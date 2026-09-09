/**
 *  omxVCM4P2_EncodeVLCZigzag_IntraDCVLC.c
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
 * Contains modules for zigzag scanning and VLC encoding
 * for intra block.
 *
 */ 
 
#include "omxtypes.h"
#include "armVC.h"
#include "omxVC.h"
#include "armCOMM_Bitstream.h"
#include "armCOMM.h"
#include "armVCM4P2_Huff_Tables_VLC.h"
#include "armVCM4P2_ZigZag_Tables.h"



/**
 * Function: omxVCM4P2_EncodeVLCZigzag_IntraDCVLC
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
)
{
    OMX_S16 dcValue, powOfSize;
    OMX_U8  DCValueSize, start = 1;
    OMX_U16 absDCValue;

    /* Argument error checks */
    armRetArgErrIf(ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(*ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pBitOffset == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pQDctBlkCoef == NULL, OMX_StsBadArgErr);
    armRetArgErrIf((*pBitOffset < 0) || (*pBitOffset >7), OMX_StsBadArgErr);
    
    if (pattern)
    {
        dcValue = pQDctBlkCoef[0];
        absDCValue = armAbs(dcValue);

        /* Find the size */
        DCValueSize = armLogSize (absDCValue);
        absDCValue = armAbs(dcValue);

        /* Insert the code into the bitstream */
        if (videoComp == OMX_VC_LUMINANCE)
        {

            armPackVLC32 (ppBitStream, pBitOffset,
                          armVCM4P2_aIntraDCLumaIndex[DCValueSize]);
        }
        else if (videoComp == OMX_VC_CHROMINANCE)
        {

            armPackVLC32 (ppBitStream, pBitOffset,
                          armVCM4P2_aIntraDCChromaIndex[DCValueSize]);
        }

        /* Additional code generation in case of negative
           dc value the additional */
        if (DCValueSize > 0)
        {
            if (dcValue < 0)
            {
                /* calulate 2 pow */
                powOfSize = (1 << DCValueSize);

                absDCValue =  absDCValue ^ (powOfSize - 1);
            }
            armPackBits(ppBitStream, pBitOffset, (OMX_U32)absDCValue, \
                        DCValueSize);

            if (DCValueSize > 8)
            {
                armPackBits(ppBitStream, pBitOffset, 1, 1);
            }
        }
    }

    return armVCM4P2_EncodeVLCZigzag_Intra(
                ppBitStream,
                pBitOffset,
                pQDctBlkCoef,
                predDir,
                pattern,
                shortVideoHeader,
                start);
}

/* End of file */
