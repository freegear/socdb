/**
 *
 *  omxIPBM_Mirror_U8_C1R.c
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
 * Description  : Image Geometric Transform - Mirror the image about the given axis.
 *                The source is in single-channel format and pixel domain, and
 *                the destination in single-channel format and pixel domain.
 *
 */

#include "omxtypes.h"
#include "omxIP.h"
#include "armCOMM.h"

OMXResult omxIPBM_Mirror_U8_C1R(
        const OMX_U8 *pSrc,
        OMX_INT srcStep,
        OMX_U8 *pDst,
        OMX_INT dstStep,
        OMXSize roiSize,
        OMXIPAxis flip
       )
{
    OMX_S32 mirWidth    = roiSize.width;
    OMX_S32 mirHeight   = roiSize.height;
    OMX_INT i, j;
    OMX_U8  *pCurDst;
    const OMX_U8 *pCurSrc;

    armRetArgErrIf(!pSrc, OMX_StsNullPtrErr);
    armRetArgErrIf(!pDst, OMX_StsNullPtrErr);
    armRetArgErrIf(srcStep < 0, OMX_StsStepErr);
    armRetArgErrIf(dstStep < 0, OMX_StsStepErr);
    armRetArgErrIf(roiSize.width <= 0, OMX_StsSizeErr);
    armRetArgErrIf(roiSize.height <= 0, OMX_StsSizeErr);
    armRetArgErrIf((flip != OMX_IP_VERTICAL) && (flip != OMX_IP_HORIZONTAL) && (flip != OMX_IP_BOTH), OMX_StsMirrorFlipErr);

    /*
    -------------------------------------------------------------------------------
    Mirroring about the Vertical axis always happens first and hence, pSrc and pDst 
    are never aliased. But for mirroring about the Horizontal axis, pSrc and pDst 
    can be aliased (if mirroring along both axes) or not aliased (if mirroring 
    along Horizontal axis only). Hence, these cases are handled separately.
    -------------------------------------------------------------------------------
    */
    
    if((flip == OMX_IP_VERTICAL) || (flip == OMX_IP_BOTH))
    {
        pCurSrc = pSrc;
        pCurDst = pDst;
        
        for(i = 0; i < mirHeight; i++, pCurSrc += srcStep, pCurDst += dstStep)
        {
            for(j = 0; j < mirWidth; j++)
            {
                pCurDst[j] = pCurSrc[mirWidth-j-1];
            }
        }
    }
    
    else if(flip == OMX_IP_HORIZONTAL)
    {
        pCurSrc = pSrc;
        pCurDst = pDst + (mirHeight-1) * dstStep;
        
        for(i = 0; i < mirHeight; i++, pCurSrc += srcStep, pCurDst -= dstStep)
        {
            for(j = 0; j < mirWidth; j++)
            {
                pCurDst[j] = pCurSrc[j];
            }
        }
    }
    
    if(flip == OMX_IP_BOTH)
    {
        OMX_U8 *pNewSrc = pDst;
        pCurDst         = pDst + (mirHeight-1) * dstStep;
        
        for(i = 0; i < mirHeight/2; i++, pNewSrc += srcStep, pCurDst -= dstStep)
        {
            for(j = 0; j < mirWidth; j++)
            {
                armSwapElem((pNewSrc + j), (pCurDst + j), 1);
            }
        }
    }
    
    return OMX_StsNoErr;
}

/* End of file */
