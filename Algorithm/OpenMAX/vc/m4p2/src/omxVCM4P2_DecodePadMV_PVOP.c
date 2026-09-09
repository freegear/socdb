/**
 *  omxVCM4P2_DecodePadMV_PVOP.c
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
 * Contains module for decoding MV and padding the same
 * 
 */

#include "omxVC.h"
#include "omxtypes.h"
#include "armCOMM_Bitstream.h"
#include "armCOMM.h"
#include "armVCM4P2_Huff_Tables_VLC.h"



/**
 * Function: omxVCM4P2_DecodePadMV_PVOP
 *
 * Description:
 * Decodes and pads four motion vectors of the non-intra macroblock in P-VOP.
 * The motion vector padding process is specified in subclause 7.6.1.6 of
 * ISO/IEC 14496-2.
 *
 * Remarks:
 *
 *
 * Parameters:
 * [in]	ppBitStream		pointer to the pointer to the current byte in
 *								the bit stream buffer
 * [in]	pBitOffset		pointer to the bit position in the byte pointed
 *								to by *ppBitStream. *pBitOffset is valid within
 *								[0-7].
 * [in]	pSrcMVLeftMB    pointers to the motion vector buffers of the
 *								macroblocks specially at the left side of the current macroblock
 *								respectively.
 * [in]	pSrcMVUpperMB   pointers to the motion vector buffers of the
 *								macroblocks specially at the upper side of the current macroblock
 *								respectively.
 * [in]	pSrcMVUpperRightMB	pointers to the motion vector buffers of the
 *								macroblocks specially at the upper-right side of the current macroblock
 *								respectively.
 * [in]	fcodeForward	a code equal to vop_fcode_forward in MPEG-4
 *								bit stream syntax
 * [in]	MBType			the type of the current macroblock. If MBType
 *								is not equal to OMX_VC_INTER4V, the destination
 *								motion vector buffer is still filled with the
 *								same decoded vector.
 * [out]	ppBitStream		*ppBitStream is updated after the block is decoded,
 *								so that it points to the current byte in the bit
 *								stream buffer
 * [out]	pBitOffset		*pBitOffset is updated so that it points to the
 *								current bit position in the byte pointed by
 *								*ppBitStream
 * [out]	pDstMVCurMB		pointer to the motion vector buffer of the current
 *								macroblock which contains four decoded motion vectors
 *
 * Return Value:
 * OMX_StsNoErr -no error
 * OMX_StsBadArgErr - bad arguments
 *      -At least one of the following pointers is NULL: ppBitStream, *ppBitStream,
 *                           pBitOffset, pTranspLeftMB, pTranspUpperMB, pTranspUpperRight,
 *                           pTranspCurMB, pDstMVCurMB
 *          or
 *      -	At least one of following cases is true: *pBitOffset exceeds [0,7], fcodeForward
 *          exceeds (0,7], MBType less than zero, transparent status or the motion vector buffer
 *          is not 32-bit aligned.
 * OMX_StsErr - status error
 *
 */

