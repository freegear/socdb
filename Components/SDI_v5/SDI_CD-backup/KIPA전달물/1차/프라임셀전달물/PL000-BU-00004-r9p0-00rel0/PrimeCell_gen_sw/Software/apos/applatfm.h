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
 * File:     applatfm.h,v
 * Revision: 1.37
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : applatfm.h.rca
 *  File Revision          : 1.10
 * 
 *  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
 *  ----------------------------------------
 *
 * This file contains all platform-specific definitions.
 * These should be set up according to the requirements of the system
 */

/*
 * ENUMERATION OF HARDWARE
 *
 * Each peripheral is identified by a numeric identifier.  For module
 * MOD, this is of type apOS_MOD_oId.  If peripheral data storage is
 * static, this will be a zero-based enumerator.  If storage is external
 * to the modules, this will be a pointer to a data storage block.
 *
 * If peripheral data storage is static, a value apOS_MOD_MAXIMUM should
 * be defined to indicate the number of peripherals of that type within 
 * the system.  This may be included as the last element in the enumeration
 * or separately #defined
 */

/*
 * MODULE TESTING
 *
 * Module testing is selected by defining the TEST_ALL_MODULES() macro to be
 * a sequence of module test invocations
 *
 * The tests are implemented using the TEST_MODULE macro
 */

#ifndef APPLATFM_H
#define APPLATFM_H

#include "../apcommon/aptypes.h"

#if !defined(apOS_NO_STATIC_STATE)
/*
 * Description:
 * Define the constant apOS_NO_STATIC_STATE as non-zero if the peripheral data storage will be
 * created externally.  Undefine this if the storage is static within each module.
 */
#define apOS_NO_STATIC_STATE FALSE
#endif

#if !defined(apOS_CONFIG_USE_NO_CLIB)
/*
 * Description:
 * Define the constant apOS_CONFIG_USE_NO_CLIB as non-zero if the code should not use any
 * C library functions.
 */
#define apOS_CONFIG_USE_NO_CLIB FALSE
#endif

#if !defined(apOS_PLATFORM_INTEGRATOR)
/*
 * Description:
 * Define the constant apOS_PLATFORM_INTEGRATOR as non-zero if running on Integrator.
 * This will allow the test code to check for a logic module and chain the interrupt handler
 */
#define apOS_PLATFORM_INTEGRATOR TRUE
#endif

#if !defined(apOS_PLATFORM_HAS_TIMERS)
/*
 * Description:
 * Define the constant apOS_PLATFORM_HAS_TIMERS as false if the platform does not include
 * any timers.  This will ensure that no cross-module calls using timers are built.
 */
#define apOS_PLATFORM_HAS_TIMERS FALSE
#endif

/*
 * Description:
 * Enumeration of the base addresses for the various 
 * peripheral modules.
 * Base addresses for the standard integrator motherboard peripherals. 
 */
typedef enum apOS_System_xBaseAddress
{
  apOS_SYSTEM_BASE_TIMER0      = (WORD32) 0x13000000, // Timer 0
  apOS_SYSTEM_BASE_TIMER1      = (WORD32) 0x13000100, // Timer 1
  apOS_SYSTEM_BASE_TIMER2      = (WORD32) 0x13000200, // Timer 2
  apOS_SYSTEM_BASE_INT         = (WORD32) 0x14000000, // Interrupt controller base address for IRQ
  apOS_SYSTEM_BASE_FIQ         = (WORD32) 0x14000020, // Interrupt controller base address for FIQ
  apOS_SYSTEM_BASE_RTC         = (WORD32) 0x15000000, // Real Time Clock
  apOS_SYSTEM_BASE_UART0       = (WORD32) 0x16000000, // UART 0
  apOS_SYSTEM_BASE_UART1       = (WORD32) 0x17000000, // UART 1
  apOS_SYSTEM_BASE_KMI0        = (WORD32) 0x18000000, // Keyboard/Mouse Interface 0
  apOS_SYSTEM_BASE_KMI1        = (WORD32) 0x19000000, // Keyboard/Mouse Interface 1
  apOS_SYSTEM_BASE_GPIO        = (WORD32) 0x1B000000, // General Purpose IO
  apOS_SYSTEM_BASE_LM          = (WORD32) 0xC0000000, // LM base address (LED's etc)
  apOS_SYSTEM_BASE_INTLM       = (WORD32) 0xC1000000  // LM Interrupt controller base address
}
apOS_System_eBaseAddress;

/*
 * Description:
 * Identifiers used in this header to build the interrupt source IDs.
 * Each should be in the second byte of the word
 */
#define apOS_INTCTL_AP (0<<8)                        //interrupt controller for Integrator AP
#define apOS_INTCTL_LM (1<<8)                        //interrupt controller for Integrator LM

