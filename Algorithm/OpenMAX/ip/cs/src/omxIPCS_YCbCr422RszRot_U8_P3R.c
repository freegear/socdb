/**
 *
 *  omxIPCS_YCbCr422RszRot_U8_P3R.c
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
 * Description  : Integrated Colour Space Conversion and Rotate Routine. Both the
 *                source and destination are in three channel, planar domain format.
 *
 */

#include "omxIP.h"
#include "omxtypes.h"
#include "armCOMM.h"
#include "armIP.h"

OMXResult omxIPCS_YCbCr422RszRot_U8_P3R(
        const OMX_U8 *pSrc[3],
        OMX_INT srcStep[3],
        OMXSize srcSize,
        OMX_U8 *pDst[3],
        OMX_INT dstStep[3],
        OMXSize dstSize,
        OMXIPInterpolation interpolation,
        OMXIPRotation rotation,
        OMX_INT rcpRatiox,
        OMX_INT rcpRatioy
       )
{
    const OMX_U8 *pSrcRef;
    OMX_F32 xOff, yOff;
    OMX_U8  *pDstRef, component;
    OMX_INT srcStepRef, dstStepRef, bufWidth;
    OMX_INT outLoopCnt, inLoopCnt, i, j, yPos, xPos;

    OMX_INT outWidthY       = dstSize.width;
    OMX_INT outWidthUV      = dstSize.width >> 1;
    OMX_INT outHeightYUV    = dstSize.height;
    OMX_F32 gridRatioH      = ((OMX_F32)rcpRatiox) / (1 << 16);
    OMX_F32 gridRatioV      = ((OMX_F32)rcpRatioy) / (1 << 16);
    
    armRetArgErrIf(!pSrc, OMX_StsBadArgErr);
    armRetArgErrIf(!pDst, OMX_StsBadArgErr);
    armRetArgErrIf(!pSrc[0], OMX_StsBadArgErr);
    armRetArgErrIf(!pSrc[1], OMX_StsBadArgErr);
    armRetArgErrIf(!pSrc[2], OMX_StsBadArgErr);
    armRetArgErrIf(!pDst[0], OMX_StsBadArgErr);
    armRetArgErrIf(!pDst[1], OMX_StsBadArgErr);
    armRetArgErrIf(!pDst[2], OMX_StsBadArgErr);
    armRetArgErrIf(!armIs4ByteAligned(pSrc[0]), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs4ByteAligned(pDst[0]), OMX_StsBadArgErr);
    armRetArgErrIf(!srcStep, OMX_StsBadArgErr);
    armRetArgErrIf(!dstStep, OMX_StsBadArgErr);
    armRetArgErrIf(srcStep[0] < 1, OMX_StsBadArgErr);
    armRetArgErrIf(srcStep[1] < 1, OMX_StsBadArgErr);
    armRetArgErrIf(srcStep[2] < 1, OMX_StsBadArgErr);
    armRetArgErrIf(dstStep[0] < 1, OMX_StsBadArgErr);
    armRetArgErrIf(dstStep[1] < 1, OMX_StsBadArgErr);
    armRetArgErrIf(dstStep[2] < 1, OMX_StsBadArgErr);
    armRetArgErrIf(!armIs4ByteAligned(srcStep[0]), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs4ByteAligned(dstStep[0]), OMX_StsBadArgErr);
    armRetArgErrIf(srcSize.width < 1, OMX_StsBadArgErr);
    armRetArgErrIf(srcSize.height < 1, OMX_StsBadArgErr);
    armRetArgErrIf(dstSize.width < 1, OMX_StsBadArgErr);
    armRetArgErrIf(dstSize.height < 1, OMX_StsBadArgErr);
    armRetArgErrIf(srcSize.width > srcStep[0], OMX_StsBadArgErr);
    armRetArgErrIf(srcSize.width > 2*srcStep[1], OMX_StsBadArgErr);
    armRetArgErrIf(srcSize.width > 2*srcStep[2], OMX_StsBadArgErr);
    armRetArgErrIf(dstSize.width & 1, OMX_StsBadArgErr);
    armRetArgErrIf(dstSize.height & 1, OMX_StsBadArgErr);
    armRetArgErrIf(rcpRatiox <= 0, OMX_StsBadArgErr);
    armRetArgErrIf(rcpRatioy <= 0, OMX_StsBadArgErr);
    armRetArgErrIf((interpolation != OMX_IP_NEAREST) && (interpolation != OMX_IP_BILINEAR), OMX_StsBadArgErr);
    armRetArgErrIf((rotation != OMX_IP_ROTATE90L) && (rotation != OMX_IP_ROTATE90R) &&
                   (rotation != OMX_IP_ROTATE180) && (rotation != OMX_IP_DISABLE) &&
                   (rotation != OMX_IP_FLIP_HORIZONTAL) && (rotation != OMX_IP_FLIP_VERTICAL), OMX_StsBadArgErr);
    if((rotation != OMX_IP_ROTATE90L) || (rotation != OMX_IP_ROTATE90R))
    {
        armRetArgErrIf(dstSize.height > dstStep[0]  , OMX_StsBadArgErr);
        armRetArgErrIf(dstSize.height > 2*dstStep[1], OMX_StsBadArgErr);
        armRetArgErrIf(dstSize.height > 2*dstStep[2], OMX_StsBadArgErr);
    }
    else
    {
        armRetArgErrIf(dstSize.width > dstStep[0]  , OMX_StsBadArgErr);
        armRetArgErrIf(dstSize.width > 2*dstStep[1], OMX_StsBadArgErr);
        armRetArgErrIf(dstSize.width > 2*dstStep[2], OMX_StsBadArgErr);
    }

    /*
    ----------------------------------------------------------------------------------
    Resize:
    Resizing is easier, if we have a have a unified grid containing both input and
    rescaled images. The pixel (0,0) of the input image co-incides with the pixel 
    (0,0) of the output image.  We can compute the relative position of rescaled 
    pixels on the original image grid using the formula -
    PIXnew(x,y) = PIXold(x*gridRatioH, y*gridRatioV),
    where gridRatioH = SourceWidth/DestWidth and gridRatioV = SourceHeight/DestHeight
    Then we apply either the Nearest Neighbour or Bilinear interpolation accordingly.
    
    It is important to note that if DstWidth and DstHeight are not big enough to hold 
    the interpolated data, the interpolated image gets clipped such that we get the 
    top-left portion of the interpolated image in the output buffer.
    ----------------------------------------------------------------------------------
    */

    for(component = 0; component < 3; component++)
    {
        pSrcRef     = pSrc[component];
        pDstRef     = pDst[component];
        srcStepRef  = srcStep[component];
        dstStepRef  = dstStep[component];
        outLoopCnt  = outHeightYUV;
        inLoopCnt   = (component == 0) ? outWidthY : outWidthUV;
        
        if(interpolation == OMX_IP_NEAREST)
        {
            for(i = 0; i < outLoopCnt; i++, pDstRef += dstStepRef)
            {
                yPos  = armRoundFloatToS32(i * gridRatioV);
                for(j = 0; j < inLoopCnt; j++)
                {
                    xPos = armRoundFloatToS32(j * gridRatioH);
                    pDstRef[j] = pSrcRef[xPos + (yPos * srcStepRef)];
                }
            }
        }
        
        else if(interpolation == OMX_IP_BILINEAR)
        {
            for(i = 0; i < outLoopCnt; i++, pDstRef += dstStepRef)
            {
                yPos    = (OMX_INT)(i * gridRatioV);
                yOff    = (i * gridRatioV) - yPos;
                for(j = 0; j < inLoopCnt; j++)
                {
                    xPos = (OMX_INT)(j * gridRatioH);
                    xOff = (j * gridRatioH) - xPos;
                    armIPCS_InterpPixel_Bilinear(pSrcRef, srcStepRef, xPos, yPos, xOff, yOff, &pDstRef[j]);
                }
            }
        }
    }
    
    /*
    ----------------------------------------------------------------------------------
    Rotation:
    The Rotation operation follows the Resize and is to be done in-place.
    The formulae for different flavours of rotation -
    H flip: OutPix(x,y) = InPix(width-x,y),
    V flip: OutPix(x,y) = InPix(x,height-y),
    180 is: OutPix(x,y) = InPix(width-x,height-y),
    90L is: OutPix(y,x) = InPix(x,height-y),
    90R is: OutPix(y,x) = InPix(width-x,y),
    
    The formulae for rotation by 90R and 90L listed above can't be implemented 
    in-place, in single looping through the image, and hence it is done in two 
    iterations (both in-place):  
    [1] The input is transformed according to the formulae OutPix(y,x) = InPix(x,y).
    [2] Then we flip it along HORIZ axis (for 90L) and VERT axis (for 90R).

    ---------------------------------------------------------------------------------
    */

    for(component = 0; component < 3; component++)
    {
        bufWidth  = (component == 0) ? outWidthY : outWidthUV;
        
        if(rotation == OMX_IP_FLIP_HORIZONTAL)
        {
            armIPCS_FlipLeftRight_I(pDst[component], 1, dstStep[component], bufWidth, outHeightYUV);
        }
        
        else if(rotation == OMX_IP_FLIP_VERTICAL)
        {
            armIPCS_FlipTopBottom_I(pDst[component], 1, dstStep[component], bufWidth, outHeightYUV);
        }
        
        else if(rotation == OMX_IP_ROTATE180)
        {
            armIPCS_Rotate180_I(pDst[component], 1, dstStep[component], bufWidth, outHeightYUV);
        }
        
        else if(rotation == OMX_IP_ROTATE90L)
        {
            armIPCS_FlipMajorDiagonal_I(pDst[component], 1, dstStep[component], bufWidth, outHeightYUV);
            armIPCS_FlipTopBottom_I(pDst[component], 1, dstStep[component], outHeightYUV, bufWidth);
        }
        
        else if(rotation == OMX_IP_ROTATE90R)
        {
            armIPCS_FlipMajorDiagonal_I(pDst[component], 1, dstStep[component], bufWidth, outHeightYUV);
            armIPCS_FlipLeftRight_I(pDst[component], 1, dstStep[component], outHeightYUV, bufWidth);
        }
    }
    return OMX_StsNoErr;
}

/* End of file */
