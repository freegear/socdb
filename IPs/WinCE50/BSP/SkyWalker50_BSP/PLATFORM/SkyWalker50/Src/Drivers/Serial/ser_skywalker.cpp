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

    Serial PDD for SMT SKYWALKER Development Board.

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
#include <smt926a_ioport.h>

// CPddskywalkerSerial1 is only use for UART 0 which 
// RTS & CTS is use GPH0 GPH1
// DTR & DSR is USE GPD0 GPD1
class CPddSMTSerial1 : public CPddSMTUart {
public:
    CPddSMTSerial1(LPTSTR lpActivePath, PVOID pMdd, PHWOBJ pHwObj)
        : CPddSMTUart(lpActivePath, pMdd, pHwObj)
        {
        m_pIOPregs = NULL;
        m_fIsDSRSet = FALSE;
    }
    ~CPddSMTSerial1() {
        if (m_pIOPregs!=NULL)
            MmUnmapIoSpace((PVOID)m_pIOPregs,0);
    }
    virtual BOOL Init() {
#if 1 //shkim-0927		
		return TRUE;
#else
        PHYSICAL_ADDRESS    ioPhysicalBase = { SMT926A_BASE_REG_PA_IOPORT, 0};
        ULONG               inIoSpace = 0;
        if (TranslateBusAddr(m_hParent,Internal,0, ioPhysicalBase,&inIoSpace,&ioPhysicalBase)) {
            // Map it if it is Memeory Mapped IO.
            m_pIOPregs = (SMT926A_IOPORT_REG *)MmMapIoSpace(ioPhysicalBase, sizeof(SMT926A_IOPORT_REG),FALSE);
        }
        if (m_pIOPregs) {
            DDKISRINFO ddi;
            if (GetIsrInfo(&ddi)== ERROR_SUCCESS && 
                    KernelIoControl(IOCTL_HAL_REQUEST_SYSINTR, &ddi.dwIrq, sizeof(UINT32), &ddi.dwSysintr, sizeof(UINT32), NULL))
            {   
                RegSetValueEx(DEVLOAD_SYSINTR_VALNAME,REG_DWORD,(PBYTE)&ddi.dwSysintr, sizeof(UINT32));
            }
            else
                return FALSE;
            m_pDTRPort = (volatile ULONG *)&(m_pIOPregs->GPDDAT);
            m_pDSRPort = (volatile ULONG *)&(m_pIOPregs->GPDDAT);
            m_dwDTRPortNum = 0;
            m_dwDSRPortNum = 1;

	        m_pIOPregs->GPHCON &= ~(0x3<<0 | 0x3<<2 | 0x3<<4 | 0x3<<6 );//tx,rx,rts,cts
        	m_pIOPregs->GPHCON |=  (0x2<<0 | 0x2<<2 | 0x2<<4 | 0x2<<6 ); 
        	m_pIOPregs->GPHCON |= (0x2<<0 | 0x2<<2);
        	m_pIOPregs->GPHUP  |= 0xf;

	        m_pIOPregs->GPDCON &= ~(0x3<<0 | 0x3<<2);//dtr,dsr
        	m_pIOPregs->GPDCON |= (0x1<<0 | 0x0<<2);
        	m_pIOPregs->GPDUP  |= 0x3;

            return CPddSMTUart::Init();
        }
        return FALSE;
#endif		
    };
    virtual void    SetDefaultConfiguration() {
        CPddSMTUart::SetDefaultConfiguration();
    }
    virtual BOOL    InitModem(BOOL bInit) {
        SetDTR(bInit);
        return CPddSMTUart::InitModem(bInit);
    }
    virtual ULONG   GetModemStatus() {
#if 1//shkim-0927 : no need of modem fuction		
		return 0;
#else
        ULONG ulReturn = CPddSMTUart::GetModemStatus();
        ULONG ulEvent = 0;
        m_HardwareLock.Lock();
        BOOL fIsDSRSet = (((*m_pDSRPort) & (1<<m_dwDSRPortNum))==0);
        if (fIsDSRSet != m_fIsDSRSet) {
            ulEvent |= EV_DSR | EV_RLSD;
        }
        ulReturn |= (fIsDSRSet?(MS_DSR_ON|MS_RLSD_ON):0);
        m_fIsDSRSet = fIsDSRSet;
        m_HardwareLock.Unlock();
        if (ulEvent!=0)
            EventCallback(ulEvent,ulReturn);
        return ulReturn;
#endif
    }
    virtual void    SetDTR(BOOL bSet) {
#if 0 //shkim-0927 : no need of modem fuction
        if (bSet)
            *m_pDTRPort &= ~(1<<m_dwDTRPortNum);
        else
            *m_pDTRPort |= (1<<m_dwDTRPortNum);
#endif
    };
private:
    volatile SMT926A_IOPORT_REG * m_pIOPregs; 
    volatile ULONG *    m_pDTRPort;
    DWORD               m_dwDTRPortNum;
    volatile ULONG *    m_pDSRPort;
    DWORD               m_dwDSRPortNum;
    BOOL                m_fIsDSRSet;
};


