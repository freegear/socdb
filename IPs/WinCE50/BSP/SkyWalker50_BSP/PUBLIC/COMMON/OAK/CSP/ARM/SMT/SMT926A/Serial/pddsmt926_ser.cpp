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
//
/*++
THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
PARTICULAR PURPOSE.

Module Name:  

Abstract:

    Serial PDD for SMT SkyWalker UART Common Code.

Notes: 
--*/
#include <windows.h>
#include <types.h>
#include <ceddk.h>

#include <ddkreg.h>
#include <serhw.h>
#include <Serdbg.h>
#include <pddsmt926_ser.h>
#include <smt926a_base_regs.h>
CRegSMTUart::CRegSMTUart(PULONG pRegAddr)
:   m_pReg(pRegAddr)
{
    m_fIsBackedUp = FALSE;
    PROCESSOR_INFO procInfo;
    DWORD dwBytesReturned;
    if (!KernelIoControl(IOCTL_PROCESSOR_INFORMATION, NULL, 0, &procInfo, sizeof(PROCESSOR_INFO), &dwBytesReturned))
    {
#if 1 //shkim-0927 : uart input clock issue    
        m_smt926_pclk = DEFAULT_SMT926A_HCLK;
#endif
        RETAILMSG(TRUE, (TEXT("WARNING: CRegSMTUart::CRegSMTUart failed to obtain processor frequency - using default value (%d).\r\n"), m_smt926_pclk)); 
    }
    else
    {
        m_smt926_pclk = procInfo.dwClockSpeed;
        RETAILMSG(TRUE, (TEXT("INFO: CRegSMTUart::CRegSMTUart using processor frequency reported by the OAL (%d).\r\n"), m_smt926_pclk)); 
    }

}
BOOL   CRegSMTUart::Init() 
{

    if (m_pReg) { // Set Value to default.
#if 0 //shkim-0927 : which register have to be set to default further work  
        Write_ULCON(0);
        Write_UCON(0);
        Write_UFCON(0);
        Write_UMCON(0);
#endif		
        return TRUE;
    }
    else
        return FALSE;
}

void CRegSMTUart::Backup()
{
#if 1 //shkim-0927 : which registor have to be backup??? further work
    m_fIsBackedUp = TRUE;

	/* which registor have to be backup??? further work
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
	m_UARTILPRBackup = Read_UARTILPR();
	m_UARTIBRDBackup = Read_UARTIBRD();
	m_UARTFBRDBackup = Read_UARTFBRD();
	m_UARTLCR_HBackup= Read_UARTLCR_H();
	m_UARTCRBackup   = Read_UARTCR();
	m_UARTIFLSBackup = Read_UARTIFLS();
#endif	
}
void CRegSMTUart::Restore()
{
#if 1 //shkim-0927 : which registor have to be backup??? further work
    if (m_fIsBackedUp) {
		Write_UARTILPR( m_UARTILPRBackup );
		Write_UARTIBRD( m_UARTIBRDBackup );
		Write_UARTFBRD( m_UARTFBRDBackup );
		Write_UARTLCR_H( m_UARTLCR_HBackup);
		Write_UARTCR( m_UARTCRBackup );
		Write_UARTIFLS( m_UARTIFLSBackup );
        m_fIsBackedUp = FALSE;
    }
#endif	
}
CRegSMTUart::Write_BaudRate(ULONG BaudRate)
{
    DEBUGMSG(ZONE_INIT, (TEXT("SetBaudRate -> %d\r\n"), BaudRate));
#if 1//shkim-0927

    ULONG iBRD, m;
    float baudDiv, fBRD; //shkim-0927 : no floating point in kernel mode further work

    baudDiv = (float)(8*1000000)/(16*BaudRate);//shkim-0927 check data loss
    iBRD = (ULONG)baudDiv;
    fBRD = baudDiv - iBRD;
    m = (ULONG)(fBRD*64+0.5);   // m = integer(BFDF*2n + 0.5) - n is width of UARTFBRD

	Write_UARTIBRD(iBRD);
	Write_UARTFBRD(m);
   /* 
    * For PL010 must write to UARTLCR_H last to actually write to UARTLCR_L, UARTLCR_M.
    * For PL011 must write to UARTLCR_H last to actually write to UARTIBRD and UARTFBRD.
    */
    Write_UARTLCR_H(Read_UARTLCR_H());
    //baudDiv = iBRD + m/64;
    //realBaudRate = (8*1000000)/(16*baudDiv);
    return TRUE;
#endif	
}
#ifdef DEBUG
void CRegSMTUart::DumpRegister()
{
#if 0 //shkim-0927 : need DumpRegister? further work
    NKDbgPrintfW(TEXT("DumpRegister (ULCON=%x, UCON=%x, UFCON=%x, UMCOM = %x, UBDIV =%x)\r\n"),
        Read_ULCON(),Read_UCON(),Read_UFCON(),Read_UMCON(),Read_UBRDIV());
#endif
    
}
#endif

