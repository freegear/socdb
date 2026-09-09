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
 * File:     smctst.c,v
 * Revision: 1.20
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : smctst.c.rca
 *  File Revision          : 1.1
 * 
 *  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
 *  ----------------------------------------
 *
 * Test code for the SMC (Static Memory Controller) code.
 */

/*
 * --------Included Headers--------
 * These headers assume a search path including the parent directory
 * for this source file.
 */
#include "../apcommon/aptypes.h"
#include "../apos/apos.h"
#include "../aptest/aptest.h"   /* Test header */
#include "apsmc.h"              /* API (public) header */

PROTECTED apTEST_eResult apSMC_SelfTest( UWORD32 Id,
                                         UWORD32 RegBase, 
                                         UWORD32 NumSources, 
                                         CONST apOS_INT_oInterruptSource * CONST pInt );

/*
 * Description:
 * This is the main test routine. 
 */
PROTECTED apTEST_eResult apSMC_SelfTest( UWORD32 Id, 
                                         UWORD32 RegBase,
                                         UWORD32 NumSources,
                                         CONST apOS_INT_oInterruptSource * CONST pInt )
{
    CONST apOS_SMC_oId oId = (apOS_SMC_oId ) Id;

    UWORD32 I;
    apSMC_sData sMemBankData, sMemBankCheck;
    apTEST_eResult TheResult, BankResult;

    BOOL WaitToutErr, WriteProtErr, HSizeErr;
    
    IGNORE(pInt);
    IGNORE(NumSources);

    TheResult = apTEST_PASS;

    /* Initialise SMC */
    apSMC_Initialize( oId, (apOS_System_eBaseAddress) RegBase, 0, aNULL, aNULL );

    /* For test coverage */
    apSMC_StateSizeGet();

    /* Set up each memory bank */
#if defined (apSMC_BANK7_BOOT)    
    for (I = 0; I < 7 ; I++)
#else
    for (I = 0; I < 8 ; I++)
#endif
    {
        /* Set up dummy memory bank data */
        sMemBankData.eMemoryWidth  = (apSMC_eMW)      (I % 3);
        sMemBankData.eBurstMode    = (apSMC_eBM)      (I % 2);
        sMemBankData.eWriteProtect = (apSMC_eWP)      (I % 2);
        sMemBankData.eCSPol        = (apSMC_eCSPol)   (I % 2);
        sMemBankData.eWaitEn       = (apSMC_eWaitEn)  (I % 2);
        sMemBankData.eWaitPol      = (apSMC_eWaitPol) (I % 2);
        sMemBankData.eRBLE         = (apSMC_eRBLE)    (I % 2);
        
        sMemBankData.ReadAccessCycles     = (UBYTE8)  (0x1F >> (I % 6));
        sMemBankData.WriteAccessCycles    = (UBYTE8) ((0x1F << (I % 6)) & 0x1F);
        sMemBankData.IdleTurnAroundCycles = (UBYTE8) ((0x0F << (I % 4)) & 0x0F);
        sMemBankData.OutputEnAssertDelay  = (UBYTE8)  (0x0F >> (I % 4));
        sMemBankData.WriteEnAssertDelay   = (UBYTE8) ((0x0F << (I % 4)) & 0x0F);

        /* Initialise the memory bank */
        apSMC_MemBankConfigSet(oId, I, &sMemBankData);

        /* Read it back and compare */
        apSMC_MemBankConfigGet(oId, I, &sMemBankCheck);

        BankResult = (apTEST_eResult) (
            (sMemBankData.eMemoryWidth         == sMemBankCheck.eMemoryWidth)  &&
            (sMemBankData.eBurstMode           == sMemBankCheck.eBurstMode)    &&
            (sMemBankData.eWriteProtect        == sMemBankCheck.eWriteProtect) &&
            (sMemBankData.eCSPol               == sMemBankCheck.eCSPol)        &&
            (sMemBankData.eWaitEn              == sMemBankCheck.eWaitEn)       &&
            (sMemBankData.eWaitPol             == sMemBankCheck.eWaitPol)      &&
            (sMemBankData.eRBLE                == sMemBankCheck.eRBLE)         &&

            (sMemBankData.ReadAccessCycles     == sMemBankCheck.ReadAccessCycles)     &&
            (sMemBankData.WriteAccessCycles    == sMemBankCheck.WriteAccessCycles)    &&
            (sMemBankData.IdleTurnAroundCycles == sMemBankCheck.IdleTurnAroundCycles) &&
            (sMemBankData.OutputEnAssertDelay  == sMemBankCheck.OutputEnAssertDelay)  &&
            (sMemBankData.WriteEnAssertDelay   == sMemBankCheck.WriteEnAssertDelay));

        /* Check initialised */
        BankResult = (apTEST_eResult) (BankResult & ((apSMC_InitGet( oId ) & (1 << I)) >> I));

        /* Check Write Protection functions */
        
        apSMC_WriteEnable( oId, I );

        apSMC_MemBankConfigGet( oId, I, &sMemBankCheck );

        BankResult = (apTEST_eResult) (BankResult & (sMemBankCheck.eWriteProtect == apSMC_WP_NO));        
       
        apSMC_WriteDisable( oId, I );

        apSMC_MemBankConfigGet( oId, I, &sMemBankCheck );
   
        BankResult = (apTEST_eResult) (BankResult & (sMemBankCheck.eWriteProtect == apSMC_WP_YES));        

        apTEST_Report( "Testing Memory Bank: ", I, apTEST_FORMAT_LONG_DEC );
        apTEST_Remove_CR();
        apTEST_Report( "  Read Error Flags:", 0, apTEST_FORMAT_NO_NUMBER );
        apTEST_Remove_CR();
        
        apSMC_ErrorGet( oId, I, &WaitToutErr, &WriteProtErr, &HSizeErr);

        if (!( WaitToutErr | WriteProtErr | HSizeErr ))
        {
            apTEST_Report( " None  ", 0, apTEST_FORMAT_NO_NUMBER );
            apTEST_Remove_CR();
        }
        else
        {
            if( WaitToutErr )
            {
                apTEST_Report( " WaitToutErr", 0, apTEST_FORMAT_NO_NUMBER );
                apTEST_Remove_CR();
            }
            if( WriteProtErr )
            {
                apTEST_Report( " WriteProtErr", 0, apTEST_FORMAT_NO_NUMBER );
                apTEST_Remove_CR();
            }
            if( HSizeErr )
            {
                apTEST_Report( " HSizeErr", 0, apTEST_FORMAT_NO_NUMBER );
                apTEST_Remove_CR();
            }
        }                        
       
        apTEST_Print( BankResult, "" );
    
        TheResult = (apTEST_eResult) (TheResult & BankResult);
    }

    return TheResult;    
}



