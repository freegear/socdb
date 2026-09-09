/*
 * Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2000,2001,2002 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     apsmc.h,v
 * Revision: 1.19
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : apsmc.h.rca
 *  File Revision          : 1.2
 * 
 *  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
 *  ----------------------------------------
 *
 * Public header file for the SMC controller code.  This file contains
 * the headers for the API implementation of the code
 */

#ifndef APSMC_H
#define APSMC_H

#ifdef  __cplusplus
extern "C" {    /* allow C++ to use these headers */
#endif  /* __cplusplus */

/*
 * --------Type definitions--------
 */

/*
 * Description:
 * General errors for this module.  Errors will be returned typecast
 * to the general error type apError.
 */

typedef enum apSMC_xError
{
    apERR_SMC_INVALIDBANK = apERR_SMC_START,    /* Invalid Bank number */
    
    apERR_SMC_INVALIDREADWAITSTATES,            /* Device Parameters
                                                 * not set because of the invalid value
                                                 * of wait states for read access 
                                                 */

    apERR_SMC_INVALIDWRITEWAITSTATES,           /* Device Parameters
                                                 * not set because of the invalid value
                                                 * of wait states for write access 
                                                 */

    apERR_SMC_INVALIDIDLECYCLES,                /* Device Parameters
                                                 * not set because of the invalid value 
                                                 * of duty or turn-around cycles
                                                 */

    apERR_SMC_INVALIDOUTPUTENDELAY,             /* Device Parameters
                                                 * not set because of the invalid value
                                                 * of output enable assertion delay
                                                 */

    apERR_SMC_INVALIDWRITEENDELAY               /* Device Parameters
                                                 * not set because of the invalid value
                                                 * of write enable assertion delay
                                                 */
} apSMC_eError;

/* No data passed in apSMC_sInitialData structure */
typedef void apSMC_sInitialData;

/*
 * Description:
 * Options for memory bank lane enable
 */
typedef enum apSMC_xRBLE
{
    apSMC_RBLE_HI = 0x00,           /* nSMBLS[3:0] all deasserted HIGH (default) */
    apSMC_RBLE_LO = 0x01            /* nSMBLS[3:0] all asserted LOW */
} apSMC_eRBLE;

/*
 * Description:
 * Options for polarity of the external wait input for activation
 */
typedef enum apSMC_xWaitPol
{
    apSMC_WAITPOL_LO = 0x00,       /* SMWAIT is active LOW (default) */
    apSMC_WAITPOL_HI = 0x01        /* SMWAIT is active HIGH */
} apSMC_eWaitPol;

/*
 * Description:
 * Options for external memory controller wait signal enable
 */
typedef enum apSMC_xWaitEn
{
    apSMC_WAITEN_NO  = 0x00,       /* not controlled by external wait signal (default) */
    apSMC_WAITEN_YES = 0x01        /* looks for external wait signal */
} apSMC_eWaitEn;

/*
 * Description:
 * Options for chip polarity bit indication for each bank
 */
typedef enum apSMC_xCSPol
{
    apSMC_CSPOL_LO = 0x00,       /* active LOW SMCS (default) */
    apSMC_CSPOL_HI = 0x01        /* active HIGH SMCS */
} apSMC_eCSPol;

/*
 * Description:
 * Options for write protection
 */
typedef enum apSMC_xWP
{
    apSMC_WP_NO  = 0x00,       /* no write protection (default) */
    apSMC_WP_YES = 0x01        /* device is write protected */
} apSMC_eWP;

/*
 * Description:
 * Options for burst mode
 */
typedef enum apSMC_xBM
{
    apSMC_BM_NO  = 0x00,       /* nonburst memory devices (default) */
    apSMC_BM_YES = 0x01        /* burst ROM memory */
} apSMC_eBM;

/*
 * Description:
 * Options for memory width
 */
typedef enum apSMC_xMW
{
    apSMC_MW_8BIT  = 0x00,      /*  8-bit wide bank */
    apSMC_MW_16BIT = 0x01,      /* 16-bit wide bank */
    apSMC_MW_32BIT = 0x02       /* 32-bit wide bank */
} apSMC_eMW;

/*
 * Description:
 * Structure for the details for SMC initialisation
 *
 */
typedef struct apSMC_xData
{
    apSMC_eRBLE     eRBLE;                  /* read byte lane enable */
    apSMC_eWaitPol  eWaitPol;               /* polarity of the external wait input for activation */
    apSMC_eWaitEn   eWaitEn;                /* external memory controller wait signal enable */
    apSMC_eCSPol    eCSPol;                 /* chip polarity bit indication for each bank */
    apSMC_eWP       eWriteProtect;          /* write protect */
    apSMC_eBM       eBurstMode;             /* burst mode */
    apSMC_eMW       eMemoryWidth;           /* memory width 8, 16, 32-bit */
    UBYTE8          ReadAccessCycles;       /* wait state 1 (0-31) in clock cycles */
    UBYTE8          WriteAccessCycles;      /* wait state 2 (0-31) in clock cycles */
    UBYTE8          IdleTurnAroundCycles;   /* idle or turn-around (0-15) in clock cycles */
    UBYTE8          OutputEnAssertDelay;    /* output enable assertion delay (0-15) in clock cycles */                                               
    UBYTE8          WriteEnAssertDelay;     /* write enable assertion delay (0-15) in clock cycles */                                               
} apSMC_sData;

/*
 * --------Data declarations--------
 * There are no data declarations in this module
 */


/*
 * --------Procedure declarations--------
 */

/*
 * Description:
 * Finds the amount of space required for driver state data
 *
 * Implementation:
 * This function is required if apOS_NO_STATIC_STATE is defined as TRUE
 * as it will retrieve the size required for storage of the driver
 * state data
 *
 * Inputs:
 * none
 * 
 * Outputs:
 * none
 *
 * Return Value:
 * size (in bytes) required.
 */
PUBLIC UWORD32 apSMC_StateSizeGet( void );

/*
 * Description:
 * Access function to ascertain the current state of initialisation
 *
 * Implementation:
 * returns the relevant bit of the initialisation state variable
 *
 * Inputs:
 * oId     - SMC number
 *
 * Outputs:
 * none
 *
 * Return Value:
 *  Initialisation flags for each memory bank.
 *  Bit is set if the bank has been initialised.
 */
PUBLIC UBYTE8 apSMC_InitGet( apOS_SMC_oId oId );

/*
 * Description:
 * Specify the base address for the apSMC registers.  No SMC routines
 * should be used until this has been performed.
 *
 * Implementation:
 * The passed value is stored to be used as a base address for future
 * accesses to the apSMC.
 *
 * The initialisation state variable is restored to apSMC_INITNONE.
 *
 * Inputs:
 * oId        - SMC number
 * eBase      - Base address of SMC registers
 * Interrupts - Ignored (there are no interrupts for the controller)
 * pSources   - Not used; pass as aNULL
 * pInitial   - Not used; pass as aNULL
 */
PUBLIC void apSMC_Initialize( apOS_SMC_oId                      oId,
                              apOS_System_eBaseAddress          eBase,
                              UWORD32                           Interrupts,
                              CONST apOS_INT_oInterruptSource * pSources,
                              apSMC_sInitialData              * pInitial );

/*
 * Description:
 * Initialises one memory bank
 *
 * Implementation:
 * Writes the initialisation values into the registers for the bank.
 * the initialisation values are based on the passed parameters
 *
 * sets the correct bit in the initialisation state variable
 *
 * Inputs:
 * oId       - SMC number
 * MemBank   - The bank number to be configured 
 * pBankData - Pointer to a block of data for configuring this 
 *             memory bank.
 *
 * Outputs:
 * none
 *
 * Return Value:
 * apERR_NONE                       - Parameters set, no errors.
 * apERR_SMC_INVALIDBANK            - Parameters not set because of the 
 *                                    invalid value of bank number.
 * apERR_SMC_INVALIDREADWAITSTATES  - Parameters not set because of the
 *                                    invalid value of wait states for read access.
 * apERR_SMC_INVALIDWRITEWAITSTATES - Parameters not set because of the
 *                                    invalid value of wait states for write access. 
 * apERR_SMC_INVALIDIDLECYCLES      - Parameters not set because of the
 *                                    invalid value duty or turn-around cycles.
 * apERR_SMC_INVALIDOUTPUTENDELAY   - Parameters not set because of the
 *                                    invalid value output enable assertion delay.
 * apERR_SMC_INVALIDWRITEENDELAY    - Device parameters not set because of the
 *                                    invalid value of write enable assertion delay.
 */
PUBLIC apError apSMC_MemBankConfigSet( apOS_SMC_oId        oId,
                                       UWORD32             MemBank,
                                       CONST apSMC_sData * pBankData );

/*
 * Description:
 * Retrieves the configuration for one memory bank
 *
 * Implementation:
 * the bank register is decoded into the specified parameters
 *
 * Inputs:
 * oId     - SMC number 
 * MemBank - The bank number to be read
 *
 * Outputs:
 * The following outputs are enumerated types, specified above:
 * pBankData - a block of data for this memory bank.
 *
 * Return Value:
 * apERR_NONE            - Parameters read, no errors.
 * apERR_SMC_INVALIDBANK - Device parameters not read because of the 
 *                         invalid value of Bank number.
 */
PUBLIC apError apSMC_MemBankConfigGet( apOS_SMC_oId        oId,
                                       UWORD32             MemBank,
                                       apSMC_sData * CONST pBankData );

/*
 * Description:
 * Reads the error status flags for the specified memory bank and clears
 *
 * Implementation:
 * The WaitToutErr, WriteProtErr and HSizeErr bits are read in the relevant registers,
 * the status is then cleared
 *
 * Inputs:
 * oId     - SMC number 
 * MemBank - The bank number to be read
 *
 * Outputs:
 * pWaitToutErr  - set TRUE if there was external wait timeout error
 * pWriteProtErr - set TRUE if there was write protection error
 * pHSizeErr     - set TRUE if there was bus transfer size error
 *
 * Return Value:
 * apERR_NONE            - Error flags read, no errors.
 * apERR_SMC_INVALIDBANK - Error flags not read because of the 
 *                         invalid value of Bank number.
 */
PUBLIC apError apSMC_ErrorGet( apOS_SMC_oId   oId,
                               UWORD32        MemBank,
                               BOOL * CONST   pWaitToutErr,
                               BOOL * CONST   pWriteProtErr,
                               BOOL * CONST   pHSizeErr );

/*
 * Description:
 * Write-enable external memory.
 *
 * Implementation:
 * After calling this function, bank MemBank can be written to
 * 
 * Inputs:
 * oId     - SMC number 
 * MemBank - The bank number to be write-enabled
 *
 * Return Value:
 * apERR_NONE            - Bank has been write-enabled, no errors.
 * apERR_SMC_INVALIDBANK - Bank has not been write-enabled because of the 
 *                         invalid value of Bank number.
 */
PUBLIC apError apSMC_WriteEnable( apOS_SMC_oId   oId,
                                  UWORD32        MemBank );
/*
 * Description:
 * Write-protect external memory.
 *
 * Implementation:
 * After calling this function, bank MemBank is write-protected.
 *
 * Inputs:
 * oId     - SMC number 
 * MemBank - The bank number to write-protect
 *
 * Return Value:
 * apERR_NONE            - Bank has been write-protected, no errors.
 * apERR_SMC_INVALIDBANK - Bank has not been write-protected because of the 
 *                         invalid value of Bank number.
 */
PUBLIC apError apSMC_WriteDisable( apOS_SMC_oId   oId,
                                   UWORD32        MemBank );

#ifdef __cplusplus
} /* allow C++ to use these headers */
#endif  /* __cplusplus */

#endif /* APSMC_H */

