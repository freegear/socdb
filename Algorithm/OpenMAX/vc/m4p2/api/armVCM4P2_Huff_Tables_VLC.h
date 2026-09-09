/**
 *  armVCM4P2_Huff_Tables_VLC.h
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
 *
 * File:        armVCM4P2_Huff_Tables.h
 * Description: Declares Tables used for Hufffman coding and decoding 
 *              in MP4P2 codec.
 *
 */
 
#ifndef _OMXHUFFTAB_H_
#define _OMXHUFFTAB_H_

extern const OMX_U8 armVCM4P2_IntraL0RunIdx[11];
extern const ARM_VLC32 armVCM4P2_IntraVlcL0[103];
extern const OMX_U8 armVCM4P2_IntraL1RunIdx[7];
extern const ARM_VLC32 armVCM4P2_IntraVlcL1[36];
extern const OMX_U8 armVCM4P2_IntraL0LMAX[15];
extern const OMX_U8 armVCM4P2_IntraL1LMAX[21];
extern const OMX_U8 armVCM4P2_IntraL0RMAX[27];
extern const OMX_U8 armVCM4P2_IntraL1RMAX[8];
extern const OMX_U8 armVCM4P2_InterL0RunIdx[12];
extern const ARM_VLC32 armVCM4P2_InterVlcL0[59];
extern const OMX_U8 armVCM4P2_InterL1RunIdx[3];
extern const ARM_VLC32 armVCM4P2_InterVlcL1[45];
extern const OMX_U8 armVCM4P2_InterL0LMAX[27];
extern const OMX_U8 armVCM4P2_InterL1LMAX[41];
extern const OMX_U8 armVCM4P2_InterL0RMAX[12];
extern const OMX_U8 armVCM4P2_InterL1RMAX[3];
extern const ARM_VLC32 armVCM4P2_aIntraDCLumaIndex[14];
extern const ARM_VLC32 armVCM4P2_aIntraDCChromaIndex[14];
extern const ARM_VLC32 armVCM4P2_aVlcMVD[66];

#endif /* _OMXHUFFTAB_H_ */
