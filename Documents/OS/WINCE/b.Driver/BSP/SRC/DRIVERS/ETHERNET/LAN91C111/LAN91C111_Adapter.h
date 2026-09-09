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
 *Description
 *              Hardware specific and driver datastructure declarations
 *
 */
#ifndef __LAN91C111_ADAPTER__
#define __LAN91C111_ADAPTER__

//Windows CE debug zones
#define ZONE_ERROR      DEBUGZONE(0)
#define ZONE_WARN       DEBUGZONE(1)
#define ZONE_FUNCTION   DEBUGZONE(2)
#define ZONE_INIT       1 //
#define ZONE_INTR       DEBUGZONE(4)
#define ZONE_RCV        DEBUGZONE(5)
#define ZONE_XMIT       DEBUGZONE(6)

//NDIS Version Declaration
#define DRIVER_NDIS_MAJOR_VERSION 5
#define DRIVER_NDIS_MINOR_VERSION 0

#define DRIVER_NDIS_VERSION        ((DRIVER_NDIS_MAJOR_VERSION << 8) + DRIVER_NDIS_MINOR_VERSION)


//---------------MINIPORT PACKET RELATED--------------------------
//The MINIPORT Packet structure.  One per active send request.
typedef struct  _MINIPORT_PACKET
{
    struct _MINIPORT_PACKET *Next;       //  Next packet on queue.
    UCHAR                   PacketNumber;//  Adapter Packet number.
	USHORT					PacketRange;
} MINIPORT_PACKET;
#define MINIPORT_PACKET_SIZE     sizeof(MINIPORT_PACKET)

//The MINIPORT packet queue structur and macros
typedef struct _MINIPORT_PACKET_QUE
{
    MINIPORT_PACKET  *First;             //  First packet on queue or 0
    MINIPORT_PACKET  *Last;              //  Last packet on queue or &First
} MINIPORT_PACKET_QUE;
#define MAC_PACKET_QUE_SIZE sizeof(MAC_PACKET_QUE)

//The MAC receive context structure.
typedef struct  _MAC_RECEIVE_CONTEXT
{
    UINT            Range;          //  Packet size.
    UCHAR           *PacketData;    //  User data.
} MAC_RECEIVE_CONTEXT;
#define MAC_RECEIVE_CONTEXT_SIZE    sizeof(MAC_RECEIVE_CONTEXT)

//Hardware packet representation.
typedef  struct _SMC_PACK_HEADER
{
    USHORT     Status;
    USHORT     Range;
} SMC_PACK_HEADER;
#define SMC_PACK_HEADER_SIZE    sizeof(SMC_PACK_HEADER)

//Clear packet queue macro.
#define ClearPacketQue(Que) {(Que).First = (MINIPORT_PACKET *) 0;                \
	(Que).Last  = (MINIPORT_PACKET *) &(Que).First;}    \
	
//Test for empty queue macro.
#define IsPacketQueEmpty(Que)  (((Que).First) == (MINIPORT_PACKET *) 0)

//Add a packet to queue macro.
#define QuePacket(Que, _Packet)  {MINIPORT_PACKET *__Last = (Que).Last;   \
	_Packet->Next = (MINIPORT_PACKET *) 0;   \
__Last->Next = (Que).Last = _Packet;}

//Remove a packet from queue macro.
#define DequePacket(Que, Packet) {Packet = (Que).First;                                \
	if(((Que).First = Packet->Next) == (MINIPORT_PACKET *) 0) \
(Que).Last = (MINIPORT_PACKET *) &(Que).First;}        

//Sneak a look at the packet at the head of the queue macro.
#define PeekQue(Que, _Packet) {_Packet = (Que).First;}

//----------------------------------------------------------------

//Multicast Table Entry Structure
#define MAX_MULTICAST_ADDRESS   128

typedef struct 
{
	UINT  MulticastTableEntryCount;
	UCHAR MulticastTableEntry[MAX_MULTICAST_ADDRESS * ETH_LENGTH_OF_ADDRESS];
} MULTICAST_TABLE;


