/**
 *
 *  omxIPCS_YCbCr422ToRGB565_U8_U16_C2C3R.c
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
 * Description  : Colour Conversion Routine - YUV422 to RGB565 in floating point.
 *                The source is in two-channel format and pixel domain, and
 *                the destination in three-channel format and pixel domain.
 *
 */

#include "omxtypes.h"
#include "armCOMM.h"
#include "armIP.h"

OMXResult omxIPCS_YCbCr422ToRGB565_U8_U16_C2C3R(
        const OMX_U8 *pSrc,
        OMX_INT srcStep,
        OMX_U16 *pDst,
        OMX_INT dstStep,
        OMXSize roiSize
       )
{
    OMX_INT convWidth   = 2 * roiSize.width;  /* convWidth is the bytes to read */
    OMX_INT convHeight  = roiSize.height;
    OMX_U8  Y0data, Y1data, Udata, Vdata;
    OMX_U8  Rdata, Gdata, Bdata;
    OMX_U16 *RGBptr;
    OMX_INT i, j;
    
    dstStep >>= 1;   /* dstStep is converted to half-word size length */
    armRetArgErrIf(!pSrc, OMX_StsNullPtrErr);
    armRetArgErrIf(!pDst, OMX_StsNullPtrErr);
    armRetArgErrIf(srcStep < 0, OMX_StsStepErr);
    armRetArgErrIf(dstStep < 0, OMX_StsStepErr);
    armRetArgErrIf(roiSize.width <= 0, OMX_StsSizeErr);
    armRetArgErrIf(roiSize.height <= 0, OMX_StsSizeErr);

    /*
    ------------------------------------------------------------------------
    Colour conversion equations
    R = 1.164(Y-16) + 1.596(Cr-128)
    G = 1.164(Y-16) - 0.813(Cr-128) - 0.391(Cb-128)
    B = 1.164(Y-16) + 2.018(Cb-128)
    
    YUV422 FORMAT:  -----------------
                    |YUV|Y--|YUV|Y--|
                    -----------------
                    |YUV|Y--|YUV|Y--|
                    -----------------
                    |YUV|Y--|YUV|Y--|
                    -----------------
                    |YUV|Y--|YUV|Y--|
                    -----------------
    
    INTERLEAVED YUV422 DATA (Current input format) |YU|YV|YU|YV|...
    
    The intermediate pixel values are first converted from float to S16, 
    taking care of rounding errors and then saturated to U8.
    ------------------------------------------------------------------------
    */
    
    for(i=0; i<convHeight; i++, pSrc+=srcStep, pDst+=dstStep)
    {
        RGBptr = pDst;
        for(j=0; j<convWidth; j+=4)
        {
            Y0data = pSrc[j];
            Udata  = pSrc[j+1];
            Y1data = pSrc[j+2];
            Vdata  = pSrc[j+3];

            armIPCS_ComputeRFromYUV_Raw(Y0data, Udata, Vdata, &Rdata);
            armIPCS_ComputeGFromYUV_Raw(Y0data, Udata, Vdata, &Gdata);
            armIPCS_ComputeBFromYUV_Raw(Y0data, Udata, Vdata, &Bdata);
            
            *RGBptr++ = (OMX_U16)armIPCS_PackToRGB565(Rdata, Gdata, Bdata);
            
            armIPCS_ComputeRFromYUV_Raw(Y1data, Udata, Vdata, &Rdata);
            armIPCS_ComputeGFromYUV_Raw(Y1data, Udata, Vdata, &Gdata);
            armIPCS_ComputeBFromYUV_Raw(Y1data, Udata, Vdata, &Bdata);
            
            *RGBptr++ = (OMX_U16)armIPCS_PackToRGB565(Rdata, Gdata, Bdata);
        }
    }
    return OMX_StsNoErr;
}

/* End of file */
