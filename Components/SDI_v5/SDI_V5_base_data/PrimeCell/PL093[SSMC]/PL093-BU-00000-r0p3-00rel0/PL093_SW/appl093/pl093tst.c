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
 * File:     pl093tst.c,v
 * Revision: 1.5
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : pl093tst.c.rca
 *  File Revision          : 1.2
 * 
 *  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
 *  ----------------------------------------
 *
 * Test code for the Synchronous Static Memory Controller PL093.
 */

/*
 * --------Included Headers--------
 * These headers assume a search path including the parent directory
 * for this source file.
 */
#include "../apcommon/aptypes.h"
#include "../apos/apos.h"
#include "../aptest/aptest.h"    /* Test header */
#include "appl093.h"             /* API (public) header */
#include "pl093.h"               /* API (private) header included for test purposes)*/

PROTECTED apTEST_eResult apPL093_SelfTest( UWORD32 Id,
                                           UWORD32 RegBase, 
                                           UWORD32 NumSources, 
                                           CONST apOS_INT_oInterruptSource * CONST pInt );

/* Private routines to test error conditions */
PRIVATE apTEST_eResult PL093_Err_MemBankConfigSet( apOS_PL093_oId oId );
PRIVATE apTEST_eResult PL093_Err_InvalidBankSet( apOS_PL093_oId oId );

/*
 * Description:
 * This is the main test routine. 
 */
