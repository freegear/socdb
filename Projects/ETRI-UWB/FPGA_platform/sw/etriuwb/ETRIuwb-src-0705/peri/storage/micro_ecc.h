#ifndef __MICRO_ECC__
#define	__MICRO_ECC__
/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: micro_ecc.h 
	Description	: ecc software module
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

typedef unsigned short	u16;
typedef unsigned char	u8;
typedef unsigned char*  u8p;
typedef unsigned short* u16p;
typedef unsigned*		u32p;
typedef void *			voidp;
typedef signed char 	s8;
typedef signed short 	s16;
typedef unsigned int	u32;

u8 mu_ecc_correct(u32 m, u32 r, u8 *buf);
u8 mu_ecc_generate_512(u8 *eccbuf, u8 *datbuf);
u8 mu_ecc_generate_256(u8 *eccbuf, u8 *datbuf);
u8 mu_ecc_generate_3(u8 *eccbuf, u8 *datbuf);

#endif
