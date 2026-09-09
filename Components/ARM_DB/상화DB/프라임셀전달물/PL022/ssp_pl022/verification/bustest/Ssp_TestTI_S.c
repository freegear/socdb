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
--  File Name              : Ssp_TestTI_S.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function TestTI_S
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void TestTI_S(Noofwords , WordLength )
  int32 Noofwords ;
  int32 WordLength  ;
{

  /* Called by Ti_FrameFormat_Test_S() */

  int32 buffer[32];
  int32 noofwords ;
  int i;
 
 
 C(" TEST TI FOR SLAVE ");

  for(i=0;i<32; i++)
        buffer[i] = i; 

 if (Noofwords > 8) noofwords = 8; 
  else noofwords = Noofwords ;

 /* Read SSP Status register */
 PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,TI_B_0);

 /* Write Eight words to the SSP  */
 for(i=0; i< noofwords ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 1 );
  }
 
 /* Read SSP Status register */
 PO( SSP_BSY , masks[5] , SSPSR , 9*TimeOut ,TI_B_1);
 PSR(SSP_BSY ,masks[5],SSPSR,TI_B_1);
 
 /* Write  data to the SSPTB  */
 for(i=0; i< 8 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 5 );
  } 

 /* Enable SSP  */
 ProgramReg(SSP_ENABLE | SSP_MS ,SSPCR1,5); 
 
 /* Enable SSPTB  */
 ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

 /* During 1st word transmission   */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , 3*TimeOut,TI_B_2);
 PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,TI_B_2);
 
 /* After one word transmission is over  */
 PO(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR , 3*TimeOut,TI_B_3);
 PSR( SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR ,TI_B_3);
 
 /* During the 8th word transmission  */
 PO(  SSP_BSY | SSP_RNE | SSP_TNF | SSP_TFE, masks[5],SSPSR,9*TimeOut ,TI_B_7);
 PSR(SSP_BSY | SSP_RNE | SSP_TNF | SSP_TFE, masks[5],SSPSR,TI_B_7);
 
 /* Wait until transmission is over and  SSP flags are set */
 PO( SSP_RFF | SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 3*TimeOut ,TI_B_8);
 PSR( SSP_RFF| SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,TI_B_8);
 
 /* Read 1st data from SSPDR register and compare data */
 PSR(buffer[0] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,TI_B_data0);
 PSR(buffer[0] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,TI_B_DATA0);

 /* Read SSP Status register */
 PO(   SSP_RNE | SSP_TNF | SSP_TFE , masks[5], SSPSR, 3*TimeOut,TI_B_9);
 
 /* Read next 4 words */
 for(i=1; i< 8 ; i++)
 {
  PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,TI_B_data4);
  PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,TI_B_DATA4);
 }

 /* Read SSP Status register */
 PO(  SSP_TNF | SSP_TFE , masks[5], SSPSR, 3*TimeOut,TI_B_c);
 PSR( SSP_TNF | SSP_TFE , masks[5], SSPSR,TI_B_c);

 /* Disable SSP and SSPTB */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );
 ProgramReg(0x00 , SSPTBSCR1 ,5 );
 ProgramReg(0x0 ,SSPCR1,5);
 
 C("TEST TI FOR SLAVE OVER");
}/* End Function */ 
