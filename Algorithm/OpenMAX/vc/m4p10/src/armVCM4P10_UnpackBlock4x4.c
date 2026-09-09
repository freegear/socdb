/* ----------------------------------------------------------------
 *
 *  armVCM4P10_UnpackBlock4x4.c
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
 * H.264 inverse quantize and transform helper module
 * 
 */
 
#include "omxtypes.h"
#include "omxVC.h"
#include "armVC.h"

/*
 * Description
 * Unpack a 4x4 block of coefficient-residual pair values
 *
 * Parameters:
 * [in]	ppSrc	Double pointer to residual coefficient-position pair
 *						buffer output by CALVC decoding
 * [out]	ppSrc	*ppSrc is updated to the start of next non empty block
 * [out]	pDst	Pointer to unpacked 4x4 block
 */

void armVCM4P10_UnpackBlock4x4(
     const OMX_U8 **ppSrc,
     OMX_S16* pDst
)
{
    const OMX_U8 *pSrc = *ppSrc;
    int i;
    int Flag, Value;

    for (i=0; i<16; i++)
    {
        pDst[i] = 0;
    }

    do
    {
        Flag  = *pSrc++;
        if (Flag & 0x10)
        {
            /* 16 bit */
            Value = *pSrc++;
            Value = Value | ((*pSrc++)<<8);
            if (Value & 0x8000)
            {
                Value -= 0x10000;
            }
        }
        else
        {
            /* 8 bit */
            Value = *pSrc++;
            if (Value & 0x80)
            {
                Value -= 0x100;
            }
        }
        i = Flag & 15;
        pDst[i] = (OMX_S16)Value;
    }
    while ((Flag & 0x20)==0);

    *ppSrc = pSrc;
}

/* End of file */
