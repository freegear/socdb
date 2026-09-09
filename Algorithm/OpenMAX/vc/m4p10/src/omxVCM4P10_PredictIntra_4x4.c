/* ----------------------------------------------------------------
 *
 *  omxVCM4P10_PredictIntra_4x4.c
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
 * H.264 4x4 intra prediction module
 * 
 */
 
#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"
#include "armVC.h"

/**
* Function: omxVCM4P10_PredictIntra_4x4
 *
 * Description: Perform Intra_4x4 prediction for luma samples. If the upper-right block
 * is not available, then duplication work should be handled inside the function. Users
 * need not define them outside.
 *
 * Remarks:
 *
 * Parameters:
 * [in] pSrcLeft - Pointer to the buffer of 4 left  pixel values: p[x, y] (x = -1, y = 0..3)
 *                 Must be 4-byte aligned.
 * [in] pSrcAbove - Pointer to the buffer of 8 above  pixel values: p[x,y] (x = 0..7, y =-1)
 *                 Must be 4-byte aligned.
 * [in] pSrcAboveLeft - Pointer to the above left  pixel value: p[x,y] (x = -1, y = -1)
 * [in] leftStep - Step of left coefficient buffer. Must be multiple of 4.
 * [in] dstStep - Step of the destination buffer. Must be multiple of 4.
 * [in] predMode - Intra_4x4 prediction mode.
 * [in] availability - Neighboring 4x4 block availability flag, refer to "Neighboring Macroblock Availability".
 * [out]	pDst - Pointer to the destination buffer. Must be 4-byte aligned.
 *
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 * If one of the following cases occurs, the function returns OMX_StsBadArgErr:
 *    pDst is NULL or is not 4-byte aligned.
 *    dstStep < 4 or is not multiple of 4.
 *	  predMode is not in the valid range of enumeration OMXVCM4P10Intra4x4PredMode.
 *  	predMode is OMX_VC_4x4_VERT, but availability doesn't set OMX_VC_UPPER indicating p[x,-1] (x = 0..3)
 *    is not available.
 *	  predMode is OMX_VC_4x4_HOR, but availability doesn't set OMX_VC_LEFT indicating p[-1,y] (y = 0..3)
 *    is not available.
 *	  predMode is OMX_VC_4x4_DIAG_DL, but availability doesn't set OMX_VC_UPPER indicating p[x,-1] (x = 0..3)
 *    is not available.
 *	  predMode is OMX_VC_4x4_DIAG_DR, but availability doesn't set OMX_VC_UPPER_LEFT or OMX_VC_UPPER or
 *    OMX_VC_LEFT indicating p[x,-1] (x = 0..3), or p[-1,y] (y = 0..3) or p[-1,-1] is not available.
 *	  predMode is OMX_VC_4x4_VR, but availability doesn't set OMX_VC_UPPER_LEFT or OMX_VC_UPPER or
 *    OMX_VC_LEFT indicating p[x,-1] (x = 0..3), or p[-1,y] (y = 0..3) or p[-1,-1] is not available.
 *	  predMode is OMX_VC_4x4_HD, but availability doesn't set OMX_VC_UPPER_LEFT or OMX_VC_UPPER or
 *    OMX_VC_LEFT indicating p[x,-1] (x = 0..3), or p[-1,y] (y = 0..3) or p[-1,-1] is not available.
 *	  predMode is OMX_VC_4x4_VL, but availability doesn't set OMX_VC_UPPER indicating p[x,-1] (x = 0..3)
 *    is not available.
 *	  predMode is OMX_VC_4x4_HU, but availability doesn't set OMX_VC_LEFT indicating p[-1,y] (y = 0..3)
 *    is not available.
 *	  availability sets OMX_VC_UPPER, but pSrcAbove is NULL.
 *	  availability sets OMX_VC_LEFT, but pSrcLeft is NULL.
 *	  availability sets OMX_VC_UPPER_LEFT, but pSrcAboveLeft is NULL.
 *
 */

