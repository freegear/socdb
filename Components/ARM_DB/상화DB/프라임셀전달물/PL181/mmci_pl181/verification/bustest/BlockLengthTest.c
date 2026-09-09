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
-- File Name              : BlockLengthTest.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Test to exercise the MMCI using a range of BlockLength
--           values
--
-- --=========================================================================*/

/******************************************************************************/
/***************************** BlockLengthTest ********************************/
/******************************************************************************/

/*
  Summary : BlockLengthTest
  =========================
      This test calls the DataFSMTest() function with block lengths
   programmed to 16,64,128,256,512,1024 and 2048.The test confirms
   the MMCI DPSM operation in cases where block length is large.
*/

void BlockLengthTest(void)
{
int32 clkdiv, pwrsave, bypass = 0x00000000;
int32 transmitmode = 0x0, streammode =  0x0;
int32 datlen = 0x0000, bloklen = 0x000, datatimer = 0x00000000;
int32 tokdel = 0x0000,busydel = 0x0000;
int32 crclineerr = 0x0, crctokerr = 0x0;
int timeout = 0x0;
int i,blokcnt;

         bypass = 0x1;
         datatimer = 0x1F;

         if (MCLK_PERIOD == 40 && PCLK_PERIOD == 100)
         {
           bypass = 0x00;
           clkdiv = 0x02;
         }
         transmitmode = 0x01;
         streammode = 0x0;
         bloklen = 0x0;
         tokdel = 0x5;
         busydel = 0x0;
         crctokerr = 0x0;

         C("DATA RECEPTION WITH BLOCK LENGTH 16");
         for (transmitmode = 0;transmitmode < 2;transmitmode ++)
         {
           DataFSMTest (4,16,streammode,
                        clkdiv,pwrsave,bypass,
                        crctokerr,
                        crclineerr,tokdel,busydel,
                        datatimer,transmitmode,timeout);
           if (transmitmode == 0x0)
           C("DATA TRANSMISSION WITH BLOCK LENGTH 16");
         }

         PSW(CLEARALL, MMCIClear);
         PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

         C("DATA RECEPTION WITH BLOCK LENGTH 64");
         for (transmitmode = 0;transmitmode < 2;transmitmode ++)
         {
         DataFSMTest (6,64,streammode,
                      clkdiv,pwrsave,bypass,
                      crctokerr,
                      crclineerr,tokdel,busydel,
                      datatimer,transmitmode,timeout);
           if (transmitmode == 0x0)
           C("DATA TRANSMISSION WITH BLOCK LENGTH 64");
         }

         PSW(CLEARALL, MMCIClear);
         PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

         C("DATA RECEPTION WITH BLOCK LENGTH 128");
         for (transmitmode = 0;transmitmode < 2;transmitmode ++)
         {
         DataFSMTest (7,128,streammode,
                      clkdiv,pwrsave,bypass,
                      crctokerr,
                      crclineerr,tokdel,busydel,
                      datatimer,transmitmode,timeout);
           if (transmitmode == 0x0)
           C("DATA TRANSMISSION WITH BLOCK LENGTH 128");
         }

         PSW(CLEARALL, MMCIClear);
         PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

         C("DATA RECEPTION WITH BLOCK LENGTH 256");
         for (transmitmode = 0;transmitmode < 2;transmitmode ++)
         {
         DataFSMTest (8,256,streammode,
                      clkdiv,pwrsave,bypass,
                      crctokerr,
                      crclineerr,tokdel,busydel,
                      datatimer,transmitmode,timeout);
           if (transmitmode == 0x0)
           C("DATA TRANSMISSION WITH BLOCK LENGTH 256");
         }

         PSW(CLEARALL, MMCIClear);
         PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

         C("DATA RECEPTION WITH BLOCK LENGTH 512");
         for (transmitmode = 0;transmitmode < 2;transmitmode ++)
         {
         DataFSMTest (9,512,streammode,
                      clkdiv,pwrsave,bypass,
                      crctokerr,
                      crclineerr,tokdel,busydel,
                      datatimer,transmitmode,timeout);
           if (transmitmode == 0x0)
           C("DATA TRANSMISSION WITH BLOCK LENGTH 512");
         }

         PSW(CLEARALL, MMCIClear);
         PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

         C("DATA RECEPTION WITH BLOCK LENGTH 1024");
         for (transmitmode = 0;transmitmode < 2;transmitmode ++)
         {
         DataFSMTest (10,1024,streammode,
                      clkdiv,pwrsave,bypass,
                      crctokerr,
                      crclineerr,tokdel,busydel,
                      datatimer,transmitmode,timeout);
           if (transmitmode == 0x0)
           C("DATA TRANSMISSION WITH BLOCK LENGTH 1024");
         }

         PSW(CLEARALL, MMCIClear);
         PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

         C("DATA RECEPTION WITH BLOCK LENGTH 2048");
         for (transmitmode = 0;transmitmode < 2;transmitmode ++)
         {
         DataFSMTest (11,2048,streammode,
                      clkdiv,pwrsave,bypass,
                      crctokerr,
                      crclineerr,tokdel,busydel,
                      datatimer,transmitmode,timeout);
           if (transmitmode == 0x0)
           C("DATA TRANSMISSION WITH BLOCK LENGTH 2048");
         }

         PSW(CLEARALL, MMCIClear);
         PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);
}

/*******************************  End  ****************************************/
