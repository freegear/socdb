/* 68328serial.c: Serial port driver for 68328 microcontroller
 *
 * Copyright (C) 1995       David S. Miller    <davem@caip.rutgers.edu>
 * Copyright (C) 1998       Kenneth Albanowski <kjahds@kjahds.com>
 * Copyright (C) 1998, 1999 D. Jeff Dionne     <jeff@rt-control.com>
 * Copyright (C) 1999       Vladimir Gurevich  <vgurevic@cisco.com>
 *
 */
#include <linux/module.h>
#include <linux/errno.h>
#include <linux/signal.h>
#include <linux/sched.h>
#include <linux/timer.h>
#include <linux/interrupt.h>
#include <linux/tty.h>
#include <linux/tty_flip.h>
#include <linux/serial.h>
#include <linux/serial_reg.h>
#include <linux/config.h>
#include <linux/major.h>
#include <linux/string.h>
#include <linux/fcntl.h>
#include <linux/ptrace.h>
#include <linux/ioport.h>
#include <linux/mm.h>
#include <asm/system.h>
#include <asm/irq.h>

#include <asm/io.h>

#include <asm/segment.h>
#include <asm/bitops.h>

/*
#include <linux/errno.h>
#include <linux/signal.h>
#include <linux/sched.h>
#include <linux/timer.h>
#include <linux/interrupt.h>
#include <linux/tty.h>
#include <linux/tty_flip.h>
#include <linux/config.h>
#include <linux/major.h>
#include <linux/string.h>
#include <linux/fcntl.h>
#include <linux/mm.h>
#include <linux/kernel.h>

#include <asm/io.h>
#include <asm/irq.h>
#include <asm/system.h>
#include <asm/segment.h>
#include <asm/bitops.h>
#include <asm/delay.h>
*/

#define NR_PORTS 1
#define SERIAL_TYPE_NORMAL 1
#define SERIAL_TYPE_CALLOUT 2

#define BASE_BAUD 115200
#define STD_COM_FLAGS 0

struct tty_driver serial_driver, callout_driver;

static int serial_refcount;

static struct tty_struct *serial_table[NR_PORTS];
static struct termios *serial_termios[NR_PORTS];
static struct termios *serial_termios_locked[NR_PORTS];

int rs_console_inited = 0;
int rs_console_port = 0;
int rs_console_baud = 115200;

DECLARE_TASK_QUEUE(tq_serial);

struct async_struct rs_or32_table[] = {
	/* UART CLK   PORT IRQ     FLAGS        */
	{ 0, BASE_BAUD, 0, 0, STD_COM_FLAGS },/* ttyS0 */
};

/*
 * or32_console_print is registered for printk.
 */
void console_print_or32(const char *p)
{
	char c;
	return;
}

void rs_console_init(void)
{
	/* Nothig for now */

	rs_console_inited++;
	return;
}

/*
 * rs_console_print is registered for printk output.
 */

void rs_console_print(const char *p)
{
	char c;
	
	while ((c = *(p++)) != 0) {
/*		if(c == '\n')
			_print("\r");
*/
		_print("%c", c);
	}
	return;
}

/*
 *	Setup for console. Argument comes from the boot command line.
 */
int rs_console_setup(char *arg)
{
	int	rc = 0;

	if (!strncmp(arg, "/dev/ttyS", 9)) {
		rs_console_port = arg[9] - '0';
		arg += 10;
		rc = 1;
	} else if (!strncmp(arg, "/dev/cua", 8)) {
		rs_console_port = arg[8] - '0';
		arg += 9;
		rc = 1;
	}
	if (*arg == ',')
		rs_console_baud = simple_strtoul(arg+1,NULL,0);
	return(rc);
}

/*
 * This is the serial driver's generic interrupt routine
 */
static void rs_or32_interrupt(int irq, void *dev_id, struct pt_regs * regs)
{
	int status;
	struct async_struct * info;
	int pass_counter = 0;
	struct async_struct *end_mark = 0;
	int first_multi = 0;
	struct rs_multiport_struct *multi;

printk("%s - %s:%d\n",__FILE__,__FUNCTION__,__LINE__);
printk("   irq=%x info=%x\n", irq, info);
	info = &rs_or32_table[irq];
	if (!info)
		return;	
/*	queue_task_irq_off(&info->tqueue, &tq_serial);*/
	queue_task_irq_off(&info->tty->flip.tqueue, &tq_serial);
	mark_bh(SERIAL_BH);
}

static void do_or32_serial_bh(void)
{
printk("%s - %s:%d\n",__FILE__,__FUNCTION__,__LINE__);
	run_task_queue(&tq_serial);
}

static void do_softint(void *private_)
{
	struct async_struct	*info = (struct async_struct *) private_;
	struct tty_struct	*tty;
	
printk("%s - %s:%d\n",__FILE__,__FUNCTION__,__LINE__);
	tty = info->tty;
	if (!tty)
		return;

/*	if (clear_bit(RS_EVENT_WRITE_WAKEUP, &info->event)) {
		if ((tty->flags & (1 << TTY_DO_WRITE_WAKEUP)) &&
		    tty->ldisc.write_wakeup)
			(tty->ldisc.write_wakeup)(tty);*/
printk("%s - %s:%d\n",__FILE__,__FUNCTION__,__LINE__);
		wake_up_interruptible(&tty->write_wait);
/*	}*/
}

