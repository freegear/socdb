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
***  This file contains the USB Mass storage disk example application.
*** Notice the fact that this example acts like a full speed disk on a
*** ARC full speed core and high-speed disk on a high-speed core. It
*** actually detects the speed by registering the speed detection with
**** the stack and changes descriptors for each speed.***                                                               
**************************************************************************
**END*********************************************************/

/**************************************************************************
Include the USB stack and local header files.
**************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "irq.h"

extern void _usb_dci_vusb20_isr(smtUint32 IRQ);
extern void _disable_interrupts(void);
extern void _enable_interrupts(void);
void card_detect_handler(smtUint32 IRQ);

#include "usbcfg.h"
#include "usb.h"
#include "usbprv.h"
#include "tdevapi.h"
#include "tdisk.h"

// arm.h
#define PSP_CACHE_LINE_SIZE		(32)
#define USB_MEM32_ALIGN(n)		((n) + (-(n) & 31))
#define USB_CACHE_ALIGN(n)		USB_MEM32_ALIGN(n)	

static smtBoolean   write_flag = SMT_FALSE;
static smtUint32    write_length;
static smtUint32    write_address;

#define CARD_EXTRACT	0x01
#define CARD_INSERTED	0x00

static smtUint32 CARD_DETECT = CARD_EXTRACT;
static smtUint32 CARD_OK	     = SMT_FALSE;
/**************************************************************************
Global variables and some defines for device.
**************************************************************************/

#define  APP_CONTROL_MAX_PKT_SIZE         (64)
#define  DEV_DESC_MAX_PACKET_SIZE         (7)
#define  EP1_FS_MAX_PACKET_SIZE           (64)
#define  EP1_HS_MAX_PACKET_SIZE           (512)
#define  CFG_DESC_EP1TX_MAX_PACKET_SIZE   (22)
#define  CFG_DESC_EP1RX_MAX_PACKET_SIZE   (29)

#define  TOT_DISK_SZ				  (TOTAL_LOGICAL_ADDRESS_BLOCKS/512)
#define  LENGTH_OF_EACH_LAB               (512)


#define USBUint16low(x)                   ((x) & 0xFF)
#define USBUint16high(x)                  (((x) >> 8) & 0xFF)
#define USBUint32low(x)                   ((x) & 0xFFFF)
#define USBUint32high(x)                  (((x) >> 16) & 0xFFFF)	


smtUint8 *ep1_buf;
smtUint8 *epTemp_buf;
smtUint8 *ep_mass_buf;

/**********************************
Buffers for use by this application
***********************************/
smtUint8 *Send_Buffer_Unaligned;
smtUint8 *Send_Buffer_aligned;

volatile smtBoolean TEST_ENABLED = SMT_FALSE;

/*All high-speed device are supposed to support test mode
see USB specification*/

volatile smtBoolean  ENTER_TEST_MODE = SMT_FALSE; 
volatile smtUint16  test_mode_index = 0;
volatile smtUint8    speed = 0;


/**************************************************************************
DESCRIPTORS DESCRIPTORS DESCRIPTORS DESCRIPTORS DESCRIPTORS DESCRIPTORS
**************************************************************************/

#define DEVICE_DESCRIPTOR_SIZE 18
smtUint8 *DevDesc;
smtUint8 DevDescData[DEVICE_DESCRIPTOR_SIZE] =
{
   /* Length of DevDesc */
   DEVICE_DESCRIPTOR_SIZE,
   /* "Device" Type of descriptor */
   1,
   /* BCD USB version */
   0, 2,
   /* Device Class is indicated in the interface descriptors */
   0x00,
   /* Device Subclass is indicated in the interface descriptors */
   0x00,
   /* Mass storage devices do not use class-specific protocols */
   0x00,
   /* Max packet size */
   APP_CONTROL_MAX_PKT_SIZE,
   /* Vendor ID */
   USBUint16low(CT500_VID), USBUint16high(CT500_VID),
   /* Product ID */
   USBUint16low(CT500_PID), USBUint16high(CT500_PID),
   /* BCD Device version */
   USBUint16low(CT500_REVISION), USBUint16high(CT500_REVISION),
   /* Manufacturer string index */
   0x1,
   /* Product string index */
   0x2,
   /* Serial number string index */
   0x6,
   /* Number of configurations available */
   0x1
};

/* USB 2.0 specific descriptor */
#define DEVICE_QUALIFIER_DESCRIPTOR_SIZE 10
smtUint8 *DevQualifierDesc;
smtUint8 DevQualifierDescData[DEVICE_QUALIFIER_DESCRIPTOR_SIZE] =
{
   DEVICE_QUALIFIER_DESCRIPTOR_SIZE,  /* bLength Length of this descriptor */
   6,                         /* bDescType This is a DEVICE Qualifier descr */
   0,2,                       /* bcdUSB USB revision 2.0 */
   0,                         /* bDeviceClass */
   0,                         /* bDeviceSubClass */
   0,                         /* bDeviceProtocol */
   APP_CONTROL_MAX_PKT_SIZE,  /* bMaxPacketSize0 */
   0x01,                      /* bNumConfigurations */
   0
};

#define CONFIG_DESC_NUM_INTERFACES  (4)
/* This must be counted manually and updated with the descriptor */
/* 1*Config(9) + 1*Interface(9) + 2*Endpoint(7) = 32 bytes */
#define CONFIG_DESC_SIZE            (32)

smtUint8 *ConfigDesc_Unaligned;

/**************************************************************
we declare the config desc as USB_Uncached because this descriptor
is updated on the fly for max packet size during enumeration. Making
it uncached ensures that main memory is updated whenever this
descriptor pointer is used.
**************************************************************/
smtUint8 *ConfigDesc;

smtUint8 ConfigDescData[CONFIG_DESC_SIZE] =
{
   /* Configuration Descriptor - always 9 bytes */
   9,
   /* "Configuration" type of descriptor */
   2,
   /* Total length of the Configuration descriptor */
   USBUint16low(CONFIG_DESC_SIZE), USBUint16high(CONFIG_DESC_SIZE),
   /* NumInterfaces */
   1,
   /* Configuration Value */
   1,
   /* Configuration Description String Index*/
   4,
   /* Attributes.  Self-powered */
   0xc0,
   /* Current draw from bus */
   1,
   /* Interface 0 Descriptor - always 9 bytes */
   9,
   /* "Interface" type of descriptor */
   4,
   /* Number of this interface */
   MASS_STORAGE_INTERFACE,
   /* Alternate Setting */
   0,
   /* Number of endpoints on this interface */
   2,
   /* Interface Class */
   0x08,
   /* Interface Subclass: SCSI transparent command set */
   0x06,
   /* Interface Protocol: Bulk only protocol */
   0x50,
   /* Interface Description String Index */
   0,
   /* Endpoint 1 (Bulk In Endpoint), Interface 0 Descriptor - always 7 bytes*/
   7,
   /* "Endpoint" type of descriptor */
   5,
   /*
   ** Endpoint address.  The low nibble contains the endpoint number and the
   ** high bit indicates TX(1) or RX(0).
   */
   0x81,
   /* Attributes.  0=Control 1=Isochronous 2=Bulk 3=Interrupt */
   0x02,
   /* Max Packet Size for this endpoint */
   USBUint16low(EP1_FS_MAX_PACKET_SIZE), 
   USBUint16high(EP1_FS_MAX_PACKET_SIZE),
   /* Polling Interval (ms) */
   0,
   /* Endpoint 2 (Bulk Out Endpoint), Interface 0 Descriptor - always 7 bytes*/
   7,
   /* "Endpoint" type of descriptor */
   5,
   /*
   ** Endpoint address.  The low nibble contains the endpoint number and the
   ** high bit indicates TX(1) or RX(0).
   */
   0x01,
   /* Attributes.  0=Control 1=Isochronous 2=Bulk 3=Interrupt */
   0x02,
   /* Max Packet Size for this endpoint */
   USBUint16low(EP1_FS_MAX_PACKET_SIZE), 
   USBUint16high(EP1_FS_MAX_PACKET_SIZE),
   /* Polling Interval (ms) */
   0
};

#define OTHER_SPEED_CONFIG_DESC_SIZE  CONFIG_DESC_SIZE
smtUint8 *other_speed_config;
smtUint8 other_speed_config_data[CONFIG_DESC_SIZE] =
{
   9,                         /* bLength Length of this descriptor */
   7,                         /* bDescType This is a Other speed config descr */
   OTHER_SPEED_CONFIG_DESC_SIZE & 0xff, 
   OTHER_SPEED_CONFIG_DESC_SIZE >> 8,
   1,
   1,
   4,
   /* Attributes.  Self-powered */
   0xc0,
   /* Current draw from bus */
   1,
   /* Interface 0 Descriptor - always 9 bytes */
   9,
   /* "Interface" type of descriptor */
   4,
   /* Number of this interface */
   MASS_STORAGE_INTERFACE,
   /* Alternate Setting */
   0,
   /* Number of endpoints on this interface */
   2,
   /* Interface Class */
   0x08,
   /* Interface Subclass: SCSI transparent command set */
   0x06,
   /* Interface Protocol: Bulk only protocol */
   0x50,
   /* Interface Description String Index */
   0,
   /* Endpoint 1 (Bulk In Endpoint), Interface 0 Descriptor - always 7 bytes*/
   7,
   /* "Endpoint" type of descriptor */
   5,
   /*
   ** Endpoint address.  The low nibble contains the endpoint number and the
   ** high bit indicates TX(1) or RX(0).
   */
   0x81,
   /* Attributes.  0=Control 1=Isochronous 2=Bulk 3=Interrupt */
   0x02,
   /* Max Packet Size for this endpoint */
   USBUint16low(EP1_HS_MAX_PACKET_SIZE), 
   USBUint16high(EP1_HS_MAX_PACKET_SIZE),
   /* Polling Interval (ms) */
   0,
   /* Endpoint 2 (Bulk Out Endpoint), Interface 0 Descriptor - always 7 bytes*/
   7,
   /* "Endpoint" type of descriptor */
   5,
   /*
   ** Endpoint address.  The low nibble contains the endpoint number and the
   ** high bit indicates TX(1) or RX(0).
   */
   0x01,
   /* Attributes.  0=Control 1=Isochronous 2=Bulk 3=Interrupt */
   0x02,
   /* Max Packet Size for this endpoint */
   USBUint16low(EP1_HS_MAX_PACKET_SIZE), 
   USBUint16high(EP1_HS_MAX_PACKET_SIZE),
   /* Polling Interval (ms) */
   0
};

