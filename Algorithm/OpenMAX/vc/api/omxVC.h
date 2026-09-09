/**
 * File: omxVC.h
 * Brief: OpenMAX Video Coding DL library
 *
 * Copyright © 2005-06 The Khronos Group Inc. All Rights Reserved. 
 *
 * These materials are protected by copyright laws and contain material 
 * proprietary to the Khronos Group, Inc.  You may use these materials 
 * for implementing Khronos specifications, without altering or removing 
 * any trademark, copyright or other notice from the specification.
 * 
 * Khronos Group makes no, and expressly disclaims any, representations 
 * or warranties, express or implied, regarding these materials, including, 
 * without limitation, any implied warranties of merchantability or fitness 
 * for a particular purpose or non-infringement of any intellectual property. 
 * Khronos Group makes no, and expressly disclaims any, warranties, express 
 * or implied, regarding the correctness, accuracy, completeness, timeliness, 
 * and reliability of these materials. 
 *
 * Under no circumstances will the Khronos Group, or any of its Promoters, 
 * Contributors or Members or their respective partners, officers, directors, 
 * employees, agents or representatives be liable for any damages, whether 
 * direct, indirect, special or consequential damages for lost revenues, 
 * lost profits, or otherwise, arising from or in connection with these 
 * materials.
 * 
 * Khronos and OpenMAX are trademarks of the Khronos Group Inc. 
 *
 */

/* *****************************************************************************************/
/**
 *
 *  NewDomain: VC The Video Coding Domain
 *  WithinDomain: OM
 *
 *  StartDomain: VC
 */

#ifndef _OMXVC_H_
#define _OMXVC_H_

#include "omxtypes.h"

#ifdef __cplusplus
extern "C" {
#endif

/******************************************************************************************/
/**
 *
 *  NewDomain: COMM The Common subdomain
 *  WithinDomain: VC
 *
 *  StartDomain: COMM
 */

/** =============== Structure Definition for Sample Generation ============== */
typedef struct {
	OMX_S16 dx;
	OMX_S16 dy;
}OMXVCMotionVector;

typedef struct
{
	OMX_INT searchEnable8x8; /** enables 8x8 search */
    OMX_INT halfPelSearchEnable; /** enables half-pel resolution */
    OMX_INT searchRange; /** search range */
    OMX_INT rndVal; /** rounding control; 0-disabled, 1-enabled*/
} OMXVCM4P2MEParams;

/**
 * Function: omxVCCOMM_ComputeTextureErrorBlock_SAD
 *
 * Description:
 * Computes texture error of the block; also returns SAD.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	 pSrc		  pointer to the source plane. This should be aligned
 *                    on an 8-byte boundary.
 * [in]	 srcStep	  step of the source plane. Must be multiple of 8
 * [in]	 pSrcRef	  pointer to the reference buffer, an 8x8 block.
 *                    This should be aligned on an 8-byte boundary.
 * [out] pDst	      pointer to the destination buffer, an 8x8 block.
 *	                  This should be aligned on an 8-byte boundary.
 * [out] pDstSAD	  pointer to the Sum of Absolute Differences (SAD) value
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - At least one of the following pointers is NULL: pSrc, pSrcRef, pDst and pDstSAD.
 *    - pSrc is not 8 byte aligned.
 *    - SrcStep <= 0 or srcStep is not a multiple of 8.
 *    - pSrcRef is not 8 byte aligned.
 *    - pDst is not 8 byte aligned.
 *
 */
OMXResult omxVCCOMM_ComputeTextureErrorBlock_SAD(
     const OMX_U8 *pSrc,
     OMX_INT srcStep,
     const OMX_U8 *pSrcRef,
     OMX_S16  *pDst,
     OMX_INT *pDstSAD
 );

/**
 * Function: omxVCCOMM_ComputeTextureErrorBlock
 *
 * Description:
 * Computes the texture error of the block.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrc		pointer to the source plane. This should be aligned
 *		            on an 8-byte boundary.
 * [in]	srcStep		step of the source plane. Must be multiple of 8
 * [in]	pSrcRef		pointer to the reference buffer, an 8x8 block. This
 *					should be aligned on an 8-byte boundary.
 * [out]	pDst	pointer to the destination buffer, an 8x8 block.
 *					This should be aligned on an 8-byte boundary.
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *   - At least one of the following pointers is NULL: pSrc, pSrcRef, pDst.
 *   - pSrc is not 8 byte aligned.
 *   - SrcStep <= 0 or srcStep is not a multiple of 8.
 *   - pSrcRef is not 8 byte aligned.
 *   - pDst is not 8 byte aligned
 *
 */

OMXResult omxVCCOMM_ComputeTextureErrorBlock(
     const OMX_U8 *pSrc,
     OMX_INT srcStep,
     const OMX_U8 *pSrcRef,
     OMX_S16 *pDst
 );

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
     const OMXVCMotionVector *pSrcMV,
     OMXVCMotionVector *pDstMV,
     const OMXRect *pRectVOPRef,
     OMX_INT Xcoord,
     OMX_INT Ycoord,
     OMX_INT size
 );

/**
 * Function: omxVCCOMM_SAD_16x
 *
 * Description:
 * This function calculate the SAD for 16x16 and 16x8 blocks.
 *
 * Remarks:
 *
 * [in]		pSrcOrg		Pointer to the original block. Must be 16-byte aligned
 * [in]		iStepOrg	Step of the original block buffer. Must be multiple of 16.
 * [in]		pSrcRef		Pointer to the reference block
 * [in]		iStepRef	Step of the reference block buffer. Must be multiple of 16.
 * [in]		iHeight		Height of the block
 * [out]	pDstSAD		Pointer of result SAD
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - At least one of the following pointers is NULL: pSrcOrg, pSrcRef, pDstSAD.
 *    - pSrcOrg is not 16 byte aligned.
 *    - iStepOrg <= 0 or iStepOrg is not a multiple of 16.
 *    - iStepRef <= 0 or iStepRef is not a multiple of 16.
 *    - iHeight is not 8 or 16
 *
 */
OMXResult omxVCCOMM_SAD_16x(
			const OMX_U8 *pSrcOrg,
			OMX_U32 	iStepOrg,
			const OMX_U8 *pSrcRef,
			OMX_U32 	iStepRef,
			OMX_S32 *pDstSAD,
			OMX_U32		iHeight
);

/**
 * Function: omxVCCOMM_SAD_8x
 *
 * Description:
 * This function calculate the SAD for 8x16, 8x8, 8x4 blocks.
 *
 * Remarks:
 *
 * [in]		pSrcOrg		Pointer to the original block. Must be 8-byte aligned
 * [in]		iStepOrg	Step of the original block buffer. Must be multiple of 8.
 * [in]		pSrcRef		Pointer to the reference block
 * [in]		iStepRef	Step of the reference block buffer. Must be multiple of 8.
 * [in]		iHeight		Height of the block
 * [out]	pDstSAD		Pointer of result SAD
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - At least one of the following pointers is NULL: pSrcOrg, pSrcRef, pDstSAD.
 *    - pSrcOrg is not 8 byte aligned.
 *    - iStepOrg <= 0 or iStepOrg is not a multiple of 8.
 *    - iStepRef <= 0 or iStepRef is not a multiple of 8.
 *    - iHeight is not 4, 8 or 16
 *
 */
OMXResult omxVCCOMM_SAD_8x(
	const OMX_U8 *pSrcOrg,
	OMX_U32 	iStepOrg,
	const OMX_U8 *pSrcRef,
	OMX_U32 	iStepRef,
	OMX_S32 *pDstSAD,
	OMX_U32		iHeight
);

/**
 * Function: omxVCCOMM_Average_8x
 *
 * Description:
 * This function calculates the average of two 8x4 or 8x8 or 8x16 blocks and stores the result.
 * The average is computed as (a+b+1)/2. The block average function can be used in conjunction
 * with half-pixel interpolation to obtain quarter pixel motion estimates, as described in
 * subclause 8.4.2.2.1 of ISO/IEC 14496-10.

 * Remarks:
 *
 *	[in]	pPred0			Pointer to the top-left corner of reference block 0
 *	[in]	pPred1			Pointer to the top-left corner of reference block 1
 *	[in]	iPredStep0	Step of reference block 0. Must be multiple of 8.
 *	[in]	iPredStep1	Step of reference block 1. Must be multiple of 8.
 *	[in]	iDstStep 		Step of the destination buffer. Must be multiple of 8.
 *	[in]	iHeight			Height of the blocks
 *	[out]	pDstPred		Pointer to the destination buffer. Must be 8-byte aligned
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - At least one of the following pointers is NULL: pPred0, pPred1, pDstPred.
 *    - pDstPred is not 8 byte aligned.
 *    - iPredStep0 <= 0 or iPredStep0 is not a multiple of 8.
 *    - iPredStep1 <= 0 or iPredStep1 is not a multiple of 8.
 *    - iDstStep <= 0 or iDstStep is not a multiple of 8.
 *    - iHeight is not 4, 8 or 16
 *
 */
 OMXResult omxVCCOMM_Average_8x (
	 const OMX_U8 *pPred0,
	 const OMX_U8 *pPred1,
     OMX_U32		iPredStep0,
     OMX_U32		iPredStep1,
	 OMX_U8 *pDstPred,
     OMX_U32		iDstStep,
	 OMX_U32		iHeight
);

/**
 * Function: omxVCCOMM_Average_16x
 *
 * Description:
 * This function calculates the average of two 16x16 or 16x8 blocks and stores the result.
 * The average is computed as (a+b+1)/2. The block average function can be used in conjunction
 * with half-pixel interpolation to obtain quarter pixel motion estimates, as described in
 * subclause 8.4.2.2.1 of ISO/IEC 14496-10.
 *
 * Remarks:
 *
 *	[in]	pPred0			Pointer to the top-left corner of reference block 0
 *	[in]	pPred1			Pointer to the top-left corner of reference block 1
 *	[in]	iPredStep0	    Step of reference block 0. Must be multiple of 16.
 *	[in]	iPredStep1	    Step of reference block 1. Must be multiple of 16.
 *	[in]	iDstStep 		Step of the destination buffer. Must be multiple of 16.
 *	[in]	iHeight			Height of the blocks
 *	[out]	pDstPred		Pointer to the destination buffer. Must be 16-byte aligned
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - At least one of the following pointers is NULL: pPred0, pPred1, pDstPred.
 *    - pDstPred is not 16 byte aligned.
 *    - iPredStep0 <= 0 or iPredStep0 is not a multiple of 16.
 *    - iPredStep1 <= 0 or iPredStep1 is not a multiple of 16.
 *    - iDstStep <= 0 or iDstStep is not a multiple of 16.
 *    - iHeight is not 8 or 16
 *
 */
 OMXResult omxVCCOMM_Average_16x (
	 const OMX_U8 *pPred0,
	 const OMX_U8 *pPred1,
	 OMX_U32		iPredStep0,
	 OMX_U32		iPredStep1,
	 OMX_U8 *pDstPred,
	 OMX_U32		iDstStep,
	 OMX_U32		iHeight
);

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
	OMX_U8  *pSrcDstPlane,
	OMX_U32	iFrameWidth,
	OMX_U32	iFrameHeight,
	OMX_U32	iExpandPels,
	OMX_U32	iPlaneStep
);


/**
 * Function: omxVCCOMM_Copy8x8
 *
 * Description:
 * Copies the reference 8x8 block to the current block.
 * Parameters:
 * [in] pSrc - pointer to the reference block in the source frame; must be aligned on an 8-byte boundary.
 * [in] step - distance between the starts of consecutive lines in the reference frame, in bytes;
 *             must be a multiple of 8 and must be larger than or equal to 8.
 * [out] pDst - pointer to the destination block; must be aligned on an 8-byte boundary.
 * Return Value:
 *	OMX_StsNoErr - no error
 *	OMX_StsBadArgErr - bad arguments; returned under any of the following conditions:
 *		             - one or more of the following pointers is NULL:  pSrc, pDst
 *		             - one or more of the following pointers is not aligned on an 8-byte boundary:  pSrc, pDst
 *		             - step <8 or step is not a multiple of 8.  
 */

OMXResult omxVCCOMM_Copy8x8(
		const OMX_U8 *pSrc, 
		OMX_U8 *pDst, 
		OMX_INT step);

/**
 * Function: omxVCCOMM_Copy16x16
 *
 * Description:
 * Copies the reference 16x16 macroblock to the current macroblock.
 * Parameters:
 * [in] pSrc - pointer to the reference macroblock in the source frame; must be aligned on a 16-byte boundary.
 * [in] step - distance between the starts of consecutive lines in the reference frame, in bytes; must be a 
 *             multiple of 16 and must be larger than or equal to 16.
 * [out] pDst - pointer to the destination macroblock; must be aligned on a 16-byte boundary.
 * Return Value:
 *	OMX_StsNoErr - no error
 *	OMX_StsBadArgErr - bad arguments; returned under any of the following conditions:
 *		             - one or more of the following pointers is NULL:  pSrc, pDst
 *		             - one or more of the following pointers is not aligned on an 16-byte boundary:  pSrc, pDst
 *		             - step <16 or step is not a multiple of 16.  
 */

OMXResult omxVCCOMM_Copy16x16(
		const OMX_U8 *pSrc, 
		OMX_U8 *pDst, 
		OMX_INT step);

/**
 * EndDomain: COMM
 */


/* *****************************************************************************************/
/**
 *
 *  NewDomain: M4P2 The MPEG4 Codec subdomain
 *  WithinDomain: VC
 *
 *  StartDomain: M4P2
 */

/** =============== Structure Definition for Sample Generation ============== */

/** direction */
enum {
	OMX_VC_NONE			= 0,
	OMX_VC_HORIZONTAL	= 1,
	OMX_VC_VERTICAL		= 2
};

/** bilinear interpolation type */
enum {
	OMX_VC_INTEGER_PIXEL = 0,
	OMX_VC_HALF_PIXEL_X  = 1,
	OMX_VC_HALF_PIXEL_Y  = 2,
	OMX_VC_HALF_PIXEL_XY = 3
};

enum {
	OMX_VC_UPPER  = 1,			/** set if the above macroblock is available */
	OMX_VC_LEFT   = 2,			/** set if the left macroblock is available */
	OMX_VC_CENTER = 4,
	OMX_VC_RIGHT  = 8,
	OMX_VC_LOWER  = 16,
	OMX_VC_UPPER_LEFT  = 32,	/** set if the above-left macroblock is available */
	OMX_VC_UPPER_RIGHT = 64,	/** set if the above-right macroblock is available */
	OMX_VC_LOWER_LEFT  = 128,
	OMX_VC_LOWER_RIGHT = 256
};

typedef enum {
	OMX_VC_LUMINANCE,			/** luminance component */
	OMX_VC_CHROMINANCE			/** chrominance component */
} OMXVCM4P2VideoComponent;

typedef enum {
	OMX_VC_INTER		= 0,	/** P picture or P-VOP */
	OMX_VC_INTER_Q		= 1,	/** P picture or P-VOP */
	OMX_VC_INTER4V		= 2,	/** P picture or P-VOP */
	OMX_VC_INTRA		= 3,	/** I and P picture, I- and P-VOP */
	OMX_VC_INTRA_Q		= 4,	/** I and P picture, I- and P-VOP */
	OMX_VC_INTER4V_Q	= 5 	/** P picture or P-VOP (H.263)*/
						        /** 6-9 is reserved for future B-VOP use */
} OMXVCM4P2MacroblockType;

typedef enum {
	OMX_VC_M4P2_FAST_SEARCH			= 0,   /** Fast Motion Search */
	OMX_VC_M4P2_FULL_SEARCH			= 1    /** Full Motion Search */
} OMXVCM4P2MEMode;

typedef	struct {
    OMX_INT	x;
    OMX_INT	y;
} OMXVCM4P2Coordinate;

typedef struct {
    OMX_S32                     sliceId; 		       /* slice number */
    OMXVCM4P2MacroblockType     mbType;			       /* MB type */
    OMX_S32                     qp;				       /* quantization paramter */
    OMX_U32                     cbpy;			       /* CBP Luma */
    OMX_U32                     cbpc;			       /* CBP Chroma */
    OMXVCMotionVector           pMV0[2][2];            /* motion vector, represented
 						                                  using 1/2-pel units,
 						                                  pMV0[blocky][blockx]
                                       	                  (blocky = 0~1, blockx =0~1) */
    OMXVCMotionVector           pMVPred[2][2];         /* motion vector prediction,
							                              represented using 1/2-pel
 					                                      units, pMVPred[blocky][blockx]
                                     	                  (blocky = 0~1, blockx = 0~1) */
    OMX_U8						pPredDir[2][2];	       /* AC prediction direction, used to decide */
	                                                   /* the zigzag scan pattern */
} OMXVCM4P2MBInfo, *OMXVCM4P2MBInfoPtr;


/** =========================== Functions =========================== */
/** MPEG-4 common */
/**
 * Function: omxVCM4P2_FindMVpred
 *
 * Description:
 *
 * Predicts a motion vector for the current block using the procedure specified in
 * ISO/IEC 14496-3 subclause 7.6.5.  The resulting predicted MV is returned in pDstMVPred.
 * If the parameter pDstMVPredME if is not NULL then the set of three MV candidates used
 * for prediction is also returned, otherwise pDstMVPredME is NULL upon return.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcMVCurMB		pointer to the MV buffer associated with the current Y macroblock
 * [in]	pSrcCandMV1		pointer to the MV buffer containing the 4 MVs associated with the MB
 *                    located to the left of the current MB; set to NULL if there is no MB
 *                    to the left.
 * [in]	pSrcCandMV2		pointer to the MV buffer containing the 4 MVs associated with the MB
 *                    located above the current MB; set to NULL if there is no MB located
 *                    above the current MB.
 * [in]	pSrcCandMV3		pointer to the MV buffer containing the 4 MVs associated with the MB
 *                    located to the right and above the current MB; set to NULL if there
 *                    is no MB located to the above-right.
 * [in]	iBlk			    the index of block in current macroblock
 * [out]	pDstMVPred		pointer to the predicted motion vector
 * [in/out]	pDstMVPredME	[in] MV candidate return buffer;  if set to NULL then prediction candidate
 *                             MVs are not returned and pDstMVPredME will beNULL upon function return;
 *                             if pDstMVPredME is non-NULL then it must point to a buffer containing
 *                             sufficient space for three return MVs.
 *                        [out]non-NULL upon input then pDstMVPredME  points upon return to a buffer
 *                             containing the three motion vector candidates used for prediction as
 *                             specified in ISO/IEC 14496-2, subclause 7.6.5, otherwise if NULL upon
 *                             input then pDstMVPredME is NULL upon output.
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments;
 *              returned under any of the following conditions:
 *              -- the pointer pDstMVPred is NULL
 *              -- the parameter iBlk does not fall into the range 0 <= iBlk <=3
 *
 */

