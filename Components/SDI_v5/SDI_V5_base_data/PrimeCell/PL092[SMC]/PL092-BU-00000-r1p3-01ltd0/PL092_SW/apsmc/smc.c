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
 * File:     smc.c,v
 * Revision: 1.26
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : smc.c.rca
 *  File Revision          : 1.2
 * 
 *  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
 *  ----------------------------------------
 *
 * Code implementation file for the SMC (Static Memory Controller) code.
 */

/*
 * --------Included Headers--------
 * These headers assume a search path including the parent directory
 * for this source file.
 */
#include "../apcommon/aptypes.h"    /*Basic project definitions*/
#include "../apcommon/apbitops.h"   /*Bit manipulation macros*/
#include "../apos/apos.h"
#include "apsmc.h"                  /*API (public) header*/
#include "smc.h"                    /*Private header*/

/*
 * Description:
 * Array to hold the state of each SMC
 */
#if !defined(apOS_NO_STATIC_STATE) || (!apOS_NO_STATIC_STATE)
PRIVATE SMC_sStateStruct SMC_sState[apOS_SMC_MAXIMUM];
#endif

/*
 * --------API (Public) Procedure definitions--------
 */

PUBLIC UWORD32 apSMC_StateSizeGet( void )
{
   return sizeof( SMC_sStateStruct );
}

/*====================================================================*/
PUBLIC UBYTE8 apSMC_InitGet( apOS_SMC_oId oId )
{
    /* Define and set up pointer to state - pState */
    SMC_sStateStruct * CONST pState = apSTATE_GET(SMC, oId);

    return pState->uSMC_Init;
}

