// usb_glob.h

#define ENDPOINTS			4

#define ENDPOINT_SPEAKER	1
#define ENDPOINT_PRINTER	3

#define USB_PACKET_LENGTH_0				0xfff0
#define USB_PACKET_LENGTH_BYTE0			0xfff1
#define USB_PACKET_LENGTH_BYTE23		0xfff2
#define USB_PACKET_LENGTH_8				0xfff8
#define USB_PACKET_LENGTH_STRINGINDEX	0xffff	// special case until camera works

#define IS_TOKEN_SETUP			((cBDT.pid & 0x3c) == 0x34)
#define IS_TOKEN_SETUP_DATA0	((cBDT.pid & 0x7c) == 0x34)
#define IS_TOKEN_SETUP_DATA1	((cBDT.pid & 0x7c) == 0x74)

#define IS_TOKEN_IN				((cBDT.pid & 0x3c) == 0x24)
#define IS_TOKEN_IN_DATA0		((cBDT.pid & 0x7c) == 0x24)
#define IS_TOKEN_IN_DATA1		((cBDT.pid & 0x7c) == 0x64)

#define IS_TOKEN_OUT			((cBDT.pid & 0x3c) == 0x04)
#define IS_TOKEN_OUT_DATA0		((cBDT.pid & 0x7c) == 0x04)
#define IS_TOKEN_OUT_DATA1		((cBDT.pid & 0x7c) == 0x44)

typedef struct
	{
	BYTE	bRequestType;	// (bits 6:5 must be 00)
	BYTE	bRequest;
	ONION	wValue;
	ONION	wIndex;
	ONION	wLength;
	} SETUP, *PSETUP;

extern SETUP setup;

typedef struct
	{
	BYTE	bmRequestType;		// 00
	BYTE	bRequest;			// 01
	ONION	wValue;				// 02-03
	ONION	wIndex;				// 04-05
	ONION	wLength;			// 06-07
	} DESCRIPTOR, *PDESCRIPTOR;

extern DESCRIPTOR tx_set_addr;

typedef struct
	{
	BYTE	bLength;
	BYTE	bDescriptorType;
	BYTE	bString[256-2];
	} DESC_STRING, *PDESC_STRING;

extern DESC_STRING rx_desc_string;

// the following hard-coded locations MUST be editted
// if your memory map is not the vautomation default

typedef struct
	{
	BYTE	intStatus,		// 0x280
#define INT_STAT_MASK_RESET			0x01
#define INT_STAT_MASK_ERROR			0x02
#define INT_STAT_MASK_SOF			0x04
#define INT_STAT_MASK_TOKEN_DONE	0x08
#define INT_STAT_MASK_SLEEP			0x10
#define INT_STAT_MASK_RESUME		0x20
#define	INT_STAT_MASK_ATTACH		0x40
#define INT_STAT_MASK_STALL			0x80

			intEnable,		// 0x281

			errorStatus,	// 0x282
			errorEnable,	// 0x283
			status,			// 0x284
			control,		// 0x285
#define	MASK_CTL_USB_EN			(1<<0)
#define	MASK_CTL_ODD_RST		(1<<1)
#define	MASK_CTL_RESUME			(1<<2)
#define	MASK_CTL_HOST_MODE_EN	(1<<3)
#define	MASK_CTL_RESET			(1<<4)
#define	MASK_CTL_TOKEN_BUSY		(1<<5)
#define	MASK_CTL_TXD_SUSPEND	(1<<5)	// overload bit 5
#define	MASK_CTL_SINGLE_ENDED_0	(1<<6)
#define	MASK_CTL_RCV			(1<<7)

#define MASK_CTL_EN_HOST		(MASK_CTL_USB_EN | MASK_CTL_HOST_MODE_EN)

			address,		// 0x286
			bdtPage,		// 0x287
			frameNumLo,		// 0x288
			frameNumHi,		// 0x289
			token,			// 0x28a
			sofThresholdLo,	// 0x28b
			sofThresholdHi;	// 0x28c

// the following variables don't map to memory, but are useful

	BYTE	intStatusMasked;	// intStatus & intEnable
	BYTE	ep;					// current endpoint
	PBDT	pBDT;				// current bdt
	} USB;

extern volatile USB		usb				/*@0x280*/;
extern USB usbSave;
extern BDT cBDT;			// *usbSave.pBDT get copied here

extern volatile BYTE	ENDPT_RG[ENDPOINTS]	/*@0x290*/;
extern volatile BYTE	ENDPT_HOST_RG	/*@0x290*/;		// same as Endpoint 0

extern volatile BYTE	USB_FIFO_TX;	/*@0x28d*/
extern volatile BYTE	USB_FIFO_RX;	/*@0x28e*/
extern volatile BYTE	USB_FIFO_TEST;	/*@0x28f*/

