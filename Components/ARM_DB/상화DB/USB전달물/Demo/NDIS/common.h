/*++

Copyright (c) 1999  Microsoft Corporation

Module Name:

   common.h

Abstract:
		Header for device data structure definitions and functions
		that are common to USB-oriented souce modules and Ndis-oriented
		source modules.
		This header must not contain any references to types that are
		either unique to NDIS or unique to USBD, as it must be usable with
		either Wdm.h, or Ndis.h with BINARY_COMPATIBLE set to 1 for Win98 compatibility.
		Unfortunately, Wdm.h cannot compile with Ndis.h in the same module
		unless  BINARY_COMPATIBLE == 0, but this causes the executable to be 
		incompatible with Win98.

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

#ifndef _COM_H
#define _COM_H

#define OID_CUSTOM_DRIVER_SET       0xFFA0C901
#define OID_CUSTOM_DRIVER_QUERY     0xFFA0C902
#define OID_CUSTOM_ARRAY            0xFFA0C903
#define OID_CUSTOM_STRING           0xFFA0C904

static unsigned char MacAddr[6]={0x0,0x12,0x34,0x56,0x78,0x90};

// registry path used for parameters global to all instances of the driver
#define USB_REGISTRY_PARAMETERS_PATH  \
	L"\\REGISTRY\\Machine\\System\\CurrentControlSet\\SERVICES\\USB\\Parameters"


// This is for use by check-for-hang handler and is just a reasonable guess;
// Total # of USBD control errors, read aerrors and write errors;
// Used by check-for-hang handler to decide if we need a reset
//
#define USB_100ns_PER_ms                    10000
#define USB_100ns_PER_us                    10
#define USB_ms_PER_SEC                      1000
#define USB_100ns_PER_SEC                   ( USB_100ns_PER_ms * USB_ms_PER_SEC )

#define MAX_QUERY_TIME_100ns             ( 8 * USB_100ns_PER_SEC )        //8 sec
#define MAX_SET_TIME_100ns               MAX_QUERY_TIME_100ns
#define MAX_SEND_TIME_100ns             ( 20 * USB_100ns_PER_SEC )        //20 sec

#define MAX_TURNAROUND_usec     10000

#define DEFAULT_TURNAROUND_usec 5000


#define MIN(a,b) (((a) <= (b)) ? (a) : (b))
#define MAX(a,b) (((a) >= (b)) ? (a) : (b))


/*
 *  A receive buffer is either FREE (not holding anything) FULL
 * (holding undelivered data) or PENDING (holding data delivered
 * asynchronously)
 */
typedef enum rcvbufferStates {
    STATE_FREE,
    STATE_FULL,
    STATE_PENDING
} rcvBufferState;


//
// Structure to keep track of receive packets and buffers to indicate
// receive data to the protocol.
//

typedef struct
{
    PVOID             packet;
    UINT              dataLen;
    PUCHAR            dataBuf; 
	PVOID    		  device;
    ULONG             fInRcvDpc;
    ULONG             fReturnPacketCalled;
	PVOID			  Irp;
    KEVENT			  Event;
    rcvBufferState    state;
	PVOID             Urb;

} RCV_BUFFER, *PRCV_BUFFER;



#define USB_INBOUND_OUTBOUND_HEADER_SIZE    0
#define USB_ADDRESS_FIELD_SIZE			    0
#define USB_CONTROL_FIELD_SIZE				0
#define USB_A_C_TOTAL_SIZE    ( USB_ADDRESS_FIELD_SIZE + USB_CONTROL_FIELD_SIZE )


#define USB_USB_TOTAL_NON_DATA_SIZE      ( USB_INBOUND_OUTBOUND_HEADER_SIZE + USB_ADDRESS_FIELD_SIZE +  USB_CONTROL_FIELD_SIZE )

#define USB_MAX_DATAONLY_SIZE				2048


