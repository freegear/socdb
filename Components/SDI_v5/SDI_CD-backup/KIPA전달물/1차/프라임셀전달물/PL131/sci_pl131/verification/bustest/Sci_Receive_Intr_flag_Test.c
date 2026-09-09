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
--  File Name              : Sci_Receive_Intr_flag_Test.c.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function Receive_Intr_flag_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void Receive_Intr_flag_Test()

{

/*
  Summary :  Receive_Intr_flag_Test 
  ==================================
 
  o This test checks the RXFF,RXFE flags, and SCIRXTIDE interrupts at all
    TIDE values.    
 
  o Enable the trick box transmitter after the initialisation 
 
  o Check the flags and interrupts.

*/

  int  i,Poll_value,SCITr_value,TrWrPtr = 0x00,SCIRdPtr = 0x00,
     loop,RXCOUNT_value = 0x00,Count_value = 0x00, DELAY_value;


  /* Function declaration reproduced here for reference
  Initialisation(int BAUD_value,  int SCIVALUE_value,
                    int ATIME_value, int DTIME_value)
*/
  Initialisation(0x01,0x05,0x05,0x05);

  /* Initilise the control registers */
  PSW(0x00,SCICR0);
  PSW(0x00,SCICR1);

  /*  Set the TFR to 0x01 */
  PSW(0x01,SCITrFiLCR);

  /* Enable the trick box transmitter */
  PSW(0x2013,SCITrCR);

  /* Write data into the trickbox transmit FIFO */
  for(i =0; i<= 7; i++)
  {
    PSW(data[TrWrPtr],SCITrDATA);
     TrWrPtr++; 
  }

  PI(Dummyclock);

  for(loop = 0x00; loop <= 7; loop++)
  {

    /* Program the TIDE value */ 
    RXCOUNT_value = Count_value << 0x04;
    PSW(RXCOUNT_value,SCITIDE);

    /* Function declaration reproduced here for reference */
    /* Poll_value = (Count_value + 0x01) * (Baud_value + 0x01) *
                  SCIVALUE * Number of etu  
    */
    Poll_value = (Count_value + 1) * 0x02 * 0x05 * 0x0C * clkmulfactor
                   + Margin;
    PO(0x0004,0x00000004,SCITrSR1,Poll_value,SCIRXTIDEINTR failed);

    /* If the Count value is more than 0x07 the FIFO becomes full and RXFF 
     becomes high */ 
    if(Count_value <= 0x07)
      PSR(0x00,0x0C,SCIFIFOSTATUS);
    else
      PSR(0x04,0x0C,SCIFIFOSTATUS);

    /* Read the SCI receive FIFO */
    if (Count_value == 0x00)
    {
      /* Read the first FIFO location */
      PSR(data[SCIRdPtr],0x1FF,SCIDATA);
        SCIRdPtr++;
      /* Array size is 16 */ 
      if(SCIRdPtr > 0x0F)
        SCIRdPtr = 0x00;
    }
    else
    for(i = Count_value; i> 0; i--) 
    {
      PSR(data[SCIRdPtr],0x1FF,SCIDATA);
        SCIRdPtr++;
      /* Array size is 16 */ 
      if(SCIRdPtr > 0x0F)
      SCIRdPtr = 0x00;
    }

    /* Write data into the transmit FIFO of the trickbox */ 
    if (Count_value == 0x00)
    {
      PSW(data[TrWrPtr],SCITrDATA);
      TrWrPtr++;

      /* Array size is 16 */ 
      if(TrWrPtr > 0x0F)
        TrWrPtr = 0x00;
    }
    else
    for(i = Count_value; i> 0; i--) 
    {
      PSW(data[TrWrPtr],SCITrDATA);
      TrWrPtr++;

      /* Array size is 16 */ 
      if(TrWrPtr > 0x0F)
        TrWrPtr = 0x00;
    }

    Count_value = Count_value + 1;

  }

  RXCOUNT_value = Count_value << 0x04;
  PSW(RXCOUNT_value,SCITIDE);

 /* Wait for the transmission to complete */ 
  Poll_value = (Count_value + 1) * 0x02 * 0x05 * 0x0C * clkmulfactor + Margin;
  PO(0x04,0x04,SCIFIFOSTATUS,Poll_value,FIFO full flag failed);
  PI(Dummyclock);
  PSR(0x0004,0x00000004,SCITrSR1);

  /* Read the received data from the SCI receive FIFO */ 
  for(i = Count_value; i>= 1; i--) 
  {
    PSR(data[SCIRdPtr],0x1FF,SCIDATA);
    SCIRdPtr++;

  /* Array size is 16 */ 
    if(SCIRdPtr > 0x0F)
      SCIRdPtr = 0x00;
  }
  /* Clear all interrupts */
  PSW(0xFFF,SCIICR);
 
  /* Disable the SCIDETECT signal */
  PSW(0x2001,SCITrCR);
 
  DELAY_value = (0x05 + 0x01) * (0x03 + 0x01) * 0x02
             * clkmulfactor * 0x03 + Margin;
 
  /* Waiting for the completion of the deactivation */
  DELAY_value = DELAY_value/254  + 1;
 
  for(i = DELAY_value; i > 0; i--)
  PI(254);

}/* End Function */
