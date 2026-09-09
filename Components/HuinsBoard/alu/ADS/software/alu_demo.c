
#include <stdio.h>
#include "uartcomm.h"
#include "..\stripe.h"

int INPUT_OPERAND,OPERAND1,OPERAND2,i,c ;
volatile unsigned int* ALU_Op1_Addr;
volatile unsigned int* ALU_Op2_Addr;
volatile unsigned int* ALU_Operation_Addr;
volatile unsigned int* ALU_Result_Addr;
//volatile unsigned int* DPRAM_Addr;
volatile unsigned int OPERATION;
volatile unsigned int RESULT,test;
volatile int debug = 0;
char OP[2];

void EnableIRQ(void);
void get_input(void);
void get_operand(void);
void flush_input( void);

int main(void)
{
ALU_Op1_Addr = (volatile unsigned int*) (EXC_PLD_BLOCK0_BASE + 4);
ALU_Op2_Addr = (volatile unsigned int*) (EXC_PLD_BLOCK0_BASE + 8);
ALU_Operation_Addr = (volatile unsigned int*) (EXC_PLD_BLOCK0_BASE + 12); 
ALU_Result_Addr = (volatile unsigned int*) (EXC_PLD_BLOCK0_BASE + 16);
//DPRAM_Addr = (volatile unsigned int*) (EXC_DPSRAM_BLOCK0_BASE);

	EnableIRQ();
	uart_init();
//	flush_input();

   	printf("\r*******************************************\r\n");		                   
   	printf("\r* Altera Excalibur Development Board      *\r\n");		                   
   	printf("\r* Huins Co., Ltd. SoCMaster Demonstration *\r\n");		                   
   	printf("\r*******************************************\r\n");

	flush_input();

	while (1)
	{
		if (debug == 0)
		{
		printf ("Enter first operand :  ");
		get_input();
		OPERAND1 = INPUT_OPERAND;

		printf ("\r\nEnter second operand :  ");
		get_input();
		OPERAND2 = INPUT_OPERAND;
		
		printf ("\r\nEnter operation( + , - or * ) :  ");
		get_operand();
		}
	
		*ALU_Op1_Addr = OPERAND1;
		*ALU_Op2_Addr = OPERAND2;
		*ALU_Operation_Addr = OPERATION;
		test = *ALU_Op1_Addr;
		RESULT = *ALU_Result_Addr;
		//*DPRAM_Addr = ~RESULT; //inverting output to display on LEDs

		printf ("\r\n\nThe result of %u %s %u is %u .\r\n",OPERAND1, OP, OPERAND2, RESULT);
	   	printf("\r\n*******************************************\r\n");
	}
}



void flush_input(void)
{
char c;
	c = fgetc(0x0);	/* flush any stale characters */
}

void get_input(void)
{
char c;		
char input[9];
int i;
	i =0;
	while ((c = fgetc(0x0))!= '\r')
	{
		input[i++] = (char)c;
		putc(c,0x0);
		if(i >=9)
			break;
	}
	input[i] = 0x00;	/* place a string termination */
	sscanf(input, "%u", &INPUT_OPERAND);
}

void get_operand(void)
{
char c;		
	while ((c = fgetc(0x0))!= '\r')
	{
		OP[0] = c;
		OP[1]= 0x0;
		putc(c,0x0);
		switch(c)
		{
			case '+':
				OPERATION = 0x00000005;
				break;
			case '-':
				OPERATION = 0x00000006;
				break;
			case '*':
				OPERATION = 0x00000007;
				break;
			default:
				printf("\r\nInvalid operation, please enter +,-, or * .\r\n");
				OPERATION = 0x000000005;
				c = '+';
		}	
	}
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

