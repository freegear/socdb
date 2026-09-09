/*++

Copyright (c) 1999  Microsoft Corporation

Module Name:

Abstract:

    Main Module

Environment:

    kernel mode only

Notes:


Revision History:

    Sample template source to show how an NDIS miniport
    driver can interface with a USB device. This is just a 
    sample source and shouldn't be used in production environment
    as is. (Eliyas Yakub - 12/03/99)

--*/

#define BINARY_COMPATIBLE 1 // for win9x compatibility with ndis.h

#define DOBREAKS    // enable debug breaks

#include <ndis.h>
#include <ntddndis.h>  // defines OID's

#include "debug.h"
#include "common.h"
#include "USBNDIS.h"


//
// Mark the DriverEntry function to run once during initialization.
//

NDIS_STATUS DriverEntry(PDRIVER_OBJECT DriverObject, PUNICODE_STRING RegistryPath);
#pragma NDIS_INIT_FUNCTION(DriverEntry)


// Begin, Code....

NDIS_STATUS
DriverEntry(
            IN PDRIVER_OBJECT  DriverObject,
            IN PUNICODE_STRING RegistryPath
            )
{
    NDIS_STATUS                     status = NDIS_STATUS_SUCCESS;
    NDIS_MINIPORT_CHARACTERISTICS characteristics;
    NDIS_HANDLE hWrapper;


    NdisMInitializeWrapper(
                &hWrapper,
                DriverObject,
                RegistryPath,
                NULL
                );


    NdisZeroMemory(
                &characteristics,
                sizeof(NDIS_MINIPORT_CHARACTERISTICS)
                );

    characteristics.MajorNdisVersion        =    (UCHAR)NDIS_MAJOR_VERSION;
    characteristics.MinorNdisVersion        =    (UCHAR)NDIS_MINOR_VERSION;
    characteristics.Reserved                =    0;


    characteristics.HaltHandler             =    MiniportHalt;
    characteristics.InitializeHandler       =    MiniportInitialize;
    characteristics.QueryInformationHandler =    MiniportQueryInformation;
    characteristics.SetInformationHandler   =    MiniportSetInformation;
    characteristics.ResetHandler            =    MiniportReset;

    //
    // For now we will allow NDIS to send only one packet at a time.

    characteristics.SendHandler             =    MiniportSend;
    characteristics.SendPacketsHandler      =    NULL;

    //
    // We don't use NdisMIndicateXxxReceive function, so we will
    // need a ReturnPacketHandler to retrieve our packet resources.
    //

    characteristics.ReturnPacketHandler     =    MiniportReturnPacket;
    characteristics.TransferDataHandler     =    NULL;

    //
    // NDIS never calls the ReconfigureHandler.
    //

    characteristics.ReconfigureHandler      =    NULL;


    //
    // This miniport driver does not handle interrupts.
    //

    characteristics.HandleInterruptHandler  =    NULL;
    characteristics.ISRHandler              =    NULL;
    characteristics.DisableInterruptHandler =    NULL;
    characteristics.EnableInterruptHandler  =    NULL;

    //
    // This miniport does not control a busmaster DMA with
    // NdisMAllocateShareMemoryAsysnc, AllocateCompleteHandler won't be
    // called from NDIS.
    //

    characteristics.AllocateCompleteHandler =    NULL;


    status = NdisMRegisterMiniport(
                hWrapper,
                &characteristics,
                sizeof(NDIS_MINIPORT_CHARACTERISTICS)
                );

    return status;
}