CPddSMTUart::CPddSMTUart (LPTSTR lpActivePath, PVOID pMdd, PHWOBJ pHwObj )
:   CSerialPDD(lpActivePath,pMdd, pHwObj)
,   m_ActiveReg(HKEY_LOCAL_MACHINE,lpActivePath)
,   CMiniThread (0, TRUE)   
{
    m_pRegSMTUart = NULL;
    m_pINTregs = NULL;
    m_dwIntShift = 0;
    m_dwSysIntr = MAXDWORD;
    m_hISTEvent = NULL;
    m_dwDevIndex = 0;
    m_pRegVirtualAddr = NULL;
    m_XmitFlushDone =  CreateEvent(0, FALSE, FALSE, NULL);
    m_XmitFifoEnable = FALSE;
    m_dwWaterMark = 8 ;
}
CPddSMTUart::~CPddSMTUart()
{
#if 0 //shkim-0927 : no need of Modem	
    InitModem(FALSE);
#endif    
    if (m_hISTEvent) {
        m_bTerminated=TRUE;
        ThreadStart();
        SetEvent(m_hISTEvent);
        ThreadTerminated(1000);
#if 1//shkim-0927 need to check interrupt        
        InterruptDisable( m_dwSysIntr ); 
#endif                
        CloseHandle(m_hISTEvent);
    };
    if (m_pRegSMTUart)
        delete m_pRegSMTUart;
    if (m_XmitFlushDone)
        CloseHandle(m_XmitFlushDone);
    if (m_pRegVirtualAddr != NULL) {
        MmUnmapIoSpace((PVOID)m_pRegVirtualAddr,0UL);
    }
    if (m_pINTregs!=NULL) {
        MmUnmapIoSpace((PVOID)m_pINTregs,0UL);
    }
        
}
BOOL CPddSMTUart::Init()
{
    if ( CSerialPDD::Init() && IsKeyOpened() && m_XmitFlushDone!=NULL) { 
        // IST Setup .
        DDKISRINFO ddi;
        if (GetIsrInfo(&ddi)!=ERROR_SUCCESS) {
            return FALSE;
        }
        m_dwSysIntr = ddi.dwSysintr;
#if 1 //shkim-0927 interrupt       
        if (m_dwSysIntr !=  MAXDWORD && m_dwSysIntr!=0 ) 
            m_hISTEvent= CreateEvent(0,FALSE,FALSE,NULL);
#endif            

#if 1 //shkim-0927 interrupt       
        if (m_hISTEvent!=NULL)
            InterruptInitialize(m_dwSysIntr,m_hISTEvent,0,0);
        else
            return FALSE;
#endif  

#if 1 //shkim-0927
        // Get Device Index.
        if (!GetRegValue(PC_REG_DEVINDEX_VAL_NAME, (PBYTE)&m_dwDevIndex, PC_REG_DEVINDEX_VAL_LEN)) {
            m_dwDevIndex = 0;
        }
        if (!GetRegValue(PC_REG_SERIALWATERMARK_VAL_NAME,(PBYTE)&m_dwWaterMark,sizeof(DWORD))) {
            m_dwWaterMark = 8;//fifo trigger level
        }
        if (!GetRegValue(PC_REG_SMTUART_INTBIT_VAL_NAME,(PBYTE)&m_dwIntShift,sizeof(DWORD))) {
            RETAILMSG(1,(TEXT("Registery does not have %s set. Drivers fail!!!\r\n"),PC_REG_SMTUART_INTBIT_VAL_NAME));
            m_dwIntShift =0;
            return FALSE;
        }
        if (!GetRegValue(PC_REG_SMTUART_IST_TIMEOUTS_VAL_NAME,(PBYTE)&m_dwISTTimeout, PC_REG_SMTUART_IST_TIMEOUTS_VAL_LEN)) {
            m_dwISTTimeout = INFINITE;
        }
        if (!MapHardware() || !CreateHardwareAccess()) {
            return FALSE;
        }
#endif        
        return TRUE;        
    }
    return FALSE;
}
BOOL CPddSMTUart::MapHardware() 
{
    if (m_pRegVirtualAddr !=NULL)
        return TRUE;

    // Get IO Window From Registry
    DDKWINDOWINFO dwi;
    if ( GetWindowInfo( &dwi)!=ERROR_SUCCESS || 
            dwi.dwNumMemWindows < 1 || 
            dwi.memWindows[0].dwBase == 0 || 
            dwi.memWindows[0].dwLen <  0x2c)
        return FALSE;
    DWORD dwInterfaceType;
    if (m_ActiveReg.IsKeyOpened() && 
            m_ActiveReg.GetRegValue( DEVLOAD_INTERFACETYPE_VALNAME, (PBYTE)&dwInterfaceType,sizeof(DWORD))) {
        dwi.dwInterfaceType = dwInterfaceType;
    }

    // Translate to System Address.
    PHYSICAL_ADDRESS    ioPhysicalBase = { dwi.memWindows[0].dwBase, 0};
    ULONG               inIoSpace = 0;
    if (TranslateBusAddr(m_hParent,(INTERFACE_TYPE)dwi.dwInterfaceType,dwi.dwBusNumber, ioPhysicalBase,&inIoSpace,&ioPhysicalBase)) {
        // Map it if it is Memeory Mapped IO.
        m_pRegVirtualAddr = MmMapIoSpace(ioPhysicalBase, dwi.memWindows[0].dwLen,FALSE);
    }
    ioPhysicalBase.LowPart = SMT926A_BASE_REG_PA_INTR ;
    ioPhysicalBase.HighPart = 0;
    inIoSpace = 0; 
    if (TranslateBusAddr(m_hParent,(INTERFACE_TYPE)dwi.dwInterfaceType,dwi.dwBusNumber, ioPhysicalBase,&inIoSpace,&ioPhysicalBase)) {
        m_pINTregs = (SMT926A_INTR_REG *) MmMapIoSpace(ioPhysicalBase,sizeof(SMT926A_INTR_REG),FALSE);
    }
    return (m_pRegVirtualAddr!=NULL && m_pINTregs!=NULL);
}
BOOL CPddSMTUart::CreateHardwareAccess()
{
    if (m_pRegSMTUart)
        return TRUE;
    if (m_pRegVirtualAddr!=NULL) {
        m_pRegSMTUart = new CRegSMTUart((PULONG)m_pRegVirtualAddr);
        if (m_pRegSMTUart && !m_pRegSMTUart->Init()) { // FALSE.
            delete m_pRegSMTUart ;
            m_pRegSMTUart = NULL;
        }
            
    }
    return (m_pRegSMTUart!=NULL);
}
#define MAX_RETRY 0x1000
void CPddSMTUart::PostInit()
{
    DWORD dwCount=0;
    m_HardwareLock.Lock();
#if 0 //shkim-0928 : further work
	m_pRegSMTUart->Write_UCON(0); // Set to Default;
#endif
    DisableInterrupt(SMTUART_INT_RXD|SMTUART_INT_TXD|SMTUART_INT_ERR);
    // Mask all interrupt.
    while ((GetInterruptStatus() & (SMTUART_INT_RXD|SMTUART_INT_TXD|SMTUART_INT_ERR))!=0 && 
            dwCount <MAX_RETRY) { // Interrupt.
        InitReceive(TRUE);
        InitLine(TRUE);
        ClearInterrupt(SMTUART_INT_RXD|SMTUART_INT_TXD|SMTUART_INT_ERR);
        dwCount++;
    }
    ASSERT((GetInterruptStatus() & (SMTUART_INT_RXD|SMTUART_INT_TXD|SMTUART_INT_ERR))==0);
    // IST Start to Run.
    m_HardwareLock.Unlock();
    CSerialPDD::PostInit();
    CeSetPriority(m_dwPriority256);
#ifdef DEBUG
    if ( ZONE_INIT )
        m_pRegSMTUart->DumpRegister();
#endif
    ThreadStart();  // Start IST.
}
DWORD CPddSMTUart::ThreadRun()
{
    while ( m_hISTEvent!=NULL && !IsTerminated()) {
        if (WaitForSingleObject( m_hISTEvent,m_dwISTTimeout)==WAIT_OBJECT_0) {
            m_HardwareLock.Lock();    
#if 1 //shkim-0927 interrupt            	
            while (!IsTerminated() ) {
                DWORD dwData = (GetInterruptStatus() & (SMTUART_INT_RXD|SMTUART_INT_TXD|SMTUART_INT_ERR));
                DWORD dwMask = (GetIntrruptMask() & (SMTUART_INT_RXD|SMTUART_INT_TXD|SMTUART_INT_ERR));
                 DEBUGMSG(ZONE_THREAD,
                      (TEXT(" CPddSMTUart::ThreadRun INT=%x, MASK =%x\r\n"),dwData,dwMask));
                dwMask &= dwData;
                if (dwMask) {
                    DEBUGMSG(ZONE_THREAD,
                      (TEXT(" CPddSMTUart::ThreadRun Active INT=%x\r\n"),dwMask));
                    DWORD interrupts=INTR_MODEM; // Always check Modem when we have change. It may work at polling mode.
                    if ((dwMask & SMTUART_INT_RXD)!=0)
                        interrupts |= INTR_RX;
                    if ((dwMask & SMTUART_INT_TXD)!=0)
                        interrupts |= INTR_TX;
                    if ((dwMask & SMTUART_INT_ERR)!=0) 
                        interrupts |= INTR_LINE|INTR_RX;
                    NotifyPDDInterrupt((INTERRUPT_TYPE)interrupts);
                    ClearInterrupt(dwData);
                }
                else 
                    break;
            }
#endif            
            m_HardwareLock.Unlock();   
            InterruptDone(m_dwSysIntr);
        }
        else { // Polling Modem.
            NotifyPDDInterrupt(INTR_MODEM);


             DEBUGMSG(ZONE_THREAD,(TEXT(" CPddSMTUart::ThreadRun timeout INT=%x,MASK=%d\r\n")\
																	,m_pINTregs->SUBSRCPND\
																	,m_pINTregs->INTSUBMSK));

#ifdef DEBUG
            if ( ZONE_THREAD )
                m_pRegSMTUart->DumpRegister();
#endif
        }
    }
    return 1;
}
BOOL CPddSMTUart::InitialEnableInterrupt(BOOL bEnable )
{
    m_HardwareLock.Lock();
    if (bEnable) 
        EnableInterrupt(SMTUART_INT_RXD | SMTUART_INT_ERR );
    else
        DisableInterrupt(SMTUART_INT_RXD | SMTUART_INT_ERR );
    m_HardwareLock.Unlock();
    return TRUE;
}