#define TOTAL_BUFFER_SIZE		0x2000
#define MAX_LOOKAHEAD_SIZE      1500
#define LOOK_AHEAD_BUFFER_SIZE  2048
#define MINIPORT_ADAPTER_SIZE   sizeof(MINIPORT_ADAPTER)
#define MAX_FRAME_DATA_SIZE     1500
#define MAX_FRAME_SIZE          ((USHORT)1514)
#define MIN_FRAME_SIZE          14
#define MIN_LEGAL_FRAME_SIZE    64
#define ETHERNET_HEADER_SIZE    14
#define MAC_ADDRESS_SIZE		6
#define MAX_MULTICAST_ADDRESS   128
#define PTR_WAIT                5       //  Loop count waiting after pointer load

#define AUTO_NEGOTIATION         0xFF
#define DEFAULT_VALUE            0xFE
#define FULL_DUPLEX              0x01
#define HALF_DUPLEX              0x00
#define SPEED10                  100000
#define SPEED100                 1000000

#define DEFAULT_IO_BASE         0x300   //  Platform Specific
#define DEFAULT_IRQ             10      //  Platform Specific
#define DEFAULT_MEDIA           0       //  Default media type

#define	CHIPID_LAN91C111		9
#define CHIPREV_LAN91C111_REVA  0
#define CHIPREV_LAN91C111_REVB  1


//--------------------- DRIVER STRUCTURE --------------------------------
typedef  struct _MINIPORT_ADAPTER
{
	NDIS_HANDLE             AdapterHandle;
	UINT					IOBase;				//  Platform Specific - type might have to be changed to accomodate platform specific values
	BOOLEAN                 IsPortRegistered;   //  I/O Port registere with NdisMRegisterIORage (...)
	NDIS_MINIPORT_INTERRUPT InterruptInfo;      //  From NdisMRegisterInterrupt(..)
	USHORT                  InterruptLevel;     //  IRQ in use
	BOOLEAN                 IsInterruptSet;     //  Attached to interrupt using NdisMRegisterInterrupt(...)
	USHORT					InterruptVector;
    USHORT					InterruptType;
	BOOLEAN                 Auto_Negotiation;
	USHORT                  BusType;
    USHORT                  BusNumber;
	USHORT					ConfigReg;          //  Config register to be output
	USHORT					ChipID;				//  Chip ID 
	USHORT					ChipRev;			//  Chip Revision

	UCHAR                   *LookAheadBuffer;   //  Pointer to lookahead buffer
	USHORT                  State;              //  Current state of the Adapter..
	NDIS_OID                LookAhead;          //  Max lookahead size
	BOOLEAN                 Sqet;               //  Enable/disable SQET monitoring
    UINT					Speed;				//  Speed ?? 10/100 
	UCHAR                   Duplex;				//  Duplex ?? FDX/HDX
	UCHAR			        MACAddress[6];		//  Current Station address
	UCHAR                   HashTable[8];       //  Multicast hash bits
	USHORT                  RCR;                //  Updated Receive Control Register.
	USHORT					TCR;				//  Updated Transmit Control Register.
	USHORT					CtrlRegister;
	BOOLEAN                 IsAllocateActive;   //  Is AllocateTxBuffer running?
	BOOLEAN                 IsDpcRunning;       //  Is DPC active?
	BOOLEAN                 AllocateFlag;       //  Allocation in progress
	BOOLEAN                 IsWriteActive;      //  Write in progress
	UINT                    XmitPending;        //  Packets in adapter memory
	UINT                    ChkHangCnt;
	USHORT					LinkStatus;			//  Link Status
	BOOLEAN					NeedIndComplete;	//	Recieve Complete indication
	BOOLEAN					RCVBroadcast;		//	If set recvs broadcasts.
	BOOLEAN					RCVAllMulticast;	//  Rcv All multicasts.
	BOOLEAN					PromiscuousMode;
	BOOLEAN					TxUnderRunFixed;
	MULTICAST_TABLE			MulticastTable;		//	Multicast Table

	MINIPORT_PACKET_QUE     AllocPending;       //  Outbound frames waiting for memory
    MINIPORT_PACKET_QUE     WritePending;       //  Waiting access to write routine
    MINIPORT_PACKET_QUE     AckPending;         //  Waiting completion intr
	NDIS_OID                TransmitQueueDepth; //  Packets on transmit queue
	UCHAR                   MaxXmits;           //  Cap on outstanding transmits

	//Required Statistics.
	UINT					Stat_TxOK;
	UINT					Stat_RxOK;
	UINT					Stat_TxError;
	UINT					Stat_RxError;
	UINT					Stat_RxOvrn;
	UINT					Stat_AlignError;
	UINT					Stat_SingleColl;
	UINT					Stat_MultiColl;

}MINIPORT_ADAPTER, *PMINIPORT_ADAPTER, *PSMSC_ADAPTER;


