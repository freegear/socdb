/**
 *  omxVCM4P2_DecodeBlockCoef_Intra.c
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
 * Contains modules for intra reconstruction
 * 
 */

#include "omxVC.h"
#include "armCOMM.h"
#include "armVC.h"

/**
 * Function: omxVCM4P2_DecodeBlockCoef_Intra
 *
 * Description:
 * Decodes the INTRA block coefficients. Inverse quantization, inversely zigzag
 * positioning, and IDCT, with appropriate clipping on each step, are performed
 * on the coefficients. The results are then placed in the output frame/plane on
 * a pixel basis. For INTRA block, the output values are clipped to [0, 255] and
 * written to corresponding block buffer within the destination plane.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppBitStream		pointer to the pointer to the current byte in
 *								the bit stream buffer. There is no boundary
 *								check for the bit stream buffer.
 * [in]	pBitOffset		pointer to the bit position in the byte pointed
 *								to by *ppBitStream. *pBitOffset is valid within
 *								[0-7].
 * [in]	step			width of the destination plane
 * [in/out]	pCoefBufRow		[in]  pointer to the coefficient row buffer
 *                        [out] updated coefficient rwo buffer
 * [in/out]	pCoefBufCol		[in]  pointer to the coefficient column buffer
 *                        [out] updated coefficient column buffer
 * [in]	curQP			quantization parameter of the macroblock which
 *								the current block belongs to
 * [in]	pQpBuf		 Pointer to a 2-element QP array. pQpBuf[0] holds the QP of the 8x8 block left to
 *                   the current block(QPa). pQpBuf[1] holds the QP of the 8x8 block just above the
 *                   current block(QPc).
 *                   Note, in case the corresponding block is out of VOP bound, the QP value will have
 *                   no effect to the intra-prediction process. Refer to subclause  "7.4.3.3 Adaptive
 *                   ac coefficient prediction" of ISO/IEC 14496-2(MPEG4 Part2) for accurate description.
 * [in]	blockIndex		block index indicating the component type and
 *								position as defined in subclause 6.1.3.8,
 *								Figure 6-5 of ISO/IEC 14496-2. 
 * [in]	intraDCVLC		a code determined by intra_dc_vlc_thr and QP.
 *								This allows a mechanism to switch between two VLC
 *								for coding of Intra DC coefficients as per Table
 *								6-21 of ISO/IEC 14496-2. 
 * [in]	ACPredFlag		a flag equal to ac_pred_flag (of luminance) indicating
 *								if the ac coefficients of the first row or first
 *								column are differentially coded for intra coded
 *								macroblock.
 * [in] shortVideoHeader    a flag indicating presence of short_video_header;
 *                           shortVideoHeader==1 selects linear intra DC mode,
 *							and shortVideoHeader==0 selects nonlinear intra DC mode.
 * [out]	ppBitStream		*ppBitStream is updated after the block is
 *								decoded, so that it points to the current byte
 *								in the bit stream buffer
 * [out]	pBitOffset		*pBitOffset is updated so that it points to the
 *								current bit position in the byte pointed by
 *								*ppBitStream
 * [out]	pDst			pointer to the block in the destination plane.
 *								pDst should be 16-byte aligned.
 * [out]	pCoefBufRow		pointer to the updated coefficient row buffer.
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *   -	At least one of the following pointers is NULL: ppBitStream, *ppBitStream, pBitOffset,
 *                                                      pCoefBufRow, pCoefBufCol, pQPBuf, pDst.
 *      or
 *   -  At least one of the below case: *pBitOffset exceeds [0,7], curQP exceeds (1, 31),
 *      blockIndex exceeds [0,9], step is not the multiple of 8, intraDCVLC is zero while
 *      blockIndex greater than 5.
 *      or
 *   -	pDst is not 16-byte aligned
 * OMX_StsErr - status error
 *
 */

