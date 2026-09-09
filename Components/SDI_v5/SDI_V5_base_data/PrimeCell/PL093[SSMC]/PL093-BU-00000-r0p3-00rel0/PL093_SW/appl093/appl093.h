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
 * File:     appl093.h,v
 * Revision: 1.5
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : appl093.h.rca
 *  File Revision          : 1.1
 * 
 *  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
 *  ----------------------------------------
 * 
 * Public header file for the Syncronous Static Memory Controller PL093 code.
 * This file contains the headers for the API implementation of the code
 */

#ifndef APPL093_H
#define APPL093_H

#ifdef  __cplusplus
extern "C" {    /* allow C++ to use these headers */
#endif  /*  __cplusplus */

/*
 * --------Type definitions--------
 */

/*
 * Description:
 * General errors for this module.  Errors will be returned typecast
 * to the general error type apError.
 */

typedef enum apPL093_xError
{
    apERR_PL093_INVALID_BANK = apERR_SSMC_START, /* Invalid Bank number */
    apERR_PL093_INVALID_WSTRD,                   /* Device parameters
                                                  * not set because of the invalid value
                                                  * of wait states for read access 
                                                  */
    apERR_PL093_INVALID_WSTWR,                   /* Device parameters
                                                  * not set because of the invalid value
                                                  * of wait states for write access 
                                                  */
    apERR_PL093_INVALID_IDCY,                    /* Device parameters
                                                  * not set because of the invalid value 
                                                  * of duty or turn-around cycles
                                                  */
    apERR_PL093_INVALID_WSTOEN,                  /* Device parameters
                                                  * not set because of the invalid value
                                                  * of output enable assertion delay
                                                  */
    apERR_PL093_INVALID_WSTWEN,                  /* Device parameters
                                                  * not set because of the invalid value
                                                  * of write enable assertion delay
                                                  */
    apERR_PL093_INVALID_WSTBRD                   /* Device parameters
                                                  * not set because of the invalid value
                                                  * of burst read delay.
                                                  */
} apPL093_eError;

/* No data passed in apPL093_sInitialData structure */
typedef void apPL093_sInitialData;

/*
 * Description:
 * Configuration SMBCR0-7 registers
 */

/*
 * Options for memory bank lane enable
 */
typedef enum apPL093_xRBLE
{
    apPL093_RBLE_HIGH = 0, /* nSMBLS[3:0] all deasserted HIGH during system reads
                              from external memory (default at reset) */
    apPL093_RBLE_LOW  = 1  /* nSMBLS[3:0] all asserted LOW during system reads
                              from external memory */
} apPL093_eRBLE;

/*
 * Description:
 * This specifies the polarity of the external wait input for activation
 */
typedef enum apPL093_xWaitPol
{
    apPL093_WAITPOL_LOW  = 0, /* SMWAIT is active LOW (default at reset) */
    apPL093_WAITPOL_HIGH = 1  /* SMWAIT is active HIGH */

} apPL093_eWaitPol;

/*
 * Description:
 * This specifies external memory controller wait signal enable
 */
typedef enum apPL093_xWaitEn
{
    apPL093_WAITEN_NO  = 0, /* not controlled by the external wait signal (default at reset) */
    apPL093_WAITEN_YES = 1  /* looks for the external wait input signal */
} apPL093_eWaitEn;

/*
 * Description:
 * This specifies write protection
 */
typedef enum apPL093_xWP
{
    apPL093_WP_NO  = 0,   /* no write protection (default at reset) */
    apPL093_WP_YES = 1    /* device is write protected */
} apPL093_eWP;

/*
 * Description:
 * This specifies memory width
 */
typedef enum apPL093_xMW
{
    apPL093_MW_8BIT     = 0,   /*  8-bit wide bank */
    apPL093_MW_16BIT    = 1,   /* 16-bit wide bank */
    apPL093_MW_32BIT    = 2    /* 32-bit wide bank */
} apPL093_eMW;

/*
 * Description:
 * This specifies the polarity of the signal SMBLS
 */
typedef enum apPL093_xSMBLSPol
{
    apPL093_SMBLSPOL_LOW  = 0, /* SMBLS is active LOW (default at reset) */
    apPL093_SMBLSPOL_HIGH = 1  /* SMBLS is active HIGH */

} apPL093_eSMBLSPol;

/*
 * Description:
 * This specifies burst mode read
 */
typedef enum apPL093_xBMRead
{
    apPL093_NON_BURST_READS = 0, /* non-burst reads from memory devices (default at reset) */
    apPL093_BURST_READS     = 1  /* burst mode/asynchronous page mode reads from memory devices */
} apPL093_eBMRead;

/*
 * Description:
 * This specifies synchronous access capable device connection for reads
 */
typedef enum apPL093_xSyncReadDev
{
    apPL093_ASYNC_READ = 0,      /* asynchronous device (default) */
    apPL093_SYNC_READ  = 1       /* synchronous device */
} apPL093_eSyncReadDev;

/*
 * Description:
 * This specifies burst transfer length for read
 */
typedef enum apPL093_xBurstLenRead
{
    apPL093_BL_READ_4BIT  = 0,    /* 4-transfer burst (default) */
    apPL093_BL_READ_8BIT  = 1,    /* 8-transfer burst */
    apPL093_BL_READ_16BIT = 2,    /* 16-transfer burst */
    apPL093_BL_READ_CONT  = 3     /* continuous burst (synchronous only) */
} apPL093_eBurstLenRead;

/*
 * Description:
 * This specifies behaviour of the signal SMADDRVALID during reading
 */
typedef enum apPL093_xAddrValidReadEn
{
    apPL093_AVRE_HIGH   = 0,   /* signal always HIGH */
    apPL093_AVRE_ACTIVE = 1    /* signal active for asynchronous and synchronous read accesses (default) */
} apPL093_eAddrValidReadEn;

/*
 * Description:
 * This specifies behaviour of the signal SMBAA and SMIND during reading
 */
typedef enum apPL093_xBIReadEn
{
    apPL093_BIREAD_HIGH   = 0,   /* signals always HIGH */
    apPL093_BIREAD_ACTIVE = 1    /* signals active for synchronous read accesses (default) */
} apPL093_eBIReadEn;

/*
 * Description:
 * This enables the wrapping burst feature from external memory
 */
typedef enum apPL093_xWrapReadEn
{
    apPL093_WRAPREAD_DISABLED   = 0,   /* wrap disabled (default) */
    apPL093_WRAPREAD_ENABLED    = 1    /* wrap enabled */
} apPL093_eWrapReadEn;

/*
 * Description:
 * This specifies burst mode write
 */
typedef enum apPL093_xBMWrite
{
    apPL093_NON_BURST_WRITES = 0,    /* non-burst writes to memory devices (default at reset) */
    apPL093_BURST_WRITES     = 1     /* burst mode writes to memory devices */
} apPL093_eBMWrite;

/*
 * Description:
 * This specifies synchronous access capable device connection for writes
 */
typedef enum apPL093_xSyncWriteDev
{
    apPL093_ASYNC_WRITE = 0,         /* asynchronous device (default) */
    apPL093_SYNC_WRITE  = 1          /* synchronous device */
} apPL093_eSyncWriteDev;

/*
 * Description:
 * This specifies burst transfer length for write
 */
typedef enum apPL093_xBurstLenWrite
{
    apPL093_BL_WRITE_4BIT = 0,   /* 4-transfer burst (default) */
    apPL093_BL_WRITE_8BIT = 1,   /* 8-transfer burst */
    apPL093_BL_WRITE_CONT = 3    /* continuous burst (synchronous only) */
} apPL093_eBurstLenWrite;

/*
 * Description:
 * This specifies behaviour of the signal SMADDRVALID during writing
 */
typedef enum apPL093_xAddrValidWriteEn
{
    apPL093_AVWE_HIGH   = 0,   /* signal always HIGH */
    apPL093_AVWE_ACTIVE = 1    /* signal active for asynchronous and synchronous write accesses (default) */
} apPL093_eAddrValidWriteEn;

/*
 * Description:
 * This specifies behaviour of the signal SMBAA and SMIND during writing
 */
typedef enum apPL093_xBIWriteEn
{
    apPL093_BIWRITE_HIGH   = 0,   /* signals always HIGH */
    apPL093_BIWRITE_ACTIVE = 1    /* signals active for synchronous write accesses (default) */
} apPL093_eBIWriteEn;

/*
 * Description:
 * Control data for SSMCCR register
 */
/*
 * Options for SMCLK Enable
 */
typedef enum apPL093_xSMClockEn
{
    apPL093_SMCLK_ACTIVE_ACCESS  = 0, /* clock only active during memory accesses to safe power */
    apPL093_SMCLK_ALWAYS_RUNNING = 1  /* clock always running (default) */
} apPL093_eSMClockEn;

/*
 * Options for SMMemClk to HCLK ratio
 */
typedef enum apPL093_xMemClkRatio
{
    apPL093_SMMEMCLK_HCLK   = 0,     /* SMMemClk = HCLK (default) */
    apPL093_SMMEMCLK_HCLK_2 = 1,     /* SMMemClk = HCLK/2 */
    apPL093_SMMEMCLK_HCLK_3 = 2      /* SMMemClk = HCLK/3 */
} apPL093_eMemClkRatio;

/*
 * Description:
 * Structure for the details for PL093 bank configuration
 */
typedef struct apPL093_xData
{
    apPL093_eRBLE             eRBLE;                /* read byte lane enable */
    apPL093_eWaitPol          eWaitPol;             /* polarity of the external wait input for activation */
    apPL093_eWaitEn           eWaitEn;              /* external memory controller wait signal enable */
    apPL093_eWP               eWriteProtect;        /* write protect */
    apPL093_eMW               eMemoryWidth;         /* memory width 8, 16, 32-bit */
    apPL093_eSMBLSPol         eSMBLSPol;            /* polarity of the signal SMBLS */
    apPL093_eBMRead           eBMRead;              /* burst mode read and asynchronous page mode */
    apPL093_eSyncReadDev      eSyncReadDev;         /* synchronous access for read */
    apPL093_eBurstLenRead     eBurstLenRead;        /* burst transfer length for read */
    apPL093_eAddrValidReadEn  eAddrValidReadEn;     /* behaviour of the signal SMADDRVALID during reading */
    apPL093_eBIReadEn         eBIReadEn;            /* behaviour of the signal SMBAA and SMIND during reading */
    apPL093_eWrapReadEn       eWrapReadEn;          /* enables the wrapping burst feature from external memory*/
    apPL093_eBMWrite          eBMWrite;             /* burst mode write */
    apPL093_eSyncWriteDev     eSyncWriteDev;        /* synchronous access for write */   
    apPL093_eBurstLenWrite    eBurstLenWrite;       /* burst transfer length for write */
    apPL093_eAddrValidWriteEn eAddrValidWriteEn;    /* behaviour of the SMADDRVALID during writing */
    apPL093_eBIWriteEn        eBIWriteEn;           /* behaviour of the signal SMBAA and SMIND during writing */
    UBYTE8                    IdleTurnAroundCycles; /* idle or turn-around (0-15) in clock cycles */
    UBYTE8                    ReadAccessCycles;     /* read wait state (0-31) in clock cycles */
    UBYTE8                    WriteAccessCycles;    /* write wait state (0-31) in clock cycles */
    UBYTE8                    OutputEnAssertDelay;  /* output enable assertion delay (0-15) in clock cycles */                                               
    UBYTE8                    WriteEnAssertDelay;   /* write enable assertion delay (0-15) in clock cycles */                                               
    UBYTE8                    BurstReadDelay;       /* burst read wait state (0-31) in clock cycles */  
} apPL093_sData;

/*
 * Description:
 * Structure for the details for PL093 control
 */
typedef struct apPL093_xControl
{
    apPL093_eSMClockEn        eSMClockEn;           /* SMCLK Enable */
    apPL093_eMemClkRatio      eMemClkRatio;         /* the ratio of SMMemClk to HCLK */

} apPL093_sControl;

/*
 * --------Procedure declarations--------
 */

/*
 * Description:
 * Specify the base address for the apPL093 registers.  No PL093 routines
 * should be used until this has been performed.
 *
 * Implementation:
 * The passed value is stored to be used as a base address for future
 * accesses to the apPL093.
 *
 * The initialisation state variable is restored to apPL093_INITNONE.
 *
 * Inputs:
 * oId        - PL093 number
 * eBase      - Base address of PL093 registers
 * Interrupts - Ignored (there are no interrupts for the controller)
 * pSources   - Not used; pass as aNULL
 * pInitial   - Not used; pass as aNULL
 *
 * Outputs:
 * none
 *
 * Return Value:
 * none
 */
PUBLIC void apPL093_Initialize( apOS_PL093_oId                   oId,
                               apOS_System_eBaseAddress          eBase,
                               UWORD32                           Interrupts,
                               CONST apOS_INT_oInterruptSource * pSources,
                               apPL093_sInitialData            * pInitial );

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
PUBLIC UWORD32 apPL093_StateSizeGet( void );

/*
 * Description:
 * Access function to ascertain the current state of initialisation
 *
 * Implementation:
 * returns the relevant bit of the initialisation state variable
 *
 * Inputs:
 * oId     - PL093 number
 *
 * Outputs:
 * none
 *
 * Return Value:
 *  Initialisation flags for each memory bank.
 *  Bit is set if the bank has been initialised.
 */
PUBLIC UBYTE8 apPL093_InitGet( apOS_PL093_oId oId );

/*
 * Description:
 * Initialises one memory bank
 *
 * Implementation:
 * writes the initialisation value into the register for the bank.
 * the initialisation value is based on the passed parameters
 *
 * sets the correct bit in the initialisation state variable
 *
 * Inputs:
 * oId       - PL093 number
 * MemBank   - The bank number to be configured 
 * pBankData - Pointer to a block of data for configuring this 
 *             memory bank.
 *
 * Outputs:
 * none
 *
 * Return Value:
 * apERR_NONE                        - Parameters set, no errors.
 * apERR_PL093_INVALIDBANK            - Parameters not set because of the 
 *                                     invalid value of bank number.
 * apERR_PL093_INVALIDREADWAITSTATES  - Parameters not set because of the
 *                                     invalid value of wait states for read access.
 * apERR_PL093_INVALIDWRITEWAITSTATES - Parameters not set because of the
 *                                     invalid value of wait states for write access. 
 * apERR_PL093_INVALIDIDLECYCLES      - Parameters not set because of the
 *                                     invalid value of duty or turn-around cycles.
 * apERR_PL093_INVALIDOUTPUTENDELAY   - Parameters not set because of the
 *                                     invalid value output enable assertion delay.
 * apERR_PL093_INVALIDWRITEENDELAY    - Device parameters not set because of the
 *                                     invalid value of write enable assertion delay.
 * apERR_PL093_INVALIDBURSTREADDELAY  - Device parameters not set because of the
 *                                     invalid value of burst read delay.
 */
PUBLIC apError apPL093_MemBankConfigSet( apOS_PL093_oId        oId,
                                        UWORD32              MemBank,
                                        CONST apPL093_sData * pBankData );

/*
 * Description:
 * Retrieves the configuration for one memory bank
 *
 * Implementation:
 * the bank register is decoded into the specified parameters
 *
 * Inputs:
 * oId     - PL093 number 
 * MemBank - The bank number to be read
 *
 * Outputs:
 * The following outputs are enumerated types, specified above:
 * pBankData - a block of data for this memory bank.
 *
 * Return Value:
 * apERR_NONE             - Parameters read, no errors.
 * apERR_PL093_INVALIDBANK - Device parameters not read because of the 
 *                          invalid value of Bank number.
 */
PUBLIC apError apPL093_MemBankConfigGet( apOS_PL093_oId        oId,
                                        UWORD32              MemBank,
                                        apPL093_sData * CONST pBankData );

/*
 * Description:
 * Reads and cleartes the error status flag for the specified memory bank
 *
 * Implementation:
 * The WaitToutErr bit is read in the relevant register,
 * the status is then cleared
 *
 * Inputs:
 * oId     - PL093 number 
 * MemBank - The bank number to be read
 *
 * Outputs:
 * pWaitToutErr - set TRUE if there was external wait timeout error
 *
 * Return Value:
 * apERR_NONE             - Error flag read, no errors.
 * apERR_PL093_INVALIDBANK - Error flag not read because of the 
 *                          invalid value of Bank number.
 */
PUBLIC apError apPL093_ErrorGet( apOS_PL093_oId oId,
                                UWORD32       MemBank,
                                BOOL * CONST  pWaitToutErr );

/*
 * Description:
 * Write-enable external memory.
 *
 * Implementation:
 * After calling this function, bank MemBank can be written to
 * 
 * Inputs:
 * oId     - PL093 number 
 * MemBank - The bank number to be write-enabled
 *
 * Return Value:
 * apERR_NONE             - Bank has been write-enabled, no errors.
 * apERR_PL093_INVALIDBANK - Bank has not been write-enabled because of the 
 *                          invalid value of Bank number.
 */
PUBLIC apError apPL093_WriteEnable( apOS_PL093_oId oId,
                                   UWORD32       MemBank );

/*
 * Description:
 * Write-protect external memory.
 *
 * Implementation:
 * After calling this function, bank MemBank is write-protected.
 *
 * Inputs:
 * oId     - PL093 number 
 * MemBank - The bank number to write-protect
 *
 * Return Value:
 * apERR_NONE             - Bank has been write-protected, no errors.
 * apERR_PL093_INVALIDBANK - Bank has not been write-protected because of the 
 *                          invalid value of Bank number.
 */
PUBLIC apError apPL093_WriteDisable( apOS_PL093_oId oId,
                                    UWORD32       MemBank );

/*
 * Description:
 * Sets control data for PL093 device
 *
 * Implementation:
 * Writes the control data to PL093 Control Register, PL093CR
 *
 * Inputs:
 * oId      - PL093 number
 * pControl - Pointer to apPL093_sControl structure containing control data to be set up
 *
 * Outputs:
 * none
 *
 * Return Value:
 * none
 */
PUBLIC void apPL093_ControlSet( apOS_PL093_oId           oId,
                               CONST apPL093_sControl * pControl );

/*
 * Description:
 * Reads control data of PL093 device
 *
 * Implementation:
 * Writes the control data to PL093 Control Register, PL093CR
 *
 * Inputs:
 * oId      - PL093 number
 * pControl - Pointer to apPL093_sControl structure that will contain read control data
 *
 * Outputs:
 * none
 *
 * Return Value:
 * none
 */
PUBLIC void apPL093_ControlGet( apOS_PL093_oId           oId,
                               apPL093_sControl * CONST pControl );

/*
 * Description:
 * Reads the External Wait Status flag of PL093
 *
 * Implementation:
 * Reads the value of PL093SR register and returns External Wait Status flag
 *
 * Inputs:
 * oId   - PL093 number 
 *
 * Outputs:
 * none 
 *
 * Return Value:
 * TRUE  - if SMWAIT signal is asserted
 * FALSE - if SMWAIT signal is deasserted
 *
 */
PUBLIC BOOL apPL093_StatusGet( apOS_PL093_oId oId );

#ifdef __cplusplus
} /* allow C++ to use these headers */
#endif  /* __cplusplus */

#endif 
