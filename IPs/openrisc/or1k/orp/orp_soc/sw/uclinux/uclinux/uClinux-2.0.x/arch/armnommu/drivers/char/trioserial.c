/* TRIO chip serial port driver
 *
 * Based on:
 *
 * drivers/char/68302serial.c
 */
 
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
#include <asm/arch-trio/irq.h>
#include <asm/system.h>
#include <asm/segment.h>
#include <asm/bitops.h>
#include <asm/delay.h>
#if 0
#include <asm/kdebug.h>
#endif

#include "trioserial.h"

#define USE_INTS	1
#define US_NB		2
#define UART_CLOCK	(ARM_CLK/16)


#define XMIT_SERIAL_SIZE	PAGE_SIZE
#define RX_SERIAL_SIZE	PAGE_SIZE


static struct uart_regs *uarts[US_NB] = {
	(struct uart_regs*)USARTA_BASE, (struct uart_regs*)USARTB_BASE
};
static struct trio_serial trio_info[US_NB];
struct tty_struct trio_ttys[US_NB];

/* Console hooks... */
/*static int m68k_cons_chanout = 0;
static int m68k_cons_chanin = 0;*/

struct trio_serial *trio_consinfo = 0;

#if 0
static unsigned char kgdb_regs[16] = {
	0, 0, 0,                     /* write 0, 1, 2 */
	(Rx8 | RxENABLE),            /* write 3 */
	(X16CLK | SB1 | PAR_EVEN),   /* write 4 */
	(Tx8 | TxENAB),              /* write 5 */
	0, 0, 0,                     /* write 6, 7, 8 */
	(NV),                        /* write 9 */
	(NRZ),                       /* write 10 */
	(TCBR | RCBR),               /* write 11 */
	0, 0,                        /* BRG time constant, write 12 + 13 */
	(BRSRC | BRENABL),           /* write 14 */
	(DCDIE)                      /* write 15 */
};
#endif

DECLARE_TASK_QUEUE(tq_serial);

struct tq_struct serialpoll;

struct tty_driver serial_driver, callout_driver;
static int serial_refcount;

/* serial subtype definitions */
#define SERIAL_TYPE_NORMAL	1
#define SERIAL_TYPE_CALLOUT	2
  
/* number of characters left in xmit buffer before we ask for more */
#define WAKEUP_CHARS 256

/* Debugging... DEBUG_INTR is bad to use when one of the zs
 * lines is your console ;(
 */
#undef SERIAL_DEBUG_INTR
#undef SERIAL_DEBUG_OPEN
#undef SERIAL_DEBUG_FLOW

#define RS_ISR_PASS_LIMIT 256

#define _INLINE_

static void serpoll(void *data);

static void change_speed(struct trio_serial *info);

static struct tty_struct *serial_table[US_NB];
static struct termios *serial_termios[US_NB];
static struct termios *serial_termios_locked[US_NB];

#ifndef MIN
#define MIN(a,b)	((a) < (b) ? (a) : (b))
#endif

static char prompt0;
static void xmit_char(struct trio_serial* info, char ch);
static void xmit_string(struct trio_serial *info, char *p, int len);
static void start_rx(struct trio_serial *info);
static void wait_EOT(struct uart_regs*);
static void uart_init(struct trio_serial *info);
static void uart_speed(struct trio_serial *info, unsigned cflag);

static void tx_enable(struct uart_regs *uart);
static void rx_enable(struct uart_regs *uart);
static void tx_disable(struct uart_regs *uart);
static void rx_disable(struct uart_regs *uart);
static void tx_stop(struct uart_regs *uart);
static void tx_start(struct uart_regs *uart, int ints);
static void rx_stop(struct uart_regs *uart);
static void rx_start(struct uart_regs *uart, int ints);
static void set_ints_mode(int yes, struct trio_serial *info);
static void rs_interrupt(struct trio_serial *info);
extern void show_net_buffers(void);
extern void hard_reset_now(void);


static void _INLINE_ tx_enable(struct uart_regs *uart){
	uart->ier	|= US_TXRDY;
}
static void _INLINE_ rx_enable(struct uart_regs *uart){
	uart->ier	|= US_RXRDY;
}
static void _INLINE_ tx_disable(struct uart_regs *uart){
	uart->idr	|= US_TXRDY;
}
static void _INLINE_ rx_disable(struct uart_regs *uart){
	uart->idr	|= US_RXRDY;
}
static void _INLINE_ tx_stop(struct uart_regs *uart){
	tx_disable(uart);
	uart->cr	|= US_RXEN;
}
static void _INLINE_ tx_start(struct uart_regs *uart, int ints){
	if(ints)
		tx_enable(uart);
	uart->cr	|= US_TXEN;
}
static void _INLINE_ rx_stop(struct uart_regs *uart){
	rx_disable(uart);
	uart->cr	|= US_RXDIS;
}
static void _INLINE_ rx_start(struct uart_regs *uart, int ints){
	if(ints)
		rx_enable(uart);
	uart->cr	|= US_RXEN;
}

static void set_ints_mode(int yes, struct trio_serial *info){
	info->use_ints = yes;
	(yes)?unmask_irq(info->irq):mask_irq(info->irq);
}

/*
 * tmp_buf is used as a temporary buffer by serial_write.  We need to
 * lock it in case the memcpy_fromfs blocks while swapping in a page,
 * and some other program tries to do a serial write at the same time.
 * Since the lock will only come under contention when the system is
 * swapping and available memory is low, it makes sense to share one
 * buffer across all the serial ports, since it significantly saves
 * memory if large numbers of serial ports are open.
 */
static unsigned char tmp_buf[XMIT_SERIAL_SIZE]; /* This is cheating */
static struct semaphore tmp_buf_sem = MUTEX;

static inline int serial_paranoia_check(struct trio_serial *info,
					dev_t device, const char *routine)
{
#ifdef SERIAL_PARANOIA_CHECK
	static const char *badmagic =
		"Warning: bad magic number for serial struct (%d, %d) in %s\n";
	static const char *badinfo =
		"Warning: null trio_serial for (%d, %d) in %s\n";

	if (!info) {
		printk(badinfo, MAJOR(device), MINOR(device), routine);
		return 1;
	}
	if (info->magic != SERIAL_MAGIC) {
		printk(badmagic, MAJOR(device), MINOR(device), routine);
		return 1;
	}
#endif
	return 0;
}

/* Sets or clears DTR/RTS on the requested line */
static inline void trio_rtsdtr(struct trio_serial *ss, int set)
{
	struct uart_regs *uart;
	uart = ss->uart;
	if(set) {
		uart->mc |= US_DTR | US_RTS;
	} else {
		uart->mc &= ~(u_32)(US_DTR | US_RTS);
	}
	return;
}

static inline void kgdb_chaninit(struct trio_serial *ss, int intson, int bps)
{
#if 0
	int brg;

	if(intson) {
		kgdb_regs[R1] = INT_ALL_Rx;
		kgdb_regs[R9] |= MIE;
	} else {
		kgdb_regs[R1] = 0;
		kgdb_regs[R9] &= ~MIE;
	}
	brg = BPS_TO_BRG(bps, ZS_CLOCK/16);
	kgdb_regs[R12] = (brg & 255);
	kgdb_regs[R13] = ((brg >> 8) & 255);
	load_zsregs(ss->trio_channel, kgdb_regs);
#endif
}


