/**
 *
 *  omxIPPP_Moments_U8_C3R.c
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
 *                for the given ROI of an image from a three channel source.
 *
 */

#include "omxtypes.h"
#include "omxIP.h"
#include "armCOMM.h"
#include "armIP.h"

/**
 * Function: omxIPPP_Moments_U8_C3R
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

OMXResult omxIPPP_Moments_U8_C3R(
     const OMX_U8* pSrc,
     OMX_INT srcStep,
     OMXSize roiSize,
     OMXMomentState* pState
     )
{
    OMX_INT roiWidth    = 3 * roiSize.width;
    OMX_INT roiHeight   = roiSize.height;
    OMX_INT x, y, mOrd, nOrd;
    const OMX_U8 *pSrcTemp = pSrc;
    OMX_S64 curMoment0, curMoment1, curMoment2;
    OMX_S64 xCentreOfGravity0 = 0, xCentreOfGravity1 = 0, xCentreOfGravity2 = 0;
    OMX_S64 yCentreOfGravity0 = 0, yCentreOfGravity1 = 0, yCentreOfGravity2 = 0;
    ARMIPPP_MomentState *pMomentState = (ARMIPPP_MomentState *)pState;

    armRetArgErrIf(!pMomentState, OMX_StsNullPtrErr);
    armRetArgErrIf(!pSrc, OMX_StsNullPtrErr);
    armRetArgErrIf(srcStep <= 0, OMX_StsSizeErr);
    armRetArgErrIf(roiSize.width <= 0, OMX_StsSizeErr);
    armRetArgErrIf(roiSize.height <= 0, OMX_StsSizeErr);

    pMomentState->maxValidChannel  = 2;
    
    for(mOrd = 0; mOrd < ARM_IPPP_MOMENTS_MAX_ORDER; mOrd++)
    {
        for(nOrd = 0; nOrd < ARM_IPPP_MOMENTS_MAX_ORDER; nOrd++)
        {
            pSrcTemp   = pSrc;
            curMoment0 = curMoment1 = curMoment2 = 0;
            for(y = 0; y < roiHeight; y++, pSrcTemp += srcStep)
            {
                for(x = 0; x < roiWidth; x += 3)
                {
                    curMoment0 += (armIPPP_Power(x/3, mOrd) * armIPPP_Power(y, nOrd) * pSrcTemp[x]);
                    curMoment1 += (armIPPP_Power(x/3, mOrd) * armIPPP_Power(y, nOrd) * pSrcTemp[x+1]);
                    curMoment2 += (armIPPP_Power(x/3, mOrd) * armIPPP_Power(y, nOrd) * pSrcTemp[x+2]);
                }
            }
            pMomentState->spMoments[0][mOrd][nOrd] = (OMX_S64)curMoment0;
            pMomentState->spMoments[1][mOrd][nOrd] = (OMX_S64)curMoment1;
            pMomentState->spMoments[2][mOrd][nOrd] = (OMX_S64)curMoment2;
        }
    }
    
    if(pMomentState->spMoments[0][0][0])
    {
        xCentreOfGravity0 = armRoundFloatToS64((OMX_F64)pMomentState->spMoments[0][1][0]/pMomentState->spMoments[0][0][0]);
        yCentreOfGravity0 = armRoundFloatToS64((OMX_F64)pMomentState->spMoments[0][0][1]/pMomentState->spMoments[0][0][0]);
    }
    
    if(pMomentState->spMoments[1][0][0])
    {
        xCentreOfGravity1 = armRoundFloatToS64((OMX_F64)pMomentState->spMoments[1][1][0]/pMomentState->spMoments[1][0][0]);
        yCentreOfGravity1 = armRoundFloatToS64((OMX_F64)pMomentState->spMoments[1][0][1]/pMomentState->spMoments[1][0][0]);
    }
    
    if(pMomentState->spMoments[2][0][0])
    {
        xCentreOfGravity2 = armRoundFloatToS64((OMX_F64)pMomentState->spMoments[2][1][0]/pMomentState->spMoments[2][0][0]);
        yCentreOfGravity2 = armRoundFloatToS64((OMX_F64)pMomentState->spMoments[2][0][1]/pMomentState->spMoments[2][0][0]);
    }

    for(mOrd = 0; mOrd < ARM_IPPP_MOMENTS_MAX_ORDER; mOrd++)
    {
        for(nOrd = 0; nOrd < ARM_IPPP_MOMENTS_MAX_ORDER; nOrd++)
        {
            pSrcTemp   = pSrc;
            curMoment0 = curMoment1 = curMoment2 = 0;
            for(y = 0; y < roiHeight; y++, pSrcTemp += srcStep)
            {
                for(x = 0; x < roiWidth; x += 3)
                {
                    curMoment0 += (armIPPP_Power((x/3 - xCentreOfGravity0), mOrd) * 
                                   armIPPP_Power((y   - yCentreOfGravity0), nOrd) * pSrcTemp[x]);
                    curMoment1 += (armIPPP_Power((x/3 - xCentreOfGravity1), mOrd) * 
                                   armIPPP_Power((y   - yCentreOfGravity1), nOrd) * pSrcTemp[x+1]);
                    curMoment2 += (armIPPP_Power((x/3 - xCentreOfGravity2), mOrd) * 
                                   armIPPP_Power((y   - yCentreOfGravity2), nOrd) * pSrcTemp[x+2]);
                }
            }
            pMomentState->ctMoments[0][mOrd][nOrd] = (OMX_S64)curMoment0;
            pMomentState->ctMoments[1][mOrd][nOrd] = (OMX_S64)curMoment1;
            pMomentState->ctMoments[2][mOrd][nOrd] = (OMX_S64)curMoment2;
        }
    }

    return OMX_StsNoErr;
}

/* End of file */
