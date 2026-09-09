 /**
 *  armVCM4P2_DCT_Table.c
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
 * File:        armVCM4P2_DCT_Table.c
 * Description: Contains the DCT/IDCT coefficent matrix
 *
 */

#ifndef _OMXDCTCOSTAB_C_
#define _OMXDCTCOSTAB_C_

#include "omxtypes.h"

const OMX_F64 armVCM4P2_preCalcDCTCos[8][8] =
{
        {
                0.353553390593273730, 
                0.490392640201615220, 
                0.461939766255643370, 
                0.415734806151272620, 
                0.353553390593273790, 
                0.277785116509801140, 
                0.191341716182544920, 
                0.097545161008064152 
        },
        {
                0.353553390593273730, 
                0.415734806151272620, 
                0.191341716182544920, 
                -0.097545161008064096, 
                -0.353553390593273730, 
                -0.490392640201615220, 
                -0.461939766255643420, 
                -0.277785116509801090
        },
        {
                0.353553390593273730, 
                0.277785116509801140, 
                -0.191341716182544860, 
                -0.490392640201615220, 
                -0.353553390593273840, 
                0.097545161008064138, 
                0.461939766255643260, 
                0.415734806151272730 
        },
        {
                0.353553390593273730, 
                0.097545161008064152, 
                -0.461939766255643370, 
                -0.277785116509801090, 
                0.353553390593273680, 
                0.415734806151272730, 
                -0.191341716182544920, 
                -0.490392640201615330
        },
        {
                0.353553390593273730, 
                -0.097545161008064096, 
                -0.461939766255643420, 
                0.277785116509800920, 
                0.353553390593273840, 
                -0.415734806151272620, 
                -0.191341716182545280, 
                0.490392640201615220 
        },
        {
                0.353553390593273730, 
                -0.277785116509800980, 
                -0.191341716182545170, 
                0.490392640201615220, 
                -0.353553390593273340, 
                -0.097545161008064013, 
                0.461939766255643370, 
                -0.415734806151272510
        },
        {
                0.353553390593273730, 
                -0.415734806151272670, 
                0.191341716182545000, 
                0.097545161008064388, 
                -0.353553390593273620, 
                0.490392640201615330, 
                -0.461939766255643200, 
                0.277785116509800760 
        },
        {
                0.353553390593273730, 
                -0.490392640201615220, 
                0.461939766255643260, 
                -0.415734806151272620, 
                0.353553390593273290, 
                -0.277785116509800760, 
                0.191341716182544780, 
                -0.097545161008064277
        }
};

#endif /*_OMXDCTCOSTAB_C_*/


/* End of file */


