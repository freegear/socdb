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
//  File Name           :reset_tst.c,v
//  File Revision       :1.14
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Example EASY world C test program that
//                        tests reset and remap
//
//--========================================================================--


#include "peripherals.h"
#include "testutils.h"
#include "reset_tst.h"

#include <stdio.h>
#include <stdlib.h>



// Function prototypes
__inline Boolean powerOnReset( void );
TestStatus testPowerOnReset( void );
TestStatus testRemPause( void );

//----------------------------------------------------------------------------
// testRemPause
//----------------------------------------------------------------------------

TestStatus testRemPause( void )
{
  TestStatus status = PASS;

  DO_TEST( remapTestFlag, "Remap", status );
  DO_TEST( testPowerOnReset() , "Power on reset", status );

  DO_TEST( 
           testPeriphID( (Word *)&remPause, RPC_ID_VALUE, RPC_ID_MASK ), 
           "ID registers", status 
         );
  DO_TEST( testPcellID( (Word *)&remPause ), "PrimeCell ID", status );

  return status;

}


//----------------------------------------------------------------------------
// powerOnReset
// Examine reset status
// Powering the system on sets a bit in the Reset Status register.
// This bit maybe read and cleared.
// Returns TRUE if POR bit set
//----------------------------------------------------------------------------
__inline Boolean powerOnReset( void )
{
  if ((remPause.ResetStatus & RPCResetStatusPOR) == RPCResetStatusPOR)
  { 
    // Power on reset
    return TRUE;
  } 
  else 
  { 
    // Soft Reset
    return FALSE;
  }
}


//----------------------------------------------------------------------------
// testPowerOnReset ()
// Test Power On Reset and clear POR flag
//----------------------------------------------------------------------------

TestStatus testPowerOnReset( void )
{

  if ( powerOnReset() != TRUE )
  {
    return FAIL;
  }
  else
  {
    remPause.ResetStatusClr = RPCResetStatusPOR;  // Clear Reset status
    return PASS;
  }

}


// end of file reset_tst.c