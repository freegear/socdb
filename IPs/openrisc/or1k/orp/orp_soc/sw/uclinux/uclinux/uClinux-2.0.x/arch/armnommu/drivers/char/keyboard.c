/*
 * linux/arch/arm/drivers/block/keyboard.c
 *
 * Keyboard driver for Linux using Latin-1.
 *
 * Written for linux by Johan Myreen as a translation from
 * the assembly version by Linus (with diacriticals added)
 *
 * Some additional features added by Christoph Niemann (ChN), March 1993
 *
 * Loadable keymaps by Risto Kankkunen, May 1993
 *
 * Diacriticals redone & other small changes, aeb@cwi.nl, June 1993
 * Added decr/incr_console, dynamic keymaps, Unicode support,
 * dynamic function/string keys, led setting,  Sept 1994
 * `Sticky' modifier keys, 951006.
 *
 * Majorly altered for use with arm Russell King (rmk@ecs.soton.ac.uk)
 *  The low-level keyboard driver is now separate.
 *  Interfaces:
 *    Driver supplies:
 *	kbd_drv_init	- initialise keyboard driver proper
 *	kbd_drv_setleds	- set leds on keyboard
 *    Driver uses:
 *	kbd_keyboardkey	- process a keypress/release
 *	kbd_reset	- reset keyboard down array
 *	kbd_setregs	- set regs for scroll-lock debug
 */

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
#include <asm/system.h>
#include <asm/irq.h>
#include <asm/segment.h>

#include "kbd_kern.h"
#include "diacr.h"
#include "vt_kern.h"

#define SIZE(x) (sizeof(x)/sizeof((x)[0]))

#define KBD_REPORT_ERR
#define KBD_REPORT_UNKN

#ifndef KBD_DEFMODE
#define KBD_DEFMODE ((1 << VC_REPEAT) | (1 << VC_META))
#endif

/*
 * Starts with NumLock off.
 */
#ifndef KBD_DEFLEDS
#define KBD_DEFLEDS 0
#endif

#ifndef KBD_DEFLOCK
#define KBD_DEFLOCK 0
#endif

#define REPEAT_TIMEOUT HZ*300/1000
#define REPEAT_RATE    HZ*30/1000

extern void ctrl_alt_del (void);
extern void scrollback(int);
extern void scrollfront(int);
extern int kbd_drv_init(void);
extern void kbd_drv_setleds(unsigned int leds);
extern unsigned int keymap_count;

/*
 * these are the valid i/o ports we're allowed to change. they map all the
 * video ports
 */
#define GPFIRST 0x3b4
#define GPLAST 0x3df
#define GPNUM (GPLAST - GPFIRST + 1)

/*
 * global state includes the following, and various static variables
 * in this module: shift_state, diacr, npadch, dead_key_next.
 * (last_console is now a global variable)
 */

/* shift state counters.. */
static unsigned char k_down[NR_SHIFT] = {0, };
/* keyboard key bitmap */
#define BITS_PER_LONG (8*sizeof (unsigned long))
static unsigned long key_down[256/BITS_PER_LONG] = {0, };
static int dead_key_next;

/*
 * In order to retrieve the shift_state (for the mouse server), either
 * the variable must be global, or a new procedure must be created to
 * return the value. I chose the former way.
 */
/*static*/ int shift_state;
static int npadch            = -1;		/* -1 or number assembled on pad */
static unsigned char diacr;
static char rep;				/* Flag telling character repeat */
static int kbd_repeatkey     = -1;
static int kbd_repeattimeout = REPEAT_TIMEOUT;
static int kbd_repeatrate    = REPEAT_RATE;

static struct kbd_struct * kbd;
static struct tty_struct * tty;

extern void compute_shiftstate (void);

typedef void (*k_hand)(unsigned char value, char up_flag);
typedef void (k_handfn)(unsigned char value, char up_flag);

static k_handfn
	do_self, do_fn, do_spec, do_pad, do_dead, do_cons, do_cur, do_shift,
	do_meta, do_ascii, do_lock, do_lowercase, do_slock, do_ignore;

static k_hand key_handler[16] = {
	do_self, do_fn, do_spec, do_pad, do_dead, do_cons, do_cur, do_shift,
	do_meta, do_ascii, do_lock, do_lowercase, do_slock,
	do_ignore, do_ignore, do_ignore
};

typedef void (*void_fnp)(void);
typedef void (void_fn)(void);

static void_fn do_null, enter, show_ptregs, send_intr, lastcons, caps_toggle,
	num, hold, scroll_forw, scroll_back, boot_it, caps_on, compose,
	SAK, decr_console, incr_console, spawn_console, show_stack, bare_num;

static void_fnp spec_fn_table[] = {
	do_null,	enter,		show_ptregs,	show_mem,
	show_state,	send_intr,	lastcons,	caps_toggle,
	num,		hold,		scroll_forw,	scroll_back,
	boot_it,	caps_on,	compose,	SAK,
	decr_console,	incr_console,	show_stack,     bare_num
};

