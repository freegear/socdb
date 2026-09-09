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
--  File Name              : Sci_Receive_Back_to_Back_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function Receive_Back_to_Back_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void Receive_Back_to_Back_Test(int BAUD_value,int SCIVALUE_value,
                               int SCICR0_value, int Jitter_value,
                               int Jitter_Pattern )

{

/*
  Summary :  Receive_Back_to_Back_Test Test
  ==========================================
 
  o This test checks the receiver by sending bytes continuously. Also toggle  
    the Wrap flag in the FIFO at all read pointer and write pointer 
    values. Jittering of data is also done. (It is possible to program the jitter
    value, jitter Pattern and jitter directionn.)  
 
  o Keeping the SCIDETECT signal high for a time which is sufficient to
    generate SCICARDININTR and check whether the interrupt is generated.
 
  o Start the Card activation sequence by enabling the Start bit.
 
  o Check the card activation sequence. Also Poll for the SCICARDUPINTR.
 
  o Depending on the programmed parameter it can check
     direct/inverse convention in the I/O line
     direct/inverse convention in the ordering of data
 
  o Baud value, SCIVALUE value,Jitter value,Jitter pattern
    also can be programmed.
 
*/

int  i,Poll_value,SCITr_value = 0x00,TrWrPtr = 0x00,SCIRdPtr = 0x00,
     loop,DELAY_value;


/* Program the SCICLKICC register. It is used for SCICLK width calculation */
PSW(0x03,SCICLKICC);
PSW(0x03,SCITrCKICC);
 
/* Enable all SCI interrupts */
PSW(0x7FFF,SCIIMSC);
 
/* Enable the Bypass mode. Also write a value to the SCISTABLE register */
PSW(0x05,SCISTABLE);
PSW(0x20,SCICR1);

/* Write programmed value into the BAUD register */ 
PSW(BAUD_value,SCIBAUD);
PSW(BAUD_value,SCITrBAUD);

/* Write programmed value into the SCIVALUE register */ 
PSW(SCIVALUE_value,SCIVALUE);
PSW(SCIVALUE_value,SCITrVALUE);

/* Write the Card activation time in SCIATIME register */ 
PSW(0x05,SCIATIME);
PSW(0x05,SCITrAT);
 
/* Write the Card deactivation time in SCIDTIME register */ 
PSW(0x05,SCIDTIME);
PSW(0x05,SCITrDT);

/* Write SCICR0_value into the SCICR0 register. This makes the SCI to transmit 
and receive data in direct/inverse mode */ 
PSW(SCICR0_value,SCICR0);

/* Enable the trickbox also make SCIDETECT signal to '1' */
PSW(0x2011,SCITrCR);
PI(Dummyclock);
 
/* Poll for the SCICARDININTR. 0x05 is STABLE register value which is
used for debounce time calculation*/
Poll_value = 0x05 * clkmulfactor + Margin;
PO(0x1000,0x00001000,SCITrSR1,Poll_value,SCICARDININTR failed);

/* Initiate the activation sequence by writing '1' to the Start bit */
PSW(0x01,SCICR2);
PI(Dummyclock);

/* Function declaration reproduced here for reference
Poll for the  SCICARDUPINTR 
Poll_value = (DactCount_value + 0x01) * (CLKICC_value + 0x01) * 0x02
             * clkmulfactor + Margin;
*/

Poll_value = (0x05 + 0x01) * (0x03 + 0x01) * 0x02 * 0x03 
              * clkmulfactor + Margin;
PO(0x0400,0x00000400,SCITrSR1,Poll_value,SCICARDUPINTR failed);

/* Program the jitter value and jitter pattern */
PSW(Jitter_value,SCITrJit);
PSW(Jitter_Pattern,SCITrJitPat);

/*  Set the TFR in the trickbox to 0x01. So trick box sets TFR signal to
high when the number of data in the transmit become one or less than one */
PSW(0x00,SCITrFiLCR);
PI(Dummyclock);

/* Program the trickbox control register with nRST = '1' SENSE value */  
SCITr_value = 0x4000 & (SCICR0_value << 14) | (DebugOn << 3) | 0x2013;
PSW(SCITr_value,SCITrCR);
PI(Dummyclock);

/* Enable Error message */
PSW(0x0F,SCITrCTRL);
PI(Dummyclock);

PSW(data[TrWrPtr],SCITrDATA);
TrWrPtr++; 
PI(Dummyclock);


for(loop = 0x00; loop <= 8; loop++)
{

/* Write data into the transmit FIFO of the trickbox */ 
for(i=0x00; i<= 6; i++)
  {
    PSW(data[TrWrPtr],SCITrDATA);

/* Increment the internal write pointer */
    TrWrPtr++; 

/* Array size is 16 */  
    if(TrWrPtr > 0x0F)
      TrWrPtr = 0x00;
  }

/* TFR becomes high after the transmission of seven data.  */ 
Poll_value = (BAUD_value+0x01) * SCIVALUE_value * 0x0C * 0x07 
              * clkmulfactor + Margin;

/* Poll for the TFR from the trickbox */ 
PO(0x01,0x01,SCITrSR0,Poll_value);
 
/* Read the received data from the SCI receive FIFO */ 
  for(i= 0x00; i <= 6; i++)
    {
/* If SENSE = 0 and ORDER = 0 */
      if(SCICR0_value == 0x00)
        PSR(data[SCIRdPtr],0x1FF,SCIDATA);

/* If SENSE = 1 and ORDER = 0 */
      else if(SCICR0_value == 0x01) 
        PSR(Exordata[SCIRdPtr],0x1FF,SCIDATA);

/* If SENSE = 0 and ORDER = 1 */
      else if(SCICR0_value == 0x02) 
        PSR(Swapdata[SCIRdPtr],0x1FF,SCIDATA);

/* If SENSE = 1 and ORDER = 1 */
      else
        PSR(ExorSwapdata[SCIRdPtr],0x1FF,SCIDATA);
/* Increment the internal read pointer after the read */
      SCIRdPtr++;

/* Array size is 16 */  
      if(SCIRdPtr > 0x0F)
        SCIRdPtr = 0x00;
    } 

}
/* Waiting for the completion of the last data transmission */  
  DELAY_value = (BAUD_value + 0x01) * SCIVALUE_value * 0x0C 
                 * clkmulfactor + Margin;
  DELAY_value = DELAY_value /254  + 1;
 
  for(i = DELAY_value; i > 0; i--) 
  PI(254);

/* Read the last data */

/* If SENSE = 0 and ORDER = 0 */
   if(SCICR0_value == 0x00)
     PSR(data[SCIRdPtr],0x1FF,SCIDATA);

/* If SENSE = 1 and ORDER = 0 */
   else if(SCICR0_value == 0x01) 
     PSR(Exordata[SCIRdPtr],0x1FF,SCIDATA);

/* If SENSE = 0 and ORDER = 1 */
   else if(SCICR0_value == 0x02) 
     PSR(Swapdata[SCIRdPtr],0x1FF,SCIDATA);

/* If SENSE = 1 and ORDER = 1 */
    else
     PSR(ExorSwapdata[SCIRdPtr],0x1FF,SCIDATA);

/* Clear all interrupts */
PSW(0xFFF,SCIICR);

/* Disable Error Messges */ 
PSW(0x00,SCITrCTRL);

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
