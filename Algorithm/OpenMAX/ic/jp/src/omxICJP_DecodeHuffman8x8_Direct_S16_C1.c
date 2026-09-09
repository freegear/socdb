/**
 *
 *  omxICJP_DecodeHuffman8x8_Direct_S16_C1.c
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
 * Description       : Huffman Decoding function.
 *
 */

#include "omxtypes.h"
#include "armCOMM.h"
#include "armCOMM_Bitstream.h"
#include "omxIC.h"
#include "armIC.h"

OMXResult armICJP_ExtendDiffCategory(OMX_INT *pdiffVal, OMX_U16 diffCategory);
OMXResult armICJP_ReadHuffmanCode(const OMX_U8 **ppHuffSrc, OMX_INT *pHuffBitOffset, 
            const ARM_sDecodeHuffmanSpec *pARM_HuffTable, OMX_U16 *pHuffcodeValue);

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
 *                                          --> pSrcDstBitsLen was less than 0
 *                                          --> pNumValidPrefetchedBits was less than 0
 *                                          --> the start address of pDst was not 32-byte aligned
 */

OMXResult omxICJP_DecodeHuffman8x8_Direct_S16_C1(
        const OMX_U8 *pSrc,
        OMX_INT *pSrcDstBitsLen,
        OMX_S16 *pDst,
        OMX_S16 *pDCPred,
        OMX_INT *pMarker,
        OMX_U32 *pPrefetchedBits,
        OMX_INT *pNumValidPrefetchedBits,
        const OMXICJPHuffmanDecodeSpec *pDCHuffTable,
        const OMXICJPHuffmanDecodeSpec *pACHuffTable
       )
{
    const OMX_U8 *pHuffSrc, *pHuffSrcRef, **ppHuffSrc;
    OMX_INT huffBitOffset, numBytesRead, numBitsRead;
    OMX_INT diffVal, i, zeroRunLen = 0;
    OMX_U16 diffCategory, huffcodeVal;
    OMXResult status;
    const ARM_sDecodeHuffmanSpec *pARM_DCHuffTable = (ARM_sDecodeHuffmanSpec *) pDCHuffTable;
    const ARM_sDecodeHuffmanSpec *pARM_ACHuffTable = (ARM_sDecodeHuffmanSpec *) pACHuffTable;
    
    armRetArgErrIf(!pSrc, OMX_StsBadArgErr);
    armRetArgErrIf(!pDst, OMX_StsBadArgErr);
    armRetArgErrIf(!pDCPred, OMX_StsBadArgErr);
    armRetArgErrIf(!pMarker, OMX_StsBadArgErr);
    armRetArgErrIf(!pSrcDstBitsLen,  OMX_StsBadArgErr);
    armRetArgErrIf(!pDCHuffTable,    OMX_StsBadArgErr);
    armRetArgErrIf(!pACHuffTable,    OMX_StsBadArgErr);
    armRetArgErrIf(!pPrefetchedBits, OMX_StsBadArgErr);
    armRetArgErrIf(*pSrcDstBitsLen < 0, OMX_StsBadArgErr);
    armRetArgErrIf(!pNumValidPrefetchedBits, OMX_StsBadArgErr);
    armRetArgErrIf(*pNumValidPrefetchedBits < 0, OMX_StsBadArgErr);
    armRetArgErrIf(armNot4ByteAligned(pDst), OMX_StsBadArgErr);
    
    pHuffSrc        = pSrc + (*pSrcDstBitsLen)/8;
    pHuffSrcRef     = pSrc + (*pSrcDstBitsLen)/8;
    ppHuffSrc       = &pHuffSrc;
    huffBitOffset   = *pSrcDstBitsLen % 8;
    
    /*
    -----------------------------------------------------------------------
    DC Huffman Decoding is described in the JPEG Standard [ISO10918] 
    Annex F.2.2.1: Huffman decoding of DC coefficients.
    -----------------------------------------------------------------------
    */
    
    status = armICJP_ReadHuffmanCode(ppHuffSrc, &huffBitOffset, pARM_DCHuffTable, &diffCategory);
    if(status == OMX_StsErr)
    {
        return OMX_StsErr;
    }
    
    if(diffCategory == 0)
    {
        diffVal = 0;
    }
    else
    {
        diffVal  = armGetBits(ppHuffSrc, &huffBitOffset, diffCategory);
        armICJP_ExtendDiffCategory(&diffVal, diffCategory);
    }

    *pDst    = *pDCPred + diffVal;
    *pDCPred = *pDst;
    
    /*
    -----------------------------------------------------------------------
    AC Huffman Decoding is described in the JPEG Standard [ISO10918] 
    Annex F.2.2.2: Decoding procedure for AC coefficients.
    -----------------------------------------------------------------------
    */
    
    for(i = 1; i < ARM_ICJP_BLOCKSIZE; i++)
    {
        pDst[i] = 0;
    }
    
    for(i = 1; i < ARM_ICJP_BLOCKSIZE; i++)
    {
        status = armICJP_ReadHuffmanCode(ppHuffSrc, &huffBitOffset, pARM_ACHuffTable, &huffcodeVal);
        if(status == OMX_StsErr)
        {
            return OMX_StsErr;
        }
        
        diffCategory = huffcodeVal & 0x0f;
        zeroRunLen   = (huffcodeVal >> 4) & 0x0f;
        
        if(diffCategory == 0)
        {
            if(zeroRunLen != 15)
            {
                break;
            }
            i += 15;
        }
        else
        {
            i += zeroRunLen;
            if(i >= ARM_ICJP_BLOCKSIZE)
            {
                break;
            }
            diffVal = armGetBits(ppHuffSrc, &huffBitOffset, diffCategory);
            armICJP_ExtendDiffCategory(&diffVal, diffCategory);
            pDst[i] = diffVal;
        }
    }
    
    /*
    -----------------------------------------------------------------------
    Update the in/out parameter <pSrcDstBitsLen> to reflect the Huffman codes
    read from the stream.
    -----------------------------------------------------------------------
    */
    
    numBytesRead    = pHuffSrc - pHuffSrcRef;
    numBitsRead     = (numBytesRead * 8) + huffBitOffset - (*pSrcDstBitsLen % 8);
    pSrcDstBitsLen += numBitsRead;
    
    return OMX_StsNoErr;
}


