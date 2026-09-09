/*
 * Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 1999,2000,2001 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     uarttst.c,v
 * Revision: 1.73
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : uarttst.c.rca
 *  File Revision          : 1.2
 * 
 *  Release Information    : PrimeCell(TM)-PL011-REL2v0
 *  ----------------------------------------
 *
 * Initialise and test UART drivers
 */


#include "../apcommon/aptypes.h"
#include "../apos/apos.h"
#include "../aptest/aptest.h"
#include "apuart.h"

/* Used to define whether a UART to UART or UART to terminal test */
#define UART_UARTTEST
//#define UART_TERMINALTEST

/*define the frequency of the clock used to drive the UART (in Hz)*/
#if (apUART_VERSION == apUART_VERS_AP)
#define UART_TESTCLK 14745600
#else
#define UART_TESTCLK 12000000   //User defined clock for logic module
#endif

/*define the FIFO size for the UART*/
#define UART_FIFO_SIZE 0x10

#ifdef UART_TERMINALTEST
PRIVATE char *UART_pMessage1 = "UART to Terminal test, enter 10 chars, these will then be sent back   ";
#define UART_MSGSIZE1 70
#endif

#ifdef UART_UARTTEST
PRIVATE char *UART_pMessage2 = "This is the message to check the validity of, it is quite long to check it does fill up enough of the FIFO to do a proper test...";
#define UART_MSGSIZE2 129
#endif

/* Used by callback function to tell while loops the write has finished */
PRIVATE volatile UWORD32 UART_WriteFinished;
#ifdef UART_UARTTEST
/* Used by callback function to tell while loops the read has finished */
PRIVATE volatile UWORD32 UART_ReadFinished;
#endif /* #ifdef UART_UARTTEST */
/* Used to store the state of the Uart test - pass or fail */
PRIVATE apTEST_eResult UART_TestResult;

#define UART_RECVSIZE 60
#ifdef UART_UARTTEST
/*Defines large buffer to store test message in blocks of UART_RECVSIZE */
PRIVATE UBYTE8 UART_ReceiveBuffer[((UART_MSGSIZE2 / UART_RECVSIZE)+1) * UART_RECVSIZE];
/*Defines total read bytes*/
PRIVATE UWORD32 UART_TotalReceived;
PRIVATE UWORD32 UART_BufferCount;
#endif /* #ifdef UART_UARTTEST */

/*Used for modem flag testing*/
PRIVATE UWORD32 UART_ModemFlag;
/* Used in transmit and receive test in apUART_TestRun */
#ifdef UART_UARTTEST
PRIVATE UWORD32 UART_ErrorFrame;
PRIVATE UWORD32 UART_ErrorParity;
PRIVATE UWORD32 UART_ErrorBreak;
PRIVATE UWORD32 UART_ErrorOverrun;
#endif /* #ifdef UART_UARTTEST */

/* Function prototypes where required to avoid warnings */
PUBLIC apTEST_eResult apUART_SelfTest(UWORD32 Id,
                                      UWORD32 RegBase,
                                      UWORD32 NumSources, 
                                      CONST apOS_INT_oInterruptSource * CONST pInt);

PRIVATE void UART_APICallsTest(apOS_UART_oId oId);
PRIVATE apTEST_eResult UART_Test(apOS_UART_oId oId);
PRIVATE void UART_TestRun (apOS_UART_oId oId);

PRIVATE void UART_BaudRateTest(apOS_UART_oId oId);
PRIVATE void UART_DCDTest(apOS_UART_oId oId);
PRIVATE void UART_RTSTest(apOS_UART_oId oId);
PRIVATE void UART_DTRTest(apOS_UART_oId oId);
PRIVATE void UART_RIConfigTest(apOS_UART_oId oId);
PRIVATE void UART_DataConfigTest(apOS_UART_oId oId);
PRIVATE void UART_ErrorIntTest(apOS_UART_oId oId);
PRIVATE void UART_FIFOConfigTest(apOS_UART_oId oId);
#if (apUART_VERSION != apUART_VERS_AP)
PRIVATE void UART_IRConfigTest(apOS_UART_oId oId);
#endif
PRIVATE void UART_ModemIntTest(apOS_UART_oId oId);
PRIVATE void UART_PowerConfigTest(apOS_UART_oId oId);

#ifdef UART_UARTTEST
PRIVATE void UART_Finished(UWORD32 Id, apError Err);
#endif /* #ifdef UART_UARTTEST */
PRIVATE void UART_Written(UWORD32 Id, apError Err);
PRIVATE void UART_Listener(UWORD32 Id, apUART_eListenerMessage eMessage);

/*=========================================================================*/
/*
 *  Main PUBLIC API test Function
 */

PUBLIC apTEST_eResult apUART_SelfTest(UWORD32 Id,UWORD32 RegBase,UWORD32 NumSources,
                                   CONST apOS_INT_oInterruptSource * CONST pInt)
{
    apUART_sInitialData sInit;
    CONST apOS_UART_oId oId=(apOS_UART_oId) Id;

    UART_TestResult = apTEST_PASS;

    sInit.ClockFrequency = UART_TESTCLK;
    sInit.FIFOSize = UART_FIFO_SIZE;
    apUART_Initialize (oId, (apOS_System_eBaseAddress) RegBase, NumSources,  pInt, &sInit);

    UART_APICallsTest(oId);
    
    UART_Test(oId);
 
    return UART_TestResult;
}

