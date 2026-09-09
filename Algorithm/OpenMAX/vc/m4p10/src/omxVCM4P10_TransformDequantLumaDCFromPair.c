/* ----------------------------------------------------------------
 *
 *  omxVCM4P10_TransformDequantLumaDCFromPair.c
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
 * Dequantize Luma DC block
 */

static void DequantLumaDC4x4(
     OMX_S16* pDst,
     OMX_INT QP        
)
{
    int Shift = (QP/6)-2 ;
    int Scale = armVCM4P10_VMatrix[QP%6][0];
    int i, Round, Value;

    if (Shift >= 0)
    {
        for (i=0; i<16; i++)
        {
            Value = (pDst[i] * Scale) << Shift;
            pDst[i] = (OMX_S16)Value;
        }
    }
    else
    {
        Shift = -Shift;;
        Round = 1<<(Shift-1);

        for (i=0; i<16; i++)
        {
            Value = (pDst[i] * Scale + Round) >> Shift;
            pDst[i] = (OMX_S16)Value;
        }
    }
}

 

/*
 * Description:
 * Inverse Transform DC 4x4 Coefficients
 */
static void InvTransformDC4x4(OMX_S16* pData)
{
    int i;

    /* Transform rows */
    for (i=0; i<16; i+=4)
    {
        int c0 = pData[i+0];
        int c1 = pData[i+1];
        int c2 = pData[i+2];
        int c3 = pData[i+3];
        pData[i+0] = (OMX_S16)(c0+c1+c2+c3);
        pData[i+1] = (OMX_S16)(c0+c1-c2-c3);
        pData[i+2] = (OMX_S16)(c0-c1-c2+c3);
        pData[i+3] = (OMX_S16)(c0-c1+c2-c3);
    }

    /* Transform columns */
    for (i=0; i<4; i++)
    {
        int c0 = pData[i+0];
        int c1 = pData[i+4];
        int c2 = pData[i+8];
        int c3 = pData[i+12];
        pData[i+0] = (OMX_S16)(c0+c1+c2+c3);
        pData[i+4] = (OMX_S16)(c0+c1-c2-c3);
        pData[i+8] = (OMX_S16)(c0-c1-c2+c3);
        pData[i+12] = (OMX_S16)(c0-c1+c2-c3);
    }
}


/**
 * Function: omxVCM4P10_TransformDequantLumaDCFromPair
 *
 * Description:
 * Reconstruct the 4x4 LumaDC block from coefficient-position pair buffer,
 * perform integer inverse, and dequantization for 4x4 LumaDC coefficients,
 * and update the pair buffer pointer to next non-empty block.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppSrc	Double pointer to residual coefficient-position pair
 *						buffer output by CALVC decoding
 * [in]	QP		Quantization parameter QpY
 * [out]	ppSrc	*ppSrc is updated to the start of next non empty block
 * [out]	pDst	Pointer to the reconstructed 4x4 LumaDC coefficients buffer
 *
 * Return Value:
 * Standard omxError result. See enumeration for possible result codes.
 *
 */

OMXResult omxVCM4P10_TransformDequantLumaDCFromPair(
     const OMX_U8 **ppSrc,
     OMX_S16* pDst,
     OMX_INT QP        
 )
{
    armRetArgErrIf(ppSrc  == NULL,           OMX_StsBadArgErr);
    armRetArgErrIf(*ppSrc == NULL,           OMX_StsBadArgErr);
    armRetArgErrIf(pDst   == NULL,           OMX_StsBadArgErr);
    armRetArgErrIf(armNot8ByteAligned(pDst), OMX_StsBadArgErr);
    armRetArgErrIf(QP<0,                     OMX_StsBadArgErr);
    armRetArgErrIf(QP>51,                    OMX_StsBadArgErr);

    armVCM4P10_UnpackBlock4x4(ppSrc, pDst);
    /*InvTransformDequantLumaDC4x4(pDst, QP);*/
    InvTransformDC4x4(pDst);
    DequantLumaDC4x4(pDst, QP);

    return OMX_StsNoErr;
}

/* End of file */
