/**
 *  omxVCCOMM_ComputeTextureErrorBlock.c
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
 * Contains module computing the error for a MB of size 8x8
 * 
 */

#include "omxVC.h"
#include "armCOMM.h"

/**
 * Function: omxVCCOMM_ComputeTextureErrorBlock
 *
 * Description:
 * Computes the texture error of the block.
 *
 * Remarks:
 * 
 * Parameters:
 * [in]	pSrc		pointer to the source plane. This should be aligned
 *							on an 8-byte boundary.
 * [in]	srcStep		step of the source plane
 * [in]	pSrcRef		pointer to the reference buffer, an 8x8 block. This
 *							should be aligned on an 8-byte boundary.
 * [out]	pDst		pointer to the destination buffer, an 8x8 block.
 *							This should be aligned on an 8-byte boundary.
 * Return Value:
 * OMX_StsNoErr ¨C no error
 * OMX_StsBadArgErr ¨C bad arguments
 *   ¡ª	At least one of the following pointers is NULL: pSrc, pSrcRef, pDst.
 *   ¡ª	pSrc is not 8 byte aligned.
 *   ¡ª	SrcStep <= 0 or srcStep is not a multiple of 8.
 *   ¡ª	pSrcRef is not 8 byte aligned.
 *   ¡ª	pDst is not 8 byte aligned
 *
 */

OMXResult omxVCCOMM_ComputeTextureErrorBlock(
     const OMX_U8 *pSrc,
     OMX_INT srcStep,
     const OMX_U8 *pSrcRef,
     OMX_S16 * pDst
)
{

    OMX_INT     x, y, count;

    /* Argument error checks */
    armRetArgErrIf(pSrc == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pSrcRef == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pSrc), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pSrcRef), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pDst), OMX_StsBadArgErr);

    /* Calculate the error block */
    for (y = 0, count = 0;
         y < 8;
         y++, pSrc += srcStep)
    {
        for (x = 0; x < 8; x++, count++)
        {
            pDst[count] = pSrc[x] - pSrcRef[count];
        }
    }

    return OMX_StsNoErr;

}

/* End of file */