OMXResult omxVCM4P10_PredictIntra_4x4(
     const OMX_U8* pSrcLeft,
     const OMX_U8 *pSrcAbove,
     const OMX_U8 *pSrcAboveLeft,
     OMX_U8* pDst,
     OMX_INT leftStep,
     OMX_INT dstStep,
     OMXVCM4P10Intra4x4PredMode predMode,
     OMX_S32 availability        
 )
{
    int x, y;
    OMX_U8 pTmp[10];

    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(dstStep < 4,  OMX_StsBadArgErr);
    armRetArgErrIf((availability & OMX_VC_UPPER)      && pSrcAbove     == NULL, OMX_StsBadArgErr);
    armRetArgErrIf((availability & OMX_VC_LEFT )      && pSrcLeft      == NULL, OMX_StsBadArgErr);
    armRetArgErrIf((availability & OMX_VC_UPPER_LEFT) && pSrcAboveLeft == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_4x4_VERT    && !(availability & OMX_VC_UPPER),      OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_4x4_HOR     && !(availability & OMX_VC_LEFT),       OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_4x4_DIAG_DL && !(availability & OMX_VC_UPPER),      OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_4x4_DIAG_DR && !(availability & OMX_VC_UPPER),      OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_4x4_DIAG_DR && !(availability & OMX_VC_UPPER_LEFT), OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_4x4_DIAG_DR && !(availability & OMX_VC_LEFT),       OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_4x4_VR      && !(availability & OMX_VC_UPPER),      OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_4x4_VR      && !(availability & OMX_VC_UPPER_LEFT), OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_4x4_VR      && !(availability & OMX_VC_LEFT),       OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_4x4_HD      && !(availability & OMX_VC_UPPER),      OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_4x4_HD      && !(availability & OMX_VC_UPPER_LEFT), OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_4x4_HD      && !(availability & OMX_VC_LEFT),       OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_4x4_VL      && !(availability & OMX_VC_UPPER),      OMX_StsBadArgErr);
    armRetArgErrIf(predMode==OMX_VC_4x4_HU      && !(availability & OMX_VC_LEFT),       OMX_StsBadArgErr);
    armRetArgErrIf((unsigned)predMode > OMX_VC_4x4_HU,   OMX_StsBadArgErr);    
    
    /* Note: This code must not read the pSrc arrays unless the corresponding
     * block is marked as available. If the block is not avaibable then pSrc
     * may not be a valid pointer.
     *
     * Note: To make the code more readable we refer to the neighbouring pixels
     * in variables named as below:
     *
     *    UL U0 U1 U2 U3 U4 U5 U6 U7
     *    L0 xx xx xx xx
     *    L1 xx xx xx xx
     *    L2 xx xx xx xx
     *    L3 xx xx xx xx
     */
     
#define UL pSrcAboveLeft[0]
#define U0 pSrcAbove[0]
#define U1 pSrcAbove[1]
#define U2 pSrcAbove[2]
#define U3 pSrcAbove[3]
#define U4 pSrcAbove[4]
#define U5 pSrcAbove[5]
#define U6 pSrcAbove[6]
#define U7 pSrcAbove[7]
#define L0 pSrcLeft[0*leftStep]
#define L1 pSrcLeft[1*leftStep]
#define L2 pSrcLeft[2*leftStep]
#define L3 pSrcLeft[3*leftStep]

    switch (predMode)
    {
    case OMX_VC_4x4_VERT:
        for (y=0; y<4; y++)
        {
            pDst[y*dstStep+0] = U0;
            pDst[y*dstStep+1] = U1;
            pDst[y*dstStep+2] = U2;
            pDst[y*dstStep+3] = U3;
        }
        break;

    case OMX_VC_4x4_HOR:
        for (x=0; x<4; x++)
        {
            pDst[0*dstStep+x] = L0;
            pDst[1*dstStep+x] = L1;
            pDst[2*dstStep+x] = L2;
            pDst[3*dstStep+x] = L3;
        }
        break;
    
    case OMX_VC_4x4_DC:
        /* This can always be used even if no blocks available */
        armVCM4P10_PredictIntraDC4x4(pSrcLeft, pSrcAbove, pDst, leftStep, dstStep, availability);
        break;
        
    case OMX_VC_4x4_DIAG_DL:
        pTmp[0] = (OMX_U8)((U0 + 2*U1 + U2 + 2)>>2);
        pTmp[1] = (OMX_U8)((U1 + 2*U2 + U3 + 2)>>2);
        if (availability & OMX_VC_UPPER_RIGHT)
        {
            pTmp[2] = (OMX_U8)((U2 + 2*U3 + U4 + 2)>>2);
            pTmp[3] = (OMX_U8)((U3 + 2*U4 + U5 + 2)>>2);
            pTmp[4] = (OMX_U8)((U4 + 2*U5 + U6 + 2)>>2);
            pTmp[5] = (OMX_U8)((U5 + 2*U6 + U7 + 2)>>2);
            pTmp[6] = (OMX_U8)((U6 + 3*U7      + 2)>>2);
        }
        else
        {
            pTmp[2] = (OMX_U8)((U2 + 3*U3      + 2)>>2);
            pTmp[3] = U3;
            pTmp[4] = U3;
            pTmp[5] = U3;
            pTmp[6] = U3;
        }
        for (y=0; y<4; y++)
        {
            for (x=0; x<4; x++)
            {
                pDst[y*dstStep+x] = pTmp[x+y];
            }
        }
        break;

    case OMX_VC_4x4_DIAG_DR:        
        /* x-y = -3, -2, -1, 0, 1, 2, 3 */
        pTmp[0] = (OMX_U8)((L1 + 2*L2 + L3 + 2)>>2);
        pTmp[1] = (OMX_U8)((L0 + 2*L1 + L2 + 2)>>2);
        pTmp[2] = (OMX_U8)((UL + 2*L0 + L1 + 2)>>2);
        pTmp[3] = (OMX_U8)((U0 + 2*UL + L0 + 2)>>2);
        pTmp[4] = (OMX_U8)((U1 + 2*U0 + UL + 2)>>2);
        pTmp[5] = (OMX_U8)((U2 + 2*U1 + U0 + 2)>>2);
        pTmp[6] = (OMX_U8)((U3 + 2*U2 + U1 + 2)>>2);
        for (y=0; y<4; y++)
        {
            for (x=0; x<4; x++)
            {
                pDst[y*dstStep+x] = pTmp[3+x-y];
            }
        }
        break;

    case OMX_VC_4x4_VR:
        /* zVR=2x-y = -3, -2, -1, 0, 1, 2, 3, 4, 5, 6
         * x-(y>>1) = -1, -1,  0, 0, 1, 1, 2, 2, 3, 3
         * y        =  3,  2,  ?, ?, ?, ?, ?, ?, 1, 0
         */
        pTmp[0] = (OMX_U8)((L2 + 2*L1 + L0 + 2)>>2);
        pTmp[1] = (OMX_U8)((L1 + 2*L0 + UL + 2)>>2);
        pTmp[2] = (OMX_U8)((L0 + 2*UL + U0 + 2)>>2);
        pTmp[3] = (OMX_U8)((UL + U0 + 1)>>1);
        pTmp[4] = (OMX_U8)((UL + 2*U0 + U1 + 2)>>2);
        pTmp[5] = (OMX_U8)((U0 + U1 + 1)>>1);
        pTmp[6] = (OMX_U8)((U0 + 2*U1 + U2 + 2)>>2);
        pTmp[7] = (OMX_U8)((U1 + U2 + 1)>>1);
        pTmp[8] = (OMX_U8)((U1 + 2*U2 + U3 + 2)>>2);
        pTmp[9] = (OMX_U8)((U2 + U3 + 1)>>1);
        for (y=0; y<4; y++)
        {
            for (x=0; x<4; x++)
            {
                pDst[y*dstStep+x] = pTmp[3+2*x-y];
            }
        }
        break;

    case OMX_VC_4x4_HD:
        /* zHD=2y-x = -3 -2 -1  0  1  2  3  4  5  6
         * y-(x>>1) = -1 -1  0  0  1  1  2  2  3  3
         * x        =  3  2                    1  0
         */
        pTmp[0] = (OMX_U8)((U2 + 2*U1 + U0 + 2)>>2);
        pTmp[1] = (OMX_U8)((U1 + 2*U0 + UL + 2)>>2);
        pTmp[2] = (OMX_U8)((U0 + 2*UL + L0 + 2)>>2);
        pTmp[3] = (OMX_U8)((UL + L0 + 1)>>1);
        pTmp[4] = (OMX_U8)((UL + 2*L0 + L1 + 2)>>2);
        pTmp[5] = (OMX_U8)((L0 + L1 + 1)>>1);
        pTmp[6] = (OMX_U8)((L0 + 2*L1 + L2 + 2)>>2);
        pTmp[7] = (OMX_U8)((L1 + L2 + 1)>>1);
        pTmp[8] = (OMX_U8)((L1 + 2*L2 + L3 + 2)>>2);
        pTmp[9] = (OMX_U8)((L2 + L3 + 1)>>1);
        for (y=0; y<4; y++)
        {
            for (x=0; x<4; x++)
            {
                pDst[y*dstStep+x] = pTmp[3+2*y-x];
            }
        }
        break;

    case OMX_VC_4x4_VL:
        /* Note: x+(y>>1) = (2*x+y)>>1
         * 2x+y = 0 1 2 3 4 5 6 7 8 9
         */
        pTmp[0] = (OMX_U8)((U0 + U1 + 1)>>1);
        pTmp[1] = (OMX_U8)((U0 + 2*U1 + U2 + 2)>>2);
        pTmp[2] = (OMX_U8)((U1 + U2 + 1)>>1);
        pTmp[3] = (OMX_U8)((U1 + 2*U2 + U3 + 2)>>2);
        pTmp[4] = (OMX_U8)((U2 + U3 + 1)>>1);
        if (availability & OMX_VC_UPPER_RIGHT)
        {
            pTmp[5] = (OMX_U8)((U2 + 2*U3 + U4 + 2)>>2);
            pTmp[6] = (OMX_U8)((U3 + U4 + 1)>>1);
            pTmp[7] = (OMX_U8)((U3 + 2*U4 + U5 + 2)>>2);
            pTmp[8] = (OMX_U8)((U4 + U5 + 1)>>1);
            pTmp[9] = (OMX_U8)((U4 + 2*U5 + U6 + 2)>>2);
        }
        else
        {
            pTmp[5] = (OMX_U8)((U2 + 3*U3 + 2)>>2);
            pTmp[6] = U3;
            pTmp[7] = U3;
            pTmp[8] = U3;
            pTmp[9] = U3;
        }
        for (y=0; y<4; y++)
        {
            for (x=0; x<4; x++)
            {
                pDst[y*dstStep+x] = pTmp[2*x+y];
            }
        }
        break;

    case OMX_VC_4x4_HU:
        /* zHU = x+2*y */
        pTmp[0] = (OMX_U8)((L0 + L1 + 1)>>1);
        pTmp[1] = (OMX_U8)((L0 + 2*L1 + L2 + 2)>>2);
        pTmp[2] = (OMX_U8)((L1 + L2 + 1)>>1);
        pTmp[3] = (OMX_U8)((L1 + 2*L2 + L3 + 2)>>2);
        pTmp[4] = (OMX_U8)((L2 + L3 + 1)>>1);
        pTmp[5] = (OMX_U8)((L2 + 3*L3 + 2)>>2);
        pTmp[6] = L3;
        pTmp[7] = L3;
        pTmp[8] = L3;
        pTmp[9] = L3;
        for (y=0; y<4; y++)
        {
            for (x=0; x<4; x++)
            {
                pDst[y*dstStep+x] = pTmp[x+2*y];
            }
        }
        break;
    }

    return OMX_StsNoErr;
}
