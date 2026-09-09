/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : WPErrorTest.c.rca
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform tests on external wait functionality of the
--           SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/************************ Write Protect Error Test ****************************/
/******************************************************************************/


void WPErrorTest()
{
  /*
     Summary: Cornercase 5
     =====================
     This function performs the following:

     First write HSIZE = MSIZE. Second write HSIZE < MEMSIZE (say 8 and 32) and 
     a) address is such that it is the first byte in the 32-bits. Follow this 
        sequence with SEQ writes
     b) address is last access in the 32 bits. Follow the second write with a read. 

  */

  int HSize = 0;
  int Address;
  const WPERRBIT = 0x2;
  char HSizeStr[3] = {'b', 'h', 'w'};
  char PrntStr[120];
  int Mask0[3] = {0xFF, 0xFFFF, 0xFFFFFFFF};
  int Mask1[3] = {0xFF00, 0xFFFF0000, 0xFFFFFFFF};
  int Shift[3] = {8, 16, 0};

  C("Configuring the SMC and the Memory banks.");
  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** ExtWait Enabled = 0x85, 0x142, disabled = 0x81, 0x42 WaitPol = 0 **/
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0xF, 0xF, 0x02, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x02, 0xF, 0xF, 0x42, SMCTrMEMBData[0], 0x02,
                  0x00, 0x000000);

  /** Set Bank 1 Memory Type as SRAM (16 bits width) **/
  /** ExtWait Enabled = 0x15, disabled = 0x11 WaitPol = 0 **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x00, 0x0, 0x0, 0x00, 0x00, 0x00000041, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x00, 0x0, 0x0, 0x41, SMCTrMEMBData[1], 0x00,
                  0x00, 0x000000);

  /** Set Bank 2 Memory Type as SRAM (8 bits width) **/
  /** ExtWait Enabled = 0x05, disabled = 0x01 WaitPol = 0 **/
  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x04, 0xD, 0xD, 0x02, 0x00, 0x00000001, 0x000000,
               0x000000);
  ConfigureMemory(2, 0x04, 0xD, 0xD, 0x40, SMCTrMEMBData[2], 0x02,
                  0x00, 0x000000);

  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** ExtWait Enabled = 0x85, disabled = 0x81 WaitPol = 0 **/
  /** WP set UUT 0x91 , TR 0x46*/
  SMCTrMEMBData[7] = 0x00000000;
  ConfigureUUT(7, 0x05, 0xF, 0xD, 0x02, 0x00, 0x00000091, 0x000000,
               0x000000);
  ConfigureMemory(7, 0x05, 0xF, 0xD, 0x46, SMCTrMEMBData[7], 0x02,
                  0x00, 0x000000);


  for(HSize=0; HSize<3; HSize++)
  {
    sprintf(PrntStr, "NSEQ Write Transfers : Writing with HSize = %d", HSize); 
    C(PrntStr);
  /* General write to 32 bit memory*/
    Address = SMCMEM_0 + 0x20;
    HSA(Address, NSEQ, INCR, OK, HSizeStr[HSize]);
    HSW( , 0x54819036);
    HSW( , 0x54819037);
  /* Write to write protected memory */
    Address = SMCMEM_7 + 0x10;
    HSA(Address, NSEQ, SINGLE, ERROR, HSizeStr[HSize]);
    HSW( , 0x54819036, ,WPError_0);
  /* Check if write protect error bit is set */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSR( , WPERRBIT, , WPERRBIT);
  /* Clear write protect error bit */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSW( , WPERRBIT);

  /* General Read from 32 bit memory*/
    Address = SMCMEM_0 + 0x20;
    HSA(Address, NSEQ, INCR, OK, HSizeStr[HSize]);
    HSR( , 0x54819036, , Mask0[HSize]);
    HSR( , 0x54819037 << Shift[HSize], , Mask1[HSize]);
  /* Write to write protected memory */
    Address = SMCMEM_7 + 0x10;
    HSA(Address, NSEQ, SINGLE, ERROR, HSizeStr[HSize]);
    HSW( , 0x54819036, ,WPError_0);
  /* Check if write protect error bit is set */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSR( , WPERRBIT, , WPERRBIT);
  /* Clear write protect error bit */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSW( , WPERRBIT);

  /* General write to 16 bit memory*/
    Address = SMCMEM_1 + 0x20;
    HSA(Address, NSEQ, INCR, OK, HSizeStr[HSize]);
    HSW( , 0x348729DF);
    HSW( , 0x348729E0);
  /* Write to write protected memory */
    Address = SMCMEM_7 + 0x20;
    HSA(Address, NSEQ, SINGLE, ERROR, HSizeStr[HSize]);
    HSW( , 0xAAABBBDD, ,WPError_1);
  /* Check if write protect error bit is set */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSR( , WPERRBIT, , WPERRBIT);
  /* Clear write protect error bit */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSW( , WPERRBIT);
  /* General read from 16 bit memory*/
    Address = SMCMEM_1 + 0x20;
    HSA(Address, NSEQ, INCR, OK, HSizeStr[HSize]);
    HSR( , 0x348729DF, , Mask0[HSize]);
    HSR( , 0x348729E0 << Shift[HSize], , Mask1[HSize]);
  /* Write to write protected memory */
    Address = SMCMEM_7 + 0x20;
    HSA(Address, NSEQ, SINGLE, ERROR, HSizeStr[HSize]);
    HSW( , 0xAAABBBDD, ,WPError_1);
  /* Check if write protect error bit is set */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSR( , WPERRBIT, , WPERRBIT);
  /* Clear write protect error bit */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSW( , WPERRBIT);

  /* General write to 8 bit memory*/
    Address = SMCMEM_2 + 0x20;
    HSA(Address, NSEQ, INCR, OK, HSizeStr[HSize]);
    HSW( , 0x9682CFEE);
    HSW( , 0x9682CFEF);
  /* Write to write protected memory */
    Address = SMCMEM_7 + 0x30;
    HSA(Address, NSEQ, SINGLE, ERROR, HSizeStr[HSize]);
    HSW( , 0x55555555, ,WPError_2);
  /* Check if write protect error bit is set */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSR( , WPERRBIT, , WPERRBIT);
  /* Clear write protect error bit */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSW( , WPERRBIT);
  /* General read to 8 bit memory*/
    Address = SMCMEM_2 + 0x20;
    HSA(Address, NSEQ, INCR, OK, HSizeStr[HSize]);
    HSR( , 0x9682CFEE, , Mask0[HSize]);
    HSR( , 0x9682CFEF << Shift[HSize], , Mask1[HSize]);
  /* Write to write protected memory */
    Address = SMCMEM_7 + 0x30;
    HSA(Address, NSEQ, SINGLE, ERROR, HSizeStr[HSize]);
    HSW( , 0x55555555, ,WPError_2);
  /* Check if write protect error bit is set */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSR( , WPERRBIT, , WPERRBIT);
  /* Clear write protect error bit */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSW( , WPERRBIT);
  }


