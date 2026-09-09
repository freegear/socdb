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
 * File:     pl093.c,v
 * Revision: 1.4
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : pl093.c.rca
 *  File Revision          : 1.1
 * 
 *  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
 *  ----------------------------------------
 *
 * Code implementation file for the Synchronous Static Memory Controller PL093.
 */

/*
 * --------Included Headers--------
 * These headers assume a search path including the parent directory
 * for this source file.
 */
#include "../apcommon/aptypes.h"    /*Basic project definitions*/
#include "../apcommon/apbitops.h"   /*Bit manipulation macros*/
#include "../apos/apos.h"
#include "appl093.h"                /*API (public) header*/
#include "pl093.h"                  /*Private header*/

/*
 * Description:
 * Array to hold the state of each PL093
 */
#if !defined(apOS_NO_STATIC_STATE) || (!apOS_NO_STATIC_STATE)
PRIVATE PL093_sStateStruct PL093_sState[apOS_PL093_MAXIMUM];
#endif

/*
 * --------API (Public) Procedure definitions--------
 */

PUBLIC UWORD32 apPL093_StateSizeGet( void )
{
   return sizeof( PL093_sStateStruct );
}

/*====================================================================*/
PUBLIC UBYTE8 apPL093_InitGet( apOS_PL093_oId oId )
{
    /* Define and set up pointer to state - pState */
    PL093_sStateStruct * CONST pState = apSTATE_GET(PL093, oId);

    return pState->uInit;
}

