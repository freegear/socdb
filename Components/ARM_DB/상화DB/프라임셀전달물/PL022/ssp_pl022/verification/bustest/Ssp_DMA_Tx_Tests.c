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
--  File Name              : Ssp_DMA_Tx_Tests.c.rca
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

void DMA_Tx_Tests(void)
{
  /*
  Summary: DMA Tests
  ===================
  These tests test the DMA logic.
  The initial state of the requests are checked, then some data written to the
  fifos.
  The requests are checked for correct setting and clearing for single data
  transfers and burst transfers. 
  The DMACLR signal is checked by writing to the trickbox.
  The DMAONERR logic is checked by generating an error via the trickbox and
  checking that the requests are not set.
  */
  

  int i,j, reg_val;
 
  C("DMA Test");

  /* Disable the SSP */
  ProgramReg(0x0, SSPCR1, 5);
  /* Disable the Trickbox */
  ProgramReg(0x00, SSPTBSCR0, 5);

  C("DMA: Tx - burst mode");

  /* Enable SSP Test FIFO mode */
  PSW(SSP_TESTFIFO, SSPTCR);

  /* Enable the Tx FIFO interrupt */
  PSW(SSP_TXSC, SSPIMSC);
  
  /* Enable the SSP Transmit DMA  */
  PSW(SSP_TXDMAE,SSPDMACR);
  PI(2);

  /* Check Tx DMA Single and Burst Request lines via the Trickbox  
     SSPTBDMACR register */
  PSR(SSPTB_TXDMABREQ|SSPTB_TXDMASREQ, MASK_SSPTB_DMACR, SSPTBDMACR, ssptdmacr_tx1);
  PI(2);

  /* Write 7 words to the transmit fifo. This is done in 1 bursts and 3 single
     transfers. The requests are cleared after each burst and while there is
     still at least one burst length or more space in the fifo both requests are
     reasserted, then just the single request is reasserted. */

 for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, SSPDR);
      if (i == 3)
	{
	  PSW(0x01,SSPTBDMACR);
	  PI(0x04); /* was 0x02 */
	  PSR(0x00, MASK_SSPTB_DMACR, SSPTBDMACR, ssptdmacr_tx2);
	  PI(0x04);
	  PSR(SSPTB_TXDMABREQ|SSPTB_TXDMASREQ, MASK_SSPTB_DMACR, SSPTBDMACR,ssptdmacr_tx3);	  
	}  
	else
	  { 
	    PSR(SSPTB_TXDMABREQ|SSPTB_TXDMASREQ, MASK_SSPTB_DMACR, SSPTBDMACR,ssptdmacr_tx4);
	  }	
    }

 for(i = 4; i < 7; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, SSPDR);
      PSW(0x01,SSPTBDMACR);
      PI(0x04); /* was 0x02 */
      PSR(0x00, MASK_SSPTB_DMACR, SSPTBDMACR,ssptdmacr_tx5);
      PI(0x04);
      PSR(SSPTB_TXDMASREQ, MASK_SSPTB_DMACR, SSPTBDMACR,ssptdmacr_tx6);	  
    }

 
  /* Read out 1 word at a time and check that the burst request is only set after 3
     words have been read out. Then disable DMA and check it is cleared. Enable
     it again and check it is reasserted. then empty fifo and check requests are
     set.*/
    
   for(i = 0; i < 5; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, MASK_SSPTDR, SSPTDR,readtxfifo_1);
      PI(0x05);
      if (i < 2)
	{
	  PSR(SSPTB_TXDMASREQ, MASK_SSPTB_DMACR, SSPTBDMACR,ssptdmacr_tx8);
	}
      else
	{
	  PSR(SSPTB_TXDMABREQ|SSPTB_TXDMASREQ, MASK_SSPTB_DMACR, SSPTBDMACR,ssptdmacr_tx9);
	}  
    }


  PSW(0x00,SSPDMACR);
  PI(2)
  PSR(0x00, MASK_SSPTB_DMACR, SSPTBDMACR,ssptdmacr_tx10);
  PI(2);

  PSW(SSP_TXDMAE,SSPDMACR);
  PI(2)
  PSR(SSPTB_TXDMABREQ|SSPTB_TXDMASREQ, MASK_SSPTB_DMACR, SSPTBDMACR,sspdmacr_tx11);
  PI(2);  

  for(i = 5; i < 7; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, MASK_SSPTDR, SSPTDR,readtx);
      PI(0x02);
      PSR(SSPTB_TXDMABREQ|SSPTB_TXDMASREQ, MASK_SSPTB_DMACR, SSPTBDMACR,ssptdmacr_tx12);
      PI(2);
    }

  /* Enable SSP Test FIFO mode */
  PSW(0x0, SSPTCR);

  /* Disable the SSP */
  ProgramReg(0x0, SSPCR1, 5);
  /* Disable the Trickbox */
  ProgramReg(0x00, SSPTBSCR0, 5);

}
