// i2c.c

#include "vauto.h"
#include "i2c.h"
#include "uart.h"

#define DISABLE_I2C	CONTROL_REG = 0xc8;
#define ENABLE_I2C	CONTROL_REG = 0x01;


//	if EEPROM_WRITE is defined,
//		 you can call RAM2EEPROM
//	if EEPROM_READ is defined as not 0,
//		you can call EEPROM2RAM
//	if EEPROM_READ is defined as 0,
//		you can call EEPROM2RAM but it won't modify RAM
//	if EEPROM_DEBUG is defined as not 0,
//		checksums will be displayed every 256 bytes during read/write
//	if EEPROM_WRITE_ONCE is defined as not 0,
//		RAM2EEPROM will modify itself so it can't be called again.
//		(this is useful if the code if loaded above 0x43ff and won't survive
//		a p-fail)

#if	!defined(EEPROM_DEBUG)
#define EEPROM_DEBUG 0			// if 1, show checksum every 256 bytes
#endif

#if !defined(EEPROM_WRITE_ONCE)
#define EEPROM_WRITE_ONCE 1		// if 1, disable self after writing
#endif

// The I2C bus control lines are muxed into the upper 4 bits of
// the PSR when the I2C bus is enabled in the control register.

//#define SET_SDA_IN	asm("stp 7")
//#define CLR_SDA_IN	asm("clp 7")
#define SET_SDA_OUT	asm("stp 6")
#define CLR_SDA_OUT	asm("clp 6")
//#define SET_SCL_IN	asm("stp 5")
//#define CLR_SCL_IN	asm("clp 5")
#define SET_SCL_OUT	asm("stp 4")
#define CLR_SCL_OUT	asm("clp 4")

void EepromAck(void);

//	RRRR    AAA   M   M   222   EEEEE  EEEEE  PPPP   RRRR    OOO   M   M
//	R   R  A   A  MM MM  2   2  E      E      P   P  R   R  O   O  MM MM
//	RRRR   AAAAA  M M M     2   EEE    EEE    PPPP   RRRR   O   O  M M M
//	R  R   A   A  M   M   22    E      E      P      R  R   O   O  M   M
//	R   R  A   A  M   M  22222  EEEEE  EEEEE  P      R   R   OOO   M   M

#if defined(EEPROM_WRITE)
BOOL RAM2EEPROM()
{
	static BOOL	bRetCode = FALSE;
	static BYTE	b, i;
	static BYTE	RAM2E_CHIP;	// this value toggles between 0xa0 and 0xa2 which
						// selects the first or the second EEPROM chip.
	static ONION	checkSum;
	static WORD	wByteCount;
	static ONION	pSRAM;
#if EEPROM_DEBUG
	static BYTE	bDump32 = 32;
#endif

	puts("\r\nCopying SRAM to EEPROM\r\n");
	putFlush();

// This routine copies the contents of the RAM into the EEPROM.
// The flow of this routine is ...
// Enable I2C bus
// send control word (random write)
// IF ack, continue, else error
// write data until done, compute 16 bit checksum (crc?).
// write the checksum bytes
// Disable I2C bus

	// Enable the I2C Bus
	SET_SDA_OUT;
	SET_SCL_OUT;
	ENABLE_I2C;
	RAM2E_CHIP = 0xa0;		// the control word for the first EEPROM=a0
	checkSum.w = 0;			// init for the write loop

	pSRAM.w = 0x0400;		// Load the EEPROM starting at address 0x400 (int vector table and up)
	wByteCount = 0x2000;	// bytes in first block

// We write the EEPROM in 64 byte pages.
// The EEPROM has a limit of one page maximum for each write.
nextPage:
	i2cQbit();		// wait for a quarter of a bit
	CLR_SDA_OUT;	// I2C START Condition
	i2cQbit();				// wait for a quarter of a bit
	if (!i2cWrite(RAM2E_CHIP))	// control word indicates a Write (bit0=0)
		goto prestop;		// No ACK
	// If we don't get an ACK, then the write is still in progress
	// so just try again by jumping to PRESTOP

	// send the start address for this page (SRAM location - 0x400)
	if (!i2cWrite(pSRAM.b.h - 4))
		goto error;			// Fail if we don't get an ACK bit
	if (!i2cWrite(pSRAM.b.l))
		goto error;			// Fail if we don't get an ACK bit

	for (i=0; i<64; i++)
		{
		b = *pSRAM.pb++;	// get next byte

#if EEPROM_DEBUG
		if (bDump32)
			{
			putbs(b);
			bDump32--;
			}
#endif
		if (!i2cWrite(b))	// write it out
			goto error;		// Fail if we don't get an ACK bit
		checkSum.w += b;	// add to check sum

#if EEPROM_DEBUG
		if (pSRAM.b.l == 0)
			{
			putw(pSRAM);
			putc('=');
			putws(checkSum);
			putFlush();
			}
#endif

		wByteCount--;
		if (!wByteCount)
			goto done;
		}

	CLR_SCL_OUT;
	i2cQbit();
	CLR_SDA_OUT;
	i2cQbit();

stop:
	SET_SCL_OUT;
	i2cHbit();
	SET_SDA_OUT;
	i2cHbit();
	goto nextPage;

prestop:
asm("prestop:");
	EepromAck();
	goto stop;

done:
	if (RAM2E_CHIP != 0xa2)
		{
		RAM2E_CHIP = 0xa2;
		wByteCount = 0x1ffe;	// bytes in second block
		goto prestop;
		}

	if (!i2cWrite(checkSum.b.l))
		goto error;		// Fail if we don't get an ACK bit
	if (!i2cWrite(checkSum.b.h))
		goto error;		// Fail if we don't get an ACK bit
	bRetCode = TRUE;
	puto(checkSum);
	puts(" \aEEPROM written\r\n");

exit:
	EepromAck();
	DISABLE_I2C;
	asm("clp 7");
	asm("clp 6");
	asm("clp 5");
	asm("clp 4");
	return bRetCode;

error:
	puto(pSRAM);
	puts(" \aEEPROM write FAILED\r\n");
	goto exit;
}
#endif

