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
//  File:  init.c
//
//  SKYWALKER initialization code.
//
#include <bsp.h>
 

//------------------------------------------------------------------------------
//
//  Function:  OEMInit
//
//  This is Windows CE OAL initialization function. It is called from kernel
//  after basic initialization is made.
//
void OEMInit()
{
    OALMSG(OAL_FUNC, (L"+OEMInit\r\n"));

    // Set memory size for DrWatson kernel support
    dwNKDrWatsonSize = 128 * 1024;

    // Initilize cache globals
    OALCacheGlobalsInit();

    OALLogSerial(
        L"DCache: %d sets, %d ways, %d line size, %d size\r\n", 
        g_oalCacheInfo.L1DSetsPerWay, g_oalCacheInfo.L1DNumWays,
        g_oalCacheInfo.L1DLineSize, g_oalCacheInfo.L1DSize
    );
    OALLogSerial(
        L"ICache: %d sets, %d ways, %d line size, %d size\r\n", 
        g_oalCacheInfo.L1ISetsPerWay, g_oalCacheInfo.L1INumWays,
        g_oalCacheInfo.L1ILineSize, g_oalCacheInfo.L1ISize
    );
    
    // Initialize interrupts
    if (!OALIntrInit()) {
        OALMSG(OAL_ERROR, (
            L"ERROR: OEMInit: failed to initialize interrupts\r\n"
        ));
    }

    // Initialize system clock
    OALTimerInit(1, S3C2410X_PCLK/2000, 0);

    // Initialize the KITL connection if required
    OALKitlStart();

    OALMSG(OAL_FUNC, (L"-OEMInit\r\n"));
}

//------------------------------------------------------------------------------
