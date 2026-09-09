// host.c

#define HOST_C		1

#include "vauto.h"
#include "uart.h"
#include "host.h"
#if WANT_HOST
#include "host_int.h"
#endif // WANT_HOST
#include "usb_drv.h"
#include "usb_glob.h"
#if WANT_PRINTER
#include "printer.h"
#endif

#define DEBUG_DESCRIPTOR		0
#define DEBUG_DEVICE_DESC		0
#define DEBUG_BDT				0
#define DEBUG_OUT_TOKENS		0
#define DEBUG_SEND_TOKEN		0
#define DEBUG_USB				0
#define DEBUG_USB_ATTACH		0
#define DEBUG_ADDRESS			0
#define DEBUG_IN_SO_FAR			0
#define USB_CHAPTER9			0
#define DEBUG_CONFIG			0
#define DEBUG_PARTIAL			0
#define DEBUG_USB_STRINGS		0
#define DEBUG_META_STATES		0
#define DEBUG_TOKEN				0
//#define DEBUG_REGISTERS			0

#if WANT_HARDWARE
ONION	HOST_WAIT = {250};
#else
ONION	HOST_WAIT = {1};
#endif


BYTE speed = 0x00;

BYTE USB_IN;		// next ep0 bdt to use
extern BYTE USB_OUT;			// next ep0 bdt to use

#if DEBUG_BDT
static volatile PBDT debugPBDT @0xff00;	// copy bdt's here to see them in simulation
static volatile BDT debugBDT @0xff04;
static volatile BYTE debugDATA[8] @0xff08;
#endif

#if DEBUG_OUT_TOKENS
volatile BYTE debugTOKEN_ADDRESS @0xff10;
volatile BYTE debugTOKEN_TOKEN @0xff11;
volatile BYTE debugTOKEN_TYPE @0xff12;
#endif

#if !WANT_LITE
void HostDumpRegs()
#include "dumpregs.h"
#endif //!WANT_LITE

#define HERTZ_DONUT				8

#if DEBUG_DESCRIPTOR
volatile DESCRIPTOR debugDESCRIPTOR @0xff10;	// copy DESCRIPTOR's here to see them in simulation
#endif

#if !WANT_LITE
typedef struct
	{
	WORD	wLength;
	PBYTE	pBuffer;
	BYTE	bReserved;
	BYTE	bEndpointControl;
	BYTE	bAddress;
	BYTE	bTokenAndEndpoint;
	WORD	wReserved;
	WORD	wBC;
	} TODO;

TODO	todo;
BYTE	bSomethingTodo = 0;	// 0 = nothing, 1 = something, 2 = in progress
BYTE	todoBuffer[64];
#endif

// we now use these even when we aren't buffering tokens for xmit on the next token_done
// this is so we can re-xmit if an error is returned
BYTE	USB_BUFFERED=0, USB_BUFFERED_TOKEN, USB_BUFFERED_ADDRESS, USB_BUFFERED_TYPE;
BDT		USB_BUFFERED_BDT = {0};

BYTE USB_HOST_STATE;

BYTE USB_CURRENT_ADDR;	// last address assigned
BYTE USB_NEXT_ADDR;	// next address to assign
BYTE USB_ARE_WE_ATTACHED;
BYTE USB_OUT;		// next ep0 bdt to use

BYTE USB_CURRENT_CONFIG;	// used for looping
BYTE USB_NUM_CONFIGS;
//static ONION USB_POLL_COUNT;
ONION rx_buffer;
ONION USB_IN_WANTED = {0};

BYTE USB_NEXT_DATA01;
BYTE USB_META_STATE_WANTED;
BYTE USB_META_STATE;

WORD USB_PACKET_LENGTH_MODE;

BYTE USB_DUMP_bIfaceClass;
BYTE USB_DUMP_bIfaceSubClass;
BYTE USB_DUMP_bNumEndPoints;
#if WANT_SAWTOOTH
BYTE USB_SPEAKER_ENDPOINT = 0xff;	// parse config will set this
#endif //WANT_SAWTOOTH
#if WANT_CAMERA
BYTE USB_CAMERA_ENDPOINT = 2;		// parse config will set this someday
#endif //WANT_CAMERA
#if WANT_PRINTER
BYTE USB_PRINTER_ENDPOINT = 0x03;	// parse config will set this someday,
									// currently we use class 0xff so 
									// there's no point looking
//BYTE USB_PRINTER_BUFFER_SIZE:	.rword 64	; ditto
#endif //WANT_PRINTER

BOOL	bItsAHub = FALSE;

typedef struct
	{
	BYTE bLength;			// 00
	BYTE bDescriptorType;	// 01
	WORD bcdUSB;			// 02-03
	BYTE bDeviceClass;		// 04
	BYTE bDeviceSubClass;	// 05
	BYTE bDeviceProtocol;	// 06
	BYTE bMaxPacketSize0;	// 07
	WORD idVendor;			// 08-09
	WORD idProduct;			// 0a-0b
	WORD bcdDevice;			// 0c-0d
	BYTE iManufacturer;		// 0e
	BYTE iProduct;			// 0f
	BYTE iSerialNumber;		// 10
	BYTE bNumConfigurations;// 11
	} DEVICE_DESCRIPTOR, *PDEVICE_DESCRIPTOR;

DEVICE_DESCRIPTOR rx_desc_device;

DESCRIPTOR tx_get_desc_device =
	{
	0x80,		// device-to-host, standard, device
	0x06,		// Get Descriptor
	{0x0100},	// wValue: HiByte type = 1 - Device, LoByte index = 0
	{0},		// wIndex: 0 (or language ID)
	{0x0012}	// wLength: 0x12 bytes
	};

DESCRIPTOR tx_get_desc_config =
	{
	0x80,		// device-to-host, standard, device
	0x06,		// Get Descriptor
	{0x0200},	// wValue: HiByte type = 2 - Config, LoByte index = 0
	{0},		// wIndex: 0 (or language ID)
	{0x01ff}	// wLength: 0x1ff bytes
	};

DESCRIPTOR tx_get_desc_string =
	{
	0x80,		// device-to-host, standard, device
	0x06,		// Get Descriptor
	{0x0300},	// wValue: HiByte type = 3 - String, LoByte index = 0
	{0},		// wIndex: 0 (or language ID)
	{0x00ff}	// wLength: 0xff bytes
	};

