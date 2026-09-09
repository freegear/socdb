/**
 *  armVCM4P2_FillVLDBuffer.c
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
 * Contains module for VLC get bits from the stream 
 *
 */ 

#include "omxtypes.h" 
#include "armVCM4P2_ZigZag_Tables.h"


/**
 * Function: armVCM4P2_FillVLDBuffer
 *
 * Description:
 * Performs filling of the coefficient buffer according to the run, level
 * and sign, also updates the index
 * 
 * Parameters:
 * [in]  storeRun        Stored Run value (count of zeros)   
 * [in]  storeLevel      Stored Level value (non-zero value)
 * [in]  sign            Flag indicating the sign of level
 * [in]  last            status of the last flag
 * [in]  pIndex          pointer to coefficient index in 8x8 matrix
 * [out] pIndex          pointer to updated coefficient index in 8x8 
 *                       matrix
 * [in]  pZigzagTable    pointer to the zigzag tables
 * [out] pDst            pointer to the coefficient buffer of current
 *                       block. Should be 32-bit aligned
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult armVCM4P2_FillVLDBuffer(
    OMX_U32 storeRun,
    OMX_S16 * pDst,
    OMX_S16 storeLevel,
    OMX_U8  sign,
    OMX_U8  last,
    OMX_U8  * pIndex,
    const OMX_U8 * pZigzagTable
)
{
    /* Store the zero's as per the run length count */
    for (;storeRun > 0; storeRun--, (*pIndex)++)
    {
        pDst[pZigzagTable[*pIndex]] = 0;
    }
    /* Store the level depending on the sign*/
    if (sign == 1)
    {
        pDst[pZigzagTable[*pIndex]] = -storeLevel;
    }
    else
    {
        pDst[pZigzagTable[*pIndex]] = storeLevel;
    }
    (*pIndex)++;

    /* If last is 1, fill the remaining elments of the buffer with zeros */
    if (last == 1)
    {
        while (*pIndex < 64)
        {
            pDst[pZigzagTable[*pIndex]] = 0;
            (*pIndex)++;
        }
    }

    return OMX_StsNoErr;
}