NDIS_STATUS
MiniportInitialize(
            OUT PNDIS_STATUS OpenErrorStatus,
            OUT PUINT        SelectedMediumIndex,
            IN  PNDIS_MEDIUM MediumArray,
            IN  UINT         MediumArraySize,
            IN  NDIS_HANDLE  NdisAdapterHandle,
            IN  NDIS_HANDLE  WrapperConfigurationContext
            )
{
    UINT                i;
    PUSB_DEVICE         device = NULL;
    NDIS_STATUS         status = NDIS_STATUS_SUCCESS;
    NTSTATUS  ntStatus = STATUS_SUCCESS;
    NTSTATUS  tstat = STATUS_SUCCESS;
    PDEVICE_OBJECT PhysicalDeviceObject = NULL;
    PDEVICE_OBJECT NextDeviceObject = NULL;
	BOOLEAN	fRes;
	
    //
    // Search for the irda medium in the medium array.
    //

    for (i = 0; i < MediumArraySize; i++)
    {
        if (MediumArray[i] == NdisMedium802_3)
        {
            break;
        }
    }
    if (i < MediumArraySize) {
        *SelectedMediumIndex = i;
    } else {
        //
        // medium not found.
        //

        status = NDIS_STATUS_UNSUPPORTED_MEDIA;

        goto done;
    }


    NdisMGetDeviceProperty(NdisAdapterHandle,
                           &PhysicalDeviceObject,
                           NULL,
                           &NextDeviceObject,
                           NULL,
                           NULL);

    //
    // Allocate memory to store device information.
    //

    device = MemAlloc(sizeof(USB_DEVICE));

    if (device == NULL)
    {
        status = NDIS_STATUS_RESOURCES;
        goto done;

	}
    NdisZeroMemory((PVOID)device, sizeof(USB_DEVICE));

	fRes = AllocUsbInfo( device );
	if ( !fRes ) {

        status = NDIS_STATUS_RESOURCES;
        goto done;
	} 

    device->pUsbDevObj = NextDeviceObject;
    device->pPhysDevObj = PhysicalDeviceObject;

    //
    // Initialize device object and resources.
    // All the queues and buffer/packets etc. are allocated here.
    //

    status = InitializeDevice(device);

    if (status != NDIS_STATUS_SUCCESS)
    {
        goto done;
    }

    //
    // Record the NdisAdapterHandle.
    //

    device->hNdisAdapter = NdisAdapterHandle;

    //
    // NdisMSetAttributes will associate our adapter handle with the wrapper's
    // adapter handle.  The wrapper will then always use our handle
    // when calling us.  We use a pointer to the device as the context.
    //

    NdisMSetAttributesEx(NdisAdapterHandle,
                         (NDIS_HANDLE)device,
                         0,
                         NDIS_ATTRIBUTE_DESERIALIZE,
                         NdisInterfaceInternal);


    // Now we're ready to do our own startup processing.
    // USB client drivers such as us set up URBs (USB Request Packets) to send requests
    // to the host controller driver (HCD). The URB structure defines a format for all
    // possible commands that can be sent to a USB device.
    // Here, we request the device descriptor and store it,
    // and configure the device.
    // In USB, no special  HW processing is required to 'open'  or 'close' the pipes

    ntStatus = StartDevice(device);

    if ( ntStatus != STATUS_SUCCESS)
    {
        status = NDIS_STATUS_ADAPTER_NOT_FOUND;
        goto done;
    }


    //
    // Create an irp and begin our receives.
    // NOTE: All other receive processing will be done in the read completion
    //       routine  and PollingThread  started therein.
    //
    status = InitializeReceive(device);	//cafe

    if (status != NDIS_STATUS_SUCCESS)
    {
        goto done;
    }


done:

    if (status != NDIS_STATUS_SUCCESS)
    {
        if (device != NULL)
        {
            DeinitializeDevice(device);
            MemFree( device, sizeof(USB_DEVICE));
            FreeUsbInfo( device );
        }
    }

    return status;
}

/*****************************************************************************
*
*  Function:   MiniportHalt
*
*  Synopsis:   Deallocates resources when the NIC is removed and halts the
*              device.
*
*  Arguments:  Context - pointer to the ir device object
*
*  Returns:
*
*  Algorithm:  Mirror image of MiniportInitialize...undoes everything initialize
*              did.
*  Notes:
*
*  This routine runs at IRQL PASSIVE_LEVEL.
*
*  BUGBUG: Could MiniportReset fail and then MiniportHalt be called. If so, we need
*          to chech validity of all the pointers, etc. before trying to
*          deallocate.
*
*****************************************************************************/

