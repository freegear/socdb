//
// Copyright (c) Microsoft Corporation.  All rights reserved.
//
//
// Use of this source code is subject to the terms of the Microsoft end-user
// license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
// If you did not accept the terms of the EULA, you are not authorized to use
// this source code. For a copy of the EULA, please see the LICENSE.RTF on your
// install media.
//
//------------------------------------------------------------------------------
//
//  File: Smscxxx.c
//
//  This file implements ethernet debug driver for SMSC LAN91Cxxx network chip.
//
#include <windows.h>
#include <halether.h>
#if 1 //shkim 2006/10/13 : don't need to include oal.h
#include <ceddk.h>
#else
#include <oal.h>
#endif

//------------------------------------------------------------------------------
// Types

typedef struct {
    union {
        struct {            // Bank 0
            UINT16 TCR;     // 0000
            UINT16 EPHSR;   // 0002
            UINT16 RCR;     // 0004
            UINT16 ECR;     // 0006
            UINT16 MIR;     // 0008
            UINT16 MCRPCR;  // 000A
        };
        struct {            // Bank 1
            UINT16 CR;      // 0000
            UINT16 BAR;     // 0002
            UINT16 IAR0;    // 0004
            UINT16 IAR1;    // 0006
            UINT16 IAR2;    // 0008
            UINT16 GPR;     // 000A
            UINT16 CTR;     // 000C
        };
        struct {            // Bank 2
            UINT16 MMUCR;   // 0000
            UINT16 PNRARR;  // 0002
            UINT16 FIFO;    // 0004
            UINT16 PTR;     // 0006
            UINT16 DATA;    // 0008
            UINT16 DATAEX;  // 000A
            UINT16 INTR;    // 000C
        };
        struct {            // Bank 3
            UINT16 MT[4];   // 0000
            UINT16 MGMT;    // 0008
            UINT16 REV;     // 000A
            UINT16 ERDV;    // 000C
        };
    };
    UINT16 BANKSEL;         // 000E
} LAN91C_REGS;

//------------------------------------------------------------------------------
// Defines 
#define TIMEOUT_VALUE           2000        // 2 seconds.

#define CTR_STORE               (1 << 0)
#define CTR_RELOAD              (1 << 1)
#define CTR_TEEN                (1 << 5)
#define CTR_CREN                (1 << 6)
#define CTR_LEEN                (1 << 7)
#define CTR_BIT8                (1 << 8)
#define CTR_AR                  (1 << 11)

#define CR_SETSQLCH             (1 << 9)
#define CR_NOWAIT               (1 << 12)

#define TCR_TXEN                (1 << 0)
#define TCR_PADEN               (1 << 7)
#define TCR_SWFDUP              (1 << 15)

#define RCR_PRMS                (1 << 1)
#define RCR_ALMUL               (1 << 2)
#define RCR_RXEN                (1 << 8)
#define RCR_STRIP_CRC           (1 << 9)

#define INTR_RX                 (1 << 0)
#define INTR_TX                 (1 << 1)
#define INTR_TX_EMPTY           (1 << 2)
#define INTR_ALLOC              (1 << 3)
#define INTR_RX_OVRN            (1 << 4)
#define INTR_EPH                (1 << 5)
#define INTR_ERCV               (1 << 6)
#define INTR_TX_IDLE            (1 << 7)
#define INTR_RX_MASK            (1 << 8)
#define INTR_TX_MASK            (1 << 9)
#define INTR_TX_EMPTY_MASK      (1 << 10)
#define INTR_ALLOC_MASK         (1 << 11)
#define INTR_RX_OVRN_MASK       (1 << 12)
#define INTR_EPH_MASK           (1 << 13)
#define INTR_ERCV_MASK          (1 << 14)
#define INTR_TX_IDLE_MASK       (1 << 15)

