/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : DataFlagSyncTest.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Tests to check simultaneous assertion of multiple
--           status flags associated with the DPSM
--
-- --=========================================================================*/

/******************************************************************************/
/****************************** DataFlagSyncTest ******************************/
/******************************************************************************/

void DataFlagSyncTest(void)
{
  /*
    Summary : DataFlagSyncTest
    ==========================

  */

  int32 clkdiv, pwrsave, bypass = 0x00000000;
  int32 transmitmode = 0x0, streammode =  0x0;
  int32 datlen = 0x0000, bloklen = 0x000, datatimer = 0x00000000;
  int32 tokdel = 0x0000,busydel = 0x0000, timeout = 0x0;
  int32 crclineerr = 0x0, crctokerr = 0x0;

  C("DPSM RX TEST WITH DATA COUNT NON-WORD ALIGNED AND BLOCK COUNT 1");
  datlen = 0x6;
  tokdel = 0x3;
  datatimer = 0x1F;
  transmitmode = 0x0;
  streammode = 0x0;
  bloklen = 0x1;
  clkdiv = 0x0;
  bypass = 0x1;

      DataFSMTest (bloklen,datlen,streammode,
                   clkdiv,pwrsave,bypass,
                   crctokerr,
                   crclineerr,tokdel,busydel,
                   datatimer,transmitmode,timeout);

      PSR(DATA_0s, DATA_0s, MMCIFIFO);
      PSR(DATA_0s, DATA_0s, MMCIFIFO);
      PSR(DATA_0s, DATA_0s, MMCIFIFO);

  C("DPSM RX TEST WITH DATA COUNT = 1");
  datlen = 0x1;
  tokdel = 0x3;
  datatimer = 0x1F;
  transmitmode = 0x0;
  streammode = 0x1;
  bloklen = 0x0;
  clkdiv = 0x0;
  bypass = 0x1;

      DataFSMTest (bloklen,datlen,streammode,
                   clkdiv,pwrsave,bypass,
                   crctokerr,
                   crclineerr,tokdel,busydel,
                   datatimer,transmitmode,timeout);

      PSR(DATA_0s, DATA_0s, MMCIFIFO);

  datlen = 0x4;
  tokdel = 0x5;
  datatimer = tokdel + 2;
  crctokerr = 0x1;
  transmitmode = 0x1;
  streammode = 0x0;
  bloklen = 0x2;
  clkdiv = 0x0;
  bypass = 0x1;

  C("DPSM TX TEST WITH DATA TIMEOUT SYNCD TO DATA CRCFAIL");

      DataFSMTest (bloklen,datlen,streammode,
                   clkdiv,pwrsave,bypass,crctokerr,
                   crclineerr,tokdel,busydel,
                   datatimer,transmitmode,timeout);

  tokdel = 0x5;
  datatimer = tokdel + 3;
  crctokerr = 0x0;
  transmitmode = 0x1;
  streammode = 0x0;
  bloklen = 0x2;

  datlen = 0x8;
 C("DPSM TX TEST WITH DATA TIMEOUT SYNCD WITH DATA BLOCKEND AND DATA END");

      DataFSMTest (bloklen,datlen,streammode,
                   clkdiv,pwrsave,bypass,
                   crctokerr,
                   crclineerr,tokdel,busydel,
                   datatimer,transmitmode,timeout);


  datlen = 0x4;
 C("DPSM TX TEST WITH DATA TIMEOUT SYNCD WITH DATA BLOCKEND AND DATA END");

      DataFSMTest (bloklen,datlen,streammode,
                   clkdiv,pwrsave,bypass,
                   crctokerr,
                   crclineerr,tokdel,busydel,
                   datatimer,transmitmode,timeout);


  datatimer = tokdel + 5;

 C("DPSM TX TEST WITH DATA TIMEOUT SYNCD WITH BUSY END BIT");

      DataFSMTest (bloklen,datlen,streammode,
                   clkdiv,pwrsave,bypass,
                   crctokerr,
                   crclineerr,tokdel,busydel,
                   datatimer,transmitmode,timeout);

  datatimer = tokdel + 4;

 C("DPSM TX TEST WITH DATA TIMEOUT SYNCD WITH BUSY START BIT");

      DataFSMTest (bloklen,datlen,streammode,
                   clkdiv,pwrsave,bypass,
                   crctokerr,
                   crclineerr,tokdel,busydel,
                   datatimer,transmitmode,timeout);

}

/*******************************  End  ****************************************/