DESCRIPTOR tx_set_config =
	{
	0,			// host-to-device, standard, device
	9,			// Set Config
	{0x0001},	// wValue: HiByte 0 = default, LoByte 1 = Configuration value
	{0},		// wIndex: 0 = Default
	{0}			// wLength: 0 = Default
	};

DESCRIPTOR tx_get_config =
	{
	0x80,		// device-to-host, standard, device
	0x08,		// Get Config
	{0},		// wValue: 0 = Default
	{0},		// wIndex: 0 = Default
	{1}			// wLength: 1 = Default
	};

DESCRIPTOR tx_set_port_feature =
	{
	0x23,		// host-to-device, class, other
	0x03,		// Set Feature
	{0},		// wValue: Feature selector (set at run time)
	{0},		// wIndex: Zero or Interface or Endpoint (1 for port 1)
	{0},		// wLength: 0 bytes
	};

#define SET_PORT_FEATURE_POWER	0x08	// wValue.b.l
#define SET_PORT_FEATURE_RESET	0x04	// wValue.b.l

DESCRIPTOR tx_get_port_status =
	{
	0xa3,		// device-to-host, class, other
	0x00,		// Get Status
	{0},		// wValue: 0 = Default
	{0},		// wIndex: Zero or Interface or Endpoint (1 for port 1)
	{0x0004}	// wLength: 4 bytes
	};

DESCRIPTOR tx_enable_echo =
	{
	0x40,		// 
	0x02,		// 
	{0x001d},	// wValue: 
	{0x0002},	// wIndex: 
	{0x0000}	// wLength: 0 bytes
	};


typedef struct
	{
	BYTE	b[4];
	} PORT_STATUS;

PORT_STATUS	rx_port_status;

BYTE rx_get_config;

typedef struct
	{
	BYTE	bLength;
	BYTE	bDescriptorType;
	ONION	wTotalLength;
	BYTE	bNumInterfaces;
	BYTE	bConfigurationValue;
	BYTE	iConfiguration;
	BYTE	bmAttributes;
	BYTE	bMaxPower;
	BYTE	data[512]; //256 - 9];	// philips speakers need 183 bytes
	} DESCRIPTION_CONFIG, *PDESCRIPTION_CONFIG;

DESCRIPTION_CONFIG rx_desc_config;

BYTE rx_null_packet[4] = {0x12,0x34,0x56,0x78};

char UsbMenuString[] =
			"\r\nUSB Menu\r\n"
#if WANT_HARDWARE
#if WANT_HOST
			"a = Attach device at address 0 (10)\r\n"
#endif // WANT_HOST
			"c = Clear Int Stat\r\n"
#if !WANT_LITE
			"e = Enable echo test (50)\r\n"
			"g = Get EP2 data\r\n"
#endif
#if WANT_HOST
			"h = Host mode\r\n"
#endif // WANT_HOST
			"i = Init\r\n"
			"l = Show last 16 packets\r\n"
#if WANT_HOST
			"p = Send test to printer\r\n"
#endif // WANT_HOST
#if !WANT_LITE
			"q = Queue EP2 data\r\n"
#endif
//#if !WANT_LITE
			"r = Register dump\r\n"
//#endif //!WANT_LITE
#if WANT_HOST
			"s = read strings (30)\r\n"
//			"s = Send sound\r\n"
#if !WANT_LITE
			"S = get port status\r\n"
#endif
			"t = Chapter 9 test (20)\r\n"
#if !WANT_LITE
			"T = Hub test (40)\r\n"
#endif
#endif // WANT_HOST
			"v = Show internal variables\r\n"
#if WANT_HOST
			"w#### = number of ms to wait when resetting\r\n"
#endif // WANT_HOST
			"x = Return to top level menu\r\n"
#if WANT_HOST
			"z = Reset USB\r\n"
#endif // WANT_HOST
			"! = Dump next 16 interrupts\r\n"
#endif
			;


void UsbCheckPrinter(void);
#if WANT_HOST
void UsbHost(void);
void UsbHost2(void);
#endif // WANT_HOST
void UsbLast16(void);
#if WANT_HOST
void UsbPrint(void);
void UsbSound(void);
#endif
void UsbVariables(void);

void SetMetaStateWanted(BYTE s);
void IncMetaStateWanted(void);
void MetaState(void);
void MetaState11(void);
void MetaState12(void);
void MetaState13(BYTE bJmp);
void MetaState14(void);
void MetaState15(void);
void MetaState20(void);
void MetaState21(BOOL bJmp);
void MetaState22(void);
void MetaState23(void);
void MetaState24(void);
void MetaState25(void);
void MetaState26(void);
void MetaState27(void);
#if DEBUG_USB_STRINGS
void MetaState30(void);
void MetaState31(BOOL bJmp);
void MetaState32(void);
void UsbDumpString(PDESC_STRING pds);
#endif // DEBUG_USB_STRINGS
#if !WANT_LITE
void MetaState40(void);
void MetaState41(void);
void MetaState42(void);
void MetaState43(void);
void MetaState44(void);
void MetaState50(void);
void MetaState51(void);
void MetaState60(void);
void MetaState61(void);
#endif

BYTE HostCreateNextControlByte(PBDT pBDT);
void ParseConfig(void);
void HostSetCurrentAddress(BYTE bAddress);
#if DEBUG_USB_STRINGS
BYTE USB_STRINGS_USED[32];
void UseString(BYTE bString);
#endif // DEBUG_USB_STRINGS
void SendSetup(BYTE bAddr, PBYTE pTx, PBYTE pRx, WORD wLength);
void HostSetNextOutBdt(WORD wLength, PBYTE p);
void HostSetNextInBdt(WORD wLength, PBYTE p);


