/*
* 	Copyright (c) Altera Corporation 2002.
* 	All rights reserved.
*
*	IRQ.h
*
*       Function prototypes and definitions to use the Interrupt handling routines
*/
extern enum int_mode {SIX_IND_DIFF_LEVEL, SIX_IND_SAME_LEVEL, SIX_PRIORITY, FIVE_PRIORITY} mode;

#ifndef IRQ_H
#define IRQ_H

#define INT_CTRL00_TYPE (volatile unsigned int *)
void irq_init(void);

#endif /* IRQ_H */
