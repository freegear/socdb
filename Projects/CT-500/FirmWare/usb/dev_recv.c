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
***  This file contains USB device API specific function to receive 
***  data.
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
*  Function Name  : _usb_device_recv_data
*  Returned Value : USB_OK or error code
*  Comments       :
*        Receives data on a specified endpoint.
*
*END*-----------------------------------------------------------------*/
uint_8 _usb_device_recv_data
   (
      /* [IN] the USB_USB_dev_initialize state structure */
      _usb_device_handle         handle,
            
      /* [IN] the Endpoint number */
      uint_8                     ep_num,
            
      /* [IN] buffer to receive data */
      uchar_ptr                  buff_ptr,
            
      /* [IN] length of the transfer */
      uint_32                    size
   )
{ /* Body */

#ifdef __VUSBHS__
   uint_8                           error = USB_OK;
   XD_STRUCT_PTR                    xd_ptr;
   USB_DEV_STATE_STRUCT_PTR         usb_dev_ptr;

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_recv_data");
   #endif

   
   usb_dev_ptr = (USB_DEV_STATE_STRUCT_PTR)handle;

   #ifdef _DATA_CACHE_
   /********************************************************
   If system has a data cache, it is assumed that buffer
   passed to this routine will be aligned on a cache line
   boundry. The following code will invalidate the
   buffer before passing it to hardware driver.   
   ********************************************************/
   USB_dcache_invalidate_mlines((pointer)buff_ptr,size);   
   
   #endif
   
   USB_lock();

   if (!usb_dev_ptr->XD_ENTRIES) 
   {
      USB_unlock();
      #ifdef _DEVICE_DEBUG_
         DEBUG_LOG_TRACE("_usb_device_recv_data, transfer in progress");
      #endif
      return USB_STATUS_TRANSFER_IN_PROGRESS;
   } /* Endif */

   /* Get a transfer descriptor for the specified endpoint 
   ** and direction 
   */
   USB_XD_QGET(usb_dev_ptr->XD_HEAD, usb_dev_ptr->XD_TAIL, xd_ptr);
   
   usb_dev_ptr->XD_ENTRIES--;

   /* Initialize the new transfer descriptor */      
   xd_ptr->EP_NUM = ep_num;
   xd_ptr->BDIRECTION = USB_RECV;
   xd_ptr->WTOTALLENGTH = size;
   xd_ptr->WSOFAR = 0;
   xd_ptr->WSTARTADDRESS = buff_ptr;
   
   xd_ptr->BSTATUS = USB_STATUS_TRANSFER_ACCEPTED;

#ifdef __USB_OS_MQX__   
   error = ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)\
      usb_dev_ptr->CALLBACK_STRUCT_PTR)->DEV_RECV(handle, xd_ptr);
#else
   error = _usb_dci_vusb20_recv_data(handle, xd_ptr);
#endif

   USB_unlock();
   
   if (error) 
   {
      #ifdef _DEVICE_DEBUG_
         DEBUG_LOG_TRACE("_usb_device_recv_data, receive failed");
      #endif
      return USBERR_RX_FAILED;
   } /* Endif */
   
   return error;
#elif defined __VUSB32__
   XD_STRUCT_PTR              pxd;
   USB_DEV_STATE_STRUCT_PTR   usb_dev_ptr;
   
   usb_dev_ptr = (USB_DEV_STATE_STRUCT_PTR)handle;

   #ifdef _DATA_CACHE_
   /********************************************************
   If system has a data cache, it is assumed that buffer
   passed to this routine will be aligned on a cache line
   boundry. The following code will invalidate the
   buffer before passing it to hardware driver.   
   ********************************************************/
   USB_dcache_invalidate_mlines((pointer)buff_ptr,size);   
   
   #endif
   
   USB_lock();
   pxd = &usb_dev_ptr->XDRECV[ep_num];
   
   /*
   ** Check if the endpoint is disabled
   */
   if (pxd->STATUS == USB_STATUS_DISABLED) 
   {
      USB_unlock();
      #ifdef _DEVICE_DEBUG_
         DEBUG_LOG_TRACE("_usb_device_recv_data, receive failed");
      #endif
      return USBERR_RX_FAILED;
   } /* Endif */
   
   if ((pxd->TYPE == USB_CONTROL_ENDPOINT) && (pxd->SETUP_BUFFER_QUEUED)) {
      pxd->SETUP_BUFFER_QUEUED = FALSE;
	  usb_dev_ptr->XDSEND[ep_num].SETUP_BUFFER_QUEUED = FALSE;
      if (size) {
         _usb_device_cancel_transfer(handle, ep_num, USB_RECV);
      } else 
      {
         #ifdef _DEVICE_DEBUG_
            DEBUG_LOG_TRACE("_usb_device_recv_data, SUCCESSFUL");
         #endif
         return USB_OK;
      } /* Endif */ 
   } /* Endif */
   
   /*
   ** Check if any transfer is in progress on this endpoint
   */
   if ((pxd->STATUS == USB_STATUS_TRANSFER_IN_PROGRESS) || 
      (pxd->STATUS == USB_STATUS_TRANSFER_PENDING)) 
   {
      USB_unlock();

      #ifdef _DEVICE_DEBUG_
         DEBUG_LOG_TRACE("_usb_device_recv_data, transfer in progress");
      #endif
      
      return USBERR_TRANSFER_IN_PROGRESS;
   } /* Endif */

   if (pxd->TYPE == USB_ISOCHRONOUS_ENDPOINT) {
      /* if Isochronous */
      if (size > pxd->MAXPACKET) {
         /* 
         ** if asked for more than maxPacket
         ** limit request to maxPacket
         */
         size = pxd->MAXPACKET;
      } /* Endif */
   } /* Endif */

   /*
   ** Queue the transfer if the endpoint is enabled and is not busy.
   ** Note that in the case of a stalled endpoint the transfer will
   ** be queued even though it can not complete without host
   ** intervention.
   */
   pxd->STARTADDRESS = buff_ptr;
   pxd->NEXTADDRESS  = buff_ptr;
   pxd->TODO = size;
   pxd->SOFAR = 0;
   pxd->UNACKNOWLEDGEDBYTES = size;
   pxd->DIRECTION = USB_RECV;
   
   /* return successful transfer initiation status. */
   pxd->STATUS = USB_STATUS_TRANSFER_PENDING;

#ifdef __USB_OS_MQX__
   ((USB_CALLBACK_FUNCTIONS_STRUCT_PTR)usb_dev_ptr->CALLBACK_STRUCT_PTR)->\
      DEV_RECV(handle, USB_RECV, ep_num);
#else
   _usb_dci_vusb11_submit_transfer(handle, USB_RECV, ep_num);
#endif

   /*
   ** If the endpoint is currently stalled notify the user after the
   ** transfer has been queued.  By queuing the transfer the
   ** operation to revert the stall condition may be separated from
   ** the the data transfer code.
   */
   if (pxd->STATUS == USB_STATUS_STALLED) 
   {
      USB_unlock();
      #ifdef _DEVICE_DEBUG_
         DEBUG_LOG_TRACE("_usb_device_recv_data, STALLED endpoint");
      #endif
      return USBERR_ENDPOINT_STALLED;
   } /* Endif */

   USB_unlock();

   #ifdef _DEVICE_DEBUG_
      DEBUG_LOG_TRACE("_usb_device_recv_data, SUCCESSFUL");
   #endif
   
   return USB_OK;
#endif
} /* EndBody */
