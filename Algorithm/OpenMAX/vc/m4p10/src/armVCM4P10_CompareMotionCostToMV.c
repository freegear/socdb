/**
 *  armVCM4P10_CompareMotionCostToMV.c
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
 * Contains module for comparing motion vectors and SAD's to decide 
 * the best MV and SAD
 *
 */
  
#include "omxtypes.h"
#include "armVC.h"
#include "armCOMM.h"

/**
 * Function: armVCM4P10_ExpGolBitsUsed
 *
 * Description:
 * Performs calculating Exp-Golomb code length for a given values
 *
 * Remarks:
 *
 * Parameters:
 * [in]	         val	Signed number for which Exp-Golomb code length has
 *                      to be calculated
 *
 * Return Value: 
 *             Returns the length of the Exp-Golomb code for val
 */

static OMX_U16 armVCM4P10_ExpGolBitsUsed (OMX_S16 val)
{
    OMX_U16 sizeCodeNum, codeNum;
    
    /* Mapping val to codeNum */
    codeNum = armAbs (val);
    if (val > 0)
    {
        codeNum = (2 * codeNum) - 1;
    }
    else
    {
        codeNum = 2 * codeNum;
    }
    
    /* Size of the exp-golomb code */
    sizeCodeNum = (2 * armLogSize (codeNum + 1)) - 1;
    
    return sizeCodeNum;
}
                

/**
 * Function: armVCM4P10_CompareMotionCostToMV
 *
 * Description:
 * Performs comparision of motion vectors and Motion cost to decide the 
 * best MV and best MC
 *
 * Remarks:
 *
 * Parameters:
 * [in]	         mvX	x coordinate of the candidate motion vector in 1/4 pel units
 * [in]	         mvY	y coordinate of the candidate motion vector in 1/4 pel units
 * [in]	      diffMV	differential MV
 * [in]	     candSAD	Candidate SAD
 * [in]	      bestMV	Best MV, contains best MV till the previous interation.
 * [in]       nLamda    Lamda factor; used to compute motion cost 
 * [in]   *pBestCost    Contains the current best motion cost.
 * [out]  *pBestCost    pBestCost Motion cost will be associated with the best MV 
 *                      after judgement; 
 *                      computed as SAD+Lamda*BitsUsedByMV, if the candCost is less 
 *                      than the best cost passed then the *pBestCost will be equal to candCost
 * [out]	  bestMV	Finally will have the best MV after the judgement.
 *
 * Return Value:
 * OMX_INT -- 1 to indicate that the current motion cost is the best 
 *            0 to indicate that it is NOT the best motion cost
 */

OMX_INT armVCM4P10_CompareMotionCostToMV (
    OMX_S16  mvX,
    OMX_S16  mvY,
    OMXVCMotionVector diffMV, 
    OMX_INT candSAD, 
    OMXVCMotionVector *bestMV, 
    OMX_U32 nLamda,
    OMX_S32 *pBestCost
) 
{
    OMX_S32 candCost;
    OMX_U16 sizeCodeNum;
    
    sizeCodeNum = armVCM4P10_ExpGolBitsUsed (diffMV.dx);
    sizeCodeNum += armVCM4P10_ExpGolBitsUsed (diffMV.dy);
    
    /* Motion cost = SAD +  lamda * ((bitsused(diffMVx) + (bitsused(diffMVy))*/
    candCost = candSAD + (nLamda * sizeCodeNum);
        
    /* Calculate candCost */
    if (candCost < *pBestCost)
    {
        *pBestCost = candCost;
        bestMV->dx = mvX;
        bestMV->dy = mvY;
        return 1;
    }
    if (candCost > *pBestCost)
    {
        return 0;
    }
    /* shorter motion vector */
    if ( (mvX * mvX + mvY * mvY) < ((bestMV->dx * bestMV->dx) + (bestMV->dy * bestMV->dy)) )
    {
        *pBestCost = candCost;
        bestMV->dx = mvX;
        bestMV->dy = mvY;
        return 1;
    }
    
    return 0;
}

/*End of File*/
