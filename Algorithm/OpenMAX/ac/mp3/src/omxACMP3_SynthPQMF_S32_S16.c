/**
 *  omxACMP3_SynthPQMF_S32_S16.c
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
 * This function is used to do synthesis PQMF filtering
 */

#include <stdio.h>
#include <math.h>
#include "omxtypes.h"
#include "armCOMM_Bitstream.h"
#include "armCOMM.h"
#include "armACMP3_Tables.h"
#include "omxAC.h"
#include "armAC.h"

/**
 * Function: omxACMP3_SynthPQMF_S32_S16
 *
 * Description:
 * Stage 2 of the hybrid synthesis filter bank
 * See ISO/IEC 13818-3  2.5.3.2.2
 *
 * Remarks:
 * This function perform a critically-sampled 32-channel PQMF synthesis bank
 * that generates 32 time-domain output samples for each 32-sample input
 * block of IMDCT outputs.
 *
 * Parameters:
 * [in]  pSrcY            pointer to the block of 32 IMDCT sub-band
 *                              input samples, represented in Q7.24 format
 * [in]  pVBuffer         pointer to the input workspace buffer containing
 *                              Q7.24 data. The elements of this buffer should be
 *                              initialized to zero during decoder reset. During
 *                              decoder operation, the values contained in this
 *                              buffer should be modified only by the PQMF primitive.
 * [in]  pVPosition       pointer to the internal workspace index; should be
 *                              initialized to zero during decoder reset. During
 *                              decoder operation, the value of this index should
 *                              be preserved between PQMF calls and should be
 *                              modified only by the primitive.
 * [in]  mode             flag that indicates whether or not the PCM audio
 *                              output channels should be interleaved;
 *                              1 - not interleaved,
 *                              2 - interleaved
 * [out] pDstAudioOut     pointer to a block of 32 reconstructed PCM output
 *                              samples in 16-bit signed format (little-endian);
 *															represented in Q16.15 format.
 *                              left and right channels are interleaved according
 *                              to the mode flag. This should be aligned on a
 *                        		4-byte boundary
 * [out] pVBuffer         pointer to the updated internal workspace buffer
 *                              containing Q7.24 data; see usage notes under input
 *                              argument discussion
 * [out] pVPosition       pointer to the updated internal workspace index;
 *                              see usage notes under input argument discussion
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult omxACMP3_SynthPQMF_S32_S16(
     OMX_S32 *pSrcY,
     OMX_S16 *pDstAudioOut,
     OMX_S32 *pVBuffer,
     OMX_INT *pVPosition,
     OMX_INT mode
)
{
    OMX_F64     acc, Angle;
    OMX_F64     V [ARM_MP3_VBUFFER_SZ], Src [ARM_MP3_PQMF_SZ];
    OMX_F64     U [ARM_MP3_VBUFFER_SZ];
    OMX_S32     i, j, k;

    /* Arguments check */
    armRetArgErrIf(pSrcY == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pDstAudioOut == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pVBuffer == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(pVPosition == NULL, OMX_StsBadArgErr)
    armRetArgErrIf(mode < 1, OMX_StsBadArgErr)
    armRetArgErrIf(mode > 2, OMX_StsBadArgErr)

    /* Validate Arguments */
    armRetArgErrIf(*pVPosition < 0, OMX_StsErr)
    armRetArgErrIf(*pVPosition > 15, OMX_StsErr)

    /* Get input */
    for (i = 0; i < ARM_MP3_PQMF_SZ; i++)
    {
        /* Convert Q7.24 to float */
        Src [i] = ((OMX_F64)pSrcY [i]) / (1 << 24);
    }

    for (i = 0; i < ARM_MP3_VBUFFER_SZ; i++)
    {
        /* Convert Q7.24 to float */
        V[i] = ((OMX_F64)pVBuffer [i]) / (1 << 24);
    }

    /* calculate 32pt DCT of Vi */
    for (i = 0; i < ARM_MP3_PQMF_SZ; i++)
    {
        Angle = (PI / 64.0) * i;
        acc = 0.0;
        for (k = 0; k < ARM_MP3_PQMF_SZ; k++)
        {
            acc += cos (Angle * (2.0 * k + 1.0)) * Src [k];
        }
        V [(ARM_MP3_PQMF_SZ * *pVPosition) + i] = acc;
        pVBuffer[(ARM_MP3_PQMF_SZ * *pVPosition) + i] = 
            armSatRoundFloatToS32 (acc * (1 << 24));

    }

    /* update pVPosition */
    k = ARM_MP3_PQMF_SZ * *pVPosition;
    *pVPosition -= 1;
    if (*pVPosition < 0)
    {
        *pVPosition = 15;
    }
    
    for (j = 0; j < 8; j++)
    {
        for (i = 0; i < 16; i++)
        {
            U [j * 64 + i] = V [k + i + 16];
            U [j * 64 + i + 17] = -V [k + 31 - i];
        }
        k += ARM_MP3_PQMF_SZ;
        if (k >= ARM_MP3_VBUFFER_SZ)
        {
            k = 0;
        }
        for (i = 0; i < 16; i++)
        {
            U [j * 64 + i + 32] = -V [k + 16 - i];
            U [j * 64 + i + 48] = -V [k + i];
        }
        U [j * 64 + 16] = 0;

        k += ARM_MP3_PQMF_SZ;
        if (k >= ARM_MP3_VBUFFER_SZ)
        {
            k = 0;
        }
    }

    for (j = 0; j < ARM_MP3_PQMF_SZ; j++)
    {
        acc = 0.0;
        for (i = 0; i < 16; i++)
        {
            /* j+32i */
            k = j + i * ARM_MP3_PQMF_SZ; 
            acc += U [k] * armACMP3_DWindow [k];
        }
        /* Convert float to Q16.15 */
        pDstAudioOut [j * mode] = armSatRoundFloatToS16 (acc * (1 << 15));
    }

    return OMX_StsNoErr;
}

/*****************************************************************************
 *                              END OF FILE
 *****************************************************************************/