#define EPH_STAT_TXSUC          (1 << 0)
#define EPH_STAT_SNGLCOL        (1 << 1)
#define EPH_STAT_MULTCOL        (1 << 2)
#define EPH_STAT_LTXMULT        (1 << 3)
#define EPH_STAT_16COL          (1 << 4)
#define EPH_STAT_SQET           (1 << 5)
#define EPH_STAT_LTXBRD         (1 << 6)
#define EPH_STAT_TXDEFR         (1 << 7)
#define EPH_STAT_LATCOL         (1 << 9)
#define EPH_STAT_LOSTCARR       (1 << 10)
#define EPH_STAT_EXCDEV         (1 << 11)
#define EPH_STAT_CTRROLL        (1 << 12)
#define EPH_STAT_LINKOK         (1 << 14)
#define EPH_STAT_TXUNRN         (1 << 15)

#define PTR_RCV                 (1 << 15)
#define PTR_AUTOINC             (1 << 14)
#define PTR_READ                (1 << 13)

#define MMUCR_BUSY              (1 << 0)    // MMU busy, don't modify PNR
#define MMUCR_NOP               (0 << 4)    // No-Op command
#define MMUCR_ALLOC             (2 << 4)    // Allocate memory
#define MMUCR_RESET             (4 << 4)    // Reset MMU to initial state
#define MMUCR_REM_TOP           (6 << 4)    // Remove frame from top of RX fifo
#define MMUCR_REM_REL_TOP       (8 << 4)    // Remove and release top of RX fifo
#define MMUCR_REL_SPEC          (10 << 4)   // Release specific packet
#define MMUCR_ENQ_TX            (12 << 4)   // Enqueue to xmit fifo
#define MMUCR_ENQ_RX            (14 << 4)   // Reset xmit fifos

#define MMUCR_111_ALLOC_TX      (1 << 5)    // Allocate Tx memory
#define MMUCR_111_RESET_MMU     (2 << 5)    // Reset the MMU
#define MMUCR_111_REMOVE_RX     (3 << 5)    // Delete top Rx FIFO buffer
#define MMUCR_111_REM_REL_RX    (4 << 5)    // Delete and release Rx FIFO buffer
#define MMUCR_111_RELEASE_RX    (5 << 5)    // Release Rx buffer memory
#define MMUCR_111_RELEASE_TX    (5 << 5)    // Release Tx buffer memory
#define MMUCR_111_ENQUEUE       (6 << 5)    // Queue Tx buffer
#define MMUCR_111_RESET_TX      (7 << 5)    // 

#define STAT_ALGNERR            (1 << 15)
#define STAT_BADCRC             (1 << 13)
#define STAT_LONG               (1 << 11)
#define STAT_SHORT              (1 << 10)

#define CTRL_ODD                (1 << 13)
#define CTRL_CRC                (1 << 12)

#define MGMT_MDO                (1 << 0)
#define MGMT_MDI                (1 << 1)
#define MGMT_MCLK               (1 << 2)
#define MGMT_MDOE               (1 << 3)
#define MGMT_MSK_CRS100         (3 << 14)

#define EPHSR_LINKOK            (1 << 14)

// PHY register definitions.
#define CONTROL_MII_DIS         0x3000
#define CONTROL_LPBK            0x7000

#define GET_CHIP_ID(a)          ((a >> 4) & 0xF)
#define GET_REV_ID(a)           (a & 0xF)

#define CHIP_ID_LAN91C90        3
#define CHIP_ID_LAN91C92        3
#define CHIP_ID_LAN91C94        4
#define CHIP_ID_LAN91C95        5
#define CHIP_ID_LAN91C96        4           // revision ID starts at 6
#define CHIP_ID_LAN91C100       7
#define CHIP_ID_LAN91C100FD     8
#define CHIP_ID_LAN91C110       9
#define CHIP_ID_LAN91C111       9

//------------------------------------------------------------------------------
// Local Variables 

static LAN91C_REGS *g_pLAN91C;
static UINT16 g_chipRevision;

