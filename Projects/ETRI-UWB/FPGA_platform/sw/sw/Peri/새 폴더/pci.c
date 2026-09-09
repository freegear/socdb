/*----------------------------------------------------------
	File Name   : apinand.c 
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
#include "global.h"
#include "dmac.h"
#include "uart.h"
#include "pci.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
static smtUint8 emptySlotNum[4];

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*-----------------------------------------------------------
    Function name   : pciScan
    Prototype       : void pciScan()
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------*/ 
void pciScan()
{
    smtUint8 devIndx;
    smtUint32 ConfigRegValue;
    CONFIG_ADDRESS config_addr;
    smtUint16 vendorID;
    smtUint16 deviceID;

    config_addr.enable = 0x1;
    config_addr.busNum = 0x0;
    config_addr.devNum = 0x0;
    config_addr.funNum = 0x0;
    config_addr.regNum = 0x0;

    DPRINTF("slot Scan Start \n");
    
//    for(devIndx=2;devIndx<3;devIndx++) // 현재 FPGA Slot4개 
//    {
        config_addr.devNum = devIndx; //0번 은 HostBridge
        type0ConfigAddr(&config_addr);
        DPRINTF("1\n");
        ConfigRegValue=readConfigData();
        DPRINTF("2\n");
        deviceID=(ConfigRegValue & 0xffff0000) >> 16;
        vendorID=(ConfigRegValue & 0x0000ffff);

        if(vendorID==0xffff){ // 빈 slot
            emptySlotNum[devIndx]=0x0;
            DPRINTF("slot [%d] is empty \n",devIndx);
            DPRINTF("slot [%d] DeviceID is [%x] VendorID is [%x] \n",devIndx,deviceID,vendorID);
        }
        else{ 
            emptySlotNum[devIndx]=0x1;
            DPRINTF("slot [%d] DeviceID is [%x] VendorID is [%x] \n",devIndx,deviceID,vendorID);
        }

//    }
}

