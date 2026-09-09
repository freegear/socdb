// usb_drv.c
//
// rev 1 5/26/98 russell

#define USB_DRV_C	1

#include "vauto.h"
#include "ad1848.h"
#if WANT_PRINTER
#include "printer.h"
#endif
#include "host.h"
#include "uart.h"
#include "usb_drv.h"
#include "usb_glob.h"
#if WANT_HUB
#include "hub.h"
#endif

//#if WANT_HUB
//#if WANT_SOUND | WANT_PRINTER
//	"Error: mutex";	// can't have hub with sound or printer
//#endif
//#endif

#if WANT_HUB

#if WANT_HARDWARE && !WANT_LITE
#define DEBUG_EXTRA_NULL	0
#define DEBUG_SOF_MISSES	0
#define DEBUG_GETDESC	0
#define DEBUG_GETDESC2	0
#define DEBUG_EP0		0
#define DEBUG_REGS		0
#define DEBUG_REGS_VERBOSE	0
#define DEBUG_SEND_IN	0
#define DEBUG_SEND_IN2	0
#define DEBUG_STATE		0
#define DEBUG_CONFIG	0
#define DEBUG_STACK		0	// save return address on entry and validate it on rti
#define DEBUG_PORT_STATE	0
#define DEBUG_PULSE		0
#define DEBUG_TRUNCATE	0
#define DEBUG_DEQUEUE	0
#define DEBUG_STALL		0
#define DEBUG_PBDT		0
#define DEBUG_CLASS_SETUP	0
#define DEBUG_SLEEP		0
#define DEBUG_USB_STATUS_DEVICE 0
#else // !WANT_HARDWARE
#define DEBUG_EXTRA_NULL	0
#define DEBUG_SOF_MISSES	0
#define DEBUG_GETDESC	0
#define DEBUG_GETDESC2	0
#define DEBUG_EP0		0
#define DEBUG_REGS		0
#define DEBUG_REGS_VERBOSE	0
#define DEBUG_SEND_IN	0
#define DEBUG_SEND_IN2	0
#define DEBUG_STATE		0
#define DEBUG_CONFIG	0
#define DEBUG_STACK		0	// save return address on entry and validate it on rti
#define DEBUG_PORT_STATE	0
#define DEBUG_PULSE		0
#define DEBUG_TRUNCATE	0
#define DEBUG_DEQUEUE	0
#define DEBUG_STALL		0
#define DEBUG_PBDT		0
#define DEBUG_CLASS_SETUP	0
#define DEBUG_SLEEP		0
#define DEBUG_USB_STATUS_DEVICE 0
#endif

#else // !WANT_HUB

#define DEBUG_EXTRA_NULL	0
#define DEBUG_SOF_MISSES	0
#define DEBUG_GETDESC	0
#define DEBUG_GETDESC2	0
#define DEBUG_EP0		0
#define DEBUG_REGS		0
#define DEBUG_REGS_VERBOSE	0
#define DEBUG_SEND_IN	0
#define DEBUG_SEND_IN2	0
#define DEBUG_STATE		0
#define DEBUG_CONFIG	0
#define DEBUG_STACK		0	// save return address on entry and validate it on rti
#define DEBUG_PORT_STATE	0
#define DEBUG_PULSE		0
#define DEBUG_TRUNCATE	0
#define DEBUG_DEQUEUE	0
#define DEBUG_STALL		0
#define DEBUG_PBDT		0
#define DEBUG_CLASS_SETUP	0
#define DEBUG_SLEEP		0
#define DEBUG_USB_STATUS_DEVICE 0
#endif // !WANT_HUB

#if DEBUG_REGS
#if DEBUG_REGS_VERBOSE
PBYTE	pStatus[8] = {"Stl","Att","Res","Slp","Tok","Sof","Err","Rst"};
PBYTE	pError[8]  = {"BTS","Own","DMA","BTO","DFN","CRC","EOF","Pid"};

void UsbDumpByte(BYTE bStat, BYTE bEnable, PBYTE *p);
#endif
void UsbDrvDumpRegs()
#include "dumpregs.h"
#endif

#if WANT_LITE
#define STALL(lite,full) UsbStall(lite)
#define PUTS(lite,full) puts(lite)
#else
#define STALL(lite,full) UsbStall(full)
#define PUTS(lite,full) puts(full)
#endif


#define INIT_ONION_WITH_BDT_FOR_EP(o,e) {o.b.h = ((WORD)USB_BDT_PAGE) >> 8; o.b.l = ep << 4;}


// Define the states that the USB interface can be in
#define	POWERED_STATE	0x03
#define	DEFAULT_STATE	0x02
#define	ADDRESS_STATE	0x01
#define	CONFIG_STATE	0x00
#define	SUSPEND_STATE	0x80	// Bit 7 indicates suspend, [6:4] indicate state
// Define the states for Control EndPoints
#define	EP_IDLE_STATE	0x00
#define	EP_SETUP_STATE	0x01
#define	EP_DISABLED_STATE	0xff
// define various variables for USB

#define USB_DEFAULT_BUFFER_SIZE 8	// valid values are 8,16,32,64 per USB spec.
#define	USB_NUM_IFACES_9 0			// number of interfaces in the configuration
#define CONFIG_SIZE_9 0x09
#define USB_DEVICE_CLASS 0			// bDeviceClass	zero means each interface operates independently
#define USB_PRODUCT 0x02			// string number of product string
#define USB_SERIAL_NUMBER 0x03		// string number of serial number


#if WANT_HUB
#define USB_NUM_IFACES_8 (USB_NUM_IFACES_9+1)
#define CONFIG_SIZE_8 (CONFIG_SIZE_9+0x10)
#undef USB_DEVICE_CLASS
#define USB_DEVICE_CLASS 9			// bDeviceClass 9=HUB
#undef USB_PRODUCT
#define USB_PRODUCT 0x07			// string number of product string
#undef USB_SERIAL_NUMBER
#define USB_SERIAL_NUMBER 0x00		// string number of serial number (none, 
									// a hub with a serial number breaks things)
#else // !WANT_HUB
#define USB_NUM_IFACES_8 (USB_NUM_IFACES_9)
#define CONFIG_SIZE_8 (CONFIG_SIZE_9)
#endif // WANT_HUB

#if WANT_SOUND
#undef USB_DEFAULT_BUFFER_SIZE
#define USB_DEFAULT_BUFFER_SIZE 64	// valid values are 8,16,32,64 per USB spec.
#define USB_NUM_IFACES_7 (USB_NUM_IFACES_8+2)
#define CONFIG_SIZE_7 (CONFIG_SIZE_8+0x7d)
#undef USB_DEVICE_CLASS
#define USB_DEVICE_CLASS 0			// bDeviceClass	zero means each interface operates independently
#else // !WANT_SOUND
#define USB_NUM_IFACES_7 (USB_NUM_IFACES_8)
#define CONFIG_SIZE_7 (CONFIG_SIZE_8)
#endif // WANT_SOUND

#if WANT_PRINTER
#define USB_NUM_IFACES_6 (USB_NUM_IFACES_7+1)
#define CONFIG_SIZE_6 (CONFIG_SIZE_7+0x17)
#undef USB_DEVICE_CLASS
#define USB_DEVICE_CLASS 0			// bDeviceClass	zero means each interface operates independently
#else // !WANT_PRINTER
#define USB_NUM_IFACES_6 (USB_NUM_IFACES_7)
#define CONFIG_SIZE_6 (CONFIG_SIZE_7)
#endif // WANT_PRINTER

#define USB_NUM_IFACES (USB_NUM_IFACES_6)
#define CONFIG_SIZE CONFIG_SIZE_6

BYTE USB_BUFFER_SIZE = USB_DEFAULT_BUFFER_SIZE;	// valid values are 8,16,32,64 per USB spec.


#if !USB_NUM_IFACES && !WANT_LITE
Hey, you don't have any interfaces;
#endif


BOOL bExtraRxBDT[ENDPOINTS] = {FALSE};

WORD USB_MAX_PACKET[ENDPOINTS] = 	// max packet size per ep
	{
	0 /* inited at runtime*/, 0x30, 1023, 0x40
#if 0
	, 
	1023, 1023, 1023, 1023, 
	1023, 1023, 1023, 1023, 
	1023, 1023, 1023, 8
#endif
	};

BYTE USB_DEBUG = 1;			// 0=debug messages off, 1=on
BYTE USB_DUMP;
BYTE USB_STATE;			// Current USB state (POWERED,DEFAULT,ADDRESS,CONFIG,SUSPEND)
BYTE USB_CURR_CONFIG;	// Current USB configuration selected
BYTE SEND_DATA01[ENDPOINTS];	// stores the Data1/0 PID for each endpoint
BYTE RECV_DATA01[ENDPOINTS];	// stores the Data1/0 PID for each endpoint

typedef union
	{
	WORD	w;
	BYTE	b[2];
	struct
		{
		WORD	pid:1,		// from VUSB ERR_STAT Reg
				crc5:1,		// from VUSB ERR_STAT Reg
				crc16:1,	// from VUSB ERR_STAT Reg
				dfn8:1,		// from VUSB ERR_STAT Reg
				bto:1,		// from VUSB ERR_STAT Reg
				dma:1,		// from VUSB ERR_STAT Reg
				own:1,		// from VUSB ERR_STAT Reg
				bitstuff:1,	// from VUSB ERR_STAT Reg
				sleep:1,	// Set when USB idle for more than 3ms
				reset:1,	// Set when USB Reset condition detected. Note that 
							// this value cannot be "reset" by the USB reset.
				non0st:1,	// Set if a non zero length data packet is received 
							// during the status phase of a setup transaction.
				stall:1,
				spare:4;
		} bits;
	} USB_ERROR;			// Writing a 0 to this register has no effect, 
							// writting a 1 to any bit will cause that bit in 
							// the register to be cleared to 0.

USB_ERROR USB_ERROR_STAT;	// error status


WORD AUDIO_BC;			// 16 bit counter of the number of bytes sent down
BYTE USB_BYTES;
BYTE USB_BREAK_OWNS;	// 1 if non-EP0's should not set owns bit
BYTE USB_ENDPOINT_CONTROL;	// value returned from GetEndpoint

	// EP2 to the AUDIO speaker outputs Currently selected 
	// alternate settings for up to USB_NUM_IFACES interfaces
static BYTE USB_IF_ALT[3];

// USB_PRINTER variables
static BYTE USB_PRN_RUN = 0xee;	// 0=no buffer actively printing
static PBYTE USB_PRN_READ = (PBYTE)0xeeee;	// current position in the buffer
static PBYTE USB_PRN_END = (PBYTE)0xeeee;	// last position in the buffer
static PBDT USB_PRN_PTR = (PBDT)0xeeee;	// Pointer to the USB BDT in use

// The SETUP Device Request is copied here until it has been
// processed. After processing, bRequestType is set to 0xff which will
// let us know if we get an erroneous IN or OUT token.
// See page 172, section 9.3 rev 1.0 USB spec

WORD USB_ERROR_CTR[8];
	// 16 bit count of the number of PID errors
	// 16 bit count of the number of CRC5 errors
	// 16 bit count of the number of CRC16 errors
	// 16 bit count of the number of DFN8 errors
	// 16 bit count of the number of Bus Time Outs
	// 16 bit count of the number of DMA errors
	// 16 bit count of the number of OWN bit BDT errors
	// 16 bit count of the number of Bit Stuff Error

#define USB_LED_ERROR_ON		asm("stp 7")
#define USB_LED_ERROR_OFF		asm("clp 7")
#define USB_LED_INT_ON			asm("stp 6")	// 1<<USB_LED_INT
#define USB_LED_INT_OFF			asm("clp 6")	// 0xff-USB_LED_INT_ON
#define USB_LED_ATTACH_ON		asm("stp 5")	// 1<<USB_LED_ATTACH
#define USB_LED_ATTACH_OFF		asm("clp 5")	// 0xff-USB_LED_ATTACH_ON
#define USB_LED_SEND_ON			asm("stp 4")	// 1<<USB_LED_SEND
#define USB_LED_SEND_OFF		asm("clp 4")	// 0xff-USB_LED_SEND_ON

static WORD USB_STATUS_DEVICE = 0xeeee;		// Device status = self-powered.
static WORD USB_STATUS_INTERFACE = 0xeeee;		// used for interface status requests
static WORD USB_STATUS_ENDPOINT = 0xeeee;		// used for EP status requests
BYTE bRemoteWakeupEnabled = FALSE;

#define USB_STR_NUM 8	// number of strings in the table not including 0 or n.

// if the number of strings changes, look for USB_STR_0 everywhere and make 
// the obvious changes.  It should be found in 3 places.

