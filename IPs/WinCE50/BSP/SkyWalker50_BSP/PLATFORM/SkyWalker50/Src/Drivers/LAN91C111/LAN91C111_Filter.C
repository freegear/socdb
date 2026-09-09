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
 *Description:
 *              Hardware Filters and OID Set/Query functions for the driver
 *
 *
 */

#define NDIS_MINIPORT_DRIVER
#define NDIS50_MINIPORT

#include <Ndis.h>
#include <LAN91C111_Adapter.h>
#include <LAN91C111_Proto.h>

USHORT		MakeHash	(NETWORK_ADDRESS *);
void		SetHash		(MINIPORT_ADAPTER *,USHORT);
NDIS_STATUS CopyInfo	(UCHAR *, UCHAR *, UINT, UINT, UINT  *, UINT  *);

/*
 Function Name : 	LAN91C111_MiniportSetInformation
 Description   :
					Required function, by the NDIS. Called by the wrapper to 
					request changes in the state information for the hardware.

  Parameters   :    

					NDIS_HANDLE AdapterContext          handle to context area 
					   NDIS_OID Oid                     OID reference for the set operation
					      PVOID InformationBuffer       buffer containing the ODI specific data
					      ULONG InformationBufferLength length of the information buffer
					     PULONG BytesRead               function sets to the number of bytes 
														it read from the buffer at InformationBuffer
					     PULONG BytesNeeded             function sets this to number of additional bytes 
														it needs to satisfy the request, in case buffer 
														length is not sufficient
  Return Value :
 				NDIS_STATUS     Status      
 */


NDIS_STATUS LAN91C111_MiniportSetInformation(
											NDIS_HANDLE MiniportAdapterContext,
											NDIS_OID Oid,
											PVOID InformationBuffer,
											ULONG InformationBufferLength,
											PULONG BytesRead,
											PULONG BytesNeeded
											)
{
    MINIPORT_ADAPTER    *Adapter = (MINIPORT_ADAPTER *) MiniportAdapterContext;
    NDIS_STATUS          Status  = NDIS_STATUS_SUCCESS;
    NDIS_OID            *NdisOid = (NDIS_OID *) InformationBuffer;
    DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:==> MiniPort Set Information\r\n")));

    switch(Oid)
    {
        //Current packet filter enabled
        case OID_GEN_CURRENT_PACKET_FILTER:
			Status = MiniPortChangeFilter(Adapter, *NdisOid);
			break;

        //Current LookAhead size.
        case OID_GEN_CURRENT_LOOKAHEAD:
			if(*NdisOid > MAX_LOOKAHEAD_SIZE)
                Status = NDIS_STATUS_FAILURE;
            Adapter->LookAhead = *NdisOid;
            *BytesRead         = sizeof(NDIS_OID);
            break;

        //Reset the list of all multicast addresses enabled.
        case OID_802_3_MULTICAST_LIST:
			if((InformationBufferLength % ETH_LENGTH_OF_ADDRESS) != 0)
			{
				Status = NDIS_STATUS_INVALID_LENGTH;
				// We don't know how big it is, assume one entry.
				*BytesNeeded = 	InformationBufferLength + 
					(ETH_LENGTH_OF_ADDRESS - 
					(InformationBufferLength % ETH_LENGTH_OF_ADDRESS));
				*BytesRead = 0;
				break;
			}

			Status = MiniPortChangeAddresses(Adapter,
                                           (UCHAR *) NdisOid,
                                             (UINT) (InformationBufferLength / MAC_ADDRESS_SIZE));
			NdisMoveMemory(Adapter->MulticastTable.MulticastTableEntry,
						InformationBuffer,
						InformationBufferLength);
			Adapter->MulticastTable.MulticastTableEntryCount =
						InformationBufferLength / ETH_LENGTH_OF_ADDRESS;
			*BytesRead = InformationBufferLength;
			break;

        //Unknown or unsupported Object Identifier.
        default:
				DEBUGMSG(ZONE_INIT, (TEXT("Unknown or Unsupported OID Set Request! OID=%d\r\n"),Oid));
   
            Status = NDIS_STATUS_NOT_SUPPORTED;
            break;
    }

    DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:<== MiniPort Set Information\r\n")));
    return(Status);
}


/*
 Function Name : 	MiniPortChangeFilter
 Description   :	Called by the filter library when a significant change has occured to
					the filter library. This function updates the driver and the hardware 
					filters.
 Parameters    :			MINIPORT_ADAPTER   *Adapter		//Pointer to the adapter structure
                            NDIS_OID            NewFilter	//Filter OID
	
 Return Value  :
					 NDIS_STATUS     Status      
					
*/