//------------------------------------------------------------------------------
// Local Functions 

static UINT32 Crc(UINT8 *pAddress);
static VOID PhyWrite(UINT8 address, UINT8 reg, UINT16 data);
static VOID Smsc91CStall(UINT32 microSec);
static UINT32 Smsc91CGetTickCount();

//------------------------------------------------------------------------------
#if 1 //shkim 2006/10/13
//------------------------------------------------------------------------------
// Macros for reading and writing a register in the SMSC91C
//
#define INPORT16(x)         READ_PORT_USHORT(x)
#define OUTPORT16(x, y)     WRITE_PORT_USHORT(x,(USHORT)(y))
#define SETPORT16(x, y)     OUTPORT16(x, INPORT16(x)|(y))
#define CLRPORT16(x, y)     OUTPORT16(x, INPORT16(x)&~(y))
#endif

//------------------------------------------------------------------------------
BOOL Smsc91CInit(BYTE *pAddress, DWORD offset, USHORT mac[3])
{
    BOOL rc = FALSE;

    EdbgOutputDebugString(
        "+Smsc91CInit(0x%08x, 0x%08x, 0x%08x)\r\n", pAddress, offset, mac
    );

    // Save address
    g_pLAN91C = (LAN91C_REGS*)pAddress;
#if 1 //shkim 2006/10/11
    // Chip settle time.
    Smsc91CStall(750);
#endif
    // Verify that network chip can be detected
    if ((INPORT16(&g_pLAN91C->BANKSEL) & 0xFF00) != 0x3300) {

        EdbgOutputDebugString (
            "ERROR: Smsc91CInit: Network Chip not found at 0x%08x\r\n", pAddress
        );
        goto cleanUp;
    }

    // Select bank 3 and read the chip ID and revision.
    OUTPORT16(&g_pLAN91C->BANKSEL, 3);
    g_chipRevision = INPORT16(&g_pLAN91C->REV);
    EdbgOutputDebugString(
        "LAN91Cxxx: Chip Id %d Revision %d\r\n", 
        GET_CHIP_ID(g_chipRevision), GET_REV_ID(g_chipRevision)
    );
           
    // Select bank 1    
    OUTPORT16(&g_pLAN91C->BANKSEL, 1);

    // Wait until reset & EEPROM load is done
    OUTPORT16(&g_pLAN91C->CTR, CTR_RELOAD);
    while ((INPORT16(&g_pLAN91C->CTR) & (CTR_RELOAD|CTR_STORE)) != 0);

    // Get MAC address from chip
    mac[0] = INPORT16(&g_pLAN91C->IAR0);
    mac[1] = INPORT16(&g_pLAN91C->IAR1);
    mac[2] = INPORT16(&g_pLAN91C->IAR2);

    // Initialize the control register
    switch (GET_CHIP_ID(g_chipRevision)) {
    case CHIP_ID_LAN91C111:
        OUTPORT16(&g_pLAN91C->CTR, CTR_TEEN);
        // The LAN91C111's internal PHY is disabled at boot time - enable it.
        PhyWrite(0, 0, CONTROL_MII_DIS);
        // Enable auto-negotiation of link speed.
        OUTPORT16(&g_pLAN91C->BANKSEL, 0);
        OUTPORT16(&g_pLAN91C->MCRPCR, 0x0800);
        break;
    default:
        // Set SQUELCH & NO WAIT bits
        OUTPORT16(&g_pLAN91C->BANKSEL, 1);
        SETPORT16(&g_pLAN91C->CR, CR_SETSQLCH|CR_NOWAIT);
        OUTPORT16(&g_pLAN91C->CTR, CTR_BIT8|CTR_TEEN);
        // Memory configuration register value.
        OUTPORT16(&g_pLAN91C->BANKSEL, 0);
        OUTPORT16(&g_pLAN91C->MCRPCR, 0x0006);
    }

    // Initialize transmit control register
    OUTPORT16(&g_pLAN91C->BANKSEL, 0);
    OUTPORT16(&g_pLAN91C->TCR, TCR_SWFDUP|TCR_PADEN|TCR_TXEN);

    // Initialize interrupt mask register (all ints disabled to start)
    OUTPORT16(&g_pLAN91C->BANKSEL, 2);
    OUTPORT16(&g_pLAN91C->INTR, 0);

    // Initialize the Receive Control Register
    OUTPORT16(&g_pLAN91C->BANKSEL, 0);
    OUTPORT16(&g_pLAN91C->RCR, RCR_RXEN|RCR_STRIP_CRC);

    // We are done
    rc = TRUE;

cleanUp:
    EdbgOutputDebugString(
        "-Smsc91CInit(mac = %02x:%02x:%02x:%02x:%02x:%02x, rc = %d)\r\n",
        mac[0]&0xFF, mac[0]>>8, mac[1]&0xFF, mac[1]>>8, mac[2]&0xFF, mac[2]>>8,
        rc
    );

    return rc;
}


