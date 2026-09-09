/**
 *  omxVCM4P2_BlockMatch_Half_16x16.c
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
 * Function: omxVCM4P2_BlockMatch_Half_16x16
 *
 * Description:
 * Performs a 16x16 block match with half-pixel resolution.  Returns the estimated
 * motion vector and associated minimum SAD.  This function estimates the half-pixel
 * motion vector by interpolating the integer resolution motion vector referenced
 * by the input parameter pSrcDstMV, i.e., the initial integer MV is generated
 * externally.  The input parameters pSrcRefBuf and pSearchPointRefPos should be
 * shifted by the winning MV of 16x16 integer search prior to calling BlockMatch_Half_16x16.
 * The function BlockMatch_Integer_16x16 may be used for integer motion estimation.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcRefBuf		    pointer to the reference Y plane; points to the reference macroblock
 *                          that corresponds to the location of the current macroblock in
 *                          the	current plane.
 * [in]	refWidth		    width of the reference plane
 * [in]	pRefRect		    reference plane valid region rectangle
 * [in]	pSrcCurrBuf		    pointer to the current macroblock extracted from original plane
 *                          (linear array, 256 entries); must be aligned on an 16-byte boundary.
 * [in]	pSearchPointRefPos  position of the starting point for half pixel search (specified in terms of
 *                          integer pixel units) in the reference plane, i.e., the reference position pointed
 *                          to by the predicted motion vector.	
 * [in]	rndVal			    rounding control parameter: 0 - disabled; 1 - enabled. 
 * [in]	pSrcDstMV		    pointer to the initial MV estimate; typically generated during a prior
 *                          16X16 integer search and its unit is half pixel.
 * [out]pSrcDstMV		    pointer to estimated MV
 * [out]pDstSAD			    pointer to minimum SAD
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *
 */

OMXResult omxVCM4P2_BlockMatch_Half_16x16(
     const OMX_U8 *pSrcRefBuf,
     OMX_INT refWidth,
     const OMXRect *pRefRect,
     const OMX_U8 *pSrcCurrBuf,
     const OMXVCM4P2Coordinate *pSearchPointRefPos,
     OMX_INT rndVal,
     OMXVCMotionVector *pSrcDstMV,
     OMX_INT *pDstSAD
)
{

    /* For a blocksize of 16x16 */
    OMX_U8 BlockSize = 16;
    
    /* Argument error checks */  
    armRetArgErrIf(!armIs16ByteAligned(pSrcCurrBuf), OMX_StsBadArgErr);
   
    return (armVCM4P2_BlockMatch_Half(
                                pSrcRefBuf,
                                refWidth,
                                pRefRect,
                                pSrcCurrBuf,
                                pSearchPointRefPos,
                                rndVal,
                                pSrcDstMV,
                                pDstSAD,
                                BlockSize));


}

/* End of file */
