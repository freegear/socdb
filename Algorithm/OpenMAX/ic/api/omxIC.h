/**
 * File: omxIC.h
 * Brief: The OpenMAX Image Codec JPEG API.
 *
 * Copyright © 2005-06 The Khronos Group Inc. All Rights Reserved. 
 *
 * These materials are protected by copyright laws and contain material 
 * proprietary to the Khronos Group, Inc.  You may use these materials 
 * for implementing Khronos specifications, without altering or removing 
 * any trademark, copyright or other notice from the specification.
 * 
 * Khronos Group makes no, and expressly disclaims any, representations 
 * or warranties, express or implied, regarding these materials, including, 
 * without limitation, any implied warranties of merchantability or fitness 
 * for a particular purpose or non-infringement of any intellectual property. 
 * Khronos Group makes no, and expressly disclaims any, warranties, express 
 * or implied, regarding the correctness, accuracy, completeness, timeliness, 
 * and reliability of these materials. 
 *
 * Under no circumstances will the Khronos Group, or any of its Promoters, 
 * Contributors or Members or their respective partners, officers, directors, 
 * employees, agents or representatives be liable for any damages, whether 
 * direct, indirect, special or consequential damages for lost revenues, 
 * lost profits, or otherwise, arising from or in connection with these 
 * materials.
 * 
 * Khronos and OpenMAX are trademarks of the Khronos Group Inc. 
 *
 */

/* ****************************************************************************************/
/**
 *
 *  NewDomain: IC The Image Codec Domain
 *  WithinDomain: OM
 *
 *  The Image Codec Domain contains encoding and decoding algorithms for still image applications.
 *  For version 1.0 of OpenMAX the only codec supported is the baseline JPEG specification.
 *
 *  StartDomain: IC
 */


#ifndef _OMXICH_
#define _OMXICH_

#ifndef _OMXTYPES_H_
  #include "omxtypes.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif




/* **************************************************************************************** */
/**
 *
 *  NewDomain: JP The JPEG Image Codec Subdomain
 *  WithinDomain: IC
 *
 *	The JPEG Subdomain of the Image Codec Domain contains some of the
 *  core functions required to build a baseline JPEG codec as specified by the
 *  JPEG specification (ISO/IEC 10918-1:1994) and the JFIF specification.
 *  Functions provided include DCTs, inverse DCTs, quantisation, and inverse quantisation.
 *
 *  Only 8-bit input data per color channel is supported in these APIs,
 *  future versions of the OpenMAX standard are expected to provide support
 *  for other image codecs (for example JPEG2000) which support higher
 *  bit depths.
 *
 *  Each library implementation of the JPEG API is free to use whatever format
 *  of quantization table is most optimal for that platform and implementation.
 *  This format is hidden from the user by providing the function
 *  omxICJP_DCTQuantFwdTableInit() to convert 8-bit, 64-element user
 *  supplied quantisation tables into the 16-bit, 64-element, implementation
 *  defined format. Similarly the function omxICJP_DCTQuantInvTableInit()
 *  is provided to convert inverse quantisation tables.
 *
 *  StartDomain: JP
 */
/* **************************************************************************************** */



/*===================================================================================*/
/**
 * Remarks:
 *  MCU boundary replicating function
 */

/*=============================================================================================*/
/**
 * Function: omxICJP_CopyExpand_U8_C3
 *
 * Brief:
 * Copy, Expand pixels for MCU on the boundary
 *
 * Description:
 * This function processes the image data block on the boundary. The values, which are situated
 * outside of the image boundary at the right and bottom sides of the buffer, are replicated from the sample values at the boundary to provide
 * missing edge values. This function just processes 3 channels image data in interleaved order.
 * Both of source image data buffer and destination image data buffer support down-top storage
 * format. In that case, srcStep and dstStep can be less than 0.
 *
 *
 * Parameters:
 * [in]  pSrc           identifies source image data buffer
 * [in]  srcStep        specifies the number of bytes in a line of the image data buffer
 * [in]  srcSize        identifies OMXSize data structure to indicate the size of source rectangle
 * [in]  dstStep        specifies the number of bytes in a line of output MCU buffer
 * [in]  dstSize        identifies OMXSize data structure to indicate the size of destination rectangle
 * [out] pDst           identifies the output MCU buffer
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_CopyExpand_U8_C3(
     const OMX_U8 *pSrc,
     OMX_INT srcStep,
     OMXSize srcSize,
     OMX_U8 *pDst,
     OMX_INT dstStep,
     OMXSize dstSize
 );


/*===================================================================================*/
/**
 * Remarks:
 *  DQ DCT, Quantisation and combined functions
 */

