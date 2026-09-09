/**
 *  omxICJP_DCTQuantFwd_Multiple_S16.c
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
 * This file contains module for multiple block FDCT with quantization
 *
 */

#include "omxtypes.h"
#include "omxIC.h"

#include "armCOMM.h"

/**
 * Function: omxICJP_DCTQuantFwd_Multiple_S16
 *
 * Brief:
 * Multiple 8x8 block FDCT with quantization function.
 *
 * Description:
 * This function implements forward DCT with quantization for the 8-bit image data. It processes
 * multiple adjacent blocks (8x8).The blocks are assumed to be part of a planarized buffer.
 * This function needs to be called separately for luma and chroma buffers with the respective quantization table.
 * Output matrix is the transpose of the explicit result.
 * As a result, the Huffman coding functions in this library handle transpose as well.
 *
 *
 * Parameters:
 * [in]  pSrc           identifies input coefficient block(8x8) buffer. This start address must be 8-byte
 *                            aligned. The input components are bounded on the interval [-128, 127] within
 *                            a signed 16-bit container.
 *                            Each 8x8 block in the buffer is stored as 64 entries (16-bit) linearly in a buffer,
 *                            and the multiple blocks to be processed must be adjacent.
 * [in]  pQuantFwdTable identifies the quantization table which was generated from
 *                            "DCTQuantFwdTableInit_JPEG_U8_U16". The table length is 64. This start address must be
 *                            8-byte aligned.
 * [in]  nBlocks        the number of 8x8 blocks to be processed.
 * [out] pDst           identifies output coefficient block(8x8) buffer. This start address must be 8-byte aligned.
 *                            To achieve better performance, the output 8x8 matrix is the transpose of the explicit result. This
 *                            transpose will be handled in Huffman encoding.
 *                            In-Out Arguments
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
 
OMXResult omxICJP_DCTQuantFwd_Multiple_S16(
     const OMX_S16* pSrc,
     OMX_S16 *pDst,
     OMX_INT nBlocks,
     const OMX_U32 *pQuantFwdTable
 )
{
    OMX_INT   blockNum;
   
    /* Argument Checks */
    armRetArgErrIf( pSrc    == NULL, OMX_StsBadArgErr)
    armRetArgErrIf( pDst    == NULL, OMX_StsBadArgErr)
    armRetArgErrIf( nBlocks <  1   , OMX_StsBadArgErr)

    armRetArgErrIf( pQuantFwdTable == NULL            , OMX_StsBadArgErr)
    armRetArgErrIf( armNot8ByteAligned(pSrc)          , OMX_StsBadArgErr)
    armRetArgErrIf( armNot8ByteAligned(pDst)          , OMX_StsBadArgErr)
    armRetArgErrIf( armNot8ByteAligned(pQuantFwdTable), OMX_StsBadArgErr)
    
    /* Processing */
    for (blockNum = 0 ; blockNum < nBlocks ; blockNum++)
    {
        omxICJP_DCTQuantFwd_S16(pSrc,pDst,pQuantFwdTable);
        
        pSrc += 64;
        pDst += 64;
    }

    return OMX_StsNoErr;
    
}

/*End of File*/

