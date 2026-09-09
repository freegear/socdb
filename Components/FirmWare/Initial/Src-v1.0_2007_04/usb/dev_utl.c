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
***  This file contains USB device API specific utility functions.
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
*  Function Name  : _usb_device_unstall_endpoint
*  Returned Value : USB_OK or error code
*  Comments       :
*     Unstalls the endpoint in specified direction
*
*END*-----------------------------------------------------------------*/
void _usb_device_unstall_endpoint
   (
      /* [IN] the USB_USB_dev_initialize state structure */
      _usb_device_handle         handle,
            
      /* [IN] the Endpoint number */
      uint_8                     ep_num,
            
      /* [IN] direction */
      uint_8                     direction
   )
{ /* Body */
   /* uint_8         error = 0; */
   USB_DEV_STATE_STRUCT_PTR      usb_dev_ptr;
   
   usb_dev_ptr = (USB_DEV_STATE_STRUCT_PTR)handle;

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_unstall_endpoint");
   #endif
   
   USB_lock();
   
#ifdef __VUSBHS__
#ifdef __USB_OS_MQX__   
    ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)\
      usb_dev_ptr->CALLBACK_STRUCT_PTR)->DEV_UNSTALL_ENDPOINT(handle, ep_num, direction);
#else
   _usb_dci_vusb20_unstall_endpoint(handle, ep_num, direction);
#endif
#elif defined __VUSB32__
#ifdef __USB_OS_MQX__
   ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)usb_dev_ptr->CALLBACK_STRUCT_PTR)->\
      DEV_UNSTALL_ENDPOINT(handle, ep_num);
#else
   _usb_dci_vusb11_unstall_endpoint(handle, ep_num);
#endif
      
   usb_dev_ptr->XDSEND[ep_num].STATUS = USB_STATUS_IDLE;
   usb_dev_ptr->XDRECV[ep_num].STATUS = USB_STATUS_IDLE;
#endif
   USB_unlock();

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_unstall_endpoint, SUCCESSFULL");
   #endif
   
} /* EndBody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : _usb_device_get_status
* Returned Value : USB_OK or error code
* Comments       :
*     Provides API to access the USB internal state.
* 
*END*--------------------------------------------------------------------*/
uint_8 _usb_device_get_status
   (
      /* [IN] Handle to the USB device */
      _usb_device_handle   handle,
      
      /* [IN] What to get the status of */
      uint_8               component,
      
      /* [OUT] The requested status */
      uint_16_ptr          status
   )
{ /* Body */
   USB_DEV_STATE_STRUCT_PTR usb_dev_ptr;

   usb_dev_ptr = (USB_DEV_STATE_STRUCT_PTR)handle;

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_get_status, SUCCESSFULL");
   #endif
   
   USB_lock();
#ifdef __VUSBHS__
   switch (component) {

      case USB_STATUS_DEVICE_STATE:
         *status = usb_dev_ptr->USB_STATE;
         break;

      case USB_STATUS_DEVICE:
         *status = usb_dev_ptr->USB_DEVICE_STATE;
         break;
         #ifndef SMALL_CODE_SIZE
      case USB_STATUS_INTERFACE:
         break;
         #endif         
      case USB_STATUS_ADDRESS:
         *status = usb_dev_ptr->DEVICE_ADDRESS;
         break;
         
      case USB_STATUS_CURRENT_CONFIG:
         *status = usb_dev_ptr->USB_CURR_CONFIG;
         break;

      case USB_STATUS_SOF_COUNT:
         *status = usb_dev_ptr->USB_SOF_COUNT;
         break;
         
      default:
         if (component & USB_STATUS_ENDPOINT) {

#ifdef __USB_OS_MQX__   
            *status = ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)\
               usb_dev_ptr->CALLBACK_STRUCT_PTR)->DEV_GET_ENDPOINT_STATUS(handle, 
               component & USB_STATUS_ENDPOINT_NUMBER_MASK);
#else
            *status = _usb_dci_vusb20_get_endpoint_status(handle,
               component & USB_STATUS_ENDPOINT_NUMBER_MASK);
#endif
         } else {
            USB_unlock();
            #ifdef _DEVICE_DEBUG_
               DEBUG_LOG_TRACE("_usb_device_get_status, bad status");
            #endif
            return USBERR_BAD_STATUS;
         } /* Endif */
         break;

   } /* Endswitch */
