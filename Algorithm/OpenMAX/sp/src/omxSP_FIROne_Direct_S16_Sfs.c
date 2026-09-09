/**
 *  omxSP_FIROne_Direct_S16_Sfs.c
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

#define ARM_SP_Q_OFFSET     (15)

/**
 * Function: omxSP_FIROne_Direct_S16_Sfs
 *
 * Description:
 * Single-sample FIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the FIR filter defined by the coefficient vector
 * pTapsQ15 to a single sample of input data.
 *
 * Parameters:
 * [in]  val        the single input sample to which the filter is
 *              applied.
 * [in]  pTapsQ15       pointer to the vector that contains the filter
 *              coefficients, represented in Q0.15 format.
 *              Given that -32768<=pTapsQ15(k)<32768,
 *              0<=k<tapsLen, the range on the actual filter
 *              coefficients is: -1<=bk<1, and therefore
 *              coefficient normalization may be required during
 *              the filter design process.
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
 * [in]  scalefactor    saturation fixed scalefactor.
 * [out] pResult        pointer to the filtered output sample
 *
 * Return Value:
 * Standard omxError result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FIROne_Direct_S16_Sfs(
     OMX_S16 val,
     OMX_S16 * pResult,
     const OMX_S16 * pTapsQ15,
     OMX_INT tapsLen,
     OMX_S16 * pDelayLine,
     OMX_INT * pDelayLineIndex,
     OMX_INT scaleFactor
 )
{
    OMX_U32 index;
    OMX_S32 accum;
    OMX_S16 *pDelayCurrent;
    int     TempSF;

    /* Input parameter check */ 
	armRetArgErrIf((pResult == NULL), OMX_StsBadArgErr)
	armRetArgErrIf((pTapsQ15 == NULL), OMX_StsBadArgErr)
	armRetArgErrIf((tapsLen < 0), OMX_StsBadArgErr)
	armRetArgErrIf((pDelayLine == NULL), OMX_StsBadArgErr)
	armRetArgErrIf((pDelayLineIndex == NULL), OMX_StsBadArgErr)
	armRetArgErrIf((*pDelayLineIndex < 0), OMX_StsBadArgErr)
	armRetArgErrIf((*pDelayLineIndex >= (2 * tapsLen)), OMX_StsBadArgErr)
    
	/* Update the delay state */
	pDelayCurrent = (pDelayLine + *pDelayLineIndex);
	
	/* Save the input at both location in pMemory */
	*pDelayCurrent = *(pDelayCurrent + tapsLen) = val;
	
	/* calculate sigma for output */
	accum = 0;
	for (index = 0; index < tapsLen ; index++)
	{
        accum = armSatMac_S32(accum, pTapsQ15 [index], pDelayCurrent [index]);
	}
	
	if (--(*pDelayLineIndex) < 0)
	{
		*pDelayLineIndex = tapsLen - 1;     
	}
	
    /* adjust the Q format here */
    TempSF = (ARM_SP_Q_OFFSET + scaleFactor);
    
    /* 32 bit saturated left shift */
    accum = armSatRoundLeftShift_S32(accum, -TempSF);

    *pResult = (OMX_S16) accum; 
    
    /* 16 bit saturation */
    if (*pResult != accum)
    {
        *pResult = (accum < 0) ? OMX_MIN_S16 : OMX_MAX_S16;
    }

    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

