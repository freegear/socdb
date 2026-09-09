/**
 *  omxACMP3_MDCTInv_S32.c
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
 * This function will do Alias reduction, Inverse MDCT, overlap add and 
 * frequency inversion
 */

#include <math.h>
#include "omxtypes.h"
#include "armCOMM_Bitstream.h"
#include "armCOMM.h"
#include "armACMP3_Tables.h"
#include "omxAC.h"
#include "armAC.h"

/**
 * Function: omxACMP3_MDCTInv_S32
 *
 * Description:
 * Stage 1 of the hybrid synthesis filter bank.
 * See ISO/IEC 13818-3  2.5.3.2.2
 *
 * Remarks:
 * This performs the following operations: a) Alias reduction, b) Inverse MDCT
 * according to block size specifiers and mixed block modes, c) Overlap
 * add of IMDCT outputs, and d) Frequency inversion prior to PQMF bank.
 *
 *
 * Parameters:
 * [in]  pSrcXr          pointer to the vector of requantized spectral
 *                             samples for the current channel and granule,
 *                             represented in Q5.26 format.
 * [in]  pSrcDstOverlapAdd    pointer to the overlap-add buffer;
 *                                  contains the overlapped portion of
 *                                  the previous granule's IMDCT output,
 *                                  in Q7.24 format
 * [in]  nonZeroBound    the bound above which all spectral coefficients
 *                             are zero for the current granule and channel
 * [in]  pPrevNumOfImdct pointer to the number of IMDCTs computed for
 *                             the current channel of the previous granule
 * [in]  blockType       block type indicator
 * [in]  mixedBlock      mixed block indicator
 * [out] pDstY           pointer to the vector of IMDCT outputs represented in
 *                             Q7.24 format, for input to PQMF bank
 * [out] pSrcDstOverlapAdd    pointer to the overlap-add buffer;
 *                                  contains the overlapped portion of
 *                                  the previous granule's IMDCT output,
 *                             	    represented in Q7.24 format
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACMP3_MDCTInv_S32 (
     OMX_S32 *pSrcXr,
     OMX_S32 *pDstY,
     OMX_S32 *pSrcDstOverlapAdd,
     OMX_INT nonZeroBound,
     OMX_INT *pPrevNumOfImdct,
     OMX_INT blockType,
     OMX_INT mixedBlock
)
{
    OMX_S32     sb, i, N, Nby2, win, k;
    OMX_F64     xar [OMX_MP3_GRANULE_LEN], xr [OMX_MP3_GRANULE_LEN];
    OMX_F64     out [ARM_MP3_WINDOW_SZ], Win [ARM_MP3_WINDOW_SZ];
    OMX_F64     xi, tmp, temp [ARM_MP3_SHORTBLOCK_SZ];
    OMX_F64     prvout [OMX_MP3_GRANULE_LEN];

    /* Arguments check */
    armRetArgErrIf(pSrcXr == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstY == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pSrcDstOverlapAdd == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pPrevNumOfImdct == NULL, OMX_StsBadArgErr)

    /* Validate Arguments */
    armRetArgErrIf(blockType < 0, OMX_StsErr)
    armRetArgErrIf(blockType > 3, OMX_StsErr)

    armRetArgErrIf(mixedBlock < 0, OMX_StsErr)
    armRetArgErrIf(mixedBlock > 1, OMX_StsErr)

    armRetArgErrIf(nonZeroBound < 0, OMX_StsErr)
    armRetArgErrIf(nonZeroBound > OMX_MP3_GRANULE_LEN, OMX_StsErr)

    armRetArgErrIf(*pPrevNumOfImdct < 0, OMX_StsErr)
    armRetArgErrIf(*pPrevNumOfImdct > ARM_MP3_NO_OF_SUBBANDS, OMX_StsErr)

    /* Copy into local float buffer */
    for (i = 0; i < OMX_MP3_GRANULE_LEN; i++)
    {
        /* convert the Q5.26 into float */
        xr [i] = (OMX_F64) pSrcXr [i] / (1 << 26);
        prvout [i] = (OMX_F64) pSrcDstOverlapAdd [i] / (1 << 24);
    }

    /* create Widnow coeffs */
    switch (blockType)
    {
    case 0:
        /* Normal Block */
        for (i = 0; i < ARM_MP3_WINDOW_SZ; i++)
        {
            Win [i] = armACMP3_LongWindow [i];
        }
        break;
    case 1:
        /* Start Block */
        for (i = 0; i < 18; i++)
        {
            Win [i] = armACMP3_LongWindow [i];
        }
        for (i = 18; i < 24; i++)
        {
            Win [i] = 1.0;
        }
        for (i = 24; i < 30; i++)
        {
            Win [i] = armACMP3_ShortWindow [i-18];
        }
        for (i = 30; i < ARM_MP3_WINDOW_SZ; i++)
        {
            Win [i] = 0;
        }
        break;
    case 2:
        /* Short Block */
        if (mixedBlock)
        {
            for (i = 0; i < ARM_MP3_WINDOW_SZ; i++)
            {
                Win [i] = armACMP3_LongWindow [i];
            }
        }
        else
        {
            for (i = 0; i < ARM_MP3_SHORTBLOCK_SZ; i++)
            {
                Win [i] = armACMP3_ShortWindow [i];
            }
        }

        break;
    case 3:
        /* Stop Block */
        for (i = 0; i < 6; i++)
        {
            Win [i] = 0;
        }
        for (i = 6; i < 12; i++)
        {
            Win [i] = armACMP3_ShortWindow [i-6];
        }
        for (i = 12; i < 18; i++)
        {
            Win [i] = 1.0;
        }
        for (i = 18; i < ARM_MP3_WINDOW_SZ; i++)
        {
            Win [i] = armACMP3_LongWindow [i];
        }
        break;
    }

    /* Alias Reduction */
    for (i = 0; i < OMX_MP3_GRANULE_LEN; i++)
    {
        xar [i] = xr [i];
    }
    
    /* get the No of sub-bands for alias reduction */
    if (blockType == 2 && mixedBlock == 1)
    {
        N = 2;
    }
    else if (blockType != 2)
    {
        N = ARM_MP3_NO_OF_SUBBANDS;
    }
    else
    {
        /* case of pure short blocks */
        N = 0;
    }

    for (sb = 1; sb < N; sb++)
    {
        for (i = 0; i < ARM_MP3_ALIAS_BFLY_NOS; i++)
        {
            xar [ARM_MP3_SUBBAND_SZ*sb - 1 - i] = 
                xr [ARM_MP3_SUBBAND_SZ*sb - 1 - i] * armACMP3_BflyCoeffCS[i] - 
                xr [ARM_MP3_SUBBAND_SZ*sb + i] * armACMP3_BflyCoeffCA[i]; 
            xar [ARM_MP3_SUBBAND_SZ*sb + i] = 
                xr [ARM_MP3_SUBBAND_SZ*sb + i] * armACMP3_BflyCoeffCS[i] + 
                xr [ARM_MP3_SUBBAND_SZ*sb - 1 - i] * armACMP3_BflyCoeffCA[i]; 
        }
    }

    /* IMDCT */
    for (sb = 0; sb < ARM_MP3_NO_OF_SUBBANDS; sb++)
    {
        if ((blockType == 2 && mixedBlock == 0) ||
            (blockType == 2 && mixedBlock == 1 && sb > 1))
        {
            /* Short */
            if (blockType == 2 && mixedBlock == 1 && sb == 2)
            {
                for (i = 0; i < ARM_MP3_SHORTBLOCK_SZ; i++)
                {
                    Win [i] = armACMP3_ShortWindow [i];
                }
            }
            N = ARM_MP3_SHORTBLOCK_SZ;
            Nby2 = N / 2;
            for (i = 0; i < ARM_MP3_WINDOW_SZ; i++)
            {
                out [i] = 0;
            }

            for (win = 0; win < 3; win++)
            {
                for (i = 0; i < N; i++)
                {
                    tmp = ((2 * i + 1 + Nby2) * PI)/(2 * N);

                    for (k = 0, xi = 0.0; k < Nby2; k++)
                    {
                        xi += xar [sb * 18 + win + 3 * k] * cos (tmp * (2 * k + 1));
                    }
                    
                    temp [i] =  xi * Win [i];
                }
                for (i = 0; i < N; i++)
                {
                    out [6*win+i+6] += temp [i];
                }
            }
        }
        else
        {
            /* Long */
            /* Update IMDCT parameters */
            N = ARM_MP3_LONGBLOCK_SZ;
            Nby2 = N / 2;

            for (i = 0; i < N; i++)
            {
                tmp = ((2 * i + 1 + Nby2) * PI)/(2 * N);

                for (k = 0, xi = 0.0; k < Nby2; k++)
                {
                    xi += xar [sb * Nby2 + k] * cos (tmp * (2 * k + 1));
                }
                out [i] = xi * Win [i];
            }
        }

        /* Overlap addition */
        for (i = 0; i < ARM_MP3_SUBBAND_SZ; i++)
        {
            xr [sb * ARM_MP3_SUBBAND_SZ + i] = 
                prvout [sb * ARM_MP3_SUBBAND_SZ + i] + out [i];
            prvout [sb * ARM_MP3_SUBBAND_SZ + i] = 
                out [i + ARM_MP3_SUBBAND_SZ];
        }
    }

    /* Frequency Inversion */
    for (sb = 1; sb < ARM_MP3_NO_OF_SUBBANDS; sb += 2)
    {
        for (i = 1; i < ARM_MP3_SUBBAND_SZ; i += 2)
        {
            xr [sb * ARM_MP3_SUBBAND_SZ + i] = 
                -xr [sb * ARM_MP3_SUBBAND_SZ + i];
        }
    }

    /* Copy from local float buffer */
    for (i = 0; i < OMX_MP3_GRANULE_LEN; i++)
    {
        /* convert to the Q7.24 from float */
        pDstY [i] = 
            armSatRoundFloatToS32 (xr [i] * (1 << 24));
        pSrcDstOverlapAdd [i] = 
            armSatRoundFloatToS32 (prvout [i] * (1 << 24));
    }

    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

