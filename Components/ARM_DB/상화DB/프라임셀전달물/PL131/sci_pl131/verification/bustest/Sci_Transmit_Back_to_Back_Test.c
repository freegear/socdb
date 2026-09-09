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
--  File Name              : Sci_Transmit_Back_to_Back_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function Transmit_Back_to_Back_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void Transmit_Back_to_Back_Test(int SCICR0_value)

{

/*
  Summary : Transmit_Back_to_Back_Test 
  =====================================
 
  o This test checks the receiver by sending bytes continuously. Also toggle
    the the Wrap flag in the FIFO at all read pointer and write pointer
    values.
 
  o Initialise the the SCI using the function Initialisation  
 
  o Depending on the programmed parameter it can check
     direct/inverse convention in the I/O line
     direct/inverse convention in the ordering of data
 
*/

  int  i,j,Poll_value, SCITr_value, SCIWrPtr = 0x00,TrRdPtr = 0x00,
       loop,DELAY_value, DATA_READ_value, tDATA_READ_value, Parity = 0x00; 

/* Function declaration reproduced here for reference
Initialisation(int BAUD_value,  int SCIVALUE_value,
               int ATIME_value, int DTIME_value)
*/
 
Initialisation(0x01,0x05,0x05,0x05);
 
/*  Set the RFR to 0x01 */
PSW(0x70,SCITrFiLCR);
PI(Dummyclock);

/* Enable Error Messges */ 
PSW(0x10,SCITrCTRL);

/* Program the Trickbox control register with programmed 
SENSE and ORDER value */
SCITr_value = 0x4000 & (SCICR0_value << 14) | 0x201D;
PSW(SCITr_value,SCITrCR);
PI(Dummyclock);
PSW(SCICR0_value,SCICR0);
PI(Dummyclock);

/* Enable the SCI transmitter */
PSW(0x04,SCICR1);
PI(Dummyclock);

/* Write data into the SCI transmit FIFO */
PSW(data[SCIWrPtr],SCIDATA);
 SCIWrPtr++; 
 PI(Dummyclock);
for(loop = 0x00; loop <= 8; loop++)
{
for(i=0x00; i<= 6; i++)
  {
    PSW(data[SCIWrPtr],SCIDATA);
    SCIWrPtr++; 
    if(SCIWrPtr > 0x0F)
      SCIWrPtr = 0x00;
  }

/* Poll conditions becomes satisfied when the Receive FIFO level of the trickbox
reaches seven */  
Poll_value = (0x01 + 0x01) * 0x05 * 0x0C * 0x07 
              * clkmulfactor + Margin;
PO(0x08,0x08,SCITrSR0,Poll_value);

/* Read the Receive FIFO of the trickbox */  
for(i= 0x00; i <= 6; i++)
  {
    DATA_READ_value = Receive_Data(SCICR0_value,TrRdPtr);
    PSR(DATA_READ_value,0x1FF,SCITrDATA);
    TrRdPtr++;
    Parity = 0x00; 
      if(TrRdPtr > 0x0F)
        TrRdPtr = 0x00;
  } 

}

/* Waiting for the completion of the last data transmit */
DELAY_value = (0x01 + 0x01) * 0x05 * 0x0C * 0x07
              * clkmulfactor + Margin;

DELAY_value = DELAY_value/254 + 1; 

  for(i = DELAY_value; i > 0; i--) 
    PI(254);

/* Read the last data */
DATA_READ_value = Receive_Data(SCICR0_value,TrRdPtr);
PSR(DATA_READ_value,0x1FF,SCITrDATA);

/* Clear all interrupts */
PSW(0x1FFF,SCIICR);
PI(Dummyclock);
 
/* Disable Error Messges */ 
PSW(0x00,SCITrCTRL);

/* Disable the SCIDETECT signal */
PSW(0x2001,SCITrCR);
 
DELAY_value = (0x05 + 0x01) * (0x03 + 0x01) * 0x02
             * clkmulfactor * 0x03 + Margin;
 
/* Waiting for the completion of the deactivation */
DELAY_value = DELAY_value/254  + 1;
 
  for(i = DELAY_value; i > 0; i--)
  PI(254);
 
}/* Function End */

int Receive_Data(int SCICR0_value,int TrRdPtr)
{

/*
  Summary : Receive_Data 
  =======================

  o This function generates the expected data value. It takes the data value 
    transmitted by the trick box, order, sense as inputs and generates the 
    expected data value to be received by the SCI.       
 
*/

  int  j, DATA_READ_value, tDATA_READ_value, Parity = 0x00;


/* If SENSE = 0 and ORDER = 0 */
  if(SCICR0_value == 0x00)
    {
      DATA_READ_value = data[TrRdPtr];
      for(j = 0x00; j<= 7; j++)
        {
          tDATA_READ_value =  0x01 & ( data[TrRdPtr] >> (7- j));
          Parity = Parity ^ tDATA_READ_value;
        }
        DATA_READ_value = DATA_READ_value | (Parity << 8);
    }


/* If SENSE = 1 and ORDER = 0 */
  else if(SCICR0_value == 0x01) 
    {
      DATA_READ_value = Exordata[TrRdPtr];
      for(j = 0x00; j<= 7; j++)
        {
          tDATA_READ_value =  0x01 & ( Exordata[TrRdPtr] >> (7- j));
          Parity = Parity ^ tDATA_READ_value;
        }
       Parity = Parity  ^ 0x01;
       DATA_READ_value = DATA_READ_value | (Parity << 8);
    }

/* If SENSE = 0 and ORDER = 1 */
  else if(SCICR0_value == 0x02) 
    {
      DATA_READ_value = Swapdata[TrRdPtr];
      for(j = 0x00; j<= 7; j++)
        {
          tDATA_READ_value =  0x01 & ( Swapdata[TrRdPtr] >> (7- j));
          Parity = Parity ^ tDATA_READ_value;
        }
        DATA_READ_value = DATA_READ_value | (Parity << 8);
    }

/* If SENSE = 1 and ORDER = 1 */
  else
    {
      DATA_READ_value = ExorSwapdata[TrRdPtr];
      for(j = 0x00; j<= 7; j++)
        {
          tDATA_READ_value =  0x01 & ( ExorSwapdata[TrRdPtr] >> (7- j));
          Parity = Parity ^ tDATA_READ_value;
        }
      Parity = Parity ^ 0x01;
      DATA_READ_value = DATA_READ_value | (Parity << 8);
    }
        
return(DATA_READ_value); 

}/* End Function */
