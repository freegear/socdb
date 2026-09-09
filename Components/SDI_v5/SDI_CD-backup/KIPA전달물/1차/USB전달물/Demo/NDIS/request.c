/*++

Copyright (c) 1999  Microsoft Corporation

Module Name:

    request.c  | usb NDIS Miniport Driver

Abstract:

    Query and Set information handlers

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
//
//  These are the OIDs we support 
//



UINT supportedOIDs[] =
{
    //
    // General required OIDs.
    //

    OID_GEN_SUPPORTED_LIST,
    OID_GEN_HARDWARE_STATUS,
    OID_GEN_MEDIA_SUPPORTED,
    OID_GEN_MEDIA_IN_USE,
    OID_GEN_MAXIMUM_LOOKAHEAD,
    OID_GEN_MAXIMUM_FRAME_SIZE,
    OID_GEN_LINK_SPEED,
    OID_GEN_TRANSMIT_BUFFER_SPACE,
    OID_GEN_RECEIVE_BUFFER_SPACE,
    OID_GEN_TRANSMIT_BLOCK_SIZE,
    OID_GEN_RECEIVE_BLOCK_SIZE,
    OID_GEN_VENDOR_ID,
    OID_GEN_VENDOR_DESCRIPTION,
    OID_GEN_CURRENT_PACKET_FILTER,
    OID_GEN_CURRENT_LOOKAHEAD,
    OID_GEN_DRIVER_VERSION,
    OID_GEN_MAXIMUM_TOTAL_SIZE,
    OID_GEN_PROTOCOL_OPTIONS,
    OID_GEN_MAC_OPTIONS,
    OID_GEN_MEDIA_CONNECT_STATUS,
    OID_GEN_MAXIMUM_SEND_PACKETS,
    OID_GEN_VENDOR_DRIVER_VERSION,
	//	SetInformation OID
	OID_802_3_MULTICAST_LIST,

    //
    // Required statistical OIDs.
    //

    OID_GEN_XMIT_OK,
    OID_GEN_RCV_OK,
    OID_GEN_XMIT_ERROR,
    OID_GEN_RCV_ERROR,
    OID_GEN_RCV_NO_BUFFER,


    OID_PNP_CAPABILITIES,/*,
    OID_PNP_SET_POWER,  
    OID_PNP_QUERY_POWER,
    OID_PNP_ENABLE_WAKE_UP
    OID_PNP_ADD_WAKE_UP_PATTERN		
    OID_PNP_REMOVE_WAKE_UP_PATTERN	
    OID_PNP_WAKE_UP_PATTERN_LIST	
    OID_PNP_WAKE_UP_OK		
    OID_PNP_WAKE_UP_ERROR	*/
	OID_802_3_MAXIMUM_LIST_SIZE,
	OID_802_3_CURRENT_ADDRESS,
	OID_GEN_SUPPORTED_GUIDS,
	OID_CUSTOM_DRIVER_SET
}; 



//
//	PnP and PM OIDs
//

#define	OID_PNP_CAPABILITIES					0xFD010100
#define	OID_PNP_SET_POWER						0xFD010101
#define	OID_PNP_QUERY_POWER						0xFD010102
#define OID_PNP_ADD_WAKE_UP_PATTERN				0xFD010103
#define OID_PNP_REMOVE_WAKE_UP_PATTERN			0xFD010104
#define	OID_PNP_WAKE_UP_PATTERN_LIST			0xFD010105
#define	OID_PNP_ENABLE_WAKE_UP					0xFD010106

//
//	PnP/PM Statistics (Optional).
//
#define	OID_PNP_WAKE_UP_OK						0xFD020200
#define	OID_PNP_WAKE_UP_ERROR					0xFD020201







