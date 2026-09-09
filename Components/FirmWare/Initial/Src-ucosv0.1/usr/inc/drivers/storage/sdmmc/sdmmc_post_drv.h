/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: sdmmc_post_drv.h
	Description		: 
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef __ATA_H__
#define __ATA_H__

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

//#include "../../../api/filesystem/sw_fs_typedefs.h"
#include "sw_fs_typedefs.h"
#include "sysinc.h"

/*
/////////////////////////////////////////////////////////
        TYPEDEF
///////////////////////////////////////////////////////// 
*/
 
typedef struct 
{
	void			(*ATAEnable)		(smtBoolean	on);
	void			(*ATASpinDown)		(smtInt32	seconds); 
	void			(*ATAPowerOff)		(smtBoolean	enable); 
	void			(*ATASleep)			(void);     
	bool			(*ATADiskIsActive)	(void); 
	smtInt32		(*ATAHardReset)		(void);
	smtInt32		(*ATASoftReset)		(void);
	smtInt32		(*ATAInit)			(void);
	smtInt32		(*ATAReadSectors)	(smtInt32 drive, smtUint32 start, 
										smtUint32 count, void *buf);
	smtInt32		(*ATAWriteSectors)	(smtInt32 drive, smtUint32 start, 
										smtUint32 count, void *buf);
	void			(*ATASpin)			(void);
	smtUint16*		(*ATAGetIdentify)	(void);   

} ATAFunction;   
 
/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////
*/

extern ATAFunction* ATAGetSDMMCFunction(void);


 
  
#endif
 
