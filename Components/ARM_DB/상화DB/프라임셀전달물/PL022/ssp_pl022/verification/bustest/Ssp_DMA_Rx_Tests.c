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
--  File Name              : Ssp_DMA_Rx_Tests.c.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function DMATests which is called in
   the main file Ssp.c
/******************************************************************************/

/******************************************************************************/
/************************* DMA Tests ** **************************************/
/******************************************************************************/

void DMA_Rx_Tests(void)
{
  int i,j, reg_val;

  C("DMA: Rx - burst mode");
   
   /* Enable the Receive DMA */
   PSW(SSP_RXDMAE, SSPDMACR);  
   PI(2);

   /* Enable Test FIFO mode */
   PSW(SSP_TESTFIFO, SSPTCR);
   PI(2);

   /* Check that the Rx single and burst DMA requests are de-asserted */ 
   PSR(0x00, MASK_SSPTB_DMACR, SSPTBDMACR, ssptdmacr_rx1);
   PSR(SSP_TFE | SSP_TNF, MASK_SSPSR, SSPSR, tx_rx_fifos_empty);

  /* Write 7 words to the Rx Fifo. When there are less than 4 words in the FIFO
   only the single request will be set. After that, both requests will be set. */ 
  for(i = 0; i < 7; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, SSPTDR);
      PI(0x04);
      if (i < 3)
      {
	PSR(SSPTB_RXDMASREQ, MASK_SSPTB_DMACR, SSPTBDMACR, sspdmacr_rx2);	  
      }
      else
	PSR(SSPTB_RXDMASREQ | SSPTB_RXDMABREQ, MASK_SSPTB_DMACR, SSPTBDMACR, ssptdmacr_rx3);	  

    }

  /* The DMA controller would service the burst request - the data is read out 4
     words at a time until there are less than 4 left and then it is read out in
     single transfers */
  
  for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, MASK_SSPDR, SSPDR, dma_rx_read1);
      PI(0x04);
      if (i == 3)
      {
        /* Clear the RX DMA Request */
	PSW(SSPTB_RXDMACLR, SSPTBDMACR);
	PI(4); /* was 2 */
	PSR(0x00, MASK_SSPTB_DMACR, SSPTBDMACR, ssptdmacr_rx4);
	PI(4);
	PSR(SSPTB_RXDMASREQ, MASK_SSPTB_DMACR , SSPTBDMACR, ssptdmacr_rx5);	  
      }
      else
	PSR(SSPTB_RXDMASREQ | SSPTB_RXDMABREQ, MASK_SSPTB_DMACR , SSPTBDMACR, ssptdmacr_rx6);
    }
 
      
   for(i = 4; i < 6; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, MASK_SSPDR, SSPDR,dma_rx_read2);
      PI(0x02);
      PSW(0x02, SSPTBDMACR);
      PI(4); /* was 2 */
      PSR(0x00, MASK_SSPTB_DMACR, SSPTBDMACR, sspdmacr_rx7);
      PI(4);
      PSR(SSPTB_RXDMASREQ, MASK_SSPTB_DMACR, SSPTBDMACR,sspdmacr_rx8);	  
    }

   for(i = 6; i < 7; i++)   
    {
      reg_val = i | (i << 4);
      PSR(reg_val, MASK_SSPDR, SSPDR,dma_rx_read3);
      PI(0x02);
      PSW(0x02, SSPTBDMACR);
      PI(4); /* was 2 */
      PSR(0x00, MASK_SSPTB_DMACR, SSPTBDMACR,sspdmacr_rx9);
      PI(4);
      PSR(0x00, MASK_SSPTB_DMACR, SSPTBDMACR,sspdmacr_rx10);	  
    }

/*  Write 4 words in to cause burst request. Disable DMA and check that the
    requests are cleared. Enable it again and check they are reasserted. then
    empty fifo  */ 
 
   for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, SSPTDR);
      PI(0x04);
      if(i == 3)
	PSR(SSPTB_RXDMASREQ | SSPTB_RXDMABREQ, MASK_SSPTB_DMACR, SSPTBDMACR,sspdmacr_rx11);
      else
	PSR(SSPTB_RXDMASREQ, MASK_SSPTB_DMACR, SSPTBDMACR,sspdmacr_rx12);
    }
   
   PSW(0x00,SSPDMACR);  
   PI(2);
   PSR(0x00, MASK_SSPDMACR, SSPDMACR,sspdmacr_rx13);
   PI(2);

   PSW(SSP_RXDMAE,SSPDMACR); 
   PI(2);
   PSR(SSPTB_RXDMABREQ |SSPTB_RXDMASREQ , MASK_SSPTB_DMACR, SSPTBDMACR,ssptdmacr_rx14);
   PI(2);

   PSW(0x02,SSPTBDMACR);
   PI(2);

   /* Empty Fifo */
   for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, MASK_SSPDR, SSPDR,dma_rx_read4);
      PI(0x02);
      PSW(0x02,SSPTBDMACR);
      PI(4); /* was 2 */
      PSR(0x00, MASK_SSPTB_DMACR, SSPTBDMACR, ssptdmacr_rx15);
    }

  /* Disable Test FIFO mode */
  PSW(0x0, SSPTCR);
  PI(2);

  /* Disable the SSP */
  ProgramReg(0x0, SSPCR1, 5);
  /* Disable the Trickbox */
  ProgramReg(0x00, SSPTBSCR0, 5);

}


