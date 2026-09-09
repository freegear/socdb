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
--  File Name              : Sci_ClockStop_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function ClockStop_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void ClockStop_Test(int CLKDISVAL) 

{

/*
  Summary :  Clock Stop Test
  ==========================
 
  o This function tests that the SCI card clock can be stopped and
    started when no transactions are in progress. It also checks that
    if a transmission or reception is in progress, then the clock stopping
    will not take effect until either has completed. If the clock is stopped
    and the Tx FIFO is written with new data, then the data will not be
    transmitted until the clock has restarted. Stop and Start time durations
    are controlled through the SCISTOPTIME and SCISTARTTIME registers.
  
  o The SCISTOPTIME and SCISTARTTIME registers are programmed with 
    appropriate values.

  o After card initialisation, whilst in Rx mode, the clock is stopped, the
    is SCICLKSTPINTR checked to have occured after the SCISTOPTIME value. The
    clock is then restarted and the SCICLKACTINTR is checked to occur after
    the SCISTARTTIME value.

  o The SCI is programmed into Tx mode and 4 words are written to the SCI 
    TX FIFO.
    During the transmission the clock is programmed to be stopped, but 
    should only stop after the transmission has completed and the CLKSTOPTIME 
    duration has expired. The four words are then read from the trickbox 
    RX FIFO.

  o Four more words are the written to the SCI TX FIFO, but no transmission
    should occur as the clock is stopped. The clock is then programmed to
    start and the four words will start to be tranmitted after the 
    SCISTARTTIME has expired. The four words are read from the trickbox 
    Rx FIFO.

  o The clock is then reprogrammed to stop.

  o Whilst the clock is stopped, the Deactivation sequence is initiated
    - the clock, if stopped, remains stopped.

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

/* Program SCIIMSC: UnMask the SCICLKSTPINTR and SCICLKACTINTR interrupts */
PSW(0x1800, SCIIMSC);

/* Program SCISTOPTIME: 0x010 */
PSW(0x010, SCISTOPTIME);

/* Program SCISTARTTIME: 0x008 */
PSW(0x008, SCISTARTTIME);




/* Program SCICR0: Stop the Clock with stopped state value of CLKDISVAL*/
PSW(0x40 | CLKDISVAL, SCICR0);

/* Program the Trickbox Transmit and Receive Watermark level to 4 words */
PSW(0x11, SCITrFiLCR);

/* Function declaration reproduced here for reference 
Poll_value = (Stop/Start cycles + 1) * ((1 + SCICLKICC) * clkmulfactor) 
smart card cycles where Stop time = 16, Start time = 8 and SCICLKICC = 0x03)
*/

Poll_value = 17 * 4 * clkmulfactor;

/* Poll for SCICLKSTPINTR assertion */
PO(0x4000, 0x4000, SCITrSR1, Poll_value, SCICLKSTOPINTR_failed);
PSR(0x4000, 0x4000, SCITrSR1, Rd_ClkStp_asserted);

PI(10);

/* Clear the SCICLKSTPINTR clock stopped interrupt*/
PSW(0x0800, SCIICR);
PI(2)

/* Check that SCICLKSTPINTR is cleared */
PSR(0x0000, 0x4000, SCITrSR1, Rd_ClkStp_deasserted);





/* Program SCICR0: Re-Start the Clock, maintaining CLKDISVAL*/
PSW(0x00 | CLKDISVAL, SCICR0);

/* Function declaration reproduced here for reference 
Poll_value = (Stop/Start cycles + 1) * ((1 + SCICLKICC) * clkmulfactor) 
smart card cycles where Stop time = 16, Start time = 8 and SCICLKICC = 0x03)
*/

Poll_value = 9 * 4 * clkmulfactor;

/* Poll for SCICLKACTINTR clock active interrupt */
PO(0x8000, 0x8000, SCITrSR1, Poll_value, SCICLKACTINTR_failed);
PSR(0x8000, 0x8000, SCITrSR1, Rd_ClkAct_asserted);

/* Clear the SCICLKACTINTR clock stopped interrupt*/
PSW(0x1000, SCIICR);
PI(2);

/* Check that SCICLKACTINTR is cleared */
PSR(0x0000, 0x8000, SCITrSR1, Rd_ClkAct_deasserted );





/* Program SCICR1: Tx Mode and Bypass */
PSW(0x24, SCICR1);

/* Enable the trickbox, tx/rx enabled, also make SCIDETECT 
   signal to '1' 
*/
PSW(0x2015,SCITrCR);
PI(Dummyclock);
 

/* Write 4 values in the SCI Tx FIFO */

for (i = 1; i <= 4; i++)
  { 
    PSW(i | i << 4, SCIDATA);
  }

Poll_value = (((SCIBAUD_value + 0x01) * SCIVALUE_value ) * 0x0C) 
             * clkmulfactor + 0x20;

/* Poll for at least 1 word to be have been transmitted from the SCI 
   to the Trickbox */
PO(0x08,0x00000008,SCITrSR0, Poll_value, SCITrRFS1 failed);
PSR(0x08, 0x00000008, SCITrSR0);

/* Program SCICR0: Stop the Clock with stopped state value of CLKDISVAL*/
PSW(0x40 | CLKDISVAL, SCICR0);

/* Re-program the Trickbox Transmit and Receive Watermark level to 4 words */
PSW(0x44, SCITrFiLCR);
PI(10);

/* Wait for the last 3 words to have been received by the Trickbox,
   check the Trickbox Rx FIFO watermark level flag 
*/
PO(0x08,0x00000008,SCITrSR0, 3 * Poll_value, SCITrRFS failed);
PSR(0x08, 0x00000008, SCITrSR0);





/* Function declaration reproduced here for reference 
   Poll_value = (Stop/Start cycles + 1) * ((1 + SCICLKICC) * 
   clkmulfactor) smart card cycles where Stop time = 16, Start time = 8 
   and SCICLKICC = 0x03)
*/

Poll_value = 17 * 4 * clkmulfactor;

/* Poll for SCICLKSTPINTR assertion */
PO(0x4000, 0x4000, SCITrSR1, Poll_value, SCICLKSTOPINTR_failed);
PSR(0x4000, 0x4000, SCITrSR1, Rd_ClkStp_asserted);

/* Clear the SCICLKSTPINTR clock stopped interrupt*/
PSW(0x0800, SCIICR);
PI(2)

/* Check that SCICLKSTPINTR is cleared */
PSR(0x0000, 0x4000, SCITrSR1, Rd_ClkStp_deasserted);


/* Read the 4 values from the Trickbox Rx FIFO */
for (i = 1; i <= 4; i++)
  { 
    PSR(i | i << 4, 0x2FF, SCITrDATA);
  }





/* Whilst the clock is stopped, write 4 more words into the SCI Tx FIFO */

for (i = 1; i <= 4; i++)
  { 
    PSW(i | i << 4, SCIDATA);
  }

/* Check the TXCOUNT value */
PSR(0x4, 0xF, SCITXCOUNT, Rd_TxCount);

Poll_value = (((SCIBAUD_value + 0x01) * SCIVALUE_value ) * 0x0C) 
             * clkmulfactor + 0x20;

/* Idle for a period corresponding to one word to have been 
   transmitted from the SCI Tx FIFO, check TXCOUNT value
   is still at 4 
*/

PI(Poll_value);

/* Re-check the TXCOUNT value -  not to have changed*/
PSR(0x4, 0xF, SCITXCOUNT, Rd_TxCount);

/* Program SCICR0: Re-Start the Clock, maintaining CLKDISVAL*/
PSW(0x00 | CLKDISVAL, SCICR0);

/* Function declaration reproduced here for reference 
   Poll_value = (Stop/Start cycles + 1) * ((1 + SCICLKICC) * clkmulfactor) 
   smart card cycles where Stop time = 16, Start time = 8 and 
   SCICLKICC = 0x03)
*/
Poll_value = 9 * 4 * clkmulfactor;






/* Poll for SCICLKACTINTR clock active interrupt */
PO(0x8000, 0x8000, SCITrSR1, Poll_value, SCICLKACTINTR_failed);

/* Clear the SCICLKACTINTR clock stopped interrupt*/
PSW(0x1000, SCIICR);
PI(2)

/* Check that SCICLKACTINTR is cleared */
PSR(0x0000, 0x8000, SCITrSR1, Rd_ClkAct_deasserted);

Poll_value = (((SCIBAUD_value + 0x01) * SCIVALUE_value ) * 0x0C) 
             * clkmulfactor + 0x20;

/* Wait 4 words to have been received by the Trickbox,
   check the Trickbox Rx FIFO watermark level flag */
PO(0x08,0x00000008,SCITrSR0, 4 * Poll_value, SCITrRFS failed);

/* Read the 4 words from the Trickbox Rx FIFO */
for (i = 1; i <= 4; i++)
  { 
    PSR(i | i << 4, 0x2FF, SCITrDATA);
  }

/* Program SCICR0: Stop the Clock with stopped state value of CLKDISVAL*/
PSW(0x40 | CLKDISVAL, SCICR0);

/* Function declaration reproduced here for reference 
   Poll_value = (Stop/Start cycles + 1) * ((1 + SCICLKICC) * 
   clkmulfactor) smart card cycles where Stop time = 16, 
   Start time = 8 and SCICLKICC = 0x03)
*/

Poll_value = 17 * 4 * clkmulfactor;

/* Poll for SCICLKSTPINTR assertion */
PO(0x4000, 0x4000, SCITrSR1, Poll_value, SCICLKSTOPINTR_failed);
PSR(0x4000, 0x4000, SCITrSR1, Rd_ClkStp_asserted);

PI(10);

/* Clear the SCICLKSTPINTR clock stopped interrupt*/
PSW(0x0800, SCIICR);
PI(2)

/* Check that SCICLKSTPINTR is cleared */
PSR(0x0000, 0x4000, SCITrSR1, Rd_ClkStp_deasserted);

/* Disable the SCIDETECT signal the Trickbox enable/receive */
PSW(0x2000,SCITrCR);
PI(Dummyclock);
 
DELAY_value = (0x05 + 0x01) * (0x03 + 0x01) * 0x02
             * clkmulfactor * 0x03 + Margin;
 
/* Waiting for the completion of the deactivation */
  DELAY_value = DELAY_value/254  + 1;
 
  for(i = DELAY_value; i > 0; i--)
  PI(254);
 
}/* End Function */
