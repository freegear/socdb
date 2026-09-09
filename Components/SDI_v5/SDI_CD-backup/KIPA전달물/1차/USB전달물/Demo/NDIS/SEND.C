/*++

Copyright (c) 1999  Microsoft Corporation

Module Name:

   send.c

Abstract:

    USB device driver - Transmit io code

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


#include <ndis.h>
#include <ntdef.h>
#include <windef.h>

#include "stdarg.h"
#include "stdio.h"
#include "debug.h"

#include "usbdi.h"
#include "usbdlib.h"

#include "common.h"
#include "usb.h"

void    DUMP_MSG
(
char                *packet,
unsigned int        len
)
{
char            *pkt;
unsigned int    idx;

    pkt = packet;

    DbgPrint("==================>> %d bytes MAC frame\n",len);
    for(idx=0; idx<len; idx++)
    {
        DbgPrint("(0x%.2x) ",*pkt++);
        if ( (idx!=0) && ((idx+1)%8==0) )
        DbgPrint("\n");
    }
    DbgPrint("\n");

    return;

}   // of DUMP_MSG
/*****************************************************************************
*
*  Function:   SendPacket
*
*  Synopsis:   Send a packet to the USB driver and add the sent irp and io context to
*              To the pending send queue; this que is really just needed for possible later error cancellation
*
*
*  Arguments:  MiniportAdapterContext - pointer to current ir device object
*              pPacketToSend          - pointer to packet to send
*              Flags                  - any flags set by protocol
			   Type					  - CONTEXT_TYPE enum for whether it's a real NDIS_PACKET
									     or dummy packet for a SetSpeed/Check Media busy call
*
*  Returns:    NDIS_STATUS_PENDING - This is generally what we should
*                                    return. We will call NdisMSendComplete
*                                    when the USB driver completes the
*                                    send.
*              STATUS_UNSUCCESSFUL - The packet was invalid.
*
*  Unsupported returns:
*              NDIS_STATUS_SUCCESS  - We should never return this since
*                                     results will always be pending from
*                                     the USB driver.
*              NDIS_STATUS_RESOURCES-This indicates to the protocol that the
*                                    device currently has no resources to complete
*                                    the request. The protocol will resend
*                                    the request when it receives either
*                                    NdisMSendResourcesAvailable or
*                                    NdisMSendComplete from the device.
*
*
*
*****************************************************************************/