/*
 * ------------------------------------------------------------
 * rs_stop() and rs_start()
 *
 * This routines are called before setting or resetting tty->stopped.
 * They enable or disable transmitter interrupts, as necessary.
 * ------------------------------------------------------------
 */
static void rs_stop(struct tty_struct *tty)
{
	struct trio_serial *info = (struct trio_serial *)tty->driver_data;
	unsigned long flags;

	if (serial_paranoia_check(info, tty->device, "rs_stop"))
		return;
	
	save_flags(flags); cli();
	tx_stop(info->uart);
	rx_stop(info->uart);
	restore_flags(flags);
}

static void rs_put_char(struct trio_serial *info, char ch)
{
        int flags = 0;
        save_flags(flags); cli();
		wait_EOT(info->uart);
		xmit_char(info,ch);
		wait_EOT(info->uart);
        restore_flags(flags);
}

static void rs_start(struct tty_struct *tty)
{
	struct trio_serial *info = (struct trio_serial *)tty->driver_data;
	unsigned long flags;
	
	if (serial_paranoia_check(info, tty->device, "rs_start"))
		return;
	
	save_flags(flags); cli();
	tx_start(info->uart, info->use_ints);
	start_rx(info);
	restore_flags(flags);
}

/* Drop into either the boot monitor or kadb upon receiving a break
 * from keyboard/console input.
 */
static void batten_down_hatches(void)
{
	/* If we are doing kadb, we call the debugger
	 * else we just drop into the boot monitor.
	 * Note that we must flush the user windows
	 * first before giving up control.
	 */
#if 0
	if((((unsigned long)linux_dbvec)>=DEBUG_FIRSTVADDR) &&
	   (((unsigned long)linux_dbvec)<=DEBUG_LASTVADDR))
		sp_enter_debugger();
	else
		panic("trio_serial: batten_down_hatches");
	return;
#endif
}

/*
 * ----------------------------------------------------------------------
 *
 * Here starts the interrupt handling routines.  All of the following
 * subroutines are declared as inline and are folded into
 * rs_interrupt().  They were separated out for readability's sake.
 *
 * Note: rs_interrupt() is a "fast" interrupt, which means that it
 * runs with interrupts turned off.  People who may want to modify
 * rs_interrupt() should try to keep the interrupt handler as fast as
 * possible.  After you are done making modifications, it is not a bad
 * idea to do:
 * 
 * gcc -S -DKERNEL -Wall -Wstrict-prototypes -O6 -fomit-frame-pointer serial.c
 *
 * and look at the resulting assemble code in serial.s.
 *
 * 				- Ted Ts'o (tytso@mit.edu), 7-Mar-93
 * -----------------------------------------------------------------------
 */

/*
 * This routine is used by the interrupt handler to schedule
 * processing in the software interrupt portion of the driver.
 */
static _INLINE_ void rs_sched_event(struct trio_serial *info,
				    int event)
{
	info->event |= 1 << event;
	queue_task_irq_off(&info->tqueue, &tq_serial);
	mark_bh(SERIAL_BH);
}

extern void breakpoint(void);  /* For the KGDB frame character */

static _INLINE_ void receive_chars(struct trio_serial *info, u_32 status)
{
	unsigned char ch;
	int count;
	struct uart_regs *uart = info->uart;	
#if 0
	// hack to receive chars by polling from anywhere
	struct trio_serial * info1 = &trio_info;
	struct tty_struct *tty = info1->tty;
	if (!(info->flags & S_INITIALIZED))
		return;
#else
	struct tty_struct *tty = info->tty;
	if (!(info->flags & S_INITIALIZED))
		return;
#endif	
	count = uart->rcr;
	// hack to receive chars by polling only BD fields
	if (!(status & US_RXRDY)  || !count){
		return;
	}
	ch = info->rx_buf[0];
	if(info->is_cons) {
		if(status & US_RXBRK) { /* whee, break received */
			batten_down_hatches();
			/*rs_recv_clear(info->trio_channel);*/
			return;
		} else if (ch == 0x10) { /* ^P */
			show_state();
			show_free_areas();
			show_buffers();
			show_net_buffers();
			return;
		} else if (ch == 0x12) { /* ^R */
			hard_reset_now();
			return;
		}
		/* It is a 'keyboard interrupt' ;-) */
		wake_up(&keypress_wait);
	}
	/* Look for kgdb 'stop' character, consult the gdb documentation
	 * for remote target debugging and arch/sparc/kernel/sparc-stub.c
	 * to see how all this works.
	 */
	/*if((info->kgdb_channel) && (ch =='\003')) {
		breakpoint();
		goto clear_and_exit;
	}*/

	if(!tty)
		goto clear_and_exit;

	if (tty->flip.count >= TTY_FLIPBUF_SIZE)
		queue_task_irq_off(&tty->flip.tqueue, &tq_timer);
	tty->flip.count++;
	if(status & US_PARE)
		*tty->flip.flag_buf_ptr++ = TTY_PARITY;
	else if(status & US_OVRE)
		*tty->flip.flag_buf_ptr++ = TTY_OVERRUN;
	else if(status & US_FRAME)
		*tty->flip.flag_buf_ptr++ = TTY_FRAME;
	else
		*tty->flip.flag_buf_ptr++ = 0; /* XXX */
	*tty->flip.char_buf_ptr++ = ch;

	queue_task_irq_off(&tty->flip.tqueue, &tq_timer);

clear_and_exit:
	start_rx(info);
	return;
}

static _INLINE_ void transmit_chars(struct trio_serial *info)
{
	if (info->x_char) {
		/* Send next char */
		xmit_char(info, info->x_char);
		info->x_char = 0;
		goto clear_and_return;
	}

	if((info->xmit_cnt <= 0) || info->tty->stopped) {
		/* That's peculiar... */
//		tx_stop(0);
		goto clear_and_return;
	}

	/* Send char */
	xmit_char(info, info->xmit_buf[info->xmit_tail++]);
	info->xmit_tail = info->xmit_tail & (SERIAL_XMIT_SIZE-1);
	info->xmit_cnt--;

	if (info->xmit_cnt < WAKEUP_CHARS)
		rs_sched_event(info, RS_EVENT_WRITE_WAKEUP);

	if(info->xmit_cnt <= 0) {
//		tx_stop(0);
		goto clear_and_return;
	}

clear_and_return:
	/* Clear interrupt (should be auto)*/
	return;
}

static _INLINE_ void status_handle(struct trio_serial *info, u_32 status)
{
#if 0
	if(status & DCD) {
		if((info->tty->termios->c_cflag & CRTSCTS) &&
		   ((info->curregs[3] & AUTO_ENAB)==0)) {
			info->curregs[3] |= AUTO_ENAB;
			info->pendregs[3] |= AUTO_ENAB;
			write_zsreg(info->trio_channel, 3, info->curregs[3]);
		}
	} else {
		if((info->curregs[3] & AUTO_ENAB)) {
			info->curregs[3] &= ~AUTO_ENAB;
			info->pendregs[3] &= ~AUTO_ENAB;
			write_zsreg(info->trio_channel, 3, info->curregs[3]);
		}
	}
#endif
	/* Whee, if this is console input and this is a
	 * 'break asserted' status change interrupt, call
	 * the boot prom.
	 */
	if((status & US_RXBRK) && info->break_abort)
		batten_down_hatches();

	/* XXX Whee, put in a buffer somewhere, the status information
	 * XXX whee whee whee... Where does the information go...
	 */
	return;
}


