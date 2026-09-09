/**
 *  omxSP_IIROne_Direct_S16_I.c
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
 * This file contains module for single sample inplace IIR filtering
 *
 */

#include "omxtypes.h"
#include "omxSP.h"

#include "armCOMM.h"

/**
 * Function: omxSP_IIROne_Direct_S16_I
 *
 * Description:
 * Single sample IIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the direct form II IIR filter defined by the
 * coefficient vector pTaps to a single sample of input data. The output will saturate to 0x8000
 *(-32768) for a negative overflow or 0x7fff (32767) for a positive overflow.
 *
 * Parameters:
 * [in]  pValResult      	A pointer is used for the in-place version.
 * [in]  pTaps      	pointer to the 2L+2 element vector that
 *				contains the combined numerator and denominator
 *				filter coefficients from the system transfer
 *				function,H(z). Coefficient scaling and c
 *				oefficient vector organization should follow
 *				the conventions described above. The value of
 *				the coefficient scalefactor exponent must be
 *              non-negative(sf>=0).
 * [in]  order    	the maximum of the degrees of the numerator and
 *				denominator coefficient polynomials from the
 *				system transfer function,H(z), that is:
 *              order=max(K,M)-1=L-1.
 * [in]  pDelayLine       pointer to the L element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zero in most applications.
 * [out] pValResult	pointer to the filtered output sample.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */


OMXResult omxSP_IIROne_Direct_S16_I(
     OMX_S16 * pValResult,
     const OMX_S16 * pTaps,
     OMX_INT order,
     OMX_S32 * pDelayLine
 )
{
    OMXResult errorCode;
    
    armRetArgErrIf(pValResult == NULL, OMX_StsBadArgErr)
    
    errorCode = omxSP_IIROne_Direct_S16(
                        *pValResult,
                        pValResult,
                        pTaps,order,
                        pDelayLine);

    return errorCode;

}

/*End of File*/