/* maximum values each key_handler can handle */
const int max_vals[] = {
	255, SIZE(func_table) - 1, SIZE(spec_fn_table) - 1, NR_PAD - 1,
	NR_DEAD - 1, 255, 3, NR_SHIFT - 1,
	255, NR_ASCII - 1, NR_LOCK - 1, 255,
	NR_LOCK - 1
};

const int NR_TYPES = SIZE(max_vals);

static void put_queue(int);
static unsigned char handle_diacr(unsigned char);

/* pt_regs - set by keyboard_interrupt(), used by show_ptregs() */
static struct pt_regs * pt_regs;

/*
 * Many other routines do put_queue, but I think either
 * they produce ASCII, or they produce some user-assigned
 * string, and in both cases we might assume that it is
 * in utf-8 already.
 */
void to_utf8(ushort c)
{
	if (c < 0x80)
		put_queue(c);			/*  0*******  */
	else if (c < 0x800) {
		put_queue(0xc0 | (c >> 6)); 	/*  110***** 10******  */
		put_queue(0x80 | (c & 0x3f));
	} else {
		put_queue(0xe0 | (c >> 12)); 	/*  1110**** 10****** 10******  */
		put_queue(0x80 | ((c >> 6) & 0x3f));
		put_queue(0x80 | (c & 0x3f));
	}
	/* UTF-8 is defined for words of up to 31 bits,
	   but we need only 16 bits here */
}

/*
 * As yet, we don't support setting and getting the
 * key codes.  I'll have to find out where this is used.
 */
int setkeycode(unsigned int scancode, unsigned int keycode)
{
	return -EINVAL;
}

int getkeycode(unsigned int scancode)
{
	return -EINVAL;
}

static void key_callback(unsigned long nr)
{
	rep = 1;
	mark_bh (KEYBOARD_BH);
}

static struct timer_list key_timer =
{
	NULL, NULL, 0, 0, key_callback
};

void kbd_reset(void)
{
	int i;

	for (i = 0; i < NR_SHIFT; i++)
		k_down[i] = 0;
	for (i = 0; i < 256/BITS_PER_LONG; i++)
		key_down[i] = 0;
	shift_state = 0;
}

void kbd_setregs(struct pt_regs *regs)
{
	pt_regs = regs;
}

static void kbd_processkey(unsigned int keycode, unsigned int up_flag, unsigned int autorepeat)
{
	del_timer(&key_timer);
	show_console();
	add_keyboard_randomness (keycode|(up_flag?0x100:0));

	tty = *vtdata.fgconsole->tty;
	kbd = vtdata.fgconsole->kbd;

	if (up_flag) {
	    	rep = 0;
		clear_bit (keycode, key_down);
		/* don't report an error if key is already up - happens when a ghost key is released */
	} else
		rep = set_bit (keycode, key_down);

	if (rep && !autorepeat)
		return;

	if (kbd->kbdmode == VC_RAW || kbd->kbdmode == VC_MEDIUMRAW) {
		put_queue(keycode + (up_flag ? 0x80 : 0));
		return;
	}

	/*
	 * We have to do our own auto-repeat processing...
	 */
	if (!up_flag) {
    		kbd_repeatkey = keycode;
		if (vc_kbd_mode(kbd, VC_REPEAT)) {
			if (rep)
				key_timer.expires = jiffies + kbd_repeatrate;
			else
				key_timer.expires = jiffies + kbd_repeattimeout;
			add_timer(&key_timer);
		}
	} else
		kbd_repeatkey = -1;

	/*
	 * Repeat a key only if the input buffers are empty or the
	 * characters get echoed locally.  This makes key repeat usable
	 * with slow applications and under heavy loads.
	 */
	if (!rep ||
	    (vc_kbd_mode (kbd, VC_REPEAT) && tty &&
             (L_ECHO(tty) || (tty->driver.chars_in_buffer (tty) == 0)))) {
		u_short keysym;
		u_char  type;

		/* the XOR below used to be an OR */
		int     shift_final = shift_state ^ kbd->lockstate ^ kbd->slockstate;
		u_short *key_map = key_maps[shift_final];

		if (key_map != NULL) {
			keysym = key_map[keycode];
			type   = KTYP(keysym);

			if (type >= 0xf0) {
				type -= 0xf0;
				if (type == KT_LETTER) {
					type = KT_LATIN;
					if (vc_kbd_led(kbd, VC_CAPSLOCK)) {
						key_map = key_maps[shift_final ^ (1<<KG_SHIFT)];
						if (key_map)
							keysym = key_map[keycode];
					}
				}
				(*key_handler[type])(keysym & 0xff, up_flag);
				if (type != KT_SLOCK)
					kbd->slockstate = 0;
			} else {
				/* maybe only if (kbd->kbdmode == VC_UNICODE) ? */
				if (!up_flag)
					to_utf8(keysym);
			}
		} else {
			/*
			 * maybe beep?
			 * we have at least to update shift_state
			 * how? two almost equivalent choices follow
			 */
#if 1
			compute_shiftstate ();
#else
			keysym = U(plain_map[keycode]);
			type   = KTYP(keysym);
			if (type == KT_SHIFT)
				(*key_handler[type]) (keysym & 0xff, up_flag);
#endif
		}
	}
}