static BYTE USB_STR_0[] = "\000\003\x09\x04";
static BYTE USB_STR_1[] = "\000\003V\000A\000u\000t\000o\000m\000a\000t\000i\000o\000n\000 \000I\000n\000c\000";
static BYTE USB_STR_2[] = "\000\003V\000U\000S\000B\000 \000S\000y\000n\000t\000h\000e\000s\000i\000z\000a\000b\000l\000e\000 \000C\000o\000r\000e\000 \000D\000e\000m\000o\000";
static BYTE USB_STR_3[] = "\000\003B\000E\000T\000A\000";
static BYTE USB_STR_4[] = "\000\003#\0000\0002\000";
static BYTE USB_STR_5[] = "\000\003_\000A\0001\000";
static BYTE USB_STR_6[] = "\000\003P\0001\0002\0008\0004\000 \000P\000r\000i\000n\000t\000e\000r\000";
#if WANT_PRINTER || WANT_SOUND
static BYTE USB_STR_7[] = "\000\003C\000o\000m\000p\000o\000s\000i\000t\000e\000 \000H\000u\000b\000";
#else
static BYTE USB_STR_7[] = "\000\003H\000u\000b\000";
#endif
static BYTE USB_STR_8[] = "\000\003V\000A\000u\000t\000o\000 \000P\000r\000i\000n\000t\000e\000r\000 \000D\000o\000n\000g\000l\000e\000";
static BYTE USB_STR_n[] = "\000\003B\000A\000D\000 \000S\000T\000R\000I\000N\000G\000 \000I\000n\000d\000e\000x\000";


static PBYTE USB_STRING_DESC[USB_STR_NUM+2] =
	{
	USB_STR_0,
	USB_STR_1,
	USB_STR_2,
	USB_STR_3,
	USB_STR_4,
	USB_STR_5,
	USB_STR_6,
	USB_STR_7,
	USB_STR_8,
	USB_STR_n
	};

// any words are stored low byte first then high byte

BYTE USB_DEVICE_DESC[] =	// table for the USB Device Descriptor
	{
	// This table is polled by the host immediately after USB Reset has been released.
	// This table defines the maximum packet size EP0 can take.
	// See section 9.6.1 of the Rev 1.0 USB specification.
	// These fields are application DEPENDENT. Be sure to modify these to meet
	// your specifications.
	18,					// bLength	Length of this descriptor
	1,					// bDescType 	This is a DEVICE descriptor
	0,1,				// bcdUSB	USB revision 1.00
	USB_DEVICE_CLASS,	// bDeviceClass
	0,					// bDeviceSubClass
	0,					// bDeviceProtocol
	0xff,				// bMaxPacketSize0 - inited in UsbInit()
	0xa3,0x05,			// idVendor	0x05a3 is VAutomation Vendor ID
	0x01,0x01,			// idProduct
	0,0,				// bcdDevice
	0x01,				// iManufacturer
	USB_PRODUCT,		// iProduct
	USB_SERIAL_NUMBER,	// iSerialNumber
	0x01				// bNumConfigurations
	};

BYTE USB_CONFIG_DESC[CONFIG_SIZE] =// table for the USB Configuration Descriptor
	{
	// This table is retrieved by the host after the address has been set.
	// This table defines the configurations available for the device.
	// See section 9.6.2 of the Rev 1.0 USB specification (page 184).
	// These fields are application DEPENDENT. 
	// Be sure to modify these to meet your specifications.
	9,		// bLength	Length of this descriptor
	2,		// bDescType	2=CONFIGURATION

	CONFIG_SIZE & 0xff, CONFIG_SIZE >> 8, 
	USB_NUM_IFACES,		// bNumInterfaces	Number of interfaces

//USB_CONFIG_VAL:
	0x01,	// bConfigValue	Configuration Value
	0x04,	// iConfig	String Index for this config = #01
#if WANT_HUB
	0xe0,	// bmAttributes	attributes - self powered, remote wakeup,
#else
	0xc0,	// bmAttributes	attributes - self powered
#endif

	0		// MaxPower	self-powered draws 0 mA from the bus.

#if WANT_SOUND
	,
#if 1	// commented out since we can't prove wether it works or not
//	IIIII  FFFFF   CCCC   000 
//	  I    F      C      0   0
//	  I    FFF    C      0   0
//	  I    F      C      0   0
//	IIIII  F       CCCC   000 

//// AUDIO CONTROL	// See section 9.6.3 of the Rev 1.0 USB spec (page 185)

	0x09,	// blength	Length of this desriptor
	4,		// bDescriptorType	4=INTERFACE
	0,		// bIfaceNum	interface number
	0,		// bAltSetting	Alternate setting 0 (no others)
	0,		// bNumEndpoints	Number of endpoints= use EP0 only
	0x01,	// bIfaceClass	Interface class 01=AUDIO
	0x01,	// bIfaceSubClass	Audio COntrol
	0x00,	// bIfaceProtocol	none
	0,	// iInterface

//USB_AC_IFACE:		// Audio Class Specific Audio Control (AC) Interface desc
	0x09,		// bLength
	0x24,		// Audio class specific interface descriptor
	0x01,		// HEADER type
	0x09,0x00,	// spec rev = 0009
	0x1e,0x00,	// total length=001e
	0x01,		// number of streaming interfaces=1
	0x01,		// Interface number=1

	0x0c,		// bLength
	0x24,		//Audio class specific interface desc
	0x02,		//Input Terminal
	0x01,		//TerminalID
	0x01,0x01,	//TerminalType=0101=Audio Streaming
	0x00,		//output AssocTerminal
	0x02,		//Number of Channels=2
	0x03,0x00,	//wChannelConfig=L,R
	0x00,		//iChannelNames=none
	0x00,		//iTerminal

	0x09,		//bLength
	0x24,		//Type=Audio class specific interface desc
	0x03,		//Output Terminal
	0x02,		//TerminalID
	0x01,0x03,	//TerminalType=0301=Generic Speakers
	0x00,		//bAssocTerminal=terminalID connect to=0?
	0x01,		//bSourceID=TerminalID which is the source for this terminal=feature unit
	0x00,		//iTerminal=string
#endif

//	IIIII  FFFFF   CCCC    1  
//	  I    F      C       11  
//	  I    FFF    C        1  
//	  I    F      C        1  
//	IIIII  F       CCCC  11111

//// AUDIO STREAM			// See section 9.6.3 of the Rev 1.0 USB spec (page 185)

//		 AAA   L      TTTTT   000 
//		A   A  L        T    0   0
//		AAAAA  L        T    0   0
//		A   A  L        T    0   0
//		A   A  LLLLL    T     000 

	0x09,	// blength	Length of this desriptor
	4,		// bDescriptorType	4=INTERFACE
	1,		// bIfaceNum	interface number #1
	0,		// bAltSetting	Alternate setting 0 Zero ISO Bandwidth version which is required by Win98
	1,		// bNumEndpoints	Number of endpoints= use EP0 only
	0x01,	// bIfaceClass	Interface class 01=AUDIO
	0x02,	// bIfaceSubClass	Audio Streaming
	0x00,	// bIfaceProtocol	none
	4,		// iInterface	String=#01

	0x07,	// bLength
	0x24,	// Audio Class Specific AS Interface Desc.
	0x01,	// AS_GENERAL
	0x01,	// TermLink connected to terminal #1
	0x00,	// Delay=0
	0x00,0x01,	// FormatTag=PCM

	0x0b,		//bLength	// Format Specification
	0x24,		//Audio Class Specific AS Interface Desc.
	0x02,		//FORMAT_TYPE
	0x01,		//formatType
	0x02,		//NrChannels=2
	0x02,		//SubFrameSize=2 byte
	16,			//BitResolution=16 bits
	0x01,		//SamFreqType=1 type
	0x00,0x00,	// ZERO BANDWIDTH
	0x00,		// SamFreq MSB (it's a 24 bit number in HZ)

	9,			// bLength	Length of this descriptor
	5,			// bDescType	5=ENDPOINT
	ENDPOINT_SPEAKER,	// bEndpntAddr	End Point address (EP2=out)
	0x09,		// bmAttr	ISO adaptive rate
	0x00,0x00,	// wMaxPktSize	Max Packet Size
	1,			// bInterval	
	0,			// bRefresh
	0,			// SyncAddr	None

////USB_AS_DESC1:		// Class Specific Audio AS EP descriptor
	7,			// bLength	Length of this descriptor
	0x25,		// bDescType	Class specific ENDPOINT
	1,			// SubType	GENERAL
	0,			// bmAttr	none
	2,			// bDelayUnits	PCM samples
	0x01,0x00,	// bLockDelay	1 sample delay

//		 AAA   L      TTTTT    1  
//		A   A  L        T     11  
//		AAAAA  L        T      1  
//		A   A  L        T      1  
//		A   A  LLLLL    T    11111

	0x09,		// blength	Length of this desriptor
	4,			// bDescriptorType	4=INTERFACE
	1,			// bIfaceNum	interface number #1
	1,			// bAltSetting	Alternate setting #1
	1,			// bNumEndpoints	Number of endpoints=1
	0x01,		// bIfaceClass	Interface class 01=AUDIO
	0x02,		// bIfaceSubClass	Subclass 02=AUDIO_STREAMING
	0x00,		// bIfaceProtocol	protocol
	05,			// iInterface	String Index

//USB_AS_IFACE:	// Audio Class Specific Audio Streaming (AS) Interface desc
	0x07,		// bLength
	0x24,		// Audio Class Specific AS Interface Desc.
	0x01,		// AS_GENERAL
	0x01,		// TermLink connected to terminal #1
	0x00,		// Delay=0
	0x01,0x00,	// FormatTag=PCM

	0x0b,		//bLength	// Format Specification
	0x24,		//Audio Class Specific AS Interface Desc.
	0x02,		//FORMAT_TYPE
	0x01,		//formatType
	0x02,		//NrChannels=2
	0x02,		//SubFrameSize=2 byte
	16,			//BitResolution=16 bits
	0x01,		//SamFreqType=1 type
	0x11,0x2b,	// SamFreq=11.025Khz
	0x00,		// SamFreq MSB (it's a 24 bit number in HZ)

//USB_EP_DESC1:	// table for the USB ENDPOINT Descriptor
	// See section 9.6.4 of the Rev 1.0 USB spec (page 187)
	9,			// bLength	Length of this descriptor
	5,			// bDescType	5=ENDPOINT
	ENDPOINT_SPEAKER,			// bEndpntAddr	End Point address (EP2=out)
	0x09,		// bmAttr	ISO adaptive rate
	0x30,0x00,	// wMaxPktSize	Max Packet Size
	1,			// bInterval	
	0,			// bRefresh
	0,			// SyncAddr	None

//USB_AS_DESC1:	// Class Specific Audio AS EP descriptor
	7,			// bLength	Length of this descriptor
	0x25,		// bDescType	Class specific ENDPOINT
	1,			// SubType	GENERAL
	0,			// bmAttr	none
	2,			// bDelayUnits	PCM samples
	0x01,0x00	// bLockDelay	1 sample delay

//	IIIII  FFFFF   CCCC   222 
//	  I    F      C      2   2
//	  I    FFF    C        22 
//	  I    F      C       2   
//	IIIII  F       CCCC  22222
#endif

#if WANT_PRINTER
	,
//// PRINTER		// See section 9.6.3 of the Rev 1.0 USB spec (page 185)
	0x09,	// blength	Length of this desriptor
	4,		// bDescriptorType	4=INTERFACE
	2,		// bIfaceNum	interface number
	0,		// bAltSetting	Alternate setting 0=none
	2,		// bNumEndpoints	Number of endpoints=2
7,//0xff,	// bIfaceClass	Interface class ff=Vendor Specific
1,//0xff,	// bIfaceSubClass	
	2,		// bIfaceProtocol, 2=bidirectional
	8,		// iInterface, string number 8

// table for the USB ENDPOINT Descriptor
// See section 9.6.4 of the Rev 1.0 USB spec (page 187)
	7,			// bLength       Length of this descriptor
	5,			// bDescType     5=ENDPOINT
	ENDPOINT_PRINTER,			// bEndpntAddr   End Point address (EP3=out)
	0x02,		// bmAttr        Attributes 02=BULK
	0x40,0x00,	// wMaxPktSizeL  Max Packet Size
	0,			// bInterval

	7,			// bLength       Length of this descriptor
	5,			// bDescType     5=ENDPOINT
	0x83,		// bEndpntAddr   End Point address (EP3=in)
	0x02,		// bmAttr        Attributes 02=BULK
	0x40,0x00,	// wMaxPktSizeL  Max Packet Size
	0			// bInterval
#endif

#if WANT_HUB
	,
//// HUB
	0x09,	// blength	Length of this desriptor
	4,		// bDescriptorType	4=INTERFACE
	0,		// bIfaceNum	interface number
	0,		// bAltSetting	Alternate setting 0 (no others)
	1,		// bNumEndpoints
	0x09,	// bIfaceClass	Interface class 09=HUB
	0x00,	// bIfaceSubClass
	0x00,	// bIfaceProtocol	none
0,//	7,		// iInterface = string 7

// table for the USB ENDPOINT Descriptor
// See section 9.6.4 of the Rev 1.0 USB spec (page 187)
	7,			// bLength       Length of this descriptor
	5,			// bDescType     5=ENDPOINT
	0x80 + ENDPOINT_HUB,	// bEndpntAddr   End Point address (EP_,in)

// 3 or 7 who knows???
// dec likes 3
// peracom likes 7
	0x03,		// bmAttr        Attributes 03=Interrupt

	PORT_BYTES,0x00,	// wMaxPktSizeL  Max Packet Size
	0xff		// bInterval
#endif //WANT_HUB
	};

