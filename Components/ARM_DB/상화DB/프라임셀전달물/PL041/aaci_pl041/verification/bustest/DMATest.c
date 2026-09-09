/* --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- --------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : DMATest.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
--  Purpose :
--            This section of the code tests the all DMA Receive and  
--            Transmmit request functionality.  
--
-- --=================================================================*/

/**********************************************************************/
/************************* Function declarations **********************/
/**********************************************************************/

void DMASREQRXWTTest(int32 ChModeSizeFen, int32 ChValidSlot);

void DMASREQRXTest(int32 ChModeSizeFen, int32 ChValidSlot);  

void DMALBREQRXTest(int32 ChModeSizeFen);

void DMABREQRXWTTest(int32 ChModeSizeFen, int32 ChValidSlot);

void DMABREQTXTest(int32 ChModeSizeFen, int32 ChValidSlot); 

void DMALSREQRXTest(int32 ChModeSizeFen);

void DMABREQRXTest(int32 ChModeSizeFen, int32 ChValidSlot);

void DMALSChar(int32 ChModeSizeFen);

void DMADisableTest(int32 ChModeSizeFen, int32 ChValidSlot);

void DMAACIFEDisable(int32 ChModeSizeFen, int32 ChValidSlot);

/**********************************************************************/
/********************** DMA Test **************************************/
/**********************************************************************/
void DMATest(void)
{
 /*
   Summary: DMA Test
   =================
   The function calls various DMA request functions. 
   Each DMA Request is called with different RSIZE or TSIZE values in
   Compact Mode and Non Compact Mode. The DMASREQRXTest function checks 
   functionality of DMA Single Receive Request in Compact Mode, Non
   Compact Mode and Character mode without RX timeout. The 
   DMASREQRXWTTest checks functionality of DMA Single Receive Request 
   in Compact Mode and Non Compact Mode with RX Timeout Condition. The
   DMALSREQRXTest function checks functionality of DMA Last Receive
   Request in Compact Mode and Non Compact Mode. The DMABREQRXTest 
   function checks functionality of DMA Burst Receive Request in 
   Compact Mode and Non Compact Mode without RX Timeout. The
   DMABREQRXWTTest checks functionality of DMA Burst Request in FIFO 
   mode with RX Timeout. The DMALBREQRXTest function checks 
   functionality of DMA Last Burst Receive Request in FIFO mode. The
   DMABREQTXTest checks functionality of DMA Burst Transmit Request.
   The DMADisableTest function checks effect on DMA request signal 
   with DMAEnable bit is disabled. The DMALSChar function checks
   functionality of DMA Last Single Receive Request in Character Mode.
   The DMAACIFEDisable checks effect on DMA request when AACIFE bit 
   is disabled in FIFO mode.  

 */
  
 int One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 int i, ValidSlots;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
   {
    One_BitClk_Period = 1;
   }

 C("START OF DMA TEST "); 

 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 C("DMA SINGLE RECEIVE REQUEST TEST IN COMPACT MODE ");
 /* Use different combinations of valid slots in the frame */
 for (i = 1; i < 3; i++)
   {
    /* Select valid slots */
    ValidSlots = SlotArr[i] | SlotArr[i+1];

    DMASREQRXTest(AACI_TSIZE12 | AACI_CM | AACI_FEN, ValidSlots);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    
    DMASREQRXTest(AACI_TSIZE16 | AACI_CM | AACI_FEN, ValidSlots);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   }

 C("DMA SINGLE RECEIVE REQUEST TEST IN NON COMPACT MODE "); 
 for (i = 3; i < 5; i++)
   {
    DMASREQRXTest(AACI_TSIZE12 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    
    DMASREQRXTest(AACI_TSIZE16 | AACI_FEN , SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   
    DMASREQRXTest(AACI_TSIZE18 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   
    DMASREQRXTest(AACI_TSIZE20 | AACI_FEN , SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   }

 C("DMA SINGLE RECEIVE REQUEST TEST IN CHARACTER MODE "); 
 for (i = 5; i < 7; i++)
   {
    DMASREQRXTest(AACI_TSIZE12  ,SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
     
    DMASREQRXTest(AACI_TSIZE16 , SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    
    DMASREQRXTest(AACI_TSIZE18, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    
    DMASREQRXTest(AACI_TSIZE20 , SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   }

 C("DMA LAST SINGLE RECEIVE REQUEST TEST IN COMPACT MODE ");

 DMALSREQRXTest(AACI_TSIZE12 | AACI_CM | AACI_FEN);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  
 DMALSREQRXTest(AACI_TSIZE16 | AACI_CM | AACI_FEN);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 C("DMA LAST SINGLE REQUEST TEST IN NON COMPACT MODE "); 
 DMALSREQRXTest(AACI_TSIZE12 | AACI_FEN);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  
 DMALSREQRXTest(AACI_TSIZE16 | AACI_FEN);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 DMALSREQRXTest(AACI_TSIZE18 | AACI_FEN);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 DMALSREQRXTest(AACI_TSIZE20 | AACI_FEN);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);   

 C("DMA SINGLE RECEIVE REQUEST TEST IN COMPACT MODE IN TIMEOUT ");
 for (i = 4; i < 6; i++)
   {
    /* Select valid slots */
    ValidSlots = SlotArr[i] | SlotArr[i+1];

    DMASREQRXWTTest(AACI_TSIZE12 | AACI_CM | AACI_FEN, ValidSlots);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    
    DMASREQRXWTTest(AACI_TSIZE16 | AACI_CM | AACI_FEN, ValidSlots);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   }
 
 C("DMA SINGLE RECEIVE REQUEST TEST IN NON COMPACT MODE WITH TIMEOUT ");
for (i = 8; i < 10; i++) 
   {
    DMASREQRXWTTest(AACI_TSIZE12 |AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
     
    DMASREQRXWTTest(AACI_TSIZE16 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    
    DMASREQRXWTTest(AACI_TSIZE18 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    
    DMASREQRXWTTest(AACI_TSIZE20 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   }

 C("DMA BURST RECEIVE REQUEST TEST IN COMPACT MODE ");
 for (i = 10; i < 12; i++)
   {
    /* Select valid slots */
    ValidSlots = SlotArr[i] | SlotArr[i+1];

    DMABREQRXTest(AACI_TSIZE12 | AACI_CM | AACI_FEN, ValidSlots);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    
    DMABREQRXTest(AACI_TSIZE16|AACI_CM|AACI_FEN, ValidSlots);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   }

 C("DMA BURST RECEIVE REQUEST TEST IN NON COMPACT MODE ");  
 for (i = 1; i < 3; i++)
   {
    DMABREQRXTest(AACI_TSIZE12 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
     
    DMABREQRXTest(AACI_TSIZE16 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    
    DMABREQRXTest(AACI_TSIZE18 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    
    DMABREQRXTest(AACI_TSIZE20 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   }

 C("DMA LAST BURST RECEIVE REQUEST TEST IN COMPACT MODE ");

 DMALBREQRXTest(AACI_TSIZE12 | AACI_CM | AACI_FEN);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
  
 DMALBREQRXTest(AACI_TSIZE16 | AACI_CM | AACI_FEN);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 C("DMA LAST BURST REQUEST TEST IN NON COMPACT MODE ");

 DMALBREQRXTest(AACI_TSIZE12 | AACI_FEN);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 DMALBREQRXTest(AACI_TSIZE16 | AACI_FEN);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 DMALBREQRXTest(AACI_TSIZE18 | AACI_FEN);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 DMALBREQRXTest(AACI_TSIZE20 | AACI_FEN);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 C("DMA BURST RECEIVE REQUEST TEST IN COMPACT MODE WITH TIMEOUT");
 for (i = 9; i < 11; i++)
   {
    /* Select valid slots */
    ValidSlots = SlotArr[i] | SlotArr[i+1];

    DMABREQRXWTTest(AACI_TSIZE12 | AACI_CM | AACI_FEN, ValidSlots);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
     
    DMABREQRXWTTest(AACI_TSIZE16 | AACI_CM | AACI_FEN, ValidSlots);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   }
 

 C("DMA BURST RECEIVE REQUEST TEST IN NON COMPACT MODE WITH TIMEOUT ");
 for (i = 10; i < 13; i++)
   {
    DMABREQRXWTTest(AACI_TSIZE12 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
     
    DMABREQRXWTTest(AACI_TSIZE16 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    
    DMABREQRXWTTest(AACI_TSIZE18 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    
    DMABREQRXWTTest(AACI_TSIZE20 | AACI_FEN , SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   }


 C("DMA BURST TRANSMIT REQUEST TEST IN COMPACT MODE ");   

 /* NOTE : As SLOT2 can't be transmitted independently, i = 2 is invalid
           combination.
 */   

 for (i = 3; i < 5; i++)
   {
    /* Select valid slots */
    ValidSlots = SlotArr[i] | SlotArr[i+1];

    DMABREQTXTest(AACI_TSIZE12 | AACI_CM | AACI_FEN , ValidSlots);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   
    DMABREQTXTest(AACI_TSIZE16 | AACI_CM | AACI_FEN, ValidSlots);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   }
 
 C("DMA BURST TRANSMIT REQUEST TEST IN NON COMPACT MODE "); 

 /* NOTE : As SLOT2 can't be transmitted independently, i = 2 is invalid
           combination.   
 */

 for (i = 6; i < 8; i++)
   {
    DMABREQTXTest(AACI_TSIZE12 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   
    DMABREQTXTest(AACI_TSIZE16 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   
    DMABREQTXTest(AACI_TSIZE12 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   
    DMABREQTXTest(AACI_TSIZE16| AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   }

 C("DMA DISABLE TEST IN COMPACT MODE ");
 for (i = 1; i < 3; i++)
   {
    /* Select valid slots */
    ValidSlots = SlotArr[i] | SlotArr[i+1];

    DMADisableTest(AACI_TSIZE12 | AACI_CM | AACI_FEN, ValidSlots);  
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
    DMADisableTest(AACI_TSIZE16 | AACI_CM | AACI_FEN, ValidSlots);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   }

 C("DMA DISABLE TEST IN NON COMPACT MODE ");
 for (i = 6; i < 8; i++)
   {
    DMADisableTest(AACI_TSIZE12 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
    DMADisableTest(AACI_TSIZE16 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
    DMADisableTest(AACI_TSIZE12 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
    DMADisableTest(AACI_TSIZE16| AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   }

 C("DMALSREQ WITH DMA DISABLE CONDITION ");

 DMALSChar(AACI_TSIZE12);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 DMALSChar(AACI_TSIZE16);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 DMALSChar(AACI_TSIZE18);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 DMALSChar(AACI_TSIZE20);
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 PI(One_BitClk_Period * 16);
 PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 C("DMA TEST WITH AACIFE DISABLED "); 

 for (i = 4; i < 6; i++)
   {
    DMAACIFEDisable(AACI_TSIZE12 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    
    DMAACIFEDisable(AACI_TSIZE16 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    
    DMAACIFEDisable(AACI_TSIZE12 | AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    
    DMAACIFEDisable(AACI_TSIZE16| AACI_FEN, SlotArr[i]);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   }
 for (i = 3; i < 5; i++)
   {  
    ValidSlots = SlotArr[i] | SlotArr[i+1];
    DMAACIFEDisable(AACI_TSIZE12 | AACI_CM | AACI_FEN, ValidSlots);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    
    DMAACIFEDisable(AACI_TSIZE16 | AACI_CM | AACI_FEN, ValidSlots);
    PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
    PI(One_BitClk_Period * 16);
    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
   }

 C("END OF DMA TEST ");
}

/**********************************************************************/
/**************** DMA Single Receive Request **************************/
/**********************************************************************/
void DMASREQRXTest(int32 ChModeSizeFen, int32 ChValidSlot) 
{
 /*
   Summary: DMASREQRX Test
   =======================
   This function tests DMA Single Receive Request functionality.
   Following  steps are performed :

   o  Trickbox TX FIFO is filled with required amount of data to be
      transmitted according to Compact or Non Compact mode and FIFO
      mode 0r Character mode.

   o  Enable Trickbox and AACI Transmission and Reception.

   o  Poll Trickbox Tx Fill level such that it should indicate 
      transmission of required valid Slot. 

   o  When expected fill level is reached for each frame, check  
      DMASREQRX and DMABREQRX requests for set or clear according
      to fill level of Rx FIFO of AACI.

   o  Repeat until last frame is transmitted.

   o  Disable Trickbox and AACI Transmission and Reception.

   o  Read Received Data and compare with expected data. After 
      each read, check DMASREQRX and DMABREQRX.

   o  Assert and Deassert DMACLRRX Signal and once again check
      DMASREQRX and DMABREQRX Request for desired status.

   o  Repeat the last 2 steps until Rx FIFO fill level reaches zero.
 */
  
 int32 Mode, RSize, Fen, Size;
 int   One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 int   SlotFill=0 , i;
 int32 SlotMask = 0x02;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x2;

 /* Extract Compact Mode information */
 Mode  = ChModeSizeFen & MASK_MODE;

 /* Extract RSIZE information */
 RSize = ChModeSizeFen & MASK_TSIZE;
 Size  = RSize >> 13;

 /* Extract FIFO Enable information */
 Fen   = ChModeSizeFen & AACI_FEN;

 C("START OF DMA SINGLE RECEIVE REQUEST TEST ");
 /* Compute the point at which the DMA request is to be checked based
    on the fill level */
 for (i = 1; i < 13; i++) 
   {
    if (ChValidSlot & SlotMask)
       SlotFill = i;
    SlotMask = SlotMask << 1 ;
   }
 SlotFill = SlotFill << 16;

 /* Enable AACIFE & DMA Enable bit */
 PSW(AACI_AACIIFE | AACI_DMAEN, AACIMAINCR);

 /* Configure AACIRXCR1 for required number of Slots */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen);

 /* Verify that DMASREQRX is set */
 PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASR_1);

 if (Fen != AACI_FEN)
   {
    C("FILL TRICKBOX TX FIFO WITH 1 FRAME ");
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
    FrameWrite(Channel_1, 0x80000, Mode | RSize);
   }
 else
   {
    C("FILL TRICKBOX TX FIFO WITH 4 FRAMES ");
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
   }

 /* Enable Trickbox Transmission and AACI Reception */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | AACI_REN);
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_TxEn | AACITB_BtClkRst, AACITrCntlReg);

 C("TRANSMISSION AND RECEPTION ENABLED ");

 if (Fen == AACI_FEN )
   {
    /* Poll for Trickbox Tx FIFO fill level for end of valid slots
       in 1st frame transmission */
    PO(AACITB_TxFFillLevel52 - SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMASR_2);
   
    C("FIRST FRAME VALID SLOTS TRANSMITTED ");
   
    /* Verify that DMASREQRX is set */
    if (Mode != AACI_CM )
      PO(AACI_DMASREQRX,AACI_DMASREQRX,AACITrDMAReg,40*One_BitClk_Period,DMASR_2); 
   
    /* Poll for Trickbox Tx FIFO fill level for end of valid slots
       in 2nd frame transmission */
    PO(AACITB_TxFFillLevel39 - SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMASR_3);
   
    C("SECOND FRAME VALID SLOTS TRANSMITTED ");
   
    /* Verify that DMASREQRX is set */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMASR_4);
   
    /* Poll for Trickbox Tx FIFO fill level for end of valid slots
       in 3rd frame transmission */
    PO(AACITB_TxFFillLevel26- SlotFill,MASK_TxFFFillLevel,AACITrFIFOStat, 512 * One_BitClk_Period,DMASR_5 );
   
    C("THIRD FRAME VALID SLOTS TRANSMITTED ");

    /* Verify that DMASREQRX is set */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMASR_6);
   
    if (Mode != AACI_CM )
      {
       C("WRITE TWO FRAME IN TRICKBOX TX FIFO ");
       FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
       FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
    
       /* Poll for Trickbox Tx FIFO fill level for end of valid slots
          in 4th frame transmission */
       if (PCLK_PERIOD > AACIBITCLK_PERIOD )
         PO(AACITB_TxFFillLevel26 ,MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMASR_7);
       else
         PO(AACITB_TxFFillLevel39 - SlotFill,MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMASR_8);
   
       C("FOURTH FRAME VALID SLOTS TRANSMITTED ");
   
       /* Verify that DMASREQRX and DMABREQRX are set */
   
       PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg, AACI3_T969);
       PO(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,40 * One_BitClk_Period,DMASR_9);
       PI(0x01);
   
       /* Poll for Trickbox Tx FIFO fill level for end of valid slots
          in 5th frame transmission */
       if (PCLK_PERIOD > AACIBITCLK_PERIOD )
          PO(AACITB_TxFFillLevel13 ,MASK_TxFFFillLevel, AACITrFIFOStat, 512*One_BitClk_Period ,DMAS_10);
       else
         PO(AACITB_TxFFillLevel26 - SlotFill,MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMAS_11);
   
       C("FIFTH FRAME VALID SLOTS TRANSMITTED ");
   
       /* Verify that DMASREQRX and DMABREQRX are set */
       PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg, DMAS_12);
       PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg, DMAS_13);
      } /* end of if, for Non Compact Node */
    PI(0x01);
   
    /* Write One valid Frame */
    FrameWrite(Channel_1, 0x80000, Mode | RSize);
   } /* End of if, for FIFO Mode */ 
 /* Poll for Trickbox Tx FIFO fill level for end of valid slots
    in last frame transmission */
 if (PCLK_PERIOD > AACIBITCLK_PERIOD )
    PO(AACITB_TxFFillLevel13,MASK_TxFFFillLevel,AACITrFIFOStat, 512 * One_BitClk_Period,DMAS_14);
 else
   PO(AACITB_TxFFillLevel26 - SlotFill,MASK_TxFFFillLevel,AACITrFIFOStat, 512 * One_BitClk_Period,DMAS_15);

 C(" LAST FRAME VALID SLOTS TRANSMITTED ");

 if (Fen == AACI_FEN )
   {
    /* Verify that DMASREQRX and DMABREQRX are set */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMAS_16);
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMAS_17);
   }
 else
   {
    /* Verify that DMASREQRX is set and DMABREQRX is cleared */
    PO(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,40 * One_BitClk_Period,DMAS_18);
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMAS_19);
   }

 PO(AACITB_TxFFillLevel0,MASK_TxFFFillLevel,AACITrFIFOStat, 256 *           One_BitClk_Period,DMASR_20);

 PI(20*One_BitClk_Period); 

 /* Disable Trickbox Transmission and AACI Reception */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen);
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);

 C("TRANSMISSION AND RECEPTION IS DISABLED ");

 /* Read Rx FIFO of AACI one by one. After each read assert 
    DMACLRRX signal and check for AACI_DMASREQRX & AACI_DMABREQRX */  
 if (Fen == AACI_FEN)
   {
    C(" READ FIRST FRAME ");
   
    RxFIFORd(Channel_1,ChValidSlot, ChModeSizeFen);
   
    /* Verify DMASREQRX and DMABREQRX are set */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMASR_21);
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMASR_22);
   
    /* Assert DMACLRRX Signal */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);

    PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASR_23);
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMASR_24);
  
    /* Deassert DMACLRRX Signal */ 
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMASREQRX is cleared & DMABREQRX is set */
    PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASR_25);
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMASR_26);
   
    C("READ SECOND FRAME ");
    RxFIFORd(Channel_1,ChValidSlot, ChModeSizeFen);
   
    /* Verify that DMASREQRX and DMABREQRX are set */
    PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASR_27);
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMASR_28);
   
    /* Assert DMACLRRX Signal */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASR_29);
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMASR_30);
   
    /* Deassert DMACLRRX Signal */ 
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMASREQRX is cleared & DMABREQRX is set */
    PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASR_31);
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMASR_32);
   
    if (Mode != AACI_CM)
      {
       C(" READ THIRD FRAME ");
       RxFIFORd(Channel_1,ChValidSlot, ChModeSizeFen);
       PI(0x03); 
       
       /* Verify that DMASREQRX is set & DMABREQRX is cleared */ 
       PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMASR_33);
       PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMASR_34);
      
       /* Assert DMACLRRX Signal */
       PSW(AACI_DMACLRRX, AACITrDMAReg);
       PI(One_BitClk_Period);
      
       PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASR_35);
       PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMASR_36);
      
       /* Deassert DMACLRRX Signal */ 
       PSW(0x0, AACITrDMAReg);
       PI(One_BitClk_Period);
      
       /* Verify that DMASREQRX & DMABREQRX are set */
       PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMASR_37);
       PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMASR_38);
      
       C(" READ  FOURTH FRAME ");
       RxFIFORd(Channel_1,ChValidSlot, ChModeSizeFen);
      
       /* Verify that DMASREQRX is set & DMABREQRX is cleared */
       PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMASR_39);
       PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMASR_40);
      
       /* Assert DMACLRRX Signal */
       PSW(AACI_DMACLRRX, AACITrDMAReg);
       PI(One_BitClk_Period);
      
       PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASR_41);
       PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMASR_42);
      
       /* Deassert DMACLRRX Signal */ 
       PSW(0x0, AACITrDMAReg);
       PI(One_BitClk_Period);
      
       /* Verify that DMASREQRX is set & DMABREQRX is cleared */
       PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMASR_43);
       PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMASR_44);
      }
   
    C(" READ THE SECOND LAST  FRAME ");
    RxFIFORd(Channel_1,ChValidSlot, ChModeSizeFen);
   
    PI(0x04); 
   
    /* Verify that DMASREQRX is set & DMABREQRX is cleared */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMASR_45);

    if (Mode != AACI_CM)
      PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMASR_46);
    else
      PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMASR_47)
   
    /* Assert DMACLRRX Signal */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASR_48);
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMASR_49);
   
    /* Deassert DMACLRRX Signal */ 
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMASREQRX is set & DMABREQRX is cleared */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMASR_50);
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMASR_51);
   
    C("READ LAST FRAME ");
   } /* End of if, for FIFO mode */ 

 RxFIFORd(Channel_1,ChValidSlot, ChModeSizeFen);

 /* Verify that DMASREQRX is set & DMABREQRX is cleared */
 PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMASR_52);
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMASR_53);

 /* Assert DMACLRRX Signal */
 PSW(AACI_DMACLRRX, AACITrDMAReg);
 PI(One_BitClk_Period);

 PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASR_54);
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMASR_55);

 /* Deassert DMACLRRX Signal */ 
 PSW(0x0, AACITrDMAReg);
 PI(One_BitClk_Period);

 /* Verify that DMASREQRX & DMABREQRX are cleared */
 PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASR_56);
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMASR_57);

 /* Disable AACIFE bit */
 PSW(0x0, AACIMAINCR);

 C("END OF DMA SINGLE RECEIVE REQUEST TEST ");
}

