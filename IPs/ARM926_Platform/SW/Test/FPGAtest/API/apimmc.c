/*----------------------------------------------------------
	File Name   : apimmc.c 
	Description : MMCSD test code
	Created by  : SHMT SoC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "Commonmacro.h"
#include "lib.h"
#include "irq.h"
#include "mmcsd.h"
#include "global.h"
#include "dmac.h"
/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

// SDCON register
#define	SDreset			(0x1Ul)<<8 
#define ENCLK			(0x1Ul)<<0
// SDPRE register
#define	PrescalerVal		(0xfUl)<<0

// SDCmdArg
#define	CmdArg			(0xffffUl)<<0

// SDCmdCon
#define	BusyRsp			(0x1Ul)<<14
#define	NoCRCRsp		(0x1Ul)<<13
#define	AbortCmd		(0x1Ul)<<12
#define WithData		(0x1Ul)<<11
#define LongRsp			(0x1Ul)<<10
#define	WaitRsp			(0x1Ul)<<9
#define	CMST			(0x1Ul)<<8
#define	CmdIndex		(0x7fUl)<<0
#define	CmdIndexVal		0x40

// SDCmdSta
#define	RspCrc			(0x1Ul)<<12
#define	CmdSent			(0x1Ul)<<11
#define	CmdTout			(0x1Ul)<<10
#define RspFin			(0x1Ul)<<9
#define	CmdOn			(0x1Ul)<<8
#define	RspIndex		(0x1Ul)<<0

//SDRSP0
#define	Response0		(0xffffUl)<<0
//SDRSP1
#define	Response1		(0xffffUl)<<0
#define	RCRC7			(0xffUl)<<24

//SDRSP2
#define	Response2		(0xffffUl)<<0
//SDRSP3
#define	Response3		(0xffffUl)<<0

//SDDTimer Register
#define	DataTimer		(0x1Ul)<<0

//SDBSize Register
#define BlkSize			(0xfffUl)<<0

//SDDatCon
#define	DMASize			(0x3fUl)<<25
#define	MMCPlus			(0x1Ul)<<21
#define	TARSP			(0x1Ul)<<20
#define	RACMD			(0x1Ul)<<19
#define	BlkMode			(0x1Ul)<<17
#define	WideBus			(0x1Ul)<<16
#define	EnDMA			(0x1Ul)<<15
#define	DTST			(0x1Ul)<<14
#define	DatMode			(0x3Ul)<<12
#define	DataRx			(0x2Ul)<<12 
#define	DataTx			(0x3Ul)<<12
#define	DataNOP			(0x0Ul)<<12
#define	BlkNum			(0xfffUl)<<0

//SDDatCnt register
#define	BlkNumCnt		(0xfffUl)<<12
#define	BlkCnt			(0xfffUl)<<0

//SDDatSta
#define	NoBusy			(0x1Ul)<<11
#define	CrcSta			(0x1Ul)<<7
#define	DatCrc			(0x1Ul)<<6
#define	DatTout			(0x1Ul)<<5
#define	DatFin			(0x1Ul)<<4
#define	BusyFin			(0x1Ul)<<3
#define	BusyFin2		(0x1Ul)<<2
#define TxDatOn			(0x1Ul)<<1
#define	RxDatOn			(0x1Ul)<<0

//SDFSTA register
#define	FRST			(0x1Ul)<<16
#define	FFfail			(0x1Ul)<<14
#define	TFDET			(0x1Ul)<<13
#define	RFDET			(0x1Ul)<<12
#define	TFHalf			(0x1Ul)<<11
#define	TFEmpty			(0x1Ul)<<10
#define	RFFull			(0x1Ul)<<8
#define	RFHalf			(0x1Ul)<<7
#define	FFCNT			(0x3fUl)<<0

//SDIntMsk register
#define	AutoReadCompInt		(0x1Ul)<<18
#define	AutoCMD12ErrorInt	(0x1Ul)<<17
#define	AutoCMD18ErrorInt	(0x1Ul)<<16
#define	NoBusyInt		(0x1Ul)<<15
#define	RspCrcInt		(0x1Ul)<<14
#define	CmdSentInt		(0x1Ul)<<13
#define	CmdToutInt		(0x1Ul)<<12
#define	RspEndInt		(0x1Ul)<<11
#define	FFfailInt		(0x1Ul)<<10
#define	CrcStaInt		(0x1Ul)<<9
#define	DatCrcInt		(0x1Ul)<<8
#define	DatToutInt		(0x1Ul)<<7
#define	DatFinInt		(0x1Ul)<<6
#define	BusyFinInt		(0x1Ul)<<5
#define	BusyFin2Int		(0x1Ul)<<4
#define	TFHalfInt		(0x1Ul)<<3
#define	TFEmptyInt		(0x1Ul)<<2
#define	RFFullInt		(0x1Ul)<<1
#define	RFHalfInt		(0x1Ul)<<0	


#define	SD			1		
#define IRQ_MMC        		19

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
static void MMCSDsrHandler(smtUint32 IRQ);

void SDMMCReadSingle(smtUint32 BlockSize, smtUint32 BlockAddress);
void SDMMCWriteSingle(smtUint32 BlockSize, smtUint32 BlockAddress);
void SDMMCReadMultiple(smtBoolean CardType, smtUint32 BlockCount, smtUint32 BlockAddress);
void SDMMCWriteMultiple(smtBoolean CardType, smtUint32 BlockCount, smtUint32 BlockAddress);
void SDMMCEraseBlock(smtBoolean CardType, smtUint32 StartBlock, smtUint32 EndBlock);
void AbortCommandSend(void);
smtUint32 MMCTest(void);
smtUint32 SDMMCClockFreqSet(smtUint8 Prescaler);
smtUint32 SDMMCCmdSend(smtUint32 CmdArgValue, smtUint32 CmdConValue);
smtBoolean SDMMCInitialize(void);
smtUint32 SDMMCWaitRsp(void);
void MMCcheck(void);
void AutoReadMulti(void);
//------------simulation function----------------------------------------------------
void MMCReadSingleSim(smtUint32 BlockAddess);
void MMCWriteSingleSim(smtUint32 BlockAddress);
void SDWriteMultipleSim(smtUint32 BlockCount, smtUint32 BlockAddress);
void SDReadMultipleSim(smtUint32 BlockCount, smtUint32 BlockAddress);
void SDMMCWriteDMAtest(smtUint32 BlockAddress);
void SDMMCReadDMAtest(smtUint32 BlockAddress);
extern void DMACNoDescrp(smtUint8 channel, smtUint32 SrcAddr, smtUint32 DestAddr, smtUint16 TransSize, smtUint8 Width,smtBoolean SrcIncrease, smtBoolean DstIncrease);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
smtBoolean CardType;
//static volatile int interruptWaiting;o
smtUint32 SDDATA[128]={0,};
/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : MMCTest()
    Prototype       : smtUint32 MMCTest(void)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/
smtUint32 MMCTest(void)
{
	smtUint32 	BlockAddress = 0;
	smtUint32 	BlockCount = 0;
	smtUint32 	getchar = 0;

	// interrupt enable
	RequestIRQ(IRQ_MMC,MMCSDsrHandler);
	SMT_WRITE(SDIntMsk, 0xFFFFFFFF); //all interrupt enable 

	UART_printf(">> MMC/SD Initialize \n\r");

	SDMMCInitialize();

	while(1)
	{

		UART_printf("Press Read & Write Test \n\r");
		UART_printf("\n\r");
		UART_printf("1. Single Write Test \n\r");
		UART_printf("2. Single Read Test \n\r");
		UART_printf("3. Multiple Write Test \n\r");
		UART_printf("4. Multiple Read Test \n\r");
		UART_printf("5. SD Card Erase Test \n\r");
		UART_printf("6. Abort Command Test \n\r");
		UART_printf("7. SD/MMC Write(DMA) test \n\r");
		UART_printf("8. SD/MMC Read(DMA) test \n\r");

		getchar = UART_getch();	
		switch(getchar)
        	{
		        case 0x31:// Single Block Write Test
				SDMMCWriteSingle(512, 0);
				break;
        	
			case 0x32:// Single Block Read Test
				SDMMCReadSingle(512, 0);
				break;
		
			case 0x33:// Multiple Block Write Test
	    			SDMMCWriteMultiple(CardType, 2, 0);
				break;
		
			case 0x34:// Multiple Block Read Test 
				SDMMCReadMultiple(CardType, 2, 0);
				break;
		
			case 0x35:// SD Card Erase Test
				SDMMCEraseBlock(CardType, 0, 511);
				break;
		
			case 0x36:// Abort Command Test
				AbortCommandSend();
				break;

			case 0x37:// SD/MMC Write(DMA) test
				SDMMCWriteDMAtest(0);
				break;

			case 0x38:// SD/MMC Read(DMA) test
				SDMMCReadDMAtest(0);
				break;
		}
	}
	UART_printf("End of Test \n\r");
}

void SDMMCWriteDMAtest(smtUint32 BlockAddress)
{
	int i;

	for (i=0; i<128 ; i++)
	{
		SDDATA[i] = i+100;
	}
	SMT_WRITE(SDDatCon,0x001A0000);// Data NoOperation
	SMT_WRITE(SDFSTA, 0xFFFFFFFF); // FIFO reset
	DMACNoDescrp(0, *SDDATA, SDDAT, 512, 5, 1, 0);
	SMT_WRITE(SDBSize,511);
	SMT_WRITE(SDDatCon,DTST|WideBus|EnDMA|DataTx|RACMD|BlkMode|TARSP);// 4bit mode
	SDMMCCmdSend(BlockAddress, CMST|WaitRsp|(CmdIndexVal|24));
	while((SMT_READ(DMACSta(0))&0x00000001)!=0x00000001);
	SMT_WRITE(DMACSta(0),(SMT_READ(DMACSta(0))|EndInt)); // End Status clear

}
void SDMMCReadDMAtest(smtUint32 BlockAddress)
{
	int i;


	// Data Nooperation setting for FIFO Flush (because of DMA signal)
	SMT_WRITE(SDDatCon,0x001A0000);// Data NoOperation
	SMT_WRITE(SDFSTA, 0xFFFFFFFF); // FIFO reset

	DMACNoDescrp(0, SDDAT, *SDDATA, 512, 5, 0, 1);
	SMT_WRITE(SDBSize,511);


	// 기존 설정대로 bus width 설정후 start
	SMT_WRITE(SDDatCon,DTST|WideBus|EnDMA|DataRx|RACMD|BlkMode|TARSP);// 4bit mode

	//CMD17(READ_SINGLE_BLOCK)	
	SDMMCCmdSend(BlockAddress, CMST|WaitRsp|(CmdIndexVal|17));
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit

	while((SMT_READ(DMACSta(0))&0x00000001)!=0x00000001)

	SMT_WRITE(DMACSta(0),(SMT_READ(DMACSta(0))|EndInt)); // End Status clear

	for (i=0; i<128 ; i++)
		{
			UART_putchhex32(SDDATA[i]);
		}
}




/*-----------------------------------------------------------------------
    Function name   : SDMMCClockFreqSet()
    Prototype       : smtUint32 SDMMCClockFreqSet(smtUint8 Prescaler)
    Return          : 
    Argument        :
    Comments        : Prescaler Setting
-----------------------------------------------------------------------*/
smtUint32 SDMMCClockFreqSet(smtUint8 Prescaler)
{
	SMT_WRITE(SDPRE,Prescaler);
}
/*-----------------------------------------------------------------------
    Function name   : SDMMCCmdSend()
    Prototype       : smtUint32 SDMMCCmdSend(int CmdArgValue, int CmdConValue)
    Return          : 
    Argument        :
    Comments        : command argument setting and command control reg set

-----------------------------------------------------------------------*/