void UsbMenu()
{
	static BYTE	c;
	static WORD	w;

	for (;;)
		{
		puts(UsbMenuString);
		putFlush();
input:
		putc('$');

		do	{
			// check to see if we need to send more chars to the printer.
			UsbCheckPrinter();
			
			// send a character to the UART if there is one.
			putFlushOneIfReady();

			// check meta-state for something to do
			if (USB_META_STATE)
				if (USB_META_STATE_WANTED == USB_META_STATE)
					MetaState();

#if !WANT_LITE
			if (bSomethingTodo == 1)
				{
				bSomethingTodo++;
				MetaState60();
				}
#endif

			} while (!UartCharWaiting());

		c = UartReadChar();
		putc(c);
		putCrlf();

		switch (c)
			{
#if WANT_HOST
			case 'a':
{
ONION	o;

putFlush();
for (o.w=0x6000; o.w<0x7000; o.w++)
	*o.pb = 'i';
}	

				USB_CURRENT_ADDR = 0;
				MetaState10();
				goto input;

#endif // WANT_HOST

			case 'c':
				usb.intStatus = 0xff;
				putCrlf();
				goto input;

#if !WANT_LITE
			case 'e':
				MetaState50();
				goto input;

			case 'g':
			case 'q':
				if (bSomethingTodo)
					{
					puts("todo ");
					puts("contains ");
					putws(todo.wLength);
					putws((WORD)todo.pBuffer);
					putbs(todo.bEndpointControl);
					putbs(todo.bAddress);
					putbs(todo.bTokenAndEndpoint);
					putw(todo.wBC);
					putCrlf();
					goto input;
					}
				
				todo.wLength = sizeof(todoBuffer);
				todo.pBuffer = todoBuffer;
				if (c == 'g')
					{
					for (w=0; w<todo.wLength; w++)	// clear buffer so it will be obvious if we get what we want
						todo.pBuffer[w] = 0;
					todo.bEndpointControl = 0x0d;
					todo.bAddress = 1;
					todo.bTokenAndEndpoint = 0x92;	// IN from EP2
					todo.wBC = 0x20;
					}
				else
					{
					for (w=0; w<todo.wLength; w++)	// initialize buffer with ascending bytes
						todo.pBuffer[w] = (BYTE)w;
					todo.bEndpointControl = 0x0d;
					todo.bAddress = 1;
					todo.bTokenAndEndpoint = 0x12;	// OUT to EP2
					todo.wBC = 0x20;
					}

				bSomethingTodo = 1;
				goto input;
#endif

#if WANT_HOST
			case 'H':
				UsbHost2();
				goto input;

			case 'h':
				UsbHost();
				goto input;
#endif // WANT_HOST

			case 'i':
				UsbInit();
				usb.intEnable = 1;				// enable only bus reset

				goto input;

			case 'l':
				UsbLast16();
				goto input;

#if WANT_HOST
			case 'p':
				UsbPrint();
				goto input;
#endif // WANT_HOST

			case 'r':
#if WANT_LITE
				putbs(usb.intStatus);
				putbs(usb.intEnable);
				putbs(usb.errorStatus);
				putbs(usb.errorEnable);
				putbs(usb.status);
				putbs(usb.control);
				putbs(usb.address);
				putb(usb.bdtPage);
				putCrlf();
#else
				HostDumpRegs();
#endif //!WANT_LITE
				goto input;

#if DEBUG_USB_STRINGS
			case 's':
				MetaState30();
				goto input;
#endif

#if WANT_HOST
//			case 's':
//				UsbSound();
//				goto input;
				

#if !WANT_LITE
			case 'S':
				SetMetaStateWanted(0x43);
				MetaState43();
				goto input;
#endif

			case 't':
				MetaState20();
				goto input;

#if !WANT_LITE
			case 'T':
				MetaState40();
				goto input;
#endif

#endif // WANT_HOST

			case 'v':
				UsbVariables();
				goto input;

#if WANT_HOST
			case 'w':
				puts("\r\nWait was ");
				puto(HOST_WAIT);
				putc('>');
				if (w = UartReadHexWord())
					HOST_WAIT.w = w;
				goto input;
#endif // WANT_HOST


			case 'x':
				return;

#if WANT_HOST
			case 'z':

				usb.control = MASK_CTL_HOST_MODE_EN;
// delay while hardware state machines complete
				for (w=0; w<100; w++)
					w=w;

				usb.control =0;
				usb.intEnable = 0;
				usb.intStatus = 0xff;

				UsbInit();

				USB_OUT = 0x0c;	// addr of odd data out
				USB_IN = 0x04;	// addr of odd data in

//				usb.intStatus = INT_STAT_MASK_ATTACH | INT_STAT_MASK_SOF;
//				usb.intEnable = INT_STAT_MASK_ATTACH | INT_STAT_MASK_SOF;
//				usb.control = MASK_CTL_HOST_MODE_EN;

				usb.errorEnable = 0xff;	// enable all errors

				usb.bdtPage = (BYTE)(((WORD)USB_BDT_PAGE) >> 8);

			// now reset the USB\
#if DEBUG_USB_ATTACH
	puts("INIT RST");
	putCrlf();
	putFlush();
#endif

				usb.control = MASK_CTL_RESET | MASK_CTL_HOST_MODE_EN | MASK_CTL_USB_EN;
				HostDelay(); // Wait for some ms
#if DEBUG_USB_ATTACH
	puts("END RESET");
	putCrlf();
	putFlush();
#endif
	UsbHost();

//  				usb.control = MASK_CTL_HOST_MODE_EN | MASK_CTL_USB_EN; // Send SOF's 
//  				HostDelay();  // For some ms 
//  #if DEBUG_USB_ATTACH 
//  	puts("START ENUM"); 
//  	putCrlf(); 
//  	putFlush(); 
//  #endif 
//  				USB_ARE_WE_ATTACHED = 1; 

//  			// enumerate the bus 

//  				usb.intStatus = INT_STAT_MASK_TOKEN_DONE | INT_STAT_MASK_SOF | INT_STAT_MASK_RESET; 
//  				usb.intEnable = INT_STAT_MASK_TOKEN_DONE | INT_STAT_MASK_SOF | INT_STAT_MASK_RESET; 

//  				MetaState10(); 
				goto input;
#endif // WANT_HOST

#if USB_DELAY_TOKEN && 0
			case 'z':
				if (USB_BUFFERED)
					{
					USB_BUFFERED = FALSE;
					puts("z: ");
					putbs(USB_BUFFERED_ADDRESS);
					putbs(USB_BUFFERED_TOKEN);
					putb(USB_BUFFERED_TYPE);
					putCrlf();
					ReallySendToken(USB_BUFFERED_ADDRESS, USB_BUFFERED_TOKEN, USB_BUFFERED_TYPE);
					USB_BUFFERED_ADDRESS = 0xee;
					USB_BUFFERED_TOKEN = 0xdd;
					USB_BUFFERED_TYPE = 0xcc;
					}
				else
					putc('\a');
				goto input;
#endif

			case '!':
				USB_DUMP_COUNT += 16;
				putb(USB_DUMP_COUNT);
				putCrlf();
				goto input;

			case ':':
				DOWNLOAD();		// won't return
				continue;

			default:
				putUnknown(c);
				continue;
			}

		}
}

