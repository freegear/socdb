/* ----------------------------------------------------------------
 *
 *  omxVCM4P10_FilterDeblockingChroma_VerEdge_I.c
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
 * H.264 deblocking module
 * 
 */
 
#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"
#include "armVC.h"

/**
 * Function: omxVCM4P10_FilterDeblockingChroma_VerEdge_I,
 *
 * Description:
 * Performs deblocking filtering on four vertical edges of the chroma
 * macroblock(8x8).
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcDst		Pointer to the input macroblock; must be 8-byte aligned.
 * [in]	srcdstStep	Step of the arrays. Must be multiple of 8.
 * [in]	pAlpha		Array of size 2 of Alpha Thresholds (the first item
 *							is alpha threshold for external vertical edge, and
 *							the second item is for internal vertical edge)
 * [in]	pBeta		Array of size 2 of Beta Thresholds (the first item is
 *							alpha threshold for external vertical edge, and the
 *							second item is for internal vertical edge)
 * [in]	pThresholds	Array of size 16 of Thresholds (TC0)
 *                  (values for the left edge of each 4x2 or above edge of each 2x4 block,
 *                   arranged in vertical block order)
 * [in]	pBS			Array of size 16 of BS parameters (values for each 2x2 chroma block, arranged in vertical block order).
 *                      This parameter is the same as the pBS parameter passed into FilterDeblockLuma_VerEdge;
 *                      valid in the range [0,4] with the following restrictions: i) pBS[i]== 4 may occur only for 0<=i<=3, ii) pBS[i]== 4 if and
 *                       only if pBS[i^1]== 4.  Must be 4-byte aligned.
 * [out] pSrcDst		Pointer to filtered output macroblock.
 *
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 * If one of the following cases occurs, the function returns OMX_StsBadArgErr:
 *   - one or more of the following pointers is NULL:  pSrcDst, pAlpha, pBeta, pThresholds, or pBS.
 *   - either pThresholds or pBS is not aligned on a 4-byte boundary.
 *   - pSrcDst is not 8-byte aligned.
 *   - srcdstStep is not a multiple of 8.
 *   - pBS is out of range, i.e., one of the following conditions is true: pBS[i]<0, pBS[i]>4, pBS[i]==4 for i>=4, or (pBS[i]==4 && pBS[i^1]!=4) for 0<=i<=3.
 */

OMXResult omxVCM4P10_FilterDeblockingChroma_VerEdge_I(
     OMX_U8* pSrcDst,
     OMX_S32 srcdstStep,
     const OMX_U8* pAlpha,
     const OMX_U8* pBeta,
     const OMX_U8* pThresholds,
     const OMX_U8 *pBS        
 )
{
    int I, X, Y, Internal=0;

    armRetArgErrIf(pSrcDst == NULL,                 OMX_StsBadArgErr);
    armRetArgErrIf(armNot8ByteAligned(pSrcDst),     OMX_StsBadArgErr);
    armRetArgErrIf(srcdstStep & 7,                  OMX_StsBadArgErr);
    armRetArgErrIf(pAlpha == NULL,                  OMX_StsBadArgErr);
    armRetArgErrIf(pBeta == NULL,                   OMX_StsBadArgErr);
    armRetArgErrIf(pThresholds == NULL,             OMX_StsBadArgErr);
    armRetArgErrIf(armNot4ByteAligned(pThresholds), OMX_StsBadArgErr);
    armRetArgErrIf(pBS == NULL,                     OMX_StsBadArgErr);
    armRetArgErrIf(armNot4ByteAligned(pBS),         OMX_StsBadArgErr);

    for (X=0; X<8; X+=4, Internal=1)
    {
        for (Y=0; Y<8; Y++)
        {
            I = (Y>>1)+4*(X>>1);
            
            armRetArgErrIf(pBS[I] > 4, OMX_StsBadArgErr)
            
            armRetArgErrIf( (I > 3) && (pBS[I] == 4),
                            OMX_StsBadArgErr)
            
            armRetArgErrIf( (I < 4)       && 
                          ( (pBS[I] == 4) && (pBS[I^1] != 4) ),
                            OMX_StsBadArgErr)
            

            /* Filter vertical edge with q0 at (X,Y) */
            armVCM4P10_DeBlockPixel(
                pSrcDst + Y*srcdstStep + X,
                1,
                pThresholds[(Y>>1)+4*(X>>2)],
                pAlpha[Internal],
                pBeta[Internal],
                pBS[I],
                1);
        }
    }

    return OMX_StsNoErr;
}
