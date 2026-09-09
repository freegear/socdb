/**
 *
 *  omxIPPP_MomentGetStateSize.c
 * 
 * (c) Copyright 2005,2006 ARM Limited. All Rights Reserved.
 * 
 * THIS SOFTWARE IS PROVIDED “AS IS”, ARM EXPRESSLY DISCLAIMS ALL REPRESENTATIONS, 
 * WARRANTIES, CONDITIONS OR OTHER TERMS, EXPRESS, IMPLIED OR STATUTORY, INCLUDING 
 * WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, 
 * SATISFACTORY QUALITY, AND FITNESS FOR A PARTICULAR PURPOSE. 
 * 
 * Your use of this Software may require additional licenses, including but not 
 * limited to copyright and patent licenses from various entities. Should any 
 * such additional copyright, patent or other licenses be required, ARM expects 
 * that you will and you agree to obtain any such licenses at your own expense. 
 * You are solely responsible for obtaining any such licenses and the copyright 
 * licenses granted herein are conditioned on you obtaining such additional 
 * licenses.
 * 
 *
 * Description  : Image Statistics Routine - Initializes the Moment state structure.
 *
 */

#include "omxtypes.h"
#include "omxIP.h"
#include "armCOMM.h"
#include "armIP.h"

/**
 * Function: omxIPPP_MomentGetStateSize
 *
 * Description:
 * Get size of moment state structure.
 *
 * Remarks:
 * Get size of state structure in bytes; returned in *pSize.
 *
 *
 * Parameters:
 * [out] pSize          pointer to varible to hold the state size.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPPP_MomentGetStateSize(
        OMX_INT* pSize
       )
{
    armRetArgErrIf(!pSize, OMX_StsNullPtrErr);
    *pSize = (OMX_INT) sizeof(ARMIPPP_MomentState);
    return OMX_StsNoErr;
}

/* End of file */