void kbd_keyboardkey(unsigned int keycode, unsigned int up_flag)
{
	kbd_processkey(keycode, up_flag, 0);
}

static void put_queue (int ch)
{
        wake_up (&keypress_wait);
        if (tty) {
                tty_insert_flip_char (tty, ch, 0);
                tty_schedule_flip (tty);
        }
}

static void puts_queue(char *cp)
{
        wake_up (&keypress_wait);
        if (!tty)
                return;

        while (*cp) {
                tty_insert_flip_char (tty, *cp, 0);
                cp++;
        }
        tty_schedule_flip (tty);
}

static void show_stack (void)
{
        unsigned long *p;
        unsigned long *q = (unsigned long *)((int)current->kernel_stack_page + 4096);
        int i;
        __asm__("mov %0, sp\n\t": "=r" (p));

        for (i = 0; p < q; p++, i++) {
                if(i && !(i & 7))
                        printk("\n");
                printk("%08lX ", *p);
        }
}

static void applkey(int key, char mode)
{
        static char buf[] = { 0x1b, 'O', 0x00, 0x00};

        buf[1] = (mode ? 'O' : '[');
        buf[2] = key;
        puts_queue(buf);
}

static void enter(void)
{
        put_queue (13);
        if (vc_kbd_mode(kbd, VC_CRLF))
                put_queue (10);
}

static void caps_toggle(void)
{
        if(rep)
                return;
        chg_vc_kbd_led(kbd, VC_CAPSLOCK);
}

static void caps_on (void)
{
        if (rep)
                return;
        set_vc_kbd_led (kbd, VC_CAPSLOCK);
}

static void show_ptregs (void)
{
        if (pt_regs)
                show_regs (pt_regs);
}

static void hold (void)
{
        if(rep || !tty)
                return;

        /*
         * Note: SCROLLOCK will be set (cleared) by stop_tty (start_tty);
         * these routines are also activated by ^S/^Q.
         * (And SCROLLOCK can also be set by the ioctl KDSKBLED.)
         */
        if (tty->stopped)
                start_tty (tty);
        else
                stop_tty (tty);
}

static void num (void)
{
        if(vc_kbd_mode(kbd,VC_APPLIC))
                applkey('P', 1);
        else
                bare_num ();
}

/*
 * Bind this to Shift-NumLock if you work in application keypad mode
 * but want to be able to change the NumLock flag.
 * Bind this to NumLock if you prefer that the NumLock key always
 * changes the NumLock flag.
 */
static void bare_num (void)
{
        if (!rep)
                chg_vc_kbd_led (kbd, VC_NUMLOCK);
}

static void lastcons (void)
{
        /* switch to the last used console, ChN */
        set_console(last_console);
}

static void decr_console (void)
{
        int i;
        int fgnum = vtdata.fgconsole->num - 1;

        for (i = fgnum - 1; i != fgnum; i--) {
                if (i == -1)
                        i = MAX_NR_CONSOLES - 1;
                if (vt_allocated (vt_con_data + i))
                        break;
        }
        set_console(vt_con_data + i);
}

static void incr_console (void)
{
        int i;
        int fgnum = vtdata.fgconsole->num - 1;

        for (i = fgnum + 1; i != fgnum; i++) {
                if (i == MAX_NR_CONSOLES)
                        i = 0;
                if (vt_allocated (vt_con_data + i))
                        break;
        }
        set_console(vt_con_data + i);
}

static void send_intr (void)
{
        if (!tty)
                return;
        tty_insert_flip_char (tty, 0, TTY_BREAK);
        tty_schedule_flip (tty);
}

static void scroll_forw (void)
{
        scrollfront(0);
}

static void scroll_back (void)
{
        scrollback(0);
}

static void boot_it (void)
{
        ctrl_alt_del();
}

static void compose (void)
{
        dead_key_next = 1;
}

int spawnpid, spawnsig;

static void spawn_console (void)
{
        if (spawnpid)
                if (kill_proc (spawnpid, spawnsig, 1))
                        spawnpid = 0;
}

static void SAK (void)
{
        do_SAK(tty);
#if 0
        /*
         * Need to fix SAK handling to fix up RAW/MEDIUM_RAW and
         * vt_cons modes before we can enable RAW/MEDIUM_RAW SAK
         * handling.
         *
         * We should do this some day --- the whole point of a secure
         * attention key is that it should be guaranteed to always
         * work.
         */
        vt_reset (vtdata.fgconsole);
        do_unblank_screen ();   /* not in interrupt routine? */
#endif
}

static void do_ignore (unsigned char value, char up_flag)
{
}

static void do_null (void)
{
        compute_shiftstate ();
}

