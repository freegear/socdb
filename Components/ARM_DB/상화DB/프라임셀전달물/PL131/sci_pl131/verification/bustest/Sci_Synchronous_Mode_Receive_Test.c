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
--  File Name              : Sci_Synchronous_Mode_Receive_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function Synchronous_Mode_Receive_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void Synchronous_Mode_Receive_Test()
{
 
/*
  Summary : Synchronous_Mode_Receive_Test
  =======================================
 
  o This test checks reception in Synchronous mode
 
  o After Initialisation enable the Synchronous mode

  o In this mode data and SCICLK are driven by the trickbox. It can be 
    checked by reading from the RAWSTAT register.   

  o Also this test checks the deactivation by SCIDEACREQ and SCIDEACACK
    given by the SCI after deactivation.  

*/
 
int Poll_value,i,value = 0x00,DELAY_value;
 
/* This function initialise the SCI and trickbox
Initialisation(int BAUD_value,  int SCIVALUE_value,
                    int ATIME_value, int DTIME_value)
*/
Initialisation(0x01,0x05,0x05,0x05);
 
/* Enable the Synchronous Mode */
PSW(0x40,SCICR1);
PI(Dummyclock);

/* Disable the WDATAEN and WCLKEN */
PSW(0x0F,SCISYNCTX);
PI(Dummyclock);

/* Enable the trickbox transmitter and SCICLKOUT from the trickbox */ 
PSW(0xA013,SCITrCR);
PI(Dummyclock);

/* Write data into the transmit FIFO of the trickbox */

PSW(0x03,SCITrDATA);
Poll_value = 0x0FFF;
PO(0x00,0x03,SCISYNCRX,Poll_value,SYNCRX_Read);
PO(0x10,0x03,SCISYNCRX,Poll_value,SYNCRX_Read);
PO(0x10,0x03,SCISYNCRX,Poll_value,SYNCRX_Read);
PO(0x11,0x03,SCISYNCRX,Poll_value,SYNCRX_Read);

DELAY_value = 0x02 * 0x05 * 0x10 * clkmulfactor + Margin;
/* Waiting for the completion of the transmission */
  DELAY_value = DELAY_value/254  + 1;
 
  for(i = DELAY_value; i > 0; i--)
  PI(254);

/* Start deactivation using SCIDEACREQ. Also Disble the SCICLKOUT from
the trickbox */
PSW(0x2813,SCITrCR);
PI(Dummyclock);

/* Poll for SCICARDDNINTR
Poll_value  = (DactCount_value + 0x01) * (CLKICC_value + 0x01) * 0x02
             * clkmulfactor * 0x03 + Margin;
*/
 
Poll_value = 0x03 * 0x08 *  clkmulfactor * 0x03 + Margin;
PO(0x0200,0x0200,SCITrSR1,Poll_value,SCICARDDNINTR_failed);

/* Disable the synchronous mode */
PSW(0x00,SCICR1);

/* Read SCIDEACACK pin */
PSR(0x01,0x01,SCITrSR2);

/* Disable the SCIDETECT signal */
PSW(0x2001,SCITrCR);
 
DELAY_value = (0x05 + 0x01) * (0x03 + 0x01) * 0x02
             * clkmulfactor * 0x03 + Margin;
 
/* Waiting for the completion of the deactivation */
  DELAY_value = DELAY_value/254  + 1;
 
  for(i = DELAY_value; i > 0; i--)
  PI(254);

PI(Dummyclock);

}/* End Function */
