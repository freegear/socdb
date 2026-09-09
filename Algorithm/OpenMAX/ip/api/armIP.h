/**
 *
 *  armIP.h
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
 * File         : armIP.h
 * Description  : Contains ARM-defined macros, functions and definitions common to Still Image domain.
 *
 */

#ifndef _armIP_H_
#define _armIP_H_

#include <math.h>
#include "omxtypes.h"
#include "omxIP.h"
#include "armCOMM.h"

#define ARM_IPPP_MOMENTS_MAX_CHANL  3       /* This is a numeric value */
#define ARM_IPPP_MOMENTS_MAX_ORDER  4       /* This is a numeric value */
#define ARM_IPCS_INTERP_BILINEAR    0       /* This is a switch - should be 1 or 0 */
#define ARM_IPCS_INTERP_NEAREST     1       /* This is a switch - should be 1 or 0 */
#define ARM_IPPP_MAX_MASK_SIZE      255     /* Maximum mask size for median filtering */
#define ARM_IPPP_MIN_MASK_SIZE      3       /* Minimum mask size for median filtering */

#define JPEG_MCU_PIX_WIDTH_444      8
#define JPEG_MCU_PIX_WIDTH_422      16
#define JPEG_MCU_PIX_WIDTH_420      16
#define JPEG_MCU_PIX_HEIGHT_444     8
#define JPEG_MCU_PIX_HEIGHT_422     8
#define JPEG_MCU_PIX_HEIGHT_420     16

#define armIPPP_Power(base, power)  armRoundFloatToS64(pow(base, power))
#define armIPCS_PackToRGB565(Rdata, Gdata, Bdata) (OMX_U16)( (((Rdata) & 0x00F8) >> 3) | \
                                                                 (((Gdata) & 0x00FC) << 3) | \
                                                                 (((Bdata) & 0x00F8) << 8));
#define armIPCS_PackToRGB555(Rdata, Gdata, Bdata) (OMX_U16)( (((Rdata) & 0x00F8) >> 3) | \
                                                                 (((Gdata) & 0x00F8) << 2) | \
                                                                 (((Bdata) & 0x00F8) << 7));
#define armIPCS_PackToRGB444(Rdata, Gdata, Bdata) (OMX_U16)( (((Rdata) & 0x00F0) >> 4) | \
                                                                 (((Gdata) & 0x00F0)) | \
                                                                 (((Bdata) & 0x00F0) << 4));
typedef struct MomentState
{
    OMX_S64 spMoments[ARM_IPPP_MOMENTS_MAX_CHANL][ARM_IPPP_MOMENTS_MAX_ORDER][ARM_IPPP_MOMENTS_MAX_ORDER];
    OMX_S64 ctMoments[ARM_IPPP_MOMENTS_MAX_CHANL][ARM_IPPP_MOMENTS_MAX_ORDER][ARM_IPPP_MOMENTS_MAX_ORDER];
    OMX_INT maxValidChannel;
}ARMIPPP_MomentState;

/* Quantization - strength table : Used in armIPPP_DeblockPixel() */
extern const OMX_U8 armIPPP_strengthTable[31];

/**
 * Function: armIPPP_ComputeBinomialCoeff
 *
 * Description:
 * Computes the binomial coefficient of the expression 
 * [(x-xOff)^mOrd * (y-yOff)^nOrd * f(x,y)] for the (r1,r2)th term,
 * where (0 <= i <= mOrd) and (0 <= j <= nOrd).
 *
 * Return Value:
 * OMX_S64 -- The value of binomial coefficient
 */
OMX_S64 armIPPP_ComputeBinomialCoeff(OMX_INT mOrd, OMX_INT nOrd, OMX_U8 r1, OMX_U8 r2, OMX_INT xOff, OMX_INT yOff);

