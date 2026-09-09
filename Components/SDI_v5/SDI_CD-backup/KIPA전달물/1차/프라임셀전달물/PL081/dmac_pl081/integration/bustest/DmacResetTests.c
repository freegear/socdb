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
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Reset Tests on the Dmac.  
--
-- --=========================================================================*/

/******************************************************************************/
/********************************* Reset Tests ********************************/
/******************************************************************************/

void ResetTests()
{
  int32 regaddr;
  int32 ahbaddr;
  char *regname;
  char *nextreg;
  int32 rstval;
  char *rstname;
  int32 count = 0;
  int result = 0;
  int TestReservedRegisters = 0;
  char debugstr[100];

  /*
     Summary: Reset Tests
     ====================
     This function performs the following: 

     o  All the Registers are read and their reset values are checked. 
  */ 

  C("Test No : DMA_REG_RST");
  regname = "DMACIntStat";
  rstname = "RST_DMACIntStat";
  regaddr = DMAC_BASE;

  if (TestReservedRegisters)
  {
    while (regaddr <= DMAC_REGADDR_LIMIT)
    {
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

      HSA(regaddr, NSEQ, SINGLE, OK, WRD, 0x0, 0x0, , 0x0, , , );
      HSR( , rstval, , NoMask, ,ResetTests);
  
      regaddr = regaddr + 0x00000004;
    }
  }
  else
  {
    while (regname != "LASTREG")
    {
      regaddr = strconst(regname);
      rstval  = strconst(rstname);
  
      sprintf(debugstr,"%s",regname);
      debug_info(debugstr);
  
      HSA(regaddr, NSEQ, SINGLE, OK, WRD, 0x0, 0x0, , 0x0, , , );
      HSR( , rstval, , NoMask, ,ResetTests);
  
      regname = NextRegisterName(regname);
      rstname = stringcat("RST_",regname);
    }
  }
}

/************************************ End *************************************/
