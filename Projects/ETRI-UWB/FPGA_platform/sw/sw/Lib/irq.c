/*----------------------------------------------------------
	File Name   : IRQ.c 
	Description : IRQ handling related routine(VIC)
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
static void UnknownIRQ(int IRQ);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
#define ALL_MASKED	0xFFFFFFFF
static smtUint32 currentLevel;
static ISRType ISRTable[32] = { 0, };	// ISR Table

// Variable to store the previous INTMASK value
static smtUint32 preStatusINTMASK = 0;

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
static void UnmaskIRQ(smtUint32 IRQ);
static void MaskIRQ(smtUint32 IRQ);
static void MaskAndAckIRQ(smtUint32 IRQ);

/*-----------------------------------------------------------------------
    Function name   : EnableVIC
    Prototype       : void EnableVIC(smtUint32 , smtUint32 , smtUint32)
    Return          : void
	Argument        : Polarity => value to write into POLARITY register
	                : Level => value to write into LEVEL register
	                : IntMod => value to write into INTMOD register.
    Comments        : Register ISR & Enable VIC
-----------------------------------------------------------------------*/
void EnableVIC(smtUint32 Polarity, smtUint32 Level, smtUint32 IntMod)
{
	int i;
    smtUint32 regINTCON;

	for(i = 0; i < 32; i++)
		ISRTable[i] = 0;

    // set GIE, VECTORED, nIRQ, nFIQ to 1(disable)
    regINTCON = INT_GIE_EN | INT_VECT_EN | INT_IRQ_EN | INT_FIQ_EN;
    SMT_WRITE(INTCON, regINTCON);

    SMT_WRITE(POLARITY, Polarity);
    SMT_WRITE(LEVEL, Level);
    SMT_WRITE(INTMOD, IntMod);
    SMT_WRITE(INTMSK, ALL_MASKED);

#if 0
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

/*-----------------------------------------------------------------------
    Function name   : DisableVIC
    Prototype       : void DisableVIC(void)
    Return          : void
	Argument        : 
    Comments        : Disable VIC
-----------------------------------------------------------------------*/
void DisableVIC(void)
{
    smtUint32 regINTCON;

    // set GIE, VECTORED, nIRQ, nFIQ to 1(disable)
    regINTCON = INT_GIE_EN | INT_VECT_EN | INT_IRQ_EN | INT_FIQ_EN;
    SMT_WRITE(INTCON, regINTCON);
}

/*-----------------------------------------------------------------------
    Function name   : RequestIRQ
    Prototype       : void RequestIRQ(int IRQ, ISRRoutineType ISR)
    Return          : void
	Argument        : IRQ => IRQ number you want to enable
	                : ISR => function pointer to coresspondant ISR
    Comments        : Register ISR & unmask interrupt
-----------------------------------------------------------------------*/
void RequestIRQ(smtUint32 IRQ, ISRType ISR)
{
	if(IRQ >= 32)
		return;
    // register ISR
    ISRTable[IRQ] = ISR;
    // unmask ISR
    UnmaskIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : ReleaseIRQ
    Prototype       : void ReleaseIRQ(int IRQ)
    Return          : void
	Argument        : IRQ => IRQ number you want to disable
    Comments        : Do mask interrupt
-----------------------------------------------------------------------*/
void ReleaseIRQ(smtUint32 IRQ)
{
	if(IRQ >= 32)
		return;
    // unregister ISR
    ISRTable[IRQ] = (ISRType)((void *)(0));
    // mask ISR
    MaskIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : UnmaskIRQ
    Prototype       : void UnmaskIRQ(smtUint32 IRQ)
    Return          : void
	Argument        : IRQ => IRQ number you want to enable
    Comments        : unmask interrupt
-----------------------------------------------------------------------*/
void UnmaskIRQ(smtUint32 IRQ)
{
    smtUint32 regINTMSK;

	if(IRQ >= 32)
		return;
    // unmask ISR
    regINTMSK = SMT_READ(INTMSK);
    regINTMSK &= ~(1<<IRQ);
    SMT_WRITE(INTMSK, regINTMSK);
}

/*-----------------------------------------------------------------------
    Function name   : MaskIRQ
    Prototype       : void MaskIRQ(smtUint32 IRQ)
    Return          : void
	Argument        : IRQ => IRQ number you want to disable
    Comments        : Do mask interrupt
-----------------------------------------------------------------------*/
void MaskIRQ(smtUint32 IRQ)
{
    smtUint32 regINTMSK;

	if(IRQ >= 32)
		return;

    // mask ISR
    regINTMSK = SMT_READ(INTMSK);
    regINTMSK |= (1<<IRQ);
    SMT_WRITE(INTMSK, regINTMSK);

    if(INTPND & (1<<IRQ))
        SMT_WRITE(I_ISPC, (1<<IRQ));	// clear INTPND if IRQ
}

/*-----------------------------------------------------------------------
    Function name   : MaskAndAckIRQ
    Prototype       : void MaskAndAckIRQ(ismtUint32nt IRQ)
    Return          : void
	Argument        : IRQ => IRQ number you want to Acknowledge
    Comments        : Clear pending interrupt when edge triggered interrupt
	                : Do nothing when level triggered interrupt
-----------------------------------------------------------------------*/
void MaskAndAckIRQ(smtUint32 IRQ)
{
    smtUint32 regI_ISPR;
    smtUint32 regINTMSK;

	if(IRQ >= 32)
		return;

	// Must Ack first and mask laster !!!
    if((~currentLevel) & (1<<IRQ))	// Edge triggered interrupt
    {
        regI_ISPR = SMT_READ(I_ISPR);
        SMT_WRITE(I_ISPC, regI_ISPR);
    }

    // mask ISR
    regINTMSK = SMT_READ(INTMSK);
    regINTMSK |= (1<<IRQ);
    SMT_WRITE(INTMSK, regINTMSK);
}

/*-----------------------------------------------------------------------
    Function name   : EnableINT
    Prototype       : void EnableINT(void)
    Return          : void
	Argument        :
    Comments        : Interrupt enable
-----------------------------------------------------------------------*/
void EnableINT(void)
{
    SMT_WRITE(INTMSK, preStatusINTMASK);
}

/*-----------------------------------------------------------------------
    Function name   : DisableINT
    Prototype       : void DisableINT(void)
    Return          : void
	Argument        :
    Comments        : Disable all interrupt
-----------------------------------------------------------------------*/
void DisableINT(void)
{
    preStatusINTMASK = SMT_READ(INTMSK);
    SMT_WRITE(INTMSK, ALL_MASKED);  // mask all interrupt
}

/*-----------------------------------------------------------------------
    Function name   : UnknownIRQ()
    Prototype       : void UnknownIRQ(int IRQ)
    Return          : void
    Argument        :
    Comments        : called when nIRQ=low & No ISR registered
-----------------------------------------------------------------------*/
static void UnknownIRQ(int IRQ)
{
    static int unknownISRCount = 0;

    unknownISRCount++;
}

/*-----------------------------------------------------------------------
    Function name   : InterruptHandler(void)
    Prototype       : void InterruptHandler(void)
    Return          : void
    Argument        :
    Comments        : called from assembler routine
-----------------------------------------------------------------------*/
extern unsigned _etext;
#include "uart.h"
void InterruptHandler(void)
{
	unsigned irq;

	while(1)
	{
		if(SMT_READ(I_ISPR) == 0)	// Check if something is wrong
			break;

		irq = SMT_READ(I_VECADDR);
		irq >>= 2;

		MaskAndAckIRQ(irq);		// Mask IRQ
		if(ISRTable[irq] != 0)
		{
			if(((unsigned)ISRTable[irq]) > _etext)
				UartPrintf("Something Wrong!!!\n");
			ISRTable[irq](irq);
		}
		else
			UnknownIRQ(irq);

		UnmaskIRQ(irq);
	}
}