OMXResult omxVCM4P2_DecodePadMV_PVOP(
     const OMX_U8 ** ppBitStream,
     OMX_INT * pBitOffset,
     OMXVCMotionVector * pSrcMVLeftMB,
     OMXVCMotionVector *pSrcMVUpperMB,
     OMXVCMotionVector * pSrcMVUpperRightMB,
     OMXVCMotionVector * pDstMVCurMB,
     OMX_INT fcodeForward,
     OMXVCM4P2MacroblockType MBType
 )
{
    OMXVCMotionVector diffMV;
    OMXVCMotionVector dstMVPredME[12];
    OMX_INT iBlk, i, count = 1;
    OMX_S32 mvHorResidual = 1, mvVerResidual = 1, mvHorData, mvVerData;
    OMX_S8 scaleFactor, index;
    OMX_S16 high, low, range;


    /* Argument error checks */
    armRetArgErrIf(ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(*ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pBitOffset == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pDstMVCurMB == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(((*pBitOffset < 0) || (*pBitOffset > 7)), OMX_StsBadArgErr);
    armRetArgErrIf(((fcodeForward < 1) || (fcodeForward > 7)), \
                    OMX_StsBadArgErr);
    armRetArgErrIf(!armIs4ByteAligned(pDstMVCurMB), OMX_StsBadArgErr);
    
    if ((MBType == OMX_VC_INTRA) ||
        (MBType == OMX_VC_INTRA_Q)
       )
    {
        /* All MV's are zero */
        for (i = 0; i < 4; i++)
        {
            pDstMVCurMB[i].dx = 0;
            pDstMVCurMB[i].dy = 0;
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
    high =  ( 32 * scaleFactor) - 1;
    low =   ( (-32) * scaleFactor);
    range = ( 64 * scaleFactor);

    /* Huffman decoding and MV reconstruction */
    for (iBlk = 0; iBlk < count; iBlk++)
    {

        /* Huffman decoding to get Horizontal data and residual */
        index = armUnPackVLC32(ppBitStream, pBitOffset,
                                            armVCM4P2_aVlcMVD);
        armRetDataErrIf(index == -1, OMX_StsErr);

        mvHorData = index - 32;

        if ((fcodeForward > 1) && (mvHorData != 0))
        {
            mvHorResidual = (OMX_S32) armGetBits(ppBitStream,
                                            pBitOffset, (fcodeForward -1));
        }

        /* Huffman decoding to get Vertical data and residual */
        index = armUnPackVLC32(ppBitStream, pBitOffset, armVCM4P2_aVlcMVD);
        armRetDataErrIf(index == -1, OMX_StsErr);

        mvVerData = index - 32;

        if ((fcodeForward > 1) && (mvVerData != 0))
        {
            mvVerResidual = (OMX_S32) armGetBits(ppBitStream,
                                            pBitOffset, (fcodeForward -1));
        }

        /* Calculating the differtial MV */
        if ( (scaleFactor == 1) || (mvHorData == 0) )
        {
            diffMV.dx = mvHorData;
        }
        else
        {
            diffMV.dx = ((armAbs(mvHorData) - 1) * fcodeForward)
                         + mvHorResidual + 1;
            if (mvHorData < 0)
            {
                diffMV.dx = -diffMV.dx;
            }
        }

        if ( (scaleFactor == 1) || (mvVerData == 0) )
        {
            diffMV.dy = mvVerData;
        }
        else
        {
            diffMV.dy = ((armAbs(mvVerData) - 1) * fcodeForward)
                         + mvVerResidual + 1;
            if (mvVerData < 0)
            {
                diffMV.dy = -diffMV.dy;
            }
        }

        /* Find the predicted vector */
        omxVCM4P2_FindMVpred (
            pDstMVCurMB,
            pSrcMVLeftMB,
            pSrcMVUpperMB,
            pSrcMVUpperRightMB,
            &pDstMVCurMB[iBlk],
            dstMVPredME,
            iBlk);

        /* Adding the difference to the predicted MV to reconstruct MV */
        pDstMVCurMB[iBlk].dx += diffMV.dx;
        pDstMVCurMB[iBlk].dy += diffMV.dy;

        /* Checking the range and keeping it within the limits */
        if ( pDstMVCurMB[iBlk].dx < low )
        {
            pDstMVCurMB[iBlk].dx += range;
        }
        if (pDstMVCurMB[iBlk].dx > high)
        {
            pDstMVCurMB[iBlk].dx -= range;
        }

        if ( pDstMVCurMB[iBlk].dy < low )
        {
            pDstMVCurMB[iBlk].dy += range;
        }
        if (pDstMVCurMB[iBlk].dy > high)
        {
            pDstMVCurMB[iBlk].dy -= range;
        }
    }

    if ((MBType == OMX_VC_INTER) || (MBType == OMX_VC_INTER_Q))
    {
        pDstMVCurMB[1] = pDstMVCurMB[0];
        pDstMVCurMB[2] = pDstMVCurMB[0];
        pDstMVCurMB[3] = pDstMVCurMB[0];
    }

    return OMX_StsNoErr;
}


/* End of file */


