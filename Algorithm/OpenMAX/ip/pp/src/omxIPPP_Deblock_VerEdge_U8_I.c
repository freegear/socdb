/**
 *  omxIPPP_Deblock_VerEdge_U8_I.c
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
 * This file contains module for vertical edge deblock filtering
 *
 */

#include "omxtypes.h"
#include "omxIP.h"

#include "armIP.h"
#include "armCOMM.h"

/**
 * Function: omxIPPP_Deblock_VerEdge_U8_I()
 *
 * Brief:
 * 
 *
 * Description:
 * Performs deblock filtering on two adjacent blocks along a block edge (vertical) of an
 * image, as shown in the figure below.
 * Status: Design
 *
 * Remarks:
 * The output buffer region is required to have the same size as 
 * that of the input region, although the width of the overall 
 * images may differ.
 *
 * Parameters:
 * [in]  pSrcDst    pointer to the first pixel of the second block (labeled ¡°block 2¡± in the figure).
 * [in]  step       width of the image plane, in bytes; must be a multiple of 8.
 * [in]  QP         quantization parameter, as described in Section J.3 of Annex J in H.263+
 * [out] pSrcDst    pointer to the first pixel of the second output block (labeled ¡°block 2¡± in the figure)
 * return value:
 * Standard OMXResult result. See enumeration for possible result codes.
 * 
 */

OMXResult omxIPPP_Deblock_VerEdge_U8_I(
	OMX_U8		  *pSrcDst, 
	const OMX_INT step, 
	const OMX_INT QP
)
{
    /* Argument Checking */
    armRetArgErrIf( pSrcDst == NULL         , OMX_StsBadArgErr);
    armRetArgErrIf( (step < 8) || (step & 7), OMX_StsBadArgErr);
    armRetArgErrIf( (QP < 1)   || (QP > 31) , OMX_StsBadArgErr);
    
    armRetArgErrIf( armNotByteAligned(pSrcDst, 8), OMX_StsBadArgErr);

    /* Processing */
    armIPPP_DeblockEdge(pSrcDst, step, QP, 0);

    return OMX_StsNoErr;
}

/*End of File*/

