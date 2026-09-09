/*++

Copyright (c) 1999  Microsoft Corporation

Module Name:

   rwir.c

Abstract:

    USB device driver .
    This module contains code pertaining to IRPS and URBS and USB, but no
	ndis-specific code

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

#include "usbdi.h"
#include "usbdlib.h"

#include "debug.h"

#include "common.h"
#include "usb.h"

/*****************************************************************************
*
*  Function:   InitializeReceive
*
*  Synopsis:   Initialize the receive functionality.
*
*  Arguments:  Deviceice - pointer to current usb device object
*
*  Returns:    NDIS_STATUS_SUCCESS   - if irp is successfully sent to USB
*                                      device object
*              NDIS_STATUS_RESOURCES - if mem can't be alloc'd
*              NDIS_STATUS_FAILURE   - otherwise
*
*  Algorithm:
*              1) Set the receive timeout to READ_INTERVAL_TIMEOUT_MSEC.
*              2) Initialize our rcvInfo and associate info for our
*                 receive state machine.
*              3) Build an IRP_MJ_READ irp to send to the USB device
*                 object, and set the completion(or timeout) routine
*                 to UsbIoCompleteRead.
*  Notes:
*
*  This routine must be called in IRQL PASSIVE_LEVEL.
*
*****************************************************************************/

NTSTATUS
InitializeReceive(
            IN PUSB_DEVICE Device
            )
{
    NTSTATUS        status = STATUS_SUCCESS;

    DEBUGMSG(DBG_FUNC, ("+InitializeReceive\n"));

    //
    // Create a thread to run at IRQL PASSIVE_LEVEL.
    //
    status =  PsCreateSystemThread(
                            &Device->hPassiveThread,
                            (ACCESS_MASK) 0L,
                            NULL,
                            NULL,
                            NULL,
                            PassiveLevelThread,
                            Device
                            );
    if (status != STATUS_SUCCESS)
    {
        DEBUGMSG(DBG_ERROR, ("    PsCreateSystemThread PassiveLevelThread failed. Returned 0x%.8x\n", status));
		status = STATUS_INSUFFICIENT_RESOURCES;

		goto done;
    }



    //
    // Create a thread to run at IRQL PASSIVE_LEVEL to be always receiving.
    //
    status =  PsCreateSystemThread(
                    &Device->hPollingThread,
                    (ACCESS_MASK) 0L,
                    NULL,
                    NULL,
                    NULL,
                    PollingThread,
                    Device
                    );

	if (status != STATUS_SUCCESS)
    {
        DEBUGMSG(DBG_ERROR, ("    PsCreateSystemThread PollingThread failed. Returned 0x%.8x\n", status));

		status = STATUS_INSUFFICIENT_RESOURCES;
		goto done;

    }


    Device->fReceiving = TRUE;

done:
        return status;
}




NTSTATUS StartUsbRead(IN PUSB_DEVICE Device)
/*++

Routine Description:

    Allocates an irp and calls USBD.

Arguments:

    Device - Current usb device.

Return Value:

    STATUS_INSUFFICIENT_RESOURCES or result of IoCallDriver

--*/
{
    ULONG siz;
    ULONG length;
    PURB urb = NULL;
    PDEVICE_OBJECT urbTargetDev;
    PIO_STACK_LOCATION nextStack;
    NTSTATUS timeStat = STATUS_UNSUCCESSFUL;
	PMDL	mdl;
	PRCV_BUFFER pRecBuf;
	UINT Index;


    ASSERT(KeGetCurrentIrql() == PASSIVE_LEVEL);

    siz = sizeof(struct _URB_BULK_OR_INTERRUPT_TRANSFER);
    length = MAX_TOTAL_SIZE_WITH_ALL_HEADERS;

    UsbIncIoCount(Device);		//cafe add 
	// Find a free buffer and set the state to PENDING;

	pRecBuf = 	GetRcvBuf( Device, &Index, STATE_PENDING );

    if ( !pRecBuf)
    {
        //
        // no buffers available; drop it
        //
		timeStat = STATUS_UNSUCCESSFUL;

        goto done;
    }


	if( TRUE == Device->fPendingReadClearStall ) {

		timeStat = STATUS_UNSUCCESSFUL;
		goto done;
	}

    urb =  ((PURB) pRecBuf->Urb);


    // Build our URB for USBD

    NdisZeroMemory(urb, siz);

    ASSERT(Device->BulkInPipeHandle);

    //
    // Now that we have created the urb, we will send a
    // request to the USB device object.
    //

    KeClearEvent(&pRecBuf->Event);

    urbTargetDev = Device->pUsbDevObj;

    ASSERT(urbTargetDev);


    //
    // Now that we have created the urb, we will send a
    // request to the USB device object.
    //

    urbTargetDev = Device->pUsbDevObj;


	// make an irp sending to usbhub
	pRecBuf->Irp = IoAllocateIrp( (CCHAR)(Device->pUsbDevObj->StackSize +1), FALSE );


    if ( NULL == pRecBuf->Irp )
    {
        timeStat = STATUS_INSUFFICIENT_RESOURCES;
        goto done;
    }


    ((PIRP) pRecBuf->Irp)->IoStatus.Status = STATUS_NOT_SUPPORTED;
    ((PIRP) pRecBuf->Irp)->IoStatus.Information = 0;


	// Build our URB for USBD

    urb->UrbBulkOrInterruptTransfer.Hdr.Length = (USHORT) siz;
    urb->UrbBulkOrInterruptTransfer.Hdr.Function =
                URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER;
    urb->UrbBulkOrInterruptTransfer.PipeHandle =
               Device->BulkInPipeHandle;
    urb->UrbBulkOrInterruptTransfer.TransferFlags =
        USBD_TRANSFER_DIRECTION_IN ;

    // short packet is not treated as an error.
    urb->UrbBulkOrInterruptTransfer.TransferFlags |=
        USBD_SHORT_TRANSFER_OK;

    //
    // not using linked urb's
    //
    urb->UrbBulkOrInterruptTransfer.UrbLink = NULL;

    urb->UrbBulkOrInterruptTransfer.TransferBufferMDL = NULL;

    urb->UrbBulkOrInterruptTransfer.TransferBuffer = pRecBuf->dataBuf;

    urb->UrbBulkOrInterruptTransfer.TransferBufferLength =length;


    //
    // Call the class driver to perform the operation.


    nextStack = IoGetNextIrpStackLocation( (PIRP) pRecBuf->Irp );

    ASSERT(nextStack != NULL);

    //
    // pass the URB to the USB driver stack
    //


	nextStack->MajorFunction = IRP_MJ_INTERNAL_DEVICE_CONTROL;
	nextStack->Parameters.Others.Argument1 = urb;
	nextStack->Parameters.DeviceIoControl.IoControlCode =
		IOCTL_INTERNAL_USB_SUBMIT_URB;


    IoSetCompletionRoutine(
                ((PIRP) pRecBuf->Irp),     // irp to use
                UsbIoCompleteRead,      // routine to call when irp is done
                pRecBuf,  // context to pass routine is the RCV_BUFFER
                TRUE,                      // call on success
                TRUE,                      // call on error
                TRUE);                     // call on cancel


	//
    // Call IoCallDriver to send the irp to the usb port.
    //

    timeStat = IoCallDriver(/*Device,*/ urbTargetDev, (PIRP) pRecBuf->Irp ); // Start UsbRead()

    DEBUGMSG(DBG_OUT, (" StartUsbRead() after IoCallDriver () status = 0x%x\n", timeStat));

	ASSERT( STATUS_SUCCESS != timeStat );

	while ( timeStat != STATUS_SUCCESS ) { //we will always get to our completion routine, even if cancelled

		timeStat = MyKeWaitForSingleObject(
					   Device,
					   &pRecBuf->Event, //event to wait on
					   NULL,  //irp to cancel on halt/reset or timeout
					   0
//					   10000 * 1000 * 1 
					   );
	}

	ASSERT( NULL == pRecBuf->Irp ); // WIll be nulled by completion routine
done:
	if ( !pRecBuf || ( Device->RcvBuffersInUse >= (NUM_RCV_BUFS -2) ) ) {

		if ( FALSE == Device->fIndicatedMediaBusy ) {

			InterlockedExchange( &Device->fMediaBusy, TRUE );
			InterlockedExchange( &Device->fIndicatedMediaBusy, TRUE );
			IndicateMediaBusy( Device ); // indicate to Ndis  BUGBUG? NOT NEEDED HERE?
		}

	}

    return timeStat;
}



/*****************************************************************************
*
*  Function:   UsbIoCompleteRead
*
*  Synopsis:
*
*  Arguments:  pUsbDevObj - pointer to the  device object which
*                              completed the irp
*              pIrp          - the irp which was completed by the  device
*                              object
*              Context       - dev ext
*
*  Returns:    STATUS_MORE_PROCESSING_REQUIRED - allows the completion routine
*              (IofCompleteRequest) to stop working on the irp.
*
*  Algorithm:
*              This is the completion routine for all pending IRP_MJ_READ irps
*              sent to the  device object.
*
*              If there is a pending halt or reset, we exit the completion
*              routine without sending another irp to the USBl device object.
*
*
*              If the IRP_MJ_READ irp returned either STATUS_SUCCESS or
*              STATUS_TIMEOUT, we must process any data (stripping BOFs, ESC
*              sequences, and EOF) into an NDIS_BUFFER and NDIS_PACKET.
*
*              Another irp is then built (we just re-use the incoming irp) and
*              sent to the USB object with another IRP_MJ_READ
*              request.
*  Notes:
*
*  This routine is called (by the io manager) in IRQL DISPATCH_LEVEL.
*
*****************************************************************************/