OMXResult omxVCM4P2_FindMVpred(
     const OMXVCMotionVector *pSrcMVCurMB,
     const OMXVCMotionVector *pSrcCandMV1,
     const OMXVCMotionVector *pSrcCandMV2,
     const OMXVCMotionVector *pSrcCandMV3,
     OMXVCMotionVector *pDstMVPred,
     OMXVCMotionVector *pDstMVPredME,
     OMX_INT iBlk
 );

 /**
 *
 *Function:  omxVCM4P2_IDCT8x8blk
 *Description:
 * Computes a 2D inverse DCT for a single 8x8 block, as defined in ISO/IEC 14496-2.
 *
 *Parameters:
 *[in] pSrc - pointer to the start of the linearly arranged IDCT input buffer;
 *             must be aligned on a 16 byte boundary.According to ISO/IEC 14496-2, the input coefficient values should lie within the range [-2048, 2047].
 *[out]pDst - pointer to the start of the linearly arranged IDCT output buffer;
 *             must be aligned on a 16 byte boundary.
 *
 *Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *   - Either pSrc or pDst is NULL.
 *   - Either pSrc or pDst is not 16 byte aligned.
 *
 */
OMXResult omxVCM4P2_IDCT8x8blk(const OMX_S16 *pSrc, OMX_S16 *pDst);


/** MPEG-4 encoder */
/**
 * Function: omxVCM4P2_MEGetBufSize
 *
 * Description:
 * Computes the size, in bytes, of the vendor-specific specification structure for
 * the following motion estimation functions:  BlockMatch_Integer_8x8, BlockMatch_Integer_16x6,
 * and MotionEstimateMB.
 *
 * Remarks:
 *
 * Parameters:
 * [in]  MEMode - motion estimation mode; available modes are defined by the enumerated type
 *                OMXVCM4P2MEMode
 * [in]	 pMEParams - motion estimation parameters
 * [out] pSize - pointer to the number of bytes required for the specification structure
 *
 * Return Value:
 *	OMX_StsNoErr - no error
 *	OMX_StsBadArgErr - one or more of the following is true:
 *     - an invalid value was specified for the parameter MEMode
 *     - a negative or zero value was specified for the parameter pMEParams->searchRange
 *
 */
 OMXResult omxVCM4P2_MEGetBufSize (
     OMXVCM4P2MEMode MEMode,
     const OMXVCM4P2MEParams *pMEParams,
     OMX_U32 *pSize);

/**
 * Function: omxVCM4P2_MEInit
 *
 * Description:
 * Initializes the vendor-specific specification structure required for the following motion
 * estimation functions:  BlockMatch_Integer_8x8, BlockMatch_Integer_16x6, and MotionEstimateMB.
 * Memory for the specification structure *pMESpec must be allocated prior to calling the function,
 * and should be aligned on a 4-byte boundary.  The number of bytes required for the specification
 * structure can be determined using the function omxVCM4P2_MEGetBufSize.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	MEMode - motion estimation mode; available modes are defined by the enumerated type
 *                OMXVCM4P2MEMode
 * [in] pMEParams - motion estimation parameters
 * [in/out]	pMESpec - [in]  pointer to the uninitialized ME specification structure
 *                     [out] to the initialized ME specification structure
 *
 * Return Value:
 *	OMX_StsNoErr - no error
 *	OMX_StsBadArgErr - one or more of the following is true:
 *     - an invalid value was specified for the parameter MEMode
 *     - a negative or zero value was specified for the parameter pMEParams->searchRange
 *
 */
 OMXResult omxVCM4P2_MEInit (
     OMXVCM4P2MEMode MEMode,
     const OMXVCM4P2MEParams *pMEParams,
     void *pMESpec);

/**
 * Function: omxVCM4P2_BlockMatch_Integer_16x16,
 *
 * Description:
 * Performs a 16x16 block search; estimates motion vector and associated minimum SAD.
 * Both the input and output motion vectors are represented using half-pixel units, and
 * therefore a shift left or right by 1 bit may be required, respectively, to match the
 * input or output MVs with other functions that either generate output MVs or expect
 * input MVs represented using integer pixel units.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcRefBuf		pointer to the reference Y plane; points to the reference MB that
 *                    corresponds to the location of the current macroblock in the current
 *                    plane.
 * [in]	refWidth		  width of the reference plane
 * [in]	pRefRect		  pointer to the valid rectangular in reference plane. Relative to image origin.
 *                    It's not limited to the image boundary, but depended on the padding. For example,
 *                    if you pad 4 pixels outside the image border, then the value for left border
 *                    can be -4
 * [in]	pSrcCurrBuf		pointer to the current macroblock extracted from original plane (linear array,
 *                    256 entries); must be aligned on an 16-byte boundary.
 * [in] pCurrPointPos	position of the current macroblock in the current plane
 * [in] pSrcPreMV		  pointer to predicted motion vector; NULL indicates no predicted MV
 * [in] pSrcPreSAD		 pointer to SAD associated with the predicted MV (referenced by pSrcPreMV); may be set to NULL if unavailable.
 * [in] pMESpec			  vendor-specific motion estimation specification structure; must have been allocated
 *                    and then initialized using omxVCM4P2_MEInit prior to calling the block matching
 *                    function.
 * [out]	pDstMV			pointer to estimated MV
 * [out]	pDstSAD			pointer to minimum SAD
 *
 * Return Value:
 * OMX_StsNoErr - no error.
 * OMX_StsBadArgErr - bad arguments
 *			-at least one of the following pointers is NULL: pSrcRefBuf, pRefRect, pSrcCurrBuff, pCurrPointPos, pSrcPreSAD, or pMESpec, or
 *          -pSrcCurrBuf is not 16-byte aligned
 *
 */

OMXResult omxVCM4P2_BlockMatch_Integer_16x16(
     const OMX_U8 *pSrcRefBuf,
     const OMX_INT refWidth,
     const OMXRect *pRefRect,
     const OMX_U8 *pSrcCurrBuf,
     const OMXVCM4P2Coordinate *pCurrPointPos,
     const OMXVCMotionVector *pSrcPreMV,
     const OMX_INT *pSrcPreSAD,
     void *pMESpec,
     OMXVCMotionVector *pDstMV,
     OMX_INT *pDstSAD
 );

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
 );



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
 );


/**
 * Function: omxVCM4P2_BlockMatch_Half_8x8
 *
 * Description:
 * Performs an 8x8 block match with half-pixel resolution.  Returns the estimated motion
 * vector and associated minimum SAD.  This function estimates the half-pixel motion
 * vector by interpolating the integer resolution motion vector referenced by the input
 * parameter pSrcDstMV, i.e., the initial integer MV is generated externally.  The input
 * parameters pSrcRefBuf and pSearchPointRefPos should be shifted by the winning MV of
 * 8x8 integer search prior to calling BlockMatch_Half_8x8. The function BlockMatch_Integer_8x8
 * may be used for integer motion estimation.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcRefBuf		    pointer to the reference Y plane; points to the reference macroblock that
 *                          corresponds to the location	of the current macroblock in the current
 *                          plane.
 * [in]	refWidth		    width of the reference plane
 * [in]	pRefRect		    reference plane valid region rectangle
 * [in] pSrcCurrBuf         pointer to current block in the current macroblock buffer extracted from
 *                          original plane (linear array, 128 entries); must be aligned on an 8-byte
 *                          boundary.  The step between lines of the 8x8 block is 16 bytes.
 * [in]	pSearchPointRefPos	position of the starting point for half pixel search (specified
 *                          in terms of integer pixel units) in the reference plane.
 * [in]	rndVal			    rounding control parameter: 0 - disabled; 1 - enabled. 
 * [in]	pSrcDstMV		    pointer to the initial MV estimate; typically generated during a prior
 *                          8X8 integer search and its unit is half pixel.
 * [out] pSrcDstMV			pointer to estimated MV
 * [out] pDstSAD			pointer to minimum SAD
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *
 */

OMXResult omxVCM4P2_BlockMatch_Half_8x8(
     const OMX_U8 *pSrcRefBuf,
     OMX_INT refWidth,
     const OMXRect *pRefRect,
     const OMX_U8 *pSrcCurrBuf,
     const OMXVCM4P2Coordinate *pSearchPointRefPos,
	 OMX_INT rndVal,     
     OMXVCMotionVector *pSrcDstMV,
     OMX_INT *pDstSAD
 );

/**
 * Function: omxVCM4P2_MotionEstimationMB
 *
 * Description:
 * Performs motion search for a 16x16 macroblock. Selects best motion search
 * strategy from among inter-1MV, inter-4MV, and intra modes. Supports integer
 * and half pixel resolution.
 *
 * Remarks:
 *
 * Parameters:
 * [in] pSrcCurrBuf     pointer to the current position in original picture plane; must be aligned on a 16-byte boundary.
 * [in] srcCurrStep     width of the original picture plane, in terms of full pixels; must be a multiple of 16.
 * [in] pSrcRefBuf      pointer to the reference Y plane; points to the reference plane location corresponding
 *                      to the location of the current macroblock in the current plane; must be aligned on a 16-byte boundary.
 * [in] srcRefStep      width of the reference picture plane, in terms of full pixels; must be a multiple of 16.
 * [in] pRefRect        reference plane valid region rectangle.
 * [in] pCurrPointPos   position of the current macroblock in the current plane
 * [in]	pMESpec         pointer to the vendor-specific motion estimation specification structure; must be allocated
 *                      and then initialized using omxVCM4P2_MEInit prior to calling this function.
 * [in] pSrcDstMBCurr   pointer to information structure for the current MB. The following entries should
 *                      be set prior to calling the function: sliceID - the number of the slice the to which the current MB belongs.
 * [in] pMBInter        array, of dimension four, containing pointers to information associated with four adjacent type INTER MBs
 *                      (Left, Top, Top-Left, Top-Right).  Any pointer in the array may be set equal to NULL if the 
 *                      corresponding MB doesn't exist or is not of type INTER.  The structure elements cbpy and cbpc 
 *                      are ignored.
 *                           -	pMBInter[0] - pointer to left MB information
 *                           -	pMBInter[1] - pointer to top MB information
 *                           -	pMBInter[2] - pointer to top-left MB information 
 *                           -	pMBInter[3] - pointer to top-right MB information. 
 *
 * [in] pMBIntra        array, of dimension four, containing pointers to information associated with four adjacent type INTRA MBs 
 *                      (Left, Top, Top-Left, Top-Right).  Any pointer in the array may be set equal to NULL if the
 *                      corresponding MB doesn't exist or is not of type INTRA.  The structure elements cbpy and cbpc
 *                      are ignored.
 *                           -	pMBIntra[0] - pointer to left MB information
 *                           -	pMBIntra[1] - pointer to top MB information
 *                           -	pMBIntra[2] - pointer to top-left MB information 
 *                           -	pMBIntra[3] - pointer to top-right MB information 
 *
 * [in] pSrcDstMBCurr   pointer to information structure for the current MB.  The following entries should be set prior 
 *                      to calling the function:  sliceID - the number of the slice the to which the current 
 *                      MB belongs.  The structure elements cbpy and cbpc are ignored.
 * [out] pSrcDstMBCurr  pointer to updated information structure for the current MB after MB-level motion estimation has been
 *                      completed.  The following structure members are updated by the ME function: 
 *                           -	mbType          -   macroblock type: OMX_VC_INTRA, OMX_VC_INTER, or OMX_VC_INTER4V. 
 *                           -	pMV0[2][2] 	    - 	estimated motion vectors; represented in terms of ½-pel units.
 *                           -	pMVPred[2][2]	-	predicted motion vectors; represented in terms of ½-pel units.
 *                      The structure members cbpy and cbpc are not updated by the function.
 * [out] pDstSAD        pointer to the minimum SAD for INTER1V, or sum of minimum SADs for INTER4V
 *
 * Return Value:
 * OMX_StsNoErr     - no error
 * OMX_StsBadArgErr - bad arguments:  returned if one or more of the following pointers is NULL: pSrcCurrBuf, 
 *                                    pSrcRefBuf, pRefRect, pCurrPointPos, pMBInter, pMBIntra, pSrcDstMBCurr,
 *                                    or pDstSAD.
 */

OMXResult omxVCM4P2_MotionEstimationMB (
			 const OMX_U8 *pSrcCurrBuf,
			 OMX_U32      srcCurrStep, 
			 const OMX_U8 *pSrcRefBuf, 
			 OMX_INT      srcRefStep, 
			 const OMXRect *pRefRect, 
			 const OMXVCM4P2Coordinate *pCurrPointPos, 
			 void  *pMESpec,
			 const OMXVCM4P2MBInfoPtr *pMBInter, 
			 const OMXVCM4P2MBInfoPtr *pMBIntra,
			 OMXVCM4P2MBInfoPtr pSrcDstMBCurr,
			 OMX_INT *pDstSAD);


/**
 *
 *Function:  omxVCM4P2_DCT8x8blk
 *Description: Computes a 2D forward DCT for a single 8x8 block, as defined in ISO/IEC 14496-2
 *
 *Parameters:
 *[in] pSrc - pointer to the start of the linearly arranged input buffer; must be aligned
 *             on a 16 byte boundary.Input values (pixel intensities) are valid in the range [-255,255].
 *[out]pDst - pointer to the start of the linearly arranged output buffer; must be aligned
 *             on a 16 byte boundary.
 *
 *Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *   -	Either pSrc or pDst is NULL.
 *   -	Either pSrc or pDst is not 16 byte aligned.
 *
 */

OMXResult omxVCM4P2_DCT8x8blk(const OMX_S16 *pSrc, OMX_S16 *pDst);



/**
 * Function: omxVCM4P2_QuantIntra_I
 *
 * Description:
 * Performs quantization on an intra block coefficients. This function supports
 * bits_per_pixel == 8.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcDst		pointer to the input intra block coefficients. Must be 16-byte aligned.
 * [in]	QP			quantization parameter (quantiser_scale).
 * [in]	blockIndex	block index indicating the component type and position as defined in subclause 6.1.3.8, of ISO/IEC 14496 2, valid in the range 0 to 5.
 * [in] shortVideoHeader    binary flag indicating presence of short_video_header;
 *                           shortVideoHeader==1 selects linear intra DC mode,
 *							and shortVideoHeader==0 selects nonlinear intra DC mode.
 * [out]	pSrcDst		pointer to the output (quantized) interblock coefficients. When
 *                          shortVideoHeader==1, AC coefficients are saturated on the interval [-127, 127], and DC
 *                          coefficients are saturated on the interval [1, 254]. When shortVideoHeader==0, AC coefficients
 *                          are saturated on the interval [-2047, 2047].
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    -pSrcDst is NULL or is not 16-byte aligned.
 *    -blockIndex < 0 or blockIndex >= 10
 *    -QP <= 0 or QP >= 32.
 *
 */

OMXResult omxVCM4P2_QuantIntra_I(
     OMX_S16 *pSrcDst,
     OMX_U8 QP,
     OMX_INT blockIndex,
	 OMX_INT shortVideoHeader
 );



/**
 * Function: omxVCM4P2_QuantInter_I
 *
 * Description:
 * Performs quantization on an inter block coefficients. This function supports
 * bits_per_pixel == 8.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcDst		pointer to the input inter block coefficients. Must be 16-byte aligned.
 * [in]	QP			quantization parameter (quantizer_scale)
 * [in] shortVideoHeader    a flag indicating presence of short_video_header;
 *                           shortVideoHeader==1 selects linear intra DC mode,
 *							and shortVideoHeader==0 selects nonlinear intra DC mode.
 * [out]	pSrcDst		pointer to the output (quantized) inter block
 *							coefficients. When shortVideoHeader==1, AC coefficients are saturated on the interval [-127, 127], and DC
 *                          coefficients are saturated on the interval [1, 254]. When shortVideoHeader==0, AC coefficients
 *                          are saturated on the interval [-2047, 2047].
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - pSrcDst is NULL or is not 16-byte aligned.
 *    - QP <= 0 or QP >= 32.
 *
 */

OMXResult omxVCM4P2_QuantInter_I(
     OMX_S16 *pSrcDst,
     OMX_U8 QP,
	 OMX_INT shortVideoHeader
	 );

