/*
 *	stdio.h
 */

#ifndef __STDIO_H__
#define __STDIO_H__

#include "types.h"

#define        NUL        0x00 
#define        SOH        0x01 
#define        STX        0x02 
#define        ETX        0x03 
#define        EOT        0x04 
#define        ENQ        0x05 
#define        ACK        0x06 
#define        BEL        0x07 
#define        BS         0x08 
#define        HT         0x09 
#define        LF         0x0a 
#define        VT         0x0b 
#define        FF         0x0c 
#define        CR         0x0d 
#define        SO         0x0e 
#define        SI         0x0f 
#define        DLE        0x10 
#define        DC1        0x11 
#define        DC2        0x12 
#define        DC3        0x13 
#define        DC4        0x14 
#define        NAK        0x15 
#define        SYN        0x16 
#define        ETB        0x17 
#define        CAN        0x18 
#define        EM         0x19 
#define        SUB        0x1a 
#define        ESC        0x1b 
#define        FS         0x1c 
#define        GS         0x1d 
#define        RS         0x1e 
#define        US         0x1f 
#define        DEL        0x7f

/*
 *	Prototypes
 */

void	MemCpy32(void *dest, void *src, int numWords);
void	HexDump(char *addr, int len);

int	StrCmp(char *s1, char *s2);
int	StrNCmp(char *s1, char *s2, int len);
void	memcpy(void *dest, void *src, int len);
void	memset(void *dest, const char c, int len);
int	MemCmp(void *addr1, void *addr2, int len);
void	StrCpy(char *dest, char *src);
int	StrLen(char *str);

bool	HexToInt(char *s, void *retval, VAR_TYPE type);
int	DecToLong(char *s, long *retval);

void	printf(char *fmt, ...);
int 	getc(void);
int 	gets(char *s);
int 	Cfg_parse_args(char *cmdline, char **argv);
char* 	strtok(char * s,const char * ct);
char* 	strpbrk(const char * cs,const char * ct);
unsigned int strspn(const char *s, const char *accept);
unsigned long strtoul(const char *str, char **endptr, int requestedbase);

// for cpu byte order (big or little endian).
// Byte swapping.
#define SWAP8(A)		(A)
#define SWAP16(A)		((((A)&0x00ff)<<8) | ((A)>>8))
#define SWAP32(A)		((((A)&0x000000ff)<<24) | (((A)&0x0000ff00)<<8) | (((A)&0x00ff0000)>>8) | (((A)&0xff000000)>>24))

#endif
