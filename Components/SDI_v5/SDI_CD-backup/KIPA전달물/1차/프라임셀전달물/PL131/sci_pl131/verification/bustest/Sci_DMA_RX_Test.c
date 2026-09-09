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
--  File Name              : Sci_DMA_RX_Test.c.rca
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

void DMA_Rx_Test(void)
{
  int i,j, reg_val;
 
  C("DMA Test");

  C("DMA: Rx - burst mode");
   
  /* Enable the trickbox, set the nSCIRST high */
  PSW(0x2001,SCITrCR);
 
  /* Program the RXTIDE level to halfway*/
  PSW(0x40, SCITIDE);
 
  /* Program the SCI in RX MODE */
  PSW(0x00, SCICR1); 

  /* Enable SCI Test FIFO mode */
  PSW(0x2, SCITCR);

  /* Enable the Rx FIFO interrupt */
  PSW(0x2000, SCIIMSC);
  
  /* Enable the SCI Receive DMA  */
  PSW(0x1,SCIDMACR);
  PI(2);

  /* Check that the Rx single and burst DMA requests are de-asserted */ 
  PSR(0x00, 0x3F, SCITrDMA, );
  PI(2);

  /* Write 7 words to the Rx Fifo. 
     When there are less than 4 words in the FIFO only the single request 
     will be set. 
     After that, both requests will be set. */ 

  for(i = 0; i < 7; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, SCITDR);
      PI(0x04);
      if (i < 3)
      {
	PSR(0x08, 0x3F, SCITrDMA, );	  
      }
      else
	PSR(0x0C, 0x3F, SCITrDMA, );	  

    }

  /* The DMA controller would service the burst request - the data is read out 4
     words at a time until there are less than 4 left and then it is read out in
     single transfers */
  
  for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0x3FF, SCIDATA, );
      PI(0x04);
      if (i == 3)
      {
        /* Clear the RX DMA Request */
	PSW(0x1, SCITrDMA);
	PI(4); 
	PSR(0x00, 0x3F, SCITrDMA, );
	PI(4);
	PSR(0x08, 0x3F , SCITrDMA, );	  
      }
      else
	PSR(0x0C, 0x3F , SCITrDMA, );
    }
 
      
   for(i = 4; i < 6; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0x3FF, SCIDATA,);
      PI(0x02);
      PSW(0x01, SCITrDMA);
      PI(4); 
      PSR(0x00, 0x3F, SCITrDMA, );
      PI(4);
      PSR(0x08, 0x3F, SCITrDMA, );	  
    }

   for(i = 6; i < 7; i++)   
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0x3FF, SCIDATA,);
      PI(0x02);
      PSW(0x01, SCITrDMA);
      PI(4); 
      PSR(0x00, 0x3F, SCITrDMA, );
      PI(4);
      PSR(0x00, 0x3F, SCITrDMA, );	  
    }

/*  Write 4 words in to cause burst request. Disable DMA and check that the
    requests are cleared. Enable it again and check they are reasserted. then
    empty fifo  */ 
 
   for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, SCITDR);
      PI(0x04);
      if(i == 3)
	PSR(0x0C, 0x3F, SCITrDMA, );
      else
	PSR(0x08, 0x3F, SCITrDMA,);
    }
   
   PSW(0x00,SCIDMACR);  
   PI(2);
   PSR(0x00, 0x3F, SCIDMACR,);
   PI(2);

   PSW(0x1,SCIDMACR); 
   PI(2);
   PSR(0x0C , 0x3F, SCITrDMA,);
   PI(2);

   PSW(0x01,SCITrDMA);
   PI(2);

   /* Empty Fifo */
   for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0x3FF, SCIDATA,);
      PI(0x02);
      PSW(0x01,SCITrDMA);
      PI(4);
      PSR(0x00, 0x3F, SCITrDMA,);
    }

  /* Disable Test FIFO mode */
  PSW(0x0, SCITCR);
  PI(2);

  /* Disable the trickbox, keeping nSCIRST high */
  PSW(0x2000,SCITrCR);

}
