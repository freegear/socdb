/**
 *  armVCM4P10_SADQuar.c
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
 * 
 */

#include "omxtypes.h"
#include "armVC.h"
#include "armCOMM.h"

/**
 * Function: armVCM4P10_SADQuar
 *
 * Description:
 * This function calculates the SAD between one block (pSrc) and the 
 * average of the other two (pSrcRef0 and pSrcRef1)
 *
 * Remarks:
 *
 * [in]		pSrc				Pointer to the original block
 * [in]		pSrcRef0		Pointer to reference block 0
 * [in]		pSrcRef1		Pointer to reference block 1
 * [in]		iSrcStep 		Step of the original block buffer
 * [in]		iRefStep0		Step of reference block 0 
 * [in]		iRefStep1 	Step of reference block 1 
 * [in]		iHeight			Height of the block
 * [in]		iWidth			Width of the block
 * [out]	pDstSAD			Pointer of result SAD
 *
 * Return Value:
 * Standard OMXResult value.
 *
 */
OMXResult armVCM4P10_SADQuar(
	const OMX_U8* 	pSrc,
    const OMX_U8* 	pSrcRef0,
	const OMX_U8* 	pSrcRef1,	
    OMX_U32 	iSrcStep,
    OMX_U32		iRefStep0,
    OMX_U32		iRefStep1,
    OMX_U32*	pDstSAD,
    OMX_U32     iHeight,
    OMX_U32     iWidth
)
{
    OMX_INT     x, y;
    OMX_S32     SAD = 0;

    /* check for argument error */
    armRetArgErrIf(pSrc == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pSrcRef0 == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pSrcRef1 == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstSAD == NULL, OMX_StsBadArgErr)

    for (y = 0; y < iHeight; y++)
    {
        for (x = 0; x < iWidth; x++)
        {
            SAD += armAbs(pSrc [y * iSrcStep + x] - ((
                    pSrcRef0 [y * iRefStep0 + x] + 
                    pSrcRef1 [y * iRefStep1 + x] + 1) >> 1));
        }
    }
        
    *pDstSAD = SAD;

    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