/*====================================================================*/
PUBLIC void apPL093_Initialize( apOS_PL093_oId                    oId,
                                apOS_System_eBaseAddress          eBase,
                                UWORD32                           Interrupts,
                                CONST apOS_INT_oInterruptSource * pSources,
                                void                            * pInitial )
{
    UWORD32           MemBank;
    PL093_sBankRegs * pBankRegs;    
    
    /* Define and set up pointer to state - pState */
    PL093_sStateStruct * CONST pState = apSTATE_GET(PL093, oId);
   
    IGNORE(Interrupts);
    IGNORE(pSources);
    IGNORE(pInitial);

    apINSTANCE_CHECK(PL093);
    
    /* Store base address into device data array */
    pState->pBaseAddress = (PL093_sRegisters *) eBase;

    /* Set up default (as after reset) parameters for all memory banks */
    
    /* Build SMBCRx registers */
    ((PL093_sRegisters *) eBase)->sBankRegs[ 0 ].SMBCR = \
           apBIT_BUILD( PL093_BIWRITEEN,        apPL093_BIWRITE_ACTIVE )   | 
           apBIT_BUILD( PL093_ADDRVALIDWRITEEN, apPL093_AVWE_ACTIVE )      | 
           apBIT_BUILD( PL093_BURSTLENWRITE,    apPL093_BL_WRITE_4BIT )    | 
           apBIT_BUILD( PL093_SYNCWRITEDEV,     apPL093_ASYNC_WRITE )      | 
           apBIT_BUILD( PL093_BMWRITE,          apPL093_NON_BURST_WRITES ) | 
           apBIT_BUILD( PL093_WRAPREADEN,       apPL093_WRAPREAD_DISABLED )| 
           apBIT_BUILD( PL093_BIREADEN,         apPL093_BIREAD_ACTIVE )    | 
           apBIT_BUILD( PL093_ADDRVALIDREADEN,  apPL093_AVRE_ACTIVE )      | 
           apBIT_BUILD( PL093_BURSTLENREAD,     apPL093_BL_READ_4BIT )     | 
           apBIT_BUILD( PL093_SYNCREADDEV,      apPL093_ASYNC_READ )       | 
           apBIT_BUILD( PL093_BMREAD,           apPL093_NON_BURST_READS )  | 
           apBIT_BUILD( PL093_SMBLSPOL,         apPL093_SMBLSPOL_LOW )     | 
           apBIT_BUILD( PL093_MW,               apPL093_MW_32BIT )         | 
           apBIT_BUILD( PL093_WP,               apPL093_WP_NO )            |  
           apBIT_BUILD( PL093_WAITEN,           apPL093_WAITEN_NO )        |  
           apBIT_BUILD( PL093_WAITPOL,          apPL093_WAITPOL_LOW )      | 
           apBIT_BUILD( PL093_RBLE,             apPL093_RBLE_HIGH );

    ((PL093_sRegisters *) eBase)->sBankRegs[ 1 ].SMBCR = \
           apBIT_BUILD( PL093_BIWRITEEN,        apPL093_BIWRITE_ACTIVE )   | 
           apBIT_BUILD( PL093_ADDRVALIDWRITEEN, apPL093_AVWE_ACTIVE )      | 
           apBIT_BUILD( PL093_BURSTLENWRITE,    apPL093_BL_WRITE_4BIT )    | 
           apBIT_BUILD( PL093_SYNCWRITEDEV,     apPL093_ASYNC_WRITE )      | 
           apBIT_BUILD( PL093_BMWRITE,          apPL093_NON_BURST_WRITES ) | 
           apBIT_BUILD( PL093_WRAPREADEN,       apPL093_WRAPREAD_DISABLED )| 
           apBIT_BUILD( PL093_BIREADEN,         apPL093_BIREAD_ACTIVE )    | 
           apBIT_BUILD( PL093_ADDRVALIDREADEN,  apPL093_AVRE_ACTIVE )      | 
           apBIT_BUILD( PL093_BURSTLENREAD,     apPL093_BL_READ_4BIT )     | 
           apBIT_BUILD( PL093_SYNCREADDEV,      apPL093_ASYNC_READ )       | 
           apBIT_BUILD( PL093_BMREAD,           apPL093_NON_BURST_READS )  | 
           apBIT_BUILD( PL093_SMBLSPOL,         apPL093_SMBLSPOL_LOW )     | 
           apBIT_BUILD( PL093_MW,               apPL093_MW_8BIT )          | 
           apBIT_BUILD( PL093_WP,               apPL093_WP_NO )            |  
           apBIT_BUILD( PL093_WAITEN,           apPL093_WAITEN_NO )        |  
           apBIT_BUILD( PL093_WAITPOL,          apPL093_WAITPOL_LOW )      | 
           apBIT_BUILD( PL093_RBLE,             apPL093_RBLE_HIGH );

    ((PL093_sRegisters *) eBase)->sBankRegs[ 2 ].SMBCR = \
           apBIT_BUILD( PL093_BIWRITEEN,        apPL093_BIWRITE_ACTIVE )   | 
           apBIT_BUILD( PL093_ADDRVALIDWRITEEN, apPL093_AVWE_ACTIVE )      | 
           apBIT_BUILD( PL093_BURSTLENWRITE,    apPL093_BL_WRITE_4BIT )    | 
           apBIT_BUILD( PL093_SYNCWRITEDEV,     apPL093_ASYNC_WRITE )      | 
           apBIT_BUILD( PL093_BMWRITE,          apPL093_NON_BURST_WRITES ) | 
           apBIT_BUILD( PL093_WRAPREADEN,       apPL093_WRAPREAD_DISABLED )| 
           apBIT_BUILD( PL093_BIREADEN,         apPL093_BIREAD_ACTIVE )    | 
           apBIT_BUILD( PL093_ADDRVALIDREADEN,  apPL093_AVRE_ACTIVE )      | 
           apBIT_BUILD( PL093_BURSTLENREAD,     apPL093_BL_READ_4BIT )     | 
           apBIT_BUILD( PL093_SYNCREADDEV,      apPL093_ASYNC_READ )       | 
           apBIT_BUILD( PL093_BMREAD,           apPL093_NON_BURST_READS )  | 
           apBIT_BUILD( PL093_SMBLSPOL,         apPL093_SMBLSPOL_LOW )     | 
           apBIT_BUILD( PL093_MW,               apPL093_MW_16BIT )         | 
           apBIT_BUILD( PL093_WP,               apPL093_WP_NO )            |  
           apBIT_BUILD( PL093_WAITEN,           apPL093_WAITEN_NO )        |  
           apBIT_BUILD( PL093_WAITPOL,          apPL093_WAITPOL_LOW )      | 
           apBIT_BUILD( PL093_RBLE,             apPL093_RBLE_HIGH );

    ((PL093_sRegisters *) eBase)->sBankRegs[ 3 ].SMBCR = \
           apBIT_BUILD( PL093_BIWRITEEN,        apPL093_BIWRITE_ACTIVE )   | 
           apBIT_BUILD( PL093_ADDRVALIDWRITEEN, apPL093_AVWE_ACTIVE )      | 
           apBIT_BUILD( PL093_BURSTLENWRITE,    apPL093_BL_WRITE_4BIT )    | 
           apBIT_BUILD( PL093_SYNCWRITEDEV,     apPL093_ASYNC_WRITE )      | 
           apBIT_BUILD( PL093_BMWRITE,          apPL093_NON_BURST_WRITES ) | 
           apBIT_BUILD( PL093_WRAPREADEN,       apPL093_WRAPREAD_DISABLED )| 
           apBIT_BUILD( PL093_BIREADEN,         apPL093_BIREAD_ACTIVE )    | 
           apBIT_BUILD( PL093_ADDRVALIDREADEN,  apPL093_AVRE_ACTIVE )      | 
           apBIT_BUILD( PL093_BURSTLENREAD,     apPL093_BL_READ_4BIT )     | 
           apBIT_BUILD( PL093_SYNCREADDEV,      apPL093_ASYNC_READ )       | 
           apBIT_BUILD( PL093_BMREAD,           apPL093_NON_BURST_READS )  | 
           apBIT_BUILD( PL093_SMBLSPOL,         apPL093_SMBLSPOL_LOW )     | 
           apBIT_BUILD( PL093_MW,               apPL093_MW_8BIT )          | 
           apBIT_BUILD( PL093_WP,               apPL093_WP_NO )            |  
           apBIT_BUILD( PL093_WAITEN,           apPL093_WAITEN_NO )        |  
           apBIT_BUILD( PL093_WAITPOL,          apPL093_WAITPOL_LOW )      | 
           apBIT_BUILD( PL093_RBLE,             apPL093_RBLE_HIGH );

    ((PL093_sRegisters *) eBase)->sBankRegs[ 4 ].SMBCR = \
           apBIT_BUILD( PL093_BIWRITEEN,        apPL093_BIWRITE_ACTIVE )   | 
           apBIT_BUILD( PL093_ADDRVALIDWRITEEN, apPL093_AVWE_ACTIVE )      | 
           apBIT_BUILD( PL093_BURSTLENWRITE,    apPL093_BL_WRITE_4BIT )    | 
           apBIT_BUILD( PL093_SYNCWRITEDEV,     apPL093_ASYNC_WRITE )      | 
           apBIT_BUILD( PL093_BMWRITE,          apPL093_NON_BURST_WRITES ) | 
           apBIT_BUILD( PL093_WRAPREADEN,       apPL093_WRAPREAD_DISABLED )| 
           apBIT_BUILD( PL093_BIREADEN,         apPL093_BIREAD_ACTIVE )    | 
           apBIT_BUILD( PL093_ADDRVALIDREADEN,  apPL093_AVRE_ACTIVE )      | 
           apBIT_BUILD( PL093_BURSTLENREAD,     apPL093_BL_READ_4BIT )     | 
           apBIT_BUILD( PL093_SYNCREADDEV,      apPL093_ASYNC_READ )       | 
           apBIT_BUILD( PL093_BMREAD,           apPL093_NON_BURST_READS )  | 
           apBIT_BUILD( PL093_SMBLSPOL,         apPL093_SMBLSPOL_LOW )     | 
           apBIT_BUILD( PL093_MW,               apPL093_MW_32BIT )         | 
           apBIT_BUILD( PL093_WP,               apPL093_WP_NO )            |  
           apBIT_BUILD( PL093_WAITEN,           apPL093_WAITEN_NO )        |  
           apBIT_BUILD( PL093_WAITPOL,          apPL093_WAITPOL_LOW )      | 
           apBIT_BUILD( PL093_RBLE,             apPL093_RBLE_HIGH );

    ((PL093_sRegisters *) eBase)->sBankRegs[ 5 ].SMBCR = \
           apBIT_BUILD( PL093_BIWRITEEN,        apPL093_BIWRITE_ACTIVE )   | 
           apBIT_BUILD( PL093_ADDRVALIDWRITEEN, apPL093_AVWE_ACTIVE )      | 
           apBIT_BUILD( PL093_BURSTLENWRITE,    apPL093_BL_WRITE_4BIT )    | 
           apBIT_BUILD( PL093_SYNCWRITEDEV,     apPL093_ASYNC_WRITE )      | 
           apBIT_BUILD( PL093_BMWRITE,          apPL093_NON_BURST_WRITES ) | 
           apBIT_BUILD( PL093_WRAPREADEN,       apPL093_WRAPREAD_DISABLED )| 
           apBIT_BUILD( PL093_BIREADEN,         apPL093_BIREAD_ACTIVE )    | 
           apBIT_BUILD( PL093_ADDRVALIDREADEN,  apPL093_AVRE_ACTIVE )      | 
           apBIT_BUILD( PL093_BURSTLENREAD,     apPL093_BL_READ_4BIT )     | 
           apBIT_BUILD( PL093_SYNCREADDEV,      apPL093_ASYNC_READ )       | 
           apBIT_BUILD( PL093_BMREAD,           apPL093_NON_BURST_READS )  | 
           apBIT_BUILD( PL093_SMBLSPOL,         apPL093_SMBLSPOL_LOW )     | 
           apBIT_BUILD( PL093_MW,               apPL093_MW_32BIT )         | 
           apBIT_BUILD( PL093_WP,               apPL093_WP_NO )            |  
           apBIT_BUILD( PL093_WAITEN,           apPL093_WAITEN_NO )        |  
           apBIT_BUILD( PL093_WAITPOL,          apPL093_WAITPOL_LOW )      | 
           apBIT_BUILD( PL093_RBLE,             apPL093_RBLE_HIGH );

    ((PL093_sRegisters *) eBase)->sBankRegs[ 6 ].SMBCR = \
           apBIT_BUILD( PL093_BIWRITEEN,        apPL093_BIWRITE_ACTIVE )   | 
           apBIT_BUILD( PL093_ADDRVALIDWRITEEN, apPL093_AVWE_ACTIVE )      | 
           apBIT_BUILD( PL093_BURSTLENWRITE,    apPL093_BL_WRITE_4BIT )    | 
           apBIT_BUILD( PL093_SYNCWRITEDEV,     apPL093_ASYNC_WRITE )      | 
           apBIT_BUILD( PL093_BMWRITE,          apPL093_NON_BURST_WRITES ) | 
           apBIT_BUILD( PL093_WRAPREADEN,       apPL093_WRAPREAD_DISABLED )| 
           apBIT_BUILD( PL093_BIREADEN,         apPL093_BIREAD_ACTIVE )    | 
           apBIT_BUILD( PL093_ADDRVALIDREADEN,  apPL093_AVRE_ACTIVE )      | 
           apBIT_BUILD( PL093_BURSTLENREAD,     apPL093_BL_READ_4BIT )     | 
           apBIT_BUILD( PL093_SYNCREADDEV,      apPL093_ASYNC_READ )       | 
           apBIT_BUILD( PL093_BMREAD,           apPL093_NON_BURST_READS )  | 
           apBIT_BUILD( PL093_SMBLSPOL,         apPL093_SMBLSPOL_LOW )     | 
           apBIT_BUILD( PL093_MW,               apPL093_MW_16BIT )         | 
           apBIT_BUILD( PL093_WP,               apPL093_WP_NO )            |  
           apBIT_BUILD( PL093_WAITEN,           apPL093_WAITEN_NO )        |  
           apBIT_BUILD( PL093_WAITPOL,          apPL093_WAITPOL_LOW )      | 
           apBIT_BUILD( PL093_RBLE,             apPL093_RBLE_HIGH );

#if !defined (apPL093_BANK7_BOOT)
    ((PL093_sRegisters *) eBase)->sBankRegs[ 7 ].SMBCR = \
           apBIT_BUILD( PL093_BIWRITEEN,        apPL093_BIWRITE_ACTIVE )   | 
           apBIT_BUILD( PL093_ADDRVALIDWRITEEN, apPL093_AVWE_ACTIVE )      | 
           apBIT_BUILD( PL093_BURSTLENWRITE,    apPL093_BL_WRITE_4BIT )    | 
           apBIT_BUILD( PL093_SYNCWRITEDEV,     apPL093_ASYNC_WRITE )      | 
           apBIT_BUILD( PL093_BMWRITE,          apPL093_NON_BURST_WRITES ) | 
           apBIT_BUILD( PL093_WRAPREADEN,       apPL093_WRAPREAD_DISABLED )| 
           apBIT_BUILD( PL093_BIREADEN,         apPL093_BIREAD_ACTIVE )    | 
           apBIT_BUILD( PL093_ADDRVALIDREADEN,  apPL093_AVRE_ACTIVE )      | 
           apBIT_BUILD( PL093_BURSTLENREAD,     apPL093_BL_READ_4BIT )     | 
           apBIT_BUILD( PL093_SYNCREADDEV,      apPL093_ASYNC_READ )       | 
           apBIT_BUILD( PL093_BMREAD,           apPL093_NON_BURST_READS )  | 
           apBIT_BUILD( PL093_SMBLSPOL,         apPL093_SMBLSPOL_LOW )     | 
           apBIT_BUILD( PL093_MW,               apPL093_MW_8BIT )          | 
           apBIT_BUILD( PL093_WP,               apPL093_WP_NO )            |  
           apBIT_BUILD( PL093_WAITEN,           apPL093_WAITEN_NO )        |  
           apBIT_BUILD( PL093_WAITPOL,          apPL093_WAITPOL_LOW )      | 
           apBIT_BUILD( PL093_RBLE,             apPL093_RBLE_HIGH );


    for( MemBank = 0; MemBank < 8; )
#else
    for( MemBank = 0; MemBank < 7; )
#endif
    {
        pBankRegs = &((PL093_sRegisters *) eBase)->sBankRegs[ MemBank++ ];

        /* Write IDCY value to SMBIDCYRx register */
        pBankRegs->SMBIDCYR = 0xF;

        /* Write WSTRD value to SMBWSTRDRx register */
        pBankRegs->SMBWSTRDR = 0x1F;

        /* Write WSTWR value to SMBWSTWRRx register */
        pBankRegs->SMBWSTWRR = 0x1F;  

        /* Write WSTOEN value to SMBWSTOENRx register */
        pBankRegs->SMBWSTOENR = 0x0;  

        /* Write WSTWEN value to SMBWSTWENRx register */
        pBankRegs->SMBWSTWENR = 0x1;

        /* Write WSTBRD value to SMBWSTBRDRx register */
        pBankRegs->SMBWSTBRDR = 0x1F;
    }

    /* Mark all memory banks as non-initialised */
    pState->uInit = 0;
}

