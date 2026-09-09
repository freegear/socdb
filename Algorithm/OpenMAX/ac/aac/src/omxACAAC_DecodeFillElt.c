/**
 *  omxACAAC_DecodeFillElt.c
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
 * This file contains module for parsing FILL Element information from AAC bitstream
 *
 */
 
#include "omxtypes.h"
#include "omxAC.h"

#include "armCOMM.h"
#include "armCOMM_Bitstream.h"

/**
 * Function: omxACAAC_DecodeFillElt
 *
 * Description:
 * Gets the fill element.
 * Reference to ISO/IEC 14496-3 table 4.4.11
 *
 * Remarks:
 * Gets the fill element from the input bit stream.
 *
 *
 * Parameters:
 * [in]  ppBitStream        pointer to the pointer to the current byte
 * [in]  pOffset            pointer to the bit position in the byte pointed
 *                                by *ppBitStream. Valid within 0 to 7. 0: MSB of
 *                                the byte, 7: LSB of the byte.
 * [out] ppBitStream        pointer to the pointer to the current byte
 * [in]  pOffset            pointer to the bit position in the byte pointed
 *                                by *ppBitStream. Valid within 0 to 7. 0: MSB of
 *                                the byte, 7: LSB of the byte.
 * [out] pFillCnt           pointer to the value of the length of total fill
 *                                data in bytes
 * [out] pDstFillElt        pointer to the fill data buffer whose length must
 *                                be equal to or greater than 270
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxACAAC_DecodeFillElt(
     const OMX_U8 **ppBitStream,
     OMX_INT *pOffset,
     OMX_INT *pFillCnt,
     OMX_U8 *pDstFillElt
 )
{
    OMX_INT FillCnt,extType;
    OMX_INT nDyn,nExc,drcNumBands;
    OMX_INT TempVar,i;
    
    /* Argument Check */        
    armRetArgErrIf( ppBitStream  == NULL , OMX_StsBadArgErr);
    armRetArgErrIf(*ppBitStream  == NULL , OMX_StsBadArgErr);
    armRetArgErrIf( pOffset      == NULL , OMX_StsBadArgErr);
    armRetArgErrIf( pFillCnt     == NULL , OMX_StsBadArgErr);
    armRetArgErrIf( pDstFillElt  == NULL , OMX_StsBadArgErr);

    armRetArgErrIf( (*pOffset > 7) || (*pOffset < 0) , OMX_StsBadArgErr);

    FillCnt = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
    
    if(FillCnt == 15)
    {
        FillCnt += ( (OMX_INT)armGetBits(ppBitStream,pOffset,8) - 1 );
    }
    
    *pFillCnt = FillCnt;
    
    while(FillCnt > 0)
    {
        /*Extension Payload */
         extType = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
         
         switch(extType)
         {
            
            case 11: /* 0b1011 */
                /* EXT_DYNAMIC_RANGE */
            
                /* Dynamic Range info */
                nDyn = 1;
                drcNumBands = 1;
                
                TempVar = (OMX_INT)armGetBits(ppBitStream,pOffset,1);/*pce_tag_present*/
                
                if(TempVar == 1)
                {
                    armSkipBits(ppBitStream,pOffset,8);
                    nDyn++;
                }
                
                TempVar = (OMX_INT)armGetBits(ppBitStream,pOffset,1);/*excluded_chns_present*/
                
                if (TempVar == 1)
                {
                    
                    /* Excluded_channels */
                    
                    nExc = 1;
                    armSkipBits(ppBitStream,pOffset,7);/*exclude_mask*/
                    
                    TempVar = (OMX_INT)armGetBits(ppBitStream,pOffset,1);/* additional_excluded_chns */
                    
                    while(TempVar == 1)
                    {
                        armSkipBits(ppBitStream,pOffset,7);/*exclude_mask*/
                        
                        nExc++;
                        
                        TempVar = (OMX_INT)armGetBits(ppBitStream,pOffset,1);/* additional_excluded_chns */
                    }
                    
                    nDyn = nDyn + nExc;
                }
                
                TempVar = (OMX_INT)armGetBits(ppBitStream,pOffset,1);/* drc_bands_present */
                
                if(TempVar == 1)
                {
                    TempVar = (OMX_INT)armGetBits(ppBitStream,pOffset,4);/* drc_band_incr */                

                    armSkipBits(ppBitStream,pOffset,4);/*drc_bands_reserved_bits*/

                    drcNumBands += TempVar;
                    nDyn        += drcNumBands + 1;

                    TempVar = ( drcNumBands << 3);
                    armSkipBits(ppBitStream,pOffset,TempVar);
                    
                }
                
                TempVar = (OMX_INT)armGetBits(ppBitStream,pOffset,1);/* prog_level_present */
                
                if(TempVar == 1)
                {
                    armSkipBits(ppBitStream,pOffset,8);
                    nDyn++;
                }
                
                TempVar = (drcNumBands << 3);
                armSkipBits(ppBitStream,pOffset,TempVar);
                
                nDyn += drcNumBands;
                
                FillCnt -= nDyn;
                break;

            case 1: /* 0b0001: */
                /* EXT_FILL_DATA */
                
                TempVar = (OMX_INT)armGetBits(ppBitStream,pOffset,4);/*fill_nibble*/
                
                TempVar = ( (extType << 4) | TempVar );
                pDstFillElt[0] = TempVar ;
                
                for (i = 0 ; i < (FillCnt - 1) ; i++)
                {
                    pDstFillElt[i+1] = (OMX_U8)armGetBits(ppBitStream,pOffset,8);
                }
                
                FillCnt -= FillCnt;
                break;
                
            default:
                
                TempVar = (OMX_INT)armGetBits(ppBitStream,pOffset,4);
                
                TempVar = (extType << 4) | TempVar;
                pDstFillElt[0] = TempVar ;
                
                for (i = 0 ; i < (FillCnt - 1) ; i++)
                {
                    pDstFillElt[i+1] = (OMX_U8)armGetBits(ppBitStream,pOffset,8);
                }
                
                FillCnt -= FillCnt;
                
                break;

         } /*End switch - case*/
    
    }/*End while()*/
    
    return OMX_StsNoErr;
}
/* End of File */
