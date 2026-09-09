/**
 * File: omxac.h
 * Brief: OpenMAX Audio Coding DL library
 *
 * Copyright © 2005-06 The Khronos Group Inc. All Rights Reserved. 
 *
 * These materials are protected by copyright laws and contain material 
 * proprietary to the Khronos Group, Inc.  You may use these materials 
 * for implementing Khronos specifications, without altering or removing 
 * any trademark, copyright or other notice from the specification.
 * 
 * Khronos Group makes no, and expressly disclaims any, representations 
 * or warranties, express or implied, regarding these materials, including, 
 * without limitation, any implied warranties of merchantability or fitness 
 * for a particular purpose or non-infringement of any intellectual property. 
 * Khronos Group makes no, and expressly disclaims any, warranties, express 
 * or implied, regarding the correctness, accuracy, completeness, timeliness, 
 * and reliability of these materials. 
 *
 * Under no circumstances will the Khronos Group, or any of its Promoters, 
 * Contributors or Members or their respective partners, officers, directors, 
 * employees, agents or representatives be liable for any damages, whether 
 * direct, indirect, special or consequential damages for lost revenues, 
 * lost profits, or otherwise, arising from or in connection with these 
 * materials.
 * 
 * Khronos and OpenMAX are trademarks of the Khronos Group Inc. 
 *
 */

/* *****************************************************************************************/
/**
 *
 *  NewDomain: AC The Audio Coding Domain
 *  WithinDomain: OM
 *
 *  StartDomain: AC
 */


#ifndef _OMXAC_H_
#define _OMXAC_H_

#include "omxtypes.h"

