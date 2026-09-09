/**
 *
 *  armIPCS_Flip.c
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
 * Description  : Contains functions that do basic flipping and rotation of input images.
 *
 */

#include "omxtypes.h"
#include "armIP.h"

/**
 * Functions: armIPCS_FlipTopBottom_I
 *
 * Description:
 * This function flips the image w.r.t X axis and does it in-place.
 * The formula being used is OutPix(x,y) = InPix(x,height-y).
 * No assumption is being made on the buffer alignment.
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
 
OMXResult armIPCS_FlipTopBottom_I(
        void    *pBuf,          /* Pointer to the Image Buffer */
        OMX_INT bufElemSize,    /* Number of bytes in one element */
        OMX_INT bufStep,        /* Offset in bytes between two rows */
        OMX_INT bufWidth,       /* Number of elements in one row */
        OMX_INT bufHeight       /* Number of rows in the image */
       )
{
    OMX_U8  *pBufTop  = (OMX_U8*)pBuf;
    OMX_U8  *pBufBot  = (OMX_U8*)pBuf + (bufHeight - 1) * bufStep;
    OMX_INT i, j;
    
    armRetArgErrIf(!pBuf, OMX_StsNullPtrErr);
    
    for(i = 0; i < bufHeight/2; i++)
    {
        for(j = 0; j < bufWidth; j++)
        {
            armSwapElem((pBufTop + j *bufElemSize), (pBufBot + j * bufElemSize), bufElemSize);
        }
        pBufTop += bufStep;
        pBufBot -= bufStep;
    }
    
    return OMX_StsNoErr;
}

/**
 * Functions: armIPCS_FlipLeftRight_I
 *
 * Description:
 * This function flips the image w.r.t Y axis and does it in-place.
 * The formula being used is OutPix(x,y) = InPix(width-x,y).
 * The size of each element of the image is specified in <bufElemSize>
 * and no assumption is being made on the buffer alignment.
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
 
OMXResult armIPCS_FlipLeftRight_I(
        void    *pBuf,          /* Pointer to the Image Buffer */
        OMX_INT bufElemSize,    /* Number of bytes in one element */
        OMX_INT bufStep,        /* Offset in bytes between two rows */
        OMX_INT bufWidth,       /* Number of elements in one row */
        OMX_INT bufHeight       /* Number of rows in the image */
       )
{
    OMX_U8  *pBufLeft   = (OMX_U8*)pBuf;
    OMX_U8  *pBufRight  = (OMX_U8*)pBuf + (bufWidth - 1) * bufElemSize;
    OMX_INT i, j;
    
    armRetArgErrIf(!pBuf, OMX_StsNullPtrErr);
    
    for(i = 0; i < bufHeight; i++)
    {
        for(j = 0; j < bufWidth/2; j++)
        {
            armSwapElem((pBufLeft + j * bufElemSize), (pBufRight - j * bufElemSize), bufElemSize);
        }
        pBufLeft  += bufStep;
        pBufRight += bufStep;
    }
    
    return OMX_StsNoErr;
}

/**
 * Functions: armIPCS_FlipMajorDiagonal_I
 *
 * Description:
 * This function flips the image w.r.t major diagonal and does it in-place.
 * The formula being used is OutPix(y,x) = InPix(x,y).
 * The size of each element of the image is specified in <bufElemSize>
 * and no assumption is being made on the buffer alignment.
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
 
OMXResult armIPCS_FlipMajorDiagonal_I(
        void    *pBuf,          /* Pointer to the Image Buffer */
        OMX_INT bufElemSize,    /* Number of bytes in one element */
        OMX_INT bufStep,        /* Offset in bytes between two rows */
        OMX_INT bufWidth,       /* Number of elements in one row */
        OMX_INT bufHeight       /* Number of rows in the image */
       )
{
    OMX_U8  *pBufRight = (OMX_U8*)pBuf;
    OMX_U8  *pBufDown  = (OMX_U8*)pBuf;
    OMX_INT loopCnt    = (bufWidth > bufHeight) ? bufWidth : bufHeight;
    OMX_INT i, j;
    
    armRetArgErrIf(!pBuf, OMX_StsNullPtrErr);
    
    for(i = 0; i < loopCnt; i++)
    {
        for(j = 0; j < i; j++)
        {
            armSwapElem((pBufRight + j * bufStep), (pBufDown + j * bufElemSize), bufElemSize);
        }
        pBufRight += bufElemSize;
        pBufDown += bufStep;
    }
    
    return OMX_StsNoErr;
}

/**
 * Functions: armIPCS_Rotate180_I
 *
 * Description:
 * The function rotates the buffer by 180 degree and does it in-place.
 * The formula being used is OutPix(x,y) = InPix(width-x,height-y).
 * The size of each element of the image is specified in <bufElemSize>
 * and no assumption is being made on the buffer alignment.
 *
 * Return Value:
 * OMXResult -- Error status from the function
 */
 
OMXResult armIPCS_Rotate180_I(
        void    *pBuf,          /* Pointer to the Image Buffer */
        OMX_INT bufElemSize,    /* Number of bytes in one element */
        OMX_INT bufStep,        /* Offset in bytes between two rows */
        OMX_INT bufWidth,       /* Number of elements in one row */
        OMX_INT bufHeight       /* Number of rows in the image */
       )
{
    OMX_U8  *pBufLeft, *pBufRight;
    OMX_U8  *pBufTop = (OMX_U8*)pBuf;
    OMX_U8  *pBufBot = (OMX_U8*)pBuf + (bufWidth - 1) * bufElemSize + (bufHeight - 1) * bufStep;
    OMX_INT i, j;
    
    armRetArgErrIf(!pBuf, OMX_StsNullPtrErr);
    
    /*
    -------------------------------------------------------------------
    The function rotates the buffer by 180 degree and does it in-place.
    The formulae for this is OutPix(x,y) = InPix(width-x,height-y)
    -------------------------------------------------------------------
    */
    
    for(i = 0; i < bufHeight/2; i++)
    {
        for(j = 0; j < bufWidth; j++)
        {
            armSwapElem((pBufTop + j * bufElemSize), (pBufBot - j * bufElemSize), bufElemSize);
        }
        pBufTop += bufStep;
        pBufBot -= bufStep;
    }
    
    /*
    ----------------------------------------------------------------------------
    This part of the code handles cases, where the <bufHeight> is an odd number.
    ----------------------------------------------------------------------------
    */
    
    if(bufHeight % 2)
    {
        pBufLeft  = (OMX_U8*)pBuf + ((OMX_INT)(bufHeight/2)) * bufStep;
        pBufRight = (OMX_U8*)pBuf + ((OMX_INT)(bufHeight/2)) * bufStep + (bufWidth - 1) * bufElemSize;
        
        for(i = 0; i < bufWidth/2; i++)
        {
            armSwapElem((pBufLeft + i), (pBufRight - i), bufElemSize);
        }
    }
    
    return OMX_StsNoErr;
}

/* End of file */
