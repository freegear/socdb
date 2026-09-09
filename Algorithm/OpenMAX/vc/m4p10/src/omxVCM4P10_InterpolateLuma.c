/**
 *  omxVCM4P10_InterpolateLuma.c
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
 * Description:
 * This function will calculate Performs quarter-pixel interpolation 
 * 
 */

#include "omxtypes.h"
#include "omxVC.h"
#include "armVC.h"
#include "armCOMM.h"

/**
 * Function: omxVCM4P10_InterpolateLuma,
 *
 * Description:
 * Performs quarter-pixel interpolation for inter luma MB.
 * It's assumed that the frame is already padded when calling this function.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrc		Pointer to the source reference frame buffer
 * [in]	srcStep		Reference frame step in byte
 * [in]	dstStep		Destination frame step in byte. Must be multiple of roi.width
 * [in]	dx			Fractional part of horizontal motion vector
 *							component in 1/4 pixel unit; valid in the range [0,3]
 * [in]	dy			Fractional part of vertical motion vector
 *							component in 1/4 pixel unit; valid in the range [0,3]
 * [in]	roi			Dimension of the interpolation region;the parameters roi.width and roi.height must
 *                   be equal to either 4, 8, or 16.
 * [out]	pDst		Pointer to the destination frame buffer.
 *                   if roi.width==4,  4-byte alignment required
 *                   if roi.width==8,  8-byte alignment required
 *                   if roi.width==16, 16-byte alignment required
 *
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 * If one of the following cases occurs, the function returns OMX_StsBadArgErr:
 *   pSrc or pDst is NULL.
 *   srcStep or dstStep < roi.width.
 *	 dx or dy is out of range [0-3].
 *	 roi.width or roi.height is out of range {4, 8, 16}.
 *	 roi.width is equal to 4, but pDst is not 4 byte aligned.
 *	 roi.width is equal to 8, but pDst is not 8 byte aligned.
 *	 roi.width is equal to 16, but pDst is not 16 byte aligned.
 *	 srcStep or dstStep is not a multiple of 8.
 *
 */

OMXResult omxVCM4P10_InterpolateLuma (
     const OMX_U8* pSrc,
     OMX_S32 srcStep,
     OMX_U8* pDst,
     OMX_S32 dstStep,
     OMX_S32 dx,
     OMX_S32 dy,
     OMXSize roi        
 )
{
    /* check for argument error */
    armRetArgErrIf(pSrc == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(srcStep < roi.width, OMX_StsBadArgErr)
    armRetArgErrIf(dstStep < roi.width, OMX_StsBadArgErr)
    armRetArgErrIf(dx < 0, OMX_StsBadArgErr)
    armRetArgErrIf(dx > 3, OMX_StsBadArgErr)
    armRetArgErrIf(dy < 0, OMX_StsBadArgErr)
    armRetArgErrIf(dy > 3, OMX_StsBadArgErr)
    armRetArgErrIf((roi.width != 4) && (roi.width != 8) && (roi.width != 16), OMX_StsBadArgErr)
    armRetArgErrIf((roi.height != 4) && (roi.height != 8) && (roi.height != 16), OMX_StsBadArgErr)
    armRetArgErrIf((roi.width == 4) && armNot4ByteAligned(pDst), OMX_StsBadArgErr)
    armRetArgErrIf((roi.width == 8) && armNot8ByteAligned(pDst), OMX_StsBadArgErr)
    armRetArgErrIf((roi.width == 16) && armNot16ByteAligned(pDst), OMX_StsBadArgErr)
    armRetArgErrIf(srcStep & 7, OMX_StsBadArgErr)
    armRetArgErrIf(dstStep & 7, OMX_StsBadArgErr) 

    return armVCM4P10_Interpolate_Luma 
        (pSrc, srcStep, pDst, dstStep, roi.width, roi.height, dx, dy);

}


/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