/**********************************************************************/
/*********************** DMA Burst Request Test ***********************/
/**********************************************************************/
void DMABREQRXTest(int32 ChModeSizeFen, int32 ChValidSlot )
{
 /*
   Summary: DMABREQRX Test
   ========================
   This function checks the functionality of the DMA Burst receive
   request signal.

   The AACIRXCR1 register of the AACI is programmed for valid slots
   indicated by ChValidSlot. When Rx FIFO is empty, the DMABREQRX bit
   of the AACITrDMAReg is checked for a '0'. The AACI is allowed to
   receive four data frames from the trickbox. After every frame, the
   DMABREQRX bit is checked for a '0' until the AACI Rx FIFO fill level
   reaches four. After the fourth data is written into the Rx FIFO,
   DMABREQRX bit is checked for a '1'. Also, it is verified that
   transferring another four data into the Rx FIFO does not clear
   this DMA request. Reading four data from the Rx FIFO of the AACI
   should not clear this DMA request. After each Rx FIFO read, DMACLRRX
   signal is asserted and deasserted via the trickbox. After deasserting
   DMACLRRX, DMABREQRX is checked for '1'. After the fifth read and
   deassertion of DMACLRRX, DMABREQRX is checked for '0' because the
   fill level drops to 3. Remaining data is read from Rx FIFO and
   DMABREQRX is checked for '0'.
 */

 int32 Mode, RSize, Size;
 int   One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 int   SlotFill=0 , i ;
 int32 SlotMask = 0x02;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
   One_BitClk_Period = 0x1;

 /* Extract Compact Mode information */
 Mode  = ChModeSizeFen & MASK_MODE;

 /* Extract RSIZE information */
 RSize  = ChModeSizeFen & MASK_TSIZE;
 Size = RSize >>13;

 C(" START OF DMA BURST RECEIVE REQUEST TEST ");
 /* Compute the point at which the DMA request is to be checked based
    on the fill level */
 for (i = 1 ; i < 13 ; i++)
   {
    if (ChValidSlot & SlotMask)
      SlotFill = i;
    SlotMask = SlotMask << 1 ;
   }
 SlotFill = SlotFill << 16; 

 /* Enable DMA Enable & AACIFE bit */
 PSW(AACI_AACIIFE | AACI_DMAEN , AACIMAINCR);

 /* Configure AACIRXCR1 to receive required number of slot */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen);

 /* Verify that DMABREQRX is cleared */
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_1);

 C("WRITE FOUR FRAME IN TRICKBOX ");
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);

 if (Mode != AACI_CM )
   {
    C("WRITE ANOTHER FOUR FRAME IN TRICKBOX ");
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
   }

 /* Enable Trickbox Transmission and AACI Reception */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | AACI_REN);
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_TxEn | AACITB_BtClkRst, AACITrCntlReg);

 if (Mode == AACI_CM)
   {
    /* Poll for Trickbox Tx FIFO fill level for end of valid slots
       in 1st frame transmission */
    PO(AACITB_TxFFillLevel52 -SlotFill , MASK_TxFFFillLevel,AACITrFIFOStat, 512 * One_BitClk_Period,DMABRX_2);
   
    /* Verify that DMABREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_3);
   
    C("FIRST FRAME VALID SLOTS TRANSMITTED ");
    /* Wait for 2nd  Frame Transmission */
    PO(AACITB_TxFFillLevel39 -SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRX_4);
   
    C("SECOND FRAME VALID SLOTS TRANSMITTED ");
    /* Verify that DMABREQRX is set */
    PO(AACI_DMABREQRX, AACI_DMABREQRX,AACITrDMAReg, 40 * One_BitClk_Period,DMABRX_5);
   }
 else 
   { 
    /* Poll for Trickbox Tx FIFO fill level for end of valid slots
       in 1st frame transmission */
    PO(AACITB_TxFFillLevel104 -SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRX_6);
 
    /* Verify that DMABREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_7);
 
    C("FIRST FRAME VALID SLOTS TRANSMITTED ");

    /* Poll for Trickbox Tx FIFO fill level for end of valid slots
       in 2nd frame transmission */
    PO(AACITB_TxFFillLevel91 -SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRX_8);
 
    C("SECOND FRAME VALID SLOTS TRANSMITTED ");

    /* Verify that DMABREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_9);

    /* Poll for Trickbox Tx FIFO fill level for end of valid slots
       in 3rd frame transmission */
    PO(AACITB_TxFFillLevel78 - SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRX_10); 
     
    /* Verify that DMABREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_11); 

    C("THIRD FRAME TRANSMITTED ");

    /* Poll for Trickbox Tx FIFO fill level for end of valid slots
       in 4th frame transmission */
    if (PCLK_PERIOD > AACIBITCLK_PERIOD)
      PO(AACITB_TxFFillLevel52, MASK_TxFFFillLevel, AACITrFIFOStat,512 *One_BitClk_Period,DMABRX_12);
    else
      PO(AACITB_TxFFillLevel65- SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period ,DMABRX_13);
     
    /* Verify that DMABREQRX is set */
    PO(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg, 40 * One_BitClk_Period,DMABRX_14);
  
    C("FOURTH FRAME VALID SLOTS TRANSMITTED ");

    /* Poll for Trickbox Tx FIFO fill level for end of valid slots
       in 5th frame transmission */
    if (PCLK_PERIOD > AACIBITCLK_PERIOD)
      PO(AACITB_TxFFillLevel39, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRX_15); 
    else
      PO(AACITB_TxFFillLevel52 - SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRX_16); 
  
    /* Verify that DMABREQRX is set */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRX_17);

    C("FIFTH FRAME VALID SLOTS TRANSMITTED ");

    /* Poll for Trickbox Tx FIFO fill level for end of valid slots
       in 5th frame transmission */
    if (PCLK_PERIOD > AACIBITCLK_PERIOD)
      PO(AACITB_TxFFillLevel26, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRX_17);
    else
       PO(AACITB_TxFFillLevel39 - SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRX_18);
  
    /* Verify that DMABREQRX is set */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRX_19);

    C("SIXTH FRAME VALID SLOTS TRANSMITTED ");
   } /* End of else, for Non Compact Mode */  
  
 FrameWrite(Channel_1, 0x80000, Mode | RSize); 

 /* Poll for Trickbox Tx FIFO fill level for end of valid slots
    in next frame transmission */
 if (PCLK_PERIOD > AACIBITCLK_PERIOD)
    PO(AACITB_TxFFillLevel12, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRX_20); 
 else              
   PO(AACITB_TxFFillLevel26-SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRX_21);

 /* Verify that DMABREQRX is set */
 PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRX_22);

 C("SECOND LAST FRAME VALID SLOTS TRANSMITTED ");

 if (PCLK_PERIOD <= AACIBITCLK_PERIOD)
    PO(AACITB_TxFFillLevel12, MASK_TxFFFillLevel, AACITrFIFOStat, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRX_23); 

 /* Disable Trickbox Transmission */
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);

 /* Poll for Trickbox Tx FIFO fill level for end of valid slots
    in last frame transmission */
 PO(AACITB_TxFFillLevel0,MASK_TxFFFillLevel, AACITrFIFOStat,256 * One_BitClk_Period,DMABRX_24);
 PI(24 * One_BitClk_Period);

 /* Verify that DMABREQRX is set */
 PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRX_25);

 C(" LAST FRAME VALID SLOTS TRANSMITTED ");   
 /* Disable AACI Reception */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen);

 /* Read First Frame */
 RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);

 /* Verify that DMABREQRX is set */
 PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRX_26);

 /* Assert DMACLRRX Signal */
 PSW(AACI_DMACLRRX, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_27);
 /* Deassert DMACLRRX Signal */ 
 PSW(0x0, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 /* Verify that DMABREQRX is set */
 PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRX_28);
 
 C("READ SECOND FRAME ");
 RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
 
 /* Verify that DMABREQRX is set */
 PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRX_29);
 
 /* Assert DMACLRRX Signal */
 PSW(AACI_DMACLRRX, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_30);
 
 /* Deassert DMACLRRX Signal */ 
 PSW(0x0, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 /* Verify that DMABREQRX is set */
 PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRX_31);

 if (Mode != AACI_CM)
   {
    C(" READ THIRD FRAME ");
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
    
    /* Verify that DMABREQRX is cleared */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRX_32);
    
    /* Assert DMACLRRX Signal */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
    
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_33);  
    
    /* Deassert DMACLRRX Signal */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
    
    /* Verify that DMABREQRX is set */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRX_34);
    
    C(" READ  FOURTH FRAME ");
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
    
    /* Verify that DMABREQRX is set */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRX_35);
    
    /* Assert DMACLRRX Signal */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_36);
   
    /* Deassert DMACLRRX Signal */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
   
     /* Verify that  DMABREQRX is set */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRX_37);

    C(" READ THE FIFTH FRAME ");
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
    
    /* Verify that DMABREQRX is cleared */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRX_38);
    
    /* Assert DMACLRRX Signal */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
    
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_39);

    /* Deassert DMACLRRX Signal */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
    
    /* Verify that DMABREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_40);
    
    C(" READ THE SIXTH FRAME ");
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
    
    /* Verify that DMABREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_41);
    
    /* Assert DMACLRRX Signal */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
    
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_42);
    
    /* Deassert DMACLRRX Signal */ 
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
    
    /* Verify that DMABREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_43);
   } /* End of if, for Non Compact Mode */ 
 
 C(" READ THE SECOND LAST FRAME ");
 RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);

 if (Mode != AACI_CM) 
    /* Verify that DMABREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_44);
 else
   /* Verify that DMABREQRX is set */
   PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRX_45);
 
 /* Assert DMACLRRX Signal */
 PSW(AACI_DMACLRRX, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_46);

 /* Deassert DMACLRRX Signal */
 PSW(0x0, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 /* Verify that DMABREQRX is cleared */
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_47);
 
 C(" READ LAST FRAME ");
 RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
 
 /* Verify that DMABREQRX is cleared */
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_48);

 /* Assert DMACLRRX Signal */
 PSW(AACI_DMACLRRX, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_49);

 /* Deassert DMACLRRX Signal */
 PSW(0x0, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 /* Verify that DMABREQRX is cleared */
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRX_50);

 /* Disable Trickbox bit */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Clear DMA Enable and FIFO Enable Bit */
 PSW(0x0, AACIMAINCR );

 C("END OF DMA BURST RECEIVE REQUEST TEST ");
}

