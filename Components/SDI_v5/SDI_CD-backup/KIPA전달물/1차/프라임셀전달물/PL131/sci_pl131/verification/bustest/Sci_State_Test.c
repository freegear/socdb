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
--  File Name              : Sci_State_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function State_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void State_Test()
{
  int Bypass, CLKICC_value, ExtCount_value, ActCount_value, DactCount_value;
  int AtrCount_value;
  int Poll_Card_In, Poll_Card_Out, Poll_Card_Up, Poll_Card_Down;
  int Poll_ATR_Start, Poll_DataWord, Poll_Reset_Low, Poll_Reset_High;
  int BAUD, VALUE;

  Bypass          = 0x1;
  CLKICC_value    = 0x3;
  ExtCount_value  = 0x5;
  ActCount_value  = 0x7;
  DactCount_value = 0x9;
  AtrCount_value  = 0xB;
  BAUD            = 0x4;
  VALUE           = 0xA;

  Poll_Card_In    = (ExtCount_value + 0x01) * (CLKICC_value + 0x01)
                    * clkmulfactor  + Dummyclock  + Margin;

  Poll_Card_Out   = (DactCount_value + 0x01) * 0x03 * clkmulfactor
                    * (CLKICC_value + 1) * 0x02 + 0x07  + Margin;

  Poll_Card_Down  = (DactCount_value + 0x01) * 0x03 * clkmulfactor
                    * (CLKICC_value + 1) * 0x02 + 0x07  + Margin;

  Poll_Card_Up    = (ActCount_value + 0x01) * (CLKICC_value + 0x01) 
                    * 0x02 * clkmulfactor + Margin;

  Poll_ATR_Start  = (AtrCount_value + 0x01) * (CLKICC_value + 0x01) 
                    * 0x02 * clkmulfactor + Margin;

  Poll_DataWord  =  (12 * (BAUD + 0x1) * (VALUE));

  /* Poll_value = etu_width * no_bits * SCIATIM_register_value */
  Poll_Reset_Low  = (0x02 + 0x01) * 0x08 * 0x10 * clkmulfactor + Margin;
  Poll_Reset_High = (0x02 + 0x01) * 0x08 * 0x10 * clkmulfactor + Margin;

  /* Initialisation(int BAUD_value,  int SCIVALUE_value, int ATIME_value, 
                 int DTIME_value) */

  /* Initialise the SCI Interface */
  Initialisation(0x04,0x0A,0x07,0x09);

  /* Disable SCIDETECT signal */
  PSW(0x2001, SCITrCR);

  /* Reset the SCI to bring the state machine to NOCARD state */
  /* nSCIRST = 0 */
  PSW(0x0001, SCITrCR);
  PI(4);
  /* nSCIRST = 1 */
  PSW(0x2001, SCITrCR);
  PI(4);

  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);

  /* Program the Debounce Time */
  PSW(0x05,SCISTABLE);

  /* Program the SCIBLKTIME and SCICHTIME with 0xFFFFFFFF */
  PSW(0xFFFF, SCICHTIMEMS);
  PSW(0xFFFF, SCICHTIMELS);
  PSW(0xFFFF, SCIBLKTIMEMS);
  PSW(0xFFFF, SCIBLKTIMELS);

  /* Program SCITIDE to 0x40 */
  PSW(0x40, SCITIDE);

  /* Clear the TX and RX FIFOs */
  PSW(0x00, SCITXCOUNT);
  PSW(0x00, SCIRXCOUNT);

  /***** DEBOUNCE STATE TRANSITION TEST *****/

  /* Enable SCIDETECT signal to start CARD detection.State machine should */
  /* go to WAIT_FOR_START state   */
  PSW(0x2011,SCITrCR);
  PI(Dummyclock);
 
  /* Poll SCICARDININTR */
  PO(0x1000,0x00001000,SCITrSR1,Poll_Card_In, SCICARDININTR failed);
  PSR(0x1009,0x01FFF,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);


  /* Disable SCIDETECT signal. State machine should go to Deactivation */
  /* sequence and then to NOCARD state   */
  PSW(0x2001,SCITrCR);
  PI(Dummyclock);

  /* Poll SCICARDDNINTR */
  PO(0x0200,0x0000200,SCITrSR1,Poll_Card_Down, SCICARDDNINTR failed);
  PSR(0x0A09,0x00001FFF,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);

  /* Enable SCIDETECT. when the state machine goes to DEBOUNCE state issue */
  /* SCDEACREQ signal, state machine should go to NOCARD state             */
  PSW(0x2011,SCITrCR);
  PI(4 );
  PSW(0x2811,SCITrCR);
  PI(4);

  /* Idle for Poll_Card_In period, check that it SCICARDININTR not asserted */
  PI(Poll_Card_In);
  /* Poll SCICARDININTR not asserted */
  PO(0x0000,0x00001000,SCITrSR1,Poll_Card_In, SCICARDININTR failed);
  PSR(0x0009,0x01FFF,SCITrSR1);


  /***** WAIT_FOR_STARTUP STATE TRANSITION TEST *****/

  /* Enable SCIDETECT, when the state machine goes to Activation state issue */
  /* SCIDEACREQ, the state machine should go to the DEACT_SEQ state         */
  PSW(0x2011,SCITrCR);
  PI(Dummyclock);
  /* Poll SCICARDININTR */
  PO(0x1000,0x00001000,SCITrSR1,Poll_Card_In, SCICARDININTR failed);
  PSR(0x1009,0x01FFF,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);
  /* Issue SCIDEACREQ  */
  PSW(0x2811,SCITrCR);
  PI(4);
  /* Poll for the SCICARDDNINTR */ 
  PO(0x0200,0x00000200,SCITrSR1,Poll_Card_Down,SCICARDDNINTR_failed);
  PSR(0x0200,0x00000200,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);

  /* Enable SCIDETECT (remove SCIDEACREQ), when the state machine */ 
  /* goes to Activation state, set FINISH bit to 1, state machine */
  /* should go to DEACT_SEQ state                                 */
  PSW(0x2011,SCITrCR);
  PI(4);
  /* Enable the Warm reset */
  PSW(0x04,SCICR2);
  PI(10);
  /* Initiate the deactivation sequence by writing  '1' to the finish bit */ 
  PSW(0x02,SCICR2);
  /* Poll for the SCICARDDNINTR */ 
  PO(0x0200,0x00000200,SCITrSR1,Poll_Card_Down,SCICARDDNINTR_failed);
  PSR(0x0200,0x00000200,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);

  /* Enable SCIDETECT,when the state machine goes to WAIT_FOR_START state, */
  /* Set STARTUP bit.State machine should go to TX_RX state              */
  PSW(0x2011,SCITrCR);
  PI(4);
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);

  /* ***********************************************************************/
  /* ******************* TX_RX STATE TRANSITION TEST ***********************/
  /* ***********************************************************************/

  /* Set FINISH bit. State machine should go to DEACT_SEQ state */

  PSW(0x02, SCICR2);
  /* Poll for the SCICARDDNINTR */ 
  PO(0x0200,0x00000200,SCITrSR1,Poll_Card_Down,SCICARDDNINTR_failed);
  PSR(0x0200,0x00000200,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);

  /* Set STARTUP BIT.when the state machine goes to TX_RX state issue */
  /* DEACREQ State machine should go to DEACT_SEQ state              */

  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all interrupts */
  PSW(0x1FFF,SCIICR);
  /* Set SCIDEACREQ, SCIDETECT */
  PSW(0x2811,SCITrCR);
  PI(4);
  /* Poll for the SCICARDDNINTR */ 
  PO(0x0200,0x00000200,SCITrSR1,Poll_Card_Down,SCICARDDNINTR_failed);
  PSR(0x0200,0x00000200,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);

  /* When the State machine is in TX_RX state disable SCIDETECT */
  /* State machine should go to DEACT_SEQ state              */

  PSW(0x2011,SCITrCR);
  PI(12);
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);
  /* Disable SCIDETECT signal. State machine should go to Deactivation */
  /* sequence and then to NOCARD state   */
  PSW(0x2001,SCITrCR);
  PI(Dummyclock);
  /* Wait untilthe state machine moves  to NOCARD state */
  /* Poll SCICARDDNINTR */
  PO(0x0200,0x0000200,SCITrSR1,Poll_Card_Down, SCICARDDNINTR failed);
  PSR(0x0A09,0x00001FFF,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);

  /* Enable SCIDETECT signal.when the state machine moves to TX_RX state set */
  /* WRESET bit to 1 .The state machine should move WARM_RESET state and     */
  /* then back to TX_RX state                                                */

  PSW(0x2011,SCITrCR);
  PI(12);
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);

  /* Enable the Warm reset */
  PSW(0x04,SCICR2);
  PI(12);
 
  /* Wait for ATR START TIME OUT, State machine should move to   */
  /* DEACT_SEQ state                                             */

  /* Poll SCIATRSTOUTINTR */
  PO(0x0080,0x00000080,SCITrSR1, Poll_ATR_Start, SCIATRSTOUTINTR failed);
  PSR(0x0081,0x00000081,SCITrSR1);    
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);
  /* Poll SCICARDDNINTR */
  PO(0x0200,0x0000200,SCITrSR1,Poll_Card_Down, SCICARDDNINTR failed);
  PSR(0x0209,0x00001FFF,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);

  /* Issue a STARTBIT by writing data to the SCIDATAIN bit of SCITISR */
  /* register. State machine should go to RX_DATA state               */ 
  /* Disable the Trickbox */
  /* Program the BAUD and VALUE registers */
  PSW(0x4, SCITrBAUD);
  PSW(0xA, SCITrVALUE);
  /* Issue a STARTBIT by writing data to the Trickbox data register */
  PSW(0xFF, SCITrDATA);
  /* Enable the Trickbox transmit logic */
  PSW(0x2013, SCITrCR);

  /* Wait till the current character receiption over.State machine should */
  /* return to TX_RX state                                                */
  /* Poll SCI RX FIFO not empty status */
  PO(0x0,0x8,SCIFIFOSTATUS, Poll_DataWord, RXFIFOEmpty failed);
  PSR(0x0,0x8,SCIFIFOSTATUS);    

  /* Issue STARTBIT less than 1 ETU ,State machine should go to          */
  /* CHK_FOR_START state and then back to TX_RX state after 1 ETU        */
  /* Disable the Trickbox prior to programming the Trickbox ETU to be    */
  /* less than that of the SCI interface ETU. An 0xFF dataword will be   */
  /* loaded into the trickbox Tx FIFO to ensure that the start bit is    */
  /* not recognised as being the correct width when received.            */
  /* The trickbox/transmit logic is enabled to allow the transmission    */
  /* reception to take place.                                            */

  /* Disable the Trickbox */
  PSW(0x2010, SCITrCR);

  /* Re-program the Trickbox Value to provide an ETU less than half */
  /* that of the SCI ETU.                                                */
  PSW(0x5,SCITrVALUE);
  /* Write 0xFF to the Trickbox Tx FIFO */
  PSW(0xFF, SCITrDATA);
  /* Enable the Trickbox/transmit logic */
  PSW(0x2013, SCITrCR);
  /* Wait till the current character reception over.State machine should  */
  /* return to TX_RX state                                                */
  PI(0xFF);
  PI(0x60);

  /* Disable the Trickbox */
  PSW(0x2010, SCITrCR);
  /* Re-program the Trickbox BAUD Value to the same as that of the SCI   */
  PSW(0x0A,SCITrVALUE);

  /* Set SELDATA to 1 to enable SYNC mode .State machine should stick to */
  /* TX_RX state even if TXMODE is enabled or RX mode is enabled or      */
  /* WRESET is enabled                                                   */
  PSW(0x04, SCISYNCTX);
  PSW(0x60, SCICR1);
  PI(12);

  /* Enable TXMODE */
  PSW(0x64, SCICR1);
  PSW(0x00, SCISYNCTX);
  PSW(0x11, SCIDATA);
  PI(12);

  /* State machine should be in TXRX state itself */
  /* Enable RXMODE and receive a start bit */
  PSW(0x00, SCITXCOUNT);
  PSW(0x04, SCISYNCTX);
  PSW(0x60, SCICR1);
  PI(6);
   
  PSW(0xFF, SCITrDATA);
  /* Enable the Trickbox/transmit logic */
  PSW(0x2013, SCITrCR);
  PI(132);
  
  /* State machine should be in TXRX state itself */
  /* Set WRESET bit */
  PSW(0x4, SCICR2);
  PI(6);
  
  /* State machine should be in TXRX state itself */
  /* Disable sync mode */
  PSW(0x20, SCICR1);
   
  /* Read value from the SCI RX FIFO to clear the RXTIDE interrupt */
  PSR(0xFF, 0xFF, SCIDATA);

  /* ***********************************************************************/
  /* ******************** WARM_RESET STATE TRANSITION TEST *****************/
  /* ***********************************************************************/

  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);

  /* Set WRESET bit to 1 .to start Warm reset sequence */
  PSW(0x4, SCICR2);
  PI(6);
  
  /* Disable SCIDETECT .state machine should go to Deactivation sequence */

  PSW(0x2001,SCITrCR);
  PI(6);
  /* Wait untilthe state machine moves  to NOCARD state */
  /* Poll SCICARDDNINTR */
  PO(0x0200,0x0000200,SCITrSR1, Poll_Card_Down, SCICARDDNINTR failed);
  PSR(0x0A09,0x00001FFF,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);

  /* Set SCIDETECT high again */
  PSW(0x2011,SCITrCR);
  /* Poll SCICARDININTR */
  PO(0x1000,0x00001000,SCITrSR1,Poll_Card_In, SCICARDININTR failed);
  PSR(0x1009,0x01FFF,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);

  /* Set STARTUP bit to 1 to start the Activation sequence */
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);

  /*When state changes to WRESET state issue DEACREQ  */
  /* State machine should go to DEACTIVATE state */
  /* Enable the Warm reset */
  PSW(0x04,SCICR2);
  PI(8);
  
  /* Set SCIDEACREQ high */
  PSW(0x2811,SCITrCR);
  PI(42);
  /* Set SCIDEACREQ low */
  PSW(0x2011,SCITrCR);
  /* Poll for the SCICARDDNINTR */ 
  PO(0x0200,0x00000200,SCITrSR1,Poll_Card_Down,SCICARDDNINTR_failed);
  PSR(0x0200,0x00000200,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);
  
  /* Set STARTUP bit to 1 to start the Activation sequence */
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all interrupts */
  PSW(0x1FFF,SCIICR);
  
  /* Set FINISH bit to 1 ,when state changes to WRESET state */
  /* State machine should go to Deactivation sequence        */
  /* Enable the Warm reset */
  PSW(0x04,SCICR2);
  PI(8);
  /* Initiate the deactivation sequence by writing  '1' to the finish bit */ 
  PSW(0x02,SCICR2);
  /* Poll for the SCICARDDNINTR */ 
  PO(0x0200,0x00000200,SCITrSR1,Poll_Card_Down,SCICARDDNINTR_failed);
  PSR(0x0200,0x00000200,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);
  /* Enable the Warm reset */
  PSW(0x04,SCICR2);
  PI(8);
  
  /* Enable Synchronous mode, the state will change to TX_RX */
  PSW(0x04, SCISYNCTX);
  PSW(0x60, SCICR1);
  PI(12);

  /* Set WRESET bit to 1 ,when state machine goes to WARM RESET state write */
  /* some data to SCISYNCACT register.State machine should go to            */
  /* WAIT_FOR_START state                                                   */
  /* Disable Synchronous mode */
  PSW(0x20, SCICR1);
  PI(6);
  /* Enable the Warm reset */
  PSW(0x04,SCICR2);
  PI(8);
  /* Write to the SCISYNCACT register */
  PSW(0x01, SCISYNCACT);
  PI(6);
 
  /* Set STARTUP bit to 1 */
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1, Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);
  
  /* Receive a Start bit and check if Statemachine goes to RXDATA state */
  /* Disable the Trickbox */
  PSW(0x2010, SCITrCR);
  /* Write 0xFF to the Trickbox Tx FIFO */
  PSW(0xFF, SCITrDATA);
  /* Enable the Trickbox/transmit logic */
  PSW(0x2013, SCITrCR);
  PI(50);

  /* Disable SCIDETECT signal. State machine should go to Deactivation */
  /* sequence and then to NOCARD state   */
  PSW(0x2001,SCITrCR);
  PI(6);
  /* Wait until the state machine moves to NOCARD state */
  /* Poll SCICARDDNINTR */
  PO(0x0200,0x0000200,SCITrSR1,Poll_Card_Down, SCICARDDNINTR failed);
  PSR(0x0A09,0x00001FFF,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);
  /* Enable SCIDTECT signal */
  PSW(0x2011,SCITrCR);
  PI(12);
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);
  /* Receive a Start bit and check if Statemachine goes to RXDATA state */
  /* Disable the Trickbox */
  PSW(0x2010, SCITrCR);
  /* Write 0xFF to the Trickbox Tx FIFO */
  PSW(0xFF, SCITrDATA);
  /* Enable the Trickbox/transmit logic */
  PSW(0x2013, SCITrCR);
  PI(50);

  /* Set FINISH bit to 1. State machine should go to Deactivation state */
  /* Initiate the deactivation sequence by writing  '1' to the finish bit */ 
  PSW(0x02,SCICR2);
  /* Poll for the SCICARDDNINTR */ 
  PO(0x0200,0x00000200,SCITrSR1,Poll_Card_Down,SCICARDDNINTR_failed);
  PSR(0x0200,0x00000200,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);
  /* Enable SCIDTECT signal */
  PSW(0x2011,SCITrCR);
  PI(12);
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
   
  /* Wait till state machine goes to RX state */
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);
  /* Receive a Start bit and check if Statemachine goes to RXDATA state */
  /* Disable the Trickbox */
  PSW(0x2010, SCITrCR);
  /* Write 0xFF to the Trickbox Tx FIFO */
  PSW(0xFF, SCITrDATA);
  /* Enable the Trickbox/transmit logic */
  PSW(0x2013, SCITrCR);
  PI(50);

  /* Issue DEACREQ - State machine should go to Deactivation state */
  PSW(0x2811,SCITrCR);
  PI(4);
  /* Poll for the SCICARDDNINTR */ 
  PO(0x0200,0x00000200,SCITrSR1,Poll_Card_Down,SCICARDDNINTR_failed);
  PSR(0x0200,0x00000200,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);
  /* Deassert SCIDEACREQ */
  PSW(0x2011,SCITrCR);
  PI(4);
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);
  /* Receive a Start bit and check if Statemachine goes to RXDATA state */
  /* Disable the Trickbox */
  PSW(0x2010, SCITrCR);
  /* Write 0xFF to the Trickbox Tx FIFO */
  PSW(0xFF, SCITrDATA);
  /* Enable the Trickbox/transmit logic */
  PSW(0x2013, SCITrCR);
  PI(50);

  /* Write some data in to SCISYNCACT register,State machine should go to */
  /* WAIT_FOR_START state */
  PSW(0x01, SCISYNCACT);
  PI(12);
  
  /* Enable Activation sequence and wait till state machine goes to RX state*/
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);
  /* Receive a Start bit and check if Statemachine goes to RXDATA state */
  /* Disable the Trickbox */
  PSW(0x2010, SCITrCR);
  /* Write 0xFF to the Trickbox Tx FIFO */
  PSW(0xFF, SCITrDATA);
  /* Enable the Trickbox/transmit logic */
  PSW(0x2013, SCITrCR);
  PI(50);
  
  /* Enable SYNC MODE. State machine should go to TX_RX state */
  PSW(0x04, SCISYNCTX);
  PSW(0x60, SCICR1);
  PI(12);

  /* DISABLE SYNC MODE */
  PSW(0x20, SCICR1);
  PI(4);

  /* Enable TX mode. State machine should go to WAIT_FOR_DAVL state */
  PSW(0x24, SCICR1);
  PI(30);

  /* Disable SCIDETECT. State machine should go to Deactivation state */
  PSW(0x2001,SCITrCR);
  PI(9);
  /* Wait untilthe state machine moves  to NOCARD state */
  /* Poll SCICARDDNINTR */
  PO(0x0200,0x0000200,SCITrSR1,Poll_Card_Down, SCICARDDNINTR failed);
  PSR(0x0A09,0x00001FFF,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);

  /* Enable SCIDETECT and wait till state machine goes to WAIT_FOR_DAVL stat*/
  PSW(0x2011,SCITrCR);
  /* Poll SCICARDININTR */
  PO(0x1000,0x00001000,SCITrSR1,Poll_Card_In, SCICARDININTR failed);
  PSR(0x1009,0x01FFF,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);
  PI(30);

  /* Set FINISH bit to 1. State machine should go to Deactivation state */
  /* Initiate the deactivation sequence by writing  '1' to the finish bit */ 
  PSW(0x02,SCICR2);
  /* Poll for the SCICARDDNINTR */ 
  PO(0x0200,0x00000200,SCITrSR1,Poll_Card_Down,SCICARDDNINTR_failed);
  PSR(0x0200,0x00000200,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);
  /* Enable SCIDTECT signal */
  PSW(0x2011,SCITrCR);
  PI(12);
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);  
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);
  PI(30);

  /* Issue DEACREQ - State machine should go to Deactivation state */
  PSW(0x2811,SCITrCR);
  PI(4);
  /* Poll for the SCICARDDNINTR */ 
  PO(0x0200,0x00000200,SCITrSR1,Poll_Card_Down,SCICARDDNINTR_failed);
  PSR(0x0200,0x00000200,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);
  /* Deassert SCIDEACREQ */
  PSW(0x2011,SCITrCR);
  PI(4);
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);
  PI(30);

  /* Change mode to RECEIVE MODE. State machine should go to TX_RX state */
  PSW(0x20, SCICR1);
  PI(9);

  /* Enable TX mode */
  PSW(0x24, SCICR1);
  PI(30);

  /* Set WRESET bit to 1, State machine should go to WARM RESET state */
  PSW(0x04,SCICR2);
  PI(30); 
 
  /* Write some data to the SCISYNC, State machine should go to TX_RX state */
  PSW(0x64, SCICR1);
  PI(30);

  /* Disable sync mode */
  PSW(0x24, SCICR1);
  PI(30);


  /* Write some data to the SCISYNACT register,State machine should */
  /* go to WAIT_FOR START state */
  PSW(0x02, SCISYNCACT);
  PI(9);

  /* Enable Activation sequence and wait till state machine goes to */
  /* WAIT_FOR_DAVL state */
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all interrupts */
  PSW(0x1FFF,SCIICR);
  PI(60);

  /* Write some data to the TXFIFO, State machine should go to TXDATA state */
  PSW(0x08, SCIDATA);
  PI(60);

  /* Set WRESET bit to 1, State machine should go to WARM RESET state */
  PSW(0x04,SCICR2);
  PI(160); 

  /* Disable SCIDETECT signal. State machine should go to Deactivation */
  /* sequence and then to NOCARD state   */
  PSW(0x2001,SCITrCR);
  PI(6);
  /* Wait untilthe state machine moves  to NOCARD state */
  /* Poll SCICARDDNINTR */
  PO(0x0200,0x0000200,SCITrSR1,Poll_Card_Down, SCICARDDNINTR failed);
  PSR(0x0A81,0x00001FFF,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);
  /* Enable SCIDETECT signal */
  PSW(0x2011,SCITrCR);
  PI(12);
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);
  PI(60);

  /* Set FINISH bit to 1. State machine should go to Deactivation state */
  /* Initiate the deactivation sequence by writing  '1' to the finish bit */ 
  PSW(0x02,SCICR2);
  /* Poll for the SCICARDDNINTR */ 
  PO(0x0200,0x00000200,SCITrSR1,Poll_Card_Down,SCICARDDNINTR_failed);
  PSR(0x0200,0x00000200,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);
  /* Enable SCIDTECT signal */
  PSW(0x2011,SCITrCR);
  PI(12);
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);  
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);
  PI(60);

  /* Issue DEACREQ - State machine should go to Deactivation state */
  PSW(0x2811,SCITrCR);
  PI(4);
  /* Poll for the SCICARDDNINTR */ 
  PO(0x0200,0x00000200,SCITrSR1,Poll_Card_Down,SCICARDDNINTR_failed);
  PSR(0x0200,0x00000200,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);
  /* Deassert SCIDEACREQ */
  PSW(0x2011,SCITrCR);
  PI(4);
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);
  PI(60);

  /* Set mode bit to 0,State machine should go to TX_RX state after 12 ETU */
  PSW(0x20, SCICR1);
  PI(200);
  PI(200);
  PI(200);
  PI(50);

  /* Load Block guard time register with some value and enable BLKGUARD */
  PSW(0x02, SCIBLKGUARD);
  PSW(0x30, SCICR1);

  /* Receive one character */
  PSW(0x2010, SCITrCR);
  /* Write 0xFF to the Trickbox Tx FIFO */
  PSW(0xFF, SCITrDATA);
  /* Enable the Trickbox/transmit logic */
  PSW(0x2013, SCITrCR);
  /* Poll SCI RX FIFO not empty status */
  PO(0x0,0x8,SCIFIFOSTATUS, Poll_DataWord, RXFIFOEmpty failed);
  PSR(0x0,0x8,SCIFIFOSTATUS);    

  /* Read the value from the RX FIFO */
  PSR(0x0FF, 0x1FF, SCIDATA);
 
  /* Enable TXMODE and write a character in to TXFIFO */
  PSW(0x34, SCICR1);
  PSW(0x00, SCITXCOUNT);
  PSW(0x04, SCIDATA);
  PI(60);

  /* Set WRESET bit to 1, State machine should go to WARM RESET state */
  PSW(0x04,SCICR2);
  PI(120); 

  /* Disable SCIDETECT signal. State machine should go to Deactivation */
  /* sequence and then to NOCARD state   */
  PSW(0x2001,SCITrCR);
  PI(Dummyclock);
  /* Wait untilthe state machine moves  to NOCARD state */
  /* Poll SCICARDDNINTR */
  PO(0x0200,0x0000200,SCITrSR1,Poll_Card_Down, SCICARDDNINTR failed);
  PSR(0x0A81,0x00001FFF,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);
  /* Enable SCIDTECT signal */
  PSW(0x2011,SCITrCR);
  PI(12);
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);

  /* Set FINISH bit to 1. State machine should go to Deactivation state */
  /* Initiate the deactivation sequence by writing  '1' to the finish bit */ 
  PSW(0x02,SCICR2);
  /* Poll for the SCICARDDNINTR */ 
  PO(0x0200,0x00000200,SCITrSR1,Poll_Card_Down,SCICARDDNINTR_failed);
  PSR(0x0200,0x00000200,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);
  /* Enable SCIDTECT signal */
  PSW(0x2011,SCITrCR);
  PI(12);
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);  
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);
  PI(60);

  /* Issue DEACREQ - State machine should go to Deactivation state */
  PSW(0x2811,SCITrCR);
  PI(4);
  /* Poll for the SCICARDDNINTR */ 
  PO(0x0200,0x00000200,SCITrSR1,Poll_Card_Down,SCICARDDNINTR_failed);
  PSR(0x0200,0x00000200,SCITrSR1);
  /* Clear all interrupts */
  PSW(0x1FFF, SCIICR);
  /* Deassert SCIDEACREQ */
  PSW(0x2011,SCITrCR);
  PI(4);
  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);
  PI(60);

  /* Write some data to the SCISYNC, State machine should go to TX_RX state */
  PSW(0x64, SCICR1);
  PI(60);

  /* Disable Synchroous mode */
  PSW(0x24, SCICR1);
  PI(60);

  /* Write some data to the SCISYNACT register,State machine should */
  /* go to WAIT_FOR START state */
  PSW(0x02, SCISYNCACT);
  PI(60);

  /* Initiate the activation sequence by writing  '1' to the Start bit */ 
  PSW(0x01,SCICR2);
  /* Poll SCICARDUPINTR */ 
  PO(0x0400,0x00000400,SCITrSR1,Poll_Card_Up, SCICARDUPINTR failed);
  PSR(0x0401,0x00000401,SCITrSR1);    
  /* Clear all inputs */
  PSW(0x1FFF,SCIICR);
  PI(60);

  /* Change mode to RX, State machine should not go to RXmode immediately */
  /* wait till the block guard over */
  PI(120);
  
}
