/**
 *
 *  omxIPCS_YCbCr422RszCscRotRGB_U8_U16_C2R.c
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
 * Description  : Integrated Resize, Colour Conversion and Rotate Routine - Integral version
 *                The source is in two-channel format and pixel domain, and
 *                the destination in three-channel format and pixel domain.
 *
 */

#include "omxIP.h"
#include "omxtypes.h"
#include "armCOMM.h"
#include "armIP.h"

static OMXVoid armIPCS_ColourConvertAndPack(OMX_U8 Ydata, OMX_U8 Udata, OMX_U8 Vdata, OMXIPColorSpace colorConversion, OMX_U16 *pDstRGB);

/**
 * Function: omxIPCS_YCbCr422RszCscRotRGB_U8_U16_C2R
 *
 * Description:
 * Integrated resize, color space conversion and rotate function.
 *
 * Remarks:
 * This function synthesizes a low-resolution preview image for high-resolution video or still capture
 * applications. In particular, the following sequence of operations is applied to the raw input image:
 * 1. Scale reduction by an integer scalefactor. First, the input image scale is reduced by an integer
 * scalefactor of either 2, 4, or 8 using the interpolation methodology specified by the control
 * parameter interpolation. The following interpolation schemes are supported: nearest neighbor,
 * bilinear. For each of these, respectively, computational complexity and preview image quality
 * rank from low to high.
 * 2. Color space conversion. Following scale reduction, color space conversion is applied
 * according to the control parameter colorConversion.
 * 3. Rotation. After color space conversion, the preview output image is rotated according to the
 * control parameter rotation(allow flip horizontal and flip vertical). 
 *
 *
 * Parameters:
 * [in]  pSrc            pointer to the start of the buffer containing the pixel-oriented input image.
 * [in]  srcStep         distance, in bytes, between the start of lines in the source image.
 * [in]  dstStep         distance, in bytes, between the start of lines in the destination image.
 * [in]  roiSize         dimensions, in pixels, of the source and destination regions of interest.
 * [in]  scaleFactor     reduction scalefactor; values other than 2, 4, or 8 are invalid.
 * [in]  interpolation   interpolation methodology control parameter; must take one of the
 *                       following values - omxInterpNearest or omxInterpBilinear for nearest neighbor or
 *                       bilinear interpolation, respectively.
 * [in]  RGBSpec         RGB color space target; must be set to one of the following
 *                       pre-defined values - omxCscRGB565 or omxCscRGB555
 * [in]  rotation        rotation control parameter; must be set to one of the following pre-defined
 *                       values - omxRotateDisable, omxRotate90L, omxRotate90R, or omxRotate180.
 * [out] pDst            pointer to the start of the buffer containing the resized, color-converted, and rotated
 *                             output image.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr422RszCscRotRGB_U8_U16_C2R(
        const OMX_U8 *pSrc,
        OMX_INT srcStep,
        OMX_U16 *pDst,
        OMX_INT dstStep,
        OMXSize roiSize,
        OMX_INT scaleFactor,
        OMXIPInterpolation interpolation,
        OMXIPColorSpace colorConversion,
        OMXIPRotation rotation
       )
{
    OMX_INT outBufWidth, outBufHeight, i, j;
    OMX_INT srcRowSkipY = 0, srcRowSkipUV = 0, srcPixSkipY = 0, srcPixSkipUV = 0;
    OMX_INT dstPixSkip = 0, dstRowSkip = 0;
    OMX_U8  Y0data, Y1data, Udata, Vdata;
    OMX_U16 *pDstRGB, tempPix16;
    const OMX_U8 *pSrcY, *pSrcU, *pSrcV;
    const OMX_U8 *pRefSrcY = NULL, *pRefSrcU = NULL, *pRefSrcV = NULL;
    
    armRetArgErrIf(!pSrc, OMX_StsBadArgErr);
    armRetArgErrIf(!pDst, OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pSrc), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pDst), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(srcStep), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(dstStep), OMX_StsBadArgErr);
    armRetArgErrIf(srcStep < 1, OMX_StsBadArgErr);
    armRetArgErrIf(dstStep < 1, OMX_StsBadArgErr);
    armRetArgErrIf(roiSize.width > srcStep/2, OMX_StsBadArgErr);
    armRetArgErrIf(roiSize.width < scaleFactor, OMX_StsBadArgErr);
    armRetArgErrIf(roiSize.height < scaleFactor, OMX_StsBadArgErr);
    armRetArgErrIf((scaleFactor != 2) && (scaleFactor != 4) && (scaleFactor != 8), OMX_StsBadArgErr);
    armRetArgErrIf((interpolation != OMX_IP_NEAREST) && (interpolation != OMX_IP_BILINEAR), OMX_StsBadArgErr);
    armRetArgErrIf((colorConversion != OMX_IP_RGB555) && (colorConversion != OMX_IP_RGB565), OMX_StsBadArgErr);
    armRetArgErrIf((rotation != OMX_IP_ROTATE90L) && (rotation != OMX_IP_ROTATE90R) &&
                   (rotation != OMX_IP_ROTATE180) && (rotation != OMX_IP_DISABLE) &&
                   (rotation != OMX_IP_FLIP_HORIZONTAL) && (rotation != OMX_IP_FLIP_VERTICAL), OMX_StsBadArgErr);

    /*
    ------------------------------------------------------------------------------
    In this reference implementation, scale reduction and colour space conversion
    are clubbed together.  In this part of algorithm, ROTATE90 cases are handled
    differently (as the output buffer may not be big enough to hold the scaled &
    colour converted input) - the image is flipped along the major diagonal, after
    scale reduction & colour conversion, and before writing to the output buffer.
    
    Scale Reduction:
    Supported interpolation schemes are Nearest Neighbor and Bilinear.
    Based on the scaleFactor:
    [1] Initialize the Y, U and V pointers in the row to be processed
    [2] Set the pixelSkipStep and rowSkipStep for all of Y, U and V pointers
    [3] Now each of the interpolation type runs these through a generic loop - 
        The Nearest Neighbour chooses the pixel data pointed to by Y, U, V 
        pointers; where as Bilinear, averages the four pixels (for Y) and/or 
        two pixels (for UV) that surround the interpolated pixel.
        
    For understanding the pointer initialization and arithmetic of the below
    loops easily, the interpolation mechanism is represented diagramatically -
    
    Scale Reduction by 2:
    --------------------------------
    |Y11 U11 Y12 V11|Y13 U12 Y14 V12|...          -------------------------
    --------------------------------      ====>>  |Yout1 Uout1|Yout2 Vout1|
    |Y21 U21 Y22 V21|Y23 U22 Y24 V22|...          -------------------------
    --------------------------------
    
    Yout1 = Interpolate(Y11, Y12, Y21, Y22)
    Uout1 = Interpolate(U11, U21)
    Yout2 = Interpolate(Y13, Y14, Y23, Y24)
    Vout1 = Interpolate(V11, V21)
    
    
    Scale Reduction by 4:
    ----------------------------------------------------------------
    |Y11 U11 Y12 V11|Y13 U12 Y14 V12|Y15 U13 Y16 V13|Y17 U14 Y18 V14|...
    ----------------------------------------------------------------
    |Y21 U21 Y22 V21|Y23 U22 Y24 V22|Y25 U23 Y26 V23|Y27 U24 Y28 V24|...
    ----------------------------------------------------------------
    |Y31 U31 Y32 V31|Y33 U32 Y34 V32|Y35 U33 Y36 V33|Y37 U34 Y38 V34|...
    ----------------------------------------------------------------
    |Y41 U41 Y42 V41|Y43 U42 Y44 V42|Y45 U43 Y46 V43|Y47 U44 Y48 V44|...
    ----------------------------------------------------------------
                                ||
                                ||
                                \/
                      -------------------------
                      |Yout1 Uout1|Yout2 Vout1|
                      -------------------------
    
    Yout1 = Interpolate(Y11, Y12, Y21, Y22)
    Uout1 = Interpolate(U11, U21)
    Yout2 = Interpolate(Y15, Y16, Y25, Y26)
    Vout1 = Interpolate(V11, V21)
    
    
    Colour Space Conversion:
    CSC is clubbed with scale reduction and hence doesn't have to be done in-place.
    A function armIPCS_ColourConvertAndPack() is called, after reading the scaled 
    input pixels. This function calls the relevant macros to perform YUV422->RGB
    conversion and then pixel packing (RGB565 or RGB555).
    ------------------------------------------------------------------------------
    */
    
    pRefSrcY        = pSrc;
    pRefSrcU        = pSrc + 1;
    pRefSrcV        = pSrc + 3;
    srcRowSkipY     = scaleFactor * srcStep;
    srcRowSkipUV    = scaleFactor * srcStep;
    srcPixSkipY     = scaleFactor * 2;
    srcPixSkipUV    = scaleFactor * 4;
    outBufWidth     = (OMX_INT)((OMX_F32)roiSize.width/scaleFactor);    /* measured in pixels */
    outBufHeight    = (OMX_INT)((OMX_F32)roiSize.height/scaleFactor);
    
    if((rotation == OMX_IP_ROTATE90L) || (rotation == OMX_IP_ROTATE90R))
    {
        dstPixSkip  = dstStep >> 1;
        dstRowSkip  = 1;
    }
    else
    {
        dstPixSkip  = 1;
        dstRowSkip  = dstStep >> 1;
    }
    
    if(interpolation == OMX_IP_NEAREST)
    {
        for(i = 0; i < outBufHeight; i++)
        {
            pSrcY   = pRefSrcY + (srcRowSkipY * i);
            pSrcU   = pRefSrcU + (srcRowSkipUV * i);
            pSrcV   = pRefSrcV + (srcRowSkipUV * i);
            pDstRGB = (OMX_U16 *)pDst + (dstRowSkip * i);
            
            for(j = 0; j < outBufWidth; j += 2)
            {
                Y0data  = *pSrcY;   pSrcY += srcPixSkipY;
                Udata   = *pSrcU;   pSrcU += srcPixSkipUV;
                Y1data  = *pSrcY;   pSrcY += srcPixSkipY;
                Vdata   = *pSrcV;   pSrcV += srcPixSkipUV;
                
                armIPCS_ColourConvertAndPack(Y0data, Udata, Vdata, colorConversion, pDstRGB);
                pDstRGB += dstPixSkip;
                armIPCS_ColourConvertAndPack(Y1data, Udata, Vdata, colorConversion, pDstRGB);
                pDstRGB += dstPixSkip;
            }
        }
    }
    
    else if(interpolation == OMX_IP_BILINEAR)
    {
        for(i = 0; i < outBufHeight; i++)
        {
            pSrcY   = pRefSrcY + (srcRowSkipY * i);
            pSrcU   = pRefSrcU + (srcRowSkipUV * i);
            pSrcV   = pRefSrcV + (srcRowSkipUV * i);
            pDstRGB = (OMX_U16 *)pDst  + (dstRowSkip * i);
            
            for(j = 0; j < outBufWidth; j += 2)
            {
                tempPix16   = armRoundFloatToS16((pSrcY[0] + pSrcY[2] + pSrcY[srcStep] + pSrcY[srcStep+2])/(OMX_F32)4);
                Y0data      = (OMX_U8)armClip(OMX_MIN_U8, OMX_MAX_U8, tempPix16);
                pSrcY       += srcPixSkipY;
                
                tempPix16   = armRoundFloatToS16((pSrcU[0] + pSrcU[srcStep])/(OMX_F32)2);
                Udata       = (OMX_U8)armClip(OMX_MIN_U8, OMX_MAX_U8, tempPix16);
                pSrcU       += srcPixSkipUV;
                
                tempPix16   = armRoundFloatToS16((pSrcY[0] + pSrcY[2] + pSrcY[srcStep] + pSrcY[srcStep+2])/(OMX_F32)4);
                Y1data      = (OMX_U8)armClip(OMX_MIN_U8, OMX_MAX_U8, tempPix16);
                pSrcY       += srcPixSkipY;
                
                tempPix16   = armRoundFloatToS16((pSrcV[0] + pSrcV[srcStep])/(OMX_F32)2);
                Vdata       = (OMX_U8)armClip(OMX_MIN_U8, OMX_MAX_U8, tempPix16);
                pSrcV       += srcPixSkipUV;
                
                armIPCS_ColourConvertAndPack(Y0data, Udata, Vdata, colorConversion, pDstRGB);
                pDstRGB += dstPixSkip;
                armIPCS_ColourConvertAndPack(Y1data, Udata, Vdata, colorConversion, pDstRGB);
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
    
    switch(rotation)
    {
        case OMX_IP_FLIP_HORIZONTAL : armIPCS_FlipLeftRight_I(pDst, 2, dstStep, outBufWidth, outBufHeight);
                                      break;
        case OMX_IP_FLIP_VERTICAL   : armIPCS_FlipTopBottom_I(pDst, 2, dstStep, outBufWidth, outBufHeight);
                                      break;
        case OMX_IP_ROTATE180       : armIPCS_Rotate180_I(pDst, 2, dstStep, outBufWidth, outBufHeight);
                                      break;
        case OMX_IP_ROTATE90L       : armIPCS_FlipTopBottom_I(pDst, 2, dstStep, outBufHeight, outBufWidth);
                                      break;
        case OMX_IP_ROTATE90R       : armIPCS_FlipLeftRight_I(pDst, 2, dstStep, outBufHeight, outBufWidth);
                                      break;
        default                     : break;
    }
    return OMX_StsNoErr;
}

/**
 * Function: armIPCS_ColourConvertAndPack
 *
 * Description:
 * This is a utility function used only by omxIPCS_YCbCr422RszCscRotRGB_U8_U16_C2R().
 * It converts a pixel from YCbCr representation to an RGB variant (RGB565 or RGB555),
 * based on the <colorConversion> parameter and stores the result in <pDstRGB>.
 *
 * Return Value:
 * OMXVoid
 */

static OMXVoid armIPCS_ColourConvertAndPack(OMX_U8 Ydata, OMX_U8 Udata, OMX_U8 Vdata, OMXIPColorSpace colorConversion, OMX_U16 *pDstRGB)
{
    OMX_U8  Rdata, Gdata, Bdata;
    
    armIPCS_ComputeRFromYUV_Raw(Ydata, Udata, Vdata, &Rdata);
    armIPCS_ComputeGFromYUV_Raw(Ydata, Udata, Vdata, &Gdata);
    armIPCS_ComputeBFromYUV_Raw(Ydata, Udata, Vdata, &Bdata);
    
    if(colorConversion == OMX_IP_RGB565)
    {
        *pDstRGB  = armIPCS_PackToRGB565(Rdata, Gdata, Bdata);
    }
    else
    {
        *pDstRGB  = armIPCS_PackToRGB555(Rdata, Gdata, Bdata);
    }
}
            
/* End of file */
