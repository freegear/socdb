/*
 * Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2000,2001 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     smc.h,v
 * Revision: 1.13
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : smc.h.rca
 *  File Revision          : 1.1
 * 
 *  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
 *  ----------------------------------------
 *
 * Private header file for the SMC PL092 controller code.
 */

#ifndef SMC_H
#define SMC_H

#ifdef  __cplusplus
extern "C" {    /* allow C++ to use these headers */
#endif  /*  __cplusplus */

/*
 * Description:
 * Bit shifts and widths for Idle Cycle CR SMBIDCYR0-7
 */
#define bsSMC_IDCY      ((WORD32) 0)
#define bwSMC_IDCY      ((WORD32) 4)

/*
 * Description:
 * Bit shifts and widths for Bank Wait State 1 CR SMBWST1R0-7
 */
#define bsSMC_WST1      ((WORD32) 0)
#define bwSMC_WST1      ((WORD32) 5)

/*
 * Description:
 * Bit shifts and widths for Bank Wait State 2 CR SMBWST2R0-7
 */
#define bsSMC_WST2      ((WORD32) 0)
#define bwSMC_WST2      ((WORD32) 5)

/*
 * Description:
 * Bit shifts and widths for Bank Output Enable Assertion Delay CR SMBWSTOENR0-7
 */
#define bsSMC_WSTOEN    ((WORD32) 0)
#define bwSMC_WSTOEN    ((WORD32) 4)

/*
 * Description:
 * Bit shifts and widths for Bank Write Enable Assertion Delay CR SMBWSTWENR0-7
 */
#define bsSMC_WSTWEN    ((WORD32) 0)
#define bwSMC_WSTWEN    ((WORD32) 4)

/*
 * Description:
 * Bit shifts and widths for Bank Control Registers SMBCR0-7
 */

/* Read byte lane enable */
#define bsSMC_RBLE             ((WORD32) 0)
#define bwSMC_RBLE             ((WORD32) 1)

/* Polarity of the external wait input for activation */
#define bsSMC_WAITPOL          ((WORD32) 1)
#define bwSMC_WAITPOL          ((WORD32) 1)

/* External memory controller wait signal enable */
#define bsSMC_WAITEN           ((WORD32) 2)
#define bwSMC_WAITEN           ((WORD32) 1)

/* Chip select polarity */
#define bsSMC_CSPOL            ((WORD32) 3)
#define bwSMC_CSPOL            ((WORD32) 1)

/* Write protect */
#define bsSMC_WP               ((WORD32) 4)
#define bwSMC_WP               ((WORD32) 1)

/* Burst mode */
#define bsSMC_BM               ((WORD32) 5)
#define bwSMC_BM               ((WORD32) 1)

/* Memory width */
#define bsSMC_MW               ((WORD32) 6)
#define bwSMC_MW               ((WORD32) 2)

/*
 * Description:
 * Bit shifts and widths for Bank Status Registers SMBSR0-7
 */

/* Bus transfer size error status flag */
#define bsSMC_HSIZEERR         ((WORD32) 0)
#define bwSMC_HSIZEERR         ((WORD32) 1)

/* Write protect error status flag */
#define bsSMC_WRITEPROTERR     ((WORD32) 1)
#define bwSMC_WRITEPROTERR     ((WORD32) 1)

/* External wait timeout error flag */
#define bsSMC_WAITTOUTERR      ((WORD32) 2)
#define bwSMC_WAITTOUTERR      ((WORD32) 1)

/*
 * Description:
 * Bit shifts and widths for External Wait Status Registers SMBEWS
 */
#define bsSMC_WAITSTATUS       ((WORD32) 0)
#define bwSMC_WAITSTATUS       ((WORD32) 1)

/*
 * Description:
 * Reserved address space of the SMC controller (in 32 bit words)
 */
#define SMC_RESERVED_BEFORE_SMCPeriphID0   ((0xFE0 - 0xE4) >> 2)

/*
 * Description:
 * This is the register access data structure for one bank.
 */
typedef volatile struct SMC_xBankRegs
{
    UWORD32 SMBIDCYR;       /* Idle cycle CR for bank n   (+ 0x00) */
    UWORD32 SMBWST1R;       /* Wait state 1 CR for bank n (+ 0x04) */
    UWORD32 SMBWST2R;       /* Wait state 2 CR for bank n (+ 0x08) */
    UWORD32 SMBWSTOENR;     /* Output enable assertion delay CR for bank n (+ 0x0C) */
    UWORD32 SMBWSTWENR;     /* Write  enable assertion delay CR for bank n (+ 0x10) */
    UWORD32 SMBCR;          /* CR for bank n (+ 0x14) */
    UWORD32 SMBSR;          /* SR for bank n (+ 0x18) */
} SMC_sBankRegs;    


typedef volatile struct SMC_xRegisters
{
    SMC_sBankRegs SMC_sBank [ 8 ];    /* SSMC Registers for banks 0-7 */
    UWORD32       SMBEWS;             /* External Wait Status register for all banks */
    UWORD32       Reserved  [ SMC_RESERVED_BEFORE_SMCPeriphID0 ];
    UWORD32       SMCPeriphID0;       /* Peripheral ID register bits  7:0  */
    UWORD32       SMCPeriphID1;       /* Peripheral ID register bits 15:8  */
    UWORD32       SMCPeriphID2;       /* Peripheral ID register bits 23:16 */
    UWORD32       SMCPeriphID3;       /* Peripheral ID register bits 31:24 */
    UWORD32       SMCPCellID0;        /* PrimeCell  ID register bits  7:0  */
    UWORD32       SMCPCellID1;        /* PrimeCell  ID register bits 15:8  */
    UWORD32       SMCPCellID2;        /* PrimeCell  ID register bits 23:16 */
    UWORD32       SMCPCellID3;        /* PrimeCell  ID register bits 31:24 */
} SMC_sRegisters;

/*
 * The structure to hold the details of each SMC
 */
 
typedef struct SMC_xStateStruct
{
    SMC_sRegisters *pBaseAddress;   /* Base address of SMC registers */
    UBYTE8          uSMC_Init;      /* Variable to check whether initialisation has occurred.
                                       The eight bits are set as each bank is initialised. */       
} SMC_sStateStruct;

/*
 * Description:
 * Number of memory banks
 */
#define SMC_MB_NUMBER   ((UWORD32) 8)

#ifdef __cplusplus
} /* allow C++ to use these headers */
#endif  /* __cplusplus */

#endif /* SMC_H */
