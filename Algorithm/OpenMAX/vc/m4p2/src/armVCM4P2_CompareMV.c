/**
 *  armVCM4P2_CompareMV.c
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
 * Function: armVCM4P2_CompareMV
 *
 * Description:
 * Performs comparision of motion vectors and SAD's to decide the 
 * best MV and SAD
 *
 * Remarks:
 *
 * Parameters:
 * [in]	    mvX		x coordinate of the candidate motion vector
 * [in]	    mvY		y coordinate of the candidate motion vector
 * [in]	    candSAD	Candidate SAD
 * [in]	    bestMVX	x coordinate of the best motion vector
 * [in]	    bestMVY	y coordinate of the best motion vector
 * [in]	    bestSAD	best SAD
 *
 * Return Value:
 * OMX_INT -- 1 to indicate that the current sad is the best 
 *            0 to indicate that it is NOT the best SAD
 */

OMX_INT armVCM4P2_CompareMV (
    OMX_S16 mvX, 
    OMX_S16 mvY, 
    OMX_INT candSAD, 
    OMX_S16 bestMVX, 
    OMX_S16 bestMVY, 
    OMX_INT bestSAD
) 
{
    if (candSAD < bestSAD)
    {
        return 1;
    }
    if (candSAD > bestSAD)
    {
        return 0;
    }
    /* shorter motion vector */
    if ( (mvX * mvX + mvY * mvY) < (bestMVX*bestMVX+bestMVY*bestMVY) )
    {
         return 1;
    }
    return 0;
}

/*End of File*/