smtUint8 USB_IF_ALT[4] = { 0, 0, 0, 0};

/* number of strings in the table not including 0 or n. */
smtUint8 USB_STR_NUM = 7;

/*
** if the number of strings changes, look for USB_STR_0 everywhere and make 
** the obvious changes.  It should be found in 3 places.
*/

#define USB_STRING_ARRAY_SIZE  9

smtUint16 USB_STRING_DESC[USB_STRING_ARRAY_SIZE][64];
smtUint8  *USB_STRING[USB_STRING_ARRAY_SIZE] = 
{
	(smtUint8 *)0x0,
	(smtUint8 *)CT500_USB_STR1,
	(smtUint8 *)CT500_USB_STR2,
	(smtUint8 *)CT500_USB_STR3,
	(smtUint8 *)CT500_USB_STR4,
	(smtUint8 *)CT500_USB_STR5,
	(smtUint8 *)CT500_USB_STR6,
	(smtUint8 *)CT500_USB_STR7,
	(smtUint8 *)CT500_USB_STR8
};
	
/*****************************************************************
MASS STORAGE SPECIFIC GLOBALS
*****************************************************************/

volatile smtBoolean        CBW_PROCESSED = SMT_FALSE;
volatile smtBoolean        ZERO_TERMINATE = SMT_FALSE;
CSW_STRUCT     csw;

MASS_STORAGE_DEVICE_INFO_STRUCT device_information_data = {
   0, 0x80, 0, 0x01, 0x1F, 0, 0, 0, 
   /* Vendor information: "TDI     " */
   {0x54, 0x44, 0x49, 0x20, 0x20, 0x20, 0x20, 0x20,}, 
   /* Product information: "Disk            " */
   {0x44, 0x69, 0x73, 0x6B, 0x20, 0x20, 0x20, 0x20,
   0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20}, 
   /* Product Revision level: "Demo" */
   {0x44, 0x65, 0x6D, 0x6F}
}; 


MASS_STORAGE_READ_CAPACITY_STRUCT read_capacity = {
   /* Data for the capacity */
   {
	   USBUint16high(USBUint32high((TOT_DISK_SZ))),
	   USBUint16low (USBUint32high((TOT_DISK_SZ))),
	   USBUint16high(USBUint32low ((TOT_DISK_SZ))),
	   USBUint16low (USBUint32low ((TOT_DISK_SZ))),  			
   }, 
   {
      0x00, 0x00, USBUint16high(LENGTH_OF_EACH_LAB), 
      USBUint16low(LENGTH_OF_EACH_LAB)
   }
};

smtUint8 *MASS_STORAGE_DISK_UNALIGNED;
smtUint8 *MASS_STORAGE_DISK;


volatile smtUint8          usb_status[2];
volatile smtUint8         endpoint, if_status;
volatile smtUint8         data_to_send;
smtUint16        sof_count;
smtUint8         setup_packet[sizeof(SETUP_STRUCT)];
SETUP_STRUCT   local_setup_packet;