//-----------------  LAN91C111 Chip Specific Registry Declarations ---------

#define LAN91C111_CHIPID		 9
#define BANK_SELECT             14      //  Offset in IO space to Bank select
#define BANK_ID_MASK            0xff00  //  Mask constant part of bank register
#define BANK_UPPER              0x3300  //  Constant value for upper byte of bank register
#define BANK_MASK               (BANK_UPPER | 3)

//Bank 0 Registers
#define BANK0_TCR               0       //  Transmit control register
#define BANK0_STS               2       //  EPH status register 
#define BANK0_RCR               4       //  Receive control register
#define BANK0_CTR               6       //  Statistics counter register
#define BANK0_MIR               8       //  Memory information register
#define BANK0_RPCR              10      //  Memory configuration register
#define BANK0_RES               12      //  Reserved

//Bank 1 Registers
#define BANK1_CONFIG            0       //  Adapter configuration register
#define BANK1_BASE              2       //  IO Base address
#define BANK1_IA0               4       //  Current address bytes 0-1
#define BANK1_IA2               6       //  Current address bytes 2-3
#define BANK1_IA4               8       //  Current address bytes 4-5
#define BANK1_GEN               10      //  General purpose
#define BANK1_CTL               12      //  Control

//Bank 2 Registers
#define BANK2_MMU_CMD           0       //  MMU command register
#define BANK2_PNR               2       //  Packet Number Register (8 bit)
#define BANK2_ARR               3       //  Allocation Result Register (8 bit)
#define BANK2_FIFOS             4
#define BANK2_TX_FIFO           4       //  Transmit Fifo Port Register (8 bit)
#define BANK2_RX_FIFO           5       //  Receive Fifo Port Register (8 bit)
#define BANK2_PTR               6       //  Pointer Register
#define BANK2_DATA1             8       //  Data Register
#define BANK2_DATA2             10      //  Data Register
#define BANK2_INT_STS           12      //  Interrupt Status Register (8 bit, Read Only)
#define BANK2_INT_ACK           12      //  Interrupt Ack Register (8 bit, Write Only)
#define BANK2_INT_MSK           13      //  Interrupt Mask Register (8 bit, Read/Write)

//Bank 3 Registers
#define BANK3_MT01              0       //  Multicast Hash Table 0-1
#define BANK3_MT23              2       //  Multicast Hash Table 2-3
#define BANK3_MT45              4       //  Multicast Hash Table 4-5
#define BANK3_MT67              6       //  Multicast Hash Table 6-7
#define BANK3_MGMT              8       //  PHY management
#define BANK3_REV               10      //  Chip Id/Revision
#define BANK3_ERCV              12      //  Early receive configuration


//Masks for Transmit Control Register (BANK0_TCR)
#define TCR_SWFDUP              0x8000  //  Full Duplex Switched Ethernet
#define TCR_EPH_LOOP            0x2000  //  Loop at EPH block
#define TCR_STP_SQET            0x1000  //  Stop xmit on SQET error
#define TCR_FDUPLX              0x0800  //  Full duplex mode
#define TCR_MON_CSN             0x0400  //  Monitor carrier
#define TCR_NO_CRC              0x0100  //  Don't append CRC
#define TCR_PAD_EN              0x0080  //  Pad short frames
#define TCR_FOR_COL             0x0004  //  Force collision
#define TCR_LOOP                0x0002  //  Local loopback
#define TCR_TX_ENA              0x0001  //  Enable transmitter


