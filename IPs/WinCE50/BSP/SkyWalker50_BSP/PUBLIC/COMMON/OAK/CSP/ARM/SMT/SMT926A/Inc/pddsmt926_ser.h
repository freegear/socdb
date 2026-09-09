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
/*++
THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
PARTICULAR PURPOSE.

Module Name:  

Abstract:

    Platform dependent Serial definitions for serial controller.

Notes: 
--*/
#ifndef __PDDSMT926_SER_H_
#define __PDDSMT926_SER_H_

#include <cserpdd.h>
#include <cmthread.h>
#include <smt926a_intr.h>
#include <smt926a_uart.h>

/////////////////////////////////////////////////////////////////////////////////////////
// Required Registry Setting.
#define PC_REG_SMTUART_INTBIT_VAL_NAME TEXT("InterruptBitsShift")
#define PC_REG_SMTUART_INTBIT_VAL_LEN sizeof(DWORD)
#define PC_REG_SMTUART_IST_TIMEOUTS_VAL_NAME TEXT("ISTTimeouts")
#define PC_REG_SMTUART_IST_TIMEOUTS_VAL_LEN sizeof(DWORD)

////////////////////////////////////////////////////////////////////////////////////////
// WaterMarker Pairs.
typedef struct  __PAIRS {
    ULONG   Key;
    ULONG   AssociatedValue;
} PAIRS, *PPAIRS;


 class CRegSMTUart {
public:
    CRegSMTUart(PULONG pRegAddr);
    virtual ~CRegSMTUart() { ; };
    virtual BOOL    Init() ;
#if 1//shkim-0926
    void Write_UARTDR(ULONG uData){ WRITE_REGISTER_ULONG( m_pReg, (uData)); };
    ULONG Read_UARTDR(){ return READ_REGISTER_ULONG(m_pReg); };
    void Write_UARTSR(ULONG uData){ WRITE_REGISTER_ULONG(m_pReg+1, (uData)); };
    ULONG Read_UARTSR(){ return READ_REGISTER_ULONG(m_pReg+1); };

    ULONG Read_UARTFR(){ return READ_REGISTER_ULONG( m_pReg+6 ); };            

    void Write_UARTILPR(ULONG uData){ WRITE_REGISTER_ULONG(m_pReg+8, (uData)); };
    ULONG Read_UARTILPR(){ return READ_REGISTER_ULONG(m_pReg+8); };

    void Write_UARTIBRD(ULONG uData){ WRITE_REGISTER_ULONG(m_pReg+9, (uData)); };
    ULONG Read_UARTIBRD(){ return READ_REGISTER_ULONG(m_pReg+9); };

    void Write_UARTFBRD(ULONG uData){ WRITE_REGISTER_ULONG(m_pReg+10, (uData)); };
    ULONG Read_UARTFBRD(){ return READ_REGISTER_ULONG(m_pReg+10); };

    void Write_UARTLCR_H(ULONG uData){ WRITE_REGISTER_ULONG(m_pReg+11, (uData)); };       
    ULONG Read_UARTLCR_H(){ return READ_REGISTER_ULONG(m_pReg+11); };

    void Write_UARTCR(ULONG uData){ WRITE_REGISTER_ULONG(m_pReg+12, (uData)); };
    ULONG Read_UARTCR(){ return READ_REGISTER_ULONG(m_pReg+12); };

    void Write_UARTIFLS(ULONG uData){ WRITE_REGISTER_ULONG(m_pReg+13, (uData)); };      
    ULONG Read_UARTIFLS(){ return READ_REGISTER_ULONG(m_pReg+13); };

    void Write_UARTIMSC(ULONG uData){ WRITE_REGISTER_ULONG(m_pReg+14, (uData)); };         
    ULONG Read_UARTIMSC(){ return READ_REGISTER_ULONG(m_pReg+14); };

    ULONG Read_UARTRIS(){ return READ_REGISTER_ULONG(m_pReg+15); };//Read Only
    ULONG Read_UARTMIS(){ return READ_REGISTER_ULONG(m_pReg+16); };//Read Only       

    void Write_UARTICR(ULONG uData){ WRITE_REGISTER_ULONG(m_pReg+17, (uData));};//write Only        

    ULONG Write_UARTDMACR(ULONG uData){ WRITE_REGISTER_ULONG( m_pReg+18, (uData)); };                   
#endif
    virtual BOOL    Write_BaudRate(ULONG uData);
    PULONG  GetRegisterVirtualAddr() { return m_pReg; };
    virtual void    Backup();
    virtual void    Restore();
#ifdef DEBUG
    virtual void    DumpRegister();
#endif
protected:
    volatile PULONG const  m_pReg;
    BOOL    m_fIsBackedUp;
private:
#if 1 //shkim-0927
/* which registor have to be backup???
ULONG m_UARTDRBackup;
ULONG m_UARTSRBackup;
ULONG m_UARTFRBackup;
ULONG m_UARTILPRBackup;
ULONG m_UARTIBRDBackup;
ULONG m_UARTFBRDBackup;
ULONG m_UARTLCR_HBackup;
ULONG m_UARTCRBackup;
ULONG m_UARTIFLSBackup;
ULONG m_UARTIMSCBackup;
ULONG m_UARTRISBackup;
ULONG m_UARTMISBackup;
ULONG m_UARTICRBackup;
ULONG m_UARTDMACRBackup;
*/
ULONG m_UARTILPRBackup;
ULONG m_UARTIBRDBackup;
ULONG m_UARTFBRDBackup;
ULONG m_UARTLCR_HBackup;
ULONG m_UARTCRBackup;
ULONG m_UARTIFLSBackup;
#else
    ULONG    m_ULCONBackup;
    ULONG    m_UCONBackup;
    ULONG    m_UFCONBackup;
    ULONG    m_UMCOMBackup;
    ULONG    m_UBRDIVBackup;
#endif    
    
    ULONG    m_BaudRate;
    ULONG    m_smt926_pclk;
};
class CPddSMTUart: public CSerialPDD, public CMiniThread  {
public:
    CPddSMTUart (LPTSTR lpActivePath, PVOID pMdd, PHWOBJ pHwObj);
    virtual ~CPddSMTUart();
    virtual BOOL Init();
    virtual void PostInit();
    virtual BOOL MapHardware();
    virtual BOOL CreateHardwareAccess();
//  Power Manager Required Function.
    virtual void    SerialRegisterBackup() { m_pRegSMTUart->Backup(); };
    virtual void    SerialRegisterRestore() { m_pRegSMTUart->Restore(); };

// Implement CPddSerial Function.
// Interrupt
    virtual BOOL    InitialEnableInterrupt(BOOL bEnable ) ; // Enable All the interrupt may include Xmit Interrupt.
private:
    virtual DWORD ThreadRun();   // IST
//  Tx Function.
public:
    virtual BOOL    InitXmit(BOOL bInit);
    virtual void    XmitInterruptHandler(PUCHAR pTxBuffer, ULONG *pBuffLen);
    virtual void    XmitComChar(UCHAR ComChar);
    virtual BOOL    EnableXmitInterrupt(BOOL bEnable);
    virtual BOOL    CancelXmit();
    virtual DWORD   GetWriteableSize();
protected:
    BOOL    m_XmitFifoEnable;
    HANDLE  m_XmitFlushDone;

//
//  Rx Function.
public:
    virtual BOOL    InitReceive(BOOL bInit);
    virtual ULONG   ReceiveInterruptHandler(PUCHAR pRxBuffer,ULONG *pBufflen);
    virtual ULONG   CancelReceive();
    virtual DWORD   GetWaterMark();
    virtual BYTE    GetWaterMarkBit();
    virtual void    Rx_Pause(BOOL bSet) {;};
protected:
    BOOL    m_bReceivedCanceled;
    DWORD   m_dwWaterMark;
//
//  Modem
public:
    virtual BOOL    InitModem(BOOL bInit);
    virtual void    ModemInterruptHandler() { GetModemStatus();};
    virtual ULONG   GetModemStatus();
    virtual void    SetDTR(BOOL bSet) {;};
    virtual void    SetRTS(BOOL bSet);
//
// Line Function.
    virtual BOOL    InitLine(BOOL bInit) ;
    virtual void    LineInterruptHandler() { GetLineStatus();};
    virtual void    SetBreak(BOOL bSet) ;
    virtual BOOL    SetBaudRate(ULONG BaudRate,BOOL bIrModule) ;
    virtual BOOL    SetByteSize(ULONG ByteSize);
    virtual BOOL    SetParity(ULONG Parity);
    virtual BOOL    SetStopBits(ULONG StopBits);
//
// Line Internal Function
    BYTE            GetLineStatus();
    virtual void    SetOutputMode(BOOL UseIR, BOOL Use9Pin) ;

protected:
    CRegSMTUart *  m_pRegSMTUart;
    PVOID           m_pRegVirtualAddr;

