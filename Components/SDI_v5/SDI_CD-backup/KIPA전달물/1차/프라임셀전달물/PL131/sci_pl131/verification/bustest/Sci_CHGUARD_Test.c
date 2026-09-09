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
--  File Name              : Sci_CHGUARD_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function CHGUARD_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void CHGUARD_Test() 

{

/*
  Summary : CHGUARD_Test
  ======================
 
  o This test checks the transmitter SCICHGUARD by sending two data 
    continuously with a GUARD time between the transmission.
 
*/

int i,DELAY_value, Poll_value;

/* Function declaration reproduced here for reference
void  Initialisation(int BAUD_value,  int SCIVALUE_value,
                    int ATIME_value, int DTIME_value)
*/
Initialisation(0x02,0x06,0x05,0x05);

/* Program the SCI and Trickbox GUARD registers */
PSW(SCICHGUARD,0x05);
PSW(SCITrTXCHG,0x05);

/* Enable trickbox receiver */
PSW(0x2015,SCITrCR);

/* Program the SCI control register in transmit mode */
PSW(0x00,SCICR0);
PSW(0x04,SCICR1);

/* Write two data values into the transmit FIFO of the SCI */
PSW(0x05,SCIDATA);
PSW(0xA0,SCIDATA);

/* Set RFR level of the trickbox at two */
PSW(0x20,SCITrFiLCR);

PI(Dummyclock);

/* Poll for the RFR */
PO(0x08,0x08,SCITrSR0,0xFFF);

/* Read the trickbox receive FIFO */
PSR(0x005,0x1FF,SCITrDATA);
PSR(0x0A0,0x1FF,SCITrDATA);

/* Clear all interrupts */
PSW(0x1FFF,SCIICR);
 
/* Disable the SCIDETECT signal */
PSW(0x2001,SCITrCR);
 
DELAY_value = (0x05 + 0x01) * (0x03 + 0x01) * 0x02
             * clkmulfactor * 0x05 + Margin;
 
/* Waiting for the completion of the deactivation */
  DELAY_value = DELAY_value/254  + 1;
 
  for(i = DELAY_value; i > 0; i--)
  PI(254);
 

}/* End Function */
