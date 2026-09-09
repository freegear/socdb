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
--  File Name              : Ssp_Spi01_RTIS_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function SPI01_RTIS_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void SPI01_RTIS_Test()
{

 /* Called by Spi01_rtis_Interrupt_Test */

  int32 buffer[32];
  int i;
  int FIFO_FLG ; 
 
 C(" TEST SPI01 RTIS");

 for(i=0; i<32 ; i++)
   buffer[i] =  0x5555;
 
 /* Read SSP Status register */
 PSR(SSP_TNF | SSP_TFE, masks[5], SSPSR, rd_ssp_status);
 
 /* Read SSPTB Status register */
 PSR(SSPTB_TXFE | SSPTB_RXFE, masks[3], SSPTBSSR, rd_ssptb_status);

 /* Enable SSPTB  */
 PSW(ssptb_enable_value, SSPTBSCR0, SSPTBSCR0);
 
 /*  Write 2 datawords to the SSPTB  */
 for(i=0; i<2 ; i++)
   ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 0);

 /* Write 2 datawords to the SSP  */
 for(i=0; i< 2 ; i++)
   ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 0);

 /* Read SSP Status register */
 PO(  SSP_BSY | SSP_TNF, masks[5], SSPSR, TimeOut, poll_ssp_status);
 PSR( SSP_BSY | SSP_TNF, masks[5], SSPSR, rd_ssp_status);
  
 /* Enable SSP RX TimeOut FIFO Interrupt */
 ProgramReg(SSP_RTSC, SSPIMSC, 3);

 /* Enable SSP  */
 ProgramReg(ssp_enable_value_scr1, SSPCR1, 3);

 /* During first word transmitted */
 PO( SSP_BSY | SSP_TNF, masks[5], SSPSR, TimeOut, poll_1st_tx_started);
 PSR(SSP_BSY | SSP_TNF, masks[5], SSPSR, rd_1st_tx_started); 
 /* Read SSPTB Status register */
 PO(SSPTB_PCLKON | SSPTB_BSY | SSPTB_RXFE , masks[13], SSPTBSSR, TimeOut, \
    polltb_1st_tx_start);
 PSR(SSPTB_PCLKON| SSPTB_BSY | SSPTB_RXFE, masks[13],SSPTBSSR, \
     rd_ssptb_status);

 /* After two words transmission over  */
 PO(SSPTB_PCLKON | SSPTB_TXFE, masks[13], SSPTBSSR, 3*TimeOut, \
    1st_tx_complete);
 PSR(SSPTB_PCLKON | SSPTB_TXFE, masks[13], SSPTBSSR, 1st_tx_complete);

 /* Read SSP SSPRIS reg */
 PSR(0x0, MASK[2], SSPRIS, rd_sspris);

 /* Read SSP SSPMIS reg */
 PSR(0x0, MASK[2], SSPMIS, rd_sspmis);

 /* Check for SSPINTR assertion (set by Receive Time Out Interrupt) */ 
 PO(SSPTB_RTFLG | SSPTB_PCLKON | SSPTB_SSPINT | SSPTB_TXFE, masks[13], \
    SSPTBSSR, TimeOut, poll_rt_asserted);
 PSR(SSPTB_RTFLG | SSPTB_PCLKON | SSPTB_SSPINT | SSPTB_TXFE, masks[13], \
     SSPTBSSR, rd_rt_asserted);

 /* Read SSP SSPRIS reg */
 PSR(SSP_RTRIS, MASK[2], SSPRIS, rd_sspris);

 /* Read SSP SSPMIS reg */
 PSR(SSP_RTMIS, MASK[2], SSPMIS, rd_sspmis);

 /* Disable SSPTB */
 ProgramReg(0x00, SSPTBSCR0, 5);
 
 /*  Write another 2 words to the SSPTB  */
 for(i=2; i< 4 ; i++)
   ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 5);

 /* Enable SSPTB  */
 PSW(ssptb_enable_value, SSPTBSCR0, SSPTBSCR0);

 /* Write another 2 words to the SSP  */ 
 for(i=2; i< 4 ; i++)
   ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 0);

 /* During the 1st word of the 2nd transmission   */
 PO( SSP_BSY | SSP_RNE | SSP_TNF, masks[5], SSPSR, TimeOut, 2nd_tx_started);
 PSR(SSP_BSY | SSP_RNE | SSP_TNF, masks[5], SSPSR, 2nd_tx_started);
 
 /* Idle for 2 data bit periods to acount for receive time out clear latency */
 Idle(128);

 /* Check that Receive Time Out Interrupt was cleared by new reception */
 /*Read SSPTB Status register */
 PO(SSPTB_PCLKON | SSPTB_BSY,  masks[13], SSPTBSSR, TimeOut, poll_rt_deasserted);
 PSR(SSPTB_PCLKON | SSPTB_BSY,  masks[13], SSPTBSSR, rd_rt_deasserted);

 /* After the 2nd transmission is complete  */
 PO(SSPTB_PCLKON| SSPTB_TXFE| SSPTB_RXWFLG, masks[13], SSPTBSSR, 3*TimeOut, \
    poll_2nd_tx_complete);
 PSR(SSPTB_PCLKON | SSPTB_TXFE | SSPTB_RXWFLG, masks[13], SSPTBSSR, \
     rd_2nd_tx_complete);

 /* Wait for SSPINTR (set by Receive Time Out Interrupt) */ 
 PO( SSPTB_RTFLG | SSPTB_PCLKON | SSPTB_SSPINT | SSPTB_TXFE | SSPTB_RXWFLG, \
     masks[13], SSPTBSSR , 3*TimeOut, poll_rt_asserted);
 PSR(SSPTB_RTFLG | SSPTB_PCLKON | SSPTB_SSPINT | SSPTB_TXFE | SSPTB_RXWFLG, \
     masks[13], SSPTBSSR, rd_rt_asserted);

 /* Allow register synchrisation latency */
 PI(2);

 /* Read SSP SSPRIS reg */
 PSR(SSP_RTRIS, MASK[2], SSPRIS, rd_raw_rt_reg);

 /* Read SSP SSPMIS reg */
 PSR(SSP_TXMIS | SSP_RXMIS | SSP_RTMIS, MASK[2], SSPMIS,rd_msk_rt_reg);

 /* Mask the SSP RX TimeOut FIFO Interrupt */
 ProgramReg(0x0, SSPIMSC, 3);

 /*Read SSPTB Status register, check SSPTB_RTFLG and SSPTB_INT deasserted */
 PSR(SSPTB_PCLKON | SSPTB_TXFE | SSPTB_RXWFLG, masks[13], SSPTBSSR, \
     rd_rt_deasserted);

 /* Read SSP SSPRIS reg */
 PSR(SSP_TXRIS | SSP_RXRIS | SSP_RTRIS, MASK[2], SSPRIS, read_sspris);

 /* Read SSP SSPMIS reg */
 PSR(0x0, MASK[2], SSPMIS, sspmis_1);

 /* UnMask the SSP RX TimeOut FIFO Interrupt */
 ProgramReg(SSP_RTSC, SSPIMSC, 3);

 /*Read SSPTB Status register, check SSPTB_RTFLG and SSPTB_INT asserted */
 PSR(SSPTB_RTFLG | SSPTB_PCLKON | SSPTB_SSPINT | SSPTB_TXFE | SSPTB_RXWFLG, \
     masks[13], SSPTBSSR, rd_status);

 /* Read SSP SSPRIS reg */
 PSR(SSP_TXRIS | SSP_RXRIS | SSP_RTRIS, MASK[2], SSPRIS, rd_sspris);

 /* Read SSP SSPMIS reg */
 PSR(SSP_TXMIS | SSP_RXMIS | SSP_RTMIS, MASK[2], SSPMIS, td_sspmis);

 /* Write to the SSPICR RTIC bit to clear the Receive Timeout interrupt */
 PSW(SSP_RTIC ,SSPICR, wrt_rtic);
 
 /* Wait for SSPINTR to be cleared */
 PO( SSPTB_PCLKON | SSPTB_TXFE | SSPTB_RXWFLG, masks[13], SSPTBSSR, TimeOut, \
     poll_sspintr_deassertion);
 PSR(SSPTB_PCLKON | SSPTB_TXFE | SSPTB_RXWFLG, masks[13], SSPTBSSR, \
     rd_sspintr_deassaertion);

 /* Allow for propagation back through through the SSPCLK domain */
 PI(128);

 /* Read SSP SSPRIS reg */
 PSR(0x0, MASK[2], SSPRIS, rd_sspris);

 /* Read SSP SSPMIS reg */
 PSR(0x0, MASK[2], SSPMIS, rd_sspmis);
    
 /* Read and compare the 4 data words */
 for(i=0; i< 4 ; i++)
 {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength], SSPDR, rd_ssp_rxfifo);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength], SSPTBSRDR, \
   rd_ssptb_rxfifo); 
 }

 /* Wait for SSPINTR de-assertion due to RX FIFO empty */
 PO( SSPTB_PCLKON | SSPTB_TXFE | SSPTB_RXFE, masks[13], SSPTBSSR, TimeOut , \
 poll_sspintr_deassertion);
 PSR(SSPTB_PCLKON | SSPTB_TXFE | SSPTB_RXFE, masks[13], SSPTBSSR, \
     rd_sspintr_deassertion);

 /* Read SSP SSPRIS reg */
 PSR(0x0, MASK[2], SSPRIS, rd_sspris);

 /* Read SSP SSPMIS reg */
 PSR(0x0, MASK[2], SSPMIS, rd_sspmis);

 /* Read SSP SSPRIS reg */
 PSR(0x0, MASK[2], SSPRIS, rd_sspris);

 /* Read SSP SSPMIS reg */
 PSR(0x0, MASK[2], SSPMIS, rd_sspmis);

 /* Read SSP status register */ 
 PO(SSP_TNF | SSP_TFE, masks[5], SSPSR, TimeOut, poll_ssp_status);
 PSR(SSP_TNF | SSP_TFE, masks[5], SSPSR, rd_ssp_status);
 PSR(SSPTB_PCLKON | SSPTB_TXFE | SSPTB_RXFE, masks[13], SSPTBSSR, \
     rd_ssptb_status);

 /* Disable SSP and SSPTB */
 ProgramReg(0x0,  SSPCR1,    5);
 ProgramReg(0x00, SSPTBSCR0, 5);

 C(" SPI01 RTIS test over ");

}/* End Function */