/**********************************************************************/
/********************** DMA Burst Transmit Request *******************/
/**********************************************************************/
void DMABREQTXTest(int32 ChModeSizeFen, int32 ChValidSlot )
{
 /*
   Summary: DMABREQTX Test
   ========================
   This function checks the functionality of the DMA Burst Transmit
   request signal.

   The AACITXCR1 register of the AACI is programmed for valid slots
   indicated by ChValidSlot. When the Tx FIFO in the AACI is empty,
   the DMABREQTX bit in the AACITrDMAReg register is checked for a '1'.
   Then, the Tx FIFO in the AACI is filled with eight data.
   After each data write to the Tx FIFO, the DMABREQTX line is checked
   for a '1'. Then, the DMACLRTX signal is asserted through the
   trickbox. The DMABREQTX line is then checked for a '0'. Frames with
   SRC bits set are written into the trickbox. Data transfer is enabled.
   After each of the first three frames, DMABREQTX is checked for a '0'.
   After the fourth frame is transmitted, the Tx FIFO in the AACI has
   four data. So the DMABREQTX Burst DMA Request is checked for a '1'.
   After each of the next four frames, DMABREQTX is expected to remain
   asserted until the DMACLRTX signal is asserted. The AACITrDMAReg in
   the trickbox is read to verify this. After the last frame
   transmission, DMABREQTX is expected to remain asserted.
 */

 int32 Mode, TSize, Size, SlotFill;
 int   i, Slot,Count;
 int   One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 int32 SlotMask = 0x02;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
   One_BitClk_Period = 0x1;

 /* Extract Compact Mode information */
 Mode  = ChModeSizeFen & MASK_MODE;

 /* Extract TSIZE information */
 TSize = ChModeSizeFen & MASK_TSIZE;
 Size = TSize >>13;

 /* Select number of frames with SRC bits set depending on Compact Mode
    bit  - one extra frame to prevent the AACI from going into Idle
    state */
 if (Mode == AACI_CM)
   Count = 5;
 else
   Count = 9;

 /* Compute the point at which the DMA request is to be checked based
    on the fill level */
 for (i = 1 ; i < 13 ; i++)
   {
    if (ChValidSlot & SlotMask)
       SlotFill = i;
     SlotMask = SlotMask << 1 ;
   }

 C(" START OF DMA BURST TRANSMIT REQUEST TEST ");

 /* Enable AACIFE & DMA Enable bit */
 PSW(AACI_AACIIFE| AACI_DMAEN, AACIMAINCR);

 /* Configure AACITXCR1 for required number of slots */
 ConfigTxCR(Channel_1, ChValidSlot | ChModeSizeFen);

 /* Verify that DMABREQTX is set */
 PSR(AACI_DMABREQTX, AACI_DMABREQTX, AACITrDMAReg,DMABTX_1);

 /* Write frames with only the SRC bits set into the Trickbox Tx FIFO */
 for (i = 0; i < 13 * Count ; i++)
   {
    if (i % 13 == 0 )
      {
       PSW(0xC0000, AACITrTxFIFO);
      }
    else
      {
       PSW(0x00000, AACITrTxFIFO);
      }
   }

 /* Write valid  Frames, each containing one slot */
 for (Slot = 1; Slot < Count; Slot ++)
   {
    /* Write Frame in Tx FIFO of AACI */
    TxFIFOFill(Channel_1, ChValidSlot, ChModeSizeFen);
 
    /* Verify that DMABREQTX is set */
    PSR(AACI_DMABREQTX, AACI_DMABREQTX, AACITrDMAReg,DMABTX_2);
   }

 /* Assert DMACLRTX Signal */
 PSW(AACI_DMACLRTX, AACITrDMAReg);
 PI(One_BitClk_Period);

 PSR(0x0, AACI_DMABREQTX, AACITrDMAReg,DMABTX_3);

 /* Deassert DMACLRTX Signal */
 PSW(0x0, AACITrDMAReg);
 PI(One_BitClk_Period);

 /* Verify that DMABREQTX is cleared */   
 PSR(0x0, AACI_DMABREQTX, AACITrDMAReg,DMABTX_4);

 /* Enable AACI Transmission and Trickbox Reception */
 ConfigTxCR(Channel_1, ChValidSlot | ChModeSizeFen | AACI_TEN);
 PSW(AACITB_En|AACITB_BtClkEn|AACITB_RxEn|AACITB_BtClkRst|AACITB_TxEn, AACITrCntlReg);

 /* Poll for Trickbox Rx FIFO fill level for end of valid slots
    in 1st frame reception */
 PO(AACITB_RxFFillLevel13+SlotFill, MASK_RxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,x2);

 C("FIRST FRAME VALID SLOTS RECEIVED ");

 /* Verify that DMABREQTX is cleared */   
 PSR(0x0, AACI_DMABREQTX, AACITrDMAReg,DMABTX_5);
 PI(0x01);

 /* Poll for Trickbox Rx FIFO fill level for end of valid slots
    in 2nd frame reception */
 PO(AACITB_RxFFillLevel26 + SlotFill, MASK_RxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABTX_6);  

 C(" SECOND FRAME VALID SLOTS RECEIVED ");

 PI(0x01);
 if (Mode == AACI_CM)
   {
    /* Verify that DMABREQTX is set */
    PO(AACI_DMABREQTX, AACI_DMABREQTX, AACITrDMAReg, 40 * One_BitClk_Period,DMABTX_7);

    PI(0x01);
   /* Poll for Trickbox Rx FIFO fill level for end of valid slots
      in 3rd frame reception */
    PO(AACITB_RxFFillLevel39+SlotFill, MASK_RxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABTX_8);
    
    /* Verify that DMABREQTX is set */
    PSR(AACI_DMABREQTX, AACI_DMABREQTX, AACITrDMAReg,DMABTX_9);
    
    C("SECOND LAST FRAME VALID SLOTS RECEIVED ");

    /* Poll for Trickbox Rx FIFO fill level for end of valid slots
       in last frame reception */
    PO(AACITB_RxFFillLevel52, MASK_RxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABTX_10); 

    PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

    /* Verify that DMABREQTX is set */
    PSR(AACI_DMABREQTX, AACI_DMABREQTX, AACITrDMAReg,DMABTX_12);

    /* Poll for Trickbox Rx FIFO fill level for end of the extra frame
       that was transmitted from the AACI */
    PO(AACITB_RxFFillLevel65, MASK_RxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABTX_13);

    C(" LAST FRAME RECEIVED ");
   }
 else 
   {
    /* Verify that DMABREQTX is cleared */
    PSR(0x0, AACI_DMABREQTX, AACITrDMAReg,DMABTX_14);
 
    /* Poll for Trickbox Rx FIFO fill level for end of valid slots
       in 3rd frame reception */
    PO(AACITB_RxFFillLevel39 + SlotFill, MASK_RxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABTX_15); 
 
    /* Verify that DMABREQTX is cleared */
    PSR(0x0, AACI_DMABREQTX, AACITrDMAReg,DMABTX_16);

    C(" THIRD FRAME VALID SLOTS RECEIVED ");

    /* Poll for Trickbox Rx FIFO fill level for end of valid slots
       in 4th frame reception */
    /* Wait for 4th Frame Transmission */
    PO(AACITB_RxFFillLevel52 + SlotFill, MASK_RxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABTX_17);
    PI(0x01);

    /* Verify that DMABREQTX is set */   
    PO(AACI_DMABREQTX, AACI_DMABREQTX, AACITrDMAReg, 40 * One_BitClk_Period,DMABTX_18);
    PI(0x01);

    C("FOURTH FRAME VALID SLOTS RECEIVED "); 

   /* Poll for Trickbox Rx FIFO fill level for end of valid slots
      in 5th frame reception */
   PO(AACITB_RxFFillLevel65 + SlotFill, MASK_RxFFFillLevel, AACITrFIFOStat, 768 * One_BitClk_Period,DMABTX_19);

   /* Verify that the DMABREQTX is set */
   PSR(AACI_DMABREQTX, AACI_DMABREQTX, AACITrDMAReg,DMABTX_20);

   C("FIFTH FRAME VALID SLOTS RECEIVED ");

   /* Poll for Trickbox Rx FIFO fill level for end of valid slots
      in 6th frame reception */
   PO(AACITB_RxFFillLevel78+SlotFill, MASK_RxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABTX_21);

   /* Verify that the DMABREQTX is set */
   PSR(AACI_DMABREQTX, AACI_DMABREQTX, AACITrDMAReg,DMABTX_22);

   C("SIXTH FRAME VALID SLOTS RECEIVED ");

   PI(0x01);
   /* Poll for Trickbox Rx FIFO fill level for end of valid slots
      in 7th frame reception */
   PO(AACITB_RxFFillLevel91+SlotFill, MASK_RxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABTX_23);

   C("SEVENTH FRAME VALID SLOTS RECEIVED ");
  
   /* Verify that the DMABREQTX is set */
   PSR(AACI_DMABREQTX, AACI_DMABREQTX, AACITrDMAReg,DMABTX_24);

   /* Poll for Trickbox Rx FIFO fill level for end of valid slots
      in last frame reception */
   PO(AACITB_RxFFillLevel104, MASK_RxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABTX_25);

   /* Disable Trickbox Reception */
   PSW(AACITB_En | AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg); 

   PI(0x01);

   /* Poll for Trickbox Rx FIFO fill level for end of extra frame 
      transmitted by the AACI */
   PO(AACITB_RxFFillLevel117 ,MASK_RxFFFillLevel, AACITrFIFOStat, 512* One_BitClk_Period,DMABTX_27);  

   C("LAST FRAME RECEIVED ");
  } /* End of else, for Non Compact Mode */  
 C(" ALL FRAMES ARE TRANSMITTED AND RECEIVED ");

 /* Disable AACI Transmission */
 ConfigTxCR(Channel_1, ChValidSlot | ChModeSizeFen );

 /* Verify that the DMABREQTX is set */
 PSR(AACI_DMABREQTX, AACI_DMABREQTX, AACITrDMAReg,DMABTX_28);

 /* Assert DMACLRTX Signal */
 PSW(AACI_DMACLRTX, AACITrDMAReg);
 PI(One_BitClk_Period);

 /* Verify that the DMABREQTX is cleared */
 PSR(0x0, AACI_DMABREQTX, AACITrDMAReg,DMABTX_29);

 /* Deassert DMACLRTX Signal */
 PSW(0x0, AACITrDMAReg);
 PI(3 * One_BitClk_Period);

 /* Verify that DMABREQTX is set */
 PSR(AACI_DMABREQTX, AACI_DMABREQTX, AACITrDMAReg,DMABTX_30);

 /* Read Data From Trickbox Rx FIFO  */
 C("READING FIRST INVALID FRAME ");
 /* First frame is invalid */
 for (i = 0; i < 13; i++)
   {
    PSR(0x0, 0x0FFFFF, AACITrRxFIFO,DMABTX_31);
   }
 
 /* Second frame is valid */
 C("READING FIRST VALID FRAME  ");
 FrameRead(Channel_1, ChValidSlot, Mode | TSize );

 C("READING SECOND VALID FRAME ");
 FrameRead(Channel_1, ChValidSlot, Mode | TSize );

 if (Mode !=  AACI_CM)
   {
    C("READING THIRD VALID FRAME  ");
    FrameRead(Channel_1, ChValidSlot, Mode | TSize );

    C("READING FOURTH VALID FRAME ");
    FrameRead(Channel_1, ChValidSlot, Mode | TSize );
  
    C("READING FIFTH VALID FRAME  ");
    FrameRead(Channel_1, ChValidSlot, Mode | TSize );
  
    C("READING SIXTH VALID FRAME ");
    FrameRead(Channel_1, ChValidSlot, Mode | TSize );
   }
   
 C("READ SECOND LAST FRAME "); 
 FrameRead(Channel_1, ChValidSlot, Mode | TSize );

 C("READ LAST FRAME ");
 FrameRead(Channel_1, ChValidSlot, Mode | TSize );

 /* Disable Trickbox bit */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Disable AACIFE bit and DMA Enable Bit */
 PSW(0x0, AACIMAINCR);

 C("END OF DMA BURST TRANSMIT REQUEST TEST");
}

