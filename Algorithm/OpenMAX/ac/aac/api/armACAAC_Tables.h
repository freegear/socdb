/**
 *  armACAAC_Tables.h
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
 * File: armACAAC_Tables.h
 * Brief: Declares Tables used for OpenMAX AAC Decoder API's.
 *
 */

#ifndef _armAAC_Tables_H_
#define _armAAC_Tables_H_

#include "omxtypes.h"

#include "armCOMM.h"
#include "armCOMM_Bitstream.h"
#include "armAC.h"

    /* scaleFactor bands */
extern const OMX_U16  armACAAC_numSwbShort[];
extern const OMX_U16  armACAAC_numSwbLong[];
extern const OMX_U16 *armACAAC_swbOffsetShortWindow[];
extern const OMX_U16 *armACAAC_swbOffsetLongWindow[];

    /* TNS Bands */
extern const OMX_U8  armACAAC_TnsMaxBands[12][4];
extern const OMX_F64 armACAAC_SinLookUp[];

    /*Prediction Bands*/
extern const OMX_U8  armACAAC_PredMaxBands[];
    
    /* CodeBooks */
extern const ARM_VLC32 *armACAAC_CodeBooks[];
extern const OMX_U8     armACAAC_signCb[];
extern const OMX_U8     armACAAC_lavCb[];

    /*IMDCT Window*/
extern const OMX_F64 armACAAC_winShortKBD[];
extern const OMX_F64 armACAAC_winLongKBD[];

extern const OMX_F64 armACAAC_winShortSine[];
extern const OMX_F64 armACAAC_winLongSine[];

extern const OMX_F64 armACAAC_ltpTable[];

#endif

/*End of File*/

