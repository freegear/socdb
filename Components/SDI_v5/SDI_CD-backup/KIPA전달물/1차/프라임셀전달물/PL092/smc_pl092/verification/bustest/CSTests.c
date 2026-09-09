/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : CSTests.c.rca
--  File Revision          : 1.10
--
--  Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Chip Select to Output Enable assertion and
--           Chip Select to Write Enable assertion Tests on the SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/**************************** Chip Select Tests *******************************/
/******************************************************************************/

void CSTests()
{
  /*
     Summary: Chip Select Tests
     ==========================
     This function performs the following:

     o  Checks whether only one CS is asserted corresponding to an address
     o  Checks the polarity of the CS signal according to the CSPol bit
     o  This is tested by applying all 8 values on HADDR[28:26], keeping
        the remaining 26 address bits unchanged. Eight memory locations are
        written into, each with different data. This data is read back and
        compared. If it matches, then unique CS assertion for each address is
        proved.
     o  Repeats the test with different value of POLARITY
     o  Each CS Polarity bit is made to change at least once
  */

  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** CSPol = 0, ExtWait disabled **/
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0x05, 0x04, 0x02, 0x04, 0x00000081, 0x000004,
               0x000000);
  ConfigureMemory(0, 0x02, 0x05, 0x04, 0x042, SMCTrMEMBData[0], 0x02,
                  0x04, 0x000000);

  /** Set Bank 1 Memory Type as SRAM (32 bits width) **/
  /** CSPol = 1, ExtWait disabled **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000088, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x02, 0x05, 0x04, 0x082, SMCTrMEMBData[1], 0x02,
                  0x00, 0x000000);

  /** Set Bank 2 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[2] = 0x00000000;
  /** CSPol = 0, ExtWait enabled **/
  ConfigureUUT(2, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000084, 0x000004,
               0x000001);
  ConfigureMemory(2, 0x02, 0x05, 0x04, 0x102, SMCTrMEMBData[2], 0x02,
                  0x00, 0x000000);

  /** Set Bank 3 Memory Type as SRAM (32 bits width) **/
  /** CSPol = 1, ExtWait enabled **/
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x02, 0x05, 0x04, 0x02, 0x00, 0x0000008C, 0x000003,
               0x000002);
  ConfigureMemory(3, 0x02, 0x05, 0x04, 0x182, SMCTrMEMBData[3], 0x02,
                  0x00, 0x000000);

  /** Set Bank 4 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[4] = 0x00000000;
  /** CSPol = 0, ExtWait enabled **/
  ConfigureUUT(4, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000084, 0x000002,
               0x000002);
  ConfigureMemory(4, 0x02, 0x05, 0x04, 0x502, SMCTrMEMBData[4], 0x02,
                  0x00, 0x000000);

  /** Set Bank 5 Memory Type as SRAM (32 bits width) **/
  /** CSPol = 1, ExtWait enabled **/
  SMCTrMEMBData[5] = 0x00000000;
  ConfigureUUT(5, 0x03, 0x07, 0x00, 0x03, 0x00, 0x0000008C, 0x000002,
               0x000003);
  ConfigureMemory(5, 0x03, 0x07, 0x00, 0x582, SMCTrMEMBData[5], 0x03,
                  0x00, 0x000000);

  /** Set Bank 6 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[6] = 0x00000000;
  /** CSPol = 0, ExtWait disabled **/
  ConfigureUUT(6, 0x04, 0x06, 0x02, 0x04, 0x00, 0x00000080, 0x000000,
               0x000000);
  ConfigureMemory(6, 0x04, 0x06, 0x02, 0x002, SMCTrMEMBData[6], 0x04,
                  0x00, 0x000000);

  /** Set Bank 7 Memory Type as SRAM (32 bits width) **/
  /** CSPol = 1, ExtWait disabled **/
  SMCTrMEMBData[7] = 0x00000000;
  ConfigureUUT(7, 0x02, 0x05, 0x01, 0x05, 0x00, 0x00000088, 0x000000,
               0x000000);
  ConfigureMemory(7, 0x02, 0x05, 0x01, 0x082, SMCTrMEMBData[7], 0x05,
                  0x00, 0x000000);

  ToggleSMCS();

  /** Changing the CS Polarity **/
  C("Toggling the CSPol configuration bit");
  HSA(SMBCR0, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x00000088);
  HSA(SMCTrMEMT_0, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x082);

  HSA(SMBCR1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x00000080);
  HSA(SMCTrMEMT_1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x002);

  HSA(SMBCR2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x0000008C);
  HSA(SMCTrMEMT_2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x182);

  HSA(SMBCR3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x00000084);
  HSA(SMCTrMEMT_3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x102);

  HSA(SMBCR4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x0000008C);
  HSA(SMCTrMEMT_4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x582);

  HSA(SMBCR5, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x00000084);
  HSA(SMCTrMEMT_5, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x502);

  HSA(SMBCR6, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x00000088);
  HSA(SMCTrMEMT_6, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x082);

  HSA(SMBCR7, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x00000080);
  HSA(SMCTrMEMT_7, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x002);

  ToggleSMCS();
}

/************************************ End *************************************/
