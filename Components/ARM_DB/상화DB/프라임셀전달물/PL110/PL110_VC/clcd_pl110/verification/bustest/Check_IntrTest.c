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
--  File Name              : Check_IntrTest.c.rca
--  File Revision          : 1.4
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
                     trickbox or HCLK                    0   or    1
 
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
void Check_IntrTest(void);
void RegTest(void);
void ResetTest(int32 RegAddr);
void R_WTest(int32 DATA);
void R_oTest(int32 RegAddr);
void R_oTest_ID(int32 RegAddr, int32 DATA);
void Read_Write_Pallete(void);
void Display_mode(int32 control_Data);
void InterruptTest(void);
void BusErrorTest(void);
/*-------------------------------------------------------------------------
      This is the main function to test the CLCD controller
      This tests the CLCD controller registers for the reset,
                 CLCD controller read-write registers,
                 CLCD controller read-only registers,
                 CLCD controller pallete read write test,
                 CLCD controller testing for occurence of different     
                 interrupts & clearing it through writing in status registers
   -----------------------------------------------------------------------*/

void Check_IntrTest(void) 
{
  RegTest();
  Read_Write_Pallete();
  InterruptTest();
  BusErrorTest();
}

/* -------------------------------------------------------------------------
    Register test  Function    
    This function test the registers in CLCD controller for reset test
    and read-write registers, read-only registers.

   -------------------------------------------------------------------------*/
void RegTest(void)
{ 
  PixelsPerLine = 32;
  LinesPerPanel = 16;
  HSyncWidth    = 4;
  HBPvalue      = 5;
  HFPvalue      = 6;
  VSyncWidth    = 1;
  VBPvalue      = 1;
  VFPvalue      = 1;
  PCDvalue      = 17;
  cSELv         = 1;
  ACBvalue      = 10;
  IVSv          = 0;
  IHSv          = 0;
  IPCv          = 0;
  IEOv          = 0;
  BCDv          = 0;
  LEDvalue      = 2;
  LEEv          = 1;

C("REGISTER TESTS");
C("REGISTER RESET TEST");
ResetTest(Tim0);
ResetTest(Tim1);
ResetTest(Tim2);
ResetTest(Tim3);
ResetTest(UpBase);
ResetTest(LpBase);
ResetTest(Imsc);
ResetTest(CntrlReg);
ResetTest(Ris);
ResetTest(Mis);
ResetTest(Icr);
ResetTest(UpCrntAddr);
ResetTest(LpCrntAddr);
R_WTest(0xFFFFFFFF);
R_WTest(0x55555555);
R_WTest(0xAAAAAAAA);
R_WTest(0x00000000);
C(" CLCD CONTROLLER READ ONLY REGISTERS TEST");
HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
HSW(0x0,0x0,,IDLE_CYCLE);
HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
HSW(0x0,0x0,,IDLE_CYCLE);
HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
HSW(0x0,0x0,,IDLE_CYCLE);
RES (LOW);
R_oTest(Ris);
R_oTest(Mis);
R_oTest(UpCrntAddr);
R_oTest(LpCrntAddr);
R_oTest_ID(PeriphID0, 0x00000010);
R_oTest_ID(PeriphID1, 0x00000011);
R_oTest_ID(PeriphID2, 0x00000024);
R_oTest_ID(PeriphID3, 0x00000000);
R_oTest_ID(PCellID0,  0x0000000D);
R_oTest_ID(PCellID1,  0x000000F0);
R_oTest_ID(PCellID2,  0x00000005);
R_oTest_ID(PCellID3,  0x000000B1);
}
/*--------------------------------------------------------------------------
          Function to test the reset condition of the registers    
  ------------------------------------------------------------------------*/
void  ResetTest(int32 RegAddr)
{
/*  Start of the Reset Test      */
HSA(RegAddr,NSEQ,SINGLE,OK,WRD);
HSR(,0x00000000,,0xFFFFFFFF,,Read_00s);
}
/*-------------------------------------------------------------------------
         This is for testing write and read operation of the read    
              operation of the read and writable registers              
  ------------------------------------------------------------------------*/
