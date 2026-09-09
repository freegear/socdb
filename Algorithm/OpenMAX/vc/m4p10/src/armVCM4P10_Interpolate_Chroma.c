/**
 *  armVCM4P10_Interpolate_Chroma.c
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
 * This function will calculate interpolation for chroma components
 * 
 */

#include "omxtypes.h"
#include "armCOMM.h"

/**
 * Function: armVCM4P10_Interpolate_Chroma
 *
 * Description:
 * This function performs interpolation for chroma components.
 *
 * Remarks:
 *
 *  [in]    pSrc            Pointer to top-left corner of block used to 
 *                                              interpolate in the reconstructed frame plane
 *  [in]    iSrcStep    Step of the source buffer.
 *  [in]    iDstStep    Step of the destination(interpolation) buffer.
 *  [in]    iWidth      Width of the current block
 *  [in]    iHeight     Height of the current block
 *  [in]    dx              Fractional part of horizontal motion vector 
 *                                              component in 1/8 pixel unit (0~7) 
 *  [in]    dy              Fractional part of vertical motion vector 
 *                                              component in 1/8 pixel unit (0~7)
 *  [out]   pDst            Pointer to the interpolation buffer
 *
 * Return Value:
 * Standard OMXResult value.
 *
 */
 OMXResult armVCM4P10_Interpolate_Chroma(
        OMX_U8      *pSrc,
        OMX_U32     iSrcStep,
        OMX_U8      *pDst,
        OMX_U32     iDstStep,
        OMX_U32     iWidth,
        OMX_U32     iHeight,
        OMX_U32     dx,
        OMX_U32     dy
)
{
    OMX_U32     EightMinusdx = 8 - dx;
    OMX_U32     EightMinusdy = 8 - dy;
    OMX_U32     ACoeff, BCoeff, CCoeff, DCoeff;
    OMX_U32     x, y;

    /* check for argument error */
    armRetArgErrIf(pSrc == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(dx > 7, OMX_StsBadArgErr)
    armRetArgErrIf(dy > 7, OMX_StsBadArgErr)
    armRetArgErrIf(iSrcStep == 0, OMX_StsBadArgErr)
    armRetArgErrIf(iDstStep == 0, OMX_StsBadArgErr)
    armRetArgErrIf(iWidth == 0, OMX_StsBadArgErr)
    armRetArgErrIf(iHeight == 0, OMX_StsBadArgErr)
    
    /* if fractionl mv is not (0, 0) */
    if (dx != 0 || dy != 0)
    {
        ACoeff = EightMinusdx * EightMinusdy;
        BCoeff = dx * EightMinusdy;
        CCoeff = EightMinusdx * dy;
        DCoeff = dx * dy;

        for (y = 0; y < iHeight; y++)
        {
            for (x = 0; x < iWidth; x++)
            {
                pDst [y * iDstStep + x] = (
                    ACoeff * pSrc [y * iSrcStep + x] +
                    BCoeff * pSrc [y * iSrcStep + x + 1] +
                    CCoeff * pSrc [(y + 1) * iSrcStep + x] +
                    DCoeff * pSrc [(y + 1) * iSrcStep + x + 1] +
                    32) >> 6;
            }
        }
    }
    else
    {
        for (y = 0; y < iHeight; y++)
        {
            for (x = 0; x < iWidth; x++)
            {
                pDst [y * iDstStep + x] = pSrc [y * iSrcStep + x];
            }
        }
    }

    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