/*
 * Description:
 * Enumeration of the bit positions of the various interrupt 
 * sources in the each of the interrupt controller registers.
 * Interrupt sources for the standard Integrator motherboard peripherals. 
 *
 * This is an opaque type so that the interrupt source can be identified
 * by whatever means the system requires.  The implementation used here
 * specifies the controller in bits 8-11, and the source in bits 0-7
 */
typedef enum apOS_INT_xInterruptSource
{
  apOS_INT_PROGRAMMED = apOS_INTCTL_AP | 0x00, // Software interrupt source
  apOS_INT_UART0      = apOS_INTCTL_AP | 0x01, // UART 0 interrupt source
  apOS_INT_UART1      = apOS_INTCTL_AP | 0x02, // UART 1 interrupt source
  apOS_INT_KMI0       = apOS_INTCTL_AP | 0x03, // Keyboard/Mouse interrupt source
  apOS_INT_KMI1       = apOS_INTCTL_AP | 0x04, // Keyboard/Mouse interrupt source
  apOS_INT_TIMER0     = apOS_INTCTL_AP | 0x05, // Timer0 interrupt source
  apOS_INT_TIMER1     = apOS_INTCTL_AP | 0x06, // Timer1 interrupt source
  apOS_INT_TIMER2     = apOS_INTCTL_AP | 0x07, // Timer2 interrupt source
  apOS_INT_RTC        = apOS_INTCTL_AP | 0x08, // Real Time Clock interrupt source
  apOS_INT_EXP0       = apOS_INTCTL_AP | 0x09, // Logic Module 0 interrupt source
  apOS_INT_EXP1       = apOS_INTCTL_AP | 0x0A, // Logic Module 1 interrupt source
  apOS_INT_EXP2       = apOS_INTCTL_AP | 0x0B, // Logic Module 2 interrupt source
  apOS_INT_EXP3       = apOS_INTCTL_AP | 0x0C, // Logic Module 3 interrupt source
  apOS_INT_PCI0       = apOS_INTCTL_AP | 0x0D, // PCI bus (INTA#) interrupt source
  apOS_INT_PCI1       = apOS_INTCTL_AP | 0x0E, // PCI bus (INTB#) interrupt source
  apOS_INT_PCI2       = apOS_INTCTL_AP | 0x0F, // PCI bus (INTC#) interrupt source
  apOS_INT_PCI3       = apOS_INTCTL_AP | 0x10, // PCI bus (INTD#) interrupt source
  apOS_INT_LINT       = apOS_INTCTL_AP | 0x11, // V3 PCI bridge interrupt source
  apOS_INT_DEG        = apOS_INTCTL_AP | 0x12, // CompactPCI aux (DEG#) interrupt source
  apOS_INT_ENUM       = apOS_INTCTL_AP | 0x13, // CompactPCI aux (ENUM#) interrupt source
  apOS_INT_PCILB      = apOS_INTCTL_AP | 0x14, // PCI local bus fault interrupt source
  apOS_INT_APC        = apOS_INTCTL_AP | 0x15, // External interrupt source reserved for AutoPC (8 sources)

  apOS_INT_LMSOFT0    = apOS_INTCTL_LM | 0x00, // LM soft interrupt source
  apOS_INT_LMSOFT1    = apOS_INTCTL_LM | 0x01, // LM soft interrupt source
  apOS_INT_LMSOFT2    = apOS_INTCTL_LM | 0x02, // LM soft interrupt source
  apOS_INT_LMSOFT3    = apOS_INTCTL_LM | 0x03, // LM soft interrupt source
  apOS_INT_LMREG      = apOS_INTCTL_LM | 0x04, // LM register (softish) interrupt source

  apOS_INT_NONE       = 0x00000020, // No source - for testing only
  apOS_INT_32BIT      = 0x7FFFFFFF  // Forces compiler to use 32-bit int for enum
}
apOS_INT_oInterruptSource;

/*
 * ------------------------------------------------------------------
 * Test sequence to be performed for this system
 * Each test should be specified as a TEST_MODULE call, with the arguments:
 * + Module identifier (e.g. TIMER)
 * + Primecell number (e.g. 180), or 0 if the number is not known or the Primecell does not use
 *   the identification registers
 * + Primecell instance defined using apOS_INSTANCE, passed the module and instance number
 * + Module base address (e.g. apOS_SYSTEM_BASE_TIMER0)
 * + Module interrupt identifier (e.g. apOS_INT_TIMER0)
 *
 * Should the module have no interrupts, the identifier apOS_INT_NONE should be used.
 *
 * For two interrupts, use the TEST_LIST() macro thus: TEST_LIST(apOS_INT_MODINT1,apOS_INT_MODINT2)
 *
 * If there are more than two interrupts, group these in pairs using the TEST_LIST macro, e.g:
 * TEST_LIST(apOS_INT_MODINT1,TEST_LIST(apOS_INT_MODINT2,apOS_INT_MODINT3))
 */
 #define TEST_ALL_MODULES 

