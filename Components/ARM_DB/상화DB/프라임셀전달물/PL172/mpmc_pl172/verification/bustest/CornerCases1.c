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
-- File Name              : CornerCases1.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           It verifies the functionality of controller when delay values are
--           kept as small values.
--
--           TEST ID : MPMC_CornerCase1
--
-- --=======================================================================--*/
/******************************************************************************/
/******************************* CornerCases **********************************/
/******************************************************************************/
void CornerCases1(void)
{
  /*
    Summary: HburstTest
    ===================
    This test performs the following functionalities:
    o It programs the delay register values with small values and performs the 
      different types of operations.
    
    o It programs the Page Mode ROMs with small values and reads from the same. 
  */
  int i,size,csel,access,quad,chip,burst,AddrMap,Bank,Row,Col;
  int BusyCnt,Position1,PosnCount1,Position2,PosnCount2,DataCnt;
  int WordSel,HWordSel,ByteSel,DWordSel, Banksel,msize;
  int st,end;
  double dif;
  int Byte[4]   = {B0, B1, B2, B3};
  int HWord[2]  = {HW0, HW1};
  int Word[4]   = {W0, W1, W2, W3};
  char debugstr[100];
  unsigned long chpsel[8] = {0,1,2,3,4,5,6,7};
  char *sizetype[] = {"BYTE", "HWRD","WRD"};
  unsigned long Addr, Data,LoBits,Bound;
 
  C("TEST ID : MPMC_CornerCase1");
  /* Disable Address mirror */
  WriteData(MPMCControl, 0x00000001, "WRD");
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  WriteData(MPMCTrExBkOff, 0x00000008, "WRD");
  /* Write from Port0 to all memory chips with diff sizes and read it back */

  MPMCTrMEMBData[0] = 0x00000000;
  StInitProc(0,0,0,0,0,0,0,0,0,0x0,0x0,0x0,0x0,0x0,0x3,0x3);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x0,0x0,0x0,0x0,0x0,0x3,MPMCTrMEMBData[0],
               0x0);
  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,1,0,0x0,0x0,0x0,0x0,0x0,0x3,0x3);
  TrickMemInit(1,1,0,0,1,0,0,1,0,0x0,0x0,0x0,0x0,0x0,0x3,MPMCTrMEMBData[1],
               0x0); 

  /* Set Bank 2 Memory Type as SRAM (32 bits width) */
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,2,0,0,1,0,1,0,0,0x0,0x0,0x0,0x0,0x0,0x0,0x3);
  TrickMemInit(2,2,0,0,1,0,1,0,0,0x0,0x0,0x0,0x0,0x0,0x0,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as Page mode ROM (32 bits width) */
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,2,1,0,1,0,1,1,1,0x0,0x0,0x0,0x0,0x0,0x0,0x3);
  TrickMemInit(3,2,1,0,1,0,1,1,1,0x0,0x0,0x0,0x0,0x0,0x0,MPMCTrMEMBData[3],
               0x0);
  
  /* indicates type of burst */ 
  for (burst = 0; burst < 8; burst++)   
  {
      /* selection of chip */ 
      for(csel = 0; csel < 3; csel++)  
      {
        /* selection of size */
        for(size = 0;size < 3; size++)
        {
          chip = csel;
          if(chip == 0)
          {
            msize = 0;
            Addr = rand() & 0x37C;
          }
          else if(chip == 1)
          {
            msize = 1;
            Addr = rand() & 0x37C;
          }
          else if(chip == 2)
          {
            msize = 2;
            Addr = rand() & 0x37C;
          }
          else if(chip == 3)
          {
            msize = 1;
            Addr = rand() & 0x37C;
          }
          Data = 0x11111111;
          if( sizetype[size]== "BYTE")           
          {
            debug_info(" Byte Transfer ");
            if (chip == 2)
            {
              WaitLoop(0x3);
              HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
              HPO(,0x00000000, ,0x00000003);
              WaitLoop(0x3);
              WriteData(MPMCTrMEMT_2, 0x52, "WRD");
              BurstWrRd(chip,burst,Addr,size,msize,Data);
              WaitLoop(0x3);
              HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
              HPO(,0x00000000, ,0x00000003);
              WaitLoop(0x3);
              WriteData(MPMCTrMEMT_2, 0x42,"WRD");
            }
            else
              BurstWrRd(chip,burst,Addr,size,msize,Data);
          }
          else if(sizetype[size] == "HWRD")
          {
            debug_info(" Halfword Transfer ");
            if (chip == 2)
            {
              WaitLoop(0x3);
              HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
              HPO(,0x00000000, ,0x00000003);
              WaitLoop(0x3);
              WriteData(MPMCTrMEMT_2, 0x52, "WRD");
              BurstWrRd(chip,burst,Addr,size,msize,Data);
              WaitLoop(0x3);
              HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
              HPO(,0x00000000, ,0x00000003);
              WaitLoop(0x3);
              WriteData(MPMCTrMEMT_2, 0x42,"WRD");
            }
            else
              BurstWrRd(chip,burst,Addr,size,msize,Data);
          }
          else if(sizetype[size] == "WRD")
          {
            debug_info(" Word Transfer ");
            BurstWrRd(chip,burst,Addr,size,msize,Data);
          }
        } /* end of size */
      } /* end of csel */
    }  /*end of burst */
    WaitLoop(0x3);
    HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
    HPO(,0x00000000, ,0x00000003);
    WaitLoop(0x3);
    WriteData(MPMCTrMEMT_2, 0x52, "WRD");
    Addr = MEM2_BASE + 0x0A1;
    HSA(Addr, NSEQ, INCR, OK, BYTE);
    HSW(,0x22222222);
    HSA(Addr+1, SEQ, INCR, OK, BYTE);
    HSW(,0x22222223);
    HSA(Addr+2, SEQ, INCR, OK, BYTE);
    HSW(,0x22222224);
    HSA(Addr+3, SEQ, INCR, OK, BYTE);
    HSW(,0x22222225);
    HSA(Addr+4, SEQ, INCR, OK, BYTE);
    HSW(,0x22222226);
    HSA(Addr+5, SEQ, INCR, OK, BYTE);
    HSW(,0x22222227);
   
    HSA(Addr, NSEQ, INCR, OK, BYTE);
    HSR(,0x22222222, ,0x0000FF00);
    HSA(Addr+1, SEQ, INCR, OK, BYTE);
    HSR(,0x22232222, ,0x00FF0000);
    HSA(Addr+2, SEQ, INCR, OK, BYTE);
    HSR(,0x24222222, ,0xFF000000);
    HSA(Addr+3, SEQ, INCR, OK, BYTE);
    HSR(,0x22222225, ,0x000000FF);
    HSA(Addr+4, SEQ, INCR, OK, BYTE);
    HSR(,0x22222622, ,0x0000FF00);
    HSA(Addr+5, SEQ, INCR, OK, BYTE);
    HSR(,0x22272222, ,0x00FF0000);
 
    WaitLoop(0x3);
    HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
    HPO(,0x00000000, ,0x00000003);
    WaitLoop(0x3);
    WriteData(MPMCTrMEMT_2, 0x42, "WRD");
    
    C("Test for BurstROM with minimum delay values");
    AHBWriteMem(3, 0xA0, 0x30, 0x00000022);
    AHBWriteMem(3, 0x80, 0x8, 0x0000002A);
    WaitLoop(0x3);
    HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
    HPO(,0x00000000, ,0x00000003);
    WaitLoop(0x3);
    WriteData(MPMCTrMEMT_3, 0x72, "WRD");
    Addr = MEM3_BASE + 0xA0;
    Data = 0x00000022;
    HSA(Addr, NSEQ, INCR4, OK, WRD);
    HSR(, Data++, ,MaskALL); 
    for(i = 0; i < 3; i++)
      HSR(, Data++, ,MaskALL); 

    Data = 0x00000022;
    HSA(Addr, NSEQ, INCR8, OK, WRD);
    HSR(, Data++, ,MaskALL);
    for(i = 0; i < 7; i++)
      HSR(, Data++, ,MaskALL);

    Data = 0x00000022;
    HSA(Addr, NSEQ, INCR16, OK, WRD);
    HSR(, Data++, ,MaskALL);
    for(i = 0; i < 15; i++)
      HSR(, Data++, ,MaskALL);

    Data = 0x00000022;
    HSA(Addr, NSEQ, WRAP4, OK, WRD);
    HSR(, Data++, ,MaskALL);
    for(i = 0; i < 3; i++)
      HSR(, Data++, ,MaskALL);
    
    Data = 0x00000022;
    HSA(Addr, NSEQ, WRAP8, OK, WRD);
    HSR(, Data++, ,MaskALL);
    for(i = 0; i < 7; i++)
      HSR(, Data++, ,MaskALL);
    
    Data = 0x00000022;
    HSA(Addr, NSEQ, WRAP16, OK, WRD);
    HSR(, Data++, ,MaskALL);
    for(i = 0; i < 15; i++)
      HSR(, Data++, ,MaskALL);

    AHBWriteMem(3, 0x00, 0x30, 0x14131211);
    HSA(0x30000000, NSEQ, INCR16, OK, BYTE);
    HSR(, 0x00000011, ,0x000000FF);
    HSR(, 0x00001200, ,0x0000FF00);
    HSR(, 0x00130000, ,0x00FF0000);
    HSR(, 0x14000000, ,0xFF000000);
    HSR(, 0x00000012, ,0x000000FF);
    HSR(, 0x00001200, ,0x0000FF00);
    HSR(, 0x00130000, ,0x00FF0000);
    HSR(, 0x14000000, ,0xFF000000);
    HSR(, 0x00000013, ,0x000000FF);
    HSR(, 0x00001200, ,0x0000FF00);
    HSR(, 0x00130000, ,0x00FF0000);
    HSR(, 0x14000000, ,0xFF000000);
    HSR(, 0x00000014, ,0x000000FF);
    HSR(, 0x00001200, ,0x0000FF00);
    HSR(, 0x00130000, ,0x00FF0000);
    HSR(, 0x14000000, ,0xFF000000);
    
    WaitLoop(0x3);
    HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
    HPO(,0x00000000, ,0x00000003);
    WaitLoop(0x3);
    WriteData(MPMCTrMEMT_3, 0x42, "WRD");
        
    WriteData(MPMCTrTES, 0x00000008, "WRD");
} /* end of main */
/*-- --================================ End ================================--*/