/*====================================================================*/
PUBLIC apError apPL093_MemBankConfigSet( apOS_PL093_oId        oId,
                                         UWORD32               MemBank,
                                         CONST apPL093_sData * pBankData )
{
    PL093_sBankRegs * pBankRegs;    

    /* Define and set up pointer to state - pState */
    PL093_sStateStruct * CONST pState = apSTATE_GET(PL093, oId);
    
    /* Check Bank number */
    if( MemBank >= PL093_MB_NUMBER )
    {
        return (apError) apERR_PL093_INVALID_BANK;
    }    

    /* Check initialisation parameters */
    if( pBankData->IdleTurnAroundCycles >= (1 << bwPL093_IDCY) ) 
    {
        return (apError) apERR_PL093_INVALID_IDCY;
    }    

    if( pBankData->ReadAccessCycles >= (1 << bwPL093_WSTRD) ) 
    {
        return (apError) apERR_PL093_INVALID_WSTRD;
    }    
        
    if( pBankData->WriteAccessCycles >= (1 << bwPL093_WSTWR) ) 
    {
        return (apError) apERR_PL093_INVALID_WSTWR;
    }    
        
    if( pBankData->OutputEnAssertDelay >= (1 << bwPL093_WSTOEN) ) 
    {
        return (apError) apERR_PL093_INVALID_WSTOEN;
    }    

    if( pBankData->WriteEnAssertDelay >= (1 << bwPL093_WSTWEN) ) 
    {
        return (apError) apERR_PL093_INVALID_WSTWEN;
    }    

    if( pBankData->BurstReadDelay >= (1 << bwPL093_WSTBRD) ) 
    {
        return (apError) apERR_PL093_INVALID_WSTBRD;
    }    

    pBankRegs = &pState->pBaseAddress->sBankRegs[ MemBank ];

    /* Build SMBCRx register from the specified values */
    pBankRegs->SMBCR =
           apBIT_BUILD( PL093_BIWRITEEN,        pBankData->eBIWriteEn )        | 
           apBIT_BUILD( PL093_ADDRVALIDWRITEEN, pBankData->eAddrValidWriteEn ) | 
           apBIT_BUILD( PL093_BURSTLENWRITE,    pBankData->eBurstLenWrite )    | 
           apBIT_BUILD( PL093_SYNCWRITEDEV,     pBankData->eSyncWriteDev )     | 
           apBIT_BUILD( PL093_BMWRITE,          pBankData->eBMWrite )          | 
           apBIT_BUILD( PL093_WRAPREADEN,       pBankData->eWrapReadEn )       | 
           apBIT_BUILD( PL093_BIREADEN,         pBankData->eBIReadEn )         | 
           apBIT_BUILD( PL093_ADDRVALIDREADEN,  pBankData->eAddrValidReadEn )  | 
           apBIT_BUILD( PL093_BURSTLENREAD,     pBankData->eBurstLenRead )     | 
           apBIT_BUILD( PL093_SYNCREADDEV,      pBankData->eSyncReadDev )      | 
           apBIT_BUILD( PL093_BMREAD,           pBankData->eBMRead )           | 
           apBIT_BUILD( PL093_SMBLSPOL,         pBankData->eSMBLSPol )         | 
           apBIT_BUILD( PL093_MW,               pBankData->eMemoryWidth )      | 
           apBIT_BUILD( PL093_WP,               pBankData->eWriteProtect )     |  
           apBIT_BUILD( PL093_WAITEN,           pBankData->eWaitEn )           |  
           apBIT_BUILD( PL093_WAITPOL,          pBankData->eWaitPol )          | 
           apBIT_BUILD( PL093_RBLE,             pBankData->eRBLE );

    /* Write IDCY value to SMBIDCYRx register */
    pBankRegs->SMBIDCYR = pBankData->IdleTurnAroundCycles;

    /* Write WSTRD value to SMBWSTRDRx register */
    pBankRegs->SMBWSTRDR = pBankData->ReadAccessCycles;

    /* Write WSTWR value to SMBWSTWRRx register */
    pBankRegs->SMBWSTWRR = pBankData->WriteAccessCycles;
    
    /* Write WSTOEN value to SMBWSTOENRx register */
    pBankRegs->SMBWSTOENR = pBankData->OutputEnAssertDelay;
    
    /* Write WSTWEN value to SMBWSTWENRx register */
    pBankRegs->SMBWSTWENR = pBankData->WriteEnAssertDelay;

    /* Write WSTBRD value to SMBWSTBRDRx register */
    pBankRegs->SMBWSTBRDR = pBankData->BurstReadDelay;

    /* Set the initialisation bit */
    pState->uInit = (UBYTE8)( pState->uInit | (0x01 << MemBank) );
    
    return apERR_NONE;
}