/**
 * Function: omxVCM4P2_TransRecBlockCoef_intra
 *
 * Description:
 * Quantizes the DCT coefficients, implements intra block AC/DC coefficient prediction,
 * and reconstructs the current intra block texture for prediction on the next frame.
 * Quantized row and column coefficients are returned in the updated coefficient buffers.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrc		pointer to the pixels of current intra block. Must be 8-byte aligned.
 * [in]	pPredBufRow	pointer to the coefficient row buffer containing ((num_mb_per_row * 2 + 1) * 8)
 *                  elements of type OMX_S16.  Coefficients are organized into blocks of eight as
 *                  described below (Internal Prediction Coefficient Update Procedures).  The DC
 *                  coefficient is first, and the remaining buffer locations contain the quantized
 *                  AC coefficients. Each group of eight row buffer elements combined with eight
 *                  elements ahead contains the coefficient predictors of the neighboring block that
 *                  is spatially above or to the left of the block currently to be decoded.
 *                  A negative-valued DC coefficient indicates that this neighboring block is not
 *                  INTRA coded or out of bounds, and therefore the AC and DC coefficients are invalid.
 * [in]	pPredBufCol	pointer to the prediction coefficient column buffer containing 16 elements of type
 *                  OMX_S16.  Coefficients are organized as described below (Internal and External
 *                  Prediction Coefficient Update Procedures).
 * [in]	pSumErr		  flag indicating whether or not AC/DC prediction is required; a negative value
 *                  disables prediction.
 * [in]	blockIndex	block index indicating the component type and position as defined in subclause
 *                  6.1.3.8, of ISO/IEC 14496-2. 
 * [in]	curQp		 quantization parameter of the macroblock which the current block belongs
 * [in]	pQpBuf		 Pointer to a 2-element QP array. pQpBuf[0] holds the QP of the 8x8 block left to
 *                   the current block(QPa). pQpBuf[1] holds the QP of the 8x8 block just above the
 *                   current block(QPc).
 *                   Note, in case the corresponding block is out of VOP bound, the QP value will have
 *                   no effect to the intra-prediction process. Refer to subclause  "7.4.3.3 Adaptive
 *                   ac coefficient prediction" of ISO/IEC 14496-2(MPEG4 Part2) for accurate description.
 * [in]	srcStep		  width of the source buffer. Must be multiple of 8.
 * [in]	dstStep		  width of the reconstructed destination buffer. Must be multiple of 8.
 * [in] shortVideoHeader    a flag indicating presence of short_video_header;
 *                           shortVideoHeader==1 selects linear intra DC mode,
 *							and shortVideoHeader==0 selects nonlinear intra DC mode.
 * [out]	pDst			pointer to the quantized DCT coefficient buffer; pDst[0] contains the predicted DC
 *                          coefficient; the remaining entries contain the quantized AC coefficients (without prediction). The
 *                          pointer pDst must be aligned on a 16-byte boundary.
 * [out]	pRec			pointer to the reconstructed texture. Must be 8-byte aligned.
 * [out]	pPredBufRow		pointer to the updated coefficient row buffer
 * [out]	pPredBufCol		pointer to the updated coefficient column buffer
 * [out]	pPreACPredict	if prediction is enabled, the parameter points to the start of the buffer containing
 *                          the coefficient differences for VLC encoding. The entry pPreACPredict[0]indicates prediction
 *                          direction for the current block and takes one of the following values: OMX_VC_NONE (prediction
 *                          disabled), OMX_VC_HORIZONTAL, or OMX_VC_VERTICAL. The entries
 *                          pPreACPredict[1]- pPreACPredict[7]contain predicted AC coefficients. If prediction is
 *                          disabled (*pSumErr<0) then the contents of this buffer are undefined upon return from the function
 * [out]	pSumErr			pointer to the updated sum of the absolute differences between predicted and
 *                    unpredicted coefficients
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - Bad arguments
 *   -	At least one of the following pointers is NULL: pSrc, pDst, pRec, pCoefBufRow, pCoefBufCol,
 *                                                      pQpBuf, pPreACPredict, pSumErr.
 *   -	BlockIndex < 0 or blockIndex >= 10; curQP <= 0 or curQP >= 32.
 *   -	SrcStep, dstStep <= 0 or not a multiple of 8.
 *   -	At least one of the following pointers is not 64-bit aligned: pSrc, pDst, pRec.
 *
 */

OMXResult omxVCM4P2_TransRecBlockCoef_intra(
     const OMX_U8 *pSrc,
     OMX_S16 *pDst,
     OMX_U8 *pRec,
     OMX_S16 *pPredBufRow,
     OMX_S16 *pPredBufCol,
     OMX_S16 *pPreACPredict,
     OMX_INT *pSumErr,
     OMX_INT blockIndex,
     OMX_U8 curQp,
     const OMX_U8 *pQpBuf,
     OMX_INT srcStep,
     OMX_INT dstStep,
	 OMX_INT shortVideoHeader
	);

 /**
 * Function: omxVCM4P2_TransRecBlockCoef_inter
 *
 * Description:
 * Implements DCT, and quantizes the DCT coefficients of the inter block while
 * reconstructing the texture residual. There is no boundary check for the bit
 * stream buffer.
 *
 * Remarks:
 *
 *
 * Parameters:
 * [in]	pSrc		pointer to the residuals to be encoded; must be aligned on a 16-byte boundary.
 * [in]	QP			quantization parameter.
 * [in] shortVideoHeader    a flag indicating presence of short_video_header;
 *                           shortVideoHeader==1 indicates using quantization method defined in short
 *                           video header mode, and shortVideoHeader==0 indicates normal quantization method.
 * [out]	pDst		pointer to the quantized DCT coefficients buffer. Must be 16-byte aligned.
 * [out]	pRec		pointer to the reconstructed texture residuals. Must be 16-byte aligned.
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *   -At least one of the following pointers is NULL or is not 64-bit aligned: pSrc, pDst, pRec.
 *   -QP <= 0 or QP >= 32.
 *
 */

OMXResult omxVCM4P2_TransRecBlockCoef_inter(
     OMX_S16 *pSrc,
     OMX_S16 *pDst,
     OMX_S16 *pRec,
     OMX_U8 QP,
     OMX_INT shortVideoHeader
 );
/**
 * Function: omxVCM4P2_EncodeVLCZigzag_IntraDCVLC; omxVCM4P2_EncodeVLCZigzag_IntraACVLC
 *
 * Description:
 * Performs zigzag scan and VLC encoding of AC and DC coefficients for one intra block.  Two
 * versions of the function (DCVLC and ACVLC) are provided in order to support the two different
 * methods of processing DC coefficients, as described in ISO/IEC 14496-2, subclause 7.4.1.4,
 * "Intra DC Coefficient Decoding for the Case of Switched VLC Encoding."
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppBitStream		pointer to the pointer to the current byte in the bit stream
 * [in]	pBitOffset		pointer to the bit position in the byte pointed by *ppBitStream.
 *                    Valid within 0 to 7.
 * [in]	pQDctBlkCoef	pointer to the quantized DCT coefficient. Must be 16-byte aligned.
 * [in]	predDir			  AC prediction direction, which is used to decide the zigzag scan pattern.
 *                    This takes one of the following values:
 *								      OMX_VC_NONE			  AC prediction not used. Performs classical zigzag scan.
 *								      OMX_VC_HORIZONTAL	Horizontal prediction. Performs alternate-vertical zigzag scan.
 *								      OMX_VC_VERTICAL		Vertical prediction. Performs alternate-horizontal zigzag scan.
 * [in]	pattern			block pattern which is used to decide whether
 *								this block is encoded
 * [in]	videoComp		video component type (luminance, chrominance) of
 *								the current block
 * [in] shortVideoHeader binary flag indicating presence of short_video_header; escape modes 0-3 are used if shortVideoHeader==0,
 *                       and escape mode 4 is used when shortVideoHeader==1.
 * [out]	ppBitStream		*ppBitStream is updated after the block is encoded,
 *								so that it points to the current byte in the bit
 *								stream buffer.
 * [out]	pBitOffset		*pBitOffset is updated so that it points to the
 *								current bit position in the byte pointed by
 *								*ppBitStream.
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - Bad arguments
 *   -At least one of the following pointers is NULL: ppBitStream, *ppBitStream, pBitOffset, pQDctBlkCoef.
 *   -*pBitOffset < 0, or *pBitOffset >7.
 *   -PredDir is not one of: OMX_VC_NONE, OMX_VC_HORIZONTAL, or OMX_VC_VERTICAL.
 *   -VideoComp is not one component of enum OMXVCM4P2VideoComponent.
 *
 */

OMXResult omxVCM4P2_EncodeVLCZigzag_IntraDCVLC(
     OMX_U8 **ppBitStream,
     OMX_INT *pBitOffset,
     const OMX_S16 *pQDctBlkCoef,
     OMX_U8 predDir,
     OMX_U8 pattern,
	 OMX_INT shortVideoHeader,
     OMXVCM4P2VideoComponent videoComp
 );

OMXResult omxVCM4P2_EncodeVLCZigzag_IntraACVLC(
     OMX_U8 **ppBitStream,
     OMX_INT *pBitOffset,
     const OMX_S16 *pQDctBlkCoef,
     OMX_U8 predDir,
     OMX_U8 pattern,
 	 OMX_INT shortVideoHeader
 );



/**
 * Function: omxVCM4P2_EncodeVLCZigzag_Inter
 *
 * Description:
 * Performs classical zigzag scanning and VLC encoding for one inter block.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppBitStream		pointer to the pointer to the current byte in
 *								the bit stream
 * [in]	pBitOffset		pointer to the bit position in the byte pointed
 *								by *ppBitStream. Valid within 0 to 7
 * [in]	pQDctBlkCoef	pointer to the quantized DCT coefficient. Must be 16-byte aligned.
 * [in]	pattern			block pattern which is used to decide whether
 *								this block is encoded
 * [in] shortVideoHeader binary flag indicating presence of short_video_header; escape modes 0-3 are used if shortVideoHeader==0,
 *                           and escape mode 4 is used when shortVideoHeader==1.
 * [out]	ppBitStream		*ppBitStream is updated after the block is encoded
 *								so that it points to the current byte in the bit
 *								stream buffer.
 * [out]	pBitOffset		*pBitOffset is updated so that it points to the
 *								current bit position in the byte pointed by
 *								*ppBitStream.
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - Bad arguments
 *   -At least one of the pointers: is NULL: ppBitStream, *ppBitStream, pBitOffset, pQDctBlkCoef
 *   -*pBitOffset < 0, or *pBitOffset >7.
 *
 */
OMXResult omxVCM4P2_EncodeVLCZigzag_Inter(
     OMX_U8 **ppBitStream,
     OMX_INT *pBitOffset,
     const OMX_S16 *pQDctBlkCoef,
     OMX_U8 pattern,
	 OMX_INT shortVideoHeader
 );

/**
 * Function: omxVCM4P2_PredictReconCoefIntra
 *
 * Description:
 * Performs adaptive DC/AC coefficient prediction for an intra block. Prior
 * to the function call, prediction direction (predDir) should be selected
 * as specified in subclause 7.4.3.1 of ISO/IEC 14496-2.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcDst		pointer to the coefficient buffer which contains
 *					the quantized coefficient residuals (PQF) of the
 *					current block. Must be 16-byte aligned
 * [in]	pPredBufRow	pointer to the coefficient row buffer
 * [in]	pPredBufCol	pointer to the coefficient column buffer
 * [in]	curQP		quantization parameter of the current block. curQP
 *							may equal to predQP especially when the current
 *							block and the predictor block are in the same
 *							macroblock.
 * [in]	predQP		quantization parameter of the predictor block
 * [in]	predDir		indicates the prediction direction which takes one
 *							of the following values:
 *							OMX_VIDEO_HORIZONTAL	predict horizontally
 *							OMX_VIDEO_VERTICAL		predict vertically
 * [in]	ACPredFlag	a flag indicating if AC prediction should be
 *							performed. It is equal to ac_pred_flag in the bit
 *							stream syntax of MPEG-4
 * [in]	videoComp	video component type (luminance, chrominance or
 *							alpha) of the current block
 * [out]	pSrcDst		pointer to the coefficient buffer which contains
 *							the quantized coefficients (QF) of the current
 *							block
 * [out]	pPredBufRow	pointer to the updated coefficient row buffer
 * [out]	pPredBufCol	pointer to the updated coefficient column buffer
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxVCM4P2_PredictReconCoefIntra(
     OMX_S16 *pSrcDst,
     OMX_S16 *pPredBufRow,
     OMX_S16 *pPredBufCol,
     OMX_INT curQP,
     OMX_INT predQP,
     OMX_U8  predDir,
     OMX_INT ACPredFlag,
     OMXVCM4P2VideoComponent videoComp
 );

/**
 * Function: omxVCM4P2_EncodeMV
 *
 * Description:
 * Predicts a motion vector for the current macroblock, encodes the difference, and writes
 * the output to the stream buffer.  The input MVs pMVCurMB, pSrcMVLeftMB, pSrcMVUpperMB,
 * and pSrcMVUpperRightMB should lie within the ranges associated with the input parameter
 * fcodeForward, as described in ISO/IEC 14496-2, subclause 7.6.3.  This function provides
 * a superset of the functionality associated with the function omxVCM4P2_FindMVpred.
 *
 * Remarks:
 *
 *
 * Parameters:
 * [in]	ppBitStream		pointer to the pointer to the current byte in
 *								the bit stream buffer
 * [in]	pBitOffset		pointer to the bit position in the byte pointed
 *								by *ppBitStream. Valid within 0 to 7.
 * [in]	pMVCurMB		pointer to the current macroblock motion vector
 * [in]	pSrcMVLeftMB	pointer to the source left macroblock motion vector
 * [in]	pSrcMVUpperMB	pointer to source upper macroblock motion vector
 * [in]	pSrcMVUpperRightMB	pointer to source upper right MB motion vector
 * [in]	fcodeForward	an integer with values from 1 to 7. This is used
 *								in encoding motion vectors related to search range.
 * [in]	MBType			macro block type, taking values from 0 to 5
 * [out]	ppBitStream		pointer to the pointer to the current byte in the
 *								bit stream buffer
 * [out]	pBitOffset		pointer to the bit position in the byte pointed
 *								by *ppBitStream
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr -bad arguments
 * At least one of the following pointers is NULL: ppBitStream, *ppBitStream,
 *       pBitOffset, pMVCurMB, pTranspLeftMB, pTranspUpperMB,
         pTransUpperRightMB, pTranspCurMB.
 * pBitOffset < 0, or *pBitOffset >7.
 * fcodeForward <= 0, or fcodeForward > 7, or MBType < 0
 *
 */

OMXResult omxVCM4P2_EncodeMV(
     OMX_U8 **ppBitStream,
     OMX_INT *pBitOffset,
     const OMXVCMotionVector *pMVCurMB,
     const OMXVCMotionVector *pSrcMVLeftMB,
     const OMXVCMotionVector *pSrcMVUpperMB,
     const OMXVCMotionVector *pSrcMVUpperRightMB,
     OMX_INT fcodeForward,
     OMXVCM4P2MacroblockType MBType
 );

/** MPEG-4 decoder */


/**
 * Function: omxVCM4P2_DecodePadMV_PVOP
 *
 * Description:
 * Decodes and pads four motion vectors of the non-intra macroblock in P-VOP.
 * The motion vector padding process is specified in subclause 7.6.1.6 of
 * ISO/IEC 14496-2.
 *
 * Remarks:
 *
 *
 * Parameters:
 * [in]	ppBitStream		pointer to the pointer to the current byte in
 *								the bit stream buffer
 * [in]	pBitOffset		pointer to the bit position in the byte pointed
 *								to by *ppBitStream. *pBitOffset is valid within
 *								[0-7].
 * [in]	pSrcMVLeftMB    pointers to the motion vector buffers of the
 *								macroblocks specially at the left side of the current macroblock
 *								respectively.
 * [in]	pSrcMVUpperMB   pointers to the motion vector buffers of the
 *								macroblocks specially at the upper side of the current macroblock
 *								respectively.
 * [in]	pSrcMVUpperRightMB	pointers to the motion vector buffers of the
 *								macroblocks specially at the upper-right side of the current macroblock
 *								respectively.
 * [in]	fcodeForward	a code equal to vop_fcode_forward in MPEG-4
 *								bit stream syntax
 * [in]	MBType			the type of the current macroblock. If MBType
 *								is not equal to OMX_VC_INTER4V, the destination
 *								motion vector buffer is still filled with the
 *								same decoded vector.
 * [out]	ppBitStream		*ppBitStream is updated after the block is decoded,
 *								so that it points to the current byte in the bit
 *								stream buffer
 * [out]	pBitOffset		*pBitOffset is updated so that it points to the
 *								current bit position in the byte pointed by
 *								*ppBitStream
 * [out]	pDstMVCurMB		pointer to the motion vector buffer of the current
 *								macroblock which contains four decoded motion vectors
 *
 * Return Value:
 * OMX_StsNoErr -no error
 * OMX_StsBadArgErr - bad arguments
 *      -At least one of the following pointers is NULL: ppBitStream, *ppBitStream,
 *                           pBitOffset, pTranspLeftMB, pTranspUpperMB, pTranspUpperRight,
 *                           pTranspCurMB, pDstMVCurMB
 *          or
 *      -	At least one of following cases is true: *pBitOffset exceeds [0,7], fcodeForward
 *          exceeds (0,7], MBType less than zero, transparent status or the motion vector buffer
 *          is not 32-bit aligned.
 * OMX_StsErr - status error
 *
 */

OMXResult omxVCM4P2_DecodePadMV_PVOP(
     const OMX_U8 **ppBitStream,
     OMX_INT *pBitOffset,
     OMXVCMotionVector *pSrcMVLeftMB,
     OMXVCMotionVector *pSrcMVUpperMB,
     OMXVCMotionVector *pSrcMVUpperRightMB,
     OMXVCMotionVector *pDstMVCurMB,
     OMX_INT fcodeForward,
     OMXVCM4P2MacroblockType MBType
 );


/**
 * Function: omxVCM4P2_DecodeVLCZigzag_IntraDCVLC; omxVCM4P2_DecodeVLCZigzag_IntraACVLC
 *
 * Description:
 * Performs VLC decoding and inverse zigzag scan of AC and DC coefficients for one intra block.
 * Two versions of the function (DCVLC and ACVLC) are provided in order to support the two
 * different methods of processing DC coefficients, as described in ISO/IEC 14496-2, subclause
 * 7.4.1.4, "Intra DC Coefficient Decoding for the Case of Switched VLC Encoding."
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppBitStream		pointer to the pointer to the current byte in the bitstream buffer
 * [in]	pBitOffset		pointer to the bit position in the byte pointed to by *ppBitStream.
 *                    *pBitOffset is valid within [0-7].
 * [in]	predDir			AC prediction direction which is used to decide	the zigzag scan pattern.
 *                  It takes one of the	following values:
 *								   OMX_VC_NONE	AC prediction not used;	perform classical zigzag scan;
 *								   OMX_VC_HORIZONTAL	Horizontal prediction; perform alternate-vertical	zigzag scan;
 *								   OMX_VC_VERTICAL		Vertical prediction; perform alternate-horizontal zigzag scan.
 * [in] shortVideoHeader  binary flag indicating presence of short_video_header; escape modes 0-3 are used if shortVideoHeader==0,
 *                          and escape mode 4 is used when shortVideoHeader==1.
 * [in]	videoComp		video component type (luminance, chrominance or alpha) of the current block
 * [out]	ppBitStream		*ppBitStream is updated after the block is decoded, so that it points
 *                      to the current byte in the bit stream buffer
 * [out]	pBitOffset		*pBitOffset is updated so that it points to the current bit position in
 *                      the byte pointed by *ppBitStream
 * [out]	pDst			pointer to the coefficient buffer of current block. Must be 4-byte aligned
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *   - At least one of the following pointers is NULL: ppBitStream, *ppBitStream, pBitOffset, pDst, or
 *   - At least one of the following conditions is true: *pBitOffset exceeds [0,7], preDir exceeds [0,2], or
 *   - pDst is not 16-byte aligned
 * OMX_StsErr
 *   - In DecodeVLCZigzag_IntraDCVLC_S16, dc_size > 12
 *   - At least one of mark bits equals zero
 *   - Illegal stream encountered; code cannot be located in VLC table
 *   - Forbidden code encountered in the VLC FLC table
 *   - The number of coefficients is greater than 64
 *
 */