extern BDT USB_BDT_PAGE[];		//@0x7000;	// USB Buffer Descriptor Table base address
extern BYTE USB_SPEAKER_BUFF[];	//@0x7100;	// USB EP2 buffer space (audio uses 256 bytes for each buffer)
extern BYTE USB_PRINTER_BUFF[];	//@0x7300;	// USB EP3 buffer space
extern BYTE USB_BUFFER[];		//@0x7400;	// USB buffer space

extern BYTE USB_EPn_BUFFER0[]; //@0x7800;	// uses 0x7800 - 0x7bff
extern BYTE USB_EPn_BUFFER1[]; //@0x7c00;	// uses 0x7c00 - 0x7fff

extern WORD USB_IN_SO_FAR;

extern WORD USB_SOF_CTR;	// reserve 2 bytes for a frame counter
extern BYTE USB_SOF_ENB;	// SOF checking is enabled when non zero

extern WORD USB_ERROR_CTR[8];

// bmEP_n_CTL(R/W)   n
//	This bit mapped Control register allows some control over each endpoint. There are 15 of
//	these registers, one for each endpoint except endpoint 0.  When setting the endpoint type to
//	control or interrupt the register effects only one endpoint.
//	The end points are grouped in even/odd pairs (2/3, 4/5, 6/7, ..., 14/15).
//	When configuring an endpoint as a bulk or isochronous endpoint, the
//	endpoint whose control register is set is configured as an input or output endpoint based
//	on the direction bit. The other endpoint of the pair is configured in the opposite direction.
//
//	The act of writing the control endpoint register has the side effect of clearing the data toggle
//	synchronization bit(s) of the effected endpoints.
//
//	4-EP_ENB-1=Endpoint is enabled
//	3-EP_STALL-1=endpoint is stalled
//	2-EP_IN-direction for bulk and iso endpoints 1=IN, 0=OUT queue.
//	1:0-EP_TYPE-corresponds to the EP_TYPE field in enpoint control registers of the VUSB.
//		00 - control endpoint
//		01 - isochronous endpoint
//		10 - bulk endpoint
//		11 - interrupt endpoint

// Define the bits within the endpoint control register
#define	ENDPT_HSHK_BIT		0x01	
#define	ENDPT_STALL_BIT		0x02
#define	ENDPT_IN_EN_BIT		0x04
#define	ENDPT_OUT_EN_BIT	0x08
//#define	ENDPT_NOT_STALL		0xfd
// Also define some useful bit combinations
#define	ENDPT_DISABLE		0x00
#define	ENDPT_CONTROL		0x0d
#define	ENDPT_BULK_OUT		0x09
#define	ENDPT_BULK_IN		0x05
#define	ENDPT_BULK_BIDIR	0x0d
#define	ENDPT_ISO_OUT		0x08
#define	ENDPT_ISO_IN		0x04
#define	ENDPT_ISO_BIDIR		0x0c	
// bit offsets are usefull for doing bit tests
//#define	ENDPT_HSHK_OFF		0
//#define	ENDPT_STALL_OFF		1
//#define	ENDPT_IN_EN_OFF		2
//#define	ENDPT_OUT_EN_OFF	3


#define	ADDR_LS_EN			7



extern BYTE USB_DUMP_COUNT;				// number of ints to dump
extern WORD USB_PACKET_LENGTH_MODE;

extern BYTE USB_NEXT_OUT[ENDPOINTS];		// next out buffer to use (odd or even)
extern BYTE USB_LAST_OUT[ENDPOINTS];		// last out buffer used (odd or even)
extern BYTE USB_NEXT_IN[ENDPOINTS];		// next in buffer to use (odd or even)

extern BOOL bFirstDeviceDescriptorGets8Bytes;
extern BOOL bTruncateNextDeviceDescriptor;

extern BYTE USB_BUFFER_SIZE;	// valid values are 8,16,32,64 per USB spec.
extern WORD USB_MAX_PACKET[ENDPOINTS];	// max packet size per ep
extern BYTE USB_DEVICE_DESC[];	// table for the USB Device Descriptor

typedef struct
	{
	BYTE	rest:1,			// 0
			sleep:1,		// 1
			globaltri:1,	// 2
			stop_osc:1;		// 3
	} PWR_SAVE_CONTROL;

typedef struct
	{
	BYTE	asleep:1,		// 0
			u_chan0i2:1,	// 1
			u_chan0i1:1,	// 2
			buttinsky:1,	// 3
			u_rx:1,			// 4
			ext_int:1,		// 5
			tms:1,			// 6
			bus_req:1;		// 7
	} PWR_SAVE_STATUS;

extern volatile PWR_SAVE_CONTROL	pwr_save_control;
extern volatile PWR_SAVE_STATUS		pwr_save_status;
extern volatile PWR_SAVE_STATUS		pwr_save_polarity;
extern volatile PWR_SAVE_STATUS		pwr_save_enable;

extern PWR_SAVE_STATUS				current_pwr_save_status;

