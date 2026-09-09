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
-- File Name              : DmacRegisterTests.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           These test are for the integration test of the DMAC AHB Slave
--           ports. These do read-write of the registers in the DMAC.
--
-- --=========================================================================*/
 
/******************************************************************************/
/******************************** Register Tests ******************************/
/******************************************************************************/

void RegisterTests()
{
/* 
  Summary : RegisterTests
  =======================
  This test checks for the normal read and write operation of the DMA Controller
  registers. These tests are used toggle the Slave ports of the DMA Controller
  o The data pattern is made such that the every bit of the data is having
    the value 0 and 1 at least once.

*/

  int32 RegAddr;
  char *RegName;
  char *NextReg;
  int32 WriteData;
  int32 ExpData;
  int32 DataMask;
  char debugstr[100];
  int32 DataArray[] = {0x55555555, 0xAAAAAAAA};

  char DataSize[] = {DWRD, 'E'};

  /* char* TransType[] = {IDLE, BUSY, "END"};
    Currently busy transactions are not generated. */
  char* TransType[] = {IDLE, "END"};

  int32 *DataPattern = DataArray;
  char Size;
  char* Trans;
  int32 RandData[100];
  int i;
  int j;
  int k;
  

  C("Test No : DMA_REG_RW");

  /* First write the write pattern to all the registers.
     If a register happens to be a read only register, then the
     expected value is the read-only value and there is no masking of bits.
     If a register happens to be a write only register, then expect only
     zeros from the registers.
     If a register is read-write register, then the expected value is the
     write pattern AND mask pattern with no masking of bits during comparison.
  */

  do
  {
    WriteAllReg(*DataPattern);
    RegName = "DMACIntStat";
    RegAddr = strconst(RegName);
    while (RegName != "LASTREG")
    {
      /* sprintf(debugstr,"%X",RegAddr);
      C(debugstr); */
      if (IsReadOnly(RegAddr) == 1)
      {
       ExpData = strconst(stringcat("RDO_",RegName));
      }
      else if (IsWriteOnly(RegAddr) == 1)
      {
        ExpData = 0x00000000;
      }
      else
      {
        ExpData = strconst(stringcat("MASK_",RegName)) & (*DataPattern);
        if (RegName == "DMACConfig")
        {
          ExpData = ExpData & DMACDISABLE;
        }
        else if (RegName == "DMACTCR")
        {
          ExpData = ExpData & (~TESTMODE);
        }
        else if ((RegName == "DMACC0Config") || (RegName == "DMACC1Config") ||
                 (RegName == "DMACC2Config") || (RegName == "DMACC3Config") ||
                 (RegName == "DMACC4Config") || (RegName == "DMACC5Config") ||
                 (RegName == "DMACC6Config") || (RegName == "DMACC7Config"))
        {
          ExpData = ExpData & CHXDISABLE;
        }
      }

      HSA(RegAddr, NSEQ, SINGLE, OK, WRD, 0x0, 0x0, , 0x0, , , );
      HSR( , ExpData, , NoMask, ,DMA_REG_RW_1);
      RegName = NextRegisterName(RegName);
      RegAddr = strconst(RegName);
    }
    DataPattern++;
  }
  while (*DataPattern != 0x00000000);


  C("Test No : DMA_REG_RW_ERR");
  /* The Default TIC bus master operation when entering in the test
     mode is
     o 32 bit transfer width - HSIZE[1:0] signifies the WORD transfer
     o Previleged access - HPROT[3:0] signifies privileged data access
       uncacheble and unbufferable
   
    So to drive the illegal values on to the HSIZE ports of the Slave
    Interface of the DMAC we have to change the default value of the
    HSIZE through the control vector control command TCV.
    With the unsupported values of the HSIZE (i.e. Half-Word and Byte
    access) the DMA Controller returns the error respose to the TIC.
    
    This is done to get the toggle coverage of the HSIZE and HRESP ports
    of the DMA Controller Slave Interface

  */

  /* Changinfg the HSIZE information to BYTE wide transfers */
  TCV(DMAC_BASE, BYTE, 1, 0, 1);

  /* Changinfg the HSIZE information to Half-Word  wide transfers */
  TCV(DMAC_BASE, HWRD, 1, 0, 1);

  /* Reverting back to the default WORD transfer from the TIC 
     for the next read-write to/from the DMAC slave
     So as to able to program the DMA Controller registers
  */
  TCV(DMAC_BASE, WRD, 1, 0, 1);

}

/********************************* End *********************************/
