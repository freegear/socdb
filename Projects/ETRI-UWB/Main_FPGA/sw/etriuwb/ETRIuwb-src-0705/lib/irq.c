/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: irq.c 
	Description	: IRQ handling related routine(VIC)
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
	INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "irq.h"

#include "uart_pre_drv.h"
#include "uart_post_drv.h"

/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
	VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/

#define ALL_MASKED	0xFFFFFFFF
static smtUint32 currentLevel;
static ISRType ISRTable[32] = { 0, };	// ISR Table


/*
/////////////////////////////////////////////////////////
	FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: EnableVIC
	Prototype		: void EnableVIC(smtUint32 , smtUint32 , smtUint32)
	Return			: void
	Argument		:
		Polarity	=> value to write into POLARITY register
		Level	=> value to write into LEVEL register
		IntMod	=> value to write into INTMOD register.
	Comments		:
		Register ISR & Enable VIC
----------------------------------------------------------*/
void EnableVIC(smtUint32 Polarity, smtUint32 Level, smtUint32 IntMod)
{
	smtUint32 regINTCON;

	// set GIE, VECTORED, nIRQ, nFIQ to 1(disable)
	regINTCON = INT_GIE_EN | INT_VECT_EN | INT_IRQ_EN | INT_FIQ_EN;
	SMT_WRITE(INTCON, regINTCON);

	SMT_WRITE(POLARITY, Polarity);
	SMT_WRITE(LEVEL, Level);
	SMT_WRITE(INTMOD, IntMod);
	SMT_WRITE(INTMSK, ALL_MASKED);

#if VICSCHEDULE_NOT_SUPPORTED
	// IPMST & F_PMST default master/slave operating mode -> Round-robin
	SMT_WRITE(I_PMST,
		(0<<SHIFT_DN_FROM_MASK(INT_MASTER_MODE_SEL)) |
		(0<<SHIFT_DN_FROM_MASK(INT_SLAVE_MODE_SEL)) |
		(0<<SHIFT_DN_FROM_MASK(INT_SLV0_PRIORITY)) |
		(1<<SHIFT_DN_FROM_MASK(INT_SLV1_PRIORITY)) |
		(2<<SHIFT_DN_FROM_MASK(INT_SLV2_PRIORITY)) |
		(3<<SHIFT_DN_FROM_MASK(INT_SLV3_PRIORITY)) );

	SMT_WRITE(F_PMST,
		(0<<SHIFT_DN_FROM_MASK(INT_MASTER_MODE_SEL)) |
		(0<<SHIFT_DN_FROM_MASK(INT_SLAVE_MODE_SEL)) |
		(0<<SHIFT_DN_FROM_MASK(INT_SLV0_PRIORITY)) |
		(1<<SHIFT_DN_FROM_MASK(INT_SLV1_PRIORITY)) |
		(2<<SHIFT_DN_FROM_MASK(INT_SLV2_PRIORITY)) |
		(3<<SHIFT_DN_FROM_MASK(INT_SLV3_PRIORITY)) );
#endif

	currentLevel = Level;
	regINTCON = 0x00000000;	// set GIE, VECTORED, nIRQ, nFIQ to 0(enable)
	SMT_WRITE(INTCON, regINTCON);
}

/*----------------------------------------------------------
	Function name	: DisableVIC
	Prototype		: void DisableVIC(void)
	Return			: void
	Argument		: 
	Comments		: Disable VIC
----------------------------------------------------------*/
void DisableVIC(void)
{
	smtUint32 regINTCON;

	// set GIE, VECTORED, nIRQ, nFIQ to 1(disable)
	regINTCON = INT_GIE_EN | INT_VECT_EN | INT_IRQ_EN | INT_FIQ_EN;
	SMT_WRITE(INTCON, regINTCON);
}

/*----------------------------------------------------------
	Function name	: RequestIRQ
	Prototype		: void RequestIRQ(int IRQ, ISRRoutineType ISR)
	Return			: void
	Argument		:
		IRQ => IRQ number you want to enable
		ISR => function pointer to coresspondant ISR
	Comments		:
		Register ISR & unmask interrupt
----------------------------------------------------------*/
void RequestIRQ(smtUint32 IRQ, ISRType ISR)
{
	ISRTable[IRQ] = ISR;
	EnableIRQ(IRQ);
}

/*----------------------------------------------------------
	Function name	: ReleaseIRQ
	Prototype		: void ReleaseIRQ(int IRQ)
	Return			: void
	Argument		: IRQ => IRQ number you want to disable
	Comments		: Do mask interrupt
----------------------------------------------------------*/
void ReleaseIRQ(smtUint32 IRQ)
{
	// unregister ISR
	ISRTable[IRQ] = (ISRType)((void *)(0));
	// mask ISR
	DisableIRQ(IRQ);
}

