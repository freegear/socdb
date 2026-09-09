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
 *
 *Description:
 *              Functions exposed to the NDIS wrapper, ie., MiniportXXX functions.
 *
 *
 */
#define NDIS_MINIPORT_DRIVER
#define NDIS50_MINIPORT

#include <Ndis.h>
#include <LAN91C111_Adapter.h>
#include <LAN91C111_Proto.h>

extern	NDIS_STATUS CopyInfo	(UCHAR *, UCHAR *, UINT, UINT, UINT  *, UINT  *);
extern  void        BackOut		(MINIPORT_ADAPTER *Adapter);
extern  BOOLEAN     AdapterReset(MINIPORT_ADAPTER *);

/*
 Function Name : AllocateTxBuffer
 Description   :
                 This function allocates a buffer for transmission. This called by
                 the miniportsend function.
 Parameters    :    
                 MINIPORT_ADAPTER *Adapter - Pointer to the adapter structure
                 MINIPORT_PACKET **Packet - Pointer to the packet !!
 Return Value  :
                 TRUE - if allocation was succesful, else FLASE
 */
BOOLEAN  AllocateTxBuffer(MINIPORT_ADAPTER  *Adapter,  MINIPORT_PACKET  **Packet)
{
	MINIPORT_PACKET   *CurrentPacket;
	UINT               AllocateOk;
	USHORT             AllocSts;

	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111==> Do Allocate\r\n")));

	if((Adapter->IsAllocateActive) || (!Adapter->AllocPending.First) /*|| (Adapter->XmitPending >= Adapter->MaxXmits)*/)
	{
		DEBUGMSG(ZONE_INIT, (TEXT("Adapter->IsAllocateActive %d\r\n"),Adapter->IsAllocateActive));
		DEBUGMSG(ZONE_INIT, (TEXT("Adapter->AllocPending.First %d\r\n"),Adapter->AllocPending.First));
		DEBUGMSG(ZONE_INIT, (TEXT("Adapter->XmitPending %d\r\n"), Adapter->XmitPending));
		DEBUGMSG(ZONE_INIT, (TEXT("Adapter->MaxXmits %d\r\n"), Adapter->MaxXmits));
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 : Do Allocate Failed !!\r\n")));
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== Do Allocate\r\n")));
		return(FALSE);
	}

	Adapter->AllocateFlag     = 
    Adapter->IsAllocateActive = TRUE;
    Adapter->XmitPending++;
	
	CurrentPacket = Adapter->AllocPending.First;

	//Set the MMU Alloc Command
		NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT,2);
		NdisRawWritePortUshort(Adapter->IOBase + BANK2_MMU_CMD, (USHORT)CMD_ALLOC);
		AllocateOk = MMU_WAIT;
		while(AllocateOk)
		{
			NdisRawReadPortUshort(Adapter->IOBase + BANK2_INT_STS, (PUSHORT) &AllocSts);
			if(AllocSts & INT_ALLOC)
				break;
			AllocateOk--;
		}

	if(AllocateOk)
    {
		USHORT TempWord;
		*Packet = CurrentPacket;
		NdisRawReadPortUshort( Adapter->IOBase + BANK2_PNR,(PUSHORT) &TempWord );
		CurrentPacket->PacketNumber = HIBYTE(TempWord);

        DequePacket(Adapter->AllocPending, CurrentPacket);
        Adapter->IsAllocateActive = Adapter->AllocateFlag = FALSE;
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== Do Allocate\r\n")));
		return TRUE;
	}    
    else
    {
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: Do Allocate Failed\r\n")));
	    Adapter->IsAllocateActive = FALSE;
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== Do Allocate\r\n")));
		return FALSE;
    }	
}


/*
 Function Name :    AdapterWrite
 Description   :
                    This function write the contents of the packet to the chip's internal
                    buffer. The packet has to be allocated before calling this function
 Parameters    :    
                    MINIPORT_ADAPTER *Adapter - Pointer to the adapter structure
                    MINIPORT_PACKET *Packet - Pointer to the packet structure,
                                                this contains the packet descriptors and
                                                the allocated packet number.
 Return Value  :
                    void
 */