void UsbCheckPrinter(void)
{

}

#if WANT_HOST
void UsbHost(void)
{

	USB_HOST_STATE =		0;
	USB_CURRENT_ADDR =		0;	// last address assigned
	USB_NEXT_ADDR =			1;	// next address to assign
	USB_CURRENT_CONFIG =	0;	// used for looping
	USB_NUM_CONFIGS =		0;
	USB_ARE_WE_ATTACHED =	0;
//	USB_POLL_COUNT.w =		0;
	rx_buffer.w =			0;
	USB_IN_SO_FAR =			0;
	USB_NEXT_DATA01 =		0;
	USB_META_STATE_WANTED =	0;
	USB_META_STATE =		0;

// insert the interrupt service routine into the proper vector
	Interrupt1 = (WORD)UsbHostIntService;

	usb.intEnable = 0x00;		// disable all interrupts for now
	usb.intStatus = 0xff;		// clear previous interrupts

	usb.control = MASK_CTL_ODD_RST;
	usb.control = MASK_CTL_EN_HOST;

	ENDPT_HOST_RG = ENDPT_CONTROL;	// enable ep0

	usb.sofThresholdLo = 0xff;

#if DEBUG_USB_ATTACH
	puts("");	// fixes overlapping interrupt problem
	puts("Enabling Attach interrupt");
	putCrlf();
	putFlush();
#endif

#if USB_DELAY_TOKEN
	usb.intEnable = INT_STAT_MASK_ATTACH | INT_STAT_MASK_SOF | INT_STAT_MASK_RESET;
#else
	usb.intEnable = INT_STAT_MASK_ATTACH | INT_STAT_MASK_RESET;
#endif

	return;
}

void UsbHost2(void)
{
	usb.control = MASK_CTL_ODD_RST;
	usb.control = MASK_CTL_EN_HOST;

#if USB_DELAY_TOKEN
	usb.intEnable = INT_STAT_MASK_ATTACH | INT_STAT_MASK_SOF | INT_STAT_MASK_RESET;
#else
	usb.intEnable = INT_STAT_MASK_ATTACH | INT_STAT_MASK_RESET;
#endif

	return;
}
#endif // WANT_HOST


void UsbLast16(void)
{

}

#if WANT_HOST
void UsbPrint(void)
{

}

void UsbSound(void)
{

	bSawtooth = !bSawtooth;

	if (bSawtooth)
		puts(" ON\r\n");
	else
		puts(" OFF\r\n");
}
#endif // WANT_HOST

void UsbVariables(void)
{
	static BYTE	i, j;
	static PBDT	pBDT;

	pBDT = (PBDT)USB_BDT_PAGE;
	for (i=0; i<4; i++)
		{
		for (j=0; j<4; j++)
			{
			putw((WORD)pBDT);
			putc('>');
			putbs(pBDT->pid);
			putbs(pBDT->bc);
			putos(pBDT->addr);
			pBDT++;
			}
		putCrlf();
		}

	puts("USB_HOST_STATE = ");
	putb(USB_HOST_STATE);
	putCrlf();
	puts("USB_META_STATE_WANTED = ");
	putb(USB_META_STATE_WANTED);
	putCrlf();
	puts("USB_META_STATE = ");
	putb(USB_META_STATE);
	putCrlf();

	return;
}


BYTE HostCreateNextControlByte(PBDT pBDT)
{
	static BYTE	b;

	b = USB_NEXT_DATA01 | 0x80;
	USB_NEXT_DATA01 ^= 0x40;

	return b;
}

void SetMetaStateWanted(BYTE s)
{

	USB_META_STATE_WANTED = s;
	if (s)
		s--;
	USB_META_STATE = s;
	return;
}

void IncMetaStateWanted()
{

	SetMetaStateWanted(USB_META_STATE_WANTED+1);
	return;
}

void ResetMetaStateWanted()
{

	SetMetaStateWanted(0);
	return;
}

void MetaState(void)
{

#if DEBUG_META_STATES
//	if (debug.bits.HostState)
		{
		puts("MetaState:");
		putb(USB_META_STATE);
		putCrlf();
		putFlush();
		}
#endif

	switch (USB_META_STATE)
		{
		case 0x11:	MetaState11();	break; // send get_desc_device (entire structure)
		case 0x12:	MetaState12();	break; // set address
		case 0x13:	MetaState13(FALSE);	break;// send get_desc_config
		case 0x14:	MetaState14();	break; // set configuration value
		case 0x15:	MetaState15();	break; // enumeration complete

		case 0x21:	MetaState21(FALSE);	break;// send get_desc_config
		case 0x22:	MetaState22();	break; // set configuration value
		case 0x23:	MetaState23();	break; // set configuration value to 0
		case 0x24:	MetaState24();	break; // get configuration value
		case 0x25:	MetaState25();	break; // check value and set configuation
		case 0x26:	MetaState26();	break; // get configuration value
		case 0x27:	MetaState27();	break; // check value and complete test

#if DEBUG_USB_STRINGS
		case 0x31:	MetaState31(FALSE);	break;
		case 0x32:	MetaState32();	break;
#endif // DEBUG_USB_STRINGS

#if !WANT_LITE
		case 0x41:	MetaState41();	break; // send get_status, port
		case 0x42:	MetaState42();	break; // show port status, then send set_feature, port 1, reset
		case 0x43:	MetaState43();	break; // send get_status, port
		case 0x44:	MetaState44();	break; // show port status

		case 0x51:	MetaState51();	break; // 

		case 0x61:	MetaState61();	break; // 
#endif

		default:
			puts("Invalid meta state:");
			putb(USB_META_STATE);
			putc('/');
			putb(USB_META_STATE_WANTED);
			puts("\r\n\a");
			return;
		}

	return;
}

void MetaState10(void)	// send get_desc_device (first 8 bytes)
{

	SetMetaStateWanted(0x10);
	tx_get_desc_device.wLength.w = 8;
	SendSetup(0|speed, (PBYTE)&tx_get_desc_device, (PBYTE)&rx_desc_device, USB_PACKET_LENGTH_8);
	return;
}

void MetaState11(void)	// send get_desc_device (entire structure)
{
#if WANT_HARDWARE
putFlush();
puts("\r\nMetaState11: about to doAReset()\r\n");
putFlush();
	doAReset();
#endif // WANT_HARDWARE

// now get the whole descriptor.

	tx_get_desc_device.wLength.w = rx_desc_device.bLength;
	SendSetup(0|speed, (PBYTE)&tx_get_desc_device, (PBYTE)&rx_desc_device, USB_PACKET_LENGTH_BYTE0);
	return;
}

