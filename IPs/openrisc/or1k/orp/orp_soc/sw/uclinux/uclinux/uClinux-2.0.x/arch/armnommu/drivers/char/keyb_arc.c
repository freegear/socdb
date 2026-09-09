/*
 * linux/arch/arm/drivers/block/keyboard.c
 *
 * Keyboard driver for ARM Linux.
 */

#include <linux/config.h>
#include <linux/sched.h>
#include <linux/interrupt.h>
#include <linux/tty.h>
#include <linux/tty_flip.h>
#include <linux/mm.h>
#include <linux/malloc.h>
#include <linux/ptrace.h>
#include <linux/signal.h>
#include <linux/timer.h>
#include <linux/random.h>
#include <linux/ctype.h>

#include <asm/bitops.h>
#include <asm/irq.h>
#include <asm/hardware.h>

#include "kbd_kern.h"
#include "diacr.h"
#include "vt_kern.h"

#define IRQ_KEYBOARDRX 15
#define IRQ_KEYBOARDTX 14

extern void kbd_keyboardkey(unsigned int keycode, unsigned int up_flag);
extern void kbd_reset(void);
extern void kbd_setregs(struct pt_regs *regs);

#define VERSION 107

#define KBD_REPORT_ERR
#define KBD_REPORT_UNKN

#include <asm/io.h>
#include <asm/system.h>

static char kbd_txval;
static int kbd_id            = -1;
static struct wait_queue *kbd_waitq;

/*
 * Protocol codes to send the keyboard.
 */
#define HRST 0xff	/* reset keyboard */
#define RAK1 0xfe	/* reset response */
#define RAK2 0xfd	/* reset response */
#define BACK 0x3f	/* Ack for first keyboard pair */
#define SMAK 0x33	/* Last data byte ack (key scanning + mouse movement scanning) */
#define MACK 0x32	/* Last data byte ack (mouse movement scanning) */
#define SACK 0x31	/* Last data byte ack (key scanning) */
#define NACK 0x30	/* Last data byte ack (no scanning, mouse data) */
#define RQMP 0x22	/* Request mouse data */
#define PRST 0x21	/* nothing */
#define RQID 0x20	/* Request ID */

#define UP_FLAG 1

/*
 * This array converts the scancode that we get from the keyboard to the
 * real rows/columns on the A5000 keyboard.  This might be keyboard specific...
 *
 * It is these values that we use to maintain the key down array.  That way, we
 * should pick up on the ghost key presses (which is what happens when you press
 * three keys, and the keyboard thinks you have pressed four!)
 *
 * Row 8 (0x80+c) is actually a column with one key per row.  It is isolated from
 * the other keys, and can't cause these problems (its used for shift, ctrl, alt etc).
 *
 * Illegal scancodes are denoted by an 0xff (in other words, we don't know about
 * them, and can't process them for ghosts).  This does however, cause problems with
 * autorepeat processing...
 */
static unsigned char scancode_2_colrow[256] = {
  0x01, 0x42, 0x32, 0x33, 0x43, 0x56, 0x5a, 0x6c, 0x7c, 0x5c, 0x5b, 0x6b, 0x7b, 0x84, 0x70, 0x60,
  0x11, 0x51, 0x62, 0x63, 0x44, 0x54, 0x55, 0x45, 0x46, 0x4a, 0x3c, 0x4b, 0x59, 0x49, 0x69, 0x79,
  0x83, 0x40, 0x30, 0x3b, 0x39, 0x38, 0x31, 0x61, 0x72, 0x73, 0x64, 0x74, 0x75, 0x65, 0x66, 0x6a,
  0x1c, 0x2c, 0x7a, 0x36, 0x48, 0x68, 0x78, 0x20, 0x2b, 0x29, 0x28, 0x81, 0x71, 0x22, 0x23, 0x34,
  0x24, 0x25, 0x35, 0x26, 0x3a, 0x0c, 0x2a, 0x76, 0x10, 0x1b, 0x19, 0x18, 0x82, 0xff, 0x21, 0x12,
  0x13, 0x14, 0x04, 0x05, 0x15, 0x16, 0x1a, 0x0a, 0x85, 0x77, 0x00, 0x0b, 0x09, 0x02, 0x80, 0x03,
  0x87, 0x86, 0x06, 0x17, 0x27, 0x07, 0x37, 0x08, 0xff,
};

#define BITS_PER_SHORT (8*sizeof(unsigned short))
static unsigned short ghost_down[128/BITS_PER_SHORT];