/* For Write to Write protected memory with HTRANS=IDLE */
  for(HSize=0; HSize<3; HSize++)
  {
    sprintf(PrntStr, "IDLE Write Transfers : Writing with HSize = %d", HSize); 
    C(PrntStr);
  /* General write to 32 bit memory*/
    Address = SMCMEM_0 + 0x20;
    HSA(Address, NSEQ, INCR, OK, HSizeStr[HSize]);
    HSW( , 0x54819036);
    HSW( , 0x54819037);
  /* Write to write protected memory */
    Address = SMCMEM_7 + 0x40;
    HSA(Address, IDLE, SINGLE, OK, HSizeStr[HSize]);
    HSW( , 0x54819036, ,WPError_4);
  /* Check if write protect error bit is set */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSR( , 0x0, , WPERRBIT, ,WPError_3);
  /* Clear write protect error bit */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSW( , WPERRBIT);
  /* General read to 32 bit memory*/
    Address = SMCMEM_0 + 0x20;
    HSA(Address, NSEQ, INCR, OK, HSizeStr[HSize]);
    HSR( , 0x54819036, , Mask0[HSize]);
    HSR( , 0x54819037 << Shift[HSize], , Mask1[HSize]);
  /* Write to write protected memory */
    Address = SMCMEM_7 + 0x40;
    HSA(Address, IDLE, SINGLE, OK, HSizeStr[HSize]);
    HSW( , 0x54819036, ,WPError_4);
  /* Check if write protect error bit is set */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSR( , 0x0, , WPERRBIT, ,WPError_3);
  /* Clear write protect error bit */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSW( , WPERRBIT);


  /* General write to 16 bit memory*/
    Address = SMCMEM_1 + 0x20;
    HSA(Address, NSEQ, INCR, OK, HSizeStr[HSize]);
    HSW( , 0x348729DF);
    HSW( , 0x348729E0);
  /* Write to write protected memory */
    Address = SMCMEM_7 + 0x50;
    HSA(Address, IDLE, SINGLE, OK, HSizeStr[HSize]);
    HSW( , 0xAAABBBDD, ,WPError_5);
  /* Check if write protect error bit is set */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSR( , 0x0, , WPERRBIT);
  /* Clear write protect error bit */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSW( , WPERRBIT);
  /* General read to 16 bit memory*/
    Address = SMCMEM_1 + 0x20;
    HSA(Address, NSEQ, INCR, OK, HSizeStr[HSize]);
    HSR( , 0x348729DF, , Mask0[HSize]);
    HSR( , 0x348729E0 << Shift[HSize], , Mask1[HSize]);
  /* Write to write protected memory */
    Address = SMCMEM_7 + 0x50;
    HSA(Address, IDLE, SINGLE, OK, HSizeStr[HSize]);
    HSW( , 0xAAABBBDD, ,WPError_5);
  /* Check if write protect error bit is set */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSR( , 0x0, , WPERRBIT);
  /* Clear write protect error bit */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSW( , WPERRBIT);

  /* General write to 8 bit memory*/
    Address = SMCMEM_2 + 0x20;
    HSA(Address, NSEQ, INCR, OK, HSizeStr[HSize]);
    HSW( , 0x9682CFEE);
    HSW( , 0x9682CFEF);
  /* Write to write protected memory */
    Address = SMCMEM_7 + 0x60;
    HSA(Address, IDLE, SINGLE, OK, HSizeStr[HSize]);
    HSW( , 0x55555555, ,WPError_6);
  /* Check if write protect error bit is set */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSR( , 0x0, , WPERRBIT);
  /* Clear write protect error bit */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSW( , WPERRBIT);
  /* General read to 8 bit memory*/
    Address = SMCMEM_2 + 0x20;
    HSA(Address, NSEQ, INCR, OK, HSizeStr[HSize]);
    HSR( , 0x9682CFEE, , Mask0[HSize]);
    HSR( , 0x9682CFEF << Shift[HSize], , Mask1[HSize]);
  /* Write to write protected memory */
    Address = SMCMEM_7 + 0x60;
    HSA(Address, IDLE, SINGLE, OK, HSizeStr[HSize]);
    HSW( , 0x55555555, ,WPError_6);
  /* Check if write protect error bit is set */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSR( , 0x0, , WPERRBIT);
  /* Clear write protect error bit */
    HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
    HSW( , WPERRBIT);
  }

