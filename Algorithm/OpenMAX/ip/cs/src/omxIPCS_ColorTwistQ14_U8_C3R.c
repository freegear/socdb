/**
 *
 *  omxIPCS_ColorTwistQ14_U8_C3R.c
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
 * Description  : Colour Conversion Routine - Colour Twist in fixed point.
 *                The source is in three-channel format and pixel domain, and
 *                the destination in three-channel format and pixel domain.
 *
 */

#include "omxtypes.h"
#include "omxIP.h"
#include "armCOMM.h"

OMXResult omxIPCS_ColorTwistQ14_U8_C3R(
        const OMX_U8* pSrc,
        OMX_INT srcStep,
        OMX_U8* pDst,
        OMX_INT dstStep,
        OMXSize roiSize,
        const OMX_S32 twistQ14[3][4]
       )
{
    OMX_INT convWidth   = 3 * roiSize.width; /* convWidth is the bytes to read */
    OMX_INT convHeight  = roiSize.height;
    OMX_U8  pix0, pix1, pix2;
    OMX_U16 round = 1 << 13;
    OMX_INT i, j;

    OMX_S32 Ct00    = twistQ14[0][0];
    OMX_S32 Ct01    = twistQ14[0][1];
    OMX_S32 Ct02    = twistQ14[0][2];
    OMX_S32 Ct03    = twistQ14[0][3];
    OMX_S32 Ct10    = twistQ14[1][0];
    OMX_S32 Ct11    = twistQ14[1][1];
    OMX_S32 Ct12    = twistQ14[1][2];
    OMX_S32 Ct13    = twistQ14[1][3];
    OMX_S32 Ct20    = twistQ14[2][0];
    OMX_S32 Ct21    = twistQ14[2][1];
    OMX_S32 Ct22    = twistQ14[2][2];
    OMX_S32 Ct23    = twistQ14[2][3];
    
    armRetArgErrIf(!pSrc, OMX_StsNullPtrErr);
    armRetArgErrIf(!pDst, OMX_StsNullPtrErr);
    armRetArgErrIf(srcStep < 0, OMX_StsStepErr);
    armRetArgErrIf(dstStep < 0, OMX_StsStepErr);
    armRetArgErrIf(roiSize.width <= 0, OMX_StsSizeErr);
    armRetArgErrIf(roiSize.height <= 0, OMX_StsSizeErr);

    /*
    -------------------------------------------------------------------------------------------------
    Colour Twist Matrix (in Q1.14 format) and Equations
    
    Q17.14 Format: -bit[31]*pow(2,17) + Summation from 0 to 16 of {bit[14+i]*pow(2,i)}
                                      + Summation from 1 to 14 of {bit[14-i]*pow(2,-i)}
    This has one sign bit, 17 integer bits and 14 binary point bits ==> Totally 32 bits.
    
                |Ct00 Ct01 Ct02 Ct03|
    TwistQ14  = |Ct10 Ct11 Ct12 Ct13|
                |Ct20 Ct21 Ct22 Ct23|
    
    newPix0 = (Ct00*pix0 + Ct01*pix1 + Ct02*pix2 + Ct03 + Rounding) / (1<<14)
    newPix1 = (Ct10*pix0 + Ct11*pix1 + Ct12*pix2 + Ct13 + Rounding) / (1<<14)
    newPix2 = (Ct20*pix0 + Ct21*pix1 + Ct22*pix2 + Ct23 + Rounding) / (1<<14)
    
    Since the newPix values have to be eventually saturated between OMX_MIN_U8 and OMX_MAX_U8,
    the division by (1<<14) could as well be replaced with a right-shift by 14.

    -------------------------------------------------------------------------------------------------
    */
    
    for(i=0; i<convHeight; i++, pSrc+=srcStep, pDst+=dstStep)
    {
        for(j=0; j<convWidth; j+=3)
        {
            pix0        = pSrc[j];
            pix1        = pSrc[j+1];
            pix2        = pSrc[j+2];
            
            pDst[j]     = (OMX_U8)armClip(OMX_MIN_U8, OMX_MAX_U8, (pix0*Ct00 + pix1*Ct01 + pix2*Ct02 + Ct03 + round) >> 14);
            pDst[j+1]   = (OMX_U8)armClip(OMX_MIN_U8, OMX_MAX_U8, (pix0*Ct10 + pix1*Ct11 + pix2*Ct12 + Ct13 + round) >> 14);
            pDst[j+2]   = (OMX_U8)armClip(OMX_MIN_U8, OMX_MAX_U8, (pix0*Ct20 + pix1*Ct21 + pix2*Ct22 + Ct23 + round) >> 14);
        }
    }
    return OMX_StsNoErr;
}

/* End of file */
