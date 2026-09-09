/**
 *  omxVCM4P10_TransformQuant_ChromaDC.c
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
 * Function: omxVCM4P10_TransformQuant_ChromaDC
 *
 * Description:
 * This function performs 2x2 hadamard transform of chroma DC coefficients and then 
 * quantize the coefficients.
 *
 * Remarks:
 *
 *	[in]	pSrcDst		Pointer to the 2x2 array of chroma DC coefficients.
 *	[in]	iQP			Quantization parameter.
 *	[in]	bIntra		Indicate whether this is an INTRA block. 1-INTRA, 0-INTER
 *	[out]	pSrcDst		Pointer to transformed and quantized coefficients.
 *
 * Return Value:
 * Standard OMXResult value.
 *
 */
OMXResult omxVCM4P10_TransformQuant_ChromaDC(
	OMX_S16* 	pSrcDst,
	OMX_U32		iQP,
	OMX_U8		bIntra
)
{
    OMX_INT     i, j;
    OMX_S32     m[2][2];
    OMX_S32     Value;
    OMX_S32     QbitsPlusOne, Two_f, MF00;

    /* Check for argument error */
    armRetArgErrIf(pSrcDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(armNot8ByteAligned(pSrcDst), OMX_StsBadArgErr);
    armRetArgErrIf(iQP > 51, OMX_StsBadArgErr);

    /* Hadamard Transform for 2x2 block */
    m[0][0] = pSrcDst[0] + pSrcDst[1] +  pSrcDst[2] + pSrcDst[3];
    m[0][1] = pSrcDst[0] - pSrcDst[1] +  pSrcDst[2] - pSrcDst[3];
    m[1][0] = pSrcDst[0] + pSrcDst[1] -  pSrcDst[2] - pSrcDst[3];
    m[1][1] = pSrcDst[0] - pSrcDst[1] -  pSrcDst[2] + pSrcDst[3];

    /* Quantization */
    QbitsPlusOne = ARM_M4P10_Q_OFFSET + 1 + (iQP / 6); /*floor (QP/6)*/
    MF00 = armVCM4P10_MFMatrix [iQP % 6][0];

    Two_f = (1 << QbitsPlusOne) / (bIntra ? 3 : 6); /* 3->INTRA, 6->INTER */

    /* Scaling */
    for (j = 0; j < 2; j++)
    {
        for (i = 0; i < 2; i++)
        {
            Value = (armAbs(m[j][i]) * MF00 + Two_f) >> QbitsPlusOne;
            pSrcDst[j * 2 + i] = (OMX_S16)((m[j][i] < 0) ? -Value : Value);
        }
    }

    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

