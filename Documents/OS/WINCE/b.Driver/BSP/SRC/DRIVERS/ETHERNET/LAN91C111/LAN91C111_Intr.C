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

 *_______________________________________________________________________________
 *
 * Description:
 *              Interrupt Service routines and other required functions for 
 *  processing the interrupts.
 *
 *
 */
#define NDIS_MINIPORT_DRIVER
#define NDIS50_MINIPORT

#include <Ndis.h>
#include <LAN91C111_Adapter.h>
#include <LAN91C111_Proto.h>



BOOLEAN CheckMultiCastAddress(UCHAR *ReadBuffer, MINIPORT_ADAPTER *Adapter);


/*
 Function Name : 	LAN91C111_MiniportISR
 Description   :
                    This routine is invoked when an interrupt occurs.  If
                    the interrupting device is identified as ours, then the DPC
                    is scheduled to complete the processing.
 Parameters    :
                         OUT PBOOLEAN     InterruptRecognized            Is it ours?
                         OUT PBOOLEAN     QueueMiniportHandleInterrupt   Run the DPC?
                         IN  NDIS_HANDLE  AdapterContext                 The Adapter structure.

 Return Value  :
                    VOID
*/
VOID		LAN91C111_MiniportISR		(
											PBOOLEAN    InterruptRecognized,
											PBOOLEAN    QueueMiniportHandleInterrupt,
											NDIS_HANDLE MiniportAdapterContext
										)
{
	MINIPORT_ADAPTER	*Adapter = (MINIPORT_ADAPTER *) MiniportAdapterContext;
	USHORT				temp;
	UCHAR				IntrSts;
    UCHAR				IntrMask;
	USHORT              SavedBank;
	
	NdisRawReadPortUshort(Adapter->IOBase + BANK_SELECT,(USHORT *) &SavedBank);    
	
	NdisRawWritePortUshort (Adapter->IOBase + BANK_SELECT,(USHORT) 2);
	NdisRawReadPortUshort  (Adapter->IOBase + BANK2_INT_STS, &temp);
	
	IntrSts  = LOBYTE(temp);
	IntrMask = HIBYTE(temp);
	if((IntrSts & (ENABLED_INTS | INT_ALLOC)))
	{
		NdisRawWritePortUshort(Adapter->IOBase + BANK2_INT_STS, 0); //Ack all intrs.. !!
		*InterruptRecognized			  =
			*QueueMiniportHandleInterrupt = TRUE;
	}
	else
	{
		*InterruptRecognized          =
			*QueueMiniportHandleInterrupt = FALSE;		
	}	
	
	NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT,SavedBank);	
	return;
}


/*
 Function Name : 	LAN91C111_MiniPortHandleInterrupt
 Description   :    
                    This routine performs deferred processing for adapter
                      interrupts.  All pending interrupt conditions are
                      handled before exit.
 Parameters    :
                    NDIS_HANDLE AdapterContext - Handle to the adapter structure

 Return Value  :
                       VOID
*/

VOID		LAN91C111_MiniPortHandleInterrupt	(IN NDIS_HANDLE  AdapterContext)
{
	MINIPORT_ADAPTER *Adapter = (MINIPORT_ADAPTER *) AdapterContext;
	USHORT          SavedBank;
	UINT			IOBase;
	UINT			IntrPort;
	USHORT			temp;
	UCHAR			IntrSts;

	IOBase		= Adapter->IOBase;
	IntrPort	= IOBase + BANK2_INT_STS;
	//Save the Bank Select..
	NdisRawReadPortUshort (IOBase + BANK_SELECT, &SavedBank);

	while(1)
	{
		NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT,(USHORT) 2);
		NdisRawReadPortUshort (IntrPort, &temp);
		IntrSts = LOBYTE(temp);
		IntrSts &= ENABLED_INTS;

		if(!IntrSts) break;

		if (IntrSts & INT_RX_CMP)
			RCV_Interrupt_Handler(Adapter);

		if (IntrSts & INT_TX_CMP)
			TX_Interrupt_Handler(Adapter);

		if (IntrSts & INT_RX_OVRN)
			RX_OVRN_Interrupt_Handler(Adapter);

		if (IntrSts & INT_EPH_INT)
			EPH_Interrupt_Handler(Adapter);

		if (IntrSts & INT_ALLOC)
			ALLOC_Interrupt_Handler(Adapter);


		if (IntrSts & INT_MDINT)
			MD_Interrupt_Handler(Adapter);
	}

	//Enable the interrupts
	//LAN91C111_MiniportEnableInterrupt(AdapterContext); //No need called by the wrapper..
	//Restore the Bank Select..
	NdisRawWritePortUshort(IOBase + BANK_SELECT, SavedBank);
	return;
}

