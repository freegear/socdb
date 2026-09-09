/**
 * File: omxIP.h
 * Brief: OpenMAX Image Processing DL library
 *
 * Copyright © 2005-06 The Khronos Group Inc. All Rights Reserved. 
 *
 * These materials are protected by copyright laws and contain material 
 * proprietary to the Khronos Group, Inc.  You may use these materials 
 * for implementing Khronos specifications, without altering or removing 
 * any trademark, copyright or other notice from the specification.
 * 
 * Khronos Group makes no, and expressly disclaims any, representations 
 * or warranties, express or implied, regarding these materials, including, 
 * without limitation, any implied warranties of merchantability or fitness 
 * for a particular purpose or non-infringement of any intellectual property. 
 * Khronos Group makes no, and expressly disclaims any, warranties, express 
 * or implied, regarding the correctness, accuracy, completeness, timeliness, 
 * and reliability of these materials. 
 *
 * Under no circumstances will the Khronos Group, or any of its Promoters, 
 * Contributors or Members or their respective partners, officers, directors, 
 * employees, agents or representatives be liable for any damages, whether 
 * direct, indirect, special or consequential damages for lost revenues, 
 * lost profits, or otherwise, arising from or in connection with these 
 * materials.
 * 
 * Khronos and OpenMAX are trademarks of the Khronos Group Inc. 
 *
 */

/* *****************************************************************************************/
/**
 *
 *  NewDomain: IP The Image Processing Domain
 *  WithinDomain: OM
 *
 *  StartDomain: IP
 */


#ifndef _OMXIP_H_
#define _OMXIP_H_

#include "omxtypes.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
   OMX_IP_HORIZONTAL = 0,
   OMX_IP_VERTICAL = 1,
   OMX_IP_BOTH = 2
} OMXIPAxis;

typedef enum {
   OMX_IP_NEAREST = 0,
   OMX_IP_BILINEAR = 1,
   OMX_IP_MEDIAN = 2
} OMXIPInterpolation;

typedef enum {
   OMX_IP_DISABLE = 0,
   OMX_IP_ROTATE90L = 1,            /* counter-clockwise */
   OMX_IP_ROTATE90R = 2,            /* clockwise */
   OMX_IP_ROTATE180 = 3,            
   OMX_IP_FLIP_HORIZONTAL = 4,    /* from R to L, about V axis */
   OMX_IP_FLIP_VERTICAL = 5      /* from top to bottom, about H axis */
} OMXIPRotation;

typedef enum {
   OMX_IP_RGB565 = 0,              /*YCbCr422ToRGB565 */
   OMX_IP_RGB555 = 1,             /* YCbCr422ToRGB555 */
   OMX_IP_RGB444 = 2,             /* YCbCr422ToRGB444 */
   OMX_IP_RGB888 = 3,             /* YCbCr422ToRGB888 */
   OMX_IP_YCBCR422 = 4,           /* RGGBToYCbCr422P */
   OMX_IP_YCBCR420 = 5          /* RGGBToYCbCr420 */
} OMXIPColorSpace;

typedef void OMXMomentState;

/*================== Functions declarations ======================*/

/* *****************************************************************************************/
/**
 *
 *	NewDomain: PP The Pre- and Post-processing subdomain
 *  WithinDomain: IP
 *
 *  StartDomain: PP
 */

/**
 *
 * Function: omxIPPP_Deblock_HorEdge_U8_I
 *
 
 * Description:
 * Performs deblock filtering on two adjacent blocks along a block edge (horizontal) of an
 * image, as shown in the figure below.
 * Status: Design
 *
 * Remarks:
 * The output buffer region is required to have the same size as 
 * that of the input region, although the width of the overall 
 * images may differ.
 *
 * Parameters:
 * [in]  pSrcDst    pointer to the first pixel of the second block (labeled "block 2" in the figure),must be aligned on an 8-byte boundary.
 * [in]  step       width of the image plane, in bytes; must be a multiple of 8.
 * [in]  QP         quantization parameter, as described in Section J.3 of Annex J in H.263+,valid in the range 1 to 31.
 * [out] pSrcDst    pointer to the first pixel of the second output block (labeled "block 2" in the figure),must be aligned on an 8-byte boundary.
 * return value:
 * Standard OMXResult result. See enumeration for possible result codes.
 * 
 */
OMXResult omxIPPP_Deblock_HorEdge_U8_I (
	      OMX_U8		*pSrcDst, 
	const OMX_INT		step, 
	const OMX_INT       QP
);

/**
 *
 * Function: omxIPPP_Deblock_VerEdge_U8_I
 *
 * Brief:
 * 
 *
 * Description:
 * Performs deblock filtering on two adjacent blocks along a block edge (vertical) of an
 * image, as shown in the figure below.
 * Status: Design
 *
 * Remarks:
 * The output buffer region is required to have the same size as 
 * that of the input region, although the width of the overall 
 * images may differ.
 *
 * Parameters:
 * [in]  pSrcDst    pointer to the first pixel of the second block (labeled "block 2" in the figure).
 * [in]  step       width of the image plane, in bytes; must be a multiple of 8.
 * [in]  QP         quantization parameter, as described in Section J.3 of Annex J in H.263+
 * [out] pSrcDst    pointer to the first pixel of the second output block (labeled "block 2" in the figure)
 * return value:
 * Standard OMXResult result. See enumeration for possible result codes.
 * 
 */
OMXResult omxIPPP_Deblock_VerEdge_U8_I (
	      OMX_U8		*pSrcDst, 
	const OMX_INT		step, 
	const OMX_INT       QP
);