    volatile SMT926A_INTR_REG   * m_pINTregs;    
    DWORD           m_dwIntShift;
public:
    void    DisableInterrupt(DWORD dwInt)
    {
#if 1//shkim-0928    
        ULONG smtTemp = m_pRegSMTUart->Read_UARTIMSC();
        m_pRegSMTUart->Write_UARTIMSC(smtTemp & ~(dwInt));
#else
        m_pINTregs->INTSUBMSK |= (dwInt<<m_dwIntShift);
#endif        
    }
    void    EnableInterrupt(DWORD dwInt)
    { 
#if 1 //shkim-0928    
        ULONG smtTemp = 0;
        smtTemp = m_pRegSMTUart->Read_UARTIMSC();
        m_pRegSMTUart->Write_UARTIMSC(smtTemp | dwInt);
#else
        m_pINTregs->INTSUBMSK &= ~(dwInt<<m_dwIntShift);
#endif        
    }
    void    ClearInterrupt(DWORD dwInt)
    {
#if 1 //shkim-0928    
        m_pRegSMTUart->Write_UARTICR(dwInt);
#else
        m_pINTregs->SUBSRCPND = (dwInt<<m_dwIntShift);
#endif        
    }
    DWORD   GetInterruptStatus()
    { 
#if 1 //shkim-0928
        return m_pRegSMTUart->Read_UARTRIS();
#else
    return ((m_pINTregs->SUBSRCPND) >> m_dwIntShift);
#endif
    };


    DWORD   GetIntrruptMask () 
    { 
#if 1 //shkim-0928
    return m_pRegSMTUart->Read_UARTIMSC();
#else
    return ((~(m_pINTregs->INTSUBMSK) )>> m_dwIntShift); 
#endif
    };
protected:
    CRegistryEdit m_ActiveReg;
//  Interrupt Handler
    DWORD       m_dwSysIntr;
    HANDLE      m_hISTEvent;
// Optional Parameter
    DWORD m_dwDevIndex;
    DWORD m_dwISTTimeout;

};

#endif
