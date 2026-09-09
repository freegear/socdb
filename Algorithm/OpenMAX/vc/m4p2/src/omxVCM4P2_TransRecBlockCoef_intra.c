/**
 *  omxVCM4P2_TransRecBlockCoef_intra.c
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
 * Contains modules DCT->quant and reconstructing the intra texture data
 * 
 */ 
 
#include "omxVC.h"
#include "armCOMM.h"
#include "armVC.h"


/**
 * Function: omxVCM4P2_TransRecBlockCoef_intra
 *
 * Description:
 * Quantizes the DCT coefficients, implements intra block AC/DC coefficient prediction,
 * and reconstructs the current intra block texture for prediction on the next frame.
 * Quantized row and column coefficients are returned in the updated coefficient buffers.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrc		pointer to the pixels of current intra block. Must be 8-byte aligned.
 * [in]	pPredBufRow	pointer to the coefficient row buffer containing ((num_mb_per_row * 2 + 1) * 8)
 *                  elements of type OMX_S16.  Coefficients are organized into blocks of eight as
 *                  described below (Internal Prediction Coefficient Update Procedures).  The DC
 *                  coefficient is first, and the remaining buffer locations contain the quantized
 *                  AC coefficients. Each group of eight row buffer elements combined with eight
 *                  elements ahead contains the coefficient predictors of the neighboring block that
 *                  is spatially above or to the left of the block currently to be decoded.
 *                  A negative-valued DC coefficient indicates that this neighboring block is not
 *                  INTRA coded or out of bounds, and therefore the AC and DC coefficients are invalid.
 * [in]	pPredBufCol	pointer to the prediction coefficient column buffer containing 16 elements of type
 *                  OMX_S16.  Coefficients are organized as described below (Internal and External
 *                  Prediction Coefficient Update Procedures).
 * [in]	pSumErr		  flag indicating whether or not AC/DC prediction is required; a negative value
 *                  disables prediction.
 * [in]	blockIndex	block index indicating the component type and position as defined in subclause
 *                  6.1.3.8, of ISO/IEC 14496-2. 
 * [in]	curQp		 quantization parameter of the macroblock which the current block belongs
 * [in]	pQpBuf		 Pointer to a 2-element QP array. pQpBuf[0] holds the QP of the 8x8 block left to
 *                   the current block(QPa). pQpBuf[1] holds the QP of the 8x8 block just above the
 *                   current block(QPc).
 *                   Note, in case the corresponding block is out of VOP bound, the QP value will have
 *                   no effect to the intra-prediction process. Refer to subclause  "7.4.3.3 Adaptive
 *                   ac coefficient prediction" of ISO/IEC 14496-2(MPEG4 Part2) for accurate description.
 * [in]	srcStep		  width of the source buffer. Must be multiple of 8.
 * [in]	dstStep		  width of the reconstructed destination buffer. Must be multiple of 8.
 * [in] shortVideoHeader    a flag indicating presence of short_video_header;
 *                           shortVideoHeader==1 selects linear intra DC mode,
 *							and shortVideoHeader==0 selects nonlinear intra DC mode.
 * [out]	pDst			pointer to the quantized DCT coefficient buffer; pDst[0] contains the predicted DC
 *                          coefficient; the remaining entries contain the quantized AC coefficients (without prediction). The
 *                          pointer pDst must be aligned on a 16-byte boundary.
 * [out]	pRec			pointer to the reconstructed texture. Must be 8-byte aligned.
 * [out]	pPredBufRow		pointer to the updated coefficient row buffer
 * [out]	pPredBufCol		pointer to the updated coefficient column buffer
 * [out]	pPreACPredict	if prediction is enabled, the parameter points to the start of the buffer containing
 *                          the coefficient differences for VLC encoding. The entry pPreACPredict[0]indicates prediction
 *                          direction for the current block and takes one of the following values: OMX_VC_NONE (prediction
 *                          disabled), OMX_VC_HORIZONTAL, or OMX_VC_VERTICAL. The entries
 *                          pPreACPredict[1]- pPreACPredict[7]contain predicted AC coefficients. If prediction is
 *                          disabled (*pSumErr<0) then the contents of this buffer are undefined upon return from the function
 * [out]	pSumErr			pointer to the updated sum of the absolute differences between predicted and
 *                    unpredicted coefficients
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - Bad arguments
 *   -	At least one of the following pointers is NULL: pSrc, pDst, pRec, pCoefBufRow, pCoefBufCol,
 *                                                      pQpBuf, pPreACPredict, pSumErr.
 *   -	BlockIndex < 0 or blockIndex >= 10; curQP <= 0 or curQP >= 32.
 *   -	SrcStep, dstStep <= 0 or not a multiple of 8.
 *   -	At least one of the following pointers is not 64-bit aligned: pSrc, pDst, pRec.
 *
 */

