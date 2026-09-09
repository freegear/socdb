/*
	ハイメモリアクセスライブラリ ヘッダファイル Ver.2.0
*/
int		_getCpuMode();
int		_preInitHimem();
unsigned char	_readHimemByte(unsigned long Address);
void		_writeHimemByte(unsigned long Address,unsigned char Data);
unsigned int	_readHimemWord(unsigned long Address);
void		_writeHimemWord(unsigned long Address,unsigned int Data);
unsigned long	_readHimemLong(unsigned long Address);
void		_writeHimemLong(unsigned long Address,unsigned long Data);
unsigned int	_readHimemBlockByte(unsigned long Address,unsigned char *Buffer,unsigned int bytes);
unsigned int	_writeHimemBlockByte(unsigned long Address,unsigned char *Buffer,unsigned int bytes);
unsigned int	_readHimemBlockWord(unsigned long Address,unsigned char *Buffer,unsigned int words);
unsigned int	_writeHimemBlockWord(unsigned long Address,unsigned char *Buffer,unsigned int words);
unsigned int	_readHimemBlockLong(unsigned long Address,unsigned char *Buffer,unsigned int longWords);
unsigned int	_writeHimemBlockLong(unsigned long Address,unsigned char *Buffer,unsigned int longWords);
unsigned long	_copyHimemByte(unsigned long SourceAddress,unsigned long DestAddress,unsigned long bytes);
unsigned long	_copyHimemWord(unsigned long SourceAddress,unsigned long DestAddress,unsigned long words);
unsigned long	_copyHimemLong(unsigned long SourceAddress,unsigned long DestAddress,unsigned long longWords);
unsigned long	_fillHimemByte(unsigned long Address,unsigned long bytes,unsigned char data);
unsigned long	_fillHimemWord(unsigned long Address,unsigned long words,unsigned int data);
unsigned long	_fillHimemLong(unsigned long Address,unsigned long longWords,unsigned long data);

void _maskNMI();
void _unmaskNMI();

/* These definitions are for _preInitHimem */
#define	ERROR_MEMORY    -1 /* Out Of Memory(needs 32KB or more)*/
#define ERROR_DRV       -2 /*This V86 driver is not support VCPI or DPMI*/
#define ERROR_CPU       -3 /*Not Support 80286 or before*/
#define ERROR_EMM       -4 /*EMM386's Device name not found(EMMXXXX0)*/
#define ERROR_VCPI_PROT -5 /*VCPI can't enter protect mode*/
#define ERROR_DPMI_PROT -6 /*DPMI can't enter protect mode*/
#define ERROR_VCPI      -7 /*Error in VCPI Function 1 or 0Ch*/
#define ERROR_DPMI      -8 /*Error in DPMI Function 2,7,8,9 or 800h*/

/* These definitions are for _getCpuMode */
#define REAL_MODE        0 /*Current mode is Real mode*/
#define VCPI_MODE        1 /*Current mode is VCPI mode*/
#define DPMI_MODE        2 /*Current mode is DPMI mode*/
#define UNKNOWN_CPU_MODE -1 /*Current mode is unknown mode*/
