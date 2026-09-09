// ad1848.c

#include "vauto.h"
#include "ad1848.h"
#include "uart.h"

// the following hard-coded locations MUST be editted
// if your memory map is not the vautomation default

//volatile BYTE	AUDIO_BASE		@0x210;	// External AUDIO BASE address
volatile BYTE	AUDIO_ADDR		@0x210;	// External AUDIO index address register
volatile BYTE	AUDIO_DATA		@0x211;	// External AUDIO index data register
volatile BYTE	AUDIO_STAT		@0x212;	// External AUDIO status register
volatile BYTE	AUDIO_PIO		@0x213;	// External AUDIO pio data register

void AudioRegs(void);
void AudioSawtooth(void);
void AudioCapture(void);
void AudioPlayback(void);

void AudioMenu()
{
	static BYTE	c;
	static ONION	onion;

prompt:
	puts(	"\r\nAUDIO DEMO MENU\r\n"
			"c = Capture 32kb\r\n"
			"i = Init ad1845\r\n"
			"p = Playback 32kb\r\n"
			"r = Register read\r\n"
			"s = Sawtooth playback data\r\n"
			"+ = Inc freq\r\n"
			"- = Dec freq\r\n"
			"= = Show Freq\r\n"
			"x = Exit");

	while (1)
		{
		putCrlf();
		putc('&');
		c = UartReadChar();
		putc(c);
		putFlush();		// echo immediately
		switch (c)
			{
			case 'i':
				AudioInit();
				break;

			case 'x':
				return;	// to main menu

			case 'r':
				putCrlf();
				AudioRegs();
				break;

			case 's':
				AudioSawtooth();
				break;

			case 'c':
				AudioCapture();
				break;

			case 'p':
				AudioPlayback();
				break;

			case ':':
				DOWNLOAD();		// won't return
				continue;

			case '+':
			AUDIO_ADDR = 22;
			AUDIO_DATA = AUDIO_DATA + 1;
			AUDIO_ADDR = 23;
			AUDIO_DATA = AUDIO_DATA;
			goto show_regs;

			case '-':
			AUDIO_ADDR = 22;
			AUDIO_DATA = AUDIO_DATA - 1;
			AUDIO_ADDR = 23;
			AUDIO_DATA = AUDIO_DATA;
			goto show_regs;

			case '=':
show_regs:
			AUDIO_ADDR = 22;
			onion.b.h = AUDIO_DATA;
			AUDIO_ADDR = 23;
			onion.b.l = AUDIO_DATA;
			puto(onion);
			continue;

			default:
				puts("?\r\n\r\n");
				goto prompt;
			}
		}
}

BYTE A_TABLE[] =	// AD1845 register init table
	{
	0xa0,	//  0 Left  Input Control - select MIC, +20db gain
	0xa0,	//  1 Right Input Control - select MIC, +20db gain
	0x9f,	//  2 Left  Aux1 in ctl - Mute
	0x9f,	//  3 Right Aux1 in ctl - Mute
	0x9f,	//  4 Left  Aux2 in ctl - Mute
	0x9f,	//  5 Right Aux2 in ctl - Mute
	0x00,	//  6 Left  DAC ctl - enable
	0x00,	//  7 Right DAC ctl - enable
	0x53,	//  8 CLK/data Format - 11Khz, 16 bit stereo, linear PCM
	0xc9,	//  9 Interface Config - enable PIO mode,ACAL, playback
	0x00,	// 10 Pin control - disable interrupts
	0x00,	// 11 Test and Init - read only
	0x40,	// 12 Misc CTL - MODE2 (bit6=1) MUST be enabled!
	0x00,	// 13 Digital Mix - disabled
	0x00,	// 14 Upper Base Count - not used
	0x00,	// 15 Lower Base Count - not used
	// the following register ARE ONLY accessable if MODE2=1!
	// DAC=0 on underrun makes PUR more obvious!
	0x91,	// 16 Alternate feature - DAC=0 on UR, 0L=0db,+12db gain
	0x10,	// 17 MIC Mix enable - diabled
	0x9f,	// 18 Left Line GAM - mute
	0x9f,	// 19 Right Line GAM - mute
	0x00,	// 20 Lo timer - don't care
	0x00,	// 21 Hi timer - don't care
	11000 >> 8,		// 23 Upper Freq - 11 Khz
	11000 & 0xff,	// 22 lower Freq - 11 Khz
	0x00,	// 24 Cap/play timer - don't care
	0x00,	// 25 Rev - read only
	0x11,	// 26 Mono CTL - mute
	0x08,	// 27 Power-Down CTL - enable freq regs
	0x50,	// 28 Capture Format - 16 bit linear stereo
	0x00,	// 29 Crystal select - 24.5 Mhz
	0x00,	// 30 CAP upper base - don't care
	0x00	// 31 CAP lower base - don't care
	};

