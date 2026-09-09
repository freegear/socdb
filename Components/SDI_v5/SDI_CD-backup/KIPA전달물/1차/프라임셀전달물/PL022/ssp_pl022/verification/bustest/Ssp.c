/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : Ssp.c.rca
--  File Revision          : 1.4
--  
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--   Purpose : This C code file is used to generate BusTalk vectors.
--             BusTalk vectors are applied to the AMBA APB bus.                 
--                                                                   
--   Files required for compilation:                                
--     makefile, busheader.h, busmacros.h, busmacros.c,            
--     config.h, addargs_script,                                  
--     Ssp.h, Ssp.c and:                          
--                                                              
--     Ssp_RegTests.c
--     Ssp_PCLKOn.c
--     Ssp_RefClkOn.c
--     Ssp_Idle.c
--     Ssp_ProgramReg.c
--     Ssp_CalculateTimeout.c
--     Ssp_TestTI.c
--     Ssp_Testspi00.c
--     Ssp_Testspi01.c
--     Ssp_Testspi10.c
--     Ssp_Testspi11.c
--     Ssp_TestMW.c
--     Ssp_FIFO_ptr_test.c 
--     Ssp_TxFIFO_critical_test.c
--     Ssp_RxFIFO_critical_test.c
--     Ssp_Ti_FrameFormat_Test.c
--     Ssp_Spi00_FrameFormat_Test.c
--     Ssp_Spi01_FrameFormat_Test.c
--     Ssp_Spi10_FrameFormat_Test.c
--     Ssp_Spi11_FrameFormat_Test.c
--     Ssp_Mw_FrameFormat_Test.c
--     Ssp_Data_Test.c
--     Ssp_Data_Check_Test.c
--     Ssp_NonBacktoBack_Test.c
--     Ssp_NonBacktoBack_Check_Test.c
--     Ssp_Ti_BacktoBack_Test.c
--     Ssp_Ti_Continuous.c
--     Ssp_Spi00_BacktoBack_Test.c
--     Ssp_Spi00_Continuous.c
--     Ssp_Spi01_BacktoBack_Test.c
--     Ssp_Spi01_Continuous.c
--     Ssp_Spi10_BacktoBack_Test.c
--     Ssp_Spi10_Continuous.c
--     Ssp_Spi11_BacktoBack_Test.c
--     Ssp_Spi11_Continuous.c
--     Ssp_Mw_BacktoBack_Test.c
--     Ssp_Mw_Continuous.c
--     Ssp_Spi11_ris_Interrupt_Test.c
--     Ssp_Spi00_rtis_Interrupt_Test.c
--     Ssp_Spi01_rtis_Interrupt_Test.c
--     Ssp_Spi10_rtis_Interrupt_Test.c
--     Ssp_Spi11_rtis_Interrupt_Test.c
--     Ssp_Ti_rtis_Interrupt_Test.c
--     Ssp_Mw_rtis_Interrupt_Test.c
--     Ssp_Spi00_tis_Interrupt_Test.c
--     Ssp_Ti_ror_Interrupt_Test.c
--     Ssp_RIS_Test.c
--     Ssp_TIS_Test.c
--     Ssp_ROR_Test.c
--     Ssp_SPI00_RTIS_Test.c
--     Ssp_SPI01_RTIS_Test.c
--     Ssp_SPI10_RTIS_Test.c
--     Ssp_SPI11_RTIS_Test.c
--     Ssp_TI_RTIS_Test.c
--     Ssp_MW_RTIS_Test.c
--     Ssp_SspLoopBack_Test.c
--     Ssp_SspdisableTest.c
--     Ssp_Ti_sspdisableTest.c 
--     Ssp_Mw_sspdisableTest.c 
--     Ssp_Spi00_sspdisableTest.c 
--     Ssp_Spi01_sspdisableTest.c 
--     Ssp_Spi10_sspdisableTest.c
--     Ssp_Spi11_sspdisableTest.c
--     Ssp_Ti_SOD_SLAVE_Cont_Test.c
--     Ssp_ExtSFRM_S.c
--     Ssp_Ti_FRCTest_S.c
--     Ssp_Mw_FRCTest_S.c
--     Ssp_Sph_FRMDA_Test.c
--     Ssp_Ti_FrameFormat_Test_S.c
--     Ssp_Mw_FrameFormat_Test_S.c
--     Ssp_Spi00_FrameFormat_Test_S.c 
--     Ssp_Spi01_FrameFormat_Test_S.c 
--     Ssp_Spi10_FrameFormat_Test_S.c
--     Ssp_Spi11_FrameFormat_Test_S.c
--     Ssp_Spi11_ris_Interrupt_Test_S.c
--     Ssp_Spi00_tis_Interrupt_Test_S.c
--     Ssp_Spi00_rtis_Interrupt_Test_S.c
--     Ssp_Spi01_rtis_Interrupt_Test_S.c
--     Ssp_Spi10_rtis_Interrupt_Test_S.c
--     Ssp_Spi11_rtis_Interrupt_Test_S.c
--     Ssp_Ti_ror_Interrupt_Test_S.c
--     Ssp_FIFO_ptr_test_S.c
--     Ssp_SspdisableTest_S.c
--     Ssp_Ti_sspdisableTest_S.c 
--     Ssp_Mw_sspdisableTest_S.c 
--     Ssp_Spi00_sspdisableTest_S.c
--     Ssp_Spi01_sspdisableTest_S.c
--     Ssp_Spi10_sspdisableTest_S.c
--     Ssp_Spi11_sspdisableTest_S.c
--     Ssp_Ti_MSTests.c
--     Ssp_Mw_MSTests.c
--     Ssp_Spi00_MSTests.c
--     Ssp_Spi01_MSTests.c
--     Ssp_Spi10_MSTests.c
--     Ssp_Spi11_MSTests.c
--     Ssp_Ti_MSSODTests.c
--     Ssp_Mw_MSSODTests.c
--     Ssp_Spi00_MSSODTests.c
--     Ssp_Spi01_MSSODTests.c
--     Ssp_Spi10_MSSODTests.c
--     Ssp_Spi11_MSSODTests.c
--     Ssp_Ti_DeAssert_SFRM_Test.c
--     Ssp_Spi00_DeAssert_SFRM_Test.c
--     Ssp_Spi01_DeAssert_SFRM_Test.c
--     Ssp_Spi10_DeAssert_SFRM_Test.c
--     Ssp_Spi11_DeAssert_SFRM_Test.c
--     Ssp_Mw_DeAssert_SFRM_Test.c
--     Ssp_Ti_Data_Discard_Test.c
--     Ssp_Spi00_Data_Discard_Test.c
--     Ssp_Spi01_Data_Discard_Test.c
--     Ssp_Spi10_Data_Discard_Test.c
--     Ssp_Spi11_Data_Discard_Test.c
--     Ssp_Nm_Data_Discard_Test.c
--     Ssp_FRFChangeTest.c
--     Ssp_RIS_Test_S.c
--     Ssp_TIS_Test_S.c
--     Ssp_ROR_Test_S.c
--     Ssp_SPI00_RTIS_Test_S.c
--     Ssp_SPI01_RTIS_Test_S.c
--     Ssp_SPI10_RTIS_Test_S.c
--     Ssp_SPI11_RTIS_Test_S.c
--     Ssp_TestMW_S.c
--     Ssp_Testspi00_S.c
--     Ssp_Testspi01_S.c
--     Ssp_Testspi10_S.c
--     Ssp_Testspi11_S.c
--     Ssp_TestTI_S.c
--     Ssp_Data_Test_S.c
--     Ssp_Data_Test_Slave.c
--     Ssp_NonBacktoBack_Test_S.c
--     Ssp_NonBacktoBack_Test_Slave.c
--     Ssp_BacktoBack_Test_S.c
--     Ssp_BacktoBack_Test_Slave.c
--     Ssp_Continuous_S(int32);
--     Ssp_SOD_Test.c
--     Ssp_SOD_Slave_Test.c
--     Ssp_DMA_Tx_Tests.c 
--     Ssp_DMA_Rx_Tests.c 
--   Usage: make <testname> e.g. make Ssp_SOD_TEST, make all ...               
--                                                            
------------------------------------------------------------------------------*/