#ifdef __cplusplus
extern "C" {
#endif

/* *****************************************************************************************/
/**
 *
 *  NewDomain: MP3 The MP3 decoder subdomain
 *  WithinDomain: AC
 *
 *  StartDomain: MP3
 */



/** Macros  */
#define OMX_MP3_GRANULE_LEN         576
#define OMX_MP3_SF_BUF_LEN          40  /** scalefactor buffer length */
#define OMX_MP3_V_BUF_LEN           512 /** V data buffer length */


/** Data Structures */

/** MPEG -1, -2 BC header, 32 bits. See ISO/IEC 11172-3, sect 2.4.1.3, 2.4.2.3, 2.4.2.4. */
/**   ISO/IEC  13818-3:1998, 2.4.2.3 */
typedef struct {
		OMX_INT idEx; 
		OMX_INT id; 										/**  idEx/ID 1/1: MPEG-1, idEx/ID: 1/0 MPEG-2, idEx/ID: 0/0 MPEG-2.5 */
    OMX_INT layer;                  /** layer index 0x3: Layer I   */
                                        /**         0x2: Layer II  */
                                        /**         0x1: Layer III */
    OMX_INT protectionBit;          /** CRC flag 0: CRC on, 1: CRC off */
    OMX_INT bitRate;                /** bit rate index */
    OMX_INT samplingFreq;           /** sampling frequency index */
    OMX_INT paddingBit;             /** padding flag 0: no padding, 1 padding  */
    OMX_INT privateBit;             /** private_bit, no use  */
    OMX_INT mode;                   /** mono/stereo select information */
    OMX_INT modeExt;                /** extension to mode */
    OMX_INT copyright;              /** copyright or not, 0: no, 1: yes  */
    OMX_INT originalCopy;           /** original bitstream or copy, 0: copy, 1: original */
    OMX_INT emphasis;               /** flag indicates the type of de-emphasis that shall be used */
    OMX_INT CRCWord;                /** CRC-check word */

} OMXMP3FrameHeader;


/** MP3 side informatin structure , for each granule. Other info main_data_begin, */
/* private_bits, scfsi are not included here. */
/* Please refer to reference ISO/IEC 11172-3:1993, 2.4.1.7, 2.4.2.7. ISO/IEC */
/* 13818-3:1998, 2.4.1.7 ). */

typedef struct {
    OMX_INT  part23Len;             /** the number of bits for scale factors and Huffman data */
    OMX_INT  bigVals;               /** the half number of Huffman data whose maximum */
                                       /*  amplitudes are greater than 1   */
    OMX_INT  globGain;              /** the quantizer step size information */
    OMX_INT  sfCompress;            /** information to select the number of bits used for */
                                       /* the transmission of the scale factors */
    OMX_INT  winSwitch;             /** flag signals that the block uses an other than */
                                        /*   normal window    */
    OMX_INT  blockType;             /** flag indicates the window type */
    OMX_INT  mixedBlock;            /** flag 0: non mixed block, 1: mixed block */
    OMX_INT  pTableSelect[3];       /** Huffman table index for the 3 regions in big-values field */
    OMX_INT  pSubBlkGain[3];        /** gain offset from the global gain for one subblock */
    OMX_INT  reg0Cnt;               /** the number of scale factor bands at the boundary */
                                        /* of the first region of the big-values field  */
    OMX_INT  reg1Cnt;               /** similar to reg0Cnt, but of the second region */
    OMX_INT  preFlag;               /** flag of high frequency amplification */
    OMX_INT  sfScale;               /** scale to the scale factors */
    OMX_INT  cnt1TabSel;            /** Huffman table index for the count1 region of quadruples */
} OMXMP3SideInfo;
#define OMX_MP3_SFB_TABLE_LONG_LEN	138
#define OMX_MP3_SFB_TABLE_SHORT_LEN	84

typedef const OMX_S16 OMXMP3ScaleFactorBandTableLong[OMX_MP3_SFB_TABLE_LONG_LEN]; /* 138 elements */
typedef const OMX_S16 OMXMP3ScaleFactorBandTableShort[OMX_MP3_SFB_TABLE_SHORT_LEN]; /* 84 elements */

#define OMX_MP3_SFB_MBP_TABLE_LEN 12
typedef const OMX_S16 OMXMP3MixedBlockPartitionTable[OMX_MP3_SFB_MBP_TABLE_LEN];

/** ========================= Frame Unpacking =============================== */
/**
 * Function: omxACMP3_UnpackFrameHeader
 *
 * Description:
 * Unpacks the audio frame header.
 * See 13818-3:1998, 2.4.2.3
 *
 * Remarks:
 * This function decode MP3 frame header.
 *
 *
 * Parameters:
 * [in]  ppBitStream        double pointer to the first byte of the MP3
 *                                frame header
 * [out] pFrameHeader       pointer to the MP3 frame header structure
 * [out] ppBitStream        ouble pointer to the byte immediately following the frame header
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACMP3_UnpackFrameHeader (
     const OMX_U8 **ppBitStream,
     OMXMP3FrameHeader *pFrameHeader
 );



/**
 * Function: omxACMP3_UnpackSideInfo
 *
 * Description:
 * Unpacks the mp3 side information.
 * See 13818-3:1998, 2.4.1.7
 *
 * Remarks:
 * This function decode MP3 side information.
 *
 *
 * Parameters:
 * [in]  ppBitStream        double pointer to the first byte of the MP3
 *                                frame header
 * [in]  pFrameHeader       pointer to the structure that contains the
 *                                unpacked MP3 frame header.
 * [out] pDstSideInfo       pointer to the MP3 side information structure
 * [out] pDstMainDataBegin    pointer to the main_data_begin field
 * [out] pDstPrivateBits    pointer to the private bits field
 * [out] pDstScfsi            pointer to the scalefactor selection information
 *                                associated with the current frame, organized
 *                                contiguously in the buffer pointed to by
 *                                pDstScfsi in the following order: {channel 0
 *                                (scfsi_band 0, scfsi_band 1, ..., scfsi_band 3),
 *                                channel 1 (scfsi_band 0, scfsi_band 1, ...,
 *                                scfsi_band 3) }.
 * [out] ppBitStream        double pointer to the first byte of the MP3
 *                                immediately following the side information for the current frame
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACMP3_UnpackSideInfo (
		 const OMX_U8 **ppBitStream,
     OMXMP3SideInfo *pDstSideInfo,
     OMX_INT *pDstMainDataBegin,
     OMX_INT *pDstPrivateBits,
     OMX_INT *pDstScfsi,
     OMXMP3FrameHeader *pFrameHeader
 );



/**
 * Function: omxACMP3_UnpackScaleFactors_S8
 *
 * Description:
 * Unpacks scalefactors.
 * See ISO/IEC 13818-3 2.4.1.7
 *
 * Remarks:
 * This function decode short and/or long block scalefactors for one granule
 * of one channel and places the results in the vector pDstScaleFactor
 *
 *
 * Parameters:
 * [in]  ppBitStream       double pointer to the first bit stream
 *                               buffer byte that is associated with the
 *                               scalefactors for the current frame,
 *                               granule, and channel
 * [in]  pOffset           pointer to the next bit in the byte referenced
 *                               by *ppBitStream. Valid within the range of 0 to 7,
 *                               where 0 corresponds to the most significant bit
 *                               and 7 corresponds to the least significant bit.
 * [in]  pSideInfo           pointer to the MP3 side information structure
 *                               associated with the current granule and channe
 * [in]  pScfsi              pointer to scalefactor selection information
 *                               for the current channel
 * [in]  pFrameHeader      pointer to MP3 frame header structure for the
 *                               current frame
 * [in]  granule           granule index; can take on the values of either 0 or 1
 * [in]  channel           channel index; can take on the values of either 0 or 1
 * [out] ppBitStream       double pointer to the first bit stream
 *                               buffer byte that is associated with the
 *                               scalefactors for the current frame, granule, and channel
 * [out] pOffset           pointer to the next bit in the byte referenced
                                 by *ppBitStream. Valid within the range of 0 to 7,
                                 where 0 corresponds to the most significant bit
                                 and 7 corresponds to the least significant bit.
 * [out] pDstScaleFactor     pointer to the scalefactor vector for long and/or
 *                               short blocks
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACMP3_UnpackScaleFactors_S8 (
		 const OMX_U8 **ppBitStream,
     OMX_INT *pOffset,
     OMX_S8 *pDstScaleFactor,
     OMXMP3SideInfo *pSideInfo,
     OMX_INT *pScfsi,
     OMXMP3FrameHeader *pFrameHeader,
     OMX_INT granule,
     OMX_INT channel
 );



/**
 * Function: omxACMP3_HuffmanDecode_S32;omxACMP3_HuffmanDecodeSfb_S32;omxACMP3_HuffmanDecodeSfbMbp_S32
 *
 * Description:
 * Decodes Huffman symbols for the 576 spectral coefficients associated with one granule of one channel..
 * See ISO/IEC 13818-3 2.5.2.8
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
 *                                MPEG-1 or MPEG-2 standards.User can also use his own table for special purpose. For table
 *                                format see references ISO/IEC 11172-3 Table B.8 and ISO/IEC 13818-3 Table B.2.
 * [in]  pSfbTableShort      pointer to Scalefactor band table for short
 *                                block.User can use the default table from
 *                                MPEG-1 or MPEG-2 standards.User can also use his own table for special purpose. For table 
 *                                format see references ISO/IEC 11172-3 Table B.8 and ISO/IEC 13818-3 Table B.2.
 * [in]  pMbpTable           pointer to Scalefactor band table for mixed
 *                                block. User can use the default table from
 *                                MPEG-1, MPEG-2 standards. User can also use
 *                                his own table for special purpose.
 * [out] ppBitStream         double pointer to the first byte of the MP3
 *                                frame header
 * [out] pOffset             updated pointer to the next bit position in the byte pointed by *ppBitStream;
 *                           valid within the range of 0 to 7, where 0 corresponds to the most significant bit, and 7
 *                           corresponds to the least significant bit
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
OMXResult omxACMP3_HuffmanDecode_S32 (
		 const OMX_U8 **ppBitStream,
     OMX_INT *pOffset,
     OMX_S32 *pDstIs,
     OMX_INT *pDstNonZeroBound,
     OMXMP3SideInfo *pSideInfo,
     OMXMP3FrameHeader *pFrameHeader,
     OMX_INT hufSize
 );


OMXResult omxACMP3_HuffmanDecodeSfb_S32(
		 const OMX_U8 **ppBitStream,
     OMX_INT *pOffset,
     OMX_S32 *pDstIs,
     OMX_INT *pDstNonZeroBound,
     OMXMP3SideInfo *pSideInfo,
     OMXMP3FrameHeader *pFrameHeader,
     OMX_INT hufSize,
     OMXMP3ScaleFactorBandTableLong pSfbTableLong
 );


OMXResult omxACMP3_HuffmanDecodeSfbMbp_S32(
		 const OMX_U8 **ppBitStream,
     OMX_INT *pOffset,
     OMX_S32 *pDstIs,
     OMX_INT *pDstNonZeroBound,
     OMXMP3SideInfo *pSideInfo,
     OMXMP3FrameHeader *pFrameHeader,
     OMX_INT hufSize,
     OMXMP3ScaleFactorBandTableLong pSfbTableLong,
     OMXMP3ScaleFactorBandTableShort pSfbTableShort,
     OMXMP3MixedBlockPartitionTable pMbpTable
 );



/** ============================== Requantization =========================== */
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
 * [in]  pSfbTableLong   pointer to Scalefactor band table for long block.User can use the default table
 *                             from MPEG-1 or MPEG-2 standards. User can also use his own table for special purpose. For table
 *                             format see references ISO/IEC 11172-3 Table B.8, and ISO/IEC 13818-3 Table B.2.
 * [in]  pSfbTableShort  pointer to Scalefactor band table for short block.User can use the default table
 *                             from MPEG-1 or MPEG-2 standards. User can also use his own table for special purpose. For table
 *                             format see references ISO/IEC 11172-3 Table B.8, and ISO/IEC 13818-3 Table B.2.
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
 );

OMXResult omxACMP3_ReQuantizeSfb_S32_I(
     OMX_S32 *pSrcDstIsXr,
     OMX_INT *pNonZeroBound,
     OMX_S8 *pScaleFactor,
     OMXMP3SideInfo *pSideInfo,
     OMXMP3FrameHeader *pFrameHeader,
     OMX_S32 *pBuffer,
     OMXMP3ScaleFactorBandTableLong pSfbTableLong,
     OMXMP3ScaleFactorBandTableShort pSfbTableShort
 );