/*=========================================================================*/
PRIVATE apTEST_eResult UART_Test(apOS_UART_oId oId )
{
    apUART_sConfigFIFOs sA;
    apUART_sConfigData  sB;
    apUART_sConfigPower sD;
    apUART_sConfigIR    sE;
    
    sA.eReceiveFIFOLevel    = apUART_HALF;
    sA.eTransmitFIFOLevel   = apUART_HALF;

    sB.eWordLen             = apUART_BITS_8;
    sB.eStopBits            = apUART_ONE_STOP_BIT;
    sB.eParitySelect        = apUART_NO_PARITY;
#if (apUART_VERSION == 11)
    sB.eHWFlowSelect        = apUART_HWFLOW_NONE;
    sB.eStickParity         = apUART_STICK_DISABLED;
#endif    

    sD.eLowPowerMode = apUART_MODE_NORMAL;
    sD.LowPowerBaud16 = 1843200;
    
    sE.eLoopBackEnable      = apUART_LOOPBACK_DISABLED;
    sE.eSIREnable           = apUART_SIR_DISABLED;

    apUART_Disable        (oId);
    apUART_TxDisable      (oId);    /* Included for test purposes only */
    apUART_RxDisable      (oId);    /* Included for test purposes only */
    apUART_FIFOConfigSet  (oId, &sA);
    apUART_DataConfigSet  (oId, &sB);
    apUART_BaudRateSet    (oId, 38400);
    apTEST_Report("Baud Rate = ",apUART_BaudRateGet(oId),apTEST_FORMAT_LONG_DEC) ;
    apUART_CallbackSet    (oId, &UART_Listener);
    apUART_PowerConfigSet (oId, &sD);
    apUART_IRConfigSet    (oId, &sE);
    apUART_Enable         (oId);
    apUART_TxEnable       (oId);    /* Included for test purposes only */
    apUART_RxEnable       (oId);    /* Included for test purposes only */

#ifdef UART_TERMINALTEST
    apTEST_TIMEOUT(&UART_TestRun, oId, 0, 15, "UART test timed out", apTEST_FAIL);
#else
    UART_TestRun(oId);
#endif
    return UART_TestResult;
}


/*=========================================================================*/
PRIVATE void UART_TestRun (apOS_UART_oId oId)
{
    UWORD32 Counter, ErrMsg;
#ifdef UART_UARTTEST
    apUART_sConfigIR sE;
#endif

#ifdef UART_TERMINALTEST
    UBYTE8 aUART_RecvString[10];

    /* Display fact on terminal that you will read 10 chars, read them then send them back */
    UART_WriteFinished = 0;
    Counter = 0;
    if (apUART_Transmit(oId, (void *) UART_pMessage1, UART_MSGSIZE1, &UART_Written) != apERR_NONE)
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - Transmit action failed");
        UART_TestResult = apTEST_FAIL;
    }
    else
    {
        /* Wait until data transmission has finished */
        while ((UART_WriteFinished == 0) && apTEST_TestInProgress);

        /* Loop construct used ilo read_n as terminal entry will be slow... */
        while ((Counter < 10) && apTEST_TestInProgress)
        {
            if ( (ErrMsg = apUART_Read(oId)) != apUART_FIFO_EMPTY )
            {
                    aUART_RecvString[Counter] = (UBYTE8) ErrMsg;
                    Counter++;
            }
        }
        UART_WriteFinished = 0;
        if (apTEST_TestInProgress)
        {
            if (apUART_Transmit(oId, (void *) &aUART_RecvString[0], 10, &UART_Written) != apERR_NONE)
            {
                apTEST_Print(apTEST_FAIL, "apUART_Transmit call failed");
                UART_TestResult = apTEST_FAIL;
            }
            else
            {
                while ((UART_WriteFinished == 0) && apTEST_TestInProgress);
                apTEST_Print(apTEST_PASS, "Successfully read 10 characters and transmitted them back to terminal");
            }
        }
    }
    apUART_RxIntDisable(oId);
#endif

