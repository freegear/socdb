/**
 *
 *  armIPPP_ComputeBinomialCoeff.c
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
 * Description  : Computes the product of binomial coefficient of two terms.
 *
 */

#include "omxtypes.h"
#include "armIP.h"

/**
 * Function: armIPPP_ComputeBinomialCoeff
 *
 * Description:
 * Computes the binomial coefficient of the expression 
 * [(x-xOff)^mOrd * (y-yOff)^nOrd * f(x,y)] for the (r1,r2)th term,
 * where (0 <= r1 <= mOrd) and (0 <= r2 <= nOrd).
 *
 * Return Value:
 * OMX_S64 -- The value of binomial coefficient
 */
 
OMX_S64 armIPPP_ComputeBinomialCoeff(
        OMX_INT mOrd,
        OMX_INT nOrd,
        OMX_U8  r1,
        OMX_U8  r2,
        OMX_INT xOff,
        OMX_INT yOff
       )
{
    OMX_S64 coeff;
    OMX_S32 comb1, comb2;
    OMX_S32 numerator = 1, denominator = 1;
    OMX_INT i;
    
    /**
    ------------------------------------------------------------------------------
    Computing the binomial coefficient of [(x-xOff)^mOrd * (y-yOff)^nOrd * f(x,y)]
    for the (r1,r2)th term, where (0 <= r1 <= mOrd) and (0 <= r2 <= nOrd).
    
    BinCoeff = C(mOrd,r1) * C(nOrd,r2) * xOff^(mOrd-r1) * yOff^(nOrd-r2),
    where C is the combination function.
    ------------------------------------------------------------------------------
    */
    
    for(i = 0; i < r1; i++)
    {
        numerator   *= (mOrd - i);
        denominator *= (r1 - i);
    }
    
    comb1 = armRoundFloatToS16((OMX_F32)numerator/denominator);
    numerator = denominator = 1;
    
    for(i = 0; i < r2; i++)
    {
        numerator   *= (nOrd - i);
        denominator *= (r2 - i);
    }
    
    comb2 = armRoundFloatToS16((OMX_F32)numerator/denominator);
    coeff = armIPPP_Power(xOff,(mOrd-r1)) * armIPPP_Power(yOff,(nOrd-r2)) * comb1 * comb2;
    return coeff;
}

/* End of file */