void MetaState12(void)	// set address
{

	USB_NUM_CONFIGS = rx_desc_device.bNumConfigurations;

	if (tx_set_addr.bRequest != 5)
		{
		puts("Value hosed\r\n");
		tx_set_addr.bRequest = 5;
		}

	tx_set_addr.wValue.b.l = USB_NEXT_ADDR++;

	SendSetup(0|speed, (PBYTE)&tx_set_addr, (PBYTE)&rx_desc_device, USB_PACKET_LENGTH_0);

	return;
}

void MetaState13(BYTE bJmp)	// send get_desc_config
{

	if (!bJmp)
		{
		USB_CURRENT_CONFIG = 0;
		}
	else
		{
		SetMetaStateWanted(0x13);
		}

	tx_get_desc_config.wIndex.b.l = USB_CURRENT_CONFIG;
	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_get_desc_config, (PBYTE)&rx_desc_config, USB_PACKET_LENGTH_BYTE23);
	return;
}

void MetaState14(void) // set configuration value
{

	ParseConfig();

	puts("Configured device:");
	putb(USB_CURRENT_CONFIG);
	putc('-');
	putb(rx_desc_device.bNumConfigurations);
	putCrlf();
	putFlush();

	if ((USB_CURRENT_CONFIG+1) < rx_desc_device.bNumConfigurations)
		{
		USB_CURRENT_CONFIG++;
		MetaState13(TRUE);
		return;
		}

	tx_set_config.wValue.b.l = 1;
	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_set_config, rx_null_packet, USB_PACKET_LENGTH_0);

	return;
}

void MetaState15(void)
{

	puts("Host mode init is done\r\n");
	ResetMetaStateWanted();

	return;
}

void MetaState20(void)
{

//	USB_DUMP_COUNT = 0x40;

	puts("\r\nStarting Chapter 9 test on address 1!\r\n");
	SetMetaStateWanted(0x20);
	HostSetCurrentAddress(1|speed);

#if 0
	// there, we've now added the low speed bit (if needed) to the address.
	// speed should not be used again until another attach sets it.
	// I've set it to 0xaa to hopefully make it obvious if it gets used again.
//	speed = 0xaa;
//#else
//	speed = 0x80;
#endif

	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_get_desc_device, (PBYTE)&rx_desc_device, USB_PACKET_LENGTH_BYTE0);
	return;
}

void MetaState21(BOOL bJmp)
{

	if (!bJmp)
		{
		USB_NUM_CONFIGS = rx_desc_device.bNumConfigurations;

#if DEBUG_DEVICE_DESC
	puts("\r\nDEVICE DESCRIPTOR\r\nbLength=");
	putb(rx_desc_device.bLength);
	puts("\r\nbDescriptorType=");
	putb(rx_desc_device.bDescriptorType);
	puts("\r\nbcdUSB=");
	putw(rx_desc_device.bcdUSB);
	puts("\r\nbDeviceClass=");
	putb(rx_desc_device.bDeviceClass);
	puts("\r\nbDeviceSubClass=");
	putb(rx_desc_device.bDeviceSubClass);
	puts("\r\nbDeviceProtocol=");
	putb(rx_desc_device.bDeviceProtocol);
	puts("\r\nbMaxPacketSize0=");
	putb(rx_desc_device.bMaxPacketSize0);
	puts("\r\nidVendor=");
	putw(rx_desc_device.idVendor);
	puts("\r\nidProduct=");
	putw(rx_desc_device.idProduct);
	puts("\r\nbcdDevice=");
	putb(rx_desc_device.bcdDevice);
	puts("\r\niManufacturer=");
	putb(rx_desc_device.iManufacturer);
	puts("\r\niProduct=");
	putb(rx_desc_device.iProduct);
	puts("\r\niSerialNumber=");
	putb(rx_desc_device.iSerialNumber);
	puts("\r\nbNumConfigurations=");
	putb(rx_desc_device.bNumConfigurations);
	putCrlf();
	putCrlf();
#endif

	bItsAHub = (rx_desc_device.bDeviceClass == 0x09);

#if DEBUG_USB_STRINGS
		UseString(rx_desc_device.iManufacturer);
		UseString(rx_desc_device.iProduct);
		UseString(rx_desc_device.iSerialNumber);
#endif

		USB_CURRENT_CONFIG = 0;
		}
	else
		{
		SetMetaStateWanted(0x21);
		}

	tx_get_desc_config.wIndex.b.l = USB_CURRENT_CONFIG;
	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_get_desc_config, (PBYTE)&rx_desc_config, USB_PACKET_LENGTH_BYTE23);
	return;
}

void MetaState22(void)     // send get_desc_config
{

	ParseConfig();

	puts("Configured device:");
	putb(USB_CURRENT_CONFIG);
	putc('-');
	putb(rx_desc_device.bNumConfigurations);
	putCrlf();
	putFlush();

	if ((USB_CURRENT_CONFIG+1) < rx_desc_device.bNumConfigurations)
		{
		USB_CURRENT_CONFIG++;
		MetaState21(TRUE);
		return;
		}

	tx_set_config.wValue.b.l = 1;
	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_set_config, rx_null_packet, USB_PACKET_LENGTH_0);
	return;
}

void MetaState23(void)   // set configuration value to 0
{

	tx_set_config.wValue.b.l = 0;
	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_set_config, rx_null_packet, USB_PACKET_LENGTH_0);
	return;
}

void MetaState24(void) // get configuration value
{

	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_get_config, &rx_get_config, 1);
	return;
}

void MetaState25(void) // check value and set configuation
{

	puts("Configured device:");
	putb(rx_get_config);
	putCrlf();

	if (rx_get_config)
		puts("Should have been zero\r\n");

	putFlush();
	tx_set_config.wValue.b.l = USB_CURRENT_CONFIG;
	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_set_config, rx_null_packet, USB_PACKET_LENGTH_0);

	return;
}

void MetaState26(void)  // get configuration value
{

	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_get_config, &rx_get_config, 1);
	return;
}

void MetaState27(void)
{

	puts("Configured device:");
	putb(rx_get_config);
	putCrlf();

	if (rx_get_config != USB_CURRENT_CONFIG)
		{
		puts("Should have been ");
		putb(USB_CURRENT_CONFIG);
		putCrlf();
		}

	puts("End of Chapter 9 test\r\n");

//#if DEBUG_USB_STRINGS
//	MetaState30();
//#else
	ResetMetaStateWanted();
//#endif

	return;
}

