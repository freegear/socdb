/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : Ssp_RxFIFO_critical_test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function RxFIFO_critical_test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void RxFIFO_critical_test()
{
  /* Summary : Receive FIFO boundary case test
     =========================================

  o This test performs the following boundary case check on the receive
    FIFO:
  When the FIFO pointers are both at '111' and if the FIFO is Full,
  if a read and a write occur simultaneously, the read and the write should
  both be allowed to have effect. (Normally, if there is a write to the 
  receive FIFO when it is already full, the write is ignored and the Overrun
  condition is said to be satisfied)
     The pointers are first brought to '111' by filling up 7 locations in the
  transmit FIFO. The Transmit FIFO in the trickbox is also filled with
  transmit data that would eventually get accumulated in the Receive FIFO
  of the SSP. Transmission/Reception is allowed to complete and the pointers
  are brought to '111'. Then, 8 more words are written to the Transmit FIFO.
  Midway through the transmission, one more word is written to the transmit 
  FIFO. When the last (ninth) word is about to get written to the Receive FIFO
  by the SSP receive section, a read of the SSP receive FIFO is initiated and
  the boundary condition is checked.
  */

  int32 buffer[32];
  int32 Buffer[32];
  int32 SSPTB_SCR0_VALUE  ;
  int i;
 
 C("Receive FIFO Critical Test");
 
 for(i=0;i<32;i++)
  buffer[i]=i;
 
 for(i=0;i<32;i++)
  Buffer[i]= i;

 /* Make the RdPtr and WrPtr to "000" using test reset */
 PSW(0x08,SSPTCR);
 PSW(0x00,SSPTCR);
 
 C(" TI mode PRESCALE 1,Baud 1, Wordlength 16 , RXW 2 ");
 /* Program SSP */
 ProgramReg( SSP_PRE_3 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE1 | SSP_TI | DataSize[16] , SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_3 , SSPTBPRE ,5 );/*prescalar bit numbers changed*/
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_TI |
                        DataSize[16]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_3 , SSPTB_SCLK_RATE1  );
 
 /* Read SSP Status register */
 PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,rxfct0);
 
 /* Read SSPTB Status register */
 PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,rxfctb0);
 
 /* Enable SSPTB  */
 ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);
 
 /* Write  16 data to the SSPTB  */
 for( i =0 ; i< 16; i++)
 {
  ProgramReg(Buffer[i] & Masks[WordLength], SSPTBSTDR, 1);
 }
 
 /* Read SSPTB Status register */
 PO( SSPTB_RXFE | SSPTB_TXFF , masks[8] , SSPTBSSR , 9*TimeOut ,rxfctb1);
 PSR(SSPTB_RXFE | SSPTB_TXFF ,masks[8],SSPTBSSR,rxfctb1);
 
 
 /* Write 7 data to the SSP  */
 for( i=0 ; i< 7 ; i++)
 {
  ProgramReg( buffer[i] & Masks[WordLength], SSPDR, 0 );
 }
 /* Enable SSP  */
 ProgramReg(SSP_ENABLE,SSPCR1,1);
 
 /* During transmission   */
 PO(  SSP_BSY | SSP_TNF , masks[5] , SSPSR , 3*TimeOut,rxfct3);
 PSR( SSP_BSY | SSP_TNF , masks[5],SSPSR,rxfct3);
 
 /* Check if SSP Tx FIFO is empty ,i.e. Transmission is done */
 PO( SSP_TFE | ~SSP_BSY, 0x11 , SSPSR , 9*TimeOut ,rxfctb3);
 PSR( SSP_TFE | ~SSP_BSY , 0x11 , SSPSR ,rxfctb3);

 /* Disable SSP  */
 ProgramReg(0x00,SSPCR1,1);
 
 for(i=0; i< 7 ; i++)
 {
  PSR(Buffer[i] & Masks[WordLength] ,Masks[WordLength],SSPDR,Rx_fifo_emptying);
 }

 /* Write 8 data to the SSP  */
 for( i= 7 ; i< 15  ; i++)
 {
  ProgramReg( buffer[i] & Masks[WordLength], SSPDR, 0 );
 }

 /* Enable SSP  */
 ProgramReg(SSP_ENABLE,SSPCR1,1);
 PO( SSP_TFE | ~SSP_BSY , 0x11 ,SSPSR,10*TimeOut,filling_rx_fifo);
 PSR( SSP_TFE | ~SSP_BSY , 0x11 , SSPSR ,rxfctb3);
 ProgramReg( buffer[1] & Masks[WordLength], SSPDR, 0 );

 PO( SSP_TFE | SSP_BSY , 0x11 ,SSPSR,10*TimeOut,filling_rx_fifo);
 PSR( SSP_TFE | SSP_BSY , 0x11 , SSPSR ,rxfctb3);

 /* Inserting adequate idle cycles to hit the critical condition  */
 PI(191);
 PSR(Buffer[7] & Masks[WordLength] , Masks[WordLength],SSPDR,simultaneous);

 /* Clear the RX FIFO */
 for(i=8; i<16 ; i++)
 PSR(Buffer[i] & Masks[WordLength] ,Masks[WordLength], SSPDR,rxfct4_data2);
 
 /* Clear the RX FIFO of the TB- Dummy reads */
 for(i=0; i<15 ; i++)
 PSR(buffer[i] & Masks[WordLength], Masks[WordLength], SSPTBSRDR,rxfctb4_DATA2);

 /* Read the data added to check the critical condition */ 
 PSR( buffer[1] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,rxfctb4_DATA2);

 PI(420);
 /* Disable SSPTB */
 ProgramReg(0x0 ,SSPCR1,5);
 ProgramReg(0x00 , SSPTBSCR0 ,5 );
 
 C("Receive FIFO Critical Test End");
 
}/* End Function */