#ifdef UART_UARTTEST
    /* Sets up listener, will then transmit UARTMSGSIZE2 chars and then checks they are received correctly */

    while (apUART_Read(oId) != apUART_FIFO_EMPTY)
    {
        /*Flush any existing data*/
    }
    
    if(apUART_TxFIFOEmpty(oId) == FALSE)
    {
        /* FIFO not empty, included for test purposes only */ 
    }
        
    apUART_Disable(oId);
    sE.eLoopBackEnable = apUART_LOOPBACK_ENABLED;
    sE.eSIREnable      = apUART_SIR_DISABLED;
    apUART_IRConfigSet(oId, &sE);
    apUART_Enable(oId);

    UART_TotalReceived = 0;
    UART_WriteFinished = 0;
    UART_ReadFinished = 0;
    UART_ErrorFrame = 0;    
    UART_ErrorParity = 0;
    UART_ErrorBreak = 0;
    UART_ErrorOverrun = 0;

    
    
    for (Counter = 0; Counter < UART_MSGSIZE2; Counter++)
    {
        UART_ReceiveBuffer[Counter] = ' ';
    }
    UART_WriteFinished = UART_ReadFinished = 0;
             
    apUART_Receive(oId, UART_ReceiveBuffer, UART_RECVSIZE, &UART_Finished);
    UART_BufferCount = 1;
    if (apUART_Transmit(oId, (void *) UART_pMessage2, UART_MSGSIZE2, &UART_Written) != apERR_NONE )
    {
        apTEST_Print(apTEST_FAIL, "apUART_Transmit call failed");
        UART_TestResult = apTEST_FAIL;
    }
    else
    {
        while (((UART_WriteFinished == 0) || (UART_ReadFinished == 0)));
        ErrMsg = 1;
         
        for (Counter = 0; Counter < UART_MSGSIZE2; Counter++)
        {
            ErrMsg &= (UART_ReceiveBuffer[Counter] == UART_pMessage2[Counter]);
        }
        
        if (ErrMsg == 1)
        {
            apTEST_Print(apTEST_PASS, "Data transmission and reception test completed successfully");
        }
        else
        {
            apTEST_Print(apTEST_FAIL, "Failed to correctly transmit string");            
            UART_TestResult = apTEST_FAIL;
        }            
    }

#if ((apUART_VERSION != apUART_VERS_AP) || (apUART_VERSION != 10))
    if (UART_ErrorFrame) apTEST_Report("Number of framing errors: ", UART_ErrorFrame, apTEST_FORMAT_LONG_DEC);
    if (UART_ErrorParity) apTEST_Report("Number of parity errors: ", UART_ErrorParity, apTEST_FORMAT_LONG_DEC);
    if (UART_ErrorBreak) apTEST_Report("Number of break errors: ", UART_ErrorBreak, apTEST_FORMAT_LONG_DEC);
    if (UART_ErrorOverrun) apTEST_Report("Number of overrun errors: ", UART_ErrorOverrun, apTEST_FORMAT_LONG_DEC);
#endif /* ((apUART_VERSION != apUART_VERS_AP) || (apUART_VERSION != 10)) */

#endif /* UART_UARTTEST */

    apTEST_TestInProgress = FALSE;
}



/*=========================================================================*/
PRIVATE void UART_APICallsTest(apOS_UART_oId oId)
{
    UART_BaudRateTest(oId);     /* Test apUART_BaudRateGet & apUART_BaudRateSet */
    UART_DCDTest(oId);          /* Test apUART_DCDConfigGet & apUART_DCDConfigSet */
    UART_RTSTest(oId);          /* Test apUART_RTSConfigGet & apUART_RTSConfigSet */
    UART_DTRTest(oId);          /* Test apUART_DTRConfigGet & apUART_DTRConfigSet */
    UART_RIConfigTest(oId);     /* Tests apUART_RIConfigSet & apUART_RIConfigGet */ 
    UART_DataConfigTest(oId);   /* Test apUART_DataConfigSet & apUART_DataConfigGet (8 - 2 - Stick Disabled - Full HW flow) */

    UART_ErrorIntTest(oId);     /* Test apUART_ErrorIntSet & apUART_ErrorIntGet */

    UART_FIFOConfigTest(oId);   /* Test apUART_FifoConfigSet & apUART_FifoConfigGet */

    UART_ModemIntTest(oId);     /* Test apUART_ModemIntSet & apUART_ModemIntGet 
                                   (PL010 Test DCD for unsupported, enable modem ints, PL011 Test DCD & DSR, Disable All, Enable All) */

#if (apUART_VERSION != apUART_VERS_AP)
    UART_IRConfigTest(oId);     /* Test apUART_IRConfigSet & apUART_IRConfigGet (Loopback & SIR enabled,  Loopback & SIR disabled) */
#endif
    UART_PowerConfigTest(oId);  /* Test apUART_PowerConfigSet & apUART_PowerConfigGet */

#if (apUART_VERSION == 11)
    apUART_DMAModeSet(oId, apUART_DMA_RX_ON);
    apUART_DMAModeSet(oId, apUART_DMA_TX_ON);
    apTEST_Report("DMA register address ", apUART_DMAAddressGet(oId), apTEST_FORMAT_LONG_HEX);
    apUART_DMAModeSet(oId, apUART_DMA_RX_OFF);
    apUART_DMAModeSet(oId, apUART_DMA_TX_OFF);
    apTEST_Print(apTEST_PASS, "DMA configuration test completed successfully");

#else
    if(apUART_DMAModeSet(oId, apUART_DMA_RX_ON) != apERR_UNSUPPORTED)
    {
        /* only supported on PL011 */
    }
#endif
}


/*=========================================================================*/
/*
 * Start of test functions to test API calls
 */