/*====================================================================*/
PUBLIC apError apPL093_MemBankConfigGet( apOS_PL093_oId        oId,
                                         UWORD32               MemBank,
                                         apPL093_sData * CONST pBankData )
{
    UWORD32           ReadValue;
    PL093_sBankRegs * pBankRegs;    

    /* Define and set up pointer to state - pState */
    PL093_sStateStruct * CONST pState = apSTATE_GET(PL093, oId);
    
    /* Check Bank number */
    if( MemBank >= PL093_MB_NUMBER )
    {
        return (apError) apERR_PL093_INVALID_BANK;
    }    

    pBankRegs = &pState->pBaseAddress->sBankRegs[ MemBank ];

    /* Read IDCY value from SMBIDCYRx register */
    pBankData->IdleTurnAroundCycles = (UBYTE8) pBankRegs->SMBIDCYR;

    /* Read WSTRD value from SMBWSTRDRx register */
    pBankData->ReadAccessCycles = (UBYTE8) pBankRegs->SMBWSTRDR;

    /* Read WSTWR value from SMBWSTWRRx register */
    pBankData->WriteAccessCycles = (UBYTE8) pBankRegs->SMBWSTWRR;
    
    /* Read WSTOEN value from SMBWSTOENRx register */
    pBankData->OutputEnAssertDelay = (UBYTE8) pBankRegs->SMBWSTOENR;
    
    /* Read WSTWEN value from SMBWSTWENRx register */
    pBankData->WriteEnAssertDelay = (UBYTE8) pBankRegs->SMBWSTWENR;

    /* Read WSTBRD value from SMBWSTBRDRx register */
    pBankData->BurstReadDelay = (UBYTE8) pBankRegs->SMBWSTBRDR;

    /* Get configuration data from SMBCRx register */

    ReadValue = pBankRegs->SMBCR;

    pBankData->eBIWriteEn        = (apPL093_eBIWriteEn)        apBIT_GET(ReadValue, PL093_BIWRITEEN );
    pBankData->eAddrValidWriteEn = (apPL093_eAddrValidWriteEn) apBIT_GET(ReadValue, PL093_ADDRVALIDWRITEEN );
    pBankData->eBurstLenWrite    = (apPL093_eBurstLenWrite)    apBIT_GET(ReadValue, PL093_BURSTLENWRITE);
    pBankData->eSyncWriteDev     = (apPL093_eSyncWriteDev)     apBIT_GET(ReadValue, PL093_SYNCWRITEDEV);
    pBankData->eBMWrite          = (apPL093_eBMWrite)          apBIT_GET(ReadValue, PL093_BMWRITE);
    pBankData->eWrapReadEn       = (apPL093_eWrapReadEn)       apBIT_GET(ReadValue, PL093_WRAPREADEN );
    pBankData->eBIReadEn         = (apPL093_eBIReadEn)         apBIT_GET(ReadValue, PL093_BIREADEN );
    pBankData->eAddrValidReadEn  = (apPL093_eAddrValidReadEn)  apBIT_GET(ReadValue, PL093_ADDRVALIDREADEN);
    pBankData->eBurstLenRead     = (apPL093_eBurstLenRead)     apBIT_GET(ReadValue, PL093_BURSTLENREAD);
    pBankData->eSyncReadDev      = (apPL093_eSyncReadDev)      apBIT_GET(ReadValue, PL093_SYNCREADDEV);
    pBankData->eBMRead           = (apPL093_eBMRead)           apBIT_GET(ReadValue, PL093_BMREAD);
    pBankData->eSMBLSPol         = (apPL093_eSMBLSPol)         apBIT_GET(ReadValue, PL093_SMBLSPOL);
    pBankData->eMemoryWidth      = (apPL093_eMW)               apBIT_GET(ReadValue, PL093_MW);
    pBankData->eWriteProtect     = (apPL093_eWP)               apBIT_GET(ReadValue, PL093_WP);
    pBankData->eWaitEn           = (apPL093_eWaitEn)           apBIT_GET(ReadValue, PL093_WAITEN);
    pBankData->eWaitPol          = (apPL093_eWaitPol)          apBIT_GET(ReadValue, PL093_WAITPOL);
    pBankData->eRBLE             = (apPL093_eRBLE)             apBIT_GET(ReadValue, PL093_RBLE);
    
    return apERR_NONE;
}

