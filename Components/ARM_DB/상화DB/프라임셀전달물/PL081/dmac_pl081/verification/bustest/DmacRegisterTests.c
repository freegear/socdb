/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : DmacRegisterTests.c.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Performs read-write tests on the Dmac registers.
-- --=========================================================================*/
 
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/***  strconst                                   DmacCommon.c               ***/
/***  stringcat                                  DmacCommon.c               ***/
/***  IdleWrite                                  DmacCommon.c               ***/
/***  IsReadOnly                                 DmacCommon.c               ***/
/***  IsWriteOnly                                DmacCommon.c               ***/
/***  NextRegisterName                           DmacCommon.c               ***/
/***  Random                                     DmacCommon.c               ***/
/***  Read                                       DmacCommon.c               ***/
/***  ReadErr                                    DmacCommon.c               ***/
/***  RegRead                                    DmacCommon.c               ***/
/***  RegWrite                                   DmacCommon.c               ***/
/***  Write                                      DmacCommon.c               ***/
/***  WriteAllReg                                DmacCommon.c               ***/
/***  WriteErr                                   DmacCommon.c               ***/
/******************************************************************************/

void RegisterTests()
{
  /*
     Summary: Register Tests
     =======================
     o  All the Registers are written with different patterns and read
        back to verify the readable/writeable bits in a register.
     o  The tests are further extended to check that the registers are
        correctly addressed.
  */

  int32 RegAddr;
  char  *RegName;
  char  *NextReg;
  int32 WriteData;
  int32 ExpData;
  int32 DataMask;
  char  debugstr[100];
  int32 DataArray[]  = {0x00000000, 0xFFFFFFFF, 0x55555555, 0xAAAAAAAA,
                        0x33333333, 0xCCCCCCCC, 0x0F0F0F0F, 0xF0F0F0F0,
                        0x00FF00FF, 0xFF00FF00, 0x0000FFFF, 0xFFFF0000,
                        0x00000000};
  char  DataSize[]   = {BYTE, HWRD, DWRD, 'E'};
  int32 *DataPattern = DataArray;
  char  Size;
  char* Trans;
  int32 RandData[100];
  int   i,j,k;

  C("Test No : DMA_REG_RW_1");

  /* First write the write pattern to all the registers. If a register is a
     read-only register, then the expected value is the read-only value of the
     respective register. If a register is a write-only register, then expect
     only zeros from the registers. If a register is read-write register, then
     the expected value is logic "AND" of the write pattern and mask pattern.
     The test is repeated for each data pattern defined in the variable
     "DataArray".
  */

  do
  {
    WriteAllReg(*DataPattern);
    RegName = "DMACIntStat";
    RegAddr = strconst(RegName);
    while (RegName != "LASTREG")
    {
      sprintf(debugstr,"%X",RegAddr);
      debug_info(debugstr);
      if (IsReadOnly(RegAddr) == 1)
      {
        ExpData = strconst(stringcat("RDO_",RegName));
      }
      else if (IsWriteOnly(RegAddr) == 1)
      {
        ExpData = 0x00000000;
      }
      else
      {
        ExpData = strconst(stringcat("MASK_",RegName)) & (*DataPattern);

        /* Dma controller is disabled during the register tests. */
        if (RegName == "DMACConfig")
        {
          ExpData = ExpData & DMACDISABLE;
        }
        else if (RegName == "DMACTCR")
        {
          ExpData = ExpData & (~TESTMODE);
        }

        /* All channels are disabled during the register tests. */
        else if ((RegName == "DMACC0Config") || (RegName == "DMACC1Config") ||
                 (RegName == "DMACC2Config") || (RegName == "DMACC3Config") ||
                 (RegName == "DMACC4Config") || (RegName == "DMACC5Config") ||
                 (RegName == "DMACC6Config") || (RegName == "DMACC7Config"))
        {
          ExpData = ExpData & CHXDISABLE;
        }
      }

      Read(RegAddr, ExpData, NoMask);
      RegName = NextRegisterName(RegName);
      RegAddr = strconst(RegName);
    }
    DataPattern++;
  }
  while (*DataPattern != 0x00000000);

  C("Test No : DMA_REG_RW_2");

  /* 
     This test is to check that the registers are correctly addressed.
     This test will group 2 registers in each group and write a data
     pattern into them.
     They are read back to verify that the registers are correctly addressed.
  */
  RegWrite(0x00000000, 2);
  RegRead(0x0000000, 2);

  RegWrite(0xFFFFFFFF, 2);
  RegRead(0xFFFFFFFF, 2);

  C("Test No : DMA_REG_RW_3");

  /* 
     This test is to check that the registers are correctly addressed.
     This test will group 4 registers in each group and write a data
     pattern into them.
     They are read back to verify that the registers are correctly addressed.
  */
  RegWrite(0x00000000, 4);
  RegRead(0x0000000, 4);

  RegWrite(0xFFFFFFFF, 4);
  RegRead(0xFFFFFFFF, 4);

  C("Test No : DMA_REG_RW_4");

  /* 
     This test is to check that the registers are correctly addressed.
     This test will group 8 registers in each group and write a data
     pattern into them.
     They are read back to verify that the registers are correctly addressed.
  */
  RegWrite(0x00000000, 8);
  RegRead(0x0000000, 8);

  RegWrite(0xFFFFFFFF, 8);
  RegRead(0xFFFFFFFF, 8);

  C("Test No : DMA_REG_RW_5");

  /* 
     This test is to check that the registers are correctly addressed.
     This test will group 16 registers in each group and write a data
     pattern into them.
     They are read back to verify that the registers are correctly addressed.
  */
  RegWrite(0x00000000, 16);
  RegRead(0x0000000, 16);

  RegWrite(0xFFFFFFFF, 16);
  RegRead(0xFFFFFFFF, 16);

  C("Test No : DMA_REG_RW_6");

  /* 
     This test is to check that the registers are correctly addressed.
     This test will group 32 registers in each group and write a data
     pattern into them.
     They are read back to verify that the registers are correctly addressed.
  */
  RegWrite(0x00000000, 32);
  RegRead(0x0000000, 32);

  RegWrite(0xFFFFFFFF, 32);
  RegRead(0xFFFFFFFF, 32);

  C("Test No : DMA_REG_RW_7");

  /* 
     This test is to check that the registers are correctly addressed.
     This test will group 64 registers in each group and write a data
     pattern into them.
     They are read back to verify that the registers are correctly addressed.
  */
  RegWrite(0x00000000, 64);
  RegRead(0x0000000, 64);

  RegWrite(0xFFFFFFFF, 64);
  RegRead(0xFFFFFFFF, 64);

  C("Test No : DMA_REG_BHW_1");

  /* The register are written with a random data and the random data is
     read back and verified. Following that, the registers are accessed
     with the data size as byte/half-word/reserved HSIZE values.
     These write accesses should not be accepted by the Dmac and the
     registers should not be updated. This is verified by reading the
     registers again.                                                    */

  RegName = "DMACIntStat";
  i = 0;

  while (RegName != "LASTREG")
  {
    RandData[i] = Random();

    RegAddr = strconst(RegName);

    /* Dmac is disabled during the register tests. */
    if (RegName == "DMACConfig")
    {
      RandData[i] = RandData[i] & DMACDISABLE;
    }
    else if (RegName == "DMACTCR")
    {
      RandData[i] = RandData[i] & (~TESTMODE);
    }

    /* All channels of the Dmac are disabled during the register tests. */
    else if ((RegName == "DMACC0Config") || (RegName == "DMACC1Config") ||
             (RegName == "DMACC2Config") || (RegName == "DMACC3Config") ||
             (RegName == "DMACC4Config") || (RegName == "DMACC5Config") ||
             (RegName == "DMACC6Config") || (RegName == "DMACC7Config"))
    {
      RandData[i] = RandData[i] & CHXDISABLE;
    }

    Write(RegAddr, RandData[i++]);
    RegName = NextRegisterName(RegName);
  }

  RegName = "DMACIntStat";
  i = 0;

  while (RegName != "LASTREG")
  {
    RegAddr = strconst(RegName);
    if (IsReadOnly(RegAddr) == 1)
    {
      ExpData = strconst(stringcat("RDO_",RegName));
    }
    else if (IsWriteOnly(RegAddr) == 1)
    {
      ExpData = 0x00000000;
    }
    else
    {
      ExpData = strconst(stringcat("MASK_",RegName)) & (RandData[i]);
    }

    Read(RegAddr, ExpData, NoMask);
    RegName = NextRegisterName(RegName);
    i++;
  }

  /* Initiate a byte/half-word/double-word write access to every
     register and ensure that the Dmac returns an error response and
     does not modify the register.                                   */

  j = 0;
  do
  {
    RegName = "DMACIntStat";

    while (RegName != "LASTREG")
    {
      WriteData  =  Random();

      RegAddr = strconst(RegName);
      Size    = *(DataSize + j);
      if (RegName == "DMACConfig")
      {
        WriteData = WriteData & DMACDISABLE;
      }

      /* Size can be byte/half-word/dword. */
      WriteErr(RegAddr, WriteData, Size);
      RegName = NextRegisterName(RegName);
    }

    RegName = "DMACIntStat";
    i = 0;

    while (RegName != "LASTREG")
    {
      RegAddr = strconst(RegName);
      if (IsReadOnly(RegAddr) == 1)
      {
        ExpData = strconst(stringcat("RDO_",RegName));
      }
      else if (IsWriteOnly(RegAddr) == 1)
      {
        ExpData = 0x00000000;
      }
      else
      {
        ExpData = strconst(stringcat("MASK_",RegName)) & (RandData[i]);
      }

      Read(RegAddr, ExpData, NoMask);
      RegName = NextRegisterName(RegName);
      i++;
    }
    j++;
  }
  while (*(DataSize + j) != 'E');

  /* Initiate byte/half-word/dword read access to the registers
     and verify that the Dmac returns an error response.
     Also check that it does not change the data in the register.
  */

  j = 0;

  do
  {
    RegName = "DMACIntStat";
    i = 0;

    while (RegName != "LASTREG")
    {
      RegAddr = strconst(RegName);
      if (IsReadOnly(RegAddr) == 1)
      {
        ExpData = strconst(stringcat("RDO_",RegName));
      }
      else if (IsWriteOnly(RegAddr) == 1)
      {
        ExpData = 0x00000000;
      }
      else
      {
        ExpData = strconst(stringcat("MASK_",RegName)) & (RandData[i]);
      }

      Size = *(DataSize + j);
      ReadErr(RegAddr, ExpData, NoMask, Size);
      RegName = NextRegisterName(RegName);
      i++;
    }

    RegName = "DMACIntStat";
    i = 0;

    while (RegName != "LASTREG")
    {
      RegAddr = strconst(RegName);
      if (IsReadOnly(RegAddr) == 1)
      {
        ExpData = strconst(stringcat("RDO_",RegName));
      }
      else if (IsWriteOnly(RegAddr) == 1)
      {
        ExpData = 0x00000000;
      }
      else
      {
        ExpData = strconst(stringcat("MASK_",RegName)) & (RandData[i]);
      }

      Read(RegAddr, ExpData, NoMask);
      RegName = NextRegisterName(RegName);
      i++;
    }
    j++;
  }
  while (*(DataSize + j) != 'E');

  C("Test No : DMA_REG_BHW_2");

  /* Initiate idle transfers with byte/half-word/dword
     write and read accesses and verify that the Dmac returns only
     okay response and does not update the registers.              */

  j = 0;

  do
  {
    sprintf(debugstr,"HSIZE is %b",*(DataSize + j));
    C(debugstr);
    for (i=0; i < 1024; i = i+4)
    {
      RegAddr = DMAC_BASE + i;
      Size    = *(DataSize + j);
      WriteData  =  Random();

      IdleWrite(RegAddr, WriteData, Size);
    }

    RegName = "DMACIntStat";
    i = 0;

    while (RegName != "LASTREG")
    {
      RegAddr = strconst(RegName);
      if (IsReadOnly(RegAddr) == 1)
      {
        ExpData = strconst(stringcat("RDO_",RegName));
      }
      else if (IsWriteOnly(RegAddr) == 1)
      {
        ExpData = 0x00000000;
      }
      else
      {
        ExpData = strconst(stringcat("MASK_",RegName)) & (RandData[i]);
      }

      Read(RegAddr, ExpData, NoMask);
      RegName = NextRegisterName(RegName);
      i++;
    }
    j++;
  }
  while (*(DataSize + j) != 'E');
}

/************************************* End ************************************/
