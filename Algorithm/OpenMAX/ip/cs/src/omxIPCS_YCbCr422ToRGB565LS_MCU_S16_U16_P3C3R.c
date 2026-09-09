/**
 *
 *  omxIPCS_YCbCr422ToRGB565LS_MCU_S16_U16_P3C3R.c
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
 * Description  : Colour Conversion Routine - Converts YUV422 to RGB565 in floating point.
 *                Source data is stored as a JPEG MCU in three channel, planar domain and 
 *                the destination would be in three-channel pixel format.
 *
 */

#include "omxtypes.h"
#include "armCOMM.h"
#include "armIP.h"

OMXResult omxIPCS_YCbCr422ToRGB565LS_MCU_S16_U16_P3C3R(
        const OMX_S16 *pSrcMCU[3],
        OMX_U16 *pDstRGB,
        OMX_INT dstStep
       )
{   
    const OMX_S16 *pSrcY, *pSrcCb, *pSrcCr;
    OMX_INT convWidth   = JPEG_MCU_PIX_WIDTH_422;
    OMX_INT convHeight  = JPEG_MCU_PIX_HEIGHT_422;
    OMX_S16 Ydata, Ydata2, Udata, Vdata;
    OMX_U8  Rdata, Gdata, Bdata, Rdata2, Gdata2, Bdata2;
    OMX_INT i, j;
    
    armRetArgErrIf(!pSrcMCU, OMX_StsBadArgErr);
    armRetArgErrIf(!pDstRGB, OMX_StsBadArgErr);
    armRetArgErrIf(!pSrcMCU[0], OMX_StsBadArgErr);
    armRetArgErrIf(!pSrcMCU[1], OMX_StsBadArgErr);
    armRetArgErrIf(!pSrcMCU[2], OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pSrcMCU[0]), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pSrcMCU[1]), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pSrcMCU[2]), OMX_StsBadArgErr);
    armRetArgErrIf(((dstStep > (-2 * JPEG_MCU_PIX_WIDTH_422)) && ((dstStep < 2 * JPEG_MCU_PIX_WIDTH_422))), OMX_StsBadArgErr);

    /*
    ---------------------------------------------------------------------------------
    With input data (Y, Cb, Cr) belonging to [-128, 127] and output data (R, G, B) 
    belonging to [0, 255], colour conversion equations in the JPEG domain would be - 
    R = (Y + 128) + 1.40200 * Cr
    G = (Y + 128) - 0.34414 * Cb - 0.71414 * Cr
    B = (Y + 128) + 1.77200 * Cb
    
    The armComputeXFromYUV_JPEG() functions apart from doing the colour conversion, 
    takes care of type-conversion from intermediate float values and clipping to U8,
    taking care of rounding errors.  This is followed armIPCS_PackToRGB565() that packs
    the R, G, B data in 565 format.
    ---------------------------------------------------------------------------------
    */
    
    pSrcY   = pSrcMCU[0];
    pSrcCb  = pSrcMCU[1];
    pSrcCr  = pSrcMCU[2];
    
    for(i = 0; i < convHeight; i++, pDstRGB += (dstStep >> 1) )
    {
        for(j = 0; j < convWidth; j += 2)
        {
            Ydata       = *pSrcY++;
            Ydata2      = *pSrcY++;
            Udata       = *pSrcCb++;
            Vdata       = *pSrcCr++;
            
            armIPCS_ComputeRFromYUV_JPEG(Ydata, Udata, Vdata, &Rdata);
            armIPCS_ComputeGFromYUV_JPEG(Ydata, Udata, Vdata, &Gdata);
            armIPCS_ComputeBFromYUV_JPEG(Ydata, Udata, Vdata, &Bdata);
            
            armIPCS_ComputeRFromYUV_JPEG(Ydata2, Udata, Vdata, &Rdata2);
            armIPCS_ComputeGFromYUV_JPEG(Ydata2, Udata, Vdata, &Gdata2);
            armIPCS_ComputeBFromYUV_JPEG(Ydata2, Udata, Vdata, &Bdata2);
            
            pDstRGB[j]   = (OMX_U16)armIPCS_PackToRGB565(Rdata,  Gdata,  Bdata);
            pDstRGB[j+1] = (OMX_U16)armIPCS_PackToRGB565(Rdata2, Gdata2, Bdata2);
        }
    }
    return OMX_StsNoErr;
}

/* End of file */
