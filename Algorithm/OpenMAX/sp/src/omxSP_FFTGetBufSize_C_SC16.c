/**
 *  omxSP_FFTGetBufSize_C_SC16.c
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
 * Compute the size of the specification structure required
 */

#include "omxtypes.h"
#include "omxSP.h"
#include "armCOMM.h"
#include "armSP.h"


/**
 * Function: omxSP_FFTGetBufSize_C_SC16
 *
 * Description:
 * These functions compute the size of the specification structure required
 * for the length 2^order complex FFT and IFFT functions.
 *
 * Remarks:
 * The function is used in conjunction with the 16-bit functions
 * <FFTFwd_CToC_SC16_Sfs> and <FFTInv_CToC_SC16_Sfs>.
 *
 * Parameters:
 * [in]  order       	base-2 logarithm of the desired block length;
 *				valid in the range [0,12]..
 * [out] pSize		pointer to the number of bytes required for
 *				the specification structure.
 *
 * Return Value:
 * Standard omxError result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTGetBufSize_C_SC16(
     OMX_INT order,
     OMX_INT *pSize)
{
    OMX_INT     Nby2;
    OMX_INT     N;
    
    /* Input parameter check */ 
    armRetArgErrIf(pSize == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(order < 0, OMX_StsBadArgErr)
    armRetArgErrIf(order > 12, OMX_StsBadArgErr)
    
    /* Check for order zero */
    if (order == 0)
    {
        *pSize = sizeof(ARMsFFTSpec_FC64);   
        return OMX_StsNoErr;
    }

    Nby2 = 1 << (order - 1);
    N = 1 << order;

    /* 2 pointers to store bitreversed array and twiddle factor array */
    *pSize = sizeof(ARMsFFTSpec_FC64)
    /* N bitreversed Numbers */
           + sizeof(OMX_U16) * N
    /* N/2 Twiddle factors  */
           + sizeof(OMX_FC64) * Nby2
           + sizeof(OMX_FC64) * N;
        
    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