/**********************************************************************/
/*********** DMA Last Single Receive Request Test *********************/
/*********************************************************************/
void DMALSREQRXTest(int32 ChModeSizeFen)
{
 /*
   Summary: DMALSREQRX Test
   ========================
   This function checks the functionality of the DMA Last Single Receive
   request signal.

   The test sequence is as follows :
   o  The Rx FIFO is enabled for the slots 3, 5, 7, and 8 for
      channel 1 and the TOC field in the AACIRXCR1 register is loaded
      with 4.

   o  The trickbox Tx FIFO is filled with 4 valid slots for the
      first frame and then for the subsequent frames the trickbox is
      filled with invalid data's for 5 frames.

   o  Data transmission from trickbox and reception into the AACI is
      enabled.

   o  At the end of the 5th frame reception, the RxTimeout status bit
      is checked.

   o  Data transmission from trickbox and reception into the AACI is
      disabled.

   o  Data words are read from Rx FIFO of AACI. After each frame is
      read, the DMASREQRX and DMALSREQRX are verified for
      expected values.

   o  The DMALSREQRX will be set on the following conditions in FIFO
      Mode :

        - If the Rx FIFO is in Compact mode, DMALSREQRX will be asserted
          when the Rx FIFO fill level is 2 with RxTimeout set.

        - If the Rx FIFO is in Non Compact Mode, DMALSREQRX will be
          asserted when the Rx FIFO fill level is 1 with RxTimeout set.

    o  After each read, DMACLRRX signal is asserted and deasserted.
       After deassertion of DMACLRRX, DMALSREQRX and DMASREQRX are again
       checked for expected value.
 
    o  Repeat the last three steps, until last data word is read.
 */

 int32 ChValidSlot;
 int32 Mode, RSize, TOC;
 int   One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 int   i;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 /* Extract Compact Mode information */
 Mode  = ChModeSizeFen & MASK_MODE;

 /* Extract RSIZE information */
 RSize = ChModeSizeFen & MASK_TSIZE;

 C(" START OF DMA LAST SINGLE RECEIVE REQUEST TEST ");

 /* Enabling the DMA & AACIFE in the main control register */
 PSW(AACI_AACIIFE | AACI_DMAEN, AACIMAINCR);

 /* Configure AACIRXCR1 for four Slots and timeout count = 4 */
 TOC = 0x4;
 TOC = TOC << 17;
 ChValidSlot =  AACI_RX3 | AACI_RX5 | AACI_RX7 | AACI_RX8;
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | TOC );

 C("WRITING VALID FRAME IN TRICKBOX");
 /* Write First Frame */
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize | TOC );

 /* Write 5 Invalid Frames */
 C("WRITING FIVE INVALID FRAMES ");
 FrameWrite(Channel_1, 0x0, Mode | RSize );
 FrameWrite(Channel_1, 0x0, Mode | RSize );
 FrameWrite(Channel_1, 0x0, Mode | RSize );
 FrameWrite(Channel_1, 0x0, Mode | RSize );
 FrameWrite(Channel_1, 0x0, Mode | RSize );
 C("FIVE INVALID FRAMES ARE WRITTEN ");

 /* Enabling the reception of the channel 1 and enable FIFO */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | AACI_REN | TOC);

 /* Enabling the trickbox for transmission */
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_BtClkRst | AACITB_TxEn, AACITrCntlReg);

 /* Poll for Trickbox Tx FIFO fill level for end of valid slots
    in 1st frame transmission */
 PO(AACITB_TxFFillLevel65, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALSRX_1);

 C("FIRST FRAME VALID SLOTS TRANSMITTED ");
 PI(0x01);

 /* Poll for Trickbox Tx FIFO fill level for end of 1st invalid frame
    transmission */
 PO(AACITB_TxFFillLevel52, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALSRX_2);

 C("FIRST INVALID FRAME TRANSMITTED ");
 PI(0x01);
 
 /* Poll for Trickbox Tx FIFO fill level for end of 2nd invalid frame
    transmission */
 PO(AACITB_TxFFillLevel39, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALSRX_3);

 C("SECOND INVALID FRAME TRANSMITTED ");
 PI(0x01);

 /* Poll for Trickbox Tx FIFO fill level for end of 3rd invalid frame
    transmission */
 PO(AACITB_TxFFillLevel26, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALSRX_4);

 C("THIRD INVALID FRAME TRANSMITTED ");
 PI(0x01);

 /* Poll for Trickbox Tx FIFO fill level for end of 4th invalid frame
    transmission */
 PO(AACITB_TxFFillLevel12, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALSRX_5);

 C("FOURTH INVALID FRAME TRANSMITTED ");
 PI(0x01);

 /* Disable Transmission */
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg); 

 /* Poll for Trickbox Tx FIFO fill level for end of last invalid frame
    transmission */
 PO(AACITB_TxFFillLevel0, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALSRX_6);

 C("LAST INVALID FRAME TRANSMITTED ");

 /* Disable Reception */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | TOC);

 /* Confirming that the RxTimeout status bit is set */
 PSR(AACI_TIMEOUT, AACI_TIMEOUT, AACISR1,DMALSRX_7); 

 if (Mode == AACI_CM)
   {
    /* Reading the 2 entries from the Rx FIFO of the AACI */
    ChValidSlot = AACI_RX3 | AACI_RX5;

    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);

    /* Verify that DMASREQRX is set and DMALSREQRX is cleared */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMALSRX_8);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALSRX_9);
 
    /* Clearing of the all the request signals by asserting DMACLRRX */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
 
    /* Verify that DMASREQRX and DMALSREQRX are cleared */
    PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALSRX_10);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALSRX_11);
 
    /* Deassert DMACLRRX */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
 
    /* Verify that DMASREQRX is cleared and DMALSREQRX is set */
    PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMALSRX_12);
    PSR(AACI_DMALSREQRX, AACI_DMALSREQRX, AACITrDMAReg,DMALSRX_13);
   }
 else
   {
    /* Reading the 3 entries from the Rx FIFO of the AACI */

    /* Read first entry */
    ChValidSlot = AACI_RX3;
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
    
    /* Verify that DMASREQRX is set and DMALSREQRX is cleared */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMALSRX_14);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALSRX_15);
   
    /* Clearing of the all the request signals by asserting DMACLRRX */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period); 
   
    /* Verify that DMASREQRX and DMALSREQRX are cleared */
    PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALSRX_16);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALSRX_17);
   
    /* Deassert DMACLRRX */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMASREQRX is set and DMALSREQRX is cleared */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMALSRX_18);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALSRX_19);
   
    /* Read second entry */
    ChValidSlot = AACI_RX5;
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
   
    /* Verify that DMASREQRX is set and DMALSREQRX is cleared */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMALSRX_20);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALSRX_21);
    
    /* Clearing of the all the request signals by asserting DMACLRRX */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
    
    /* Verify that DMASREQRX and DMALSREQRX are cleared */
    PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALSRX_22);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALSRX_23);
    
    /* Deassert DMACLRRX */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
    
    /* Verify that DMASREQRX is set and DMALSREQRX is cleared */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMALSRX_24);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALSRX_25);
       
    /* Read third entry */
    ChValidSlot = AACI_RX7;
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
    
    /* Verify that DMASREQRX is set and DMALSREQRX is cleared */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMALSRX_26);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALSRX_27);
    
    /* Clearing of the all the request signals by asserting DMACLRRX */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMASREQRX and DMALSREQRX are cleared */
    PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALSRX_28);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALSRX_29);
    
    /* Deassert DMACLRRX */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
    
    /* Verify that DMASREQRX is cleared and DMALSREQRX is set */
    PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMALSRX_30);
    PSR(AACI_DMALSREQRX, AACI_DMALSREQRX, AACITrDMAReg,DMALSRX_31);
   } /* End of else, for Non Compact Mode */

 /* Reading the last entry from the Rx FIFO of the AACI */
 if (Mode == AACI_CM)
    ChValidSlot = AACI_RX7 | AACI_RX8;
 else
    ChValidSlot = AACI_RX8;
 RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);

 /* Verify that DMASREQRX is cleared and DMALSREQRX is set */
 PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMALSRX_32);
 PSR(AACI_DMALSREQRX, AACI_DMALSREQRX, AACITrDMAReg,DMALSRX_33);
 
 /* Clearing of the all the request signals by asserting DMACLRRX */
 PSW(AACI_DMACLRRX, AACITrDMAReg);
 PI(One_BitClk_Period);

 /* Verify that DMASREQRX and DMALSREQRX are cleared */
 PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALSRX_34);
 PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALSRX_35);

 /* Deassert DMACLRRX */
 PSW(0x0, AACITrDMAReg);
 PI(One_BitClk_Period);

 /* Verify that DMASREQRX is cleared and DMALSREQRX is set */
 PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALSRX_36);
 PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALSRX_37);

 /* Disable Trickbox bit */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 /* Disable AACIFE bit */
 PSW(0x0, AACIMAINCR);

 C(" END OF DMA LAST SINGLE RECEIVE REQUEST TEST ");
}

