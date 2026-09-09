/**
 *  omxSP_Copy_S16.c
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
 * This file contains module for vector copy
 *
 */

#include "omxtypes.h"
#include "omxSP.h"

#include "armCOMM.h"

/**
 * Function: omxSP_Copy_S16
 *
 * Description:
 * Vector copy for 16-bit type data.
 *
 * Remarks:
 * This function Copies the len elements of the vector pointed to by pSrc into
 * the len elements of the vector pointed to by pDst.
 * The function checks the alignment of the pointers and select the optimal way to copy.
 *
 * Parameters:
 * [in]  pSrc        pointer to the source vector
 * [in]  len         number of elements contained in the source and
 *             destination vectors
 * [out] pDst        pointer to the destination vector
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_Copy_S16(
     const OMX_S16 * pSrc,
     OMX_S16 * pDst,
     OMX_INT len
 )
{
    OMX_INT i;
    /* Argument Check */
    armRetArgErrIf( pSrc == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( len < 0, OMX_StsBadArgErr);
    
    /* Processing */    
    for (i = len; i > 0; i--) 
    {
        *pDst++ = *pSrc++;
    }

    return OMX_StsNoErr;
}

/*End of File*/