PROTECTED apTEST_eResult apPL093_SelfTest( UWORD32 Id,
                                           UWORD32 RegBase, 
                                           UWORD32 NumSources, 
                                           CONST apOS_INT_oInterruptSource * CONST pInt )
{
    CONST apOS_PL093_oId oId = (apOS_PL093_oId ) Id;

    UWORD32 I;
    apPL093_sData    sMemBankData, sMemBankCheck;
    apPL093_sControl sControlCheck, sControlData = {
                                                    apPL093_SMCLK_ACTIVE_ACCESS,
                                                    apPL093_SMMEMCLK_HCLK_3 };
    
    apTEST_eResult TheResult, BankResult;

    BOOL WaitToutErr;
    
    IGNORE(pInt);
    IGNORE(NumSources);

    /* Initialise PL093 */
    apPL093_Initialize( oId, (apOS_System_eBaseAddress) RegBase, 0, aNULL, aNULL );

    /* For test coverage */
    apPL093_StateSizeGet();

    /* Set and read control data */
    apPL093_ControlSet( oId, &sControlData );
    apPL093_ControlGet( oId, &sControlCheck );
       
    /* Compare set and read control data */
    TheResult = (apTEST_eResult) (
        (sControlData.eSMClockEn   == sControlCheck.eSMClockEn) &&
        (sControlData.eMemClkRatio == sControlCheck.eMemClkRatio) );
    
    apTEST_Report( "Check control data", 0, apTEST_FORMAT_NO_NUMBER );
    apTEST_Remove_CR();
    apTEST_Print( TheResult, "" );

    /* Set up each memory bank */
#if defined (apPL093_BANK7_BOOT)
    for (I = 0; I < 7 ; I++)
#else
    for (I = 0; I < 8 ; I++)
#endif
    {
        /* Set up dummy memory bank data */
        sMemBankData.eBIWriteEn           = (apPL093_eBIWriteEn)        (I % 2);
        sMemBankData.eAddrValidWriteEn    = (apPL093_eAddrValidWriteEn) (I % 2);
        sMemBankData.eBurstLenWrite       = (apPL093_eBurstLenWrite)    (I % 2);
        sMemBankData.eSyncWriteDev        = (apPL093_eSyncWriteDev)     (I % 2);
        sMemBankData.eBMWrite             = (apPL093_eBMWrite)          (I % 2);
        sMemBankData.eWrapReadEn          = (apPL093_eWrapReadEn)       (I % 2);
        sMemBankData.eBIReadEn            = (apPL093_eBIReadEn)         (I % 2);
        sMemBankData.eAddrValidReadEn     = (apPL093_eAddrValidReadEn)  (I % 2);
        sMemBankData.eBurstLenRead        = (apPL093_eBurstLenRead)     (I % 2);
        sMemBankData.eSyncReadDev         = (apPL093_eSyncReadDev)      (I % 2);
        sMemBankData.eBMRead              = (apPL093_eBMRead)           (I % 2);
        sMemBankData.eSMBLSPol            = (apPL093_eSMBLSPol)         (I % 2);
        sMemBankData.eMemoryWidth         = (apPL093_eMW)               (I % 3);
        sMemBankData.eWriteProtect        = (apPL093_eWP)               (I % 2);
        sMemBankData.eWaitEn              = (apPL093_eWaitEn)           (I % 2);
        sMemBankData.eWaitPol             = (apPL093_eWaitPol)          (I % 2);
        sMemBankData.eRBLE                = (apPL093_eRBLE)             (I % 2);
        
        sMemBankData.ReadAccessCycles     = (UBYTE8)  (0x1F >> (I % 5));
        sMemBankData.WriteAccessCycles    = (UBYTE8) ((0x1F << (I % 5)) & 0x1F);
        sMemBankData.IdleTurnAroundCycles = (UBYTE8) ((0x0F << (I % 4)) & 0x0F);
        sMemBankData.OutputEnAssertDelay  = (UBYTE8)  (0x0F >> (I % 4));
        sMemBankData.WriteEnAssertDelay   = (UBYTE8) ((0x0F << (I % 4)) & 0x0F);
        sMemBankData.BurstReadDelay       = (UBYTE8)  (0x1F >> (I % 5));

        /* Initialise the memory bank */
        apPL093_MemBankConfigSet(oId, I, &sMemBankData);

        /* Read it back and compare */
        apPL093_MemBankConfigGet(oId, I, &sMemBankCheck);

        BankResult = (apTEST_eResult) (
            (sMemBankData.eBIWriteEn           == sMemBankCheck.eBIWriteEn)           &&
            (sMemBankData.eAddrValidWriteEn    == sMemBankCheck.eAddrValidWriteEn)    &&
            (sMemBankData.eBurstLenWrite       == sMemBankCheck.eBurstLenWrite)       &&
            (sMemBankData.eSyncWriteDev        == sMemBankCheck.eSyncWriteDev)        &&
            (sMemBankData.eBMWrite             == sMemBankCheck.eBMWrite)             &&
            (sMemBankData.eWrapReadEn          == sMemBankCheck.eWrapReadEn)          &&
            (sMemBankData.eBIReadEn            == sMemBankCheck.eBIReadEn)            &&
            (sMemBankData.eAddrValidReadEn     == sMemBankCheck.eAddrValidReadEn)     &&
            (sMemBankData.eBurstLenRead        == sMemBankCheck.eBurstLenRead)        &&
            (sMemBankData.eSyncReadDev         == sMemBankCheck.eSyncReadDev)         &&
            (sMemBankData.eBMRead              == sMemBankCheck.eBMRead)              &&
            (sMemBankData.eSMBLSPol            == sMemBankCheck.eSMBLSPol)            &&
            (sMemBankData.eMemoryWidth         == sMemBankCheck.eMemoryWidth)         &&
            (sMemBankData.eWriteProtect        == sMemBankCheck.eWriteProtect)        &&
            (sMemBankData.eWaitEn              == sMemBankCheck.eWaitEn)              &&
            (sMemBankData.eWaitPol             == sMemBankCheck.eWaitPol)             &&
            (sMemBankData.eRBLE                == sMemBankCheck.eRBLE)                &&

            (sMemBankData.ReadAccessCycles     == sMemBankCheck.ReadAccessCycles)     &&
            (sMemBankData.WriteAccessCycles    == sMemBankCheck.WriteAccessCycles)    &&
            (sMemBankData.IdleTurnAroundCycles == sMemBankCheck.IdleTurnAroundCycles) &&
            (sMemBankData.OutputEnAssertDelay  == sMemBankCheck.OutputEnAssertDelay)  &&
            (sMemBankData.WriteEnAssertDelay   == sMemBankCheck.WriteEnAssertDelay)   &&
            (sMemBankData.BurstReadDelay       == sMemBankCheck.BurstReadDelay) );

        /* Check initialised */
        BankResult = (apTEST_eResult) (BankResult & ((apPL093_InitGet( oId ) & (1 << I)) >> I));

        /* Check Write Protection functions */
        apPL093_WriteEnable( oId, I );

        apPL093_MemBankConfigGet( oId, I, &sMemBankCheck );

        BankResult = (apTEST_eResult) (BankResult & (sMemBankCheck.eWriteProtect == apPL093_WP_NO));        
       
        apPL093_WriteDisable( oId, I );

        apPL093_MemBankConfigGet( oId, I, &sMemBankCheck );
   
        BankResult = (apTEST_eResult) (BankResult & (sMemBankCheck.eWriteProtect == apPL093_WP_YES));        

        apTEST_Report( "Testing Memory Bank #", I, apTEST_FORMAT_LONG_DEC );
        apTEST_Remove_CR();
        apTEST_Report( BankResult?": Pass":": Fail", 0, apTEST_FORMAT_NO_NUMBER );
        apTEST_Remove_CR();

        apTEST_Report( "  Error Flag: ", 0, apTEST_FORMAT_NO_NUMBER );
        apTEST_Remove_CR();
        
        apPL093_ErrorGet( oId, I, &WaitToutErr );

        apTEST_Report( WaitToutErr?"WaitToutErr\n":"None\n", 0, apTEST_FORMAT_NO_NUMBER );
        
        TheResult = (apTEST_eResult) (TheResult & BankResult);
    }

    /* Read current status of external wait status */
    apTEST_Report( "Testing External Wait Status: SMWAIT ", 0, apTEST_FORMAT_NO_NUMBER );
    apTEST_Remove_CR();
    apTEST_Report( apPL093_StatusGet( oId )?"asserted\n":"deasserted\n", 0, apTEST_FORMAT_NO_NUMBER );
    
    /* Routines to invoke specific error conditions for code coverage */
    TheResult = (apTEST_eResult) (TheResult & PL093_Err_MemBankConfigSet( oId ));
    TheResult = (apTEST_eResult) (TheResult & PL093_Err_InvalidBankSet( oId ));

    return TheResult;    
}

