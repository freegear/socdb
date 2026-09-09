/**
 *  omxACMP3_ReQuantizeSfb_S32_I.c
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

#include <stdio.h>
#include <math.h>
#include "omxtypes.h"
#include "armCOMM.h"
#include "armCOMM_Bitstream.h"
#include "omxAC.h"
#include "armAC.h"
#include "armACMP3_Tables.h"

#include <assert.h>


/**
 * Function: armACMP3_Requant
 */
static OMXResult armACMP3_Requant (
    OMX_S32 *pSrc,
    OMX_F64 *pDst,
    OMX_S8  *pScaleFactor,
    OMX_INT *pNonZeroBound,    
    OMX_INT samplingFreq, 
    OMX_INT id, 
    OMX_INT globGain, 
    OMX_INT sfScale, 
    OMX_INT preFlag, 
    OMX_INT *pSubBlkGain,
    OMX_INT winSwitch, 
    OMX_INT blockType, 
    OMX_INT mixedBlock,
    OMXMP3ScaleFactorBandTableLong pSfbTableLong,
    OMXMP3ScaleFactorBandTableShort pSfbTableShort)
{
    OMX_F64     gain, short_gain[3];
    OMX_F64     scale;
    OMX_F64     sfmultiplier;
    OMX_S32     Offset, i, j, sign;
    OMX_S32     sfb, width, sflimit;
    OMX_F64     mag;
    OMX_U32     win;

    gain = (globGain - 210);
    sfmultiplier = sfScale ? 1.0 : 0.5;
    i = 0;
    sfb = 0;

    if (winSwitch == 1 && blockType == 2)
    {        
        /* Mixed Block */
        if (mixedBlock == 1)
        {
            /* Long Block */
            Offset = (samplingFreq + 3 * id) * ARM_MP3_LONG_SFB_TABLE_SZ;
            while (sfb < 8)
            {
                scale = pow (2.0, (0.25 * gain) - (sfmultiplier * 
                        (preFlag * armACMP3_Pretab [sfb] + *pScaleFactor++)));
                sflimit = pSfbTableLong [Offset + ++sfb];
                for (; (i < sflimit) && (i < *pNonZeroBound); i++)
                {
                    /* get sign and abs magnitude */
                    sign = (pSrc[i] < 0) ? 1 : 0;
                    mag = (OMX_F64) (sign ? -pSrc[i] : pSrc[i]);
                    pDst[i] = pow (mag, (4.0/3.0)) * scale;
                    pDst[i] = sign ? -pDst[i] : pDst[i];
                }
            }
            
            /* Reset sfb for Short Blocks */
            sfb = 3;
        }
        
        /* Short block */
        short_gain [0] = (gain - 8 * pSubBlkGain[0]) * 0.25;
        short_gain [1] = (gain - 8 * pSubBlkGain[1]) * 0.25;
        short_gain [2] = (gain - 8 * pSubBlkGain[2]) * 0.25;
        
        Offset = (samplingFreq + 3 * id) * ARM_MP3_SHORT_SFB_TABLE_SZ;
        while (sfb < 13)
        {
            sflimit = pSfbTableShort [Offset + sfb + 1];
            width = sflimit - pSfbTableShort [Offset + sfb];
            sfb++;

            for (win = 0; win < 3; win++)
            {
                scale = pow (2.0, short_gain [win] - 
                            sfmultiplier * *pScaleFactor++);
                
                for (j = 0; (j < width) && (i < *pNonZeroBound); j++, i++)
                {
                    /* get sign and abs magnitude */
                    sign = (pSrc[i] < 0) ? 1 : 0;
                    mag = (OMX_F64) (sign ? -pSrc[i] : pSrc[i]);
                    pDst[i] = pow (mag, (4.0/3.0)) * scale;
                    pDst[i] = sign ? -pDst[i] : pDst[i];
                }
            }
        }  /* Short block */
    }
    else
    {
        /* Long Block */
        Offset = (samplingFreq + 3 * id) * ARM_MP3_LONG_SFB_TABLE_SZ;
        while (sfb < 23)
        {
            scale = pow (2.0, (0.25 * gain) - (sfmultiplier * 
                    (preFlag * armACMP3_Pretab [sfb] + pScaleFactor [sfb])));
            sflimit = pSfbTableLong [Offset + (++sfb)];
            for (; (i < sflimit) && (i < *pNonZeroBound); i++)
            {
                /* get sign and abs magnitude */
                sign = (pSrc[i] < 0) ? 1 : 0;
                mag = (OMX_F64) (sign ? - pSrc[i] : pSrc[i]);
                pDst[i] = pow (mag, (4.0/3.0)) * scale;
                pDst[i] = sign ? -pDst[i] : pDst[i];
            }
        }
    }
    
    /* Fill remaining values pSrc the output buffer */
    for (i = *pNonZeroBound; i < OMX_MP3_GRANULE_LEN; i++)
    {
        pDst[i] = 0.0;
    }
    return OMX_StsNoErr;
}



