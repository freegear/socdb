// vauto.h

// the following are the major components which can be enabled at compile time
#ifndef WANT_USB
#define WANT_USB		0
#endif

#ifndef WANT_JTAG
#define WANT_JTAG		0
#endif

#ifndef WANT_MONITOR
#define WANT_MONITOR	0
#endif

#ifndef WANT_PRINTER
#define WANT_PRINTER	0
#endif

#ifndef WANT_REGRESS
#define WANT_REGRESS	0
#endif

#ifndef WANT_HUB
#define WANT_HUB		0
#endif

#ifndef WANT_SOUND
#define WANT_SOUND		0
#endif

#ifndef WANT_PRINTER
#define WANT_PRINTER	0
#endif

#ifndef WANT_TIMER
#define WANT_TIMER		0
#endif

#ifndef EEPROM_WRITE
#define EEPROM_WRITE	0
#endif

// standard defines for VAutomation C programs.

typedef unsigned char BYTE;		// unsigned 8 bit
typedef unsigned char *PBYTE;	// pointer to unsigned 8 bit

typedef unsigned int WORD;		// unsigned 16 bit
typedef unsigned int *PWORD;	// pointer to unsigned 16 bit

#define TRUE 1
#define FALSE 0
#define NULL (0)

typedef unsigned char BOOL;		// unsigned 8 bit
typedef unsigned char *PBOOL;	// pointer to unsigned 8 bit

typedef struct
	{
	BYTE	zero:2,
			odd:1,
			out:1,
			ep:4,
			page:8;
	} BDT_PARTS;

typedef union
	{
	WORD w;
	struct {BYTE l; BYTE h;} b;
	PBYTE pb;
	PWORD pw;
	struct {BYTE zero:2, odd:1, out:1, ep:4, page:8;}bdt;
	struct _BDT  *pBDT;
	} ONION, *PONION;

typedef union
	{
	struct {BYTE h; BYTE l;} b;
	WORD w;
	} BYTES_TO_RWORD, *PBYTES_TO_RWORD;

typedef struct _BDT
	{
	BYTE	pid;	// 7:own 6:data0/1 5-2:pid 1-0:bch
	BYTE	bc;
	ONION	addr;
	} BDT, *PBDT;

typedef union
	{
	WORD	w;
	struct {WORD UsbInt:1, UsbSend:1, HostState:1, HubState:1, SofErrors:1;} bits;
	} DEBUG;

#if WANT_HARDWARE
extern DEBUG debug;
#endif

typedef char *PSTR;

extern volatile BYTE CONTROL_REG;	// Control Register address

extern volatile WORD	Interrupt0;	// interupt vector 0
extern volatile WORD	Interrupt1;	// interupt vector 1
extern volatile WORD	Interrupt2;	// interupt vector 2
extern volatile WORD	Interrupt3;	// interupt vector 3
extern volatile WORD	Interrupt4;	// interupt vector 4
extern volatile WORD	Interrupt5;	// interupt vector 5
extern volatile WORD	Interrupt6;	// interupt vector 6
extern volatile WORD	Interrupt7;	// interupt vector 7

extern WORD start;					// defined by the compiler

extern BYTE shift[8];

void DOWNLOAD(void);
void stuff(void);	// HACK

// init p[0] - p[len-1] with val
void memset(PBYTE p, BYTE val, BYTE len);
void memcpy(PBYTE pd, PBYTE ps, BYTE len);
void disableInterrupts(void);
void enableInterrupts(void);