void interrupt UsbTargetIntService(void);
BOOL UsbRegRW(BYTE b);
void UsbSuspend(void);
void UsbConfig(void);
void UsbAddress(void);
void UsbDefault(void);
void UsbPowered(void);
void UsbStall(PBYTE p);
void UsbTokenDoneEP0(void);
#if DEBUG_EP0
void UsbTokenDoneEP0setup(void);
void UsbTokenDoneEP0in(void);
void UsbTokenDoneEP0out(void);
void UsbTokenDoneEP0other(void);
#endif // DEBUG_EP0
#if WANT_SOUND
void UsbTokenDoneEP1_Speaker(void);
void UsbChangeFreq(WORD wDelta);
#endif // WANT_SOUND
#if WANT_PRINTER
void UsbTokenDoneEP3(void);
void UsbPrinter(void);
void PrinterClassSetup(void);
void InitPrinterEndpoints(void);
#endif
void UsbTokenDoneEPn(void);
void UsbProvideRxBDT(BOOL bOther);
void UsbSofDet(void);
void UsbSleep(void);
void UsbResume(void);
void UsbError(void);
void UsbEchoEP(void);
void UsbVendor(void);
void UsbVendSetStatus(void);
void UsbVendGetStatus(void);
void UsbVendSetEndPoint(void);
void UsbVendGetEndPoint(void);
void UsbVendSetMemory(void);
void UsbVendGetMemory(void);
void UsbVendBreakOwns(void);

void UsbReleaseTx(void);

void UsbGetStatus(void);
void UsbClearFeature(void);
void UsbSetFeature(void);
void UsbSetAddress(void);
void UsbGetDescription(void);
void UsbSetDescription(void);
void UsbGetConfig(void);
void UsbSetConfig(void);
void UsbGetInterface(void);
void UsbSetInterface(void);
void UsbSynchFrame(void);
void UsbDequeue(void);

BDT		cBDT;	// copy of current BDT.  All work should be done on this

#if !WANT_LITE
BYTE usb_target_pcl, usb_target_pch, usb_target_psr, usb_target_new_pcl, usb_target_new_pch;
#endif

#if DEBUG_PULSE
WORD usb_target_pulse;
#endif

// <<<<<<<<<<<Interrupt Service Routine Entry Point>>>>>>>>>>>>>>>>>
#pragma interrupt_level 1
void interrupt UsbTargetIntService()
{
#if DEBUG_STACK
	static BYTE	b;
	static ONION	onion;
#endif //DEBUG_STACK

#if WANT_SIMULATOR
	asm("stp 6");
	asm("stp 7");
	asm("clp 7");
	asm("clp 6");
#endif

#if !WANT_LITE
	USB_LED_INT_ON;
#asm		// save PC and PSR for later testing
	pop r0			; pcl
	pop r1			; pch
	pop r2			; psr
	sta r0,_usb_target_pcl
	sta r1,_usb_target_pch
	sta r2,_usb_target_psr
	psh r2			; psr
	psh r1			; pch
	psh r0			; pcl
#endasm
#endif

	usbSave = usb;
	usbSave.intStatusMasked = usbSave.intStatus & usbSave.intEnable;
	usbSave.ep = usbSave.status >> 4;	// end point
	usbSave.pBDT = (PBDT)((usbSave.bdtPage<<8)|usbSave.status);
	USB_ERROR_STAT.b[0] |= usbSave.errorStatus;	// add error bits
	cBDT = *usbSave.pBDT;		// save copy of bdt

	if ((usbSave.intStatusMasked & INT_STAT_MASK_TOKEN_DONE) && (usbSave.status & 0x08))	// out token
		USB_LAST_OUT[usbSave.ep] = (usbSave.status >> 2) & 1;

#if DEBUG_SLEEP
	if (usbSave.intStatus & INT_STAT_MASK_SLEEP)
		{
		puts("UsbTargetIntService: ");
		putb(*(PBYTE)&usbSave.intStatus);
		puts(", ");
		putb(*(PBYTE)&usbSave.intEnable);
		putCrlf();
		}
#endif

#if WANT_HUB
	if (usbSave.intStatusMasked == INT_STAT_MASK_SLEEP)
		{	// Sleep and only sleep is set
		HubSleep();
		usb.intStatus = INT_STAT_MASK_SLEEP;	// clear sleep
		return;
		}
#endif // WANT_HUB

#if DEBUG_REGS && WANT_HARDWARE && !WANT_LITE
//	if (debug.bits.UsbInt)
//		if (usbSave.intStatusMasked != INT_STAT_MASK_SOF)	// ignore SOF onlys
			{
			if (USB_DUMP_COUNT)
				{
				USB_DUMP_COUNT--;
				putb(USB_DUMP_COUNT);
				putc('#');
				UsbDrvDumpRegs();
				if (!USB_DUMP_COUNT)
					puts("No more interrupts will be dumped\r\n");
				}
			}
#endif // DEBUG_REGS

#if 0
	putc('$');
	putb(USB_STATE);
#endif

	if (usbSave.control & MASK_CTL_HOST_MODE_EN)
		USB_STATE = 0;
	else
		{
		if (USB_STATE & 0x80)
			{
			UsbSuspend();
			}
		else if (USB_STATE == CONFIG_STATE)
			{
			UsbCheckForSuspend();

			UsbConfig();
			}
		else if (USB_STATE == ADDRESS_STATE)
			{
			UsbAddress();
			}
		else if (USB_STATE == DEFAULT_STATE)
			{
			UsbDefault();
			}
		else if (USB_STATE == POWERED_STATE)
			{
			UsbPowered();
			}
		// The only interrupt that should be enabled at this point is the USB_RST.
	//	else if (usbSave.intStatusMasked & (1 << INT_STAT_USB_RST))
	//		{
	//		UsbPowered();
	//		}
		else if (usbSave.intStatusMasked & INT_STAT_MASK_ATTACH)
			{
			PUTS("~42", "Attach ignored\r\n");
			putFlush();
			}
		else
			STALL("~39", "UNEXPECTED BIT IN INT_STAT");
		}

// by writting the value we previously read, all 
// bits that were set and enabled are cleared by hardware.

	usb.intStatus = usbSave.intStatusMasked;

#if !WANT_LITE
	usb_target_psr &= 0x4F;
#endif

//	usb.errorStatus = 0xff;		// clear error bits
	usb.errorStatus = usbSave.errorStatus;	// clear error bits that we've seen

	USB_LED_INT_OFF;

#if DEBUG_PULSE
	if (usbSave.intStatus & INT_STAT_MASK_SOF)
		usb_target_pulse++;
	if (usb_target_pulse & 0x0200)
		usb_target_psr |= 0x80;
	else
		usb_target_psr &= 0x7f;

#endif

#if !WANT_LITE
#asm
	pop r2			; pcl
	pop r3			; pch
	pop r4			; psr
	lda r6,_usb_target_pcl
	lda r7,_usb_target_pch
	lda r4,_usb_target_psr
	psh r4			; psr
	psh r7			; pch
	psh r6			; pcl

#if DEBUG_STACK
; see if stack was hosed, r23 should == r67
	tx0 r6
	cmp r2
	brne stack_hosed
	tx0 r7
	cmp r3
	brne stack_hosed
#endif //DEBUG_STACK

#endasm
	goto the_end;	//	rti		; happy
#asm

#if DEBUG_STACK
stack_hosed:
	sta r2,_usb_target_new_pcl
	sta r3,_usb_target_new_pch
#endif //DEBUG_STACK
#endasm

#if DEBUG_STACK
	puts("\r\n\aUSB rti expected ");
	putb(usb_target_pch);
	putb(usb_target_pcl);
	puts(" found ");
	putb(usb_target_new_pch);
	putb(usb_target_new_pcl);
	putCrlf();

	for (onion.w=0x300; onion.w<0x400; onion.w++)
		{
		if ((onion.w & 0x0f) == 0x00)
		puto(onion);
		putc(':');
		putbs(*onion.pb);
		if ((onion.w & 0x0f) == 0x0f)
			{
			putCrlf();
			}
		}

	puts("\r\nPress any key\r\n");

	for (b=0; !UartCharWaiting(); b++)
		{
		if (b & 1)
			asm("stp 7");
		else
			asm("clp 7");
		if (b & 2)
			asm("stp 6");
		else
			asm("clp 6");
		if (b & 4)
			asm("stp 5");
		else
			asm("clp 5");
		if (b & 8)
			asm("stp 4");
		else
			asm("clp 4");
		}
#endif //DEBUG_STACK

//	asm("rti");
the_end:
#endif // !WANT_LITE

	return;
}

void UsbPowered()
{
	static PBDT	pBDT;
	// we got the USB RESET indication. We simply need to go to the
	// DEFAULT state and enable endpoint 0 at addr 0.
	// First, assign EP0 an RX buffer

	if (bFirstDeviceDescriptorGets8Bytes)
		{
#if DEBUG_TRUNCATE
		puts("UsbPowered: will truncate next device descriptor\r\n");
#endif
		bTruncateNextDeviceDescriptor = TRUE;
		}

	memset(USB_NEXT_OUT, 0, ENDPOINTS);
	memset(USB_LAST_OUT, 0xff, ENDPOINTS);
	memset(USB_NEXT_IN, 0, ENDPOINTS);

	usb.intStatus = INT_STAT_MASK_TOKEN_DONE;	// clear pending token done
	usb.intStatus = INT_STAT_MASK_TOKEN_DONE;	// clear pending token done
	usb.intStatus = INT_STAT_MASK_TOKEN_DONE;	// clear pending token done
	usb.intStatus = INT_STAT_MASK_TOKEN_DONE;	// clear pending token done

// using subscripts is faster than pBDT++

	pBDT = USB_BDT_PAGE;	// pBDT points to EP0 even in buffer
	pBDT[0].addr.pb = (PBYTE)USB_BUFFER;
	pBDT[1].addr.pb = ((PBYTE)USB_BUFFER) + 64;
	pBDT[0].bc = pBDT[1].bc = 64;			// buffer size is 64 bytes even though we only need 8 now
	pBDT[0].pid = 0x80;		// own bit of EP0 RX=SIE (always change the OWN bit last!)
#if 0	// don't release it anymore
	pBDT[1].pid = 0x80;		// own bit of EP0 RX=SIE (always change the OWN bit last!)
#endif
	pBDT[2].addr.w = pBDT[3].addr.w = 0;
	pBDT[2].bc = pBDT[3].bc = 0;
	pBDT[2].pid = pBDT[3].pid = 0x00;

	setup.bRequestType = 0xff;	// invalidate bmRequestType

	USB_STATE = DEFAULT_STATE;	// change the state to be DEFAULT

#if DEBUG_STATE
	puts("Usb:DEFAULT_STATE\r\n");
#endif
	USB_CURR_CONFIG = 0;		// reset the current configuration to none

	usb.address = 0;				// USB addr=0 (default)
	usb.control = 0x03;				// clear the BDT ODD bits in the VUSB
	usb.control = 0x01;				// enable the VUSB
	ENDPT_RG[0] = ENDPT_CONTROL;	// endpoint 0 is a control pipe and requires an ACK
	usb.intEnable = 0xfd;			// enable all ints but ERROR
	usb.intStatus = usbSave.intStatus; // clear whatever interupts were set
	USB_ERROR_STAT.bits.reset = 1;	// set the bit in the diagnostic status register

#if WANT_HUB
	HubReset(0);		/* Warm reset the Hub (CEK 3/3/99) */
#endif

//	all done... return from interrupt!   <<<<<<EXIT>>>>>

	return;
}

void UsbSuspend()
{

	STALL("~40", "SUSPEND not supported");
	return;
}

void UsbStall(PBYTE p)
{

	puts("\a\r\nError:");
	puts(p);
	puts(" - stalling\r\n");
	putFlush();

	ENDPT_RG[usbSave.ep] |= ENDPT_STALL_BIT;	// stall endpoint zero on error condition

	return;
}

void UsbDefault()
{
	UsbCheckForSuspend();

	UsbConfig();
}

void UsbAddress()
{

	if (usbSave.intStatusMasked & INT_STAT_MASK_TOKEN_DONE)
		{
		if (IS_TOKEN_SETUP)
			{	// copy the 8 byte Device Request so we don't lose it.
			memcpy((PBYTE)&setup, cBDT.addr.pb, 8);
			}
		}

	UsbCheckForSuspend();

	if (usbSave.intStatusMasked & INT_STAT_MASK_TOKEN_DONE)
		{
		switch (setup.bRequestType & 0x60)
			{
			case 0x00:
				switch (setup.bRequest)
					{
					case  0:	//UsbGetStatus();		// ep0 only
					case  1:	//UsbClearFeature();	// ep0 only
					case  3:	//UsbSetFeature();	// ep0 only
								if (usbSave.ep)
									{
									STALL("~1", "UsbAddress: EP not 0");
									UsbProvideRxBDT(TRUE);			// release the RX BDT again now that we're done
									return;
									}
								break;

					case  7:	//UsbSetDescription();
					case 10:	//UsbGetInterface();
					case 11:	//UsbSetInterface();
					case 12:	//UsbSynchFrame();
								STALL("~2", "UsbAddress: bad request");
								UsbProvideRxBDT(TRUE);			// release the RX BDT again now that we're done
								return;
					}
			}
		}

	UsbConfig();
	return;
}

