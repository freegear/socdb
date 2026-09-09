/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: init.c
	Description	: Peri initialize file
	Created by	: SHMT SOC Team
----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "structdef.h"
#include "commonmacro.h"

#include "global.h"
#include "lib.h"
#include "uart_pre_drv.h"

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
#if 0//shkim-20070109 : remove this function
/*----------------------------------------------------------
	Function name	: InitUart()
	Prototype		: void InitUart(void)
	Return			: 
	Argument		:
	Comments		: 
		UART initialize
----------------------------------------------------------*/
void InitUart(void)
{

	UART_STRUCT uartInit;
	smtUint8 crash;
	
	SMT_WRITE(PM_CLKDIV, 
		0<<SHIFT_DN_FROM_MASK(PM_UCLK_DIV));// Uart clock divider : HCLK

	/*
		smtUartSetMode();
		
		1. Baud-rate setting
		2. Line control setting
		3. Control setting
		4. Rx/Tx interrupt level setting
		5. Rx FIFO flush
		6. Interrupt status flag clear
		7. Interrupt mask setting
		
		UARTIBRD/UARTFBRD
		
		UARTLCR_H
		UARTCR TxEn/RxEn/UartEn
		UARTIFLS
		
		UARTICR
		UARTIMSC
	*/
	smtUartSetBaudRate(BAUD_9600);
	
	uartInit.lineCtrl.fifoEn = FIFO_ENABLE;
	uartInit.lineCtrl.parityEn = PARITY_DISABLE;
	uartInit.lineCtrl.paritySel = ODD_PARITY;
	uartInit.lineCtrl.sendBreak = SEND_BREAK_DISABLE;
	uartInit.lineCtrl.stickParitySel = STICK_PARITY_DISABLE;
	uartInit.lineCtrl.stopSel = ONE_STOP_BIT;
	uartInit.lineCtrl.wordLengh = DATA_8BIT;
	smtUartSetMode(&uartInit, SET_UARTLCR);

	// UARTCR register setting
	UART_RX_ENABLE(UARTCR, RX_EN);      // Rx enable
	UART_TX_ENABLE(UARTCR, TX_EN);      // Tx enable
	UART_LOOPBACK_DISABLE(UARTCR, LOOP_BACK_EN);    // Loop-back disable
	UART_DIASBLE(UARTCR, UART_EN);      // Uart disable
	
	// Empty the receive FIFO
	while((SMT_READ(UARTFR)&RXFIFO_EMPTY) != RXFIFO_EMPTY)
		crash = (smtUint8)SMT_READ(UARTDR);
	
	uartInit.rxIntLevel = INT_LEVEL_1BY2;
	uartInit.txIntLevel = INT_LEVEL_1BY2;
	uartInit.intClear = ALL_INT;
	uartInit.intMask = ALL_INT;
	smtUartSetMode(&uartInit, SET_UARTIFLS);
	smtUartSetMode(&uartInit, SET_UARTICR);
	smtUartSetMode(&uartInit, CLR_UARTIMSC);

	// UART ISR register
}
#endif
/*----------------------------------------------------------
	Function name	: InitI2C()
	Prototype		: void InitI2C(void)
	Return			: 
	Argument		:
	Comments		: 
		I2C initialize
----------------------------------------------------------*/
void InitI2C(void)
{
#ifdef USE_I2C_OLD_VER
	// Need to coding real gpio initial value
	
	gI2C.txClkSel = 0;
	gI2C.txClk = 0;
	gI2C.highPeriod = 0x15;
	//gI2C.slaveAddr = ;
	gI2C.channel = I2C_CH0;
	smtI2CSetMode(gI2C);
	
	//gI2C.slaveAddr = ;
	gI2C.channel = I2C_CH1;
	smtI2CSetMode(gI2C);
#endif    
}

