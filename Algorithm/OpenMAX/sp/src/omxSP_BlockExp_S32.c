/**
 *  omxSP_BlockExp_S32.c
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
 * This file contains module for block exponent computation
 *
 */

#include "omxtypes.h"
#include "omxSP.h"

/**
 * Function: omxSP_BlockExp_S32
 *
 * Description:
 * Block exponent calculation for 32-bit signals (count leading sign bits).
 *
 * Status: Design
 *
 * Remarks:
 * This function computes the number of extra sign bits of all values
 * in the 32-bit input vector pSrc and returns the minimum sign bit
 * count. This is also the maximum shift value that could be used in
 * scaling the block of data.
 *
 * Note:
 * This function differs from other DL functions by not returning the
 *       standard OMXError but the actual result.
 *
 * Parameters:
 * [in]  pSrc  Pointer to the input signal buffer.
 * [in]  len   Length of the signal in pSrc
 *
 * Return Value:
 * Maximum exponent that may be used in scaling.
 *
 */

OMX_S32 omxSP_BlockExp_S32(
                            const OMX_S32 *pSrc,
                            int            len
                            )
{

    OMX_S32 Var,MaxVar;
    OMX_S32 MinSignBits;


    /* Compute the Leading zeros */

    MaxVar = 0;

    do
    {
        Var = *pSrc++;

        /* Invert the bits of a Negative number */

        if(Var < 0)
        {
            Var = ~Var;
        }

        /* Compute the Maximum */

        if(Var > MaxVar)
        {
            MaxVar = Var;
        }

        len--;

    }while(len != 0);

    for (MinSignBits=31; (MaxVar>>(31-MinSignBits))!=0 ; MinSignBits--);


    return MinSignBits;
}

/* End of File */