PRIVATE void UART_BaudRateTest(apOS_UART_oId oId)
{
    UWORD32 BaudRate;
    
    apUART_BaudRateSet(oId, 2400);
    BaudRate = apUART_BaudRateGet(oId);
    apTEST_Report("Baud Rate = ",BaudRate,apTEST_FORMAT_LONG_DEC) ;

    if ((BaudRate < 2380) || (BaudRate > 2420))
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - Incorrect baud rate returned");
        UART_TestResult = apTEST_FAIL;        
    }

    apUART_BaudRateSet(oId, 57600);
    BaudRate = apUART_BaudRateGet(oId);   
    apTEST_Report("Baud Rate = ",BaudRate,apTEST_FORMAT_LONG_DEC) ;

    if ((BaudRate < 57100) || (BaudRate > 58100))
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - Incorrect baud rate returned");
        UART_TestResult = apTEST_FAIL;
    }

    apUART_BaudRateSet(oId, 115200);
    BaudRate = apUART_BaudRateGet(oId);
    apTEST_Report("Baud Rate = ",BaudRate,apTEST_FORMAT_LONG_DEC) ;

    if ((BaudRate < 114200) || (BaudRate > 116200))
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - Incorrect baud rate returned");
        UART_TestResult = apTEST_FAIL;
    }

    if(apUART_BaudRateSet(oId, 10) != apUART_INVALID_BAUD_RATE)
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - Did not detect invalid baud rate ");
    }
    else
    {
        apTEST_Print(apTEST_PASS, "Baud rate tests completed successfully");
    }
}


/*=========================================================================*/
PRIVATE void UART_DCDTest(apOS_UART_oId oId)
{
    apUART_eDCDEnable eDCDflag = apUART_DCD_ENABLED;
    apUART_eDCDEnable *peDCDflag = &eDCDflag;

#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
    
    if (apUART_DCDConfigSet(oId, eDCDflag) != apERR_UNSUPPORTED)
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - apUART_DCDConfigSet Incorrectly detected that DCD is supported");    
        UART_TestResult = apTEST_FAIL;
    }
    else
    {
        if (apUART_DCDConfigGet(oId, peDCDflag) != apERR_UNSUPPORTED)
        {
            apTEST_Print(apTEST_FAIL, "FAILURE - apUART_DCDConfigGet Incorrectly detected that DCD is supported");    
            UART_TestResult = apTEST_FAIL;
        }
        else
        {
            apTEST_Print(apTEST_PASS, "DCD configuration tests completed successfully - informed that DCD is not supported");
        }
    }
#else
    if (apUART_DCDConfigSet(oId, eDCDflag) == apERR_UNSUPPORTED)
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - apUART_DCDConfigSet Incorrectly detected that DCD is not supported");
        UART_TestResult = apTEST_FAIL;
    }
    else
    {
        if (apUART_DCDConfigGet(oId, peDCDflag) == apERR_UNSUPPORTED)
        {
            apTEST_Print(apTEST_FAIL, "FAILURE - apUART_DCDConfigGet Incorrectly detected that DCD is not supported");
            UART_TestResult = apTEST_FAIL;
        }
        else
        {
            if (*peDCDflag != apUART_DCD_ENABLED)
            {
                apTEST_Print(apTEST_FAIL, "FAILURE - apUART_DCDConfigGet did not retrieve correct DCD value");
                UART_TestResult = apTEST_FAIL;
            }
            else
            {
                apUART_DCDConfigSet(oId, apUART_DCD_DISABLED);
                apTEST_Print(apTEST_PASS, "DCD configuration tests completed successfully");
            }
        }
    }    
#endif
}

/*=========================================================================*/
PRIVATE void UART_RTSTest(apOS_UART_oId oId)
{
    apUART_eRTSEnable eRTSflag = apUART_RTS_ENABLED;
    apUART_eRTSEnable *peRTSflag = &eRTSflag;

#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
    
    if (apUART_RTSConfigSet(oId, eRTSflag) != apERR_UNSUPPORTED)
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - apUART_RTSConfigSet Incorrectly detected that RTS is supported");    
        UART_TestResult = apTEST_FAIL;
    }
    else
    {
        if (apUART_RTSConfigGet(oId, peRTSflag) != apERR_UNSUPPORTED)
        {
            apTEST_Print(apTEST_FAIL, "FAILURE - apUART_RTSConfigGet Incorrectly detected that RTS is supported");    
            UART_TestResult = apTEST_FAIL;
        }
        else
        {
            apTEST_Print(apTEST_PASS, "RTS configuration tests completed successfully - informed that RTS is not supported");
        }
    }