/**
 * Function: omxIPPP_FilterFIR_U8_C1R
 *
 * Description:
 * Filter single-channel image.
 *
 * Remarks:
 * Performs filtering of the ROI of the source image pointed to by pSrc using a general rectangular
 * (WxH size) convolution kernel. The value of the output pixel is normalized by the divider and
 * saturated.
 * The result is placed into the ROI of the destination image pointed to by pDst.
 * single-channel (gray) image
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to the source ROI
 * [in]  srcStep        distance in bytes between the starts of consecutive lines in the source image
 * [in]  dstStep        distance in bytes between the starts of consecutive lines in the destination image
 * [in]  roiSize        size of the source and destination ROI in pixels
 * [in]  pKernel        pointer to the 2D FIR filter taps
 * [in]  kernelSize     size of the FIR filter
 * [in]  anchor         anchor cell specifying the array of filter taps alignment with respect to the position
 *                            of the input pixel
 * [in]  divider        divider value used to normalise result
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
 );




/**
 * Function: omxIPPP_FilterMedian_U8_C1R
 *
 * Description:
 * Filter single-channel image.
 *
 * Remarks:
 * Performs median filtering of the ROI of the source image pointed to by pSrc using the median
 * filter of the size maskSize and location anchor. The result is placed into the ROI of the destination
 * image pointed to by pDst.
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to the source ROI
 * [in]  srcStep        distance in bytes between the starts of consecutive lines in the source image
 * [in]  dstStep        distance in bytes between the starts of consecutive lines in the destination image
 * [in]  roiSize        size of the source and destination ROI in pixels
 * [in]  maskSize       size of the mask in pixels;minimum size is 3x3; maximum size is 31x31.
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
 );



/**
 * Function: omxIPPP_MomentGetStateSize
 *
 * Description:
 * Get size of moment state structure.
 *
 * Remarks:
 * Get size of state structure in bytes; returned in *pSize.
 *
 *
 * Parameters:
 * [out] pSize          pointer to varible to hold the state size.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPPP_MomentGetStateSize(
     OMX_INT* pSize        
 );




/**
 * Function: omxIPPP_MomentInit
 *
 * Description:
 * Moment state structure initialization.
 *
 * Remarks:
 * Initializes moment state structure.
 *
 *
 * Parameters:
 * [in]  pState         pointer to the uninitialized state structure
 * [out] pState         pointer to the initialized state structure
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPPP_MomentInit(
     OMXMomentState* pState        
 );




/**
 * Function: omxIPPP_Moments_U8_C1R
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

OMXResult omxIPPP_Moments_U8_C1R(
     const OMX_U8* pSrc,
     OMX_INT srcStep,
     OMXSize roiSize,
     OMXMomentState* pState        
 );




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
 );



/**
 * Function: omxIPPP_GetSpatialMoment_S64
 *
 * Description:
 * Spatial moment function.
 *
 * Remarks:
 * Returns nOrd by mOrd spatial moment calculated by omxiMoments64s ( ) function. Place the
 * scaled result into the memory pointed to by pValue.
 *
 *
 * Parameters:
 * [in]  mOrd           moment specifier
 * [in]  nOrd           moment specifier
 * [in]  pState         pointer to the state structure
 * [in]  nChannel       specify the image channel number
 * [in]  roiOffset      ROI location
 * [in]  pValue         pointer to the variable required moment value to be stored. Function returns value
 * [in]  scaleFactor    value of the scale factor
 * [out] pValue         pointer to the computed moment value
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPPP_GetSpatialMoment_S64(
     const OMXMomentState* pState,
     OMX_INT mOrd,
     OMX_INT nOrd,
     OMX_INT nChannel,
     OMXPoint roiOffset,
     OMX_S64* pValue,
     OMX_INT scaleFactor        
 );



/**
 * Function: omxIPPP_GetCentralMoment_S64
 *
 * Description:
 * Central moment function.
 *
 * Remarks:
 * Returns specified by nOrd and mOrd central moment calculated by omxiMoments 64s ( ) function.
 * Place the scaled result into the memory pointed to by pValue.
 *
 *
 * Parameters:
 * [in]  pState         pointer to the state structure
 * [in]  mOrd           specify the required spatial moment
 * [in]  nOrd           specify the required spatial moment
 * [in]  nChannel       specify the image channel number
 * [in]  scaleFactor    value of the scale factor
 * [out] pValue         pointer to the computed moment value
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPPP_GetCentralMoment_S64(
     const OMXMomentState* pState,
     OMX_INT mOrd,
     OMX_INT nOrd,
     OMX_INT nChannel,
     OMX_S64* pValue,
     OMX_INT scaleFactor        
 );




/**
 * EndDomain: PP
 */
 
 


/* *****************************************************************************************/
/** 
 *
 *	NewDomain: CS The Color Space Coversion Subdomain
 *  WithinDomain: IP
 * 
 *  StartDomain: CS
 */
 
  


