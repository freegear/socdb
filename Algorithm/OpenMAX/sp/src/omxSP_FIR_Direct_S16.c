/**
 *  omxSP_FIR_Direct_S16.c
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
 *
 */

#include "omxtypes.h"
#include "omxSP.h"
#include "armCOMM.h"

extern 



/** FIR single rate */
/**
 * Function: omxSP_FIR_Direct_S16
 *
 * Description:
 * Block FIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the FIR filter defined by the coefficient vector
 * pTapsQ15 to a vector of input data.
 *
 * Parameters:
 * [in]  pSrc           pointer to the vector of input samples to which
 *              the filter is applied.
 * [in]  sampLen        the number of samples contained in both the
 *              input and output vectors.
 * [in]  pTapsQ15       pointer to the vector that contains the filter
 *              coefficients, represented in Q0.15 format.
 *              Given that -32768<=pTapsQ15(k)<32768,
 *              0<=k<tapsLen, the range on the actual filter
 *              coefficients is: -1<=bk<1, and therefore
 *              coefficient normalization may be required
 *              during the filter design process.
 * [in]  tapsLen        the number of taps, e.g. the filter order + 1
 * [in]  pDelayLine       pointer to the 2*tapsLen-element filter memory
 *              buffer(state). The user is responsible for
 *              allocation, initialization, and de-allocation.
 *              The filter memory elements are initialized to
 *              zero in most applications.
 * [in]  pDelayLineIndex  pointer to the filter memory index that is
 *              maintained internally by the primitive. User
 *              should initialize the value of this index to
 *              zero.
 * [out] pDst       pointer to the vector of filtered output
 *              samples.
 *
 * Return Value:
 * Standard omxError result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FIR_Direct_S16(
     const OMX_S16 * pSrc,
     OMX_S16 * pDst,
     OMX_INT sampLen,
     const OMX_S16 * pTapsQ15,
     OMX_INT tapsLen,
     OMX_S16 * pDelayLine,
     OMX_INT * pDelayLineIndex
 )
 {
    OMX_U32     Count;
    OMXResult  Result = OMX_StsNoErr;
    
    /* Input parameter check */ 
	armRetArgErrIf((pSrc == NULL), OMX_StsBadArgErr)
	armRetArgErrIf((pDst == NULL), OMX_StsBadArgErr)
	armRetArgErrIf((sampLen <= 0), OMX_StsBadArgErr)
	armRetArgErrIf((pTapsQ15 == NULL), OMX_StsBadArgErr)
	armRetArgErrIf((tapsLen <= 0), OMX_StsBadArgErr)
	armRetArgErrIf((pDelayLine == NULL), OMX_StsBadArgErr)
	armRetArgErrIf((pDelayLineIndex == NULL), OMX_StsBadArgErr)
	armRetArgErrIf((*pDelayLineIndex < 0), OMX_StsBadArgErr)
	armRetArgErrIf((*pDelayLineIndex >= (2 * tapsLen)), OMX_StsBadArgErr)
    
    for (Count = 0; Count < sampLen; Count++) 
    {
        if ((Result = omxSP_FIROne_Direct_S16  (pSrc [Count], 
									&(pDst [Count]), 
									pTapsQ15, 
									tapsLen, 
									pDelayLine, 
									pDelayLineIndex)) != OMX_StsNoErr)
        {
            return Result;
        }
    }
    
    return OMX_StsNoErr;
 }

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

