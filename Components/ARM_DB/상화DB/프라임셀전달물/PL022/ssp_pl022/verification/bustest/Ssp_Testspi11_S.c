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
--  File Name              : Ssp_Testspi11_S.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Testspi11_S
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Testspi11_S(Noofwords , WordLength )
  int32 Noofwords ;
  int32 WordLength;
{

 /* Called by Spi11_FrameFormat_Test_S */

  int32 buffer[32];
  int32 noofwords ;
  int i;
 
 C("TEST spi11 for Slave");
  
  for(i=0 ; i< 32 ; i++)
    buffer[i] = i;

 if (Noofwords > 8) noofwords = 8; 
  else noofwords = Noofwords ;

 /* Read SSP Status register */
    PSR(SSP_TNF | SSP_TFE ,masks[5],SSPSR,spi11_B_0);
    PI(2);

 /* Enable SSP  */
   ProgramReg(SSP_ENABLE | SSP_MS ,SSPCR1,20); 

 /* Write data to the SSPTB  */
  for(i=0; i< 8 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength] , SSPTBSTDR,1 );
  }

 /* Write data to the SSP  */
  for(i=0; i< 8 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength] , SSPDR,1 );
  }

 /* Enable SSPTB  */
   ProgramReg(ssptb_enable_value ,SSPTBSCR0,1);
 
 /* After one word transmission is over  */
   PO(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR , 3*TimeOut,spi11_B_2);
   PSR( SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR ,spi11_B_2);
 
 /* During the 8th word transmission  */
   PO( SSP_BSY | SSP_RNE | SSP_TNF | SSP_TFE, masks[5],SSPSR,9*TimeOut ,spi11_B_5);
   PSR(SSP_BSY | SSP_RNE | SSP_TNF | SSP_TFE, masks[5],SSPSR,spi11_B_5);
 
 /* Wait until transmission is over and  SSP flags are set */
   PO( SSP_RFF |  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 3*TimeOut ,spi11_B_6);
   PSR( SSP_RFF | SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,spi11_B_6);
 
 /* Read 1st SSP SSPDR register and compare data */
   PSR(buffer[0] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,spi11_B_data0);
   PSR(buffer[0] & Masks[WordLength],Masks[WordLength],SSPTBSRDR,spi11_B_DATA0);
   PO(  SSP_RNE | SSP_TNF | SSP_TFE , masks[5], SSPSR, 3*TimeOut,spi11_B_7);
 
 /* Read next 7 words */
   for(i=1; i< noofwords ; i++)
   {
    PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,spi11_B_data4);
    PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,spi11_B_DATA4);
  }
 
   PO( SSP_TNF | SSP_TFE ,masks[5],SSPSR,3*TimeOut,spi11_B_8);

 /* Disable SSP and SSPTB */
 ProgramReg( 0x00 , SSPTBSCR0 ,5);
 ProgramReg(0x00 , SSPTBSCR1 ,5 );
 ProgramReg( 0x00 , SSPCR1 ,5 );

 C("TEST spi11 for Slave OVER");

}/* End Function */
