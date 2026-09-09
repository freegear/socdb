/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : Sci_CLKZ1_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function CLKZ1_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void CLKZ1_Test(CLKZ1_value)

{

/*
  Summary : CLKZ1_Test 
  ====================
 
  o This test checks the SCICLK output configuration. SCICLK can be configured as
    buffer output or pulled down(open drain) 
 
  o After Initialisation change the SCI to Synchronous mode  
  
  o If CLKZ1 = 1  the SCICLKOUT will be zero and clock will be driven by 
    nSCICLKOUTEN. If CLKZ1 = 0  the nSCICLKOUTEN will be zero and clock will 
    be driven by SCICLKOUT
*/
 

int Poll_value,i,value = 0x00,SCICR1_value = 0x00,DELAY_value;
 
/* This function initialise the SCI and trickbox  
 Initialisation(int BAUD_value,  int SCIVALUE_value,
                    int ATIME_value, int DTIME_value)
*/
 
 Initialisation(0x01,0x05,0x05,0x05);

/* Program the CLKZ1 value */
SCICR1_value =  (CLKZ1_value << 3);
PSW(SCICR1_value, SCICR1);
 
/* Enable the Synchronous Mode and CLKZ1 Value and ByPass mode*/
PSW(SCICR1_value | 0x60, SCICR1);
PI(Dummyclock);

/* If CLKZ1 is high SCICLKOUT will be zero at all times and nSCICLKOUTEN is 
driving the SCICLK */ 
if(CLKZ1_value == 0x01)
  {
    PSW(0x00,SCISYNCTX);
    PI(Dummyclock);
    PSR(0x000,0x050,SCISYNCACT);

    PSW(0x02,SCISYNCTX);
    PI(Dummyclock);
    PSR(0x020,0x050,SCISYNCACT);
 
    PSW(0x00,SCISYNCTX);
    PI(Dummyclock);
    PSR(0x000,0x050,SCISYNCACT);

    PSW(0x02,SCISYNCTX);
    PI(Dummyclock);
    PSR(0x020,0x050,SCISYNCACT);
 
  }  
/* If CLKZ1 is high nSCICLKOUTEN will be zero at all times and SCICLKOUT is 
driving the SCICLK */
else
  {
    PSW(0x00,SCISYNCTX);
    PI(Dummyclock);
    PSR(0x000,0x050,SCISYNCACT);
 
    PSW(0x02,SCISYNCTX);
    PI(Dummyclock);
    PSR(0x080,0x050,SCISYNCACT);
 
    PSW(0x00,SCISYNCTX);
    PI(Dummyclock);
    PSR(0x000,0x050,SCISYNCACT);
 
    PSW(0x02,SCISYNCTX);
    PI(Dummyclock);
    PSR(0x080,0x050,SCISYNCACT);
 
  }
 
/* Disable the synchronous mode and CLK1Z setting */
PSW(0x00,SCICR1);
PI(Dummyclock);

/* Clear all interrupts */
PSW(0x1FFF,SCIICR);
 
/* Disable the SCIDETECT signal */
PSW(0x2001,SCITrCR);
PI(Dummyclock);
 
DELAY_value = (0x05 + 0x01) * (0x03 + 0x01) * 0x02
             * clkmulfactor * 0x03 + Margin;
 
/* Waiting for the completion of the deactivation */
  DELAY_value = DELAY_value/254  + 1;
 
  for(i = DELAY_value; i > 0; i--)
  PI(254);

}/* End Function */
