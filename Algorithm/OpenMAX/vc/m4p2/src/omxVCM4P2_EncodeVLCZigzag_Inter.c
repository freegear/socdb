/**
 *  omxVCM4P2_EncodeVLCZigzag_Inter.c
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
 * Contains modules for zigzag scanning and VLC encoding
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
 * Function: omxVCM4P2_EncodeVLCZigzag_Inter
 *
 * Description:
 * Performs classical zigzag scanning and VLC encoding for one inter block.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppBitStream		pointer to the pointer to the current byte in
 *								the bit stream
 * [in]	pBitOffset		pointer to the bit position in the byte pointed
 *								by *ppBitStream. Valid within 0 to 7
 * [in]	pQDctBlkCoef	pointer to the quantized DCT coefficient. Must be 16-byte aligned.
 * [in]	pattern			block pattern which is used to decide whether
 *								this block is encoded
 * [in] shortVideoHeader binary flag indicating presence of short_video_header; escape modes 0-3 are used if shortVideoHeader==0,
 *                           and escape mode 4 is used when shortVideoHeader==1.
 * [out]	ppBitStream		*ppBitStream is updated after the block is encoded
 *								so that it points to the current byte in the bit
 *								stream buffer.
 * [out]	pBitOffset		*pBitOffset is updated so that it points to the
 *								current bit position in the byte pointed by
 *								*ppBitStream.
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - Bad arguments
 *   -At least one of the pointers: is NULL: ppBitStream, *ppBitStream, pBitOffset, pQDctBlkCoef
 *   -*pBitOffset < 0, or *pBitOffset >7.
 *
 */
OMXResult omxVCM4P2_EncodeVLCZigzag_Inter(
     OMX_U8 **ppBitStream,
     OMX_INT * pBitOffset,
     const OMX_S16 *pQDctBlkCoef,
     OMX_U8 pattern,
	 OMX_INT shortVideoHeader
)
{
    OMX_U8 start = 0;
    const OMX_U8  *pZigzagTable = armVCM4P2_aClassicalZigzagScan;

    /* Argument error checks */
    armRetArgErrIf(ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(*ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pBitOffset == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pQDctBlkCoef == NULL, OMX_StsBadArgErr);
    armRetArgErrIf((*pBitOffset < 0) || (*pBitOffset >7), OMX_StsBadArgErr);

    if (pattern)
    {
        armVCM4P2_PutVLCBits (
              ppBitStream,
              pBitOffset,
              pQDctBlkCoef,
              shortVideoHeader,
              start,
              26,
              40,
              10,
              1,
              armVCM4P2_InterL0RunIdx,
              armVCM4P2_InterVlcL0,
			  armVCM4P2_InterL1RunIdx,
              armVCM4P2_InterVlcL1,
              armVCM4P2_InterL0LMAX,
              armVCM4P2_InterL1LMAX,
              armVCM4P2_InterL0RMAX,
              armVCM4P2_InterL1RMAX,
              pZigzagTable
        );
    } /* Pattern check ends*/

    return OMX_StsNoErr;

}

/* End of file */