OMXResult omxVCM4P2_DecodeVLCZigzag_IntraDCVLC(
     const OMX_U8 **ppBitStream,
     OMX_INT *pBitOffset,
     OMX_S16 *pDst,
     OMX_U8 predDir,
	 OMX_INT shortVideoHeader,
     OMXVCM4P2VideoComponent videoComp
 );



OMXResult omxVCM4P2_DecodeVLCZigzag_IntraACVLC(
     const OMX_U8 **ppBitStream,
     OMX_INT *pBitOffset,
     OMX_S16 *pDst,
     OMX_U8 predDir,
	 OMX_INT shortVideoHeader
 );



/**
 * Function: omxVCM4P2_DecodeVLCZigzag_Inter
 *
 * Description:
 * Performs VLC decoding and inverse zigzag scan for one intra coded block.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppBitStream		pointer to the pointer to the current byte in
 *								the bitstream buffer
 * [in]	pBitOffset		pointer to the bit position in the byte pointed
 *								to by *ppBitStream. *pBitOffset is valid within
 *								[0-7].
 * [in] shortVideoHeader  binary flag indicating presence of short_video_header;
 *                          escape modes 0-3 are used if shortVideoHeader==0, and escape mode 4 is used when shortVideoHeader==1.
 * [out]	ppBitStream		*ppBitStream is updated after the block is
 *								decoded, so that it points to the current byte
 *								in the bit stream buffer
 * [out]	pBitOffset		*pBitOffset is updated so that it points to the
 *								current bit position in the byte pointed by
 *								*ppBitStream
 * [out]	pDst			pointer to the coefficient buffer of current
 *								block. Must be 16-byte aligned
 *
 * Return Value:
 * OMX_StsBadArgErr - bad arguments
 *   -At least one of the following pointers is NULL: ppBitStream, *ppBitStream, pBitOffset, pDst, or
 *   -pDst is not 16-byte aligned, or
 *   -*pBitOffset exceeds [0,7].
 * OMX_StsErr - status error
 *   -At least one mark bit is equal to zero
 *   -Encountered an illegal stream code that cannot be found in the VLC table
 *   -Encountered and illegal code in the VLC FLC table
 *   -The number of coefficients is greater than 64
 *
 */

OMXResult omxVCM4P2_DecodeVLCZigzag_Inter(
     const OMX_U8 **ppBitStream,
     OMX_INT *pBitOffset,
     OMX_S16 *pDst,
	 OMX_INT shortVideoHeader
 );



/**
 * Function: omxVCM4P2_QuantInvIntra_I;omxVCM4P2_QuantInvInter_I
 *
 * Description:
 * Performs inverse quantization on intra/inter coded block.
 * This function supports bits_per_pixel = 8. Mismatch control
 * is performed for the first MPEG-4 mode inverse quantization method.
 * The output coefficients are clipped to the range: [-2048, 2047].
 * Mismatch control is performed for the first inverse quantization method.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcDst		pointer to the input (quantized) intra/inter block. Must be 16-byte aligned.
 * [in]	QP			quantization parameter (quantiser_scale)
 * [in]	videoComp	(Intra version only.) Video component type of the
 *							current block. Takes one of the following flags:
 *							OMX_VC_LUMINANCE, OMX_VC_CHROMINANCE,
 *							OMX_VC_ALPHA.
 * [in] shortVideoHeader    a flag indicating presence of short_video_header;
 *                           shortVideoHeader==1 selects linear intra DC mode,
 *							and shortVideoHeader==0 selects nonlinear intra DC mode.
 * [out]	pSrcDst		pointer to the output (dequantized) intra/inter block.  Must be 16-byte aligned.
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    -	If pSrcDst is NULL or is not 16-byte aligned.
 *      or
 *    - If QP <= 0.
 *      or
 *    - videoComp is none of OMX_VC_LUMINANCE, OMX_VC_CHROMINANCE and OMX_VC_ALPHA.
 *
 */

OMXResult omxVCM4P2_QuantInvIntra_I(
     OMX_S16 *pSrcDst,
     OMX_INT QP,
     OMXVCM4P2VideoComponent videoComp,
	 OMX_INT shortVideoHeader
);

OMXResult omxVCM4P2_QuantInvInter_I(
     OMX_S16 *pSrcDst,
     OMX_INT QP,
	 OMX_INT shortVideoHeader
);



/**
 * Function: omxVCM4P2_DecodeBlockCoef_Intra
 *
 * Description:
 * Decodes the INTRA block coefficients. Inverse quantization, inversely zigzag
 * positioning, and IDCT, with appropriate clipping on each step, are performed
 * on the coefficients. The results are then placed in the output frame/plane on
 * a pixel basis. For INTRA block, the output values are clipped to [0, 255] and
 * written to corresponding block buffer within the destination plane.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppBitStream		pointer to the pointer to the current byte in
 *								the bit stream buffer. There is no boundary
 *								check for the bit stream buffer.
 * [in]	pBitOffset		pointer to the bit position in the byte pointed
 *								to by *ppBitStream. *pBitOffset is valid within
 *								[0-7].
 * [in]	step			width of the destination plane
 * [in/out]	pCoefBufRow		[in]  pointer to the coefficient row buffer
 *                        [out] updated coefficient rwo buffer
 * [in/out]	pCoefBufCol		[in]  pointer to the coefficient column buffer
 *                        [out] updated coefficient column buffer
 * [in]	curQP			quantization parameter of the macroblock which
 *								the current block belongs to
 * [in]	pQpBuf		 Pointer to a 2-element QP array. pQpBuf[0] holds the QP of the 8x8 block left to
 *                   the current block(QPa). pQpBuf[1] holds the QP of the 8x8 block just above the
 *                   current block(QPc).
 *                   Note, in case the corresponding block is out of VOP bound, the QP value will have
 *                   no effect to the intra-prediction process. Refer to subclause  "7.4.3.3 Adaptive
 *                   ac coefficient prediction" of ISO/IEC 14496-2(MPEG4 Part2) for accurate description.
 * [in]	blockIndex		block index indicating the component type and
 *								position as defined in subclause 6.1.3.8,
 *								Figure 6-5 of ISO/IEC 14496-2. 
 * [in]	intraDCVLC		a code determined by intra_dc_vlc_thr and QP.
 *								This allows a mechanism to switch between two VLC
 *								for coding of Intra DC coefficients as per Table
 *								6-21 of ISO/IEC 14496-2. 
 * [in]	ACPredFlag		a flag equal to ac_pred_flag (of luminance) indicating
 *								if the ac coefficients of the first row or first
 *								column are differentially coded for intra coded
 *								macroblock.
 * [in] shortVideoHeader    a flag indicating presence of short_video_header;
 *                           shortVideoHeader==1 selects linear intra DC mode,
 *							and shortVideoHeader==0 selects nonlinear intra DC mode.
 * [out]	ppBitStream		*ppBitStream is updated after the block is
 *								decoded, so that it points to the current byte
 *								in the bit stream buffer
 * [out]	pBitOffset		*pBitOffset is updated so that it points to the
 *								current bit position in the byte pointed by
 *								*ppBitStream
 * [out]	pDst			pointer to the block in the destination plane.
 *								pDst should be 16-byte aligned.
 * [out]	pCoefBufRow		pointer to the updated coefficient row buffer.
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *   -	At least one of the following pointers is NULL: ppBitStream, *ppBitStream, pBitOffset,
 *                                                      pCoefBufRow, pCoefBufCol, pQPBuf, pDst.
 *      or
 *   -  At least one of the below case: *pBitOffset exceeds [0,7], curQP exceeds (1, 31),
 *      blockIndex exceeds [0,9], step is not the multiple of 8, intraDCVLC is zero while
 *      blockIndex greater than 5.
 *      or
 *   -	pDst is not 16-byte aligned
 * OMX_StsErr - status error
 *
 */

OMXResult omxVCM4P2_DecodeBlockCoef_Intra(
     const OMX_U8 **ppBitStream,
     OMX_INT *pBitOffset,
     OMX_U8 *pDst,
     OMX_INT step,
     OMX_S16 *pCoefBufRow,
     OMX_S16 *pCoefBufCol,
     OMX_U8 curQP,
     const OMX_U8 *pQPBuf,
     OMX_INT blockIndex,
     OMX_INT intraDCVLC,
     OMX_INT ACPredFlag,
	 OMX_INT shortVideoHeader
 );


/**
 * Function: omxVCM4P2_DecodeBlockCoef_Inter
 *
 * Description:
 * Decodes the INTER block coefficients. Inverse quantization, inversely zigzag
 * positioning and IDCT, with appropriate clipping on each step, are performed
 * on the coefficients. The results (residuals) are placed in a contiguous array
 * of 64 elements. For INTER block, the output buffer holds the residuals for
 * further reconstruction.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppBitStream		pointer to the pointer to the current byte in
 *								the bit stream buffer. There is no boundary
 *								check for the bit stream buffer.
 * [in]	pBitOffset		pointer to the bit position in the byte pointed
 *								to by *ppBitStream. *pBitOffset is valid within
 *								[0-7]
 * [in]	QP				quantization parameter
 * [in] shortVideoHeader    a flag indicating presence of short_video_header;
 *                           shortVideoHeader==1 indicates using quantization method defined in short
 *                           video header mode, and shortVideoHeader==0 indicates normail quantization method.
 * [out] ppBitStream 	*ppBitStream is updated after the block is decoded, so that it points to the
 *                      current byte in the bit stream buffer.
 * [out] pBitOffset		*pBitOffset is updated so that it points to the current bit position in the
 *                      byte pointed by *ppBitStream
 * [out] pDst			pointer to the decoded residual buffer (a contiguous array of 64 elements of
 *                      OMX_S16 data type). Must be 16-byte aligned.
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *   - At least one of the following pointers is Null: ppBitStream, *ppBitStream, pBitOffset , pDst
 *   - At least one of the below case:
 *   - *pBitOffset exceeds [0,7], QP <= 0;
 *	 - pDst not 16-byte aligned
 * OMX_StsErr - status error
 *
 */
OMXResult omxVCM4P2_DecodeBlockCoef_Inter(
     const OMX_U8 **ppBitStream,
     OMX_INT *pBitOffset,
     OMX_S16 *pDst,
     OMX_INT QP,
     OMX_INT shortVideoHeader
 );

/**
 *
 * Function:  omxVCM4P2_MCReconBlock	
 *
 * Description:  
 * Performs motion compensation prediction for an 8x8 block using interpolation described in ISO/IEC
 * 14496-2, subclause 7.6.2.
 *
 *
 * Parameters:	
 * [in] pSrc          - pointer to the block in the reference plane.
 * [in] srcStep       - distance between the start of consecutive lines in the reference plane, in bytes; must be a multiple of 8.
 * [in] dstStep       - distance between the start of consecutive lines in the destination plane, in bytes; must be a multiple of 8.
 * [in] pSrcResidue   - pointer to a buffer containing the 16-bit prediction residuals. If the pointer is NULL,
 *                      then no prediction is done, only motion compensation, i.e., the block is moved with interpolation.
 * [in] predictType   - bilinear interpolation type, as defined in section 6.2.1.2.
 * [in] rndVal        - rounding control parameter; 0-disabled, 1-enabled.
 * [out] pDst         - pointer to the destination buffer; must be 8-byte aligned. If prediction residuals are added
 *                      then output intensities are clipped to the range [0,255].
 * Return Values:
 *	 OMX_StsNoErr     - no error
 *   OMX_StsBadArgErr - bad arguments; returned under any of the following conditions:
 *                        -- one or more of the following pointers is NULL:  pSrc or pDst.
 *                        -- either srcStep or dstStep is not a multiple of 8. 
 *                        -- invalid type specificed for the parameter predictType.
 *	                      -- the parameter rndVal is not equal either to 0 or 1.
 *
 */
OMXResult omxVCM4P2_MCReconBlock (
		const OMX_U8 *pSrc,
		OMX_INT srcStep,
		const OMX_S16 *pSrcResidue,
		OMX_U8 *pDst, 
		OMX_INT dstStep,
		OMX_INT predictType,
		OMX_INT rndVal);

/**
 * EndDomain: M4P2
 */



/* *****************************************************************************************/
/**
 *
 *  NewDomain: M4P10 The MPEG4 Part10 Codec Subdomain
 *  WithinDomain: VC
 *
 *  StartDomain: M4P10
 */
/* =============== Data Structure and enumerator ============== */
typedef enum {
	OMX_VC_16X16_VERT = 0,		/** Intra_16x16_Vertical (prediction mode) */
	OMX_VC_16X16_HOR = 1,		/** Intra_16x16_Horizontal (prediction mode) */
	OMX_VC_16X16_DC = 2,		/** Intra_16x16_DC (prediction mode) */
	OMX_VC_16X16_PLANE = 3	/** Intra_16x16_Plane (prediction mode) */
} OMXVCM4P10Intra16x16PredMode;

typedef enum
{
	OMX_VC_4x4_VERT = 0,		/** Intra_4x4_Vertical (prediction mode) */
	OMX_VC_4x4_HOR  = 1,		/** Intra_4x4_Horizontal (prediction mode) */
	OMX_VC_4x4_DC   = 2,		/** Intra_4x4_DC (prediction mode) */
	OMX_VC_4x4_DIAG_DL = 3,	/** Intra_4x4_Diagonal_Down_Left (prediction mode) */
	OMX_VC_4x4_DIAG_DR = 4,	/** Intra_4x4_Diagonal_Down_Right (prediction mode) */
	OMX_VC_4x4_VR = 5,			/** Intra_4x4_Vertical_Right (prediction mode) */
	OMX_VC_4x4_HD = 6,			/** Intra_4x4_Horizontal_Down (prediction mode) */
	OMX_VC_4x4_VL = 7,			/** Intra_4x4_Vertical_Left (prediction mode) */
	OMX_VC_4x4_HU = 8			/** Intra_4x4_Horizontal_Up (prediction mode) */
} OMXVCM4P10Intra4x4PredMode;

typedef enum
{
	OMX_VC_CHROMA_DC = 0,		/** Intra_Chroma_DC (prediction mode) */
	OMX_VC_CHROMA_HOR = 1,		/** Intra_Chroma_Horizontal (prediction mode) */
	OMX_VC_CHROMA_VERT = 2,	/** Intra_Chroma_Vertical (prediction mode) */
	OMX_VC_CHROMA_PLANE = 3	/** Intra_Chroma_Plane (prediction mode) */
} OMXVCM4P10IntraChromaPredMode;

typedef enum {
	OMX_VC_M4P10_FAST_SEARCH  	= 0,	 	/** Fast motion search */
	OMX_VC_M4P10_FULL_SEARCH  	= 1  /** Full motion search */
} OMXVCM4P10MEMode;

typedef enum {
	OMX_VC_P_16x16   	= 0,	/* defined by ISO/IEC 14496-10 */
	OMX_VC_P_16x8    				= 1,
	OMX_VC_P_8x16    				= 2,
	OMX_VC_P_8x8     				= 3,
	OMX_VC_PREF0_8x8 				= 4,
	OMX_VC_INTER_SKIP    			= 5,
	OMX_VC_INTRA_4x4   				= 8,
	OMX_VC_INTRA_16x16 				= 9,
	OMX_VC_INTRA_PCM   				= 10
} OMXVCM4P10MacroblockType;

typedef enum {
	OMX_VC_SUB_8x8  	= 0,	/* defined by ISO/IEC 14496-10 */
	OMX_VC_SUB_8x4	= 1,
	OMX_VC_SUB_4x8	= 2,
	OMX_VC_SUB_4x4 	= 3
} OMXVCM4P10SubMacroblockType;

typedef struct {
    OMX_S32                     sliceId; 	  /* slice number */
    OMXVCM4P10MacroblockType    mbType;			  /* MB type */
    OMXVCM4P10SubMacroblockType subMBType[4]; /* sub-block type */
    OMX_S32                     qpy;			    /* qp for luma */
    OMX_S32                     qpc;          /* qp for chroma */
    OMX_U32                     cbpy;         /* CBP Luma */
    OMX_U32                     cbpc;			    /* CBP Chroma */
    OMXVCMotionVector             pMV0[4][4];   /* motion vector, represented
 						                                     using 1/4-pel units,
 						                                     pMV0[blocky][blockx]
                                       	         (blocky = 0~3, blockx =0~3) */
    OMXVCMotionVector             pMVPred[4][4]; /* motion vector prediction,
							                                   Represented using 1/4-pel
 					                                       units, pMVPred[blocky][blockx]
                                     	           (blocky = 0~3, blockx = 0~3) */
    OMX_U8                      pRefL0Idx[4];  /* reference picture indices */
    OMXVCM4P10Intra16x16PredMode Intra16x16PredMode; /* best intra 16x16 prediction mode */
    OMXVCM4P10Intra4x4PredMode   pIntra4x4PredMode[16]; /* best intra 4x4 prediction mode
 						                                               for each block, pMV0 indexed as above */
} OMXVCM4P10MBInfo, *OMXVCM4P10MBInfoPtr;

typedef struct
{
	OMX_S32 blockSplitEnable8x8;	/* enables 16x8, 8x16, 8x8 */
    OMX_S32 blockSplitEnable4x4;    /* enable splitting of 8x4, 4x8, 4x4 blocks */
    OMX_S32 halfSearchEnable;
    OMX_S32 quarterSearchEnable;
    OMX_S32 intraEnable4x4;         /* 1=enable, 0=disable */
    OMX_S32 searchRange16x16;       /* integer pixel units */
    OMX_S32 searchRange8x8;
    OMX_S32 searchRange4x4;
} OMXVCM4P10MEParams;