#elif defined __VUSB32__

   switch (component) {

      case USB_STATUS_DEVICE_STATE:
         *status = usb_dev_ptr->USB_STATE;
         break;

      case USB_STATUS_DEVICE:
         *status = usb_dev_ptr->USB_DEVICE_STATE;
         break;

      case USB_STATUS_INTERFACE:
         break;
         
      case USB_STATUS_ADDRESS:
#ifdef __USB_OS_MQX__
         *status = 
            ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)usb_dev_ptr->\
               CALLBACK_STRUCT_PTR)->DEV_GET_ADDRESS(handle);
#else
         *status = _usb_dci_vusb11_get_address(handle);
#endif         
         break;
         
      case USB_STATUS_CURRENT_CONFIG:
         *status = usb_dev_ptr->USB_CURR_CONFIG;
         break;

      case USB_STATUS_SOF_COUNT:
         *status = usb_dev_ptr->USB_SOF_COUNT;
         break;
         
      default:
         if (component & USB_STATUS_ENDPOINT) {
#ifdef __USB_OS_MQX__
            *status = 
               ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)usb_dev_ptr->\
                  CALLBACK_STRUCT_PTR)->DEV_GET_ENDPOINT_STATUS(handle,
                  component & USB_STATUS_ENDPOINT_NUMBER_MASK);
#else
            *status = _usb_dci_vusb11_get_endpoint_status(handle,
               component & USB_STATUS_ENDPOINT_NUMBER_MASK);
#endif
         } else {
            USB_unlock();
            #ifdef _DEVICE_DEBUG_
               DEBUG_LOG_TRACE("_usb_device_get_status, bad status");
            #endif
            return USBERR_BAD_STATUS;
         } /* Endif */
         break;

   } /* Endswitch */
#endif
   USB_unlock();

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_get_status, SUCCESSFUL");
   #endif
   
   return USB_OK;   
} /* EndBody */  
 
/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : _usb_device_set_status
* Returned Value : USB_OK or error code
* Comments       :
*     Provides API to set internal state
* 
*END*--------------------------------------------------------------------*/
uint_8 _usb_device_set_status
   (
      /* [IN] Handle to the usb device */
      _usb_device_handle   handle,
      
      /* [IN] What to set the status of */
      uint_8               component,
      
      /* [IN] What to set the status to */
      uint_16              setting
   )
{ /* Body */
   USB_DEV_STATE_STRUCT_PTR usb_dev_ptr;

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_set_status");
   #endif
   
   usb_dev_ptr = (USB_DEV_STATE_STRUCT_PTR)handle;
   USB_lock();
   switch (component) {

      case USB_STATUS_DEVICE_STATE:
         usb_dev_ptr->USB_STATE = setting;
         break;

      case USB_STATUS_DEVICE:
         usb_dev_ptr->USB_DEVICE_STATE = setting;
         break;

      case USB_STATUS_INTERFACE:
         break;

      case USB_STATUS_CURRENT_CONFIG:
         usb_dev_ptr->USB_CURR_CONFIG = setting;
         break;

      case USB_STATUS_SOF_COUNT:
         usb_dev_ptr->USB_SOF_COUNT = setting;
         break;
         
#ifdef __VUSBHS__
      case USB_FORCE_FULL_SPEED:
         _usb_dci_vusb20_set_speed_full((pointer)usb_dev_ptr, setting);
         break;
      case USB_PHY_LOW_POWER_SUSPEND:
         _usb_dci_vusb20_suspend_phy((pointer)usb_dev_ptr, setting);
         break;
#endif


#ifdef __VUSBHS__
      case USB_STATUS_ADDRESS:
         usb_dev_ptr->DEVICE_ADDRESS = setting;

#ifdef __USB_OS_MQX__   
         ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)\
            usb_dev_ptr->CALLBACK_STRUCT_PTR)->DEV_SET_ADDRESS((pointer)usb_dev_ptr, setting);
#else
         _usb_dci_vusb20_set_address((pointer)usb_dev_ptr, setting);
#endif
         break;

      
      case USB_STATUS_TEST_MODE:
         _usb_dci_vusb20_set_test_mode(handle, 
            setting);
         break;
         
      default:
         if (component & USB_STATUS_ENDPOINT) {
#ifdef __USB_OS_MQX__   
	    if (setting) {
	       ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)\
                  usb_dev_ptr->CALLBACK_STRUCT_PTR)->DEV_STALL_ENDPOINT(handle,
                  (component & 0x0F), (component & 0x80));
	    } else {
	       ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)\
                  usb_dev_ptr->CALLBACK_STRUCT_PTR)->DEV_UNSTALL_ENDPOINT(handle,
                  (component & 0x0F), (component & 0x80));

               ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)\
                  usb_dev_ptr->CALLBACK_STRUCT_PTR)->DEV_RESET_DATA_TOGGLE(handle,
                  (component & 0x0F), (component & 0x80));
	    }