OMXResult omxVCM4P2_TransRecBlockCoef_intra(
     const OMX_U8 *pSrc,
     OMX_S16 * pDst,
     OMX_U8 * pRec,
     OMX_S16 *pPredBufRow,
     OMX_S16 *pPredBufCol,
     OMX_S16 * pPreACPredict,
     OMX_INT *pSumErr,
     OMX_INT blockIndex,
     OMX_U8 curQp,
     const OMX_U8 *pQpBuf,
     OMX_INT srcStep,
     OMX_INT dstStep,
	 OMX_INT shortVideoHeader
)
{
    /* 64 elements are needed but to align it to 16 bytes need
    8 more elements of padding */
    OMX_S16 tempBuf1[79], tempBuf2[79];
    OMX_S16 tempBuf3[79];
    OMX_S16 *pTempBuf1, *pTempBuf2,*pTempBuf3;
    OMXVCM4P2VideoComponent videoComp;
    OMX_U8  flag;
    OMX_INT x, y, count, predDir;
    OMX_INT predQP, ACPredFlag;
    

    /* Aligning the local buffers */
    pTempBuf1 = armAlignTo16Bytes(tempBuf1);
    pTempBuf2 = armAlignTo16Bytes(tempBuf2);
    pTempBuf3 = armAlignTo16Bytes(tempBuf3);

    /* Argument error checks */
    armRetArgErrIf(pSrc == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pRec == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pSrc), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pRec), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pDst), OMX_StsBadArgErr);
    armRetArgErrIf(pPredBufRow == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pPredBufCol == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pPreACPredict == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pSumErr == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pQpBuf == NULL, OMX_StsBadArgErr);
    armRetArgErrIf((srcStep <= 0) || (dstStep <= 0) ||
                (dstStep & 7) || (srcStep & 7)
                , OMX_StsBadArgErr);
    armRetArgErrIf((blockIndex < 0) || (blockIndex > 9), OMX_StsBadArgErr);

   /* Setting the videoComp */
    if (blockIndex <= 3)
    {
        videoComp = OMX_VC_LUMINANCE;
    }
    else
    {
        videoComp = OMX_VC_CHROMINANCE;
    }
    /* Converting from 2-d to 1-d buffer */
    for (y = 0, count = 0; y < 8; y++)
    {
        for(x= 0; x < 8; x++, count++)
        {
            pTempBuf1[count] = pSrc[(y*srcStep) + x];
        }
    }

    omxVCM4P2_DCT8x8blk  (pTempBuf1, pTempBuf2);
    omxVCM4P2_QuantIntra_I(
        pTempBuf2,
        curQp,
        blockIndex,
        shortVideoHeader);

    /* Converting from 1-D to 2-D buffer */
    for (y = 0, count = 0; y < 8; y++)
    {
        for(x = 0; x < 8; x++, count++)
        {
            /* storing tempbuf2 to tempbuf1 */
            pTempBuf1[count] = pTempBuf2[count];
            pDst[(y*dstStep) + x] = pTempBuf2[count];
        }
    }

    /* AC and DC prediction */
    armVCM4P2_SetPredDir(
        blockIndex,
        pPredBufRow,
        pPredBufCol,
        &predDir,
        &predQP,
        pQpBuf);

    armRetDataErrIf(((predQP <= 0) || (predQP >= 32)), OMX_StsBadArgErr);

    flag = 1;
    if (*pSumErr < 0)
    {
        ACPredFlag = 0;
    }
    else
    {
        ACPredFlag = 1;
    }

    armVCM4P2_ACDCPredict(
        pTempBuf2,
        pPreACPredict,
        pPredBufRow,
        pPredBufCol,
        curQp,
        predQP,
        predDir,
        ACPredFlag,
        videoComp,
        flag,
        pSumErr);

    /* Reconstructing the texture data */
    omxVCM4P2_QuantInvIntra_I(
        pTempBuf1,
        curQp,
        videoComp,
        shortVideoHeader);
    omxVCM4P2_IDCT8x8blk (pTempBuf1, pTempBuf3);
    for(count = 0; count < 64; count++)
    {
        pRec[count] = armMax(0,pTempBuf3[count]);
    }

    return OMX_StsNoErr;
}

/* End of file */