/******************************************************************************/
/*** For more information on the Ssp, please refer to PL021 AMBA SSP        ***/
/*** Block Specification                                                    ***/
/******************************************************************************/


#include "SspCommon.h"

/*********************************************************************/
/* Modify this define to reflect the period of the SSPCLK set in the */
/* timing.vhd testbench file.                                        */
/*********************************************************************/

#define  SSPCLK_PERIOD  10
#define  PCLK_PERIOD    10

/******************************************************************************/
/************************* Function declarations ******************************/
/******************************************************************************/
void  RegTests(void);
void  PCLKOn(void);
void  RefClkOn(void);
void  Idle(unsigned long time);
void  ProgramReg(int32 write_val , int32 reg_address,unsigned long time);
void  CalculateTimeout(int32 Prescale_val , int32 clkrate );

void  TestTI(int32 , int32);
void  Testspi00(int32 , int32);
void  Testspi01(int32 , int32);
void  Testspi10(int32 , int32);
void  Testspi11(int32 , int32);
void  TestMW(int32 , int32); 
void  FIFO_ptr_test(void); 
void  TxFIFO_critical_test(void);
void  RxFIFO_critical_test(void);

void  Ti_FrameFormat_Test(void);
void  Spi00_FrameFormat_Test(void);
void  Spi01_FrameFormat_Test(void);
void  Spi10_FrameFormat_Test(void);
void  Spi11_FrameFormat_Test(void);
void  Mw_FrameFormat_Test(void);

void  Data_Test(int32, int32, int32, int32);
void  Data_Check_Test(void);

void  NonBacktoBack_Test(int32, int32, int32, int32);
void  NonBacktoBack_Check_Test(void);

void  Ti_BacktoBack_Test(void);
void  Ti_Continuous(void);

void  Spi00_BacktoBack_Test(void);
void  Spi00_Continuous(void);

void  Spi01_BacktoBack_Test(void);
void  Spi01_Continuous(void);

void  Spi10_BacktoBack_Test(void);
void  Spi10_Continuous(void);

void  Spi11_BacktoBack_Test(void);
void  Spi11_Continuous(void);

void  Mw_BacktoBack_Test(void);
void  Mw_Continuous(void);

void  Spi11_ris_Interrupt_Test(void);
void  Spi00_rtis_Interrupt_Test(void);
void  Spi01_rtis_Interrupt_Test(void);
void  Spi10_rtis_Interrupt_Test(void);
void  Spi11_rtis_Interrupt_Test(void);
void  Ti_rtis_Interrupt_Test(void);
void  Mw_rtis_Interrupt_Test(void);
void  Spi00_tis_Interrupt_Test(void);
void  Ti_ror_Interrupt_Test(void);

void  RIS_Test(void);
void  TIS_Test(void);
void  ROR_Test(void);
void  SPI00_RTIS_Test(void);
void  SPI01_RTIS_Test(void);
void  SPI10_RTIS_Test(void);
void  SPI11_RTIS_Test(void);
void  TI_RTIS_Test(void);
void  MW_RTIS_Test(void);
void  SspLoopBack_Test(void);

void  SspdisableTest(void);
void  Ti_sspdisableTest(void); 
void  Mw_sspdisableTest(void); 
void  Spi00_sspdisableTest(void); 
void  Spi01_sspdisableTest(void); 
void  Spi10_sspdisableTest(void);
void  Spi11_sspdisableTest(void);

void  Ti_SOD_SLAVE_Cont_Test(void);

void  ExtSFRM_S(void);
void  Ti_FRCTest_S(void);
void  Mw_FRCTest_S(void);
void  Sph_FRMDA_Test(void);

