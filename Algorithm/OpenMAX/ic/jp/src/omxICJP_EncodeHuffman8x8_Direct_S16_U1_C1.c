/**
 *
 *  omxICJP_EncodeHuffman8x8_Direct_S16_U1_C1.c
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
 * Description: Huffman encoding function.
 *
 */

#include "omxtypes.h"
#include "armCOMM.h"
#include "armCOMM_Bitstream.h"
#include "omxIC.h"
#include "armIC.h"

static OMXResult armICJP_FindDiffCategory(OMX_U16 value, OMX_U16 *pCategory);
static OMXResult armICJP_WriteHuffmanCode(OMX_U8 **ppHuffDst, OMX_INT *pHuffBitOffset, 
                        const ARM_sEncodeHuffmanSpec *pARM_HuffTable, OMX_U32 value);
       
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
 * [in]  pSrcDstBitsLen identifies the length of valid bits in pDst.
 * [in]  pDCPred        identifies quantized DC coefficient from the most recently coded block of
 *                            the component.
 * [out] pDst           identifies destination bit stream buffer.
 * [out] pSrcDstBitsLen identifies new length of valid bits in pDst.
 * [out] pDCPred        identifies DC coefficient from the current block of the component.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_EncodeHuffman8x8_Direct_S16_U1_C1(
        const OMX_S16 *pSrc,
        OMX_U8  *pDst,
        OMX_INT *pSrcDstBitsLen,
        OMX_S16 *pDCPred,
        const OMXICJPHuffmanEncodeSpec *pDCHuffTable,
        const OMXICJPHuffmanEncodeSpec *pACHuffTable
       )
{
    OMX_U8  *pHuffDst, *pHuffDstRef, **ppHuffDst;
    OMX_INT huffBitOffset, numBytesWritten, numBitsWritten;
    OMX_INT dcDiff, i, zeroRunLen = 0;
    OMX_U16 diffCategory;
    OMX_S16 curAcCoeff;
    const ARM_sEncodeHuffmanSpec *pARM_DCHuffTable = (ARM_sEncodeHuffmanSpec *) pDCHuffTable;
    const ARM_sEncodeHuffmanSpec *pARM_ACHuffTable = (ARM_sEncodeHuffmanSpec *) pACHuffTable;
    
    armRetArgErrIf(!pSrc,         OMX_StsBadArgErr);
    armRetArgErrIf(!pDst,         OMX_StsBadArgErr);
    armRetArgErrIf(!pDCPred,      OMX_StsBadArgErr);
    armRetArgErrIf(!pSrcDstBitsLen, OMX_StsBadArgErr);
    armRetArgErrIf(!pDCHuffTable,   OMX_StsBadArgErr);
    armRetArgErrIf(!pACHuffTable,   OMX_StsBadArgErr);
    armRetArgErrIf(*pSrcDstBitsLen < 0, OMX_StsBadArgErr);
    armRetArgErrIf(armNot4ByteAligned(pSrc),    OMX_StsBadArgErr);
    armRetArgErrIf(armNot4ByteAligned(pDst),    OMX_StsBadArgErr);
    armRetArgErrIf(armNot4ByteAligned(pDCPred), OMX_StsBadArgErr);
    armRetArgErrIf(armNot4ByteAligned(pSrcDstBitsLen), OMX_StsBadArgErr);
    armRetArgErrIf(armNot4ByteAligned(pDCHuffTable),   OMX_StsBadArgErr);
    armRetArgErrIf(armNot4ByteAligned(pACHuffTable),   OMX_StsBadArgErr);
    
    pHuffDst        = pDst + (*pSrcDstBitsLen)/8;
    pHuffDstRef     = pDst + (*pSrcDstBitsLen)/8;
    ppHuffDst       = &pHuffDst;
    huffBitOffset   = *pSrcDstBitsLen % 8;
    
    /*
    -----------------------------------------------------------------------
    DC Huffman Encoding is described in the JPEG Standard [ISO10918] 
    Annex F.1.2.1: Huffman encoding of DC coefficients.
    -----------------------------------------------------------------------
    */
    
    dcDiff      = *pSrc - *pDCPred;
    *pDCPred    = *pSrc;
    
    armICJP_FindDiffCategory(armAbs(dcDiff), &diffCategory);
    armICJP_WriteHuffmanCode(ppHuffDst, &huffBitOffset, pARM_DCHuffTable, diffCategory);
    
    dcDiff = (dcDiff < 0) ? (dcDiff - 1) : dcDiff;
    armPackBits(ppHuffDst, &huffBitOffset, dcDiff, diffCategory);
    
    /*
    -----------------------------------------------------------------------
    AC Huffman Encoding is described in the JPEG Standard [ISO10918] 
    Annex F.1.2.2: Huffman encoding of AC coefficients.
    -----------------------------------------------------------------------
    */
    
    for(i = 1; i < ARM_ICJP_BLOCKSIZE; i++)
    {
        curAcCoeff = pSrc[i];
        
        if(curAcCoeff == 0)
        {
            if (i == ARM_ICJP_BLOCKSIZE - 1)
            {
                armICJP_WriteHuffmanCode(ppHuffDst, &huffBitOffset, pARM_ACHuffTable, 0);
                break;
            }
            zeroRunLen++;
        }
        else
        {
            while(zeroRunLen > 15)
            {
                armICJP_WriteHuffmanCode(ppHuffDst, &huffBitOffset, pARM_ACHuffTable, (16 * 15 + 0));
                zeroRunLen -= 16;
            }
            
            armICJP_FindDiffCategory(armAbs(curAcCoeff), &diffCategory);
            armICJP_WriteHuffmanCode(ppHuffDst, &huffBitOffset, pARM_ACHuffTable, (16 * zeroRunLen + diffCategory));
            curAcCoeff = (curAcCoeff < 0) ? (curAcCoeff - 1) : curAcCoeff;
            armPackBits(ppHuffDst, &huffBitOffset, curAcCoeff, diffCategory);
            
            zeroRunLen = 0;
        }
    }
    
    /*
    -----------------------------------------------------------------------
    Update the in/out parameter <pSrcDstBitsLen> to reflect the Huffman codes
    written into the stream.
    -----------------------------------------------------------------------
    */
    
    numBytesWritten  = pHuffDst - pHuffDstRef;
    numBitsWritten   = (numBytesWritten * 8) + huffBitOffset - (*pSrcDstBitsLen % 8);
    *pSrcDstBitsLen += numBitsWritten;
    
    return OMX_StsNoErr;
}

