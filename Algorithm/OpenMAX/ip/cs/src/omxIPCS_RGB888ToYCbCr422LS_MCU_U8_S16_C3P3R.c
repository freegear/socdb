/**
 *
 *  omxIPCS_RGB888ToYCbCr422LS_MCU_U8_S16_C3P3R.c
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
 * Description  : Colour Conversion Routine - Converts RGB888 to YUV422 in floating point.
 *                Source is in three channel, pixel domain and the destination would be in 
 *                three-channel planar format. Output is a JPEG MCU.
 *
 */

#include "omxtypes.h"
#include "armCOMM.h"
#include "armIP.h"

OMXResult omxIPCS_RGB888ToYCbCr422LS_MCU_U8_S16_C3P3R(
        const OMX_U8 *pSrc,
        OMX_INT srcStep,
        OMX_S16 * pDstMCU[3]
       )
{
    OMX_INT convWidth   = 3 * JPEG_MCU_PIX_WIDTH_422;
    OMX_INT convHeight  = JPEG_MCU_PIX_HEIGHT_422;
    OMX_S16 *pDstY, *pDstCb, *pDstCr;
    OMX_U8  Rdata, Gdata, Bdata, Rdata2, Gdata2, Bdata2;
    OMX_INT i, j;
       
    armRetArgErrIf(!pSrc, OMX_StsBadArgErr);
    armRetArgErrIf(!pDstMCU, OMX_StsBadArgErr);
    armRetArgErrIf(!pDstMCU[0], OMX_StsBadArgErr);
    armRetArgErrIf(!pDstMCU[1], OMX_StsBadArgErr);
    armRetArgErrIf(!pDstMCU[2], OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pDstMCU[0]), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pDstMCU[1]), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pDstMCU[2]), OMX_StsBadArgErr);
    armRetArgErrIf(((srcStep > (-3 * JPEG_MCU_PIX_WIDTH_422)) && (srcStep < (3 * JPEG_MCU_PIX_WIDTH_422))), OMX_StsBadArgErr);
    
    /*
    -----------------------------------------------------------------------------
    With input data (R, G, B) belonging to [0, 255] and output data (Y,Cb,Cr) 
    expected in [-128, 127], CC equations in JPEG domain would be - 
    Y  =  0.29900*R  + 0.58700*G  + 0.11400*B - 128
    Cb = -0.16874*R  - 0.33126*G  + 0.50000*B
    Cr =  0.50000*R  - 0.41869*G  - 0.08131*B
    
    The armComputeXFromRGB_JPEG() functions apart from doing the colour conversion, 
    takes care of type-conversion from intermediate float values and clipping to 
    S16, taking care of rounding errors.
    
    The cases of Nearest Neighbour interpolation and Bilinear interpolation 
    are separately handled.
    -----------------------------------------------------------------------------
    */
    
    pDstY   = pDstMCU[0];
    pDstCb  = pDstMCU[1];
    pDstCr  = pDstMCU[2];
    
    for(i = 0; i < convHeight; i++, pSrc += srcStep)
    {
        for(j = 0; j < convWidth; j += 6)
        {
            Bdata   = pSrc[j];
            Gdata   = pSrc[j+1];
            Rdata   = pSrc[j+2];
            Bdata2  = pSrc[j+3];
            Gdata2  = pSrc[j+4];
            Rdata2  = pSrc[j+5];

            armIPCS_ComputeYFromRGB_JPEG(Rdata,  Gdata,  Bdata,  pDstY++);
            armIPCS_ComputeYFromRGB_JPEG(Rdata2, Gdata2, Bdata2, pDstY++);            

#if ARM_IPCS_INTERP_NEAREST

            {
                armIPCS_ComputeUFromRGB_JPEG(Rdata, Gdata, Bdata, pDstCb++);
                armIPCS_ComputeVFromRGB_JPEG(Rdata, Gdata, Bdata, pDstCr++);
            }
            
#elif ARM_IPCS_INTERP_BILINEAR

            {
                OMX_F32 interpPixR = (Rdata + Rdata2) / (OMX_F32)4;
                OMX_F32 interpPixG = (Gdata + Gdata2) / (OMX_F32)4;
                OMX_F32 interpPixB = (Bdata + Bdata2) / (OMX_F32)4;
                
                armIPCS_ComputeUFromRGB_JPEG(interpPixR, interpPixG, interpPixB, pDstCb++);
                armIPCS_ComputeVFromRGB_JPEG(interpPixR, interpPixG, interpPixB, pDstCr++);
            }
#endif
        }
    }
    return OMX_StsNoErr;
}

/* End of file */