VOID		LAN91C111_MiniportEnableInterrupt				(NDIS_HANDLE MiniportAdapterContext)
{
	MINIPORT_ADAPTER    *Adapter = (MINIPORT_ADAPTER *) MiniportAdapterContext;
    USHORT              IntrSts = ( ENABLED_INTS << 8 );
			
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: ==> MiniPort ENABLE Interrupt\r\n")));
	
	NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT,(USHORT) 2);
	NdisRawWritePortUshort( Adapter->IOBase + BANK2_INT_STS,IntrSts);		
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: <== MiniPort ENABLE Interrupt\r\n")));
	return;
}


VOID		LAN91C111_MiniportDisableInterrupt			(NDIS_HANDLE MiniportAdapterContext)
{
	MINIPORT_ADAPTER    *Adapter = (MINIPORT_ADAPTER *) MiniportAdapterContext;
    		
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: ==> MiniPort DISABLE Interrupt\r\n")));
		
	NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT,(USHORT) 2);
	NdisRawWritePortUchar( Adapter->IOBase + BANK2_INT_MSK,0);
		
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: <== MiniPort DISABLE Interrupt\r\n")));
	return;
}


VOID			MD_Interrupt_Handler	(MINIPORT_ADAPTER *Adapter)
{
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: ==> MDINT Interrupt Handler\r\n")));
	
	//Acknowledge the interrupt
	NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT,2);
	NdisRawWritePortUchar (Adapter->IOBase + BANK2_INT_STS,INT_MDINT);

	//Acknowledge the PHY interrupt
	ReadPhyRegister(Adapter->IOBase, 18);

	//Indicate to the change to the higher layer.
	if (Adapter->LinkStatus == MEDIA_CONNECTED)
	{
        NdisMIndicateStatus(Adapter->AdapterHandle,NDIS_STATUS_MEDIA_DISCONNECT,NULL,0);
		Adapter->LinkStatus = MEDIA_DISCONNECTED;
	}
	else
	{
		//Re-Negotiate the Link..
		EstablishLink(Adapter);
		NdisMIndicateStatus(Adapter->AdapterHandle,NDIS_STATUS_MEDIA_CONNECT,NULL,0);
		Adapter->LinkStatus = MEDIA_CONNECTED;
	}
	NdisMIndicateStatusComplete(Adapter->AdapterHandle);
		
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111<== MDINT Interrupt\r\n")));
	return;
}

VOID		EPH_Interrupt_Handler		(MINIPORT_ADAPTER *Adapter)
{
	USHORT EPHStatus;
	USHORT temp;
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: ==> EPH Interrupt Handler\r\n")));
		
	//Read the EPH Status register
	NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT, (USHORT) 0);
	NdisRawReadPortUshort(Adapter->IOBase + BANK0_STS, &EPHStatus);

	//Check for errors
	if (EPHStatus & TFS_LINKERROR)
	{
		//Acked by clearing the LE_ENABLE bit in the Control Register
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: LINK_OK\r\n")));
	}
	if (EPHStatus & TFS_COUNTER)
	{
		//This is cleared by reading the ECR
		NdisRawReadPortUshort(Adapter->IOBase + BANK0_CTR, &temp);
	}

	//Renable the Transmitter..
	NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT, (USHORT) 0);
	NdisRawWritePortUshort(Adapter->IOBase + BANK0_TCR, Adapter->TCR);

	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: <== EPH Interrupt Handler\r\n")));
}


