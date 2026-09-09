/**
 *  armACMP3_Tables.h
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
 * File: armACMP3_Tables.h
 * Brief: Declares Tables used for MP3 Codec.
 *
 */

#ifndef _armMP3Tables_H_
#define _armMP3Tables_H_

#include "armCOMM.h" /* Get the OMX_F32 and OMX_F64 definitions */

#define PI          (3.1415926535897932384626433832795)

extern const OMX_S16 armACMP3_SFBTableLong [];
extern const OMX_S16 armACMP3_SFBTableShort [];
extern const OMX_S16 armACMP3_SFBTableMixed [];


    /* LinBits */
extern const OMX_INT armACMP3_LinBits [];
    /* Pretab */
extern const OMX_U32     armACMP3_Pretab [22];

    /* Huffman code and code lenth */
extern const ARM_VLC32 armACMP3_HuffTable1 [];
extern const ARM_VLC32 armACMP3_HuffTable2 [];
extern const ARM_VLC32 armACMP3_HuffTable3 [];
    /* ARM_VLC32 armACMP3_HuffTable4 */
extern const ARM_VLC32 armACMP3_HuffTable5 [];
extern const ARM_VLC32 armACMP3_HuffTable6 [];
extern const ARM_VLC32 armACMP3_HuffTable7 [];
extern const ARM_VLC32 armACMP3_HuffTable8 [];
extern const ARM_VLC32 armACMP3_HuffTable9 [];
extern const ARM_VLC32 armACMP3_HuffTable10 [];
extern const ARM_VLC32 armACMP3_HuffTable11 [];
extern const ARM_VLC32 armACMP3_HuffTable12 [];
extern const ARM_VLC32 armACMP3_HuffTable13 [];
    /* ARM_VLC32 armACMP3_HuffTable14 */
extern const ARM_VLC32 armACMP3_HuffTable15 [];
extern const ARM_VLC32 armACMP3_HuffTable16 [];
extern const ARM_VLC32 armACMP3_HuffTable24 [];
extern const ARM_VLC32 armACMP3_HuffTable32 [];
extern const ARM_VLC32 armACMP3_HuffTable33 [];
extern const ARM_VLC32* armACMP3_HuffCodeBook [];

extern const OMX_S16 armACMP3_TableXY0 [][2];
extern const OMX_S16 armACMP3_TableXY1 [][2];
extern const OMX_S16 armACMP3_TableXY2 [][2];
extern const OMX_S16 armACMP3_TableXY3 [][2];
extern const OMX_S16 armACMP3_TableXY4 [][2];
extern const OMX_S16 armACMP3_TableXY5 [][2];
extern const OMX_S16 armACMP3_TableXY6 [][2];
extern const OMX_S16 armACMP3_TableXY7 [][2];
extern const OMX_S16 armACMP3_TableXY8 [][2];
extern const OMX_S16 armACMP3_TableXY9 [][2];
extern const OMX_S16 armACMP3_TableXY10 [][2];
extern const OMX_S16 armACMP3_TableXY11 [][2];
extern const OMX_S16 armACMP3_TableXY12 [][2];
extern const OMX_S16 armACMP3_TableXY13 [][2];
extern const OMX_S16 armACMP3_TableXY14 [][2];
extern const OMX_S16 armACMP3_TableXY15 [][2];
extern const OMX_S16 armACMP3_TableXY16 [][2];
extern const OMX_S16 armACMP3_TableXY24 [][2];
extern const OMX_S16 armACMP3_TableXY32 [][2];
extern const OMX_S16 armACMP3_TableXY33 [][2];
extern const OMX_S16 (*armACMP3_HuffXYValues[]) [2];


extern const OMX_F64 armACMP3_BflyCoeffCS [];
extern const OMX_F64 armACMP3_BflyCoeffCA [];
extern const OMX_F64 armACMP3_LongWindow [];
extern const OMX_F64 armACMP3_ShortWindow [];

extern const OMX_F64 armACMP3_DWindow [];

#endif /* _armMP3Tables_H_ */