//------------------------------------------------------------------------------

UINT16 Smsc91CSendFrame(BYTE *pBuffer, DWORD length)
{
    UINT16 rc = 0;
    UINT16 bufferSize, frameHandle;
    UINT16 packetNumber;
#if 1 //shkim 2006/10/11
    UINT32 startTime;
#endif
    static BOOLEAN bAllocRequest = FALSE;

    // Calculate the amount of memory needed (must be an even number)
    bufferSize = 2 + 2 + (UINT16)length + 1;
    if ((bufferSize & 1) != 0) bufferSize++;

    switch (GET_CHIP_ID(g_chipRevision)) {
    case CHIP_ID_LAN91C111:
        // Make sure there's enough free Tx memory.
        OUTPORT16(&g_pLAN91C->BANKSEL, 0);
        if ((INPORT16(&g_pLAN91C->MIR) >> 8) == 0) {
            // No memory?  Reset the MMU.
            OUTPORT16(&g_pLAN91C->BANKSEL, 2);
            OUTPORT16(&g_pLAN91C->MMUCR, MMUCR_111_RESET_MMU);
            while ((INPORT16(&g_pLAN91C->MMUCR) & MMUCR_BUSY) != 0);

            bAllocRequest = FALSE;
        }
        // Allocate memory in the buffer for the frame
        OUTPORT16(&g_pLAN91C->BANKSEL, 2);
        if (!bAllocRequest)
        {
            OUTPORT16(&g_pLAN91C->MMUCR, MMUCR_111_ALLOC_TX);
            bAllocRequest = TRUE;
        }
        break;
    default:
        // Allocate memory in the buffer for the frame
        OUTPORT16(&g_pLAN91C->BANKSEL, 2);
        OUTPORT16(&g_pLAN91C->MMUCR, MMUCR_ALLOC|(bufferSize >> 8));
    }

#if 1 //shkim 2006/10/11
    // Loop until the request is satisfied
    startTime = Smsc91CGetTickCount();
    while ((Smsc91CGetTickCount() - startTime) < TIMEOUT_VALUE)
    {
        if (INPORT16(&g_pLAN91C->INTR) & INTR_ALLOC)
        {
            break;
        }
    }
#endif    
    // If we couldn't satisfy the allocation, abort - we'll give the
    // receive side time to free up some space in the MMU, then we'll
    // re-check whether the allocation succeeded on the next call.
    if ((INPORT16(&g_pLAN91C->INTR) & INTR_ALLOC) == 0)
    {
        EdbgOutputDebugString("ERROR: Smsc91CSendFrame: Timed out allocating frame.\r\n");
        return(1);
    }

    bAllocRequest = FALSE;

    // Make sure the allocation didn't fail.
    if (INPORT16(&g_pLAN91C->PNRARR) & 0x8000)
    {
        EdbgOutputDebugString("ERROR: Smsc91CSendFrame: Failed to allocate frame.\r\n");
        return(1);
    }

    // Get frame handle
    frameHandle = (0x3f00 & INPORT16(&g_pLAN91C->PNRARR)) >> 8;

    // Now write the frame into the buffer
    OUTPORT16(&g_pLAN91C->PNRARR, frameHandle);
    OUTPORT16(&g_pLAN91C->PTR, PTR_AUTOINC);

    // Write status word
    OUTPORT16(&g_pLAN91C->DATA, 0);
    // Write the buffer size
    OUTPORT16(&g_pLAN91C->DATA, bufferSize);

    // Now write all except possibly the last data byte
    while (length > 1) {
        OUTPORT16(&g_pLAN91C->DATA, *(UINT16*)pBuffer);
        pBuffer += sizeof(UINT16);
        length -= sizeof(UINT16);
    }

    if (length > 0) {
        // If length was odd we can put that just before the control byte
        OUTPORT16(&g_pLAN91C->DATA, *pBuffer|CTRL_ODD|CTRL_CRC);
    } else {
        // Otherwise just pad the last byte with 0
        OUTPORT16(&g_pLAN91C->DATA, CTRL_CRC);
    }        

    // Enqueue Frame number into TX FIFO
    switch (GET_CHIP_ID(g_chipRevision)) {
    case CHIP_ID_LAN91C111:
        OUTPORT16(&g_pLAN91C->MMUCR, MMUCR_111_ENQUEUE);
        break;
    default:        
        OUTPORT16(&g_pLAN91C->MMUCR, MMUCR_ENQ_TX);
    }
#if 1 //shkim 2006/10/11
    // Wait until it is sent or an error is generated.
    startTime = Smsc91CGetTickCount();
    while ((Smsc91CGetTickCount() - startTime) < TIMEOUT_VALUE)
    {
        if (INPORT16(&g_pLAN91C->INTR) & INTR_TX)
        {
            break;
        }
    }
#endif    

    if ((INPORT16(&g_pLAN91C->INTR) & INTR_TX) == 0)
    {
        EdbgOutputDebugString("ERROR: Smsc91CSendFrame: Timed out waiting for the transfer to complete.\r\n");
        return(1);
    }

	// Read TXDONE Pkt# from FIFO Port Register
    OUTPORT16(&g_pLAN91C->BANKSEL, 2);
    packetNumber = (INPORT16(&g_pLAN91C->FIFO) & 0x3F);

	// Write to Packet Number Register
    OUTPORT16(&g_pLAN91C->PNRARR, packetNumber);

	// Retrieve packet status
    OUTPORT16(&g_pLAN91C->PTR, (PTR_AUTOINC | PTR_READ));
#if 1 //shkim 2006/10/11
    Smsc91CStall(100);
#endif    
    rc = INPORT16(&g_pLAN91C->DATA);

	// Release the packet
    switch (GET_CHIP_ID(g_chipRevision)) {
    case CHIP_ID_LAN91C111:
        OUTPORT16(&g_pLAN91C->MMUCR, MMUCR_111_RELEASE_TX);
        break;
    default:            
        OUTPORT16(&g_pLAN91C->MMUCR, MMUCR_REL_SPEC);
    }
    while ((INPORT16(&g_pLAN91C->MMUCR) & MMUCR_BUSY) != 0);

	// Clear the tx interrupt status
    SETPORT16(&g_pLAN91C->INTR, INTR_TX);

    // Tx error?
    if (rc & (EPH_STAT_TXUNRN | EPH_STAT_SQET | EPH_STAT_LOSTCARR | EPH_STAT_LATCOL | EPH_STAT_16COL))
    {
        // Display error status.
        EdbgOutputDebugString("ERROR: Smsc91CSendFrame: status = ( ");
        if (rc & EPH_STAT_TXUNRN)
        {
            EdbgOutputDebugString("TXUNRN ");
        }
        if (rc & EPH_STAT_SQET)
        {
            EdbgOutputDebugString("SQET ");
        }
        if (rc & EPH_STAT_LOSTCARR)
        {
            EdbgOutputDebugString("LOSTCARR ");
        }
        if (rc & EPH_STAT_LATCOL)
        {
            EdbgOutputDebugString("LATCOL ");
        }
        if (rc & EPH_STAT_16COL)
        {
            EdbgOutputDebugString("16COL ");
        }
        EdbgOutputDebugString(")\r\n");
            
        // Re-enable TXENA
        OUTPORT16(&g_pLAN91C->BANKSEL, 0);
        OUTPORT16(&g_pLAN91C->TCR, TCR_SWFDUP|TCR_PADEN|TCR_TXEN);

        // Failure.
        rc = 1;
    }
    else
    {
        // Success.
        rc = 0;
    }

    // Clear the statistics registers
    OUTPORT16(&g_pLAN91C->BANKSEL, 0);
    INPORT16(&g_pLAN91C->ECR);

    // Set back bank 2
    OUTPORT16(&g_pLAN91C->BANKSEL, 2);

    return rc;
}