BOOL  CPddSMTUart::InitXmit(BOOL bInit)
{
    if (bInit) { 
        m_HardwareLock.Lock();    
#if 1 //shkim-0927
// init UART for transmit further work
#else
        DWORD dwBit = m_pRegSMTUart->Read_UCON();
        // Set TxINterrupt To Level.
        dwBit |= (1<<9);
        // Set Interrupt Tx Mode.
        dwBit &= ~(3<<2);
        dwBit |= (1<<2);
        m_pRegSMTUart->Write_UCON(dwBit );

        dwBit = m_pRegSMTUart->Read_UFCON();
        // Reset Xmit Fifo.
        dwBit |= (1<<2);
        dwBit &= ~(1<<0);
        m_pRegSMTUart->Write_UFCON( dwBit);
        // Set Trigger level to 16. 
        dwBit &= ~(3<<6);//empty
        dwBit |= (1<<6);//16
        m_pRegSMTUart->Write_UFCON(dwBit); 
        // Enable Xmit FIFO.
        dwBit &= ~(1<<2);
        dwBit |= (1<<0);
        m_pRegSMTUart->Write_UFCON(dwBit); // Xmit Fifo Reset Done..
#endif        
        m_HardwareLock.Unlock();
    }
    else { // Make Sure data has been trasmit out.
        // We have to make sure the xmit is complete because MDD will shut donw the device after this return
#if 1//shkim-0927
        DWORD dwTicks = 0;
        DWORD dwUTRState;

        while (dwTicks < 1000 && 
                (((dwUTRState = m_pRegSMTUart->Read_UARTFR())>>7) & 1) != 1 )
        { // Transmitter empty is not true
            DEBUGMSG(ZONE_THREAD|ZONE_WRITE,(TEXT("CPdd16550::InitXmit! Wait for UTRSTAT=%x clear.\r\n"), dwUTRState));
            Sleep(5);
            dwTicks +=5;
        }
#endif	                
		
    }
    return TRUE;
}
DWORD   CPddSMTUart::GetWriteableSize()
{
#if 1 //shkim-0927 :  no h/w support further work
	return 0;
#else
    DWORD dwWriteSize = 0;
    DWORD dwUfState = m_pRegSMTUart->Read_UFSTAT() ;
    if ((dwUfState& (1<<14))==0) { // It is not full.
        dwUfState = ((dwUfState>>8) & 0x3f); // It is fifo count.
        if (dwUfState < SERSMT_FIFO_DEPTH_TX-1)
            dwWriteSize = SERSMT_FIFO_DEPTH_TX-1 - dwUfState;
    }
    return dwWriteSize;
#endif    
}
void    CPddSMTUart::XmitInterruptHandler(PUCHAR pTxBuffer, ULONG *pBuffLen)
{
    PREFAST_DEBUGCHK(pBuffLen!=NULL);
    m_HardwareLock.Lock();    
    if (*pBuffLen == 0) { 
        EnableXmitInterrupt(FALSE);
    }
    else {
        DEBUGCHK(pTxBuffer);
        PulseEvent(m_XmitFlushDone);
        DWORD dwDataAvaiable = *pBuffLen;
        *pBuffLen = 0;

		Rx_Pause(TRUE);
        if ((m_DCB.fOutxCtsFlow && IsCTSOff()) ||(m_DCB.fOutxDsrFlow && IsDSROff())) { // We are in flow off
            DEBUGMSG(ZONE_THREAD|ZONE_WRITE,(TEXT("CPdd16550::XmitInterruptHandler! Flow Off, Data Discard.\r\n")));
            EnableXmitInterrupt(FALSE);
        }
        else  {
            DWORD dwWriteSize = GetWriteableSize();
            DEBUGMSG(ZONE_THREAD|ZONE_WRITE,(TEXT("CPdd16550::XmitInterruptHandler! WriteableSize=%x to FIFO,dwDataAvaiable=%x\r\n"),
                    dwWriteSize,dwDataAvaiable));
            for (DWORD dwByteWrite=0; dwByteWrite<dwWriteSize && dwDataAvaiable!=0;dwByteWrite++) {
#if 1 //shkim-0927 : interrupt	
               m_pRegSMTUart->Write_UARTDR(*pTxBuffer);
#endif    
                pTxBuffer ++;
                dwDataAvaiable--;
            }
            DEBUGMSG(ZONE_THREAD|ZONE_WRITE,(TEXT("CPdd16550::XmitInterruptHandler! Write %d byte to FIFO\r\n"),dwByteWrite));
            *pBuffLen = dwByteWrite;
            EnableXmitInterrupt(TRUE);        
        }
        ClearInterrupt(SMTUART_INT_TXD);
#if 0//shkim-0928 : further work
		if (m_pRegSMTUart->Read_ULCON() & (0x1<<6))
			while( (m_pRegSMTUart->Read_UFSTAT() >> 0x8 ) & 0x3f );
#endif
		Rx_Pause(FALSE);
    }
    m_HardwareLock.Unlock();
}

