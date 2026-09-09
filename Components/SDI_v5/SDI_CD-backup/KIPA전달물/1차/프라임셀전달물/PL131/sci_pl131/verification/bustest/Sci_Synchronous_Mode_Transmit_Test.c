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
--  File Name              : Sci_Synchronous_Mode_Transmit_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function Synchronous_Mode_Transmit_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void Synchronous_Mode_Transmit_Test()
{

/*
  Summary : Synchronous_Mode_Transmit_Test
  ========================================
 
  o This test checks transmission in Synchronous mode  
 
  o After Initialisation enable the Synchronous mode  
  
  o Change the clock value and data value through SCISYNCDATA register and
    read it from the SCIRAWSTAT register after some clock delay
*/

int Poll_value,i,value = 0x00,DELAY_value;

/* This function initialise the SCI and trickbox  
Initialisation(int BAUD_value,  int SCIVALUE_value,
                    int ATIME_value, int DTIME_value)
*/ 
Initialisation(0x01,0x05,0x05,0x05);

/* Enable the Synchronous Mode */
PSW(0x40,SCICR1);
PI(Dummyclock);

for(i = 0x0; i<= 0x10; i++) 
{
/* Writing value to the sync data register */ 
PSW(value,SCISYNCTX);
/* Idle cycle required for synchronisation from PCLK to REFCLK domain */
PI(Dummyclock);
/* Reading the RAW status register to check whether the written value to the
sync data register is reflected on the output clock and data line */ 
PSR(value,0x03,SCISYNCRX);
value = i % 0x04;
}

PSW(0x03,SCISYNCTX);

/* Disable the synchronous mode */
PSW(0x00,SCICR1);
 
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
