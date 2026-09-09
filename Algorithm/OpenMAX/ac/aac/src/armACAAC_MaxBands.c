/**
 *  armACAAC_MaxBands.c
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
 * Table describing TnsMaxBands, to be used in decoding TNS
**/


#include "omxtypes.h"

#include "armACAAC_Tables.h"

const OMX_U8 armACAAC_TnsMaxBands[12][4] =

 {
    {31,  9, 28,  7},	  
    {31,  9, 28,  7},	  
    {34, 10, 27,  7},	  
    {40, 14, 26,  6},	  
    {42, 14, 26,  6},	  
    {51, 14, 26,  6},	  
    {46, 14, 29,  7},	  
    {46, 14, 29,  7},	   
    {42, 14, 23,  8},	   
    {42, 14, 23,  8},	   
    {42, 14, 23,  8},	   
    {39, 14, 19,  7},	   
};

const OMX_U8 armACAAC_PredMaxBands[12] =
{
    33, 33, 38, 40, 40, 40, 41, 41,
    37, 37, 37, 34
};
/*End of File*/