void  Ti_FrameFormat_Test_S(void);
void  Mw_FrameFormat_Test_S(void);
void  Spi00_FrameFormat_Test_S(void); 
void  Spi01_FrameFormat_Test_S(void); 
void  Spi10_FrameFormat_Test_S(void);
void  Spi11_FrameFormat_Test_S(void);

void  Spi11_ris_Interrupt_Test_S(void);
void  Spi00_rtis_Interrupt_Test_S(void);
void  Spi01_rtis_Interrupt_Test_S(void);
void  Spi10_rtis_Interrupt_Test_S(void);
void  Spi11_rtis_Interrupt_Test_S(void);
void  Ti_rtis_Interrupt_Test_S(void);
void  Mw_rtis_Interrupt_Test_S(void);
void  Spi00_tis_Interrupt_Test_S(void);
void  Ti_ror_Interrupt_Test_S(void);
void  FIFO_ptr_test_S(void);

void  SspdisableTest_S(void);
void  Ti_sspdisableTest_S(void); 
void  Mw_sspdisableTest_S(void); 
void  Spi00_sspdisableTest_S(void);
void  Spi01_sspdisableTest_S(void);
void  Spi10_sspdisableTest_S(void);
void  Spi11_sspdisableTest_S(void);

void  Ti_MSTests(void);
void  Mw_MSTests(void);
void  Spi00_MSTests(void);
void  Spi01_MSTests(void);
void  Spi10_MSTests(void);
void  Spi11_MSTests(void);

void  Ti_MSSODTests(void);
void  Mw_MSSODTests(void);
void  Spi00_MSSODTests(void);
void  Spi01_MSSODTests(void);
void  Spi10_MSSODTests(void);
void  Spi11_MSSODTests(void);

void  Ti_DeAssert_SFRM_Test(void);
void  Spi00_DeAssert_SFRM_Test(void);
void  Spi01_DeAssert_SFRM_Test(void);
void  Spi10_DeAssert_SFRM_Test(void);
void  Spi11_DeAssert_SFRM_Test(void);
void  Mw_DeAssert_SFRM_Test(void);

void  Ti_Data_Discard_Test(void);
void  Spi00_Data_Discard_Test(void);
void  Spi01_Data_Discard_Test(void);
void  Spi10_Data_Discard_Test(void);
void  Spi11_Data_Discard_Test(void);
void  Nm_Data_Discard_Test(void);

void  FRFChangeTest(void);

void  RIS_Test_S(void);
void  TIS_Test_S(void);
void  ROR_Test_S(void);
void  SPI00_RTIS_Test_S(void);
void  SPI01_RTIS_Test_S(void);
void  SPI10_RTIS_Test_S(void);
void  SPI11_RTIS_Test_S(void);
void  TI_RTIS_Test_S(void);
void  MW_RTIS_Test_S(void);

void  TestMW_S(int32, int32);
void  Testspi00_S(int32, int32);
void  Testspi01_S(int32, int32);
void  Testspi10_S(int32, int32);
void  Testspi11_S(int32, int32);
void  TestTI_S(int32, int32);

void  Data_Test_S(int32, int32, int32, int32);
void  Data_Test_Slave(void);

void  NonBacktoBack_Test_S(int32, int32, int32, int32);
void  NonBacktoBack_Test_Slave(void);
 
void  BacktoBack_Test_S(int32, int32, int32, int32);
void  BacktoBack_Test_Slave(void);
void  Continuous_S(int32);
 
void  SOD_Test(int32, int32, int32, int32);
void  SOD_Slave_Test(void);
void  DMA_Tx_Tests(void);
void  DMA_Rx_Tests(void);

void  Mode_Change_Tests(void);
void  Ssp_Ti_RxDisMid_S(void);
void  Ssp_Nmw_RxDisMid_S(void);

/******************************************************************************/
/************************** Include Function Bodies ***************************/
/******************************************************************************/

/* Register Tests */ 
#if defined(ALL_TESTS) || defined(REG_TESTS)
#	include "Ssp_RegTests.c"
#endif

/* Data Tests for the measurement of Setup and Hold Times */
#if defined(ALL_TESTS) || defined(DATA_TESTS)
#       include "Ssp_Data_Test.c"
#	include "Ssp_Data_Check_Test.c"
#endif

/* Non Back to Back Tests */
#if defined(ALL_TESTS) || defined(NON_BACK_TO_BACK_TESTS)
#       include "Ssp_NonBacktoBack_Test.c"
#	include "Ssp_NonBacktoBack_Check_Test.c"
#endif

/* Frame Format Tests */
#if defined(ALL_TESTS) || defined(FRAME_FORMAT_TESTS)
#       include "Ssp_TestTI.c"
#	include "Ssp_Ti_FrameFormat_Test.c"
#       include "Ssp_TestMW.c"
#	include "Ssp_Mw_FrameFormat_Test.c"
#       include "Ssp_Testspi00.c"
#	include "Ssp_Spi00_FrameFormat_Test.c"
#       include "Ssp_Testspi01.c"
#	include "Ssp_Spi01_FrameFormat_Test.c"
#       include "Ssp_Testspi10.c"
#	include "Ssp_Spi10_FrameFormat_Test.c"
#       include "Ssp_Testspi11.c"
#	include "Ssp_Spi11_FrameFormat_Test.c"
#endif

/* Back to Back tests */
#if defined(ALL_TESTS) || defined(BACK_TO_BACK_TESTS)
#       include "Ssp_Spi00_Continuous.c"
#	include "Ssp_Spi00_BacktoBack_Test.c"
#       include "Ssp_Spi01_Continuous.c"
#	include "Ssp_Spi01_BacktoBack_Test.c"
#       include "Ssp_Spi10_Continuous.c"
#	include "Ssp_Spi10_BacktoBack_Test.c"
#       include "Ssp_Spi11_Continuous.c"
#	include "Ssp_Spi11_BacktoBack_Test.c"
#       include "Ssp_Ti_Continuous.c"
#	include "Ssp_Ti_BacktoBack_Test.c"
#       include "Ssp_Mw_Continuous.c"
#	include "Ssp_Mw_BacktoBack_Test.c"
#endif

