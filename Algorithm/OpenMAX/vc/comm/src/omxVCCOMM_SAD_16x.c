/**
 *  omxVCCOMM_SAD_16x.c
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
 * This function will calculate SAD for 16x16 and 16x8 blocks
 * 
 */

#include "omxtypes.h"
#include "omxVC.h"
#include "armVC.h"
#include "armCOMM.h"

/**
 * Function: omxVCCOMM_SAD_16x
 *
 * Description:
 * This function calculate the SAD for 16x16 and 16x8 blocks.
 *
 * Remarks:
 *
 * [in]		pSrcOrg		Pointer to the original block. Must be 16-byte aligned
 * [in]		iStepOrg	Step of the original block buffer. Must be multiple of 16.
 * [in]		pSrcRef		Pointer to the reference block
 * [in]		iStepRef	Step of the reference block buffer. Must be multiple of 16.
 * [in]		iHeight		Height of the block
 * [out]	pDstSAD		Pointer of result SAD
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - At least one of the following pointers is NULL: pSrcOrg, pSrcRef, pDstSAD.
 *    - pSrcOrg is not 16 byte aligned.
 *    - iStepOrg <= 0 or iStepOrg is not a multiple of 16.
 *    - iStepRef <= 0 or iStepRef is not a multiple of 16.
 *    - iHeight is not 8 or 16
 *
 */
OMXResult omxVCCOMM_SAD_16x(
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
    armRetArgErrIf((iHeight != 16) && (iHeight != 8), OMX_StsBadArgErr)
    armRetArgErrIf(armNot16ByteAligned(pSrcOrg), OMX_StsBadArgErr)
    armRetArgErrIf((iStepOrg == 0) || (iStepOrg & 15), OMX_StsBadArgErr)
    armRetArgErrIf((iStepRef == 0) || (iStepRef & 15), OMX_StsBadArgErr)

    return armVCCOMM_SAD 
        (pSrcOrg, iStepOrg, pSrcRef, iStepRef, pDstSAD, iHeight, 16);
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