void R_WTest(int32 DATA)
{
C(" CLCD  CONTROLLER READ WRITE REGISTER TEST ");
C(" WRITING TO THE REGISTERS : Non Sequential Writes");
HSA(Tim0,NSEQ,SINGLE,OK,WRD);
HSW(,DATA,,TIMING0_WRITE);
HSA(Tim2,NSEQ,SINGLE,OK,WRD);
HSW(,DATA,,TIMING2_WRITE);
HSA(Tim1,NSEQ,SINGLE,OK,WRD);
HSW(,DATA,,TIMING1_WRITE);
HSA(Tim3,NSEQ,SINGLE,OK,WRD);
HSW(,DATA,,TIMING3_WRITE);
HSA(LpBase,NSEQ,SINGLE,OK,WRD);
HSW(,DATA,,LPBASE_WRITE);
HSA(UpBase,NSEQ,SINGLE,OK,WRD);
HSW(,DATA,,UPBASE_WRITE);
HSA(Imsc,NSEQ,SINGLE,OK,WRD);
HSW(,DATA,,Imsc_WRITE);
HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
HSW(,DATA,,CntrlReg_WRITE);

C("READING THE REGISTERS : Non Sequential Reads");
HSA(Tim0,NSEQ,SINGLE,OK,WRD);
HSR(,DATA,,0xFFFFFFFC,);
HSA(Tim2,NSEQ,SINGLE,OK,WRD); 
HSR(,DATA,,0xFFFF7FFF,);
HSA(Tim1,NSEQ,SINGLE,OK,WRD);
HSR(,DATA,,0xFFFFFFFF,);
HSA(Tim3,NSEQ,SINGLE,OK,WRD);
HSR(,DATA,,0x0001007F,);
HSA(LpBase,NSEQ,SINGLE,OK,WRD);
HSR(,DATA,,0xFFFFFFFC,);
HSA(UpBase,NSEQ,SINGLE,OK,WRD);
HSR(,DATA,,0xFFFFFFFC,);
HSA(Imsc,NSEQ,SINGLE,OK,WRD);
HSR(,DATA,,0x0000001E,);
HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
HSR(,DATA,,0x00013FFF,);

C(" WRITING TO THE REGISTERS : Sequential Writes");
HSA(Tim0,NSEQ,SINGLE,OK,WRD);
HSW(,DATA,,TIMING0_WRITE);
HSW(,DATA,,TIMING1_WRITE);
HSW(,DATA,,TIMING2_WRITE);
HSW(,DATA,,TIMING3_WRITE);
HSW(,DATA,,UPBASE_WRITE);
HSW(,DATA,,LPBASE_WRITE);
HSW(,DATA,,Imsc_WRITE);
HSW(,DATA,,CntrlReg_WRITE);

C("READING THE REGISTERS : Sequential Reads");
HSA(Tim0,NSEQ,SINGLE,OK,WRD);
HSR(,DATA,,0xFFFFFFFC,);  /* Tim0    */
HSR(,DATA,,0xFFFFFFFF,);  /* Tim1    */
HSR(,DATA,,0x07FF7FFF,);  /* Tim2    */
HSR(,DATA,,0x0001007F,);  /* Tim3    */
HSR(,DATA,,0xFFFFFFFC,);  /* UpBase  */
HSR(,DATA,,0xFFFFFFFC,);  /* LpBase  */
HSR(,DATA,,0x0000001E,);  /* Imsc    */
HSR(,DATA,,0x00013FFF,);  /* Control */

}
/*-------------------------------------------------------------------------
        This is the function to test read only registers 
  ------------------------------------------------------------------------*/
