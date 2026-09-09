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
--  File Name              : Sci_Transmit_Intr_flag_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function Transmit_Intr_flag_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void Transmit_Intr_flag_Test()

{

/*
  Summary : Transmit_Intr_flag_Test 
  ==================================
 
  o This test checks the TXFF,TXFE flags, and SCITXTIDE interrupts at all
    TIDE values.
 
  o Enable the trick box transmitter after the initialisation
 
  o Check the flags and interrupt.
 
*/

int  i,Poll_value,SCITr_value,SCIWrPtr = 0x00,TrRdPtr = 0x00,
     loop,TXCOUNT_value = 0x00,Count_value = 0x07,DELAY_value;

/* Function declaration reproduced here for reference
Initialisation(int BAUD_value,  int SCIVALUE_value,
               int ATIME_value, int DTIME_value)
*/
 
Initialisation(0x01,0x05,0x05,0x05);

/*  Set the TFR to 0x01 */
PSW(0x80,SCITrFiLCR);

/* Enable trickbox receiver */
PSW(0x2015,SCITrCR);

/* Enable the SCI transmitter */
PSW(0x04,SCICR1);
PSW(0x00,SCICR0);

/* Read the flag register. Expect TXFE = '1' and TXFF = '0' */
PSR(0x02,0x03,SCIFIFOSTATUS);

/* Write data into the transmit FIFO */ 
for(i =0; i<= 7; i++)
{
  PSW(data[SCIWrPtr],SCIDATA);
   SCIWrPtr++; 
}

/* Read the flag register after eight writes into the transmit FIFO. 
Expect TXFE = '0' and TXFF = '1' */
PSR(0x01,0x03,SCIFIFOSTATUS);
PI(Dummyclock);

for(loop = 0x00; loop < 7; loop++)
{

  TXCOUNT_value = Count_value;
  PSW(TXCOUNT_value,SCITIDE);

  /* Poll for the SCITXTIDEINTR interrupt */
  Poll_value = ( 0x0A - Count_value ) * 0x02 * 0x05 * 0x0C * clkmulfactor 
             + Margin;
  PO(0x0008,0x00000008,SCITrSR1,Poll_value,SCITXTIDEINTR failed);

  /* Write data into the transmit FIFO of the trickbox */
  for(i = Count_value; i< 8; i++) 
  {
    PSW(data[SCIWrPtr],SCIDATA);
    SCIWrPtr++;
    if(SCIWrPtr > 0x0F)
      SCIWrPtr = 0x00;
  }

/* Read the receive FIFO of the trickbox */ 
  for(i = Count_value; i< 8; i++) 
  {
    PSR(data[TrRdPtr],0x1FF,SCITrDATA);
    TrRdPtr++;
    if(TrRdPtr > 0x0F)
      TrRdPtr = 0x00;
  }

Count_value = Count_value - 1;

}

/* Waiting for the completion of the last data transmit */
TXCOUNT_value = Count_value;
PSW(TXCOUNT_value,SCITIDE);
Poll_value = (0x0A - Count_value ) * 0x02 * 0x05 * 0x0C * clkmulfactor
            + Margin;
PO(0x08,0x08,SCITrSR0,Poll_value,FIFO full flag failed);

/* Read the remaining data in the receive FIFO of the trickbox */ 
for(i = Count_value; i<= 7; i++) 
{
  PSR(data[TrRdPtr],0x1FF,SCITrDATA);
  TrRdPtr++;
    if(TrRdPtr > 0x0F)
      TrRdPtr = 0x00;
}

PI(Dummyclock);
PSR(0x02,0x03,SCIFIFOSTATUS);

/* Clear all interrupts */
PSW(0x1FFF,SCIICR);
PI(Dummyclock);
 
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
