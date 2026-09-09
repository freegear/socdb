/**
 *  omxVCM4P2_MCReconBlock.c
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
 * MPEG4 motion compensation prediction for an 8x8 block using 
 * interpolation
 * 
 */
 
#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"

/**
 * Function: armVCM4P2_HalfPelVer
 *
 * Description:
 * Performs half pel motion compensation for an 8x8 block using vertical 
 * interpolation described in ISO/IEC 14496-2, subclause 7.6.2.
 *
 * Remarks:
 *
 * Parameters:
 * [in] pSrc        pointer to the block in the reference plane.
 * [in] srcStep     distance between the start of consecutive lines
 *                  in the reference plane, in bytes; must be a multiple
 *                  of 8.
 * [in] rndVal      rounding control parameter: 0 - disabled; 1 - enabled.
 * [out] pDst       pointer to the linaer 8x8 destination buffer;
 *
 */
static OMXVoid armVCM4P2_HalfPelVer(
      const OMX_U8 *pSrc,
      OMX_INT srcStep, 
      OMX_U8 *pDst,
      OMX_INT rndVal)
{
  const OMX_U8 *pTempSrc1;
  const OMX_U8 *pTempSrc2;
  OMX_INT y, x;
  
  pTempSrc1 = pSrc;  
  pTempSrc2 = pSrc + srcStep;
  srcStep -= 8;
  for (y = 0; y < 8; y++)
  {
    for (x = 0; x < 8; x++)
    {
      *pDst++ = ((*pTempSrc1++ + *pTempSrc2++) + 1 - rndVal) >> 1;
    }
    pTempSrc1 += srcStep;
    pTempSrc2 += srcStep;
  }
}

/**
 * Function: armVCM4P2_HalfPelHor
 *
 * Description:
 * Performs half pel motion compensation for an 8x8 block using horizontal 
 * interpolation described in ISO/IEC 14496-2, subclause 7.6.2.
 *
 * Remarks:
 *
 * Parameters:
 * [in] pSrc        pointer to the block in the reference plane.
 * [in] srcStep     distance between the start of consecutive lines
 *                  in the reference plane, in bytes; must be a multiple
 *                  of 8.
 * [in] rndVal      rounding control parameter: 0 - disabled; 1 - enabled.
 * [out] pDst       pointer to the linaer 8x8 destination buffer;
 *
 */
static OMXVoid armVCM4P2_HalfPelHor(
      const OMX_U8 *pSrc,
      OMX_INT srcStep, 
      OMX_U8 *pDst,
      OMX_INT rndVal)
{
  const OMX_U8 *pTempSrc1;
  const OMX_U8 *pTempSrc2;
  OMX_INT y, x;
  
  pTempSrc1 = pSrc;
  pTempSrc2 = pTempSrc1 + 1;

  srcStep -= 8;
  for (y=0; y<8; y++)
  {
    for (x=0; x<8; x++)
    {
      *pDst++ = ((*pTempSrc1++ + *pTempSrc2++) + 1 - rndVal) >> 1;
    }
    pTempSrc1 += srcStep;
    pTempSrc2 += srcStep;
  }
}


/**
 * Function: armVCM4P2_HalfPelVerHor
 *
 * Description:
 * Performs half pel motion compensation for an 8x8 block using both 
 * horizontal and vertical interpolation described in ISO/IEC 14496-2,
 * subclause 7.6.2.
 *
 * Remarks:
 *
 * Parameters:
 * [in] pSrc        pointer to the block in the reference plane.
 * [in] srcStep     distance between the start of consecutive lines
 *                  in the reference plane, in bytes; must be a multiple
 *                  of 8.
 * [in] rndVal      rounding control parameter: 0 - disabled; 1 - enabled.
 * [out] pDst       pointer to the linaer 8x8 destination buffer;
 *
 */
static OMXVoid armVCM4P2_HalfPelVerHor(
      const OMX_U8 *pSrc,
      OMX_INT srcStep, 
      OMX_U8 *pDst,
      OMX_INT rndVal)
{
  const OMX_U8 *pTempSrc1;
  const OMX_U8 *pTempSrc2;
  const OMX_U8 *pTempSrc3;
  const OMX_U8 *pTempSrc4;
  OMX_INT y, x;

  pTempSrc1 = pSrc;
  pTempSrc2 = pSrc + srcStep;
  pTempSrc3 = pSrc + 1;
  pTempSrc4 = pSrc + srcStep + 1;

  srcStep -= 8;
  for (y=0; y<8; y++)
  {
    for (x=0; x<8; x++)
	{
	  *pDst++ = ((*pTempSrc1++ + *pTempSrc2++ + *pTempSrc3++ + *pTempSrc4++) + 
	                  2 - rndVal) >> 2;
	}
    pTempSrc1 += srcStep;
    pTempSrc2 += srcStep;
    pTempSrc3 += srcStep;
    pTempSrc4 += srcStep;
  }
}

