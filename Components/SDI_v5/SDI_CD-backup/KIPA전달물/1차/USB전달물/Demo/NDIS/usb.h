/*++

Copyright (c) 1999  Microsoft Corporation

Module Name:

   usb.h

Abstract:
		Header for function prototypes and struct defs pertaining to USB.
		This header can only be used in modules that DO include Wdm.h, Usbdi.h, and usbdlib.h
		but do NOT include ndis.h and ntddndis.h

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

#ifndef USB_H
#define USB_H



// used to track driver-generated write irps 
typedef struct _USB_CONTEXT {

    PUSB_DEVICE DeviceObject;
	PVOID			Packet;
    PURB			Urb;
    PIRP			Irp;
	PUCHAR			Buffer;
	UINT			BufLen;
	CONTEXT_TYPE	Type;
	ULONG			fInUse; // Declared as ULONG so can use with InterlockedExchange()

} USB_CONTEXT, *PUSB_CONTEXT, **PPUSB_CONTEXT;


typedef struct _USB_INFO
{

    // USB configuration handle and ptr for the configuration the
    // device is currently in
    USBD_CONFIGURATION_HANDLE UsbConfigurationHandle;
	PUSB_CONFIGURATION_DESCRIPTOR UsbConfigurationDescriptor;

	PIRP			IrpSubmitUrb;
	PIRP			IrpSubmitIoCtl;


    // ptr to the USB device descriptor
    // for this device
    PUSB_DEVICE_DESCRIPTOR UsbDeviceDescriptor;

    // we support one interface
    // this is a copy of the info structure
    // returned from select_configuration or
    // select_interface
    PUSBD_INTERFACE_INFORMATION UsbInterface[3];

	// urb for control diescriptor request
	struct _URB_CONTROL_DESCRIPTOR_REQUEST DescriptorUrb;

	// urb to use for control/status  requests to USBD
	struct _URB_CONTROL_VENDOR_OR_CLASS_REQUEST ClassUrb;


} USB_INFO, *PUSB_INFO;
//
// Externs for required miniport export functions
//



NTSTATUS
UsbIoCompleteControl(
            IN PDEVICE_OBJECT pUsbDevObj,
            IN PIRP           pIrp,
            IN PVOID          Context
            );


NTSTATUS UsbIoCompleteRead(
            IN PDEVICE_OBJECT pUsbDevObj,
            IN PIRP           pIrp,
            IN PVOID          Context
            );


NTSTATUS UsbIoCompleteWrite(
            IN PDEVICE_OBJECT pUsbDevObj,
            IN PIRP           pIrp,
            IN PVOID          Context
            );


NTSTATUS
CallUSBD(
    IN PUSB_DEVICE DeviceExt,
    IN PURB Urb
    );



BOOLEAN
CancelPendingControlIo(
    IN PUSB_DEVICE DeviceExt,
	IN PIRP  IrpToCancel,
	IN PKEVENT EventToClear
    );



NTSTATUS
SelectInterface(
    IN PUSB_DEVICE DeviceExt,
    IN PUSB_CONFIGURATION_DESCRIPTOR ConfigurationDescriptor
    );


NTSTATUS MyKeWaitForSingleObject( 
    IN  PUSB_DEVICE     Device,
    IN  PVOID          EventWaitingFor,
    IN  OUT PIRP       IrpWaitingFor,
    LONGLONG           timeout100ns
);



NTSTATUS
UsbIoCompleteRead(
            IN PDEVICE_OBJECT pUsbDevObj,
            IN PIRP           pIrp,
            IN PVOID          Context
            );



#endif // USB_H