static void do_spec (unsigned char value,char up_flag)
{
        if (up_flag)
                return;
        if (value >= SIZE(spec_fn_table))
                return;
        spec_fn_table[value] ();
}

static void do_lowercase (unsigned char value, char up_flag)
{
        printk(KERN_ERR "keyboard.c: do_lowercase was called - impossible\n");
}

static void do_self(unsigned char value, char up_flag)
{
        if (up_flag)
                return;         /* no action, if this is a key release */

        if (diacr)
                value = handle_diacr (value);

        if (dead_key_next) {
                dead_key_next = 0;
                diacr = value;
                return;
        }

        put_queue (value);
}

#define A_GRAVE '`'
#define A_ACUTE '\''
#define A_CFLEX '^'
#define A_TILDE '~'
#define A_DIAER '"'
#define A_CEDIL ','
static unsigned char ret_diacr[] =
        {A_GRAVE, A_ACUTE, A_CFLEX, A_TILDE, A_DIAER, A_CEDIL };

/* If a dead key pressed twice, output a character corresponding to it, */
/* otherwise just remember the dead key.                                */

static void do_dead(unsigned char value, char up_flag)
{
        if (up_flag)
                return;

        value = ret_diacr[value];
        if (diacr == value) { /* pressed twice */
                diacr = 0;
                put_queue (value);
                return;
        }
        diacr = value;
}


/* If space is pressed, return the character corresponding the pending  */
/* dead key, otherwise try to combine the two.                          */

static unsigned char handle_diacr(unsigned char ch)
{
        int d = diacr;
        int i;

        diacr = 0;
        if (ch == ' ')
                return d;

        for (i = 0; i < accent_table_size; i++) {
                if (accent_table[i].diacr == d && accent_table[i].base == ch)
                    return accent_table[i].result;
        }

        put_queue (d);
        return ch;
}

static void do_cons(unsigned char value, char up_flag)
{
        if (up_flag)
                return;
        set_console(vt_con_data + value);
}

static void do_fn(unsigned char value, char up_flag)
{
        if (up_flag)
                return;
        if (value < SIZE(func_table)) {
                if (func_table[value])
                        puts_queue (func_table[value]);
        } else
                printk (KERN_ERR "do_fn called with value=%d\n",value);
}

static void do_pad(unsigned char value, char up_flag)
{
	static const char *pad_chars = "0123456789+-*/\015,.?#";
	static const char *app_map = "pqrstuvwxylmRQMnn?S";

	if (up_flag)
		return; 	/* no action, if this is a key release */

	/* kludge... shift forces cursor/number keys */
	if (vc_kbd_mode (kbd, VC_APPLIC) && !k_down[KG_SHIFT]) {
		applkey (app_map[value], 1);
		return;
	}

	if (!vc_kbd_led (kbd,VC_NUMLOCK))
		switch (value) {
			case KVAL(K_PCOMMA):
			case KVAL(K_PDOT):
				do_fn (KVAL(K_REMOVE), 0);
				return;
			case KVAL(K_P0):
				do_fn (KVAL(K_INSERT), 0);
				return;
			case KVAL(K_P1):
				do_fn (KVAL(K_SELECT), 0);
				return;
			case KVAL(K_P2):
				do_cur(KVAL(K_DOWN), 0);
				return;
			case KVAL(K_P3):
				do_fn (KVAL(K_PGDN), 0);
				return;
			case KVAL(K_P4):
				do_cur(KVAL(K_LEFT), 0);
				return;
			case KVAL(K_P6):
				do_cur(KVAL(K_RIGHT), 0);
				return;
			case KVAL(K_P7):
				do_fn (KVAL(K_FIND), 0);
				return;
			case KVAL(K_P8):
				do_cur(KVAL(K_UP), 0);
				return;
			case KVAL(K_P9):
				do_fn (KVAL(K_PGUP), 0);
				return;
			case KVAL(K_P5):
				applkey('G',vc_kbd_mode(kbd, VC_APPLIC));
				return;
	}

	put_queue (pad_chars[value]);
	if (value == KVAL(K_PENTER) && vc_kbd_mode (kbd, VC_CRLF))
		put_queue (10);
}

static void do_cur(unsigned char value, char up_flag)
{
	static const char *cur_chars = "BDCA";
	if (up_flag)
		return;

	applkey (cur_chars[value], vc_kbd_mode(kbd, VC_CKMODE));
}

static void do_shift(unsigned char value, char up_flag)
{
    int old_state = shift_state;

    if (rep)
	return;

    /* Mimic typewriter: a CapsShift key acts like Shift but undoes CapsLock */
    if (value == KVAL(K_CAPSSHIFT)) {
	value = KVAL(K_SHIFT);
	if (!up_flag)
	    clr_vc_kbd_led (kbd, VC_CAPSLOCK);
    }

    if(up_flag) {
	/* handle the case that two shift or control
	   keys are depressed simultaneously */
	if(k_down[value])
	    k_down[value]--;
    } else
	k_down[value]++;

    if(k_down[value])
	shift_state |= (1 << value);
    else
	shift_state &= ~ (1 << value);

    /* kludge */
    if(up_flag && shift_state != old_state && npadch != -1) {
	if(kbd->kbdmode == VC_UNICODE)
	    to_utf8(npadch & 0xffff);
	else
	    put_queue(npadch & 0xff);
	npadch = -1;
    }
}

