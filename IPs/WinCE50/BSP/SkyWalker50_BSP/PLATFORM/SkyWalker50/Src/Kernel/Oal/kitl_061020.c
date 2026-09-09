//
// Copyright (c) Microsoft Corporation.  All rights reserved.
//
//
// Use of this source code is subject to the terms of the Microsoft end-user
// license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
// If you did not accept the terms of the EULA, you are not authorized to use
// this source code. For a copy of the EULA, please see the LICENSE.RTF on your
// install media.
//
// -----------------------------------------------------------------------------
//
//      THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
//      ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
//      THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
//      PARTICULAR PURPOSE.
//  
// -----------------------------------------------------------------------------
#include <windows.h>
#include <bsp.h>
#include <kitl_cfg.h>

OAL_KITL_DEVICE g_kitlDevice;

const OAL_KITL_SERIAL_DRIVER *GetKitlSerialDriver (void);
//const OAL_KITL_SERIAL_DRIVER *GetKitlUSBSerialDriver (void); // To no bug temparary by DJKIM 2006/09/26
static OAL_KITL_ETH_DRIVER g_kitlEthLAN91C111 = OAL_ETHDRV_LAN91C;

volatile SMT926A_MEMCTRL_REG *g_pMEMCTRLReg;
volatile SMT926A_IOPORT_REG *g_pIOPortReg;

BOOL USBSerKitl_POLL = FALSE;

BOOL InitKitlEtherArgs (OAL_KITL_ARGS *pKitlArgs)
{
    // init flags
    pKitlArgs->flags = OAL_KITL_FLAGS_ENABLED | OAL_KITL_FLAGS_VMINI;
#ifdef LAN91C111_KITL_POLLMODE
    pKitlArgs->flags |= OAL_KITL_FLAGS_POLL; // Use polling without intr
#endif //LAN91C111_KITL_POLLMODE
#ifdef LAN91C111_KITL_DHCP
    pKitlArgs->flags |= OAL_KITL_FLAGS_DHCP; // Enable DHCP
#endif //LAN91C111_KITL_DHCP

    pKitlArgs->devLoc.IfcType    	= Internal;
    pKitlArgs->devLoc.BusNumber    	= 0;
    pKitlArgs->devLoc.LogicalLoc    = BSP_BASE_REG_PA_LAN91C111_IOBASE;  // base address
    pKitlArgs->devLoc.Pin           = 0;
    
    OALKitlStringToMAC(LAN91C111_MAC,pKitlArgs->mac);

#ifndef LAN91C111_KITL_DHCP
    pKitlArgs->ipAddress            = OALKitlStringToIP(LAN91C111_IP_ADDRESS);
    pKitlArgs->ipMask            	= OALKitlStringToIP(LAN91C111_IP_MASK);
    pKitlArgs->ipRoute            	= OALKitlStringToIP(LAN91C111_IP_ROUTER);
#endif LAN91C111_KITL_DHCP

    g_kitlDevice.ifcType			= Internal;
    g_kitlDevice.type               = OAL_KITL_TYPE_ETH; // Kitl type is ethernet
    g_kitlDevice.pDriver            = (void *)&g_kitlEthLAN91C111;

    //configure nCS3 for lan91c111 // Hmm. by DJKIM 2006/10/10 ???
    g_pMEMCTRLReg = (SMT926A_MEMCTRL_REG *)OALPAtoVA(SMT926A_BASE_REG_PA_MEMCTRL, FALSE);
    g_pMEMCTRLReg->BWSCON = (g_pMEMCTRLReg->BWSCON & ~(0xf<<12)) | (0xd<<12);

    //setting EINT9 as IRQ_LAN
    if (!(pKitlArgs->flags & OAL_KITL_FLAGS_POLL))
    {
        g_pIOPortReg = (SMT926A_IOPORT_REG *)OALPAtoVA(SMT926A_BASE_REG_PA_IOPORT, FALSE);
        g_pIOPortReg->GPGCON = (g_pIOPortReg->GPGCON & ~(0x3<<2)) | (0x2<<2);
        g_pIOPortReg->GPGUP |= 0x1<<1;
        g_pIOPortReg->EXTINT1 = (g_pIOPortReg->EXTINT1 & ~(0x7<<4)) | (0x1<<4);
    }
    return TRUE;
}

