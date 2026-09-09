/**
 *  armACAAC_DecodeLtpData.c
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
 * This file contains module for decoding TNS coefficients
 *
 */

#include "omxtypes.h"
#include "omxAC.h"

#include "armAC.h"
#include "armCOMM_Bitstream.h"

/**
 * Function: armACAAC_DecodeLtpData
 *
 * Description:
 * Parses the LTP information from the bit stream.
 *
 * Parameters:
 * [in/out]  ppBitStream  pointer to the pointer to the current byte
 * [in/out]  pOffset	  pointer to the bit position in the byte pointed
 *                         by *ppBitStream. Valid within 0 to 7. 0: MSB of
 *                         the byte, 7: LSB of the byte.
 * [in]  winSequence      window type, short or long
 * [in]  maxSfb           number of scale factor band
 * [out] pAACLtpInfo      pointer to the LTP information
 *
 */

OMXVoid armACAAC_DecodeLtpData(
                          const OMX_U8 **ppBitStream,
                          OMX_INT *pOffset,
                          OMX_INT winSequence,
                          OMX_INT maxSfb,
                          OMXAACLtpInfo *pLtpInfo
                        ) 
{
    OMX_INT sfbNum;
    
    pLtpInfo->ltpLag  = (OMX_INT)armGetBits(ppBitStream,pOffset,11);
    pLtpInfo->ltpCoef = (OMX_INT)armGetBits(ppBitStream,pOffset,3);

    if(winSequence != ARM_AAC_EIGHT_SHORT_SEQUENCE)
    {
        for(sfbNum = 0; sfbNum < armMin(maxSfb,OMX_AAC_MAX_LTP_SFB) ; sfbNum++ )
        {
            pLtpInfo->pLtpLongUsed[sfbNum] = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
        }
    }

    return;
}

/*End of File*/

