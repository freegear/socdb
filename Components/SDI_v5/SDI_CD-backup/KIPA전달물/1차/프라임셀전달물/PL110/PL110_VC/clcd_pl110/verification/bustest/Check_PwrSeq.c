/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2002 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : Check_PwrSeq.c.rca
--  File Revision          : 1.1
--  
--  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
--  
------------------------------------------------------------------------------*/

/*  Parameter declarations : These values are defined manually
    Guidelines for defining the values for parameters 

   P A R A M E T E R           NOTE                   Minimum      Maximum 

  PixelsPerLine      Number of pixels in one line        32        1024 
  LinesPerPanel      In multiples of 16                  16        768 
  HSyncWidth         Hz Sync in no. of PCLKs             1         256 
  HBPvalue           Hz Backporch in no. of PCLKs        1         256 
  HFPvalue           Hz Frontporch in no. of PCLKs       1         256 
  VSyncWidth         Vertical Sync in no. of lines       1         64 
  VBPvalue           Vertical Backporch in no. of lines  0         255 
  VFPvalue           Vertical Frontporch in no. of lines 0         255 
  PCDvalue           No. of CLCLCKs in PANEL Clock       PCDMin    31 
  cSELv              Salecting CLCD clock either from 
                     trickbox or HCLK                    0   or    1
  ACBvalue           CLAC bias frequency in no. of lines 1         32 
  IVSv               Invert vertical sync                0   or    1 
  IHSv               Invert Horizontal sync              0   or    1 
  IPCv               Invert panel clock                  0   or    1 
  IEOv               Invert output enable                0   or    1 
  BCDv               Bupass panel clock divider          0   or    1 
  LEDvalue           Line end delay for CLLE             1         128 
  LEEv               CLLE Enable signal                  0   or    1      

  NOTE : The value of the PCDMin is dependent on the mode which we are 
         programming as given in the following table  

     M O D E           COLOUR/MONOCHROME      INTERFACE             PCDMin   

 STN DUAL PANEL MODE        COLOUR                8 BIT              5 
 STN DUAL PANEL MODE        MONOCHROME            8 BIT              16 
 STN DUAL PANEL MODE        MONOCHROME            4 BIT              6
 STN SINGLE PANEL MODE      COLOUR                8 BIT              2 
 STN SINGLE PANEL MODE      MONOCHROME            8 BIT              8 
 STN SINGLE PANEL MODE      MONOCHROME            4 BIT              2 
 TFT MODE                      ---                 ---               1
                                  */ 


/* function declarations  */

void Test_PwrSeq(void);
void Display_mode(int32 control_Data);

/*-------------------------------------------------------------------------
      This tests the Power Sequencing of the CLCD controller 
  -----------------------------------------------------------------------*/
  
