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
//  File Name           :globals.h,v
//  File Revision       :1.23
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Common Include File
//
//--========================================================================--

#ifndef GLOBALS_H
#define GLOBALS_H


//------------------------------------------------------------------------
// Global Defines, Typedefs and Macros
//------------------------------------------------------------------------

// Controls the level of detail about the tests.
// Text indent levels less than this value will be printed
//
// For global pass/fail test result only, use the following value:
//#define VERBOSE_LEVEL 1
//
// The following value gives information at a block-by-block level:
#define VERBOSE_LEVEL 2
//
// For in-depth information, one may use a large value, e.g.:
//#define VERBOSE_LEVEL 9

// Indents text in steps of two spaces 
#define INDENT( indent ) printf( "%*s", indent * 2, "" )

// Checks for indent level and if allowed prints message and value
// using printf
// The message string should include the printf format specifier
#define TEST_REPORT( msg, val )  \
    if( textIndent < VERBOSE_LEVEL ) { \
    INDENT( textIndent ); printf( msg "\n", val ); } 

// Checks for indent level and if allowed prints message using printf 
#define TEST_MSG( msg )   if( textIndent < VERBOSE_LEVEL ) { \
    INDENT( textIndent ); printf( msg"\n" ); }

// Macro to execute a test routine and quit testing on error
#define DO_TEST( x, msg, status )  \
  TEST_MSG( msg ); \
  textIndent++; \
  switch ( x ) { \
  case PASS: textIndent--; TEST_MSG( ":PASS" ); break; \
  case FAIL: textIndent--; TEST_MSG( ":* FAIL *" ); status = FAIL; break; \
  case UNKNOWN: textIndent--; TEST_MSG( ":UNKNOWN\n" ); break; \
  default: textIndent--; \
    TEST_MSG( ":*** ERROR: Unexpected value returned from test ***\n" ); \
    status = FAIL; break; \
  }  

// Macro to check  for desired result
#define DO_CHECK( x, z, msg, status )   \
  TEST_MSG( msg ); \
  textIndent++; \
  if ( x == z ) { textIndent--; TEST_MSG( ":PASS" ); }\
  else { textIndent--; TEST_MSG( ":* FAIL *" ); status = FAIL; }\
  

// Indicates that the parameter is not used (to supress compiler errors)
#define IGNORE(v) ((void)(v))


// Typedefs

typedef unsigned char           Byte;
typedef unsigned short int      HalfWord;
typedef unsigned long int       Word;

typedef enum
{
  FALSE = 0, 
  TRUE = 1,

  BOOL_USE32BIT = 0x7FFFFFFF // forces compiler to use Word
} 
Boolean;


typedef enum 
{
  FAIL = 0,
  PASS = 1,
  UNKNOWN = 2,
  
  TEST_USE32BIT = 0x7FFFFFFF // forces compiler to use Word
} TestStatus;

//------------------------------------------------------------------------
// Global variable extern defs
//------------------------------------------------------------------------

extern volatile Boolean pauseFlag;
extern volatile Boolean undefinedFlag;
extern volatile Boolean swiFlag;
extern volatile Boolean prefetchAbortFlag;
extern volatile Boolean dataAbortFlag;

extern volatile Boolean softIrqFlag;
extern volatile Boolean timer1IrqFlag;
extern volatile Boolean timer2IrqFlag;
extern volatile Boolean timersIrqFlag;
extern volatile Boolean wdogIrqFlag;
extern volatile Boolean gpio0IrqFlag;
extern volatile Boolean gpio1IrqFlag;
extern volatile Boolean gpio2IrqFlag;
extern volatile Boolean gpio3IrqFlag;
extern volatile Boolean gpio4IrqFlag;
extern volatile Boolean gpio5IrqFlag;
extern volatile Boolean gpio6IrqFlag;
extern volatile Boolean gpio7IrqFlag;
extern volatile Boolean gpioIrqFlag;
extern volatile Boolean uartIrqFlag;
extern volatile Boolean dmacIrqFlag;

extern volatile Boolean softFiqFlag;
extern volatile Boolean timer1FiqFlag;
extern volatile Boolean timer2FiqFlag;
extern volatile Boolean timersFiqFlag;
extern volatile Boolean wdogFiqFlag;
extern volatile Boolean gpio0FiqFlag;
extern volatile Boolean gpio1FiqFlag;
extern volatile Boolean gpio2FiqFlag;
extern volatile Boolean gpio3FiqFlag;
extern volatile Boolean gpio4FiqFlag;
extern volatile Boolean gpio5FiqFlag;
extern volatile Boolean gpio6FiqFlag;
extern volatile Boolean gpio7FiqFlag;
extern volatile Boolean gpioFiqFlag;


extern volatile TestStatus remapTestFlag;
extern volatile Boolean wdogResetFlag;
extern TestStatus testStatus;

extern int textIndent;

#endif // defined( GLOBALS_H )

// end of file globals.h
