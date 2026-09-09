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
    int i;
    smtUint8 devIndx,regIndx;
    smtUint32 ConfigRegValue;
    CONFIG_ADDRESS config_addr;
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
    
    DPRINTF("\n -------- PCI Slot Scan Start -------- \n");
    for(devIndx=0;devIndx<5;devIndx++) // 현재 FPGA Slot4개 
    {
        config_addr.enable = 0x1;
        config_addr.busNum = 0x0;
        config_addr.devNum = devIndx; //0번 은 HostBridge
        config_addr.funNum = 0x0;
        config_addr.regNum = 0x0;
        type0ConfigAddr(&config_addr);
        ConfigRegValue=readConfigData();
        deviceID=(ConfigRegValue & 0xffff0000) >> 16;
        vendorID=(ConfigRegValue & 0x0000ffff);

        if(vendorID==0xffff){ // 빈 slot
            emptySlotNum[devIndx]=0x0;
            config_addr.devNum = 0x0;
            config_addr.regNum = 0x1;
            type0ConfigAddr(&config_addr);
            writeConfigData(0xffff0000);
            DPRINTF("slot [%d] is empty \n",devIndx);
        }
        else{ 
            emptySlotNum[devIndx]=0x1;
            DPRINTF("slot [%d] DeviceID is [%x] VendorID is [%x] \n",devIndx,deviceID,vendorID);
        }
    }

    
    
    //
    //// Configuration Register read 00h ~ 40h
    //
    DPRINTF("\n -------- 8139D Configuration Register READ Test -------- \n\n");
    for(devIndx=0;devIndx<5;devIndx++) // 현재 FPGA Slot4개 
    {
        config_addr.enable = 0x1;
        config_addr.busNum = 0x0;
        config_addr.devNum = 0x0;
        config_addr.funNum = 0x0;
        config_addr.regNum = 0x0;
        if(emptySlotNum[devIndx]){
            DPRINTF("********* slot[%d] register read ********* \n",devIndx);
            for(regIndx=0;regIndx<17;regIndx++) {
                config_addr.devNum = devIndx;
                config_addr.regNum = regIndx;
                type0ConfigAddr(&config_addr);
                ConfigRegValue=readConfigData();
                DPRINTF("Reg[%d] Value is [%x] \n",regIndx,ConfigRegValue);
            }
        }
    }


    //
    ////  8139D Configuration Register write/read 
    //
    DPRINTF("\n -------- 8139D Register Write READ Test -------- \n\n");
    for(devIndx=1;devIndx<5;devIndx++) // 현재 FPGA Slot4개 
    {
        config_addr.enable = 0x1;
        config_addr.busNum = 0x0;
        config_addr.devNum = 0x0;
        config_addr.funNum = 0x0;
        config_addr.regNum = 0x0;
        if(emptySlotNum[devIndx]){
            config_addr.devNum = devIndx;
            config_addr.regNum = 0x5;
            type0ConfigAddr(&config_addr);
            writeConfigData(0xaabbcc00);
            type0ConfigAddr(&config_addr);
            ConfigRegValue=readConfigData();
            if(ConfigRegValue==0xaabbcc00)
//                DPRINTF("read value is [%x] \n",ConfigRegValue);
                DPRINTF("device[%d] write/read value match \n",devIndx);
            else
                DPRINTF("device[%d] write/read value not match\n",devIndx);
        }
    }        

}

