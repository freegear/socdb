/*++

Copyright (c) 1999  Microsoft Corporation

Module Name:

   USBNDIS.h

Abstract:
		Header for function prototypes pertainng to and using Ndis.
		These functions must be in modules that include Ndis.h
		but do NOT include Wdm.h

Environment:

    kernel mode only

Notes:

  THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
  KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
  PURPOSE.

  Copyright (c) 1999 Microsoft Corporation.  All Rights Reserved.


Revision History:


--*/

#ifndef NDIS_H
#define NDIS_H


//
// NDIS version compatibility.
//

#define NDIS_MAJOR_VERSION 5  
#define NDIS_MINOR_VERSION 0

//
// Externs for required NDIS-dependent miniport export functions
//



VOID MiniportHalt(
            IN NDIS_HANDLE MiniportAdapterContext
            );

NDIS_STATUS MiniportInitialize(
            OUT PNDIS_STATUS    OpenErrorStatus,
            OUT PUINT           SelectedMediumIndex,
            IN  PNDIS_MEDIUM    MediumArray,
            IN  UINT            MediumArraySize,
            IN  NDIS_HANDLE     MiniportAdapterHandle,
            IN  NDIS_HANDLE     WrapperConfigurationContext
            );

NDIS_STATUS MiniportQueryInformation(
            IN  NDIS_HANDLE MiniportAdapterContext,
            IN  NDIS_OID    Oid,
            IN  PVOID       InformationBuffer,
            IN  ULONG       InformationBufferLength,
            OUT PULONG      BytesWritten,
            OUT PULONG      BytesNeeded
            );

NDIS_STATUS MiniportSend(
            IN NDIS_HANDLE  MiniportAdapterContext,
            IN PNDIS_PACKET Packet,
            IN UINT         Flags
            );


VOID
UsbCommonShutdown(
            IN PUSB_DEVICE Device
            );

NDIS_STATUS MiniportReset(
            OUT PBOOLEAN    AddressingReset,
            IN  NDIS_HANDLE MiniportAdapterContext
            );

VOID
ResetUsbDevice(
    IN PUSB_WORK_ITEM  pWorkItem
);


NDIS_STATUS MiniportSetInformation(
            IN  NDIS_HANDLE MiniportAdapterContext,
            IN  NDIS_OID    Oid,
            IN  PVOID       InformationBuffer,
            IN  ULONG       InformationBufferLength,
            OUT PULONG      BytesRead,
            OUT PULONG      BytesNeeded
            );

VOID MiniportReturnPacket(
            IN NDIS_HANDLE  MiniportAdapterContext,
            IN PNDIS_PACKET Packet
            );

NTSTATUS
StartDevice(
    IN  PUSB_DEVICE DeviceExt
    );

NTSTATUS
StopDevice(
    IN  PUSB_DEVICE DeviceExt
    );


NTSTATUS
AddDevice(
    IN OUT PUSB_DEVICE *DeviceExt
    );


NTSTATUS
CreateDeviceExt(
    IN OUT PUSB_DEVICE *DeviceExt
    );

NTSTATUS
ConfigureDevice(
    IN  PUSB_DEVICE DeviceExt
    );



BOOLEAN
CancelPendingIo(
    IN PUSB_DEVICE DeviceExt
    );




NDIS_STATUS InitializeDevice(
            IN OUT PUSB_DEVICE dev
            );

NDIS_STATUS DeinitializeDevice(
            IN OUT PUSB_DEVICE dev
            );


NDIS_STATUS UsbOpen(
            IN PUSB_DEVICE Device
            );

NDIS_STATUS UsbClose(
            IN PUSB_DEVICE Device
            );





VOID FreeDevice(
            IN PUSB_DEVICE dev
            );


NTSTATUS
GetClassDescriptor(
    IN PUSB_DEVICE DeviceExt,
    IN OUT PUSB_CLASS_SPECIFIC_DESCRIPTOR ClassDesc
    );



//PNDIS_USB_PACKET_INFO  GetPacketInfo(PNDIS_PACKET packet); Eliyas




#endif USBNDIS_H
