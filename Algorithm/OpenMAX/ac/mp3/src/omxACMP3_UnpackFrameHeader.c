/**
 *  omxACMP3_UnpackFrameHeader.c
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
 * Description: This function is used to unpack a 32 bit mp3 frame header
 * as defined in ISO/IEC 13818-3
 */

#include "omxtypes.h"
#include "omxAC.h"
#include "armCOMM.h"

#define ARM_MP3_IDEX_MASK       (0x00100000) 
#define ARM_MP3_ID_MASK         (0x00080000)
#define ARM_MP3_LAYER_MASK      (0x00060000)
#define ARM_MP3_PROTBIT_MASK    (0x00010000)
#define ARM_MP3_BITRATE_MASK    (0x0000F000)
#define ARM_MP3_SAMPFREQ_MASK   (0x00000C00)
#define ARM_MP3_PADFLAG_MASK    (0x00000200)
#define ARM_MP3_PRIVBIT_MASK    (0x00000100)
#define ARM_MP3_MODE_MASK       (0x000000C0)
#define ARM_MP3_MODEEXT_MASK    (0x00000030)
#define ARM_MP3_COPYRIGHT_MASK  (0x00000008)
#define ARM_MP3_ORIGCOPY_MASK   (0x00000004)
#define ARM_MP3_EMPHASIS_MASK   (0x00000003)

#define ARM_MP3_IDEX_SHIFT      (20)
#define ARM_MP3_ID_SHIFT        (19)
#define ARM_MP3_LAYER_SHIFT     (17)
#define ARM_MP3_PROTBIT_SHIFT   (16)
#define ARM_MP3_BITRATE_SHIFT   (12)
#define ARM_MP3_SAMPFREQ_SHIFT  (10)
#define ARM_MP3_PADFLAG_SHIFT   (9)
#define ARM_MP3_PRIVBIT_SHIFT   (8)
#define ARM_MP3_MODE_SHIFT      (6)
#define ARM_MP3_MODEEXT_SHIFT   (4)
#define ARM_MP3_COPYRIGHT_SHIFT (3)
#define ARM_MP3_ORIGCOPY_SHIFT  (2)
#define ARM_MP3_EMPHASIS_SHIFT  (0)

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
 * Parameters:
 * [in]  ppBitStream        double pointer to the first byte of the MP3
 *                                frame header
 * [out] pFrameHeader       pointer to the MP3 frame header structure
 * [out] ppBitStream        ouble pointer to the byte immediately following 
 *                                the frame header
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACMP3_UnpackFrameHeader (
     const OMX_U8 **ppBitStream,
     OMXMP3FrameHeader *pFrameHeader
 )
{
    OMX_U32     Mp3Header;
    OMX_U8      *pBitStream; 

    /* Arguments check */
    armRetArgErrIf(ppBitStream == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pFrameHeader == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(*ppBitStream == NULL, OMX_StsBadArgErr)
    
    pBitStream = (OMX_U8 *)*ppBitStream; 

    /* get 32 bit header */
    Mp3Header = (OMX_U32) pBitStream [0];
    Mp3Header = (Mp3Header << 8) | (OMX_U32) pBitStream [1];
    Mp3Header = (Mp3Header << 8) | (OMX_U32) pBitStream [2];
    Mp3Header = (Mp3Header << 8) | (OMX_U32) pBitStream [3];

    /* Fill struct with header fields */
    pFrameHeader->idEx = 
        (Mp3Header & ARM_MP3_IDEX_MASK) >> ARM_MP3_IDEX_SHIFT;
    pFrameHeader->id = 
        (Mp3Header & ARM_MP3_ID_MASK) >> ARM_MP3_ID_SHIFT;
    pFrameHeader->layer = 
        (Mp3Header & ARM_MP3_LAYER_MASK) >> ARM_MP3_LAYER_SHIFT;
    pFrameHeader->protectionBit = 
        (Mp3Header & ARM_MP3_PROTBIT_MASK) >> ARM_MP3_PROTBIT_SHIFT;
    pFrameHeader->bitRate = 
        (Mp3Header & ARM_MP3_BITRATE_MASK) >> ARM_MP3_BITRATE_SHIFT;
    pFrameHeader->samplingFreq = 
        (Mp3Header & ARM_MP3_SAMPFREQ_MASK) >> ARM_MP3_SAMPFREQ_SHIFT;
    pFrameHeader->paddingBit = 
        (Mp3Header & ARM_MP3_PADFLAG_MASK) >> ARM_MP3_PADFLAG_SHIFT;
    pFrameHeader->privateBit = 
        (Mp3Header & ARM_MP3_PRIVBIT_MASK) >> ARM_MP3_PRIVBIT_SHIFT;
    pFrameHeader->mode = 
        (Mp3Header & ARM_MP3_MODE_MASK) >> ARM_MP3_MODE_SHIFT;
    pFrameHeader->modeExt = 
        (Mp3Header & ARM_MP3_MODEEXT_MASK) >> ARM_MP3_MODEEXT_SHIFT;
    pFrameHeader->copyright = 
        (Mp3Header & ARM_MP3_COPYRIGHT_MASK) >> ARM_MP3_COPYRIGHT_SHIFT;
    pFrameHeader->originalCopy = 
        (Mp3Header & ARM_MP3_ORIGCOPY_MASK) >> ARM_MP3_ORIGCOPY_SHIFT;
    pFrameHeader->emphasis = 
        (Mp3Header & ARM_MP3_EMPHASIS_MASK) >> ARM_MP3_EMPHASIS_SHIFT;
    
    /* update bit stream pointer */
    *ppBitStream += 4;
    pBitStream = (OMX_U8 *)*ppBitStream; 

    /* Check for presence of CRC */
    if (pFrameHeader->protectionBit == 0)
    {
        /* Read 32 bit CRC */
        pFrameHeader->CRCWord = 
            ((OMX_INT) pBitStream [0] << 8) | (OMX_INT) pBitStream [1];
        *ppBitStream += 2;
    }

    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/





