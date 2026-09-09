/*
 *
 *    Copyright (c) Standard MicroSystems Corporation.  All Rights Reserved.
 *
 *				    LAN91C111 Driver for Windows CE .NET
 *
 *							 Revision History
 *_______________________________________________________________________________
 *     Author		  Date		Version		Description
 *_______________________________________________________________________________
 * Pramod Bhardwaj  6/18/2002	  0.1		Beta Release 
 * Pramod Bhardwaj	7/15/2002	  1.0       Release 
 *_______________________________________________________________________________
 *
 *Description:
 *      Contains the functions to be exported.
 *
 *
 */
#define NDIS_MINIPORT_DRIVER
#define NDIS50_MINIPORT


#include <Ndis.h>
#include "LAN91C111_Adapter.h"
#include "LAN91C111_Proto.h"

DBGPARAM dpCurSettings = {
  TEXT("LAN91C111"), {
    TEXT("Init"),TEXT("Critical"),TEXT("Interrupt"),TEXT("Message"),
    TEXT(""),TEXT(""),TEXT(""),TEXT(""),
    TEXT(""),TEXT(""),TEXT(""),TEXT(""),
    TEXT(""),TEXT(""),TEXT("Warnings"), TEXT("Errors")},
    0x00000000
}; 

const NDIS_PHYSICAL_ADDRESS HighestAcceptedMax = NDIS_PHYSICAL_ADDRESS_CONST(-1,-1);



NTSTATUS    DriverEntry(IN PDRIVER_OBJECT  DriverObject, IN PUNICODE_STRING RegistryPath)
{
	NDIS_MINIPORT_CHARACTERISTICS 	Characteristics;
	NDIS_HANDLE						LAN91C111_WrapperHandle;
	NDIS_STATUS                     Status=NDIS_STATUS_SUCCESS;

	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 => DriverEntry\r\n")));

    //Initialize the Wrapper.
	NdisMInitializeWrapper( &LAN91C111_WrapperHandle,
							DriverObject,
							RegistryPath,
							NULL
						);   

    //Set up our Characteristics, but clear it first
    NdisZeroMemory((PVOID) &Characteristics, sizeof(Characteristics));

	Characteristics.MajorNdisVersion        = DRIVER_NDIS_MAJOR_VERSION;
    Characteristics.MinorNdisVersion        = DRIVER_NDIS_MINOR_VERSION;
    Characteristics.CheckForHangHandler     = NULL;									//Optional
    Characteristics.DisableInterruptHandler = LAN91C111_MiniportDisableInterrupt; 
    Characteristics.EnableInterruptHandler  = LAN91C111_MiniportEnableInterrupt; 
    Characteristics.HaltHandler             = LAN91C111_MiniportHalt;				//Required
    Characteristics.HandleInterruptHandler  = LAN91C111_MiniPortHandleInterrupt;	//Required
    Characteristics.InitializeHandler       = LAN91C111_MiniportInitialize;			//Required
    Characteristics.ISRHandler              = LAN91C111_MiniportISR;				//Required
    Characteristics.QueryInformationHandler = LAN91C111_MiniportQueryInformation;	//Required
    Characteristics.ReconfigureHandler      = NULL;
    Characteristics.ResetHandler            = LAN91C111_MiniportReset;				//Required
    Characteristics.SendHandler             = LAN91C111_MiniportSend;				//Required
    Characteristics.SetInformationHandler   = LAN91C111_MiniportSetInformation;
    Characteristics.TransferDataHandler     = LAN91C111_MiniportTransferData;
	

    //Register as an NDIS MiniPort Driver.
    Status = NdisMRegisterMiniport(LAN91C111_WrapperHandle,
                                   (PNDIS_MINIPORT_CHARACTERISTICS) &Characteristics,
                                   sizeof(Characteristics));

    if(Status != NDIS_STATUS_SUCCESS)
    {
		NdisTerminateWrapper (LAN91C111_WrapperHandle, NULL);
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 : NdisMRegisterMiniport Failed !!\r\n")));
    }
	
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <= DriverEntry\r\n")));
    return(Status);
}


BOOL __stdcall DllEntry	(
							HANDLE hDLL,
							DWORD dwReason,
							LPVOID lpReserved
						)
{
    switch (dwReason) 
	{
        case DLL_PROCESS_ATTACH:
				DEBUGREGISTER(hDLL);
				DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 : DLL Process Attach\r\n")));
				break;
		case DLL_PROCESS_DETACH:
				DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 :  DLL Process Detach\r\n")));
				break;
    }
    return TRUE;
}
