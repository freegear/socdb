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
--  File Name              : Ssp_SOD_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function SOD_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void SOD_Test(int32 SSP_SCLK_RATE,int32 spo,int32 sph,int32 mode)
{

 /*
  Summary: SOD SLAVE Test
  ==========================
 

      The purpose of this test is to check that the slave does not transmit
 data to the master when the SOD bit is set. A data word is written into 
 both the Trickbox and the Ssp Slave. The status flags are read to check that 
 the transmit FIFO of the slave contains the data written and that the data is 
 not transmitted to the slave. Now a new data word is written into the master 
 and the SOD bit is cleared. Transmission is allowed to take place and the data
 is read and compared. Writing a single byte helps to find out from the TFE
 bit,whether data is being removed from the TxFIFO by the SSP's Transmitter
 logic.

 */
  int SSPDataBuffer[32];
  int TBDataBuffer[32];
  int i ;
  int32 SSPTB_SCLK_RATE;
 
 SSPTB_SCLK_RATE = SSP_SCLK_RATE;

 C("SOD SLAVE Test");
  
 C("Wordlength 16");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_MS,SSPCR1,32);

 /* Program SSPTB */
 ProgramReg(PRE_1, SSPTBPRE, 5 );
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE);

 if (mode == SSPTB_SPI)
 {
  ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE | SSPTB_SPI
                        | DataSize[16]) ;
  if(spo==0 && sph==0)
    {
     ProgramReg(SSP_SCLK_RATE | SSP_SPI00 | DataSize[16] , SSPCR0,32);
     ProgramReg(SSPTB_SPI00 | SSPTB_MS | SSPTB_OD,  SSPTBSCR1, 5);
    }
  else if(spo==1 && sph==0)
    {
     ProgramReg(SSP_SCLK_RATE | SSP_SPI01 | DataSize[16] , SSPCR0,32);
     ProgramReg(SSPTB_SPI01 | SSPTB_MS | SSPTB_OD,  SSPTBSCR1, 5);
    }
  else if(spo==0 && sph==1)
    {
     ProgramReg(SSP_SCLK_RATE | SSP_SPI10 | DataSize[16] , SSPCR0,32);
     ProgramReg(SSPTB_SPI10 | SSPTB_MS | SSPTB_OD,  SSPTBSCR1, 5);
    }
  else if(spo==1 && sph==1)
    {
     ProgramReg(SSP_SCLK_RATE | SSP_SPI11 | DataSize[16] , SSPCR0,32);
     ProgramReg(SSPTB_SPI11 | SSPTB_MS | SSPTB_OD,  SSPTBSCR1, 5);
    }
 }
 else if(mode == SSP_TI)
 {
   ProgramReg(SSPTB_TI ,SSPTBSCR0,5);
   ProgramReg(SSP_SCLK_RATE | SSP_TI | DataSize[16] , SSPCR0,32);
   ProgramReg( SSPTB_MS | SSPTB_OD,  SSPTBSCR1, 5);
   ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE | SSPTB_TI
                        | DataSize[16]) ;
 
 }
 else if(mode == SSP_MICROWIRE)
 {
   ProgramReg(SSP_SCLK_RATE | SSP_MICROWIRE | DataSize[16] , SSPCR0,32);
   ProgramReg( SSPTB_MS | SSPTB_OD,  SSPTBSCR1, 5);
   ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE | SSPTB_MICROWIRE
                        | DataSize[16]) ;
 
 }

 for(i=0;i<32;i++)
      SSPDataBuffer[i] = i;
 
  for(i=0;i<32; i++)
      TBDataBuffer[i] =  i % 2 ;


 /* Read SSP Status register */
 PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,N_0);

 /* Write one word to SSPTB */
 for(i=1; i< 2 ; i++)
  {
    ProgramReg(TBDataBuffer[i] & Masks[WordLength], SSPTBSTDR,5);
  }
 
 /* Enable SSP  */
 ProgramReg(SSP_ENABLE | SSP_MS | SSP_SOD ,SSPCR1,5);
 
 /* Write data to SSP */
 for(i=1; i< 2; i++)
  {
    ProgramReg(SSPDataBuffer[i] & Masks[WordLength], SSPDR,5);
  }

 /* Enable SSPTB  */
 ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);
 
 /* Read SSP and SSPTB Status register */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut ,N_1); 
 PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,N_1);
 PO(SSPTB_BSY | SSPTB_RXFE |SSPTB_TXFE ,masks[8],SSPTBSSR, TimeOut ,N_1); 
 PSR(SSPTB_RXFE | SSPTB_BSY | SSPTB_TXFE,masks[8],SSPTBSSR,N_11);

 /* Wait until transmission is over and SSP flags are set */
 PO( SSP_BSY | SSP_TNF | SSP_RNE , masks[5] , SSPSR , TimeOut ,N_1);
 PSR(SSP_BSY | SSP_TNF | SSP_RNE ,masks[5],SSPSR,N_10);
 PO(SSPTB_TXFE ,masks[8],SSPTBSSR, TimeOut ,N_13);
 PSR(SSPTB_TXFE ,masks[8],SSPTBSSR,N_13);

 
 /* Read 1 word */
 for(i=1; i< 2 ; i++)
 {
  PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,N_data4);
 /* As the Slave output is disabled so the expected data is zero */
  PSR(0x0000 ,Masks[WordLength],SSPTBSRDR,N_data4);
 }

 /* Clear SOD Bit in SSPTB  */
 if (mode == SSPTB_SPI)
 {
  if(spo==0 && sph==0)
   ProgramReg(SSPTB_SPI00 | SSPTB_MS ,  SSPTBSCR1, 5);
  else if(spo==0 && sph==1)
   ProgramReg(SSPTB_SPI01 | SSPTB_MS ,  SSPTBSCR1, 5);
  else if(spo==1 && sph==0)
   ProgramReg(SSPTB_SPI10 | SSPTB_MS ,  SSPTBSCR1, 5);
  else if(spo==1 && sph==1)
   ProgramReg(SSPTB_SPI11 | SSPTB_MS ,  SSPTBSCR1, 5);
 }
 else
 ProgramReg(SSPTB_MS,  SSPTBSCR1, 5);

 /* Clear SOD Bit in SSP */
 ProgramReg(SSP_ENABLE | SSP_MS ,SSPCR1,5);

 /* Write one word to SSPTB */
 for(i=1; i< 2 ; i++)
 {
   ProgramReg(TBDataBuffer[i] & Masks[WordLength], SSPTBSTDR,5);
 }

 /* Read SSP and SSPTB Status register */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut ,N_1); 
 PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,N_1);
 PO(SSPTB_BSY| SSPTB_RXFE | SSPTB_TXFE,masks[8],SSPTBSSR, TimeOut ,N_11);
 PSR(SSPTB_RXFE | SSPTB_BSY | SSPTB_TXFE ,masks[8],SSPTBSSR,N_11);

 /* Wait until transmission is over and SSP flags are set */
 PO(SSP_TNF | SSP_RNE | SSP_TFE , masks[5] , SSPSR , TimeOut ,N_12);
 PSR(SSP_TNF | SSP_RNE | SSP_TFE ,masks[5],SSPSR,N_12);
 PO(SSPTB_TXFE ,masks[8],SSPTBSSR, TimeOut ,N_13);
 PSR(SSPTB_TXFE ,masks[8],SSPTBSSR,N_13); 

 /* Read 1 word */
 for(i=1; i< 2 ; i++)
 {
  PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,N_data5);
  PSR(SSPDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,N_data5);
 }
 
 /* Disable SSP and SSPTB */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );
 ProgramReg(0x00,  SSPTBSCR1, 5);
 ProgramReg(0x0 ,SSPCR1,7);

 C("SOD SLAVE Test over");

}/* End Function */
