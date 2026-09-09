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
--  File Name              : Ssp_SspLoopBack_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function SspLoopBack_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void SspLoopBack_Test()
{
  /*
  Summary: Loop Back Mode Tests
  =============================
  
  o This is to test the SSP in the loop back mode. In this SSP is enabled in
  the loopback mode. TrickBox is disabled. Now data is written to the Tx fifo
  and after complete transmission, data is read from the Rx fifo and checked 
  for correct transmission.

  */
 
  int32 buffer[16];
  int i;
  
 C("Loop Back Test");

 C(" TI mode ,Baud 0, Wordlength 16");

  for(i=0;i<16; i++)
        buffer[i] = (16 - i );

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE0 | SSP_TI | DataSize[16] , SSPCR0,32);
 WordLength = DataSize[16]; 

 /* Read SSP Status register */
 PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,lM_B_0);

 /* Write Eight words to the SSP  */
 for(i=0; i< 8 ; i++)
 {
   ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 1 );
 }
 
 /* Read SSP Status register */
 PO( SSP_BSY , masks[5] , SSPSR , 9*TimeOut ,LB_B_1);
 PSR(SSP_BSY ,masks[5],SSPSR,LB_B_1);
 
 /* Enable SSP  */
 ProgramReg(SSP_ENABLE | SSP_LBM ,SSPCR1,5); 
 
 /* During 1st word transmission   */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , 2*TimeOut,LB_B_2);
 PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,LB_B_2);
 
 /* After one word transmission is over  */
 PO(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR , 2*TimeOut,LB_B_3);
 PSR( SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR ,LB_B_3);
 
 /* During the 8th word transmission  */
 PO(  SSP_BSY | SSP_RNE | SSP_TNF | SSP_TFE, masks[5],SSPSR,9*TimeOut ,LB_B_7);
 PSR(SSP_BSY | SSP_RNE | SSP_TNF | SSP_TFE, masks[5],SSPSR,LB_B_7);
 
 /* Wait until transmission is over and SSP flags are set */
 PO( SSP_RFF | SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 9*TimeOut ,LB_B_8);
 PSR( SSP_RFF| SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,LB_B_8);
 
 /* Read 1st data from SSPDR register and compare data */
 PSR(buffer[0] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,LB_B_data0);

 /* Read SSP Status register */
 PO(   SSP_RNE | SSP_TNF | SSP_TFE , masks[5], SSPSR, 2*TimeOut,LB_B_9);
 
 /* Read next 4 words */
 for(i=1; i< 8 ; i++)
 {
  PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,LB_B_data4);
 }

 /* Read SSP Status register */
 PO(  SSP_TNF | SSP_TFE , masks[5], SSPSR, 4*TimeOut,LB_B_c);
 PSR( SSP_TNF | SSP_TFE , masks[5], SSPSR,LB_B_c);

 /* Disable SSP  */
 ProgramReg(0x0 ,SSPCR1,5);
 
 C("Loop Back Test End");
 
}/* End Function */
