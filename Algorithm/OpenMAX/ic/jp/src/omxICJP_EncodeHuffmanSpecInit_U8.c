/**
 *
 *  omxICJP_EncodeHuffmanSpecInit_U8.c
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
 * Description: Huffman table initialization function.
 *
 */

#include "omxtypes.h"
#include "armCOMM.h"
#include "omxIC.h"
#include "armIC.h"

static OMXResult armICJP_OrderCodes(const OMX_U8 *pHuffValue, ARM_sEncodeHuffmanSpec *pHuffTable);

/**
 * Function: omxICJP_EncodeHuffmanSpecInit_U8
 *
 * Description:
 * Generate Huffman table for encoding from Huffman table specification.
 *
 *
 * Parameters:
 * [in]  pHuffBits      Pointer to the array of HUFFBITS, which contains the number of Huffman
 *                      codes for size 1-16.
 * [in]  pHuffValue     Pointer to the array of HUFFVAL, which contains the symbol values to be
 *                      associated with the Huffman codes ordering by size.
 * [out] pHuffTable     identifies a OMXiEncodeHuffmanSpec data structure. The structure member is
 *                      4-byte aligned.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_EncodeHuffmanSpecInit_U8(
        const OMX_U8 *pHuffBits,
        const OMX_U8 *pHuffValue,
        OMXICJPHuffmanEncodeSpec *pHuffTable
       )
{
    ARM_sEncodeHuffmanSpec *pARM_HuffTable = (ARM_sEncodeHuffmanSpec *) pHuffTable;
    
    armRetArgErrIf(!pHuffBits,  OMX_StsBadArgErr);
    armRetArgErrIf(!pHuffValue, OMX_StsBadArgErr);
    armRetArgErrIf(!pHuffTable, OMX_StsBadArgErr);
    
    /*
    ---------------------------------------------------------------------
    This function calls three subroutines to generate Huffman size table,
    Huffman Code table and then to arrange them, so that Huffman code and
    size are indexed by the input symbol.
    
    All these functionalities are described in the JPEG Standard [ISO10918] 
    Annex C.2: Conversion of Huffman Tables Specified in Interchange Format
    to Tables of Codes and Code Lengths.
    ---------------------------------------------------------------------
    */
    
    armICJP_GenerateSizeTable(pHuffBits, pARM_HuffTable);
    armICJP_GenerateCodeTable(pARM_HuffTable);
    armICJP_OrderCodes(pHuffValue, pARM_HuffTable);
    
    return OMX_StsNoErr;
}


static OMXResult armICJP_OrderCodes(
        const OMX_U8 *pHuffValue,
        ARM_sEncodeHuffmanSpec *pHuffTable
       )
{
    OMX_INT index, i;
    OMX_U8  encHuffSize[256] = {0};
    OMX_U16 endHuffCode[256] = {0};
    
    /*
    ------------------------------------------------------------------------------
    This functionality is described in the JPEG Standard [ISO10918] Annex 
    C.2: Conversion of Huffman Tables Specified in Interchange Format to 
    Tables of Codes and Code Lengths.
    
    The first for-loop arranges the huffman codes and their sizes in temporary
    local arrays such that they're indexed by the Huffman symbols, they represent.
    This is followed by another for-loop that copies all the entries from the 
    temporary local arrays back into the ARM_sEncodeHuffmanSpec structure.
    ------------------------------------------------------------------------------
    */

    for(i = 0; i < pHuffTable->numEntries; i++)
    {
        index               = pHuffValue[i];
        endHuffCode[index]  = pHuffTable->huffcode[i];
        encHuffSize[index]  = pHuffTable->huffsize[i];
    }
    
    for(i = 0; i < 256; i++)
    {
        pHuffTable->huffcode[i] = endHuffCode[i];
        pHuffTable->huffsize[i] = encHuffSize[i];
    }
    
    return OMX_StsNoErr;
}

/* End of file */
