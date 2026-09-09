/**
 *  armVCCOMM_SAD.c
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
 * This function will calculate SAD for NxM blocks
 * 
 */

#include <stdio.h>
#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"

/**
 * Function: armVCCOMM_SAD
 *
 * Description:
 * This function calculate the SAD for NxM blocks.
 *
 * Remarks:
 *
 * [in]		pSrcOrg		Pointer to the original block
 * [in]		iStepOrg	Step of the original block buffer
 * [in]		pSrcRef		Pointer to the reference block
 * [in]		iStepRef	Step of the reference block buffer
 * [in]		iHeight		Height of the block
 * [in]		iWidth		Width of the block
 * [out]	pDstSAD		Pointer of result SAD
 *
 * Return Value:
 * Standard OMXResult value.
 *
 */
OMXResult armVCCOMM_SAD(	
	const OMX_U8* 	pSrcOrg,
	OMX_U32 	iStepOrg,
	const OMX_U8* 	pSrcRef,
	OMX_U32 	iStepRef,
	OMX_S32*	pDstSAD,
	OMX_U32		iHeight,
	OMX_U32		iWidth
)
{
    OMX_INT     x, y;
    
    /* check for argument error */
    armRetArgErrIf(pSrcOrg == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pSrcRef == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstSAD == NULL, OMX_StsBadArgErr)
    
    *pDstSAD = 0;
    for (y = 0; y < iHeight; y++)
    {
        for (x = 0; x < iWidth; x++)
        {
            *pDstSAD += armAbs(pSrcOrg [(y * iStepOrg) + x] - 
                       pSrcRef [(y * iStepRef) + x]);
        }
    }
    
    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