/*
 * Description:
 * Variable Length Coding (VLC) Information data structure.
 *
 *	uTrailing_Ones			Trailing ones(three at most)
 *	uTrailing_One_Signs	    Trailing ones's signal
 *	uNumCoeffs					Total Number of non-zero coefficients (including Trailing Ones)
 *	uTotalZeros					Total Number of zero coefficients
 *	iLevels[16]					Levels of none-zero coefficients, in reverse zigzag order
 *	uRuns[16]						Runs for levels and trailing ones, in reverse zigzag order
 *
 */
 typedef struct {
	OMX_U8		uTrailing_Ones;
	OMX_U8		uTrailing_One_Signs;
	OMX_U8		uNumCoeffs;
	OMX_U8		uTotalZeros;
	OMX_S16		iLevels[16];
	OMX_U8 		uRuns[16];
} OMXVCM4P10VLCInfo;

/** H.264 common functions */
/**
 * Function: omxVCM4P10_PredictIntra_4x4
 *
 * Description: Perform Intra_4x4 prediction for luma samples. If the upper-right block
 * is not available, then duplication work should be handled inside the function. Users
 * need not define them outside.
 *
 * Remarks:
 *
 * Parameters:
 * [in] pSrcLeft - Pointer to the buffer of 4 left  pixel values: p[x, y] (x = -1, y = 0..3)
 *                 Must be 4-byte aligned.
 * [in] pSrcAbove - Pointer to the buffer of 8 above  pixel values: p[x,y] (x = 0..7, y =-1)
 *                 Must be 4-byte aligned.
 * [in] pSrcAboveLeft - Pointer to the above left  pixel value: p[x,y] (x = -1, y = -1)
 * [in] leftStep - Step of left coefficient buffer. Must be multiple of 4.
 * [in] dstStep - Step of the destination buffer. Must be multiple of 4.
 * [in] predMode - Intra_4x4 prediction mode.
 * [in] availability - Neighboring 4x4 block availability flag, refer to "Neighboring Macroblock Availability".
 * [out]	pDst - Pointer to the destination buffer. Must be 4-byte aligned.
 *
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 * If one of the following cases occurs, the function returns OMX_StsBadArgErr:
 *    pDst is NULL or is not 4-byte aligned.
 *    dstStep < 4 or is not multiple of 4.
 *	  predMode is not in the valid range of enumeration OMXVCM4P10Intra4x4PredMode.
 *  	predMode is OMX_VC_4x4_VERT, but availability doesn't set OMX_VC_UPPER indicating p[x,-1] (x = 0..3)
      is not available.
 *	  predMode is OMX_VC_4x4_HOR, but availability doesn't set OMX_VC_LEFT indicating p[-1,y] (y = 0..3)
      is not available.
 *	  predMode is OMX_VC_4x4_DIAG_DL, but availability doesn't set OMX_VC_UPPER indicating p[x,-1] (x = 0..3)
      is not available.
 *	  predMode is OMX_VC_4x4_DIAG_DR, but availability doesn't set OMX_VC_UPPER_LEFT or OMX_VC_UPPER or
      OMX_VC_LEFT indicating p[x,-1] (x = 0..3), or p[-1,y] (y = 0..3) or p[-1,-1] is not available.
 *	  predMode is OMX_VC_4x4_VR, but availability doesn't set OMX_VC_UPPER_LEFT or OMX_VC_UPPER or
      OMX_VC_LEFT indicating p[x,-1] (x = 0..3), or p[-1,y] (y = 0..3) or p[-1,-1] is not available.
 *	  predMode is OMX_VC_4x4_HD, but availability doesn't set OMX_VC_UPPER_LEFT or OMX_VC_UPPER or
      OMX_VC_LEFT indicating p[x,-1] (x = 0..3), or p[-1,y] (y = 0..3) or p[-1,-1] is not available.
 *	  predMode is OMX_VC_4x4_VL, but availability doesn't set OMX_VC_UPPER indicating p[x,-1] (x = 0..3)
      is not available.
 *	  predMode is OMX_VC_4x4_HU, but availability doesn't set OMX_VC_LEFT indicating p[-1,y] (y = 0..3)
      is not available.
 *	  availability sets OMX_VC_UPPER, but pSrcAbove is NULL.
 *	  availability sets OMX_VC_LEFT, but pSrcLeft is NULL.
 *	  availability sets OMX_VC_UPPER_LEFT, but pSrcAboveLeft is NULL.
 *
 */
OMXResult omxVCM4P10_PredictIntra_4x4(
    const OMX_U8 *pSrcLeft,
    const OMX_U8 *pSrcAbove,
    const OMX_U8 *pSrcAboveLeft,
    OMX_U8 *pDst,
    OMX_INT leftStep,
    OMX_INT dstStep,
    OMXVCM4P10Intra4x4PredMode predMode,
    OMX_S32 availability);

/**
 * Function: omxVCM4P10_PredictIntra_16x16
 *
 * Description: Perform Intra_16x16 prediction for luma samples. If the upper-right block is not available, then duplication work should be handled inside the function. Users need not define them outside.
 *
 * Remarks:
 *
 * Parameters:
 * [in] pSrcLeft - Pointer to the buffer of 16 left  pixel values: p[x, y] (x = -1, y = 0..15)
 *                 Must be 16-byte aligned.
 * [in] pSrcAbove - Pointer to the buffer of 16 above  pixel values: p[x,y] (x = 0..15, y= -1)
 *                 Must be 16-byte aligned.
 * [in] pSrcAboveLeft - Pointer to the above left  pixel value: p[x,y] (x = -1, y = -1)
 * [in] leftStep - Step of left coefficient buffer. Must be multiple of 16.
 * [in] dstStep - Step of the destination buffer. Must be multiple of 16.
 * [in] predMode - Intra_16x16 prediction mode, please refer to section 3.4.1.
 * [in] availability - Neighboring 16x16 MB availability flag. Refer to section 3.4.4.
 * [out] pDst - Pointer to the destination buffer. Must be 16-byte aligned.
 *
 * Return Value:
 * if the function runs without error, it returns OMX_StsNoErr.
 * If one of the following cases occurs, the function returns OMX_StsBadArgErr:
 *	 pDst is NULL or is not 16-byte aligned.
 *	 dstStep < 16 or is not multiple of 16.
 *	 predMode is not in the valid range of enumeration OMXVCM4P10Intra16x16PredMode
 *	 predMode is OMX_VC_16X16_VERT, but availability doesn't set OMX_VC_UPPER indicating
     p[x,-1] (x = 0..15) is not available.
 *	 predMode is OMX_VC_16X16_HOR, but availability doesn't set OMX_VC_LEFT indicating
     p[-1,y] (y = 0..15) is not available.
 *	 predMode is OMX_VC_16X16_PLANE, but availability doesn't set OMX_VC_UPPER_LEFT or
     OMX_VC_UPPER or OMX_VC_LEFT indicating p[x,-1](x = 0..15), or p[-1,y] (y = 0..15),
     or p[-1,-1] is not available.
 *	 availability sets OMX_VC_UPPER, but pSrcAbove is NULL.
 *	 availability sets OMX_VC_LEFT, but pSrcLeft is NULL.
 *	 availability sets OMX_VC_UPPER_LEFT, but pSrcAboveLeft is NULL.
 *
 */
OMXResult omxVCM4P10_PredictIntra_16x16(
    const OMX_U8 *pSrcLeft,
    const OMX_U8 *pSrcAbove,
    const OMX_U8 *pSrcAboveLeft,
    OMX_U8 *pDst,
    OMX_INT leftStep,
    OMX_INT dstStep,
    OMXVCM4P10Intra16x16PredMode predMode,
    OMX_S32 availability);

/**
 * Function: omxVCM4P10_PredictIntraChroma8x8
 *
 * Description: Performs Intra prediction for chroma samples.
 *
 * Remarks:
 *
 * Parameters:
 * [in] pSrcLeft - Pointer to the buffer of 8 left  pixel values: p[x, y] (x = -1, y= 0..7)
 *                 Must be 8-byte aligned.
 * [in] pSrcAbove - Pointer to the buffer of 8 above  pixel values: p[x,y] (x = 0..7, y = -1)
 *                 Must be 8-byte aligned.
 * [in] pSrcAboveLeft - Pointer to the above left  pixel value: p[x,y] (x = -1, y = -1)
 * [in] leftStep - Step of left coefficient buffer. Must be multiple of 8
 * [in] dstStep - Step of the destination buffer. Must be multiple of 8
 * [in] predMode - Intra chroma prediction mode, please refer to section 3.4.3.
 * [in] availability - Neighboring chroma block availability flag, please refer to "Neighboring Macroblock Availability".
 * [out] pDst - Pointer to the destination buffer. Must be 8-byte aligned.
 *
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 * If any of the following cases occurs, the function returns OMX_StsBadArgErr:
 *	 pDst is NULL or is not 8-byte aligned.
 *	 dstStep < 8 or is not multiple of 8.
 *	 predMode is not in the valid range of enumeration OMXVCM4P10IntraChromaPredMode.
 *	 predMode is OMX_VC_CHROMA_VERT, but availability doesn't set OMX_VC_UPPER indicating p[x,-1] (x = 0..7) is not available.
 *	 predMode is OMX_VC_CHROMA_HOR, but availability doesn't set OMX_VC_LEFT indicating p[-1,y] (y = 0..7) is not available.
 *	 predMode is OMX_VC_CHROMA_PLANE, but availability doesn't set OMX_VC_UPPER_LEFT or OMX_VC_UPPER or OMX_VC_LEFT indicating p[x,-1](x = 0..7), or p[-1,y] (y = 0..7), or p[-1,-1] is not available.
 *	 availability sets OMX_VC_UPPER, but pSrcAbove is NULL.
 *	 availability sets OMX_VC_LEFT, but pSrcLeft is NULL.
 *	 availability sets OMX_VC_UPPER_LEFT, but pSrcAboveLeft is NULL.
 *
 */
OMXResult omxVCM4P10_PredictIntraChroma8x8(
    const OMX_U8 *pSrcLeft,
    const OMX_U8 *pSrcAbove,
    const OMX_U8 *pSrcAboveLeft,
    OMX_U8 *pDst,
    OMX_INT leftStep,
    OMX_INT dstStep,
    OMXVCM4P10IntraChromaPredMode predMode,
    OMX_S32 availability);

/**
 * Function: omxVCM4P10_InterpolateLuma,
 *
 * Description:
 * Performs quarter-pixel interpolation for inter luma MB.
 * It's assumed that the frame is already padded when calling this function.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrc		Pointer to the source reference frame buffer
 * [in]	srcStep		Reference frame step in byte
 * [in]	dstStep		Destination frame step in byte. Must be multiple of roi.width
 * [in]	dx			Fractional part of horizontal motion vector
 *							component in 1/4 pixel unit; valid in the range [0,3]
 * [in]	dy			Fractional part of vertical motion vector
 *							component in 1/4 pixel unit; valid in the range [0,3]
 * [in]	roi			Dimension of the interpolation region;the parameters roi.width and roi.height must
 *                   be equal to either 4, 8, or 16.
 * [out]	pDst		Pointer to the destination frame buffer.
 *                   if roi.width==4,  4-byte alignment required
 *                   if roi.width==8,  8-byte alignment required
 *                   if roi.width==16, 16-byte alignment required
 *
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 * If one of the following cases occurs, the function returns OMX_StsBadArgErr:
 *   pSrc or pDst is NULL.
 *   srcStep or dstStep < roi.width.
 *	 dx or dy is out of range [0-3].
 *	 roi.width or roi.height is out of range {4, 8, 16}.
 *	 roi.width is equal to 4, but pDst is not 4 byte aligned.
 *	 roi.width is equal to 8, but pDst is not 8 byte aligned.
 *	 roi.width is equal to 16, but pDst is not 16 byte aligned.
 *	 srcStep or dstStep is not a multiple of 8.
 *
 */
OMXResult omxVCM4P10_InterpolateLuma (
     const OMX_U8 *pSrc,
     OMX_S32 srcStep,
     OMX_U8 *pDst,
     OMX_S32 dstStep,
     OMX_S32 dx,
     OMX_S32 dy,
     OMXSize roi
 );



/**
 * Function: omxVCM4P10_InterpolateChroma,
 *
 * Description:
 * Performs 1/8-pixel interpolation for inter chroma MB.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrc	Pointer to the source reference frame buffer
 * [in]	srcStep Reference frame step in byte
 * [in]	dstStep Destination frame step in byte. Must be multiple of roi.width.
 * [in]	dx		Fractional part of horizontal motion vector component
 *						in 1/8 pixel unit;valid in the range [0,7]
 * [in]	dy		Fractional part of vertical motion vector component
 *						in 1/8 pixel unit;valid in the range [0,7]
 * [in]	roi		Dimension of the interpolation region;the parameters roi.width and roi.height must
 *                      be equal to either 2, 4, or 8.
 * [out]	pDst	Pointer to the destination frame buffer.
 *                   if roi.width==2,  2-byte alignment required
 *                   if roi.width==4,  4-byte alignment required
 *                   if roi.width==8,  8-byte alignment required
 *
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 * If one of the following cases occurs, the function returns OMX_StsBadArgErr:
 *	pSrc or pDst is NULL.
 *	srcStep or dstStep < 8.
 *	dx or dy is out of range [0-7].
 *	roi.width or roi.height is out of range {2,4,8}.
 *	roi.width is equal to 2, but pDst is not 2-byte aligned.
 *	roi.width is equal to 4, but pDst is not 4-byte aligned.
 *	roi.width is equal to 8, but pDst is not 8 byte aligned.
 *	srcStep or dstStep is not a multiple of 8.
 *
 */

OMXResult omxVCM4P10_InterpolateChroma (
     const OMX_U8 *pSrc,
     OMX_S32 srcStep,
     OMX_U8 *pDst,
     OMX_S32 dstStep,
     OMX_S32 dx,
     OMX_S32 dy,
     OMXSize roi
 );


 /**
 * Function: omxVCM4P10_FilterDeblockingLuma_VerEdge_I,
 *
 * Description:
 * Performs in-place deblock filtering on four vertical edges of the luma
 * macroblock(16x16).
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcDst		Pointer to the input macroblock; must be 16-byte aligned.
 * [in]	srcdstStep	Step of the arrays. Must be multiple of 16.
 * [in]	pAlpha		Array of size 2 of Alpha Thresholds (the first item
 *							is alpha threshold for external vertical edge, and
 *							the second item is for internal vertical edge)
 * [in]	pBeta		Array of size 2 of Beta Thresholds (the first item
 *							is alpha threshold for external vertical edge, and
 *							the second item is for internal vertical edge)
 * [in]	pThresholds	Array of size 16 of Thresholds (TC0) (values for
 *							the left edge of each 4x4 block, arranged in vertical
 *							block order)
 * [in]	pBS			 Array of size 16 of BS parameters (arranged in vertical block order); valid in the range [0,4]
 *                          with the following restrictions: i) pBS[i]== 4 may occur only for 0<=i<=3, ii) pBS[i]== 4 if and
 *                          only if pBS[i^1]== 4. Must be 4-byte aligned.
 * [out] pSrcDst	 Pointer to filtered output macroblock.
 *
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 * If one of the following cases occurs, the function returns OMX_StsBadArgErr:
 *	Either of the pointers in pSrcDst, pAlpha, pBeta, pThresholds, or pBS is NULL.
 *  Either pThresholds or pBS is not aligned on a 4-byte boundary.
 *  pSrcDst is not 16-byte aligned.
 *  srcdstStep is not a multiple of 16.
 *	pBS is out of range, i.e., one of the following conditions is true: pBS[i]<0, pBS[i]>4, pBS[i]==4 for i>=4, or (pBS[i]==4 && pBS[i^1]!=4) for 0<=i<=3.
 *
 */

OMXResult omxVCM4P10_FilterDeblockingLuma_VerEdge_I(
     OMX_U8 *pSrcDst,
     OMX_S32 srcdstStep,
     const OMX_U8 *pAlpha,
     const OMX_U8 *pBeta,
     const OMX_U8 *pThresholds,
     const OMX_U8 *pBS
 );




/**
 * Function: omxVCM4P10_FilterDeblockingLuma_HorEdge_I,
 *
 * Description:
 * Performs deblocking filtering on four horizontal edges of the luma macroblock
 * (16x16).
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcDst		Pointer to the input macroblock;
 *                  Must be 16-byte aligned.
 * [in]	srcdstStep	Step of the arrays. Must be multiple of 16
 * [in]	pAlpha			Array of size 2 of Alpha Thresholds (the first
 *								item is alpha threshold for external horizontal
 *								edge, and the second item is for internal
 *								horizontal edge)
 * [in]	pBeta			Array of size 2 of Beta Thresholds (the first
 *								item is alpha threshold for external horizontal
 *								edge, and the second item is for internal
 *								horizontal edge)
 * [in]	pThresholds		Array of size 16 of Thresholds (TC0) (values
 *								for the left edge of each 4x4 block, arranged in
 *								horizontal block order)
 * [in]	pBS				Array of size 16 of BS parameters (arranged in horizontal block order);
 *                             valid in the range [0,4] with the following restrictions: i) pBS[i]== 4 may occur only for 0<=i<=3, ii) pBS[i]== 4 if and
 *                              only if pBS[i^1]== 4. Must be 4-byte aligned.
 * [out] pSrcDst     Pointer to filtered output macroblock.
 *
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 *	If one of the following cases occurs, the function returns OMX_StsBadArgErr:
 *    one or more of the following pointers is NULL: pSrcDst, pAlpha, pBeta, pThresholds, or pBS.
 *    either pThresholds or pBS is not aligned on a 4-byte boundary.
 *    pSrcDst is not 16-byte aligned.
 *    srcdstStep is not a multiple of 16.
 *    pBS is out of range, i.e., one of the following conditions is true: pBS[i]<0, pBS[i]>4,pBS[i]==4 for i>=4, or (pBS[i]==4 && pBS[i^1]!=4) for 0<=i<=3.
 *
 */

OMXResult omxVCM4P10_FilterDeblockingLuma_HorEdge_I(
     OMX_U8 *pSrcDst,
     OMX_S32 srcdstStep,
     const OMX_U8 *pAlpha,
     const OMX_U8 *pBeta,
     const OMX_U8 *pThresholds,
     const OMX_U8 *pBS
 );



