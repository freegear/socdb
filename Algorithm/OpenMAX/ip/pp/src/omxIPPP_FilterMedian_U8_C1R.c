/**
 *  omxIPPP_FilterMedian_U8_C1R.c
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
 * This file contains module for single channel median filtering
 *
 */

#include "omxtypes.h"
#include "omxIP.h"

#include "armIP.h"
#include "armCOMM.h"

/**
 * Function: omxIPPP_FilterMedian_U8_C1R
 *
 * Description:
 * Filter single-channel image.
 *
 * Remarks:
 * Performs median filtering of the ROI of the source image pointed to by pSrc using the median
 * filter of the size maskSize and location anchor. Place the result into the ROI of the destination
 * image pointed to by pDst.
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to the source ROI
 * [in]  srcStep        step in bytes through the source image
 * [in]  dstStep        step in bytes through the destination image
 * [in]  roiSize        size of the source and destination ROI in pixels
 * [in]  maskSize       size of the mask in pixels
 * [in]  anchor         anchor cell specifying the mask alignment with respect to the position of the input
 *                            pixel
 * [out] pDst           pointer to the destination ROI
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPPP_FilterMedian_U8_C1R(
     const OMX_U8* pSrc,
     OMX_INT srcStep,
     OMX_U8* pDst,
     OMX_INT dstStep,
     OMXSize roiSize,
     OMXSize maskSize,
     OMXPoint anchor        
 )
{
    OMX_INT width,height;
    OMX_INT maskWidth,maskHeight;
    OMX_INT maskLength,maskByTwo;
    
    OMX_INT ax,ay;
    OMX_INT i,j,m,n;

    OMX_U8 buffer[(ARM_IPPP_MAX_MASK_SIZE)*(ARM_IPPP_MAX_MASK_SIZE)];
    
    OMX_U8 *pBuffer,temp;
    const OMX_U8  *pSrcTemp;
    
    /* Argument Check */
    armRetArgErrIf(!pDst   , OMX_StsNullPtrErr)
    armRetArgErrIf(!pSrc   , OMX_StsNullPtrErr)
    
    armRetArgErrIf(srcStep <= 0, OMX_StsStepErr)
    armRetArgErrIf(dstStep <= 0, OMX_StsStepErr)
    
    armRetArgErrIf(roiSize.width  <= 0, OMX_StsSizeErr)
    armRetArgErrIf(roiSize.height <= 0, OMX_StsSizeErr)

    armRetArgErrIf( (maskSize.width  & 1) == 0 , OMX_StsMaskSizeErr)
    armRetArgErrIf( (maskSize.height & 1) == 0 , OMX_StsMaskSizeErr)
    
    armRetArgErrIf(maskSize.width  > ARM_IPPP_MAX_MASK_SIZE, 
                                        OMX_StsMaskSizeErr)
    armRetArgErrIf(maskSize.width  < ARM_IPPP_MIN_MASK_SIZE, 
                                        OMX_StsMaskSizeErr)
    armRetArgErrIf(maskSize.height > ARM_IPPP_MAX_MASK_SIZE, 
                                        OMX_StsMaskSizeErr)
    armRetArgErrIf(maskSize.height < ARM_IPPP_MIN_MASK_SIZE, 
                                        OMX_StsMaskSizeErr)
 
    armRetArgErrIf(anchor.x >= maskSize.width , OMX_StsAnchorErr)
    armRetArgErrIf(anchor.y >= maskSize.height, OMX_StsAnchorErr)

    armRetArgErrIf(anchor.x < 0, OMX_StsAnchorErr)
    armRetArgErrIf(anchor.y < 0, OMX_StsAnchorErr)

    /* Processing */
    width  = roiSize.width;
    height = roiSize.height;
    
    maskWidth  = maskSize.width;
    maskHeight = maskSize.height;
    maskLength = maskWidth * maskHeight;
    maskByTwo  = ((maskLength - 1)>>1);

    ax = anchor.x;
    ay = anchor.y;

    
    for(n = 0 ; n < height ; n++)
    {
        for(m = 0 ; m < width ; m++)
        {
            pSrcTemp = pSrc + m + ax + ay * srcStep; /*pSrc(m + ax,n + ay)*/
            pBuffer  = buffer;
                                    
            /* Populate the buffer */    

            for( j = 0; j < maskHeight ; j++)
            {
                for( i = 0; i < maskWidth ; i++)
                {
                    pBuffer[i] = pSrcTemp[-i];
                }
                
                pSrcTemp -= srcStep;
                pBuffer  += maskWidth;
            }
            
            /* Sort the data in buffer */

            for(i = 0 ; i <= maskByTwo ; i++)
            {
                for(j = 0; j < (maskLength - 1 - i); j++ )
                {
                    if(buffer[j+1] < buffer[j])
                    {
                        temp        = buffer[j];
                        buffer[j]   = buffer[j+1];
                        buffer[j+1] = temp;
                    }
                }
            }
            
            /* Store the Output */
            
            pDst[m] = (OMX_U8)buffer[maskByTwo]; 
        }

        pDst += dstStep;
        pSrc += srcStep;
    }

    return OMX_StsNoErr;
}

/*End of File*/