#define MAX_TOTAL_SIZE_WITH_ALL_HEADERS	( USB_MAX_DATAONLY_SIZE + USB_USB_TOTAL_NON_DATA_SIZE )

#define INBOUND_HEADER_MEDIA_BUSY_BIT   0x80
#define HEADER_LINK_SPEED_MASK          0x0f  // we want to mask off bits 4-7

typedef struct{
    enum         baudRates tableIndex;
    UINT bitsPerSec;
    UINT ndisCode;         // bitmask element as used by ndis and in class-specific descriptor
    UCHAR        headerLinkSpeed; // value as used in bits 0-3 of inbound header and outbound header
	UCHAR        bofDivisor;
} baudRateInfo;


//
// Struct to hold the IR USB dongle's USB Class-Specific Descriptor as per
// "Universal Serial Bus IrDA Bridge Device Definition" doc, section 7.2
// This is the struct returned by USBD as the result of a request with an urb 
// of type _URB_CONTROL_VENDOR_OR_CLASS_REQUEST, function URB_FUNCTION_CLASS_DEVICE
// 

// Enable 1-byte alignment in the below struct
#pragma pack (push,1)

typedef struct _USB_CLASS_SPECIFIC_DESCRIPTOR
{
    UCHAR  bLength;            // len of this struct (0xC, decimal 12)
    UCHAR  bDescriptorType;    // type of this descriptor,  0x21 as per doc
    USHORT bcdSpecRevision;    // spec revision, binary coded decimal

    UCHAR  bmDataSize;         // max bytes allowed in any frame as per IrLAP spec, where:
                            
    UCHAR bmWindowSize;         // max un-acked frames that can be received
                                // before an ack is sent, where:
    UCHAR bmMinTurnaroundTime;         // min millisecs required for recovery between
                                       // end of last xmission and can receive again, where:
    USHORT wBaudRate;

    UCHAR  bmExtraBofs; // #BOFS required at 115200; 0 if slow speeds <=115200 not supported

    
    UCHAR  bIrdaRateSniff;     // 1 if can dynamically accept frames xmistted at any speed
                               // 0 if can only accept frames xmitted at a pre-specified speed
    
    UCHAR  bMaxUnicastList;    // #addresses that can be specified in a class-specific
                               // Set IrDA Unicast List request; 0 if filtering not supported (all valid frames accepted)

} USB_CLASS_SPECIFIC_DESCRIPTOR, *PUSB_CLASS_SPECIFIC_DESCRIPTOR;

#pragma pack (pop) //disable 1-byte alignment


typedef struct _DONGLE_CAPABILITIES
{

    //
    // Time (in microseconds) that must transpire between
    // a transmit and the next receive.
    //

    LONG turnAroundTime_usec;   // gotten from class-specific descriptor

    //
    // Max un-acked frames that can be received
    // before an ack is sent
    //

    UINT windowSize;            // gotten from class-specific descriptor

    //
    // #BOFS required at 115200; 0 if slow speeds <=115200 are not supported
    //

    UINT extraBOFS;             // gotten from class-specific descriptor

    //
    // max bytes allowed in any frame as per IrLAP spec
    //

    UINT dataSize;              // gotten from class-specific descriptor



} DONGLE_CAPABILITIES, *PDONGLE_CAPABILITIES;


//
// Enum of context types for SendPacket
//
typedef enum _CONTEXT_TYPE {
    CONTEXT_NDIS_PACKET = 1,
    CONTEXT_SETSPEED,
	CONTEXT_TERMINATOR
} CONTEXT_TYPE;




typedef	VOID	(*WORK_PROC)(struct _USB_WORK_ITEM *);

typedef struct _USB_WORK_ITEM
{
    PVOID               pIrDevice;
    WORK_PROC           Callback;
    PUCHAR              InfoBuf;
    ULONG               InfoBufLen;
	ULONG				fInUse;  // declared as ulong for use with interlockedexchange
} USB_WORK_ITEM, *PUSB_WORK_ITEM;


