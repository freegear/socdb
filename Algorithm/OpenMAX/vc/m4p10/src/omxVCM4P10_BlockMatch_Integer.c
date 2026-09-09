/**
 *  omxVCM4P10_BlockMatch_Integer.c
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
 * Description:
 * Contains modules for Block matching, a full search algorithm
 * is implemented
 * 
 */
 
#include "omxVC.h"
#include "armVC.h"
#include "armCOMM.h"

/**
 * Function: omxVCM4P10_BlockMatch_Integer
 *
 * Description:
 *  Performs integer block match.  Returns best MV and associated cost.
 *
 * Remarks:
 *
 * Parameters:
 *  [in]    pSrcOrgY - Pointer to the top-left corner of the current MB. 
 *                    In case iBlockWidth==4,  4-byte aligned.
 *                    In case iBlockWidth==8,  8-byte aligned.
 *                    In case iBlockWidth==16, 16-byte aligned.
 *    [in]    pSrcRefY - Pointer to the top-left corner of the co-located MB in the reference picture
 *    [in]    nSrcOrgStep - Stride of the original picture plane, expressed in terms of integer pixels. 
 *                       Must be multiple of iBlockWidth.
 *    [in]    nSrcRefStep - Stride of the reference picture plane, expressed in terms of integer pixels
 *    [in]  nMBPosX - X coordinate of the top-left corner of the current MB, expressed in terms of integer pixels
 *    [in]  nMBPosY - Y coordinate of the top-left corner of the current MB, expressed in terms of integer pixels
 *    [in]  iBlockWidth - Width of the current block, expressed in terms of integer pixels
 *    [in]  iBlockHeight - Height of the current block, expressed in terms of integer pixels
 *    [in]  nSearchRange - Motion search range, expressed in terms of integer pixels
 *    [in]    nLamda - Lamda factor; used to compute motion cost 
 *    [in]  pMVPred - Predicted MV; used to compute motion cost, expressed in terms of 1/4-pel units
 *    [in]    pMVCandidate - Candidate MV; used to initialize the motion search, expressed in terms of integer pixels
 *    [in]    pMESpec - pointer to the ME specification structure
 *  [out]    pBestMV - Best MV resulting from integer search, expressed in terms of 1/4-pel units 
 *    [out] pBestCost - Motion cost associated with the best MV; computed as SAD+Lamda*BitsUsedByMV 
 *
 * Return Value:
 * OMX_StsNoErr - No Error
 * OMX_StsBadArgErr - Bad arguments:
 *
 */
 
 OMXResult omxVCM4P10_BlockMatch_Integer (
     const OMX_U8 *pSrcOrgY,
     OMX_S32 nSrcOrgStep,
     const OMX_U8 *pSrcRefY,
     OMX_S32 nSrcRefStep,
	 const OMXRect *pRefRect,
	 const OMXVCM4P2Coordinate *pCurrPointPos,
     OMX_U8 iBlockWidth,
     OMX_U8 iBlockHeight,
     OMX_U32 nLamda,
     const OMXVCMotionVector *pMVPred,
     const OMXVCMotionVector *pMVCandidate,
     OMXVCMotionVector *pBestMV,
     OMX_S32 *pBestCost,
     void *pMESpec
)
{
    /* Definitions and Initializations*/
    OMX_INT     candSAD;
    OMX_INT     fromX, toX, fromY, toY;
    /* Offset to the reference at the begining of the bounding box */
    const OMX_U8      *pTempSrcRefY, *pTempSrcOrgY;
    OMX_S16     x, y;
    OMXVCMotionVector diffMV;
    OMX_S32     nSearchRange;
    /* Argument error checks */
    armRetArgErrIf((iBlockWidth ==  4) && (!armIs4ByteAligned(pSrcOrgY)), OMX_StsBadArgErr);
    armRetArgErrIf((iBlockWidth ==  8) && (!armIs8ByteAligned(pSrcOrgY)), OMX_StsBadArgErr);
    armRetArgErrIf((iBlockWidth == 16) && (!armIs16ByteAligned(pSrcOrgY)), OMX_StsBadArgErr);
    armRetArgErrIf(pSrcOrgY == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pSrcRefY == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pMVPred == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pMVCandidate == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pBestMV == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pBestCost == NULL, OMX_StsBadArgErr);
    
    armIgnore (pMESpec);
    if(iBlockWidth == 4)
    {
        nSearchRange = ((OMXVCM4P10MEParams  *)pMESpec)->searchRange4x4;
    }
    else if(iBlockWidth == 8)
    {
        nSearchRange = ((OMXVCM4P10MEParams  *)pMESpec)->searchRange8x8;
    }
    else
    {
        nSearchRange = ((OMXVCM4P10MEParams  *)pMESpec)->searchRange16x16;
    }
    /* Check for valid region */ 
    fromX = nSearchRange;
    toX   = nSearchRange;
    fromY = nSearchRange;
    toY   = nSearchRange;
    
    if ((pCurrPointPos->x - nSearchRange) < pRefRect->x)
    {
        fromX =  pCurrPointPos->x - pRefRect->x;
    }

    if ((pCurrPointPos->x + iBlockWidth + nSearchRange) > (pRefRect->x + pRefRect->width))
    {
        toX   = pRefRect->width - (pCurrPointPos->x - pRefRect->x) - iBlockWidth;
    }

    if ((pCurrPointPos->y - nSearchRange) < pRefRect->y)
    {
        fromY = pCurrPointPos->y - pRefRect->y;
    }

    if ((pCurrPointPos->y + iBlockWidth + nSearchRange) > (pRefRect->y + pRefRect->height))
    {
        toY   = pRefRect->width - (pCurrPointPos->y - pRefRect->y) - iBlockWidth;
    }
    
    pBestMV->dx = -fromX * 4;
    pBestMV->dy = -fromY * 4;
    /* Initialize to max value as a start point */
    *pBestCost = 0x7fffffff;
    
    /* Looping on y- axis */
    for (y = -fromY; y <= toY; y++)
    {
        /* Looping on x- axis */
        for (x = -fromX; x <= toX; x++)
        {
            /* Positioning the pointer */
            pTempSrcRefY = pSrcRefY + (nSrcRefStep * y) + x;
            pTempSrcOrgY = pSrcOrgY;
            
            /* Calculate the SAD */
            armVCCOMM_SAD(	
    	        pTempSrcOrgY,
    	        nSrcOrgStep,
    	        pTempSrcRefY,
    	        nSrcRefStep,
    	        &candSAD,
    	        iBlockHeight,
    	        iBlockWidth);
    	    
            diffMV.dx = (x * 4) - pMVPred->dx;
            diffMV.dy = (y * 4) - pMVPred->dy;
            
            /* Result calculations */
            armVCM4P10_CompareMotionCostToMV ((x * 4), (y * 4), diffMV, candSAD, pBestMV, nLamda, pBestCost);

        } /* End of x- axis */
    } /* End of y-axis */

    return OMX_StsNoErr;

}

/* End of file */
