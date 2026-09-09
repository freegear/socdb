/**
 *  omxVCM4P2_DecodeVLCZigzag_Inter.c
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
 * Contains modules for zigzag scanning and VLC decoding
 * for inter block.
 *
 */

#include "omxtypes.h"
#include "armVC.h"
#include "armCOMM_Bitstream.h"
#include "armCOMM.h"
#include "armVCM4P2_Huff_Tables_VLC.h"
#include "armVCM4P2_ZigZag_Tables.h"



/**
 * Function: omxVCM4P2_DecodeVLCZigzag_Inter
 *
 * Description:
 * Performs VLC decoding and inverse zigzag scan for one intra coded block.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppBitStream		pointer to the pointer to the current byte in
 *								the bitstream buffer
 * [in]	pBitOffset		pointer to the bit position in the byte pointed
 *								to by *ppBitStream. *pBitOffset is valid within
 *								[0-7].
 * [in] shortVideoHeader  binary flag indicating presence of short_video_header;
 *                          escape modes 0-3 are used if shortVideoHeader==0, and escape mode 4 is used when shortVideoHeader==1.
 * [out]	ppBitStream		*ppBitStream is updated after the block is
 *								decoded, so that it points to the current byte
 *								in the bit stream buffer
 * [out]	pBitOffset		*pBitOffset is updated so that it points to the
 *								current bit position in the byte pointed by
 *								*ppBitStream
 * [out]	pDst			pointer to the coefficient buffer of current
 *								block. Must be 16-byte aligned
 *
 * Return Value:
 * OMX_StsBadArgErr - bad arguments
 *   -At least one of the following pointers is NULL: ppBitStream, *ppBitStream, pBitOffset, pDst, or
 *   -pDst is not 16-byte aligned, or
 *   -*pBitOffset exceeds [0,7].
 * OMX_StsErr - status error
 *   -At least one mark bit is equal to zero
 *   -Encountered an illegal stream code that cannot be found in the VLC table
 *   -Encountered and illegal code in the VLC FLC table
 *   -The number of coefficients is greater than 64
 *
 */

OMXResult omxVCM4P2_DecodeVLCZigzag_Inter(
     const OMX_U8 ** ppBitStream,
     OMX_INT * pBitOffset,
     OMX_S16 * pDst,
     OMX_INT shortVideoHeader
)
{
    OMX_U8  last,start = 0;
    const OMX_U8  *pZigzagTable = armVCM4P2_aClassicalZigzagScan;
    OMXResult errorCode;
    
    /* Argument error checks */
    armRetArgErrIf(ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(*ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pBitOffset == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(!armIs4ByteAligned(pDst), OMX_StsBadArgErr);

    errorCode = armVCM4P2_GetVLCBits (
              ppBitStream,
              pBitOffset,
			  pDst,
			  shortVideoHeader,
              start,
			  &last,
			  11,
			  42,
			   2,
			   5,
              armVCM4P2_InterL0RunIdx,
              armVCM4P2_InterVlcL0,
			  armVCM4P2_InterL1RunIdx,
              armVCM4P2_InterVlcL1,
              armVCM4P2_InterL0LMAX,
              armVCM4P2_InterL1LMAX,
              armVCM4P2_InterL0RMAX,
              armVCM4P2_InterL1RMAX,
              pZigzagTable );
    armRetDataErrIf((errorCode != OMX_StsNoErr), errorCode);
    
    if (last == 0)
    {
        return OMX_StsErr;
    }
    return OMX_StsNoErr;
}

/* End of file */