/*
 * Called after returning from RAW mode or when changing consoles -
 * recompute k_down[] and shift_state from key_down[]
 * Maybe called when keymap is undefined so that shift key release is seen
 */
void compute_shiftstate(void)
{
	int i, j, k, sym, val;

	shift_state = 0;
	for (i = 0; i < SIZE(k_down); i++)
		k_down[i] = 0;

	for (i = 0; i < SIZE(key_down); i++)
		if (key_down[i]) {	/* skip this word if not a single bit on */
			k = i * BITS_PER_LONG;
			for (j = 0; j < BITS_PER_LONG; j++, k++)
				if (test_bit (k, key_down)) {
					sym = U(plain_map[k]);
					if (KTYP(sym) == KT_SHIFT) {
						val = KVAL (sym);
						if (val == KVAL(K_CAPSSHIFT))
							val = KVAL(K_SHIFT);
						k_down[val] ++;
						shift_state |= (1 << val);
		    			}
				}
		}
}

static void do_meta(unsigned char value, char up_flag)
{
	if(up_flag)
		return;

	if(vc_kbd_mode(kbd, VC_META)) {
		put_queue ('\033');
		put_queue (value);
	} else
		put_queue (value | 0x80);
}

static void do_ascii(unsigned char value, char up_flag)
{
	int base;

	if (up_flag)
		return;

	if (value < 10)	/* decimal input of code, while Alt depressed */
		base = 10;
	else {		/* hexadecimal input of code, while AltGr depressed */
		value -= 10;
		base = 16;
	}

	if(npadch == -1)
		npadch = value;
	else
		npadch = npadch * base + value;
}

static void do_lock (unsigned char value, char up_flag)
{
    if (up_flag || rep)
	return;
    chg_vc_kbd_lock (kbd, value);
}

static void do_slock (unsigned char value, char up_flag)
{
    if (up_flag || rep)
	return;
    chg_vc_kbd_slock (kbd, value);
}

/*
 * The leds display either
 * (i)   The status of NumLock, CapsLock and ScrollLock.
 * (ii)  Whatever pattern of lights people wait to show using KDSETLED.
 * (iii) Specified bits of specified words in kernel memory.
 */

static unsigned char ledstate = 0xff; /* undefined */
static unsigned char ledioctl;

unsigned char getledstate(void)
{
    return ledstate;
}

void setledstate(struct kbd_struct *kbd, unsigned int led)
{
    if(!(led & ~7)) {
	ledioctl = led;
	kbd->ledmode = LED_SHOW_IOCTL;
    } else
	kbd->ledmode = LED_SHOW_FLAGS;
    set_leds();
}

static struct ledptr {
    unsigned int *addr;
    unsigned int mask;
    unsigned char valid:1;
} ledptrs[3];

void register_leds(int console, unsigned int led,
		  unsigned int *addr, unsigned int mask)
{
    struct kbd_struct *kbd = vt_con_data[console].kbd;
    if(led < 3) {
	ledptrs[led].addr = addr;
	ledptrs[led].mask = mask;
	ledptrs[led].valid= 1;
	kbd->ledmode = LED_SHOW_MEM;
    } else
	kbd->ledmode = LED_SHOW_FLAGS;
}

static inline unsigned char getleds(void)
{
    struct kbd_struct *kbd = vtdata.fgconsole->kbd;
    unsigned char leds;

    if(kbd->ledmode == LED_SHOW_IOCTL)
	return ledioctl;
    leds = kbd->ledflagstate;
    if (kbd->ledmode == LED_SHOW_MEM) {
	if (ledptrs[0].valid) {
	    if (*ledptrs[0].addr & ledptrs[0].mask)
		leds |= 1;
	    else
		leds &= ~1;
        }
	if (ledptrs[1].valid) {
	    if (*ledptrs[1].addr & ledptrs[1].mask)
		leds |= 2;
	    else
		leds &= ~2;
        }
	if (ledptrs[2].valid) {
	    if(*ledptrs[2].addr & ledptrs[2].mask)
		leds |= 4;
	    else
		leds &= ~4;
        }
    }
    return leds;
}

/*
 * This routine is the bottom half of the keyboard interrupt
 * routine, and runs with all interrupts enabled.  It does
 * console changing, led setting and copy_to_cooked, which can
 * take a reasonably long time.
 *
 * Aside from timing (which isn't really that important for
 * keyboard interrupts as they happen often), using the software
 * interrupt routines for this thing allows us to easily mask
 * this when we don't want any of the above to happen.  Not yet
 * used, but this allows for easy and efficient race-condition
 * prevention later on.
 */
