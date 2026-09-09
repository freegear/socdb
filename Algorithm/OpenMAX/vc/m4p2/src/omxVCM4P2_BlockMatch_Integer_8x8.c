/**
 *  omxVCM4P2_BlockMatch_Integer_8x8.c
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
 * Description:
 * Contains modules for Block matching, a full search algorithm
 * is implemented
 * 
 */

#include "omxVC.h"
#include "armVC.h"
#include "armCOMM.h"

/**
 * Function: omxVCM4P2_BlockMatch_Integer_8x8
 *
 * Description:
 * Performs an 8x8 block search; estimates motion vector and associated minimum SAD.  Both
 * the input and output motion vectors are represented using half-pixel units, and therefore
 * a shift left or right by 1 bit may be required, respectively, to match the input or output
 * MVs with other functions that either generate output MVs or expect input MVs represented
 * using integer pixel units.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcRefBuf		pointer to the reference Y plane; points to the reference block that
 *                    corresponds to the location of the current 8x8 block in the current
 *                    plane.
 * [in]	refWidth		  width of the reference plane
 * [in]	pRefRect		  pointer to the valid reference plane rectangle; coordinates are specified
 *                    relative to the image origin.  Rectangle boundaries may extend beyond
 *                    image boundaries if the image has been padded.
 * [in]	pSrcCurrBuf		pointer to current block in the current macroblock buffer extracted from
 *                    original plane (linear array, 128 entries); must be aligned on an 8-byte boundary.
 *                    The step between lines of the 8x8 block is 16 bytes.
 * [in]	pCurrPointPos	position of the current macroblock in the current plane
 * [in]	pSrcPreMV		  pointer to predicted motion vector; NULL indicates no predicted MV
 * [in]	pSrcPreSAD		pointer to SAD associated with the predicted MV , may be set to NULL if unavailable.
 * [in]	pMESpec 	    implementation-specific state,can be set to NULL when using full search
 * [out]	pDstMV			pointer to estimated MV
 * [out]	pDstSAD			pointer to minimum SAD
 *
 * Return Value:
 * OMX_StsNoErr - no error.
 * OMX_StsBadArgErr - bad arguments
 *			at least one of the following pointers is NULL: pSrcRefBuf, pRefRect, pSrcCurrBuff,
 *                                    pCurrPointPos, pSrcPreSAD, or pMESpec, or
 *                         pSrcCurrBuf is not 8-byte aligned
 *
 */

OMXResult omxVCM4P2_BlockMatch_Integer_8x8(
     const OMX_U8 *pSrcRefBuf,
     OMX_INT refWidth,
     const OMXRect *pRefRect,
     const OMX_U8 *pSrcCurrBuf,
     const OMXVCM4P2Coordinate *pCurrPointPos,
     const OMXVCMotionVector *pSrcPreMV,
     const OMX_INT *pSrcPreSAD,
     void *pMESpec,
     OMXVCMotionVector *pDstMV,
     OMX_INT *pDstSAD
)
{
   OMX_U8 BlockSize = 8;
   
   /* Argument error checks */  
   armRetArgErrIf(!armIs8ByteAligned(pSrcCurrBuf), OMX_StsBadArgErr);
   
   return ( armVCM4P2_BlockMatch_Integer(
     pSrcRefBuf,
     refWidth,
     pRefRect,
     pSrcCurrBuf,
     pCurrPointPos,
     pSrcPreMV,
     pSrcPreSAD,
     pMESpec,
     pDstMV,
     pDstSAD,
     BlockSize)
     );

}

/* End of file */