static void do_serial_hangup(void *private_)
{
	struct async_struct	*info = (struct async_struct *) private_;
	struct tty_struct	*tty;
	
printk("%s - %s:%d\n",__FILE__,__FUNCTION__,__LINE__);
	tty = info->tty;
	if (!tty)
		return;

	tty_hangup(tty);
}

void init_port(struct async_struct *info, int num)
{
  int retval;

  info->magic = SERIAL_MAGIC;
  info->line = num;
#if 1
printk("%s(%d): info=%x num=%x\n", __FILE__, __LINE__, (int) info, num);
#endif
  info->tty = 0;
  info->type = PORT_UNKNOWN;
  info->custom_divisor = 0;
  info->close_delay = 5*HZ/10;
  info->closing_wait = 30*HZ;
  info->x_char = 0;
  info->event = 0;
  info->count = 0;
  info->blocked_open = 0;
  info->tqueue.routine = do_softint;
  info->tqueue.data = info;
  info->tqueue_hangup.routine = do_serial_hangup;
  info->tqueue_hangup.data = info;
  info->callout_termios =callout_driver.init_termios;
  info->normal_termios = serial_driver.init_termios;
  info->open_wait = 0;
  info->close_wait = 0;
  info->delta_msr_wait = 0;
  info->icount.cts = info->icount.dsr = 
	info->icount.rng = info->icount.dcd = 0;
  info->next_port = 0;
  info->prev_port = 0;

  retval = request_irq(info->irq, rs_or32_interrupt, IRQ_FLG_PRI_HI, "serial", NULL);
  if (retval)
    printk("SERIAL: failed to register interrup %d\n", info->irq);
}

/*
 * This routine is called whenever a serial port is opened.  It
 * enables interrupts for a serial port, linking in its async structure into
 * the IRQ chain.   It also performs the serial-specific
 * initialization for the tty structure.
 */
int rs_or32_open(struct tty_struct *tty, struct file * filp)
{
	struct async_struct	*info;

	info = rs_or32_table;

	info->count++;
        tty->driver_data = info;
        info->tty = tty;
	return 0;
}

/*
 * ------------------------------------------------------------
 * rs_close()
 * 
 * This routine is called when the serial port gets closed.  First, we
 * wait for the last remaining data to be sent.  Then, we unlink its
 * async structure from the interrupt chain if necessary, and we free
 * that IRQ if nothing is left in the chain.
 * ------------------------------------------------------------
 */
static void rs_or32_close(struct tty_struct *tty, struct file * filp)
{
}

static int rs_or32_write(struct tty_struct * tty, int from_user,
		    const unsigned char *buf, int count)
{
	int	total = count;
	
	while (count--) {
		_print("%c", *buf);
		buf++;
	}
	
	return total;
}

static void rs_or32_put_char(struct tty_struct *tty, unsigned char ch)
{
	_print("%c", ch);
}

static void rs_or32_flush_chars(struct tty_struct *tty)
{
}

static int rs_or32_write_room(struct tty_struct *tty)
{
	return 100;
}

static int rs_or32_chars_in_buffer(struct tty_struct *tty)
{
	return 0;
}

static void rs_or32_flush_buffer(struct tty_struct *tty)
{
}

static int rs_or32_ioctl(struct tty_struct *tty, struct file * file,
		    unsigned int cmd, unsigned long arg)
{
	int error;
	struct async_struct * info = (struct async_struct *)tty->driver_data;
	int retval;

	if ((cmd != TIOCGSERIAL) && (cmd != TIOCSSERIAL) &&
	    (cmd != TIOCSERCONFIG) && (cmd != TIOCSERGWILD)  &&
	    (cmd != TIOCSERSWILD) && (cmd != TIOCSERGSTRUCT) &&
	    (cmd != TIOCMIWAIT) && (cmd != TIOCGICOUNT)) {
		if (tty->flags & (1 << TTY_IO_ERROR))
		    return -EIO;
	}
	
printk("%s - %s:%d\n",__FILE__,__FUNCTION__,__LINE__);

	switch (cmd) {
                case TIOCSBRK:  /* Turn break on, unconditionally */
printk("   TIOCSBRK\n");
			return 0;
                case TIOCCBRK:  /* Turn break off, unconditionally */
printk("   TIOCCBRK\n");
			return 0;
		case TCSBRK:	/* SVID version: non-zero arg --> no break */
printk("   TCSBRK\n");
			return 0;
		case TCSBRKP:	/* support for POSIX tcsendbreak() */
printk("   TCSBRKP\n");
			return 0;
		case TIOCGSOFTCAR:
printk("   TIOCGSOFTCAR\n");
			return 0;
		case TIOCSSOFTCAR:
printk("   TIOCSSOFTCAR\n");
			return 0;
		case TIOCMGET:
printk("   TIOCMGET\n");
			sizeof(unsigned int);
		case TIOCMBIS:
		case TIOCMBIC:
		case TIOCMSET:
printk("   TIOCMSET\n");
			return 0;
		case TIOCGSERIAL:
printk("   TIOCGSERIAL\n");
			return 0;
		case TIOCSSERIAL:
printk("   TIOCSSERIAL\n");
			return 0;
		case TIOCSERCONFIG:
printk("   TIOCSERCONFIG\n");
			return 0;

		case TIOCSERGETLSR: /* Get line status register */
printk("   TIOCSERGETLSR\n");
			return 0;

		case TIOCSERGSTRUCT:
printk("   TIOCSERGSTRUCT\n");
			return 0;
			
		/*
		 * Wait for any of the 4 modem inputs (DCD,RI,DSR,CTS) to change
		 * - mask passed in arg for lines of interest
 		 *   (use |'ed TIOCM_RNG/DSR/CD/CTS for masking)
		 * Caller should use TIOCGICOUNT to see which one it was
		 */
		 case TIOCMIWAIT:
printk("   TIOCMIWAIT\n");
			return 0;
		case TIOCGICOUNT:
printk("   TIOCGICOUNT\n");
			return 0;

		default:
printk("   default\n");
			return -ENOIOCTLCMD;
		}
	return 0;
}

