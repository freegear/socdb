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
-- File Name              : Rel1HburstTest.c.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function tests the HBURST operation
--
--           TEST ID : MPMC_Rel1HburstTest_1
--
-- --=======================================================================--*/
/******************************************************************************/
/***************************** Rel1HburstTest *********************************/
/******************************************************************************/
void Rel1HburstTest(void)
{
  /*
    Summary: Rel1HburstTest
    =======================
    This test performs the following functionalities:
   
    o Address connections for this test is similar to Rel1.

    o This test performs single data write with different types of size 
      and read the data back to check the data integrity.
 
    o It also does the multiple data write with different size depending on the 
       the burst type and reads the data back.

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
 
  C("TEST ID : MPMC_Rel1HburstTest_1");
  /* Disable Address mirror */
  WriteData(MPMCControl, 0x00000001, "WRD");
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  /* Write from Port0 to all memory chips with diff sizes and read it back */
  StInitProc(0,2,0,0,1,0,0,0,0,0x1,0x1,0x7,0x5,0x8,0x5,0x8);
  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  StInitProc(1,1,0,0,1,0,0,0,0,0x1,0x1,0x1,0x1,0x1,0x1,0x1);

  /* Set Bank 2 Memory Type as SRAM (8 bits width) */
  StInitProc(2,0,0,0,0,0,0,0,0,0x1,0x1,0x8,0x5,0x8,0x1,0x1);

  /* Set Bank 3 Memory Type as SRAM (32 bits width) */
  StInitProc(3,2,0,0,0,0,0,0,0,0x1,0x1,0x1,0x1,0x1,0x1,0x1);

  /* indicates type of burst */ 
  for (burst = 2; burst < 8; burst++)   
  {
     /* selection of chip */ 
     for(csel = 0; csel < 4; csel++)  
     {
       /* selection of size */
       for(size = 0;size < 3; size++)
       {
         chip = csel;
         if(chip == 0)
         {
           msize = 2;
           Addr = rand() & 0x37C;
           LoBits = Addr + 400; 
           if(LoBits > 1024)
             Addr = Addr - 400;
         }
         else if(chip == 1)
         {
           msize = 1;
           Addr = rand() & 0x37C;
           LoBits = Addr + 400;
           if(LoBits > 1024)
             Addr = Addr - 400;
         }
         else if(chip == 2)
         {
           msize = 0;
           Addr = rand() & 0x37C;
           LoBits = Addr + 400;
           if(LoBits > 1024)
              Addr = Addr - 400;
          }
         else if(chip == 3)
         {
          msize = 2;
           Addr = rand() & 0x37C;
            LoBits = Addr + 400;
           if(LoBits > 1024)
              Addr = Addr - 16;
         }
         Data = 0x11111111;
         if( sizetype[size]== "BYTE")           
         {
           debug_info(" Byte Transfer ");
           BurstWrRd(chip,burst,Addr,size,msize,Data);
         }
         else if(sizetype[size] == "HWRD")
         {
           debug_info(" Halfword Transfer ");
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
   WriteData(MPMCTrTES, 0x00000008, "WRD");
} /* end of main */
/*-- --================================ End ================================--*/
