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
--  File Name              : Sci_ATR_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function ATR_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void ATR_Test() 

{

/*
  Summary :  ATR Test 
  ===================
 
  o This test checks the ATR sequence, SCIATRSTOUTINTR, SCIATRDTOUTINTR,
    SCIRTOUTINTR, warm reset, self deactivation of SCI(if start bit of ATR
    is delayed more than the programmed value) 
 
*/

int Poll_value,DELAY_value,i;

PSW(0x2000,SCITrCR);
PI(Dummyclock);

/* Program the SCIATRSTIME register */
PSW(0x10,SCIATRSTIME);

/* Program the SCIATRDTIME register */
PSW(0xFF,SCIATRDTIME);

/* Program the SCIRXTIME register */
PSW(0x010, SCIRXTIME);

/* Enable all interrupts */
PSW(0x7FFF,SCIIMSC);

/* Function declaration reproduced here for reference
void  Initialisation(int BAUD_value,  int SCIVALUE_value,
                    int ATIME_value, int DTIME_value)
*/

Initialisation( 0x02,0x08,0x01,0x02);

/* Enable the ATR duration timer */
PSW(0x01,SCICR1);

/* Poll for the SCIATRSTOUTINTR. It is in terms of SCICLK  */
Poll_value = (0x03 + 0x01) * 0x02 * 0x10 * clkmulfactor + Margin;
PO(0x0081,0x0081,SCITrSR1,Poll_value,SCIATRSTOUTINTR_failed);

/* Enable the Trickbox transmitter */
PSW(0xAA,SCITrDATA);
PSW(0x2013,SCITrCR);

/* Poll the Receive FIFO read pointer */
/* Poll_value = etu_width * no_bits * RXTIME_register_value */
Poll_value = (0x02 + 0x01) * 0x08 * 0x0C * clkmulfactor + Margin;
PO(0x01,0x01,SCIRXCOUNT,Poll_value,SCIRXCOUNT_Poll);

/* Poll for the SCIRTOUTINTR */
/* Poll_value = SCICLK_width * RXTIME_register_value */
Poll_value = (0x03 + 0x01) * 0x02 * 0x10 * clkmulfactor + Margin;
PO(0x0003,0x0003,SCITrSR1,Poll_value,SCIRTOUTINTR_failed);

/* Read the received data from the SCI receive FIFO */
PSR(0xAA,0xFF,SCIDATA);

/* Poll for SCIATRDTOUTINTR */
/* Poll_value = SCICLK_width * ATRDURATION_register_value */
Poll_value = (0x02 + 0x01) * 0x08 * 0xFF * clkmulfactor + Margin;
PO(0x0041,0x0041,SCITrSR1,Poll_value,SCIATRDTOUTINTR_failed);

/* Disable the ATRDEN */
PSW(0x00,SCICR1);
PI(Dummyclock);

/* Enable the Warm reset */
PSW(0x04,SCICR2);

/* Poll_value = etu_width * no_bits * SCIATIM_register_value */
Poll_value = (0x02 + 0x01) * 0x08 * 0x10 * clkmulfactor + Margin;
PO(0x0000,0x0002,SCISYNCACT,Poll_value,CARDRESET_low_failed);
PO(0x0002,0x0002,SCISYNCACT,Poll_value,CARDRESET_high_failed);

/*If ATR reception has not started within the programmed period of time,
the SCI should start deactivation */
/* Poll for SCICARDDNINTR 
Poll_value  = (DactCount_value + 0x01) * (CLKICC_value + 0x01) * 0x02
             * clkmulfactor * 0x03 + Margin;
*/
 
Poll_value = 0x03 * 0x08 *  clkmulfactor * 0x03 + Margin;
PO(0x0200,0x0200,SCITrSR1,Poll_value,SCICARDDNINTR_failed);

/* Make SCIDETECT to '0'  otherwise after debounce time SCICARDININTR
becomes high */
PSW(0x2001,SCITrCR);
 
DELAY_value = (0x05 + 0x01) * (0x03 + 0x01) * 0x02
             * clkmulfactor * 0x03 + Margin;
 
/* Waiting for the completion of the deactivation */
  DELAY_value = DELAY_value/254  + 1;
 
  for(i = DELAY_value; i >= 0; i--)
  PI(254);
     
PI(Dummyclock));
  
}/* End Function */

