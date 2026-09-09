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
--  File Name              : Sci_Transmit_Parity_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function Transmit_Parity_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void Transmit_Parity_Test(SCIRETRY_value, SCITrRXPC_value, MODE_value)

{
/*
  Summary : Transmit_Parity_Test 
  ===============================
 
  o This test checks the retry counter and parity error generation
 
  o Enable the trick box transmitter after the initialisation
 
  o Force parity error condition and request the transmitter for retransmission
  
  o Check timings of the hand shaking
 
*/
 

int  Poll_value,i,j,SCIWrPtr =0x00,TrRdPtr =0x00, RETRY_value,PERdata = 0x00,
     SCICR0_value = 0x00, SCITrFiLCR_value,DELAY_value;

/* Function declaration reproduced here for reference
void  Initialisation(int BAUD_value,  int SCIVALUE_value,
                    int ATIME_value, int DTIME_value)
*/
 
Initialisation(0x01,0x05,0x05,0x05);

/* Make the setting level of the TFS flag in the tricbox to 0000 */
PSW(0x00,SCITrFiLCR);

/* Program the trickbox and SCI retry registers */ 
PSW(SCITrRXPC_value,SCITrRXPC);
PSW(SCIRETRY_value,SCIRETRY);

/* Program the mode value */
SCICR0_value = MODE_value << 3;
PSW(SCICR0_value,SCICR0);

/* Enable the SCI in the transmit mode */
PSW(0x04,SCICR1);

for(i = 0; i<= 7; i++)
  {
  if ( MODE_value == 0x01)
    PSW(0x2455,SCITrCR);
  else
    PSW(0x2055,SCITrCR);
    
  PI(Dummyclock);
  PSW(data[SCIWrPtr],SCIDATA);
  SCIWrPtr++; 
  PI(Dummyclock);

/* More number of retry than SCI retry register in TO mode */
  if ((SCITrRXPC_value > SCIRETRY_value) && (MODE_value == 0x01)) 
    {
      Poll_value = (0x01 + 0x01) * 0x05 * 0x10 * (SCIRETRY_value + 0x01)
                    * clkmulfactor + Margin;
      PO(0x0100,0x0100,SCITrSR1,Poll_value);
      PSW(0x010,SCIICR);
      PSW(0x2415,SCITrCR);
      PSW(0x00,SCITXCOUNT);
      for(j = SCIRETRY_value; j >= 0; j--)     
        PSR(data[TrRdPtr],0x000001FF,SCITrDATA);
        TrRdPtr++; 
    }
/* Less number of retry than SCI retry register in TO mode */
  else if((SCITrRXPC_value <= SCIRETRY_value) && (MODE_value == 0x01))
    { 
      Poll_value = (0x01 + 0x01) * 0x05 * 0x10 * (SCITrRXPC_value + 0x01)
                    * clkmulfactor + Margin;
      PO(0x00,0x0F,SCITXCOUNT,Poll_value);
      for(j = SCITrRXPC_value; j >= 0; j--) 
        PSR(data[TrRdPtr],0x000001FF,SCITrDATA);
        TrRdPtr++; 
    } 
/* In T1 mode no retry is allowed */  
  else  
    { 
      Poll_value = (0x01+0x01) * 0x05 * 0x10 * clkmulfactor + Margin;
      PO(0x00,0x0F,SCITXCOUNT,Poll_value);
      PSR(data[TrRdPtr],0x000001FF,SCITrDATA);
      TrRdPtr++;
    } 

}

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
 
}/* Function End */