void    CPddSMTUart::XmitComChar(UCHAR ComChar)
{
    // This function has to poll until the Data can be sent out.
    BOOL bDone = FALSE;
    do {
        m_HardwareLock.Lock(); 
        if ( GetWriteableSize()!=0 ) {  // If not full 
#if 1 //shkim-0928	
            m_pRegSMTUart->Write_UARTDR(ComChar);
#endif	
            bDone = TRUE;
        }
        else {
            EnableXmitInterrupt(TRUE);
        }
        m_HardwareLock.Unlock();
        if (!bDone)
           WaitForSingleObject(m_XmitFlushDone, (ULONG)1000); 
    }
    while (!bDone);
}
BOOL    CPddSMTUart::EnableXmitInterrupt(BOOL fEnable)
{
    m_HardwareLock.Lock();
    if (fEnable)
        EnableInterrupt(SMTUART_INT_TXD);
    else
        DisableInterrupt(SMTUART_INT_TXD);
    m_HardwareLock.Unlock();
    return TRUE;
        
}
BOOL  CPddSMTUart::CancelXmit()
{
    return InitXmit(TRUE);     
}
static PAIRS s_HighWaterPairs[] = {
    {0, 1 },
    {1, 8 },
    {2, 16 },
    {3, 32 }
};

