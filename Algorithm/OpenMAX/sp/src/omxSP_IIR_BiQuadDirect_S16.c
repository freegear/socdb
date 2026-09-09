/**
 *  omxSP_IIR_BiQuadDirect_S16.c
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
 * This file contains module for block biquad IIR filtering
 *
 */
 
#include "omxtypes.h"
#include "omxSP.h"

#include "armCOMM.h"

/**
 * Function: omxSP_IIR_BiQuadDirect_S16
 *
 * Description:
 * Block biquad IIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the direct form II biquad IIR cascade defined by the
 * coefficient vector pTaps to a vector of input data.The output will saturate to 0x8000
 *(-32768) for a negative overflow or 0x7fff (32767) for a positive overflow.
 *
 * Parameters:
 * [in]  pSrc       	pointer to the vector of input samples to which
 *				the filter is applied.
 * [in]  len	     	the number of samples contained in both the
 *				input and output vectors.
 * [in]  pTaps      	pointer to the 6P element vector that contains
 * 				the combined numerator and denominator filter
 *				coefficients from the biquad cascade.
 *				Coefficient scaling and coefficient vector
 *				organization should follow the conventions
 *				described above. The value of the coefficient
 *				scalefactor exponent must be non-negative.
 *              (sfp >= 0)
 * [in]  numBiquad    	the number of biquads contained in the IIR
 *				filter cascade: (P).
 * [in]  pDelayLine       pointer to the 2P element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zero
 * [out] pDst		pointer to the filtered output samples.
 *
 * Return Value:
 * Standard omxError result. See enumeration for possible result codes.
 *
 */




OMXResult omxSP_IIR_BiQuadDirect_S16(
     const OMX_S16 * pSrc,
     OMX_S16 * pDst,
     OMX_INT len,
     const OMX_S16 * pTaps,
     OMX_INT numBiquad,
     OMX_S32 * pDelayLine
 )
{

    OMXResult errorCode = OMX_StsNoErr;

    /* Argument Check */
    armRetArgErrIf( pSrc       == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pDst       == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pDelayLine == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pTaps      == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( len       <= 0    , OMX_StsBadArgErr);
    armRetArgErrIf( numBiquad <= 0    , OMX_StsBadArgErr);
    

    /* Processing */
    while(len != 0)
    {
        errorCode = omxSP_IIROne_BiQuadDirect_S16(
                        *pSrc,
                        pDst,
                        pTaps,
                        numBiquad,
                        pDelayLine);

        armRetArgErrIf( errorCode != OMX_StsNoErr, errorCode);

        pSrc++;
        pDst++;
        
        len--;
        
    }/*end while(len != 0)*/

    return OMX_StsNoErr;

}

/* End of File */
