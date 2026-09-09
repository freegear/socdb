#if defined ( pcnt ) || defined ( alphant )
#pragma comment(exestr, "LAI_SVTAG_vpi_user_c[] = @(#) vpi_user.c[/main/1] ; Copyright(C)1999 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED" )
#else
static char LAI_SVTAG_vpi_user_c[] = "@(#) vpi_user.c[/main/1] ; Copyright(C)1999 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED";
#endif
/*
 * |-----------------------------------------------------------------------|
 * |                                                                       |
 * |   Copyright Cadence Design Systems, Inc. 1985, 1988.                  |
 * |     All Rights Reserved.       Licensed Software.                     |
 * |                                                                       |
 * |                                                                       |
 * | THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF CADENCE DESIGN SYSTEMS |
 * | The copyright notice above does not evidence any actual or intended   |
 * | publication of such source code.                                      |
 * |                                                                       |
 * |-----------------------------------------------------------------------|
 */

/*
 * |-------------------------------------------------------------|
 * |                                                             |
 * | PROPRIETARY INFORMATION, PROPERTY OF CADENCE DESIGN SYSTEMS |
 * |                                                             |
 * |-------------------------------------------------------------|
 */

#include "vpi_user.h"
#include "vpi_user_cds.h"

/* ------------- cut here - section 1 -------------- */
extern void cpipe_startup_routines();

/* ------------- end section 1 -------------- */

void (*vlog_startup_routines[])() = 
{
 /* ------------- cut here - section 2 -------------- */

        cpipe_startup_routines,
  	0 /*** final entry must be 0 ***/

 /* ------------- end section 2 -------------- */

};
