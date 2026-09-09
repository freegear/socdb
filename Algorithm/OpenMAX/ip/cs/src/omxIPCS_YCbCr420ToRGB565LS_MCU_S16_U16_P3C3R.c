/**
 *
 *  omxIPCS_YCbCr420ToRGB565LS_MCU_S16_U16_P3C3R.c
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
 * Description  : Colour Conversion Routine - Converts YUV420 to RGB565 in floating point.
 *                Source data is stored as a JPEG MCU in three channel, planar domain and 
 *                the destination would be in three-channel pixel format.
 *
 */

#include "omxtypes.h"
#include "armCOMM.h"
#include "armIP.h"

OMXResult omxIPCS_YCbCr420ToRGB565LS_MCU_S16_U16_P3C3R(
        const OMX_S16 *pSrcMCU[3],
        OMX_U16 *pDstRGB,
        OMX_INT dstStep
       )
{
    const OMX_S16 *pSrcY, *pSrcY2, *pSrcCb, *pSrcCr;
    OMX_U16 *pDstRGB2   = pDstRGB + (dstStep >> 1);
    OMX_INT convWidth   = JPEG_MCU_PIX_WIDTH_420;
    OMX_INT convHeight  = JPEG_MCU_PIX_HEIGHT_420;
    OMX_S16 Ydata, Ydata2, Ydata3, Ydata4, Udata, Vdata;
    OMX_U8  Rdata, Rdata2, Rdata3, Rdata4;
    OMX_U8  Gdata, Gdata2, Gdata3, Gdata4;
    OMX_U8  Bdata, Bdata2, Bdata3, Bdata4;
    OMX_INT i, j;
    
    armRetArgErrIf(!pSrcMCU, OMX_StsBadArgErr);
    armRetArgErrIf(!pDstRGB, OMX_StsBadArgErr);
    armRetArgErrIf(!pSrcMCU[0], OMX_StsBadArgErr);
    armRetArgErrIf(!pSrcMCU[1], OMX_StsBadArgErr);
    armRetArgErrIf(!pSrcMCU[2], OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pSrcMCU[0]), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pSrcMCU[1]), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pSrcMCU[2]), OMX_StsBadArgErr);
    armRetArgErrIf(((dstStep > (-2 * JPEG_MCU_PIX_WIDTH_420)) && (dstStep < (2 * JPEG_MCU_PIX_WIDTH_420))), OMX_StsBadArgErr);

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
    pSrcY2  = pSrcMCU[0] + JPEG_MCU_PIX_WIDTH_420;
    pSrcCb  = pSrcMCU[1];
    pSrcCr  = pSrcMCU[2];
    
    for(i = 0; i < convHeight/2; i++)
    {
        for(j = 0; j < convWidth; j += 2)
        {
            Ydata       = *pSrcY++;
            Ydata2      = *pSrcY++;
            Ydata3      = *pSrcY2++;
            Ydata4      = *pSrcY2++;
            Udata       = *pSrcCb++;
            Vdata       = *pSrcCr++;
            
            armIPCS_ComputeRFromYUV_JPEG(Ydata, Udata, Vdata, &Rdata);
            armIPCS_ComputeGFromYUV_JPEG(Ydata, Udata, Vdata, &Gdata);
            armIPCS_ComputeBFromYUV_JPEG(Ydata, Udata, Vdata, &Bdata);
            
            armIPCS_ComputeRFromYUV_JPEG(Ydata2, Udata, Vdata, &Rdata2);
            armIPCS_ComputeGFromYUV_JPEG(Ydata2, Udata, Vdata, &Gdata2);
            armIPCS_ComputeBFromYUV_JPEG(Ydata2, Udata, Vdata, &Bdata2);
            
            armIPCS_ComputeRFromYUV_JPEG(Ydata3, Udata, Vdata, &Rdata3);
            armIPCS_ComputeGFromYUV_JPEG(Ydata3, Udata, Vdata, &Gdata3);
            armIPCS_ComputeBFromYUV_JPEG(Ydata3, Udata, Vdata, &Bdata3);
            
            armIPCS_ComputeRFromYUV_JPEG(Ydata4, Udata, Vdata, &Rdata4);
            armIPCS_ComputeGFromYUV_JPEG(Ydata4, Udata, Vdata, &Gdata4);
            armIPCS_ComputeBFromYUV_JPEG(Ydata4, Udata, Vdata, &Bdata4);
            
            pDstRGB[j]      = (OMX_U16)armIPCS_PackToRGB565(Rdata,  Gdata,  Bdata);
            pDstRGB[j+1]    = (OMX_U16)armIPCS_PackToRGB565(Rdata2, Gdata2, Bdata2);
            pDstRGB2[j]     = (OMX_U16)armIPCS_PackToRGB565(Rdata3, Gdata3, Bdata3);
            pDstRGB2[j+1]   = (OMX_U16)armIPCS_PackToRGB565(Rdata4, Gdata4, Bdata4);
        }
        
        pDstRGB     += dstStep;
        pDstRGB2    += dstStep;
        pSrcY       += JPEG_MCU_PIX_WIDTH_420;
        pSrcY2      += JPEG_MCU_PIX_WIDTH_420;
    }
    return OMX_StsNoErr;
}

/* End of file */
