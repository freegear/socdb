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

/* 
 * This driver uses EINT0 button as POWER ON/OFF Button.
 * 
 */

#include <windows.h>
#include <types.h>
#include <excpt.h>
#include <tchar.h>
#include <cardserv.h>
#include <cardapi.h>
#include <tuple.h>
#include <devload.h>
#include <diskio.h>
#include <nkintr.h>
#include <windev.h>

#include "BSP.h"
#include "pwrbtnskywalker.h"

#define PRIVATE			static
#define PUBLIC

typedef DWORD (*PFN_SetSystemPowerState)(LPCWSTR, DWORD, DWORD);
PFN_SetSystemPowerState gpfnSetSystemPowerState;

PRIVATE HANDLE gPwrButtonIntrEvent;
PRIVATE HANDLE gPwrButtonIntrThread;
PRIVATE BOOL   gOffFlag;

UINT32 g_PwrButtonIrq = IRQ_EINT0;
UINT32 g_PwrButtonSysIntr = SYSINTR_UNDEFINED;
UINT32 g_RebootButtonIrq = IRQ_EINT2;
UINT32 g_RebootButtonSysIntr = SYSINTR_UNDEFINED;
UINT32 g_BattFLTIrq = IRQ_BAT_FLT;
UINT32 g_BattFLTSysIntr = SYSINTR_UNDEFINED;


PRIVATE volatile SMT926A_IOPORT_REG * v_pIOPregs;
volatile SMT926A_PWM_REG * v_pPWMregs;
volatile SMT926A_INTR_REG * v_pINTRregs;

PRIVATE VOID
PBT_EnableInterrupt(VOID)
{
	//Pwr button
	v_pIOPregs->GPFCON  &= ~(0x3 << 0);		/* Set EINT0(GPF0) as EINT0							*/
	v_pIOPregs->GPFCON  |=  (0x2 << 0);

    v_pIOPregs->EXTINT0 &= ~(0x7 << 0);		/* Configure EINT0 as Falling Edge Mode				*/
    v_pIOPregs->EXTINT0 |=  (0x2 << 0);


	//SW_RESET button
	v_pIOPregs->GPFCON  &= ~(0x3 << 4);		/* Set EINT2(GPF2) as EINT2							*/
	v_pIOPregs->GPFCON  |=  (0x2 << 4);

    v_pIOPregs->EXTINT0 &= ~(0x7 << 8);		/* Configure EINT2 as Falling Edge Mode				*/
    v_pIOPregs->EXTINT0 |=  (0x2 << 8);

}

PRIVATE BOOL
PBT_IsPushed(VOID)
{
	UINT32 push;
	
	v_pIOPregs->GPFCON &= ~(3 << 0);
	push = v_pIOPregs->GPFDAT & (1 << 0);
	v_pIOPregs->GPFCON |= (2 << 0);
	
	
	return ( push ? FALSE : TRUE);
}

