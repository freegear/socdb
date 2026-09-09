/*----------------------------------------------------------
	File Name   : structDef.h
	Description : SDI V5 struct definition header file
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/
#ifndef __STRUCTDEF_H__
#define __STRUCTDEF_H__

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */

#include "sysinc.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

/*--------------------------------------------------------
        Internal flash
--------------------------------------------------------*/
typedef enum {
    FM_ERASE_CHIP           = 0x1,
    FM_ERASE_SECTOR     = 0x2,
    FM_PROGRAM              = 0x4,
    FM_PROGRAM_OPTION   = 0x20
} FM_OPERATION_MODE;

typedef enum {
    OPTION_SMART,
    OPTION_PROTECT_HW,
    OPTION_PROTECT_RD
} FM_OPTION_TYPE;

typedef struct {
    smtUint32 addr;
    smtUint32 data;
    smtUint32 length;
    smtUint32 mode;
} FM_STRUCT;    // Flash memory struct

typedef struct {
    /*
    smtBoolean chipEraseEn;
    smtBoolean sectorEraseEn;
    smtBoolean ProgramEn;
    smtBoolean optionProgEn;
    */
    smtUint8 mode;
    smtBoolean cpuHold;
    smtBoolean operation;
    smtBoolean oscEn;
    smtUint8 waitReg;
} FMC_STRUCT;   // Flash memory controller struct

/*--------------------------------------------------------
        External sram
--------------------------------------------------------*/

/*--------------------------------------------------------
        UART
--------------------------------------------------------*/
typedef enum {
    BAUD_2400 = 2400,
    BAUD_4800 = 4800,
    BAUD_9600 = 9600,
    BAUD_19200 = 19200,
    BAUD_38400 = 38400,
    BAUD_115200 = 115200
} UART_BAUDRATE;

typedef enum {
    SET_UARTLCR,   // Line control set
    GET_UARTLCR,
    //SET_UARTCR,   // UART Tx/Rx
    //GET_UARTCR,
    SET_UARTIFLS,  // Interrupt level set
    GET_UARTIFLS,
    SET_UARTICR,
    SET_UARTIMSC,
    CLR_UARTIMSC,
    GET_UARTIMSC
} UART_MODE;

typedef enum {
    SEND_BREAK_DISABLE,
    SEND_BREAK_ENABLE
} SEND_BREAK_ENUM;

typedef enum {
    PARITY_DISABLE,
    PARITY_ENABLE
} PARITY_EN_ENUM;

typedef enum {
    ODD_PARITY,
    EVEN_PARITY
} PARITY_SEL_ENUM;

typedef enum {
    ONE_STOP_BIT,
    TWO_STOP_BIT
} STOP_SEL_ENUM;

typedef enum {
    FIFO_DISABLE,
    FIFO_ENABLE
} FIFO_EN_ENUM;

typedef enum {
    STICK_PARITY_DISABLE,
    STICK_PARITY_ENABLE
} STICK_PARITY_EN_ENUM;

typedef enum {
    DATA_5BIT,
    DATA_6BIT,
    DATA_7BIT,
    DATA_8BIT
} WORD_LENGTH_ENUM;

typedef enum {
    LOOPBACK,
    TRANSMIT,
    RECEIVE
} UART_OPERATION;

typedef enum {
    INT_LEVEL_1BY8 = 0,
    INT_LEVEL_1BY4,
    INT_LEVEL_1BY2,
    INT_LEVEL_3BY4,
    INT_LEVEL_7BY8
} UART_COMM_INT_LEVEL;

typedef enum {
    MODEM_RI_INT = 0x1,
    MODEM_CTS_INT = 0x2 ,
    MODEM_DCD_INT = 0x4,
    MODEM_DSR_INT = 0x8,

    RX_INT = 0x10,
    TX_INT = 0x20,
    RX_TIMEOUT_INT = 0x40,
    FRAME_ERR_INT = 0x80,
    PARITY_ERR_INT = 0x100,
    BREAK_ERR_INT = 0x200,
    OVERRUN_ERR_INT = 0x400,

    ALL_INT = 0x7ff
} UART_INT;

typedef struct {
    smtBoolean sendBreak;
    smtBoolean parityEn;
    smtBoolean paritySel;
    smtBoolean stopSel;
    smtBoolean fifoEn;
    smtBoolean stickParitySel;
    smtUint8 wordLengh;
} UART_DATA_STRUCT;