#if defined(EEPROM_READ)
BOOL EEPROM2RAM()
{
	static BYTE	b, i;
	static ONION	pSRAM;
	static BYTE	RAM2E_CHIP;	// this value toggles between 0xa0 and 0xa2 which
						// selects the first or the second EEPROM chip.
	static ONION	checkSum, ckRead;
	static WORD	wByteCount;
#if EEPROM_DEBUG
	static BYTE	bDump32 = 32;
#endif

	putsNow("Reading EEPROM\r\n");
	// Enable the I2C Bus
	SET_SDA_OUT;
	SET_SCL_OUT;
	ENABLE_I2C;
	checkSum.w = 0;
	RAM2E_CHIP = 0xa0;		// the control word for the first EEPROM=a0
	pSRAM.w = 0x0400;		// Load the EEPROM starting at address 0x400 (int vector table and up)
	wByteCount = 0x2000;	// bytes in first block

nextPage:
	i2cQbit();		// wait for a quarter of a bit
	CLR_SDA_OUT;	// I2C START Condition
	i2cQbit();				// wait for a quarter of a bit
	if (!i2cWrite(RAM2E_CHIP))	// control word indicates a Write (bit0=0)
		{
		puts("i2cWrite 1 failed");		// No ACK
		goto done;
		}
	// If we don't get an ACK, then the write is still in progress
	// so just try again by jumping to PRESTOP

	// send the start address for this page (SRAM location - 0x400)
	b = (pSRAM.b.h & 0x7f) - 0x04;
	if (!i2cWrite(b))
		{
		puts("i2cWrite 2 failed");		// No ACK
		goto done;
		}
	if (!i2cWrite(pSRAM.b.l))
		{
		puts("i2cWrite 3 failed");		// No ACK
		goto done;
		}

	CLR_SCL_OUT;
	i2cHbit();
	SET_SCL_OUT;
	i2cHbit();
	CLR_SDA_OUT;
	i2cQbit();

	if (!i2cWrite(RAM2E_CHIP | 1))	// control word indicates a Read (bit0=1)
		{
		puts("i2cWrite 4 failed");		// No ACK
		goto done;
		}

	for (i=0; i<64; i++)
		{
		b = i2cRead();		// get next byte
		EepromAck();
#if EEPROM_DEBUG
		if (bDump32)
			{
			putbs(b);
			bDump32--;
			}
#endif
		checkSum.w += b;	// add to check sum
		*pSRAM.pb++ = b;	// save byte

#if EEPROM_DEBUG
		if (pSRAM.b.l == 0)
			{
			putw(pSRAM);
			putc('=');
			putws(checkSum);
			putFlush();
			}
#endif

		wByteCount--;
		if (!wByteCount)
			goto done;
		}

stop:
	SET_SCL_OUT;
	i2cHbit();
	SET_SDA_OUT;
	i2cHbit();
	goto nextPage;

prestop:
	EepromAck();
	goto stop;

done:
	if (RAM2E_CHIP != 0xa2)
		{
		RAM2E_CHIP = 0xa2;
		wByteCount = 0x1ffe;	// bytes in second block
		goto prestop;
		}

	ckRead.b.h = i2cRead();		// get next byte
	ckRead.b.l = i2cRead();		// get next byte

	EepromAck();
	SET_SDA_OUT;	// and high again
	DISABLE_I2C;

#if EEPROM_DEBUG
	putw(pSRAM);
	putc('=');
	putw(checkSum);
	puts(" read ");
	putw(ckRead);
#endif


	asm("clp 7");
	asm("clp 6");
	asm("clp 5");
	asm("clp 4");

#if EEPROM_DEBUG
	putFlush();
#endif

	return TRUE;
}
#endif