smtUint32 SDMMCCmdSend(smtUint32 CmdArgValue, smtUint32 CmdConValue)
{
	SMT_WRITE(SDCmdArg, CmdArgValue); 
	SMT_WRITE(SDCmdCon, CmdConValue);
  	//Command Sent Check(falling checking)
	while((SMT_READ(SDCmdSta)&CmdSent)!=CmdSent);
}

/*-----------------------------------------------------------------------
    Function name   : SDMMCWaitRsp()
    Prototype       : smtUint32 SDMMCWaitRsp(void)
    Return          : SDCmdSta Value
    Argument        :
    Comments        : Return a error-code

-----------------------------------------------------------------------*/
smtUint32 SDMMCWaitRsp(void)
{
	UART_printf("Wait Response or TimeOut \n\r ");
	while(((SMT_READ(SDCmdSta)&RspFin)!=RspFin)&&((SMT_READ(SDCmdSta)&CmdTout)!=CmdTout))
	UART_putchhex32(SMT_READ(SDCmdSta));
}

/*-----------------------------------------------------------------------
    Function name   : SDMMCInitialize()
    Prototype       : smtBoolean SDMMCInitialize(void)
    Return          : error code
    Argument        :
    Comments        : Return a error-code

-----------------------------------------------------------------------*/
smtBoolean SDMMCInitialize(void)
{
	smtUint32 	OCR_Register;
	smtUint32	CID_Register0;
	smtUint32	CID_Register1;
	smtUint32	CID_Register2;
	smtUint32	CID_Register3;
	smtUint32	CSD_Register0;
	smtUint32	CSD_Register1;
	smtUint32	CSD_Register2;
	smtUint32	CSD_Register3;
	smtUint32	CardStatus;
 	smtUint32	APP_CMD41arg=0x00000000;
	smtUint32	RCA_ADDRESS=0;	
	
	// Prescaler setting 
	SDMMCClockFreqSet(0xff);  // Low Frequecy  (spec. 400KHz)
	
	// Clock Enable
	SMT_WRITE(SDCON, ENCLK);
	
	// Interrupt Enable or Disable
	SMT_WRITE(SDIntMsk,0x00000000); // ALL interrupt disnable
	
	// CMD0 (GO_IDLE_STATE) No response Command 
	SDMMCCmdSend(0x00000000, CMST|(CmdIndexVal|0));
	UART_printf("---Present SDCmdSta Value: ");
	UART_putchhex16(SMT_READ(SDCmdSta));
	UART_printf("\n\r");
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit

	//------------ACMD41------------
APP_CMD41:	//CMD55
	UART_printf(">> Send CMD55 for SD/MMC type Check \n\r");
	SDMMCCmdSend(0x00000000, CMST|WaitRsp|(CmdIndexVal|55)); // 0x37 == 55
	UART_printf(">> Wait CMD55 Response \n\r");
	SDMMCWaitRsp();

		UART_getch();//////////////////////////////////////////

	UART_printf("---Present SDCmdSta Value: ");
	UART_putchhex16(SMT_READ(SDCmdSta));
	UART_printf("\n\r");
	if ((SMT_READ(SDCmdSta)&RspFin)==RspFin) // CMD55에 대한 응답이 있는 경우
	{
		
		SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
		UART_printf("---CMD55 Response(Card Status):  ");
		UART_putchhex32(SMT_READ(SDRSP0));
		UART_printf("\n\r");


		UART_printf(">> Send CMD41 (CMD55+CMD41)==ACMD41 \n\r");
		//CMD41
		SDMMCCmdSend(APP_CMD41arg, NoCRCRsp|CMST|WaitRsp|(CmdIndexVal|41));
		UART_printf(">> Wait CMD41 Response \n\r");
		SDMMCWaitRsp();


		UART_getch();//////////////////////////////////////////


		UART_printf("---Present SDCmdSta Value: ");
		UART_putchhex16(SMT_READ(SDCmdSta));
		UART_printf("\n\r");
		if  ((SMT_READ(SDCmdSta)&RspFin)==RspFin)
		{
			UART_printf("---Response(ACMD41 Card Status OCR register value):  ");
			UART_putchhex32(SMT_READ(SDRSP0));
			UART_printf("\n\r");
			SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
			if((SMT_READ(SDRSP0)&0x80000000)==0x00000000)	// 카드가 initialize가 되지 않았으면 커맨드 재전송
			{
				SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
				APP_CMD41arg= SDRSP0; // OCR값을 써주어야 busy flag가 clear됨
				goto APP_CMD41;
			}
			else
			{
				CardType =1; // SD Card
			}
		}
	
		else if ((SMT_READ(SDCmdSta)&CmdTout)==CmdTout) // CMD41에 대한 응답이 없는 경우
		{
			// response time out
			//CMD1
			UART_printf(">> Send CMD1 \n\r");
			SDMMCCmdSend(0x00000000, CMST|WaitRsp|NoCRCRsp|(CmdIndexVal|1));
			SDMMCWaitRsp();
		UART_getch();//////////////////////////////////////////
			if ((SMT_READ(SDCmdSta)&CmdTout)==CmdTout)
			{
				UART_printf("Check the Card Socket: Card Present Not Insert\n\r");
				return 0; // No card 
			}
			else
			{
				SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
				CardType=0; // MMC CardType
			}
		}

	}
	else if ((SMT_READ(SDCmdSta)&CmdTout)==CmdTout) // ACMD41에 대한 응답이 없는 경우
	{
		UART_getch();
		UART_printf("Response not receive\n\r");
		SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit

CMD1:		//CMD1
		UART_printf(">> Send CMD1 \n\r"); // MMC Check
		SDMMCCmdSend(0x00ff8000, NoCRCRsp|CMST|WaitRsp|(CmdIndexVal|1));
		// voltage range를 빼고 날리면 무조건 busy가 돌아오니 주의할 것
		SDMMCWaitRsp();
		UART_getch();//////////////////////////////////////////

		if ((SMT_READ(SDCmdSta)&CmdTout)==CmdTout)
		{
			UART_printf("Check the Card Socket: Card Present Not Insert\n\r");
			return 0; // No card 
		}
		else
		SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	}

	OCR_Register = SMT_READ(SDRSP0);
	UART_printf("	OCR_Register: ");
	UART_putchhex32(OCR_Register);
	UART_printf("\n\r");
	if ((OCR_Register & 0x80000000)==0x00000000) // Card Busy Check
	{
		UART_printf("Card is Busy \n\r");
		if (CardType ==1)
		goto APP_CMD41;
		else
		goto CMD1;
	}
	
	if (OCR_Register & 0x00000080) // Card Voltage Check
	{
		UART_printf("Dual Voltage Card \n\r");
	}
	else
	{
		UART_printf("High Voltage Card \n\r");
	}

	//CMD2
	UART_printf(">> Send CMD2 \n\r");
	SDMMCCmdSend(0x00000000, CMST|WaitRsp|LongRsp|(CmdIndexVal|2));
	SDMMCWaitRsp();
		UART_getch();//////////////////////////////////////////

	UART_putchhex16(SMT_READ(SDCmdSta));
	UART_printf("\n\r");

	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	CID_Register0 = SMT_READ(SDRSP0);
	CID_Register1 = SMT_READ(SDRSP1);
	CID_Register2 = SMT_READ(SDRSP2);
	CID_Register3 = SMT_READ(SDRSP3);
	UART_printf("---CID_Register0: ");
	UART_putchhex32(CID_Register0);
	UART_printf("\n\r");
	UART_printf("---CID_Register1: ");
	UART_putchhex32(CID_Register1);
	UART_printf("\n\r");
	UART_printf("---CID_Register2: ");
	UART_putchhex32(CID_Register2);
	UART_printf("\n\r");
	UART_printf("---CID_Register3: ");
	UART_putchhex32(CID_Register3);
	UART_printf("\n\r");

	UART_printf("---Manufacturer ID(MID): ");
	UART_putchhex((CID_Register0&0xFF000000)>>24);
	UART_printf("\n\r");
	UART_printf("---OEM/Application ID(OID): ");
	UART_putchhex16((CID_Register0&0x00ffff00)>>8);
	UART_printf("\n\r");

	if (CardType)// SD Card
	{	
		//CMD3
		UART_printf(">> Send CMD3 (Set RCA)\n\r");

		// RCA address를 물어봐야한다.
		// Argument를 0으로 하여 RCA를 물어본다.
		SDMMCCmdSend(0x00000000, CMST|WaitRsp|(CmdIndexVal|3));
		SDMMCWaitRsp();
		UART_getch();//////////////////////////////////////////

		SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
		UART_printf("---CardStatus:  ");
		RCA_ADDRESS =SMT_READ(SDRSP0);
		UART_putchhex32(RCA_ADDRESS);
		UART_printf("\n\r");
	}

	else // MMC card
	{
		UART_printf(">> Send CMD3 (Set RCA)\n\r");
		SDMMCCmdSend(0x00010000, CMST|WaitRsp|(CmdIndexVal|3));
		//임으로  RCA 발행
		SDMMCWaitRsp();
		UART_getch();//////////////////////////////////////////
		SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
		RCA_ADDRESS = 0x00010000;
		UART_printf("---CardStatus:  ");
		UART_putchhex32(SMT_READ(SDRSP0));
		UART_printf("\n\r");
	}


	//CMD9
	UART_printf(">> Send CMD9 (Send Card Specific Data)\n\r");

	SDMMCCmdSend(RCA_ADDRESS, CMST|WaitRsp|LongRsp|(CmdIndexVal|9));
	SDMMCWaitRsp();
		UART_getch();//////////////////////////////////////////
	CSD_Register0 = SMT_READ(SDRSP0);
	CSD_Register1 = SMT_READ(SDRSP1);
	CSD_Register2 = SMT_READ(SDRSP2);
	CSD_Register3 = SMT_READ(SDRSP3);
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit

	UART_printf("	CSD_Register0: ");
	UART_putchhex32(CSD_Register0);
	UART_printf("\n\r");

	UART_printf("	CSD_Register1: ");
	UART_putchhex32(CSD_Register1);
	UART_printf("\n\r");

	UART_printf("	CSD_Register2: ");
	UART_putchhex32(CSD_Register2);
	UART_printf("\n\r");

	UART_printf("	CSD_Register3: ");
	UART_putchhex32(CSD_Register3);
	UART_printf("\n\r");
//------------------------------------------ Refer to MMC/SD Specification-----------------------------
	UART_printf("	CSD_STRUCTURE :");
	if ((CSD_Register0 &0xc0000000)>>30 == 0x00) 
	UART_printf("	CSD version No. 1.0");
	else if ((CSD_Register0 &0xc0000000)>>30 == 0x01) 
	UART_printf("	CSD version No. 1.1");
	else if ((CSD_Register0 &0xc0000000)>>30 == 0x02) 
	UART_printf("	CSD version No. 1.2");
	else if ((CSD_Register0 &0xc0000000)>>30 == 0x03) 
	UART_printf("	CSD version located on EXT_CSD register");
	UART_printf("\n\r");
	


	if (!CardType)// for MMC Card
	{
		UART_printf("	MMC Card Spec Version :");
		if ((CSD_Register0 &0x3c000000)>>26 == 0x0000) 
		UART_printf("	MMC Support Spec. version 1.0-1.2");
		else if ((CSD_Register0 &0x3c000000)>>26 == 0x0001) 
		UART_printf("	MMC Support Spec. version 1.4");
		else if ((CSD_Register0 &0x3c000000)>>26 == 0x0002) 
		UART_printf("	MMC Support Spec. version 2.0-2.2");
		else if ((CSD_Register0 &0x3c000000)>>26 == 0x0003) 
		UART_printf("	MMC Support Spec. version 3.1-3.2-3.31");
		else if ((CSD_Register0 &0x3c000000)>>26 == 0x0004) 
		{	
			UART_printf("	MMC Support Spec. version 4.0-4.1");
			UART_printf("\n\r");
			UART_printf(">> Send CMD8 (Send Extend Card Specific Data)");
			//EXT_CSD is 512 byte => data line
			SDMMCCmdSend(RCA_ADDRESS, CMST|WaitRsp|(CmdIndexVal|8));
			UART_getch();//////////////////////////////////////////
			SDMMCWaitRsp();
			SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
		}
		UART_printf("\n\r");
	}
	UART_printf("	TAAC(Data Read Access Time1 :");
	UART_putchhex((CSD_Register0&0x00FF0000)>>16);
	UART_printf("\n\r");
	
	UART_printf("	NSAC(Data Read Access Time2 in CLK cycle (NSAC*100) :");
	UART_putchhex((CSD_Register0&0x0000FF00)>>8);
	UART_printf("\n\r");

	UART_printf("	TRANS_SPEED (Max. Bus Clock Frequency :");
	UART_putchhex((CSD_Register0&0x000000FF));
	UART_printf("\n\r");

	UART_printf("	CCC (Card Command Class) :");
	UART_putchhex((CSD_Register1&0xFFF00000)>>20);
	UART_printf("\n\r");

	UART_printf("	READ_BL_LEN (Max. Read Block length) :");
	UART_putchhex((CSD_Register1&0x000F0000)>>16);
	UART_printf("\n\r");
	UART_printf("	READ_BL_PARTIAL (Partial Blocks for Read allowed) :");
	UART_putchhex((CSD_Register1&0x00008000)>>15);
	UART_printf("\n\r");
	UART_printf("	WRITE_BLK_MISALIGN (Write block misalignment) :");
	UART_putchhex((CSD_Register1&0x00004000)>>14);
	UART_printf("\n\r");
	UART_printf("	READ_BLK_MISALIGN (Read block misalignment) :");
	UART_putchhex((CSD_Register1&0x00002000)>>13);
	UART_printf("\n\r");
	UART_printf("	DSR_IMP (DSR_implement) :");
	UART_putchhex((CSD_Register1&0x00001000)>>12);
	UART_printf("\n\r");
	UART_printf("	C_SIZE (Device size) :");
	UART_putchhex16((((CSD_Register1&0x000003FF)<<2)+((CSD_Register2&0xc0000000)>>30)));
	UART_printf("\n\r");

	UART_printf("	VDD_R_CURR_MIN (Max. read current @ VDD min) :");
	UART_putchhex((CSD_Register2&0x38000000)>>27);
	UART_printf("\n\r");

	UART_printf("	VDD_R_CURR_MAX (Max. read current @ VDD max) :");
	UART_putchhex((CSD_Register2&0x07000000)>>24);
	UART_printf("\n\r");

	UART_printf("	VDD_W_CURR_MIN (Max. write current @ VDD min) :");
	UART_putchhex((CSD_Register2&0x00E00000)>>21);
	UART_printf("\n\r");

	UART_printf("	VDD_W_CURR_MAX (Max. write current @ VDD max) :");
	UART_putchhex((CSD_Register2&0x001C0000)>>18);
	UART_printf("\n\r");

	UART_printf("	C_SIZE_MULT (Device size multiplier) :");
	UART_putchhex((CSD_Register2&0x00038000)>>15);
	UART_printf("\n\r");
	if (CardType)
	{
	UART_printf("	ERASE_BLK_EN (Erase single block enable) :");
	UART_putchhex((CSD_Register2&0x00004000)>>14);
	UART_printf("\n\r");
	UART_printf("	SECTOR_SIZE (Erase sector size) :");
	UART_putchhex((CSD_Register2&0x00000f80)>>7);
	UART_printf("\n\r");
	UART_printf("	WP_GRP_SIZE (Write protect group size) :");
	UART_putchhex((CSD_Register2&0x0000007f));
	UART_printf("\n\r");
	}
	else
	{
	UART_printf("	ERASE_GRP_SIZE (Device size multiplier) :");
	UART_putchhex((CSD_Register2&0x00007c00)>>10);
	UART_printf("\n\r");

	UART_printf("	ERASE_GRP_MULT (Device size multiplier) :");
	UART_putchhex((CSD_Register2&0x000003e0)>>5);
	UART_printf("\n\r");
	UART_printf("	WP_GRP_SIZE (Write protect group size) :");
	UART_putchhex((CSD_Register2&0x0000001f));

	}

	UART_printf("	WP_GRP_ENABLE (Write protect group enable) :");
	UART_putchhex((CSD_Register3&0x80000000)>>31);
	UART_printf("\n\r");
	if (!CardType)
	{
	UART_printf("	DEFAULT_ECC (Manufacturer default ECC) :");
	UART_putchhex((CSD_Register3&0x60000000)>>29);
	UART_printf("\n\r");
	}
	UART_printf("	R2W_FACTOR(Write speed factor) :");
	UART_putchhex((CSD_Register3&0x1C000000)>>26);
	UART_printf("\n\r");
	UART_printf("	WRITE_BL_LEN (Max. write data block length) :");
	UART_putchhex((CSD_Register3&0x03C00000)>>22);
	UART_printf("\n\r");
	UART_printf("	WRITE_BL_PARTIAL (Partial blocks for wirte allowed) :");
	UART_putchhex((CSD_Register3&0x00200000)>>21);
	UART_printf("\n\r");
	if (!CardType)
	{
	UART_printf("	CONTENT_PROT_APP (Content protection application) :");
	UART_putchhex((CSD_Register3&0x00010000)>>16);
	UART_printf("\n\r");
	}
	UART_printf("	FILE_FORMAT_GRP (File format group) :");
	UART_putchhex((CSD_Register3&0x00008000)>>15);
	UART_printf("\n\r");
	UART_printf("	COPY (Copy flag OTP) :");
	UART_putchhex((CSD_Register3&0x00004000)>>14);
	UART_printf("\n\r");
	UART_printf("	PERM_WRITE_PROTECT (Permanent write protection) :");
	UART_putchhex((CSD_Register3&0x00002000)>>13);
	UART_printf("\n\r");
	UART_printf("	TMP_WRITE_PROTECT (Temporary write protection) :");
	UART_putchhex((CSD_Register3&0x00001000)>>12);
	UART_printf("\n\r");
	UART_printf("	FILE_FORMAT (File format) :");
	UART_putchhex((CSD_Register3&0x00000C00)>>10);
	UART_printf("\n\r");
	if (!CardType)
	{
	UART_printf("	ECC (ECC code) :");
	UART_putchhex((CSD_Register3&0x00000300)>>8);
	UART_printf("\n\r");
	}



	





//---------------------------------------------------------------------------------------------------
	// CMD7
	// ADDRESS 지정 sd의 경우 물어본 address에 대한 응답을 그대로 넣는다.
	UART_printf(">> Send CMD7 (Send Select Card)\n\r");
	SDMMCCmdSend(RCA_ADDRESS, CMST|WaitRsp|(CmdIndexVal|7));
	SDMMCWaitRsp();
		UART_getch();//////////////////////////////////////////
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	UART_printf("---CardStatus:  ");
	UART_putchhex32(SMT_READ(SDRSP0));
	UART_printf("\n\r");
	UART_getch();


/*
	// ACMD13 SD Status register READ 
	if (CardType)
	{
		UART_printf(">> Send CMD55 for SD Status Register Read \n\r");
		SDMMCCmdSend(0x00000000, CMST|WaitRsp|(CmdIndexVal|55)); // 0x37 == 55
		UART_printf(">> Wait CMD55 Response \n\r");
		SDMMCWaitRsp();
		SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
		UART_printf("---CMD55 Response(Card Status):  ");
		UART_putchhex32(SMT_READ(SDRSP0));
		UART_printf("\n\r");


		// Data Nooperation setting for FIFO Flush (because of DMA signal)
		SMT_WRITE(SDDatCon,0x001A0000);// Data NoOperation
		SMT_WRITE(SDFSTA, 0xFFFFFFFF); // FIFO reset

		// 기존 설정대로 bus width 설정후 start
		SMT_WRITE(SDDatCon,DTST|DataRx|RACMD|BlkMode|TARSP);// 4bit mode
		UART_printf(">> Send CMD13 for SD Status Register Read (ACMD13) \n\r");
		SDMMCCmdSend(0x00000000, CMST|WaitRsp|(CmdIndexVal|13));
		UART_printf(">> Wait CMD13 Response \n\r");
		SDMMCWaitRsp();

		SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
		UART_printf("---CMD13 Response(Card Status):  ");
		UART_putchhex32(SMT_READ(SDRSP0));
		UART_printf("\n\r");
		UART_getch();//////////////////////////////////////////


	while((SMT_READ(SDFSTA)&0x1000)!=0x1000);
	while((SMT_READ(SDFSTA)&0x100)!=0x100);
		int i;
		for (i=1; i<129 ; i++)
		{
		UART_printf("READ DATA : ");
		UART_putchhex32(SMT_READ(SDDAT));
		UART_printf("\n\r");

		UART_printf("FIFO STATUS: ");
		UART_putchhex32(SMT_READ(SDFSTA));
		UART_printf("\n\r");

		UART_printf("DATA COUNTER: ");
		UART_putchhex32(SMT_READ(SDDatCnt));
		UART_printf("\n\r");
		UART_getch();	
		}

	}
*/

	// Card Bus Width Select
	// 8bit
	// 4bit를 지원한다면 
	// 1bit
	if (CardType)
	{
		// SD CARD 는 ACMD6을 보내 Bus Width를 보내야 된다.
		UART_printf(">> Send CMD55 (APP_CMD)\n\r");
		SDMMCCmdSend(RCA_ADDRESS, CMST|WaitRsp|(CmdIndexVal|55));
		SDMMCWaitRsp();
		UART_getch();//////////////////////////////////////////
		SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	}
	//CMD6(SWITCH) select bus width
	UART_printf(">> Send CMD6 (Switch CMD)\n\r");
	UART_printf("4Bit DataWidth transmit\n\r");
	if (CardType)
		{SDMMCCmdSend(0x00000002, CMST|WaitRsp|(CmdIndexVal|6));}
	//	{SDMMCCmdSend(0x00000000, CMST|WaitRsp|(CmdIndexVal|6));}// 1bit Bus
	else
	//	{SDMMCCmdSend(0x03B70200, CMST|WaitRsp|(CmdIndexVal|6));}// 8Bit bus
		{SDMMCCmdSend(0x03B70100, CMST|WaitRsp|(CmdIndexVal|6));}// 4Bit bus
	//	{SDMMCCmdSend(0x03B70000, CMST|WaitRsp|(CmdIndexVal|6));}// 1Bit bus
	SDMMCWaitRsp();
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	UART_printf("---CardStatus:  ");
	UART_putchhex32(SMT_READ(SDRSP0));
	UART_printf("\n\r");
	UART_getch();
	

	// HS Clock Mode Setting
		//CMD6(SWITCH) select HS_TIMING
		 // MMC card HS Clock Mode
			UART_printf(">> Send CMD6 (Switch CMD)\n\r");
			UART_printf("\n\r");
			if (CardType)
			SDMMCCmdSend(0x80ffff01, CMST|WaitRsp|(CmdIndexVal|6));
			else
			SDMMCCmdSend(0x03B90100, CMST|WaitRsp|(CmdIndexVal|6)); // HS_TIMING Bit Set
			SDMMCWaitRsp();
			UART_getch();//////////////////////////////////////////
			SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
			UART_printf("---CardStatus:  ");
			UART_putchhex32(SMT_READ(SDRSP0));
			UART_printf("\n\r");
			UART_getch();
	
	UART_printf(">> Clock Frequecy -> High \n\r");
	SDMMCClockFreqSet(0x01);

	
	// Block length setting
	if (!CardType)
	{
		//CMD16(Set Block length)
		UART_printf("Block Length setting  512byte block\n\r");
		SDMMCCmdSend(512, CMST|WaitRsp|0x50);
		
		SDMMCWaitRsp();
		UART_getch();//////////////////////////////////////////
		SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
		UART_getch();
		UART_printf("	CardStatus:  ");
		UART_putchhex32(SMT_READ(SDRSP0));
		UART_printf("\n\r");
	}


	return 0;
}
/*-----------------------------------------------------------------------
    Function name   : SDMMCReadSingle()
    Prototype       : void SDMMCReadSingle(smtUint32 BlockSize, smtUint32 BlockAddress)
    Return          : 
    Argument        :
    Comments        :  MMC Single Block Read function
-----------------------------------------------------------------------*/
void SDMMCReadSingle(smtUint32 BlockSize, smtUint32 BlockAddress)
{
	int i;
	//Block Size Setting
	//SMT_WRITE(SDBSize,511);
	SMT_WRITE(SDBSize,(BlockSize-1));


	// Data Nooperation setting for FIFO Flush (because of DMA signal)
	SMT_WRITE(SDDatCon,0x001A0000);// Data NoOperation
	SMT_WRITE(SDFSTA, 0xFFFFFFFF); // FIFO reset

	// 기존 설정대로 bus width 설정후 start
	SMT_WRITE(SDDatCon,DTST|WideBus|DataRx|RACMD|BlkMode|TARSP);// 4bit mode

	//CMD17(READ_SINGLE_BLOCK)	
	SDMMCCmdSend(BlockAddress, CMST|WaitRsp|(CmdIndexVal|17));
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	
	while((SMT_READ(SDFSTA)&0x1000)!=0x1000);
	while((SMT_READ(SDFSTA)&0x100)!=0x100);

	for (i=1; i<129 ; i++)
	{
		UART_printf("READ DATA : ");
		UART_putchhex32(SMT_READ(SDDAT));
		UART_printf("\n\r");

		UART_printf("FIFO STATUS: ");
		UART_putchhex32(SMT_READ(SDFSTA));
		UART_printf("\n\r");

		UART_printf("DATA COUNTER: ");
		UART_putchhex32(SMT_READ(SDDatCnt));
		UART_printf("\n\r");
		UART_getch();	
	}
	while((SMT_READ(SDDatSta)&0x00000010) !=0x00000010)
	{
		UART_printf("	DATA Status Register:  ");
		UART_putchhex32(SMT_READ(SDDatSta));
		UART_printf("\n\r");
	}
	UART_printf("	DATA Status Register:  ");
	UART_putchhex32(SMT_READ(SDDatSta));
	UART_printf("\n\r");

}
/*-----------------------------------------------------------------------
    Function name   : SDMMCWriteSingle()
    Prototype       : smtUint32 MMCWriteSingle(void)
    Return          : 
    Argument        :
    Comments        :  MMC Single Block Write function
-----------------------------------------------------------------------*/
void SDMMCWriteSingle(smtUint32 BlockSize,  smtUint32 BlockAddress)
{
	int i;
	//Block Size Setting
//	SMT_WRITE(SDBSize,511);
	SMT_WRITE(SDBSize,(BlockSize-1));
	SMT_WRITE(SDDatCon,DTST|WideBus|DataTx|RACMD|BlkMode|TARSP);// 4bit mode

	while(SMT_READ(SDFSTA)&0x2000 != 0x2000);

	for (i=1; i<127 ; i++)
	{
		SMT_WRITE(SDDAT,i);
		UART_putchhex32(SMT_READ(SDFSTA));
		UART_printf("\n\r");
	}

	SDMMCCmdSend(BlockAddress, CMST|WaitRsp|(CmdIndexVal|24));

	while((SMT_READ(SDFSTA)&0x800) != 0x800)
	{
		UART_printf("	FIFO Cnt:  ");
		UART_putchhex32(SMT_READ(SDFSTA));
		UART_printf("\n\r");
	}
	SMT_WRITE(SDDAT,127);
	SMT_WRITE(SDDAT,128);

	UART_putchhex32(SMT_READ(SDFSTA));
	UART_printf("\n\r");
	UART_printf("	DATA Cnt:  ");
	UART_putchhex32(SMT_READ(SDDatCnt));
	UART_printf("\n\r");

	SDMMCWaitRsp();
	
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit

	UART_printf("	CardStatus:  ");
	UART_putchhex32(SMT_READ(SDRSP0));
	UART_printf("\n\r");

	
	while(SMT_READ(SDDatCnt)!=0x00000000);
	{
		UART_printf("	DatCount Register:  ");
		UART_putchhex32(SMT_READ(SDDatCnt));
		UART_printf("\n\r");
	}
	UART_printf("	DATA Status Register:  ");
	UART_putchhex32(SMT_READ(SDDatSta));
	UART_printf("\n\r");
	UART_getch();

	while((SMT_READ(SDDatSta)&0x00000010) !=0x00000010)
	{
		UART_printf("	DATA Status Register:  ");
		UART_putchhex32(SMT_READ(SDDatSta));
		UART_printf("\n\r");
	}
	SMT_WRITE(SDDatSta,0xFFFFFFFF);// SDDatSta register Clear
	UART_printf("	DATA Status Register:  ");
	UART_putchhex32(SMT_READ(SDDatSta));
	UART_printf("\n\r");
	UART_printf("FIFO STATUS: ");
	UART_putchhex32(SMT_READ(SDFSTA));
	UART_printf("\n\r");

	UART_printf("Single Block Write Command Transmit : CMD24\n\r");

}
/*-----------------------------------------------------------------------
    Function name   : SDMMCReadMultiple()
    Prototype       : void SDMMCReadMultiple(smtUint32 BlockCount, smtUint32 BlockAddress)
    Return          : 
    Argument        :
    Comments        :  MMC Multiple Block Read function
-----------------------------------------------------------------------*/
void SDMMCReadMultiple(smtBoolean CardType, smtUint32 BlockCount, smtUint32 BlockAddress)
{

	int i,j;
	SMT_WRITE(SDBSize,511);

	SMT_WRITE(SDDatCon,0x001A0000);// Data NoOperation
	SMT_WRITE(SDFSTA, 0xFFFFFFFF); // FIFO reset
		UART_printf("   FIFO Status : ");
		UART_putchhex32(SMT_READ(SDFSTA));
		UART_printf("\n\r");
	SMT_WRITE(SDDatCon,DTST|WideBus|DataRx|RACMD|BlkMode|TARSP|0x01);// 4bit mode

	//CMD18(READ_MULTIPLE_BLOCK)
	SDMMCCmdSend(BlockAddress, CMST|WaitRsp|(CmdIndexVal|18));
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit

	for (j=0; j<BlockCount; j++)
	{
		while(SMT_READ(SDFSTA)&0x1000 != 0x1000)//;// FIFO Rx Available
		{
		UART_printf("   FIFO Status : ");
		UART_putchhex32(SMT_READ(SDFSTA));
		UART_printf("\n\r");
		}
		while((SMT_READ(SDFSTA)&0x100)!=0x100); // fifo full 시에 read

		for (i=1; i<129 ; i++)
		{
		UART_printf("   DATA : ");
		UART_putchhex32(SMT_READ(SDDAT));
		UART_printf("\n\r");

		UART_printf("   FIFO Status : ");
		UART_putchhex32(SMT_READ(SDFSTA));
		UART_printf("\n\r");

		UART_printf("    Data counter register : ");
		UART_putchhex32(SMT_READ(SDDatCnt));
		UART_printf("\n\r");
	UART_getch();
		}
	UART_printf("   DATA Status : ");
		UART_putchhex32(SMT_READ(SDDatSta));
		UART_printf("\n\r");
		UART_getch();

	}

}
/*-----------------------------------------------------------------------
    Function name   : SDMMCWriteMultiple()
    Prototype       : smtUint32 SDWriteMultiple(int BlockCount, int BlockSize)
    Return          : 
    Argument        :
    Comments        :  MMC Multiple Block Write Function
-----------------------------------------------------------------------*/
void SDMMCWriteMultiple(smtBoolean CardType, smtUint32 BlockCount, smtUint32 BlockAddress)
{
	//CardType 0: MMC Card 1: SD Card...

	int i,j;
	SMT_WRITE(SDBSize,511); // One block Size is 512Byte

	UART_printf("SDBSize :");
	UART_putchhex32(SMT_READ(SDBSize));
	UART_printf("\n\r");

	SMT_WRITE(SDDatCon,0x001B0000);// Data NoOperation
	SMT_WRITE(SDFSTA, 0xFFFFFFFF); // FIFO reset


	if (CardType) // SD Type Card
	{//ACMD22 (SEND_NUM_WR_BLOCKS)
		SDMMCCmdSend(0x00000000, CMST|WaitRsp|(CmdIndexVal|55));
		UART_putchhex32(SMT_READ(SDCmdSta));
		SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit

		SDMMCCmdSend(BlockCount, CMST|WaitRsp|(CmdIndexVal|22));
		UART_putchhex32(SMT_READ(SDCmdSta));
		SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	}
	else		// MMC Type Card
	{
		//CMD23(SET_BLOCK_COUNT) 전송할 블록의 총 갯수를 설정
		SDMMCCmdSend(BlockCount, CMST|WaitRsp|(CmdIndexVal|23));
		UART_putchhex32(SMT_READ(SDCmdSta));

		SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	}

	SMT_WRITE(SDDatCon,DTST|WideBus|DataTx|RACMD|BlkMode|TARSP|0x01);// 4bit mode

	while(SMT_READ(SDFSTA)&0x2000 != 0x2000); // Tx Available Check
	
	for (i=1; i<127 ; i++)
	{
		SMT_WRITE(SDDAT,i);
		UART_putchhex32(SMT_READ(SDFSTA));
		UART_printf("\n\r");
	}

	SDMMCCmdSend(BlockCount, CMST|WaitRsp|(CmdIndexVal|25));

	while((SMT_READ(SDFSTA)&0x800) != 0x800)
	{
		UART_printf("	FIFO Cnt:  ");
		UART_putchhex32(SMT_READ(SDFSTA));
		UART_printf("\n\r");
		UART_printf("	DATA Cnt:  ");
		UART_putchhex32(SMT_READ(SDDatCnt));
		UART_printf("\n\r");
		
	}
	SMT_WRITE(SDDAT,127);
	SMT_WRITE(SDDAT,128);
	
	SDMMCWaitRsp();
	
	
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit

	UART_printf("	CardStatus:  ");
	UART_putchhex32(SMT_READ(SDRSP0));
	UART_printf("\n\r");

	UART_getch();
	
	while((SMT_READ(SDDatCnt)&0x00000FFF)!= 0)
	{
		UART_printf("	DatCount Register:  ");
		UART_putchhex32(SMT_READ(SDDatCnt));
		UART_printf("\n\r");
	}
	UART_printf("	DATA Status Register:  ");
	UART_putchhex32(SMT_READ(SDDatSta));
	UART_printf("\n\r");
	UART_getch();

//	for (j=0 ; j<(BlockCount-1) ; j++)
	{	
	//	for (i=1; i<127 ; i++)
		for (i=129; i<255 ; i++)
		{
			SMT_WRITE(SDDAT,i);
		}
		while((SMT_READ(SDFSTA)&0x800) != 0x800)
		{
			UART_putchhex32(SMT_READ(SDFSTA));
		}
		SMT_WRITE(SDDAT,255);
		SMT_WRITE(SDDAT,256);
	}

	while(SMT_READ(SDDatCnt)!=0x00000000);
	while((SMT_READ(SDDatSta)&0x00000010) !=0x00000010);
	SMT_WRITE(SDDatSta,0xFFFFFFFF);// SDDatSta register Clear

	UART_printf("Multiple Block Write Done\n\r");

}
/*-----------------------------------------------------------------------
    Function name   : SDMMCEraseBlock()
    Prototype       : smtUint32 SDMMCEraseBlock(Boolean CardType, int StartBlock, int EndBlock)
    Return          : 
    Argument        :
    Comments        :  SDMMC Erase Block Function
-----------------------------------------------------------------------*/
void SDMMCEraseBlock(smtBoolean CardType, smtUint32 StartBlock, smtUint32 EndBlock)
{

	if (CardType)
	{
		//CMD32(ERASE_WR_BLOCK_START)
		SDMMCCmdSend(StartBlock, CMST|WaitRsp|(CmdIndexVal|32));

		while((SMT_READ(SDCmdSta)&0x200)!=0x200);
		SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
		UART_printf("	Response0 Register:  ");
		UART_putchhex32(SMT_READ(SDRSP0));
		UART_printf("\n\r");

		//CMD33(ERASE_WR_BLOCK_END)
		SDMMCCmdSend(EndBlock, CMST|WaitRsp|(CmdIndexVal|33));
		//Command Sent Check
		while((SMT_READ(SDCmdSta)&0x200)!=0x200);
		SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
		UART_printf("	Response0 Register:  ");
		UART_putchhex32(SMT_READ(SDRSP0));
		UART_printf("\n\r");
	}
	else
	{	//CMD35(ERASE_GROUP_START)
		SDMMCCmdSend(StartBlock, CMST|WaitRsp|(CmdIndexVal|35));
		//Command Sent Check
		while((SMT_READ(SDCmdSta)&0x800)!=0x800);
		SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit

		//CMD36(ERASE_GROUP_END)
		SDMMCCmdSend(EndBlock, CMST|WaitRsp|(CmdIndexVal|36));
		//Command Sent Check
		while((SMT_READ(SDCmdSta)&0x800)!=0x800);
		SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	}	
	//CMD38(ERASE)
	SDMMCCmdSend(0x00000000, CMST|WaitRsp|BusyRsp|(CmdIndexVal|38));
		
	//Command Sent Check
	while((SMT_READ(SDCmdSta)&0x800)!=0x800);
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	// R1b의 응답으로 busy check를 해야한다.
}