//------------------------------------------------------------------------------

UINT16 Smsc91CGetFrame(BYTE *pBuffer, UINT16 *pLength)
{
    UINT8 *pos = pBuffer;
    UINT16 code, pointer;
    UINT32 length, count; 

    // Make sure that bank 2 is actual
    OUTPORT16(&g_pLAN91C->BANKSEL, 2);

    length = 0;
    while ((INPORT16(&g_pLAN91C->INTR) & INTR_RX) != 0) {

        // Setup pointer address register
        pointer = PTR_RCV | PTR_READ;

        // Read status
        OUTPORT16(&g_pLAN91C->PTR, pointer);
        code = INPORT16(&g_pLAN91C->DATA);
        pointer += sizeof(UINT16);

        if ((code & (STAT_ALGNERR|STAT_BADCRC|STAT_LONG|STAT_SHORT)) == 0) {

            // Get packet size
            OUTPORT16(&g_pLAN91C->PTR, pointer);
            length = (INPORT16(&g_pLAN91C->DATA) & 0x07FF) - 6;
            pointer += sizeof(UINT16);

            // Copy packet
            count = length;
            while (count > 1) {
                OUTPORT16(&g_pLAN91C->PTR, pointer);
                *(UINT16*)pos = INPORT16(&g_pLAN91C->DATA);
                pointer += sizeof(UINT16);
                pos += sizeof(UINT16);
                count -= sizeof(UINT16);
            }

            // Get control word (which can contain last byte)
            OUTPORT16(&g_pLAN91C->PTR, pointer);
            code = INPORT16(&g_pLAN91C->DATA);
            pointer += sizeof(UINT16);
            if ((code & CTRL_ODD) != 0) {
                length++;
                *pos = (UINT8)code;
            }
        }

        // Release the memory for the received frame
        switch (GET_CHIP_ID(g_chipRevision)) {
        case CHIP_ID_LAN91C111:
            OUTPORT16(&g_pLAN91C->MMUCR, MMUCR_111_REM_REL_RX);
            break;
        default:            
            OUTPORT16(&g_pLAN91C->MMUCR, MMUCR_REM_REL_TOP);
        }

        while ((INPORT16(&g_pLAN91C->MMUCR) & MMUCR_BUSY) != 0);

        // If length is non zero we get a packet
        if (length > 0) break;

    }        

    *pLength = (UINT16)length;
    return (*pLength);
}