/**
 * Function: omxIPCS_ColorTwistQ14_U8_C3R
 *
 * Description:
 * Color twist function.
 *
 * Remarks:
 * Apply color twist Q1.14 matrix twist_Q14 to the ROI of the source image pointed to by pSrc.
 * Place the results into the ROI of the destination image pointed to by pDst. Ordinarily, the matrix
 * for the color twist conversion has float-point format but the fix point matrix implementation is
 * used here. Q14 modifier implies that the matrix values were obtained by multiplying every
 * original float-point matrix element by (1<<14).
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to the source ROI; should contain three interleaved (¡°C3¡±) channels of 8-bit image data. 
 * [in]  srcStep        distance in bytes between the starts of consecutive lines in the source image
 * [in]  dstStep        distance in bytes between the starts of consecutive lines in the destination image
 * [in]  roiSize        size of the source and destination ROI in pixels
 * [in]  twistQ14       twist matrix
 * [out] pDst           pointer to the destination ROI; contains transformed version of the input ROI.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_ColorTwistQ14_U8_C3R(
     const OMX_U8 *pSrc,
     OMX_INT srcStep,
     OMX_U8 *pDst,
     OMX_INT dstStep,
     OMXSize roiSize,
     const OMX_S32 twistQ14[3][4]        
 );




/**
 * Function: omxIPCS_YCbCr444ToRGB888_U8_C3R
 *
 * Description:
 * YCbCr(4:4:4) to RGB color space converstion function.
 *
 * Remarks:
 * Converts a YCbCr image to RGB color space. The ROI of the source image is pointed to by pSrc,
 * the result is placed into the ROI of the destination image pointed to by pDst.
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to the source ROI
 * [in]  srcStep        distance in bytes between the starts of consecutive lines in the source image
 * [in]  dstStep        distance in bytes between the starts of consecutive lines in the destination image
 * [in]  roiSize        size of the source and destination ROI in pixels
 * [out] pDst           pointer to the destination ROI
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr444ToRGB888_U8_C3R(
     const OMX_U8 *pSrc,
     OMX_INT srcStep,
     OMX_U8 *pDst,
     OMX_INT dstStep,
     OMXSize roiSize        
 );




/**
 * Function: omxIPCS_YCbCr444ToRGB565_U8_U16_C3R
 *
 * Description:
 * YCbCr(4:4:4) to RGB565 color space converstion function.
 *
 * Remarks:
 * Converts a YCbCr image to RGB565 color space. The ROI of the source image is pointed to by 
 * pSrc, the result is placed into the ROI of the destination image pointed to by pDst.
 * RGB565 is represented using 16-bit words that are packed as follows: 5 bits B (bits 0-4), 6
 * bits G (bits 5-10) and 5 bits R (bits 11-15).
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to the source ROI
 * [in]  srcStep        distance in bytes between the starts of consecutive lines in the source image
 * [in]  dstStep        distance in bytes between the starts of consecutive lines in the destination image
 * [in]  roiSize        size of the source and destination ROI in pixels
 * [out] pDst           pointer to the destination ROI
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr444ToRGB565_U8_U16_C3R(
     const OMX_U8 *pSrc,
     OMX_INT srcStep,
     OMX_U16 *pDst,
     OMX_INT dstStep,
     OMXSize roiSize        
 );




/**
 * Function: omxIPCS_YCbCr444ToRGB565_U8_U16_P3C3R
 *
 * Description:
 * YCbCr(4:4:4) planar format to RGB565 color space converstion function.
 *
 * Remarks:
 * Convert a YCbCr input image to RGB565 color space. The ROI of the source image is pointed to
 * by pSrc, and the result is placed into the ROI of the destination image pointed to by pDst. The
 * RGB565 destination image pDst is represented using 16-bit words that are packed as follows: 5
 * bits B (bits 0-4), 6 bits G (bits 5-10) and 5 bits R (bits 11-15).
 *
 *
 * Parameters:
 * [in]  pSrc           vector containing pointers to Y, Cb, and Cr planes.
 * [in]  srcStep        distance in bytes between the starts of consecutive lines in the source image
 * [in]  dstStep        distance in bytes between the starts of consecutive lines in the destination image
 * [in]  roiSize        size of the source and destination ROI in pixels
 * [out] pDst           pointer to the destination ROI
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr444ToRGB565_U8_U16_P3C3R(
     const OMX_U8* pSrc[3],
     OMX_INT srcStep,
     OMX_U16* pDst,
     OMX_INT dstStep,
     OMXSize roiSize        
 );




/**
 * Function: omxIPCS_YCbCr420ToRGB565_U8_U16_P3C3R
 *
 * Description:
 * YCbCr420 to RGB565 color space converstion function.
 *
 * Remarks:
 * Convert a YCbCr420 input image to RGB565 color space. The ROI of the source image is pointed to
 * by pSrc, and the result is placed into the ROI of the destination image pointed to by pDst. The
 * RGB565 destination image pDst is represented using 16-bit words that are packed as follows: 5
 * bits B (bits 0-4), 6 bits G (bits 5-10) and 5 bits R (bits 11-15).
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to the source ROI
 * [in]  srcStep        step in bytes through the source image
 * [in]  dstStep        distance in bytes between the starts of consecutive lines in the destination image
 * [in]  roiSize        size of the source and destination ROI in pixels
 * [out] pDst           pointer to the destination ROI
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr420ToRGB565_U8_U16_P3C3R(
     const OMX_U8* pSrc[3],
     OMX_INT srcStep[3],
     OMX_U16* pDst,
     OMX_INT dstStep,
     OMXSize roiSize        
 );




/**
 * Function: omxIPCS_YCbCr422ToRGB888_U8_C2C3R 
 *
 * Description:
 * YCbCr422 to RGB color space converstion function.
 *
 * Remarks:
 * Convert a YCbCr422 input image to RGB888 color space. The ROI of the source image is pointed to
 * by pSrc, and the result is placed into the ROI of the destination image pointed to by pDst.
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to the source ROI
 * [in]  srcStep        distance in bytes between the starts of consecutive lines in the source image
 * [in]  dstStep        distance in bytes between the starts of consecutive lines in the destination image
 * [in]  roiSize        size of the source and destination ROI in pixels
 * [out] pDst           pointer to the destination ROI
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr422ToRGB888_U8_C2C3R (
     const OMX_U8 *pSrc,
     OMX_INT srcStep,
     OMX_U8 *pDst,
     OMX_INT dstStep,
     OMXSize roiSize        
 );




/**
 * Function: omxIPCS_YCbCr422ToRGB565_U8_U16_C2C3R 
 *
 * Description:
 * YCbCr422 to RGB565 color space converstion function.
 *
 * Remarks:
 * Convert a YCbCr422 input image to RGB565 color space. The ROI of the source image is pointed to
 * by pSrc, and the result is placed into the ROI of the destination image pointed to by pDst. The
 * RGB565 destination image pDst is represented using 16-bit words that are packed as follows: 5
 * bits B (bits 0-4), 6 bits G (bits 5-10) and 5 bits R (bits 11-15).
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to the source ROI
 * [in]  srcStep        distance in bytes between the starts of consecutive lines in the source image
 * [in]  dstStep        distance in bytes between the starts of consecutive lines in the destination image
 * [in]  roiSize        size of the source and destination ROI in pixels
 * [out] pDst           pointer to the destination ROI
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr422ToRGB565_U8_U16_C2C3R (
     const OMX_U8 *pSrc,
     OMX_INT srcStep,
     OMX_U16 *pDst,
     OMX_INT dstStep,
     OMXSize roiSize        
 );


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
     OMXIPColorSpace RGBSpec,
     OMXIPRotation rotation        
 );




/**
 * Function: omxIPCS_YCbCr422ToYCbCr420Rotate_U8_C2P3R
 *
 * Description:
 * YCbCr422 to YCbCr420 planar format conversion with rotation function.
 *
 * Remarks:
 * This function decimates and interpolates the color space of the input image from YCbCr 422 to
 * YCbCr 420, applies an optional rotation of -90, +90, or 180 degrees, and then rearranges the data
 * from the pixel-oriented input format to a planar output format.
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to the start of the buffer containing the pixel-oriented YCbCr422(Cb0Y0Cr0Y1Cb1Y2Cr1Y3......) input.
 * [in]  srcStep        distance, in bytes, between the start of lines in the source image.
 * [in]  dstStep        a 3-element vector containing the distance, in bytes, between the start of lines in
 *                      each of the output image planes.
 * [in]  roiSize        dimensions, in pixels, of the source and destination regions of interest.
 * [in]  rotation       rotation control parameter; must be set to one of the following pre-defined
 *                      values - omxRotateDisable, omxRotate90L, omxRotate90R, or omxRotate180.
 * [out]  pDst           a 3-element vector containing pointers to the start of each of the YCbCr420 output
 *                      planes.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr422ToYCbCr420Rotate_U8_C2P3R(
     const OMX_U8 *pSrc,
     OMX_INT srcStep,
     OMX_U8 *pDst[3],
     OMX_INT dstStep[3],
     OMXSize roiSize,
     OMXIPRotation rotation        
 );




/**
 * Function: omxIPCS_YCbCr422ToYCbCr420Rotate_U8_P3R
 *
 * Description:
 * This function decimates the color space of the input image from YCbCr 422 planar data to YCbCr 420 planar data, 
 * and then applies an optional rotation of -90, +90, or 180 degrees.  
 * The difference between this function and omxIPCS_YCbCr422ToYCbCr420Rotate_U8_C2P3R is that this function supports the input YCbCr422 format in planar order.
 *
 *
 * Parameters:
 * [in]  pSrc           a 3-element vector containing pointers to the start of each of the YCbCr420 input
 *                            planes.
 * [in]  srcStep        a 3-element vector containing the distance, in bytes, between the start of lines in
 *                            each of the input image planes.
 * [in]  dstStep        a 3-element vector containing the distance, in bytes, between the start of lines in
 *                            each of the output image planes.
 * [in]  roiSize        dimensions, in pixels, of the source and destination regions of interest.
 * [in]  rotation       rotation control parameter; must be set to one of the following pre-defined
 *                      values - omxRotateDisable, omxRotate90L, omxRotate90R, or omxRotate180.
 * [out]  pDst          a 3-element vector containing pointers to the start of each of the YCbCr420 output
 *                      planes.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr422ToYCbCr420Rotate_U8_P3R(
     const OMX_U8 *pSrc[3],
     OMX_INT srcStep[3],
     OMX_U8 *pDst[3],
     OMX_INT dstStep[3],
     OMXSize roiSize,
     OMXIPRotation rotation        
 );




/**
 * Function: omxIPCS_YCbCr420RszCscRotRGB_U8_P3C3R
 *
 * Description:
 * Integrated CSC/rotate/fractional resize function.
 * The ratios control the scaling and the image is then clipped to fit in the dstSize 
 * destination, and bottom and right bits get clipped. 
 * Remarks:
 * This function provides an image for previewing of video or still-capture applications or playback
 * of video. Several atomic image processing kernels have been combined into a single function. In
 * particular, the following sequence of operations is applied to the input YCbCr image:
 * 1. Spatial resizing. First, the input image of srcSize is scaled using x&y ratio using the
 * interpolation methodology specified by the control parameter interpolation. And then clip to dstSize image(the right and bottom side will be cliped).
 * The following interpolation schemes are supported: nearest neighbor, bilinear. For each of these,
 * respectively, computational complexity and preview image quality rank from low to high.
 * 2. Color space conversion. Following scaling, color space conversion is applied according to the
 * control parameter colorConversion.
 * 3. Rotation. After color space conversion, the preview output image is rotated according to the
 * control parameter rotation.
 * The input data should be in YCbCr420 planar format.
 *
 *
 * Parameters:
 * [in]  pSrc            a 3-element vector containing pointers to the start of each of the YCbCr420 input
 *                             planes.
 * [in]  srcStep         a 3-element vector containing the distance, in bytes, between the start of lines in
 *                             each of the input image planes.
 * [in]  dstStep         distance, in bytes, between the start of lines in the destination image.
 * [in]  srcSize         dimensions, in pixels, of the source image.
 * [in]  dstSize         dimensions, in pixels, of the destination image (before applying rotation to the
 *                             resizing image).
 * [in]  interpolation   interpolation methodology control parameter; must take one of the
 *                             following values - omxInterpNearest, or omxInterpBilinear for nearest neighbor or bilinear
 *                             interpolation, respectively.
 * [in]  colorConversion color conversion control parameter; must be set to one of the following
 *                             pre-defined values - omxCscRGB565, omxCscRGB555,
 *                             omxCscRGB444, or omxCscRGB888
 * [in]  rotation        rotation control parameter; must be set to one of the following pre-defined
 *                             values - omxRotateDisable, omxRotate90L, omxRotate90R, omxRotate180, omxFlipHorizontal,
 *                             or omxFlipVertical
 * [in]  rcpRatiox       reciprocal resizing ratio in X direction, which is in Q16 format. If
 *                             rcpRatiox>65536, it means the input image will expand in x direction.
 * [in]  rcpRatioy       reciprocal resizing ratio in Y direction, which is in Q16 format. If
 *                             rcpRatioy>65536, it means the input image will expand in y direction.
 * [out] pDst            pointer to the start of the buffer containing the, resized, color-converted, and rotated
 *                             output image.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr420RszCscRotRGB_U8_P3C3R(
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
 );




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
 );




/**
 * Function: omxIPCS_YCbCr420RszRot_U8_P3R
 *
 * Description:
 * Integrated rotate/fractional resize function.
 *
 * Remarks:
 * This function combines several atomic image processing kernels into a single function. In
 * particular, the following sequence of operations is applied:
 * 1. Spatial resizing. First, the input image of srcSize is scaled using x&y ratio using the
 * interpolation methodology specified by the control parameter interpolation. And then clip to dstSize image(the right and bottom side will be cliped).
 * The following interpolation schemes are supported: nearest neighbor, bilinear. For each of these,
 * respectively, computational complexity and preview image quality rank from low to high.
 * 2. Rotation. the preview output image is rotated according to the
 * control parameter rotation.
 * The input data should be YCbCr420 planar format.
 * This function does not alter the format/storage of the image data
 *
 * Parameters:
 * [in]  pSrc           a 3-element vector containing pointers to the start of each of the YCbCr420 input
 *                            planes.
 * [in]  srcStep        a 3-element vector containing the distance, in bytes, between the start of lines in
 *                            each of the input image planes.
 * [in]  dstStep        a 3-element vector containing the distance, in bytes, between the start of lines in
 *                            each of the output image planes.
 * [in]  srcSize        dimensions, in pixels, of the source image.
 * [in]  dstSize        dimensions, in pixels, of the destination image(before applying rotation to the
 *                            resized image).
 * [in]  interpolation  interpolation methodology control parameter; must take one of the
 *                            following values - omxInterpNearest, or omxInterpBilinear for nearest neighbor or bilinear
 *                            interpolation, respectively.
 * [in]  rotation       rotation control parameter; must be set to one of the following pre-defined
 *                            values - omxRotateDisable, omxRotate90L, omxRotate90R, omxRotate180, omxFlipHorizontal,
 *                            or omxFlipVertical
 * [in]  rcpRatiox      reciprocal resizing ratio in X direction, which is in Q16 format. If
 *                            rcpRatiox>65536, it means the input image will expand in x direction.
 * [in]  rcpRatioy      reciprocal resizing ratio in Y direction, which is in Q16 format. If
 *                            rcpRatioy>65536, it means the input image will expand in y direction.
 * [out] pDst [3]       a 3-element vector containing pointers to the start of each of the YCbCr420 output
 *                            planes.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr420RszRot_U8_P3R(
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
 );




/**
 * Function: omxIPCS_YCbCr422RszRot_U8_P3R
 *
 * Description:
 * Integrated rotate/fractional resize function.
 *
 * Remarks:
 * This function combines several atomic image processing kernels into a single function. In
 * particular, the following sequence of operations is applied:
 * 1. Spatial resizing. First, the input image of srcSize is scaled using x&y ratio using the
 * interpolation methodology specified by the control parameter interpolation. And then clip to dstSize image(the right and bottom side will be cliped).
 * The following interpolation schemes are supported: nearest neighbor, bilinear. For each of these,
 * respectively, computational complexity and preview image quality rank from low to high.
 * 2. Rotation. After Spatial resizing, the preview output image is rotated according to the
 * control parameter rotation.
 * The input data should be YCbCr422 planar format.
 *
 *
 * Parameters:
 * [in]  pSrc           a 3-element vector containing pointers to the start of each of the YCbCr422 input planes.
 * [in]  srcStep        a 3-element vector containing the distance, in bytes, between the start of lines in
 *                            each of the input image planes.
 * [in]  dstStep        a 3-element vector containing the distance, in bytes, between the start of lines in
 *                            each of the output image planes.
 * [in]  srcSize        dimensions, in pixels, of the source image.
 * [in]  dstSize        dimensions, in pixels, of the destination image(before applying rotation to the
 *                            resized image).
 * [in]  interpolation  interpolation methodology control parameter; must take one of the
 *                            following values - omxInterpNearest, or omxInterpBilinear for nearest neighbor or bilinear
 *                            interpolation, respectively.
 * [in]  rotation       rotation control parameter; must be set to one of the following pre-defined
 *                            values - omxRotateDisable, omxRotate90L, omxRotate90R, omxRotate180, omxFlipHorizontal,
 *                            or omxFlipVertical
 * [in]  rcpRatiox      reciprocal resizing ratio in X direction, which is in Q16 format. If
 *                            rcpRatiox>65536, it means the input image will expand in x direction.
 * [in]  rcpRatioy      reciprocal resizing ratio in Y direction, which is in Q16 format. If
 *                            rcpRatioy>65536, it means the input image will expand in y direction.
 * [out] pDst           a 3-element vector containing pointers to the start of each of the YCbCr420 output
 *                            planes.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

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
 );




/**
 * Function: omxIPCS_RGB888ToYCbCr444LS_MCU_U8_S16_C3P3R 
 *
 * Description:
 * RGB to YCbCr444 color conversion function.
 *
 * Remarks:
 * This function converts RGB data to YCbCr data with level-shift and
 * sampling (in 4:4:4). It processes image data in MCU size, 8x8(Y block) for 444;
 *
 *
 * Parameters:
 * [in]  pSrc           identifies source image data buffer. The source image data are stored in interleaved
 *                            order as BGRBGRBGR... The image data buffer pSrc can support down-top storage
 *                            formats. In that case, srcStep can be less than 0.
 * [in]  srcStep        specifies the number of bytes in a line of the image data buffer. This buffer
 *                            contains the current block, which is identified by pSrc. This value can be less than 0 to
 *                            support down to top storage format.
 * [out] pDstMCU [3]    output MCU pointers; must be 8-byte aligned. The buffers
 *                            referenced by pDstMCU[] support top-down storage format only. The output
 *                            components are expressed using a Q8 representation and are bounded on the
 *                            interval [-128, 127]. pDstMCU[0] points to the Y block, pDstMCU[1] points
 *                            to the Cb block, and pDstMCU[2] points to the Cr block.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_RGB888ToYCbCr444LS_MCU_U8_S16_C3P3R (
     const OMX_U8 * pSrc,
     OMX_INT srcStep,
     OMX_S16 * pDstMCU[3]        
 );



/**
 * Function: omxIPCS_RGB888ToYCbCr422LS_MCU_U8_S16_C3P3R 
 *
 * Description:
 * RGB to YCbCr422 color conversion function.
 *
 * Remarks:
 * This function converts RGB data to YCbCr data with level-shift and
 * sampling (in 4:2:2). It processes image data in MCU size, 
 * 16x8(Y block) for 422.
 *
 *
 * Parameters:
 * [in]  pSrc           identifies source image data buffer. The source image data are stored in interleaved
 *                            order as BGRBGRBGR... The image data buffer pSrc can support down-top storage
 *                            formats. In that case, srcStep can be less than 0.
 * [in]  srcStep        specifies the number of bytes in a line of the image data buffer. This buffer
 *                            contains the current block, which is identified by pSrc. This value can be less than 0 to
 *                            support down to top storage format.
 * [out] pDstMCU [3]    output MCU pointers; must be 8-byte aligned. The buffers
 *                            referenced by pDstMCU[] support top-down storage format only. The output
 *                            components are expressed using a Q8 representation and are bounded on the
 *                            interval [-128, 127]. pDstMCU[0] points to the Y block, pDstMCU[1] points
 *                            to the Cb block, and pDstMCU[2] points to the Cr block.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_RGB888ToYCbCr422LS_MCU_U8_S16_C3P3R (
     const OMX_U8 * pSrc,
     OMX_INT srcStep,
     OMX_S16 * pDstMCU[3]        
 );



/**
 * Function: omxIPCS_RGB888ToYCbCr420LS_MCU_U8_S16_C3P3R 
 *
 * Description:
 * RGB to YCbCr420 color conversion function.
 *
 * Remarks:
 * This function converts RGB data to YCbCr data with level-shift and
 * sampling (in 4:1:1). It processes image data in MCU size, 16x16(Y block) for 420;
 *
 *
 * Parameters:
 * [in]  pSrc           identifies source image data buffer. The source image data are stored in interleaved
 *                            order as BGRBGRBGR... The image data buffer pSrc can support down-top storage
 *                            formats. In that case, srcStep can be less than 0.
 * [in]  srcStep        specifies the number of bytes in a line of the image data buffer. This buffer
 *                            contains the current block, which is identified by pSrc. This value can be less than 0 to
 *                            support down to top storage format.
 * [out] pDstMCU [3]    output MCU pointers; must be 8-byte aligned. The buffers
 *                            referenced by pDstMCU[] support top-down storage format only. The output
 *                            components are expressed using a Q8 representation and are bounded on the
 *                            interval [-128, 127]. pDstMCU[0] points to the Y block, pDstMCU[1] points
 *                            to the Cb block, and pDstMCU[2] points to the Cr block.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_RGB888ToYCbCr420LS_MCU_U8_S16_C3P3R (
     const OMX_U8 * pSrc,
     OMX_INT srcStep,
     OMX_S16 * pDstMCU[3]        
 );



/**
 * Function: omxIPCS_RGB565ToYCbCr444LS_MCU_U16_S16_C3P3R 
 *
 * Description:
 * RGB565 to YCbCr444 color conversion function.
 *
 * Remarks:
 * This function converts packed RGB565 data to YCbCr data with level-shift and 4:2:2
 * subsampling. Data is processed in MCU block sizes, i.e., 8x8 for 444, and 16x8 for 422.
 *
 *
 * Parameters:
 * [in]  pSrc           references the source image data buffer. Pixel intensities are interleaved as [B G R B
 *                            G R ...], where G, B, and R are represented using, repspectively, 6, 5, and 5 bits. The image
 *                            data buffer pSrc can support down-top storage formats. In that case, srcStep can be less
 *                            than 0.
 * [in]  srcStep        specifies the number of bytes in a line of the image data buffer. This buffer
 *                            contains the current block, which is identified by pSrc. This value can be less than 0 to
 *                            support down to top storage format.
 * [out] pDstMCU [3]    output MCU pointers; must be 8-byte aligned. The buffers
 *                            referenced by pDstMCU[] support top-down storage format only. The output
 *                            components are expressed using a Q8 representation and are bounded on the
 *                            interval [-128, 127]. pDstMCU[0] points to the Y block, pDstMCU[1] points
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_RGB565ToYCbCr444LS_MCU_U16_S16_C3P3R (
     const OMX_U16 * pSrc,
     OMX_INT srcStep,
     OMX_S16 * pDstMCU[3]        
 );



/**
 * Function: omxIPCS_RGB565ToYCbCr422LS_MCU_U16_S16_C3P3R 
 *
 * Description:
 * RGB565 to YCbCr422 color conversion function.
 *
 * Remarks:
 * This function converts packed RGB565 data to YCbCr data with level-shift and 4:2:2
 * subsampling. Data is processed in MCU block sizes, i.e., 8x8 for 444, and 16x8 for 422.
 *
 *
 * Parameters:
 * [in]  pSrc           references the source image data buffer. Pixel intensities are interleaved as [B G R B
 *                            G R ...], where G, B, and R are represented using, repspectively, 6, 5, and 5 bits. The image
 *                            data buffer pSrc can support down-top storage formats. In that case, srcStep can be less
 *                            than 0.
 * [in]  srcStep        specifies the number of bytes in a line of the image data buffer. This buffer
 *                            contains the current block, which is identified by pSrc. This value can be less than 0 to
 *                            support down to top storage format.
 * [out] pDstMCU [3]    output MCU pointers; must be 8-byte aligned. The buffers
 *                            referenced by pDstMCU[] support top-down storage format only. The output
 *                            components are expressed using a Q8 representation and are bounded on the
 *                            interval [-128, 127]. pDstMCU[0] points to the Y block, pDstMCU[1] points
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_RGB565ToYCbCr422LS_MCU_U16_S16_C3P3R (
     const OMX_U16 * pSrc,
     OMX_INT srcStep,
     OMX_S16 * pDstMCU[3]        
 );



/**
 * Function: omxIPCS_RGB565ToYCbCr420LS_MCU_U16_S16_C3P3R 
 *
 * Description:
 * RGB565 to YCbCr420 color conversion function.
 *
 * Remarks:
 * This function converts packed RGB565 data to YCbCr data with level-shift and 4:2:2
 * subsampling. Data is processed in MCU block sizes, i.e., 8x8 for 444, and 16x8 for 422.
 *
 *
 * Parameters:
 * [in]  pSrc           references the source image data buffer. Pixel intensities are interleaved as [B G R B
 *                            G R ...], where G, B, and R are represented using, repspectively, 6, 5, and 5 bits. The image
 *                            data buffer pSrc can support down-top storage formats. In that case, srcStep can be less
 *                            than 0.
 * [in]  srcStep        specifies the number of bytes in a line of the image data buffer. This buffer
 *                            contains the current block, which is identified by pSrc. This value can be less than 0 to
 *                            support down to top storage format.
 * [out] pDstMCU [3]    output MCU pointers; must be 8-byte aligned. The buffers
 *                            referenced by pDstMCU[] support top-down storage format only. The output
 *                            components are expressed using a Q8 representation and are bounded on the
 *                            interval [-128, 127]. pDstMCU[0] points to the Y block, pDstMCU[1] points
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_RGB565ToYCbCr420LS_MCU_U16_S16_C3P3R (
     const OMX_U16 * pSrc,
     OMX_INT srcStep,
     OMX_S16 * pDstMCU[3]        
 );



/**
 * Function: omxIPCS_YCbCr444ToRGB888LS_MCU_S16_U8_P3C3R
 *
 * Description:
 * YCbCr444 to RGB color conversion function.
 *
 * Remarks:
 * This function converts YCbCr data to RGB data with level-shift and sampling (in 4:4:4). They
 * process image data in MCU size, 8x8 for 444; 16x8 for 422.
 *
 *
 * Parameters:
 * [in]  pSrcMCU [3]    identifies a three-pointer array in sequence. The start address of each pointer
 *                            in pSrcMCU[] must be 8-byte aligned. The source data buffers identified by pSrcMCU[]
 *                            support top-down format only.
 *                            pSrcMCU[0] points to Y block
 *                            pSrcMCU[1] points to Cb block
 *                            pSrcMCU[2] points to Cr block
 * [in]  dstStep        specifies the number of bytes in a line of the image data buffer. This buffer
 *                            contains the current block, which is identified by pDst. This value can be less than 0 to
 *                            support down to top storage format.
 * [out] pDst           identifies output image data buffer. The source image data are stored in interleaved order
 *                            as RGBRGBRGB... Each output value in pDst is saturated at [0, 255]. The destination image
 *                            data buffer pDst can support down-top storage formats. In that case, srcStep can be less than 0.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr444ToRGB888LS_MCU_S16_U8_P3C3R(
     const OMX_S16 *pSrcMCU[3],
     OMX_U8 * pDst,
     OMX_INT dstStep        
 );



/**
 * Function: omxIPCS_YCbCr422ToRGB888LS_MCU_S16_U8_P3C3R
 *
 * Description:
 * YCbCr422 to RGB color conversion function.
 *
 * Remarks:
 * This function converts YCbCr data to RGB data with level-shift and sampling (in 4:4:4). They
 * process image data in MCU size, 8x8 for 444; 16x8 for 422.
 *
 *
 * Parameters:
 * [in]  pSrcMCU        identifies a three-pointer array in sequence. The start address of each pointer
 *                            in pSrcMCU[] must be 8-byte aligned. The source data buffers identified by pSrcMCU[]
 *                            support top-down format only.
 *                            pSrcMCU[0] points to Y block
 *                            pSrcMCU[1] points to Cb block
 *                            pSrcMCU[2] points to Cr block
 * [in]  dstStep        specifies the number of bytes in a line of the image data buffer. This buffer
 *                            contains the current block, which is identified by pDst. This value can be less than 0 to
 *                            support down to top storage format.
 * [out] pDst           identifies output image data buffer. The source image data are stored in interleaved order
 *                            as BGRBGRBGR... Each output value in pDst is saturated at [0, 255]. The destination image
 *                            data buffer pDst can support down-top storage formats. In that case, srcStep can be less than 0.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr422ToRGB888LS_MCU_S16_U8_P3C3R(
     const OMX_S16 *pSrcMCU[3],
     OMX_U8 * pDst,
     OMX_INT dstStep        
 );



/**
 * Function: omxIPCS_YCbCr420ToRGB888LS_MCU_S16_U8_P3C3R
 *
 * Description:
 * YCbCr420 to RGB color conversion function.
 *
 * Remarks:
 * This function converts YCbCr data to RGB data with level-shift and sampling (in 4:1:1). They
 * process image data in MCU size, 8x8 for 444; 16x8 for 422.
 *
 *
 * Parameters:
 * [in]  pSrcMCU        identifies a three-pointer array in sequence. The start address of each pointer
 *                            in pSrcMCU[] must be 8-byte aligned. The source data buffers identified by pSrcMCU[]
 *                            support top-down format only.
 *                            pSrcMCU[0] points to Y block
 *                            pSrcMCU[1] points to Cb block
 *                            pSrcMCU[2] points to Cr block
 * [in]  dstStep        specifies the number of bytes in a line of the image data buffer. This buffer
 *                            contains the current block, which is identified by pDst. This value can be less than 0 to
 *                            support down to top storage format.
 * [out] pDst           identifies output image data buffer. The source image data are stored in interleaved order
 *                            as BGRBGRBGR... Each output value in pDst is saturated at [0, 255]. The destination image
 *                            data buffer pDst can support down-top storage formats. In that case, srcStep can be less than 0.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr420ToRGB888LS_MCU_S16_U8_P3C3R(
     const OMX_S16 *pSrcMCU[3],
     OMX_U8 * pDst,
     OMX_INT dstStep        
 );



/**
 * Function: omxIPCS_YCbCr444ToRGB565LS_MCU_S16_U16_P3C3R 
 *
 * Description:
 * YCbCr444 to RGB565 color conversion function.
 *
 * Remarks:
 * This functions converts YCbCr data to RGB565 data to with level-shift and sampling (in 4:4:4).
 * They process image data in MCU size, 8x8 for 444; 16x8 for 422.
 *
 *
 * Parameters:
 * [in]  pSrcMCU        array of input MCU buffer pointers; 8-byte alignment required. Only
 *                            top-down format is supported. Input components are expressed using a Q8 representation and
 *                            are bounded on the interval [-128, 127].
 *                            pSrcMCU[0] points to the Y block
 *                            pSrcMCU[1] points to the Cb block
 *                            pSrcMCU[2] points to the Cr block
 * [in]  dstStep        specifies the number of bytes in a line of the image data buffer. This buffer
 *                            contains the current block, which is identified by pDst. This value can be less than 0 to
 *                            support down to top storage format.
 * [out] pDst           identifies output image data buffer. The image data are stored in interleaved order as [B G
 *                            R B G R B G R...], where G is expressed by 6 bits, and B and R are expressed in 5 bits,
 *                            respectively. Each output value in pDst is saturated. The destination image data buffer pDst
 *                            can support down-top storage formats. In this case, dstStep can be less than 0.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr444ToRGB565LS_MCU_S16_U16_P3C3R (
     const OMX_S16 *pSrcMCU[3],
     OMX_U16 * pDst,
     OMX_INT dstStep        
 );



/**
 * Function: omxIPCS_YCbCr422ToRGB565LS_MCU_S16_U16_P3C3R 
 *
 * Description:
 * YCbCr422 to RGB565 color conversion function.
 *
 * Remarks:
 * This functions converts YCbCr data to RGB565 data to with level-shift and sampling (in 4:2:2).
 * They process image data in MCU size, 8x8 for 444; 16x8 for 422.
 *
 *
 * Parameters:
 * [in]  pSrcMCU        array of input MCU buffer pointers; 8-byte alignment required. Only
 *                            top-down format is supported. Input components are expressed using a Q8 representation and
 *                            are bounded on the interval [-128, 127].
 *                            pSrcMCU[0] points to the Y block
 *                            pSrcMCU[1] points to the Cb block
 *                            pSrcMCU[2] points to the Cr block
 * [in]  dstStep        specifies the number of bytes in a line of the image data buffer. This buffer
 *                            contains the current block, which is identified by pDst. This value can be less than 0 to
 *                            support down to top storage format.
 * [out] pDst           identifies output image data buffer. The image data are stored in interleaved order as [B G
 *                            R B G R B G R...], where G is expressed by 6 bits, and B and R are expressed in 5 bits,
 *                            respectively. Each output value in pDst is saturated. The destination image data buffer pDst
 *                            can support down-top storage formats. In this case, dstStep can be less than 0.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr422ToRGB565LS_MCU_S16_U16_P3C3R (
     const OMX_S16 *pSrcMCU[3],
     OMX_U16 * pDst,
     OMX_INT dstStep        
 );



/**
 * Function: omxIPCS_YCbCr420ToRGB565LS_MCU_S16_U16_P3C3R 
 *
 * Description:
 * YCbCr420 to RGB565 color conversion function.
 *
 * Remarks:
 * This functions converts YCbCr data to RGB565 data to with level-shift and sampling (in 4:1:1).
 * They process image data in MCU size, 8x8 for 444; 16x8 for 422.
 *
 *
 * Parameters:
 * [in] pSrcMCU         array of input MCU buffer pointers; 8-byte alignment required. Only
 *                            top-down format is supported. Input components are expressed using a Q8 representation and
 *                            are bounded on the interval [-128, 127].
 *                            pSrcMCU[0] points to the Y block
 *                            pSrcMCU[1] points to the Cb block
 *                            pSrcMCU[2] points to the Cr block
 * [in] dstStep         specifies the number of bytes in a line of the image data buffer. This buffer
 *                            contains the current block, which is identified by pDst. This value can be less than 0 to
 *                            support down to top storage format.
 * [out] pDst        identifies output image data buffer. The image data are stored in interleaved order as [B G
 *                            R B G R B G R...], where G is expressed by 6 bits, and B and R are expressed in 5 bits,
 *                            respectively. Each output value in pDst is saturated. The destination image data buffer pDst
 *                            can support down-top storage formats. In this case, dstStep can be less than 0.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPCS_YCbCr420ToRGB565LS_MCU_S16_U16_P3C3R (
     const OMX_S16 *pSrcMCU[3],
     OMX_U16 * pDst,
     OMX_INT dstStep        
 );





/**
 * EndDomain: CS
 */