void R_oTest(int32 RegAddr)
{
HSA(RegAddr,NSEQ,SINGLE,OK,WRD);
HSW(,0xFFFFFFFF,,R_OTestWrite);
HSA(RegAddr,NSEQ,SINGLE,OK,WRD);
HSR( ,0x00000000,,0xFFFFFFFF,,R_OTestRead);
}
/*-------------------------------------------------------------------------
        This is the function to test read only ID registers 
  ------------------------------------------------------------------------*/
void R_oTest_ID(int32 RegAddr, int32 DATA)
{
HSA(RegAddr,NSEQ,SINGLE,OK,WRD);
HSW(,~DATA,,R_O_ID_TestWrite);
HSA(RegAddr,NSEQ,SINGLE,OK,WRD);
HSR( ,DATA,,0xFFFFFFFF,,R_OTestRead);
}
/*------------------------------------------------------------------------
          This function read write test for  palette
 -------------------------------------------------------------------------*/
void Read_Write_Pallete(void)
{
int32 Data,Address;

  PixelsPerLine = 32;
  LinesPerPanel = 16;
  HSyncWidth    = 4;
  HBPvalue      = 5;
  HFPvalue      = 6;
  VSyncWidth    = 1;
  VBPvalue      = 1;
  VFPvalue      = 1;
  PCDvalue      = 17;
  cSELv         = 1;
  ACBvalue      = 10;
  IVSv          = 0;
  IHSv          = 0;
  IPCv          = 0;
  IEOv          = 0;
  BCDv          = 0;
  LEDvalue      = 2;
  LEEv          = 1;

C("PALLETE CHECKING");
for(Address = 0x0; Address < 0x1FF; Address = Address + 4)
  {
   Data = 0x01010101 * Address + 0x03020100 ;
  if(Address== 0x0)
    {
    HSA(Pal+Address,NSEQ,INCR,OK,WRD);
    HSW(,Data,,PALLETE_WRITE);
    }
  else
    {
  HSA(Pal+Address,SEQ,INCR,OK,WRD);
  HSW(,Data,,PALLETE_WRITE);
    }
  }
for(Address = 0x0; Address<  0x1FF; Address = Address + 4)
  {
   Data = 0x01010101 * Address + 0x03020100 ;
   if(Address== 0x0)
     {
      HSA(Pal+Address,NSEQ,INCR,OK,WRD);
      HSR( ,Data,,0xFFFFFFFF,,PALLETE_READ);
      }
   else
      {
       HSA(Pal+Address,SEQ,INCR,OK,WRD);
       HSR( ,Data,,0xFFFFFFFF,,PALLETE_READ);
      }
  }
for(Address = 0x0; Address<  0x1FF; Address = Address + 4)
  {
   Data = 0x01010101 * Address + 0x03020100 ;
   Data = ~Data;
   if(Address== 0x0)
     {
      HSA(Pal+Address,NSEQ,INCR,OK,WRD);
      HSW(,Data,,PALLETE_WRITE);
     }
   else
     {
      HSA(Pal+Address,SEQ,INCR,OK,WRD);
      HSW(,Data,,PALLETE_WRITE);
     }
  }
for(Address = 0x0; Address<  0x1FF; Address = Address + 4)
  {
   Data = 0x01010101 * Address + 0x03020100 ;
   Data = ~Data;
 
   if(Address== 0x0)
     {
      HSA(Pal+Address,NSEQ,INCR,OK,WRD);
      HSR( ,Data,,0xFFFFFFFF,,PALLETE_READ);
     }
   else
     {
      HSA(Pal+Address,SEQ,INCR,OK,WRD);
      HSR( ,Data,,0xFFFFFFFF,,PALLETE_READ);
     }
  }
C("PALLETE IS CHECKED");
}

/*----------------------------------------------------------------------------
          This is to test the Interrupts in the CLCD controller
  --------------------------------------------------------------------------*/
