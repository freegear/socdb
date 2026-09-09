/**
 *
 *  armIPCS_HelperRGB.c
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
 * Description  : Contains utility functions surrounding the RGB format.
 *
 */

#include "omxtypes.h"
#include "armIP.h"

/**
 * Functions: armIPCS_UnpackRGB565
 *
 * Description:
 * This function unpacks an RGB565 compressed image data into separate 
 * R, G and B components, by padding zeros in the lower order bits. 
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
 
OMXResult armIPCS_UnpackRGB565(OMX_U16 RGBdata, OMX_U8 *pRdata, OMX_U8 *pGdata, OMX_U8 *pBdata) 
{
    armRetArgErrIf(!pRdata || !pGdata || !pBdata, OMX_StsNullPtrErr);
    
    *pRdata = (OMX_U8)(((RGBdata) & 0x001F) << 3);
    *pGdata = (OMX_U8)(((RGBdata) & 0x07E0) >> 3);
    *pBdata = (OMX_U8)(((RGBdata) & 0xF800) >> 8);
    
    return OMX_StsNoErr;
}

/**
 * Function: armIPCS_RGBConvertAndPack
 *
 * Description:
 * This is a utility function used by omxIPCS_YCbCr42xRszCscRotRGB_U8_P3C3R(). It converts
 * a pixel from YCbCr representation to one of the RGB variants - RGB565, RGB555, RGB444, 
 * RGB888 based on the <colorConversion> parameter and stores the result in <pDstRGB>.
 *
 * Return Value:
 * OMXVoid
 */

OMXVoid armIPCS_RGBConvertAndPack(OMX_U8 Ydata, OMX_U8 Udata, OMX_U8 Vdata, OMXIPColorSpace colorConversion, void *pDst)
{
    OMX_U8  Rdata, Gdata, Bdata;
    OMX_U8  *p8DstRGB  = (OMX_U8 *)pDst;
    OMX_U16 *p16DstRGB = (OMX_U16 *)pDst;
    
    armIPCS_ComputeRFromYUV_Raw(Ydata, Udata, Vdata, &Rdata);
    armIPCS_ComputeGFromYUV_Raw(Ydata, Udata, Vdata, &Gdata);
    armIPCS_ComputeBFromYUV_Raw(Ydata, Udata, Vdata, &Bdata);
    
    switch(colorConversion)
    {
        case OMX_IP_RGB565: *p16DstRGB = armIPCS_PackToRGB565(Rdata, Gdata, Bdata);
                            break;
        case OMX_IP_RGB555: *p16DstRGB = armIPCS_PackToRGB555(Rdata, Gdata, Bdata);
                            break;
        case OMX_IP_RGB444: *p16DstRGB = armIPCS_PackToRGB444(Rdata, Gdata, Bdata);
                            break;
        case OMX_IP_RGB888: *p8DstRGB++ = Rdata;
                            *p8DstRGB++ = Gdata;
                            *p8DstRGB   = Bdata;
                            break;
        default:            break;
    }
}

/* End of file */
