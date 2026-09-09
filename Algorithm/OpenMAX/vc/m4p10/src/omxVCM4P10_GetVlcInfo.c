/**
 *  omxVCM4P10_GetVlcInfo.c
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
 * 
 * This function extracts run-length encoding (RLE) information
 */

#include "omxtypes.h"
#include "omxVC.h"
#include "armCOMM.h"
#include "armVC.h"

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
	const OMX_S16*		    pSrcCoeff,
	const OMX_U8*			    pScanMatrix,
	OMX_U8			    bAC,
	OMX_U32			    MaxNumCoef,
	OMXVCM4P10VLCInfo*	pDstVLCInfo
)
{
    OMX_INT     i, MinIndex;
    OMX_S32     Value;
    OMX_U32     Mask = 4, RunBefore;
    OMX_S16     *pLevel;
    OMX_U8      *pRun;
    OMX_S16     Buf [16];

    /* check for argument error */
    armRetArgErrIf(pSrcCoeff == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(armNot8ByteAligned(pSrcCoeff), OMX_StsBadArgErr)
    armRetArgErrIf(pScanMatrix == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstVLCInfo == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(bAC > 1, OMX_StsBadArgErr)
    armRetArgErrIf(MaxNumCoef > 16, OMX_StsBadArgErr)

    /* Initialize RLE Info structure */
    pDstVLCInfo->uTrailing_Ones = 0;
    pDstVLCInfo->uTrailing_One_Signs = 0;
    pDstVLCInfo->uNumCoeffs = 0;
    pDstVLCInfo->uTotalZeros = 0;

    for (i = 0; i < 16; i++)
    {
        pDstVLCInfo->iLevels [i] = 0;
        pDstVLCInfo->uRuns [i] = 0;
    }
    
    MinIndex = (bAC == 0 && MaxNumCoef == 15) ? 1 : 0;
    for (i = MinIndex; i < (MaxNumCoef + MinIndex); i++)
    {        
        /* Scan */
        Buf [i - MinIndex] = pSrcCoeff [pScanMatrix [i]];
    }

    /* skip zeros at the end */
    i = MaxNumCoef - 1;
    while (!Buf [i] && i >= 0)
    {
        i--;
    }
    
    if (i < 0)
    {
        return OMX_StsNoErr;
    }

    /* Fill RLE Info structure */
    pLevel = pDstVLCInfo->iLevels;
    pRun = pDstVLCInfo->uRuns;
    RunBefore = 0;

    /* Handle first non zero separate */
    pDstVLCInfo->uNumCoeffs++;
    Value = Buf [i];
    if (Value == 1 || Value == -1)
    {
        pDstVLCInfo->uTrailing_Ones++;
        
        pDstVLCInfo->uTrailing_One_Signs |= 
            Value == -1 ? Mask : 0;
        Mask >>= 1;
    }
    else
    {
        Value -= (Value > 0 ? 1 : -1);
        *pLevel++ = Value;
        Mask = 0;
    }

    /* Remaining non zero */
    while (--i >= 0)
    {
        Value = Buf [i];
        if (Value)
        {
            pDstVLCInfo->uNumCoeffs++;

            /* Mask becomes zero after entering */
            if (Mask &&
                (Value == 1 || 
                 Value == -1))
            {
                pDstVLCInfo->uTrailing_Ones++;
                
                pDstVLCInfo->uTrailing_One_Signs |= 
                    Value == -1 ? Mask : 0;
                Mask >>= 1;
                *pRun++ = RunBefore;
                RunBefore = 0;
            }
            else
            {
                /* If 3 trailing ones are not completed */
                if (Mask)
                {
                    Mask = 0;
                    Value -= (Value > 0 ? 1 : -1);
                }
                *pLevel++ = Value;
                *pRun++ = RunBefore;
                RunBefore = 0;
            }
        }
        else
        {
            pDstVLCInfo->uTotalZeros++;
            RunBefore++;
        }        
    }
    
    /* Update last run */
    if (RunBefore)
    {
        *pRun++ = RunBefore;
    }

    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