/*----------------------------------------------------------
	Function name	: EnableIRQ
	Prototype		: void EnableIRQ(smtUint32 IRQ)
	Return			: void
	Argument		: IRQ => IRQ number you want to enable
	Comments		: unmask interrupt
----------------------------------------------------------*/
void EnableIRQ(smtUint32 IRQ)  // UnmaskIRQ
{
	smtUint32 regINTMSK;

	// unmask ISR
	regINTMSK = SMT_READ(INTMSK);
	regINTMSK &= ~(1<<IRQ);
	SMT_WRITE(INTMSK, regINTMSK);
}

/*----------------------------------------------------------
	Function name	: DisableIRQ
	Prototype		: void DisableIRQ(smtUint32 IRQ)
	Return			: void
	Argument		: IRQ => IRQ number you want to disable
	Comments		: Do mask interrupt
----------------------------------------------------------*/
void DisableIRQ(smtUint32 IRQ) //MaskIRQ
{
	smtUint32 regINTMSK;

	// mask ISR
	regINTMSK = SMT_READ(INTMSK);
	regINTMSK |= (1<<IRQ);
	SMT_WRITE(INTMSK, regINTMSK);

	if(INTPND & (1<<IRQ))
		SMT_WRITE(I_ISPC, (1<<IRQ));	// clear INTPND if IRQ
}

/*----------------------------------------------------------
	Function name	: AckIRQ
	Prototype		: void AckIRQ(ismtUint32nt IRQ)
	Return			: void
	Argument		: IRQ => IRQ number you want to Acknowledge
	Comments		:
		Clear pending interrupt when edge triggered interrupt
		Do nothing when level triggered interrupt
----------------------------------------------------------*/
void AckIRQ(smtUint32 IRQ)
{
	smtUint32 regI_ISPR;

	if((~currentLevel) & (1<<IRQ))	// Edge triggered interrupt
	{
		regI_ISPR = SMT_READ(I_ISPR);
		SMT_WRITE(I_ISPC, regI_ISPR);
	}
}



/*----------------------------------------------------------
	Function name	: AckIRQ
	Prototype		: void AckIRQ(ismtUint32nt IRQ)
	Return			: void
	Argument		: IRQ => IRQ number you want to Acknowledge
	Comments		:
		Clear pending interrupt when edge triggered interrupt
		Do nothing when level triggered interrupt
----------------------------------------------------------*/
void InterruptHandler(void)
{
	unsigned irq;
	
	while(1)
	{
		if(SMT_READ(I_ISPR) == 0)	// Check if something is wrong
			break;


		irq = SMT_READ(I_VECADDR);
		irq >>= 2;


		AckIRQ(irq);		// Mask IRQ
		if(ISRTable[irq] != 0)
		{
			ISRTable[irq](irq);
		}
		else
		{
			smt2UartPrint(11, "Unknown IRQ");
		}

		EnableIRQ(irq);
	}
}


/*----------------------------------------------------------
	Function name	: UndefHandler
	Prototype		: void UndefHandler(ismtUint32nt IRQ)
	Return			: void
	Argument		: IRQ => IRQ number you want to Acknowledge
	Comments		:
		Clear pending interrupt when edge triggered interrupt
		Do nothing when level triggered interrupt
----------------------------------------------------------*/
void UndefHandler(int IRQ)
{
	smt2UartPrint(11, "UndefHandler()\n");
}


///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
// GPIO IRQ Handler

#define ALL_GPIO_MASKED	0x00000000

static ISRType GpioISRTable[32] = { 0, };	// ISR Table

/*----------------------------------------------------------
	Function name	: RequestGpioIRQ()
	Prototype		: void RequestGpioIRQ(smtUint32 GPIOPin, ISRType ISR)
	Return		: void
	Argument	:
	Comments	: Regist GPIO ISR and enable relative GPIO pin
----------------------------------------------------------*/
void RequestGpioIRQ(smtUint32 GPIOPin, ISRType ISR)
{
	if(GPIOPin >= 32)
		return;

	GpioISRTable[GPIOPin] = ISR;
	// unmask ISR
	EnableGpioIRQ(GPIOPin);
}

/*----------------------------------------------------------
	Function name	: ReleaseGpioIRQ()
	Prototype		: void ReleaseGpioIRQ(smtUint32 IRQ)
	Return		: void
	Argument	:
	Comments	: Unregist GPIO ISR
----------------------------------------------------------*/
void ReleaseGpioIRQ(smtUint32 IRQ)
{
	// unregister ISR
	GpioISRTable[IRQ] = (ISRType)((void *)(0));
	// mask ISR
	DisableGpioIRQ(IRQ);
}

/*----------------------------------------------------------
	Function name	: EnableGpioIRQ()
	Prototype		: void EnableGpioIRQ(smtUint32 GPIOPin)
	Return		: void
	Argument	:
	Comments	: Enable GPIO interrupt
----------------------------------------------------------*/
void EnableGpioIRQ(smtUint32 GPIOPin)
{
    smtUint32 regINTMSK;

    // unmask ISR
    regINTMSK = SMT_READ(GPIO0_INTEN);
    regINTMSK |= (1<<GPIOPin);
    SMT_WRITE(GPIO0_INTEN, regINTMSK);
}