NTSTATUS
SendPacket(
		   IN PUSB_DEVICE   Device,
           IN PVOID		   pPacketToSend,
           IN UINT         Flags,
		   IN CONTEXT_TYPE Type
           )
{
    PIRP                pIrp;
    UINT                BytesToWrite =0;
    NTSTATUS			status;
    BOOLEAN             fConvertedPacket;
    ULONG siz;
    PURB urb = NULL;
    PDEVICE_OBJECT urbTargetDev;
    PIO_STACK_LOCATION nextStack;
	PMDL	mdl = NULL;
	PUSB_CONTEXT pCur, thisContext;

    DEBUGMSG(DBG_FUNC, ("+++SendPacket\n"));
	

//    ASSERT( KeGetCurrentIrql() == PASSIVE_LEVEL );

	thisContext = (PUSB_CONTEXT) GetFreeContext( Device );

	if ( NULL == thisContext )
    {
        status = STATUS_UNSUCCESSFUL;
        goto done;
    }
	
	thisContext->Packet = pPacketToSend;
	thisContext->Type = Type;

	urb = thisContext->Urb;

	NdisZeroMemory( urb, Device->UrbLen );


	if (  CONTEXT_NDIS_PACKET == Type ){

		ASSERT( NULL != pPacketToSend );

		//
		// Get the packet's entire length
		//

		NdisQueryPacket( (PNDIS_PACKET)pPacketToSend, NULL, NULL, NULL, &BytesToWrite);
		BytesToWrite += USB_INBOUND_OUTBOUND_HEADER_SIZE;

		thisContext->BufLen = BytesToWrite;

		NdisZeroMemory(
					thisContext->Buffer,
					thisContext->BufLen
					);


		//
		// Convert the packet to an usb frame and copy into our buffer
		// and send the irp.
		//

		fConvertedPacket = NdisToUsbPacket(
									Device,
									pPacketToSend,
									(PUCHAR)thisContext->Buffer,
									MAX_TOTAL_SIZE_WITH_ALL_HEADERS
									);

		if (fConvertedPacket == FALSE)
		{
			status = STATUS_UNSUCCESSFUL;
			goto done;
		}


	} else if (  CONTEXT_SETSPEED == Type ){

		// set up the single byte required to send to device to change speeds

		BytesToWrite = 1;

		Device->OutBoundHeader = Device->linkSpeedInfo->headerLinkSpeed;

		thisContext->Buffer[0] = Device->OutBoundHeader;

	} else if (  CONTEXT_TERMINATOR == Type ) {

		// We need to Send a zero-lengh USB ( not NDIS) packet as a terminator
		// when we have  previously sent a packet with a length that is an exact multiple of
		// Device->UsbInterface->Pipes[1]->MaximumPacketSize  (64)
		//
		BytesToWrite = 0;

	}

	thisContext->BufLen = BytesToWrite;

	//
    // Now that we have created the urb, we will send a
    // request to the USB device object.
    //

    urbTargetDev = Device->pUsbDevObj;


	// make an irp sending to usbhub
	pIrp = IoAllocateIrp( (CCHAR)(Device->pUsbDevObj->StackSize +1), FALSE );


    if ( NULL == pIrp )
    {
        status = STATUS_UNSUCCESSFUL;
        goto done;
    }

    pIrp->IoStatus.Status = STATUS_NOT_SUPPORTED; 
    pIrp->IoStatus.Information = 0;

	thisContext->Irp = pIrp;


	// Build our URB for USBD


    urb->UrbBulkOrInterruptTransfer.Hdr.Length =
		(USHORT) sizeof( struct _URB_BULK_OR_INTERRUPT_TRANSFER );
    urb->UrbBulkOrInterruptTransfer.Hdr.Function =
                URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER;
    urb->UrbBulkOrInterruptTransfer.PipeHandle =
               Device->BulkOutPipeHandle;
    urb->UrbBulkOrInterruptTransfer.TransferFlags =
        USBD_TRANSFER_DIRECTION_OUT ;
    // short packet is not treated as an error.
    urb->UrbBulkOrInterruptTransfer.TransferFlags |=
        USBD_SHORT_TRANSFER_OK;
    urb->UrbBulkOrInterruptTransfer.UrbLink = NULL;
    urb->UrbBulkOrInterruptTransfer.TransferBufferMDL = NULL;
    urb->UrbBulkOrInterruptTransfer.TransferBuffer = thisContext->Buffer;
    urb->UrbBulkOrInterruptTransfer.TransferBufferLength = (int) BytesToWrite;


	if(Device->DisplayPacket) DUMP_MSG(thisContext->Buffer,BytesToWrite);
	DEBUGMSG(DBG_OUT,("send:len(0x%x)\n",BytesToWrite));
    //
    // Call the class driver to perform the operation.


    nextStack = IoGetNextIrpStackLocation(pIrp);

    ASSERT(nextStack != NULL);

    //
    // pass the URB to the USB driver stack
    //


	nextStack->MajorFunction = IRP_MJ_INTERNAL_DEVICE_CONTROL;
	nextStack->Parameters.Others.Argument1 = urb;
	nextStack->Parameters.DeviceIoControl.IoControlCode =
		IOCTL_INTERNAL_USB_SUBMIT_URB;
	

    IoSetCompletionRoutine(
                pIrp,                      // irp to use
                UsbIoCompleteWrite,      // routine to call when irp is done
                DEV_TO_CONTEXT(thisContext),  // context to pass routine
                TRUE,                      // call on success
                TRUE,                      // call on error
                TRUE);                     // call on cancel

	//
    // Call IoCallDriver to send the irp to the usb port.
    //

	UsbIncIoCount( Device );

    status =  IoCallDriver( urbTargetDev, pIrp );
    //
    // The USB driver should always return STATUS_PENDING when
    // it receives a write irp
    //

    ASSERT(status == STATUS_PENDING);

    // We need to Send a zero-lengh USB ( not NDIS) packet as a terminator
	// when we have  previously sent a packet with a length that is an exact multiple of
    // ((PUSB_INFO) Device->pUsbInfo)->UsbInterface->Pipes[1]->MaximumPacketSize  (64)
	// BUGBUG? we'll indicate send complete before sending terminator
	//

	if ( BytesToWrite && ( BytesToWrite % 64 )==0)
	{
		DEBUGMSG(DBG_OUT,("!!!Zero length=%x\n",BytesToWrite));
		SendPacket( Device, NULL, 0, CONTEXT_TERMINATOR );
	}


done:

    return status;

}


