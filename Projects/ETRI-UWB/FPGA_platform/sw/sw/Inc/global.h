/*-------------------------------------------------------------------
File name   : global.h

Description : middle level routines
----------------------------------------------------------------------*/
#ifndef __GLOBAL_VAR_H__
#define __GLOBAL_VAR_H__

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */

#include "sysinc.h"
#include "structDef.h"

/*/////////////////////////////////////////////////////////
        GLOBAL VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

#ifdef GLOBAL_DEFINE
    #define GLOBAL_VAR
#else
    #define GLOBAL_VAR  extern
#endif

/*---------------------------------------------------------
        MEMEORY
--------------------------------------------------------- */

/*---------------------------------------------------------
        UART
--------------------------------------------------------- */

/*---------------------------------------------------------
        I2C
--------------------------------------------------------- */
//GLOBAL_VAR volatile smtUint32 interruptWait;
//GLOBAL_VAR I2C_STRUCT gI2C;

/*
	--------------------------------
	| 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
	--------------------------------
	0	-> I2C master error
	1	-> Start flag bit
	2	-> Restart flag bit

	(WR operation)
	3	-> Add Tx. Slave's ack receive flag bit
	4	-> Data Tx. Slave's ack flag bit
	(RD operation)
	5	-> Addr Tx. Slave's ack receive flag bit
	6	-> Data Rx. Slave's data Tx. master ack flag bit
	7	-> Data Rx. Slave's data Tx. master non-ack flag bit
*/
//GLOBAL_VAR volatile smtUint16 masterStatus;

#define I2C_MASTER_NO_ERROR				0x0
#define I2C_MASTER_ERROR				0x1
#define I2C_MASTER_START_FLAG			0x2
#define I2C_MASTER_RESTART_FLAG			0x4
// Master write operation
#define I2C_MASTER_WR_ADDR_ACK_FLAG		0x8
#define I2C_MASTER_WR_DATA_ACK_FLAG		0x10
// Master read operation
#define I2C_MASTER_RD_ADDR_ACK_FLAG		0x20
#define I2C_MASTER_RD_DATA_ACK_FLAG		0x40
#define I2C_MASTER_RD_DATA_NON_ACK_FLAG	0x80
 

/*---------------------------------------------------------
        TIMER & PWM
--------------------------------------------------------- */


/*---------------------------------------------------------
        WDT
--------------------------------------------------------- */


/*---------------------------------------------------------
        GPIO
--------------------------------------------------------- */


/*---------------------------------------------------------
        VIC
--------------------------------------------------------- */


/*---------------------------------------------------------
        ADC
--------------------------------------------------------- */


/*---------------------------------------------------------
        POWER MANAGEMENT
--------------------------------------------------------- */

#endif /* __GLOBAL_VAR_H__ */
