/**
 *  omxACMP3_UnpackSideInfo.c
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
 * This function is used to unpack a 9/17/32 byte sideinfo as specified in 
 * ISO/IEC 13818-3
 * 
 */

#include "omxtypes.h"
#include "omxAC.h"
#include "armAC.h"
#include "armCOMM_Bitstream.h"
#include "armCOMM.h"

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
)
{
    OMX_INT     i, j, k, BitIndex, len;
    OMX_U32     Granule, NumChan;
    OMX_INT     Mpeg1Flag;

    /* Arguments check */
    armRetArgErrIf(ppBitStream == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstSideInfo == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstMainDataBegin == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstPrivateBits == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstScfsi == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pFrameHeader == NULL, OMX_StsBadArgErr)

    /* Arguments check */
    armRetArgErrIf(*ppBitStream == NULL, OMX_StsBadArgErr)

    /* Frame Header Validation */
    armRetArgErrIf(pFrameHeader->id < 0, OMX_StsErr)
    armRetArgErrIf(pFrameHeader->id > 1, OMX_StsErr)
    armRetArgErrIf(pFrameHeader->layer != 1, OMX_StsErr)
    armRetArgErrIf(pFrameHeader->mode < 0, OMX_StsErr)
    armRetArgErrIf(pFrameHeader->mode > 3, OMX_StsErr)
    /*armRetArgErrIf((pDstSideInfo->blockType == 0) && 
        pDstSideInfo->mixedBlock, OMX_StsErr)*/

    /* Initialize bitstream parameters */
    BitIndex = 7;

    /* Check whether stream is MPEG1 or MPEG2 */
    if (pFrameHeader->id == 1 && pFrameHeader->idEx == 1)
    {
        Mpeg1Flag = 1;
    }
    else
    {
        Mpeg1Flag = 0;
    }

    /* Get main data begin offset from side info */
    len = Mpeg1Flag ? ARM_MP3_MAIN_BEGIN_LEN1 : ARM_MP3_MAIN_BEGIN_LEN2;
    *pDstMainDataBegin = (OMX_INT) armGetBits (ppBitStream, &BitIndex, len);

    /* Get private bits from side info */
    /* Also get number of channels */
    if (pFrameHeader->mode == ARM_MP3_SINGLE_CHANNEL_MODE)
    {
        NumChan = 1;
        len = Mpeg1Flag ? ARM_MP3_PRIV_SINGLE_LEN1 : ARM_MP3_PRIV_SINGLE_LEN2;
        *pDstPrivateBits = (OMX_INT) armGetBits (ppBitStream, 
                                                 &BitIndex, 
                                                 len);
    }
    else
    {
        NumChan = 2;
        len = Mpeg1Flag ? 
            ARM_MP3_PRIV_NOTSINGLE_LEN1 : ARM_MP3_PRIV_NOTSINGLE_LEN2;
        *pDstPrivateBits = (OMX_INT) armGetBits (ppBitStream, 
                                                 &BitIndex, 
                                                 len);
    }

    /* Get Scalefactor Selection Info from side info */
    if (Mpeg1Flag)
    {
        for (j = 0; j < NumChan; j++)
        {
            /* For each SCFSI Band */
            for (i = 0; i < 4; i++)
            {
                pDstScfsi [j * 4 + i] = 
                    (OMX_INT) armGetBits (ppBitStream, &BitIndex, 1);
            }
        }
    }
    
    /* Fill side info structure for both granule */
    Granule = Mpeg1Flag ? 2 : 1;

    for (j = 0; j < Granule; j++)
    {
        for (i = 0; i < NumChan; i++)
        {
            pDstSideInfo->part23Len = 
                armGetBits (ppBitStream, &BitIndex, 12);
            pDstSideInfo->bigVals = 
                armGetBits (ppBitStream, &BitIndex, 9);
            pDstSideInfo->globGain = 
                armGetBits (ppBitStream, &BitIndex, 8);
            pDstSideInfo->sfCompress = 
                armGetBits (ppBitStream, &BitIndex, (Mpeg1Flag ? 4 : 9));
            pDstSideInfo->winSwitch = 
                armGetBits (ppBitStream, &BitIndex, 1);
            if (pDstSideInfo->winSwitch)
            {
                pDstSideInfo->blockType = 
                    armGetBits (ppBitStream, &BitIndex, 2);
                pDstSideInfo->mixedBlock = 
                    armGetBits (ppBitStream, &BitIndex, 1);
                
                /* For each Region */
                for (k = 0; k < 2; k++)
                {
                    pDstSideInfo->pTableSelect [k] = 
                        armGetBits (ppBitStream, &BitIndex, 5);
                }

                /* For each Window */
                for (k = 0; k < 3; k++)
                {
                    pDstSideInfo->pSubBlkGain [k] = 
                        armGetBits (ppBitStream, &BitIndex, 3);
                }
                /* Update Fields */
                if (pDstSideInfo->blockType == 2 &&
                    !pDstSideInfo->mixedBlock)
                {
                    pDstSideInfo->reg0Cnt = 8;
                }
                else
                {
                    pDstSideInfo->reg0Cnt = 7;
                }
                pDstSideInfo->reg1Cnt = 36;
            }
            else
            {
                /* For each Region */
                for (k = 0; k < 3; k++)
                {
                    pDstSideInfo->pTableSelect [k] = 
                        armGetBits (ppBitStream, &BitIndex, 5);
                }
                pDstSideInfo->reg0Cnt = 
                    armGetBits (ppBitStream, &BitIndex, 4);
                pDstSideInfo->reg1Cnt = 
                    armGetBits (ppBitStream, &BitIndex, 3);
                /* Update Fields */
                pDstSideInfo->blockType = 0;
                pDstSideInfo->mixedBlock = 0;
            }
            if (Mpeg1Flag)
            {
                pDstSideInfo->preFlag = 
                    armGetBits (ppBitStream, &BitIndex, 1);
            }
            pDstSideInfo->sfScale = 
                armGetBits (ppBitStream, &BitIndex, 1);
            pDstSideInfo->cnt1TabSel = 
                armGetBits (ppBitStream, &BitIndex, 1);
            
            /* go to the next Side Info structure */
            pDstSideInfo++;
        }
    }
    
    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

