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
//  File Name           :testutils.c,v
//  File Revision       :1.11
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Test utilities may be used by several modules
//
//--========================================================================--


#include <stdio.h>
#include "testutils.h"



//----------------------------------------------------------------------------
// installHandler()
//
// Installs a new interrupt handler
// Updates contents of 'addr' to contain address of handler function
// Function return value is original contents of 'vector'.
//
// Note: This function stores an address, rather than a branch instruction, at 
// 'addr', so cannot be used to write directly to the exception vector.
//
// This method of installing interrupt handlers is dependent on 'addr' 
// being remapped to RAM (see vector.s)
//
//
// Note:  If you are using a processor with separate instruction and data 
// caches such as StrongARM, or ARM940T, you must ensure that cache coherence  
// problems do not prevent the new contents of the vectors from being used. 
// The data cache (or at least the entries containing the modified vectors)  
// must be cleaned to ensure the new vector contents are written to main  
// memory. You must then flush the instruction cache to ensure that the new  
// vector contents are read from main memory.  For details of cache clean and  
// flush operations, see the datasheet for your target processor.
//
//----------------------------------------------------------------------------

Word installHandler( Word routine, Word *addr )
{   
    Word  oldRt;

    oldRt = *addr;
    *addr = routine;

    return (oldRt);
}


//----------------------------------------------------------------------------
// testPcellID()
//
// Check the Primecell ID registers - 
// these identify a Primecell is present at the stated address
//----------------------------------------------------------------------------

TestStatus testPcellID( Word *baseAddr )
{

  Word pcellId;
   
  pcellId = 
    ( ( *(Word *)( (Word)baseAddr + TEST_PCELL_ID      ) ) & 0xFF )       |
    ( ( *(Word *)( (Word)baseAddr + TEST_PCELL_ID +  4 ) ) & 0xFF ) <<  8 |
    ( ( *(Word *)( (Word)baseAddr + TEST_PCELL_ID +  8 ) ) & 0xFF ) << 16 |
    ( ( *(Word *)( (Word)baseAddr + TEST_PCELL_ID + 12 ) ) & 0xFF ) << 24;
 

  
  TEST_REPORT( "PCell ID = %#08.8lx", pcellId ); // report PrimeCell ID
  
  if ( pcellId != TEST_IS_PCELL ) 
  { 
    return UNKNOWN; // doesn't fail if not a PrimeCell
  }
  else
  { 
    return PASS; 
  }
 
} 


//----------------------------------------------------------------------------
// testPeriphID ()
//
// Check the Peripheral ID registers - 
// Bits 11:0  are Part number
// Bits 19:12 are Designer ID ( 0x41 == ARM )
// Bits 23:20 are Revision number
// Bits 31:24 are Configuration
//
//----------------------------------------------------------------------------

TestStatus testPeriphID( Word *baseAddr, const Word expected, const Word mask )
{

  Word periphId;
  Word fieldValue;
   

  periphId = 
    ( ( *(Word *)( (Word)baseAddr + TEST_PER_ID      ) ) & 0xFF )       |
    ( ( *(Word *)( (Word)baseAddr + TEST_PER_ID +  4 ) ) & 0xFF ) <<  8 |
    ( ( *(Word *)( (Word)baseAddr + TEST_PER_ID +  8 ) ) & 0xFF ) << 16 |
    ( ( *(Word *)( (Word)baseAddr + TEST_PER_ID + 12 ) ) & 0xFF ) << 24;

  // Display Part number
  fieldValue = periphId & 0xFFF;
  TEST_REPORT( "Part No = %#03.3lx", fieldValue );

  // Display Designer id
  fieldValue = (periphId & 0xFF000) >> 12;
  TEST_REPORT( "Designer = %#02.2lx", fieldValue );

  // Display Revision No
  fieldValue = (periphId & 0xF00000) >> 20;
  TEST_REPORT( "Revision = %#01.1lx", fieldValue );

  // Display Revision No
  fieldValue = (periphId & 0xFF000000) >> 24;
  TEST_REPORT( "Configuration = %#02.2lx", fieldValue );
  
  if ( mask == 0 ) 
  { 
    return UNKNOWN; // returns UNKNOWN if mask is zero
  }
  else if ( ( periphId & mask ) != ( expected & mask ) ) 
  { 
    return FAIL;
  }
  else
  { 
    return PASS; 
  }

}
    
// end of file testutils.c

