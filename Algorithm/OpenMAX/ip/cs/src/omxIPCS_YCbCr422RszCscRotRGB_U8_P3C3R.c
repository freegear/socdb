/**
 *
 *  omxIPCS_YCbCr422RszCscRotRGB_U8_P3C3R.c
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
 * Description  : Integrated Resize, Colour Conversion and Rotate Routine - Fractional version.
 *                The source is in three-channel format and planar domain, and
 *                the destination in three-channel format and pixel domain.
 *
 */

#include "omxIP.h"
#include "omxtypes.h"
#include "armCOMM.h"
#include "armIP.h"

/**
 * Function: omxIPCS_YCbCr422RszCscRotRGB_U8_P3C3R
 *
 * Description:
 * Integrated CSC/rotate/fractional resize function.
 * The ratios control the scaling and the image is then clipped to fit in the dstSize 
 * destination, and bottom and right bits get clipped. 
 * Remarks:
 * This function provides an image for previewing of video or still-capture applications or playback
 * of video. Several atomic image processing kernels have been combined into a single function. In
 * particular, the following sequence of operations is applied to the raw input image:
 * 1. Spatial resizing. First, the input image of srcSize is scaled using x&y ratio using the
 * interpolation methodology specified by the control parameter interpolation. And then clip to dstSize image(the right and bottom side will be cliped).
 * The following interpolation schemes are supported: nearest neighbor, bilinear. For each of these,
 * respectively, computational complexity and preview image quality rank from low to high.
 * 2. Color space conversion. Following scaling, color space conversion is applied according to the
 * control parameter colorConversion.
 * 3. Rotation. After color space conversion, the preview output image is rotated according to the
 * control parameter rotation.
 * The input data should be in YCbCr422 planar format.
 *
 *
 * Parameters:
 * [in]  pSrc           a 3-element vector containing pointers to the start of each of the YCbCr422 input
 *                            planes.
 * [in]  srcStep        a 3-element vector containing the distance, in bytes, between the start of lines in
 *                            each of the input image planes.
 * [in]  dstStep        distance, in bytes, between the start of lines in the destination image.
 * [in]  srcSize        dimensions, in pixels, of the source image.
 * [in]  dstSize        dimensions, in pixels, of the destination image (before applying rotation to the
 *                            resizing image).
 * [in]  interpolation  interpolation methodology control parameter; must take one of the
 *                            following values - omxInterpNearest, or omxInterpBilinear for nearest neighbor or bilinear
 *                            interpolation, respectively.
 * [in]  colorConversion  color conversion control parameter; must be set to one of the following
 *                            pre-defined values - omxCscRGB565, omxCscRGB555,
 *                            omxCscRGB444, or omxCscRGB888
 * [in]  rotation       rotation control parameter; must be set to one of the following pre-defined
 *                            values - omxRotateDisable, omxRotate90L, omxRotate90R, omxRotate180, omxFlipHorizontal,
 *                            or omxFlipVertical
 * [in]  rcpRatiox      reciprocal resizing ratio in X direction, which is in Q16 format. If
 *                            rcpRatiox>65536, it means the input image will expand in x direction.
 * [in]  rcpRatioy      reciprocal resizing ratio in Y direction, which is in Q16 format. If
 *                            rcpRatioy>65536, it means the input image will expand in y direction.
 * [out] pDst           pointer to the start of the buffer containing the, resized, color-converted, and rotated
 *                            output image.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr422RszCscRotRGB_U8_P3C3R(
        const OMX_U8 *pSrc[3],
        OMX_INT srcStep[3],
        OMXSize srcSize,
        void *pDst,
        OMX_INT dstStep,
        OMXSize dstSize,
        OMXIPColorSpace colorConversion,
        OMXIPInterpolation interpolation,
        OMXIPRotation rotation,
        OMX_INT rcpRatiox,
        OMX_INT rcpRatioy
       )
{
    const OMX_U8 *pSrcY, *pSrcU, *pSrcV;
    OMX_U8  *pDstRGB;
    OMX_U8  Y0data, Y1data, Udata, Vdata;
    OMX_INT srcStepY, srcStepU, srcStepV, dstPixSkip, dstRowSkip, i, j;
    OMX_INT bytesPerOutPix = (colorConversion == OMX_IP_RGB888) ? 3 : 2;
    OMX_INT outBufWidth, outBufHeight;
    OMX_INT xPos, yPos, lumaPix, chromaPix;
    OMX_INT xPosLuma1, xPosLuma2, xPosChroma;
    OMX_F32 xOff, yOff;
    OMX_F32 gridRatioH   = ((OMX_F32)rcpRatiox) / (1 << 16);
    OMX_F32 gridRatioV   = ((OMX_F32)rcpRatioy) / (1 << 16);
    OMX_F32 rcpRatioXmax = (((srcSize.width  & ~1) -1) << 16) / (OMX_F32)((dstSize.width  & ~1) -1);
    OMX_F32 rcpRatioYmax = (((srcSize.height & ~1) -1) << 16) / (OMX_F32)((dstSize.height & ~1) -1);
    
    armRetArgErrIf(!pSrc,    OMX_StsBadArgErr);
    armRetArgErrIf(!pSrc[0], OMX_StsBadArgErr);
    armRetArgErrIf(!pSrc[1], OMX_StsBadArgErr);
    armRetArgErrIf(!pSrc[2], OMX_StsBadArgErr);
    armRetArgErrIf(!srcStep, OMX_StsBadArgErr);
    armRetArgErrIf(!pDst,    OMX_StsBadArgErr);
    armRetArgErrIf(srcSize.width <= 0,  OMX_StsBadArgErr);
    armRetArgErrIf(srcSize.height <= 0, OMX_StsBadArgErr);
    armRetArgErrIf(dstSize.width <= 0,  OMX_StsBadArgErr);
    armRetArgErrIf(dstSize.height <= 0, OMX_StsBadArgErr);
    armRetArgErrIf(armNot4ByteAligned(pSrc[0]), OMX_StsBadArgErr);
    armRetArgErrIf(armNot2ByteAligned(pSrc[1]), OMX_StsBadArgErr);
    armRetArgErrIf(armNot2ByteAligned(pSrc[2]), OMX_StsBadArgErr);
    armRetArgErrIf(armNot8ByteAligned(pDst),    OMX_StsBadArgErr);
    armRetArgErrIf(armNot4ByteAligned(srcStep[0]), OMX_StsBadArgErr);
    armRetArgErrIf(armNot2ByteAligned(srcStep[1]), OMX_StsBadArgErr);
    armRetArgErrIf(armNot2ByteAligned(srcStep[2]), OMX_StsBadArgErr);
    armRetArgErrIf(rcpRatiox <= 0, OMX_StsBadArgErr);
    armRetArgErrIf(rcpRatioy <= 0, OMX_StsBadArgErr);
    armRetArgErrIf(rcpRatiox > rcpRatioXmax, OMX_StsBadArgErr);
    armRetArgErrIf(rcpRatioy > rcpRatioYmax, OMX_StsBadArgErr);
    armRetArgErrIf((colorConversion == OMX_IP_RGB888) && armNot2ByteAligned(dstStep), OMX_StsBadArgErr);
    armRetArgErrIf((colorConversion != OMX_IP_RGB888) && armNot8ByteAligned(dstStep), OMX_StsBadArgErr);
    armRetArgErrIf(srcStep[0] < 1, OMX_StsBadArgErr);
    armRetArgErrIf(srcStep[1] < 1, OMX_StsBadArgErr);
    armRetArgErrIf(srcStep[2] < 1, OMX_StsBadArgErr);
    armRetArgErrIf(dstStep    < 1, OMX_StsBadArgErr);
    armRetArgErrIf(srcSize.width > srcStep[0],        OMX_StsBadArgErr);
    armRetArgErrIf((srcSize.width >> 1) > srcStep[1], OMX_StsBadArgErr);
    armRetArgErrIf((srcSize.width >> 1) > srcStep[2], OMX_StsBadArgErr);
    armRetArgErrIf((interpolation != OMX_IP_NEAREST) && 
                   (interpolation != OMX_IP_BILINEAR), OMX_StsBadArgErr);
    armRetArgErrIf((rotation != OMX_IP_ROTATE90L) && 
                   (rotation != OMX_IP_ROTATE90R) &&
                   (rotation != OMX_IP_ROTATE180) && 
                   (rotation != OMX_IP_DISABLE) &&
                   (rotation != OMX_IP_FLIP_HORIZONTAL) && 
                   (rotation != OMX_IP_FLIP_VERTICAL), OMX_StsBadArgErr);
    armRetArgErrIf((colorConversion != OMX_IP_RGB555) && 
                   (colorConversion != OMX_IP_RGB565) &&
                   (colorConversion != OMX_IP_RGB444) && 
                   (colorConversion != OMX_IP_RGB888), OMX_StsBadArgErr);

    if((rotation == OMX_IP_ROTATE90L) || (rotation == OMX_IP_ROTATE90R))
    {
        armRetArgErrIf((dstSize.height * bytesPerOutPix) > dstStep, OMX_StsBadArgErr);
    }
    else
    {
        armRetArgErrIf((dstSize.width * bytesPerOutPix) > dstStep, OMX_StsBadArgErr);
    }

    /*
    ----------------------------------------------------------------------------------
    In this reference implementation, resize and colour space conversion are clubbed 
    together.  In this part of algorithm, ROTATE90 cases are handled differently (as
    the output buffer may not be big enough to hold the resized and colour converted 
    input) - the image is flipped along the major diagonal, after resizing & colour 
    conversion, and before writing to the output buffer.
    
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
    
    After interpolation, the YUV422 data is converted from planar domain, to a pixel
    domain in the from of |Y|U|Y|V|.
    
    Colour Space Conversion:
    CSC is clubbed with scale reduction and hence doesn't have to be done in-place.
    A function armIPCS_RGBConvertAndPack() is called, after reading the scaled 
    input pixels. This function calls the relevant macros to perform YUV422->RGB
    conversion and then pixel packing (RGB565 or RGB555).

    ----------------------------------------------------------------------------------
    */
    
    pSrcY       = pSrc[0];
    pSrcU       = pSrc[1];
    pSrcV       = pSrc[2];
    srcStepY    = srcStep[0];
    srcStepU    = srcStep[1];
    srcStepV    = srcStep[2];
    
    if((rotation == OMX_IP_ROTATE90L) || (rotation == OMX_IP_ROTATE90R))
    {
        dstPixSkip  = dstStep;
        dstRowSkip  = bytesPerOutPix;
    }
    else
    {
        dstPixSkip  = bytesPerOutPix;
        dstRowSkip  = dstStep;
    }

    if(interpolation == OMX_IP_NEAREST)
    {
        for(i = 0; i < dstSize.height; i++)
        {
            yPos    = armRoundFloatToS32(i * gridRatioV);
            lumaPix = chromaPix = 0;
            pDstRGB = (OMX_U8 *)pDst + (dstRowSkip * i);
            
            for(j = 0; j < dstSize.width; j += 2)
            {
                xPosLuma1   = armRoundFloatToS32(lumaPix++ * gridRatioH);
                xPosLuma2   = armRoundFloatToS32(lumaPix++ * gridRatioH);
                xPosChroma  = armRoundFloatToS32(chromaPix++ * gridRatioH);
                Y0data      = pSrcY[xPosLuma1  + (yPos * srcStepY)];
                Udata       = pSrcU[xPosChroma + (yPos * srcStepU)];
                Y1data      = pSrcY[xPosLuma2  + (yPos * srcStepY)];
                Vdata       = pSrcV[xPosChroma + (yPos * srcStepV)];
                
                armIPCS_RGBConvertAndPack(Y0data, Udata, Vdata, colorConversion, (void *)pDstRGB);
                pDstRGB += dstPixSkip;
                armIPCS_RGBConvertAndPack(Y1data, Udata, Vdata, colorConversion, (void *)pDstRGB);
                pDstRGB += dstPixSkip;
            }
        }
    }
    
    else if(interpolation == OMX_IP_BILINEAR)
    {
        for(i = 0; i < dstSize.height; i++)
        {
            yPos    = (OMX_INT)(i * gridRatioV);
            yOff    = (i * gridRatioV) - yPos;
            lumaPix = chromaPix = 0;
            pDstRGB = (OMX_U8 *)pDst + (dstRowSkip * i);
            
            for(j = 0; j < dstSize.width; j += 2)
            {
                xPos    = (OMX_INT)(lumaPix * gridRatioH);
                xOff    = (lumaPix * gridRatioH) - xPos;
                armIPCS_InterpPixel_Bilinear(pSrcY, srcStepY, xPos, yPos, xOff, yOff, &Y0data);
                lumaPix++;
                
                xPos    = (OMX_INT)(lumaPix * gridRatioH);
                xOff    = (lumaPix * gridRatioH) - xPos;
                armIPCS_InterpPixel_Bilinear(pSrcY, srcStepY, xPos, yPos, xOff, yOff, &Y1data);
                lumaPix++;
                
                xPos    = (OMX_INT)(chromaPix * gridRatioH);
                xOff    = (chromaPix * gridRatioH) - xPos;
                armIPCS_InterpPixel_Bilinear(pSrcU, srcStepU, xPos, yPos, xOff, yOff, &Udata);
                armIPCS_InterpPixel_Bilinear(pSrcV, srcStepV, xPos, yPos, xOff, yOff, &Vdata);
                chromaPix++;
                
                armIPCS_RGBConvertAndPack(Y0data, Udata, Vdata, colorConversion, (void *)pDstRGB);
                pDstRGB += dstPixSkip;
                armIPCS_RGBConvertAndPack(Y1data, Udata, Vdata, colorConversion, (void *)pDstRGB);
                pDstRGB += dstPixSkip;
            }
        }
    }
    
    /*
    ---------------------------------------------------------------------------------
    Rotation:
    The Rotation operation follows the Resize-CSC and is to be done in-place.
    The formulae for different flavours of rotation -
    H flip: OutPix(x,y) = InPix(width-x,y),
    V flip: OutPix(x,y) = InPix(x,height-y),
    180 is: OutPix(x,y) = InPix(width-x,height-y),
    90L is: OutPix(y,x) = InPix(x,height-y),
    90R is: OutPix(y,x) = InPix(width-x,y),
    
    The formulae for rotation by 90R and 90L listed above can't be implemented 
    in-place elegantly, in single looping through the image, and hence it is done
    in two iterations (both of which can be done in-place, easily):
    [1] The input is transformed according to the formulae OutPix(y,x) = InPix(x,y).
        This is equivalent to flipping the image along the major diagonal and is 
        already performed during the Resize-Csc phase.
    [2] Then we flip it along HORIZ axis (for 90L) and VERT axis (for 90R).
    ---------------------------------------------------------------------------------
    */
    
    outBufWidth   = dstSize.width;
    outBufHeight  = dstSize.height;
    
    switch(rotation)
    {
        case OMX_IP_FLIP_HORIZONTAL : armIPCS_FlipLeftRight_I(pDst, bytesPerOutPix, dstStep, outBufWidth, outBufHeight);
                                      break;
        case OMX_IP_FLIP_VERTICAL   : armIPCS_FlipTopBottom_I(pDst, bytesPerOutPix, dstStep, outBufWidth, outBufHeight);
                                      break;
        case OMX_IP_ROTATE180       : armIPCS_Rotate180_I(pDst, bytesPerOutPix, dstStep, outBufWidth, outBufHeight);
                                      break;
        case OMX_IP_ROTATE90L       : armIPCS_FlipTopBottom_I(pDst, bytesPerOutPix, dstStep, outBufHeight, outBufWidth);
                                      break;
        case OMX_IP_ROTATE90R       : armIPCS_FlipLeftRight_I(pDst, bytesPerOutPix, dstStep, outBufHeight, outBufWidth);
                                      break;
        default                     : break;
    }
    return OMX_StsNoErr;
}

/* End of file */
