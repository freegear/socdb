/* ----------------------------------------------------------------
 *
 *  omxVCM4P10_PredictIntraChroma8x8.c
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
 * H.264 chroma 8x8 intra prediction module
 * 
 */
 
#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"
#include "armVC.h"

/*
 * Description:
 * Perform DC style intra prediction, upper block has priority
 *
 * Parameters:
 * [in]	pSrcLeft		Pointer to the buffer of 16 left coefficients:
 *								p[x, y] (x = -1, y = 0..3)
 * [in]	pSrcAbove		Pointer to the buffer of 16 above coefficients:
 *								p[x,y] (x = 0..3, y = -1)
 * [in]	leftStep		Step of left coefficient buffer
 * [in]	dstStep			Step of the destination buffer
 * [in]	availability	Neighboring 16x16 MB availability flag
 * [out]	pDst			Pointer to the destination buffer
 *
 * Return Value:
 * None
 */

static void armVCM4P10_PredictIntraDCUp4x4(
     const OMX_U8* pSrcLeft,
     const OMX_U8 *pSrcAbove,
     OMX_U8* pDst,
     OMX_INT leftStep,
     OMX_INT dstStep,
     OMX_S32 availability        
)
{
    int x, y, Sum=0, Count = 0;

    if (availability & OMX_VC_UPPER)
    {
        for (x=0; x<4; x++)
        {
            Sum += pSrcAbove[x];
        }
        Count++;
    }
    else if (availability & OMX_VC_LEFT)
    {
        for (y=0; y<4; y++)
        {
            Sum += pSrcLeft[y*leftStep];
        }
        Count++;
    }
    if (Count==0)
    {
        Sum = 128;
    }
    else
    {
        Sum = (Sum + 2) >> 2;
    }
    for (y=0; y<4; y++)
    {
        for (x=0; x<4; x++)
        {
            pDst[y*dstStep+x] = (OMX_U8)Sum;
        }
    }
}

/*
 * Description:
 * Perform DC style intra prediction, left block has priority
 *
 * Parameters:
 * [in]	pSrcLeft		Pointer to the buffer of 16 left coefficients:
 *								p[x, y] (x = -1, y = 0..3)
 * [in]	pSrcAbove		Pointer to the buffer of 16 above coefficients:
 *								p[x,y] (x = 0..3, y = -1)
 * [in]	leftStep		Step of left coefficient buffer
 * [in]	dstStep			Step of the destination buffer
 * [in]	availability	Neighboring 16x16 MB availability flag
 * [out]	pDst			Pointer to the destination buffer
 *
 * Return Value:
 * None
 */

static void armVCM4P10_PredictIntraDCLeft4x4(
     const OMX_U8* pSrcLeft,
     const OMX_U8 *pSrcAbove,
     OMX_U8* pDst,
     OMX_INT leftStep,
     OMX_INT dstStep,
     OMX_S32 availability        
)
{
    int x, y, Sum=0, Count = 0;

    if (availability & OMX_VC_LEFT)
    {
        for (y=0; y<4; y++)
        {
            Sum += pSrcLeft[y*leftStep];
        }
        Count++;
    }
    else if (availability & OMX_VC_UPPER)
    {
        for (x=0; x<4; x++)
        {
            Sum += pSrcAbove[x];
        }
        Count++;
    }
    if (Count==0)
    {
        Sum = 128;
    }
    else
    {
        Sum = (Sum + 2) >> 2;
    }
    for (y=0; y<4; y++)
    {
        for (x=0; x<4; x++)
        {
            pDst[y*dstStep+x] = (OMX_U8)Sum;
        }
    }
}

/**
 * Function: omxVCM4P10_PredictIntraChroma8x8
 *
 * Description: Performs Intra prediction for chroma samples.
 *
 * Remarks:
 *
 * Parameters:
 * [in] pSrcLeft - Pointer to the buffer of 8 left  pixel values: p[x, y] (x = -1, y= 0..7)
 *                 Must be 8-byte aligned.
 * [in] pSrcAbove - Pointer to the buffer of 8 above  pixel values: p[x,y] (x = 0..7, y = -1)
 *                 Must be 8-byte aligned.
 * [in] pSrcAboveLeft - Pointer to the above left  pixel value: p[x,y] (x = -1, y = -1)
 * [in] leftStep - Step of left coefficient buffer. Must be multiple of 8
 * [in] dstStep - Step of the destination buffer. Must be multiple of 8
 * [in] predMode - Intra chroma prediction mode, please refer to section 3.4.3.
 * [in] availability - Neighboring chroma block availability flag, please refer to "Neighboring Macroblock Availability".
 * [out] pDst - Pointer to the destination buffer. Must be 8-byte aligned.
 *
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 * If any of the following cases occurs, the function returns OMX_StsBadArgErr:
 *	 pDst is NULL or is not 8-byte aligned.
 *	 dstStep < 8 or is not multiple of 8.
 *	 predMode is not in the valid range of enumeration OMXVCM4P10IntraChromaPredMode.
 *	 predMode is OMX_VC_CHROMA_VERT, but availability doesn't set OMX_VC_UPPER indicating p[x,-1] (x = 0..7) is not available.
 *	 predMode is OMX_VC_CHROMA_HOR, but availability doesn't set OMX_VC_LEFT indicating p[-1,y] (y = 0..7) is not available.
 *	 predMode is OMX_VC_CHROMA_PLANE, but availability doesn't set OMX_VC_UPPER_LEFT or OMX_VC_UPPER or OMX_VC_LEFT indicating p[x,-1](x = 0..7), or p[-1,y] (y = 0..7), or p[-1,-1] is not available.
 *	 availability sets OMX_VC_UPPER, but pSrcAbove is NULL.
 *	 availability sets OMX_VC_LEFT, but pSrcLeft is NULL.
 *	 availability sets OMX_VC_UPPER_LEFT, but pSrcAboveLeft is NULL.
 *
 */