/* Make bank1 burst ROM and read from it */
/* Bank 1 - BM, RBLE, WP, 16 bit */
  HSA(SMBCR1, NSEQ, SINGLE, OK, WRD);
  HSW(, 0x71);
  HSA(SMCTrMEMT_1, NSEQ, INCR, OK, WRD);
  HSW(, 0x4D);
/* And Write to Write protected memory with HTRANS=IDLE */
  sprintf(PrntStr, "Burst read - WP NSEQ Write Transfers : 
            Writing with HSize = 0, 1, 2"); 
  C(PrntStr);

  /* Burst read to 16 bit memory HSize = 8*/
  Address = SMCMEM_1 + 0x20;
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSR( , 0xDF, , Mask0[0]);
  HSR( , 0x2900, , Mask1[0]);
  /* Write to write protected memory */
  Address = SMCMEM_7 + 0x50;
  HSA(Address, NSEQ, SINGLE, ERROR, BYTE);
  HSW( , 0xAAABBBDD, ,WPError_10);
  /* Check if write protect error bit is set */
  HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
  HSR( , WPERRBIT, , WPERRBIT);
  /* Clear write protect error bit */
  HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
  HSW( , WPERRBIT);

  /* Burst read to 16 bit memory HSize = 16 */
  Address = SMCMEM_1 + 0x20;
  HSA(Address, NSEQ, INCR4, OK, HWRD);
  HSR( , 0x29DF, , Mask0[1]);
  HSR( , 0x34870000, , Mask1[1]);
  /* Write to write protected memory */
  Address = SMCMEM_7 + 0x50;
  HSA(Address, NSEQ, SINGLE, ERROR, HWRD);
  HSW( , 0xAAABBBDD, ,WPError_11);
  /* Check if write protect error bit is set */
  HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
  HSR( , WPERRBIT, , WPERRBIT);
  /* Clear write protect error bit */
  HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
  HSW( , WPERRBIT);

  /* Burst read to 16 bit memory HSize = 32 */
  Address = SMCMEM_1 + 0x20;
  HSA(Address, NSEQ, INCR4, OK, WRD);
  HSR( , 0x348729DF, , Mask0[2]);
  HSR( , 0x348729E0, , Mask1[2]);
  /* Write to write protected memory */
  Address = SMCMEM_7 + 0x50;
  HSA(Address, NSEQ, SINGLE, ERROR, WRD);
  HSW( , 0xAAABBBDD, ,WPError_12);
  /* Check if write protect error bit is set */
  HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
  HSR( , WPERRBIT, , WPERRBIT);
  /* Clear write protect error bit */
  HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
  HSW( , WPERRBIT);

/* WP Idle write after burst read */
  sprintf(PrntStr, "Burst read - WP IDLE Write Transfers : 
            Writing with HSize = 0, 1, 2"); 
  C(PrntStr);

  /* Burst read to 16 bit memory HSize = 8*/
  Address = SMCMEM_1 + 0x20;
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSR( , 0xDF, , Mask0[0]);
  HSR( , 0x2900, , Mask1[0]);
  /* Write to write protected memory */
  Address = SMCMEM_7 + 0x50;
  HSA(Address, IDLE, SINGLE, OK, BYTE);
  HSW( , 0xAAABBBDD, ,WPError_10);
  /* Check if write protect error bit is set */
  HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
  HSR( , 0x0, , WPERRBIT);
  /* Clear write protect error bit */
  HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
  HSW( , WPERRBIT);

  /* Burst read to 16 bit memory HSize = 16*/
  Address = SMCMEM_1 + 0x20;
  HSA(Address, NSEQ, INCR4, OK, HWRD);
  HSR( , 0x29DF, , Mask0[1]);
  HSR( , 0x34870000, , Mask1[1]);
  /* Write to write protected memory */
  Address = SMCMEM_7 + 0x50;
  HSA(Address, IDLE, SINGLE, OK, HWRD);
  HSW( , 0xAAABBBDD, ,WPError_11);
  /* Check if write protect error bit is set */
  HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
  HSR( , 0x0, , WPERRBIT);
  /* Clear write protect error bit */
  HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
  HSW( , WPERRBIT);

  /* Burst read to 16 bit memory HSize = 32*/
  Address = SMCMEM_1 + 0x20;
  HSA(Address, NSEQ, INCR4, OK, WRD);
  HSR( , 0x348729DF, , Mask0[2]);
  HSR( , 0x348729E0, , Mask1[2]);
  /* Write to write protected memory */
  Address = SMCMEM_7 + 0x50;
  HSA(Address, IDLE, SINGLE, OK, WRD);
  HSW( , 0xAAABBBDD, ,WPError_12);
  /* Check if write protect error bit is set */
  HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
  HSR( , 0x0, , WPERRBIT);
  /* Clear write protect error bit */
  HSA(SMBSR7, NSEQ, SINGLE, OK, WRD);
  HSW( , WPERRBIT);
}
/************************************ End *************************************/