void MMCcheck(void)
{

	SMT_WRITE(SDPRE, 0x10);
	//Clock Enable
	SMT_WRITE(SDCON, 0x01);
	//Interrupt Enable
//	SMT_WRITE(SDIntMsk, 0xFFFFFFFF); //all interrupt enable 
	SMT_WRITE(SDIntMsk, 0x00000000); //all interrupt disable 
	RequestIRQ(IRQ_MMC,MMCSDsrHandler);

	//CMD1 Send 

MMC_CMD1:
	SDMMCCmdSend(0x00000000, CMST|WaitRsp|NoCRCRsp|(CmdIndexVal|1));
		
	while(((SMT_READ(SDCmdSta)&0x200)!=0x200)&&((SMT_READ(SDCmdSta)&0x400)!=0x400));
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	if ((SMT_READ(SDRSP0) & 0x80000000)==0x00000000)
	{
		goto MMC_CMD1;
	}
	SDMMCCmdSend(0x00000000, CMST|WaitRsp|LongRsp|(CmdIndexVal|2));
	while(((SMT_READ(SDCmdSta)&0x200)!=0x200)&&((SMT_READ(SDCmdSta)&0x400)!=0x400));
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	SDMMCCmdSend(0x00010000, CMST|WaitRsp|(CmdIndexVal|3));
	while(((SMT_READ(SDCmdSta)&0x200)!=0x200)&&((SMT_READ(SDCmdSta)&0x400)!=0x400));
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	SDMMCCmdSend(0x00010000, CMST|WaitRsp|(CmdIndexVal|7));
	while(((SMT_READ(SDCmdSta)&0x200)!=0x200)&&((SMT_READ(SDCmdSta)&0x400)!=0x400));
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	SDMMCCmdSend(0x03B70100, CMST|WaitRsp|0x46);
	//SDMMCCmdSend(0x03B70200, CMST|WaitRsp|0x46);// 0: 1bit 1: 4bit 2: 8bit
	while(((SMT_READ(SDCmdSta)&0x200)!=0x200)&&((SMT_READ(SDCmdSta)&0x400)!=0x400));
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit

SDWriteMultipleSim(2,0);
SDReadMultipleSim(2,0);
AutoReadMulti();
//SDMMCWriteDMAtest(0);


while(1);

}

