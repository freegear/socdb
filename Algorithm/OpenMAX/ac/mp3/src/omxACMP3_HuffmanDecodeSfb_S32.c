/**
 *  omxACMP3_HuffmanDecodeSfb_S32.c
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
 * Description:
 * This function is used to decode Huffman symbols as given in ISO/IEC 13818-3
 */

#include "omxtypes.h"
#include "omxAC.h"
#include "armCOMM_Bitstream.h"
#include "armACMP3_Tables.h"

/**
 * Function: omxACMP3_HuffmanDecodeSfb_S32
 *
 * Description:
 * Decodes Huffman symbols for one granule of one channel.
 * See ISO/IEC 13818-3 2.4.1.7
 *
 * Remarks:
 * This function decode Huffman symbols for the 576 spectral coefficients
 * associated with one granule of one channel.
 *
 *
 * Parameters:
 * [in]  ppBitStream         double pointer to the first byte of the MP3
 *                                frame header
 * [in]  pOffset             pointer to the starting bit position in the
 *                                bit stream byte pointed by *ppBitStream
 * [in]  pSideInfo           pointer to MP3 structure that contains the
 *                                side information associated with the
 *                                current granule and channel
 * [in]  pFrameHeader        pointer to MP3 structure that contains the
 *                                header associated with the current frame
 * [in]  hufSize             the number of Huffman code bits associated
 *                                with the current granule and channel
 * [in]  pSfbTableLong       pointer to Scalefactor band table for long
 *                                block. User can use the default table from
 *                                MPEG-1 or MPEG-2 standards.
 * [in]  pSfbTableShort      pointer to Scalefactor band table for short
 *                                block.User can use the default table from
 *                                MPEG-1 or MPEG-2 standards.
 * [in]  pMbpTable           pointer to Scalefactor band table for mixed
 *                                block. User can use the default table from
 *                                MPEG-1, MPEG-2 standards. User can also use
 *                                his own table for special purpose.
 * [out] ppBitStream         double pointer to the first byte of the MP3
 *                                frame header
 * [out] pOffset             pointer to the starting bit position in the
 *                                bit stream byte pointed by *ppBitStream
 * [out] pDstIs              pointer to the vector of decoded Huffman
 *                                symbols used to compute the quantized
 *                                values of the 576 spectral coefficients that
 *                                are associated with the current granule and
 *                                channel, represented in Q16.15 format.
 * [out] pDstNonZeroBound    pointer to the spectral region above which
 *                                all coefficients are set equal to zero
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxACMP3_HuffmanDecodeSfb_S32(
    const OMX_U8 **ppBitStream,
    OMX_INT *pOffset,
    OMX_S32 *pDstIs,
    OMX_INT *pDstNonZeroBound,
    OMXMP3SideInfo *pSideInfo,
    OMXMP3FrameHeader *pFrameHeader,
    OMX_INT hufSize,
    OMXMP3ScaleFactorBandTableLong pSfbTableLong
)
{
    return omxACMP3_HuffmanDecodeSfbMbp_S32 (   
        ppBitStream,
        pOffset,
        pDstIs,
        pDstNonZeroBound,
        pSideInfo,
        pFrameHeader,
        hufSize,
        (/*OMXMP3ScaleFactorBandTableLong*/void*) pSfbTableLong,
        (/*OMXMP3ScaleFactorBandTableShort*/void*)armACMP3_SFBTableShort,
        (/*OMXMP3MixedBlockPartitionTable*/void*)armACMP3_SFBTableMixed);
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

