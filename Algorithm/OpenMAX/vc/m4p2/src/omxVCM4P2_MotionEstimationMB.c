/**
 *  omxVCM4P2_MotionEstimationMB.c
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
 * Contains module for motion search 16x16 macroblock
 * 
 */
 
#include "omxVC.h"
#include "armVC.h"
#include "armCOMM.h"

/**
 * Function: armVCM4P2_BlockMatch_16x16
 *
 * Description:
 * 16x16 block match wrapper function, calls omxVCM4P2_BlockMatch_Integer_16x16.
 * If half pel search is enabled it also calls omxVCM4P2_BlockMatch_Half_16x16
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcRefBuf	  pointer to the reference Y plane; points to the reference MB that
 *                    corresponds to the location of the current macroblock in the current
 *                    plane.
 * [in]	srcRefStep	  width of the reference plane
 * [in]	pRefRect	  pointer to the valid rectangular in reference plane. Relative to image origin.
 *                    It's not limited to the image boundary, but depended on the padding. For example,
 *                    if you pad 4 pixels outside the image border, then the value for left border
 *                    can be -4
 * [in]	pSrcCurrBuf	  pointer to the current macroblock extracted from original plane (linear array,
 *                    256 entries); must be aligned on an 16-byte boundary.
 * [in] pCurrPointPos position of the current macroblock in the current plane
 * [in] pSrcPreMV	  pointer to predicted motion vector; NULL indicates no predicted MV
 * [in] pSrcPreSAD	  pointer to SAD associated with the predicted MV (referenced by pSrcPreMV); may be set to NULL if unavailable.
 * [in] pMESpec		  vendor-specific motion estimation specification structure; must have been allocated
 *                    and then initialized using omxVCM4P2_MEInit prior to calling the block matching
 *                    function.
 * [out] pDstMV	      pointer to estimated MV
 * [out] pDstSAD	  pointer to minimum SAD
 * *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *
 */
static OMXResult armVCM4P2_BlockMatch_16x16(
     const OMX_U8 *pSrcRefBuf,
     const OMX_INT srcRefStep,
     const OMXRect *pRefRect,
     const OMX_U8 *pSrcCurrBuf,
     const OMXVCM4P2Coordinate *pCurrPointPos,
     OMXVCMotionVector *pSrcPreMV,
     OMX_INT *pSrcPreSAD,
     void *pMESpec,
     OMXVCMotionVector *pDstMV,
     OMX_INT *pDstSAD
)
{
    OMXVCM4P2MEParams *pMEParams = (OMXVCM4P2MEParams *)pMESpec;
    OMX_INT rndVal;
    
    rndVal = pMEParams->rndVal;
    
    omxVCM4P2_BlockMatch_Integer_16x16(
        pSrcRefBuf,
        srcRefStep,
        pRefRect,
        pSrcCurrBuf,
        pCurrPointPos,
        pSrcPreMV,
        pSrcPreSAD,
        pMEParams,
        pDstMV,
        pDstSAD);
    
    if (pMEParams->halfPelSearchEnable)
    {
        omxVCM4P2_BlockMatch_Half_16x16(
            pSrcRefBuf,
            srcRefStep,
            pRefRect,
            pSrcCurrBuf,
            pCurrPointPos,
            rndVal,
            pDstMV,
            pDstSAD);
    }
 
    return OMX_StsNoErr;        
}

/**
 * Function: armVCM4P2_BlockMatch_8x8
 *
 * Description:
 * 8x8 block match wrapper function, calls omxVCM4P2_BlockMatch_Integer_8x8.
 * If half pel search is enabled it also calls omxVCM4P2_BlockMatch_Half_8x8
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcRefBuf	  pointer to the reference Y plane; points to the reference MB that
 *                    corresponds to the location of the current macroblock in the current
 *                    plane.
 * [in]	srcRefStep	  width of the reference plane
 * [in]	pRefRect	  pointer to the valid rectangular in reference plane. Relative to image origin.
 *                    It's not limited to the image boundary, but depended on the padding. For example,
 *                    if you pad 4 pixels outside the image border, then the value for left border
 *                    can be -4
 * [in]	pSrcCurrBuf	  pointer to the current macroblock extracted from original plane (linear array,
 *                    256 entries); must be aligned on an 16-byte boundary.
 * [in] pCurrPointPos position of the current macroblock in the current plane
 * [in] pSrcPreMV	  pointer to predicted motion vector; NULL indicates no predicted MV
 * [in] pSrcPreSAD	  pointer to SAD associated with the predicted MV (referenced by pSrcPreMV); may be set to NULL if unavailable.
 * [in] pMESpec		  vendor-specific motion estimation specification structure; must have been allocated
 *                    and then initialized using omxVCM4P2_MEInit prior to calling the block matching
 *                    function.
 * [out] pDstMV	      pointer to estimated MV
 * [out] pDstSAD	  pointer to minimum SAD
 * *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *
 */