/**********************************************************************/
/************* DMA Single Receive Request with Timeout Condition ******/
/**********************************************************************/
void DMASREQRXWTTest(int32 ChModeSizeFen, int32 ChValidSlot)
{
 /*
   Summary: DMASREQRX With Timeout Test
   ====================================
   This function tests DMA Single Receive Request functionality with
   RxTimeout.

   The test sequence is as follows :

   o  AACIRXCR1 is programmed for valid slots indicated by
      ChValidSlot & TOC field is programmed for 4 invalid frames.

   o  Trickbox Tx FIFO is filled with required amount of data to be
      transmitted according to Compact or Non Compact mode. Five invalid
      frames are filled in Trickbox subsequently.

   o  Enable Trickbox transmission and AACI reception.

   o  Poll Trickbox Tx FIFO fill level such that it should indicate
      transmission of required valid slots.

   o  When expected fill level is reached for each frame, check that
      DMASREQRX and DMABREQRX request are set or cleared according to
      the fill level of the Rx FIFO of the AACI.

   o  Repeat the above 2 steps until the last frame is transmitted.

   o  Disable Trickbox transmission and AACI reception.

   o  Read received data and compare with expected data. After each
      read, check DMASREQRX and DMABREQRX.

   o  Assert and Deassert DMACLRRX signal, once again check DMASREQRX
      and DMABREQRX request for desired status.

   o  Repeat the above 2 steps until Rx FIFO fill level reaches zero.
 */
 
 int32 Mode, RSize, TOC;
 int   One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 int   i;
 
 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 /* Extract Compact Mode information */
 Mode   = ChModeSizeFen & MASK_MODE;

 /* Extract RSIZE information */
 RSize  = ChModeSizeFen & MASK_TSIZE;

 C(" START OF DMA SINGLE RECEIVE REQUEST WITH TIMEOUT TEST");

 /* Enabling the DMA & AACIFE bit in the main control register */
 PSW(AACI_AACIIFE | AACI_DMAEN, AACIMAINCR);
 
 /* Configure AACIRXCR1 for required number of slots and
    timeout count = 4 */
 TOC = 0x4;
 TOC = TOC << 17;
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | TOC);

 /* Verify that DMASREQRX is cleared */
 PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASWTRX_1);

 C("FILL TRICKBOX Tx FIFO ");
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);

 if (Mode != AACI_CM )
   {
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
   }
 
 /* Enable Trickbox Transmission and AACI Reception */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | AACI_REN | TOC );
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_TxEn | AACITB_BtClkRst, AACITrCntlReg);

 C("TRANSMISSION AND RECEPTION ENABLED ");
 
 /* Poll for Trickbox Tx FIFO fill level for end of valid slots
    in 2nd frame transmission */
 PO(AACITB_TxFFillLevel26, MASK_TxFFFillLevel, AACITrFIFOStat , 512 * One_BitClk_Period,DMASWTRX_2);
 
 C("TWO FRAMES ARE TRANSMITTED ");

 C("WRITING 2 INVALID FRAMES IN TRICKBOX "); 
 FrameWrite(Channel_1, 0x0, Mode | RSize);
 FrameWrite(Channel_1, 0x0, Mode | RSize);

 /* Poll for Trickbox Tx FIFO fill level for end of 4th frame
    transmission */
 PO(AACITB_TxFFillLevel26, MASK_TxFFFillLevel, AACITrFIFOStat , 512 * One_BitClk_Period,DMASWTRX_3);
 
 C("NEXT TWO FRAMES ARE TRANSMITTED ");

 PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg, AACI3_T971_q);

 C("WRITING 2 INVALID FRAMES IN TRICKBOX ");
 FrameWrite(Channel_1, 0x0, Mode | RSize);
 FrameWrite(Channel_1, 0x0, Mode | RSize);

 C(" WAIT FOR 4 INVALID FRAMES TRANSMISSION ");
 PO(AACITB_TxFFillLevel26, MASK_TxFFFillLevel, AACITrFIFOStat , 512 * One_BitClk_Period,DMASWTRX_4);

 /* Write a frame with CODEC ready bit set into the Trickbox Tx FIFO to
    prevent the AACI from going to idle state */
 FrameWrite(Channel_1, 0x0, Mode | RSize);
  
 /* Poll for Trickbox Tx FIFO fill level for end of 2nd invalid frame
    transmission */
 PO(AACITB_TxFFillLevel13, MASK_TxFFFillLevel, AACITrFIFOStat , 512 * One_BitClk_Period,DMASWTRX_5);

 C("TWO INVALID FRAMES ARE TRANSMITTED ");

 /* Poll for Trickbox Tx FIFO fill level for end of last invalid frame
    transmission */
 PO(AACITB_TxFFillLevel0, MASK_TxFFFillLevel, AACITrFIFOStat , 512 * One_BitClk_Period,DMASWTRX_6);

 C("ALL INVALID FRAMES ARE TRANSMITTED ");

 /* Disable Trickbox Transmission and AACI Reception */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | TOC);
 PSW(AACITB_En|AACITB_BtClkEn|AACITB_BtClkRst,AACITrCntlReg);

 C("TRANSMISSION AND RECEPTION IS DISABLED ");

 /* Confirming that the RxTimeout status bit is set */
 PSR(AACI_TIMEOUT, AACI_TIMEOUT, AACISR1,DMASWTRX_6);

 /* Verify that DMASREQRX is set */
 PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMASWTRX_7);  

 /* Read one frame */
 RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);

 C("FIRST FRAME READ ");

 /* Verify that DMASREQRX is set */
 PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMASWTRX_8);

 /* Assert DMACLRRX Signal */
 PSW(AACI_DMACLRRX, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 /* Verify that DMASREQRX is cleared */
 PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASWTRX_9);
 
 /* Deassert DMACLRRX Signal */
 PSW(0x0, AACITrDMAReg);
 PI(3*One_BitClk_Period);
 
 if (Mode == AACI_CM)
   {
    /* Verify that DMASREQRX is cleared and DMALSREQRX is asserted */
    PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASWTRX_10);
    PSR(AACI_DMALSREQRX, AACI_DMALSREQRX, AACITrDMAReg,DMASWTRX_11);
   }
 else 
    /* Verify that DMASREQRX is asserted */
    PSR(AACI_DMASREQRX,AACI_DMASREQRX,AACITrDMAReg,DMASWTRX_12);

 if (Mode != AACI_CM)
   {
    /* Read second frame */
    RxFIFORd(Channel_1,ChValidSlot,ChModeSizeFen);
    C("SECOND FRAME READ ");
   
    /* Verify that DMASREQRX is set */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMASWTRX_13);
  
    /* Assert DMACLRRX signal */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMASREQRX is cleared */
    PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASWTRX_14);
   
    /* Deassert DMACLRRX signal */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMASREQRX is set */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMASWTRX_15);
  
    /* Read third frame */
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
  
    C("THIRD FRAME READ ");
   
    /* Verify that DMASREQRX is set */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMASWTRX_16);
     
    /* Assert DMACLRRX Signal */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMASREQRX is cleared */
    PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASWTRX_17);
   
    /* Deassert DMACLRRX signal */
    PSW(0x0, AACITrDMAReg);
    PI(3*One_BitClk_Period);
   
    /* Verify that DMASREQRX is cleared */
    PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASWTRX_18);
   } /* End of if, for Compact Mode */ 

 /* Read Last  Frame */
 RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);

 C("LAST FRAME READ ");

 if (Mode != AACI_CM)
   {
    /* Verify that DMASREQRX is cleared */
     PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASWTRX_19);
   } 
 else
   {
    /* Verify that DMASREQRX is cleared & DMALSREQRX is set */
    PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASWTRX_20);
    PSR(AACI_DMALSREQRX, AACI_DMALSREQRX, AACITrDMAReg,DMASWTRX_21)
   } 
  
 /* Assert DMACLRRX Signal */
 PSW(AACI_DMACLRRX, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 /* Verify that DMASREQRX is cleared */
 PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASWTRX_22);
 
 /* Deassert DMACLRRX Signal */
 PSW(0x0, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 /* Verify that DMASREQRX is cleared */
 PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMASWTRX_23);

 /* Disable Trickbox bit */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Disable AACIFE bit */
 PSW(0x0, AACIMAINCR);
 
 C("END OF DMA SINGLE RECEIVE REQUEST WITH TIMEOUT TEST ");
}

