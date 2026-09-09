/**
 *  omxVCM4P10_InvTransformDequant_ChromaDC.c
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
 * This function will calculate 4x4 hadamard transform of chroma DC  
 * coefficients and quantization
 * 
 */

#include "omxtypes.h"
#include "omxVC.h"
#include "armVC.h"
#include "armCOMM.h"

/**
 * Function:omxVCM4P10_InvTransformDequant_ChromaDC
 *
 * Description:
 * This function performs inverse 2x2 hadamard transform and then dequantize the 
 * coefficients.
 *
 * Remarks:
 *
 *	[in]	pSrc	Pointer to the 2x2 array of the 2x2 hadamard transformed and 
 *										quantized coefficients.
 *	[in]	iQP		Quantization parameter.
 *	[out]	pDst	Pointer to inverse-transformed and dequantized coefficients.
 *
 * Return Value:
 * Standard OMXResult value.
 *
 */																								
OMXResult omxVCM4P10_InvTransformDequant_ChromaDC(
	const OMX_S16* 	pSrc,
	OMX_S16*	pDst,
	OMX_U32		iQP
)
{
    OMX_INT     i, j;
    OMX_S32     m[2][2];
    OMX_S32     QPer, V00, Value;

    /* check for argument error */
    armRetArgErrIf(pSrc == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(armNot8ByteAligned(pSrc), OMX_StsBadArgErr);
    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(armNot8ByteAligned(pDst), OMX_StsBadArgErr);
    armRetArgErrIf(iQP > 51, OMX_StsBadArgErr)

    /* Inv Hadamard Transform for 2x2 block */
    m[0][0] = pSrc[0] + pSrc[1] +  pSrc[2] + pSrc[3];
    m[0][1] = pSrc[0] - pSrc[1] +  pSrc[2] - pSrc[3];
    m[1][0] = pSrc[0] + pSrc[1] -  pSrc[2] - pSrc[3];
    m[1][1] = pSrc[0] - pSrc[1] -  pSrc[2] + pSrc[3];

    /* Quantization */
    /* Scaling */
    QPer = iQP / 6;
    V00 = armVCM4P10_VMatrix [iQP % 6][0];

    for (j = 0; j < 2; j++)
    {
        for (i = 0; i < 2; i++)
        {
            if (QPer < 1)
            {
                Value = (m[j][i] * V00) >> 1;
            }
            else
            {
                Value = (m[j][i] * V00) << (QPer - 1);
            }

            pDst[j * 2 + i] = (OMX_S16) Value;
        }
    }

    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

