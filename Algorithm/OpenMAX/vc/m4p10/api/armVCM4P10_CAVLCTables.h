/* ----------------------------------------------------------------
 * 
 *  armVCM4P10_CAVLCTables.h
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
 * ----------------------------------------------------------------
 * File:     armVCM4P10_CAVLCTables.h
 * ----------------------------------------------------------------
 * 
 * Header file for ARM implementation of OpenMAX VCM4P10
 * 
 */
 
#ifndef ARMVCM4P10_CAVLCTABLES_REF_H
#define ARMVCM4P10_CAVLCTABLES_REF_H
  
/* CAVLC tables */

extern const OMX_U8 armVCM4P10_CAVLCTrailingOnes[62];
extern const OMX_U8 armVCM4P10_CAVLCTotalCoeff[62];
extern const ARM_VLC32 *armVCM4P10_CAVLCCoeffTokenTables[5];
extern const ARM_VLC32 armVCM4P10_CAVLCLevelPrefix[17];
extern const ARM_VLC32 *armVCM4P10_CAVLCTotalZeroTables[15];
extern const ARM_VLC32 *armVCM4P10_CAVLCTotalZeros2x2Tables[3];
extern const ARM_VLC32 *armVCM4P10_CAVLCRunBeforeTables[7];

#endif
