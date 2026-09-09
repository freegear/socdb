/*----------------------------------------------------------
	File Name   : pci.h
	Description : pci header
	Created by  : SHMT SoC Team
-----------------------------------------------------------*/
#include "sysinc.h"

typedef struct
{
    smtUint8 enable;
    smtUint8 busNum;
    smtUint8 devNum;
    smtUint8 funNum;
    smtUint8 regNum;
} CONFIG_ADDRESS;

void type0ConfigAddr(CONFIG_ADDRESS *push)
{
    SMT_WRITE(PCI_CONFIG_ADDR,
               ((push->enable & 0x1 ) << 31) |
               ((push->busNum & 0xff) << 16) |
               ((push->devNum & 0x1f) << 11) |
               ((push->funNum & 0x7 ) << 8 ) |
               ((push->regNum & 0x3f) << 2 ) 
             );
}

void type1ConfigAddr(CONFIG_ADDRESS *push)
{
    SMT_WRITE(PCI_CONFIG_ADDR,
               ((push->enable & 0x1 ) << 31) |
               ((push->busNum & 0xff) << 16) |
               ((push->devNum & 0x1f) << 11) |
               ((push->funNum & 0x7 ) << 8 ) |
               ((push->regNum & 0x3f) << 2 ) | 0x1
             );
}

smtUint32 readConfigData()
{
    return SMT_READ(PCI_CONFIG_DATA);
}

void writeConfigData(smtUint32 writeData)
{
    SMT_WRITE(PCI_CONFIG_DATA,writeData);
}
