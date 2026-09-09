/**
 *  omxVCM4P2_MEInit.c
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
 * Function: omxVCM4P2_MEInit
 *
 * Description:
 * Initializes the vendor-specific specification structure required for the following motion
 * estimation functions:  BlockMatch_Integer_8x8, BlockMatch_Integer_16x6, and MotionEstimateMB.
 * Memory for the specification structure *pMESpec must be allocated prior to calling the function,
 * and should be aligned on a 4-byte boundary.  The number of bytes required for the specification
 * structure can be determined using the function omxVCM4P2_MEGetBufSize.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	MEMode - motion estimation mode; available modes are defined by the enumerated type
 *                OMXVCM4P2MEMode
 * [in] pMEParams - motion estimation parameters
 * [in/out]	pMESpec - [in]  pointer to the uninitialized ME specification structure
 *                     [out] to the initialized ME specification structure
 *
 * Return Value:
 *	OMX_StsNoErr - no error
 *	OMX_StsBadArgErr - one or more of the following is true:
 *     - an invalid value was specified for the parameter MEMode
 *     - a negative or zero value was specified for the parameter pMEParams->searchRange
 *
 */

OMXResult omxVCM4P2_MEInit(
    OMXVCM4P2MEMode MEMode, 
    const OMXVCM4P2MEParams *pMEParams, 
    void *pMESpec
   )
{
    ARMVCM4P2_MESpec *armMESpec = (ARMVCM4P2_MESpec *) pMESpec;
    
    armRetArgErrIf(!pMEParams, OMX_StsBadArgErr);
    armRetArgErrIf(!pMESpec, OMX_StsBadArgErr);
    armRetArgErrIf((MEMode != OMX_VC_M4P2_FAST_SEARCH) && 
                   (MEMode != OMX_VC_M4P2_FULL_SEARCH), OMX_StsBadArgErr);
    armRetArgErrIf(pMEParams->searchRange <= 0, OMX_StsBadArgErr);
    
    armMESpec->MEParams.searchEnable8x8     = pMEParams->searchEnable8x8;
    armMESpec->MEParams.halfPelSearchEnable = pMEParams->halfPelSearchEnable;
    armMESpec->MEParams.searchRange         = pMEParams->searchRange;        
    armMESpec->MEParams.rndVal              = pMEParams->rndVal;
    armMESpec->MEMode                       = MEMode;
    
    return OMX_StsNoErr;
}

/* End of file */
