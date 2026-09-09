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
-- File Name              : DmacResetTests.c.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Performs Reset Tests on the Dmac registers.
--
-- --=========================================================================*/
 
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** debug_info                                 DmacCommon.c                ***/
/*** strconst                                   DmacCommon.c                ***/
/*** stringcat                                  DmacCommon.c                ***/
/*** IsDmacReg                                  DmacCommon.c                ***/
/*** NextRegisterName                           DmacCommon.c                ***/
/*** RegisterName                               DmacCommon.c                ***/
/******************************************************************************/

void ResetTests()
{
  /*
     Summary: Reset Tests
     ====================
     o  Read the reset values of all Dmac registers. If the variable
        TestReservedRegisters is set to 1, then all the reserved registers of
        the Dmac are also read. Otherwise only the valid registers of the Dmac
        are tested for their reset values.
  */

  int32 regaddr;
  char *regname;
  int32 rstval;
  char *rstname;
  int TestReservedRegisters = 0;
  char debugstr[100];

  C("Test No : DMA_REG_RST");

  regname = "DMACIntStat";
  rstname = "RST_DMACIntStat";
  regaddr = DMAC_BASE;

  /* If the reserved registers should also be tested for the reset values,
     then variable "TestReservedRegisters" in this file should be set to 1. */
  if (TestReservedRegisters)
  {
    while (regaddr <= DMAC_REGADDR_LIMIT)
    {
      /* Starting from Dmac register address base, increment the address by
         4 (word-wide). If the address corresponds to a valid Dmac register,
         check for its reset value. Otherwise check that zero is returned from
         the reserved register address.                                       */
      if (IsDmacReg(regaddr) == 1)
      {
       regname = RegisterName(regaddr);
       rstname = stringcat("RST_",regname);
       rstval  = strconst(rstname);
      }
      else
      {
        regname = RegisterName(regaddr);
        rstval = 0x00000000;
      }

      sprintf(debugstr,"%s",regname);
      debug_info(debugstr);

      Read(regaddr, rstval, NoMask);
  
      regaddr = regaddr + 0x00000004;
    }
  }
  else
  {
    /* Only the valid registers of Dmac are tested for their reset values. */
    while (regname != "LASTREG")
    {
      regaddr = strconst(regname);
      rstval  = strconst(rstname);
  
      sprintf(debugstr,"%s",regname);
      debug_info(debugstr);
  
      Read(regaddr, rstval, NoMask);
  
      regname = NextRegisterName(regname);
      rstname = stringcat("RST_",regname);
    }
  }
}
/************************************ End *************************************/
