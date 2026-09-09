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
-- File Name              : DyHburstCmdDelTest1.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function tests all HBURST accesses on the dynamic memory
--           with command delayed option
--
--           TEST ID : MPMC_DyHburstCmdDelTest1
--
-- --=======================================================================--*/
/******************************************************************************/
/************************** DyHburstCmdDelTest1 *******************************/
/******************************************************************************/
void DyHburstCmdDelTest1(void)
{
  /*
    Summary: DyHburstCmdDelTest1
    =============================
    This test performs the following functionalities:
   
    o This test performs single data write with different types of size 
      and read the data back to check the data integrity with command delayed
      enabled.
 
    o It also does the multiple data write with different size depending on the 
       the burst type and reads the data back.

    o It reads the data from the memory at the end of test to check whether data
      is not missed in between.
  */
  int i,size,csel,chip,burst;
  char debugstr[100];
  int caslat0,caslat1,caslat2,caslat3;
  int raslat0,raslat1,raslat2,raslat3;
  int ClkRatio,msize;
  char *sizetype[] = {"BYTE", "HWRD","WRD"};
  unsigned long Addr, Data,LoBits,Bound;
 
  int32 AddrArr[] = {0x00000004,0x00000208,0x00020000,0x00030034,0x00040000,
                     0x00050010,0x000600A8,0x00070034,0x000800C0,0x00090064,
                     0x000A0014,0x000B0060,0x000EE004,0x00011008,0x00022000,
                     0x00055000,0x0006601C,0x00077000,0x00088034,0x00099048,
                     0x000AA020,0x000BB014,0x000CC06C,0x000DD060};
                     
  C("TEST ID : MPMC_DyHburstCmdDelTest1");
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  C("Disable Address mirror");
  WriteData(MPMCControl, 0x00000001, "WRD");
  ClkRatio = 0;
  C("Initialize SDRAMs and configure the registers");
  TimingInit(2,0xF,0xF,0xF,0xF,0xF,0xF,0x1F,0x1F,0x1F,0xF,0xF);
  CmdDelSyncInitializeProc(3, 0, 2, 3, 0, 0,
                           2, 0, 2, 2, 0, 0,
                           3, 0, 3, 2, 0, 0,
                           3, 0, 2, 3, 0, 0,
                           0,1,3,0,0,1,1,0,3,1,2,
                           0,2,2,0,1,1,1,0,2,1,1,
                           0,1,0,0,0,1,1,0,2,0,0,
                           0,1,1,0,0,1,1,0,2,1,1,
                           12,12,10,11,
                           0,
                           ClkRatio,
                           1);
  WriteData(MPMCTrExBkOff, 0x00000008, "WRD");
  C("Reprogram the refresh counter");
  WriteData(MPMCDyRef, 0x4, "WRD");
  /* selection of chip */ 
  for(csel = 4; csel < 8; csel++)  
  {
    /* if (csel == 4)
       csel = 5; */
     if(csel == 4)
       msize = 1;
     else if(csel == 5)
       msize = 2;
     else if(csel == 6)
       msize = 1;
     else if(csel == 7)
       msize = 1;
     i = 0;
     /* indicates type of burst*/ 
     for (burst = 0; burst < 8; burst++)
     {
        /* selection of size */
        for(size = 0;size < 3; size++)
        {
          chip = csel;
          Addr = AddrArr[i];
          i = i + 1;
          LoBits = Addr & 0x03FF;
          Bound  = LoBits + 400;
          if (Bound > 1024)
            Addr = Addr - 400;
          Addr = Addr | (chip << 28);  
          Data = 0x11111111;
          if( sizetype[size]== "BYTE")           
          {
            debug_info(" Byte Transfer ");
            LockedBurstWrRd(chip,burst,Addr,size,msize,Data);  
          }
          else if(sizetype[size] == "HWRD")
          {
            debug_info(" Halfword Transfer ");
            LockedBurstWrRd(chip,burst,Addr,size,msize,Data); 
          }
          else if(sizetype[size] == "WRD")
          {
            debug_info(" Word Transfer ");
            LockedBurstWrRd(chip,burst,Addr,size,msize,Data);  
          }
        } /* end of size*/ 
      } /* end of csel*/ 
    }  /*end of burst */
    /* Write to last row of CS4 so that precharge is applied to the memory */
    /* Reprogram the refresh counter */
    WriteData(MPMCDyRef, 0x1A, "WRD");
   /* Wait for 33 clk cycles to close any opened page */
    WaitLoop(0x33);
    for(i = 0; i < 0x50; i++)
    {
       Addr = i << 11 | 0xFF << 2;
       Addr = Addr | 0x40000000;
       ReadData(Addr,0x00000000 ,0x00000000,"WRD");
    }
    /* Read data back */
    C("Wait till buffer is flushed");
    WaitLoop(0x30);
    /* indicates type of burst */
    C("Read data back from memory and check the data integrity");
    /* selection of chip */
    for(csel = 4; csel < 8; csel++)
    {
       if(csel == 4)
         msize = 1;
       else if(csel == 5)
         msize = 2;
       else if(csel == 6)
         msize = 1;
       else if(csel == 7)
         msize = 1;
       i = 0;
       sprintf(debugstr,"Reading back from csel %X", csel);
       C(debugstr);
       for (burst = 0; burst < 8; burst++)
       {
          /*selection of size */
         C("Please wait...");
         for(size = 0;size < 3; size++)
         {
           Addr = AddrArr[i];
           i = i + 1;
           LoBits = Addr & 0x03FF;
           Bound  = LoBits + 400;
           if (Bound > 1024)
             Addr = Addr - 400;
           Addr = Addr | (csel << 28);
           Data = 0x11111111;
           ReadDataBack(csel, burst, Addr, size, msize,Data); 
        }
      }
    }
} /* end of main */
/*-- --================================ End ================================--*/
