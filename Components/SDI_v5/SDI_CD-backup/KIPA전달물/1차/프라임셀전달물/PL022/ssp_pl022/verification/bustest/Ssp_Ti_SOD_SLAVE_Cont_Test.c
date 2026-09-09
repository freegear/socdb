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
--  File Name              : Ssp_Ti_SOD_SLAVE_Cont_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Ti_SOD_SLAVE_Cont_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Ti_SOD_SLAVE_Cont_Test()
{

 /*
  Summary: TI SOD Continuous SLAVE Test
  =====================================
 

      The purpose of this test is to check that the slave does not transmit
 data to the master when the SOD bit is set. Four data words are written into 
 both the Trickbox and the Ssp and transmission is allowed to take place.
 Then status flags are read to check that the transmit FIFO of the slave 
 contains the data written and that the data is not transmitted to the slave.
 Now again four data words are written into the master and the SOD bit is 
 cleared. Transmission is allowed to take place and the data is read and 
 compared.

 */
  int SSPDataBuffer[32];
  int TBDataBuffer[32];
  int i ;

 C("TI SOD CONTINUOUS SLAVE Test");
  
 C("Baud 5, Wordlength 16");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE5 | SSP_TI | DataSize[16] , SSPCR0,32);
 ProgramReg(SSP_MS,SSPCR1,32);

 /* Program SSPTB */
 ProgramReg(PRE_1, SSPTBPRE, 5 );
 ProgramReg(0x30,  SSPTBSCR1, 5);
 ProgramReg(SSPTB_TI,  SSPTBSCR0, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE5 | SSPTB_TI 
                        | DataSize[16]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE5);

 for(i=0;i<32;i++)
        SSPDataBuffer[i] = i;
 
 for(i=0;i<32; i++)
        TBDataBuffer[i] =  i % 2 ;


 /* Read SSP Status register */
 PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,TI_N_0);

 /* Write four words to SSPTB */
 for(i=1; i< 5 ; i++)
  {
    ProgramReg(TBDataBuffer[i] & Masks[WordLength], SSPTBSTDR,5);
  }
 
 /* Enable SSP  */
 ProgramReg(SSP_ENABLE | SSP_MS | SSP_SOD ,SSPCR1,5);
 
 /* Write data to SSP */
 for(i=1; i< 5; i++)
  {
    ProgramReg(SSPDataBuffer[i] & Masks[WordLength], SSPDR,5);
  }

 /* Enable SSPTB  */
 ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);
 
 /* Read SSP and SSPTB Status register */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , 2*TimeOut ,TI_N_1); 
 PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,TI_N_1);
 PO(SSPTB_BSY | SSPTB_RXFE  ,masks[8],SSPTBSSR, 2*TimeOut ,TI_N_1); 
 PSR(SSPTB_RXFE | SSPTB_BSY ,masks[8],SSPTBSSR,TI_N_11);

 /* Wait until transmission is over and SSP flags are set */
 PO( SSP_BSY | SSP_TNF | SSP_RNE , masks[5] , SSPSR , 6*TimeOut ,TI_N_1);
 PSR(SSP_BSY | SSP_TNF | SSP_RNE ,masks[5],SSPSR,TI_N_10);
 PO(SSPTB_TXFE | SSPTB_RXWFLG,masks[8],SSPTBSSR, 6*TimeOut ,TI_N_2); 
 PSR(SSPTB_TXFE | SSPTB_RXWFLG,masks[8],SSPTBSSR,TI_N_21);

 
 /* Read 4 words */
 for(i=1; i< 5 ; i++)
 {
  PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,TI_N_data4);
 /* As the Slave output is disabled so the expected data is zero */
  PSR(0x0000 ,Masks[WordLength],SSPTBSRDR,TI_N_data4);
 }

 /* Clear SOD Bit in SSPTB  */
 ProgramReg(0x10,  SSPTBSCR1, 5);

 /* Clear SOD Bit in SSP */
 ProgramReg(SSP_ENABLE | SSP_MS ,SSPCR1,5);

 /* Write four words to SSPTB */
 for(i=1; i< 5 ; i++)
  {
    ProgramReg(TBDataBuffer[i] & Masks[WordLength], SSPTBSTDR,5);
  }

 /* Read SSP and SSPTB Status register */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , 2*TimeOut ,TI_N_1); 
 PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,TI_N_1);
 PO(SSPTB_BSY| SSPTB_RXFE ,masks[8],SSPTBSSR, 2*TimeOut ,TI_N_11);    
 PSR(SSPTB_RXFE | SSPTB_BSY ,masks[8],SSPTBSSR,TI_N_11);

 /* Wait until transmission is over and SSP flags are set */
 PO(SSP_TNF | SSP_RNE | SSP_TFE , masks[5] , SSPSR , 6*TimeOut ,TI_N_12);
 PSR(SSP_TNF | SSP_RNE | SSP_TFE ,masks[5],SSPSR,TI_N_12);
 PO(SSPTB_TXFE | SSPTB_RXWFLG,masks[8],SSPTBSSR, 6*TimeOut ,TI_N_13);
 PSR(SSPTB_TXFE | SSPTB_RXWFLG,masks[8],SSPTBSSR,TI_N_13); 
 
 /* Read four words */
 for(i=1; i< 5 ; i++)
 {
  PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,TI_N_data5);
  PSR(SSPDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,TI_N_data5);
 }
 
 /* Disable SSP and SSPTB */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );
 ProgramReg(0x00,  SSPTBSCR1, 5);
 ProgramReg(0x0 ,SSPCR1,7);

 C("TI SOD Continuous SLAVE Test over");

}/* End Function */
