/**
 *  armVCCOMM_Average.c
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
 * This function will calculate Average of two blocks if size iWidth X iHeight
 * 
 */

#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"
#include "armVC.h"

/**
 * Function: armVCCOMM_Average
 *
 * Description:
 * This function calculates the average of two blocks and stores the result.
 *
 * Remarks:
 *
 *	[in]	pPred0			Pointer to the top-left corner of reference block 0
 *	[in]	pPred1			Pointer to the top-left corner of reference block 1
 *	[in]	iPredStep0	    Step of reference block 0
 *	[in]	iPredStep1	    Step of reference block 1
 *	[in]	iDstStep 		Step of the destination buffer
 *	[in]	iWidth			Width of the blocks
 *	[in]	iHeight			Height of the blocks
 *	[out]	pDstPred		Pointer to the destination buffer
 *
 * Return Value:
 * Standard OMXResult value.
 *
 */
 OMXResult armVCCOMM_Average (
	 const OMX_U8* 	    pPred0,
	 const OMX_U8* 	    pPred1,	
	 OMX_U32		iPredStep0,
	 OMX_U32		iPredStep1,
	 OMX_U8*		pDstPred,
	 OMX_U32		iDstStep, 
	 OMX_U32		iWidth,
	 OMX_U32		iHeight
)
{
    OMX_U32     x, y;

    /* check for argument error */
    armRetArgErrIf(pPred0 == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pPred1 == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstPred == NULL, OMX_StsBadArgErr)

    for (y = 0; y < iHeight; y++)
    {
        for (x = 0; x < iWidth; x++)
        {
            pDstPred [y * iDstStep + x] = 
                (OMX_U8)(((OMX_U32)pPred0 [y * iPredStep0 + x] + 
                                  pPred1 [y * iPredStep1 + x] + 1) >> 1);
        }
    }

    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

