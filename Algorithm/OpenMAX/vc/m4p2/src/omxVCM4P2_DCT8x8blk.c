/**
 *  omxVCM4P2_DCT8x8blk.c
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
 * Contains modules for 8x8 block DCT
 * 
 */
 
#include <math.h>
#include "omxtypes.h"
#include "armCOMM.h"
#include "armVCM4P2_DCT_Table.h"

/**
 *Function:  omxVCM4P2_DCT8x8blk
 *Description: Computes a 2D forward DCT for a single 8x8 block, as defined in ISO/IEC 14496-2
 *
 *Parameters:
 *[in] pSrc - pointer to the start of the linearly arranged input buffer; must be aligned
 *             on a 16 byte boundary.Input values (pixel intensities) are valid in the range [-255,255].
 *[out]pDst - pointer to the start of the linearly arranged output buffer; must be aligned
 *             on a 16 byte boundary.
 *
 *Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *   -	Either pSrc or pDst is NULL.
 *   -	Either pSrc or pDst is not 16 byte aligned.
 *
 */

OMXResult omxVCM4P2_DCT8x8blk (const OMX_S16 *pSrc, OMX_S16 *pDst)
{
    OMX_INT x, y, u, v;
    
    /* Argument error checks */
    armRetArgErrIf(pSrc == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(!armIs16ByteAligned(pSrc), OMX_StsBadArgErr);
    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(!armIs16ByteAligned(pDst), OMX_StsBadArgErr);


    for (u = 0; u < 8; u++)
    {
        for (v = 0; v < 8; v++)
        {
            OMX_F64 sum = 0.0;
            for (x = 0; x < 8; x++)
            {
                for (y = 0; y < 8; y++)
                {
                    sum += pSrc[(x * 8) + y] *
                       armVCM4P2_preCalcDCTCos[x][u] *
                       armVCM4P2_preCalcDCTCos[y][v];
                }
            }
            pDst[(u * 8) + v]= armRoundFloatToS16 (sum);            
        }
    }

    return OMX_StsNoErr;
}



/* End of file */