/**********************************************************************/
/*********** DMA Burst Receive Request with Timeout Condition *********/
/**********************************************************************/
void DMABREQRXWTTest(int32 ChModeSizeFen, int32 ChValidSlot)
{
 /*
   Summary: DMABREQRX With Timeout Test
   ====================================
   This function tests DMA Burst Receive Request functionality with
   RxTimeout.

   o  The AACIRXCR1 register is programmed for valid slots indicated by
      ChValidSlot. The TOC field is loaded for 4 invalid frames.

   o  The Tx FIFO in the trickbox is filled with 4 frames if it is in
      Compact mode or with 8 frames if it is in non compact mode. Four
      invalid frames are written subsequently.

   o  The trickbox is allowed to transmit data.

   o  After valid frame transmission, subsequent frames transmitted
      from the Trickbox are invalid frames that do not result in any
      further data being written to the Rx FIFO of the AACI.

   o  When the AACI receives slot 12 of the fourth invalid frame, it is
      expected to raise the RxTimeout Interrupt. Then AACISR1 is read
      to verify that RxTimeout has been asserted.

   o  Trickbox transmission and AACI reception is disabled.

   o  DMABREQRX is checked for set. Three data words are read from the
      Rx FIFO. After each read DMABREQRX is checked for set. Also
      DMACLRRX is asserted and deasserted. After deassertion of
      DMACLRRX, once again DMABREQRX is checked for set.

   o  After 4th Rx FIFO is read and DMACLRRX is asserted & deasserted,
      DMABREQRX is checked for clear.

   o  Remaining data is read from Rx FIFO and each time DMABREQRX is
      checked for clear.
 */

 int32 Mode, RSize, TOC;
 int   One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 int   i;
 
 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;
 
 /* Extract Compact Mode information */
 Mode   = ChModeSizeFen & MASK_MODE;

 /* Extract RSIZE information */
 RSize  = ChModeSizeFen & MASK_TSIZE;

 /* Configure AACIRXCR1 for required number of slots and
    Timeout count = 4 */
 TOC = 0x4;
 TOC = TOC << 17;
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | TOC);

 C(" START OF DMA BURST RECEIVE REQUEST WITH TIMEOUT TEST");
 
 /* Enable DMA Enable & AACIFE bit */
 PSW(AACI_AACIIFE | AACI_DMAEN, AACIMAINCR);
 
 /* Verify that DMABREQRX is cleared */
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_1);

 C("FILL FOUR FRAMES IN TRICKBOX ");
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);

 if (Mode != AACI_CM)
   {
    C("WRITE ANOTHER FOUR VALID FRAMES IN TRICKBOX ");
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
   }
 else
   {
    C("WRITING 4 INVALID FRAMES IN TRICKBOX ");
    FrameWrite(Channel_1, 0x0, Mode | RSize);
    FrameWrite(Channel_1, 0x0, Mode | RSize);
    FrameWrite(Channel_1, 0x0, Mode | RSize);
    FrameWrite(Channel_1, 0x0, Mode | RSize);
   }
 
 /* Enable Trickbox Transmission and AACI Reception */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | AACI_REN | TOC);
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_TxEn | AACITB_BtClkRst, AACITrCntlReg);
   
 /* Poll for Trickbox Tx FIFO fill level for end of 1st frame 
    transmission */
 PO(AACITB_TxFFillLevel91, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRXWT_2);
 
 C("FIRST FRAME TRANSMITTED ");

 /* Poll for Trickbox Tx FIFO fill level for end of 2nd frame
    transmission */
 PO(AACITB_TxFFillLevel78, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRXWT_3);

 C("SECOND FRAME TRANSMITTED ");
 PI(0x01); 

 /* Poll for Trickbox Tx FIFO fill level for end of 3rd frame
    transmission */
 PO(AACITB_TxFFillLevel65, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRXWT_4);

 C("THIRD FRAME TRANSMITTED ");
 PI(0x01);

 if (Mode == AACI_CM)
   {
    /* Poll for Trickbox Tx FIFO fill level for end of last frame
    transmission */
    PO(AACITB_TxFFillLevel52, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRXWT_5);

    C("LAST FRAME TRANSMITTED ");
    PI(0x01);

    /* Poll for Trickbox Tx FIFO fill level for end of 1st invalid frame
       transmission */
    PO(AACITB_TxFFillLevel39, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRXWT_6);
 
    C("FIRST INVALID FRAME TRANSMITTED "); 
    PI(0x01);

    /* Poll for Trickbox Tx FIFO fill level for end of 2nd invalid frame
       transmission */
    PO(AACITB_TxFFillLevel26, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRXWT_7);
 
    C(" SECOND INVALID FRAME TRANSMITTED ");
    PI(0x01);
   }
 else
   {
    C("WRITING 2 INVALID FRAME IN TRICKBOX ")
    FrameWrite(Channel_1, 0x0, Mode | RSize);
    FrameWrite(Channel_1, 0x0, Mode | RSize);

    /* Poll for Trickbox Tx FIFO fill level for end of 5th frame 
       transmission */
    PO(AACITB_TxFFillLevel65, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRXWT_9);

    C("FOURTH and FIFTH FRAME TRANSMITTED ");
    PI(0x01);

    /* Poll for Trickbox Tx FIFO fill level for end of 6th frame 
    transmission */
    PO(AACITB_TxFFillLevel52, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRXWT_10); 

    C("SIXTH FRAME TRANSMITTED ");
    PI(0x01);
 
    /* Poll for Trickbox Tx FIFO fill level for end of 7th frame  
       transmission */
    PO(AACITB_TxFFillLevel39, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRXWT_11);
 
    C("SEVENTH FRAME TRANSMITTED ");

    /* Poll for Trickbox Tx FIFO fill level for end of last frame 
       transmission */
    PO(AACITB_TxFFillLevel26, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRXWT_12);

    C(" LAST VALID FRAME TRANSMITTED ");
    PI(0x01);

     C("WRITING 2 INVALID FRAMES IN TRICKBOX ")
     FrameWrite(Channel_1, 0x0, Mode | RSize);
     FrameWrite(Channel_1, 0x0, Mode | RSize); 
   
     /* Poll for Trickbox Tx FIFO fill level for end of 2nd invalid
        frame transmission */
     PO(AACITB_TxFFillLevel26, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRXWT_14);

     C(" TWO INVALID FRAME TRANSMITTED ");
     PI(0x01);
    }/* End of else, for Non Compact Mode */

 C("WRITING INVALID FRAME IN TRICKBOX ");
 FrameWrite(Channel_1, 0x0, Mode | RSize);

 /* Poll for Trickbox Tx FIFO fill level for end of third invalid
    frame transmission */
 PO(AACITB_TxFFillLevel12, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMABRXWT_15);

 C("THIRD INVALID FRAME TRANSMITTED "); 

 /* Disable Transmission */
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);

 /* Poll for Trickbox Tx FIFO fill level for end of last invalid frame
    transmission */
 PO(AACITB_TxFFillLevel0, MASK_TxFFFillLevel, AACITrFIFOStat,512 * One_BitClk_Period,DMABRXWT_16);

 C("LAST INVALID FRAME TRANSMITTED ");
 
 /* Verify that DMABREQRX is set */
 PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_17);

 /* Disable AACI Reception */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | TOC);

 C("READ FIRST FRAME ");
 RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
 
 /* Verify that DMABREQRX is set */
 PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_18);
 
 /* Assert DMACLRRX signal */
 PSW(AACI_DMACLRRX, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 /* Verify that DMABREQRX is cleared */
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_19);
 
 /* Deassert DMACLRRX signal */
 PSW(0x0, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 /* Verify that DMABREQRX is set */
 PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_20);
 
 C("READ SECOND FRAME ");
 RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
 
 /* Verify that DMABREQRX is set */
 PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_21);
 
 /* Assert DMACLRRX Signal */
 PSW(AACI_DMACLRRX, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 /* Verify that DMABREQRX is cleared */
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_22);
 
 /* Deassert DMACLRRX signal */
 PSW(0x0, AACITrDMAReg);
 PI(One_BitClk_Period);

 if (Mode == AACI_CM)
    /* Verify that DMABREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_23);
 else
    /* Verify that DMABREQRX is set */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_24);
 
 if (Mode != AACI_CM )
   {
    /* 3rd Read */
 
    C(" READ THIRD FRAME ");
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
   
    /* Verify that DMABREQRX is set */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_25);
    
    /* Assert DMACLRRX Signal */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_26);
   
    /* Deassert DMACLRRX Signal */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX is set */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_27);
   
    C(" READ FOURTH FRAME ");
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
   
    /* Verify that DMABREQRX is set */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_28);
   
    /* Assert DMACLRRX Signal */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
    
    /* Verify that DMABREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_29);
   
    /* Deassert DMACLRRX Signal */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX is set */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_30);

    C(" READ THE FIFTH FRAME ");
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
   
    /* Verify that DMABREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_31);
    
    /* Assert DMACLRRX Signal */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_32);
   
    /* Deassert DMACLRRX Signal */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_33);
   
    C(" READ THE SIXTH FRAME ");
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
   
    /* Verify that DMABREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_34);
   
    /* Assert DMACLRRX Signal */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_35);
   
    /* Deassert DMACLRRX Signal */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_35);
   } /* End of if, for Non Compact Mode */

 C(" READ THE SECOND LAST FRAME ");
 RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
 
 /* Verify that DMABREQRX is cleared */
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_36);
 
 /* Assert DMACLRRX Signal */
 PSW(AACI_DMACLRRX, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 /* Verify that DMABREQRX is cleared */
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_37);
 
 /* Deassert DMACLRRX Signal */
 PSW(0x0, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 /* Verify that DMABREQRX is cleared */
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_38);

 C(" READ LAST FRAME ");
 RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
 
 /* Verify that DMABREQRX is cleared */
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_39);
 
 /* Assert DMACLRRX Signal */
 PSW(AACI_DMACLRRX, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 /* Verify that DMABREQRX is cleared */
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_40);
 
 /* Deassert DMACLRRX Signal */
 PSW(0x0, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 /* Verify that DMABREQRX is cleared */
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMABRXWT_41);

 /* Disable Trickbox enable bit */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 /* Clear DMA Enable and FIFO Enable Bit */
 PSW(0x0, AACIMAINCR );
 
 C("END OF DMA BURST RECEIVE REQUREST WITH TIMEOUT TEST ");
}

/**********************************************************************/
/****************** DMA Last Burst Receive Request ********************/
/**********************************************************************/
void DMALBREQRXTest(int32 ChModeSizeFen)
{
 /*
   Summary: DMALBREQRX Test
   ========================
    The Rx FIFO of the AACI is enabled. The TOC bit field of AACIRXCR is
   written with 4 (timeout after 4 frames). The AACIRXCR1 register is 
   programmed for reception of slots 3, 4, 5, 6, 7, 8, 10 and 12. The Tx
   FIFO in the trickbox is filled with valid data for 8 slots and with 
   invalid data for the other slots in the 1st frame. Then the trickbox
   is allowed to transmit data. After the completion of the first frame,
   eight data words are expected to be present in the Rx FIFO .
   Subsequent frames transmitted from the Trickbox are invalid frames
   that do not result in any further data being written to the Rx FIFO
   of the AACI. When the AACI receives Slot12 of the fourth invalid
   frame, it is expected to raise the RxTimeout Interrupt. Then 
   RxTimeout bit in the AACISR1 register is read to verify that the
   RxTimeout interrupt has been raised. The DMALBREQRX bit in the
   AACITrDMAReg register is tested for a '0'. Then one by one three data
   are read from Rx FIFO of the AACI and after each read, the
   DMALBREQRX bit in the AACITrDMAReg register is tested for a '0'.
   After reading the fourth data, the DMALSREQRX signal should be
   asserted. This is verified by reading the AACITrDMAReg register.
   Data is read out one word at a time from the Rx FIFO of the AACI.
   After each read, the DMALSREQRX signal is checked for a '1'.
   Asserting DMACLRRX signal is expected to clear this DMA request.
*/

 int32 ChValidSlot; 
 int32 Mode, RSize, TOC;
 int   One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 int   i;
 
 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;
 
 /* Extract Compact Mode information */
 Mode   = ChModeSizeFen & MASK_MODE;

 /* Extract RSize information */
 RSize  = ChModeSizeFen & MASK_TSIZE;

 ChValidSlot = AACI_RX3 | AACI_RX4 | AACI_RX5 | AACI_RX6 |  AACI_RX7 | AACI_RX8 | AACI_RX10 | AACI_RX12;

 C(" START OF DMA LAST BURST RECEIVE REQUEST  TEST");

 /* Enabling the DMA in the main control register */
 PSW(AACI_AACIIFE | AACI_DMAEN, AACIMAINCR);
 
 /* Configure AACIRXCR1 for eight Slots and timeout count = 4 */
 TOC = 0x4;
 TOC = TOC << 17;
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | TOC );

 C("WRITING VALID FRAME IN TRICKBOX");
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize | TOC );

 /* Write 5 Invalid Frame */
 C("WRITING FIVE INVALID FRAME ");
 FrameWrite(Channel_1, 0x0, Mode | RSize );
 FrameWrite(Channel_1, 0x0, Mode | RSize );
 FrameWrite(Channel_1, 0x0, Mode | RSize );
 FrameWrite(Channel_1, 0x0, Mode | RSize );
 FrameWrite(Channel_1, 0x0, Mode | RSize );
 C("FIVE INVALID FRAMES ARE WRITTEN ");

 /* Enabling the reception of the channel 1 and enabling FIFO */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | AACI_REN | TOC);
 
 /* Enabling the trickbox for transmission */
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_BtClkRst | AACITB_TxEn , AACITrCntlReg);
 
 /* Poll for Trickbox Tx FIFO fill level for end 1st frame
    transmission */
 PO(AACITB_TxFFillLevel65, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALBRX_1);

 C("FIRST FRAME TRANSMITTED ");
 PI(0x01);

 /* Poll for Trickbox Tx FIFO fill level for end of 1st invalid frame 
    transmission */
 PO(AACITB_TxFFillLevel52, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALBRX_2);

 C("FIRST INVALID FRAME TRANSMITTED ");
 PI(0x01);
 
 /* Poll for Trickbox Tx FIFO fill level for end of 2nd invalid frame 
    transmission */
 PO(AACITB_TxFFillLevel39, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALBRX_3);

 C("SECOND INVALID FRAME TRANSMITTED ");
 PI(0x01);
 
 /* Poll for Trickbox Tx FIFO fill level for end of 3rd invalid frame 
    transmission */
 PO(AACITB_TxFFillLevel26, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALBRX_4);

 C("THIRD INVALID FRAME TRANSMITTED ");
 PI(0x01);
 
 /* Poll for Trickbox Tx FIFO fill level for end of 4th invalid frame 
    transmission */
 PO(AACITB_TxFFillLevel12, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALBRX_5);

 C("FOURTH INVALID FRAME TRANSMITTED ");
 PI(0x01);

 /* Disable Transmission */
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);
 
 /* Poll for Trickbox Tx FIFO fill level for end of last invalid frame 
    transmission */
 PO(AACITB_TxFFillLevel0, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALBRX_6);

 C("LAST INVALID FRAME TRANSMITTED ");

 /* Disable AACI Reception */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | TOC);
 
 /* Confirming that the RxTimeout status bit is set */
 PSR(AACI_TIMEOUT, AACI_TIMEOUT, AACISR1,DMALBRX_7);

 if (Mode == AACI_CM)
   {
    /* Read 2 data */
    ChValidSlot = AACI_RX3 | AACI_RX4;
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
 
    /* Verify that DMABREQRX is set and DMALBREQRX is cleared */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_8);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_9);
 
    /* Clearing of the all the request signals by asserting DMACLRRX */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
 
    /* Verify that DMABREQRX and DMALBREQRX are cleared */
    PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALBRX_10);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALBRX_11);
 
    /* Deassert DMACLRRX */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
 
    /* Verify that DMABREQRX is set and DMALBREQRX is cleared */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_12);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_13);

    /* Read 2 data */
    ChValidSlot = AACI_RX5 | AACI_RX6;
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
   
    /* Verify that DMABREQRX is set and DMALBREQRX is cleared */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_14);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_15);
   
    /* Clearing of the all the request signals by asserting DMACLRRX */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX and DMALBREQRX are cleared */
    PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALBRX_16);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALBRX_17);
   
    /* Deassert DMACLRRX */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX is set and DMALBREQRX is cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_18);
    PSR(AACI_DMALBREQRX, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_19);
   
    /* Read 2 data */
    ChValidSlot = AACI_RX7 | AACI_RX8;
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
   
    /* Verify that DMABREQRX is cleared and DMALBREQRX is set */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_20);
    PSR(AACI_DMALBREQRX, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_21);
   
    /* Read 2 data */
    ChValidSlot = AACI_RX10 | AACI_RX12;
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
   
    /* Verify that DMABREQRX is cleared and DMALBREQRX is set */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_22);
    PSR(AACI_DMALBREQRX, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_23);
   
    /* Clearing of the all the request signals by asserting DMACLRRX */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX and DMALBREQRX are cleared */
    PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALBRX_24);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALBRX_25);
   
    /* Deassert DMACLRRX */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX & DMALBREQRX are cleared */
    PSR(0x0, AACI_DMABREQRX,  AACITrDMAReg,DMALBRX_26);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_27);
   } /* End of if, for Compact Mode */ 
 else 
   {
    /* Read 1 data */
    ChValidSlot = AACI_RX3;
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
   
    /* Verify that DMABREQRX is set and DMALBREQRX is cleared */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_28);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_29);
   
    /* Clearing of the all the request signals by asserting DMACLRRX */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX and DMALBREQRX are cleared */
    PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALBRX_30);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALBRX_31);
   
    /* Deassert DMACLRRX */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX is set and DMALBREQRX is cleared */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_32);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_33);
   
    /* Read 1 data */
    ChValidSlot = AACI_RX4;
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
   
    /* Verify that DMABREQRX is set and DMALBREQRX is cleared */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_34);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_35);
   
    /* Clearing of the all the request signals by asserting DMACLRRX */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX and DMALBREQRX are cleared */
    PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALBRX_36);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALBRX_37);
   
    /* Deassert DMACLRRX */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX is set and DMALBREQRX is cleared */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_38);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_39);
   
    /* Read 1 data */
    ChValidSlot = AACI_RX5;
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
   
    /* Verify that DMABREQRX is set and DMALBREQRX is cleared */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_40);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_41);
   
    /* Clearing of the all the request signals by asserting DMACLRRX */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX and DMALBREQRX are cleared */
    PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALBRX_42);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALBRX_43);
   
    /* Deassert DMACLRRX */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX is set and DMALBREQRX is cleared */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_44);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_45);
   
    /* Read 1 data */
    ChValidSlot = AACI_RX6;
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
   
    /* Verify that DMABREQRX is set and DMALBREQRX is cleared */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_46);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_47);
   
    /* Clearing of the all the request signals by asserting DMACLRRX */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX and DMALBREQRX are cleared */
    PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALBRX_48);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALBRX_49);
   
    /* Deassert DMACLRRX */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX is cleared and DMALBREQRX is set */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_50);
    PSR(AACI_DMALBREQRX, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_51);
   
    /* Read 1 data */
    ChValidSlot = AACI_RX7;
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
   
    /* Verify that DMABREQRX is cleared and DMALBREQRX is set */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_52);
    PSR(AACI_DMALBREQRX, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_53);
   
    /* Read 1 data */
    ChValidSlot = AACI_RX8;
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
   
    /* Verify that DMABREQRX is cleared and DMALBREQRX is set */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_54);
    PSR(AACI_DMALBREQRX, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_55);
  
    /* Read 1 data */
    ChValidSlot = AACI_RX10;
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
   
    /* Verify that DMABREQRX is cleared and DMALBREQRX is set */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_56);
    PSR(AACI_DMALBREQRX, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_57);
   
    /* Read 1 data */
    ChValidSlot = AACI_RX12;
    RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
   
    /* Verify that DMABREQRX is cleared and DMALBREQRX is set */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_58);
    PSR(AACI_DMALBREQRX, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_59);
   
    /* Clearing of the all the request signals */
    PSW(AACI_DMACLRRX, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX and DMALBREQRX are cleared */
    PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALBRX_60);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALBRX_61);
   
    /* Deassert DMACLRRX */
    PSW(0x0, AACITrDMAReg);
    PI(One_BitClk_Period);
   
    /* Verify that DMABREQRX & DMALBREQRX are cleared */
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMALBRX_62);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMALBRX_63);
   } /* End of else, for Non Compact Mode */
 /* Disable Trickbox enable bit */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 /* Disable AACIFE bit */
 PSW(0x0, AACIMAINCR);
 
 C(" DMA LAST BURST RECEIVE REQUEST TEST IS OVER "); 
}