typedef struct _USB_DEVICE
{

    //
    // Keep track of various device objects.
    //

    PDEVICE_OBJECT  pUsbDevObj;     //'Next Device Object'
    PDEVICE_OBJECT  pPhysDevObj;    // Physical Device Object 


    //
    // This is the handle that the NDIS wrapper associates with a connection.
    // (The handle that the miniport driver associates with the connection
    // is just an index into the devStates array).
    //

    HANDLE hNdisAdapter;

    //
    // The dongle interface allows us to check the tranceiver type once
    // and then set up the interface to allow us to init, set speed,
    // and deinit the dongle.
    //
    // We also want the dongle capabilities.
    //

    DONGLE_CAPABILITIES dongleCaps; 

    //
    // Current speed setting, in bits/sec.
    // Note: This is updated when we ACTUALLY change the speed,
    //       not when we get the request to change speed via
    //       usbSetInformation.
    //
    //
    //  When speed is changed, we have to clear the send queue before
    //  setting the new speed on the hardware.
    //  These vars let us remember to do it.
    //
    PVOID			LastPacketAtOldSpeed;
    UINT			currentSpeed;
    ULONG			fSetSpeedAfterCurrentSendPacket;


    //
    // Current link speed information. This also will maintain the
    // chosen speed if the protocol requests a speed change.
    //

    baudRateInfo *linkSpeedInfo; 

    //
    // Maintain statistical debug info.
    //

    ULONG packetsReceived;
    ULONG packetsReceivedDropped;
    ULONG packetsReceivedOverflow;
    ULONG packetsSent;
    ULONG packetsSentDropped;
	ULONG SendContextsInUse;
	ULONG RcvBuffersInUse;


    // used by check hang handler to track Query, Set, and Send times
    LARGE_INTEGER LastQueryTime;
    LARGE_INTEGER LastSetTime;
	BOOLEAN fSetpending;
	BOOLEAN fQuerypending;

    //
    // Set when device has been started; use for safe cleanup after failed initialization
    //

    BOOLEAN fDeviceStarted;

    //
    // Indicates that we have received an OID_GEN_CURRENT_PACKET_FILTER
    // indication from the protocol. We can deliver received packets to the
    // protocol.
    //

    BOOLEAN fGotFilterIndication;


    //
    // NDIS calls most of the MiniportXxx function with IRQL DISPATCH_LEVEL.
    // There are a number of instances where the ir device must send
    // requests to the device which may be synchronous and
    // we can't block in DISPATCH_LEVEL. Therefore, we set up a thread to deal
    // with request which require PASSIVE_LEVEL. An event is used to signal
    // the thread that work is required.
    //

    HANDLE          hPassiveThread;
    BOOLEAN         fKillPassiveLevelThread;


    KEVENT EventPassiveThread;



    ULONG         fMediaBusy;  // declare as ULONGS for use with InterlockedExchange
    ULONG         fIndicatedMediaBusy;

    //
    // The variable fReceiving is used to indicate that the ir device
    // object in pending a receive from the USB device object. Note,
    // that this does NOT necessarily mean that any data is being
    // received from the USB device object, since we are constantly
    // in a blocking receive call to the USB device object for data.
    //
    // Under normal circumstances fReceiving should always be TRUE.
    // However, when usbHalt or usbReset are called, the receive
    // has to be shut down and this variable is used to synchronize
    // the halt and reset handler.
    //

    BOOLEAN fReceiving;

    //
    // The variables fPendingHalt and fPendingReset allow the send and receive
    // completion routines to complete the current pending irp and
    // then cleanup and stop sending irps to the USB driver.
    //

    BOOLEAN fPendingHalt;
    BOOLEAN fPendingReset;


    ULONG fPendingReadClearStall;
    ULONG fPendingWriteClearStall;


    //
    // We keep an array of receive buffers so that we don't continually
    // need to allocate buffers to indicate packets to the protocol.
    // Since the protocol can retain ownership of up to eight packets
    // and we can be receiving up to WindowSize  ( 7 ) packets while the protocol has
    // ownership of eight packets, we will allocate 16 packets for
    // receiving.
    //

    #define NUM_RCV_BUFS 16

    RCV_BUFFER rcvBufs[NUM_RCV_BUFS];

	PRCV_BUFFER pCurrentRcvBuf;

	// Can have max of NUM_RCV_BUFS packets pending + one set and one query
	//
	#define  NUM_WORK_ITEMS	 (NUM_RCV_BUFS + 3)

	USB_WORK_ITEM WorkItems[ NUM_WORK_ITEMS ];

	//
    // Since we can have muliple write irps pending with the USB driver,
    // we track the irp contexts for each one so we have all the info we need at each
	// invokation of the USB write completion routine. See the USB_CONTEXT definition below
    //
 
	#define	 NUM_SEND_CONTEXTS  NUM_RCV_BUFS

	PVOID	 pSendContexts;

    //
    // Handles to the NDIS packet pool and NDIS buffer pool
    // for allocating the receive buffers.
    //

    HANDLE hPacketPool;
    HANDLE hBufferPool;


	KEVENT			EventUrb;
	KEVENT			EventIoCtl;

	NTSTATUS        StatusControl;  
	NTSTATUS        StatusReset;  

	ULONG        	BytesRead;

	// track pending IRPS; this should be zero at halt time

	UINT	PendingIrpCount;

    ULONG         NumReads;

    // total # of USBD control errors, read aerrors and write errors;
    // used by check-for-hang handler to decide if we need a reset
    //
    ULONG         NumDataErrors;


    HANDLE BulkInPipeHandle;
    HANDLE BulkOutPipeHandle;

    HANDLE          hPollingThread;
    BOOLEAN         fKillPollingThread;


    // events to serialize HW access
	KEVENT			EventSetSpeedNow;

//
// The IR USB dongle's USB Class-Specific Descriptor as per
// "Universal Serial Bus IrDA Bridge Device Definition" doc, section 7.2
// This is the struct returned by USBD as the result of a request with an urb 
// of type _URB_CONTROL_VENDOR_OR_CLASS_REQUEST, function URB_FUNCTION_CLASS_DEVICE.
// Note this  struct is  in-line, not a pointer
// 
    USB_CLASS_SPECIFIC_DESCRIPTOR  ClassDesc;

	UINT			IdVendor;			//USB vendor Id read from dongle
	//
	//  used to deal with speed and extra BOF changes
	//
	UCHAR			OutBoundHeader;

	// We don't define it here because we need to isolate USB stuff so we
	// can build  things referencing NDIS with the BINARY_COMPATIBLE flag for win9x

	PUCHAR			pUsbInfo;

	// Optional registry entry for debugging; limit baud rate. 
	// The mask is set up as per the USB Class-Specific descriptor 'wBaudRate'
	// This is 'and'ed with value from Class descriptor to possibly limit baud rate;
	// It defaults to 0xffff
	//
	UINT			BaudRateMask;

	UINT			UrbLen;

	UINT			DisplayPacket;

}USB_DEVICE, *PUSB_DEVICE;




