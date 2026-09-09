/**
 *  omxVCM4P2_EncodeMV.c
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
 * Description: 
 * Contains module for predicting MV of MB
 *
 */ 

#include "omxVC.h"
#include "armCOMM.h"
#include "armCOMM_Bitstream.h"
#include "armVCM4P2_Huff_Tables_VLC.h"



/**
 * Function: omxVCM4P2_EncodeMV
 *
 * Description:
 * Predicts a motion vector for the current macroblock, encodes the difference, and writes
 * the output to the stream buffer.  The input MVs pMVCurMB, pSrcMVLeftMB, pSrcMVUpperMB,
 * and pSrcMVUpperRightMB should lie within the ranges associated with the input parameter
 * fcodeForward, as described in ISO/IEC 14496-2, subclause 7.6.3.  This function provides
 * a superset of the functionality associated with the function omxVCM4P2_FindMVpred.
 *
 * Remarks:
 *
 *
 * Parameters:
 * [in]	ppBitStream		pointer to the pointer to the current byte in
 *								the bit stream buffer
 * [in]	pBitOffset		pointer to the bit position in the byte pointed
 *								by *ppBitStream. Valid within 0 to 7.
 * [in]	pMVCurMB		pointer to the current macroblock motion vector
 * [in]	pSrcMVLeftMB	pointer to the source left macroblock motion vector
 * [in]	pSrcMVUpperMB	pointer to source upper macroblock motion vector
 * [in]	pSrcMVUpperRightMB	pointer to source upper right MB motion vector
 * [in]	fcodeForward	an integer with values from 1 to 7. This is used
 *								in encoding motion vectors related to search range.
 * [in]	MBType			macro block type, taking values from 0 to 5
 * [out]	ppBitStream		pointer to the pointer to the current byte in the
 *								bit stream buffer
 * [out]	pBitOffset		pointer to the bit position in the byte pointed
 *								by *ppBitStream
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr -bad arguments
 * At least one of the following pointers is NULL: ppBitStream, *ppBitStream,
 *       pBitOffset, pMVCurMB, pTranspLeftMB, pTranspUpperMB,
         pTransUpperRightMB, pTranspCurMB.
 * pBitOffset < 0, or *pBitOffset >7.
 * fcodeForward <= 0, or fcodeForward > 7, or MBType < 0
 *
 */

OMXResult omxVCM4P2_EncodeMV(
     OMX_U8 **ppBitStream,
     OMX_INT *pBitOffset,
     const OMXVCMotionVector * pMVCurMB,
     const OMXVCMotionVector * pSrcMVLeftMB,
     const OMXVCMotionVector * pSrcMVUpperMB,
     const OMXVCMotionVector * pSrcMVUpperRightMB,
     OMX_INT fcodeForward,
     OMXVCM4P2MacroblockType MBType
)
{
    OMXVCMotionVector dstMVPred, diffMV;
    OMXVCMotionVector dstMVPredME[12];
    /* Initialized to remove compilation warning */
    OMX_INT iBlk, i, count = 1;
    OMX_S32 mvHorResidual, mvVerResidual, mvHorData, mvVerData;
    OMX_U8 scaleFactor, index;

    /* Argument error checks */
    armRetArgErrIf(ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(*ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pBitOffset == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pMVCurMB == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(((*pBitOffset < 0) || (*pBitOffset > 7)), OMX_StsBadArgErr);
    armRetArgErrIf(((fcodeForward < 1) || (fcodeForward > 7)), \
                    OMX_StsBadArgErr);
    
    if ((MBType == OMX_VC_INTRA) ||
        (MBType == OMX_VC_INTRA_Q)
       )
    {
        /* No candidate vectors hence make them zero */
        for (i = 0; i < 12; i++)
        {
            dstMVPredME[i].dx = 0;
            dstMVPredME[i].dy = 0;
        }

        return OMX_StsNoErr;
    }

    if ((MBType == OMX_VC_INTER4V) || (MBType == OMX_VC_INTER4V_Q))
    {
        count = 4;
    }
    else if ((MBType == OMX_VC_INTER) || (MBType == OMX_VC_INTER_Q))
    {
        count = 1;
    }

    /* Calculating the scale factor */
    scaleFactor = 1 << (fcodeForward -1);

    for (iBlk = 0; iBlk < count; iBlk++)
    {

        /* Find the predicted vector */
        omxVCM4P2_FindMVpred (
            pMVCurMB,
            pSrcMVLeftMB,
            pSrcMVUpperMB,
            pSrcMVUpperRightMB,
            &dstMVPred,
            dstMVPredME,
            iBlk );

        /* Calculating the differential motion vector (diffMV) */
        diffMV.dx = pMVCurMB[iBlk].dx - dstMVPred.dx;
        diffMV.dy = pMVCurMB[iBlk].dy - dstMVPred.dy;

        /* Calculating the mv_data and mv_residual for Horizantal MV */
        if (diffMV.dx == 0)
        {
            mvHorResidual = 0;
            mvHorData = 0;
        }
        else
        {
            mvHorResidual = ( armAbs(diffMV.dx) - 1) % scaleFactor;
            mvHorData = (armAbs(diffMV.dx) - mvHorResidual + (scaleFactor - 1))
                     / scaleFactor;
            if (diffMV.dx < 0)
            {
                mvHorData = -mvHorData;
            }
        }

        /* Calculating the mv_data and mv_residual for Vertical MV */
        if (diffMV.dy == 0)
        {
            mvVerResidual = 0;
            mvVerData = 0;
        }
        else
        {
            mvVerResidual = ( armAbs(diffMV.dy) - 1) % scaleFactor;
            mvVerData = (armAbs(diffMV.dy) - mvVerResidual + (scaleFactor - 1))
                     / scaleFactor;
            if (diffMV.dy < 0)
            {
                mvVerData = -mvVerData;
            }
        }

        /* Huffman encoding */

        /* The index is actually calculate as
           index = ((float) (mvHorData/2) + 16) * 2,
           meaning the MV data is halfed and then normalized
           to begin with zero and then doubled to take care of indexing
           the fractional part included */
        index = mvHorData + 32;
        armPackVLC32 (ppBitStream, pBitOffset, armVCM4P2_aVlcMVD[index]);
        if ((fcodeForward > 1) && (diffMV.dx != 0))
        {
            armPackBits (ppBitStream, pBitOffset, mvHorResidual, (fcodeForward -1));
        }

        /* The index is actually calculate as
           index = ((float) (mvVerData/2) + 16) * 2,
           meaning the MV data is halfed and then normalized
           to begin with zero and then doubled to take care of indexing
           the fractional part included */
        index = mvVerData + 32;
        armPackVLC32 (ppBitStream, pBitOffset, armVCM4P2_aVlcMVD[index]);
        if ((fcodeForward > 1) && (diffMV.dy != 0))
        {
            armPackBits (ppBitStream, pBitOffset, mvVerResidual, (fcodeForward -1));
        }
    }

    return OMX_StsNoErr;
}


/* End of file */