/*****************************************************************************
*
*  Function:   UsbIoCompleteWrite
*
*  Synopsis:
*
*  Arguments:  pUsbDevObj - pointer to the USB device object which
*                              completed the irp
*              pIrp          - the irp which was completed by the
*                              device object
*              Context       - the context given to IoSetCompletionRoutine
*                              before calling IoCallDriver on the irp
*                              The Context is a pointer to the ir device object.
*
*  Returns:    STATUS_MORE_PROCESSING_REQUIRED - allows the completion routine
*              (IofCompleteRequest) to stop working on the irp.
*
*  Algorithm:
*     1a) Indicate to the protocol the status of the write.
*     1b) Return ownership of the packet to the protocol.
*
*     2)  If any more packets are queue for sending, send another packet
*         to USBD.
*         If the attempt to send the packet to the driver fails,
*         return ownership of the packet to the protocol and
*         try another packet (until one succeeds).
*
*
*****************************************************************************/

NTSTATUS
UsbIoCompleteWrite(
            IN PDEVICE_OBJECT pUsbDevObj,
            IN PIRP           pIrp,
            IN PVOID          Context
            )
{
    PUSB_DEVICE          device;
    PVOID               pThisContextPacket;
    NTSTATUS            status;
	BOOLEAN             found = FALSE;
	PUSB_CONTEXT		thisContext = ( PUSB_CONTEXT ) Context;
	PUSB_CONTEXT		pPrev, pCur, pNext;
	int					len;
	CONTEXT_TYPE		ContextType;
	PIRP				ContextIrp;
	PURB                ContextUrb;
	ULONG				BufLen;

    DEBUGMSG(DBG_FUNC, ("---UsbIoCompleteWrite\n"));
	//
    // The context given to IoSetCompletionRoutine is an USB_CONTEXT struct
    //
	ASSERT( NULL != thisContext );				// we better have a non NULL buffer

    device = thisContext->DeviceObject;


	ASSERT( NULL != device );	

	ContextType = thisContext->Type;
	ContextIrp = thisContext->Irp;
	ContextUrb = thisContext->Urb;
	BufLen = thisContext->BufLen;

	pThisContextPacket =  thisContext->Packet; //save ptr to packet to access after context freed

	//
	// Perform various IRP, URB, and buffer 'sanity checks'
	//

    ASSERT( ContextIrp ==  pIrp );				// check we're not a bogus IRP

    status = pIrp->IoStatus.Status;

	//we should have failed, succeeded, or cancelled, but NOT be pending

	ASSERT( STATUS_PENDING != status );
    //
    // IoCallDriver has been called on this Irp;
    // Set the length based on the TransferBufferLength
    // value in the URB
    //

    pIrp->IoStatus.Information =
        ContextUrb->UrbBulkOrInterruptTransfer.TransferBufferLength;

	len = (int)pIrp->IoStatus.Information; // save for below need-termination test

    if (status == STATUS_SUCCESS)
    {
	    InterlockedIncrement( (PLONG) &device->packetsSent );
    }
    else
    {
        InterlockedIncrement( (PLONG) &device->NumDataErrors);
        InterlockedIncrement( (PLONG) &device->packetsSentDropped);
    }



    //
    // Free the IRP  because we alloced it ourselves,
    //

    IoFreeIrp( pIrp );


    //
    // See if this was the last packet before we need to change
    // speed.
    //
    if ( pThisContextPacket == device->LastPacketAtOldSpeed){

        InterlockedExchangePointer( &device->LastPacketAtOldSpeed, NULL);
        InterlockedExchange( (PLONG) &device->fSetSpeedAfterCurrentSendPacket, TRUE);
    }

	InterlockedExchange( (PLONG) &thisContext->fInUse, FALSE );

	UsbDecIoCount( device ); // we will track count of pending irps

    if ( device->fSetSpeedAfterCurrentSendPacket) {

         InterlockedExchange( (PLONG) &device->fSetSpeedAfterCurrentSendPacket,  FALSE);

		 ASSERT( NULL == device->LastPacketAtOldSpeed );

		// Signal SetspeedCallback it's OK to set speed now
		KeSetEvent(&device->EventSetSpeedNow, 0, FALSE );
    }


	if ( CONTEXT_SETSPEED == ContextType ) {

		if ( STATUS_SUCCESS == status ) {
			InterlockedExchange( (PLONG) &device->currentSpeed,
				device->linkSpeedInfo->bitsPerSec);
		}
        NdisMSetInformationComplete( (NDIS_HANDLE) device->hNdisAdapter, (NDIS_STATUS) status );

        device->LastSetTime.QuadPart = 0;

    	device->fSetpending = FALSE;

	} else	if ( CONTEXT_NDIS_PACKET == ContextType ) {
		//
		//
		// Indicate to the protocol the status of the sent packet and return
		// ownership of the packet.
		//

		NdisMSendComplete(
					device->hNdisAdapter,
					pThisContextPacket,
					status );

	}

	if (( STATUS_SUCCESS != status )  && ( STATUS_CANCELLED != status )) {

		InterlockedExchange( (PLONG) &device->fPendingWriteClearStall, TRUE );

		ScheduleWorkItem( device,
		  ResetPipeCallback, device->BulkOutPipeHandle, 0);
	}

    return STATUS_MORE_PROCESSING_REQUIRED;
}


