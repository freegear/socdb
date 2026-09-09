/**
 *  omxSP_IIROne_Direct_S16.c
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
 * This file contains module for single sample IIR filtering
 *
 */

#include "omxtypes.h"
#include "omxSP.h"

#include "armCOMM.h"
#include "armSP.h"

/**
 * Function: omxSP_IIROne_Direct_S16
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
 * [in]  val       	the single input sample to which the filter is
 * 				applied.
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
 * [out] pResult		pointer to the filtered output sample.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_IIROne_Direct_S16 (
     OMX_S16 val,
     OMX_S16 * pResult,
     const OMX_S16 * pTaps,
     OMX_INT order,
     OMX_S32 * pDelayLine
 )
{
    const OMX_S16 *pTapsAk;
    const OMX_S16 *pTapsBm;
    OMX_S32       macAk,macBm,temp;
    OMX_INT       scaleFactor,tapNum;
    
    /* Argument Check */
    armRetArgErrIf( pResult    == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pDelayLine == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pTaps      == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( order      <  0   , OMX_StsBadArgErr);
    armRetArgErrIf( pTaps[order + 2]  <  0 , OMX_StsBadArgErr);

    /* Processing */
    order       = order + 1;
    scaleFactor = pTaps[order + 1];
    pTapsAk     = pTaps + order + 1;
    pTapsBm     = pTaps;


    macAk    = 0;
    macBm    = 0;
    pDelayLine--;
    
    for(tapNum = order; tapNum != 0; tapNum--)
    {
        macAk = armSatMac_S16S32_S32(macAk, pDelayLine[tapNum], pTapsAk[tapNum]);
        macBm = armSatMac_S16S32_S32(macBm, pDelayLine[tapNum], pTapsBm[tapNum]);
        
        /*shifting the delay line*/
        if(tapNum != 1)
        {
            pDelayLine[tapNum] = pDelayLine[tapNum - 1];
        }
    }
    
    temp  = armSatRoundLeftShift_S32(val, scaleFactor);
    macAk = armSatSub_S32( temp , macAk);
    
    macAk = armSatRoundLeftShift_S32(macAk,-scaleFactor);
    macBm = armSatMac_S16S32_S32(macBm,macAk,pTapsBm[0]);
    
    pDelayLine[1] = macAk;
    *pResult      = armSatRoundRightShift_S32_S16(macBm, scaleFactor);

    return OMX_StsNoErr;
}

/*End of File*/

