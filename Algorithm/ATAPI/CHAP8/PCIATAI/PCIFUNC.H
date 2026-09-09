/*
	PCI BIOSコールライブラリ ヘッダファイル Ver.2.0
*/

unsigned int	_pciGetSts(unsigned char *,unsigned int *,unsigned char *,unsigned long *);
unsigned int	_pciConfigVersion();
unsigned int	_pciBusVersion();
unsigned char	_pciMaxBusNo();
unsigned long	_pciSigPCI();
unsigned long	_pciFindPciDevice(unsigned int,unsigned int,unsigned int);
unsigned long	_pciFindPciClass(unsigned char,unsigned char,unsigned char,unsigned int);
unsigned char	_pciConfigReadByte(unsigned int,unsigned int);
unsigned int	_pciConfigReadWord(unsigned int,unsigned int);
unsigned long	_pciConfigReadLong(unsigned int,unsigned int);
void		_pciConfigWriteByte(unsigned int,unsigned int,unsigned char);
void		_pciConfigWriteWord(unsigned int,unsigned int,unsigned int);
void		_pciConfigWriteLong(unsigned int,unsigned int,unsigned long);
unsigned long	_pciGetIrqRoute(unsigned int,unsigned char far *);


/* バス番号,デバイス番号,ファンクション番号 から PCIデバイスアドレスに変換 */
#define pciBusDevFunc(Bus,Dev,Func)		((Bus&0xff)<<8)|((Dev&0x1f)<<3)|(Func&7)
/* PCIデバイスアドレス から バス番号取得 */
#define pciGetBus(BXreg)		((BXreg>>8)&0xff)
/* PCIデバイスアドレス から デバイス番号取得 */
#define pciGetDev(BXreg)		((BXreg>>3)&0x1f)
/* PCIデバイスアドレス から ファンクション番号取得 */
#define pciGetFunc(BXreg)		(BXreg&7)

