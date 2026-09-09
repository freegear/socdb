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
//  File Name           :memory_tst.c,v
//  File Revision       :1.15
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
// Purpose              : Example EASY world C test program that
//                        performs tests on memory
//
//--========================================================================--


// Includes

#include "peripherals.h"
#include "testutils.h"
#include "memory_tst.h"
#include "encache.h"

#include <stdio.h>
#include <stdlib.h>

// Defines

// __BIG_ENDIAN is predefined if compiling for a big-endian target.
// This is used to select the endianness of the tests.


// Function prototypes

TestStatus testMemory(void);

TestStatus testExtRam1(void);
TestStatus testExtRam2(void);
TestStatus testRom(void);
TestStatus testIntRam(void);

static TestStatus testRW(MemUnion *address);
static TestStatus testRO(volatile const Word *address);

static TestStatus testBurstRW(Word *address);
static TestStatus testBurstRO(volatile const Word *address);


//----------------------------------------------------------------------------
// testMemory ()
// Test access to each area of memory in turn
//----------------------------------------------------------------------------

TestStatus testMemory(void)
{
  // track result of tests
  TestStatus status = PASS;

  DO_TEST( testExtRam1(), "External RAM1", status );
  DO_TEST( testExtRam2(), "External RAM2", status );
  DO_TEST( testRom(), "External ROM", status );
  DO_TEST( testIntRam(), "Internal RAM", status );
  
  return status;  
} 


//----------------------------------------------------------------------------
// testExtRam1 ()
// Tests some locations in the first area of external RAM
//----------------------------------------------------------------------------

TestStatus testExtRam1(void)
{
  // track result of tests
  TestStatus status = PASS;

  DO_TEST( testRW(&ExtRam1), "Byte/halfword/word access",
            status );
  DO_TEST( testBurstRW(ExtRam1Array), "Word burst access",
            status );

  return status;  
} 


//----------------------------------------------------------------------------
// testExtRam2 ()
// Tests some locations in the second area of external RAM
//----------------------------------------------------------------------------

TestStatus testExtRam2(void)
{
  // track result of tests
  TestStatus status = PASS;

  DO_TEST( testRW(&ExtRam2), "Byte/halfword/word access",
            status );
  DO_TEST( testBurstRW(ExtRam2Array), "Word burst access",
            status );

  return status;  
} 


//----------------------------------------------------------------------------
// testRom ()
// Tests some locations in ROM
//----------------------------------------------------------------------------

TestStatus testRom(void)
{
  // track result of tests
  TestStatus status = PASS;

  // As the ROM area is cached in some EASYs, disable data cache prior to 
  // testing ROM
  disableDCacheForRomTst();

  DO_TEST( testRO(&ExtRom), "Byte/halfword/word access",
            status );
  DO_TEST( testBurstRO(ExtRomArray), "Word burst access",
            status );

  // Re-enable the data cache after testing ROM
  enableDCacheAfterRomTst();

  return status;  
} 


//----------------------------------------------------------------------------
// testIntRam ()
// Tests some locations in internal RAM
//----------------------------------------------------------------------------

TestStatus testIntRam(void)
{
  // track result of tests
  TestStatus status = PASS;

  DO_TEST( testRW(&IntRam), "Byte/halfword/word access",
            status );
  DO_TEST( testBurstRW(IntRamArray), "Word burst access",
            status );

  return status;  
} 


//----------------------------------------------------------------------------
// testRO ()
// Tests word, half-word, and byte access to a word of read-only memory
//
// Assumption:
// The location specified in the call to testROM() should contain the
// value TEST_VAL_1, which has been set at link time
//----------------------------------------------------------------------------

static TestStatus testRO(volatile const Word *address)
{

  MemUnion *pRom;
  
  Word value;
  
  pRom = (MemUnion *)address;           

  // Read as word
  
  if (pRom->w != TEST_VAL_1)
  {
    return FAIL;
  }


  // Read as 2 halfwords
  #ifdef __BIG_ENDIAN     // Big-endian
    value = (Word)(pRom->h.h2) | ( (Word)(pRom->h.h1) << 16 );  
  #else                   // Little-endian    
    value = (Word)(pRom->h.h1) | ( (Word)(pRom->h.h2) << 16 );  
  #endif
  
  if (value != TEST_VAL_1)
  {
    return FAIL;
  } 
  
  // Read as 4 bytes
  #ifdef __BIG_ENDIAN // Big-endian
    value = ( ( (Word) (pRom->b.b4) ) | 
              ( (Word) (pRom->b.b3) << 8 ) |
              ( (Word) (pRom->b.b2) << 16 ) |
              ( (Word) (pRom->b.b1) << 24 ) 
            );
  #else               // Little-endian
    value = ( ( (Word) (pRom->b.b1) ) | 
              ( (Word) (pRom->b.b2) << 8 ) | 
              ( (Word) (pRom->b.b3) << 16 ) |
              ( (Word) (pRom->b.b4) << 24 ) 
            );
  #endif
  
  if (value != TEST_VAL_1)
  {
      return FAIL;
  }
  
  // Attempt write to ROM
  pRom->w = TEST_VAL_2;
  
  if (pRom->w != TEST_VAL_1)
  {
      return FAIL;
  }
  
  
  return PASS;
}


