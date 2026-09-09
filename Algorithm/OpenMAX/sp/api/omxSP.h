/**
 * File: omxSP.h
 * Brief: OpenMAX Signal processing DL library
 *
 * Copyright © 2005-06 The Khronos Group Inc. All Rights Reserved. 
 *
 * These materials are protected by copyright laws and contain material 
 * proprietary to the Khronos Group, Inc.  You may use these materials 
 * for implementing Khronos specifications, without altering or removing 
 * any trademark, copyright or other notice from the specification.
 * 
 * Khronos Group makes no, and expressly disclaims any, representations 
 * or warranties, express or implied, regarding these materials, including, 
 * without limitation, any implied warranties of merchantability or fitness 
 * for a particular purpose or non-infringement of any intellectual property. 
 * Khronos Group makes no, and expressly disclaims any, warranties, express 
 * or implied, regarding the correctness, accuracy, completeness, timeliness, 
 * and reliability of these materials. 
 *
 * Under no circumstances will the Khronos Group, or any of its Promoters, 
 * Contributors or Members or their respective partners, officers, directors, 
 * employees, agents or representatives be liable for any damages, whether 
 * direct, indirect, special or consequential damages for lost revenues, 
 * lost profits, or otherwise, arising from or in connection with these 
 * materials.
 * 
 * Khronos and OpenMAX are trademarks of the Khronos Group Inc. 
 *
 */


#ifndef _OMXSP_H_
#define _OMXSP_H_

#include "omxtypes.h"

