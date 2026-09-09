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
-- File Name              : DmacCornerTests2.c.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Corner test cases of the Dma controller.
-- --=========================================================================*/ 
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** P2MDma                                     DmacCommon.c                ***/
/*** PeriphReg                                  DmacCommon.c                ***/
/*** ProgramResponse                            DmacCommon.c                ***/
/*** Poll                                       DmacCommon.c                ***/
/*** WaitLoop                                   DmacCommon.c                ***/
/*** Write                                      DmacCommon.c                ***/
/******************************************************************************/

void DmacCornerTests2()
{
  int32 TxrSize, ControlData, ConfigData;
  int32 Addr, MaskValue, *RegAddr;
  int i, j, MasterConfig;
  int32 SrcAddrMask, DestAddrMask;

  C("Testing for Waited response with Grant toggling for Master0");
/* This test is added for coverage where the Grant is toggled and the waited
   response is going on.
     The general steps, which needed to be followed to carry out the following
     test cases is given below.
       a) Poll for Channel0 Enabled bit to go low.
       b) Program the Memory module to give consecutive 3 waited Responses.
       c) Program the Grant Block to toggle the grant for every 2 HCLK.
       d) This test is repeated for Master1 also.

    Program the following for Waited transfers
    Channel No : 0
    Flow Controller        : DMAC
    Transfer Type          : M2M
    Source Width           : 32 bits
    Destination Width      : 32 bits
    Source Burst Size      : 4
    Destination Burst Size : 4
    Transfer Size          : 32
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode
*/
  C("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000048);

  C("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000048);

  C("Channel0 Control register");
  TxrSize = 0x00000008;
  ControlData = SBURST4 | DBURST4 | SWIDTH32 | DWIDTH32 | SMASTER0 | DMASTER0 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);

  C(" Dma Req Config register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  C("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x800000C8);

  C("Writing  to Control reg 1 of Memory Module 1 ");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  C("Enabling Memory Module 2 ");
  Write(DMACTrMemEn1, 0x800000C8);

  C("Writing  to Control reg 1 of Memory Module 2 ");
  Write(DMACTrMemData1, 0xC2000003);

  C("Writing  to Grant Control Register ");
  Write(DMACGRANTCNT0, 0x00000013);

  C(" Channel 0 Config register ");
  ConfigData = M2MDMAC | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);

  C("Testing for Waited response with Grant toggling for Master1");
/* This test is added for coverage where the Grant is toggled and the waited
   response is going on.
     The general steps, which needed to be followed to carry out the following
     test cases is given below.
       a) Poll for Channel0 Enabled bit to go low.
       b) Program the Memory module to give consecutive 3 waited Responses.
       c) Program the Grant Block to toggle the grant for every 2 HCLK.
       d) This test is repeated for Master1 also.

    Program the following for Waited transfers
    Channel No : 0
    Flow Controller        : DMAC
    Transfer Type          : M2M
    Source Width           : 32 bits
    Destination Width      : 32 bits
    Source Burst Size      : 4
    Destination Burst Size : 4
    Transfer Size          : 32
    Source Master          : Master1
    Destination Master     : Master1
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode
*/
  C("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000048);

  C("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000048);

  C("Channel0 Control register");
  TxrSize = 0x00000008;
  ControlData = SBURST4 | DBURST4 | SWIDTH32 | DWIDTH32 | SMASTER1 | DMASTER1 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);

  C(" Dma Req Config register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  C("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x800000C8);

  C("Writing  to Control reg 1 of Memory Module 1 ");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  C("Enabling Memory Module 2 ");
  Write(DMACTrMemEn1, 0x800000C8);

  C("Writing  to Control reg 1 of Memory Module 2 ");
  Write(DMACTrMemData1, 0xC2000003);

  C("Writing  to Grant Control Register ");
  Write(DMACGRANTCNT0, 0x00000013);

  C(" Channel 0 Config register ");
  ConfigData = M2MDMAC | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);

/* The following P2M (Dmac flow controller) case is added to get coverage on
   the address lines. */

  Write(DMACGRANTCNT0, 0x00000000);
  Write(DMACGRANTCNT1, 0x00000000);
  
  C("Tests to cover address increment logic");

  Write(DMACREQCONFIG, 0xFFFFFFFF);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  /* Big Endian mode */
  Endianness = 1;

  Write(DMACConfig, (DMACENABLE |
                    (Endianness << 1) | (Endianness << 2)));

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

  P2MDma(CHANNEL,
         15,
         0x9FFFFFFA,
         0x10000000,
         0x00000000,
         1,
         1,
         8,
         8,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

/* these test cases were added to cover the "AHB address incrementing Burst traansfer " in DmacLiteMaster. */
/* --------------------------------------------------------------------------*/
/* (1) -> for Byte access <-   */
 P2MDma(CHANNEL,
         15,
         0x9FFFFF0F,
         0x100000FF,
         0x00000000,
         1,
         1,
         8,
         8,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

/*  (2) */
 P2MDma(CHANNEL,
         15,
         0x9FFF0FFF,
         0x1000FFFF,
         0x00000000,
         1,
         1,
         8,
         8,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

/*  (3) */
 P2MDma(CHANNEL,
         15,
         0x9F0FFFFF,
         0x10FFFFFF,
         0x00000000,
         1,
         1,
         8,
         8,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));
/* (4)  */
 P2MDma(CHANNEL,
         15,
         0x9FFFFFFF,
         0x10000000,
         0x00000000,
         1,
         1,
         8,
         8,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));
/*  (5) -> for half word access <-  */
 P2MDma(CHANNEL,
         15,
         0x9FFFF01E,
         0x100001FE,
         0x00000000,
         1,
         1,
         8,
         8,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));
/* (6) */
 P2MDma(CHANNEL,
         15,
         0x9FF01FFE,
         0x1001FFFE,
         0x00000000,
         1,
         1,
         8,
         8,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));
