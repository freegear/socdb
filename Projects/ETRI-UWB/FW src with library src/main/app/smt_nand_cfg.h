#ifndef NAND_MEMORY_MAP_H_
#define	NAND_MEMORY_MAP_H_

#include "structdef.h"
//------------------------------------------------------------------------------
//	NAND memory base offset
//------------------------------------------------------------------------------
#define	NAND_MEM_START			(160)									// offset from 20MByte
//------------------------------------------------------------------------------
//	NAND test block (16 NAND blocks)
//------------------------------------------------------------------------------
#define	NAND_TEST_START			(NAND_MEM_START)

// 2MByte reserve for NAND test
#define	NAND_TEST_LEN			(16)

#define	NAND_TEST_END			(NAND_MEM_START+NAND_TEST_LEN)
//------------------------------------------------------------------------------
//	I2S test block (960 NAND blocks)
//------------------------------------------------------------------------------
#define	I2S_WAVE_START			(NAND_TEST_END)

// 60MByte 	reserve
#define	I2S_WAVE_0_HANDLE		(I2S_WAVE_START)						
#define	I2S_WAVE_0_LEN			(480)

// 60MByte 	reserve
#define	I2S_WAVE_1_HANDLE		(I2S_WAVE_0_HANDLE+I2S_WAVE_0_LEN)	
#define	I2S_WAVE_1_LEN			(480)

// 120Mbyte reserve for I2S test
#define	I2S_WAVE_LEN			(I2S_WAVE_0_LEN\
								+I2S_WAVE_1_LEN)

#define I2S_WAVE_END			(I2S_WAVE_START+I2S_WAVE_LEN)
//------------------------------------------------------------------------------
//	DM test block (80 NAND blocks)
//------------------------------------------------------------------------------
#define	DM_START				(I2S_WAVE_END)		

// 10MByte	reserve for Display & Video encoder test
#define	DM_LEN					(80)

#define	DM_END					(DM_START+DM_LEN)
//------------------------------------------------------------------------------
//	JPEG test block (10 NAND blocks)
//------------------------------------------------------------------------------
#define	JPG_START				(DM_END)

// 1.28MByte reserve for JPEG test
#define	JPG_LEN					(10)

// 640KByte reserve
#define	JPG_PANORAMA_0_HANDLE	(JPG_START)						
#define	JPG_PANORAMA_0_LEN		(5)

// 640KByte reserve
#define	JPG_PANORAMA_1_HANDLE	(JPG_PANORAMA_0_HANDLE+JPG_PANORAMA_0_LEN)	
#define	JPG_PANORAMA_1_LEN		(5)

#define	JPG_END					(JPG_START+JPG_LEN)
//------------------------------------------------------------------------------
//	Free test block (480 NAND blocks)
//------------------------------------------------------------------------------
#define	NAND_FREE_START			(JPG_END)			

// 60MByte 	reserve
#define	NAND_FREE_LEN			(480)

#define	NAND_FREE_END			(NAND_FREE_START+NAND_FREE_LEN)
//------------------------------------------------------------------------------
//	NAND memory end
//------------------------------------------------------------------------------
#define	NAND_MEM_END			(NAND_FREE_END)							


#else
#endif
