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
***  This file contains USB device API specific function to 
*** deinitialize the endpoint.
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
*  Function Name  : _usb_device_deinit_endpoint
*  Returned Value : USB_OK or error code
*  Comments       :
*  Disables the endpoint and the data structures associated with the 
*  endpoint
*
*END*-----------------------------------------------------------------*/
uint_8 _usb_device_deinit_endpoint
   (
      /* [IN] the USB_USB_dev_initialize state structure */
      _usb_device_handle         handle,
            
      /* [IN] the Endpoint number */
      uint_8                    ep_num,
            
      /* [IN] Direction */
      uint_8                    direction
   )
{ /* Body */
   uint_8         error = 0;
   USB_DEV_STATE_STRUCT_PTR      usb_dev_ptr;
#ifdef __VUSB32__
   XD_STRUCT_PTR              pxd;
#endif

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_deinit_endpoint");
   #endif

   usb_dev_ptr = (USB_DEV_STATE_STRUCT_PTR)handle;
   USB_lock();

#ifdef __VUSBHS__
#ifdef __USB_OS_MQX__   
   error = ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)\
      usb_dev_ptr->CALLBACK_STRUCT_PTR)->DEV_DEINIT_ENDPOINT(handle, ep_num, direction);
#else
   error = _usb_dci_vusb20_deinit_endpoint(handle, ep_num, direction);
#endif
#elif defined __VUSB32__
   if (direction) {
      pxd = &usb_dev_ptr->XDSEND[ep_num];
   } else {
      pxd = &usb_dev_ptr->XDRECV[ep_num];
   } /* Endif */   

   pxd->STATUS = USB_STATUS_IDLE;

#ifdef __USB_OS_MQX__     
   ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)usb_dev_ptr->CALLBACK_STRUCT_PTR)->\
      DEV_DEINIT_ENDPOINT(handle, ep_num, pxd);
#else
   _usb_dci_vusb11_deinit_endpoint(handle, ep_num, pxd);
#endif
#else
#error "One of __VUSB32__ or __VUSBHS__ must be defined"
#endif
   
   USB_unlock();

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_deinit_endpoint,SUCCESSFUL");
   #endif
   
   return error;
} /* EndBody */

/* EOF */