BOOLEAN
NdisToUsbPacket(
            PUSB_DEVICE   Device,
            PVOID        pPack,
            UCHAR        *usbPacketBuf,
            UINT         usbPacketBufLen
            )
{
    UINT i;
    UINT ndisPacketBytes;
    UINT I_fieldBytes;
    UINT totalBytes;
    UINT ndisPacketLen;
    UINT bufLen;

    UCHAR *bufData;
    UCHAR nextChar;

    PNDIS_BUFFER ndisBuf;
	PNDIS_PACKET    pPacket = (PNDIS_PACKET) pPack;


    DEBUGMSG(DBG_FUNC, ("+NdisToUsbPacket input packet:\n"));

    //
    // Initialize locals.
    //

    Device->OutBoundHeader  = 0;  // this translates to 'no change ' of either link speed or BOFS
    ndisPacketBytes = 0;
    I_fieldBytes    = 0;
    totalBytes      = 0;

    //
    // Get the packet's entire length and its first NDIS buffer.
    //

    NdisQueryPacket(pPacket, NULL, NULL, &ndisBuf, &ndisPacketLen);

    // A zero-legth packet is OK; we may just get the one-byte inbound header
    //  to report media busy!
    if ( ndisPacketLen > 0 )
    {

        //
        // But if the packet is not 0-len, it must have at least Addr and Control fields
        //  Make sure that the packet is big enough to be legal.
        // It consists of an A, C, and variable-length I field.
        //

//        if (ndisPacketLen < USB_A_C_TOTAL_SIZE )
        if (0 )
        {
            DEBUGMSG(DBG_ERR, ("    Packet too short in NdisToUsbPacket (%d bytes)\n",
                    ndisPacketLen));

            return FALSE;
        }
        else
        {
            I_fieldBytes = ndisPacketLen - USB_A_C_TOTAL_SIZE;
        }
    }

    //
    // Make sure that we won't overwrite our contiguous buffer.
    // Make sure that the passed-in buffer can accomodate this packet's data
    //

    if (ndisPacketLen > Device->dongleCaps.dataSize + USB_USB_TOTAL_NON_DATA_SIZE ) 
    {
        //
        // The packet is too large
        // Tell the caller to retry with a packet size large
        // enough to get past this stage next time.
        //

        DEBUGMSG(DBG_ERR, ("Packet too large in NdisToUsbPacket (%d=%xh bytes), \n",ndisPacketLen, ndisPacketLen));
        DEBUGMSG(DBG_ERR, ("Device->dongleCaps.dataSize=%d, usbPacketBufLen=%d.\n",Device->dongleCaps.dataSize, usbPacketBufLen));

        return FALSE;
    }

    if (!ndisBuf)
    {
        DEBUGMSG(DBG_ERR, ("No NDIS_BUFFER in NdisToUsbPacket\n"));
        return FALSE;
    }
	
    NdisQueryBuffer(ndisBuf, (PVOID *)&bufData, &bufLen);


 
	//
	// Now begin building the USB frame.
	//
	// This is the final format:
	//
	// 	Outbound Header 	(1)
	//     

	

//    usbPacketBuf[0] = Device->OutBoundHeader;

    totalBytes =  USB_INBOUND_OUTBOUND_HEADER_SIZE;  // USB_INBOUND_OUTBOUND_HEADER_SIZE is just one byte


    for (i=0; i<ndisPacketLen; i++)
    {
        ASSERT(bufData);

        nextChar = *bufData++;


        usbPacketBuf[totalBytes++] = nextChar; 


        if (--bufLen==0)
        {
            NdisGetNextBuffer(ndisBuf, &ndisBuf);
            if (ndisBuf)
            {
                NdisQueryBuffer(ndisBuf, (PVOID *)&bufData, &bufLen);
            }
            else
            {
                bufData = NULL;
            }
        }

    }

    if ((bufData!=NULL) && ndisPacketLen )
    {
		/*
		 *  Packet was corrupt -- it misreported its size.
		 */
		DEBUGMSG(DBG_ERR, ("Packet corrupt in NdisToUsbPacket (buffer lengths don't add up to packet length)."));
		return FALSE;
    }


    DEBUGMSG(DBG_BUF, ("SENDING:")); 
    USB_DUMP( DBG_BUF, (usbPacketBuf,   totalBytes ) );


    return TRUE;
}




