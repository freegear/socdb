/**
 *
 *  armIPCS_InterpPixel_Bilinear.c
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
 * Description  : Contains bilinear interpolation function.
 *
 */

#include "omxtypes.h"
#include "armIP.h"

/**
 * Functions: armIPCS_InterpPixel_Bilinear
 *
 * Description:
 * This function computes the Bilinear interpolated pixel, by taking
 * the buffer and its step, top-left neighbour pixel coordinates and
 * the offset of the interpolated pixel from this top-left pixel as 
 * input parameters
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
 
OMXResult armIPCS_InterpPixel_Bilinear(
        const OMX_U8 *pBuf,     /* Pointer to the Image Buffer */
        OMX_INT bufStep,        /* Offset in bytes between two rows */
        OMX_INT xPos,           /* x-coordinate of the nearest top-left pixel of the interpolated pixel */
        OMX_INT yPos,           /* y-coordinate of the nearest top-left pixel of the interpolated pixel */
        OMX_F32 xOff,           /* Distance along X, between interpolated and its nearest top-left pixel */
        OMX_F32 yOff,           /* Distance along Y, between interpolated and its nearest top-left pixel */
        OMX_U8  *pInterpPix     /* Pointer to return the interpolated pixel value */
       )
{
    OMX_F32 weight00, weight10, weight01, weight11;
    OMX_U8  pix00, pix10, pix01, pix11;
    OMX_U16 tempPix;
    
    armRetArgErrIf(!pBuf, OMX_StsNullPtrErr);
    
    weight00    = (1 - xOff) * (1 - yOff);
    weight10    = xOff * (1 - yOff);
    weight01    = yOff * (1 - xOff);
    weight11    = xOff * yOff;
    
    pix00       = pBuf[xPos + (yPos * bufStep)];
    pix10       = pBuf[xPos + 1 + (yPos * bufStep)];
    pix01       = pBuf[xPos + ((yPos + 1) * bufStep)];
    pix11       = pBuf[xPos + 1 + ((yPos + 1) * bufStep)];
    
    tempPix     = armRoundFloatToS16((pix00 * weight00) + (pix10 * weight10) + (pix01 * weight01) + (pix11 * weight11));
    *pInterpPix = (OMX_U8)armClip(OMX_MIN_U8, OMX_MAX_U8, tempPix);
    
    return OMX_StsNoErr;
}

/* End of file */
