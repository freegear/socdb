#ifndef __usb_cfg_h__
#define __usb_cfg_h__

#include "sysinc.h"
#define USB_POLLING

#define CT500_USB_ALIGN		0x100


/* CT500_USB_BASE = lower 11Bit clear */
/* Non-cache region */
#define CT500_USB_LEN		0x16E0
//#define CT500_USB_BASE		0x62000000
#define CT500_USB_BASE		USB_FIFOBUF_STARTADDR
#define CT500_USB_END		(CT500_USB_BASE+CT500_USB_LEN)
  
#define CT500_USB_BUF_LEN	(0x10960+CT500_USB_ALIGN)
#define CT500_USB_BUF_BASE	(CT500_USB_END+CT500_USB_ALIGN)
#define CT500_USB_BUF_END	(CT500_USB_BUF_BASE+CT500_USB_BUF_LEN)

// totlength = 0x12240 76KB

#define  TOTAL_LOGICAL_ADDRESS_BLOCKS     0

#define CT500_VID		0x0B20
#define CT500_PID		0x1
#define CT500_REVISION	0x0002


 /* CT500_USB_STR1 : Manufacturer string index	*/
 /* CT500_USB_STR2 : Product string index		*/
 /* CT500_USB_STR3 : Serial number string index	*/
#define CT500_USB_STR1 "SangHwa Micro Technology Inc."
#define CT500_USB_STR2 "SMT Mass Storage"
#define CT500_USB_STR3 "00000001"
#define CT500_USB_STR4 " "
#define CT500_USB_STR5 " "
#define CT500_USB_STR6 " "
#define CT500_USB_STR7 " "
#define CT500_USB_STR8 "BAD STRING INDEX"

#define CT500_MASS_VENDOR8	"ENTER   "
#define CT500_MASS_PRODUCT16	"CT500-KARAOKE   "
#define CT500_MASS_REVISION4	"0001"

#endif
