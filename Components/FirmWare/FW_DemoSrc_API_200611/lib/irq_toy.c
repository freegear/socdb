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
//static void smtISRregist(void);
void smtISRregist(void);
/* 
 * Not expored functions
 * but I'm not sure  supports static function.
 */

/*
 void IsrEINT0(void);
 void IsrEINT1(void);
 void IsrEINT2(void);
 void IsrEINT3(void);
 void IsrIIC0(void);
 void IsrIIC0_AAS(void);
 void IsrTIMER0_TOF(void);
 void IsrTIMER0_TMC(void);
 void IsrTIMER1_TOF(void);
 void IsrTIMER1_TMC(void);
 void IsrTIMER2_TOF(void);
 void IsrTIMER2_TMC(void);
 void IsrEINT4(void);
 void IsrEINT5(void);
 void IsrEINT6(void);
 void IsrEINT7(void);
 void IsrIIC1(void);
 void IsrIIC1_AAS(void);
 void IsrWDT(void);
 void IsrADC(void);
 void IsrUTX(void);
 void IsrURX(void);
 void IsrTIMER3_TOF(void);
 void IsrTIMER3_TMC(void);
 void IsrTIMER4_TOF(void);
 void IsrTIMER4_TMC(void);
 void IsrTIMER5_TOF(void);
 void IsrTIMER5_TMC(void);
 void IsrTIMER6_TOF(void);
 void IsrTIMER6_TMC(void);
 void IsrTIMER7_TOF(void);
 void IsrTIMER7_TMC(void);
*/

void IsrEINT0(void);
void IsrEINT1(void);
void IsrEINT2(void);
void IsrEINT3(void);
void IsrIIC0(void);
void IsrIIC0_AAS(void);
void IsrTIMER0_TOF(void);
void IsrTIMER0_TMC(void);
void IsrTIMER1_TOF(void);
void IsrTIMER1_TMC(void);
void IsrTIMER2_TOF(void);
void IsrTIMER2_TMC(void);
void IsrEINT4(void);
void IsrEINT5(void);
void IsrEINT6(void);
void IsrEINT7(void);
void IsrIIC1(void);
void IsrIIC1_AAS(void);
void IsrWDT(void);
void IsrADC(void);
void IsrUTX(void);
void IsrURX(void);
void IsrTIMER3_TOF(void);
void IsrTIMER3_TMC(void);
void IsrTIMER4_TOF(void);
void IsrTIMER4_TMC(void);
void IsrTIMER5_TOF(void);
void IsrTIMER5_TMC(void);
void IsrTIMER6_TOF(void);
void IsrTIMER6_TMC(void);
void IsrTIMER7_TOF(void);
void IsrTIMER7_TMC(void);

static void UnknownISR(int IRQ);

typedef void (*ISR_SER)(void);

ISR_SER ISRTAB[32];

void InterruptServiceRoutine(void)
{
    int IN_VECADDR;
    static unsigned int i = 0;
    
    IN_VECADDR = SMT_READ(I_VECADDR);

    //if(IN_VECADDR != 0x0)
//    if(IN_VECADDR < 30)
        ISRTAB[(IN_VECADDR>>2)]();
}



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
    smtUint32 regINTCON;

    // Register ISRs
    smtISRregist();

    // set GIE, VECTORED, nIRQ, nFIQ to 1(disable)
    regINTCON = INT_GIE_EN | INT_VECT_EN | INT_IRQ_EN | INT_FIQ_EN;
    SMT_WRITE(INTCON, regINTCON);

    SMT_WRITE(POLARITY, Polarity);
    SMT_WRITE(LEVEL, Level);
    SMT_WRITE(INTMOD, IntMod);
    SMT_WRITE(INTMSK, ALL_MASKED);

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
    // register ISR
    ISRTable[IRQ] = ISR;
    // unmask ISR
    EnableIRQ(IRQ);
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
    // unregister ISR
    ISRTable[IRQ] = (ISRType)((void *)(0));
    // mask ISR
    DisableIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : EnableIRQ
    Prototype       : void EnableIRQ(smtUint32 IRQ)
    Return          : void
	Argument        : IRQ => IRQ number you want to enable
    Comments        : unmask interrupt
-----------------------------------------------------------------------*/
void EnableIRQ(smtUint32 IRQ)
{
    smtUint32 regINTMSK;

    // unmask ISR
    regINTMSK = SMT_READ(INTMSK);
    regINTMSK &= ~(1<<IRQ);
    SMT_WRITE(INTMSK, regINTMSK);
}

