// host.h

#if WANT_HARDWARE
#define USB_LONG_RESET	0	// 10ms if 1, 1ms if 0
#define USB_DELAY_TOKEN	1	// wait 'til next SOF to send token
#else
#define USB_LONG_RESET	0	// 10ms if 1, 1ms if 0
#define USB_DELAY_TOKEN	0	// wait 'til next SOF to send token
#endif

extern BYTE	USB_BUFFERED, USB_BUFFERED_TOKEN, USB_BUFFERED_ADDRESS, USB_BUFFERED_TYPE;
extern BDT	USB_BUFFERED_BDT;

extern BYTE speed;

void UsbMenu(void);
void ReallySendToken(BYTE bAddress, BYTE bToken, BYTE bType);
void ResetMetaStateWanted(void);
void MetaState10(void);
BYTE HostDebounceAttachDetach(void);
void HostDelay(void);
void doAReset(void);
void SendToken(BYTE bAddress, BYTE bToken, BYTE bType);