/*****************************************************************************
*
*  Function:   MiniportQueryInformation
*
*  Synopsis:   Queries the capabilities and status of the miniport driver.
*
*  Arguments:  MiniportAdapterContext  - miniport context area (PUSB_DEVICE)
*              Oid                     - system defined OID_Xxx
*              InformationBuffer       - where to return Oid specific info
*              InformationBufferLength - specifies size of InformationBuffer
*              BytesWritten            - bytes written to InformationBuffer
*              BytesNeeded             - addition bytes required if
*                                        InformationBufferLength is less than
*                                        what the Oid requires to write
*
*  Returns:    NDIS_STATUS_SUCCESS       - success
*              NDIS_STATUS_PENDING       - will complete asynchronously and
*                                          call NdisMQueryInformationComplete
*              NDIS_STATUS_INVALID_OID   - don't recognize the Oid
*              NDIS_STATUS_INVALID_LENGTH- InformationBufferLength does not
*                                          match length for the Oid
*              NDIS_STATUS_NOT_ACCEPTED  - failure
*              NDIS_STATUS_NOT_SUPPORTED - do not support an optional Oid
*              NDIS_STATUS_RESOURCES     - failed allocation of resources
*
*  Notes:
*       See list of Supported OIDs at the top of this module in the supportedOIDs[] array
*
*
*****************************************************************************/

