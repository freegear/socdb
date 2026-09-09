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
--  File Name              : Sci_TXERRINTR_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function TXERRINTR_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void TXERRINTR_Test(DATA_value, SCIRETRY_value, SCITrRXPC_value, 
                           MODE_value)

{

/*
  Summary : TXERRINTR_Test 
  ========================
 
  o This test checks the generation of SCITXERRINTR. By changing the parameter,
    MODE_value, it is possible to run this test both in T0 and TI mode.
    In case of T1 mode, SCITXERRINTR should not be asserted.     
 
  o Enable the trick box receiver, mode of operation(T1 or T0) after the 
    initialisation of the SCI. 
 
  o Program the SCIRETRY and trickbox retry registers. If the SCIRETRY
    register value is less, trick box requests for more number of retransmission;
    this causes the SCI to generate SCITXERRINTR in T0 mode. 

*/

int  i,j, Poll_value, RETRY_value = 0x00, SCICR0_value = 0x00, DELAY_value,
     tDATA_SWAP_value,Parity = 0x00,RDATA_value = 0x00;

/* Function declaration reproduced here for reference
void  Initialisation(int BAUD_value,  int SCIVALUE_value,
                    int ATIME_value, int DTIME_value)
*/
 
Initialisation(0x01,0x05,0x05,0x05);

/* Program the trickbox and SCI retry counter. Program the trickbox retry
counter with larger value. So trickbox sends more number of wrong parity bit
than the SCIRETRY couter value. It makes the SCI assert TXERR */    
/*  Set the TFR to 0x01 */
PSW(SCITrRXPC_value,SCITrRXPC);
RETRY_value = SCIRETRY_value; 
PSW(RETRY_value,SCIRETRY);
SCICR0_value = MODE_value << 3;
PSW(SCICR0_value,SCICR0);
PSW(0x2455,SCITrCR);

for(i = 0x00; i<= 7; i++)
{
  tDATA_SWAP_value =  0x01 & (DATA_value >> (7- i));
  Parity = Parity ^ tDATA_SWAP_value;
}

RDATA_value = DATA_value | Parity << 8;

/*  Set the TFR to 0x01 */
PSW(0x10,SCITrFiLCR);

PSW(0x04,SCICR1);

 PSW(DATA_value,SCIDATA);
 PI(Dummyclock); 

if(MODE_value == 0x01)
{
 Poll_value = (0x01+0x01) * 0x05 * 0x10 * clkmulfactor 
              * (SCIRETRY_value + 0x01)  + Margin;
 PO(0x0100,0x0100,SCITrSR1,Poll_value);
 PSW(0x010,SCIICR);
 PSW(0x00,SCITXCOUNT);
 for(j = RETRY_value; j >= 0; j--)     
   PSR(RDATA_value,0x000001FF,SCITrDATA);
 PI(Dummyclock); 
}

else
{
 Poll_value = (0x01+0x01) * 0x05 * 0x10 * clkmulfactor + Margin;
 PO(0x08,0x08,SCITrSR0,0xFF);
 PI(0x02);
 PSR(0x08,0x08,SCITrSR0);

 PSR(RDATA_value,0x000001FF,SCITrDATA);

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
 
}/* End Function */