#if DEBUG_USB_STRINGS

ONION USB_STRING_DESC_NUM;
BYTE	bCurrentString;

void MetaState30(void)
{
//	static BYTE	b;

//	for (b=0; b<32; b++)
//		USB_STRINGS_USED[b] = 0;


//USB_DUMP_COUNT =64;

	SetMetaStateWanted(0x30);
	bCurrentString = 0;
	tx_get_desc_string.wValue.b.h = 3;
	tx_get_desc_string.wValue.b.l = 0;
	tx_get_desc_string.wIndex.w = 0;

	SendSetup(USB_CURRENT_ADDR, &tx_get_desc_string, (PBYTE)&rx_desc_string, USB_PACKET_LENGTH_STRINGINDEX);
	return;
}

void MetaState31(BOOL bJmp)
{

	if (bCurrentString == 0)
		{
		if (tx_get_desc_string.wValue.b.h == 0)
			if (USB_IN_WANTED.w == 2)	// konica
				{
				USB_STRING_DESC_NUM.b.h = rx_desc_string.bLength;
				USB_STRING_DESC_NUM.b.l = rx_desc_string.bDescriptorType;
				}
			else
				{
				USB_STRING_DESC_NUM.b.h = rx_desc_string.bString[0];
				USB_STRING_DESC_NUM.b.l = rx_desc_string.bString[1];

				if (rx_desc_string.bLength != 4)
					UsbDumpString(&rx_desc_string);
				}
		}
	else
		{
		SetMetaStateWanted(0x31);
		UsbDumpString(&rx_desc_string);
		}

	for (bCurrentString++; bCurrentString; bCurrentString++)
		{
		if (USB_STRINGS_USED[bCurrentString>>3] & shift[bCurrentString&7])
			{
			USB_STRINGS_USED[bCurrentString>>3] -= shift[bCurrentString&7];

			SetMetaStateWanted(0x30);
			tx_get_desc_string.wValue.b.h = 3;
			tx_get_desc_string.wValue.b.l = bCurrentString;
			tx_get_desc_string.wIndex.w = 0;

			SendSetup(USB_CURRENT_ADDR, &tx_get_desc_string, (PBYTE)&rx_desc_string, USB_PACKET_LENGTH_STRINGINDEX);

			break;
			}
		}

	if (!bCurrentString)
		{
		ResetMetaStateWanted();
		}

	return;
}

void MetaState32(void)
{

	return;
}
#endif // DEBUG_USB_STRINGS

void ParseConfig(void)
{
	static PBYTE	p;
	static BYTE	b;
	static WORD	wLen;

	USB_DUMP_bIfaceClass = 0xff;
	USB_DUMP_bIfaceSubClass = 0xff;
	USB_DUMP_bNumEndPoints = 0xff;
#if WANT_SAWTOOTH
	USB_SPEAKER_ENDPOINT = 0xff;
#endif

	p = (PBYTE)&rx_desc_config;
	wLen = rx_desc_config.wTotalLength.w;

	while (wLen)
		{
		if (p[1] == 2)
			{
#if DEBUG_CONFIG
			puts("          Configuration:");
#endif
#if DEBUG_USB_STRINGS
			UseString(p[6]);
#endif
			}
		else if (p[1] == 4)
			{
#if DEBUG_CONFIG
			puts("              Interface:");
#endif
			USB_DUMP_bNumEndPoints = p[4];
			USB_DUMP_bIfaceClass = p[5];
			USB_DUMP_bIfaceSubClass = p[6];
#if DEBUG_USB_STRINGS
			UseString(p[8]);
#endif
			}
		else if (p[1] == 5)
			{
#if DEBUG_CONFIG
			puts("               EndPoint:");
#endif
			if (USB_DUMP_bNumEndPoints == 0)
				;
			else
				{
				if (USB_DUMP_bIfaceClass-1)
					;
				else
					{
					if (USB_DUMP_bIfaceSubClass-2)
						;
						{
#if WANT_SAWTOOTH
						USB_SPEAKER_ENDPOINT = 2;
#endif
						}
					}
				}
			}
		else if (p[1] == 0x24)
			{
#if DEBUG_CONFIG
			puts("ClassSpecific Interface:");
#endif
			}
		else if (p[1] == 0x25)
			{
#if DEBUG_CONFIG
			puts(" ClassSpecific Endpoint:");
#endif
			}

		b = p[0];
#if DEBUG_CONFIG
		{
		BYTE	i;
		for (i=0; i<b; i++)
			{
			putbs(p[i]);
			}
		}
		putCrlf();
#endif // DEBUG_CONFIG

		wLen -= b;
		p += b;
		}
}

#if !WANT_LITE
void MetaState40(void)	// send set_feature, port 1, power
{

	SetMetaStateWanted(0x40);
	tx_set_port_feature.wValue.b.l = SET_PORT_FEATURE_POWER;
	tx_set_port_feature.wIndex.b.l = 1;	// port #1

	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_set_port_feature, rx_null_packet, USB_PACKET_LENGTH_0);
	return;
}

void MetaState41(void)	// send get_status, port
{
	tx_get_port_status.wIndex.b.l = 1;	// port #1

	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_get_port_status, (PBYTE)&rx_port_status, 4);
	return;
}

void MetaState42(void) // show port status, then send set_feature, port 1, reset
{

	puts("Got port status:");
	putbs(rx_port_status.b[0]);
	putbs(rx_port_status.b[1]);
	putbs(rx_port_status.b[2]);
	putbs(rx_port_status.b[3]);
	putCrlf();
	putFlush();

	tx_set_port_feature.wValue.b.l = SET_PORT_FEATURE_RESET;
	tx_set_port_feature.wIndex.b.l = 1;	// port #1

	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_set_port_feature, rx_null_packet, USB_PACKET_LENGTH_0);
	return;
}

void MetaState43(void)	// send get_status, port
{

	tx_get_port_status.wIndex.b.l = 1;	// port #1

	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_get_port_status, (PBYTE)&rx_port_status, 4);
	return;
}

