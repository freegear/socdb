/**
 *  omxACAAC_LongTermReconstruct_S32.c
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
 * This file contains module for Long Term Reconstruction for an AAC decoder
 *
 */

#include "omxtypes.h"
#include "omxAC.h"

#include "armAC.h"
#include "armCOMM.h"

#include "armACAAC_Tables.h"

/**
 * Function: omxACAAC_LongTermReconstruct_S32_I
 *
 * Description:
 * Reconstruction portion of the LTP loop; 
 * adds the vector of decoded spectral coefficients and the corresponding spectral-domain LTP output vector to obtain a vector of reconstructed spectral samples
 * Reference to ISO/IEC 14496-3 Sect 6.6
 *
 * Remarks:
 * Use Long Term Reconstruct (LTR) to reduce the redundancy of a signal between successive
 * coding frames.
 *
 * Parameters:
 * [in]  pSrcDstSpec        pointer to decoded spectral coefficients
 * [in]  pSrcEstSpec        pointer to the spectral-domain LTP output vector
 * [in]  samplingFreqIndex  sampling frequency index
 * [in]  pLtpFlag           pointer to the vector of scalefactor band LTP indicator flags
 * [out] pSrcDstSpec        pointer to reconstructed spectral coefficient vector
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxACAAC_LongTermReconstruct_S32_I(
     OMX_S32 *pSrcEstSpec,
     OMX_S32 *pSrcDstSpec,
     OMX_INT *pLtpFlag,
     OMX_INT samplingFreqIndex
 )
{
    OMX_INT numSwb,sfbNum;
    OMX_INT ltpFlag,width,coeffNum;
    const OMX_U16 *pOffsetTable;
     
    /* Argument Check */
    armRetArgErrIf( pSrcEstSpec == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pSrcDstSpec == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pLtpFlag    == NULL, OMX_StsBadArgErr);

    armRetArgErrIf( samplingFreqIndex > 12,  OMX_StsBadArgErr);
    armRetArgErrIf( samplingFreqIndex < 0 , OMX_StsBadArgErr);

    /* Processing */
    numSwb       = armACAAC_numSwbLong[samplingFreqIndex];
    pOffsetTable = armACAAC_swbOffsetLongWindow[samplingFreqIndex];
    
    for(sfbNum = 0 ; sfbNum < numSwb ; sfbNum ++)
    {
        ltpFlag = pLtpFlag[sfbNum];
        width   = pOffsetTable[sfbNum + 1] - pOffsetTable[sfbNum];
        
        if(ltpFlag == 1)
        {
            for(coeffNum = 0; coeffNum < width ; coeffNum++)
            {
                pSrcDstSpec[coeffNum] = armSatAdd_S32(pSrcDstSpec[coeffNum],pSrcEstSpec[coeffNum]);
            }
        }

        pSrcDstSpec += width;
        pSrcEstSpec += width;
    }
       
    return OMX_StsNoErr;
}

/*End of File*/