/*====================================================================*/
PUBLIC void apSMC_Initialize( apOS_SMC_oId oId,
                              apOS_System_eBaseAddress eBase,
                              UWORD32 Interrupts,
                              CONST apOS_INT_oInterruptSource * pSources,
                              void *pInitial )
{
    UWORD32 MemBank;
    
    /* Define and set up pointer to state - pState */
    SMC_sStateStruct * CONST pState = apSTATE_GET(SMC, oId);
   
    IGNORE(Interrupts);
    IGNORE(pSources);
    IGNORE(pInitial);

    apINSTANCE_CHECK(SMC);
    
    /* Store base address into device data array */
    pState->pBaseAddress = (SMC_sRegisters *) eBase;

    /* Set up default (as after reset) parameters for all memory banks */
    
    /* Build SMBCRx registers */
    ((SMC_sRegisters *) eBase)->SMC_sBank[ 0 ].SMBCR = \
           apBIT_BUILD( SMC_MW,      (UWORD32) apSMC_MW_32BIT )   | 
           apBIT_BUILD( SMC_BM,      (UWORD32) apSMC_BM_NO )      | 
           apBIT_BUILD( SMC_WP,      (UWORD32) apSMC_WP_NO )      |  
           apBIT_BUILD( SMC_CSPOL,   (UWORD32) apSMC_CSPOL_LO )   | 
           apBIT_BUILD( SMC_WAITEN,  (UWORD32) apSMC_WAITEN_NO )  |  
           apBIT_BUILD( SMC_WAITPOL, (UWORD32) apSMC_WAITPOL_LO ) | 
           apBIT_BUILD( SMC_RBLE,    (UWORD32) apSMC_RBLE_HI );

    ((SMC_sRegisters *) eBase)->SMC_sBank[ 1 ].SMBCR = \
           apBIT_BUILD( SMC_MW,      (UWORD32) apSMC_MW_8BIT )    | 
           apBIT_BUILD( SMC_BM,      (UWORD32) apSMC_BM_NO )      | 
           apBIT_BUILD( SMC_WP,      (UWORD32) apSMC_WP_NO )      |  
           apBIT_BUILD( SMC_CSPOL,   (UWORD32) apSMC_CSPOL_LO )   | 
           apBIT_BUILD( SMC_WAITEN,  (UWORD32) apSMC_WAITEN_NO )  |  
           apBIT_BUILD( SMC_WAITPOL, (UWORD32) apSMC_WAITPOL_LO ) | 
           apBIT_BUILD( SMC_RBLE,    (UWORD32) apSMC_RBLE_HI );

    ((SMC_sRegisters *) eBase)->SMC_sBank[ 2 ].SMBCR = \
           apBIT_BUILD( SMC_MW,      (UWORD32) apSMC_MW_16BIT )   | 
           apBIT_BUILD( SMC_BM,      (UWORD32) apSMC_BM_NO )      | 
           apBIT_BUILD( SMC_WP,      (UWORD32) apSMC_WP_NO )      |  
           apBIT_BUILD( SMC_CSPOL,   (UWORD32) apSMC_CSPOL_LO )   | 
           apBIT_BUILD( SMC_WAITEN,  (UWORD32) apSMC_WAITEN_NO )  |  
           apBIT_BUILD( SMC_WAITPOL, (UWORD32) apSMC_WAITPOL_LO ) | 
           apBIT_BUILD( SMC_RBLE,    (UWORD32) apSMC_RBLE_HI );

    ((SMC_sRegisters *) eBase)->SMC_sBank[ 3 ].SMBCR = \
           apBIT_BUILD( SMC_MW,      (UWORD32) apSMC_MW_8BIT )    | 
           apBIT_BUILD( SMC_BM,      (UWORD32) apSMC_BM_NO )      | 
           apBIT_BUILD( SMC_WP,      (UWORD32) apSMC_WP_NO )      |  
           apBIT_BUILD( SMC_CSPOL,   (UWORD32) apSMC_CSPOL_LO )   | 
           apBIT_BUILD( SMC_WAITEN,  (UWORD32) apSMC_WAITEN_NO )  |  
           apBIT_BUILD( SMC_WAITPOL, (UWORD32) apSMC_WAITPOL_LO ) | 
           apBIT_BUILD( SMC_RBLE,    (UWORD32) apSMC_RBLE_HI );

    ((SMC_sRegisters *) eBase)->SMC_sBank[ 4 ].SMBCR = \
           apBIT_BUILD( SMC_MW,      (UWORD32) apSMC_MW_32BIT )   | 
           apBIT_BUILD( SMC_BM,      (UWORD32) apSMC_BM_NO )      | 
           apBIT_BUILD( SMC_WP,      (UWORD32) apSMC_WP_NO )      |  
           apBIT_BUILD( SMC_CSPOL,   (UWORD32) apSMC_CSPOL_LO )   | 
           apBIT_BUILD( SMC_WAITEN,  (UWORD32) apSMC_WAITEN_NO )  |  
           apBIT_BUILD( SMC_WAITPOL, (UWORD32) apSMC_WAITPOL_LO ) | 
           apBIT_BUILD( SMC_RBLE,    (UWORD32) apSMC_RBLE_HI );

    ((SMC_sRegisters *) eBase)->SMC_sBank[ 5 ].SMBCR = \
           apBIT_BUILD( SMC_MW,      (UWORD32) apSMC_MW_32BIT )   | 
           apBIT_BUILD( SMC_BM,      (UWORD32) apSMC_BM_NO )      | 
           apBIT_BUILD( SMC_WP,      (UWORD32) apSMC_WP_NO )      |  
           apBIT_BUILD( SMC_CSPOL,   (UWORD32) apSMC_CSPOL_LO )   | 
           apBIT_BUILD( SMC_WAITEN,  (UWORD32) apSMC_WAITEN_NO )  |  
           apBIT_BUILD( SMC_WAITPOL, (UWORD32) apSMC_WAITPOL_LO ) | 
           apBIT_BUILD( SMC_RBLE,    (UWORD32) apSMC_RBLE_HI );

    ((SMC_sRegisters *) eBase)->SMC_sBank[ 6 ].SMBCR = \
           apBIT_BUILD( SMC_MW,      (UWORD32) apSMC_MW_16BIT )   | 
           apBIT_BUILD( SMC_BM,      (UWORD32) apSMC_BM_NO )      | 
           apBIT_BUILD( SMC_WP,      (UWORD32) apSMC_WP_NO )      |  
           apBIT_BUILD( SMC_CSPOL,   (UWORD32) apSMC_CSPOL_LO )   | 
           apBIT_BUILD( SMC_WAITEN,  (UWORD32) apSMC_WAITEN_NO )  |  
           apBIT_BUILD( SMC_WAITPOL, (UWORD32) apSMC_WAITPOL_LO ) | 
           apBIT_BUILD( SMC_RBLE,    (UWORD32) apSMC_RBLE_HI );

#if !defined (apSMC_BANK7_BOOT)
    ((SMC_sRegisters *) eBase)->SMC_sBank[ 7 ].SMBCR = \
           apBIT_BUILD( SMC_MW,      (UWORD32) apSMC_MW_8BIT )    | 
           apBIT_BUILD( SMC_BM,      (UWORD32) apSMC_BM_NO )      | 
           apBIT_BUILD( SMC_WP,      (UWORD32) apSMC_WP_NO )      |  
           apBIT_BUILD( SMC_CSPOL,   (UWORD32) apSMC_CSPOL_LO )   | 
           apBIT_BUILD( SMC_WAITEN,  (UWORD32) apSMC_WAITEN_NO )  |  
           apBIT_BUILD( SMC_WAITPOL, (UWORD32) apSMC_WAITPOL_LO ) | 
           apBIT_BUILD( SMC_RBLE,    (UWORD32) apSMC_RBLE_HI );

    for (MemBank = 0; MemBank < 8; MemBank++)
#else
    for (MemBank = 0; MemBank < 7; MemBank++)
#endif
    {
        /* Write IDCY value to SMBIDCYRx register */
        ((SMC_sRegisters *) eBase)->SMC_sBank[ MemBank ].SMBIDCYR = 0xF;

        /* Write WST1 value to SMBWST1Rx register */
        ((SMC_sRegisters *) eBase)->SMC_sBank[ MemBank ].SMBWST1R = 0x1F;

        /* Write WST2 value to SMBWST2Rx register */
        ((SMC_sRegisters *) eBase)->SMC_sBank[ MemBank ].SMBWST2R = 0x1F;
    
        /* Write WSTOEN value to SMBWSTOENRx register */
        ((SMC_sRegisters *) eBase)->SMC_sBank[ MemBank ].SMBWSTOENR = 0x0;
    
        /* Write WSTWEN value to SMBWSTWENRx register */
        ((SMC_sRegisters *) eBase)->SMC_sBank[ MemBank ].SMBWSTWENR = 0x0;
    }

    /* Mark all memory banks as non-initialised */
    pState->uSMC_Init = 0;
}

