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
-- File Name              : CornerCases2.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This test does the memory access to the 512M memory
--
--           TEST ID : MPMC_CornerCase2
--
-- --=======================================================================--*/
/******************************************************************************/
/******************************** CornerCases2 ********************************/
/******************************************************************************/
void CornerCases2()
{
  /* 
     Summary: CornerCases2
     =====================
     This test does the memory access to the 512M memory to hit the upper Row
     address.
  */
  int i,k,j;
  int32 Addr,data;
  int tempdata = 00;
  int32 TempAddr;
  int32 RowAddr;
  FILE *fp;
  int32 AddrArr4[500]; 
  int32 AddrArr5[500];
  int32 DataArr[4] ={0x33333333,0x55555555,0xAAAAAAAA,0xCCCCCCCC};
  C("TEST ID : MPMC_CornerCase2");
  WriteData(MPMCControl, 0x00000001,"WRD"); 
 if((fp = fopen("../denali/hm5257805b_a6.dat", "wb")) == NULL) 
 {
   C("Cann't open file");
 }
  TimingInit(2,5,8,0,5,2,0,7,7,0,2,3);
  SyncInitializeProc(2, 0, 3, 3, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     2, 0, 2, 3, 0, 0,
                     2, 0, 3, 2, 0, 0,
                     0, 0, 4, 0, 1, 1, 1, 0, 5, 1, 2,
                     0, 0, 4, 1, 0, 1, 1, 0, 5, 1, 2,
                     0, 0, 4, 1, 1, 1, 1, 0, 5, 1, 2, 
                     0, 2, 2, 0, 1, 1, 1, 0, 2, 1, 1,
                     15, 12, 13, 12,
                     0,
                     0
                     );
   C("Access to CS4");
   data = DataArr[1]; 
   C("Write data to CS4");
   /* Since initializing whole model consumes lot of time, only certain part
      of memory where memory is accessed are initialized */
   HSA(0x4FFFFFFC, NSEQ, INCR, OK, WRD);
   HSW(,0x22222222);
   HSA(0x4FFFFFFC, NSEQ, INCR, OK, WRD);
   HSR(,0x22222222, ,MaskALL);
 
   for(i = 0; i < 300; i++)
   { 
     RowAddr = rand() & 0x1FFF;
     Addr = rand() & 0x7FC;
     Addr = (RowAddr << 12) | Addr; 
     TempAddr = Addr;
     Addr = Addr | 0x40000000;
     AddrArr4[i]= Addr;
     for(j = 0; j < 10; j++)
     {
       fprintf(fp, "%X", TempAddr);
       fputs("/",fp);
       fprintf(fp, "%d",tempdata);
       fputs(";\n",fp);
       TempAddr = TempAddr + 1;
     }
     WriteData(Addr, data++, "WRD");
   }
  
   C("Write to CS5");
    data = DataArr[2];
   for(i = 0; i < 300; i++)
   {
     RowAddr = (rand() & 0x1FFF) + 0x1FFF;
     Addr = rand() & 0x3FC;
     Addr = (RowAddr << 12) | Addr;
     TempAddr = Addr;
     AddrArr5[i]= Addr;
     Addr = Addr | 0x50000000;
     AddrArr5[i]= Addr;
     for(j = 0; j < 10; j++)
     {
       fprintf(fp, "%X", TempAddr);
       fputs("/",fp);
       fprintf(fp, "%d",tempdata);
       fputs(";\n",fp);
       TempAddr = TempAddr + 1;
     }
     WriteData(Addr, data++, "WRD");
   }
   data = DataArr[1];
   C("Read data back from CS4");
   for(i = 0; i < 300; i++)
   {
     Addr = AddrArr4[i]; 
     ReadData(Addr, data++, MaskALL, "WRD"); 
   } 
   C("Read data back from CS5");
   data = DataArr[2];
   for(i = 0; i < 300; i++)
   {
      Addr = AddrArr5[i];
      Addr = Addr | 0x50000000;
      ReadData(Addr, data++,MaskALL, "WRD");
   }
   Addr = AddrArr5[0];
   Addr = Addr | 0x60000000;
   
   C("Write data to CS6");
   Addr = rand() & 0x0FFFFFFC;
   Addr = Addr | 0x60000000;
   HSA(Addr, NSEQ, INCR, OK, WRD);
   HSW(,0x22222222);
   C("Read data back");
   HSA(Addr, NSEQ, INCR, OK, WRD);
   HSR(,0x22222222);
}
/*-- --============================== End ===============================-- --*/
