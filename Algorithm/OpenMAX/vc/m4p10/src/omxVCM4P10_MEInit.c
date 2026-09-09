/**
 *  omxVCM4P10_MEInit.c
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
 * Function: omxVCM4P10_MEInit
 *
 * Description:
 * Initializes the vendor-specific specification structure required for the omxVCM4P10 motion
 * estimation functions BlockMatch_Integer and MotionEstimationMB.  Memory for the specification
 * structure *pMESpec must be allocated prior to calling the function, and should be aligned on
 * a 4-byte boundary.  The number of bytes required for the specification structure can be
 * determined using the function omxVCM4P10_MEGetBufSize.Following initialization by this function, the vendor-specific
 * structure *pMESpec should contain an implementation-specific representation of all motion estimation
 * parameters received via the structure pMEParams, for example searchRange16x16,
 * searchRange8x8, etc.
 *
 * Remarks:
 *
 * Parameters:
 * [in]  MEMode   motion estimation mode; available modes are defined by the enumerated type OMXVCM4P10MEMode
 * [in]	 pMEParams   motion estimation parameters
 * [out] pMESpec   pointer to the initialized ME specification structure
 *
 * Return Value:
 *	OMX_StsNoErr - no error
 *	OMX_StsBadArgErr - one or more of the following is true:
 *     - an invalid value was specified for the parameter MEMode
 *     - a negative or zero value was specified for the SearchRanges(16x16, 8x8, 4x4) in pMBOptions
 *
 */

OMXResult omxVCM4P10_MEInit(
        OMXVCM4P10MEMode MEMode,
        const OMXVCM4P10MEParams *pMEParams,
        void *pMESpec
       )
{
    ARMVCM4P10_MESpec *armMESpec = (ARMVCM4P10_MESpec *) pMESpec;
    
    armRetArgErrIf(!pMEParams, OMX_StsBadArgErr);
    armRetArgErrIf(!pMESpec, OMX_StsBadArgErr);
    armRetArgErrIf((MEMode != OMX_VC_M4P10_FAST_SEARCH) && 
                   (MEMode != OMX_VC_M4P10_FULL_SEARCH), OMX_StsBadArgErr);
    armRetArgErrIf((pMEParams->searchRange16x16 <= 0) || 
                   (pMEParams->searchRange8x8 <= 0) || 
                   (pMEParams->searchRange4x4 <= 0), OMX_StsBadArgErr);
    
    armMESpec->MEParams.blockSplitEnable8x8 = pMEParams->blockSplitEnable8x8;
    armMESpec->MEParams.blockSplitEnable4x4 = pMEParams->blockSplitEnable4x4;
    armMESpec->MEParams.halfSearchEnable    = pMEParams->halfSearchEnable;
    armMESpec->MEParams.quarterSearchEnable = pMEParams->quarterSearchEnable;
    armMESpec->MEParams.intraEnable4x4      = pMEParams->intraEnable4x4;     
    armMESpec->MEParams.searchRange16x16    = pMEParams->searchRange16x16;   
    armMESpec->MEParams.searchRange8x8      = pMEParams->searchRange8x8;
    armMESpec->MEParams.searchRange4x4      = pMEParams->searchRange4x4;
    armMESpec->MEMode                       = MEMode;
    
    return OMX_StsNoErr;
}

/* End of file */
