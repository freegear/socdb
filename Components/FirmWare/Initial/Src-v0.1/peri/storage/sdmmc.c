/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: sdmmc.c 
	Description	: SD/MMC test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
//#include "irq.h"

#include "sdmmc.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

// Edit your code

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

// Edit your code

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*----------------------------------------------------------
	Function name	: SD_Main()
	Prototype		: void SD_Main(void)
	Return			:
	Argument		:
	Comments		:
		SD/MMC Test main function
-----------------------------------------------------------*/
void SD_Main(void)
{
	smtInt32 dwSlot;
	PSD_BUS_REQUEST pRequset;
	
	// Initialize
	Initialize();
	
	OnPowerUp();
	
	// Get the SD device information (RCA, CSD...)
	// Setting pRequest
	BusRequestHandler(dwSlot);
	Transfer();
	
	OnPowerDown();
	DeInitialize();
}

/*----------------------------------------------------------
	Function name	: SendCommand()
	Prototype		: SD_API_STATUS SendCommand(...)
	Return			: SD API status
	Argument		:
		cmd				- command number
		arg				- command argument
		respType		- Response
		bDataTransfer	- Data R/W command identifier
	Comments		:
		Command만 보낸다.
		Data R/W의 경우 command만 보내고 data 처리 루틴은 별도로 존재
-----------------------------------------------------------*/
SD_API_STATUS SendCommand(smtUint16 cmd, smtUint32 arg, smtUint16 respType, smtBoolean bDataTransfer)
{
	return SD_API_STATUS_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: GetCommandResponse()
	Prototype		: SD_API_STATUS GetCommandResponse(PSD_BUS_REQUEST pRequest)
	Return			: SD API status
	Argument		:
			pRequest		- To use the PSD_BUS_REQUEST structure's read buffer
	Comments		:
			SD_COMMAND_RESPONSE는 ResponseType과 ResponseBuffer로 구성이 되어있다.
			ResponseType을 보고 ResponseBuffer에 해당 byte들을 채운다.
-----------------------------------------------------------*/
SD_API_STATUS GetCommandResponse(PSD_BUS_REQUEST pRequest)
{
	return SD_API_STATUS_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: Set_SDI_Bus_Width_4Bit()
	Prototype		: SD_API_STATUS SD_Main(void)
	Return			: SD API status
	Argument		:
	Comments		:
		SD Bus를 4Bit 모드로 설정
-----------------------------------------------------------*/
SD_API_STATUS Set_SDI_Bus_Width_4Bit(void)
{
	return SD_API_STATUS_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: Set_SDI_Bus_Width_1Bit()
	Prototype		: SD_API_STATUS Set_SDI_Bus_Width_1Bit(void)
	Return			: SD API status
	Argument		:
	Comments		:
		SD Bus를 1Bit 모드로 설정
-----------------------------------------------------------*/
SD_API_STATUS Set_SDI_Bus_Width_1Bit(void)
{
	return SD_API_STATUS_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: PollingReceive()
	Prototype		: SD_API_STATUS PollingReceive(PSD_BUS_REQUEST pRequest)
	Return			: SD API status
	Argument		:
		pRequest		- To use the PSD_BUS_REQUEST structure's read buffer
	Comments		:
		데이터를 받는 부분을 별도의 thread로 처리하기 때문에 interrupt로 할 필요 없음
		Command 완료 후 response를 확인한 후 데이터를 읽는다.
-----------------------------------------------------------*/
SD_API_STATUS PollingReceive(PSD_BUS_REQUEST pRequest)
{
	return SD_API_STATUS_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: PollingTransmit()
	Prototype		: SD_API_STATUS PollingTransmit(PSD_BUS_REQUEST pRequest)
	Return			: SD API status
	Argument		:
		pRequest		- To use the PSD_BUS_REQUEST structure's write buffer
	Comments		:
-----------------------------------------------------------*/
SD_API_STATUS PollingTransmit(PSD_BUS_REQUEST pRequest)
{
	return SD_API_STATUS_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: Transfer()
	Prototype		: SD_API_STATUS Transfer(void)
	Return			: SD API status
	Argument		:
	Comments		:
		BusRequesthandler()가 완료되면 뒷처리 작업을 한다. Response를
		분석하거나 data를 R/W 한다. 먼저 GetCommandResponse()를 호출하여
		response를 처리한 후 R/W에 따라서 해당하는 Polling R/W를 호출한다.
-----------------------------------------------------------*/
SD_API_STATUS Transfer(void)
{
	return SD_API_STATUS_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: BusRequestHandler()
	Prototype		: SD_API_STATUS BusRequestHandler(smtInt32 dwSlot)
	Return			: SD API status
	Argument		:
		dwSlot			- SD slot number
	Comments		:
		Command를 보내고 command 완료를 기다리는 루틴.
		SD 루틴의 시작이다. WinCE에서는 여러 개의 SD device가 존재한다는
		가정하에 slot이 존재한다.
		pRequest에는 command와 command에 해당하는 데이터버퍼 및 모든 변수들이
		설정이 되서 호출이 된다. Command가 완료되면 response 분석 및
		data R/W를 수행을 위해 Transfer()함수를 호출한다.
-----------------------------------------------------------*/
SD_API_STATUS BusRequestHandler(smtInt32 dwSlot)
{
	return SD_API_STATUS_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: CardDetect()
	Prototype		: SD_API_STATUS CardDetect(void)
	Return			: SD API status
	Argument		:
	Comments		:
		Card 삽입을 인식하는 함수
-----------------------------------------------------------*/
SD_API_STATUS CardDetect(void)
{
	return SD_API_STATUS_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: IsCardBusy()
	Prototype		: SD_API_STATUS IsCardBusy(smtUint16 inData)
	Return			: SD API status
	Argument		:
		inData	- Dummy argument
	Comments		:
		Command or data가 처리 중인지 체크 하는 함수
-----------------------------------------------------------*/
SD_API_STATUS IsCardBusy(smtUint16 inData)
{
	return SD_API_STATUS_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: SetClockRate()
	Prototype		: SD_API_STATUS SetClockRate(smtInt32 dwClockRate)
	Return			: SD API status
	Argument		:
		dwClockRate	- Setting clock value
	Comments		:
		SD clock은 400KHz ~ 25MHz까지 가능하며, 변경 가능해야 한다.
-----------------------------------------------------------*/
SD_API_STATUS SetClockRate(smtInt32 dwClockRate)
{
	return SD_API_STATUS_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: InterpretCapabilities()
	Prototype		: SD_API_STATUS InterpretCapabilities(LPCTSTR pszRegistryPath)
	Return			: SD API status
	Argument		:
		pszRegistryPath	- Structure to be stored the registry
	Comments		:
		Controller 함수를 bus 드라이버에 연결하는 함수 (WinCE에서만 사용)
-----------------------------------------------------------*/
//SD_API_STATUS InterpretCapabilities(const TCHAR *pszRegistryPath)	//(LPCTSTR pszRegistryPath)
SD_API_STATUS InterpretCapabilities(const short int *pszRegistryPath)
{
	return SD_API_STATUS_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: OnPowerUp()
	Prototype		: SD_API_STATUS OnPowerUp(void)
	Return			: SD API status
	Argument		:
	Comments		:
		SD/MMC Test main function
-----------------------------------------------------------*/
SD_API_STATUS OnPowerUp(void)
{
	return SD_API_STATUS_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: OnPowerDown()
	Prototype		: SD_API_STATUS OnPowerDown(void)
	Return			: SD API status
	Argument		:
	Comments		:
-----------------------------------------------------------*/
SD_API_STATUS OnPowerDown(void)
{
	return SD_API_STATUS_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: Initialize()
	Prototype		: SD_API_STATUS Initialize(void)
	Return			: SD API status
	Argument		:
	Comments		:
		S/W initialize function
-----------------------------------------------------------*/
SD_API_STATUS Initialize(void)
{
	return SD_API_STATUS_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: DeInitialize()
	Prototype		: SD_API_STATUS DeInitialize(void)
	Return			: SD API status
	Argument		:
	Comments		:
		S/W DeInitialize function
-----------------------------------------------------------*/
SD_API_STATUS DeInitialize(void)
{
	return SD_API_STATUS_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: Stop_SDI_Clock()
	Prototype		: SD_API_STATUS Stop_SDI_Clock(void)
	Return			: SD API status
	Argument		:
	Comments		:
		Stop the SD clock
-----------------------------------------------------------*/
SD_API_STATUS Stop_SDI_Clock(void)
{
	return SD_API_STATUS_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: Start_SDI_Clock()
	Prototype		: SD_API_STATUS Start_SDI_Clock(void)
	Return			: SD API status
	Argument		:
	Comments		:
		Start the SD clock
-----------------------------------------------------------*/
SD_API_STATUS Start_SDI_Clock(void)
{
	return SD_API_STATUS_SUCCESS;
}