/** =============================== Hybrid Filtering ======================== */
/**
 * Function: omxACMP3_MDCTInv_S32
 *
 * Description:
 * Stage 1 of the hybrid synthesis filter bank.
 * See ISO/IEC 13818-3  2.5.3.3.2
 *
 * Remarks:
 * This performs the following operations: a) Alias reduction, b) Inverse MDCT
 * according to block size specifiers and mixed block modes, c) Overlap
 * add of IMDCT outputs, and d) Frequency inversion prior to PQMF bank.
 *
 *
 * Parameters:
 * [in]  pSrcXr          pointer to the vector of requantized spectral
 *                             samples for the current channel and granule,
 *                             represented in Q5.26 format.
 * [in]  pSrcDstOverlapAdd    pointer to the overlap-add buffer;
 *                                  contains the overlapped portion of
 *                                  the previous granule's IMDCT output.
 * [in]  nonZeroBound    the bound above which all spectral coefficients
 *                             are zero for the current granule and channel
 * [in]  pPrevNumOfImdct pointer to the number of IMDCTs computed for
 *                             the current channel of the previous granule
 * [in]  blockType       block type indicator
 * [in]  mixedBlock      mixed block indicator
 * [out] pDstY           pointer to the vector of IMDCT outputs represented in
 *                             Q7.24 format, for input to PQMF bank
 * [out] pSrcDstOverlapAdd    pointer to the overlap-add buffer;
 *                                  contains the overlapped portion of
 *                                  the previous granule's IMDCT output.
 * [out]  pPrevNumOfImdct	 pointer to the number of IMDCTs, current channel, 
 *											current granule.
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACMP3_MDCTInv_S32 (
     OMX_S32 *pSrcXr,
     OMX_S32 *pDstY,
     OMX_S32 *pSrcDstOverlapAdd,
     OMX_INT nonZeroBound,
     OMX_INT *pPrevNumOfImdct,
     OMX_INT blockType,
     OMX_INT mixedBlock
 );



/** =========================== Polyphase Filtering ========================= */
/**
 * Function: omxACMP3_SynthPQMF_S32_S16
 *
 * Description:
 * Stage 2 of the hybrid synthesis filter bank
 * See ISO/IEC 13818-3  2.5.3.3.2
 *
 * Remarks:
 * This function perform a critically-sampled 32-channel PQMF synthesis bank
 * that generates 32 time-domain output samples for each 32-sample input
 * block of IMDCT outputs.
 *
 * Parameters:
 * [in]  pSrcY            pointer to the block of 32 IMDCT sub-band
 *                              input samples, represented in Q7.24 format
 * [in]  pVBuffer         pointer to the input workspace buffer containing
 *                              Q7.24 data. The elements of this buffer should be
 *                              initialized to zero during decoder reset. During
 *                              decoder operation, the values contained in this
 *                              buffer should be modified only by the PQMF primitive.
 * [in]  pVPosition       pointer to the internal workspace index; should be
 *                              initialized to zero during decoder reset. During
 *                              decoder operation, the value of this index should
 *                              be preserved between PQMF calls and should be
 *                              modified only by the primitive.
 * [in]  mode             flag that indicates whether or not the PCM audio
 *                              output channels should be interleaved;
 *                              1 - not interleaved,
 *                              2 - interleaved
 * [out] pDstAudioOut     pointer to a block of 32 reconstructed PCM output
 *                              samples in 16-bit signed format (little-endian);
 *															represented in Q16.15 format.
 *                              left and right channels are interleaved according
 *                              to the mode flag. This should be aligned on a
 *                        		4-byte boundary
 * [out] pVBuffer         pointer to the updated internal workspace buffer
 *                              containing Q7.24 data; see usage notes under input
 *                              argument discussion
 * [out] pVPosition       pointer to the updated internal workspace index;
 *                              see usage notes under input argument discussion
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACMP3_SynthPQMF_S32_S16(
     OMX_S32 *pSrcY,
     OMX_S16 *pDstAudioOut,
     OMX_S32 *pVBuffer,
     OMX_INT *pVPosition,
     OMX_INT mode
 );


/**
 * EndDomain: MP3
 */

/* *****************************************************************************************/
/**
 *
 *  NewDomain: AAC The AAC Decoder Subdomain
 *  WithinDomain: AC
 *
 *  StartDomain: AAC
 */



/** macros */

#define OMX_AAC_FRAME_LEN       1024        /** frame length */
#define OMX_AAC_SF_LEN          120         /** scalefactor buffer length */
#define OMX_AAC_TNS_COEF_LEN    60          /** TNS coefficients buffer length */
#define OMX_AAC_SF_MAX          60          /** maximum number of sfb in one window */
#define OMX_AAC_GROUP_NUM_MAX   8           /** maximum groups number for one frame */
#define OMX_AAC_TNS_FILT_MAX    8           /** maximum TNS filters number for one frame */
#define OMX_AAC_PRED_SFB_MAX    41          /** maximum prediction scalefactor bands number for one frame */

#define OMX_AAC_ELT_NUM         16          /** maximum elements number for one program */
#define OMX_AAC_LFE_ELT_NUM     (1<<2)      /** maximum Low Frequency Enhance elements number for one program */
#define OMX_AAC_DATA_ELT_NUM    (1<<3)      /** maximum data elements number for one program */
#define OMX_AAC_COMMENTS_LEN    (1<<8)      /** maximum length of the comments field in bytes */

#define OMX_AAC_WIN_MAX         8
#define OMX_AAC_MAX_LTP_SFB     40
#define OMX_GROUP_NUM_MAX       8



/** Data Structures */

/** MPEG-2/4 AAC ADTS frame header See ISO/IEC 13838-7, Table 6.5. */
/* ISO/IEC 14496-3(1999E), table A.6 */
typedef struct {
	/** ADTS fixed header */
    OMX_INT id;                     /** ID 1*/
    OMX_INT layer;                  /** layer index 0x3: Layer I */
                                     /*             0x2: Layer II */
                                     /*             0x1: Layer III */
    OMX_INT protectionBit;          /** CRC flag 0: CRC on, 1: CRC off */
    OMX_INT profile;                /** profile: 0:MP, 1:LP, 2:SSR */
    OMX_INT samplingRateIndex;      /** sampling frequency index */
    OMX_INT privateBit;             /** private_bit, no use  */
    OMX_INT chConfig;               /** channel configuration */
    OMX_INT originalCopy;           /** original bitstream or copy, 0: copy, 1: original */
    OMX_INT home;
    OMX_INT emphasis;               /** not used by ISO/IEC 13818-7, but used by 14490-3 */

	/** ADTS variable header */
    OMX_INT cpRightIdBit;           /** copyright id bit */
    OMX_INT cpRightIdStart;         /** copyright id start */
    OMX_INT frameLen;               /** frame length in bytes */
    OMX_INT ADTSBufFullness;        /** buffer fullness */
    OMX_INT numRawBlock;            /** number of raw data blocks in the frame */

	/** ADTS CRC error check, 16bits */
    OMX_INT CRCWord;                /** CRC-check word */
} OMXAACADTSFrameHeader;

/** MPEG-2/4 AAC ADIF frame header See ISO/IEC 13838-7, Table 6.2. */
/* ISO/IEC 14496-3(1999E), table A.2 */

typedef struct {
    OMX_U32 ADIFId;                                 /** 32-bit, "ADIF" ASCII code */
    OMX_INT     copyIdPres;                         /** copy id flag: 0: off, 1: on */
    OMX_INT     originalCopy;                       /** original bitstream or copy, 0: copy, 1: original */
    OMX_INT	    home;
    OMX_INT     bitstreamType;                      /** bitstream flag: 0: constant rate bitstream, 1: varible rate bitstream */
    OMX_INT     bitRate;                            /** bit rate. if 0, unkown bit rate */
    OMX_INT     numPrgCfgElt;                       /** number of program config elements */
    OMX_INT     pADIFBufFullness[OMX_AAC_ELT_NUM];  /** buffer fullness */
    OMX_U8      pCopyId[9];                         /** 72-bit copy id */
} OMXAACADIFHeader;


