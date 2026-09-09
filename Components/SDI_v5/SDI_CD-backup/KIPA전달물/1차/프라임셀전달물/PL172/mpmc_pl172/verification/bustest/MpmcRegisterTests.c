/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : MpmcRegisterTests.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Performs read-write tests on the Mpmc registers.
-- 
--           Test No : MPMC_REG_RW
--
-- --=========================================================================*/
 
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/***  strconst                                   Common.c                   ***/
/***  stringcat                                  Common.c                   ***/
/***  IdleWrite                                  Common.c                   ***/
/***  IsReadOnly                                 Common.c                   ***/
/***  IsWriteOnly                                Common.c                   ***/
/***  NextRegisterName                           Common.c                   ***/
/***  Random                                     Common.c                   ***/
/***  Read                                       Common.c                   ***/
/***  ReadErr                                    Common.c                   ***/
/***  RegRead                                    Common.c                   ***/
/***  RegWrite                                   Common.c                   ***/
/***  Write                                      Common.c                   ***/
/***  WriteAllReg                                Common.c                   ***/
/***  WriteErr                                   Common.c                   ***/
/******************************************************************************/

void MpmcRegisterTests()
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
                        0x00000001};
  char  DataSize[]   = {BYTE, HWRD,'E'};
  int32 *DataPattern = DataArray;
  char  Size;
  char* Trans;
  int32 RandData[100];
  int32 InvData;
  int32 CSPData0;
  int32 CSPData1;
  int32 CSPData2;
  int32 CSPData3;
  int   i,j,k;
  C("WAIT LOOP");
  WaitLoop(0x1);
  
  HSA(MPMCTrCR, NSEQ, INCR, OK, WRD);
  HSW(,0x10);
  C("Test No:MPMC_REG_nPOR");
  WaitLoop(0x15);
  C("Drive MPMCEndian pin high through Trickbox");
  HSA(MPMCTrCR, NSEQ, INCR, OK, WRD);
  HSW(,0x18);
  WaitLoop(0x2);
  C("Apply nPOR");
  REGPOReset();
  WaitLoop(0x2);
  HSA(MPMCTrCR, NSEQ, INCR, OK, WRD);
  HSW(,0x18);
  WaitLoop(0x3);
  C("Read MPMCConfig");
  HSA(MPMCConfig, NSEQ, INCR, OK, WRD);
  HSR(,0x1, ,0x1);
  WaitLoop(0x2);
  C("Write to Endian bit of MPMCConfig");
  HSA(MPMCConfig, NSEQ, INCR, OK, WRD);
  HSW(,0x0);
  WaitLoop(0x2);
  C("Read MPMCConfig");
  HSA(MPMCConfig, NSEQ, INCR, OK, WRD);
  HSR(,0x0, ,0x1);
  WaitLoop(0x2);

  C("Drive MPMCEndian pin low through Trickbox");
  HSA(MPMCTrCR, NSEQ, INCR, OK, WRD);
  HSW(,0x10);
  C("Apply nPOR");
  REGPOReset();
  HSA(MPMCTrCR, NSEQ, INCR, OK, WRD);
  HSW(,0x10);
  WaitLoop(0x3);
  C("Read MPMCConfig");
  HSA(MPMCConfig, NSEQ, INCR, OK, WRD);
  HSR(,0x0, ,0x1);
  WaitLoop(0x2);
  C("Write to Endian bit of MPMCConfig");
  HSA(MPMCConfig, NSEQ, INCR, OK, WRD);
  HSW(,0x1);
  WaitLoop(0x2);
  C("Read MPMCConfig");
  HSA(MPMCConfig, NSEQ, INCR, OK, WRD);
  HSR(,0x1, ,0x1);
  WaitLoop(0x2);
  C("Write to Endian bit of MPMCConfig");
  HSA(MPMCConfig, NSEQ, INCR, OK, WRD);
  HSW(,0x1);
  WaitLoop(0x2);
  C("Read MPMCConfig");
  HSA(MPMCConfig, NSEQ, INCR, OK, WRD);
  HSR(,0x1, ,0x1);
  WaitLoop(0x2);
  for(i = 0; i < 12; i++)
  {
     C("Drive static chip select polarity through Trickbox");
     HSA(MPMCTrStaticCS, NSEQ, INCR, OK, WRD);
     HSW(,DataArray[i]);
     CSPData0 = (DataArray[i] & 0x00000001) << 0x6;
     CSPData1 = (DataArray[i] & 0x00000002) << 0x5;
     CSPData2 = (DataArray[i] & 0x00000004) << 0x4;
     CSPData3 = (DataArray[i] & 0x00000008) << 0x3;
     C("Apply nPOR");
     REGPOReset();
     WaitLoop(0x3);
     HSA(MPMCTrCR, NSEQ, INCR, OK, WRD);
     HSW(,0x10);
     C("Read MPMCStConfig registers");
     HSA(MPMCStConfig0, NSEQ, INCR, OK, WRD);
     HSR(,CSPData0, , 0x00000040);
     WaitLoop(0x2);
     HSA(MPMCStConfig1, NSEQ, INCR, OK, WRD);
     HSR(,CSPData1, , 0x00000040);
     WaitLoop(0x2);
     HSA(MPMCStConfig2, NSEQ, INCR, OK, WRD);
     HSR(,CSPData2, , 0x00000040);
     WaitLoop(0x2);
     HSA(MPMCStConfig3, NSEQ, INCR, OK, WRD);
     HSR(,CSPData3, , 0x00000040);
     WaitLoop(0x2);
     InvData = ~(DataArray[i]);
     C("Write to MPMCStConfig registers");
     HSA(MPMCStConfig0, NSEQ, INCR, OK, WRD);
     HSW(,InvData);
     WaitLoop(0x2);
     HSA(MPMCStConfig1, NSEQ, INCR, OK, WRD);
     HSW(,InvData);
     WaitLoop(0x2);
     HSA(MPMCStConfig2, NSEQ, INCR, OK, WRD);
     HSW(,InvData);
     WaitLoop(0x2);
     HSA(MPMCStConfig3, NSEQ, INCR, OK, WRD);
     HSW(,InvData);
     WaitLoop(0x2);
     C("Read from the MPMCStConfig registers");
     HSA(MPMCStConfig0, NSEQ, INCR, OK, WRD);
     HSR(,InvData, , 0x00000040);
     WaitLoop(0x2);
     HSA(MPMCStConfig1, NSEQ, INCR, OK, WRD);
     HSR(,InvData, , 0x00000040);
     WaitLoop(0x2);
     HSA(MPMCStConfig2, NSEQ, INCR, OK, WRD);
     HSR(,InvData, , 0x00000040);
     WaitLoop(0x2);
     HSA(MPMCStConfig3, NSEQ, INCR, OK, WRD);
     HSR(,InvData, , 0x00000040);
     WaitLoop(0x2);
     HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
     HSW(,0x00000008);
     WaitLoop(0x2);
  }
  C("Test No : MPMC_REG_RW_1");
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(,0x00000000);
  
  /* Disable Protocol checker warning */
  HSA(MPMCTrCR, NSEQ, INCR, OK, WRD);
  HSW(, 0x10); 
  /*
     First write the write pattern to all the registers. If a register is a
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
    RegName = "MPMCControl";
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
      }
      Read(RegAddr, ExpData, MaskALL);
      RegName = NextRegisterName(RegName);
      RegAddr = strconst(RegName);
    }
    DataPattern++;
  }
  while (*DataPattern != 0x00000001);

  C("Test No : MPMC_REG_RW_2");
  
  /* This test is to check that the registers are correctly addressed.
     This test will group 2 registers in each group and write a data
     pattern into them.
     They are read back to verify that the registers are correctly addressed.
  */ 
  RegWrite(0x00000000, 2);
  RegRead(0x0000000, 2);

  RegWrite(0xFFFFFFFF, 2);
  RegRead(0xFFFFFFFF, 2);

  C("Test No : MPMC_REG_RW_3");

   
  /* This test is to check that the registers are correctly addressed.
     This test will group 4 registers in each group and write a data
     pattern into them.
     They are read back to verify that the registers are correctly addressed.
  */ 
  RegWrite(0x00000000, 4);
  RegRead(0x0000000, 4);

  RegWrite(0xFFFFFFFF, 4);
  RegRead(0xFFFFFFFF, 4);

  /* These Write/Read have been added to increase the coverage */
  HSA(0x80000F80, NSEQ, SINGLE, OK, WRD, 0x0, 0x0, , 0x0, , , );
  HSW(,0x00000000);
  HSA(0x80000F80, NSEQ, INCR, OK, WRD);
  HSR(,0x00000000, ,0x00000000);

  C("Test No : MPMC_REG_RW_4");

   
  /* This test is to check that the registers are correctly addressed.
     This test will group 8 registers in each group and write a data
     pattern into them.
     They are read back to verify that the registers are correctly addressed.
  */ 
  RegWrite(0x00000000, 8);
  RegRead(0x0000000, 8);

  RegWrite(0xFFFFFFFF, 8);
  RegRead(0xFFFFFFFF, 8);

  C("Test No : MPMC_REG_RW_5");

   
  /* This test is to check that the registers are correctly addressed.
     This test will group 16 registers in each group and write a data
     pattern into them.
     They are read back to verify that the registers are correctly addressed.
  */ 
  RegWrite(0x00000000, 16);
  RegRead(0x0000000, 16);

  RegWrite(0xFFFFFFFF, 16);
  RegRead(0xFFFFFFFF, 16);

  C("Test No : MPMC_REG_RW_6");

   
  /* This test is to check that the registers are correctly addressed.
     This test will group 32 registers in each group and write a data
     pattern into them.
     They are read back to verify that the registers are correctly addressed.
  */ 
  RegWrite(0x00000000, 32);
  RegRead(0x0000000, 32);

  RegWrite(0xFFFFFFFF, 32);
  RegRead(0xFFFFFFFF, 32);

  C("Test No : MPMC_REG_RW_7");

   
  /* This test is to check that the registers are correctly addressed.
     This test will group 64 registers in each group and write a data
     pattern into them.
     They are read back to verify that the registers are correctly addressed.
  */ 
  RegWrite(0x00000000, 64);
  RegRead(0x0000000, 64);

  RegWrite(0xFFFFFFFF, 64);
  RegRead(0xFFFFFFFF, 64);

  C("Test No : MPMC_REG_BHW_1");
  
  /* The register are written with a random data and the random data is
     read back and verified. Following that, the registers are accessed
     with the data size as byte/half-word/reserved HSIZE values.
     These write accesses should not be accepted by the Mpmc and the
     registers should not be updated. This is verified by reading the
     registers again.  
  */                                                    
  RegName = "MPMCControl";
  i = 0;

  while (RegName != "LASTREG")
  {
    RandData[i] = Random();

    RegAddr = strconst(RegName);
    if(RegAddr == MPMC_BASE)
      RandData[i] = RandData[i] & 0xFFFFFFFE;

    Write(RegAddr, RandData[i++]);
    RegName = NextRegisterName(RegName);
  }

  RegName = "MPMCControl";
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

    Read(RegAddr, ExpData, MaskALL);
    RegName = NextRegisterName(RegName);
    i++;
  }
  
  /* Initiate a byte/half-word/double-word write access to every
     register and ensure that the Mpmc returns an error response and
     does not modify the register.   */                                   
  
  j = 0;
  do
  {
    RegName = "MPMCControl";

    while (RegName != "LASTREG")
    {
      WriteData  =  Random();

      RegAddr = strconst(RegName);
      Size    = *(DataSize + j);

      /*  Size can be byte/half-word    */ 
      WriteErr(RegAddr, WriteData, Size);
      RegName = NextRegisterName(RegName);
    }

    RegName = "MPMCControl";
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

      Read(RegAddr, ExpData, MaskALL);
      RegName = NextRegisterName(RegName);
      i++;
    }
    j++;
  }
  while (*(DataSize + j) != 'E');
  
  /* Initiate byte/half-word read access to the registers
     and verify that the Mpmc returns an error response.
     Also check that it does not change the data in the register.
  */ 

  j = 0;

  do
  {
    RegName = "MPMCControl";
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
      ReadErr(RegAddr, ExpData, MaskALL, Size);
      RegName = NextRegisterName(RegName);
      i++;
    }

    RegName = "MPMCControl";
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

      Read(RegAddr, ExpData, MaskALL);
      RegName = NextRegisterName(RegName);
      i++;
    }
    j++;
  }
  while (*(DataSize + j) != 'E');

  C("Test No : MPMC_REG_BHW_2");
  
  /* Initiate idle transfers with byte/half-word/dword
     write and read accesses and verify that the Mpmc returns only
     okay response and does not update the registers.              
  */ 
  j = 0;

  do
  {
    sprintf(debugstr,"HSIZE is %b",*(DataSize + j));
    C(debugstr);
    for (i=0; i < 1024; i = i+4)
    {
      RegAddr = MPMC_BASE + i;
      Size    = *(DataSize + j);
      WriteData  =  Random();

      IdleWrite(RegAddr, WriteData, Size);
    }

    RegName = "MPMCControl";
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

      Read(RegAddr, ExpData, MaskALL);
      RegName = NextRegisterName(RegName);
      i++;
    }
    j++;
  }
  while (*(DataSize + j) != 'E');
}
/************************************* End ************************************/
