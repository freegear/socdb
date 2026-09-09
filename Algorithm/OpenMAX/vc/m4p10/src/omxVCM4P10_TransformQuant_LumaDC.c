/**
 *  omxVCM4P10_TransformQuant_LumaDC.c
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
 * This function will calculate 4x4 hadamard transform of luma DC coefficients 
 * and quantization
 * 
 */

#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"
#include "armVC.h"

/**
 * Function:omxVCM4P10_TransformQuant_LumaDC
 *
 * Description:
 * This function performs 4x4 hadamard transform of luma DC coefficients and then 
 * quantize the coefficients.
 *
 * Remarks:
 *
 *	[in]	pSrcDst	Pointer to the 4x4 array of luma DC coefficients.
 *	[in]	iQP		Quantization parameter.
 *	[out]	pSrcDst	Pointer to transformed and quantized coefficients.
 *
 * Return Value:
 * Standard OMXResult value.
 *
 */																						
OMXResult omxVCM4P10_TransformQuant_LumaDC(
	OMX_S16* 	pSrcDst,
	OMX_U32		iQP
)
{
    OMX_INT     i, j;
    OMX_S32     m1[4][4], m2[4][4];
    OMX_S32     Value;
    OMX_U32     QbitsPlusOne, Two_f, MF;

    /* Check for argument error */
    armRetArgErrIf(pSrcDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(armNot16ByteAligned(pSrcDst), OMX_StsBadArgErr);
    armRetArgErrIf(iQP > 51, OMX_StsBadArgErr);

    /* Hadamard Transform for 4x4 block */
    /* Horizontal Hadamard */
    for (i = 0; i < 4; i++)
    {
        j = i * 4;
        
        m1[i][0] = pSrcDst[j + 0] + pSrcDst[j + 2]; /* a+c */
        m1[i][1] = pSrcDst[j + 1] + pSrcDst[j + 3]; /* b+d */
        m1[i][2] = pSrcDst[j + 0] - pSrcDst[j + 2]; /* a-c */
        m1[i][3] = pSrcDst[j + 1] - pSrcDst[j + 3]; /* b-d */

        m2[i][0] = m1[i][0] + m1[i][1]; /* a+b+c+d */
        m2[i][1] = m1[i][2] + m1[i][3]; /* a+b-c-d */
        m2[i][2] = m1[i][2] - m1[i][3]; /* a-b-c+d */
        m2[i][3] = m1[i][0] - m1[i][1]; /* a-b+c-d */

    }

    /* Vertical */
    for (i = 0; i < 4; i++)
    {
        m1[0][i] = m2[0][i] + m2[2][i];
        m1[1][i] = m2[1][i] + m2[3][i];
        m1[2][i] = m2[0][i] - m2[2][i];
        m1[3][i] = m2[1][i] - m2[3][i];

        m2[0][i] = m1[0][i] + m1[1][i];
        m2[1][i] = m1[2][i] + m1[3][i];
        m2[2][i] = m1[2][i] - m1[3][i];
        m2[3][i] = m1[0][i] - m1[1][i];
    }

    
    /* Quantization */
    QbitsPlusOne = ARM_M4P10_Q_OFFSET + 1 + (iQP / 6); /*floor (QP/6)*/
    Two_f = (1 << QbitsPlusOne) / 3; /* 3->INTRA, 6->INTER */
    MF = armVCM4P10_MFMatrix [iQP % 6][0];

    /* Scaling */
    for (j = 0; j < 4; j++)
    {
        for (i = 0; i < 4; i++)
        {
            Value = (armAbs((m2[j][i]/* + 1*/) / 2) * MF + Two_f) >> QbitsPlusOne;
            pSrcDst[j * 4 + i] = (OMX_S16)((m2[j][i] < 0) ? -Value : Value);
        }
    }
    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