// CPddSMTSerial2 is only use for UART 2 which 
// nIrDATXDEN use GPB1
class CPddSMTSerial2 : public CPddSMTUart {
public:
    CPddSMTSerial2(LPTSTR lpActivePath, PVOID pMdd, PHWOBJ pHwObj)
        : CPddSMTUart(lpActivePath, pMdd, pHwObj)
        {
        m_pIOPregs = NULL;
    }
    ~CPddSMTSerial2() {
        if (m_pIOPregs!=NULL)
            MmUnmapIoSpace((PVOID)m_pIOPregs,0);
    }
    virtual BOOL Init() {
#if 1 //shkim-0927
		return TRUE;
#else
        PHYSICAL_ADDRESS    ioPhysicalBase = { SMT926A_BASE_REG_PA_IOPORT, 0};
        ULONG               inIoSpace = 0;
        if (TranslateBusAddr(m_hParent,Internal,0, ioPhysicalBase,&inIoSpace,&ioPhysicalBase)) {
            // Map it if it is Memeory Mapped IO.
            m_pIOPregs =(SMT926A_IOPORT_REG *) MmMapIoSpace(ioPhysicalBase, sizeof(SMT926A_IOPORT_REG),FALSE);
        }
        if (m_pIOPregs) {
            DDKISRINFO ddi;
            if (GetIsrInfo(&ddi)== ERROR_SUCCESS && 
                    KernelIoControl(IOCTL_HAL_REQUEST_SYSINTR, &ddi.dwIrq, sizeof(UINT32), &ddi.dwSysintr, sizeof(UINT32), NULL))
            {   
                RegSetValueEx(DEVLOAD_SYSINTR_VALNAME,REG_DWORD,(PBYTE)&ddi.dwSysintr, sizeof(UINT32));
            }
            else
                return FALSE;

	        m_pIOPregs->GPHCON &= ~(0x3<<12 | 0x3<<14); // uart 2 - rx, tx
	        m_pIOPregs->GPHCON |= (0x2<<12 | 0x2<<14); 
    	    m_pIOPregs->GPHUP |= 0xc0;
        
	        m_pIOPregs->GPBCON &= ~(0x3<<2);	//GPB1 -> nIrDATXDEN
    	    m_pIOPregs->GPBCON |=  (0x1<<2); 
        	m_pIOPregs->GPBUP  |=  (0x1<<1);
	        m_pIOPregs->GPBDAT &= ~(0x1<<1);

            return CPddSMTUart::Init();
        }
        return FALSE;
#endif		
    };
    virtual void    SetDefaultConfiguration() {
        CPddSMTUart::SetDefaultConfiguration();
    }
    virtual ULONG   GetModemStatus() {
#if 1//shkim-0927		
		return 0;
#else
        return (CPddSMTUart::GetModemStatus() | MS_CTS_ON);
#endif
    }
    virtual void    Rx_Pause(BOOL bSet) {
#if 0 //shkim-0927		
    	if(bSet)
    		m_pIOPregs->GPHCON = (m_pIOPregs->GPHCON & ~(0x3<<14)) | 0x0<<14;
    	else	
    		m_pIOPregs->GPHCON = (m_pIOPregs->GPHCON & ~(0x3<<14)) | 0x2<<14;
#endif		
    }

    volatile SMT926A_IOPORT_REG * m_pIOPregs; 
};
CSerialPDD * CreateSerialObject(LPTSTR lpActivePath, PVOID pMdd,PHWOBJ pHwObj, DWORD DeviceArrayIndex)
{
    CSerialPDD * pSerialPDD = NULL;
    switch (DeviceArrayIndex) {
      case 0:
        pSerialPDD = new CPddSMTSerial1(lpActivePath,pMdd, pHwObj);
        break;
      case 1:
        pSerialPDD = new CPddSMTSerial2(lpActivePath,pMdd, pHwObj);
        break;
    }
    if (pSerialPDD && !pSerialPDD->Init()) {
        delete pSerialPDD;
        pSerialPDD = NULL;
    }    
    return pSerialPDD;
}
void DeleteSerialObject(CSerialPDD * pSerialPDD)
{
    if (pSerialPDD)
        delete pSerialPDD;
}