//
// We use a pointer to the USB_DEVICE structure as the miniport's device context.
//

#define CONTEXT_TO_DEV(__deviceContext) ((PUSB_DEVICE)(__deviceContext))
#define DEV_TO_CONTEXT(__irdev) ((HANDLE)(__irdev))

#define USB_TAG ' RIF'
#define DEVICE_PREFIX L"\\DEVICE\\"



BOOLEAN NdisToUsbPacket(
            IN  PUSB_DEVICE      thisDev,
            IN  PVOID           Packet,
            OUT UCHAR           *usbPacketBuf,
            IN  UINT            usbPacketBufLen
            );


VOID  
   IndicateMediaBusy(
       IN PUSB_DEVICE Device
       );



VOID  
UsbIncIoCount( 
		IN PUSB_DEVICE  Device 
		); 


VOID  
UsbDecIoCount( 
		IN PUSB_DEVICE  Device 
		);



void SetDongleCaps( 
        IN OUT PUSB_DEVICE Device 
);

VOID MemFree(
            IN PVOID memptr,
            IN UINT size
            );


PVOID MemAlloc(UINT);


void DumpStatsEverySec( PUSB_DEVICE Device, UINT NumSeconds ) ;

BOOLEAN AllocUsbInfo(
	PUSB_DEVICE Device );

