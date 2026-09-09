/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : SsmcEndianTests.c.rca
--  File Revision          : 1.8
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform different types of Asynchronous transfers.
--
-- --=========================================================================*/

/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                                      Located in          ***/
/*** ---------------------------------------------------------------------- ***/
/*** ConfigureMemory                                    SsmcCommon.c        ***/
/*** ConfigureUUT                                       SsmcCommon.c        ***/
/*** SingleWriteRead                                    SsmcCommon.c        ***/
/*** BurstWriteRead                                     SsmcCommon.c        ***/
/******************************************************************************/

/******************************************************************************/
/***************************** SsmcEndianTests ********************************/
/******************************************************************************/

void SsmcEndianTests()
{
    /*
     Summary: Endianness Tests
     =========================
     This function performs the following:

     o  Does the following sequence of tests for Little and Big Endian mode
        of operation:
        - Memory configured as 32 bits. Transactions are initiated from the
          AHB with different HSIZE and HBURST values. The written data patterns
          are read back from Memory via both the AHB interface of the TrickMem
          and the SSMC.
        - Memory configured as 16 bits. Transactions are initiated from the
          AHB with different HSIZE and HBURST values. The written data patterns
          are read back from Memory via both the AHB interface of the TrickMem
          and the SSMC.
        - Memory configured as 8 bits. Transactions are initiated from the
          AHB with different HSIZE and HBURST values. The written data patterns
          are read back from Memory via both the AHB interface of the TrickMem
          and the SSMC.
  */

   char report[100];

  struct parameters {
    int   BANKNO;
    int   HSIZE;
    int   MSIZE;
    int   BURSTLENRD;
    int   BURSTLENWR;
    int   ENDIAN; 
    int   HBURST;
    int   RBLE;
  };

  struct caselist {
    char *CaseNumber;
    struct parameters *TestParams;
  };

  int Hsize, Msize;
  int32 BCRData, MemAddr1, TestData, WTCNCLData, ExtMuxData, SMBLSPOLData;

  struct parameters *SsmcEndianessParams ;

  /* 
     The parameters corresponds to the list of configurations defined for
     Test number "SsmcEndianTests" in the block verification document.
     The BANKNO value as '9' indicates the end of the
     configurations, as in the last element of the parameters' list.       
  */

   struct parameters B0SmallEndianCases[80] = {
        0, 8, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
        0, 8, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
        0, 8, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
        0, 8, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
        0, 8, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
        0, 8, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
        0, 8, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
        0, 8, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

        0, 16, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
        0, 16, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
        0, 16, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
        0, 16, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
        0, 16, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
        0, 16, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
        0, 16, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
        0, 16, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

        0, 32, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
        0, 32, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
        0, 32, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
        0, 32, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
        0, 32, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
        0, 32, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
        0, 32, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
        0, 32, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

        0, 8, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
        0, 8, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
        0, 8, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
        0, 8, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
        0, 8, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
        0, 8, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
        0, 8, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
        0, 8, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

        0, 16, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
        0, 16, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
        0, 16, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
        0, 16, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
        0, 16, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
        0, 16, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
        0, 16, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
        0, 16, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

        0, 32, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
        0, 32, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
        0, 32, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
        0, 32, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
        0, 32, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
        0, 32, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
        0, 32, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
        0, 32, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

        0, 8, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
 	0, 8, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
	0, 8, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
	0, 8, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
	0, 8, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
	0, 8, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
	0, 8, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
	0, 8, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

        0, 16, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
        0, 16, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
        0, 16, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
        0, 16, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
        0, 16, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
        0, 16, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
        0, 16, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
        0, 16, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

        0, 32, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
        0, 32, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
        0, 32, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
        0, 32, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
        0, 32, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
        0, 32, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
        0, 32, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
	0, 32, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

        9, 32, MW32, BLENRD8, BLENWR8,   big, WRP16, RBLE_1};

   struct parameters B0BigEndianCases[80] = {
        0, 8, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
        0, 8, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
        0, 8, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
        0, 8, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
        0, 8, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
        0, 8, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
        0, 8, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
        0, 8, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

        0, 16, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
        0, 16, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
        0, 16, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
        0, 16, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
        0, 16, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
        0, 16, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
        0, 16, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
        0, 16, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

        0, 32, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
        0, 32, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
        0, 32, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
        0, 32, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
        0, 32, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
        0, 32, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
        0, 32, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
        0, 32, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

        0, 8, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
        0, 8, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
        0, 8, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
        0, 8, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
        0, 8, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
        0, 8, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
        0, 8, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
        0, 8, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

        0, 16, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
        0, 16, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
        0, 16, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
        0, 16, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
        0, 16, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
        0, 16, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
        0, 16, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
        0, 16, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

        0, 32, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
        0, 32, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
        0, 32, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
        0, 32, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
        0, 32, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
        0, 32, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
        0, 32, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
        0, 32, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

        0, 8, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
        0, 8, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
        0, 8, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
        0, 8, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
        0, 8, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
        0, 8, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
        0, 8, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
        0, 8, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

        0, 16, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
        0, 16, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
        0, 16, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
        0, 16, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
        0, 16, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
        0, 16, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
        0, 16, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
        0, 16, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

        0, 32, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
        0, 32, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
        0, 32, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
        0, 32, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
        0, 32, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
        0, 32, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
        0, 32, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
        0, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,
        9, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1};


  struct parameters B1SmallEndianCases[80] = {
        1, 8, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
        1, 8, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
        1, 8, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
        1, 8, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
        1, 8, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
        1, 8, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
        1, 8, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
        1, 8, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

        1, 16, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
        1, 16, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
        1, 16, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
        1, 16, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
        1, 16, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
        1, 16, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
        1, 16, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
        1, 16, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

        1, 32, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
        1, 32, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
        1, 32, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
        1, 32, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
        1, 32, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
        1, 32, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
        1, 32, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
        1, 32, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

        1, 8, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
        1, 8, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
        1, 8, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
        1, 8, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
        1, 8, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
        1, 8, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
        1, 8, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
        1, 8, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       1, 16, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       1, 16, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       1, 16, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       1, 16, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       1, 16, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       1, 16, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       1, 16, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       1, 16, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       1, 32, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       1, 32, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       1, 32, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       1, 32, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       1, 32, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       1, 32, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       1, 32, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       1, 32, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       1, 8, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       1, 8, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       1, 8, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       1, 8, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       1, 8, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       1, 8, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       1, 8, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       1, 8, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       1, 16, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       1, 16, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       1, 16, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       1, 16, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       1, 16, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       1, 16, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       1, 16, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       1, 16, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       1, 32, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       1, 32, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       1, 32, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       1, 32, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       1, 32, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       1, 32, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       1, 32, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       1, 32, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       9, 32, MW32, BLENRD8, BLENWR8, small, WRP16, RBLE_1};

  struct parameters B1BigEndianCases[80] = {
       1, 8, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       1, 8, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       1, 8, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       1, 8, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       1, 8, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       1, 8, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       1, 8, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       1, 8, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       1, 16, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       1, 16, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       1, 16, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       1, 16, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       1, 16, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       1, 16, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       1, 16, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       1, 16, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       1, 32, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       1, 32, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       1, 32, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       1, 32, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       1, 32, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       1, 32, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       1, 32, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       1, 32, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       1, 8, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       1, 8, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       1, 8, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       1, 8, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       1, 8, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       1, 8, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       1, 8, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       1, 8, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       1, 16, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       1, 16, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       1, 16, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       1, 16, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       1, 16, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       1, 16, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       1, 16, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       1, 16, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       1, 32, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       1, 32, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       1, 32, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       1, 32, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       1, 32, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       1, 32, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       1, 32, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       1, 32, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       1, 8, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       1, 8, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       1, 8, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       1, 8, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       1, 8, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       1, 8, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       1, 8, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       1, 8, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       1, 16, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       1, 16, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       1, 16, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       1, 16, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       1, 16, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       1, 16, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       1, 16, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       1, 16, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       1, 32, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       1, 32, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       1, 32, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       1, 32, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       1, 32, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       1, 32, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       1, 32, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       1, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,
       9, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1};


  struct parameters B2SmallEndianCases[80] = {
       2, 8, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       2, 8, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       2, 8, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       2, 8, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       2, 8, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       2, 8, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       2, 8, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       2, 8, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

       2, 16, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       2, 16, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       2, 16, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       2, 16, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       2, 16, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       2, 16, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       2, 16, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       2, 16, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

       2, 32, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       2, 32, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       2, 32, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       2, 32, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       2, 32, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       2, 32, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       2, 32, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       2, 32, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

       2, 8, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       2, 8, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       2, 8, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       2, 8, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       2, 8, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       2, 8, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       2, 8, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       2, 8, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       2, 16, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       2, 16, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       2, 16, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       2, 16, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       2, 16, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       2, 16, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       2, 16, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       2, 16, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       2, 32, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       2, 32, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       2, 32, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       2, 32, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       2, 32, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       2, 32, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       2, 32, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       2, 32, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       2, 8, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       2, 8, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       2, 8, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       2, 8, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       2, 8, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       2, 8, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       2, 8, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       2, 8, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       2, 16, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       2, 16, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       2, 16, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       2, 16, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       2, 16, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       2, 16, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       2, 16, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       2, 16, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       2, 32, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       2, 32, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       2, 32, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       2, 32, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       2, 32, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       2, 32, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       2, 32, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       2, 32, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,
       9, 32, MW32, BLENRD8, BLENWR8,   big, WRP16, RBLE_1};

  struct parameters B2BigEndianCases[80] = {
       2, 8, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       2, 8, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       2, 8, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       2, 8, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       2, 8, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       2, 8, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       2, 8, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       2, 8, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       2, 16, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       2, 16, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       2, 16, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       2, 16, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       2, 16, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       2, 16, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       2, 16, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       2, 16, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       2, 32, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       2, 32, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       2, 32, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       2, 32, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       2, 32, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       2, 32, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       2, 32, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       2, 32, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       2, 8, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       2, 8, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       2, 8, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       2, 8, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       2, 8, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       2, 8, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       2, 8, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       2, 8, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       2, 16, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       2, 16, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       2, 16, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       2, 16, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       2, 16, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       2, 16, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       2, 16, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       2, 16, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       2, 32, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       2, 32, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       2, 32, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       2, 32, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       2, 32, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       2, 32, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       2, 32, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       2, 32, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       2, 8, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       2, 8, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       2, 8, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       2, 8, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       2, 8, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       2, 8, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       2, 8, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       2, 8, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       2, 16, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       2, 16, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       2, 16, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       2, 16, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       2, 16, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       2, 16, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       2, 16, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       2, 16, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       2, 32, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       2, 32, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       2, 32, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       2, 32, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       2, 32, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       2, 32, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       2, 32, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       2, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,
       9, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1};


  struct parameters B3SmallEndianCases[80] = {
       3, 8, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       3, 8, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       3, 8, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       3, 8, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       3, 8, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       3, 8, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       3, 8, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       3, 8, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

       3, 16, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       3, 16, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       3, 16, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       3, 16, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       3, 16, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       3, 16, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       3, 16, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       3, 16, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

       3, 32, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       3, 32, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       3, 32, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       3, 32, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       3, 32, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       3, 32, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       3, 32, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       3, 32, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

       3, 8, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       3, 8, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       3, 8, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       3, 8, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       3, 8, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       3, 8, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       3, 8, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       3, 8, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       3, 16, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       3, 16, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       3, 16, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       3, 16, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       3, 16, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       3, 16, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       3, 16, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       3, 16, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       3, 32, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       3, 32, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       3, 32, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       3, 32, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       3, 32, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       3, 32, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       3, 32, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       3, 32, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,



       3, 8, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       3, 8, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       3, 8, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       3, 8, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       3, 8, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       3, 8, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       3, 8, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       3, 8, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       3, 16, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       3, 16, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       3, 16, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       3, 16, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       3, 16, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       3, 16, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       3, 16, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       3, 16, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       3, 32, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       3, 32, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       3, 32, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       3, 32, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       3, 32, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       3, 32, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       3, 32, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       3, 32, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,
       9, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1};

  struct parameters B3BigEndianCases[80] = {
       3, 8, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       3, 8, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       3, 8, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       3, 8, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       3, 8, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       3, 8, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       3, 8, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       3, 8, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       3, 16, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       3, 16, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       3, 16, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       3, 16, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       3, 16, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       3, 16, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       3, 16, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       3, 16, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       3, 32, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       3, 32, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       3, 32, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       3, 32, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       3, 32, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       3, 32, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       3, 32, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       3, 32, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       3, 8, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       3, 8, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       3, 8, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       3, 8, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       3, 8, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       3, 8, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       3, 8, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       3, 8, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       3, 16, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       3, 16, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       3, 16, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       3, 16, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       3, 16, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       3, 16, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       3, 16, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       3, 16, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       3, 32, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       3, 32, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       3, 32, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       3, 32, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       3, 32, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       3, 32, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       3, 32, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       3, 32, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       3, 8, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       3, 8, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       3, 8, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       3, 8, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       3, 8, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       3, 8, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       3, 8, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       3, 8, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       3, 16, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       3, 16, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       3, 16, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       3, 16, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       3, 16, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       3, 16, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       3, 16, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       3, 16, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       3, 32, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       3, 32, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       3, 32, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       3, 32, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       3, 32, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       3, 32, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       3, 32, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       3, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,
       9, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1};


  struct parameters B4SmallEndianCases[80] = {
       4, 8, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       4, 8, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       4, 8, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       4, 8, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       4, 8, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       4, 8, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       4, 8, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       4, 8, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

       4, 16, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       4, 16, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       4, 16, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       4, 16, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       4, 16, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       4, 16, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       4, 16, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       4, 16, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

       4, 32, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       4, 32, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       4, 32, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       4, 32, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       4, 32, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       4, 32, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       4, 32, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       4, 32, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,


       4, 8, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       4, 8, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       4, 8, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       4, 8, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       4, 8, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       4, 8, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       4, 8, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       4, 8, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       4, 16, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       4, 16, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       4, 16, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       4, 16, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       4, 16, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       4, 16, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       4, 16, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       4, 16, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       4, 32, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       4, 32, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       4, 32, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       4, 32, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       4, 32, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       4, 32, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       4, 32, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       4, 32, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,


       4, 8, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       4, 8, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       4, 8, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       4, 8, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       4, 8, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       4, 8, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       4, 8, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       4, 8, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       4, 16, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       4, 16, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       4, 16, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       4, 16, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       4, 16, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       4, 16, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       4, 16, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       4, 16, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       4, 32, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       4, 32, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       4, 32, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       4, 32, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       4, 32, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       4, 32, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       4, 32, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       4, 32, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,
       9, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1};

  struct parameters B4BigEndianCases[80] = {
       4, 8, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       4, 8, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       4, 8, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       4, 8, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       4, 8, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       4, 8, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       4, 8, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       4, 8, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       4, 16, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       4, 16, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       4, 16, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       4, 16, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       4, 16, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       4, 16, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       4, 16, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       4, 16, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       4, 32, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       4, 32, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       4, 32, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       4, 32, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       4, 32, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       4, 32, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       4, 32, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       4, 32, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       4, 8, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       4, 8, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       4, 8, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       4, 8, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       4, 8, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       4, 8, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       4, 8, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       4, 8, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       4, 16, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       4, 16, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       4, 16, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       4, 16, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       4, 16, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       4, 16, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       4, 16, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       4, 16, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       4, 32, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       4, 32, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       4, 32, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       4, 32, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       4, 32, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       4, 32, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       4, 32, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       4, 32, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       4, 8, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       4, 8, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       4, 8, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       4, 8, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       4, 8, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       4, 8, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       4, 8, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       4, 8, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       4, 16, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       4, 16, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       4, 16, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       4, 16, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       4, 16, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       4, 16, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       4, 16, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       4, 16, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       4, 32, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       4, 32, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       4, 32, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       4, 32, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       4, 32, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       4, 32, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       4, 32, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       4, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,
       9, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1};


  struct parameters B5SmallEndianCases[80] = {
       5, 8, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       5, 8, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       5, 8, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       5, 8, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       5, 8, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       5, 8, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       5, 8, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       5, 8, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

       5, 16, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       5, 16, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       5, 16, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       5, 16, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       5, 16, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       5, 16, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       5, 16, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       5, 16, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

       5, 32, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       5, 32, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       5, 32, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       5, 32, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       5, 32, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       5, 32, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       5, 32, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       5, 32, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

       5, 8, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       5, 8, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       5, 8, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       5, 8, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       5, 8, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       5, 8, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       5, 8, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       5, 8, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       5, 16, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       5, 16, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       5, 16, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       5, 16, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       5, 16, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       5, 16, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       5, 16, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       5, 16, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       5, 32, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       5, 32, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       5, 32, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       5, 32, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       5, 32, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       5, 32, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       5, 32, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       5, 32, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,


       5, 8, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       5, 8, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       5, 8, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       5, 8, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       5, 8, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       5, 8, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       5, 8, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       5, 8, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       5, 16, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       5, 16, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       5, 16, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       5, 16, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       5, 16, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       5, 16, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       5, 16, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       5, 16, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       5, 32, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       5, 32, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       5, 32, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       5, 32, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       5, 32, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       5, 32, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       5, 32, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       5, 32, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,
       9, 32, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1};

  struct parameters B5BigEndianCases[80] = {
       5, 8, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       5, 8, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       5, 8, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       5, 8, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       5, 8, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       5, 8, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       5, 8, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       5, 8, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       5, 16, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       5, 16, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       5, 16, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       5, 16, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       5, 16, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       5, 16, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       5, 16, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       5, 16, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       5, 32, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       5, 32, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       5, 32, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       5, 32, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       5, 32, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       5, 32, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       5, 32, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       5, 32, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       5, 8, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       5, 8, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       5, 8, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       5, 8, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       5, 8, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       5, 8, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       5, 8, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       5, 8, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       5, 16, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       5, 16, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       5, 16, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       5, 16, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       5, 16, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       5, 16, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       5, 16, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       5, 16, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       5, 32, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       5, 32, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       5, 32, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       5, 32, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       5, 32, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       5, 32, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       5, 32, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       5, 32, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       5, 8, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       5, 8, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       5, 8, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       5, 8, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       5, 8, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       5, 8, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       5, 8, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       5, 8, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       5, 16, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       5, 16, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       5, 16, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       5, 16, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       5, 16, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       5, 16, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       5, 16, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       5, 16, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       5, 32, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       5, 32, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       5, 32, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       5, 32, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       5, 32, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       5, 32, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       5, 32, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       5, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,
       9, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1};


  struct parameters B6SmallEndianCases[80] = {
       6, 8, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       6, 8, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       6, 8, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       6, 8, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       6, 8, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       6, 8, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       6, 8, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       6, 8, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

       6, 16, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       6, 16, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       6, 16, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       6, 16, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       6, 16, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       6, 16, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       6, 16, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       6, 16, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

       6, 32, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       6, 32, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       6, 32, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       6, 32, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       6, 32, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       6, 32, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       6, 32, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       6, 32, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

       6, 8, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       6, 8, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       6, 8, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       6, 8, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       6, 8, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       6, 8, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       6, 8, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       6, 8, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       6, 16, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       6, 16, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       6, 16, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       6, 16, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       6, 16, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       6, 16, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       6, 16, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       6, 16, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       6, 32, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       6, 32, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       6, 32, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       6, 32, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       6, 32, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       6, 32, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       6, 32, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       6, 32, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       6, 8, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       6, 8, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       6, 8, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       6, 8, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       6, 8, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       6, 8, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       6, 8, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       6, 8, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       6, 16, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       6, 16, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       6, 16, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       6, 16, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       6, 16, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       6, 16, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       6, 16, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       6, 16, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       6, 32, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       6, 32, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       6, 32, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       6, 32, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       6, 32, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       6, 32, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       6, 32, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       6, 32, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,
       9, 32, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1};

  struct parameters B6BigEndianCases[80] = {
       6, 8, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       6, 8, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       6, 8, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       6, 8, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       6, 8, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       6, 8, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       6, 8, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       6, 8, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       6, 16, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       6, 16, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       6, 16, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       6, 16, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       6, 16, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       6, 16, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       6, 16, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       6, 16, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       6, 32, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       6, 32, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       6, 32, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       6, 32, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       6, 32, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       6, 32, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       6, 32, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       6, 32, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       6, 8, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       6, 8, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       6, 8, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       6, 8, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       6, 8, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       6, 8, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       6, 8, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       6, 8, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       6, 16, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       6, 16, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       6, 16, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       6, 16, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       6, 16, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       6, 16, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       6, 16, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       6, 16, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       6, 32, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       6, 32, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       6, 32, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       6, 32, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       6, 32, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       6, 32, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       6, 32, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       6, 32, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       6, 8, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       6, 8, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       6, 8, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       6, 8, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       6, 8, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       6, 8, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       6, 8, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       6, 8, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       6, 16, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       6, 16, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       6, 16, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       6, 16, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       6, 16, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       6, 16, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       6, 16, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       6, 16, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       6, 32, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       6, 32, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       6, 32, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       6, 32, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       6, 32, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       6, 32, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       6, 32, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       6, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,
       9, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1};


  struct parameters B7SmallEndianCases[80] = {
       7, 8, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       7, 8, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       7, 8, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       7, 8, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       7, 8, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       7, 8, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       7, 8, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       7, 8, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

       7, 16, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       7, 16, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       7, 16, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       7, 16, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       7, 16, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       7, 16, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       7, 16, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       7, 16, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

       7, 32, MW8, BLENRD4, BLENWR4, small,   SIN, RBLE_0,
       7, 32, MW8, BLENRD4, BLENWR4, small,   INC, RBLE_0,
       7, 32, MW8, BLENRD4, BLENWR4, small,  INC4, RBLE_0,
       7, 32, MW8, BLENRD4, BLENWR4, small,  INC8, RBLE_0,
       7, 32, MW8, BLENRD4, BLENWR4, small, INC16, RBLE_0,
       7, 32, MW8, BLENRD4, BLENWR4, small,  WRP4, RBLE_0,
       7, 32, MW8, BLENRD4, BLENWR4, small,  WRP8, RBLE_0,
       7, 32, MW8, BLENRD4, BLENWR4, small, WRP16, RBLE_0,

       7, 8, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       7, 8, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       7, 8, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       7, 8, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       7, 8, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       7, 8, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       7, 8, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       7, 8, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       7, 16, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       7, 16, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       7, 16, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       7, 16, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       7, 16, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       7, 16, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       7, 16, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       7, 16, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       7, 32, MW16, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       7, 32, MW16, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       7, 32, MW16, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       7, 32, MW16, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       7, 32, MW16, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       7, 32, MW16, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       7, 32, MW16, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       7, 32, MW16, BLENRD4, BLENWR4, small, WRP16, RBLE_1,


       7, 8, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       7, 8, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       7, 8, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       7, 8, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       7, 8, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       7, 8, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       7, 8, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       7, 8, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       7, 16, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       7, 16, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       7, 16, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       7, 16, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       7, 16, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       7, 16, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       7, 16, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       7, 16, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,

       7, 32, MW32, BLENRD4, BLENWR4, small,   SIN, RBLE_1,
       7, 32, MW32, BLENRD4, BLENWR4, small,   INC, RBLE_1,
       7, 32, MW32, BLENRD4, BLENWR4, small,  INC4, RBLE_1,
       7, 32, MW32, BLENRD4, BLENWR4, small,  INC8, RBLE_1,
       7, 32, MW32, BLENRD4, BLENWR4, small, INC16, RBLE_1,
       7, 32, MW32, BLENRD4, BLENWR4, small,  WRP4, RBLE_1,
       7, 32, MW32, BLENRD4, BLENWR4, small,  WRP8, RBLE_1,
       7, 32, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1,
       9, 32, MW32, BLENRD4, BLENWR4, small, WRP16, RBLE_1};

  struct parameters B7BigEndianCases[80] = {
       7, 8, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       7, 8, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       7, 8, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       7, 8, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       7, 8, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       7, 8, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       7, 8, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       7, 8, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       7, 16, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       7, 16, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       7, 16, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       7, 16, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       7, 16, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       7, 16, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       7, 16, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       7, 16, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       7, 32, MW8, BLENRD8, BLENWR8, big,   SIN, RBLE_0,
       7, 32, MW8, BLENRD8, BLENWR8, big,   INC, RBLE_0,
       7, 32, MW8, BLENRD8, BLENWR8, big,  INC4, RBLE_0,
       7, 32, MW8, BLENRD8, BLENWR8, big,  INC8, RBLE_0,
       7, 32, MW8, BLENRD8, BLENWR8, big, INC16, RBLE_0,
       7, 32, MW8, BLENRD8, BLENWR8, big,  WRP4, RBLE_0,
       7, 32, MW8, BLENRD8, BLENWR8, big,  WRP8, RBLE_0,
       7, 32, MW8, BLENRD8, BLENWR8, big, WRP16, RBLE_0,

       7, 8, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       7, 8, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       7, 8, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       7, 8, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       7, 8, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       7, 8, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       7, 8, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       7, 8, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       7, 16, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       7, 16, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       7, 16, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       7, 16, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       7, 16, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       7, 16, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       7, 16, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       7, 16, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       7, 32, MW16, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       7, 32, MW16, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       7, 32, MW16, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       7, 32, MW16, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       7, 32, MW16, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       7, 32, MW16, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       7, 32, MW16, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       7, 32, MW16, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       7, 8, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       7, 8, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       7, 8, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       7, 8, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       7, 8, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       7, 8, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       7, 8, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       7, 8, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       7, 16, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       7, 16, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       7, 16, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       7, 16, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       7, 16, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       7, 16, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       7, 16, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       7, 16, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,

       7, 32, MW32, BLENRD8, BLENWR8, big,   SIN, RBLE_1,
       7, 32, MW32, BLENRD8, BLENWR8, big,   INC, RBLE_1,
       7, 32, MW32, BLENRD8, BLENWR8, big,  INC4, RBLE_1,
       7, 32, MW32, BLENRD8, BLENWR8, big,  INC8, RBLE_1,
       7, 32, MW32, BLENRD8, BLENWR8, big, INC16, RBLE_1,
       7, 32, MW32, BLENRD8, BLENWR8, big,  WRP4, RBLE_1,
       7, 32, MW32, BLENRD8, BLENWR8, big,  WRP8, RBLE_1,
       7, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1,
       9, 32, MW32, BLENRD8, BLENWR8, big, WRP16, RBLE_1};


  /* The test cases and their corresponding parameters are listed here.
     The user can modify the 'caselist' to run the specific test cases.
     e.g., if the user wants to test only the first test case, the last
     element "ENDOFTEST" of the array may be put next to the B0SYWRRD test */
  struct caselist SsmcEndianessCaseList[20] = {
       "SsmcSmallEndianess_B0",   B0SmallEndianCases,
       "SsmcBigEndianess_B0",   B0BigEndianCases,
       "SsmcSmallEndianess_B1",   B1SmallEndianCases,
       "SsmcBigEndianess_B1",   B1BigEndianCases,
       "SsmcSmallEndianess_B2",   B2SmallEndianCases,
       "SsmcBigEndianess_B2",   B2BigEndianCases,
       "SsmcSmallEndianess_B3",   B3SmallEndianCases,
       "SsmcBigEndianess_B3",   B3BigEndianCases,
       "SsmcSmallEndianess_B4",   B4SmallEndianCases,
       "SsmcBigEndianess_B4",   B4BigEndianCases,
       "SsmcSmallEndianess_B5",   B5SmallEndianCases,
       "SsmcBigEndianess_B5",   B5BigEndianCases,
       "SsmcSmallEndianess_B6",   B6SmallEndianCases,
       "SsmcBigEndianess_B6",   B6BigEndianCases,
       "SsmcSmallEndianess_B7",   B7SmallEndianCases,
       "SsmcBigEndianess_B7",   B7BigEndianCases,
       "ENDOFTEST",          B0SmallEndianCases, 
       "ENDOFTEST",          B0BigEndianCases 
       };


  struct caselist *TestCases = SsmcEndianessCaseList;


  /*
     Programming SSMCCR and SSMCTrCR registers. The constants CLKRATIO and
     CLKSTATUS defined in the Ssmc.h set the required  MemClkRatio and
     SMClockEn field bits.
  */
  SSMCCRDATA = CLKRATIO | CLKSTATUS;
  ConfigureCLKRatio(SSMCCRDATA);

  /*
     Programming the SSMCTrBurstWT register to turn the mask ON/OFF and to
     set the BeatNo and BurstWT counts. The constants BWtMask_ON/OFF,
     Beat0 to 15 and SSMCTrBurstWT0 to 15 are defined in Ssmc.h.
  */
  SSMCTrBurstWTData = BWtMask_ON | Beat15 | SSMCTrBurstWT15;
  ConfigureBurstWT(SSMCTrBurstWTData);

  /*
     Programming the SSMCTrWTCNCL register. The constant SMWTCNCLDI/EN
     disables or Enables the SMCANCELWait signal. The constant SMWAITIGNORE_0/1
     enables or disables the SMWAITIGNORE respectively and the constants
     WTCNCL0 to 63 are used to load the CANCEL WAIT count.
  */
  WTCNCLData = SMWTCNCLDI | SMWAITIGNORE_1 | WTCNCL10 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  /** Configuring the system to LITTLE endian mode by setting ENDIANNESS = 0 **/
  ENDIANNESS = 0;
  HSA(SSMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,ENDIANNESS);
  HSEN(LITTLE);

  /*
     Programming the SSMCTrExtMuxWT register.The constant ExtMuxDI/EN disables
     or enables the  External Mux. The constants ExtMuxAss0 to 15 and
     ExtMuxDAss0 to 15 define the Assertion and Deassertion counts.
  */
  ExtMuxData = ExtMuxAss5 | ExtMuxDAss5 | ExtMuxDI;
  HSA(SSMCTrExtMux, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,ExtMuxData);

  /** Programming the SSMCTrSMBLSPOL register **/
  SMBLSPOLData = SMBLSPOL_0;
  HSA(SSMCTrSMBLSPOL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SMBLSPOLData);

  while (TestCases->CaseNumber != "ENDOFTEST")
  {
    sprintf(report,"Test No : %s", TestCases->CaseNumber);
    C(report);


    SsmcEndianessParams = TestCases->TestParams;
   while (SsmcEndianessParams->BANKNO != 9)
    {

  /* Set the ofset for the memory to zero.The offset can be given a new value
     by changing the value of the variable SSMCTrMEMBData */

  SSMCTrMEMBData[SsmcEndianessParams -> BANKNO ] = 0x00000000;


  /*
     The control register fields are configured as per the requirement.
     The banks are configured with the external wait enabled when endianness is
     big and vice versa.The (SsmcEndianessParams -> ENDIAN << 2) & 0x00000004
     decides wether ext wait is enabled or not. 
  */
  BCRData     =   CRADDRVALIDWR_DI |
                  CRADDRVALIDRD_DI |
                  CRSYNCENWR_ASY   |
                  CRSYNCENRD_ASY   |
                  CRBMWRITE_EN     |
                  CRBMREAD_EN      |
                  CRWP_DI          |
                  WRAPRD_DI        |
                  (SsmcEndianessParams -> ENDIAN << 2) & 0x00000004  |
                  CRWAITPOL_0      |
                  SsmcEndianessParams -> BURSTLENWR |
                  SsmcEndianessParams -> BURSTLENRD |
                  BIWRITE_DI        |
                  BIREAD_DI         |
                  SMBLSPOL_0        |          
                  SsmcEndianessParams -> RBLE       |
                  SsmcEndianessParams -> MSIZE;

  SSMCTrCS2WTRData[SsmcEndianessParams -> BANKNO] = TRWAITEN_DI | TRWAITPOL_0 |
                                                    TRCS2WTR2   | TRWT2DEWT2;

  ConfigureUUT(SsmcEndianessParams -> BANKNO,
               WSTIDCY3,
               WSTRD7,
               WSTWR0,
               WSTOEN3,
               WSTWEN0,
               BCRData,
               SSMCTrCS2WTRData[SsmcEndianessParams -> BANKNO],
               WSTBRD2 );

  ConfigureMemory(SsmcEndianessParams -> BANKNO,
                  SSMCTrMEMBData[SsmcEndianessParams -> BANKNO ]
                  );

  /* 
     Assign values to Hsize  depending on the HSIZE values in testcases
     Hsize = 0, 1, 2 when HSIZE = 8, 16, 32 respectively 
  */
    switch(SsmcEndianessParams -> HSIZE)
     {
    	case  8 : Hsize = 0;
                  break;

    	case 16 : Hsize = 1;
        	  break;

     	case 32 : Hsize = 2;
                  break;
     }

  /*
     Assign values to Msize  depending on the MSIZE values in testcases 
     Msize = 0, 1, 2 when MSIZE = 8, 16, 32 respectively                    
  */
  switch(SsmcEndianessParams -> MSIZE)
   {
  	  case MW8 : Msize = 0;
                     break;

   	  case MW16 : Msize = 1;
                      break;
 
          case MW32 : Msize = 2;
                      break;
    }

  /* Generate TestData depending on the HSIZE   */
   switch(SsmcEndianessParams -> HBURST)
  {
    case  SIN : TestData =0x11111111 ;
                break;

    case  INC : TestData = 0x22222222;
                break;

    case  INC4 : TestData =0x33333333;
                 break;

    case  INC8 : TestData = 0x44444444;
                 break;

    case INC16 : TestData = 0x55555555;
                 break;

    case  WRP4 : TestData = 0x66666666;
                 break;

    case  WRP8 : TestData = 0x77777777;
                 break;

    case WRP16 : TestData = 0x88888888;
                 break;
  }

  /* SET THE ENDIANESS FOR THE CONFIGURED BANK */
  switch(SsmcEndianessParams -> ENDIAN)
  {
    case small :  ENDIANNESS = 0;
		  /** Configuring the System to LITTLE ENDIAN Mode **/
 		  HSA(SSMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
 		  HSW( ,ENDIANNESS);
 		  HSEN(LITTLE);
 		  break;

    case big   :  ENDIANNESS = 1;
                  /** Configuring the System to BIG ENDIAN Mode **/
                  HSA(SSMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
                  HSW( ,ENDIANNESS);
                  HSEN(DISABLE);
                  break;
  }

     BurstWriteRead(SsmcEndianessParams -> BANKNO, 
                    SsmcEndianessParams -> HBURST, 
                    0x00, 
                    Hsize,
		    Msize,            
                    TestData);

     SsmcEndianessParams++;
    }
  TestCases++;
  }
  /** Configuring the system to LITTLE endian mode **/
  ENDIANNESS = 0;
  HSA(SSMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,ENDIANNESS);
  HSEN(LITTLE);


}

/************************************* END ************************************/
