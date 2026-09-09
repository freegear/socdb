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
-- File Name              : IntRegisterTest.c.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           Performs read-write tests on the integration registers.
--
-- --=======================================================================--*/
void IntRegisterTest()
{
  /* Summary : IntegrationTest
     =========================

    o  All integration registers are written with different patterns and read
        back to verify the readable/writeable bits in a register.
    o  The tests are further extended to check that the registers are
        correctly addressed.
  */

  int i;
  int32 ExpData;
  int32 DataArray[]  = {0x00000000, 0xFFFFFFFF, 0x55555555, 0xAAAAAAAA,
                        0x33333333, 0xCCCCCCCC, 0x0F0F0F0F, 0xF0F0F0F0,
                        0x00FF00FF, 0xFF00FF00, 0x0000FFFF, 0xFFFF0000,
                        0x00000001};
  /* Enable Integration testing of the MPMC by setting the ITEN
     bit in the MPMCITCR register 
  */
  C("Register tests for the MPMC");
  HSA(MPMCITCR, NSEQ, INCR, OK, WRD, , , , ,);
  HSW(,0x00000001);
  i = 0;
  do
  {
    HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,);
    HSW(,DataArray[i]);

    ExpData = MASK_MPMCITIP & DataArray[i];

    HSA(MPMCITIP, NSEQ, INCR, OK, WRD, , , , ,);
    HSR(,ExpData, ,NoMask);

    HSA(MPMCITOP, NSEQ, INCR, OK, WRD, , , , ,);
    HSW(,DataArray[i]);

    ExpData = MASK_MPMCITOP & DataArray[i];

    HSA(MPMCITOP, NSEQ, INCR, OK, WRD, , , , ,);
    HSR(,ExpData, ,NoMask);
    i = i + 1;
  }
  while (DataArray[i] != 0x00000001);
  /* Exit from test mode */
  HSA(MPMCITCR, NSEQ, INCR, OK, WRD, , , , ,);
  HSW(,0x00000000);

}
/*-- --================================ End ================================--*/
