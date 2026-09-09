/**
 *  omxVCM4P10_InterpolateHalfHor_Luma.c
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
 * This function will calculate Half horizontal luma interpolation
 * 
 */

#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"
#include "armVC.h"

/**
 * Function: omxVCM4P10_InterpolateHalfHor_Luma
 *
 * Description:
 * This function performs interpolation for two horizontal 1/2-pel positions - (-1/2,0)
 * and (1/2, 0) - around a full-pel position .
 *
 * Remarks:
 *
 *	[in]	pSrc			Pointer to top-left corner of block used to interpolate
 													in the reconstructed frame plane
 *	[in]	iSrcStep	Step of the source buffer.
 *	[in]	iDstStep	Step of the destination(interpolation) buffer.
 *	[in]	iWidth		Width of the current block;must be equal to either 4, 8, or 16
 *	[in]	iHeight		Height of the current block;must be equal to either 4, 8, or 16
 *	[out]	pDstLeft	Pointer to the interpolation buffer of the left 1/2-pel
 *									position (-1/2, 0)
 *                    In case iWidth==4,  4-byte aligned.
 *                    In case iWidth==8,  8-byte aligned.
 *                    In case iWidth==16, 16-byte aligned.
 *	[out]	pDstRight	Pointer to the interpolation buffer of the right 1/2-pel
 *									position (1/2, 0)
 *                    In case iWidth==4,  4-byte aligned.
 *                    In case iWidth==8,  8-byte aligned.
 *                    In case iWidth==16, 16-byte aligned.
 *
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 * If one of the following cases occurs, the function returns OMX_StsBadArgErr:
 *   pSrc or pDstLeft or pDstRight is NULL.
 *	 iWidth or iHeight is out of range {4, 8, 16}.
 *	 iWidth is equal to  4, but pDstLeft or pDstRight is not  4 byte aligned.
 *	 iWidth is equal to  8, but pDstLeft or pDstRight is not  8 byte aligned.
 *	 iWidth is equal to 16, but pDstLeft or pDstRight is not 16 byte aligned.
 *
 */

OMXResult omxVCM4P10_InterpolateHalfHor_Luma(
        const OMX_U8*     pSrc, 
        OMX_U32     iSrcStep, 
        OMX_U8*     pDstLeft, 
        OMX_U8*     pDstRight, 
        OMX_U32     iDstStep, 
        OMX_U32     iWidth, 
        OMX_U32     iHeight
)
{
    OMXResult   RetValue;    

    /* check for argument error */
    armRetArgErrIf(pSrc == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstLeft == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstRight == NULL, OMX_StsBadArgErr)
    armRetArgErrIf((iWidth == 4) && 
                   armNot4ByteAligned(pDstLeft) &&
                   armNot4ByteAligned(pDstRight), OMX_StsBadArgErr)
    armRetArgErrIf((iWidth == 8) && 
                   armNot8ByteAligned(pDstLeft) &&
                   armNot8ByteAligned(pDstRight), OMX_StsBadArgErr)
    armRetArgErrIf((iWidth == 16) && 
                   armNot16ByteAligned(pDstLeft) &&
                   armNot16ByteAligned(pDstRight), OMX_StsBadArgErr)

    RetValue = armVCM4P10_InterpolateHalfHor_Luma (
        pSrc - 1,     
        iSrcStep, 
        pDstLeft,     
        iDstStep, 
        iWidth,   
        iHeight);

    if (RetValue != OMX_StsNoErr)
    {
        return RetValue;
    }

    RetValue = armVCM4P10_InterpolateHalfHor_Luma (
        pSrc,     
        iSrcStep, 
        pDstRight,     
        iDstStep, 
        iWidth,   
        iHeight);

    return RetValue;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