#else
    if (apUART_RTSConfigSet(oId, eRTSflag) == apERR_UNSUPPORTED)
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - apUART_RTSConfigSet Incorrectly detected that RTS is not supported");
        UART_TestResult = apTEST_FAIL;
    }
    else
    {
        if (apUART_RTSConfigGet(oId, peRTSflag) == apERR_UNSUPPORTED)
        {
            apTEST_Print(apTEST_FAIL, "FAILURE - apUART_RTSConfigGet Incorrectly detected that RTS is not supported");
            UART_TestResult = apTEST_FAIL;
        }
        else
        {
            if (*peRTSflag != apUART_RTS_ENABLED)
            {
                apTEST_Print(apTEST_FAIL, "FAILURE - apUART_RTSConfigGet did not retrieve correct RTS value");
                UART_TestResult = apTEST_FAIL;
            }
            else
            {
                apUART_RTSConfigSet(oId, apUART_RTS_DISABLED);
                apTEST_Print(apTEST_PASS, "RTS configuration tests completed successfully");
            }
        }
    }    
#endif
}

/*=========================================================================*/
PRIVATE void UART_DTRTest(apOS_UART_oId oId)
{
    apUART_eDTREnable eDTRflag = apUART_DTR_ENABLED;
    apUART_eDTREnable *peDTRflag = &eDTRflag;

#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
    
    if (apUART_DTRConfigSet(oId, eDTRflag) != apERR_UNSUPPORTED)
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - apUART_DTRConfigSet Incorrectly detected that DTR is supported");    
        UART_TestResult = apTEST_FAIL;
    }
    else
    {
        if (apUART_DTRConfigGet(oId, peDTRflag) != apERR_UNSUPPORTED)
        {
            apTEST_Print(apTEST_FAIL, "FAILURE - apUART_DTRConfigGet Incorrectly detected that DTR is supported");    
            UART_TestResult = apTEST_FAIL;
        }
        else
        {
            apTEST_Print(apTEST_PASS, "DTR configuration tests completed successfully - informed that DTR is not supported");
        }
    }
#else
    if (apUART_DTRConfigSet(oId, eDTRflag) == apERR_UNSUPPORTED)
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - apUART_DTRConfigSet Incorrectly detected that DTR is not supported");
        UART_TestResult = apTEST_FAIL;
    }
    else
    {
        if (apUART_DTRConfigGet(oId, peDTRflag) == apERR_UNSUPPORTED)
        {
            apTEST_Print(apTEST_FAIL, "FAILURE - apUART_DTRConfigGet Incorrectly detected that DTR is not supported");
            UART_TestResult = apTEST_FAIL;
        }
        else
        {
            if (*peDTRflag != apUART_DTR_ENABLED)
            {
                apTEST_Print(apTEST_FAIL, "FAILURE - apUART_DTRConfigGet did not retrieve correct DTR value");
                UART_TestResult = apTEST_FAIL;
            }
            else
            {
                apUART_DTRConfigSet(oId, apUART_DTR_DISABLED);
                apTEST_Print(apTEST_PASS, "DTR configuration tests completed successfully");
            }
        }
    }    
#endif
}

/*=========================================================================*/
PRIVATE void UART_RIConfigTest(apOS_UART_oId oId)
{
    apUART_eRIEnable eRIflag = apUART_RI_ENABLED;
    apUART_eRIEnable *peRIflag = &eRIflag;
    
#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))

    if (apUART_RIConfigSet(oId, eRIflag) != apERR_UNSUPPORTED)
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - apUART_RIConfigSet Incorrectly detected that RI is supported");    
        UART_TestResult = apTEST_FAIL;
    }
    else
    {
        if (apUART_RIConfigGet(oId, peRIflag) != apERR_UNSUPPORTED)
        {
            apTEST_Print(apTEST_FAIL, "FAILURE - apUART_RIConfigGet Incorrectly detected that RI is supported");    
            UART_TestResult = apTEST_FAIL;
        }
        else
        {
            apTEST_Print(apTEST_PASS, "RI configuration tests completed successfully - informed that RI is not supported");
        }
    }
#else
    if (apUART_RIConfigSet(oId, eRIflag) == apERR_UNSUPPORTED)
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - apUART_RIConfigSet Incorrectly detected that RI is not supported");
        UART_TestResult = apTEST_FAIL;
    }
    else
    {
        if (apUART_RIConfigGet(oId, peRIflag) == apERR_UNSUPPORTED)
        {
            apTEST_Print(apTEST_FAIL, "FAILURE - apUART_RIConfigGet Incorrectly detected that RI is not supported");
            UART_TestResult = apTEST_FAIL;
        }
        else
        {
            if (*peRIflag != apUART_RI_ENABLED)
            {
                apTEST_Print(apTEST_FAIL, "FAILURE - apUART_RIConfigGet did not retrieve correct RI value");
                UART_TestResult = apTEST_FAIL;
            }
            else
            {
                apUART_RIConfigSet(oId, apUART_RI_DISABLED);
                apTEST_Print(apTEST_PASS, "RI configuration tests completed successfully");
            }
        }
    }    
#endif
}

