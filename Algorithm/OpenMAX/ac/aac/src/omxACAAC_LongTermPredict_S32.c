/**
 *  omxACAAC_LongTermPredict_S32.c
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
 * This file contains module for Long Term Prediction used in LTP loop of AAC decoder
 *
 */

#include "omxtypes.h"
#include "omxAC.h"

#include "armCOMM.h"
#include "armACAAC_Tables.h"

/**
 * Function: omxACAAC_LongTermPredict_S32
 *
 * Description:
 * Long Term Prediction
 * Reference to ISO/IEC 14496-3 Sect 6.6
 *
 * Remarks:
 * In the Long Term Prediction (LTP) loop, Analysis LTP is needed to get the predicted time
 * domain signals.
 *
 *
 * Parameters:
 * [in]  pSrcTimeSignal     pointer to the temporal signals to be predicted in 
 *													temporary domain;represented in Q13.18 format.  
 * [in]  pDstEstTimeSignal  pointer to the output of samples after LTP;
 *													represented in Q13.18 format.  
 * [in]  pAACLtpInfo        pointer to the LTP information
 * [out] pDstEstTimeSignal  pointer to the output of prediction in time domain
 *													represented in Q13.18 format.  
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
 
OMXResult omxACAAC_LongTermPredict_S32(
     OMX_S32 *pSrcTimeSignal,
     OMX_S32 *pDstEstTimeSignal,
     OMXAACLtpInfo *pAACLtpInfo
 )
{
    OMX_F64 scale,coeff;
    OMX_INT Offset;
    OMX_INT numSamples,coeffNum;
    
    /* Argument Check */
    armRetArgErrIf( pSrcTimeSignal    == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pDstEstTimeSignal == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pAACLtpInfo       == NULL, OMX_StsBadArgErr);

    armRetArgErrIf( pAACLtpInfo->ltpCoef > 7 , OMX_StsBadArgErr) 
    armRetArgErrIf( pAACLtpInfo->ltpCoef < 0 , OMX_StsBadArgErr);

    armRetArgErrIf( pAACLtpInfo->ltpLag > 2047 , OMX_StsBadArgErr) 
    armRetArgErrIf( pAACLtpInfo->ltpLag < 0    , OMX_StsBadArgErr);
    
    /* Processing */
    scale = armACAAC_ltpTable[pAACLtpInfo->ltpCoef];
    
    Offset = (ARM_AAC_WIN_LONG << 1) - pAACLtpInfo->ltpLag;
    
    if(pAACLtpInfo->ltpLag > ARM_AAC_WIN_LONG)
    {
        numSamples  = (ARM_AAC_WIN_LONG << 1);
    }
    else
    {
        numSamples = ARM_AAC_WIN_LONG + pAACLtpInfo->ltpLag;
    }

    for (coeffNum = 0; coeffNum < numSamples ; coeffNum++)
    {
        coeff = scale * ( pSrcTimeSignal[Offset + coeffNum] / (OMX_F64)(1 << ARM_AAC_Q_FACTOR) );
        pDstEstTimeSignal[coeffNum] = armSatRoundFloatToS32(coeff * (1 << ARM_AAC_Q_FACTOR));
    }
    
    for(coeffNum = numSamples ; coeffNum < (ARM_AAC_WIN_LONG << 1) ; coeffNum++)
    {
        pDstEstTimeSignal[coeffNum] = 0;
    }

    return OMX_StsNoErr;
}

/*End of File*/
