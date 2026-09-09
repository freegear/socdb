/*
 * linux/arch/arm/drivers/char/serialecho.c
 *
 * Serial echoing for kernel console messages.
 */
#if defined (CONFIG_ARCH_A5K) || defined (CONFIG_ARCH_RPC) || defined(CONFIG_ARCH_EBSA110)

#include <asm/io.h>

#include <linux/serial_reg.h>

extern int serial_echo_init (int base);
extern int serial_echo_print (const char *s);

/*
 * this defines the address for the port to which printk echoing is done
 *  when CONFIG_SERIAL_ECHO is defined
 */
#ifndef SERIAL_ECHO_PORT
#define SERIAL_ECHO_PORT	0x3f8	/* internal serial port */
#endif

#ifndef SERIAL_ECHO_DIVISOR
#define SERIAL_ECHO_DIVISOR	12	/* 9600 baud */
#endif

static int serial_echo_port = 0;

#define serial_echo_outb(v,a) outb((v),(a)+serial_echo_port)
#define serial_echo_inb(a)    inb((a)+serial_echo_port)

#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)

/* wait for the transmitter & holding register to empty */
#define WAIT_FOR_XMITR \
 do { \
	lsr = serial_echo_inb (UART_LSR); \
 } while ((lsr & BOTH_EMPTY) != BOTH_EMPTY)

/*
 * These two functions abstract the actual communications with the
 * debug port.  This is so we can change the underlying communications
 * mechanism without modifying the rest of the code.
 */
int serial_echo_print (const char *s)
{
	int lsr, ier;
	int i;

	if (!serial_echo_port)
		return 0;

	/*
	 * First save the IER then disable interrupts
	 */
	ier = serial_echo_inb (UART_IER);
	serial_echo_outb (0x00, UART_IER);

	/*
	 * Now do each character
	 */
	for (i = 0; *s; i++, s++) {
		WAIT_FOR_XMITR;

		/* send the character out. */
		serial_echo_outb (*s, UART_TX);

		/* if a LF, also do CR... */
		if (*s == 10) {
			WAIT_FOR_XMITR;
			serial_echo_outb (13, UART_TX);
		}
	}

	/*
	 * Finally, wait for transmitter & holding register to empty
	 *  and restore the IER.
	 */
	WAIT_FOR_XMITR;
	serial_echo_outb (ier, UART_IER);

	return 0;
}

int serial_echo_init (int base)
{
	int comstat, hi, lo;

	if (base != 0x3f8 && base != 0x2f8) {
		serial_echo_port = 0;
		return 0;
	} else
		serial_echo_port = base;

	/*
	 * Read the Divisor Latch
	 */
	comstat = serial_echo_inb (UART_LCR);
	serial_echo_outb (comstat | UART_LCR_DLAB, UART_LCR);
	hi = serial_echo_inb (UART_DLM);
	lo = serial_echo_inb (UART_DLL);
	serial_echo_outb (comstat, UART_LCR);

	/*
	 * now do a hardwired init
	 */
	serial_echo_outb (0x03, UART_LCR); /* No parity, 8 bits, 1 stop */
	serial_echo_outb (0x83, UART_LCR); /* Access divisor latch */
	serial_echo_outb (SERIAL_ECHO_DIVISOR >> 8, UART_DLM);
	serial_echo_outb (SERIAL_ECHO_DIVISOR & 0xff, UART_DLL);
	serial_echo_outb (0x03, UART_LCR); /* Done with divisor */

	/* Prior to disabling interrupts, read the LSR and RBR
	 * registers
	 */
	comstat = serial_echo_inb (UART_LSR); /* COM? LSR */
	comstat = serial_echo_inb (UART_RX);  /* COM? RBR */
	serial_echo_outb (0x00, UART_IER);    /* Disable all interrupts */

	return 0;
}

#endif

