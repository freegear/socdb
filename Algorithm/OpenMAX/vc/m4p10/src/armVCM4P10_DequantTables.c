/* ----------------------------------------------------------------
 *
 *  armVCM4P10_DequantTables.c
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
 * H.264 inverse quantize tables
 * 
 */
 
#include "omxtypes.h"
#include "omxVC.h"
#include "armVC.h"


const OMX_U8 armVCM4P10_PosToVCol4x4[16] = 
{
    0, 2, 0, 2,
    2, 1, 2, 1,
    0, 2, 0, 2,
    2, 1, 2, 1
};

const OMX_U8 armVCM4P10_PosToVCol2x2[4] = 
{
    0, 2,
    2, 1
};

const OMX_U8 armVCM4P10_VMatrix[6][3] =
{
    { 10, 16, 13 },
    { 11, 18, 14 },
    { 13, 20, 16 },
    { 14, 23, 18 },
    { 16, 25, 20 },
    { 18, 29, 23 }
};