#else
            _usb_dci_vusb20_set_endpoint_status(handle,
               component & USB_STATUS_ENDPOINT_NUMBER_MASK,
               setting);
#endif
         } else {
            USB_unlock();
            #ifdef _DEVICE_DEBUG_
               DEBUG_LOG_TRACE("_usb_device_set_status, bad status");
            #endif
            return USBERR_BAD_STATUS;
         } /* Endif */
         break;

#elif defined __VUSB32__
      case USB_STATUS_ADDRESS:
#ifdef __USB_OS_MQX__
         ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)usb_dev_ptr->\
            CALLBACK_STRUCT_PTR)->DEV_SET_ADDRESS(handle,
            setting);
#else
         _usb_dci_vusb11_set_address(handle, setting);
#endif
         
         break;

      default:
         if (component & USB_STATUS_ENDPOINT) {
#ifdef __USB_OS_MQX__
            ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)usb_dev_ptr->\
               CALLBACK_STRUCT_PTR)->DEV_SET_ENDPOINT_STATUS(handle,
               component & USB_STATUS_ENDPOINT_NUMBER_MASK, setting);
#else
            _usb_dci_vusb11_set_endpoint_status(handle,
               component & USB_STATUS_ENDPOINT_NUMBER_MASK,
               setting);
#endif
         } else {
            USB_unlock();
            #ifdef _DEVICE_DEBUG_
               DEBUG_LOG_TRACE("_usb_device_set_status, bad status");
            #endif
            return USBERR_BAD_STATUS;
         } /* Endif */
         break;

#endif

   } /* Endswitch */

   USB_unlock();

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_set_status, SUCCESSFUL");
   #endif
   
   return USB_OK;   
} /* EndBody */

/*FUNCTION*-------------------------------------------------------------
*
*  Function Name  : _usb_device_stall_endpoint
*  Returned Value : USB_OK or error code
*  Comments       :
*     Stalls the endpoint.
*
*END*-----------------------------------------------------------------*/
void _usb_device_stall_endpoint
   (
      /* [IN] the USB_USB_dev_initialize state structure */
      _usb_device_handle         handle,
            
      /* [IN] the Endpoint number */
      uint_8                     ep_num,
            
      /* [IN] direction */
      uint_8                     direction
   )
{ /* Body */
   /* uint_8         error = 0; */
   USB_DEV_STATE_STRUCT_PTR      usb_dev_ptr;

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_stall_endpoint");
   #endif
   
   usb_dev_ptr = (USB_DEV_STATE_STRUCT_PTR)handle;

#ifdef __VUSBHS__
#ifdef __USB_OS_MQX__   
    ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)\
      usb_dev_ptr->CALLBACK_STRUCT_PTR)->DEV_STALL_ENDPOINT(handle, ep_num, direction);
#else
   _usb_dci_vusb20_stall_endpoint(handle, ep_num, direction);
#endif
#elif defined __VUSB32__
   usb_dev_ptr->XDSEND[ep_num].STATUS = USB_STATUS_STALLED;
   usb_dev_ptr->XDRECV[ep_num].STATUS = USB_STATUS_STALLED;

   _usb_device_set_status(handle, USB_STATUS_ENDPOINT | ep_num, 1);
#endif

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_stall_endpoint, SUCCESSFUL");
   #endif
   
} /* EndBody */

//#ifdef __VUSBHS__
/*FUNCTION*-------------------------------------------------------------
*
*  Function Name  : _usb_device_process_resume
*  Returned Value : USB_OK or error code
*  Comments       :
*        Process Resume event
*
*END*-----------------------------------------------------------------*/
void _usb_device_assert_resume
   (
      /* [IN] the USB_USB_dev_initialize state structure */
      _usb_device_handle         handle
   )
{ /* Body */
   USB_DEV_STATE_STRUCT_PTR      usb_dev_ptr;

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_assert_resume");
   #endif
   
   usb_dev_ptr = (USB_DEV_STATE_STRUCT_PTR)handle;

#ifdef __VUSBHS__
#ifdef __USB_OS_MQX__   
    ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)\
      usb_dev_ptr->CALLBACK_STRUCT_PTR)->DEV_ASSERT_RESUME(handle);
#else
   _usb_dci_vusb20_assert_resume(handle);
#endif
#elif defined __VUSB32__
#ifdef __USB_OS_MQX__
   ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)usb_dev_ptr->CALLBACK_STRUCT_PTR)->\
      DEV_ASSERT_RESUME(handle);
#else
   _usb_dci_vusb11_assert_resume(handle);
#endif
#endif

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_assert_resume, SUCCESSFUL");
   #endif

} /* EndBody */
//#endif

/* EOF */
