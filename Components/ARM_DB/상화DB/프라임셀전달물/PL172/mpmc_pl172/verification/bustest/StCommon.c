/*-- --=======================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : StCommon.c.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           It is a common file which has functions used by different test
--           cases. 
--
-- --=======================================================================--*/
int32 MPMCTrMEMBData[8] = {0x0000, 0x0000, 0x0000, 0x0000,
                          0x0000, 0x0000, 0x0000, 0x0000};

int ENDIANNESS;
/******************************************************************************/
/******************************** StInitProc **********************************/
/******************************************************************************/
void StInitProc(
                int bank,int mw,int pm, int pc, int pb, int ew, int rdbufen,
                int wrbufen, int wrprot,int StWtWen, int StWtOen,int StWtRd,
                int StWtPg, int StWtWr, int StWtTurn, int StExdDel
               )
  /*
     Summary: StInitProc
     ===================
     This function performs the following functionality
 
     o  This function initializes configuration registers of all 4 memory banks.
        
     o  These registers are modified only when MPMC is disabled.
  */
{
  unsigned long StConfig, MPMCStConfig, MPMCStWtWen, MPMCStWtOen,MPMCStWtRd,
                MPMCStWtPg, MPMCStWtWr, MPMCStWtTurn, MPMCStExdDel;
  StConfig = wrprot << 20 | wrbufen << 19 | rdbufen << 18 | ew << 8 | pb << 7 |
             pc << 6 | pm << 3 | mw;  
  if(bank == 0)
  {
    MPMCStConfig = MPMCStConfig0;
    MPMCStWtWen  = MPMCStWtWen0;
    MPMCStWtOen  = MPMCStWtOen0;
    MPMCStWtRd   = MPMCStWtRd0;
    MPMCStWtPg   = MPMCStWtPg0;
    MPMCStWtWr   = MPMCStWtWr0;
    MPMCStWtTurn = MPMCStWtTurn0; 
  }
  else if(bank == 1)
  {
    MPMCStConfig = MPMCStConfig1;
    MPMCStWtWen  = MPMCStWtWen1;
    MPMCStWtOen  = MPMCStWtOen1;
    MPMCStWtRd   = MPMCStWtRd1;
    MPMCStWtPg   = MPMCStWtPg1;
    MPMCStWtWr   = MPMCStWtWr1;
    MPMCStWtTurn = MPMCStWtTurn1; 
  }
  else if(bank == 2)
  {
    MPMCStConfig = MPMCStConfig2;
    MPMCStWtWen  = MPMCStWtWen2;
    MPMCStWtOen  = MPMCStWtOen2;
    MPMCStWtRd   = MPMCStWtRd2;
    MPMCStWtPg   = MPMCStWtPg2;
    MPMCStWtWr   = MPMCStWtWr2;
    MPMCStWtTurn = MPMCStWtTurn2; 
  }
  else if(bank == 3)
  {
    MPMCStConfig = MPMCStConfig3;
    MPMCStWtWen  = MPMCStWtWen3;
    MPMCStWtOen  = MPMCStWtOen3;
    MPMCStWtRd   = MPMCStWtRd3;
    MPMCStWtPg   = MPMCStWtPg3;
    MPMCStWtWr   = MPMCStWtWr3;
    MPMCStWtTurn = MPMCStWtTurn3; 
  }

  HSA(MPMCDyCntl, NSEQ, INCR, OK, WRD);
  HSW(,0x00000003);
  MPMCDisable();

  HSA(MPMCStWtWen,NSEQ, INCR, OK, WRD);
  HSW(, StWtWen, ,MPMCStWtWenWr);

  HSA(MPMCStWtOen,NSEQ, INCR, OK, WRD);
  HSW(, StWtOen, ,MPMCStWtOenWr);

  HSA(MPMCStWtRd,NSEQ, INCR, OK, WRD);
  HSW(, StWtRd, ,MPMCStWtRdWr);

  HSA(MPMCStWtPg,NSEQ, INCR, OK, WRD);
  HSW(, StWtPg, ,MPMCStWtPgWr);

  HSA(MPMCStWtWr,NSEQ, INCR, OK, WRD);
  HSW(, StWtWr, ,MPMCStWtWrWr);

  HSA(MPMCStWtTurn,NSEQ, INCR, OK, WRD);
  HSW(, StWtTurn, ,MPMCStWtTurnWr);

  HSA(MPMCStExdWt,NSEQ, INCR, OK, WRD);
  HSW(, StExdDel, ,MPMCStWtExdDelWr);

  HSA(MPMCStConfig,NSEQ, INCR, OK, WRD);
  HSW(, StConfig, ,MPMCStConfigWr);

  MPMCEnable();
}
/******************************************************************************/
/***************************** AHBWriteMem ************************************/
/******************************************************************************/
void AHBWriteMem(int BankNo, int32 Offset, int BlockSize, int32 StartData)
{
  /*
     Summary: Write into Memory through AHB side
     ===========================================
     This performs performs the following :

     o  Writes into the Memory bank 'BankNo' through the AHB side.
     o  Starts from 'Offset' away from the Base Address.
     o  Fills 'BlockSize' number of words.
     o  Starting from 'StartData', the memory is filled in an incrementing
        fashion (i.e. StartData, StartData+1, StartData+2, ..).
  */
    
  int i;
  int32 AHBAddr;

  switch(BankNo)
  {
    case 0 : AHBAddr = MPMCTrMEMR_0 + (Offset); break;
    case 1 : AHBAddr = MPMCTrMEMR_1 + (Offset); break;
    case 2 : AHBAddr = MPMCTrMEMR_2 + (Offset); break;
    case 3 : AHBAddr = MPMCTrMEMR_3 + (Offset); break;
  }

  BlockSize--;
  HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , StartData++);
  for (i=0; i<BlockSize; i++)
    HSW( , StartData++);
}
/******************************************************************************/
/****************************** TrickMemInit **********************************/
/******************************************************************************/
void TrickMemInit(
                   int bank,int mw,int pm, int pc, int pb, int ew, int rdbufen,
                   int wrbufen, int wrprot,int StWtWen, int StWtOen,int StWtRd,
                   int StWtPg, int StWtWr, int StWtTurn,int StMemb,
                   int cspol 
                 )
  /*
    Summary: TrickMemInit
    =====================
    This test performs the functionalities

    o  This function initializes the trick memory registers when controller
       is initialized.
  */
  {
   unsigned long MPMCTrMEMT, MemType, MPMCTrCS2Wen, MPMCTrCS2Oen,MPMCTrCS2Rd,
                MPMCTrWtPg, MPMCTrCS2Wr, MPMCTrIDCY,MPMCTrMEMB,MPMCTrCSPOL;
   MemType = ((ew << 8) & 0x100) | ((pc << 7) & 0x80) | ((pb << 6) & 0x40) |
             ((pm << 3) & 0x8) | ((wrprot << 2) & 0x4) | mw; 
   if(bank == 0)
   {
     MPMCTrMEMT    = MPMCTrMEMT_0; 
     MPMCTrCS2Wen  = MPMCTrCS2Wen_0;
     MPMCTrCS2Oen  = MPMCTrCS2Oen_0;
     MPMCTrCS2Rd   = MPMCTrCS2Rd_0;
     MPMCTrWtPg    = MPMCTrWtPg_0;
     MPMCTrCS2Wr   = MPMCTrCS2Wr_0;
     MPMCTrIDCY    = MPMCTrIDCY_0;
     MPMCTrMEMB    = MPMCTrMEMB_0;
     MPMCTrCSPOL   = MPMCTrCSPOL_0;
   }
   else if(bank == 1)
   {
     MPMCTrMEMT    = MPMCTrMEMT_1;
     MPMCTrCS2Wen  = MPMCTrCS2Wen_1;
     MPMCTrCS2Oen  = MPMCTrCS2Oen_1;
     MPMCTrCS2Rd   = MPMCTrCS2Rd_1;
     MPMCTrWtPg    = MPMCTrWtPg_1;
     MPMCTrCS2Wr   = MPMCTrCS2Wr_1;
     MPMCTrIDCY    = MPMCTrIDCY_1;
     MPMCTrMEMB    = MPMCTrMEMB_1;
     MPMCTrCSPOL   = MPMCTrCSPOL_1;
   }
   else if(bank == 2)
   {
     MPMCTrMEMT    = MPMCTrMEMT_2;
     MPMCTrCS2Wen  = MPMCTrCS2Wen_2;
     MPMCTrCS2Oen  = MPMCTrCS2Oen_2;
     MPMCTrCS2Rd   = MPMCTrCS2Rd_2;
     MPMCTrWtPg    = MPMCTrWtPg_2;
     MPMCTrCS2Wr   = MPMCTrCS2Wr_2;
     MPMCTrIDCY    = MPMCTrIDCY_2;
     MPMCTrMEMB    = MPMCTrMEMB_2;
     MPMCTrCSPOL   = MPMCTrCSPOL_2;
   }
   else if(bank == 3)
   {
     MPMCTrMEMT    = MPMCTrMEMT_3;
     MPMCTrCS2Wen  = MPMCTrCS2Wen_3;
     MPMCTrCS2Oen  = MPMCTrCS2Oen_3;
     MPMCTrCS2Rd   = MPMCTrCS2Rd_3;
     MPMCTrWtPg    = MPMCTrWtPg_3;
     MPMCTrCS2Wr   = MPMCTrCS2Wr_3;
     MPMCTrIDCY    = MPMCTrIDCY_3;
     MPMCTrMEMB    = MPMCTrMEMB_3;
     MPMCTrCSPOL   = MPMCTrCSPOL_3;
   }

   HSA(MPMCTrMEMT,NSEQ, INCR, OK, WRD);
   HSW(, MemType, ,MPMCTrMEMTWr);

   HSA(MPMCTrCS2Wen,NSEQ, INCR, OK, WRD);
   HSW(, StWtWen, ,MPMCTrCS2WenWr);

   HSA(MPMCTrCS2Oen,NSEQ, INCR, OK, WRD);
   HSW(, StWtOen, ,MPMCTrCS2OenWr);

   HSA(MPMCTrCS2Rd,NSEQ, INCR, OK, WRD);
   HSW(, StWtRd, ,MPMCTrCS2RdWr);

   HSA(MPMCTrWtPg,NSEQ, INCR, OK, WRD);
   HSW(, StWtPg, ,MPMCTrWtPgWr);

   HSA(MPMCTrCS2Wr,NSEQ, INCR, OK, WRD);
   HSW(, StWtWr, ,MPMCTrCS2WrWr);

   HSA(MPMCTrIDCY,NSEQ, INCR, OK, WRD);
   HSW(, StWtTurn, ,MPMCTrIDCYWr);
 
   HSA(MPMCTrMEMB,NSEQ, INCR, OK, WRD);
   HSW(, StMemb, ,MPMCTrMEMBWr);
   
   HSA(MPMCTrCSPOL, NSEQ, INCR, OK, WRD);
   HSW(, cspol, ,MPMCTrCSPOLWr);
}
/******************************************************************************/
/******************************* BurstWrite ***********************************/
/******************************************************************************/
void BurstWrite(int BankNo, int Burst, int32 Offset, int hsize, int msize,
                    int32 Data)
{
  /*
     Summary: Burst Write-Read
     =========================
     This performs the following:

     o  Writes to a Memory location through the MPMC and verifies through both
        the MPMC and AHB Read.
  */

  int32 MemAddr, AHBAddr, AHBRdData1, AHBRdData2, AHBRdData3, AHBRdData4;
  int32 TempData, TestData, ReadMask,TmpData0,TmpData1,TmpData2,TmpData3;
  char size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};
  char* SizeStr[3] = {"BYTE", "HALFWORD", "WORD"};
  char* MsizeStr[3] = {"BYTE", "HALFWORD", "WORD"};
  char* BurstStr[8] = {"SINGLE", "INCR", "INCR4", "INCR8", "INCR16", "WRAP4",
                       "WRAP8", "WRAP16"};
  char PrintStr[75];
  
  int Shift[3] = {8, 16, 32};
  int32 Mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int i, BeatsNo,k,sh;

  switch(BankNo)
  {
    case 0 : MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_0 + (Offset << (2-msize)); break;
    case 1 : MemAddr = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_1 + (Offset << (2-msize)); break;
    case 2 : MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_2 + (Offset << (2-msize)); break;
    case 3 : MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_3 + (Offset << (2-msize)); break;
    default: MemAddr = Offset;break;
  }

  switch(Burst)
  {
    case 0 : BeatsNo = 1;  break;
    case 1 : BeatsNo = 1;  break;
    case 2 : BeatsNo = 4;  break;
    case 3 : BeatsNo = 8;  break;
    case 4 : BeatsNo = 16; break;
    case 5 : BeatsNo = 4;  break;
    case 6 : BeatsNo = 8;  break;
    case 7 : BeatsNo = 16; break;
  }

  debug_info("Address is");
  sprintf(PrintStr,"%X",MemAddr);
  debug_info(PrintStr);
  sprintf(PrintStr,
          "Does Burst Write with HSIZE = %s, MSIZE = %s, BURST = %s",
          SizeStr[hsize], MsizeStr[msize], BurstStr[Burst]);
  C(PrintStr);

  /** Writing via MPMC **/
  debug_info("Writing via MPMC");
  TempData = Data;
  if (ENDIANNESS == 0)
  {
    TestData = TempData & Mask[hsize];
  } else
  {
    if(msize == 0)
    {
      if(hsize == 0)
        TestData = ((TempData << 24) & 0xFF000000);
      else if(hsize == 1)
      {
        TmpData0 = TempData;
        TmpData1 = TempData;
        TestData = (((TmpData0 & 0x000000FF) << 24)|  
                    ((TmpData1 & 0x0000FF00) << 8));
      }
      else
      {
        TmpData0 = TempData;
        TmpData1 = TempData;
        TmpData2 = TempData;
        TmpData3 = TempData;
        TestData = (((TmpData0 & 0x000000FF) << 24)|
                     ((TmpData1 & 0x0000FF00) << 8)|
                     ((TmpData2 & 0x00FF0000) >> 8)|
                     (TmpData3 & 0xFF000000) >> 24);
      }
    }
    if(msize == 1)
    {
      if(hsize == 0)
      {
        TestData = ((TempData & 0x000000FF) << 24);
      }
      else if(hsize == 1)
      {
        TestData = (TempData & 0x0000FFFF);
        TestData = TestData << 16;
      }
      else
      {
        TmpData0 = TempData;
        TmpData1 = TempData;
        TestData = (((TmpData0 & 0x0000FFFF) << 16)|
                    ((TmpData1 & 0xFFFF0000) >> 16));
      }
    }
    if(msize == 2)
    {
      if(hsize == 0)
        TestData = ((TempData & 0x000000FF)<< 24);
      else if(hsize == 1)
        TestData = ((TempData & 0x0000FFFF)<< 16);
      else 
        TestData = TempData;
    }  
  }

  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
  HSW( , TestData);
  for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      TestData = TempData & Mask[hsize];
    } else
    {
      if(msize == 0)
      {
        if(hsize == 0)
          TestData = (TempData << (3-i%4)*Shift[hsize]) &
                     (Mask[hsize] <<(3-i%4)*Shift[hsize]);
        else if(hsize == 1)
        {
          TmpData0 = TempData;
          TmpData1 = TempData;
          TmpData2 = (((TmpData0 & 0x000000FF) << 8)|  
                    ((TmpData1 & 0x0000FF00) >> 8));
          TestData = TmpData2 << ((3-i%4)*Shift[hsize]);
        }
      else if(hsize == 2)
          TestData = (((TempData & 0x000000FF) << 24)|
                     ((TempData & 0x0000FF00) << 8)|
                     ((TempData & 0x00FF0000) >> 8)|
                     (TempData & 0xFF000000)>> 24);
    }
    else if(msize == 1)
    {
      if(hsize == 0)
      {
        sh = (3 - i);
        TestData = (TempData << (sh*Shift[hsize]));
      }
      else if(hsize == 1)
      {
        TestData = (TempData & 0x0000FFFF);
        TestData = TestData << ((3-i%4)*Shift[hsize]);
      }
      else
        TestData = (((TempData & 0x0000FFFF) << 16) |
                    ((TempData & 0xFFFF0000) >> 16));
     }
     else if(msize == 2)
     {
       if(hsize == 0)
       /*  TestData = (TempData << (3-i%4)*Shift[hsize]) &
                     (Mask[hsize] << (3-i%4)*Shift[hsize]);  */
           TestData = (TempData & i*Shift[hsize]) &
                     (Mask[hsize] << i*Shift[hsize]);
       else if(hsize == 1)
       {
         TmpData0 = TempData;
         TmpData1 = TempData;
         TestData = ((TmpData0 & 0x000000FF)|
                    (TmpData1 & 0x0000FF00));
         TestData = TestData << ((3-i%4)*Shift[hsize]);
       }
       else
         TestData = TempData; 
     }
   }
    HSW( , TestData);
  }
}
/******************************************************************************/
/******************************** BurstRead ***********************************/
/******************************************************************************/
void BurstRead(int BankNo, int Burst, int32 Offset, int hsize, int msize,
                    int32 Data)  
{
  /*
     Summary : BurstRead
     ===================
     o It reads the data back depending on the type of burst, hsize values
       passed to this function.

     o It also checks for the data integrity.
  */
  int32 MemAddr, AHBAddr, AHBRdData1, AHBRdData2, AHBRdData3, AHBRdData4;
  int32 TempData, TestData, ReadMask,TempData1;
  int32 TmpData0,TmpData1,TmpData2,TmpData3;
  char size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};
  char* MsizeStr[3] = {"BYTE", "HALFWORD", "WORD"};
  char* SizeStr[3] = {"BYTE", "HALFWORD", "WORD"};
  char* BurstStr[8] = {"SINGLE", "INCR", "INCR4", "INCR8", "INCR16", "WRAP4",
                       "WRAP8", "WRAP16"};
  char PrintStr[75];
  int Shift[3] = {8, 16, 32};
  int32 Mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int i, BeatsNo,sh;

  switch(BankNo)
  {
    case 0 : MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_0 + (Offset << (2-msize)); break;
    case 1 : MemAddr = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_1 + (Offset << (2-msize)); break;
    case 2 : MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_2 + (Offset << (2-msize)); break;
    case 3 : MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_3 + (Offset << (2-msize)); break;
    default: MemAddr = Offset;break;
  }

  switch(Burst)
  {
    case 0 : BeatsNo = 1;  break;
    case 1 : BeatsNo = 1;  break;
    case 2 : BeatsNo = 4;  break;
    case 3 : BeatsNo = 8;  break;
    case 4 : BeatsNo = 16; break;
    case 5 : BeatsNo = 4;  break;
    case 6 : BeatsNo = 8;  break;
    case 7 : BeatsNo = 16; break;
  }

  sprintf(PrintStr,
          "Does Burst Reads with HSIZE = %s, MSIZE = %s, BURST = %s",
          SizeStr[hsize], MsizeStr[msize], BurstStr[Burst]);
  C(PrintStr);
   /** Reading via MPMC **/
 debug_info("Reading via MPMC");
 TempData = Data;
 if (ENDIANNESS == 0)
 {
   ReadMask = Mask[hsize];
   TestData = TempData & ReadMask;
 }
 else
 {
   if(msize == 0)
   {
     if(hsize == 0)
     {
       ReadMask = (Mask[hsize] << 3*Shift[hsize]);
       TestData = (TempData << 24) & ReadMask;
     }
     else if(hsize == 1)
     {
       ReadMask = (Mask[hsize] << 3*Shift[hsize]);
       TestData = (((TempData & 0x0000FF00) >> 8) |
                   (TempData & 0x000000FF)<<8);
       TestData = (TestData << 16) & 0xFFFF0000;
     }
     else if(hsize == 2)
     {
       ReadMask = (Mask[hsize] << 3*Shift[hsize]);
       TempData1 = (((TempData & 0xFF000000)>>24)|
                    ((TempData & 0x00FF0000) >> 8)|
                    ((TempData & 0x0000FF00) << 8)|
                    ((TempData & 0x000000FF) << 24));
       TestData = TempData1;
     }
   }
   else if(msize == 1)
   {
     if(hsize == 0)
     {
       ReadMask = (Mask[hsize] << 16);
       TestData = (TempData << 16) & ReadMask;
     }
     else if(hsize == 1)
     {
       TestData = (TempData << 16) & 0xFFFF0000;
       ReadMask = (Mask[hsize] << 3*Shift[hsize]);
     }
     else if(hsize == 2)
     {
       TestData = (((TempData & 0x0000FFFF) << 16) |
                   ((TempData & 0xFFFF0000) >> 16));
       ReadMask = (Mask[hsize] << 3*Shift[hsize]);
     }
   }
   else
   {
      TestData = TempData;
      ReadMask = (Mask[hsize]);
   }
 }

 WaitLoop(0x3);
 HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
 HSR( , TestData, , ReadMask, ,BurstWriteRead_1);
 for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
 {
   if (ENDIANNESS == 0)
   {
     ReadMask = (Mask[hsize] << i*Shift[hsize]);
     TestData = (TempData << i*Shift[hsize]) & ReadMask;
   }
   else
   {
      if(msize == 0)
      {
         if(hsize == 0)
         {
           ReadMask = (Mask[hsize] << (3-i%4)*Shift[hsize]);
           TestData = (TempData << ((3-i%4)*Shift[hsize])) & ReadMask;
         }
         else if(hsize == 1)
         {
           TmpData0 = TempData;
           TmpData1 = TempData;
           ReadMask = (Mask[hsize] << (3- i%4)*Shift[hsize]);
           TmpData2 = ((TmpData0 & 0x0000FF00) >> 8);
           TmpData3 = ((TmpData1 & 0x000000FF) << 8);
           TempData1 = TmpData2 | TmpData3;
           TestData = (TempData1 << (3-i%4)*Shift[hsize]) & ReadMask;
         }
         else if(hsize == 2)
         {
           TmpData0 = TempData;
           TmpData1 = TempData;
           TmpData2 = TempData;
           TmpData3 = TempData;
           ReadMask = (Mask[hsize] << (3-i%4)*Shift[hsize]);
           TempData1 = (((TmpData0 & 0xFF000000)>>24)|
                        ((TmpData1 & 0x00FF0000) >> 8)|
                        ((TmpData2 & 0x0000FF00) << 8)|
                        ((TmpData3 & 0x000000FF) << 24));
           TestData = TempData1;
         }
       }
       else if(msize == 1)
       {
         if(hsize == 0)
         {
           ReadMask = (Mask[hsize] << (((2+i)%4)*Shift[hsize]));
           TestData = (TempData << (((2+i)%4)*Shift[hsize])) & ReadMask;
         }
         else if(hsize == 1)
         {
           ReadMask = (Mask[hsize] << (3-i%4)*Shift[hsize]);
           TestData = (TempData << (3-i%4)*Shift[hsize]) & ReadMask;
         }
         else if(hsize == 2)
         {
           TmpData0 = TempData;
           TmpData1 = TempData;
           TestData = (((TmpData0 & 0x0000FFFF) << 16) |
                       ((TmpData1 & 0xFFFF0000) >> 16));
           TestData = (TestData << (3-i%4)*Shift[hsize]) & ReadMask;
         }
       }
       else
       {
          ReadMask = (Mask[hsize] << i*Shift[hsize]);
          TestData = (TempData << i*Shift[hsize]) & ReadMask;;
       }
   }
   HSR( , TestData, , ReadMask, ,BurstWriteRead_2);
  }
}