/*Example TEST_ALL_MODULES below:

 #define TEST_ALL_MODULES \
    TEST_MODULE(TIMER, 0, apOS_INSTANCE(TIMER,0), apOS_SYSTEM_BASE_TIMER0,   apOS_INT_TIMER0); \
    TEST_MODULE(TIMER, 0, apOS_INSTANCE(TIMER,1), apOS_SYSTEM_BASE_TIMER1,   apOS_INT_TIMER1); \
    TEST_MODULE(TIMER, 0, apOS_INSTANCE(TIMER,2), apOS_SYSTEM_BASE_TIMER2,   apOS_INT_TIMER2); \
    TEST_MODULE(KMI,   0, apOS_INSTANCE(KMI,0),   apOS_SYSTEM_BASE_KMI0,     apOS_INT_KMI0); \
    TEST_MODULE(KMI,   0, apOS_INSTANCE(KMI,1),   apOS_SYSTEM_BASE_KMI1,     apOS_INT_KMI1); \
    TEST_MODULE(UART,  0, apOS_INSTANCE(UART,0),  apOS_SYSTEM_BASE_UART0,    apOS_INT_UART0); \
    TEST_MODULE(UART,  0, apOS_INSTANCE(UART,1),  apOS_SYSTEM_BASE_UART1,    apOS_INT_UART1); \
    TEST_MODULE(RTC,  30, apOS_INSTANCE(RTC,0),   apOS_SYSTEM_BASE_RTC,      apOS_INT_RTC);  
*/

/*
 * ------------------------------------------------------------------
 * Peripherals available to the system
 * These are not used if USE_NO_PLATFORM is defined
 * If apOS_NO_STATIC_STATE is defined, these are declared as pointers, except the
 * interrupt controller, which currently always uses static state
 */

#ifndef USE_NO_PLATFORM

/*
 * Define the system interrupt controllers.
 * For the Integrator platform, we set up one interrupt controller on the main
 * board and a second on the Logic Module, unless this is a Vectored (VIC) Controller
 */
#if (apINT_VERSION & apVERSION_INTEGRATOR) || (apINT_VERSION & apVERSION_ARMULATOR)
typedef enum apOS_INT_xId
{
    apOS_INT_0,             // The default interrupt controller
#if !(apINT_VERSION & apVERSION_VECTORED)
    apOS_INT_LM,            // The logic module INTC
#endif
    apOS_INT_MAXIMUM        // Number of interrupt controllers in the system
}
apOS_INT_oId;               //Enumeration of interrupt controllers available for the system.
#else
typedef UWORD32 apOS_INT_oId; //A dummy type is required for the indirection layer
#endif

/*
 * Define the system interrupt controllers (VIC).
 */
#if (apINT_VERSION & apVERSION_VECTORED)
typedef enum apOS_VIC_xId
{
    apOS_VIC_0,             // The vectored interrupt controller
    apOS_VIC_MAXIMUM        // Number of vectored interrupt controllers in the system
}
apOS_VIC_oId;               //Enumeration of vectored interrupt controllers available for the system.
#endif

#if !apOS_NO_STATIC_STATE

typedef enum apOS_UART_xId
{
    apOS_UART_0 = 0,		// Specifies UART 0
    apOS_UART_1 = 1,		// Specifies UART 1
    apOS_UART_MAXIMUM		// Number of UARTs in the system
}
apOS_UART_oId;              //Enumeration of UARTs available for the system

typedef enum apOS_GPIO_xId
{
    apOS_GPIO_0 = 0,		// General GPIO available to OEM
    apOS_GPIO_1 = 1,		// General GPIO available to OEM
    apOS_GPIO_MAXIMUM		// Number of GPIOs in the system
}
apOS_GPIO_oId;              //Enumeration of GPIOs available for the system

typedef enum apOS_RTC_xId
{
    apOS_RTC_0   = 0,       // Specifies Timer 0
    apOS_RTC_MAXIMUM        // Number of timers in the system
}
apOS_RTC_oId;               //Enumeration of real time clocks available for the system

typedef enum apOS_KMI_xId
{
    apOS_KMI_0   = 0,       // Specifies Keyboard/Mouse Interface 0
    apOS_KMI_1   = 1,       // Specifies Keyboard/Mouse Interface 1
    apOS_KMI_MAXIMUM        // Number of Interfaces in the system
}
apOS_KMI_oId;               //Enumeration of Keyboard/Mouse Interfaces available for the system

#else

typedef void * apOS_UART_oId;
typedef void * apOS_GPIO_oId;
typedef void * apOS_RTC_oId;
typedef void * apOS_KMI_oId;

#endif

/*
 * ------------------------------------------------------------------
 * Versions of peripherals available to the system
 */
//#define apUART_VERSION 11   //This is an example definition specifying the UART to be a PL011

#endif

#endif // APOS_H