VOID		AdapterWrite				(MINIPORT_ADAPTER *Adapter,
										MINIPORT_PACKET  *Packet)
{
	UINT        IOBase,
		DataPort,
		TotalRange,
		BufferRange;
    UCHAR       *BufferData;
	BOOLEAN     WriteContinue = TRUE;
    NDIS_BUFFER *CurrentBuffer,
		*NextBuffer;
	NDIS_PACKET *NdisPacket;
    
	

	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:==> Adapter Write\r\n")));
	if(!Adapter->IsWriteActive)
    {
		
        DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: Adapter is not busy\r\n")));
        Adapter->IsWriteActive = TRUE;
		//Attach to tail of appropriate write queue.
        QuePacket(Adapter->AckPending, Packet);
    }    
    else
		// Write routine is already executing.  When the current write is completed, this one will be processed.
    {
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: Adapter is busy\r\n")));
        QuePacket(Adapter->WritePending, Packet);
        return;
    }

	IOBase   = Adapter->IOBase;
    DataPort = IOBase + BANK2_DATA1;

	//Write the Packet to the 91C111
	while(WriteContinue)
	{
		NdisPacket = CONTAINING_RECORD(Packet,NDIS_PACKET,MiniportReserved[0]);

		//Write the Packet number, that we got from the allocation
		NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT,2);
		NdisRawWritePortUchar(IOBase + BANK2_PNR,  Packet->PacketNumber);
		NdisRawWritePortUshort(IOBase + BANK2_PTR, (USHORT) PTR_AUTO);

		// Output packet preamble.
		NdisQueryPacket(NdisPacket,
			(PUINT) 0,
			(PUINT) 0,
			(PNDIS_BUFFER *) &CurrentBuffer,
			(PUINT) &TotalRange);
			

		//Start writing the Packet to the memory
		//First Write 0 - This is placeholder for the Status word in the memory
		NdisRawWritePortUshort(DataPort, (USHORT) 0);

		//Next write the byte count + frame overhead
		NdisRawWritePortUshort(DataPort,  (USHORT)(TotalRange + FRAME_OVERHEAD));

		//Now write the Data 
		while (CurrentBuffer)
		{
			NdisQueryBuffer(CurrentBuffer,(PVOID *) &BufferData,(PUINT) &BufferRange);
			NdisRawWritePortBufferUshort(DataPort, BufferData, BufferRange>>1);
			if (BufferRange & 0x1)
				NdisRawWritePortUchar(DataPort, BufferData[BufferRange-1]);
			NdisGetNextBuffer(CurrentBuffer,(PNDIS_BUFFER *) &NextBuffer);				
			CurrentBuffer = NextBuffer;
		}
		
		//Lastly write the ControlByte and Odd byte if needed..
		if (TotalRange & 1)
			NdisRawWritePortUchar( DataPort, (UCHAR) ( CTL_BYTE_ODD | CTL_BYTE_CRC ) );
		else
			NdisRawWritePortUshort( DataPort, (USHORT) ( CTL_BYTE_CRC << 8 ) );

		//Now enque the packet for transmission..
		NdisRawWritePortUshort( IOBase + BANK2_MMU_CMD,	(USHORT) CMD_ENQ_TX );		

		//Check if more packets to be transmitted.
		if(!Adapter->WritePending.First)
		{
			WriteContinue =	
				Adapter->IsWriteActive = FALSE;
		}
		else
		{
			DequePacket(Adapter->WritePending, Packet);
			QuePacket(Adapter->AckPending, Packet);
		}

	}
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:<== Adapter Write\r\n")));
}


/*
 Function Name : LAN91C111-MiniportHalt       
 Description   :
                    MiniportHalt is a required function that de-allocates resources 
                    when the network adapter is removed and halts the network adapter
 Parameters    :    
                  NDIS_HANDLE AdapterContext - Specifies the handle to a 
                                                miniport-allocated context area 
 Return Value  :
                  VOID
 */
VOID		LAN91C111_MiniportHalt		(NDIS_HANDLE AdapterContext)
{
    PMINIPORT_ADAPTER   Adapter = (MINIPORT_ADAPTER *) AdapterContext;
    BackOut(Adapter);
	return;
}


/*
 Function Name : LAN91C111_MiniportQueryInformation
 Description   : This function is a required function 
     that returns information about the capabilities 
     and status of the driver and/or its network adapter.
 Parameters    :
    NDIS_HANDLE AdapterContext - Handle to the adapter structure
    NDIS_OID    Oid - OID code designation the query operation that the driver should carr out
    PVOID       InformationBuffer - pointer to the buffer in which the driver return the value
    ULONG       InformationBufferLength - lenght of the buffer
    PULONG      BytesWritten - number of bytes the driver is returning
    PULONG      BytesNeeded - additional bytes, if needed, to satisfy the query.
 Return Value  :
            NDIS_STATUS Status
 */
