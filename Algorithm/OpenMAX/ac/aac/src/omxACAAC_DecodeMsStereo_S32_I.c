/**
 *  omxACAAC_DecodeMsStereo_S32_I.c
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
 * This file contains module for M/S Stereo decoding for an AAC decoder
 *
 */


#include "omxtypes.h"
#include "omxAC.h"

#include "armCOMM_Bitstream.h"
#include "armAC.h"
#include "armCOMM.h"

#include "armACAAC_Tables.h"

/**
 * Function: omxACAAC_DecodeMsStereo_S32_I
 *
 * Description:
 * MS stereo process.
 * Reference to ISO/IEC 14496-3 Sect 6.7.1
 *
 * Remarks:
 * This function perform MS stereo process for pair channels.
 *
 *
 * Parameters:
 * [in]  pSrcDstL       pointer to left channel data in Q13.18 format.
 * [in]  pSrcDstR       pointer to right channel data in Q13.18 format.
 * [in]  msMaskPres     MS stereo mask flag. 0: MS off, 1: MS on. 2: MS all bands on.
 * [in]  ppMsUsed       pointer to the MS Stereo flag buffer. Buffer length must = 120.
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
)
{
    OMX_INT groupNum,winNum,sfbNum,cbNum;
    OMX_INT msMask,coeff;
    OMX_S32 diff;
    const OMX_U16 *pOffsetTable;
    OMX_U16 width,numSwb;
    OMX_INT msMaskPres;
    
    /* Argument Check */        
    armRetArgErrIf( pChanPairElt == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pSrcDstL     == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pSrcDstR     == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pSfbCb       == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pWinGrpLen   == NULL, OMX_StsBadArgErr);

    armRetArgErrIf( (maxSfb > 51)    || (maxSfb < 0)    , OMX_StsBadArgErr);
    armRetArgErrIf( pChanPairElt->msMaskPres > 2, OMX_StsBadArgErr);
    armRetArgErrIf( pChanPairElt->msMaskPres < 1, OMX_StsBadArgErr);
    
    armRetArgErrIf( samplingRateIndex > 11, OMX_StsBadArgErr);
    armRetArgErrIf( samplingRateIndex < 0 , OMX_StsBadArgErr);

    armRetArgErrIf( armNot8ByteAligned(pSrcDstL), OMX_StsBadArgErr)
    armRetArgErrIf( armNot8ByteAligned(pSrcDstR), OMX_StsBadArgErr)
    
    armRetArgErrIf( ( winLen != ARM_AAC_WIN_SHORT ) && 
                    ( winLen != ARM_AAC_WIN_LONG  ),
                    OMX_StsBadArgErr );

    armRetArgErrIf( ( winLen == ARM_AAC_WIN_SHORT ) && 
                    ( (numWinGrp > 8) || (numWinGrp < 1) ), 
                    OMX_StsBadArgErr );

    armRetArgErrIf( ( winLen == ARM_AAC_WIN_LONG ) && 
                    ( numWinGrp != 1),
                    OMX_StsBadArgErr );
    

    /* Processing */
    msMaskPres = pChanPairElt->msMaskPres;
    
    if(winLen == ARM_AAC_WIN_SHORT)
    {
        pOffsetTable = armACAAC_swbOffsetShortWindow[samplingRateIndex];
        numSwb       = armACAAC_numSwbShort[samplingRateIndex];
    }
    else
    {
        pOffsetTable = armACAAC_swbOffsetLongWindow[samplingRateIndex];
        numSwb       = armACAAC_numSwbLong[samplingRateIndex];
    }
  
    armRetArgErrIf( maxSfb > numSwb, OMX_StsAacMaxSfbErr);

    for (groupNum = 0; groupNum < numWinGrp; groupNum++)
    {
        for(sfbNum = 0; sfbNum < maxSfb; sfbNum++)
        {
            msMask = pChanPairElt->ppMsMask[groupNum][sfbNum];
            cbNum  = *pSfbCb;
            
            /*inverting the intensity*/
            if(msMask == 1 && cbNum  == ARM_AAC_INTENSITY_HCB)
            {
                cbNum   = ARM_AAC_INTENSITY_HCB2;
                *pSfbCb = ARM_AAC_INTENSITY_HCB2;
            }
            else if(msMask == 1 && cbNum  == ARM_AAC_INTENSITY_HCB2)
            {
                cbNum   = ARM_AAC_INTENSITY_HCB;
                *pSfbCb = ARM_AAC_INTENSITY_HCB;
            }
            
            width  = pOffsetTable[sfbNum + 1] - pOffsetTable[sfbNum];
            pSfbCb++;
            
            if
            (   ( msMask == 1                     || 
                  msMaskPres == 2 )               &&
                  cbNum != ARM_AAC_INTENSITY_HCB  &&
                  cbNum != ARM_AAC_INTENSITY_HCB2 &&
                  cbNum != ARM_AAC_NOISE_HCB
            )
            {
                
                for (winNum = 0; winNum < pWinGrpLen[groupNum]; winNum++)
                {
                    for (coeff = 0; coeff < width; coeff++)
                    {
                        diff      = armSatSub_S32(*pSrcDstL,*pSrcDstR);
                        *pSrcDstL = armSatAdd_S32(*pSrcDstL,*pSrcDstR);
                        *pSrcDstR = diff;
                        
                        pSrcDstL++;
                        pSrcDstR++;
                    }
                }
            }
            else
            {
                pSrcDstL += pWinGrpLen[groupNum] * width;
                pSrcDstR += pWinGrpLen[groupNum] * width;
            }
        }
    }

    return OMX_StsNoErr;
}

/* End of File */
