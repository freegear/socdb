/**
 *  omxACAAC_EncodeTNS_S32_I.c
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
 * This file contains module for reversing TNS decoding process in an LTP loop
 * for an AAC decoder
 *
 */

#include "omxtypes.h" 
#include "omxAC.h"

#include "armAC.h"
#include "armCOMM.h"
#include "armACAAC_Tables.h"

/**
 * Function: omxACAAC_EncodeTNS_S32_I
 *
 * Description:
 * Analysis TNS module
 * Reference to ISO/IEC 14496-3 Sect 6.6
 *
 * Remarks:
 * In the Long Term Prediction (LTP) loop, Analysis Temporal Noise Shaping is needed for
 * reversion of TNS.
 *
 *
 * Parameters:
 * [in]  pSrcDstSpectralCoefs  pointer to the spectral coefficients to do encode TNS
 *												represented in Q13.18 format.  
 * [in]  pTnsNumFilt      pointer to number of TNS filter
 * [in]  pTnsRegionLen    pointer to length of TNS filter
 * [in]  pTnsFiltOrder    pointer to TNS filter order
 * [in]  pTnsFiltCoefRes  pointer to TNS coef resolution flag
 * [in]  pTnsFiltCoef     pointer to TNS filter coefficients
 * [in]  pTnsDirection    pointer to TNS direction flag
 * [in]  maxSfb           maximum scale factor number
 * [in]  profile          audio profile
 * [in]  samplingRateIndex sampling frequency index
 * [out] pSrcDstSpectralCoefs  pointer to the spectral coefficients have done encode TNS
 *												represented in Q13.18 format.  
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxACAAC_EncodeTNS_S32_I(
     OMX_S32 *pSrcDstSpectralCoefs,
     const OMX_INT *pTnsNumFilt,
     const OMX_INT *pTnsRegionLen,
     const OMX_INT *pTnsFiltOrder,
     const OMX_INT *pTnsFiltCoefRes,
     const OMX_S8 *pTnsFiltCoef,
     const OMX_INT *pTnsDirection,
     OMX_INT maxSfb,
     OMX_INT profile,
     OMX_INT samplingRateIndex
 )
{

    const OMX_U16 *pOffsetTable;
    OMX_U16 swbCount,top,offset;
    OMX_INT winCount,filtCount,winNum,filtNum,regionLen,bottom;
    OMX_INT tnsOrder,direction,increment,coeffRes,size,start,end;
    OMX_U8  tnsMaxBand;

    OMX_F64 lpCoeff[20];

    OMXResult errorCode;
    
    /* Argument Check */
    armRetArgErrIf( pSrcDstSpectralCoefs == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pTnsNumFilt          == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pTnsRegionLen        == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pTnsFiltOrder        == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pTnsFiltCoefRes      == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pTnsFiltCoef         == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pTnsDirection        == NULL, OMX_StsBadArgErr);
    
    armRetArgErrIf( samplingRateIndex > 11, OMX_StsBadArgErr);
    armRetArgErrIf( samplingRateIndex < 0 , OMX_StsBadArgErr);
    armRetArgErrIf( profile != 1          , OMX_StsBadArgErr);

    /* Processing */        
    swbCount     = armACAAC_numSwbLong[samplingRateIndex];
    pOffsetTable = armACAAC_swbOffsetLongWindow[samplingRateIndex];
    tnsMaxBand   = armACAAC_TnsMaxBands[samplingRateIndex][0];
    winCount     = 1;


    armRetArgErrIf( (maxSfb > swbCount) || (maxSfb < 0), OMX_StsBadArgErr);
   
    for(winNum = 0; winNum < winCount ; winNum++)
    {
        filtCount = pTnsNumFilt[winNum];
        coeffRes  = pTnsFiltCoefRes[winNum];

        /* Argument Check */
        armRetDataErrIf( (filtCount < 0)|| (filtCount > 3),
                                OMX_StsAacTnsNumFiltErr );
        
        armRetDataErrIf( (filtCount!= 0) && ( (coeffRes < 3) || (coeffRes > 4) ),
                                OMX_StsAacTnsCoefResErr );
            
        bottom = swbCount;
        
        for(filtNum = 0; filtNum < filtCount ; filtNum++)
        {
            regionLen = pTnsRegionLen[winNum + filtNum];
            tnsOrder  = pTnsFiltOrder[winNum + filtNum];
            direction = pTnsDirection[winNum + filtNum];

            if (tnsOrder == 0)
            {
                continue;
            }
            
            armRetDataErrIf( (regionLen < 0) || (regionLen > swbCount),
                                    OMX_StsAacTnsLenErr );

            armRetDataErrIf( (tnsOrder < 0) || (tnsOrder > 12),
                                    OMX_StsAacTnsOrderErr );

            armRetDataErrIf( (direction < 0) || (direction > 1),
                                    OMX_StsAacTnsDirectErr );
            
            top    = bottom;
            bottom = top - regionLen;
            
            if(bottom < 0)
            {
                bottom = 0;
            }

            /*Decoding Filter Coefficients*/

            errorCode = armACAAC_TnsDecodeCoef(pTnsFiltCoef,lpCoeff,coeffRes,tnsOrder);
            
            armRetDataErrIf( errorCode != OMX_StsNoErr, errorCode );

            pTnsFiltCoef += tnsOrder;
            
            offset = armMin(tnsMaxBand,maxSfb);

            start = pOffsetTable[armMin(bottom,offset)];
            end   = pOffsetTable[armMin(top,offset)];
            
            size  = end - start;
            
            if ( size <= 0 )
            {
                continue;
            }
            
            if (direction == 1)
            {
                increment = -1;
                start     = end - 1;
            } 
            else
            {
                increment = 1;
            }
            
            /*Filtering*/
            
            armACAAC_TnsFilter(&pSrcDstSpectralCoefs[start],lpCoeff,size,increment,tnsOrder,1);
        }
        
        pSrcDstSpectralCoefs += ARM_AAC_WIN_SHORT;
    }

    return OMX_StsNoErr;
}


/* End of File */
