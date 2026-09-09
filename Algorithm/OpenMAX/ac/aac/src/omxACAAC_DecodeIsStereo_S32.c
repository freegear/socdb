/**
 *  omxACAAC_DecodeIsStereo_S32.c
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
 * This file contains module for Intensity Stereo decoding for an AAC decoder
 *
 */

#include <math.h>
 
#include "omxtypes.h"
#include "omxAC.h"

#include "armCOMM_Bitstream.h" 
#include "armCOMM.h"

#include "armACAAC_Tables.h"

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
 
static OMX_S32 armACAAC_ScaleIsStereo(
    OMX_S32 input,
    OMX_INT cbNum,
    OMX_S16 isPos
    );

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
 )
{

    OMX_INT groupNum,sfbNum,cbNum,winNum = 0;
    OMX_INT coeff;
    const OMX_U16 *pOffsetTable;
    OMX_U16 width,numSwb;
    OMX_S16 isPos;

    /* Argument Check */        
    armRetArgErrIf( pSrcL        == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pDstR        == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pScalefactor == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pSfbCb       == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pWinGrpLen   == NULL, OMX_StsBadArgErr);

    armRetArgErrIf( (maxSfb > 51) || (maxSfb < 0), OMX_StsBadArgErr);

    armRetArgErrIf( samplingRateIndex > 11, OMX_StsBadArgErr);
    armRetArgErrIf( samplingRateIndex < 0 , OMX_StsBadArgErr);

    
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
        for(sfbNum = 0; sfbNum <maxSfb; sfbNum++)
        {
            isPos  = *pScalefactor++;
            cbNum  = *pSfbCb++;
            
            width = pOffsetTable[sfbNum + 1] - pOffsetTable[sfbNum];

            if (
                cbNum == ARM_AAC_INTENSITY_HCB  ||
                cbNum == ARM_AAC_INTENSITY_HCB2
                )
            {
                for (winNum = 0; winNum < pWinGrpLen[groupNum]; winNum++)
                {
                    for (coeff = 0; coeff < width; coeff++)
                    {
                        *pDstR = armACAAC_ScaleIsStereo(*pSrcL,cbNum,isPos);
                        
                        pSrcL++;
                        pDstR++;
                    }
                }
            }
            else
            {
                pSrcL += (pWinGrpLen[groupNum] * width);
                pDstR += (pWinGrpLen[groupNum] * width);
            }
        }
    }


    return OMX_StsNoErr;

}


/**
 * Function: armACAAC_ScaleIsStereo
 *
 * Description:
 * Computes 2^(-isPos/4) and scales the input with this value 
 *
 *
 * Parameters:
 * [in]  input	 the input to be scaled
 * [in]  cbNum	 the code book index used
 * [in]  isPos	 scaling coefficient
 *
 * Return Value:
 * The scaled value of the input
 *
 */

static OMX_S32 armACAAC_ScaleIsStereo(OMX_S32 input,OMX_INT cbNum,OMX_S16 isPos)
{
    OMX_F64 coeff;
    OMX_S32 output;
    
    coeff = input /(OMX_F64)(1 << ARM_AAC_Q_FACTOR);
    coeff = coeff * pow(2.0 , -isPos/4.0);

    if (cbNum == ARM_AAC_INTENSITY_HCB2)
    {
        coeff = -coeff;
    }
    
    output = armSatRoundFloatToS32(coeff * (1 << ARM_AAC_Q_FACTOR ));
    
    return output;
}

