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
--  File Name              : Sci_Transmit_non_Back_to_Back_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function Transmit_non_Back_to_Back_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void Transmit_non_Back_to_Back_Test(int DATA_value, int BAUD_value,
                                    int SCIVALUE_value, int SCICR0_value)
 
{
/*
  Summary : Transmit_non_Back_to_Back_Test 
  =========================================
 
  o This test checks the transmitter by sending a single byte.
 
  o After Initialisation, transmit one data and read the data from the
    trickbox receiver and verify it.
 
  o Depending on the programmed parameter it can check
    --  direct/inverse convention in the I/O line
    --  direct/inverse convention in the ordering of data
 
  o Data value, Baud value, SCIVALUE value,Jitter value,Jitter pattern
    also can be programmed.
*/ 

int i,Poll_value,DATA_READ_value,DATA_SWAP_value =0x00, tDATA_SWAP_value,
    EXOR_DATA_value,SCITr_value = 0x0000,Parity = 0x00,DELAY_value;

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
 
/* Write  programmed value into the SCIVALUE register */
PSW(SCIVALUE_value,SCIVALUE);
PSW(SCIVALUE_value,SCITrVALUE);
 
/* Write the Card activation time in SCIATIME register */
PSW(0x05,SCIATIME);
PSW(0x05,SCITrAT);
 
/* Write the Card deactivation time in SCIDTIME register */
PSW(0x05,SCIDTIME);
PSW(0x05,SCITrDT);

/* Write SCICR0_value into the SCICR0 register. This makes the SCI transmit
and receive data in direct/inverse mode */
PSW(SCICR0_value,SCICR0);
 
/* Enable the trickbox; also make SCIDETECT signal to '1' */
PSW(0x2011,SCITrCR);
PI(Dummyclock);
 
/* Poll for the SCICARDININTR */
Poll_value = 0x05 * clkmulfactor + 0x10;
PO(0x1000,0x00001000,SCITrSR1,Poll_value,SCICARDININTR failed);
 
/* Initiate the activation sequence by writing  '1' to the Start bit */
PSW(0x01,SCICR2);
PI(Dummyclock);
 
Poll_value =  0x05 * 0x08 * 0x03 * clkmulfactor + Margin;
PO(0x0400,0x00000400,SCITrSR1,Poll_value,SCICARDUPINTR failed);

/* Configure the trickbox in the required sense(data line) */  
SCITr_value = 0x4000 & (SCICR0_value << 14) | 0x2015;
PSW(SCITr_value,SCITrCR);

/* Make the setting level of the TFS flag in the tricbox to 0001 */
PSW(0x10,SCITrFiLCR);
 
/* Enable the SCI in the transmit mode */
PSW(0x04,SCICR1);

/* Write a data to the Transmit FIFO of the SCI */
PSW(DATA_value,SCIDATA);

Poll_value = (((BAUD_value + 0x01) * SCIVALUE_value ) * 0x0C) 
             * clkmulfactor + 0x20;
PO(0x08,0x00000008,SCITrSR0,Poll_value, SCITrRFS failed);
 
/* Find the data value when the SENSE bit becomes set */
EXOR_DATA_value = DATA_value ^ 0xFF;

/* Find the data value when the MSB is transmitted first */
for(i = 0x00; i<= 7; i++)
{
  tDATA_SWAP_value =  0x01 & (DATA_value >> (7- i));
  Parity = Parity ^ tDATA_SWAP_value;
  DATA_SWAP_value =  DATA_SWAP_value | (tDATA_SWAP_value << (8-i));
}

/* If  SENSE = '1' and ORDER = '1' */
if((SCICR0_value & 0x03) == 0x03)
{
  DATA_READ_value = DATA_SWAP_value ^ 0xFF;
  Parity = Parity ^ 0x01;
}

/* If  SENSE = '0' and ORDER = '1' */
else if((SCICR0_value & 0x03) == 0x02)
  DATA_READ_value = DATA_SWAP_value;

/* If  SENSE = '1' and ORDER = '0' */
else if((SCICR0_value & 0x03) == 0x01)
{
  DATA_READ_value = EXOR_DATA_value;
  Parity = Parity ^ 0x01;
}

/* If  SENSE = '1' and ORDER = '0' */
else
  DATA_READ_value = DATA_value;

DATA_READ_value = DATA_READ_value | (Parity << 8); 

PO(0x00,0x000000FF,SCITXCOUNT,0x09);
PSR(DATA_READ_value,0x000001FF,SCITrDATA);

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
