#include "sysinc.h"
/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */


void GPIO_OutputEnable(unsigned short oe);
void GPIO_Write(unsigned short data);
unsigned short GPIO_Read(void);

void GPIO_OutputEnable(unsigned short oe)
{
	SMT_WRITE(GPIO_OE, oe);
}

void GPIO_Write(unsigned short data)
{
	SMT_WRITE(GPIO_OUT, data);
}

unsigned short GPIO_Read()
{
	unsigned short result;
	result = SMT_READ(GPIO_IN);

	return result;
}