/**
 * Function: omxVCM4P10_FilterDeblockingChroma_VerEdge_I,
 *
 * Description:
 * Performs deblocking filtering on four vertical edges of the chroma
 * macroblock(8x8).
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcDst		Pointer to the input macroblock; must be 8-byte aligned.
 * [in]	srcdstStep	Step of the arrays. Must be multiple of 8.
 * [in]	pAlpha		Array of size 2 of Alpha Thresholds (the first item
 *							is alpha threshold for external vertical edge, and
 *							the second item is for internal vertical edge)
 * [in]	pBeta		Array of size 2 of Beta Thresholds (the first item is
 *							alpha threshold for external vertical edge, and the
 *							second item is for internal vertical edge)
 * [in]	pThresholds	Array of size 16 of Thresholds (TC0)
 *                  (values for the left edge of each 4x2 or above edge of each 2x4 block,
 *                   arranged in vertical block order)
 * [in]	pBS			Array of size 16 of BS parameters (values for each 2x2 chroma block, arranged in vertical block order).
 *                      This parameter is the same as the pBS parameter passed into FilterDeblockLuma_VerEdge;
 *                      valid in the range [0,4] with the following restrictions: i) pBS[i]== 4 may occur only for 0<=i<=3, ii) pBS[i]== 4 if and
 *                       only if pBS[i^1]== 4.  Must be 4-byte aligned.
 * [out] pSrcDst		Pointer to filtered output macroblock.
 *
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 * If one of the following cases occurs, the function returns OMX_StsBadArgErr:
 *   - one or more of the following pointers is NULL:  pSrcDst, pAlpha, pBeta, pThresholds, or pBS.
 *   - either pThresholds or pBS is not aligned on a 4-byte boundary.
 *   - pSrcDst is not 8-byte aligned.
 *   - srcdstStep is not a multiple of 8.
 *   - pBS is out of range, i.e., one of the following conditions is true: pBS[i]<0, pBS[i]>4, pBS[i]==4 for i>=4, or (pBS[i]==4 && pBS[i^1]!=4) for 0<=i<=3.
 */

OMXResult omxVCM4P10_FilterDeblockingChroma_VerEdge_I(
     OMX_U8 *pSrcDst,
     OMX_S32 srcdstStep,
     const OMX_U8 *pAlpha,
     const OMX_U8 *pBeta,
     const OMX_U8 *pThresholds,
     const OMX_U8 *pBS
 );


/**
 * Function: omxVCM4P10_FilterDeblockingChroma_HorEdge_I,
 *
 * Description:
 * Performs deblocking filtering on the horizontal edges of the chroma
 * macroblock (8x8).
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcDst		pointer to the input macroblock; must be 8-byte aligned.
 * [in]	srcdstStep	Step of the arrays. Must be multiple of 8
 * [in]	pAlpha		Array of size 2 of Alpha Thresholds (the first
 *								item is alpha threshold for external horizontal
 *								edge, and the second item is for internal
 *								horizontal edge)
 * [in]	pBeta			Array of size 2 of Beta Thresholds (the first
 *								item is alpha threshold for external horizontal
 *								edge, and the second item is for internal
 *								horizontal edge)
 * [in]	pThresholds		array of size 16 containing BS parameters for each 2x2 chroma block, arranged in horizontal block order;
 *                         valid in the range [0,4] with the following restrictions: i) pBS[i]== 4 may occur only for 0<=i<=3, ii) pBS[i]== 4 if and
 *                         only if pBS[i^1]== 4.  Must be 4-byte aligned.
 * [in]	pBS				array of size 16 containing BS parameters for each 2x2 chroma block, arranged in horizontal block order;
 *                          valid in the range [0,4] with the following restrictions: i) pBS[i]== 4 may occur only for 0<=i<=3, ii) pBS[i]== 4 if and
 *                          only if pBS[i^1]== 4.  Must be 4-byte aligned.
 * [out]	pSrcDst			Pointer to filtered output macroblock.
 *
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 * If one or more of the following conditions occurs, the function returns OMX_StsBadArgErr:
 *   - any of the following pointers is NULL:  pSrcDst, pAlpha, pBeta, pTresholds, or pBS.
 *   - pSrcDst is not 8-byte aligned.
 *   - srcdstStep is not a multiple of 8.
 *   - pTresholds is not 4-byte aligned.
 *   - pBS is out of range, i.e., one of the following conditions is true: pBS[i]<0, pBS[i]>4, pBS[i]==4 for i>=4, or (pBS[i]==4 && pBS[i^1]!=4) for 0<=i<=3.
 *
 */

OMXResult omxVCM4P10_FilterDeblockingChroma_HorEdge_I(
     OMX_U8 *pSrcDst,
     OMX_S32 srcdstStep,
     const OMX_U8 *pAlpha,
     const OMX_U8 *pBeta,
     const OMX_U8 *pThresholds,
     const OMX_U8 *pBS
 );
/**
 * Function: omxVCM4P10_DeblockLuma_I
 *
 * Description:
 * This function performs deblock filtering the horizontal and vertical edges of a luma macroblock
 *(16x16).
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcDst         pointer to the input macroblock. Must be 8-byte aligned.
 * [in]	srcdstStep      image width
 * [in]	pAlpha          pointer to a 2x2 table of alpha thresholds, organized as follows: { external
 *                             vertical edge, internal vertical edge, external horizontal
 *                             edge, internal horizontal edge }
 * [in]	pBeta			pointer to a 2x2 table of beta thresholds, organized as follows: { external
 *                              vertical edge, internal vertical edge, external  horizontal edge,
 *                              internal  horizontal edge }
 * [in]	pThresholds		pointer to a 16x2 table of threshold (TC0), organized as follows: { values for
 *                              the  left or above edge of each 4x4 block, arranged in  vertical block order
 *                              and then in horizontal block order)
 * [in]	pBS				 pointer to a 16x2 table of BS parameters arranged in scan block order for vertical edges and then horizontal edges;
 *                               valid in the range [0,4] with the following restrictions: i) pBS[i]== 4 may occur only for 0<=i<=3, ii) pBS[i]== 4 if and only if pBS[i^1]== 4.  Must be 4-byte aligned.
 * [out]	pSrcDst		pointer to filtered output macroblock.
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - Either of the pointers in pSrcDst, pAlpha, pBeta, pTresholds or pBS is NULL.
 *    - pSrcDst is not 8-byte aligned.
 *    - srcdstStep is not a multiple of 8
 *    - pBS is out of range, i.e., one of the following conditions is true: pBS[i]<0, pBS[i]>4, pBS[i]==4 for i>=4, or (pBS[i]==4 && pBS[i^1]!=4) for 0<=i<=3.
.
 *
 */

OMXResult omxVCM4P10_DeblockLuma_I(
	OMX_U8 *pSrcDst,
	OMX_S32 srcdstStep,
	const OMX_U8 *pAlpha,
	const OMX_U8 *pBeta,
	const OMX_U8 *pThresholds,
	const OMX_U8 *pBS
);
/**
 * Function: omxVCM4P10_DeblockChroma_I
 *
 * Description:
 * Performs deblocking filtering on all edges of the chroma macroblock (16x16).
 *
 * Remarks:
 *
 * Parameters:
 * [in]	pSrcDst         pointer to the input macroblock. Must be 8-byte aligned.
 * [in]	srcdstStep      Step of the arrays
 * [in]	pAlpha          pointer to a 2x2 array of alpha thresholds, organized as follows: { external
 *                          vertical edge, internal  vertical edge, external
 *                         horizontal edge, internal horizontal edge }
 * [in]	pBeta			pointer to a 2x2 array of beta thresholds, organized as follows: { external
 *                              vertical edge, internal vertical edge, external  horizontal edge,
 *                              internal  horizontal edge }
 * [in]	pThresholds		AArray of size  8x2 of Thresholds (TC0) (values for the left or
 *                               above edge of each 4x2 or 2x4 block, arranged in  vertical block order
 *                               and then in  horizontal block order)
 * [in]	pBS				array of size 16x2 of BS parameters (arranged in scan block order for vertical edges and then horizontal edges);
 *                         valid in the range [0,4] with the following restrictions: i) pBS[i]== 4 may occur only for 0<=i<=3, ii) pBS[i]== 4 if and only if pBS[i^1]== 4.  Must be 4-byte aligned.
 * [out]	pSrcDst		pointer to filtered output macroblock
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *   - Either of the pointers in pSrcDst, pAlpha, pBeta, pTresholds, or pBS is NULL.
 *   - pSrcDst is not 8-byte aligned.
 *   - either pThresholds or pBS is not 4-byte aligned.
 *   - pBS is out of range, i.e., one of the following conditions is true: pBS[i]<0, pBS[i]>4, pBS[i]==4 for i>=4, or (pBS[i]==4 && pBS[i^1]!=4) for 0<=i<=3.
 *   - srcdstStep is not a multiple of 8.
 *
 */
OMXResult omxVCM4P10_DeblockChroma_I(
	OMX_U8 *pSrcDst,
	OMX_S32 srcdstStep,
	const OMX_U8 *pAlpha,
	const OMX_U8 *pBeta,
	const OMX_U8 *pThresholds,
    const OMX_U8 *pBS
);


/** H.264 decoder */
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
 *								buffer;valid in the range [0,7].
 * [in]	pOffset			Pointer to current bit position in the byte
 *								pointed to by *ppBitStream
 * [out]	ppBitStream		*ppBitStream is updated after each block is decoded
 * [out]	pOffset			*pOffset is updated after each block is decoded
 * [out]	pNumCoeff		Pointer to the number of nonzero coefficients
 *								in this block
 * [out]	ppPosCoefbuf	Double pointer to destination residual coefficient-position pair buffer. Buffer
 *                           position (*ppPosCoefBuf) is updated upon return, unless there are only zero coefficients in the
 *                           currently decoded block. In this case the caller is expected tobypass the transform/dequantization of
 *                           the empty blocks.
 *
 * Return Value:
 * The function returns OMX_StsNoErr if it runs without error.
 * The function returns OMX_StsBadArgErr if one or more of the following is true:
 *	ppBitStream or pOffset is NULL.
 *	ppPosCoefBuf or pNumCoeff is NULL.
 *	an illegal code is encountered in the bitstream
 *
 */

OMXResult omxVCM4P10_DecodeChromaDcCoeffsToPairCAVLC (
     const OMX_U8 **ppBitStream,
     OMX_S32 *pOffset,
     OMX_U8 *pNumCoeff,
     OMX_U8 **ppPosCoefbuf
 );



/**
 * Function: omxVCM4P10_DecodeCoeffsToPairCAVLC
 *
 * Description:
 * Performs CAVLC decoding and inverse zigzag scan for 4x4 block of
 * Intra16x16DCLevel, Intra16x16ACLevel,LumaLevel, and ChromaACLevel.
 * Inverse field scan is not supported. The decoded coefficients in packed
 * position-coefficient buffer are stored in increasing zigzag order instead
 * of position order.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppBitStream		Double pointer to current byte in bit stream buffer
 * [in]	pOffset			Pointer to current bit position in the byte pointed
 *								to by *ppBitStream;valid in the range [0,7].
 * [in]	sMaxNumCoeff	Maximum number of non-zero coefficients in current
 *								block
 * [in]	sVLCSelect		VLC table selector, obtained from number of non-zero
 *								AC coefficients of above and left 4x4 blocks. It is
 *								equivalent to the variable nC described in H.264 standard
 *								table 9-5, except its value can't be less than zero.
 * [out]	ppBitStream		*ppBitStream is updated after each block is decoded. Buffer position
 *                          (*ppPosCoefBuf) is updated upon return, unless there are only zero coefficients in the currently
 *                           decoded block. In this case the caller is expected tobypass the transform/dequantization of the empty
 *                           blocks.
 * [out]	pOffset			*pOffset is updated after each block is decoded
 * [out]	pNumCoeff		Pointer to the number of nonzero coefficients in
 *								this block
 * [out]	ppPosCoefbuf	Double pointer to destination residual
 *								coefficient-position pair buffer
 * Return Value:
 *  If the function runs without error, it returns OMX_StsNoErr.
 *  If any of the following cases occurs, the function returns OMX_StsBadArgErr:
 *     ppBitStream or pOffset is NULL.
 *     ppPosCoefBuf or pNumCoeff is NULL.
 *     sMaxNumCoeff is neither equal to 16 nor equal to 15.
 *     sVLCSelect is less than 0.
 *  If illegal code occurs in bitstream, the function returns OMX_StsErr
 *
 */

OMXResult omxVCM4P10_DecodeCoeffsToPairCAVLC(
     const OMX_U8 **ppBitStream,
     OMX_S32 *pOffset,
     OMX_U8 *pNumCoeff,
     OMX_U8 **ppPosCoefbuf,
     OMX_INT sVLCSelect,
     OMX_INT sMaxNumCoeff
 );



/**
 * Function: omxVCM4P10_TransformDequantLumaDCFromPair
 *
 * Description:
 * Reconstruct the 4x4 LumaDC block from coefficient-position pair buffer,
 * perform integer inverse, and dequantization for 4x4 LumaDC coefficients,
 * and update the pair buffer pointer to next non-empty block.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppSrc	Double pointer to residual coefficient-position pair
 *						buffer output by CALVC decoding
 * [in]	QP		Quantization parameter QpY
 * [out]	ppSrc	*ppSrc is updated to the start of next non empty block
 * [out]	pDst	Pointer to the reconstructed 4x4 LumaDC coefficients buffer. Must be 8-byte aligned.
 *
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 * If one of the following cases occurs, the function returns OMX_StsBadArgErr:
 *	ppSrc or pDst is NULL.
 *	pDst is not 8 byte aligned.
 *	QP is not in the range of [0-51].
 *
 */

OMXResult omxVCM4P10_TransformDequantLumaDCFromPair(
     const OMX_U8 **ppSrc,
     OMX_S16 *pDst,
     OMX_INT QP
 );

/**
 * Function: omxVCM4P10_TransformDequantChromaDCFromPair
 *
 * Description:
 * Reconstruct the 2x2 ChromaDC block from coefficient-position pair buffer,
 * perform integer inverse transformation, and dequantization for 2x2 chroma
 * DC coefficients, and update the pair buffer pointer to next non-empty block.
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppSrc	Double pointer to residual coefficient-position pair
 *						buffer output by CALVC decoding
 * [in]	QP		Quantization parameter QpC
 * [out]	ppSrc	*ppSrc is updated to the start of next non empty block
 * [out]	pDst	Pointer to the reconstructed 2x2 ChromaDC coefficients. Must be 8-byte aligned.
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 * If any of the following cases occurs, the function returns OMX_StsBadArgErr:
 *	ppSrc or pDst is NULL.
 *	pDst is not 8 byte aligned.
 *	QP is not in the range of [0-51].
 *
 */

OMXResult omxVCM4P10_TransformDequantChromaDCFromPair(
     const OMX_U8 **ppSrc,
     OMX_S16 *pDst,
     OMX_INT QP
 );



/**
 * Function: omxVCM4P10_DequantTransformResidualFromPairAndAdd
 *
 * Description:
 * Reconstruct the 4x4 residual block from coefficient-position pair buffer,
 * perform dequantisation and integer inverse transformation for 4x4 block of
 * residuals with previous intra prediction or motion compensation data, and
 * update the pair buffer pointer to next non-empty block.If pDC == NULL,
 * there're 16 non-zero AC coefficients at most in the packed buffer starting
 * from 4x4 block position 0; If pDC != NULL, there're 15 non-zero AC
 * coefficients at most in the packet buffer starting from 4x4 block position 1
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppSrc		Double pointer to residual coefficient-position
 *							pair buffer output by CALVC decoding
 * [in]	pPred		Pointer to the reference 4x4 block. Must be 4-byte aligned
 * [in]	predStep	Reference frame step in byte. Must be multiple of 4.
 * [in]	dstStep		Destination frame step in byte. Must be multiple of 4.
 * [in]	pDC			Pointer to the DC coefficient of this block, NULL
 *							if it doesn't exist
 * [in]	QP			Quantization parameter It should be QpC in chroma 4x4
 *              block decoding, otherwise it should be QpY
 * [in]	AC			Flag indicating if at least one non-zero AC coefficient
 *							exists
 * [out]	pDst		pointer to the reconstructed 4x4 block data. Must be 4-byte aligned
 *
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 * If one of the following cases occurs, the function returns OMX_StsBadArgErr:
 *	pPred or pDst is NULL.
 *	pPred or pDst is not 4-byte aligned.
 *	predStep or dstStep is not a multiple of 4.
 *	AC is not zero, but Qp is not in the range of [0-51] or ppSrc is NULL.
 *	AC is zero, but pDC is NULL.
 *
 */
OMXResult omxVCM4P10_DequantTransformResidualFromPairAndAdd(
     const OMX_U8 **ppSrc,
     const OMX_U8 *pPred,
     const OMX_S16 *pDC,
     OMX_U8 *pDst,
     OMX_INT predStep,
     OMX_INT dstStep,
     OMX_INT QP,
     OMX_INT AC
 );


/** H.264 encoder */

/**
 * Function: omxVCM4P10_MEGetBufSize
 *
 * Description:
 * Computes the size, in bytes, of the vendor-specific specification structure for the
 * omxVCM4P10 motion estimation functions BlockMatch_Integer and MotionEstimationMB.
 *
 * Remarks:
 *
 * Parameters:
 *	[in] MEMode   motion estimation mode; available modes are defined by the enumerated
 *                 type OMXVCM4P10MEMode
 *	[in] pMEParams  motion estimation parameters
 *  [out]pSize   pointer to the number of bytes required for the motion estimation specification structure
 *
 * Return Value:
 *	OMX_StsNoErr - no error
 *	OMX_StsBadArgErr - one or more of the following is true:
 *     - an invalid value was specified for the parameter MEMode
 *     - a negative or zero value was specified for the SearchRanges(16x16, 8x8, 4x4) in pMBOptions
 */
OMXResult omxVCM4P10_MEGetBufSize(
    OMXVCM4P10MEMode MEMode,
    const OMXVCM4P10MEParams *pMEParams,
    OMX_U32 *pSize);