/*====================================================================*/
PUBLIC apError apPL093_ErrorGet( apOS_PL093_oId oId,
                                 UWORD32        MemBank,
                                 BOOL * CONST   pWaitToutErr )
{
    PL093_sBankRegs * pBankRegs;    

    /* Define and set up pointer to state - pState */
    PL093_sStateStruct * CONST pState = apSTATE_GET(PL093, oId);
    
    /* Check Bank number */
    if( MemBank >= PL093_MB_NUMBER )
    {
        return (apError) apERR_PL093_INVALID_BANK;
    }    

    pBankRegs = &pState->pBaseAddress->sBankRegs[ MemBank ];

    /* Retrieve the error bit from SMBSRx register */
    *pWaitToutErr = ((BOOL) apBIT_GET( pBankRegs->SMBSR, PL093_WAITTOUTERR ));
    
    /* Clear the error bit in SMBSRx register */
    pBankRegs->SMBSR = ( 1 << bsPL093_WAITTOUTERR );

    return apERR_NONE;
}

/*====================================================================*/
PUBLIC apError apPL093_WriteEnable( apOS_PL093_oId oId,
                                    UWORD32        MemBank )
{
    /* Define and set up pointer to state - pState */
    PL093_sStateStruct * CONST pState = apSTATE_GET(PL093, oId);
    
    /* Check Bank number */
    if( MemBank >= PL093_MB_NUMBER )
    {
        return (apError) apERR_PL093_INVALID_BANK;
    }    

    apBIT_SET( pState->pBaseAddress->sBankRegs[ MemBank ].SMBCR, PL093_WP, apPL093_WP_NO);

    return apERR_NONE;
}

