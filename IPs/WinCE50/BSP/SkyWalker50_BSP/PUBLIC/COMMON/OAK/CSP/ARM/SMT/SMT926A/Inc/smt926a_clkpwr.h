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
//  Header: smt926a_clkpwr.h
//
//  Defines the clock and power register layout and definitions.
//
#ifndef __SMT926A_CLKPWR_H
#define __SMT926A_CLKPWR_H

#if __cplusplus
    extern "C" 
    {
#endif


//------------------------------------------------------------------------------
//  Type: SMT926A_CLKPWR_REG
//
//  Clock and Power Management registers.
//

typedef struct 
{
    UINT32   LOCKTIME;               // PLL lock time count register
    UINT32   MPLLCON;                // MPLL configuration register
    UINT32   UPLLCON;                // UPLL configuration register
    UINT32   CLKCON;                 // clock generator control register
    UINT32   CLKSLOW;                // slow clock control register
    UINT32   CLKDIVN;                // clock divider control register
    UINT32	 CAMDIVN;				 // camera clock divider register

	/* SMT926 Power management registers */
	// Inserted by DJKIM 2006/09/27
	//UINT32	 CLKCON;
	UINT32	 CLKDIV;
	UINT32	 SYSPLL;
	UINT32	 USYSPLL;
	UINT32	 RSTCON;

} SMT926A_CLKPWR_REG, *PSMT926A_CLKPWR_REG;


#if __cplusplus
    }
#endif

#endif 