void MetaState44(void) // show port status, 
{

	puts("Got port status:");
	putbs(rx_port_status.b[0]);
	putbs(rx_port_status.b[1]);
	putbs(rx_port_status.b[2]);
	putbs(rx_port_status.b[3]);
	putCrlf();
	putFlush();

	if ((rx_port_status.b[0] & 0x03) == 0x01)	// connected but not ready
		{
		SetMetaStateWanted(0x43);	// lather, rinse, repeat
		MetaState43();
		return;
		}

// if bit 1 of the second byte (bit 9 overall) is set, it's a low speed device
	speed = (rx_port_status.b[1] & 0x02) ? 0x80 : 0x00;

	ResetMetaStateWanted();
	return;
}

void MetaState50(void)	// send enable echo
{

	SetMetaStateWanted(0x50);

	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_enable_echo, rx_null_packet, USB_PACKET_LENGTH_0);	// expect 0 bytes returned
	return;
}

void MetaState51(void) // 
{

	puts("Enable echo has been sent\r\n");

	ResetMetaStateWanted();
	return;
}


void MetaState60(void)	// send enable echo
{
	WORD	wBufferSize;

	puts("MetaState60: ");
	puts("todo ");
	puts("contains ");
	putws(todo.wLength);
	putws((WORD)todo.pBuffer);
	putbs(todo.bEndpointControl);
	putbs(todo.bAddress);
	putbs(todo.bTokenAndEndpoint);
	putw(todo.wBC);
	putCrlf();

	SetMetaStateWanted(0x60);

	wBufferSize = todo.wBC & 0x03ff;

	if (wBufferSize > todo.wLength)
		wBufferSize = todo.wLength;

	USB_HOST_STATE = 0x11;
	IncMetaStateWanted();
	USB_NEXT_DATA01 = 0;		// reset DATA0/1 flag
	USB_PACKET_LENGTH_MODE = todo.wLength;
	USB_IN_SO_FAR = 0;
	rx_buffer.pb = todo.pBuffer;

//puts("Sending ");putw(wBufferSize);puts(" bytes to ");putb(todo.bTokenAndEndpoint);putCrlf();

	if (todo.bTokenAndEndpoint & 0x80)
		{	// receiving data
		HostSetNextInBdt(wBufferSize, todo.pBuffer);
		}
	else
		{	// sending data
		HostSetNextOutBdt(wBufferSize, todo.pBuffer);
		}

#if DEBUG_SEND_TOKEN
	puts("MetaState60: SendToken(");
	putbs(todo.bAddress);
	putbs(todo.bTokenAndEndpoint);
	putb(ENDPT_CONTROL);
	puts(")\r\n");
#endif

	SendToken(todo.bAddress, todo.bTokenAndEndpoint, ENDPT_CONTROL);

	todo.pBuffer += wBufferSize;
	todo.wLength -= wBufferSize;

	return;
}

void MetaState61(void) // 
{

puts("MetaState61: todo.wLength=");
putw(todo.wLength);
putCrlf();

	if (todo.wLength)	// still more to do
		{
		MetaState60();
		return;
		}

	puts("todo is done\r\n");
	bSomethingTodo = 0;

	ResetMetaStateWanted();
	return;
}
#endif //!WANT_LITE




void HostSetCurrentAddress(BYTE bAddress)
{

	USB_CURRENT_ADDR = bAddress;
	return;
}

#if DEBUG_USB_STRINGS

void UseString(BYTE bString)
{
	static BYTE	m;

//	m = 1 << (bString & 7);
	m = shift[bString & 7];
	USB_STRINGS_USED[bString>>3] |= m;
	return;
}
#endif // DEBUG_USB_STRINGS

void SendSetup(BYTE bAddr, PBYTE pTx, PBYTE pRx, WORD wLength)
{

#if DEBUG_DESCRIPTOR
	{
	static PBYTE	pd;
	static BYTE	i;
	
	puts("Setup:");
	for (pd=(PBYTE)&debugDESCRIPTOR, i=0; i<8; i++)
		{
		pd[i] = pTx[i];
		putbs(pTx[i]);
		}
	putCrlf();
	}
#endif

	USB_HOST_STATE = 1;
	IncMetaStateWanted();
	USB_NEXT_DATA01 = 0;		// reset DATA0/1 flag

	rx_buffer.pb = (PBYTE)pRx;
	HostSetNextOutBdt(0x08, pTx);

	USB_PACKET_LENGTH_MODE = wLength;
	USB_IN_SO_FAR = 0;

#if DEBUG_SEND_TOKEN
	puts("SendSetup: SendToken(");
	putbs(bAddr);
	putbs(0xd0);
	putb(ENDPT_CONTROL);
	puts(")\r\n");
#endif

	SendToken(bAddr, 0xd0, ENDPT_CONTROL);	// setup ep0
	return;
}

void HostSetNextOutBdt(WORD wLength, PBYTE p)
{
	static ONION	onion;
	BYTE	newPid;

	USB_OUT ^= 0x04;	// toggle odd/even and use result

	onion.pBDT = USB_BDT_PAGE;
	onion.b.l = USB_OUT;	// create pointer to current out bdt

	onion.pBDT->bc = (BYTE)wLength;
	onion.pBDT->addr.pb = p;
	newPid = HostCreateNextControlByte(onion.pBDT);
	newPid |= wLength >> 8;

	USB_BUFFERED_BDT.pid = newPid;
	USB_BUFFERED_BDT.bc = onion.pBDT->bc;
	USB_BUFFERED_BDT.addr = onion.pBDT->addr;

	onion.pBDT->pid = newPid;

#if DEBUG_BDT
	{
	static PBYTE	ps;
	static BYTE	i;

	putos(onion);
	debugPBDT = onion.pBDT;
	debugBDT = *onion.pBDT;
	for (i=0, ps=onion.pBDT->addr.pb; i<8; i++)
		{
		putbs(ps[i]);
		debugDATA[i] = ps[i];
		}
	putCrlf();
	}
#endif

	return;
}

void HostSetNextInBdt(WORD wLength, PBYTE p)
{
	static ONION	onion;
	BYTE	newPid;

	USB_IN ^= 0x04;	// toggle odd/even and use result

	onion.pBDT = USB_BDT_PAGE;
	onion.b.l = USB_IN;	// create pointer to current in bdt

	onion.pBDT->bc = (BYTE)wLength;
	onion.pBDT->addr.pb = p;
	newPid = HostCreateNextControlByte(onion.pBDT);
	newPid |= wLength >> 8;

	USB_BUFFERED_BDT.pid = newPid;
	USB_BUFFERED_BDT.bc = onion.pBDT->bc;
	USB_BUFFERED_BDT.addr = onion.pBDT->addr;

	onion.pBDT->pid = newPid;

#if DEBUG_BDT
	{
	static PBYTE	ps;
	static BYTE	i;

	putos(onion);
	debugPBDT = onion.pBDT;
	debugBDT = *onion.pBDT;
	for (i=0, ps=onion.pBDT->addr.pb; i<8; i++)
		{
		putbs(ps[i]);
		debugDATA[i] = ps[i];
		}
	putCrlf();
	}
#endif

	return;
}