void UsbConfig()
{
	// In all cases we have to basically fully respond to all packet types
	// at least on EP0.

	if (usbSave.intStatusMasked & INT_STAT_MASK_RESET)
		{	// Bus reset, we don't process any of the other
			// interrupts, just reset the interface!
		UsbPowered();
		usb.intStatus = 0xff;	// clear all interrupts
		return;
		}

	if (usbSave.intStatusMasked & INT_STAT_MASK_TOKEN_DONE)
		{
#if DEBUG_PBDT
puts("UsbConfig: usbSave.pBDT=");
putw((WORD)usbSave.pBDT);
puts("->");
putbs(cBDT.pid);
putbs(cBDT.bc);
puto(cBDT.addr);
putCrlf();
#endif

		if (cBDT.pid & 0x80)	// you don't own me, i'm not one of your pretty toys
			{
			PUTS("~3", "UsbConfig: BDT owned by host\r\n\a");
			}

		switch (usbSave.status >> 4)	// switch based on endpoint number
			{
			case 0:
						{
						if (!IS_TOKEN_IN)
							UsbProvideRxBDT(TRUE);			// release the RX BDT again now that we're done

#if DEBUG_EP0
		// verbose for simulator/v8time
						if (IS_TOKEN_IN)
							UsbTokenDoneEP0in();
						else if (IS_TOKEN_SETUP)
							UsbTokenDoneEP0setup();
						else if (IS_TOKEN_OUT)
							UsbTokenDoneEP0out();
						else
							UsbTokenDoneEP0other();
#else
						UsbTokenDoneEP0();
#endif
						}
						break;

#if WANT_SOUND
			case ENDPOINT_SPEAKER:
						UsbTokenDoneEP1_Speaker();
						break;
#endif // WANT_SOUND
#if WANT_PRINTER
			case ENDPOINT_PRINTER:
						UsbTokenDoneEP3();
						break;
#endif
#if WANT_HUB
			case ENDPOINT_HUB:
						HubTokenDoneEPhub();
						break;
#endif
			default:	UsbTokenDoneEPn();
						break;
			}
		}

	if (usbSave.intStatusMasked & INT_STAT_MASK_STALL)
		USB_ERROR_STAT.bits.stall = 1;

	if (usbSave.intStatusMasked & INT_STAT_MASK_SOF)
		UsbSofDet();

	if (usbSave.intStatusMasked & INT_STAT_MASK_SLEEP)
		UsbSleep();

	if (usbSave.intStatusMasked & INT_STAT_MASK_RESUME)
		UsbResume();

	if (usbSave.intStatusMasked & INT_STAT_MASK_ERROR)
		UsbError();

// <<<<<<<<<<Primary EXIT point for the USB Interrupt Service>>>>>>>>>
	return;
}

void UsbProvideRxBDT(BOOL bOther)
{
	static ONION	onion;
	BYTE			ep;

	onion.pBDT = usbSave.pBDT;		// get current BDT into onion
	ep = usbSave.ep;

	// if this BDT belongs to a control endpoint, provide the other BDT.
	if (ENDPT_RG[ep] == ENDPT_CONTROL)
		{
		if (!bExtraRxBDT[ep])
			onion.b.l ^= 0x04;	// point to other BDT

		if (onion.pBDT->pid & 0x80)
			goto please_sir_may_i_have_another;	// been there done that
		}
	else
		{
		if (cBDT.pid & 0x80)
			return;	// been there done that
		}

//	onion.pBDT->addr.w ^= 0x0040;
	onion.pBDT->bc = 64;			// reset the byte count to 64 bytes
	onion.pBDT->pid = 0x88 | RECV_DATA01[ep];	// change OWN back to the VUSB (provide it)
	RECV_DATA01[ep] ^= 0x40;

please_sir_may_i_have_another:

	if (bOther && !bExtraRxBDT[ep])
		{
		bExtraRxBDT[ep] = TRUE;	// make note that we've provided an extra rx BDT

		onion.b.l ^= 0x04;	// point to other BDT

		if (onion.pBDT->pid & 0x80)
			return;	// we've already provided this buffer... we're done

//		onion.pBDT->addr.w ^= 0x0040;
		onion.pBDT->bc = 64;			// reset the byte count to 64 bytes
		onion.pBDT->pid = 0x88 | RECV_DATA01[ep];	// change OWN back to the VUSB (provide it)
		RECV_DATA01[ep] ^= 0x40;
		}

	return;
}

void UsbSofDet()
{
	static ONION	expected;
	static ONION	got;

//putc('$');
	expected.w = (USB_SOF_CTR + 1) & 0x07ff;	// 11 bits

	got.b.h = usbSave.frameNumHi;
	got.b.l = usbSave.frameNumLo;
	if (got.w != expected.w)
		{
#if DEBUG_SOF_MISSES
#if WANT_HARDWARE && !WANT_LITE
		if (debug.bits.SofErrors)
#endif
			{
			puts("SOF ");
			puto(expected);
			puts("!=");
			puto(got);
			putCrlf();
			}
#endif // DEBUG_SOF_MISSES
		expected.w = got.w;	// use actual as next expected
		}
	USB_SOF_CTR = expected.w;
	return;
}

void UsbSleep()
{
	// not entirely implemented
	
	USB_ERROR_STAT.bits.sleep = 1;

	if (!(usbSave.intStatus & INT_STAT_MASK_RESUME))
		{
		current_pwr_save_status = pwr_save_status;
		if (current_pwr_save_status.asleep)
			{
			pwr_save_polarity = pwr_save_status;
			*(PBYTE)&pwr_save_enable = 0x41;	// tms, hub_asleep
			*(PBYTE)&pwr_save_control = 0x02;	// sleep

			asm("or r0");	// NOP
			asm("or r0");	// NOP
			}
		}

}

void UsbResume()
{
	// not implemented
}

void UsbError()
{
	static BYTE	b, bError;
	static BYTE	bm;
	static PWORD	pw;

	bError = usbSave.errorStatus;
	usb.errorStatus = bError;	// clear error bits
	bError &= usb.errorEnable;	// mask off ones we are ignoring

#if 1
putc('*');
putb(bError);
#endif

	USB_ERROR_STAT.b[0] |= bError;	// add bits

	pw = USB_ERROR_CTR;
	for (b=0, bm=1; b<8; b++, bm<<=1)
		{
		if (bError & bm)
			pw[0]++;
		pw++;
		}

	if (USB_DEBUG & 0x80)
		{
		puts("\aError:");
		putb(bError);
		putCrlf();
		}

	return;
}


#if DEBUG_REGS_VERBOSE
void UsbDumpByte(BYTE bStat, BYTE bEnable, PBYTE *p)
{
	static BYTE	b, i;

	for (i=0, b=0x80; i<8; i++, b>>=1)
		{
		if (bStat & b)
			{
			if (bEnable & b)
				putc('+');
			else
				putc('-');
			puts(p[i]);
			putSpace();
			}
		}

	if (bStat)
		putCrlf();

	return;
}
#endif

#if DEBUG_EP0
void UsbTokenDoneEP0setup(void)
{
	UsbTokenDoneEP0();
}
void UsbTokenDoneEP0in(void)
{
	UsbTokenDoneEP0();
}
void UsbTokenDoneEP0out(void)
{
	UsbTokenDoneEP0();
}
void UsbTokenDoneEP0other(void)
{
	UsbTokenDoneEP0();
}
#endif // DEBUG_EP0

void UsbTokenDoneEP0(void)
{

	if (IS_TOKEN_SETUP)
		{	// copy the 8 byte Device Request so we don't lose it.
		memcpy((PBYTE)&setup, cBDT.addr.pb, 8);
		}

	if (setup.bRequestType == 0xff)
		{
		UsbEchoEP();
		return;
		}

	switch (setup.bRequestType & 0x60)
		{
		case 0x00:
			switch (setup.bRequest)
				{
				case  0:	UsbGetStatus();		return;
				case  1:	UsbClearFeature();	return;
				case  3:	UsbSetFeature();		return;
				case  5:	UsbSetAddress();		return;
				case  6:	UsbGetDescription();	return;
				case  7:	UsbSetDescription();	return;
				case  8:	UsbGetConfig();		return;
				case  9:	UsbSetConfig();		return;
				case 10:	UsbGetInterface();	return;
				case 11:	UsbSetInterface();	return;
				case 12:	UsbSynchFrame();		return;
				}

			STALL("~36", "UsbTokenDoneEP0: bad bRequest");
			return;
		case 0x20:
#if WANT_HUB
			HubClassSetup();
#endif
#if WANT_PRINTER
			PrinterClassSetup();
#endif
			return;
		case 0x40:
			UsbVendor();
			return;
		}

	STALL("~37", "UsbTokenDoneEP0: bad bRequestType");
	return;
}

void UsbGetStatus(void)
{
//	wValue=Zero
//	wIndex=Zero
//	wLength=1
//	DATA=bmERR_STAT
//	The GET_STATUS command is used to read the bmERR_STAT register.

// Return the status based on the bRrequestType bits:
// device (0) = bit 0 = 1 = self powered
//              bit 1 = 0 = DEVICE_REMOTE_WAKEUP which can be modified
//			with a SET_FEATURE/CLEAR_FEATURE command.
// interface(1) = 0000.
// endpoint(2) = bit 0 = stall.
	static PBYTE	pData;

	switch (cBDT.pid & 0x7c)
		{
		case 0x34:	// SETUP
			if (setup.bRequestType == 0x80)			// device req
				{
				pData = (PBYTE)&USB_STATUS_DEVICE;
#if DEBUG_USB_STATUS_DEVICE
	puts("UsbGetStatus: USB_STATUS_DEVICE=");
	putb(USB_STATUS_DEVICE);
	putCrlf();
#endif //DEBUG_USB_STATUS_DEVICE
				}
			else if (setup.bRequestType == 0x81)	// interface req
				{
				USB_STATUS_INTERFACE = 0;
				pData = (PBYTE)&USB_STATUS_INTERFACE;
				}
			else if (setup.bRequestType == 0x82)	// endpoint req
				{
				if (ENDPT_RG[setup.wIndex.b.l & 0x0f] & ENDPT_STALL_BIT)
					{
					USB_STATUS_ENDPOINT = 1;
					}
				else
					USB_STATUS_ENDPOINT = 0;
				pData = (PBYTE)&USB_STATUS_ENDPOINT;
				}
			else							// unknown req
				{
				STALL("~38", "UsbGetStatus BAD own");
				return;
				}

			UsbSendIn(0xc0, 2, pData, TRUE);
			break;

		case 0x64:	// IN
			return;

		case 0x44:	// OUT
			// invalidate bReqestType so we know we are done
			setup.bRequestType = 0xff;
			break;

		default:
			STALL("~4", "UsbGetStatus: Bad PID");
			return;
		}

}

void UsbClearFeature(void)
{
	BYTE	ep, i;
	ONION	onion;
	PBDT	pBDT;

	if (IS_TOKEN_SETUP_DATA0)
		{
		if (setup.bRequestType == 0)	// DEVICE
			{
			if (setup.wValue.w == 1)	// REMOTE WAKEUP
				{
				bRemoteWakeupEnabled = FALSE;
	#if WANT_HUB
				HubClearDeviceFeature();
	#endif

				USB_STATUS_DEVICE &= 0xfd;	// clear bit 1 - REMOTE WAKEUP
	#if DEBUG_USB_STATUS_DEVICE
		puts("UsbClearFeature: USB_STATUS_DEVICE=");
		putb(USB_STATUS_DEVICE);
		putCrlf();
	#endif //DEBUG_USB_STATUS_DEVICE
				}
			}
		else							// NOT DEVICE
			{
			if (setup.bRequestType != 2)
				{
				STALL("~6", "UsbClearFeature: not CLR_ENDPOINT");
				return;
				}
			if (setup.wValue.w)
				{
				STALL("~7", "UsbClearFeature: wValue not 0");
				return;
				}

			ep = setup.wIndex.b.l & 0x0f;

			onion.bdt.page = usbSave.bdtPage;
			onion.b.l = 0;	// clear zero, odd, out
			onion.bdt.ep = ep;

			bExtraRxBDT[ep] = FALSE;	// there is no longer an extra RX BDT

			for (i=0; i<4; i++)
				{
	#if DEBUG_DEQUEUE
				if (onion.pBDT->pid & 0x80)
					{
					puto(onion);
					puts(" - dequeueing\r\n");
					}
	#endif // DEBUG_DEQUEUE
				onion.pBDT->pid = 0x00;
				onion.pBDT->bc = 0;

		// there's no point in clearing the address, provideRxBDT would just have to set it again
		//		onion.pBDT->addr.w = 0;
				onion.pBDT++;
				}

			USB_NEXT_OUT[ep] = USB_LAST_OUT[ep] + 1;

			onion.bdt.page = usbSave.bdtPage;
			onion.b.l = 0;	// clear zero, odd, out
			onion.bdt.ep = ep;
			pBDT = &onion.pBDT[0];

			pBDT[0].bc = 0xff;
			pBDT[1].bc = 0xff;
			pBDT[0].addr.w = (WORD)USB_EPn_BUFFER0;
			pBDT[1].addr.w = (WORD)USB_EPn_BUFFER1;

			pBDT[USB_NEXT_OUT[ep]&1].pid = 0x8b;		// OWN=1, DTS=1, BCH=3
			pBDT[!(USB_NEXT_OUT[ep]&1)].pid = 0xcb;	// OWN=1, DATA01=1, DTS=1, BCH=3

			RECV_DATA01[ep] = 0x00;

			ENDPT_RG[ep] &= ~ENDPT_STALL_BIT;	// clear stall bit

			SEND_DATA01[ep] = 0x00;	// next in token from this ep will use data0
			}

		UsbSendInZero();	// ack
		return;
		}

	if (IS_TOKEN_IN_DATA1)
		{
		setup.bRequestType = 0xff;
		return;
		}

	STALL("~5", "UsbClearFeature: bad own");
	return;
}

