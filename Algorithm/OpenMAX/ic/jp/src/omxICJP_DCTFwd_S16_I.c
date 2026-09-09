/**
 *  omxICJP_DCTFwd_S16_I.c
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
 * This file contains module for inplace FDCT 
 *
 */

#include "omxtypes.h"
#include "omxIC.h"

#include "armCOMM.h"

/**
 * Function: omxICJP_DCTFwd_S16_I
 *
 * Brief:
 * Performs an in-place 8x8 block forward discrete cosine transform (DCT).
 *
 * Description:
 * This function implements forward DCT for the 8-bit image data (packed into signed 16-bit).
 * It processes one block (8x8) in-place.Output matrix is the transpose of the explicit result.
 * As a result, the Huffman coding functions in this library handle transpose as well.
 *
 *
 * Parameters:
 * [in,out]  pSrc           identifies the input coefficient block(8x8) buffer for in-place processing. This start address must be 8-byte
 *                            aligned. The input components are bounded on the interval [-128, 127] within a 16-bit container.
 *                            To achieve better performance, the output 8x8 matrix is the transpose of the explicit result. This
 *                            transpose can be handled in later processing stages (e.g. Huffman encoding).
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_DCTFwd_S16_I(
     OMX_S16* pSrc
 )
{
    OMXResult errorCode;
    OMX_S16   tempBuffer[67]; /*3 dummy elements for alignment consideration*/
    OMX_S16   *pBuffer;
    OMX_INT   i;
    
    pBuffer = armAlignTo8Bytes(tempBuffer);
    
    errorCode = omxICJP_DCTFwd_S16((const OMX_S16 *)pSrc,pBuffer);
                                                
    armRetArgErrIf(errorCode != OMX_StsNoErr, errorCode);
    
    for ( i = 0 ; i < 64 ; i++)
    {
        pSrc[i] = pBuffer[i];
    }

    return OMX_StsNoErr;
}

/*End of File*/
