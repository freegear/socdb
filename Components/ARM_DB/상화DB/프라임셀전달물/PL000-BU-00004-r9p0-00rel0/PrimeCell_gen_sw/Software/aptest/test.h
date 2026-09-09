/*
 * Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2000,2001 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     test.h,v
 * Revision: 1.23
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : test.h.rca
 *  File Revision          : 1.9
 * 
 *  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
 *  ----------------------------------------
 *
 * Private header file for the Primecell test code.  Routines here can be replaced if other
 * debug media are required.
 */

#ifndef test_h
#define test_h

#ifdef	__cplusplus
extern "C" {	/* allow C++ to use these headers */
#endif	/* __cplusplus */

#include "../apcommon/aptypes.h"
#include "../apos/apos.h"

/*
 * Description:
 * This defines the number of progress steps for non-interactive waiting
 */
#define TEST_PROGRESS_STEPS 10

/*
 * Description:
 * This defines the use of the Integrator decoder status register to check for logic modules
 */
#define TEST_SC_DEC 0x11000010           //location of status register
#define TEST_SC_DEC_LM0 0x10            //mask for LM0

/*
 * Description:
 * Locations of the Primecell identifier registers
 */
#define TEST_PCELL_ID 0xFF0             //primecell id register at this address
#define TEST_PER_ID   0xFE0             //peripheral id register at this address
#define TEST_IS_PCELL 0xB105F00D        //device is a primecell

/*
 * Description:
 * This macro runs a memory test on a data item by writing _data to a 
 * variable of type _type and then retrieving from it.  It sets _flag
 * to false if the retrieved value is not the same as the written value.
 */
#define TEST_MEMCYCLE(_type,_data,_flag) \
        {volatile _type v;v=_data;_flag=(apTEST_eResult)(_flag&((v^(_data))==0));}

/*
 * Description:
 * This routine implements the printing of a test message. 
 * Rewrite this routine to redirect the messages to an output device (e.g. serial port) if required.
 *
 * Inputs:
 * pMessage - a string message to be displayed.
 *
 * Outputs:
 * none
 *
 * Return Value:
 * none
 */
PRIVATE void TEST_ImplementPrint(char * CONST pMessage);

/*
 * Description:
 * This routine implements waiting for a keypress from the user.
 * Rewrite this routine to redirect to an intput device (e.g. button) if required.
 *
 * Inputs:
 * none
 *
 * Outputs:
 * none
 *
 * Return Value:
 * none
 */
PRIVATE void TEST_ImplementWaitKey(void);

#ifdef __cplusplus
} /* allow C++ to use these headers */
#endif	/* __cplusplus */

#endif

