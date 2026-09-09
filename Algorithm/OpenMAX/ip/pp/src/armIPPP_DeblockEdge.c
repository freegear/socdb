/**
 *  armIPPP_DeblockEdge.c
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
 * This file contains module for deblock filtering
 *
 */

#include "omxtypes.h"
#include "armCOMM.h"

#include "armIP.h"

/**
 * Function: armIPPP_DeblockEdge()
 *
 * Description:
 * Performs deblock filtering on two adjacent blocks along a block edge (horizontal/Vertical) of an
 *
 * Remarks:
 * The output buffer region is required to have the same size as 
 * that of the input region, although the width of the overall 
 * images may differ.
 *
 * Parameters:
 * [in]  pSrcDst    pointer to the first pixel of the second block
 * [in]  step       width of the image plane, in bytes; must be a multiple of 8.
 * [in]  QP         quantization parameter, as described in Section J.3 of Annex J in H.263+
 * [in]  flag       flag = 0 :vertical Edge, flag = 1: Horizontal edge
 * [out] pSrcDst    pointer to the first pixel of the second output block
 *
 * Return value:
 * OMXVoid
 */
 

OMXVoid armIPPP_DeblockEdge(
        OMX_U8 *pSrcDst,
        OMX_INT step,
        OMX_INT QP,
        OMX_INT flag
)
{
    OMX_U8  pixA,pixB,pixC,pixD;
    OMX_U8  pixA1,pixB1,pixC1,pixD1;
    OMX_U8  strength;
    OMX_S16 d,d1,d2,td;

    OMX_INT x,stepVert,stepHorz;

    strength = armIPPP_strengthTable[QP - 1];    
    
    if(flag == 0)
    {
        /*Vertical Edge Deblocking*/
        stepVert = step;
        stepHorz = 1;
    }
    else
    {
        /*Horizontal Edge Deblocking*/
        stepVert = 1;
        stepHorz = step;
    }
    
    for ( x = 0; x < 8 ; x++ )    
    {
        pixA = pSrcDst[-2 * stepHorz];    
        pixB = pSrcDst[-1 * stepHorz];    
        pixC = pSrcDst[ 0 * stepHorz];    
        pixD = pSrcDst[ 1 * stepHorz];    

        /* Compute d */
        d = pixA - (pixB << 2) + (pixC << 2) - pixD;
        d = d / 8;
        
        /* Compute d1 - UpDownRamp */
        td = armAbs(d);
        d1 = armMax(0, 2*(td - strength ) );
        d1 = armMax(0,td - d1);
        
        if (d < 0)
        {
           d1 = -d1;
        }
        
        /* Compute d2 - clipd1 */
        d2 = ( pixA - pixD ) / 4;
        td = d1/2;
        td = armAbs(td);
        d2 = (OMX_S16)armClip(-td,td, d2);
        
        /* Compute output pixels */
        pixA1 = (OMX_U8)(pixA - d2);
        pixB1 = (OMX_U8)armClip(0, 255, pixB + d1);
        pixC1 = (OMX_U8)armClip(0, 255, pixC - d1);
        pixD1 = (OMX_U8)(pixD + d2);

        /* Store result */
        pSrcDst[-2 * stepHorz] = pixA1;    
        pSrcDst[-1 * stepHorz] = pixB1;    
        pSrcDst[ 0 * stepHorz] = pixC1;    
        pSrcDst[ 1 * stepHorz] = pixD1;    

        pSrcDst += stepVert;
    }
}

/*End of File*/

