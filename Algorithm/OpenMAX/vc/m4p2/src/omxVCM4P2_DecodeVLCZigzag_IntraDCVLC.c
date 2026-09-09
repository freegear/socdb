/**
 *  omxVCM4P2_DecodeVLCZigzag_IntraDCVLC.c
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
 * Contains modules for zigzag scanning and VLC decoding
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
 * Function: omxVCM4P2_DecodeVLCZigzag_IntraDCVLC
 *
 * Description:
 * Performs VLC decoding and inverse zigzag scan of AC and DC coefficients for one intra block.
 * Two versions of the function (DCVLC and ACVLC) are provided in order to support the two
 * different methods of processing DC coefficients, as described in ISO/IEC 14496-2, subclause
 * 7.4.1.4, "Intra DC Coefficient Decoding for the Case of Switched VLC Encoding."
 *
 * Remarks:
 *
 * Parameters:
 * [in]	ppBitStream		pointer to the pointer to the current byte in the bitstream buffer
 * [in]	pBitOffset		pointer to the bit position in the byte pointed to by *ppBitStream.
 *                    *pBitOffset is valid within [0-7].
 * [in]	predDir			AC prediction direction which is used to decide	the zigzag scan pattern.
 *                  It takes one of the	following values:
 *								   OMX_VC_NONE	AC prediction not used;	perform classical zigzag scan;
 *								   OMX_VC_HORIZONTAL	Horizontal prediction; perform alternate-vertical	zigzag scan;
 *								   OMX_VC_VERTICAL		Vertical prediction; perform alternate-horizontal zigzag scan.
 * [in] shortVideoHeader  binary flag indicating presence of short_video_header; escape modes 0-3 are used if shortVideoHeader==0,
 *                          and escape mode 4 is used when shortVideoHeader==1.
 * [in]	videoComp		video component type (luminance, chrominance or alpha) of the current block
 * [out]	ppBitStream		*ppBitStream is updated after the block is decoded, so that it points
 *                      to the current byte in the bit stream buffer
 * [out]	pBitOffset		*pBitOffset is updated so that it points to the current bit position in
 *                      the byte pointed by *ppBitStream
 * [out]	pDst			pointer to the coefficient buffer of current block. Must be 4-byte aligned
 *
 * Return Value:
 * OMX_StsNoErr - no error
 * OMX_StsBadArgErr - bad arguments
 *   - At least one of the following pointers is NULL: ppBitStream, *ppBitStream, pBitOffset, pDst, or
 *   - At least one of the following conditions is true: *pBitOffset exceeds [0,7], preDir exceeds [0,2], or
 *   - pDst is not 16-byte aligned
 * OMX_StsErr
 *   - In DecodeVLCZigzag_IntraDCVLC_S16, dc_size > 12
 *   - At least one of mark bits equals zero
 *   - Illegal stream encountered; code cannot be located in VLC table
 *   - Forbidden code encountered in the VLC FLC table
 *   - The number of coefficients is greater than 64
 *
 */

OMXResult omxVCM4P2_DecodeVLCZigzag_IntraDCVLC(
     const OMX_U8 ** ppBitStream,
     OMX_INT * pBitOffset,
     OMX_S16 * pDst,
     OMX_U8 predDir,
     OMX_INT shortVideoHeader,
     OMXVCM4P2VideoComponent videoComp
)
{
    /* Dummy initilaization to remove compilation error */
    OMX_S8  DCValueSize = 0;
    OMX_U16 powOfSize, fetchDCbits;
    OMX_U8 start = 1;

    /* Argument error checks */
    armRetArgErrIf(ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(*ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pBitOffset == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pDst == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(!armIs4ByteAligned(pDst), OMX_StsBadArgErr);
    armRetArgErrIf((*pBitOffset < 0) || (*pBitOffset > 7), OMX_StsBadArgErr);
    armRetArgErrIf((predDir > 2), OMX_StsBadArgErr);

    /* Insert the code into the bitstream */
    if (videoComp == OMX_VC_LUMINANCE)
    {
        DCValueSize = armUnPackVLC32(ppBitStream,
                            pBitOffset, armVCM4P2_aIntraDCLumaIndex);
        armRetDataErrIf(DCValueSize == -1, OMX_StsErr);
    }
    else if (videoComp == OMX_VC_CHROMINANCE)
    {
        DCValueSize = armUnPackVLC32(ppBitStream,
                            pBitOffset, armVCM4P2_aIntraDCChromaIndex);
        armRetDataErrIf(DCValueSize == -1, OMX_StsErr);
    }


    if (DCValueSize == 0)
    {
        pDst[0] = 0;
    }
    else
    {
        fetchDCbits = (OMX_U16) armGetBits(ppBitStream, pBitOffset, \
                                           DCValueSize);

        if ( (fetchDCbits >> (DCValueSize - 1)) == 0)
        {
            /* calulate pow */
            powOfSize = (1 << DCValueSize);

            pDst[0] =  (OMX_S16) (fetchDCbits ^ (powOfSize - 1));
            pDst[0] = -pDst[0];
        }
        else
        {
            pDst[0] = fetchDCbits;
        }

        if (DCValueSize > 8)
        {
            /* reading and checking the marker bit*/
            armRetDataErrIf (armGetBits(ppBitStream, pBitOffset, 1) == 0, \
                             OMX_StsErr);
        }
    }

    return armVCM4P2_DecodeVLCZigzag_Intra(
                ppBitStream,
                pBitOffset,
                pDst,
                predDir,
                shortVideoHeader,
                start);
}

/* End of file */