/*====================================================================*/
PUBLIC apError apSMC_MemBankConfigSet( apOS_SMC_oId        oId,
                                       UWORD32             MemBank,
                                       CONST apSMC_sData * pBankData )
{
    /* Define and set up pointer to state - pState */
    SMC_sStateStruct * CONST pState = apSTATE_GET(SMC, oId);
    
    /* Define and set up pointer to base address - pBase */
    SMC_sRegisters * CONST pBase = pState->pBaseAddress;

    /* Check Bank number */
    if( MemBank >= SMC_MB_NUMBER )
    {
        return (apError) apERR_SMC_INVALIDBANK;
    }    

    /* Check initialisation parameters */
    if( pBankData->IdleTurnAroundCycles >= (1 << bwSMC_IDCY) ) 
    {
        return (apError) apERR_SMC_INVALIDWRITEWAITSTATES;
    }    

    if( pBankData->ReadAccessCycles >= (1 << bwSMC_WST1) ) 
    {
        return (apError) apERR_SMC_INVALIDREADWAITSTATES;
    }    
        
    if( pBankData->WriteAccessCycles >= (1 << bwSMC_WST2) ) 
    {
        return (apError) apERR_SMC_INVALIDIDLECYCLES;
    }    
        
    if( pBankData->OutputEnAssertDelay >= (1 << bwSMC_WSTOEN) ) 
    {
        return (apError) apERR_SMC_INVALIDOUTPUTENDELAY;
    }    

    if( pBankData->WriteEnAssertDelay >= (1 << bwSMC_WSTWEN) ) 
    {
        return (apError) apERR_SMC_INVALIDWRITEENDELAY;
    }    

    /* Build SMBCRx register from the specified variables */
    pBase->SMC_sBank[ MemBank ].SMBCR = \
                apBIT_BUILD( SMC_MW,      (UWORD32) pBankData->eMemoryWidth )  | 
                apBIT_BUILD( SMC_BM,      (UWORD32) pBankData->eBurstMode )    | 
                apBIT_BUILD( SMC_WP,      (UWORD32) pBankData->eWriteProtect ) |  
                apBIT_BUILD( SMC_CSPOL,   (UWORD32) pBankData->eCSPol )        | 
                apBIT_BUILD( SMC_WAITEN,  (UWORD32) pBankData->eWaitEn )       |  
                apBIT_BUILD( SMC_WAITPOL, (UWORD32) pBankData->eWaitPol )      | 
                apBIT_BUILD( SMC_RBLE,    (UWORD32) pBankData->eRBLE );

    /* Write IDCY value to SMBIDCYRx register */
    pBase->SMC_sBank[ MemBank ].SMBIDCYR = pBankData->IdleTurnAroundCycles;

    /* Write WST1 value to SMBWST1Rx register */
    pBase->SMC_sBank[ MemBank ].SMBWST1R = pBankData->ReadAccessCycles;

    /* Write WST2 value to SMBWST2Rx register */
    pBase->SMC_sBank[ MemBank ].SMBWST2R = pBankData->WriteAccessCycles;
    
    /* Write WSTOEN value to SMBWSTOENRx register */
    pBase->SMC_sBank[ MemBank ].SMBWSTOENR = pBankData->OutputEnAssertDelay;
    
    /* Write WSTWEN value to SMBWSTWENRx register */
    pBase->SMC_sBank[ MemBank ].SMBWSTWENR = pBankData->WriteEnAssertDelay;

    /* Set the initialisation bit */
    pState->uSMC_Init = (UBYTE8)(pState->uSMC_Init | ( 0x01 << MemBank ));
    
    return apERR_NONE;
}

