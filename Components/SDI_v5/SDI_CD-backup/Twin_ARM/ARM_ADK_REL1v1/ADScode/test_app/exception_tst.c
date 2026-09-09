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
//  File Name           :exception_tst.c,v
//  File Revision       :1.6
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
// Purpose           : Example EASY world C test program that
//                     tests Processor Exception Handling
//
//--========================================================================--


#include "testutils.h"
#include "exception_tst.h"
#include "defaultslave.h"
#include "exception.h"

#include <stdio.h>
#include <stdlib.h>

// defines
#define INT_WAIT  50  // When used in loops, will not give an accurate delay
#define SWI_NUM   1

// Function prototypes

TestStatus testUndefined (void);
TestStatus testSwi (void);
TestStatus testPrefetchAbort( void );
TestStatus testDataAbort( void );


void __swi(SWI_NUM) swi_test( void );


//----------------------------------------------------------------------------
// testExceptions ()
// Calls exception tests on core
//----------------------------------------------------------------------------

TestStatus testExceptions( void )
{
  TestStatus status = PASS;

  DO_TEST( testUndefined(), "Undefined Exception", status ); 
  DO_TEST( testSwi(), "Software Interrupt", status ); 
  DO_TEST( testPrefetchAbort(), "Prefetch Abort Exception", status );  
  DO_TEST( testDataAbort(), "Data Abort Exception", status );    

  return status;
}    

 

//----------------------------------------------------------------------------
// testUndefined()
// Generate an Undefined Instruction exception in the core
//
// Ref: ARM ARM 3.13.1 Undefined Instruction space
//----------------------------------------------------------------------------

TestStatus testUndefined( void )
{
  Word oldHandler;

  undefinedFlag = FALSE;

  // install Undefined Instruction handler
  oldHandler = installHandler ( (Word)undefined_Handler, &undefined_Addr );

  undefined();     // This function causes an undefined instruction exception

  // re-install default Undefined Instruction handler
  installHandler ( oldHandler, &undefined_Addr );

  if ( undefinedFlag == FALSE )
  {  
    return FAIL;
  }

  return PASS;

}

//----------------------------------------------------------------------------
// setUndefinedFlag()
// Callback function from undefined_Handler()
//
// Warning:  There is no stack overflow checking.
// 
//----------------------------------------------------------------------------
void setUndefinedFlag( void )
{
  TEST_MSG("Undefined instruction");
  undefinedFlag = TRUE;
}


//----------------------------------------------------------------------------
// testSwi()
// Generate a Software Interrupt exception in the core
//
// Ref: ARM ARM 2.6.3 Software Interrupt exception
//----------------------------------------------------------------------------

TestStatus testSwi( void )
{
  Word oldHandler;

  swiFlag = FALSE;

  
  // install Software Interrup handler
  oldHandler = installHandler ( (Word)swi_Handler, &swi_Addr );

  swi_test();     // This function causes an SWI exception

  // re-install default SWI handler
  installHandler ( oldHandler, &swi_Addr );

  if ( swiFlag == FALSE )
  {  
     return FAIL;
  }
      
  return PASS;

}


//----------------------------------------------------------------------------
// setSwiFlag()
// Callback function from swi_Handler()
//
// Warning: There is no stack overflow checking.
// 
//----------------------------------------------------------------------------

void setSwiFlag( int swi_num )
{

  switch( swi_num )
  {
  case SWI_NUM:

    TEST_REPORT("SWI #%i", swi_num );
    swiFlag = TRUE;
    break;
    
  default:
    TEST_REPORT("Incorrect SWI (#%i)", swi_num);
    swiFlag = FALSE;
    break;
  }
}



//----------------------------------------------------------------------------
// testPrefetchAbort()
// Generate an Prefetch Abort exception in the core
//
// Ref: ARM ARM 2.6.4 Prefetch Abort                      
//
//----------------------------------------------------------------------------

TestStatus testPrefetchAbort( void )
{
  Word oldHandler;
    
  prefetchAbortFlag = FALSE;

  // install Prefetch Abort handler
  oldHandler = installHandler ( (Word)prefetchAbort_Handler, 
                                &prefetchAbort_Addr );
  
  prefetchAbort();

  // Wait for prefetchAbortFlag to be altered by the interrupt handler
  // If this doesn't occur with in INT_WAIT iterations flag an error
  {
    int i;
    for( i = 0; ( dataAbortFlag == FALSE ) && ( i < INT_WAIT ) ; i++ )
    {
      // wait loop
    }
  }

  // re-install default Prefetch Abort handler
  installHandler ( oldHandler, &prefetchAbort_Addr );
      
  if ( prefetchAbortFlag == FALSE )
  {  
     return FAIL;
  }
  return PASS;
}


//----------------------------------------------------------------------------
// setPrefetchAbortFlag()
// Callback function from prefetchAbort_Handler()
//
// Warning: There is no stack overflow checking.
// 
//----------------------------------------------------------------------------

void setPrefetchAbortFlag( void )
{
  TEST_MSG("Prefetch abort");
  prefetchAbortFlag = TRUE;
}




//----------------------------------------------------------------------------
// testDataAbort()
// Generate an Data Abort exception in the core
//
// Ref: ARM ARM 2.6.5 Data Abort                      
//
//----------------------------------------------------------------------------

TestStatus testDataAbort( void )
{

  Word oldHandler;
  dataAbortFlag = FALSE;
  
  // install Prefetch Abort handler
  oldHandler = installHandler ( (Word)dataAbort_Handler, &dataAbort_Addr );

  defaultSlave = 0; // This causes a data abort exception

  // Wait for dataAbortFlag to be altered by the interrupt handler
  // If this doesn't occur with in INT_WAIT iterations flag an error
  {
    int i;
    for( i = 0; ( dataAbortFlag == FALSE ) && ( i < INT_WAIT ) ; i++ )
    {
      // wait loop
    }
  }
  
  // re-install default Data Abort handler
  installHandler ( oldHandler, &dataAbort_Addr );
      

  if ( dataAbortFlag == FALSE )
  {  
     return FAIL;
  }
  return PASS;
}


//----------------------------------------------------------------------------
// setDataAbortFlag()
// Callback function from dataAbort_Handler()
//
// Warning: There is no stack overflow checking.
// 
//----------------------------------------------------------------------------

void setDataAbortFlag( void )
{

  TEST_MSG("Data abort");
  dataAbortFlag = TRUE;
}

// end of file exception_tst.c


