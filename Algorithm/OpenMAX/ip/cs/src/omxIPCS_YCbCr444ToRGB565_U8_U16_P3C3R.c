/**
 *
 *  omxIPCS_YCbCr444ToRGB565_U8_U16_P3C3R.c
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
 * Description  : Colour Conversion Routine - YUV444 to RGB565 in floating point.
 *                The source is in three-channel format and planar domain, and
 *                the destination in three-channel format and pixel domain.
 *
 */

#include "omxtypes.h"
#include "armCOMM.h"
#include "armIP.h"

OMXResult omxIPCS_YCbCr444ToRGB565_U8_U16_P3C3R(
        const OMX_U8 *pSrc[3],
        OMX_INT srcStep,
        OMX_U16 *pDst,
        OMX_INT dstStep,
        OMXSize roiSize
       )
{
    OMX_INT convWidth   = roiSize.width; /* convWidth is the bytes to read */
    OMX_INT convHeight  = roiSize.height;
    OMX_U8  Ydata, Udata, Vdata, Rdata, Gdata, Bdata;
    OMX_U16 *RGBptr;
    const OMX_U8 *Yptr, *Uptr, *Vptr;
    OMX_INT i, j;
    
    dstStep >>= 1;   /* dstStep is converted to half-word size length */
    armRetArgErrIf(!pSrc, OMX_StsNullPtrErr);
    armRetArgErrIf(!pDst, OMX_StsNullPtrErr);
    armRetArgErrIf(!pSrc[0], OMX_StsNullPtrErr);
    armRetArgErrIf(!pSrc[1], OMX_StsNullPtrErr);
    armRetArgErrIf(!pSrc[2], OMX_StsNullPtrErr);
    armRetArgErrIf(srcStep < 0, OMX_StsStepErr);
    armRetArgErrIf(dstStep < 0, OMX_StsStepErr);
    armRetArgErrIf(roiSize.width <= 0, OMX_StsSizeErr);
    armRetArgErrIf(roiSize.height <= 0, OMX_StsSizeErr);

    /*
    ------------------------------------------------------------------------
    Colour conversion equations
    R = 1.164(Y-16) + 1.596(Cr-128)
    G = 1.164(Y-16) - 0.813(Cr-128) - 0.391(Cb-128)
    B = 1.164(Y-16) + 2.017(Cb-128)
    
    The armIPCS_ComputeXFromYUV_Raw() functions apart from doing the colour 
    conversion, takes care of type-conversion from intermediate float values
    and clipping to U8, taking care of rounding errors. Then the packing of
    R,G and B to the RGB565 format is done by macro armIPCS_PackToRGB565().
    ------------------------------------------------------------------------
    */
    
    Yptr = pSrc[0];
    Uptr = pSrc[1];
    Vptr = pSrc[2];
    
    for(i = 0; i < convHeight; i++, Yptr += srcStep, Uptr += srcStep, Vptr += srcStep, pDst += dstStep)
    {
        RGBptr = pDst;
        for(j = 0; j < convWidth; j++)
        {
            Ydata = Yptr[j];
            Udata = Uptr[j];
            Vdata = Vptr[j];
            
            armIPCS_ComputeRFromYUV_Raw(Ydata, Udata, Vdata, &Rdata);
            armIPCS_ComputeGFromYUV_Raw(Ydata, Udata, Vdata, &Gdata);
            armIPCS_ComputeBFromYUV_Raw(Ydata, Udata, Vdata, &Bdata);
            
            *RGBptr++ = (OMX_U16)armIPCS_PackToRGB565(Rdata, Gdata, Bdata);
        }
    }
    
    return OMX_StsNoErr;
}

/* End of file */