/**
 * Function: armVCM4P2_MCReconBlock_NoRes
 *
 * Description:
 * Do motion compensation and copy the result to the current block.
 *
 * Remarks:
 *
 * Parameters:
 * [in] pSrc        pointer to the block in the reference plane.
 * [in] srcStep     distance between the start of consecutive lines
 *                  in the reference plane, in bytes; must be a multiple
 *                  of 8.
 * [in] dstStep     distance between the start of consecutive lines in the
 *                  destination plane, in bytes; must be a multiple of 8.
 * [in] predictType bilinear interpolation type, as defined in section 6.2.1.2.
 * [in] rndVal      rounding control parameter: 0 - disabled; 1 - enabled.
 * [out] pDst       pointer to the destination buffer; must be 8-byte aligned.
 *                  If prediction residuals are added then output intensities
 *                  are clipped to the range [0,255].
 *
 */
static OMXVoid armVCM4P2_MCReconBlock_NoRes(
      const OMX_U8 *pSrc, 
      OMX_INT srcStep,
      OMX_U8 *pDst,
      OMX_INT dstStep)
{
    OMX_U8 x,y,count,index;
    
    /* Copying the ref 8x8 blk to the curr blk */
    for (y = 0, count = 0, index = 0; y < 8; y++,index += (srcStep -8), count += (dstStep - 8))
    {
        for (x = 0; x < 8; x++, count++,index++)
        {
            pDst[count] = pSrc[index];
        }       
    }
}

/**
 * Function: armVCM4P2_MCReconBlock_Res
 *
 * Description:
 * Reconstructs INTER block by summing the motion compensation results
 * and the results of the inverse transformation (prediction residuals).
 * Output intensities are clipped to the range [0,255].
 *
 * Remarks:
 *
 * Parameters:
 * [in] pSrc        pointer to the block in the reference plane.
 * [in] pSrcResidue pointer to a buffer containing the 16-bit prediction
 *                  residuals. If the pointer is NULL,then no prediction
 *                  is done, only motion compensation, i.e., the block is
 *                  moved with interpolation.
 * [in] dstStep     distance between the start of consecutive lines in the
 *                  destination plane, in bytes; must be a multiple of 8.
 * [out] pDst       pointer to the destination buffer; must be 8-byte aligned.
 *                  If prediction residuals are added then output intensities
 *                  are clipped to the range [0,255].
 *
 */
static OMXVoid armVCM4P2_MCReconBlock_Res(
      const OMX_U8 *pSrc, 
      const OMX_S16 *pSrcResidue,
      OMX_U8 *pDst,
      OMX_INT dstStep)
{
      
  OMX_U8 x,y;
  OMX_INT temp;
  
  for(y = 0; y < 8; y++)
  {
    for(x = 0; x < 8; x++)
    {
      temp = pSrc[x] + pSrcResidue[x];         
      pDst[x] = armClip(0,255,temp);
    }
    pDst += dstStep;
    pSrc += 8;
    pSrcResidue += 8;
  }
}

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
OMXResult omxVCM4P2_MCReconBlock(
		const OMX_U8 *pSrc,
		OMX_INT srcStep,
		const OMX_S16 *pSrcResidue,
		OMX_U8 *pDst, 
		OMX_INT dstStep,
		OMX_INT predictType,
		OMX_INT rndVal)
{
    /* Definitions and Initializations*/
    OMX_U8 pTempDst[64];
    OMX_S16 i;
    
    /* Argument error checks */
    armRetArgErrIf(pSrc == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(((dstStep % 8) || (srcStep % 8)), OMX_StsBadArgErr);
    armRetArgErrIf(((predictType != OMX_VC_INTEGER_PIXEL) &&
                    (predictType != OMX_VC_HALF_PIXEL_X) &&
                    (predictType != OMX_VC_HALF_PIXEL_Y) &&
                    (predictType != OMX_VC_HALF_PIXEL_XY)
                   ),OMX_StsBadArgErr); 
    armRetArgErrIf(((rndVal != 0) && (rndVal != 1)),OMX_StsBadArgErr);
    
    for(i = 0; i < 64; i++)
    {
        pTempDst[i] = 0;
    }
    switch(predictType)
    {
        case OMX_VC_INTEGER_PIXEL:
                                   armVCM4P2_MCReconBlock_NoRes(pSrc,
                                                                    srcStep,
                                                                    &(pTempDst[0]),
                                                                    8);
                                   break;
        case OMX_VC_HALF_PIXEL_X:
                                   armVCM4P2_HalfPelVer(pSrc,
                                                            srcStep,
                                                            &(pTempDst[0]),
                                                            rndVal);
                                   break;
        case OMX_VC_HALF_PIXEL_Y:
                                   armVCM4P2_HalfPelHor(pSrc,
                                                            srcStep,
                                                            &(pTempDst[0]),
                                                            rndVal);
                                   break;
        case OMX_VC_HALF_PIXEL_XY:
                                   armVCM4P2_HalfPelVerHor(pSrc,
                                                            srcStep,
                                                            &(pTempDst[0]),
                                                            rndVal);
                                   break;
    }
    
    if(pSrcResidue == NULL)
    {
      armVCM4P2_MCReconBlock_NoRes(&(pTempDst[0]),
                                         8,
                                         pDst,
                                         dstStep);    
    }
    else
    {
      armVCM4P2_MCReconBlock_Res(&(pTempDst[0]),
                                          pSrcResidue,
                                          pDst,
                                          dstStep);    
    }
    
    return OMX_StsNoErr;
}

