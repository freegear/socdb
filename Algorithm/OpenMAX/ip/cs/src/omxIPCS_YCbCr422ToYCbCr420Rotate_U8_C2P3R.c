/**
 *
 *  omxIPCS_YCbCr422ToYCbCr420Rotate_U8_C2P3R.c
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
 * Description  : Integrated Colour Space Conversion and Rotate Routine. The Source is
 *                in two-channel pixel domain format and the destination is in 
 *                three-channel, planar domain format.
 *                
 */

#include "omxIP.h"
#include "omxtypes.h"
#include "armCOMM.h"
#include "armIP.h"

OMXResult omxIPCS_YCbCr422ToYCbCr420Rotate_U8_C2P3R(
        const OMX_U8 *pSrc,
        OMX_INT srcStep,
        OMX_U8 *pDst[3],
        OMX_INT dstStep[3],
        OMXSize roiSize,
        OMXIPRotation rotation
       )
{
    const OMX_U8 *pSrcRef, *pSrcRef2;
    OMX_INT chroma, chromaOffset, chromaOffsetRev, i, j;
    OMX_INT inWidthYUV, outWidthY, outHeightY, outWidthUV, outHeightUV;
    OMX_U8  *pDstRef;
    
#if ARM_IPCS_INTERP_BILINEAR
    OMX_S16 interpPix;
#endif

    armRetArgErrIf(!pSrc, OMX_StsBadArgErr);
    armRetArgErrIf(!pDst, OMX_StsBadArgErr);
    armRetArgErrIf(!pDst[0], OMX_StsBadArgErr);
    armRetArgErrIf(!pDst[1], OMX_StsBadArgErr);
    armRetArgErrIf(!pDst[2], OMX_StsBadArgErr);
    armRetArgErrIf(!dstStep, OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pSrc), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pDst[0]), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs4ByteAligned(pDst[1]), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs4ByteAligned(pDst[2]), OMX_StsBadArgErr);
    armRetArgErrIf(srcStep < 1, OMX_StsBadArgErr);
    armRetArgErrIf(dstStep[0] < 1, OMX_StsBadArgErr);
    armRetArgErrIf(dstStep[1] < 1, OMX_StsBadArgErr);
    armRetArgErrIf(dstStep[2] < 1, OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(srcStep), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(dstStep[0]), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs4ByteAligned(dstStep[1]), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs4ByteAligned(dstStep[2]), OMX_StsBadArgErr);
    armRetArgErrIf(roiSize.width > srcStep/2, OMX_StsBadArgErr);
    armRetArgErrIf(roiSize.width > dstStep[0], OMX_StsBadArgErr);
    armRetArgErrIf(roiSize.width > 2*dstStep[1], OMX_StsBadArgErr);
    armRetArgErrIf(roiSize.width > 2*dstStep[2], OMX_StsBadArgErr);
    armRetArgErrIf(roiSize.width < 8, OMX_StsBadArgErr);
    armRetArgErrIf(roiSize.height < 8, OMX_StsBadArgErr);
    armRetArgErrIf((rotation != OMX_IP_ROTATE180) &&
                   (rotation != OMX_IP_ROTATE90L) &&
                   (rotation != OMX_IP_ROTATE90R) &&
                   (rotation != OMX_IP_DISABLE), OMX_StsBadArgErr);
    
    roiSize.height  = (roiSize.height >> 3) << 3;
    roiSize.width   = (roiSize.width >> 3) << 3;
    
    inWidthYUV      = roiSize.width * 2;
    outHeightY      = roiSize.height;
    outWidthY       = roiSize.width;
    outHeightUV     = roiSize.height >> 1;
    outWidthUV      = roiSize.width >> 1;

    /*
    ----------------------------------------------------------------------------------
    The conversion from Colour Space YCbCr422 to YCbCr420 in planar domain is easier
    as Y remains unchanged and it is a simple case of interpolation for Cb and Cr 
    planes. This function supports two interpolation methods (Not at the API level, 
    but internally) - namely Nearest Neighbour and Bilinear, by setting a static 
    global variable.
    
    The Rotation operation if combined with interpolation, becomes easier to carry
    out as we'll not have to do it in-place. The formulae for rotation by 
    180 is: OutPix(x,y) = InPix(width-x,height-y),
    90R is: OutPix(y,x) = InPix(width-x,y) and 
    90L is: OutPix(y,x) = InPix(x,height-y).
    
    For each type of rotation, the Luma plane is separately handled but the two 
    Chroma planes (having similar characteristics), are handled together in a loop.
    ---------------------------------------------------------------------------------
    */

    if(rotation == OMX_IP_ROTATE90R)
    {
        pSrcRef = pSrc;
        pDstRef = pDst[0] + outWidthY - 1;
        for(i = 0; i < outHeightY; i++)
        {
            for(j = 0; j < outWidthY; j++)
            {
                pDstRef[dstStep[0] * j] = pSrcRef[2 * j];
            }
            pSrcRef += srcStep;
            pDstRef--;
        }
        
        for(chroma = 1; chroma <= 2; chroma++)
        {
            chromaOffset    = (chroma == 1) ? 1 : 3;
            pSrcRef         = pSrc + chromaOffset;
            pSrcRef2        = pSrc + chromaOffset + srcStep;
            pDstRef         = pDst[chroma] + outHeightUV - 1;
            
            for(i = 0; i < outHeightUV; i++)
            {
                for(j = 0; j < outWidthUV; j++)
                {
#if ARM_IPCS_INTERP_NEAREST
                    pDstRef[dstStep[chroma] * j] = pSrcRef[4 * j];
#elif ARM_IPCS_INTERP_BILINEAR
                    interpPix = armRoundFloatToS16(((OMX_F32)pSrcRef[4 * j] + (OMX_F32)pSrcRef2[4 * j]) / 2);
                    pDstRef[dstStep[chroma] * j] = armClip(OMX_MIN_U8, OMX_MAX_U8, interpPix);
#endif
                }
                pSrcRef  += 2*srcStep;
                pSrcRef2 += 2*srcStep;
                pDstRef--;
            }
        }
    }

    else if(rotation == OMX_IP_ROTATE90L)
    {
        pSrcRef = pSrc;
        pDstRef = pDst[0];
        for(i = 0; i < outHeightY; i++)
        {
            for(j = 0; j < outWidthY; j++)
            {
                pDstRef[dstStep[0] * j] = pSrcRef[inWidthYUV - 2 - (2 * j)];
            }
            pSrcRef += srcStep;
            pDstRef++;
        }
        
        for(chroma = 1; chroma <= 2; chroma++)
        {
            chromaOffsetRev = (chroma == 1) ? 3 : 1;
            pSrcRef         = pSrc;
            pSrcRef2        = pSrc + srcStep;
            pDstRef         = pDst[chroma];
            
            for(i = 0; i < outHeightUV; i++)
            {
                for(j = 0; j < outWidthUV; j++)
                {
#if ARM_IPCS_INTERP_NEAREST
                    pDstRef[dstStep[chroma] * j] = pSrcRef[inWidthYUV - chromaOffsetRev - (4 * j)];
#elif ARM_IPCS_INTERP_BILINEAR 
                    interpPix = armRoundFloatToS16(((OMX_F32)pSrcRef[inWidthYUV - chromaOffsetRev - (4 * j)] + 
                                                       (OMX_F32)pSrcRef2[inWidthYUV - chromaOffsetRev - (4 * j)]) / 2);
                    pDstRef[dstStep[chroma] * j] = armClip(OMX_MIN_U8, OMX_MAX_U8, interpPix);
#endif
                }
                pSrcRef  += 2*srcStep;
                pSrcRef2 += 2*srcStep;
                pDstRef++;
            }
        }
    }
    
    else if(rotation == OMX_IP_ROTATE180)
    {
        pSrcRef = pSrc;
        pDstRef = pDst[0] + (outHeightY-1) * dstStep[0];
        for(i = 0; i < outHeightY; i++)
        {
            for(j = 0; j < outWidthY; j++)
            {
                pDstRef[outWidthY - j - 1] = pSrcRef[2 * j];
            }
            pSrcRef += srcStep;
            pDstRef -= dstStep[0];
        }
        
        for(chroma = 1; chroma <= 2; chroma++)
        {
            chromaOffset    = (chroma == 1) ? 1 : 3;
            pSrcRef         = pSrc + chromaOffset;
            pSrcRef2        = pSrc + chromaOffset + srcStep;
            pDstRef         = pDst[chroma] + (outHeightUV-1) * dstStep[chroma];
            
            for(i = 0; i < outHeightUV; i++)
            {
                for(j = 0; j < outWidthUV; j++)
                {
#if ARM_IPCS_INTERP_NEAREST
                    pDstRef[outWidthUV - j - 1] = pSrcRef[4 * j];
#elif ARM_IPCS_INTERP_BILINEAR
                    interpPix = armRoundFloatToS16(((OMX_F32)pSrcRef[4 * j] + (OMX_F32)pSrcRef2[4 * j]) / 2);
                    pDstRef[outWidthUV - j - 1] = armClip(OMX_MIN_U8, OMX_MAX_U8, interpPix);
#endif
                }
                pSrcRef  += 2*srcStep;
                pSrcRef2 += 2*srcStep;
                pDstRef  -= dstStep[chroma];
            }
        }
    }
    
    else if(rotation == OMX_IP_DISABLE)
    {
        pSrcRef = pSrc;
        pDstRef = pDst[0];
        for(i = 0; i < outHeightY; i++)
        {
            for(j = 0; j < outWidthY; j++)
            {
                pDstRef[j] = pSrcRef[j * 2];
            }
            pSrcRef += srcStep;
            pDstRef += dstStep[0];
        }
        
        for(chroma = 1; chroma <= 2; chroma++)
        {
            chromaOffset    = (chroma == 1) ? 1 : 3;
            pSrcRef         = pSrc + chromaOffset;
            pSrcRef2        = pSrc + chromaOffset + srcStep;
            pDstRef         = pDst[chroma];
            
            for(i = 0; i < outHeightUV; i++)
            {
                for(j = 0; j < outWidthUV; j++)
                {
#if ARM_IPCS_INTERP_NEAREST
                    pDstRef[j] = pSrcRef[4 * j];
#elif ARM_IPCS_INTERP_BILINEAR
                    interpPix  = armRoundFloatToS16(((OMX_F32)pSrcRef[4 * j] + (OMX_F32)pSrcRef2[4 * j]) / 2);
                    pDstRef[j] = armClip(OMX_MIN_U8, OMX_MAX_U8, interpPix);
#endif
                }
                pSrcRef  += 2*srcStep;
                pSrcRef2 += 2*srcStep;
                pDstRef  += dstStep[chroma];
            }
        }
    }
    
    return OMX_StsNoErr;
}

/* End of file */