static OMXResult armVCM4P2_BlockMatch_8x8(
     const OMX_U8 *pSrcRefBuf,
     OMX_INT srcRefStep,
     const OMXRect *pRefRect,
     const OMX_U8 *pSrcCurrBuf,
     const OMXVCM4P2Coordinate *pCurrPointPos,
     OMXVCMotionVector *pSrcPreMV,
     OMX_INT *pSrcPreSAD,
     void *pMESpec,
     OMXVCMotionVector *pSrcDstMV,
     OMX_INT *pDstSAD
)
{
    OMXVCM4P2MEParams *pMEParams = (OMXVCM4P2MEParams *)pMESpec;
    OMX_INT rndVal;
    
    rndVal = pMEParams->rndVal;
    
    omxVCM4P2_BlockMatch_Integer_8x8(
        pSrcRefBuf,
        srcRefStep,
        pRefRect,
        pSrcCurrBuf,
        pCurrPointPos,
        pSrcPreMV,
        pSrcPreSAD,
        pMEParams,
        pSrcDstMV,
        pDstSAD);
    
    if (pMEParams->halfPelSearchEnable)
    {
        omxVCM4P2_BlockMatch_Half_8x8(
            pSrcRefBuf,
            srcRefStep,
            pRefRect,
            pSrcCurrBuf,
            pCurrPointPos,
            rndVal,
            pSrcDstMV,
            pDstSAD);
    }
    
    return OMX_StsNoErr;        
}


/**
 * Function: omxVCM4P2_MotionEstimationMB
 *
 * Description:
 * Performs motion search for a 16x16 macroblock. Selects best motion search
 * strategy from among inter-1MV, inter-4MV, and intra modes. Supports integer
 * and half pixel resolution.
 *
 * Remarks:
 *
 * Parameters:
 * [in] pSrcCurrBuf     pointer to the current position in original picture plane; must be aligned on a 16-byte boundary.
 * [in] srcCurrStep     width of the original picture plane, in terms of full pixels; must be a multiple of 16.
 * [in] pSrcRefBuf      pointer to the reference Y plane; points to the reference plane location corresponding
 *                      to the location of the current macroblock in the current plane; must be aligned on a 16-byte boundary.
 * [in] srcRefStep      width of the reference picture plane, in terms of full pixels; must be a multiple of 16.
 * [in] pRefRect        reference plane valid region rectangle.
 * [in] pCurrPointPos   position of the current macroblock in the current plane
 * [in]	pMESpec         pointer to the vendor-specific motion estimation specification structure; must be allocated
 *                      and then initialized using omxVCM4P2_MEInit prior to calling this function.
 * [in] pSrcDstMBCurr   pointer to information structure for the current MB. The following entries should
 *                      be set prior to calling the function: sliceID - the number of the slice the to which the current MB belongs.
 * [in] pMBInter        array, of dimension four, containing pointers to information associated with four adjacent type INTER MBs
 *                      (Left, Top, Top-Left, Top-Right).  Any pointer in the array may be set equal to NULL if the 
 *                      corresponding MB doesn't exist or is not of type INTER.  The structure elements cbpy and cbpc 
 *                      are ignored.
 *                           -	pMBInter[0] - pointer to left MB information
 *                           -	pMBInter[1] - pointer to top MB information
 *                           -	pMBInter[2] - pointer to top-left MB information 
 *                           -	pMBInter[3] - pointer to top-right MB information. 
 *
 * [in] pMBIntra        array, of dimension four, containing pointers to information associated with four adjacent type INTRA MBs 
 *                      (Left, Top, Top-Left, Top-Right).  Any pointer in the array may be set equal to NULL if the
 *                      corresponding MB doesn't exist or is not of type INTRA.  The structure elements cbpy and cbpc
 *                      are ignored.
 *                           -	pMBIntra[0] - pointer to left MB information
 *                           -	pMBIntra[1] - pointer to top MB information
 *                           -	pMBIntra[2] - pointer to top-left MB information 
 *                           -	pMBIntra[3] - pointer to top-right MB information 
 *
 * [in] pSrcDstMBCurr   pointer to information structure for the current MB.  The following entries should be set prior 
 *                      to calling the function:  sliceID - the number of the slice the to which the current 
 *                      MB belongs.  The structure elements cbpy and cbpc are ignored.
 * [out] pSrcDstMBCurr  pointer to updated information structure for the current MB after MB-level motion estimation has been
 *                      completed.  The following structure members are updated by the ME function: 
 *                           -	mbType          -   macroblock type: OMX_VC_INTRA, OMX_VC_INTER, or OMX_VC_INTER4V. 
 *                           -	pMV0[2][2] 	    - 	estimated motion vectors; represented in terms of ½-pel units.
 *                           -	pMVPred[2][2]	-	predicted motion vectors; represented in terms of ½-pel units.
 *                      The structure members cbpy and cbpc are not updated by the function.
 * [out] pDstSAD        pointer to the minimum SAD for INTER1V, or sum of minimum SADs for INTER4V
 *
 * Return Value:
 * OMX_StsNoErr     - no error
 * OMX_StsBadArgErr - bad arguments:  returned if one or more of the following pointers is NULL: pSrcCurrBuf, 
 *                                    pSrcRefBuf, pRefRect, pCurrPointPos, pMBInter, pMBIntra, pSrcDstMBCurr,
 *                                    or pDstSAD.
 */

