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
-- File Name              : BusDegrantTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This progam is to check the functionality of the controller when
--           bus degrant occurs during the test 
--
--           TEST ID : MPMC_BusDegrant_1
--
-- --=======================================================================--*/
/******************************************************************************/
/****************************** Degrant Test **********************************/
/******************************************************************************/
void BusDegrantTest(int Busy)
{
  /*
    Summary : Bus Degrant Test
    ===========================

    o  A sequence of idle cycles is inserted in a burst write of each
       burst type in any position.The number of idle cycles is decided randomly.

    o  After the idle cycles, the burst is rebuilt by using suitable number of
       transfers with burst type INCR. When the writes are completed the data 
       is read back using the same type of burst.
  */

  int i, j, k, Address, BusyCnt, temp,chip;
  int LoBits, Bound, QWStart, BankSel;
  int bank,Row,AddrMap,Col;
  int idlest;
  int32 data;

  C("TEST ID : MPMC_BusDegrant_1");
  WriteData(MPMCControl, 0x00000001, "WRD");
  idlest = 1;
  TimingInit(2,5,8,0,5,5,0,7,7,0,2,3);
  SyncInitializeProc(3, 0, 2, 2, 0, 0,
                     2, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     0,1,3,0,0,1,1,0,3,1,2,
                     0,2,2,0,1,1,1,0,2,1,1,
                     0,1,0,0,0,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,1,
                     12,12,10,11,
                     0,
                     0);
  WriteData(MPMCControl, 0x00000001, "WRD");
  /* Set Bank 0 Memory Type as SRAM (32 bits width) */
  C("Initilize registers of bank0 and TrickMem0");
  StInitProc(0,2,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(0,2,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);

  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Initilize registers of bank1 and TrickMem1");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,1,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);
  TrickMemInit(1,1,0,0,1,0,0,1,0,0x4,0x5,0x6,0x7,0x9,0x3,MPMCTrMEMBData[1],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (8 bits width) */
  C("Initilize registers of bank2 and TrickMem2");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,0x3);
  TrickMemInit(2,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (32 bits width) with buffers disabled */
  C("Initilize registers of bank3 and TrickMem3");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,2,0,0,1,0,1,0,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  TrickMemInit(3,2,0,0,1,0,1,0,0,0x4,0x5,0x6,0x7,0x9,0x7,MPMCTrMEMBData[3],
               0x0);

  data = 0x33333333;
  C("INCR4 burst termination and rebuild");

  for (k = 0; k < 3; k ++)
  {
    for (i = 1; i < 4; i ++)
    {
      /* INCR4 Burst termination due to degranting */
      chip = rand() % 8;
      if(chip > 3)
      {
        Address = rand() & 0x0FFFFFFC;
        Address = Address | chip << 28;
      }
      else
      {
        Address = rand() & 0x000000FC;
        Address = Address | chip << 28; 
      }
      temp = rand() % 4;
      Address = Address + (4*temp);

      /* Check whether the burst will cross a 1KB boundary */
      /* Change the address if it crosses a 1KB boundary */
      LoBits = Address & 0x03FF;
      Bound  = LoBits + 16;
      if (Bound > 1024)
        Address = Address - 16;

      if (Busy == 1)
      {
        /* Random number of BUSY transfers */
        BusyCnt = (rand() % 30) + 1;

        /* NSEQ-SEQ-BUSY sequence */
        WordTrans(Address, i, INCR4, data, BusyCnt, i-1, 1, 0, 0,0);
      }
      else
      {
        /* NSEQ-SEQ sequence */
        WordTrans(Address, i, INCR4, data, 0, 0, 0, 0, 0,0);
      }

      /* Random number of idle cycles during degranting */
      j = (rand() % 16) + 1;
      WrWaitLoop(j);
      data = data + i;
      if (Busy == 1)
      {
        /* Rebuild of the burst after getting grant again */
        WordTrans(Address + (4*i), 4 - i, INCR4, data, 0, 0, 0, 0, 0,0);
      }
      else
        WordTrans(Address + (4*i), 4 - i, INCR, data, 0, 0, 0, 0, 0,0);

      C("Read data with bus degrant");
      /* Check data through reads */
      data = 0x33333333;
      WordRd(Address, 4, INCR4, data,idlest);
    }
  }

  C("INCR burst termination and rebuild");
  data = 0x44444444;
  for (k = 0; k < 3; k++)
  {
     for (i = 1; i < 5; i ++)
     {
        /* INCR burst termination due to degranting */
       chip = rand() % 8;
       if(chip > 3)
       {
          Address = rand() & 0x0FFFFFFC;
          Address = Address | chip << 28;
       }
       else 
       {
          Address = rand() & 0x000000FC;
          Address = Address | chip << 28;
       }

       temp = rand() % 4;
       Address = Address + (4*temp);

       /* Check whether the burst will cross a 1KB boundary */
       /* Change the address if it crosses a 1KB boundary */
       LoBits = Address & 0x03FF;
       Bound  = LoBits + 24;
       if (Bound > 1024)
         Address = Address - 24;

       if (Busy == 1)
       {
          /* Random number of BUSY transfers */
          BusyCnt = (rand() % 30) + 1;

          /* NSEQ-SEQ-BUSY sequence */
          WordTrans(Address, i, INCR, data, BusyCnt, i-1, 1, 0, 0,0);
       }
       else
       {
         /* NSEQ-SEQ sequence */
         WordTrans(Address, i, INCR, data, 0, 0, 0, 0, 0,0);
       }

       /* Random number of idle cycles during degranting */
       j = (rand() % 16) + 1;
       WrWaitLoop(j);

       data = data + i;
       /* Rebuild of the burst after getting grant again */
       WordTrans(Address + (4*i), 6 - i, INCR, data, 0, 0, 0, 0, 0,0);
       data = 0x44444444;
       /* Check data through reads */
       C("Read data back with bus degrant");
       WordRd(Address, 6, INCR, data,idlest);
     }
  }

  C("INCR8 burst termination and rebuild");
  data = 0x44444444;
  for (k = 0; k < 3; k++)
  {
     for (i = 1; i < 5; i ++)
     {
        /* INCR8 burst termination due to degranting */

        chip = rand() % 8;
        if(chip < 4)
        {
           Address = rand() & 0x000000FC;
           Address = Address | chip << 28; 
        }
        else
        {
          Address = rand() & 0x0FFFFFFC;
          Address = Address | chip << 28;
        }
        temp = rand() % 4;
        Address = Address + (4*temp);

        /* Check whether the burst will cross a 1KB boundary */
        /* Change the address if it crosses a 1KB boundary */
        LoBits = Address & 0x03FF;
        Bound  = LoBits + 32;
        if (Bound > 1024)
          Address = Address - 32;

        if (Busy == 1)
        {
           /* Random number of BUSY transfers */
           BusyCnt = (rand() % 30) + 1;

           /* NSEQ-SEQ-BUSY sequence */
           WordTrans(Address, i, INCR8, data, BusyCnt, i-1, 1, 0, 0,0);
        }
        else
        {
           /* NSEQ-SEQ sequence */
           WordTrans(Address, i, INCR8, data, 0, 0, 0, 0, 0,0);
        }
        /* Random number of idle cycles during degranting */
        j = (rand() % 16) + 1;
        WrWaitLoop(j);
        data = data + i;
        if (Busy == 1)
        {
           /* Rebuild of the burst after getting grant again */
           WordTrans(Address + (4*i), 8 - i, INCR8, data, 0, 0, 0, 0, 0,0);
        }
        else
           WordTrans(Address + (4*i), 8 - i, INCR, data, 0, 0, 0, 0, 0,0);

        /* Check data through reads */
        data = 0x44444444;
        C("Read data back with bus degrant");
        WordRd(Address, 8, INCR8, data,idlest);
     }
  }

  C("INCR16 burst termination and rebuild");
  data = 0x55555555;
  for (k = 0; k < 3; k++)
  {
    for (i = 1; i < 5; i ++)
    {
      /* INCR16 burst termination due to degranting */

      chip = rand() % 8;
      if(chip < 4)
      {
        Address = rand() & 0x000000FC;
        Address = Address | chip << 28; 
      }
      else
      {
        Address = rand() & 0x0FFFFFFC;
        Address = Address | chip << 28;
      }

      temp = rand() % 4;
      Address = Address + (4*temp);

      /* Check whether the burst will cross a 1KB boundary */
      /* Change the address if it crosses a 1KB boundary */
      LoBits = Address & 0x03FF;
      Bound  = LoBits + 64;
      if (Bound > 1024)
        Address = Address - 64;

      if (Busy == 1)
      {
        /* Random number of BUSY transfers */
        BusyCnt = (rand() % 30) + 1;

        /* NSEQ-SEQ-BUSY sequence */
        WordTrans(Address, i, INCR16, data, BusyCnt, i-1, 1, 0, 0,0);
      }
      else
      {
        /* NSEQ-SEQ sequence */
        WordTrans(Address, i, INCR16, data, 0, 0, 0, 0, 0,0);
      }

      /* Random number of idle cycles during degranting */
      j = (rand() % 16) + 1;
      WrWaitLoop(j);

      data = data + i;
      if (Busy == 1)
      {
        /* Rebuild of the burst after getting grant again */
        WordTrans(Address + (4*i), 16 - i, INCR16, data, 0, 0, 0, 0, 0,0);
      }
      else
        WordTrans(Address + (4*i), 16 - i, INCR, data, 0, 0, 0, 0, 0,0);

      data = 0x55555555; 
      /* Check data through reads */
      C("Read data back with bus degrant");
      WordRd(Address, 16, INCR16, data,idlest);
    }
  }

  C("WRAP4 burst termination and rebuild");

  data = 0x44444444;
  for (k = 0; k < 3; k ++)
  {
    for (i = 1; i < 4; i ++)
    {
      /* WRAP4 Burst termination due to degranting of the master*/

      chip = rand() % 8;
      if(chip < 4)
      {
        Address = rand() & 0x000000F0;
        Address = Address | chip << 28; 
        QWStart   = Address;
      }
      else  
      {
        Address = rand() & 0x0FFFFF00;
        Address = Address | chip << 28;
        QWStart   = Address;
      }

      temp = 0;
      Address = Address + (4*temp);

      if (Busy == 1)
      {
        /* Random number of BUSY transfers */
        BusyCnt = (rand() % 30) + 1;

        /* NSEQ-SEQ-BUSY sequence */
        WordTrans(Address, i, WRAP4, data, BusyCnt, i-1, 1, 0, 0,0);
      }
      else
      {
        /* NSEQ-SEQ sequence */
        WordTrans(Address, i, WRAP4, data, 0, 0, 0, 0, 0,0);
      }
  
      /* Random number of idle cycles during degranting */
      j = (rand() % 16) + 1;
      WrWaitLoop(j);
  
      data = data + i;
      /* Rebuild of the burst after getting grant again */
      if ((temp + i ) <= 4)
      {
        /* Burst was interrupted before the address wrapped around */
        WordTrans(Address + (4*i), 4-temp-i, WRAP4, data, 0, 0, 0, 0, 0,0);
        WordTrans(Address - (4*temp), temp, WRAP4, data, 0, 0, 0, 0, 0,0);
      }
      else
      {
        data = data + 1;
        /* Burst was interrupted after the address wrapped around */
        WordTrans(QWStart + 4*(temp+i-4),(4 - i),WRAP4,data, 0, 0, 0,0,0,0);
      }
      /* Check data through reads */
      data = 0x44444444;
      C("Read data back with bus degrant");
      WordRd(Address, 3, WRAP4, data,idlest);
    }
  }

  C("WRAP8 burst termination and rebuild");

  data = 0x55555555;
  for (k = 0; k < 3; k ++)
  {
    for (i = 1; i < 3; i ++)
    {
      /* WRAP8 burst termination due to degranting */

      chip = rand() % 8;
      if(chip < 4)
      {
        Address = rand() & 0x000000F0;
        Address = Address | chip << 28; 
        QWStart   = Address;
      }
      else
      {
        Address = rand() & 0x0FFFF000;
        Address = Address | chip << 28;
        QWStart   = Address;
      }
      temp = 0;
      Address = Address + (4*temp);

      if (Busy == 1)
      {
        /* Random number of BUSY transfers */
        BusyCnt = (rand() % 30) + 1;

        /* NSEQ-SEQ-BUSY sequence */
        WordTrans(Address, i, WRAP8, data, BusyCnt, i-1, 1, 0, 0,0);
      }
      else
      {
        /* NSEQ-SEQ sequence */
        WordTrans(Address, i, WRAP8, data, 0, 0, 0, 0, 0,0);
      }

      /* Random number of idle cycles during degranting */
      j = (rand() % 16) + 1;
      WrWaitLoop(j);

      data = data + i;
      /* Rebuild of the burst after getting grant again */
      if ((temp + i ) <= 8)
      {
        /* Burst was interrupted before the address wrapped around */
        WordTrans(Address + (4*i), 8-temp-i, WRAP8, data, 0, 0, 0, 0, 0,0);
        WordTrans(Address - (4*temp), temp, WRAP8, data, 0, 0, 0, 0, 0,0);
      }
      else
      {
        /* Burst was interrupted after the address wrapped around */
        WordTrans(QWStart + 4*(temp+i-8),(8 - i),WRAP8,data, 0, 0, 0,0,0,0);
      }

      data = 0x55555555;
      /* Check data through reads */
      C("Read data back with bus degrant");
      WordRd(Address, 8, WRAP8, data,idlest);
    }
  }

  C("WRAP16 burst termination and rebuild");

  data = 0x66666666;
  for (k = 0; k < 3; k ++)
  {
    for (i = 1; i < 3; i ++)
    {
      /* WRAP16 burst termination due to degranting */

      chip = rand() % 8;
      if(chip < 4)
      {
        Address = 0x00000000;
        Address = Address | chip << 28; 
        QWStart   = Address;
      }
      else
      {
        Address = 0x00000000;
        Address = Address | chip << 28;
        QWStart   = Address;
      }
      temp = 0;
      Address = Address + (4*temp);

      if (Busy == 1)
      {
        /* Random number of BUSY transfers */
        BusyCnt = (rand() % 30) + 1;

        /* NSEQ-SEQ-BUSY sequence */
        WordTrans(Address, i, WRAP16, data, BusyCnt, i-1, 1, 0, 0,0);
      }
      else
      {
        /* NSEQ-SEQ sequence */
        WordTrans(Address, i, WRAP16, data, 0, 0, 0, 0, 0,0);
      }

      /* Random number of idle cycles during degranting */
      j = (rand() % 16) + 1;
      WrWaitLoop(j);

      data = data + i;
      /* Rebuild of the burst after getting grant again */
      if (temp + i <= 16)
      {
        /* Burst was interrupted before the address wrapped around */
        WordTrans(Address + (4*i), 16-temp-i, WRAP16, data,0,0, 0, 0, 0,0);
        WordTrans(Address - (4*temp), temp, WRAP16, data, 0, 0, 0, 0, 0,0);
      }
      else
      {
        /* Burst was interrupted after the address wrapped around */
        WordTrans(QWStart+4*(temp+i-16), (16 - i),WRAP16, data, 0, 0, 0,0,0,0);
      }

      data = 0x66666666;
      /* Check data through reads */
      C("Read data back with bus degrant");
      WordRd(Address, 15, WRAP16, data,idlest);
    }
  }
}
/*-- --================================ End ================================--*/