NDIS_STATUS
MiniportQueryInformation(
            IN  NDIS_HANDLE MiniportAdapterContext,
            IN  NDIS_OID    Oid,
            IN  PVOID       InformationBuffer,
            IN  ULONG       InformationBufferLength,
            OUT PULONG      BytesWritten,
            OUT PULONG      BytesNeeded
            )
{
    PUSB_DEVICE      device;
    NDIS_STATUS     status;
    UINT            speeds;
    UINT            i;
    UINT            infoSizeNeeded;
    UINT            *infoPtr;
    ULONG           OidCategory = Oid & 0xFF000000;
	BOOLEAN			fBusy;

    static char vendorDesc[] = "Usb Infrared Port";

    // WMI support
    // check out the e100b.mof file for examples of how the below
    // maps into a .mof file for external advertisement of GUIDs
#define NUM_CUSTOM_GUIDS 1

    static const NDIS_GUID GuidList[NUM_CUSTOM_GUIDS] =
    {	{  {0xF4A80276,0x23B7,0x11d1,{0x9E,0xD9,0x00,0xA0,0xC9,0x01,0x00,0x57}},
//            E100BExampleSetUINT_OIDGuid,
            OID_CUSTOM_DRIVER_SET,
            sizeof(ULONG),
            (fNDIS_GUID_TO_OID)
		}
	};

    DEBUGMSG(DBG_FUNC, ("+MiniportQueryInformation\n"));

    device = CONTEXT_TO_DEV(MiniportAdapterContext);

	ASSERT( NULL != device ); 
	ASSERT( NULL != BytesWritten );
	ASSERT( NULL != BytesNeeded );

    status = NDIS_STATUS_SUCCESS;

    NdisGetCurrentSystemTime( &device->LastQueryTime ); //used by check for hang handler
	device->fQuerypending = TRUE;

	//DUMP_STATS_SEC( device, 180 ); // dump statistics every n seconds if debugging
/*
	if ( NULL == InformationBuffer ) { // Should be impossible but it happened on an MP system!

        DEBUGMSG(DBG_ERR, ("    MiniportQueryInformation() NULL info buffer passed!,InformationBufferLength = dec %d\n",InformationBufferLength));
		status = NDIS_STATUS_NOT_ACCEPTED;
        *BytesNeeded =0;
        *BytesWritten = 0;
        goto done;
 
	}
*/
	//
    // Figure out buffer size needed.
    // Most OIDs just return a single UINT, but there are exceptions.
    //

    switch (Oid)
    {
        case OID_GEN_SUPPORTED_LIST:
            infoSizeNeeded = sizeof(supportedOIDs);
            break;

        case OID_PNP_CAPABILITIES:
            infoSizeNeeded = sizeof(NDIS_PNP_CAPABILITIES);
            break;

        case OID_GEN_DRIVER_VERSION:
            infoSizeNeeded = sizeof(USHORT);
            break;

        case OID_GEN_VENDOR_DESCRIPTION:
            infoSizeNeeded = sizeof(vendorDesc);
            break;

		case OID_802_3_CURRENT_ADDRESS:
            infoSizeNeeded = ETH_LENGTH_OF_ADDRESS;
			break;

		case OID_GEN_SUPPORTED_GUIDS:
            infoSizeNeeded = sizeof(GuidList);
			break;

        default:
            infoSizeNeeded = sizeof(UINT);
            break;
    }

    //
    // If the protocol provided a large enough buffer, we can go ahead
    // and complete the query.
    //
    DEBUGMSG(DBG_FUNC, ("    MiniportQueryInformation(%d=0x%x)\n", Oid, Oid));

    if (InformationBufferLength >= infoSizeNeeded)
    {
        //
        // Set default results.
        //

        *BytesWritten = infoSizeNeeded;
        *BytesNeeded = 0;

        switch (Oid)
        {
            //
            // Generic OIDs.
            //

            case OID_GEN_SUPPORTED_LIST:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_SUPPORTED_LIST)\n"));
/*
                Specifies an array of OIDs for objects that the underlying
                 driver or its device supports. Objects include general, media-specific,
                 and implementation-specific objects.

                The underlying driver should order the OID list it returns 
                in increasing numeric order. NDIS forwards a subset of the returned 
                list to protocols that make this query. That is, NDIS filters
                any supported statistics OIDs out of the list since protocols
                never make statistics queries subsequentlly. 

*/
                NdisMoveMemory(
                            InformationBuffer,
                            (PVOID)supportedOIDs,
                            sizeof(supportedOIDs)
                            );

                break;

            case OID_GEN_HARDWARE_STATUS:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_HARDWARE_STATUS)\n"));

                //
                // If we can be called with a context, then we are
                // initialized and ready.
                //

                *(UINT *)InformationBuffer = NdisHardwareStatusReady;

                break;

            case OID_GEN_MEDIA_SUPPORTED:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_MEDIA_SUPPORTED)\n"));

                *(UINT *)InformationBuffer = NdisMedium802_3;

                break;

            case OID_GEN_MEDIA_IN_USE:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_MEDIA_IN_USE)\n"));

                *(UINT *)InformationBuffer = NdisMedium802_3;

                break;

            case OID_GEN_TRANSMIT_BUFFER_SPACE: 
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_TRANSMIT_BUFFER_SPACE)\n"));
/*
                The amount of memory, in bytes, on the device available 
                for buffering transmit data.  

*/
                *(UINT *)InformationBuffer = MAX_TOTAL_SIZE_WITH_ALL_HEADERS;

                break;

            case OID_GEN_RECEIVE_BUFFER_SPACE: 
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_RECEIVE_BUFFER_SPACE)\n"));
/*
                The amount of memory on the device available 
                for buffering receive data.
*/
                
                *(UINT *)InformationBuffer = MAX_TOTAL_SIZE_WITH_ALL_HEADERS;

                break;

            case OID_GEN_TRANSMIT_BLOCK_SIZE: 
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_TRANSMIT_BLOCK_SIZE)\n"));
/*

                The minimum number of bytes that a single net packet 
                occupies in the transmit buffer space of the device.
                For example, on some devices the transmit space is 
                divided into 256-byte pieces so such a device's 
                transmit block size would be 256. To calculate 
                the total transmit buffer space on such a device, 
                its driver multiplies the number of transmit 
                buffers on the device by its transmit block size.

                For other devices, the transmit block size is
                identical to its maximum packet size. 

*/
                 *(UINT *)InformationBuffer = device->dongleCaps.dataSize +
                    USB_USB_TOTAL_NON_DATA_SIZE;

                break;

            case OID_GEN_RECEIVE_BLOCK_SIZE: 
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_RECEIVE_BLOCK_SIZE)\n"));
/*
                The amount of storage, in bytes, that a single packet
                occupies in the receive buffer space of the device

*/
                 *(UINT *)InformationBuffer = device->dongleCaps.dataSize +
                    USB_USB_TOTAL_NON_DATA_SIZE;
 
                break;

            case OID_GEN_MAXIMUM_LOOKAHEAD: 
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_MAXIMUM_LOOKAHEAD)\n"));
/*
                The maximum number of bytes the device can always provide as lookahead data.
                If the underlying driver supports multipacket receive indications,
                bound protocols are given full net packets on every indication. 
                Consequently, this value is identical to that 
                returned for OID_GEN_RECEIVE_BLOCK_SIZE. 

*/
                 *(UINT *)InformationBuffer =  device->dongleCaps.dataSize +
                    USB_USB_TOTAL_NON_DATA_SIZE;

                break;

            case OID_GEN_CURRENT_LOOKAHEAD: 
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_CURRENT_LOOKAHEAD)\n"));
/*
                The number of bytes of received packet data, 
                excluding the header, that will be indicated 
                to the protocol driver. For a query, 
                NDIS returns the largest lookahead size from 
                among all the bindings. A protocol driver can 
                set a suggested value for the number of bytes 
                to be used in its binding; however, 
                the underlying device driver is never required 
                to limit its indications to the value set. 

                If the underlying driver supports multipacket
                receive indications, bound protocols are given
                full net packets on every indication. Consequently,
                this value is identical to that returned for OID_GEN_RECEIVE_BLOCK_SIZE. 

*/

                 *(UINT *)InformationBuffer = device->dongleCaps.dataSize +
                    USB_USB_TOTAL_NON_DATA_SIZE;

                break;

            case OID_GEN_MAXIMUM_FRAME_SIZE:
                DEBUGMSG(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_MAXIMUM_FRAME_SIZE)\n"));
