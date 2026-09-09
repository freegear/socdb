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
--  File Name              : Sci_Non_EMV_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function Non_EMV_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void Non_EMV_Test()
{

/*
  Summary : Non_EMV_Test 
  ======================
 
  o This test checks the Non EMV mode
  
  o Make the SCIDETECT signal high and wait for SCICARDININTR
  
  o In NON EMV mode clock enable, data enable, reset, fcb and
    vccen are provided through the SCISYNACT register, 

  o After the activation sequence, enable the the synchronous mode and change
    the clock and data through SCISYNCDATA register. 
   
*/
 

int Poll_value,value = 0x00,i,DELAY_value;

/* Enable all SCI interrupts */
PSW(0x7FFF,SCIIMSC);
 
/* Enable the Bypass mode. Also write a value to the SCISTABLE register */
PSW(0x20,SCICR1);
PSW(0x05,SCISTABLE);
 
/* Enable the trickbox also make SCIDETECT signal to '1' */
PSW(0x2011,SCITrCR);
 
/* Poll for the SCICARDININTR */
Poll_value = 0x05 * clkmulfactor + 0x10;
PO(0x1000,0x00001000,SCITrSR1,Poll_value,SCICARDININTR failed);

/* Doing the activation sequence using the SCISYNCACT register */
/* Write '1' to POWER and DATAEN bit */  
PSW(0x09,SCISYNCACT);

/* Idle clock is required for synchronisation */
PI(Dummyclock);

/* Read the SCISYNCACT register. Expecting POWER = '1',DATAEN = '1',
CARDPRESENT = '1' */ 
PSR(0x709,0x3FF,SCISYNCACT)

/* Write '1' to POWER,DATAEN and CLKEN bit */
PSW(0x0D,SCISYNCACT);

/* Idle clock is required for synchronisation */
PI(Dummyclock);

/* Read the SCISYNCACT register. Expecting POWER = '1',DATAEN = '1',
CARDPRESENT = '1',CLKEN = '1' */
PSR(0x70D,0x37F,SCISYNCACT);

/* Write '1' to POWER,DATAEN and CLKEN,CRESET  bit */
PSW(0x0F, SCISYNCACT);

/* Idle clock is required for synchronisation */
PI(Dummyclock);

/* Read the SCISYNCACT register. Expecting POWER = '1',DATAEN = '1',
CARDPRESENT = '1',CLKEN = '1', CRESET = '1' */
PSR(0x70F,0x37F,SCISYNCACT);

/* Test the FCB bit Write '1' to FCB, POWER,DATAEN and CLKEN,CRESET  bit */
PSW(0x01F, SCISYNCACT);

/* Idle clock is required for synchronisation */
PI(Dummyclock);

/* Read the SCISYNCACT register. Expecting POWER = '1',DATAEN = '1',
CARDPRESENT = '1',CLKEN = '1', CRESET = '1'and FCB = 1 */
PSR(0x71F,0x37F,SCISYNCACT);

/* Test the FCB bit Write '0' to FCB, 
   a '1' to the POWER,DATAEN and CLKEN,CRESET  bit */
PSW(0x00F, SCISYNCACT);

/* Idle clock is required for synchronisation */
PI(Dummyclock);

/* Read the SCISYNCACT register. Expecting POWER = '1',DATAEN = '1',
CARDPRESENT = '1',CLKEN = '1', CRESET = '1'and FCB = 1 */
PSR(0x70F,0x37F,SCISYNCACT);

/* Enable the Synchronous Mode and Bypass*/
PSW(0x60,SCICR1);
PI(Dummyclock);
 
for(i = 0x0; i<= 0x10; i++)
{
/* Writing value to the sync data register */
PSW(value | 0x10,SCISYNCTX);
/* Idle cycle required for synchronisation from PCLK to REFCLK domain */
PI(Dummyclock);
/* Reading the RAW status register to check whether the written value to the
sync data register is reflected on the output clock and data line */
PSR(value | 0x10, 0x03, SCISYNCRX);
value = i % 0x04;
}
 
PSW(0x03,SCISYNCTX);
 
/* Clear all interrupts */
PSW(0x1FFF,SCIICR);
 
/* Disable the SCIDETECT signal */
PSW(0x2001,SCITrCR);
 
DELAY_value = (0x05 + 0x01) * (0x03 + 0x01) * 0x02
             * clkmulfactor * 0x03 + Margin;
 
/* Waiting for the completion of the deactivation */
  DELAY_value = DELAY_value/254  + 1;
 
  for(i = DELAY_value; i > 0; i--)
  PI(254);

}/* End Function */