/* 
 * Function: armACMP3_Stereoprocessing 
 */

static OMXResult armACMP3_Stereoprocessing (
    OMX_F64 pSrc[][OMX_MP3_GRANULE_LEN],
    OMX_F64 pDst[][OMX_MP3_GRANULE_LEN],
    OMX_S8  *pScaleFactor,
    OMX_INT *pNonZeroBound,
    OMX_INT mode, 
    OMX_INT modeExt, 
    OMX_INT samplingFreq, 
    OMX_INT id, 
    OMX_INT winSwitch, 
    OMX_INT blockType, 
    OMX_INT mixedBlock,
    OMX_INT sfCompress,
    OMXMP3ScaleFactorBandTableLong pSfbTableLong,
    OMXMP3ScaleFactorBandTableShort pSfbTableShort)
{
    OMX_U32     IStereoFlag, MSStereoFlag;
    OMX_U32     is_pos [OMX_MP3_GRANULE_LEN];
    OMX_S8      *pRScaleFactor;
    OMX_S32     Soff, Loff, sfBound, sfmax;
    OMX_S32     frlimit, fr;
    OMX_S32     i;
    OMX_S32     sp, sfb, width;
    OMX_F64     is_ratio;
    OMX_U32     win;

    /* Initialise is_ratio (this prevents a compiler warning about variable used before initialisation. */
    is_ratio=0.0;

    /* set flags */
    IStereoFlag = (mode == ARM_MP3_JOINT_STEREO_MODE) &&
                  (modeExt & 1);
    MSStereoFlag = (mode == ARM_MP3_JOINT_STEREO_MODE) &&
                   (modeExt & 2);

    if (pNonZeroBound [0] == 0 && pNonZeroBound [1] == 0)
    {
        return OMX_StsNoErr;        
    }

    /* Initialize is_pos array */
    for (i = 0; i < OMX_MP3_GRANULE_LEN; i ++)
    {
        is_pos [i] = 7;
    }
    if (mode != 3 && IStereoFlag)
    {
        pRScaleFactor = &pScaleFactor [OMX_MP3_SF_BUF_LEN];

        if (winSwitch == 1 && blockType == 2)
        {
            /* Short or Mixed Block */
            if (mixedBlock == 0)
            {
                /* Short Block */
                Soff = (samplingFreq + 
                        3 * id) * ARM_MP3_SHORT_SFB_TABLE_SZ;
                
                for (win = 0; win < 3; win++)
                {
                    for (sfb = 12, sfBound = 0; sfb >= 0; sfb--)
                    {
                        sp = pSfbTableShort [Soff + sfb];
                        width = 
                            pSfbTableShort [Soff + sfb + 1] - sp;
                        i = 3 * sp + (win + 1) * width - 1;
                        for (fr = 0; fr < width; fr++, i--)
                        {
                            if (pSrc [1][i] != 0.0)
                            {
                                /* Got Last Non Zero value */
                                sfBound = sfb + 1;
                                sfb = -1;
                                fr = width;
                            }
                        }
                    }
                    /* Fill remaining sfb with intensity pos */
                    for (sfb = sfBound; sfb < 12; sfb++)
                    {
                        sp = pSfbTableShort [Soff + sfb];
                        width = 
                            pSfbTableShort [Soff + sfb + 1] - sp;

                        i = 3 * sp + win * width;
                        for (fr = 0; fr < width; fr++)
                        {
                            is_pos [i + fr] = 
                                pRScaleFactor[sfb * 3 + win];
                            /* if MPEG1, intensity position is > 7 return error */    
                            armRetArgErrIf(id == 1 && is_pos [i + fr] > 7, OMX_StsErr)
                        }
                    }
                    
                    frlimit = pSfbTableShort [Soff + 13] - 
                        pSfbTableShort [Soff + 12];
                    i = 3 * pSfbTableShort [Soff + 11] + win * frlimit;
                    width = pSfbTableShort [Soff + 12] - 
                         pSfbTableShort [Soff + 11];
                    sp = 3 * pSfbTableShort [Soff + 11] + width * win;
                    for (fr = 0; fr < frlimit; fr++)
                    {
                        is_pos [i + fr] = 
                            is_pos [sp];
                    }
                } /* for window */
            }
            else
            {
                /* Mixed Block */
                Soff = (samplingFreq + 
                        3 * id) * ARM_MP3_SHORT_SFB_TABLE_SZ;
                Loff = (samplingFreq + 
                        3 * id) * ARM_MP3_LONG_SFB_TABLE_SZ;
                sfmax = 0;

                for (win = 0; win < 3; win++)
                {
                    for (sfb = 12,sfBound = 3; sfb > 2; sfb--)
                    {
                        sp = pSfbTableShort [Soff + sfb];
                        width = 
                            pSfbTableShort [Soff + sfb + 1] - sp;
                        i = 3 * sp + (win + 1) * width - 1;
                        for (fr = 0; fr < width; fr++, i--)
                        {
                            if (pSrc [1][i] != 0.0)
                            {
                                /* Got Last Non Zero value */
                                sfBound = sfb + 1;
                                sfb = -1;
                                fr = width;
                            }
                        }
                    }
                    if (sfmax < sfBound)
                    {
                        sfmax = sfBound;
                    }
                    /* Fill remaining sfb with intensity pos */
                    for (sfb = sfBound; sfb < 12; sfb++)
                    {
                        sp = pSfbTableShort [Soff + sfb];
                        width = 
                            pSfbTableShort [Soff + sfb + 1] - sp;

                        i = 3 * sp + win * width;
                        for (fr = 0; fr < width; fr++)
                        {
                            is_pos [i + fr] = 
                                pRScaleFactor[sfb * 3 + win];
                            
                            /* if MPEG1, intensity position is > 7 return error */    
                            armRetArgErrIf(id == 1 && is_pos [i + fr] > 7, OMX_StsErr)
                        }
                    }

                    frlimit = pSfbTableShort [Soff + 13] - 
                        pSfbTableShort [Soff + 12];
                    i = 3 * pSfbTableShort [Soff + 11] + win * frlimit;
                    width = pSfbTableShort [Soff + 12] - 
                         pSfbTableShort [Soff + 11];
                    sp = 3 * pSfbTableShort [Soff + 11] + width * win;
                    for (fr = 0; fr < frlimit; fr++)
                    {
                        is_pos [i + fr] = 
                            is_pos [sp];
                    }

                }
                if (sfmax <= 3)
                {
                    for (sfb = 8,sfBound = 0; sfb >= 0; sfb--)
                    {
                        sp = pSfbTableLong [Loff + sfb];
                        width = 
                            pSfbTableLong [Loff + sfb + 1] - sp;
                        i = pSfbTableLong [Loff + sfb + 1];
                        for (fr = 0; fr < width; fr++, i--)
                        {
                            if (pSrc [1][i] != 0.0)
                            {
                                /* Got Last Non Zero value */
                                sfBound = sfb + 1;
                                sfb = -1;
                                fr = width;
                            }
                        }
                    }

                    /* Fill remaining sfb with intensity pos */
                    for (sfb = sfBound; sfb < 8; sfb++)
                    {
                        i = pSfbTableLong [Loff + sfb];
                        width = 
                            pSfbTableLong [Loff + sfb + 1] - i;

                        for (fr = 0; fr < width; fr++)
                        {
                            is_pos [i + fr] = 
                                pRScaleFactor[sfb];
                            /* if MPEG1, intensity position is > 7 return error */    
                            armRetArgErrIf(id == 1 && is_pos [i + fr] > 7, OMX_StsErr)
                        }
                    }
                }
            }
        }
        else 
        {
            /* Long Block */
            Loff = (samplingFreq + 
                    3 * id) * ARM_MP3_LONG_SFB_TABLE_SZ;

            i = OMX_MP3_GRANULE_LEN - 1;
            while (pSrc [1][i] == 0.0)
            {
                i--;
            }
            sfb = ARM_MP3_LONG_SFB_TABLE_SZ - 1;
            i++;
            while (pSfbTableLong [Loff + sfb] >= i)
            {
                sfb--;
            }
            sfb = sfb + 1;
            for (; sfb < (ARM_MP3_LONG_SFB_TABLE_SZ - 2); sfb++)
            {
                i = pSfbTableLong [Loff + sfb];
                fr = pSfbTableLong [Loff + sfb + 1] - i;
                for (--fr; fr >= 0; fr--)
                {
                    is_pos [i + fr] = pRScaleFactor[sfb];
                }
            }
            sp = pSfbTableLong [Loff + ARM_MP3_LONG_SFB_TABLE_SZ - 3];
            i = pSfbTableLong [Loff + ARM_MP3_LONG_SFB_TABLE_SZ - 2];
            fr = OMX_MP3_GRANULE_LEN - i;
            for (--fr; fr >= 0; fr--)
            {
                is_pos [i + fr] = is_pos [sp];
            }
            
        }
    }

    if (mode != 3) /* not mono */
    {
         /* MPEG 2 intensity stereo case */
        if (id == 0 && IStereoFlag)
        {
            is_ratio = (sfCompress % 2) ? 0.707106781188 : 0.840896415256;
        }
        
        for (i = 0; i < OMX_MP3_GRANULE_LEN; i++)
        {
            if (is_pos [i] == 7)
            {
                if (MSStereoFlag)
                {
                    /* M/S Stereo */
                    pDst [0][i] = (pSrc [0][i] + pSrc [1][i]) / ARM_MP3_SQUARROOT;
                    pDst [1][i] = (pSrc [0][i] - pSrc [1][i]) / ARM_MP3_SQUARROOT;
                }
                else
                {
                    /* Normal Stereo/Dual */
                    pDst [0][i] = pSrc [0][i];
                    pDst [1][i] = pSrc [1][i];
                }
            }
            else
            {
                if (IStereoFlag)
                {
                    if (id == 1)
                    {
                        is_ratio = tan (is_pos [i] * PI / 12.0);
                        pDst [0][i] = pSrc [0][i] * is_ratio / (1 + is_ratio);
                        pDst [1][i] = pSrc [0][i] / (1 + is_ratio);
                    }
                    else
                    {
                        /* Check that id==0 */
                        armAssert(id==0);
                        
                        /* MPEG 2 intensity stereo case */
                        if (is_pos [i] == 0)
                        {
                            pDst [0][i] = pSrc [0][i];
                            pDst [1][i] = pSrc [1][i];
                        } 
                        else if((is_pos [i] % 2) == 1)
                        {
                            pDst [0][i] = pSrc [0][i] * pow (is_ratio, (OMX_F64) ((is_pos [i] + 1) / 2));
                            pDst [1][i] = pSrc [1][i];
                        } 
                        else
                        {
                            pDst [0][i] = pSrc [0][i];
                            pDst [1][i] = pSrc [1][i] * pow (is_ratio, (OMX_F64) (is_pos [i] / 2));
                        }
                    }
                }
                else
                {
                    /* Error Conditon */
                    return OMX_StsErr;
                }
            }
        }
    }
    else
    {
        /* Mono */
        for (i = 0; i < OMX_MP3_GRANULE_LEN; i++)
        {
            pDst [0][i] = pSrc [0][i];
        }
    }
    return OMX_StsNoErr;
    /* End of Stereo Module */    
}