/*
 * ------------------------------------------------------------
 * rs_throttle()
 * 
 * This routine is called by the upper-layer tty layer to signal that
 * incoming characters should be throttled.
 * ------------------------------------------------------------
 */
static void rs_or32_throttle(struct tty_struct * tty)
{
}

static void rs_or32_unthrottle(struct tty_struct * tty)
{
}

static void rs_or32_set_termios(struct tty_struct *tty, struct termios *old_termios)
{
}

/*
 * ------------------------------------------------------------
 * rs_stop() and rs_start()
 *
 * This routines are called before setting or resetting tty->stopped.
 * They enable or disable transmitter interrupts, as necessary.
 * ------------------------------------------------------------
 */
static void rs_or32_stop(struct tty_struct *tty)
{
}

static void rs_or32_start(struct tty_struct *tty)
{
}

/*
 * rs_hangup() --- called by tty_hangup() when a hangup is signaled.
 */
void rs_or32_hangup(struct tty_struct *tty)
{
}

/*
 * The serial driver boot-time initialization code!
 */

int rs_or32_init(void)
{
	int i;
	struct async_struct * info;
	
	init_bh(SERIAL_BH, do_or32_serial_bh);

	/* Initialize the tty_driver structure */
	
	memset(&serial_driver, 0, sizeof(struct tty_driver));
	serial_driver.magic = TTY_DRIVER_MAGIC;
	serial_driver.name = "tty";
	serial_driver.major = TTY_MAJOR;
	serial_driver.minor_start = 64;
	serial_driver.num = NR_PORTS;
	serial_driver.type = TTY_DRIVER_TYPE_SERIAL;
	serial_driver.subtype = SERIAL_TYPE_NORMAL;
	serial_driver.init_termios = tty_std_termios;
	serial_driver.init_termios.c_cflag =
		B9600 | CS8 | CREAD | HUPCL | CLOCAL;
	serial_driver.flags = TTY_DRIVER_REAL_RAW;
	serial_driver.refcount = &serial_refcount;
	serial_driver.table = serial_table;
	serial_driver.termios = serial_termios;
	serial_driver.termios_locked = serial_termios_locked;

	serial_driver.open = rs_or32_open;
	serial_driver.close = rs_or32_close;
	serial_driver.write = rs_or32_write;
	serial_driver.put_char = rs_or32_put_char;
	serial_driver.flush_chars = rs_or32_flush_chars;
	serial_driver.write_room = rs_or32_write_room;
	serial_driver.chars_in_buffer = rs_or32_chars_in_buffer;
	serial_driver.flush_buffer = rs_or32_flush_buffer;
	serial_driver.ioctl = rs_or32_ioctl;
	serial_driver.throttle = rs_or32_throttle;
	serial_driver.unthrottle = rs_or32_unthrottle;
	serial_driver.set_termios = rs_or32_set_termios;
	serial_driver.stop = rs_or32_stop;
	serial_driver.start = rs_or32_start;
	serial_driver.hangup = rs_or32_hangup;

	/*
	 * The callout device is just like normal device except for
	 * major number and the subtype code.
	 */
	callout_driver = serial_driver;
	callout_driver.name = "cua";
	callout_driver.major = TTYAUX_MAJOR;
	callout_driver.subtype = SERIAL_TYPE_CALLOUT;

	if (tty_register_driver(&serial_driver))
		panic("Couldn't register serial driver\n");
	if (tty_register_driver(&callout_driver))
		panic("Couldn't register callout driver\n");

	for (i = 0, info = rs_or32_table; i < NR_PORTS; i++,info++) {
				init_port(info, i);
	}


	return 0;
}


