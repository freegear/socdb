/* ----------------------------------------------------------------
 *
 *  omxVCM4P10_PredictIntra_16x16.c
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
 * H.264 16x16 intra prediction module
 * 
 */
 
#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"
#include "armVC.h"

/**
 * Function: omxVCM4P10_PredictIntra_16x16
 *
 * Description: Perform Intra_16x16 prediction for luma samples. If the upper-right block is not available, then duplication work should be handled inside the function. Users need not define them outside.
 *
 * Remarks:
 *
 * Parameters:
 * [in] pSrcLeft - Pointer to the buffer of 16 left  pixel values: p[x, y] (x = -1, y = 0..15)
 *                 Must be 16-byte aligned.
 * [in] pSrcAbove - Pointer to the buffer of 16 above  pixel values: p[x,y] (x = 0..15, y= -1)
 *                 Must be 16-byte aligned.
 * [in] pSrcAboveLeft - Pointer to the above left  pixel value: p[x,y] (x = -1, y = -1)
 * [in] leftStep - Step of left coefficient buffer. Must be multiple of 16.
 * [in] dstStep - Step of the destination buffer. Must be multiple of 16.
 * [in] predMode - Intra_16x16 prediction mode, please refer to section 3.4.1.
 * [in] availability - Neighboring 16x16 MB availability flag. Refer to section 3.4.4.
 * [out] pDst - Pointer to the destination buffer. Must be 16-byte aligned.
 *
 * Return Value:
 * if the function runs without error, it returns OMX_StsNoErr.
 * If one of the following cases occurs, the function returns OMX_StsBadArgErr:
 *	 pDst is NULL or is not 16-byte aligned.
 *	 dstStep < 16 or is not multiple of 16.
 *	 predMode is not in the valid range of enumeration OMXVCM4P10Intra16x16PredMode
 *	 predMode is OMX_VC_16X16_VERT, but availability doesn't set OMX_VC_UPPER indicating
 *   p[x,-1] (x = 0..15) is not available.
 *	 predMode is OMX_VC_16X16_HOR, but availability doesn't set OMX_VC_LEFT indicating
 *   p[-1,y] (y = 0..15) is not available.
 *	 predMode is OMX_VC_16X16_PLANE, but availability doesn't set OMX_VC_UPPER_LEFT or
 *   OMX_VC_UPPER or OMX_VC_LEFT indicating p[x,-1](x = 0..15), or p[-1,y] (y = 0..15),
 *   or p[-1,-1] is not available.
 *	 availability sets OMX_VC_UPPER, but pSrcAbove is NULL.
 *	 availability sets OMX_VC_LEFT, but pSrcLeft is NULL.
 *	 availability sets OMX_VC_UPPER_LEFT, but pSrcAboveLeft is NULL.
 *
 */
OMXResult omxVCM4P10_PredictIntra_16x16(
    const OMX_U8* pSrcLeft, 
    const OMX_U8 *pSrcAbove, 
    const OMX_U8 *pSrcAboveLeft, 
    OMX_U8* pDst, 
    OMX_INT leftStep, 
    OMX_INT dstStep, 
    OMXVCM4P10Intra16x16PredMode predMode, 
    OMX_S32 availability)
{
    int x,y,Sum,Count;
    int H,V,a,b,c;

    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(dstStep < 16,  OMX_StsBadArgErr);
    armRetArgErrIf((availability & OMX_VC_UPPER)      && pSrcAbove     == NULL, OMX_StsBadArgErr);
    armRetArgErrIf((availability & OMX_VC_LEFT )      && pSrcLeft      == NULL, OMX_StsBadArgErr);
    armRetArgErrIf((availability & OMX_VC_UPPER_LEFT) && pSrcAboveLeft == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_16X16_VERT  && !(availability & OMX_VC_UPPER),      OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_16X16_HOR   && !(availability & OMX_VC_LEFT),       OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_16X16_PLANE && !(availability & OMX_VC_UPPER),      OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_16X16_PLANE && !(availability & OMX_VC_UPPER_LEFT), OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_16X16_PLANE && !(availability & OMX_VC_LEFT),       OMX_StsBadArgErr);
    armRetArgErrIf((unsigned)predMode > OMX_VC_16X16_PLANE,  OMX_StsBadArgErr);

    switch (predMode)
    {
    case OMX_VC_16X16_VERT:
        for (y=0; y<16; y++)
        {
            for (x=0; x<16; x++)
            {
                pDst[y*dstStep+x] = pSrcAbove[x];
            }
        }
        break;

    case OMX_VC_16X16_HOR:
        for (y=0; y<16; y++)
        {
            for (x=0; x<16; x++)
            {
                pDst[y*dstStep+x] = pSrcLeft[y*leftStep];
            }
        }
        break;

    case OMX_VC_16X16_DC:
        /* This can always be used even if no blocks available */
        Sum = 0;
        Count = 0;
        if (availability & OMX_VC_LEFT)
        {
            for (y=0; y<16; y++)
            {
                Sum += pSrcLeft[y*leftStep];
            }
            Count++;
        }
        if (availability & OMX_VC_UPPER)
        {
            for (x=0; x<16; x++)
            {
                Sum += pSrcAbove[x];
            }
            Count++;
        }
        if (Count==0)
        {
            Sum = 128;
        }
        else if (Count==1)
        {
            Sum = (Sum + 8) >> 4;
        }
        else /* Count = 2 */
        {
            Sum = (Sum + 16) >> 5;
        }
        for (y=0; y<16; y++)
        {
            for (x=0; x<16; x++)
            {
                pDst[y*dstStep+x] = (OMX_U8)Sum;
            }
        }
        break;

    case OMX_VC_16X16_PLANE:
        H = 8*(pSrcAbove[15] - pSrcAboveLeft[0]);
        for (x=6; x>=0; x--)
        {
            H += (x+1)*(pSrcAbove[8+x] - pSrcAbove[6-x]);
        }
        V = 8*(pSrcLeft[15*leftStep] - pSrcAboveLeft[0]);
        for (y=6; y>=0; y--)
        {
            V += (y+1)*(pSrcLeft[(8+y)*leftStep] - pSrcLeft[(6-y)*leftStep]);
        }
        a = 16*(pSrcAbove[15] + pSrcLeft[15*leftStep]);
        b = (5*H+32)>>6;
        c = (5*V+32)>>6;
        for (y=0; y<16; y++)
        {
            for (x=0; x<16; x++)
            {
                Sum = (a + b*(x-7) + c*(y-7) + 16)>>5;
                pDst[y*dstStep+x] = (OMX_U8)armClip(0,255,Sum);
            }
        }
        break;
    }

    return OMX_StsNoErr;
}