/*====================================================================*/
PUBLIC apError apPL093_WriteDisable( apOS_PL093_oId oId,
                                     UWORD32        MemBank )
{
    /* Define and set up pointer to state - pState */
    PL093_sStateStruct * CONST pState = apSTATE_GET(PL093, oId);
    
    /* Check Bank number */
    if( MemBank >= PL093_MB_NUMBER )
    {
        return (apError) apERR_PL093_INVALID_BANK;
    }    

    apBIT_SET( pState->pBaseAddress->sBankRegs[ MemBank ].SMBCR, PL093_WP, apPL093_WP_YES);
    
    return apERR_NONE;
}

/*====================================================================*/
PUBLIC void apPL093_ControlSet( apOS_PL093_oId           oId,
                                CONST apPL093_sControl * pControl )
{
    /* Define and set up pointer to state - pState */
    PL093_sStateStruct * CONST pState = apSTATE_GET(PL093, oId);
    
    /* Build SSMCCR register from the specified values */
    pState->pBaseAddress->SSMCCR =
        apBIT_BUILD( PL093_SMCLOCKEN,   pControl->eSMClockEn ) | 
        apBIT_BUILD( PL093_MEMCLKRATIO, pControl->eMemClkRatio ); 
}

/*====================================================================*/
PUBLIC void apPL093_ControlGet( apOS_PL093_oId           oId,
                                apPL093_sControl * CONST pControl )
{
    UWORD32 ReadValue;

    /* Define and set up pointer to state - pState */
    PL093_sStateStruct * CONST pState = apSTATE_GET(PL093, oId);
    
    /* Get control data from SSMCCR register */
    ReadValue = pState->pBaseAddress->SSMCCR;
  
    pControl->eSMClockEn   = (apPL093_eSMClockEn)   apBIT_GET(ReadValue, PL093_SMCLOCKEN);
    pControl->eMemClkRatio = (apPL093_eMemClkRatio) apBIT_GET(ReadValue, PL093_MEMCLKRATIO);
}

/*====================================================================*/
PUBLIC BOOL apPL093_StatusGet( apOS_PL093_oId oId )
{
    /* Define and set up pointer to state - pState */
    PL093_sStateStruct * CONST pState = apSTATE_GET(PL093, oId);
    
    /* Retrieve the Wait Status bit from SSMCSR register */
    return (BOOL) apBIT_GET( pState->pBaseAddress->SSMCSR, PL093_WAITSTATUS );
}