VOID		RX_OVRN_Interrupt_Handler	(MINIPORT_ADAPTER *Adapter)
{
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: ==> RX OVRN Interrupt Handler\r\n")));
	//Acknowledge the interrupt
	NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT,2);
	NdisRawWritePortUchar (Adapter->IOBase + BANK2_INT_STS,INT_RX_OVRN);

	//Update the counter
	Adapter->Stat_RxOvrn++;

	//Make sure the RCR is ok.
	NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT,(USHORT) 0);
    NdisRawWritePortUshort(Adapter->IOBase + BANK0_RCR, Adapter->RCR);
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: <== RX OVRN Interrupt Handler\r\n")));
}

VOID		ALLOC_Interrupt_Handler		(MINIPORT_ADAPTER *Adapter)
{
	UCHAR            PacketNumber;
	UINT IOBase = Adapter->IOBase;
    MINIPORT_PACKET *Packet = (MINIPORT_PACKET *) 0;

	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: ==> ALLOC Interrupt Handler\r\n")));
	Adapter->AllocateFlag = FALSE;
	//Retrieve allocated packet number.
	NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT,2);
    NdisRawReadPortUchar(IOBase + BANK2_ARR,(UCHAR *) &PacketNumber);
	//Process the waiting packet.
    if(Adapter->AllocPending.First)
        DequePacket(Adapter->AllocPending, Packet);
	
    if(Packet)
    {
        Packet->PacketNumber = PacketNumber;
        AdapterWrite(Adapter, Packet);
    }
    else
    {
        NdisRawWritePortUchar(IOBase + BANK2_PNR,PacketNumber);		
        NdisRawWritePortUshort(IOBase,(USHORT) CMD_REL_SPEC);
    }
	while(Adapter->AllocPending.First)
    {
        if(!AllocateTxBuffer(Adapter, (MINIPORT_PACKET **) &Packet))
			break;
        else
			AdapterWrite(Adapter, Packet);
	}
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: <== ALLOC Interrupt Handler\r\n")));
}

VOID		TX_Interrupt_Handler		(MINIPORT_ADAPTER *Adapter)
{
	UINT				IOBase;
	UCHAR				SavedPnr,
		PacketNumber;
	USHORT				PacketStatus,
		PacketRange,
		Pointer,
		TempWord,
		Count = PTR_WAIT;
    MINIPORT_PACKET		*LocalPkt;
    NDIS_PACKET			*NdisPacket;
    NDIS_STATUS			TransmitStatus = NDIS_STATUS_SUCCESS;

	RETAILMSG(ZONE_INIT, (TEXT("LAN91C111: ==> TX Interrupt Handler\r\n")));
	
	IOBase = Adapter->IOBase;
	Adapter->XmitPending--;

	//Save the Packet Number Register, for restoring later
	NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT,2);
	NdisRawReadPortUshort(IOBase + BANK2_PNR, &TempWord);
    SavedPnr = LOBYTE(TempWord);

	//Read TXDONE Pkt# from FIFO Port Register
    NdisRawReadPortUshort( IOBase + BANK2_FIFOS, &TempWord );
	PacketNumber = (CHAR)LOBYTE(TempWord);

	//Write to Packet Number Register
	NdisRawWritePortUshort(IOBase + BANK2_PNR,(USHORT) PacketNumber);

	//Retrieve packet status and range
    NdisRawWritePortUshort(IOBase + BANK2_PTR,	(USHORT) (PTR_AUTO | PTR_READ));

	while(Count--)
        NdisRawReadPortUshort(IOBase + BANK2_PTR,(PUSHORT) &Pointer);
	NdisRawReadPortUshort(IOBase + BANK2_DATA1,	(PUSHORT) &PacketStatus);
	NdisRawReadPortUshort(IOBase + BANK2_DATA1,	(PUSHORT) &PacketRange);
	RETAILMSG(ZONE_INIT, (TEXT("LAN91C111: ==> PacketStatus=%X\r\n"),PacketStatus));
	RETAILMSG(ZONE_INIT, (TEXT("LAN91C111: ==> PacketRange=%X\r\n"),PacketRange));

	//Release the Packet
	NdisRawWritePortUshort(IOBase + BANK2_MMU_CMD,	(USHORT) CMD_REL_SPEC);
	//Acknowledge the interrupt
	NdisRawWritePortUshort(IOBase + BANK2_INT_STS, INT_TX_CMP);

	if (PacketStatus & TFS_ERROR)
	{
		TransmitStatus = NDIS_STATUS_FAILURE;
		Adapter->Stat_TxError++;
	}
	else
		Adapter->Stat_TxOK++;

	if(PacketStatus & TFS_MULTICOL)
		Adapter->Stat_MultiColl++;
    if(PacketStatus & TFS_1COL)
		Adapter->Stat_SingleColl++;

	LocalPkt = (MINIPORT_PACKET *) 0;
	if (Adapter->AckPending.First)
	{
		Adapter->TransmitQueueDepth --;
		DequePacket(Adapter->AckPending, LocalPkt);
		NdisPacket = CONTAINING_RECORD(LocalPkt,NDIS_PACKET,MiniportReserved[0]);
		//NdisMSendComplete(Adapter->AdapterHandle,NdisPacket,TransmitStatus);
	}
	NdisRawWritePortUshort(IOBase + BANK2_PNR, (USHORT)SavedPnr);
	
	RETAILMSG(ZONE_INIT, (TEXT("LAN91C111: <== TX Interrupt Handler\r\n")));
	return;
}


