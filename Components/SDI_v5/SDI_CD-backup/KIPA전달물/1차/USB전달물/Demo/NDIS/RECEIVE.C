/*++

Copyright (c) 1999  Microsoft Corporation

Module Name:

    receive.c  | usb NDIS Miniport Driver

Abstract:

    receive logic

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

#define BINARY_COMPATIBLE 1 // for win9x compatibility with ndis.h

#define DOBREAKS    // enable debug breaks

#include <ndis.h>
#include <ntddndis.h>  // defines OID's

#include "debug.h"
#include "common.h"
#include "USBNDIS.h"
#define ETHERNET_HEADER_SIZE            14

/*****************************************************************************
*
*  Function:   ProcessData
*
*  Synopsis:   Copy our data to the appropriate buffer ,process
*              the inbound USB header,  check for overrun,
*              deliver to the protocol
*
*  Arguments:  Device     - a pointer to the current ir device object
*              pRecBuf      - a pointer to a RCV_BUFFER struct
*
*  Returns:    STATUS_SUCCESS
*
*
*****************************************************************************/
NTSTATUS
ProcessData(
            IN PUSB_DEVICE		Device,
            IN PRCV_BUFFER      pRecBuf
            )
{
    UCHAR    inboundHeader;
    NTSTATUS status = STATUS_SUCCESS;


    USB_DUMP( DBG_BUF,( pRecBuf->dataBuf,  pRecBuf->dataLen ) );
	DEBUGMSG(DBG_OUT,("Rx:len(0x%x)\n",pRecBuf->dataLen));

    if ( pRecBuf->dataLen > Device->dongleCaps.dataSize + USB_USB_TOTAL_NON_DATA_SIZE )
    {

        //
        // Reset the buffer for our next read.
        //

        Device->packetsReceivedOverflow++;
        goto done;
    }


    inboundHeader = pRecBuf->dataBuf[0];



    //
    // DeliverBuffer attempts to deliver the current
    // frame . If the ownership
    // of the packet is retained by the protocol, the
    // DeliverBuffer routine gives us a new receive
    // buffer.
    //

    status = DeliverBuffer(
                    Device,
					pRecBuf
                    );


done:
    DEBUGMSG(DBG_FUNC, ("-ProcessData\n"));

    return status;
}



VOID ProcessReturnPacket(PUSB_DEVICE Device,
                         PRCV_BUFFER pReceiveBuffer)
{
    PNDIS_BUFFER pBuffer;

	DEBUGONCE(DBG_FUNC, ("+ProcessReturnPacket\n"));


	NdisUnchainBufferAtFront( (PNDIS_PACKET) pReceiveBuffer->packet, &pBuffer);


	if (pBuffer) {
		NdisFreeBuffer( pBuffer );
	}else DEBUGMSG(DBG_ERROR, ("NdisFreeBuffer error!\n"));


	
    InterlockedExchange( &pReceiveBuffer->dataLen, 0);

    InterlockedExchange( &pReceiveBuffer->fInRcvDpc, FALSE);
    InterlockedExchange( &pReceiveBuffer->fReturnPacketCalled, FALSE);
    InterlockedExchange( (PULONG)&pReceiveBuffer->state, STATE_FREE);

    DEBUGMSG(DBG_FUNC, ("-ProcessReturnPacket\n"));

}

/*****************************************************************************
*
*  Function:   DeliverBuffer
*
*  Synopsis:   Delivers the buffer to the protocol via
*              NdisMIndicateReceivePacket.
*
*  Arguments:  Device - pointer to the current ir device object
*
*  Returns:    STATUS_SUCCESS      - on success
*              STATUS_UNSUCCESSFUL - if packet can't be delivered to protocol
*
*
*
*****************************************************************************/

