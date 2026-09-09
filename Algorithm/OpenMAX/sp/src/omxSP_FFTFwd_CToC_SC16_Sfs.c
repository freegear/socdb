/**
 *  omxSP_FFTFwd_CToC_SC16_Sfs.c
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
 * Compute a forward FFT for a complex signal
 */

#include "omxtypes.h"
#include "armCOMM.h"
#include "omxSP.h"
#include "armSP.h"

/**
 * Function: omxSP_FFTFwd_CToC_SC16_Sfs
 *
 * Description:
 * Compute a forward FFT for a complex signal of length of
 * 2^order, where 0 <= order <= 12.
 *
 * Remarks:
 * Transform length is determined by the specification structure, which must
 * be initialized prior to calling the FFT function using the appropriate
 * helper, i.e., <FFTInit_C_SC16>.
 *
 * Parameters:
 * [in]  pSrc       	pointer to the input signal, a complex-valued
 *				vector of length 2^order.
 * [in]  pFFTSpec     	pointer to the pre-allocated and initialized
 *				specification structure.
 * [in]  scaleFactor      output scale factor; the range for
 *				<ippsFFTFwd_CToC_SC16_Sfs> is [0,16].
 * [out] pDst		pointer to the complex-valued output vector, of
 *				length 2^order.
 *
 * Return Value:
 * Standard omxError result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTFwd_CToC_SC16_Sfs(
     const OMX_SC16 *pSrc,
     OMX_SC16 *pDst,
     const OMXFFTSpec_C_SC16 *pFFTSpec,
     OMX_INT scaleFactor
)
{
    OMX_INT     block, point;
    OMX_INT     i, j, N, NBy2;
    OMX_U16     *pRevIndex;
    OMX_FC64     *out;
    OMX_FC64    *pT1, *pT2, *pT, *pTw, T;
    ARMsFFTSpec_FC64 *pFFTStruct;

    /* Input parameter check */ 
    armRetArgErrIf(pSrc == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(armNot8ByteAligned(pSrc), OMX_StsBadArgErr)
    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(armNot8ByteAligned(pDst), OMX_StsBadArgErr)
    armRetArgErrIf(pFFTSpec == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(scaleFactor < 0, OMX_StsBadArgErr)
    armRetArgErrIf(scaleFactor > 16, OMX_StsBadArgErr)

    /* Order range check */ 
    pFFTStruct = (ARMsFFTSpec_FC64 *) pFFTSpec;    
    N = pFFTStruct->N;
    armRetArgErrIf(N < 1, OMX_StsBadArgErr)
    armRetArgErrIf(N > (1 << 12), OMX_StsBadArgErr)
    
    /* Handle order zero case separate */
    if (N == 1)
    {
        pDst [0].Re = armSatRoundRightShift_S32_S16 (pSrc[0].Re, scaleFactor);
        pDst [0].Im = armSatRoundRightShift_S32_S16 (pSrc[0].Im, scaleFactor);
        return OMX_StsNoErr;        
    }

    /* Do fft in float */
    out = pFFTStruct->pBuf;

    /* bit reversal */    
    pRevIndex = pFFTStruct->pBitRev;
    for (i = 0; i < N; i++)
    {
        out [pRevIndex [i]].Re = (OMX_F64) pSrc [i]. Re;
        out [pRevIndex [i]].Im = (OMX_F64) pSrc [i]. Im;
    }
    
    NBy2 = N >> 1;
    pT = &T;
    point = 2;
    for (block = NBy2; block > 0; block >>= 1)
    {
        pTw = pFFTStruct->pTwiddle;
        for (i = 0; i < point / 2; i++)
        {
            pT1 = out + i;
            pT2 = pT1 + (point / 2);
            for (j = 0; j < block; j++)
            {
                CPLX_MUL (pT, pTw, pT2);
                CPLX_SUB (pT2, pT1, pT);
                CPLX_ADD (pT1, pT1, pT);
                pT1 += point;
                pT2 += point;
            }
            pTw += block;
        }
        point <<= 1;
    }
    

    /* revert back from float */
    for (i = 0; i < N; i++)
    {
        out [i].Re /= (1 << scaleFactor);
        out [i].Im /= (1 << scaleFactor);
        pDst [i]. Re = armSatRoundFloatToS16 (out [i].Re);
        pDst [i]. Im = armSatRoundFloatToS16 (out [i].Im);
    }
    
    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