VOID
MiniportHalt(
            IN NDIS_HANDLE Context
            )
{
    PUSB_DEVICE device;

    NTSTATUS ntstatus;
	DEBUGMSG( DBG_FUNC,(" +MiniportHalt\n"));
    device = CONTEXT_TO_DEV(Context);


	if ( TRUE == device->fPendingHalt ) {

        goto done;
	}

    //
    // Let the send completion and receive completion routine know that there
    // is a pending reset.
    //

    device->fPendingHalt = TRUE;

    UsbCommonShutdown( device );  //shutdown logic common to halt and reset; see below

	// We had better not have left any pending read, write, or control IRPS hanging out there!

	ASSERT( 0 == device->PendingIrpCount );
	if(0 != device->PendingIrpCount)DEBUGMSG(DBG_ERROR,("device->PendingIrpCount:%d\n",(UINT)device->PendingIrpCount));

	ASSERT( FALSE == device->fSetpending );

	ASSERT( FALSE == device->fQuerypending );

    //
    // Free our own ir device object.
    //

    MemFree(device, sizeof(USB_DEVICE));

done:

	DEBUGMSG( DBG_FUNC,(" -MiniportHalt\n"));
    return;
}




/*****************************************************************************
*
*  Function:   UsbCommonShutdown
*
*  Synopsis:   Deallocates resources when the NIC is removed and halts the
*              device. This is stuff common to USBHalt and USBReset and is called by both
*
*  Arguments:  device USB_DEVICE
*
*  Returns:
*
*  Algorithm:  Mirror image of USBInitialize...undoes everything initialize
*              did.
*
*  Notes:
*
*  This routine runs at IRQL PASSIVE_LEVEL.
*
*
*****************************************************************************/

VOID
UsbCommonShutdown(
            IN PUSB_DEVICE Device
            )
{

    NTSTATUS ntStatus;

   //
    // Sleep 50 milliseconds so pending io might finish normally
    //

    NdisMSleep(50000);    //


    // We want to wait until all pending receives and sends to the
    // device object. We cancel any
    // irps. Wait until sends and receives have stopped.
    //
    CancelPendingIo( Device );



    Device->fKillPassiveLevelThread = TRUE;

    KeSetEvent(&Device->EventPassiveThread, 0, FALSE);

    while (Device->hPassiveThread != NULL)
    {
        //
        // Sleep 50 milliseconds.
        //

        NdisMSleep(50000);
    }


    Device->fKillPollingThread = TRUE;


    //ASSERT( NT_SUCCESS( ntstatus ) );

    while (Device->hPollingThread != NULL)
    {
        //
        // Sleep 50 milliseconds.
        //

        NdisMSleep(50000);
    }

    //
    // Deinitialize our own ir device object.
    //

    DeinitializeDevice(Device);


    Device->fDeviceStarted= FALSE;

    Device->NumDataErrors = 0;  //reset data error count


    return;
}


/*****************************************************************************
*
*  Function:   MiniportReset
*
*  Synopsis:   Resets the drivers software state.
*
*  Arguments:  AddressingReset - return arg. If set to TRUE, NDIS will call
*                                MiniportSetInformation to restore addressing
*                                information to the current values.
*              Context         - pointer to ir device object
*
*  Returns:    NDIS_STATUS_PENDING
*
*
*  Notes:
*
*
*****************************************************************************/

NDIS_STATUS
MiniportReset(
            OUT PBOOLEAN    AddressingReset,
            IN  NDIS_HANDLE MiniportAdapterContext
            )
{
    PUSB_DEVICE  device;
    NDIS_STATUS status = NDIS_STATUS_PENDING;
    NDIS_PHYSICAL_ADDRESS noMaxAddr = NDIS_PHYSICAL_ADDRESS_CONST(-1,-1);
	DEBUGMSG( DBG_FUNC,(" +MiniportReset\n"));


    device = CONTEXT_TO_DEV(MiniportAdapterContext);

	if ( TRUE == device->fPendingReset ) {

		status = NDIS_STATUS_RESET_IN_PROGRESS ;
		goto done;
	}

    //
    // Let the send completion and receive completion routine know that there
    // is a pending reset.
    //

    device->fPendingReset = TRUE;

    *AddressingReset = TRUE;


	 if ( FALSE == ScheduleWorkItem( device,
		 ResetUsbDevice, NULL, 0)){
		  status = NDIS_STATUS_FAILURE;
	 }
 done:
	DEBUGMSG( DBG_FUNC,(" -MiniportReset\n"));
    return status;
}

