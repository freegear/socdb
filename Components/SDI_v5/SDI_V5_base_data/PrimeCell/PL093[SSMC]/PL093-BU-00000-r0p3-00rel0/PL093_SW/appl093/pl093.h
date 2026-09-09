/*
 * Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2001,2002 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     pl093.h,v
 * Revision: 1.6
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : pl093.h.rca
 *  File Revision          : 1.2
 * 
 *  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
 *  ----------------------------------------
 *
 * Public header file for the Synchronous Static Memory Controller PL093 code.
 * This file contains the headers for the API implementation of the code
 */

#ifndef PL093_H
#define PL093_H

#ifdef  __cplusplus
extern "C" {    /* allow C++ to use these headers */
#endif  /* __cplusplus */

/*
 * Description:
 * Bit shifts and widths for Idle Cycle CR SMBIDCYR0-7
 */
#define bsPL093_IDCY             0
#define bwPL093_IDCY             4

/*
 * Description:
 * Bit shifts and widths for Bank Read Wait State CR SMBWSTRDR0-7
 */
#define bsPL093_WSTRD            0
#define bwPL093_WSTRD            5

/*
 * Description:
 * Bit shifts and widths for Bank Write Wait State CR SMBWSTWRR0-7
 */
#define bsPL093_WSTWR            0
#define bwPL093_WSTWR            5

/*
 * Description:
 * Bit shifts and widths for Bank Output Enable Assertion delay CR SMBWSTOENR0-7
 */
#define bsPL093_WSTOEN           0
#define bwPL093_WSTOEN           4

/*
 * Description:
 * Bit shifts and widths for Bank Write Enable Assertion delay CR SMBWSTWENR0-7
 */
#define bsPL093_WSTWEN           0
#define bwPL093_WSTWEN           4

/*
 * Description:
 * Bit shifts and widths for Bank Burst Read Delay CR SMBWSTBRD0-7
 */
#define bsPL093_WSTBRD           0
#define bwPL093_WSTBRD           5

/*
 * Description:
 * Bit shifts and widths for Bank Control Registers SMBCR0-7
 */
/* Read byte lane enable */
#define bsPL093_RBLE             0
#define bwPL093_RBLE             1

/* Polarity of the external wait input for activation */
#define bsPL093_WAITPOL          1
#define bwPL093_WAITPOL          1

/* External memory controller wait signal enable */
#define bsPL093_WAITEN           2
#define bwPL093_WAITEN           1

/* Write protect */
#define bsPL093_WP               3
#define bwPL093_WP               1

/* Memory width */
#define bsPL093_MW               4
#define bwPL093_MW               2

/* Polarity of signal SMBLS */
#define bsPL093_SMBLSPOL         6
#define bwPL093_SMBLSPOL         1

/* Burst mode read */
#define bsPL093_BMREAD           8
#define bwPL093_BMREAD           1

/* Synchronous access capable device conected */
#define bsPL093_SYNCREADDEV      9
#define bwPL093_SYNCREADDEV      1

/* Burst tramsfer length */
#define bsPL093_BURSTLENREAD     10
#define bwPL093_BURSTLENREAD     2

/* Behaviour of the signal SMADDRVALID during reading */ 
#define bsPL093_ADDRVALIDREADEN  12
#define bwPL093_ADDRVALIDREADEN  1

/* Behaviour of the signal SMBAA and SMIND during read opeartions */
#define bsPL093_BIREADEN         13
#define bwPL093_BIREADEN         1

/* Wrapping burst feature enable */
#define bsPL093_WRAPREADEN       14
#define bwPL093_WRAPREADEN       1

/* Burst mode write */
#define bsPL093_BMWRITE          16
#define bwPL093_BMWRITE          1

/* Synchronous access capable device conected */
#define bsPL093_SYNCWRITEDEV     17
#define bwPL093_SYNCWRITEDEV     1

/* Burst transfer length */
#define bsPL093_BURSTLENWRITE    18
#define bwPL093_BURSTLENWRITE    2

/* Behaviour of the signal SMADDRVALID during writing */ 
#define bsPL093_ADDRVALIDWRITEEN 20
#define bwPL093_ADDRVALIDWRITEEN 1

/* Behaviour of the signal SMBAA and SMIND during write opeartions */
#define bsPL093_BIWRITEEN        21
#define bwPL093_BIWRITEEN        1

/*
 * Description:
 * Bit shifts and widths for PL093 Bank Status Register SMBSR0-7
 */
/* External wait timeout error flag */
#define bsPL093_WAITTOUTERR      0
#define bwPL093_WAITTOUTERR      1

/*
 * Description:
 * Bit shifts and widths for PL093 External Wait Status Register SSMCSR
 */
/* External wait status */
#define bsPL093_WAITSTATUS        0
#define bwPL093_WAITSTATUS        1

/*
 * Description:
 * Bit shifts and widths for PL093 Control Register SSMCCR
 */
/* PL093LK enable */
#define bsPL093_SMCLOCKEN         0
#define bwPL093_SMCLOCKEN         1

/* Ratio of SMMemClk to HCLK */
#define bsPL093_MEMCLKRATIO       1
#define bwPL093_MEMCLKRATIO       2

/*
 * Description:
 * Reserved address space of the PL093 controller (in 32 bit words)
 */
#define PL093_RESERVED_BEFORE_PL093SR         ((0x200 - 0x100) >> 2)
#define PL093_RESERVED_BEFORE_PL093PeriphID0  ((0xFE0 - 0x214) >> 2)

/*
 * --------Type definitions--------
 */

/*
 * Description:
 * This is the register access data structure for one bank.
 */
typedef volatile struct PL093_xBankRegs
{
    UWORD32 SMBIDCYR;       /* Idle cycle CR for bank n                    (+ 0x00) */
    UWORD32 SMBWSTRDR;      /* Read  wait state 1 CR for bank n            (+ 0x04) */
    UWORD32 SMBWSTWRR;      /* Write wait state 2 CR for bank n            (+ 0x08) */
    UWORD32 SMBWSTOENR;     /* Output enable assertion delay CR for bank n (+ 0x0C) */
    UWORD32 SMBWSTWENR;     /* Write  enable assertion delay CR for bank n (+ 0x10) */
    UWORD32 SMBCR;          /* CR for bank n                               (+ 0x14) */
    UWORD32 SMBSR;          /* SR for bank n                               (+ 0x18) */
    UWORD32 SMBWSTBRDR;     /* Burst read wait state CR for bank n         (+ 0x1C) */

} PL093_sBankRegs;    

typedef volatile struct PL093_xRegisters
{
    PL093_sBankRegs sBankRegs [ 8 ];     /* SSMC Registers for banks 0-7 */
    UWORD32         Reserved1 [ PL093_RESERVED_BEFORE_PL093SR ];
    UWORD32         SSMCSR;              /* External Wait Status register for all banks */
    UWORD32         SSMCCR;              /* Control Register for all banks */
    UWORD32         SSMCITCR;            /* Test Control Register */
    UWORD32         SSMCITIP;            /* Test Input   Register */
    UWORD32         SSMCITOP;            /* Test Output  Register */
    UWORD32         Reserved2 [ PL093_RESERVED_BEFORE_PL093PeriphID0 ];
    UWORD32         SSMCPeriphID0;       /* Peripheral ID register bits  7:0  */
    UWORD32         SSMCPeriphID1;       /* Peripheral ID register bits 15:8  */
    UWORD32         SSMCPeriphID2;       /* Peripheral ID register bits 23:16 */
    UWORD32         SSMCPeriphID3;       /* Peripheral ID register bits 31:24 */
    UWORD32         SSMCPCellID0;        /* PrimeCell  ID register bits  7:0  */
    UWORD32         SSMCPCellID1;        /* PrimeCell  ID register bits 15:8  */
    UWORD32         SSMCPCellID2;        /* PrimeCell  ID register bits 23:16 */
    UWORD32         SSMCPCellID3;        /* PrimeCell  ID register bits 31:24 */

} PL093_sRegisters;

/*
 * Description:
 * The data structure to hold the details of each PL093 device.
 *
 */
typedef volatile struct PL093_xStateStruct
{
    PL093_sRegisters * pBaseAddress;  /* Base address of PL093 device registers */
    UBYTE8             uInit;         /* Variable to check whether initialisation has occurred.
                                         The eight bits are set as each bank is initialised. */       
} PL093_sStateStruct;

/*
 * Description:
 * Number of memory banks
 */
#define PL093_MB_NUMBER   ((UWORD32) 8)

#ifdef __cplusplus
} /* allow C++ to use these headers */
#endif /* __cplusplus */

#endif /* PL093_H */ 

