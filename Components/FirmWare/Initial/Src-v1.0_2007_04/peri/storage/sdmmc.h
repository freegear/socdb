/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: sdmmc.h
	Description	: SD/MMC Test for  SkyWalker
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef	__SDMMC_H__
#define	__SDMMC_H__

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

//#include "sysinc.h"
#include "sysdatadef.h"

/*
/////////////////////////////////////////////////////////
        MACRO DEFINITION
///////////////////////////////////////////////////////// 
*/

#define SD_API_STATUS_SUCCESS					(0x00000000L)
#define SD_API_STATUS_PENDING					(0x00000001L)
#define SD_API_STATUS_BUFFER_OVERFLOW			(0x00000001L)
#define SD_API_STATUS_DEVICE_BUSY				(0x00000002L)
#define SD_API_STATUS_UNSUCCESSFUL				(0x00000003L)
#define SD_API_STATUS_NOT_IMPLEMENTED			(0x00000004L)
#define SD_API_STATUS_ACCESS_VIOLATION			(0x00000005L)
#define SD_API_STATUS_INVALID_HANDLE			(0x00000006L)
#define SD_API_STATUS_INVALID_PARAMETER			(0x00000007L)
#define SD_API_STATUS_NO_SUCH_DEVICE			(0x00000008L)
#define SD_API_STATUS_INVALID_DEVICE_REQUEST	(0x00000009L)
#define SD_API_STATUS_NO_MEMORY					(0x0000000AL)
#define SD_API_STATUS_BUS_DRIVER_NOT_READY		(0x0000000BL)
#define SD_API_STATUS_DATA_ERROR				(0x0000000CL)
#define SD_API_STATUS_CRC_ERROR					(0x0000000DL)
#define SD_API_STATUS_INSUFFICIENT_RESOURCES	(0x0000000EL)
#define SD_API_STATUS_DEVICE_NOT_CONNECTED		(0x00000010L)
#define SD_API_STATUS_DEVICE_REMOVED			(0x00000011L)
#define SD_API_STATUS_DEVICE_NOT_RESPONDING		(0x00000012L)
#define SD_API_STATUS_CANCELED					(0x00000013L)
#define SD_API_STATUS_RESPONSE_TIMEOUT			(0x00000014L)
#define SD_API_STATUS_DATA_TIMEOUT				(0x00000015L)
#define SD_API_STATUS_DEVICE_RESPONSE_ERROR		(0x00000016L)
#define SD_API_STATUS_DEVICE_UNSUPPORTED		(0x00000017L)
#define SD_API_STATUS_SHUT_DOWN					(0x00000018L)

// macro to test for success
#define SD_API_SUCCESS(status)	((SD_API_STATUS)(status)>=0)

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

typedef long SD_API_STATUS;

typedef struct _SD_COMMAND_RESPONSE
{
	smtUint8 ResponseType;			// char ResponseType
	smtUint8 ResponseBuffer[17];	// char ResponseBuffer[17]
} SD_COMMAND_RESPONSE, *PSD_COMMAND_RESPONSE;

typedef struct _SD_BUS_REQUEST
{
	smtUint8 CommandCode;			// UCHAR CommandCode
	smtInt32 CommandArgument;		// DWORD CommandArgument
	SD_COMMAND_RESPONSE CommandResponse;
				
	smtUint32 NumBlocks;			// ULONG NumBlocks
	smtUint32 BlockSize;			// ULONG BlockSize
	smtUint8 *pBlockBluffer;		// PUCHAR pBlockBuffer
} SD_BUS_REQUSET, *PSD_BUS_REQUEST;

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

SD_API_STATUS SendCommand(smtUint16 cmd, smtUint32 arg, smtUint16 respType, smtBoolean bDataTransfer);
SD_API_STATUS GetCommandResponse(PSD_BUS_REQUEST pRequest);

SD_API_STATUS Set_SDI_Bus_Width_4Bit(void);
SD_API_STATUS Set_SDI_Bus_Width_1Bit(void);

SD_API_STATUS PollingReceive(PSD_BUS_REQUEST pRequest);
SD_API_STATUS PollingTransmit(PSD_BUS_REQUEST pRequest);

SD_API_STATUS Transfer(void);
SD_API_STATUS BusRequestHandler(smtInt32 dwSlot);	//(DWORD dwSlot);
SD_API_STATUS CardDetect(void);
SD_API_STATUS IsCardBusy(smtUint16 inData);
SD_API_STATUS SetClockRate(smtInt32 dwClockRate);	//(DWORD dwClockRate);
//SD_API_STATUS InterpretCapabilities(const TCHAR * pszRegistryPath);	//(LPCTSTR pszRegistryPath);
SD_API_STATUS InterpretCapabilities(const short int * pszRegistryPath);

SD_API_STATUS OnPowerUp(void);
SD_API_STATUS OnPowerDown(void);

SD_API_STATUS Initialize(void);
SD_API_STATUS DeInitialize(void);
SD_API_STATUS Stop_SDI_Clock(void);
SD_API_STATUS Start_SDI_Clock(void);

#endif /* __SDMMC_H__ */
