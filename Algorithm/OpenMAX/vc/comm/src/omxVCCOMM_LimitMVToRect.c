/**
 *  omxVCCOMM_LimitMVToRect.c
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
 * Contains module for limiting the MV
 * 
 */
 
#include "omxVC.h"
#include "armCOMM.h"

/**
  * Function: omxVCCOMM_LimitMVToRect
 *
 * Description:
 * Limit the motion vector of current block/macroblock into the expanded
 * bounding rectangle.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcMV			pointer to the motion vector of current block
 *								  or macroblock
 * [in]	pRectVOPRef	pointer to the bounding rectangle
 * [in]	Xcoord      the coordinates of the current block or
 *								  macroblock
 * [in] Ycoord	    the coordinates of the current block or
 *								  macroblock
 * [in]	size			  the size of block or macroblock
 * [out]pDstMV  		pointer to the limited motion vector
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - At least one of the following pointers is NULL: pSrcMV, pDstMV, or pRectVOPRef.
 *        or
 *    - At least one of following case is true: size is neither BLOCK_SIZE nor MB_SIZE;
 *        the width (or height) of rectangle is less than twice the of size.
 *
 */
OMXResult omxVCCOMM_LimitMVToRect(
     const OMXVCMotionVector * pSrcMV,
     OMXVCMotionVector *pDstMV,
     const OMXRect * pRectVOPRef,
     OMX_INT Xcoord,
     OMX_INT Ycoord,
     OMX_INT size
)
{
    /* Argument error checks */
    armRetArgErrIf(pSrcMV == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pDstMV == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pRectVOPRef == NULL, OMX_StsBadArgErr);
    armRetArgErrIf((size != 8) && (size != 16), OMX_StsBadArgErr);
    armRetArgErrIf((pRectVOPRef->width < (2* size)), OMX_StsBadArgErr);
    armRetArgErrIf((pRectVOPRef->height < (2* size)), OMX_StsBadArgErr);

    pDstMV->dx = armMin (armMax (pSrcMV->dx, pRectVOPRef->x - Xcoord),
                    (pRectVOPRef->x + pRectVOPRef->width - Xcoord - size));
    pDstMV->dy = armMin (armMax (pSrcMV->dy, pRectVOPRef->y - Ycoord),
                    (pRectVOPRef->y + pRectVOPRef->height - Ycoord - size));


    return OMX_StsNoErr;
}

/* End of file */
