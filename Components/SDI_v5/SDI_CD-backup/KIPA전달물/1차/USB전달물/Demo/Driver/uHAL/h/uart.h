/***************************************************************************
 * Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
 * Copyright © ARM Limited 1998.  All rights reserved.
 ***************************************************************************/
/*****************************************************************************

  Defines, Structures, Routines used & defined in StrongARM library.

******************************************************************************/
#ifdef UARTS
#if UARTS != 0
#ifndef _UART_
#define _UART_

/* Line status register */
#define LineDRMsk		0x1	/* Data ready */
#define LineOEMsk		0x2	/* Overrun Error */
#define LinePEMsk		0x4	/* Parity Error */
#define LineFEMsk		0x8	/* Framing Error */
#define LineBIMsk		0x10	/* Break interrupt signal */
#define LineTHREMsk		0x20	/* Transmitter holding register empty (i.e. ready for next char) */
#define LineTEMTMsk		0x40	/* Transmitter empty (inc. FIFO if in use) */
#define LineRFEMsk		0x80	/* Receive FIFO error */

/* 
 * Receive, Transmit, Interupt enable, Interrupt Identitication and
 * FIFO are only 
 * accesable when the Divisor latch access bit in the line control
 * register is 0
 */
#define Rx		0x0	/* Receive port, read only */
#define Tx		0x0	/* Transmit port, write only */
#define IntEnable	0x1	/* Interrupt enable, read/write */
#define IntId		0x2	/* Interrupt id, read only */
#define FIFOcntl	0x2	/* FIFO control, write only */
#define LineCntl	0x3	/* Line control, word len, stop bits, parity */
#define ModmCntl	0x4	/* Modem control, DTR, RTS */
#define LineStatus	0x5	/* Transmit status */
#define LoBaud		0x0	/* Baud Rate - Low Byte */
#define HiBaud		0x1	/* Baud Rate - High Byte */

#define L1200BD		96	/* Clock rates */
#define H1200BD		 0
#define L2400BD		24
#define H2400BD		 0
#define L9600BD		12
#define H9600BD		 0
#define L19200BD	 6
#define H19200BD	 0
#define L38400BD	 3
#define H38400BD	 0

#define BAUDLOCK	0x80	/* Serial data attributes */
#define BITS8		 3
#define BITS7		 2
#define BITS6		 1
#define BITS5		 0
#define PARITY		0x08
#define EVEN		0x10
#define EVENPARITY	(EVEN & PARITY)
#define ODDPARITY	(PARITY)

#define NO_INTS		 0
#define MCR_IRQ_ENABLE	 8

#define READ_INTERRUPT(p)	inb( (void *)(p + IntId) )
/* Enable & disable both write the value to the same address */
#define ENABLE_INT(v, b, p)	outb(v, (void *)((p) + IntEnable))
#define DISABLE_INT(v, b, p)	outb(v, (void *)((p) + IntEnable))
#define ENABLE_INTERRUPT(p)	outb(MCR_IRQ_ENABLE, (void *)((p) + ModmCntl) )

#define TX_READY(a)		((a) & LineTHREMsk)	/* Check Tx Ready bit */
#define RX_DATA(a)		((a) & LineDRMsk)
#define GET_STATUS(p)		(inb( (void *)((p) + LineStatus) ) & 0xFF)
#define GET_CHAR(p)		(inb((void *)((p) + Rx)))
#define PUT_CHAR(p, c)		(outb(c, (void *)((p) + Tx)))

#endif 
#endif 
#endif 
