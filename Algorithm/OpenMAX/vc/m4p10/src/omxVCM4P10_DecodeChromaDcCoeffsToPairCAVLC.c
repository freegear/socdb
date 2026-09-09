/* ----------------------------------------------------------------
 *
 *  omxVCM4P10_DecodeChromaDcCoeffsToPairCAVLC.c
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
 * H.264 decode coefficients module
 * 
 */
 
#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"
#include "armVC.h"

/**
 * Function: omxVCM4P10_DecodeChromaDcCoeffsToPairCAVLC
 *
 * Description:
 * Performs CAVLC decoding and inverse raster scan for 2x2 block of 
 * ChromaDCLevel. The decoded coefficients in packed position-coefficient 
 * buffer are stored in increasing raster scan order, namely position order.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppBitStream		Double pointer to current byte in bit stream
 *								buffer
 * [in]	pOffset			Pointer to current bit position in the byte 
 *								pointed to by *ppBitStream
 * [out]	ppBitStream		*ppBitStream is updated after each block is decoded
 * [out]	pOffset			*pOffset is updated after each block is decoded
 * [out]	pNumCoeff		Pointer to the number of nonzero coefficients
 *								in this block
 * [out]	ppPosCoefbuf	Double pointer to destination residual
 *								coefficient-position pair buffer
 *
 * Return Value:
 * Standard omxError result. See enumeration for possible result codes.
 *
 */

OMXResult omxVCM4P10_DecodeChromaDcCoeffsToPairCAVLC (
     const OMX_U8** ppBitStream,
     OMX_S32* pOffset,
     OMX_U8* pNumCoeff,
     OMX_U8** ppPosCoefbuf        
 )

{
    armRetArgErrIf(ppBitStream==NULL   , OMX_StsBadArgErr);
    armRetArgErrIf(*ppBitStream==NULL  , OMX_StsBadArgErr);
    armRetArgErrIf(pOffset==NULL       , OMX_StsBadArgErr);
    armRetArgErrIf(*pOffset<0          , OMX_StsBadArgErr);
    armRetArgErrIf(*pOffset>7          , OMX_StsBadArgErr);
    armRetArgErrIf(pNumCoeff==NULL     , OMX_StsBadArgErr);
    armRetArgErrIf(ppPosCoefbuf==NULL  , OMX_StsBadArgErr);
    armRetArgErrIf(*ppPosCoefbuf==NULL , OMX_StsBadArgErr);

    return armVCM4P10_DecodeCoeffsToPair(ppBitStream, pOffset, pNumCoeff,
                                         ppPosCoefbuf, 4, 4);

}
