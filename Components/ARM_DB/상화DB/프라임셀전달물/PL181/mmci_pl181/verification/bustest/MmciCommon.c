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
-- File Name              : MmciCommon.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This file contains utility functions that are called by
--           multiple tests.
--
-- --=========================================================================*/

/******************************************************************************/
/***************************** Global Variables *******************************/
/******************************************************************************/
char printstr[1000];
int  CLKDIV;
int  DELAY;
int32 dataarray [0x10];
int32 DATA, local;

/******************************************************************************/
/*************************   PCLK to MCLK  ************************************/
/******************************************************************************/

void PCLKOn()
{
  /*
    Summary: PCLK to MCLK
    =====================
    This test routes the PCLK onto the MCLK line.
  */

  C( "Routing PCLK to MCLK line" );

 /* Clear MCLKSEL and Set PCLKSel - Internal MCLK routed to MCLK */
  PSW(PCLKSEL | GENCLK,MMCITBCLKRSTCntl);

 /* Poll for MCLKOn zero */
  PO(0x00000000,0x00000080,MMCITBStatus);

 /* Route PCLK to MCLK */
  PSW(PCLKSEL,MMCITBCLKRSTCntl);
}

/******************************************************************************/
/**********************  Internal MCLK to MCLK input of MMCI ******************/
/******************************************************************************/

void MCLKOn()
{
  /*
    Summary: Internal MCLK to MCLK port of trickbox
    ===============================================
    This function routes the internally generated MCLK onto the MCLK
    output line of the trickbox.
  */

 C( "Routing Trickbox-generated MCLK to MCLK input of MMCI" );

 /* Clear PCLKSEL, Set MCLKSel - PCLK routed to MCLK */
  PSW(MCLKSEL,MMCITBCLKRSTCntl);

 /* Poll for PCLKOn zero */
  PO(0x00000000,0x00000040,MMCITBStatus);

 /* Internal MCLK routed to MCLK */
  PSW(MCLKSEL | GENCLK,MMCITBCLKRSTCntl);
}

/******************************************************************************/
/*********************************  Idle  *************************************/
/******************************************************************************/
void Idle(unsigned long time)
{
  /*
    Summary: Idle
    =============
    This function inserts idle cycles using the PI command. The
    argument to PI cannot be more than 255. Hence, larger delays
    need to be split into multiple PI commands.

  */

  unsigned long i;
  int Count, Remainder, OddNum;

  OddNum    = time % 2;
  if (OddNum == 1)
    {
      Count     = (time - 3) / 255;
      Remainder = (time - 3) % 255;
    }
  else
    {
      Count     = (time - 2) / 255;
      Remainder = (time - 2) % 255;
    }

  if (time <= 5)
  {
    PI(0x02);
  }
  else
  {
    while (Count > 0)
      {
       if (Remainder == 1)
         {
          PI(0xFE);
          PI(0x2);
          Remainder = 0;
         }
       else
         {
          PI(0xFF);
         }
       Count = Count - 1;
      }
    if (Remainder != 0)
      {
       PI(Remainder);
      }
  }
}

/******************************************************************************/
/****************************  DATAFSM  Test **********************************/
/******************************************************************************/