/** MPEG-2/4 AAC program configure element See ISO/IEC 13838-7, Table 6.21. */
/* ISO/IEC 14496-3(1999E), table 4.2 */
typedef struct {
    OMX_INT     eltInsTag;                          /** element instance tag */
    OMX_INT     profile;                            /** profile index. 0: main profile, 1: Low Complexity profile */
    OMX_INT     samplingRateIndex;                  /** sampling rate index */
    OMX_INT     numFrontElt;                        /** number of front elements */
    OMX_INT     numSideElt;                         /** number of side elements  */
    OMX_INT     numBackElt;                         /** number of back elements  */
    OMX_INT     numLfeElt;                          /** number of LFE elements   */
    OMX_INT     numDataElt;                         /** number of data elements   */
    OMX_INT     numValidCcElt;                      /** number of coupling channel elements */
    OMX_INT     monoMixdownPres;                    /** mono mixdown flag. 0: off, 1: on */
    OMX_INT     monoMixdownEltNum;                  /** number of mono mixdown elements */
    OMX_INT     stereoMixdownPres;                  /** stereo mixdown flag. 0: off, 1: on */
    OMX_INT     stereoMixdownEltNum;                /** number of stereo mixdown elements */
    OMX_INT     matrixMixdownIdxPres;               /** matrix mixdown index flag. 0: off, 1: on */
    OMX_INT     matrixMixdownIdx;                   /** index of the surround mixdown coefficients */
    OMX_INT     pseudoSurroundEnable;               /** pseudo surround flag. 0: off, 1: on */
    OMX_INT     pFrontIsCpe[OMX_AAC_ELT_NUM];       /** channel pair flag for front elements */
    OMX_INT     pFrontTagSel[OMX_AAC_ELT_NUM];      /** instance tag for front elements */
    OMX_INT     pSideIsCpe[OMX_AAC_ELT_NUM];        /** channel pair flag for side elements */
    OMX_INT     pSideTagSel[OMX_AAC_ELT_NUM];       /** instance tag for side elements */
    OMX_INT     pBackIsCpe[OMX_AAC_ELT_NUM];        /** channel pair flag for back elements */
    OMX_INT     pBackTagSel[OMX_AAC_ELT_NUM];       /** instance tag for back elements */
    OMX_INT     pLfeTagSel[OMX_AAC_LFE_ELT_NUM];    /** channel pair flag for LFE elements */
    OMX_INT     pDataTagSel[OMX_AAC_DATA_ELT_NUM];  /** instance tag for data elements */
    OMX_INT     pCceIsIndSw[OMX_AAC_ELT_NUM];       /** independent flag for coupling channel elements */
    OMX_INT     pCceTagSel[OMX_AAC_ELT_NUM];        /** instance tag for coupling channel elements */
    OMX_INT     numComBytes;                        /** number of comment field bytes */
    OMX_S8  pComFieldData[OMX_AAC_COMMENTS_LEN];    /** the buffer of comment field */
} OMXAACPrgCfgElt;


/** MPEG-2/4 AAC individual channel stream See ISO/IEC 13838-7, Table 6.11. */
/* ISO/IEC 14496-3(1999E), table 4.24 */
typedef struct {
	/** unpacked from the bitstream */
	OMX_INT		icsReservedBit;
    OMX_INT     winSequence;                        /** window sequence flag */
    OMX_INT     winShape;                           /** window shape flag, 0: sine, 1: KBD  */
    OMX_INT     maxSfb;                             /** maximum effective scalefactor bands */
    OMX_INT     sfGrouping;                         /** scalefactor grouping flag */
    OMX_INT     predDataPres;                       /** prediction data present flag for one fraem, 0: prediction off, 1: prediction on */
    OMX_INT     predReset;                          /** prediction reset flag, 0: reset off, 1: reset on */
    OMX_INT     predResetGroupNum;                  /** prediction reset group number */
    OMX_U8  pPredUsed[OMX_AAC_PRED_SFB_MAX+3];      /** prediction flag buffer for each scalefactor band: 0: off, 1: on */
                                                        /* buffer length 44 bytes, 4-byte align   */
    /** decoded from the above info */
    OMX_INT     numWinGrp;                          /** number of window_groups */
    OMX_INT     pWinGrpLen[OMX_AAC_GROUP_NUM_MAX];  /** buffer for number of windows in each group */
} OMXAACIcsInfo;

/** MPEG-2/4 AAC channel pair element See ISO/IEC 13838-7, Table 6.10. */
/* ISO/IEC 14496-3(1999E), table 4.5 */
typedef struct {
    OMX_INT     commonWin;                          /** common window flag, 0: off, 1: on */
    OMX_INT     msMaskPres;                         /** MS stereo mask present flag */
    OMX_U8      ppMsMask[OMX_GROUP_NUM_MAX][OMX_AAC_SF_MAX];/** MS stereo flag buffer for each scalefactor band */
} OMXAACChanPairElt;

typedef struct {
	OMX_INT		tag;
    OMX_INT     id;                     /** element id */

	OMX_INT		samplingRateIndex;
    OMX_INT     predSfbMax;             /** maximum prediction scalefactor bands */
    OMX_INT     preWinShape;            /** previous block window shape */
    OMX_INT     winLen;                 /** 128: if short window, 1024: others */
    OMX_INT     numWin;                 /** 1 for long block, 8 for short block */
    OMX_INT     numSwb;                 /** decided by sampling rate and block type */

	/** unpacking from the bitstream */
    OMX_INT     globGain;               /** global gain */
    OMX_INT     pulseDataPres;          /** pulse data present flag, 0: off, 1: on */
    OMX_INT     tnsDataPres;            /** TNS data present flag, 0: off, 1: on */
    OMX_INT     gainContrDataPres;      /** gain control data present flag, 0: off, 1: on */

	/** Ics Info pointer */
    OMXAACIcsInfo *pIcsInfo;            /** pointer to OMXAACIcsInfo structure */

	/** channel pair element pointer */
    OMXAACChanPairElt *pChanPairElt;    /** pointer to OMXAACChanPairElt structure */

	/** section data */
    OMX_U8 pSectCb[OMX_AAC_SF_LEN];         /** section code book buffer */
    OMX_U8 pSectEnd[OMX_AAC_SF_LEN];        /** at which scalefactor band each section ends */
    OMX_INT pMaxSect[OMX_AAC_GROUP_NUM_MAX];/** maximum section number for each group */

	/** TNS data */
    OMX_INT pTnsNumFilt[OMX_AAC_GROUP_NUM_MAX];     /** TNS number filter buffer */
    OMX_INT pTnsFiltCoefRes[OMX_AAC_GROUP_NUM_MAX]; /** TNS coefficients resolution flag */
    OMX_INT pTnsRegionLen[OMX_AAC_TNS_FILT_MAX];    /** TNS filter length */
    OMX_INT pTnsFiltOrder[OMX_AAC_TNS_FILT_MAX];    /** TNS filter order */
    OMX_INT pTnsDirection[OMX_AAC_TNS_FILT_MAX];    /** TNS filter direction flag */
}OMXAACChanInfo;

