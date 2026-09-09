/**
 *  omxACAAC_MDCTFwd_S32.c
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
 * This file contains module for MDCT for an AAC decoder
 *
 */

#include<math.h>
 
#include "omxtypes.h" 
#include "omxAC.h"

#include "armAC.h"
#include "armCOMM.h"

#include "armACAAC_Tables.h"

/**
 * Function: omxACAAC_MDCTFwd_S32
 *
 * Description:
 * MDCT forward process,used only in LTP(Long Term Prediction) object type.
 * Reference to ISO/IEC 14496-3 Sect 6.6
 * Remarks:
 * In the Long Term Prediction (LTP) loop, MDCT is needed to generate spectrum coefficient of
 * PCM samples.
 *
 *
 * Parameters:
 * [in]  pSrc              pointer to temporal signals to do MDCT;
 *												 represented in Q13.18 format.							 
 * [in]  pOverlapAdd      pointer to overlap buffer. Not used in AAC decode
 *												 represented in Q13.18 format.
 * [in]  winSequence       window sequence shows  that this block is long or short block
 * [in]  winShape          window shape shows current window's shape
 * [in]  preWinShape       window shape shows previous window's shape
 * [in]  pWindowedBuf      work buffer for MDCT, length of pWindowedBuf is at least 2048 words
 * [out] pDst              output of MDCT, the spectral coefficients of PCM samples
 *												 represented in Q13.18 format.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
 
OMXResult omxACAAC_MDCTFwd_S32(
     OMX_S32 *pSrc,
     OMX_S32 *pDst,
     OMX_INT winSequence,
     OMX_INT winShape,
     OMX_INT preWinShape,
     OMX_S32 *pWindowedBuf
 )
 
{
    const OMX_F64 *pLeftWinShortPrev = NULL,*pLeftWinLongPrev = NULL;
    const OMX_F64 *pRightWinShort = NULL,*pRightWinLong = NULL; /*To avoid warnings*/
    
    OMX_F64 buffer[ARM_AAC_WIN_LONG << 1],PiByN,outCoeff0;
    OMX_F64 theta,output,coeff,alpha,cosine;
    
    OMX_INT inCoeff,outCoeff;
    
    /* Argument Check */

    armRetArgErrIf( pSrc         == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pDst         == NULL, OMX_StsBadArgErr);
    armRetArgErrIf( pWindowedBuf == NULL, OMX_StsBadArgErr);

    armRetArgErrIf( (winSequence > 3) || (winSequence < 0), OMX_StsBadArgErr);
    armRetArgErrIf(  winSequence == 2                     , OMX_StsBadArgErr);
    armRetArgErrIf( (winShape > 1)    || (winShape < 0)   , OMX_StsBadArgErr);
    armRetArgErrIf( (preWinShape > 1) || (preWinShape < 0), OMX_StsBadArgErr);

    /* Processing */
    
    /*Windowing pointer assignments*/

    switch(preWinShape)
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

            break;
            
        case 1:
            /*KBD window*/
            pRightWinShort = armACAAC_winShortKBD + ARM_AAC_WIN_SHORT - 1;
            pRightWinLong  = armACAAC_winLongKBD  + ARM_AAC_WIN_LONG - 1;

            break;        
    }

    
      /*Windowing*/

    switch(winSequence)
    {
        case ARM_AAC_ONLY_LONG_SEQUENCE:

            for(inCoeff = 0; inCoeff < ARM_AAC_WIN_LONG ; inCoeff ++)
            {   
                /*Left Half*/
                coeff = pSrc[inCoeff] / (OMX_F64)(1 << ARM_AAC_Q_FACTOR) ;
                coeff = coeff * pLeftWinLongPrev[inCoeff] ;

                buffer[inCoeff] = coeff;

                /*Right Half*/
                coeff = pSrc[inCoeff + ARM_AAC_WIN_LONG] / (OMX_F64)(1 << ARM_AAC_Q_FACTOR) ;
                coeff = coeff * pRightWinLong [-inCoeff]    ;
                
                buffer[inCoeff + ARM_AAC_WIN_LONG] = coeff;
            }

        break;
            
        case ARM_AAC_LONG_START_SEQUENCE:

            for(inCoeff = 0 ; inCoeff < ARM_AAC_WIN_LONG ; inCoeff ++)
            {
                coeff = pSrc[inCoeff] / (OMX_F64)(1 << ARM_AAC_Q_FACTOR) ;
                coeff = pLeftWinLongPrev[inCoeff] * coeff;

                buffer[inCoeff] = coeff;
            }

            for(inCoeff = ARM_AAC_WIN_LONG ; inCoeff < 1472 ; inCoeff ++)
            {
                buffer[inCoeff] = pSrc[inCoeff] / (OMX_F64)(1 << ARM_AAC_Q_FACTOR) ;
            }

            for(inCoeff = 1472 ; inCoeff < 1600 ; inCoeff ++)
            {
                coeff = pSrc[inCoeff] / (OMX_F64)(1 << ARM_AAC_Q_FACTOR) ;
                coeff = pRightWinShort[1472 - inCoeff] * coeff;

                buffer[inCoeff] = coeff;
                
            }
            
            for(inCoeff = 1600 ; inCoeff < (ARM_AAC_WIN_LONG << 1 ) ; inCoeff ++)
            {
                buffer[inCoeff] = 0;
            }

        break;
        
        case ARM_AAC_LONG_STOP_SEQUENCE:
            
            for(inCoeff = 0 ; inCoeff < 448 ; inCoeff ++)
            {
                buffer[inCoeff] = 0;
            }

            for(inCoeff = 448 ; inCoeff < 576 ; inCoeff ++)
            {
                coeff = pSrc[inCoeff] / (OMX_F64)(1 << ARM_AAC_Q_FACTOR) ;
                coeff = pLeftWinShortPrev[inCoeff - 448] * coeff;

                buffer[inCoeff] = coeff;
            }
            
            for(inCoeff = 576 ; inCoeff < ARM_AAC_WIN_LONG ; inCoeff ++)
            {
                buffer[inCoeff] = pSrc[inCoeff] / (OMX_F64)(1 << ARM_AAC_Q_FACTOR) ;
            }
            
            for(inCoeff = ARM_AAC_WIN_LONG ; inCoeff < (ARM_AAC_WIN_LONG << 1) ; inCoeff ++)
            {
                coeff = pSrc[inCoeff] / (OMX_F64)(1 << ARM_AAC_Q_FACTOR) ;
                coeff = pRightWinLong[ARM_AAC_WIN_LONG - inCoeff] * coeff;
                
                buffer[inCoeff] = coeff;
            }
            
        break;

    }

      /*Long MDCT*/
    outCoeff0 = 512.5;
    PiByN     = armPI/(ARM_AAC_WIN_LONG << 1);
        
    for(outCoeff = 0 ; outCoeff < ARM_AAC_WIN_LONG ; outCoeff ++) 
    {
        theta  = (2*PiByN)*( (OMX_F64)outCoeff + outCoeff0);
        output = 0;
        
        for(inCoeff = 0; inCoeff < ( ARM_AAC_WIN_LONG << 1 ) ; inCoeff ++)
        {
            alpha  = theta * ( (OMX_F64)inCoeff + .5);
            cosine = cos(alpha);

            coeff  = cosine * buffer[inCoeff];
            output = output + coeff;
        }
      
        pDst[outCoeff] = armSatRoundFloatToS32(2 * output * (1 << ARM_AAC_Q_FACTOR) );
    }

    return OMX_StsNoErr;
}
 
/*End of File*/