NDIS_STATUS LAN91C111_MiniportQueryInformation(
											NDIS_HANDLE AdapterContext,
											NDIS_OID    Oid,
											PVOID       InformationBuffer,
											ULONG       InformationBufferLength,
											PULONG      BytesWritten,
											PULONG      BytesNeeded
											)
{
	MINIPORT_ADAPTER  *Adapter     = (MINIPORT_ADAPTER *) AdapterContext;
    NDIS_STATUS        Status      = NDIS_STATUS_SUCCESS;
    NDIS_OID           ReturnData;
    void              *Source      = &ReturnData;
    UINT               BytesToMove = sizeof(NDIS_OID);
	
    
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 ==> MiniportQuery Information OID=%x, "), Oid));
	switch(Oid)
    {
		
	case OID_GEN_SUPPORTED_LIST:
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_SUPPORTED_LIST\r\n")));
        Source      = (void *) &GlobalObjects;
        BytesToMove = sizeof(GlobalObjects);
		break;
		
	case OID_GEN_MEDIA_SUPPORTED:
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_MEDIA_SUPPORTED\r\n")));
		ReturnData = NdisMedium802_3;
		break;
		
	case OID_GEN_MEDIA_IN_USE:
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_MEDIA_IN_USE\r\n")));
		ReturnData = NdisMedium802_3;
		break;
		
	case OID_GEN_MAXIMUM_LOOKAHEAD:
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_MAXIMUM_LOOKAHEAD\r\n")));
		ReturnData = MAX_LOOKAHEAD_SIZE;
		break;

	case OID_GEN_MAXIMUM_FRAME_SIZE:
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_MAXIMUM_FRAME_SIZE\r\n")));
		ReturnData = MAX_FRAME_DATA_SIZE;
		break;		
       
	case OID_GEN_LINK_SPEED:
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_LINK_SPEED\r\n")));
		ReturnData = Adapter->Speed;
		break;		
       
	case OID_GEN_TRANSMIT_BUFFER_SPACE: 
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_TRANSMIT_BUFFER_SPACE\r\n")));
		ReturnData = MAX_FRAME_SIZE;
		break;
		
	case OID_GEN_RECEIVE_BUFFER_SPACE: 
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_RECEIVE_BUFFER_SPACE\r\n")));
		ReturnData = TOTAL_BUFFER_SIZE;		
		break;
		
	case OID_GEN_TRANSMIT_BLOCK_SIZE: 
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_TRANSMIT_BLOCK_SIZE\r\n")));
		ReturnData = MAX_FRAME_SIZE;
		break;
		
        
	case OID_GEN_RECEIVE_BLOCK_SIZE: 
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_RECEIVE_BLOCK_SIZE\r\n")));
		ReturnData = MAX_FRAME_SIZE;
		break;
		
       
	case OID_GEN_VENDOR_ID:
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_VENDOR_ID\r\n")));
		ReturnData = 0;
		NdisMoveMemory((void *) &ReturnData,(void *) &Adapter->MACAddress,	3);
		break;
		
  	case OID_GEN_VENDOR_DESCRIPTION: 
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_VENDOR_DESCRIPTION\r\n")));
		Source      = (void *) DRV_VENDOR_NAME;
		BytesToMove = SIZE_DRV_VENDOR_NAME;
		break;
		
	case OID_GEN_CURRENT_LOOKAHEAD:  
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_CURRENT_LOOKAHEAD\r\n")));
		ReturnData = Adapter->LookAhead;
		break;
		
	case OID_GEN_DRIVER_VERSION:  
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_DRIVER_VERSION\r\n")));
		BytesToMove = 2;
		ReturnData  = DRIVER_NDIS_VERSION;
		break;
		      
	case OID_GEN_MAXIMUM_TOTAL_SIZE:  
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_MAXIMUM_TOTAL_SIZE\r\n")));
		ReturnData = MAX_FRAME_SIZE;
		break;
        
	case OID_GEN_MAC_OPTIONS: 
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_MAC_OPTIONS\r\n")));
		ReturnData = NDIS_MAC_OPTION_COPY_LOOKAHEAD_DATA |
			NDIS_MAC_OPTION_RECEIVE_SERIALIZED  |
			NDIS_MAC_OPTION_TRANSFERS_NOT_PEND  |
			NDIS_MAC_OPTION_NO_LOOPBACK;
		if( Adapter->Duplex )
			ReturnData |= NDIS_MAC_OPTION_FULL_DUPLEX;
		break;
		
		
	case OID_802_3_PERMANENT_ADDRESS:
		DEBUGMSG(ZONE_INIT, (TEXT("OID_802_3_PERMANENT_ADDRESS\r\n")));
		Source      = (void *) &Adapter->MACAddress;
		BytesToMove = MAC_ADDRESS_SIZE;
		break;
		
    case OID_802_3_CURRENT_ADDRESS: 
		DEBUGMSG(ZONE_INIT, (TEXT("OID_802_3_CURRENT_ADDRESS\r\n")));
		Source      = (void *) &Adapter->MACAddress;
		BytesToMove = MAC_ADDRESS_SIZE;
		break;
		
	case OID_802_3_MULTICAST_LIST:
		DEBUGMSG(ZONE_INIT, (TEXT("OID_802_3_MULTICAST_LIST\r\n")));
		BytesToMove = Adapter->MulticastTable.MulticastTableEntryCount 
			* ETH_LENGTH_OF_ADDRESS;
		Source = (void *) Adapter->MulticastTable.MulticastTableEntry;
		break;
		
	case OID_802_3_MAXIMUM_LIST_SIZE: 
		DEBUGMSG(ZONE_INIT, (TEXT("OID_802_3_MAXIMUM_LIST_SIZE\r\n")));
		ReturnData = MAX_MULTICAST_ADDRESS;
		break;

	case OID_802_3_RCV_ERROR_ALIGNMENT:
		DEBUGMSG(ZONE_INIT, (TEXT("OID_802_3_RCV_ERROR_ALIGNMENT\r\n")));
		ReturnData = Adapter->Stat_AlignError;		
		break;
		
	case OID_802_3_XMIT_ONE_COLLISION:
		DEBUGMSG(ZONE_INIT, (TEXT("OID_802_3_XMIT_ONE_COLLISION\r\n")));
		ReturnData = Adapter->Stat_SingleColl;
		break;		
        
	case OID_802_3_XMIT_MORE_COLLISIONS:
		DEBUGMSG(ZONE_INIT, (TEXT("OID_802_3_XMIT_MORE_COLLISIONS\r\n")));
		ReturnData = Adapter->Stat_MultiColl;
		break;
		
	case OID_GEN_MEDIA_CONNECT_STATUS:
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_MEDIA_CONNECT_STATUS\r\n")));
		if(Adapter->LinkStatus == MEDIA_DISCONNECTED)
		{
			ReturnData = NdisMediaStateDisconnected;
		}
		else
		{
			ReturnData = NdisMediaStateConnected;
		}
		break;

	case OID_GEN_VENDOR_DRIVER_VERSION:
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_VENDOR_DRIVER_VERSION\r\n")));
		ReturnData = ((DRIVER_NDIS_MINOR_VERSION >> 16 ) | 
			DRIVER_NDIS_MAJOR_VERSION);
		break;
		
	case OID_GEN_MAXIMUM_SEND_PACKETS:
		DEBUGMSG(ZONE_INIT, (TEXT("OID_GEN_MAXIMUM_SEND_PACKETS\r\n")));
		ReturnData = 1;
		break;

	case OID_GEN_XMIT_OK:
		ReturnData = Adapter->Stat_TxOK;
		break;		

	case OID_GEN_RCV_OK:
		ReturnData = Adapter->Stat_RxOK;
		break;

	case OID_GEN_XMIT_ERROR:
		ReturnData = Adapter->Stat_TxError;
		break;

	case OID_GEN_RCV_ERROR:
		ReturnData = Adapter->Stat_RxError;
		break;

	case OID_GEN_RCV_NO_BUFFER:
		ReturnData = Adapter->Stat_RxOvrn;
		break;

	case OID_GEN_HARDWARE_STATUS:
		if (Adapter->State == NORMAL_STATE)
				ReturnData = NdisHardwareStatusReady;
			else
			{
				if(Adapter->State == INITIALIZING_STATE)
					ReturnData = NdisHardwareStatusNotReady;
				if(Adapter->State == RESET_STATE)
					ReturnData = NdisHardwareStatusReset;
			}
		break;

	default:
		DEBUGMSG(ZONE_INIT, (TEXT("Unknown or Unsupported OID Statistics Query\r\n")));
		BytesToMove = 0;
		Status      = NDIS_STATUS_NOT_SUPPORTED;
		break;
	}
	
	
	if(BytesToMove)
    {
        Status = CopyInfo(InformationBuffer,
			Source,
			InformationBufferLength,
			BytesToMove,
			BytesWritten,
			BytesNeeded);
    }
	
	
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== MiniportQuery Information OID\r\n")));
	return Status;
}