BOOL InitKitlSerialArgs (OAL_KITL_ARGS *pKitlArgs)
{
    DWORD dwIoBase = UART_Kitl;

    // init flags
    pKitlArgs->flags = OAL_KITL_FLAGS_ENABLED | OAL_KITL_FLAGS_POLL;

    pKitlArgs->devLoc.LogicalLoc    = dwIoBase;
    pKitlArgs->devLoc.Pin           = OAL_INTR_IRQ_UNDEFINED;
    pKitlArgs->baudRate             = CBR_115200;
    pKitlArgs->dataBits             = DATABITS_8;
    pKitlArgs->parity               = PARITY_NONE;
    pKitlArgs->stopBits             = STOPBITS_10;

    g_kitlDevice.type               = OAL_KITL_TYPE_SERIAL;
    g_kitlDevice.pDriver            = (VOID*) GetKitlSerialDriver ();

    return TRUE;
}

BOOL InitKitlUSBSerialArgs (OAL_KITL_ARGS *pKitlArgs)
{
    DWORD dwIoBase = SMT926A_BASE_REG_PA_USBD + 0x140;

    // init flags
    pKitlArgs->flags = OAL_KITL_FLAGS_ENABLED;
#ifdef USBSER_KITL_POLL
    pKitlArgs->flags |= OAL_KITL_FLAGS_POLL;
    USBSerKitl_POLL = TRUE;
#endif

    pKitlArgs->devLoc.LogicalLoc    = dwIoBase;
    pKitlArgs->devLoc.Pin           = IRQ_USBD;

    g_kitlDevice.type               = OAL_KITL_TYPE_SERIAL;
    g_kitlDevice.pDriver            = (void*)NULL; //(VOID*) GetKitlUSBSerialDriver (); // To no bug temparary by DJKIM 2006/09/26

    return TRUE;
}
//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------
BOOL OALKitlStart()
{
    OAL_KITL_ARGS   kitlArgs, *pArgs;
    BOOL            fRet = FALSE;
    UCHAR			*szDeviceId,buffer[OAL_KITL_ID_SIZE]="\0";

    memset (&kitlArgs, 0, sizeof (kitlArgs));

    pArgs = (OAL_KITL_ARGS *)OALArgsQuery(OAL_ARGS_QUERY_KITL);
    szDeviceId = (CHAR*)OALArgsQuery(OAL_ARGS_QUERY_DEVID);

    // common parts
    kitlArgs.devLoc.IfcType = g_kitlDevice.ifcType
                            = InterfaceTypeUndefined;
    g_kitlDevice.name       = g_oalIoCtlPlatformType;

    KITLOutputDebugString ("OALKitlStart : ");

    
#ifdef KITL_SERIAL
    KITLOutputDebugString ("SERIAL\n");
    fRet = InitKitlSerialArgs (&kitlArgs);
    strcpy(buffer,"SMTSerKitl");
    szDeviceId = buffer;
    g_kitlDevice.id = kitlArgs.devLoc.LogicalLoc;
#endif //KITL_SERIAL
#ifdef KITL_USBSERIAL
    KITLOutputDebugString ("USB SERIAL\n");
    fRet = InitKitlUSBSerialArgs (&kitlArgs);
    strcpy(buffer,"SMTUSBSerKitl");
    szDeviceId = buffer;
    g_kitlDevice.id = kitlArgs.devLoc.LogicalLoc;
#endif //KITL_USBSERIAL
#ifdef KITL_ETHERNET
    KITLOutputDebugString ("ETHERNET\n");
	
    if (pArgs == NULL)
    {	
        fRet = InitKitlEtherArgs (&kitlArgs);
        OALKitlCreateName(BSP_DEVICE_PREFIX, kitlArgs.mac, buffer);
        szDeviceId = buffer;
        g_kitlDevice.id = kitlArgs.devLoc.LogicalLoc;
    }
    else
    {
        g_kitlDevice.ifcType			= Internal;
        g_kitlDevice.id    				= BSP_BASE_REG_PA_LAN91C111_IOBASE;  // base address
        g_kitlDevice.type               = OAL_KITL_TYPE_ETH;
        g_kitlDevice.pDriver            = (void *)&g_kitlEthLAN91C111; // Pointer to the KITL device driver

        memcpy(&kitlArgs, pArgs, sizeof (kitlArgs));

        fRet = TRUE;
    }
    
#endif //KITL_ETHERNET

    if (fRet == FALSE)
    {
        KITLOutputDebugString ("NONE\n");
        return FALSE;
    }
	
    OALKitlInit (szDeviceId, &kitlArgs, &g_kitlDevice);
    return fRet;
}

//------------------------------------------------------------------------------
//
//  Function:  OALGetTickCount
//
//  This function is called by some KITL libraries to obtain relative time
//  since device boot. It is mostly used to implement timeout in network
//  protocol.
//

UINT32 OALGetTickCount()
{
    static ULONG count = 0;

    count++;
    return count/100;
}

// Define a dummy SetKMode function to satisfy the NAND FMD.
//
DWORD SetKMode (DWORD fMode)
{
    return(1);
}
//------------------------------------------------------------------------------

