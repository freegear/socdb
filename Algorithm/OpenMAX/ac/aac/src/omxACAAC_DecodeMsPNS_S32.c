/**
 *  omxACAAC_DecodeMsPNS_S32.c
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
 * This file contains module for Perceptual Noise Substitution for an AAC decoder
 *
 */

#include<math.h>

#include "omxtypes.h"
#include "omxAC.h"

#include "armCOMM.h"
#include "armAC.h"

#include "armACAAC_Tables.h"

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
 
static OMX_INT armACAAC_GenerateRandomVector(
    OMX_S32 *pDstSpec,
    OMX_INT seed,
    OMX_INT width,
    OMX_S16 scale
);

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
 )
{
    OMX_INT groupNum,sfbNum,seed = 0;
    OMX_INT width,cbNum,msUsed;
    OMX_S16 scale;
    
    const OMX_U16 *pOffsetTable;
    
    /* Argument Check */        
    armRetArgErrIf( pSrcDstSpec    == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pScaleFactor   == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pSrcDstLtpFlag == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pWinGrpLen     == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pSfbCb         == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pRandomSeed    == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pMsUsed        == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pNoiseState    == NULL, OMX_StsBadArgErr);

    armRetArgErrIf( (maxSfb > 51)  || (maxSfb < 0),   OMX_StsBadArgErr);
    armRetArgErrIf( (channel != 1) && (channel != 0), OMX_StsBadArgErr);

    armRetArgErrIf( samplingFreqIndex > 12, OMX_StsBadArgErr); 
    armRetArgErrIf( samplingFreqIndex < 0 , OMX_StsBadArgErr);

    armRetArgErrIf( (numWinGrp > 8) || (numWinGrp < 1),  OMX_StsBadArgErr );

    armRetArgErrIf( ( winLen != ARM_AAC_WIN_SHORT ) && 
                    ( winLen != ARM_AAC_WIN_LONG  ) ,
                    OMX_StsBadArgErr );

    /* Processing */
    
    if(winLen == ARM_AAC_WIN_SHORT)
    {
        pOffsetTable = armACAAC_swbOffsetShortWindow[samplingFreqIndex];
    }
    else
    {
        pOffsetTable = armACAAC_swbOffsetLongWindow[samplingFreqIndex];
    }

    seed = *pRandomSeed;                        
    
    for( groupNum = 0; groupNum < numWinGrp; groupNum++ )
    {
        for( sfbNum = 0; sfbNum < maxSfb; sfbNum ++ )
        {
            cbNum  = *pSfbCb++;
            scale  = *pScaleFactor++;
            msUsed = pMsUsed[sfbNum];
            
            width  = pOffsetTable[sfbNum + 1] - pOffsetTable[sfbNum];
            width  = width * pWinGrpLen[groupNum];
            
            if( cbNum == ARM_AAC_NOISE_HCB )
            {
                if(winLen == ARM_AAC_WIN_LONG)
                {
                    pSrcDstLtpFlag[sfbNum] = 0;
                }

                if(msUsed == 1)
                {
                    /*Two channels are correlated*/
                    if (channel == 0)
                    {
                        /* Left Channel */
                        /* Stores the seed used, for the right channel */
                        pNoiseState[sfbNum] = seed;
                    }
                    else
                    {
                        /* Right Channel */
                        /* Uses the stored seed */
                        seed = pNoiseState[sfbNum];
                    }
                }
                else if(channel == 1)
                {
                    seed = *pRandomSeed;                        
                }

                seed = armACAAC_GenerateRandomVector(pSrcDstSpec,seed,width,scale);
                
                if( (msUsed == 0) && (channel == 1) )
                {
                    *pRandomSeed = seed;
                }
            }

            pSrcDstSpec += width;
        }
 
        pNoiseState += OMX_AAC_SF_MAX;
        pMsUsed     += OMX_AAC_SF_MAX;
    }

    return OMX_StsNoErr;
}

/**
 * 
 * Function: armACAAC_GenerateRandomVector
 *
 * Description:
 * Generates random vector to be used in PNS tool
 *
 *
 * Parameters:
 * [in]  pDstSpec     pointer to spectrum coefficients to be PNS
 *                      represented in Q13.18 format.
 * [in]  seed       random seed for PNS
 * [in]  width      size of the vector to be generated
 * [in]  scale      Scaling value to applied on generated vector
 *
 * [out] pDstSpec   pointer to the output spectrum substituted by
 *                        perceptual noise;represented in Q13.18 format. 
 *
 * Return Value:
 * seed: the modified random seed.
 *
 */
 
static OMX_INT armACAAC_GenerateRandomVector(
    OMX_S32 *pDstSpec,
    OMX_INT seed,
    OMX_INT width,
    OMX_S16 scale
)
{
    OMX_INT coeffNum;
    OMX_F64 temp,power = 0;
    OMX_F64 coeff,scaleValue;
    
    for(coeffNum = 0 ; coeffNum < width ; coeffNum++)
    {
        seed   = seed*(ARM_AAC_RAND_MULT) + (ARM_AAC_RAND_ADD); 
        temp   = (OMX_F64)seed/8.0;
        power += (temp*temp);
        
        pDstSpec[coeffNum] = seed;
    }
    
    /* Scaling the Noise energy */
    
    scaleValue  = pow( 2.0, 0.25 * scale);
    scaleValue *= ( 1/sqrt(power) );

    for(coeffNum = 0; coeffNum < width ; coeffNum++ )
    {
        coeff  = (OMX_F64)pDstSpec[coeffNum];
        coeff *= scaleValue;
        coeff *= (1/8.0);

        pDstSpec[coeffNum] = armSatRoundFloatToS32(coeff * (1 << ARM_AAC_Q_FACTOR)) ;
    }

    return seed;
}

/*End Of file*/

