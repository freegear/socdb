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
//  Header: smt926a_pwm.h
//
//  Defines the PWM Timer register layout and associated types and constants.
//
#ifndef __SMT926A_PWM_H
#define __SMT926A_PWM_H

#if __cplusplus
extern "C" {
#endif

//------------------------------------------------------------------------------
//
//  Type:  SMT926A_PWM_REG
//
//  Defines the PWM Timer control register layout. This register bank is 
//  located by the constant SMT926A_BASE_REG_XX_PWM in the configuration file
//  smt926a_base_reg_cfg.h.
//
typedef struct  {
    UINT32 TCFG0;
    UINT32 TCFG1;
    UINT32 TCON;
    UINT32 TCNTB0;
    UINT32 TCMPB0;
    UINT32 TCNTO0;
    UINT32 TCNTB1;
    UINT32 TCMPB1;
    UINT32 TCNTO1;
    UINT32 TCNTB2;
    UINT32 TCMPB2;
    UINT32 TCNTO2;
    UINT32 TCNTB3;
    UINT32 TCMPB3;
    UINT32 TCNTO3;
    UINT32 TCNTB4;
    UINT32 TCNTO4;

	/* SMT926 PWM registers */
	// Inserted by DJKIM 2006/09/27
	UINT32	 TDAT0;
	UINT32	 TPRE0;
	UINT32	 TCON0;
	UINT32	 TCNT0;
	UINT32	 TPWM0;

	UINT32	 TDAT1;
	UINT32	 TPRE1;
	UINT32	 TCON1;
	UINT32	 TCNT1;
	UINT32	 TPWM1;

	UINT32	 TDAT2;
	UINT32	 TPRE2;
	UINT32	 TCON2;
	UINT32	 TCNT2;
	UINT32	 TPWM2;

	UINT32	 TDAT3;
	UINT32	 TPRE3;
	UINT32	 TCON3;
	UINT32	 TCNT3;
	UINT32	 TPWM3;

	UINT32	 TDAT4;
	UINT32	 TPRE4;
	UINT32	 TCON4;
	UINT32	 TCNT4;
	UINT32	 TPWM4;

	UINT32	 TDAT5;
	UINT32	 TPRE5;
	UINT32	 TCON5;
	UINT32	 TCNT5;
	UINT32	 TPWM5;

	UINT32	 TDAT6;
	UINT32	 TPRE6;
	UINT32	 TCON6;
	UINT32	 TCNT6;
	UINT32	 TPWM6;

	UINT32	 TDAT7;
	UINT32	 TPRE7;
	UINT32	 TCON7;
	UINT32	 TCNT7;
	UINT32	 TPWM7;

} SMT926A_PWM_REG, *PSMT926A_PWM_REG;

//------------------------------------------------------------------------------

#if __cplusplus
}
#endif

#endif 
