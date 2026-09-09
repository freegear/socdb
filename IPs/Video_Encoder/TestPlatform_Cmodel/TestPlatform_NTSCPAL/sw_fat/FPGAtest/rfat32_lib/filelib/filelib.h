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
//-----------------------------------------------------------------------------

#include "../base/typedefs.h"

#ifndef _FILELIB_H_
#define	_FILELIB_H_
//-----------------------------------------------------------------------------
// Global Structures
//-----------------------------------------------------------------------------
typedef struct _FILE_DATA
{
	UI32 startcluster;
	UI32 currentcluster;
	UI32 bytenum;
	
}FILE_DATA;

//-----------------------------------------------------------------------------
// Prototypes
//-----------------------------------------------------------------------------
UI32 	fOpenDir(char *path);
UI32	fOpen(char *path);
int 	fGetC(char *pch);
byte	fRead512(unsigned int buffer);
int 	fRead(unsigned int buffer, int size);
void 	fScanf(char *args, char *string);

extern 	FILE_DATA FILE0;

#endif
