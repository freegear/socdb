/**
 *  omxVCM4P10_MEGetBufSize.c
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
 * Description:
 * Initialization modules for the vendor specific Motion Estimation structure.
 * 
 */

#include "omxVC.h"
#include "armVC.h"
#include "armCOMM.h"

/**
 * Function: omxVCM4P10_MEGetBufSize
 *
 * Description:
 * Computes the size, in bytes, of the vendor-specific specification structure for the
 * omxVCM4P10 motion estimation functions BlockMatch_Integer and MotionEstimationMB.
 *
 * Remarks:
 *
 * Parameters:
 *	[in] MEMode   motion estimation mode; available modes are defined by the enumerated
 *                 type OMXVCM4P10MEMode
 *	[in] pMEParams  motion estimation parameters
 *  [out]pSize   pointer to the number of bytes required for the motion estimation specification structure
 *
 * Return Value:
 *	OMX_StsNoErr - no error
 *	OMX_StsBadArgErr - one or more of the following is true:
 *     - an invalid value was specified for the parameter MEMode
 *     - a negative or zero value was specified for the SearchRanges(16x16, 8x8, 4x4) in pMBOptions
 */

OMXResult omxVCM4P10_MEGetBufSize(
    OMXVCM4P10MEMode MEMode,
    const OMXVCM4P10MEParams *pMEParams,
    OMX_U32 *pSize
    )
{
    armRetArgErrIf(!pMEParams, OMX_StsBadArgErr);
    armRetArgErrIf(!pSize, OMX_StsBadArgErr);
    armRetArgErrIf((MEMode != OMX_VC_M4P10_FAST_SEARCH) && 
                   (MEMode != OMX_VC_M4P10_FULL_SEARCH), OMX_StsBadArgErr);
    armRetArgErrIf((pMEParams->searchRange16x16 <= 0) || 
                   (pMEParams->searchRange8x8 <= 0) || 
                   (pMEParams->searchRange4x4 <= 0), OMX_StsBadArgErr);
                   
    *pSize = (OMX_INT) sizeof(ARMVCM4P10_MESpec);
    
    return OMX_StsNoErr;
}

/* End of file */