void InterruptTest(void)
{
int32 i,Timing0,Timing1,Timing2,Timing3,control_Data,Mode_Data;
int32 Data,Address;

/**************   FOR THE BUS ERROR  INTERRUPT TEST    ***********************/

  PixelsPerLine = 32;
  LinesPerPanel = 16;
  HSyncWidth    = 4;
  HBPvalue      = 5;
  HFPvalue      = 6;
  VSyncWidth    = 1;
  VBPvalue      = 1;
  VFPvalue      = 1;
  PCDvalue      = 17;
  cSELv         = 1;
  ACBvalue      = 10;
  IVSv          = 0;
  IHSv          = 0;
  IPCv          = 0;
  IEOv          = 0;
  BCDv          = 0;
  LEDvalue      = 2;
  LEEv          = 1;

Timing0 = 0x04050300;
Timing1 = 0x01010004;
Timing2 = 0x00050271;
Timing3 = 0x010002;
control_Data = 0x949;

HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
HSW(0x0,0x0,,IDLE_CYCLE);
HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
HSW(0x0,0x0,,IDLE_CYCLE);
RES(LOW);

C("BUS ERROR INTERRUPT TEST ");
C(" PROGRAMMING PALLETE ");
  Address = 0x0;
  Data = 0x0;
  for(Address = 0x0; Address < 0x1FF; Address = Address + 4)
    {
    Data = 0x01010101 * Address + 0x03020100 ;
    HSA(Pal+Address,NSEQ,INCR,OK,WRD);
    HSW(,Data,,PALLETE_PROGAMMING);
     }
  C("PALLETE IS PROGRAMMED");
     /* 
        Timing registers are programmed in the CLcd controller and
        in the trickbox and also the base address register are programmed
        and then the CLCD control register is programmed and enabled      */

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
 
/* Enabling the MBERROR bit in the interrupt enable register */
HSA(Imsc,NSEQ,SINGLE,OK,WRD);
HSW(,0x10,,Imsc_WRITE);
 
/* Giving error responce from the trickbox         */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSW(,0x0F,,Trickbox_write);
 
Display_mode(control_Data);
HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
HSW(,control_Data,,MODE_SETTING);

/* Waiting for some time for the occurence of the interrupt */
/* This is  for including wait cycles  */
HSA(DelayReg,NSEQ,SINGLE,OK,WRD);
HSW(0x0,0xFF,,WRITE_DELAY_REG);

/* Dummy read     */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x000,,0x00,,WAITING_READ_Trickbox);
 
/* Test the interrupt mask set clear function whilst reading
   the interrupt register of the CLCD controller */
HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x10,,0x1E,,INTRUPT_BERR_Mis);
 
/* Mask the MBERROR bit in the interrupt mask set clear register */
HSA(Imsc,NSEQ,SINGLE,OK,WRD);
HSW(,0x00,,Imsc_WRITE);
/* Check that the interrupt has been masked */
HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x00,,0x1E,,INTRUPT_BERR_Mis);
/* Unmask the MBERROR bit in the interrupt mask set clear register */
HSA(Imsc,NSEQ,SINGLE,OK,WRD);
HSW(,0x10,,Imsc_WRITE);
/* Check that the interrupt has been unmasked */
HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x10,,0x1E,,INTRUPT_BERR_Mis);
 

/* Read the MBERROR interrupt through the Trickbox */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x021,,0x21,,INTERRUPT_BERROR_Trickbox);

/* Clearing the interrupt  */
HSA(Icr,NSEQ,SINGLE,OK,WRD);
HSW(,0x1E,,Ris_Clear);
HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x00,,0x1E,,,INTBERR_Mis_Clear);
 
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x00,,0x3F,,INTR_BERR_Trickbox_Clear);
 
Mode_Data = control_Data & 0xFFFE; 
HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
HSW(0x0,Mode_Data,,DISABLE_CLCD);
 
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSW(0x0,0x0,,DISABLE_TRICKBOX);

/**************   FOR THE FIFO UNDERFLOW  ERROR INTERRUPT TEST *************/

HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
HSW(0x0,0x0,,IDLE_CYCLE);
HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
HSW(0x0,0x0,,IDLE_CYCLE);
RES(LOW);

C(" PROGRAMMING PALLETE ");
Address = 0x0;
Data = 0x0;
for(Address = 0x0; Address < 0x1FF; Address = Address + 4)
  {
  Data = 0x01010101 * Address + 0x03020100 ;
  HSA(Pal+Address,NSEQ,INCR,OK,WRD);
  HSW(,Data,,PALLETE_PROGAMMING);
   }
C("PALLETE IS PROGRAMMED");
C("FIFO UNDERFLOW INTERRUPT TEST ");
/* 
   Timing registers are programmed in the CLcd controller and
   in the trickbox and also the base address register are programmed
   and then the CLCD control register is programmed and enabled      */

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

/* Enabling the FUFL bit in the interrupt enable register */
HSA(Imsc,NSEQ,SINGLE,OK,WRD);
HSW(,0x02,,Imsc_WRITE);

/* Removing the grant for the master in trickbox */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSW(,0x011,,Trickbox_write);

/* This is  for inserting the wait cycles for enabling the clcd at the
   right time of the hsync pulse */
HSA(DelayReg,NSEQ,SINGLE,OK,WRD);
HSW(0x0,0x20,,WRITE_DELAY_REG);
/* Dummy delay read  */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x000,,0x00,,WAITING_READ_Trickbox);

Display_mode(control_Data);
HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
HSW(,control_Data,,MODE_SETTING);

/* Enabling the grant for the master in trickbox */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSW(,0x013,,Trickbox_write);


/* Allow the DMA Fifo to fill with defined values */
/* by granting the master for sufficient time.    */
for(i =0x0; i < 0x80; i = i+1)
  {
    HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
    HSR(,0x000,,0x00,,WAITING_READ_Trickbox);
  }

/* Disabling the grant for the master in trickbox */
/* such that a FIFO underflow will occur when all */
/* the values have been read i.e. subsequent      */
/* HBUSREQM requests are not serviced.            */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSW(,0x011,,Trickbox_write);

/* Waiting for some time for the occurence of the interrupt */

/* This is  for inserting the wait cycles  */
HSA(DelayReg,NSEQ,SINGLE,OK,WRD);
HSW(0x0,0x8FF,,WRITE_DELAY_REG);
/* Dummy delay read  */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x000,,0x00,,WAITING_READ_Trickbox);

/* Test the interrupt mask set clear function whilst reading
   the interrupt register of the CLCD controller */
HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x02,,0x1E,,INTERRUPT_UFL_Mis);

/* Mask the FUFL bit in the interrupt mask set clear register */
HSA(Imsc,NSEQ,SINGLE,OK,WRD);
HSW(,0x00,,Imsc_WRITE);
/* Check that the interrupt has been masked */
HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x00,,0x1E,,INTERRUPT_UFL_Mis);
/* Unmask the FUFL bit in the interrupt mask set clear register */
HSA(Imsc,NSEQ,SINGLE,OK,WRD);
HSW(,0x02,,Imsc_WRITE);
/* Check that the interrupt has been unmasked */
HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x02,,0x1E,,INTERRUPT_UFL_Mis);

/* Read the FUFL interrupt through the Trickbox */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x011,,0x11,,INTERRUPT_UFL_Trickbox);

/* CLEAring the interrupt  */
HSA(Icr,NSEQ,SINGLE,OK,WRD);
HSW(,0x1E,,Ris_Clear);

HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x00,,0x1E,,INTERRUPT_UFL_Mis_Clear);

HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x00,,0x3F,,INTERRUPT_UFL_Trickbox_Clear);

Mode_Data = control_Data & 0xFFFE;
HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
HSW(0x0,Mode_Data,,DISABLE_CLCD);

/* giving grant to come out of previous transactions for master */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSW(,0x03,,Trickbox_write);

