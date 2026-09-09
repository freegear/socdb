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
--  File Name              : Sci_CHTout_Intr_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function CHTout_Intr_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void CHTout_Intr_Test(MODE_value,SCICHTIME_value,SCITrTXCHG_value) 

{

/*
  Summary : CHTout_Intr_Test 
  ==========================
 
  o This test checks the character time out interrupt generation
 
  o Enable the trick box transmitter after the initialisation
  
  o Program the trickbox character GUARD registers with a larger value
    than in the SCI GUARD register. It makes the SCI assert SCICHOUTINTR
*/

int i,Poll_value,SCICR0_value = 0x00,DELAY_value;

/* Function declaration reproduced here for reference
 Initialisation(int BAUD_value,  int SCIVALUE_value,
                    int ATIME_value, int DTIME_value)
*/
 
Initialisation(0x01,0x05,0x05,0x05);

/* Write two data into the transmit FIFO of trickbox */
PSW(0xAA,SCITrDATA);
PSW(0xCC,SCITrDATA);

/* Program the GUARD registers. */
PSW(SCITrTXCHG_value,SCITrTXCHG);
PSW(0x0000,SCICHTIMEMS);
PSW(SCICHTIME_value,SCICHTIMELS);

/* Program mode value in the control register */ 
SCICR0_value = MODE_value << 5;
PSW(SCICR0_value,SCICR0);

/* Enable all interrupts */
PSW(0x7FFF,SCIIMSC);

/* Enable the trickbox transmitter */
PSW(0x2013,SCITrCR);
PI(Dummyclock);

/* Poll for the SCICHTOUTINTR */
Poll_value = 0x10 * (0x0B + MODE_value + SCICHTIME_value) 
             * clkmulfactor + Margin;
PO(0x0010,0x0010,SCITrSR1,Poll_value);

/* Read the SCI receive FIFO */
PSR(0xAA,0x1FF,SCIDATA);

/* Read the interrupt status register */
PSR(0x100,0x0100,SCIRIS);
PSR(0x100,0x0100,SCIMIS);

/* Clear the SCICHTOUTINTR */
PSW(0x100,SCIICR);
PI(Dummyclock);
PO(0x0000,0x0010,SCITrSR1,0x10);
PSR(0x000,0x0100,SCIRIS);
PSR(0x000,0x0100,SCIMIS);

/* Wait for the completion of the transmission */ 
Poll_value = 0x10 * (0x0B + MODE_value + SCICHTIME_value)
             * clkmulfactor + Margin;
PO(0x01,0xFF,SCIRXCOUNT,Poll_value);

/* Read the receive FIFO */
PSR(0xCC,0x1FF,SCIDATA);
PI(Dummyclock);
 
/* Clear all interrupts */
PSW(0x1FFF,SCIICR);
PI(Dummyclock);
 

/* Disable the SCIDETECT signal and the Trickbox*/
PSW(0x2000,SCITrCR);
PI(Dummyclock);
 
DELAY_value = (0x05 + 0x01) * (0x03 + 0x01) * 0x02
             * clkmulfactor * 0x03 + Margin;
 
/* Waiting for the completion of the deactivation */
  DELAY_value = DELAY_value/254  + 1;
 
  for(i = DELAY_value; i > 0; i--)
  PI(254);

}/* End Function */
