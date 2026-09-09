/*
*    Simple interrupt controller intialisation and fist level
*	 IRQ and FIQ handlers
*    =========================================================
*
*    Author:	PRR
*    =========================================================
*
*    Copyright (c) Altera Corporation 2000-2001.
*    All rights reserved.
*
*
*/

#include <stdio.h>
#include "../stripe.h"
#include "int_ctrl00.h"
#include "uartcomm.h"

#define INT_CTRL00_TYPE (volatile unsigned int *)
#define UART_IRQ_PRI 7
#define KEYPAD_IRQ_PRI 1

#define readb(a)	(*(volatile char *)(a))
#define writeb(v,a)	(*(volatile char *)(a)=v)
#define readw(a)	(*(volatile unsigned short *)(a))
#define writew(v,a)	(*(volatile unsigned short *)(a)=v)
#define readl(a)	(*(volatile unsigned int *)(a))
#define writel(v,a)	(*(volatile unsigned int *)(a)=v)

void uart_irq_handler(void);

void irq_init(void)
{
	/*
	*	Disable the interrupts for all the PLD sources
	*	confusingly enough these are all on by default
	*	The reason is in case people want to implement their own
	*	interrupt controller in the PLD they don't have to write 
	*	any code to enable interrupts in the Excalibur controller
	*/
	unsigned int i;
	
	*INT_MODE(EXC_INT_CTRL00_BASE) = 0x3;
	for( i = 0 ; i < 17 ; i++ )
		*INT_PRIORITY_P0(EXC_INT_CTRL00_BASE + (4 * i)) = i;

	*INT_MC(EXC_INT_CTRL00_BASE) = 	INT_MC_P0_MSK | INT_MC_P1_MSK | 
									INT_MC_P2_MSK | INT_MC_P3_MSK | 
									INT_MC_P4_MSK | INT_MC_P5_MSK;
		
	*INT_MS(EXC_INT_CTRL00_BASE)=INT_MS_P1_MSK | INT_MS_UA_MSK;

}

void CIrqHandler(void)
{
	volatile int irqID;
	unsigned int *KEY_PAD_ADDR = (unsigned int*)(EXC_PLD_BLOCK0_BASE + 4);
	
	irqID = *INT_ID(EXC_INT_CTRL00_BASE);
         
	switch (irqID)
	{
	case KEYPAD_IRQ_PRI:
		
		
	        
	          switch(*KEY_PAD_ADDR)
	          {
	            case 0 :
//	                *KEY_PAD_ADDR = 1 ;
	                printf( "Key Value : %d\r\n",1 ) ;
	                break ;
	            
	            case 2 :
	             
	                printf( "Key Value : %d\r\n", 2) ;
	                break ;
	            
	             case 1 :
	            
	                printf( "Key Value : %d\r\n", 3) ;
	                break ; 
	                
	             case 8 :
	           
	                printf( "Key Value : %d\r\n", 4) ;
	                break ;  
	            
	             case 10 :
	              
	                printf( "Key Value : %d\r\n", 5) ;
	                break ;  
	            
	             case 9 :
	               
	                printf( "Key Value : %d\r\n", 6) ;
	                break ;   
	                
	             case 4 :
	               
	                printf( "Key Value : %d\r\n", 7) ;
	                break ;   
	             
	             case 6 :
	         
	                printf( "Key Value : %d\r\n", 8) ;
	                break ;    
	                
	             case 5 :
	            
	                printf( "Key Value : %d\r\n", 9) ;
	                break ;     
	             
	             case 14 : 
	                    
	                 printf( "Key Value : %d\r\n", 0) ;
	                break ;     
	                
	              case 12 : 
	                
	                 printf( "Key Value : %c\r\n", '*' );
	                break ;         
	              
	              case 13 : 
	               
	                 printf( "Key Value : %c\r\n", '#') ;
	                break ;         
	                
	              default :
	                 
		      break;
		   
	}
	                
//		printf("%x\r\n", *KEY_PAD_ADDR );
		
//		printf("%x\r\n", readl(EXC_PLD_BLOCK0_BASE + 4));
break;
	case UART_IRQ_PRI:
//		printf("Uart Interrupt\r\n");
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
	/* This shouldn't happen, but let's trap it just in case */
	puts("Unexpected FIQ\r\n");
	return;
}