/*
                The maximum network packet size in bytes 
                the device supports, not including a header. 
                For a binding emulating another medium type, 
                the device driver must define the maximum frame 
                size in such a way that it will not transform 
                a protocol-supplied net packet of this size 
                to a net packet too large for the true network medium.

*/
                *(UINT *)InformationBuffer = device->dongleCaps.dataSize;

                break;

            case OID_GEN_MAXIMUM_TOTAL_SIZE:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_MAXIMUM_TOTAL_SIZE)\n"));

/*
                The maximum total packet length, in bytes, 
                the device supports, including the header. 
                This value is medium-dependent. The returned 
                length specifies the largest packet a protocol 
                driver can pass to NdisSend or NdisSendPackets.

                For a binding emulating another media type,
                the device driver must define the maximum total 
                packet length in such a way that it will not 
                transform a protocol-supplied net packet of 
                this size to a net packet too large for the true network medium.

*/
                *(UINT *)InformationBuffer = device->dongleCaps.dataSize  +
                    USB_USB_TOTAL_NON_DATA_SIZE;

                break;

            case OID_GEN_VENDOR_ID:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_VENDOR_ID)\n"));

                // we get this from our config descriptor
                *(UINT *)InformationBuffer = device->IdVendor;

                break;

            case OID_GEN_VENDOR_DESCRIPTION:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_VENDOR_DESCRIPTION)\n"));

                // BUGBUG? should we ask for class-specific string?
                NdisMoveMemory(
                            InformationBuffer,
                            (PVOID)vendorDesc,
                            sizeof(vendorDesc)
                            );

                break;

            case OID_GEN_LINK_SPEED:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_LINK_SPEED)\n"));

                //
                // Return MAXIMUM POSSIBLE speed for this device in units
                // of 100 bits/sec.
                //

                *(UINT *)InformationBuffer = 100000;

                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_LINK_SPEED)  %d\n",*(UINT *)InformationBuffer));


                break;



            case OID_GEN_CURRENT_PACKET_FILTER:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_CURRENT_PACKET_FILTER)\n"));

                *(UINT *)InformationBuffer = NDIS_PACKET_TYPE_PROMISCUOUS;

                break;


            case OID_GEN_DRIVER_VERSION:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_DRIVER_VERSION)\n"));

                *(USHORT *)InformationBuffer = ((NDIS_MAJOR_VERSION << 8) |
                                                 NDIS_MINOR_VERSION);

                break;


            case OID_GEN_PROTOCOL_OPTIONS:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_PROTOCOL_OPTIONS)\n"));

                DEBUGMSG(DBG_ERR, ("This is a set-only OID\n"));
                *BytesWritten = 0;
                status = NDIS_STATUS_NOT_SUPPORTED;

                break;

            case OID_GEN_MAC_OPTIONS:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_MAC_OPTIONS)\n"));

                *(UINT *)InformationBuffer =   
                    NDIS_MAC_OPTION_COPY_LOOKAHEAD_DATA |
                    NDIS_MAC_OPTION_TRANSFERS_NOT_PEND;  

                break;

            case OID_GEN_MEDIA_CONNECT_STATUS:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_MEDIA_CONNECT_STATUS)\n"));

                //
                // Since we are not physically connected to a LAN, we
                // cannot determine whether or not we are connected;
                // so always indicate that we are.
                //

                *(UINT *)InformationBuffer = NdisMediaStateConnected;

                break;

            case OID_GEN_MAXIMUM_SEND_PACKETS:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_MAXIMUM_SEND_PACKETS)\n"));

                //The maximum number of send packets the
                //MiniportSendPackets function can accept. 
                //If a larger packet array is given to MiniportSendPackets, 
                //it will return some packets in the array to NDIS for resubmission later. 
                //If the underlying driver has only a MiniportSend function, it should return one
                //for this query. This is our case 

                *(UINT *)InformationBuffer = 1;

                break;

            case OID_GEN_VENDOR_DRIVER_VERSION:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_VENDOR_DRIVER_VERSION)\n"));

                *(UINT *)InformationBuffer =
                                            ((NDIS_MAJOR_VERSION << 16) |
                                              NDIS_MINOR_VERSION);

                break;

            //
            // Required statistical OIDs.
            //

            case OID_GEN_XMIT_OK:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_XMIT_OK)\n"));

                *(UINT *)InformationBuffer =
                                (UINT)device->packetsSent;

                break;

            case OID_GEN_RCV_OK:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_RCV_OK)\n"));

                *(UINT *)InformationBuffer =
                                (UINT)device->packetsReceived;

                break;

            case OID_GEN_XMIT_ERROR:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_XMIT_ERROR)\n"));

                *(UINT *)InformationBuffer =
                                (UINT)device->packetsSentDropped;

                break;

            case OID_GEN_RCV_ERROR:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_RCV_ERROR)\n"));

                *(UINT *)InformationBuffer =
                                (UINT)device->packetsReceivedDropped;

                break;

            case OID_GEN_RCV_NO_BUFFER:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_RCV_NO_BUFFER)\n"));

                *(UINT *)InformationBuffer =
                                (UINT)device->packetsReceivedOverflow;

                break;


            // PNP OIDs
            case OID_PNP_CAPABILITIES:
                DEBUGONCE(DBG_FUNC, ("USB: OID_PNP_CAPABILITIES OID %x BufLen:%d\n", Oid, InformationBufferLength));