typedef struct {
    UART_OPERATION operation;
    smtUint8 txIntLevel;
    smtUint8 rxIntLevel;
    smtUint16 intClear;
    smtUint16 intMask;

    UART_DATA_STRUCT lineCtrl;
} UART_STRUCT;

/*--------------------------------------------------------
        I2C
--------------------------------------------------------*/
typedef enum {
    I2C_CH0,
    I2C_CH1
} I2C_CHANNEL;

typedef struct {
    smtBoolean txClkSel;
    smtUint8 txClk;
    smtUint8 highPeriod;
    smtUint8 slaveAddr;

    smtBoolean channel;
} I2C_STRUCT;

/*--------------------------------------------------------
        Timer & PWM
--------------------------------------------------------*/
typedef enum {
    TIMER_INTERVAL,
    TIMER_CAPTURE,
    TIMER_MATCHOVER,
    TIMER_PWM
} TIMER_MODE;

typedef enum {
    TIMER_SEL0,
    TIMER_SEL1,
    TIMER_SEL2,
    TIMER_SEL3,
    TIMER_SEL4,
    TIMER_SEL5,
    TIMER_SEL6,
    TIMER_SEL7
} TIMER_SEL;

typedef struct {
    smtBoolean phase;
    smtBoolean clk;
    smtUint8 opMode;
    smtBoolean timerClear;
    smtBoolean timerEn;

    smtUint8 prescale;
    smtUint16 data;
} TIMER_STRUCT;

/*--------------------------------------------------------
        WDT
--------------------------------------------------------*/
typedef enum {
    WDT_NO_INT = 0,
    WDT_INT = 1,

    WDT_NO_RST = 0,
    WDT_RST = 1,

    WDT_DISABLE = 0,
    WDT_ENABLE = 1
} WDT_STATE;

typedef struct {
    smtUint8 div;
    smtBoolean clkSel;
    smtBoolean intEn;
    smtBoolean rstEn;
    smtBoolean wdtEn;

    smtUint16 preScale;
    smtUint16 reloadValue;
} WDT_STRUCT;

/*--------------------------------------------------------
        GPIO
--------------------------------------------------------*/
typedef enum {
    GPIO0_TYPE,
    GPIO1_TYPE,
    GPIO2_TYPE,
    GPIO3_TYPE
} GPIO_TYPE;

typedef enum {
    GPIO_MODE0 = 0,
    GPIO_MODE1 = 1,
    GPIO_MODE2 = 2,
    GPIO_MODE3 = 3,

    GPIO0_EINT = 0,
    GPIO0_IN = 1,
    GPIO0_OUT = 2,
    GPIO0_TOUT = 3,

    GPIO1_IN = 0,
    GPIO1_OUT = 1,
    GPIO1_TCAP = 2,
    GPIO1_MEM = 3,

    GPIO2_POUT = 0,
    GPIO2_TOUT = 1,
    GPIO2_IN = 2,
    GPIO2_OUT = 3,

    GPIO3_IN = 0,
    GPIO3_OUT = 1,
    GPIO3_TCLK = 2,
    GPIO3_MEM = 3
} GPIO_MODE;

typedef struct {
    smtUint8 gpioNum;
    smtUint16 gpioMode;
    //smtUint8 gpioData;
} GPIO_STRUCT;

/*--------------------------------------------------------
        VIC
--------------------------------------------------------*/

/*--------------------------------------------------------
        ADC
--------------------------------------------------------*/
typedef enum {
    ADC_NORMAL,
    ADC_STANDBY
} ADC_MODE;

typedef enum {
    ADC_DISABLE,
    ADC_ENABLE
} ADC_OPERATION;

typedef enum {
    ADC_CH0,
    ADC_CH1,
    ADC_CH2,
    ADC_CH3,
    ADC_CH4,
    ADC_CH5,
    ADC_CH6,
    ADC_CH7
} ADC_CHANNEL;

typedef struct {
    smtBoolean adcEnable;
    smtBoolean readStart;
    smtBoolean opMode;
    smtUint8 adcChanSel;

    //smtUint16 adcData;
} ADC_STRUCT;

/*--------------------------------------------------------
        Power Management
--------------------------------------------------------*/
typedef enum {
    PWR_NORMAL,
    PWR_DOWN,
    PWR_SLOW
} POWER_MODE;

typedef struct {
    smtUint8 sclkDiv;
    smtUint8 uclkDiv;
    smtBoolean gie;
    smtBoolean uartIntSel;
    smtUint8 aclkDiv;
} POWER_STRUCT;

#endif  /* __STRUCTDEF_H__ */
