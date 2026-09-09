/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001-2002 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : Arb4StWrRd.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--          It performs memory access from port3.
--
--          TEST ID : MPMC_Arb4St_1
--
-- --=======================================================================--*/
/******************************************************************************/
/******************************** Arb4StWrRd **********************************/
/******************************************************************************/
void Arb4StWrRd()
{
  /*
     Summary: Arb4StWrRd
     ===================
     It does the following operations    

     o It writes data from all ports and reads data back from same port.
   
     o It accesses the static memory arbitrarily from different ports
        but at the same time and tests the functionality of buffer and arbiter
        and mem controller.
  */
  int i,size,csel,chip,burst,msize;
  char debugstr[100];
  char *sizetype[] = {"BYTE", "HWRD","WRD"};
  unsigned long Addr, Data,LoBits,Bound;

  #if(INFILE == 3)
  /* Disable Address mirror bit */
  C("TEST ID : MPMC_Arb4StWrRd_1");
  WriteData(MPMCControl, 0x00000001, "WRD");
  WriteData(MPMCTrExBkOff, 0x00000011, "WRD");
  MPMCTrMEMBData[0] = 0x00000000;
  StInitProc(0,0,0,0,0,0,0,0,0,0x1,0x1,0x1,0x2,0x1,0x1,0x3);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x1,0x1,0x1,0x2,0x1,0x1,MPMCTrMEMBData[0],
               0x0);
  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,1,0,0x1,0x1,0x1,0x2,0x1,0x1,0x3);
  TrickMemInit(1,1,0,0,1,0,0,1,0,0x1,0x1,0x1,0x2,0x1,0x1,MPMCTrMEMBData[1],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (32 bits width) */
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,2,0,0,1,0,1,0,0,0x1,0x1,0x1,0x2,0x1,0x0,0x3);
  TrickMemInit(2,2,0,0,1,0,1,0,0,0x1,0x1,0x1,0x2,0x1,0x0,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (16 bits width) */
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,1,0,0,1,0,1,1,0,0x1,0x1,0x1,0x2,0x2,0x0,0x3);
  TrickMemInit(3,1,0,0,1,0,1,1,0,0x1,0x1,0x1,0x2,0x2,0x1,MPMCTrMEMBData[3],
               0x0);

  WriteData(MPMCTrTES, 0x00000008, "WRD");
  /* Write to CS0 */
  C("Write data to CS0 from Port3");
  for (burst = 0; burst < 8; burst++)
  {
    /* selection of chip */
    for(csel = 0; csel < 1; csel++)
    {
      msize = 0;
      /* selection of size */
      for(size = 0;size < 3; size++)
      {
        chip = csel;
        Addr = rand() & 0x000000FC;
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
  #elif(INFILE == 2)
   HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);
  WaitLoop(0x10);
  C("Perform Burst write followed by burst read to CS1 from port2");
  for (burst = 0; burst < 8; burst++)
  {
    msize = 1;
    /* selection of chip */
    for(csel = 1; csel < 2; csel++)
    {
      msize = 2;
      /* selection of size */
      for(size = 0;size < 3; size++)
      {
        chip = csel;
        Addr = rand() & 0x000000FC;
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
  WaitLoop(3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);
  #elif(INFILE == 1)
    HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);
  WaitLoop(0x10);
  C("Perform burst write to CS2 via port1");
  for (burst = 0; burst < 8; burst++)
  {
    /* selection of chip */
    for(csel = 2; csel < 3; csel++)
    {
      msize = 2;

      /* selection of size */
      for(size = 0;size < 3; size++)
      {
        chip = csel;
        Addr = rand() & 0x000000FC;
        Data = 0x11111111;
        if( sizetype[size]== "BYTE")
        {
          debug_info(" Byte Transfer ");
          BurstWrRd(chip,burst,Addr,size,msize,Data);
        }
        else if(sizetype[size] == "HWRD")
        {
          debug_info(" Halfword Transfer ");
          if (chip == 2)
          {
            C("Poll for busy bit");
            WaitLoop(0x3);
            HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
            HPO(,0x00000000, ,0x00000003);
            WaitLoop(0x3);
            WriteData(MPMCTrMEMT_2, 0x51, "WRD");
            BurstWrRd(chip,burst,Addr,size,msize,Data);
            C("Poll for busy bit");
            WaitLoop(0x3);
            HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
            HPO(,0x00000000, ,0x00000003);
            WaitLoop(0x3);
            WriteData(MPMCTrMEMT_2, 0x41,"WRD");
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

  WaitLoop(3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);
  #elif(INFILE == 0)
   HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);

  C("Write data to CS3 from Port0");
  for (burst = 0; burst < 8; burst++)
  {
    /* selection of chip */
    for(csel = 3; csel < 4; csel++)
    {
      msize = 1;

      /* selection of size */
      for(size = 0;size < 3; size++)
      {
        chip = csel;
        Addr = rand() & 0x000000FC;
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

  WaitLoop(3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);
  #endif;
}
/*-- --============================== End ==================================--*/