//----------------------------------------------------------------------------
// testRW ()
// Tests word, half-word, and byte access to a word of read/write memory
//----------------------------------------------------------------------------

static TestStatus testRW(MemUnion *address)
{
  Word value;
  
  // Write to external RAM
  address->w = TEST_VAL_1;
  
  // Read back as word  
  if (address->w != TEST_VAL_1)
  {
      return FAIL;
  }
  
  // Read back as 2 halfwords
  #ifdef __BIG_ENDIAN     // Big-endian
    value = (Word)(address->h.h2) | ( (Word)(address->h.h1) << 16 );  
  #else                    // Little-endian 
    value = (Word)(address->h.h1) | ( (Word)(address->h.h2) << 16 ); 
  #endif
  
  if (value != TEST_VAL_1)
  {
    return FAIL;
  }
   
  // Write to external RAM
  address->w = TEST_VAL_2;

  // Read back as 4 bytes
  #ifdef __BIG_ENDIAN  // Big-endian
    value = ( ( (Word) (address->b.b4) ) | 
              ( (Word) (address->b.b3) << 8 ) |
              ( (Word) (address->b.b2) << 16 ) |
              ( (Word) (address->b.b1) << 24 ) 
            );
  #else               // Little-endian
    value = ( ( (Word) (address->b.b1) ) | 
              ( (Word) (address->b.b2) << 8 ) | 
              ( (Word) (address->b.b3) << 16 ) |
              ( (Word) (address->b.b4) << 24 ) 
            );

  #endif
  
  if (value != TEST_VAL_2)
  {
      return FAIL;
  }
  
  // Write as 2 bytes and 1 halfword
  #ifdef __BIG_ENDIAN  // Big-endian
    address->b.b4 = (Byte)(TEST_VAL_3);
    address->b.b3 = (Byte)(TEST_VAL_3 >> 8);
    address->h.h1 = (HalfWord)(TEST_VAL_3 >> 16);
  #else               // Little-endian
    address->b.b1 = (Byte)(TEST_VAL_3);
    address->b.b2 = (Byte)(TEST_VAL_3 >> 8);
    address->h.h2 = (HalfWord)(TEST_VAL_3 >> 16);
  #endif

  
  // Read back as word  
  if (address->w != TEST_VAL_3)
  {
      return FAIL;
  }

  
  return PASS;
}


//----------------------------------------------------------------------------
// testBurstRO ()
// Tests word burst access to an array of read-only memory
//----------------------------------------------------------------------------

static TestStatus testBurstRO(volatile const Word *address)
{
  Word i;

  Word testData[BURST_ARRAY_SIZE] = { BURST_VAL_7, BURST_VAL_6, 
                                      BURST_VAL_5, BURST_VAL_4, 
                                      BURST_VAL_3, BURST_VAL_2, 
                                      BURST_VAL_1, BURST_VAL_0  
                                    };


  Word readData[BURST_ARRAY_SIZE] = { 0x00000000, 0x00000000,
                                      0x00000000, 0x00000000,
                                      0x00000000, 0x00000000,
                                      0x00000000, 0x00000000
                                    };


  // Sequential read & write of length 8 words -
  // copies address[] to readData[]
  BurstCopy8(address, readData);

  // Check burst read from ROM
  for (i = 0; i < BURST_ARRAY_SIZE; i++)
  {
    if ( readData[i] !=  testData[i])
    {
      return FAIL;
    }
  }

  return PASS;
}


//----------------------------------------------------------------------------
// testBurstRW ()
// Tests word burst access to an array of read/write memory
//----------------------------------------------------------------------------

static TestStatus testBurstRW(Word *address)
{
  Word i;

  Word testData[BURST_ARRAY_SIZE] = { BURST_VAL_0, BURST_VAL_1, 
                                      BURST_VAL_2, BURST_VAL_3, 
                                      BURST_VAL_4, BURST_VAL_5, 
                                      BURST_VAL_6, BURST_VAL_7  
                                    };

  Word readData[BURST_ARRAY_SIZE] = { 0x00000000, 0x00000000,
                                      0x00000000, 0x00000000,
                                      0x00000000, 0x00000000,
                                      0x00000000, 0x00000000
                                    };

  // Sequential read & write of length 8 words -
  // copies testData[] to address[]
  BurstCopy8(testData, address);

  // Check burst write to RAM
  for (i = 0; i < BURST_ARRAY_SIZE; i++)
  {
    if ( address[i] !=  testData[i])
    {
      return FAIL;
    }
  }

  // Sequential read & write of length 8 words -
  // copies address[] to readData[]
  BurstCopy8(address, readData);

  // Check burst read from RAM
  for (i = 0; i < BURST_ARRAY_SIZE; i++)
  {
    if ( readData[i] !=  testData[i])
    {
      return FAIL;
    }
  }

  return PASS;
}


// end of file memory_tst.c