/*=========================================================================*/
PRIVATE void UART_DataConfigTest(apOS_UART_oId oId)
{
    apUART_sConfigData sCon, sGetCon;
    apUART_sConfigData *pGetCon = &sGetCon;    
    
    sCon.eParitySelect = apUART_EVEN_PARITY;
    sCon.eWordLen = apUART_BITS_8;
    sCon.eStopBits = apUART_TWO_STOP_BITS;
#if (apUART_VERSION == 11)
    sCon.eHWFlowSelect = apUART_HWFLOW_ALL;
    sCon.eStickParity = apUART_STICK_DISABLED;
#endif
    apUART_DataConfigSet(oId, &sCon);  
    apUART_DataConfigGet(oId, pGetCon);
    if ( (pGetCon->eWordLen == apUART_BITS_8) && (pGetCon->eStopBits == apUART_TWO_STOP_BITS) && (pGetCon->eParitySelect == apUART_EVEN_PARITY) )
    {
        apTEST_Print(apTEST_PASS, "Data configuration tests completed successfully");
#if (apUART_VERSION == 11)
        if ( (pGetCon->eHWFlowSelect != apUART_HWFLOW_ALL) || (pGetCon->eStickParity != apUART_STICK_DISABLED) )
        {
            apTEST_Print(apTEST_FAIL, "FAILURE - hardware flow control and stick parity data configuration settings returned incorrect values");        
            UART_TestResult = apTEST_FAIL;
        }
#endif
    }
    else
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - Data Configuration tests did not complete successfully");
        UART_TestResult = apTEST_FAIL;
    }
}

/*=========================================================================*/
PRIVATE void UART_ErrorIntTest(apOS_UART_oId oId)
{  
    UWORD32 Errormask, GetErrormask;
    
    Errormask = apUART_ERROR_INT_BREAK;
    apUART_ErrorIntSet(oId, Errormask);
    apUART_ErrorIntGet(oId, &GetErrormask);
#if (apUART_VERSION == 11)
    if (GetErrormask != apUART_ERROR_INT_BREAK)
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - apUART_ErrorIntGet didn't return the correct value (BREAK enabled)");
        UART_TestResult = apTEST_FAIL;
    }
    else
    {
        Errormask = apUART_ERROR_INT_OVERRUN | apUART_ERROR_INT_FRAMING | apUART_ERROR_INT_BREAK | apUART_ERROR_INT_PARITY;
        apUART_ErrorIntSet(oId, Errormask);
        apUART_ErrorIntGet(oId, &GetErrormask);
        if ((GetErrormask & apUART_ERROR_INT_BREAK) && (GetErrormask & apUART_ERROR_INT_FRAMING) && (GetErrormask & apUART_ERROR_INT_PARITY) && (GetErrormask & apUART_ERROR_INT_OVERRUN))
        {
            apTEST_Print(apTEST_PASS, "Completed error interrupt configuration tests successfully");
        }
        else
        {
            apTEST_Print(apTEST_FAIL, "FAILURE - apUART_ErrorIntGet didn't return the correct value");
            UART_TestResult = apTEST_FAIL;
        }   
    }
#endif 
}


/*=========================================================================*/
PRIVATE void UART_FIFOConfigTest(apOS_UART_oId oId)
{

    apUART_sConfigFIFOs sCon, sConOut;
    apUART_sConfigFIFOs *pConOut = &sConOut;
 #if (apUART_VERSION == 11)
    UWORD32 Pass = 1;
   
    sCon.eReceiveFIFOLevel = apUART_ONEEIGHTH;
    sCon.eTransmitFIFOLevel = apUART_SEVENEIGHTHS;
    apUART_FIFOConfigSet(oId, &sCon);
    apUART_FIFOConfigGet(oId, pConOut);
    if ((pConOut->eReceiveFIFOLevel != apUART_ONEEIGHTH) || (pConOut->eTransmitFIFOLevel != apUART_SEVENEIGHTHS)) Pass = 0;

    sCon.eReceiveFIFOLevel = apUART_ONEQUARTER;
    sCon.eTransmitFIFOLevel = apUART_THREEQUARTERS;
    apUART_FIFOConfigSet(oId, &sCon);
    apUART_FIFOConfigGet(oId, pConOut);
    if ((pConOut->eReceiveFIFOLevel != apUART_ONEQUARTER) || (pConOut->eTransmitFIFOLevel != apUART_THREEQUARTERS)) Pass = 0;
    
    
    sCon.eReceiveFIFOLevel = apUART_HALF;
    sCon.eTransmitFIFOLevel = apUART_HALF;
    apUART_FIFOConfigSet(oId, &sCon);
    apUART_FIFOConfigGet(oId, pConOut);
    if ((pConOut->eReceiveFIFOLevel != apUART_HALF) || (pConOut->eTransmitFIFOLevel != apUART_HALF)) Pass = 0;

    sCon.eReceiveFIFOLevel = apUART_THREEQUARTERS;
    sCon.eTransmitFIFOLevel = apUART_ONEQUARTER;
    apUART_FIFOConfigSet(oId, &sCon);
    apUART_FIFOConfigGet(oId, pConOut);
    if ((pConOut->eReceiveFIFOLevel != apUART_THREEQUARTERS) || (pConOut->eTransmitFIFOLevel != apUART_ONEQUARTER)) Pass = 0;

    sCon.eReceiveFIFOLevel = apUART_SEVENEIGHTHS;
    sCon.eTransmitFIFOLevel = apUART_ONEEIGHTH;
    apUART_FIFOConfigSet(oId, &sCon);
    apUART_FIFOConfigGet(oId, pConOut);
    if ((pConOut->eReceiveFIFOLevel != apUART_SEVENEIGHTHS) || (pConOut->eTransmitFIFOLevel != apUART_ONEEIGHTH)) Pass = 0;
            
    if (Pass == 1)
    {
        apTEST_Print(apTEST_PASS, "FIFO Configuration tests completed successfully");
    }
    else
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - FIFO configuration tests did not complete successfully");
        UART_TestResult = apTEST_FAIL;
    }