/* *****************************************************************************************/
/** 
 *
 *	NewDomain: BM The Bitmap Manipulation Subdomain
 *  WithinDomain: IP
 * 
 *  StartDomain: BM
 */



/**
 * Function: omxIPBM_Mirror_U8_C1R
 *
 * Description:
 * Mirror function.
 *
 * Remarks:
 * This function mirrors the source image pSrc about a horizontal or vertical axis or both,
 * depending on the flip value, and writes it to the destination image pDst.
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to the source buffer.
 * [in]  srcStep        step, in bytes, through the source image buffer.
 * [in]  dstStep        step, in bytes, through the destination image buffer.
 * [in]  roiSize        size of the source and destination ROI in pixels.
 * [in]  flip           specifies the axis to mirror the image about. Use the following values to specify the axes:
 *                            OMX_IP_HORIZONTAL to mirror about the horizontal axis, OMX_IP_VERTICAL to mirror about the vertical axis and
 *                            OMX_IP_BOTH to mirror both horizontal and vertical axis.
 * [out] pDst           pointer to the destination buffer.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPBM_Mirror_U8_C1R(
     const OMX_U8 *pSrc,
     OMX_INT srcStep,
     OMX_U8 *pDst,
     OMX_INT dstStep,
     OMXSize roiSize,
     OMXIPAxis flip        
 );




/**
 * Function: omxIPBM_Copy_U8_C1R
 *
 * Description:
 * Copy single-channel image.
 *
 * Remarks:
 * Copy pixel values from the ROI of the source image pointed pSrc to the ROI of the destination
 * image pDst.
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to the source ROI
 * [in]  srcStep        distance in bytes between the starts of consecutive lines in the source image
 * [in]  dstStep        distance in bytes between the starts of consecutive lines in the destination image
 * [in]  roiSize        size of the source and destination ROI in pixels
 * [out] pDst           pointer to the destination ROI
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPBM_Copy_U8_C1R(
     const OMX_U8 *pSrc,
     OMX_INT srcStep,
     OMX_U8 *pDst,
     OMX_INT dstStep,
     OMXSize roiSize        
 );




/**
 * Function: omxIPBM_Copy_U8_C3R
 *
 * Description:
 * Copy three channel image.
 *
 * Remarks:
 * Copy pixel values from the ROI of the source image pointed pSrc to the ROI of the destination
 * image pDst.
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to the source ROI
 * [in]  srcStep        distance in bytes between the starts of consecutive lines in the source image
 * [in]  dstStep        distance in bytes between the starts of consecutive lines in the destination image
 * [in]  roiSize        size of the source and destination ROI in pixels
 * [out] pDst           pointer to the destination ROI
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPBM_Copy_U8_C3R(
     const OMX_U8 *pSrc,
     OMX_INT srcStep,
     OMX_U8 *pDst,
     OMX_INT dstStep,
     OMXSize roiSize        
 );




/**
 * Function: omxIPBM_AddC_U8_C1R_Sfs
 *
 * Description:
 * Image arithmetic operation - Add with a constant.
 *
 * Remarks:
 * Add a constant to every pixels in the source ROI, and put the scaled result to the
 * destination ROI. The source and destination are single-channel images.
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to the source ROI
 * [in]  srcStep        distance in bytes between the starts of consecutive lines in the source image
 * [in]  value          constant for operation
 * [in]  dstStep        distance in bytes between the starts of consecutive lines in the destination image
 * [in]  roiSize        size of the source and destination ROI in pixels
 * [in]  scaleFactor    scale factor value
 * [out] pDst           pointer to the destination ROI
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPBM_AddC_U8_C1R_Sfs(
     const OMX_U8 *pSrc,
     OMX_INT srcStep,
     OMX_U8 value,
     OMX_U8 *pDst,
     OMX_INT dstStep,
     OMXSize roiSize,
     OMX_INT scaleFactor        
 );




/**
 * Function: omxIPBM_MulC_U8_C1R_Sfs
 *
 * Description:
 * Image arithmetic operation - Multiply with a constant.
 *
 * Remarks:
 * Multiply a constant to every pixels in the source ROI, and put the scaled result to the
 * destination ROI. The source and destination are single-channel images.
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to the source ROI
 * [in]  srcStep        distance in bytes between the starts of consecutive lines in the source image
 * [in]  value          constant for operation
 * [in]  dstStep        distance in bytes between the starts of consecutive lines in the destination image
 * [in]  roiSize        size of the source and destination ROI in pixels
 * [in]  scaleFactor    scale factor value
 * [out] pDst           pointer to the destination ROI
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPBM_MulC_U8_C1R_Sfs(
     const OMX_U8 *pSrc,
     OMX_INT srcStep,
     OMX_U8 value,
     OMX_U8 *pDst,
     OMX_INT dstStep,
     OMXSize roiSize,
     OMX_INT scaleFactor        
 );

/**
 * EndDomain: BM
 */

/**
 * EndDomain: IP
 */



#ifdef __cplusplus
}
#endif

#endif /** _OMXIP_H_ */

/** EOF */


