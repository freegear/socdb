//
// Copyright (c) Microsoft Corporation.  All rights reserved.
//
//
// Use of this source code is subject to the terms of the Microsoft end-user
// license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
// If you did not accept the terms of the EULA, you are not authorized to use
// this source code. For a copy of the EULA, please see the LICENSE.RTF on your
// install media.
//
// -----------------------------------------------------------------------------
//
//      THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
//      ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
//      THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
//      PARTICULAR PURPOSE.
//  
// -----------------------------------------------------------------------------
#include <windows.h>
#include <bsp.h>

#define Clear_FrameBuffer 0xAC100000

void InitTimer(void);
void ConfigStopGPIO(void);

VOID BSPPowerOff()
{
	//RETAILMSG(1,(TEXT("BSPPowerOff\r\n")));
    volatile SMT926A_IOPORT_REG *pIOPort = (SMT926A_IOPORT_REG*)OALPAtoVA(SMT926A_BASE_REG_PA_IOPORT, FALSE);
    volatile SMT926A_ADC_REG *pADCPort = (SMT926A_ADC_REG*)OALPAtoVA(SMT926A_BASE_REG_PA_ADC, FALSE);
    volatile SMT926A_RTC_REG *pRTCPort = (SMT926A_RTC_REG*)OALPAtoVA(SMT926A_BASE_REG_PA_RTC, FALSE);
    volatile SMT926A_LCD_REG *pLCDPort = (SMT926A_LCD_REG*)OALPAtoVA(SMT926A_BASE_REG_PA_LCD, FALSE);
	
	ULONG *FrameBufferPtr = (ULONG *)Clear_FrameBuffer;
	ULONG FrameBufferCount;
  
    pRTCPort->RTCCON=0x0;   // R/W disable, 1/32768, Normal(merge), No reset
    pADCPort->ADCCON|=(1<<2);		// ADC StanbyMode

    pIOPort->MISCCR|=(1<<12); //USB port0 = suspend
    pIOPort->MISCCR|=(1<<13); //USB port1 = suspend

    pIOPort->MISCCR|=(1<<2); //Previous state at STOP(?) mode (???)

    //D[31:0] pull-up off. The data bus will not be float by the external bus holder.
    //If the pull-up resitsers are turned on,
    //there will be the leakage current through the pull-up resister
    pIOPort->MISCCR=pIOPort->MISCCR|(3<<0); 

	// In the evaluation board, Even though in sleep mode, the devices are all supplied the power.
	pIOPort->MSLCON = (0<<11)|(0<<10)|(0<<9)|(0<<8)|(0<<7)|(0<<6)|(0<<5)|(0<<4)|(0<<3)|(0<<2)|(0<<1)|(0<<0);
	pIOPort->DSC0 = (1<<31)|(3<<8)|(3<<0);
	pIOPort->DSC1 = (3<<28)|(3<<26)|(3<24)|(3<<22)|(3<<20)|(3<<18);

	// Clear frame buffer & wait until framebuffer refresh
	for (FrameBufferCount = 0 ; FrameBufferCount < 320*240/2 ; FrameBufferCount++)
		*FrameBufferPtr++ = 0xffffffff;
	pLCDPort->LCDSRCPND = 0x2;
	while((pLCDPort->LCDSRCPND & 0x2) == 0);
	pLCDPort->LCDSRCPND = 0x2;
	while((pLCDPort->LCDSRCPND & 0x2) == 0);
	pLCDPort->LCDSRCPND = 0x2;
	while((pLCDPort->LCDSRCPND & 0x2) == 0);
	pLCDPort->LCDSRCPND = 0x2;

    /* LCD Controller Disable               */
    CLRPORT32(&pIOPort->GPGDAT, 1 << 4);

}