//Masks for Receive Control Register (BANK0_RCR)
#define RCR_RESET               0x8000  //  Software reset
#define RCR_FILT_CAR            0x4000  //  Filter carrier for 12 bits
#define RCR_ABORT_ENB			0x2000	//  Enables abort of receive when collision occurs
#define RCR_STRP_CRC            0x0200  //  Strip CRC on received frames
#define RCR_RX_EN               0x0100  //  Enable receiver
#define RCR_ALL_MUL             0x0004  //  Accept all multicasts (no filtering)
#define RCR_PRMS                0x000  //  Promiscuous mode
#define RCR_ABORT               0x0001  //  Frame aborted (too long)


//Masks for Counter Register (BANK0_CTR)
#define CTR_EX_DFER             0xf000  //  Number of excessively deferred xmits
#define CTR_DFER                0x0f00  //  Number of deferred xmits
#define CTR_MCOL                0x00f0  //  Number of multiple collisions
#define CTR_COL                 0x000f  //  Number of single collisions

//Masks for Memory Information Register (BANK0_MIR)
#define MIR_FREE_MEM            0xff00  //  Memory available (* 256 bytes)
#define MIR_MEM_SIZE            0x00ff  //  Memory size (* 256 bytes)


//Masks for Receive/Phy Control Register (BANK0_RPCR)
#define RPCR_SPEED				0x2000  //  Speed select input
#define RPCR_DPLX				0x1000  //  Duplex Select
#define RPCR_ANEG				0x0800  //  Auto-Negotiation mode select
#define RPCR_LS2A				0x0080  //  LED Select Signal Enable
#define RPCR_LS1A				0x0040  //  LED Select Signal Enable
#define RPCR_LS0A				0x0020  //  LED Select Signal Enable

//Adapter Configuration Register (BANK1_CONFIG)
#define CFG_EPH_POW_EN          0x8000  //  =1 100mb port, =0 10mb port
#define CFG_NO_WAIT             0x1000  //  No wait states
#define CFG_GPCNTRL		        0x0400  //  Full step signalling to AUI
#define CFG_EXTPHY	            0x0200  //  Set squelch level

//Base Address Register (BANK1_BASE)
#define BASE_IO_ADR             0xff00  //  Mask IO base address (a15,a14,a13,a9,a8,a7,a6,a5)

//Configuration Control Register (BANK1_CTL)
#define CTL_RCV_BAD             0x4000  //  Receive bad CRC packets
#define CTL_AUTO                0x0800  //  Auto-release xmit memory
#define CTL_LE_EN               0x0080  //  Link error enable (mux into EPH int)
#define CTL_CR_EN               0x0040  //  Counter rollover enable (mux into EPH int)
#define CTL_TE_EN               0x0020  //  Xmit error enable (mux into EPH int)
#define CTL_EEPROM              0x0004  //  EEPROM select
#define CTL_RELOAD              0x0002  //  Reload from EEPROM
#define CTL_STORE               0x0001  //  Store to EEPROM

//MMU Command Register (BANK2_MMU_CMD)
#define MMUCMD_MSK              0x00e0  //  Mask out command
#define MMUCMD_MEM_SZ           0x0007  //  Mask size of request (if cmd = alloc)  amount = (value + 1) * 256 bytes
#define MMUCMD_BUSY             0x0001  //  MMU busy don't mod PNR