void AbortCommandSend(void)
{
	SMT_WRITE(SDCmdArg, 0x00000000); 
	SMT_WRITE(SDCmdCon, CMST|WaitRsp|0x4C);
	while((SMT_READ(SDCmdSta)&0x200)!=0x200);
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	UART_printf("Response0 STATUS: ");
	UART_putchhex32(SMT_READ(SDRSP0));
	UART_printf("\n\r");
}


/*-----------------------------------------------------------------------
    Function name   : MMCSDsr()
    Prototype       : static void MMCSDsr(smtUint32 IRQ)
    Return          : 
    Argument        :
    Comments        :  MMC interrupt handle function
-----------------------------------------------------------------------*/
static void MMCSDsrHandler(smtUint32 IRQ)
{
	UART_printf("SDCmdSta register: ");
	UART_putchhex32(SMT_READ(SDCmdSta));
	UART_printf("\n\r");
	UART_printf("SDDatSta register: ");
	UART_putchhex32(SMT_READ(SDDatSta));
	UART_printf("\n\r");
	UART_printf("SDFSTA register: ");
	UART_putchhex32(SMT_READ(SDFSTA));
	UART_printf("\n\r");
}
//////////////////////////////////////////////////////////////////////////
//                      SIMULATION CODE
//////////////////////////////////////////////////////////////////////////
void SDWriteMultipleSim(smtUint32 BlockCount, smtUint32 BlockAddress)
{
	int i,j;
	SMT_WRITE(SDBSize,511); // One block Size is 512Byte

	SMT_WRITE(SDDatCon,0x001A0000);// Data NoOperation
	SMT_WRITE(SDFSTA, 0xFFFFFFFF); // FIFO reset


	//CMD23(SET_BLOCK_COUNT)
	SDMMCCmdSend(BlockCount, CMST|WaitRsp|(CmdIndexVal|23));
	//Command Sent Check
	while((SMT_READ(SDCmdSta)&0x200)!=0x200);

	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	SMT_WRITE(SDDatCon,0x003B7001);// MMC 8bit mode
//	SMT_WRITE(SDDatCon,0x001B7001);// 4bit mode
	while(SMT_READ(SDFSTA)&0x2000 != 0x2000); // Tx Available Check
	

	for (i=1; i<127 ; i++)
	{
	SMT_WRITE(SDDAT,i);
	}
	SDMMCCmdSend(BlockAddress, CMST|WaitRsp|0x59);

	while((SMT_READ(SDFSTA)&0x800) != 0x800);
	SMT_WRITE(SDDAT,127);
	SMT_WRITE(SDDAT,128);
	while((SMT_READ(SDCmdSta)&0x800)!=0x800);
	
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	
	while((SMT_READ(SDDatCnt)&0x00000FFF)!= 511);

//	for (j=0 ; j<(BlockCount-1) ; j++)
	{	
	//	for (i=1; i<127 ; i++)
		for (i=129; i<255 ; i++)
		{
		SMT_WRITE(SDDAT,i);
		}
		while((SMT_READ(SDFSTA)&0x800) != 0x800);
		SMT_WRITE(SDDAT,255);
		SMT_WRITE(SDDAT,256);
	}

	while(SMT_READ(SDDatCnt)!=0x00000000);
	while((SMT_READ(SDDatSta)&0x00000010) !=0x00000010);
	SMT_WRITE(SDDatSta,0xFFFFFFFF);// SDDatSta register Clear
	while((SMT_READ(SDFSTA)&0x3F) != 0x00);

}
/*-----------------------------------------------------------------------
    Function name   : MMCReadSingleSim()
    Prototype       : smtUint32 MMCReadSingleSim(void)
    Return          : 
    Argument        :
    Comments        :  MMC Single Block Read function for RTL Simulation
-----------------------------------------------------------------------*/
void MMCReadSingleSim(smtUint32 BlockAddress)
{
	int i;
	SMT_WRITE(SDBSize,511);

	SMT_WRITE(SDDatCon,0x001A0000);// Data NoOperation
	SMT_WRITE(SDFSTA, 0xFFFFFFFF); // FIFO reset

	SMT_WRITE(SDDatCon,0x003B6000);// 8bit mode
//	SMT_WRITE(SDDatCon,0x001B6000);// 4bit mode
//	SMT_WRITE(SDDatCon,0x001A60000);// 1bit mode

	//CMD17(READ_SINGLE_BLOCK)	
	SMT_WRITE(SDCmdArg, BlockAddress);	
	SMT_WRITE(SDCmdCon, CMST|WaitRsp|0x51);
	//Command Sent Check
	while((SMT_READ(SDCmdSta)&0x800)!=0x800);
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit
	
	while((SMT_READ(SDFSTA)&0x1000)!=0x1000);


	while((SMT_READ(SDFSTA)&0x100)!=0x100); // fifo full 시에 read



	//UART_putchhex32(SMT_READ(SDDAT));
	for (i=1; i<128 ; i++)
	{
		UART_putchhex32(SMT_READ(SDDAT));
	}
	while(SMT_READ(SDFSTA)&0x1000 != 0x1000);// FIFO Rx Available
	UART_putchhex32(SMT_READ(SDDAT));
	while((SMT_READ(SDDatSta)&0x00000010) !=0x00000010);
	SMT_WRITE(SDDatSta,0xFFFFFFFF);// SDDatSta register Clear

}

