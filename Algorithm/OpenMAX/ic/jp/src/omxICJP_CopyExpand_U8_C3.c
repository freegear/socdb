/**
 *  omxICJP_CopyExpand_U8_C3.c
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
 * This file contains module for Copy/Expand for an MCU on the boundary
 *
 */

#include "omxtypes.h"
#include "omxIC.h"

#include "armCOMM.h"

/**
 * Function: omxICJP_CopyExpand_U8_C3
 *
 * Brief:
 * Copy, Expand pixels for MCU on the boundary
 *
 * Description:
 * This function processes the image data block on the boundary. The values, which are situated
 * outside of the image boundary at the right and bottom sides of the buffer, are replicated from the sample values at the boundary to provide
 * missing edge values. This function just processes 3 channels image data in interleaved order.
 * Both of source image data buffer and destination image data buffer support down-top storage
 * format. In that case, srcStep and dstStep can be less than 0.
 *
 *
 * Parameters:
 * [in]  pSrc           identifies source image data buffer
 * [in]  srcStep        specifies the number of bytes in a line of the image data buffer
 * [in]  srcSize        identifies OMXSize data structure to indicate the size of source rectangle
 * [in]  dstStep        specifies the number of bytes in a line of output MCU buffer
 * [in]  dstSize        identifies OMXSize data structure to indicate the size of destination rectangle
 * [out] pDst           identifies the output MCU buffer
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxICJP_CopyExpand_U8_C3(
     const OMX_U8 *pSrc,
     OMX_INT srcStep,
     OMXSize srcSize,
     OMX_U8 *pDst,
     OMX_INT dstStep,
     OMXSize dstSize
 )
{
    OMX_INT srcX,srcY,dstX,dstY;
    OMX_U8  coefOne,coefTwo,coefThr;
    
    /* Argument Checks */
    armRetArgErrIf( pSrc == NULL, OMX_StsBadArgErr)
    armRetArgErrIf( pDst == NULL, OMX_StsBadArgErr)
    
    armRetArgErrIf( (srcStep < 3) && (srcStep > -3), OMX_StsBadArgErr)
    armRetArgErrIf( (dstStep < 3) && (dstStep > -3), OMX_StsBadArgErr)
    
    armRetArgErrIf( srcSize.height <=0, OMX_StsBadArgErr)
    armRetArgErrIf( srcSize.width  <=0, OMX_StsBadArgErr)
    
    armRetArgErrIf( dstSize.height <=0, OMX_StsBadArgErr)
    armRetArgErrIf( dstSize.width  <=0, OMX_StsBadArgErr)
    
    armRetArgErrIf( dstSize.height < srcSize.height, OMX_StsBadArgErr)
    armRetArgErrIf( dstSize.width  < srcSize.width , OMX_StsBadArgErr)

    /* Processing */
    for(srcY = 0 ; srcY < srcSize.height ; srcY++)
    {
        /* Copy the contents of source image */
        for(srcX = 0 ; srcX < (3 * srcSize.width) ; srcX += 3 )
        {
            pDst[srcX]     = pSrc[srcX];
            pDst[srcX + 1] = pSrc[srcX + 1];
            pDst[srcX + 2] = pSrc[srcX + 2];
        }
        
        /* Border Element */ 
        coefOne = pSrc[srcX - 3];
        coefTwo = pSrc[srcX - 2];
        coefThr = pSrc[srcX - 1];
        
        /* Replicate the border elements on right side */
        for(dstX = (3 * srcSize.width) ; dstX < (3 * dstSize.width) ; dstX += 3)
        {
            pDst[dstX]     = coefOne;
            pDst[dstX + 1] = coefTwo;
            pDst[dstX + 2] = coefThr;
            
        }

        pDst += dstStep;
        pSrc += srcStep;
    }

    /* Replicate the border elements on bottom side */
    for(dstX = 0 ;dstX < dstSize.width ; dstX++)
    {
        coefOne = pDst[-dstStep];
        coefTwo = pDst[-dstStep + 1];
        coefThr = pDst[-dstStep + 2];
        
        for(dstY =  0 ; dstY < (dstSize.height - srcSize.height) ; dstY++)
        {
            pDst[ dstY * dstStep ]    = coefOne;
            pDst[ dstY * dstStep + 1] = coefTwo;
            pDst[ dstY * dstStep + 2] = coefThr;
            
        }
        
        pDst += 3;
    }

    return OMX_StsNoErr;
}

/* End of File */