/*
 Function Name : LAN91C111_MiniportSend
 Description   :
                This function transfers a protocol-supplied packet over the network.
 Parameters    : 
                NDIS_HANDLE  AdapterContext - Handle to the adapter structure
				PNDIS_PACKET NDISPacket - Points to a packet descriptor 
                                            specifying the data to be transmitted. 

				UINT         Flags - Specifies the packet flags, if any, set by the protocol. 
 Return Value  :
            NDIS_STATUS  Status
 */
NDIS_STATUS LAN91C111_MiniportSend		(
											NDIS_HANDLE  AdapterContext,
											PNDIS_PACKET NDISPacket,
											UINT         Flags
										)
{
	MINIPORT_ADAPTER	*Adapter = (MINIPORT_ADAPTER *) AdapterContext;
	UINT				BufferCount;
    UINT				PacketLength;
	MINIPORT_PACKET     *Packet;

	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 ==> Miniport Send\n")));

	if (Adapter->State != NORMAL_STATE)
	{
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: Adapter not in normal state\n")));
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== Miniport Send\n")));
		return (NDIS_STATUS_FAILURE);
	}
	NdisQueryPacket(NDISPacket,	(PUINT) &BufferCount,(PUINT) 0,(PNDIS_BUFFER *) 0,(PUINT) &PacketLength);
	if ((PacketLength > MAX_FRAME_SIZE) || (PacketLength < MIN_FRAME_SIZE))
	{
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: Invalid Packet Size\n")));
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== Miniport Send\n")));
		return (NDIS_STATUS_FAILURE);
	}

	Packet			= (MINIPORT_PACKET *) NDISPacket->MiniportReserved;
	Packet->Next	= (MINIPORT_PACKET *) 0;
	
	Adapter->TransmitQueueDepth++;
	QuePacket(Adapter->AllocPending, Packet);
	if(AllocateTxBuffer(Adapter, (MINIPORT_PACKET **) &Packet))
		AdapterWrite(Adapter, Packet);
	else
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:==> ALLOCATE failed. No Writes allowed\r\n")));


	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== Miniport Send\n")));
	return NDIS_STATUS_SUCCESS;
}