VOID		RCV_Interrupt_Handler		(MINIPORT_ADAPTER *Adapter)
{
	UINT				IOBase, DataPort, PtrPort, RxFifoPort, MMUPort;
	USHORT				FIFO;
	USHORT				PacketStatus;
    USHORT				PacketRange, TempRange;
	UCHAR				*ReadBuffer;
	MAC_RECEIVE_CONTEXT Context;
	SMC_PACK_HEADER		*PackHead;

	RETAILMSG(1, (TEXT("LAN91C111: <==>RX Interrupt\r\n")));
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: ==> RCV Interrupt Handler\r\n")));
	IOBase		= Adapter->IOBase;
	DataPort	= IOBase + BANK2_DATA1;
	PtrPort		= IOBase + BANK2_PTR;
	RxFifoPort	= IOBase + BANK2_RX_FIFO;
	MMUPort		= IOBase;

	//Check the fifo for the packets to be recvd
	NdisRawWritePortUshort(IOBase + BANK_SELECT,(USHORT)2);
    NdisRawReadPortUshort(IOBase + BANK2_FIFOS, &FIFO);
	while(!(FIFO & FIFO_RX_EMPTY))
	{
		//Set the pointer to Recieve Area, Auto Increment and Read mode
		NdisRawWritePortUshort(PtrPort,  (USHORT) (PTR_RCV | PTR_AUTO | PTR_READ));

		PackHead = (SMC_PACK_HEADER *) Adapter->LookAheadBuffer;
		//Read the first word of the rx area to get the packet status and length
		NdisRawReadPortBufferUshort(DataPort,(USHORT *) PackHead,(ULONG)2);
		PacketStatus = PackHead->Status;
        PacketRange  = PackHead->Range;
		//Check for errors.  And discard if bad.
		if (PacketStatus & RFS_ERROR)
        {
			if(PacketStatus & RFS_ALIGN)
                Adapter->Stat_AlignError++;

			//Release the frame.  This acknowledges the interrupt.
            NdisRawWritePortUshort(MMUPort, (USHORT) CMD_REM_REL_TOP);
			//Update the counter
			Adapter->Stat_RxError++;
			//Get ready for the next packet
		    NdisRawReadPortUshort( IOBase + BANK2_FIFOS, &FIFO);
 			continue;
        }

		if (Adapter->PromiscuousMode != TRUE)
		{
			if (PacketStatus & RFS_BCAST)
			{
				if (Adapter->RCVBroadcast == FALSE) 
				{
					//Release the frame.  This acknowledges the interrupt.
					NdisRawWritePortUshort(MMUPort, (USHORT) CMD_REM_REL_TOP);
					//Get ready for the next packet
					NdisRawReadPortUshort( IOBase + BANK2_FIFOS, &FIFO);
					continue;
				}
			}
            else
            {
                if ((PacketStatus & RFS_MCAST) && (Adapter->RCVAllMulticast == FALSE))
                {
                    //Recv only the mulitcast with the address in the multicast table
                    if(!CheckMultiCastAddress(ReadBuffer,Adapter))
                    {
                        //Release the frame.  This acknowledges the interrupt.
                        NdisRawWritePortUshort(MMUPort, (USHORT) CMD_REM_REL_TOP);
                        //Get ready for the next packet
                        NdisRawReadPortUshort( IOBase + BANK2_FIFOS, &FIFO);
                        continue;
                    }
                }
            }
		}

		//Good frame received - adjust range for SMSC packet overhead.
		PacketRange -= FRAME_OVERHEAD;
		
		if ((Adapter->ChipID == CHIPID_LAN91C111) && (Adapter->ChipRev == CHIPREV_LAN91C111_REVA))
		{
			//LAN91C111 RevA doesn't set the odd-frame bit in recv status
			//To fix this just increment the frame size by 1 and
			//Let the higher layer figure it out
			PacketRange++;			
		}
		else
		{
			if (PacketStatus & RFS_ODD)
				PacketRange++;			
		}
		ReadBuffer = Adapter->LookAheadBuffer;
		NdisRawReadPortBufferUshort(DataPort,(ULONG *) ReadBuffer,PacketRange>>1);
		if (PacketRange & 0x01)
			NdisRawReadPortUchar(DataPort,&ReadBuffer[PacketRange-1]);

		
		// Release the frame.  This acknowledges the interrupt.
        NdisRawWritePortUshort(MMUPort,(USHORT) CMD_REM_REL_TOP);
				
		Context.Range		= PacketRange;
        Context.PacketData	= ReadBuffer;
		TempRange			= PacketRange - ETHERNET_HEADER_SIZE;
		//Indicate the frame
		NdisMEthIndicateReceive(Adapter->AdapterHandle,
			(NDIS_HANDLE) &Context,
			(void *) ReadBuffer,
			(UINT) ETHERNET_HEADER_SIZE,
			(void *) ((char *) ReadBuffer + ETHERNET_HEADER_SIZE),
			TempRange,
			TempRange);
		Adapter->NeedIndComplete = TRUE;

		//Update the counter
		Adapter->Stat_RxOK++;

		//Next Frame
		NdisRawReadPortUshort( IOBase + BANK2_FIFOS, &FIFO);
		
	} 
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: <== RCV Interrupt Handler\r\n")));
}


