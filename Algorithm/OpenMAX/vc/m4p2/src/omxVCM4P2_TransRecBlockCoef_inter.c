/**
 *  omxVCM4P2_TransRecBlockCoef_inter.c
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
 * Contains modules DCT->quant and reconstructing the inter texture data
 * 
 */ 

#include "omxVC.h"
#include "armCOMM.h"


/**
 * Function: omxVCM4P2_TransRecBlockCoef_inter
 *
 * Description:
 * Implements DCT, and quantizes the DCT coefficients of the inter block while
 * reconstructing the texture residual. There is no boundary check for the bit
 * stream buffer.
 *
 * Remarks:
 *
 *
 * Parameters:
 * [in]	pSrc		pointer to the residuals to be encoded; must be aligned on a 16-byte boundary.
 * [in]	QP			quantization parameter.
 * [in] shortVideoHeader    a flag indicating presence of short_video_header;
 *                           shortVideoHeader==1 indicates using quantization method defined in short
 *                           video header mode, and shortVideoHeader==0 indicates normal quantization method.
 * [out]	pDst		pointer to the quantized DCT coefficients buffer. Must be 16-byte aligned.
 * [out]	pRec		pointer to the reconstructed texture residuals. Must be 16-byte aligned.
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *   -At least one of the following pointers is NULL or is not 64-bit aligned: pSrc, pDst, pRec.
 *   -QP <= 0 or QP >= 32.
 *
 */

OMXResult omxVCM4P2_TransRecBlockCoef_inter(
     OMX_S16 *pSrc,
     OMX_S16 * pDst,
     OMX_S16 * pRec,
     OMX_U8 QP,
     OMX_INT shortVideoHeader
)
{
    /* 64 elements are needed but to align it to 16 bytes need 
    8 more elements of padding */
    OMX_S16 tempBuffer[72];
    OMX_S16 *pTempBuffer;
    OMX_INT i;
        
    /* Aligning the local buffers */
    pTempBuffer = armAlignTo16Bytes(tempBuffer);

    /* Argument error checks */
    armRetArgErrIf(pSrc == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pRec == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(!armIs16ByteAligned(pSrc), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs16ByteAligned(pRec), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs16ByteAligned(pDst), OMX_StsBadArgErr);
    armRetArgErrIf(((QP <= 0) || (QP >= 32)), OMX_StsBadArgErr);
    omxVCM4P2_DCT8x8blk (pSrc, pDst);
    omxVCM4P2_QuantInter_I(
     pDst,
     QP,
     shortVideoHeader);

    for (i = 0; i < 64; i++)
    {
        pTempBuffer[i] = pDst[i];
    }

    omxVCM4P2_QuantInvInter_I(
     pTempBuffer,
     QP,
     shortVideoHeader);
    omxVCM4P2_IDCT8x8blk (pTempBuffer, pRec);

    return OMX_StsNoErr;
}

/* End of file */


