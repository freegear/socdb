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
//  Header: skywalker.h
//
//  This header file defines the SKYWALKER processor.
//
//  The skywalker is a System on Chip (SoC) part consisting of an ARM920T core. 
//  This header file is comprised of component header files that define the 
//  register layout of each component.
//  
//------------------------------------------------------------------------------
#ifndef __SKYWALKER_H
#define __SKYWALKER_H

#if __cplusplus
extern "C" {
#endif

//------------------------------------------------------------------------------

// Base Definitions
#include "skywalker_base_regs.h"

// SoC Components
#include "skywalker_adc.h"
#include "skywalker_clkpwr.h"
#include "skywalker_dma.h"
#include "skywalker_iicbus.h"
#include "skywalker_iisbus.h"
#include "skywalker_intr.h"
#include "skywalker_ioport.h"
#include "skywalker_lcd.h"
#include "skywalker_memctrl.h"
#include "skywalker_nand.h"
#include "skywalker_pwm.h"
#include "skywalker_rtc.h"
#include "skywalker_sdi.h"
#include "skywalker_spi.h"
#include "skywalker_uart.h"
#include "skywalker_usbd.h"
#include "skywalker_wdog.h"

//------------------------------------------------------------------------------

#if __cplusplus
}
#endif

#endif 