/*****************************************************************************
*
*  Function:   ResetUsbDevice
*
*  Synopsis: Callback for MiniportReset
*
*  Arguments:
*
*  Returns:
*
*
*  Notes:
*
*  The following elements of the ir device object outlast the reset:
*
*
*      pUsbDevObj
*
*      hNdisAdapter
*
*****************************************************************************/

VOID
ResetUsbDevice(
    IN PUSB_WORK_ITEM  pWorkItem
)

{
    NDIS_STATUS         status = NDIS_STATUS_FAILURE;

	PUSB_DEVICE device = (PUSB_DEVICE) pWorkItem->pIrDevice;

    FreeWorkItem(pWorkItem);

    UsbCommonShutdown( device );  //shutdown logic common to halt and reset; see above

    status = InitializeDevice(device);  //this MUST succeed

    if (status != NDIS_STATUS_SUCCESS)
    {
        status = NDIS_STATUS_FAILURE;

        goto done;
    }

    //
    // Initialize receive loop.
    //

    status = InitializeReceive(device);

    if (status != NDIS_STATUS_SUCCESS)
    {
        status = NDIS_STATUS_FAILURE;

        goto done;
    }

    if (status != STATUS_SUCCESS)
    {
        NdisWriteErrorLogEntry(device->hNdisAdapter,
                               NDIS_ERROR_CODE_ADAPTER_NOT_FOUND,
                               1,
                               status);
        status = NDIS_STATUS_HARD_ERRORS;
        goto done;
    }


done:
    NdisMResetComplete(
            device->hNdisAdapter,
            (NDIS_STATUS)status,
            TRUE
            );

    device->fPendingReset         = FALSE;


}


/* Commented by Eliyas

PNDIS_USB_PACKET_INFO  
GetPacketInfo(
    PNDIS_PACKET packet
)
{
    MEDIA_SPECIFIC_INFORMATION *mediaInfo;
    UINT size;
    NDIS_GET_PACKET_MEDIA_SPECIFIC_INFO(packet, &mediaInfo, &size);
    return (PNDIS_USB_PACKET_INFO)mediaInfo->ClassInformation;
}
*/


VOID
IndicateMediaBusy(
       IN PUSB_DEVICE Device
    )
{

    NdisMIndicateStatus(
       Device->hNdisAdapter,
       NDIS_STATUS_MEDIA_BUSY,
       NULL,
       0
       );

    NdisMIndicateStatusComplete(
       Device->hNdisAdapter,
       );

}

/*****************************************************************************
*
*  Function:   MiniportSend
*
*  Synopsis:   Send a packet to the USB driver and add the sent irp and io context to
*              To the pending send queue; this que is really just needed for possible later error cancellation
*
*
*  Arguments:  MiniportAdapterContext - pointer to current ir device object
*              pPacketToSend          - pointer to packet to send
*              Flags                  - any flags set by protocol
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
*	Notes: This routine delegates all the real work to SendPacket in rwir.c
*
*
*****************************************************************************/

NDIS_STATUS
MiniportSend(
           IN NDIS_HANDLE  MiniportAdapterContext,
           IN PNDIS_PACKET pPacketToSend,
           IN UINT         Flags
           )
{
	NDIS_STATUS status;
	//PNDIS_USB_PACKET_INFO packetInfo; Eliyas
	PUSB_DEVICE device = ( PUSB_DEVICE ) MiniportAdapterContext;

    DEBUGMSG(DBG_FUNC|DBG_PNP, ("+MiniportSend\n"));

/*
	if (  device->RcvBuffersInUse >= (NUM_RCV_BUFS -2)  ) {

		//
		// fail the packet until we're caught up

		status = NDIS_STATUS_FAILURE;
		goto done;
	}
*/
	if( TRUE == device->fPendingWriteClearStall ) {

		status = NDIS_STATUS_FAILURE;
		goto done;
	}

	//packetInfo = GetPacketInfo(pPacketToSend); Eliyas
	NdisStallExecution(1000);

	status =  ( NDIS_STATUS ) SendPacket(
				device,
				pPacketToSend,
				Flags,
				CONTEXT_NDIS_PACKET
				);
done:

	return status;
}