//------------------------------------------------------------------------------

VOID Smsc91CEnableInts()
{
    EdbgOutputDebugString("+Smsc91CEnableInts\r\n");

    // Only enable receive interrupts (we poll for Tx completion)
    OUTPORT16(&g_pLAN91C->BANKSEL, 2);
    OUTPORT16(&g_pLAN91C->INTR, INTR_RX_MASK);

    EdbgOutputDebugString("-Smsc91CEnableInts\r\n");
}

//------------------------------------------------------------------------------

VOID Smsc91CDisableInts()
{
    EdbgOutputDebugString("+Smsc91CDisableInts\r\n");

    // Disable all interrupts
    OUTPORT16(&g_pLAN91C->BANKSEL, 2);
    OUTPORT16(&g_pLAN91C->INTR, 0);

    EdbgOutputDebugString("-Smsc91CDisableInts\r\n");
}

//------------------------------------------------------------------------------

VOID Smsc91CCurrentPacketFilter(DWORD filter)
{
    UINT16 rcr = RCR_RXEN|RCR_STRIP_CRC;

    EdbgOutputDebugString(
        "+Smsc91CCurrentPacketFilter(0x%08x)\r\n", filter
    );

    if ((filter & PACKET_TYPE_ALL_MULTICAST) != 0) rcr |= RCR_ALMUL;
    if ((filter & PACKET_TYPE_PROMISCUOUS) != 0) rcr |= RCR_PRMS;

    OUTPORT16(&g_pLAN91C->BANKSEL, 0);
    OUTPORT16(&g_pLAN91C->RCR, rcr);

    EdbgOutputDebugString("-Smsc91CCurrentPacketFilter\r\n");
}

