static char LAI_SVTAG_vss_dummy_calls_c[] = "@(#) vss_dummy_calls.c[/main/1] ; Copyright(C)1997 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED";

/*******************************************************************************
 *
 *  File: vss_dummy_calls.c 
 *
 *  Desc: This file contains a function that makes cli calls so that the 
 *        necessary cli libraries are linked in.
 *
 *******************************************************************************/

#include <stdio.h>
#include "cli.h"

/* ======================================================================
 *
 *   Make calls to CLI entry points so that CLI libraries are linked in.
 *
 * ====================================================================== */

static void vss_dummy_calls
(
    void
)
{
    cliVALUE* value = cliGetParameterValue( (void*)0, 0 );
    cliSetReturnValue( (void*)0, value );
}