void service_ep0(void *handle, smtBoolean setup, smtUint8 direction,
					smtUint8 *buffer, smtUint32 length, smtUint8 error);

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : ch9GetStatus
* Returned Value : None
* Comments       :
*     Chapter 9 GetStatus command
*     wValue=Zero
*     wIndex=Zero
*     wLength=1
*     DATA=bmERR_STAT
*     The GET_STATUS command is used to read the bmERR_STAT register.
*     
*     Return the status based on the bRrequestType bits:
*     device (0) = bit 0 = 1 = self powered
*                  bit 1 = 0 = DEVICE_REMOTE_WAKEUP which can be modified
*     with a SET_FEATURE/CLEAR_FEATURE command.
*     interface(1) = 0000.
*     endpoint(2) = bit 0 = stall.
*     static smtUint8 *pData;
*
*     See section 9.4.5 (page 190) of the USB 1.1 Specification.
* 
*END*--------------------------------------------------------------------*/
void ch9GetStatus
   (
      /* USB handle */
      void *handle,
      
      /* Is it a Setup phase? */
      smtBoolean setup,
            
      /* The setup packet pointer */
      SETUP_STRUCT_PTR setup_ptr
   )
{ /* Body */
   smtUint16 temp_status;
   
   if (setup) {
      switch (setup_ptr->REQUESTTYPE) {

         case 0x80:
            /* Device request */
            _usb_device_get_status(handle, 
                                    USB_STATUS_DEVICE, 
                                    (smtUint16 *)&usb_status);
            /* Send the requested data */
            _usb_device_send_data(
                  handle, 
                  0, 
                  (smtUint8 *)&usb_status, 
                  2 /*two bytes */
                  );
            break;

         case 0x81:
            /* Interface request */
            if_status = USB_IF_ALT[setup_ptr->INDEX & 0x00FF];
            /* Send the requested data */
            _usb_device_send_data(handle, 0, (void *) &if_status, sizeof(if_status));
            break;
      
         case 0x82:
            /* Endpoint request */
            endpoint = setup_ptr->INDEX & USB_STATUS_ENDPOINT_NUMBER_MASK;

            _usb_device_get_status(handle,
               USB_STATUS_ENDPOINT | endpoint,&temp_status);
            
            /*copy status to usb_status global buffer for uncached access */
            usb_status[0] = temp_status & 0xFF;
            usb_status[1] = (temp_status >> 8)& 0xFF;
            
            /* Send the requested data */
            _usb_device_send_data(handle,
                                 0,
                                 (smtUint8 *) &usb_status, 
                                 2 //sizeof(usb_status)
                                 );      
            break;
         
         default:
            /* Unknown request */
            _usb_device_stall_endpoint(handle, 0, 0);
            return;

      } /* Endswitch */
      
      /* status phase */
      _usb_device_recv_data(handle, 0, 0, 0);
   } /* Endif */
   return;
} /* Endbody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : ch9ClearFeature
* Returned Value : None
* Comments       :
*     Chapter 9 ClearFeature command
* 
*END*--------------------------------------------------------------------*/
void ch9ClearFeature
   (
      /* USB handle */
      void *handle,
      
      /* Is it a Setup phase? */
      smtBoolean setup,
            
      /* The setup packet pointer */
      SETUP_STRUCT_PTR setup_ptr
   )
{ /* Body */
   static smtUint8           endpoint;
   smtUint16                 usb_status;

   _usb_device_get_status(handle, USB_STATUS_DEVICE_STATE, &usb_status);

   if ((usb_status != USB_STATE_CONFIG) && (usb_status != USB_STATE_ADDRESS)) {
      _usb_device_stall_endpoint(handle, 0, 0);
      return;
   } /* Endif */

   if (setup) {
      switch (setup_ptr->REQUESTTYPE) {
      
         case 0:
            /* DEVICE */
            if (setup_ptr->VALUE == 1) {
               /* clear remote wakeup */
               _usb_device_get_status(handle, USB_STATUS_DEVICE, &usb_status);
               usb_status &= ~USB_REMOTE_WAKEUP;
               _usb_device_set_status(handle, USB_STATUS_DEVICE, usb_status);
            } else {
               _usb_device_stall_endpoint(handle, 0, 0);
               return;
            } /* Endif */
            break;
         
         case 2:
            /* ENDPOINT */
            if (setup_ptr->VALUE != 0) {
               _usb_device_stall_endpoint(handle, 0, 0);
               return;
            } /* Endif */
            endpoint = setup_ptr->INDEX & USB_STATUS_ENDPOINT_NUMBER_MASK;
            _usb_device_get_status(handle, USB_STATUS_ENDPOINT | endpoint,
               &usb_status);
            /* unstall */
            _usb_device_set_status(handle, USB_STATUS_ENDPOINT | endpoint,
               0);
            break;
         default:
            _usb_device_stall_endpoint(handle, 0, 0);
            return;
      } /* Endswitch */
      
      /* status phase */
      _usb_device_send_data(handle, 0, 0, 0);
   } /* Endif */
   return;
} /* Endbody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : ch9SetFeature
* Returned Value : None
* Comments       :
*     Chapter 9 SetFeature command
* 
*END*--------------------------------------------------------------------*/
void ch9SetFeature
   (
      /* USB handle */
      void *handle,
      
      /* Is it a Setup phase? */
      smtBoolean setup,
            
      /* The setup packet pointer */
      SETUP_STRUCT_PTR setup_ptr
   )
{ /* Body */
   smtUint16           usb_status;
   smtUint8            endpoint;

   if (setup) {
      switch (setup_ptr->REQUESTTYPE) {

         case 0:
            /* DEVICE */
            switch (setup_ptr->VALUE) {
               case 1:
                  /* set remote wakeup */
                  _usb_device_get_status(handle, USB_STATUS_DEVICE, &usb_status);
                  usb_status |= USB_REMOTE_WAKEUP;
                  _usb_device_set_status(handle, USB_STATUS_DEVICE, usb_status);
                  break;
               case 2:
                  /* Test Mode */
                  if ((setup_ptr->INDEX & 0x00FF) || 
                     (speed != USB_SPEED_HIGH)) 
                  {
                     _usb_device_stall_endpoint(handle, 0, 0);
                     return;
                  } /* Endif */
                  _usb_device_get_status(handle, USB_STATUS_DEVICE_STATE, 
                     &usb_status);
                  if ((usb_status == USB_STATE_CONFIG) || 
                     (usb_status == USB_STATE_ADDRESS) || 
                     (usb_status == USB_STATE_DEFAULT)) 
                  {
                     ENTER_TEST_MODE = SMT_TRUE;
                     test_mode_index = (setup_ptr->INDEX & 0xFF00);
                  } else {
                     _usb_device_stall_endpoint(handle, 0, 0);
                     return;
                  } /* Endif */
                  break;
               default:
                  _usb_device_stall_endpoint(handle, 0, 0);
                  return;
            } /* Endswitch */
            break;
            
         case 2:
            /* ENDPOINT */
            if (setup_ptr->VALUE != 0) {
               _usb_device_stall_endpoint(handle, 0, 0);
               return;
            } /* Endif */
            endpoint = setup_ptr->INDEX & USB_STATUS_ENDPOINT_NUMBER_MASK;
            _usb_device_get_status(handle, USB_STATUS_ENDPOINT | endpoint,
               &usb_status);
            /* set stall */
            _usb_device_set_status(handle, USB_STATUS_ENDPOINT | endpoint,
               1);
            break;

         default:
            _usb_device_stall_endpoint(handle, 0, 0);
            return;
      } /* Endswitch */
      
      /* status phase */
      _usb_device_send_data(handle, 0, 0, 0);
   } else {
      if (ENTER_TEST_MODE) {
         /* Enter Test Mode */
         _usb_device_set_status(handle, USB_STATUS_TEST_MODE, 
            test_mode_index);
      } /* Endif */
   } /* Endif */
   return;
} /* Endbody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : ch9SetAddress
* Returned Value : None
* Comments       :
*     Chapter 9 SetAddress command
*     We setup a TX packet of 0 length ready for the IN token
*     Once we get the TOK_DNE interrupt for the IN token, then
*     we change the ADDR register and go to the ADDRESS state.
* 
*END*--------------------------------------------------------------------*/
void ch9SetAddress
   (
      /* USB handle */
      void *handle,
      
      /* Is it a Setup phase? */
      smtBoolean setup,
            
      /* The setup packet pointer */
      SETUP_STRUCT_PTR setup_ptr
   )
{ /* Body */
   static smtUint8  new_address;
   smtUint32        max_pkt_size;

   if (setup) {
      new_address = setup_ptr->VALUE;
      /*******************************************************
      if hardware assitance is enabled for set_address (see
      hardware rev for details) we need to do the set_address
      before queuing the status phase.
      *******************************************************/
      #ifdef SET_ADDRESS_HARDWARE_ASSISTANCE      
         _usb_device_set_status(handle, USB_STATUS_ADDRESS, new_address);
      #endif
      /* ack */
      _usb_device_send_data(handle, 0, 0, 0);
      
   } else {
      #ifndef SET_ADDRESS_HARDWARE_ASSISTANCE
         _usb_device_set_status(handle, USB_STATUS_ADDRESS, new_address);
      #endif
      
      _usb_device_set_status(handle, USB_STATUS_DEVICE_STATE,
         USB_STATE_ADDRESS);
         
      if (speed == USB_SPEED_HIGH) {
         max_pkt_size = EP1_HS_MAX_PACKET_SIZE;
	   } else {
         max_pkt_size = EP1_FS_MAX_PACKET_SIZE;
	   } /* Endif */
      
      _usb_device_init_endpoint(handle, 1, max_pkt_size,
			USB_RECV, USB_BULK_ENDPOINT, USB_DEVICE_DONT_ZERO_TERMINATE);
	   _usb_device_init_endpoint(handle, 1, max_pkt_size,
		   USB_SEND, USB_BULK_ENDPOINT, USB_DEVICE_DONT_ZERO_TERMINATE);
	
      if (_usb_device_get_transfer_status(handle, 1, USB_RECV) == USB_OK) {
         _usb_device_recv_data(handle, 1, ep1_buf, 31);
      } /* Endif */      
      
      TEST_ENABLED = SMT_TRUE;
   } /* Endif */
   return;
} /* Endbody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : ch9GetDescription
* Returned Value : None
* Comments       :
*     Chapter 9 GetDescription command
*     The Device Request can ask for Device/Config/string/interface/endpoint
*     descriptors (via wValue). We then post an IN response to return the
*     requested descriptor.
*     And then wait for the OUT which terminates the control transfer.
* 
*END*--------------------------------------------------------------------*/
void ch9GetDescription
   (
      /* USB handle */
      void *handle,
      
      /* Is it a Setup phase? */
      smtBoolean setup,
            
      /* The setup packet pointer */
      SETUP_STRUCT_PTR setup_ptr
   )
{ /* Body */
   smtUint32  max_pkt_size;
   
   if (setup) {
      /* Load the appropriate string depending on the descriptor requested.*/
      switch (setup_ptr->VALUE & 0xFF00) {

         case 0x0100:
            _usb_device_send_data(handle, 0, DevDesc,
               USB_MIN(setup_ptr->LENGTH, DEVICE_DESCRIPTOR_SIZE));
            break;

         case 0x0200:
	         /* Set the Max Packet Size in the config and other speed config */
            if(speed == USB_SPEED_HIGH) {
               max_pkt_size = EP1_HS_MAX_PACKET_SIZE;
            } else {
               max_pkt_size = EP1_FS_MAX_PACKET_SIZE;
            } /* Endif */

            *(ConfigDesc + CFG_DESC_EP1TX_MAX_PACKET_SIZE) = 
               USBUint16low(max_pkt_size);
            *(ConfigDesc +CFG_DESC_EP1TX_MAX_PACKET_SIZE+1) = 
               USBUint16high(max_pkt_size);
            *(ConfigDesc +CFG_DESC_EP1RX_MAX_PACKET_SIZE) = 
               USBUint16low(max_pkt_size);
            *(ConfigDesc +CFG_DESC_EP1RX_MAX_PACKET_SIZE+1) = 
               USBUint16high(max_pkt_size);

            _usb_device_send_data(handle, 0, ConfigDesc,
               USB_MIN(setup_ptr->LENGTH, CONFIG_DESC_SIZE));
            break;

         case 0x0300:
            if ((setup_ptr->VALUE & 0x00FF) > USB_STR_NUM) {
               _usb_device_send_data(handle, 0, (smtUint8 *)USB_STRING_DESC[USB_STR_NUM+1],
                  USB_MIN(setup_ptr->LENGTH, USB_STRING_DESC[USB_STR_NUM+1][0]));
            } else {
               _usb_device_send_data(handle, 0,
                  (smtUint8 *)USB_STRING_DESC[setup_ptr->VALUE & 0x00FF],
                  USB_MIN(setup_ptr->LENGTH,
                     USB_STRING_DESC[setup_ptr->VALUE & 0x00FF][0]));
            } /* Endif */      
            break;
            
         case 0x600:
            _usb_device_send_data(handle, 0, (smtUint8 *)DevQualifierDesc, 
               USB_MIN(setup_ptr->LENGTH, DEVICE_QUALIFIER_DESCRIPTOR_SIZE));
            break;
            
         case 0x700:
            if(speed == USB_SPEED_HIGH) {
               max_pkt_size = EP1_FS_MAX_PACKET_SIZE;
            } else {
               max_pkt_size = EP1_HS_MAX_PACKET_SIZE;
            } /* Endif */
            
            *(other_speed_config + CFG_DESC_EP1TX_MAX_PACKET_SIZE) = 
               USBUint16low(max_pkt_size);
            *(other_speed_config +CFG_DESC_EP1TX_MAX_PACKET_SIZE+1) = 
               USBUint16high(max_pkt_size);
            *(other_speed_config +CFG_DESC_EP1RX_MAX_PACKET_SIZE) = 
               USBUint16low(max_pkt_size);
            *(other_speed_config +CFG_DESC_EP1RX_MAX_PACKET_SIZE+1) = 
               USBUint16high(max_pkt_size);
            
            _usb_device_send_data(handle, 0, (smtUint8 *)other_speed_config, 
               USB_MIN(setup_ptr->LENGTH, OTHER_SPEED_CONFIG_DESC_SIZE));
               
            break;

         default:
            _usb_device_stall_endpoint(handle, 0, 0);
            return;
      } /* Endswitch */
      /* status phase */
      _usb_device_recv_data(handle, 0, 0, 0);
   } /* Endif */
   return;
} /* Endbody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : ch9SetDescription
* Returned Value : None
* Comments       :
*     Chapter 9 SetDescription command
* 
*END*--------------------------------------------------------------------*/
void ch9SetDescription
   (
      /* USB handle */
      void *handle,
      
      /* Is it a Setup phase? */
      smtBoolean setup,
            
      /* The setup packet pointer */
      SETUP_STRUCT_PTR setup_ptr
   )
{ /* Body */
   _usb_device_stall_endpoint(handle, 0, 0);
   return;
} /* Endbody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : ch9GetConfig
* Returned Value : None
* Comments       :
*     Chapter 9 GetConfig command
* 
*END*--------------------------------------------------------------------*/
void ch9GetConfig
   (
      /* USB handle */
      void *handle,
      
      /* Is it a Setup phase? */
      smtBoolean setup,
            
      /* The setup packet pointer */
      SETUP_STRUCT_PTR setup_ptr
   )
{ /* Body */
   smtUint16 current_config;
   /* Return the currently selected configuration */
   if (setup){ 
      _usb_device_get_status(handle, USB_STATUS_CURRENT_CONFIG,
         &current_config);
      *epTemp_buf = current_config;      
      _usb_device_send_data(handle, 0, epTemp_buf, sizeof(smtUint8));
      /* status phase */
      _usb_device_recv_data(handle, 0, 0, 0);
   } /* Endif */
   return;
} /* Endbody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : ch9SetConfig
* Returned Value : None
* Comments       :
*     Chapter 9 SetConfig command
* 
*END*--------------------------------------------------------------------*/
void ch9SetConfig
   (
      /* USB handle */
      void *handle,
      
      /* Is it a Setup phase? */
      smtBoolean setup,
            
      /* The setup packet pointer */
      SETUP_STRUCT_PTR setup_ptr
   )
{ /* Body */
   smtUint16 usb_state;
   
   if (setup) {
      if ((setup_ptr->VALUE & 0x00FF) > 1) {
         /* generate stall */
         _usb_device_stall_endpoint(handle, 0, 0);
         return;
      } /* Endif */
      /* 0 indicates return to unconfigured state */
      if ((setup_ptr->VALUE & 0x00FF) == 0) {
         _usb_device_get_status(handle, USB_STATUS_DEVICE_STATE, &usb_state);
         if ((usb_state == USB_STATE_CONFIG) || 
            (usb_state == USB_STATE_ADDRESS)) 
         {
            /* clear the currently selected config value */
            _usb_device_set_status(handle, USB_STATUS_CURRENT_CONFIG, 0);
            _usb_device_set_status(handle, USB_STATUS_DEVICE_STATE,
               USB_STATE_ADDRESS);
            /* status phase */      
            _usb_device_send_data(handle, 0, 0, 0);
         } else {
            _usb_device_stall_endpoint(handle, 0, 0);
         } /* Endif */
         return;
      } /* Endif */

      /*
      ** If the configuration value (setup_ptr->VALUE & 0x00FF) differs
      ** from the current configuration value, then endpoints must be
      ** reconfigured to match the new device configuration
      */
      _usb_device_get_status(handle, USB_STATUS_CURRENT_CONFIG,
         &usb_state);
      if (usb_state != (setup_ptr->VALUE & 0x00FF)) {
         /* Reconfigure endpoints here */
         switch (setup_ptr->VALUE & 0x00FF) {
      
            default:
               break;
         } /* Endswitch */
         _usb_device_set_status(handle, USB_STATUS_CURRENT_CONFIG,
            setup_ptr->VALUE & 0x00FF);
         _usb_device_set_status(handle, USB_STATUS_DEVICE_STATE,
            USB_STATE_CONFIG);      
         /* status phase */      
         _usb_device_send_data(handle, 0, 0, 0);
         return;
      } /* Endif */
      _usb_device_set_status(handle, USB_STATUS_DEVICE_STATE,
         USB_STATE_CONFIG);
      /* status phase */
      _usb_device_send_data(handle, 0, 0, 0);
   } /* Endif */
   return;
} /* Endbody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : ch9GetInterface
* Returned Value : None
* Comments       :
*     Chapter 9 GetInterface command
* 
*END*--------------------------------------------------------------------*/
void ch9GetInterface
   (
      /* USB handle */
      void *handle,
      
      /* Is it a Setup phase? */
      smtBoolean setup,
            
      /* The setup packet pointer */
      SETUP_STRUCT_PTR setup_ptr
   )
{ /* Body */
   smtUint16 usb_state;
   
   _usb_device_get_status(handle, USB_STATUS_DEVICE_STATE, &usb_state);
   if (usb_state != USB_STATE_CONFIG) {
      _usb_device_stall_endpoint(handle, 0, 0);
      return;
   } /* Endif */

   if (setup) {
      _usb_device_send_data(handle, 0, &USB_IF_ALT[setup_ptr->INDEX & 0x00FF],
         USB_MIN(setup_ptr->LENGTH, sizeof(smtUint8)));
      /* status phase */      
      _usb_device_recv_data(handle, 0, 0, 0);
   } /* Endif */
   return;
} /* Endbody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : ch9SetInterface
* Returned Value : None
* Comments       :
*     Chapter 9 SetInterface command
* 
*END*--------------------------------------------------------------------*/
void ch9SetInterface
   (
      /* USB handle */
      void *handle,
      
      /* Is it a Setup phase? */
      smtBoolean setup,
            
      /* The setup packet pointer */
      SETUP_STRUCT_PTR setup_ptr
   )
{ /* Body */
   if (setup) {
      if (setup_ptr->REQUESTTYPE != 0x01) {
         _usb_device_stall_endpoint(handle, 0, 0);
         return;
      } /* Endif */

      /*
      ** If the alternate value (setup_ptr->VALUE & 0x00FF) differs
      ** from the current alternate value for the specified interface,
      ** then endpoints must be reconfigured to match the new alternate
      */
      if (USB_IF_ALT[setup_ptr->INDEX & 0x00FF]
         != (setup_ptr->VALUE & 0x00FF))
      {
         USB_IF_ALT[setup_ptr->INDEX & 0x00FF] = (setup_ptr->VALUE & 0x00FF);
         /* Reconfigure endpoints here. */
         
      } /* Endif */

      /* status phase */
      _usb_device_send_data(handle, 0, 0, 0);
   } /* Endif */
   return;
} /* Endbody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : ch9SynchFrame
* Returned Value : 
* Comments       :
*     Chapter 9 SynchFrame command
* 
*END*--------------------------------------------------------------------*/
void ch9SynchFrame
   (
      /* USB handle */
      void *handle,
      
      /* Is it a Setup phase? */
      smtBoolean setup,
            
      /* The setup packet pointer */
      SETUP_STRUCT_PTR setup_ptr
   )
{ /* Body */
   
   if (setup) {
      if (setup_ptr->REQUESTTYPE != 0x02) {
         _usb_device_stall_endpoint(handle, 0, 0);
         return;
      } /* Endif */

      if ((setup_ptr->INDEX & 0x00FF) >=
         ConfigDesc[CONFIG_DESC_NUM_INTERFACES])
      {
         _usb_device_stall_endpoint(handle, 0, 0);
         return;
      } /* Endif */

      _usb_device_get_status(handle, USB_STATUS_SOF_COUNT, (smtUint16 *)epTemp_buf);
      _usb_device_send_data(handle, 0, epTemp_buf,
         USB_MIN(setup_ptr->LENGTH, sizeof(smtUint16)));
      /* status phase */      
      _usb_device_recv_data(handle, 0, 0, 0);
   } /* Endif */
   return;
} /* Endbody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : ch9Class
* Returned Value : 
* Comments       :
*     Chapter 9 Class specific request
*     See section 9.4.11 (page 195) of the USB 1.1 Specification.
* 
*END*--------------------------------------------------------------------*/
void ch9Class
   (
      void *handle,
      smtBoolean setup,
      smtUint8  direction,
      SETUP_STRUCT_PTR setup_ptr
   )
{ /* Body */
   
   if (setup) {
      switch (setup_ptr->REQUEST) {
         case 0xFF:
            /* Bulk-Only Mass Storage Reset: Ready the device for the next 
            ** CBW from the host 
            */
            if ((setup_ptr->VALUE != 0) || 
                (setup_ptr->INDEX != MASS_STORAGE_INTERFACE) ||
                (setup_ptr->LENGTH != 0)) {
                _usb_device_stall_endpoint(handle, 0, 0);
            } else { /* Body */
               CBW_PROCESSED = SMT_FALSE;
               ZERO_TERMINATE = SMT_FALSE;
               _usb_device_cancel_transfer(handle, 1, USB_RECV);
               _usb_device_cancel_transfer(handle, 1, USB_SEND);
               
               /* unstall bulk endpoint */
               _usb_device_unstall_endpoint(handle, 1, 0);
               _usb_device_unstall_endpoint(handle, 1, 1);
               /* 
               _usb_device_set_status(handle, USB_STATUS_ENDPOINT | 1, 0); */
               
               _usb_device_recv_data(handle, 1, ep1_buf, 31);
               /* send zero packet to control pipe */
               _usb_device_send_data(handle, 0, 0, 0);
            } /* Endbody */
            return;
         case 0xFE:
            /* For Get Max LUN use any of these responses*/
            if (setup_ptr->LENGTH == 0) { /* Body */
               _usb_device_stall_endpoint(handle, 0, 0);
            } else if ((setup_ptr->VALUE != 0) ||
                (setup_ptr->INDEX != MASS_STORAGE_INTERFACE) ||
                (setup_ptr->LENGTH != 1)) { /* Body */
                _usb_device_stall_endpoint(handle, 0, 0);
             } else { /* Body */
               /* Send Max LUN = 0 to the the control pipe */
               *epTemp_buf = 0;
               _usb_device_send_data(handle, 0, epTemp_buf, 1);
                 /* status phase */
               _usb_device_recv_data(handle, 0, 0, 0);
               
             } /* Endbody */     
            return;
         default :
            _usb_device_stall_endpoint(handle, 0, 0);
            return;
      } /* EndSwitch */
   } 

} /* Endbody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : service_ep0
* Returned Value : None
* Comments       :
*     Called upon a completed endpoint 0 (USB 1.1 Chapter 9) transfer
* 
*END*--------------------------------------------------------------------*/
void service_ep0
   (
      /* [IN] Handle of the USB device */
      void *handle,
      
      /* [IN] Is it a setup packet? */
      smtBoolean              setup,
      
      /* [IN] Direction of the transfer.  Is it transmit? */
      smtUint8               direction,
      
      /* [IN] Pointer to the data buffer */
      smtUint8		         *buffer,
      
      /* [IN] Length of the transfer */
      smtUint32              length,
      
      /* [IN] Error, if any */
      smtUint8               error
            
   )
{ /* Body */
   
   if (setup) {
      _usb_device_read_setup_data(handle, 0, (smtUint8 *)&local_setup_packet);
   }
   
   switch (local_setup_packet.REQUESTTYPE & 0x60) {

      case 0x00:
         switch (local_setup_packet.REQUEST) {

            case 0x0:
               ch9GetStatus(handle, setup, &local_setup_packet);
               break;

            case 0x1:
               ch9ClearFeature(handle, setup, &local_setup_packet);
               break;

            case 0x3:
               ch9SetFeature(handle, setup, &local_setup_packet);
               break;

            case 0x5:
               ch9SetAddress(handle, setup, &local_setup_packet);
               break;

            case 0x6:
               ch9GetDescription(handle, setup, &local_setup_packet);
               break;

            case 0x7:
               ch9SetDescription(handle, setup, &local_setup_packet);
               break;

            case 0x8:
               ch9GetConfig(handle, setup, &local_setup_packet);
               break;

            case 0x9:
               ch9SetConfig(handle, setup, &local_setup_packet);
               break;

            case 0xa:
               ch9GetInterface(handle, setup, &local_setup_packet);
               break;

            case 0xb:
               ch9SetInterface(handle, setup, &local_setup_packet);
               break;

            case 0xc:
               ch9SynchFrame(handle, setup, &local_setup_packet);
               break;

            default:
               _usb_device_stall_endpoint(handle, 0, 0);
               break;

         } /* Endswitch */
         
         break;

      case 0x20:
         /* class specific request */
         ch9Class(handle, setup, direction, &local_setup_packet);
         return;

      case 0x40:
         /* vendor specific request can be handled here*/
         _usb_device_stall_endpoint(handle, 0, 0);
         break;
      
      default:
         _usb_device_stall_endpoint(handle, 0, 0);
         break;
         
   } /* Endswitch */
   
   return;
} /* Endbody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : _process_inquiry_command
* Returned Value : None
* Comments       :
*     Process a Mass storage class Inquiry command
* 
*END*--------------------------------------------------------------------*/
void _process_inquiry_command
   (
      /* [IN] Handle of the USB device */
      void *handle,
            
      /* [IN] Endpoint number */
      smtUint8               ep_num,
      
      /* [IN] Pointer to the data buffer */
      CBW_STRUCT_PTR       cbw_ptr
   )
{ /* Body */
   MASS_STORAGE_INQUIRY_PTR   inquiry_cmd_ptr = 
      (MASS_STORAGE_INQUIRY_PTR)((void *)cbw_ptr->CBWCB);

   if (cbw_ptr->DCBWDATALENGTH) {
      if (cbw_ptr->BMCBWFLAGS & USB_CBW_DIRECTION_BIT) {      
         /* Send the device information */
         _usb_device_send_data(handle, 1, (smtUint8 *)&device_information_data, 
            36);
      } /* Endif */
   } /* Endif */
   
   /* The actual length will never exceed the DCBWDATALENGTH */            
   csw.DCSWDATARESIDUE = (cbw_ptr->DCBWDATALENGTH - 36);
   csw.BCSWSTATUS = 0;
   
} /* EndBody */