/* waiting for sometime to give the grant */
/* This is  for inserting the wait cycles  */
HSA(DelayReg,NSEQ,SINGLE,OK,WRD);
HSW(0x0,0x30,,WRITE_DELAY_REG);

/* Dummy delay read  */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x000,,0x00,,WAITING_READ_Trickbox);

HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSW(0x0,0x0,,DISABLE_TRICKBOX);
 


/**************    FOR THE NEXT BASE UPDATE LNBU INTERRUPT TEST    **********/

HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
HSW(0x0,0x0,,IDLE_CYCLE);
HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
HSW(0x0,0x0,,IDLE_CYCLE);
RES(LOW);

C(" PROGRAMMING PALLETE ");
Address = 0x0;
Data = 0x0;
for(Address = 0x0; Address < 0x1FF; Address = Address + 4)
  {
  Data = 0x01010101 * Address + 0x03020100 ;
  HSA(Pal+Address,NSEQ,INCR,OK,WRD);
  HSW(,Data,,PALLETE_PROGAMMING);
   }
/* 
   Timing registers are programmed in the CLcd controller and
   in the trickbox and also the base address register are programmed
   and then the CLCD control register is programmed and enabled      */

C("PALLETE IS PROGRAMMED");
C("LNBU INTERRUPT TEST ");
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

/* Enabling the LNBU bit in the interrupt enable register */
HSA(Imsc,NSEQ,SINGLE,OK,WRD);
HSW(,0x04,,Imsc_WRITE);

/* Enabling the  trickbox */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSW(,0x00B,,Trickbox_write);

Display_mode(control_Data);
HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
HSW(,control_Data,,MODE_SETTING);

/* Waiting for some time for the occurence of the interrupt */
/* This is for including wait cycles  */
HSA(DelayReg,NSEQ,SINGLE,OK,WRD);
HSW(0x0,0xFF,,WRITE_DELAY_REG);
/* Dummy read     */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x000,,0x00,,WAITING_READ_Trickbox);

/* Test the interrupt mask set clear function whilst reading
   the interrupt register of the CLCD controller */
HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x04,,0x1E,,INTERRUPT_LNBU_Mis);

/* Mask the LNBU bit in the interrupt mask set clear register */
HSA(Imsc,NSEQ,SINGLE,OK,WRD);
HSW(,0x00,,Imsc_WRITE);
/* Check that the interrupt has been masked */
HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x00,,0x1E,,INTERRUPT_LNBU_Mis);
/* Unmask the LNBU bit in the interrupt mask set clear register */
HSA(Imsc,NSEQ,SINGLE,OK,WRD);
HSW(,0x04,,Imsc_WRITE);
/* Check that the interrupt has been unmasked */
HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x04,,0x1E,,INTERRUPT_LNBU_Mis);

/* Read the LNBU interrupt through the Trickbox */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x05,,0x05,,INTERRUPT_LNBU_Trickbox);

/* Clearing the interrupt  */
HSA(Icr,NSEQ,SINGLE,OK,WRD);
HSW(,0x1E,,Ris_Clear);
 
HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x00,,0x1E,,INTRUPT_UFL_Mis_0_READ);
 
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x00,,0x3F,,INTERRUPT_UFL_Trickbox_0_READ);
 
Mode_Data = control_Data & 0xFFFE;
HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
HSW(0x0,Mode_Data,,DISABLE_CLCD);

HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSW(0x0,0x0,,DISABLE_TRICKBOX);
 

/**************   FOR VERTICAL INTERRUPT VCOMP INTERRUPT TEST   **************/

HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
HSW(0x0,0x0,,IDLE_CYCLE);
HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
HSW(0x0,0x0,,IDLE_CYCLE);
RES(LOW);

C(" PROGRAMMING PALLETE ");
Address = 0x0;
Data = 0x0;
for(Address = 0x0; Address < 0x1FF; Address = Address + 4)
  {
  Data = 0x01010101 * Address + 0x03020100 ;
  HSA(Pal+Address,NSEQ,INCR,OK,WRD);
  HSW(,Data,,PALLETE_PROGAMMING);
   }
