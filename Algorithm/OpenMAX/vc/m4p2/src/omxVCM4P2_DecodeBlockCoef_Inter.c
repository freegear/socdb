/**
 *  omxVCM4P2_DecodeBlockCoef_Inter.c
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
 * Contains modules for inter reconstruction
 * 
 */
 

#include "omxVC.h"
#include "armCOMM.h"


/**
 * Function: omxVCM4P2_DecodeBlockCoef_Inter
 *
 * Description:
 * Decodes the INTER block coefficients. Inverse quantization, inversely zigzag
 * positioning and IDCT, with appropriate clipping on each step, are performed
 * on the coefficients. The results (residuals) are placed in a contiguous array
 * of 64 elements. For INTER block, the output buffer holds the residuals for
 * further reconstruction.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppBitStream		pointer to the pointer to the current byte in
 *								the bit stream buffer. There is no boundary
 *								check for the bit stream buffer.
 * [in]	pBitOffset		pointer to the bit position in the byte pointed
 *								to by *ppBitStream. *pBitOffset is valid within
 *								[0-7]
 * [in]	QP				quantization parameter
 * [in] shortVideoHeader    a flag indicating presence of short_video_header;
 *                           shortVideoHeader==1 indicates using quantization method defined in short
 *                           video header mode, and shortVideoHeader==0 indicates normail quantization method.
 * [out] ppBitStream 	*ppBitStream is updated after the block is decoded, so that it points to the
 *                      current byte in the bit stream buffer.
 * [out] pBitOffset		*pBitOffset is updated so that it points to the current bit position in the
 *                      byte pointed by *ppBitStream
 * [out] pDst			pointer to the decoded residual buffer (a contiguous array of 64 elements of
 *                      OMX_S16 data type). Must be 16-byte aligned.
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *   - At least one of the following pointers is Null: ppBitStream, *ppBitStream, pBitOffset , pDst
 *   - At least one of the below case:
 *   - *pBitOffset exceeds [0,7], QP <= 0;
 *	 - pDst not 16-byte aligned
 * OMX_StsErr - status error
 *
 */
OMXResult omxVCM4P2_DecodeBlockCoef_Inter(
     const OMX_U8 ** ppBitStream,
     OMX_INT * pBitOffset,
     OMX_S16 * pDst,
     OMX_INT QP,
     OMX_INT shortVideoHeader
)
{
    /* 64 elements are needed but to align it to 16 bytes need
    15 more elements of padding */
    OMX_S16 tempBuf[79];
    OMX_S16 *pTempBuf1;
    OMXResult errorCode;
    /* Aligning the local buffers */
    pTempBuf1 = armAlignTo16Bytes(tempBuf);
    
    /* Argument error checks */
    armRetArgErrIf(ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(*ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pBitOffset == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(!armIs16ByteAligned(pDst), OMX_StsBadArgErr);
    armRetArgErrIf(((QP <= 0) || (QP >= 32)), OMX_StsBadArgErr);

    /* VLD and zigzag */
    errorCode = omxVCM4P2_DecodeVLCZigzag_Inter(ppBitStream, pBitOffset, 
                                        pTempBuf1,shortVideoHeader);
    armRetDataErrIf((errorCode != OMX_StsNoErr), errorCode);
    
    /* Dequantization */
    errorCode = omxVCM4P2_QuantInvInter_I(
     pTempBuf1,
     QP,
     shortVideoHeader);
    armRetDataErrIf((errorCode != OMX_StsNoErr), errorCode);
    
    /* Inverse transform */
    errorCode = omxVCM4P2_IDCT8x8blk(pTempBuf1, pDst);
    armRetDataErrIf((errorCode != OMX_StsNoErr), errorCode);
    
    return OMX_StsNoErr;
}

/* End of file */