#else
    sCon.eReceiveFIFOLevel = apUART_HALF;
    sCon.eTransmitFIFOLevel = apUART_HALF;
    
    if(apUART_FIFOConfigSet(oId, &sCon) != apERR_UNSUPPORTED)
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - FIFO configuration tests did not return unsupported");
    }
    else
    {
        if(apUART_FIFOConfigGet(oId, pConOut) != apERR_UNSUPPORTED)
        {
            apTEST_Print(apTEST_FAIL, "FAILURE - FIFO configuration tests did not return unsupported");
        }
        else
        {
            apTEST_Print(apTEST_PASS, "FIFO Configuration tests completed successfully");
        }
    }
#endif     
}

/*=========================================================================*/
#if (apUART_VERSION != apUART_VERS_AP)
PRIVATE void UART_IRConfigTest(apOS_UART_oId oId)
{
    apUART_sConfigIR sCon, sGetCon;
    apUART_sConfigIR *pGetCon = &sGetCon;
    UWORD32 Pass = 1;
    
    apUART_Disable(oId);
    sCon.eLoopBackEnable = apUART_LOOPBACK_ENABLED;
    sCon.eSIREnable = apUART_SIR_ENABLED;
    apUART_IRConfigSet(oId, &sCon);
    apUART_Enable(oId);

    apUART_IRConfigGet(oId, pGetCon);
    if ((pGetCon->eLoopBackEnable != apUART_LOOPBACK_ENABLED) || (pGetCon->eSIREnable != apUART_SIR_ENABLED)) Pass = 0;

    apUART_Disable(oId);
    sCon.eLoopBackEnable = apUART_LOOPBACK_DISABLED;
    sCon.eSIREnable = apUART_SIR_DISABLED;
    apUART_IRConfigSet(oId, &sCon);
    apUART_Enable(oId);

    apUART_IRConfigGet(oId, pGetCon);

    if ((pGetCon->eLoopBackEnable != apUART_LOOPBACK_DISABLED) || (pGetCon->eSIREnable != apUART_SIR_DISABLED)) Pass = 0;

    if (Pass == 1)
    {
        apTEST_Print(apTEST_PASS, "IR Configuration tests completed successfully");
    }
    else
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - IR tests did not complete successfully");
        UART_TestResult = apTEST_FAIL;
    }
}
#endif /* #if (apUART_VERSION != apUART_VERS_AP) */


/*=========================================================================*/
PRIVATE void UART_ModemIntTest(apOS_UART_oId oId)
{
UWORD32 Modemmask;
UWORD32 GetModemmask = 0xFFFFFFFF;
UWORD32 *pGetModemmask = &GetModemmask;

#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
    Modemmask = apUART_MODEM_INT_DCD;
    if (apUART_ModemIntSet(oId, Modemmask) == apERR_UNSUPPORTED)
    {
        Modemmask = apUART_MODEM_INT_ENABLE;
        if (apUART_ModemIntSet(oId, Modemmask) == apERR_NONE)
        {
            apUART_ModemIntGet(oId, pGetModemmask);
            if (*pGetModemmask == apUART_MODEM_INT_ENABLE)
            {
                Modemmask = apUART_MODEM_INT_DISABLE;
                if (apUART_ModemIntSet(oId, Modemmask) == apERR_NONE)
                {
                    apUART_ModemIntGet(oId, pGetModemmask);
                    if (*pGetModemmask == apUART_MODEM_INT_DISABLE)
                    {
                        apTEST_Print(apTEST_PASS, "Modem interrupt configuration test completed successfully");
                    }
                    else
                    {
                        apTEST_Print(apTEST_FAIL, "FAILURE - Modem interrupt settings test");
                        UART_TestResult = apTEST_FAIL;
                    }
                }
                else
                {
                    apTEST_Print(apTEST_FAIL, "FAILURE - Modem interrupt settings test");
                    UART_TestResult = apTEST_FAIL;
                }
            }
            else
            {
                apTEST_Print(apTEST_FAIL, "FAILURE - Modem interrupt settings test");
                UART_TestResult = apTEST_FAIL;
            }
        }
        else
        {
            apTEST_Print(apTEST_FAIL, "Unsuccessfully tested that Modem interrupts are supported");    
            UART_TestResult = apTEST_FAIL;
        }
    }
    else
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - Modem interrupt tests incorrectly identified that DCD is supported");
        UART_TestResult = apTEST_FAIL;
    }