/*
                NdisZeroMemory( // say all pnp caps are unspecified
                            InformationBuffer,
                            sizeof(NDIS_PNP_CAPABILITIES)
                            );
*/
                status = NDIS_STATUS_NOT_SUPPORTED; 
                break;
			
			// cafe add.
            case OID_802_3_MAXIMUM_LIST_SIZE:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_802_3_MAXIMUM_LIST_SIZE)\n"));

                *(UINT *)InformationBuffer =  32;

                break;

			case OID_802_3_CURRENT_ADDRESS:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_802_3_CURRENT_ADDRESS)\n"));
                NdisMoveMemory(
                            InformationBuffer,
                            MacAddr,
                            ETH_LENGTH_OF_ADDRESS
                            );
				break;
			case OID_GEN_SUPPORTED_GUIDS:
                DEBUGONCE(DBG_FUNC, ("    MiniportQueryInformation(OID_GEN_SUPPORTED_GUIDS)\n"));
                NdisMoveMemory(
                            InformationBuffer,
                            GuidList,
                            sizeof(GuidList)
                            );

				break;
		    case OID_CUSTOM_DRIVER_SET:
                *(UINT *)InformationBuffer =  32;
				 break;

            default:
                DEBUGMSG(DBG_WARN, ("    MiniportQueryInformation(%d=0x%x), invalid OID\n", Oid, Oid));

                status = NDIS_STATUS_NOT_SUPPORTED; 

                break;
        }
    }
    else
    {
        *BytesNeeded = infoSizeNeeded - InformationBufferLength;
        *BytesWritten = 0;
        status = NDIS_STATUS_INVALID_LENGTH;
    }

