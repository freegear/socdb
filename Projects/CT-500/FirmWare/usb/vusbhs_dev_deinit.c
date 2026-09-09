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
***  This file contains the VUSB_HS Device Controller interface 
***  to de-initialize the endpoints.
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
*  Function Name  : _usb_dci_vusb20_deinit_endpoint
*  Returned Value : None
*  Comments       :
*        Disables the specified endpoint and the endpoint queue head
*
*END*-----------------------------------------------------------------*/
uint_8 _usb_dci_vusb20_deinit_endpoint
   (
      /* [IN] the USB_dev_initialize state structure */
      _usb_device_handle         handle,
            
      /* [IN] the Endpoint number */
      uint_8                     ep_num,
            
      /* [IN] direction */
      uint_8                     direction
   )
{ /* Body */
   USB_DEV_STATE_STRUCT_PTR                     usb_dev_ptr;
   VUSB20_REG_STRUCT_PTR                        dev_ptr;
   VUSB20_EP_QUEUE_HEAD_STRUCT _PTR_            ep_queue_head_ptr;
   uint_32                                      bit_pos;

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_dci_vusb20_deinit_endpoint");
   #endif
   
   usb_dev_ptr = (USB_DEV_STATE_STRUCT_PTR)handle;
   dev_ptr = (VUSB20_REG_STRUCT_PTR)usb_dev_ptr->DEV_PTR;
   
   /* Ger the endpoint queue head address */
   ep_queue_head_ptr = (VUSB20_EP_QUEUE_HEAD_STRUCT_PTR)
      dev_ptr->REGISTERS.OPERATIONAL_DEVICE_REGISTERS.EP_LIST_ADDR + 
      (2*ep_num + direction);
      
   bit_pos = (1 << (16 * direction + ep_num));
      
   /* Check if the Endpoint is Primed */
   if ((!(dev_ptr->REGISTERS.OPERATIONAL_DEVICE_REGISTERS.ENDPTPRIME & bit_pos)) && 
      (!(dev_ptr->REGISTERS.OPERATIONAL_DEVICE_REGISTERS.ENDPTSTATUS & bit_pos))) 
   { 
      /* Reset the max packet length and the interrupt on Setup */
      ep_queue_head_ptr->MAX_PKT_LENGTH = 0;
      
      /* Disable the endpoint for Rx or Tx and reset the endpoint type */
      dev_ptr->REGISTERS.OPERATIONAL_DEVICE_REGISTERS.ENDPTCTRLX[ep_num] &= 
         ((direction ? ~EHCI_EPCTRL_TX_ENABLE : ~EHCI_EPCTRL_RX_ENABLE) | 
          (direction ? ~EHCI_EPCTRL_TX_TYPE : ~EHCI_EPCTRL_RX_TYPE));
   } else 
   { 
      #ifdef _DEVICE_DEBUG_
         DEBUG_LOG_TRACE("_usb_dci_vusb20_deinit_endpoint, error deinit failed");
      #endif
      return USBERR_EP_DEINIT_FAILED;
   } /* Endif */
      
   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_dci_vusb20_deinit_endpoint, SUCCESSFUL");
   #endif

   return USB_OK;
   
} /* EndBody */


