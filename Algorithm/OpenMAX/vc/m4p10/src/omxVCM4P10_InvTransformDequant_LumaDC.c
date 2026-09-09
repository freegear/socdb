/**
 *  omxVCM4P10_InvTransformDequant_LumaDC.c
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
 * Function:omxVCM4P10_InvTransformDequant_LumaDC
 *
 * Description:
 * This function performs inverse 4x4 hadamard transform and then dequantize the 
 * coefficients.
 *
 * Remarks:
 *
 *	[in]	pSrc		Pointer to the 4x4 array of the 4x4 hadamard transformed 
 *											and quantized coefficients.
 *	[in]	iQP			Quantization parameter.
 *	[out]	pDst		Pointer to inverse-transformed and dequantized coefficients.
 *
 * Return Value:
 * Standard OMXResult value.
 *
 */																					
OMXResult omxVCM4P10_InvTransformDequant_LumaDC(	
	const OMX_S16* 	pSrc,
	OMX_S16*	pDst,
	OMX_U32		iQP
)
{
    OMX_INT     i, j;
    OMX_S32     m1[4][4], m2[4][4], Value;
    OMX_S32     QPer, V;

    /* check for argument error */
    armRetArgErrIf(pSrc == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(iQP > 51, OMX_StsBadArgErr)
    armRetArgErrIf(armNot16ByteAligned(pSrc), OMX_StsBadArgErr)
    armRetArgErrIf(armNot16ByteAligned(pDst), OMX_StsBadArgErr)

    /* Inv Hadamard Transform for DC Luma 4x4 block */
    /* Horizontal */
    for (i = 0; i < 4; i++)
    {
        j = i * 4;
        
        m1[i][0] = pSrc[j + 0] + pSrc[j + 2]; /* a+c */
        m1[i][1] = pSrc[j + 1] + pSrc[j + 3]; /* b+d */
        m1[i][2] = pSrc[j + 0] - pSrc[j + 2]; /* a-c */
        m1[i][3] = pSrc[j + 1] - pSrc[j + 3]; /* b-d */

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

    
    /* Scaling */
    QPer = iQP / 6;
    V = armVCM4P10_VMatrix [iQP % 6][0];

    for (j = 0; j < 4; j++)
    {
        for (i = 0; i < 4; i++)
        {
            if (QPer < 2)
            {
                Value = (m2[j][i] * V + (1 << (1 - QPer))) >> (2 - QPer);
            }
            else
            {
                Value = m2[j][i] * V * (1 << (QPer - 2));
            }
                        
            pDst[j * 4 + i] = (OMX_S16) Value;
            
        }
    }
    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