/*
 Function Name : LAN91C111_MiniportReset
 Description   : This function is a required function that issues a hardware reset 
                    to the network adapter and/or resets the driver’s software state.
 Parameters    : 
                PBOOLEAN    AddressingReset -Points to a variable that MiniportReset
                            sets to TRUE if the NDIS library should call 
                            MiniportSetInformation to restore addressing information 
                            to the current values. 
 				NDIS_HANDLE AdapterContext - Handle to the adapter structure

 Return Value  :
            NDIS_STATUS Status
 */
NDIS_STATUS	LAN91C111_MiniportReset		(
											PBOOLEAN    AddressingReset,
											NDIS_HANDLE AdapterContext
										)
{
	NDIS_STATUS          Status=NDIS_STATUS_SUCCESS;
	MINIPORT_ADAPTER	*Adapter = (MINIPORT_ADAPTER *) AdapterContext;
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 ==> Miniport Reset\r\n")));
	Status = AdapterReset(Adapter);
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== Miniport Reset\r\n")));
	return Status;
}
 

/*
 Function Name : LAN91C111_MiniportTransferData
 Description   :
                This function is a required function in network adapter drivers that do 
                not indicate multipacket receives and/or media-specific information with 
                NdisMIndicateReceivePacket and in those that do not support WAN media
 Parameters    :    
            PNDIS_PACKET Packet - points to packet descriptor with chained buffers into 
                                which the data should be copied
            PUINT BytesTransferred -    no. of bytes of data actually copied by this function                
            NDIS_HANDLE MiniportAdapterContext - Handle to the adapter structure 
            NDIS_HANDLE MiniportReceiveContext - Handle tot he recieve context passed in 
                            previous NdisMIndicateRecieve function
            UINT ByteOffset - offset within the recieved packet
            UINT BytesToTransfer -  specifies how many bytes to copy
 Return Value  :
            NDIS_STATUS Status
 */
NDIS_STATUS LAN91C111_MiniportTransferData(
											PNDIS_PACKET Packet,
											PUINT BytesTransferred,
											NDIS_HANDLE MiniportAdapterContext,
											NDIS_HANDLE MiniportReceiveContext,
											UINT ByteOffset,
											UINT BytesToTransfer
											)
{
    /*
      Note : This function is not required since the driver transfers the complete packet
      in one function call using the NdisMEthIndicateReceive function, when there is a RX interrupt.
    */
	NDIS_STATUS				Status=NDIS_STATUS_FAILURE;
	return Status;
}