OMXResult omxVCM4P2_MotionEstimationMB (
			 const OMX_U8 *pSrcCurrBuf,
			 OMX_U32      srcCurrStep, 
			 const OMX_U8 *pSrcRefBuf, 
			 OMX_INT      srcRefStep, 
			 const OMXRect *pRefRect, 
			 const OMXVCM4P2Coordinate *pCurrPointPos, 
			 void  *pMESpec,
			 const OMXVCM4P2MBInfoPtr *pMBInter, 
			 const OMXVCM4P2MBInfoPtr *pMBIntra,
			 OMXVCM4P2MBInfoPtr pSrcDstMBCurr,
			 OMX_INT *pDstSAD)
{
 
    OMX_INT intraSAD, average, count, index, x, y;
    OMXVCMotionVector dstMV16x16;
    OMX_INT           dstSAD16x16;
    OMX_INT           dstSAD8x8;
    OMXVCM4P2MEParams  *pMEParams; 
	OMXVCM4P2Coordinate TempCurrPointPos; 
    OMXVCM4P2Coordinate *pTempCurrPointPos; 
    OMX_U8 aTempSrcCurrBuf[271];
    OMX_U8 *pTempSrcCurrBuf;
    OMXVCMotionVector* pSrcCandMV1[4];
    OMXVCMotionVector* pSrcCandMV2[4];
    OMXVCMotionVector* pSrcCandMV3[4];
        
    /* Argument error checks */
    armRetArgErrIf(!armIs16ByteAligned(pSrcCurrBuf), OMX_StsBadArgErr);
	armRetArgErrIf(!armIs16ByteAligned(pSrcRefBuf), OMX_StsBadArgErr);
    armRetArgErrIf(((srcCurrStep % 16) || (srcRefStep % 16)), OMX_StsBadArgErr);
	armRetArgErrIf(pSrcRefBuf == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pRefRect == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pSrcCurrBuf == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pCurrPointPos == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pDstSAD == NULL, OMX_StsBadArgErr);
    armIgnore(pMBIntra);
    
    pTempCurrPointPos = &(TempCurrPointPos);
    pTempSrcCurrBuf = armAlignTo16Bytes(aTempSrcCurrBuf);
    pMEParams = (OMXVCM4P2MEParams *)pMESpec;
    pTempCurrPointPos->x = pCurrPointPos->x;
    pTempCurrPointPos->y = pCurrPointPos->y;
    pSrcDstMBCurr->mbType = OMX_VC_INTER;
    
    
    
    /* Preparing a linear buffer for block match */
    for (y = 0, index = count = 0; y < 16; y++, index += srcCurrStep - 16)
    {
        for(x = 0; x < 16; x++, count++, index++)
        {
            pTempSrcCurrBuf[count] = pSrcCurrBuf[index];
        }
    }
    for(y = 0, index = 0; y < 2; y++)
    {
        for(x = 0; x < 2; x++,index++)
        {
            if(pMBInter[0] != NULL)
            {
               pSrcCandMV1[index] = &(pMBInter[0]->pMV0[y][x]); 
            }
            else
            {
               pSrcCandMV1[index] = NULL;
            }
            if(pMBInter[1] != NULL)
            {
               pSrcCandMV2[index] = &(pMBInter[1]->pMV0[y][x]);
            }
            else
            {
               pSrcCandMV2[index] = NULL; 
            }
            if(pMBInter[3] != NULL)
            {
               pSrcCandMV3[index] = &(pMBInter[3]->pMV0[y][x]);
            }
            else
            {
               pSrcCandMV3[index] = NULL; 
            }
        }
    }
	/* Calculating SAD at MV(0,0) */
	armVCCOMM_SAD(pTempSrcCurrBuf,
					  16,
					  pSrcRefBuf,
					  srcRefStep,
					  pDstSAD,
					  16,
					  16);
    /* Mode decision for NOT_CODED MB */
	if(*pDstSAD == 0)
	{
        pSrcDstMBCurr->pMV0[0][0].dx = 0;
        pSrcDstMBCurr->pMV0[0][0].dy = 0;
        *pDstSAD   = 0;
		return OMX_StsNoErr;
	}

    omxVCM4P2_FindMVpred(
                    &(pSrcDstMBCurr->pMV0[0][0]),
                    pSrcCandMV1[0],
                    pSrcCandMV2[0],
                    pSrcCandMV3[0],
                    &(pSrcDstMBCurr->pMVPred[0][0]),
                    NULL,
                    0);
                    
    /* Inter 1 MV */
    armVCM4P2_BlockMatch_16x16(
        pSrcRefBuf,
        srcRefStep,
        pRefRect,
        pTempSrcCurrBuf,
        pCurrPointPos,
        &(pSrcDstMBCurr->pMVPred[0][0]),
        NULL,
        pMEParams,
        &dstMV16x16,
        &dstSAD16x16);
    
    /* Initialize all with 1 MV values */
    pSrcDstMBCurr->pMV0[0][0].dx = dstMV16x16.dx;
    pSrcDstMBCurr->pMV0[0][0].dy = dstMV16x16.dy;
    pSrcDstMBCurr->pMV0[0][1].dx = dstMV16x16.dx;
    pSrcDstMBCurr->pMV0[0][1].dy = dstMV16x16.dy;
    pSrcDstMBCurr->pMV0[1][0].dx = dstMV16x16.dx;
    pSrcDstMBCurr->pMV0[1][0].dy = dstMV16x16.dy;
    pSrcDstMBCurr->pMV0[1][1].dx = dstMV16x16.dx;
    pSrcDstMBCurr->pMV0[1][1].dy = dstMV16x16.dy; 
    
    *pDstSAD   = dstSAD16x16;       
    
    if (pMEParams->searchEnable8x8)
    {
        /* Inter 4MV */
        armVCM4P2_BlockMatch_8x8 (pSrcRefBuf,
                                      srcRefStep, pRefRect,
                                      pTempSrcCurrBuf, pTempCurrPointPos,
                                      &(pSrcDstMBCurr->pMVPred[0][0]), NULL,
                                      pMEParams, &(pSrcDstMBCurr->pMV0[0][0]),
                                      &dstSAD8x8
                                      );
        *pDstSAD = dstSAD8x8;
        pTempCurrPointPos->x += 8;
        pSrcRefBuf += 8;
         omxVCM4P2_FindMVpred(
                    &(pSrcDstMBCurr->pMV0[0][1]),
                    pSrcCandMV1[1],
                    pSrcCandMV2[1],
                    pSrcCandMV3[1],
                    &(pSrcDstMBCurr->pMVPred[0][1]),
                    NULL,
                    1);
        
        armVCM4P2_BlockMatch_8x8 (pSrcRefBuf,
                                      srcRefStep, pRefRect,
                                      pTempSrcCurrBuf, pTempCurrPointPos,
                                      &(pSrcDstMBCurr->pMVPred[0][1]), NULL,
                                      pMEParams, &(pSrcDstMBCurr->pMV0[0][1]),
                                      &dstSAD8x8
                                      );
        *pDstSAD += dstSAD8x8;
        pTempCurrPointPos->x -= 8;
        pTempCurrPointPos->y += 8;
        pSrcRefBuf += (srcRefStep * 8) - 8;
        
        omxVCM4P2_FindMVpred(
                    &(pSrcDstMBCurr->pMV0[1][0]),
                    pSrcCandMV1[2],
                    pSrcCandMV2[2],
                    pSrcCandMV3[2],
                    &(pSrcDstMBCurr->pMVPred[1][0]),
                    NULL,
                    2);
        armVCM4P2_BlockMatch_8x8 (pSrcRefBuf,
                                      srcRefStep, pRefRect,
                                      pTempSrcCurrBuf, pTempCurrPointPos,
                                      &(pSrcDstMBCurr->pMVPred[1][0]), NULL,
                                      pMEParams, &(pSrcDstMBCurr->pMV0[1][0]),
                                      &dstSAD8x8
                                      );
        *pDstSAD += dstSAD8x8;
        pTempCurrPointPos->x += 8;
        pSrcRefBuf += 8;
         omxVCM4P2_FindMVpred(
                    &(pSrcDstMBCurr->pMV0[1][1]),
                    pSrcCandMV1[3],
                    pSrcCandMV2[3],
                    pSrcCandMV3[3],
                    &(pSrcDstMBCurr->pMVPred[1][1]),
                    NULL,
                    3);
        armVCM4P2_BlockMatch_8x8 (pSrcRefBuf,
                                      srcRefStep, pRefRect,
                                      pTempSrcCurrBuf, pTempCurrPointPos,
                                      &(pSrcDstMBCurr->pMVPred[1][1]), NULL,
                                      pMEParams, &(pSrcDstMBCurr->pMV0[1][1]),
                                      &dstSAD8x8
                                      );
        *pDstSAD += dstSAD8x8;   
        
        
        /* Checking if 4MV is equal to 1MV */
        if (
            (pSrcDstMBCurr->pMV0[0][0].dx != dstMV16x16.dx) ||
            (pSrcDstMBCurr->pMV0[0][0].dy != dstMV16x16.dy) ||
            (pSrcDstMBCurr->pMV0[0][1].dx != dstMV16x16.dx) ||
            (pSrcDstMBCurr->pMV0[0][1].dy != dstMV16x16.dy) ||
            (pSrcDstMBCurr->pMV0[1][0].dx != dstMV16x16.dx) ||
            (pSrcDstMBCurr->pMV0[1][0].dy != dstMV16x16.dy) ||
            (pSrcDstMBCurr->pMV0[1][1].dx != dstMV16x16.dx) ||
            (pSrcDstMBCurr->pMV0[1][1].dy != dstMV16x16.dy)
           )
        {
            /* select the 4 MV */
            pSrcDstMBCurr->mbType = OMX_VC_INTER4V;
        }                                      
    }
                                         
    /* finiding the error in intra mode */
    for (count = 0, average = 0; count < 256 ; count++)
    {
        average = average + pTempSrcCurrBuf[count];
    }
    average = average/256;
    
    /* Intra SAD calculation */
    for (count = 0; count < 256 ; count++)
    {
        intraSAD = armAbs (pTempSrcCurrBuf[count] - average);
    }
    
	/* Using the MPEG4 VM formula for intra/inter mode decision 
	   Var < (SAD - 2*NB) where NB = N^2 is the number of pixels
	   of the macroblock.*/

    if (intraSAD <= (*pDstSAD - 512))
    {
        pSrcDstMBCurr->mbType = OMX_VC_INTRA;
        pSrcDstMBCurr->pMV0[0][0].dx = 0;
        pSrcDstMBCurr->pMV0[0][0].dy = 0;
        *pDstSAD   = intraSAD;
    }  
    
    return OMX_StsNoErr;
}

/* End of file */

