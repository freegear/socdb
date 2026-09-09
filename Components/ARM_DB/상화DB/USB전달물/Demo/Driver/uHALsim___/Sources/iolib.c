/***************************************************************************
   Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
   Copyright ARM Limited 1998 - 2000.  All rights reserved.
****************************************************************************

  iolib.c

	$Id: iolib.c,v 1.12.2.6 2000/02/02 16:13:56 drusling Exp $

   This file contains some basic drivers etc. to interface with the serial
   port(s) on a ARM target. The aim of these routines is to provide
   a standard access mechanism without having target-specific code.
  
****************************************************************************/


#include "uhal.h"
#include "except_h.h"
#include "uart.h"


#ifdef ADS_BUILD
#if ADS_BUILD == 1
__weak void LCDr_putchar(unsigned char c);
__weak void LCDr_PutString(char *string);
#if USE_C_LIBRARY == 1
#ifdef __SOFTFP__
#include   <locale.h>
#endif
#endif

#endif
#endif

// Routine converts address to real ARM address & writes a byte
void outb(unsigned char value, void *address)
{
    IO_WRITE(address, value);
}


// Routine converts address to real ARM address & reads a byte
unsigned int inb(void *address)
{
    return (IO_READ(address));
}


// Routine converts address to real ARM address & writes a short
void outw(unsigned short value, void *address)
{
    address = (void *)(_MapAddress(address));
    *(unsigned short *)address = value;
}


// Routine converts address to real ARM address & reads a short
unsigned int inw(void *address)
{
    address = (void *)(_MapAddress(address));
    return (*(unsigned short *)address);
}


// Routine converts address to real ARM address & writes an int
void outl(unsigned int value, void *address)
{
    address = (void *)(_MapAddress(address));
    *(unsigned char *)address = value;
}


// Routine converts address to real ARM address & reads an int
unsigned int inl(void *address)
{
    address = (void *)(_MapAddress(address));
    return (*(unsigned char *)address);
}


// Co-exist with Semihosted by using its serial interface if no other
// ports are defined. This interface is via a SWI call.

#ifdef SEMIHOSTED

#ifdef __thumb
unsigned int __swi(SWI_Angel_Thumb) SWI_0(unsigned int reason);
     unsigned int __swi(SWI_Angel_Thumb) SWI_1(unsigned int reason, void *arg1);

#else
unsigned int __swi(SWI_Angel) SWI_0(unsigned int reason);
     unsigned int __swi(SWI_Angel) SWI_1(unsigned int reason, void *arg1);

#endif

#define SWI_READC() SWI_0(angel_SWI_SYS_READC)


     void SWI_WRITEC(char ch)
{
    SWI_1(angel_SWI_SYS_WRITEC, &ch);
}


void SWI_WRITE0(char *s)
{
    SWI_1(angel_SWI_SYS_WRITE0, s);
}

#endif


// Get a byte from the serial port.
//
// Return:
//     The byte read. Does not return until the byte is available