PRIVATE BOOL
PBT_InitializeAddresses(VOID)
{
	BOOL	RetValue = TRUE;

//	RETAILMSG(1, (TEXT(">>> PBT_initalization address..set..\r\n")));

		
	/* IO Register Allocation */
	v_pIOPregs = (volatile SMT926A_IOPORT_REG *)VirtualAlloc(0, sizeof(SMT926A_IOPORT_REG), MEM_RESERVE, PAGE_NOACCESS);
	if (v_pIOPregs == NULL) 
	{
		ERRORMSG(1,(TEXT("For IOPregs : VirtualAlloc failed!\r\n")));
		RetValue = FALSE;
	}
	else 
	{
		if (!VirtualCopy((PVOID)v_pIOPregs, (PVOID)(SMT926A_BASE_REG_PA_IOPORT >> 8), sizeof(SMT926A_IOPORT_REG), PAGE_PHYSICAL | PAGE_READWRITE | PAGE_NOCACHE)) 
		{
			ERRORMSG(1,(TEXT("For IOPregs: VirtualCopy failed!\r\n")));
			RetValue = FALSE;
		}
	}
	
	if (!RetValue) 
	{
//		RETAILMSG (1, (TEXT("::: PBT_InitializeAddresses - Fail!!\r\n") ));

		if (v_pIOPregs) 
		{
			VirtualFree((PVOID) v_pIOPregs, 0, MEM_RELEASE);
		}

		v_pIOPregs = NULL;
	}

	/* INTR Register Allocation */
	v_pINTRregs = (volatile SMT926A_INTR_REG *)VirtualAlloc(0, sizeof(SMT926A_INTR_REG), MEM_RESERVE, PAGE_NOACCESS);
	if (v_pINTRregs == NULL) 
	{
		ERRORMSG(1,(TEXT("For INTRregs : VirtualAlloc failed!\r\n")));
		RetValue = FALSE;
	}
	else 
	{
		if (!VirtualCopy((PVOID)v_pINTRregs, (PVOID)(SMT926A_BASE_REG_PA_INTR >> 8), sizeof(SMT926A_INTR_REG), PAGE_PHYSICAL | PAGE_READWRITE | PAGE_NOCACHE)) 
		{
			ERRORMSG(1,(TEXT("For INTRregs: VirtualCopy failed!\r\n")));
			RetValue = FALSE;
		}
	}
	
	if (!RetValue) 
	{
		RETAILMSG (1, (TEXT("::: PBT_InitializeAddresses - Fail!!\r\n") ));

		if (v_pINTRregs) 
		{
			VirtualFree((PVOID) v_pINTRregs, 0, MEM_RELEASE);
		}

		v_pINTRregs = NULL;
	}


	v_pPWMregs = (volatile SMT926A_PWM_REG *)VirtualAlloc(0, sizeof(SMT926A_PWM_REG), MEM_RESERVE, PAGE_NOACCESS);
	if (v_pPWMregs == NULL) 
	{
		ERRORMSG(1,(TEXT("For IOPregs : VirtualAlloc failed!\r\n")));
		RetValue = FALSE;
	}
	else 
	{
		if (!VirtualCopy((PVOID)v_pPWMregs, (PVOID)(SMT926A_BASE_REG_PA_PWM >> 8), sizeof(SMT926A_PWM_REG), PAGE_PHYSICAL | PAGE_READWRITE | PAGE_NOCACHE)) 
		{
			ERRORMSG(1,(TEXT("For IOPregs: VirtualCopy failed!\r\n")));
			RetValue = FALSE;
		}
	}
	
	if (!RetValue) 
	{

		if (v_pPWMregs) 
		{
			VirtualFree((PVOID) v_pPWMregs, 0, MEM_RELEASE);
		}

		v_pPWMregs = NULL;
	}

	return(RetValue);
}

