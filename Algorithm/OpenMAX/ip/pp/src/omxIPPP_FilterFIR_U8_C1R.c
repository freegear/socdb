/**
 *  omxIPPP_FilterFIR_U8_C1R.c
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
 * This file contains module for 2 dimensional filtering 
 *
 */

#include "omxtypes.h"
#include "omxIP.h"

#include "armCOMM.h"

static OMX_S32 armIPPP_Mac(
        OMX_S32 mac,
        OMX_S32 filtCoeff,
        OMX_U8 input
);


/**
 * Function: omxIPPP_Filter_U8_C1R
 *
 * Description:
 * Filter single-channel image.
 *
 * Remarks:
 * Performs filtering of the ROI of the source image pointed to by pSrc using a general rectangular
 * (WxH size) convolution kernel. The value of the output pixel is normalized by the divider and
 * saturated.
 * Place the result into the ROI of the destination image pointed to by pDst.
 * single¨Cchannel (gray) image
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to the source ROI
 * [in]  srcStep        step in bytes through the source image
 * [in]  dstStep        step in bytes through the destination image
 * [in]  roiSize        size of the source and destination ROI in pixels
 * [in]  pKernel        pointer to the 2D FIR filter taps
 * [in]  kernelSize     size of the FIR filter
 * [in]  anchor         anchor cell specifying the array of filter taps alignment with respect to the position
 *                            of the input pixel
 * [in]  divider        size of the source and destination ROI in pixels
 * [out] pDst           pointer to the destination ROI
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPPP_FilterFIR_U8_C1R(
     const OMX_U8* pSrc,
     OMX_INT srcStep,
     OMX_U8* pDst,
     OMX_INT dstStep,
     OMXSize roiSize,
     const OMX_S32* pKernel,
     OMXSize kernelSize,
     OMXPoint anchor,
     OMX_INT divider        
 )
{
    OMX_INT width,height;
    OMX_INT kerWidth,kerHeight;
    OMX_INT ax,ay;
    
    OMX_INT i,j,m,n;
    
    OMX_F32 div;
    OMX_S32 result,mac;
    
    const OMX_S32 *pKerTemp;
    const OMX_U8  *pSrcTemp;
    
    /* Argument Check */
    armRetArgErrIf(!pDst   , OMX_StsNullPtrErr);
    armRetArgErrIf(!pSrc   , OMX_StsNullPtrErr);
    armRetArgErrIf(!pKernel, OMX_StsNullPtrErr);
    
    armRetArgErrIf(srcStep <= 0, OMX_StsStepErr);
    armRetArgErrIf(dstStep <= 0, OMX_StsStepErr);
    
    armRetArgErrIf(roiSize.width  <= 0, OMX_StsSizeErr);
    armRetArgErrIf(roiSize.height <= 0, OMX_StsSizeErr);

    armRetArgErrIf(kernelSize.width <= 0 , OMX_StsSizeErr);
    armRetArgErrIf(kernelSize.height <= 0, OMX_StsSizeErr);

    armRetArgErrIf(anchor.x < 0, OMX_StsAnchorErr);
    armRetArgErrIf(anchor.y < 0, OMX_StsAnchorErr);

    armRetArgErrIf(anchor.x >= kernelSize.width , OMX_StsAnchorErr);
    armRetArgErrIf(anchor.y >= kernelSize.height, OMX_StsAnchorErr);

    armRetArgErrIf(divider == 0, OMX_StsBadArgErr);

    /* Processing */
    width  = roiSize.width;
    height = roiSize.height;
    
    kerWidth  = kernelSize.width;
    kerHeight = kernelSize.height;
    
    ax = anchor.x;
    ay = anchor.y;
    
    div = (OMX_F32)divider;
    
    for(n = 0 ; n < height ; n++)
    {
        for(m = 0 ; m < width ; m++)
        {
            pSrcTemp = pSrc + m + ax + ay * srcStep; /*pSrc(m + ax,n + ay)*/
            pKerTemp = pKernel;
            mac      = 0;
                                    
            /* Compute the Output */    
            for( j = 0; j < kerHeight ; j++)
            {
                for( i = 0; i < kerWidth ; i++)
                {
                     mac = armIPPP_Mac(mac,pKerTemp[i],pSrcTemp[-i]); 
                }
                
                pSrcTemp -= srcStep;
                pKerTemp += kerWidth;
            }
            
            /*Store the Output*/
            result = armRoundFloatToS32(mac / div);
            result = armClip (0,255,result);
        
            pDst[m] = (OMX_U8)result; 
        }

        pDst += dstStep;
        pSrc += srcStep;
    }

    return OMX_StsNoErr;
}

static OMX_S32 armIPPP_Mac(OMX_S32 mac, OMX_S32 filtCoeff,OMX_U8 input)
{
    
    OMX_S16 hi;
    OMX_U16 lo;
    
    OMX_S32 result;
    
    /* Multiply Operation */
    hi = (OMX_S16)( filtCoeff >> 16);
    lo = (OMX_U16)( (OMX_U32)(filtCoeff << 16) >> 16 );
    
    result  = (hi * input) << 8;
    result += (lo * input) >> 8;
    
    if( result > ( (OMX_S32)OMX_MAX_S32 >> 8) )
    {
        result = OMX_MAX_S32;
    }
    else if(result < ( (OMX_S32)OMX_MIN_S32 >> 8) )
    {
        result = OMX_MIN_S32;
    }
    else
    {
        result = filtCoeff * input;
    }
    
    /* Accumulate Operation */
     result = armSatAdd_S32(mac, result);
     
    return result;
}

/* End of File */

