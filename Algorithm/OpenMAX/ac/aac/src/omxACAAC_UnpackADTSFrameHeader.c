/**
 *  omxACAAC_UnpackADTSFrameHeader.c
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
 * This file contains module for parsing ADTS header information from AAC bitstream
 *
 */
 
#include "omxtypes.h"
#include "omxAC.h"

#include "armCOMM.h"
#include "armCOMM_Bitstream.h"

/**
 * Function: omxACAAC_UnpackADTSFrameHeader
 *
 * Description:
 * Gets ADTS frame header from the input bit stream.
 * Reference to ISO/IEC 14496-3(1999E), table 1.A.6 

 *
 * Remarks:
 * This function decode AAC ADTS frame header.
 *
 *
 * Parameters:
 * [in]  ppBitStream        double pointer to the current byte
 * [out] pADTSFrameHeader   pointer to the OMXAACADTSFrameHeader structure
 * [out] ppBitStream        double pointer to the current byte after decode
 *								  header information
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
 
OMXResult omxACAAC_UnpackADTSFrameHeader(
     const OMX_U8 **ppBitStream,
     OMXAACADTSFrameHeader *pADTSFrameHeader
 )
{
        
    OMX_INT offset = 0, *pOffset;

    /* Argument Check */
    armRetArgErrIf(ppBitStream      == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(*ppBitStream     == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pADTSFrameHeader == NULL, OMX_StsBadArgErr);

    /* Processing */
    pOffset = &offset;
           
    /* ADTS Fixed Header */
    armByteAlign(ppBitStream, pOffset);
    armSkipBits(ppBitStream, pOffset, 12);/*Syncword*/
    
    pADTSFrameHeader->id            = (OMX_INT)armGetBits(ppBitStream, pOffset, 1);
    pADTSFrameHeader->layer         = (OMX_INT)armGetBits(ppBitStream, pOffset, 2);
    pADTSFrameHeader->protectionBit = (OMX_INT)armGetBits(ppBitStream, pOffset, 1);
    
    pADTSFrameHeader->profile           = (OMX_INT)armGetBits(ppBitStream, pOffset, 2);
    pADTSFrameHeader->samplingRateIndex = (OMX_INT)armGetBits(ppBitStream, pOffset, 4);
    pADTSFrameHeader->privateBit        = (OMX_INT)armGetBits(ppBitStream, pOffset, 1);

    pADTSFrameHeader->chConfig     = (OMX_INT)armGetBits(ppBitStream, pOffset, 3);
    pADTSFrameHeader->originalCopy = (OMX_INT)armGetBits(ppBitStream, pOffset, 1);
    pADTSFrameHeader->home         = (OMX_INT)armGetBits(ppBitStream, pOffset, 1);
    pADTSFrameHeader->emphasis     = (OMX_INT)armGetBits(ppBitStream, pOffset, 2);

    /* ADTS Variable Header */
    pADTSFrameHeader->cpRightIdBit    = (OMX_INT)armGetBits(ppBitStream, pOffset, 1);
    pADTSFrameHeader->cpRightIdStart  = (OMX_INT)armGetBits(ppBitStream, pOffset, 1);
    pADTSFrameHeader->frameLen        = (OMX_INT)armGetBits(ppBitStream, pOffset, 13);
    pADTSFrameHeader->ADTSBufFullness = (OMX_INT)armGetBits(ppBitStream, pOffset, 11);
    pADTSFrameHeader->numRawBlock     = (OMX_INT)armGetBits(ppBitStream, pOffset, 2);

    /* ADTS Error Check */    
    if(pADTSFrameHeader->protectionBit == 0)
    {
        /* Read CRC Word */
        pADTSFrameHeader->CRCWord = (OMX_INT)armGetBits(ppBitStream, pOffset, 16);
    }
    
    
    return  OMX_StsNoErr;
        
}
/* End of File */
