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
--  File Name              : Ssp_FIFO_ptr_test_S.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function FIFO_ptr_test_S
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void FIFO_ptr_test_S()
{

 /*
  Summary: FIFO POINTER Test for Slave
  =====================================
 
        In this test the water mark level is changed from two to four,
 four to six and then to eight. Data is written and the status flags are
 checked to see that RXWFLG flag goes high depending upon the number of
 words transmitted and the value of the water mark level set.   

 */ 

  int32 buffer[32];
  int32 Buffer[32];
  int32 SSPTB_SCR0_VALUE  ;
  int i;
 
 C("FIFO Pointer Test for Slave");
 
 for(i=0;i<32;i++)
  buffer[i]=i;

 for(i=0;i<32;i++)
  Buffer[i]= (( i % 16 ) << 4) ;

 C(" TI mode PRESCALE 1,Baud 6, Wordlength 16 , RXW 2 ");
 /* Program SSP */
 ProgramReg( SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE6 | SSP_TI | DataSize[16] , SSPCR0,32);
 ProgramReg(SSP_MS,SSPCR1,32);

 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(SSPTB_TI,SSPTBSCR0,5);
 RXW_Value = SSPTB_RXW_2;
 ProgramReg( RXW_Value | SSPTB_MS , SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE6 | SSPTB_TI | 
                        DataSize[16]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE6 );

 /* Read SSP Status register */
 PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,t0);
 
 /* Read SSPTB Status register */
 PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,tb0);

 /* Enable SSP  */
 ProgramReg(SSP_ENABLE | SSP_MS ,SSPCR1,1);
 
 /* Write  16 data to the SSPTB  */
 for( i =0 ; i< 16; i++)
 {
  ProgramReg(Buffer[i] & Masks[WordLength], SSPTBSTDR, 1);
 }

 /* Read SSPTB Status register */
 PO( SSPTB_RXFE | SSPTB_TXFF , masks[8] , SSPTBSSR , 17*TimeOut ,tb1);  
 PSR(SSPTB_RXFE | SSPTB_TXFF ,masks[8],SSPTBSSR,tb1);

 /* Write 8 data to the SSP  */
 for( i=0 ; i< 8 ; i++)
 {
  ProgramReg( buffer[i] & Masks[WordLength], SSPDR, 0 );
 } 

 /* Read SSP Status register */
 PO( SSP_BSY , masks[5] , SSPSR , 9*TimeOut ,t2);
 PSR(SSP_BSY ,masks[5],SSPSR,t2);

 /* Enable SSPTB  */
 ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);
 
 /* During transmission   */
 PO(  SSP_BSY | SSP_TNF , masks[5] , SSPSR , 3*TimeOut,t3);
 PSR( SSP_BSY | SSP_TNF , masks[5],SSPSR,t3);

 /* Read SSPTB status register */        
 PO( SSPTB_RXWFLG | SSPTB_BSY ,masks[8] , SSPTBSSR , 8*TimeOut ,tb3); 
 PSR(SSPTB_RXWFLG |SSPTB_BSY ,masks[8],SSPTBSSR,tb3);
 
 /* Write 2 data to the SSP  */
 for( i=8 ; i< 10  ; i++)
 {
  ProgramReg( buffer[i] & Masks[WordLength], SSPDR, 0 );
 } 
 /* Delay intoduced for the data to be written to UUT's RXFIFO after */
 /* writing to trickbox RXFIFO */
 Idle(4 * SSPCLK_PERIOD / PCLK_PERIOD);

 /* Read two words from SSPTB & SSP and compare data */
 for( i=0 ; i< 2 ; i++)
  {
   PSR(Buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,t4_data2);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,tb4_DATA2);
  }

 /* Program SSPTB for RXW_4 */
 RXW_Value = SSPTB_RXW_4;
 ProgramReg( RXW_Value | SSPTB_MS , SSPTBSCR1, 1);

 /* Read SSPTB status register */        
 PO( SSPTB_RXFE| SSPTB_BSY ,masks[8] , SSPTBSSR , 9*TimeOut ,tb4 ); 
 PSR( SSPTB_BSY  | SSPTB_RXFE ,masks[8],SSPTBSSR,tb4);

 /* Read SSPTB status register */        
 PO( SSPTB_RXWFLG | SSPTB_BSY ,masks[8] , SSPTBSSR , 9*TimeOut ,tb5); 
 PSR(SSPTB_RXWFLG | SSPTB_BSY ,masks[8],SSPTBSSR,tb5);

 /* Write 3 data to the SSP  */
 for( i=10 ; i< 13  ; i++)
 {
   ProgramReg( buffer[i] & Masks[WordLength], SSPDR, 0 );
  } 

 /* Read four words from SSPTB & SSP and compare data */
 for( i=2 ; i< 6 ; i++)
 {
  PSR(Buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,t6_data4);
  PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,tb6_DATA4);
 }

 /* Program SSPTB for 6 */
 RXW_Value = SSPTB_RXW_6;
 ProgramReg( RXW_Value | SSPTB_MS , SSPTBSCR1, 1);

 /* read SSPTB status register */        
 PO( SSPTB_RXFE| SSPTB_BSY ,masks[8] , SSPTBSSR , 3*TimeOut ,tb7); 
 PSR( SSPTB_BSY  | SSPTB_RXFE ,masks[8],SSPTBSSR,tb7);

 /* READ SSPTB status register */        
  PO( SSPTB_RXWFLG | SSPTB_BSY ,masks[8] , SSPTBSSR , 7*TimeOut ,tb8); 
  PSR(SSPTB_RXWFLG | SSPTB_BSY ,masks[8],SSPTBSSR,tb8);

 /* Write 3 data to the SSP  */
 for( i=13 ; i< 16  ; i++)
  {
    ProgramReg( buffer[i] & Masks[WordLength], SSPDR, 0 );
  } 

 /* Read six words and compare it */
 for( i=6 ; i< 12 ; i++)
  {
   PSR(Buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,t9_data);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,tb9_DATA);
  }

 /* read SSPTB status register */        
 PO( SSPTB_RXFE| SSPTB_BSY ,masks[8] , SSPTBSSR , 3*TimeOut ,tbA+); 
 PSR( SSPTB_BSY  | SSPTB_RXFE ,masks[8],SSPTBSSR,tbA+);

 /* After transmission  is over  */
 PO( SSPTB_TXFE ,masks[8] , SSPTBSSR , 3*TimeOut ,TBA+); 
 PSR(SSPTB_TXFE ,masks[8],SSPTBSSR,TBA+);

 /* Read SSP SSPDR register and compare data */
 for( i=12 ; i< 16 ; i++)
 {
  PSR(Buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,tB_data);
  PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,tbB_DATA);
 }

 /* read SSPTB and SSP status register */        
 PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,tbC);
 PO( SSP_TNF | SSP_TFE , masks[5], SSPSR, 2*TimeOut,tC);

 /* Disable SSPTB */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );
 ProgramReg(0x00 , SSPTBSCR1 ,5 );
 ProgramReg(0x0 ,SSPCR1,5);

 C("FIFO Pointer Test End for Slave");

}/* End Function */
