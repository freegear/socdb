/*****************************************************************
* main.c
* Oct 14, 2002
* Rev 1
*
* This main routine intializes the VGA driver.  It set's up the 
* image size and frame buffer address, then it starts the driver.
*
* The vga_irq_handler function in the irq.c file takes care of 
* updating the images on the screen.
*
*    Copyright (c) Altera Corporation 2001-2002.
*    All rights reserved.
*
*****************************************************************/

#include <stdio.h>
#include <rt_sys.h>
#include "..\stripe.h"
#include "uartcomm.h"
#include "hex.h"

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
    
 void EnableIRQ(void);

   int main(void)                                                                                                                                
   {                                                                                        
   //	volatile int *DMA = (int*) EXC_PLD_BLOCK0_BASE;                                    
   	unsigned short *frame_buffer;                                                       
   	int count, fb_size = 320 * 240;                                                
                                                                                   
   	irq_init();                                                                        
  // 	EnableIRQ();                                                                       
   	uart_init();                                                                       
                                                                                            
   	printf("\r*******************************************\r\n");		                   
   	printf("\r* Altera Excalibur Development Board      *\r\n");		                   
   	printf("\r* Huins Co., Ltd. SoCMaster Demonstration *\r\n");		                   
   	printf("\r*******************************************\r\n");
   	printf("\rDisplay Image on TFTLCD ...................\r\n");                   
   	                                                                                   
   	frame_buffer = (unsigned short *)(EXC_SDRAM_BLOCK0_BASE + 0x100000);                           

  	                                                                                   
   	for( count = 0 ; count < fb_size ; count++ )                                       
   	{                                                                                  
   		*frame_buffer++ = hex[count];                                                   
   	}                                                                                  

   	writel( EXC_SDRAM_BLOCK0_BASE + 0x100000, (EXC_PLD_BLOCK0_BASE + 0x0) );                      
   	writel( 0x00F00140, (EXC_PLD_BLOCK0_BASE + 0x4) );                                 
   	writel( 0x00000001, (EXC_PLD_BLOCK0_BASE + 0x8) );                                 
                                                                                     
   	while(1);  // continously loop and service vga interrupts in the irq.c file        
   	                                                                                   
   } 
