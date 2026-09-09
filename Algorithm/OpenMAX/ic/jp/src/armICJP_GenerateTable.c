/**
 *
 *  armICJP_GenerateTable.c
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
 * Description  : Contains ARM-defined utility functions used by the JPEG Huffman modules.
 *
 */

#include "omxtypes.h"
#include "armIC.h"

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
 
OMXResult armICJP_GenerateSizeTable(
        const OMX_U8 *pHuffBits,
        ARM_sEncodeHuffmanSpec *pHuffTable
       )
{
    OMX_INT i, j, k = 0;

    /*
    ---------------------------------------------------------------------
    This functionality is described in the JPEG Standard [ISO10918] Annex 
    C.2: Conversion of Huffman Tables Specified in Interchange Format to 
    Tables of Codes and Code Lengths.
    
    The inner loop handles those cases where more than one symbol has 
    the same Huffman codeSize and the outer loop iterates over all the 
    possible Huffman codeSizes.
    ---------------------------------------------------------------------
    */

    for(i = 1; i <= 16; i++, pHuffBits++)
    {
        for(j = 1; j <= *pHuffBits; j++)
        {
            pHuffTable->huffsize[k++] = i;
        }
    }
    pHuffTable->huffsize[k] = 0;
    pHuffTable->numEntries  = k;
    
    return OMX_StsNoErr;
}

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

OMXResult armICJP_GenerateCodeTable(
        ARM_sEncodeHuffmanSpec *pHuffTable
       )
{
    OMX_INT index       = 0;
    OMX_U32 code        = 0;
    OMX_U32 codeSize    = pHuffTable->huffsize[0];
    
    /*
    ----------------------------------------------------------------------------
    This functionality is described in the JPEG Standard [ISO10918] Annex 
    C.2: Conversion of Huffman Tables Specified in Interchange Format to 
    Tables of Codes and Code Lengths.
    
    The first do-while loop assigns huffman codes (in an incremental fashion)
    to all the symbols that have same huffman code size.  After this assignment,
    a check is made to see if anymore entries are left in the huffSize[] table.
    The next do-while loop, sets <code> to reflect the <codeSize> value and 
    returns the control back to the outermost while(1) loop.
    ----------------------------------------------------------------------------
    */
    
    for(;;)
    {
        while(codeSize && pHuffTable->huffsize[index] == codeSize)
        {
            pHuffTable->huffcode[index] = code;
            index++, code++;
        }
        
        if (pHuffTable->huffsize[index] == 0)
        {
            break;
        }
        
        do
        {
            code <<= 1;
            codeSize++;
        }
        while(pHuffTable->huffsize[index] != codeSize);
    }

    return OMX_StsNoErr;
}

/* End of file */
