/**
 *
 *  omxIPBM_Copy_U8_C3R.c
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
 * Description  : Image initialization - Copying the image from a three channel source
 *
 */

#include "omxtypes.h"
#include "armCOMM.h"
    
OMXResult omxIPBM_Copy_U8_C3R(
        const OMX_U8* pSrc,
        OMX_INT srcStep, 
        OMX_U8* pDst,
        OMX_INT dstStep, 
        OMXSize roiSize
       )
{
    OMX_INT copyWidth   = 3 * roiSize.width;
    OMX_INT copyHeight  = roiSize.height;
    OMX_INT i, j;
    
    armRetArgErrIf(!pSrc, OMX_StsNullPtrErr);
    armRetArgErrIf(!pDst, OMX_StsNullPtrErr);
    armRetArgErrIf(srcStep < 0, OMX_StsStepErr);
    armRetArgErrIf(dstStep < 0, OMX_StsStepErr);
    armRetArgErrIf(roiSize.width <= 0, OMX_StsSizeErr);
    armRetArgErrIf(roiSize.height <= 0, OMX_StsSizeErr);
    
    for(i=0; i<copyHeight; i++, pSrc+=srcStep, pDst+=dstStep)
    {
        for(j = 0; j < copyWidth; j++)
        {
            pDst[j] = pSrc[j];
        }
    }
    
    return OMX_StsNoErr;
}

/* End of file */
