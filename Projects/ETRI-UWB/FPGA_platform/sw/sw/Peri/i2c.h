/*----------------------------------------------------------
	File Name   : i2c.h
	Description : i2c API code
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/
#ifndef _I2C_H_
#define _I2C_H_
#include "sysinc.h"
void I2CInit(unsigned char prescaler);
int I2C1ByteWrite(unsigned char addr, unsigned char subAddr, unsigned char Data);
int I2C1ByteRead(unsigned char addr, unsigned char subAddr, unsigned char *data);
#endif 
