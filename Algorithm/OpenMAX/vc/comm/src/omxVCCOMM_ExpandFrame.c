/**
 *  omxVCCOMM_ExpandFrame.c
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
 * Description:
 * This function will Expand Frame boundary pixels into Plane
 * 
 */

#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"

/**
 * Function: omxVCCOMM_ExpandFrame
 *
 * Description:
 * This function expands a reconstructed frame. The unexpanded frame is stored in a
 * plane buffer with preserved space for edge expansion, so what we do is only filling
 * out the edge pixels. (A plane is like a container, the frame is in the center of it).
 *
 * Remarks:
 *
 *	[in]	pSrcDstPlane	Pointer to the top-left corner of the frame to be expanded.
 *                          Must be 16-byte aligned
 *	[in]	iFrameWidth		Width of the frame.	Must be multiple of 16.
 *	[in]	iFrameHeight	Height of the frame. Must be multiple of 16.
 *	[in]	iExpandPels		Number of pixels to be expanded in one direction.
 *	[in]	iPlaneStep      Width of the plane buffer. iPlaneStep should be greater than
 *                          (iFrameWidth + 2 * iExpandPels). Must be multiple of 8.
 *	[out]	pSrcDstPlane	Pointer to the top-left corner of the frame(NOT the top-left
 *							corner of the plane).
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    -  pSrcDstPlane is NULL
 *    -  iFrameWidth(iFrameHeight) <=0 or not a multiple of 16
 *    -  iExpandPels <=0 or not a multiple of 8
 *    -  iPlaneStep <=0 or not a multiple of 16
 *
 */	   															
OMXResult omxVCCOMM_ExpandFrame(
	OMX_U8*	pSrcDstPlane, 
	OMX_U32	iFrameWidth, 
	OMX_U32	iFrameHeight, 
	OMX_U32	iExpandPels, 
	OMX_U32	iPlaneStep
)
{
    OMX_INT     x, y;
    OMX_U8*     pLeft;
    OMX_U8*     pRight;
    OMX_U8*     pTop;
    OMX_U8*     pBottom;

    /* check for argument error */
    armRetArgErrIf(pSrcDstPlane == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(armNot16ByteAligned(pSrcDstPlane), OMX_StsBadArgErr)
    armRetArgErrIf(iFrameWidth == 0 || iFrameWidth & 15, OMX_StsBadArgErr)
    armRetArgErrIf(iFrameHeight == 0 || iFrameHeight & 15, OMX_StsBadArgErr)
    armRetArgErrIf(iExpandPels == 0 || iExpandPels & 7, OMX_StsBadArgErr)
    armRetArgErrIf(iPlaneStep < (iFrameWidth + 2 * iExpandPels), 
                   OMX_StsBadArgErr)

    /* Top and Bottom */
    pTop = pSrcDstPlane - (iExpandPels * iPlaneStep);
    pBottom = pSrcDstPlane + (iFrameHeight * iPlaneStep);

    for (y = 0; y < (OMX_INT)iExpandPels; y++)
    {
        for (x = 0; x < (OMX_INT)iFrameWidth; x++)
        {
            pTop [y * iPlaneStep + x] = 
                pSrcDstPlane [x];
            pBottom [y * iPlaneStep + x] = 
                pSrcDstPlane [(iFrameHeight - 1) * iPlaneStep + x];
        }
    }

    /* Left, Right and Corners */
    pLeft = pSrcDstPlane - iExpandPels;
    pRight = pSrcDstPlane + iFrameWidth;

    for (y = -(OMX_INT)iExpandPels; y < (OMX_INT)(iFrameHeight + iExpandPels); y++)
    {
        for (x = 0; x < (OMX_INT)iExpandPels; x++)
        {
            pLeft [y * iPlaneStep + x] = 
                pSrcDstPlane [y * iPlaneStep + 0];
            pRight [y * iPlaneStep + x] = 
                pSrcDstPlane [y * iPlaneStep + (iFrameWidth - 1)];
        }
    }

    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

