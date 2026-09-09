/* ----------------------------------------------------------------
 *
 *  armVCM4P10_FwdTransformResidual4x4.c
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
 * H.264 transform module
 * 
 */
 
#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"
#include "armVC.h"
 
/*
 * Description:
 * Forward Transform Residual 4x4 Coefficients
 *
 * Parameters:
 * [in]  pSrc		Source 4x4 block
 * [out] pDst		Destination 4x4 block
 *
 */
void armVCM4P10_FwdTransformResidual4x4(OMX_S16* pDst, OMX_S16 *pSrc)
{
    int i;

    /* Transform rows */
    for (i=0; i<16; i+=4)
    {
        int d0 = pSrc[i+0];
        int d1 = pSrc[i+1];
        int d2 = pSrc[i+2];
        int d3 = pSrc[i+3];
        int e0 = d0 + d3;
        int e1 = d0 - d3;
        int e2 = d1 + d2;
        int e3 = d1 - d2;
        int f0 = e0 + e2;
        int f1 = (e1 << 1) + e3;
        int f2 = e0 - e2;
        int f3 = e1 - (e3 << 1);
        pDst[i+0] = (OMX_S16)f0;
        pDst[i+1] = (OMX_S16)f1;
        pDst[i+2] = (OMX_S16)f2;
        pDst[i+3] = (OMX_S16)f3;
    }

    /* Transform columns */
    for (i=0; i<4; i++)
    {
        int f0 = pDst[i+0];
        int f1 = pDst[i+4];
        int f2 = pDst[i+8];
        int f3 = pDst[i+12];
        int g0 = f0 + f3;
        int g1 = f0 - f3;
        int g2 = f1 + f2;
        int g3 = f1 - f2;
        int h0 = g0 + g2;
        int h1 = (g1 << 1) + g3;
        int h2 = g0 - g2;
        int h3 = g1 - (g3 << 1);
        pDst[i+0] = (OMX_S16) h0;
        pDst[i+4] = (OMX_S16) h1;
        pDst[i+8] = (OMX_S16) h2;
        pDst[i+12] = (OMX_S16) h3;
    }
}