/* RIS Interrupt tests */
#if defined(ALL_TESTS) || defined(RIS_INTERRUPT_TESTS) 
#       include "Ssp_RIS_Test.c" 
#	include "Ssp_Spi11_ris_Interrupt_Test.c" 
#endif 

/* TIS Interrupt tests */
#if defined(ALL_TESTS) || defined(TIS_INTERRUPT_TESTS)
#       include "Ssp_TIS_Test.c"
#	include "Ssp_Spi00_tis_Interrupt_Test.c"
#endif */

/* RORIS Interrupt tests */
#if defined(ALL_TESTS) || defined(RORIS_INTERRUPT_TESTS) 
#	include "Ssp_ROR_Test.c" 
#	include "Ssp_Ti_ror_Interrupt_Test.c" 
#endif 

/* SPI00_RTIS Interrupt tests */
#if defined(ALL_TESTS) || defined(SPI00_RTIS_INTERRUPT_TESTS) 
#	include "Ssp_Spi00_RTIS_Test.c" 
#	include "Ssp_Spi00_rtis_Interrupt_Test.c" 
#endif 

/* SPI01_RTIS Interrupt tests */
#if defined(ALL_TESTS) || defined(SPI01_RTIS_INTERRUPT_TESTS) 
#	include "Ssp_Spi01_RTIS_Test.c" 
#	include "Ssp_Spi01_rtis_Interrupt_Test.c" 
#endif 

/* SPI10_RTIS Interrupt tests */
#if defined(ALL_TESTS) || defined(SPI10_RTIS_INTERRUPT_TESTS) 
#	include "Ssp_Spi10_RTIS_Test.c" 
#	include "Ssp_Spi10_rtis_Interrupt_Test.c" 
#endif 

/* SPI11_RTIS Interrupt tests */
#if defined(ALL_TESTS) || defined(SPI11_RTIS_INTERRUPT_TESTS) 
#	include "Ssp_Spi11_RTIS_Test.c" 
#	include "Ssp_Spi11_rtis_Interrupt_Test.c" 
#endif 

/* TI_RTIS Interrupt tests */
#if defined(ALL_TESTS) || defined(TI_RTIS_INTERRUPT_TESTS) 
#	include "Ssp_Ti_RTIS_Test.c" 
#	include "Ssp_Ti_rtis_Interrupt_Test.c" 
#endif 

/* MW_RTIS Interrupt tests */
#if defined(ALL_TESTS) || defined(MW_RTIS_INTERRUPT_TESTS) 
#	include "Ssp_Mw_RTIS_Test.c" 
#	include "Ssp_Mw_rtis_Interrupt_Test.c" 
#endif 

/* Loopback tests */
#if defined(ALL_TESTS) || defined(LOOPBACK_TESTS)
#	include "Ssp_SspLoopBack_Test.c"
#endif

/* Tx - Rx FIFO Pointer tests */
#if defined(ALL_TESTS) || defined(TXRX_FIFO_PTR_TESTS)
#	include "Ssp_FIFO_ptr_test.c"
#endif

/* Tx - Rx FIFO Critical test */ 
#if defined(ALL_TESTS) || defined(TXRX_CRITICAL_TESTS)
#	include "Ssp_TxFIFO_critical_test.c"
#	include "Ssp_RxFIFO_critical_test.c"
#endif

/* Disable tests */ 
#if defined(ALL_TESTS) || defined(DISABLE_TESTS)
#       include "Ssp_Ti_sspdisableTest.c"
#       include "Ssp_Mw_sspdisableTest.c"
#       include "Ssp_Spi00_sspdisableTest.c"
#       include "Ssp_Spi01_sspdisableTest.c"
#       include "Ssp_Spi10_sspdisableTest.c"
#       include "Ssp_Spi11_sspdisableTest.c"
#	include "Ssp_SspdisableTest.c"
#endif

/* Slave data Tests */
/* Common Files that need to be included */
#if defined(ALL_TESTS) \
 || defined(SLAVE_DATA_TESTS) \
 || defined(SLAVE_EXTENDED_FRAME_TESTS) \
 || defined(SLAVE_FRAME_FORMAT_CHANGE_TESTS)
#       include "Ssp_Data_Test_S.c"
#endif

/* Slave data Tests */
#if defined(ALL_TESTS) || defined(SLAVE_DATA_TESTS)
#	include "Ssp_Data_Test_Slave.c"
#endif

/* Slave Non Back to Back Tests */ 
/* Common Files that need to be included */
#if defined(ALL_TESTS) \
 || defined(SLAVE_NON_BACK_TO_BACK_TESTS) \
 || defined(SLAVE_EXTENDED_FRAME_TESTS)
#	include "Ssp_NonBacktoBack_Test_S.c"
#endif

/* Slave Non Back to Back Tests */
#if defined(ALL_TESTS) || defined(SLAVE_NON_BACK_TO_BACK_TESTS)
#	include "Ssp_NonBacktoBack_Test_Slave.c"
#endif

/* Slave Frame Format Tests */
/* Common Files that need to be included */
#if defined(ALL_TESTS) \
 || defined(SLAVE_FRAME_FORMAT_TESTS) \
 || defined(SLAVE_EXTENDED_FRAME_TESTS)
#       include "Ssp_TestTI_S.c"
#	include "Ssp_Ti_FrameFormat_Test_S.c"
#endif

/* Slave Frame Format Tests */
#if defined(ALL_TESTS) || defined(SLAVE_FRAME_FORMAT_TESTS)
#       include "Ssp_Testspi11_S.c"
#       include "Ssp_TestMW_S.c"
#	include "Ssp_Mw_FrameFormat_Test_S.c"
#       include "Ssp_Testspi00_S.c"
#	include "Ssp_Spi00_FrameFormat_Test_S.c"
#       include "Ssp_Testspi01_S.c"
#	include "Ssp_Spi01_FrameFormat_Test_S.c"
#       include "Ssp_Testspi10_S.c"
#	include "Ssp_Spi10_FrameFormat_Test_S.c"
#	include "Ssp_Spi11_FrameFormat_Test_S.c"
#endif

