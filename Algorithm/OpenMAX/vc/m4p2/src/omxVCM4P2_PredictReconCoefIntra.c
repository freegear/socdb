 /**
 *  omxVCM4P2_PredictReconCoefIntra.c
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
 * File:        omxVCM4P2_PredictReconCoefIntra_S16.c
 * Description: Contains modules for AC DC prediction
 *
 */

#include "omxVC.h"
#include "armCOMM.h"
#include "armVC.h"

/**
 * Function: omxVCM4P2_PredictReconCoefIntra
 *
 * Description:
 * Performs adaptive DC/AC coefficient prediction for an intra block. Prior
 * to the function call, prediction direction (predDir) should be selected
 * as specified in subclause 7.4.3.1 of ISO/IEC 14496-2.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcDst		pointer to the coefficient buffer which contains the 
 *                  quantized coefficient residuals (PQF) of the current 
 *                  block; must be aligned on a 4-byte boundary. The 
 *                  output coefficients are saturated to the range 
 *                  [-2048, 2047].
 * [in]	pPredBufRow	pointer to the coefficient row buffer; must be aligned
 *                  on a 4-byte boundary.
 * [in]	pPredBufCol	pointer to the coefficient column buffer; must be 
 *                  aligned on a 4-byte boundary.
 * [in]	curQP	    quantization parameter of the current block. curQP may 
 *                  equal to predQP especially when the current block and 
 *                  the predictor block are in the same macroblock.
 * [in]	predQP		quantization parameter of the predictor block
 * [in]	predDir		indicates the prediction direction which takes one
 *							of the following values:
 *							OMX_VIDEO_HORIZONTAL	predict horizontally
 *							OMX_VIDEO_VERTICAL		predict vertically
 * [in]	ACPredFlag	a flag indicating if AC prediction should be
 *							performed. It is equal to ac_pred_flag in the bit
 *							stream syntax of MPEG-4
 * [in]	videoComp	video component type (luminance, chrominance or
 *							alpha) of the current block
 * [out]	pSrcDst		pointer to the coefficient buffer which contains
 *							the quantized coefficients (QF) of the current
 *							block
 * [out]	pPredBufRow	pointer to the updated coefficient row buffer
 * [out]	pPredBufCol	pointer to the updated coefficient column buffer
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - Bad arguments 
 * - At least one of the pointers is NULL: pSrcDst, pPredBufRow, or pPredBufCol.
 * - At least one the following cases: curQP <= 0, predQP <= 0, curQP >31, 
 *   predQP > 31, preDir exceeds [1,2].
 * - At least one of the pointers pSrcDst, pPredBufRow, or pPredBufCol is not 
 *   4-byte aligned.
 *
 */

OMXResult omxVCM4P2_PredictReconCoefIntra(
     OMX_S16 * pSrcDst,
     OMX_S16 * pPredBufRow,
     OMX_S16 * pPredBufCol,
     OMX_INT curQP,
     OMX_INT predQP,
     OMX_U8  predDir,
     OMX_INT ACPredFlag,
     OMXVCM4P2VideoComponent videoComp
 )
{
    OMX_U8 flag;
    /* Argument error checks */
    armRetArgErrIf(pSrcDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pPredBufRow == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pPredBufCol == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(curQP <= 0, OMX_StsBadArgErr);
    armRetArgErrIf(predQP <= 0, OMX_StsBadArgErr);
    armRetArgErrIf(curQP > 31, OMX_StsBadArgErr);
    armRetArgErrIf(predQP > 31, OMX_StsBadArgErr);
    armRetArgErrIf((predDir != 1) && (predDir != 2), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs4ByteAligned(pSrcDst), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs4ByteAligned(pPredBufRow), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs4ByteAligned(pPredBufCol), OMX_StsBadArgErr);

    flag = 0;
    return armVCM4P2_ACDCPredict(
        pSrcDst,
        NULL,
        pPredBufRow,
        pPredBufCol,
        curQP,
        predQP,
        predDir,
        ACPredFlag,
        videoComp,
        flag,
        NULL);

}

/* End of file */


