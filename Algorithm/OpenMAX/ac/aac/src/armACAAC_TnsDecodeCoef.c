/**
 *  armACAAC_TnsDecodeCoef.c
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
 * This file contains module for decoding TNS coefficients
 *
 */

#include "omxtypes.h"

#include "armAC.h"
#include "armACAAC_Tables.h"

/**
 * Function: armACAAC_TnsDecodeCoef
 *
 * Description:
 * Inverse Quantization and conversion to LPC coefficients
 *
 * Parameters:
 * [in]  pTnsFiltCoef pointer to TNS filter coefficients
 * [in]  coeffRes     TNS coef resolution bits
 * [in]  tnsOrder     TNS filter order
 * [out] pLpCoeff     pointer to the LPC coefficients
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult armACAAC_TnsDecodeCoef(
    const OMX_S8 *pTnsFiltCoef,
    OMX_F64 *pLpCoeff,
    OMX_INT coeffRes,
    OMX_INT tnsOrder
)
{
    
    OMX_INT coeff,i;

    OMX_F64 invQuantCoeff[20]; 
    OMX_F64 temp[20];
    OMX_F64 prod;
    
    coeffRes -= 3;
    
    /* Inverse Quantization */

    for (i = 0; i < tnsOrder ; i++)
    {
        if( (pTnsFiltCoef[i] < - 8) || ( pTnsFiltCoef[i] > 7 ) )
        {
            return OMX_StsAacTnsCoefErr;
        }

        invQuantCoeff[i] = armACAAC_SinLookUp[ ( (pTnsFiltCoef[i] + 8) << 1 ) + coeffRes];
    }
    
    /* Conversion to LPC coefficients */
    
    pLpCoeff[0] = 1;

    for (coeff = 1; coeff <= tnsOrder; coeff++)
    {
        for (i = 1; i < coeff ; i++)
        { 
            prod    = invQuantCoeff[coeff - 1] * pLpCoeff[coeff - i];
            temp[i] = pLpCoeff[i] + prod;
        }

        for (i = 1; i < coeff; i++)
        { 
            pLpCoeff[i] = temp[i];
        }
        
        pLpCoeff[coeff] = invQuantCoeff[coeff - 1];
    }
    
    return OMX_StsNoErr;
}

/*End of File*/
