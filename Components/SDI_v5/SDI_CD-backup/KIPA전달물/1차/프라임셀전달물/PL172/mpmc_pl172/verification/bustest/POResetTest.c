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
-- File Name              : POResetTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Performs Reset Tests on the Mpmc registers.
--
--           Test No : MPMC_REG_RST
--
-- --=========================================================================*/
 
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** debug_info                                 Common.c                    ***/
/*** strconst                                   Common.c                    ***/
/*** stringcat                                  Common.c                    ***/
/*** IsMpmcReg                                  Common.c                    ***/
/*** NextRegisterName                           Common.c                    ***/
/*** RegisterName                               Common.c                    ***/
/******************************************************************************/

void POResetTest()
{
  /*
     Summary: POResetTest
     ====================
     o  Read the PowerOnreset values of all Mpmc registers. If the variable
        TestReservedRegisters is set to 1, then all the reserved registers of
        the Mpmc are also read. Otherwise only the valid registers of the Mpmc
        are tested for their reset values.
  */

  int32 regaddr;
  char *regname;
  int32 rstval;
  char *MaskName;
  int32 MaskVal;
  char *rstname;
  int TestReservedRegisters = 0;
  char debugstr[100];

  C("Test No : MPMC_REG_RST");
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(,0x0000000);

  regname = "MPMCControl";
  rstname = "PRST_MPMCControl";
  regaddr = MPMC_BASE;
  POReset();
  WaitLoop(0x2);
  /* If the reserved registers should also be tested for the reset values,
     then variable "TestReservedRegisters" in this file should be set to 1. */
  if (TestReservedRegisters)
  {
    while (regaddr <= MPMC_REGADDR_LIMIT)
    {
      /* Starting from Mpmc register address base, increment the address by
         4 (word-wide). If the address corresponds to a valid Mpmc register,
         check for its reset value. Otherwise check that zero is returned from
         the reserved register address.                                       */
      if (IsMpmcReg(regaddr) == 1)
      {
        regname = RegisterName(regaddr);
        rstname = stringcat("PRST_",regname);
        rstval  = strconst(rstname);
      }
      else
      {
        regname = RegisterName(regaddr);
        rstval = 0x00000000;
      }
      MaskName = stringcat("PMASK_",regname);
      MaskVal = strconst(MaskName);
      sprintf(debugstr,"%s",regname);
      debug_info(debugstr);
      ReadRes(regaddr, rstval, MaskVal);
      regaddr = regaddr + 0x00000004;
    }
  } 
  else
  {
    /* Only the valid registers of Mpmc are tested for their reset values. */
    while (regname != "LASTREG")
    {
      regaddr = strconst(regname);
      rstval  = strconst(rstname);
      MaskName = stringcat("PMASK_",regname);
      MaskVal = strconst(MaskName);
      sprintf(debugstr,"%s",regname);
      debug_info(debugstr);
      ReadRes(regaddr, rstval, MaskVal);
  
      regname = NextPRegisterName(regname);
      rstname = stringcat("PRST_",regname);
    }
  }
  /* Commented because all register tests are run continuously */
  /*  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(,0x0000008); */
}
/************************************ End *************************************/
