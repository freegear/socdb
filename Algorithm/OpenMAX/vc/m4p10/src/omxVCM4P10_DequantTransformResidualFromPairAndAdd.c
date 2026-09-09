/* ----------------------------------------------------------------
 *
 *  omxVCM4P10_DequantTransformResidualFromPairAndAdd.c
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
 * Dequantize Luma AC block
 */

static void DequantLumaAC4x4(
     OMX_S16* pSrcDst,
     OMX_INT QP        
)
{
    const OMX_U8 *pVRow = &armVCM4P10_VMatrix[QP%6][0];
    int Shift = QP / 6;
    int i;
    OMX_S32 Value;

    for (i=0; i<16; i++)
    {

        Value = (pSrcDst[i] * pVRow[armVCM4P10_PosToVCol4x4[i]]) << Shift;
        pSrcDst[i] = (OMX_S16)Value;
    }
}

/**
 * Function: omxVCM4P10_DequantTransformResidualFromPairAndAdd
 *
 * Description:
 * Reconstruct the 4x4 residual block from coefficient-position pair buffer,
 * perform dequantisation and integer inverse transformation for 4x4 block of
 * residuals with previous intra prediction or motion compensation data, and
 * update the pair buffer pointer to next non-empty block.If pDC == NULL, 
 * there¡¯re 16 non-zero AC coefficients at most in the packed buffer starting 
 * from 4x4 block position 0; If pDC != NULL, there¡¯re 15 non-zero AC 
 * coefficients at most in the packet buffer starting from 4x4 block position 1
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppSrc		Double pointer to residual coefficient-position
 *							pair buffer output by CALVC decoding
 * [in]	pPred		Pointer to the reference 4x4 block
 * [in]	predStep	Reference frame step in byte
 * [in]	dstStep		Destination frame step in byte
 * [in]	pDC			Pointer to the DC coefficient of this block, NULL
 *							if it doesn't exist
 * [in]	QP			Quantization parameter It should be QpC in chroma 4x4 
 *              block decoding, otherwise it should be QpY
 * [in]	AC			Flag indicating if at least one non-zero AC coefficient
 *							exists
 * [out]	pDst		pointer to the reconstructed 4x4 block data
 *
 * Return Value:
 * Standard omxError result. See enumeration for possible result codes.
 *
 */

OMXResult omxVCM4P10_DequantTransformResidualFromPairAndAdd(
     const OMX_U8 **ppSrc,
     const OMX_U8 *pPred,
     const OMX_S16 *pDC,
     OMX_U8 *pDst,
     OMX_INT predStep,
     OMX_INT dstStep,
     OMX_INT QP,
     OMX_INT AC        
)
{
    OMX_S16 pBuffer[16+4];
    OMX_S16 *pDelta;
    int i,x,y;
    
    armRetArgErrIf(pPred == NULL,            OMX_StsBadArgErr);
    armRetArgErrIf(armNot4ByteAligned(pPred),OMX_StsBadArgErr);
    armRetArgErrIf(pDst   == NULL,           OMX_StsBadArgErr);
    armRetArgErrIf(armNot4ByteAligned(pDst), OMX_StsBadArgErr);
    armRetArgErrIf(predStep & 3,             OMX_StsBadArgErr);
    armRetArgErrIf(dstStep & 3,              OMX_StsBadArgErr);
    armRetArgErrIf(AC!=0 && (QP<0),          OMX_StsBadArgErr);
    armRetArgErrIf(AC!=0 && (QP>51),         OMX_StsBadArgErr);
    armRetArgErrIf(AC!=0 && ppSrc==NULL,     OMX_StsBadArgErr);
    armRetArgErrIf(AC!=0 && *ppSrc==NULL,    OMX_StsBadArgErr);
    armRetArgErrIf(AC==0 && pDC==NULL,       OMX_StsBadArgErr);
    
    pDelta = armAlignTo8Bytes(pBuffer);    

    for (i=0; i<16; i++)
    {
        pDelta[i] = 0;
    }
    if (AC)
    {
        armVCM4P10_UnpackBlock4x4(ppSrc, pDelta);
        DequantLumaAC4x4(pDelta, QP);
    }
    if (pDC)
    {
        pDelta[0] = pDC[0];
    }
    armVCM4P10_TransformResidual4x4(pDelta,pDelta);

    for (y=0; y<4; y++)
    {
        for (x=0; x<4; x++)
        {
            pDst[y*dstStep+x] = (OMX_U8)armClip(0,255,pPred[y*predStep+x] + pDelta[4*y+x]);
        }
    }

    return OMX_StsNoErr;
}

/* End of file */
