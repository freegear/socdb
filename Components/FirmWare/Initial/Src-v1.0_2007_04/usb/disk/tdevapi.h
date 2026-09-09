#ifndef __devapi_h__
#define __devapi_h__ 1
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
***  This file contains the declarations specific to the USB Device API
***
**************************************************************************
**END*********************************************************/


#define  USB_SEND                         (1)
#define  USB_RECV                         (0)

/* Endpoint types */
#define  USB_CONTROL_ENDPOINT             (0)
#define  USB_ISOCHRONOUS_ENDPOINT         (1)
#define  USB_BULK_ENDPOINT                (2)
#define  USB_INTERRUPT_ENDPOINT           (3)

/* Informational Request/Set Types */
#define  USB_STATUS_DEVICE_STATE          (0x01)
#define  USB_STATUS_INTERFACE             (0x02)
#define  USB_STATUS_ADDRESS               (0x03)
#define  USB_STATUS_CURRENT_CONFIG        (0x04)
#define  USB_STATUS_SOF_COUNT             (0x05)
#define  USB_STATUS_DEVICE                (0x06)
#define  USB_STATUS_TEST_MODE             (0x07)
#define  USB_FORCE_FULL_SPEED             (0x08)
#define  USB_PHY_LOW_POWER_SUSPEND        (0x09)
#define  USB_STATUS_ENDPOINT              (0x10)
#define  USB_STATUS_ENDPOINT_NUMBER_MASK  (0x8F)

#define  USB_TEST_MODE_TEST_PACKET        (0x0400)

/* Available service types */
/* Services 0 through 15 are reserved for endpoints */
#define  USB_SERVICE_EP0                  (0x00)
#define  USB_SERVICE_EP1                  (0x01)
#define  USB_SERVICE_EP2                  (0x02)
#define  USB_SERVICE_EP3                  (0x03)
#define  USB_SERVICE_BUS_RESET            (0x10)
#define  USB_SERVICE_SUSPEND              (0x11)
#define  USB_SERVICE_SOF                  (0x12)
#define  USB_SERVICE_RESUME               (0x13)
#define  USB_SERVICE_SLEEP                (0x14)
#define  USB_SERVICE_SPEED_DETECTION      (0x15)
#define  USB_SERVICE_ERROR                (0x16)
#define  USB_SERVICE_STALL                (0x17)

#ifdef __cplusplus
extern "C" {
#endif

extern smtUint8 _usb_device_init(smtUint8, void *, smtUint8);
extern smtUint8 _usb_device_recv_data(void *, smtUint8, smtUint8 *, smtUint32);
extern smtUint8 _usb_device_send_data(void *, smtUint8, smtUint8 *, smtUint32);
extern smtUint8 _usb_device_get_transfer_status(void *, smtUint8, smtUint8);
extern void _usb_device_get_transfer_details(void *, smtUint8, smtUint8, smtUint32 *);
extern smtUint8 _usb_device_cancel_transfer(void *, smtUint8, smtUint8);
extern smtUint8 _usb_device_get_status(void *, smtUint8, smtUint16 *);
extern smtUint8 _usb_device_set_status(void *, smtUint8, smtUint16);
extern smtUint8 _usb_device_register_service(void *, smtUint8,
   void(* service)(void *, smtBoolean, smtUint8, smtUint8 *, smtUint32, smtUint8));
 
extern smtUint8 _usb_device_unregister_service(void *, smtUint8);
extern smtUint8 _usb_device_call_service(void *, smtUint8, smtBoolean,
   smtBoolean, smtUint8 *, smtUint32, smtUint8);
extern void _usb_device_shutdown(void *);
extern void _usb_device_set_address(void *, smtUint8);
extern void _usb_device_read_setup_data(void *, smtUint8, smtUint8 *);
extern void _usb_device_assert_resume(void *);
extern smtUint8 _usb_device_init_endpoint(void *, smtUint8, smtUint16,
   smtUint8, smtUint8, smtUint8);
extern void _usb_device_stall_endpoint(void *, smtUint8, smtUint8);
extern void _usb_device_unstall_endpoint(void *, smtUint8, smtUint8);
extern smtUint8 _usb_device_deinit_endpoint(void *, smtUint8, smtUint8);

#ifdef __cplusplus
}
#endif

#endif
/* EOF */

