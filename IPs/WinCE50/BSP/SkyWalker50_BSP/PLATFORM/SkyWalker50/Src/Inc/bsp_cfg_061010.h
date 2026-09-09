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
//  File:  bsp_cfg.h
//
//  This file contains system constant specific for SKYWALKER board.
//
#ifndef __BSP_CFG_H
#define __BSP_CFG_H

//------------------------------------------------------------------------------
//
//  Define:  BSP_DEVICE_PREFIX
//
//  Prefix used to generate device name for bootload/KITL
//
#define BSP_DEVICE_PREFIX       "SKYWALKER"        // Device name prefix
//------------------------------------------------------------------------------
// Board clock
//------------------------------------------------------------------------------

#define SMT926A_FCLK           399651840           // 399.65MHz
#define SMT926A_HCLK           (SMT926A_FCLK/3)   // divisor 6
#define SMT926A_PCLK           (SMT926A_FCLK/6)   // divisor 6

//------------------------------------------------------------------------------
// Debug UART1
//------------------------------------------------------------------------------

#define BSP_UART1_ULCON         0x03                // 8 bits, 1 stop, no parity
#define BSP_UART1_UCON          0x0005              // pool mode, PCLK for UART
#define BSP_UART1_UFCON         0x00                // disable FIFO
#define BSP_UART1_UMCON         0x00                // disable auto flow control
#define BSP_UART1_UBRDIV        (SMT926A_PCLK/(115200*16) - 1)

//------------------------------------------------------------------------------
// Static SYSINTR Mapping for driver.
#define SYSINTR_OHCI            (SYSINTR_FIRMWARE+1)

#endif
