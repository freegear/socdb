/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : Sci_DMA_TX_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function DMATests which is called in
   the main file Sci.c
/******************************************************************************/

/******************************************************************************/
/************************* DMA Tests ** **************************************/
/******************************************************************************/

void Dma_Tx_Test(void)
{
  /*
  Summary: DMA Tests
  ===================
  These tests test the DMA  using the FIFO test mode logic.
  The initial state of the requests are checked, then some data written to the
  fifos.
  The requests are checked for correct setting and clearing for single data
  transfers and burst transfers. 
  The DMACLR signal is checked by writing to the trickbox.
  */
  

  int i,j, reg_val;
 
  C("DMA Test");

  C("DMA: Tx - burst mode");

  /* Enable the trickbox, set the nSCIRST high */
  PSW(0x2001,SCITrCR);

  /* Program the TXTIDE level to halfway*/
  PSW(0x04, SCITIDE);
 
  /* Program the SCI in TX MODE */
  PSW(0x04, SCICR1); 

  /* Enable SCI Test FIFO mode */
  PSW(0x2, SCITCR);

  /* Enable the Tx FIFO interrupt */
  PSW(0x4000, SCIIMSC);
  
  /* Enable the SCI Transmit DMA  */
  PSW(0x2,SCIDMACR);
  PI(2);

  /* Check Tx DMA Single and Burst Request lines via the Trickbox  
     SCITrDMA register */
  PSR(0x30, 0x3F, SCITrDMA, );

  /* Write 7 words to the transmit fifo. This is done in 1 bursts and 3 single
     transfers. The requests are cleared after each burst and while there is
     still at least one burst length or more space in the fifo both requests are
     reasserted, then just the single request is reasserted. */

 for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, SCIDATA);
      if (i == 3)
	{
	  PSW(0x2,SCITrDMA);
	  PI(0x04);
	  PSR(0x00, 0x3F, SCITrDMA, );
	  PI(0x04);
	  PSR(0x30, 0x3F, SCITrDMA, );	  
	}  
	else
	  { 
	    PSR(0x30, 0x3F, SCITrDMA, );
	  }	
    }

 for(i = 4; i < 7; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, SCIDATA);
      PSW(0x2,SCITrDMA);
      PI(0x04);
      PSR(0x00, 0x3F, SCITrDMA,);
      PI(0x04);
      PSR(0x20, 0x3F, SCITrDMA,);	  
    }

 
  /* Read out 1 word at a time and check that the burst request is only set after 3
     words have been read out. Then disable DMA and check it is cleared. Enable
     it again and check it is reasserted. then empty fifo and check requests are
     set.*/
    
   for(i = 0; i < 5; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xFF, SCITDR,);
      PI(0x05);
      if (i < 2)
	{
	  PSR(0x20, 0x3F, SCITrDMA,);
	}
      else
	{
	  PSR(0x30, 0x3F, SCITrDMA,);
	}  
    }

   /* Disable TX DMA */
  PSW(0x00,SCIDMACR);
  PI(2)
  PSR(0x00, 0x3F, SCITrDMA,);
  PI(2);

  /* Enable TX DMA */
  PSW(0x2,SCIDMACR);
  PI(2)
  PSR(0x30, 0x3F, SCITrDMA,);
  PI(2);  

  for(i = 5; i < 7; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xFF, SCITDR,);
      PI(0x02);
      PSR(0x30, 0x3F, SCITrDMA,);
      PI(2);
    }

  /* Disable SCI Test FIFO mode */
  PSW(0x0, SCITCR);

  /* Disable the trickbox, keeping nSCIRST high */
  PSW(0x2000,SCITrCR);

}