/******************************************************************************/
/******************************* CSPolWriteRead *******************************/
/******************************************************************************/
void CSPolWriteRead(int BankNo, int Burst, int32 Offset, int hsize, int msize,
                    int32 Data,int bufen)
{
  /*
     Summary: Burst Write-Read
     =========================
     This performs performs the following:

     o  Writes to a Memory location through the MPMC and verifies through both
        the MPMC and AHB Read.
  */
  int MPMCTrMEMBData[4] = { 0x0000,0x0000,0x0000,0x0000};
  int32 MemAddr, AHBAddr, AHBRdData1, AHBRdData2, AHBRdData3, AHBRdData4;
  int32 TempData, TestData, ReadMask;
  char size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};
  char* SizeStr[3] = {"BYTE", "HALFWORD", "WORD"};
  char* BurstStr[8] = {"SINGLE", "INCR", "INCR4", "INCR8", "INCR16", "WRAP4",
                       "WRAP8", "WRAP16"};
  char PrintStr[75];
  int Shift[3] = {8, 16, 32};
  int32 Mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int i, BeatsNo;

  switch(BankNo)
  {
    case 0 : MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + Offset;break;
    case 1 : MemAddr = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + Offset;break;
    case 2 : MemAddr = MEM2_BASE +  (MPMCTrMEMBData[2] << 11) + Offset;  break;
    case 3 : MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11) + Offset;break;
  }

  switch(Burst)
  {
    case 0 : BeatsNo = 1;  break;
    case 1 : BeatsNo = 1;  break;
    case 2 : BeatsNo = 4;  break;
    case 3 : BeatsNo = 8;  break;
    case 4 : BeatsNo = 16; break;
    case 5 : BeatsNo = 4;  break;
    case 6 : BeatsNo = 8;  break;
    case 7 : BeatsNo = 16; break;
  }

  sprintf(PrintStr,
          "Does Burst Write-Reads with HSIZE = %s, MSIZE = %s, BURST = %s",
           SizeStr[hsize], SizeStr[msize], BurstStr[Burst]);
  C(PrintStr);

  /** Writing via MPMC **/
  debug_info("Writing via MPMC");
  TempData = Data;
  if (ENDIANNESS == 0)
  {
    TestData = TempData & Mask[hsize];
  } 
  else
  {
    TestData = (TempData << 3*Shift[hsize]) &
               (Mask[hsize] << 3*Shift[hsize]);
  }

  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
  HSW( , TestData);
  for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      TestData = TempData & Mask[hsize];
    }
    else
    {
      TestData = (TempData << (3-i%4)*Shift[hsize]) &
                 (Mask[hsize] << (3-i%4)*Shift[hsize]);
    }
    HSW( , TestData);
  }
  /* If write buffer is enabled insert idle cycle so that data will be flushed
     to memory */ 
  if(bufen == 1)
    WaitLoop(0x10); 
 /** Reading via MPMC **/
 debug_info("Reading via MPMC");
  TempData = Data;
  if (ENDIANNESS == 0)
  {
    ReadMask = Mask[hsize];
    TestData = TempData & ReadMask;
  } else
  {
    ReadMask = (Mask[hsize] << 3*Shift[hsize]);
    TestData = (TempData << 3*Shift[hsize]) & ReadMask;
  }

  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
  HSR( , TestData, , ReadMask, ,BurstWriteRead_1);
  for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      ReadMask = (Mask[hsize] << i*Shift[hsize]);
      TestData = (TempData << i*Shift[hsize]) & ReadMask;
    } else
    {
      ReadMask = (Mask[hsize] << (3-i%4)*Shift[hsize]);
      TestData = (TempData << (3-i%4)*Shift[hsize]) & ReadMask;
    }
    HSR( , TestData, , ReadMask, ,BurstWriteRead_2);
  }
}
/******************************************************************************/
/******************************* BurstWrRd ***********************************/
/******************************************************************************/
void BurstWrRd(int BankNo, int Burst, int32 Offset, int hsize, int msize,
                    int32 Data)
{
  /*
     Summary: Burst Write-Read
     =========================
     This performs performs the following:

     o  Writes to a Memory location through the MPMC and verifies through
        the MPMC.
  */

  int32 MemAddr, AHBAddr, AHBRdData1, AHBRdData2, AHBRdData3, AHBRdData4;
  int32 TempData, TestData, ReadMask;
  int32 OrgMemAddr;
  char size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};
  char* SizeStr[3] = {"BYTE", "HALFWORD", "WORD"};
  char* BurstStr[8] = {"SINGLE", "INCR", "INCR4", "INCR8", "INCR16", "WRAP4",
                       "WRAP8", "WRAP16"};
  char PrintStr[75];
  int Shift[3] = {8, 16, 32};
  int32 Mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int i, BeatsNo,incr,temp, incr1;

  switch(BankNo)
  {
    case 0 : MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_0 + (Offset << (2-msize)); break;
    case 1 : MemAddr = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_1 + (Offset << (2-msize)); break;
    case 2 : MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_2 + (Offset << (2-msize)); break;
    case 3 : MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_3 + (Offset << (2-msize)); break;
    default: MemAddr = Offset; break;
  }

  switch(Burst)
  {
    case 0 : BeatsNo = 50;  break;
    case 1 : BeatsNo = 50;  break;
    case 2 : BeatsNo = 4;  break;
    case 3 : BeatsNo = 8;  break;
    case 4 : BeatsNo = 16; break;
    case 5 : BeatsNo = 4;  break;
    case 6 : BeatsNo = 8;  break;
    case 7 : BeatsNo = 16; break;
  }
  sprintf(PrintStr,
         "Does Burst Write-Reads with HSIZE = %s, MSIZE = %s, BURST = %s",
          SizeStr[hsize], SizeStr[msize], BurstStr[Burst]);
    C(PrintStr);
  /** Writing via MPMC **/
  debug_info("Writing via MPMC");
  TempData = Data;
  if (ENDIANNESS == 0)
  {
    TestData = TempData & Mask[hsize];
  } 
  else
  {
    TestData = (TempData << 3*Shift[hsize]) &
               (Mask[hsize] << 3*Shift[hsize]);
  }

  OrgMemAddr = MemAddr;
  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
  HSW( , TestData);
  for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      TestData = TempData & Mask[hsize];
    } else
    {
      TestData = (TempData << (3-i%4)*Shift[hsize]) &
                 (Mask[hsize] << (3-i%4)*Shift[hsize]);
    }
    if(Burst == 0)
    {
     MemAddr = AddrGenLogic(MemAddr, hsize, beat[Burst]);
     HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
     HSW( , TestData++);
    }
    else
    {
     MemAddr = AddrGenLogic(MemAddr, hsize, beat[Burst]);
     HSA(MemAddr, SEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
     HSW( , TestData++);
    }
  }
  if(hsize == 0)
    incr = 1;
  else if(hsize == 1)
    incr = 2;
  else
    incr = 4;
  MemAddr = OrgMemAddr + (BeatsNo * incr); 
  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
  HSW( , TestData++);
  for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      TestData = TempData & Mask[hsize];
    } else
    {
      TestData = (TempData << (3-i%4)*Shift[hsize]) &
                 (Mask[hsize] << (3-i%4)*Shift[hsize]);
    }
    if(Burst == 0)
    {
     MemAddr = AddrGenLogic(MemAddr, hsize, beat[Burst]);
     HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
     HSW( , TestData++);
    }
    else
    {
     MemAddr = AddrGenLogic(MemAddr, hsize, beat[Burst]);
     HSA(MemAddr, SEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
     HSW( , TestData++);
    }
  }
  /** Reading via MPMC **/
  debug_info("Reading via MPMC");
  TempData = Data;
  if (ENDIANNESS == 0)
  {
    ReadMask = Mask[hsize];
    TestData = TempData & ReadMask;
  } else
  {
    ReadMask = (Mask[hsize] << 3*Shift[hsize]);
    TestData = (TempData << 3*Shift[hsize]) & ReadMask;
  }
  WaitLoop(0x3);
  MemAddr = OrgMemAddr;
  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
  HSR( , TestData, , ReadMask, ,BurstWriteRead_1);
  for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      ReadMask = (Mask[hsize] << i*Shift[hsize]);
      TestData = (TempData << i*Shift[hsize]) & ReadMask;
    } else
    {
      ReadMask = (Mask[hsize] << (3-i%4)*Shift[hsize]);
      TestData = (TempData << (3-i%4)*Shift[hsize]) & ReadMask;
    }
    if(Burst == 0)
    {
     MemAddr = AddrGenLogic(MemAddr, hsize, beat[Burst]);
     HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
     HSR( , TestData, , ReadMask, ,BurstWriteRead_2);
    }
    else
    {
       MemAddr = AddrGenLogic(MemAddr, hsize, beat[Burst]);
       HSA(MemAddr, SEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
       HSR( , TestData, , ReadMask, ,BurstWriteRead_2);
    }
  }
  MemAddr = OrgMemAddr + (BeatsNo * incr); 
  ReadMask = Mask[hsize] << ((BeatsNo%4)*Shift[hsize]);
  TestData = (TempData<<(BeatsNo%4)*Shift[hsize]) & ReadMask;
  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
  HSR( , TestData, , ReadMask, ,BurstWriteRead_1);
  for (i = BeatsNo + 1, TempData++; i < (2*BeatsNo); i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      ReadMask = (Mask[hsize] << i*Shift[hsize]);
      TestData = (TempData << i*Shift[hsize]) & ReadMask;
    } else
    {
      ReadMask = (Mask[hsize] << (3-i%4)*Shift[hsize]);
      TestData = (TempData << (3-i%4)*Shift[hsize]) & ReadMask;
    }
    if(Burst == 0)
    {
     MemAddr = AddrGenLogic(MemAddr, hsize, beat[Burst]);
     HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
     HSR( , TestData, , ReadMask, ,BurstWriteRead_2);
    }
    else
    {
     MemAddr = AddrGenLogic(MemAddr, hsize, beat[Burst]);
     HSA(MemAddr, SEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
     HSR( , TestData, , ReadMask, ,BurstWriteRead_2);
    }
   }
}
/******************************************************************************/
/****************************** BigBurstWrRd **********************************/
/******************************************************************************/
void BigBurstWrRd(int BankNo, int Burst, int32 Offset, int hsize, int msize,
                    int32 Data)
{
  /*
     Summary: Big Endian Burst Write-Read
     ====================================
     This performs performs the following:

     o  Writes to a Memory location in Big Endian through the MPMC and verifies
        by reading back the data.
  */

  int32 MemAddr, AHBAddr, AHBRdData1, AHBRdData2, AHBRdData3, AHBRdData4;
  int32 TempData, TestData, ReadMask;
  int32 OrgMemAddr;
  char size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};
  char* SizeStr[3] = {"BYTE", "HALFWORD", "WORD"};
  char* BurstStr[8] = {"SINGLE", "INCR", "INCR4", "INCR8", "INCR16", "WRAP4",
                       "WRAP8", "WRAP16"};
  char PrintStr[75];
  int Shift[3] = {8, 16, 32};
  int32 Mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int i, BeatsNo,incr,temp;

  switch(BankNo)
  {
    case 0 : MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_0 + (Offset << (2-msize)); break;
    case 1 : MemAddr = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_1 + (Offset << (2-msize)); break;
    case 2 : MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_2 + (Offset << (2-msize)); break;
    case 3 : MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_3 + (Offset << (2-msize)); break;
    default: MemAddr = Offset; break;
  }

  switch(Burst)
  {
    case 0 : BeatsNo = 50;  break;
    case 1 : BeatsNo = 50;  break;
    case 2 : BeatsNo = 4;  break;
    case 3 : BeatsNo = 8;  break;
    case 4 : BeatsNo = 16; break;
    case 5 : BeatsNo = 4;  break;
    case 6 : BeatsNo = 8;  break;
    case 7 : BeatsNo = 16; break;
  }
  sprintf(PrintStr,
    "Does BigEndian Burst operation  with HSIZE = %s, MSIZE = %s, BURST = %s",
          SizeStr[hsize], SizeStr[msize], BurstStr[Burst]);
  C(PrintStr);
  /** Writing via MPMC **/
  debug_info("Writing via MPMC");
  TempData = Data;
  TestData = (TempData << 3*Shift[hsize]) &
               (Mask[hsize] << 3*Shift[hsize]);

  OrgMemAddr = MemAddr;
  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
  HSW( , TestData);
  for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
  {
      TestData = (TempData << (3-i%4)*Shift[hsize]) &
                 (Mask[hsize] << (3-i%4)*Shift[hsize]);
      HSW( , TestData++);
  }
  if(hsize == 0)
    incr = 1;
  else if(hsize == 1)
    incr = 2;
  else
    incr = 4;
  /** Reading via MPMC **/
  debug_info("Reading via MPMC");
  TempData = Data;
  ReadMask = (Mask[hsize] << 3*Shift[hsize]);
  TestData = (TempData << 3*Shift[hsize]) & ReadMask;
  WaitLoop(0x3);
  MemAddr = OrgMemAddr;
  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
  HSR( , TestData, , ReadMask, ,BurstWriteRead_1);
  for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
  {
      ReadMask = (Mask[hsize] << (3-i%4)*Shift[hsize]);
      TestData = (TempData << (3-i%4)*Shift[hsize]) & ReadMask;
      HSR( , TestData, , ReadMask, ,BurstWriteRead_2);
  }
}
/******************************************************************************/
/**************************** Reading via MPMC ********************************/
/******************************************************************************/
 ReadDataBack(int BankNo, int Burst, int32 Offset, int hsize, int msize,
              int32 Data)
 {
   /*
      Summary : ReadDataBack
      ======================
      It does the following functionality
      o It reads the data back according to the parameters burst, size passed
        to this function.
 
      o It also checks for the data integrity.
   */
    int32 MemAddr, AHBAddr, AHBRdData1, AHBRdData2, AHBRdData3, AHBRdData4;
    int32 TempData, TestData, ReadMask;
    int32 OrgMemAddr;
    char size[3] = {'b', 'h', 'w'};
    char* beat[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};
    char* SizeStr[3] = {"BYTE", "HALFWORD", "WORD"};
    char* BurstStr[8] = {"SINGLE", "INCR", "INCR4", "INCR8", "INCR16", "WRAP4",
                         "WRAP8", "WRAP16"};
    char PrintStr[75];
    int Shift[3] = {8, 16, 32};
    int32 Mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
    int i, BeatsNo,incr,temp;
    debug_info("Reading via MPMC");
    switch(BankNo)
    {
      case 0 : MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + Offset;break;
      case 1 : MemAddr = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + Offset;break;
      case 2 : MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11) + Offset;break;
      case 3 : MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11) + Offset;break;
      default: MemAddr = Offset;break;
    }
    switch(Burst)
    {
      case 0 : BeatsNo = 50;  break;
      case 1 : BeatsNo = 50;  break;
      case 2 : BeatsNo = 4;  break;
      case 3 : BeatsNo = 8;  break;
      case 4 : BeatsNo = 16; break;
      case 5 : BeatsNo = 4;  break;
      case 6 : BeatsNo = 8;  break;
      case 7 : BeatsNo = 16; break;
    }
    TempData = Data;
    if (ENDIANNESS == 0)
    {
      ReadMask = Mask[hsize];
      TestData = TempData & ReadMask;
    } 
    else
    {
      ReadMask = (Mask[hsize] << 3*Shift[hsize]);
      TestData = (TempData << 3*Shift[hsize]) & ReadMask;
    }
    WaitLoop(0x3);
    HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
    HSR( , TestData, , ReadMask, ,BurstWriteRead_1);
    for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
    {
      if (ENDIANNESS == 0)
      {
        ReadMask = (Mask[hsize] << i*Shift[hsize]);
        TestData = (TempData << i*Shift[hsize]) & ReadMask;
      } 
      else
      {
        ReadMask = (Mask[hsize] << (3-i%4)*Shift[hsize]);
        TestData = (TempData << (3-i%4)*Shift[hsize]) & ReadMask;
      }
      HSR( , TestData, , ReadMask, ,BurstWriteRead_2);
    }
  }
