/**
 *
 *  omxIPPP_GetCentralMoment_S64.c
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
 * Description  : Image Statistical Routine - Returns nOrd by mOrd central moment 
 *                calculated by omxIP_Moments_U8_CxR() functions, beforehand.
 *
 */

#include "omxtypes.h"
#include "omxIP.h"
#include "armCOMM.h"
#include "armIP.h"

/**
 * Function: omxIPPP_GetCentralMoment_S64
 *
 * Description:
 * Central moment function.
 *
 * Remarks:
 * Returns specified by nOrd and mOrd central moment calculated by omxiMoments 64s ( ) function.
 * Place the scaled result into the memory pointed to by pValue.
 *
 *
 * Parameters:
 * [in]  pState         pointer to the state structure
 * [in]  mOrd           specify the required spatial moment
 * [in]  nOrd           specify the required spatial moment
 * [in]  nChannel       specify the image channel number
 * [in]  scaleFactor    value of the scale factor
 * [out] pValue         pointer to the computed moment value
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPPP_GetCentralMoment_S64(
     const OMXMomentState *pState,
     OMX_INT mOrd,
     OMX_INT nOrd,
     OMX_INT nChannel,
     OMX_S64* pValue,
     OMX_INT scaleFactor
     )
{
    ARMIPPP_MomentState *pMomentState = (ARMIPPP_MomentState *)pState;
    
    armRetArgErrIf(!pMomentState, OMX_StsNullPtrErr);
    armRetArgErrIf(!pValue, OMX_StsNullPtrErr);
    armRetArgErrIf((nChannel < 0) || (nChannel > 2) || (nChannel > pMomentState->maxValidChannel), OMX_StsChannelErr);
    armRetArgErrIf((mOrd < 0) || (mOrd > ARM_IPPP_MOMENTS_MAX_ORDER-1), OMX_StsSizeErr);
    armRetArgErrIf((nOrd < 0) || (nOrd > ARM_IPPP_MOMENTS_MAX_ORDER-1), OMX_StsSizeErr);
    
    *pValue = pMomentState->ctMoments[nChannel][mOrd][nOrd];
    *pValue = armSatRoundLeftShift_S64(*pValue, -scaleFactor);
    return OMX_StsNoErr;
}

/* End of file */