void DataFSMTest (int32 bloklen, int32 datlen, int32 streammode,
                  int32 clkdiv, int32 pwrsave, int32 bypass,
                  int crctokerr,
                  int crclineerr, int32 tokdel, int32 busydel,
                  int32 datatimer, int transmitmode, int timeout )
{
  /*
     Summary : Data FSM Test
     =======================

     In these tests the data is filled into the transmit FIFO of the
     trickbox and the FIFO in MMCI. The data patterns are loaded in such
     a way that every bit is toggled atleast once. Data transfers are
     allowed to occur with the following combinations.
     - Single data line, min block length, DataLength = 16
     - Single data line, block length = 32, DataLength = 128
     - Single data line, block length = 64, DataLength = 256. This test
       is done in bypass mode.
     - Wide bus mode, block length = 128, DataLength = 512
     - Wide bus mode, block length = 256, DataLength = 1024. This test
       is done in Bypass mode.
     - Stream mode, DataLength = 1
     - Stream mode, DataLength = 128
     The above combinations are repeated for receive mode and
     transmit mode of the MMCI.
     For the above combinations, a few other variations are added
     as below :
     - The data which is filled in the FIFOs (MMCI and Trickbox) are
       toggled so that all variations of data goes into CRC generation
       block of the MMCI.
     - The trickbox is programmed to give a wrong CRC token, delay the
       sending of CRC token, indicate BUSY and to vary the
       duration of the BUSY.
     - The Trickbox is programmed to give the Start bit error.
     - The DPSM tests are run in power down mode, bypass mode and with
       clkdiv value programmed to different values.
  */
  int32 data1, data2, data3, data1and, data2and, i, j;
  int32 clkdivand, pwrsaveand, bypassand, mmciclkreg;
  int32 streammodeand, bloklenand, datactrlreg, mmcitbcontrolreg;
  int32 crclineerrand, crctokerrand;
  int32 bloklensize, bloklentemp, datlentemp, timeoutcond;
  int len, blockno, display, byte, hw, temp;
  int32 dataarray [0x10];
  int32 DATA, local;

  srand(SEED);
  for (i=0x0; i<0x10; i++)
    {
     /* Generation of random data */
      data1 = rand();
      data2 = rand();
      data2and = (data2 & 0x00007FFF) << 15;
      data1and = data1 & 0x00007FFF;
      data3 = (rand()) << 30;
      if (i < datlen)
        dataarray[i] = (data3 | data2and | data1and);
      else
        dataarray[i] = 0x00000000;

      /* Sizing data for cases where block length is less than 4 */

      if (streammode == 0x0 && transmitmode == 0x0)
      {
        if (bloklen == 0)
          dataarray[i] = dataarray[i] & 0x000000FF;
        if (bloklen == 1)
          dataarray[i] = dataarray[i] & 0x0000FFFF;
      }

      if (streammode == 0x1)
      {
        if (datlen == 1)
          dataarray[i] = dataarray[i] & 0x000000FF;
        if (datlen == 2)
          dataarray[i] = dataarray[i] & 0x0000FFFF;
        if (datlen == 3)
          dataarray[i] = dataarray[i] & 0x00FFFFFF;
      }
    }
  bloklensize = 0x001 << bloklen;

  clkdivand = clkdiv & 0x000000FF;
  CLKDIV = clkdivand;
  pwrsaveand = (pwrsave & 0x00000001) << 9;
  bypassand  = (bypass & 0x00000001) << 10;
  mmciclkreg = clkdivand | pwrsaveand | bypassand;

  /*
     Disabling the Clock Phase Check protocol just before programming
     the Clock control unit and enabling the protocol after the clock
     is stabilized
  */

  PSW(0x00010000, MMCITBPCDisable);
  Idle(((DELAY) * (2 * (CLKDIV + 1))) * 0xA);
  PSW(mmciclkreg | CLKENB,MMCIClock);
  Idle(((DELAY) * (2 * (CLKDIV + 1))) * 0xA);
  PSW(0x00000000, MMCITBPCDisable);
  Idle(((DELAY) * (2 * (CLKDIV + 1))) * 0xA);

  /*
     Writing values into Timer registers depending on 'timeout'
     argument value
  */
  if (timeout == 0)
  {
    PSW(datatimer,MMCIDataTimer);
    PSW(datatimer - 2,MMCITBDataTimer);
  }
  else if (timeout == 1)
  {
    PSW(datatimer,MMCIDataTimer);
    PSW(datatimer + 0xA,MMCITBDataTimer);
  }
  else if (timeout == 2)
  {
    PSW(datatimer,MMCIDataTimer);
    PSW(datatimer + 0x3,MMCITBDataTimer);
  }

  PSW(datlen,MMCIDataLength);

  crclineerrand = (crclineerr & 0x00000001) << 1;
  crctokerrand  = (crctokerr & 0x00000001) << 5;
  mmcitbcontrolreg = crclineerrand | crctokerrand |
                    0x00000000;

  PSW(mmcitbcontrolreg,MMCITBControl);
  PSW(tokdel,MMCITBTokenTimer);
  PSW(busydel,MMCITBBusyTimer);

  if (pwrsave == 1)
  PSW(0x00010400, MMCITBPCDisable);

  streammodeand  = (streammode & 0x00000001) << 2;
  bloklenand  = (bloklen & 0x0000000F) << 4;
  datactrlreg = streammodeand | bloklenand ;

  /*
   The 'timeoutcond' variable reflects situations where the
   programmed values of the timer registers are bound to
   result in a timeout
  */

   if ((datatimer < (tokdel + busydel + 7) &&
        streammode == 0x0 && transmitmode == 0x1 && crctokerr == 0x0))
      timeoutcond = 1;
   else
      timeoutcond = 0;

   /*
     The 'len' variable is used to determine the number of fifo
     locations to be filled or read from
   */

   if (timeoutcond == 1 || crctokerr == 1)
      len = 4;
   else
   if (transmitmode == 0x1)
   {
     if (streammode == 0x0)
     {
       if (datlen < 4 && bloklen == 0)
          len = 4;
       else if (datlen < 4 && bloklen == 1)
          len = 4;
       else if (datlen == 4 && bloklen == 0)
          len = 4;
       else if (datlen == 4 && bloklen == 1)
            len = 4;
       else if ( bloklen == 0)
          len = datlen;
       else if ( bloklen == 1)
          len = datlen / 2;
       else
          len = datlen;
     }
     else
     {
       if (datlen < 4)
            len = 4;
       else
          len = datlen;
     }
   }
   else
   {
     if (streammode == 0x0)
     {
       if (datlen < 4 && bloklen == 0)
          len = 4 * datlen;
       else if (datlen < 4 && bloklen == 1)
          len = 8;
       else if (datlen == 4 && bloklen == 0)
          len = 16;
       else if (datlen == 4 && bloklen == 1)
          len = 8;
       else if ( bloklen == 0)
          len = datlen * 4;
       else if ( bloklen == 1)
          len = datlen * 2;
       else
          len = datlen;
     }
     else
     {
       if (datlen < 4)
          len = 4;
       else
          len = datlen;
     }
   }

  /*
     Filling up the respective FIFO and enabling the DPSM, the cases
     where number of FIFO locations to filled are greater than 16 and
     where it is less than 16 are separately dealt
  */

 if (len/0x4 <= 0x16)
 {
   if (transmitmode == 1)
   {
     PO(0x00000000, TXACTIVE, MMCIStatus,0x0000FFFF);
     PSW(datactrlreg | DATATXRENB, MMCIDataCtrl);
     PO(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus,0x0000FFFF);

     for( i=0x00; i<len/0x4; i++)
     {
       PO(0x00001000, TXFIFOFULL | TXACTIVE, MMCIStatus,0x0000FFFF);
       PSW(dataarray[i % 0x10], MMCIFIFO);
     }
   }
   else
   {
     PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
     for( i=0; i<len/4; i++)
     {
       PSW(dataarray[i % 0x10], MMCITBFIFOReg);
       PO(0x00000000, TBTXFIFOFULL, MMCITBStatus,0x0000FFFF);
     }
     PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
     PSW(datactrlreg | DATATXRENB | DATARXDIR, MMCIDataCtrl);
   }
 }
 else
 {
   if (transmitmode == 1)
   {
     len = 0x001 << bloklen;
     PO(0x00000000, TXACTIVE, MMCIStatus,0x0000FFFF);
     PSW(datactrlreg | DATATXRENB, MMCIDataCtrl);
     PO(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus,0x0000FFFF);

     PSW(dataarray[0], MMCIFIFO);
     PSW(dataarray[1], MMCIFIFO);

     while (len/16 >= 1)
     {
       for( i=0x2; i<16; i++)
       {
         PO(0x00001000, TXACTIVE, MMCIStatus,0x0000FFFF);
         PSW(dataarray[i % 0x10], MMCIFIFO);
       }

       PO(0x00000000, TBRXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
       PSW(dataarray[0], MMCIFIFO);
       PSW(dataarray[1], MMCIFIFO);

       PO(0x00000020, TBRXHALFFULL, MMCITBStatus,0x0000FFFF);
       for (i=0x00; i<0x10; i++)
         PSR(dataarray [i], MASK_TBMMCIFIFO, MMCITBFIFOReg);

       len = len - 0x40;
     }
     PSR(DATA_0s, MASK_TBDATACRC, MMCITBCrcErrStat);
     PSW(DATABLOCKENDCLR, MMCIClear);

  }
  else
  {
    PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
    for( i=0; i< 32; i++)
    {
      PSW(dataarray[i % 0x10], MMCITBFIFOReg);
    }
    PO(0x00000000, RXACTIVE, MMCIStatus,0x0000FFFF);
    PSW(datactrlreg | DATATXRENB | DATARXDIR, MMCIDataCtrl);

    for (j=0;j<2;j++)
    {
      PO(0x00008000, RXFIFOHALFEMPTY, MMCIStatus,0x0000FFFF);
      for ( i=0x00; i<0x8; i++)
        PSR(dataarray [i], MASK_MMCIFIFO, MMCIFIFO);

      PSW(dataarray[j], MMCITBFIFOReg);

      PO(0x00008000, RXFIFOHALFEMPTY, MMCIStatus,0x0000FFFF);
      for ( i=0x08; i<0x10; i++)
        PSR(dataarray [i], MASK_MMCIFIFO, MMCIFIFO);
    }

    len = len - 0x80;

    while ((len/4)/32 >= 1)
    {
      for( i=2; i< 32; i++)
      {
        PSW(dataarray[i % 0x10], MMCITBFIFOReg);
      }

      for (j=0;j<2;j++)
      {
        PO(0x00008000, RXFIFOHALFEMPTY, MMCIStatus,0x0000FFFF);
        for ( i=0x00; i<0x8; i++)
          PSR(dataarray [i], MASK_MMCIFIFO, MMCIFIFO);

        PSW(dataarray[j], MMCITBFIFOReg);

        PO(0x00008000, RXFIFOHALFEMPTY, MMCIStatus,0x0000FFFF);
        for ( i=0x08; i<0x10; i++)
          PSR(dataarray [i], MASK_MMCIFIFO, MMCIFIFO);
      }
      len = len - 0x80;
    }

    PO(0x00000004, TBTXHALFEMPTY, MMCITBStatus,0x0000FFFF);
    for( i=2; i<(len % 32); i++)
    {
      PSW(dataarray[i % 0x10], MMCITBFIFOReg);
      PO(0x00000000, TBTXFIFOFULL, MMCITBStatus,0x0000FFFF);
    }

    if (len/0x4 < 0x10)
    {
      for ( i=0x00; i<len/0x4; i++)
      {
        PO(0x00200000, RXDATAAVLBL, MMCIStatus,0x0000FFFF);
        PSR(dataarray [i], MASK_MMCIFIFO, MMCIFIFO);
      }
    }
  }
 }

 /*
    Reading from the FIFO in cases where no errors have been induced.
    By reading the FIFO we also check the validity of the data received
    The DPSM stays in the WAIT-R state till all the data received has
    been read out from the FIFO.
    The read from FIFOs are governed by appropriate polls of the FIFO
    flags to determine the fill level.This prevents any premature
    reads from the FIFO.
 */

if ((transmitmode == 1) && (streammode == 1 || bloklen <= 6))
{
  if ((crclineerr == 0x00000000) && (crctokerr == 0) &&
      (timeoutcond == 0))
  {
    datlentemp = datlen;
    bloklentemp = 0x001 << bloklen;
    if (streammode == 1)
    {
      while (datlentemp/0x4 > 0x10)
      {
        PO(0x00000020, TBRXHALFFULL, MMCITBStatus,0x0000FFFF);
        for ( i=0x00; i<0x10; i++)
          PSR(dataarray [i], MASK_TBMMCIFIFO, MMCITBFIFOReg);
        datlentemp = datlentemp - 0x40;
      }
      if (datlentemp/0x4 < 0x10)
      {
        for ( i=0x00; i<datlentemp/0x4; i++)
        {
          PO(0x00000000, TBRXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
          PSR(dataarray [i], MASK_TBMMCIFIFO, MMCITBFIFOReg);
        }
      }
    }
    else
    {
      if (bloklentemp < 0x4)
        len = 4 * bloklentemp;
      else
        len = bloklentemp;

      while (datlentemp/0x4 >= 0x10)
      {
        while (bloklentemp/0x4 >= 0x10)
        {
          PO(0x00000020, TBRXHALFFULL, MMCITBStatus,0x0000FFFF);
          for (i=0x00; i<0x10; i++)
            PSR(dataarray [i], MASK_TBMMCIFIFO, MMCITBFIFOReg);
          bloklentemp = bloklentemp - 0x40;
        }
        if (bloklentemp/0x4 < 0x10)
        {
          for (i=0x00; i<bloklentemp/0x4; i++)
          {
            PO(0x00000000, TBRXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
            PSR(dataarray [i], MASK_TBMMCIFIFO, MMCITBFIFOReg);
            Idle(((MCLK_PERIOD/PCLK_PERIOD) *
                  (2 * (CLKDIV + 1))) * 0x3A);
          }
          PSR(DATA_0s, MASK_TBDATACRC, MMCITBCrcErrStat);
          PSW(DATABLOCKENDCLR, MMCIClear);
        }
        datlentemp = datlentemp - bloklensize;
        bloklentemp = 0x001 << bloklen;
      }

      if (datlentemp/0x4 < 0x10 && datlentemp != 0x0)
      {
        if (datlen < 4)
          datlentemp = 4 * datlen;
        else
          datlentemp = datlen;

        bloklentemp = 0x001 << bloklen;

        if (bloklentemp < 0x4)
          bloklentemp = 4 * bloklentemp;
        else
          bloklentemp = bloklentemp;

        bloklensize = 0x001 << bloklen;

        blockno = datlen/bloklentemp;

        for (i = 0;i< blockno;i++)
        {
          PO(0x00000400, DATABLOCKEND, MMCIStatus,0x0000FFFF);
          PSW(DATABLOCKENDCLR, MMCIClear);
        }
        PO(0x00000100, DATAEND, MMCIStatus,0x0000FFFF);

        for (i=0x00; i<blockno; i++)
        {
          PO(0x00000000, TBRXFIFOEMPTY, MMCITBStatus,0x0000FFFF);

          if(bloklensize == 0x1)
          {
            for(j=0;j < 4;j++)
            {
              byte = BYTE << j*8;
              DATA = (dataarray [i] & byte) >> j*8;
              PSR(DATA , MASK_TBMMCIFIFO, MMCITBFIFOReg);
            }
          }
          else if (bloklensize == 0x2)
          {
            for(j=0;j<2;j++)
            {
              hw = HW << j*16;
              DATA = (dataarray [i] & hw) >> j*16;
              PSR(DATA, MASK_TBMMCIFIFO, MMCITBFIFOReg);
            }
          }
          else
          {
            PSR(dataarray [i], MASK_TBMMCIFIFO, MMCITBFIFOReg);
          }
          Idle(((MCLK_PERIOD/PCLK_PERIOD) *
                (2 * (CLKDIV + 1))) * 0x3A);
        }
        PSR(DATA_0s, MASK_TBDATACRC, MMCITBCrcErrStat);
        PSW(DATAENDCLR, MMCIClear);
      }
    }
  }
}
else if ((streammode == 0x1 || bloklen <= 0x6) && transmitmode == 0x0)
{
  if ((crclineerr == 0x00000000) && (timeout == 0x0))
  {

    datlentemp = datlen;
    bloklentemp = 0x001 << bloklen;

    /*
     The 'len' variable is used to determine the number of fifo
     locations to be filled or read from
    */
    if (transmitmode == 0x0 || transmitmode == 0x1)
    {
      if (streammode == 0x0)
      {
        if (datlen < 4 && bloklen == 0)
          len = 4;
        else if (datlen < 4 && bloklen == 1)
          len = 4;
        else if (datlen == 4 && bloklen == 0)
          len = 4;
        else if (datlen == 4 && bloklen == 1)
          len = 4;
        else if ( bloklen == 0)
          len = datlen;
        else if ( bloklen == 1)
          len = datlen / 2;
        else
          len = datlen;
      }
      else
      {
        if (datlen < 4)
          len = 4;
        else
          len = datlen;
      }
    }
    else
    {
      if (streammode == 0x0)
      {
        if (datlen < 4 && bloklen == 0)
          len = 4 * datlen;
        else if (datlen < 4 && bloklen == 1)
          len = 8;
        else if (datlen == 4 && bloklen == 0)
          len = 16;
        else if (datlen == 4 && bloklen == 1)
          len = 8;
        else if ( bloklen == 0)
          len = datlen * 4;
        else if ( bloklen == 1)
          len = datlen * 2;
        else
          len = datlen;
      }
      else
      {
        if (datlen < 4)
          len = 4;
        else
          len = datlen;
      }
    }
    if (bloklentemp == 0x1 && streammode == 0x0)
    {
      for (i=0,j=0;i<len;i=i+4,j++)
      {
        dataarray[j] = (dataarray[i] |
                       (dataarray[i+1] << 8 )  |
                       (dataarray[i+2] << 16 ) |
                       (dataarray[i+3] << 24 ));
      }
    }
    else if (bloklentemp == 0x02 && streammode == 0x0)
    {
      for (i=0,j=0;i<len;i=i+2,j++)
      {
        dataarray[j] = dataarray[i] |
                       (dataarray[i+1] & 0x0000FFFF) << 16;
      }
    }

    while (len/0x4 >= 0x10)
    {
       PO(0x00008000, RXFIFOHALFEMPTY, MMCIStatus,0x0000FFFF);
       for ( i=0x00; i<0x8; i++)
         PSR(dataarray [i], MASK_MMCIFIFO, MMCIFIFO);
       len = len - 0x20;
       PO(0x00008000, RXFIFOHALFEMPTY, MMCIStatus,0x0000FFFF);
       for ( i=0x08; i<0x10; i++)
         PSR(dataarray [i], MASK_MMCIFIFO, MMCIFIFO);
       len = len - 0x20;
    }
    if (len/0x4 < 0x10)
    {
       for ( i=0x00; i<len/0x4; i++)
       {
         PO(0x00200000, RXDATAAVLBL, MMCIStatus,0x0000FFFF);
         PSR(dataarray [i], MASK_MMCIFIFO, MMCIFIFO);
       }
    }
  }
}

/*
   Checking the respective Flags from the status register.The main
   flags that are involved are DataTimeout flag, DataCrcFail flag,
   DataEnd flag, DataBlockEnd flag, StartBitErr flag.
   Except for the DataTimeout case all other error conditions are
   induceable through register bits. In case of DataTimeout, the
   implicit conditions which can bring out this error are checked.
*/

if (timeout == 0x1 || ((datatimer < (tokdel + busydel + 5) &&
    streammode == 0x0 && transmitmode == 0x1 && crctokerr == 0x0) ||
    (datatimer < (tokdel + 5) &&
    streammode == 0x0 && transmitmode == 0x1 && crctokerr == 0x1))
    || transmitmode == 0x0 && MMCITBDataTimer >= MMCIDataTimer)
{
  PO(0x00000008, DATATIMEOUT, MMCIStatus,0x0000FFFF);
}
else
  if (transmitmode == 0x1)
  {
    if (crctokerr == 0x1)
      PO(0x00000002, DATACRCFAIL, MMCIStatus,0x0000FFFF);
    else
      PO(0x00000100, DATAEND, MMCIStatus,0x0000FFFF);
  }
  else
      if (crclineerr != 0x0)
      {
        PO(0x00000002, DATACRCFAIL, MMCIStatus,0x0000FFFF);
      }
      else
        PO(0x00000100, DATAEND, MMCIStatus,0x0000FFFF);

/* Clearing all relevant flags before next transfer */

     PSW(0x0000070A, MMCIClear);


/* Introducing idle cycles to ensure that trickbox completes
   transmission */

datlentemp = datlen * 8;
bloklentemp = ((0x001 << bloklen) + 0x2) * 8;
if (MCLK_PERIOD < PCLK_PERIOD)
  DELAY = 1;
else
  DELAY = MCLK_PERIOD/PCLK_PERIOD;

if (streammode == 0x1 && timeout == 0x1 && transmitmode == 0x0)
{
  Idle(((DELAY) * (2 * (CLKDIV + 1))) *
        (datlentemp + datatimer + 0xA));

}
else if (streammode == 0x0 && transmitmode == 0x1 && crctokerr == 1)
{
  Idle(((DELAY) * (4 * (CLKDIV + 1))) *
        (busydel + 0xA));

}
else if (streammode == 0x0 && transmitmode == 0x0)
  if(crclineerr != 0x0 || timeout == 0x1)
  {
    Idle(((DELAY) * (4 * (CLKDIV + 1))) *
          (bloklentemp + datatimer + 15) *
          ((datlentemp/bloklentemp) + 1));

  }
  else
  {
    Idle(((DELAY) * (2 * (CLKDIV + 1))) * 0x3A);
  }

/* Clearing the Trickbox FIFO contents */

Idle(((DELAY) * (2 * (CLKDIV + 1))) * 0x3A);
PSW(TBRESET, MMCITBControl);
Idle(((DELAY) * (2 * (CLKDIV + 1))) * 0x0A);
PSW(DATA_0s, MMCITBControl);
Idle(((DELAY) * (2 * (CLKDIV + 1))) * 0x3A);
}

/******************************************************************************/
/****************************  Random number generator ************************/
/******************************************************************************/
int32 Randomgen (void)
{
/*
  Summary : Randomgen
  ===================

  This function generates 32-bit random numbers for use in other
  functions. Since the rand() built-in utility generates only
  16-bit quantities, this utility has been called multiple
  times and the return values manipulated to generate a single
  32-bit return value for this function.
*/

int32 rand1, rand2, rand3, rand32, rand6, rand1and, rand2and;

   srand(SEED);

   rand1 = rand();
   rand2 = rand();
   rand2and = (rand2 & 0x00007FFF) << 15;
   rand1and = rand1 & 0x00007FFF;
   rand3 = (rand()) << 30;
   rand32 = (rand3 | rand2and | rand1and);

return rand32;
}

/******************************************************************************/
/****************************  CHECK Function  ********************************/
/******************************************************************************/

void Check ( int32 FlagExp, int32 FlagMask)
{
/*
  Summary : Check
  ===============
  This function checks the status of flags as passed throgh the FlagMask
  argument against the expected levels indicated through the FlagExp
  argument. This Check is performed on both the Mask Registers.
*/
  PSW(FlagMask, MMCIMask0);
  PO(FlagExp, FlagMask, MMCIStatus,0x0000FFFF);
  if (FlagExp != 0x00000000)
    PSR(0x00000010, TBMASKINTR, MMCITBSIGSTAT);
  PSW(DATA_0s, MMCIMask0);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(FlagMask, MMCIMask1);
  if (FlagExp != 0x00000000)
    PSR(0x00000020, TBMASKINTR, MMCITBSIGSTAT);
  PSW(DATA_0s, MMCIMask0);
  PSW(DATA_0s, MMCIMask1);
}

/******************************************************************************/
/**********************   INTERRUPT ROUTING FUNCTION   ************************/
/******************************************************************************/

void RoutableInterrupt (int32 expected, int32 mask, int32 PollWait)
{
/*
  Summary : RoutableInterrupt
  ===========================
  This function in addtion to checking the status of flags passed
  through the arguments, checks their routing to the interrupt line
  by reading out the MMCITBSIGSTAT register. The MMCI interrupts
  are made visible to APB side through this register. This function
  also ensures that the flags attain their expected levels before the
  number of clocks indicated by the PollWait argument
*/

  PO(expected, mask, MMCIStatus, PollWait);
  PSR(0x00000010, TBMASKINTR, MMCITBSIGSTAT);
  PSW(DATA_0s, MMCIMask0);
  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(mask, MMCIMask1);
  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);
  PSR(0x00000020, TBMASKINTR, MMCITBSIGSTAT);
  PSW(mask, MMCIClear);
  Idle((((MCLK_PERIOD / PCLK_PERIOD) + 1) +
        ((PCLK_PERIOD / MCLK_PERIOD) + 1)) * 0x03);
  PSR(0x00000000, TBMASKINTR, MMCITBSIGSTAT);
  PSW(DATA_0s, MMCIMask0);
  PSW(DATA_0s, MMCIMask1);
}

/*******************************  End  ****************************************/
