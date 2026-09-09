/**
 *  omxVCM4P10_SubAndTransformQDQResidual.c
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
#include "armVC.h"

/**
 * Function:omxVCM4P10_SubAndTransformQDQResidual
 *
 * Description:
 * This function substracts the prediction signal from original signal to produce the difference 
 * signal and then performs 4x4 integer transform and quantization. The quantized transformed 
 * coefficients will be stored pDstQuantCoeff. 
 * This function can also output dequantized coefficients or unquantized DC coefficients optionally 
 * by setting the pointers pDstDeQuantCoeff, pDCCoeff. (See parameter specification)
 *
 * Remarks:
 *
 *	[in]	pSrcOrg					Pointer to original singal
 *	[in]	pSrcPred				Pointer to prediction signal.
 *	[in]	iSrcOrgStep			Step of the original signal buffer
 *	[in]	iSrcPredStep		Step of the prediction signal buffer. 
 *	[in]	pNumCoeff				Number of non-zero coefficients after quantization. 
 *															If don¡¯t need, set this to	NULL.
 *	[in]	nThreshSAD			Zero-block early detection threshold. If don¡¯t need, 
 *															set this to 0.
 *	[in]	iQP							Quantization parameter.
 *	[in]	bIntra					Indicate whether this is an INTRA block. 1-INTRA, 0-INTER
 *	[out]	pDstQuantCoeff		Pointer to the quantized transformed coefficients. 
 *	[out]	pDstDeQuantCoeff	Pointer to the dequantized transformed coefficients 
 *																if this parameter is not equal to NULL.
 *	[out]	pDCCoeff					Pointer to the unquantized DC coefficient if this parameter 
 *																is not equal to	NULL.
 *
 * Return Value:
 * Standard OMXResult value.
 *
 */
 OMXResult omxVCM4P10_SubAndTransformQDQResidual (
	 const OMX_U8*		pSrcOrg,
	 const OMX_U8*		pSrcPred,
	 OMX_U32		iSrcOrgStep,
	 OMX_U32		iSrcPredStep,
	 OMX_S16*	    pDstQuantCoeff,
	 OMX_S16* 	    pDstDeQuantCoeff,
	 OMX_S16*	    pDCCoeff,
	 OMX_S8*		pNumCoeff,
	 OMX_U32		nThreshSAD,
	 OMX_U32		iQP,
	 OMX_U8		    bIntra
)
{
    OMX_INT     i, j;
    OMX_S8      NumCoeff = 0;
    OMX_S16     Buf[16], m[16];
    OMX_U32     QBits, QPper, QPmod, f;
    OMX_S32     Value, MF, ThreshDC;

    /* check for argument error */
    armRetArgErrIf(pSrcOrg == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(armNot4ByteAligned(pSrcOrg), OMX_StsBadArgErr)
    armRetArgErrIf(pSrcPred == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(armNot4ByteAligned(pSrcPred), OMX_StsBadArgErr)
    armRetArgErrIf(pDstQuantCoeff == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(armNot8ByteAligned(pDstQuantCoeff), OMX_StsBadArgErr)
    armRetArgErrIf((pDstDeQuantCoeff != NULL) && 
        armNot8ByteAligned(pDstDeQuantCoeff), OMX_StsBadArgErr)
    armRetArgErrIf((bIntra != 0) && (bIntra != 1), OMX_StsBadArgErr)
    armRetArgErrIf(iQP > 51, OMX_StsBadArgErr)
    armRetArgErrIf(iSrcOrgStep == 0, OMX_StsBadArgErr)
    armRetArgErrIf(iSrcPredStep == 0, OMX_StsBadArgErr)
    armRetArgErrIf(iSrcOrgStep & 3, OMX_StsBadArgErr)
    armRetArgErrIf(iSrcPredStep & 3, OMX_StsBadArgErr)

    /* 
     * Zero-Block Early detection using nThreshSAD param 
     */

    QPper = iQP / 6;
    QPmod = iQP % 6;    
    QBits = 15 + QPper;
    
    f = (1 << QBits) / (bIntra ? 3 : 6);
    
    /* Do Zero-Block Early detection if enabled */
    if (nThreshSAD)
    {
        ThreshDC = ((1 << QBits) - f) / armVCM4P10_MFMatrix[QPmod][0];
        if (nThreshSAD < ThreshDC)
        {
            /* Set block to zero */
            if (pDCCoeff != NULL)
            {
                *pDCCoeff = 0;
            }

            for (j = 0; j < 4; j++)
            {
                for (i = 0; i < 4; i++)
                {
                    pDstQuantCoeff [4 * j + i] = 0;
                    if (pDstDeQuantCoeff != NULL)
                    {
                        pDstDeQuantCoeff [4 * j + i] = 0;    
                    }                    
                }
            }

            if (pNumCoeff != NULL)
            {
                *pNumCoeff = 0;
            }
            return OMX_StsNoErr;
        }
    }


   /* Calculate difference */
    for (j = 0; j < 4; j++)
    {
        for (i = 0; i < 4; i++)
        {
            Buf [j * 4 + i] = 
                pSrcOrg [j * iSrcOrgStep + i] - pSrcPred [j * iSrcPredStep + i];
        }
    }

    /* Residual Transform */
    armVCM4P10_FwdTransformResidual4x4 (m, Buf);

    if (pDCCoeff != NULL)
    {
        /* Copy unquantized DC value into pointer */
        *pDCCoeff = m[0];
    }

    /* Quantization */
    for (j = 0; j < 4; j++)
    {
        for (i = 0; i < 4; i++)
        {
            MF = armVCM4P10_MFMatrix[QPmod][armVCM4P10_PosToVCol4x4[j * 4 + i]];
            Value = armAbs(m[j * 4 + i]) * MF + f;
            Value >>= QBits;
            Value = m[j * 4 + i] < 0 ? -Value : Value;
            Buf[4 * j + i] = pDstQuantCoeff [4 * j + i] = (OMX_S16)Value;
            if ((pNumCoeff != NULL) && Value)
            {
                NumCoeff++;
            }
        }
    }

    /* Output number of non-zero Coeffs */
    if (pNumCoeff != NULL)
    {
        *pNumCoeff = NumCoeff;
    }
    
    /* Residual Inv Transform */
    if (pDstDeQuantCoeff != NULL)
    {    
        /* Re Scale */
        for (j = 0; j < 4; j++)
        {
            for (i = 0; i < 4; i++)
            {
                m [j * 4 + i]  = Buf [j * 4 + i] * (1 << QPper) *
                    armVCM4P10_VMatrix[QPmod][armVCM4P10_PosToVCol4x4[j * 4 + i]];
            }
        }
        armVCM4P10_TransformResidual4x4 (pDstDeQuantCoeff, m);        
    }
        
    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