/* Slave Back to Back Tests */
/* Common Files that need to be included */
#if defined(ALL_TESTS) \
 || defined(SLAVE_BACK_TO_BACK_TESTS) \
 || defined(SLAVE_EXTENDED_FRAME_TESTS) \
 || defined(SLAVE_FRAME_DEACT_TESTS)
#       include "Ssp_Continuous_S.c"
#endif

/* Slave Back to Back Tests */
/* Common Files that need to be included */
#if defined(ALL_TESTS) \
 || defined(SLAVE_BACK_TO_BACK_TESTS) \
 || defined(SLAVE_EXTENDED_FRAME_TESTS) \
 || defined(SLAVE_FRAME_DEACT_TESTS)
#	include "Ssp_BacktoBack_Test_S.c"
#endif 

/* Slave Back to Back Tests */
#if defined(ALL_TESTS) || defined(SLAVE_BACK_TO_BACK_TESTS)
#	include "Ssp_BacktoBack_Test_Slave.c"
#endif

/* Slave RIS Interrupt tests */
#if defined(ALL_TESTS) || defined(SLAVE_RIS_INTERRUPT_TESTS)
#       include "Ssp_RIS_Test_S.c"
#	include "Ssp_Spi11_ris_Interrupt_Test_S.c"
#endif

/* Slave TIS Interrupt tests */
#if defined(ALL_TESTS) || defined(SLAVE_TIS_INTERRUPT_TESTS)
#       include "Ssp_TIS_Test_S.c"
#	include "Ssp_Spi00_tis_Interrupt_Test_S.c"
#endif

/* Slave RORIS Interrupt tests */
#if defined(ALL_TESTS) || defined(SLAVE_RORIS_INTERRUPT_TESTS)
#	include "Ssp_ROR_Test_S.c"
#	include "Ssp_Ti_ror_Interrupt_Test_S.c"
#endif

/* Slave SPI00_RTIS Interrupt tests */
#if defined(ALL_TESTS) || defined(SLAVE_SPI00_RTIS_INTERRUPT_TESTS) 
#	include "Ssp_Spi00_RTIS_Test_S.c" 
#	include "Ssp_Spi00_rtis_Interrupt_Test_S.c" 
#endif 

/* Slave SPI01_RTIS Interrupt tests */
#if defined(ALL_TESTS) || defined(SLAVE_SPI01_RTIS_INTERRUPT_TESTS) 
#	include "Ssp_Spi01_RTIS_Test_S.c" 
#	include "Ssp_Spi01_rtis_Interrupt_Test_S.c" 
#endif 

/* Slave SPI10_RTIS Interrupt tests */
#if defined(ALL_TESTS) || defined(SLAVE_SPI10_RTIS_INTERRUPT_TESTS) 
#	include "Ssp_Spi10_RTIS_Test_S.c" 
#	include "Ssp_Spi10_rtis_Interrupt_Test_S.c" 
#endif 

/* Slave SPI11_RTIS Interrupt tests */
#if defined(ALL_TESTS) || defined(SLAVE_SPI11_RTIS_INTERRUPT_TESTS) 
#	include "Ssp_Spi11_RTIS_Test_S.c" 
#	include "Ssp_Spi11_rtis_Interrupt_Test_S.c" 
#endif 

/* Slave TI_RTIS Interrupt tests */
#if defined(ALL_TESTS) || defined(SLAVE_TI_RTIS_INTERRUPT_TESTS) 
#	include "Ssp_Ti_RTIS_Test_S.c" 
#	include "Ssp_Ti_rtis_Interrupt_Test_S.c" 
#endif 

/* Slave MW_RTIS Interrupt tests */
#if defined(ALL_TESTS) || defined(SLAVE_MW_RTIS_INTERRUPT_TESTS) 
#	include "Ssp_Mw_RTIS_Test_S.c" 
#	include "Ssp_Mw_rtis_Interrupt_Test_S.c" 
#endif 

/* Tx - Rx FIFO Pointer tests */
#if defined(ALL_TESTS) || defined(SLAVE_TXRX_FIFO_TESTS)
#	include "Ssp_FIFO_ptr_test_S.c"
#endif

/* SOD tests */
/* Common Files that need to be included */
#if defined(ALL_TESTS) \
 || defined(SOD_TESTS) \
 || defined(MSSOD_TESTS)
#       include "Ssp_SOD_Test.c"
#endif

/* SOD tests */
#if defined(ALL_TESTS) || defined(SOD_TESTS)
#	include "Ssp_SOD_Slave_Test.c"
#	include "Ssp_Ti_SOD_SLAVE_Cont_Test.c"
#endif

/* Extended Frame Test for Slave */
#if defined(ALL_TESTS) || defined(SLAVE_EXTENDED_FRAME_TESTS)
#	include "Ssp_ExtSFRM_S.c"
#endif

/* Free Running Clock Test for Slave */
#if defined(ALL_TESTS) || defined(SLAVE_FREE_RUN_CLOCK_TESTS)
#	include "Ssp_Ti_FRCTest_S.c"
#	include "Ssp_Mw_FRCTest_S.c"
#endif

/* Frame Deactivation Test for Slave */
#if defined(ALL_TESTS) || defined(SLAVE_FRAME_DEACT_TESTS)
#	include "Ssp_Sph_FRMDA_Test.c"
#endif

/* Frame Format Change Test for Slave */
#if defined(ALL_TESTS) || defined(SLAVE_FRAME_FORMAT_CHANGE_TESTS)
#	include "Ssp_FRFChangeTest.c"
#endif

/* Slave Disable tests */ 
#if defined(ALL_TESTS) || defined(SLAVE_DISABLE_TESTS)
#       include "Ssp_Ti_sspdisableTest_S.c"
#       include "Ssp_Mw_sspdisableTest_S.c"
#       include "Ssp_Spi00_sspdisableTest_S.c"
#       include "Ssp_Spi01_sspdisableTest_S.c"
#       include "Ssp_Spi10_sspdisableTest_S.c"
#       include "Ssp_Spi11_sspdisableTest_S.c"
#	include "Ssp_SspdisableTest_S.c"
#endif

