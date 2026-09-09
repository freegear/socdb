/**
 *  omxACAAC_QuantInv_S32_I.c
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
 * This file contains module for Inverse Quantization of input data for an AAC decoder
 *
 */

#include <math.h>
 
#include "omxtypes.h"
#include "omxAC.h"

#include "armCOMM.h"
#include "armCOMM_Bitstream.h"
#include "armAC.h"

#include "armACAAC_Tables.h"

static OMX_S32 armACAAC_Rescale(
        OMX_S32 Value,
        OMX_INT signBit, 
        OMX_S16 scalefactor
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
 * [in]  pSrcDstSpectralCoef        pointer to the input quantized
 * 										  						coefficients in Q13.18 format. For short 
 *                                  block the coefficients are interleaved by
 *                                        scalefactor window bands in each
 *                                        group. Buffer length must = 1024
 * [in]  pScalefactor               pointer to the scalefactor buffer.
 *                                        Buffer length must = 120.
 * [in]  numWinGrp                  group number
 * [in]  pWinGrpLen                 pointer to the number of windows in each group.
 * [in]  maxSfb                     max scalefactor bands number for the current block
 * [in]  pSfbCb                     pointer to the scalefactor band codebook,
 *                                        buffer length must = 120. Only maxSfb
 * [in]  samplingRateIndex          sampling rate index. Valid in [0, 11].
 * [in]  winLen                     the data number in one window
 * [out] pSrcDstSpectralCoef        pointer to the input quantized
 * 										  						coefficients in Q13.18 forma. For short 
 *                                  block the coefficients are interleaved by
 *                                        scalefactor window bands in each
 *                                        group. Buffer length must = 1024
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
 )
{
    const OMX_U16 *pOffsetTable;
    OMX_U16 width,numSwb;
    OMX_INT groupNum,sfbNum,signBit;
    OMX_INT winNum,coeffNum,cbNum;
    OMX_S32 Value;
    OMX_S16 scale;
    
    /* Argument Check */        
    armRetArgErrIf(pSrcDstSpectralCoef == NULL , OMX_StsBadArgErr);
    armRetArgErrIf(pScalefactor        == NULL , OMX_StsBadArgErr);
    armRetArgErrIf(pWinGrpLen          == NULL , OMX_StsBadArgErr);
    armRetArgErrIf(pSfbCb              == NULL , OMX_StsBadArgErr);

    armRetArgErrIf( (maxSfb > 51) || (maxSfb < 0), OMX_StsBadArgErr);
    armRetArgErrIf( samplingRateIndex > 11 , OMX_StsBadArgErr);
    armRetArgErrIf( samplingRateIndex < 0  , OMX_StsBadArgErr);

    armRetArgErrIf( ( winLen != ARM_AAC_WIN_SHORT ) && 
                    ( winLen != ARM_AAC_WIN_LONG  ) ,
                    OMX_StsBadArgErr );

    armRetArgErrIf( ( winLen == ARM_AAC_WIN_SHORT ) && 
                    ( (numWinGrp > 8) || (numWinGrp < 1) ), 
                    OMX_StsBadArgErr );

    armRetArgErrIf( ( winLen == ARM_AAC_WIN_LONG ) && 
                    ( numWinGrp != 1) ,
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
    
    armRetArgErrIf( maxSfb > numSwb , OMX_StsAacMaxSfbErr);

    for( groupNum = 0; groupNum < numWinGrp; groupNum++ )
    {
        for( sfbNum = 0; sfbNum < maxSfb; sfbNum ++ )
        {
            cbNum = *pSfbCb++;
            scale = *pScalefactor++;
            
            width = pOffsetTable[sfbNum + 1] - pOffsetTable[sfbNum];
            
            if(
                cbNum != ARM_AAC_ZERO_HCB       &&
                cbNum != ARM_AAC_NOISE_HCB      &&
                cbNum != ARM_AAC_INTENSITY_HCB2 &&
                cbNum != ARM_AAC_INTENSITY_HCB  
               )
            {
                for(winNum = 0 ; winNum < pWinGrpLen[groupNum] ; winNum++ )
                {
                    for(coeffNum = 0; coeffNum < width ; coeffNum++ )
                    {

                        Value = *pSrcDstSpectralCoef;
                        
                        signBit  = 1;
                        
                        if(Value < 0)
                        {
                            Value   = -Value;
                            signBit = -1;
                        }
                        
                        armRetDataErrIf(Value > 8191, OMX_StsAacCoefValErr)

                        Value = armACAAC_Rescale( Value, signBit, scale );
                    
                        *pSrcDstSpectralCoef++ = Value;
                    }
                }
            }
            else
            {
                pSrcDstSpectralCoef += pWinGrpLen[groupNum]*width;
            }
        }
    }

    return OMX_StsNoErr;
}

/**
 * Function: armACAAC_Rescale
 *
 * Description:
 * Scales input with 2^( (scalefactor - 100)/ 4)
 *
 * Parameters:
 * [in]  Value	     the input to be scaled
 * [in]  scalefactor scaling coefficient
 *
 * Return Value:
 * The scaled value of the input
 *
 */
static OMX_S32 armACAAC_Rescale(OMX_S32 Value, OMX_INT signBit, OMX_S16 scalefactor)
{

    OMX_F64 ValueFl;

    ValueFl = pow((OMX_F64)Value, 4.0/3);
    ValueFl = ValueFl * pow( 2 , (scalefactor - 100)/4.0 );

    ValueFl *= (1 << ARM_AAC_Q_FACTOR );
    ValueFl *= signBit;
    
    Value = armSatRoundFloatToS32(ValueFl);
    
    return Value;
}


/* End of File */
