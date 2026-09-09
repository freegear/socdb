/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: i2c.c 
	Description	: I2C test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
//#include "irq.h"
#include "i2c.h"
#include "global.h"


/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
#define SLAVE_ADDR		0x00B0
#define I2C_INT_NUM		0x0


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
static void ISRI2C(smtUint32 irq);


/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */


/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*----------------------------------------------------------
	Function name	: I2CTest()
	Prototype		: smtUint32 I2CTest(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
smtUint32 I2CTest(void)
{
	smtUint32 errCode;
	I2C_CTRL_STRUCT i2c;
	smtUint8 slaveAddr, data;

	// TEST1 : Register R/W
	(smtUint32)errCode = RegisterI2C();

	i2c.txRxIntEn = 1;		// I2C interrupt enable
	i2c.txPrescale = 0x11;	//

	slaveAddr = SLAVE_ADDR;
	data = 0xf;

	RequestIRQ(I2C_INT_NUM, ISRI2C);

	// TEST2 : Write
	errCode = smt2I2CWrite(i2c, slaveAddr, data);
	if(errCode != SMT_SUCCESS)
		return SMT_ERROR;

	ReleaseIRQ(I2C_INT_NUM);
	RequestIRQ(I2C_INT_NUM, ISRI2C);

	// TEST3 : Read
	errCode = smt2I2CRead(i2c, slaveAddr, data);
	if(errCode != SMT_SUCCESS)
		return SMT_ERROR;

	ReleaseIRQ(I2C_INT_NUM);

	// TEST4 : Interrupt
	// Interupt test is included in TEST2/3

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: ISRI2C()
	Prototype		: static void ISRI2C(smtUint32 irq)
	Return		: 
	Argument	:
	Comments	: I2C interrupt handler
-----------------------------------------------------------*/
static void ISRI2C(smtUint32 irq)
{
	AckIRQ(irq);	// I2C interrupt clear
}