BOOLEAN CheckMultiCastAddress(UCHAR *ReadBuffer, MINIPORT_ADAPTER *Adapter)
{
	//Start of CheckMultiCastAddress Function definition
	
	UINT Result;
	PUCHAR ListEntry;
	ULONG Count;
	
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: ==> CheckMultiCastAddress\r\n")));
	
	Result = 1;
	Count = 0;
	ListEntry = Adapter->MulticastTable.MulticastTableEntry;
	
	//If empty list then get out.
	if(Adapter->MulticastTable.MulticastTableEntryCount == 0)
		return FALSE;
	
	// checking all the multicasttable entries against frame address.
	for(Count = 0; Count <Adapter->MulticastTable.MulticastTableEntryCount; Count++)
	{
		// Compare the Ethernet Frame Address with MulticastTableList
		ETH_COMPARE_NETWORK_ADDRESSES(ReadBuffer,	ListEntry,	&Result);
		if(!Result)	break;
		ListEntry += 6;//See next entry in multicast list
	}
	
	//returning the value depending upon the MultiCastTableCount.
	//If Less than TotalCount return TRUE means finds some multicast address
	// same as frame adress
	if(Count <= Adapter->MulticastTable.MulticastTableEntryCount)
		return TRUE;
	else	
		return FALSE;

	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: <== CheckMultiCastAddress\r\n")));
}