//MMU Commands
#define CMD_NOP                 0       //  No-Op command
#define CMD_ALLOC               0x0020  //  Allocate memory
#define CMD_RIS                 0x0040  //  Reset to initial state
#define CMD_REM_TOP             0x0060  //  Remove frame from top of RX fifo
#define CMD_REM_TXFIFO          0x0070  //  Remove top of TX fifo to Tx Completion Fifo
#define CMD_REM_REL_TOP         0x0080  //  Remove and release top of RX fifo
#define CMD_REL_SPEC            0x00a0  //  Release specific packet
#define CMD_ENQ_TX              0x00c0  //  Enqueue to xmit fifo
#define CMD_ENQ_RX              0x00e0  //  Reset xmit fifos (should only be done with transmitter disabled)

//Allocation Result Register (BANK2_ARR)  This is an 8 bit register
#define ARR_FAIL                0x80    //  Allocation failed
#define ARR_ALLOC_MSK           0x7f    //  Mask allocated packet number

//Fifo Port Registers (BANK2_TX_FIFO, BANK2_RX_FIFO)  These are 8 bit registers
#define FIFO_EMPTY              0x0080    //  No packet at top of fifo
#define FIFO_RX_EMPTY           0x8000	  //  Recieve FIFO Empty when set
#define FIFI_MASK               0x007f    //  Mask top packet number

//Pointer Register (BANK2_PTR)
#define PTR_RCV                 0x8000  //  Access is to receive area
#define PTR_AUTO                0x4000  //  Auto-increment on access
#define PTR_READ                0x2000  //  =1 then read operation =0 then write operation
#define PTR_ETEN                0x1000  //  Detect early transmit underrun
#define PTR_AUTO_TX             0x0800  //  Write fifo not empty
#define PTR_NOT_EMPTY           0x0800  //  Write fifo not empty
#define PTR_OFFSET              0x03ff  //  Mask pointer value

//Interrupt Registers (BANK2_INT_STS, BANK2_INT_ACK, BANK2_INT_MSK)
#define INT_MDINT				0x80	//  91C111 MDINT interrupt
#define INT_EARLY_RX            0x40    //  Early receive
#define INT_EPH_INT             0x20    //  EPH type interrupt
#define INT_RX_OVRN             0x10    //  Receive overrun interrupt
#define INT_ALLOC               0x08    //  Allocation interrupt
#define INT_TXF_EMPTY           0x04    //  Xmit fifo empty interrupt
#define INT_TX_CMP              0x02    //  Xmit complete interrupt
#define INT_RX_CMP              0x01    //  Receive complete interrupt

#define ENABLED_INTS			(INT_MDINT | INT_TX_CMP | INT_RX_CMP | INT_EPH_INT | INT_RX_OVRN)

//Isolate packet number in PNR
#define PNR_MASK                0x7f

//Management Interface Register (BANK3_MGMT)
#define MGMT_MDOE               0x0008  //  Output enable
#define MGMT_MCLK               0x0004  //  Drive MDCLK 
#define MGMT_MDI                0x0002  //  Read MDI pin
#define MGMT_MDO                0x0001  //  Write MDO pin

//Revision Register (BANK3_REV)
#define REV_CHIP_ID             0x00f0  //  Mask chip ID
#define REV_REV_ID              0x000f  //  Mask chip revision.

#define CHIP_ID_111				0x0009	//  Chip is 91c111/113

//Early Receive Register (Bank3_Ercv)
#define ERCV_DISCARD            0x0080  //  Discard packet being received
#define ERCV_THRESHOLD          0x001f  //  Threshold for ERCV-INT in 64 byte units

#define DEFAULT_CONFIGURATION	0xA0B1  //  Bank1/Offset0

//Phy Register Definitions
#define PHY_MASK_BASE			 0xFFC0
#define PHY_MASK_INT			 ~0x8000
#define PHY_MASK_LINK			 ~0x4000

