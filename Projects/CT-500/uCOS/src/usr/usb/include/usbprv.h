#ifndef __usbprv_h__
#define __usbprv_h__ 1
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
*** Comments:      
***   This file contains the internal USB specific type definitions
***                                                               
**************************************************************************
**END*********************************************************/
#include "stdlib.h"
#include "string.h"

#define USB_lock()                           _disable_interrupts()
#define USB_unlock()                         _enable_interrupts()

/**********************************************************
The following lines have been commented because when MQX
is not used, the RTOS abstration layer provides the
implementation of USB_memalloc routine which aligns
the pointers on cache line size.
**********************************************************/
#define USB_memalloc(n)                      
#define USB_Uncached_memalloc(n)             
#define USB_memfree(ptr)                     

#define USB_memzero(ptr,n)                   memset(ptr,0,n)
#define USB_memcopy(src,dst,n)               memcpy(dst,src,n)

#ifdef _DATA_CACHE_
	#define USB_dcache_invalidate()        		 _dcache_invalidate()
	#define USB_dcache_invalidate_line(p)        _dcache_invalidate_line(p)
	#define USB_dcache_invalidate_mlines(p,n)    _dcache_invalidate_mlines(p,n)
	#define USB_dcache_flush_line(p)        	 _dcache_flush_line(p)
	#define USB_dcache_flush_mlines(p,n)    	 _dcache_flush_mlines(p,n)
#else
	#define USB_dcache_invalidate()
	#define USB_dcache_invalidate_line(p)
	#define USB_dcache_invalidate_mlines(p,n)
	#define USB_dcache_flush_line(p)        
	#define USB_dcache_flush_mlines(p,n)

#endif


#define USB_install_isr(vector, isr, data)   USB_int_install_isr(vector, isr, data)


#endif

/* EOF */

