/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: l2inf.h
	Description	: I2S test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

#ifndef _L3INF_H_
#define	_L3INF_H_

void	L3Delay(void);
int		L3Addr(unsigned char addr);
int		L3Data(unsigned char data);
void	L3Init(void);
int		UDA1341Init(void);

#endif