void SendToken(BYTE bAddress, BYTE bToken, BYTE bType)
{
#if DEBUG_TOKEN
	puts("SendToken(");
	putbs(bAddress);
	putbs(bToken);
	putb(bType);
	puts(")\r\n");
#endif

#if USB_DELAY_TOKEN && 0
	if (USB_BUFFERED)
		{
		puts("SendToken: already buffered\a ");
		putbs(USB_BUFFERED_ADDRESS);
		putbs(USB_BUFFERED_TOKEN);
		putb(USB_BUFFERED_TYPE);
		putCrlf();
		}
	USB_BUFFERED = TRUE;
#endif

	USB_BUFFERED_ADDRESS = bAddress;
	USB_BUFFERED_TOKEN = bToken;
	USB_BUFFERED_TYPE = bType;

#if USB_DELAY_TOKEN && 0
	puts("SendToken: queueing ");
	putbs(USB_BUFFERED_ADDRESS);
	putbs(USB_BUFFERED_TOKEN);
	putb(USB_BUFFERED_TYPE);
	putCrlf();
#else
	USB_BUFFERED = FALSE;
	ReallySendToken(bAddress, bToken, bType);
#endif

	return;
}






void ReallySendToken(BYTE bAddress, BYTE bToken, BYTE bType)
{

#if USB_DELAY_TOKEN && 0
	puts("ReallySendToken: ");
	putbs(bAddress);
	putbs(bToken);
	putb(bType);
	putCrlf();
#endif

	while (usb.control & MASK_CTL_TOKEN_BUSY)
		{
		putFlush();
		}

#if DEBUG_OUT_TOKENS
	debugTOKEN_ADDRESS = bAddress;
	debugTOKEN_TOKEN = bToken;
	debugTOKEN_TYPE = bType;

	puts("-> ");
	putbs(bAddress);
	putbs(bToken);
	putb(bType);
	putCrlf();
#endif

	ENDPT_HOST_RG = bType;
	usb.address = bAddress;
	usb.token = bToken;
	return;
}

#if DEBUG_USB_STRINGS




void UsbDumpString(PDESC_STRING pds)
{
	BYTE	j;

	putCrlf();
	putc('#');
	putbs(bCurrentString);
	putb(pds->bLength);
	putc('=');
	for (j=0; j<(pds->bLength-2); j+=2)
		if (pds->bString[j])
			putc(pds->bString[j]);
		else
			puts("<NULL>");
	putCrlf();


}
#endif // DEBUG_USB_STRINGS

#if 0
BYTE HostDebounceAttachDetach(void)
{
	static BYTE	b, b2, i, j;

#if WANT_HARDWARE
#if USB_LONG_RESET
#define LOOPS 255
#else
#define LOOPS 48
#endif // USB_LONG_RESET
#else
#define LOOPS 1
#endif

try_again:
	b = usb.control;	// get current value

	for (i=LOOPS; i; i--)
		{
		for (j=160; j; j--)
			{
			}
		b2 = usb.control;
		if (b != b2)
			goto try_again;
		}

	return b;
}
#endif

BYTE HostDebounceAttachDetach(void)
{
	static BYTE	b, b2, j, equal, try;

puts("HDAD: usb.control=");
putb(usb.control);
putCrlf();

	for (try=15; try; try--)
		{
		equal = 1;			// initialize comparitor
		b = usb.control;	// get current value
		for (j=160; j; j--)
			{
			b2 = usb.control;
			if (b != b2) 
				equal = 0;
			}
		if (equal)
			return b;
		}

	return usb.control | 0x40;
}

#if !WANT_LITE
void HostIntDumpRegs();
#endif //!WANT_LITE

void HostDelay(void)
{
	static ONION	o1, o2;
	long delay;

#if 0
#if !WANT_LITE
puts("\r\nRegs 1 = ");
HostIntDumpRegs();
#endif //!WANT_LITE

putc('<');
puts("usb.intEnable=");
putbs(usb.intEnable);
puts("usb.control=");
putbs(usb.control);
putFlush();
#endif
	usb.intEnable |= INT_STAT_MASK_SOF;
#if 0
puts("usb.intEnable=");
putbs(usb.intEnable);
putFlush();
putCrlf();
#endif
	o1.b.l = usb.frameNumLo;
	o1.b.h = usb.frameNumHi;
	o1.w = (o1.w + HOST_WAIT.w) & 0x7ff;

//putw(o1.w);	putCrlf();	putFlush();	// dump SOF number that we're waiting for

	delay = 0xffff0000;

	do	{
		o2.b.l = usb.frameNumLo;
		o2.b.h = usb.frameNumHi;
        if (o2.b.l & 1) asm ("stp 4"); else asm ("clp 4");
        if (o2.b.l & 2) asm ("stp 5"); else asm ("clp 5");
        if (o2.b.l & 4) asm ("stp 6"); else asm ("clp 6");
        if (o2.b.l & 8) asm ("stp 7"); else asm ("clp 7");

		// send a character to the UART if there is one.
		putFlushOneIfReady();

		delay++;
		} while ((o1.w != o2.w) && delay);

if (!delay)
	{
	puts("\r\ndelay timed out\r\n");
	putFlush();
	}

#if 0
putc('>');
putCrlf();
putFlush();
#endif
}

void doAReset()
{

#if 1
// Be like Microsoft and reset the device between the initial 8 byte get desctiptor 
// and the full get descriptor.
// just shut up for a while but send SOF's to keep the device awake
	usb.control = MASK_CTL_HOST_MODE_EN | MASK_CTL_USB_EN;
	HostDelay();
// now reset the USB
	usb.control = MASK_CTL_HOST_MODE_EN | MASK_CTL_USB_EN | MASK_CTL_RESET;
	HostDelay();
// end the reset and start the SOFs
	usb.control = MASK_CTL_HOST_MODE_EN | MASK_CTL_USB_EN;
	HostDelay();
#endif // be like microsoft
}

