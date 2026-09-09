/**
 *
 *  armIPCS_ComputeColourComponents.c
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
 * Description  : Contains functions that compute individual components of YUV/RGB.
 */

#include "omxtypes.h"
#include "armIP.h"

/**
 * Functions: armIPCS_ComputeYFromRGB_JPEG, armIPCS_ComputeUFromRGB_JPEG, armIPCS_ComputeVFromRGB_JPEG
 *
 * Description:
 * With input data (R,G,B) belonging to [0, 255] and output data (Y,U,V) 
 * expected in [-128, 127], CC equations in JPEG domain would be - 
 * Y =  0.29900*R  + 0.58700*G  + 0.11400*B - 128
 * U = -0.16874*R  - 0.33126*G  + 0.50000*B
 * V =  0.50000*R  - 0.41869*G  - 0.08131*B
 * The pixels are converted from float to S16, taking care of rounding errors
 * and also clipped to the range [-128, 127].
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
 
OMXResult armIPCS_ComputeYFromRGB_JPEG(OMX_F32 Rdata, OMX_F32 Gdata, OMX_F32 Bdata, OMX_S16 *pYdata)
{
    OMX_S16 tempPix;
    armRetArgErrIf(!pYdata, OMX_StsNullPtrErr);
    
    tempPix = armRoundFloatToS16(0.29900*Rdata + 0.58700*Gdata + 0.11400*Bdata - 128);
    *pYdata = (OMX_S16)armClip(OMX_MIN_S8, OMX_MAX_S8, tempPix);
    
    return OMX_StsNoErr;
}

OMXResult armIPCS_ComputeUFromRGB_JPEG(OMX_F32 Rdata, OMX_F32 Gdata, OMX_F32 Bdata, OMX_S16 *pUdata)
{
    OMX_S16 tempPix;
    armRetArgErrIf(!pUdata, OMX_StsNullPtrErr);
    
    tempPix = armRoundFloatToS16(-0.16874*Rdata - 0.33126*Gdata + 0.50000*Bdata);
    *pUdata = (OMX_S16)armClip(OMX_MIN_S8, OMX_MAX_S8, tempPix);
    
    return OMX_StsNoErr;
}

OMXResult armIPCS_ComputeVFromRGB_JPEG(OMX_F32 Rdata, OMX_F32 Gdata, OMX_F32 Bdata, OMX_S16 *pVdata)
{
    OMX_S16 tempPix;
    armRetArgErrIf(!pVdata, OMX_StsNullPtrErr);
    
    tempPix = armRoundFloatToS16(0.50000*Rdata - 0.41869*Gdata - 0.08131*Bdata);
    *pVdata = (OMX_S16)armClip(OMX_MIN_S8, OMX_MAX_S8, tempPix);
    
    return OMX_StsNoErr;
}


/**
 * Functions: armIPCS_ComputeRFromYUV_JPEG, armIPCS_ComputeGFromYUV_JPEG, armIPCS_ComputeBFromYUV_JPEG
 *
 * Description:
 * With input data (Y, Cb, Cr) belonging to [-128, 127] and output data (R, G, B) 
 * belonging to [0, 255], colour conversion equations in the JPEG domain would be - 
 * R = (Y + 128) + 1.40200 * Cr
 * G = (Y + 128) - 0.34414 * Cb - 0.71414 * Cr
 * B = (Y + 128) + 1.77200 * Cb
 * The Colour Conversion is followed by a float to S16 type-conversion, taking care 
 * of rounding error and then a clipping to the final range [0, 255].
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
 
OMXResult armIPCS_ComputeRFromYUV_JPEG(OMX_F32 Ydata, OMX_F32 Udata, OMX_F32 Vdata, OMX_U8 *pRdata)
{
    OMX_S16 tempPix;
    armRetArgErrIf(!pRdata, OMX_StsNullPtrErr);
    
    tempPix = armRoundFloatToS16(Ydata + 128 + 1.40200 * Vdata + 0 * Udata);
    *pRdata = (OMX_U8)armClip(OMX_MIN_U8, OMX_MAX_U8, tempPix);
    
    return OMX_StsNoErr;
}

OMXResult armIPCS_ComputeGFromYUV_JPEG(OMX_F32 Ydata, OMX_F32 Udata, OMX_F32 Vdata, OMX_U8 *pGdata)
{
    OMX_S16 tempPix;
    armRetArgErrIf(!pGdata, OMX_StsNullPtrErr);
    
    tempPix = armRoundFloatToS16(Ydata + 128 - 0.34414 * Udata - 0.71414 * Vdata);
    *pGdata = (OMX_U8)armClip(OMX_MIN_U8, OMX_MAX_U8, tempPix);
    
    return OMX_StsNoErr;
}

OMXResult armIPCS_ComputeBFromYUV_JPEG(OMX_F32 Ydata, OMX_F32 Udata, OMX_F32 Vdata, OMX_U8 *pBdata)
{
    OMX_S16 tempPix;
    armRetArgErrIf(!pBdata, OMX_StsNullPtrErr);
    
    tempPix = armRoundFloatToS16(Ydata + 128 + 1.77200 * Udata + 0 * Vdata);
    *pBdata = (OMX_U8)armClip(OMX_MIN_U8, OMX_MAX_U8, tempPix);
    
    return OMX_StsNoErr;
}

/**
 * Functions: armIPCS_ComputeRFromYUV_Raw, armIPCS_ComputeGFromYUV_Raw, armIPCS_ComputeBFromYUV_Raw
 *
 * Description:
 * With input data (Y, U, V) and output data (R, G, B) belonging to [0, 255], 
 * colour conversion equations in the Raw Image Processing domain would be - 
 * R = 1.164(Y-16) + 1.596(V-128)
 * G = 1.164(Y-16) - 0.813(V-128) - 0.391(U-128)
 * B = 1.164(Y-16) + 2.018(U-128)
 * The Colour Conversion is followed by a float to S16 type-conversion, taking care 
 * of rounding error and then a clipping to the final range [0, 255].
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
 
OMXResult armIPCS_ComputeRFromYUV_Raw(OMX_F32 Ydata, OMX_F32 Udata, OMX_F32 Vdata, OMX_U8 *pRdata)
{
    OMX_S16 tempPix;
    armRetArgErrIf(!pRdata, OMX_StsNullPtrErr);
    
    tempPix = armRoundFloatToS16(1.164*(Ydata-16) + 1.596*(Vdata-128) + 0 * (Udata-128));
    *pRdata = (OMX_U8)armClip(OMX_MIN_U8, OMX_MAX_U8, tempPix);
    
    return OMX_StsNoErr;
}

OMXResult armIPCS_ComputeGFromYUV_Raw(OMX_F32 Ydata, OMX_F32 Udata, OMX_F32 Vdata, OMX_U8 *pGdata)
{
    OMX_S16 tempPix;
    armRetArgErrIf(!pGdata, OMX_StsNullPtrErr);
    
    tempPix = armRoundFloatToS16(1.164*(Ydata-16) - 0.813*(Vdata-128) - 0.391*(Udata-128));
    *pGdata = (OMX_U8)armClip(OMX_MIN_U8, OMX_MAX_U8, tempPix);
    
    return OMX_StsNoErr;
}

OMXResult armIPCS_ComputeBFromYUV_Raw(OMX_F32 Ydata, OMX_F32 Udata, OMX_F32 Vdata, OMX_U8 *pBdata)
{
    OMX_S16 tempPix;
    armRetArgErrIf(!pBdata, OMX_StsNullPtrErr);
    
    tempPix = armRoundFloatToS16(1.164*(Ydata-16) + 2.017*(Udata-128) + 0 * (Vdata-128));
    *pBdata = (OMX_U8)armClip(OMX_MIN_U8, OMX_MAX_U8, tempPix);
    
    return OMX_StsNoErr;
}

/* End of file */