static void kbd_drv_key(unsigned int keycode, unsigned int up_flag)
{
	unsigned int real_keycode;

	if (keycode > 0x72) {
#ifdef KBD_REPORT_UNKN
		printk ("kbd: unknown scancode 0x%04x\n", keycode);
#endif
		return;
	}
	if (keycode >= 0x70) {
#ifdef CONFIG_KBDMOUSE
		unsigned char buttons;
		switch (keycode) {
			case 0x70: /* Left mouse button */
				buttons = add_mouse_buttonchange(4, up_flag ? 4 : 0);
				break;

			case 0x71: /* Middle mouse button */
				buttons = add_mouse_buttonchange(2, up_flag ? 2 : 0);
				break;

			case 0x72:/* Right mouse button */
				buttons = add_mouse_buttonchange(1, up_flag ? 1 : 0);
				break;
			default:
				buttons = 0;
		}
		add_mouse_randomness (buttons << 16);
#endif
		return;
	}

	/*
	 * We have to work out if we accept this key press as a real key, or
	 * if it is a ghost.  IE. If you press three keys, the keyboard will think
	 * that you've pressed a fouth: (@ = key down, # = ghost)
	 *
	 *   0 1 2 3 4 5 6 7
	 *   | | | | | | | |
	 * 0-+-+-+-+-+-+-+-+-
	 *   | | | | | | | |
	 * 1-+-@-+-+-+-@-+-+-
	 *   | | | | | | | |
	 * 2-+-+-+-+-+-+-+-+-
	 *   | | | | | | | |
	 * 3-+-@-+-+-+-#-+-+-
	 *   | | | | | | | |
	 *
	 * This is what happens when you have a matrix keyboard...
	 */

	real_keycode = scancode_2_colrow[keycode];

	if ((real_keycode & 0x80) == 0) {
		int rr, kc = (real_keycode >> 4) & 7;
		int cc;
		unsigned short res, kdownkc;

		kdownkc = ghost_down[kc] | (1 << (real_keycode & 15));

		for (rr = 0; rr < 128/BITS_PER_SHORT; rr++)
			if (rr != kc && (res = ghost_down[rr] & kdownkc)) {
			    	/*
				 * we have found a second row with at least one key pressed in the
			    	 * same column.
			    	 */
			    	for (cc = 0; res; res >>= 1)
					cc += (res & 1);
				if (cc > 1)
					return; /* ignore it */
			}
		if (up_flag)
			clear_bit (real_keycode, ghost_down);
		else
			set_bit (real_keycode, ghost_down);
	}

	kbd_keyboardkey(keycode, up_flag);
}

static inline void kbd_drv_sendbyte(unsigned char val)
{
	kbd_txval = val;
	enable_irq(IRQ_KEYBOARDTX);
}

static inline void kbd_drv_reset(void)
{
	int i;

	for (i = 0; i < 128/BITS_PER_SHORT; i++)
		ghost_down[i] = 0;

	kbd_reset();
}

void kbd_drv_setleds(unsigned int leds)
{
	leds =  ((leds & (1<<VC_SCROLLOCK))?4:0) | ((leds & (1<<VC_NUMLOCK))?2:0) |
		((leds & (1<<VC_CAPSLOCK))?1:0);
	kbd_drv_sendbyte(leds);
}

/*
 * Keyboard states:
 *  0 initial reset condition, sent HRST, wait for HRST
 *  1 Send HRST, wait for HRST acknowledge
 *  2 Sent RAK1, wait for RAK1
 *  3 Sent RAK2, wait for RAK2
 *  4 Sent SMAK, wait for anything
 *  5 Wait for second keyboard nibble for key pressed
 *  6 Wait for second keyboard nibble for key released
 *  7 Wait for second part of mouse data
 */
#define KBD_INITRST	0
#define KBD_RAK1	1
#define KBD_RAK2	2
#define KBD_ID		3
#define KBD_IDLE	4
#define KBD_KEYDOWN	5
#define KBD_KEYUP	6
#define KBD_MOUSE	7