void AudioInit()
{
	static BYTE	b, c;

	for (c=2; c; c--)	// takes two tries to succeed
		{
		for (b = 0; b < 16; b++)
			if ((AUDIO_ADDR & 0x80) == 0)	// test init bit
				break;				// set, init is over
			else
				{
#if WANT_HARDWARE
				puts("AUDIO CHIP still initing\r\n");
#endif	// WANT_HARDWARE
				}

	// init audio from table
		for (b=0; b<32; b++)
			{
			// add MCE bit (6) to allow write to all registers.
			AUDIO_ADDR = 0x40 + b;
			AUDIO_DATA = A_TABLE[b];
			}

	// release MCE and the chip should begin running in about 128 samples...
		AUDIO_ADDR = 0;
		}

#if WANT_HARDWARE
	puts("AUDIO CHIP inited\r\n");
#endif	// WANT_HARDWARE

	return;
}

void AudioRegs()
{
	static BYTE	i, j;

	for (i=0; i<32; i++)
		{
		AUDIO_ADDR = i;
		j = AUDIO_DATA;
		putbs(j);
		if ((i & 0x0f) == 0x0f)
			{
			putCrlf();
			}
		}

	return;
}

void AudioSawtooth()
{
	static BYTE	b, l, r;

	AUDIO_ADDR = 9;
	AUDIO_DATA = 0xc1;		// enable PIO playback
	l = 0;
	r = 0;

	while(1)
		{
		if (UartCharWaiting())	// if char has been typed
			{
			b = UartReadChar();	// eat it
			return;				// we are done
			}

		if ((AUDIO_STAT & 0x02) == 0)
			{						// uart not ready
			continue;
			}

		if (AUDIO_STAT & 0x04)	// is left channel ready
			{				// yes
			l--;
			AUDIO_PIO = l;	// 2 bytes for 16 bit data
			AUDIO_PIO = l;
			}
		else
			{
			r++;
			AUDIO_PIO = r;	// 2 bytes for 16 bit data
			AUDIO_PIO = r;
			}
		}
}

void AudioCapture()
{
	static BYTE	b, max;
	static PBYTE	p;
	static ONION	pMax;

	p = (PBYTE)0x8000;
	max = 0;
	pMax.pb = NULL;

	AUDIO_ADDR = 9;
	AUDIO_DATA = 0xc2;		// enable capture
	AUDIO_ADDR = 0;

	while (1)
		{
		if ((AUDIO_STAT & 0x20) == 0)
			continue;		// wait for data to become available
		b = AUDIO_PIO;
		if (b > max)		// save max value address
			{
			max = b;
			pMax.pb = p;
			}
		*p++ = b;			// write data to buffer
		if (!p)
			break;
		}

	putb(max);
	putc('@');
	puto(pMax);
	puts("=Max, Capture done\r\n");
	return;
}

void AudioPlayback()
{
	static PBYTE	p;

	p = (PBYTE)0x8000;
	AUDIO_ADDR = 9;
	AUDIO_DATA = 0xc1;		// enable PIO playback

	while (1)
		{
		if ((AUDIO_STAT & 0x02) == 0)
			continue;

		AUDIO_PIO = *p++;
		if (!p)
			break;
		}

	return;
}
