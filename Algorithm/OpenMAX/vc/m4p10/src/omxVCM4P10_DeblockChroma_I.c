/* ----------------------------------------------------------------
 *
 *  omxVCM4P10_DeblockChroma_I.c
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
 * H.264 intra chroma deblock
 * 
 */
 
#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"
#include "armVC.h"

/**
 * Function: omxVCM4P10_DeblockChroma_I
 *
 * Description:
 * Performs deblocking filtering on all edges of the chroma macroblock (16x16).
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcDst         pointer to the input macroblock. Must be 8-byte aligned.
 * [in]	srcdstStep      Step of the arrays
 * [in]	pAlpha          pointer to a 2x2 array of alpha thresholds, organized as follows: { external
 *                          vertical edge, internal  vertical edge, external
 *                         horizontal edge, internal horizontal edge }
 * [in]	pBeta			pointer to a 2x2 array of beta thresholds, organized as follows: { external
 *                              vertical edge, internal vertical edge, external  horizontal edge,
 *                              internal  horizontal edge }
 * [in]	pThresholds		AArray of size  8x2 of Thresholds (TC0) (values for the left or
 *                               above edge of each 4x2 or 2x4 block, arranged in  vertical block order
 *                               and then in  horizontal block order)
 * [in]	pBS				array of size 16x2 of BS parameters (arranged in scan block order for vertical edges and then horizontal edges);
 *                         valid in the range [0,4] with the following restrictions: i) pBS[i]== 4 may occur only for 0<=i<=3, ii) pBS[i]== 4 if and only if pBS[i^1]== 4.  Must be 4-byte aligned.
 * [out]	pSrcDst		pointer to filtered output macroblock
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *   - Either of the pointers in pSrcDst, pAlpha, pBeta, pTresholds, or pBS is NULL.
 *   - pSrcDst is not 8-byte aligned.
 *   - either pThresholds or pBS is not 4-byte aligned.
 *   - pBS is out of range, i.e., one of the following conditions is true: pBS[i]<0, pBS[i]>4, pBS[i]==4 for i>=4, or (pBS[i]==4 && pBS[i^1]!=4) for 0<=i<=3.
 *   - srcdstStep is not a multiple of 8.
 *
 */
OMXResult omxVCM4P10_DeblockChroma_I(
	OMX_U8* pSrcDst, 
	OMX_S32 srcdstStep, 
	const OMX_U8* pAlpha, 
	const OMX_U8* pBeta, 
	const OMX_U8* pThresholds,
    const OMX_U8 *pBS
)
{
    OMXResult errorCode;
    
    armRetArgErrIf(pSrcDst == NULL,                 OMX_StsBadArgErr);
    armRetArgErrIf(armNot8ByteAligned(pSrcDst),     OMX_StsBadArgErr);
    armRetArgErrIf(srcdstStep & 7,                  OMX_StsBadArgErr);
    armRetArgErrIf(pAlpha == NULL,                  OMX_StsBadArgErr);
    armRetArgErrIf(pBeta == NULL,                   OMX_StsBadArgErr);
    armRetArgErrIf(pThresholds == NULL,             OMX_StsBadArgErr);
    armRetArgErrIf(armNot4ByteAligned(pThresholds), OMX_StsBadArgErr);
    armRetArgErrIf(pBS == NULL,                     OMX_StsBadArgErr);
    armRetArgErrIf(armNot4ByteAligned(pBS),         OMX_StsBadArgErr);

    errorCode = omxVCM4P10_FilterDeblockingChroma_VerEdge_I(
        pSrcDst, srcdstStep, pAlpha, pBeta, pThresholds, pBS);

    armRetArgErrIf(errorCode != OMX_StsNoErr, errorCode)
    
    errorCode = omxVCM4P10_FilterDeblockingChroma_HorEdge_I(
        pSrcDst, srcdstStep, pAlpha+2, pBeta+2, pThresholds+8, pBS+16);

    return errorCode;
}