/*====================================================================*/
PUBLIC apError apSMC_MemBankConfigGet( apOS_SMC_oId        oId,
                                       UWORD32             MemBank,
                                       apSMC_sData * CONST pBankData )
{
    /* Define and set up pointer to state - pState */
    SMC_sStateStruct * CONST pState = apSTATE_GET(SMC, oId);
    
    /* Define and set up pointer to base address - pBase */
    SMC_sRegisters * CONST pBase = pState->pBaseAddress;

    /* Check Bank number */
    if( MemBank >= SMC_MB_NUMBER )
    {
        return (apError) apERR_SMC_INVALIDBANK;
    }    

    /* Read IDCY value from SMBIDCYRx register */
    pBankData->IdleTurnAroundCycles = (UBYTE8) pBase->SMC_sBank[ MemBank ].SMBIDCYR;

    /* Read WST1 value from SMBWST1Rx register */
    pBankData->ReadAccessCycles = (UBYTE8) pBase->SMC_sBank[ MemBank ].SMBWST1R;

    /* Read WST2 value from SMBWST2Rx register */
    pBankData->WriteAccessCycles = (UBYTE8) pBase->SMC_sBank[ MemBank ].SMBWST2R;
    
    /* Read WSTOEN value from SMBWSTOENRx register */
    pBankData->OutputEnAssertDelay = (UBYTE8) pBase->SMC_sBank[ MemBank ].SMBWSTOENR;
    
    /* Reads WSTWEN value from SMBWSTWENRx register */
    pBankData->WriteEnAssertDelay = (UBYTE8) pBase->SMC_sBank[ MemBank ].SMBWSTWENR;

    /* Get configuration data from SMBCRx register */

    pBankData->eMemoryWidth  = (apSMC_eMW)      apBIT_GET(pBase->SMC_sBank[ MemBank ].SMBCR,SMC_MW);
    pBankData->eBurstMode    = (apSMC_eBM)      apBIT_GET(pBase->SMC_sBank[ MemBank ].SMBCR,SMC_BM);
    pBankData->eWriteProtect = (apSMC_eWP)      apBIT_GET(pBase->SMC_sBank[ MemBank ].SMBCR,SMC_WP);
    pBankData->eCSPol        = (apSMC_eCSPol)   apBIT_GET(pBase->SMC_sBank[ MemBank ].SMBCR,SMC_CSPOL);
    pBankData->eWaitEn       = (apSMC_eWaitEn)  apBIT_GET(pBase->SMC_sBank[ MemBank ].SMBCR,SMC_WAITEN);
    pBankData->eWaitPol      = (apSMC_eWaitPol) apBIT_GET(pBase->SMC_sBank[ MemBank ].SMBCR,SMC_WAITPOL);
    pBankData->eRBLE         = (apSMC_eRBLE)    apBIT_GET(pBase->SMC_sBank[ MemBank ].SMBCR,SMC_RBLE);
    
    return apERR_NONE;
}

