/*----------------------------------------------------------
	File Name   : gpio_irq.c 
	Description : IRQ handling related routine(GPIO)
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "Commonmacro.h"
#include "irq.h"


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
static void GpioIRQHandlerMaster(unsigned irq);
static void UnknownGpioIRQ(int GPIOPin);
static void AckGpioIRQ(smtUint32 GPIOPin);
static void DisableGpioIRQ(smtUint32 GPIOPin);
static void EnableGpioIRQ(smtUint32 GPIOPin);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
#define ALL_GPIO_MASKED	0x00000000
static smtUint32 currentGpioLevel;
static smtUint32 currentGpioMask;
static ISRType GpioISRTable[32] = { 0, };	// ISR Table

// Variable to store the previous INTMASK value

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : GpioIntEnable
    Prototype       : void GpioIntEnable(void)
    Return          : void
	Argument        :
    Comments        : Register IRQ handler for GPIO0(shuld be called after VIC enabled)
-----------------------------------------------------------------------*/
void GpioIntEnable(void)
{
	int i;

	for(i = 0; i < 32; i++)
		GpioISRTable[i] = 0;

    SMT_WRITE(GPIO0_INTEN, ALL_GPIO_MASKED);	// masking all interrupt
    SMT_WRITE(GPIO0_INTLEVEL, ALL_GPIO_MASKED);
    SMT_WRITE(GPIO0_INTPOL, ALL_GPIO_MASKED);	// all interrupt active low edge triggering
	SMT_WRITE(GPIO0_INTBEDGE, ALL_GPIO_MASKED);	// Not both edge triggered

    SMT_WRITE(GPIO0_INTSTAT, ~ALL_GPIO_MASKED);	// clearing all pending interrupt

	currentGpioLevel = ALL_GPIO_MASKED;
	currentGpioMask  = ALL_GPIO_MASKED;

	RequestIRQ(IRQ_GPIO0, (ISRType)GpioIRQHandlerMaster);
}

/*-----------------------------------------------------------------------
    Function name   : GpioIntDisable
    Prototype       : void GpioIntDisable(void)
    Return          : void
	Argument        : 
    Comments        : Disable Gpio Interrupt Handler
-----------------------------------------------------------------------*/
void GpioIntDisable(void)
{
    SMT_WRITE(GPIO0_INTEN, ALL_GPIO_MASKED);
	currentGpioMask = ALL_GPIO_MASKED;
	ReleaseIRQ(IRQ_GPIO0);
}

/*-----------------------------------------------------------------------
    Function name   : RequestGpioIRQ
    Prototype       : void RequestGpioIRQ(U32, int, int, int, ISRRoutineType)
    Return          : void
	Argument        : GPIOPin => GPIOPin to connect ISR
	                : Level => when 1 when level triggered interrupt
	                : Plarity => when 1 when active high
	                : Bedge => when 1 when both edge triggered(should be Level == 0)
	                : ISR => function pointer to coresspondant ISR
    Comments        : Register ISR & unmask interrupt
-----------------------------------------------------------------------*/
void RequestGpioIRQ(smtUint32 GPIOPin, int Level, int Polarity, int Bedge, ISRType ISR)
{
	smtUint32 data;
	if(GPIOPin >= 32)
		return;

    // register ISR
    GpioISRTable[GPIOPin] = ISR;

	if(Level)
		currentGpioLevel |= (1UL << GPIOPin);
	else
		currentGpioLevel &= ~(1UL << GPIOPin);
	SMT_WRITE(GPIO0_INTLEVEL, currentGpioLevel);

	data = SMT_READ(GPIO0_INTPOL);
	if(Polarity)
		data |= (1UL << GPIOPin);
	else
		data &= ~(1UL << GPIOPin);
	SMT_WRITE(GPIO0_INTPOL, data);

	data = SMT_READ(GPIO0_INTBEDGE);
	if(Bedge)
		data |= (1 << GPIOPin);
	else
		data &= ~(1 << GPIOPin);
	SMT_WRITE(GPIO0_INTBEDGE, data);

    // unmask ISR
    EnableGpioIRQ(GPIOPin);
}