/**
 * Function: armIPCS_UnpackRGB565
 *
 * Description:
 * This function unpacks an RGB565 compressed image data into separate 
 * R, G and B components, by padding zeros in the lower order bits. 
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
OMXResult armIPCS_UnpackRGB565(OMX_U16 RGBdata, OMX_U8 *pRdata, OMX_U8 *pGdata, OMX_U8 *pBdata);

/**
 * Functions: armIPCS_ComputeRFromYUV_JPEG, armIPCS_ComputeGFromYUV_JPEG, armIPCS_ComputeBFromYUV_JPEG
 *
 * Description:
 * These atomic functions use the JPEG Colour Conversion equations 
 * to convert the input Y,U,V bytes to R,G,B.
 * R = (Y + 128) + 1.40200 * Cr
 * G = (Y + 128) - 0.34414 * Cb - 0.71414 * Cr
 * B = (Y + 128) + 1.77200 * Cb
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
OMXResult armIPCS_ComputeRFromYUV_JPEG(OMX_F32 Ydata, OMX_F32 Udata, OMX_F32 Vdata, OMX_U8  *pRdata);
OMXResult armIPCS_ComputeGFromYUV_JPEG(OMX_F32 Ydata, OMX_F32 Udata, OMX_F32 Vdata, OMX_U8  *pGdata);
OMXResult armIPCS_ComputeBFromYUV_JPEG(OMX_F32 Ydata, OMX_F32 Udata, OMX_F32 Vdata, OMX_U8  *pBdata);

/**
 * Functions: armIPCS_ComputeYFromRGB_JPEG, armIPCS_ComputeUFromRGB_JPEG, armIPCS_ComputeVFromRGB_JPEG
 *
 * Description:
 * These atomic functions use the JPEG Colour Conversion equations 
 * to convert the input R,G,B bytes to Y,U,V.
 * Y  =  0.29900*R  + 0.58700*G  + 0.11400*B - 128
 * U = -0.16874*R  - 0.33126*G  + 0.50000*B
 * V =  0.50000*R  - 0.41869*G  - 0.08131*B
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
OMXResult armIPCS_ComputeYFromRGB_JPEG(OMX_F32 Rdata, OMX_F32 Gdata, OMX_F32 Bdata, OMX_S16 *pYdata);
OMXResult armIPCS_ComputeUFromRGB_JPEG(OMX_F32 Rdata, OMX_F32 Gdata, OMX_F32 Bdata, OMX_S16 *pUdata);
OMXResult armIPCS_ComputeVFromRGB_JPEG(OMX_F32 Rdata, OMX_F32 Gdata, OMX_F32 Bdata, OMX_S16 *pVdata);

/**
 * Functions: armIPCS_ComputeYFromRGB_Raw, armIPCS_ComputeUFromRGB_Raw, armIPCS_ComputeVFromRGB_Raw
 *
 * Description:
 * With output data (Y, U, V) and input data (R, G, B) belonging to [0, 255], 
 * colour conversion equations in the Raw Image Processing domain would be - 
 * Y = 0.257*R  + 0.504*G + 0.098*B + 16
 * U = -0.148*R - 0.291*G + 0.439*B + 128
 * V = 0.439*R  - 0.368*G - 0.071*B + 128
 * The Colour Conversion is followed by a float to S16 type-conversion, taking care 
 * of rounding error and then a clipping to the final range [0, 255].
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
OMXResult armIPCS_ComputeYFromRGB_Raw(OMX_F32 Rdata, OMX_F32 Gdata, OMX_F32 Bdata, OMX_S16 *pYdata);
OMXResult armIPCS_ComputeUFromRGB_Raw(OMX_F32 Rdata, OMX_F32 Gdata, OMX_F32 Bdata, OMX_S16 *pUdata);
OMXResult armIPCS_ComputeVFromRGB_Raw(OMX_F32 Rdata, OMX_F32 Gdata, OMX_F32 Bdata, OMX_S16 *pVdata);

/**
 * Functions: armIPCS_ComputeRFromYUV_Raw, armIPCS_ComputeGFromYUV_Raw, armIPCS_ComputeBFromYUV_Raw
 *
 * Description:
 * With input data (Y, U, V) and output data (R, G, B) belonging to [0, 255], 
 * colour conversion equations in the Raw Image Processing domain would be - 
 * R = 1.164(Y-16) + 1.596(V-128)
 * G = 1.164(Y-16) - 0.813(V-128) - 0.391(U-128)
 * B = 1.164(Y-16) + 2.018(U-128)
 * The Colour Conversion is followed by a float to S16 type-conversion, taking care 
 * of rounding error and then a clipping to the final range [0, 255].
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
OMXResult armIPCS_ComputeRFromYUV_Raw(OMX_F32 Ydata, OMX_F32 Udata, OMX_F32 Vdata, OMX_U8 *pRdata);
OMXResult armIPCS_ComputeGFromYUV_Raw(OMX_F32 Ydata, OMX_F32 Udata, OMX_F32 Vdata, OMX_U8 *pGdata);
OMXResult armIPCS_ComputeBFromYUV_Raw(OMX_F32 Ydata, OMX_F32 Udata, OMX_F32 Vdata, OMX_U8 *pBdata);

/**
 * Function: armIPCS_FlipTopBottom_I
 *
 * Description:
 * This function flips the image w.r.t X axis and does it in-place.
 * The formula being used is OutPix(x,y) = InPix(x,height-y).
 * The size of each element of the image is specified in <bufElemSize>
 * and no assumption is being made on the buffer alignment.
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
OMXResult armIPCS_FlipTopBottom_I(
        void    *pBuf,          /* Pointer to the Image Buffer */
        OMX_INT bufElemSize,    /* Number of bytes in one element */
        OMX_INT bufStep,        /* Offset in bytes between two rows */
        OMX_INT bufWidth,       /* Number of elements in one row */
        OMX_INT bufHeight       /* Number of rows in the image */
       );

