/**
 *  omxVCCOMM_SAD_8x.c
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
 * This function will calculate SAD for 8x16, 8x8, 8x4 blocks
 * 
 */

#include "omxtypes.h"
#include "omxVC.h"
#include "armVC.h"
#include "armCOMM.h"

/**
 * Function: omxVCCOMM_SAD_8x
 *
 * Description:
 * This function calculate the SAD for 8x16, 8x8, 8x4 blocks.
 *
 * Remarks:
 *
 * [in]		pSrcOrg		Pointer to the original block. Must be 8-byte aligned
 * [in]		iStepOrg	Step of the original block buffer. Must be multiple of 8.
 * [in]		pSrcRef		Pointer to the reference block
 * [in]		iStepRef	Step of the reference block buffer. Must be multiple of 8.
 * [in]		iHeight		Height of the block
 * [out]	pDstSAD		Pointer of result SAD
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - At least one of the following pointers is NULL: pSrcOrg, pSrcRef, pDstSAD.
 *    - pSrcOrg is not 8 byte aligned.
 *    - iStepOrg <= 0 or iStepOrg is not a multiple of 8.
 *    - iStepRef <= 0 or iStepRef is not a multiple of 8.
 *    - iHeight is not 4, 8 or 16
 *
 */
OMXResult omxVCCOMM_SAD_8x(	
	const OMX_U8* 	pSrcOrg,
	OMX_U32 	iStepOrg,
	const OMX_U8* 	pSrcRef,
	OMX_U32 	iStepRef,
	OMX_S32*	pDstSAD,
	OMX_U32		iHeight
)
{
    /* check for argument error */
    armRetArgErrIf(pSrcOrg == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pSrcRef == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstSAD == NULL, OMX_StsBadArgErr)
    armRetArgErrIf((iHeight != 16) && (iHeight != 8) && (iHeight != 4), OMX_StsBadArgErr)
    armRetArgErrIf(armNot8ByteAligned(pSrcOrg), OMX_StsBadArgErr)
    armRetArgErrIf((iStepOrg == 0) || (iStepOrg & 7), OMX_StsBadArgErr)
    armRetArgErrIf((iStepRef == 0) || (iStepRef & 7), OMX_StsBadArgErr)

    return armVCCOMM_SAD 
        (pSrcOrg, iStepOrg, pSrcRef, iStepRef, pDstSAD, iHeight, 8);
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