static int handle_rawcode(unsigned int keyval)
{
	static signed char kbd_mousedx = 0;
	       signed char kbd_mousedy;
	static unsigned char kbd_state = KBD_INITRST;
	static unsigned char kbd_keyhigh=0;

    switch(kbd_state) {
    case KBD_INITRST: /* hard reset - sent HRST */
	if (keyval == HRST) {
	    kbd_drv_reset ();
	    kbd_drv_sendbyte (RAK1);
	    kbd_state = KBD_RAK1;
	} else
	    goto kbd_wontreset;
	break;

    case KBD_RAK1:/* Sent RAK1 */
	switch (keyval) {
	case HRST:
	    kbd_drv_sendbyte (RAK1);
	    kbd_state = KBD_INITRST;
	    break;
	case RAK1:
	    kbd_drv_sendbyte (RAK2);
	    kbd_state = KBD_RAK2;
	    break;
	default:
	    goto kbd_wontreset;
	}
	break;

    case KBD_RAK2:/* Sent RAK2 */
	switch (keyval) {
	case HRST:
	    kbd_drv_sendbyte (HRST);
	    kbd_state = KBD_INITRST;
	    break;
	case RAK2:
	    if (kbd_id == -1) {
		kbd_drv_sendbyte (NACK);
		kbd_drv_sendbyte (RQID);
		kbd_state = KBD_ID;
	    } else {
		kbd_drv_sendbyte (SMAK);
		kbd_state = KBD_IDLE;
	    }
	    break;
	default:
	    goto kbd_wontreset;
	}
	break;

    case KBD_ID:
	if (keyval == HRST) {
	    kbd_drv_sendbyte (HRST);
	    kbd_state = KBD_INITRST;
	    kbd_id = -2;
	    wake_up(&kbd_waitq);
	    break;
	} else
	if ((keyval & 0xc0) == 0x80) {
	    kbd_id = keyval & 0x3f;
	    kbd_drv_sendbyte (SMAK);
	    kbd_state = KBD_IDLE;
	    wake_up(&kbd_waitq);
	    break;
	}
	break;

    case KBD_IDLE:/* Send SMAK, ready for any reply */
	if (keyval == HRST) {
	    kbd_drv_sendbyte (HRST);
	    kbd_state = KBD_INITRST;
	} else
	if (keyval & 0x80) {
	    if (!(keyval & 0x40)) {
	    	if (kbd_id == -1)
		    kbd_id = keyval & 0x3f;
		else {
		    kbd_state = KBD_INITRST;
		    kbd_drv_sendbyte (HRST);
		}
		break;
	    }
	    switch (keyval & 0xf0) {
	    case 0xc0:
		kbd_keyhigh = keyval;
		kbd_state   = KBD_KEYDOWN;
		kbd_drv_sendbyte (BACK);
		break;

	    case 0xd0:
		kbd_keyhigh = keyval;
		kbd_state   = KBD_KEYUP;
		kbd_drv_sendbyte (BACK);
		break;

	    default:
		kbd_state = KBD_INITRST;
		kbd_drv_sendbyte (HRST);
	    }
	} else {
	    kbd_mousedx = keyval & 0x40 ? keyval|0x80 : keyval;
	    kbd_state   = KBD_MOUSE;
	    kbd_drv_sendbyte (BACK);
	}
	break;

    case KBD_KEYDOWN:
	if ((keyval & 0xf0) != 0xc0)
	    goto kbd_error;
	else {
	    kbd_state = KBD_IDLE;
	    kbd_drv_sendbyte (SMAK);
	    if (((kbd_keyhigh ^ keyval) & 0xf0) == 0)
		kbd_drv_key ((keyval & 0x0f) | ((kbd_keyhigh << 4) & 0xf0), 0);
	    return 1;
	}
	break;

    case KBD_KEYUP:
	if ((keyval & 0xf0) != 0xd0)
	    goto kbd_error;
	else {
	    kbd_state = KBD_IDLE;
	    kbd_drv_sendbyte (SMAK);
	    if (((kbd_keyhigh ^ keyval) & 0xf0) == 0)
		kbd_drv_key ((keyval & 0x0f) | ((kbd_keyhigh << 4) & 0xf0), UP_FLAG);
	    return 1;
	}
	break;

    case KBD_MOUSE:
		if (keyval & 0x80)
			goto kbd_error;
		else {
			kbd_state = KBD_IDLE;
			kbd_drv_sendbyte (SMAK);
			kbd_mousedy = (char)(keyval & 0x40 ? keyval | 0x80 : keyval);
#ifdef CONFIG_KBDMOUSE
			add_mouse_movement((int)kbd_mousedx, (int)kbd_mousedy);
			add_mouse_randomness((kbd_mousedy << 8) + kbd_mousedx);
#endif
		}
		return 1;
	}
	return 0;

kbd_wontreset:
#ifdef KBD_REPORT_ERR
	printk ("kbd: keyboard won't reset (kbdstate %d, keyval %02X)\n",
		kbd_state, keyval);
#endif
	kbd_drv_sendbyte (HRST);
	kbd_state = KBD_INITRST;
	return 0;

kbd_error:
#ifdef KBD_REPORT_ERR
	printk ("kbd: keyboard out of sync - resetting\n");
#endif
	kbd_drv_sendbyte (HRST);
	kbd_state = KBD_INITRST;
	return 0;
}

static void kbd_drv_rx(int irq, void *dev_id, struct pt_regs *regs)
{
	if (handle_rawcode(inb(IOC_KARTRX)))
		mark_bh (KEYBOARD_BH);
	kbd_setregs(regs);
}

static void kbd_drv_tx(int irq, void *dev_id, struct pt_regs *regs)
{
	outb (kbd_txval, IOC_KARTTX);
}

int kbd_drv_init (void)
{
	unsigned long flags;

	save_flags_cli (flags);
	if (request_irq (IRQ_KEYBOARDRX, kbd_drv_rx, 0, "keyboard", NULL) != 0)
		panic("Could not allocate keyboard receive IRQ!");
	if (request_irq (IRQ_KEYBOARDTX, kbd_drv_tx, 0, "keyboard", NULL) != 0)
		panic("Could not allocate keyboard transmit IRQ!");
	disable_irq (IRQ_KEYBOARDTX);
	(void)inb(IOC_KARTRX);
	restore_flags (flags);

	kbd_drv_sendbyte (HRST);

	current->timeout = jiffies + HZ; /* wait 1s for keyboard to initialise */
	interruptible_sleep_on(&kbd_waitq);

	printk (KERN_INFO "Keyboard driver v%d.%02d. (", VERSION/100, VERSION%100);
	if (kbd_id != -1)
	      printk ("id=%d ", kbd_id);
	printk ("English)\n");
	return 0;
}
