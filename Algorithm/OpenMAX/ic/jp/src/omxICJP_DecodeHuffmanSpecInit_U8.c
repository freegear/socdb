/**
 *
 *  omxICJP_DecodeHuffmanSpecInit_U8.c
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
 * Brief        : Huffman table initialization function.
 *
 */

#include "omxtypes.h"
#include "armCOMM.h"
#include "omxIC.h"
#include "armIC.h"

static OMXResult armICJP_DecoderTables(const OMX_U8 *pHuffBits, const OMX_U8 *pHuffValue, ARM_sDecodeHuffmanSpec *pARM_HuffTable);

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
 *                      codes for size 1-16
 * [in]  pHuffValue     Pointer to the array of HUFFVAL, which contains the symbol values to be
 *                      associated with the Huffman codes ordering by size
 * [out] pHuffTable     identifies a OMXiDecodeHuffmanSpec data structure. The structure member is
 *                      4-byte aligned.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_DecodeHuffmanSpecInit_U8(
        const OMX_U8 *pHuffBits,
        const OMX_U8 *pHuffValue,
        OMXICJPHuffmanDecodeSpec *pHuffTable
       )
{
    ARM_sDecodeHuffmanSpec *pARM_HuffTable = (ARM_sDecodeHuffmanSpec *) pHuffTable;
    
    armRetArgErrIf(!pHuffBits,  OMX_StsBadArgErr);
    armRetArgErrIf(!pHuffValue, OMX_StsBadArgErr);
    armRetArgErrIf(!pHuffTable, OMX_StsBadArgErr);
    
    /*
    ---------------------------------------------------------------------
    This function calls three subroutines to generate Huffman size table,
    Huffman Code table and finally to populate the Huffman decoder spec.
    
    These functionalities are described in the JPEG Standard [ISO10918] 
    Annex C.2: Conversion of Huffman Tables Specified in Interchange 
    Format to Tables of Codes and Code Lengths, Annex F.2.2.3: The DECODE 
    procedure and Figure F.15 – Decoder table generation
    ---------------------------------------------------------------------
    */
    
    armICJP_GenerateSizeTable(pHuffBits, &(pARM_HuffTable->sDecTable));
    armICJP_GenerateCodeTable(&(pARM_HuffTable->sDecTable));
    armICJP_DecoderTables(pHuffBits, pHuffValue, pARM_HuffTable);
    
    return OMX_StsNoErr;
}


/**
 * Function: armICJP_DecoderTables
 *
 * Description:
 * This function populates the Huffman Decoder specification
 *
 * Parameters:
 * [in]  pHuffBits      Pointer to the array containing the number of Huffman codes for size 1-16.
 * [out] pHuffTable     Pointer to the ARM_sDecodeHuffmanSpec, which needs to be populated.
 *
 * Return Value:
 * OMXResult -- Standard OMXResult result
 */

static OMXResult armICJP_DecoderTables(
        const OMX_U8 *pHuffBits,
        const OMX_U8 *pHuffValue,
        ARM_sDecodeHuffmanSpec *pARM_HuffTable
       )
{
    OMX_INT i, pos = 0;
    OMX_U16 *pHuffcode = (OMX_U16 *)(pARM_HuffTable->sDecTable.huffcode);
    pARM_HuffTable->maxLen = 1;

    for(i = 0; i < pARM_HuffTable->sDecTable.numEntries; i++)
    {
        pARM_HuffTable->huffval[i]  = *pHuffValue++;
    }

    /*
    ---------------------------------------------------------------------
    This function populates the Huffman decoder table, according to the
    JPEG Standard [ISO10918], Figure F.15 – Decoder table generation.
    ---------------------------------------------------------------------
    */
    
    for(i = 0; i < 16; i++)
    {
        if (pHuffBits[i]==0)
        {
            pARM_HuffTable->maxcode[i] = -1;
        }
        else
        {
            pARM_HuffTable->valptr[i]   = pos;
            pARM_HuffTable->mincode[i]  = pHuffcode[pos];
            pos += (pHuffBits[i] - 1);
            pARM_HuffTable->maxcode[i]  = pHuffcode[pos];
            pARM_HuffTable->maxLen      = (i+1);
            pos++;
        }
    }
    
    return OMX_StsNoErr;
}

/* End of file */
