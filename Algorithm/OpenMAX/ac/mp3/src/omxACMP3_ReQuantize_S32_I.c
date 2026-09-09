/**
 *  omxACMP3_ReQuantize_S32_I.c
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
 * This function is used to Requantizes the decoded Huffman symbols
 */

#include "omxtypes.h"
#include "armCOMM_Bitstream.h"
#include "omxAC.h"
#include "armACMP3_Tables.h"

/**
 * Function: omxACMP3_ReQuantize_S32_I
 *
 * Description:
 * Requantizes the decoded Huffman symbols.
 * See ISO/IEC 13818-3 2.5.3.2.2
 *
 * Remarks:
 * This function Requantizes the decoded Huffman symbols.
 *
 *
 * Parameters:
 * [in]  pSrcDstIsXr     pointer to the vector of decoded Huffman symbols;
 *                             for stereo and dual_channel modes, right channel
 *                             data begins at the address &(pSrcDstIsXr[576])
 *														 represented in Q16.15 format.
 * [in]  pNonZeroBound   (Inout/output argument) pointer to the spectral
 *                             bound above which all coefficients are set to zero;
 *                             for stereo and dual-channel modes, the left channel
 *                             bound is pNonZeroBound [0], and the right channel
 *                             bound is pNonZeroBound [1].
 * [in]  pScaleFactor    pointer to the scalefactor buffer; for stereo and
 *                             dual-channel modes, the right channel scalefactors
 *                             begin at & (pScaleFactor [OMX_MP3_SF_BUF_LEN] )
 * [in]  pSideInfo       pointer to the side information for the current granule
 * [in]  pFrameHeader    pointer to the frame header for the current frame
 * [in]  pBuffer         pointer to a workspace buffer. The buffer length
 *                             must be 576 samples
 * [in]  pSfbTableLong   pointer to Scalefactor band table for long block.
 * [in]  pSfbTableShort  pointer to Scalefactor band table for short block.
 * [out] pSrcDstIsXr     pointer to the vector of decoded Huffman symbols;
 *                             for stereo and dual_channel modes, right channel
 *                             data begins at the address &(pSrcDstIsXr[576])
 *														 represented in Q5.26 format.
 * [out] pNonZeroBound   (Inout/output argument) pointer to the spectral
 *                             bound above which all coefficients are set to zero;
 *                             for stereo and dual-channel modes, the left channel
 *                             bound is pNonZeroBound [0], and the right channel
 *                             bound is pNonZeroBound [1].
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACMP3_ReQuantize_S32_I(
     OMX_S32 *pSrcDstIsXr,
     OMX_INT *pNonZeroBound,
     OMX_S8 *pScaleFactor,
     OMXMP3SideInfo *pSideInfo,
     OMXMP3FrameHeader *pFrameHeader,
     OMX_S32 *pBuffer
)
{
    /* Call requantize function with Standard scale factor tables */
    return omxACMP3_ReQuantizeSfb_S32_I(pSrcDstIsXr,
                                        pNonZeroBound,
                                        pScaleFactor,
                                        pSideInfo,
                                        pFrameHeader,
                                        pBuffer,
                                        armACMP3_SFBTableLong,
                                        armACMP3_SFBTableShort);

}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

