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
//  Header:  smt926a_memctrl.h
//
//  Defines the memory controller register layout and associated 
//  constants and types.
//
#ifndef __SMT926A_MEMCTRL_H
#define __SMT926A_MEMCTRL_H

#if __cplusplus
extern "C" {
#endif

//------------------------------------------------------------------------------
//
//  Type:  SMT926A_MEMCTRL_REG    
//
//  Memory controller register layout. This register bank is located by the 
//  constant SMT926A_REG_BASE_XX_MEMCTRL in the configuration file 
//  smt926a_base_reg_cfg.h.
//

typedef struct  {
    UINT32 BWSCON;              // bus width & wait status control reg  
    UINT32 BANKCON0;            // bank 0 control reg
    UINT32 BANKCON1;            // bank 1 control reg
    UINT32 BANKCON2;            // bank 2 control reg
    UINT32 BANKCON3;            // bank 3 control reg
    UINT32 BANKCON4;            // bank 4 control reg
    UINT32 BANKCON5;            // bank 5 control reg
    UINT32 BANKCON6;            // bank 6 control reg
    UINT32 BANKCON7;            // bank 7 control reg
    UINT32 REFRESH;             // SDRAM refresh control reg
    UINT32 BANKSIZE;            // Flexible bank size reg
    UINT32 MRSRB6;              // Mode reg set reg bank6
    UINT32 MRSRB7;              // mode reg set reg bank7

	/*SMT926 memory controller registers */
	// Inserted by DJKIM 2006/09/27
	UINT32	 SMC_BANK0;
	UINT32	 SMC_BANK1;
	UINT32	 SMC_BANK2;
	UINT32	 SMC_BANK3;

} SMT926A_MEMCTRL_REG, *PSMT926A_MEMCTRL_REG;

//------------------------------------------------------------------------------

#if __cplusplus
}
#endif

#endif 
