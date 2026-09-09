/**
 *  armICJP_DCTQuantFwd_S16.c
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
 * This file contains module for FDCT with quantization
 *
 */

#include "omxtypes.h"
#include "omxIC.h"

#include "armIC.h"
#include "armCOMM.h"

/**
 * Function: armICJP_DCTQuantFwd_S16
 *
 * Brief:
 * One block FDCT with quantization function.
 *
 * Description:
 * This function implements forward DCT with (optional) quantization for the 8-bit image data (packed into signed 16-bit).
 * It processes one block (8x8).Output matrix is the transpose of the explicit result.
 * As a result, the Huffman coding functions in this library handle transpose as well.
 *
 *
 * Parameters:
 * [in]  pSrc           identifies input coefficient block(8x8) buffer. This start address must be 8-byte
 *                            aligned. The input components are bounded on the interval [-128, 127].
 * [in]  pQuantFwdTable identifies the quantization table which was generated from
 *                            "DCTQuantFwdTableInit_JPEG_U8_U16". The table length is 64 entries. This start address must be
 *                            8-byte aligned. If this pointer is NULL then quantization is not performed
 
 * [out] pDst           identifies output coefficient block(8x8) buffer. This start address must be 8-byte aligned.
 *                            To achieve better performance, the output 8x8 matrix is the transpose of the explicit result. This
 *                            transpose will be handled in Huffman encoding.
 *
 * Return Value:
 * OMXVoid
 *
 */

OMXVoid armICJP_DCTQuantFwd_S16(
     const OMX_S16* pSrc,
     OMX_S16 *pDst,
     const OMX_U32 *pQuantFwdTable
 )
{
    OMX_INT v,u,y,x,quantFlag;
    OMX_F64 coeff,mac,quant;
    
    if( pQuantFwdTable == NULL )
    {
        quantFlag = 0;
    }
    else
    {
        quantFlag = 1;
    }
    
    /* Processing */
    for( v = 0 ; v < 8 ; v++)
    {
        for( u = 0 ; u < 8 ; u++)
        {
            /* Compute the FDCT coefficient */
            mac = 0.0;
            
            for( y = 0 ; y < 8 ; y++)
            {
                for( x = 0 ; x < 8 ; x++)
                {
                    coeff  = (OMX_F64)pSrc[y*8 + x];
                    coeff *= (armICJP_CosTable[x][u] *
                                armICJP_CosTable[y][v]);
                    
                    mac  += coeff;
                }
            }
            
            /* Quantization */
            if(quantFlag == 1)
            {
                quant = pQuantFwdTable[v*8 + u] / (OMX_F64)(1 << ARM_ICJP_QUANT_Q);
                mac  *= quant;
            }
            
            /* Transposed output */
            pDst[u*8 + v] = armSatRoundFloatToS16(mac);
        }
    }

}

/* End of File */