/*
 * This is the serial driver's generic interrupt routine
 */
void rs_interrupta(int irq, void *dev_id, struct pt_regs * regs){
	rs_interrupt(&trio_info[0]);
}
void rs_interruptb(int irq, void *dev_id, struct pt_regs * regs){
	rs_interrupt(&trio_info[1]);
}
static void rs_interrupt(struct trio_serial *info)
{
	u_32 status;
	status = info->uart->csr;
	
	if (status & US_TXRDY) {
		transmit_chars(info);
	}
	if (status & US_RXRDY){
		receive_chars(info, status);
	}
	status_handle(info, status);
	
	if(!info->use_ints){
		serialpoll.data = (void *)info;		
		queue_task_irq_off(&serialpoll, &tq_timer);
	}
	return;
}
static void serpoll(void *data){
	struct trio_serial * info = data;
	rs_interrupt(info);
}

/*
 * -------------------------------------------------------------------
 * Here ends the serial interrupt routines.
 * -------------------------------------------------------------------
 */

/*
 * This routine is used to handle the "bottom half" processing for the
 * serial driver, known also the "software interrupt" processing.
 * This processing is done at the kernel interrupt level, after the
 * rs_interrupt() has returned, BUT WITH INTERRUPTS TURNED ON.  This
 * is where time-consuming activities which can not be done in the
 * interrupt driver proper are done; the interrupt driver schedules
 * them using rs_sched_event(), and they get done here.
 */
static void do_serial_bh(void)
{
	run_task_queue(&tq_serial);
}

static void do_softint(void *private_)
{
	struct trio_serial	*info = (struct trio_serial *) private_;
	struct tty_struct	*tty;
	
	tty = info->tty;
	if (!tty)
		return;

	if (clear_bit(RS_EVENT_WRITE_WAKEUP, &info->event)) {
		if ((tty->flags & (1 << TTY_DO_WRITE_WAKEUP)) &&
		    tty->ldisc.write_wakeup)
			(tty->ldisc.write_wakeup)(tty);
		wake_up_interruptible(&tty->write_wait);
	}
}

/*
 * This routine is called from the scheduler tqueue when the interrupt
 * routine has signalled that a hangup has occurred.  The path of
 * hangup processing is:
 *
 * 	serial interrupt routine -> (scheduler tqueue) ->
 * 	do_serial_hangup() -> tty->hangup() -> rs_hangup()
 * 
 */
static void do_serial_hangup(void *private_)
{
	struct trio_serial	*info = (struct trio_serial *) private_;
	struct tty_struct	*tty;
	
	tty = info->tty;
	if (!tty)
		return;

	tty_hangup(tty);
}


/*
 * This subroutine is called when the RS_TIMER goes off.  It is used
 * by the serial driver to handle ports that do not have an interrupt
 * (irq=0).  This doesn't work at all for 16450's, as a sun has a Z8530.
 */
 
static void rs_timer(void)
{
	panic("rs_timer called\n");
	return;
}
static u_32 calcCD(u_32 br){
	return(UART_CLOCK/br);
}
static void uart_init(struct trio_serial *info){
	struct uart_regs* uart;
	if(info){
		uart = info->uart;
	}else{
		uart = uarts[0];
	}
	uart->cr	= US_RSTRX|US_RSTTX|US_RSTSTA|US_TXDIS|US_RXDIS;
	uart->mr	= US_USCLKS(0)|US_CLK0|US_CHMODE(0)|US_NBSTOP(0)|US_PAR(4)|US_CHRL(3);
	uart->ier	= 0;
	uart->idr	= US_ALL_INTS;
	uart->brgr	= calcCD(9600);
	uart->rtor	= 100;	// timeout = value * 4 * bit period
	uart->ttgr	= 0;	// no guard time
	uart->rpr	= 0;
	uart->rcr	= 0;
	uart->tpr	= 0;
	uart->tcr	= 0;
	uart->mc	= 0;
}

static void uart_speed(struct trio_serial *info, unsigned cflag){
	unsigned baud = info->baud;
	struct uart_regs *uart = info->uart;

	uart->cr	= US_TXDIS|US_RXDIS;
	uart->ier	= 0;
	uart->idr	= US_ALL_INTS;
	uart->brgr	= calcCD(baud);
	uart->rtor	= 100;	// timeout = value * 4 *bit period	
	uart->ttgr	= 0;	// no guard time	
	uart->rpr	= 0;
	uart->rcr	= 0;
	uart->tpr	= 0;
	uart->tcr	=0;
	uart->mc	= 0;
	if (cflag != 0xffff){
		uart->mr	= US_USCLKS(0)|US_CLK0|US_CHMODE(0)|US_PAR(0);
		
		if ((cflag & CSIZE) == CS8)
			uart->mr |= US_CHRL(3);		// 8 bit char
		else
			uart->mr |= US_CHRL(2);		// 7 bit char
		
		if (cflag & CSTOPB)
			uart->mr |= US_NBSTOP(2);	// 2 stop bits
		
		if (!(cflag & PARENB))
			uart->mr |= US_PAR(4);		// parity disabled
		else
			if (cflag & PARODD)
				uart->mr |= US_PAR(1);	// odd parity
	}
	tx_start(uart, info->use_ints);
	start_rx(info);
}
static void wait_EOT(struct uart_regs *uart){
	volatile u_32 status;
	volatile struct uart_regs* puart;
	puart = (volatile struct uart_regs*)uart;
	while(1){
		status = puart->csr;
		if(status & US_TXRDY)
			break;
	}
}
static int startup(struct trio_serial * info)
{
	unsigned long flags;

	if (info->flags & S_INITIALIZED)
		return 0;

	if (!info->xmit_buf) {
		info->xmit_buf = (unsigned char *) get_free_page(GFP_KERNEL);
		if (!info->xmit_buf)
			return -ENOMEM;
	}
	if (!info->rx_buf) {
		info->rx_buf = (unsigned char *) get_free_page(GFP_KERNEL);
		if (!info->rx_buf)
			return -ENOMEM;
	}
	save_flags(flags); cli();
#ifdef SERIAL_DEBUG_OPEN
	printk("starting up ttyS%d (irq %d)...\n", info->line, info->irq);
#endif
	/*
	 * Clear the FIFO buffers and disable them
	 * (they will be reenabled in change_speed())
	 */
	
	if (info->tty)
		clear_bit(TTY_IO_ERROR, &info->tty->flags);
	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;

	/*
	 * and set the speed of the serial port
	 */

	uart_init(info);
	set_ints_mode(1, info);
	change_speed(info);

	info->flags |= S_INITIALIZED;
	restore_flags(flags);
	return 0;
}

/*
 * This routine will shutdown a serial port; interrupts are disabled, and
 * DTR is dropped if the hangup on close termio flag is on.
 */