/**
 * Function: armICJP_FindDiffCategory
 *
 * Description:
 * This function finds the difference category to which the input value belongs.
 * This function looks up the table armICJP_HuffmanCategoryTable[], for finding
 * the category.
 *
 * Parameters:
 * [in]  value      The difference value for which the category is to be found.
 * [out] pCategory  The difference category to which the current value belongs.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

static OMXResult armICJP_FindDiffCategory(
        OMX_U16 value,
        OMX_U16 *pCategory
       )
{
    armRetArgErrIf(!pCategory, OMX_StsBadArgErr);
    
    if (value < 256)
    {
        *pCategory  = armICJP_HuffmanCategoryTable[value];
    }
    else
    {
        value       = value >> 8;
        *pCategory  = armICJP_HuffmanCategoryTable[value] + 8;
    }
    return OMX_StsNoErr;
}

/**
 * Function: armICJP_WriteHuffmanCode
 *
 * Description:
 * This function looks up the Huffman encoding table to find the Huffman code for the input
 * value; Then writes this into the destination buffer and updates the buffer pointer and 
 * the bit-offset of the current byte.
 *
 * Parameters:
 * [in]  ppHuffDst       Pointer to pointer to the stream, where Huffman code is to be written.
 * [in]  pHuffBitOffset  Pointer to the bit offset in the current byte pointed by ppHuffDst.
 * [in]  pARM_HuffTable  Pointer to the Huffman Table structure.
 * [in]  value           The value to be encoded using the Huffman codes.
 * [out] ppHuffDst       Updated pointer to pointer to the stream, where Huffman code was written.
 * [out] pHuffBitOffset  Updated pointer to the bit offset in the current byte pointed by ppHuffDst.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

static OMXResult armICJP_WriteHuffmanCode(
        OMX_U8 **ppHuffDst,
        OMX_INT *pHuffBitOffset,
        const ARM_sEncodeHuffmanSpec *pARM_HuffTable,
        OMX_U32 value
       )
{
    OMX_U8  huffSize = pARM_HuffTable->huffsize[value];
    OMX_U16 huffCode = pARM_HuffTable->huffcode[value];
    
    if(huffSize)
    {
        armPackBits(ppHuffDst, pHuffBitOffset, huffCode, huffSize);
        return OMX_StsNoErr;
    }
    
    return OMX_StsErr;
}

/* End of file */
