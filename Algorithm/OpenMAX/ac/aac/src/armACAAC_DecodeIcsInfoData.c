/**
 *  armACAAC_DecodeIcsInfoData.c
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
 * This file contains module for parsing Ics-info from an AAC bitstream
 *
 */
#include "omxtypes.h"
#include "omxAC.h"

#include "armAC.h"
#include "armCOMM_Bitstream.h"
#include "armACAAC_Tables.h"

/**
 * Function: armACAAC_DecodeIcsInfoData
 *
 * Description:
 * Parses ICS information from the bit stream.
 *
 * Parameters:
 * [in/out]  ppBitStream  pointer to the pointer to the current byte
 * [in/out]  pOffset	  pointer to the bit position in the byte pointed
 *                         by *ppBitStream. Valid within 0 to 7. 0: MSB of
 *                         the byte, 7: LSB of the byte.
 * [in]  commonWin         1/0:Infomation shared/ notshared for two channels
 * [in]  audioObjectType   audio object type indication. 1:main, 2:LC, 4: LTP 
 * [in]  predSfbMax         maximum prediction scalefactor bands. For LC profile, set predSfbMax = 0
 *                                for there is no predictors.
 * [out] pChanInfo     pointer to the channel information structure
 *                          used as output only if != NULL
 * [out] pIcsInfo     pointer to the ICS information structure
 * [out] pLtpInfo          pointer to the array of pointers to the LTP information structures
 *
 */
 

OMXResult armACAAC_DecodeIcsInfoData(
                                const OMX_U8 **ppBitStream,
                                OMX_INT *pOffset,
                                OMX_INT commonWin,
                                OMX_INT audioObjectType,
                                OMX_INT predSfbMax,
                                OMXAACChanInfo *pChanInfo,
                                OMXAACIcsInfo *pIcsInfo,
                                OMXAACLtpInfoPtr *pLtpInfo
                            )
{
    OMX_INT i,nextVar;
    
    pIcsInfo->icsReservedBit = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
    pIcsInfo->winSequence    = (OMX_INT)armGetBits(ppBitStream,pOffset,2); 
    pIcsInfo->winShape       = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
    
    if(pIcsInfo->winSequence == ARM_AAC_EIGHT_SHORT_SEQUENCE) 
    {
        if(pChanInfo != NULL)
        {
            pChanInfo->winLen       = ARM_AAC_WIN_SHORT;
            pChanInfo->numWin       = OMX_AAC_WIN_MAX;
            pChanInfo->numSwb       = armACAAC_numSwbShort[pChanInfo->samplingRateIndex];
        }
        
        pIcsInfo->maxSfb        = (OMX_INT)armGetBits(ppBitStream,pOffset,4);/*max_sfb*/
        pIcsInfo->numWinGrp     = 1;
        pIcsInfo->pWinGrpLen[0] = 1;
       
        nextVar                 = (OMX_INT)armGetBits(ppBitStream,pOffset,7);
        pIcsInfo->sfGrouping    = nextVar;
     
        for(i = 0 ; i < 7 ; i++)
        {
            if( (  ( nextVar >> (6 - i) ) & 1) == 0)
            {
                pIcsInfo->numWinGrp++;
                pIcsInfo->pWinGrpLen[pIcsInfo->numWinGrp - 1] = 1;
            }
            else
            {
                pIcsInfo->pWinGrpLen[pIcsInfo->numWinGrp - 1] += 1;
            }
            
        }
        
    } 
    else
    {
        if(pChanInfo != NULL)
        {
            pChanInfo->winLen       = ARM_AAC_WIN_LONG;
            pChanInfo->numWin       = 1;
            pChanInfo->numSwb       = armACAAC_numSwbLong[pChanInfo->samplingRateIndex];
        }
        
        nextVar = (OMX_INT)armGetBits(ppBitStream,pOffset,6);/*max_sfb*/
        
        if(nextVar > 51 )
        {
            return OMX_StsAacMaxSfbErr; 
        }                                       
        
        pIcsInfo->maxSfb        = nextVar;
        pIcsInfo->numWinGrp     = 1;
        pIcsInfo->pWinGrpLen[0] = 1;

        pIcsInfo->predDataPres  = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
        
        if (audioObjectType == ARM_AAC_LTP) 
        {
            if(pIcsInfo->predDataPres == 1)
            {
                pLtpInfo[0]->ltpDataPresent = (OMX_INT)armGetBits(ppBitStream,pOffset,1);

                if(pLtpInfo[0]->ltpDataPresent == 1)
                {
                    /*LTP data Present*/
                    armACAAC_DecodeLtpData(ppBitStream,pOffset,pIcsInfo->winSequence,pIcsInfo->maxSfb,pLtpInfo[0]);        
                }

                if(commonWin == 1)
                {
                    pLtpInfo[1]->ltpDataPresent = (OMX_INT)armGetBits(ppBitStream,pOffset,1);

                    if(pLtpInfo[1]->ltpDataPresent == 1)
                    {
                        /*LTP data Present*/
                        armACAAC_DecodeLtpData(ppBitStream,pOffset,pIcsInfo->winSequence,pIcsInfo->maxSfb,pLtpInfo[1]);        
                    }
                }
            }
        }
        else if(audioObjectType == 1)/*AAC Main*/
        {
            if(pIcsInfo->predDataPres == 1)
            {
                pIcsInfo->predReset  = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
               
                if(pIcsInfo->predReset == 1)
                {
                    pIcsInfo->predResetGroupNum = (OMX_INT)armGetBits(ppBitStream,pOffset,5);
                }
                
                for( i = 0 ; i < armMin(pIcsInfo->maxSfb,predSfbMax); i ++) 
                {
                    pIcsInfo->pPredUsed[i] = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
                }
            }
        }
    }
    
    return OMX_StsNoErr;
}

/*End of File*/