static void shutdown(struct trio_serial * info)
{
	unsigned long	flags;

	tx_disable(info->uart);
	rx_disable(info->uart);
	rx_stop(info->uart); /* All off! */
	if (!(info->flags & S_INITIALIZED))
		return;

#ifdef SERIAL_DEBUG_OPEN
	printk("Shutting down serial port %d (irq %d)....\n", info->line,
	       info->irq);
#endif
	
	save_flags(flags); cli(); /* Disable interrupts */
	
	if (info->xmit_buf) {
		free_page((unsigned long) info->xmit_buf);
		info->xmit_buf = 0;
	}

	if (info->tty)
		set_bit(TTY_IO_ERROR, &info->tty->flags);
	
	info->flags &= ~S_INITIALIZED;
	restore_flags(flags);
}

/* rate = 1036800 / ((65 - prescale) * (1<<divider)) */

static int baud_table[] = {
	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400, 4800,
	9600, 19200, 38400, 57600, 115200, 0 };

/*
 * This routine is called to set the UART divisor registers to match
 * the specified baud rate for a serial port.
 */
static void change_speed(struct trio_serial *info)
{
	unsigned cflag;
	int	i;

	if (!info->tty || !info->tty->termios)
		return;
	cflag = info->tty->termios->c_cflag;

	/* First disable the interrupts */
	tx_stop(info->uart);
	rx_stop(info->uart);
	/* set the baudrate */
	i = cflag & CBAUD;

	info->baud = baud_table[i];
	uart_speed(info, cflag);
	start_rx(info);
	tx_start(info->uart, info->use_ints);
	return;
}
static void start_rx(struct trio_serial *info){
	struct uart_regs *uart = info->uart;
	uart->rcr = (u_32)RX_SERIAL_SIZE;
	uart->rpr = (u_32)info->rx_buf;	
	rx_start(uart, info->use_ints);
}
static void xmit_char(struct trio_serial *info, char ch){
	prompt0 = ch;
	xmit_string(info, &prompt0, 1);
}
static void xmit_string(struct trio_serial *info, char *p, int len){
	info->uart->tcr = (u_32)len;
	info->uart->tpr = (u_32)p;	
	tx_start(info->uart, info->use_ints);
}

#if 0
/* These are for receiving and sending characters under the kgdb
 * source level kernel debugger.
 */
void putDebugChar(char kgdb_char)
{
	struct sun_zschannel *chan = trio_kgdbchan;

	while((chan->control & Tx_BUF_EMP)==0)
		udelay(5);

	chan->data = kgdb_char;
}

char getDebugChar(void)
{
	struct sun_zschannel *chan = trio_kgdbchan;

	while((chan->control & Rx_CH_AV)==0)
		barrier();
	return chan->data;
}
#endif

/*
 * Fair output driver allows a process to speak.
 */
static void rs_fair_output(	struct trio_serial *info)
{
	int left;		/* Output no more than that */
	unsigned long flags;
	char c;

	if (info == 0) return;
	if (info->xmit_buf == 0) return;

	save_flags(flags);  cli();
	left = info->xmit_cnt;
	while (left != 0) {
		c = info->xmit_buf[info->xmit_tail];
		info->xmit_tail = (info->xmit_tail+1) & (SERIAL_XMIT_SIZE-1);
		info->xmit_cnt--;
		restore_flags(flags);

		rs_put_char(info, c);

		save_flags(flags);  cli();
		left = MIN(info->xmit_cnt, left-1);
	}

	/* Last character is being transmitted now (hopefully). */
//	udelay(20);
	wait_EOT(info->uart);
	restore_flags(flags);
	return;
}

/*
 * trio_console_print is registered for printk.
 */
static int console_initialized = 0;
static void init_console(void){
	struct trio_serial *info;
	info = &trio_info[0];
	memset(info, 0, sizeof(struct trio_serial));
#if 0	
	info->uart = uarts[0];
#else	
	info->uart = (struct uart_regs*)USARTA_BASE;
#endif
	info->tty = 0;
	info->irqmask = AIC_UA;
	info->irq = IRQ_USARTA;
	info->port = 1;
	info->use_ints = 0;
	info->is_cons = 1;
	console_initialized = 1;
}
void console_print_trio(const char *p)
{
	char c;
	struct trio_serial *info;
	info = &trio_info[0];

//	if (!(info->flags & S_INITIALIZED)){
	if(!console_initialized){
		init_console();
		uart_init(info);
		info->baud = 9600;
		uart_speed(info,0xffff);
	}
	while((c=*(p++)) != 0) {
		if(c == '\n')
			rs_put_char(info, '\r');
		rs_put_char(info, c);
	}

	/* Comment this if you want to have a strict interrupt-driven output */
//	if (!info->use_ints)
//		rs_fair_output(info);

	return;
}

static void rs_set_ldisc(struct tty_struct *tty)
{
	struct trio_serial *info = (struct trio_serial *)tty->driver_data;

	if (serial_paranoia_check(info, tty->device, "rs_set_ldisc"))
		return;

	info->is_cons = (tty->termios->c_line == N_TTY);
	
	printk("ttyS%d console mode %s\n", info->line, info->is_cons ? "on" : "off");
}

static void rs_flush_chars(struct tty_struct *tty)
{
	struct trio_serial *info = (struct trio_serial *)tty->driver_data;
	unsigned long flags;

	if (serial_paranoia_check(info, tty->device, "rs_flush_chars"))
		return;
	if(!info->use_ints){	
		for(;;) {
			if (info->xmit_cnt <= 0 || tty->stopped || tty->hw_stopped ||
				!info->xmit_buf)
				return;

			/* Enable transmitter */
			save_flags(flags); cli();
			tx_start(info->uart,info->use_ints);
		}
	}else{
		if (info->xmit_cnt <= 0 || tty->stopped || tty->hw_stopped ||
			!info->xmit_buf)
			return;

			/* Enable transmitter */
		save_flags(flags); cli();
		tx_start(info->uart, info->use_ints);
	}

	if(!info->use_ints)	
		wait_EOT(info->uart);
		/* Send char */
	xmit_char(info, info->xmit_buf[info->xmit_tail++]);
	info->xmit_tail = info->xmit_tail & (SERIAL_XMIT_SIZE-1);
	info->xmit_cnt--;
	
	restore_flags(flags);
}

extern void console_printn(const char * b, int count);

