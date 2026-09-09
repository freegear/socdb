/**
 *  omxVCM4P10_InvTransformResidualAndAdd.c
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
 * This function will inverse integer 4x4 transform
 * 
 */

#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"
#include "armVC.h"

/**
 * Function:omxVCM4P10_InvTransformResidualAndAdd
 *
 * Description:
 * This function performs inverse 4x4 integer transform to produce the difference 
 * signal and then add the difference to prediction to get the reconstructed signal.
 *
 * Remarks:
 *
 *	[in]	pSrcPred			Pointer to prediction signal.
 *	[in]	pDequantCoeff	Pointer to the transformed coefficients.
 *	[in]	iSrcPredStep	Step of the prediction buffer.
 *	[in]	iDstReconStep	Step of the destination reconstruction buffer
 *	[in]	bAC						Indicate whether there is AC coefficients in the coefficients matrix. 
 *	[out]	pDstRecon			Pointer to the destination reconstruction buffer. 
 *
 * Return Value:
 * Standard OMXResult value.
 *
 */
OMXResult omxVCM4P10_InvTransformResidualAndAdd(
	const OMX_U8* 	pSrcPred, 
	const OMX_S16* 	pDequantCoeff, 
	OMX_U8* 	pDstRecon,
	OMX_U32 	iSrcPredStep, 
	OMX_U32		iDstReconStep, 
	OMX_U8		bAC
)
{
    OMX_INT     i, j;
    OMX_S16     In[16], Out[16];
    OMX_S32     Value;

    /* check for argument error */
    armRetArgErrIf(pSrcPred == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(armNot4ByteAligned(pSrcPred), OMX_StsBadArgErr)
    armRetArgErrIf(pDequantCoeff == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(armNot8ByteAligned(pDequantCoeff), OMX_StsBadArgErr)
    armRetArgErrIf(pDstRecon == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(armNot4ByteAligned(pDstRecon), OMX_StsBadArgErr)
    armRetArgErrIf(bAC > 1, OMX_StsBadArgErr)
    armRetArgErrIf(iSrcPredStep == 0 || iSrcPredStep & 3, OMX_StsBadArgErr)
    armRetArgErrIf(iDstReconStep == 0 || iDstReconStep & 3, OMX_StsBadArgErr)

    if (bAC)
    {
        for (i = 0; i < 16; i++)
        {
            In[i] = pDequantCoeff [i];
        }
    }
    else
    {
        /* Copy DC */
        In[0] = pDequantCoeff [0];
    
        for (i = 1; i < 16; i++)
        {
            In[i] = 0;
        }
    }

    /* Residual Transform */
    armVCM4P10_TransformResidual4x4 (Out, In);    
    
    for (j = 0; j < 4; j++)
    {
        for (i = 0; i < 4; i++)
        {
            /* Add predition */
            Value = (OMX_S32) Out [j * 4 + i] + pSrcPred [j * iSrcPredStep + i];
            
            /* Saturate Value to OMX_U8 */
            Value = armClip (0, 255, Value);

            pDstRecon[j * iDstReconStep + i] = (OMX_U8) Value;
        }
    }

    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

