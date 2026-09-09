/**
 *  omxVCM4P10_Average_4x.c
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
 * This function will calculate Average of two 4x4 or 4x8 blocks
 * 
 */

#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"
#include "armVC.h"

/**
 * Function: omxVCM4P10_Average_4x
 *
 * Description:
 * This function calculates the average of two 4x4 or 4x8 blocks and stores the result.
 * The average is computed as (a+b+1)/2
 *
 * Remarks:
 *
 *	[in]	pPred0			Pointer to the top-left corner of reference block 0
 *	[in]	pPred1			Pointer to the top-left corner of reference block 1
 *	[in]	iPredStep0	Step of reference block 0. Must be multiple of 4.
 *	[in]	iPredStep1	Step of reference block 1. Must be multiple of 4.
 *	[in]	iDstStep 		Step of the destination buffer. Must be multiple of 4.
 *	[in]	iHeight			Height of the blocks, must be either 4 or 8.
 *	[out]	pDstPred		Pointer to the destination buffer. Must be 4-byte aligned
 *
 * Return Value:
 * OMX_StsNoErr -no error
 * OMX_StsBadArgErr -bad arguments
 *    -At least one of the following pointers is NULL: pPred0, pPred1, pDstPred.
 *    -pDstPred is not 4 byte aligned.
 *    -iPredStep0 <= 0 or iPredStep0 is not a multiple of 4.
 *    -iPredStep1 <= 0 or iPredStep1 is not a multiple of 4.
 *    -iDstStep <= 0 or iDstStep is not a multiple of 4.
 *    -iHeight is not 4 or 8
 *
 */
 OMXResult omxVCM4P10_Average_4x (
	 const OMX_U8* 	    pPred0,
	 const OMX_U8* 	    pPred1,	
	 OMX_U32		iPredStep0,
	 OMX_U32		iPredStep1,
	 OMX_U8*		pDstPred,
	 OMX_U32		iDstStep, 
	 OMX_U32		iHeight
)
{
    /* check for argument error */
    armRetArgErrIf(pPred0 == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pPred1 == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstPred == NULL, OMX_StsBadArgErr)
    armRetArgErrIf((iHeight != 4) && (iHeight != 8), OMX_StsBadArgErr)
    armRetArgErrIf((iPredStep0 == 0) || (iPredStep0 & 3), OMX_StsBadArgErr)
    armRetArgErrIf((iPredStep1 == 0) || (iPredStep1 & 3), OMX_StsBadArgErr)
    armRetArgErrIf((iDstStep == 0) || (iDstStep & 3), OMX_StsBadArgErr)
    armRetArgErrIf(armNot4ByteAligned(pDstPred), OMX_StsBadArgErr)

    return armVCCOMM_Average 
        (pPred0, pPred1, iPredStep0, iPredStep1, pDstPred, iDstStep, 4, iHeight);
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

