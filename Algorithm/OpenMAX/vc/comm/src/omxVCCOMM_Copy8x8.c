/**
 *  omxVCCOMM_Copy8x8.c
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
 * Description:
 * MPEG4 8x8 Copy module
 * 
 */
 
#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"
#include "omxVC.h"

/**
 * Function: omxVCCOMM_Copy8x8
 *
 * Description:
 * Copies the reference 8x8 block to the current block.
 * Parameters:
 * [in] pSrc - pointer to the reference block in the source frame; must be aligned on an 8-byte boundary.
 * [in] step - distance between the starts of consecutive lines in the reference frame, in bytes;
 *             must be a multiple of 8 and must be larger than or equal to 8.
 * [out] pDst - pointer to the destination block; must be aligned on an 8-byte boundary.
 * Return Value:
 *	OMX_StsNoErr - no error
 *	OMX_StsBadArgErr - bad arguments; returned under any of the following conditions:
 *		             - one or more of the following pointers is NULL:  pSrc, pDst
 *		             - one or more of the following pointers is not aligned on an 8-byte boundary:  pSrc, pDst
 *		             - step <8 or step is not a multiple of 8.  
 */

OMXResult omxVCCOMM_Copy8x8(
		const OMX_U8 *pSrc, 
		OMX_U8 *pDst, 
		OMX_INT step)
 {
    /* Definitions and Initializations*/

    OMX_INT count,index, x, y;
    
    /* Argument error checks */
    armRetArgErrIf(pSrc == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pSrc), OMX_StsBadArgErr);
    armRetArgErrIf(!armIs8ByteAligned(pDst), OMX_StsBadArgErr);
    armRetArgErrIf(((step < 8) || (step % 8)), OMX_StsBadArgErr);
    
    
    /* Copying the ref 8x8 blk to the curr blk */
    for (y = 0, count = 0, index = 0; y < 8; y++, count = count + step - 8)
    {
        for (x = 0; x < 8; x++, count++, index++)
        {
            pDst[index] = pSrc[count];
        }       
    }
    return OMX_StsNoErr;
 }