//done:

    if (  NDIS_STATUS_PENDING != status  ) {

        // zero-out the time so check for hang handler knows nothing pending

        device->LastQueryTime.QuadPart = 0;
		device->fQuerypending            = FALSE;
    }

    DEBUGMSG(DBG_FUNC, ("-MiniportQueryInformation\n"));

    return status;
}

/*****************************************************************************
*
*  Function:   MiniportSetInformation
*
*  Synopsis:   MiniportSetInformation allows other layers of the network software
*              (e.g., a transport driver) to control the miniport driver
*              by changing information that the miniport driver maintains
*              in its OIDs, such as the packet filters or multicast addresses.
*
*  Arguments:  MiniportAdapterContext  - miniport context area (PUSB_DEVICE)
*              Oid                     - system defined OID_Xxx
*              InformationBuffer       - buffer containing data for the set Oid
*              InformationBufferLength - specifies size of InformationBuffer
*              BytesRead               - bytes read from InformationBuffer
*              BytesNeeded             - addition bytes required if
*                                        InformationBufferLength is less than
*                                        what the Oid requires to read
*
*  Returns:    NDIS_STATUS_SUCCESS       - success
*              NDIS_STATUS_PENDING       - will complete asynchronously and
*                                          call NdisMSetInformationComplete
*              NDIS_STATUS_INVALID_OID   - don't recognize the Oid
*              NDIS_STATUS_INVALID_LENGTH- InformationBufferLength does not
*                                          match length for the Oid
*              NDIS_STATUS_INVALID_DATA  - supplied data was invalid for the
*                                          given Oid
*              NDIS_STATUS_NOT_ACCEPTED  - failure
*              NDIS_STATUS_NOT_SUPPORTED - do not support an optional Oid
*              NDIS_STATUS_RESOURCES     - failed allocation of resources
*
*  Notes:
*
*
*****************************************************************************/

