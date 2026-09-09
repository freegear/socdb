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
-- File Name              : DmacMasTest.c.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--          This test checks the AHB Master Interface 
--
-- --=======================================================================--*/

/******************************************************************************/
/********************* List of Functions Called *******************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** -----------------------------------------------------------------------***/
/*** Write                                      DmacCommon.c                ***/
/*** msg_info                                   DmacCommon.c                ***/
/*** Poll                                       DmacCommon.c                ***/
/******************************************************************************/

void DmacMasTest()
{
  /* Summary : DmacMasTest
     =====================
     The general steps, which needed to be followed to carry out the following
     test cases is given below.  
     1) Poll for Channel0 enable flag to go low.
     2) Set up Channel0 for M2M transactions.
     3) Program the Channel Registers so that all possible combinations are
        tried out.
     4) Enable Channel0
     5) Wait for the Transactions to get over by Polling the Channel Enable
        Flag to go low.
     6) Re Program the channel for other combinations.
  */
  int32 TxrSize, ControlData, ConfigData;
  C("--------------------------------------------------");
  C("MASTER TESTS FOR DMAC WHEN MEMORY ARE ON MASTER0");
  C("--------------------------------------------------");
  C("DMAC_MSTR_1 :TESTING FOR BACK TO BACK TRANSFERS");
  /*
    Program the following for INCR4 followed by INCR4
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

  /* Resetting the Memory modules before the test begins*/
  Write(DMACTrMemEn0, MEMORYRESET);
  WaitLoop(1);

  Write(DMACTrMemEn1, MEMORYRESET);
  WaitLoop(1);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  /* Enable the DMAC */
  msg_info("Enabling the DMAC ");
  Write(DMACConfig, DMACENABLE);
 
  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000040);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000040);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000020;
  ControlData = SBURST4 | DBURST4 | SWIDTH32 | DWIDTH32 | SMASTER0 | DMASTER0 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);
 
  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);
 
  msg_info("Writting  to Control reg 1 of Memory Module 1 ");
  Write(DMACTrMemData0, 0xC2000003);
 
  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2 ");
  Write(DMACTrMemEn1, 0x80000000);
 
  msg_info("Writting  to Control reg 1 of Memory Module 2 ");
  Write(DMACTrMemData1, 0xC2000003);
 
  msg_info(" Channel 0 Config register ");
  ConfigData = M2MDMAC | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  WaitLoop(1);

  Write(DMACTrMemEn1, MEMORYRESET);
  WaitLoop(1);

  msg_info("TESTING FOR BACK TO BACK TRANSFERS INCR8 - INCR8");
  /*
    Program the following for INCR8 followed by INCR8
    Channel No : 0
    Flow Controller        : DMAC
    Transfer Type          : M2M
    Source Width           : 16 bits
    Destination Width      : 16 bits
    Source Burst Size      : 8 
    Destination Burst Size : 8
    Transfer Size          : 32
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000040);
  WaitLoop(1);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000040);
  WaitLoop(1);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000020;
  ControlData = SBURST8 | DBURST8 | SWIDTH16 | DWIDTH16 | SMASTER0 | DMASTER0 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);
  WaitLoop(1);
 
  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);
  WaitLoop(1);
 
  msg_info("Writting  to Control reg 1 of Memory Module 1 ");
  Write(DMACTrMemData0, 0xC2000003);
  WaitLoop(1);
 
  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2 ");
  Write(DMACTrMemEn1, 0x80000000);
  WaitLoop(1);
 
  msg_info("Writting  to Control reg 1 of Memory Module 2 ");
  Write(DMACTrMemData1, 0xC2000003);
 
  msg_info(" Channel 0 Config register ");
  ConfigData = M2MDMAC | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  WaitLoop(1);

  Write(DMACTrMemEn1, MEMORYRESET);
  WaitLoop(1);

  msg_info("TESTING FOR BACK TO BACK TRANSFERS INCR16 - INCR16");
  /*
    Program the following for INCR16 followed by INCR16
    Channel No : 0
    Flow Controller        : DMAC
    Transfer Type          : M2M
    Source Width           : 8 bits
    Destination Width      : 8 bits
    Source Burst Size      : 16 
    Destination Burst Size : 16
    Transfer Size          : 32
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000040);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000040);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000020;
  ControlData = SBURST16 | DBURST16 | SWIDTH8 | DWIDTH8 | SMASTER0 | DMASTER0 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);
 
  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);
  WaitLoop(1);
 
  msg_info("Writting  to Control reg 1 of Memory Module 1 ");
  Write(DMACTrMemData0, 0xC2000003);
 
  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2 ");
  Write(DMACTrMemEn1, 0x80000000);
 
  msg_info("Writting  to Control reg 1 of Memory Module 2 ");
  Write(DMACTrMemData1, 0xC2000003);
  WaitLoop(1);
 
  msg_info(" Channel 0 Config register ");
  ConfigData = M2MDMAC | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  WaitLoop(1);

  Write(DMACTrMemEn1, MEMORYRESET);
  WaitLoop(1);

  msg_info("TESTING FOR DIFFERENT HSIZE VALUES WITH BURST TRANSFERS"); 
  /*
    Program the following
    Channel No : 0
    Flow Controller        : DMAC
    Transfer Type          : M2M
    Source Width           : 16 bits
    Destination Width      : 8 bits
    Source Burst Size      : 8 
    Destination Burst Size : 8
    Transfer Size          : 32
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000040);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000040);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000020;
  ControlData = SBURST8 | DBURST8 | SWIDTH16 | DWIDTH8 | SMASTER0 | DMASTER0 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);
 
  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);
 
  msg_info("Writting  to Control reg 1 of Memory Module 1 ");
  Write(DMACTrMemData0, 0xC2000003);
 
  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2 ");
  Write(DMACTrMemEn1, 0x80000000);
 
  msg_info("Writting  to Control reg 1 of Memory Module 2 ");
  Write(DMACTrMemData1, 0xC2000003);
 
  msg_info(" Channel 0 Config register ");
  ConfigData = M2MDMAC | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);

  msg_info("Testing for Different HSIZE values With Burst Transfers"); 
  /*
    Program the following
    Channel No : 0
    Flow Controller        : DMAC
    Transfer Type          : M2M
    Source Width           : 32 bits
    Destination Width      : 16 bits
    Source Burst Size      : 8 
    Destination Burst Size : 8
    Transfer Size          : 32
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000040);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000040);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000020;
  ControlData = SBURST8 | DBURST8 | SWIDTH32 | DWIDTH16 | SMASTER0 | DMASTER0 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);

  msg_info("Writting  to Control reg 1 of Memory Module 1 ");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2 ");
  Write(DMACTrMemEn1, 0x80000000);

  msg_info("Writting  to Control reg 1 of Memory Module 2 ");
  Write(DMACTrMemData1, 0xC2000003); 
 
  msg_info(" Channel 0 Config register ");
  ConfigData = M2MDMAC | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);

  msg_info("TESTING FOR DIFFERENT HSIZE VALUES WITH UNINCR TRANSFERS"); 
  /*
    Program the following
    Channel No : 0
    Flow Controller        : DMAC
    Transfer Type          : M2M
    Source Width           : 16 bits
    Destination Width      : 8 bits
    Source Burst Size      : 8 
    Destination Burst Size : 8
    Transfer Size          : 32
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Non Incrementing mode
    Destination Incr Type  : Non Incrementing mode
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000040);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000040);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000020;
  ControlData = SBURST8 | DBURST8 | SWIDTH16 | DWIDTH8 | SMASTER0 | DMASTER0 |
                SNONINCR | DNONINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);

  msg_info("Writting  to Control reg 1 of Memory Module 1 ");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2 ");
  Write(DMACTrMemEn1, 0x80000000);

  msg_info("Writting  to Control reg 1 of Memory Module 2 ");
  Write(DMACTrMemData1, 0xC2000003); 
 
  msg_info(" Channel 0 Config register ");
  ConfigData = M2MDMAC | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);


  msg_info("Testing for Different HSIZE values With UNINCR Transfers"); 
  /*
    Program the following
    Channel No : 0
    Flow Controller        : DMAC
    Transfer Type          : M2M
    Source Width           : 32 bits
    Destination Width      : 16 bits
    Source Burst Size      : 8 
    Destination Burst Size : 8
    Transfer Size          : 32
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Non Incrementing mode
    Destination Incr Type  : Non Incrementing mode
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000040);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000040);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000020;
  ControlData = SBURST8 | DBURST8 | SWIDTH32 | DWIDTH16 | SMASTER0 | DMASTER0 |
                SNONINCR | DNONINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);

  msg_info("Writting  to Control reg 1 of Memory Module 1 ");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2 ");
  Write(DMACTrMemEn1, 0x80000000);

  msg_info("Writting  to Control reg 1 of Memory Module 2 ");
  Write(DMACTrMemData1, 0xC2000003); 
 
  msg_info(" Channel 0 Config register ");
  ConfigData = M2MDMAC | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);

  msg_info("TESTING FOR DIFFERENT HSIZE VALUES, BURST TRANSFERS AND LOCK SET");
 /*
    Program the following
    Channel No : 0
    Flow Controller        : DMAC
    Transfer Type          : M2M
    Source Width           : 16 bits
    Destination Width      : 8 bits
    Source Burst Size      : 8 
    Destination Burst Size : 8
    Transfer Size          : 32
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode
    Lock Transfer          : Enabled
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000040);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000040);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000020;
  ControlData = SBURST8 | DBURST8 | SWIDTH16 | DWIDTH8 | SMASTER0 | DMASTER0 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);

  msg_info("Writting  to Control reg 1 of Memory Module 1 ");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2 ");
  Write(DMACTrMemEn1, 0x80000000);

  msg_info("Writting  to Control reg 1 of Memory Module 2 ");
  Write(DMACTrMemData1, 0xC2000003); 
 
  msg_info(" Channel 0 Config register ");
  ConfigData = M2MDMAC | LOCK | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);


  msg_info("Testing for Diff HSIZE With Burst Transfers and LOCK bit set"); 
  /*
    Program the following
    Channel No : 0
    Flow Controller        : DMAC
    Transfer Type          : M2M
    Source Width           : 32 bits
    Destination Width      : 16 bits
    Source Burst Size      : 8 
    Destination Burst Size : 8
    Transfer Size          : 32
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode
    Lock Transfer          : Enabled
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000040);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000040);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000020;
  ControlData = SBURST8 | DBURST8 | SWIDTH32 | DWIDTH16 | SMASTER0 | DMASTER0 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module1");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2");
  Write(DMACTrMemEn1, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module2");
  Write(DMACTrMemData1, 0xC2000003); 
 
  msg_info("Channel0 Config Register");
  ConfigData = M2MDMAC | LOCK | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);

  msg_info("TESTING FOR DIFFERENT HSIZE VALUES,UNINCR TRANSFERS AND LOCK SET"); 
  /*
    Program the following
    Channel No : 0
    Flow Controller        : DMAC
    Transfer Type          : M2M
    Source Width           : 16 bits
    Destination Width      : 8 bits
    Source Burst Size      : 8 
    Destination Burst Size : 8
    Transfer Size          : 32
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Non Incrementing mode
    Destination Incr Type  : Non Incrementing mode
    Lock Transfer          : Enabled
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000040);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000040);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000020;
  ControlData = SBURST8 | DBURST8 | SWIDTH16 | DWIDTH8 | SMASTER0 | DMASTER0 |
                SNONINCR | DNONINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module1");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2");
  Write(DMACTrMemEn1, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module2");
  Write(DMACTrMemData1, 0xC2000003); 
 
  msg_info("Channel0 Config Register");
  ConfigData = M2MDMAC | LOCK | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);


  msg_info("Testing for Diff HSIZE values With UNINCR Transfers and LOCK set"); 
  /*
    Program the following
    Channel No : 0
    Flow Controller        : DMAC
    Transfer Type          : M2M
    Source Width           : 32 bits
    Destination Width      : 16 bits
    Source Burst Size      : 8 
    Destination Burst Size : 8
    Transfer Size          : 32
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Non Incrementing mode
    Destination Incr Type  : Non Incrementing mode
    Lock Transfer          : Enabled
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000040);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000040);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000020;
  ControlData = SBURST8 | DBURST8 | SWIDTH32 | DWIDTH16 | SMASTER0 | DMASTER0 |
                SNONINCR | DNONINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module1");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2");
  Write(DMACTrMemEn1, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module2");
  Write(DMACTrMemData1, 0xC2000003); 
 
  msg_info("Channel0 Config Register");
  ConfigData = M2MDMAC | LOCK | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);

  msg_info("TESTING FOR BACK TO BACK TRANSFERS INCR4 - SINGLE");
  /*
    Program the following for INCR4 followed by SINGLE
    Channel No             : 0
    Flow Controller        : DMAC
    Transfer Type          : M2M
    Source Width           : 32 bits
    Destination Width      : 32 bits
    Source Burst Size      : 4 
    Destination Burst Size : 1
    Transfer Size          : 8
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000040);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000040);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000008;
  ControlData = SBURST4 | DBURST1 | SWIDTH32 | DWIDTH32 | SMASTER0 | DMASTER0 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module1");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2");
  Write(DMACTrMemEn1, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module2");
  Write(DMACTrMemData1, 0xC2000003); 
 
  msg_info("Channel0 Config Register");
  ConfigData = M2MDMAC | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);

  msg_info("TESTING FOR BACK TO BACK TRANSFERS SINGLE - INCR4");
  /*
    Program the following for SINGLE followed by INCR4
    Channel No             : 0
    Flow Controller        : DMAC
    Transfer Type          : M2M
    Source Width           : 32 bits
    Destination Width      : 8 bits
    Source Burst Size      : 1 
    Destination Burst Size : 4
    Transfer Size          : 4
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000040);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000040);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000008;
  ControlData = SBURST1 | DBURST4 | SWIDTH32 | DWIDTH8 | SMASTER0 | DMASTER0 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module1");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2");
  Write(DMACTrMemEn1, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module2");
  Write(DMACTrMemData1, 0xC2000003); 
 
  msg_info("Channel0 Config Register");
  ConfigData = M2MDMAC | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);

  msg_info("TESTING FOR BACK TO BACK TRANSFERS INCR8 - SINGLE ");
  /*
    Program the following for INCR8 followed by SINGLE
    Channel No             : 0
    Flow Controller        : DMAC
    Transfer Type          : M2M
    Source Width           : 16 bits
    Destination Width      : 8 bits
    Source Burst Size      : 4 
    Destination Burst Size : 1
    Transfer Size          : 8
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000040);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000040);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000008;
  ControlData = SBURST8 | DBURST1 | SWIDTH16 | DWIDTH8 | SMASTER0 | DMASTER0 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module1");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2");
  Write(DMACTrMemEn1, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module2");
  Write(DMACTrMemData1, 0xC2000003); 
 
  msg_info("Channel0 Config Register");
  ConfigData = M2MDMAC | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);

  msg_info("TESTING FOR BACK TO BACK TRANSFERS INCR8 - SINGLE WITH LOCK SET");
  /*
    Program the following for INCR8 followed by SINGLE
    Channel No             : 0
    Flow Controller        : DMAC
    Transfer Type          : M2M
    Source Width           : 16 bits
    Destination Width      : 8 bits
    Source Burst Size      : 4 
    Destination Burst Size : 1
    Transfer Size          : 8
    Source Master          : Master0
    Destination Master     : Master0
    Source Incr Type       : Incrementing mode
    Destination Incr Type  : Incrementing mode
    Lock Transfer          : Enabled
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000040);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000040);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000008;
  ControlData = SBURST8 | DBURST1 | SWIDTH16 | DWIDTH8 | SMASTER0 | DMASTER0 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module1");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2");
  Write(DMACTrMemEn1, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module2");
  Write(DMACTrMemData1, 0xC2000003); 
 
  msg_info("Channel0 Config Register");
  ConfigData = M2MDMAC | LOCK | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);

  C("DMAC_MSTR_2 :TESTING FOR DEFAULT MASTER CASE");
  /* Corner Test Case1 :(Default Master Test Case)
     =============================================
    1) In this test The DMAC is made as the Default master, so that the master
       comes out with valid transactions with HBUSREQ before Arbiter sees the 
       Request. i.e NSEQ comes with assertion of HBUSREQ.
       The steps needed to carry out this test is given below.
       a) Poll for Channel0 Enabled bit to go low.
       b) Program Channel0 for M2M transfer with DMAC being the Flow Controller
          and with following parameters.
          Channel No             : 0
          Flow Controller        : DMAC
          Transfer Type          : M2M
          Source Width           : 32 bits
          Destination Width      : 32 bits
          Source Burst Size      : 1
          Destination Burst Size : 1
          Transfer Size          : 1
          Source Master          : Master0
          Destination Master     : Master0
          Source Incr Type       : Incrementing mode
          Destination Incr Type  : Incrementing mode
       c) Enable Channel0
       d) Wait for the Transactions to get over by Polling the Channel Enable
          Flag to go low.
       e) Re Program the channel for other combinations.
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000040);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000040);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000001;
  ControlData = SBURST1 | DBURST1 | SWIDTH32 | DWIDTH32 | SMASTER0 | DMASTER0 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module1");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2");
  Write(DMACTrMemEn1, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module2");
  Write(DMACTrMemData1, 0xC2000003); 
 
  msg_info("Channel0 Config Register");
  ConfigData = M2MDMAC | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);

  C("DMAC_MSTR_3 :TESTING FOR SPLIT/RETRY MASTER CASE");
  /* Corner Test Case2 :(Split/Retry Master Test Case)
     =================================================
    1) This test tests the master with Retry/Split response. Here the
       Split/Retry is given succesively for few times and then OK response is
       given so that same address gets retried repeatedly. Here This test is
       carried out with HGRANT toggling. The same test is carried out near 1KB
       boundhary so that the transaction proceeds smoothly.
       The steps needed to carry out this test is given below.
       a) Poll for Channel0 Enabled bit to go low.
       b) Program the Memory module to give consecutive 3 Retry's followed by OK
       c) Program the Source and Destination Register 1 Short of 1KB.
       d) Program the Grant Block to toggle the grant for every 2 HCLK.
       e) Program Channel0 for M2M transfer with DMAC being the Flow Controller
          and with following parameters.
          Channel No             : 0
          Flow Controller        : DMAC
          Transfer Type          : M2M
          Source Width           : 32 bits
          Destination Width      : 32 bits
          Source Burst Size      : 4
          Destination Burst Size : 4
          Transfer Size          : 8
          Source Master          : Master0
          Destination Master     : Master0
          Source Incr Type       : Incrementing mode
          Destination Incr Type  : Incrementing mode
       f) Enable Channel0
       g) Wait for the Transactions to get over by Polling the Channel Enable
          Flag to go low.
       h) Re Program the channel for other combinations.
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000FF8);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000FF8);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000008;
  ControlData = SBURST4 | DBURST4 | SWIDTH32 | DWIDTH32 | SMASTER0 | DMASTER0 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x800000C2);

  msg_info("Writing to Control reg1 of Memory Module1");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2");
  Write(DMACTrMemEn1, 0x800000C2);

  msg_info("Writing to Control reg1 of Memory Module2");
  Write(DMACTrMemData1, 0xC2000003); 

  msg_info("Writing to Grant Control Register");
  Write(DMACGRANTCNT0, 0x00000012); 
 
  msg_info("Channel0 Config Register");
  ConfigData = M2MDMAC | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);

  C("DMAC_MSTR_4 :TESTING FOR ERROR MASTER CASE");
  /* Corner Test Case4 :(Error Master Test Case)
     =================================================
    1) This test tests the master with Error  response.
       This test is carried out with HGRANT toggling. The Grant is toggled so 
       that it is not there when Error happens.
       The steps needed to carry out this test is given below.
       a) Poll for Channel0 Enabled bit to go low.
       b) Program the Memory module to give Error response
       c) Program the Source and Destination Register 1 Short of 1KB.
       d) Program the Grant Block to toggle the grant for every HCLK.
       e) Program Channel0 for M2M transfer with DMAC being the Flow Controller
          and with following parameters.
          Channel No             : 0
          Flow Controller        : DMAC
          Transfer Type          : M2M
          Source Width           : 32 bits
          Destination Width      : 32 bits
          Source Burst Size      : 4
          Destination Burst Size : 4
          Transfer Size          : 8
          Source Master          : Master0
          Destination Master     : Master0
          Source Incr Type       : Incrementing mode
          Destination Incr Type  : Incrementing mode
       f) Enable Channel0
       g) Wait for the Transactions to get over by Polling the Channel Enable
          Flag to go low.
       h) Re Program the channel for other combinations.
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000FF8);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000FF8);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000008;
  ControlData = SBURST4 | DBURST4 | SWIDTH32 | DWIDTH32 | SMASTER0 | DMASTER0 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000001);

  msg_info("Writing to Control reg1 of Memory Module1");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2");
  Write(DMACTrMemEn1, 0x80000001);

  msg_info("Writing to Control reg1 of Memory Module2");
  Write(DMACTrMemData1, 0xC2000003); 
 
  msg_info("Writing to Grant Control Register");
  Write(DMACGRANTCNT0, 0x00000011); 
 
  msg_info("Channel0 Config Register");
  ConfigData = M2MDMAC | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);

  C("DMAC_MSTR_5 :TESTING FOR 1KB BOUNDHARY WITHOUT GRANT TOGGLING");
  /* Corner Test Case4 :(Testing for 1KB boundary Case)
     ==================================================
    1) This test tests the master near burst boundhary case. These test ensures
       that there is no break in transactions i.e IDLE coming in middle because
       of 1KB. The steps needed to carry out this test is given below.
       a) Poll for Channel0 Enabled bit to go low.
       b) Program the Source and Destination Register near 1KB.
       c) Program Channel0 for M2M transfer with DMAC being the Flow Controller
          and with following parameters.
          Channel No             : 0
          Flow Controller        : DMAC
          Transfer Type          : M2M
          Source Width           : 32 bits
          Destination Width      : 16 bits
          Source Burst Size      : 4
          Destination Burst Size : 8
          Transfer Size          : 8
          Source Master          : Master0
          Destination Master     : Master0
          Source Incr Type       : Incrementing mode
          Destination Incr Type  : Incrementing mode
       f) Enable Channel0
       g) Wait for the Transactions to get over by Polling the Channel Enable
          Flag to go low.
       h) Re Program the channel for other combinations.
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000FFC);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000FFA);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000008;
  ControlData = SBURST4 | DBURST8 | SWIDTH32 | DWIDTH16 | SMASTER0 | DMASTER0 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module1");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2");
  Write(DMACTrMemEn1, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module2");
  Write(DMACTrMemData1, 0xC2000003); 

  msg_info("Writing to Grant Control Register");
  Write(DMACGRANTCNT0, 0x00000000); 
 
  msg_info("Channel0 Config Register");
  ConfigData = M2MDMAC | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);

  C("DMAC_MSTR_6 :TESTING FOR 1KB BOUNDHARY WITH GRANT TOGGLING MASTER CASE");
  /* Corner Test Case5 :(Testing for 1KB boundary Case)
     ==================================================
    1) This test tests the master near 1KB boundhary case. These test ensures
       that there is no break in transactions i.e IDLE coming in middle because
       of 1KB. The steps needed to carry out this test is given below.
       a) Poll for Channel0 Enabled bit to go low.
       b) Program the Source and Destination Register near 1KB.
       c) Program Channel0 for M2M transfer with DMAC being the Flow Controller
          and with following parameters.
          Channel No             : 0
          Flow Controller        : DMAC
          Transfer Type          : M2M
          Source Width           : 8 bits
          Destination Width      : 8 bits
          Source Burst Size      : 16
          Destination Burst Size : 16
          Transfer Size          : 32
          Source Master          : Master0
          Destination Master     : Master0
          Source Incr Type       : Incrementing mode
          Destination Incr Type  : Incrementing mode
       f) Enable Channel0
       g) Wait for the Transactions to get over by Polling the Channel Enable
          Flag to go low.
       h) Re Program the channel for other combinations.
  */

  msg_info("Source Address writing");
  Write(DMACC0SrcAddr, 0x08000FFC);
 
  msg_info("Destination Address writing");
  Write(DMACC0DestAddr, 0x10000FFA);
 
  msg_info("Channel0 Control register");
  TxrSize = 0x00000020;
  ControlData = SBURST16 | DBURST16 | SWIDTH8 | DWIDTH8 | SMASTER0 | DMASTER0 |
                SINCR | DINCR | pbc | INTTCDI | TxrSize;
  Write(DMACC0Control, ControlData);
 
  msg_info("Dma Req Config Register");
  Write(DMACREQCONFIG, 0x00000000);

  /* Enable Memory Module 1 */
  msg_info("Enabling Memory Module 1 ");
  Write(DMACTrMemEn0, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module1");
  Write(DMACTrMemData0, 0xC2000003);

  /* Enable Memory Module 2 */
  msg_info("Enabling Memory Module 2");
  Write(DMACTrMemEn1, 0x80000000);

  msg_info("Writing to Control reg1 of Memory Module2");
  Write(DMACTrMemData1, 0xC2000003); 

  msg_info("Writing to Grant Control Register");
  Write(DMACGRANTCNT0, 0x00000011); 
 
  msg_info("Channel0 Config Register");
  ConfigData = M2MDMAC | CHXENABLE;
  Write(DMACC0Config, ConfigData);
  WaitLoop(2);

  /* Polling for the activity of Channel 0 to go Low */
  Poll(DMACEnbldChns, 0x00000000, CH0ENABLED);

  Write(DMACTrMemEn0, MEMORYRESET);
  Write(DMACTrMemEn1, MEMORYRESET);

}

/************************************ End *************************************/