/*=============================================================================================*/
/**
 * Function: omxICJP_DCTQuantFwdTableInit
 *
 * Brief:
 * Quantization table initialization function.
 *
 * Description:
 * Generate the quantization table for optimized FDCT and quantization functions.
 * Output matrix is automatically transposed for compatibility with quantization and DCT functions.
 *
 * Parameters:
 * [in]  pQuantRawTable  pointer to the raw quantization table; must be aligned on an 8-byte boundary.  
 *                       The table must contain 64 entries.
 * [out] pQuantFwdTable  pointer to the pre-scaled quantization table; must be aligned on an  8 byte boundary. 
 *                       Table must contain 64 entries that are computed as follows: pQuantFwdTable[i][j]=(c[i][j]/pQuantRawTable[i][j]) + 0.5, 
 *                       where c(i,j) = 1/(x(i)*x(j)*8), x(0)=x(4)=1, x(n)=1/sqrt(2)*cos(n*pi/16)) for n=1,2,3,5,6,7, 
 *                       and the indices i and j are defined as:  0 <= i, j <= 7. 
 *                       Scaling (Q-format) of the table entries may be implementation-specific, but the Q-format of the table entries generated by this function 
 *                       must match the input Q-format on the table entries expected by the associated set of forward DCT quantization functions in the same OpenMAX DL implementation, 
 *                       including the functions DCTQuantFwd_S16, DCTQuantFwd_S16_I, and DCTQuantFwd_Multiple_S16.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_DCTQuantFwdTableInit (
     const OMX_U8 *pQuantRawTable,
     OMX_U32 *pQuantFwdTable
 );


/**
 * Function: omxICJP_DCTQuantFwd_S16
 *
 * Brief:
 * One block FDCT with quantization function.
 *
 * Description:
 * This function implements forward DCT with quantization for the 8-bit image data (packed into signed 16-bit).
 * It processes one block (8x8).Output matrix is the transpose of the explicit result.
 * As a result, the Huffman coding functions in this library handle transpose as well.
 *
 *
 * Parameters:
 * [in]  pSrc           identifies input coefficient block(8x8) buffer. This start address must be 8-byte
 *                            aligned. The input components are bounded on the interval [-128, 127].
 * [in]  pQuantFwdTable identifies the quantization table which was generated from
 *                            "DCTQuantFwdTableInit". The table length is 64 entries. This start address must be
 *                            8-byte aligned.
 * [out] pDst           identifies output coefficient block(8x8) buffer. This start address must be 8-byte aligned.
 *                            To achieve better performance, the output 8x8 matrix is the transpose of the explicit result. This
 *                            transpose will be handled in Huffman encoding.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_DCTQuantFwd_S16 (
     const OMX_S16* pSrc,
     OMX_S16 *pDst,
     const OMX_U32 *pQuantFwdTable
 );



/**
 * Function: omxICJP_DCTQuantFwd_S16_I
 *
 * Brief:
 * One block FDCT with quantization function.
 *
 * Description:
 * This function implements in place forward DCT with quantization for the 8-bit image data. It processes
 * one block (8x8).Output matrix is the transpose of the explicit result.
 * As a result, the Huffman coding functions in this library handle transpose as well.
 *
 *
 * Parameters:
 * [in,out]  pSrcDst    Identifies coefficient block(8x8) buffer for in-place processing. This start address
 *                      must be 8-byte aligned. The input components are bounded on the interval [-128, 127]
 *                      within a signed 16-bit container.
 *                      To achieve better performance, the output 8x8 matrix is the transpose of the explicit result.
 *                      This transpose will be handled in Huffman encoding.
 * [in]  pQuantFwdTable identifies the quantization table which was generated from
 *                            "DCTQuantFwdTableInit". The table length is 64. This start address must be
 *                            8-byte aligned.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_DCTQuantFwd_S16_I (
     OMX_S16* pSrcDst,
     const OMX_U32 *pQuantFwdTable
 );


/**
 * Function: omxICJP_DCTQuantInvTableInit
 *
 * Brief:
 * Dequantization table initialization function.
 *
 * Description:
 * Generates the JPEG IDCT inverse quantization table for 8-bit image data.
 *
 * Parameters:
 * [in]  pQuantRawTable pointer to the raw (unprocessed) quantization table, containing 64 entries; must be 
 *                      aligned on an 8-byte boundary.
 * [out] pQuantInvTable pointer to the pre-scaled quantization table; must be aligned on an  8 byte boundary.  
 *                      Table must contain 64 entries that are computed as follows: pQuantFwdTable[i][j]=(c[i][j]/pQuantRawTable[i][j]) + 0.5,
 *                      where c(i,j) = 1/(x(i)*x(j)*8), x(0)=x(4)=1, x(n)=1/sqrt(2)*cos(n*pi/16)) for n=1,2,3,5,6,7, 
 *                      and the indices i and j are defined as:  0 <= i, j <= 7.  Scaling (Q-format) of the table entries may be implementation-specific, 
 *                      but the Q-format of the table entries generated by this function must match the input Q-format on the table entries expected by the 
 *                      associated set of forward DCT quantization functions in the same OpenMAX DL implementation, including the functions DCTQuantFwd_S16,
 *                      DCTQuantFwd_S16_I, and DCTQuantFwd_Multiple_S16.
 *
 * Return Value:
 * OMX_StsNoErr -no error
 * OMX_StsBadArgErr - Bad arguments. Returned for any of the following conditions:
 *      - a pointer was NULL
 *      - the start address of a pointer was not 8-byte aligned.
 *
 */

