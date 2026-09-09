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
-- File Name              : ClkEnableTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This program verifies the Clock Enable(CE) bit of MPMCDyCntl
--
--           TEST ID : MPMC_ClkEn_1
--
-- --=======================================================================--*/
/******************************************************************************/
/***************************** Clock Enable Test ******************************/
/******************************************************************************/
void ClkEnableTest(void)
{
  /*
    Summary: ClkEnable
    ==================
    This test verifies the following functionalities :

    o Write CS = 0 and CE = 0. Write valid data . Trickbox checks MPMCCKEOUT
      according to the value programmed to its register.
    
    o Write CS = 1 and CE = 0. Trickbox checks MPMCCKEOUT according to the
      value programmed to its register. 
  */
  int chip, bank, AddrMap, Row, Col,BankSel;
  unsigned long Address;
  char debugstr[100];
  WriteData(MPMCControl, 0x00000001, "WRD");

  C("Initialize SDRAMs");
  TimingInit(2,5,8,0,5,5,0,7,7,0,2,3);
  SyncInitializeProc(3, 0, 2, 2, 0, 0,
                     2, 0, 2, 1, 0, 0,
                     3, 0, 2, 1, 0, 0,
                     3, 0, 2, 1, 0, 0,
                     0,1,3,0,0,1,1,0,3,1,2,
                     0,2,2,0,1,1,1,0,2,1,1,
                     0,1,0,0,0,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,1,
                     12,12,10,11,
                     0,
                     0);
  C("Deassert Clock enable and Clock control");
  /* Write CS = 0 and CE = 0 */
  C("TEST ID : MPMC_ClkEn_1");
  WriteData(MPMCDyCntl, 0x00000000, "WRD");
  /* Generate a random address and align it with a QW address */
  for(chip = 4; chip < 8; chip++)
  {
     Address = rand() & 0x0FFFFFFC;
     Address = Address | chip << 28;
     sprintf(debugstr,"0x03030303 has been written to address %X",Address);
     debug_info(debugstr);
     WriteData(Address, 0x03030303, "WRD");
  }
  WaitLoop(0x10); 

  /* Wait till buffer gets flushed */
  debug_info("Poll for the buffer to be flushed");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , , );
  HPO(,0x00000000, , 0x00000010);
  ReadData(Address, 0x03030303,MaskALL, "WRD");
  WaitLoop(0x20);
  /* Write CS = 1 CE = 0 */ 

  C("TEST ID : MPMC_ClkEn_2");
  C("Assert clock control and deassert clock enable");

  WriteData(MPMCDyCntl, 0x00000002, "WRD");
  for(chip = 4; chip < 8; chip++)
  {
    /* Generate a random address and align it with a QW address */
    Address = rand() & 0x0FFFFFFC;
    Address = Address | chip << 28;
    sprintf(debugstr,"Data 0x07070707 written to address %X",Address);
    debug_info(debugstr);
    WriteData(Address, 0x07070707, "WRD");
  }
  /* Wait till buffer gets flushed */
  WaitLoop(0x10);

  MPMCDisable();
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , , );
  HPO(,0x00000000, , 0x00000010);
  MPMCEnable();

  ReadData(Address, 0x07070707, 0xFFFFFFFF, "WRD");
  /* Write CE = 1 and CS = 1 */

  C("Assert clock enable and clock control");
  WriteData(MPMCDyCntl, 0x00000003, "WRD");
  WaitLoop(0x3);  
  chip = 4;
  /* Generate a random address and align it with a QW address */
  Address = rand() & 0x0FFFFFFC;
  Address = Address | chip << 28;

  sprintf(debugstr,"Data 0x05050505 written to address %X",Address);
  debug_info(debugstr);

  WriteData(Address, 0x05050505, "WRD");

  /* Wait till buffer gets flushed */
  WaitLoop(0x3);
  debug_info("Wait till buffer gets flushed");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , , );
  HPO(,0x00000000, , 0x00000010);
  WaitLoop(0x30);
  ReadData(Address, 0x05050505,MaskALL, "WRD");
}
/*-- --================================ End ================================--*/
