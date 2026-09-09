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
--  File Name              : Sci_BLKTout_Intr_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function BLKTout_Intr_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void BLKTout_Intr_Test(SCIBLKTIME_value,SCITrTXBLKG_value)
 
{

/*
  Summary : BLKTout_Intr_Test
  ============================
 
  o This test checks the block time out interrupt generation
 
  o Enable the trick box transmitter after the initialisation
 
  o Program the trickbox Block GUARD registers with larger value
    than SCI GUARD register. It make the SCI to assert SCIBLKTOUTINTR

  o Also this test checks the Interlock mechanism.
  
*/

int i,Poll_value,DELAY_value;

/* Function declaration reproduced here for reference
 Initialisation(int BAUD_value,  int SCIVALUE_value,
                    int ATIME_value, int DTIME_value)
*/

Initialisation(0x01,0x05,0x05,0x05);

/*  Set the TFR to 0x01 */
PSW(0x10,SCITrFiLCR);
PSW(0xCC,SCITrDATA);

/* Program the trickbox and SCI Guard register */
PSW(0x0000,SCIBLKTIMEMS);
PSW(SCIBLKTIME_value,SCIBLKTIMELS);
PSW(SCITrTXBLKG_value,SCITrTXBLKG);
PSW(0x00,SCICR0);

/* Unmask all the interrupt */
PSW(0x7FFF,SCIIMSC);

/* Enable the trickbox receiver */  
PSW(0x2015,SCITrCR);
PI(Dummyclock);

/* Enable the SCI in the transmit mode */
PSW(0x04,SCICR1);

/* Write a data into the transmit FIFO of the SCI */ 
PSW(0xAA,SCIDATA);

/* Switch the SCI from the transmit mode to receive mode. This will check the
interlock mechanism  */ 
PSW(0x02,SCICR1);
PI(Dummyclock);

/* Poll the TFR of the trickbox. It becomes high when the trickbox FIFO contains
one data */
Poll_value = (0x01 + 0x01) * 0x05 * 0x0C * clkmulfactor + Margin;
PO(0x08,0x08,SCITrSR0,Poll_value);

/* Read the trickbox receive FIFO */
PSR(0xAA,0x1FF,SCITrDATA);

/* Enable the Transmitter of the trickbox */
PSW(0x2013,SCITrCR);
PI(Dummyclock);

/* Poll for the SCIBLKOUTINTR */
Poll_value = 0x0A * ( SCIBLKTIME_value +2 ) * clkmulfactor  + Margin;
PO(0x0020,0x0020,SCITrSR1,Poll_value);

/* Dummy clocks for synchronisation to the PCLK domain */
PI(Dummyclock);
PI(Dummyclock);

/* Read the interrupt flag register */
PSR(0x080,0x080,SCIRIS);
PSR(0x080,0x080,SCIMIS);

/* Clear the interrupt */
PSW(0x080,SCIICR);
PO(0x0000,0x0020,SCITrSR1,0x10);

/* Dummy clocks for synchronisation to the PCLK domain */
PI(Dummyclock);
PI(Dummyclock);

/* Read the interrupt flag register */
PSR(0x000,0x080,SCIRIS);
PSR(0x000,0x080,SCIMIS);
 
/* Clear all interrupts */
PSW(0x1FFF,SCIICR);

/* Dummy clocks for synchronisation to the PCLK domain */
PI(Dummyclock);
PI(Dummyclock);

/* Read the SCIDATA */
PSR(0xCC, 0xFF, SCIDATA);

/* Disable the SCIDETECT signal */
PSW(0x2001,SCITrCR);
 
DELAY_value = (0x05 + 0x01) * (0x03 + 0x01) * 0x02
             * clkmulfactor * 0x03 + Margin;
 
/* Waiting for the completion of the deactivation */
DELAY_value = DELAY_value/254  + 1;
 
for(i = DELAY_value; i > 0; i--)
PI(254);

}/* End Function */