void Check_PwrSeq(void)
{
  int32 control_Data,Timing0,Timing1,Timing2,Timing3,invalid,Mode_Data;
  int32 PPL,LPP,HSw,HBP,HFP,VSW,VBP,VFP,PCD,cSEL,ACB,IVS;
  int32 IHS,IPC,IEO,cPL,BCD,LED,LEE,i;
  int32 Data,Address,PerLineClock,VFPDelay;
  int32 Power_Seq;
  int   Delay,FrameNum,Mult;

  PixelsPerLine = 32;
  LinesPerPanel = 16;
  HSyncWidth    = 4;
  HBPvalue      = 5;
  HFPvalue      = 6;
  VSyncWidth    = 1;
  VBPvalue      = 1;
  VFPvalue      = 1;
  PCDvalue      = 1;
  cSELv         = 1;
  ACBvalue      = 10;
  IVSv          = 0;
  IHSv          = 0;
  IPCv          = 0;
  IEOv          = 0;
  BCDv          = 0;
  LEDvalue      = 2;
  LEEv          = 1;

  /* Code to allow clean concatenated file simulations */
  HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
  HSW(0x0,0x0,,IDLE_CYCLE);
  HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
  HSW(0x0,0x0,,IDLE_CYCLE);
  HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
  HSW(0x0,0x0,,IDLE_CYCLE);
  C(" ASSERTING RESET LOW ");
  RES(LOW);

  C(" ---------------------------------------");
  C(" ---------------------------------------");
  C(" POWER UP/DOWN SEQUENCE TEST IN TFT MODE");
  C(" ---------------------------------------");
  C(" ---------------------------------------");
  C(" WITH PROGRAMMABLE WATERMARK ");
  C(" BIT SET TO HIGH ");
  C(" PROGRAMMING PALLETE ");

    Address = 0x0;
    Data = 0x0;
    for(Address = 0x0; Address < 0x1FF; Address = Address + 4)
      {
      Data = 0x01010101 * Address + 0x03020100 ;
      HSA(Pal+Address,NSEQ,INCR,OK,WRD);
      HSW(,Data,,PALLETE_PROGRAMMING);
       }
    C("PALLETE IS PROGRAMMED");

  /*  Setting the control mode with control registers and timing registers */
  /* Setting the data for timing 0 register   */
  PPL = (PixelsPerLine/16 - 1) * 0x4  ;
  HSw = (HSyncWidth-1) * 0x100;
  HFP = (HFPvalue-1) * 0x10000;
  HBP = (HBPvalue-1) * 0x1000000;
  Timing0 = PPL + HSw + HFP +HBP ;

  /* Setting the timing1 register data  */
  LPP = LinesPerPanel-1; 
  VSW = (VSyncWidth-1) * 0x400;
  VFP = VFPvalue * 0x10000;
  VBP = VBPvalue * 0x1000000;
  Timing1 = LPP + VSW + VFP + VBP ;

   /* Setting data for timing2 register  */
  PCD = PCDvalue;
  cSEL = cSELv * 0x20;
  ACB = (ACBvalue-1) * 0x40;
  IVS = IVSv * 0x800;
  IHS = IHSv * 0x1000;
  IPC = IPCv * 0x2000;
  IEO = IEOv * 0x4000;
 
  /* Setting the data for timing3 register  */
   LED = LEDvalue;
   LEE = LEEv * 0x10000;
   Timing3 = LED + LEE;

  control_Data = 0x00010867;
  /* Calculation of CPL from PPL */

  cPL = (PixelsPerLine - 1) * 0x10000;
  BCD = BCDv * 0x4000000;
  PerLineClock = (cPL/0x10000)+ 1;

  Timing2 = PCD +  cSEL + ACB + IVS + IHS + IPC +IEO + cPL + BCD;

  /* The trickbox is enabled to give grant & No error responses to master 
     and the timing registers are programmed in the CLcd controller and 
     in the trickbox and also the base address register are programmed 
     and then the CLCD control register is programmed and enabled      */
 
  HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
  HSW(,0x00000013,,Trickbox_write);

  HSA(Tim0,NSEQ,SINGLE,OK,WRD);
  HSW(,Timing0,,TIMING0_WRITE);

  HSA(Tim1,NSEQ,SINGLE,OK,WRD);
  HSW(,Timing1,,TIMING1_WRITE);

  HSA(Tim2,NSEQ,SINGLE,OK,WRD);
  HSW(,Timing2,,TIMING2_WRITE);

  HSA(Tim3,NSEQ,SINGLE,OK,WRD);
  HSW(,Timing3,,TIMING3_WRITE);

  HSA(UpBase,NSEQ,SINGLE,OK,WRD);
  HSW(,0xA0000000,,UPBASE_WRITE);

  HSA(LpBase,NSEQ,SINGLE,OK,WRD);
  HSW(,0xB0000000,,LPBASE_WRITE);

  Power_Seq = control_Data & 0xFFFFF7FE;
  Display_mode(control_Data);
  HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
  HSW(,Power_Seq,,MODE_SETTING);

  Power_Seq = control_Data & 0xFFFFF7FF;
  HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
  HSW(,Power_Seq,,MODE_SETTING);

  /* This is  for including wait cycles  */
  HSA(DelayReg,NSEQ,SINGLE,OK,WRD);
  HSW(0x0,0x100,,WRITE_DELAY_REG);
  /* Dummy read     */ 
  HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
  HSR(,0x000,,0x00,,WAITING_READ_Trickbox);

  HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
  HSW(,control_Data,,MODE_SETTING);

  /* Simulating for 3 frames for TFT and 16 frames for STN mode  */
  FrameNum = 3;

  /*  Bypass panel clock divisor only for TFT mode */
  if(BCD)
    Mult = 1;
  else
    Mult = PCD + 2;
  Delay = (FrameNum * (VSyncWidth + VBPvalue + LinesPerPanel + VFPvalue)
           - VFPvalue) 
           * (HSyncWidth + HBPvalue + HFPvalue + PerLineClock) 
           * Mult; 

  /* This is  for including wait cycles  */
  HSA(DelayReg,NSEQ,SINGLE,OK,WRD);
  HSW(0x0,Delay,,WRITE_DELAY_REG);
  /* Dummy read     */ 
  HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
  HSR(,0x000,,0x00,,WAITING_READ_Trickbox);

  /* Disabling the trickbox as the data would be zero after
     writing low to LcdPwr bit But the other protocol for checking
     data to zero is still active */
  HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
  HSW(0x0,0x10,,DISABLE_TRICKBOX);

  Power_Seq = control_Data & 0xFFFFF7FF;
  HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
  HSW(,Power_Seq,,MODE_SETTING);

  /* This is  for including wait cycles  */
  HSA(DelayReg,NSEQ,SINGLE,OK,WRD);
  HSW(0x0,0x100,,WRITE_DELAY_REG);
  /* Dummy read     */ 
  HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
  HSR(,0x000,,0x00,,WAITING_READ_Trickbox);

  Power_Seq = control_Data & 0xFFFFF7FE;
  HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
  HSW(,Power_Seq,,MODE_SETTING);

  Mode_Data = control_Data & 0x1FFFE; 
  HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
  HSW(0x0,Mode_Data,,DISABLE_CLCD);
}

/*******************************END******************************************/