VOID FreeUsbInfo(
	PUSB_DEVICE Device );


VOID PollingThread(
            IN PVOID Context
            );

NTSTATUS StartUsbRead(IN PUSB_DEVICE Device);

VOID
RaiseIrqlToDispatch( PUCHAR sav );

VOID
RestoreIrqlTo( UCHAR saved );


NTSTATUS ProcessData(
            IN PUSB_DEVICE		Device,
            IN PRCV_BUFFER      pRecBuf
            );

NTSTATUS DeliverBuffer(
            IN  PUSB_DEVICE Device,
			IN  PRCV_BUFFER pRecBuf
            );

NTSTATUS InitializeReceive(
            IN OUT PUSB_DEVICE Device
            );
NTSTATUS
ResetPipe (
    IN PUSB_DEVICE   Device,
    IN HANDLE Pipe
    );

BOOLEAN
InitWdmStuff( 
            IN OUT PUSB_DEVICE Device
			);

VOID
FreeWdmStuff( 
            IN OUT PUSB_DEVICE Device
			);

NTSTATUS
SendPacket(
		   IN PUSB_DEVICE   Device, 
           IN PVOID		   pPacket,
           IN UINT         Flags,
		   IN CONTEXT_TYPE Type
           );


VOID
	MyNdisSetPacketStatus( 
	PVOID packet,
	NTSTATUS status
	);


PRCV_BUFFER
	GetRcvBuf( 
	PUSB_DEVICE Device,
	OUT UINT *pIndex,
	IN rcvBufferState state
	);


VOID PassiveLevelThread(
            IN PVOID Context
            );
VOID 
ProcessDataCallBack( PUSB_WORK_ITEM pWorkItem );


BOOLEAN
ScheduleWorkItem(
			PUSB_DEVICE        pDevice,
            WORK_PROC         Callback,
            PVOID             InfoBuf,
            ULONG             InfoBufLen);

VOID FreeWorkItem(
            IN PUSB_WORK_ITEM pItem
            );

VOID 
	PrepareSetSpeed(
		PUSB_DEVICE Device
		);

VOID
SetSpeedCallback(
	PUSB_WORK_ITEM pWorkItem
	);

VOID
ResetPipeCallback (
    IN PUSB_WORK_ITEM   pWorkItem
    );


PVOID 
AllocXferUrb ( VOID );


VOID
FreeXferUrb( PVOID Urb );

PVOID
GetFreeContext( 
	PUSB_DEVICE Device 
	);

BOOLEAN
NoSendsPending( 
	PUSB_DEVICE Device
	);


BOOLEAN
CancelPendingReadIo(
    IN PUSB_DEVICE DeviceExt,
	BOOLEAN fWaitCancelComplete
    );

BOOLEAN
CancelPendingWriteIo(
    IN PUSB_DEVICE DeviceExt
    );


BOOLEAN
GetRegistryDword(
    IN      PWCHAR    RegPath,
    IN      PWCHAR    ValueName,
    IN OUT  PULONG    Value
    );

NTSTATUS
IoCtlUSBD(
    IN PUSB_DEVICE Device,
    IN ULONG IoCtl
    );


#endif // _IRCOM_H