OMXResult omxICJP_DCTQuantInvTableInit (
     const OMX_U8 *pQuantRawTable,
     OMX_U32 *pQuantInvTable
 );





/**
 * Function: omxICJP_DCTQuantInv_S16
 *
 * Brief:
 * Single block dequantization and IDCT function.
 *
 * Description:
 * This function implements inverse DCT with dequantization for 8-bit image data. It processes one
 * block (8x8).
 * The start address of pQuantRawTable and pQuantInvTable must be 8-byte aligned.
 *
 *
 * Parameters:
 * [in]  pSrc           identifies the input coefficient block (8x8) buffer. The start address must be 8-byte
 *                      aligned.
 * [in]  pQuantInvTable identifies the quantization table which was generated from
 *                      "omxICJP_DCTQuantInvTableInit". The table length is 128 entries by 32-bit wide. 
 *                      The start address must be 8-byte aligned.
 * [out] pDst           identifies output coefficient block(8x8) buffer. The start address must be 8-byte aligned.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_DCTQuantInv_S16(
     const OMX_S16 *pSrc,
     OMX_S16 *pDst,
     const OMX_U32 *pQuantInvTable
 );



/**
 * Function: omxICJP_DCTQuantInv_S16_I
 *
 * Brief:
 * In-place, single block dequantization and IDCT function.
 *
 * Description:
 * This function implements inverse DCT with dequantization for 8-bit image data. It processes one
 * block (8x8).
 * The start address of pQuantRawTable and pQuantInvTable must be 8-byte aligned.
 *
 *
 * Parameters:
 * [in,out]  pSrcDst    Identifies input coefficient block(8x8) buffer for in-place processing.
 *                      The start address must be 8-byte aligned.
 * [in]  pQuantInvTable identifies the quantization table which was generated from
 *                      "omxICJP_DCTQuantInvTableInit". The table length is 64 entries by 32-bit. 
 *                      The start address must be 8-byte aligned.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_DCTQuantInv_S16_I (
     OMX_S16* pSrcDst,
     const OMX_U32 *pQuantInvTable
 );

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

OMXResult omxICJP_DCTFwd_S16 (
     const OMX_S16* pSrc,
     OMX_S16 *pDst
 );



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
 * [in,out]  pSrcDst           identifies the input coefficient block(8x8) buffer for in-place processing. This start address must be 8-byte
 *                            aligned. The input components are bounded on the interval [-128, 127] within a 16-bit container.
 *                            To achieve better performance, the output 8x8 matrix is the transpose of the explicit result. This
 *                            transpose can be handled in later processing stages (e.g. Huffman encoding).
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_DCTFwd_S16_I (
     OMX_S16* pSrcDst
 );





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
 *                            "DCTQuantFwdTableInit". The table length is 64. This start address must be
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

OMXResult omxICJP_DCTQuantFwd_Multiple_S16 (
     const OMX_S16* pSrc,
     OMX_S16 *pDst,
     OMX_INT nBlocks,
     const OMX_U32 *pQuantFwdTable
 );




/**
 * Function: omxICJP_DCTInv_S16
 *
 * Brief:
 * Single block IDCT function.
 *
 * Description:
 * This function implements inverse DCT for 8-bit image data. It processes one
 * block (8x8).
 * The start address of pQuantRawTable must be 8-byte aligned.
 *
 *
 * Parameters:
 * [in]  pSrc           identifies the input DCT coefficient block (8x8) buffer. The start address must be 8-byte
 *                            aligned.
 * [out] pDst           identifies output image pixel data block(8x8) buffer. The start address must be 8-byte aligned.
 *
 * Return Value:
 * Standard OMX_RESULT result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_DCTInv_S16(
     const OMX_S16 *pSrc,
     OMX_S16 *pDst
 );


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
 );
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
 *                            aligned.
 * [in]  nBlocks        the number of 8x8 blocks to be processed.
 * [in]  pQuantInvTable identifies the quantization table which was generated from
 *                      "omxICJP_DCTQuantInvTableInit". The table length is omxICJP_DCTQuantInv_Multiple_S16. 
 *                      The start address must be 8-byte aligned.
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
 );








/*===================================================================================*/
/**
 * Remarks:
 *  Huffman encoding and decoding functions
 *
 *  These functions and structures assist in the Huffman encoding and decoding
 *  within JPEG.
 */