/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : _process_unsupported_command
* Returned Value : None
* Comments       :
*     Responds appropriately to unsupported commands
* 
*END*--------------------------------------------------------------------*/
void _process_unsupported_command
   (
      /* [IN] Handle of the USB device */
      void *handle,
            
      /* [IN] Endpoint number */
      smtUint8               ep_num,
      
      /* [IN] Pointer to the data buffer */
      CBW_STRUCT_PTR       cbw_ptr
   )
{ /* Body */
   
   /* The actual length will never exceed the DCBWDATALENGTH */
   csw.DCSWDATARESIDUE = 0;
   csw.BCSWSTATUS = 0;

   if (cbw_ptr->BMCBWFLAGS & USB_CBW_DIRECTION_BIT) {      
      /* Send a zero-length packet */
      _usb_device_send_data(handle, ep_num, 
         (smtUint8 *)&device_information_data, 0);
   } else {
      CBW_PROCESSED = SMT_FALSE;
      /* Send the command status information */
      _usb_device_send_data(handle, 1, (smtUint8 *)&csw, 13);
      _usb_device_recv_data(handle, 1, ep1_buf, 31);
   } /* Endif */
   
} /* EndBody */


void _process_stall_command
   (
      /* [IN] Handle of the USB device */
      void *handle,
            
      /* [IN] Endpoint number */
      smtUint8               ep_num,
      
      /* [IN] Pointer to the data buffer */
      CBW_STRUCT_PTR       cbw_ptr
   )
{ /* Body */

   volatile wait;
   
   /* The actual length will never exceed the DCBWDATALENGTH */
   csw.DCSWDATARESIDUE = cbw_ptr->DCBWDATALENGTH;
   csw.BCSWSTATUS = 1;

   _usb_device_stall_endpoint(handle, 1, USB_SEND);
   for(wait=0;wait<50;wait++);

   _usb_device_unstall_endpoint(handle, 1, USB_SEND);   	
   for(wait=0;wait<50;wait++);

   /* Send the command status information */
   _usb_device_send_data(handle, 1, (smtUint8 *)&csw, 13);        

} /* Endif */