DWORD
PBT_IntrThread(PVOID pArg)
{

	PBT_InitializeAddresses();

	PBT_EnableInterrupt();

	gPwrButtonIntrEvent = CreateEvent(NULL, FALSE, FALSE, NULL);

    // Request a SYSINTR value from the OAL.
    //
    if (!KernelIoControl(IOCTL_HAL_REQUEST_SYSINTR, &g_PwrButtonIrq, sizeof(UINT32), &g_PwrButtonSysIntr, sizeof(UINT32), NULL))
    {
        RETAILMSG(1, (TEXT("ERROR: PwrButton: Failed to request sysintr value for sw_reset button interrupt.\r\n")));
        return(0);
    }
    RETAILMSG(1,(TEXT("INFO: PwrButton: Mapped Irq 0x%x to SysIntr 0x%x.\r\n"), g_PwrButtonIrq, g_PwrButtonSysIntr));

    if (!KernelIoControl(IOCTL_HAL_REQUEST_SYSINTR, &g_RebootButtonIrq, sizeof(UINT32), &g_RebootButtonSysIntr, sizeof(UINT32), NULL))
    {
        RETAILMSG(1, (TEXT("ERROR: RebootButton: Failed to request sysintr value for sw_reset button interrupt.\r\n")));
        return(0);
    }
    RETAILMSG(1,(TEXT("INFO: RebootButton: Mapped Irq 0x%x to SysIntr 0x%x.\r\n"), g_RebootButtonIrq, g_RebootButtonSysIntr));

    if (!KernelIoControl(IOCTL_HAL_REQUEST_SYSINTR, &g_BattFLTIrq, sizeof(UINT32), &g_BattFLTSysIntr, sizeof(UINT32), NULL))
    {
        RETAILMSG(1, (TEXT("ERROR: BattFLT: Failed to request sysintr value for BattFLT interrupt.\r\n")));
        return(0);
    }
    RETAILMSG(1,(TEXT("INFO: BattFLT: Mapped Irq 0x%x to SysIntr 0x%x.\r\n"), g_BattFLTIrq, g_BattFLTSysIntr));


	if (!(InterruptInitialize(g_PwrButtonSysIntr, gPwrButtonIntrEvent, 0, 0))) 
	{
		RETAILMSG(1, (TEXT("ERROR: PwrButton: Interrupt initialize failed.\r\n")));
	}
	if (!(InterruptInitialize(g_RebootButtonSysIntr, gPwrButtonIntrEvent, 0, 0))) 
	{
		RETAILMSG(1, (TEXT("ERROR: RebootButton: Interrupt initialize failed.\r\n")));
	}
	if (!(InterruptInitialize(g_BattFLTSysIntr, gPwrButtonIntrEvent, 0, 0))) 
	{
		RETAILMSG(1, (TEXT("ERROR: g_BattFLTSysIntr: Interrupt initialize failed.\r\n")));
	}
	while (1) 
	{
		WaitForSingleObject(gPwrButtonIntrEvent, INFINITE);

		if (v_pINTRregs->INTMSK & (1<<IRQ_EINT2))
		{
			 
			if (!KernelIoControl(IOCTL_HAL_REBOOT, NULL, 0, NULL, 0, NULL))
				RETAILMSG(1, (TEXT("::: reset error \r\n")));

			InterruptDone(g_RebootButtonSysIntr);
		}
		else if (v_pINTRregs->INTMSK & (1<<IRQ_EINT0))
		{

    		if (gOffFlag == FALSE) 
			{
				if (PBT_IsPushed())			/* To Filter Noise				*/
				{
					Sleep(500);

					if (PBT_IsPushed())
					{  
						RETAILMSG(1, (TEXT("::: Back Light On/Off \r\n")));
					} 
					else 
					{
						RETAILMSG(1, (TEXT("::: power off \r\n")));

						// Soft reset and standard suspend-resume both start with suspend for now.
						#if (WINCEOSVER >= 400)
							// call whichever shutdown API is available
							if(gpfnSetSystemPowerState != NULL)
							{
								gpfnSetSystemPowerState(NULL, POWER_STATE_SUSPEND, POWER_FORCE);
							}
							else
							{
								GwesPowerOffSystem();
							}
						#else
							GwesPowerOffSystem();
						#endif

						// Give control back to system if it wants it for anything.  Not in
						//  power handling mode yet.  All suspend and resume operations
						//  will be performed in the PowerOffSystem() function.
						Sleep(0);
					}
				}

				InterruptDone(g_PwrButtonSysIntr);
			}

    	}
    	else if(v_pINTRregs->INTMSK & (1<<IRQ_BAT_FLT))
    	{
			// Soft reset and standard suspend-resume both start with suspend for now.
			#if (WINCEOSVER >= 400)
				// call whichever shutdown API is available
				if(gpfnSetSystemPowerState != NULL)
				{
					gpfnSetSystemPowerState(NULL, POWER_STATE_SUSPEND, POWER_FORCE);
				}
				else
				{
					GwesPowerOffSystem();
				}
			#else
				GwesPowerOffSystem();
			#endif

			// Give control back to system if it wants it for anything.  Not in
			//  power handling mode yet.  All suspend and resume operations
			//  will be performed in the PowerOffSystem() function.
			Sleep(0);

			InterruptDone(g_BattFLTSysIntr);
    	
    	}
    	else 
    	{
    		//should not happen	
    	}
    }        	
}


