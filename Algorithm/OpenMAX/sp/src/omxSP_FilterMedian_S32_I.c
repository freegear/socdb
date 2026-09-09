/**
 *  omxSP_FilterMedian_S32_I.c
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
 * This file contains module for inplace median filtering
 *
 */

#include "omxtypes.h"
#include "omxSP.h"

#include "armCOMM.h"

/**
 * Function: omxSP_FilterMedian_S32_I
 *
 * Description:
 * This function computes the median values for each element of the input
 * array, and stores the result in the output vector.
 *
 * Remarks:
 * This function computes the median values for each element of the input
 * array, and stores the result in the output vector.
 *
 * Parameters:
 * [in]  pSrcDst    pointer to input and output array
 * [in]  len        number of elements contained in the input and
 *			  output vectors (0 < len < 65536)
 * [in]  maskSize   median mask size. If an even value is specified,
 *			  the function subtracts 1 and uses the odd value
 *			  of the filter mask for median filtering
 *			  (0 < maskSize ¡Ü 256).
 * [out] pSrcDst    pointer to input and output array
 *
 * Return Value:
 * Standard omxError result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FilterMedian_S32_I(
     OMX_S32 *pSrcDst,
     OMX_INT len,
     OMX_INT maskSize
 )
{

    OMX_S32 sortedData[256];
    OMX_S32 medianData[127];
    
    OMX_S32       *pSort;
    const OMX_S32 *pTempSrc;
    
    OMX_S32 firstElement,lastElement,temp;
    
    OMX_INT maskByTwo,count,i,j;
    OMX_INT countMedianData;
    
    /* Argument Check */
    armRetArgErrIf( pSrcDst  == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( len      <= 0     , OMX_StsBadArgErr);
    armRetArgErrIf( len      >= 65536 , OMX_StsBadArgErr);
    armRetArgErrIf( maskSize <= 0     , OMX_StsBadArgErr);
    armRetArgErrIf( maskSize >= 256   , OMX_StsBadArgErr);
    armRetArgErrIf( maskSize > len    , OMX_StsBadArgErr);

    /* Processing */
    if(!(maskSize & 1))
    {
        maskSize--;
    }
    
    /* Initializations */
    
    maskByTwo       = ((maskSize - 1)>>1);
    countMedianData = 0;
    firstElement    = pSrcDst[0];
    lastElement     = pSrcDst[len - 1];
    
    for(count = 0 ; count < len ; count ++)
    {
        pSort    =  sortedData;
        pTempSrc =  pSrcDst;
        
        /* Initialize the array */

        if ( count < maskByTwo )
        {
            for(i = 0 ; i < (maskByTwo - count) ; i++)
            {
                *pSort++ = firstElement;
            }

            for(i = 0; i <= count; i++)
            {
                *pSort++ = *pTempSrc++;
            }
        }
        else if(maskByTwo != 0)/*maskSize = 1*/
        {
            for(i = 0; i <= maskByTwo; i++)
            {
                *pSort++ = *pTempSrc++;
            }

            *pSrcDst++ = medianData[countMedianData];
        }
        
        if ( (len - count - 1) < maskByTwo )
        {
            for(i = 0; i < (len - count - 1); i++)
            {
                *pSort++ = *pTempSrc++;
            }

            for(i = 0; i < ( maskByTwo - (len - count - 1) ); i++)
            {
                *pSort++ = lastElement;
            }
        }
        else
        {
            for(i = 0; i < maskByTwo; i++)
            {
                *pSort++ = *pTempSrc++;
            }
        }
    
        /*Sort the Data - Bubble sort implementation*/
        
        for(i = 0 ; i <= maskByTwo ; i++)
        {
            for(j = 0; j < (maskSize - 1 - i); j++ )
            {
                if(sortedData[j+1] < sortedData[j])
                {
                    temp             = sortedData[j];
                    sortedData[j]    = sortedData[j+1];
                    sortedData[j+1]  = temp;
                }
            
            }
        
        }

        medianData[countMedianData] = sortedData[maskByTwo];

        countMedianData++;
        
        if(countMedianData >= maskByTwo)
        {
            countMedianData = 0;
        }

    }

    /* Empty medianData queue */
    
    for(i = 0 ;  i < maskByTwo ; i++)
    {
        *pSrcDst++ = medianData[countMedianData];
        
        countMedianData++;
        
        if(countMedianData >= maskByTwo)
        {
            countMedianData = 0;
        }
    }
    
    return OMX_StsNoErr;
}