C("PALLETE IS PROGRAMMED");
C("VCOMP INTERRUPT TEST ");
/*
   Timing registers are programmed in the CLcd controller and
   in the trickbox and also the base address register are programmed
   and then the CLCD control register is programmed and enabled      */

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
 
/* Enabling the VCOMP bit in the interrupt enable register */
HSA(Imsc,NSEQ,SINGLE,OK,WRD);
HSW(,0x08,,Imsc_WRITE);
 
/* Enabling the  trickbox */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSW(,0x003,,Trickbox_write);

Display_mode(control_Data);
HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
HSW(,control_Data,,MODE_SETTING);
 
/* Waiting for some time for the occurence of the interrupt */

/* This is  for including wait cycles  */
HSA(DelayReg,NSEQ,SINGLE,OK,WRD);
HSW(0x0,0xC80,,WRITE_DELAY_REG);
/* HSW(0x0,0xFFF,,WRITE_DELAY_REG); */
/* Dummy delay read  */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x000,,0x00,,WAITING_READ_Trickbox);

/* Test the interrupt mask set clear function whilst reading
   the interrupt register of the CLCD controller */
HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x08,,0x1E,,INTR_VCOMP_Mis);

/* Mask the VCOMP bit in the interrupt mask set clear register */
HSA(Imsc,NSEQ,SINGLE,OK,WRD);
HSW(,0x00,,Imsc_WRITE);
/* Check that the interrupt has been masked */
HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x00,,0x1E,,INTR_VCOMP_Mis);
/* Unmask the VCOMP bit in the interrupt mask set clear register */
HSA(Imsc,NSEQ,SINGLE,OK,WRD);
HSW(,0x08,,Imsc_WRITE);
/* Check that the interrupt has been unmasked */
HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x08,,0x1E,,INTR_VCOMP_Mis);


/* Read the VCOMP interrupt through the Trickbox */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x03,,0x03,,INTR_VCOMP_Trickbox);

/* Clearing the interrupt  */
HSA(Icr,NSEQ,SINGLE,OK,WRD);
HSW(,0x1E,,Ris_Clear);
HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x00,,0x1E,,INTERRUPT_UFL_Mis_Clear);

HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x00,,0x3F,,INTERRUPT_UFL_Trickbox_Clear);

Mode_Data = control_Data & 0xFFFE;
HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
HSW(0x0,Mode_Data,,DISABLE_CLCD);
 
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSW(0x0,0x0,,DISABLE_TRICKBOX);
}


/*----------------------------------------------------------------------------
      This function tests the controller bus error interrupt by giving error
      responce at the middle of the active region of the display
  --------------------------------------------------------------------------*/