static int rs_write(struct tty_struct * tty, int from_user,
		    const unsigned char *buf, int count)
{
	int	c, total = 0;
	struct trio_serial *info = (struct trio_serial *)tty->driver_data;
	unsigned long flags;

	if (serial_paranoia_check(info, tty->device, "rs_write"))
		return 0;

	if (!tty || !info->xmit_buf)
		return 0;
	
	/*buf = "123456";
	count = 6;
	
	printk("Writing '%s' to serial port\n", buf);*/

	/*printk("rs_write of %d bytes\n", count);*/


	save_flags(flags);
	while (1) {
		cli();		
		c = MIN(count, MIN(SERIAL_XMIT_SIZE - info->xmit_cnt - 1,
				   SERIAL_XMIT_SIZE - info->xmit_head));
		if (c <= 0)
			break;

		if (from_user) {
			down(&tmp_buf_sem);
			memcpy_fromfs(tmp_buf, buf, c);
			
#if 0		// HN already done			
			c = MIN(c, MIN(SERIAL_XMIT_SIZE - info->xmit_cnt - 1,
				       SERIAL_XMIT_SIZE - info->xmit_head));
#endif			
			memcpy(info->xmit_buf + info->xmit_head, tmp_buf, c);
			up(&tmp_buf_sem);
		} else
			memcpy(info->xmit_buf + info->xmit_head, buf, c);
		info->xmit_head = (info->xmit_head + c) & (SERIAL_XMIT_SIZE-1);
		info->xmit_cnt += c;
		restore_flags(flags);
		buf += c;
		count -= c;
		total += c;
	}

	if (info->xmit_cnt && !tty->stopped && !tty->hw_stopped ){
		/* Enable transmitter */
		
		cli();		
		/*printk("Enabling transmitter\n");*/

		if(!info->use_ints){	
			while(info->xmit_cnt) {
				wait_EOT(info->uart);
				/* Send char */
				xmit_char(info, info->xmit_buf[info->xmit_tail++]);
				wait_EOT(info->uart);
				info->xmit_tail = info->xmit_tail & (SERIAL_XMIT_SIZE-1);
				info->xmit_cnt--;
			}
		}else{
			if (info->xmit_cnt){
				/* Send char */
				wait_EOT(info->uart);
				xmit_string(info, &info->xmit_buf[info->xmit_tail], info->xmit_cnt);
				info->xmit_tail = info->xmit_tail & (SERIAL_XMIT_SIZE-1);
				info->xmit_cnt=0;
			}
		}
		restore_flags(flags);
	} else {
		/*printk("Skipping transmit\n");*/
	}


#if 0
		printk("Enabling stuff anyhow\n");
		tx_start(0);

		if (SCC_EOT(0,0)) {
			printk("TX FIFO empty.\n");
			/* Send char */
			trio_xmit_char(info->uart, info->xmit_buf[info->xmit_tail++]);
			info->xmit_tail = info->xmit_tail & (SERIAL_XMIT_SIZE-1);
			info->xmit_cnt--;
		}
#endif

	restore_flags(flags);
	return total;
}

static int rs_write_room(struct tty_struct *tty)
{
	struct trio_serial *info = (struct trio_serial *)tty->driver_data;
	int	ret;
				
	if (serial_paranoia_check(info, tty->device, "rs_write_room"))
		return 0;
	ret = SERIAL_XMIT_SIZE - info->xmit_cnt - 1;
	if (ret < 0)
		ret = 0;
	return ret;
}

static int rs_chars_in_buffer(struct tty_struct *tty)
{
	struct trio_serial *info = (struct trio_serial *)tty->driver_data;

	if (serial_paranoia_check(info, tty->device, "rs_chars_in_buffer"))
		return 0;
	return info->xmit_cnt;
}

static void rs_flush_buffer(struct tty_struct *tty)
{
	struct trio_serial *info = (struct trio_serial *)tty->driver_data;
				
	if (serial_paranoia_check(info, tty->device, "rs_flush_buffer"))
		return;
	cli();
	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
	sti();
	wake_up_interruptible(&tty->write_wait);
	if ((tty->flags & (1 << TTY_DO_WRITE_WAKEUP)) &&
	    tty->ldisc.write_wakeup)
		(tty->ldisc.write_wakeup)(tty);
}

/*
 * ------------------------------------------------------------
 * rs_throttle()
 * 
 * This routine is called by the upper-layer tty layer to signal that
 * incoming characters should be throttled.
 * ------------------------------------------------------------
 */
static void rs_throttle(struct tty_struct * tty)
{
	struct trio_serial *info = (struct trio_serial *)tty->driver_data;
#ifdef SERIAL_DEBUG_THROTTLE
	char	buf[64];
	
	printk("throttle %s: %d....\n", _tty_name(tty, buf),
	       tty->ldisc.chars_in_buffer(tty));
#endif

	if (serial_paranoia_check(info, tty->device, "rs_throttle"))
		return;
	
	if (I_IXOFF(tty))
		info->x_char = STOP_CHAR(tty);

	/* Turn off RTS line (do this atomic) */
}

static void rs_unthrottle(struct tty_struct * tty)
{
	struct trio_serial *info = (struct trio_serial *)tty->driver_data;
#ifdef SERIAL_DEBUG_THROTTLE
	char	buf[64];
	
	printk("unthrottle %s: %d....\n", _tty_name(tty, buf),
	       tty->ldisc.chars_in_buffer(tty));
#endif

	if (serial_paranoia_check(info, tty->device, "rs_unthrottle"))
		return;
	
	if (I_IXOFF(tty)) {
		if (info->x_char)
			info->x_char = 0;
		else
			info->x_char = START_CHAR(tty);
	}

	/* Assert RTS line (do this atomic) */
}

/*
 * ------------------------------------------------------------
 * rs_ioctl() and friends
 * ------------------------------------------------------------
 */

static int get_serial_info(struct trio_serial * info,
			   struct serial_struct * retinfo)
{
	struct serial_struct tmp;
  
	if (!retinfo)
		return -EFAULT;
	memset(&tmp, 0, sizeof(tmp));
	tmp.type = info->type;
	tmp.line = info->line;
	tmp.irq = info->irq;
	tmp.port = info->port;
	tmp.flags = info->flags;
	tmp.baud_base = info->baud_base;
	tmp.close_delay = info->close_delay;
	tmp.closing_wait = info->closing_wait;
	tmp.custom_divisor = info->custom_divisor;
	memcpy_tofs(retinfo,&tmp,sizeof(*retinfo));
	return 0;
}

static int set_serial_info(struct trio_serial * info,
			   struct serial_struct * new_info)
{
	struct serial_struct new_serial;
	struct trio_serial old_info;
	int 			retval = 0;

	if (!new_info)
		return -EFAULT;
	memcpy_fromfs(&new_serial,new_info,sizeof(new_serial));
	old_info = *info;

	if (!suser()) {
		if ((new_serial.baud_base != info->baud_base) ||
		    (new_serial.type != info->type) ||
		    (new_serial.close_delay != info->close_delay) ||
		    ((new_serial.flags & ~S_USR_MASK) !=
		     (info->flags & ~S_USR_MASK)))
			return -EPERM;
		info->flags = ((info->flags & ~S_USR_MASK) |
			       (new_serial.flags & S_USR_MASK));
		info->custom_divisor = new_serial.custom_divisor;
		goto check_and_exit;
	}

	if (info->count > 1)
		return -EBUSY;

	/*
	 * OK, past this point, all the error checking has been done.
	 * At this point, we start making changes.....
	 */

	info->baud_base = new_serial.baud_base;
	info->flags = ((info->flags & ~S_FLAGS) |
			(new_serial.flags & S_FLAGS));
	info->type = new_serial.type;
	info->close_delay = new_serial.close_delay;
	info->closing_wait = new_serial.closing_wait;

check_and_exit:
	retval = startup(info);
	return retval;
}

