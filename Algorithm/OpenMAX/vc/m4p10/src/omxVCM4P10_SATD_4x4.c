/**
 *  omxVCM4P10_SATD_4x4.c
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
 * This function will calculate SAD for 4x4 blocks
 * 
 */
#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"

/**
 * Function: omxVCM4P10_SATD_4x4
 *
 * Description:
 * This function calculate the SATD for a 4x4 block.
 * SATD is calculated by imposing Hadarmard transform on the
 * difference block and then calculating the sum of absolute
 * values of the coefficients
 *
 * Remarks:
 *
 * [in]		pSrcOrg			Pointer to the original block. Must be 4-byte aligned.
 * [in]		iStepOrg		Step of the original block buffer. Must be multiple of 4.
 * [in]		pSrcRef			Pointer to the reference block. Must be 4-byte aligned.
 * [in]		iStepRef		Step of the reference block buffer. Must be multiple of 4.
 * [out]	pDstSAD			Pointer of result SAD
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - At least one of the following pointers is NULL: pSrcOrg, pSrcRef, pDstSAD.
 *    - pSrcOrg or pSrcRef is not 4 byte aligned.
 *    - iStepOrg <= 0 or iStepOrg is not a multiple of 4.
 *    - iStepRef <= 0 or iStepRef is not a multiple of 4.
 *
 */
OMXResult omxVCM4P10_SATD_4x4( 
	const OMX_U8*		pSrcOrg,
	OMX_U32     iStepOrg,                         
	const OMX_U8*		pSrcRef,
	OMX_U32		iStepRef,
	OMX_U32*    pDstSAD
)
{
    OMX_INT     i, j;
    OMX_S32     SATD = 0;
    OMX_S32     d [4][4], m1[4][4], m2[4][4];

    /* check for argument error */
    armRetArgErrIf(pSrcOrg == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pSrcRef == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstSAD == NULL, OMX_StsBadArgErr)
    armRetArgErrIf((iStepOrg == 0) || (iStepOrg & 3), OMX_StsBadArgErr)
    armRetArgErrIf((iStepRef == 0) || (iStepRef & 3), OMX_StsBadArgErr)
    armRetArgErrIf(armNot4ByteAligned(pSrcOrg), OMX_StsBadArgErr)
    armRetArgErrIf(armNot4ByteAligned(pSrcRef), OMX_StsBadArgErr)

    /* Calculate the difference */
    for (j = 0; j < 4; j++)
    {
        for (i = 0; i < 4; i++)
        {
            d [j][i] = pSrcOrg [j * iStepOrg + i] - pSrcRef [j * iStepRef + i];
        }
    }

    /* Hadamard Transfor for 4x4 block */

    /* Horizontal */
    for (i = 0; i < 4; i++)
    {
        m1[i][0] = d[i][0] + d[i][2]; /* a+c */
        m1[i][1] = d[i][1] + d[i][3]; /* b+d */
        m1[i][2] = d[i][0] - d[i][2]; /* a-c */
        m1[i][3] = d[i][1] - d[i][3]; /* b-d */

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
    
    /* calculate SAD for Transformed coefficients */
    for (j = 0; j < 4; j++)
    {
        for (i = 0; i < 4; i++)
        {
            SATD += armAbs(m2 [j][i]);
        }
    }
        
    *pDstSAD = (SATD + 1) / 2;

    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

