/**
 *  omxICJP_DCTQuantInv_Multiple_S16.c
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
 * This file contains module for multiple block IDCT with de-quantization
 *
 */

#include "omxtypes.h"
#include "omxIC.h"

#include "armCOMM.h"

/**
 * Function: omxICJP_DCTQuantInv_Multiple_S16
 *
 * Brief:
 * Multiple block dequantization and IDCT function.
 *
 * Description:
 * This function implements inverse DCT with dequantization for 8-bit image data. It processes multiple
 * blocks (each 8x8).The blocks are assumed to be part of a planarized buffer.
 * This function needs to be called separately for luma and chroma buffers with the respective quantization table.
 * The start address of pQuantRawTable and pQuantInvTable must be 8-byte aligned.
 *
 *
 * Parameters:
 * [in]  pSrc           identifies the input coefficient block (8x8) buffer. The start address must be 8-byte
 *                      aligned.
 * [in]  nBlocks        the number of 8x8 blocks to be processed.
 * [in]  pQuantInvTable identifies the quantization table which was generated from
 *                      "omxICJP_DCTQuantInvTableInit". The table length is 64 by 32-bits. The start address must be
 *                      8-byte aligned.
 * [out] pDst           identifies output coefficient block(8x8) buffer. The start address must be 8-byte aligned.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
 
OMXResult omxICJP_DCTQuantInv_Multiple_S16(
     const OMX_S16 *pSrc,
     OMX_S16 *pDst,
     OMX_INT nBlocks,
     const OMX_U32 *pQuantInvTable
 )
{
    
    OMX_INT   blockNum;
   
    /* Argument Checks */
    armRetArgErrIf( pSrc    == NULL, OMX_StsBadArgErr)
    armRetArgErrIf( pDst    == NULL, OMX_StsBadArgErr)
    armRetArgErrIf( nBlocks <  1   , OMX_StsBadArgErr)
    
    armRetArgErrIf( pQuantInvTable == NULL            , OMX_StsBadArgErr)
    armRetArgErrIf( armNot8ByteAligned(pSrc)          , OMX_StsBadArgErr)
    armRetArgErrIf( armNot8ByteAligned(pDst)          , OMX_StsBadArgErr)
    armRetArgErrIf( armNot8ByteAligned(pQuantInvTable), OMX_StsBadArgErr)
    
    /* Processing */
    for (blockNum = 0 ; blockNum < nBlocks ; blockNum++)
    {
        omxICJP_DCTQuantInv_S16(pSrc,pDst,pQuantInvTable);
        
        pSrc += 64;
        pDst += 64;
    }

    return OMX_StsNoErr;
}

/*End of File*/