/**
 * Function: armACMP3_Reorder
 *
 */
static OMXResult armACMP3_Reorder (OMX_F64 *pSrc, 
    OMX_F64 *pDst, 
    OMX_INT winSwitch, 
    OMX_INT blockType, 
    OMX_INT mixedBlock, 
    OMX_INT samplingFreq, 
    OMX_INT id, 
    OMXMP3ScaleFactorBandTableLong pSfbTableLong,
    OMXMP3ScaleFactorBandTableShort pSfbTableShort)
{
    OMX_S32     Offset;
    OMX_S32     frstart, frlimit;
    OMX_S32     i;
    OMX_S32     sfb = 0;
    OMX_U32     win;

    if (winSwitch && blockType == 2)
    {        
        /* Short Block */
        if (mixedBlock)
        {
            /* Mixed Block */
            Offset = (samplingFreq + 3 * id) * ARM_MP3_LONG_SFB_TABLE_SZ;
            for (i = 0; i < pSfbTableLong [Offset + 8]; i++)
            {
                pDst [i] = pSrc [i];
            }
            sfb = 3;
        }
            
        Offset = (samplingFreq + 3 * id) * ARM_MP3_SHORT_SFB_TABLE_SZ;
        for (; sfb < 13; sfb++)
        {
            frstart = pSfbTableShort [Offset + sfb];
            frlimit = pSfbTableShort [Offset + sfb + 1] - frstart; 
            for (win = 0; win < 3; win++)
            {
                for (i = 0; i < frlimit; i++)
                {
                    pDst [3 * frstart + (i * 3) + win] = 
                        pSrc [3 * frstart + (win * frlimit) + i];
                }
            }
        }
    }
    else
    {
        /* Long Block */
        for (i = 0; i < OMX_MP3_GRANULE_LEN; i++)
        {
            pDst [i] = pSrc [i];
        }
    }
    return OMX_StsNoErr;
}

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
OMXResult omxACMP3_ReQuantizeSfb_S32_I(
     OMX_S32 *pSrcDstIsXr,
     OMX_INT *pNonZeroBound,
     OMX_S8 *pScaleFactor,
     OMXMP3SideInfo *pSideInfo,
     OMXMP3FrameHeader *pFrameHeader,
     OMX_S32 *pBuffer,
     OMXMP3ScaleFactorBandTableLong pSfbTableLong,
     OMXMP3ScaleFactorBandTableShort pSfbTableShort
)
{
    OMX_S32     i;
    OMX_U32     ch, NCh, MaxSfb;
    OMX_F64     Buf1 [ARM_MP3_MAX_NUM_CHANNEL][OMX_MP3_GRANULE_LEN];
    OMX_F64     Buf2 [ARM_MP3_MAX_NUM_CHANNEL][OMX_MP3_GRANULE_LEN];
    OMXResult   Result;

    /* Arguments check */
    armRetArgErrIf(pSrcDstIsXr == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pNonZeroBound == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pScaleFactor == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pSideInfo == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pBuffer == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pFrameHeader == NULL, OMX_StsBadArgErr)

    /* Validate input conditions */
    /* Verify header */
    armRetArgErrIf(pFrameHeader->id < 0, OMX_StsErr)
    armRetArgErrIf(pFrameHeader->id > 1, OMX_StsErr)

    /* Verify sampling frequency */
    armRetArgErrIf(pFrameHeader->samplingFreq < 0, OMX_StsErr)
    armRetArgErrIf(pFrameHeader->samplingFreq > 2, OMX_StsErr)

    /* Verify mode */
    armRetArgErrIf(pFrameHeader->mode < 0, OMX_StsErr)
    armRetArgErrIf(pFrameHeader->mode > 3, OMX_StsErr)
    
    /* Verify modeExt */
    armRetArgErrIf(pFrameHeader->modeExt < 0, OMX_StsErr)
    armRetArgErrIf(pFrameHeader->modeExt > 3, OMX_StsErr)

    /* Total Number of channels */
    NCh = (pFrameHeader->mode == ARM_MP3_SINGLE_CHANNEL_MODE) ? 1 : 2;

    for (ch = 0; ch < NCh; ch++)
    {
        /* Non-zero bound test*/
        armRetArgErrIf(pNonZeroBound[ch] < 0, OMX_StsErr)
        armRetArgErrIf(pNonZeroBound[ch] > 576, OMX_StsErr)

        /* gain value */
        armRetArgErrIf(pSideInfo[ch].globGain < 0, OMX_StsErr)
        armRetArgErrIf(pSideInfo[ch].globGain > 255, OMX_StsErr)

        /* block type */
        armRetArgErrIf(pSideInfo[ch].blockType < 0, OMX_StsErr)
        armRetArgErrIf(pSideInfo[ch].blockType > 3, OMX_StsErr)

        /* Mixed block */
        armRetArgErrIf(pSideInfo[ch].mixedBlock < 0, OMX_StsErr)
        armRetArgErrIf(pSideInfo[ch].mixedBlock > 1, OMX_StsErr)

        /* scale factor scale */
        armRetArgErrIf(pSideInfo[ch].sfScale < 0, OMX_StsErr)
        armRetArgErrIf(pSideInfo[ch].sfScale > 1, OMX_StsErr)

        /* preflag */
        armRetArgErrIf(pSideInfo[ch].preFlag < 0, OMX_StsErr)
        armRetArgErrIf(pSideInfo[ch].preFlag > 1, OMX_StsErr)

        /* sub block gain */
        armRetArgErrIf(pSideInfo[ch].pSubBlkGain[0] < 0, OMX_StsErr)
        armRetArgErrIf(pSideInfo[ch].pSubBlkGain[0] > 7, OMX_StsErr)
        armRetArgErrIf(pSideInfo[ch].pSubBlkGain[1] < 0, OMX_StsErr)
        armRetArgErrIf(pSideInfo[ch].pSubBlkGain[1] > 7, OMX_StsErr)
        armRetArgErrIf(pSideInfo[ch].pSubBlkGain[2] < 0, OMX_StsErr)
        armRetArgErrIf(pSideInfo[ch].pSubBlkGain[2] > 7, OMX_StsErr)
    
        /* input values and scalefactors */
        for (i = 0; i < pNonZeroBound[ch]; i++)
        {
            armRetArgErrIf(pSrcDstIsXr 
                [ch * OMX_MP3_GRANULE_LEN + i] < -8206, OMX_StsErr) 
            armRetArgErrIf(pSrcDstIsXr 
                [ch * OMX_MP3_GRANULE_LEN + i] > 8206, OMX_StsErr) 
        }
        
        /* scalefactors */
        if (pSideInfo[ch].winSwitch == 1 && pSideInfo[ch].blockType == 2)
        {        
            /* Mixed Block */
            if (pSideInfo[ch].mixedBlock == 1)
            {
                /* 8 + (12 - 3) * 3 */
                MaxSfb = 35;
            }
            else /* Short Block */
            {
                /* 12 * 3 */
                MaxSfb = 36;
            }
        }
        else
        {
            /* Long Block */
            MaxSfb = 21;
        }
        
        for (i = 0; i < MaxSfb; i++)
        {
            armRetArgErrIf(pScaleFactor
                [ch * OMX_MP3_SF_BUF_LEN + i] < 0, OMX_StsErr)
            armRetArgErrIf(pScaleFactor
                [ch * OMX_MP3_SF_BUF_LEN + i] > 15, OMX_StsErr)
        }
        
        if (pFrameHeader->mode == ARM_MP3_JOINT_STEREO_MODE)
        {
            armRetArgErrIf(pSideInfo[0].blockType != pSideInfo[1].blockType, OMX_StsErr)
            armRetArgErrIf((pSideInfo[0].blockType == 2) && 
                (pSideInfo[0].mixedBlock != pSideInfo[1].mixedBlock), OMX_StsErr)
        }

        /*
         * Requantization of huffman codes 
         */
        
        Result = armACMP3_Requant (
            pSrcDstIsXr + ch * OMX_MP3_GRANULE_LEN,
            Buf1 [ch],
            pScaleFactor + ch * OMX_MP3_SF_BUF_LEN,
            &pNonZeroBound[ch],
            pFrameHeader->samplingFreq,
            pFrameHeader->id,
            pSideInfo[ch].globGain, 
            pSideInfo[ch].sfScale, 
            pSideInfo[ch].preFlag, 
            pSideInfo[ch].pSubBlkGain,
            pSideInfo[ch].winSwitch, 
            pSideInfo[ch].blockType, 
            pSideInfo[ch].mixedBlock,
            pSfbTableLong,
            pSfbTableShort);
            
        armRetArgErrIf(Result != OMX_StsNoErr, Result)            

    }
    
    /*
     * Stereo Processing 
     */
    
    Result = armACMP3_Stereoprocessing (
        Buf1,
        Buf2,
        pScaleFactor,
        pNonZeroBound,
        pFrameHeader->mode, 
        pFrameHeader->modeExt, 
        pFrameHeader->samplingFreq, 
        pFrameHeader->id, 
        pSideInfo[0].winSwitch, 
        pSideInfo[0].blockType, 
        pSideInfo[0].mixedBlock,
        pSideInfo[0].sfCompress,
        pSfbTableLong,
        pSfbTableShort);

    armRetArgErrIf(Result != OMX_StsNoErr, Result)            

    /*
     * Reorder
     */

    for (ch = 0; ch < NCh; ch++)
    {
        Result = armACMP3_Reorder (
            Buf2[ch], 
            Buf1[ch], 
            pSideInfo[ch].winSwitch, 
            pSideInfo[ch].blockType, 
            pSideInfo[ch].mixedBlock, 
            pFrameHeader->samplingFreq, 
            pFrameHeader->id, 
            pSfbTableLong,
            pSfbTableShort);

        armRetArgErrIf(Result != OMX_StsNoErr, Result)            
    } /* for ch */

    for (ch = 0; ch < NCh; ch++)
    {
        for (i = 0; i < OMX_MP3_GRANULE_LEN; i++)
        {
            /* Q5.26 */
            pSrcDstIsXr [ch * OMX_MP3_GRANULE_LEN + i] = 
                armSatRoundFloatToS32 (Buf1 [ch][i] * (1 << 26));
        }
    }

    /* Update Non-zero variable */
    for (ch = 0; ch < NCh; ch++)
    {
        i = OMX_MP3_GRANULE_LEN - 1;
        while ((i >= 0) && (pSrcDstIsXr [ch * OMX_MP3_GRANULE_LEN + i] == 0))
        {
            i--;
        }
        
        pNonZeroBound[ch] = ++i;
    }

    return Result;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