void _process_request_sense_command
   (
      /* [IN] Handle of the USB device */
      void *handle,
            
      /* [IN] Endpoint number */
      smtUint8               ep_num,
      
      /* [IN] Pointer to the data buffer */
      CBW_STRUCT_PTR       cbw_ptr
   )
{ /* Body */

   smtUint8 request_sense_data[] = {
   	0x70, 
	0x00, 
	0x02, 
	0x00, 0x00, 0x00, 0x00, 
	0x0A, 
	0x00, 0x00, 0x00, 0x00, 
	0x3A, 0x00,  /* MEDIUM NOT PRESENT */
	0x00, 0x00, 0x0, 0x00
   };


   if(CARD_DETECT  == CARD_INSERTED)
   {
	if(CARD_OK==SMT_FALSE)
	{
	       request_sense_data[2]  = 0x06;
	       request_sense_data[12] = 0x28;
	       request_sense_data[13] = 0x00;
	       CARD_OK = SMT_TRUE;			
	}
	else
	{
		request_sense_data[2]  = 0x02;
		request_sense_data[12] = 0x3A;
		request_sense_data[13] = 0x00;
	}		
   }
   else
   {
	request_sense_data[2]  = 0x02;
	request_sense_data[12] = 0x3A;
	request_sense_data[13] = 0x00;
   }

   if (cbw_ptr->DCBWDATALENGTH) {
      if (cbw_ptr->BMCBWFLAGS & USB_CBW_DIRECTION_BIT) {      
         /* Send the device information */
         _usb_device_send_data(handle, 1, request_sense_data, 18);
      } /* Endif */
   } /* Endif */
   
   /* The actual length will never exceed the DCBWDATALENGTH */            
   csw.DCSWDATARESIDUE = (cbw_ptr->DCBWDATALENGTH - 18);
   csw.BCSWSTATUS = 0;
   
} /* EndBody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : _process_report_capacity
* Returned Value : None
* Comments       :
*     Reports the media capacity as a response to READ CAPACITY Command.
* 
*END*--------------------------------------------------------------------*/
void _process_report_capacity
   (
      /* [IN] Handle of the USB device */
      void *handle,
            
      /* [IN] Endpoint number */
      smtUint8               ep_num,
      
      /* [IN] Pointer to the data buffer */
      CBW_STRUCT_PTR       cbw_ptr
   )
{ /* Body */

   smtUint32 capacity;

   if(CARD_DETECT==CARD_INSERTED)
   {
	capacity = mmc_decode_csd();
	
	capacity = capacity/512;
	capacity = capacity - 1;

	read_capacity.LAST_LOGICAL_BLOCK_ADDRESS[0] = USBUint16high(USBUint32high((capacity)));
	read_capacity.LAST_LOGICAL_BLOCK_ADDRESS[1] = USBUint16low (USBUint32high((capacity)));
	read_capacity.LAST_LOGICAL_BLOCK_ADDRESS[2] = USBUint16high(USBUint32low ((capacity)));
	read_capacity.LAST_LOGICAL_BLOCK_ADDRESS[3] = USBUint16low (USBUint32low ((capacity))); 		
   }

   if (cbw_ptr->BMCBWFLAGS & USB_CBW_DIRECTION_BIT) {      
      /* Send a zero-length packet */
         _usb_device_send_data(handle, ep_num, (smtUint8 *)&read_capacity, 8);
      
   } /* Endif */
   
   if(CARD_DETECT==CARD_INSERTED)
	csw.BCSWSTATUS = 0;
   else
   	csw.BCSWSTATUS = 1;
   
} /* EndBody */



////////////////////////////////////////////////////////////////////////////////
void _process_read_format_capacity
   (
      /* [IN] Handle of the USB device */
      void *handle,
            
      /* [IN] Endpoint number */
      smtUint8               ep_num,
      
      /* [IN] Pointer to the data buffer */
      CBW_STRUCT_PTR       cbw_ptr
   )
{ /* Body */	
	smtUint32 capacity;
	smtUint8 Rfc[] = {
	0x00, 0x00, 0x00, 0x08,
	0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00
	};

	if(CARD_DETECT==CARD_INSERTED)
	{
	   	capacity = mmc_decode_csd();

		capacity = capacity/512;
		capacity = capacity - 1;
	
		// Number of blocks
		Rfc[4] = USBUint16high(USBUint32high((capacity)));
		Rfc[5] = USBUint16low (USBUint32high((capacity)));
		Rfc[6] = USBUint16high(USBUint32low ((capacity)));
		Rfc[7] = USBUint16low (USBUint32low ((capacity))); 		

		// Descriptor Type
		Rfc[8] = 0x02;	// Formatted media
		
		// Block Size
		Rfc[9 ] = (smtUint8)((512 & 0x00ff0000) >> 16);
		Rfc[10] = (smtUint8)((512 & 0x0000ff00) >> 8);
		Rfc[11] = (smtUint8)(512 & 0x000000ff);

		CARD_OK = SMT_TRUE;
		
	}	
	
   if (cbw_ptr->BMCBWFLAGS & USB_CBW_DIRECTION_BIT) {      
      /* Send a zero-length packet */
         _usb_device_send_data(handle, ep_num, Rfc, 12);
      
   } /* Endif */
   
   /* The actual length will never exceed the DCBWDATALENGTH */            
    csw.DCSWDATARESIDUE = (cbw_ptr->DCBWDATALENGTH - 12);

   if(CARD_DETECT==CARD_INSERTED)
	csw.BCSWSTATUS = 0;
   else
   	csw.BCSWSTATUS = 1;
   	
}