/*
 * get_lsr_info - get line status register info
 *
 * Purpose: Let user call ioctl() to get info when the UART physically
 * 	    is emptied.  On bus types like RS485, the transmitter must
 * 	    release the bus after transmitting. This must be done when
 * 	    the transmit shift register is empty, not be done when the
 * 	    transmit holding register is empty.  This functionality
 * 	    allows an RS485 driver to be written in user space. 
 */
static int get_lsr_info(struct trio_serial * info, unsigned int *value)
{
	unsigned char status;

	cli();
	status = info->uart->csr;
	status &= US_TXEMPTY;
	sti();
	put_user(status,value);
	return 0;
}

/*
 * This routine sends a break character out the serial port.
 */
static void send_break(	struct trio_serial * info, int duration)
{
	current->state = TASK_INTERRUPTIBLE;
	current->timeout = jiffies + duration;
	cli();
	info->uart->cr |= US_STTBRK;
	if(!info->use_ints){
		while(US_TXRDY != (info->uart->csr & US_TXRDY)){
			;			// this takes max 2ms at 9600
		}
		info->uart->cr |= US_STTBRK;
	}
	sti();
}

static int rs_ioctl(struct tty_struct *tty, struct file * file,
		    unsigned int cmd, unsigned long arg)
{
	int error;
	struct trio_serial * info = (struct trio_serial *)tty->driver_data;
	int retval;

	if (serial_paranoia_check(info, tty->device, "rs_ioctl"))
		return -ENODEV;

	if ((cmd != TIOCGSERIAL) && (cmd != TIOCSSERIAL) &&
	    (cmd != TIOCSERCONFIG) && (cmd != TIOCSERGWILD)  &&
	    (cmd != TIOCSERSWILD) && (cmd != TIOCSERGSTRUCT)) {
		if (tty->flags & (1 << TTY_IO_ERROR))
		    return -EIO;
	}
	
	switch (cmd) {
		case TCSBRK:	/* SVID version: non-zero arg --> no break */
			retval = tty_check_change(tty);
			if (retval)
				return retval;
			tty_wait_until_sent(tty, 0);
			if (!arg)
				send_break(info, HZ/4);	/* 1/4 second */
			return 0;
		case TCSBRKP:	/* support for POSIX tcsendbreak() */
			retval = tty_check_change(tty);
			if (retval)
				return retval;
			tty_wait_until_sent(tty, 0);
			send_break(info, arg ? arg*(HZ/10) : HZ/4);
			return 0;
		case TIOCGSOFTCAR:
			error = verify_area(VERIFY_WRITE, (void *) arg,sizeof(long));
			if (error)
				return error;
			put_fs_long(C_CLOCAL(tty) ? 1 : 0,
				    (unsigned long *) arg);
			return 0;
		case TIOCSSOFTCAR:
			arg = get_fs_long((unsigned long *) arg);
			tty->termios->c_cflag =
				((tty->termios->c_cflag & ~CLOCAL) |
				 (arg ? CLOCAL : 0));
			return 0;
		case TIOCGSERIAL:
			error = verify_area(VERIFY_WRITE, (void *) arg,
						sizeof(struct serial_struct));
			if (error)
				return error;
			return get_serial_info(info,
					       (struct serial_struct *) arg);
		case TIOCSSERIAL:
			return set_serial_info(info,
					       (struct serial_struct *) arg);
		case TIOCSERGETLSR: /* Get line status register */
			error = verify_area(VERIFY_WRITE, (void *) arg,
				sizeof(unsigned int));
			if (error)
				return error;
			else
			    return get_lsr_info(info, (unsigned int *) arg);

		case TIOCSERGSTRUCT:
			error = verify_area(VERIFY_WRITE, (void *) arg,
						sizeof(struct trio_serial));
			if (error)
				return error;
			memcpy_tofs((struct trio_serial *) arg,
				    info, sizeof(struct trio_serial));
			return 0;
			
		default:
			return -ENOIOCTLCMD;
		}
	return 0;
}

static void rs_set_termios(struct tty_struct *tty, struct termios *old_termios)
{
	struct trio_serial *info = (struct trio_serial *)tty->driver_data;

	if (tty->termios->c_cflag == old_termios->c_cflag)
		return;

	change_speed(info);

	if ((old_termios->c_cflag & CRTSCTS) &&
	    !(tty->termios->c_cflag & CRTSCTS)) {
		tty->hw_stopped = 0;
		rs_start(tty);
	}
	
}

/*
 * ------------------------------------------------------------
 * rs_close()
 * 
 * This routine is called when the serial port gets closed.  First, we
 * wait for the last remaining data to be sent.  Then, we unlink its
 * S structure from the interrupt chain if necessary, and we free
 * that IRQ if nothing is left in the chain.
 * ------------------------------------------------------------
 */
static void rs_close(struct tty_struct *tty, struct file * filp)
{
	struct trio_serial * info = (struct trio_serial *)tty->driver_data;
	unsigned long flags;

	if (!info || serial_paranoia_check(info, tty->device, "rs_close"))
		return;
	
	save_flags(flags); cli();
	
	if (tty_hung_up_p(filp)) {
		restore_flags(flags);
		return;
	}
	
#ifdef SERIAL_DEBUG_OPEN
	printk("rs_close ttyS%d, count = %d\n", info->line, info->count);
#endif
	if ((tty->count == 1) && (info->count != 1)) {
		/*
		 * Uh, oh.  tty->count is 1, which means that the tty
		 * structure will be freed.  Info->count should always
		 * be one in these conditions.  If it's greater than
		 * one, we've got real problems, since it means the
		 * serial port won't be shutdown.
		 */
		printk("rs_close: bad serial port count; tty->count is 1, "
		       "info->count is %d\n", info->count);
		info->count = 1;
	}
	if (--info->count < 0) {
		printk("rs_close: bad serial port count for ttyS%d: %d\n",
		       info->line, info->count);
		info->count = 0;
	}
	if (info->count) {
		restore_flags(flags);
		return;
	}
	// closing port so disable interrupts
	set_ints_mode(0, info);
	
	info->flags |= S_CLOSING;
	/*
	 * Save the termios structure, since this port may have
	 * separate termios for callout and dialin.
	 */
	if (info->flags & S_NORMAL_ACTIVE)
		info->normal_termios = *tty->termios;
	if (info->flags & S_CALLOUT_ACTIVE)
		info->callout_termios = *tty->termios;
	/*
	 * Now we wait for the transmit buffer to clear; and we notify 
	 * the line discipline to only process XON/XOFF characters.
	 */
	tty->closing = 1;
	if (info->closing_wait != S_CLOSING_WAIT_NONE)
		tty_wait_until_sent(tty, info->closing_wait);
	/*
	 * At this point we stop accepting input.  To do this, we
	 * disable the receive line status interrupts, and tell the
	 * interrupt driver to stop checking the data ready bit in the
	 * line status register.
	 */

	shutdown(info);
	if (tty->driver.flush_buffer)
		tty->driver.flush_buffer(tty);
	if (tty->ldisc.flush_buffer)
		tty->ldisc.flush_buffer(tty);
	tty->closing = 0;
	info->event = 0;
	info->tty = 0;
	if (tty->ldisc.num != ldiscs[N_TTY].num) {
		if (tty->ldisc.close)
			(tty->ldisc.close)(tty);
		tty->ldisc = ldiscs[N_TTY];
		tty->termios->c_line = N_TTY;
		if (tty->ldisc.open)
			(tty->ldisc.open)(tty);
	}
	if (info->blocked_open) {
		if (info->close_delay) {
			current->state = TASK_INTERRUPTIBLE;
			current->timeout = jiffies + info->close_delay;
			schedule();
		}
		wake_up_interruptible(&info->open_wait);
	}
	info->flags &= ~(S_NORMAL_ACTIVE|S_CALLOUT_ACTIVE|
			 S_CLOSING);
	wake_up_interruptible(&info->close_wait);
	restore_flags(flags);
}