NTSTATUS
UsbIoCompleteRead(
            IN PDEVICE_OBJECT pUsbDevObj,
            IN PIRP           pIrp,
            IN PVOID          Context
            )
{
    PUSB_DEVICE  device;
    NTSTATUS    status;
    ULONG_PTR    BytesRead;
	PRCV_BUFFER  pRecBuf;
	LARGE_INTEGER tat;

//    DEBUGMSG(DBG_FUNC, (" +UsbIoCompleteRead\n"));

    //
    // The context given to IoSetCompletionRoutine is the receive buffer object
    //

	pRecBuf = (PRCV_BUFFER) Context;

    device = (PUSB_DEVICE) pRecBuf->device;

    ASSERT( pRecBuf->Irp == pIrp );

    ASSERT( NULL != device );



    if ((device->fPendingHalt  == TRUE) ||
        (device->fPendingReset == TRUE))
    {
        //
        // Set the fReceiving boolean so that the halt and reset routines
        // know when it is okay to continue.
        //
                    // change the below back to DBG_FUNC later?
        DEBUGMSG(DBG_FUNC, ("UsbIoCompleteRead  halt or reset pending setting fReceiving FALSE\n"));
        device->fReceiving = FALSE;


    }



    //
    // We have a number of cases:
    //      1) The USB read timed out and we received no data.
    //      2) The USB read timed out and we received some data.
    //      3) The USB read was successful and fully filled our irp buffer.
    //      4) The irp was cancelled.
    //      5) Some other failure from the USB device object.
    //


    status = pIrp->IoStatus.Status;

    //
    // IoCallDriver has been called on this Irp;
    // Set the length based on the TransferBufferLength
    // value in the URB
    //
    pIrp->IoStatus.Information =
         ((PURB) pRecBuf->Urb)->UrbBulkOrInterruptTransfer.TransferBufferLength;

    BytesRead = pIrp->IoStatus.Information;

	device->pCurrentRcvBuf = NULL;


    switch (status)
    {
        case STATUS_SUCCESS:

            if (BytesRead > 0)
            {

				pRecBuf->dataLen = (UINT)pIrp->IoStatus.Information;

                //
                // We don't need to synchronously wait here
				// for the packet to be processed and sent to the protocol
                //
#if 0 // BUGBUG?  EXPERIMENT
			if ( FALSE == ScheduleWorkItem( device,
					 ProcessDataCallBack,
					 pRecBuf,
					 sizeof( RCV_BUFFER )){

				status = STATUS_INSUFFICIENT_RESOURCES;

			}
		

#else
			device->pCurrentRcvBuf = pRecBuf; // do it in polling loop (at PASSIVE_LEVEL)
			//	ProcessData(
			//				device,
			//				pRecBuf
			//				);

#endif

            }

            break; // STATUS_SUCCESS

        case STATUS_TIMEOUT:
            device->NumDataErrors++;
            DEBUGMSG(DBG_FUNC, (" UsbIoCompleteRead STATUS_TIMEOUT\n"));
            break;

        case STATUS_PENDING:
            DEBUGMSG(DBG_FUNC, (" UsbIoCompleteRead STATUS_PENDING\n"));
            break;

        case STATUS_DEVICE_DATA_ERROR:
        // can get during shutdown
            device->NumDataErrors++;
            DEBUGMSG(DBG_FUNC, (" UsbIoCompleteRead STATUS_DEVICE_DATA_ERROR\n"));
            break;

        case STATUS_UNSUCCESSFUL:
            device->NumDataErrors++;
            DEBUGMSG(DBG_ERR, (" UsbIoCompleteRead STATUS_UNSUCCESSFUL\n"));
            break;

        case STATUS_INSUFFICIENT_RESOURCES:
            device->NumDataErrors++;
            DEBUGMSG(DBG_ERR, (" UsbIoCompleteRead STATUS_INSUFFICIENT_RESOURCES\n"));
            break;
        case STATUS_INVALID_PARAMETER:
            device->NumDataErrors++;
            DEBUGMSG(DBG_ERR, (" UsbIoCompleteRead STATUS_INVALID_PARAMETER\n"));
            break;

        case STATUS_CANCELLED:
            DEBUGMSG(DBG_FUNC, (" UsbIoCompleteRead STATUS_CANCELLED\n"));
            break;

        case STATUS_DEVICE_NOT_CONNECTED:
        // can get during shutdown
            device->NumDataErrors++;
            DEBUGMSG(DBG_ERR, (" UsbIoCompleteRead STATUS_DEVICE_NOT_CONNECTED\n"));
            break;

        case STATUS_DEVICE_POWER_FAILURE:
        // can get during shutdown
            device->NumDataErrors++;
            DEBUGMSG(DBG_ERR, (" UsbIoCompleteRead STATUS_DEVICE_POWER_FAILURE\n"));
            break;

        default:
            device->NumDataErrors++;
            DEBUGMSG(DBG_ERR, (" UsbIoCompleteRead UNKNOWN WEIRD STATUS = 0x%x, dec %d\n",status,status ));

            break;
    }


	// if we were not successful, we need to free the recv buffer for future use right here
	if ( STATUS_SUCCESS != status || BytesRead==0 ) {

		pRecBuf->state = STATE_FREE;
	}

    //
    // Free the IRP  and its mdl because they were  alloced by us
    //

	IoFreeIrp( pIrp );

    pRecBuf->Irp = NULL;

    device->NumReads++;


	UsbDecIoCount( device ); // we will track count of pending irps


	if (( STATUS_SUCCESS != status )  && ( STATUS_CANCELLED != status )) {

		PURB urb = (PURB) pRecBuf->Urb;

		DEBUGMSG(DBG_ERR, (" UsbIoCompleteRead error, will schedule a clear stall via URB_FUNCTION_RESET_PIPE\n"));

		DEBUGMSG(DBG_ERR, (" USBD status = 0x%x\n", urb->UrbHeader.Status));

		DEBUGMSG(DBG_ERR, (" NT status = 0x%x\n",  status));



		InterlockedExchange( &device->fPendingReadClearStall, TRUE );

		ScheduleWorkItem( device,
		  ResetPipeCallback, device->BulkInPipeHandle, 0);

//cafe add 0814
		device->fKillPollingThread=TRUE;

	}


	KeSetEvent(&pRecBuf->Event, 0, FALSE);  //signal polling thread

    //
    // We return STATUS_MORE_PROCESSING_REQUIRED so that the completion
    // routine (IofCompleteRequest) will stop working on the irp.
    //

    status = STATUS_MORE_PROCESSING_REQUIRED;

//    DEBUGMSG(DBG_FUNC, ("-UsbIoCompleteRead\n"));

    return status;
}



BOOLEAN
ScheduleWorkItem(
            PUSB_DEVICE        pDevice,
            WORK_PROC         Callback,
            PVOID             InfoBuf,
            ULONG             InfoBufLen)
{
	int i;
	PUSB_WORK_ITEM pWorkItem = NULL;
	BOOLEAN fRes = FALSE;


    DEBUGMSG(DBG_FUNC, ("+ScheduleWorkItem\n"));

    for (i = 0; i < NUM_WORK_ITEMS; i++){
			
		pWorkItem = &(pDevice->WorkItems[i]);

		if ( pWorkItem->fInUse == FALSE ) {

				InterlockedExchange( (PLONG) &pWorkItem->fInUse, TRUE);
				fRes = TRUE;
				break;
		}
	}

	// Can't fail because can only have one set and one query pending,
	// and no more than 8 packets  to process
	ASSERT( NULL != pWorkItem );
	ASSERT(i < NUM_WORK_ITEMS );

    InterlockedExchangePointer( &pWorkItem->InfoBuf, InfoBuf);
    InterlockedExchange( (PLONG) &pWorkItem->InfoBufLen, InfoBufLen);

    /*
    ** This interface was designed to use NdisScheduleWorkItem(), which
    ** would be good except that we're really only supposed to use that
    ** interface during startup and shutdown, due to the limited pool of
    ** threads available to service NdisScheduleWorkItem().  Therefore,
    ** instead of scheduling real work items, we simulate them, and use
    ** our own thread to process the calls.  This also makes it easy to
    ** expand the size of our own thread pool, if we wish.
    **
    ** Our version is slightly different from actual NDIS_WORK_ITEMs,
    ** because that is an NDIS 5.0 structure, and we want people to
    ** (at least temporarily) build this with NDIS 4.0 headers.
    */

    InterlockedExchangePointer( (PVOID *)&pWorkItem->Callback, (PVOID)Callback);

    /*
    ** Our worker thread checks this list for new jobs, whenever its event
    ** is signalled.
    */

    // wake up worker thread
    KeSetEvent(&pDevice->EventPassiveThread, 0, FALSE);

    DEBUGMSG(DBG_FUNC, ("-ScheduleWorkItem\n"));
	return fRes;

}

VOID
FreeWorkItem(
            PUSB_WORK_ITEM pItem
            )
{
    InterlockedExchange( (PLONG) &pItem->fInUse, FALSE );
}



BOOLEAN
CancelPendingIo(
    IN PUSB_DEVICE Device
    )
/*++



Return Value:

    TRUE if cancelled any, else FALSE

--*/
{
	BOOLEAN cRes = TRUE;

    DEBUGMSG( DBG_FUNC, ("  +CancelPendingIo(), fDeviceStarted =%d\n", Device->fDeviceStarted)); // chag to FUNC later?

    ASSERT(KeGetCurrentIrql() <= DISPATCH_LEVEL);

    if ( Device->fDeviceStarted ){

        CancelPendingReadIo(Device, TRUE);

        CancelPendingWriteIo(Device);
    }


    DEBUGMSG( DBG_FUNC, ("  -CancelPendingIo()\n")); // chag to FUNC later?

    return (BOOLEAN) cRes;

}






BOOLEAN
CancelPendingReadIo(
    IN PUSB_DEVICE DeviceExt,
	BOOLEAN fWaitCancelComplete
    )
/*++



Return Value:

    TRUE if cancelled any, else FALSE

--*/
{
	PUSB_DEVICE device = DeviceExt;
	BOOLEAN cRes = FALSE;
    NTSTATUS timeStat;
	int i;

    DEBUGMSG( DBG_FUNC, ("  +CancelPendingReadIo()\n"));

    ASSERT(KeGetCurrentIrql() <= DISPATCH_LEVEL);

	
    for (i = 0; i < NUM_RCV_BUFS; i++)
    {
        PRCV_BUFFER  pRcvBuf = &device->rcvBufs[i];

        if ( ( STATE_PENDING == pRcvBuf->state ) &&
			 ( NULL != pRcvBuf->Irp ) )
        {

			PIRP pIrp = (PIRP) pRcvBuf->Irp;

			// Since IoCallDriver has been called on this request, we call IoCancelIrp
			//  and let our completion routine handle it
			//
			DEBUGMSG( DBG_FUNC, ("  CancelPendingReadIo() about to CANCEL a read IRP!\n"));

			KeClearEvent( &pRcvBuf->Event );

			cRes = IoCancelIrp( (PIRP) pRcvBuf->Irp );  //CancelPendingReadIo()

			DEBUGCOND( DBG_ERR, !cRes, ("  CancelPendingReadIo() COULDN'T CANCEL IRP!\n"));
			DEBUGCOND( DBG_FUNC, cRes, ("  CancelPendingReadIo() CANCELLED IRP SUCCESS!\n"));

			if ( cRes  && fWaitCancelComplete ) {

				timeStat = MyKeWaitForSingleObject(
						   device,
						   &pRcvBuf->Event,
						   NULL,  // irp to cancel; we did it above already, so pass NULL
						   0 );

				ASSERT( pRcvBuf->Irp == NULL);
			}		
			
		} // if pending

    } // for


    DEBUGMSG( DBG_FUNC, ("  -CancelPendingReadIo()\n"));

    return (BOOLEAN) cRes;

}


BOOLEAN
CancelPendingWriteIo(
    IN PUSB_DEVICE DeviceExt
    )
/*++



Return Value:

    TRUE if cancelled any, else FALSE

--*/
{
	PUSB_DEVICE device = DeviceExt;
	BOOLEAN cRes = FALSE;
    NTSTATUS timeStat;
	PUSB_CONTEXT pCont;
	ULONGLONG thisContext;  //make ptr arithmetic 64-bit compatible
	int i;

    DEBUGMSG( DBG_FUNC, ("  +CancelPendingWriteIo()\n"));

    ASSERT(KeGetCurrentIrql() < DISPATCH_LEVEL);


    //
    // Free all resources for the SEND buffer queue.
    //


	thisContext = (ULONGLONG) device->pSendContexts;

	for ( i= 0; i < NUM_SEND_CONTEXTS; i++ ) {

		pCont = (PUSB_CONTEXT)thisContext;

		if( TRUE == pCont->fInUse ) {

			// Get the USB_CONTEXT and cancel it's IRP; the completion routine will itself
			// remove it from the HeadPendingSendList and NULL out HeadPendingSendList
			//  when the last IRP on the list has been  cancelled; that's how we exit this loop
			//

			ASSERT( NULL != pCont->Irp );

			DEBUGMSG( DBG_WARN, ("  CancelPendingWriteIo() about to CANCEL a write IRP!\n"));

			// Completion routine ( USBCompleteWrite() )will free irps, mdls, buffers, etc as well
			cRes = IoCancelIrp( pCont->Irp );

			DEBUGCOND( DBG_ERR, !cRes, ("  CancelPendingWriteIo() COULDN'T CANCEL IRP! 0x%x\n", pCont->Irp ));
			DEBUGCOND( DBG_FUNC, cRes, ("  CancelPendingWriteIo() CANCELLED IRP SUCCESS! 0x%x\n\n", pCont->Irp));


			//
			// Sleep 200 microsecs to give cancellation time to work
			//

			NdisMSleep(200);
		}

		thisContext +=  sizeof( USB_CONTEXT );


	} // for
	
	

    DEBUGMSG( DBG_FUNC, ("  -CancelPendingWriteIo()\n"));

    return (BOOLEAN) cRes;

}

BOOLEAN
CancelPendingControlIo(
    IN PUSB_DEVICE DeviceExt,
	IN PIRP  IrpToCancel,
	IN PKEVENT EventToClear

    )
/*++



Return Value:

    TRUE if cancelled any, else FALSE

--*/
{
	PUSB_DEVICE device = DeviceExt;
	BOOLEAN cRes = FALSE;
    NTSTATUS timeStat;

    DEBUGMSG( DBG_FUNC, ("  +CancelPendingControlIo()\n"));

    ASSERT(KeGetCurrentIrql() <= DISPATCH_LEVEL );


	KeClearEvent( EventToClear );

	cRes = IoCancelIrp( IrpToCancel );  //CancelPendingControlIo()

    DEBUGCOND( DBG_ERR, !cRes, ("  CancelPendingControlIo() COULDN'T CANCEL IRP!\n"));
    DEBUGCOND( DBG_FUNC, cRes, ("  CancelPendingControlIo() CANCELLED IRP SUCCESS!\n"));

	if ( cRes ) {
		timeStat = MyKeWaitForSingleObject(
				   device,
				   EventToClear,
				   NULL,  // irp to cancel; we did it above already, so pass NULL
				   0 );
	}


    DEBUGMSG( DBG_FUNC, ("  -CancelPendingControlIo()\n"));

    return (BOOLEAN) cRes;

}

NTSTATUS
CallUSBD(
    IN PUSB_DEVICE Device,
    IN PURB Urb
    )
/*++

Routine Description:

    Passes a URB to the USBD class driver
	The client device driver passes USB request block (URB) structures
	to the class driver as a parameter in an IRP with Irp->MajorFunction
	set to IRP_MJ_INTERNAL_DEVICE_CONTROL and the next IRP stack location
	Parameters.DeviceIoControl.IoControlCode field set to
	IOCTL_INTERNAL_USB_SUBMIT_URB.

Arguments:

    DeviceExt - pointer to the dev ext

    Urb - pointer to an already-formatted Urb request block

Return Value:

    STATUS_SUCCESS if successful,
    STATUS_UNSUCCESSFUL otherwise

--*/
{
    NTSTATUS ntStatus;
    PDEVICE_OBJECT urbTargetDev;
    PIO_STACK_LOCATION nextStack;
	PMDL mdl;

    DEBUGMSG( DBG_FUNC,(" +++CallUSBD\n"));

    ASSERT(KeGetCurrentIrql() == PASSIVE_LEVEL );

    ASSERT( Device );

    ASSERT( NULL == ((PUSB_INFO) Device->pUsbInfo)->IrpSubmitUrb );  //shouldn't be multiple control calls pending

    //
    // issue a synchronous request (we'll wait )
    //

    urbTargetDev = Device->pUsbDevObj;

    ASSERT( urbTargetDev );

		// make an irp sending to usbhub
	((PUSB_INFO) Device->pUsbInfo)->IrpSubmitUrb = 
	        IoAllocateIrp( (CCHAR)(Device->pUsbDevObj->StackSize +1), FALSE );

    if ( NULL == ((PUSB_INFO) Device->pUsbInfo)->IrpSubmitUrb )
    {
        DEBUGMSG(DBG_ERR, ("  CallUsbd failed to alloc IRP\n"));

		ntStatus = STATUS_INSUFFICIENT_RESOURCES;

        goto done;
    }

    ((PUSB_INFO) Device->pUsbInfo)->IrpSubmitUrb->IoStatus.Status = STATUS_NOT_SUPPORTED;
    ((PUSB_INFO) Device->pUsbInfo)->IrpSubmitUrb->IoStatus.Information = 0;



    //
    // Call the class driver to perform the operation.  If the returned status
    // is PENDING, wait for the request to complete.
    //

    nextStack = IoGetNextIrpStackLocation(((PUSB_INFO) Device->pUsbInfo)->IrpSubmitUrb);
    ASSERT(nextStack != NULL);

    //
    // pass the URB to the USB driver stack
    //
    nextStack->Parameters.Others.Argument1 = Urb;

    //
    // pass the URB to the USB driver stack
    //


	nextStack->MajorFunction = IRP_MJ_INTERNAL_DEVICE_CONTROL;
	nextStack->Parameters.Others.Argument1 = Urb;
	nextStack->Parameters.DeviceIoControl.IoControlCode =
		IOCTL_INTERNAL_USB_SUBMIT_URB;


    IoSetCompletionRoutine(
                ((PUSB_INFO) Device->pUsbInfo)->IrpSubmitUrb,      // irp to use
                UsbIoCompleteControl,         // routine to call when irp is done
                DEV_TO_CONTEXT(Device),  // context to pass routine
                TRUE,                      // call on success
                TRUE,                      // call on error
                TRUE);                     // call on cancel

	KeClearEvent(&Device->EventUrb);

	UsbIncIoCount( Device );

    ntStatus =  IoCallDriver( urbTargetDev, ((PUSB_INFO) Device->pUsbInfo)->IrpSubmitUrb );

    DEBUGMSG( DBG_OUT,("CallUSBD () return from IoCallDriver USBD %x\n", ntStatus));

    if ((ntStatus == STATUS_PENDING) || (ntStatus == STATUS_SUCCESS)){

        // wait, but dump out on timeout
        if (ntStatus == STATUS_PENDING){
            ntStatus = MyKeWaitForSingleObject( Device, &Device->EventUrb, NULL, 0 );

            if ( ntStatus == STATUS_TIMEOUT ) {
                DEBUGMSG( DBG_ERR,("CallUSBD () TIMED OUT! return from IoCallDriver USBD %x\n", ntStatus));

				CancelPendingControlIo( Device, ((PUSB_INFO) Device->pUsbInfo)->IrpSubmitUrb, &Device->EventUrb );
            }
        }

    } else {
        DEBUGMSG( DBG_ERR, ("CallUSBD IoCallDriver FAILED(%x)\n",ntStatus));
    }

    DEBUGMSG( DBG_OUT,("CallUSBD () URB status = %x  IRP status = %x\n",
        Urb->UrbHeader.Status, ntStatus ));
done:

	((PUSB_INFO) Device->pUsbInfo)->IrpSubmitUrb = NULL;


    DEBUGCOND( DBG_ERR, !NT_SUCCESS( ntStatus ), ("exit CallUSBD FAILED (%x)\n", ntStatus));

    DEBUGMSG( DBG_FUNC,(" -CallUSBD\n"));

    return ntStatus;
}




NTSTATUS
IoCtlUSBD(
    IN PUSB_DEVICE Device,
    IN ULONG IoCtl
    )
/*++

Routine Description:

    Passes a USBD IOCTL to the USBD class driver

Arguments:

    DeviceExt - pointer to the dev ext

   IoCtl - the USBD ioctl

Return Value:

    STATUS_SUCCESS if successful,
    STATUS_UNSUCCESSFUL otherwise

--*/
{
    NTSTATUS ntStatus;
    PDEVICE_OBJECT urbTargetDev;
    PIO_STACK_LOCATION nextStack;
	PMDL mdl;

    DEBUGMSG( DBG_FUNC,(" +++IoCtlUSBD\n"));

    ASSERT(KeGetCurrentIrql() == PASSIVE_LEVEL );

    ASSERT( Device );

    ASSERT( NULL == ((PUSB_INFO) Device->pUsbInfo)->IrpSubmitIoCtl );  //shouldn't be multiple control calls pending

    //
    // issue a synchronous request (we'll wait )
    //

    urbTargetDev = Device->pUsbDevObj;

    ASSERT( urbTargetDev );

		// make an irp sending to usbhub
	((PUSB_INFO) Device->pUsbInfo)->IrpSubmitIoCtl = IoAllocateIrp( (CCHAR)(Device->pUsbDevObj->StackSize +1), FALSE );

    if ( NULL == ((PUSB_INFO) Device->pUsbInfo)->IrpSubmitIoCtl )
    {
        DEBUGMSG(DBG_ERR, ("  IoCtlUSBD failed to alloc IRP\n"));

		ntStatus = STATUS_INSUFFICIENT_RESOURCES;

        goto done;
    }

    ((PUSB_INFO) Device->pUsbInfo)->IrpSubmitIoCtl->IoStatus.Status = STATUS_NOT_SUPPORTED;
    ((PUSB_INFO) Device->pUsbInfo)->IrpSubmitIoCtl->IoStatus.Information = 0;



    //
    // Call the class driver to perform the operation.  If the returned status
    // is PENDING, wait for the request to complete.
    //

    nextStack = IoGetNextIrpStackLocation(((PUSB_INFO) Device->pUsbInfo)->IrpSubmitIoCtl);
    ASSERT(nextStack != NULL);


	nextStack->MajorFunction = IRP_MJ_INTERNAL_DEVICE_CONTROL;
	nextStack->Parameters.DeviceIoControl.IoControlCode = IoCtl;


    IoSetCompletionRoutine(
                ((PUSB_INFO) Device->pUsbInfo)->IrpSubmitIoCtl,      // irp to use
                UsbIoCompleteControl,         // routine to call when irp is done
                DEV_TO_CONTEXT(Device),  // context to pass routine
                TRUE,                      // call on success
                TRUE,                      // call on error
                TRUE);                     // call on cancel

	KeClearEvent(&Device->EventIoCtl);

	UsbIncIoCount( Device );

    ntStatus =  IoCallDriver( urbTargetDev, 
            ((PUSB_INFO) Device->pUsbInfo)->IrpSubmitIoCtl );

    DEBUGMSG( DBG_OUT,("IoCtlUSBD () return from IoCallDriver USBD %x\n", ntStatus));

    if ((ntStatus == STATUS_PENDING) || (ntStatus == STATUS_SUCCESS)){

        // wait, but dump out on timeout
        if (ntStatus == STATUS_PENDING){
            ntStatus = MyKeWaitForSingleObject( Device, &Device->EventIoCtl, NULL, 0 );

            if ( ntStatus == STATUS_TIMEOUT ) {
                DEBUGMSG( DBG_ERR,("IoCtlUSBD () TIMED OUT! return from IoCallDriver USBD %x\n", ntStatus));

				CancelPendingControlIo( Device, ((PUSB_INFO) Device->pUsbInfo)->IrpSubmitIoCtl, &Device->EventIoCtl );
            }
        }

    } else {
        DEBUGMSG( DBG_ERR, ("IoCtlUSBD IoCallDriver FAILED(%x)\n",ntStatus));
    }

    DEBUGMSG( DBG_OUT,("IoCtlUSBD ()  IRP status = %x\n",
         ntStatus ));
done:

	((PUSB_INFO) Device->pUsbInfo)->IrpSubmitIoCtl = NULL;


    DEBUGCOND( DBG_ERR, !NT_SUCCESS( ntStatus ), ("exit IoCtlUSBD FAILED NTSTATUS (%x)\n", ntStatus));

    DEBUGMSG( DBG_FUNC,(" -IoCtlUSBD\n"));

    return ntStatus;
}



/*****************************************************************************
*
*  Function:   UsbIoCompleteControl
*
*  Synopsis:   General completetion routine just to insure cancel-ability of control calls
*              and keep track of pending irp count
*
*  Arguments:  pUsbDevObj - pointer to the  device object which
*                              completed the irp
*              pIrp          - the irp which was completed by the  device
*                              object
*              Context       - dev ext
*
*  Returns:    STATUS_MORE_PROCESSING_REQUIRED - allows the completion routine
*              (IofCompleteRequest) to stop working on the irp.
*

*  This routine is called (by the io manager) in IRQL DISPATCH_LEVEL.
*
*****************************************************************************/

NTSTATUS
UsbIoCompleteControl(
            IN PDEVICE_OBJECT pUsbDevObj,
            IN PIRP           pIrp,
            IN PVOID          Context
            )
{
    PUSB_DEVICE  device;
    NTSTATUS    status;


    DEBUGMSG(DBG_FUNC, ("---UsbIoCompleteControl\n"));

    //
    // The context given to IoSetCompletionRoutine is simply the the ir
    // device object pointer.
    //

    device = CONTEXT_TO_DEV(Context);


    status = pIrp->IoStatus.Status;

    switch (status)
    {
        case STATUS_SUCCESS:
            DEBUGMSG(DBG_OUT, (" UsbIoCompleteControl STATUS_SUCCESS\n"));
            break; // STATUS_SUCCESS

        case STATUS_TIMEOUT:
            DEBUGMSG(DBG_ERR, (" UsbIoCompleteControl STATUS_TIMEOUT\n"));

            break;

        case STATUS_PENDING:
            DEBUGMSG(DBG_ERR, (" UsbIoCompleteControl STATUS_PENDING\n"));
            break;

        case STATUS_DEVICE_DATA_ERROR:
        // can get during shutdown
            DEBUGMSG(DBG_ERR, (" UsbIoCompleteControl STATUS_DEVICE_DATA_ERROR\n"));

            break;

        case STATUS_UNSUCCESSFUL:
            DEBUGMSG(DBG_ERR, (" UsbIoCompleteControl STATUS_UNSUCCESSFUL\n"));

            break;

        case STATUS_INSUFFICIENT_RESOURCES:
            DEBUGMSG(DBG_ERR, (" UsbIoCompleteControl STATUS_INSUFFICIENT_RESOURCES\n"));
            break;

        case STATUS_INVALID_PARAMETER:
            DEBUGMSG(DBG_ERR, (" UsbIoCompleteControl STATUS_INVALID_PARAMETER\n"));
            break;

        case STATUS_CANCELLED:
            DEBUGMSG(DBG_ERR, (" UsbIoCompleteControl STATUS_CANCELLED\n"));
            break;

        case STATUS_DEVICE_NOT_CONNECTED:
        // can get during shutdown
            DEBUGMSG(DBG_ERR, (" UsbIoCompleteControl STATUS_DEVICE_NOT_CONNECTED\n"));
            break;

        case STATUS_DEVICE_POWER_FAILURE:
        // can get during shutdown
            DEBUGMSG(DBG_ERR, (" UsbIoCompleteControl STATUS_DEVICE_POWER_FAILURE\n"));
            break;

        default:
            DEBUGMSG(DBG_ERR, (" UsbIoCompleteControl UNKNOWN WEIRD STATUS = 0x%x, dec %d\n",status,status ));
            ASSERT( 0 );

            break;
    }


	UsbDecIoCount( device );  //we track pending irp count

	if  ( pIrp == ((PUSB_INFO) device->pUsbInfo)->IrpSubmitUrb ) {

		ASSERT( NULL != ((PUSB_INFO) device->pUsbInfo)->IrpSubmitUrb );

		IoFreeIrp( ((PUSB_INFO) device->pUsbInfo)->IrpSubmitUrb );

		device->StatusControl =  status; // save status because can't use irp after completion routine is hit!
		KeSetEvent(&device->EventUrb, 0, FALSE);  //signal we're done

	} else {

		DEBUGMSG( DBG_ERR, (" UsbIoCompleteControl UNKNOWN IRP\n"));

		ASSERT( 0 );
	}



    DEBUGCOND(DBG_ERR, !( NT_SUCCESS( status ) ), ("UsbIoCompleteControl BAD status = 0x%x\n", status));

    DEBUGMSG(DBG_FUNC, ("-UsbIoCompleteControl\n"));


    // We return STATUS_MORE_PROCESSING_REQUIRED so that the completion
    // routine (IofCompleteRequest) will stop working on the irp.
    //

    status = STATUS_MORE_PROCESSING_REQUIRED;

    return status;
}




NTSTATUS
GetClassDescriptor(
    IN PUSB_DEVICE Device,
    IN OUT PUSB_CLASS_SPECIFIC_DESCRIPTOR ClassDesc
    )
/*++

Routine Description:

    Get the USB dongle's Class-Specific descriptor; this has many
    characterisitics we must tell Ndis about, such as supported speeds,
    BOFS required, rate sniff-supported flag, turnaround time, window size,
    data size.

    This routine allocates and frees the URB

Arguments:

    Device - pointer to the dev ext

    ClassDesc - ptr to Caller-allocated USB_CLASS_SPECIFIC_DESCRIPTOR

Return Value:

    STATUS_SUCCESS if successful,
    STATUS_UNSUCCESSFUL otherwise

--*/
{

    NTSTATUS ntStatus = STATUS_INSUFFICIENT_RESOURCES ;
    PURB urb;
    UINT lenUrb, lenDesc;

    DEBUGMSG( DBG_FUNC, ("  +GetClassDescriptor()\n"));

    ASSERT( NULL == ((PUSB_INFO) Device->pUsbInfo)->IrpSubmitUrb );  //shouldn't be multiple control calls pending

    lenUrb = sizeof( struct _URB_CONTROL_VENDOR_OR_CLASS_REQUEST );
    lenDesc = sizeof(USB_CLASS_SPECIFIC_DESCRIPTOR );

	urb = (PURB) &((PUSB_INFO) Device->pUsbInfo)->ClassUrb;
						
    DEBUGMSG( DBG_OUT, ("  len of _URB_CONTROL_VENDOR_OR_CLASS_REQUEST = 0x%x, len of USB_CLASS_SPECIFIC_DESCRIPTOR =0x%x \n", lenUrb, lenDesc));

    NdisZeroMemory( urb, lenUrb );

    urb->UrbHeader.Length = (USHORT) lenUrb;
    urb->UrbHeader.Function = URB_FUNCTION_CLASS_INTERFACE;
    urb->UrbControlVendorClassRequest.Index = 0;  // index of interface; we only have one
    urb->UrbControlVendorClassRequest.RequestTypeReservedBits =  0; // only the reserved bits! see usbd100 doc chap 9.2
    urb->UrbControlVendorClassRequest.Request = 6;  //also from Bridge doc sec 6.2.5
    urb->UrbControlVendorClassRequest.Value = 0;    //also from Bridge doc sec 6.2.5
    urb->UrbControlVendorClassRequest.TransferFlags = USBD_TRANSFER_DIRECTION_IN; // | USBD_SHORT_TRANSFER_OK;
    urb->UrbControlVendorClassRequest.TransferBuffer = ClassDesc;
    urb->UrbControlVendorClassRequest.TransferBufferLength = lenDesc;

	ntStatus = CallUSBD(Device, urb); //GetClassDescriptor; done in main thread



    DEBUGCOND( DBG_ERR, !NT_SUCCESS( ntStatus ), ("  GetClassDescriptor FAILED ( 0x%x )\n", ntStatus));

    DEBUGMSG( DBG_FUNC, ("  -GetClassDescriptor( 0x%x )\n", ntStatus));

    return ntStatus;
}




NTSTATUS
ConfigureDevice(
    IN  PUSB_DEVICE DeviceExt
    )
/*++

Routine Description:

    Initializes a given instance of the device on the USB and
	selects and saves the configuration.


Return Value:

    NT status code

--*/
{
    PUSB_DEVICE device;
    NTSTATUS ntStatus = STATUS_SUCCESS;
    PURB urb;
    ULONG siz;

    DEBUGMSG(DBG_FUNC,(" +ConfigureDevice()\n"));

    device = DeviceExt;

	ASSERT( ((PUSB_INFO) device->pUsbInfo)->UsbConfigurationDescriptor == NULL );


    urb = (PURB)  &((PUSB_INFO) device->pUsbInfo)->DescriptorUrb;


	// When USB_CONFIGURATION_DESCRIPTOR_TYPE is specified for DescriptorType
	// in a call to UsbBuildGetDescriptorRequest(),
	// all interface, endpoint, class-specific, and vendor-specific descriptors
	// for the configuration also are retrieved.
	// The caller must allocate a buffer large enough to hold all of this
	// information or the data is truncated without error.
	// Therefore the 'siz' set below is just a 'good guess', and we may have to retry

    siz = sizeof(USB_CONFIGURATION_DESCRIPTOR) + 512;  // Store size, may need to free

	// We will break out of this 'retry loop' when UsbBuildGetDescriptorRequest()
	// has a big enough device->UsbConfigurationDescriptor buffer not to truncate
	while( 1 ) {

		((PUSB_INFO) device->pUsbInfo)->UsbConfigurationDescriptor = MemAlloc( siz);

		if ( !((PUSB_INFO) device->pUsbInfo)->UsbConfigurationDescriptor ) {
		    MemFree(urb, sizeof(struct _URB_CONTROL_DESCRIPTOR_REQUEST));
			return STATUS_INSUFFICIENT_RESOURCES;
		}

		UsbBuildGetDescriptorRequest(urb,
									 (USHORT) sizeof (struct _URB_CONTROL_DESCRIPTOR_REQUEST),
									 USB_CONFIGURATION_DESCRIPTOR_TYPE,
									 0,
									 0,
									 ((PUSB_INFO) device->pUsbInfo)->UsbConfigurationDescriptor,
									 NULL,
									 siz,
									 NULL);

		ntStatus = CallUSBD(DeviceExt, urb); //Get Usb Config Descriptor; done in main thread

		DEBUGMSG(DBG_OUT,(" ConfigureDevice() Configuration Descriptor = %x, len %x\n",
						((PUSB_INFO) device->pUsbInfo)->UsbConfigurationDescriptor,
						urb->UrbControlDescriptorRequest.TransferBufferLength));
		//
		// if we got some data see if it was enough.
		// NOTE: we may get an error in URB because of buffer overrun
		if (urb->UrbControlDescriptorRequest.TransferBufferLength>0 &&
				((PUSB_INFO) device->pUsbInfo)->UsbConfigurationDescriptor->wTotalLength > siz) {

			MemFree(((PUSB_INFO) device->pUsbInfo)->UsbConfigurationDescriptor, siz);
			siz = ((PUSB_INFO) device->pUsbInfo)->UsbConfigurationDescriptor->wTotalLength;
			((PUSB_INFO) device->pUsbInfo)->UsbConfigurationDescriptor = NULL;
		} else {
			break;  // we got it on the first try
		}

	} // end, while (retry loop )


	ASSERT( ((PUSB_INFO) device->pUsbInfo)->UsbConfigurationDescriptor );


    if (!NT_SUCCESS(ntStatus)) {

        DEBUGMSG( DBG_ERR,(" ConfigureDevice() Get Config Descriptor FAILURE (%x)\n", ntStatus));
        goto done;
    }

    //
    // We have the configuration descriptor for the configuration we want.
    // Now we issue the select configuration command to get
    // the  pipes associated with this configuration.
    //


    ntStatus = SelectInterface(DeviceExt,
        ((PUSB_INFO) device->pUsbInfo)->UsbConfigurationDescriptor);


    if (!NT_SUCCESS(ntStatus)) 
	{
        DEBUGMSG( DBG_ERR,(" ConfigureDevice() SelectInterface() FAILURE (%x)\n", ntStatus));
    } else {

        //
        // Next we must get the Class-Specific Descriptor
        // Get the USB dongle's Class-Specific descriptor; this has many
        // characterisitics we must tell Ndis about, such as supported speeds,
        // BOFS required, rate sniff-supported flag, turnaround time, window size,
        // data size.
        //
//cafe add.
//        ntStatus = GetClassDescriptor( device, &(device->ClassDesc));
//        if (NT_SUCCESS(ntStatus)) {
            // fill out device from class-specific descriptor info
//        }
    }

done:

    DEBUGMSG(DBG_FUNC,(" -ConfigureDevice (%x)\n", ntStatus));

    return ntStatus;
}


NTSTATUS
SelectInterface(
    IN PUSB_DEVICE DeviceExt,
    IN PUSB_CONFIGURATION_DESCRIPTOR ConfigurationDescriptor
    )
/*++

Routine Description:

    Initializes an 82930 with (possibly) multiple interfaces;
	This minidriver only supports one interface (with multiple endpoints).

Arguments:

    Deviceext - pointer to the device ext for this instance of the 82930
                    device.

    ConfigurationDescriptor - pointer to the USB configuration
                    descriptor containing the interface and endpoint
                    descriptors.

Return Value:

    NT status code

--*/
{
    PUSB_DEVICE device;
    NTSTATUS ntStatus;
    PURB urb = NULL;
    ULONG i,j;
    PUSB_INTERFACE_DESCRIPTOR interfaceDescriptor = NULL;
    USBD_INTERFACE_LIST_ENTRY interfaceList[3];
    PUSBD_INTERFACE_INFORMATION interfaceObject[2];
    USHORT siz;
	UCHAR alternateSetting=0;

    DEBUGMSG(DBG_FUNC,(" +SelectInterface\n"));

    device = DeviceExt;

	// USBD_ParseConfigurationDescriptorEx searches a given configuration
	// descriptor and returns a pointer to an interface that matches the
	//  given search criteria. We only support one interface on this device
	//
	for(i=0;i<2;i++)
	{
		interfaceList[i].InterfaceDescriptor =
			USBD_ParseConfigurationDescriptor(ConfigurationDescriptor,
			(UCHAR)i, //interface number (this is bInterfaceNumber from interface descr)
			(UCHAR)alternateSetting);
			ASSERT(interfaceList[i].InterfaceDescriptor != NULL);
			if(interfaceList[i].InterfaceDescriptor==NULL) 
			return STATUS_UNSUCCESSFUL;
	}
	interfaceList[2].InterfaceDescriptor = NULL;
	interfaceList[2].Interface = NULL;

	urb = USBD_CreateConfigurationRequestEx(ConfigurationDescriptor, &interfaceList[0]);
		
	for(i=0;i<2;i++)
	{
		interfaceObject[i] = interfaceList[i].Interface;
		for (j=0; j<interfaceList[i].InterfaceDescriptor->bNumEndpoints; j++)
			interfaceObject[i]->Pipes[j].MaximumTransferSize =MAX_TOTAL_SIZE_WITH_ALL_HEADERS ;
	}
	

		
	ntStatus = CallUSBD(DeviceExt, urb); //select config; done in main thread
		
		
	if (NT_SUCCESS(ntStatus) && USBD_SUCCESS(urb->UrbHeader.Status))
	{	
		for(i=0;i<2;i++)
		{
			((PUSB_INFO) device->pUsbInfo)->UsbConfigurationHandle =
				urb->UrbSelectConfiguration.ConfigurationHandle;
			
			if ( NULL == ((PUSB_INFO) device->pUsbInfo)->UsbInterface[i] ) 
			{
				((PUSB_INFO) device->pUsbInfo)->UsbInterface[i] = 
					MemAlloc(interfaceObject[i]->Length);
			}
			
			if ( NULL != ((PUSB_INFO) device->pUsbInfo)->UsbInterface[i]) 
			{
				
				//
				// save a copy of the interface information returned
				//
				NdisMoveMemory(((PUSB_INFO) device->pUsbInfo)->UsbInterface[i], interfaceObject[i], interfaceObject[i]->Length);
				
				//
				// Dump the interface to the debugger
				//
				DEBUGMSG(DBG_DBG,("---------After Select Config \n"));
				DEBUGMSG(DBG_DBG,("NumberOfPipes 0x%x\n", ((PUSB_INFO) device->pUsbInfo)->UsbInterface[i]->NumberOfPipes));
				DEBUGMSG(DBG_DBG,("Length 0x%x\n", ((PUSB_INFO) device->pUsbInfo)->UsbInterface[i]->Length));
				DEBUGMSG(DBG_DBG,("Alt Setting 0x%x\n", ((PUSB_INFO) device->pUsbInfo)->UsbInterface[i]->AlternateSetting));
				DEBUGMSG(DBG_DBG,("Interface Number 0x%x\n", ((PUSB_INFO) device->pUsbInfo)->UsbInterface[i]->InterfaceNumber));
				DEBUGMSG(DBG_DBG,("Class, subclass, protocol 0x%x 0x%x 0x%x\n",
					((PUSB_INFO) device->pUsbInfo)->UsbInterface[i]->Class,
					((PUSB_INFO) device->pUsbInfo)->UsbInterface[i]->SubClass,
					((PUSB_INFO) device->pUsbInfo)->UsbInterface[i]->Protocol));
				
				// Find our Bulk in and out pipes, save their handles, Dump the pipe info
				for (j=0; j<interfaceObject[i]->NumberOfPipes; j++) 
				{
					PUSBD_PIPE_INFORMATION pipeInformation;
					
					pipeInformation = &((PUSB_INFO) device->pUsbInfo)->UsbInterface[i]->Pipes[j];
					
					//Find the Bulk In and Out pipes ( these are probably the only two pipes )
					if ( UsbdPipeTypeBulk == pipeInformation->PipeType )
					{
						// endpoint address with bit 0x80 set are input pipes, else output
						if ( USB_ENDPOINT_DIRECTION_IN( pipeInformation->EndpointAddress ) ) 
						{
							device->BulkInPipeHandle = pipeInformation->PipeHandle;
						}
						
						if ( USB_ENDPOINT_DIRECTION_OUT( pipeInformation->EndpointAddress ) ) 
						{
							device->BulkOutPipeHandle = pipeInformation->PipeHandle;
						}
						
					}
					
					
					DEBUGMSG(DBG_DBG,("---------\n"));
					DEBUGMSG(DBG_DBG,("PipeType 0x%x\n", pipeInformation->PipeType));
					DEBUGMSG(DBG_DBG,("EndpointAddress 0x%x\n", pipeInformation->EndpointAddress));
					DEBUGMSG(DBG_DBG,("MaxPacketSize 0x%x\n", pipeInformation->MaximumPacketSize));
					DEBUGMSG(DBG_DBG,("Interval 0x%x\n", pipeInformation->Interval));
					DEBUGMSG(DBG_DBG,("Handle 0x%x\n", pipeInformation->PipeHandle));
					DEBUGMSG(DBG_DBG,("MaximumTransferSize 0x%x\n", pipeInformation->MaximumTransferSize));
				}
				DEBUGMSG(DBG_DBG,("---------\n"));
			}
		}
	}
	
	//we better have found input and output bulk pipes!
	ASSERT( device->BulkInPipeHandle && device->BulkOutPipeHandle );
			
	if (urb) 
	{
			// don't call the MemFree since the buffer was
				//  alloced by USBD_CreateConfigurationRequest, not MemAlloc()
		ExFreePool(urb);
	}
			
			
	DEBUGMSG(DBG_FUNC,(" -SelectInterface (%x)\n", ntStatus));
			
	return ntStatus;
}


NTSTATUS
StartDevice(
    IN  PUSB_DEVICE DeviceExt
    )
/*++

Routine Description:

    Initializes a given instance of the device on the USB.
    USB client drivers such as us set up URBs (USB Request Packets) to send requests
    to the host controller driver (HCD). The URB structure defines a format for all
    possible commands that can be sent to a USB device.
    Here, we request the device descriptor and store it, and configure the device.




Return Value:

    NT status code

--*/
{
    PUSB_DEVICE device;
    NTSTATUS ntStatus;
    PUSB_DEVICE_DESCRIPTOR deviceDescriptor = NULL;
    PURB urb;
    ULONG siz;

    DEBUGMSG( DBG_FUNC, (" +StartDevice()\n"));

    device = DeviceExt;

    urb = MemAlloc(sizeof(struct _URB_CONTROL_DESCRIPTOR_REQUEST));

    DEBUGCOND( DBG_ERR,!urb, ("StartDevice() FAILED MemAlloc() for URB\n"));

    if (urb) {

        siz = sizeof(USB_DEVICE_DESCRIPTOR);

        deviceDescriptor = MemAlloc(siz);

        DEBUGCOND( DBG_ERR, !deviceDescriptor, ("StartDevice() FAILED MemAlloc() for deviceDescriptor\n"));

        if (deviceDescriptor) {

            UsbBuildGetDescriptorRequest(urb,
                                         (USHORT) sizeof (struct _URB_CONTROL_DESCRIPTOR_REQUEST),
                                         USB_DEVICE_DESCRIPTOR_TYPE,
                                         0,
                                         0,
                                         deviceDescriptor,
                                         NULL,
                                         siz,
                                         NULL);


            ntStatus = CallUSBD(DeviceExt, urb); // build get descripttor req; main thread

            DEBUGCOND( DBG_ERR, !NT_SUCCESS(ntStatus), ("StartDevice() FAILED CallUSBD (DeviceExt, urb)\n"));

            if (NT_SUCCESS(ntStatus)) {
                DEBUGMSG( DBG_DBG,("Device Descriptor = %x, len %x\n",
                                deviceDescriptor,
                                urb->UrbControlDescriptorRequest.TransferBufferLength));

                DEBUGMSG( DBG_DBG,("IR Dongle Device Descriptor:\n"));
                DEBUGMSG( DBG_DBG,("-------------------------\n"));
                DEBUGMSG( DBG_DBG,("bLength %d\n", deviceDescriptor->bLength));
                DEBUGMSG( DBG_DBG,("bDescriptorType 0x%x\n", deviceDescriptor->bDescriptorType));
                DEBUGMSG( DBG_DBG,("bcdUSB 0x%x\n", deviceDescriptor->bcdUSB));
                DEBUGMSG( DBG_DBG,("bDeviceClass 0x%x\n", deviceDescriptor->bDeviceClass));
                DEBUGMSG( DBG_DBG,("bDeviceSubClass 0x%x\n", deviceDescriptor->bDeviceSubClass));
                DEBUGMSG( DBG_DBG,("bDeviceProtocol 0x%x\n", deviceDescriptor->bDeviceProtocol));
                DEBUGMSG( DBG_DBG,("bMaxPacketSize0 0x%x\n", deviceDescriptor->bMaxPacketSize0));
                DEBUGMSG( DBG_DBG,("idVendor 0x%x\n", deviceDescriptor->idVendor));
                DEBUGMSG( DBG_DBG,("idProduct 0x%x\n", deviceDescriptor->idProduct));
                DEBUGMSG( DBG_DBG,("bcdDevice 0x%x\n", deviceDescriptor->bcdDevice));
                DEBUGMSG( DBG_DBG,("iManufacturer 0x%x\n", deviceDescriptor->iManufacturer));
                DEBUGMSG( DBG_DBG,("iProduct 0x%x\n", deviceDescriptor->iProduct));
                DEBUGMSG( DBG_DBG,("iSerialNumber 0x%x\n", deviceDescriptor->iSerialNumber));
                DEBUGMSG( DBG_DBG,("bNumConfigurations 0x%x\n", deviceDescriptor->bNumConfigurations));
            }
        } else {
			// if we got here we failed to allocate deviceDescriptor
            ntStatus = STATUS_INSUFFICIENT_RESOURCES;
        }


        if (NT_SUCCESS(ntStatus)) {
            ((PUSB_INFO) device->pUsbInfo)->UsbDeviceDescriptor = deviceDescriptor;
			device->IdVendor =
				((PUSB_INFO) device->pUsbInfo)->UsbDeviceDescriptor->idVendor;
        }

        MemFree(urb, sizeof(struct _URB_CONTROL_DESCRIPTOR_REQUEST));

    } else {
		// if we got here we failed to allocate the urb
        ntStatus = STATUS_INSUFFICIENT_RESOURCES;
    }

	if(deviceDescriptor->idVendor!=0x0b2a)
	{
		DEBUGMSG(DBG_ERROR,("Vendor id error!!\n"));
		ntStatus=0xffffffff;
	}
    if (NT_SUCCESS(ntStatus)) {
        ntStatus = ConfigureDevice(DeviceExt);

        DEBUGCOND( DBG_ERR,!NT_SUCCESS(ntStatus),("StartDevice ConfigureDevice() FAILURE (%x)\n", ntStatus));
    }


    if (NT_SUCCESS(ntStatus)) {
            DeviceExt->fDeviceStarted = TRUE;
    }

    DEBUGMSG( DBG_FUNC, (" -StartDevice (%x)\n", ntStatus));



    return ntStatus;
}




NTSTATUS
StopDevice(
    IN  PUSB_DEVICE DeviceExt
    )
/*++

Routine Description:

    Stops a given instance of a 82930 device on the USB.
    We basically just tell USB this device is now 'unconfigured'


Return Value:

    NT status code

--*/
{
    PUSB_DEVICE device;
    NTSTATUS ntStatus = STATUS_SUCCESS;
    PURB urb;
    ULONG siz;

    DEBUGMSG( DBG_FUNC,(" +StopDevice\n"));

    device = DeviceExt;

    //
    // Send the select configuration urb with a NULL pointer for the configuration
    // handle. This closes the configuration and puts the device in the 'unconfigured'
    // state.
    //

    siz = sizeof(struct _URB_SELECT_CONFIGURATION);

    urb = MemAlloc(siz);

    if (urb) {
        UsbBuildSelectConfigurationRequest(urb,
                                          (USHORT) siz,
                                          NULL);

        ntStatus = CallUSBD(DeviceExt, urb); // build select config req; main thread

        DEBUGCOND( DBG_ERR,!NT_SUCCESS(ntStatus),("StopDevice() FAILURE Configuration Closed status = %x usb status = %x.\n", ntStatus, urb->UrbHeader.Status));
        DEBUGCOND( DBG_WARN,NT_SUCCESS(ntStatus),("StopDevice() SUCCESS Configuration Closed status = %x usb status = %x.\n", ntStatus, urb->UrbHeader.Status));

        MemFree(urb, sizeof(struct _URB_SELECT_CONFIGURATION));
    } else {
        ntStatus = STATUS_INSUFFICIENT_RESOURCES;
    }


    DEBUGMSG( DBG_FUNC,(" -StopDevice  (%x) \n ", ntStatus));

    return ntStatus;
}

VOID
ResetPipeCallback (
    IN PUSB_WORK_ITEM   pWorkItem
    )
{
	PUSB_DEVICE device;
	HANDLE Pipe;
	NTSTATUS ntStatus;

	device = (PUSB_DEVICE) pWorkItem->pIrDevice;
	Pipe = ( HANDLE ) pWorkItem->InfoBuf;

	if( Pipe == device->BulkInPipeHandle ) {

		ASSERT( TRUE == device->fPendingReadClearStall );
		
		ResetPipe( device, Pipe );
		CancelPendingReadIo(device, TRUE );


		//StopDevice( device ); // select the NULL interface

		//ntStatus = SelectInterface( device, // re-select our real interface
		//	((PUSB_INFO) device->pUsbInfo)->UsbConfigurationDescriptor);

		InterlockedExchange( &device->fPendingReadClearStall, FALSE );


	} else  if( Pipe == device->BulkOutPipeHandle ) {


//		ASSERT( TRUE == device->fPendingWriteClearStall );
		if(TRUE != device->fPendingWriteClearStall )
		{
			DEBUGMSG(DBG_ERROR,("Error :TRUE != device->fPendingWriteClearStall"));
		}	
		ResetPipe( device, Pipe );
		CancelPendingWriteIo( device );

		//ResetPipe( device, Pipe );

		//StopDevice( device ); // select the NULL interface

		//ntStatus = SelectInterface( device, // re-select our real interface
		//	((PUSB_INFO) device->pUsbInfo)->UsbConfigurationDescriptor);

		InterlockedExchange( &device->fPendingWriteClearStall, FALSE );
	}
	else {
		ASSERT( 0 );
	}

	FreeWorkItem( pWorkItem );

}

//******************************************************************************
//
// ResetPipe()
//
// This will reset the host pipe to Data0 and should also reset the device
// endpoint to Data0 for Bulk and Interrupt pipes by issuing a Clear_Feature
// Endpoint_Stall to the device endpoint.
//
// Must be called at IRQL PASSIVE_LEVEL
//
//******************************************************************************

NTSTATUS
ResetPipe (
    IN PUSB_DEVICE   Device,
    IN HANDLE Pipe
    )
{
    PURB        urb;
    NTSTATUS    ntStatus;

    DEBUGMSG(DBG_ERR, ("  +ResetPipe()\n"));

    // Allocate URB for RESET_PIPE request
    //
    urb = MemAlloc( sizeof(struct _URB_PIPE_REQUEST));

    if (urb != NULL)
    {
#if 0
		NdisZeroMemory( urb, sizeof (struct _URB_PIPE_REQUEST) );

		DEBUGMSG(DBG_ERR, ("  ResetPipe before ABORT PIPE \n"));

		// Initialize ABORT_PIPE request URB
        //

        urb->UrbHeader.Length   = sizeof (struct _URB_PIPE_REQUEST);
        urb->UrbHeader.Function = URB_FUNCTION_ABORT_PIPE;
        urb->UrbPipeRequest.PipeHandle = Pipe;

        ntStatus = CallUSBD(Device, urb);

		DEBUGCOND(DBG_ERR, !NT_SUCCESS(ntStatus),  ("  ResetPipe ABORT PIPE FAILED \n"));


		DEBUGMSG(DBG_ERR, ("  ResetPipe  before RESET_PIPE \n"));
#endif
		
		NdisZeroMemory( urb, sizeof (struct _URB_PIPE_REQUEST) );

		// Initialize RESET_PIPE request URB
        //
        urb->UrbHeader.Length   = sizeof (struct _URB_PIPE_REQUEST);
        urb->UrbHeader.Function = URB_FUNCTION_RESET_PIPE;
        urb->UrbPipeRequest.PipeHandle = (USBD_PIPE_HANDLE) Pipe;

        // Submit RESET_PIPE request URB
        //
        ntStatus = CallUSBD(Device, urb);

		DEBUGCOND(DBG_ERR, !NT_SUCCESS(ntStatus),  ("  ResetPipe RESET PIPE FAILED \n"));
		DEBUGCOND(DBG_ERR, NT_SUCCESS(ntStatus),  ("  ResetPipe RESET PIPE SUCCEEDED \n"));



        // Done with URB for RESET_PIPE request, free urb
        //
        ExFreePool(urb);
    }
    else
    {
        ntStatus = STATUS_INSUFFICIENT_RESOURCES;
    }

    DEBUGMSG(DBG_ERR, ("  -ResetPipe %08X\n", ntStatus));


    return ntStatus;
}


NTSTATUS MyKeWaitForSingleObject(
    IN  PUSB_DEVICE     Device,
    IN  PVOID          EventWaitingFor,
    IN  OUT PIRP       IrpWaitingFor,
    LONGLONG           timeout100ns
)
/*++

Routine Description:

    Wait with a timeout in a loop
    so we will never hang if we are asked to halt/reset the driver while
    pollingthread is waiting for something.
    If input IRP is not null, also cancel it on timeout.

    NOTE: THIS FUNCTION MUST BE RE-ENTERABLE!

Return Value:

    NT status code

--*/
{

    NTSTATUS status = STATUS_SUCCESS;
    LARGE_INTEGER Timeout;
    BOOLEAN cancelResult;


	if ( timeout100ns ) {   //if a non-zero timeout was passed in, use it

		Timeout.QuadPart = - ( timeout100ns );

	} else {
		Timeout.QuadPart = -10000 * 1000 * 3; // default to 3 second relative delay
	}


	DEBUGMSG( DBG_OUT,(" +MyKeWaitForSingleObject\n "));


	status = KeWaitForSingleObject( //keep this as standard wait
			   EventWaitingFor,
			   Suspended,
			   KernelMode,
			   FALSE,
			   &Timeout);

    if ( IrpWaitingFor && (status != STATUS_SUCCESS))
    {
        // if we get here we timed out and we were passed a PIRP to cancel
        cancelResult = IoCancelIrp( IrpWaitingFor );

        DEBUGCOND( DBG_FUNC, cancelResult,(" MyKeWaitForSingleObject successfully cancelled IRP (%x),cancelResult = %x\n",IrpWaitingFor, cancelResult));
        DEBUGCOND( DBG_ERR, !cancelResult,(" MyKeWaitForSingleObject FAILED to cancel IRP (%x),cancelResult = %x\n",IrpWaitingFor, cancelResult));
    }


	DEBUGCOND( DBG_OUT,( STATUS_TIMEOUT == status ),(" MyKeWaitForSingleObject TIMED OUT\n"));
    DEBUGCOND( DBG_OUT,( STATUS_ALERTED == status ),(" MyKeWaitForSingleObject ALERTED\n"));
    DEBUGCOND( DBG_OUT,( STATUS_USER_APC == status ),(" MyKeWaitForSingleObject USER APC\n"));

    DEBUGMSG( DBG_OUT,(" -MyKeWaitForSingleObject  (%x)\n", status));
    return status;
}


void DumpStatsEverySec( PUSB_DEVICE Device, UINT NumSeconds )
{

#if DBG  //disable unless really need it
	
	static LARGE_INTEGER LastStatTime = { 0 };
	LARGE_INTEGER        Now;
	LARGE_INTEGER		 Elapsed;

	if ( 0 == LastStatTime.QuadPart ) {
		NdisGetCurrentSystemTime( &LastStatTime ); // init
	}

	NdisGetCurrentSystemTime( &Now );

	Elapsed = RtlLargeIntegerSubtract( Now, LastStatTime );

	if ( Elapsed.QuadPart >= ( NumSeconds * USB_100ns_PER_SEC ) ) {

		NdisGetCurrentSystemTime( &LastStatTime );


		DEBUGMSG( DBG_WARN,("\n   ****Dumping statistics every %d seconds\n",NumSeconds));
		DEBUGMSG( DBG_WARN,("    Total  packetsReceived = decimal %d\n",Device->packetsReceived));
		DEBUGMSG( DBG_WARN,("    packetsReceivedDropped = decimal %d\n",Device->packetsReceivedDropped));
		DEBUGMSG( DBG_WARN,("    packetsReceivedOverflow = decimal %d\n",Device->packetsReceivedOverflow));
		DEBUGMSG( DBG_WARN,("    packetsSent = decimal %d\n",Device->packetsSent));
		DEBUGMSG( DBG_WARN,("    packetsSentDropped = decimal %d\n",Device->packetsSentDropped));
		//DEBUGMSG( DBG_WARN,("    packetsHeldByProtocol = decimal %d\n",Device->packetsHeldByProtocol));
//		DEBUGMSG( DBG_WARN,("    MaxPacketsHeldByProtocol = decimal %d\n",Device->MaxPacketsHeldByProtocol));
//		DEBUGMSG( DBG_WARN,("    MaxLenSendList ever attained = decimal %d\n",Device->MaxLenSendList));
//		DEBUGMSG( DBG_WARN,("    NumTimesRcvListMaxedOut = decimal %d\n",Device->NumTimesRcvListMaxedOut));
//		DEBUGMSG( DBG_WARN,("    NumSendPacketsRejected = decimal %d\n",Device->NumSendPacketsRejected));
//		DEBUGMSG( DBG_WARN,("    #Times SendList que > 1 = decimal %d\n",Device->NumTimesLongerThan1));
//	    DEBUGMSG( DBG_WARN,("    Total packet data errors = decimal %d\n",Device->NumDataErrors));
//	    DEBUGMSG( DBG_WARN,("    Total bytes sent  = decimal %d\n",Device->TotalBytesSent ));
//	    DEBUGMSG( DBG_WARN,("    Total bytes received  = decimal %d\n",Device->TotalBytesReceived ));
//		DEBUGMSG( DBG_WARN,("    NumYesQueryMediaBusyOids = decimal %d\n",Device->NumYesQueryMediaBusyOids));
//		DEBUGMSG( DBG_WARN,("    NumNoQueryMediaBusyOids = decimal %d\n",Device->NumNoQueryMediaBusyOids));
//		DEBUGMSG( DBG_WARN,("    NumSetMediaBusyOids = decimal %d\n",Device->NumSetMediaBusyOids));
//		DEBUGMSG( DBG_WARN,("    NumMediaBusyUsbHeaders = decimal %d\n",Device->NumMediaBusyUsbHeaders));
//		DEBUGMSG( DBG_WARN,("    NumMediaNotBusyUsbHeaders = decimal %d\n",Device->NumMediaNotBusyUsbHeaders));
//		DEBUGMSG( DBG_WARN,("    NumMediaBusyIndications = decimal %d\n",Device->NumMediaBusyIndications));
//		DEBUGMSG( DBG_WARN,("    NumPacketsSentRequiringTurnaroundTime = decimal %d\n",Device->NumPacketsSentRequiringTurnaroundTime));
//		DEBUGMSG( DBG_WARN,("    NumPacketsSentNotRequiringTurnaroundTime = decimal %d\n",Device->NumPacketsSentNotRequiringTurnaroundTime));

	}

#endif // DBG
}



/*****************************************************************************
*
*  Function:   PassiveLevelThread
*
*  Synopsis:   Thread running at IRQL PASSIVE_LEVEL.
*
*  Arguments:
*
*  Returns:
*
*  Notes:
*
*  Any work item that can be called must be serialized.
*  i.e. when USBReset is called, NDIS will not make any other
*       requests of the miniport until NdisMResetComplete is called.
*
*****************************************************************************/

VOID
PassiveLevelThread(
            IN OUT PVOID Context
            )
{
    NTSTATUS    ntStatus;
    LARGE_INTEGER Timeout;
	int i;
	PUSB_WORK_ITEM pWorkItem;

    // every parameter used here is passed via Device.
    PUSB_DEVICE    Device = (PUSB_DEVICE) Context;

    DEBUGMSG(DBG_WARN, ("+PassiveLevelThread\n"));  // change to FUNC later?

    KeSetPriorityThread(KeGetCurrentThread(), LOW_REALTIME_PRIORITY);

    Timeout.QuadPart = -10000 * 1000 * 3; // 3 second relative delay

    while ( !Device->fKillPassiveLevelThread )
    {

        //
        // The eventPassiveThread is an auto-clearing event, so
        // we don't need to reset the event.
        //

        ntStatus = KeWaitForSingleObject( //keep this as standard wait
                   &Device->EventPassiveThread,
                   Suspended,
                   KernelMode,
                   FALSE,
                   &Timeout);


        for (i = 0; i < NUM_WORK_ITEMS; i++ )
        {
			if ( Device->WorkItems[i].fInUse ) {

				Device->WorkItems[i].Callback(&(Device->WorkItems[i]));
			}
        }


    } // while !fKill

    DEBUGMSG(DBG_ERR, ("    PassiveLevelThread: HALT\n"));

    Device->hPassiveThread = NULL;

    DEBUGMSG(DBG_WARN, (" -PassiveLevelThread\n")); // change to FUNC later?
    PsTerminateSystemThread(STATUS_SUCCESS);

}



/*****************************************************************************
*
*  Function:   PollingThread
*
*  Synopsis:   Thread running at IRQL PASSIVE_LEVEL.
*
*  Arguments: Device Extension
*
*  Returns:
*
*  Algorithm:  Call USBD for input data;
*
*  History:    dd-mm-yyyy   Author    Comment
* 
*
*  Notes:
*
*  USB reads are by nature 'Blocking', and when in a read, the device looks like it's
*  in a 'stall' condition, so we deliberately time out every second if we've gotten no data
*
*****************************************************************************/

VOID
PollingThread(
    IN PVOID Context
    )
{
    // every parameter used here is passed via device.
    PUSB_DEVICE    device = (PUSB_DEVICE) Context;
    NTSTATUS    Status;
    DEBUGMSG(DBG_WARN, (" +PollingThread\n"));  // change to FUNC later?


    while(!device->fKillPollingThread  )
	{
		NdisMSleep(1024);
        if ( device->fReceiving )

        {

			NTSTATUS ntStatus;

			ntStatus = StartUsbRead(device);

			if ( NULL != device->pCurrentRcvBuf) {	// flag we were successful	
				
				ProcessData(
							device,
							device->pCurrentRcvBuf
							);  // BUGBUG EXPERIMENT?

				device->pCurrentRcvBuf = NULL;
			}



		} // end if

    } // end while

    DEBUGMSG(DBG_WARN, (" -PollingThread\n"));  // change to FUNC later?

    device->hPollingThread = NULL;
    // this thread will finish here
    // if the terminate flag is TRUE
    PsTerminateSystemThread(0);
}


BOOLEAN AllocUsbInfo(
	PUSB_DEVICE device )

{
	UINT siz =  sizeof( USB_INFO);

	device->pUsbInfo = MemAlloc( siz );

	if ( NULL == device->pUsbInfo ) {
		return FALSE;
	}

    NdisZeroMemory((PVOID)device->pUsbInfo, siz);
	return TRUE;

}

VOID FreeUsbInfo(
	PUSB_DEVICE Device )

{
	int i;	
	if ( NULL != Device->pUsbInfo ) 
	{

		//
		// Free device descriptor structure
		//

		if ( ((PUSB_INFO) Device->pUsbInfo)->UsbDeviceDescriptor) {
			MemFree( ((PUSB_INFO) Device->pUsbInfo)->UsbDeviceDescriptor,  sizeof(PUSB_DEVICE_DESCRIPTOR));
		}

		//
		// Free up the UsbInterface structure
		//
		for(i=0;i<3;i++)
		{
			if ( ((PUSB_INFO) Device->pUsbInfo)->UsbInterface[i]) {
				MemFree( ((PUSB_INFO) Device->pUsbInfo)->UsbInterface[i],
					((PUSB_INFO) Device->pUsbInfo)->UsbInterface[i]->Length);
			}
		}	
		// free up the USB config discriptor
		if ( ((PUSB_INFO) Device->pUsbInfo)->UsbConfigurationDescriptor) {
			MemFree( ((PUSB_INFO) Device->pUsbInfo)->UsbConfigurationDescriptor, sizeof(USB_CONFIGURATION_DESCRIPTOR) + 512);
		}

		MemFree((PVOID)Device->pUsbInfo, sizeof(USB_INFO));

	}
}



BOOLEAN
InitWdmStuff(
            IN OUT PUSB_DEVICE Device
			)
{

	BOOLEAN fRes = TRUE;
	ULONGLONG thisContext;  //make ptr arithmetic 64-bit compatible
	PUSB_CONTEXT pCont;
	int i;

    DEBUGMSG(DBG_FUNC, (" +InitWdmStuff\n"));
    //
    // Initialize a notification event for signalling PassiveLevelThread.
    //

    KeInitializeEvent(
                &Device->EventPassiveThread,
                SynchronizationEvent, // auto-clearing event
                FALSE                 // event initially non-signalled
                );


    KeInitializeEvent(
                &Device->EventUrb,
                NotificationEvent,    // non-auto-clearing event
                FALSE                 // event initially non-signalled
                );

    KeInitializeEvent(
                &Device->EventIoCtl,
                NotificationEvent,    // non-auto-clearing event
                FALSE                 // event initially non-signalled
                );

    KeInitializeEvent(
                &Device->EventSetSpeedNow,
                NotificationEvent,    // non-auto-clearing event
                FALSE                  // event initially non-signalled
                );

	((PUSB_INFO) Device->pUsbInfo)->IrpSubmitUrb               = NULL;

	// set urblen to max possible urb size
	Device->UrbLen = sizeof(struct _URB_BULK_OR_INTERRUPT_TRANSFER);
	Device->UrbLen = MAX( Device->UrbLen, sizeof(struct _URB_CONTROL_VENDOR_OR_CLASS_REQUEST));
	Device->UrbLen = MAX( Device->UrbLen, sizeof(struct _URB_CONTROL_DESCRIPTOR_REQUEST ));
	Device->UrbLen = MAX( Device->UrbLen, sizeof(struct _URB_SELECT_CONFIGURATION));

	// allocate our send context structs

	Device->pSendContexts = MemAlloc( NUM_SEND_CONTEXTS * sizeof( USB_CONTEXT ) );

	if ( NULL == Device->pSendContexts ) {

		fRes = FALSE;
		goto done;

	}
	NdisZeroMemory( Device->pSendContexts, NUM_SEND_CONTEXTS * sizeof( USB_CONTEXT ) );

	thisContext = (ULONGLONG) Device->pSendContexts;


	for ( i= 0; i < NUM_SEND_CONTEXTS; i++ ) {

		pCont = (PUSB_CONTEXT) thisContext;

		pCont->DeviceObject = Device;

		pCont->Urb = MemAlloc( Device->UrbLen );

		if ( NULL == pCont->Urb )
		{
			DEBUGMSG(DBG_ERR, ("  InitWdmStuff failed to alloc urb\n"));

			fRes = FALSE;
			goto done;
		}

		NdisZeroMemory( pCont->Urb, Device->UrbLen );

		pCont->fInUse = FALSE;

		pCont->Buffer = MemAlloc( MAX_TOTAL_SIZE_WITH_ALL_HEADERS );

		if ( NULL == pCont->Buffer )
		{
			DEBUGMSG(DBG_ERR, ("  InitWdmStuff failed to alloc info buf\n"));

			fRes = FALSE;
			goto done;
		}

		thisContext +=  sizeof( USB_CONTEXT );

	} // for

done:
    DEBUGMSG(DBG_FUNC, (" -InitWdmStuff\n"));
	
	return fRes;
}


VOID
FreeWdmStuff(
            IN OUT PUSB_DEVICE Device
			)
{
	ULONGLONG thisContext;  //make ptr arithmetic 64-bit compatible
	PUSB_CONTEXT pCont;

	int i;

    DEBUGMSG(DBG_FUNC, (" +FreeWdmStuff\n"));

	thisContext = (ULONGLONG) Device->pSendContexts;

	if ( NULL != Device->pSendContexts ) {


		for ( i= 0; i < NUM_SEND_CONTEXTS; i++ ) {


			pCont = (PUSB_CONTEXT) thisContext;

			if ( NULL != pCont->Urb )
			{
				MemFree( pCont->Urb, Device->UrbLen );
				pCont->Urb = NULL;
			}


			if ( NULL != pCont->Buffer )
			{
				MemFree( pCont->Buffer, MAX_TOTAL_SIZE_WITH_ALL_HEADERS );
				pCont->Buffer = NULL;
				
			}

			thisContext +=  sizeof( USB_CONTEXT );

		} // for



		MemFree( Device->pSendContexts , NUM_SEND_CONTEXTS * sizeof( USB_CONTEXT ) );
		Device->pSendContexts = NULL;

	} //if

    DEBUGMSG(DBG_FUNC, (" -FreeWdmStuff\n"));

}


PVOID
GetFreeContext(
	PUSB_DEVICE Device
	)
{
	ULONGLONG thisContext;  //make ptr arithmetic 64-bit compatible
	PVOID pCont = NULL;

	int i;
#if DBG
	UINT ListLen = 1;
#endif

    DEBUGMSG(DBG_FUNC, (" +GetFreeContext()\n"));

	thisContext = (ULONGLONG) Device->pSendContexts;

	for ( i= 0; i < NUM_SEND_CONTEXTS; i++ ) {


		if( FALSE == ((PUSB_CONTEXT)thisContext)->fInUse ) {

			InterlockedExchange( (PLONG) &((PUSB_CONTEXT)thisContext)->fInUse, TRUE );

			pCont =  (PVOID) thisContext;
			break;
		}

		thisContext +=  sizeof( USB_CONTEXT );


	} // for


    DEBUGMSG(DBG_FUNC, (" -GetFreeContext()\n"));

	return pCont;
}


VOID
SetSpeedCallback(PUSB_WORK_ITEM pWorkItem)
{
    PUSB_DEVICE      device = (PUSB_DEVICE) pWorkItem->pIrDevice;
    NTSTATUS        status = STATUS_SUCCESS;
    NTSTATUS        waitStatus;


    DEBUGMSG(DBG_FUNC, (" +SetSpeedCallback()\n"));

	waitStatus = MyKeWaitForSingleObject(
					   device,
					   &device->EventSetSpeedNow,
					   NULL,  // irp to cancel on timeout
					   0 );

	if  ( !device->fPendingHalt  &&
		  !device->fPendingReset &&
		  (STATUS_SUCCESS == waitStatus) ) {

		SendPacket( device, NULL, 0, CONTEXT_SETSPEED );


	} else {

		DEBUGMSG(DBG_WARN , ("  SetSpeedCallback() DUMPING OUT on TIMEOUT,HALT OR RESET\n"));

		status = STATUS_UNSUCCESSFUL;

        NdisMSetInformationComplete( (NDIS_HANDLE) device->hNdisAdapter, (NDIS_STATUS) status );

        device->LastSetTime.QuadPart = 0;

    	device->fSetpending = FALSE;

	}

    FreeWorkItem(pWorkItem);


    DEBUGMSG(DBG_FUNC, (" -SetSpeedCallback()\n"));

    return;
}



VOID
ProcessDataCallBack( PUSB_WORK_ITEM pWorkItem )
{
	PUSB_DEVICE device;
	PRCV_BUFFER pRecBuf;

	device = (PUSB_DEVICE) pWorkItem->pIrDevice;
	pRecBuf = ( PRCV_BUFFER ) pWorkItem->InfoBuf;

    ProcessData(
                device,
                pRecBuf
                );

	FreeWorkItem( pWorkItem );

}

BOOLEAN
GetRegistryDword(
    IN      PWCHAR    RegPath,
    IN      PWCHAR    ValueName,
    IN OUT  PULONG    Value
    )

/*++

Routine Description:

	Obtain a Dword value from the registry


Arguments:

    RegPath  -- supplies absolute registry path
    ValueName    - Supplies the Value Name.
    Value      - receives the REG_DWORD value.

Return Value:

    TRUE if successfull, FALSE on fail.

--*/

{
    UNICODE_STRING path;
    RTL_QUERY_REGISTRY_TABLE paramTable[2];  //zero'd second table terminates parms
    ULONG lDef = *Value;                     // default
    NTSTATUS status;
    BOOLEAN fres;
	WCHAR wbuf[ MAXIMUM_FILENAME_LENGTH ];

    DEBUGMSG( DBG_FUNC,(" +GetRegistryDword() RegPath = %ws\n   ValueName =%ws\n", RegPath, ValueName));
    path.Length = 0;
    path.MaximumLength = MAXIMUM_FILENAME_LENGTH * sizeof( WCHAR );  // MAXIMUM_FILENAME_LENGTH defined in wdm.h
    path.Buffer = wbuf;


    RtlZeroMemory(path.Buffer, path.MaximumLength);
    RtlMoveMemory(path.Buffer, RegPath, wcslen( RegPath) * sizeof( WCHAR ));

    RtlZeroMemory(paramTable, sizeof(paramTable));

    paramTable[0].Flags = RTL_QUERY_REGISTRY_DIRECT;

    paramTable[0].Name = ValueName;

    paramTable[0].EntryContext = Value;
    paramTable[0].DefaultType = REG_DWORD;
    paramTable[0].DefaultData = &lDef;
    paramTable[0].DefaultLength = sizeof(ULONG);


    status = RtlQueryRegistryValues( RTL_REGISTRY_ABSOLUTE | RTL_REGISTRY_OPTIONAL,
                                    path.Buffer, paramTable, NULL, NULL);

    if (NT_SUCCESS(status)) {
        DEBUGMSG( DBG_FUNC,(" -GetRegistryDWord() SUCCESS, value = decimal %d 0x%x\n", *Value, *Value));
        fres = TRUE;

    } else {

        DEBUGCOND( DBG_ERR, (status == STATUS_INVALID_PARAMETER) ,("GetRegistryDWord() STATUS_INVALID_PARAMETER\n"));

		DEBUGCOND( DBG_ERR, (status == STATUS_OBJECT_NAME_NOT_FOUND) ,("GetRegistryDWord() STATUS_OBJECT_NAME_NOT_FOUND\n"));

        fres = FALSE;

    }

    return fres;
}

BOOLEAN
NoSendsPending(
	PUSB_DEVICE Device
	)
{
	int i;
	PUSB_CONTEXT pCont;
	ULONGLONG thisContext;  //make ptr arithmetic 64-bit compatible
	BOOLEAN fRes = TRUE;

	thisContext = (ULONGLONG) Device->pSendContexts;

	for ( i= 0; i < NUM_SEND_CONTEXTS; i++ ) {


		pCont = (PUSB_CONTEXT) thisContext;

		if ( TRUE == pCont->fInUse )
		{
			fRes = FALSE;
			break;
		}

		thisContext +=  sizeof( USB_CONTEXT );

	} // for


	return fRes;
}



VOID
UsbIncIoCount(
		IN PUSB_DEVICE  Device
		) // we will track count of pending irps
{


	InterlockedIncrement( &Device->PendingIrpCount);

}


VOID
UsbDecIoCount(
		IN PUSB_DEVICE  Device
		) // we will track count of pending irps
{

	InterlockedDecrement( &Device->PendingIrpCount);

}

PVOID
AllocXferUrb ( VOID )
{
 return MemAlloc( sizeof (struct _URB_BULK_OR_INTERRUPT_TRANSFER ));

}

VOID
FreeXferUrb( PVOID Urb )
{
  MemFree( Urb, sizeof (struct _URB_BULK_OR_INTERRUPT_TRANSFER ));

}
