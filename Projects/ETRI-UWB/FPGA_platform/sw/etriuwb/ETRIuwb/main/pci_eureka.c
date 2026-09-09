/*----------------------------------------------------------
	 ETRI-UWB
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2007 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File Name	: pci.c 
	Description	: pci driver file
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
	INCLUDE
///////////////////////////////////////////////////////// 
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "irq.h"

#include "mmu.h"

#include "pci_drv.h"

/*
/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// 
*/


/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
void pciCfgRegAccess(void);

/*
/////////////////////////////////////////////////////////
	VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/
static smtUint8 emptySlotNum[4];

/*
/////////////////////////////////////////////////////////
	FUNCTION
///////////////////////////////////////////////////////// 
*/
/*----------------------------------------------------------
	Function name	: PCITest()
	Prototype		: void PCITest(void)
	Return		: smtUint32
	Argument	:
	Comments	:
----------------------------------------------------------*/
smtUint32 PCITest(void)
{
	pciCfgRegAccess();

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: smtPCIType0CfgCycle()
	Prototype		: void smtPCIType0CfgCycle(PCI_CF_ADDR_REG *pciCfg0)
	Return		: void
	Argument	:
	Comments	:
----------------------------------------------------------*/
void smtPCIType0CfgCycle(PCI_CF_ADDR_REG *pciCfg0)
{
	SMT_WRITE(PCI_CONFIG_ADDR,
		((pciCfg0->enable & 0x1 ) << 31) |
		((pciCfg0->busNum & 0xff) << 16) |
		((pciCfg0->devNum & 0x1f) << 11) |
		((pciCfg0->funNum & 0x7 ) << 8 ) |
		//((pciCfg0->regNum & 0xff) << 2 ) );
		((pciCfg0->regNum & 0x3f) << 2 ) );
}

/*----------------------------------------------------------
	Function name	: smtPCIType1CfgCycle()
	Prototype		: void smtPCIType1CfgCycle(PCI_CF_ADDR_REG *pciCfg1)
	Return		: void
	Argument	:
	Comments	:
----------------------------------------------------------*/
void smtPCIType1CfgCycle(PCI_CF_ADDR_REG *pciCfg1)
{
	SMT_WRITE(PCI_CONFIG_ADDR,
		((pciCfg1->enable & 0x1 ) << 31) |
		((pciCfg1->busNum & 0xff) << 16) |
		((pciCfg1->devNum & 0x1f) << 11) |
		((pciCfg1->funNum & 0x7 ) << 8 ) |
		//((pciCfg1->regNum & 0xff) << 2 ) | 0x1 );
		((pciCfg1->regNum & 0x3f) << 2 ) | 0x1 );
}

/*----------------------------------------------------------
	Function name	: smtPCIReadCfgData(void)
	Prototype		: smtUint32 smtPCIReadCfgData(void)
	Return		: smtUint32
	Argument	:
	Comments	:
----------------------------------------------------------*/
smtUint32 smtPCIReadCfgData(void)
{
	return SMT_READ(PCI_CONFIG_DATA);
}

/*----------------------------------------------------------
	Function name	: smtPCIWriteCfgData()
	Prototype		: void smtPCIWriteCfgData(smtUint32 writeData)
	Return		: void
	Argument	:
	Comments	:
----------------------------------------------------------*/
void smtPCIWriteCfgData(smtUint32 writeData)
{
	SMT_WRITE(PCI_CONFIG_DATA, writeData);
}

/*----------------------------------------------------------
	Function name	: pciCfgRegAccess()
	Prototype		: void pciCfgRegAccess(void)
	Return		: void
	Argument	:
	Comments	:
----------------------------------------------------------*/
void pciCfgRegAccess(void)
{
	smtUint8 devIndx, regIndx;
	smtUint32 ConfigRegValue;
	PCI_CF_ADDR_REG config_addr;
	smtUint16 vendorID;
	smtUint16 deviceID;

	config_addr.enable = 0x1;
	config_addr.busNum = 0x0;
	config_addr.devNum = 0x0;
	config_addr.funNum = 0x0;
	config_addr.regNum = 0x0;

	//
	////  Scan PCI Slot
	//    
	smt2UartPrint(11,"PCI Slot Scan Start \n");
	for(devIndx=1;devIndx<5;devIndx++)
	{
		config_addr.enable = 0x1;
		config_addr.busNum = 0x0;
		config_addr.devNum = devIndx;		// Device number 0 is host bridge number
		config_addr.funNum = 0x0;
		config_addr.regNum = 0x0;

		smtPCIType0CfgCycle(&config_addr);
		ConfigRegValue=smtPCIReadCfgData();
		deviceID=(ConfigRegValue & 0xffff0000) >> 16;
		vendorID=(ConfigRegValue & 0x0000ffff);

		if(vendorID==0xffff)				// Empty slot
		{
			emptySlotNum[devIndx]=0x0;
			smt2UartPrint(11,"slot [%d] is empty \n",devIndx);
		}
		else
		{ 
			emptySlotNum[devIndx]=0x1;
			smt2UartPrint(11,"slot [%d] DeviceID is [%x] VendorID is [%x] \n",devIndx,deviceID,vendorID);
		}
	}


	//
	//// Configuration Register read 00h ~ 40h
	//
	smt2UartPrint(11,"\n -------- 8139D Configuration Register READ Test -------- \n\n");
	for(devIndx=1;devIndx<5;devIndx++)
	{
		config_addr.enable = 0x1;
		config_addr.busNum = 0x0;
		config_addr.devNum = 0x0;
		config_addr.funNum = 0x0;
		config_addr.regNum = 0x0;

		if(emptySlotNum[devIndx])
		{
			smt2UartPrint(11,"********* slot[%d] register read ********* \n",devIndx);
			for(regIndx=0;regIndx<17;regIndx++)
			{
				config_addr.devNum = devIndx;
				config_addr.regNum = regIndx;
				smtPCIType0CfgCycle(&config_addr);
				ConfigRegValue=smtPCIReadCfgData();
				smt2UartPrint(11,"Reg[%d] Value is [%x] \n",regIndx,ConfigRegValue);
			}
		}
	}


	//
	////  8139D Configuration Register write/read 
	//
	smt2UartPrint(11,"\n -------- 8139D Register Write READ Test -------- \n\n");
	for(devIndx=1;devIndx<5;devIndx++)
	{
		config_addr.enable = 0x1;
		config_addr.busNum = 0x0;
		config_addr.devNum = 0x0;
		config_addr.funNum = 0x0;
		config_addr.regNum = 0x0;

		if(emptySlotNum[devIndx])
		{
			config_addr.devNum = devIndx;
			config_addr.regNum = 0x5;

			smtPCIType0CfgCycle(&config_addr);
			smtPCIWriteCfgData(0xaabbcc00);
			smtPCIType0CfgCycle(&config_addr);
			ConfigRegValue=smtPCIReadCfgData();

			if(ConfigRegValue==0xaabbcc00)
			    smt2UartPrint(11,"device[%d] write/read value match \n",devIndx);
			else
			    smt2UartPrint(11,"device[%d] write/read value not match\n",devIndx);
		}
	}      

}

