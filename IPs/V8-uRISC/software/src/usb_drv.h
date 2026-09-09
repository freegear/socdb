// usb_drv.h

void UsbInit(void);
void UsbEnableReset(void);
void UsbCheckForSuspend(void);
PBDT UsbSendInZero(void);
PBDT UsbSendIn(BYTE pid, BYTE bc, PBYTE pData, BOOL bStall);

#if WANT_HUB
void HubTokenDoneEPhub(void);
void HubClassSetup(void);
#endif