typedef struct {
	OMX_INT tnsDataPresent;
    OMX_INT pTnsNumFilt[OMX_AAC_GROUP_NUM_MAX];     /** Number of TNS filter */
    OMX_INT pTnsFiltCoefRes[OMX_AAC_GROUP_NUM_MAX]; /** TNS coefficient resolution */
    OMX_INT pTnsRegionLen[OMX_AAC_TNS_FILT_MAX];    /** TNS filter length */
    OMX_INT pTnsFiltOrder[OMX_AAC_TNS_FILT_MAX];    /** TNS filter order */
    OMX_INT pTnsDirection[OMX_AAC_TNS_FILT_MAX];    /** TNS filter direction flag */
    OMX_INT pTnsCoefCompress[OMX_AAC_GROUP_NUM_MAX];/** The most significant bit of the coefficients of the */
                                                     /* noise shaping filter in window w is omitted or not */
    OMX_S8 pTnsFiltCoef[OMX_AAC_TNS_COEF_LEN];      /** TNS filter coefficients */
} OMXAACTnsInfo;

typedef struct{
    OMX_INT ltpDataPresent;                         /** bitstream flag indicating if ltp data is present */
    OMX_INT ltpLag;                                 /** LTP lag; valid range [0,2047] */
    OMX_S16 ltpCoef;                                /** LTP coefficient */
    OMX_INT pLtpLongUsed[OMX_AAC_MAX_LTP_SFB+1];    /** LTP indicators */
}OMXAACLtpInfo,*OMXAACLtpInfoPtr;