int uHALr_getchar(void)
{
    unsigned int Status;
    unsigned int Ch;

    Ch = lib_support_getchar();
    if (Ch == FALSE)
    {
#ifdef SEMIHOSTED

	// Use the debugger if the ports are the same
	if (HOST_COMPORT == OS_COMPORT)
	    Ch = (int)SWI_READC();
	else
	{
#else
	// Dummy bracket to match else from debugger code above
	{
#endif
	    do
	    {
		Status = GET_STATUS(OS_COMPORT);
		// (CSLEE) Read RxFE Status (AMBA_UARTFR)
	    }
	    while (!RX_DATA(Status));	// wait until ready
	    // (CSLEE) when the RxFE is set to 0, exit the while loop
	    // (CSLEE) when RxFF contains Data, exit the while loop

	    Ch = GET_CHAR(OS_COMPORT);
	    // (CSLEE) Read Character From AMBA_UARTDR(0x00)
	}
    }
    return ((int)Ch);
}				// uHALr_getchar


// Send a byte to the serial port.
//
// byte Ch - the byte to send

void uHALr_putchar(char Ch)
{
    unsigned int Status;


#ifdef ADS_BUILD
#if ADS_BUILD == 1
    LCDr_putchar(Ch);
#endif
#endif

    if (lib_support_putchar(Ch) == FALSE)
    {
/*    
#ifdef SEMIHOSTED
	// Use the debugger if the ports are the same
	if (HOST_COMPORT == OS_COMPORT)
	    SWI_WRITEC((unsigned int)Ch);
	else
	{
	
#else
	// Dummy bracket to match else from debugger code above
	{
#endif
*/
	{
	    do
	    {
		Status = GET_STATUS(OS_COMPORT);
		// (CSLEE) Read TxFF Status (AMBA_UARTFR)
	    }
	    while (!TX_READY(Status));	// wait until ready
	    // (CSLEE) when the TxFF is set to 0, exit the while loop
	    // (CSLEE) when TxFF is not Full, exit the while loop

	    PUT_CHAR(OS_COMPORT, Ch);
	    // (CSLEE) Write Character Into AMBA_UARTDR(0x00)
	    if (Ch == '\n')
	    {
		do
		{
		    Status = GET_STATUS(OS_COMPORT);
		    // (CSLEE) Read TxFF Status (AMBA_UARTFR)
		}
		while (!TX_READY(Status));	// wait until ready
	    // (CSLEE) when the TxFF is set to 0, exit the while loop
	    // (CSLEE) when TxFF is not Full, exit the while loop

		PUT_CHAR(OS_COMPORT, '\r');
		// (CSLEE) Write Character Into AMBA_UARTDR(0x00)
	    }
	}
    }
}				// uHALr_putchar


// Check if a byte is available from the serial port.
//
// Return:
//      TRUE if available or
//      FALSE if not.

int uHALr_CharAvailable(void)
{
    unsigned int Status;

#ifdef SEMIHOSTED

    // If the ports are the same, have to use the debugger and we
    // can't tell if there is a character available
    if (HOST_COMPORT == OS_COMPORT)
    {
	return (1);
    }

#endif
    lib_flush_buffer();
    Status = GET_STATUS(OS_COMPORT);
    // (CSLEE) Read RxFE Status (AMBA_UARTFR)
    if (!RX_DATA(Status))	// If RxFF is empty
	return (0);
    else					// If RxFF is not empty
	return (1);
}


#ifdef DEBUG
// Serial-only version of putchar
void sputchar(char Ch)
{
    unsigned int Status;

    do
    {
	Status = GET_STATUS(OS_COMPORT);
	// (CSLEE) Read TxFF Status (AMBA_UARTFR)
    }
    while (!TX_READY(Status));	// wait until ready
	// (CSLEE) when the TxFF is set to 0, exit the while loop
	// (CSLEE) when TxFF is not Full, exit the while loop
	
    PUT_CHAR(OS_COMPORT, Ch);
    // (CSLEE) Write Character Into AMBA_UARTDR(0x00)
    if (Ch == '\n')
    {
	do
	{
	    Status = GET_STATUS(OS_COMPORT);
	    // (CSLEE) Read TxFF Status (AMBA_UARTFR)
	}
	while (!TX_READY(Status));	// wait until ready
	// (CSLEE) when the TxFF is set to 0, exit the while loop
	// (CSLEE) when TxFF is not Full, exit the while loop
	    
	PUT_CHAR(OS_COMPORT, '\r');
	// (CSLEE) Write Character Into AMBA_UARTDR(0x00)
    }
}
#endif


void PutString(char *string)
{

#ifdef SEMIHOSTED

    SWI_WRITE0(string);

#ifdef ADS_BUILD
#if ADS_BUILD == 1
    LCDr_PutString(string);
#endif
#endif

#else
    while (*string != '\0')
    {
	uHALr_putchar(*string);
	string++;
    }
#endif
}


// Routine to fill the stream buffer from the com port.
// Returns the first character read.
int fil_sys_buf(unsigned int max_count, unsigned char *stream_ptr)
{
    unsigned int Status, ch, count = 0;

    do
    {
	do
	{
	    Status = GET_STATUS(OS_COMPORT);
	    // (CSLEE) Read RxFE Status (AMBA_UARTFR)
	}
	while (!RX_DATA(Status));
	// (CSLEE) when the RxFE is set to 0, exit the while loop
	// (CSLEE) when RxFF contains Data, exit the while loop
	
	ch = GET_CHAR(OS_COMPORT);
	// (CSLEE) Read Character From AMBA_UARTDR(0x00)

	switch (ch)
	{
	    case 0x8:
		// Delete code.
		if (count > 0)
		{
		    stream_ptr--;
		    count--;
		}
		uHALr_putchar(ch);
		break;
	    case 0xd:
		// Carriage return code, change to 0xa.
		ch = 0xa;
		count--;
	    default:
		uHALr_putchar(ch);
		*stream_ptr++ = ch;
		count++;
		break;
	}
    }
    while (ch != 0xa);
    stream_ptr -= count;
    return max_count - (count + 1);
}

// Routine to print out the stream buffer using uHALr_putchar.
// Returns the number of characters transmitted.
int print_sys_buf(unsigned int count, unsigned char *stream_ptr)
{
    do
    {
	uHALr_putchar(*stream_ptr);
	count--;
	stream_ptr++;
    }
    while (count != 0);

    return count;
}


void uHALir_FloatInit(void)
{
#ifdef ADS_BUILD
#if ADS_BUILD == 1
#if USE_C_LIBRARY == 1

#ifdef __SOFTFP__
    extern void _fp_init( void );

    _fp_init();
    setlocale(LC_ALL, "C");
#endif

#endif
#endif
#endif
}

// End of file - iolib.c