OMXResult omxVCM4P10_PredictIntraChroma8x8(
     const OMX_U8* pSrcLeft,
     const OMX_U8 *pSrcAbove,
     const OMX_U8 *pSrcAboveLeft,
     OMX_U8* pDst,
     OMX_INT leftStep,
     OMX_INT dstStep,
     OMXVCM4P10IntraChromaPredMode predMode,
     OMX_S32 availability        
 )
{
    int x, y, Sum;
    int H, V, a, b, c;

    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(dstStep < 8,  OMX_StsBadArgErr);
    armRetArgErrIf((availability & OMX_VC_UPPER)      && pSrcAbove     == NULL, OMX_StsBadArgErr);
    armRetArgErrIf((availability & OMX_VC_LEFT )      && pSrcLeft      == NULL, OMX_StsBadArgErr);
    armRetArgErrIf((availability & OMX_VC_UPPER_LEFT) && pSrcAboveLeft == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_CHROMA_VERT  && !(availability & OMX_VC_UPPER),      OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_CHROMA_HOR   && !(availability & OMX_VC_LEFT),       OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_CHROMA_PLANE && !(availability & OMX_VC_UPPER),      OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_CHROMA_PLANE && !(availability & OMX_VC_UPPER_LEFT), OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_CHROMA_PLANE && !(availability & OMX_VC_LEFT),       OMX_StsBadArgErr);
    armRetArgErrIf((unsigned)predMode > OMX_VC_CHROMA_PLANE,   OMX_StsBadArgErr);    

    switch (predMode)
    {
    case OMX_VC_CHROMA_DC:
        armVCM4P10_PredictIntraDC4x4(       pSrcLeft,            pSrcAbove,   pDst,             leftStep, dstStep, availability);
        armVCM4P10_PredictIntraDCUp4x4(     pSrcLeft,            pSrcAbove+4, pDst+4,           leftStep, dstStep, availability);
        armVCM4P10_PredictIntraDCLeft4x4(   pSrcLeft+4*leftStep, pSrcAbove,   pDst+4*dstStep,   leftStep, dstStep, availability);
        armVCM4P10_PredictIntraDC4x4(       pSrcLeft+4*leftStep, pSrcAbove+4, pDst+4+4*dstStep, leftStep, dstStep, availability);
        break;

    case OMX_VC_CHROMA_HOR:
        for (y=0; y<8; y++)
        {
            for (x=0; x<8; x++)
            {
                pDst[y*dstStep+x] = pSrcLeft[y*leftStep];
            }
        }
        break;

    case OMX_VC_CHROMA_VERT:
        for (y=0; y<8; y++)
        {
            for (x=0; x<8; x++)
            {
                pDst[y*dstStep+x] = pSrcAbove[x];
            }
        }
        break;

    case OMX_VC_CHROMA_PLANE:
        H = 4*(pSrcAbove[7] - pSrcAboveLeft[0]);
        for (x=2; x>=0; x--)
        {
            H += (x+1)*(pSrcAbove[4+x] - pSrcAbove[2-x]);
        }
        V = 4*(pSrcLeft[7*leftStep] - pSrcAboveLeft[0]);
        for (y=2; y>=0; y--)
        {
            V += (y+1)*(pSrcLeft[(4+y)*leftStep] - pSrcLeft[(2-y)*leftStep]);
        }
        a = 16*(pSrcAbove[7] + pSrcLeft[7*leftStep]);
        b = (17*H+16)>>5;
        c = (17*V+16)>>5;
        for (y=0; y<8; y++)
        {
            for (x=0; x<8; x++)
            {
                Sum = (a + b*(x-3) + c*(y-3) + 16)>>5;
                pDst[y*dstStep+x] = (OMX_U8)armClip(0,255,Sum);
            }
        }
        break;
    }

    return OMX_StsNoErr;
}
