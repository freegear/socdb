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
--  File Name              : Ssp_Ti_DeAssert_SFRM_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Ti_DeAssert_SFRM_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Ti_DeAssert_SFRM_Test()
{

  /*
  Summary: SFRM deactivation test for Slave in TI mode
  ====================================================
  This test verifies that the SSP discards a frame in the TI mode if SFRMIN is
  sampled high on an SCLK falling edge midway through a frame. Both the data
  being transmitted and the data being received are discarded.

  Two data words are written to the Transmit FIFOs of the SSP and the Trickbox.
  The SSP is programmed for a data size of 10 bits whereas the Trickbox is
  programmed for a data length of 4 bits. When data transfer is allowed to take
  place, the Trickbox transmits and receives two full frames of 4 bits each.
  The SSP slave, on the other hand, is expected to abort the first frame since 
  it is shorter than the programmed data length of 10 bits. The second frame
  is expected to be received in full, with 4 bits from the data transmitted
  by the Trickbox and the remaining 6 bits as the default value driven on the
  SSPRXD line by the Trickbox.
  */

  int buffer[32];
  int i ;
 
 C("TI DeAssert SFRAME Test for Slave");
 
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE5 | SSP_TI | DataSize[10] , SSPCR0,32);
 ProgramReg(SSP_MS,SSPCR1,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1, SSPTBPRE, 5 );
 ProgramReg(SSPTB_MS , SSPTBSCR1, 5);
 ProgramReg(SSPTB_TI,SSPTBSCR0,5);
 ProgramReg(0x500,SSPTBCR2,5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE5 | SSPTB_TI
                        | DataSize[4]) ;
 WordLength = DataSize[4] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE5);

 buffer[0] = 0x1111;
 
 for(i=1;i<32;i++)
        buffer[i] = 0x5555;
 
 /* Read SSP Status register */
        PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,TI_N_0);
 
 /* Write two words to SSP  */
 for(i=0; i< 2 ; i++)
  {
    ProgramReg(buffer[i] , SSPDR, 1 );
  }
 
 /* Read SSP Status register */
     PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut ,TI_N_1);
     PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,TI_N_1);
 
 /* Write data to SSPTB  */
 for(i=0; i< 2; i++)
  {
    ProgramReg(buffer[i] , SSPTBSTDR, 5 );
  }

 /* Enable SSP  */
    ProgramReg(SSP_ENABLE | SSP_MS ,SSPCR1,5);
 
 /* Enable SSPTB  */
    ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);
 
 /* During 1st word transmission  */
   PO(SSPTB_RXFE | SSPTB_BSY ,masks[9],SSPTBSSR, TimeOut,TI_N_11);
   PSR(SSPTB_RXFE | SSPTB_BSY ,masks[9],SSPTBSSR,TI_N_11);
   PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut,TI_N_2);
   PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,TI_N_2);
 
 /* Wait until transmission is over and SSP flags are set */
   PO(SSPTB_TXFE | SSPTB_RXWFLG,masks[9],SSPTBSSR, TimeOut,TI_N_12);
   PSR(SSPTB_TXFE | SSPTB_RXWFLG,masks[9],SSPTBSSR, TI_N_12);
   PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, TimeOut ,TI_N_4);
   PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,TI_N_4);

 /* At this point the first frame of data is expected to be aborted
    by the SSP and the second frame is expected to be received. */
    
 /* Read 2 words from the Trickbox */
    PSR(0x0004,Masks[WordLength],SSPTBSRDR,TI_N_DATA5);
   for(i=1; i< 2 ; i++)
   {
    PSR(buffer[i] & Masks[WordLength],Masks[WordLength],SSPTBSRDR,TI_N_DATA5);
  }

 /* Read 1 word from the SSP */
   for(i=1; i< 2 ; i++)
   {
    PSR(0x017f,0xffff,SSPDR,TI_N_data5);
  }

 /* Read SSP Status to verify that the SSP receive FIFO is empty */
   PSR( SSP_TNF | SSP_TFE, masks[5], SSPSR,TI_N_4);
 
 /* Disable SSP and SSPTB */
   ProgramReg(0x00 , SSPTBSCR0 ,5 );
   ProgramReg(0x00 , SSPTBSCR1 ,5 );
   ProgramReg(0x00 ,SSPCR1,7);
   ProgramReg(0x000,SSPTBCR2,5);
 
 C("TI DeAssert SFRAME Test for Slave over");
 
}/* End Function */
