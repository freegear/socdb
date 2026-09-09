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
***  This file contains USB device API specific function to cancel 
*** transfer.
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
*  Function Name  : _usb_device_cancel_transfer
*  Returned Value : USB_OK or error code
*  Comments       :
*        returns the status of the transaction on the specified endpoint.
*
*END*-----------------------------------------------------------------*/
uint_8 _usb_device_cancel_transfer
   (
      /* [IN] the USB_USB_dev_initialize state structure */
      _usb_device_handle         handle,
            
      /* [IN] the Endpoint number */
      uint_8                     ep_num,
            
      /* [IN] direction */
      uint_8                     direction
   )
{ /* Body */
   uint_8                        error = USB_OK;
   USB_DEV_STATE_STRUCT_PTR      usb_dev_ptr;

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_cancel_transfer");
   #endif
   
   usb_dev_ptr = (USB_DEV_STATE_STRUCT_PTR)handle;
   
   USB_lock();

   /* Cancel transfer on the specified endpoint for the specified 
   ** direction 
   */
#ifdef __VUSBHS__
#ifdef __USB_OS_MQX__   
   error = ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)\
      usb_dev_ptr->CALLBACK_STRUCT_PTR)->DEV_CANCEL_TRANSFER(handle, ep_num, direction);
#else
   error = _usb_dci_vusb20_cancel_transfer(handle, ep_num, direction);
#endif
#elif defined __VUSB32__
#ifdef __USB_OS_MQX__   
   ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)usb_dev_ptr->CALLBACK_STRUCT_PTR)->\
      DEV_CANCEL_TRANSFER(handle, direction, ep_num);
#else
   _usb_dci_vusb11_cancel_transfer(handle, direction, ep_num);
#endif
#else
#error "One of __VUSH32__ or __VUSBHS__ must be defined"
#endif

   USB_unlock();

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_cancel_transfer, SUCCESSFUL");
   #endif
   return error;

} /* EndBody */

/* EOF */
