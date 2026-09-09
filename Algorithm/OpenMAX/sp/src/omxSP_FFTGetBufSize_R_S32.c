/**
 *  omxSP_FFTGetBufSize_R_S32.c
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
 * Computes the size of the specification structure required.
 */

#include "omxtypes.h"
#include "omxSP.h"
#include "armCOMM.h"
#include "armSP.h"

/**
 * Function: omxSP_FFTGetBufSize_R_S32
 *
 * Description:
 * Computes the size of the specification structure required for the length
 * 2^order real FFT and IFFT functions.
 *
 * Remarks:
 * This function is used in conjunction with the 32-bit functions
 * <FFTFwd_RToCCS_S32_Sfs> and <FFTInv_CCSToR_S32_Sfs>.
 *
 * Parameters:
 * [in]  order       base-2 logarithm of the length; valid in the range
 *			   [0,12].
 * [out] pSize	   pointer to the number of bytes required for the
 *			   specification structure.
 *
 * Return Value:
 * Standard omxError result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTGetBufSize_R_S32(
     OMX_INT order,     
     OMX_INT *pSize
 )
{
    OMX_INT     NBy2;
    
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
    
    NBy2 = 1 << (order - 1);
    
    /* 2 pointers to store bitreversed array and twiddle factor array */
    *pSize = sizeof(ARMsFFTSpec_FC64)
    /* N bitreversed Numbers */
           + sizeof(OMX_U16) * NBy2
    /* Twiddle factors  */
           + sizeof(OMX_FC64) * NBy2
           + sizeof(OMX_F64) * (2 + (NBy2 << 1));

    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