OMXResult omxVCM4P2_DecodeBlockCoef_Intra(
     const OMX_U8 ** ppBitStream,
     OMX_INT *pBitOffset,
     OMX_U8 *pDst,
     OMX_INT step,
     OMX_S16 *pCoefBufRow,
     OMX_S16 *pCoefBufCol,
     OMX_U8 curQP,
     const OMX_U8 *pQPBuf,
     OMX_INT blockIndex,
     OMX_INT intraDCVLC,
     OMX_INT ACPredFlag,
	 OMX_INT shortVideoHeader
 )
{
    OMX_S16 tempBuf1[79], tempBuf2[79];
    OMX_S16 *pTempBuf1, *pTempBuf2;
    OMX_INT predDir, predACDir, i, j, count;
    OMX_INT  predQP;
    OMXVCM4P2VideoComponent videoComp;
    OMXResult errorCode;
    
    /* Argument error checks */
    armRetArgErrIf(ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(*ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pBitOffset == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pCoefBufRow == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pCoefBufCol == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pQPBuf == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pDst), OMX_StsBadArgErr);
    armRetArgErrIf(((curQP <= 0) || (curQP >= 32)), OMX_StsBadArgErr);
    armRetArgErrIf((*pBitOffset < 0) || (*pBitOffset >7), OMX_StsBadArgErr);
    armRetArgErrIf((blockIndex < 0) || (blockIndex > 9), OMX_StsBadArgErr);
    armRetArgErrIf((step % 8) != 0, OMX_StsBadArgErr);
    armRetArgErrIf((blockIndex > 5) && (intraDCVLC == 0), OMX_StsBadArgErr);

    /* Aligning the local buffers */
    pTempBuf1 = armAlignTo16Bytes(tempBuf1);
    pTempBuf2 = armAlignTo16Bytes(tempBuf2);
    
    /* Setting the AC prediction direction and prediction direction */
    armVCM4P2_SetPredDir(
        blockIndex,
        pCoefBufRow,
        pCoefBufCol,
        &predDir,
        &predQP,
        pQPBuf);

    predACDir = predDir;

    armRetArgErrIf(((predQP <= 0) || (predQP >= 32)), OMX_StsBadArgErr);

    if (ACPredFlag == 0)
    {
        predACDir = OMX_VC_NONE;
    }

    /* Setting the videoComp */
    if (blockIndex <= 3)
    {
        videoComp = OMX_VC_LUMINANCE;
    }
    else
    {
        videoComp = OMX_VC_CHROMINANCE;
    }
    

    /* VLD and zigzag */
    if (intraDCVLC == 1)
    {
        errorCode = omxVCM4P2_DecodeVLCZigzag_IntraDCVLC(
            ppBitStream,
            pBitOffset,
            pTempBuf1,
            predACDir,
            shortVideoHeader,
            videoComp);
        armRetDataErrIf((errorCode != OMX_StsNoErr), errorCode);
    }
    else
    {
        errorCode = omxVCM4P2_DecodeVLCZigzag_IntraACVLC(
            ppBitStream,
            pBitOffset,
            pTempBuf1,
            predACDir,
            shortVideoHeader);
        armRetDataErrIf((errorCode != OMX_StsNoErr), errorCode);
    }

    /* AC DC prediction */
    errorCode = omxVCM4P2_PredictReconCoefIntra(
        pTempBuf1,
        pCoefBufRow,
        pCoefBufCol,
        curQP,
        predQP,
        predDir,
        ACPredFlag,
        videoComp);
    armRetDataErrIf((errorCode != OMX_StsNoErr), errorCode);
    
    /* Dequantization */
    errorCode = omxVCM4P2_QuantInvIntra_I(
     pTempBuf1,
     curQP,
     videoComp,
     shortVideoHeader);
    armRetDataErrIf((errorCode != OMX_StsNoErr), errorCode);
    
    /* Inverse transform */
    errorCode = omxVCM4P2_IDCT8x8blk (pTempBuf1, pTempBuf2);
    armRetDataErrIf((errorCode != OMX_StsNoErr), errorCode);
    
    /* Placing the linear array into the destination plane and clipping
       it to 0 to 255 */
    for (j = 0, count = 0; j < 8; j++)
    {
        for(i = 0; i < 8; i++, count++)
        {
            pDst[i] = armClip (0, 255, pTempBuf2[count]);
        }
        pDst += step;
    }

    return OMX_StsNoErr;
}

/* End of file */


