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
--  File Name              : Ssp_Ti_RxDisMid_S.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Ti_FrameFormat_Test_S
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Ti_RxDisMid_S()
{
   /*
   Summary: TI SSP Disabled during Reception Tests 
   ===============================================
 
   o This test disables the SSP during reception before the whole word
     has been received, causing the SSP to return to it's idle state.

   */

 int32 buffer[32];
 int i;

 C("TI SSP Slave Disabled During Reception");

 C("Baud 5, Wordlength 8");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE5 | SSP_TI | DataSize[8] , SSPCR0,32);
 ProgramReg(SSP_MS,SSPCR1,32);

 /* Program SSPTB */
 ProgramReg(PRE_1, SSPTBPRE, 5 );
 ProgramReg(0x10,  SSPTBSCR1, 5);
 ProgramReg(SSPTB_TI,SSPTBSCR0,5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE5 | SSPTB_TI 
                        | DataSize[8]);
 WordLength = DataSize[8] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE5);
 
 for(i=0; i<32 ; i++)
   buffer[i] =  0x5555;

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

 /* Enable SSP  */
  ProgramReg(SSP_ENABLE | SSP_MS ,SSPCR1,5);

 /* Enable SSPTB  */
  ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

 /* Idle for 48 cycles */
  Idle(48);
           
  PSR(SSP_BSY | SSP_TNF | SSP_TFE, masks[5], SSPSR, ti_busy);

 /* Disable SSP, but remaining in Slave Mode*/
  ProgramReg(0x4 ,SSPCR1,5);

  Idle(3);

  PSR(SSP_TNF | SSP_TFE, masks[5], SSPSR, ti_notbusy);

 /* Disable the Trickbox */
  ProgramReg(0x00 , SSPTBSCR0 ,5 );
 



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

 /* Enable SSP  */
  ProgramReg(SSP_ENABLE | SSP_MS ,SSPCR1,5);

 /* Enable SSPTB  */
  ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

 /* Idle for 52 cycles */
  Idle(52);
           
  PSR(SSP_BSY | SSP_TNF | SSP_TFE, masks[5], SSPSR, ti_busy);

 /* Disable SSP, but remaining in Slave Mode*/
  ProgramReg(0x4 ,SSPCR1,5);

  Idle(3);

  PSR(SSP_TNF | SSP_TFE, masks[5], SSPSR, ti_notbusy);
  
 /* Disable the Trickbox */
  ProgramReg(0x00 , SSPTBSCR0 ,5 );
 



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

 /* Enable SSP  */
  ProgramReg(SSP_ENABLE | SSP_MS ,SSPCR1,5);

 /* Enable SSPTB  */
  ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

 /* Idle for 104 cycles */
  Idle(102);
           
  PSR(SSP_BSY | SSP_TNF | SSP_TFE, masks[5], SSPSR, ti_busy);

 /* Disable SSP, but remaining in Slave Mode*/
  ProgramReg(0x4 ,SSPCR1,5);

  Idle(3);

  PSR(SSP_TFE | SSP_TNF| SSP_RNE, masks[5], SSPSR, ti_notbusy);
  
 /* Disable the Trickbox */
  ProgramReg(0x00 , SSPTBSCR0 ,5 );
 


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

 /* Enable SSP  */
  ProgramReg(SSP_ENABLE | SSP_MS ,SSPCR1,5);

 /* Enable SSPTB  */
  ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

 /* Idle for 108 cycles */
  Idle(108);
           
  PSR(SSP_BSY | SSP_TFE | SSP_TNF | SSP_RNE, masks[5], SSPSR, ti_notbusy);

 /* Disable SSP, but remaining in Slave Mode*/
  ProgramReg(0x4 ,SSPCR1,5);

  Idle(3);

  PSR(SSP_TNF | SSP_TFE | SSP_RNE, masks[5], SSPSR, ti_notbusy);

 /* Disable the Trickbox */
  ProgramReg(0x00 , SSPTBSCR0 ,5 );

 /* Clear SSP Rx FIFO */

  for(i=0; i< 2 ; i++)
  {
    PSR(0x0000, 0x0000, SSPDR, 0 );
  }


 /* Disable SSP and SSPTB */
 ProgramReg( 0x00 , SSPTBSCR0 ,5);
 ProgramReg( 0x00 , SSPTBSCR1 ,5);
 ProgramReg( 0x4 ,SSPCR1,5);

 C("TI Frame Format Test End  for Slave");

}/* End Function */
