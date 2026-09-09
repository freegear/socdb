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
//------------------------------------------------------------------------------
//
#include <bsp.h>

//------------------------------------------------------------------------------
// Definitions to extract the MAC address from the old driver globals model.
// This will be used to create the device string when we are booted using the
// old bootloader
#define BSP_PREV_DRVGBL_SIG_LOC 0xAC020800
#define BSP_PREV_DRVGBL_SIG     0x45424F54  // "EBOT"
#define BSP_PREV_DRVGBL_MAC     0xAC02080C  

// Device ID string buffer used in case where we are booted 
// with the old bootloader.
CHAR g_deviceName[EDBG_MAX_DEV_NAMELEN] = "";

// Must define this locally instead of using the OALKitlCreateName so that we
// do not break non-kitl images
VOID CreateName(CHAR *pPrefix, UINT16 mac[3], CHAR *pBuffer);

//------------------------------------------------------------------------------
//
//  Function:  OALArgsQuery
//
//  This function is called from other OAL modules to return boot arguments.
//  Boot arguments are typically placed in fixed memory location and they are
//  filled by boot loader. In case that boot arguments can't be located
//  the function should return NULL. The OAL module then must use default
//  values.
//
VOID* OALArgsQuery(UINT32 type)
{
    VOID *pData = NULL;
    BSP_ARGS *pArgs;

    OALMSG(OAL_ARGS&&OAL_FUNC, (L"+OALArgsQuery(%d)\r\n", type));

    // Get pointer to expected boot args location
    pArgs = (BSP_ARGS*)IMAGE_SHARE_ARGS_UA_START;

    // Check if there is expected signature
    if (
        pArgs->header.signature  != OAL_ARGS_SIGNATURE ||
        pArgs->header.oalVersion != OAL_ARGS_VERSION   ||
        pArgs->header.bspVersion != BSP_ARGS_VERSION
    ) {
        // Check to see if there is a driver globals 
        // signature from the old bootloader
        if (*((DWORD *)(BSP_PREV_DRVGBL_SIG_LOC)) == ((DWORD)(BSP_PREV_DRVGBL_SIG)))
        {
            // If they are requesting the device id, we need to create
            // it and return it to the caller
            if (type == OAL_ARGS_QUERY_DEVID)
            {
                if (g_deviceName[0] == '\0')
                {
                    // Get MAC address from Ethernet configuration and
                    // the platform string to create the device name.
                    CreateName(BSP_DEVICE_PREFIX,
                               (USHORT *)BSP_PREV_DRVGBL_MAC,
                               g_deviceName);
                }
                pData = g_deviceName;
            }
        }

        goto cleanUp;
    }

    // Depending on required args
    switch (type) {
    case OAL_ARGS_QUERY_DEVID:
        pData = &pArgs->deviceId;
        break;
    case OAL_ARGS_QUERY_KITL:
        pData = &pArgs->kitl;
        break;
    }

cleanUp:
    OALMSG(OAL_ARGS&&OAL_FUNC, (L"-OALArgsQuery(pData = 0x%08x)\r\n", pData));
    return pData;
}

//------------------------------------------------------------------------------
//
//  Function:  CreateName
//
//  This function create device name from prefix and mac address (usually last
//  two bytes of MAC address used for download).
//
VOID CreateName(CHAR *pPrefix, UINT16 mac[3], CHAR *pBuffer)
{
    UINT32 count;
    UINT16 base, code;

    count = 0;
    code = (mac[2] >> 8) | ((mac[2] & 0x00ff) << 8);
    while (count < OAL_KITL_ID_SIZE - 6 && pPrefix[count] != '\0') {
        pBuffer[count] = pPrefix[count];
        count++;
    }        
    base = 10000;
    while (base > code && base != 0) base /= 10;
    if (base == 0) { 
        pBuffer[count++] = '0';
    } else {
        while (base > 0) {
            pBuffer[count++] = code/base + '0';
            code %= base;
            base /= 10;
        }
    }        
    pBuffer[count] = '\0';
}

//------------------------------------------------------------------------------