void ConfigStopGPIO(void)
{
    volatile SMT926A_IOPORT_REG *pIOPort = (SMT926A_IOPORT_REG*)OALPAtoVA(SMT926A_BASE_REG_PA_IOPORT, FALSE);

    // Check point
    // 1) NC pin: input pull-up on 
    // 2) If input is driver externally: input pull-up off
    // 3) If a connected component draws some current: output low.
    // 4) If a connected component draws no current: output high.
    
    //chip # = 5

    //CAUTION:Follow the configuration order for setting the ports. 
    // 1) setting value(GPnDAT) 
    // 2) setting control register  (GPnCON)
    // 3) configure pull-up resistor(GPnUP)  

    //32bit data bus configuration  
    //*** PORT A GROUP
    //Ports  : GPA22 GPA21  GPA20 GPA19 GPA18 GPA17 GPA16 GPA15 GPA14 GPA13 GPA12  
    //Signal : nFCE nRSTOUT nFRE  nFWE  ALE   CLE   nGCS5 nGCS4 nGCS3 nGCS2 nGCS1 
    //Binary : 1     1      1,    1     1     1     1,    1     1     1     1,
    //POFF   : 1     0      1,    1     0     0     1,    1     1     1     1,
    //-------------------------------------------------------------------------------------------
    //Ports  : GPA11  GPA10  GPA9   GPA8   GPA7   GPA6   GPA5   GPA4   GPA3   GPA2   GPA1   GPA0
    //Signal : ADDR26 ADDR25 ADDR24 ADDR23 ADDR22 ADDR21 ADDR20 ADDR19 ADDR18 ADDR17 ADDR16 ADDR0 
    //Binary : 1      1      1      1,     1      1      1      1,     1      1      1      1         
    //POFF   : 0      0      0      0,     0      0      0      0,     0      0      0      0
    pIOPort->GPACON = 0x7fffff; 

    //**** PORT B GROUP
    //Ports  : GPB10   GPB9    GPB8    GPB7    GPB6    GPB5     GPB4    GPB3   GPB2   GPB1       GPB0
    //Signal : nXDREQ0 nXDACK0 nXDREQ1 nXDACK1 nSS_KBD nDIS_OFF L3CLOCK L3DATA L3MODE nIrDATXDEN Keyboard
    //Setting: INPUT   OUTPUT  INPUT   OUTPUT  INPUT   OUT      OUT     OUT    OUT    INPUT      INPUT 
    //Binary : 00,     01      00,     01      00,     01       01,     01     01,    00         00  
    //PU_OFF :  0       1       0,      1      1(ext)  1(*)     1,      1      1      1(ext)     1(ext)           
    //*:nDIS_OFF:4.7K external pull-down resistor                                 
    // pIOPort->GPBDAT=  0x0|(1<<9)|(1<<7)|(0<<5)|(1<<4)|(1<<3)|(1<<2);
	pIOPort->GPBDAT=  0x0|(0<<9)|(1<<7)|(0<<5)|(1<<4)|(1<<3)|(1<<2);			// SHLIM 040116
    pIOPort->GPBCON = 0x044550;  
    pIOPort->GPBUP  = 0x2ff;   //0x2fd->2ff, 3uA is reduced. Why? 

    //*** PORT C GROUP
    //Ports  : GPC15 GPC14 GPC13 GPC12 GPC11 GPC10 GPC9 GPC8 GPC7  GPC6   GPC5   GPC4 GPC3 GPC2  GPC1 GPC0
    //Signal : VD7   VD6   VD5   VD4   VD3   VD2   VD1  VD0 LCDVF2 LCDVF1 LCDVF0 VM VFRAME VLINE VCLK LEND  
    //Setting: IN    IN    IN    IN    IN    IN    IN   IN   OUT   OUT    OUT    IN   IN   IN    IN   IN
    //Binary : 00    00,   00    00,   00    00,   00   00,  01    01,    01     00,  00   00,   00   00
    //PU_OFF :  0     0     0     0,    0     0     0    0,   1     1      1      0,   0    0     0    0
    pIOPort->GPCDAT = 0x0;
    pIOPort->GPCCON = 0x00005400;  //0x00000000;	
    pIOPort->GPCUP  = 0x00e0;      //0x0000;     
    //LCDVFn is connected the analog circuit in LCD. So, this signal should be output L.
    
    //*** PORT D GROUP
    //Ports  : GPD15 GPD14 GPD13 GPD12 GPD11 GPD10 GPD9 GPD8 GPD7 GPD6 GPD5 GPD4 GPD3 GPD2 GPD1 GPD0
    //Signal : VD23  VD22  VD21  VD20  VD19  VD18  VD17 VD16 VD15 VD14 VD13 VD12 VD11 VD10 VD9  VD8
    //Setting: IN    IN    IN    IN    IN    IN    IN   IN   IN   IN   IN   IN   IN   IN   IN   IN
    //Binary : 00    00,   00    00,   00    00,   00   00,  00   00,  00   00,  00   00,  00   00
    //PU_OFF :  0     0     0     0,    0     0     0    0,   0    0    0    0,   0    0    0    0
    pIOPort->GPDDAT=  0x0;
    pIOPort->GPDCON = 0x0;	
    pIOPort->GPDUP  = 0x0;    

    //*** PORT E GROUP
    //Ports  : GPE15  GPE14  GPE13   GPE12    GPE11    GPE10   GPE9    GPE8    GPE7    GPE6  GPE5  GPE4  
    //Signal : IICSDA IICSCL SPICLK0 SPIMOSI0 SPIMISO0 SDDATA3 SDDATA2 SDDATA1 SDDATA0 SDCMD SDCLK I2SSDO 
    //Setting: IN     IN     IN      IN       IN       IN      IN      IN      IN      IN    IN    OUT
    //Binary : 00     00,    00      00,      00       00,     00      00,     00      00,   00    01,     
    //PU_OFF :  1-ext  1-ext  0       0,       0        0       0       0,      0       0     0     1,
    //------------------------------------------------------------------------------------------------
    //Ports  : GPE3   GPE2  GPE1    GPE0    
    //Signal : I2SSDI CDCLK I2SSCLK I2SLRCK     
    //Setting: IN     OUT   OUT     OUT
    //Binary : 00     01,   01      01
    //PU_OFF :  1-ext  1     1       1
    pIOPort->GPEDAT = 0x0|(1<<4)|(1<<2)|(1<<1)|(1<<0);
    pIOPort->GPECON = 0x00000115;	
    pIOPort->GPEUP  = 0xc01f;     

    //*** PORT F GROUP
    //Ports  : GPF7   GPF6   GPF5   GPF4   GPF3        GPF2  GPF1   GPF0
    //Signal : nLED_8 nLED_4 nLED_2 nLED_1 nIRQ_PCMCIA EINT2 KBDINT EINT0
    //Setting: Output Output Output Output IN          IN    IN     EINT0
    //Binary : 01     01,    01     01,    00          00,   00     10
    //PU_OFF :  1      1      1      1,     0-ext       1-ext 1-ext  1-ext
    pIOPort->GPFDAT = 0x0  |(0xf<<4);
    pIOPort->GPFCON = 0x5502;
    pIOPort->GPFUP  = 0xf7;   
                            
    //*** PORT G GROUP
    //Ports  : GPG15 GPG14 GPG13 GPG12 GPG11  GPG10    GPG9     GPG8     GPG7      GPG6    
    //Signal : nYPON YMON  nXPON XMON  EINT19 DMAMODE1 DMAMODE0 DMASTART KBDSPICLK KBDSPIMOSI
    //Setting: OUT   OUT   OUT   OUT   OUT    OUT      OUT      OUT      OUT       OUT
    //Binary : 01    01,   01    01,   01-dbg 01,      01       01,      01        01
    //PU_OFF :  1     1     1     1,    1-ext  1        1        1,       1         1
    //---------------------------------------------------------------------------------------
    //Ports  : GPG5       GPG4      GPG3   GPG2    GPG1    GPG0    
    //Signal : KBDSPIMISO LCD_PWREN EINT11 nSS_SPI IRQ_LAN IRQ_PCMCIA
    //Setting: IN         IN        EINT11 IN      IN      IN
    //Binary : 00         00,       10     00,     00      00
    //PU_OFF :  0-ext      0,        1-ext  0       0       0
#if 0
    pIOPort->GPGDAT = 0x0 |(1<<11)|(1<<15)|(1<<14)|(1<<13)|(1<<12)|(1<<9)|(1<<8)|(1<<7)|(1<<6) ;
    pIOPort->GPGCON = 0x55455080;   //GPG11=OUT  //for debug
    pIOPort->GPGUP  = 0xfbc8;    
#else	// Modified for SMT
	pIOPort->GPGDAT = 0;
	pIOPort->GPGCON = 0x00000000;
	pIOPort->GPGUP	= 0x0;
#endif

    //*** PORT H GROUP
    //Ports  : GPH10   GPH9    GPH8 GPH7  GPH6  GPH5 GPH4 GPH3 GPH2 GPH1  GPH0 
    //Signal : CLKOUT1 CLKOUT0 UCLK nCTS1 nRTS1 RXD1 TXD1 RXD0 TXD0 nRTS0 nCTS0
    //Setting: IN      IN      IN   IN    IN    IN   OUT  RXD0 TXD0 OUT   IN
    //Binary : 00,     00      00,  00    00,   00   01,  10   10,  01    00
    //PU_OFF :  0       0       0,   1-ext 1-ext 1-ext 1, 1-ext 1    1     1-ext

#if 1
    pIOPort->GPHDAT = 0x0|(1<<6)|(1<<1)|(1<<4);    
    pIOPort->GPHCON = 0x0001a4; 		   //0x0011a4->0x0001a4 reduces 12uA why -> MAX3232C may sink 12uA.
#else
    //GPHDAT = 0x0|(1<<6)|(1<<1)|(1<<4);  
    //GPHCON = 0x0011a4; 
    pIOPort->GPHDAT = 0x0|(0<<6)|(1<<1)|(1<<4);  //(1<<6)->(0<<6) reduces 12uA (MAX3232C may sink 12uA.)
    pIOPort->GPHCON = 0x0011a4; 
#endif    
    pIOPort->GPHUP  = 0x0ff;    // The pull up function is disabled GPH[10:0]


	//PORT J GROUP
	//Ports	:  GPJ12    GPJ11     GPJ10	  GPJ9  GPJ8      GPJ7	GPJ6  GPJ5	GPJ4  GPJ3  GPJ2  GPJ1  GPJ0
	//Signal : CAMRESET CAMCLKOUT CAMHREF CAMVS CAMPCLKIN CAMD7 CAMD6 CAMD5 CAMD4 CAMD3 CAMD2 CAMD1 CAMD0
	//Setting: Out      Out       Out     Out   Out       Out   Out   Out   Out   Out   Out   Out   Out
	//Binary : 01	    01        01      01    01        01    01    01    01    01    01    01    01
	//PU_OFF : 0	    0 		  1	      1     1         1     1     1		1	  1     1     1     1
	//---------------------------------------------------------------------------------------
	
	pIOPort->GPJCON = 0x02aaaaaa;
	pIOPort->GPJUP  = 0x1fff;    // The pull up function is disabled GPH[10:0]
    
    //External interrupt will be falling edge triggered. 
//    pIOPort->rEXTINT0 = 0x22222222;    // EINT[7:0]
    pIOPort->EXTINT0 = 0x22222224;    // EINT[7:0]			// charlie. button glich
    pIOPort->EXTINT1 = 0x22222222;    // EINT[15:8]
    pIOPort->EXTINT2 = 0x22222022;    // EINT[23:16]
}

