/**
 *  omxACMP3_HuffmanDecodeSfbMbp_S32.c
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
#include "armAC.h"
#include "armCOMM.h"

/**
 * Function: armACMP3_GetBits()
 *
 * Description:
 * This function used to make sure that it will not read past 
 * the allowed buffer area.    
 *
 * Parameters:
 * [in]     *ppBitStream
 * [in]     *pOffset
 * [in]     N=1..32
 * [in]     BitsRemain 
 *
 * [out]    *ppBitStream
 * [out]    *pOffset
 * Returns  Value
 */

static OMX_U32 armACMP3_GetBits(const OMX_U8 **ppBitStream, OMX_INT *pOffset, OMX_INT N, OMX_INT BitsRemain)
{
    if (BitsRemain >= N)
    {   
        return armGetBits (ppBitStream, pOffset, N);        
    }
    else
    {
        if (BitsRemain > 0)
        {
            return armGetBits (ppBitStream, pOffset, BitsRemain);                    
        }
        else
        {
            return 0;
        }
    }    
}

/**
 * Function: omxACMP3_HuffmanDecodeSfbMbp_S32
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
)
{
    OMX_INT     i;
    OMX_S32     BigVals, HuffIndex;
    OMX_U32     HuffTableNo;
    OMX_U32     Count1;
    OMX_U32     Offset, Offset1, Offset2, Temp1, Llines, Slines;
    OMX_U32     linbits, linbitsx, linbitsy;
    OMX_U32     signx = 0, signy = 0, signv = 0, signw = 0;
    OMX_U32     Reg0Count, Reg1Count;
    OMX_S32     x = 0, y = 0, v = 0, w = 0;
    const ARM_VLC32   *pCodeBook;
    const OMX_S16 (*ppHuffXY)[2];
    const OMX_S16 *pSfbTableMixed = (OMX_S16 *) pMbpTable;
    

    /* Arguments check */
    armRetArgErrIf(ppBitStream == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(*ppBitStream == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pOffset == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstIs == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstNonZeroBound == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pSideInfo == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pFrameHeader == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pSfbTableLong == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pSfbTableShort == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pSfbTableMixed == NULL, OMX_StsBadArgErr)

    armRetArgErrIf(*pOffset < 0, OMX_StsBadArgErr)
    armRetArgErrIf(*pOffset > 7, OMX_StsBadArgErr)


    BigVals = pSideInfo->bigVals * 2;

    /* Validate Big Values */
    armRetArgErrIf(BigVals < 0, OMX_StsErr)
    armRetArgErrIf(BigVals > OMX_MP3_GRANULE_LEN, OMX_StsErr)
    
    /* Validate WinSwitch */
    armRetArgErrIf(pSideInfo->winSwitch < 0, OMX_StsErr)
    armRetArgErrIf(pSideInfo->winSwitch > 1, OMX_StsErr)

    /* Validate MixedBlock */
    armRetArgErrIf(pSideInfo->mixedBlock < 0, OMX_StsErr)
    armRetArgErrIf(pSideInfo->mixedBlock > 1, OMX_StsErr)
    
    /* Validate Block Type */
    armRetArgErrIf(pSideInfo->blockType < 0, OMX_StsErr)
    armRetArgErrIf(pSideInfo->blockType > 3, OMX_StsErr)

    /* Win Switch case for value of Block type */
    armRetArgErrIf(pSideInfo->winSwitch == 1 &&
        pSideInfo->blockType == 0, OMX_StsErr)

    /* Validate Count1 Table */
    armRetArgErrIf(pSideInfo->cnt1TabSel < 0, OMX_StsErr)
    armRetArgErrIf(pSideInfo->cnt1TabSel > 1, OMX_StsErr)
    
    /* Reg 0 Count for value of Block type */
    armRetArgErrIf (pSideInfo->blockType == 0 &&
        pSideInfo->reg0Cnt < 0, OMX_StsErr)

    /* Reg 1 Count for value of Block type */
    armRetArgErrIf (pSideInfo->blockType == 0 &&
        pSideInfo->reg1Cnt < 0, OMX_StsErr)

    /* Validate Block Type, reg 0 and reg 1 size */
    armRetArgErrIf (pSideInfo->blockType == 0 &&
        (pSideInfo->reg0Cnt + pSideInfo->reg1Cnt + 2) > 22, OMX_StsErr)
    
    /* Validate Block Type and table select */
    armRetArgErrIf(pSideInfo->pTableSelect[0] < 0, OMX_StsErr)
    armRetArgErrIf(pSideInfo->pTableSelect[0] > 31, OMX_StsErr)

    /* Validate Block Type and table select */
    armRetArgErrIf(pSideInfo->pTableSelect[1] < 0, OMX_StsErr)
    armRetArgErrIf(pSideInfo->pTableSelect[1] > 31, OMX_StsErr)

    /* Validate Block Type and table select */
    if (pSideInfo->blockType == 0)
    {
        armRetArgErrIf(pSideInfo->pTableSelect[2] < 0, OMX_StsErr)
        armRetArgErrIf(pSideInfo->pTableSelect[2] > 31, OMX_StsErr)
    }

    /* Verify header */
    armRetArgErrIf(pFrameHeader->id < 0, OMX_StsErr)
    armRetArgErrIf(pFrameHeader->id > 1, OMX_StsErr)
    
    /* If not Layer III */
    armRetArgErrIf(pFrameHeader->layer != 1, OMX_StsErr)

    /* Verify Sampling Freq */
    armRetArgErrIf(pFrameHeader->samplingFreq < 0, OMX_StsErr)
    armRetArgErrIf(pFrameHeader->samplingFreq > 2, OMX_StsErr)

    /* Verify hufSize */
    armRetArgErrIf(hufSize < 0, OMX_StsErr)
    armRetArgErrIf(hufSize > pSideInfo->part23Len, OMX_StsErr)

    /* Decode Regions */

    Offset = pFrameHeader->samplingFreq + pFrameHeader->id * 3;
    if (pSideInfo->winSwitch == 1)
    {
        if (pSideInfo->blockType == 2 && pSideInfo->mixedBlock == 0)
        {
            /* 3 == (8+1)/3 */
            Reg0Count = 3 * pSfbTableShort 
                [Offset * ARM_MP3_SHORT_SFB_TABLE_SZ + 3];
        }
        else
        {
            if (pSideInfo->blockType == 2)
            {
                /* 8 = (7+1) */
                Temp1 = pFrameHeader->samplingFreq * 2 + pFrameHeader->id * 6;
                
                Llines = pSfbTableMixed [Temp1];
                Slines = pSfbTableMixed [Temp1 + 1];
                
                Offset1 = Slines / 3;
                Offset2 = Slines % 3;
                
                Reg0Count = pSfbTableLong [Offset * ARM_MP3_LONG_SFB_TABLE_SZ + Llines];
                Temp1 =  pSfbTableShort [Offset * ARM_MP3_SHORT_SFB_TABLE_SZ + Offset1 + 3];
                
                Reg0Count += (Temp1 - pSfbTableShort [Offset * ARM_MP3_SHORT_SFB_TABLE_SZ + 3]) * 3;
                Reg0Count += (pSfbTableShort [Offset * ARM_MP3_SHORT_SFB_TABLE_SZ + Offset1 + 4] - Temp1) * Offset2;
            }
            else
            {
                /* case of blocktype 1 and 3 */
                Reg0Count = pSfbTableLong [Offset * ARM_MP3_LONG_SFB_TABLE_SZ + 8];
            }
        }
        
        Reg1Count = OMX_MP3_GRANULE_LEN;
    }
    else
    {
        Offset *= ARM_MP3_LONG_SFB_TABLE_SZ;
        
        Reg0Count = pSfbTableLong 
            [Offset + pSideInfo->reg0Cnt + 1];
        Reg1Count = pSfbTableLong 
            [Offset + pSideInfo->reg1Cnt + pSideInfo->reg0Cnt + 2];
    }

    /* Big values : includes Reg0, Reg1, and Reg2 */
    for (i = 0; (i < BigVals) && (hufSize > 0); i += 2)
    {
        /* Region 0*/
        if (i < Reg0Count)
        {
            HuffTableNo = pSideInfo->pTableSelect [0];
            pCodeBook = armACMP3_HuffCodeBook [HuffTableNo];
        }
        /* Region 1*/
        else if (i < Reg1Count)
        {
            HuffTableNo = pSideInfo->pTableSelect [1];
            pCodeBook = armACMP3_HuffCodeBook [HuffTableNo];
        }
        /* Region 2*/
        else
        {
            HuffTableNo = pSideInfo->pTableSelect [2];
            pCodeBook = armACMP3_HuffCodeBook [HuffTableNo];
        }
        
        if (HuffTableNo == 0)        
        {
            pDstIs [i] = 0; /* x */
            pDstIs [i + 1] = 0; /* y */
            
            continue;
        }
        else if (HuffTableNo == 4  || HuffTableNo == 14)
        {
            /* Not supported Error */
            return OMX_StsErr;
        }
        
        /* Search code-words in table */
        HuffIndex = armUnPackVLC32(ppBitStream, pOffset, pCodeBook);
        if (HuffIndex == -1)
        {
            return OMX_StsErr;
        }
        
        /* Update the available bits */
        hufSize -= pCodeBook [HuffIndex].codeLen;
        
        ppHuffXY = armACMP3_HuffXYValues [HuffTableNo];
        x = ppHuffXY[HuffIndex][0];
        y = ppHuffXY[HuffIndex][1];
        linbits = armACMP3_LinBits [HuffTableNo];
        
        /* escape code for x */
        if (x == ARM_MP3_HUFF_ESCAPE_CODE && linbits > 0)
        {
            linbitsx = armACMP3_GetBits (ppBitStream, pOffset, linbits, hufSize);
            hufSize -= linbits; 
            x += linbitsx;
        }
        
        /* Decode sign */
        if (x != 0)
        {
            signx = armACMP3_GetBits (ppBitStream, pOffset, 1, hufSize);
            hufSize -= 1; 
        }

        /* escape code for y */
        if (y == ARM_MP3_HUFF_ESCAPE_CODE && linbits > 0)
        {
            linbitsy = armACMP3_GetBits (ppBitStream, pOffset, linbits, hufSize);
            hufSize -= linbits; 
            y += linbitsy;
        }

        /* Decode sign */
        if (y != 0)
        {
            signy = armACMP3_GetBits (ppBitStream, pOffset, 1, hufSize);
            hufSize -= 1; 
        }
        pDstIs [i] = signx ? -x : x;
        pDstIs [i + 1] = signy ? -y : y;
    }

    /* Count1 values */
    Count1 = OMX_MP3_GRANULE_LEN;
    for (; (i < Count1) && (hufSize > 0); i += 4)
    {
        if (pSideInfo->cnt1TabSel == 0)
        {
            /* Table A */
            pCodeBook = armACMP3_HuffTable32;
            HuffIndex = armUnPackVLC32(ppBitStream, pOffset, pCodeBook);
            if (HuffIndex == -1)
            {
                return OMX_StsErr;
            }

            hufSize -= pCodeBook [HuffIndex].codeLen;
            if (hufSize < 0)
            {
                armSkipBits (ppBitStream, pOffset, hufSize);
            }
            v = (armACMP3_TableXY32 [HuffIndex][0] & 8)>>3;
            w = (armACMP3_TableXY32 [HuffIndex][0] & 4)>>2;
            x = (armACMP3_TableXY32 [HuffIndex][0] & 2)>>1;
            y = (armACMP3_TableXY32 [HuffIndex][0] & 1);
            /* Decode sign */
            if (v != 0)
            {
                signv = armACMP3_GetBits (ppBitStream, pOffset, 1, hufSize);
                hufSize--;
            }
            if (w != 0)
            {
                signw = armACMP3_GetBits (ppBitStream, pOffset, 1, hufSize);
                hufSize--;
            }
            if (x != 0)
            {
                signx = armACMP3_GetBits (ppBitStream, pOffset, 1, hufSize);
                hufSize--;
            }
            if (y != 0)
            {
                signy = armACMP3_GetBits (ppBitStream, pOffset, 1, hufSize);
                hufSize--;
            }
            pDstIs [i + 0] = signv ? -v : v;
            pDstIs [i + 1] = signw ? -w : w;
            pDstIs [i + 2] = signx ? -x : x;
            pDstIs [i + 3] = signy ? -y : y;
        }
        else
        {
            /* Table B */
            v = armACMP3_GetBits (ppBitStream, pOffset, 1, hufSize);
            hufSize--;
            w = armACMP3_GetBits (ppBitStream, pOffset, 1, hufSize);
            hufSize--;
            x = armACMP3_GetBits (ppBitStream, pOffset, 1, hufSize);
            hufSize--;
            y = armACMP3_GetBits (ppBitStream, pOffset, 1, hufSize);
            hufSize--;
            
            v = v ? 0 : 1;
            w = w ? 0 : 1;
            x = x ? 0 : 1;
            y = y ? 0 : 1;                

            /* Decode sign */
            if (v != 0)
            {                
                signv = armACMP3_GetBits (ppBitStream, pOffset, 1, hufSize);
                hufSize--;
            }
            if (w != 0)
            {
                signw = armACMP3_GetBits (ppBitStream, pOffset, 1, hufSize);
                hufSize--;
            }
            if (x != 0)
            {
                signx = armACMP3_GetBits (ppBitStream, pOffset, 1, hufSize);
                hufSize--;
            }
            if (y != 0)
            {
                signy = armACMP3_GetBits (ppBitStream, pOffset, 1, hufSize);
                hufSize--;
            }
            pDstIs [i + 0] = signv ? -v : v;
            pDstIs [i + 1] = signw ? -w : w;
            pDstIs [i + 2] = signx ? -x : x;
            pDstIs [i + 3] = signy ? -y : y;                    
        }
    }

    /* Adjust bitstream if we read past bits associated with current gr and ch */
    if (hufSize < 0)
    {
        armSkipBits (ppBitStream, pOffset, hufSize);
    }

    /* Update zero bound */
    /*i -= 4;*/
    pDstNonZeroBound [0] = i - 1;
    while (pDstIs [pDstNonZeroBound [0]] == 0)
    {
        --(pDstNonZeroBound [0]);
    }
    
    pDstNonZeroBound [0] += 1;
    
    /* Fill the remaining Zero values */
    for (; i < OMX_MP3_GRANULE_LEN; i++)
    {
        pDstIs [i] = 0;
    }
    
    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

