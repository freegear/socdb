/* ----------------------------------------------------------------
 *
 *  omxVCM4P10_TransformDequantChromaDCFromPair.c
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
 *
 * H.264 inverse quantize and transform module
 * 
 */
 
#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"
#include "armVC.h"

/*
 * Description:
 * Dequantize Chroma 2x2 DC block
 */

static void DequantChromaDC2x2(
     OMX_S16* pDst,
     OMX_INT QP        
)
{
    int Shift = (QP/6)-1 ;
    int Scale = armVCM4P10_VMatrix[QP%6][0];
    int i, Value;

    if (Shift >= 0)
    {
        for (i=0; i<4; i++)
        {
            Value = (pDst[i] * Scale) << Shift;
            pDst[i] = (OMX_S16)Value;
        }
    }
    else
    {
        for (i=0; i<4; i++)
        {
            Value = (pDst[i] * Scale) >> 1;
            pDst[i] = (OMX_S16)Value;
        }
    }
}
 

/*
 * Description:
 * Inverse Transform DC 2x2 Coefficients
 */

static void InvTransformDC2x2(OMX_S16* pData)
{
    int c00 = pData[0];
    int c01 = pData[1];
    int c10 = pData[2];
    int c11 = pData[3];

    int d00 = c00 + c01;
    int d01 = c00 - c01;
    int d10 = c10 + c11;
    int d11 = c10 - c11;

    pData[0] = (OMX_S16)(d00 + d10);
    pData[1] = (OMX_S16)(d01 + d11);
    pData[2] = (OMX_S16)(d00 - d10);
    pData[3] = (OMX_S16)(d01 - d11);
}


/**
 * Function: omxVCM4P10_TransformDequantChromaDCFromPair
 *
 * Description:
 * Reconstruct the 2x2 ChromaDC block from coefficient-position pair buffer,
 * perform integer inverse transformation, and dequantization for 2x2 chroma
 * DC coefficients, and update the pair buffer pointer to next non-empty block.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppSrc	Double pointer to residual coefficient-position pair
 *						buffer output by CALVC decoding
 * [in]	QP		Quantization parameter QpC
 * [out]	ppSrc	*ppSrc is updated to the start of next non empty block
 * [out]	pDst	Pointer to the reconstructed 2x2 ChromaDC coefficients
 * Return Value:
 * Standard omxError result. See enumeration for possible result codes.
 *
 */

OMXResult omxVCM4P10_TransformDequantChromaDCFromPair(
     const OMX_U8 **ppSrc,
     OMX_S16* pDst,
     OMX_INT QP        
 )
{
    armRetArgErrIf(ppSrc  == NULL,           OMX_StsBadArgErr);
    armRetArgErrIf(*ppSrc == NULL,           OMX_StsBadArgErr);
    armRetArgErrIf(pDst   == NULL,           OMX_StsBadArgErr);
    armRetArgErrIf(armNot4ByteAligned(pDst), OMX_StsBadArgErr);
    armRetArgErrIf(QP<0,                     OMX_StsBadArgErr);
    armRetArgErrIf(QP>51,                    OMX_StsBadArgErr);

    armVCM4P10_UnpackBlock2x2(ppSrc, pDst);
    InvTransformDC2x2(pDst);
    DequantChromaDC2x2(pDst, QP);

    return OMX_StsNoErr;
}

/* End of file */