NDIS_STATUS
InitializeDevice(
    IN OUT PUSB_DEVICE Device)
{
    int         i;
    NDIS_STATUS status = NDIS_STATUS_SUCCESS;

    DEBUGMSG(DBG_FUNC|DBG_PNP, ("+InitializeDevice\n"));

    ASSERT(Device != NULL);

    //
    // Init statistical info. 
    // We need to do this cause reset wont free and realloc Device!
    //

    Device->packetsReceived         = 0;
    Device->packetsReceivedDropped  = 0;
    Device->packetsReceivedOverflow = 0;
    Device->packetsSent             = 0;
    Device->packetsSentDropped      = 0;
	Device->SendContextsInUse       = 0;
	Device->RcvBuffersInUse         = 0;



    Device->fDeviceStarted          = FALSE;
    Device->fGotFilterIndication    = FALSE;
    Device->fPendingHalt            = FALSE;
    Device->fPendingReset           = FALSE;
    Device->fPendingReadClearStall  = FALSE;
    Device->fPendingWriteClearStall = FALSE;

    Device->fKillPollingThread      = FALSE;

	Device->dongleCaps.turnAroundTime_usec = 1000;
	Device->dongleCaps.dataSize=1600;	//cafe add

    Device->fKillPassiveLevelThread = FALSE;

    Device->LastQueryTime.QuadPart   = 0;
    Device->LastSetTime.QuadPart     = 0;
	Device->PendingIrpCount          = 0;

	Device->fQuerypending            = FALSE;
	Device->fSetpending              = FALSE;

    InterlockedExchange( &Device->fMediaBusy, FALSE ); 
    InterlockedExchange( &Device->fIndicatedMediaBusy, FALSE ); 

    Device->fSetSpeedAfterCurrentSendPacket = FALSE;
	Device->LastPacketAtOldSpeed  = NULL;
	Device->pCurrentRcvBuf = NULL;

    Device->fReceiving            = FALSE;



   //
    // Initialize the queues.
    //

 
	if ( TRUE != InitWdmStuff( Device ) ){

        goto done;
	}


    //
    // Allocate the NDIS packet and NDIS buffer pools
    // for this device's RECEIVE buffer queue.
    // Our receive packets must only contain one buffer apiece,
    // so #buffers == #packets.
    //

    NdisAllocatePacketPool(
                &status,                    // return status
                &Device->hPacketPool,     // handle to the packet pool
                NUM_RCV_BUFS,               // number of packet descriptors
                16                          // number of bytes reserved for
                );                          //   ProtocolReserved field

    if (status != NDIS_STATUS_SUCCESS)
    {
 
        goto done;
    }

    NdisAllocateBufferPool(
                &status,               // return status
                &Device->hBufferPool,// handle to the buffer pool
                NUM_RCV_BUFS           // number of buffer descriptors
                );

    if (status != NDIS_STATUS_SUCCESS)
    {
        goto done;
    }


    for (i = 0; i < NUM_WORK_ITEMS; i++)
    {
		PUSB_WORK_ITEM pWorkItem;
			
		pWorkItem = &(Device->WorkItems[i]);

	    pWorkItem->pIrDevice    = Device;
        pWorkItem->InfoBuf      = NULL;
        pWorkItem->InfoBufLen   = 0;
        pWorkItem->fInUse       = FALSE;
        pWorkItem->Callback     = NULL;
	}

    //
    //  Initialize each of the RECEIVE objects for this device.
    //

    for (i = 0; i < NUM_RCV_BUFS; i++)
    {
        PNDIS_BUFFER pBuffer = NULL;
        PRCV_BUFFER  pReceivBuffer = &Device->rcvBufs[i];

        //
        // Allocate a data buffer
        //
        //

        pReceivBuffer->dataBuf = MemAlloc( MAX_TOTAL_SIZE_WITH_ALL_HEADERS ); 

		pReceivBuffer->Urb = AllocXferUrb();


        if (pReceivBuffer->dataBuf == NULL)
        {
            status = NDIS_STATUS_RESOURCES;

            goto done;
        }

        NdisZeroMemory(
                    pReceivBuffer->dataBuf,
                    MAX_TOTAL_SIZE_WITH_ALL_HEADERS
                    );

		pReceivBuffer->device = Device;

        pReceivBuffer->dataLen = 0;

        pReceivBuffer->state = STATE_FREE;

 		KeInitializeEvent(
                &pReceivBuffer->Event, NotificationEvent,
                FALSE                 // event initially non-signalled
                );

        //
        //  Allocate the NDIS_PACKET.
        //


        NdisAllocatePacket(
                    &status,              // return status
                     &((PNDIS_PACKET)pReceivBuffer->packet),     // return pointer to allocated descriptor
                    Device->hPacketPool // handle to packet pool
                    );

        if (status != NDIS_STATUS_SUCCESS)
        {
            goto done;
        }


    }


done:

    //
    // If we didn't complete the init successfully, then we should clean
    // up what we did allocate.
    //

    if (status != NDIS_STATUS_SUCCESS)
    {
        DeinitializeDevice(Device);
    }
    else
    {
    }

    return status;
}




