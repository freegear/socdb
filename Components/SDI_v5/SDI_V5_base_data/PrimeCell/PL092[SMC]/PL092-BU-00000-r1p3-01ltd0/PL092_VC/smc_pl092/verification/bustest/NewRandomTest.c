/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : NewRandomTest.c.rca
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           To randomize the type of memory bank, the control parameters and
--           then randomize the access.
--
-- --=========================================================================*/

/******************************************************************************/
/**************************** New Random Test *********************************/
/******************************************************************************/

#define run
#define UseTrickMem 1
#include "Seed.h"

void NewRandomTest()
{
  /*
     Summary: New Random Test
     =====================
     This function performs the following:

     o  Configures all the memory banks with random control values.
     o  Access these banks for reading writing randomly with random burst sizes
        and transfer types
     o  A C function srandom is used to initialise function random wrt to a
        given seed value for the ease of re-creation of the scenario. 
  */
  
  int Seed;
  int i, j, Num,OpFlag;
  int Bank, RdWr, OffSet, Address;
  int HSize, HBurst, BurstSize ;
  int RandTrans[120];
  int TrickOffSet[8] = { 0, 0x0400, 0x0000, 0x0400, 
                         0, 0x0400, 0x0000, 0x0400}; 
  int HostSize, Data, Endian; 
  char Oper; 
  int Val,Val1,Val2;
  Seed   =  SEED_NEW;
  OffSet = 0;

  ApplyReset();

  /* SMWAIT and TRANS testing */
  for(i=0; i<1; i++)
  {
    /* Initialise the random seed */
    InitSeed(Seed++);

    /* Configure ALL the memory banks with random (but legal values) */
    ConfigureBanks(UseTrickMem);
  
    RandEndian();
    /* Randomly set/ reset BIGENDIAN bit */
    InitTrickArray(BANK0,  TM0_BASE, TM0_BASE+0x3FC);
    InitTrickArray(BANK0,  TM0_BASE+0x400, TM0_BASE+0x7FC);
    InitTrickArray(BANK1,  TM1_BASE, TM1_BASE+0x3FC);
    InitTrickArray(BANK1,  TM1_BASE+0x400, TM1_BASE+0x7FC);
    InitTrickArray(BANK2,  TM2_BASE, TM2_BASE+0x3FC);
    InitTrickArray(BANK2,  TM2_BASE+0x400, TM2_BASE+0x7FC);
    InitTrickArray(BANK3,  TM3_BASE, TM3_BASE+0x3FC);
    InitTrickArray(BANK3,  TM3_BASE+0x400, TM3_BASE+0x7FC);
    InitTrickArray(BANK4,  TM4_BASE, TM4_BASE+0x3FC);
    InitTrickArray(BANK4,  TM4_BASE+0x400, TM4_BASE+0x7FC);
    InitTrickArray(BANK5,  TM5_BASE, TM5_BASE+0x3FC);
    InitTrickArray(BANK5,  TM5_BASE+0x400, TM5_BASE+0x7FC);
    InitTrickArray(BANK6,  TM6_BASE, TM6_BASE+0x3FC);
    InitTrickArray(BANK6,  TM6_BASE+0x400, TM6_BASE+0x7FC);
    InitTrickArray(BANK7,  TM7_BASE, TM7_BASE+0x3FC);
    InitTrickArray(BANK7,  TM7_BASE+0x400, TM7_BASE+0x7FC);


/*    ExtBusMux = rand() % 2; */
    ExtBusMux = 0x1;
    if(ExtBusMux == 0)
    /* Initialise trick resgisters for MCBUSREQ configuration */
      RandInitMcBusReq(); 
    else
      {
      Val1 = random() % 32;
      Val2 = random() % 32;
      Val  = Val1 | (Val2 << 0x5) | (ExtBusMux << 0x0b);
      HSA(SMCTrEBICntl, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
      HSW( , Val);
      }

    /* select any bank and perform write/read randomly */
    for(j=0; j<200; j++)
    {
     C("Start of test");
      OpFlag = rand()%2;
      if(OpFlag)
       Oper = 'w';
      else
       Oper = 'r'; 
      /* Generate a random burst type */
      HBurst = RandBurst();

      /* Decide size of the transfer according to the burst */
      BurstSize = GetBurstSize(HBurst);

      /* Generate a random HSIZE */
      HSize = RandSize();

      /* Generate a random Address */
      Num   = rand();
      Bank  = Num%8;
      Address = MemBank[Bank].Address;
      Address = Address + RandAddress(HSize);

      /* Generate a random sequence and write*/
      GenTransRnd(RandTrans, BurstSize, Seed++);

      /* Access some registers randomly */
      if(Num%2)
        RandRegAccess();
      if(OpFlag == 0)
      {
      /* Make the memory BROM or ROM (By setting BM/ WP bits) or both randomly */
      if((Num%3) == 1)
      {
        /* Let the write finish properly */
        WaitLoop(50);
        C("Reading as BROM.");
        MakeBROM(Bank);
      }
      if((Num%4) == 1)
      {
        /* Let the write finish properly */
        WaitLoop(50);
        C("Reading as ROM.");
        MakeROM(Bank);
      }
      }
      /* Generate a random sequence and read*/
/*
      GenTransRnd(RandTrans, BurstSize, Seed);
      RndSequence('r', Address, RandTrans, BurstString[HBurst], HSize, Num,
                  BigEndian,Bank);
*/

      /* Generate a random sequence and do write or read*/
      RndSequence(Oper, Address, RandTrans, BurstString[HBurst], HSize, Num,
                  BigEndian,Bank);
      /* Randomly set or reset remap */
      if(!(Num%3))
        RandGenRemap();

      /* Reset the BM/ WP setting to enable writing into the memory */
      MakeSRAM(Bank);
    }
  }
}

/************************************ End *************************************/