/*-----------------------------------------------------------------------
    Function name   : DisableIRQ
    Prototype       : void DisableIRQ(smtUint32 IRQ)
    Return          : void
	Argument        : IRQ => IRQ number you want to disable
    Comments        : Do mask interrupt
-----------------------------------------------------------------------*/
void DisableIRQ(smtUint32 IRQ)
{
    smtUint32 regINTMSK;

    // mask ISR
    regINTMSK = SMT_READ(INTMSK);
    regINTMSK |= (1<<IRQ);
    SMT_WRITE(INTMSK, regINTMSK);

    if(INTPND & (1<<IRQ))
        SMT_WRITE(I_ISPC, (1<<IRQ));	// clear INTPND if IRQ
}

/*-----------------------------------------------------------------------
    Function name   : AckIRQ
    Prototype       : void AckIRQ(ismtUint32nt IRQ)
    Return          : void
	Argument        : IRQ => IRQ number you want to Acknowledge
    Comments        : Clear pending interrupt when edge triggered interrupt
	                : Do nothing when level triggered interrupt
-----------------------------------------------------------------------*/
void AckIRQ(smtUint32 IRQ)
{
    smtUint32 regI_ISPR;
    if((~currentLevel) & (1<<IRQ))	// Edge triggered interrupt
    {
        regI_ISPR = SMT_READ(I_ISPR);
        SMT_WRITE(I_ISPC, regI_ISPR);
    }
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
    Function name   : smtISRregist()
    Prototype           : void smtISRregist(void);
    Return              : 
    Argument            :
    Comments        : Regist the isr routine to vector table
                      time > 0 : the number of loop time
-----------------------------------------------------------------------*/
//static void smtISRregist(void)
void smtISRregist(void)
{
     //ISRTAB[0] = (smtUint32)IsrEINT0;
     ISRTAB[0] = IsrEINT0;
     ISRTAB[1] = IsrEINT1;
     ISRTAB[2] = IsrEINT2;
     ISRTAB[3] = IsrEINT3;
     ISRTAB[4] = IsrIIC0;
     ISRTAB[5] = IsrIIC0_AAS;
     ISRTAB[6] = IsrTIMER0_TOF;
     ISRTAB[7] = IsrTIMER0_TMC;
     ISRTAB[8] = IsrTIMER1_TOF;
     ISRTAB[9] = IsrTIMER1_TMC;
     ISRTAB[10] = IsrTIMER2_TOF;
     ISRTAB[11] = IsrTIMER2_TMC;
     ISRTAB[12] = IsrEINT4;
     ISRTAB[13] = IsrEINT5;
     ISRTAB[14] = IsrEINT6;
     ISRTAB[15] = IsrEINT7;
     ISRTAB[16] = IsrIIC1;
     ISRTAB[17] = IsrIIC1_AAS;
     ISRTAB[18] = IsrWDT;
     ISRTAB[19] = IsrADC;
     ISRTAB[20] = IsrUTX;
     ISRTAB[21] = IsrURX;
     ISRTAB[22] = IsrTIMER3_TOF;
     ISRTAB[23] = IsrTIMER3_TMC;
     ISRTAB[24] = IsrTIMER4_TOF;
     ISRTAB[25] = IsrTIMER4_TMC;
     ISRTAB[26] = IsrTIMER5_TOF;
     ISRTAB[27] = IsrTIMER5_TMC;
     ISRTAB[28] = IsrTIMER6_TOF;
     ISRTAB[29] = IsrTIMER6_TMC;
     ISRTAB[30] = IsrTIMER7_TOF;
     ISRTAB[31] = IsrTIMER7_TMC;
}

/*-----------------------------------------------------------------------
    Function name   : IsrEINT0()
    Prototype           : void IsrEINT0(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void  IsrEINT0(void)
{
    AckIRQ(0);
    // Edit your code.
    while(1);

    if(ISRTable[0])
        ISRTable[0](0);
    else
        UnknownISR(0);
}

/*-----------------------------------------------------------------------
    Function name   : IsrEINT1()
    Prototype           : void IsrEINT1(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrEINT1(void)
{
    AckIRQ(1);
    if(ISRTable[1])
        ISRTable[1](1);
    else
        UnknownISR(1);
}

/*-----------------------------------------------------------------------
    Function name   : IsrEINT2()
    Prototype           : void IsrEINT2(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrEINT2(void)
{
    AckIRQ(2);
    if(ISRTable[2])
        ISRTable[2](2);
    else
        UnknownISR(2);
}

/*-----------------------------------------------------------------------
    Function name   : IsrEINT3()
    Prototype           : void IsrEINT3(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrEINT3(void)
{
    AckIRQ(3);
    if(ISRTable[3])
        ISRTable[3](3);
    else
        UnknownISR(3);
}

/*-----------------------------------------------------------------------
    Function name   : IsrIIC0()
    Prototype           : void IsrIIC0(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrIIC0(void)
{
    AckIRQ(4);
    if(ISRTable[4])
        ISRTable[4](4);
    else
        UnknownISR(4);
}

/*-----------------------------------------------------------------------
    Function name   : IsrIIC0_AAS()
    Prototype           : void IsrIIC0_AAS(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrIIC0_AAS(void)
{
    AckIRQ(5);
    if(ISRTable[5])
        ISRTable[5](5);
    else
        UnknownISR(5);
}

/*-----------------------------------------------------------------------
    Function name   : IsrTIMER0_TOF()
    Prototype           : void IsrTIMER0_TOF(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrTIMER0_TOF(void)
{
    AckIRQ(6);
    if(ISRTable[6])
        ISRTable[6](6);
    else
        UnknownISR(6);
}

/*-----------------------------------------------------------------------
    Function name   : IsrTIMER0_TMC()
    Prototype           : void IsrTIMER0_TMC(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrTIMER0_TMC(void)
{
    AckIRQ(7);
    if(ISRTable[7])
        ISRTable[7](7);
    else
        UnknownISR(7);
}

/*-----------------------------------------------------------------------
    Function name   : IsrTIMER1_TOF()
    Prototype           : void IsrTIMER1_TOF(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrTIMER1_TOF(void)
{
    AckIRQ(8);
    if(ISRTable[8])
        ISRTable[8](8);
    else
        UnknownISR(8);
}

/*-----------------------------------------------------------------------
    Function name   : IsrTIMER1_TMC()
    Prototype           : void IsrTIMER1_TMC(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrTIMER1_TMC(void)
{
    AckIRQ(9);
    if(ISRTable[9])
        ISRTable[9](9);
    else
        UnknownISR(9);
}

/*-----------------------------------------------------------------------
    Function name   : IsrTIMER2_TOF()
    Prototype           : void IsrTIMER2_TOF(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrTIMER2_TOF(void)
{
    AckIRQ(10);
    if(ISRTable[10])
        ISRTable[10](10);
    else
        UnknownISR(10);
}

/*-----------------------------------------------------------------------
    Function name   : IsrTIMER2_TMC()
    Prototype           : void IsrTIMER2_TMC(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrTIMER2_TMC(void)
{
    AckIRQ(11);
    if(ISRTable[11])
        ISRTable[11](11);
    else
        UnknownISR(11);
}

/*-----------------------------------------------------------------------
    Function name   : IsrEINT4()
    Prototype           : void IsrEINT4(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrEINT4(void)
{
    AckIRQ(12);
    if(ISRTable[12])
        ISRTable[12](12);
    else
        UnknownISR(12);
}

/*-----------------------------------------------------------------------
    Function name   : IsrEINT5()
    Prototype           : void IsrEINT5(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrEINT5(void)
{
    AckIRQ(13);
    if(ISRTable[13])
        ISRTable[13](13);
    else
        UnknownISR(13);
}

/*-----------------------------------------------------------------------
    Function name   : IsrEINT6()
    Prototype           : void IsrEINT6(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrEINT6(void)
{
    AckIRQ(14);
    if(ISRTable[14])
        ISRTable[14](14);
    else
        UnknownISR(14);
}

/*-----------------------------------------------------------------------
    Function name   : IsrEINT7()
    Prototype           : void IsrEINT7(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrEINT7(void)
{
    AckIRQ(15);
    if(ISRTable[15])
        ISRTable[15](15);
    else
        UnknownISR(15);
}

/*-----------------------------------------------------------------------
    Function name   : IsrIIC1()
    Prototype           : void IsrIIC1(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrIIC1(void)
{
    AckIRQ(16);
    if(ISRTable[16])
        ISRTable[16](16);
    else
        UnknownISR(16);
}

/*-----------------------------------------------------------------------
    Function name   : IsrIIC1_AAS()
    Prototype           : void IsrIIC1_AAS(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrIIC1_AAS(void)
{
    AckIRQ(17);
    if(ISRTable[17])
        ISRTable[17](17);
    else
        UnknownISR(17);
}

/*-----------------------------------------------------------------------
    Function name   : IsrWDT()
    Prototype           : void IsrWDT(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrWDT(void)
{
    // Disable interrupt
    DisableINT();
    
    AckIRQ(18);
        if(ISRTable[18])
    ISRTable[18](18);
    else
        UnknownISR(18);

    // Enable interrupt
    EnableINT();
}

/*-----------------------------------------------------------------------
    Function name   : IsrADC()
    Prototype           : void IsrADC(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void IsrADC(void)
{
    AckIRQ(19);
    if(ISRTable[19])
        ISRTable[19](19);
    else
        UnknownISR(19);
}

/*-----------------------------------------------------------------------
    Function name   : IsrUTX()
    Prototype           : void IsrUTX(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrUTX(void)
{
    AckIRQ(20);
    if(ISRTable[20])
        ISRTable[20](20);
    else
        UnknownISR(20);
}

/*-----------------------------------------------------------------------
    Function name   : IsrURX()
    Prototype           : void IsrURX(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrURX(void)
{
    AckIRQ(21);
    if(ISRTable[21])
        ISRTable[21](21);
    else
        UnknownISR(21);
}

/*-----------------------------------------------------------------------
    Function name   : IsrTIMER3_TOF()
    Prototype           : void IsrTIMER3_TOF(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrTIMER3_TOF(void)
{
    AckIRQ(22);
    if(ISRTable[22])
        ISRTable[22](22);
    else
        UnknownISR(22);
}

/*-----------------------------------------------------------------------
    Function name   : IsrTIMER3_TMC()
    Prototype           : void IsrTIMER3_TMC(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrTIMER3_TMC(void)
{
    AckIRQ(23);
    if(ISRTable[23])
        ISRTable[23](23);
    else
        UnknownISR(23);
}

/*-----------------------------------------------------------------------
    Function name   : IsrTIMER4_TOF()
    Prototype           : void IsrTIMER4_TOF(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrTIMER4_TOF(void)
{
    AckIRQ(24);
    if(ISRTable[24])
        ISRTable[24](24);
    else
        UnknownISR(24);
}

/*-----------------------------------------------------------------------
    Function name   : IsrTIMER4_TMC()
    Prototype           : void IsrTIMER4_TMC(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrTIMER4_TMC(void)
{
    AckIRQ(25);
    if(ISRTable[25])
        ISRTable[25](25);
    else
        UnknownISR(25);
}

/*-----------------------------------------------------------------------
    Function name   : IsrTIMER5_TOF()
    Prototype           : void IsrTIMER5_TOF(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrTIMER5_TOF(void)
{
    AckIRQ(26);
    if(ISRTable[26])
        ISRTable[26](26);
    else
        UnknownISR(26);
}

/*-----------------------------------------------------------------------
    Function name   : IsrTIMER5_TMC()
    Prototype           : void IsrTIMER5_TMC(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrTIMER5_TMC(void)
{
    AckIRQ(27);
    if(ISRTable[27])
        ISRTable[27](27);
    else
        UnknownISR(27);
}

/*-----------------------------------------------------------------------
    Function name   : IsrTIMER6_TOF()
    Prototype           : void IsrTIMER6_TOF(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
 void IsrTIMER6_TOF(void)
{
    AckIRQ(28);
    if(ISRTable[28])
        ISRTable[28](28);
    else
        UnknownISR(28);
}

/*-----------------------------------------------------------------------
    Function name   : IsrTIMER6_TMC()
    Prototype           : void IsrTIMER6_TMC(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void IsrTIMER6_TMC(void)
{
    AckIRQ(29);
    if(ISRTable[29])
        ISRTable[29](29);
    else
        UnknownISR(29);
}

/*-----------------------------------------------------------------------
    Function name   : IsrTIMER7_TOF()
    Prototype           : void IsrTIMER7_TOF(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void IsrTIMER7_TOF(void)
{
    AckIRQ(30);
    if(ISRTable[30])
        ISRTable[30](30);
    else
        UnknownISR(30);
}

/*-----------------------------------------------------------------------
    Function name   : IsrTIMER7_TMC()
    Prototype           : void IsrTIMER7_TMC(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
// void IsrTIMER7_TMC(void)
void IsrTIMER7_TMC(void)
{
    AckIRQ(31);
    if(ISRTable[31])
        ISRTable[31](31);
    else
        UnknownISR(31);
}

/*-----------------------------------------------------------------------
    Function name   : UnknownIRQ()
    Prototype       : void UnknownIRQ(int IRQ)
    Return          : void
    Argument        :
    Comments        : called when nIRQ=low & No ISR registered
-----------------------------------------------------------------------*/
static void UnknownISR(int IRQ)
{
    static int unknownISRCount = 0;
    unknownISRCount++;
}