BYTE  CPddSMTUart::GetWaterMarkBit()
{
    BYTE bReturnKey = (BYTE)s_HighWaterPairs[0].Key;
    for (DWORD dwIndex=dim(s_HighWaterPairs)-1;dwIndex!=0; dwIndex --) {
        if (m_dwWaterMark>=s_HighWaterPairs[dwIndex].AssociatedValue) {
            bReturnKey = (BYTE)s_HighWaterPairs[dwIndex].Key;
            break;
        }
    }
    return bReturnKey;
}
DWORD   CPddSMTUart::GetWaterMark()
{
    BYTE bReturnValue = (BYTE)s_HighWaterPairs[0].AssociatedValue;
    for (DWORD dwIndex=dim(s_HighWaterPairs)-1;dwIndex!=0; dwIndex --) {
        if (m_dwWaterMark>=s_HighWaterPairs[dwIndex].AssociatedValue) {
            bReturnValue = (BYTE)s_HighWaterPairs[dwIndex].AssociatedValue;
            break;
        }
    }
    return bReturnValue;
}

// Receive
BOOL    CPddSMTUart::InitReceive(BOOL bInit)
{

#if 1//shkim-0927	further work
	/*
		1. fifo setup:	RX FIFO reset
						RX FIFO trigger level
						Enable RX FIFO
		2. clean Line error stuatus
		3. enable RX time out/level interrupt trigger
	*/
	return TRUE;
#else
    m_HardwareLock.Lock();    
    if (bInit) {         
        BYTE uWarterMarkBit = GetWaterMarkBit();
        if (uWarterMarkBit> 3)
            uWarterMarkBit = 3;
        // Setup Receive FIFO.
        // Reset Receive Fifo.
        DWORD dwBit = m_pRegSMTUart->Read_UFCON();
        dwBit |= (1<<1);
        dwBit &= ~(1<<0);
        m_pRegSMTUart->Write_UFCON( dwBit);
        // Set Trigger level to WaterMark.
        dwBit &= ~(3<<4);
        dwBit |= (uWarterMarkBit<<4);
        m_pRegSMTUart->Write_UFCON(dwBit); 
        // Enable Receive FIFO.
        dwBit &= ~(1<<1);
        dwBit |= (1<<0);
        m_pRegSMTUart->Write_UFCON(dwBit); // Xmit Fifo Reset Done..
        m_pRegSMTUart->Read_UERSTAT(); // Clean Line Interrupt.
        dwBit = m_pRegSMTUart->Read_UCON();
        dwBit &= ~(3<<0);
        dwBit |= (1<<0)|(1<<7)|(1<<8); // Enable Rx Timeout and Level Interrupt Trigger.
        m_pRegSMTUart->Write_UCON(dwBit);
        EnableInterrupt(SMTUART_INT_RXD | SMTUART_INT_ERR );
    }
    else {
        DisableInterrupt(SMTUART_INT_RXD | SMTUART_INT_ERR );
    }
    m_HardwareLock.Unlock();
    return TRUE;
#endif	
}
ULONG   CPddSMTUart::ReceiveInterruptHandler(PUCHAR pRxBuffer,ULONG *pBufflen)
{
    DEBUGMSG(ZONE_THREAD|ZONE_READ,(TEXT("+CPddSMTUart::ReceiveInterruptHandler pRxBuffer=%x,*pBufflen=%x\r\n"),
        pRxBuffer,pBufflen!=NULL?*pBufflen:0));
    DWORD dwBytesDropped = 0;
#if 0 //shkim-0927	further work
    if (pRxBuffer && pBufflen ) {
        DWORD dwBytesStored = 0 ;
        DWORD dwRoomLeft = *pBufflen;
        m_bReceivedCanceled = FALSE;
        m_HardwareLock.Lock();
        
        while (dwRoomLeft && !m_bReceivedCanceled) {
            ULONG ulUFSTATE = m_pRegSMTUart->Read_UFSTAT();
            DWORD dwNumRxInFifo = (ulUFSTATE & (0x3f<<0));
            if ((ulUFSTATE & (1<<6))!=0) // Overflow. Use FIFO depth (16);
                dwNumRxInFifo = SERSMT_FIFO_DEPTH_RX;
            DEBUGMSG(ZONE_THREAD|ZONE_READ,(TEXT("CPddSMTUart::ReceiveInterruptHandler ulUFSTATE=%x,UTRSTAT=%x, dwNumRxInFifo=%X\r\n"),
                ulUFSTATE, m_pRegSMTUart->Read_UTRSTAT(), dwNumRxInFifo));
            if (dwNumRxInFifo) {
                ASSERT((m_pRegSMTUart->Read_UTRSTAT () & (1<<0))!=0);
                while (dwNumRxInFifo && dwRoomLeft) {
#if 1 //shkim-0928 Read UARTDR first then you can get the line status.
      // refer to SDI UART spec.... 
                   UCHAR uData = (UCHAR)m_pRegSMTUart->Read_UARTDR();
                   UCHAR uLineStatus = GetLineStatus();
#endif
                    if (DataReplaced(&uData,(uLineStatus & UERSTATE_PARITY_ERROR)!=0)) {
                        *pRxBuffer++ = uData;
                        dwRoomLeft--;
                        dwBytesStored++;                    
                    }
                    dwNumRxInFifo --;
                }
            }
            else
                break;
        }
        if (m_bReceivedCanceled)
            dwBytesStored = 0;
        
        m_HardwareLock.Unlock();
        *pBufflen = dwBytesStored;
    }
    else {
        ASSERT(FALSE);
    }

    DEBUGMSG(ZONE_THREAD|ZONE_READ,(TEXT("-CPddSMTUart::ReceiveInterruptHandler pRxBuffer=%x,*pBufflen=%x,dwBytesDropped=%x\r\n"),
        pRxBuffer,pBufflen!=NULL?*pBufflen:0,dwBytesDropped));
#endif	
    return dwBytesDropped;
}
ULONG   CPddSMTUart::CancelReceive()
{
    m_bReceivedCanceled = TRUE;
    m_HardwareLock.Lock();   
    InitReceive(TRUE);
    m_HardwareLock.Unlock();
    return 0;
}
BOOL    CPddSMTUart::InitModem(BOOL bInit)
{
#if 1 //shkim-0927 : no need of modem fuction
	return FALSE;
#else
    m_HardwareLock.Lock();   
    m_pRegSMTUart->Write_UMCON((1<<0)); // Disable AFC and Set RTS as default.
    m_HardwareLock.Unlock();
	
    return TRUE;
#endif
}

