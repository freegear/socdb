//--========================================================================--
// This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT  2001 ARM Limited
//       ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//----------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           :mmc_tst.c,v
//  File Revision       :1.16
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
// Purpose              : Example EASY world C test program that
//                        performs integration tests on MMC 
//
//--========================================================================--

#include "peripherals.h"
#include "testutils.h"
#include "mmc_tst.h"

#include <stdio.h>
#include <stdlib.h>


// Function prototypes
TestStatus testMmc( void );


//----------------------------------------------------------------------------
// testMmc ()
// Verifies MMC PCellID and PeriphID
// Verifies operation of MMC Primary I/O 
//----------------------------------------------------------------------------

TestStatus testMmc( void )
{
  TestStatus status = PASS;

  printf("test mmc\n");

  DO_TEST( testPcellID( (Word *)( &mmc ) ), "PrimeCell ID", status );

  return status;

}

// end of file mmc_tst.c
