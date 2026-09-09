/*
 * Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 1999,2000,2001 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     apuart.h,v
 * Revision: 1.47
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : apuart.h.rca
 *  File Revision          : 1.2
 * 
 *  Release Information    : PrimeCell(TM)-PL011-REL2v0
 *  ----------------------------------------
 *
 * Public header for UART interface.
 */


#ifndef apUART_H
#define apUART_H

#ifdef __cplusplus
extern "C" { /* allow C++ to use these headers */
#endif /* __cplusplus */

#if 0	/* holelee */
/*
 * The UART present on the Integrator AP is a variant of PL010 and should be
 * selected by setting apVERSION_UART equal to the value below
 */
#define apUART_VERS_AP 1

#ifndef apUART_VERSION
#define apUART_VERSION apUART_VERS_AP
#endif
#else
#define apUART_VERS_AP 1
#define apUART_VERSION	11
#endif

/*
 * Description:
 * Word length enumerated type. Used in apUART_sConfigData type.
 */
typedef enum apUART_xWordLength
{
    apUART_BITS_5,    // 5 bits.
    apUART_BITS_6,    // 6 bits.
    apUART_BITS_7,    // 7 bits.
    apUART_BITS_8     // 8 bits.
}
apUART_eWordLength;


/*
 * Description:
 * Stop bits enumerated type. Used in apUART_sConfigData type.
 */
typedef enum apUART_xStopBits
{
    apUART_ONE_STOP_BIT,     // One stop bit.
    apUART_TWO_STOP_BITS     // Two stop bits.
}
apUART_eStopBits;


/*
 * Description:
 * Parity select enumerated type. Used with apUART_sConfigData type.
 */
typedef enum apUART_xParitySelect
{
    apUART_NO_PARITY,      // Parity checking disabled.
    apUART_ODD_PARITY,     // Odd parity checking.
    apUART_EVEN_PARITY=3   // Even parity checking.
}
apUART_eParitySelect;


/*
 * Description:
 * (n/a for PL010). Stick parity select enumerated type. Used in apUART_sConfigData type.
 */
typedef enum apUART_xStickParityEnable
{
    apUART_STICK_DISABLED,   // Stick parity disabled.
    apUART_STICK_ENABLED     // Stick parity enabled.
}
apUART_eStickParityEnable;


/*
 * Description:
 * Loop back enable enumerated type. Used in apUART_sConfigIR type.
 */
typedef enum apUART_xLoopBackEnable
{
    apUART_LOOPBACK_DISABLED,   // Loop back disabled.
    apUART_LOOPBACK_ENABLED     // Loop back enabled.
}
apUART_eLoopBackEnable;


/*
 * Description:
 * Low power mode enumerated type. When set to low power mode, low-level bits
 * are transmitted with a pulse width 3 times the period of the low power baud setting,
 * LowPowerBaud16, regardless of the selected bit rate.  This setting uses less power,
 * but might reduce the transmission distance.
 * Used in apUART_sConfigPower type.
 */
typedef enum apUART_xLowPowerMode
{
    apUART_MODE_NORMAL,       // Normal power mode.
    apUART_MODE_LOW_POWER     // Low power mode.
}
apUART_eLowPowerMode;


/*
 * Description:
 * SIR enable. When enabled, data is transmitted and received
 * on nSIROUT and SIRIN. When disabled, nSIROUT remains clear,
 * and signal transitions on SIRIN have no effect.
 * Used in apUART_sConfigIR type.
 */
typedef enum apUART_xSIREnable
{
    apUART_SIR_DISABLED,   // SIR disabled.
    apUART_SIR_ENABLED     // SIR enabled.
}
apUART_eSIREnable;


/*
 * Description:
 * FIFO level select. Sets trigger levels for Transmit and Receive interrupts.
 * Used in apUART_sConfigFIFOs type.
 */
typedef enum apUART_xFIFOLevelSelect
{
    apUART_ONEEIGHTH,      // receive FIFO >= 1/8 full ( <= 1/8 for transmit).
    apUART_ONEQUARTER,     // receive FIFO >= 1/4 full ( <= for transmit).
    apUART_HALF,           // receive FIFO >= 1/2 full ( <= for transmit).
    apUART_THREEQUARTERS,  // receive FIFO >= 3/4 full ( <= for transmit).
    apUART_SEVENEIGHTHS    // receive FIFO >= 7/8 full ( <= 7/8 for transmit).
}
apUART_eFIFOLevelSelect;

/*
 * Description:
 * (n/a for PL010). Hardware flow control enumerated type.  Used in apUART_sConfigData type.
 */
typedef enum apUART_xHWFlowSelect
{
    apUART_HWFLOW_NONE,     // Hardware flow control disabled.
    apUART_HWFLOW_RTS_ONLY, // Hardware flow control of incoming data.
    apUART_HWFLOW_CTS_ONLY, // Hardware flow control of outgoing data.
    apUART_HWFLOW_ALL       // Hardware flow control fully enabled.
}
apUART_eHWFlowSelect;


/*
 * Description:
 * Data Carrier Detect (DCD) setting state control. Used in apUART_DCDConfigGet and apUART_DCDConfigSet.
 */
typedef enum apUART_xDCDEnable
{
    apUART_DCD_DISABLED, 
    apUART_DCD_ENABLED      //DCD asserted.
}
apUART_eDCDEnable;

/*
 * Description:
 * (n/a for PL010). Ring Indicator (RI) setting state control. Used in apUART_RIConfigSet and apUART_RIConfigGet.
 */
typedef enum apUART_xRIEnable
{
    apUART_RI_DISABLED, 
    apUART_RI_ENABLED      //RI asserted.
}
apUART_eRIEnable;

/*
 * Description:
 * (n/a for PL010). Request To Send (RTS) setting state control. Used in apUART_RTSConfigSet and apUART_RTSConfigGet.
 */
typedef enum apUART_xRTSEnable
{
    apUART_RTS_DISABLED,
    apUART_RTS_ENABLED     //RTS asserted.
}
apUART_eRTSEnable;

/*
 * Description:
 * Data Transmit Ready (DTR) setting state control. Used in apUART_DTRConfigGet and apUART_DTRConfigSet.
 */
typedef enum apUART_xDTREnable
{
    apUART_DTR_DISABLED,
    apUART_DTR_ENABLED     //DTR asserted.
}
apUART_eDTREnable;


/*
 * Description:
 * (n/a for PL010). Enumerated type for use in defining and comparing against a bitmask
 * to set and retrieve the Modem interrupt mask.  Used in apUART_ModemIntSet and apUART_ModemIntGet.
 */
typedef enum apUART_xModemEnable
{
    apUART_MODEM_INT_DISABLE = 0x0,  // Disable all the Modem interrupts.
    apUART_MODEM_INT_RI = 0x1,       // Enable/disable RI interrupt if supported (n/a for PL010).
    apUART_MODEM_INT_CTS = 0x2,      // Enable/disable CTS interrupt if supported (n/a for PL010).
    apUART_MODEM_INT_DCD = 0x4,      // Enable/disable DCD interrupt if supported (n/a for PL010).
    apUART_MODEM_INT_DSR = 0x8,      // Enable/disable DSR interrupt if supported (n/a for PL010).
    apUART_MODEM_INT_ENABLE = 0xF    // Enable all the Modem interrupts.
}
apUART_eModemEnable;


/*
 * Description:
 * Enumerated type for use in comparing against the bitmask
 * apUART_ModemStatusGet returns.
 */
typedef enum apUART_xModemFlags
{
    apUART_MODEM_FLAG_CTS = 0x1,     // CTS asserted.
    apUART_MODEM_FLAG_DSR = 0x2,     // DSR asserted.
    apUART_MODEM_FLAG_DCD = 0x4,     // DCD asserted.
    apUART_MODEM_FLAG_RI = 0x100     // RI asserted (n/a for PL010).
}
apUART_eModemFlags;

/*
 * Description:
 * (n/a for PL010).
 * Enumerated type for use in defining a bitmask to mask Error Interrupts (apUART_ErrorIntSet)
 * and comparing against the bitmask returned by apUART_ErrorIntGet to view the current Error Interrupt masking.
 */
typedef enum apUART_xErrorEnable
{
    apUART_ERROR_INT_FRAMING = 0x1,  // Framing error enable/disable.
    apUART_ERROR_INT_PARITY = 0x2,   // Parity error enable/disable.
    apUART_ERROR_INT_BREAK = 0x4,    // Break error enable/disable.
    apUART_ERROR_INT_OVERRUN = 0x8   // Overrun error enable/disable.
}
apUART_eErrorEnable;


/*
 * Description:
 * Enumerated type for use in comparing against the value returned
 * by apUART_Read for manual polling of errors (n/a for PL010).
 */
typedef enum apUART_xErrorFlags
{
    apUART_ERROR_FLAG_FRAMING = 0x100, // Framing error detection.
    apUART_ERROR_FLAG_PARITY = 0x200,  // Parity error detection.
    apUART_ERROR_FLAG_BREAK = 0x400,   // Break error detection.
    apUART_ERROR_FLAG_OVERRUN = 0x800  // Overrun error detection.
}
apUART_eErrorFlags;


/*
 * Description:
 * Enumerated type for use in comparing against the bitmask
 * apUART_ErrorStatusGet returns. (Primarily used for PL010).
 */
typedef enum apUART_xErrorStatusFlags
{
    apUART_ERROR_STATUS_FLAG_FRAMING = 0x1, // Framing error detection.
    apUART_ERROR_STATUS_FLAG_PARITY = 0x2,  // Parity error detection.
    apUART_ERROR_STATUS_FLAG_BREAK = 0x4,   // Break error detection.
    apUART_ERROR_STATUS_FLAG_OVERRUN = 0x8  // Overrun error detection.
}
apUART_eErrorStatusFlags;

 
/*
 * Description:
 * UART port activity information, which is passed from the Interrupt Service Routine to the
 * user-defined apUART_rListener function. 
 */
typedef enum apUART_xListenerMessage
{
    apUART_DATA_ARRIVED,            // Incoming data without an apUART_Receive action setup to receive the data.
    apUART_DEVICE_CHANGED,          // A modem signal has changed (PL010 only).
    apUART_DEVICE_CHANGED_RI,       // Modem has signalled RI change in state (n/a for PL010).
    apUART_DEVICE_CHANGED_CTS,      // Modem has signalled CTS change in state (n/a for PL010).
    apUART_DEVICE_CHANGED_DCD,      // Modem has signalled DCD change in state (n/a for PL010).
    apUART_DEVICE_CHANGED_DSR       // Modem has signalled DSR change in state (n/a for PL010).
}
apUART_eListenerMessage;


/*
 * Description:
 * General error reporting type for this module.  Errors are returned typecast
 * to the general error type apError. 
 */
typedef enum apUART_xError
{
    apUART_NO_BUFFER=apERR_UART_START,  // No pBuffer specified for transmitting or receiving data.
    apUART_BUFFER_FULL,                 // Receiving data buffer is full.
    apUART_FIFO_FULL,                   // Cannot write as Tx FIFO is full
    apUART_FIFO_EMPTY,                  // Cannot read as Rx FIFO is empty
    apUART_SIZE_ZERO,                   // Buffer of size zero.
    apUART_ERROR_FRAME,                 // Framing error (n/a to PL010).
    apUART_ERROR_PARITY,                // Parity error (n/a to PL010).
    apUART_ERROR_BREAK,                 // Break error (n/a to PL010).
    apUART_ERROR_OVERRUN,               // Overrun error (n/a to PL010).
    apUART_IN_USE,                      // UART is busy.
    apUART_INVALID_BAUD_RATE            // Unable to generate divisor for required baud rate
}
apUART_eError;


/*
 * Description:
 * This specifies the DMA mode options. Valid for PL011 only.
 */
typedef enum apUART_xDMAMode
{
    apUART_DMA_TX_ON = 1,
    apUART_DMA_TX_OFF,
    apUART_DMA_RX_ON,
    apUART_DMA_RX_OFF 
}
apUART_eDMAMode;

/*
 * Description:
 * (n/a for PL010). UART FIFO configuration data. Used with apUART_FIFOConfigSet and apUART_FIFOConfigGet.
 *
 * Implementation:
 * This structure is used with apUART_FIFOConfigSet and apUART_FIFOConfigGet to configure the
 * UART's FIFO levels for transmit and receive interrupt triggering.
 */
typedef struct apUART_xConfigFIFOs
{
    apUART_eFIFOLevelSelect        eReceiveFIFOLevel;   // Receive FIFO interrupt level setting.
    apUART_eFIFOLevelSelect        eTransmitFIFOLevel;  // Transmit FIFO interrupt level setting.
}
apUART_sConfigFIFOs;


/*
 * Description:
 * UART data transfer configuration data. Used with apUART_DataConfigSet and apUART_DataConfigGet.
 *
 * Implementation:
 * This structure is used with apUART_DataConfigSet and apUART_DataConfigGet to configure the
 * UART's line control parameters.
 */
typedef struct apUART_xConfigData
{
    apUART_eWordLength             eWordLen;           // Word length (5, 6, 7 or 8 bits).
    apUART_eStopBits               eStopBits;          // Number of stop bits to send (one or two).
    apUART_eParitySelect           eParitySelect;      // Parity select (odd, even or disabled).
    apUART_eStickParityEnable      eStickParity;       // Stick parity enable/disable where supported (ignored for PL010).
    apUART_eHWFlowSelect           eHWFlowSelect;      // Hardware flow enable/disable control where supported (ignored for PL010).
}
apUART_sConfigData;


/*
 * Description:
 * UART low power configuration data. Used with apUART_PowerConfigSet and apUART_PowerConfigGet.
 *
 * Implementation:
 * This structure is used with apUART_PowerConfigSet and apUART_PowerConfigGet to configure the
 * UART's IrDA power saving features.
 */
typedef struct apUART_xConfigPower
{
    UWORD32                   LowPowerBaud16;         // Low power baud rate.
    apUART_eLowPowerMode      eLowPowerMode;          // Low power mode.
}
apUART_sConfigPower;


/*
 * Description:
 * UART IR configuration data. Used with apUART_IRConfigSet and apUART_IRConfigGet.
 *
 * Implementation:
 * This structure is used with apUART_IRConfigSet and apUART_IRConfigGet to configure the
 * UART's IrDA SIR capabilities.
 */
typedef struct apUART_xConfigIR
{
    apUART_eLoopBackEnable         eLoopBackEnable;        //  Loop back enable.
    apUART_eSIREnable              eSIREnable;             //  SIR enable.
}
apUART_sConfigIR;


/*
 * Description:
 * Callback for apUART_Transmit and apUART_Receive indicating completion of the action or an error.
 * The interrupt service routine calls this function with a message regarding the current transmit
 * or receive action setup by apUART_Transmit and apUART_Receive.
 *
 * Implementation:
 * Parameters are the UART identifier, Id, and the apUART_eError code, ErrorMessage, pertaining to the last transfer.
 * ErrorMessage should be checked against:
 * + apERR_NONE if successful - for apUART_Receive callbacks it is recommended that the
 * user calls apUART_ReceiveStatusGet to see what length of pBuffer contains data.
 * For apUART_Transmit this message indicates the transmission has completed.
 * If transmission hasn't ended another apUART_Receive call should be intiated or apUART_Continue or apUART_TerminateReceive. 
 * + apUART_BUFFER_FULL if pBuffer has been filled up (apUART_Receive only).
 * + apUART_ERROR_FRAME if there has been a framing error (apUART_Receive only).
 * + apUART_ERROR_PARITY if there has been a parity error (apUART_Receive only).
 * + apUART_ERROR_BREAK if there has been a break error (apUART_Receive only).
 * + apUART_ERROR_OVERRUN if there has been an overrun error (apUART_Receive only).
 */
typedef void (*apUART_rCallback) (UWORD32 Id, apError ErrorMessage);


/*
 * Description:
 * Callback for apUART_CallbackSet.  This function is called under interrupts if a receive action is not underway and data arrives
 * (ie. no apUART_rCallback function registered), or if there is a change in modem status.
 *
 * Implementation:
 * Parameters are the UART identifier, Id, and apUART_eListenerMessage information, eMessage, pertaining to the change in UART status.
 * eMessage should be checked against:
 * + apUART_DATA_ARRIVED - if data has arrived and the UART is not already setup to
 * read the data.
 * + apUART_DEVICE_CHANGED - if a modem status interrupt has occurred (PL010 only).
 * + apUART_DEVICE_CHANGED_RI - if a RI status interrupt has ocurred (n/a for PL010).
 * + apUART_DEVICE_CHANGED_CTS - if a CTS status interrupt has ocurred (n/a for PL010).
 * + apUART_DEVICE_CHANGED_DCD - if a DCD status interrupt has ocurred (n/a for PL010).
 * + apUART_DEVICE_CHANGED_DSR - if a DSR status interrupt has ocurred (n/a for PL010).
 */
typedef void (*apUART_rListener) (UWORD32 Id, apUART_eListenerMessage eMessage);


/*
 * Description:
 * UART initialization data. Used with apUART_Initialize.
 *
 * Implementation:
 * These are device parameters which are either defined by the system hardware
 * or are not intended to be altered except through rebuilding the system.
 */
typedef struct apUART_xInitialData
{
  UWORD32 FIFOSize;       /* Size of Rx FIFO in bytes.*/
  UWORD32 ClockFrequency; /* Reference clock frequency applied to UARTCLK */
}
apUART_sInitialData;


 /*
  * Description:
  * This is the raw interrupt handler for the module, to be called directly
  * from the interrupt vector
  *
  * Note:
  * NOT FOR GENERAL USE.  This routine should only be executed as a branch from the IRQ vector
  *
  * Inputs:
  * none
  *
  * Outputs:
  * none
  *
  * Return Value:
  * none
  */
// holelee PUBLIC IRQ void apUART_RawISR(void);
PUBLIC void apUART_RawISR(void);

 /*
  * Description:
  * This is the standard interrupt handler for the module
  *
  * Note:
  * NOT FOR GENERAL USE.  This routine should only be called by an interrupt dispatcher
  *
  * Inputs:
  * oInterruptId - the ID of the interrupt
  * DeviceId - Identifier for the instance of the driver
  *
  * Outputs:
  * none
  *
  * Return Value:
  * none
  */
PUBLIC void apUART_IntHandler(CONST apOS_INT_oInterruptSource oInterruptId, UWORD32 DeviceId);

/*
 * Description:
 * Finds the amount of space required for driver state data
 *
 * Implementation:
 * This function is required if apOS_NO_STATIC_STATE is defined as TRUE
 * as it will retrieve the size required for storage of the driver
 * state data
 *
 * Inputs:
 * none
 * 
 * Outputs:
 * none
 *
 * Return Value:
 * size (in bytes) required.
 */
PUBLIC UWORD32 apUART_StateSizeGet(void);

/*
 * Description:
 * Initializes the UART.
 *
 * Implementation:
 * The initialization routine carries out the following:
 * + Stores the UART's base address and interrupt Id.
 * + Removes any registered callbacks.
 * + Disables UART, SIR, IrDA low power and loop back.
 * + Sets word length to 8, enables the FIFOs ilo 1 byte registers,
 * one stop bit, no parity and send break = 0.
 * + Empties any data in the receive FIFO.
 * + Where supported - enables transmit and receive sections, deasserts
 * DTR, RTS, DCD (Out1) and RI(Out2), disables stick parity and HW flow control. 
 *
 * Inputs:
 * Id - UART to initialize.
 * eBase - base address of UART registers.
 * Interrupts - Number of interrupt events recognised by handler.
 * pSources - Pointer to the array of interrupt events handled.
 * pInitial - Pointer to the initalisation data, containing the FIFO size.
 */
PUBLIC void apUART_Initialize (apOS_UART_oId Id,
                               apOS_System_eBaseAddress eBase,
                               UWORD32 Interrupts,
                               CONST apOS_INT_oInterruptSource * pSources,
                               CONST apUART_sInitialData *pInitial);


/* ---------------------------------------------------------------------------
 * Description:
 * Sets the DMA mode.
 *
 * Implementation:
 * Sets or clears the DMA enable bit in the dma control register
 * 
 * Inputs:
 * oId     - UART device identifier
 * DMAMode - Required state of DMA control bit
 *
 * Outputs:
 * None
 *
 * Return Value:
 * apERR_NONE if successful.
 * apERR_UNSUPPORTED if unsupported by hardware (PL011 only).
 */
PUBLIC apError apUART_DMAModeSet(apOS_UART_oId oId, apUART_eDMAMode eDMAMode);

/* ---------------------------------------------------------------------------
 * Description:
 * Gets the address of data register for use by the DMA controller.
 *
 * Implementation:
 * Returns address of data register
 * 
 * Inputs:
 * oId     - UART device identifier
 *
 * Outputs:
 * None
 *
 * Return Value:
 * Data register address
 */
PUBLIC UWORD32 apUART_DMAAddressGet(apOS_UART_oId oId);


/*
 * Description:
 * Enables the UART.
 *
 * Implementation:
 * The specified UART's FIFOs, all the interrupts excluding transmit and
 * the UART itself are enabled.
 *
 * Input:
 * Id - selects the UART to be enabled.
 */
PUBLIC void apUART_Enable(apOS_UART_oId Id);


/*
 * Description:
 * Disables the UART.
 *
 * Implementation:
 * The specified UART is disabled.  This call should be invoked before any configuration
 * changes
 *
 * Input:
 * Id - selects the UART to be disabled.
 */
PUBLIC void apUART_Disable(apOS_UART_oId Id);


/*
 * Description:
 * Enables UART transmit ability. (n/a for PL010 and Integrator variants)
 *
 * Implementation:
 * Sets the Transmit Enable bit in the control register.
 *
 * Input:
 * Id - selects the UART to be referenced.
 *
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (PL010).
 */
PUBLIC apError apUART_TxEnable(apOS_UART_oId Id);


/*
 * Description:
 * Disables the UART's transmit ability. (n/a for PL010 and Integrator variants)
 *
 * Implementation:
 * Clears the Transmit Enable bit in the control register. Transmission of the current
 * byte will complete before transmit is disabled.
 *
 * Input:
 * Id - selects the UART to be referenced.
 *
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (PL010).
 */
PUBLIC apError apUART_TxDisable(apOS_UART_oId Id);


/*
 * Description:
 * Returns a boolean indicating if the Transmit FIFO is empty.
 * Primarily for use in conjunction with apUART_Write_N when
 * writing FIFO-size blocks of data.
 *
 * Implementation:
 * Checks the flag register to see if the Transmit FIFO is empty.
 *
 * Input:
 * Id - selects the UART to be referenced.
 *
 * Returns:
 * + TRUE if the Transmit FIFO is empty.
 * + FALSE if the Transmit FIFO is not empty.
 *
 */
PUBLIC BOOL apUART_TxFIFOEmpty(apOS_UART_oId Id);


/*
 * Description:
 * Enables the UART's receive ability. (n/a for PL010 and Integrator variants)
 *
 * Implementation:
 * Sets the Receive Enable bit in the control register.
 *
 * Input:
 * Id - selects the UART to be referenced.
 *
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (PL010).
 */
PUBLIC apError apUART_RxEnable(apOS_UART_oId Id);


/*
 * Description:
 * Disables the UART's receive ability. (n/a for PL010 and Integrator variants)
 *
 * Implementation:
 * Clears the Receive Enable bit in the control register. Receipt of the current 
 * byte will complete before the receive section is actually disabled.
 *
 * Input:
 * Id - selects the UART to be referenced.
 *
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (PL010).
 */
PUBLIC apError apUART_RxDisable(apOS_UART_oId Id);


/*
 * Description:
 * Enables FIFOs for given UART.
 *
 * Implementation:
 * The specified UART FIFOs are enabled by setting the relevant bit
 * in the LineCon_H register.
 *
 * Input:
 * Id - selects the UART to be referenced.
 */
PUBLIC void apUART_FIFOEnable(apOS_UART_oId Id);


/*
 * Description:
 * Disables FIFOs for a given UART.
 *
 * Implementation:
 * The specified UART's FIFOs are disabled by setting the relevant bit
 * in the LineCon_H register.
 *
 * Input:
 * Id - selects the UART to be referenced.
 */
PUBLIC void apUART_FIFODisable(apOS_UART_oId Id);


/*
 * Description:
 * Configures the UART to a specific Baud rate.
 *
 * Implementation:
 * Sets the Baud rate divisor based on a local copy of the clock frequency
 *
 * Inputs:
 * Id - UART Id.
 * Rate  - Baud rate in bps.
 *
 * Returns:
 * apERR_NONE if successful in setting up receive actions.
 * apUART_INVALID_BAUD_RATE if unable to set divisor for required baud rate
 */
PUBLIC apError apUART_BaudRateSet(apOS_UART_oId Id, UWORD32 Rate);


/*
 * Description:
 * Returns the Baud rate that the UART is operating at.
 *
 * Implementation:
 * Complement of apUART_BaudRateSet. Reads the Baud rate divisor and uses
 * a local copy of the clock frequency to calculate the UART Baud rate
 *
 * Inputs:
 * Id - UART Id.
 * Rate  - Baud rate in bps.
 */
PUBLIC UWORD32 apUART_BaudRateGet(apOS_UART_oId Id);


/*
 * Description:
 * Begin sending data to the UART for transmission under interrupt control.
 *
 * Implementation:
 * Starts off data transfer and sets up the Transmit interrupt to keep the Tx FIFO fed.
 * The Transmit interrupt is disabled when the transfer has completed.
 *
 * Inputs:
 * Id - UART Id.
 * pBuffer - pointer to the buffer with the data to be transmitted.
 * Size - the size of data to transmit in bytes.
 * rCallback - pointer to a notification function that apUART_Transmit has finished.
 *
 * Returns:
 * + apERR_NONE if successful in setting up transmit actions.
 * + apUART_IN_USE if the UART is already transmitting data.
 * + apUART_NO_BUFFER if pBuffer is aNULL.
 * + apUART_SIZE_ZERO if the transmit size is 0.
 */
PUBLIC apError apUART_Transmit(apOS_UART_oId Id, void *pBuffer, UWORD32 Size, apUART_rCallback rCallback);


/*
 * Description:
 * Begin receiving data from the UART under interrupt control.
 *
 * Implementation:
 * Starts off data fetch and sets up interrupts to keep FIFOs from getting full.
 * A Timer should be set before calling this function with a call to 
 * apUART_TerminateReceive and rCallback to ensure the UART doesn't
 * wait for data forever, with rCallback passed apERR_NONE.
 * 
 * Inputs:
 * Id - UART Id.
 * pBuffer - pointer to the data buffer that will store the received data.
 * Size - the size of data to receive in bytes.
 * rCallback - notification function to call when apUART_Receive has finished.
 *
 * Returns:
 * + apERR_NONE if successful in setting up receive actions.
 * + apUART_IN_USE if the UART is already receiving data.
 * + apUART_NO_BUFFER if pBuffer is aNULL.
 * + apUART_SIZE_ZERO if the read size is 0.
 */
PUBLIC apError apUART_Receive(apOS_UART_oId Id, void *pBuffer, UWORD32 Size, apUART_rCallback rCallback);


/*
 * Description:
 * Used to resume receiving data under interrupts if the port times out before
 * the required message length has been received (ie. rCallback routine informed of apERR_NONE but
 * apUART_ReceiveStatusGet informs the user that there is still more than the expected amount of buffer space left).
 *
 * Implementation:
 * Resumes previous transfer.
 *
 * Inputs:
 * Id - UART Id.
 *
 * Returns:
 * + apERR_NONE if successful.
 * + apUART_IN_USE if the UART is already receiving data.
 */
PUBLIC apError apUART_Continue(apOS_UART_oId Id);


/*
 * Description:
 * Read a byte of data and any error conditions from the UART (error conditions n/a for PL010).
 *
 * Implementation:
 * Fetches a byte of data from the FIFO and any associated error conditions.  The returned value should be
 * compared to the enumerated type of apUART_eErrorFlags if errors to be detected without interrupts.
 *
 * Inputs:
 * Id - UART Id.
 *
 * Returns:
 * + Data value and error conditions read from UART (errors n/a for PL010).
 * + apUART_FIFO_EMPTY if there is no data waiting.
 * + apUART_IN_USE if the UART is already in use.
 */
PUBLIC UWORD32 apUART_Read(apOS_UART_oId Id);


/*
 * Description:
 * Send a byte of data to UART.
 *
 * Implementation:
 * Places a byte of data on the Tx FIFO.
 *
 * Inputs:
 * Id - UART Id.
 * Byte_to_send - data value to send.
 *
 * Returns:
 * + apERR_NONE for success.
 * + apUART_FIFO_FULL if there is no space free in the transmit FIFO.
 * + apUART_IN_USE if the UART is already in use.
 */
PUBLIC apError apUART_Write(apOS_UART_oId Id, UWORD32 Byte_to_send);


/*
 * Description:
 * Read N bytes of data from UART. Used for reads up to the FIFO size,
 * larger reads should use apUART_RECEIVE.
 *
 * Implementation:
 * Fetches N bytes of data from the FIFO, where N <= FIFO size.
 *
 * Inputs:
 * Id - UART Id.
 * pBuffer - pointer to the receiving data buffer.
 * Size - the number of bytes of data to receive.
 *
 * Returns:
 * + Number of bytes read.
 * + apUART_IN_USE if the UART is already receiving.
 */
PUBLIC UWORD32 apUART_Read_N(apOS_UART_oId Id, UBYTE8* pBuffer, UWORD32 Length);


/*
 * Description:
 * Send N bytes of data to the UART's Tx FIFO. Used for writes up to the Tx FIFO size,
 * larger writes should use apUART_TRANSMIT.
 *
 * Implementation:
 * Places N bytes of data on FIFO, where N <= FIFO size.
 *
 * Inputs:
 * Id - UART Id.
 * word_to_send - data value to send.
 * pBuffer - pointer to the data to send.
 * Length - the number of bytes of data to transmit.
 *
 * Returns:
 * + Number of bytes written.
 * + apUART_IN_USE - if the UART is already transmitting.
 */
PUBLIC UWORD32 apUART_Write_N(apOS_UART_oId Id, UBYTE8* pBuffer, UWORD32 Length);


/*
 * Description:
 * Returns the number of bytes that remain to be written to the FIFO.
 * Used in conjunction with apUART_Transmit().
 *
 * Implementation:
 * Returns value of static counter.
 *
 * Inputs:
 * Id - UART Id.
 *
 * Returns:
 * Number of bytes still to be written to Tx FIFO in current transfer.
 */
PUBLIC UWORD32 apUART_TransmitStatusGet(apOS_UART_oId Id);


/*
 * Description:
 * Returns the number of remaining bytes that can be read before the pBuffer is full.
 * Primarily designed to be used within the apUART_rCallback routine to determine how
 * much of the receive buffer has been filled.
 *
 * Implementation:
 * Returns value of static counter.
 *
 * Inputs:
 * Id - UART Id.
 *
 * Returns:
 * Free space remaining in pBuffer.
 */
PUBLIC UWORD32 apUART_ReceiveStatusGet(apOS_UART_oId Id);


/*
 * Description:
 * Terminates current transmit action. Used in conjunction with apUART_Transmit.
 * 
 * Implementation:
 * Disables the transmit interrupt. Stops any additional data
 * being written to the Tx FIFO. FIFO continues to empty if applicable.
 *
 * Inputs:
 * Id - UART Id.
 */
PUBLIC void apUART_TerminateTransmit(apOS_UART_oId Id);


/*
 * Description:
 * Terminates current receive action. Used in conjunction with apUART_Receive.
 * 
 * Implementation:
 * Stops further data being read into pBuffer from the Uart. If a Receive/Timeout
 * interrupt occurs after a call to this function the registered rListener routine
 * will be informed in lieu of the rCallback.  The registered rCallback routine is
 * also removed and the remaining read buffer size reset to 0.
 *
 * Inputs:
 * Id - UART Id.
 */
PUBLIC void apUART_TerminateReceive(apOS_UART_oId Id);


/*
 * Description:
 * Sets the user rListener function for UART Rx port activity and Modem interrupts.
  
 * Implementation:
 * If anything happens at the Rx port and a transfer is not underway, or a
 * Modem interrupt occurs, the rListener function is invoked and provided with
 * the appropriate apUART_eListenerMessage parameter.
 *
 * Inputs:
 * Id - UART Id.
 * rListener - The callback function of type apUART_rListener;
 *             setting it to aRNULL will clear the callback.
 */
PUBLIC void apUART_CallbackSet(apOS_UART_oId Id, apUART_rListener rListener);


/*
 * Description:
 * Configures FIFO watermark levels. (n/a for PL010 and Integrator variants)
 *  
 * Implementation:
 * Write values to hardware. Values set are the transmit and receive
 * FIFO levels.
 *  
 * Inputs:
 * Id - UART Id.
 * pConfig - pointer to apUART_sConfigFIFOs struct.
 *
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (PL010).
 */
PUBLIC apError apUART_FIFOConfigSet(apOS_UART_oId Id, apUART_sConfigFIFOs *pConfig);


/*
 * Description:
 * Returns FIFO watermark configuration. (n/a for PL010 and Integrator variants)
 *  
 * Implementation:
 * Complement of apUART_FIFOConfigSet(). Values returned are the transmit and receive
 * FIFO levels.
 *  
 * Inputs:
 * Id - UART Id.
 *
 * Outputs:
 * pConfig - pointer to apUART_sConfigFIFOs struct.
 *
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (PL010).
 */
PUBLIC apError apUART_FIFOConfigGet(apOS_UART_oId Id, apUART_sConfigFIFOs *pConfig);


/*
 * Description:
 * Configure data transfer options.
 *  
 * Implementation:
 * Write values to hardware; values set are the character frame parameters,
 * data bits, stop bits and parity.
 * Hardware flow control and stick parity is configured where supported.
 *  
 * Inputs:
 * Id - UART Id.
 * pConfig - pointer to apUART_sConfigData struct.
 */
PUBLIC void apUART_DataConfigSet(apOS_UART_oId Id, apUART_sConfigData *pConfig);


/*
 * Description:
 * Returns the data transfer options currently set.
 *  
 * Implementation:
 * The complement of apUART_DataConfigSet(). Values returned are the character frame parameters,
 * data bits, stop bits and parity.
 * Hardware flow control and stick parity configuration is only valid where supported. 
 *
 * Inputs:
 * Id - UART Id.
 *
 * Outputs:
 * pConfig - pointer to apUART_sConfigData struct.
 */
PUBLIC void apUART_DataConfigGet(apOS_UART_oId Id, apUART_sConfigData *pConfig);


/*
 * Description:
 * Configures the UART's low power options. (n/a to Integrator UARTs)
 *  
 * Implementation:
 * Write values to hardware. Values set are the low power mode and the
 * low power counter divisor based on a local copy of the clock frequency
 *
 * Inputs:
 * Id - UART Id.
 * pConfig - pointer to apUART_sConfigPower struct.
 *
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (Integrator UART).
 */
PUBLIC apError apUART_PowerConfigSet(apOS_UART_oId Id, apUART_sConfigPower *pConfig);


/*
 * Description:
 * Returns the UART's low power settings. (n/a to Integrator UARTs)
 *  
 * Implementation:
 * The complement of apUART_PowerConfigSet(). Values returned are the low power mode and the
 * low power baud rate, calculated from the low power counter divisor and
 * a local copy of the clock frequency
 *  
 * Inputs:
 * Id - UART Id.
 *
 * Outputs:
 * pConfig - pointer to apUART_sConfigPower struct.
 *
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (Integrator UART).
 */
PUBLIC apError apUART_PowerConfigGet(apOS_UART_oId Id, apUART_sConfigPower *pConfig);


/*
 * Description:
 * Configures the UART's infra-red and loopback settings.
 *  
 * Implementation:
 * Values set are the loopback enable and the infra-red enable. Before enabling
 * the SIR, apUART_Disable should be called.
 * When using an Integrator UART the infra-red apUART_eSIREnable should always
 * be defined as disabled (apUART_SIR_DISABLED).
 *  
 * Inputs:
 * Id - UART Id.
 * pConfig - pointer to IR apUART_sConfigIR struct.
 */
PUBLIC void apUART_IRConfigSet(apOS_UART_oId Id, apUART_sConfigIR *pConfig);


/*
 * Description:
 * Returns the configuration of the UART's infra-red and loopback options.
 *  
 * Implementation:
 * The complement of apUART_IRConfigSet(). Values returned are the loopback enable and the
 * infra-red enable.
 * When using an Integrator UART the infra-red configuration can be ignored as
 * it is not available.
 *  
 * Inputs:
 * Id - UART Id.
 *
 * Outputs:
 * pConfig - pointer to power apUART_sConfigIR struct.
 */
PUBLIC void apUART_IRConfigGet(apOS_UART_oId Id, apUART_sConfigIR *pConfig);

 
/*
 * Description:
 * Configures the Data Carrier Detect output (DCE role). (n/a for PL010 and Integrator variants)
 *
 * Implementation:
 * Asserts or deasserts the DCD output.  Sets the relevant Out1 bit in the
 * Control register.
 *
 * Inputs:
 * Id - UART Id.
 * Config - apUART_eDCDEnable type.
 * 
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (PL010).
 */
PUBLIC apError apUART_DCDConfigSet(apOS_UART_oId Id, apUART_eDCDEnable Config);


/*
 * Description:
 * Returns the Data Carrier Detect configuration (DCE role). (n/a for PL010 and Integrator variants)
 *
 * Implementation:
 * Returns the status of the DCD output.  Reads the relevant Out1 bit in the
 * Control register.
 *
 * Inputs:
 * Id - UART Id.
 *
 * Outputs:
 * pConfig - pointer to apUART_eDCDEnable type is returned indicating the DCD configuration.
 *
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (PL010). 
 */
PUBLIC apError apUART_DCDConfigGet(apOS_UART_oId Id, apUART_eDCDEnable *pConfig);


/*
 * Description:
 * Configures the Ring Indicator output (DCE role). (n/a for PL010 and Integrator variants)
 *
 * Implementation:
 * Asserts or deasserts the RI output.  Sets the Out2 bit in the
 * Control register.
 *
 * Inputs:
 * Id - UART Id.
 * Config - apUART_eRIEnable type.
 * 
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (PL010).
 */
PUBLIC apError apUART_RIConfigSet(apOS_UART_oId Id, apUART_eRIEnable Config);


/*
 * Description:
 * Returns the Ring Indicator configuration (DCE role). (n/a for PL010 and Integrator variants)
 *
 * Implementation:
 * Returns the status of the RI output.  Reads the Out2 bit in the
 * Control register.
 *
 * Inputs:
 * Id - UART Id.
 *
 * Outputs:
 * pConfig - pointer to apUART_eRIEnable type is returned indicating the RI configuration.
 * 
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (PL010).
 */
PUBLIC apError apUART_RIConfigGet(apOS_UART_oId Id, apUART_eRIEnable *pConfig);


/*
 * Description:
 * Configures the Request To Send output. (n/a for PL010 and Integrator variants)
 *
 * Implementation:
 * Asserts or deasserts the RTS output. Sets the RTS bit in the Control register.
 * The RTS output cannot be controlled if RTS hardware flow control is supported and enabled.
 *
 * Inputs:
 * Id - UART Id.
 * Config - apUART_eRTSEnable type.
 * 
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (PL010).
 */
PUBLIC apError apUART_RTSConfigSet(apOS_UART_oId Id, apUART_eRTSEnable Config);


/*
 * Description:
 * Returns the Request To Send configuration. (n/a for PL010 and Integrator variants)
 *
 * Implementation:
 * Returns the status of the RTS output. Reads the RTS bit in the
 * Control register.
 *
 * Inputs:
 * Id - UART Id.
 *
 * Outputs:
 * pConfig - pointer to apUART_eRTSEnable type is returned indicating the RTS configuration.
 *
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (PL010).
 */
 PUBLIC apError apUART_RTSConfigGet(apOS_UART_oId Id, apUART_eRTSEnable *pConfig);


/*
 * Description:
 * Configures the Data Transmit Ready output. (n/a for PL010 and Integrator variants)
 *
 * Implementation:
 * Asserts or deasserts the DTR output. Sets the relevant DTR bit in the
 * Control register.
 *
 * Inputs:
 * Id - UART Id
 * Config - apUART_eDTREnable type.
 * 
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (PL010).
 */
PUBLIC apError apUART_DTRConfigSet(apOS_UART_oId Id, apUART_eDTREnable Config);


/*
 * Description:
 * Returns the Data Transmit Ready configuration. (n/a for PL010 and Integrator variants)
 *
 * Implementation:
 * Returns the status of the DTR output. Reads the relevant DTR bit in the
 * Control register.
 *
 * Inputs:
 * Id - UART Id.
 *
 * Outputs:
 * pConfig - pointer to apUART_eDTREnable type is returned indicating the DTR configuration.
 *
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (PL010).
 */
 PUBLIC apError apUART_DTRConfigGet(apOS_UART_oId Id, apUART_eDTREnable *pConfig);


/*
 * Description:
 * Enables the UART's transmit interrupt. Used to restart the apUART_Transmit action.
 *
 * Implementation:
 * Sets a bit in the interrupt mask register.
 *
 * Inputs:
 * Id - UART Id.
 */
PUBLIC void apUART_TxIntEnable(apOS_UART_oId Id);


/*
 * Description:
 * Disables the UART's transmit interrupt. Used to pause the current apUART_Transmit action.
 *
 * Implementation:
 * Clears a bit in the interrupt mask register.
 *
 * Inputs:
 * Id - UART Id.
 */
PUBLIC void apUART_TxIntDisable(apOS_UART_oId Id);


/*
 * Description:
 * Enables the UART's receive and timeout interrupts.
 *
 * Implementation:
 * Sets bits in the interrupt mask register.
 *
 * Inputs:
 * Id - UART Id.
 */
PUBLIC void apUART_RxIntEnable(apOS_UART_oId Id);


/*
 * Description:
 * Disables the UART's receive and timeout interrupts.
 *
 * Implementation:
 * Clears bits in the interrupt mask register.
 *
 * Inputs:
 * Id - UART Id.
 */
PUBLIC void apUART_RxIntDisable(apOS_UART_oId Id);


/*
 * Description:
 * Enables/disables the Uart's specified Modem interrupts.
 *
 * Implementation: 
 * Sets the relevant interrupt mask bit(s).
 *
 * Inputs:
 * Id - UART Id.
 * Modemmask - a bitmask defined by ORing values of the type
 * apUART_eModemEnable together for the Modem interrupts to enable.
 * Passing 0 disables all the interrupts.
 *
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware.
 */
PUBLIC apError apUART_ModemIntSet(apOS_UART_oId Id, UWORD32 Modemmask);


/*
 * Description:
 * Returns the settings of the Uart's Modem interrupt mask.
 * 
 * Implementation:
 * Returns the value of the relevant interrupt mask bits.
 *
 * Inputs:
 * Id - UART Id.
 * pModemmask - pointer to a bitmask the function uses to return
 * the Modem interrupt mask. This value should be ANDed with
 * apUART_eModemEnable type values to determine the Modem interrupt status.
 */
PUBLIC void apUART_ModemIntGet(apOS_UART_oId Id, UWORD32 *pModemmask);


/*
 * Description:
 * Primarily to be used within the apUART_rListener routine.
 * Determines the status of the incoming modem signals CTS,
 * DSR, DCD and RI (RI where supported).
 *
 * Implementation:
 * Returns the values of the modem flags.
 *
 * Inputs:
 * Id - UART Id.
 *
 * Returns:
 * A value that should be AND'ed with values from the type apUART_eModemFlags
 * to determine the state of the incoming modem signals.
 */
PUBLIC UWORD32 apUART_ModemStatusGet(apOS_UART_oId Id);

/*
 * Description:
 * Enables/disables the specified Error interrupts. (n/a for PL010 and Integrator variants)
 *
 * Implementation:
 * Sets the relevant interrupt mask bits.
 * 
 * Inputs:
 * Id - UART Id.
 * Errormask - a bitmask created by ORing values of the type
 * apUART_eErrorEnable together for those Error interrupts to enable.
 *
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (PL010).
 */
PUBLIC apError apUART_ErrorIntSet(apOS_UART_oId Id, UWORD32 Errormask);


/*
 * Description:
 * Returns the status of the Error interrupts. (n/a for PL010 and Integrator variants)
 *
 * Implementation:
 * Returns the value of the relevant interrupt mask bits.
 * 
 * Inputs:
 * Id - UART Id.
 * pErrormask - pointer to a bitmask the function uses to return
 * the Error interrupt status.  This value returned should be ANDed with the
 * apUART_eErrorEnable type values to determine the Error interrupt status.
 *
 * Returns:
 * + apERR_NONE if successful.
 * + apERR_UNSUPPORTED if unsupported by hardware (PL010).
 */
PUBLIC apError apUART_ErrorIntGet(apOS_UART_oId Id, UWORD32 *pErrormask);


/*
 * Description:
 * Clears the current status information for the data character read prior to
 * the call to this function.
 *
 * Implementation:
 * Writes to the receive status/error clear register to clear the status.
 *
 * Inputs:
 * Id - UART Id.
 */
PUBLIC void apUART_ErrorStatusClear(apOS_UART_oId Id);


/*
 * Description:
 * Returns the status information for the byte read prior to the call to
 * this function. This function call is included for backward compatibility
 * with PL010.  PL011 variants should use the method outlined in 
 * apUART_Read for the polling method of error detection.
 * 1 pCLK cycle is needed inbetween a call to apUART_Read and
 * apUART_ErrorStatusGet to allow the receive status/error clear register
 * to update.
 *
 * Implementation:
 * Returns the value of the receive status/error clear register.
 *
 * Inputs:
 * Id - UART Id.
 *
 * Returns:
 * A value that should be AND'ed with the values in apUART_eErrorStatusFlags
 * to determine the current error status.
 */
PUBLIC UWORD32 apUART_ErrorStatusGet(apOS_UART_oId Id);



#ifdef __cplusplus
} /* allow C++ to use these headers */
#endif /* __cplusplus */

#endif /* apUART_H */
