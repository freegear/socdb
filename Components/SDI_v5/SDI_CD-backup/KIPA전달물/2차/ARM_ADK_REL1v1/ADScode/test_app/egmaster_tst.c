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
//  File Name           :egmaster_tst.c,v
//  File Revision       :1.1
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
// Purpose              : Example EASY world C test program that performs
//                        integration tests on Example AHB master and 
//                        File Reader
//
//--========================================================================--


// includes
#include <stdio.h>
#include <stdlib.h>

#include "peripherals.h"
//#include "testutils.h"
#include "egmaster_tst.h"


// defines


#define EBM_LAST_BYTE 0x0F

// Function prototypes
TestStatus testFrbmAndEbm( void );
TestStatus testFrbm( void );
TestStatus testEgMaster( void );
TestStatus fillEgMasterInMem( void );

// Note: the following values must agree with the values written using the
// File Reader Bus Master script.
const Word testData[EGMASTER_ARRAY_SIZE] = { 0x03020100, 0x07060504, 
                                             0x0B0A0908, 0x0F0E0D0C };


//----------------------------------------------------------------------------
// testFrbmAndEbm()
// Calls test on File Reader Bus Master.
// If this is passed, also calls test on Example AHB Master
//
//----------------------------------------------------------------------------
TestStatus testFrbmAndEbm( void )
{
  TestStatus status = PASS;

  DO_TEST( testFrbm(), "File Reader", status );

  // If FRBM test has failed, need to fill EgMasterInMem with known values
  if( status != PASS )
  {
    if( fillEgMasterInMem() != PASS )
    {
      // If memory fill fails, can't test Example AHB Master
      DO_TEST( UNKNOWN,"Example AHB Master", status );
      return status;
    }    
  }

  DO_TEST( testEgMaster(),"Example AHB Master", status );
  return status;
}

//----------------------------------------------------------------------------
// testFrbm()
// Test File Reader Bus Master (FRBM)
//
// Assumption:
// Assumes the 4 words at location EgMasterInMem[0..3] contain the values 
// FRBM_WORD0..FRBM_WORD3.
// These values should be written by the FRBM.
//----------------------------------------------------------------------------
TestStatus testFrbm( void )
{
  Word i;
  TestStatus status = PASS;

  // Check that expected data has been written to memory by the FRBM
  for (i = 0; i < EGMASTER_ARRAY_SIZE; i++)
  {
    if ( egMasterInMem[i] != testData[i] )
    {
      TEST_REPORT( "Incorrect data at address %#08.8lx", 
                   (Word)&(egMasterInMem[i]) );
      status = FAIL;
    }
  }
  return status;

}

//----------------------------------------------------------------------------
// testEgMaster()
// Test Example AHB Master
//
// Tests that byte at location EgMasterOutMem contains the value 
// EBM_LAST_BYTE.
// 
//
// Assumptions:
// 1) Assumes that the Example AHB Master locks the bus during its write phase,
//    that is intermediate values written by the Example AHB Master cannot be
//    read by the ARM core.
//
// 2) Assumes that Example AHB Master is little-endian.
//
// 3) Assumes that the memory location used doesn't already contain
//----------------------------------------------------------------------------
TestStatus testEgMaster( void )
{
  // Check that expected data has been written to memory by Eg Master
  if( egMasterOutMem !=  ( EgMasterOutMem )EBM_LAST_BYTE )
  {
    return FAIL;
  }
  return PASS;
}


//----------------------------------------------------------------------------
// fillEgMasterInMem()
// Fill memory that should have been written to by FRBM, then checks contents
//----------------------------------------------------------------------------

TestStatus fillEgMasterInMem( void )
{
  Word i;

  // fill memory
  for (i = 0; i < EGMASTER_ARRAY_SIZE; i++)
  {
    egMasterInMem[i] = testData[i];
  }

  // check memory
  for (i = 0; i < EGMASTER_ARRAY_SIZE; i++)
  {
    if ( egMasterInMem[i] != testData[i] )
    {
      return FAIL;
    }
  }

  // default return value
  return PASS;
}

// end of file egmaster_tst.c
