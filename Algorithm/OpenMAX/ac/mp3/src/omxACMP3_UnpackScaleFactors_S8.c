/**
 *  omxACMP3_UnpackScaleFactors_S8.c
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
 * This function is used to unpack scalefactors specified by ISO/IEC 13818-3
 *
 */

#include "omxtypes.h"
#include "armCOMM_Bitstream.h"
#include "omxAC.h"
#include "armCOMM.h"

static OMXResult armACMP3_MPEG2_UnpackScaleFactors_S8 (
     const OMX_U8 **ppBitStream,
     OMX_INT *pOffset,
     OMX_INT blockType,
     OMX_INT mixedBlock,
     OMX_INT *pPreflag,
     OMX_S8 *pScaleFactor,
     OMX_INT sfCompress,
     OMX_INT modeExt,
     OMX_INT ch)
{
    OMX_INT     BlkTypeNo, BlkNo = 0;
    OMX_S32     NewSLen[4], ISFCompress;
    OMX_U32     i, j, k;

    const OMX_U8 SFBlockNo [6][3][4] = 
    {
        {
            {6, 5, 5, 5}, { 9, 9, 9, 9 }, {6, 9, 9, 9}
        },
        {   
            {6, 5, 7, 3}, { 9, 9, 12, 6}, {6, 9, 12, 6}
        },
        {
            {11, 10, 0, 0}, { 18, 18, 0, 0}, {15,18,0,0 }
        },
        {
            {7, 7, 7, 0}, { 12, 12, 12, 0}, {6, 15, 12, 0}
        },
        {
            {6, 6, 6, 3}, {12, 9, 9, 6}, {6, 12, 9, 6}
        },
        {   
            {8, 8, 5, 0}, {15,12,9,0}, {6,18,9,0}
        }
    };

    
    
    BlkTypeNo = 0;
    if ((blockType == 2) && (mixedBlock == 0))
    {
        BlkTypeNo = 1;
    }

    if ((blockType == 2) && (mixedBlock == 1))
    {
        BlkTypeNo = 2;
    }

    if (!((( modeExt == 1) || (modeExt == 3)) && (ch == 1)))
    {
        if (sfCompress < 400)
        {
            NewSLen[0] = (sfCompress >> 4) / 5 ;
            NewSLen[1] = (sfCompress >> 4) % 5 ;
            NewSLen[2] = (sfCompress % 16) >> 2 ;
            NewSLen[3] = (sfCompress % 4);
            *pPreflag = 0;
            BlkNo = 0;
        }
        else if( sfCompress  < 500)
        {
            NewSLen[0] = ((sfCompress - 400 )  >> 2) / 5 ;
            NewSLen[1] = ((sfCompress - 400) >> 2) % 5 ;
            NewSLen[2] = (sfCompress - 400 ) % 4 ;
            NewSLen[3] = 0;
            *pPreflag = 0;
            BlkNo = 1;
        }
        else if( sfCompress  < 512)
        {
            NewSLen[0] = (sfCompress - 500 ) / 3 ;
            NewSLen[1] = (sfCompress - 500)  % 3 ;
            NewSLen[2] = 0 ;
            NewSLen[3] = 0;
            *pPreflag = 1;
            BlkNo = 2;
        }
    }

    if((((modeExt == 1) || (modeExt == 3)) && (ch == 1)))
    {
        /*   intensity scale = sfCompress %2; */
        ISFCompress = sfCompress >> 1;
        if(ISFCompress  < 180)
        {
            NewSLen[0] = ISFCompress  / 36 ;
            NewSLen[1] = (ISFCompress % 36 ) / 6 ;
            NewSLen[2] = (ISFCompress % 36) % 6;
            NewSLen[3] = 0;
            *pPreflag = 0;
            BlkNo = 3;
        }
        else if( ISFCompress  < 244)
        {
            NewSLen[0] = ((ISFCompress - 180 )  % 64 ) >> 4 ;
            NewSLen[1] = ((ISFCompress - 180) % 16) >> 2 ;
            NewSLen[2] = (ISFCompress - 180 ) % 4 ;
            NewSLen[3] = 0;
            *pPreflag = 0;
            BlkNo = 4;
        }
        else if( ISFCompress  < 255)
        {
            NewSLen[0] = (ISFCompress - 244 ) / 3 ;
            NewSLen[1] = (ISFCompress - 244 )  % 3 ;
            NewSLen[2] = 0 ;
            NewSLen[3] = 0;
            *pPreflag = 0;
            BlkNo = 5;
        }
    }
    
    k = 0;
    for(i = 0; i < 4; i++)
    { 
        for(j = 0; j < SFBlockNo[BlkNo][BlkTypeNo][i]; j++)
        {
            if(NewSLen[i] == 0)
            {
                *pScaleFactor++ = 0;
            }
            else
            {   
                *pScaleFactor++  = 
                    armGetBits (ppBitStream, pOffset, NewSLen[i]);
            }
            k++;
        }
    }
    
    return OMX_StsNoErr;
}

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
)
{
    OMX_INT         sfb, win, Band, Scfsi;
    const OMX_U8    LongSfbLength [] = {0, 6, 11, 16, 21};
    OMX_S8          *pScaleFactor = pDstScaleFactor;
    /*const OMX_U8 ShortSfbLength [] = {0, 6, 12};*/
    const OMX_U8 SLen [2][16] = 
        {{0, 0, 0, 0, 3, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4},
         {0, 1, 2, 3, 0, 1, 2, 3, 1, 2, 3, 1, 2, 3, 2, 3}};

    /* Arguments check */
    armRetArgErrIf(ppBitStream == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(*ppBitStream == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pOffset == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstScaleFactor == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pSideInfo == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pScfsi == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pFrameHeader == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(*pOffset < 0, OMX_StsBadArgErr)
    armRetArgErrIf(*pOffset > 7, OMX_StsBadArgErr)
    armRetArgErrIf(granule < 0, OMX_StsBadArgErr)
    armRetArgErrIf(granule > 1, OMX_StsBadArgErr)
    armRetArgErrIf(channel < 0, OMX_StsBadArgErr)
    armRetArgErrIf(channel > 1, OMX_StsBadArgErr)

    /* Validate ID */
    armRetArgErrIf(pFrameHeader->id < 0, OMX_StsErr)
    armRetArgErrIf(pFrameHeader->id > 1, OMX_StsErr)
    
    /* Validate Mode Ext */
    armRetArgErrIf(pFrameHeader->modeExt < 0, OMX_StsErr)
    armRetArgErrIf(pFrameHeader->modeExt > 3, OMX_StsErr)

    /* Validate Block Type */
    armRetArgErrIf(pSideInfo->blockType < 0, OMX_StsErr)
    armRetArgErrIf(pSideInfo->blockType > 3, OMX_StsErr)

    if (pFrameHeader->id == 1)
    {
        /* MPEG1 */
        /* Validate Scale Factor Compress */
        armRetArgErrIf(pSideInfo->sfCompress < 0, OMX_StsErr)
        armRetArgErrIf(pSideInfo->sfCompress > 15, OMX_StsErr)
        
        /* Get Scalefactors */
        if ((pSideInfo->winSwitch == 1) &&
            (pSideInfo->blockType == 2))
        {
            /* Validate Mixed Block Flag */
            armRetArgErrIf(pSideInfo->mixedBlock < 0, OMX_StsErr)
            armRetArgErrIf(pSideInfo->mixedBlock > 1, OMX_StsErr)
            
            if (pSideInfo->mixedBlock)
            {
                /* Short & Long */
                for (sfb = 0; sfb < 8; sfb++)
                {
                    *pScaleFactor++  = 
                        armGetBits (ppBitStream, pOffset, SLen [0] [pSideInfo->sfCompress]);
                }
                for (sfb = 3; sfb < 12; sfb++)
                {
                    for (win = 0; win < 3; win++)
                    {
                        *pScaleFactor++  = 
                            armGetBits (ppBitStream, pOffset, 
                            SLen [(sfb < 6)? 0 : 1] [pSideInfo->sfCompress]);
                    }
                }
            }
            else
            {
                /* Only Short */
                for (sfb = 0; sfb < 12; sfb++)
                {
                    for (win = 0; win < 3; win++)
                    {
                        *pScaleFactor++  = 
                            armGetBits (ppBitStream, pOffset, 
                            SLen [(sfb < 6)? 0 : 1] [pSideInfo->sfCompress]);
                    }
                }
            }
        }
        else
        {
            /* Only Long */
            for (Band = 0; Band < 4; Band++)
            {
                Scfsi = pScfsi [Band];
                /* Validate Mixed Block Flag */
                if (Scfsi < 0 || Scfsi > 1)
                {
                    return OMX_StsErr;
                }

                if ((Scfsi == 0) || (granule == 0))
                {
                    for (sfb = LongSfbLength [Band]; 
                         sfb < LongSfbLength [Band + 1]; 
                         sfb++)
                    {
                        pScaleFactor [sfb]  = 
                            armGetBits (ppBitStream, pOffset, 
                            SLen [(Band >> 1)] [pSideInfo->sfCompress]);
                    }
                }
            }
        }
    }
    else
    {
        /* MPEG2 */
        /* Validate Scale Factor Compress */
        armRetArgErrIf(pSideInfo->sfCompress < 0, OMX_StsErr)
        armRetArgErrIf(pSideInfo->sfCompress > 511, OMX_StsErr)

        armACMP3_MPEG2_UnpackScaleFactors_S8 (
             ppBitStream,
             pOffset,
             pSideInfo->blockType,
             pSideInfo->mixedBlock,
             &(pSideInfo->preFlag),
             pScaleFactor,
             pSideInfo->sfCompress,
             pFrameHeader->modeExt,
             channel);

    }


    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

