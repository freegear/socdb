/**
 *  omxVCM4P2_FindMVpred.c
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
 * Contains module for predicting MV of MB
 *
 */
  
#include "omxVC.h"
#include "armCOMM.h"

/**
 * Function: omxVCM4P2_FindMVpred
 *
 * Description:
 *
 * Predicts a motion vector for the current block using the procedure specified in
 * ISO/IEC 14496-3 subclause 7.6.5.  The resulting predicted MV is returned in pDstMVPred.
 * If the parameter pDstMVPredME if is not NULL then the set of three MV candidates used
 * for prediction is also returned, otherwise pDstMVPredME is NULL upon return.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcMVCurMB		pointer to the MV buffer associated with the current Y macroblock
 * [in]	pSrcCandMV1		pointer to the MV buffer containing the 4 MVs associated with the MB
 *                    located to the left of the current MB; set to NULL if there is no MB
 *                    to the left.
 * [in]	pSrcCandMV2		pointer to the MV buffer containing the 4 MVs associated with the MB
 *                    located above the current MB; set to NULL if there is no MB located
 *                    above the current MB.
 * [in]	pSrcCandMV3		pointer to the MV buffer containing the 4 MVs associated with the MB
 *                    located to the right and above the current MB; set to NULL if there
 *                    is no MB located to the above-right.
 * [in]	iBlk			    the index of block in current macroblock
 * [out]	pDstMVPred		pointer to the predicted motion vector
 * [in/out]	pDstMVPredME	[in] MV candidate return buffer;  if set to NULL then prediction candidate
 *                             MVs are not returned and pDstMVPredME will beNULL upon function return;
 *                             if pDstMVPredME is non-NULL then it must point to a buffer containing
 *                             sufficient space for three return MVs.
 *                        [out]non-NULL upon input then pDstMVPredME  points upon return to a buffer
 *                             containing the three motion vector candidates used for prediction as
 *                             specified in ISO/IEC 14496-2, subclause 7.6.5, otherwise if NULL upon
 *                             input then pDstMVPredME is NULL upon output.
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments;
 *              returned under any of the following conditions:
 *              -- the pointer pDstMVPred is NULL
 *              -- the parameter iBlk does not fall into the range 0 <= iBlk <=3
 *
 */

OMXResult omxVCM4P2_FindMVpred(
     const OMXVCMotionVector* pSrcMVCurMB,
     const OMXVCMotionVector* pSrcCandMV1,
     const OMXVCMotionVector* pSrcCandMV2,
     const OMXVCMotionVector* pSrcCandMV3,
     OMXVCMotionVector* pDstMVPred,
     OMXVCMotionVector* pDstMVPredME,
     OMX_INT iBlk
 )
{
    OMXVCMotionVector CandMV;
	const OMXVCMotionVector *pCandMV1;
    const OMXVCMotionVector *pCandMV2;
    const OMXVCMotionVector *pCandMV3;
    
    /* Argument error checks */
    armRetArgErrIf(pSrcMVCurMB == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pDstMVPred == NULL, OMX_StsBadArgErr);
    armRetArgErrIf((iBlk < 0) || (iBlk > 3), OMX_StsBadArgErr); 

    CandMV.dx = CandMV.dy = 0;
	/* Based on the position of the block extract the motion vectors and
       the tranperancy status */
   
    
    /* Set the default value for these to be used if pSrcCandMV[1|2|3] == NULL */
    pCandMV1 = pCandMV2 = pCandMV3 = &CandMV;

    
    switch (iBlk)
    {
        case 0:
        {
            if(pSrcCandMV1 != NULL)
            {
			    pCandMV1 = &pSrcCandMV1[1];
			}
			if(pSrcCandMV2 != NULL)
            {
				pCandMV2 = &pSrcCandMV2[2];
			}
			if(pSrcCandMV3 != NULL)
            {
				pCandMV3 = &pSrcCandMV3[2];
			}
            break;
        }
        case 1:
        {
            pCandMV1 = &pSrcMVCurMB[0];
			if(pSrcCandMV2 != NULL)
            {
				pCandMV2 = &pSrcCandMV2[3];
			}
			if(pSrcCandMV3 != NULL)
            {
				pCandMV3 = &pSrcCandMV3[2];
			}
            break;
        }
        case 2:
        {
            if(pSrcCandMV1 != NULL)
            {
				pCandMV1 = &pSrcCandMV1[3];
			}
			pCandMV2 = &pSrcMVCurMB[0];
			pCandMV3 = &pSrcMVCurMB[1];
			break;
        }
        case 3:
        {
            pCandMV1 = &pSrcMVCurMB[2];
			pCandMV2 = &pSrcMVCurMB[0];
			pCandMV3 = &pSrcMVCurMB[1];
			break;
        }
    }

    /* Using the transperancy info, zero out the candidate MV
       if neccesary */
    
    if ((pSrcCandMV1 == NULL) && (pSrcCandMV2 == NULL))
    {
        pCandMV1 = pCandMV2 = pCandMV3;
    }
    else if((pSrcCandMV1 == NULL) && (pSrcCandMV3 == NULL))
    {
        pCandMV1 = pCandMV3 = pCandMV2;
    }
    else if((pSrcCandMV2 == NULL) && (pSrcCandMV3 == NULL))
    {
        pCandMV2 = pCandMV3 = pCandMV1;
    }
        
    /* Find the median of the 3 candidate MV's */
    pDstMVPred->dx = armMedianOf3 (pCandMV1->dx, pCandMV2->dx, pCandMV3->dx);
    pDstMVPred->dy = armMedianOf3 (pCandMV1->dy, pCandMV2->dy, pCandMV3->dy);
        
    if (pDstMVPredME != NULL)
    {
        /* Store the candidate MV's into the pDstMVPredME, these can be used
           in the fast algorithm if implemented */
        pDstMVPredME[0].dx = pCandMV1->dx;
        pDstMVPredME[0].dy = pCandMV1->dy;
        pDstMVPredME[1].dx = pCandMV2->dx;
        pDstMVPredME[1].dy = pCandMV2->dy;
        pDstMVPredME[2].dx = pCandMV3->dx;
        pDstMVPredME[2].dy = pCandMV3->dy;
    }

    return OMX_StsNoErr;
}


/* End of file */