/**
 * Function: armICJP_ReadHuffmanCode
 *
 * Description:
 * This function looks up the Huffman decoding table to find the value corresponding to the
 * Huffman code read from the input stream; Then writes this into the value pointer and 
 * updates the buffer pointer and the bit-offset of the current byte.
 *
 * Parameters:
 * [in]  ppHuffSrc       Pointer to pointer to the stream, from where Huffman code is to be read.
 * [in]  pHuffBitOffset  Pointer to the bit offset in the current byte pointed by ppHuffSrc.
 * [in]  pARM_HuffTable  Pointer to the Huffman Table structure.
 * [out] pHuffcodeValue  Pointer variable that contains the value corresponding to the Huffman code.
 * [out] ppHuffSrc       Updated pointer to pointer to the stream, from where Huffman code was read.
 * [out] pHuffBitOffset  Updated pointer to the bit offset in the current byte pointed by ppHuffSrc.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult armICJP_ReadHuffmanCode(
        const OMX_U8 **ppHuffSrc,
        OMX_INT *pHuffBitOffset,
        const ARM_sDecodeHuffmanSpec *pARM_HuffTable,
        OMX_U16 *pHuffcodeValue
       )
{
    OMX_INT i, pos;
    OMX_U16 huffcode;
    
    /*
    -----------------------------------------------------------------------
    This functionality, referred as DECODE, by the JPEG Standard [ISO10918] 
    is described in Annex F.2.2.3: The DECODE procedure.
    -----------------------------------------------------------------------
    */
    
    huffcode = armGetBits(ppHuffSrc, pHuffBitOffset, 1);
    
    for(i = 0; (huffcode > pARM_HuffTable->maxcode[i]) && (i < 16); i++)
    {
        huffcode = (huffcode << 1) + armGetBits(ppHuffSrc, pHuffBitOffset, 1);
    }
    
    if((huffcode <= pARM_HuffTable->maxcode[pARM_HuffTable->maxLen - 1]) && (i < 16))
    {
        pos = pARM_HuffTable->valptr[i] + huffcode - pARM_HuffTable->mincode[i];
        *pHuffcodeValue = pARM_HuffTable->huffval[pos];
        return OMX_StsNoErr;
    }
    
    return OMX_StsErr;
}


/**
 * Function: armICJP_ExtendDiffCategory
 *
 * Description:
 * This function takes in the difference category and the additional bits that
 * are used to completely represent the Huffman encoded value and returns the
 * actual value that was represented by these two together.
 *
 * Parameters:
 * [in]  diffCategory   The difference category of the Huffman code.
 * [in]  pdiffVal       The additional bits as read from the Huffman Stream.
 * [out] pdiffVal       The final value decoded, after sign adjustments.
 * 
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult armICJP_ExtendDiffCategory(
        OMX_INT *pdiffVal,
        OMX_U16 diffCategory
       )
{
    OMX_INT minPositiveVal = 1 << (diffCategory - 1);
    
    /*
    -----------------------------------------------------------------------
    This functionality is described by the JPEG Standard [ISO10918] in the
    Figure F.12: Extending the sign bit of a decoded value in V.
    -----------------------------------------------------------------------
    */
    
    if(*pdiffVal < minPositiveVal)
    {
        *pdiffVal += ((0xffffffff << diffCategory) + 1);
    }
    
    return OMX_StsNoErr;
}

/* End of file */