PUBLIC DWORD
DSK_Init(DWORD dwContext)
{
	PDISK	pDisk;
	DWORD   IDThread;
        HMODULE hmCore;


	pDisk = (PDISK)dwContext;


        // contain the appropriate APIs.
        gpfnSetSystemPowerState = NULL;
        hmCore = (HMODULE) LoadLibrary(_T("coredll.dll"));
        if(hmCore != NULL) {
            gpfnSetSystemPowerState = (PFN_SetSystemPowerState) GetProcAddress(hmCore, _T("SetSystemPowerState"));
            if(gpfnSetSystemPowerState == NULL) {
                FreeLibrary(hmCore);
            }
	}

	do 
	{
		gPwrButtonIntrThread = CreateThread(0, 0, (LPTHREAD_START_ROUTINE) PBT_IntrThread, 0, 0, &IDThread);

//		RETAILMSG(1, (TEXT("::: PBT_IntrThread ID = %x\r\n"), IDThread));

		if (gPwrButtonIntrThread == 0) 
		{
//			RETAILMSG(1, (TEXT("::: CreateThread() Fail\r\n")));
			break;
		}
	} while (0);

//    RETAILMSG(1, (TEXT("::: PBT_Init Out\r\n")));

	pDisk->d_DiskCardState = 1;

	return (DWORD)pDisk;
}

PUBLIC BOOL WINAPI
DllEntry(HANDLE hInstDll, DWORD dwReason, LPVOID lpvReserved)
{
    switch ( dwReason ) 
	{
    case DLL_PROCESS_ATTACH:
//        RETAILMSG(1, (TEXT("PwrButton : DLL_PROCESS_ATTACH\r\n")));
		DisableThreadLibraryCalls((HMODULE) hInstDll);
        break;

    }
    return (TRUE);
}

BOOL
DSK_Close(
    DWORD Handle
    )
{
    return TRUE;
}   // DSK_Close


//
// Device deinit - devices are expected to close down.
// The device manager does not check the return code.
//
BOOL
DSK_Deinit(
    DWORD dwContext     // future: pointer to the per disk structure
    )
{
    return TRUE;
}   // DSK_Deinit


//
// Returns handle value for the open instance.
//
DWORD
DSK_Open(
    DWORD dwData,
    DWORD dwAccess,
    DWORD dwShareMode
    )
{
    return 0;
}   // DSK_Open

//
// I/O Control function - responds to info, read and write control codes.
// The read and write take a scatter/gather list in pInBuf
//
BOOL
DSK_IOControl(
    DWORD Handle,
    DWORD dwIoControlCode,
    PBYTE pInBuf,
    DWORD nInBufSize,
    PBYTE pOutBuf,
    DWORD nOutBufSize,
    PDWORD pBytesReturned
    )
{
    return FALSE;
}   // DSK_IOControl


DWORD DSK_Read(DWORD Handle, LPVOID pBuffer, DWORD dwNumBytes)
{
	return 0;
}
DWORD DSK_Write(DWORD Handle, LPCVOID pBuffer, DWORD dwNumBytes)
{
	return 0;
}
DWORD DSK_Seek(DWORD Handle, long lDistance, DWORD dwMoveMethod)
{
	return 0;
}

void DSK_PowerUp(void)
{
	PBT_EnableInterrupt();
	return;
}

void
DSK_PowerDown(void)
{
	return;
}