/**
 * Function: omxVCM4P10_MEInit
 *
 * Description:
 * Initializes the vendor-specific specification structure required for the omxVCM4P10 motion
 * estimation functions BlockMatch_Integer and MotionEstimationMB.  Memory for the specification
 * structure *pMESpec must be allocated prior to calling the function, and should be aligned on
 * a 4-byte boundary.  The number of bytes required for the specification structure can be
 * determined using the function omxVCM4P10_MEGetBufSize.Following initialization by this function, the vendor-specific
 * structure *pMESpec should contain an implementation-specific representation of all motion estimation
 * parameters received via the structure pMEParams, for example searchRange16x16,
 * searchRange8x8, etc.
 *
 * Remarks:
 *
 * Parameters:
 * [in]  MEMode   motion estimation mode; available modes are defined by the enumerated type OMXVCM4P10MEMode
 * [in]	 pMEParams   motion estimation parameters
 * [out] pMESpec   pointer to the initialized ME specification structure
 *
 * Return Value:
 *	OMX_StsNoErr - no error
 *	OMX_StsBadArgErr - one or more of the following is true:
 *     - an invalid value was specified for the parameter MEMode
 *     - a negative or zero value was specified for the SearchRanges(16x16, 8x8, 4x4) in pMBOptions
 *
 */
 OMXResult omxVCM4P10_MEInit (
     OMXVCM4P10MEMode MEMode,
     const OMXVCM4P10MEParams *pMEParams,
     void *pMESpec);

/**
 * Function: omxVCM4P10_BlockMatch_Integer
 *
 * Description:
 *  Performs integer block match.  Returns best MV and associated cost.
 *
 * Remarks:
 *
 * Parameters:
 *  [in]	pSrcOrgY - Pointer to the top-left corner of the current block.
 *                    In case iBlockWidth==4,  4-byte aligned.
 *                    In case iBlockWidth==8,  8-byte aligned.
 *                    In case iBlockWidth==16, 16-byte aligned.
 *	[in]	pSrcRefY - Pointer to the top-left corner of the co-located block in the reference picture.
 *                    If iBlockWidth==4,  4-byte alignment required.
 *                    If iBlockWidth==8,  8-byte alignment required.
 *                    If iBlockWidth==16, 16-byte alignment required.
 *	[in]	nSrcOrgStep - Stride of the original picture plane, expressed in terms of integer pixels.
 *                       Must be multiple of iBlockWidth.
 *	[in]	nSrcRefStep - Stride of the reference picture plane, expressed in terms of integer pixels
 *	[in]    pRefRect - pointer to the valid reference rectangle inside the reference picture plane
 *	[in]    nCurrPointPos - position of the current block in the current plane
 *	[in]  iBlockWidth - Width of the current block, expressed in terms of integer pixels;must be equal to
 *                       either 4, 8, or 16.
 *	[in]  iBlockHeight - Height of the current block, expressed in terms of integer pixels;must be equal to
 *                        either 4, 8, or 16.
 *	[in]	nLamda - Lamda factor; used to compute motion cost
 *	[in]  pMVPred - Predicted MV; used to compute motion cost, expressed in terms of 1/4-pel units
 *	[in]	pMVCandidate - Candidate MV; used to initialize the motion search, expressed in terms of integer pixels
 *	[in]	pMESpec - pointer to the ME specification structure
 *  [out]	pBestMV - Best MV resulting from integer search, expressed in terms of 1/4-pel units
 *	[out] pBestCost - Motion cost associated with the best MV; computed as SAD+Lamda*BitsUsedByMV
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *
 */
 OMXResult omxVCM4P10_BlockMatch_Integer (
     const OMX_U8 *pSrcOrgY,
     OMX_S32 nSrcOrgStep,
     const OMX_U8 *pSrcRefY,
     OMX_S32 nSrcRefStep,
	 const OMXRect *pRefRect,
	 const OMXVCM4P2Coordinate *pCurrPointPos,
     OMX_U8 iBlockWidth,
     OMX_U8 iBlockHeight,
     OMX_U32 nLamda,
     const OMXVCMotionVector *pMVPred,
     const OMXVCMotionVector *pMVCandidate,
     OMXVCMotionVector *pBestMV,
     OMX_S32 *pBestCost,
     void *pMESpec);


/**
 * Function: omxVCM4P10_BlockMatch_Half
 *
 * Description:
 * Performs a half-pel block match using results from a prior integer search.
 * Returns the best MV and associated cost.  This function estimates the half-pixel
 * motion vector by interpolating the integer resolution motion vector referenced by
 * the input parameter pSrcDstBestMV, i.e., the initial integer MV is generated
 * externally.  The function omxVCM4P10_BlockMatch_Integer may be used for integer
 * motion estimation.
 *
 * Remarks:
 *
 * Parameters:
 * [in] pSrcOrgY - Pointer to the current position in original picture plane.
 *                    In case iBlockWidth==4,  4-byte aligned.
 *                    In case iBlockWidth==8,  8-byte aligned.
 *                    In case iBlockWidth==16, 16-byte aligned.
 * [in] pSrcRefY - Pointer to the top-left corner of the co-located block in the reference picture
 *                    If iBlockWidth==4, 4-byte alignment required.
 *                    If iBlockWidth==8, 8-byte alignment required.
 *                    If iBlockWidth==16, 16-byte alignment required.
 * [in] nSrcOrgStep - Stride of the original picture plane in terms of full pixels
 *                       Must be multiple of iBlockWidth.

 * [in] nSrcRefStep - Stride of the reference picture plane in terms of full pixels
 * [in] iBlockWidth - Width of the current block in terms of full pixels;must be equal to either 4, 8, or 16.
 * [in] iBlockHeight - Height of the current block in terms of full pixels;must be equal to either 4, 8, or 16.
 * [in]	nLamda - Lamda factor, used to compute motion cost
 * [in] pMVPred - Predicted MV, represented in terms of 1/4-pel units; used to compute motion cost
 * [in] pSrcDstBestMV - The best MV resulting from a prior integer search, represented in terms of 1/4-pel units
 * [out]	pSrcDstBestMV - Best MV resulting from the half-pel search, expressed in terms of 1/4-pel units
 * [out]	pBestCost - Motion cost associated with the best MV; computed as SAD+Lamda*BitsUsedByMV
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *
 */
OMXResult omxVCM4P10_BlockMatch_Half(
    const OMX_U8 *pSrcOrgY,
    OMX_S32 nSrcOrgStep,
    const OMX_U8 *pSrcRefY,
    OMX_S32 nSrcRefStep,
    OMX_U8 iBlockWidth,
    OMX_U8 iBlockHeight,
    OMX_U32 nLamda,
    const OMXVCMotionVector *pMVPred,
    OMXVCMotionVector *pSrcDstBestMV,
    OMX_S32 *pBestCost);


/**
 * Function: omxVCM4P10_BlockMatch_Quarter
 *
 * Description:
 * Performs a quarter-pel block match using results from a prior half-pel search.  Returns
 * the best MV and associated cost.  This function estimates the quarter-pixel motion vector
 * by interpolating the half-pel resolution motion vector referenced by the input parameter
 * pSrcDstBestMV, i.e., the initial half-pel MV is generated externally.  The function
 * omxVCM4P10_BlockMatch_Half may be used for half-pel motion estimation.
 *
 * Remarks:
 *
 * Parameters:
 * [in] pSrcOrgY - Pointer to the current position in original picture plane.
 *                    In case iBlockWidth==4,  4-byte aligned.
 *                    In case iBlockWidth==8,  8-byte aligned.
 *                    In case iBlockWidth==16, 16-byte aligned.
 * [in] pSrcRefY - Pointer to the top-left corner of the co-located block in the reference picture
 *                    In case iBlockWidth==4,  4-byte aligned.
 *                    In case iBlockWidth==8,  8-byte aligned.
 *                    In case iBlockWidth==16, 16-byte aligned.
 * [in] nSrcOrgStep - Stride of the original picture plane in terms of full pixels
 *                       Must be multiple of iBlockWidth.
 * [in] nSrcRefStep - Stride of the reference picture plane in terms of full pixels
 * [in] iBlockWidth - Width of the current block in terms of full pixels;must be equal to either 4, 8, or 16.
 * [in] iBlockHeight - Height of the current block in terms of full pixels;must be equal to either 4, 8, or 16.
 * [in] nLamda - Lamda factor, used to compute motion cost
 * [in] pMVPred - Predicted MV, represented in terms of 1/4-pel units; used to compute motion cost
 * [in] pSrcDstBestMV - The best MV resulting from a prior half-pel search, represented in terms of 1/4-pel units
 * [out]	pSrcDstBestMV - Best MV resulting from the quarter-pel search, expressed in terms of 1/4-pel units
 * [out]	pBestCost - Motion cost associated with the best MV; computed as SAD+Lamda*BitsUsedByMV
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 */
OMXResult omxVCM4P10_BlockMatch_Quarter(
    const OMX_U8 *pSrcOrgY,
    OMX_S32 nSrcOrgStep,
    const OMX_U8 *pSrcRefY,
    OMX_S32 nSrcRefStep,
    OMX_U8 iBlockWidth,
    OMX_U8 iBlockHeight,
    OMX_U32 nLamda,
    const OMXVCMotionVector *pMVPred,
    OMXVCMotionVector *pSrcDstBestMV,
    OMX_S32 *pBestCost);


/** Function: omxVCM4P10_MotionEstimationMB */
 /* Description: */
 /* Performs MB-level motion estimation and selects best motion estimation strategy from */
 /* the set of modes supported in baseline profile ISO/IEC 14496-10. */
 /* Remarks: 														 */
 /* Parameters:														 
 * [in] pSrcCurrBuf   Pointer to the current position in original picture plane; 16-byte alignment required
 * [in] pSrcRefBufList   Pointer to an array with 15 entries. Each entry points to the top-left corner of
 *                         the co-located MB in a reference picture. The array is filled from low-to-high with valid reference
 *                         frame pointers; the unused high entries should be set to NULL. Ordering of the reference frames
 *                         should follow ISO/IEC 14496-10 subclause 8.2.4 "Decoding Process for Reference Picture Lists."
 *                         The entries must be 16-byte aligned.
 * [in] pSrcRecBuf   Pointer to the top-left corner of the co-located MB in the reconstructed picture; must
 *                     be 16-byte aligned.
 * [in] SrcCurrStep   Width of the original picture plane in terms of full pixels; must be a multiple of 16.
 * [in] SrcRefStep   Width of the reference picture plane in terms of full pixels; must be a multiple of 16.
 * [in] SrcRecStep   Width of the reconstructed picture plane in terms of full pixels; must be a multiple of 16.
 * [in] pRefRect   Pointer to the valid reference rectangle; relative to the image origin.
 * [in] pCurrPointPos   Position of the current macroblock in the current plane.
 * [in] Lambda   Lagrange factor for computing the cost function
 * [in] pMESpec   Pointer to the motion estimation specification structure; must have been allocated and
 *                  initialized prior to calling this function.
 * [in] pMBInter   Array, of dimension four, containing pointers to information associated with four
 *                   adjacent type INTER MBs (Left, Top, Top-Left, Top-Right). Any pointer in the array may be set
 *                   equal to NULL if the corresponding MB doesn't exist or is not of type INTER.
 *                     -- pMBInter[0] - Pointer to left MB information
 *                     -- pMBInter[1] - Pointer to top MB information
 *                     -- pMBInter[2] - Pointer to top-left MB information
 *                     -- pMBInter[3] - Pointer to top-right MB information.
 * [in]pMBIntra   Array, of dimension four, containing pointers to information associated with four
 *                 adjacent type INTRA MBs (Left, Top, Top-Left, Top-Right). Any pointer in the array may be set
 *                 equal to NULL if the corresponding MB doesn't exist or is not of type INTRA.
 *                     -- pMBIntra[0] - Pointer to left MB information
 *                     -- pMBIntra[1] - Pointer to top MB information
 *                     -- pMBIntra[2] - Pointer to top-left MB information
 *                     -- pMBIntra[3] - Pointer to top-right MB information
 * [in] pSrcDstMBCurr   Pointer to information structure for the current MB. The following entries should
 *                        be set prior to calling the function: sliceID - the number of the slice the to which the current MB belongs.
 * [out] pDstCost   Pointer to the minimum motion cost for the current MB.
 * [out] pSrcDstMBCurr   Pointer to updated information structure for the current MB after MB-level
 *                         motion estimation has been completed. The following fields are updated by the ME function.
 *                         Together this information quantifies the MB-level ME search results:
 *                           -- MbType,
 *                           -- subMBType[4]
 *                           -- pMV0[4][4]
 *                           -- pMVPred[4][4]
 *                           -- pRefL0Idx[4]
 *                           -- Intra16x16PredMode
 *                           -- pIntra4x4PredMode[4][4]
 * Returns
 * If the function runs without error, it returns OMX_StsNoErr.
 * If one of the following cases occurs, the function returns OMX_StsBadArgErr:
     -One of more of the following pointers is NULL: pSrcCurrBuf, pSrcRefBufList,
        pSrcRecBuf, pRefRect, pCurrPointPos, pMESpec, pMBInter, pMBIntra,
        pSrcDstMBCurr, pDstCost, pSrcRefBufList[0]
     -SrcRefStep, SrcRecStep are not multiples of 16
     -Either iBlockWidth or iBlockHeight are equal to values other than 4, 8, or 16.
     -Any alignment restrictions are violated
 */

OMXResult omxVCM4P10_MotionEstimationMB(
    const OMX_U8 *pSrcCurrBuf, 
	OMX_S32 SrcCurrStep, 
	const OMX_U8 *pSrcRefBufList[15],
	OMX_S32 SrcRefStep,
	const OMX_U8 *pSrcRecBuf, 
	OMX_S32 SrcRecStep,
	const OMXRect *pRefRect,
	const OMXVCM4P2Coordinate *pCurrPointPos,
	OMX_U32 Lambda,
	void *pMESpec,
	const OMXVCM4P10MBInfoPtr *pMBInter, 
	const OMXVCM4P10MBInfoPtr *pMBIntra,
    OMXVCM4P10MBInfoPtr pSrcDstMBCurr,
	OMX_INT *pDstCost
);

/**
 * Function: omxVCM4P10_SAD_4x
 *
 * Description:
 * This function calculate the SAD for 4x8 and 4x4 blocks.
 *
 * Remarks:
 *
 * [in]		pSrcOrg		Pointer to the original block. Must be 4-byte aligned
 * [in]		iStepOrg	Step of the original block buffer. Must be multiple of 4.
 * [in]		pSrcRef		Pointer to the reference block
 * [in]		iStepRef	Step of the reference block buffer. Must be multiple of 4.
 * [in]		iHeight		Height of the block;must be equal to either 4 or 8.
 * [out]	pDstSAD		Pointer of result SAD
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - At least one of the following pointers is NULL: pSrcOrg, pSrcRef, pDstSAD.
 *    - pSrcOrg is not 4 byte aligned.
 *    - iStepOrg <= 0 or iStepOrg is not a multiple of 4.
 *    - iStepRef <= 0 or iStepRef is not a multiple of 4.
 *    - iHeight is not 4, 8
 *
 */
OMXResult omxVCM4P10_SAD_4x(
	const OMX_U8 *pSrcOrg,
	OMX_U32 	iStepOrg,
	const OMX_U8 *pSrcRef,
	OMX_U32 	iStepRef,
	OMX_S32		*pDstSAD,
	OMX_U32		iHeight
);

/**
 * Function: omxVCM4P10_SADQuar_4x
 *
 * Description:
 * This function calculates the SAD between one block (pSrc) and the
 * average of the other two (pSrcRef0 and pSrcRef1) for 4x8 or 4x4 blocks
 * Rounding is applied according to the convention (a+b+1)>>1.
 *
 * Remarks:
 *
 * [in]		pSrc			Pointer to the original block. Must be 4-byte aligned
 * [in]		pSrcRef0		Pointer to reference block 0
 * [in]		pSrcRef1		Pointer to reference block 1
 * [in]		iSrcStep 		Step of the original block buffer. Must be multiple of 4.
 * [in]		iRefStep0		Step of reference block 0. Must be multiple of 4.
 * [in]		iRefStep1 	Step of reference block 1. Must be multiple of 4.
 * [in]		iHeight			Height of the block;must be equal to either 4 or 8.
 * [out]	pDstSAD			Pointer of result SAD
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - At least one of the following pointers is NULL: pSrcOrg, pSrcRef0, pSrcRef1, pDstSAD.
 *    - pSrcOrg is not 4 byte aligned.
 *    - iStepOrg <= 0 or iStepOrg is not a multiple of 4.
 *    - iStepRef0 <= 0 or iStepRef0 is not a multiple of 4.
 *    - iStepRef1 <= 0 or iStepRef1 is not a multiple of 4.
 *    - iHeight is not 4, 8
 *
 */
OMXResult omxVCM4P10_SADQuar_4x(
	  const OMX_U8 *pSrc,
      const OMX_U8 *pSrcRef0,
	  const OMX_U8 *pSrcRef1,
      OMX_U32 	iSrcStep,
      OMX_U32	iRefStep0,
      OMX_U32	iRefStep1,
      OMX_U32 *pDstSAD,
      OMX_U32   iHeight
);

/**
 * Function: omxVCM4P10_SADQuar_8x
 *
 * Description:
 * This function calculates the SAD between one block (pSrc) and the
 * average of the other two (pSrcRef0 and pSrcRef1) for 8x16 or 8x8
 * or 8x4 blocks. The average is computed as (a+b+1)/2.
 *
 * Remarks:
 *
 * [in]		pSrc				Pointer to the original block. Must be 8-byte aligned.
 * [in]		pSrcRef0		Pointer to reference block 0
 * [in]		pSrcRef1		Pointer to reference block 1
 * [in]		iSrcStep 		Step of the original block buffer. Must be multiple of 8.
 * [in]		iRefStep0		Step of reference block 0. Must be multiple of 8.
 * [in]		iRefStep1 	Step of reference block 1. Must be multiple of 8.
 * [in]		iHeight			Height of the block;must be equal to either 4, 8 or 16
 * [out]	pDstSAD			Pointer of result SAD
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - At least one of the following pointers is NULL: pSrcOrg, pSrcRef0, pSrcRef1, pDstSAD.
 *    - pSrcOrg is not 8 byte aligned.
 *    - iStepOrg <= 0 or iStepOrg is not a multiple of 8.
 *    - iStepRef0 <= 0 or iStepRef0 is not a multiple of 8.
 *    - iStepRef1 <= 0 or iStepRef1 is not a multiple of 8.
 *    - iHeight is not 4, 8 or 16
 *
 */