/*****************************************************************************
*
*  Function:   DeinitializeDevice
*
*  Synopsis:   deallocate the resources of the ir device object
*
*  Arguments:  Device - the ir device object to close
*
*  Returns:    none
*
*
*  Notes:
*
*  Called for shutdown and reset.
*  Don't clear hNdisAdapter, since we might just be resetting.
*  This function should be called with device lock held.
*
*****************************************************************************/

NDIS_STATUS
DeinitializeDevice(
            IN OUT PUSB_DEVICE Device
            )
{
    UINT        i;
    NDIS_STATUS status;
    NTSTATUS ntstatus;

    status = NDIS_STATUS_SUCCESS;

    Device->linkSpeedInfo = NULL;

    //
    // Free all resources for the RECEIVE buffer queue.
    //

    for (i = 0; i < NUM_RCV_BUFS; i++)
    {
        PNDIS_BUFFER pBuffer = NULL;
        PRCV_BUFFER  pRcvBuf = &Device->rcvBufs[i];

        if (pRcvBuf->packet != NULL)
        {
            NdisFreePacket((PNDIS_PACKET) pRcvBuf->packet);
            pRcvBuf->packet = NULL;
        }

        if (pRcvBuf->dataBuf != NULL)
        {
            MemFree(pRcvBuf->dataBuf, MAX_TOTAL_SIZE_WITH_ALL_HEADERS ); 
            pRcvBuf->dataBuf = NULL;
        }

        if (pRcvBuf->Urb != NULL)
        {
 			FreeXferUrb( pRcvBuf->Urb );
			pRcvBuf->Urb = NULL;
		}


        pRcvBuf->dataLen = 0;

    }

    //
    // Free the packet and buffer pool handles for this device.
    //

    if (Device->hPacketPool)
    {
        NdisFreePacketPool(Device->hPacketPool);
        Device->hPacketPool = NULL;
    }

    if (Device->hBufferPool)
    {
        NdisFreeBufferPool(Device->hBufferPool);
        Device->hBufferPool = NULL;
    }



    if ( Device->fDeviceStarted )
    {

        ntstatus = StopDevice( Device ); 
    }

    InterlockedExchange( &Device->fMediaBusy, FALSE ); 
    InterlockedExchange( &Device->fIndicatedMediaBusy, FALSE ); 

	FreeWdmStuff( Device );

    return status;
}



/*****************************************************************************
*
*  Function:   MemAlloc
*
*  Synopsis:   allocates a block of memory using NdisAllocateMemory
*
*  Arguments:  size - size of the block to allocate
*
*  Returns:    a pointer to the allocated block of memory
*
*
*****************************************************************************/


PVOID
MemAlloc(UINT size)
{
    PVOID                 memptr;
    NDIS_PHYSICAL_ADDRESS noMaxAddr = NDIS_PHYSICAL_ADDRESS_CONST(-1,-1);
    NDIS_STATUS           status;


    status = NdisAllocateMemoryWithTag(&memptr, size, USB_TAG);

    if (status != NDIS_STATUS_SUCCESS)
    {
        memptr = NULL;
    }


    return memptr;
}

/*****************************************************************************
*
*  Function:   MemFree
*
*  Synopsis:   frees a block of memory allocated by MemAlloc
*
*  Arguments:  memptr - memory to free
*              size   - size of the block to free
*
*
*****************************************************************************/

VOID
MemFree(
            PVOID memptr,
            UINT size
            )
{

    NdisFreeMemory(memptr, size, 0);

}



