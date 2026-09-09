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
-- File Name              : TxDataFSMTestCall.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose : This C code file is used to generate BusTalk vectors.
--             BusTalk vectors are applied to the AMBA APB bus.

-- --=========================================================================*/

void TxDataFSMTestCall(void)
{

/*
  Summary : TxDataFSMTestCall
  ===========================
     This test exercises the DPSM (Transmit mode) in the following
     different possibilities,
     o Bypass and non-bypass mode
     o Power save and non-power save mode
     o Different values of DataLength
     o Different values of DataTimer
     o Stream mode and Block mode
     o In block mode,
        o Standard bus and Wide bus mode
        o Different block length values
        o Reception of token with correct and wrong crc
*/

int32 clkdiv, pwrsave, bypass = 0x00000000;
int32 transmitmode = 0x0, streammode =  0x0;
int32 datlen = 0x0000, bloklen = 0x000, datatimer = 0x00000000;
int32 tokdel = 0x0000,busydel = 0x0000;
int32 crclineerr = 0x0, crctokerr = 0x0;
int timeout = 0x0;
int i,blokcnt;

          PSW(0x000010440, MMCITBPCDisable);
          Idle(((DELAY)* (2 * (CLKDIV + 1))) * 0x020);
          PSW(DATA_0s, MMCIDataCtrl);
          Idle(((DELAY)* (2 * (CLKDIV + 1))) * 0x020);

for (clkdiv = 0; clkdiv < 2;clkdiv++)
{
  CLKDIV = clkdiv;

  if(clkdiv == 0)
  {
    bypass = 0x01;
    C("MMCICLK IN BYPASS MODE");
  }
  else
    bypass = 0x00;
    for (pwrsave = 0; pwrsave < 2;pwrsave++)
    {
      if (pwrsave == 0x1)
        C("POWERSAVE MODE TURNED ON");

      for(datlen = 0x4,i=1; datlen < 0x10; datlen = datlen + 4 ,i++)
      {
        for(datatimer = 0x2;datatimer < 0x14;datatimer = datatimer + 5)
        {
           sprintf(printstr,"DATALENGTH = %x DATATIMER = %x",
                   datlen,datatimer);
           C(printstr);

           /* Transmit mode for stream data*/
           C("DATA TRANSMISSION IN STREAM MODE");
           transmitmode = 0x01;
           streammode = 0x1;
           bloklen = 0x0;
           tokdel = 0x0000;
           busydel = 0x0000;
           crctokerr = 0x0;

           DataFSMTest (bloklen,datlen,streammode,
                        clkdiv,pwrsave,bypass,
                        crctokerr,
                        crclineerr,tokdel,busydel,
                        datatimer,transmitmode,timeout);

           PSW(CLEARALL, MMCIClear);
           PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

           /* Transmit mode for Block data */
           transmitmode = 0x01;
           streammode = 0x0;

           if (datlen > 4)
             blokcnt = 2;
           else if (datlen > 16)
             blokcnt = 4;
           else if (datlen > 64)
             blokcnt = 7;
           else if (datlen == 0x4)
             blokcnt = 1;
           else
             blokcnt = 0;

           for(bloklen = 0;bloklen <= blokcnt;bloklen = bloklen + 2)
           {
             sprintf(printstr,"BLOCK LEN = %x",bloklen);
             C(printstr);

             /* CRC TOKEN ERROR */
             for(tokdel = 2,busydel = 2;tokdel < 10,busydel < 5;
                 tokdel = tokdel + 3,busydel = busydel + 2)
             {
                for(crctokerr = 0;crctokerr < 2;crctokerr++)
                {
                  if (crctokerr == 0x1)
                  C("DATA TRANSMISSION WITH CRC TOKEN ERROR BIT SET");

                  /* NonWideBus mode */
                  C("DATA TRANSMISSION IN BLOCK-NONWIDEBUS MODE");

                  DataFSMTest (bloklen,datlen,streammode,
                               clkdiv,pwrsave,bypass,
                               crctokerr,
                               crclineerr,tokdel,busydel,
                               datatimer,transmitmode,timeout);

                  PSW(CLEARALL, MMCIClear);
                  PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

               }
             }
           }
         }
       }

       for(datlen = 0x1,i=1; datlen < 0x5; datlen = datlen + 1 ,i++)
       {
          for(datatimer = 0xA;datatimer < 0xB;datatimer = datatimer + 5)
          {
             sprintf(printstr,"DATALENGTH = %x DATATIMER = %x",
                     datlen,datatimer);
             C(printstr);

             /* Transmit mode for stream data*/
             C("DATA TRANSMISSION IN STREAM MODE");
             transmitmode = 0x01;
             streammode = 0x1;
             bloklen = 0x0;
             tokdel = 0x0000;
             busydel = 0x0000;
             crctokerr = 0x0;

             DataFSMTest (bloklen,datlen,streammode,
                          clkdiv,pwrsave,bypass,
                          crctokerr,
                          crclineerr,tokdel,busydel,
                          datatimer,transmitmode,timeout);

             PSW(CLEARALL, MMCIClear);
             PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

             /* Transmit mode for Block data */
             transmitmode = 0x01;
             streammode = 0x0;

             if (datlen > 4)
               blokcnt = 2;
             else if (datlen > 16)
               blokcnt = 4;
             else if (datlen > 64)
               blokcnt = 7;
             else if (datlen == 0x4)
               blokcnt = 1;
             else
               blokcnt = 0;

             for(bloklen = 0;bloklen <= blokcnt;bloklen = bloklen + 2)
             {
               sprintf(printstr,"BLOCK LEN = %x",bloklen);
               C(printstr);

               /* CRC TOKEN ERROR */
               for(tokdel = 2,busydel = 2;tokdel < 10,busydel < 5;
                   tokdel = tokdel + 3,busydel = busydel + 2)
               {
                  for(crctokerr = 0;crctokerr < 2;crctokerr++)
                  {
                    if (crctokerr == 0x1)
                      C("DATA TRANSMISSION WITH CRCTOKENERROR BIT SET");

                    /* NonWideBus mode */
                    C("DATA TRANSMISSION IN BLOCK-NONWIDEBUS MODE");

                    DataFSMTest (bloklen,datlen,streammode,
                                 clkdiv,pwrsave,bypass,
                                 crctokerr,
                                 crclineerr,tokdel,busydel,
                                 datatimer,transmitmode,timeout);

                    PSW(CLEARALL, MMCIClear);
                    PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);

                  }
                }
             }
          }
       }
    }
  }
C("END OF DPSM TESTS");
}

/*******************************  End  ****************************************/
