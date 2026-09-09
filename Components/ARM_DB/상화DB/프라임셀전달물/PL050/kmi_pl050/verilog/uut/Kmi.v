//  ----------------------------------------------------------------------------
//  This confidential and proprietary software may be used only
//  as authorised by a licensing agreement from ARM Limited
//  (C) COPYRIGHT 1998 ARM Limited
//  ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised copies
//  and copies may only be made to the extent permitted by a
//  licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//  
//  Version and Release Control Information :
//   
//  
//  Filename            : Kmi.v,v
//  
//  File Revision       : 1.5
//  
//  Release Information : PL050-REL1v1  
//  
//  -----------------------------------------------------------------------------
`timescale 1ns/1ps


module Kmi(PCLK, KMIREFCLK, BnRES, nKMIRST, PSEL, PENABLE, PWRITE, PADDRH, PWDATA
          , KMICLKIN, KMIDATAIN, SCANMODE, PADDRL, PRDATA, nKMICLKEN
          , nKMIDATAEN, KMITXINTR, KMIRXINTR, KMIINTR);
input 	PCLK;	// APB Clock
input 	KMIREFCLK;	// KMI Reference Clock
input 	BnRES;	// APB Reset
input 	nKMIRST;	// KBD Reset 
input 	PSEL;	// APB select
input 	PENABLE;	// APB enable
input 	PWRITE;	// APB Read/Write
input 	[7:6] PADDRH;	// APB Address Bus
input 	[7:0] PWDATA;	// APB  Data Bus
input 	KMICLKIN;	// KMI Clock Input line
input 	KMIDATAIN;	// KMI Data Input line
input 	SCANMODE;	// ScanMode Control pin
input 	[4:2] PADDRL;	// APB Address Bus
output	[7:0] PRDATA;	// Read Data Bus
output	nKMICLKEN;	// KMI Clock Enable control
output	nKMIDATAEN;	// KMI DATA Enable control
output	KMITXINTR;	// KMI TX Interrupt
output	KMIRXINTR;	// KMI RX Interrupt
output	KMIINTR;	// Combined KMI Interrupt


// ----------------------------------------------------------------------------
//  Purpose : This block is the top level module for the Keyboard Mouse
//            Interface and instantiates all the functional sub-Blocks. 
// ----------------------------------------------------------------------------
//  
//                         KMI
//                         ===
// 
// ----------------------------------------------------------------------------
// 
//  Overview
//  ========
//  This block instantiates the different modules within the KMI
// 
// ----------------------------------------------------------------------------

wire [7:0] PWDataIn; 
wire TxBusy; 
wire RxBusy; 
wire RxParity; 
wire StartBit; 
wire TXDoneSync; 
wire TXDone; 
wire DataReadSync; 
wire DataRead; 
wire DataAvlSync; 
wire ResetBitCounter; 
wire [3:0] BitCounter; 
wire ResetTimer; 
wire DataAvl; 
wire StopBitON; 
wire KmiClkInLow; 
wire FKMIDSync; 
wire KmiDataInMxSync; 
wire KmiEn; 
wire FKMIC; 
wire FKMID; 
wire KmiEnSync; 
wire WrenKMICR; 
wire WrenKMIDATA; 
wire WrenKMICLKDIV; 
wire WrenKMITCR; 
wire WrenKMITISR; 
wire WrenKMITMR; 
wire [7:0] KMITXSR; 
wire [3:0] KMICLKDIV; 
wire [7:0] KMIRXR; 
wire [3:0] KMISTATE; 
wire KMICSync; 
wire KMIDSync; 
wire TxBusySync; 
wire RxBusySync; 
wire RxParitySync; 
wire KmiClkInMxSync; 
wire SampKmiClkIn; 
wire Usec64; 
wire Msec16; 
wire RdenKMIDATA; 
wire DataRdydly; 
wire DataRdydlySync; 
wire SelKMITCER; 
wire [4:0] KMITCR; 
wire [1:0] KMITISR; 
wire KmiDataInMx; 
wire KmiClkInMx; 
wire [3:0] KMITMR; 
wire ClkEn; 
wire nReset; 
wire nKMIRES; 
wire RxFull; 
wire TxEmpty; 
wire FKMICSync; 
wire KmiDataEnHigh; 
wire CLKDIVUpdate; 
wire CLKDIVUpdateSync; 
wire Pulse8MHz; 
wire [5:0] KMITIMERSTG1; 
wire [2:0] KMITIMERSTG2; 
wire [7:0] KMITIMERSTG3; 
wire KMITYPE; 
wire KMITYPESync; 
wire KMIRXINTREn; 
wire KMITXINTREn; 







// ----------------------------------------------------------------------------
//  This block is the APB Interface for the KMI 
// ----------------------------------------------------------------------------
 KmiApbif uKmiApbif	(.PCLK(PCLK)
	, .BnRES(BnRES)
	, .PSEL(PSEL)
	, .PENABLE(PENABLE)
	, .PWRITE(PWRITE)
	, .PWDATA(PWDATA)
	, .Usec64(Usec64)
	, .Msec16(Msec16)
	, .PWDataIn(PWDataIn)
	, .PRDATA(PRDATA)
	, .nReset(nReset)
	, .KMIRXR(KMIRXR)
	, .KMICLKDIV(KMICLKDIV)
	, .KMITCR(KMITCR)
	, .KMITMR(KMITMR)
	, .KMISTATE(KMISTATE)
	, .KMITISR(KMITISR)
	, .WrenKMICR(WrenKMICR)
	, .WrenKMIDATA(WrenKMIDATA)
	, .WrenKMICLKDIV(WrenKMICLKDIV)
	, .WrenKMITCR(WrenKMITCR)
	, .WrenKMITISR(WrenKMITISR)
	, .WrenKMITMR(WrenKMITMR)
	, .RdenKMIDATA(RdenKMIDATA)
	, .KMITXINTR(KMITXINTR)
	, .KMIRXINTR(KMIRXINTR)
	, .KMICSync(KMICSync)
	, .KMIDSync(KMIDSync)
	, .RxParitySync(RxParitySync)
	, .RxBusySync(RxBusySync)
	, .TxBusySync(TxBusySync)
	, .SelKMITCER(SelKMITCER)
	, .ClkEn(ClkEn)
	, .nKMIDATAEN(nKMIDATAEN)
	, .nKMICLKEN(nKMICLKEN)
	, .KMIINTR(KMIINTR)
	, .TxEmpty(TxEmpty)
	, .RxFull(RxFull)
	, .KMITIMERSTG1(KMITIMERSTG1)
	, .KMITIMERSTG2(KMITIMERSTG2)
	, .KMITIMERSTG3(KMITIMERSTG3)
	, .PADDRH(PADDRH)
	, .PADDRL(PADDRL)
	, .KMITYPE(KMITYPE)
	, .KMIRXINTREn(KMIRXINTREn)
	, .KMITXINTREn(KMITXINTREn)
	, .KmiEn(KmiEn)
	, .FKMID(FKMID)
	, .FKMIC(FKMIC));


// ----------------------------------------------------------------------------
//  The KmiRegBlk contains the Normal mode registers of the KMI and also
//  generates the KMITXINTR and KMIRXINTR interrupt signals.
// ----------------------------------------------------------------------------
// 
// 
 KmiRegBlk uKmiRegBlk	(.PCLK(PCLK)
	, .DataRdydly(DataRdydly)
	, .WrenKMICR(WrenKMICR)
	, .WrenKMICLKDIV(WrenKMICLKDIV)
	, .WrenKMIDATA(WrenKMIDATA)
	, .KmiEn(KmiEn)
	, .PWDataIn(PWDataIn)
	, .TXDoneSync(TXDoneSync)
	, .ClkEn(ClkEn)
	, .KMITXSR(KMITXSR)
	, .KMICLKDIV(KMICLKDIV)
	, .FKMID(FKMID)
	, .FKMIC(FKMIC)
	, .nReset(nReset)
	, .DataAvlSync(DataAvlSync)
	, .DataRead(DataRead)
	, .KMIRXINTR(KMIRXINTR)
	, .KMITXINTR(KMITXINTR)
	, .RdenKMIDATA(RdenKMIDATA)
	, .RxFull(RxFull)
	, .TxEmpty(TxEmpty)
	, .CLKDIVUpdate(CLKDIVUpdate)
	, .KMITYPE(KMITYPE)
	, .KMITXINTREn(KMITXINTREn)
	, .KMIRXINTREn(KMIRXINTREn));


// ----------------------------------------------------------------------------
// This block implements the KMI Controller for controlling the overall 
// operations of the KMI.
// ----------------------------------------------------------------------------
 KmiCntrl uKmiCntrl	(.KMIREFCLK(KMIREFCLK)
	, .nKMIRES(nKMIRES)
	, .DataRdydlySync(DataRdydlySync)
	, .SampKmiClkIn(SampKmiClkIn)
	, .Pulse8MHz(Pulse8MHz)
	, .Usec64(Usec64)
	, .Msec16(Msec16)
	, .KmiEnSync(KmiEnSync)
	, .BitCounter(BitCounter)
	, .nKMICLKEN(nKMICLKEN)
	, .TxBusy(TxBusy)
	, .RxBusy(RxBusy)
	, .ResetBitCounter(ResetBitCounter)
	, .ResetTimer(ResetTimer)
	, .DataReadSync(DataReadSync)
	, .KMISTATE(KMISTATE)
	, .ClkEn(ClkEn)
	, .StartBit(StartBit)
	, .TXDone(TXDone)
	, .DataAvl(DataAvl)
	, .KmiDataInMxSync(KmiDataInMxSync)
	, .StopBitON(StopBitON)
	, .FKMICSync(FKMICSync)
	, .KmiDataEnHigh(KmiDataEnHigh)
	, .KMITYPESync(KMITYPESync));


// ----------------------------------------------------------------------------
// This block samples the incoming KMICLKIN input and generates a valid KMI 
// clock for the KMI core.
// ----------------------------------------------------------------------------
 KmiClkInSync uKmiClkInSync	(.ClkEn(ClkEn)
	, .nKMIRES(nKMIRES)
	, .KmiClkInMxSync(KmiClkInMxSync)
	, .SampKmiClkIn(SampKmiClkIn)
	, .KmiClkInLow(KmiClkInLow)
	, .Pulse8MHz(Pulse8MHz)
	, .KMIREFCLK(KMIREFCLK));


// ----------------------------------------------------------------------------
// This block implements the 17-bit Timer for generating the 64usec and 16msec
// timeout.
// ----------------------------------------------------------------------------
 KmiTimer uKmiTimer	(.Pulse8MHz(Pulse8MHz)
	, .KmiEnSync(KmiEnSync)
	, .nKMIRES(nKMIRES)
	, .ResetTimer(ResetTimer)
	, .ClkEn(ClkEn)
	, .KMITMR(KMITMR)
	, .Usec64(Usec64)
	, .Msec16(Msec16)
	, .KMITIMERSTG1(KMITIMERSTG1)
	, .KMITIMERSTG2(KMITIMERSTG2)
	, .KMITIMERSTG3(KMITIMERSTG3)
	, .KMIREFCLK(KMIREFCLK));


// ----------------------------------------------------------------------------
// Synchronisers for signal crossing into PCLK domain.
// ----------------------------------------------------------------------------
 KmiSynctoPCLK uKmiSynctoPCLK	(.PCLK(PCLK)
	, .TXDone(TXDone)
	, .TxBusy(TxBusy)
	, .RxBusy(RxBusy)
	, .RxParity(RxParity)
	, .TXDoneSync(TXDoneSync)
	, .DataAvlSync(DataAvlSync)
	, .TxBusySync(TxBusySync)
	, .RxBusySync(RxBusySync)
	, .ClkEn(ClkEn)
	, .nReset(nReset)
	, .DataAvl(DataAvl)
	, .RxParitySync(RxParitySync)
	, .SampKmiClkIn(SampKmiClkIn)
	, .KmiDataInMx(KmiDataInMx)
	, .KMICSync(KMICSync)
	, .KMIDSync(KMIDSync));


// ----------------------------------------------------------------------------
// Synchronisers for signals crossing into REFCLK domain
// ----------------------------------------------------------------------------
 KmiSynctoREFCLK uKmiSynctoREFCLK	(.CLKDIVUpdate(CLKDIVUpdate)
	, .CLKDIVUpdateSync(CLKDIVUpdateSync)
	, .ClkEn(ClkEn)
	, .DataReadSync(DataReadSync)
	, .DataRead(DataRead)
	, .nKMIRES(nKMIRES)
	, .KmiEn(KmiEn)
	, .KmiDataInMx(KmiDataInMx)
	, .KmiDataInMxSync(KmiDataInMxSync)
	, .KmiEnSync(KmiEnSync)
	, .FKMIC(FKMIC)
	, .FKMID(FKMID)
	, .FKMIDSync(FKMIDSync)
	, .FKMICSync(FKMICSync)
	, .KmiClkInMx(KmiClkInMx)
	, .KmiClkInMxSync(KmiClkInMxSync)
	, .DataRdydly(DataRdydly)
	, .DataRdydlySync(DataRdydlySync)
	, .KMIREFCLK(KMIREFCLK)
	, .KMITYPE(KMITYPE)
	, .KMITYPESync(KMITYPESync));


// ----------------------------------------------------------------------------
// This block implements the KMI Transmitter and Receiver logic.
// ----------------------------------------------------------------------------
 KmiTxRx uKmiTxRx	(.KMIREFCLK(KMIREFCLK)
	, .nKMIRES(nKMIRES)
	, .KmiEnSync(KmiEnSync)
	, .ResetBitCounter(ResetBitCounter)
	, .TxBusy(TxBusy)
	, .RxBusy(RxBusy)
	, .KMITXSR(KMITXSR)
	, .KMIRXR(KMIRXR)
	, .RxParity(RxParity)
	, .nKMIDATAEN(nKMIDATAEN)
	, .FKMIDSync(FKMIDSync)
	, .KmiDataInMxSync(KmiDataInMxSync)
	, .Pulse8MHz(Pulse8MHz)
	, .nKMICLKEN(nKMICLKEN)
	, .BitCounter(BitCounter)
	, .ClkEn(ClkEn)
	, .StartBit(StartBit)
	, .Usec64(Usec64)
	, .DataReadSync(DataReadSync)
	, .DataAvl(DataAvl)
	, .KmiClkInLow(KmiClkInLow)
	, .StopBitON(StopBitON)
	, .SampKmiClkIn(SampKmiClkIn)
	, .KmiDataEnHigh(KmiDataEnHigh));


// ----------------------------------------------------------------------------
// This Block implements the KMI Test logic
// ----------------------------------------------------------------------------
 KmiTest uKmiTest	(.BnRES(BnRES)
	, .PCLK(PCLK)
	, .SCANMODE(SCANMODE)
	, .WrenKMITCR(WrenKMITCR)
	, .WrenKMITISR(WrenKMITISR)
	, .WrenKMITMR(WrenKMITMR)
	, .SelKMITCER(SelKMITCER)
	, .PSEL(PSEL)
	, .PENABLE(PENABLE)
	, .KMIDATAIN(KMIDATAIN)
	, .KMICLKIN(KMICLKIN)
	, .ClkEn(ClkEn)
	, .nReset(nReset)
	, .nKMIRES(nKMIRES)
	, .KMITCR(KMITCR)
	, .KMITMR(KMITMR)
	, .KMITISR(KMITISR)
	, .KmiDataInMx(KmiDataInMx)
	, .KmiClkInMx(KmiClkInMx)
	, .PWDataIn(PWDataIn[4:0])
	, .nKMIRST(nKMIRST));


// ----------------------------------------------------------------------------
// This block implements the REFCLKDIV for generating the internal Pulse8MHz
// signal.
// ----------------------------------------------------------------------------
 KmiREFCLKDiv uKmiREFCLKDiv	(.CLKDIVUpdateSync(CLKDIVUpdateSync)
	, .Pulse8MHz(Pulse8MHz)
	, .ClkEn(ClkEn)
	, .nKMIRES(nKMIRES)
	, .KMICLKDIV(KMICLKDIV)
	, .KMIREFCLK(KMIREFCLK));
endmodule