static void kbd_bh(void)
{
	unsigned char leds = getleds();

	tty = *vtdata.fgconsole->tty;
	kbd = vtdata.fgconsole->kbd;

	if (rep) {
		/*
		 * This prevents the kbd_key routine from being called
		 * twice, once by this BH, and once by the interrupt
		 * routine.  Maybe we should put the key press in a
		 * buffer or variable, and then call the BH...
		 */
		disable_irq (IRQ_KEYBOARDRX);
		if (kbd_repeatkey != -1)
			kbd_processkey (kbd_repeatkey, 0, 1);
		enable_irq (IRQ_KEYBOARDRX);
		rep = 0;
	}

	if (leds != ledstate) {
		ledstate = leds;
		kbd_drv_setleds(leds);
	}
}

/*
 * Initialise a kbd struct
 */
int kbd_struct_init (struct vt *vt, int init)
{
	vt->kbd->ledflagstate = vt->kbd->default_ledflagstate = KBD_DEFLEDS;
	vt->kbd->ledmode = LED_SHOW_FLAGS;
	vt->kbd->lockstate = KBD_DEFLOCK;
	vt->kbd->slockstate = 0;
	vt->kbd->modeflags = KBD_DEFMODE;
	vt->kbd->kbdmode = VC_XLATE;
	return 0;
}