/*
 * rs_hangup() --- called by tty_hangup() when a hangup is signaled.
 */
void rs_hangup(struct tty_struct *tty)
{
	struct trio_serial * info = (struct trio_serial *)tty->driver_data;
	
	if (serial_paranoia_check(info, tty->device, "rs_hangup"))
		return;
	
	rs_flush_buffer(tty);
	shutdown(info);
	info->event = 0;
	info->count = 0;
	info->flags &= ~(S_NORMAL_ACTIVE|S_CALLOUT_ACTIVE);
	info->tty = 0;
	wake_up_interruptible(&info->open_wait);
}

/*
 * ------------------------------------------------------------
 * rs_open() and friends
 * ------------------------------------------------------------
 */
static int block_til_ready(struct tty_struct *tty, struct file * filp,
			   struct trio_serial *info)
{
	struct wait_queue wait = { current, NULL };
	int		retval;
	int		do_clocal = 0;

	/*
	 * If the device is in the middle of being closed, then block
	 * until it's done, and then try again.
	 */
	if (info->flags & S_CLOSING) {
		interruptible_sleep_on(&info->close_wait);
#ifdef SERIAL_DO_RESTART
		if (info->flags & S_HUP_NOTIFY)
			return -EAGAIN;
		else
			return -ERESTARTSYS;
#else
		return -EAGAIN;
#endif
	}

	/*
	 * If this is a callout device, then just make sure the normal
	 * device isn't being used.
	 */
	if (tty->driver.subtype == SERIAL_TYPE_CALLOUT) {
		if (info->flags & S_NORMAL_ACTIVE)
			return -EBUSY;
		if ((info->flags & S_CALLOUT_ACTIVE) &&
		    (info->flags & S_SESSION_LOCKOUT) &&
		    (info->session != current->session))
		    return -EBUSY;
		if ((info->flags & S_CALLOUT_ACTIVE) &&
		    (info->flags & S_PGRP_LOCKOUT) &&
		    (info->pgrp != current->pgrp))
		    return -EBUSY;
		info->flags |= S_CALLOUT_ACTIVE;
		return 0;
	}
	
	/*
	 * If non-blocking mode is set, or the port is not enabled,
	 * then make the check up front and then exit.
	 */
	if ((filp->f_flags & O_NONBLOCK) ||
	    (tty->flags & (1 << TTY_IO_ERROR))) {
		if (info->flags & S_CALLOUT_ACTIVE)
			return -EBUSY;
		info->flags |= S_NORMAL_ACTIVE;
		return 0;
	}

	if (info->flags & S_CALLOUT_ACTIVE) {
		if (info->normal_termios.c_cflag & CLOCAL)
			do_clocal = 1;
	} else {
		if (tty->termios->c_cflag & CLOCAL)
			do_clocal = 1;
	}
	
	/*
	 * Block waiting for the carrier detect and the line to become
	 * free (i.e., not in use by the callout).  While we are in
	 * this loop, info->count is dropped by one, so that
	 * rs_close() knows when to free things.  We restore it upon
	 * exit, either normal or abnormal.
	 */
	retval = 0;
	add_wait_queue(&info->open_wait, &wait);
#ifdef SERIAL_DEBUG_OPEN
	printk("block_til_ready before block: ttyS%d, count = %d\n",
	       info->line, info->count);
#endif
	info->count--;
	info->blocked_open++;
	while (1) {
		cli();
		if (!(info->flags & S_CALLOUT_ACTIVE))
			trio_rtsdtr(info, 1);
		sti();
		current->state = TASK_INTERRUPTIBLE;
		if (tty_hung_up_p(filp) ||
		    !(info->flags & S_INITIALIZED)) {
#ifdef SERIAL_DO_RESTART
			if (info->flags & S_HUP_NOTIFY)
				retval = -EAGAIN;
			else
				retval = -ERESTARTSYS;	
#else
			retval = -EAGAIN;
#endif
			break;
		}
		if (!(info->flags & S_CALLOUT_ACTIVE) &&
		    !(info->flags & S_CLOSING) && do_clocal)
			break;
		if (current->signal & ~current->blocked) {
			retval = -ERESTARTSYS;
			break;
		}
#ifdef SERIAL_DEBUG_OPEN
		printk("block_til_ready blocking: ttyS%d, count = %d\n",
		       info->line, info->count);
#endif
		schedule();
	}
	current->state = TASK_RUNNING;
	remove_wait_queue(&info->open_wait, &wait);
	if (!tty_hung_up_p(filp))
		info->count++;
	info->blocked_open--;
#ifdef SERIAL_DEBUG_OPEN
	printk("block_til_ready after blocking: ttyS%d, count = %d\n",
	       info->line, info->count);
#endif
	if (retval)
		return retval;
	info->flags |= S_NORMAL_ACTIVE;
	if(!info->use_ints){	
		serialpoll.data = (void *)info;		
		queue_task(&serialpoll, &tq_timer);
	}
	return 0;
}	

/*
 * This routine is called whenever a serial port is opened.  It
 * enables interrupts for a serial port, linking in its S structure into
 * the IRQ chain.   It also performs the serial-specific
 * initialization for the tty structure.
 */
int rs_open(struct tty_struct *tty, struct file * filp)
{
	struct trio_serial	*info;
	int 			retval, line;

	line = MINOR(tty->device) - tty->driver.minor_start;
	
	if (line != 0) /* we have exactly one */
		return -ENODEV;

	info = &trio_info[0];
#if 0
	/* Is the kgdb running over this line? */
	if (info->kgdb_channel)
		return -ENODEV;
#endif
	if (serial_paranoia_check(info, tty->device, "rs_open"))
		return -ENODEV;
#ifdef SERIAL_DEBUG_OPEN
	printk("rs_open %s%d, count = %d\n", tty->driver.name, info->line,
	       info->count);
#endif
	info->count++;
	tty->driver_data = info;
	info->tty = tty;

	/*
	 * Start up serial port
	 */
	retval = startup(info);
	if (retval)
		return retval;
	
	retval = block_til_ready(tty, filp, info);
	if (retval) {
#ifdef SERIAL_DEBUG_OPEN
		printk("rs_open returning after block_til_ready with %d\n",
		       retval);
#endif
		return retval;
	}

	if ((info->count == 1) && (info->flags & S_SPLIT_TERMIOS)) {
		if (tty->driver.subtype == SERIAL_TYPE_NORMAL)
			*tty->termios = info->normal_termios;
		else 
			*tty->termios = info->callout_termios;
		change_speed(info);
	}

	info->session = current->session;
	info->pgrp = current->pgrp;

#ifdef SERIAL_DEBUG_OPEN
	printk("rs_open ttyS%d successful...\n", info->line);
#endif
	return 0;
}