OMXResult omxVCM4P10_SADQuar_8x(
	const OMX_U8 *pSrc,
    const OMX_U8 *pSrcRef0,
	const OMX_U8 *pSrcRef1,
    OMX_U32 	iSrcStep,
    OMX_U32		iRefStep0,
    OMX_U32		iRefStep1,
    OMX_U32 *pDstSAD,
    OMX_U32   iHeight
);

/**
 * Function: omxVCM4P10_SADQuar_16x
 *
 * Description:
 * This function calculates the SAD between one block (pSrc) and the
 * average of the other two (pSrcRef0 and pSrcRef1) for 16x16 or 16x8
 * blocks. Rounding is applied according to the convention (a+b+1)>>1.
 *
 * Remarks:
 *
 * [in]		pSrc				Pointer to the original block. Must be 16-byte aligned.
 * [in]		pSrcRef0		Pointer to reference block 0
 * [in]		pSrcRef1		Pointer to reference block 1
 * [in]		iSrcStep 		Step of the original block buffer. Must be multiple of 16.
 * [in]		iRefStep0		Step of reference block 0. Must be multiple of 16.
 * [in]		iRefStep1 	Step of reference block 1. Must be multiple of 16.
 * [in]		iHeight			Height of the block;must be equal to either 8 or 16
 * [out]	pDstSAD			Pointer of result SAD
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - At least one of the following pointers is NULL: pSrcOrg, pSrcRef0, pSrcRef1, pDstSAD.
 *    - pSrcOrg is not 16 byte aligned.
 *    - iStepOrg <= 0 or iStepOrg is not a multiple of 16.
 *    - iStepRef0 <= 0 or iStepRef0 is not a multiple of 16.
 *    - iStepRef1 <= 0 or iStepRef1 is not a multiple of 16.
 *    - iHeight is not 8 or 16
 *
 */
OMXResult omxVCM4P10_SADQuar_16x(
	const OMX_U8 *pSrc,
    const OMX_U8 *pSrcRef0,
    const OMX_U8 *pSrcRef1,
    OMX_U32 	iSrcStep,
    OMX_U32		iRefStep0,
    OMX_U32		iRefStep1,
    OMX_U32 *pDstSAD,
    OMX_U32   iHeight
);

/**
 * Function: omxVCM4P10_SATD_4x4
 *
 * Description:
 * This function calculate the SATD for a 4x4 block.
 * SATD is calculated by imposing Hadarmard transform on the
 * difference block and then calculating the sum of absolute
 * values of the coefficients
 *
 * Remarks:
 *
 * [in]		pSrcOrg			Pointer to the original block. Must be 4-byte aligned.
 * [in]		iStepOrg		Step of the original block buffer. Must be multiple of 4.
 * [in]		pSrcRef			Pointer to the reference block. Must be 4-byte aligned.
 * [in]		iStepRef		Step of the reference block buffer. Must be multiple of 4.
 * [out]	pDstSAD			Pointer of result SAD
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *    - At least one of the following pointers is NULL: pSrcOrg, pSrcRef, pDstSAD.
 *    - pSrcOrg or pSrcRef is not 4 byte aligned.
 *    - iStepOrg <= 0 or iStepOrg is not a multiple of 4.
 *    - iStepRef <= 0 or iStepRef is not a multiple of 4.
 *
 */
OMXResult omxVCM4P10_SATD_4x4(
	const OMX_U8 *pSrcOrg,
	OMX_U32     iStepOrg,
	const OMX_U8 *pSrcRef,
	OMX_U32		iStepRef,
	OMX_U32 *pDstSAD
);


/**
 * Function: omxVCM4P10_InterpolateHalfHor_Luma
 *
 * Description:
 * This function performs interpolation for two horizontal 1/2-pel positions - (-1/2,0)
 * and (1/2, 0) - around a full-pel position .
 *
 * Remarks:
 *
 *	[in]	pSrc			Pointer to top-left corner of block used to interpolate
 													in the reconstructed frame plane
 *	[in]	iSrcStep	Step of the source buffer.
 *	[in]	iDstStep	Step of the destination(interpolation) buffer.
 *	[in]	iWidth		Width of the current block;must be equal to either 4, 8, or 16
 *	[in]	iHeight		Height of the current block;must be equal to either 4, 8, or 16
 *	[out]	pDstLeft	Pointer to the interpolation buffer of the left 1/2-pel
 *									position (-1/2, 0)
 *                    In case iWidth==4,  4-byte aligned.
 *                    In case iWidth==8,  8-byte aligned.
 *                    In case iWidth==16, 16-byte aligned.
 *	[out]	pDstRight	Pointer to the interpolation buffer of the right 1/2-pel
 *									position (1/2, 0)
 *                    In case iWidth==4,  4-byte aligned.
 *                    In case iWidth==8,  8-byte aligned.
 *                    In case iWidth==16, 16-byte aligned.
 *
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 * If one of the following cases occurs, the function returns OMX_StsBadArgErr:
 *   pSrc or pDstLeft or pDstRight is NULL.
 *	 iWidth or iHeight is out of range {4, 8, 16}.
 *	 iWidth is equal to  4, but pDstLeft or pDstRight is not  4 byte aligned.
 *	 iWidth is equal to  8, but pDstLeft or pDstRight is not  8 byte aligned.
 *	 iWidth is equal to 16, but pDstLeft or pDstRight is not 16 byte aligned.
 *
 */
OMXResult omxVCM4P10_InterpolateHalfHor_Luma(
        const OMX_U8 *pSrc,
		OMX_U32 	iSrcStep,
		OMX_U8		*pDstLeft,
		OMX_U8		*pDstRight,
		OMX_U32 	iDstStep,
		OMX_U32 	iWidth,
		OMX_U32 	iHeight
);

/**
 * Function: omxVCM4P10_InterpolateHalfVer_Luma
 *
 * Description:
 * This function performs interpolation for two verticall 1/2-pel positions - (0, -1/2)
 * and (0, 1/2) - around a full-pel position.
 *
 * Remarks:
 *
 *	[in]	pSrc			Pointer to top-left corner of block used to interpolate
 *												in the reconstructed frame plane
 *	[in]	iSrcStep	Step of the source buffer.
 *	[in]	iDstStep	Step of the destination(interpolation) buffer.
 *	[in]	iWidth		Width of the current block;must be equal to either 4, 8, or 16
 *	[in]	iHeight		Height of the current block;must be equal to either 4, 8, or 16
 *	[out]	pDstUp		Pointer to the interpolation buffer of the above 1/2-pel
 *									position (0, -1/2)
 *                    In case iWidth==4,  4-byte aligned.
 *                    In case iWidth==8,  8-byte aligned.
 *                    In case iWidth==16, 16-byte aligned.
 *	[out]	pDstDown	Pointer to the interpolation buffer of the lower 1/2-pel
 *									position (0, 1/2)
 *                    In case iWidth==4,  4-byte aligned.
 *                    In case iWidth==8,  8-byte aligned.
 *                    In case iWidth==16, 16-byte aligned.
 *
 * Return Value:
 * If the function runs without error, it returns OMX_StsNoErr.
 * If one of the following cases occurs, the function returns OMX_StsBadArgErr:
 *   pSrc or pDstUp or pDstDown is NULL.
 *	 iWidth or iHeight is out of range {4, 8, 16}.
 *	 iWidth is equal to  4, but pDstUp or pDstDown is not  4 byte aligned.
 *	 iWidth is equal to  8, but pDstUp or pDstDown is not  8 byte aligned.
 *	 iWidth is equal to 16, but pDstUp or pDstDown is not 16 byte aligned.
 *
 */
 OMXResult omxVCM4P10_InterpolateHalfVer_Luma(
	 const OMX_U8	*pSrc,
	 OMX_U32 		iSrcStep,
 	 OMX_U8			*pDstUp,
 	 OMX_U8			*pDstDown,
 	 OMX_U32 		iDstStep,
 	 OMX_U32 		iWidth,
 	 OMX_U32 		iHeight
);

/**
 * Function: omxVCM4P10_Average_4x
 *
 * Description:
 * This function calculates the average of two 4x4 or 4x8 blocks and stores the result.
 * The average is computed as (a+b+1)/2
 *
 * Remarks:
 *
 *	[in]	pPred0			Pointer to the top-left corner of reference block 0
 *	[in]	pPred1			Pointer to the top-left corner of reference block 1
 *	[in]	iPredStep0	Step of reference block 0. Must be multiple of 4.
 *	[in]	iPredStep1	Step of reference block 1. Must be multiple of 4.
 *	[in]	iDstStep 		Step of the destination buffer. Must be multiple of 4.
 *	[in]	iHeight			Height of the blocks, must be either 4 or 8.
 *	[out]	pDstPred		Pointer to the destination buffer. Must be 4-byte aligned
 *
 * Return Value:
 * OMX_StsNoErr -no error
 * OMX_StsBadArgErr -bad arguments
 *    -At least one of the following pointers is NULL: pPred0, pPred1, pDstPred.
 *    -pDstPred is not 4 byte aligned.
 *    -iPredStep0 <= 0 or iPredStep0 is not a multiple of 4.
 *    -iPredStep1 <= 0 or iPredStep1 is not a multiple of 4.
 *    -iDstStep <= 0 or iDstStep is not a multiple of 4.
 *    -iHeight is not 4 or 8
 *
 */
 OMXResult omxVCM4P10_Average_4x (
	 const OMX_U8		*pPred0,
	 const OMX_U8		*pPred1,
	 OMX_U32		iPredStep0,
	 OMX_U32		iPredStep1,
	 OMX_U8			*pDstPred,
	 OMX_U32		iDstStep,
	 OMX_U32		iHeight
);




/**
 * Function: omxVCM4P10_TransformQuant_ChromaDC
 *
 * Description:
 * This function performs 2x2 hadamard transform of chroma DC coefficients and then
 * quantize the coefficients.
 *
 * Remarks:
 *
 *	[in]	pSrcDst		Pointer to the 2x2 array of chroma DC coefficients. Must be 8-byte aligned.
 *	[in]	iQP			Quantization parameter.must be in the range [0,51].
 *	[in]	bIntra		Indicate whether this is an INTRA block. 1-INTRA, 0-INTER
 *	[out]	pSrcDst		Pointer to transformed and quantized coefficients.  Must be 8-byte aligned.
 *
 * Return Value:
 * Standard OMXResult value.
 *
 */
OMXResult omxVCM4P10_TransformQuant_ChromaDC(
	OMX_S16		*pSrcDst,
	OMX_U32		iQP,
	OMX_U8		bIntra
);

/**
 * Function:omxVCM4P10_TransformQuant_LumaDC
 *
 * Description:
 * This function performs 4x4 hadamard transform of luma DC coefficients and then
 * quantize the coefficients.
 *
 * Remarks:
 *
 *	[in]	pSrcDst	Pointer to the 4x4 array of luma DC coefficients. Must be 8-byte aligned.
 *	[in]	iQP		Quantization parameter.must be in the range [0,51].
 *	[out]	pSrcDst	Pointer to transformed and quantized coefficients. Must be 8-byte aligned.
 *
 * Return Value:
 * Standard OMXResult value.
 *
 */
OMXResult omxVCM4P10_TransformQuant_LumaDC(
	OMX_S16		*pSrcDst,
	OMX_U32		iQP
);

/**
 * Function:omxVCM4P10_InvTransformDequant_LumaDC
 *
 * Description:
 * This function performs inverse 4x4 hadamard transform and then dequantize the
 * coefficients.
 *
 * Remarks:
 *
 *	[in]	pSrc		Pointer to the 4x4 array of the 4x4 hadamard transformed
 *						and quantized coefficients. Must be 8-byte aligned.
 *	[in]	iQP			Quantization parameter.must be in the range [0,51].
 *	[out]	pDst		Pointer to inverse-transformed and dequantized coefficients. Must be 8-byte aligned.
 *
 * Return Value:
 * Standard OMXResult value.
 *
 */
OMXResult omxVCM4P10_InvTransformDequant_LumaDC(
	const OMX_S16	*pSrc,
	OMX_S16			*pDst,
	OMX_U32			iQP
);

/**
 * Function:omxVCM4P10_InvTransformDequant_ChromaDC
 *
 * Description:
 * This function performs inverse 2x2 hadamard transform and then dequantize the
 * coefficients.
 *
 * Remarks:
 *
 *	[in]	pSrc	Pointer to the 2x2 array of the 2x2 hadamard transformed and
 *							quantized coefficients.  Must be 8-byte aligned.
 *	[in]	iQP		Quantization parameter.
 *	[out]	pDst	Pointer to inverse-transformed and dequantized coefficients.  Must be 8-byte aligned.
 *
 * Return Value:
 * Standard OMXResult value.
 *
 */
OMXResult omxVCM4P10_InvTransformDequant_ChromaDC(
	const OMX_S16	*pSrc,
	OMX_S16			*pDst,
	OMX_U32			iQP
);

/**
 * Function:omxVCM4P10_InvTransformResidualAndAdd
 *
 * Description:
 * This function performs inverse 4x4 integer transform to produce the difference
 * signal and then add the difference to prediction to get the reconstructed signal.
 *
 * Remarks:
 *
 *	[in]	pSrcPred			Pointer to prediction signal. Must be 4-byte aligned.
 *	[in]	pDequantCoeff	Pointer to the transformed coefficients.  Must be 8-byte aligned.
 *	[in]	iSrcPredStep	Step of the prediction buffer. Must be multiple of 4.
 *	[in]	iDstReconStep	Step of the destination reconstruction buffer. Must be multiple of 4.
 *	[in]	bAC						Indicate whether there is AC coefficients in the coefficients matrix.
 *	[out]	pDstRecon			Pointer to the destination reconstruction buffer.  Must be 4-byte aligned.
 *
 * Return Value:
 * Standard OMXResult value.
 *
 */
OMXResult omxVCM4P10_InvTransformResidualAndAdd(
	const OMX_U8	*pSrcPred,
	const OMX_S16	*pDequantCoeff,
	OMX_U8			*pDstRecon,
	OMX_U32 	iSrcPredStep,
	OMX_U32		iDstReconStep,
	OMX_U8		bAC
);

/**
 * Function:omxVCM4P10_SubAndTransformQDQResidual
 *
 * Description:
 * This function substracts the prediction signal from original signal to produce the difference
 * signal and then performs 4x4 integer transform and quantization. The quantized transformed
 * coefficients will be stored pDstQuantCoeff.
 * This function can also output dequantized coefficients or unquantized DC coefficients optionally
 * by setting the pointers pDstDeQuantCoeff, pDCCoeff. (See parameter specification)
 *
 * Remarks:
 *
 *	[in]	pSrcOrg					Pointer to original singal. Must be 4-byte aligned.
 *	[in]	pSrcPred				Pointer to prediction signal. Must be 4-byte aligned.
 *	[in]	iSrcOrgStep			Step of the original signal buffer. Must be multiple of 4.
 *	[in]	iSrcPredStep		Step of the prediction signal buffer. Must be multiple of 4.
 *	[in]	pNumCoeff				Number of non-zero coefficients after quantization.
 *															If don't need, set this to	NULL.
 *	[in]	nThreshSAD			Zero-block early detection threshold. If don't need,
 *															set this to 0.
 *	[in]	iQP							Quantization parameter.
 *	[in]	bIntra					Indicate whether this is an INTRA block. 1-INTRA, 0-INTER
 *	[out]	pDstQuantCoeff		Pointer to the quantized transformed coefficients.  Must be 8-byte aligned.
 *	[out]	pDstDeQuantCoeff	Pointer to the dequantized transformed coefficients
 *													if this parameter is not equal to NULL. Must be 8-byte aligned.
 *	[out]	pDCCoeff					Pointer to the unquantized DC coefficient if this parameter
 *													is not equal to	NULL.
 *
 * Return Value:
 * Standard OMXResult value.
 *
 */
 OMXResult omxVCM4P10_SubAndTransformQDQResidual (
	 const OMX_U8	*pSrcOrg,
	 const OMX_U8	*pSrcPred,
	 OMX_U32		iSrcOrgStep,
	 OMX_U32		iSrcPredStep,
	 OMX_S16		*pDstQuantCoeff,
	 OMX_S16		*pDstDeQuantCoeff,
	 OMX_S16		*pDCCoeff,
	 OMX_S8			*pNumCoeff,
	 OMX_U32		nThreshSAD,
	 OMX_U32		iQP,
	 OMX_U8		    bIntra
);

/**
 * Function:omxVCM4P10_GetVLCInfo
 *
 * Description:
 * This function extracts run-length encoding (RLE) information from the coefficient matrix. The results are
 * returned in an OMXVCM4P10VLCInfo structure. *
 * Remarks:
 *
 *	[in]	pSrcCoeff		pointer to the transform coefficient matrix. 8-byte alignment required.
 *	[in]	pScanMatrix		pointer to the scan order definition matrix. For a luma block the scan matrix should
 *                          follow section 8.5.4 of ISO/IEC 14496-10, and should contain the values 0, 1, 4, 8, 5, 2, 3, 6, 9, 12, 13,
 *                          10, 7, 11, 14, 15. For a chroma block, the scan matrix should contain the values 0, 1, 2, 3.
 *	[in]	bAC				indicates presence of a DC coefficient; 0 = DC coefficient present, 1= DC coefficient absent.
 *	[in]	MaxNumCoef		specifies the number of coefficients contained in the transform coefficient matrix,
 *                           pSrcCoeff. The value should be 16 for blocks of type LUMADC, LUMAAC, LUMALEVEL, and
 *                           CHROMAAC. The value should be 4 for blocks of type CHROMADC.
 *	[out]	pDstVLCInfo     pointer to structure that stores information for run-length coding.
 *
 * Return Value:
 * Standard OMXResult value.
 *
 */
OMXResult omxVCM4P10_GetVLCInfo (
	const OMX_S16 *pSrcCoeff,
	const OMX_U8 *pScanMatrix, 
	OMX_U8 bAC, 
	OMX_U32 MaxNumCoef, 
	OMXVCM4P10VLCInfo *pDstVLCInfo
);


/**
 * EndDomain: M4P10
 */



#ifdef __cplusplus
}
#endif

#endif /** end of #define _OMXVC_H_ */

/** EOF */