VOID BSPPowerOn()
{
    volatile SMT926A_IOPORT_REG *pIOPort = (SMT926A_IOPORT_REG*)OALPAtoVA(SMT926A_BASE_REG_PA_IOPORT, FALSE);
    volatile SMT926A_LCD_REG *pLCD = (SMT926A_LCD_REG*)OALPAtoVA(SMT926A_BASE_REG_PA_LCD, FALSE);

	OEMInitDebugSerial();
	
	InitTimer();

    pIOPort->EXTINT0 = 0x22222222;    // EINT[7:0]
    pIOPort->EXTINT1 = 0x22222222;    // EINT[15:8]
    pIOPort->EXTINT2 = 0x22222222;    // EINT[23:16]

	pIOPort->GSTATUS2 = pIOPort->GSTATUS2;

    pIOPort->MISCCR &= ~(1<<12); //USB port0 = normal mode
    pIOPort->MISCCR &= ~(1<<13); //USB port1 = normal mode

    /* LCD Controller Enable               */
    SETPORT32(&pIOPort->GPGDAT, 1 << 4);

}

//------------------------------------------------------------------------------
//
//  Function:  InitClock
//
//  This function is now considered obsolete. It is called by kernel after OAL
//  returns from OEMPowerOff. All its function should be moved to OEMPowerOff.
//
//	This function is defined on \common\src\common\other\clock.c
//
VOID InitTimer()
{
	volatile SMT926A_PWM_REG *g_pPWMRegs = (SMT926A_PWM_REG*)OALPAtoUA(SMT926A_BASE_REG_PA_PWM);
    UINT32 tcon;

	RETAILMSG(1,(TEXT("InitClock\r\n")));

	    // Hardware Setup
    g_pPWMRegs = (SMT926A_PWM_REG*)OALPAtoUA(SMT926A_BASE_REG_PA_PWM);

    OUTREG32(&g_pPWMRegs->TCFG0, INREG32(&g_pPWMRegs->TCFG0) & ~0x0000FF00);
    OUTREG32(&g_pPWMRegs->TCFG0, INREG32(&g_pPWMRegs->TCFG0) | (245-1) <<8);		// charlie, Timer4 scale value
    OUTREG32(&g_pPWMRegs->TCFG1, INREG32(&g_pPWMRegs->TCFG1) & ~(0xF << 16));
    OUTREG32(&g_pPWMRegs->TCFG1, INREG32(&g_pPWMRegs->TCFG1) | (3 << 16));	// charlie, Timer4 Division
    OUTREG32(&g_pPWMRegs->TCNTB4, g_oalTimer.countsPerSysTick);

    // Start timer in auto reload mode
    tcon = INREG32(&g_pPWMRegs->TCON) & ~(0x0F << 20);
    OUTREG32(&g_pPWMRegs->TCON, tcon | (0x2 << 20) );
    OUTREG32(&g_pPWMRegs->TCON, tcon | (0x5 << 20) );
}

//------------------------------------------------------------------------------