/******************************************************************************/
/***************************** LockedBurstWrRd ********************************/
/******************************************************************************/
void LockedBurstWrRd(int BankNo, int Burst, int32 Offset, int hsize, int msize,
                    int32 Data)
{
  /*
     Summary: Locked Burst Write-Read
     ================================
     This performs performs the following:

     o  Writes to a Memory location through the MPMC and verifies through
        the MPMC.
  */

  int32 MemAddr, AHBAddr, AHBRdData1, AHBRdData2, AHBRdData3, AHBRdData4;
  int32 TempData, TestData, ReadMask;
  int32 OrgMemAddr;
  char size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};
  char* SizeStr[3] = {"BYTE", "HALFWORD", "WORD"};
  char* BurstStr[8] = {"SINGLE", "INCR", "INCR4", "INCR8", "INCR16", "WRAP4",
                       "WRAP8", "WRAP16"};
  char PrintStr[75];
  int Shift[3] = {8, 16, 32};
  int32 Mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int i, BeatsNo,incr,temp;

  switch(BankNo)
  {
    case 0 : MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_0 + (Offset << (2-msize)); break;
    case 1 : MemAddr = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_1 + (Offset << (2-msize)); break;
    case 2 : MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_2 + (Offset << (2-msize)); break;
    case 3 : MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_3 + (Offset << (2-msize)); break;
    default: MemAddr = Offset; break;
  }

  switch(Burst)
  {
    case 0 : BeatsNo = 50;  break;
    case 1 : BeatsNo = 50;  break;
    case 2 : BeatsNo = 4;  break;
    case 3 : BeatsNo = 8;  break;
    case 4 : BeatsNo = 16; break;
    case 5 : BeatsNo = 4;  break;
    case 6 : BeatsNo = 8;  break;
    case 7 : BeatsNo = 16; break;
  }
  sprintf(PrintStr,
         "Does Burst Write-Reads with HSIZE = %s, MSIZE = %s, BURST = %s",
          SizeStr[hsize], SizeStr[msize], BurstStr[Burst]);
    C(PrintStr);
  /** Writing via MPMC **/
  debug_info("Writing via MPMC");
  TempData = Data;
  if (ENDIANNESS == 0)
  {
    TestData = TempData & Mask[hsize];
  } 
  else
  {
    TestData = (TempData << 3*Shift[hsize]) &
               (Mask[hsize] << 3*Shift[hsize]);
  }

  OrgMemAddr = MemAddr;
  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1,0x1 , , , ,);
  HSW( , TestData);
  for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      TestData = TempData & Mask[hsize];
    } else
    {
      TestData = (TempData << (3-i%4)*Shift[hsize]) &
                 (Mask[hsize] << (3-i%4)*Shift[hsize]);
    }
    HSW( , TestData++);
  }
  if(hsize == 0)
    incr = 1;
  else if(hsize == 1)
    incr = 2;
  else
    incr = 4;
  MemAddr = MemAddr + BeatsNo * incr;
  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1,0x1, , , ,);
  HSW( , TestData++);
  for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      TestData = TempData & Mask[hsize];
    } else
    {
      TestData = (TempData << (3-i%4)*Shift[hsize]) &
                 (Mask[hsize] << (3-i%4)*Shift[hsize]);
    }
    HSW( , TestData);
  }
  /** Reading via MPMC **/
  debug_info("Reading via MPMC");
  TempData = Data;
  if (ENDIANNESS == 0)
  {
    ReadMask = Mask[hsize];
    TestData = TempData & ReadMask;
  } else
  {
    ReadMask = (Mask[hsize] << 3*Shift[hsize]);
    TestData = (TempData << 3*Shift[hsize]) & ReadMask;
  }
  MemAddr = OrgMemAddr;
  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1,0x1, , , ,);
  HSR( , TestData, , ReadMask, ,BurstWriteRead_1);
  for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      ReadMask = (Mask[hsize] << i*Shift[hsize]);
      TestData = (TempData << i*Shift[hsize]) & ReadMask;
    } else
    {
      ReadMask = (Mask[hsize] << (3-i%4)*Shift[hsize]);
      TestData = (TempData << (3-i%4)*Shift[hsize]) & ReadMask;
    }
    HSR( , TestData, , ReadMask, ,BurstWriteRead_2);
  }
  MemAddr = MemAddr + BeatsNo * incr;
  ReadMask = Mask[hsize] << ((BeatsNo%4)*Shift[hsize]);
  TestData = (TempData<<(BeatsNo%4)*Shift[hsize]) & ReadMask;
  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1,0x1, , , ,);
  HSR( , TestData, , ReadMask, ,BurstWriteRead_1);
  for (i = BeatsNo + 1, TempData++; i < (2*BeatsNo); i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      ReadMask = (Mask[hsize] << i*Shift[hsize]);
      TestData = (TempData << i*Shift[hsize]) & ReadMask;
    } else
    {
      ReadMask = (Mask[hsize] << (3-i%4)*Shift[hsize]);
      TestData = (TempData << (3-i%4)*Shift[hsize]) & ReadMask;
    }
    HSR( , TestData, , ReadMask, ,BurstWriteRead_2);
  }
}
/******************************************************************************/
/**************************** LockedBurstWrRd1 ********************************/
/******************************************************************************/
void LockedBurstWrRd1(int BankNo, int Burst, int32 Offset, int hsize, int msize,
                    int32 Data)
{
  /*
     Summary: Locked Burst Write-Read
     =========================
     This performs performs the following:

     o  Writes to a Memory location through the MPMC and verifies through
        the MPMC.
  */

  int32 MemAddr, AHBAddr, AHBRdData1, AHBRdData2, AHBRdData3, AHBRdData4;
  int32 TempData, TestData, ReadMask;
  int32 OrgMemAddr;
  char size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};
  char* SizeStr[3] = {"BYTE", "HALFWORD", "WORD"};
  char* BurstStr[8] = {"SINGLE", "INCR", "INCR4", "INCR8", "INCR16", "WRAP4",
                       "WRAP8", "WRAP16"};
  char PrintStr[75];
  int Shift[3] = {8, 16, 32};
  int32 Mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int i, BeatsNo,incr,temp, incr1;

  switch(BankNo)
  {
    case 0 : MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_0 + (Offset << (2-msize)); break;
    case 1 : MemAddr = MEM1_BASE + (MPMCTrMEMBData[1] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_1 + (Offset << (2-msize)); break;
    case 2 : MemAddr = MEM2_BASE + (MPMCTrMEMBData[2] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_2 + (Offset << (2-msize)); break;
    case 3 : MemAddr = MEM3_BASE + (MPMCTrMEMBData[3] << 11) + Offset;
             AHBAddr = MPMCTrMEMR_3 + (Offset << (2-msize)); break;
    default: MemAddr = Offset; break;
  }

  switch(Burst)
  {
    case 0 : BeatsNo = 50;  break;
    case 1 : BeatsNo = 50;  break;
    case 2 : BeatsNo = 4;  break;
    case 3 : BeatsNo = 8;  break;
    case 4 : BeatsNo = 16; break;
    case 5 : BeatsNo = 4;  break;
    case 6 : BeatsNo = 8;  break;
    case 7 : BeatsNo = 16; break;
  }
  sprintf(PrintStr,
         "Does Burst Write-Reads with HSIZE = %s, MSIZE = %s, BURST = %s",
          SizeStr[hsize], SizeStr[msize], BurstStr[Burst]);
    C(PrintStr);
  /** Writing via MPMC **/
  debug_info("Writing via MPMC");
  TempData = Data;
  if (ENDIANNESS == 0)
  {
    TestData = TempData & Mask[hsize];
  } 
  else
  {
    TestData = (TempData << 3*Shift[hsize]) &
               (Mask[hsize] << 3*Shift[hsize]);
  }

  OrgMemAddr = MemAddr;
  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1,0x1 , , , ,);
  HSW( , TestData);
  for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      TestData = TempData & Mask[hsize];
    } else
    {
      TestData = (TempData << (3-i%4)*Shift[hsize]) &
                 (Mask[hsize] << (3-i%4)*Shift[hsize]);
    }
    if(Burst == 0)
    {
     WaitLoop(0x3);
     MemAddr = AddrGenLogic(MemAddr, hsize, beat[Burst]);
     HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1,0x1 , , , ,);
     HSW( , TestData++);
    }
    else
    {
     MemAddr = AddrGenLogic(MemAddr, hsize, beat[Burst]);
     HSA(MemAddr, SEQ, beat[Burst], , size[hsize], , 0x1,0x1 , , , ,);
     HSW( , TestData++);
    }
  }
  if(hsize == 0)
    incr = 1;
  else if(hsize == 1)
    incr = 2;
  else
    incr = 4;
  WaitLoop(0x3);
  MemAddr = OrgMemAddr + (BeatsNo * incr); 
  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
  HSW( , TestData++);
  for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      TestData = TempData & Mask[hsize];
    } else
    {
      TestData = (TempData << (3-i%4)*Shift[hsize]) &
                 (Mask[hsize] << (3-i%4)*Shift[hsize]);
    }
    if(Burst == 0)
    {
     WaitLoop(0x3);
     MemAddr = AddrGenLogic(MemAddr, hsize, beat[Burst]);
     HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1,0x1 , , , ,);
     HSW( , TestData++);
    }
    else
    {
     MemAddr = AddrGenLogic(MemAddr, hsize, beat[Burst]);
     HSA(MemAddr, SEQ, beat[Burst], , size[hsize], , 0x1,0x1 , , , ,);
     HSW( , TestData++);
    }
  }
  WaitLoop(0x3);
  /** Reading via MPMC **/
  debug_info("Reading via MPMC");
  TempData = Data;
  if (ENDIANNESS == 0)
  {
    ReadMask = Mask[hsize];
    TestData = TempData & ReadMask;
  } else
  {
    ReadMask = (Mask[hsize] << 3*Shift[hsize]);
    TestData = (TempData << 3*Shift[hsize]) & ReadMask;
  }
  MemAddr = OrgMemAddr;
  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1,0x1, , , ,);
  HSR( , TestData, , ReadMask, ,BurstWriteRead_1);
  for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      ReadMask = (Mask[hsize] << i*Shift[hsize]);
      TestData = (TempData << i*Shift[hsize]) & ReadMask;
    } else
    {
      ReadMask = (Mask[hsize] << (3-i%4)*Shift[hsize]);
      TestData = (TempData << (3-i%4)*Shift[hsize]) & ReadMask;
    }
    if(Burst == 0)
    {
     WaitLoop(0x3);
     MemAddr = AddrGenLogic(MemAddr, hsize, beat[Burst]);
     HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1,0x1, , , ,);
     HSR( , TestData, , ReadMask, ,BurstWriteRead_2);
    }
    else
    {
       MemAddr = AddrGenLogic(MemAddr, hsize, beat[Burst]);
       HSA(MemAddr, SEQ, beat[Burst], , size[hsize], , 0x1,0x1, , , ,);
       HSR( , TestData, , ReadMask, ,BurstWriteRead_2);
    }
  }
     WaitLoop(0x3);
  MemAddr = OrgMemAddr + (BeatsNo * incr); 
  ReadMask = Mask[hsize] << ((BeatsNo%4)*Shift[hsize]);
  TestData = (TempData<<(BeatsNo%4)*Shift[hsize]) & ReadMask;
  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1,0x1, , , ,);
  HSR( , TestData, , ReadMask, ,BurstWriteRead_1);
  for (i = BeatsNo + 1, TempData++; i < (2*BeatsNo); i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      ReadMask = (Mask[hsize] << i*Shift[hsize]);
      TestData = (TempData << i*Shift[hsize]) & ReadMask;
    } else
    {
      ReadMask = (Mask[hsize] << (3-i%4)*Shift[hsize]);
      TestData = (TempData << (3-i%4)*Shift[hsize]) & ReadMask;
    }
    if(Burst == 0)
    {
     WaitLoop(0x3);
     MemAddr = AddrGenLogic(MemAddr, hsize, beat[Burst]);
     HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1,0x1, , , ,);
     HSR( , TestData, , ReadMask, ,BurstWriteRead_2);
    }
    else
    {
     MemAddr = AddrGenLogic(MemAddr, hsize, beat[Burst]);
     HSA(MemAddr, SEQ, beat[Burst], , size[hsize], , 0x1,0x1, , , ,);
     HSR( , TestData, , ReadMask, ,BurstWriteRead_2);
    }
   }
}
/******************************************************************************/
/******************************* AddrGenLogic *********************************/
/******************************************************************************/
 AddrGenLogic(int Address,int size,char* burst)
 {
  /*
     Summary: AddrGenLogic
     =====================
     o It generates the next address according to the address, hsize and
       type of burst
  */
  int tempaddr,LocalAddress;
  int32 getval[5] = {0x00000003, 0x00000007, 0x0000000F,0x0000001F,0x0000003F};
  int32 mask[5] = {0xFFFFFFFC, 0xFFFFFFF8, 0xFFFFFFF0,0xFFFFFFE0,0xFFFFFFC0};
  if(burst == "wr4")
  {
    tempaddr = Address & getval[size];
    Address  = Address & mask[size];

    if(size == 0)
    {
      tempaddr = tempaddr + 1;
      tempaddr = tempaddr & getval[size];
    }
    else
    {
      tempaddr = tempaddr + (2 * size);
      tempaddr = tempaddr & getval[size];
    }
    Address = Address | tempaddr;
  }
  else if(burst == "wr8")
  {
    tempaddr = Address & getval[size+1];
    Address  = Address & mask[size+1];
    if(size == 0)
    {
      tempaddr = tempaddr + 1;
      tempaddr = tempaddr & getval[size+1];
    }
    else
    {
      tempaddr = tempaddr + (2 * size);
      tempaddr = tempaddr & getval[size+1];
    }
    Address = Address | tempaddr;
  }
  else if(burst == "w16")
  {
    tempaddr = Address & getval[size+2];
    Address  = Address & mask[size+2];
    if(size == 0)
    {
      tempaddr = tempaddr + 1;
      tempaddr = tempaddr & getval[size+2];
    }
    else
    {
      tempaddr = tempaddr + (2 * size);
      tempaddr = tempaddr & getval[size+2];
    }
    Address = Address | tempaddr;
  }
  else
  {
     if(size == 0)
           Address = Address + 1;
         else
           Address = Address + (size*2);
  }
  return(Address);
}
/******************************************************************************/
/***************************** Sequence ***************************************/
/******************************************************************************/
void Sequence(char op, int32 Address, int trans[],char* burst, int size,
              int32 Data,int endian)
{
  /* 
    Summary : Sequence()
    ====================
    It does the following operations
    
    o It performs memory write operations depending on the parameters(size,
      burst, sequence of transfers, endian, address and data)passed to this 
      function.
      Transfers can be specified in an array and 2 will be 
      interpreted as NSEQ, 3 as SEQ, 0 as IDLE and 1 as BUSY. Last parameter
      of the array should be '5' indicates the function that the expected
      transfers are complete. hsize can be specified as integer value.
      If size is '0', it'll be interpreted as "BYTE", if '1' then "HWRD" 
      and if '2' then "WRD".
      Burst can be specified as described in busheader.h file.
      When endian is 0, transfers will be done in little endian mode and when 1,
      transfers are done in big endian.
 
    o It reads back the data with the parameters passed to this function and
      verifies the data integrity
  */
  int lsb,i,maskpos,hsize,flag,AddrLSB;
  char PrintStr[75];
  int32 maskval,tempdata;
  int32 mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};      
  int htrans;
  char debugstr[200];
  char sizearr[3] = {'b', 'h', 'w'};
  char* transarr[4] = {"i","b","n","s"};
  char* beatarr[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};
  char* SizeStr[3] = {"BYTE", "HALFWORD", "WORD"};
  char* BurstStr[8] = {"SINGLE", "INCR", "INCR4", "INCR8", "INCR16", "WRAP4",
                       "WRAP8", "WRAP16"};
  int shift[3] = {8,16,32};
  i = 0;
  if(op == 'w')
  {
    sprintf(PrintStr,
        "Perform write operation from the ADDR = %X with HSIZE = %s,BURST = %s",
         Address, SizeStr[size], burst);
    C(PrintStr);
    while(trans[i] != 5)
    {
      AddrLSB = Address & 0x0000000F;
      htrans = trans[i];
      if(htrans == 0 | htrans == 1)
            tempdata = 0x87654321;
      else
      {
        if(endian == 0)
          tempdata = Data++;
        else
        { 
          if(size == 0)
            tempdata = Data++ << (3 - (AddrLSB % 4))*shift[size]; 
          else if(size == 1)
          {
            if((AddrLSB % 4) == 2)
              flag = 0;
            else
              flag = 1;
            tempdata = Data++ << (flag* 16); 
          }  
          else
            tempdata = Data++;
        }
      }
      HSA(Address, transarr[htrans], burst, OK, sizearr[size]);
      HSW(,tempdata); 
      if(htrans == 2 | htrans == 3)
      {
         Address = AddrGenLogic(Address, size, burst);
      }      
      i++;
    }
  }
  else if(op == 'r')
  {
    sprintf(PrintStr,
        "Perform read operation from the ADDR = %X with HSIZE = %s, BURST = %s",
         Address, SizeStr[size], burst);
    C(PrintStr);
    if(size == 0)
    {
       while(trans[i] != 5)
       {
          AddrLSB = Address & 0x0000000F;
          htrans = trans[i];
          maskpos = Address & 0x0000000F;
          if(htrans == 0 | htrans == 1)
            tempdata = 0x87654321;
          else
          {
            if(endian == 0)
            {
               tempdata = Data++ << maskpos*8; 
               maskval = mask[0] << (maskpos*8);
            }
            else
            {
                 tempdata = Data++ << (3 - (AddrLSB % 4))*shift[size];
                 maskval =  mask[0] << (3 - (AddrLSB % 4))*shift[size];
            }
          } 
          HSA(Address,transarr[htrans], burst, OK,sizearr[size]);
          HSR(,tempdata, ,maskval); 
          if(htrans == 2 | htrans == 3)
            Address = AddrGenLogic(Address, size, burst);
          i++;
       }
    }
    else if(size == 1)
    {
       while(trans[i] != 5)
       {
          AddrLSB = Address & 0x0000000F;
          htrans = trans[i];
          maskpos = Address & 0x0000000F;
          if((maskpos % 4) == 2)
           flag = 1;
          else
           flag = 0;
          if(htrans == 0 | htrans == 1)
            tempdata = 0x12345678;
          else
          {
            if(endian == 0)
            {
               tempdata = Data++ << (16*flag);
               maskval = mask[1] << (16*flag);
            }
            else
            {
              if((AddrLSB % 4) == 2)
                flag = 0;
              else
                flag = 1;
              tempdata = Data++ << (flag* 16);
              maskval = mask[1] << (flag * 16);
            }
          } 
          HSA(Address,transarr[htrans], burst, OK,sizearr[size]);
          HSR(,tempdata, ,maskval); 
          if(htrans == 2 | htrans == 3)
            Address = AddrGenLogic(Address, size, burst);
          i++;
       }
    }  
    else if(size == 2)
    {
       while(trans[i] != 5)
       {
          AddrLSB = Address & 0x0000000F;
          htrans = trans[i];
          if(htrans == 0 | htrans == 1)
            tempdata = 0x12345678;
          else
            tempdata = Data++;
          HSA(Address,transarr[htrans], burst, OK,sizearr[size]);
          HSR(,tempdata, ,MaskALL); 
          if(htrans == 2 | htrans == 3)
            Address = AddrGenLogic(Address, size, burst);
          i++;
       }
    } 
  }
}
/******************************************************************************/
/****************************** InitTransRnd **********************************/
/******************************************************************************/
InitTransRnd(int *trans, int burst)
{
  /*
     Summary : InitTransRnd
     ======================
     o It generates the sequence of HTRANS randomly and inserts SEQ or NSEQ 
       according to the value of burst and returns trans array.
  */ 
  int i = 1, cnt = 1, endp,j,temp;
  trans[0] = 2;
  while(cnt != burst)
  {
     trans[i] = (rand() % 0x00000003) + 1;
     if(trans[i-1] == 0)
       trans[i] = 2;
     else if((trans[i-1] == 2) && (trans[i] == 2))
       trans[i] = rand() % 0x00000001;
     if((trans[i] == 2) || (trans[i] == 3))
       cnt++;
     i++;
  }
  trans[i] = 5;
}
/******************************************************************************/
/**************************** InitTransBusyDet ********************************/
/******************************************************************************/
 InitTransBusyDet(int *trans, int burst, int busypos)
{
 /* 
     Summary : InitTransBusyDet
     ==========================
     o It generates the sequence of transfers and inserts BUSY according to the
       busypos position
  */ 
  int i = 2, cnt = 2;
  trans[0] = 2;
  while(cnt != burst)
  {
     trans[i] = rand() % 0x00000001;
     trans[i] = trans[i] + 2;
     if((trans[i-1] == 2) && (trans[i] == 2))
       trans[i] = 3;
     if(i == busypos)
       trans[i] = 1;
     if(trans[i] == 2 || trans[i] == 3)
       cnt++;
     i++;
  }
  trans[burst+1] = 5;
}

