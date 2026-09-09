/**
 *  omxICJP_DCTFwd_S16.c
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
 * This file contains module for FDCT
 *
 */

#include "omxtypes.h"
#include "omxIC.h"

#include "armIC.h"
#include "armCOMM.h"

/**
 * Function: omxICJP_DCTFwd_S16
 *
 * Brief:
 * Performs an 8x8 block forward discrete cosine transform (DCT).
 *
 * Description:
 * This function implements forward DCT for the 8-bit image data (packed into signed 16-bit).
 * It processes one block (8x8).Output matrix is the transpose of the explicit result.
 * As a result, the Huffman coding functions in this library handle transpose as well.
 *
 *
 * Parameters:
 * [in]  pSrc           identifies input coefficient block(8x8) buffer. This start address must be 8-byte
 *                            aligned. The input components are bounded on the interval [-128, 127].
 * [out] pDst           identifies output DCT coefficient block(8x8) buffer. This start address must be 8-byte aligned.
 *                            To achieve better performance, the output 8x8 matrix is the transpose of the explicit result. This
 *                            transpose can be handled in later processing stages (e.g. Huffman encoding).
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_DCTFwd_S16(
     const OMX_S16* pSrc,
     OMX_S16 *pDst
 )
{
    /* Argument Checks */
    armRetArgErrIf( pSrc == NULL, OMX_StsBadArgErr)
    armRetArgErrIf( pDst == NULL, OMX_StsBadArgErr)
    
    armRetArgErrIf( armNot8ByteAligned(pSrc), OMX_StsBadArgErr)
    armRetArgErrIf( armNot8ByteAligned(pDst), OMX_StsBadArgErr)
    
    /* Processing */
    armICJP_DCTQuantFwd_S16(pSrc, pDst, NULL);

    return OMX_StsNoErr;
}

/*End of File*/
