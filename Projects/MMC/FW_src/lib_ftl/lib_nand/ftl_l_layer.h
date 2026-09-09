#ifndef _FTL_L_LAYER_H_
#define _FTL_L_LAYER_H_

/****************************************************************************
 *
 *            Copyright (c) 2005-2006 by HCC Embedded
 *
 * This software is copyrighted by and is the sole property of
 * HCC.  All rights, title, ownership, or other interests
 * in the software remain the property of HCC.  This
 * software may only be used in accordance with the corresponding
 * license agreement.  Any unauthorized use, duplication, transmission,
 * distribution, or disclosure of this software is expressly forbidden.
 *
 * This Copyright notice may not be removed or modified without prior
 * written consent of HCC.
 *
 * HCC reserves the right to modify this software without notice.
 *
 * HCC Embedded
 * Budapest 1132
 * Victor Hugo Utca 11-15
 * Hungary
 *
 * Tel:  +36 (1) 450 1302
 * Fax:  +36 (1) 450 1303
 * http: www.hcc-embedded.com
 * email: info@hcc-embedded.com
 *
 ***************************************************************************/

/****************************************************************************
 *
 * C++ opening bracket for compatibility
 *
 ***************************************************************************/

#ifdef __cplusplus
extern "C" {
#endif

/****************************************************************************
 *
 * includes
 *
 ***************************************************************************/


#ifndef _FTL_O_RW_H_
//#include "../mlayer.h"
#include "../lib_ftl/ftl_o_rw.h"
#endif


/****************************************************************************
 *
 * external functions of llayer
 *
 ***************************************************************************/

extern smtUint8 FTL_L_Init(void);
extern smtUint8 FTL_L_Erase(smtBlkAddr pba);
extern smtUint8 FTL_L_Write(smtBlkAddr pba,smtPageAddr ppo, smtUint8 *buffer);
extern smtUint8 FTL_L_WriteDouble(smtBlkAddr pba,smtPageAddr ppo, smtUint8 *buffer0,smtUint8 *buffer1);
extern smtUint8 FTL_L_Read(smtBlkAddr pba,smtPageAddr ppo, smtUint8 *buffer);
extern smtUint8 FTL_L_ReadPart(smtBlkAddr pba,smtPageAddr ppo, smtUint8 *buffer,smtUint8 index);
extern smtUint8 FTL_L_IsBadBlk(smtBlkAddr pba);

/****************************************************************************
 *
 * #defines for FTL_L_ReadPart index parameter
 *
 ***************************************************************************/

#define	FTL_L_M0_0	(0x01)
#define	FTL_L_M0_1	(0x02)
#define	FTL_L_M1_0	(0x03)
#define	FTL_L_M1_1	(0x04)
#define	FTL_L_M2_0	(0x05)
#define	FTL_L_M2_1	(0x06)
#define	FTL_L_M3_0	(0x07)
#define	FTL_L_M3_1	(0x08)

#define	FTL_L_S0	(0x11)
#define	FTL_L_S1	(0x12)
#define	FTL_L_S2	(0x13)
#define	FTL_L_S3	(0x14)


/****************************************************************************
 *
 * return values
 *
 ***************************************************************************/

enum 
{
	FTL_L_OK,
	FTL_L_ERASED,
	FTL_L_ERROR
};

/****************************************************************************
 *
 * C++ closing bracket
 *
 ***************************************************************************/

#ifdef __cplusplus
}
#endif

/****************************************************************************
 *
 * end of llayer.h
 *
 ***************************************************************************/

#endif	/* _LLAYER_H_ */
