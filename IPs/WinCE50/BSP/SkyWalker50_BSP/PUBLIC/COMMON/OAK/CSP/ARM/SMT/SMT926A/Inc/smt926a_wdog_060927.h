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
//  Header:  smt926a_wdog.h
//
//  Defines the Watchdog Timer register layout and associated types 
//  and constants.
//
#ifndef __SMT926A_WDOG_H
#define __SMT926A_WDOG_H

#if __cplusplus
extern "C" {
#endif

//------------------------------------------------------------------------------
//
//  Type:  SMT926A_WATCHDOG_REG    
//
//  Watchdog timer control registers. This register bank is located by the 
//  constant SMT926A_BASE_REG_XX_WATCHDOG in the configuration file 
//  smt926a_reg_base_cfg.h.
//

typedef struct {
    UINT32 WTCON;               // timer control reg
    UINT32 WTDAT;               // timer data reg
    UINT32 WTCNT;               // timer count reg

} SMT926A_WATCHDOG_REG, *PSMT926A_WATCHDOG_REG;

//------------------------------------------------------------------------------

#if __cplusplus
    }
#endif

#endif 
