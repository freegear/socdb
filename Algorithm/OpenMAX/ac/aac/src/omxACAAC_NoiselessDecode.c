/**
 *  omxACAAC_NoiselessDecode.c
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
 * This file contains module for Noiseless decoding for an AAC decoder
 *
 */

 
#include "omxtypes.h"
#include "omxAC.h"

#include "armCOMM.h"
#include "armCOMM_Bitstream.h"
#include "armAC.h"

#include "armACAAC_Tables.h"

#include <assert.h>

/*Local Function Declarations - Not used outside this file*/
static OMXVoid armACAAC_DecodeSectionData(
                                const OMX_U8    **ppBitStream,
                                OMX_INT         *pOffset,
                                OMX_U8          *pDstSfbCb,
                                OMXAACChanInfo  *pChanInfo
                                    );
                             
static OMXResult armACAAC_DecodeScaleFactorData(
                                    const OMX_U8  **ppBitStream,
                                    OMX_INT       *pOffset,
                                    OMX_U8        *pDstSfbCb,
                                    OMX_S16       *pDstScalefactor,
                                    OMX_INT       globGain,
                                    OMXAACIcsInfo *pIcsInfo
                                    );
                                
static OMXResult armACAAC_DecodeSpectralData(
                                const OMX_U8    **ppBitStream,
                                OMX_INT         *pOffset,
                                OMX_S32         *pDstQuantizedSpectralCoef,
                                OMXAACChanInfo  *pChanInfo
                              );

static OMXResult armACAAC_DecodePulseData(
                            const OMX_U8  **ppBitStream,
                            OMX_INT       *pOffset,
                            const OMX_U16 *pOffsetTable,
                            OMX_INT       *numPulse,
                            OMX_INT       *pulseStart,
                            OMX_INT       *pulseOff,
                            OMX_INT       *pulseAmp,
                            OMX_U16        numSwb
                          );
                          
static OMXVoid armACAAC_DecodeTNSData(
                            const OMX_U8   **ppBitStream,
                            OMX_INT        *pOffset,
                            OMX_INT         audioObjectType,
                            OMX_S8         *pDstTnsFiltCoef,
                            OMXAACChanInfo *pChanInfo
                        );
