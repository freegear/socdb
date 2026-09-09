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
//  File Name           :egslave_tst.c,v
//  File Revision       :1.9
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
// Purpose              : Example EASY world C test program that performs
//                        integration tests on Example APB slave
//
//--========================================================================--


// includes

#include "peripherals.h"
#include "testutils.h"
#include "egslave_tst.h"

#include <stdio.h>
#include <stdlib.h>


// defines

#define TEST_WORD0 0x12345678
#define TEST_WORD1 0xAAAAAAAA
#define TEST_WORD2 0x0F0F0F0F
#define TEST_WORD3 0xFF00FF00



// Function prototypes

TestStatus testSlave( EgSlave * );
TestStatus testEgSlave( void );


//----------------------------------------------------------------------------
// testEgSlave()
// Test Example APB Slave 
//----------------------------------------------------------------------------
TestStatus testEgSlave( void )
{
  TestStatus status = PASS;

  DO_TEST( testPeriphID( (Word *)( &egSlave ), 
           EGSLAVE_ID_VALUE, EGSLAVE_ID_MASK ), "ID registers", status );
  DO_TEST( testPcellID( (Word *)( &egSlave ) ), 
           "PrimeCell ID", status );

  DO_TEST( testSlave( &egSlave ), "Read/write registers", status );
  
  return status;
}


//----------------------------------------------------------------------------
// testSlave()
// Tests Example APB Slave at given address by writing to
// and reading from example registers
//----------------------------------------------------------------------------
TestStatus testSlave( EgSlave *dut )
{

  dut->R0 = TEST_WORD0;
  dut->R1 = TEST_WORD1;
  dut->R2 = TEST_WORD2;
  dut->R3 = TEST_WORD3;
  
  if (dut->read28 == ( TEST_WORD0 ^ TEST_WORD1 ^ TEST_WORD2 ^ TEST_WORD3 ) )
  {
    return PASS;
  }
  else
  {
    return FAIL;
  }

}

// end of file egslave_tst.c