void UsbSetFeature(void)
{
	static PBDT pTxBDT;

	if (!IS_TOKEN_SETUP_DATA0)	// !SETUP DATA0
		{
		if (!IS_TOKEN_IN_DATA1)	// !IN DATA1
			{
			STALL("~8", "UsbSetFeature: bad own");
			return;
			}
		return;
		}

	if (setup.bRequestType == 0)	// DEVICE
		{
		if (setup.wValue.w == 1)	// REMOTE WAKEUP
			{
			bRemoteWakeupEnabled = TRUE;
#if WANT_HUB
			HubSetDeviceFeature();
#endif

			USB_STATUS_DEVICE |= 0x02;	// set bit 1 - Remote Wakeup
#if DEBUG_USB_STATUS_DEVICE
	puts("UsbSetFeature: USB_STATUS_DEVICE=");
	putb(USB_STATUS_DEVICE);
	putCrlf();
#endif //DEBUG_USB_STATUS_DEVICE
			}
		}
	else							// NOT DEVICE
		{
		if (setup.bRequestType != 2)
			{
			STALL("~9", "UsbSetFeature: not CLR_ENDPOINT");
			return;
			}
		if (setup.wValue.w)
			{
			STALL("~10", "UsbSetFeature: wValue not 0");
			return;
			}
		ENDPT_RG[setup.wIndex.b.l & 0x0f] |= ENDPT_STALL_BIT;	// set stall bit
#if DEBUG_STALL
		puts("Stalling EP");
		putb(setup.wIndex.b.l & 0x0f);
		putCrlf();
#endif
		}

	pTxBDT = UsbSendInZero();

	if (setup.bRequestType)	// wait if not 0
		while (pTxBDT->pid & 0x80)
			;	// wait for own bit to clear

	return;
}

void UsbSetAddress(void)
{
	static PBDT pTxBDT, pRxBDT;
	
// We setup a TX packet of 0 length ready for the IN token
// Once we get the TOK_DNE interrupt for the IN token, then
// we change the ADDR register and go to the ADDRESS state.
// See section 9.4.6 rev 1.0 page 179 3rd paragraph of the USB Spec.

	if (bTruncateNextDeviceDescriptor)
		{
#if DEBUG_TRUNCATE
		puts("UsbSetAddress: will NOT truncate next device descriptor\r\n");
#endif
		bTruncateNextDeviceDescriptor = FALSE;
		}

	if (IS_TOKEN_SETUP_DATA0)
		{
		pTxBDT = UsbSendIn(0xc0, 0, 0, TRUE);
		pRxBDT = (PBDT)(((WORD)pTxBDT) & 0xfff3);	// mask off direction and parity

		while ((pTxBDT->pid & 0x80) && (pRxBDT[0].pid & 0x80) && (pRxBDT[1].pid & 0x80))
			;	// wait for own bit to clear

		if ((pTxBDT->pid & 0x80) == 0x00)			// got in token
			usb.address = setup.wValue.b.l;			// set new address
		return;							// now wait for the IN to complete.
		}
// ;;;; the following several lines keep the V8 in the interrupt 
// service routine to set the address VERY quickly.

// STATUS phase of the SET_ADDR transaction (there is no data phase)

	if (!IS_TOKEN_IN_DATA1)
		{
		STALL("~11", "UsbSetAddress: not In Data1");
//		return;
		}

	usb.address = setup.wValue.b.l;			// set new address
	USB_STATE = ADDRESS_STATE;
#if DEBUG_STATE
	puts("Usb:ADDRESS_STATE ");
	putb(usb.address);
	putCrlf();
#endif
	return;
}

PBYTE	pDataOut = NULL;
ONION	wDataOut = {0xee};
BOOL	bSendExtraNullPacket = FALSE;	// if descriptor size is a multiple of 
										// the packet size, send an extra null
										// packet

void UsbGetDescription(void)
{
	static WORD	wMax;
	static ONION	bytes;
// The Device Request can ask for Device/Config/string/interface/endpoint
// descriptors (via wValue). We then post an IN response to return the
// requested descriptor.
// And then wait for the OUT which terminates the control transfer.

	wMax = USB_MAX_PACKET[usbSave.ep];

	if (IS_TOKEN_SETUP)
		{
		// Load the appropriate string depending on the descriptor requested.

		switch (setup.wValue.b.h)
			{
			case 1:
				pDataOut = USB_DEVICE_DESC;
				// the first get device descriptor after a reset
				// should only return 8 bytes
				if (bTruncateNextDeviceDescriptor)
					{
					bTruncateNextDeviceDescriptor = FALSE;
					wDataOut.w = 8;
					}
				else // get size from bytes 7-8 of incoming token
					{
					if (setup.wLength.w > sizeof(USB_DEVICE_DESC))
						wDataOut.w = sizeof(USB_DEVICE_DESC);
					else
						wDataOut = setup.wLength;
					}
asm("stp 5");
				break;
			case 2:
				pDataOut = USB_CONFIG_DESC;
				if (setup.wLength.w > sizeof(USB_CONFIG_DESC))
					wDataOut.w = sizeof(USB_CONFIG_DESC);
				else
					wDataOut = setup.wLength;
asm("stp 5");
				break;
			case 3:
				USB_STR_0[0] = sizeof(USB_STR_0) - 1;
				USB_STR_1[0] = sizeof(USB_STR_1) - 1;
				USB_STR_2[0] = sizeof(USB_STR_2) - 1;
				USB_STR_3[0] = sizeof(USB_STR_3) - 1;
				USB_STR_4[0] = sizeof(USB_STR_4) - 1;
				USB_STR_5[0] = sizeof(USB_STR_5) - 1;
				USB_STR_6[0] = sizeof(USB_STR_6) - 1;
				USB_STR_7[0] = sizeof(USB_STR_7) - 1;
				USB_STR_8[0] = sizeof(USB_STR_8) - 1;
				USB_STR_n[0] = sizeof(USB_STR_n) - 1;

				if (setup.wValue.b.l > USB_STR_NUM)
					pDataOut = USB_STRING_DESC[USB_STR_NUM+1];
				else
					pDataOut = USB_STRING_DESC[setup.wValue.b.l];
				if (setup.wLength.b.l < pDataOut[0])
					wDataOut.b.l = setup.wLength.b.l;
				else
					wDataOut.b.l = pDataOut[0];
				wDataOut.b.h = 0;
				break;
			default:
				putb(setup.wValue.b.h);
				STALL("~12", " - UsbGetDescription: bad wValue");
				return;
			}
		// send the descriptor
		// first check to see how much the host wants and if it wants less than
		// we have, then only send it what it wants.
		// Then post buffers until all the data has been queued.

#if 0
		if (setup.wLength.w > wDataOut.w)	// host wants more than we have to send
			setup.wLength.w = wDataOut.w;	// so change wLength to the size we want to send.

		if (setup.wLength.w > wMax)	// more than a buffer's worth to send?
			bytes.w =  wMax;
		else
			bytes = setup.wLength;
#else
		if (wDataOut.w >  wMax)	// more than a buffer's worth to send?
			bytes.w =  wMax;
		else
			bytes = wDataOut;
#endif
asm("clp 5");

#if DEBUG_GETDESC
puts("wDataOut=");
putos(wDataOut);
puts("bytes=");
puto(bytes);
putCrlf();
putFlush();
#endif // DEBUG_GETDESC


		// DATA1 for first packet
		UsbSendIn(0xc0 | bytes.b.h, bytes.b.l, pDataOut, wDataOut.w == bytes.w);
		// SEND_DATA01 is now set to DATA0 for next packet

		wDataOut.w -= bytes.w;		// decrease count of bytes remaining
		pDataOut += bytes.w;		// increase pointer to output buffer

//	If you want to send a second buffer now, just remove the following return
		return;

//		// instead of returning at this point, we'll try to post another
//		// buffer if we have more data than fits in a buffer.
		}
	else if (IS_TOKEN_IN)
		{
		}
	else if (IS_TOKEN_OUT)
		{
		setup.bRequestType = 0xff;
		return;
		}
	else
		{
#if !WANT_LITE
		puts("pid=");
		putb(cBDT.pid);
		putCrlf();
#endif // !WANT_LITE
		STALL("~13", "UsbGetDescription: Bad PID");
		return;
		}

// SETUP and IN tokens fall into this

	if (!wDataOut.w)
		{
		if (!bSendExtraNullPacket)
			return;			// all done
		bSendExtraNullPacket = FALSE;
#if DEBUG_EXTRA_NULL
		puts("UsbGetDescription: sending extra null packet\r\n");
#endif
		}

// I don't trust this - Russell

#if DEBUG_GETDESC2
puts("wDataOut=");
puto(wDataOut);
putCrlf();
putFlush();
#endif // DEBUG_GETDESC

#if 0
	if (setup.wLength.w > wMax)	// more than a buffer's worth to send?
		bytes.w =  wMax;	// only send  wMax bytes
	else
		bytes = setup.wLength;	// send all bytes
#else
	if (wDataOut.w > wMax)	// more than a buffer's worth to send?
		bytes.w =  wMax;
	else
		bytes = wDataOut;
#endif

// if this is the last packet
//    then (wDataOut.w <= wMax) && !bSendExtraNullPacket
// we want to stall the other in bdt

	UsbSendIn(0x80 | bytes.b.h, bytes.b.l, pDataOut, (wDataOut.w <= wMax) && !bSendExtraNullPacket);
	// DATA01 is now toggled

	wDataOut.w -= bytes.w;	// decrease count of bytes remaining
	pDataOut += bytes.w;	// increase pointer to output buffer

// HACK alert
// we shouldn't do this at all.
// if we do do it the test should be (bytes.w == wMax)
// as it currently stands, it will send an extra null packet after every request

//	if (bytes.w <= wMax)
	if (bytes.w == wMax)
		bSendExtraNullPacket = TRUE;	// note to myself, send extra null packet

	return;
}

void UsbSetDescription(void)
{
	STALL("~14", "UsbSetDescription: not implemented");
	return;
}

void UsbGetConfig(void)
{
// Return the currently selected configuration

#if DEBUG_CONFIG
puts("UsbGetConfig: ");
putw((WORD)pBDT);
puts("->");
putb(cBDT.pid);
putCrlf();
#endif
	if (IS_TOKEN_SETUP_DATA0)
		{
		if (setup.bRequestType != 0x80)
			{
			STALL("~15", "UsbGetConfig: bad bRequestType");
			return;
			}
		UsbSendIn(0xc0, 1, &USB_CURR_CONFIG, TRUE);
		return;
		}

	if (IS_TOKEN_IN_DATA1)
		{
		return;
		}

	if (IS_TOKEN_OUT_DATA1)
		{
		setup.bRequestType = 0xff;
		return;
		}

	puts("pid=");
	putb(cBDT.pid);
	putCrlf();
	STALL("~3", "UsbGetConfig Bad PID");
	return;
}

