/*
* 	General UART IO functions (interrupt driven), these implement fputc and fgetc
* 	which enables printf to be available from the target. It is configured by default
*	for a baud rate of 38400, 8 bits per character, 1 stop bit, no parity, with no flow
*	control.
*
* 	Copyright (c) Altera Corporation 2000-2001.
*/

#include <stdio.h>
#include "..\stripe.h"
#include "uart00.h"
#include "uartcomm.h"
#include "int_ctrl00.h"

#define UART00_TYPE (volatile unsigned int*)
#define BUFF_SIZE 1024
#define BUFF_MASK 0x3ff
#define DIVISOR_FROM_BAUD(baud,clk) ((clk) /(16*(baud)))

static char tx_buffer[BUFF_SIZE];
static char rx_buffer[BUFF_SIZE];
static volatile int tx_head,tx_tail,rx_head,rx_tail;

void uart_init(void)
{
    /* setup the rx and tx circular buffers */
	
	rx_head=rx_tail=0;
	tx_head=tx_tail=0;

	irq_init();
     
	/* 
	 * configure the uart for 38400 baud, 8 data, 
	 * 1 stop, no parity
	 */

	*UART_MC(EXC_UART00_BASE) = UART_MC_CLS_CHARLEN_8;
	*UART_DIV_LO(EXC_UART00_BASE) = DIVISOR_FROM_BAUD(115200,EXC_AHB2_CLK_FREQUENCY)& 0xFF;
	*UART_DIV_HI(EXC_UART00_BASE) = (DIVISOR_FROM_BAUD(115200,EXC_AHB2_CLK_FREQUENCY)& 0xFF00) >> 8;

	/* Setup and clear FIFOs */
	*UART_FCR(EXC_UART00_BASE)=UART_FCR_RX_THR_1 | UART_FCR_TX_THR_2 | 
		UART_FCR_RC_MSK | UART_FCR_TC_MSK;
		
	/* Clear pending interrupt */
	*UART_IEC(EXC_UART00_BASE) = UART_IEC_RE_MSK | UART_IEC_TE_MSK;

	/* Enable receive & transmit interrupts */
	*UART_IES(EXC_UART00_BASE)=UART_IES_RE_MSK;
}


static void uart_tx_handler(void)
{
	int dummy;
	/* Read the status register to clear the interrupt */
	dummy=*UART_TSR(EXC_UART00_BASE);

	/* 
	 * Write data to the fifo until it either 
	 * fills up, or we run out of stuff in the
	 * tx buffer 
	 */
	
       
	while(((*UART_TSR(EXC_UART00_BASE) & UART_TSR_TX_LEVEL_MSK)<15)&&
	      (tx_head!=tx_tail))
	{
				
		/* transmit the next character */
		*UART_TD(EXC_UART00_BASE)=tx_buffer[tx_head++];
		tx_head&=BUFF_MASK;
	}
	/* 
	 * If there's nothing left to transmit, turn the 
	 * interrupt off 
	 */
	if(tx_head==tx_tail)
	{
		*UART_IEC(EXC_UART00_BASE)=UART_IEC_TE_MSK;
	}
	else
	{
		*UART_IES(EXC_UART00_BASE) = UART_IES_TE_MSK;
	}

}

static void uart_rx_handler(void)
{
	int next_loc;

	/* Read the status register to clear the interrupt */
	next_loc=*UART_RSR(EXC_UART00_BASE);    
	 
	do
	{
	      next_loc=(rx_tail+1)&BUFF_MASK;
	      if(next_loc==rx_head)
		  {
		      /* 
		       * Hmm, the buffer is full so we'll
		       * ditch the stuff in the fifo
		       */
		      *UART_FCR(EXC_UART00_BASE)=UART_FCR_RC_MSK;
		      break;
	      }
		/* receive the next character */
		rx_buffer[rx_tail]=*UART_RD(EXC_UART00_BASE);
		rx_tail++;
		rx_tail&=BUFF_MASK;

	} while(*UART_RSR(EXC_UART00_BASE) & UART_RSR_RX_LEVEL_MSK);
}

void uart_irq_handler(void)
{
       
	while(*UART_IID(EXC_UART00_BASE) & UART_IID_IID_MSK)
	{
		switch(*UART_IID(EXC_UART00_BASE) & UART_IID_IID_MSK)
		{
		case UART_IID_IID_RI:

			uart_rx_handler();
			break;
			
		case UART_IID_IID_TI:
			uart_tx_handler();
			break;

		case UART_IID_IID_TII:
		case UART_IID_IID_MI:
		default:

			/* 
			 * Tricky to know what to do here
			 * so we'll do nothing and hope the 
			 * irq goes away. We'll probably just
			 * get stuck in the while loop, but 
			 * there we go.
			 */
			break;
		}
	}
}

static void uart_start_tx(void)
{
	/*
	 * if the tx interrupt is already running
	 * then we need do nothing. Otherwise calling
	 * the tx handler shoud kick things off 
	 */
	if(!(*UART_IES(EXC_UART00_BASE) & UART_IES_TE_MSK))
	{
		uart_tx_handler();
	}
}

/*
*	Simple implementation of putc, should probably beef this up to be interrupt driver
*/
extern int fputc(int ch, FILE *f)
{
	/* Copy the character into the tx buffer */
	tx_buffer[tx_tail++]=(char)ch;
	tx_tail&=BUFF_MASK;
	if(tx_tail==tx_head)
	{
		return EOF;
	}
		
	/* Give the transmitter a kick */
	uart_start_tx();

	/* Everything is OK... */
	return 0;
}

extern int fgetc( FILE *f)
{
	int character;
	
	while(rx_head==rx_tail);
	character=rx_buffer[rx_head++];
	rx_head&=BUFF_MASK;
	return character;
}
