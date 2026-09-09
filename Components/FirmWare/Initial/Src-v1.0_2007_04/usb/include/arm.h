#ifndef __arc_h__
#define __arc_h__
/*******************************************************************************
** File          : $HeadURL$ 
** Author        : $Author$
** Project       : HSCTRL 
** Instances     : 
** Creation date : 
********************************************************************************
********************************************************************************
** ChipIdea Microelectronica - IPCS
** TECMAIA, Rua Eng. Frederico Ulrich, n 2650
** 4470-920 MOREIRA MAIA
** Portugal
** Tel: +351 229471010
** Fax: +351 229471011
** e_mail: chipidea.com
********************************************************************************
** ISO 9001:2000 - Certified Company
** (C) 2005 Copyright Chipidea(R)
** Chipidea(R) - Microelectronica, S.A. reserves the right to make changes to
** the information contained herein without notice. No liability shall be
** incurred as a result of its use or application.
********************************************************************************
** Modification history:
** $Date$
** $Revision$
*******************************************************************************
*** Description:      
***  This file contains ARM-specific defines. The file is solely for compilations
*** and most customers will need to redfine the code in this file and in arm.c to
*** make it work on their system.
***                                                               
**************************************************************************
**END*********************************************************/

/*--------------------------------------------------------------------------*/
/*
**                            STANDARD TYPES
*/

/*
**  The following typedefs allow us to minimize portability problems
**  due to the various C compilers (even for the same processor) not
**  agreeing on the sizes of "int"s and "short int"s and "longs".
*/
#include "usbcfg.h"


#define _PTR_      *
#define _CODE_PTR_ *

typedef char _PTR_                    char_ptr;    /* signed character       */
typedef unsigned char  uchar, _PTR_   uchar_ptr;   /* unsigned character     */

typedef signed   char   int_8, _PTR_   int_8_ptr;   /* 8-bit signed integer   */
typedef unsigned char  uint_8, _PTR_   uint_8_ptr;  /* 8-bit signed integer   */

typedef          short int_16, _PTR_   int_16_ptr;  /* 16-bit signed integer  */
typedef unsigned short uint_16, _PTR_  uint_16_ptr; /* 16-bit unsigned integer*/

typedef          long  int_32, _PTR_   int_32_ptr;  /* 32-bit signed integer  */
typedef unsigned long  uint_32, _PTR_  uint_32_ptr; /* 32-bit unsigned integer*/

typedef unsigned long  boolean;  /* Machine representation of a boolean */

typedef void _PTR_     pointer;  /* Machine representation of a pointer */

/* IEEE single precision floating point number (32 bits, 8 exponent bits) */
typedef float          ieee_single;

/* IEEE double precision floating point number (64 bits, 11 exponent bits) */
typedef double         ieee_double;

/*--------------------------------------------------------------------------*/
/*
**                          STANDARD CONSTANTS
**
**  Note that if standard 'C' library files are included after types.h,
**  the defines of TRUE, FALSE and NULL may sometimes conflict, as most
**  standard library files do not check for previous definitions.
*/

#ifdef  FALSE
   #undef  FALSE
#endif
#define FALSE ((boolean)0)

#ifdef  TRUE
   #undef  TRUE
#endif
#define TRUE ((boolean)1) 

#ifdef  NULL
   #undef  NULL
#endif

#ifdef __cplusplus
   #define NULL (0)
#else
   #define NULL ((pointer)0)
#endif

typedef  uint_32  USB_REGISTER;

#define  BSP_VUSB20_DEVICE_BASE_ADDRESS0     (0x4001C100)
#define  BSP_VUSB20_DEVICE_VECTOR0           (5)

#define  BSP_VUSB20_HOST_BASE_ADDRESS0		 (0x4001C100)

/*define the memory address for USB stack if heap is not supported */
#ifdef NO_DYNAMIC_MEMORY_ALLOCATION
    /*0x6050.0000 THE MEMORY LOCATION WHERE STACK WILL OPERATE ON  */
	#define  USB_STACK_MEMORY_START 	     CT500_USB_BASE
    /*0x6050.0840 THE MEMORY LOCATIONS WHERE HARDWARE DRIVER WILL OPERATE ON    */
	#define  USB_DRIVER_MEMORY_START    	 (CT500_USB_BASE+0x840)
	/*0x6050.0840 QH address should be aligned on a 2K boundry (bits 0-10 should be 0)  */
	#define  USB_DRIVER_QH_BASE         	 (CT500_USB_BASE+0x840)	
	/*0x6050.1140 DTD address should be aligned on a 4 byte boundry   */
	#define  USB_DRIVER_DTD_BASE        	 (CT500_USB_BASE+0x1140)
	/*0x6050.1560  384Byte*/
	#define  USB_DRIVER_SCRATCH_STRUCT_BASE  (CT500_USB_BASE+0x1560)

#endif

/* The ARC is little-endian, just like USB */
#define USB_uint_16_low(x)                   ((x) & 0xFF)
#define USB_uint_16_high(x)                  (((x) >> 8) & 0xFF)



/*********************************************************
Data caching related macros
**********************************************************/
#ifdef _DATA_CACHE_
	#define USB_Uncached	  volatile
#else
	#define USB_Uncached	  volatile
#endif
/* Macro for aligning the EP queue head to 32 byte boundary */
#define USB_MEM32_ALIGN(n)                   ((n) + (-(n) & 31))
#define USB_CACHE_ALIGN(n)     		     USB_MEM32_ALIGN(n)	


#define PSP_CACHE_LINE_SIZE        (32)
#if PSP_CACHE_LINE_SIZE
#define PSP_MEMORY_ALIGNMENT       (PSP_CACHE_LINE_SIZE-1)
#else
#define PSP_MEMORY_ALIGNMENT       (3)
#endif
#define PSP_MEMORY_ALIGNMENT_MASK  (~PSP_MEMORY_ALIGNMENT)

#ifdef __cplusplus
extern "C" {
#endif
#ifndef __USB_OS_MQX__
extern void USB_int_install_isr(uint_8, void (_CODE_PTR_ )(void), pointer);
extern void _disable_interrupts(void);
extern void _enable_interrupts(void);

#ifdef _DATA_CACHE_
	void _dcache_invalidate(void);
	void _dcache_invalidate_line(pointer);
	/* void _dcache_flush_mlines(pointer, uint_32); */
	void _dcache_flush_mlines(pointer, int);
	void _dcache_flush_line(pointer);
	/* void _dcache_invalidate_mlines(pointer, uint_32); */
	void _dcache_invalidate_mlines(pointer, int);
#endif

#ifndef NO_DYNAMIC_MEMORY_ALLOCATION
 extern	void * USB_memalloc(uint_32 n);
 extern	void * USB_Uncached_memalloc(uint_32 n);
 extern void  USB_memfree(void * aligned_ptr);
#endif

#endif
#ifdef __cplusplus
}
#endif
   
#endif