/* (7)  */
 P2MDma(CHANNEL,
         15,
         0x9F1FFFFE,
         0x11FFFFFE,
         0x00000000,
         1,
         1,
         8,
         8,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

/* (8)  */
 P2MDma(CHANNEL,
         15,
         0x1FFFFFFE,
         0x10000000,
         0x00000000,
         1,
         1,
         8,
         8,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK, 
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

/* (9) ->for word access <- */
 P2MDma(CHANNEL,
         15,
         0x1FFFF03C,
         0x100003FC,
         0x00000000,
         1,
         1,
         8,
         8,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

/* (10)  */
 P2MDma(CHANNEL,
         15,
         0x1FF03FFC,
         0x1003FFFC,
         0x00000000,
         1,
         1,
         8,
         8,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

/* (11)  */
 P2MDma(CHANNEL,
         15,
         0x103FFFFC,
         0x13FFFFFC,
         0x00000000,
         1,
         1,
         8,
         8,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

/* (12)  */
 P2MDma(CHANNEL,
         15,
         0x3FFFFFFC,
         0x10000000,
         0x00000000,
         1,
         1,
         8,
         8,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));


/*---------------------end of added test cases for coverage og AHB address incrementing bust transfer -------------------- */
  P2MDma(CHANNEL,
         15,
         0x9FFFFFF8,
         0x10000000,
         0x00000000,
         1,
         1,
         16,
         16,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

  P2MDma(CHANNEL,
         15,
         0x9FFFFFFC,
         0x10000000,
         0x00000000,
         1,
         1,
         32,
         32,
         "I",
         "I",
         16,
         32,
         4,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  Write(DMACREQCONFIG, 0xFFFFFFFF);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

  P2MDma(CHANNEL,
         15,
         0x9FFFFFFA,
         0x10000000,
         0x00000000,
         1,
         1,
         8,
         8,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  Write(DMACREQCONFIG, 0xFFFFFFFF);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

  P2MDma(CHANNEL,
         15,
         0x9FFFFFF8,
         0x10000000,
         0x00000000,
         1,
         1,
         16,
         16,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

  P2MDma(CHANNEL,
         15,
         0x9FFFFFFC,
         0x10000000,
         0x00000000,
         1,
         1,
         32,
         32,
         "I",
         "I",
         16,
         32,
         4,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);


  Write(DMACREQCONFIG, 0x00000000);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  /* Big Endian mode */
  Endianness = 1;

  Write(DMACConfig, (DMACENABLE |
                    (Endianness << 1) | (Endianness << 2)));

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

  P2MDma(CHANNEL,
         15,
         0x9FFFFFFA,
         0x10000000,
         0x00000000,
         0,
         0,
         8,
         8,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

  P2MDma(CHANNEL,
         15,
         0x9FFFFFF8,
         0x10000000,
         0x00000000,
         0,
         0,
         16,
         16,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

  P2MDma(CHANNEL,
         15,
         0x9FFFFFFC,
         0x10000000,
         0x00000000,
         0,
         0,
         32,
         32,
         "I",
         "I",
         16,
         32,
         4,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  Write(DMACREQCONFIG, 0xFFFFFFFF);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

  P2MDma(CHANNEL,
         15,
         0x9FFFFFFA,
         0x10000000,
         0x00000000,
         0,
         0,
         8,
         8,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  Write(DMACREQCONFIG, 0xFFFFFFFF);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

  P2MDma(CHANNEL,
         15,
         0x9FFFFFF8,
         0x10000000,
         0x00000000,
         0,
         0,
         16,
         16,
         "I",
         "I",
         16,
         32,
         8,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  /* Program the Peripheral to return Wait inserted Okay responses. */
  Write(PeriphReg(15,PERIPHENREG), 0x8000043C);
  Write(PeriphReg(15,PERIPHDATAREG), 0x12000000);

  Write(DMACTrMemEn1, 0x8000043C);
  Write(DMACTrMemData1, 0x12000000);

  Write(PeriphReg(15, PERIPHREQREG), (2 << 8));

  P2MDma(CHANNEL,
         15,
         0x9FFFFFFC,
         0x10000000,
         0x00000000,
         0,
         0,
         32,
         32,
         "I",
         "I",
         16,
         32,
         4,
         0,
         PBC,
         1,
         TCENABLE,
         TCMASK,
         ERRMASK);

  /* WaitLoop(Idle2Poll); */
  Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

  Write(DMACTrMemEn1, MEMORYRESET);
  Write(PeriphReg(15, PERIPHENREG), PERIPHRESET);

  C("Coverage tests for the DmacLiteMaster module");

  /* This test is added for coverage for address boundary condition checking 
      Boundary Condition test for DmacLiteMaster :
      The source/destination peripheral is requesting more than 1 transfer with
      starting address on 1KB boundary with incrementing mode of addressing

   The general steps, which needed to be followed to carry out the following
     test cases is given below.
     a) Program Channel for Source and Destination at 1kB boundary and TxSize
        greater than 1
     b) Program the peripheral module.
     c) Poll for Channel Enabled bit to go low

    Program the Channel for following parameters 
    Channel No             : 0
    Flow Controller        : DMAC
    Transfer Type          : P2P
    Source Width           : 8 bits
    Destination Width      : 8 bits
    Source Burst Size      : 8
    Destination Burst Size : 8
    Transfer Size          : 8
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode
  */

  C("Programming Channel 0 Source Address Register");
  Write(DMACC0SrcAddr, 0x3583A3FF);
  C("Programming Channel 0 Destination Address Register");
  Write(DMACC0DestAddr, 0x4BA903FF);
  C("Programming Channel 0 LLI Address Register");
  Write(DMACC0LLIReg, 0x00000000);
  C("Programming Channel 0 Control Register");
  Write(DMACC0Control, 0x0C009008);

  /* Programming Channel 0 Peripherals with Default Ok Response */
  Addr = SlaveAddrSelection(3);
  Write (Addr, 0x80000000);
  Write (Addr + 0x00000004, 0xC2000003);
  Addr = SlaveAddrSelection(6);
  Write (Addr, 0x80000000);
  Write (Addr + 0x00000004, 0xC2000003);

  C("Enabling Channel 0");
  Write(DMACC0Config, 0x00001987);

  /* Programming DMA Requests of Channel 0  */
  C("Programming DMA Burst Request of Source Peripheral 3");
  Addr  = SlaveAddrSelection(3);
  Write(Addr + 0x00000008, 0x00000500);

  C("Programming DMA Burst Request of Destination Peripheral 6");
  Addr  = SlaveAddrSelection(6);
  Write(Addr + 0x00000008, 0x00000500);

  /* Poll Channel Enable bit of Channel 0 */
  MaskValue = 0x00000001;
  Poll(ConfigRegs[0], 0x00000000, MaskValue);

  /* Reset Channel 0 Peripherals */
  Addr = SlaveAddrSelection(3);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);
  Addr = SlaveAddrSelection(6);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);

  /* This test is added for coverage for address boundary condition checking 
      Boundary Condition test for DmacLiteMaster :
      The source/destination peripheral is requesting more than 1 transfer with
      starting address on 1KB boundary with incrementing mode of addressing

   The general steps, which needed to be followed to carry out the following
     test cases is given below.
     a) Program Channel for Source and Destination at 1kB boundary and TxSize
        greater than 1
     b) Program the peripheral module.
     c) Poll for Channel Enabled bit to go low

    Program the Channel for following parameters 
    Channel No             : 0
    Flow Controller        : DMAC
    Transfer Type          : P2P
    Source Width           : 8 bits
    Destination Width      : 8 bits
    Source Burst Size      : 8
    Destination Burst Size : 8
    Transfer Size          : 8
    Source Master          : Master1
    Destination Master     : Master1
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode
  */

  Write(DMACREQCONFIG,0xFFFFFFFF);

  C("Programming Channel 0 Source Address Register");
  Write(DMACC0SrcAddr, 0x3583A3FF);
  C("Programming Channel 0 Destination Address Register");
  Write(DMACC0DestAddr, 0x4BA903FF);
  C("Programming Channel 0 LLI Address Register");
  Write(DMACC0LLIReg, 0x00000000);
  C("Programming Channel 0 Control Register");
  Write(DMACC0Control, 0x0F009008);

  /* Programming Channel 0 Peripherals with Default Ok Response */
  Addr = SlaveAddrSelection(3);
  Write (Addr, 0x80000000);
  Write (Addr + 0x00000004, 0xC2000003);
  Addr = SlaveAddrSelection(6);
  Write (Addr, 0x80000000);
  Write (Addr + 0x00000004, 0xC2000003);

  C("Enabling Channel 0");
  Write(DMACC0Config, 0x00001987);

  /* Programming DMA Requests of Channel 0  */
  C("Programming DMA Burst Request of Source Peripheral 3");
  Addr  = SlaveAddrSelection(3);
  Write(Addr + 0x00000008, 0x00000500);

  C("Programming DMA Burst Request of Destination Peripheral 6");
  Addr  = SlaveAddrSelection(6);
  Write(Addr + 0x00000008, 0x00000500);

  /* Poll Channel Enable bit of Channel 0 */
  MaskValue = 0x00000001;
  Poll(ConfigRegs[0], 0x00000000, MaskValue);

  /* Reset Channel 0 Peripherals */
  Addr = SlaveAddrSelection(3);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);
  Addr = SlaveAddrSelection(6);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);

  /* Reset Channel 1 Peripherals */
  Addr = SlaveAddrSelection(9);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);
  Addr = SlaveAddrSelection(12);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);

  /* This test disbles the channel in the midle of the burst */

  /* Disable Trickbox protocol check before the disable test */
  Write(DMACTRICKEN, 0x00000000);

 /* This test is added for code coverage where Abort occurs in multichannel
    case. The aborted channel starts from boundary address with incrementing
    address mode and  it receives waited response before it gets abort
    Acknowledge from Master interface. It is expected after Abort, new channel
    to come on to the BUS for the data transfer

   The Abort is happening from the current channel, which is on AHB, 
   at the middle of the AHB access started by the DmacLiteMaster, at the same
   time next channel is coming up with the transfer request but the response
   for the last transfer for aborted channel is waited.

   The general steps, which needed to be followed to carry out the following
     test cases is given below.
     a) Program Channel 0 and Channel 1 for Source and Destination at 1kB
        boundary and TxSize greater than 1
     b) Program the peripheral modules of Channel 0 and 1.
     c) Abort Channel 6 data transfer
     d) Check Channel 0 starts data transfer
     e) Poll for Channel Enabled bit of Channel 1 and 0 to go low

   Program the Channel 0 and Channel 1 for following parameters
    Channel No             : 0
    Flow Controller        : DMAC
    Transfer Type          : P2P
    Source Width           : 8 bits
    Destination Width      : 8 bits
    Source Burst Size      : 16
    Destination Burst Size : 16
    Transfer Size          : 16
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode

    Channel No             : 1
    Flow Controller        : DMAC
    Transfer Type          : P2P
    Source Width           : 8 bits
    Destination Width      : 8 bits
    Source Burst Size      : 16
    Destination Burst Size : 16
    Transfer Size          : 16
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode
*/
  Write(DMACREQCONFIG,0x00000000);

  Write(DMACConfig,DMACENABLE);
 
  C("Programming Channel 0 Source Address Register");
  Write(DMACC0SrcAddr, 0x3583A3FF);
  C("Programming Channel 0 Destination Address Register");
  Write(DMACC0DestAddr, 0x4BA903FF);
  C("Programming Channel 0 LLI Address Register");
  Write(DMACC0LLIReg, 0x00000000);
  C("Programming Channel 0 Control Register");
  Write(DMACC0Control, 0x0C01B010);

  /* Channel 1 Programmed for P2P DMAC */
  C("Programming Channel 1 Source Address Register");
  Write(DMACC1SrcAddr, 0x618363FF);
  C("Programming Channel 1 Destination Address Register");
  Write(DMACC1DestAddr, 0x78C363FF);
  C("Programming Channel 1 LLI Address Register");
  Write(DMACC1LLIReg, 0x00000000);
  C("Programming Channel 1 Control Register");
  Write(DMACC1Control, 0x0C01B010);

  /* Programming Channel 0 and 1 Peripherals  with Default Waited Ok Response */
  Addr = SlaveAddrSelection(3);
  Write (Addr, 0x80000024);
  Write (Addr + 0x00000004, 0xC2000003);
  Addr = SlaveAddrSelection(6);
  Write (Addr, 0x80000024);
  Write (Addr + 0x00000004, 0xC2000003);
  Addr = SlaveAddrSelection(9);
  Write (Addr, 0x80000024);
  Write (Addr + 0x00000004, 0xA9000003);
  Addr = SlaveAddrSelection(12);
  Write (Addr, 0x80000024);
  Write (Addr + 0x00000004, 0xA9000003);

  C("Enabling Channel 0 and 1");
  Write(DMACC0Config, 0x00001987);
  Write(DMACC1Config, 0x00001B13);

  /* Programming DMA Requests of Channel 1  */
  Addr  = SlaveAddrSelection(9);
  C("Programming DMA Burst Request of Source Peripheral 9");
  Write(Addr + 0x00000008, 0x00000500);
  Addr  = SlaveAddrSelection(12);
  C("Programming DMA Burst Request of Destination Peripheral 12");
  Write(Addr + 0x00000008, 0x00000500);

  /* Programming DMA Requests of Channel 0  */
  C("Programming DMA Burst Request of Source Peripheral 3");
  Addr  = SlaveAddrSelection(3);
  Write(Addr + 0x00000008, 0x00000500);
  C("Programming DMA Burst Request of Destination Peripheral 6");
  Addr  = SlaveAddrSelection(6);
  Write(Addr + 0x00000008, 0x00000500);

  WaitLoop(10);

  /* Disable Channel 1 */
  RegAddr = ChannelRegisters(1);
  Write (*RegAddr + 0x00000010, 0x00001987 & DMACDISABLE);
  WaitLoop(10);

  /* Poll Channel Enable bit  of Channel 1 */
  MaskValue = 0x00000001;
  Poll(ConfigRegs[1], 0x00000000, MaskValue);

  /* Poll Channel Enable bit  of Channel 0 */
  MaskValue = 0x00000001;
  Poll(ConfigRegs[0], 0x00000000, MaskValue);

  /* Reset Channel 0 Peripherals */
  Addr = SlaveAddrSelection(3);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);
  Addr = SlaveAddrSelection(6);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);

  /* Reset Channel 6 Peripherals */
  Addr = SlaveAddrSelection(9);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);
  Addr = SlaveAddrSelection(12);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);
  
 /* This test is added for code coverage where Abort occurs in multichannel
    case. The aborted channel starts from boundary address with incrementing
    address mode and  it receives waited response before it gets abort
    Acknowledge from Master interface. It is expected after Abort, new channel
    to come on to the BUS for the data transfer

   The Abort is happening from the current channel, which is on AHB, 
   at the middle of the AHB access started by the DmacLiteMaster, at the same
   time next channel is coming up with the transfer request but the response
   for the last transfer for aborted channel is waited.

   The general steps, which needed to be followed to carry out the following
     test cases is given below.
     a) Program Channel 0 and Channel 1 for Source and Destination at 1kB
        boundary and TxSize greater than 1
     b) Program the peripheral modules of Channel 0 and 1.
     c) Abort Channel 1 data transfer
     d) Check Channel 0 starts data transfer
     e) Poll for Channel Enabled bit of Channel 1 and 0 to go low

   Program the Channel 0 and Channel 1 for following parameters
    Channel No             : 0
    Flow Controller        : DMAC
    Transfer Type          : P2P
    Source Width           : 8 bits
    Destination Width      : 8 bits
    Source Burst Size      : 16
    Destination Burst Size : 16
    Transfer Size          : 1
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode

    Channel No             : 1
    Flow Controller        : DMAC
    Transfer Type          : P2P
    Source Width           : 8 bits
    Destination Width      : 8 bits
    Source Burst Size      : 16
    Destination Burst Size : 16
    Transfer Size          : 16
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode
*/
 C("Programming Channel 0 Source Address Register");
  Write(DMACC0SrcAddr, 0x3583A3FF);
  C("Programming Channel 0 Destination Address Register");
  Write(DMACC0DestAddr, 0x4BA903FF);
  C("Programming Channel 0 LLI Address Register");
  Write(DMACC0LLIReg, 0x00000000);
  C("Programming Channel 0 Control Register");
  Write(DMACC0Control, 0x0C01B001);

  /* Channel 1 Programmed for P2P DMAC */
  C("Programming Channel 1 Source Address Register");
  Write(DMACC1SrcAddr, 0x618363FF);
  C("Programming Channel 1 Destination Address Register");
  Write(DMACC1DestAddr, 0x78C363FF);
  C("Programming Channel 1 LLI Address Register");
  Write(DMACC1LLIReg, 0x00000000);
  C("Programming Channel 1 Control Register");
  Write(DMACC1Control, 0x0C01B010);

  /* Programming Channel 0 and 1 Peripherals  with Default Waited Ok Response */
  Addr = SlaveAddrSelection(3);
  Write (Addr, 0x80000024);
  Write (Addr + 0x00000004, 0xC2000003);
  Addr = SlaveAddrSelection(6);
  Write (Addr, 0x80000024);
  Write (Addr + 0x00000004, 0xC2000003);
  Addr = SlaveAddrSelection(9);
  Write (Addr, 0x80000024);
  Write (Addr + 0x00000004, 0xA9000003);
  Addr = SlaveAddrSelection(12);
  Write (Addr, 0x80000024);
  Write (Addr + 0x00000004, 0xA9000003);

  C("Enabling Channel 0 and 1");
  Write(DMACC0Config, 0x00001987);
  Write(DMACC1Config, 0x00001B13);

  /* Programming DMA Requests of Channel 1  */
  Addr  = SlaveAddrSelection(9);
  C("Programming DMA Burst Request of Source Peripheral 9");
  Write(Addr + 0x00000008, 0x00000500);
  Addr  = SlaveAddrSelection(12);
  C("Programming DMA Burst Request of Destination Peripheral 12");
  Write(Addr + 0x00000008, 0x00000500);

  /* Programming DMA Requests of Channel 0  */
  C("Programming DMA Burst Request of Source Peripheral 3");
  Addr  = SlaveAddrSelection(3);
  Write(Addr + 0x00000008, 0x00000500);
  C("Programming DMA Burst Request of Destination Peripheral 6");
  Addr  = SlaveAddrSelection(6);
  Write(Addr + 0x00000008, 0x00000500);

  WaitLoop(10);

  /* Disable Channel 1 */
  RegAddr = ChannelRegisters(1);
  Write (*RegAddr + 0x00000010, 0x00001987 & DMACDISABLE);
  WaitLoop(10);

  /* Poll Channel Enable bit  of Channel 1 */
  MaskValue = 0x00000001;
  Poll(ConfigRegs[1], 0x00000000, MaskValue);

  /* Poll Channel Enable bit  of Channel 0 */
  MaskValue = 0x00000001;
  Poll(ConfigRegs[0], 0x00000000, MaskValue);

  /* Reset Channel 0 Peripherals */
  Addr = SlaveAddrSelection(3);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);
  Addr = SlaveAddrSelection(6);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);

  /* Reset Channel 6 Peripherals */
  Addr = SlaveAddrSelection(9);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);
  Addr = SlaveAddrSelection(12);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);

 /* This test is added for code coverage where Abort occurs in multichannel
    case. The aborted channel starts from boundary address with incrementing
    address mode and  it receives waited response before it gets abort
    Acknowledge from Master interface. It is expected after Abort, new channel
    to come on to the BUS for the data transfer

   The Abort is happening from the current channel, which is on AHB, 
   at the middle of the AHB access started by the DmacLiteMaster, at the same
   time next channel is coming up with the transfer request but the response
   for the last transfer for aborted channel is waited.

   The general steps, which needed to be followed to carry out the following
     test cases is given below.
     a) Program Channel 0 and Channel 1 for Source and Destination at 1kB
        boundary and TxSize greater than 1
     b) Program the peripheral modules of Channel 0 and 1.
     c) Abort Channel 1 data transfer
     d) Check Channel 0 starts data transfer
     e) Poll for Channel Enabled bit of Channel 1 and 0 to go low

   Program the Channel 0 and Channel 1 for following parameters
    Channel No             : 0
    Flow Controller        : DMAC
    Transfer Type          : P2P
    Source Width           : 8 bits
    Destination Width      : 8 bits
    Source Burst Size      : 16
    Destination Burst Size : 16
    Transfer Size          : 1
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode

    Channel No             : 1
    Flow Controller        : DMAC
    Transfer Type          : P2P
    Source Width           : 8 bits
    Destination Width      : 8 bits
    Source Burst Size      : 16
    Destination Burst Size : 16
    Transfer Size          : 16
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Non Incrementing mode
    Destination Incr Type  : Non Incrementing mode
*/
 C("Programming Channel 0 Source Address Register");
  Write(DMACC0SrcAddr, 0x3583A3FF);
  C("Programming Channel 0 Destination Address Register");
  Write(DMACC0DestAddr, 0x4BA903FF);
  C("Programming Channel 0 LLI Address Register");
  Write(DMACC0LLIReg, 0x00000000);
  C("Programming Channel 0 Control Register");
  Write(DMACC0Control, 0x0C01B001);

  /* Channel 1 Programmed for P2P DMAC */
  C("Programming Channel 1 Source Address Register");
  Write(DMACC1SrcAddr, 0x618363FF);
  C("Programming Channel 1 Destination Address Register");
  Write(DMACC1DestAddr, 0x78C363FF);
  C("Programming Channel 1 LLI Address Register");
  Write(DMACC1LLIReg, 0x00000000);
  C("Programming Channel 1 Control Register");
  Write(DMACC1Control, 0x0001B010);

  /* Programming Channel 0 and 1 Peripherals  with Default Waited Ok Response */
  Addr = SlaveAddrSelection(3);
  Write (Addr, 0x80000024);
  Write (Addr + 0x00000004, 0xC2000003);
  Addr = SlaveAddrSelection(6);
  Write (Addr, 0x80000024);
  Write (Addr + 0x00000004, 0xC2000003);
  Addr = SlaveAddrSelection(9);
  Write (Addr, 0x80000024);
  Write (Addr + 0x00000004, 0xA9000003);
  Addr = SlaveAddrSelection(12);
  Write (Addr, 0x80000024);
  Write (Addr + 0x00000004, 0xA9000003);

  C("Enabling Channel 0 and 6");
  Write(DMACC0Config, 0x00001987);
  Write(DMACC1Config, 0x00001B13);

  /* Programming DMA Requests of Channel 1  */
  Addr  = SlaveAddrSelection(9);
  C("Programming DMA Burst Request of Source Peripheral 9");
  Write(Addr + 0x00000008, 0x00000500);
  Addr  = SlaveAddrSelection(12);
  C("Programming DMA Burst Request of Destination Peripheral 12");
  Write(Addr + 0x00000008, 0x00000500);

  /* Programming DMA Requests of Channel 0  */
  C("Programming DMA Burst Request of Source Peripheral 3");
  Addr  = SlaveAddrSelection(3);
  Write(Addr + 0x00000008, 0x00000500);
  C("Programming DMA Burst Request of Destination Peripheral 1");
  Addr  = SlaveAddrSelection(6);
  Write(Addr + 0x00000008, 0x00000500);

  WaitLoop(10);

  /* Disable Channel 1 */
  RegAddr = ChannelRegisters(1);
  Write (*RegAddr + 0x00000010, 0x00001987 & DMACDISABLE);
  WaitLoop(10);

  /* Poll Channel Enable bit  of Channel 1 */
  MaskValue = 0x00000001;
  Poll(ConfigRegs[1], 0x00000000, MaskValue);

  /* Poll Channel Enable bit  of Channel 0 */
  MaskValue = 0x00000001;
  Poll(ConfigRegs[0], 0x00000000, MaskValue);

  /* Reset Channel 0 Peripherals */
  Addr = SlaveAddrSelection(3);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);
  Addr = SlaveAddrSelection(6);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);

  /* Reset Channel 1 Peripherals */
  Addr = SlaveAddrSelection(9);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);
  Addr = SlaveAddrSelection(12);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);

 /* This test is added for code coverage where Abort happens at the boundary
    of 1KB
    Program the Channel 0 and Channel 1 for following parameters

    Channel No             : 0
    Flow Controller        : DMAC
    Transfer Type          : P2P
    Source Width           : 8 bits
    Destination Width      : 8 bits
    Source Burst Size      : 16
    Destination Burst Size : 16
    Transfer Size          : 15
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode

    Channel No             : 1
    Flow Controller        : DMAC
    Transfer Type          : P2P
    Source Width           : 8 bits
    Destination Width      : 8 bits
    Source Burst Size      : 16
    Destination Burst Size : 16
    Transfer Size          : 15
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode
*/

 C("Programming Channel 0 Source Address Register");
  Write(DMACC0SrcAddr, 0x3583A3F9);
  C("Programming Channel 0 Destination Address Register");
  Write(DMACC0DestAddr, 0x4BA903F9);
  C("Programming Channel 0 LLI Address Register");
  Write(DMACC0LLIReg, 0x00000000);
  C("Programming Channel 0 Control Register");
  Write(DMACC0Control, 0x0C01B00F);

  /* Channel 1 Programmed for P2P DMAC */
  C("Programming Channel 1 Source Address Register");
  Write(DMACC1SrcAddr, 0x618363F9);
  C("Programming Channel 1 Destination Address Register");
  Write(DMACC1DestAddr, 0x78C363F9);
  C("Programming Channel 1 LLI Address Register");
  Write(DMACC1LLIReg, 0x00000000);
  C("Programming Channel 1 Control Register");
  Write(DMACC1Control, 0x0C01B00F);

  /* Programming Channel 0 and 1 Peripherals  with Default Waited Ok Response */
  Addr = SlaveAddrSelection(3);
  Write (Addr, 0x80000024);
  Write (Addr + 0x00000004, 0xC2000003);
  Addr = SlaveAddrSelection(6);
  Write (Addr, 0x80000024);
  Write (Addr + 0x00000004, 0xC2000003);
  Addr = SlaveAddrSelection(9);
  Write (Addr, 0x80000024);
  Write (Addr + 0x00000004, 0xA9000003);
  Addr = SlaveAddrSelection(12);
  Write (Addr, 0x80000024);
  Write (Addr + 0x00000004, 0xA9000003);

  C("Enabling Channel 0 and 1");
  Write(DMACC0Config, 0x00001987);
  Write(DMACC1Config, 0x00001B13);

  /* Programming DMA Requests of Channel 1  */
  Addr  = SlaveAddrSelection(9);
  C("Programming DMA Burst Request of Source Peripheral 9");
  Write(Addr + 0x00000008, 0x00000500);
  Addr  = SlaveAddrSelection(12);
  C("Programming DMA Burst Request of Destination Peripheral 12");
  Write(Addr + 0x00000008, 0x00000500);

  /* Programming DMA Requests of Channel 0  */
  C("Programming DMA Burst Request of Source Peripheral 3");
  Addr  = SlaveAddrSelection(3);
  Write(Addr + 0x00000008, 0x00000500);
  C("Programming DMA Burst Request of Destination Peripheral 1");
  Addr  = SlaveAddrSelection(6);
  Write(Addr + 0x00000008, 0x00000500);

  /* This wait loop is added to give the abort to the channel
     exactly near the boundary */
  WaitLoop(30);

  /* Disable Channel 1 */
  RegAddr = ChannelRegisters(1);
  Write (*RegAddr + 0x00000010, 0x00001987 & DMACDISABLE);
  WaitLoop(10);

  /* Poll Channel Enable bit  of Channel 1 */
  MaskValue = 0x00000001;
  Poll(ConfigRegs[1], 0x00000000, MaskValue);

  /* Poll Channel Enable bit  of Channel 0 */
  MaskValue = 0x00000001;
  Poll(ConfigRegs[0], 0x00000000, MaskValue);

  /* Reset Channel 0 Peripherals */
  Addr = SlaveAddrSelection(3);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);
  Addr = SlaveAddrSelection(6);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);

  /* Reset Channel 1 Peripherals */
  Addr = SlaveAddrSelection(9);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);
  Addr = SlaveAddrSelection(12);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);

  Write(DMACREQCONFIG,0x00000000);

  /* Enable Trickbox for the next tests */
  Write(DMACTRICKEN, 0x00000001);

  /* The following test will test that the SoftReq bits are reset after
     an error response. */
  /* For each of the peripheral, this will test that the SoftReq bits are
     reset after an error response */
  for (i=0;i<16;i++)
  {
    C("Testing the SoftReq of the peripheral.");
    SrcPeriphNo();

    Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRSTCLR);
    Write(DMACTrMemEn1, MEMORYRSTCLR);

    MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
    Write(DMACREQCONFIG, MasterConfig);

    Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHENABLE | DEFERROR);

    P2MDma(CHANNEL,
           SrcPeripheral,
           AddrGen(PeriphLowAddress[SrcPeripheral],
                   PeriphHighAddress[SrcPeripheral]) & 0XFFFFFFF0,
           AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & 0XFFFFFFF0,
           0x00000000,
           SMASTER,
           DMASTER,
           8,
           8,
           "I",
           "I",
           4,
           4,
           8,
           0,
           pbc,
           0,
           TCENABLE,
           TCMASK,
           ERRMASK);

    Write(DMACSoftBReq,(0x00000001 << SrcPeripheral));

    Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

    CheckStatus(CHANNEL);

    Write(DMACSoftBReq,0x00000000);

    Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
    Write(DMACTrMemEn1, MEMORYRESET);
  }
    C("LLI TEST CASES START FROM HERE ");
   /* The following test cases are related to LLI transactions. They are
      added to get more coverage from the implementation point of view.
      The following cases are covered in the following tests for all the
      channels.
      1. P2M transfer with LLI, and with the peripheral as the flow controller.
      2. M2P transfer with LLI, and with the peripheral as the flow controller.
      3. P2P transfer with LLI, and with the dmac as the flow controller.
      4. Error response to be returned while loading the destination register
         value from the LLI.                                                  
      Note: IntTCEnable is set to '1' in all the test cases.                  */

   Endianness = 1;
   Write(DMACConfig,DMACENABLE);

   C("LLI tests for P2M Dma");
   /* The test is repeated for both channels */
     SrcAddrMask  = 0xFFFFFFFC;
     DestAddrMask = 0xFFFFFFFC;

   Write(DMACTrMemEn0, MEMORYDISABLE);
   Write(DMACTrMemEn1, MEMORYDISABLE);

   Write(DMACTrMemEn0, MEMORYENABLE);
   Write(DMACTrMemEn1, MEMORYENABLE);

   for(i=0;i<2;i++) {
     SrcPeriphNo();

     Write((DMACTR_BASE | 0x00010200),
           (AddrGen(PeriphLowAddress[SrcPeripheral],
                   PeriphHighAddress[SrcPeripheral]) & SrcAddrMask));
     Write((DMACTR_BASE | 0x00010204),
           (AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask));
     Write((DMACTR_BASE | 0x00010208), 0x00000000);
     ControlData = SbValue(4) | DbValue(4) | SwValue (8) | DwValue(8) |
                   SmValue(0) | DmValue(0) | SiValue("NI") | DiValue("NI") |
                   TeValue(0);
     Write((DMACTR_BASE | 0x0001020C), ControlData);

     /* Clear pending interrupts if any */
     Write(DMACIntTCClr, 0x00000003);
     Write(DMACIntErrClr, 0x00000003);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRSTCLR);
     Write(DMACTrMemEn1, MEMORYRSTCLR);
     Write(DMACTrMemEn0, MEMORYRSTCLR);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHENABLE | DEFWAIT5 |
            DEFOKAY);

     Write(DMACTrMemEn1, MEMORYENABLE | DEFWAIT3 | DEFOKAY);

     Write(DMACTrMemEn0, MEMORYENABLE | DEFWAIT10 | DEFOKAY);

     Write(PeriphReg(SrcPeripheral, PERIPHDATAREG), 0x12345678);
     Write(DMACTrMemData1, 0x12345678);

     /* Program the request register of the peripheral to initiate
        DMALSREQ request */
     Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (5 << 16));
     P2MSp(i,
           SrcPeripheral,
           AddrGen(PeriphLowAddress[SrcPeripheral],
                   PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
           AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
           DMACTRMEM0BASE,
           0,
           0,
           8,
           8,
           "NI",
           "NI",
           4,
           4,
           0,
           pbc,
           0,
           1,
           0,
           0);
     Poll(DMACSoftLSReq, (0x00000001 << SrcPeripheral), 0x0000FFFF);
     Poll(DMACSoftLSReq, 0x00000000, 0x0000FFFF);

     Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (5 << 16));
     Poll(ConfigRegs[i], 0x00000000, 0x00000001);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
     Write(DMACTrMemEn1, MEMORYRESET);
   }

   C("LLI tests for P2P Dma");
   /* The test is repeated for all the eight channels */
     SrcAddrMask  = 0xFFFFFFFC;
     DestAddrMask = 0xFFFFFFFC;

   Write(DMACTrMemEn0, MEMORYDISABLE);
   Write(DMACTrMemEn1, MEMORYDISABLE);

   Write(DMACTrMemEn0, MEMORYENABLE);
   Write(DMACTrMemEn1, MEMORYENABLE);

   for(i=0;i<2;i++) {
     SrcPeriphNo();
     DestPeriphNo();

     Write((DMACTR_BASE | 0x00010200),
           (AddrGen(PeriphLowAddress[SrcPeripheral],
                   PeriphHighAddress[SrcPeripheral]) & SrcAddrMask));
     Write((DMACTR_BASE | 0x00010204),
           (AddrGen(PeriphLowAddress[DestPeripheral],
                   PeriphHighAddress[DestPeripheral]) & DestAddrMask));
     Write((DMACTR_BASE | 0x00010208), 0x00000000);

     /* The last operand in the following equation (0x00000004) corresponds
        to the transfer size.                                              */
     ControlData = SbValue(4) | DbValue(4) | SwValue (8) | DwValue(8) |
                   SmValue(0) | DmValue(0) | SiValue("I") | DiValue("I") |
                   TeValue(0) | 0x00000004;
     Write((DMACTR_BASE | 0x0001020C), ControlData);

     /* Clear pending interrupts if any */
     Write(DMACIntTCClr, 0x000000FF);
     Write(DMACIntErrClr, 0x000000FF);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
     Write(DMACTrMemEn0, MEMORYRESET);
     Write(DMACTrMemEn1, MEMORYRESET);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRSTCLR);
     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRSTCLR);
     Write(DMACTrMemEn1, MEMORYRSTCLR);
     Write(DMACTrMemEn0, MEMORYRSTCLR);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHENABLE | DEFWAIT5 |
            DEFOKAY);

     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHENABLE | DEFOKAY);

     Write(DMACTrMemEn1, MEMORYENABLE | DEFWAIT3 | DEFOKAY);

     Write(DMACTrMemEn0, MEMORYENABLE | DEFWAIT10 | DEFOKAY);

     Write(PeriphReg(SrcPeripheral, PERIPHDATAREG), 0x12345678);
     Write(PeriphReg(DestPeripheral, PERIPHDATAREG), 0x12345678);

     /* Program the request register of the peripheral to initiate
        DMALSREQ request */
     Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (5 << 8));
     Write(PeriphReg(DestPeripheral, PERIPHREQREG), (15 << 8));

     P2PDma(i,
            AddrGen(PeriphLowAddress[SrcPeripheral],
                    PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
            AddrGen(PeriphLowAddress[DestPeripheral],
                    PeriphHighAddress[DestPeripheral]) & DestAddrMask,
            DMACTRMEM0BASE,
            SrcPeripheral,
            DestPeripheral,
            0,
            0,
            8,
            8,
            "I",
            "I",
            4,
            4,
            4,
            0,
            pbc,
            0,
            1,
            1,
            0);

     Poll(DMACIntTCStat, (0x00000001 << i), 0x0000FFFF);
     Write(DMACIntTCClr, (0x00000001 << i));
     Poll(DMACIntTCStat, 0x00000000, 0x0000FFFF);

     Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (5 << 8));
     Write(PeriphReg(DestPeripheral, PERIPHREQREG), (5 << 8));

     Poll(ConfigRegs[i], 0x00000000, 0x00000001);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);
   }

   /* The test is repeated for all the eight channels */
     SrcAddrMask  = 0xFFFFFFFC;
     DestAddrMask = 0xFFFFFFFC;

   Write(DMACTrMemEn0, MEMORYDISABLE);
   Write(DMACTrMemEn1, MEMORYDISABLE);

   Write(DMACTrMemEn0, MEMORYENABLE);
   Write(DMACTrMemEn1, MEMORYENABLE);

   for(i=0;i<2;i++) {
     SrcPeriphNo();
     DestPeriphNo();

     Write((DMACTR_BASE | 0x00010200),
           (AddrGen(PeriphLowAddress[SrcPeripheral],
                   PeriphHighAddress[SrcPeripheral]) & SrcAddrMask));
     Write((DMACTR_BASE | 0x00010204),
           (AddrGen(PeriphLowAddress[DestPeripheral],
                   PeriphHighAddress[DestPeripheral]) & DestAddrMask));
     Write((DMACTR_BASE | 0x00010208), 0x00000000);
     ControlData = SbValue(4) | DbValue(4) | SwValue (8) | DwValue(8) |
                   SmValue(0) | DmValue(0) | SiValue("I") | DiValue("I") |
                   TeValue(0);
     Write((DMACTR_BASE | 0x0001020C), ControlData);

     /* Clear pending interrupts if any */
     Write(DMACIntTCClr, 0x00000003);
     Write(DMACIntErrClr, 0x00000003);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
     Write(DMACTrMemEn0, MEMORYRESET);
     Write(DMACTrMemEn1, MEMORYRESET);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRSTCLR);
     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRSTCLR);
     Write(DMACTrMemEn1, MEMORYRSTCLR);
     Write(DMACTrMemEn0, MEMORYRSTCLR);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHENABLE | DEFWAIT5 |
            DEFOKAY);

     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHENABLE | DEFOKAY);

     Write(DMACTrMemEn1, MEMORYENABLE | DEFWAIT3 | DEFOKAY);

     Write(DMACTrMemEn0, MEMORYENABLE | DEFWAIT10 | DEFOKAY);

     Write(PeriphReg(SrcPeripheral, PERIPHDATAREG), 0x12345678);
     Write(PeriphReg(DestPeripheral, PERIPHDATAREG), 0x12345678);

     /* Program the request register of the peripheral to initiate
        DMALSREQ request */
     Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (5 << 16));
     Write(PeriphReg(DestPeripheral, PERIPHREQREG), (15 << 8));

     P2PSp(i,
           AddrGen(PeriphLowAddress[SrcPeripheral],
                   PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
           AddrGen(PeriphLowAddress[DestPeripheral],
                   PeriphHighAddress[DestPeripheral]) & DestAddrMask,
           DMACTRMEM0BASE,
           SrcPeripheral,
           DestPeripheral,
           0,
           0,
           8,
           8,
           "I",
           "I",
           4,
           4,
           0,
           0,
           pbc,
           0,
           1,
           1,
           0);

     Poll(DMACSoftLSReq, (0x00000001 << SrcPeripheral), 0x0000FFFF);
     Poll(DMACSoftLSReq, 0x00000000, 0x0000FFFF);

     Poll(DMACIntTCStat, (0x00000001 << i), 0x0000FFFF);
     Write(DMACIntTCClr, (0x00000001 << i));
     Poll(DMACIntTCStat, 0x00000000, 0x0000FFFF);

     Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (5 << 16));
     Write(PeriphReg(DestPeripheral, PERIPHREQREG), (5 << 8));

     Poll(ConfigRegs[i], 0x00000000, 0x00000001);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);
   }

   /* The test is repeated for all the eight channels */
     SrcAddrMask  = 0xFFFFFFFC;
     DestAddrMask = 0xFFFFFFFC;

   Write(DMACTrMemEn0, MEMORYDISABLE);
   Write(DMACTrMemEn1, MEMORYDISABLE);

   Write(DMACTrMemEn0, MEMORYENABLE);
   Write(DMACTrMemEn1, MEMORYENABLE);

   for(i=0;i<2;i++) {
     SrcPeriphNo();
     DestPeriphNo();

     Write((DMACTR_BASE | 0x00010200),
           (AddrGen(PeriphLowAddress[SrcPeripheral],
                   PeriphHighAddress[SrcPeripheral]) & SrcAddrMask));
     Write((DMACTR_BASE | 0x00010204),
           (AddrGen(PeriphLowAddress[DestPeripheral],
                   PeriphHighAddress[DestPeripheral]) & DestAddrMask));
     Write((DMACTR_BASE | 0x00010208), 0x00000000);
     ControlData = SbValue(4) | DbValue(4) | SwValue (8) | DwValue(8) |
                   SmValue(0) | DmValue(0) | SiValue("I") | DiValue("I") |
                   TeValue(0);
     Write((DMACTR_BASE | 0x0001020C), ControlData);

     /* Clear pending interrupts if any */
     Write(DMACIntTCClr, 0x000000FF);
     Write(DMACIntErrClr, 0x000000FF);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
     Write(DMACTrMemEn0, MEMORYRESET);
     Write(DMACTrMemEn1, MEMORYRESET);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRSTCLR);
     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRSTCLR);
     Write(DMACTrMemEn1, MEMORYRSTCLR);
     Write(DMACTrMemEn0, MEMORYRSTCLR);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHENABLE | DEFWAIT5 |
            DEFOKAY);

     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHENABLE | DEFOKAY);

     Write(DMACTrMemEn1, MEMORYENABLE | DEFWAIT3 | DEFOKAY);

     Write(DMACTrMemEn0, MEMORYENABLE | DEFWAIT10 | DEFOKAY);

     Write(PeriphReg(SrcPeripheral, PERIPHDATAREG), 0x12345678);
     Write(PeriphReg(DestPeripheral, PERIPHDATAREG), 0x12345678);

     /* Program the request register of the peripheral to initiate
        DMALSREQ request */
     Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (15 << 8));
     Write(PeriphReg(DestPeripheral, PERIPHREQREG), (5 << 16));

     P2PDp(i,
           AddrGen(PeriphLowAddress[SrcPeripheral],
                   PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
           AddrGen(PeriphLowAddress[DestPeripheral],
                   PeriphHighAddress[DestPeripheral]) & DestAddrMask,
           DMACTRMEM0BASE,
           SrcPeripheral,
           DestPeripheral,
           0,
           0,
           8,
           8,
           "I",
           "I",
           4,
           4,
           0,
           0,
           pbc,
           0,
           1,
           1,
           0);

     Poll(DMACSoftLSReq, (0x00000001 << DestPeripheral), 0x0000FFFF);
     Poll(DMACSoftLSReq, 0x00000000, 0x0000FFFF);

     Poll(DMACIntTCStat, (0x00000001 << i), 0x0000FFFF);
     Write(DMACIntTCClr, (0x00000001 << i));
     Poll(DMACIntTCStat, 0x00000000, 0x0000FFFF);

     Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (5 << 8));
     Write(PeriphReg(DestPeripheral, PERIPHREQREG), (5 << 16));

     Poll(ConfigRegs[i], 0x00000000, 0x00000001);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);
   }

  Write(DMACREQCONFIG, 0x00000000);

   C("2 Channel tests with LLI loading.");
   /* The following test is added to get more coverage. */
   /* Channel 0 is programmed to initiate an P2M transaction with 16 as the
      burst size of the peripheral and memory and the same value as the
      transfer size. All the peripheral and memory will be programmed to
      return a single clock wait response.
      Another channel (1,2,3,4,5,6 and 7) will be programmed for an M2M
      transfer with a burst size of 4 and an error response will be returned
      for the fourth transfer.                                               */

   SrcAddrMask  = 0xFFFFFFF0;
   DestAddrMask = 0xFFFFFFF0;

   Write(DMACTrMemEn0, MEMORYDISABLE);
   Write(DMACTrMemEn1, MEMORYDISABLE);

   Write(DMACTrMemEn0, MEMORYENABLE);
   Write(DMACTrMemEn1, MEMORYENABLE);

   for(i=1;i<2;i++) {
     SrcPeriphNo();
     DestPeriphNo();

     Write((DMACTR_BASE | 0x00020200),
           (AddrGen(PeriphLowAddress[SrcPeripheral],
                   PeriphHighAddress[SrcPeripheral]) & SrcAddrMask));
     Write((DMACTR_BASE | 0x00020204),
           (AddrGen(PeriphLowAddress[DestPeripheral],
                   PeriphHighAddress[DestPeripheral]) & DestAddrMask));
     Write((DMACTR_BASE | 0x00020208), 0x00000000);
     ControlData = SbValue(16) | DbValue(16) | SwValue (8) | DwValue(8) |
                   SmValue(0) | DmValue(0) | SiValue("I") | DiValue("I") |
                   TeValue(0);
     Write((DMACTR_BASE | 0x0002020C), ControlData);

     /* Clear pending interrupts if any */
     Write(DMACIntTCClr, 0x000000FF);
     Write(DMACIntErrClr, 0x000000FF);

     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRSTCLR);
     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRSTCLR);
     Write(DMACTrMemEn1, MEMORYRSTCLR);
     Write(DMACTrMemEn0, MEMORYRSTCLR);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHENABLE | DEFWAIT2 |
            DEFOKAY);
     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHENABLE | DEFWAIT2 |
            DEFOKAY);

     Write(DMACTrMemEn1, MEMORYENABLE | DEFOKAY);
     /* Programmed to return an error response when HADDR[1:0] is 11 */
     Write(DMACTrMemControl1, 0x81010003);
     Write((DMACTrMemControl1 + 0x00000004), 0xA1010003);

     Write(DMACTrMemEn0, MEMORYENABLE | DEFOKAY);

     Write(PeriphReg(SrcPeripheral, PERIPHDATAREG), 0x12345678);
     Write(PeriphReg(DestPeripheral, PERIPHDATAREG), 0x12345678);

     /* Program the request register of the peripheral to initiate
        DMALSREQ request */
     Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (0x05 << 24));
     Write(PeriphReg(DestPeripheral, PERIPHREQREG), (0x05 << 8));
     P2PSp(i,
           AddrGen(PeriphLowAddress[SrcPeripheral],
                   PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
           AddrGen(PeriphLowAddress[DestPeripheral],
                   PeriphHighAddress[DestPeripheral]) & DestAddrMask,
           DMACTRMEM1BASE,
           SrcPeripheral,
           DestPeripheral,
           0,
           0,
           8,
           8,
           "I",
           "I",
           16,
           16,
           0,
           0,
           pbc,
           0,
           1,
           1,
           0);
     Poll(DMACSoftLBReq, (0x00000001 << SrcPeripheral), 0x0000FFFF);
     Poll(DMACSoftLBReq, 0x00000000, 0x0000FFFF);

     M2MDma(0,
            AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & 0xFFFFFFF0,
            AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & 0xFFFFFFF0,
            0x00000000,
            0,
            0,
            8,
            8,
            "I",
            "I",
            4,
            4,
            4,
            0,
            pbc,
            0,
            0,
            0,
            0);

     Poll(ConfigRegs[i], 0x00000000, 0x00000001);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);
   }

   /* Channel 0 is programmed to initiate an P2M transaction with 16 as the
      burst size of the peripheral and memory and the same value as the
      transfer size. All the peripheral and memory will be programmed to
      return a single clock wait response.
      Another channel (1,2,3,4,5,6 and 7) will be programmed for an M2M
      transfer with a burst size of 4 and an error response will be returned
      for the third transfer.                                               */

   C("2 Channel test case, with error response before LLI loading");
   SrcAddrMask  = 0xFFFFFFF0;
   DestAddrMask = 0xFFFFFFF0;

   Write(DMACTrMemEn0, MEMORYDISABLE);
   Write(DMACTrMemEn1, MEMORYDISABLE);

   Write(DMACTrMemEn0, MEMORYENABLE);
   Write(DMACTrMemEn1, MEMORYENABLE);

   for(i=1;i<2;i++) {
     SrcPeriphNo();
     DestPeriphNo();

     Write((DMACTR_BASE | 0x00020200),
           (AddrGen(PeriphLowAddress[SrcPeripheral],
                   PeriphHighAddress[SrcPeripheral]) & SrcAddrMask));
     Write((DMACTR_BASE | 0x00020204),
           (AddrGen(PeriphLowAddress[DestPeripheral],
                   PeriphHighAddress[DestPeripheral]) & DestAddrMask));
     Write((DMACTR_BASE | 0x00020208), 0x00000000);
     ControlData = SbValue(16) | DbValue(16) | SwValue (8) | DwValue(8) |
                   SmValue(0) | DmValue(0) | SiValue("I") | DiValue("I") |
                   TeValue(0);
     Write((DMACTR_BASE | 0x0002020C), ControlData);

     /* Clear pending interrupts if any */
     Write(DMACIntTCClr, 0x000000FF);
     Write(DMACIntErrClr, 0x000000FF);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRSTCLR);
     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRSTCLR);
     Write(DMACTrMemEn1, MEMORYRSTCLR);
     Write(DMACTrMemEn0, MEMORYRSTCLR);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHENABLE | DEFWAIT1 |
            DEFOKAY);
     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHENABLE | DEFWAIT1 |
            DEFOKAY);

     Write(DMACTrMemEn1, MEMORYENABLE | DEFOKAY);
     /* Programmed to return an error response when HADDR[1:0] is 11 */
     Write(DMACTrMemControl1, 0x81010002);
     Write((DMACTrMemControl1 + 0x00000004), 0xA1010003);

     Write(DMACTrMemEn0, MEMORYENABLE | DEFOKAY);

     Write(PeriphReg(SrcPeripheral, PERIPHDATAREG), 0x12345678);
     Write(PeriphReg(DestPeripheral, PERIPHDATAREG), 0x12345678);

     /* Program the request register of the peripheral to initiate
        DMALSREQ request */
     Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (0x05 << 24));
     Write(PeriphReg(DestPeripheral, PERIPHREQREG), (0x05 << 8));
     P2PSp(i,
           AddrGen(PeriphLowAddress[SrcPeripheral],
                   PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
           AddrGen(PeriphLowAddress[DestPeripheral],
                   PeriphHighAddress[DestPeripheral]) & DestAddrMask,
           DMACTRMEM1BASE,
           SrcPeripheral,
           DestPeripheral,
           0,
           0,
           8,
           8,
           "I",
           "I",
           16,
           16,
           0,
           0,
           pbc,
           0,
           1,
           1,
           0);
     Poll(DMACSoftLBReq, (0x00000001 << SrcPeripheral), 0x0000FFFF);
     Poll(DMACSoftLBReq, 0x00000000, 0x0000FFFF);

     M2MDma(0,
            AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & 0xFFFFFFF0,
            AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & 0xFFFFFFF0,
            0x00000000,
            0,
            0,
            8,
            8,
            "I",
            "I",
            4,
            4,
            4,
            0,
            pbc,
            0,
            0,
            0,
            0);

     Poll(ConfigRegs[i], 0x00000000, 0x00000001);

     Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
     Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);
   }
   /* To initiate an M2M transaction on all the channels and to give an
      error response during the last data transfer of source/destination */
   C("M2M transfer with error response.");
   /* This test is repeated for all channels */
   for(i=0;i<2;i++) {
     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);

     Write(DMACTrMemEn1, MEMORYRSTCLR);
     Write(DMACTrMemEn0, MEMORYRSTCLR);

     Write(DMACTrMemEn1, MEMORYENABLE | DEFOKAY);
     Write(DMACTrMemEn0, MEMORYENABLE | DEFOKAY);

     Write(DMACTrMemControl1, 0x81010003);

     M2MDma(i,
            AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & 0xFFFFFFF0,
            AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & 0xFFFFFFF0,
            0x00000000,
            0,
            0,
            8,
            8,
            "I",
            "I",
            4,
            4,
            4,
            0,
            pbc,
            0,
            0,
            0,
            0);

     Poll(ConfigRegs[i], 0x00000000, 0x00000001);

     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);
   }

   /* To initiate an M2M transaction on all the channels and to give an
      error response during the last data transfer of source/destination */
   C("M2M transfer with error response.");
   /* This test is repeated for all channels */
   for(i=0;i<2;i++) {
     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);

     Write(DMACTrMemEn1, MEMORYRSTCLR);
     Write(DMACTrMemEn0, MEMORYRSTCLR);

     Write(DMACTrMemEn1, MEMORYENABLE | DEFOKAY);
     Write(DMACTrMemEn0, MEMORYENABLE | DEFOKAY);

     Write(DMACTrMemControl1, 0x81010003);

     M2MDma(i,
            AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & 0xFFFFFFF0,
            AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & 0xFFFFFFF0,
            0x00000000,
            0,
            0,
            8,
            8,
            "I",
            "I",
            4,
            4,
            4,
            0,
            pbc,
            0,
            0,
            0,
            0);

     Poll(ConfigRegs[i], 0x00000000, 0x00000001);

     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);
   }

   /* This test is repeated for all channels */
   for(i=0;i<2;i++) {
     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);

     Write(DMACTrMemEn1, MEMORYRSTCLR);
     Write(DMACTrMemEn0, MEMORYRSTCLR);

     Write(DMACTrMemEn1, MEMORYENABLE | DEFOKAY);
     Write(DMACTrMemEn0, MEMORYENABLE | DEFOKAY);

     Write(DMACTrMemControl0, 0x81010003);

     M2MDma(i,
            AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & 0xFFFFFFF0,
            AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & 0xFFFFFFF0,
            0x00000000,
            0,
            0,
            8,
            8,
            "I",
            "I",
            4,
            4,
            4,
            0,
            pbc,
            0,
            0,
            0,
            0);

     Poll(ConfigRegs[i], 0x00000000, 0x00000001);

     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);
   }

   /* This test is repeated for all channels */
   for(i=0;i<2;i++) {
     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);

     Write(DMACTrMemEn1, MEMORYRSTCLR);
     Write(DMACTrMemEn0, MEMORYRSTCLR);

     Write(DMACTrMemEn1, MEMORYENABLE | DEFOKAY);
     Write(DMACTrMemEn0, MEMORYENABLE | DEFOKAY);

     Write(DMACTrMemControl1, 0x81010003);

     M2MDma(i,
            AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & 0xFFFFFFF0,
            AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & 0xFFFFFFF0,
            0x00000000,
            0,
            0,
            8,
            8,
            "I",
            "I",
            4,
            4,
            8,
            0,
            pbc,
            0,
            0,
            0,
            0);

     Poll(ConfigRegs[i], 0x00000000, 0x00000001);

     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);
   }

   /* The following test is to improve the coverage of the code.
      A transaction is started at 1KB boundary with 2 data transfers. */
   C("2 Data transfers at the 1KB boundary.");
   /* This test is repeated for all channels */
   for(i=0;i<2;i++) {
     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);

     Write(DMACTrMemEn1, MEMORYRSTCLR);
     Write(DMACTrMemEn0, MEMORYRSTCLR);

     Write(DMACTrMemEn1, MEMORYENABLE | DEFOKAY);
     Write(DMACTrMemEn0, MEMORYENABLE | DEFOKAY);

     Write(DMACTrMemControl1, 0x81010003);

     M2MDma(i,
            0x08FFFFFF,
            0x11FFFFFF,
            0x00000000,
            0,
            0,
            8,
            8,
            "I",
            "I",
            4,
            4,
            2,
            0,
            pbc,
            0,
            0,
            0,
            0);

     Poll(ConfigRegs[i], 0x00000000, 0x00000001);

     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRESET);
   }

   Write(DMACREQCONFIG,0x00000000);
}

/************************************ End *************************************/
