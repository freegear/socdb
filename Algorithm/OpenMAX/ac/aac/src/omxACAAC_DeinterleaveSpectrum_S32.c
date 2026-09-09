/**
 *  omxACAAC_DeinterleaveSpectrum_S32.c
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
 * This file contains module for De-Interleaving input data for short blocks for an AAC decoder
 *
 */

#include "omxtypes.h"
#include "omxAC.h"

#include "armCOMM.h"
#include "armACAAC_Tables.h"

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
 
OMXResult omxACAAC_DeinterleaveSpectrum_S32(
     const OMX_S32 *pSrc,
     OMX_S32 *pDst,
     OMX_INT numWinGrp,
     const OMX_INT *pWinGrpLen,
     OMX_INT maxSfb,
     OMX_INT samplingRateIndex,
     OMX_INT winLen
 )
{
    const OMX_U16 *pOffsetTable;
    OMX_U16 width,numSwb;
    OMX_INT groupNum,sfbNum,winNum,coeffNum;
    OMX_S32 *pDstTemp;

    /* Argument Check */        
    armRetArgErrIf( pSrc       == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pDst       == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pWinGrpLen == NULL, OMX_StsBadArgErr);

    armRetArgErrIf( (numWinGrp > 8) || (numWinGrp < 1), OMX_StsBadArgErr);
    armRetArgErrIf( (maxSfb > 51)   || (maxSfb < 0)   , OMX_StsBadArgErr);

    armRetArgErrIf( samplingRateIndex > 11     , OMX_StsBadArgErr);
    armRetArgErrIf( samplingRateIndex < 0      , OMX_StsBadArgErr);
    armRetArgErrIf( winLen != ARM_AAC_WIN_SHORT, OMX_StsBadArgErr);

    armRetArgErrIf( armNot8ByteAligned(pSrc), OMX_StsBadArgErr);
    armRetArgErrIf( armNot8ByteAligned(pDst), OMX_StsBadArgErr);

    /* Processing */
    pOffsetTable = armACAAC_swbOffsetShortWindow[samplingRateIndex];        
    numSwb       = armACAAC_numSwbShort[samplingRateIndex];

    armRetArgErrIf( maxSfb > numSwb, OMX_StsAacMaxSfbErr);

    for( groupNum = 0; groupNum < numWinGrp; groupNum++ )
    {
        for( sfbNum = 0; sfbNum < maxSfb; sfbNum ++ )
        {
            width = pOffsetTable[sfbNum + 1] - pOffsetTable[sfbNum];

            pDstTemp = pDst;

            for( winNum = 0; winNum < pWinGrpLen[groupNum]; winNum++ )
            {
                for( coeffNum = 0; coeffNum < width; coeffNum++ )
                {
                    *(pDstTemp + coeffNum) = *pSrc++;
                }

                pDstTemp += winLen;
            }

            pDst += width;
        }
        
        /*For coefficients above maxSfb*/
        
        for(sfbNum = maxSfb ; sfbNum < numSwb ; sfbNum ++)
        {
            width = pOffsetTable[sfbNum + 1] - pOffsetTable[sfbNum];

            pDstTemp = pDst;

            for( winNum = 0; winNum < pWinGrpLen[groupNum]; winNum++ )
            {
                for( coeffNum = 0; coeffNum < width; coeffNum++ )
                {
                    pDstTemp[coeffNum] = 0;
                }

                pDstTemp += winLen;

            }

            pDst += width;
        
        }
        
        pDst += winLen*(pWinGrpLen[groupNum] - 1);
    }

    return OMX_StsNoErr;
}
 
 
 
 
 
 
 
 
 
 

