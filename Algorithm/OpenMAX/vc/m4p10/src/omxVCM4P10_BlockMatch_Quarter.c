/**
 *  omxVCM4P10_BlockMatch_Quarter.c
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
 * Contains modules for quater pel Block matching, 
 * 
 */
 
#include "omxVC.h"
#include "armVC.h"
#include "armCOMM.h"
 
    
/**
 * Function: omxVCM4P10_BlockMatch_Quarter
 *
 * Description:
 * Performs a quarter-pel block match using results from a prior half-pel search.  Returns 
 * the best MV and associated cost.  This function estimates the quarter-pixel motion vector 
 * by interpolating the half-pel resolution motion vector referenced by the input parameter 
 * pSrcDstBestMV, i.e., the initial half-pel MV is generated externally.  The function 
 * omxVCM4P10_BlockMatch_Half may be used for half-pel motion estimation.
 *
 * Remarks:
 *
 * Parameters:
 * [in] pSrcOrgY - Pointer to the current position in original picture plane.
 *                    In case iBlockWidth==4,  4-byte aligned.
 *                    In case iBlockWidth==8,  8-byte aligned.
 *                    In case iBlockWidth==16, 16-byte aligned.
 * [in] pSrcRefY - Pointer to the top-left corner of the co-located MB in the reference picture
 * [in] nSrcOrgStep - Stride of the original picture plane in terms of full pixels
 *                       Must be multiple of iBlockWidth.
 * [in] nSrcRefStep - Stride of the reference picture plane in terms of full pixels
 * [in] iBlockWidth - Width of the current block in terms of full pixels
 * [in] iBlockHeight - Height of the current block in terms of full pixels
 * [in] nLamda - Lamda factor, used to compute motion cost 
 * [in] pMVPred - Predicted MV, represented in terms of 1/4-pel units; used to compute motion cost
 * [in] pSrcDstBestMV -     The best MV resulting from a prior half-pel search, represented in terms of 1/4-pel units
 * [out]    pSrcDstBestMV - Best MV resulting from the quarter-pel search, expressed in terms of 1/4-pel units 
 * [out]    pBestCost - Motion cost associated with the best MV; computed as SAD+Lamda*BitsUsedByMV
 *
 * Return Value:
 * OMX_StsNoErr - No Error
 * OMX_StsBadArgErr - Bad arguments:
 */
 
OMXResult omxVCM4P10_BlockMatch_Quarter(
    const OMX_U8* pSrcOrgY, 
    OMX_S32 nSrcOrgStep, 
    const OMX_U8* pSrcRefY, 
    OMX_S32 nSrcRefStep, 
    OMX_U8 iBlockWidth, 
    OMX_U8 iBlockHeight, 
    OMX_U32 nLamda, 
    const OMXVCMotionVector* pMVPred, 
    OMXVCMotionVector* pSrcDstBestMV, 
    OMX_S32* pBestCost
)
{
    /* Definitions and Initializations*/
    OMX_INT     candSAD;
    OMX_INT     fromX, toX, fromY, toY;
    /* Offset to the reference at the begining of the bounding box */
    const OMX_U8      *pTempSrcRefY, *pTempSrcOrgY;
    OMX_S16     x, y;
    OMXVCMotionVector diffMV, candMV, initialMV;
    OMX_U8      interpolY[256];
    OMX_S32     pelPosX, pelPosY;

    /* Argument error checks */
    armRetArgErrIf((iBlockWidth ==  4) && (!armIs4ByteAligned(pSrcOrgY)), OMX_StsBadArgErr);
    armRetArgErrIf((iBlockWidth ==  8) && (!armIs8ByteAligned(pSrcOrgY)), OMX_StsBadArgErr);
    armRetArgErrIf((iBlockWidth == 16) && (!armIs16ByteAligned(pSrcOrgY)), OMX_StsBadArgErr);
    armRetArgErrIf((nSrcOrgStep % iBlockWidth), OMX_StsBadArgErr);
    armRetArgErrIf(pSrcOrgY == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pSrcRefY == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pMVPred == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pSrcDstBestMV == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pBestCost == NULL, OMX_StsBadArgErr);
        
            
    /* Check for valid region */ 
    fromX = 1;
    toX   = 1;
    fromY = 1;
    toY   = 1;
    
    /* Initialize to max value as a start point */
    *pBestCost = 0x7fffffff;
    
    initialMV.dx = pSrcDstBestMV->dx;
    initialMV.dy = pSrcDstBestMV->dy;
    
    /* Looping on y- axis */
    for (y = -fromY; y <= toY; y++)
    {
        /* Looping on x- axis */
        for (x = -fromX; x <= toX; x++)
        {
            /* Positioning the pointer */
            pTempSrcRefY = pSrcRefY + (nSrcRefStep * (initialMV.dy/4)) + (initialMV.dx/4);
            
            /* Calculating the fract pel position */
            pelPosX = (initialMV.dx % 4) + x;
            if (pelPosX < 0) 
            {
                pTempSrcRefY = pTempSrcRefY - 1;
                pelPosX += 4;
            }
            pelPosY = (initialMV.dy % 4) + y;
            if (pelPosY < 0) 
            {
                pTempSrcRefY = pTempSrcRefY - (1 * nSrcRefStep);
                pelPosY += 4;
            }
            
            pTempSrcOrgY = pSrcOrgY; 
            
            /* Prepare cand MV */
            candMV.dx = initialMV.dx + x;
            candMV.dy = initialMV.dy + y;
             
            /* Interpolate Quater pel for the current position*/
            armVCM4P10_Interpolate_Luma(
                        pTempSrcRefY,
                        nSrcRefStep,
                        interpolY,
                        iBlockWidth,
                        iBlockWidth,
                        iBlockHeight,
                        pelPosX,
                        pelPosY);
            
            /* Calculate the SAD */
            armVCCOMM_SAD(	
                        pTempSrcOrgY,
                        nSrcOrgStep,
                        interpolY,
                        iBlockWidth,
                        &candSAD,
                        iBlockHeight,
                        iBlockWidth);
 
            diffMV.dx = candMV.dx - pMVPred->dx;
            diffMV.dy = candMV.dy - pMVPred->dy;
            
            /* Result calculations */
            armVCM4P10_CompareMotionCostToMV (
                        candMV.dx, 
                        candMV.dy, 
                        diffMV, 
                        candSAD, 
                        pSrcDstBestMV, 
                        nLamda, 
                        pBestCost);

        } /* End of x- axis */
    } /* End of y-axis */

    return OMX_StsNoErr;

}

/* End of file */