int kbd_ioctl (struct vt *vt, int cmd, unsigned long arg)
{
    asmlinkage int sys_ioperm(unsigned long from, unsigned long num, int on);
    int i;

    switch (cmd) {
    case KDGKBTYPE:
	/*
	 * This is naive.
	 */
	i = verify_area (VERIFY_WRITE, (void *)arg, sizeof (unsigned char));
	if (!i)
	    put_user (KB_101, (char *)arg);
	return i;

    case KDADDIO:
    case KDDELIO:
	/*
	 * KDADDIO and KDDELIO may be able to add ports beyond what
	 * we reject here, but to be safe...
	 */
	if (arg < GPFIRST || arg > GPLAST)
	    return -EINVAL;
	return sys_ioperm (arg, 1, (cmd == KDADDIO)) ? -ENXIO : 0;

    case KDENABIO:
    case KDDISABIO:
	return sys_ioperm (GPFIRST, GPLAST, (cmd == KDENABIO)) ? -ENXIO : 0;

    case KDMAPDISP:
    case KDUNMAPDISP:
	/*
	 * These work like a combination of mmap and KDENABIO.
	 * this could easily be finished.
	 */
	return -EINVAL;

    case KDSKBMODE:
	switch (arg) {
	case K_RAW:
	    vt->kbd->kbdmode = VC_RAW;
	    break;
	case K_MEDIUMRAW:
	    vt->kbd->kbdmode = VC_MEDIUMRAW;
	    break;
	case K_XLATE:
	    vt->kbd->kbdmode = VC_XLATE;
	    compute_shiftstate ();
	    break;
	case K_UNICODE:
	    vt->kbd->kbdmode = VC_UNICODE;
	    compute_shiftstate ();
	    break;
	default:
	    return -EINVAL;
	}
	if (tty->ldisc.flush_buffer)
	    tty->ldisc.flush_buffer (*vt->tty);
	return 0;

    case KDGKBMODE:
	i = verify_area (VERIFY_WRITE, (void *)arg, sizeof (unsigned long));
	if (!i) {
	    int ucval;
	    ucval = ((vt->kbd->kbdmode == VC_RAW) ? K_RAW :
		     (vt->kbd->kbdmode == VC_MEDIUMRAW) ? K_MEDIUMRAW :
		     (vt->kbd->kbdmode == VC_UNICODE) ? K_UNICODE : K_XLATE);
	    put_user (ucval, (int *)arg);
	}
	return i;

    case KDSKBMETA:
	/*
	 * this could be folded into KDSKBMODE, but for compatibility
	 * reasons, it is not so easy to fold kDGKBMETA into KDGKBMODE.
	 */
	switch (arg) {
	case K_METABIT:
	    clr_vc_kbd_mode (vt->kbd, VC_META);
	    break;
	case K_ESCPREFIX:
	    set_vc_kbd_mode (vt->kbd, VC_META);
	    break;
	default:
	    return -EINVAL;
	}
	return 0;

    case KDGKBMETA:
	i = verify_area (VERIFY_WRITE, (void *)arg, sizeof (unsigned long));
	if (!i) {
	    int ucval;
	    ucval = (vc_kbd_mode (vt->kbd, VC_META) ? K_ESCPREFIX : K_METABIT);
	    put_user (ucval, (int *)arg);
	}
	return i;

    case KDGETKEYCODE: {
	struct kbkeycode *const a = (struct kbkeycode *)arg;

	i = verify_area (VERIFY_WRITE, a, sizeof (struct kbkeycode));
	if (!i) {
	    unsigned int sc;

	    sc = get_user (&a->scancode);
	    i = getkeycode (sc);
	    if (i > 0)
		put_user (i, &a->keycode);
	    i = 0;
	}
	return i;
        }

    case KDSETKEYCODE: {
	struct kbkeycode *const a = (struct kbkeycode *)arg;

	i = verify_area (VERIFY_READ, a, sizeof (struct kbkeycode));
	if (!i) {
	    unsigned int sc, kc;
	    sc = get_user (&a->scancode);
	    kc = get_user (&a->keycode);
	    i = setkeycode (sc, kc);
	}
	return i;
        }

    case KDGKBENT: {
	struct kbentry *const a = (struct kbentry *)arg;

	i = verify_area (VERIFY_WRITE, a, sizeof (struct kbentry));
	if (!i) {
	    ushort *keymap, val;
	    u_char s;
	    i = get_user (&a->kb_index);
	    if (i >= NR_KEYS)
		return -EINVAL;
	    s = get_user (&a->kb_table);
	    if (s >= MAX_NR_KEYMAPS)
		return -EINVAL;
	    keymap = key_maps[s];
	    if (keymap) {
		val = U(keymap[i]);
		if (vt->kbd->kbdmode != VC_UNICODE && KTYP(val) >= NR_TYPES)
		    val = K_HOLE;
	    } else
		val = (i ? K_HOLE : K_NOSUCHMAP);
	    put_user (val, &a->kb_value);
	    i = 0;
	}
	return i;
        }

    case KDSKBENT: {
	struct kbentry *const a = (struct kbentry *)arg;

	i = verify_area (VERIFY_WRITE, a, sizeof (struct kbentry));
	if (!i) {
	    ushort *key_map;
	    u_char s;
	    u_short v, ov;

	    if ((i = get_user(&a->kb_index)) >= NR_KEYS)
		return -EINVAL;
	    if ((s = get_user(&a->kb_table)) >= MAX_NR_KEYMAPS)
		return -EINVAL;
	    v = get_user(&a->kb_value);
	    if (!i && v == K_NOSUCHMAP) {
		/* disallocate map */
		key_map = key_maps[s];
		if (s && key_map) {
		    key_maps[s] = 0;
		    if (key_map[0] == U(K_ALLOCATED)) {
			kfree_s(key_map, sizeof(plain_map));
			keymap_count--;
		    }
		}
		return 0;
	    }

	    if (KTYP(v) < NR_TYPES) {
		if (KVAL(v) > max_vals[KTYP(v)])
		    return -EINVAL;
	    } else
		if (kbd->kbdmode != VC_UNICODE)
		    return -EINVAL;

	    /* assignment to entry 0 only tests validity of args */
	    if (!i)
		return 0;

	    if (!(key_map = key_maps[s])) {
		int j;
			
		if (keymap_count >= MAX_NR_OF_USER_KEYMAPS && !suser())
		    return -EPERM;

		key_map = (ushort *) kmalloc(sizeof(plain_map),
					     GFP_KERNEL);
		if (!key_map)
		    return -ENOMEM;
		key_maps[s] = key_map;
		key_map[0] = U(K_ALLOCATED);
		for (j = 1; j < NR_KEYS; j++)
		    key_map[j] = U(K_HOLE);
		keymap_count++;
	    }
	    ov = U(key_map[i]);
	    if (v == ov)
		return 0;	/* nothing to do */
	    /*
	     * Only the Superuser can set or unset the Secure
	     * Attention Key.
	     */
	    if (((ov == K_SAK) || (v == K_SAK)) && !suser())
		return -EPERM;
	    key_map[i] = U(v);
	    if (!s && (KTYP(ov) == KT_SHIFT || KTYP(v) == KT_SHIFT))
		compute_shiftstate();
	    return 0;
	}
	return i;
        }

    case KDGKBSENT: {
	struct kbsentry *a = (struct kbsentry *)arg;
	char *p;
	u_char *q;
	int sz;

	i = verify_area(VERIFY_WRITE, (void *)a, sizeof(struct kbsentry));
	if (i)
	    return i;
	if ((i = get_user(&a->kb_func)) >= MAX_NR_FUNC || i < 0)
	    return -EINVAL;
	sz = sizeof(a->kb_string) - 1; /* sz should have been
					  a struct member */
	q = a->kb_string;
	p = func_table[i];
	if(p)
	    for ( ; *p && sz; p++, sz--)
		put_user(*p, q++);
	put_user('\0', q);
	return ((p && *p) ? -EOVERFLOW : 0);
        }

    case KDSKBSENT: {
	struct kbsentry * const a = (struct kbsentry *)arg;
	int delta;
	char *first_free, *fj, *fnw;
	int j, k, sz;
	u_char *p;
	char *q;

	i = verify_area(VERIFY_READ, (void *)a, sizeof(struct kbsentry));
	if (i)
	    return i;
	if ((i = get_user(&a->kb_func)) >= MAX_NR_FUNC)
	    return -EINVAL;
	q = func_table[i];

	first_free = funcbufptr + (funcbufsize - funcbufleft);
	for (j = i+1; j < MAX_NR_FUNC && !func_table[j]; j++) ;
	if (j < MAX_NR_FUNC)
	    fj = func_table[j];
	else
	    fj = first_free;

	delta = (q ? -strlen(q) : 1);
	sz = sizeof(a->kb_string); 	/* sz should have been
					   a struct member */
	for (p = a->kb_string; get_user(p) && sz; p++,sz--)
	    delta++;
	if (!sz)
	    return -EOVERFLOW;
	if (delta <= funcbufleft) { 	/* it fits in current buf */
	    if (j < MAX_NR_FUNC) {
		memmove(fj + delta, fj, first_free - fj);
		for (k = j; k < MAX_NR_FUNC; k++)
		    if (func_table[k])
			func_table[k] += delta;
	    }
	    if (!q)
		func_table[i] = fj;
	    funcbufleft -= delta;
	} else {			/* allocate a larger buffer */
	    sz = 256;
	    while (sz < funcbufsize - funcbufleft + delta)
		sz <<= 1;
	    fnw = (char *) kmalloc(sz, GFP_KERNEL);
	    if(!fnw)
		return -ENOMEM;

	    if (!q)
		func_table[i] = fj;
	    if (fj > funcbufptr)
		memmove(fnw, funcbufptr, fj - funcbufptr);
	    for (k = 0; k < j; k++)
		if (func_table[k])
		    func_table[k] = fnw + (func_table[k] - funcbufptr);

	    if (first_free > fj) {
		memmove(fnw + (fj - funcbufptr) + delta, fj, first_free - fj);
		for (k = j; k < MAX_NR_FUNC; k++)
		    if (func_table[k])
			func_table[k] = fnw + (func_table[k] - funcbufptr) + delta;
	    }
	    if (funcbufptr != func_buf)
		kfree_s(funcbufptr, funcbufsize);
	    funcbufptr = fnw;
	    funcbufleft = funcbufleft - delta + sz - funcbufsize;
	    funcbufsize = sz;
	}
	for (p = a->kb_string, q = func_table[i]; ; p++, q++)
	    if (!(*q = get_user(p)))
		break;
	return 0;
	}

    case KDGKBDIACR: {
	struct kbdiacrs *a = (struct kbdiacrs *)arg;

	i = verify_area(VERIFY_WRITE, (void *) a, sizeof(struct kbdiacrs));
	if (i)
	    return i;
	put_user(accent_table_size, &a->kb_cnt);
	memcpy_tofs(a->kbdiacr, accent_table,
		    accent_table_size*sizeof(struct kbdiacr));
	return 0;
	}

    case KDSKBDIACR: {
	struct kbdiacrs *a = (struct kbdiacrs *)arg;
	unsigned int ct;

	i = verify_area(VERIFY_READ, (void *) a, sizeof(struct kbdiacrs));
	if (i)
	    return i;
	ct = get_user(&a->kb_cnt);
	if (ct >= MAX_DIACR)
	    return -EINVAL;
	accent_table_size = ct;
	memcpy_fromfs(accent_table, a->kbdiacr, ct*sizeof(struct kbdiacr));
	return 0;
	}

    /* the ioctls below read/set the flags usually shown in the leds */
    /* don't use them - they will go away without warning */
    case KDGKBLED:
	i = verify_area(VERIFY_WRITE, (void *) arg, sizeof(unsigned char));
	if (i)
	    return i;
	put_user(vt->kbd->ledflagstate |
		    (vt->kbd->default_ledflagstate << 4), (char *) arg);
	return 0;

    case KDSKBLED:
	if (arg & ~0x77)
	    return -EINVAL;
	vt->kbd->ledflagstate = (arg & 7);
	vt->kbd->default_ledflagstate = ((arg >> 4) & 7);
	set_leds ();
	return 0;

    /* the ioctls below only set the lights, not the functions */
    /* for those, see KDGKBLED and KDSKBLED above */
    case KDGETLED:
	i = verify_area(VERIFY_WRITE, (void *) arg, sizeof(unsigned char));
	if (i)
	    	return i;
	put_user(getledstate(), (char *) arg);
	return 0;

    case KDSETLED:
	setledstate(kbd, arg);
	return 0;

    /*
     * A process can indicate its willingness to accept signals
     * generated by pressing an appropriate key combination.
     * Thus, one can have a daemon that e.g. spawns a new console
     * upon a keypess and then changes to it.
     * Probably init should be changed to do this (and have a
     * field ks (`keyboard signal') in inittab describing the
     * desired acion), so that the number of background daemons
     * does not increase.
     */
    case KDSIGACCEPT: {
	if (arg < 1 || arg > NSIG || arg == SIGKILL)
	    return -EINVAL;
	spawnpid = current->pid;
	spawnsig = arg;
	return 0;
	}
    default:
	return -ENOIOCTLCMD;
    }
}

int kbd_init (void)
{
	int ret;
	init_bh(KEYBOARD_BH, kbd_bh);
	ret = kbd_drv_init();
	mark_bh(KEYBOARD_BH);
	return ret;
}