#else
    Modemmask = apUART_MODEM_INT_DCD | apUART_MODEM_INT_DSR;
    if (apUART_ModemIntSet(oId, Modemmask) == apERR_NONE)
    {
        apUART_ModemIntGet(oId, pGetModemmask);
        if ((*pGetModemmask & apUART_MODEM_INT_DCD) && (*pGetModemmask & apUART_MODEM_INT_DSR))
        {
            apTEST_Print(apTEST_PASS, "Modem interrupt configuration test completed successfully");
            apUART_ModemIntSet(oId, apUART_MODEM_INT_DISABLE);
            apUART_ModemIntSet(oId, apUART_MODEM_INT_ENABLE);           
        }
        else
        {
            apTEST_Print(apTEST_FAIL, "FAILURE - Modem interrupt tests failed to retrieve set state");
            UART_TestResult = apTEST_FAIL;
        }        
    }
    else
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - Modem interrupt tests failed to correctly identify support for DCD and DSR");
        UART_TestResult = apTEST_FAIL;
    }
#endif

}


/*=========================================================================*/
PRIVATE void UART_PowerConfigTest(apOS_UART_oId oId)
{
apUART_sConfigPower sCon, sGetCon;
apUART_sConfigPower *pGetCon = &sGetCon;

    /* Sets power configuration as Low Power and the LPB16 as 1843200 */
    sCon.eLowPowerMode = apUART_MODE_LOW_POWER;
    sCon.LowPowerBaud16 = 1843200;
    apUART_PowerConfigSet(oId, &sCon);
    
    apUART_PowerConfigGet(oId, pGetCon);
    
#if (apUART_VERSION != apUART_VERS_AP)
    if (pGetCon->eLowPowerMode == apUART_MODE_LOW_POWER)
    {
        apTEST_Report("Low power baud = ",(UWORD32) pGetCon->LowPowerBaud16,apTEST_FORMAT_LONG_DEC) ;
        if ((((UWORD32) pGetCon->LowPowerBaud16) > 1420000) &&
                (((UWORD32) pGetCon->LowPowerBaud16) < 2120000))
        {
            apTEST_Print(apTEST_PASS, "Power configuration tests completed successfully");
        }
        else
        {
            apTEST_Print(apTEST_FAIL, "FAILURE - Power configuration settings tests failed");
            UART_TestResult = apTEST_FAIL;
        }
    }
    else
    {
        apTEST_Print(apTEST_FAIL, "FAILURE - Failed to read back power mode correctly");
    }
#endif
}


/* End of API tests */


#ifdef UART_UARTTEST
/*=========================================================================*/
PRIVATE void UART_Finished(UWORD32 Id, apError Err)
{
    IGNORE (Id);

    switch (Err)
    {
        case apERR_NONE:
            UART_TotalReceived += ( UART_RECVSIZE - apUART_ReceiveStatusGet((apOS_UART_oId) Id) );
            if (UART_TotalReceived < UART_MSGSIZE2)
            {
                apUART_Receive((apOS_UART_oId) Id, UART_ReceiveBuffer +(UART_BufferCount*UART_RECVSIZE), UART_RECVSIZE, &UART_Finished);
                UART_BufferCount++;
            }
            else
            {
                UART_ReadFinished = 1;
            }
            break;
        case apUART_BUFFER_FULL:
            UART_TotalReceived += ( UART_RECVSIZE - apUART_ReceiveStatusGet((apOS_UART_oId) Id) );
            apUART_Receive((apOS_UART_oId) Id, UART_ReceiveBuffer +(UART_BufferCount*UART_RECVSIZE), UART_RECVSIZE, &UART_Finished);
            UART_BufferCount++;
            break;
        case apUART_ERROR_FRAME:
            UART_ErrorFrame++;
            break;
        case apUART_ERROR_PARITY:   
            UART_ErrorParity++;
            break;
        case apUART_ERROR_BREAK:   
            UART_ErrorBreak++;
            break;
        case apUART_ERROR_OVERRUN:
            UART_ErrorOverrun++;
            break;
        default:
            break;
    }
}
#endif /* #ifdef UART_UARTTEST */

/*=========================================================================*/
PRIVATE void UART_Written(UWORD32 Id, apError Err)
{
    IGNORE(Id);
    IGNORE(Err);
    UART_WriteFinished = 1;
}


/*=========================================================================*/
PRIVATE void UART_Listener(UWORD32 Id, apUART_eListenerMessage eMessage)
{

    if ((eMessage == apUART_DEVICE_CHANGED_RI) | (eMessage == apUART_DEVICE_CHANGED_CTS) | (eMessage == apUART_DEVICE_CHANGED_DCD) | (eMessage == apUART_DEVICE_CHANGED_DSR) | (eMessage == apUART_DEVICE_CHANGED))
    {
        UART_ModemFlag = apUART_ModemStatusGet((apOS_UART_oId) Id);
    }
    else
    {
        /* Data has arrived */
        /* Not using Listener in this test suite to receive any data so ignore */
        apUART_Continue((apOS_UART_oId) Id);
    }
}

