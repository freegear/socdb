

#include <stdio.h>
#include "uartcomm.h"
#include "..\stripe.h"
volatile unsigned int* SEG_ADD;
volatile unsigned int* LCD_ADD1;

void EnableIRQ(void);
void Scroll_PLD(void);
void delay(unsigned int);
void lcd_init(void);
void lcd_display1(void);
void lcd_display2(void);

int main(void)
{

	uart_init();
	EnableIRQ();	// Enable processor interrupts
		
   	printf("\r*******************************************\r\n");		                   
   	printf("\r* Altera Excalibur Development Board      *\r\n");		                   
   	printf("\r*       SangHwa Micro Technology          *\r\n");		                   
   	printf("\r*******************************************\r\n");
   	printf("\rDisplay Text LCD and 7-Segment ...........\r\n");
    lcd_init();
	while (1)
	{   
	    Scroll_PLD();
    }
}

void lcd_init(void)
{
	int i;
	LCD_ADD1 = (volatile unsigned int*) (EXC_PLD_BLOCK0_BASE + 260);		
    for(i=0;i<40;i++)
	{
		*LCD_ADD1=0x80;
	    LCD_ADD1++;
	}
}

void lcd_display1(void)
{
	int i, num;
	                       //1---------1---------/1---------1---------//
    unsigned char disp[41]={"  SoCMaster-XP8000   SoC Development Kit "}; 
	LCD_ADD1 = (volatile unsigned int*) (EXC_PLD_BLOCK0_BASE + 260);
	
    for (i=0; i<41; i++)
	{
		*LCD_ADD1=disp[i];
	    LCD_ADD1++; 
	}
}

void lcd_display2(void)
{
	int i, num;
	                       //1---------1---------/1---------1---------//
    unsigned char disp[41]={"          SangHwa Micro Technology       "}; 	
	LCD_ADD1 = (volatile unsigned int*) (EXC_PLD_BLOCK0_BASE + 260);

    for (i=0; i<41; i++)
	{
		*LCD_ADD1=disp[i];
	    LCD_ADD1++; 
	}
}	
		
void Scroll_PLD(void)
{
	int i,j,k,l;
	int value=0x41;
	SEG_ADD = (volatile unsigned int*) (EXC_PLD_BLOCK0_BASE + 4);
	LCD_ADD1 = (volatile unsigned int*) (EXC_PLD_BLOCK0_BASE + 260);

	for(l=0;l<10; l++)
	{
		for(k=0; k<10; k++)
		{
			for( j=0; j < 10 ; j++)
			{	//LSB Digit  
				for(i = 0; i < 10; i++)
				{
		    	    *SEG_ADD=(l<<12)+(k<<8)+(j<<4)+i;
                    lcd_display1();
                    delay(3000000);
                    lcd_display2();
                    delay(3000000);
				}
			}
		}
	}
	
				
}

void delay(unsigned int time)
{
	volatile unsigned int i;
	for(i = 0; i < time; i++);
}

void CAbtHandler(void)
{
	printf("Data abort\r\n");
}

void CPabtHandler(void)
{
	printf("Error prefetch abort\r\n");
}

void CDabtHandler(void)
{
	printf("Error data abort\r\n");
}

void CSwiHandler(void)
{
	printf("Error swi\r\n");
}

void CUdefHandler(void)
{
	printf("Error undefined instruction\r\n");
}