/**********************************************************************/
/**************** DMA Disable Test ************************************/
/**********************************************************************/
void DMADisableTest(int32 ChModeSizeFen, int32 ChValidSlot)
{
 /*
   Summary: DMA Disable Test
   =========================
   In this function, DMA Enable bit is not enabled. Trickbox is filled
   with four valid frame. Data is allowed to transmission. After every 
   reception of data, DMASREQRX and DMABREQRX is checked for '0'.
   when all data are transmitted, transmission & reception is disabled.
   Now data is read one by one. Each time DMASREQRX and DMABREQRX is 
   checked for '0'. 
 */
 
 int32 Mode, RSize;
 int   One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 int   i;
 
 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
   One_BitClk_Period = 0x2;
 
 C(" START OF DMA DISABLE TEST  ");

 /* Extract Compact Mode information */
 Mode  = ChModeSizeFen & MASK_MODE;

 /* Extract RSIZE information */
 RSize = ChModeSizeFen & MASK_TSIZE;

 /* Enable AACIFE bit with DMA Disable  */
 PSW(AACI_AACIIFE, AACIMAINCR);
 
 /* Configure AACIRXCR1 for required number of slots */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen);
 
 /* Verify that DMASREQRX is cleared */
 PSR(0x0, AACI_DMASREQRX, AACITrDMAReg, DMADIST_1);

 C("FILL TRICKBOX TX FIFO WITH 4 FRAMES ");
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
 C("FOUR VALID FRAMES ARE WRITTEN ");

 /* Write an extra frame into the Trickbox Tx FIFO to avoid the AACI
    going to Idle state */
 FrameWrite(Channel_1, 0x80000, Mode | RSize);

 /* Enable Trickbox Transmission and AACI Reception */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | AACI_REN);
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_TxEn | AACITB_BtClkRst, AACITrCntlReg);

 C("TRANSMISSION AND RECEPTION ENABLED ");

 /* Poll for Trickbox Tx FIFO fill level for end of 1st frame
    transmission */
 PO(AACITB_TxFFillLevel52, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMADIST_2);

 C("FIRST FRAME TRANSMITTED ");

 /* Verify that DMASREQRX and DMABREQRX are cleared */
 PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMADIST_3);
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMADIST_4); 
   
 /* Poll for Trickbox Tx FIFO fill level for end of 2nd frame
    transmission */
 PO(AACITB_TxFFillLevel39, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMADIST_5);

 C("SECOND FRAME TRANSMITTED ");

 /* Verify that DMASREQRX and DMABREQRX are cleared */
 PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMADIST_6);
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMADIST_7);

 /* Poll for Trickbox Tx FIFO fill level for end of 3rd frame
    transmission */
 PO(AACITB_TxFFillLevel26, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMADIST_8);

 C("THIRD FRAME TRANSMITTED ");

 /* Verify that DMASREQRX and DMABREQRX are cleared */
 PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMADIST_9);
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMADIST_10);

 /* Poll for Trickbox Tx FIFO fill level for end of 4th frame
    transmission */
 PO(AACITB_TxFFillLevel12, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMADIST_11);

 C("FOURTH FRAME TRANSMITTED ");

 /* Verify that DMASREQRX and DMABREQRX are cleared */
 PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMADIST_12);
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMADIST_13); 

 /* Disable Trickbox Transmission */
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);

 /* Poll for Trickbox Tx FIFO fill level for end of last frame
    transmission */
 PO(AACITB_TxFFillLevel0, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMADIST_14);

 C("ALL FRAMES TRANSMITTED "); 

 /* Disable AACI Reception */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen);

 C("TRANSMISSION AND RECEPTION IS DISABLED ");
 
 /* Verify that DMASREQRX, DMABREQRX and DMALBREQRX are cleared */
 PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMADIST_15);
 PSR(0x0, AACI_DMABREQRX,  AACITrDMAReg,DMADIST_16);
 PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMADIST_17);

 /* Read First Frame */
 RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
 C("FIRST FRAME READ ");

 /* Verify that DMASREQRX, DMABREQRX and DMALBREQRX are cleared */
 PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMADIST_18);
 PSR(0x0, AACI_DMABREQRX,  AACITrDMAReg,DMADIST_19); 
 PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMADIST_20);
 
 /* Read Second Frame */ 
 RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
 C("SECOND FRAME READ ");
 
 /* Verify that all DMA receive request signals are cleared */
 PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMADIST_21);
 PSR(0x0, AACI_DMABREQRX,  AACITrDMAReg,DMADIST_22);
 PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMADIST_23);
 PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMADIST_24);

 /* Read Third Frame */ 
 RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);
 C("THIRD FRAME READ ");
 
 /* Verify that all DMA receive request signals are cleared */
 PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMADIST_25);
 PSR(0x0, AACI_DMABREQRX,  AACITrDMAReg,DMADIST_26);
 PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMADIST_27);
 PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMADIST_28);

 /* Read Fourth Frame */ 
 RxFIFORd(Channel_1,ChValidSlot, ChModeSizeFen);
 C("FOURTH FRAME READ ");
 
 /* Verify that all DMA receive request signals are cleared */
 PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMADIST_29);
 PSR(0x0, AACI_DMABREQRX,  AACITrDMAReg,DMADIST_30);
 PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMADIST_31);
 PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMADIST_32); 

 /* Set DMA Enable bit  */
 PSW(AACI_AACIIFE | AACI_DMAEN, AACIMAINCR);

 PI(3); 

 /* Verify that DMABREQTX is set */
 PSR(AACI_DMABREQTX, AACI_DMABREQTX,  AACITrDMAReg,DMADIST_33);

 /* Clear DMA Enable Bit */

 PSW(AACI_AACIIFE, AACIMAINCR);
 
 PI(3);

 /* Verify that DMABREQTX is cleared */
 PSR(0x0, AACI_DMABREQTX,  AACITrDMAReg,DMADIST_34);

 /* Disable Trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 /* Clear FIFO Enable Bit */
 PSW(0x0, AACIMAINCR );
 
 C("END OF DMA DISABLE TEST ");
}

/**********************************************************************/
/********* DMA Last Single Receive Request test in Character Mode *****/
/**********************************************************************/
void DMALSChar(int32 ChModeSizeFen)
{
 /*
   Summary: DMALSREQRX in Character Mode  
   ===================================
   This function checks functionality of DMA Last Receive Request
   in Character Mode.

   The test sequence is as follows : 
   o  The DMAEnable bit is disabled.

   o  The Rx FIFO is enabled for the slot 3 for channel 1 and the TOC
      field in the AACIRXCR1 register is loaded with 4.

   o  The trickbox Tx FIFO is filled with 1 valid slot for the
      first frame and then for the subsequent frames the trickbox is
      filled with invalid data's for 5 frames. 

   o  Data transmission from trickbox and reception into the AACI is
      enabled.
 
   o  At the end of the 5th frame reception, the RxTimeout status bit
      is checked.
 
   o  Data transmission from trickbox and reception into the AACI is
      disabled.

   o  The DMA Single and Last Single Request are checked for clear.
  
   o  The DMAEnable bit is set.

   o  The DMA Last Single Receive checked for '1' and DMA Single
      Receive is checked for '0'.

   o  Data word is read from Rx FIFO of AACI. The DMA Last Single
      Receive checked for '1' and DMA Single Receive is checked for '0'.

   o  After DMACLRRX signal is asserted and deasserted, the DMA Single
      and Last Single Request are checked for clear. 
 */

 int32 ChValidSlot;
 int32 Mode, RSize, TOC;
 int   One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 int   i;
 
 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;
 
 /* Extract Compact Mode information */
 Mode  = ChModeSizeFen & MASK_MODE;

 /* Extract RSIZE information */
 RSize = ChModeSizeFen & MASK_TSIZE;

 C(" START OF DMA LAST SINGLE RECEIVE REQUEST TEST WITH DMA DISABLE ");
 
 /* Disable the DMA in the main control register */
 PSW(AACI_AACIIFE , AACIMAINCR);
 
 /* Configure AACIRXCR1 for four Slots and timeout count = 4 */
 TOC = 0x4;
 TOC = TOC << 17;
 ChValidSlot = AACI_RX3;
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | TOC);

 /* Write First Frame */
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize | TOC);
 
 /* Write 5 Invalid Frame */
 C("WRITING FIVE INVALID FRAME ");
 FrameWrite(Channel_1, 0x0, Mode | RSize);
 FrameWrite(Channel_1, 0x0, Mode | RSize);
 FrameWrite(Channel_1, 0x0, Mode | RSize);
 FrameWrite(Channel_1, 0x0, Mode | RSize);
 FrameWrite(Channel_1, 0x0, Mode | RSize);
 C("FIVE INVALID FRAMES ARE WRITTEN ");
 
 /* Enabling the reception of the channel 1 and FIFO enable */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | AACI_REN | TOC);
 
 /* Enabling the trickbox for transmission */
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_BtClkRst | AACITB_TxEn, AACITrCntlReg);

 /* Poll for Trickbox Tx FIFO fill level for end of 1st frame 
    transmission */
 PO(AACITB_TxFFillLevel65, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALSChar_1);

 C("FIRST FRAME TRANSMITTED ");
 PI(0x01);

 /* Poll for Trickbox Tx FIFO fill level for end of 1st invalid frame
    transmission */
 PO(AACITB_TxFFillLevel52, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALSChar_2);

 C("FIRST INVALID FRAME TRANSMITTED ");
 PI(0x01);
 
 /* Poll for Trickbox Tx FIFO fill level for end of 2nd invalid frame
    transmission */
 PO(AACITB_TxFFillLevel39, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALSChar_3);

 C("SECOND INVALID FRAME TRANSMITTED ");
 PI(0x01);
 
 /* Poll for Trickbox Tx FIFO fill level for end of 3rd invalid frame
    transmission */
 PO(AACITB_TxFFillLevel26, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALSChar_4);

 C("THIRD INVALID FRAME TRANSMITTED ");
 PI(0x01);
 
 /* Poll for Trickbox Tx FIFO fill level for end of 4th invalid frame
    transmission */
 PO(AACITB_TxFFillLevel12, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALSChar_5);

 C("FOURTH INVALID FRAME TRANSMITTED ");
 PI(0x01);
 
 /* Disable Trickbox Transmission */
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);
 
 /* Poll for Trickbox Tx FIFO fill level for end of last invalid frame
    transmission */
 PO(AACITB_TxFFillLevel0, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMALSChar_6);

 C("LAST INVALID FRAME TRANSMITTED ");
 
 /* Disable Reception */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | TOC);
 
 /* Confirming that the RxTimeout status bit is set */
 PSR(AACI_TIMEOUT, AACI_TIMEOUT, AACISR1,DMALSChar_7);   

 /* Verify that DMA Single And Last Single Request are cleared */
 PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALSChar_8);
 PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALSChar_9); 

 /* Enable DMA bit */
 PSW(AACI_AACIIFE | AACI_DMAEN, AACIMAINCR);

 /* Verify that DMASREQRX is cleared & DMALSREQRX is set */
 PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALSChar_10); 
 PSR(AACI_DMALSREQRX, AACI_DMALSREQRX, AACITrDMAReg,DMALSChar_11); 

 /* Read the data from the AACI Rx FIFO*/
 RxFIFORd(Channel_1, ChValidSlot, ChModeSizeFen);

 /* Verify that DMASREQRX is cleared & DMALSREQRX is set */
 PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALSChar_12); 
 PSR(AACI_DMALSREQRX, AACI_DMALSREQRX, AACITrDMAReg,DMALSChar_13); 

 /* Clearing of all the DMA receive request signals by asserting
    DMACLRRX */
 PSW(AACI_DMACLRRX, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 /* Verify that DMASREQRX & DMALSREQRX are cleared */
 PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALSChar_14);
 PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALSChar_15);
 
 /* Deasserting DMACLRRX */
 PSW(0x0, AACITrDMAReg);
 PI(One_BitClk_Period);
 
 /* Verify that DMASREQRX & DMALSREQRX are cleared */
 PSR(0x0, AACI_DMASREQRX,  AACITrDMAReg,DMALSChar_16);
 PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMALSChar_17);
 
 /* Disable Trickbox bit */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);
 
 /* Disable AACIFE bit */
 PSW(0x0, AACIMAINCR);
 
 C(" END OF DMA LAST SINGLE RECEIVE REQUEST TEST WITH DMA DISABLE");
}

