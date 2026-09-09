/**
 *  armSP.h
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
 * File: armSP.h
 * Brief: Declares API's/Basic Data types used across the OpenMAX Signal Processing domain
 *
 */
#ifndef _armSP_H_
#define _armSP_H_

#include "omxtypes.h"

/** FFT Specific declarations */

#define OMX_ACSP_FFT_NULL   (0)
#define OMX_ACSP_MAX_FFT_ORDER  (12)
#define PI          (3.1415926535897932384626433832795)

typedef struct  ARMsFFTSpec_FC64_Tag 
{
    OMX_U32     N;
    OMX_U16     *pBitRev;    
    OMX_FC64    *pTwiddle;
    OMX_FC64     *pBuf;    
}ARMsFFTSpec_FC64;

typedef struct  ARMsFFTSpec_SC32_Tag 
{
    OMX_U32     N;
    OMX_U16     *pBitRev;    
    OMX_SC32    *pTwiddle;
}ARMsFFTSpec_SC32;

typedef struct  ARMsFFTSpec_SC16_Tag 
{
    OMX_U32     N;
    OMX_U16     *pBitRev;    
    OMX_SC16    *pTwiddle;
}ARMsFFTSpec_SC16;

typedef struct  ARMsFFTSpec_F32_Tag 
{
    OMX_U32     N;
    OMX_U16     *pBitRev;    
    OMX_FC32    *pTwiddle;
}ARMsFFTSpec_FC32;

typedef struct  ARMsFFTSpec_R_F32_Tag 
{
    OMX_U32     N;
    OMX_U16     *pBitRev;
    OMX_FC32    *pTwiddle;
    OMX_F32     *pBuf;    
}ARMsFFTSpec_R_FC32;
typedef struct  ARMsFFTSpec_R_F64_Tag 
{
    OMX_U32     N;
    OMX_U16     *pBitRev;
    OMX_FC64    *pTwiddle;
    OMX_F64     *pBuf;    
}ARMsFFTSpec_R_FC64;

#define CPLX_MUL(out, a, b)                                         \
{                                                                   \
    ((out)->Re) = (((a)->Re * (b)->Re) - ((a)->Im * (b)->Im));      \
    ((out)->Im) = (((a)->Re * (b)->Im) + ((a)->Im * (b)->Re));      \
}

#define CPLX_ADD(out, a, b)                                         \
{                                                                   \
    ((out)->Re) = (((a)->Re + (b)->Re));                            \
    ((out)->Im) = (((a)->Im + (b)->Im));                            \
}

#define CPLX_SUB(out, a, b)                                         \
{                                                                   \
    ((out)->Re) = (((a)->Re - (b)->Re));                            \
    ((out)->Im) = (((a)->Im - (b)->Im));                            \
}



#endif

/*End of File*/



