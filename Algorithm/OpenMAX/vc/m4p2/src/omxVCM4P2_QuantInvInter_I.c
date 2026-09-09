/**
 *  omxVCM4P2_QuantInvInter_I.c
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
 * Contains modules for inter inverse Quantization
 * 
 */ 

#include "omxVC.h"
#include "armCOMM.h"


/**
 * Function: omxVCM4P2_QuantInvInter_I
 *
 * Description:
 * Performs inverse quantization on intra/inter coded block.
 * This function supports bits_per_pixel = 8. Mismatch control
 * is performed for the first MPEG-4 mode inverse quantization method.
 * The output coefficients are clipped to the range: [-2048, 2047].
 * Mismatch control is performed for the first inverse quantization method.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcDst		pointer to the input (quantized) intra/inter block. Must be 16-byte aligned.
 * [in]	QP			quantization parameter (quantiser_scale)
 * [in]	videoComp	(Intra version only.) Video component type of the
 *							current block. Takes one of the following flags:
 *							OMX_VC_LUMINANCE, OMX_VC_CHROMINANCE,
 *							OMX_VC_ALPHA.
 * [in] shortVideoHeader    a flag indicating presence of short_video_header;
 *                           shortVideoHeader==1 selects linear intra DC mode,
 *							and shortVideoHeader==0 selects nonlinear intra DC mode.
 * [out]	pSrcDst		pointer to the output (dequantized) intra/inter block.  Must be 16-byte aligned.
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    -	If pSrcDst is NULL or is not 16-byte aligned.
 *      or
 *    - If QP <= 0.
 *      or
 *    - videoComp is none of OMX_VC_LUMINANCE, OMX_VC_CHROMINANCE and OMX_VC_ALPHA.
 *
 */

OMXResult omxVCM4P2_QuantInvInter_I(
     OMX_S16 * pSrcDst,
     OMX_INT QP,
	 OMX_INT shortVideoHeader
)
{

    OMX_INT coeffCount, Sign;
    
    /* Argument error checks */
    armRetArgErrIf(pSrcDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(((QP <= 0) || (QP >= 32)), OMX_StsBadArgErr);

    /* Second Inverse quantisation method */
    for (coeffCount = 0; coeffCount < 64; coeffCount++)
    {
        /* check sign */
        Sign =  armSignCheck (pSrcDst[coeffCount]);
              
        /* Quantize the coeff */
        if (QP & 0x1)
        {
            pSrcDst[coeffCount] = (2* armAbs(pSrcDst[coeffCount]) + 1) * QP;
            pSrcDst[coeffCount] *= Sign;
        }
        else
        {
            pSrcDst[coeffCount] = (2* armAbs(pSrcDst[coeffCount]) + 1)
                                                                * QP - 1;
            pSrcDst[coeffCount] *= Sign;
        }
        /* Saturate */
        pSrcDst[coeffCount] = armClip (-2048, 2047, pSrcDst[coeffCount]);
    }
    return OMX_StsNoErr;
}

/* End of file */