//Receive frame status word
#define RFS_ALIGN               0x8000  //  Frame alignment error
#define RFS_BCAST               0x4000  //  Frame was broadcast
#define RFS_CRC                 0x2000  //  Frame CRC error
#define RFS_ODD                 0x1000  //  Frame has odd byte count
#define RFS_LONG                0x0800  //  Frame was too long
#define RFS_SHORT               0x0400  //  Frame was too short
#define RFS_MCAST               0x0001  //  Frame was multicast
#define RFS_HASH                0x00fe  //  Mask hash value (multicast)
#define RFS_ERROR				(RFS_ALIGN | RFS_CRC | RFS_LONG | RFS_SHORT)
#define FRAME_OVERHEAD          6       //  Overhead bytes for adapter control

//Transmit frame status word (Same masks used for EPH status register)
#define TFS_UNDERRUN            0x8000  //  Frame uderrun
#define TFS_LINKERROR           0x4000  //  10BASET link error condition
#define TFS_RXOVERRUN           0x2000  //  Receiver overrun
#define TFS_COUNTER             0x1000  //  Counter roll over
#define TFS_EXDEFER             0x0800  //  Excessive deferral
#define TFS_CARRIER             0x0400  //  Carrier not present
#define TFS_LATE                0x0200  //  Late collision
#define TFS_DEFER               0x0080  //  Frame was deferred
#define TFS_BCAST               0x0040  //  Last frame was broadcast
#define TFS_SQET                0x0020  //  Signal Quality Error
#define TFS_16COL               0x0010  //  Too many collisions
#define TFS_MCAST               0x0008  //  Last frame was multicast
#define TFS_MULTICOL            0x0004  //  Multiple collisions on last frame
#define TFS_1COL                0x0002  //  Single collision on last frame
#define TFS_OKAY                0x0001  //  Frame successfully transmitted
#define TFS_ERROR   (TFS_UNDERRUN | TFS_EXDEFER | TFS_CARRIER | TFS_LATE | TFS_16COL)

//Frame send/receive control byte
#define CTL_BYTE_ODD            0x20    //  Frame ends on odd byte boundary
#define CTL_BYTE_CRC            0x10    //  Append CRC on xmit


//------------------------ GLOBAL OID ------------------------------
//Supported OIDs
static  const NDIS_OID GlobalObjects[] = 
{
    OID_GEN_SUPPORTED_LIST,
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
    OID_GEN_CURRENT_LOOKAHEAD,
    OID_GEN_DRIVER_VERSION,
    OID_GEN_MAXIMUM_TOTAL_SIZE,
    OID_GEN_MAC_OPTIONS,
	OID_GEN_HARDWARE_STATUS,
	OID_GEN_CURRENT_PACKET_FILTER,
    OID_802_3_PERMANENT_ADDRESS,
    OID_802_3_CURRENT_ADDRESS,
    OID_802_3_MULTICAST_LIST,
    OID_802_3_MAXIMUM_LIST_SIZE,
	OID_802_3_RCV_ERROR_ALIGNMENT,
    OID_802_3_XMIT_ONE_COLLISION,
    OID_802_3_XMIT_MORE_COLLISIONS,
    OID_GEN_MAXIMUM_SEND_PACKETS,
	OID_GEN_VENDOR_DRIVER_VERSION,
	OID_GEN_MEDIA_CONNECT_STATUS,
	OID_GEN_XMIT_OK,
	OID_GEN_RCV_OK,
	OID_GEN_XMIT_ERROR,
	OID_GEN_RCV_ERROR,
	OID_GEN_RCV_NO_BUFFER
};

//OID Return Strings
//OID Query return strings.
#define DRV_VENDOR_NAME			"SMSC-LAN91C111 Ethernet Adapter"
#define SIZE_DRV_VENDOR_NAME    sizeof(DRV_VENDOR_NAME)

//Status
#define MEDIA_CONNECTED		0x01
#define MEDIA_DISCONNECTED	0x02

//Defines possible states for MAC structures.
typedef enum    _STATE_TYPE
{
		VOID_STATE,                        // Illegal value.
		INITIALIZING_STATE,                // Structure is being built.
		NORMAL_STATE,                      // Operational state.		
		RESET_STATE
} STATE_TYPE;

#define MMU_WAIT                10      //  Loop count waiting for memory allocation

#endif _LAN91C111_ADAPTER_