//------------------------------------------------------------------------------

BOOL Smsc91CMulticastList(BYTE *pAddresses, DWORD count)
{
    UINT32 crc, i;
    UINT16 h[4];

    EdbgOutputDebugString(
        "+Smsc91CMulticastList(0x%08x, %d)\r\n", pAddresses, count
    );

    // Calculate hash bits       
    h[0] = h[1] = h[2] = h[3] = 0;
    for (i = 0; i < count; i++) {
        crc = Crc(pAddresses);
        h[crc >> 30] |= 1 << ((crc >> 26) & 0x0F);
        pAddresses += 6;
    }

    // Write it to hardware
    OUTPORT16(&g_pLAN91C->BANKSEL, 3);
    OUTPORT16(&g_pLAN91C->MT[0], h[0]);
    OUTPORT16(&g_pLAN91C->MT[1], h[1]);
    OUTPORT16(&g_pLAN91C->MT[2], h[2]);
    OUTPORT16(&g_pLAN91C->MT[3], h[3]);

    EdbgOutputDebugString("-Smsc91CMulticastList(rc = 1)\r\n");
    return TRUE;
}

//------------------------------------------------------------------------------

UINT32 Crc(UINT8 *pAddress)
{
    UINT32 crc, carry;
    UINT32 i, j;
    UINT8 uc;

    crc = 0xFFFFFFFF;
    for (i = 0; i < 6; i++) {
        uc = pAddress[i];
        for (j = 0; j < 8; j++) {
            carry = ((crc & 0x80000000) ? 1 : 0) ^ (uc & 0x01);
            crc <<= 1;
            uc >>= 1;
            if (carry) crc = (crc ^ 0x04c11db6) | carry;
        }
    }
    return crc;
}
//------------------------------------------------------------------------------
//
//  Function:  Smsc91CStall
//
//  Wait for time specified in parameter in microseconds (busy wait). This
//  function can be called in hardware/kernel initialization process.
//
VOID Smsc91CStall(UINT32 microSec)
{
#if 0 //shkim 2006/10/12 further work
    UINT32 base, counts;

    while (microSec > 0) {
        if (microSec > 1000) {
            counts = g_oalTimer.countsPerMSec;
            microSec -= 1000;
        } else {
            counts = (microSec * g_oalTimer.countsPerMSec)/1000;
            microSec = 0;
        }
        //base = OALTimerGetCount();					// Comment to compile by DJKIM 2006/09/29
        base = counts;		// Just prevent to compile error by DJKIM 2006/09/29
        //while ((OALTimerGetCount()  base) < counts);	// Comment to compile by DJKIM 2006/09/29
    }
#endif    
}
//------------------------------------------------------------------------------
//
//  Function:  Smsc91CGetTickCount
//
//  This function is called by some KITL libraries to obtain relative time
//  since device boot. It is mostly used to implement timeout in network
//  protocol.
//