/* MS Tests */
#if defined(ALL_TESTS) || defined(MS_TESTS)
#	include "Ssp_Ti_MSTests.c"
#	include "Ssp_Mw_MSTests.c"
#	include "Ssp_Spi00_MSTests.c"
#	include "Ssp_Spi01_MSTests.c"
#	include "Ssp_Spi10_MSTests.c"
#	include "Ssp_Spi11_MSTests.c"
#endif

/* MSSOD Tests */ 
#if defined(ALL_TESTS) || defined(MSSOD_TESTS)
#	include "Ssp_Ti_MSSODTests.c"
#	include "Ssp_Mw_MSSODTests.c"
#	include "Ssp_Spi00_MSSODTests.c"
#	include "Ssp_Spi01_MSSODTests.c"
#	include "Ssp_Spi10_MSSODTests.c"
#	include "Ssp_Spi11_MSSODTests.c"
#endif

/* DeAsserting SFRAME Tests */
#if defined(ALL_TESTS) || defined(DEASSERT_SFRAME_TESTS)
#	include "Ssp_Ti_DeAssert_SFRM_Test.c"
#	include "Ssp_Spi00_DeAssert_SFRM_Test.c"
#	include "Ssp_Spi01_DeAssert_SFRM_Test.c"
#	include "Ssp_Spi10_DeAssert_SFRM_Test.c"
#	include "Ssp_Spi11_DeAssert_SFRM_Test.c"
#	include "Ssp_Mw_DeAssert_SFRM_Test.c"
#endif

/* Data Discard Tests */
#if defined(ALL_TESTS) || defined(DATA_DISCARD_TESTS)
#	include "Ssp_Ti_Data_Discard_Test.c"
#	include "Ssp_Spi00_Data_Discard_Test.c"
#	include "Ssp_Spi01_Data_Discard_Test.c"
#	include "Ssp_Spi10_Data_Discard_Test.c"
#	include "Ssp_Spi11_Data_Discard_Test.c"
#	include "Ssp_Nm_Data_Discard_Test.c"
#endif

/* DMA Tx Tests */
#if defined(ALL_TESTS) || defined(DMA_TX_TESTS)
#	include "Ssp_DMA_Tx_Tests.c"
#endif

/* DMA Rx Tests */
#if defined(ALL_TESTS) || defined(DMA_RX_TESTS)
#	include "Ssp_DMA_Rx_Tests.c"
#endif

/* Mode Change Tests */
#if defined(ALL_TESTS) || defined(MODE_CHANGE_TESTS)
#	include "Ssp_ModeChangeTests.c"
#endif

/* SSP Disabled During Reception Tests */
#if defined(ALL_TESTS) || defined(DISABLE_MID_TESTS)
#	include "Ssp_Ti_RxDisMid_S.c"
#	include "Ssp_Nmw_RxDisMid_S.c"
#endif

/******************************************************************************/
/********************************  MAIN  **************************************/
/******************************************************************************/

