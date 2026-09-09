/**
 *
 *  omxIPPP_Moments_U8_C1R.c
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
 * Description  : Image Statistical Routine - Computes the moments of order 0 to 3 
 *                for the given ROI of an image from a single channel source.
 *
 */

#include "omxtypes.h"
#include "omxIP.h"
#include "armCOMM.h"
#include "armIP.h"

/**
 * Function: omxIPPP_Moments_U8_C1R
 *
 * Description:
 * Moment statistical function.
 *
 * Remarks:
 * Computes statistical spatial moments of order 0 to 3 for the ROI of the image pointed to by pSrc.
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to the source ROI
 * [in]  srcStep        distance in bytes between the starts of consecutive lines in the source image
 * [in]  roiSize        size of the ROI in pixels
 * [out] pState         pointer to the state structure
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPPP_Moments_U8_C1R(
     const OMX_U8* pSrc,
     OMX_INT srcStep,
     OMXSize roiSize,
     OMXMomentState* pState
     )
{
    OMX_INT roiWidth        = roiSize.width;
    OMX_INT roiHeight       = roiSize.height;
    const OMX_U8 *pSrcTemp  = pSrc;
    OMX_INT x, y, mOrd, nOrd;
    OMX_S64 curMoment, centreOfGravityX = 0, centreOfGravityY = 0;
    ARMIPPP_MomentState *pMomentState = (ARMIPPP_MomentState *)pState;
    
    armRetArgErrIf(!pMomentState, OMX_StsNullPtrErr);
    armRetArgErrIf(!pSrc, OMX_StsNullPtrErr);
    armRetArgErrIf(srcStep <= 0, OMX_StsSizeErr);
    armRetArgErrIf(roiSize.width <= 0, OMX_StsSizeErr);
    armRetArgErrIf(roiSize.height <= 0, OMX_StsSizeErr);

    pMomentState->maxValidChannel  = 0;
    
    for(mOrd = 0; mOrd < ARM_IPPP_MOMENTS_MAX_ORDER; mOrd++)
    {
        for(nOrd = 0; nOrd < ARM_IPPP_MOMENTS_MAX_ORDER; nOrd++)
        {
            pSrcTemp  = pSrc;
            curMoment = 0;
            for(y = 0; y < roiHeight; y++, pSrcTemp += srcStep)
            {
                for(x = 0; x < roiWidth; x++)
                {
                    curMoment += (armIPPP_Power(x, mOrd) * armIPPP_Power(y, nOrd) * pSrcTemp[x]);
                }
            }
            pMomentState->spMoments[0][mOrd][nOrd] = (OMX_S64)curMoment;
        }
    }
    
    if(pMomentState->spMoments[0][0][0])
    {
        centreOfGravityX = armRoundFloatToS64((OMX_F64)pMomentState->spMoments[0][1][0]/pMomentState->spMoments[0][0][0]);
        centreOfGravityY = armRoundFloatToS64((OMX_F64)pMomentState->spMoments[0][0][1]/pMomentState->spMoments[0][0][0]);
    }
    
    for(mOrd = 0; mOrd < ARM_IPPP_MOMENTS_MAX_ORDER; mOrd++)
    {
        for(nOrd = 0; nOrd < ARM_IPPP_MOMENTS_MAX_ORDER; nOrd++)
        {
            pSrcTemp = pSrc;
            curMoment = 0;
            for(y = 0; y < roiHeight; y++, pSrcTemp += srcStep)
            {
                for(x = 0; x < roiWidth; x++)
                {
                    curMoment += (armIPPP_Power(x-centreOfGravityX, mOrd) * 
                                  armIPPP_Power(y-centreOfGravityY, nOrd) * pSrcTemp[x]);
                }
            }
            pMomentState->ctMoments[0][mOrd][nOrd] = (OMX_S64)curMoment;
        }
    }

    return OMX_StsNoErr;
}

/* End of file */
