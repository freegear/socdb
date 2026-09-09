/**
 *  omxACAAC_DecodeChanPairElt.c
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
 * This file contains module for Parsing channel pair element information from AAC bitstream
 *
 */

#include "omxtypes.h"
#include "omxAC.h"

#include "armAC.h"
#include "armCOMM.h"
#include "armCOMM_Bitstream.h"

/**
 * Function: omxACAAC_DecodeChanPairElt
 *
 * Description:
 * Decode channel_pair_element
 * ISO/IEC 14496-3(1999E), table 4.4.5
 *
 * Remarks:
 * Retrieves the channel_pair_element from the input bit stream.
 *
 *
 * Parameters:
 * [in]  ppBitStream        double pointer to the current byte.
 * [in]  pOffset            pointer to the bit position in the byte pointed by *ppBitStream. Valid within 0 to
 *                                7. 0: MSB of the byte, 7: LSB of the byte.
 * [in]  audioObjectType    index of audio object type. 2: LC, 4: LTP
 * [out] ppBitStream        double pointer to the current byte, after decoding the channel pair element.
 * [out] pOffset            pointer to the bit position in the byte pointed by *ppBitStream. Valid within 0 to
 *                                7. 0: MSB of the byte, 7: LSB of the byte.
 * [out] pIcsInfo           pointer to OMXAACIcsInfo structure.
 * [out] pChanPairElt       pointer to channel pair element.
 * [out] pLtpInfo		        pointer to LTP information structure.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
 
OMXResult omxACAAC_DecodeChanPairElt(
     const OMX_U8 **ppBitStream,
     OMX_INT *pOffset,
     OMXAACIcsInfo *pIcsInfo,
     OMXAACChanPairElt *pChanPairElt,
     OMX_INT audioObjectType,
     OMXAACLtpInfoPtr *pLtpInfo
 )
{
    OMX_INT i,j;
    OMXResult errorCode;

    /* Argument Check */        
    armRetArgErrIf( ppBitStream    == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( *ppBitStream   == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pOffset        == NULL, OMX_StsBadArgErr);

    armRetArgErrIf( pIcsInfo       == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pLtpInfo       == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pChanPairElt   == NULL, OMX_StsBadArgErr);

    armRetArgErrIf( (*pOffset > 7) || (*pOffset < 0)   , OMX_StsBadArgErr);
    
    armRetArgErrIf( (audioObjectType != 2) &&
                    (audioObjectType != 4), OMX_StsBadArgErr);

    /* Processing */    
    armSkipBits(ppBitStream,pOffset,4); /*element_instance_tag*/
    
    pChanPairElt->commonWin = (OMX_INT)armGetBits(ppBitStream,pOffset,1); 
     

    if(pChanPairElt->commonWin == 1)
    {
        
        errorCode = armACAAC_DecodeIcsInfoData(ppBitStream,pOffset,
                            pChanPairElt->commonWin,audioObjectType,
                            0,NULL,pIcsInfo,pLtpInfo);
    
        armRetDataErrIf(errorCode != OMX_StsNoErr , errorCode);
       
        pChanPairElt->msMaskPres = (OMX_INT)armGetBits(ppBitStream,pOffset,2);

        
        if(pChanPairElt->msMaskPres == 1)
        {
            for(i = 0;i < pIcsInfo->numWinGrp;i++)
            {
                for(j = 0 ; j < pIcsInfo->maxSfb ; j++ )
                {
                    pChanPairElt->ppMsMask[i][j] = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
                }
            }
        }
        
    }/*End if() */
    
        
    return OMX_StsNoErr;

}
 /* End of File */