/**
 * Function: armIPCS_FlipLeftRight_I
 *
 * Description:
 * This function flips the image w.r.t Y axis and does it in-place.
 * The formula being used is OutPix(x,y) = InPix(width-x,y).
 * The size of each element of the image is specified in <bufElemSize>
 * and no assumption is being made on the buffer alignment.
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
OMXResult armIPCS_FlipLeftRight_I(
        void    *pBuf,          /* Pointer to the Image Buffer */
        OMX_INT bufElemSize,    /* Number of bytes in one element */
        OMX_INT bufStep,        /* Offset in bytes between two rows */
        OMX_INT bufWidth,       /* Number of elements in one row */
        OMX_INT bufHeight       /* Number of rows in the image */
       );

/**
 * Function: armIPCS_FlipMajorDiagonal_I
 *
 * Description:
 * This function flips the image w.r.t major diagonal and does it in-place.
 * The formula being used is OutPix(y,x) = InPix(x,y).
 * The size of each element of the image is specified in <bufElemSize>
 * and no assumption is being made on the buffer alignment.
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
OMXResult armIPCS_FlipMajorDiagonal_I(
        void    *pBuf,          /* Pointer to the Image Buffer */
        OMX_INT bufElemSize,    /* Number of bytes in one element */
        OMX_INT bufStep,        /* Offset in bytes between two rows */
        OMX_INT bufWidth,       /* Number of elements in one row */
        OMX_INT bufHeight       /* Number of rows in the image */
       );

/**
 * Function: armIPCS_Rotate180_I
 *
 * Description:
 * The function rotates the buffer by 180 degree and does it in-place.
 * The formula being used is OutPix(x,y) = InPix(width-x,height-y).
 * The size of each element of the image is specified in <bufElemSize>
 * and no assumption is being made on the buffer alignment.
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
OMXResult armIPCS_Rotate180_I(
        void    *pBuf,          /* Pointer to the Image Buffer */
        OMX_INT bufElemSize,    /* Number of bytes in one element */
        OMX_INT bufStep,        /* Offset in bytes between two rows */
        OMX_INT bufWidth,       /* Number of elements in one row */
        OMX_INT bufHeight       /* Number of rows in the image */
       );

/**
 * Function: armIPCS_InterpPixel_Bilinear
 *
 * Description:
 * This function computes the Bilinear interpolated pixel, by taking
 * the buffer and its step, top-left neighbour pixel coordinates and
 * the offset of the interpolated pixel from this top-left pixel as 
 * input parameters
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
OMXResult armIPCS_InterpPixel_Bilinear(
        const OMX_U8 *pBuf,     /* Pointer to the Image Buffer */
        OMX_INT bufStep,        /* Offset in bytes between two rows */
        OMX_INT xPos,           /* x-coordinate of the nearest top-left pixel of the interpolated pixel */
        OMX_INT yPos,           /* y-coordinate of the nearest top-left pixel of the interpolated pixel */
        OMX_F32 xOff,           /* Distance along X, between interpolated and its nearest top-left pixel */
        OMX_F32 yOff,           /* Distance along Y, between interpolated and its nearest top-left pixel */
        OMX_U8  *pInterpPix     /* Pointer to return the interpolated pixel value */
       );

/**
 * Function: armIPPP_DeblockEdge
 *
 * Description:
 * Performs deblock filtering on two adjacent blocks along a block edge (horizontal/Vertical)
 *
 * Remarks:
 * The output buffer region is required to have the same size as 
 * that of the input region, although the width of the overall 
 * images may differ.
 *
 * Parameters:
 * [in]  pSrcDst    pointer to the first pixel of the second block
 * [in]  step       width of the image plane, in bytes; must be a multiple of 8.
 * [in]  QP         quantization parameter, as described in Section J.3 of Annex J in H.263+
 * [in]  flag       flag = 0 :vertical Edge, flag = 1: Horizontal edge
 * [out] pSrcDst    pointer to the first pixel of the second output block
 *
 * return value:
 * OMXVoid.
 * 
 */ 
OMXVoid armIPPP_DeblockEdge(
        OMX_U8 *pSrcDst,
        OMX_INT step,
        OMX_INT QP,
        OMX_INT flag
);

/**
 * Function: armIPCS_RGBConvertAndPack
 *
 * Description:
 * This is a utility function used by omxIPCS_YCbCr42xRszCscRotRGB_U8_P3C3R().
 * It converts a pixel from YCbCr representation to one of the RGB variants - 
 * RGB565, RGB555, RGB444, RGB888 based on the <colorConversion> parameter and 
 * stores the result in <pDstRGB>.
 *
 * Return Value:
 * OMXVoid
 */

OMXVoid armIPCS_RGBConvertAndPack(OMX_U8 Ydata, OMX_U8 Udata, OMX_U8 Vdata, OMXIPColorSpace colorConversion, void *pDst);

#endif /* _armIP_H_ */
