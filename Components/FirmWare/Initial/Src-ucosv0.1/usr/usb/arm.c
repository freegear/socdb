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
***   This file contains the VUSB functions specific to ARM processor.
***                                                               
**************************************************************************
**END*********************************************************/
#include "arm.h"
#include "stdlib.h"
static uint_8 disable_count = 0;
/*volatile boolean  IN_ISR = FALSE;*/
boolean  IN_ISR = FALSE;
/*#define debug 1*/
#ifdef debug
uint_32 test[100];
#define max 500
uint_32 store_flush[max],i=0;
#endif

/*FUNCTION*-------------------------------------------------------------
*
*  Function Name  : USB_int_install_isr
*  Returned Value : None
*  Comments       :
*        Installs the USB interrupt service routine
*
*END*-----------------------------------------------------------------*/

void USB_int_install_isr
   (
      /* [IN] vector number */
      uint_8 vector_number,

      /* [IN] interrupt service routine address */
      void (_CODE_PTR_ isr_ptr)(void),
            
      /* [IN] parameter for ISR - unused for standalone version */
      pointer  handle
   )
{ /* Body */

	; 
} /* EndBody */


/*FUNCTION*-------------------------------------------------------------
*
*  Function Name  : _bsp_get_usb_vector
*  Returned Value : interrupt vector number
*  Comments       :
*        Get the vector number for the specified device number
*END*-----------------------------------------------------------------*/

uint_8 _bsp_get_usb_vector
   (
      uint_8 device_number
   )
{ /* Body */
#ifdef __USB_HOST__
   if (device_number == 0) {
      return BSP_VUSB20_HOST_VECTOR0;
   } /* Endif */
#endif

#ifdef __USB_DEVICE__
   if (device_number == 0) {
      return BSP_VUSB20_DEVICE_VECTOR0;
   } /* Endif */
#endif

#ifdef __USB_OTG__
   if (device_number == 0) {
      return BSP_VUSB20_OTG_VECTOR0;
   } /* Endif */
#endif
 
} /* EndBody */

/*FUNCTION*-------------------------------------------------------------
*
*  Function Name  : _bsp_get_usb_base
*  Returned Value : Address of the VUSB register base
*  Comments       :
*        Get the USB register base address
*END*-----------------------------------------------------------------*/

pointer _bsp_get_usb_base
   (
      uint_8 device_number
   )
{ /* Body */
   if (device_number == 0) {
      return (pointer)BSP_VUSB20_HOST_BASE_ADDRESS0;
   } /* Endif */
   
} /* EndBody */

/*FUNCTION*-------------------------------------------------------------
*
*  Function Name  : _bsp_get_usb_capability_register_base
*  Returned Value : Address of the VUSB1.1 capability register base
*  Comments       :
*        Get the USB capability register base address
*END*-----------------------------------------------------------------*/

pointer _bsp_get_usb_capability_register_base
   (
      /* [IN] the device number */
      uint_8 device_number
   )
{ /* Body */

   if (device_number == 0) {
      return (pointer)BSP_VUSB20_HOST_BASE_ADDRESS0;
   } /* Endif */
   
} /* EndBody */

#ifndef __USB_OS_MQX__
void _disable_interrupts
   (
      void
   )
{ /* Body */
#if 0   
   if ((!disable_count) && (!IN_ISR)) {
      Disable_IRQ();
   } /* Endif */

   if (!IN_ISR) {
      disable_count++;
   } /* Endif */
#endif

} /* EndBody */

void _enable_interrupts
   (
      void
   )
{ /* Body */
#if 0
   if (!IN_ISR) {
      disable_count--;
   } /* Endif */
   
   if ((!disable_count) && (!IN_ISR)) {
      Enable_IRQ();
   } /* Endif */
#endif
} /* EndBody */

#ifdef _DATA_CACHE_


/*---------------------------------------------------------------
 cache -> mem
-------------------------------------------------------------*/
void _dcache_flush_mlines( void *mem_ptr, int mem_size )
{  
	int i, j;
	
	for(i = 0; i < 4; i++)
	{
		for(j=0;j<128;j++)
		{
			MMU_CleanInvalidateDCacheSET((i<<30)|(j<<5));	
		}
	}	  
}


/*---------------------------------------------------------------

  
-------------------------------------------------------------*/
void _dcache_invalidate_mlines( void *mem_ptr, int mem_size )
{
#if 1
	int i, j;
	
	for(i = 0; i < 4; i++)
	{
		for(j=0;j<128;j++)
		{
			MMU_CleanInvalidateDCacheSET((i<<30)|(j<<5));	
		}
	}
#endif     
   
}


#endif


#endif /* __MQX__ */


/* EOF */
   
