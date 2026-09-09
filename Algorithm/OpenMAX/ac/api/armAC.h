/**
 *  armAC.h
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
 * File: armAC.h
 * Brief: Declares API's/Basic Data types used across the OpenMAX Audio domain
 *
 */
 
  
#ifndef _armAC_H_
#define _armAC_H_

#include "omxAC.h"
#include "armCOMM.h"

/*AAC specific Declarations/Definitions*/


#define ARM_AAC_ZERO_HCB                0
#define ARM_AAC_FIRST_PAIR_HCB          5
#define ARM_AAC_NOISE_HCB               13
#define ARM_AAC_INTENSITY_HCB2          14
#define ARM_AAC_INTENSITY_HCB           15
#define ARM_AAC_ESC_HCB                 11
#define ARM_AAC_ESC_FLAG                16

#define ARM_AAC_ONLY_LONG_SEQUENCE      0
#define ARM_AAC_LONG_START_SEQUENCE     1
#define ARM_AAC_EIGHT_SHORT_SEQUENCE    2
#define ARM_AAC_LONG_STOP_SEQUENCE      3
#define ARM_AAC_LTP                     4

#define ARM_AAC_NOISE_OFFSET            90
#define ARM_AAC_INDEX_OFFSET            60
#define ARM_AAC_WIN_SHORT               128
#define ARM_AAC_WIN_LONG                1024

#define ARM_AAC_Q_FACTOR                18
#define ARM_AAC_RAND_MULT               1664525
#define ARM_AAC_RAND_ADD                1013904223


/**
 * Function: armACAAC_TnsDecodeCoef
 *
 * Description:
 * Inverse Quantization and conversion to LPC coefficients
 *
 * Parameters:
 * [in]  pTnsFiltCoef pointer to TNS filter coefficients
 * [in]  coeffRes     TNS coef resolution bits
 * [in]  tnsOrder     TNS filter order
 * [out] pLpCoeff     pointer to the LPC coefficients
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */
OMXResult armACAAC_TnsDecodeCoef(
    const OMX_S8 *pTnsFiltCoef,
    OMX_F64 *pLpCoeff,
    OMX_INT coeffRes,
    OMX_INT tnsOrder
);

/**
 * Function: armACAAC_TnsFilter
 *
 * Description:
 * TNS filter for analysis/synthesis
 *
 * Parameters:
 * [in]  pSpectralCoeff pointer to the spectral coefficients to do encode TNS
 *                                             	represented in Q13.18 format.  
 * [in]  pLpCoeff       pointer to the LPC coefficients
 * [in]  size           size of filtering
 * [in]  tnsOrder       TNS filter order
 * [in]  increment      indicating direction of filtering
 * [in]  flag           Indicating Encode/Decode 1: Encode 0: Decode
 * [out] pSpectralCoeff pointer to the spectral coefficients have done encode TNS
 *												represented in Q13.18 format.  
 *
 */
OMXVoid   armACAAC_TnsFilter(
    OMX_S32 *pSpectralCoeff,
    OMX_F64 *pLpCoeff,
    OMX_INT size,
    OMX_INT increment, 
    OMX_INT tnsOrder,
    OMX_INT flag
);

/**
 * Function: armACAAC_DecodeLtpData
 *
 * Description:
 * Parses the LTP information from the bit stream.
 *
 * Parameters:
 * [in/out]  ppBitStream  pointer to the pointer to the current byte
 * [in/out]  pOffset	  pointer to the bit position in the byte pointed
 *                         by *ppBitStream. Valid within 0 to 7. 0: MSB of
 *                         the byte, 7: LSB of the byte.
 * [in]  winSequence      window type, short or long
 * [in]  maxSfb           number of scale factor band
 * [out] pAACLtpInfo      pointer to the LTP information
 *
 */

OMXVoid armACAAC_DecodeLtpData(
                          const OMX_U8 **ppBitStream,
                          OMX_INT *pOffset,
                          OMX_INT winSequence,
                          OMX_INT maxSfb,
                          OMXAACLtpInfo *pLtpInfo
                        );
                        
/**
 * Function: armACAAC_DecodeIcsInfoData
 *
 * Description:
 * Parses ICS information from the bit stream.
 *
 * Parameters:
 * [in/out]  ppBitStream  pointer to the pointer to the current byte
 * [in/out]  pOffset	  pointer to the bit position in the byte pointed
 *                         by *ppBitStream. Valid within 0 to 7. 0: MSB of
 *                         the byte, 7: LSB of the byte.
 * [in]  commonWin         1/0:Infomation shared/ notshared for two channels
 * [in]  audioObjectType   audio object type indication. 1:main, 2:LC, 4: LTP 
 * [in]  predSfbMax         maximum prediction scalefactor bands. For LC profile, set predSfbMax = 0
 *                                for there is no predictors.
 * [out] pChanInfo     pointer to the channel information structure
 *                          used as output only if != NULL
 * [out] pIcsInfo     pointer to the ICS information structure
 * [out] pLtpInfo          pointer to the array of pointers to the LTP information structures
 *
 */
 
OMXResult armACAAC_DecodeIcsInfoData(
                                const OMX_U8 **ppBitStream,
                                OMX_INT *pOffset,
                                OMX_INT commonWin,
                                OMX_INT audioObjectType,
                                OMX_INT predSfbMax,
                                OMXAACChanInfo *pChanInfo,
                                OMXAACIcsInfo *pIcsInfo,
                                OMXAACLtpInfoPtr *pLtpInfo
                            );

/*MP3 specific Declarations/Definitions*/
#define ARM_MP3_SINGLE_CHANNEL_MODE    (3)
#define ARM_MP3_MAIN_BEGIN_LEN1        (9)
#define ARM_MP3_MAIN_BEGIN_LEN2        (8)
#define ARM_MP3_PRIV_SINGLE_LEN1       (5)
#define ARM_MP3_PRIV_SINGLE_LEN2       (1)
#define ARM_MP3_PRIV_NOTSINGLE_LEN1    (3)
#define ARM_MP3_PRIV_NOTSINGLE_LEN2    (2)

#define ARM_MP3_WINDOW_SZ              (36)
#define ARM_MP3_SHORTBLOCK_SZ          (12)
#define ARM_MP3_LONGBLOCK_SZ           (36)
#define ARM_MP3_SUBBAND_SZ             (18)
#define ARM_MP3_NO_OF_SUBBANDS         (32)
#define ARM_MP3_ALIAS_BFLY_NOS         (8)
#define ARM_MP3_MAX_NUM_CHANNEL        (2) 
#define ARM_MP3_JOINT_STEREO_MODE      (1) 
#define ARM_MP3_SQUARROOT              (1.4142135623730950488016887242097) 
#define ARM_MP3_SINGLE_CHANNEL_MODE    (3)
#define ARM_MP3_LONG_SFB_TABLE_SZ      (23)
#define ARM_MP3_SHORT_SFB_TABLE_SZ     (14)
#define ARM_MP3_PQMF_SZ                (32)
#define ARM_MP3_VBUFFER_SZ             (512)
#define ARM_MP3_HUFF_ESCAPE_CODE       (15)

#endif /*_armAC_H_*/

/*End of file*/