void UsbSetConfig()
{
#if DEBUG_CONFIG
puts("UsbSetConfig: ");
putw((WORD)pBDT);
putb(cBDT.pid);
putCrlf();
#endif

//	USB_DUMP_COUNT = 0x40;		// number of ints to dump

	memset(SEND_DATA01, 0x00, ENDPOINTS);	// stores the Data1/0 PID
	memset(RECV_DATA01, 0x00, ENDPOINTS);	// stores the Data1/0 PID

	if (IS_TOKEN_SETUP_DATA0)
		{
		USB_CURR_CONFIG = setup.wValue.b.l;	// save the currently selected config value
		
		// config=0 indicates return to unconfig'd state
		if (!USB_CURR_CONFIG)
			{
			USB_STATE = ADDRESS_STATE;
			puts("USC:Addr=");
			putb(usbSave.address);
			putCrlf();
			UsbSendInZero();	// ack
			return;
			}

#if WANT_HUB
		HubSetConfiguration();
#endif

		if (USB_CURR_CONFIG != USB_CONFIG_DESC[5])
			{
			putb(USB_CURR_CONFIG);
			puts("!=");
			putb(USB_CONFIG_DESC[5]);
			UsbStall("UsbSetConfig");
			return;
			}

		USB_STATE = CONFIG_STATE;

#if WANT_SOUND
		{
static PBDT	pBDT;
		// init BDT for EP2
		pBDT = (PBDT)&USB_BDT_PAGE[ENDPOINT_SPEAKER*4+0];	// EP1 out even
		pBDT[0].pid = pBDT[1].pid = 0x80;
		pBDT[0].bc = pBDT[1].bc = 64;		// BC=64 (even though we only need 32)
		pBDT[0].addr.w = (WORD)&USB_SPEAKER_BUFF[0x000];
		pBDT[1].addr.w = (WORD)&USB_SPEAKER_BUFF[0x100];
		memset((PBYTE)&USB_BDT_PAGE[ENDPOINT_SPEAKER*4+2], 0, 8);	// clear in bdts
		ENDPT_RG[ENDPOINT_SPEAKER] = ENDPT_ISO_OUT;
		}
#endif

#if WANT_HUB
		{
static PBDT	pBDT;
		// init BDT for EP1
		pBDT = (PBDT)&USB_BDT_PAGE[ENDPOINT_HUB*4];		// EP1 out even
		memset((PBYTE)pBDT, 0, sizeof(BDT) * 4);
		pBDT->bc = PORT_BYTES;
		pBDT->addr.w = (WORD)ChangeSummary;

		pBDT++;											// EP1 out odd
		pBDT->bc = PORT_BYTES;
		pBDT->addr.w = (WORD)ChangeSummary;

		ENDPT_RG[ENDPOINT_HUB] = ENDPT_BULK_IN;
		}
#endif

#if WANT_PRINTER
		InitPrinterEndpoints();
#endif
		
		USB_IF_ALT[0] = USB_IF_ALT[1] = USB_IF_ALT[2] = 0;
		UsbSendInZero();	// ack

		return;
		}

	if (!IS_TOKEN_IN_DATA1)
		{
		putws((WORD)usbSave.pBDT);
		putb(cBDT.pid);
		STALL("~16", "UsbSetConfig: Bad PID");
		return;
		}

	// just return once the IN token has been acked
	return;
}

void UsbGetInterface(void)
{
	if (IS_TOKEN_SETUP_DATA0)
		{
		if (setup.bRequestType != 0x81)
			{
			STALL("~17", "UsbGetInterface: bad bRequestType");
			return;
			}

#if 0 && USB_NUM_IFACES
		if (setup.wIndex.b.l >= USB_NUM_IFACES)
			{
			STALL("~18", "UsbGetInterface: bad wIndex");
			return;
			}
#endif

		UsbSendIn(0xc0, 1, &USB_IF_ALT[setup.wIndex.b.l], TRUE);
		return;
		}

	if (IS_TOKEN_IN_DATA1)
		return;

	if (IS_TOKEN_OUT_DATA1)
		{
		setup.bRequestType = 0xff;
		return;
		}

	STALL("~19", "UsbGetInterface: bad pid");
	return;
}

void UsbSetInterface(void)
{
// we only have 1 setting and we allow the host to set it to the same value

	if (USB_DEBUG)
		{
		puts("I=");
		putbs(setup.bRequestType);
		putbs(setup.bRequest);
		putos(setup.wValue);
		putos(setup.wIndex);
		puto(setup.wLength);
		putCrlf();
		}

	if (IS_TOKEN_SETUP_DATA0)
		{
		if (setup.bRequestType != 0x01)
			{
			STALL("~20", "UsbSetInterface: bad bRequestType");
			return;
			}
		
#if 0 && USB_NUM_IFACES
		if (setup.wIndex.b.l >= USB_NUM_IFACES)
			{
			STALL("~21", "UsbSetInterface: bad wIndex");
			return;
			}
#endif

		// save new setting
		USB_IF_ALT[setup.wIndex.b.l] = setup.wValue.b.l;
		UsbSendInZero();	// ack
		return;
		}

	if (IS_TOKEN_IN_DATA1)
		return;

	if (IS_TOKEN_OUT_DATA1)
		{
		setup.bRequestType = 0xff;
		return;
		}

	STALL("~22", "UsbSetInterface: bad pid");
	return;
}

void UsbSynchFrame(void)
{
	if (IS_TOKEN_SETUP_DATA0)
		{
		if (setup.bRequestType != 0x02)
			{
			STALL("~23", "UsbSynchFrame: bad bRequestType");
			return;
			}
		
#if 0 && USB_NUM_IFACES
		if (setup.wIndex.b.l >= USB_NUM_IFACES)
			{
			STALL("~24", "UsbSynchFrame: bad wIndex");
			return;
			}
#endif

		UsbSendIn(0xc0, 2, (PBYTE)&USB_SOF_CTR, TRUE);
		return;
		}

	if (IS_TOKEN_IN_DATA1)
		return;

	if (IS_TOKEN_OUT_DATA1)
		{
		setup.bRequestType = 0xff;
		return;
		}

	STALL("~25", "UsbSynchFrame: bad pid");
	return;
}

#if WANT_SOUND
void UsbTokenDoneEP1_Speaker(void)
{
// We assume that EP2 is an ISO OUT EP to the AD1845 audio chip.
// Data is buffered in the packet buffer and copied to the AD1845 fifos
// immediately. Ideally, we really should wait until the SOF to copy the
// data so it aligns perfectly. For 3D audio this would be required but
// our application does not need that level of accuracy so we simply
// copy as soon as the packet is received.

	static PBYTE	ps;
	static BYTE	b, USB_SR11;

	if (!IS_TOKEN_OUT)
		{
		STALL("~26", "UsbTokenDoneEP1_Speaker: bad pid");
		return;
		}

//putc('$');
//putw((WORD)pBDT);

	ps = (PBYTE)cBDT.addr.w;
	USB_BYTES = cBDT.bc;
	AUDIO_BC++;

#if WANT_1394
	FWSendUsbAudio( xxx );
#endif

	AUDIO_ADDR = 11;	// underran the audio chip?
	USB_SR11 = AUDIO_DATA;		// read reg 11
	if ((AUDIO_STAT & 0x02) == 0)	// test PRDY
		{						// NOT PRDY
		if (USB_DEBUG)
			putc('~');
		AUDIO_ADDR = 9;			// make sure playback is enabled.
		b = AUDIO_DATA;
		if ((b & 0x01) == 0)	// if PEN not set
			goto EP2_drop_done;	// re-init it
		}

	if (AUDIO_STAT & 0x10)				// SOUR?
		{
		if (USB_DEBUG)
			putc('$');
		if (USB_SR11 & 0x40)			// underrun
			UsbChangeFreq(0xffff);
		}

	while (USB_BYTES)
		{
		if ((AUDIO_STAT & 0x02) == 0)	// test PRDY
			{
			UsbChangeFreq(0x0001);
			break;
			}

		AUDIO_PIO = *ps++;		// send next byte out
		USB_BYTES--;
		}

EP2_drop_done:
	cBDT.bc = 0xff;	// set byte count to 0x3ff

//BREAK_OWNS here

	cBDT.pid = 0x83;	// set OWNs bit
	*usbSave.pBDT = cBDT;	// copy local copy back to BDT

#if DEBUG_PBDT
puts("UsbTokenDoneEP1_Speaker: usbSave.pBDT=");
putw((WORD)usbSave.pBDT);
puts("->");
putbs(cBDT.pid);
putbs(cBDT.bc);
puto(cBDT.addr);
putCrlf();
#endif
}

void UsbChangeFreq(WORD wDelta)
{
	static ONION	onion;

	if (USB_DEBUG)
		{
		putc(wDelta & 0x8000 ? '-' : '+');
		}

	AUDIO_ADDR = 23;
	onion.b.l = AUDIO_DATA;
	AUDIO_ADDR = 22;
	onion.b.h = AUDIO_DATA;
	onion.w += wDelta;
	AUDIO_DATA = onion.b.h;
	AUDIO_ADDR = 23;
	AUDIO_DATA = onion.b.l;

	return;
}
#endif // WANT_SOUND

#if WANT_PRINTER
void UsbTokenDoneEP3(void)
{
// EP3 is a BULK in/out port that just sends/receives the data to/from the P1284 port.
// All actual processing is done in the IDLE loop with calls the
// USB_PRINTER routine once each time thru the idle loop. Data is sent
// to the printer in this way so that we don't slow down interrupt proccesing.
// In effect, EP3 is polled instead of interrupt driven. Being a bulk
// device with an unknown amount of delay from the printer after sending
// each byte made interrupt processing impractical as all other processing
// would stop until the printer finally became ready again.

	return;
}

void UsbPrinter()
{
// This is the routine that actually does all of the work!
	static ONION	onion;

	while (1)
		{
		if (USB_PRN_RUN)
			{
			if (PP_CTL.busy)	// printer busy
				return;			// YES, do nothing more

			// printer is ready for another byte
			PP_DATA = *USB_PRN_READ++;
			if (USB_PRN_END == USB_PRN_READ)	// EOB?
				{
				USB_PRN_PTR->bc = 64;	// reset the byte count to 64 bytes
// BREAK_OWNS
				USB_PRN_PTR->pid = 0x80;	// release this buffer
				USB_PRN_PTR = (PBDT)((WORD)USB_PRN_PTR ^ 0x04);	// point to other buffer
				}
			}

		// Check if the current buffer has data in it
		if (USB_PRN_PTR->pid & 0x80)	// no longer ours
			{							// nothing to do, clear the RUN flag
			USB_PRN_RUN = 0;
			return;
			}

		USB_PRN_READ = (PBYTE)USB_PRN_PTR->addr.w;	// start of buffer
		onion.b.l = USB_PRN_PTR->bc;
		onion.b.h = USB_PRN_PTR->pid & 0x03;
		USB_PRN_END = USB_PRN_READ + onion.w;	// end of buffer
		}
}
#endif // WANT_PRINTER

void UsbTokenDoneEPn(void)
{
// All other endpoints function in the diagnostic mode.
// If an OUT token is received, the data is posted to the IN BDT of the
// EP with EP_ADDR[0]=NOT EP_ADDR[0].

	putc('%');

	if (setup.bRequestType != 0xff)
		{
		STALL("~27", "UsbTokenDoneEPn: bad bRequestType");
		return;
		}

// if the bmRequestType=ff then we are not currently processing a SETUP 
// transaction.  We will just echo any OUT data to the IN and drop anything we 
// don't understand or if we don't have a buffer. This should only be used 
// during diagnostic testing.

	UsbEchoEP();
	return;
}

void UsbEchoEP(void)
{
	if (!IS_TOKEN_OUT)
		return;

	UsbProvideRxBDT(TRUE);			// release the RX BDT again now that we're done

	UsbSendIn(0x80 | (cBDT.pid & 0x03), cBDT.bc, (PBYTE)cBDT.addr.w, FALSE);
}

PBDT UsbSendInZero()	// ack
{

	return UsbSendIn(0xc0, 0, 0x0000, TRUE);
}

PBDT UsbSendIn(BYTE pid, BYTE bc, PBYTE pData, BOOL bStall)
{
//	This routine is THE ONLY routine allowed to post packets for
//	transmission on EP0. It keeps track of which buffer to use (even or
//	or odd) and which one is to be used next. RESET must initialzize it's
//	state variable USB_NEXT_OUT to 0x01.
//	R0=OWN byte (80 or c0), R1=BC, R3/R2=addr of buffer to send.

	static ONION	onion;
	static PBDT		pTxBDT;
#if DEBUG_SEND_IN
	static BYTE	skip = 0;
#endif

	USB_LED_SEND_ON;

#if DEBUG_SEND_IN && !WANT_LITE
	if (debug.bits.UsbSend)
		{
		if (skip)
			skip--;
		if (!skip)
			{
			puts("UsbSendIn:");
			putbs(usbSave.ep);
			putb(pid);
			putb(bc);
			putw((WORD)pData);
			puts(" In:");
			putw((WORD)pBDT);
			puts("->");
			putb(cBDT.pid);
			putb(cBDT.bc);
			putos(cBDT.addr);
			putbs(USB_NEXT_OUT[usbSave.ep]);
			}
		}
#endif

	onion.pBDT = usbSave.pBDT;
	onion.bdt.out = 1;
	onion.bdt.odd = USB_NEXT_OUT[usbSave.ep]++;
	pTxBDT = onion.pBDT;

#if DEBUG_SEND_IN2 && !WANT_LITE
	if (debug.bits.UsbSend)
		{
		static BYTE	b;

		for (b=0; b<4; b++)
			{
			putw((WORD)&USB_BDT_PAGE[b]);
			putc('>');
			putbs(USB_BDT_PAGE[b].pid);
			putbs(USB_BDT_PAGE[b].bc);
			putos(USB_BDT_PAGE[b].addr);
			}
		putCrlf();
		putFlush();
		}
#endif

	if (pTxBDT->pid & 0x80)
		{	// we don't own the buffer
		putw((WORD)pTxBDT);
		PUTS("~41", " - USB Buffer not OWNed\r\n");
		return NULL;
		}

	pTxBDT->bc = bc;
	pTxBDT->addr.w = (WORD)pData;

	if ((pid & 0x40) == 0)	// if DATA1 is clear
		pid |= SEND_DATA01[usbSave.ep];	// get value from SEND_DATA01

	SEND_DATA01[usbSave.ep] = (pid & 0x40) ^ 0x40;	// toggle bit for next packet

	pTxBDT->pid = pid;

//if (pid & 0x04)
//	puts("\r\n\apid & 0x04\r\n");

#if DEBUG_SEND_IN && !WANT_LITE
	if (debug.bits.UsbSend)
		if (!skip)
			{
			puts("Out:");
			putw((WORD)pTxBDT);
			puts("->");
			putb(pTxBDT->pid);
			putb(pTxBDT->bc);
			puto(pTxBDT->addr);
			putCrlf();
			putFlush();
			}
#endif

	if (bStall)	// set stall bit on other out bdt
		{
		onion.pBDT = pTxBDT;
		onion.b.l ^= 0x04;
		onion.pBDT->pid = 0xc4;		// owns and stall and data1
		}

	USB_LED_SEND_OFF;

	return pTxBDT;
}


