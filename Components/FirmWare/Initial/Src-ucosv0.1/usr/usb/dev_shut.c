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
***  This file contains USB device API specific function to shutdown 
***  the device.
***                                                               
**************************************************************************
**END*********************************************************/
#include "devapi.h"
#include "usbprv_dev.h"

#ifdef __USB_OS_MQX__
   #include "mqx_arc.h"
#endif

/*FUNCTION*-------------------------------------------------------------
*
*  Function Name  : _usb_device_shutdown
*  Returned Value : USB_OK or error code
*  Comments       :
*        Shutdown an initialized USB device
*
*END*-----------------------------------------------------------------*/
void _usb_device_shutdown
   (
      /* [IN] the USB_USB_dev_initialize state structure */
      _usb_device_handle         handle
   )
{ /* Body */
   USB_DEV_STATE_STRUCT_PTR         usb_dev_ptr;

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_shutdown");
   #endif
   
   usb_dev_ptr = (USB_DEV_STATE_STRUCT_PTR)handle;

#ifdef __VUSBHS__
#ifdef __USB_OS_MQX__   
    ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)\
      usb_dev_ptr->CALLBACK_STRUCT_PTR)->DEV_SHUTDOWN(usb_dev_ptr);
#else
   _usb_dci_vusb20_shutdown(usb_dev_ptr);
#endif
   
   /* Free all the Callback function structure memory */
   USB_memfree((pointer)usb_dev_ptr->SERVICE_HEAD_PTR);

   /* Free all internal transfer descriptors */
   USB_memfree((pointer)usb_dev_ptr->XD_BASE);
   
   /* Free all XD scratch memory */
   USB_memfree((pointer)usb_dev_ptr->XD_SCRATCH_STRUCT_BASE);

   /* Free the temp ep init XD */
   USB_memfree((pointer)usb_dev_ptr->TEMP_XD_PTR);

#elif defined __VUSB32__
#ifdef __USB_OS_MQX__
   ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)usb_dev_ptr->CALLBACK_STRUCT_PTR)->\
      DEV_SHUTDOWN(handle);
#else
   _usb_dci_vusb11_shutdown((_usb_device_handle)usb_dev_ptr);
#endif

   USB_memfree((uchar_ptr)usb_dev_ptr->SERVICE_HEAD_PTR);

   /* Free all internal transfer descriptors */
   USB_memfree((uchar_ptr)usb_dev_ptr->XDSEND);
   USB_memfree((uchar_ptr)usb_dev_ptr->XDRECV);
#endif

   /* Free the USB state structure */
   USB_memfree((pointer)usb_dev_ptr);

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_shutdown,SUCCESSFUL");
   #endif
   
} /* EndBody */
