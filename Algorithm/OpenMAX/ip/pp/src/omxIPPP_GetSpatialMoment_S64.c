/**
 *
 *  omxIPPP_GetSpatialMoment_S64.c
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
 * Description  : Image Statistical Routine - Returns nOrd by mOrd spatial moment 
 *                calculated by omxIP_Moments_U8_CxR() functions, beforehand.
 *
 */

#include "omxtypes.h"
#include "omxIP.h"
#include "armCOMM.h"
#include "armIP.h"

/**
 * Function: omxIPPP_GetSpatialMoment_S64
 *
 * Description:
 * Spatial moment function.
 *
 * Remarks:
 * Returns nOrd by mOrd spatial moment calculated by omxiMoments64s ( ) function. Place the
 * scaled result into the memory pointed to by pValue.
 *
 *
 * Parameters:
 * [in]  mOrd           moment specifier
 * [in]  nOrd           moment specifier
 * [in]  pState         pointer to the state structure
 * [in]  nChannel       specify the image channel number
 * [in]  roiOffset      ROI location
 * [in]  pValue         pointer to the variable required moment value to be stored. Function returns value
 * [in]  scaleFactor    value of the scale factor
 * [out] pValue         pointer to the computed moment value
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPPP_GetSpatialMoment_S64(
     const OMXMomentState *pState,
     OMX_INT mOrd,
     OMX_INT nOrd,
     OMX_INT nChannel,
     OMXPoint roiOffset,
     OMX_S64* pValue,
     OMX_INT scaleFactor
     )
{
    OMX_INT  xOff = roiOffset.x, yOff = roiOffset.y;
    OMX_INT  i, j;
    ARMIPPP_MomentState *pMomentState = (ARMIPPP_MomentState *)pState;
    
    armRetArgErrIf(!pMomentState, OMX_StsNullPtrErr);
    armRetArgErrIf(!pValue, OMX_StsNullPtrErr);
    armRetArgErrIf((nChannel < 0) || (nChannel > 2) || (nChannel > pMomentState->maxValidChannel), OMX_StsChannelErr);
    armRetArgErrIf((mOrd < 0) || (mOrd > ARM_IPPP_MOMENTS_MAX_ORDER-1), OMX_StsSizeErr);
    armRetArgErrIf((nOrd < 0) || (nOrd > ARM_IPPP_MOMENTS_MAX_ORDER-1), OMX_StsSizeErr);

    if((xOff == 0) && (yOff == 0))
    {
        *pValue = pMomentState->spMoments[nChannel][mOrd][nOrd];
        *pValue = armSatRoundLeftShift_S64(*pValue, -scaleFactor);
        return OMX_StsNoErr;
    }

    /**
    ----------------------------------------------------------------------------------
    To compute the moments for non-zero offsets (xOff,yOff), we'll have to solve
    M(p,q,xOff,yOff) = Sum_(x,y)_of [(x-xOff)^p * (y-yOff)^q * f(x,y)]
    
    To solve this, we expand the first two factors using binomial expansion 
    (with 0 <= p,q <= 4) and then multiply them to get a series of Terms as in,
    M(p,q,xOff,yOff) = Sum_(x,y)_of [(T1+T2+T3+...+T16) * f(x,y)]
    
    On expanding, this equation becomes
    M(p,q,xOff,yOff) = Sum_(x,y)_of [T1 * f(x,y)] + ... + Sum_(x,y)_of [T16 * f(x,y)]
    where, each Term Tn is a factor of (a power of x, a power of y and a constant).
    If we pull the constant out of each summation, each of the 16 terms of the moments 
    equation M(p,q,xOff,yOff) can be written as: (constant * moment of some order).
    
    This idea is implemented in the following code, where
    (1) Firstly, we compute the terms Tn, which are nothing but binomial coefficients 
        of the moments equation for the given order (p,q).
    (2) Then, multiply each coefficient with its corresponding moment value and
        continue to accumulate, until we're done with all of them.

    ----------------------------------------------------------------------------------
    */
    
    for(i = 0, *pValue = 0; i <= mOrd; i++)
    {
        for(j = 0; j <= nOrd; j++)
        {
            *pValue += (pMomentState->spMoments[nChannel][i][j] * armIPPP_ComputeBinomialCoeff(mOrd, nOrd, i, j, -xOff, -yOff));
        }
    }
    
    *pValue = armSatRoundLeftShift_S64(*pValue, -scaleFactor);
    return OMX_StsNoErr;
}

/* End of file */