/*-----------------------------------------------------------------------
    Function name   : ReleaseGpioIRQ
    Prototype       : void ReleaseGpioIRQ(int GPIOPin)
    Return          : void
	Argument        : GPIOPin => GPIOPin number you want to disable
    Comments        : Do mask interrupt
-----------------------------------------------------------------------*/
void ReleaseGpioIRQ(smtUint32 GPIOPin)
{
	if(GPIOPin >= 32)
		return;

    // mask ISR
    DisableGpioIRQ(GPIOPin);
    // unregister ISR
    ISRTable[GPIOPin] = (ISRType)((void *)(0));
}

/*-----------------------------------------------------------------------
    Function name   : EnableGpioIRQ
    Prototype       : void EnableGpioIRQ(smtUint32 GPIOPin)
    Return          : void
	Argument        : GPIOPin => GPIOPin number you want to enable
    Comments        : unmask interrupt
-----------------------------------------------------------------------*/
static void EnableGpioIRQ(smtUint32 GPIOPin)
{
    smtUint32 regINTMSK;

    // unmask ISR
    regINTMSK = SMT_READ(GPIO0_INTEN);
    regINTMSK |= (1<<GPIOPin);
	currentGpioMask |=(1<<GPIOPin);
    SMT_WRITE(GPIO0_INTEN, regINTMSK);
}

/*-----------------------------------------------------------------------
    Function name   : DisableIRQ
    Prototype       : void DisableIRQ(smtUint32 GPIOPin)
    Return          : void
	Argument        : GPIOPin => GPIOPin number you want to disable
    Comments        : Do mask interrupt
-----------------------------------------------------------------------*/
static void DisableGpioIRQ(smtUint32 GPIOPin)
{
    smtUint32 regINTMSK;

    // mask ISR
    regINTMSK = SMT_READ(GPIO0_INTEN);
    regINTMSK &= ~(1<<GPIOPin);
	currentGpioMask &=~(1<<GPIOPin);
    SMT_WRITE(GPIO0_INTEN, regINTMSK);
}

/*-----------------------------------------------------------------------
    Function name   : AckIRQ
    Prototype       : void AckIRQ(ismtUint32nt GPIOPin)
    Return          : void
	Argument        : GPIOPin => GPIOPin number you want to Acknowledge
    Comments        : Clear pending interrupt when edge triggered interrupt
	                : Do nothing when level triggered interrupt
-----------------------------------------------------------------------*/
static void AckGpioIRQ(smtUint32 GPIOPin)
{
    if((~currentGpioLevel) & (1<<GPIOPin))	// Edge triggered interrupt
		SMT_WRITE(GPIO0_INTSTAT, (1<<GPIOPin));
}

/*-----------------------------------------------------------------------
    Function name   : UnknownGpioIRQ()
    Prototype       : void UnknownGpioIRQ(int GPIOPin)
    Return          : void
    Argument        :
    Comments        : called when No ISR registered
-----------------------------------------------------------------------*/
static void UnknownGpioIRQ(int GPIOPin)
{
    static int unknownGpioIRQCount = 0;

    unknownGpioIRQCount++;
}

/*-----------------------------------------------------------------------
    Function name   : GpioIRQHandlerMaster(int irq)
    Prototype       : void GpioIRQHandlerMaster(int irq)
    Return          : void
    Argument        :
    Comments        : called from InterruptHandler
-----------------------------------------------------------------------*/
extern void UartPrintf(const char *fmt, ...);
static void GpioIRQHandlerMaster(unsigned irq)
{
	int i;
	smtUint32 int_pend;
	smtUint32 int_pend_masked;
	smtUint32 int_enable;

	int_pend = SMT_READ(GPIO0_INTSTAT);
	int_enable = SMT_READ(GPIO0_INTEN);
	int_pend_masked = int_pend & int_enable;

	do
	{
		for(i = 0; i < 32; i++)
		{
			if(int_pend_masked & 0x01)
			{
				AckGpioIRQ(i);
				DisableGpioIRQ(i);
				if(GpioISRTable[i] != 0)
					GpioISRTable[i](i);
				else
					UnknownGpioIRQ(i);
				EnableGpioIRQ(i);
			}

			int_pend_masked >>= 1;
		}
		int_pend = SMT_READ(GPIO0_INTSTAT);
		int_enable = SMT_READ(GPIO0_INTEN);
		int_pend_masked = int_pend & int_enable;
	} while(int_pend_masked != 0);
}