BOOL i2cWrite(BYTE b)
{
	static BYTE	i;
	static BYTE	bRetCode;

	bRetCode = FALSE;
	for (i=0; i<9; i++)	// for 9 bits
		{
		CLR_SCL_OUT;
		i2cQbit();
		SET_SDA_OUT;
		if ((b & 0x80) == 0)	// test hi bit
			CLR_SDA_OUT;

		i2cQbit();
		SET_SCL_OUT;
		i2cHbit();

		b += b;		// shift left without regard to carry
		b |= 1;		// make ninth bit a 1
// This will be the ACK bit which is sent by the other chip. By sending a ninth
// bit of 1, we will tristate the SDA pin during the ACK bit.
		}

	asm("br1 7,error");	// Fail if we don't get an ACK bit
	bRetCode = TRUE;

asm("error:");

	return bRetCode;
}

#if defined(EEPROM_READ)
BYTE i2cRead()
{
	static BYTE	b, i;

	for (i=0; i<8; i++)
		{
		CLR_SCL_OUT;
		i2cQbit();
		SET_SDA_OUT;		// Insures we've removed the ACK bit
		i2cQbit();
		SET_SCL_OUT;
		i2cQbit();
		b += b;					// shift left
		asm("br0 7,zero");
		b |= 1;					// set low bit
		asm("zero:");
		i2cQbit();
		}
	return b;
}
#endif

void i2cHbit()	// Wait for 1/2 of a I2C bit.
{
	i2cQbit();
}

void i2cQbit()	// Wait for 1/4 of a I2C bit.
{
// One I2C bit = 400Khz = 30 clocks @ 12Mhz. So, we need to wait for 8 clocks.
// It takes 5 clocks to execute the JSR and 5 more to execute the rts
// so we don't actully have to do any waiting in this routine, just getting
// here and returning takes more than enough time.
// the JSR into this routine takes 5 clocks.

	return;			// 5 clocks, total=10 clocks.
}

#if EEPROM_DEBUG
void EepromSecure()
{
	static BYTE	RAM2E_CHIP;	// this value toggles between 0xa0 and 0xa2 which
						// selects the first or the second EEPROM chip.

	RAM2E_CHIP = 0xa0;

nextChip:
	SET_SDA_OUT;
	SET_SCL_OUT;
	ENABLE_I2C;

	i2cQbit();			// wait for a quarter of a bit
	CLR_SDA_OUT;		// I2C START Condition
	i2cQbit();				// wait for a quarter of a bit
	i2cWrite(RAM2E_CHIP);	// control word indicates a Write (bit0=0)

	i2cWrite(0x80);		// 1xx0000x = starting block 0
	i2cWrite(0x00);		// xxxxxxxx = don't care
	i2cWrite(0xc0);		// 11xx0000 = set, read, 0 blocks

	puts("\r\nStart block:");
	putb(i2cRead());	// get a byte
	EepromAck();		// send the ACK bit

	puts(", Block Length:");
	putb(i2cRead());	// get a byte
	EepromAck();
	SET_SDA_OUT;

	DISABLE_I2C;

	if (RAM2E_CHIP == 0xa2)
		return;
	
	RAM2E_CHIP = 0xa2;
	goto nextChip;
}

void EepromUnsecure()
{
	static BYTE	RAM2E_CHIP;	// this value toggles between 0xa0 and 0xa2 which
						// selects the first or the second EEPROM chip.

	RAM2E_CHIP = 0xa0;

nextChip:
	SET_SDA_OUT;
	SET_SCL_OUT;
	ENABLE_I2C;

	i2cQbit();		// wait for a quarter of a bit
	CLR_SDA_OUT;	// I2C START Condition
	i2cQbit();				// wait for a quarter of a bit
	i2cWrite(RAM2E_CHIP);	// control word indicates a Write (bit0=0)

	i2cWrite(0x90);		// 1xx1000x = starting block 0
	i2cWrite(0x00);		// xxxxxxxx = don't care
	i2cWrite(0x80);		// 10xx0000 = set, write, 0 blocks
	EepromAck();
	SET_SDA_OUT;

	DISABLE_I2C;

	if (RAM2E_CHIP == 0xa2)
		return;

	RAM2E_CHIP = 0xa2;
	goto nextChip;
}

#endif

void EepromAck()
{
	CLR_SCL_OUT;	// SCL goes low to complete the ACK bit.
	i2cQbit();
	CLR_SDA_OUT;	// SDA goes low in preparation for a STOP
	i2cQbit();
	SET_SCL_OUT;	// and high again
	i2cHbit();
	return;
}