// Two types of accesses will be supported by the diagnostic endpoint:
//	Status transactions and Loop-back requests.
//
// Status transactions make use of the vendor specific device requests.
// These transactions use the same format as specified in section 9.3 of the
// USB rev1.0 specification.
// The bmRequestType values for these Device Requests should be of TYPE=Vendor
// D6..5=2 or in binary=x1000000. Bit 7 should reflect the direction of the
// transaction.
// Status transactions are only supported on EP0.
//
// The new bmRequest values are:
//		bRequest	Action
//			0		SET_STATUS
//			1		GET_STATUS
//			2		SET_EP_CTL
//			3		GET_EP_CTL
//			4		SET_MEM
//			5		GET_MEM
//			6		BREAK_OWNS
// 
//		wValue - for set status and set endpoint ctl the wValue contains the data
//			to be writen to the register.
//		wIndex - contains address information for endpoint and memory operatons.
//		wLength - set the length of the data packet that follows the get or set
//			descriptor packet.
//SET_STATUS:
//	wValue=value to set the bmERR_STAT register to.
//	wIndex=Zero
//	wLength=Zero
//	DATA=none.
//	The SET_STATUS command is used to write the bmERR_STAT register.
//GET_STATUS:
//	wValue=Zero
//	wIndex=Zero
//	wLength=1
//	DATA=bmERR_STAT
//	The GET_STATUS command is used to read the bmERR_STAT register.
//SET_EP_CTL:
//	wValue=value to set the bmEP_n_CTL register to.
//	wIndex=EP number to be set (0-15)
//	wLength=Zero
//	DATA=none.
//	The SET_EP_CTL command is used to write the bmEP_n_CTL register.
//GET_EP_CTL:
//	wValue=Zero
//	wIndex=EP number to be read (0-15)
//	wLength=2
//	DATA=bmEP_n_CTL
//	The GET_EP_CTL command is used to read the bmEP_n_CTL register.
//SET_MEM:
//	wValue=Zero
//	wIndex=Address in memory
//	wLength=number of bytes to write
//	DATA=Data to be written to memory
//	The SET_MEM command is used to write anywhere in the V8 address space.
//GET_MEM:
//	wValue=Zero
//	wIndex=Address in memory
//	wLength=number of bytes to read
//	DATA=Data read from memory
//	The GET_MEM command is used to read from anywhere in the V8 address space.
//BREAK_OWNS:
//	wValue=0 or 1
//	wIndex = 0
//	wLength = 0
//	DATA = None
//	if wValue = 1, all non-ep0 owns bits won't be set (ask Chris)
//
// LoopBack requests are handled by simply echoing any OUT packets on EP0 to
// the EP0 IN Queue. The Host can then retrieve the echoed data by sending
// and IN PID. If the V8 does not have a BDT to echo the packet to, the packet
// is simply dropped. In normal operation, the Host should never do IN or OUT
// tokens to EP0 without a SETUP token. Remember, this feature is meant to
// be used ONLY for diagnostic purposes and you may want to remove this code for
// production devices. This code will HAVE to be removed if you wish to transfer
// data on EP0 via IN ot OUT transactions.

void UsbVendor(void)
{
	switch (setup.bRequest)
		{
		case 0:	UsbVendSetStatus();		return;
		case 1:	UsbVendGetStatus();		return;
		case 2:	UsbVendSetEndPoint();	return;
		case 3:	UsbVendGetEndPoint();	return;
		case 4:	UsbVendSetMemory();		return;
		case 5:	UsbVendGetMemory();		return;
		case 6:	UsbVendBreakOwns();		return;
		}

	STALL("~28", "UsbVendor: bad bRequest");
	return;
}

void UsbVendSetStatus(void)
{
	static BYTE	b;

	if (IS_TOKEN_SETUP_DATA0)
		{
		usb.errorStatus = setup.wValue.b.l;	// immeadiately clear bits no longer wanted
		b = setup.wValue.b.l ^ 0xff;
		USB_ERROR_STAT.b[0] &= b;
		b = setup.wValue.b.h ^ 0xff;
		USB_ERROR_STAT.b[1] &= b;
		UsbSendInZero();
		return;
		}

	if (IS_TOKEN_IN_DATA1)
		{								// we're done
		setup.bRequestType = 0xff;
		return;
		}
	
	STALL("~29", "UsbVendSetStatus: bad pid");

	return;
}

void UsbVendGetStatus(void)
{
	if (IS_TOKEN_SETUP_DATA0)
		{
		USB_ERROR_STAT.b[0] |= usb.errorStatus;	// add current error bits
		UsbSendIn(0xc0, 2, (PBYTE)&USB_ERROR_STAT, TRUE);
		return;
		}

	if (IS_TOKEN_IN_DATA1)
		return;							// we're done

	if (IS_TOKEN_OUT_DATA1)
		return;							// we're done

	STALL("~30", "UsbVendGetStatus: bad pid");
	return;
}

void UsbVendSetEndPoint(void)
{
//	static PBDT	pBDT;
	ONION	onion;
	BYTE	ep;

	if (IS_TOKEN_SETUP_DATA0)
		{
		ep = setup.wIndex.b.l & 0x0f;
		ENDPT_RG[ep] = setup.wValue.b.l;
#if DEBUG_STALL
		puts("EP");
		putb(ep);
		putc('=');
		putb(ENDPT_RG[ep]);
		putCrlf();
#endif

// if the Rx enable bit was set then set the owns bit and length fields of the Rx BDT
// So the endpoint will be ready to receive data.  If not clear the owns bits.


#if 1
		INIT_ONION_WITH_BDT_FOR_EP(onion,ep);	// point to BDT for specified EP

		if (setup.wValue.b.l & 0x08)
			{
			onion.pBDT[2].pid = 0;	// clear OWNs bit in IN 0
			onion.pBDT[3].pid = 0;	// clear OWNs bit in IN 1
			}

		if (setup.wValue.b.l & 0x04)
			{
			onion.pBDT[0].bc = 0xff;
			onion.pBDT[1].bc = 0xff;
			onion.pBDT[0].addr.w = (WORD)USB_EPn_BUFFER0;
			onion.pBDT[1].addr.w = (WORD)USB_EPn_BUFFER1;

			onion.pBDT[USB_NEXT_OUT[ep]&1].pid = 0x8b;		// OWN=1, DTS=1, BCH=3
			onion.pBDT[!(USB_NEXT_OUT[ep]&1)].pid = 0xcb;	// OWN=1, DATA01=1, DTS=1, BCH=3
			}
#else
		pBDT = &USB_BDT_PAGE[(BYTE)(ep << 2)];	// point to BDT for specified EP

		if (setup.wValue.b.l & 0x08)
			{
			pBDT[2].pid = 0;	// clear OWNs bit in IN 0
			pBDT[3].pid = 0;	// clear OWNs bit in IN 1
			}

		if (setup.wValue.b.l & 0x04)
			{
			pBDT[0].bc = 0xff;
			pBDT[1].bc = 0xff;
			pBDT[0].addr.w = (WORD)USB_EPn_BUFFER0;
			pBDT[1].addr.w = (WORD)USB_EPn_BUFFER1;

			pBDT[USB_NEXT_OUT[ep]&1].pid = 0x8b;		// OWN=1, DTS=1, BCH=3
			pBDT[!(USB_NEXT_OUT[ep]&1)].pid = 0xcb;	// OWN=1, DATA01=1, DTS=1, BCH=3
			}
#endif
                SEND_DATA01[ep] = 0;  // clear the data toggle bit for data TX
                RECV_DATA01[ep] = 0;  // clear the data toggle bit for data RX


		UsbSendInZero();			// ack
		return;
		}

	if (IS_TOKEN_IN_DATA1)
		{
		setup.bRequestType = 0xff;
		return;
		}

	STALL("~31", "UsbVendSetEndPoint: bad pid");

	return;
}

void UsbVendGetEndPoint(void)
{

	if (IS_TOKEN_SETUP_DATA0)
		{
		USB_ENDPOINT_CONTROL = ENDPT_RG[setup.wIndex.b.l & 0x0f];
		UsbSendIn(0xc0, 1, &USB_ENDPOINT_CONTROL, TRUE);
		return;
		}

	if (IS_TOKEN_IN_DATA1)
		return;

	if (IS_TOKEN_OUT_DATA1)
		return;

	STALL("~32", "UsbVendGetEndPoint: bad pid");
	return;
}

void UsbVendSetMemory(void)
{
// Have a problem here... since we've posted 2 buffers already, we may have 
// already put data in buffer space and not where we really want it. It either 
// has to be copied (slow and not a great thing to do in an interrupt routine) 
// or we have to copy this one only and then post others to memory or never 
// release more than 1 RX buffer. hmmm....
// The best thing is to release only 1 RX buffer at a time. Shouldn't have an 
// impact since we really need to know what we're doing before releasing 
// double buffers. And we need to know how many buffers to release all together

// If the PID=setup, then set the DATA1/0 bit,
// If wLength=0, we're done so do nothing,
// subtract 64 from wLength and post the new packet
// and store the new wLength and wIndex out.
// we can send.

	static BYTE	b;

	if (IS_TOKEN_SETUP)
		SEND_DATA01[usbSave.ep] = 0x00;

	if (IS_TOKEN_IN_DATA1)
		{
		setup.bRequestType = 0xff;
		return;
		}

	if (!setup.wLength.w)
		return;			// wlength is zero, just return.

// 64 should match descriptor???

	if (setup.wLength.w > 64)
		b = 64;
	else
		b = setup.wLength.b.l;

// need to write current buffer somewhere

	setup.wLength.w -= b;
	
	return;
}

void UsbReleaseTx()
{
// NOT IMPLEMENTED
	return;
}

void UsbVendGetMemory(void)
{
// NOT IMPLEMENTED
	return;
}

void UsbVendBreakOwns(void)
{
	static BYTE	i;
	static PBDT	pBreakBDT;

	if (IS_TOKEN_SETUP_DATA0)
		{
		USB_BREAK_OWNS = setup.wValue.b.l;
		pBreakBDT = (PBDT)USB_BDT_PAGE;
		pBreakBDT += 4;
		for (i=ENDPOINTS; i; i--)
			{
			if (USB_BREAK_OWNS)
				{
				pBreakBDT->pid &= 0x7f;
				pBreakBDT++;
				pBreakBDT->pid &= 0x7f;
				}
			else
				{
				pBreakBDT->pid |= 0x80;
				pBreakBDT++;
				pBreakBDT->pid |= 0x80;
				}
			pBreakBDT += 3;
			}
		UsbSendInZero();			// ack
		return;
		}

	if (IS_TOKEN_IN_DATA1)
		{
		setup.bRequestType = 0xff;
		return;
		}

	STALL("~33", "UsbVendBreakOwns: bad pid");
	return;
}

void UsbEnableReset()
{
	usb.intEnable = 1;				// enable only bus reset
}

//////// the following are not called from the usb int service vector ////////

