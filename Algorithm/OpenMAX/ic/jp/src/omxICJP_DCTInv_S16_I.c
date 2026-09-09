/**
 *  omxICJP_DCTInv_S16_I.c
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
 * This file contains module for inplace IDCT
 *
 */

#include "omxtypes.h"
#include "omxIC.h"

#include "armCOMM.h"

/**
 * Function: omxICJP_DCTInv_S16_I
 *
 * Brief:
 * In-place single block IDCT function.
 *
 * Description:
 * This function implements an inverse DCT for 8-bit image data. It processes one
 * block (8x8) in an in-place fashion.
 * The start address of pQuantRawTable must be 8-byte aligned.
 *
 *
 * Parameters:
 * [in,out]  pSrcDst      identifies the shared buffer for the input DCT coefficient block (8x8)
 *                        and the output image pixel data block. The start address must be 8-byte
 *                        aligned.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_DCTInv_S16_I(
     OMX_S16 *pSrcDst
 )
{
    OMXResult errorCode;
    OMX_S16   tempBuffer[67]; /*3 dummy elements for alignment consideration*/
    OMX_S16   *pBuffer;
    OMX_INT   i;
    
    pBuffer = armAlignTo8Bytes(tempBuffer);

    errorCode = omxICJP_DCTInv_S16((const OMX_S16 *)pSrcDst,pBuffer);
                                                
    armRetArgErrIf(errorCode != OMX_StsNoErr, errorCode);
    
    for ( i = 0 ; i < 64 ; i++)
    {
        pSrcDst[i] = pBuffer[i];
    }

    return OMX_StsNoErr;
}

/* End of file */

