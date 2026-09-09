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
--  File Name              : Ssp_ModeChangeTests.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function ModeChange_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Mode_Change_Tests()
{

  int32 buffer[32];
  int i;
 
 C("Mode Change Tests Baud 1, Wordlength 8, RXW_4");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE1 | SSP_TI | DataSize[8] , SSPCR0,32);
 ssp_enable_value_scr1 = (SSP_ENABLE) ;
 /* Mask ALL interrupts */
 ProgramReg(SSP_IMCLR, SSPIMSC, 5);

 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 RXW_Value = (SSPTB_RXW_4);
 ProgramReg( RXW_Value  , SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_TI | 
                        DataSize[8]) ;
 WordLength = DataSize[8] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE1 );



 C(" TI Format Single Word Tx/Rx");

 for(i=0; i<32 ; i++)
   buffer[i] =  0x5555;
 
 /* Read SSP Status register */
        PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,spi_5I_0);
 
 /* Read SSPTB Status register */
        PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_5I_tb0);

 /* Enable SSPTB  */
  PSW(ssptb_enable_value ,SSPTBSCR0,SSPTBSCR0);
 
 /*  Write single data word to the SSPTB  */
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 0 );
  } 

 /* Write single data to the SSP  */
 
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 0 );
  }

 /* Read SSP Status register */
     PO(  SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut,spi_5I_1);
     PSR( SSP_BSY | SSP_TNF , masks[5] , SSPSR ,spi_5I_1);
  
 /* Enable SSP  */
    ProgramReg(ssp_enable_value_scr1,SSPCR1,3);

 /* During 1st word transmission   */
  PO(  SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_2);
  PSR( SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_2);
 
 /* Read SSPTB Status register */
   PO(SSPTB_BSY  | SSPTB_RXFE ,masks[8],SSPTBSSR, 3*TimeOut,spi_5I_tb2);
   PSR(SSPTB_BSY | SSPTB_RXFE ,masks[8],SSPTBSSR, spi_5I_tb2);

 /* After one word transmission  over  */
  PO( SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_3);
  PSR(SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_3);
 
 /* Read and compare the single data words  */
 for(i=0; i< 1 ; i++)
 {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,data_spi_5I_7);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_5I_7); 
 }

 /* Disable the Trickbox */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );


 C(" NMw Format Single Word Tx/Rx");

  ProgramReg(SSP_SCLK_RATE1 | SSP_MICROWIRE | DataSize[8] , SSPCR0,32);

  ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_MICROWIRE | 
                        DataSize[8]) ;
  PSW(ssptb_enable_value ,SSPTBSCR0,SSPTBSCR0);

 /* Read SSP Status register */
        PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,spi_5I_0);
 
 /* Read SSPTB Status register */
        PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_5I_tb0);

 /*  Write single data word to the SSPTB  */
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 0 );
  } 

 /* Write single data to the SSP  */
 
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 0 );
  }

 /* During 1st word transmission   */
  PO(  SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_2);
  PSR( SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_2);
 
 /* Read SSPTB Status register */
   PO(SSPTB_BSY  | SSPTB_RXFE ,masks[8],SSPTBSSR, 3*TimeOut,spi_5I_tb2);
   PSR(SSPTB_BSY | SSPTB_RXFE ,masks[8],SSPTBSSR, spi_5I_tb2);

 /* After one word transmission  over  */
  PO( SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_3);
  PSR(SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_3);
 
 /* Read and compare the single data words  */
 for(i=0; i< 1 ; i++)
 {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,data_spi_5I_7);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_5I_7); 
 }

 /* Disable the Trickbox */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );



 C(" TI  Format Single Word Tx/Rx");

  ProgramReg(SSP_SCLK_RATE1 | SSP_TI | DataSize[8] , SSPCR0,32);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_TI | 
                        DataSize[8]) ;
 PSW(ssptb_enable_value ,SSPTBSCR0,SSPTBSCR0);

 /* Read SSP Status register */
        PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,spi_5I_0);
 
 /* Read SSPTB Status register */
        PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_5I_tb0);

 /*  Write single data word to the SSPTB  */
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 0 );
  } 

 /* Write single data to the SSP  */
 
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 0 );
  }

 /* During 1st word transmission   */
  PO(  SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_2);
  PSR( SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_2);
 
 /* Read SSPTB Status register */
   PO(SSPTB_BSY  | SSPTB_RXFE ,masks[8],SSPTBSSR, 3*TimeOut,spi_5I_tb2);
   PSR(SSPTB_BSY | SSPTB_RXFE ,masks[8],SSPTBSSR, spi_5I_tb2);

 /* After one word transmission  over  */
  PO( SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_3);
  PSR(SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_3);
 
 /* Read and compare the single data words  */
 for(i=0; i< 1 ; i++)
 {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,data_spi_5I_7);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_5I_7); 
 }

 /* Disable the Trickbox */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );



 C(" Motorola SPI00 Format Single Word Tx/Rx");

  ProgramReg(SSP_SCLK_RATE1 | SSP_SPI00 | DataSize[8] , SSPCR0,32);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_SPI00 | 
                        DataSize[8]) ;
 PSW(ssptb_enable_value ,SSPTBSCR0,SSPTBSCR0);

 /* Read SSP Status register */
        PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,spi_5I_0);
 
 /* Read SSPTB Status register */
        PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_5I_tb0);

 /*  Write single data word to the SSPTB  */
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 0 );
  } 

 /* Write single data to the SSP  */
 
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 0 );
  }

 /* During 1st word transmission   */
  PO(  SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_2);
  PSR( SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_2);
 
 /* Read SSPTB Status register */
   PO(SSPTB_BSY  | SSPTB_RXFE ,masks[8],SSPTBSSR, 3*TimeOut,spi_5I_tb2);
   PSR(SSPTB_BSY | SSPTB_RXFE ,masks[8],SSPTBSSR, spi_5I_tb2);

 /* After one word transmission  over  */
  PO( SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_3);
  PSR(SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_3);
 
 /* Read and compare the single data words  */
 for(i=0; i< 1 ; i++)
 {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,data_spi_5I_7);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_5I_7); 
 }

 /* Disable the Trickbox */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );


 C(" TI Format Single Word Tx/Rx");

  ProgramReg(SSP_SCLK_RATE1 | SSP_TI | DataSize[8] , SSPCR0,32);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_TI | 
                        DataSize[8]) ;
 PSW(ssptb_enable_value ,SSPTBSCR0,SSPTBSCR0);

 /* Read SSP Status register */
        PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,spi_5I_0);
 
 /* Read SSPTB Status register */
        PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_5I_tb0);

 /*  Write single data word to the SSPTB  */
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 0 );
  } 

 /* Write single data to the SSP  */
 
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 0 );
  }

 /* During 1st word transmission   */
  PO(  SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_2);
  PSR( SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_2);
 
 /* Read SSPTB Status register */
   PO(SSPTB_BSY  | SSPTB_RXFE ,masks[8],SSPTBSSR, 3*TimeOut,spi_5I_tb2);
   PSR(SSPTB_BSY | SSPTB_RXFE ,masks[8],SSPTBSSR, spi_5I_tb2);

 /* After one word transmission  over  */
  PO( SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_3);
  PSR(SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_3);
 
 /* Read and compare the single data words  */
 for(i=0; i< 1 ; i++)
 {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,data_spi_5I_7);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_5I_7); 
 }

 /* Disable the Trickbox */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );


C(" NMw Format Single Word Tx/Rx");

  ProgramReg(SSP_SCLK_RATE1 | SSP_MICROWIRE | DataSize[8] , SSPCR0,32);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_MICROWIRE | 
                        DataSize[8]) ;
 PSW(ssptb_enable_value ,SSPTBSCR0,SSPTBSCR0);

 /* Read SSP Status register */
        PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,spi_5I_0);
 
 /* Read SSPTB Status register */
        PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_5I_tb0);

 /*  Write single data word to the SSPTB  */
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 0 );
  } 

 /* Write single data to the SSP  */
 
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 0 );
  }

 /* During 1st word transmission   */
  PO(  SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_2);
  PSR( SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_2);
 
 /* Read SSPTB Status register */
   PO(SSPTB_BSY  | SSPTB_RXFE ,masks[8],SSPTBSSR, 3*TimeOut,spi_5I_tb2);
   PSR(SSPTB_BSY | SSPTB_RXFE ,masks[8],SSPTBSSR, spi_5I_tb2);

 /* After one word transmission  over  */
  PO( SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_3);
  PSR(SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_3);
 
 /* Read and compare the single data words  */
 for(i=0; i< 1 ; i++)
 {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,data_spi_5I_7);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_5I_7); 
 }

 /* Disable the Trickbox */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );



C(" Motorola SPI00 Format Single Word Tx/Rx");

  ProgramReg(SSP_SCLK_RATE1 | SSP_SPI00 | DataSize[8] , SSPCR0,32);

 /* Change SSP Tricbox From Ti to NatSemi Microwire mode */
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_SPI00 | 
                        DataSize[8]) ;
 PSW(ssptb_enable_value ,SSPTBSCR0,SSPTBSCR0);

 /* Read SSP Status register */
        PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,spi_5I_0);
 
 /* Read SSPTB Status register */
        PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_5I_tb0);

 /*  Write single data word to the SSPTB  */
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 0 );
  } 

 /* Write single data to the SSP  */
 
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 0 );
  }

 /* During 1st word transmission   */
  PO(  SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_2);
  PSR( SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_2);
 
 /* Read SSPTB Status register */
   PO(SSPTB_BSY  | SSPTB_RXFE ,masks[8],SSPTBSSR, 3*TimeOut,spi_5I_tb2);
   PSR(SSPTB_BSY | SSPTB_RXFE ,masks[8],SSPTBSSR, spi_5I_tb2);

 /* After one word transmission  over  */
  PO( SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_3);
  PSR(SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_3);
 
 /* Read and compare the single data words  */
 for(i=0; i< 1 ; i++)
 {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,data_spi_5I_7);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_5I_7); 
 }

 /* Disable the Trickbox */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );




C(" TI Format Single Word Tx/Rx");

  ProgramReg(SSP_SCLK_RATE1 | SSP_TI | DataSize[8] , SSPCR0,32);

 /* Change SSP Tricbox From Ti to NatSemi Microwire mode */
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_TI | 
                        DataSize[8]) ;
 PSW(ssptb_enable_value ,SSPTBSCR0,SSPTBSCR0);

 /* Read SSP Status register */
        PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,spi_5I_0);
 
 /* Read SSPTB Status register */
        PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_5I_tb0);

 /*  Write single data word to the SSPTB  */
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 0 );
  } 

 /* Write single data to the SSP  */
 
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 0 );
  }

 /* During 1st word transmission   */
  PO(  SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_2);
  PSR( SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_2);
 
 /* Read SSPTB Status register */
   PO(SSPTB_BSY  | SSPTB_RXFE ,masks[8],SSPTBSSR, 3*TimeOut,spi_5I_tb2);
   PSR(SSPTB_BSY | SSPTB_RXFE ,masks[8],SSPTBSSR, spi_5I_tb2);

 /* After one word transmission  over  */
  PO( SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_3);
  PSR(SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_3);
 
 /* Read and compare the single data words  */
 for(i=0; i< 1 ; i++)
 {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,data_spi_5I_7);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_5I_7); 
 }

 /* Disable the Trickbox */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );



 C(" Motorola SPI00 Format Single Word Tx/Rx");

  ProgramReg(SSP_SCLK_RATE1 | SSP_SPI00 | DataSize[8] , SSPCR0,32);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_SPI00 | 
                        DataSize[8]) ;
 PSW(ssptb_enable_value ,SSPTBSCR0,SSPTBSCR0);

 /* Read SSP Status register */
        PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,spi_5I_0);
 
 /* Read SSPTB Status register */
        PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_5I_tb0);

 /*  Write single data word to the SSPTB  */
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 0 );
  } 

 /* Write single data to the SSP  */
 
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 0 );
  }

 /* During 1st word transmission   */
  PO(  SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_2);
  PSR( SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_2);
 
 /* Read SSPTB Status register */
   PO(SSPTB_BSY  | SSPTB_RXFE ,masks[8],SSPTBSSR, 3*TimeOut,spi_5I_tb2);
   PSR(SSPTB_BSY | SSPTB_RXFE ,masks[8],SSPTBSSR, spi_5I_tb2);

 /* After one word transmission over  */
  PO( SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_3);
  PSR(SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_3);
 
 /* Read and compare the single data words  */
 for(i=0; i< 1 ; i++)
 {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,data_spi_5I_7);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_5I_7); 
 }

 /* Disable the Trickbox */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );


C(" NMw Format Single Word Tx/Rx");

  ProgramReg(SSP_SCLK_RATE1 | SSP_MICROWIRE | DataSize[8] , SSPCR0,32);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_MICROWIRE | 
                        DataSize[8]) ;
 PSW(ssptb_enable_value ,SSPTBSCR0,SSPTBSCR0);

 /* Read SSP Status register */
        PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,spi_5I_0);
 
 /* Read SSPTB Status register */
        PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_5I_tb0);

 /*  Write single data word to the SSPTB  */
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 0 );
  } 

 /* Write single data to the SSP  */
 
  for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 0 );
  }

 /* During 1st word transmission   */
  PO(  SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_2);
  PSR( SSP_BSY | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_2);
 
 /* Read SSPTB Status register */
   PO(SSPTB_BSY  | SSPTB_RXFE ,masks[8],SSPTBSSR, 3*TimeOut,spi_5I_tb2);
   PSR(SSPTB_BSY | SSPTB_RXFE ,masks[8],SSPTBSSR, spi_5I_tb2);

 /* After one word transmission  over  */
  PO( SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR , 3*TimeOut, spi_5I_3);
  PSR(SSP_RNE | SSP_TNF | SSP_TFE, masks[5] , SSPSR ,spi_5I_3);
 
 /* Read and compare the single data words  */
 for(i=0; i< 1 ; i++)
 {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,data_spi_5I_7);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_5I_7); 
 }

 /* Disable SSP and SSPTB */
  ProgramReg(0x0 ,SSPCR1,5);
  ProgramReg(0x00 , SSPTBSCR0 ,5 );

 C(" Mode Change Tests Complete ");

}/* End Function */