void UsbInit()
{
// USBInit initializes the USB interface.
// the BDTs are NOT intialized here! They are initialized as they are enabled.
	static ONION	onion;

#if WANT_HARDWARE
#if DEBUG_STATE
	puts("UsbInit:\r\n");
#endif	// DEBUG_STATE
#endif	// WANT_HARDWARE

	usb.control = 0;		// disable the VUSB
	usb.intEnable = 0;		// mask all interupts

	usbSave.ep = 0;

	USB_MAX_PACKET[0] = USB_BUFFER_SIZE;
	USB_DEVICE_DESC[7] = USB_BUFFER_SIZE;

//	USB_HUB_CONFIG_DESC[2] = sizeof(USB_HUB_CONFIG_DESC) & 0xff;
//	USB_HUB_CONFIG_DESC[3] = sizeof(USB_HUB_CONFIG_DESC) >> 8;

//	USB_DEBUG = 1;			// 0=debug messages off, 1=on
	USB_DUMP = 0;
	USB_STATE = 0;			// Current USB state (POWERED,DEFAULT,ADDRESS,CONFIG,SUSPEND)
	USB_CURR_CONFIG = 0;	// Current USB configuration selected
	USB_SOF_CTR = 0xffff;	// reserve 2 bytes for a frame counter
	USB_SOF_ENB = 0;		// SOF checking is enabled when non zero

	memset(SEND_DATA01, 0x00, ENDPOINTS);	// stores the Data1/0 PID
	memset(RECV_DATA01, 0x00, ENDPOINTS);	// stores the Data1/0 PID
	USB_ERROR_STAT.w = 0;	// error status
	AUDIO_BC = 0;			// 16 bit counter of the number of bytes sent down
	USB_BYTES = 0;
	USB_BREAK_OWNS = 0;		// 1 if non-EP0's should not set owns bit
	USB_ENDPOINT_CONTROL = 0;	// value returned from GetEndpoint

	memset(USB_NEXT_OUT, 0, ENDPOINTS);
	memset(USB_LAST_OUT, 0xff, ENDPOINTS);
	memset(USB_NEXT_IN, 0, ENDPOINTS);

	// alternate settings for up to USB_NUM_IFACES interfaces
	USB_IF_ALT[0] = USB_IF_ALT[1] = USB_IF_ALT[2] = 0;

	// USB_PRINTER variables
	USB_PRN_RUN = 0;	// 0=no buffer actively printing
	USB_PRN_READ = NULL;	// current position in the buffer
	USB_PRN_END = NULL;	// last position in the buffer
	USB_PRN_PTR = 0;	// Pointer to the USB BDT in use

	setup.bRequestType = 0xff;
	USB_ERROR_CTR[0] = USB_ERROR_CTR[1] = USB_ERROR_CTR[2] = USB_ERROR_CTR[3] = 
	USB_ERROR_CTR[4] = USB_ERROR_CTR[5] = USB_ERROR_CTR[6] = USB_ERROR_CTR[7] = 0;
	USB_DUMP_COUNT = 0xf0;		// number of ints to dump
	USB_STATUS_DEVICE = 1;		// Device status = self-powered.
#if DEBUG_USB_STATUS_DEVICE
	puts("UsbInit: USB_STATUS_DEVICE=");
	putb(USB_STATUS_DEVICE);
	putCrlf();
#endif //DEBUG_USB_STATUS_DEVICE
	USB_STATUS_INTERFACE = 0;	// interface status
	USB_STATUS_ENDPOINT = 0;	// EP status


// Quickly do a register read/write test to the 8 bit ErrorEnable register.
// If its fully read/write we know the interface works.

#if WANT_HARDWARE
	if (!UsbRegRW(0xaa))
		return;
	if (!UsbRegRW(0x55))
		return;
	if (!UsbRegRW(0xf0))
		return;
	if (!UsbRegRW(0x0f))
		return;
#endif

	if (!UsbRegRW(0x7f))
		return;

#if WANT_FIFO_TEST
	{
	BYTE	b;
	// test FIFO
	USB_FIFO_TEST = 1;
// test RX
	USB_FIFO_RX = 0xaa;
	USB_FIFO_RX = 0x55;
	USB_FIFO_RX = 0x1;
	USB_FIFO_RX = 0x2;
	b = USB_FIFO_RX;
	if (b != 0xaa)
		{
		puts("rxFifo expected aa, got ");
		putb(b);
		putCrlf();
		}
	b = USB_FIFO_RX;
	if (b != 0x55)
		{
		puts("rxFifo expected 55, got ");
		putb(b);
		putCrlf();
		}
	b = USB_FIFO_RX;
	if (b != 0x01)
		{
		puts("rxFifo expected 01, got ");
		putb(b);
		putCrlf();
		}
	b = USB_FIFO_RX;
	if (b != 0x02)
		{
		puts("rxFifo expected 02, got ");
		putb(b);
		putCrlf();
		}
// test TX
	USB_FIFO_TX = 0xaa;
	USB_FIFO_TX = 0x55;
	USB_FIFO_TX = 0x1;
	USB_FIFO_TX = 0x2;
	b = USB_FIFO_TX;
	if (b != 0xaa)
		{
		puts("txFifo expected aa, got ");
		putb(b);
		putCrlf();
		}
	b = USB_FIFO_TX;
	if (b != 0x55)
		{
		puts("txFifo expected 55, got ");
		putb(b);
		putCrlf();
		}
	b = USB_FIFO_TX;
	if (b != 0x01)
		{
		puts("txFifo expected 01, got ");
		putb(b);
		putCrlf();
		}
	b = USB_FIFO_TX;
	if (b != 0x02)
		{
		puts("txFifo expected 02, got ");
		putb(b);
		putCrlf();
		}

	USB_FIFO_TEST = 0;
	}
#endif

// OK, assume the USB SIE is functional... and leave 0x7f in usb.errorEnable

// clear the USB buffer memory - OPTIONAL!
#if WANT_HARDWARE
	memset((PBYTE)USB_BUFFER, 0x90, 0xa8);
#endif

// insert the interrupt service routine into the proper vector
	Interrupt1 = (WORD)UsbTargetIntService;

#if WANT_HUB
	Interrupt2 = (WORD)HubFrameIntService;
#endif

	usb.address = 0;
	speed = 0;
//	usb.bdtPage = ((WORD)USB_BDT_PAGE) >> 8;
	onion.pBDT = USB_BDT_PAGE;
	usb.bdtPage = onion.b.h;

// disable all endpoints
	memset((PBYTE)&ENDPT_RG[0], ENDPOINTS, ENDPT_DISABLE);

	USB_STATE = POWERED_STATE;	// we are now in the powered state
#if WANT_HARDWARE
#if DEBUG_STATE
	puts("Usb:POWERED_STATE\r\n");
#endif	// DEBUG_STATE
#endif	// WANT_HARDWARE

	usb.intStatus = 0xfe;			// Clear all interrupts except RESET

// init some BDTs
	memset((PBYTE)USB_BDT_PAGE, 128, 0);

	USB_SOF_ENB = 1;			// enable SOF checking to start with...
	USB_PRN_RUN = 0;			// clear printer buffer operation
	*(PBYTE)0x7d30 = 0;			// clear printer buffers
	*(PBYTE)0x7d34 = 0;			// clear printer buffers
	usb.control = 1;					//WORD  =the//VUSB

// All done... We're now in POWERED state and ready to go to DEFAULT.
// if debug mode, send a message
#if WANT_HARDWARE
	if (USB_DEBUG)
		puts("USB Enabled\r\n\a");
#endif	// WANT_HARDWARE
	//moved outside usbInit
	// 	usb.intEnable = 1;				// enable only bus reset

#if WANT_HUB
	HubReset(1);
#endif

	return;
}

BOOL UsbRegRW(BYTE b)
{
// Very quick register READ/WRITE test of the 8 bit R/W USB registers.
// write R0+reg offset to 6 registers, then read it.
	static BYTE b2;
#if !WANT_LITE
	int iFailCount = 0;

repeat:
#endif
	usb.errorEnable = b;	//save the expected value
	b2 = usb.errorEnable;
	if (b == b2)
		return TRUE;
#if WANT_LITE
	puts(" \aUSB Failed BIST\r\n");
	return FALSE;
#else
	iFailCount++;
	if (iFailCount == 1)
		{
		puts("\r\n\aERROR:USB Failed BIST\r\n\aExpected=");
		putb(b);
		puts(" Actual=");
		putb(b2);
		putFlush();
		}
	else
		{
		putw(iFailCount);
		iFailCount++;
		if (UartCharWaiting())
			return FALSE;
		}
	putCrlf();
	goto repeat;
#endif
}

void UsbCheckForSuspend(void)
{
//	static ONION tx;

	if (usbSave.intStatusMasked & INT_STAT_MASK_TOKEN_DONE)
		if (IS_TOKEN_SETUP)		// if it is a setup token
			if (usbSave.control & MASK_CTL_TXD_SUSPEND)	// and the txd_suspend bit is set
				{								// dequeue any pending packets
//				tx.b.h = usbSave.bdtPage;
//				tx.b.l = (usbSave.status & 0xf8) | 0x08;	// even tx bdt
				UsbDequeue();
				}
}

void UsbDequeue()
{
	static ONION	onion;
	static BYTE		i;

	onion.bdt.page = usbSave.bdtPage;
	onion.b.l = 0;	// clear zero, odd, out
	onion.bdt.ep = usbSave.ep;

	bExtraRxBDT[usbSave.ep] = FALSE;	// there is no longer an extra RX BDT

	for (i=0; i<4; i++)
		{
#if DEBUG_DEQUEUE
		if (onion.pBDT->pid & 0x80)
			{
			puto(onion);
			puts(" - dequeueing\r\n");
			}
#endif // DEBUG_DEQUEUE
		onion.pBDT->pid = 0x00;
		onion.pBDT->bc = 0;

// there's no point in clearing the address, provideRxBDT would just have to set it again
//		onion.pBDT->addr.w = 0;
		onion.pBDT++;
		}

// clear endpoint stall bit here

	usb.control &= ~MASK_CTL_TXD_SUSPEND;	// clear the txd_suspend bit
	usbSave.control = usb.control;

	USB_NEXT_OUT[usbSave.ep] = USB_LAST_OUT[usbSave.ep] + 1;

	return;
}

#if WANT_PRINTER
typedef struct
	{
	BYTE	spare:3,	// 0-2
			fault_n:1,	// 3
			select:1,	// 4
			perror:1;	// 5
	} PRINTER_CLASS_PORT_STATUS;

PRINTER_CLASS_PORT_STATUS printerClassPortStatus;

void PrinterClassSetup()
{
// process class specific SETUP transactions on EP0.
#if DEBUG_CLASS_SETUP
	puts("PrinterClassSetup: rt=");
	putb(setup.bRequestType);
	puts(" r=");
	putbs(setup.bRequest);
	putws(setup.wValue.w);
	putws(setup.wIndex.w);
	putw(setup.wLength.w);
	putCrlf();
#endif

	if (setup.bRequestType == 0x23 && setup.bRequest == 0x02)
		{	// SoftReset(0,      interface, 0,       none)
			//           wValue, wIndex,    wLength, Data
		switch (cBDT.pid & 0x7c)
			{
			case 0x34:	// SETUP
				Init1284();
				InitPrinterEndpoints();

				UsbSendInZero();
				goto done;

			case 0x64:		// In token, DATA phase
				goto done;
			}
		goto booboo;
		}

	if (setup.bRequestType == 0xa1 && setup.bRequest == 0x00)
		{	// GetDeviceID(config index, ifc & alt, Max length, 1284 device id string)
			//             wValue,       wIndex,    wLength,    Data
		switch (cBDT.pid & 0x7c)
			{
			case 0x34:		// SETUP token,send the data packet
				UsbSendIn(0xc0, DEVICE_ID_LENGTH, DEVICE_ID_1284, FALSE);
				break;
			case 0x64:		// In token, DATA phase
			case 0x24:		// In token, DATA phase
				break;
			case 0x44:		// OUT token, Status phase, we're done
				setup.bRequestType = 0xff;
				break;
			default:
				goto booboo;
			}
		goto done;
		}

	if (setup.bRequestType == 0xa1 && setup.bRequest == 0x01)
		{	// GetPortStatus(0, ifc,    1,       byte)
			//                  wIndex, wLength, Data
		switch (cBDT.pid & 0x7c)
			{
			case 0x34:		// SETUP token,send the data packet
				*(PBYTE)&printerClassPortStatus = 0;
				printerClassPortStatus.perror = PP_CTL.perror;
				printerClassPortStatus.select = PP_CTL.select;
				printerClassPortStatus.fault_n = PP_CTL.fault_n;
				UsbSendIn(0xc0, 1, (PBYTE)&printerClassPortStatus, FALSE);
				break;
			case 0x64:		// In token, DATA phase
			case 0x24:		// In token, DATA phase
				break;
			case 0x44:		// OUT token, Status phase, we're done
				setup.bRequestType = 0xff;
				break;
			default:
				goto booboo;
			}
		goto done;
		}


booboo:
	putbs(cBDT.pid);
	putbs(setup.bRequestType);
	putbs(setup.bRequest);
	PUTS("~35", "PrinterClassSetup: Bad PID");
	goto done;

done:
	return;
}

void InitPrinterEndpoints()
{
static PBDT	pBDT;

	// init BDT for EP3
	pBDT = (PBDT)&USB_BDT_PAGE[ENDPOINT_PRINTER*4+0];	// EP3 out even
	pBDT[0].pid = pBDT[1].pid = 0x80;
	pBDT[0].bc = pBDT[1].bc = 64;		// BC=64
	pBDT[0].addr.pb = USB_PRINTER_BUFF;
	pBDT[1].addr.pb = USB_PRINTER_BUFF + 0x40;
	memset((PBYTE)&USB_BDT_PAGE[ENDPOINT_PRINTER*4+2], 0, 8);	// clear in bdts
	ENDPT_RG[ENDPOINT_PRINTER] = ENDPT_BULK_BIDIR;
	USB_PRN_RUN = 0;
	return;
}
#endif // WANT_PRINTER