/******************************************************************************/
/****************************** InitTransDet **********************************/
/******************************************************************************/
InitTransDet(int *trans, int burst, int burstboundary)
{
  /* 
     Summary : InitTransDet
     ======================
     o It generates the sequence of transfers according to the burst and 
       burstboundary 
  */
  int i = 0;
  while(i != burst)
  {
     if((i % burstboundary) == 0)
        trans[i] = 2;
     else
        trans[i] = 3; 
     i++;
  }  
  trans[burst+1] = 5;
} 
/******************************************************************************/
/******************************* InitBusyRnd **********************************/
/******************************************************************************/
InitBusyRnd(int *trans, int burst)
{
  /*
     Summary : InitTransRnd
     ======================
     o It generates the sequence of HTRANS except IDLE randomly and inserts
       SEQ or NSEQ  according to the value of burst and returns trans array.
  */ 
  int i = 1, cnt = 1, endp,j,temp;
  trans[0] = 2;
  while(cnt != burst)
  {
     trans[i] = (rand() % 0x00000002) + 1;
     if(trans[i-1] == 0)
       trans[i] = 2;
     else if((trans[i-1] == 2) && (trans[i] == 2))
       trans[i] = 3;
      /* trans[i] = (rand() % 0x00000002) + 1; */
     if((trans[i] == 2) || (trans[i] == 3))
       cnt++;
     i++;
  }
  trans[i] = 5;
}
/*-- --================================ End ================================--*/