/* omxJPEGENHuffTable */
typedef void OMXICJPHuffmanEncodeSpec;

/* omxJPEGDEHuffTable */
typedef void OMXICJPHuffmanDecodeSpec;


/**
 * Function: omxICJP_EncodeHuffmanSpecGetBufSize_U8
 *
 * Brief:
 * Get huffman encoding table size function.
 *
 * Description:
 * This function generates the size of the Huffman encoding table.
 *
 *
 * Parameters:
 * [out] pSize          pointer to the size
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_EncodeHuffmanSpecGetBufSize_U8 (
     OMX_INT* pSize
 );




/**
 * Function: omxICJP_EncodeHuffmanSpecInit_U8
 *
 * Brief:
 * Huffman table initialization function.
 *
 * Description:
 * Generate Huffman table for encoding from Huffman table specification.
 *
 *
 * Parameters:
 * [in]  pHuffBits      Pointer to the array of HUFFBITS, which contains the number of Huffman
 *                            codes for size 1-16.
 * [in]  pHuffValue     Pointer to the array of HUFFVAL, which contains the symbol values to be
 *                            associated with the Huffman codes ordering by size.
 * [out] pHuffTable     identifies a OMXEncodeHuffmanSpec data structure. The structure member is
 *                            4-byte aligned.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_EncodeHuffmanSpecInit_U8 (
     const OMX_U8 *pHuffBits,
     const OMX_U8 *pHuffValue,
     OMXICJPHuffmanEncodeSpec *pHuffTable
 );




/**
 * Function: omxICJP_EncodeHuffmanStateGetBufSize_U8
 *
 * Brief:
 * Get Huffman encoding state size.
 *
 * Description:
 * This API generates the size of Huffman encoding state.
 *
 *
 * Parameters:
 * [out] pSize          pointer to the size
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_EncodeHuffmanStateGetBufSize_U8 (
     OMX_INT* pSize
 );





/**
 * Function: omxICJP_EncodeHuffman8x8_Direct_S16_U1_C1
 *
 * Brief:
 * Huffman encoding function for baseline mode.
 *
 * Description:
 * This function implements Huffman encoding for baseline mode.
 *
 *
 * Parameters:
 * [in]  pSrc           identifies source data block (8x8). The start address of pSrc must be 4-byte aligned.
 * [in]  pDCHuffTable   identifies OMXEncodeHuffmanSpec data structure, each of which
 *                            indicates a DC Huffman encoding table. The structure member is 4-byte aligned.
 * [in]  pACHuffTable   identifies OMXEncodeHuffmanSpec data structure. The structure
 *                            member is 4-byte aligned.
 * [in]  pSrcDstBitsLen    identifies the length of valid bits in pDst.
 * [in]  pDCPred        identifies quantized DC coefficient from the most recently coded block of
 *                            the component.
 * [out] pDst           identifies destination bit stream buffer.
 * [out] pDstBitsLen    identifies new length of valid bits in pDst.
 * [out] pDCPred        identifies DC coefficient from the current block of the component.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_EncodeHuffman8x8_Direct_S16_U1_C1 (
     const OMX_S16 *pSrc,
     OMX_U8 *pDst,
     OMX_INT *pSrcDstBitsLen,
     OMX_S16 *pDCPred,
     const OMXICJPHuffmanEncodeSpec *pDCHuffTable,
     const OMXICJPHuffmanEncodeSpec *pACHuffTable
 );




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
 * [out] pSize          pointer to the size
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_DecodeHuffmanSpecGetBufSize_U8 (
     OMX_INT* pSize
 );




/**
 * Function: omxICJP_DecodeHuffmanSpecInit_U8
 *
 * Brief:
 * Huffman decoding table initialization.
 *
 * Description:
 * This function generates Huffman table for decoding from Huffman table specification.
 *
 *
 * Parameters:
 * [in]  pHuffBits      Pointer to the array of HUFFBITS, which contains the number of Huffman
 *                            codes for size 1-16
 * [in]  pHuffValue     Pointer to the array of HUFFVAL, which contains the symbol values to be
 *                            associated with the Huffman codes ordering by size
 * [out] pHuffTable     identifies a OMXiDecodeHuffmanSpec data structure. The structure member is
 *                            4-byte aligned.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_DecodeHuffmanSpecInit_U8 (
     const OMX_U8 *pHuffBits,
     const OMX_U8 *pHuffValue,
     OMXICJPHuffmanDecodeSpec *pHuffTable
 );




/**
 * Function: omxICJP_DecodeHuffmanStateGetBufSize_U8
 *
 * Brief:
 * Get Huffman decoding state structure size.
 *
 * Description:
 * This function generates the size of Huffman decoding state.
 *
 *
 * Parameters:
 * [out] pSize          pointer to the size
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_DecodeHuffmanStateGetBufSize_U8 (
     OMX_INT* pSize
 );





/**
 * Function: omxICJP_DecodeHuffman8x8_Direct_S16_C1
 *
 * Brief:
 * Huffman decoding function for baseline mode.
 *
 * Description:
 * Implements the JPEG baseline Huffman decoder.  Decodes an 8x8 block of quantized DCT coefficients using  
 * the tables referenced by the parameters pDCHuffTable and pACHuffTable in accordance with the Huffman
 * decoding procedure defined in ISO10918, Annex F.2.2, Baseline Huffman Decoding Procedures.  
 * If a JPEG marker is detected during decoding, the function stops decoding and writes the marker to the location 
 * indicated by pMarker.  The DC coefficient prediction parameter pDCPred should be set to 0 during initialization 
 * and after every restart interval.  The parameter pMarker should set to 0 during initialization or after the 
 * found marker has been processed.  The parameter pNumValidPrefetchedBits should be set to 0 in the following cases:
 * 1) during function initialization, 2) after each restart interval, and 3) after each found marker has been
 * processed.  The parameter pPrefetchedBits should be set to 0 during function initialization. 
 *
 * Parameters:
 * [in]	pSrc					 pointer to the to the first byte of the input JPEG bitstream buffer both upon function 
 *                                   entry and upon function return, i.e., the function does not modify the value of the pointer. 
 *                                   The location of the first available bit in the buffer is indexed by the parameter pSrcDstBitsLen. 
 *								     For a buffer of non-zero length, the value of the first bit accessed during the Huffman block deecode 
 *	         					     operation  is given by (pSrc[currentByte]>>currentBit)&0x1, where currentByte=(pSrcDstBitsLen-1)>>3, 
 *								     and currentBit=7-((pSrcDstBitsLen-1)&0x7).  Within each byte, bits are consumed from most significant
 *								     to least significant.  The buffer contents should be formatted in accordance with CCITT T.81, and 
 *								     the pointer pSrc must be aligned on a 4-byte boundary.
 * [in] pDCHuffTable             pointer to the OMXICJPHuffmanDecodeSpec structure containing the DC Huffman decoding table; must
 *                               be aligned on a 4 byte boundary.
 * [in] pACHuffTable             pointer to the OMXICJPHuffmanDecodeSpec structure containing the AC Huffman decoding table; must
 *                                   be aligned on a 4 byte aligned.
 * [in] pSrcDstBitsLen           pointer to the current bit position indicator for the input buffer (pSrc).  This parameter informs 
 *                                   the Huffman decoder of where to start reading input bits for the current block since the start of 
 * 								     the current block may not necessarily be positioned at the start of the input buffer.  
 *								     The parameter pSrcDstBitsLen indicates the offset in terms of bits of the current bit relative to pSrc.
 *								     Updated upon return as described below under [out].  There is no restriction on buffer 
 *								     length.  It is the responsibility of the caller to maintain the Huffman buffer and limit the buffer 
 *								     length as appropriate for the target application or environment.  The parameter pSrcDstBitsLen must 
 *								     be aligned on a 4-byte boundary.
 * [in] pDCPred                  pointer to the DC prediction coefficient.  Upon input contains the quantized DC coefficient decoded 
 *                                   from the most recent block.  Should be set to 0 upon function initialization and after each restart 
 *								     interval.  Updated upon return as described below under [out].
 * [in] pMarker                  pointer to the most recently encountered marker.  The caller should set this parameter to 0 during 
 *                                   function initialization and after a found marker has been processed.  Updated upon return as described
 *								     below under [out].  
 * [in] pPrefetchedBits          implementation-specific pre fetchparameter; should be set to 0 during function initialization.  
 * [in] pNumValidPrefetchedBits  pointer to the number of valid bits in the pre fetch buffer;  should be set to 0 upon input under
 *                                   the following conditions:  1) function initialization, 2) after each restart interval, 
 *								     3) after each found marker has been processed.
 * [out] pDst                    pointer to the output buffer; must be aligned on a 32 byte boundary.
 * [out] pSrcDstBitsLen          pointer to the updated value of the bit index for the input buffer (pSrc); informs the caller
 *                                   of where the Huffman decoder stopped reading bits for the current block.  The value *pSrcDstBitsLen
 *								     is modified by the Huffman decoder such that it indicates upon return  the offset in terms of 
 *								     bits of the current bit relative to pSrc after block decoding has been completed.  Usage 
 *								     guidelines apply as described above under [in]. 
 * [out] pDCPred                 pointer to the DC prediction coefficient.  Returns the quantized value of the DC coefficient 
 *                                   from the current block.  
 * [out] pMarker                 pointer to the most recently encountered marker.  If a marker is detected during decoding, 
 *                                   the function stops decoding and returns the encountered marker using this parameter; 
 *								     returned value should be preserved between calls to the decoder or reset prior to input
 *								     as described above under [in].
 * [out] pPrefetchedBits         implementation-specific pre fetch parameter; returned value should be preserved between
 *                                   calls to the decoder or reset prior to input as described above under "Input Arguments."  
 * [out] pNumValidPrefetchedBits pointer to the number of valid bits in the pre fetch buffer; returned value should 
 *                                   be preserved between calls to the decoder or reset prior to input as described above under [in]. 
 *
 * Return Value:
 *  OMX_StsNoErr          - no error.
 *  OMX_StsErr            - error, illegal Huffman code encountered in the input bitstream.
 *  OMX_StsJPEGMarkerWarn - JPEG marker encountered; Huffman decoding terminated early.
 *  OMX_StsBadArgErr      - bad arguments; returned if one or more of the following was true:
 *                                          --> a pointer was NULL
 *                                          --> pSrcBitsLen was less than 0
 *                                          --> pNumValidPrefetchedBits was less than 0
 *                                          --> the start address of pDst was not 32-byte aligned
 */

OMXResult omxICJP_DecodeHuffman8x8_Direct_S16_C1 (
     const OMX_U8 *pSrc,
     OMX_INT *pSrcDstBitsLen,
     OMX_S16 *pDst,
     OMX_S16 *pDCPred,
     OMX_INT *pMarker,
     OMX_U32 *pPrefetchedBits,
     OMX_INT *pNumValidPrefetchedBits,
     const OMXICJPHuffmanDecodeSpec *pDCHuffTable,
     const OMXICJPHuffmanDecodeSpec *pACHuffTable
 );


/**
 * EndDomain: JP
 */

/**
 * EndDomain: IC
 */

#ifdef __cplusplus
}
#endif

#endif /** _OMXIC_H_ */


/* ************************ End of file "omxIC.h" *************************** */
/** EOF */




