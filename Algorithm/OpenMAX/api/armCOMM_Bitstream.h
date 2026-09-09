/**
 *  armCOMM_Bitstream.h
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
 * File: armCOMM_Bitstream.h
 * Brief: Declares common API's/Data types used across the OpenMax Encoders/Decoders.
 *
 */

#ifndef _armCodec_H_
#define _armCodec_H_

typedef struct {
    OMX_U8   codeLen;
    OMX_U32	 codeWord;
} ARM_VLC32;

/**
 * Function: armLookAheadBits()
 *
 * Description:
 * Get the next N bits from the bitstream without advancing the bitstream pointer
 *
 * Parameters:
 * [in]     **ppBitStream
 * [in]     *pOffset
 * [in]     N=1...32
 *
 * Returns  Value
 */

OMX_U32 armLookAheadBits(const OMX_U8 **ppBitStream, OMX_INT *pOffset, OMX_INT N);

/**
 * Function: armGetBits()
 *
 * Description:
 * Read N bits from the bitstream
 *    
 * Parameters:
 * [in]     *ppBitStream
 * [in]     *pOffset
 * [in]     N=1..32
 *
 * [out]    *ppBitStream
 * [out]    *pOffset
 * Returns  Value
 */

OMX_U32 armGetBits(const OMX_U8 **ppBitStream, OMX_INT *pOffset, OMX_INT N);

/**
 * Function: armByteAlign()
 *
 * Description:
 * Align the pointer *ppBitStream to the next byte boundary
 *
 * Parameters:
 * [in]     *ppBitStream
 * [in]     *pOffset
 *
 * [out]    *ppBitStream
 * [out]    *pOffset
 *
 **/
 
OMXVoid armByteAlign(const OMX_U8 **ppBitStream,OMX_INT *pOffset);

/** 
 * Function: armSkipBits()
 *
 * Description:
 * Skip N bits from the value at *ppBitStream
 *
 * Parameters:
 * [in]     *ppBitStream
 * [in]     *pOffset
 * [in]     N
 *
 * [out]    *ppBitStream
 * [out]    *pOffset
 *
 **/

OMXVoid armSkipBits(const OMX_U8 **ppBitStream,OMX_INT *pOffset,OMX_INT N);

/***************************************
 * Variable bit length Decode
 ***************************************/

/**
 * Function: armUnPackVLC32()
 *
 * Description:
 * Variable length decode of variable length symbol (max size 32 bits) read from
 * the bit stream pointed by *ppBitStream at *pOffset by using the table
 * pointed by pCodeBook
 * 
 * Parameters:
 * [in]     *pBitStream
 * [in]     *pOffset
 * [in]     pCodeBook
 * 
 * [out]    *pBitStream
 * [out]    *pOffset
 *
 * Returns : Code Book Index if successfull. 
 *         :  -1             if search fails.
 **/

OMX_INT armUnPackVLC32(
    const OMX_U8 **ppBitStream,
    OMX_INT *pOffset,
    const ARM_VLC32 *pCodeBook
);

/***************************************
 * Fixed bit length Encode
 ***************************************/

/**
 * Function: armPackBits
 *
 * Description:
 * Pack a VLC code word into the bitstream
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppBitStream		pointer to the pointer to the current byte 
 *                      in the bit stream.
 * [in]	pOffset	        pointer to the bit position in the byte 
 *                      pointed by *ppBitStream. Valid within 0
 *                      to 7.
 * [in]	codeWord		Code word that need to be inserted in to the
 *                          bitstream
 * [in]	codeLength		Length of the code word valid range 1...32
 *
 * [out] ppBitStream	*ppBitStream is updated after the block is encoded,
 *	                        so that it points to the current byte in the bit
 *							stream buffer.
 * [out] pBitOffset		*pBitOffset is updated so that it points to the
 *							current bit position in the byte pointed by
 *							*ppBitStream.
 *
 * Return Value:
 * Standard OMX_RESULT result. See enumeration for possible result codes.
 *
 */
 
OMXResult armPackBits (
    OMX_U8  **ppBitStream, 
    OMX_INT *pOffset,
    OMX_U32 codeWord, 
    OMX_INT codeLength 
);
 
/***************************************
 * Variable bit length Encode
 ***************************************/

/**
 * Function: armPackVLC32
 *
 * Description:
 * Pack a VLC code word into the bitstream
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppBitStream		pointer to the pointer to the current byte 
 *                      in the bit stream.
 * [in]	pBitOffset	    pointer to the bit position in the byte 
 *                      pointed by *ppBitStream. Valid within 0
 *                      to 7.
 * [in]	 code     		VLC code word that need to be inserted in to the
 *                      bitstream
 *
 * [out] ppBitStream	*ppBitStream is updated after the block is encoded,
 *	                    so that it points to the current byte in the bit
 *						stream buffer.
 * [out] pBitOffset		*pBitOffset is updated so that it points to the
 *						current bit position in the byte pointed by
 *						*ppBitStream.
 *
 * Return Value:
 * Standard OMX_RESULT result. See enumeration for possible result codes.
 *
 */
 
OMXResult armPackVLC32 (
    OMX_U8 **ppBitStream, 
    OMX_INT *pBitOffset,
    ARM_VLC32 code 
);

#endif      /*_armCodec_H_*/

/*End of File*/
