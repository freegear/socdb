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
//  Header:  smt926a_intr.h
//
//  Defines the interrupt controller register layout and associated interrupt
//  sources and bit masks.
//
#ifndef __SMT926A_INTR_H
#define __SMT926A_INTR_H

#if __cplusplus
extern "C" {
#endif

//------------------------------------------------------------------------------
//
//  Type: SMT926A_INTR_REG    
//
//  Interrupt control registers. This register bank is located by the constant 
//  SMT926A_BASE_REG_XX_INTR in the configuration file smt926a_base_reg_cfg.h.
//

typedef struct {
    UINT32 SRCPND;                     // interrupt request status reg
    UINT32 INTMOD;                     // interrupt mode reg
    UINT32 INTMSK;                     // interrupt mask reg
    UINT32 PRIORITY;                   // priority reg
    UINT32 INTPND;                     // interrupt pending reg
    UINT32 INTOFFSET;                  // interrupt offset reg
    UINT32 SUBSRCPND;                  // SUB source pending reg
    UINT32 INTSUBMSK;                  // interrupt SUB mask reg

	/* SMT926 vectored interrupt controller registers */
	// Inserted by DJKIM 2006/09/27
	UINT32	 INTCON;
	//UINT32   INTPND;
	//UINT32   INTMOD;
	//UINT32   INTMSK;
	UINT32   LEVEL;
	UINT32   I_PSLV0;
	UINT32   I_PSLV1;
	UINT32   I_PSLV2;
	UINT32   I_PSLV3;
	UINT32   F_PSLV0;
	UINT32   F_PSLV1;
	UINT32   F_PSLV2;
	UINT32   F_PSLV3;
	UINT32   I_PMST;
	UINT32   F_PMST;
	UINT32   ICSLV0;
	UINT32   ICSLV1;
	UINT32   ICSLV2;
	UINT32   ICSLV3;
	UINT32   F_CSLV0;
	UINT32   F_CSLV1;
	UINT32   F_CSLV2;
	UINT32   F_CSLV3;
	UINT32   I_CMST;
	UINT32   F_CMST;
	UINT32   I_ISPR;
	UINT32   F_ISPR;
	UINT32   I_ISPC;
	UINT32   F_ISPC;
	UINT32   POLARITY;
	UINT32   I_VECADDR;
	UINT32   F_VECADDR;
} SMT926A_INTR_REG, *PSMT926A_INTR_REG;


//------------------------------------------------------------------------------
//
//  Define: IRQ_XXX
//
//  Interrupt sources numbers
//

#define IRQ_EINT0           0           // Arbiter 0
#define IRQ_EINT1           1
#define IRQ_EINT2           2
#define IRQ_EINT3           3

#define IRQ_EINT4_7         4           // Arbiter 1
#define IRQ_EINT8_23        5
#define IRQ_CAM             6
#define IRQ_BAT_FLT         7
#define IRQ_TICK            8
#define IRQ_WDT_AC97        9

#define IRQ_TIMER0          10          // Arbiter 2
#define IRQ_TIMER1          11
#define IRQ_TIMER2          12
#define IRQ_TIMER3          13
#define IRQ_TIMER4          14
#define IRQ_UART2           15

#define IRQ_LCD             16          // Arbiter 3
#define IRQ_DMA0            17
#define IRQ_DMA1            18
#define IRQ_DMA2            19
#define IRQ_DMA3            20
#define IRQ_SDI             21

#define IRQ_SPI0            22          // Arbiter 4
#define IRQ_UART1           23
#define IRQ_NFCON           24
#define IRQ_USBD            25
#define IRQ_USBH            26
#define IRQ_IIC             27

#define IRQ_UART0           28          // Arbiter 5
#define IRQ_SPI1            29
#define IRQ_RTC             30
#define IRQ_ADC             31

#define IRQ_EINT4           32
#define IRQ_EINT5           33
#define IRQ_EINT6           34
#define IRQ_EINT7           35
#define IRQ_EINT8           36
#define IRQ_EINT9           37
#define IRQ_EINT10          38
#define IRQ_EINT11          39
#define IRQ_EINT12          40
#define IRQ_EINT13          41
#define IRQ_EINT14          42
#define IRQ_EINT15          43
#define IRQ_EINT16          44
#define IRQ_EINT17          45
#define IRQ_EINT18          46
#define IRQ_EINT19          47
#define IRQ_EINT20          48
#define IRQ_EINT21          49
#define IRQ_EINT22          50
#define IRQ_EINT23          51


// Interrupt sub-register source numbers
//
#define IRQ_SUB_RXD0     0
#define IRQ_SUB_TXD0     1
#define IRQ_SUB_ERR0     2
#define IRQ_SUB_RXD1     3
#define IRQ_SUB_TXD1     4
#define IRQ_SUB_ERR1     5
#define IRQ_SUB_RXD2     6
#define IRQ_SUB_TXD2     7
#define IRQ_SUB_ERR2     8
#define IRQ_SUB_TC       9
#define IRQ_SUB_ADC      10
#define	IRQ_SUB_CAM_C	 11		// 030610
#define	IRQ_SUB_CAM_P	 12		// 040218, INTSUB_CAM_S - 030610
#define	IRQ_SUB_WDT		 13		// 040218
#define	IRQ_SUB_AC97	 14		// 040218

/* SMT926 Interrupt sources numbers */
// Inserted by DJKIM 2006/09/27
#define IRQ_EINT0			0
#define IRQ_EINT1			1
#define IRQ_EINT2			2
#define IRQ_EINT3			3
#define IRQ_I2C0			4
#define IRQ_I2C0_AAS		5
#define IRQ_TIMER0_TOF		6
#define IRQ_TIMER0_TMC		7
#define IRQ_TIMER1_TOF		8
#define IRQ_TIMER1_TMC		9
                       		
#define IRQ_TIMER2_TOF		10
#define IRQ_TIMER2_TMC		11
//#define IRQ_EINT4			12
//#define IRQ_EINT5			13
//#define IRQ_EINT6			14
//#define IRQ_EINT7			15
#define IRQ_I2C1			16
#define IRQ_I2C1_AAS		17
#define IRQ_WDT				18
//#define IRQ_ADC				19
                       		
#define IRQ_UARTRX			20
#define IRQ_UARTTX			21
#define IRQ_TIMER3_TOF		22
#define IRQ_TIMER3_TMC		23
#define IRQ_TIMER4_TOF		24
#define IRQ_TIMER4_TMC		25
#define IRQ_TIMER5_TOF		26
#define IRQ_TIMER5_TMC		27
#define IRQ_TIMER6_TOF		28
#define IRQ_TIMER6_TMC		29
                       		
#define IRQ_TIMER7_TOF		30
#define IRQ_TIMER7_TMC		31
//------------------------------------------------------------------------------

#if __cplusplus
}
#endif

#endif 
