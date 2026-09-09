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
//  Header: smt926a.h
//
//  This header file defines the smt926A processor.
//
//  The smt926A is a System on Chip (SoC) part consisting of an ARM920T core. 
//  This header file is comprised of component header files that define the 
//  register layout of each component.
//  
//------------------------------------------------------------------------------
#ifndef __S3C2440A_H
#define __S3C2440A_H

#if __cplusplus
extern "C" {
#endif

//------------------------------------------------------------------------------

// Base Definitions
#include "smt926a_base_regs.h"

// SoC Components
#include "smt926a_adc.h"
#include "smt926a_clkpwr.h"
#include "smt926a_dma.h"
#include "smt926a_iicbus.h"
#include "smt926a_iisbus.h"
#include "smt926a_intr.h"
#include "smt926a_ioport.h"
#include "smt926a_lcd.h"
#include "smt926a_memctrl.h"
#include "smt926a_nand.h"
#include "smt926a_pwm.h"
#include "smt926a_rtc.h"
#include "smt926a_sdi.h"
#include "smt926a_spi.h"
#include "smt926a_uart.h"
#include "smt926a_usbd.h"
#include "smt926a_wdog.h"
#include "smt926a_cam.h"
//------------------------------------------------------------------------------

#if __cplusplus
}
#endif

#endif 
