//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//					    FAT32 File IO Library for AVR 
//								  V0.1c
// 	  							Rob Riglar
//							Copyright 2003,2004 
//
//   					  Email: rob@robriglar.com
//
//			    Compiled with Imagecraft C Compiler for the AVR series
//-----------------------------------------------------------------------------
//
// This file is part of FAT32 File IO Library.
//
// FAT32 File IO Library is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// FAT32 File IO Library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with FAT32 File IO Library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//-----------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------
//#include <stdio.h>
#include <stdarg.h>

extern void UART_printf(const char *format, ...);

//-----------------------------------------------------------------------------
// InitUART
//-----------------------------------------------------------------------------
void InitUART( unsigned char baudrate )
{

}

//-----------------------------------------------------------------------------
// PutChar
//-----------------------------------------------------------------------------
void PutChar( unsigned char data )
{
	UART_printf("%c", data);
	return;
}
	
//-----------------------------------------------------------------------------
// GetChar
//-----------------------------------------------------------------------------
int GetChar(void)
{
	return 0;
}
//-----------------------------------------------------------------------------
// Printf function
//-----------------------------------------------------------------------------
int Printf(const char *format, ...)
{
	va_list arg;
	int rv;
	char String[4096];

	
	va_start(arg, format);
	vsprintf(String, format, arg);
	va_end(arg);
	
	UART_printf(String);

	return 0;
}

