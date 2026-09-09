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
-- File Name              : DmacCornerTests.c.rca
-- File Revision          : 1.5
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

void DmacCornerTests()
{
  int32 TxrSize, ControlData, ConfigData;
  int32 Addr, MaskValue, *RegAddr;
  int i, j, MasterConfig;

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

  C("Writting  to Control reg 1 of Memory Module 1 ");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  C("Enabling Memory Module 2 ");
  Write(DMACTrMemEn1, 0x800000C8);

  C("Writting  to Control reg 1 of Memory Module 2 ");
  Write(DMACTrMemData1, 0xC2000003);

  C("Writting  to Grant Control Register ");
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

  C("Writting  to Control reg 1 of Memory Module 1 ");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  C("Enabling Memory Module 2 ");
  Write(DMACTrMemEn1, 0x800000C8);

  C("Writting  to Control reg 1 of Memory Module 2 ");
  Write(DMACTrMemData1, 0xC2000003);

  C("Writting  to Grant Control Register ");
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

  C("Test to cover address increment");

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

  Write(DMACREQCONFIG, 0xFFFFFFFF);

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

  Write(DMACREQCONFIG, 0x00000000);

  /* Lock test cases added to test all the channels. */

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);

  Write(DMACConfig, DMACENABLE);
  /* Little Endian mode */
  Endianness = 0;

  for (i=0;i<2;i++)
  {
    for (j=0;j<1;j++)
    {
        /* The master of the Dmac with which the source and destination memory
           models will interact are configured in the Request Configuration
           (DMACREQCONFIG) register of the trickbox
           Please note that Memory0 is always fixed as the source of the DMA
            and Memory1 is always fixed as the destination.     */
        MasterConfig = (j << 1) | j;
        Write(DMACREQCONFIG, MasterConfig);

        /* Big Endian mode */
        Endianness = 1;

        Write(DMACConfig, (DMACENABLE |
                          (Endianness << 1) | (Endianness << 2)));

        ProgramResponse("M2M", 16, 8, 8);

        M2MDma(i,
               AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & 0xFFFFFFFE,
               AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & 0xFFFFFFFE,
               0x00000000,
               j,
               j,
               (8 * (j + 1)),
               (8 * (j + 1)),
               "I",
               "I",
               8,
               8,
               16,
               0,
               pbc,
               1,
               1,
               1,
               1);
        Write(DMACTrMemEn0, MEMORYRESET);
        Write(DMACTrMemEn1, MEMORYRESET);
        Write(DMACConfig, DMACENABLE);
        /* Little Endian mode */
        Endianness = 0;

    }
  }

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

#ifdef TWOMASTERCONFIG
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

  /* Reset Channel 1 Peripherals */
  Addr = SlaveAddrSelection(9);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);
  Addr = SlaveAddrSelection(12);
  Write (Addr, PERIPHRESET);
  Write (Addr, PERIPHRSTCLR);

#endif
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
}

/************************************ End *************************************/