NDIS_STATUS
MiniportSetInformation(
            IN  NDIS_HANDLE MiniportAdapterContext,
            IN  NDIS_OID    Oid,
            IN  PVOID       InformationBuffer,
            IN  ULONG       InformationBufferLength,
            OUT PULONG      BytesRead,
            OUT PULONG      BytesNeeded
            )
{
    NDIS_STATUS status;
    PUSB_DEVICE device;
	NTSTATUS ntStatus;
    ULONG               PacketFilter;

    int i;

    DEBUGMSG(DBG_FUNC, ("+MiniportSetInformation\n"));


    status   = NDIS_STATUS_SUCCESS;
    device = CONTEXT_TO_DEV(MiniportAdapterContext);

	ASSERT( NULL != device ); 
	ASSERT( NULL != BytesRead );
	ASSERT( NULL != BytesNeeded );


    NdisGetCurrentSystemTime( &device->LastSetTime ); //used by check for hang handler
	device->fSetpending = TRUE;
/*
	if ( NULL == InformationBuffer ) { // Should be impossible but it happened on an MP system!

        DEBUGMSG(DBG_ERR, ("    MiniportSetInformation() NULL info buffer passed!,InformationBufferLength = dec %d\n",InformationBufferLength));
		status = NDIS_STATUS_NOT_ACCEPTED;
        *BytesNeeded =0;
        *BytesRead = 0;
        goto done;
 
	}
*/
    if (InformationBufferLength >= sizeof(UINT) )
    {
        //
        //  Set default results.
        //

        UINT info = 0;
		
		if ( NULL != InformationBuffer ) {
			info = *(UINT *)InformationBuffer;
		}


        *BytesRead = sizeof(UINT);
        *BytesNeeded = 0;

        switch (Oid)
        {
            //
            //  Generic OIDs.
            //

		case OID_GEN_CURRENT_PACKET_FILTER:
			DEBUGONCE(DBG_FUNC, ("    MiniportSetInformation(OID_GEN_CURRENT_PACKET_FILTER, %xh)\n", info));
			// Verify the Length
			if (InformationBufferLength != 4)
				return (NDIS_STATUS_INVALID_LENGTH);
			
			// Now call the filter package to set the packet filter.
			NdisMoveMemory((PVOID)&PacketFilter, InformationBuffer, sizeof(ULONG));
			
			// Verify bits, if any bits are set that we don't support, leave
			if (PacketFilter &
				~(NDIS_PACKET_TYPE_DIRECTED |
				NDIS_PACKET_TYPE_MULTICAST |
				NDIS_PACKET_TYPE_BROADCAST |
				NDIS_PACKET_TYPE_PROMISCUOUS |
				NDIS_PACKET_TYPE_ALL_MULTICAST))
			{
				status = NDIS_STATUS_NOT_SUPPORTED;
				*BytesRead = 4;
				break;
			}
			
			*BytesRead = InformationBufferLength;
                //
                // We ignore the packet filter itself.
                //
                // Note:  The protocol may use a NULL filter, in which case
                //        we will not get this OID; so don't wait on
                //        OID_GEN_CURRENT_PACKET_FILTER to start receiving
                //        frames.
                //

                device->fGotFilterIndication = TRUE;

                break;

            case OID_GEN_CURRENT_LOOKAHEAD:
                DEBUGONCE(DBG_FUNC, ("    MiniportSetInformation(OID_GEN_CURRENT_LOOKAHEAD, %xh)\n", info));

                //
                // We always indicate entire receive frames all at once,
                // so just ignore this.
                //

                break;

            case OID_GEN_PROTOCOL_OPTIONS:
                DEBUGONCE(DBG_FUNC, ("    MiniportSetInformation(OID_GEN_PROTOCOL_OPTIONS, %xh)\n", info));

                //
                // Ignore.
                //

                break;
			case OID_802_3_MULTICAST_LIST:
		
				status=NDIS_STATUS_SUCCESS;
				*BytesRead = InformationBufferLength;

				break;

            default:
                DEBUGMSG(DBG_WARN, ("    MiniportSetInformation(OID=%d=0x%x, value=%xh) - invalid OID\n", Oid, Oid, info));

                *BytesRead = 0;
                *BytesNeeded = 0;
                status = NDIS_STATUS_INVALID_OID;

                break;
        }
    }
    else
    {
        //
        // The given data buffer is not large enough for the information
        // to set.
        //

        *BytesRead = 0;
        *BytesNeeded = sizeof(UINT);
        status = NDIS_STATUS_INVALID_LENGTH;
    }

//done:

    if (  NDIS_STATUS_PENDING != status  ) {

        // zero-out the time so check for hang handler knows nothing pending

        device->LastSetTime.QuadPart = 0;
		device->fSetpending            = FALSE;
    }

    DEBUGMSG(DBG_FUNC, ("-MiniportSetInformation\n"));

    return status;
}

