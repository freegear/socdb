/**
 *
 *  armIC.h
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
 * File         : armIC.h
 * Description  : Contains ARM-defined macros, functions and definitions common to Image Compression subdomain.
 *
 */
  
#ifndef _armIC_H_
#define _armIC_H_

#include "omxtypes.h"
#include "armCOMM.h"

#define ARM_ICJP_BLOCKSIZE (8*8)
#define ARM_ICJP_QUANT_Q   15

extern const OMX_U8  armICJP_ZigZagTable[64];
extern const OMX_F64 armICJP_CosTable[8][8];
extern const OMX_F64 armICJP_QuantTable[64];
extern const OMX_U8  armICJP_HuffmanCategoryTable[256];

struct EncHuffmanSpec
{
    OMX_U8  huffsize[256];  /* Huffman codeSize table indexed on code word */
    OMX_U16 huffcode[256];  /* Huffman codeValue table indexed on code word */
    OMX_INT numEntries;     /* Number of valid entries in the huffsize & huffcode tables */
};

struct DecHuffmanSpec
{
    struct EncHuffmanSpec sDecTable;
    OMX_U8  huffval[256];   /* Table of values that have Huffman representations */
    OMX_INT maxcode[16];    /* Maximum Huffman code for a given bit length; If no codes, then -1 */
    OMX_INT mincode[16];    /* Minimum Huffman code for a given bit length */
    OMX_INT valptr[16];     /* Index of mincode for a given bit-length */
    OMX_INT maxLen;         /* Length of the longest Huffman code */
};

typedef struct EncHuffmanSpec  ARM_sEncodeHuffmanSpec;
typedef struct DecHuffmanSpec  ARM_sDecodeHuffmanSpec;

/**
 * Function: armICJP_GenerateSizeTable
 *
 * Description:
 * This function generates a Huffman codeSize table, that contains the number of bits used in 
 * representing each symbol.
 *
 * Parameters:
 * [in]  pHuffBits      Pointer to the array containing the number of Huffman codes for size 1-16.
 * [out] pHuffTable     Pointer to the ARM_sEncodeHuffmanSpec, where Huffman code sizes are written.
 *
 * Return Value:
 * OMXResult -- Standard OMXResult result
 */
OMXResult armICJP_GenerateSizeTable(const OMX_U8 *pHuffBits, ARM_sEncodeHuffmanSpec *pHuffTable);

/**
 * Function: armICJP_GenerateCodeTable
 *
 * Description:
 * This function generates Huffman codes, for all the codesizes specified in the pHuffTable.
 *
 * Parameters:
 * [out] pHuffTable  Pointer to the ARM_sEncodeHuffmanSpec, where Huffman codees are written.
 *
 * Return Value:
 * OMXResult -- Standard OMXResult result
 */
OMXResult armICJP_GenerateCodeTable(ARM_sEncodeHuffmanSpec *pHuffTable);

/**
 * Function: armICJP_DCTQuantInv_S16
 *
 * Brief:
 * Single block dequantization and IDCT function.
 *
 * Description:
 * This function implements inverse DCT with (Optional) dequantization for 8-bit image data. It processes one
 * block (8x8).
 * The start address of pQuantRawTable and pQuantInvTable must be 8-byte aligned.
 *
 *
 * Parameters:
 * [in]  pSrc           identifies the input coefficient block (8x8) buffer. The start address must be 8-byte
 *                            aligned.
 * [in]  pQuantInvTable identifies the quantization table which was generated from
 *                            "omxICJP_DCTQuantInvTableInit". The table length is 64 entries by 32-bit wide. The start address must be
 *                            8-byte aligned. If this pointer is NULL then dequantization is not performed
 *
 * [out] pDst           identifies output coefficient block(8x8) buffer. The start address must be 8-byte aligned.
 *
 * Return Value:
 * OMXVoid
 *
 */
OMXVoid armICJP_DCTQuantInv_S16(
     const OMX_S16 *pSrc,
     OMX_S16 *pDst,
     const OMX_U32 *pQuantInvTable
 );

/**
 * Function: armICJP_DCTQuantFwd_S16
 *
 * Brief:
 * One block FDCT with quantization function.
 *
 * Description:
 * This function implements forward DCT with (optional) quantization for the 8-bit image data (packed into signed 16-bit).
 * It processes one block (8x8).Output matrix is the transpose of the explicit result.
 * As a result, the Huffman coding functions in this library handle transpose as well.
 *
 *
 * Parameters:
 * [in]  pSrc           identifies input coefficient block(8x8) buffer. This start address must be 8-byte
 *                            aligned. The input components are bounded on the interval [-128, 127].
 * [in]  pQuantFwdTable identifies the quantization table which was generated from
 *                            "DCTQuantFwdTableInit_JPEG_U8_U16". The table length is 64 entries. This start address must be
 *                            8-byte aligned. If this pointer is NULL then quantization is not performed
 
 * [out] pDst           identifies output coefficient block(8x8) buffer. This start address must be 8-byte aligned.
 *                            To achieve better performance, the output 8x8 matrix is the transpose of the explicit result. This
 *                            transpose will be handled in Huffman encoding.
 *
 * Return Value:
 * OMXVoid
 *
 */

OMXVoid armICJP_DCTQuantFwd_S16(
     const OMX_S16* pSrc,
     OMX_S16 *pDst,
     const OMX_U32 *pQuantFwdTable
 );

#endif /* _armIC_H_ */

/* End of File */

