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
//  File Name           :mpmc_tst.c,v
//  File Revision       :1.16
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
// Purpose              : Example EASY world C test program that
//                        performs integration tests on GPIO
//
//--========================================================================--

#include "peripherals.h"
#include "testutils.h"
#include "mpmc_tst.h"

#include <stdio.h>
#include <stdlib.h>


// Function prototypes
TestStatus testMpmc( void );


//----------------------------------------------------------------------------
// testMpmc ()
// Verifies MPMC PCellID and PeriphID
// Verifies operation of MPMC Primary I/O 
//----------------------------------------------------------------------------

TestStatus testMpmc( void )
{
  TestStatus status = PASS;

//  DO_TEST( testPeriphID( (Word *)( &mpmc ), GPIO_ID_VALUE, GPIO_ID_MASK ), 
//                         "ID registers", status );
printf("test mpmc\n");

 // mpmc.MPMCControl = 0x00;

 // printf("MPMCControl Address %#08.8lx\n", mpmc.MPMCControl);

  DO_TEST( testPcellID( (Word *)( &mpmc ) ), "PrimeCell ID", status );

  return status;

}

// end of file mpmc_tst.c