extern void register_console(void (*proc)(const char *));
#if 0

static inline void
rs_cons_check(struct trio_serial *ss, int channel)
{
	int i, o, io;
	static consout_registered = 0;
	static msg_printed = 0;

	i = o = io = 0;

	/* Is this one of the serial console lines? */
	if((trio_cons_chanout != channel) &&
	   (trio_cons_chanin != channel))
		return;
	trio_conschan = ss->trio_channel;
	trio_consinfo = ss;

	/* Register the console output putchar, if necessary */
	if((trio_cons_chanout == channel)) {
		o = 1;
		/* double whee.. */
		if(!consout_registered) {
			register_console(trio_console_print);
			consout_registered = 1;
		}
	}

	/* If this is console input, we handle the break received
	 * status interrupt on this line to mean prom_halt().
	 */
	if(trio_cons_chanin == channel) {
		ss->break_abort = 1;
		i = 1;
	}
	if(o && i)
		io = 1;
	if(ss->baud != 9600)
		panic("Console baud rate weirdness");

	/* Set flag variable for this port so that it cannot be
	 * opened for other uses by accident.
	 */
	ss->is_cons = 1;

	if(io) {
		if(!msg_printed) {
			printk("zs%d: console I/O\n", ((channel>>1)&1));
			msg_printed = 1;
		}
	} else {
		printk("zs%d: console %s\n", ((channel>>1)&1),
		       (i==1 ? "input" : (o==1 ? "output" : "WEIRD")));
	}
}
#endif

static struct irqaction irq_usarta = { rs_interrupta, 0, 0, "usarta", NULL, NULL};
static struct irqaction irq_usartb = { rs_interruptb, 0, 0, "usartb", NULL, NULL};

extern int setup_arm_irq(int, struct irqaction *);

void interrupts_init(void)
{
	setup_arm_irq(IRQ_USARTA, &irq_usarta);
	setup_arm_irq(IRQ_USARTB, &irq_usartb);
}

/* rs_init inits the driver */
int rs_trio_init(void)
{
	int flags,i;
	struct trio_serial *info;
	/* Setup base handler, and timer table. */
	init_bh(SERIAL_BH, do_serial_bh);
	timer_table[RS_TIMER].fn = rs_timer;
	timer_table[RS_TIMER].expires = 0;

	/* Initialize the tty_driver structure */
	
	memset(&serial_driver, 0, sizeof(struct tty_driver));
	serial_driver.magic = TTY_DRIVER_MAGIC;
	serial_driver.name = "ttyS";
	serial_driver.major = TTY_MAJOR;
	serial_driver.minor_start = 64;
	serial_driver.num = 1;
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

	serial_driver.open = rs_open;
	serial_driver.close = rs_close;
	serial_driver.write = rs_write;
	serial_driver.flush_chars = rs_flush_chars;
	serial_driver.write_room = rs_write_room;
	serial_driver.chars_in_buffer = rs_chars_in_buffer;
	serial_driver.flush_buffer = rs_flush_buffer;
	serial_driver.ioctl = rs_ioctl;
	serial_driver.throttle = rs_throttle;
	serial_driver.unthrottle = rs_unthrottle;
	serial_driver.set_termios = rs_set_termios;
	serial_driver.stop = rs_stop;
	serial_driver.start = rs_start;
	serial_driver.hangup = rs_hangup;
	serial_driver.set_ldisc = rs_set_ldisc;

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
	
	save_flags(flags); cli();
	i=0;
	while(i<US_NB){
		info = &trio_info[i];
		info->magic = SERIAL_MAGIC;
		info->uart = uarts[i];
		info->tty = 0;
		info->irqmask = (i)?AIC_UB:AIC_UA;
		info->irq = (i)?IRQ_USARTB:IRQ_USARTA;
		info->port = i+1;
		set_ints_mode(0,info);
		info->custom_divisor = 16;
		info->close_delay = 50;
		info->closing_wait = 3000;
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
		info->line = 0;
		info->is_cons = (i)?0:1; /* Means shortcuts work */
		i++;
	}
	interrupts_init();
	restore_flags(flags);
// hack to do polling
	serialpoll.routine = serpoll;
	serialpoll.data = 0;
	
	return 0;
}

/*
 * register_serial and unregister_serial allows for serial ports to be
 * configured at run-time, to support PCMCIA modems.
 */
/* SPARC: Unused at this time, just here to make things link. */
int register_serial(struct serial_struct *req)
{
	return -1;
}

void unregister_serial(int line)
{
	return;
}

#if 0
/* Hooks for running a serial console.  con_init() calls this if the
 * console is being run over one of the ttya/ttyb serial ports.
 * 'chip' should be zero, as chip 1 drives the mouse/keyboard.
 * 'channel' is decoded as 0=TTYA 1=TTYB, note that the channels
 * are addressed backwards, channel B is first, then channel A.
 */
void
rs_cons_hook(int chip, int out, int channel)
{
	if(chip)
		panic("rs_cons_hook called with chip not zero");
	if(!trio_chips[chip]) {
		trio_chips[chip] = get_zs(chip);
		/* Two channels per chip */
		trio_channels[(chip*2)] = &trio_chips[chip]->channelA;
		trio_channels[(chip*2)+1] = &trio_chips[chip]->channelB;
	}
	trio_info[channel].trio_channel = trio_channels[channel];
	trio_info[channel].change_needed = 0;
	trio_info[channel].clk_divisor = 16;
	trio_info[channel].trio_baud = get_zsbaud(&trio_info[channel]);
	rs_cons_check(&trio_info[channel], channel);
	if(out)
		trio_cons_chanout = ((chip * 2) + channel);
	else
		trio_cons_chanin = ((chip * 2) + channel);

}

/* This is called at boot time to prime the kgdb serial debugging
 * serial line.  The 'tty_num' argument is 0 for /dev/ttya and 1
 * for /dev/ttyb which is determined in setup_arch() from the
 * boot command line flags.
 */
void
rs_kgdb_hook(int tty_num)
{
	int chip = 0;

	if(!trio_chips[chip]) {
		trio_chips[chip] = get_zs(chip);
		/* Two channels per chip */
		trio_channels[(chip*2)] = &trio_chips[chip]->channelA;
		trio_channels[(chip*2)+1] = &trio_chips[chip]->channelB;
	}
	trio_info[tty_num].trio_channel = trio_channels[tty_num];
	trio_kgdbchan = trio_info[tty_num].trio_channel;
	trio_info[tty_num].change_needed = 0;
	trio_info[tty_num].clk_divisor = 16;
	trio_info[tty_num].trio_baud = get_zsbaud(&trio_info[tty_num]);
	trio_info[tty_num].kgdb_channel = 1;     /* This runs kgdb */
	trio_info[tty_num ^ 1].kgdb_channel = 0; /* This does not */
	/* Turn on transmitter/receiver at 8-bits/char */
	kgdb_chaninit(&trio_info[tty_num], 0, 9600);
	ZS_CLEARERR(trio_kgdbchan);
	udelay(5);
	ZS_CLEARFIFO(trio_kgdbchan);
}
#endif