/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : _process_read_command
* Returned Value : None
* Comments       :
*     Sends data as a response to READ Command.
* 
*END*--------------------------------------------------------------------*/
void _process_read_command
   (
      /* [IN] Handle of the USB device */
      void *handle,
            
      /* [IN] Endpoint number */
      smtUint8               ep_num,
      
      /* [IN] Pointer to the data buffer */
      CBW_STRUCT_PTR       cbw_ptr
   )
{ /* Body */
   smtUint32 index1 = 0, index2 = 0;
   smtUint32 max_pkt_size;
   smtUint32 loopCnt, mSector;

   if (cbw_ptr->BMCBWFLAGS & USB_CBW_DIRECTION_BIT) {      
      /* Send a zero-length packet */

      index1  = ((smtUint32)cbw_ptr->CBWCB[2] << 24);
      index1  |= ((smtUint32)cbw_ptr->CBWCB[3] << 16);
      index1  |= ((smtUint32)cbw_ptr->CBWCB[4] << 8);
      index1  |= cbw_ptr->CBWCB[5];

      index2 = ((smtUint32)cbw_ptr->CBWCB[7] << 8);
      index2 |= (smtUint32)cbw_ptr->CBWCB[8];
      
      /*
      loopCnt = index2;
      mSector = index1;
      */
      loopCnt = index1;
      mSector = index2;
      
      index2 *= LENGTH_OF_EACH_LAB;
      
      if (cbw_ptr->DCBWDATALENGTH == 0) { /* Body */
         csw.DCSWDATARESIDUE = 0;
         csw.BCSWSTATUS = 2;
         CBW_PROCESSED = SMT_FALSE;
         /* Send the command status information */
         _usb_device_send_data(handle, ep_num, (smtUint8 *)&csw, 13);
         _usb_device_recv_data(handle, ep_num, ep1_buf, 31);
         return;
      } else { /* Body */
         csw.DCSWDATARESIDUE = 0;
         csw.BCSWSTATUS = 0;         
         if (index2 > cbw_ptr->DCBWDATALENGTH) { /* Body */
            index2 = cbw_ptr->DCBWDATALENGTH;
            csw.DCSWDATARESIDUE = cbw_ptr->DCBWDATALENGTH;
            csw.BCSWSTATUS = 2;
         } else if (index2 < cbw_ptr->DCBWDATALENGTH) { /* Body */
            csw.DCSWDATARESIDUE = cbw_ptr->DCBWDATALENGTH - index2;
            if (index2 > 0) { /* Body */
               if (speed == USB_SPEED_HIGH) {
                  max_pkt_size = EP1_HS_MAX_PACKET_SIZE;
	            } else {
                  max_pkt_size = EP1_FS_MAX_PACKET_SIZE;
	            }
               if (index2%max_pkt_size == 0) { /* Body */
                  /* Need send a zero terminate packet to host */
                  ZERO_TERMINATE = SMT_TRUE;
               } /* Endbody */
            } /* Endbody */  
         } /* Endbody */

     	  DeviceReadSectors(0, loopCnt, mSector, ep_mass_buf, 0);
         _usb_device_send_data(handle, ep_num, ep_mass_buf, index2);
      } /* Endbody */
   } else { /* Body */
      /* Incorrect but valid CBW */
      if (cbw_ptr->DCBWDATALENGTH > BUFFERSIZE)
         index2 = BUFFERSIZE;
      else
         index2 = cbw_ptr->DCBWDATALENGTH;
      csw.DCSWDATARESIDUE = cbw_ptr->DCBWDATALENGTH;
      csw.BCSWSTATUS = 2;
       _usb_device_recv_data(handle, ep_num, ep1_buf, index2);   
   } /* Endbody */
} /* EndBody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : _process_write_command
* Returned Value : None
* Comments       :
*     Sends data as a response to WRITE Command.
* 
*END*--------------------------------------------------------------------*/
void _process_write_command
   (
      /* [IN] Handle of the USB device */
      void *handle,
            
      /* [IN] Endpoint number */
      smtUint8               ep_num,
      
      /* [IN] Pointer to the data buffer */
      CBW_STRUCT_PTR       cbw_ptr
   )
{ /* Body */
   smtUint32 index1 = 0, index2 = 0;

   if (!(cbw_ptr->BMCBWFLAGS & USB_CBW_DIRECTION_BIT)) {

      index1  = ((smtUint32)cbw_ptr->CBWCB[2] << 24);
      index1  |= ((smtUint32)cbw_ptr->CBWCB[3] << 16);
      index1  |= ((smtUint32)cbw_ptr->CBWCB[4] << 8);
      index1  |= cbw_ptr->CBWCB[5];

      index2 = ((smtUint32)cbw_ptr->CBWCB[7] << 8);
      index2 |= (smtUint32)cbw_ptr->CBWCB[8];
      
	  write_address = index1;
	  write_length  = index2;

      
      if (cbw_ptr->DCBWDATALENGTH == 0) { /* Body */
         /* Zero transfer length */
         csw.DCSWDATARESIDUE = 0;
         csw.BCSWSTATUS = 2;
         CBW_PROCESSED = SMT_FALSE;
         /* Send the command status information */
         _usb_device_send_data(handle, ep_num, (smtUint8 *)&csw, 13);
         _usb_device_recv_data(handle, ep_num, ep1_buf, 31);
         return;
      } else { /* Body */
         csw.DCSWDATARESIDUE = 0;
         csw.BCSWSTATUS = 0;
         index2 *= LENGTH_OF_EACH_LAB;
         
         if (index2 < cbw_ptr->DCBWDATALENGTH) { /* Body */
            /* The actual length will never exceed the DCBWDATALENGTH */
            csw.DCSWDATARESIDUE = cbw_ptr->DCBWDATALENGTH - index2;
            index2 = cbw_ptr->DCBWDATALENGTH;
         } else if (index2 > cbw_ptr->DCBWDATALENGTH) { /* Body */
            csw.DCSWDATARESIDUE = cbw_ptr->DCBWDATALENGTH;
            csw.BCSWSTATUS = 2;
            index2 = cbw_ptr->DCBWDATALENGTH;
         } /* Endbody */
            
         if (_usb_device_get_transfer_status(handle, ep_num, USB_RECV) != USB_OK) {
            _usb_device_cancel_transfer(handle, ep_num, USB_RECV);
         } /* Endif */
	 
         _usb_device_recv_data(handle, ep_num, ep_mass_buf, index2);
	  write_flag = SMT_TRUE;
      }
   } else { /* Body */
      /* Incorrect but valid CBW */
      csw.DCSWDATARESIDUE = cbw_ptr->DCBWDATALENGTH;
      csw.BCSWSTATUS = 2;
      _usb_device_send_data(handle, ep_num, 0, 0);
      return;
   } /* Endbody */
   
} /* EndBody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : _process_test_unit_ready
* Returned Value : None
* Comments       :
*     Responds appropriately to unit ready query
* 
*END*--------------------------------------------------------------------*/
void _process_test_unit_ready
   (
      /* [IN] Handle of the USB device */
      void *handle,
            
      /* [IN] Endpoint number */
      smtUint8               ep_num,
      
      /* [IN] Pointer to the data buffer */
      CBW_STRUCT_PTR       cbw_ptr
   )
{ /* Body */
   smtUint32 BufSize;

   if(CARD_OK != SMT_TRUE)
   {
      csw.DCSWDATARESIDUE = cbw_ptr->DCBWDATALENGTH;
      csw.BCSWSTATUS = 1;

      CBW_PROCESSED = SMT_FALSE;
      /* Send the command status information */
      _usb_device_send_data(handle, 1, (smtUint8 *)&csw, 13);
      _usb_device_recv_data(handle, 1, ep1_buf, 31);	  
      return;
   }
   
   if ((cbw_ptr->BMCBWFLAGS & USB_CBW_DIRECTION_BIT) ||
       (cbw_ptr->DCBWDATALENGTH == 0)) {
      /* The actual length will never exceed the DCBWDATALENGTH */
      csw.DCSWDATARESIDUE = 0;
      csw.BCSWSTATUS = 0;
   
      CBW_PROCESSED = SMT_FALSE;
      /* Send the command status information */
      _usb_device_send_data(handle, 1, (smtUint8 *)&csw, 13);
      _usb_device_recv_data(handle, 1, ep1_buf, 31);
   } else { /* Body */
      /* Incorrect but valid CBW */
      if (cbw_ptr->DCBWDATALENGTH > BUFFERSIZE)
         BufSize = BUFFERSIZE;
      else
         BufSize = cbw_ptr->DCBWDATALENGTH;
      csw.DCSWDATARESIDUE = cbw_ptr->DCBWDATALENGTH;
      csw.BCSWSTATUS = 1;
      _usb_device_recv_data(handle, ep_num, ep1_buf, BufSize);
   } /* Endbody */
   
} /* EndBody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : _process_prevent_allow_medium_removal
* Returned Value : None
* Comments       :
*     Responds appropriately to unit ready query
* 
*END*--------------------------------------------------------------------*/
void _process_prevent_allow_medium_removal
   (
      /* [IN] Handle of the USB device */
      void *handle,
            
      /* [IN] Endpoint number */
      smtUint8               ep_num,
      
      /* [IN] Pointer to the data buffer */
      CBW_STRUCT_PTR       cbw_ptr
   )
{ /* Body */

   /* The actual length will never exceed the DCBWDATALENGTH */
   if(CARD_OK==SMT_FALSE)
	csw.BCSWSTATUS = 1;
   else
   	csw.BCSWSTATUS = 0;

   csw.DCSWDATARESIDUE = 0;	  
   CBW_PROCESSED = SMT_FALSE;
   
   /* Send the command status information */
   _usb_device_send_data(handle, 1, (smtUint8 *)&csw, 13);

   _usb_device_recv_data(handle, 1, ep1_buf, 31);
   
} /* EndBody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : _process_mode_sense6_command
* Returned Value : None
* Comments       :
*     
* 
*END*--------------------------------------------------------------------*/
void _process_mode_sense6_command
   (
      /* [IN] Handle of the USB device */
      void *handle,
            
      /* [IN] Endpoint number */
      smtUint8               ep_num,
      
      /* [IN] Pointer to the data buffer */
      CBW_STRUCT_PTR       cbw_ptr
   )
{ /* Body */
   // write protected : default LOCK
   smtUint32 reg;
   smtUint8 mode_sense6[4] = 
   	{0x3, 0x00, 0x00, 0x00};

   reg = SMT_READ(GPIO0_IN);
   reg = reg>>30;
   
   if(reg&0x01)
   {
      mode_sense6[2] = 0x80; //lock
   }   
   if (cbw_ptr->BMCBWFLAGS & USB_CBW_DIRECTION_BIT) {      
      /* Send a zero-length packet */
         _usb_device_send_data(handle, ep_num, mode_sense6, 4);
      
   } /* Endif */
   
   /* The actual length will never exceed the DCBWDATALENGTH */            
    csw.DCSWDATARESIDUE = (cbw_ptr->DCBWDATALENGTH - 4);   
} /* EndBody */
/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : _process_mass_storage_command
* Returned Value : None
* Comments       :
*     Process a Mass storage class command
* 
*END*--------------------------------------------------------------------*/
void _process_mass_storage_command
   (
      /* [IN] Handle of the USB device */
      void *handle,
            
      /* [IN] Endpoint number */
      smtUint8               ep_num,
      
      /* [IN] Pointer to the data buffer */
      CBW_STRUCT_PTR       cbw_ptr
   )
{ /* Body */

   if(write_flag==SMT_TRUE)
   {		
	   DeviceWriteSectors(0, write_address, write_length, ep_mass_buf, 0);	/* 0-DMA */   
       write_flag = SMT_FALSE;
   }      
        
   switch (cbw_ptr->CBWCB[0]) {
      case 0x00: /* Request the device to report if it is ready */         
         	_process_test_unit_ready(handle, ep_num, cbw_ptr);
         break;
      case 0x12: /* Inquity command. Get device information */

         _process_inquiry_command(handle, ep_num, cbw_ptr);
         break;
      case 0x1A:
         _process_mode_sense6_command(handle, ep_num, cbw_ptr);
         break;
      case 0x1E: /* Prevent or allow the removal of media from a removable 
                 ** media device 
                 */
         _process_prevent_allow_medium_removal(handle, ep_num, cbw_ptr);
         break;
      case 0x23: /* Read Format Capacities. Report current media capacity and 
                 ** formattable capacities supported by media 
                 */
      	_process_read_format_capacity(handle, ep_num, cbw_ptr);
        break;
      case 0x25: /* Report current media capacity */
	_process_report_capacity(handle, ep_num, cbw_ptr);
         break;

      case 0x28: /* Read (10) Transfer binary data from media to the host */        
        if(CARD_DETECT==CARD_INSERTED)
        {
         	 _process_read_command(handle, ep_num, cbw_ptr);
        }
	 else
	 {
         	_process_stall_command(handle, ep_num, cbw_ptr);
	 }
        break;
      case 0x2A: /* Write (10) Transfer binary data from the host to the 
                 ** media 
                 */
        if(CARD_DETECT==CARD_INSERTED)
        {
	         _process_write_command(handle, ep_num, cbw_ptr);
        }
	 else
	 {
         	_process_stall_command(handle, ep_num, cbw_ptr);
	 }

         break;

      case 0x03: /* Transfer status sense data to the host */
  	 _process_request_sense_command(handle, ep_num, cbw_ptr);
	 break;

      case 0x01: /* Position a head of the drive to zero track */
      case 0x04: /* Format unformatted media */
      case 0x1B: /* Request a request a removable-media device to load or 
                 ** unload its media 
                 */
      case 0x1D: /* Perform a hard reset and execute diagnostics */
      case 0x2B: /* Seek the device to a specified address */
      case 0x2E: /* Transfer binary data from the host to the media and 
                 ** verify data 
                 */
      case 0x2F: /* Verify data on the media */
      case 0x55: /* Allow the host to set parameters in a peripheral */
      case 0x5A: /* Report parameters to the host */
      case 0xA8: /* Read (12) Transfer binary data from the media to the host */
      case 0xAA: /* Write (12) Transfer binary data from the host to the 
                 ** media 
                 */
      default:
       _process_unsupported_command(handle, ep_num, cbw_ptr);
         break;
   } /* Endswitch */

} /* EndBody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : service_ep1
* Returned Value : None
* Comments       :
*     Called upon a completed endpoint 1 (USB 1.1 Chapter 9) transfer
* 
*END*--------------------------------------------------------------------*/
void service_ep1
   (
      /* [IN] Handle of the USB device */
      void *handle,
      
      /* [IN] Is it a setup packet? */
      smtBoolean              setup,
      
      /* [IN] Direction of the transfer.  Is it transmit? */
      smtUint8               direction,
      
      /* [IN] Pointer to the data buffer */
      smtUint8	             *buffer,
      
      /* [IN] Length of the transfer */
      smtUint32              length,

      /* [IN] Error, if any */
      smtUint8               error
            
   )
{ /* Body */
   CBW_STRUCT_PTR cbw_ptr;     

   if ((!direction) && (!CBW_PROCESSED)) {
      cbw_ptr = (CBW_STRUCT_PTR)((void *)buffer);
   } /* Endif */

   if ((!direction) && (!CBW_PROCESSED) && (length == 31) && 
      (cbw_ptr->DCBWSIGNATURE == USB_DCBWSIGNATURE)) 
   {
      /* A valid CBW was received */
      csw.DCSWSIGNATURE = USB_DCSWSIGNATURE;
      csw.DCSWTAG = cbw_ptr->DCBWTAG;
      CBW_PROCESSED = SMT_TRUE;
      /* Process the command */
      _process_mass_storage_command(handle, 1, cbw_ptr);
   } else {
      /* If a CBW was processed then send the status information and 
      ** queue another cbw receive request, else just queue another CBW receive
      ** request if we received an invalid CBW 
      */
      if (CBW_PROCESSED) {
         if (ZERO_TERMINATE) { /* Body */
            ZERO_TERMINATE = SMT_FALSE;
            _usb_device_send_data(handle, 1, 0, 0);
         } else { /* Body */
            CBW_PROCESSED = SMT_FALSE;
            /* Send the command status information */
            _usb_device_send_data(handle, 1, (smtUint8 *)&csw, 13);        
            _usb_device_recv_data(handle, 1, ep1_buf, 31);
         }
      } else if (!direction) {
         _usb_device_stall_endpoint(handle, 1, 0);
         _usb_device_stall_endpoint(handle, 1, 1);

         /* Invalid CBW received. Queue another receive buffer */
         _usb_device_recv_data(handle, 1, ep1_buf, 31);  
      } /* Endif */
   } /* Endif */
   
   return;
} /* Endbody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : service_speed
* Returned Value : None
* Comments       :
*     Called upon a speed detection event.
* 
*END*--------------------------------------------------------------------*/
void service_speed
   (
      /* [IN] Handle of the USB device */
      void *handle,
   
      /* [IN] Unused */
      smtBoolean              setup,
   
      /* [IN] Unused */
      smtUint8               direction,
   
      /* [IN] Unused */
      smtUint8		         *buffer,
   
      /* [IN] Unused */
      smtUint32              length,

      /* [IN] Error, if any */
      smtUint8               error
            
   )
{ /* EndBody */
   speed = length;
   return;
} /* EndBody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : reset_ep0
* Returned Value : None
* Comments       :
*     Called upon a bus reset event.  Initialises the control endpoint.
* 
*END*--------------------------------------------------------------------*/
void reset_ep0
   (
      /* [IN] Handle of the USB device */
      void *handle,
   
      /* [IN] Unused */
      smtBoolean              setup,
   
      /* [IN] Unused */
      smtUint8               direction,
   
      /* [IN] Unused */
      smtUint8		         *buffer,
   
      /* [IN] Unused */
      smtUint32              length,

      /* [IN] Error, if any */
      smtUint8               error
            
   )
{ /* Body */

   /* on a reset always ensure all transfers are cancelled on control EP*/
   _usb_device_cancel_transfer(handle, 0, USB_RECV);
   _usb_device_cancel_transfer(handle, 0, USB_SEND);

   
   /* Initialize the endpoint 0 in both directions */
   _usb_device_init_endpoint(handle, 0, DevDesc[DEV_DESC_MAX_PACKET_SIZE], 
      USB_RECV, USB_CONTROL_ENDPOINT, 0);
   _usb_device_init_endpoint(handle, 0, DevDesc[DEV_DESC_MAX_PACKET_SIZE], 
      USB_SEND, USB_CONTROL_ENDPOINT, 0);

   if (TEST_ENABLED) {
      _usb_device_cancel_transfer(handle, 1, USB_RECV);
      _usb_device_cancel_transfer(handle, 1, USB_SEND);
   } /* Endif */
   
   TEST_ENABLED = SMT_FALSE;
   
   return;
} /* EndBody */