/*====================================================================*/
PUBLIC apError apSMC_ErrorGet( apOS_SMC_oId   oId,
                               UWORD32        MemBank,
                               BOOL * CONST   pWaitToutErr,
                               BOOL * CONST   pWriteProtErr,
                               BOOL * CONST   pHSizeErr )
{
    /* Define and set up pointer to state - pState */
    SMC_sStateStruct * CONST pState = apSTATE_GET(SMC, oId);
    
    /* Define and set up pointer to base address - pBase */
    SMC_sRegisters * CONST pBase = pState->pBaseAddress;

    /* Check Bank number */
    if( MemBank >= SMC_MB_NUMBER )
    {
        return (apError) apERR_SMC_INVALIDBANK;
    }    

    /* Retrieve the error bits from SMBSRx register*/
    *pHSizeErr     = (BOOL) apBIT_GET( pBase->SMC_sBank[ MemBank ].SMBSR, SMC_HSIZEERR);
    *pWriteProtErr = (BOOL) apBIT_GET( pBase->SMC_sBank[ MemBank ].SMBSR, SMC_WRITEPROTERR);
    *pWaitToutErr  = (BOOL) apBIT_GET( pBase->SMC_sBank[ MemBank ].SMBSR, SMC_WAITTOUTERR);
    
    /* Clear the error bits in SMBSRx register */
    pBase->SMC_sBank[ MemBank ].SMBSR = ( 1 << bsSMC_HSIZEERR )     |
                                        ( 1 << bsSMC_WRITEPROTERR ) |
                                        ( 1 << bsSMC_WAITTOUTERR );
    return apERR_NONE;
}

/*====================================================================*/
PUBLIC apError apSMC_WriteEnable ( apOS_SMC_oId   oId,
                                   UWORD32        MemBank )
{
    /* Define and set up pointer to state - pState */
    SMC_sStateStruct * CONST pState = apSTATE_GET(SMC, oId);
    
    /* Define and set up pointer to base address - pBase */
    SMC_sRegisters * CONST pBase = pState->pBaseAddress;

    /* Check Bank number */
    if( MemBank >= SMC_MB_NUMBER )
    {
        return (apError) apERR_SMC_INVALIDBANK;
    }    

    apBIT_SET( pBase->SMC_sBank[ MemBank ].SMBCR, SMC_WP, apSMC_WP_NO);

    return apERR_NONE;
}

/*====================================================================*/
PUBLIC apError apSMC_WriteDisable ( apOS_SMC_oId   oId,
                                    UWORD32        MemBank )
{
    /* Define and set up pointer to state - pState */
    SMC_sStateStruct * CONST pState = apSTATE_GET(SMC, oId);
    
    /* Define and set up pointer to base address - pBase */
    SMC_sRegisters * CONST pBase = pState->pBaseAddress;

    /* Check Bank number */
    if( MemBank >= SMC_MB_NUMBER )
    {
        return (apError) apERR_SMC_INVALIDBANK;
    }    

    apBIT_SET( pBase->SMC_sBank[ MemBank ].SMBCR, SMC_WP, apSMC_WP_YES);
    
    return apERR_NONE;
}


/*
 * --------Private Procedure definitions--------
 * There are currently no private procedures in this module
 */