NTSTATUS
DeliverBuffer(
            IN  PUSB_DEVICE Device,
			IN  PRCV_BUFFER pRecBuf
            )
{
    PNDIS_BUFFER       pBuffer;
    NTSTATUS           status;
	PNDIS_BUFFER	Buffer;
	NDIS_STATUS		Status;

	NdisAllocateBuffer(
		&Status,
		&Buffer,
		Device->hBufferPool,
		pRecBuf->dataBuf , // don't give header to protocol
		pRecBuf->dataLen   // don't give header to protocol
		);
	
	NdisChainBufferAtFront( (PNDIS_PACKET) pRecBuf->packet, Buffer);

    //
    // Fix up some other packet fields.
    //

	//  remember, we stripped the inbound header, so we only account for A and C fields
    NDIS_SET_PACKET_HEADER_SIZE(
                (PNDIS_PACKET) pRecBuf->packet,
                ETHERNET_HEADER_SIZE
                );

	NdisAdjustBufferLength((PNDIS_BUFFER) Buffer,
                    (UINT) pRecBuf->dataLen);
    //
    // Set the packet status to SUCCESS or RESOURCES
    //
//    NDIS_SET_PACKET_STATUS((PNDIS_PACKET) pRecBuf->packet, NDIS_STATUS_SUCCESS); //Added by Eliyas
    
    //
    // Indicate the packet to NDIS.
    //

    InterlockedExchange( &pRecBuf->fInRcvDpc, TRUE);

    NdisMIndicateReceivePacket(
                Device->hNdisAdapter,
                &((PNDIS_PACKET) pRecBuf->packet),
                1
                );


    InterlockedExchange( &pRecBuf->fInRcvDpc, FALSE);

    //
    // Check to see if the packet is pending.
    //

    status = NDIS_GET_PACKET_STATUS((PNDIS_PACKET) pRecBuf->packet);

    if (pRecBuf->fReturnPacketCalled ||
        status == NDIS_STATUS_SUCCESS ||
        status == NDIS_STATUS_RESOURCES)
    {
       ProcessReturnPacket(Device, pRecBuf);
    }


    DEBUGMSG(DBG_FUNC, ("-DeliverBuffer\n"));
    return status;
}

/*****************************************************************************
*
*  Function:   MiniportReturnPacket
*
*  Synopsis:   The protocol returns ownership of a receive packet to
*              the usb device object.
*
*  Arguments:  Context         - a pointer to the current usb device obect.
*              pReturnedPacket - a pointer the packet which the protocol
*                                is returning ownership.
*
*  Returns:    None.
*
*
*
*****************************************************************************/

VOID
MiniportReturnPacket(
            IN NDIS_HANDLE  Context,
            IN PNDIS_PACKET pReturnedPacket
            )
{
    PUSB_DEVICE   device;
    PNDIS_BUFFER pBuffer;
    PRCV_BUFFER  pRecBuffer;
	UINT		 Index;
	BOOLEAN      found = FALSE;


    DEBUGMSG(DBG_FUNC, ("+MiniportReturnPacket\n"));
    //
    // The context is just the pointer to the current ir device object.
    //

    device = CONTEXT_TO_DEV(Context);

    NdisInterlockedIncrement( (PLONG) &device->packetsReceived);

	//
	// Search the queue to find the right packet.
	//

	for(Index=0;Index < NUM_RCV_BUFS;Index ++){

		pRecBuffer = &(device->rcvBufs[Index]);

		if( ((PNDIS_PACKET) pRecBuffer->packet) ==  pReturnedPacket ){

            if (pRecBuffer->fInRcvDpc)
            {
                InterlockedExchange( (PLONG) &pRecBuffer->fReturnPacketCalled, TRUE);;
            }
			else
            {

                ProcessReturnPacket(device, pRecBuffer);

            }
			found = TRUE;
			break;
		}
	}


    //
    // Ensure that the packet was found.
    //

	ASSERT( found );


        DEBUGMSG(DBG_FUNC, ("-MiniportReturnPacket\n"));

        return;
}


PRCV_BUFFER
	GetRcvBuf(
	PUSB_DEVICE Device,
	OUT UINT *pIndex,
	IN rcvBufferState state  // state to set to if found
	)
{
	UINT	Index;
	PRCV_BUFFER pBuf = NULL;

//    DEBUGMSG(DBG_FUNC, (" +GetRcvBuf()\n"));


	for(Index=0;Index < NUM_RCV_BUFS; Index++){

		if( Device->rcvBufs[Index].state == STATE_FREE ){

			InterlockedExchange( (PULONG)&Device->rcvBufs[Index].state, (ULONG)state ); // set to input state

			*pIndex = Index;

			InterlockedExchange(  &Device->RcvBuffersInUse, Index+1);

			pBuf = &(Device->rcvBufs[*pIndex]);

			break;
		}
	}

//    DEBUGMSG(DBG_FUNC, (" -GetRcvBuf()\n"));

	return pBuf;
}

