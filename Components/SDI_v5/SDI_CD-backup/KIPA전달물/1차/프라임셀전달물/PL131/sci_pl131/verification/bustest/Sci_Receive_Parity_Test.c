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
--  File Name              : Sci_Receive_Parity_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function Receive_Parity_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void Receive_Parity_Test(SCIRETRY_value, SCITrTXPC_value, MODE_value)

{

/*
  Summary :  Receive_Parity_Test
  ==================================
 
  o This test checks the retry counter and parity error generation
 
  o Enable the trick box transmitter after the initialisation
 
  o Transmit wrong parity bit and retransmit the data again
    if the SCI requests for retransmission 
         
  o Check timings of the hand shaking  

  o Force more number of parity error than SCIRXRETRY and check the parity
    error bit condition
 
  o Parity check in T1 mode (In T1 mode parity will set immediately after 
    parity error is detected. Also in T1 mode no retransmission is allowed.       
*/

int  Poll_value,i,TrWrPtr =0x00,SCIRdPtr =0x00, RETRY_value,PERdata = 0x00,
     SCICR0_value = 0x00,DELAY_value;

/* Function declaration reproduced here for reference
Initialisation(int BAUD_value,  int SCIVALUE_value,
               int ATIME_value, int DTIME_value)
*/

Initialisation(0x01,0x05,0x05,0x05);

/* Write data into the trickbox transmit FIFO */ 
  for(i = 0; i<= 7; i++)
  {
    PSW(data[TrWrPtr],SCITrDATA);
     TrWrPtr++; 
  }

/* Program the required retry value in to the trickbox and SCI */
/* Trickbox will transmit wrong parity SCITrTXPC_value times for each data */ 
PSW(SCITrTXPC_value,SCITrTXPC);
RETRY_value = SCIRETRY_value << 4;
PSW(RETRY_value,SCIRETRY);

/* Using the Mode_value it is possible to program the T0 and T1 mode */ 
SCICR0_value = SCICR0_value | MODE_value << 5;
PSW(SCICR0_value,SCICR0);

/* Enable trickbox TxParityEn bit */ 
PSW(0x2033,SCITrCR);
PI(Dummyclock);

/* Poll the SCIRXCOUNT for a value 0x08. */   
Poll_value = 0x02 * 0x05 * 0x10 * (SCIRETRY_value + MODE_value + 0x01)
             * clkmulfactor * 0x08 + Margin;
PO(0x08,0x0F,SCIRXCOUNT,Poll_value);

/* Read the receive FIFO of the SCI */

/* If more number of wrong parity is transmitted than SCIRETRY value, parity 
bit becomes high. Also in the case of T1 mode if SCI detects wrong parity 
it will set the parity bit */  
if ((SCITrTXPC_value > SCIRETRY_value)|| 
   ((MODE_value = 0x01) && (SCITrTXPC_value > 0x01)))   
 
    for(i = 0; i<= 7; i++)
    {
      PERdata = (0x100 | data[SCIRdPtr]);  
      PSR(PERdata,0x000001FF,SCIDATA);
      SCIRdPtr++; 
    }

  else 
    for(i = 0; i<= 7; i++)
    { 
      PSR(data[SCIRdPtr],0x000001FF,SCIDATA);
      SCIRdPtr++; 
    } 
 
/* Clear all interrupts */
PSW(0x7FFF,SCIICR);
 
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