void BusErrorTest(void)
{
int32 i,Timing0,Timing1,Timing2,Timing3,control_Data;
int32 Delay,Delay2,Mode_Data,Address,Data;

  PixelsPerLine = 32;
  LinesPerPanel = 16;
  HSyncWidth    = 4;
  HBPvalue      = 5;
  HFPvalue      = 6;
  VSyncWidth    = 1;
  VBPvalue      = 1;
  VFPvalue      = 1;
  PCDvalue      = 40;
  cSELv         = 1;
  ACBvalue      = 10;
  IVSv          = 0;
  IHSv          = 0;
  IPCv          = 0;
  IEOv          = 0;
  BCDv          = 0;
  LEDvalue      = 2;
  LEEv          = 1;

Timing0 = 0x04050300;
Timing1 = 0x01010004;
Timing2 = 0x08050268;
Timing3 = 0x010002;
control_Data = 0x949;

/* For the BUS ERROR interrupt test */

HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
HSW(0x0,0x0,,IDLE_CYCLE);
HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
HSW(0x0,0x0,,IDLE_CYCLE);
RES(LOW);

C(" PROGRAMMING PALLETE ");
Address = 0x0;
Data = 0x0;
for(Address = 0x0; Address < 0x1FF; Address = Address + 4)
  {
  Data = 0x01010101 * Address + 0x03020100 ;
  HSA(Pal+Address,NSEQ,INCR,OK,WRD);
  HSW(,Data,,PALLETE_PROGAMMING);
   }
C("PALLETE IS PROGRAMMED");
C("BUS ERROR INTERRUPT TEST ");
/* The trickbox is enabled to give grant & No error responses to master
   and the timing registers are programmed in the CLcd controller and
   in the trickbox and also the base address register are programmed
   and then the CLCD control register is programmed and enabled      */

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
 
/* Enabling the MBERROR bit in the interrupt enable register */
HSA(Imsc,NSEQ,SINGLE,OK,WRD);
HSW(,0x10,,Imsc_WRITE);
 
/* Enabling  the trickbox         */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSW(,0x03,,Trickbox_write);
 
Display_mode(control_Data);
HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
HSW(,control_Data,,MODE_SETTING);
 
/* Waiting for some time for the occurence of the interrupt */
Delay2 = (VSyncWidth + VBPvalue + 1)
        * (HSyncWidth + HBPvalue + HFPvalue + 2)
        * (PCDvalue + 2);
/* This is  for including wait cycles  */
HSA(DelayReg,NSEQ,SINGLE,OK,WRD);
HSW(0x0,Delay2,,WRITE_DELAY_REG);
/* Dummy delay read  */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x000,,0x00,,WAITING_READ_Trickbox);
/* Giving error responce from the trickbox         */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSW(,0x0F,,Trickbox_write);
 
/* Waiting for some time for the occurence of the interrupt */
/* This is  for including wait cycles  */
HSA(DelayReg,NSEQ,SINGLE,OK,WRD);
HSW(0x0,0xFF,,WRITE_DELAY_REG);
/* Dummy delay read  */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x000,,0x00,,TRICKBOX_WAIT_READ);

/* Then reading the interrupts status register of the trickbox
        and interrupt register of the CLCD controller         */
 
HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x10,,0x1E,,INTRUPT_BERR_Mis);
 
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x021,,0x21,,INTERRUPT_BERROR_Trickbox);
 
Delay = 1 * (HSyncWidth + HBPvalue + HFPvalue + 2)
        * (PCDvalue + 2);

/* This is  for including wait cycles  */
HSA(DelayReg,NSEQ,SINGLE,OK,WRD);
HSW(0x0,Delay,,WRITE_DELAY_REG);
/* Dummy delay read  */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x000,,0x00,,WAITING_READ_Trickbox);
 
/* Clearing the interrupt  */
HSA(Icr,NSEQ,SINGLE,OK,WRD);
HSW(,0x1E,,Ris_Clear);
 
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSW(0x0,0x0,,DISABLE_TRICKBOX);
 
/* Enabling  the trickbox         */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSW(,0x0B,,Trickbox_write);
 
HSA(Mis,NSEQ,SINGLE,OK,WRD);
HSR( ,0x00,,0x1E,,,INTERRUPT_BERROR_Mis_Clear);
 
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x00,,0x3F,,INTERRUPT_BERROR_Trickbox_Clear);
 
Delay =  5 * (HSyncWidth + HBPvalue + HFPvalue + 2)
        * (PCDvalue + 2);
/* This is  for including wait cycles  */
HSA(DelayReg,NSEQ,SINGLE,OK,WRD);
HSW(0x0,Delay,,WRITE_DELAY_REG);
/* Dummy delay read  */
HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSR(,0x000,,0x00,,TRICKBOX_WAIT_READ);

HSA(CLTr_base,NSEQ,SINGLE,OK,WRD);
HSW(0x0,0x0,,DISABLE_TRICKBOX);
 
Mode_Data = control_Data & 0xFFFE;
HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
HSW(0x0,Mode_Data,,DISABLE_CLCD);
}

/*******************************END******************************************/
