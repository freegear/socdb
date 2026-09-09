/*------------------------------------------------------------------------------
	 ETRI-UWB
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2007 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File name		: pci_drv.h
	Description	: pci driver header file
------------------------------------------------------------------------------*/
#ifndef __PCI_DRV_H__
#define __PCI_DRV_H__

/*
//////////////////////////////////////////////////////////////////////////////
	INCLUDE
//////////////////////////////////////////////////////////////////////////////
*/
#include "global.h"
#include "commonmacro.h"

/*
//////////////////////////////////////////////////////////////////////////////
        DEFINITION
//////////////////////////////////////////////////////////////////////////////
*/
typedef enum
{
	MASTER_RX,
	MASTER_TX
} PCI_OPMODE;

typedef struct
{
    smtUint8 enable;
    smtUint8 busNum;
    smtUint8 devNum;
    smtUint8 funNum;
    smtUint8 regNum;
} PCI_CF_ADDR_REG;

typedef struct
{
#ifdef PCI_V23
	smtBoolean intrEnable;
#endif
	smtBoolean fastBackEnable;	// Read Only
	smtBoolean sErr;
	smtBoolean addrStepping;		// Read Only

	smtBoolean parErrResp;
	smtBoolean vgaPaletteEnable;	// Read Only
	smtBoolean mwiEnable;		// MWI : Master Write Invalidate
	smtBoolean specialCycle;		// Read Only
	smtBoolean busMaster;
	smtBoolean memEnable;
	smtBoolean ioEnable;
} PCI_CMD_REG;

typedef struct
{
	smtUint8 devSelTiming;		// Read Only
	smtBoolean fastBackCapable;	// Read Only
	smtBoolean udf;				// Read Only
	smtBoolean pciClkcapable;		// Read Only
	smtBoolean capableList;		// Read Only
#ifdef PCI_V23
	smtBoolean intrStatus;		// Read Only
#endif
} PCI_STATUS_REG;

typedef struct
{
	smtUint16 vendorID;			// Read Only
	smtUint16 deviceID;			// Read Only
	smtUint16 cmd;
	smtUint16 status;

	smtUint8 revisionID;			// Read Only
	smtUint8 classCode[3];		// Read Only
	smtUint8 cacheLineSize;
	smtUint8 latencyTimer;
	smtUint8 headerType;			// Read Only
	smtUint8 bist;					// Read Only

	// Base Address Register : 0x10h ~ 0x24h
	// The number of rd/wr bits and rd-only bits are defined by the user
	// using the BAR_SETUP signals.
	smtUint32 baseAddrReg0;
	smtUint32 baseAddrReg1;
	smtUint32 baseAddrReg2;
	smtUint32 baseAddrReg3;
	smtUint32 baseAddrReg4;
	smtUint32 baseAddrReg5;

	smtUint32 cisPtr;				// Read Only
	smtUint16 subVendorID;		// Read Only
	smtUint16 subID;				// Read Only
	smtUint32 expROMBaseAddr;
#ifdef PCI_V22
	smtUint8 capabilityPtr;
	smtUint8 dummy[3];
#else
	smtUint8 dummy[4];
#endif

	smtUint8 intrLine;
	smtUint8 intrPin;				// Read Only
	smtUint8 minGnt;				// Read Only
	smtUint8 maxLat;				// Read Only

#ifdef PCI_V23
	smtUint16 retryCnt;
	smtUint8 cntEnable;
	smtUint8 retryOFflag;
#endif
} PCI_CFG_REG;

/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
void smtPCIType0CfgCycle(PCI_CF_ADDR_REG *pciCfg0);
void smtPCIType1CfgCycle(PCI_CF_ADDR_REG *pciCfg1);
smtUint32 smtPCIReadCfgData(void);
void smtPCIWriteCfgData(smtUint32 writeData);


#endif

