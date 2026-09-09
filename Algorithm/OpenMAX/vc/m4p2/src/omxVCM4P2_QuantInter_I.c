/**
 *  omxVCM4P2_QuantInter_I.c
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
 * Contains modules for inter Quantization
 * 
 */
 
#include "omxVC.h"
#include "armCOMM.h"

/**
 * Function: omxVCM4P2_QuantInter_I
 *
 * Description:
 * Performs quantization on an inter block coefficients. This function supports
 * bits_per_pixel == 8.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcDst		pointer to the input inter block coefficients. Must be 16-byte aligned.
 * [in]	QP			quantization parameter (quantizer_scale)
 * [in] shortVideoHeader    a flag indicating presence of short_video_header;
 *                           shortVideoHeader==1 selects linear intra DC mode,
 *							and shortVideoHeader==0 selects nonlinear intra DC mode.
 * [out]	pSrcDst		pointer to the output (quantized) inter block
 *							coefficients. When shortVideoHeader==1, AC coefficients are saturated on the interval [-127, 127], and DC
 *                          coefficients are saturated on the interval [1, 254]. When shortVideoHeader==0, AC coefficients
 *                          are saturated on the interval [-2047, 2047].
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - pSrcDst is NULL or is not 16-byte aligned.
 *    - QP <= 0 or QP >= 32.
 *
 */

OMXResult omxVCM4P2_QuantInter_I(
     OMX_S16 * pSrcDst,
     OMX_U8 QP,
	 OMX_INT shortVideoHeader
)
{

    /* Definitions and Initializations*/
    OMX_INT coeffCount;
    OMX_INT fSign;
    OMX_INT maxClpAC = 0, minClpAC = 0;
    OMX_INT maxClpDC = 0, minClpDC = 0;
    
    /* Argument error checks */
    armRetArgErrIf(pSrcDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(((QP <= 0) || (QP >= 32)), OMX_StsBadArgErr);
   /* One argument check is delayed until we have ascertained that  */
   /* pQMatrix is not NULL.                                         */
                
    /* Set the Clip Range based on SVH on/off */
    if(shortVideoHeader == 1)
    {
       maxClpDC = 254;
       minClpDC = 1;
       maxClpAC = 127;
       minClpAC = -127;        
    }
    else
    {
        maxClpDC = 2047;
        minClpDC = -2047;
        maxClpAC = 2047;
        minClpAC = -2047;   
    }
                
    /* Second Inverse quantisation method */
    for (coeffCount = 0; coeffCount < 64; coeffCount++)
    {
        fSign =  armSignCheck (pSrcDst[coeffCount]);  
        pSrcDst[coeffCount] = (armAbs(pSrcDst[coeffCount]) 
                              - (QP/2))/(2 * QP);
        pSrcDst[coeffCount] *= fSign;
        
        /* Clip */
        if (coeffCount == 0)
        {
           pSrcDst[coeffCount] =
           (OMX_S16) armClip (minClpDC, maxClpDC, pSrcDst[coeffCount]);
        }
        else
        {
           pSrcDst[coeffCount] =
           (OMX_S16) armClip (minClpAC, maxClpAC, pSrcDst[coeffCount]);
        }
    }
    return OMX_StsNoErr;

}

/* End of file */