ULONG   CPddSMTUart::GetModemStatus()
{
#if 1//shkim-0927 : no need of modem fuction
	return 0;
#else
    m_HardwareLock.Lock();    
    ULONG ulReturn =0 ;
    ULONG Events = 0;
    UINT8 ubModemStatus = (UINT8) m_pRegSMTUart->Read_UMSTAT();
    m_HardwareLock.Unlock();

    // Event Notification.
    if (ubModemStatus & (1<<2))
        Events |= EV_CTS;
    if (Events!=0)
        EventCallback(Events);

    // Report Modem Status;
    if ( ubModemStatus & (1<<0) )
        ulReturn |= MS_CTS_ON;
    return ulReturn;
#endif
}
void    CPddSMTUart::SetRTS(BOOL bSet)
{
#if 0 //shkim-0927 : no need of modem fuction
    m_HardwareLock.Lock();
    ULONG ulData = m_pRegSMTUart->Read_UMCON();
    if (bSet) {
        ulData |= (1<<0);
    }
    else
        ulData &= ~(1<<0);
    m_pRegSMTUart->Write_UMCON(ulData);
    m_HardwareLock.Unlock();
#endif
}
BOOL CPddSMTUart::InitLine(BOOL bInit)
{
#if 1 //shkim-0927
    m_HardwareLock.Lock();
    if  (bInit) {
        // Set 8Bit,1Stop,NoParity,Normal Mode.
        //m_pRegSMTUart->Write_ULCON( (0x3<<0) | (0<<1) | (0<<3) | (0<<6) );
        EnableInterrupt( SMTUART_INT_ERR );
    }
    else {
        DisableInterrupt(SMTUART_INT_ERR );
    }
    m_HardwareLock.Unlock();
#endif
    return TRUE;
}
BYTE CPddSMTUart::GetLineStatus()
{
#if 1//shkim-0927
    m_HardwareLock.Lock();
    ULONG ulData = m_pRegSMTUart->Read_UARTDR();
    m_HardwareLock.Unlock();  
    ULONG ulError = 0;


    if (ulData & (1<<0) ) {
        ulError |=  CE_FRAME;
    }
    if (ulData & (1<<1)) {
        ulError |= CE_RXPARITY;
    }
	if (ulData & (1<<3)){
		ulError |= CE_OVERRUN;	
	}
    
    if (ulError)
        SetReceiveError(ulError);
   
	if (ulData & (1<<2)) {
         EventCallback(EV_BREAK);
    }
	
#if 0//shkim-0927 : need to clear the UARTSR? further work
	m_pRegSMTUart->Write_UARTSR(0x00);
#endif	
    return (UINT8)ulData;
#endif
        
}
void    CPddSMTUart::SetBreak(BOOL bSet)
{
    m_HardwareLock.Lock();
#if 1 //shkim-0927
	ULONG ulData = m_pRegSMTUart->Read_UARTLCR_H();
	if(bSet)
		ulData |= SEND_BREAK_ENABLE;
	else
		ulData &= SEND_BREAK_DISABLE;
	m_pRegSMTUart->Write_UARTLCR_H(ulData);
#endif
    m_HardwareLock.Unlock();      
}
BOOL    CPddSMTUart::SetBaudRate(ULONG BaudRate,BOOL /*bIrModule*/)
{
    m_HardwareLock.Lock();
    BOOL bReturn = m_pRegSMTUart->Write_BaudRate(BaudRate);
    m_HardwareLock.Unlock();      
    return TRUE;
}
BOOL    CPddSMTUart::SetByteSize(ULONG ByteSize)
{
    BOOL bRet = TRUE;
    m_HardwareLock.Lock();
#if 1 //shkim-0928
	ULONG ulData = m_pRegSMTUart->Read_UARTLCR_H() & (~(WORD_LENGTH));
    switch ( ByteSize ) {
    case 5: 
        break;
    case 6:
        ulData |= (DATA_6BIT<<WORD_LENGTH_BS);
        break;
    case 7:
        ulData |= (DATA_7BIT<<WORD_LENGTH_BS);
        break;
    case 8:
        ulData |= (DATA_8BIT<<WORD_LENGTH_BS);
        break;
    default:
        bRet = FALSE;
        break;
    }
	if(bRet){
		m_pRegSMTUart->Write_UARTLCR_H(ulData);
	}
    m_HardwareLock.Unlock();
#endif
    return bRet;
}
BOOL    CPddSMTUart::SetParity(ULONG Parity)
{
    BOOL bRet = TRUE;
    m_HardwareLock.Lock();
#if 1 //shkim-0927
    ULONG ulData = m_pRegSMTUart->Read_UARTLCR_H() & (~((STICK_PAR_SEL)|(EVEN_PARITY_SEL)|(PARITY_EN)));

switch ( Parity ) {
    case ODDPARITY:
        ulData |= (PARITY_ENABLE<<SHIFT_DN_FROM_MASK(PARITY_EN));
        break;
    case EVENPARITY:
        ulData |= (PARITY_ENABLE<<SHIFT_DN_FROM_MASK(PARITY_EN));
        ulData |= (EVEN_PARITY<<SHIFT_DN_FROM_MASK(EVEN_PARITY_SEL));
        break;
    case MARKPARITY:
        ulData |= (PARITY_ENABLE<<SHIFT_DN_FROM_MASK(PARITY_EN));
        ulData |= (EVEN_PARITY<<SHIFT_DN_FROM_MASK(EVEN_PARITY_SEL));
        ulData |= (STICK_PARITY_ENABLE<<SHIFT_DN_FROM_MASK(STICK_PAR_SEL));
        break;
    case SPACEPARITY:
        ulData |= (PARITY_ENABLE<<SHIFT_DN_FROM_MASK(PARITY_EN));
        ulData |= (STICK_PARITY_ENABLE<<SHIFT_DN_FROM_MASK(STICK_PAR_SEL));
        break;
    case NOPARITY:
        break;
    default:
        bRet = FALSE;
        break;
    }
    if (bRet) {
        m_pRegSMTUart->Write_UARTLCR_H(ulData);
    }
#endif
    m_HardwareLock.Unlock();
    return bRet;
}
BOOL    CPddSMTUart::SetStopBits(ULONG StopBits)
{
    BOOL bRet = TRUE;
    m_HardwareLock.Lock();
#if 1//shkim-0927
    ULONG ulData = m_pRegSMTUart->Read_UARTLCR_H() & ~(T_STOP_BIT_SEL);

    switch ( StopBits )
	{
	    case ONESTOPBIT :
	        break;
	    case TWOSTOPBITS :
	        ulData |= (TWO_STOP_BIT<<SHIFT_DN_FROM_MASK(T_STOP_BIT_SEL));
	        break;
	    default:
	        bRet = FALSE;
	        break;
    }
    if (bRet)
	{
        m_pRegSMTUart->Write_UARTLCR_H(ulData);
    }
#endif
    m_HardwareLock.Unlock();
    return bRet;
}
void    CPddSMTUart::SetOutputMode(BOOL UseIR, BOOL Use9Pin)
{
    m_HardwareLock.Lock();	
    CSerialPDD::SetOutputMode(UseIR, Use9Pin);
#if 0 //shkim-0927	further work
    ULONG ulData = m_pRegSMTUart->Read_ULCON() & (~(0x1<<6));
    ulData |= (UseIR?(0x1<<6):0);
    m_pRegSMTUart->Write_ULCON(ulData);
#endif	
    m_HardwareLock.Unlock();
}

