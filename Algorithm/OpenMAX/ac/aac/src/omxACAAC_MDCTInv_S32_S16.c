/**
 *  omxACAAC_MDCTInv_S32_S16.c
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
 * This file contains module for IMDCT for an AAC decoder
 *
 */

#include <math.h>
 
#include "omxtypes.h" 
#include "omxAC.h"

#include "armAC.h"
#include "armCOMM.h"

#include "armACAAC_Tables.h"

/**
 * Function: omxACAAC_MDCTInv_S32_S16
 *
 * Description:
 * IMDCT process
 * Reference to ISO/IEC 14496-3 Sect 6.10
 *
 * Remarks:
 * This module is used to map the time-frequency domain signal into time domain
 * and generate 1024 reconstructed 16-bit signed little-endian PCM samples as
 * output for each channel.
 *
 *
 * Parameters:
 * [in]  pSrcSpectralCoefs pointer to the input time-frequency domain
 *                               samples in Q13.18 format. There are 1024 elements
 *                               in the buffer pointed by pSrcSpectralCoefs.
 * [in]  pSrcDstOverlapAddBuf pointer to the overlap-add buffer which contains
 *                                  the second half of the previous block windowed sequence
 *               					in Q13.18. There are 1024 elements in this buffer.
 * [in]  winSequence          flag that indicates which window sequence is used for current block
 * [in]  winShape             flag that indicates which window function is selected for current block
 * [in]  prevWinShape         flag that indicates which window function is selected for previous block
 * [in]  pcmMode              flag that indicates whether the PCM audio output is interleaved
 *                                  (LRLRLR? or not. 1 = not interleaved;2 = interleaved
 * [out] pDstPcmAudioOut      Pointer to the output 1024 reconstructed 16-bit signed little-endian PCM
 *                                  samples represented in Q16.15format, interleaved if needed.
 * [out] pSrcDstOverlapAddBuf pointer to the overlap-add buffer which contains the second half
 *                                  of the current block windowed sequence in Q13.18.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */


OMXResult omxACAAC_MDCTInv_S32_S16(
     OMX_S32 *pSrcSpectralCoefs,
     OMX_S16 *pDstPcmAudioOut,
     OMX_S32 *pSrcDstOverlapAddBuf,
     OMX_INT winSequence,
     OMX_INT winShape,
     OMX_INT prevWinShape,
     OMX_INT pcmMode
 )
{
    const OMX_F64 *pLeftWinShortPrev = NULL,*pLeftWinShort = NULL,*pLeftWinLongPrev = NULL;
    const OMX_F64 *pRightWinShort = NULL,*pRightWinLong = NULL; /*To avoid warnings*/
    
    OMX_F64       *pDstCoeff,*pBuffer;
    OMX_F64        dstCoeff[ARM_AAC_WIN_LONG << 1],buffer[ARM_AAC_WIN_SHORT];
    
    OMX_F64        theta,PiByN,alpha,coeff;
    OMX_F64        output,cosine,outCoeff0;

    OMX_INT        outCoeff,inCoeff,winNum;
    
    
    /* Argument Check */        
    armRetArgErrIf( pSrcSpectralCoefs    == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pDstPcmAudioOut      == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pSrcDstOverlapAddBuf == NULL, OMX_StsBadArgErr);

    armRetArgErrIf( (winSequence > 3)  || (winSequence < 0) , OMX_StsBadArgErr);
    armRetArgErrIf( (winShape > 1)     || (winShape < 0)    , OMX_StsBadArgErr);
    armRetArgErrIf( (prevWinShape > 1) || (prevWinShape < 0), OMX_StsBadArgErr);
    armRetArgErrIf( (pcmMode > 2)      || (pcmMode < 1)     , OMX_StsBadArgErr);

    /* Processing */
    
    /*Windowing pointer assignments*/
    
    switch(prevWinShape)
    {
        case 0:
            /*sine window*/
            pLeftWinShortPrev = armACAAC_winShortSine;
            pLeftWinLongPrev  = armACAAC_winLongSine;
            
            break;
            
        case 1:
            /*KBD window*/
            pLeftWinShortPrev = armACAAC_winShortKBD;
            pLeftWinLongPrev  = armACAAC_winLongKBD;
            
            break;        
    }
    
    switch(winShape)
    {
        case 0:
            
            /*sine window*/
            pRightWinShort = armACAAC_winShortSine + ARM_AAC_WIN_SHORT - 1;
            pRightWinLong  = armACAAC_winLongSine  + ARM_AAC_WIN_LONG - 1;
            
            pLeftWinShort  = armACAAC_winShortSine;
            
            break;
            
        case 1:
            /*KBD window*/
            pRightWinShort = armACAAC_winShortKBD + ARM_AAC_WIN_SHORT - 1;
            pRightWinLong  = armACAAC_winLongKBD  + ARM_AAC_WIN_LONG - 1;
            
            pLeftWinShort  = armACAAC_winShortKBD;

            break;        
    }
    
    
    /*IMDCT*/

    pDstCoeff = dstCoeff;
    pBuffer   = buffer;

    if(winSequence == ARM_AAC_EIGHT_SHORT_SEQUENCE)
    {
        /*Short IMDCT*/
        
        outCoeff0 = 64.5;
        PiByN     = armPI/(ARM_AAC_WIN_SHORT << 1);
        
        /*Adding the Inital zeros to buffer*/
        
        for(outCoeff = 0; outCoeff < 448 ; outCoeff++)
        {
            *pDstCoeff++ = 0;
        }

        for(winNum = 0; winNum < OMX_AAC_WIN_MAX ; winNum++)
        {
            for(outCoeff = 0 ; outCoeff < (ARM_AAC_WIN_SHORT << 1) ; outCoeff ++) 
            {
                theta  = (2*PiByN)*( (OMX_F64)outCoeff + outCoeff0);
                output = 0;
                
                for(inCoeff = 0; inCoeff < ARM_AAC_WIN_SHORT ; inCoeff ++)
                {
                    alpha  = theta * ( (OMX_F64)inCoeff + .5);
                    cosine = cos(alpha);
                    coeff  = pSrcSpectralCoefs[inCoeff]/ (OMX_F64)(1 << ARM_AAC_Q_FACTOR);
                    
                    coeff  = cosine * coeff;
                    output = output + coeff;
                }

                output = (output/ARM_AAC_WIN_SHORT);
                
                /*Windowing operation */             
                
                if(outCoeff < ARM_AAC_WIN_SHORT)
                {
                    /* First Half */
                    
                    /*Window and store in the buffer*/

                    if(winNum == 0)
                    {
                        output = pLeftWinShortPrev[outCoeff] * output;
                    }
                    else
                    {
                        output = pLeftWinShort[outCoeff] * output;
                        output = pBuffer[outCoeff] + output;    
                    }
                    
                    *pDstCoeff++ = output;
                }
                else
                {
                    /*Second Half*/
                    output =  pRightWinShort[ARM_AAC_WIN_SHORT - outCoeff] * output;
                    pBuffer[outCoeff - ARM_AAC_WIN_SHORT] = output;
                }
            }
            
            pSrcSpectralCoefs += ARM_AAC_WIN_SHORT;
        }
        
        for(outCoeff = 0 ; outCoeff < ARM_AAC_WIN_SHORT ; outCoeff++)
        {
            *pDstCoeff++ = pBuffer[outCoeff];
        }
        
        /*Adding the terminating zeros to the buffer*/
        
        for(outCoeff = 0; outCoeff < 448 ; outCoeff++)
        {
            *pDstCoeff++ = 0;
        }

    }
    else
    {
        /*Long IMDCT*/
        outCoeff0 = 512.5;
        PiByN     = armPI/(ARM_AAC_WIN_LONG << 1);
        
        for(outCoeff = 0 ; outCoeff < (ARM_AAC_WIN_LONG << 1) ; outCoeff ++) 
        {
            theta  = (2*PiByN)*( (OMX_F64)outCoeff + outCoeff0);
            output = 0;
            
            for(inCoeff = 0; inCoeff < ARM_AAC_WIN_LONG ; inCoeff ++)
            {
                alpha  = theta * ( (OMX_F64)inCoeff + .5);
                cosine = cos(alpha);
                coeff  = pSrcSpectralCoefs[inCoeff]/ (OMX_F64)(1 << ARM_AAC_Q_FACTOR);
                
                coeff  = cosine * coeff;
                output = output + coeff;
            }

            pDstCoeff[outCoeff] = (output/ARM_AAC_WIN_LONG);
        }
    
    }
    
    pDstCoeff = dstCoeff;
    
    /*Windowing*/
    switch(winSequence)
    {
        case ARM_AAC_ONLY_LONG_SEQUENCE:

            for(outCoeff = 0 ; outCoeff < ARM_AAC_WIN_LONG ; outCoeff ++)
            {
                /*Left Half*/
                output  = pLeftWinLongPrev[outCoeff] * pDstCoeff[outCoeff] ;
                pDstCoeff[outCoeff] = output;
            
                /*Right Half*/
                output  = pRightWinLong[-outCoeff] * pDstCoeff[outCoeff + ARM_AAC_WIN_LONG] ;
                pDstCoeff[outCoeff + ARM_AAC_WIN_LONG] = output;
                
            }
            
            break;
            
        case ARM_AAC_LONG_STOP_SEQUENCE:
            
            for(outCoeff = 0 ; outCoeff < 448 ; outCoeff ++)
            {
                pDstCoeff[outCoeff] = 0;
            }

            for(outCoeff = 448 ; outCoeff < 576 ; outCoeff ++)
            {
                output  = pLeftWinShortPrev[outCoeff - 448] * pDstCoeff[outCoeff];

                pDstCoeff[outCoeff] = output;
            }
            
            for(outCoeff = ARM_AAC_WIN_LONG ; outCoeff < (ARM_AAC_WIN_LONG << 1) ; outCoeff ++)
            {
                output  = pRightWinLong[ARM_AAC_WIN_LONG - outCoeff] * pDstCoeff[outCoeff];
                
                pDstCoeff[outCoeff] = output;
            }
            
            break;

        case ARM_AAC_LONG_START_SEQUENCE:

            for(outCoeff = 0 ; outCoeff < ARM_AAC_WIN_LONG ; outCoeff ++)
            {
                output  = pLeftWinLongPrev[outCoeff] * pDstCoeff[outCoeff];

                pDstCoeff[outCoeff] = output;
            }

            for(outCoeff = 1472 ; outCoeff < 1600 ; outCoeff ++)
            {
                output  = pRightWinShort[1472 - outCoeff] * pDstCoeff[outCoeff];

                pDstCoeff[outCoeff] = output;
            }
            
            for(outCoeff = 1600 ; outCoeff < (ARM_AAC_WIN_LONG << 1 ) ; outCoeff ++)
            {
                pDstCoeff[outCoeff] = 0;
            }

            break;
        
        case ARM_AAC_EIGHT_SHORT_SEQUENCE:
    
                /*Windowing already done*/
                break;

    }
    
    
    /*Overlap and Add*/
    for(outCoeff = 0 ;outCoeff < ARM_AAC_WIN_LONG ; outCoeff++)
    {
        output                         = pDstCoeff[outCoeff] + pSrcDstOverlapAddBuf[outCoeff]/ (OMX_F64)(1 << ARM_AAC_Q_FACTOR);
        pSrcDstOverlapAddBuf[outCoeff] = armSatRoundFloatToS32( (pDstCoeff[outCoeff + ARM_AAC_WIN_LONG]) * (1 << ARM_AAC_Q_FACTOR) );
        
        /*Rounding*/
        pDstPcmAudioOut[pcmMode * outCoeff] = (OMX_S16)armSatRoundFloatToS16(output * (1 << 15));
    }
    
    
    return OMX_StsNoErr;
}


/*End of File*/
