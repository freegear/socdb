/**
 *
 *  omxICJP_DecodeHuffmanSpecGetBufSize_U8.c
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
 * Description        : JPEG Huffman Decoder function.
 *
 */

#include "omxtypes.h"
#include "armCOMM.h"
#include "omxIC.h"
#include "armIC.h"

/**
 * Function: omxICJP_DecodeHuffmanSpecGetBufSize_U8
 *
 * Brief:
 * Get Huffman decoding table size.
 *
 * Description:
 * This function generates the size of Huffman decoding table.
 *
 *
 * Parameters:
 * [out] pSize      pointer to the size
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_DecodeHuffmanSpecGetBufSize_U8(
        OMX_INT* pSize
       )
{
    armRetArgErrIf(!pSize, OMX_StsBadArgErr);
    *pSize = (OMX_INT) sizeof(ARM_sDecodeHuffmanSpec);
    return OMX_StsNoErr;
}

/* End of file */