/*----------------------------------------------------------
	Function name	: InitTimer()
	Prototype		: void InitTimer(void)
	Return			: 
	Argument		:
	Comments		: 
		Timer&PWM initialize
----------------------------------------------------------*/
void InitTimer(void)
{
	// Need to coding real gpio initial value
	
	SMT_WRITE(TCON0, 
		0<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR) |
		0<<SHIFT_DN_FROM_MASK(TIMER_EN) );
	SMT_WRITE(TPRE0, 0xff);

	SMT_WRITE(TCON1, 
		0<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR) |
		0<<SHIFT_DN_FROM_MASK(TIMER_EN) );
	SMT_WRITE(TPRE1, 0xff);
	
	SMT_WRITE(TCON2, 
		0<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR) |
		0<<SHIFT_DN_FROM_MASK(TIMER_EN) );
	SMT_WRITE(TPRE2, 0xff);

	SMT_WRITE(TCON3, 
		0<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR) |
		0<<SHIFT_DN_FROM_MASK(TIMER_EN) );
	SMT_WRITE(TPRE3, 0xff);
	
	SMT_WRITE(TCON4, 
		0<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR) |
		0<<SHIFT_DN_FROM_MASK(TIMER_EN) );
	SMT_WRITE(TPRE4, 0xff);

	SMT_WRITE(TCON5, 
		0<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR) |
		0<<SHIFT_DN_FROM_MASK(TIMER_EN) );
	SMT_WRITE(TPRE5, 0xff);
	
	SMT_WRITE(TCON6, 
		0<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR) |
		0<<SHIFT_DN_FROM_MASK(TIMER_EN) );
	SMT_WRITE(TPRE6, 0xff);
	
	SMT_WRITE(TCON7, 
		0<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) |
		0<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR) |
		0<<SHIFT_DN_FROM_MASK(TIMER_EN) );
	SMT_WRITE(TPRE7, 0xff);
}

/*----------------------------------------------------------
	Function name	: InitGpio()
	Prototype		: void InitGpio(void)
	Return			: 
	Argument		:
	Comments		: 
		GPIO initialize
----------------------------------------------------------*/
void InitGpio(void)
{
	// Need to coding real gpio initial value

	/*
	GPIO_STRUCT gpio;
	
	gpio.gpioNum = GPIO_CON0;
	gpio.gpioMode = GPIO0_EINT;
	smtGPIOSetDir(gpio);
	
	gpio.gpioNum = GPIO_CON1;
	gpio.gpioMode = GPIO1_IN;
	smtGPIOSetDir(gpio);
	
	gpio.gpioNum = GPIO_CON2;
	gpio.gpioMode = GPIO2_POUT;
	smtGPIOSetDir(gpio);
	
	gpio.gpioNum = GPIO_CON3;
	gpio.gpioMode = GPIO3_IN;
	smtGPIOSetDir(gpio);
	*/
}

/*----------------------------------------------------------
	Function name	: InitAdc()
	Prototype		: void InitAdc(void)
	Return			: 
	Argument		:
	Comments		: 
		ADC initialize
		SYSCON regsiter - adc clock division
		ADCCON register - A/D enable, Read start, Standby mode, ADC channel setting
----------------------------------------------------------*/
void InitAdc(smtUint8 adcClkDiv)
{
	// Need to coding real gpio initial value
	
	SMT_WRITE(PM_CLKDIV, SMT_READ(PM_CLKDIV) |
		adcClkDiv<<SHIFT_DN_FROM_MASK(PM_ACLK_DIV));
	
	SMT_WRITE(ADCCON, 
		0<<SHIFT_DN_FROM_MASK(ADENABLE) |		// No operation
		1<<SHIFT_DN_FROM_MASK(ADC_READ_START) | // Read start
		1<<SHIFT_DN_FROM_MASK(ADC_STBY) |		// Standby mode
		0<<SHIFT_DN_FROM_MASK(ADC_IN_SEL) );	// ADC channel 0
}

/*----------------------------------------------------------
	Function name	: InitPower()
	Prototype		: void InitPower(void)
	Return			: 
	Argument		:
	Comments		: 
		Power management initialize
		SYSCON register - normal operation, System clock divider, GIE enable
----------------------------------------------------------*/
void InitPower(void)
{
	// Need to coding real gpio initial value

	// TODO :
	// Other power management setting
	SMT_WRITE(PM_CLKDIV, SMT_READ(PM_CLKDIV) |
		0<<SHIFT_DN_FROM_MASK(PM_SCLK_DIV) );	// System bus clock
}
