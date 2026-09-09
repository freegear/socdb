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
--  File Name              : Sci_Receive_OverRun_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function RxOverRun_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void RxOverRun_Test() 

{

/*
  Summary :  Receive OverRun  Test
  ================================
 
  o This test checks that if the SCI Receive FIFO is full and more
    data is attempted to be written to it, then the Receive OverRun
    interrupt is generated to inform the system that data has not
    be captured.

  o After initialisation, 8 values are written to the Trickbox Tx 
    FIFO, then tranmitted to the SCI.

  o The SCIFIFOSTATUS is checked for RXFF being set, the SCIRORINTR
    is checked to be still deasserted.

  o One more value is written to the Trickbox and transmitted to
    SCI.

  o Sufficient time is allowed for reception to complete and then
    the SCIRORINTR is check to be asserted.

  o One value is read from the SCI Rx FIFO and the SCIRORINTR is
    checked to have remained asserted.

  o The remaining 7 values are read from the SCI Rx FIFO, the
    SCIRORINTR should remain asserted.

  o The SCIRORINTR is then cleared by writing a "1" to the
    RORIC bit within the SCIICR register. Its deasserted
    state is then check.

  o The Trickbox is disabled with nSCIRST remaining high.

*/


int i, DELAY_value, SCIVALUE_value = 0x05, SCIBAUD_value = 0x04, Poll_value;
int DATA_READ_value;

/* Function declaration reproduced here for reference
Initialisation(int SCIBAUD_value,  int SCIVALUE_value,
                    int ATIME_value, int DTIME_value)
*/

Initialisation(0x04,0x05,0x05,0x05);
 
/* Program SCICR0: 
   Direct convention, lsb first, tx even parity, 
   no tx handshaking, rx even parity, no rx handshaking 
   sci clock enabled, clock stop value logic 0. */
PSW(0x00, SCICR0);

/* Program SCICR1: 
   ATR timeout disabled, block timeout disabled, receive mode,
   sciclk configured as buffer output, block guard timer disabled,
   bypass fixed debounce timer, asynchronous card mode. */
PSW(0x20, SCICR1);

/* Program SCITIDE:Set the Tx and Rx tide levels to 4 */
PSW(0x44, SCITIDE);

/* Program SCIICR: Clear all the interrupts */
PSW(0x1FFF, SCIICR);

/* Program SCIIMSC: UnMask the SCIRORINTR interrupts */
PSW(0x0400, SCIIMSC);


/* Write 8 values in the Trickbox Tx FIFO */

for (i = 1; i <= 8; i++)
  { 
    PSW(i | i << 4, SCITrDATA);
  }

/* Enable the Trickbox transmit logic */
PSW(0x2013, SCITrCR);
PI(Dummyclock);


Poll_value = (((SCIBAUD_value + 0x01) * SCIVALUE_value ) * 0x0C) 
             * clkmulfactor + 0x20;

/* Poll the SCIFIFOSTATUS register for 8 words to be have been 
   received by the SCI Rx FIFO register i.e check for the 
   RXFF bit to be set */

PO(0x4,0x00000004, SCIFIFOSTATUS, 8*Poll_value, SCI_RX_FIFO_full);
PSR(0x4, 0x00000004, SCIFIFOSTATUS);

/* Check that the SCIRORINTR is not asserted */
PSR(0x0000, 0x0400, SCIRIS);
PSR(0x0000, 0x0400, SCIMIS);
PSR(0x0000, 0x2000, SCITrSR1);

/* Disable the Trickbox transmit logic */
PSW(0x2011, SCITrCR);
PI(Dummyclock);

/* Write 1 more values to the Trickbox Tx FIFO */

for (i = 9; i <= 9; i++)
  { 
    PSW(i | i << 4, SCITrDATA);
  }

/* Enable the Trickbox transmit logic */
PSW(0x2013, SCITrCR);
PI(Dummyclock);

Poll_value = (((SCIBAUD_value + 0x01) * SCIVALUE_value ) * 0x0C) 
             * clkmulfactor + 0x20;

/* Poll the SCITrSR1 register for SCIRORINTR assertion */

PO(0x2000,0x00002000, SCITrSR1, Poll_value, SCIRORINTR_asserted);
PSR(0x0400, 0x0400, SCIRIS);
PSR(0x0400, 0x0400, SCIMIS);
PSR(0x2000, 0x00002000, SCITrSR1);

/* Read 1 value from the SCI RX FIFO */
PSR(0x11, 0x2FF, SCIDATA);
PI(4);

/* Check that SCIRORINTR is still asserted */
PSR(0x2000, 0x00002000, SCITrSR1);

/* Read the remaining 7 values from the SCI RX FIFO */
for (i = 2; i <= 8; i++)
  { 
    PSR(i | i << 4, 0x2FF, SCIDATA);
  }

/* Check that SCIRORINTR is still asserted */
PSR(0x2000, 0x00002000, SCITrSR1);

/* Clear the SCIRORINTR by writing to the SCIICR register */
PSW(0x0400, SCIICR);
PI(Dummyclock);

/* Check that SCIRORINTR is cleared */
PSR(0x0000, 0x0400, SCIRIS);
PSR(0x0000, 0x0400, SCIMIS);
PSR(0x0000, 0x00002000, SCITrSR1);


/* Disable the SCIDETECT signal and the Trickbox enable/transmit */
PSW(0x2000,SCITrCR);
PI(Dummyclock);
 
DELAY_value = (0x05 + 0x01) * (0x03 + 0x01) * 0x02
             * clkmulfactor * 0x03 + Margin;
 
/* Waiting for the completion of the deactivation */
  DELAY_value = DELAY_value/254  + 1;
 
  for(i = DELAY_value; i > 0; i--)
  PI(254);
 
}/* End Function */