/*FUNCTION*----------------------------------------------------------------
* 
* Function Name  : main
* Returned Value : None
* Comments       :
*     First function called.  Initialises the USB and registers Chapter 9
*     callback functions.
* 
*END*--------------------------------------------------------------------*/
void usb_init_string(void)
{
	smtUint8 *src;
	smtUint16 *dst;
	smtUint32 len, i, j;
	
	dst = USB_STRING_DESC[0];
	dst[0] = 0x0302;
	dst[1] = 0x0409;

	for(j=1;j<USB_STRING_ARRAY_SIZE;j++)
	{	
		dst = USB_STRING_DESC[j];
		src = (smtUint8 *)USB_STRING[j];
		len = sizeof(src);
		
		dst[0] = 0x300 + len;
		for(i=1;i<len;i++)
			dst[i] = src[i];
	}	
}


void mass_init_string(void)
{
	smtUint8 *psrc, *pdst;
	smtUint32 i;

	pdst = (smtUint8 *)&device_information_data;
	pdst += 8;
	psrc = (smtUint8 *)CT500_MASS_VENDOR8;
	for(i=0;i<8;i++)
	{
		*pdst++ = *psrc++;
	}

	pdst = (smtUint8 *)&device_information_data;
	pdst += 16;
	psrc = (smtUint8 *)CT500_MASS_PRODUCT16;
	for(i=0;i<16;i++)
	{
		*pdst++ = *psrc++;
	}	

	pdst = (smtUint8 *)&device_information_data;
	pdst += 32;
	psrc = (smtUint8 *)CT500_MASS_REVISION4;
	for(i=0;i<4;i++)
	{
		*pdst++ = *psrc++;
	}
}