/*----------------------------------------------------------
	Function name	: DisableGpioIRQ()
	Prototype		: void DisableGpioIRQ(smtUint32 GPIOPin)
	Return		: void
	Argument	:
	Comments	: Disable GPIO interrupt
----------------------------------------------------------*/
void DisableGpioIRQ(smtUint32 GPIOPin)
{
    smtUint32 regINTMSK;

    // mask ISR
    regINTMSK = SMT_READ(GPIO0_INTEN);
    regINTMSK &= ~(1<<GPIOPin);
    SMT_WRITE(GPIO0_INTEN, regINTMSK);
}

/*----------------------------------------------------------
	Function name	: AckGpioIRQ()
	Prototype		: void AckGpioIRQ(smtUint32 GPIOPin)
	Return		: void
	Argument	:
	Comments	: GPIO interrupt status clear
----------------------------------------------------------*/
void AckGpioIRQ(smtUint32 GPIOPin)
{
	smtUint32 level, data;
	
	data = SMT_READ(GPIO0_INTSTAT);

	if(level)
		data |= (1UL << GPIOPin);
	else
		data &= ~(1UL << GPIOPin);
	SMT_WRITE(GPIO0_INTSTAT, data);
}

/*----------------------------------------------------------
	Function name	: UnknownIRQ()
	Prototype		: void UnknownIRQ(int IRQ)
	Return		: void
	Argument	:
	Comments	: called when nIRQ=low & No ISR registered
----------------------------------------------------------*/
void UnknownGpioIRQ(smtUint32 GPIOPin)
{
    static smtUint32 unknownGpioIRQCount = 0;

	smt2UartPrint(11, "UnknownGpioIRQ\n");

    unknownGpioIRQCount++;
}

/*----------------------------------------------------------
	Function name	: GpioIRQHandler()
	Prototype		: void GpioIRQHandler(smtUint32 IRQ)
	Return		: void
	Argument	:
	Comments	: GPIO interrupt handler
----------------------------------------------------------*/
void GpioIRQHandler(smtUint32 irq)
{
	smtUint32 i;
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


/*-----------------------------------------------------------------------
	Function name: GpioInitInterrupt
	Prototype		: void GpioInitInterrupt(GPIO_STRUCT gpio)
	Return		: void
	Argument	:
	Comments	: Register IRQ handler for GPIO0(shuld be called after VIC enabled)
-----------------------------------------------------------------------*/
void GpioInitInterrupt(GPIO_STRUCT gpio)
{
	smtUint32 i;

	for(i = 0; i < 32; i++)
		GpioISRTable[i] = 0;

	SMT_WRITE(GPIO0_INTEN, 0);		// masking all interrupt
	SMT_WRITE(GPIO0_INTLEVEL, 0);	// Edge trigger
	SMT_WRITE(GPIO0_INTPOL, 0);		// all interrupt active low edge triggering
	SMT_WRITE(GPIO0_INTBEDGE, 0);	// Not both edge triggered
	SMT_WRITE(GPIO0_INTSTAT, ~0);	// clearing all pending interrupt 

	RequestIRQ(IRQ_GPIO0, (ISRType)GpioIRQHandler);
}

/*----------------------------------------------------------
	Function name	: DmaIRQHandler()
	Prototype		: void DmaIRQHandler(smtUint32 irq)
	Return		: void
	Argument	:
	Comments	: DMA interrupt handler
----------------------------------------------------------*/
void DmaIRQHandler(smtUint32 irq)
{
	extern DMA_STRUCT gDmaVariable;

	gDmaVariable.intOn[irq] = SMT_TRUE;

	gDmaVariable.status[irq] = SMT_READ(DMACSta(irq));
	SMT_WRITE(DMACSta(irq), 0xF);
}

/*----------------------------------------------------------
	Function name	: HandlerUndef()
	Prototype		: void HandlerUndef(void)
	Return		: void
	Argument	:
	Comments	: Undefine instruction interrupt handler
----------------------------------------------------------*/
void HandlerUndef(void)
{
	smt2UartPrint(11, "HandlerUndef \n");
}

/*----------------------------------------------------------
	Function name	: HandlerPabort()
	Prototype		: void HandlerPabort(void)
	Return		: void
	Argument	:
	Comments	: Pre-fetch abort interrupt handler
----------------------------------------------------------*/
void HandlerPabort(void)
{
	smt2UartPrint(11, "HandlerPabort \n");
}

/*----------------------------------------------------------
	Function name	: HandlerDabort()
	Prototype		: void HandlerDabort(void)
	Return		: void
	Argument	:
	Comments	: Data-abort interrupt handler
----------------------------------------------------------*/
void HandlerDabort(void)
{
	smt2UartPrint(11, "HandlerDabort \n");
}

/*----------------------------------------------------------
	Function name	: HandlerFIQ()
	Prototype		: void HandlerFIQ(void)
	Return		: void
	Argument	:
	Comments	: FIQ interrupt handler
----------------------------------------------------------*/
void HandlerFIQ(void)
{
	smt2UartPrint(11, "HandlerFIQ \n");
}

