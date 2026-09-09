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
-- File Name              : DyHburstTestTB9.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function tests the HBURST operation for dynamic memory.
--           This test uses tbench9
--
--           TEST ID : MPMC_DyHburstTestTB9_1
--
-- --=======================================================================--*/
/******************************************************************************/
/****************************** DyHburstTestTB9 *******************************/
/******************************************************************************/
void DyHburstTestTB9(void)
{
  /*
    Summary: DyHburstTestTB9
    ========================
    This test performs the following functionalities:
   
    o This test performs single data write with different types of size 
      and read the data back to check the data integrity.
 
    o It also does the multiple data write with different size depending on the 
       the burst type and reads the data back.

  */
  int i,size,csel,chip,burst,msize;
  char debugstr[100];
  unsigned long chpsel[8] = {0,1,2,3,4,5,6,7};
  int caslat0, caslat1, caslat2, caslat3;
  int raslat0, raslat1,raslat2, raslat3;
  int ClkRatio;
  char *sizetype[] = {"BYTE", "HWRD","WRD"};
  unsigned long Addr, Data,LoBits,Bound;
 
  C("TEST ID : MPMC_DyHburstTestTB9_1");
  WriteData(MPMCTrTES, 0x00000000, "WRD");

  C("Disable Address mirror");
  WriteData(MPMCControl, 0x00000001, "WRD"); 

  caslat1 = rand() % 1;
  raslat1 = rand() % 1;
  caslat1 = caslat1 + 2;
  raslat1 = raslat1 + 2;

  caslat2 = rand() % 1;
  raslat2 = rand() % 1;
  caslat2 = caslat2 + 2;
  raslat2 = raslat2 + 2;

  caslat3 = rand() % 1;
  raslat3 = rand() % 1;
  caslat3 = caslat3 + 2;
  raslat3 = raslat3 + 2;

  ClkRatio = 0;
  C("Initialize SDRAMs and configure the registers");
  TimingInit(2,5,8,0,5,3,0,7,7,0,2,3);
  SyncInitializeProc(2, 0, 2, 2, 0, 0,
                     3, 0, 3, 3, 0, 0,
                     3, 0, caslat2, raslat2, 0, 0,
                     2, 0, 3, 3, 0, 0,
                     0,0,0,0,1,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,2,
                     0,0,0,0,0,1,1,0,3,0,0,
                     0,2,1,0,1,1,1,0,2,1,1,
                     12,11,11,12,
                     0,
                     ClkRatio);
  /* indicates type of burst */ 
  for (burst = 0; burst < 8; burst++)   
  {
    /* selection of chip */ 
    for(csel = 4; csel < 7; csel++)  
    {
      if(csel == 4)
        msize = 1;
      else if(csel == 5)
        msize = 2;
      else if(csel == 6)
        msize = 1;
      else if(csel == 7)
        msize = 1;

     /* selection of size */
     for(size = 0;size < 3; size++)
     {
       chip = csel;
       Addr = rand() & 0x0FFFFFFC;
       LoBits = Addr & 0x03FF;
       Bound  = LoBits + 400;
       if (Bound > 1024)
         Addr = Addr - 400;
       Addr = Addr | (chip << 28);  
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