/**
 * Function: omxACAAC_UnpackADIFHeader
 *
 * Description:
 * Unpacks the AAC frame header.
 * Reference to ISO/IEC 14496-3(1999E), table 1.A.2 

 *
 * Remarks:
 * This function gets the AAC ADIF format header, including program
 * configuration elements from the input bit stream.
 *
 *
 * Parameters:
 * [in]  ppBitStream        double pointer to the first byte of the AAC
 *                                frame header
 * [in]  prgCfgEltMax       the maximum program configure element number
 * [out] ppBitStream        double pointer to the first byte of the AAC
 *                                frame header after decode header information
 * [out] pADIFHeader        pointer to the OMXACCADIFHeader structure
 * [out] pPrgCfgElt           pointer to the OMXAACPrgCfgElt structure.
 *                                There must be prgCfgEltMax elements in the buffer.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_UnpackADIFHeader (
		 const OMX_U8 **ppBitStream,
     OMXAACADIFHeader *pADIFHeader,
     OMXAACPrgCfgElt *pPrgCfgElt,
     OMX_INT prgCfgEltMax
 );


/**
 * Function: omxACAAC_UnpackADTSFrameHeader
 *
 * Description:
 * Gets ADTS frame header from the input bit stream.
 * Reference to ISO/IEC 14496-3(1999E), table 1.A.6 

 *
 * Remarks:
 * This function decode AAC ADTS frame header.
 *
 *
 * Parameters:
 * [in]  ppBitStream        double pointer to the current byte
 * [out] pADTSFrameHeader   pointer to the OMXAACADTSFrameHeader structure
 * [out] ppBitStream        double pointer to the current byte after decode
 *								  header information
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_UnpackADTSFrameHeader (
		 const OMX_U8 **ppBitStream,
     OMXAACADTSFrameHeader *pADTSFrameHeader
 );



/**
 * Function: omxACAAC_DecodePrgCfgElt
 *
 * Description:
 * Unpacks the AAC PCE information.
 * Reference to ISO/IEC 14496-3(1999E), table 4.4.2

 *
 * Remarks:
 * Gets program configuration element from the input bit stream.
 *
 *
 * Parameters:
 * [in]  ppBitStream        double pointer to the current byte
 * [in]  pOffset            pointer to the bit position in the byte
 * [out] ppBitStream        double pointer to the current byte after decoding
 *                                the program configuration element
 * [out] pOffset            pointer to the bit position in the byte
 *                                pointed by *ppBitStream. Valid within 0 to 7. 0:
 *                                MSB of the byte, 7: LSB of the byte.
 * [out] pPrgCfgElt         pointer to OMXAACPrgCfgElt structure
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_DecodePrgCfgElt(
		 const OMX_U8 **ppBitStream,
     OMX_INT *pOffset,
     OMXAACPrgCfgElt *pPrgCfgElt
 );

/**
 * Function: omxACAAC_DecodeDatStrElt
 *
 * Description:
 * Gets data_stream_element from the input bit stream.
 * Reference to ISO/IEC 14496-3 table 4.4.10
 *
 * Remarks:
 * This function gets data_stream_element from the input bit stream.
 *
 *
 * Parameters:
 * [in]  ppBitStream        double pointer to the current byte
 * [in]  pOffset            pointer to the bit position in the byte pointed
 *                                by *ppBitStream. Valid within 0 to 7. 0: MSB of
 *                                the byte, 7: LSB of the byte.
 * [out]  ppBitStream       double pointer to the current byte
 * [out]  pOffset           pointer to the bit position in the byte pointed
 *                                by *ppBitStream. Valid within 0 to 7. 0: MSB of
 *                                the byte, 7: LSB of the byte.
 * [out]  pDataTag          pointer to element_instance_tag.
 * [out]  pDataCnt          pointer to the value of length of total data in bytes
 * [out]  pDstDataElt       pointer to the data stream buffer that contains
 *                                the data stream extracted from the input bit stream.
 *                                There are 512 elements in the buffer pointed by pDstDataElt.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_DecodeDatStrElt(
		 const OMX_U8 **ppBitStream,
     OMX_INT *pOffset,
     OMX_INT *pDataTag,
     OMX_INT *pDataCnt,
     OMX_U8 *pDstDataElt
 );



/**
 * Function: omxACAAC_DecodeFillElt
 *
 * Description:
 * Gets the fill element.
 * Reference to ISO/IEC 14496-3 table 4.4.11
 *
 * Remarks:
 * Gets the fill element from the input bit stream.
 *
 *
 * Parameters:
 * [in]  ppBitStream        pointer to the pointer to the current byte
 * [in]  pOffset            pointer to the bit position in the byte pointed
 *                                by *ppBitStream. Valid within 0 to 7. 0: MSB of
 *                                the byte, 7: LSB of the byte.
 * [out] ppBitStream        pointer to the pointer to the current byte
 * [in]  pOffset            pointer to the bit position in the byte pointed
 *                                by *ppBitStream. Valid within 0 to 7. 0: MSB of
 *                                the byte, 7: LSB of the byte.
 * [out] pFillCnt           pointer to the value of the length of total fill
 *                                data in bytes
 * [out] pDstFillElt        pointer to the fill data buffer whose length must
 *                                be equal to or greater than 270
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_DecodeFillElt(
		 const OMX_U8 **ppBitStream,
     OMX_INT *pOffset,
     OMX_INT *pFillCnt,
     OMX_U8 *pDstFillElt
 );




/**
 * Function: omxACAAC_QuantInv_S32_I
 *
 * Description:
 * Inverse quantization.
 * Reference to  ISO/IEC 14496-3 Sect 6.1
 *
 * Remarks:
 * Inverse quantize the Huffman symbols for current channel. The formula is
 * shown as below equation.
 *
 *
 * Parameters:
 * [in] pSrcDstSpectralCoef         Pointer to the quantized spectral 
 *								       coefficients returned by the noiseless decoder;
 *								       integer data, i.e., no scaling (Q0).  For short 
 *                                     blocks the coefficients are interleaved by
 *                                     scalefactor window bands in each group.
 *                                     Buffer length must = 1024
 * [in]  pScalefactor               pointer to the scalefactor buffer.
 *                                     Buffer length must = 120.
 * [in]  numWinGrp                  group number
 * [in]  pWinGrpLen                 pointer to the number of windows in each group.
 * [in]  maxSfb                     max scalefactor bands number for the current block
 * [in]  pSfbCb                     pointer to the scalefactor band codebook,
 *                                  buffer length must = 120. Only maxSfb
 * [in]  samplingRateIndex          sampling rate index. Valid in [0, 11].
 * [in]  winLen                     the data number in one window
 * [out] pSrcDstSpectralCoef        pointer to the input quantized
 * 								       coefficients in Q13.18 forma. For short 
 *                                     block the coefficients are interleaved by
 *                                     scalefactor window bands in each
 *                                     group. Buffer length must = 1024
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_QuantInv_S32_I(
     OMX_S32 *pSrcDstSpectralCoef,
     const OMX_S16 *pScalefactor,
     OMX_INT numWinGrp,
     const OMX_INT *pWinGrpLen,
     OMX_INT maxSfb,
     const OMX_U8 *pSfbCb,
     OMX_INT samplingRateIndex,
     OMX_INT winLen
 );



/**
 * Function: omxACAAC_DecodeMsStereo_S32_I
 *
 * Description:
 * Performs M-S stereo decoding; converts the MS stereo jointly-coded scalefactor bands of a channel
 * pair from the M-S representation to the L-R representation; also performs the 
 * invert_intensity(group, sfb) function and stores the values in the pSfbCb buffer.  
 * If invert_intensity(group, sfb) = -1, and if *pSfbCb = INTERITY_HCB, let *pSfbCb = INTERITY_HCB2; 
 * else if *pSfbCb = INTERITY_HCB2, let *pSfbCb = INTERITY_HCB.  
 * For scalefactor bands in which the MS stereo flag is asserted, the individual
 * left and right channel spectral samples pSrcDstL[i] and pSrcDstR[i] are computed as follows:
 * Reference to ISO/IEC 14496-3 Sect 6.7.1.
 *
 * Remarks:
 * This function perform MS stereo process for pair channels.
 *
 *
 * Parameters:
 * [in]  pSrcDstL       pointer to left channel data in Q13.18 format.
 * [in]  pSrcDstR       pointer to right channel data in Q13.18 format.
 * [in]  pChanPairElt   pointer to a Channel Pair Element structure that has been
 *                      previously populated.  At minimum, the contents of msMaskPres
 *                      and pMsUsed fields are used  to control MS decoding process and
 *                      must be valid.  These provide, respectively, the MS stereo mask 
 *                      for a scalefactor band (0: MS Off, 1: MS On, 2: all bands on), 
 *                      and the MS stereo flag buffer, of length 120.
 * [in]  pSfbCb         Pointer to the scalefactor band codebook, buffer length must = 120
 * [in]  numWinGrp      group number
 * [in]  pWinGrpLen     pointer to the number of windows in each group. Buffer length must = 8
 * [in]  maxSfb         max scalefactor bands number for the current block
 * [in]  samplingRateIndex    sampling rate index. Valid in [0, 11].
 * [in]  winLen         the data number in one window
 * [out] pSrcDstL       pointer to left channel data in Q13.18 format.
 * [out] pSrcDstR       pointer to right channel data in Q13.18 format.
 * [out] pSfbCb         Pointer to the scalefactor band codebook, buffer length must = 120
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_DecodeMsStereo_S32_I(
     OMX_S32 *pSrcDstL,
     OMX_S32 *pSrcDstR,
     OMXAACChanPairElt *pChanPairElt,
     OMX_U8 *pSfbCb,
     OMX_INT numWinGrp,
     const OMX_INT *pWinGrpLen,
     OMX_INT maxSfb,
     OMX_INT samplingRateIndex,
     OMX_INT winLen
);


/**
 * Function: omxACAAC_DecodeIsStereo_S32
 *
 * Description:
 * Intensity stereo process for pair channels.
 * Reference to ISO/IEC 14496-3 Sect 6.7.2
 *
 * Remarks:
 * Only the pSfbCb[sfb] indicates intensity stereo on for
 * that scalefactor band.
 *
 *
 * Parameters:
 * [in]  pSrcL       pointer to left channel data in Q13.18 format.
 * [in]  pScalefactor   pointer to the scalefactor buffer. Buffer length must = 120.
 * [in]  pSfbCb         Pointer to the scalefactor band codebook, buffer length must = 120
 * [in]  numWinGrp      group number
 * [in]  pWinGrpLen     pointer to the number of windows in each group. Buffer length must = 8
 * [in]  maxSfb         max scalefactor bands number for the current block
 * [in]  samplingRateIndex    sampling rate index. Valid in [0, 11].
 * [in]  winLen         the data number in one window
 * [out] pDstR       pointer to right channel data in Q13.18 format.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_DecodeIsStereo_S32(
     const OMX_S32 *pSrcL,
     OMX_S32 *pDstR,
     const OMX_S16 *pScalefactor,
     const OMX_U8 *pSfbCb,
     OMX_INT numWinGrp,
     const OMX_INT *pWinGrpLen,
     OMX_INT maxSfb,
     OMX_INT samplingRateIndex,
     OMX_INT winLen
 );



/**
 * Function: omxACAAC_DeinterleaveSpectrum_S32
 *
 * Description:
 * Deinterleaves the coefficients for short block.
 * Reference to ISO/IEC 14496-3 Sect 6.7.2
 *
 * Remarks:
 * This function perform deinterleave for short block.
 *
 *
 * Parameters:
 * [in]  pSrc           pointer to channel data.
 * [in]  numWinGrp      group number
 * [in]  pWinGrpLen     pointer to the number of windows in each group.
 *                            Buffer length must = 8
 * [in]  maxSfb         max scalefactor bands number for the current block
 * [in]  samplingRateIndex    sampling rate index. Valid in [0, 11].
 * [in]  winLen         the data number in one window
 * [out] pDst           pointer to the output of coefficients. Data
 *                            sequence is ordered in pDst[w*128+sfb*sfbWidth[sfb]+i].
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_DeinterleaveSpectrum_S32 (
     const OMX_S32 *pSrc,
     OMX_S32 *pDst,
     OMX_INT numWinGrp,
     const OMX_INT *pWinGrpLen,
     OMX_INT maxSfb,
     OMX_INT samplingRateIndex,
     OMX_INT winLen
 );




/**
 * Function: omxACAAC_DecodeTNS_S32_I
 *
 * Description:
 * TNS process
 * Reference to ISO/IEC 14496-3 Sect 6.8
 *
 * Remarks:
 * Decoding process for Temporal Noise Shaping that controls the
 * temporal shape of the quantization noise within each window
 * of the transform.
 *
 *
 * Parameters:
 * [in]  pSrcDstSpectralCoefs pointer to the input spectral coefficients
 *                                  to be filtered by the all-pole filters in
 *                                  Q13.18 format. There are 1024 elements in
 *                                  the buffer pointed by pSrcDstSpectralCoefs.
 * [in]  pTnsNumFilt          pointer to the number of noise shaping
 *                                  filters that are used for each window of the
 *                                  current frame.
 * [in]  pTnsRegionLen        pointer to the length of the region (in units
 *                                  of scalefactor bands) to which
 * [in]  pTnsFiltOrder        pointer to the order of one noise shaping
 *                                  filter applied to each window of the current frame.
 * [in]  pTnsFiltCoefRes      pointer to the resolution (3 bits or 4 bits)
 *                                  of the transmitted filter coefficients for each
 *                                  window of the current frame.
 * [in]  pTnsFiltCoef         pointer to the coefficients of one noise shaping
 *                                  filter applied to each window of the current frame.
 * [in]  pTnsDirection        pointer to the token which indicates whether the
 *                                  filter is applied in upward or downward direction: 0
 *                                  for upward and 1 for downward.
 * [in]  maxSfb               the number of scalefactor bands transmitted per
 *                                  window group of the current frame
 * [in]  profile              the profile index from Table 7.1 in ISO/IEC 13818-7:1997
 * [in]  samplingRateIndex    the index which indicates the sampling rate of the current frame
 * [in]  winLen               the data number in one window
 * [out] pSrcDstSpectralCoefs pointer to the output spectral coefficients after
 *                                  filtering by the all-pole filters in Q13.18 format.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_DecodeTNS_S32_I(
     OMX_S32 *pSrcDstSpectralCoefs,
     const OMX_INT *pTnsNumFilt,
     const OMX_INT *pTnsRegionLen,
     const OMX_INT *pTnsFiltOrder,
     const OMX_INT *pTnsFiltCoefRes,
     const OMX_S8 *pTnsFiltCoef,
     const OMX_INT *pTnsDirection,
     OMX_INT maxSfb,
     OMX_INT profile,
     OMX_INT samplingRateIndex,
     OMX_INT winLen
 );




/**
 * Function: omxACAAC_MDCTInv_S32_S16
 *
 * Description:
 * IMDCT process
 * Reference to ISO/IEC 14496-3 Sect 6.10
 *
 * Remarks:
 * This module is used to map the time-frequency domain signal into time domain
 * and generate 1024 reconstructed 16-bit signed little-endian PCM samples as
 * output for each channel.
 *
 *
 * Parameters:
 * [in]  pSrcSpectralCoefs pointer to the input time-frequency domain
 *                               samples in Q13.18 format. There are 1024 elements
 *                               in the buffer pointed by pSrcSpectralCoefs.
 * [in]  pSrcDstOverlapAddBuf pointer to the overlap-add buffer which contains
 *                                  the second half of the previous block windowed sequence
 *               					in Q13.18. There are 1024 elements in this buffer.
 * [in]  winSequence          flag that indicates which window sequence is used for current block
 * [in]  winShape             flag that indicates which window function is selected for current block
 * [in]  prevWinShape         flag that indicates which window function is selected for previous block
 * [in]  pcmMode              flag that indicates whether the PCM audio output is interleaved
 *                                  (LRLRLR? or not. 1 = not interleaved;2 = interleaved
 * [out] pDstPcmAudioOut      Pointer to the output 1024 reconstructed 16-bit signed little-endian PCM
 *                                  samples represented in Q16.15format, interleaved if needed.
 * [out] pSrcDstOverlapAddBuf pointer to the overlap-add buffer which contains the second half
 *                                  of the current block windowed sequence in Q13.18.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_MDCTInv_S32_S16(
     OMX_S32 *pSrcSpectralCoefs,
     OMX_S16 *pDstPcmAudioOut,
     OMX_S32 *pSrcDstOverlapAddBuf,
     OMX_INT winSequence,
     OMX_INT winShape,
     OMX_INT prevWinShape,
     OMX_INT pcmMode
 );




/**
 * Function: omxACAAC_DecodeMsPNS_S32_I
 *
 * Description:
 * Decode PNS
 * Reference to ISO/IEC 14496-3 Sect 6.12
 *
 * Remarks:
 * This function implements perceptual noise substitution coding within an ICS.
 *
 *
 * Parameters:
 * [in]  pSrcDstSpec      pointer to spectrum coefficients to be PNS
 *												represented in Q13.18 format.
 * [in]  pSrcDstLtpFlag   pointer to LTP used flag
 * [in]  pSfbCb           pointer to scale factor code book
 * [in]  pScaleFactor     pointer to the scale factor value
 * [in]  maxSfb           number of scale factor band used in this layer
 * [in]  numWinGrp        number of window group
 * [in]  pWinGrpLen       pointer to the length of every window group
 * [in]  samplingFreqIndex sampling frequency index
 * [in]  winLen           window length, 1024 for long, 128 for short
 * [in]  pRandomSeed      random seed for PNS
 * [in]  channel          index of current channel, 0:left, 1:right
 * [in]  pMsUsed          Pointer to MS used buffer in CPE structure.
 * [in]  pNoiseState      Pointer to noise state buffer, which stores
 *    							the left channel's noise random seeds for
 *                              every scalefactor band. When pMsUsed[sfb]==1,
 *      					    the content in this buffer will be used for
 *					            right channel.
 * [out] pSrcDstSpec      pointer to the output spectrum substituted by
 *                        perceptual noise;represented in Q13.18 format. 
 * [out] pSrcDstLtpFlag   pointer to the LTP used flag
 * [out] pRandomSeed      random seed for PNS
 * [out] pNoiseState      Pointer to noise state buffer, which stores
 *                              the left channel's noise random seeds for
 *                              every scalefactor band. When pMsUsed[sfb]==1,
 *        					    the content in this buffer will be used for
 *                              right channel.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_DecodeMsPNS_S32_I(
     OMX_S32 *pSrcDstSpec,
     OMX_INT *pSrcDstLtpFlag,
     OMX_U8 *pSfbCb,
     OMX_S16 *pScaleFactor,
     OMX_INT maxSfb,
     OMX_INT numWinGrp,
     OMX_INT *pWinGrpLen,
     OMX_INT samplingFreqIndex,
     OMX_INT winLen,
     OMX_INT *pRandomSeed,
     OMX_INT channel,
     OMX_U8 *pMsUsed,
     OMX_INT *pNoiseState
 );



/**
 * Function: omxACAAC_LongTermReconstruct_S32_I
 *
 * Description:
 * Reconstruction portion of the LTP loop; 
 * adds the vector of decoded spectral coefficients and the corresponding spectral-domain LTP output vector to obtain a vector of reconstructed spectral samples
 * Reference to ISO/IEC 14496-3 Sect 6.6
 *
 * Remarks:
 * Use Long Term Reconstruct (LTR) to reduce the redundancy of a signal between successive
 * coding frames.
 *
 * Parameters:
 * [in]  pSrcDstSpec        pointer to decoded spectral coefficients
 * [in]  pSrcEstSpec        pointer to the spectral-domain LTP output vector
 * [in]  samplingFreqIndex  sampling frequency index
 * [in]  pLtpFlag           pointer to the vector of scalefactor band LTP indicator flags
 * [out] pSrcDstSpec        pointer to reconstructed spectral coefficient vector
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_LongTermReconstruct_S32_I(
     OMX_S32 *pSrcEstSpec,
     OMX_S32 *pSrcDstSpec,
     OMX_INT *pLtpFlag,
     OMX_INT samplingFreqIndex
 );



/**
 * Function: omxACAAC_MDCTFwd_S32
 *
 * Description:
 * Forward MDCT portion of the LTP loop; used only for audio objects of type LTP.
 * Reference: ISO/IEC 14496-3 Sect 4.6.6
 *
 * Parameters:
 * [in]  pSrc              pointer to time-domain input sequence						 
 * [in]  winSequence       analysis window sequence, current block; valid only for 0=long, 1=long_start, 3=long_stop.
 * [in]  winShape          analysis window shape, current block; valid only for 0=sine, 1=KBD.
 * [in]  preWinShape       analysis window shape, previous block; valid only for 0=sine, 1=KBD.
 * [in]  pWindowedBuf      work buffer; minimum length 2048 elements
 * [out] pDst              pointer to MDCT output sequence
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_MDCTFwd_S32(
     OMX_S32 *pSrc,
     OMX_S32 *pDst,
     OMX_INT winSequence,
     OMX_INT winShape,
     OMX_INT preWinShape,
     OMX_S32 *pWindowedBuf
 );



/**
 * Function: omxACAAC_EncodeTNS_S32_I
 *
 * Description:
 * Analysis TNS module
 * Reference to ISO/IEC 14496-3 Sect 4.6.9
 *
 * Remarks:
 * In the Long Term Prediction (LTP) loop, Analysis Temporal Noise Shaping is needed for
 * reversion of TNS.
 *
 *
 * Parameters:
 * [in]  pSrcDstSpectralCoefs  pointer to the spectral coefficients to do encode TNS
 *												represented in Q13.18 format.  
 * [in]  pTnsNumFilt      pointer to number of TNS filter
 * [in]  pTnsRegionLen    pointer to length of TNS filter
 * [in]  pTnsFiltOrder    pointer to TNS filter order
 * [in]  pTnsFiltCoefRes  pointer to TNS coef resolution flag
 * [in]  pTnsFiltCoef     pointer to TNS filter coefficients
 * [in]  pTnsDirection    pointer to TNS direction flag
 * [in]  maxSfb           maximum scale factor number
 * [in]  profile          audio profile
 * [in]  samplingRateIndex sampling frequency index
 * [out] pSrcDstSpectralCoefs  pointer to the spectral coefficients have done encode TNS
 *												represented in Q13.18 format.  
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_EncodeTNS_S32_I(
     OMX_S32 *pSrcDstSpectralCoefs,
     const OMX_INT *pTnsNumFilt,
     const OMX_INT *pTnsRegionLen,
     const OMX_INT *pTnsFiltOrder,
     const OMX_INT *pTnsFiltCoefRes,
     const OMX_S8 *pTnsFiltCoef,
     const OMX_INT *pTnsDirection,
     OMX_INT maxSfb,
     OMX_INT profile,
     OMX_INT samplingRateIndex
 );



/**
 * Function: omxACAAC_LongTermPredict_S32
 *
 * Description:
 * Long Term Prediction
 * Reference to ISO/IEC 14496-3 Sect 4.6.6
 *
 * Remarks:
 * In the Long Term Prediction (LTP) loop, Analysis LTP is needed to get the predicted time
 * domain signals.
 *
 *
 * Parameters:
 * [in]  pSrcTimeSignal     pointer to the temporal signals to be predicted in 
 *													temporary domain;represented in Q13.18 format.  
 * [in]  pDstEstTimeSignal  pointer to the output of samples after LTP;
 *													represented in Q13.18 format.  
 * [in]  pAACLtpInfo        pointer to the LTP information
 * [out] pDstEstTimeSignal  pointer to the output of prediction in time domain
 *													represented in Q13.18 format.  
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_LongTermPredict_S32(
     OMX_S32 *pSrcTimeSignal,
     OMX_S32 *pDstEstTimeSignal,
     OMXAACLtpInfo *pAACLtpInfo
 );

/**
 * Function: omxACAAC_NoiselessDecode
 *
 * Description:
 * Huffman decoder
 * Reference to ISO/IEC 14496-3 Sect 4.6.3
 *
 * Remarks:
 * This is a general noiseless decode module for MPEG-2 and MPEG-4 objects.
 *
 *
 * Parameters:
 * [in]  ppBitStream        double pointer to the bit stream to be parsed
 * [in]  pOffset            pointer to the offset in one byte
 * [in]  pChanInfo          pointer to channel information structure
 * [in]  commonWin          if channel pair use the same ics information
 * [in]  audioObjectType    audio object type indication. 1:main, 2:LC, 4: LTP, 6:scaleable
 * [out] ppBitStream        double pointer to the bit stream has been parsed
 * [out] pOffset            pointer to the offset in one byte
 * [out] pChanInfo          pointer to channel information structure
 * [out] pDstScalefactor    Pointer to the scale factor has been parsed.
 * [out] pDstQuantizedSpectralCoef    Pointer to the quantized spectral 
 *									  coefficients after Huffman decoding;
 *									  integer data, i.e., no scaling (Q0)
 * [out] pDstSfbCb          Pointer to the scale factor code book index.
 * [out] pDstTnsFiltCoef    Pointer to TNS filter coefficients. Not used in scaleable object.
 * [out] pLtpInfo		    Pointer to LTP information structure.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_NoiselessDecode(
		 const OMX_U8 **ppBitStream,
     OMX_INT *pOffset,
     OMX_S16 *pDstScalefactor,
     OMX_S32 *pDstQuantizedSpectralCoef,
     OMX_U8 *pDstSfbCb,
     OMX_S8 *pDstTnsFiltCoef,
     OMXAACChanInfo *pChanInfo,
     OMX_INT commonWin,
     OMX_INT audioObjectType,
     OMXAACLtpInfoPtr *pLtpInfo 
 );


/**
 * Function: omxACAAC_DecodeChanPairElt
 *
 * Description:
 * Decode channel_pair_element
 * ISO/IEC 14496-3(1999E), table 4.4.5
 *
 * Remarks:
 * Retrieves the channel_pair_element from the input bit stream.
 *
 *
 * Parameters:
 * [in]  ppBitStream        double pointer to the current byte.
 * [in]  pOffset            pointer to the bit position in the byte pointed by *ppBitStream. Valid within 0 to
 *                                7. 0: MSB of the byte, 7: LSB of the byte.
 * [in]  audioObjectType    index of audio object type. 2: LC, 4: LTP
 * [out] ppBitStream        double pointer to the current byte, after decoding the channel pair element.
 * [out] pOffset            pointer to the bit position in the byte pointed by *ppBitStream. Valid within 0 to
 *                                7. 0: MSB of the byte, 7: LSB of the byte.
 * [out] pIcsInfo           pointer to OMXAACIcsInfo structure.
 * [out] pChanPairElt       pointer to channel pair element.
 * [out] pLtpInfo		        pointer to LTP information structure.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACAAC_DecodeChanPairElt(
	   const OMX_U8 **ppBitStream,
     OMX_INT *pOffset,
     OMXAACIcsInfo *pIcsInfo,
     OMXAACChanPairElt *pChanPairElt,
     OMX_INT audioObjectType,
     OMXAACLtpInfoPtr *pLtpInfo
 );
 

/**
 * EndDomain: AAC
 */


#ifdef __cplusplus
}
#endif

#endif /** end of #define _OMXAC_H_ */

/** EOF */