UINT32 Smsc91CGetTickCount()
{
    static ULONG count = 0;

    count++;
    return count/100;
}

//------------------------------------------------------------------------------

static VOID PhyWrite(UINT8 PHYaddr, UINT8 PHYreg, UINT16 PHYdata)
{
    INT32 i;
    UINT16 mask;
    UINT16 mii_reg;
    UINT8 bits[65];
    INT32 clk_idx = 0;

    // 32 consecutive ones on MDO to establish sync.
    //
    for (i = 0; i < 32; ++i)
    {
        bits[clk_idx++] = MGMT_MDOE | MGMT_MDO;
    }

    // Start code <01>.
    //
    bits[clk_idx++] = MGMT_MDOE;
    bits[clk_idx++] = MGMT_MDOE | MGMT_MDO;

    // Write command <01>.
    //
    bits[clk_idx++] = MGMT_MDOE;
    bits[clk_idx++] = MGMT_MDOE | MGMT_MDO;

    // Output the PHY address, msb first.
    //
    mask = (UINT8)0x10;
    for (i = 0; i < 5; ++i)
    {
        if (PHYaddr & mask)
            bits[clk_idx++] = MGMT_MDOE | MGMT_MDO;
        else
            bits[clk_idx++] = MGMT_MDOE;

        // Shift to next lowest bit.
        mask >>= 1;
    }

    // Output the PHY register number, msb first.
    //
    mask = (UINT8)0x10;
    for (i = 0; i < 5; ++i)
    {
        if (PHYreg & mask)
            bits[clk_idx++] = MGMT_MDOE | MGMT_MDO;
        else
            bits[clk_idx++] = MGMT_MDOE;

        // Shift to next lowest bit.
        mask >>= 1;
    }

    // Tristate and turnaround (2 bit times).
    //
    bits[clk_idx++] = 0;
    bits[clk_idx++] = 0;

    // Write out 16 bits of data, msb first.
    //
    mask = 0x8000;
    for (i = 0; i < 16; ++i)
    {
        if (PHYdata & mask)
            bits[clk_idx++] = MGMT_MDOE | MGMT_MDO;
        else
            bits[clk_idx++] = MGMT_MDOE;

        // Shift to next lowest bit.
        mask >>= 1;
    }

    // Final clock bit (tristate).
    //
    bits[clk_idx++] = 0;

    // Select bank 3.
    //
    OUTPORT16(&g_pLAN91C->BANKSEL, 3);

    // Get the current MII register value.
    //
    mii_reg = INPORT16(&g_pLAN91C->MGMT);

    // Turn off all MII Interface bits.
    //
    mii_reg &= ~(MGMT_MDOE | MGMT_MCLK | 
                 MGMT_MDI  | MGMT_MDO);

    // Clock all cycles.
    //
    for (i = 0; i < sizeof bits; ++i)
    {
        // Clock Low - output data.
        //
        OUTPORT16(&g_pLAN91C->MGMT, mii_reg | bits[i]);
#if 1 //shkim 2006/10/11
        Smsc91CStall(50);
#endif
        // Clock Hi - input data.
        //
        OUTPORT16(&g_pLAN91C->MGMT, (UINT16)(mii_reg | bits[i] | MGMT_MCLK));
#if 1 //shkim 2006/10/11
        Smsc91CStall(50);
#endif  

        bits[i] |= INPORT16(&g_pLAN91C->MGMT) & MGMT_MDI;
    }

    // Return to idle state.  Set clock to low, data to low, and output tristated.
    //
    OUTPORT16(&g_pLAN91C->MGMT, mii_reg);
#if 1 //shkim 2006/10/11
    Smsc91CStall(50);
#endif

}

//------------------------------------------------------------------------------