/*-----------------------------------------------------------------------
    Function name   : MMCWriteSingleSim()
    Prototype       : smtUint32 MMCWriteSingleSim(void)
    Return          : 
    Argument        :
    Comments        :  MMC Single Block Write function for RTL Simulation
-----------------------------------------------------------------------*/
void MMCWriteSingleSim(smtUint32 BlockAddress)
{
	int i;
	SMT_WRITE(SDBSize,511);
	//CMD24(WRITE_BLOCK)
	SMT_WRITE(SDDatCon,0x003B7000);// MMC 8bit mode
//	SMT_WRITE(SDDatCon,0x001B7000);// 4bit mode
	//SMT_WRITE(SDDatCon,0x001A7000);// 1bit mode
	//SMT_WRITE(SDDatCon,0x001FF001);
	while(SMT_READ(SDFSTA)&0x2000 != 0x2000);

	UART_putchhex32(SMT_READ(SDBSize));
	UART_printf("\n\r");

	UART_putchhex32(SMT_READ(SDFSTA));
	UART_printf("\n\r");


	for (i=1; i<127 ; i++)
	{
		SMT_WRITE(SDDAT,i);
	}

	SDMMCCmdSend(BlockAddress, CMST|WaitRsp|0x58);

	while((SMT_READ(SDFSTA)&0x800) != 0x800);
	SMT_WRITE(SDDAT,127);
	SMT_WRITE(SDDAT,128);

	SDMMCWaitRsp();
	
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit

	while(SMT_READ(SDDatCnt)!=0x00000000);

	while((SMT_READ(SDDatSta)&0x00000010) !=0x00000010);
	SMT_WRITE(SDDatSta,0xFFFFFFFF);// SDDatSta register Clear

}
void SDReadMultipleSim(smtUint32 BlockCount, smtUint32 BlockAddress)
{
	int i,j,a;
	SMT_WRITE(SDBSize,511);

	SMT_WRITE(SDDatCon,0x001A0000);// Data NoOperation
	SMT_WRITE(SDFSTA, 0xFFFFFFFF); // FIFO reset

	SMT_WRITE(SDDatCon,0x003B6001);// MMC 8bit mode
//	SMT_WRITE(SDDatCon,0x001B6001);// 4bit mode

	while(SMT_READ(SDFSTA)&0x1000 != 0x1000); // Rx Available Check

	//CMD23(SET_BLOCK_COUNT)
	SMT_WRITE(SDCmdArg, BlockCount);
	SMT_WRITE(SDCmdCon,CMST|WaitRsp|0x57);
	//Command Sent Check
	while((SMT_READ(SDCmdSta)&0x200)!=0x200);
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit

	//CMD18(READ_MULTIPLE_BLOCK)
	SMT_WRITE(SDCmdArg, BlockAddress);
	SMT_WRITE(SDCmdCon,CMST|WaitRsp|0x52);
	//Command Sent Check
	while((SMT_READ(SDCmdSta)&0x800)!=0x800);
	SMT_WRITE(SDCmdSta,0xFFFF); // Clear CmdSent bit

	for (j=0; j<BlockCount; j++)
	{
		while(SMT_READ(SDFSTA)&0x1000 != 0x1000);// FIFO Rx Available
		while((SMT_READ(SDFSTA)&0x100)!=0x100); // fifo full 시에 read

		for (i=1; i<128 ; i++)
		{
		a=(SMT_READ(SDDAT));
		}
		while(SMT_READ(SDFSTA)&0x1000 != 0x1000);// FIFO Rx Available
		a=(SMT_READ(SDDAT));

	}

}


void AutoReadMulti(void)
{
	int i,a;
	SMT_WRITE(SDDatCon,0x003B6001);// MMC 8bit mode	

	//while(SMT_READ(SDFSTA)&0x1000 != 0x1000); // Rx Available Check
	SMT_WRITE (SDAutoReadCon,0x00000007); //MultipleRead AutoReadEnable|AutoReadStart|Single/MultiSelect
	while((SMT_READ(SDFSTA)&0x100)!=0x100); // fifo full 시에 read
	for (i=1; i<129 ; i++)
		{
		a=(SMT_READ(SDDAT));
		}

	while((SMT_READ(SDFSTA)&0x100)!=0x100); // fifo full 시에 read
	for (i=1; i<129 ; i++)
		{
		a=(SMT_READ(SDDAT));
		}
}