PRIVATE apTEST_eResult PL093_Err_MemBankConfigSet( apOS_PL093_oId oId )
{
    apTEST_eResult eResult = apTEST_PASS;
    apPL093_sData sConfigData;
    
    /* Fetch current config settings */
    apPL093_MemBankConfigGet( oId, 0, &sConfigData );
    
    /* Attempt to set invalid Parameter for SMBIDCYRx register*/
    sConfigData.IdleTurnAroundCycles = (1 << bwPL093_IDCY);
    if ( apPL093_MemBankConfigSet( oId, 0, &sConfigData ) != apERR_PL093_INVALID_IDCY )
    {
        eResult = apTEST_FAIL;    
    }
    sConfigData.IdleTurnAroundCycles     = 0x0F;

    /* Attempt to set invalid Parameter for SMBWSTRDRx register*/
    sConfigData.ReadAccessCycles = (1 << bwPL093_WSTRD);
    if ( apPL093_MemBankConfigSet( oId, 0, &sConfigData ) != apERR_PL093_INVALID_WSTRD )
    {
        eResult = apTEST_FAIL;    
    }
    sConfigData.ReadAccessCycles     = 0x1F;

    /* Attempt to set invalid Parameter for SMBWSTWRRx register*/
    sConfigData.WriteAccessCycles = (1 << bwPL093_WSTWR);
    if ( apPL093_MemBankConfigSet( oId, 0, &sConfigData ) != apERR_PL093_INVALID_WSTWR )
    {
        eResult = apTEST_FAIL;    
    }
    sConfigData.WriteAccessCycles     = 0x1F;

    /* Attempt to set invalid Parameter for SMBWSTOENRx register*/
    sConfigData.OutputEnAssertDelay = (1 << bwPL093_WSTOEN);
    if ( apPL093_MemBankConfigSet( oId, 0, &sConfigData ) != apERR_PL093_INVALID_WSTOEN )
    {
        eResult = apTEST_FAIL;    
    }
    sConfigData.OutputEnAssertDelay     = 0x00;

    /* Attempt to set invalid Parameter for SMBWSTWENRx register*/
    sConfigData.WriteEnAssertDelay = (1 << bwPL093_WSTWEN);
    if ( apPL093_MemBankConfigSet( oId, 0, &sConfigData ) != apERR_PL093_INVALID_WSTWEN )
    {
        eResult = apTEST_FAIL;    
    }
    sConfigData.WriteEnAssertDelay     = 0x01;

    /* Attempt to set invalid Parameter for SMBWSTBRDRx register*/
    sConfigData.BurstReadDelay = (1 << bwPL093_WSTBRD);
    if ( apPL093_MemBankConfigSet( oId, 0, &sConfigData ) != apERR_PL093_INVALID_WSTBRD )
    {
        eResult = apTEST_FAIL;    
    }
    sConfigData.BurstReadDelay     = 0x1F;

    /* Attempt to set all Parameters to defaults*/
    if ( apPL093_MemBankConfigSet( oId, 0, &sConfigData ) != apERR_NONE )
    {
        eResult = apTEST_FAIL;    
    }

    apTEST_Print( eResult, "apPL093_MemBankConfigSet() error condition invalid parameters " );

    return eResult;
}

PRIVATE apTEST_eResult PL093_Err_InvalidBankSet( apOS_PL093_oId oId )
{
    apTEST_eResult eResult = apTEST_PASS;
    apPL093_sData sConfigData;
    BOOL WaitToutErr;
    
    /* Attempt to fetch current config settings with invalid bank*/
    if ( apPL093_MemBankConfigGet( oId, PL093_MB_NUMBER, &sConfigData ) != apERR_PL093_INVALID_BANK )
    {
        eResult = apTEST_FAIL;    
    }
    
    /* Attempt to set config settings with invalid bank*/
    if ( apPL093_MemBankConfigSet( oId, PL093_MB_NUMBER, &sConfigData ) != apERR_PL093_INVALID_BANK )
    {
        eResult = apTEST_FAIL;    
    }

    /* Attempt to get status of memory bank with invalid bank*/
    if ( apPL093_ErrorGet( oId, PL093_MB_NUMBER, &WaitToutErr ) != apERR_PL093_INVALID_BANK )
    {
        eResult = apTEST_FAIL;    
    }

    /* Attempt to set config settings with invalid bank*/
    if ( apPL093_WriteEnable( oId, PL093_MB_NUMBER ) != apERR_PL093_INVALID_BANK ) 
    {
        eResult = apTEST_FAIL;    
    }

    /* Attempt to set config settings with invalid bank*/
    if ( apPL093_WriteDisable( oId, PL093_MB_NUMBER ) != apERR_PL093_INVALID_BANK )
    {
        eResult = apTEST_FAIL;    
    }

    apTEST_Print( eResult, "Testing error condition invalid bank selected " );

    return eResult;
}