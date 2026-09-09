/*----------------------------------------------------------
    File Name   : syscfg.h
    Description : System configuration
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

#ifndef __SYSCFG_H_
#define __SYSCFG_H__

#define MCLK					50000000
#define DEVICE_ID				0x00105101

// Flash memory
#define FLASH_MAX_SIZE			0x100000000	// 4GB

// External SRAM (Max 64KB)
#define EXT_SRAM_MAX_SIZE		0x10000		// 64KB

// BUSWIDTH : 16/32
#define BUSWIDTH			(8)

/*-----------------------------------------------------------
    BASE ADDRESS DEFINITION
-----------------------------------------------------------*/
#define DEVICE_STARTADDR	0x2000		// 8KB ~
#define EXTSRAM_STARTADDR	0x0

#endif /* __SYSCFG_H__ */
