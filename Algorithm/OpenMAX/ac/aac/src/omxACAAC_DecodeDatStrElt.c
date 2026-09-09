/**
 *  omxACAAC_DecodeDatStrElt.c
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
 * This file contains module for parsing DSE information from AAC bitstream
 *
 */

#include "omxtypes.h" 
#include "omxAC.h"

#include "armCOMM.h"
#include "armCOMM_Bitstream.h"
 
/**
 * Function: omxACAAC_DecodeDatStrElt
 *
 * Description:
 * Gets data_stream_element from the input bit stream.
 * Reference to ISO/IEC 14496-3 table 4.4.10
 *
 * Remarks:
 * This function gets data_stream_element from the input bit stream.
 *
 *
 * Parameters:
 * [in]  ppBitStream        double pointer to the current byte
 * [in]  pOffset            pointer to the bit position in the byte pointed
 *                                by *ppBitStream. Valid within 0 to 7. 0: MSB of
 *                                the byte, 7: LSB of the byte.
 * [out]  ppBitStream       double pointer to the current byte
 * [out]  pOffset           pointer to the bit position in the byte pointed
 *                                by *ppBitStream. Valid within 0 to 7. 0: MSB of
 *                                the byte, 7: LSB of the byte.
 * [out]  pDataTag          pointer to element_instance_tag.
 * [out]  pDataCnt          pointer to the value of length of total data in bytes
 * [out]  pDstDataElt       pointer to the data stream buffer that contains
 *                                the data stream extracted from the input bit stream.
 *                                There are 512 elements in the buffer pointed by pDstDataElt.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
  
OMXResult omxACAAC_DecodeDatStrElt(
     const OMX_U8 **ppBitStream,
     OMX_INT *pOffset,
     OMX_INT *pDataTag,
     OMX_INT *pDataCnt,
     OMX_U8 *pDstDataElt
 )
{
    OMX_INT  nextData,count;
    OMX_INT  i;
    
    /* Argument Check */        
    armRetArgErrIf( ppBitStream  == NULL , OMX_StsBadArgErr);
    armRetArgErrIf(*ppBitStream  == NULL , OMX_StsBadArgErr);
    armRetArgErrIf( pOffset      == NULL , OMX_StsBadArgErr);
    armRetArgErrIf( pDataTag     == NULL , OMX_StsBadArgErr);
    armRetArgErrIf( pDataCnt     == NULL , OMX_StsBadArgErr);
    armRetArgErrIf( pDstDataElt  == NULL , OMX_StsBadArgErr);

    armRetArgErrIf( (*pOffset > 7) || (*pOffset < 0) , OMX_StsBadArgErr);

    /* Processing */
    *pDataTag   = (OMX_INT)armGetBits(ppBitStream,pOffset,4);/*element_instance_tag*/
    nextData    = (OMX_INT)armGetBits(ppBitStream,pOffset,1);/*data_byte_align_flag*/
    count       = (OMX_INT)armGetBits(ppBitStream,pOffset,8);/*cnt*/
    
    if(count == 255)
    {
        count  += (OMX_INT)armGetBits(ppBitStream,pOffset,8);/*esc_count*/
    }
    *pDataCnt = count;
    
    if(nextData == 1)
    {
        /*data_byte_align_flag*/
        armByteAlign(ppBitStream,pOffset);
    }
    
    for(i = 0; i < count ; i++)
    {
        pDstDataElt[i]   = (OMX_INT)armGetBits(ppBitStream,pOffset,8);/*data_stream_byte*/
    }
    
    return OMX_StsNoErr;
}

 /* End of File */
