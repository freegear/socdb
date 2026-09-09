/*
*    Simple interrupt controller intialisation and fist level
*	 IRQ and FIQ handlers
*
*    Copyright (c) Altera Corporation 2001-2002.
*    All rights reserved.
*/

#include <stdio.h>

#include "irq.h"

#include "../stripe.h"
#include "int_ctrl00.h"
#include "uartcomm.h"

#define INT_CTRL00_TYPE (volatile unsigned int *)
#define PLDINT0_FIQ_PRI		INT_PRIORITY_P1_FQ_MSK
#define PLDINT1_IRQ_PRI		1
#define PLDINT2_IRQ_PRI		2
#define PLDINT3_IRQ_PRI		3
#define PLDINT4_IRQ_PRI		4
#define PLDINT5_IRQ_PRI		5
#define PLDINT_IRQ_PRI		1
#define UART_IRQ_PRI		10


#define readw(a)	(*(volatile unsigned short *)(a))
#define writew(v,a)	(*(volatile unsigned short *)(a)=v)
#define readl(a)	(*(volatile unsigned int *)(a))
#define writel(v,a)	(*(volatile unsigned int *)(a)=v)
#define outb(v,a) (*(volatile unsigned char*)(a)=v)
#define inb(a)    (*(volatile unsigned char*)(a))
#define outw(v,a) (*(volatile unsigned short*)(a)=v)
#define inw(a)    (*(volatile unsigned short*)(a))
#define outl(v,a) (*(volatile unsigned int*)(a)=v)
#define inl(a)    (*(volatile unsigned int*)(a))



static int i = 0;  // loop index for vga_irq_handler
static int address = 0;  // image address for vga_irq_handler
static int size = 1; // pixel mode for vga_irq_handler

void uart_irq_handler(void);
void vga_irq_handler(void);

void irq_init(void)
{
	/*
	*	Disable the interrupts for all the PLD sources
	*	confusingly enough these are all on by default
	*	The reason is in case people want to implement their own
	*	interrupt controller in the PLD they don't have to write 
	*	any code to enable interrupts in the Excalibur controller
	*/
	*INT_MC(EXC_INT_CTRL00_BASE) = 	INT_MC_P0_MSK | INT_MC_P1_MSK | 
									INT_MC_P2_MSK | INT_MC_P3_MSK | 
									INT_MC_P4_MSK | INT_MC_P5_MSK;
		
	/* 
	* Set priority for the UART interrupts
	*/
	*INT_PRIORITY_UA(EXC_INT_CTRL00_BASE)=UART_IRQ_PRI;

	/*
	*	Enable the UART interrupt 
	*/
	*INT_MS(EXC_INT_CTRL00_BASE)= INT_MS_UA_MSK;
	
	// Set interrupt mode to Six Individual Interrupts from the PLD
	*INT_MODE(EXC_INT_CTRL00_BASE) = INT_MODE_SIX_IND;
	
	// Set each PLD interrupt with different priority levels.
	// INT_PLD[0] generates a FIQ interrupt, while INT_PLD[1-5]
	// generate an IRQ interrupt.		
	*INT_PRIORITY_P0(EXC_INT_CTRL00_BASE) = PLDINT0_FIQ_PRI;	
	*INT_PRIORITY_P1(EXC_INT_CTRL00_BASE) = PLDINT1_IRQ_PRI;
	*INT_PRIORITY_P2(EXC_INT_CTRL00_BASE) = PLDINT2_IRQ_PRI;
	*INT_PRIORITY_P3(EXC_INT_CTRL00_BASE) = PLDINT3_IRQ_PRI;	
	*INT_PRIORITY_P4(EXC_INT_CTRL00_BASE) = PLDINT4_IRQ_PRI;
	*INT_PRIORITY_P5(EXC_INT_CTRL00_BASE) = PLDINT5_IRQ_PRI;
	
	// Enable PLD interrupts
	*INT_MS(EXC_INT_CTRL00_BASE) |= INT_MS_P0_MSK | INT_MS_P1_MSK | INT_MS_P2_MSK |
						   		    INT_MS_P3_MSK | INT_MS_P4_MSK | INT_MS_P5_MSK;	
}

void CIrqHandler(void)
{
	volatile int irqID;
	
	irqID = *INT_ID(EXC_INT_CTRL00_BASE);

	switch (irqID)
	{
		case PLDINT1_IRQ_PRI:
			vga_irq_handler();
		case UART_IRQ_PRI:
			uart_irq_handler();
			break;
		default:
			/* This shouldn't happen, but let's trap it in case */
			printf("Unknown irq %#x",irqID);
			break;		
	}
	
	return;
}

void CFiqHandler(void)
{
	/* This shouldn't happen */
	return;
}

void vga_irq_handler(void)
{

	writel( EXC_SDRAM_BLOCK0_BASE + 0x100000, ( EXC_PLD_BLOCK0_BASE + 0x0 ) );

}




