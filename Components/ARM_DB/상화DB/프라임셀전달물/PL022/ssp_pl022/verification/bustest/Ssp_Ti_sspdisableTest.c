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
--  File Name              : Ssp_Ti_sspdisableTest.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Ti_sspdisableTest
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Ti_sspdisableTest()
{

 /* Called by SspdisableTest */

  int buffer[32];
  int Buffer[32];
  int i ;

 C("TI sspdisable Test");
  
 C("Baud 0, Wordlength 16");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE0 | SSP_TI | DataSize[16] , SSPCR0,32);

 /* Program SSPTB */
 ProgramReg(PRE_1, SSPTBPRE, 5 );
 ProgramReg(SSPTB_SCLK_RATE0 | SSPTB_TI  | DataSize[16],SSPTBSCR0,5);
 Idle(3 * SSPCLK_PERIOD);
 ProgramReg(SSPTB_OD,  SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE0 | SSPTB_TI 
                        | DataSize[16]) ;

 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE0);

 for(i=0;i<32;i++)
        buffer[i] = i;
 
  for(i=0;i<32; i++)
        Buffer[i] =  i % 2 ;

 /* Read SSP Status register */
        PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,TI_N_0);

 /* Write five words to SSP  */
 for(i=0; i< 5 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 1 );
  }
 
 /* Read SSP Status register */
     PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , 3*TimeOut ,TI_N_1);
     PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,TI_N_1);
 
 /* Enable SSPTB  */
    ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

 /* Write data to SSPTB  */
 for(i=0; i< 5; i++)
  {
    ProgramReg(Buffer[i] & Masks[WordLength], SSPTBSTDR, 5 );
  }
 
 /* Idle Cycles */
     Idle(4*TimeOut);
 
 /* Read SSP Status register */
     PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,TI_N_1);
     PSR(SSPTB_RXFE ,masks[9],SSPTBSSR,TI_N_1); 

 /* Disable OD Bit */
     ProgramReg(0x00,  SSPTBSCR1, 5);
 
 /* Enable SSP  */
    ProgramReg(SSP_ENABLE,SSPCR1,5); 
 
 /* During 1st word transmission  */
   PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , 2*TimeOut,TI_N_2);
   PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,TI_N_2);
 
 /* After one word transmission is over  */
   PO(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR , 2*TimeOut,TI_N_3);
   PSR( SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR ,TI_N_3);
 
 /* Wait until transmission is over and SSP flags are set */
   PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 6*TimeOut ,TI_N_4);
   PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,TI_N_4);
 
 /* Read next 5 words */
   for(i=0; i< 5 ; i++)
   {
    PSR(Buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,TI_N_data4);
    PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,TI_N_DATA4);
  }

 /* Disable SSP and SSPTB */
   ProgramReg(0x0 ,SSPCR1,7);
   ProgramReg(0x00 , SSPTBSCR0 ,5 );

 C("TI sspdisable Test over");

}/* End Function */
