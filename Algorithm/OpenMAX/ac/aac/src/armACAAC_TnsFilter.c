/**
 *  armACAAC_TnsFilter.c
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
 * This file contains module for TNS filtering (Encode/Decode)
 *
 */

#include "omxtypes.h"

#include "armAC.h"
#include "armCOMM.h"

/**
 * Function: armACAAC_TnsFilter
 *
 * Description:
 * TNS filter for analysis/synthesis. Depending on the 'flag' this module behaves
 * as FIR(Encode) or IIR (decode) filter.
 *
 * Parameters:
 * [in]  pSpectralCoeff pointer to the spectral coefficients to do encode TNS
 *                                             	represented in Q13.18 format.  
 * [in]  pLpCoeff       pointer to the LPC coefficients
 * [in]  size           size of filtering
 * [in]  tnsOrder       TNS filter order
 * [in]  increment      indicating direction of filtering
 * [in]  flag           Indicating Encode/Decode 1: Encode 0: Decode
 * [out] pSpectralCoeff pointer to the spectral coefficients have done encode TNS
 *												represented in Q13.18 format.  
 *
 */

OMXVoid   armACAAC_TnsFilter(
    OMX_S32 *pSpectralCoeff,
    OMX_F64 *pLpCoeff,
    OMX_INT size,
    OMX_INT increment, 
    OMX_INT tnsOrder,
    OMX_INT flag
)
{
    
    OMX_F64 delayLine[21]; /* TNS_MAX_ORDER + 1*/
    OMX_F64 mac,prod,coeff;

    OMX_INT count,order;
    
    /*Intializing the delayline*/
    
    for (count = 0; count < 21 ; count++)
    {
        delayLine[count] = 0;
    }
    
    for (count = 0; count < size ; count ++)    
    {
        mac  = 0;

        for(order = tnsOrder ; order >= 1 ; order--)
        {
            prod   = pLpCoeff[order] * delayLine[order] ;
            mac   += prod;
            
            delayLine[order] = delayLine[order - 1];
        }
        coeff = *pSpectralCoeff /(OMX_F64)(1 << ARM_AAC_Q_FACTOR) ;
        
        if(flag == 1)
        {
            /*Synthesis/Encode*/
            mac = coeff + mac;
            delayLine[1] = coeff;
        }
        else
        {
            /*Analysis/Decode*/
            mac = coeff - mac;
            delayLine[1] = mac;
        }
        
        *pSpectralCoeff   = armSatRoundFloatToS32(mac * (1 << ARM_AAC_Q_FACTOR) );
        pSpectralCoeff   += increment;
    }

    return;
}

/*End of File*/