/**
 * Function: omxACAAC_NoiselessDecode
 *
 * Description:
 * Huffman decoder
 * Reference to ISO/IEC 14496-3 Sect 6.3
 *
 * Remarks:
 * This is a general noiseless decode module for MPEG-2 and MPEG-4 objects.
 *
 *
 * Parameters:
 * [in]  ppBitStream        double pointer to the bit stream to be parsed
 * [in]  pOffset            pointer to the offset in one byte
 * [in]  pChanInfo          pointer to channel information structure
 * [in]  commonWin          if channel pair use the same ics information
 * [in]  audioObjectType    audio object type indication. 1:main, 2:LC, 4: LTP, 6:scaleable
 * [out] ppBitStream        double pointer to the bit stream has been parsed
 * [out] pOffset            pointer to the offset in one byte
 * [out] pChanInfo          pointer to channel information structure
 * [out] pDstScalefactor    Pointer to the scale factor has been parsed.
 * [out] pDstQuantizedSpectralCoef    Pointer to the quantized spectral 
 *													coefficients after Huffman decoder.
 *													represented in Q16.15 format.
 * [out] pDstSfbCb          Pointer to the scale factor code book index.
 * [out] pDstTnsFiltCoef    Pointer to TNS filter coefficients. Not used in scaleable object.
 * [out] pLtpInfo		        Pointer to LTP information structure.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxACAAC_NoiselessDecode(
     const OMX_U8 **ppBitStream,
     OMX_INT *pOffset,
     OMX_S16 *pDstScalefactor,
     OMX_S32 *pDstQuantizedSpectralCoef,
     OMX_U8 *pDstSfbCb,
     OMX_S8 *pDstTnsFiltCoef,
     OMXAACChanInfo *pChanInfo,
     OMX_INT commonWin,
     OMX_INT audioObjectType,
     OMXAACLtpInfoPtr *pLtpInfo 
 )
{
            
    OMXAACIcsInfo   *pIcsInfo;
    OMXResult       errorCode;

    const OMX_U16   *pOffsetTable;
    OMX_U16         numSwb;
    OMX_INT         numPulse = 0,pulseStart = 0;
    OMX_INT         pulseOff[4],pulseAmp[4];
    OMX_INT         j,k;
    
       
    /* Argument Check */        
    armRetArgErrIf( pDstQuantizedSpectralCoef == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pDstScalefactor           == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pDstTnsFiltCoef           == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pDstSfbCb                 == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( ppBitStream               == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( *ppBitStream              == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pOffset                   == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pChanInfo                 == NULL, OMX_StsBadArgErr);

    armRetArgErrIf( (commonWin > 1)   || (commonWin < 0)  , OMX_StsBadArgErr);
    armRetArgErrIf( (*pOffset > 7)    || (*pOffset < 0)   , OMX_StsBadArgErr);

    armRetArgErrIf( audioObjectType > 16 , OMX_StsBadArgErr);
    armRetArgErrIf( audioObjectType < 0  , OMX_StsBadArgErr);

    /* Processing */
    pIcsInfo = pChanInfo->pIcsInfo;
    pOffsetTable = armACAAC_swbOffsetLongWindow[pChanInfo->samplingRateIndex];

    pChanInfo->globGain = (OMX_INT)armGetBits(ppBitStream,pOffset,8);
    
    if(!commonWin)
    {
        errorCode  = armACAAC_DecodeIcsInfoData(ppBitStream,pOffset,commonWin,
                    audioObjectType,pChanInfo->predSfbMax,pChanInfo,pChanInfo->pIcsInfo,pLtpInfo);
        
        armRetDataErrIf(errorCode != OMX_StsNoErr , errorCode);
    }
    
    /*Section Data*/
    
    armACAAC_DecodeSectionData(ppBitStream,pOffset,pDstSfbCb,pChanInfo);

    /*ScaleFactor data*/

    errorCode = armACAAC_DecodeScaleFactorData(ppBitStream,pOffset,pDstSfbCb,
                    pDstScalefactor,pChanInfo->globGain,pIcsInfo);
    
    armRetDataErrIf(errorCode != OMX_StsNoErr , errorCode);


    /*Pulse Data*/

    pChanInfo->pulseDataPres = (OMX_INT)armGetBits(ppBitStream,pOffset,1);     

    if(pChanInfo->pulseDataPres == 1)
    {
        armRetDataErrIf(pIcsInfo->winSequence == ARM_AAC_EIGHT_SHORT_SEQUENCE , 
                        OMX_StsErr);

        numSwb    = armACAAC_numSwbLong[pChanInfo->samplingRateIndex];
        
        errorCode = armACAAC_DecodePulseData(ppBitStream,pOffset,pOffsetTable,
                        &numPulse,&pulseStart,pulseOff,pulseAmp,numSwb);

        armRetDataErrIf(errorCode != OMX_StsNoErr , errorCode);
    }
    
    /*TNS Data*/

    pChanInfo->tnsDataPres = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
    
    if(pChanInfo->tnsDataPres == 1)
    {
        armACAAC_DecodeTNSData(ppBitStream,pOffset,audioObjectType,
                        pDstTnsFiltCoef,pChanInfo);
    }
    
    /*Gain Control Data*/

    pChanInfo->gainContrDataPres = (OMX_INT)armGetBits(ppBitStream,pOffset,1); 
    
    armRetDataErrIf(pChanInfo->gainContrDataPres == 1 ,
                    OMX_StsAacGainCtrErr);
    
    /*Spectral Data*/

    errorCode = armACAAC_DecodeSpectralData(ppBitStream,pOffset,pDstQuantizedSpectralCoef,
                    pChanInfo);
    
    armRetDataErrIf(errorCode != OMX_StsNoErr , errorCode);
    
    
    /* Applying Pulse data */
        
    if (pChanInfo->pulseDataPres == 1) 
    {
        k = pOffsetTable[pulseStart];
        
        for (j = 0; j< (numPulse + 1); j++)
        {
            k += pulseOff[j];
        
            if ( pDstQuantizedSpectralCoef[k] > 0 )
            {
                pDstQuantizedSpectralCoef[k] += pulseAmp[j];
            }
            else
            {
                pDstQuantizedSpectralCoef[k] -= pulseAmp[j];
            }
        }
    }

    return OMX_StsNoErr;
}


static OMXVoid armACAAC_DecodeSectionData(
                                const OMX_U8 **ppBitStream,
                                OMX_INT *pOffset,
                                OMX_U8 *pDstSfbCb,
                                OMXAACChanInfo *pChanInfo
                             )
{
    OMX_INT         sectEscVal,groupNum,nextVar;
    OMX_INT         sfbNum,sectNum,sectLen,sfb;

    OMXAACIcsInfo   *pIcsInfo = pChanInfo->pIcsInfo;
    OMX_U8          *pSectCb  = pChanInfo->pSectCb;
    OMX_U8          *pSectEnd = pChanInfo->pSectEnd;
    
    if(pIcsInfo->winSequence == ARM_AAC_EIGHT_SHORT_SEQUENCE) 
    {
        sectEscVal = (1 << 3) - 1;
    }
    else
    {
        sectEscVal = (1 << 5) - 1;
    }
    
    for(groupNum = 0 ; groupNum < pIcsInfo->numWinGrp ; groupNum ++)
    {
        sfbNum  = 0;
        sectNum = 0;
        
        while(sfbNum < pIcsInfo->maxSfb)
        {
            *pSectCb = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
            sectLen   = 0;
            
            do
            {
                if(pIcsInfo->winSequence == ARM_AAC_EIGHT_SHORT_SEQUENCE) 
                {
                    nextVar = (OMX_INT)armGetBits(ppBitStream,pOffset,3);
                }
                else
                {
                    nextVar = (OMX_INT)armGetBits(ppBitStream,pOffset,5);
                }
            
                sectLen += nextVar;
                
                armAssert(sectLen <= OMX_AAC_SF_MAX);
                
            }while(nextVar == sectEscVal);
            
            *pSectEnd = sfbNum + sectLen;
            pSectEnd++;
        
            for(sfb = sfbNum ; sfb < (sfbNum + sectLen) ; sfb++ )
            {
                *pDstSfbCb = *pSectCb;
                pDstSfbCb++;
            }
            
            sfbNum += sectLen;
            sectNum++;
            pSectCb++;
        }
        
        pChanInfo->pMaxSect[groupNum] = sectNum; 
    }
    
    return;
}

static OMXResult armACAAC_DecodeScaleFactorData(
                                    const OMX_U8 **ppBitStream,
                                    OMX_INT *pOffset,
                                    OMX_U8 *pDstSfbCb,
                                    OMX_S16 *pDstScalefactor,
                                    OMX_INT globGain,
                                    OMXAACIcsInfo *pIcsInfo
                                    )
{

    OMX_INT groupNum,sfbNum,cbNum,noiseFlag;
    OMX_INT lastSf,dpcmSf;
    OMX_INT lastIsPos,dpcmIsPos;
    OMX_INT lastNoiseNrg = 0,dpcmNoiseNrg;
    OMX_S16 index;

    lastSf    = globGain;
    lastIsPos = 0;
    noiseFlag = 1;
    
    for(groupNum = 0 ; groupNum < pIcsInfo->numWinGrp ; groupNum ++)
    {
        for(sfbNum = 0; sfbNum < pIcsInfo->maxSfb ; sfbNum++)
        {
            cbNum = *pDstSfbCb++;
            
            switch(cbNum)            
            {
                case ARM_AAC_NOISE_HCB:
                    
                    if(noiseFlag)
                    {
                        lastNoiseNrg  = (OMX_INT)armGetBits(ppBitStream,pOffset,9);
                        lastNoiseNrg += globGain - ARM_AAC_NOISE_OFFSET - 256;
                        
                        noiseFlag = 0;
                    }
                    else
                    {
                        index = armUnPackVLC32(ppBitStream,pOffset,armACAAC_CodeBooks[0]);
                        
                        if(index == -1)
                        {
                            return OMX_StsErr;
                        }

                        dpcmNoiseNrg = index - ARM_AAC_INDEX_OFFSET;
                        lastNoiseNrg = dpcmNoiseNrg + lastNoiseNrg;
                    }

                    *pDstScalefactor++ = lastNoiseNrg;
                
                    break;
                    
                case ARM_AAC_INTENSITY_HCB:
                case ARM_AAC_INTENSITY_HCB2:
                    
                    index = armUnPackVLC32(ppBitStream,pOffset,armACAAC_CodeBooks[0]);

                    if(index == -1)
                    {
                        return OMX_StsErr;
                    }

                    dpcmIsPos = index - ARM_AAC_INDEX_OFFSET;
                    lastIsPos = dpcmIsPos + lastIsPos;

                    *pDstScalefactor++ = lastIsPos;
                    
                    break;
                    
                case ARM_AAC_ZERO_HCB:

                    *pDstScalefactor++ = 0;
                    
                    break;
                
                default:

                    index = armUnPackVLC32(ppBitStream,pOffset,armACAAC_CodeBooks[0]);

                    if(index == -1)
                    {
                        return OMX_StsErr;
                    }

                    dpcmSf = index - ARM_AAC_INDEX_OFFSET;
                    lastSf = dpcmSf + lastSf;

                    *pDstScalefactor++ = lastSf;

            } /*End switch(cbNum)*/

        }
        
    }

    return OMX_StsNoErr;
}


static OMXResult armACAAC_DecodeSpectralData(
                                const OMX_U8 **ppBitStream,
                                OMX_INT *pOffset,
                                OMX_S32 *pDstQuantizedSpectralCoef,
                                OMXAACChanInfo *pChanInfo
                              )
{
    OMX_INT         groupNum,sectNum,cbNum,sectSfb;
    OMX_INT         offset,sfbNum,width,indexCb,bitCount,signOffset,i;
    OMX_INT         modulo,nextBit,signBit1 = 0,signBit2 = 0;
        
    OMX_S32         Coeff1,Coeff2,Coeff3,Coeff4;
    OMX_INT         sectSfbOffset[OMX_AAC_GROUP_NUM_MAX][OMX_AAC_SF_MAX];
    const OMX_U16   *pOffsetTable;
    
    OMXAACIcsInfo   *pIcsInfo = pChanInfo->pIcsInfo;
    OMX_U8          *pSectCb  = pChanInfo->pSectCb;
    OMX_U8          *pSectEnd = pChanInfo->pSectEnd;
    
    OMX_U8          sectStart;
    OMX_U8          sectEnd   = *pSectEnd;
    
    /*Populate sectSfbOffset*/
    
    if(pIcsInfo->winSequence == ARM_AAC_EIGHT_SHORT_SEQUENCE)
    {
 
        pOffsetTable = armACAAC_swbOffsetShortWindow[pChanInfo->samplingRateIndex];
        
        for( groupNum = 0; groupNum < pIcsInfo->numWinGrp ; groupNum++ ) 
        {
            sectSfb = 0;
            offset = 0;
            
            for( sfbNum = 0; sfbNum < pIcsInfo->maxSfb; sfbNum++ )
            {
                width  = pOffsetTable[sfbNum+1] - pOffsetTable[sfbNum];
                width *= pIcsInfo->pWinGrpLen[groupNum];
                
                sectSfbOffset[groupNum][sectSfb] = offset;
                
                offset += width;
                sectSfb++;
            }

            sectSfbOffset[groupNum][sectSfb] = offset;
        }
    
    }
    else
    {
        pOffsetTable = armACAAC_swbOffsetLongWindow[pChanInfo->samplingRateIndex];
        
        for( sfbNum = 0; sfbNum < pIcsInfo->maxSfb + 1; sfbNum ++ )
        {
            sectSfbOffset[0][sfbNum] = pOffsetTable[sfbNum];
        }
            
    }
    
    
    for(groupNum = 0 ; groupNum < pIcsInfo->numWinGrp ; groupNum ++)
    {
        sectStart = 0;

        for(sectNum = 0 ; sectNum < pChanInfo->pMaxSect[groupNum] ; sectNum++)
        {
            cbNum = *pSectCb++;
            
            for(i = sectSfbOffset[groupNum][sectStart] ;
                i < sectSfbOffset[groupNum][ sectEnd ] ;)
            {

        
                if(
                    cbNum != ARM_AAC_ZERO_HCB       &&
                    cbNum != ARM_AAC_NOISE_HCB      &&
                    cbNum != ARM_AAC_INTENSITY_HCB  &&
                    cbNum != ARM_AAC_INTENSITY_HCB2 
                  )
                {
                
                    if(cbNum < ARM_AAC_FIRST_PAIR_HCB)
                    {
                        indexCb = armUnPackVLC32(ppBitStream,pOffset,armACAAC_CodeBooks[cbNum]);

                        if(indexCb == -1)
                        {
                            return OMX_StsErr;
                        }

                        if(armACAAC_signCb[cbNum] == 1)
                        {
                            modulo     = armACAAC_lavCb[cbNum] + 1;
                            signOffset = 0;
                        }
                        else
                        {
                            modulo     = 2*armACAAC_lavCb[cbNum] + 1;
                            signOffset = armACAAC_lavCb[cbNum];
                        }

                        Coeff1   = (OMX_S32)(indexCb/(modulo*modulo*modulo)) - signOffset;
                        indexCb -= (Coeff1 + signOffset)*(modulo*modulo*modulo);
                        
                        Coeff2   = (OMX_S32)(indexCb/(modulo*modulo)) - signOffset;
                        indexCb -= (Coeff2 + signOffset)*(modulo*modulo);
                        
                        Coeff3   = (OMX_S32)(indexCb/modulo) - signOffset;
                        indexCb -= (Coeff3 + signOffset)*modulo;
                        
                        Coeff4   = indexCb - signOffset;
                        
                        if(armACAAC_signCb[cbNum] == 1)
                        {
                            
                            if(Coeff1 != 0)
                            {
                                nextBit = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
                                
                                if(nextBit == 1 )
                                {
                                    Coeff1 = -Coeff1;
                                }
                            }
                            if(Coeff2 != 0)
                            {
                                nextBit = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
                                
                                if(nextBit == 1 )
                                {
                                    Coeff2 = -Coeff2;
                                }
                            }
                            if(Coeff3 != 0)
                            {
                                nextBit = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
                                
                                if(nextBit == 1 )
                                {
                                    Coeff3 = -Coeff3;
                                }
                            }
                            if(Coeff4 != 0)
                            {
                                nextBit = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
                                
                                if(nextBit == 1 )
                                {
                                    Coeff4 = -Coeff4;
                                }
                            }
                        }
                        
                        *pDstQuantizedSpectralCoef++ = Coeff1;
                        *pDstQuantizedSpectralCoef++ = Coeff2;
                        *pDstQuantizedSpectralCoef++ = Coeff3;
                        *pDstQuantizedSpectralCoef++ = Coeff4;
                        
                        i += 4;

                    }/*End if (cbNum < FIRST_PAIR_HCB)*/
                    else 
                    {
                        indexCb = armUnPackVLC32(ppBitStream,pOffset,armACAAC_CodeBooks[cbNum]);

                        if(indexCb == -1)
                        {
                            return OMX_StsErr;
                        }

                        if(armACAAC_signCb[cbNum] == 1)
                        {
                            modulo     = armACAAC_lavCb[cbNum] + 1;
                            signOffset = 0;
                        }
                        else
                        {
                            modulo     = 2*armACAAC_lavCb[cbNum] + 1;
                            signOffset = armACAAC_lavCb[cbNum];
                        }
     
                        Coeff1   = (OMX_S32)(indexCb/modulo) - signOffset;
                        indexCb -= (Coeff1 + signOffset)*modulo;
                        
                        Coeff2   = indexCb - signOffset;
                        
                        if(armACAAC_signCb[cbNum] == 1)
                        {
                            
                            if(Coeff1 != 0)
                            {
                                signBit1 = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
                                
                                if(signBit1 == 1 )
                                {
                                    Coeff1 = -Coeff1;
                                }
                            }
                            
                            if(Coeff2 != 0)
                            {
                                signBit2 = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
                                
                                if(signBit2 == 1 )
                                {
                                    Coeff2 = -Coeff2;
                                }
                            }
                        }
                        
                        if(cbNum == ARM_AAC_ESC_HCB)
                        {

                            if(
                                Coeff1 ==  ARM_AAC_ESC_FLAG || 
                                Coeff1 == -ARM_AAC_ESC_FLAG 
                              )
                            {
                                Coeff1   = (1 << 4);
                                bitCount = 4;
                                
                                while( ( nextBit = (OMX_INT)armGetBits(ppBitStream,pOffset,1) ) != 0)
                                {
                                    Coeff1 <<= 1;
                                    bitCount++;
                                    armAssert(bitCount <= 12);
                                }
                                
                                Coeff1 += (OMX_S32)armGetBits(ppBitStream,pOffset,bitCount);

                                if(signBit1 == 1 )
                                {
                                    Coeff1 = -Coeff1;
                                }
                                
                            }
                            
                            if(
                                Coeff2 ==  ARM_AAC_ESC_FLAG ||
                                Coeff2 == -ARM_AAC_ESC_FLAG
                              )
                            {
                                Coeff2   = (1 << 4);
                                bitCount = 4;

                                while( ( nextBit = (OMX_INT)armGetBits(ppBitStream,pOffset,1) ) != 0)
                                {
                                    Coeff2 <<= 1;
                                    bitCount++;
                                    armAssert(bitCount <= 12);
                                }
                                
                                Coeff2 += (OMX_S32)armGetBits(ppBitStream,pOffset,bitCount);

                                if(signBit2 == 1 )
                                {
                                    Coeff2 = -Coeff2;
                                }

                            }
                        }
                        
                        *pDstQuantizedSpectralCoef++ = Coeff1;
                        *pDstQuantizedSpectralCoef++ = Coeff2;

                        i += 2;

                    }/*End else */
                
                }/*End if()*/
                else
                {
                    /*CodeBook - ZERO_HCB,INTENSITY_HCB,INTENSITY_HCB2,NOISE_HCB*/
                    *pDstQuantizedSpectralCoef++ = 0;
                    i++;
                }
                
            }/*End for() - The i loop*/
            
            sectStart = sectEnd;
            sectEnd   = *(++pSectEnd);

        }/*End for() - The sectNum loop*/
        
    }/*End for() - The groupNum loop*/
    
    return OMX_StsNoErr;
}

static OMXResult armACAAC_DecodePulseData(
                            const OMX_U8 **ppBitStream,
                            OMX_INT *pOffset,
                            const OMX_U16 *pOffsetTable,
                            OMX_INT *numPulse,
                            OMX_INT *pulseStart,
                            OMX_INT *pulseOff,
                            OMX_INT *pulseAmp,
                            OMX_U16 numSwb
                          )
{
    
    OMX_INT i,k;
    
    *numPulse   = (OMX_INT)armGetBits(ppBitStream,pOffset,2);
    *pulseStart = (OMX_INT)armGetBits(ppBitStream,pOffset,6);

    if (*pulseStart >= (OMX_INT)numSwb)
    {
        return OMX_StsErr;
    }

    k = pOffsetTable[*pulseStart];

    for(i = 0;i < (*numPulse + 1); i++)
    {
        pulseOff[i] = (OMX_INT)armGetBits(ppBitStream,pOffset,5);
        pulseAmp[i] = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
        
        k += pulseOff[i];
        
        armRetDataErrIf(k >= ARM_AAC_WIN_LONG , OMX_StsErr)

    }
    
    return OMX_StsNoErr;
}



static OMXVoid armACAAC_DecodeTNSData(
                            const OMX_U8 **ppBitStream,
                            OMX_INT *pOffset,
                            OMX_INT audioObjectType,
                            OMX_S8 *pDstTnsFiltCoef,
                            OMXAACChanInfo *pChanInfo
                        )
{
        
    OMX_INT *pTnsRegionLen,*pTnsFiltOrder,*pTnsDirection;
    OMX_INT TnsMaxOrder,numWin,numBits,nextVar,i,j;
    
    /* Local array declarations for TNS coefficients decode*/
    
    OMX_S8 signMask[] = { 0x2, 0x4, 0x8 };
    OMX_S8 negMask[]  = { ~0x3, ~0x7, ~0xf };
    OMX_S8 coeff,nMask,sMask;

    OMXAACIcsInfo *pIcsInfo = pChanInfo->pIcsInfo;
   
    if(audioObjectType == 3)
    {
        /*Scaleable Sampling Rate profile*/
        TnsMaxOrder = 12;
    }
    else
    {
        if(pIcsInfo->winSequence == ARM_AAC_EIGHT_SHORT_SEQUENCE)
        {
            /*Short Window*/
            TnsMaxOrder = 7;
        }
        else
        {
            /*Long Window*/
            if(pChanInfo->samplingRateIndex >= 5)
            {
                /*Sampling rate at and below 32 Khz*/
                TnsMaxOrder = 20;
            }
            else
            {
                TnsMaxOrder = 12;
            }
        
        }
    }

    pTnsRegionLen = pChanInfo->pTnsRegionLen;
    pTnsFiltOrder = pChanInfo->pTnsFiltOrder;
    pTnsDirection = pChanInfo->pTnsDirection;
    
    for(numWin = 0;numWin < pChanInfo->numWin; numWin++)
    {
        if(pIcsInfo->winSequence == ARM_AAC_EIGHT_SHORT_SEQUENCE) 
        {
            pChanInfo->pTnsNumFilt[numWin] = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
        }
        else
        {
            pChanInfo->pTnsNumFilt[numWin] = (OMX_INT)armGetBits(ppBitStream,pOffset,2);
        }
        
        if(pChanInfo->pTnsNumFilt[numWin] > 0)
        {
            pChanInfo->pTnsFiltCoefRes[numWin] = ( (OMX_INT)armGetBits(ppBitStream,pOffset,1) + 3);
        }

        for(i = 0; i< pChanInfo->pTnsNumFilt[numWin] ; i++ )
        {
            if(pIcsInfo->winSequence == ARM_AAC_EIGHT_SHORT_SEQUENCE) 
            {
                pTnsRegionLen[numWin + i] = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
                pTnsFiltOrder[numWin + i] = (OMX_INT)armGetBits(ppBitStream,pOffset,3);
            }
            else
            {
                pTnsRegionLen[numWin + i] = (OMX_INT)armGetBits(ppBitStream,pOffset,6);
                pTnsFiltOrder[numWin + i] = (OMX_INT)armGetBits(ppBitStream,pOffset,5);
            }
        
            if(pTnsFiltOrder[numWin + i] > TnsMaxOrder)
            {
                pTnsFiltOrder[numWin + i] = TnsMaxOrder;
            }
            
            if(pTnsFiltOrder[numWin + i] > 0)
            {
                pTnsDirection[numWin + i] = (OMX_INT)armGetBits(ppBitStream,pOffset,1);
                
                nextVar        = (OMX_INT)armGetBits(ppBitStream,pOffset,1); 
                numBits        = pChanInfo->pTnsFiltCoefRes[numWin] - nextVar;
                
                /* Conversion to signed integer */
                
                sMask = signMask[ numBits - 2 ]; 
                nMask = negMask[ numBits - 2 ]; 

                for(j = 0; j < pTnsFiltOrder[numWin + i] ; j++ )
                {
                    coeff = (OMX_S8)armGetBits(ppBitStream,pOffset,numBits);
                    
                    if( (coeff & sMask) == 0)
                    {
                        *pDstTnsFiltCoef = coeff;
                    }
                    else
                    {
                        /*Sign extension*/
                        *pDstTnsFiltCoef = ( coeff | nMask );
                    }

                    pDstTnsFiltCoef++;
                }
            }
        }
    }
    
    return;
}


/*End Of File*/
