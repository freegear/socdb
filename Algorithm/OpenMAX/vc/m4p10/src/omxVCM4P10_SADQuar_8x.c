/**
 *  omxVCM4P10_SADQuar_8x.c
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
 * This function will calculate SAD of pSrc with average of two Ref blocks
 * of 8x16 or 8x8 or 8x4
 * 
 */

#include "omxtypes.h"
#include "omxVC.h"
#include "armVC.h"
#include "armCOMM.h"

/**
 * Function: omxVCM4P10_SADQuar_8x
 *
 * Description:
 * This function calculates the SAD between one block (pSrc) and the
 * average of the other two (pSrcRef0 and pSrcRef1) for 8x16 or 8x8
 * or 8x4 blocks. The average is computed as (a+b+1)/2.
 *
 * Remarks:
 *
 * [in]		pSrc				Pointer to the original block. Must be 8-byte aligned.
 * [in]		pSrcRef0		Pointer to reference block 0
 * [in]		pSrcRef1		Pointer to reference block 1
 * [in]		iSrcStep 		Step of the original block buffer. Must be multiple of 8.
 * [in]		iRefStep0		Step of reference block 0. Must be multiple of 8.
 * [in]		iRefStep1 	Step of reference block 1. Must be multiple of 8.
 * [in]		iHeight			Height of the block;must be equal to either 4, 8 or 16
 * [out]	pDstSAD			Pointer of result SAD
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - At least one of the following pointers is NULL: pSrcOrg, pSrcRef0, pSrcRef1, pDstSAD.
 *    - pSrcOrg is not 8 byte aligned.
 *    - iStepOrg <= 0 or iStepOrg is not a multiple of 8.
 *    - iStepRef0 <= 0 or iStepRef0 is not a multiple of 8.
 *    - iStepRef1 <= 0 or iStepRef1 is not a multiple of 8.
 *    - iHeight is not 4, 8 or 16
 *
 */
OMXResult omxVCM4P10_SADQuar_8x( 
	const OMX_U8* 	pSrc,
    const OMX_U8* 	pSrcRef0,
	const OMX_U8* 	pSrcRef1,	
    OMX_U32 	iSrcStep,
    OMX_U32		iRefStep0,
    OMX_U32		iRefStep1,
    OMX_U32*	pDstSAD,
    OMX_U32     iHeight
)
{
    /* check for argument error */
    armRetArgErrIf(pSrc == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pSrcRef0 == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pSrcRef1 == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstSAD == NULL, OMX_StsBadArgErr)
    armRetArgErrIf((iHeight != 16) && (iHeight != 8) && 
        (iHeight != 4), OMX_StsBadArgErr)
    armRetArgErrIf(armNot8ByteAligned(pSrc), OMX_StsBadArgErr)
    armRetArgErrIf((iSrcStep == 0) || (iSrcStep & 7), OMX_StsBadArgErr)
    armRetArgErrIf((iRefStep0 == 0) || (iRefStep0 & 7), OMX_StsBadArgErr)
    armRetArgErrIf((iRefStep1 == 0) || (iRefStep1 & 7), OMX_StsBadArgErr)

    return armVCM4P10_SADQuar
        (pSrc, pSrcRef0, pSrcRef1, iSrcStep, 
        iRefStep0, iRefStep1, pDstSAD, iHeight, 8);
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

