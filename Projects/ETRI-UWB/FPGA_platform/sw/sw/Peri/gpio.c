/*----------------------------------------------------------
	File Name   : gpio.c 
	Description : GPIO API
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "gpio.h"
#include "Commonmacro.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

void GPIOOutputEnable(unsigned oe);
void GPIOWrite(unsigned data);
unsigned GPIORead(void);

void GPIOOutputEnable(unsigned oe)
{
	SMT_WRITE(GPIO0_OE, oe);
}

void GPIOWrite(unsigned data)
{
	SMT_WRITE(GPIO0_OUT, data);
}

unsigned GPIORead(void)
{
	return SMT_READ(GPIO0_IN);
}