/**********************************************************************/
/********************** DMA with AACIFE Disable ***********************/
/**********************************************************************/
void DMAACIFEDisable(int32 ChModeSizeFen, int32 ChValidSlot )
{
 /*
   Summary: DMA AACIFE Disable Test
   ================================
   This function checks the functionality of the DMA when AACIFE is
   disabled. 

   The AACIRXCR1 register of the AACI is programmed for valid slots
   indicated by ChValidSlot. When Rx FIFO is empty, the DMASREQRX, 
   DMABREQRX, DMALSREQRX, DMALBREQRX  bit is checked for a '0'and 
   DMABREQTX is checked for '1'. The AACI is allowed to receive four
   data frames from the trickbox. After every frame, all DMA request
   signal is checked for expected value depending on fill level.
   When all frames are received, trickbox transmission and AACI
   reception is disabled. The AACIFE bit is cleared and all DMA
   request are checked for '0'. Once again AACIFE bit is set. All DMA 
   receive signal i.e. DMASREQRX, DMABREQRX, DMALSREQRX, DMALBREQRX bit 
   is checked for a '0'and DMABREQTX is checked for '1'. 
 */

 int32 Mode, RSize, Size;
 int   One_BitClk_Period = AACIBITCLK_PERIOD / PCLK_PERIOD;
 int   SlotFill=0 , i ;
 int32 SlotMask = 0x02;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
    One_BitClk_Period = 0x1;

 /* Extract Compact Mode information */
 Mode  = ChModeSizeFen & MASK_MODE;

 /* Extract RSIZE information */
 RSize  = ChModeSizeFen & MASK_TSIZE;
 Size = RSize >>13;

 C(" START OF DMA WITH AACIFE BIT DISABLE TEST ");

 /* Compute the point at which the DMA request is to be checked based
    on the fill level */
 for (i = 1 ; i < 13 ; i++)
   {
    if (ChValidSlot & SlotMask)
      SlotFill = i;
    SlotMask = SlotMask << 1 ;
   }
 SlotFill = SlotFill << 16; 

 /* Enable DMA Enable & AACIFE bit */
 PSW(AACI_AACIIFE | AACI_DMAEN , AACIMAINCR);

 /* Configure AACIRXCR1 to receive required number of slot */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen);

 /* Verify that DMABREQRX is cleared */
 PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMAAACIFEDis_1);
 PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMAAACIFEDis_2);
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMAAACIFEDis_3);
 PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMAAACIFEDis_4);
 PSR(AACI_DMABREQTX, AACI_DMABREQTX, AACITrDMAReg,DMAAACIFEDis_67);

 C("WRITE FOUR FRAME IN TRICKBOX ");
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
 FrameWrite(Channel_1, ChValidSlot, Mode | RSize);

 if (Mode != AACI_CM )
   {
    C("WRITE ANOTHER FOUR FRAME IN TRICKBOX ");
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
    FrameWrite(Channel_1, ChValidSlot, Mode | RSize);
   }

 /* Enable Trickbox Transmission and AACI Reception */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen | AACI_REN);
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_TxEn | AACITB_BtClkRst, AACITrCntlReg);

 if (Mode == AACI_CM)
   {
    /* Poll for Trickbox Tx FIFO fill level for end of valid slots
       in 1st frame transmission */
    PO(AACITB_TxFFillLevel52 -SlotFill , MASK_TxFFFillLevel,AACITrFIFOStat, 512 * One_BitClk_Period,DMAAACIFEDis_5);
 
    C("FIRST FRAME VALID SLOTS TRANSMITTED ");
    PI(0x01);
   
    /* Verify that DMABREQRX is cleared */
    PO(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,40* One_BitClk_Period,DMAAACIFEDis_6);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMAAACIFEDis_7);
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMAAACIFEDis_8);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMAAACIFEDis_9); 

    /* Wait for 2nd  Frame Transmission */
    PO(AACITB_TxFFillLevel39 -SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMAAACIFEDis_10);
   
    C("SECOND FRAME VALID SLOTS TRANSMITTED ");
    /* Verify that DMABREQRX is set */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMAAACIFEDis_11); 
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMAAACIFEDis_12);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMAAACIFEDis_13);
    PO(AACI_DMABREQRX, AACI_DMABREQRX,AACITrDMAReg, 40 * One_BitClk_Period,DMAAACIFEDis_14);
   } /* End of if, for Compact Mode */
 else 
   { 
    /* Poll for Trickbox Tx FIFO fill level for end of valid slots
       in 1st frame transmission */
    PO(AACITB_TxFFillLevel104 -SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMAAACIFEDis_15);
 
    C("FIRST FRAME VALID SLOTS TRANSMITTED ");
    PI(0x01);   

    /* Verify that DMABREQRX is cleared */
     PO(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,40* One_BitClk_Period,DMAAACIFEDis_16);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMAAACIFEDis_17);
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMAAACIFEDis_18);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMAAACIFEDis_19);

    /* Poll for Trickbox Tx FIFO fill level for end of valid slots
       in 2nd frame transmission */
    PO(AACITB_TxFFillLevel91 -SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMAAACIFEDis_20);
 
    C("SECOND FRAME VALID SLOTS TRANSMITTED ");

    /* Verify that DMABREQRX is cleared */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMAAACIFEDis_21);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMAAACIFEDis_22);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMAAACIFEDis_23);
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMAAACIFEDis_24);

    /* Poll for Trickbox Tx FIFO fill level for end of valid slots
       in 3rd frame transmission */
    PO(AACITB_TxFFillLevel78 - SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMAAACIFEDis_25); 
     
    C("THIRD FRAME TRANSMITTED ");

    /* Verify that DMABREQRX is cleared */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMAAACIFEDis_26);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMAAACIFEDis_27);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMAAACIFEDis_28);
    PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMAAACIFEDis_29); 

    /* Poll for Trickbox Tx FIFO fill level for end of valid slots
       in 4th frame transmission */
    if (PCLK_PERIOD > AACIBITCLK_PERIOD)
      PO(AACITB_TxFFillLevel52, MASK_TxFFFillLevel, AACITrFIFOStat,512 *One_BitClk_Period,DMAAACIFEDis_30);
    else
      PO(AACITB_TxFFillLevel65- SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period ,DMAAACIFEDis_31);
     
    C("FOURTH FRAME VALID SLOTS TRANSMITTED ");

    /* Verify that DMABREQRX is set */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMAAACIFEDis_32);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMAAACIFEDis_33);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMAAACIFEDis_34);
    PO(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg, 40 * One_BitClk_Period,DMAAACIFEDis_35);
    PI(0x01);   

    /* Poll for Trickbox Tx FIFO fill level for end of valid slots
       in 5th frame transmission */
    if (PCLK_PERIOD > AACIBITCLK_PERIOD)
       PO(AACITB_TxFFillLevel39, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMAAACIFEDis_36); 
    else
       PO(AACITB_TxFFillLevel52 - SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMAAACIFEDis_37); 
  
    C("FIFTH FRAME VALID SLOTS TRANSMITTED ");

    /* Verify that DMABREQRX is set */
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMAAACIFEDis_38);

    /* Poll for Trickbox Tx FIFO fill level for end of valid slots
       in 6th frame transmission */
    if (PCLK_PERIOD > AACIBITCLK_PERIOD)
       PO(AACITB_TxFFillLevel26, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMAAACIFEDis_39);
    else
       PO(AACITB_TxFFillLevel39 - SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMAAACIFEDis_40);
  
    C("SIXTH FRAME VALID SLOTS TRANSMITTED ");

    /* Verify that DMABREQRX is set */
    PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMAAACIFEDis_41);
    PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMAAACIFEDis_42);
    PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMAAACIFEDis_43); 
    PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMAAACIFEDis_44);
   } /* End of else, for Non Compact Mode */
  
 FrameWrite(Channel_1, 0x80000, Mode | RSize); 

 /* Poll for Trickbox Tx FIFO fill level for end of valid slots
    in next frame transmission */
 if (PCLK_PERIOD > AACIBITCLK_PERIOD)
    PO(AACITB_TxFFillLevel12, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMAAACIFEDis_45); 
 else              
    PO(AACITB_TxFFillLevel26-SlotFill, MASK_TxFFFillLevel, AACITrFIFOStat, 512 * One_BitClk_Period,DMAAACIFEDis_46);

 C("SECOND LAST FRAME VALID SLOTS TRANSMITTED ");

 /* Verify that DMABREQRX is set */
 PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMAAACIFEDis_47);
 PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMAAACIFEDis_48);
 PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMAAACIFEDis_49);
 PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMAAACIFEDis_50);

 if (PCLK_PERIOD <= AACIBITCLK_PERIOD)
    PO(AACITB_TxFFillLevel12, MASK_TxFFFillLevel, AACITrFIFOStat, AACITrFIFOStat, 512 * One_BitClk_Period,DMAAACIFEDis_51); 

 /* Disable Trickbox Transmission */
 PSW(AACITB_En | AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);

 /* Poll for Trickbox Tx FIFO fill level for end of valid slots
    in last frame transmission */
 PO(AACITB_TxFFillLevel0,MASK_TxFFFillLevel, AACITrFIFOStat,256 * One_BitClk_Period,DMAAACIFEDis_52);
 PI(24 * One_BitClk_Period);

 C(" LAST FRAME VALID SLOTS TRANSMITTED ");   

 /* Verify that DMABREQRX is set */
  PSR(AACI_DMASREQRX, AACI_DMASREQRX, AACITrDMAReg,DMAAACIFEDis_53);
  PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMAAACIFEDis_54);
  PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMAAACIFEDis_55);
  PSR(AACI_DMABREQRX, AACI_DMABREQRX, AACITrDMAReg,DMAAACIFEDis_56);

 /* Disable AACI Reception */
 ConfigRxCR(Channel_1, ChValidSlot | ChModeSizeFen);

 /* Disable Trickbox */
 PSW(AACITB_BtClkRst | AACITB_BtClkEn, AACITrCntlReg);

 /* Disable AACIFE bit */
 PSW(AACI_DMAEN, AACIMAINCR);

 PI(One_BitClk_Period);

 /* Verify that DMABREQRX is cleared */
 PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMAAACIFEDis_57);
 PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMAAACIFEDis_58);
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMAAACIFEDis_59);
 PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMAAACIFEDisDMAAACIFEDis_60);
 PSR(0x0, AACI_DMABREQTX, AACITrDMAReg,DMAAACIFEDis_61);
 /* Enable once again AACIFE bit */
 PSW(AACI_AACIIFE | AACI_DMAEN , AACIMAINCR);
 /* Verify that DMABREQRX is cleared */
 PSR(0x0, AACI_DMASREQRX, AACITrDMAReg,DMAAACIFEDis_62);
 PSR(0x0, AACI_DMALSREQRX, AACITrDMAReg,DMAAACIFEDis_63);
 PSR(0x0, AACI_DMABREQRX, AACITrDMAReg,DMAAACIFEDis_64);
 PSR(0x0, AACI_DMALBREQRX, AACITrDMAReg,DMAAACIFEDis_65);
 PSR(AACI_DMABREQTX, AACI_DMABREQTX, AACITrDMAReg,DMAAACIFEDis_66);
 
 /* Disable AACIFE bit */
 PSW(0x0, AACIMAINCR);

 C(" END OF DMA WITH AACIFE BIT DISABLE TEST ");
}
