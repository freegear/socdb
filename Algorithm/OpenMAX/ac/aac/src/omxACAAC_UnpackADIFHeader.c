/**
 *  omxACAAC_UnpackADIFHeader.c
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
 * This file contains module for parsing ADIF header information from AAC bitstream
 *
 */

#include "omxtypes.h"
#include "omxAC.h"

#include "armCOMM.h"
#include "armCOMM_Bitstream.h"



/**
 * Function: omxACAAC_UnpackADIFHeader
 *
 * Description:
 * Unpacks the AAC frame header.
 * Reference to ISO/IEC 14496-3(1999E), table 1.A.2 

 *
 * Remarks:
 * This function gets the AAC ADIF format header, including program
 * configuration elements from the input bit stream.
 *
 *
 * Parameters:
 * [in]  ppBitStream        double pointer to the first byte of the AAC
 *                                frame header
 * [in]  prgCfgEltMax       the maximum program configure element number
 * [out] ppBitStream        double pointer to the first byte of the AAC
 *                                frame header after decode header information
 * [out] pADIFHeader        pointer to the OMXACCADIFHeader structure
 * [out] pPrgCfgElt           pointer to the OMXAACPrgCfgElt structure.
 *                                There must be prgCfgEltMax elements in the buffer.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxACAAC_UnpackADIFHeader (
     const OMX_U8 **ppBitStream,
     OMXAACADIFHeader *pADIFHeader,
     OMXAACPrgCfgElt *pPrgCfgElt,
     OMX_INT prgCfgEltMax
 )
{
    OMX_INT   i,Offset = 0;
    OMXResult errorCode;

    /* Argument Check */        
    armRetArgErrIf(ppBitStream  == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(*ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pADIFHeader  == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(pPrgCfgElt   == NULL, OMX_StsBadArgErr);

    armRetArgErrIf( (prgCfgEltMax > OMX_AAC_ELT_NUM) || (prgCfgEltMax < 1), OMX_StsBadArgErr);
        
    /* Processing */
    pADIFHeader->ADIFId     = (OMX_INT)armGetBits(ppBitStream,&Offset,32);
    pADIFHeader->copyIdPres = (OMX_INT)armGetBits(ppBitStream,&Offset,1);
    
    if(pADIFHeader->copyIdPres == 1)
    {
        for(i = 0; i < 9 ; i++)
        {
            pADIFHeader->pCopyId[i] = (OMX_INT)armGetBits(ppBitStream,&Offset,8);
        }
    }

    pADIFHeader->originalCopy   = (OMX_INT)armGetBits(ppBitStream,&Offset,1);
    pADIFHeader->home           = (OMX_INT)armGetBits(ppBitStream,&Offset,1);
    pADIFHeader->bitstreamType  = (OMX_INT)armGetBits(ppBitStream,&Offset,1);
    pADIFHeader->bitRate        = (OMX_INT)armGetBits(ppBitStream,&Offset,23);
    pADIFHeader->numPrgCfgElt   = (OMX_INT)armGetBits(ppBitStream,&Offset,4) + 1;
    
    armRetDataErrIf( pADIFHeader->numPrgCfgElt > prgCfgEltMax, OMX_StsAacPrgNumErr );

    for(i = 0 ;i < pADIFHeader->numPrgCfgElt ; i++ )    
    {
        if(pADIFHeader->bitstreamType == 0)    
        {
            pADIFHeader->pADIFBufFullness[i] = (OMX_INT)armGetBits(ppBitStream,&Offset,20);
        }
        
        errorCode = omxACAAC_DecodePrgCfgElt(ppBitStream,&Offset,&pPrgCfgElt[i]);
        
        armRetDataErrIf( errorCode != OMX_StsNoErr, errorCode );
    }
    
    return OMX_StsNoErr;
}
/* End of File */
