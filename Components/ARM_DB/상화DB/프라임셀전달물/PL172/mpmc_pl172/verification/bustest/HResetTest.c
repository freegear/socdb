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
-- File Name              : HResetTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Performs Reset Tests on the Mpmc registers.
--
--           Test No : MPMC_REG_HRST
--
-- --=========================================================================*/
 
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** debug_info                                 Common.c                ***/
/*** strconst                                   Common.c                ***/
/*** stringcat                                  Common.c                ***/
/*** IsMpmcReg                                  Common.c                ***/
/*** NextRegisterName                           Common.c                ***/
/*** RegisterName                               Common.c                ***/
/******************************************************************************/
void HResetTest()
{
  /*
     Summary: HReset Tests
     =====================
     o  Read the HRESETn reset values of all Mpmc registers. If the variable
        TestReservedRegisters is set to 1, then all the reserved registers of
        the Mpmc are also read. Otherwise only the valid registers of the Mpmc
        are tested for their reset values.
  */

  int32 regaddr;
  char *regname;
  int32 rstval;
  char *rstname;
  char *MaskName;
  int32 MaskVal;
  int TestReservedRegisters = 0;
  char debugstr[100];
  C("Test No : MPMC_REG_HRST");
 
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  regname = "MPMCControl";
  rstname = "HRST_MPMCControl";
  regaddr = MPMC_BASE;

  /* If the reserved registers should also be tested for the reset values,
     then variable "TestReservedRegisters" in this file should be set to 1. */
  if (TestReservedRegisters)
  {
    while (regaddr <= MPMC_REGADDR_LIMIT)
    {
      /* Starting from Mpmc register address base, increment the address by
         4 (word-wide). If the address corresponds to a valid Mpmc register,
         check for its Hreset value. Otherwise check that zero is returned from
         the reserved register address.                                       */
      if (IsHMpmcReg(regaddr) == 1)
      {
       regname = RegisterName(regaddr);
       rstname = stringcat("HRST_",regname);
       rstval  = strconst(rstname);
      }
      else
      {
        regname = RegisterName(regaddr);
        rstval = 0x00000000;
      }

      sprintf(debugstr,"%s",regname);
      debug_info(debugstr);
      MaskName = stringcat("HMASK_",regname);
      MaskVal = strconst(MaskName); 
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
      MaskName = stringcat("HMASK_",regname);
      MaskVal = strconst(MaskName); 
      sprintf(debugstr,"%s",regname);
      debug_info(debugstr);
      ReadRes(regaddr, rstval, MaskVal);
  
      regname = NextHRegisterName(regname);
      rstname = stringcat("HRST_",regname);
    }
  }
}
/************************************ End *************************************/
