/**
 *  omxVCM4P10_SADQuar_4x.c
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
 * of 4x8 or 4x4 blocks
 * 
 */

#include "omxtypes.h"
#include "omxVC.h"
#include "armVC.h"
#include "armCOMM.h"

/**
 * Function: omxVCM4P10_SADQuar_4x
 *
 * Description:
 * This function calculates the SAD between one block (pSrc) and the
 * average of the other two (pSrcRef0 and pSrcRef1) for 4x8 or 4x4 blocks
 * Rounding is applied according to the convention (a+b+1)>>1.
 *
 * Remarks:
 *
 * [in]		pSrc			Pointer to the original block. Must be 4-byte aligned
 * [in]		pSrcRef0		Pointer to reference block 0
 * [in]		pSrcRef1		Pointer to reference block 1
 * [in]		iSrcStep 		Step of the original block buffer. Must be multiple of 4.
 * [in]		iRefStep0		Step of reference block 0. Must be multiple of 4.
 * [in]		iRefStep1 	Step of reference block 1. Must be multiple of 4.
 * [in]		iHeight			Height of the block;must be equal to either 4 or 8.
 * [out]	pDstSAD			Pointer of result SAD
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - At least one of the following pointers is NULL: pSrcOrg, pSrcRef0, pSrcRef1, pDstSAD.
 *    - pSrcOrg is not 4 byte aligned.
 *    - iStepOrg <= 0 or iStepOrg is not a multiple of 4.
 *    - iStepRef0 <= 0 or iStepRef0 is not a multiple of 4.
 *    - iStepRef1 <= 0 or iStepRef1 is not a multiple of 4.
 *    - iHeight is not 4, 8
 *
 */
OMXResult omxVCM4P10_SADQuar_4x( 
	  const OMX_U8* 	pSrc,
      const OMX_U8* 	pSrcRef0,
	  const OMX_U8* 	pSrcRef1,	
      OMX_U32 	iSrcStep,
      OMX_U32	iRefStep0,
      OMX_U32	iRefStep1,
      OMX_U32*	pDstSAD,
      OMX_U32   iHeight
)
{
    /* check for argument error */
    armRetArgErrIf(pSrc == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pSrcRef0 == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pSrcRef1 == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstSAD == NULL, OMX_StsBadArgErr)
    armRetArgErrIf((iHeight != 8) && (iHeight != 4), OMX_StsBadArgErr)
    armRetArgErrIf(armNot4ByteAligned(pSrc), OMX_StsBadArgErr)
    armRetArgErrIf((iSrcStep == 0) || (iSrcStep & 3), OMX_StsBadArgErr)
    armRetArgErrIf((iRefStep0 == 0) || (iRefStep0 & 3), OMX_StsBadArgErr)
    armRetArgErrIf((iRefStep1 == 0) || (iRefStep1 & 3), OMX_StsBadArgErr)

    return armVCM4P10_SADQuar
        (pSrc, pSrcRef0, pSrcRef1, iSrcStep, 
        iRefStep0, iRefStep1, pDstSAD, iHeight, 4);
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

