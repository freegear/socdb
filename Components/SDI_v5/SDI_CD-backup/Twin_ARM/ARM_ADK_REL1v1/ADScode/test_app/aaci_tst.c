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
//  File Name           :aaci_tst.c,v
//  File Revision       :1.16
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
// Purpose              : Example EASY world C test program that
//                        performs integration tests on AACI 
//
//--========================================================================--

#include "peripherals.h"
#include "testutils.h"
#include "aaci_tst.h"

#include <stdio.h>
#include <stdlib.h>


// Function prototypes
TestStatus testAaci( void );


//----------------------------------------------------------------------------
// testAaci ()
// Verifies AACI PCellID and PeriphID
// Verifies operation of AACI Primary I/O 
//----------------------------------------------------------------------------

TestStatus testAaci( void )
{
  TestStatus status = PASS;

  printf("test aaci\n");

  DO_TEST( testPcellID( (Word *)( &aaci ) ), "PrimeCell ID", status );

  return status;

}

// end of file aaci_tst.c
