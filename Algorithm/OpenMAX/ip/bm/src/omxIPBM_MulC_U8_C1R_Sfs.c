/**
 *
 *  omxIPBM_MulC_U8_C1R_Sfs.c
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
 * Description  : Image arithmetic operation - Multiply every pixel in the 
 *                ROI of a single channel source image by a constant.
 *
 */

#include "omxtypes.h"
#include "armCOMM.h"

OMXResult omxIPBM_MulC_U8_C1R_Sfs(
        const OMX_U8* pSrc,
        OMX_INT srcStep,
        OMX_U8 value,
        OMX_U8* pDst,
        OMX_INT dstStep,
        OMXSize roiSize,
        OMX_INT scaleFactor
       )
{
    OMX_INT mulWidth    = roiSize.width;
    OMX_INT mulHeight   = roiSize.height;
    OMX_U16 round       = 0;
    OMX_INT i, j;

    armRetArgErrIf(!pSrc, OMX_StsNullPtrErr);
    armRetArgErrIf(!pDst, OMX_StsNullPtrErr);
    armRetArgErrIf(srcStep < 0, OMX_StsStepErr);
    armRetArgErrIf(dstStep < 0, OMX_StsStepErr);
    armRetArgErrIf(roiSize.width <= 0, OMX_StsSizeErr);
    armRetArgErrIf(roiSize.height <= 0, OMX_StsSizeErr);
    armRetArgErrIf(scaleFactor < 0, OMX_StsSizeErr);
    
    if(scaleFactor)
    {
        round   = 1 << (scaleFactor - 1);   
    }

    for(i=0; i<mulHeight; i++, pSrc+=srcStep, pDst+=dstStep)
    {
        for(j=0; j<mulWidth; j++)
        {
            pDst[j] = (OMX_U8) armClip(OMX_MIN_U8, OMX_MAX_U8, (pSrc[j] * value + round) >> scaleFactor);
        }
    }    
    return OMX_StsNoErr;
}

/* End of file */