#ifdef __cplusplus
extern "C" {
#endif

/* *****************************************************************************************/
/**
 *
 *  NewDomain: SP The Signal Processing subdomain
 *  WithinDomain: OM
 *
 *  StartDomain: SP
 */



/** =============== FFT Specification Structure ============== */

typedef void OMXFFTSpec_C_SC16;
typedef void OMXFFTSpec_C_SC32;
typedef void OMXFFTSpec_R_S16S32;
typedef void OMXFFTSpec_R_S32;

/** =========================== General Functions =========================== */


/** Copy */
/**
 * Function: omxSP_Copy_S16
 *
 * Description:
 * Vector copy for 16-bit type data.
 *
 * Remarks:
 * This function Copies the len elements of the vector pointed to by pSrc into
 * the len elements of the vector pointed to by pDst.
 * The function checks the alignment of the pointers and select the optimal way to copy.
 *
 * Parameters:
 * [in]  pSrc        pointer to the source vector
 * [in]  len         number of elements contained in the source and
 *             destination vectors
 * [out] pDst        pointer to the destination vector
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_Copy_S16(
     const OMX_S16 * pSrc,
     OMX_S16 * pDst,
     OMX_INT len
 );


/** Dot product */

/**
 * Function: omxSP_DotProd_S16
 *
 * Description:
 * Calculates the dot product of the two input vectors.  This function does not perform scaling.  
 * The internal accumulator width must be at least 32 bits.  
 * If any of the partially accumulated values exceeds the range of a signed 32-bit integer then the result is undefined.  
 * Remarks:
 * The function does not perform scaling.
 *
 * Note:
 * This function differs from other DL functions by not returning the standard
 * OMXError but the actual result.
 *
 * Parameters:
 * [in]  pSrc1      Pointer to the first input vector,must be aligned on an 8-byte boundary.
 * [in]  pSrc2      Pointer to the second input vector,must be aligned on an 8-byte boundary.
 * [in]  len        Length of the vector in pSrc and pDst.
 *
 * Return Value:
 * The dot product result.
 *
 */

OMX_S32 omxSP_DotProd_S16 (
     const OMX_S16 * pSrc1,
     const OMX_S16 * pSrc2,
     OMX_INT len
);


/**
 * Function: omxSP_DotProd_S16_Sfs
 *
 * Calculates the dot product of the two input signals with output scaling and saturation, 
 * i.e., the result is multiplied by two to the power of the negative (-)scalefactor (scaled) prior to return.  
 * The result is saturated with rounding if the scaling operation produces a value outside the range of a signed 32-bit integer.  
 * Rounding behavior is defined in section 1.6.6 Integer Scaling and Rounding Conventions. The internal accumulator width must be at least 32 bits. 
 * The result is undefined if any of the partially accumulated values exceeds the range of a signed 32-bit integer. 
 * Note:
 * This function differs from other DL functions by not returning the
 * standard OMXError but the actual result.
 *
 * Parameters:
 * [in]  pSrc1      Pointer to the first input vector,must be aligned on an 8-byte boundary.
 * [in]  pSrc2      Pointer to the second input vector,must be aligned on an 8-byte boundary.
 * [in]  len        Length of the vector in pSrc and pDst.
 * [in]  scaleFactor    Integer scalefactor.
 *
 * Return Value:
 * The dot product result.
 *
 */

OMX_S32 omxSP_DotProd_S16_Sfs (
     const OMX_S16 * pSrc1,
     const OMX_S16 * pSrc2,
     OMX_INT len,
     OMX_INT scaleFactor
);



/**
 * Function: omxSP_BlockExp_S16
 *
 * Description:
 * Block exponent calculation for 16-bit signals (count leading sign bits)
 *
 * Remarks:
 * This function computes the number of extra sign bits of all values in
 * the 16-bit input vector pSrc  and returns the minimum sign bit count.
 * This is also the maximum shift value that could be used in scaling the
 * block of data.The functions return the values 15, for
 * input vectors in which all entries are equal to zero.
 *
 * Note:
 * This function differs from other DL functions by not returning the
 * standard OMXError but the actual result.
 *
 * Parameters:
 * [in]  pSrc       Pointer to the input signal buffer
 * [in]  len        Length of the signal in pSrc
 *
 * Return Value:
 * Maximum exponent that may be used in scaling
 *
 */

OMX_S32 omxSP_BlockExp_S16 (
     const OMX_S16 * pSrc,
     OMX_INT len
);

/**
 * Function: omxSP_BlockExp_S32
 *
 * Description:
 * Block exponent calculation for 32-bit signals (count leading sign bits).
 *
 * Remarks:
 * This function computes the number of extra sign bits of all values in the
 * 32-bit input vector pSrc  and returns the minimum sign bit count. This is
 * also the maximum shift value that could be used in scaling the block of
 * data.The functions return the values 31, for
 * input vectors in which all entries are equal to zero.
 *
 * Note:
 * This function differs from other DL functions by not returning the
 * standard OMXError but the actual result.
 *
 * Parameters:
 * [in]  pSrc       Pointer to the input signal buffer.
 * [in]  len        Length of the signal in pSrc.
 *
 * Return Value:
 * Maximum exponent that may be used in scaling
 *
 */

OMX_S32 omxSP_BlockExp_S32 (
     const OMX_S32 * pSrc,
     OMX_INT len
);



/** =========================== Filter Functions ============================ */

/** FIR single rate */
/**
 * Function: omxSP_FIR_Direct_S16
 *
 * Description:
 * Block FIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the FIR filter defined by the coefficient vector
 * pTapsQ15 to a vector of input data.The output will saturate to 0x8000
 *(-32768) for a negative overflow or 0x7fff (32767) for a positive overflow.
 *
 * Parameters:
 * [in]  pSrc       	pointer to the vector of input samples to which
 *				the filter is applied.
 * [in]  sampLen     	the number of samples contained in both the
 *				input and output vectors.
 * [in]  pTapsQ15      	pointer to the vector that contains the filter
 *				coefficients, represented in Q0.15 format.
 *              Given that -32768<=pTapsQ15(k)<32768,
 *              0<=k<tapsLen, the range on the actual filter
 *              coefficients is: -1<=bk<1, and therefore
 *				coefficient normalization may be required
 *				during the filter design process.
 * [in]  tapsLen    	the number of taps, e.g. the filter order + 1
 * [in]  pDelayLine       pointer to the 2*tapsLen-element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zero in most applications.
 * [in]  pDelayLineIndex  pointer to the filter memory index that is
 *				maintained internally by the primitive. User
 *				should initialize the value of this index to
 *				zero.
 * [out] pDst		pointer to the vector of filtered output
 *				samples.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FIR_Direct_S16(
     const OMX_S16 * pSrc,
     OMX_S16 * pDst,
     OMX_INT sampLen,
     const OMX_S16 * pTapsQ15,
     OMX_INT tapsLen,
     OMX_S16 * pDelayLine,
     OMX_INT * pDelayLineIndex
 );



/**
 * Function: omxSP_FIR_Direct_S16_I
 *
 * Description:
 * Block FIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the FIR filter defined by the coefficient vector
 * pTapsQ15 to a vector of input data.The output will saturate to 0x8000
 *(-32768) for a negative overflow or 0x7fff (32767) for a positive overflow.
 *
 * Parameters:
 * [in]  pSrcDst       	pointer to the vector of input samples to which
 *				the filter is applied.
 * [in]  sampLen     	the number of samples contained in both the
 *				input and output vectors.
 * [in]  pTapsQ15      	pointer to the vector that contains the filter
 *				coefficients, represented in Q0.15 format.
 *              Given that -32768<=pTapsQ15(k)<32768,
 *              0<=k<tapsLen, the range on the actual filter
 *              coefficients is: -1<=bk<1, and therefore
 *				coefficient normalization may be required during
 *				the filter design process.
 * [in]  tapsLen    	the number of taps, e.g. the filter order + 1
 * [in]  pDelayLine       pointer to the 2*tapsLen-element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zeroin most applications.
 * [in]  pDelayLineIndex  pointer to the filter memory index that is
 *				maintained internally by the primitive. User
 *				should initialize the value of this index to
 *				zero.
 * [out] pSrcDst		pointer to the vector of filtered output
 *				samples.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FIR_Direct_S16_I(
     OMX_S16 * pSrcDst,
     OMX_INT sampLen,
     const OMX_S16 * pTapsQ15,
     OMX_INT tapsLen,
     OMX_S16 * pDelayLine,
     OMX_INT * pDelayLineIndex
 );



/**
 * Function: omxSP_FIROne_Direct_S16
 *
 * Description:
 * Single-sample FIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the FIR filter defined by the coefficient vector
 * pTapsQ15 to a single sample of input data.The output will saturate to 0x8000
 *(-32768) for a negative overflow or 0x7fff (32767) for a positive overflow.
 *
 * Parameters:
 * [in]  val       	the single input sample to which the filter is
 * 				applied.
 * [in]  pTapsQ15      	pointer to the vector that contains the filter
 *				coefficients, represented in Q0.15 format.
 *              Given that -32768<=pTapsQ15(k)<32768,
 *              0<=k<tapsLen, the range on the actual filter
 *              coefficients is: -1<=bk<1, and therefore
 *				coefficient normalization may be required
 *				during the filter design process.
 * [in]  tapsLen    	the number of taps, e.g. the filter order + 1
 * [in]  pDelayLine       pointer to the 2*tapsLen-element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zero in most applications.
 * [in]  pDelayLineIndex  pointer to the filter memory index that is
 *				maintained internally by the primitive. User
 *				should initialize the value of this index to
 *				zero.
 * [out] pResult		pointer to the filtered output sample
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FIROne_Direct_S16(
     OMX_S16 val,
     OMX_S16 * pResult,
     const OMX_S16 * pTapsQ15,
     OMX_INT tapsLen,
     OMX_S16 * pDelayLine,
     OMX_INT * pDelayLineIndex
 );



/**
 * Function: omxSP_FIROne_Direct_S16_I
 *
 * Description:
 * Single-sample FIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the FIR filter defined by the coefficient vector
 * pTapsQ15 to a single sample of input data.The output will saturate to 0x8000
 *(-32768) for a negative overflow or 0x7fff (32767) for a positive overflow.
 *
 * Parameters:
 * [in]  pValResult      	A pointer to the single input sample to which
 * 				the filter is applied.
 * [in]  pTapsQ15      	pointer to the vector that contains the filter
 *				coefficients, represented in Q0.15 format.
 *              Given that -32768<=pTapsQ15(k)<32768,
 *              0<=k<tapsLen, the range on the actual filter
 *              coefficients is: -1<=bk<1, and therefore
 *				coefficient normalization may be required
 *				during the filter design process.
 * [in]  tapsLen    	the number of taps, e.g. the filter order + 1
 * [in]  pDelayLine       pointer to the 2*tapsLen-element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zero in most applications.
 * [in]  pDelayLineIndex  pointer to the filter memory index that is
 *				maintained internally by the primitive. User
 *				should initialize the value of this index to
 *				zero.
 * [out] pValResult	pointer to the filtered output sample.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FIROne_Direct_S16_I(
     OMX_S16 * pValResult,
     const OMX_S16 * pTapsQ15,
     OMX_INT tapsLen,
     OMX_S16 * pDelayLine,
     OMX_INT * pDelayLineIndex
 );



/**
 * Function: omxSP_FIR_Direct_S16_Sfs
 *
 * Description:
 * Block FIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the FIR filter defined by the coefficient vector
 * pTapsQ15 to a vector of input data.The output will be multiplied by 2 to the negative power of scalefactor before returning to the caller.
 *
 * Parameters:
 * [in]  pSrc       	pointer to the vector of input samples to which
 *				the filter is applied.
 * [in]  sampLen     	the number of samples contained in both the
 *				input and output vectors.
 * [in]  pTapsQ15      	pointer to the vector that contains the filter
 *				coefficients, represented in Q0.15 format.
 *              Given that -32768<=pTapsQ15(k)<32768,
 *              0<=k<tapsLen, the range on the actual filter
 *              coefficients is: -1<=bk<1, and therefore
 *				coefficient normalization may be required during
 *				the filter design process.
 * [in]  tapsLen    	the number of taps, e.g. the filter order + 1
 * [in]  pDelayLine       pointer to the 2*tapsLen-element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zero in most applications.
 * [in]  pDelayLineIndex  pointer to the filter memory index that is
 *				maintained internally by the primitive. User
 *				should initialize the value of this index to
 *				zero.
 * [in]  scaleFactor	saturation fixed scalefactor.
 * [out] pDst		pointer to the filtered output samples.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FIR_Direct_S16_Sfs(
     const OMX_S16 * pSrc,
     OMX_S16 * pDst,
     OMX_INT sampLen,
     const OMX_S16 * pTapsQ15,
     OMX_INT tapsLen,
     OMX_S16 * pDelayLine,
     OMX_INT * pDelayLineIndex,
     OMX_INT scaleFactor
 );



/**
 * Function: omxSP_FIR_Direct_S16_ISfs
 *
 * Description:
 * Block FIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the FIR filter defined by the coefficient vector
 * pTapsQ15 to a vector of input data.The output will be multiplied by 2 to the negative power of scalefactor before returning to the caller.
 *
 * Parameters:
 * [in]  pSrcDst       	pointer to the vector of input samples to which
 *				the filter is applied.
 * [in]  sampLen     	the number of samples contained in both the
 *				input and output vectors.
 * [in]  pTapsQ15      	pointer to the vector that contains the filter
 *				coefficients, represented in Q0.15 format.
 *              Given that -32768<=pTapsQ15(k)<32768,
 *              0<=k<tapsLen, the range on the actual filter
 *              coefficients is: -1<=bk<1, and therefore
 *				coefficient normalization  may be required during
 *				the filter design process.
 * [in]  tapsLen    	the number of taps, e.g. the filter order + 1
 * [in]  pDelayLine       pointer to the 2*tapsLen-element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zero in most	applications.
 * [in]  pDelayLineIndex  pointer to the filter memory index that is
 *				maintained internally by the primitive. User
 *				should initialize the value of this index to
 *				zero.
 * [in]  scaleFactor	saturation fixed scalefactor.
 * [out] pSrcDst		pointer to the filtered output samples.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FIR_Direct_S16_ISfs(
     OMX_S16 * pSrcDst,
     OMX_INT sampLen,
     const OMX_S16 * pTapsQ15,
     OMX_INT tapsLen,
     OMX_S16 * pDelayLine,
     OMX_INT * pDelayLineIndex,
     OMX_INT scaleFactor
 );



/**
 * Function: omxSP_FIROne_Direct_S16_Sfs
 *
 * Description:
 * Single-sample FIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the FIR filter defined by the coefficient vector
 * pTapsQ15 to a single sample of input data.The output will be multiplied by 2 to the negative power of scalefactor before returning to the user.
 *
 * Parameters:
 * [in]  val       	the single input sample to which the filter is
 * 				applied.
 * [in]  pTapsQ15      	pointer to the vector that contains the filter
 *				coefficients, represented in Q0.15 format.
 *              Given that -32768<=pTapsQ15(k)<32768,
 *              0<=k<tapsLen, the range on the actual filter
 *              coefficients is: -1<=bk<1, and therefore
 *				coefficient normalization may be required during
 *				the filter design process.
 * [in]  tapsLen    	the number of taps, e.g. the filter order + 1
 * [in]  pDelayLine       pointer to the 2*tapsLen-element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zero in most applications.
 * [in]  pDelayLineIndex  pointer to the filter memory index that is
 *				maintained internally by the primitive. User
 *				should initialize the value of this index to
 *				zero.
 * [in]  scaleFactor	saturation fixed scalefactor.
 * [out] pResult		pointer to the filtered output sample
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FIROne_Direct_S16_Sfs(
     OMX_S16 val,
     OMX_S16 * pResult,
     const OMX_S16 * pTapsQ15,
     OMX_INT tapsLen,
     OMX_S16 * pDelayLine,
     OMX_INT * pDelayLineIndex,
     OMX_INT scaleFactor
 );



/**
 * Function: omxSP_FIROne_Direct_S16_ISfs
 *
 * Description:
 * Single-sample FIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the FIR filter defined by the coefficient vector
 * pTapsQ15 to a single sample of input data.The output will be multiplied by 2 to the negative power of scalefactor before returning to the user.
 *
 * Parameters:
 * [in]  pValResult      	A pointer to the single input sample to which
 * 				the filter is applied.
 * [in]  pTapsQ15      	pointer to the vector that contains the filter
 *				coefficients, represented in Q0.15 format.
 *              Given that -32768<=pTapsQ15(k)<32768,
 *              0<=k<tapsLen, the range on the actual filter
 *              coefficients is: -1<=bk<1, and therefore
 *				coefficient normalization may be required during
 *				the filter design process.
 * [in]  tapsLen    	the number of taps, e.g. the filter order + 1
 * [in]  pDelayLine       pointer to the 2*tapsLen-element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zero in most applications.
 * [in]  pDelayLineIndex  pointer to the filter memory index that is
 *				maintained internally by the primitive. User
 *				should initialize the value of this index to
 *				zero.
 * [in]  scaleFactor	saturation fixed scalefactor.
 * [out] pValResult	pointer to the filtered output sample
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FIROne_Direct_S16_ISfs(
     OMX_S16 * pValResult,
     const OMX_S16 * pTapsQ15,
     OMX_INT tapsLen,
     OMX_S16 * pDelayLine,
     OMX_INT * pDelayLineIndex,
     OMX_INT scaleFactor
 );




/** IIR direct form */
/**
 * Function: omxSP_IIR_Direct_S16
 *
 * Description:
 * Block IIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the direct form II IIR filter defined by the
 * coefficient vector pTaps to a vector of input data.The output will saturate to 0x8000
 *(-32768) for a negative overflow or 0x7fff (32767) for a positive overflow.
 *
 * Parameters:
 * [in]  pSrc       	pointer to the vector of input samples to which
 *				the filter is applied.
 * [in]  len	     	the number of samples contained in both the
 *				input and output vectors.
 * [in]  pTaps      	pointer to the 2L+2 element vector that
 *				contains the combined numerator and denominator
 *				filter coefficients from the system transfer
 *				function,H(z). Coefficient scaling and c
 *				oefficient vector organization should follow
 *				the conventions described above. The value of
 *				the coefficient scalefactor exponent must be
 *              non-negative(sf>=0).
 * [in]  order    	the maximum of the degrees of the numerator and
 *				denominator coefficient polynomials from the
 *				system transfer function,H(z), that is:
 *              order=max(K,M)-1=L-1.
 * [in]  pDelayLine       pointer to the L element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zero .
 * [out] pDst		pointer to the filtered output samples.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_IIR_Direct_S16(
     const OMX_S16 * pSrc,
     OMX_S16 * pDst,
     OMX_INT len,
     const OMX_S16 * pTaps,
     OMX_INT order,
     OMX_S32 * pDelayLine
 );



/**
 * Function: omxSP_IIR_Direct_S16_I
 *
 * Description:
 * Block IIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the direct form II IIR filter defined by the
 * coefficient vector pTaps to a vector of input data.The output will saturate to 0x8000
 *(-32768) for a negative overflow or 0x7fff (32767) for a positive overflow.
 *
 * Parameters:
 * [in]  pSrcDst       	pointer to the vector of input samples to which
 *				the filter is applied.
 * [in]  len	     	the number of samples contained in both the
 *				input and output vectors.
 * [in]  pTaps      	pointer to the 2L+2 element vector that
 *				contains the combined numerator and denominator
 *				filter coefficients from the system transfer
 *				function,H(z). Coefficient scaling and c
 *				oefficient vector organization should follow
 *				the conventions described above. The value of
 *				the coefficient scalefactor exponent must be
 *              non-negative(sf>=0).
 * [in]  order    	the maximum of the degrees of the numerator and
 *				denominator coefficient polynomials from the
 *				system transfer function,H(z), that is:
 *              order=max(K,M)-1=L-1.
 * [in]  pDelayLine       pointer to the L element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zero in most applications.
 * [out] pSrcDst		pointer to the filtered output samples.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_IIR_Direct_S16_I(
     OMX_S16 * pSrcDst,
     OMX_INT len,
     const OMX_S16 * pTaps,
     OMX_INT order,
     OMX_S32 * pDelayLine
 );



/**
 * Function: omxSP_IIROne_Direct_S16
 *
 * Description:
 * Single sample IIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the direct form II IIR filter defined by the
 * coefficient vector pTaps to a single sample of input data. The output will saturate to 0x8000
 *(-32768) for a negative overflow or 0x7fff (32767) for a positive overflow.
 *
 * Parameters:
 * [in]  val       	the single input sample to which the filter is
 * 				applied.
 * [in]  pTaps      	pointer to the 2L+2 element vector that
 *				contains the combined numerator and denominator
 *				filter coefficients from the system transfer
 *				function,H(z). Coefficient scaling and c
 *				oefficient vector organization should follow
 *				the conventions described above. The value of
 *				the coefficient scalefactor exponent must be
 *              non-negative(sf>=0).
 * [in]  order    	the maximum of the degrees of the numerator and
 *				denominator coefficient polynomials from the
 *				system transfer function,H(z), that is:
 *              order=max(K,M)-1=L-1.
 * [in]  pDelayLine       pointer to the L element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zero in most applications.
 * [out] pResult		pointer to the filtered output sample.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_IIROne_Direct_S16 (
     OMX_S16 val,
     OMX_S16 * pResult,
     const OMX_S16 * pTaps,
     OMX_INT order,
     OMX_S32 * pDelayLine
 );



/**
 * Function: omxSP_IIROne_Direct_S16_I
 *
 * Description:
 * Single sample IIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the direct form II IIR filter defined by the
 * coefficient vector pTaps to a single sample of input data. The output will saturate to 0x8000
 *(-32768) for a negative overflow or 0x7fff (32767) for a positive overflow.
 *
 * Parameters:
 * [in]  pValResult      	A pointer is used for the in-place version.
 * [in]  pTaps      	pointer to the 2L+2 element vector that
 *				contains the combined numerator and denominator
 *				filter coefficients from the system transfer
 *				function,H(z). Coefficient scaling and c
 *				oefficient vector organization should follow
 *				the conventions described above. The value of
 *				the coefficient scalefactor exponent must be
 *              non-negative(sf>=0).
 * [in]  order    	the maximum of the degrees of the numerator and
 *				denominator coefficient polynomials from the
 *				system transfer function,H(z), that is:
 *              order=max(K,M)-1=L-1.
 * [in]  pDelayLine       pointer to the L element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zero in most applications.
 * [out] pValResult	pointer to the filtered output sample.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_IIROne_Direct_S16_I(
     OMX_S16 * pValResult,
     const OMX_S16 * pTaps,
     OMX_INT order,
     OMX_S32 * pDelayLine
 );



/** IIR biquad */
/**
 * Function: omxSP_IIR_BiQuadDirect_S16
 *
 * Description:
 * Block biquad IIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the direct form II biquad IIR cascade defined by the
 * coefficient vector pTaps to a vector of input data.The output will saturate to 0x8000
 *(-32768) for a negative overflow or 0x7fff (32767) for a positive overflow.
 *
 * Parameters:
 * [in]  pSrc       	pointer to the vector of input samples to which
 *				the filter is applied.
 * [in]  len	     	the number of samples contained in both the
 *				input and output vectors.
 * [in]  pTaps      	pointer to the 6P element vector that contains
 * 				the combined numerator and denominator filter
 *				coefficients from the biquad cascade.
 *				Coefficient scaling and coefficient vector
 *				organization should follow the conventions
 *				described above. The value of the coefficient
 *				scalefactor exponent must be non-negative.
 *              (sfp >= 0)
 * [in]  numBiquad    	the number of biquads contained in the IIR
 *				filter cascade: (P).
 * [in]  pDelayLine       pointer to the 2P element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zero
 * [out] pDst		pointer to the filtered output samples.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_IIR_BiQuadDirect_S16(
     const OMX_S16 * pSrc,
     OMX_S16 * pDst,
     OMX_INT len,
     const OMX_S16 * pTaps,
     OMX_INT numBiquad,
     OMX_S32 * pDelayLine
 );



/**
 * Function: omxSP_IIR_BiQuadDirect_S16_I
 *
 * Description:
 * Block biquad IIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the direct form II biquad IIR cascade defined by the
 * coefficient vector pTaps to a vector of input data.The output will saturate to 0x8000
 *(-32768) for a negative overflow or 0x7fff (32767) for a positive overflow.
 *
 * Parameters:
 * [in]  pSrcDst       	pointer to the vector of input samples to which
 *				the filter is applied.
 * [in]  len	     	the number of samples contained in both the
 *				input and output vectors.
 * [in]  pTaps      	pointer to the 6P element vector that contains
 * 				the combined numerator and denominator filter
 *				coefficients from the biquad cascade.
 *				Coefficient scaling and coefficient vector
 *				organization should follow the conventions
 *				described above. The value of the coefficient
 *				scalefactor exponent must be non-negative.
 *              (sfp >= 0)
 * [in]  numBiquad    	the number of biquads contained in the IIR
 *				filter cascade: (P).
 * [in]  pDelayLine       pointer to the 2P element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zero
 * [out] pSrcDst		pointer to the filtered output samples.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_IIR_BiQuadDirect_S16_I(
     OMX_S16 * pSrcDst,
     OMX_INT len,
     const OMX_S16 * pTaps,
     OMX_INT numBiquad,
     OMX_S32 * pDelayLine
 );



/**
 * Function: omxSP_IIROne_BiQuadDirect_S16
 *
 * Description:
 * Single-sample biquad IIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the direct form II biquad IIR cascade defined by the
 * coefficient vector pTaps to a single sample of input data.The output will saturate to 0x8000
 *(-32768) for a negative overflow or 0x7fff (32767) for a positive overflow.
 *
 * Parameters:
 * [in]  val       	the single input sample to which the filter is
 *				applied.
 * [in]  pTaps      	pointer to the 6P element vector that contains
 * 				the combined numerator and denominator filter
 *				coefficients from the biquad cascade.
 *				Coefficient scaling and coefficient vector
 *				organization should follow the conventions
 *			        described above. The value of the coefficient
 *				scalefactor exponent must be non-negative.
 *              (sfp >= 0)
 * [in]  numBiquad    	the number of biquads contained in the IIR
 *				filter cascade: (P).
 * [in]  pDelayLine       pointer to the 2P element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zero
 * [out] pResult		pointer to the filtered output sample.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_IIROne_BiQuadDirect_S16(
     OMX_S16 val,
     OMX_S16 * pResult,
     const OMX_S16 * pTaps,
     OMX_INT numBiquad,
     OMX_S32 * pDelayLine
 );



/**
 * Function: omxSP_IIROne_BiQuadDirect_S16_I
 *
 * Description:
 * Single-sample biquad IIR filtering for 16-bit data type.
 *
 * Remarks:
 * This function applies the direct form II biquad IIR cascade defined by the
 * coefficient vector pTaps to a single sample of input data.The output will saturate to 0x8000
 *(-32768) for a negative overflow or 0x7fff (32767) for a positive overflow.
 *
 * Parameters:
 * [in]  pValResult      	A pointer to the single input sample to which
 *				the filter is applied.
 * [in]  pTaps      	pointer to the 6P element vector that contains
 * 				the combined numerator and denominator filter
 *				coefficients from the biquad cascade.
 *				Coefficient scaling and coefficient vector
 *				organization should follow the conventions
 *			        described above. The value of the coefficient
 *				scalefactor exponent must be non-negative.
 *              (sfp >= 0)
 * [in]  numBiquad    	the number of biquads contained in the IIR
 *				filter cascade: (P).
 * [in]  pDelayLine       pointer to the 2P element filter memory
 *				buffer(state). The user is responsible for
 *				allocation, initialization, and de-allocation.
 *				The filter memory elements are initialized to
 *				zero
 * [out] pValResult	pointer to the filtered output sample.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_IIROne_BiQuadDirect_S16_I(
     OMX_S16 * pValResult,
     const OMX_S16 * pTaps,
     OMX_INT numBiquad,
     OMX_S32 * pDelayLine
 );


/** Median */
/**
 * Function: omxSP_FilterMedian_S32
 *
 * Description:
 * This function computes the median values for each element of the input
 * array, and stores the result in the output vector.
 *
 * Remarks:
 * This function computes the median values for each element of the input
 * array, and stores the result in the output vector.
 *
 * Parameters:
 * [in]  pSrc       pointer to input and output array
 * [in]  len        number of elements contained in the input and
 *            output vectors (0 < len < 65536)
 * [in]  maskSize   median mask size. If an even value is specified,
 *            the function subtracts 1 and uses the odd value
 *            of the filter mask for median filtering
 *            (0 < maskSize <= 256).
 * [out] pDst       pointer to input and output array
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FilterMedian_S32(
     const OMX_S32 *pSrc,
     OMX_S32 *pDst,
     OMX_INT len,
     OMX_INT maskSize
 );



/**
 * Function: omxSP_FilterMedian_S32_I
 *
 * Description:
 * This function computes the median values for each element of the input
 * array, and stores the result in the output vector.
 *
 * Remarks:
 * This function computes the median values for each element of the input
 * array, and stores the result in the output vector.
 *
 * Parameters:
 * [in]  pSrcDst    pointer to input and output array
 * [in]  len        number of elements contained in the input and
 *            output vectors (0 < len < 65536)
 * [in]  maskSize   median mask size. If an even value is specified,
 *            the function subtracts 1 and uses the odd value
 *            of the filter mask for median filtering
 *            (0 < maskSize <= 256).
 * [out] pSrcDst    pointer to input and output array
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FilterMedian_S32_I(
     OMX_S32 *pSrcDst,
     OMX_INT len,
     OMX_INT maskSize
 );


/** ========================== FFT Functions ========================== */

/** FFT Helper Functions */
/**
 * Function: omxSP_FFTInit_C_SC16
 *
 * Description:
 * These functions initialize the specification structures required for the
 * complex FFT and IFFT functions.
 *
 * Remarks:
 * Desired block length is specified as an input. The function is used to
 * initialize the specification structures for functions <omxSP_FFTFwd_CToC_SC16_Sfs>
 * and <omxSP_FFTInv_CToC_SC16_Sfs>. Memory for the specification structure *pFFTSpec
 * must be allocated prior to calling this function and should be 4-byte aligned. The space required for
 * *pFFTSpec, in bytes, can be determined using <FFTGetBufSize_C_SC16>.
 *
 * Parameters:
 * [in]  order       	base-2 logarithm of the desired block length;
 *				valid in the range [0,12].
 * [out] pFFTSpec		pointer to initialized specification structure.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTInit_C_SC16(
     OMXFFTSpec_C_SC16* pFFTSpec,
     OMX_INT order
 );



/**
 * Function: omxSP_FFTGetBufSize_C_SC16
 *
 * Description:
 * These functions compute the size of the specification structure required
 * for the length 2^order complex FFT and IFFT functions.
 *
 * Remarks:
 * The function is used in conjunction with the 16-bit functions
 * <omxSP_FFTFwd_CToC_SC16_Sfs> and <omxSP_FFTInv_CToC_SC16_Sfs>.
 *
 * Parameters:
 * [in]  order       	base-2 logarithm of the desired block length;
 *				valid in the range [0,12]..
 * [out] pSize		pointer to the number of bytes required for
 *				the specification structure.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTGetBufSize_C_SC16(
     OMX_INT order,
     OMX_INT *pSize
 );



/**
 * Function: omxSP_FFTInit_C_SC32
 *
 * Description:
 * Initializes the specification structures required for the
 * complex FFT and IFFT functions.
 *
 * Remarks:
 * Desired block length is specified as an input. The function is used to
 * initialize the specification structures for functions <omxSP_FFTFwd_CToC_SC32_Sfs>
 * and <omxSP_FFTInv_CToC_SC32_Sfs>. Memory for the specification structure *pFFTSpec
 * must be allocated prior to calling this function and should be 8-byte aligned. The space required for
 * *pFFTSpec, in bytes, can be determined using <omxSP_FFTGetBufSize_C_SC32>.
 *
 * Parameters:
 * [in]  order       	base-2 logarithm of the desired block length;
 *				valid in the range [0,12].
 * [out] pFFTSpec		pointer to initialized specification structure.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTInit_C_SC32(
     OMXFFTSpec_C_SC32* pFFTSpec,
     OMX_INT order
 );



/**
 * Function: omxSP_FFTGetBufSize_C_SC32
 *
 * Description:
 * Compute the size of the specification structure required
 * for the length 2^order complex FFT and IFFT functions.
 *
 * Remarks:
 * The function is used in conjunction with the 32-bit functions
 * <omxSP_FFTFwd_CToC_SC32_Sfs> and <omxSP_FFTInv_CToC_SC32_Sfs>.
 *
 * Parameters:
 * [in]  order       	base-2 logarithm of the desired block length;
 *				valid in the range [0,12].
 * [out] pSize		pointer to the number of bytes required for
 *				the specification structure.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTGetBufSize_C_SC32(
     OMX_INT order,
     OMX_INT *pSize
 );




/**
 * Function: omxSP_FFTInit_R_S16S32
 *
 * Description:
 * Initialize the real forward-FFT specification information struct.
 *
 * Remarks:
 * This function is used to initialize the specification structures
 * for functions <omxSP_FFTFwd_RToCCS_S16S32_Sfs> and
 * <omxSP_FFTInv_CCSToR_S32S16_Sfs>. Memory for *pFFTSpec must be
 * allocated prior to calling this function and should be 8-byte aligned. The number of bytes
 * required for *pFFTSpec can be determined using
 * <omxSP_FFTGetBufSize_R_S16S32>.
 *
 * Parameters:
 * [in]  order       base-2 logarithm of the desired block length;
 *			   valid in the range [0,12].
 * [out] pFFTFwdSpec pointer to the initialized specification structure.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTInit_R_S16S32(
     OMXFFTSpec_R_S16S32* pFFTFwdSpec,
     OMX_INT order
 );



/**
 * Function: omxSP_FFTInit_R_S32
 *
 * Description:
 * Initialize the real forward-FFT specification information struct.
 *
 * Remarks:
 * This function is used to initialize the specification structures
 * for functions <omxSP_FFTFwd_RToCCS_S32_Sfs> and
 * <omxSP_FFTInv_CCSToR_S32_Sfs>. Memory for *pFFTSpec must be
 * allocated prior to calling this function and should be 8-byte aligned. The number of bytes
 * required for *pFFTSpec can be determined using
 * <omxSP_FFTGetBufSize_R_S32>.
 *
 * Parameters:
 * [in]  order       base-2 logarithm of the desired block length;
 *			   valid in the range [0,12].
 * [out] pFFTFwdSpec pointer to the initialized specification structure.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTInit_R_S32(
     OMXFFTSpec_R_S32* pFFTFwdSpec,
     OMX_INT order
 );



/**
 * Function: omxSP_FFTGetBufSize_R_S16S32
 *
 * Description:
 * Computes the size of the specification structure required for the length
 * 2^order real FFT and IFFT functions.
 *
 * Remarks:
 * This function is used in conjunction with the 16-bit functions
 * <omxSP_FFTFwd_RToCCS_S16S32_Sfs> and <omxSP_FFTInv_CCSToR_S32S16_Sfs>.
 *
 * Parameters:
 * [in]  order       base-2 logarithm of the length; valid in the range
 *			   [0,12].
 * [out] pSize	   pointer to the number of bytes required for the
 *			   specification structure.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTGetBufSize_R_S16S32(
     OMX_INT order,
     OMX_INT *pSize
 );



/**
 * Function: omxSP_FFTGetBufSize_R_S32
 *
 * Description:
 * Computes the size of the specification structure required for the length
 * 2^order real FFT and IFFT functions.
 *
 * Remarks:
 * This function is used in conjunction with the 32-bit functions
 * <omxSP_FFTFwd_RToCCS_S32_Sfs> and <omxSP_FFTInv_CCSToR_S32_Sfs>.
 *
 * Parameters:
 * [in]  order       base-2 logarithm of the length; valid in the range
 *			   [0,12].
 * [out] pSize	   pointer to the number of bytes required for the
 *			   specification structure.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTGetBufSize_R_S32(
     OMX_INT order,
     OMX_INT *pSize
 );




/** Complex FFT, 16-bit */
/**
 * Function: omxSP_FFTFwd_CToC_SC16_Sfs
 *
 * Description:
 * Compute a forward FFT for a complex signal of length of
 * 2^order, where 0 <= order <= 12.
 *
 * Remarks:
 * Transform length is determined by the specification structure, which must
 * be initialized prior to calling the FFT function using the appropriate
 * helper, i.e., <omxSP_FFTInit_C_SC16>.
 *
 * Parameters:
 * [in]  pSrc       	pointer to the input signal, a complex-valued
 *				vector of length 2^order;must be aligned on an 8-byte boundary.
 * [in]  pFFTSpec     	pointer to the pre-allocated and initialized
 *				specification structure.
 * [in]  scaleFactor      output scale factor; the range for
 *				<omxSP_FFTFwd_CToC_SC16_Sfs> is [0,16].
 * [out] pDst		pointer to the complex-valued output vector, of
 *				length 2^order.must be aligned on an 8-byte boundary.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTFwd_CToC_SC16_Sfs(
     const OMX_SC16 *pSrc,
     OMX_SC16 *pDst,
     const OMXFFTSpec_C_SC16 *pFFTSpec,
     OMX_INT scaleFactor
 );



/**
 * Function: omxSP_FFTInv_CToC_SC16_Sfs
 *
 * Description:
 * Compute an inverse FFT for a complex signal of length of 2^order,
 * where 0 <= order <= 12.
 *
 * Remarks:
 * Transform length is determined by the specification structure, which must
 * be initialized prior to calling the FFT function using the appropriate
 * helper, i.e., <omxSP_FFTInit_C_SC16>.
 *
 * Parameters:
 * [in]  pSrc       	pointer to the input signal, a complex-valued
 *				vector of length 2^order;must be aligned on an 8-byte boundary.
 * [in]  pFFTSpec     	pointer to the pre-allocated and initialized
 *				specification structure.
 * [in]  scaleFactor      output scale factor; the range for
 *				<omxSP_FFTFwd_CToC_SC16_Sfs> is [0,16].
 * [out] pDst		pointer to the complex-valued output vector, of
 *				length 2^order.must be aligned on an 8-byte boundary.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTInv_CToC_SC16_Sfs(
     const OMX_SC16 *pSrc,
     OMX_SC16 *pDst,
     const OMXFFTSpec_C_SC16 *pFFTSpec,
     OMX_INT scaleFactor
 );





/** Complex FFT, 32-bit */
/**
 * Function: omxSP_FFTFwd_CToC_SC32_Sfs
 *
 * Description:
 * Compute a forward FFT for a complex signal of length of 2^order,
 * where 0 <= order <= 12.
 *
 * Remarks:
 * Transform length is determined by the specification structure, which must
 * be initialized prior to calling the FFT function using the appropriate helper,
 * i.e., <omxSP_FFTInit_C_SC32>.
 *
 * Parameters:
 * [in]  pSrc       	pointer to the input signal, a complex-valued
 *				vector of length 2^order.must be aligned on an 8-byte boundary.
 * [in]  pFFTSpec     	pointer to the pre-allocated and initialized
 *				specification structure.
 * [in]  scaleFactor      output scale factor; the range is [0,32].
 * [out] pDst		pointer to the complex-valued output vector, of
 *				length 2^order.must be aligned on an 8-byte boundary.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTFwd_CToC_SC32_Sfs(
     const OMX_SC32 *pSrc,
     OMX_SC32 *pDst,
     const OMXFFTSpec_C_SC32 *pFFTSpec,
     OMX_INT scaleFactor
 );



/**
 * Function: omxSP_FFTInv_CToC_SC32_Sfs
 *
 * Description:
 * Compute an inverse FFT for a complex signal of length of 2^order,
 * where 0 <= order <= 12.
 *
 * Remarks:
 * Transform length is determined by the specification structure, which must
 * be initialized prior to calling the FFT function using the appropriate helper,
 * i.e., <omxSP_FFTInit_C_SC32>.
 *
 * Parameters:
 * [in]  pSrc       	pointer to the input signal, a complex-valued
 *				vector of length 2^order;must be aligned on an 8-byte boundary.
 * [in]  pFFTSpec     	pointer to the pre-allocated and initialized
 *				specification structure.
 * [in]  scaleFactor      output scale factor; the range is [0,32].
 * [out] pDst		pointer to the complex-valued output vector, of
 *				length 2^order;must be aligned on an 8-byte boundary.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTInv_CToC_SC32_Sfs(
     const OMX_SC32 *pSrc,
     OMX_SC32 *pDst,
     const OMXFFTSpec_C_SC32 *pFFTSpec,
     OMX_INT scaleFactor
 );




/** Real FFT, 16-bit */
/**
 * Function: omxSP_FFTFwd_RToCCS_S16S32_Sfs
 *
 * Description:
 * Compute a forward FFT for a real-valued signal of length of 2^order,
 * where 0 <= order <=12.
 *
 * Remarks:
 * Transform length is determined by the specification structure, which must be
 * initialized prior to calling the FFT function using the appropriate helper,
 * i.e., <omxSP_FFTInit_R_S16S32>. The conjugate-symmetric output sequence is
 * represented using a packed RCCS vector, which is of length N+2, and is
 * organized as follows:
 * Index:     0 1  2  3  4  5 . . .  N-2    N-1    N  N+1
*  Component R0 0 R1 I1 R2 I2 . . . RN/2-1 IN/2-1 RN/2 0
 *
 * Parameters:
 * [in]  pSrc       	pointer to the input signal, a complex-valued
 *				vector of length 2^order;must be aligned on an 8-byte boundary.
 * [in]  pFFTSpec     	pointer to the pre-allocated and initialized
 *				specification structure.
 * [in]  scaleFactor      output scale factor; the range is [0,32].
 * [out] pDst		pointer to output sequence, represented using
 *				RCCS format, of length 2^order+2;must be aligned on an 8-byte boundary.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTFwd_RToCCS_S16S32_Sfs(
     const OMX_S16 *pSrc,
     OMX_S32 *pDst,
     const OMXFFTSpec_R_S16S32 *pFFTSpec,
     OMX_INT scaleFactor
 );



/**
 * Function: omxSP_FFTInv_CCSToR_S32S16_Sfs
 *
 * Description:
 * Compute an inverse FFT for a real-valued output sequence of length of
 * 2^order,where 0 <= order <=12.
 *
 * Remarks:
 * Transform length is determined by the specification structure, which must be
 * initialized prior to calling the FFT function using the appropriate helper,
 * i.e., <omxSP_FFTInit_R_S16S32>. The conjugate-symmetric input sequence is
 * represented using a packed RCCS vector, which is of length N+2, and is
 * organized as follows:
 * Index:     0 1  2  3  4  5 . . .  N-2    N-1    N  N+1
 * Component R0 0 R1 I1 R2 I2 . . . RN/2-1 IN/2-1 RN/2 0
 *
 * Parameters:
 * [in]  pSrc       	pointer to the complex-valued input sequence
 *				represented using RCCcs format, of length
 *				2^order + 2;must be aligned on an 8-byte boundary.
 * [in]  pFFTSpec     	pointer to the pre-allocated and initialized
 *				specification structure.
 * [in]  scaleFactor      output scale factor; the range is [0,16].
 * [out] pDst		pointer to the real-valued output sequence,
 *				of length 2^order;must be aligned on an 8-byte boundary.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTInv_CCSToR_S32S16_Sfs(
     const OMX_S32 *pSrc,
     OMX_S16 *pDst,
     const OMXFFTSpec_R_S16S32 *pFFTSpec,
     OMX_INT scaleFactor
 );



/** Real FFT, 32-bit */
/**
 * Function: omxSP_FFTFwd_RToCCS_S32_Sfs
 *
 * Description:
 * Compute a forward FFT for a real-valued signal of length of 2^order,
 * where 0 <= order <=12.
 *
 * Remarks:
 * Transform length is determined by the specification structure, which must be
 * initialized prior to calling the FFT function using the appropriate helper,
 * i.e., <omxSP_FFTInit_R_S32>. The conjugate-symmetric output sequence is
 * represented using a packed RCCS vector, which is of length N+2, and is
 * organized as follows:
 * Index:     0 1  2  3  4  5 . . .  N-2    N-1    N  N+1
*  Component R0 0 R1 I1 R2 I2 . . . RN/2-1 IN/2-1 RN/2 0
 *
 * Parameters:
 * [in]  pSrc       	pointer to the input signal, a complex-valued
 *				vector of length 2^order;must be aligned on an 8-byte boundary.
 * [in]  pFFTSpec     	pointer to the pre-allocated and initialized
 *				specification structure.
 * [in]  scaleFactor      output scale factor; the range is [0,32].
 * [out] pDst		pointer to output sequence, represented using
 *				RCCS format, of length 2^order+2;must be aligned on an 8-byte boundary.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTFwd_RToCCS_S32_Sfs (
     const OMX_S32 *pSrc,
     OMX_S32 *pDst,
     const OMXFFTSpec_R_S32 *pFFTSpec,
     OMX_INT scaleFactor
 );



/**
 * Function: omxSP_FFTInv_CCSToR_S32_Sfs
 *
 * Description:
 * Computes an inverse FFT for a real-valued output sequence of length of
 * 2^order,where 0 <= order <=12.
 *
 * Remarks:
 * Transform length is determined by the specification structure, which must be
 * initialized prior to calling the FFT function using the appropriate helper,
 * i.e., <omxSP_FFTInit_R_S32>. The conjugate-symmetric input sequence is
 * represented using a packed RCCS vector, which is of length N+2, and is
 * organized as follows:
 * Index:     0 1  2  3  4  5 . . .  N-2    N-1    N  N+1
 * Component R0 0 R1 I1 R2 I2 . . . RN/2-1 IN/2-1 RN/2 0
 *
 * Parameters:
 * [in]  pSrc       	pointer to the complex-valued input sequence
 *				represented using RCCcs format, of length 2^order + 2;must be aligned on an 8-byte boundary.
 * [in]  pFFTSpec     	pointer to the pre-allocated and initialized
 *				specification structure.
 * [in]  scaleFactor      output scale factor; the range is [0,32].
 * [out] pDst		pointer to the real-valued output sequence,
 *				of length 2^order;must be aligned on an 8-byte boundary.
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxSP_FFTInv_CCSToR_S32_Sfs (
     const OMX_S32 *pSrc,
     OMX_S32 *pDst,
     const OMXFFTSpec_R_S32 *pFFTSpec,
     OMX_INT scaleFactor
 );





/**
 * EndDomain: SP
 */


#ifdef __cplusplus
}
#endif

#endif /** _OMXSP_H_ */

/** EOF */