int main()
{ 

  C("-----------------------------------------------------------------------------",header);
  C("  This confidential and proprietary software may be used only",header);
  C("  as authorised by a licensing agreement from ARM Limited",header);
  C("    (C) COPYRIGHT 1999 ARM Limited",header);
  C("        ALL RIGHTS RESERVED",header);
  C("  The entire notice above must be reproduced on all authorised copies",header);
  C("  and copies may only be made to the extent permitted by a",header);
  C("  licensing agreement from ARM Limited.",header);
  C("-----------------------------------------------------------------------------",header);
  C(" ",header);
  C("Version and Release Control Information:",header);
  C(" ",header);
  C("File Name              : Ssp.c.rca",header);
  C("File Revision          : 1.4",header);
  C(" ",header);
  C("Release Information    : PrimeCell(TM)-PL022-REL1v2",header);
  C("-----------------------------------------------------------------------------",header);
  
  TestStart();

  RES(LOW,0x1,0x2);
  PI(0x01);

  PI(10);
  /**** Program SSPCLK  periods into the Trickbox ****/
  C("SSPCLK REG LOAD"); 
  PSW(SSPCLK_PERIOD , SSPCLKREG ,SSPCLK);

  if(SSPCLK_PERIOD == PCLK_PERIOD )
  {
    /**** Route PCLK line onto SSPCLK ****/
    PCLKOn();
  }
    else
  {  
    /**** Route RefClk line onto SSPCLK ****/
    RefClkOn();
  } 

  /**** Compliance test program ****/

#if defined(ALL_TESTS) || defined(REG_TESTS)
  C(" Register Tests ");
  RegTests();  
#endif

#if defined(ALL_TESTS) || defined(DATA_TESTS)
  C(" Data Tests for the measurement of Setup and Hold Times ");
  Data_Check_Test();
#endif

#if defined(ALL_TESTS) || defined(NON_BACK_TO_BACK_TESTS)
  C(" Non Back to Back Tests ")
  NonBacktoBack_Check_Test();
#endif

#if defined(ALL_TESTS) || defined(FRAME_FORMAT_TESTS)
  C(" Frame Format Tests ");
    Ti_FrameFormat_Test();
    Mw_FrameFormat_Test();
    Spi00_FrameFormat_Test();
    Spi01_FrameFormat_Test();
    Spi10_FrameFormat_Test();
    Spi11_FrameFormat_Test();
#endif

#if defined(ALL_TESTS) || defined(BACK_TO_BACK_TESTS)
  C(" Back to Back tests ");
    Spi00_BacktoBack_Test();
    Spi01_BacktoBack_Test();
    Spi10_BacktoBack_Test(); 
    Spi11_BacktoBack_Test();
    Ti_BacktoBack_Test();
    Mw_BacktoBack_Test();
#endif

#if defined(ALL_TESTS) || defined(RIS_INTERRUPT_TESTS)
  C(" RIS Interrupt tests ");
  Spi11_ris_Interrupt_Test();
#endif */

#if defined(ALL_TESTS) || defined(TIS_INTERRUPT_TESTS)
  C("TIS Interrupt tests ");
  Spi00_tis_Interrupt_Test();
#endif
 
#if defined(ALL_TESTS) || defined(RORIS_INTERRUPT_TESTS)
  C(" RORIS Interrupt tests ");
  Ti_ror_Interrupt_Test();
#endif

#if defined(ALL_TESTS) || defined(SPI00_RTIS_INTERRUPT_TESTS)
  C(" SPI00 RTIS Interrupt tests ");
  Spi00_rtis_Interrupt_Test();
#endif

#if defined(ALL_TESTS) || defined(SPI01_RTIS_INTERRUPT_TESTS)
  C(" SPI01 RTIS Interrupt tests ");
  Spi01_rtis_Interrupt_Test();
#endif

#if defined(ALL_TESTS) || defined(SPI10_RTIS_INTERRUPT_TESTS)
  C(" SPI10 RTIS Interrupt tests ");
  Spi10_rtis_Interrupt_Test();
#endif

#if defined(ALL_TESTS) || defined(SPI11_RTIS_INTERRUPT_TESTS)
  C(" SPI11 RTIS Interrupt tests ");
  Spi11_rtis_Interrupt_Test();
#endif

#if defined(ALL_TESTS) || defined(TI_RTIS_INTERRUPT_TESTS)
  C(" TI RTIS Interrupt tests ");
  Ti_rtis_Interrupt_Test();
#endif

#if defined(ALL_TESTS) || defined(MW_RTIS_INTERRUPT_TESTS)
  C(" MW RTIS Interrupt tests ");
  Mw_rtis_Interrupt_Test();
#endif

#if defined(ALL_TESTS) || defined(LOOPBACK_TESTS)
  C(" Loopback tests ");
  SspLoopBack_Test();
#endif

#if defined(ALL_TESTS) || defined(TXRX_FIFO_PTR_TESTS)
  C(" Tx - Rx FIFO Pointer tests ");
  FIFO_ptr_test();
#endif

#if defined(ALL_TESTS) || defined(TXRX_CRITICAL_TESTS)
  C(" Tx - Rx FIFO Critical test ");
  if (SSPCLK_PERIOD == PCLK_PERIOD )
  {
    TxFIFO_critical_test(); 
    RxFIFO_critical_test(); 
  } 
#endif

#if defined(ALL_TESTS) || defined(DISABLE_TESTS)
  C(" Disable tests "); 
  SspdisableTest();
#endif
  
#if defined(ALL_TESTS) || defined(SLAVE_DATA_TESTS)
  C(" Slave data Tests ");
  Data_Test_Slave();
#endif

#if defined(ALL_TESTS) || defined(SLAVE_NON_BACK_TO_BACK_TESTS)
  C(" Slave Non Back to Back Tests ");
  NonBacktoBack_Test_Slave();
#endif

#if defined(ALL_TESTS) || defined(SLAVE_FRAME_FORMAT_TESTS)
  C(" Slave Frame Format Tests ");
  Ti_FrameFormat_Test_S();
  Mw_FrameFormat_Test_S();
  Spi00_FrameFormat_Test_S(); 
  Spi01_FrameFormat_Test_S();
  Spi10_FrameFormat_Test_S();
  Spi11_FrameFormat_Test_S();
#endif
 
#if defined(ALL_TESTS) || defined(SLAVE_BACK_TO_BACK_TESTS)
   C(" Slave Back to Back Tests ");
   BacktoBack_Test_Slave();
#endif

#if defined(ALL_TESTS) || defined(SLAVE_RIS_INTERRUPT_TESTS)
   C(" Slave RIS Interrupt tests ");
   Spi11_ris_Interrupt_Test_S();
#endif

#if defined(ALL_TESTS) || defined(SLAVE_TIS_INTERRUPT_TESTS)
   C(" Slave TIS Interrupt tests ");
   Spi00_tis_Interrupt_Test_S();
#endif

#if defined(ALL_TESTS) || defined(SLAVE_RORIS_INTERRUPT_TESTS)
   C(" Slave RORIS Interrupt tests ");
   Ti_ror_Interrupt_Test_S();
#endif

#if defined(ALL_TESTS) || defined(SLAVE_SPI00_RTIS_INTERRUPT_TESTS)
  C(" Slave SPI00 RTIS Interrupt tests ");
  Spi00_rtis_Interrupt_Test_S();
#endif

#if defined(ALL_TESTS) || defined(SLAVE_SPI01_RTIS_INTERRUPT_TESTS)
  C(" Slave SPI01 RTIS Interrupt tests ");
  Spi01_rtis_Interrupt_Test_S();
#endif

#if defined(ALL_TESTS) || defined(SLAVE_SPI10_RTIS_INTERRUPT_TESTS)
  C(" Slave SPI10 RTIS Interrupt tests ");
  Spi10_rtis_Interrupt_Test_S();
#endif

#if defined(ALL_TESTS) || defined(SLAVE_SPI11_RTIS_INTERRUPT_TESTS)
  C(" Slave SPI11 RTIS Interrupt tests ");
  Spi11_rtis_Interrupt_Test_S();
#endif

#if defined(ALL_TESTS) || defined(SLAVE_TI_RTIS_INTERRUPT_TESTS)
  C(" Slave TI RTIS Interrupt tests ");
  Ti_rtis_Interrupt_Test_S();
#endif

#if defined(ALL_TESTS) || defined(SLAVE_MW_RTIS_INTERRUPT_TESTS)
  C(" Slave MW RTIS Interrupt tests ");
  Mw_rtis_Interrupt_Test_S();
#endif

#if defined(ALL_TESTS) || defined(SLAVE_TXRX_FIFO_TESTS)
   C(" Tx - Rx FIFO Pointer tests ");
   FIFO_ptr_test_S();
#endif

#if defined(ALL_TESTS) || defined(SOD_TESTS)
   C(" SOD tests ");
   SOD_Slave_Test();
   Ti_SOD_SLAVE_Cont_Test();
#endif
 
#if defined(ALL_TESTS) || defined(SLAVE_EXTENDED_FRAME_TESTS)
   C(" Extended Frame Test for Slave ");
   ExtSFRM_S();
#endif
 
#if defined(ALL_TESTS) || defined(SLAVE_FREE_RUN_CLOCK_TESTS)
   C(" Free Running Clock Test for Slave ");
   Ti_FRCTest_S();
   Mw_FRCTest_S();
#endif
 
#if defined(ALL_TESTS) || defined(SLAVE_FRAME_DEACT_TESTS)
   C(" Frame Deactivation Test for Slave ");
   Sph_FRMDA_Test();
#endif

#if defined(ALL_TESTS) || defined(SLAVE_FRAME_FORMAT_CHANGE_TESTS)
   C(" Frame Format Change Test for Slave ");
   FRFChangeTest();
#endif

#if defined(ALL_TESTS) || defined(SLAVE_DISABLE_TESTS)
   C(" Slave Disable tests ");
   SspdisableTest_S(); 
#endif

#if defined(ALL_TESTS) || defined(MS_TESTS)
   C(" MS Tests ");
   Ti_MSTests();
   Mw_MSTests();
   Spi00_MSTests();
   Spi01_MSTests();
   Spi10_MSTests();
   Spi11_MSTests();
#endif

#if defined(ALL_TESTS) || defined(MSSOD_TESTS)
   C(" MSSOD Tests ");
   Ti_MSSODTests(); 
   Mw_MSSODTests(); 
   Spi00_MSSODTests(); 
   Spi01_MSSODTests(); 
   Spi10_MSSODTests();
   Spi11_MSSODTests();
#endif

#if defined(ALL_TESTS) || defined(DEASSERT_SFRAME_TESTS)
   C(" DeAsserting SFRAME Tests ");
   Ti_DeAssert_SFRM_Test();
   Spi00_DeAssert_SFRM_Test();
   Spi01_DeAssert_SFRM_Test();
   Spi10_DeAssert_SFRM_Test();
   Spi11_DeAssert_SFRM_Test();
   Mw_DeAssert_SFRM_Test();
#endif

#if defined(ALL_TESTS) || defined(DATA_DISCARD_TESTS)
   C(" Data Discard Tests ");
   Ti_Data_Discard_Test();
   Spi00_Data_Discard_Test();
   Spi01_Data_Discard_Test();
   Spi10_Data_Discard_Test();
   Spi11_Data_Discard_Test();
   Nm_Data_Discard_Test();
#endif

#if defined(ALL_TESTS) || defined(DMA_TX_TESTS)
   C(" DMA TX Tests ");
   DMA_Tx_Tests();
#endif

#if defined(ALL_TESTS) || defined(DMA_RX_TESTS)
   C(" DMA RX Tests ");
   DMA_Rx_Tests();
#endif

#if defined(ALL_TESTS) || defined(MODE_CHANGE_TESTS)
   C(" Mode Change Tests ");
   Mode_Change_Tests();
#endif

#if defined(ALL_TESTS) || defined(DISABLE_MID_TESTS)
   C(" SSP Disabled During Reception Tests ");
   Ti_RxDisMid_S();
   Nmw_RxDisMid_S();
#endif

   PI(20);
   TestEnd();

   return 0;
}
/******************************************************************************/
/***************************** End of MAIN ************************************/
/******************************************************************************/


