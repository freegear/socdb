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
--  File Name              : Ssp_Spi01_MSTests.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Spi01_MSTests
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Spi01_MSTests()
{

 /*
  Summary: MS Test in SPI01 Mode
  ===========================
 
       In this test the functionality of the SSP has been changed from
 Master to Slave and then to Master. 
     Initially when the SSP is in Master mode two data words are written
 and transmitted. The two words are then read and compared for error free
 transmission. Then the SSP and the Trickbox are disabled. Now, the SSP
 is enabled as a Slave and the data is written and read. Again after
 disabling, the SSP is enabled as a Master and data is written and read.
 
 */

 int32 buffer[32];
 int i;

 for(i=0;i<32;i++)
 buffer[i]=0x5555;

 C(" SPI01 mode PRESCALE 1,Baud 1, Wordlength 16 , RXW 2 ");

 /* Program SSP */
 ProgramReg( SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE1 | SSP_SPI01 | DataSize[16] , SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 RXW_Value = SSPTB_RXW_2;
 ProgramReg( RXW_Value | SSPTB_SPI01 , SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_SPI |
                        DataSize[16]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE1  );
 
 /* Read SSP Status register */
 PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,s0);
 
 /* Read SSPTB Status register */
 PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,sb0);
 
 /* Enable SSPTB  */
 ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);
 
 /* Write  2 data to the SSPTB  */
 for( i =0 ; i< 2; i++)
 {
  ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 1);
 }
 
 /* Read SSPTB Status register */
 PO( SSPTB_RXFE , masks[8] , SSPTBSSR , 2*TimeOut ,sb1);
 PSR(SSPTB_RXFE ,masks[8],SSPTBSSR,sb1);
 
 /* Write 2 data to the SSP  */
 for( i=0 ; i< 2 ; i++)
 {
  ProgramReg( buffer[i] & Masks[WordLength], SSPDR, 0 );
 }
 
 /* Enable SSP  */
 ProgramReg(SSP_ENABLE,SSPCR1,1);
 
 /* During transmission   */
 PO(  SSP_BSY | SSP_TNF , masks[5] , SSPSR , 2*TimeOut,s3);
 PSR( SSP_BSY | SSP_TNF , masks[5],SSPSR,s3);
 
 /* Read SSPTB status register */
 PO( SSPTB_RXWFLG | SSPTB_TXFE,masks[8] , SSPTBSSR , 3*TimeOut ,sb3);
 PSR(SSPTB_RXWFLG | SSPTB_TXFE,masks[8],SSPTBSSR,sb3);
 PO(SSP_TFE | SSP_TNF | SSP_RNE, masks[5] , SSPSR , 3*TimeOut,t3);
 PSR(SSP_TFE | SSP_TNF | SSP_RNE, masks[5],SSPSR,t3);

 /* Read two words from SSPTB & SSP and compare data */
 for( i=0 ; i< 2 ; i++)
  {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,s4_data2);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,sb4_DATA2);
  }

 /* Disable SSPTB and SSP */ 
 ProgramReg(0x0 ,SSPCR1,5);
 ProgramReg(0x00 , SSPTBSCR0 ,5 ); 
 
 /* Program SSP */
 ProgramReg( SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE6 | SSP_SPI01 | DataSize[16] , SSPCR0,32);
 ProgramReg(SSP_MS,SSPCR1,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 RXW_Value = SSPTB_RXW_2;
 ProgramReg( RXW_Value | SSPTB_MS | SSPTB_SPI01, SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE6 | SSPTB_SPI |
                        DataSize[16]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE6 );
 
 /* Enable SSP  */
 ProgramReg(SSP_ENABLE | SSP_MS ,SSPCR1,1);

 /* Write  2 data to the SSPTB  */
 for( i =2 ; i< 4; i++)
 {
  ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 1);
 }
 
 /* Read SSPTB Status register */
 PO( SSPTB_RXFE , masks[8] , SSPTBSSR , 2*TimeOut ,sb1);
 PSR(SSPTB_RXFE ,masks[8],SSPTBSSR,sb1);
 
 /* Write 2 data to the SSP  */
 for( i=2 ; i< 4 ; i++)
 {
  ProgramReg( buffer[i] & Masks[WordLength], SSPDR, 0 );
 }
 
 /* Enable SSPTB  */
 ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);
 
 /* During transmission   */
 PO(  SSP_BSY | SSP_TNF , masks[5] , SSPSR , 2*TimeOut,s3);
 PSR( SSP_BSY | SSP_TNF , masks[5],SSPSR,s3);
 
 /* Read SSPTB status register */
 PO( SSPTB_RXWFLG | SSPTB_TXFE,masks[8] , SSPTBSSR , 3*TimeOut ,sb3);
 PSR(SSPTB_RXWFLG | SSPTB_TXFE,masks[8],SSPTBSSR,sb3);
 PO(SSP_TFE | SSP_TNF | SSP_RNE, masks[5] , SSPSR , 3*TimeOut,t3);
 PSR(SSP_TFE | SSP_TNF | SSP_RNE, masks[5],SSPSR,t3);

 /* Read two words from SSPTB & SSP and compare data */
 for( i=2 ; i< 4 ; i++)
  {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,s4_data2);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,sb4_DATA2);
  }

 /* Disable SSPTB and SSP */ 
 ProgramReg(0x00 , SSPTBSCR0 ,5 ); 
 ProgramReg(0x00 , SSPTBSCR1 ,5 );
 ProgramReg(0x00 ,SSPCR1,5);
 
 /* Program SSP */
 ProgramReg( SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE1 | SSP_SPI01 | DataSize[16] , SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 RXW_Value = SSPTB_RXW_2;
 ProgramReg( RXW_Value | SSPTB_SPI01 , SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_SPI |
                        DataSize[16]) ;

 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE1  );
 
 /* Read SSP Status register */
 PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,s0);
 
 /* Read SSPTB Status register */
 PSR(SSPTB_RXFE | SSPTB_TXFE ,masks[8],SSPTBSSR,sb0);
 
 /* Enable SSPTB  */
 ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

 /* Write  2 data to the SSPTB  */
 for( i =4 ; i< 6; i++)
 {
  ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 1);
 }
 
 /* Write 2 data to the SSP  */
 for( i=4 ; i< 6 ; i++)
 {
  ProgramReg( buffer[i] & Masks[WordLength], SSPDR, 0 );
 }
 
 /* Read SSPTB Status register */
 PO( SSPTB_RXFE ,masks[8] , SSPTBSSR , 2*TimeOut ,sb1);
 PSR(SSPTB_RXFE ,masks[8],SSPTBSSR,sb1);
 
 /* Enable SSP  */
 ProgramReg(SSP_ENABLE,SSPCR1,1);
 
 /* During transmission   */
 PO(  SSP_BSY | SSP_TNF , masks[5] , SSPSR , 2*TimeOut,s3);
 PSR( SSP_BSY | SSP_TNF , masks[5],SSPSR,s3);
 
 /* Read SSPTB status register */
 PO( SSPTB_RXWFLG | SSPTB_TXFE,masks[8] , SSPTBSSR , 4*TimeOut ,sb3);
 PSR(SSPTB_RXWFLG | SSPTB_TXFE,masks[8],SSPTBSSR,sb3);
 PO(SSP_TFE | SSP_TNF | SSP_RNE, masks[5] , SSPSR , 4*TimeOut,t3);
 PSR(SSP_TFE | SSP_TNF | SSP_RNE, masks[5],SSPSR,t3);
 
 /* Read two words from SSPTB & SSP and compare data */
 for( i=4 ; i< 6 ; i++)
  {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,s4_data2);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,sb4_DATA2);
  }
 
 /* Disable SSPTB and SSP */
 ProgramReg(0x00 ,SSPCR1,5);
 ProgramReg(0x00 , SSPTBSCR0 ,5 );

 C("MS Test in SPI01 mode over");
 
}/* End Function */