smtBoolean USBTest(smtUint32 card) 
{ /* Body */
	#define USB_STOP	(*(volatile unsigned *)(0x4001C140))
	
   void *handle;
   smtUint8               error;
   smtUint8 *			 temp = (smtUint8 *)CT500_USB_BASE;
   volatile smtInt32				 i;
   smtUint8 uart_input =0;	   
     
   DisableVIC();
   
   smt2UARTPrint(CFG_UART_CH,"\nConnect the USB cable and insert SD Card!!\n");
   smt2UARTPrint(CFG_UART_CH,"press any key when you ready!!\n");
   smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);

#ifndef USB_POLLING

   EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);	
	
   /*lock interrupts */
   Disable_IRQ();
#endif   

   USB_memzero(temp,CT500_USB_LEN);  
   
   usb_init_string(); 
   mass_init_string();
   CARD_DETECT = card;

   if(CARD_DETECT==CARD_INSERTED)
   {
	if(SDMMCIdentify() == -1) 
	{
		smt2UARTPrint(CFG_UART_CH,"[usb_main()]: has no card... insert card\n");
	}
   }


   /* Initialize the USB interface */
   error = _usb_device_init(0, &handle, 2);
     
#ifndef SMALL_CODE_SIZE      
   error = _usb_device_register_service(handle, USB_SERVICE_EP0, service_ep0);   
   error = _usb_device_register_service(handle, USB_SERVICE_BUS_RESET, reset_ep0);
   error = _usb_device_register_service(handle, USB_SERVICE_SPEED_DETECTION, service_speed);
   error = _usb_device_register_service(handle, USB_SERVICE_EP1, service_ep1);
#endif
                               	
	Send_Buffer_Unaligned = (smtUint8 *)CT500_USB_BUF_BASE;
	
   
   Send_Buffer_aligned = (smtUint8 *) USB_CACHE_ALIGN((smtUint32) Send_Buffer_Unaligned);   

   /**************************************************************************
   Assign pointers to different buffers from it and copy data inside.
   ***************************************************************************/
    
   DevDesc =  (smtUint8 *) Send_Buffer_aligned;
   for(i=0;i<DEVICE_DESCRIPTOR_SIZE;i++) DevDesc[i] = DevDescData[i];
   Send_Buffer_aligned += ((DEVICE_DESCRIPTOR_SIZE/PSP_CACHE_LINE_SIZE) + 1)* PSP_CACHE_LINE_SIZE; 
   
   ConfigDesc =  (smtUint8 *) Send_Buffer_aligned;
   for(i=0;i<CONFIG_DESC_SIZE;i++) ConfigDesc[i] = ConfigDescData[i];   
   Send_Buffer_aligned += ((CONFIG_DESC_SIZE/PSP_CACHE_LINE_SIZE) + 1)* PSP_CACHE_LINE_SIZE; 
   
   DevQualifierDesc =  (smtUint8 *) Send_Buffer_aligned;
   for(i=0;i<DEVICE_QUALIFIER_DESCRIPTOR_SIZE;i++) DevQualifierDesc[i] = DevQualifierDescData[i];      
   Send_Buffer_aligned += ((DEVICE_QUALIFIER_DESCRIPTOR_SIZE/PSP_CACHE_LINE_SIZE) + \
                           1)* PSP_CACHE_LINE_SIZE;

   other_speed_config =  (smtUint8 *) Send_Buffer_aligned;
   for(i=0;i<OTHER_SPEED_CONFIG_DESC_SIZE;i++) other_speed_config[i] = other_speed_config_data[i];         
   Send_Buffer_aligned += ((OTHER_SPEED_CONFIG_DESC_SIZE/PSP_CACHE_LINE_SIZE) + 1)* PSP_CACHE_LINE_SIZE; 

   /*buffer to receive data from Bulk OUT */
   ep1_buf =  (smtUint8 *) Send_Buffer_aligned;
   memset(ep1_buf,0, BUFFERSIZE);
   Send_Buffer_aligned += ((BUFFERSIZE/PSP_CACHE_LINE_SIZE) + 1)* PSP_CACHE_LINE_SIZE;
   
   /*buffer for control endpoint to send data */
   epTemp_buf =  (smtUint8 *) Send_Buffer_aligned;
   Send_Buffer_aligned += ((EP_TEMP_BUFFERSIZE/PSP_CACHE_LINE_SIZE) + 1)* PSP_CACHE_LINE_SIZE; 
   
   ep_mass_buf = (smtUint8 *)Send_Buffer_aligned;
   Send_Buffer_aligned += ((EP_TEMP_BUFFERSIZE/PSP_CACHE_LINE_SIZE) + 1)* PSP_CACHE_LINE_SIZE; 
                         
   /**************************************************************************
   Flush the cache to ensure main memory is updated.
   ***************************************************************************/
   USB_dcache_flush_mlines((void *)0, 0);

   /* This is a Self-Powered Device so set device status to show that. */
   _usb_device_set_status(handle, USB_STATUS_DEVICE, USB_SELF_POWERED);
   
#ifndef USB_POLLING

   RequestIRQ(4/*IRQ_USB*/, _usb_dci_vusb20_isr);
   RequestIRQ(14/*IRQ_GPIO0*/, (ISRType)GpioIRQHandler);
   RequestGpioIRQ(29, card_detect_handler);
   Enable_IRQ();
   
#endif   
   
   while (SMT_TRUE) 
   {
	 #ifdef USB_POLLING
			_usb_dci_vusb20_isr(0);	
		
			if(SMT_READ(GPIO0_IN)&0x20000000)
			{
				CARD_DETECT = CARD_EXTRACT;
				CARD_OK = SMT_FALSE;
			}
			else
			{
				if(CARD_DETECT  == CARD_EXTRACT)
				{
					if(SDMMCIdentify() == -1) 
					{
						smt2UARTPrint(CFG_UART_CH,"[SDMMC TEST]: has no card... insert card\n");
					}

					CARD_DETECT = CARD_INSERTED;
					
					mmc_decode_csd();
					mmc_decode_cid();
					print_sd_information();
					
					smt2UARTPrint(CFG_UART_CH, "[SDMMC TEST]:  Remove the usb device before finishing the usb test\n");
					smt2UARTPrint(CFG_UART_CH, "[SDMMC TEST]:  then, press '0'\n");
			  }
		  }
	  #else
			smt2UARTPrint(CFG_UART_CH,".\n");
	  #endif
	
		smt2UARTDataValid(CFG_UART_CH, &uart_input);
		if(uart_input)
		{			
			smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);
			if(uart_input == '0')
			break;
		}				
   } /* Endwhile */

   // USB Power OFF, SD Socket Power OFF
   USB_STOP = SMT_FALSE;
   GPIO0_OE = 0x0;

#ifndef USB_POLLING
   ReleaseGpioIRQ(29);
   ReleaseIRQ(14/*IRQ_GPIO0*/);
   ReleaseIRQ(4/*IRQ_USB*/);
#endif

   return SMT_SUCCESS;

} /* Endbody */


#ifndef USB_POLLING

void card_detect_handler(smtUint32 IRQ)
{
	smtUint32 value;
	
	value = SMT_READ(GPIO0_IN)>>29;
	value = value & 0x01;

	if(value&0x01)
	{		
	    smt2UARTPrint(CFG_UART_CH,"OUT\n");
		CARD_DETECT = CARD_EXTRACT;
		CARD_OK = SMT_FALSE;
	}
	else
	{
		smt2UARTPrint(CFG_UART_CH,"IN\n");
		if(SDMMCIdentify() == -1) 
		{
			smt2UARTPrint(CFG_UART_CH,"[card_detect_handler()]: has no card... insert card\n");
		}
		else
		{
			CARD_DETECT = CARD_INSERTED;
			
			mmc_decode_csd();
			mmc_decode_cid();
			print_sd_information();
		}
	}
}

#endif 
/* EOF */