NDIS_STATUS MiniPortChangeFilter(MINIPORT_ADAPTER   *Adapter,
                                 NDIS_OID            NewFilter)
{
    USHORT       NewRCR  = 0;
	
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111==> MiniPort Change Filter\r\n")));
    
    //Check for invalid type.
    if(NewFilter & ~((
		NDIS_PACKET_TYPE_BROADCAST    | 
		NDIS_PACKET_TYPE_MULTICAST    |
		NDIS_PACKET_TYPE_DIRECTED     |
		NDIS_PACKET_TYPE_PROMISCUOUS  |
		NDIS_PACKET_TYPE_ALL_MULTICAST
		)))
        return(NDIS_STATUS_NOT_SUPPORTED);

	//Rcv all directed packets
    if(NewFilter & NDIS_PACKET_TYPE_DIRECTED);
	//Rcv only the multicast with addresses in the list, by clearing the ALMUL in the RCR
    if(NewFilter & NDIS_PACKET_TYPE_MULTICAST);
		
	NewRCR = 0;
	
    if(NewFilter & NDIS_PACKET_TYPE_BROADCAST)
	{		
			Adapter->RCVBroadcast = TRUE;   
	}
    else
		Adapter->RCVBroadcast = FALSE;
	
    if(NewFilter & NDIS_PACKET_TYPE_ALL_MULTICAST)
    {
		NewRCR = RCR_ALL_MUL;
        Adapter->RCVAllMulticast = TRUE;
    }
    else
		Adapter->RCVAllMulticast = FALSE;
	
    if(NewFilter & NDIS_PACKET_TYPE_PROMISCUOUS)
    {
		NewRCR = RCR_PRMS;
        Adapter->PromiscuousMode = TRUE;
    }
    else
		Adapter->PromiscuousMode = FALSE;
	
    NewRCR |= RCR_STRP_CRC;
	NewRCR |= RCR_RX_EN;
	Adapter->RCR = NewRCR;

	//Now load the new RCR value
	NdisRawWritePortUshort(	Adapter->IOBase + BANK_SELECT, 0);
    NdisRawWritePortUshort( Adapter->IOBase + BANK0_RCR, NewRCR);
	
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111<== MiniPort Change Filter\r\n")));
    return(NDIS_STATUS_SUCCESS);
}


NDIS_STATUS MiniPortChangeAddresses(MINIPORT_ADAPTER *Adapter,
                                    UCHAR            *AddressList,
                                    UINT              AddressCount)
{
    USHORT       HashBits;
    USHORT       Count;
    
    //Add "Flow Control" packet's multicast address for changing the Hash Table.
    UCHAR        FCAddress[6] = { 0x01, 0x80, 0xC2, 0x00, 0x00, 0x01 };
	
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111==> MiniPort Change Address\r\n")));
	
    //Clear the current list.
    for(Count = 0; Count < 8; Count++)
        Adapter->HashTable[Count] = 0;
	
	
    //Generate Hash codes for new addresses
    while(AddressCount--)
    {
        HashBits = MakeHash((NETWORK_ADDRESS *) AddressList);
        SetHash(Adapter, HashBits);
        AddressList += MAC_ADDRESS_SIZE;
    };
	
	
    //Output the new list.
	NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT, (USHORT) 3);
	for(Count = 0;Count < 8;Count += 2)
		NdisRawWritePortUshort(Adapter->IOBase + BANK3_MT01 + Count, *(&Adapter->HashTable[Count]));

    DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111<== MiniPort Change Address\r\n")));
    return(NDIS_STATUS_SUCCESS);
}



USHORT    MakeHash(NETWORK_ADDRESS *Address)
{
    UINT    crc = (UINT) 0xffffffff;
    USHORT  i;
    USHORT  j;
    USHORT  carry;
    PUCHAR  Multi = (PUCHAR) Address;
    UCHAR   Temp;
	
    for (i = 0; i < 6; i++)
    {
        Temp = *Multi++;
        for (j = 0; j < 8; j++)
        {
            carry = ((crc & 0x80000000) ? 1 : 0) ^ (Temp & 0x01);
            crc <<= 1;
            Temp >>= 1;
            if (carry) crc = (crc ^ 0x04c11db6) | carry;
        }
    }
	
	//High order 6 bits are hash value.
    return((USHORT) (crc >> 26));
}


void    SetHash(MINIPORT_ADAPTER *Adapter,
                USHORT            HashValue)
{
    PUCHAR      WhichByte;      //  Pick byte out of array
    UCHAR       WhichBit;       //  Pick out bit
	
    WhichByte = (UCHAR *) ((&(Adapter->HashTable[0])) + (HashValue >> 3));
    WhichBit  = (UCHAR) (1 << (HashValue & 7));
	
    *WhichByte |= WhichBit;
	
    return;
}

NDIS_STATUS CopyInfo(UCHAR *InformationBuffer,
                     UCHAR *Source,
                     UINT   BufferLength,
                     UINT   BytesToMove,
                     UINT  *BytesWritten,
                     UINT  *BytesNeeded)
{
    NDIS_STATUS Status = NDIS_STATUS_SUCCESS;
	
    if(BufferLength < BytesToMove)
    {
		DEBUGMSG(ZONE_INIT, (TEXT("Query Buffer is too small!\r\n")));		
        *BytesNeeded = BytesToMove;
        BytesToMove  = BufferLength;
        Status       = NDIS_STATUS_INVALID_LENGTH;
    }
	
    NdisMoveMemory(InformationBuffer,Source,BytesToMove);
	
    *BytesWritten = BytesToMove;	
	return(Status);
}