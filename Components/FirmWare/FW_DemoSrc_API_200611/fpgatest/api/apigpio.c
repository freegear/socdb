/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "Commonmacro.h"
#include "lib.h"
#include "irq.h"
#include "dmac.h"
#include "global.h"

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
	unsigned data_t;
	data_t = SMT_READ(GPIO_OUT);
	SMT_WRITE(GPIO_OUT, (data_t & 0xffff0000)|data);
}

unsigned short GPIO_Read()
{
	unsigned short result;
	result = SMT_READ(GPIO_IN);

	return result;
}
