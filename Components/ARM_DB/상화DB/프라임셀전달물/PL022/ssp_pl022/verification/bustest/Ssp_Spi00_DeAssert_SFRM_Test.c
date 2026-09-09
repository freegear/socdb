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
--  File Name              : Ssp_Spi00_DeAssert_SFRM_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Spi00_DeAssert_SFRM_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Spi00_DeAssert_SFRM_Test()
{

  /*
  Summary: SFRM deactivation test for Slave in SPI00 mode
  =======================================================
  This test verifies that the SSP discards a frame in the SPI mode if SFRMIN is
  negated midway through a frame. Both the data being transmitted and the data 
  being received are expected to be discarded.

  One data word is written to the SSP and the Trickbox. The SSP is programmed
  for a data length of 10 bits and the Trickbox is programmed for a data length
  of 4 bits. When data transfer is allowed to occur, the Trickbox transmits
  and receives one full frame of 4 bits length. The SSP Slave is expected to
  abort the frame after the 4-th bit since the Trickbox negates SFRMIN after
  4 bits.
  */

  int32 buffer[32];
  int i ;
 
 C("spi00 DeAssert SFRAME Test for Slave");
 
 
 /* Program the SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE5 | SSP_SPI00 | DataSize[10] , SSPCR0,32);
 ProgramReg(SSP_MS , SSPCR1 ,5 );
 
 /* Program the SSPTB */
 ProgramReg(PRE_1, SSPTBPRE, 5 );
 ProgramReg(SSPTB_SPI00 | SSPTB_MS,  SSPTBSCR1, 5);
 
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE5 | SSPTB_SPI
                        | DataSize[4]) ;
 WordLength = DataSize[4] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE5);
 
  for(i=0;i<32; i++)
        buffer[i] = 0x5555;
 
 /* Read SSP Status register */
        PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,SPI_d_0);
 
 /* Enable SSP  */
    ProgramReg(SSP_ENABLE | SSP_MS,SSPCR1,5);
 
 /* Write 1 word to the SSP  */
 for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] , SSPDR, 1 );
  }
 
 /* Read SSP Status register */
     PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut ,SPI_d_1);
     PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,SPI_d_1);
 
 /* Write data to the SSPTB  */
 for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] , SSPTBSTDR, 5 );
  }
 
 /* Enable SSPTB  */
    ProgramReg(ssptb_enable_value ,SSPTBSCR0,10);
 
 /* During 1st word transmission   */
   PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut,SPI_d_2);
   PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,SPI_d_2);
   PO(SSPTB_RXFE | SSPTB_BSY | SSPTB_TXFE,masks[9],SSPTBSSR, TimeOut,TI_N_11);
   PSR(SSPTB_RXFE | SSPTB_BSY | SSPTB_TXFE,masks[9],SSPTBSSR,TI_N_11);
 
 /* Wait until transmission is over and SSP flags are set */
   PO(SSP_TNF | SSP_TFE, masks[5], SSPSR, TimeOut ,SPI_d_4);
   PSR(SSP_TNF | SSP_TFE, masks[5], SSPSR,SPI_d_4);
   PO(SSPTB_TXFE ,masks[9],SSPTBSSR, TimeOut,TI_N_12);
   PSR(SSPTB_TXFE ,masks[9],SSPTBSSR, TI_N_12);

   Idle (10 * PRE_1 *(SSPTB_SCLK_RATE5/256 + 1)* SSPCLK_PERIOD / PCLK_PERIOD );
 
 /* Read 1 word from Trickbox */
  for(i=0; i< 1 ; i++)
  {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,SPI_d_DATA4);
  }
 
 /* Disable SSP and SSPTB */
    ProgramReg(0x00 , SSPTBSCR0 ,5 );
    ProgramReg(0x00 , SSPTBSCR1 ,5 );
    ProgramReg(0x0 ,SSPCR1,5);

 C("spi00 DeAssert SFRAME Test for Slave over");

}/* End Function */