/******************************************************************************/
/************************* Miscellaneous Functions  ***************************/
/******************************************************************************/


/******************************************************************************/
/****************************  REFCLK to SSPCLK *******************************/
/******************************************************************************/
void RefClkOn()
{
  /*
    Summary: SSPRefClk to SSpCLK
    ===========================
    This test routes the SSPRefClk onto the SSPCLK line.
  */

 C( "SSPRefClk to SSpCLK" );

 /* Clear pclksel */
 PSW(GENCLK_ENABLE | RSTMODE_ENABLE,TB_SET_PINS);

 /* Poll for pclkon zero */
 PO(0x000,MASK_SSPTB_PCLKON,SSPTBSSR,,testing);

 /* Set sspclksel */
 PSW(SSPCLK_ENABLE | RSTMODE_ENABLE,TB_SET_PINS);

}

/******************************************************************************/
/**************************** Refclk to  PCLK *********************************/
/******************************************************************************/
void PCLKOn()
{
  /* 
    Summary: PCLK to SSPPRefClk
    ===========================
    This test routes the PCLK onto the SSPCLK line.
  */

  C( "PCLK to SSPPRefClk" );

 /* Clear sspclksel */
  PSW(RSTMODE_ENABLE,TB_SET_PINS);

 /* Poll for sspclkon zero */
  PO(0x000,MASK_SSPTB_REFCLKON,SSPTBSSR,,testing);

 /* Set pclksel */
  PSW(PCLK_ENABLE | GENCLK_ENABLE | RSTMODE_ENABLE ,TB_SET_PINS);

}

/******************************************************************************/
/********************************  Idle  **************************************/
/******************************************************************************/

void Idle(unsigned long time)
{
  /*
  Summary: Idle function
  ======================

  This is to create the delay of time, passed as the argument to this 
  function.

  */

  unsigned long i;

  if (time <= 2)
  {
    PI(0x02);
  }
  else
  {
    for(i=0; i< ((unsigned long)(time/2) - 1); i++)
    {
      PI(0x02);
    }
    if ((unsigned long)time % 2)
    {
      PI(0x03);
    }
    else
    {
      PI(0x02);
    }
  }
}

void ProgramReg(int32 write_val , int32 reg_address,unsigned long time)
{
   PSW(write_val , reg_address );
     Idle (time);

}

void CalculateTimeout(int32 Prescale_val ,int32 clkrate )

{
   TimeOut = (( SSPCLK_PERIOD / PCLK_PERIOD) * DataSize[WordLength] * Prescale_val * ( clkrate  + 1 ));
}
