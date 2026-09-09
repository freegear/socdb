// usb_glob.c

#include "vauto.h"
#include "usb_glob.h"

volatile USB	usb					@0x280;
USB usbSave;
volatile BYTE	ENDPT_RG[ENDPOINTS]	@0x290;
volatile BYTE	ENDPT_HOST_RG		@0x290;		// same as Endpoint 0

volatile BYTE	USB_FIFO_TX			@0x28d;
volatile BYTE	USB_FIFO_RX			@0x28e;
volatile BYTE	USB_FIFO_TEST		@0x28f;

BDT USB_BDT_PAGE[64]	@0x7000;	// USB Buffer Descriptor Table base address
BYTE USB_SPEAKER_BUFF[512]	@0x7100;// USB EP2 buffer space (audio uses 256 bytes for each buffer)
BYTE USB_PRINTER_BUFF[256]	@0x7300;// USB EP3 buffer space
BYTE USB_BUFFER[1024]	@0x7400;	// USB buffer space

BYTE USB_EPn_BUFFER0[1024] @0x7800;	// uses 0x7800 - 0x7bff
BYTE USB_EPn_BUFFER1[1024] @0x7c00;	// uses 0x7c00 - 0x7fff

BYTE USB_NEXT_OUT[ENDPOINTS];		// next out buffer to use (odd or even)
BYTE USB_LAST_OUT[ENDPOINTS];		// last out buffer used (odd or even)
BYTE USB_NEXT_IN[ENDPOINTS];		// next in buffer to use (odd or even)


BYTE USB_DUMP_COUNT;		// number of ints to dump
WORD USB_IN_SO_FAR;

WORD USB_SOF_CTR;	// reserve 2 bytes for a frame counter
BYTE USB_SOF_ENB;	// SOF checking is enabled when non zero

volatile PWR_SAVE_CONTROL	pwr_save_control	@0x0230;
volatile PWR_SAVE_STATUS	pwr_save_status		@0x0231;
volatile PWR_SAVE_STATUS	pwr_save_polarity	@0x0232;
volatile PWR_SAVE_STATUS	pwr_save_enable		@0x0233;
PWR_SAVE_STATUS				current_pwr_save_status;

DESCRIPTOR tx_set_addr = 
	{
	0,
	0x05,		// Set Address
	{0},
	{0},
	{0}
	};

DESC_STRING rx_desc_string;

SETUP setup;

BOOL bFirstDeviceDescriptorGets8Bytes = FALSE;
BOOL bTruncateNextDeviceDescriptor = FALSE;

