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
 *Description
 *      Function prototypes
 *
 *
 */
#ifndef __LAN91C111_PROTO__
#define __LAN91C111_PROTO__

#include <NDIS.H>

VOID		LAN91C111_MiniportHalt		(NDIS_HANDLE MiniportAdapterContext);


VOID		LAN91C111_MiniPortHandleInterrupt	(IN NDIS_HANDLE  AdapterContext);


NDIS_STATUS LAN91C111_MiniportInitialize(
											PNDIS_STATUS	OpenErrorStatus,
											PUINT			SelectedMediumIndex,
											PNDIS_MEDIUM	MediumArray,
											UINT			MediumArraySize,
											NDIS_HANDLE		MiniportAdapterHandle,
											NDIS_HANDLE		WrapperConfigurationContext
										);


VOID		LAN91C111_MiniportISR		(
											PBOOLEAN    InterruptRecognized,
											PBOOLEAN    QueueMiniportHandleInterrupt,
											NDIS_HANDLE MiniportAdapterContext
										);


NDIS_STATUS LAN91C111_MiniportQueryInformation(
											NDIS_HANDLE AdapterContext,
											NDIS_OID    Oid,
											PVOID       InformationBuffer,
											ULONG       InformationBufferLength,
											PULONG      BytesWritten,
											PULONG      BytesNeeded
											);

NDIS_STATUS	LAN91C111_MiniportReset		(
											PBOOLEAN    AddressingReset,
											NDIS_HANDLE AdapterContext
										);


NDIS_STATUS LAN91C111_MiniportSend		(
											NDIS_HANDLE  AdapterContext,
											PNDIS_PACKET Packet,
											UINT         Flags
										);
 

NDIS_STATUS LAN91C111_MiniportSetInformation(
											NDIS_HANDLE MiniportAdapterContext,
											NDIS_OID Oid,
											PVOID InformationBuffer,
											ULONG InformationBufferLength,
											PULONG BytesRead,
											PULONG BytesNeeded
											);

NDIS_STATUS LAN91C111_MiniportTransferData(
											PNDIS_PACKET Packet,
											PUINT BytesTransferred,
											NDIS_HANDLE MiniportAdapterContext,
											NDIS_HANDLE MiniportReceiveContext,
											UINT ByteOffset,
											UINT BytesToTransfer
											);

VOID		LAN91C111_MiniportEnableInterrupt(
											NDIS_HANDLE MiniportAdapterContext
											);

VOID		LAN91C111_MiniportDisableInterrupt(
											NDIS_HANDLE MiniportAdapterContext
											 );

VOID	    MD_Interrupt_Handler			(MINIPORT_ADAPTER *Adapter);
VOID		EPH_Interrupt_Handler			(MINIPORT_ADAPTER *Adapter);
VOID		RX_OVRN_Interrupt_Handler		(MINIPORT_ADAPTER *Adapter);
VOID		ALLOC_Interrupt_Handler			(MINIPORT_ADAPTER *Adapter);
VOID		TX_Interrupt_Handler			(MINIPORT_ADAPTER *Adapter);
VOID		RCV_Interrupt_Handler			(MINIPORT_ADAPTER *Adapter);

UINT		ReadPhyRegister					(
											UINT IOBase, 
											UCHAR  PhyReg
											);

void		WritePhyRegister				( 
											UINT IOBase, 
											UCHAR  PhyReg, 
											USHORT Value
											);

BOOLEAN		EstablishLink					(MINIPORT_ADAPTER *Adapter);

VOID		AdapterWrite					(MINIPORT_ADAPTER *Adapter,
											 MINIPORT_PACKET  *Packet);

BOOLEAN		AllocateTxBuffer				(MINIPORT_ADAPTER  *Adapter,  
											 MINIPORT_PACKET  **Packet);

VOID		DumpRegisters					(MINIPORT_ADAPTER *Adapter);

NDIS_STATUS MiniPortChangeFilter			(
											 MINIPORT_ADAPTER   *Adapter,
											NDIS_OID            NewFilter);

NDIS_STATUS MiniPortChangeAddresses			(
											 MINIPORT_ADAPTER *Adapter,
											 UCHAR            *AddressList,
											 UINT              AddressCount);


#endif