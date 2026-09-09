#if defined ( pcnt ) || defined ( alphant )
#pragma comment(exestr, "LAI_SVTAG_veriuser_c[] = @(#) veriuser.c[/main/12] ; Copyright(C)1999 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED" )
#else
static char LAI_SVTAG_veriuser_c[] = "@(#) veriuser.c[/main/12] ; Copyright(C)1999 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED";
#endif

/* $Author: yux $ */
/* $Date: 1999/03/15 17:27:55 $ */
/* $Source: /view/yux_mempro/prod/.extern/cpipe/cpipe_pli/src/veriuser.c $ */
/* $Revision: /main/12 $ */
/* $State: Exp $ */
/* $Locker:  $ */

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

#ifdef VERILOGXL
#  undef VERILOGXL
#endif

#ifndef TF_MAXARRAY
#  define TF_MAXARRAY
#endif

/*****************************************************************************
*   This is the `veriuser.c' file.  For more information about the contents
*   of this file, please see `veriuser.doc'.
*****************************************************************************/

#include "veriuser.h"

#include "vxl_veriuser.h"


char *veriuser_version_str = "";

/************************************/
/* extern PLI function declarations */
/************************************/
/* ------------- cut here - section 1 -------------- */
/* C-pipe interface */
extern int pli_slm_post();
extern int slm_mempro_handle();
extern int slm_mempro_width_info();
extern int slm_transport();
extern int slm_transport_checktf();
extern int slm_inertial();
extern int slm_inertial_checktf();
/* ------------- end section 1 -------------- */

int (*endofcompile_routines[TF_MAXARRAY])() = 
{
    /*** my_eoc_routine, ***/
    0 /*** final entry must be 0 ***/
};

bool err_intercept(level,facility,code)
int level; char *facility; char *code;
{ return(true); }

s_tfcell veriusertfs[TF_MAXARRAY] =
{
    /*** Template for an entry:
    { usertask|userfunction, data,
      checktf(), sizetf(), calltf(), misctf(),
      "$tfname", forwref?, Vtool?, ErrMsg? },
    Example:
    { usertask, 0, my_check, 0, my_func, my_misctf, "$my_task" },
    ***/

    /*** add user entries here ***/
/* ------------- cut here - section 2 -------------- */
        { usertask, 0, 0, 0, pli_slm_post,          0, "$slm_post_hdl",          true },
        { usertask, 0, 0, 0, pli_slm_post,          0, "$slm_post",              true },
        { usertask, 0, 0, 0, slm_mempro_handle,     0, "$slm_mempro_handle",     true },
        { usertask, 0, 0, 0, slm_mempro_width_info, 0, "$slm_mempro_width_info", true },
        { usertask, 0, slm_transport_checktf, 0, slm_transport, 0, "$slm_transport", true },
        { usertask, 0, slm_inertial_checktf, 0, slm_inertial, 0, "$slm_inertial", true },
/* ------------- end section 2 -------------- */
    {0} /*** final entry must be 0 ***/
};

