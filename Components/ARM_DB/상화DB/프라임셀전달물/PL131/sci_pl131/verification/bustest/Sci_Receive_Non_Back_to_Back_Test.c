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
--  File Name              : Sci_Receive_Non_Back_to_Back_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function Receive_Non_Back_to_Back_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void Receive_Non_Back_to_Back_Test(DATA_value,BAUD_value,SCIVALUE_value,
     SCICR0_value,Jitter_value,Jitter_Pattern) 

{

/*
  Summary :  Receive_Non_Back_to_Back_Test Test
  =============================================
 
  o This test checks the receiver by send a single byte.
 
  o After Initialisation, transmit one data and read the data from the 
    Interface and verify it.

  o Depending on the programmed parameter it can check
    --  direct/inverse convention in the I/O line 
    --  direct/inverse convention in the ordering of data 
  
  o Data value, Baud value, SCIVALUE value,Jitter value,Jitter pattern
    also can be programmed.

*/

int i,Poll_value,DATA_READ_value,DATA_SWAP_value =0x00, tDATA_SWAP_value,
    EXOR_DATA_value,SCITr_value = 0x0000,DELAY_value;

/* Function declaration reproduced here for reference
Initialisation(int BAUD_value,  int SCIVALUE_value,
                    int ATIME_value, int DTIME_value)
*/
Initialisation(BAUD_value,SCIVALUE_value,0x05,0x05);
 
/* Write SCICR0_value into the SCICR0 register. This makes the SCI transmit 
and receive data in direct/inverse mode */ 
PSW(SCICR0_value,SCICR0);

/* Program the jitter value and jitter pattern */
PSW(Jitter_value,SCITrJit);
PSW(Jitter_Pattern,SCITrJitPat);

/* Program the RXTIDE value to 0x00. So SCIRXTIDEINTR becomes high when
the receive FIFO contains one data */ 
PSW(0x00,SCITIDE);

/* Write a data to the Transmit FIFO of the trickbox */
PSW(DATA_value,SCITrDATA);

/* Program the trickbox control register with nRST = '1' and programmed
SENSE value */ 
SCITr_value = 0x4000 & (SCICR0_value << 14) | 0x2013;
PSW(SCITr_value,SCITrCR);
PI(Dummyclock);

Poll_value = (BAUD_value + 0x01) * SCIVALUE_value  * 0x0C * clkmulfactor 
             + Margin;
PO(0x0004,0x00000004,SCITrSR1,Poll_value,SCIRXTIDEINTR failed);


/* Find the data value when the SENSE bit becomes set */  
EXOR_DATA_value = DATA_value ^ 0xFF; 

/* Find the data value when the MSB is transmitted first */  
for(i = 0x00; i<= 7; i++)  
{
  tDATA_SWAP_value =  0x01 & (DATA_value >> (7- i));  
  DATA_SWAP_value =  DATA_SWAP_value | (tDATA_SWAP_value << (8-i)); 
} 

/* If  SENSE = '1' and ORDER = '1' */ 
if((SCICR0_value & 0x03) == 0x03)
  DATA_READ_value = DATA_SWAP_value ^ 0xFF; 

/* If  SENSE = '0' and ORDER = '1' */ 
else if((SCICR0_value & 0x03) == 0x02)
  DATA_READ_value = DATA_SWAP_value; 

/* If  SENSE = '1' and ORDER = '0' */ 
else if((SCICR0_value & 0x03) == 0x01)
  DATA_READ_value = EXOR_DATA_value;

/* If  SENSE = '1' and ORDER = '0' */ 
else
  DATA_READ_value = DATA_value; 

/* Read the SCIRXCOUNT. Expecting a value of 0x01*/ 
PSR(0x01,0x000000FF,SCIRXCOUNT);

/* Read the receive FIFO */
PSR(DATA_READ_value,0x000001FF,SCIDATA);

/* Read the SCIRXCOUNT. Expecting a value of 0x00 */ 
PSR(0x00,0x000000FF,SCIRXCOUNT); 

/* Deactivate the card by writing '1' to the finish bit */
PSW(0x02,SCICR2);
PI(Dummyclock);

/* Function declaration reproduced here for reference
Poll_value = (DactCount_value + 0x01) * (CLKICC_value + 0x01) * 0x02
             * clkmulfactor + Margin;
*/ 
Poll_value = (0x05 + 0x01) * (0x03 + 0x01) * 0x02
             * clkmulfactor * 0x03  + Margin;
PO(0x0200,0x00000200,SCITrSR1,Poll_value,SCICARDDNINTR_failed);

/* Clear all interrupts */
PSW(0x7FFF,SCIICR);

/* Disable the SCIDETECT signal */
PSW(0x2001,SCITrCR);

DELAY_value = (0x05 + 0x01) * (0x03 + 0x01) * 0x02
             * clkmulfactor * 0x05 + Margin;
/* Waiting for the completion of the deactivation */
  DELAY_value = DELAY_value/254  + 1;
 
  for(i = DELAY_value; i > 0; i--)
  PI(254);
 

}/* End Function */
