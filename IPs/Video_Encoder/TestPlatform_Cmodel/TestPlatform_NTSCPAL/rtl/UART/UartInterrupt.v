//------------------------------------------------------------------------------
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : UartInterrupt.v.rca
//  File Revision          : 1.2
//  
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//  
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Purpose     : This block contains the interrupt logic for the UART.
//------------------------------------------------------------------------------
`timescale 1ns/1ps

module UartInterrupt
                    (
                     DataStp,
                     UARTMSINT,
                     UARTEINTRfbp,
                     UARTTXMIS,
                     UARTRXMIS,
                     UARTOEMIS,
             
                     UARTRTIC,
                     UARTDSRIC,
                     UARTDCDIC,
                     UARTCTSIC,
                     UARTRIIC,
                     UARTOEIC,
                     UARTBEIC,
                     UARTPEIC,
                     UARTFEIC,
                     
                     RTINTR,
                     MSINTR,
                     EINTR,
                     UARTINT
                    );
input        DataStp;      // for UARTRTINTR
input        UARTMSINT;    // for UARTMSINTR
input        UARTEINTRfbp; // Combined int for break, frame,parity
input        UARTTXMIS;    // Transmit Interrupt
input        UARTRXMIS;    // Receive Interrupt
input        UARTOEMIS;    // Overrun error interrupt
input        UARTRTIC;     // RTINTR clear
input        UARTDSRIC;    // DSR MSINTR clear
input        UARTDCDIC;    // DCD MSINTR clear
input        UARTCTSIC;    // CTS MSINTR clear
input        UARTRIIC;     // RI MSINTR clear
input        UARTOEIC;     // OEINTR clear
input        UARTBEIC;     // BEINTR clear
input        UARTPEIC;     // PEINTR clear
input        UARTFEIC;     // FEINTR clear

output       RTINTR;       // Receive Timeout interrupt
output       MSINTR;       // Modem status interrupt
output       EINTR;        // Combined Error interrupt
output       UARTINT;      // Combined interrupt


      
//------------------------------------------------------------------------------
//
//                   UartInterrupt
//                   =============
//
//------------------------------------------------------------------------------
//
// Overview
// ========
//  This block contains the aynchronous interrupt logic.  The
//  interrupts from the UARTCLK domain are ANDed with the relevant
//  interrupt clear signal and taken as ouptuts.  The interrupts are
//  generated asynchronously but cleared synchronuosly with PCLK.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Wire Declaration
//------------------------------------------------------------------------------

wire MSINTRCLR;
// Combined Modem interrupt clear wire

wire EINTRCLR;
// Combined Error interrupt clear wire

wire ERRINTR;
// Combined Error interrupt wire

wire iRTINTR;
// Internal version of RTINTR

wire  iMSINTR;
// Internal version of MSINTR

wire  iEINTR;
// Internal version of EINTR


//-------------------------------------------------------------------
// Generate a combined modem interrupt clear by ORing together the
// individual modem interrupt clear signals.
//-------------------------------------------------------------------

assign MSINTRCLR = UARTDSRIC | UARTDCDIC | UARTCTSIC | UARTRIIC; 

//-------------------------------------------------------------------
// Generate a combined error interrupt clear by ORing together the
// individual error interrupt clear signals.
//-------------------------------------------------------------------

assign EINTRCLR = UARTOEIC | UARTBEIC | UARTPEIC | UARTFEIC;

//-------------------------------------------------------------------
// OR together the break, frame and parity interrupt with the Overrun
// interrupt to generate one combimed error interrupt.
//-------------------------------------------------------------------
assign ERRINTR = UARTEINTRfbp | UARTOEMIS;
  
//-------------------------------------------------------------------
// When the relevant interrupt clear signal is asserted, the
// asynchronous interrupt is cleared.  
//-------------------------------------------------------------------

assign  iRTINTR = DataStp & (!UARTRTIC);
assign  iMSINTR = UARTMSINT & (!MSINTRCLR);
assign iEINTR   = ERRINTR & (!EINTRCLR);

//-----------------------------------------------------------------
// Combine all interrupts to generate UARTINTR
//-----------------------------------------------------------------

assign  UARTINT = iRTINTR | iMSINTR | iEINTR | UARTTXMIS | UARTRXMIS;
assign  RTINTR  = iRTINTR;
assign  MSINTR  = iMSINTR;
assign  EINTR   = iEINTR;
  
endmodule // 

//--========================== End of UartInterrupt =========================--
