/**
 *  omxACAAC_DecodePrgCfgElt.c
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
 * Function: omxACAAC_DecodePrgCfgElt
 *
 * Description:
 * Unpacks the AAC PCE information.
 * Reference to ISO/IEC 14496-3(1999E), table 4.4.2

 *
 * Remarks:
 * Gets program configuration element from the input bit stream.
 *
 *
 * Parameters:
 * [in]  ppBitStream        double pointer to the current byte
 * [in]  pOffset            pointer to the bit position in the byte
 * [out] ppBitStream        double pointer to the current byte after decoding
 *                                the program configuration element
 * [out] pOffset            pointer to the bit position in the byte
 *                                pointed by *ppBitStream. Valid within 0 to 7. 0:
 *                                MSB of the byte, 7: LSB of the byte.
 * [out] pPrgCfgElt         pointer to OMXAACPrgCfgElt structure
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxACAAC_DecodePrgCfgElt(
     const OMX_U8 **ppBitStream,
     OMX_INT *pOffset,
     OMXAACPrgCfgElt *pPrgCfgElt
 )
{

    OMX_INT i; 
    
    /* Argument Check */        
    armRetArgErrIf( ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf(*ppBitStream == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pOffset     == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pPrgCfgElt  == NULL, OMX_StsBadArgErr);
    
    armRetArgErrIf( (*pOffset > 7) || (*pOffset < 0), OMX_StsBadArgErr);

    /* Processing */
    pPrgCfgElt->eltInsTag           = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
    pPrgCfgElt->profile             = (OMX_INT)armGetBits(ppBitStream,pOffset,2);
    pPrgCfgElt->samplingRateIndex   = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
    pPrgCfgElt->numFrontElt         = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
    pPrgCfgElt->numSideElt          = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
    pPrgCfgElt->numBackElt          = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
    pPrgCfgElt->numLfeElt           = (OMX_INT)armGetBits(ppBitStream,pOffset,2);
    pPrgCfgElt->numDataElt          = (OMX_INT)armGetBits(ppBitStream,pOffset,3);
    pPrgCfgElt->numValidCcElt       = (OMX_INT)armGetBits(ppBitStream,pOffset,4);

    pPrgCfgElt->monoMixdownPres     = (OMX_INT)armGetBits(ppBitStream,pOffset,1);

    if(pPrgCfgElt->monoMixdownPres == 1)
    {
        pPrgCfgElt->monoMixdownEltNum = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
    }

    pPrgCfgElt->stereoMixdownPres = (OMX_INT)armGetBits(ppBitStream,pOffset,1);

    if(pPrgCfgElt->stereoMixdownPres == 1)
    {
        pPrgCfgElt->stereoMixdownEltNum = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
    }

    pPrgCfgElt->matrixMixdownIdxPres = (OMX_INT)armGetBits(ppBitStream,pOffset,1);

    if(pPrgCfgElt->matrixMixdownIdxPres == 1)
    {
        pPrgCfgElt->matrixMixdownIdx = (OMX_INT)armGetBits(ppBitStream,pOffset,2);
        pPrgCfgElt->pseudoSurroundEnable = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
    }

    for (i = 0; i < pPrgCfgElt->numFrontElt ; i++ ) 
    {
        pPrgCfgElt->pFrontIsCpe[i]  = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
        pPrgCfgElt->pFrontTagSel[i] = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
    }

    for (i = 0; i < pPrgCfgElt->numSideElt ; i++ )
    {
        pPrgCfgElt->pSideIsCpe[i]  = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
        pPrgCfgElt->pSideTagSel[i] = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
    }

    for (i = 0; i < pPrgCfgElt->numBackElt ; i++ )
    {
        pPrgCfgElt->pBackIsCpe[i]  = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
        pPrgCfgElt->pBackTagSel[i] = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
    }

    for (i = 0; i < pPrgCfgElt->numLfeElt ; i++ )
    {
        pPrgCfgElt->pLfeTagSel[i] = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
    }
   
    for (i = 0; i < pPrgCfgElt->numDataElt ; i++ )
    {
        pPrgCfgElt->pDataTagSel[i] = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
    }
   
    for (i = 0; i < pPrgCfgElt->numValidCcElt ; i++ )
    {
        pPrgCfgElt->pCceIsIndSw[i]  = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
        pPrgCfgElt->pCceTagSel[i]   = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
    }
    
    armByteAlign(ppBitStream,pOffset);
    
    pPrgCfgElt->numComBytes = (OMX_INT)armGetBits(ppBitStream,pOffset,8);
    
    for (i = 0; i < pPrgCfgElt->numComBytes ; i++ )
    {
        pPrgCfgElt->pComFieldData[i] = (OMX_INT)armGetBits(ppBitStream,pOffset,8);
    }

    return OMX_StsNoErr;

}
/* End of File */
