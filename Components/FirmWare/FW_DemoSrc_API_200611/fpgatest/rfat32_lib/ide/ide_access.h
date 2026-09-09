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
//	code name 	: knight - read only simple file system port
//	author		: bf109up
//-----------------------------------------------------------------------------
#include "../base/typedefs.h"

#ifndef _IDE_ACCESS_H_
#define	_IDE_ACCESS_H_

//-----------------------------------------------------------------------------
//  IDE temporal data structure
//-----------------------------------------------------------------------------
typedef struct _IDE_DATA
{
	byte currentsector[512];		// current sector data
	UI32 SectorCurrentlyLoaded; 	// Initially Load to 0xffffffff;
	UI32 maxLBA;					// max LBA sector
	   
} IDE_DATA;

//-----------------------------------------------------------------------------
// Prototypes
//-----------------------------------------------------------------------------
extern	IDE_DATA IDE_Internal;
byte 	IDE_SectorByte(word sublocation);
word 	IDE_SectorWord(word sublocation);
UI32 	IDE_SectorUI32(word sublocation);
void 	IDE_SectorCopy(unsigned int pbuffer);
int 	IDE_BufferSector(UI32 LBALocation);
void	IDE_Reset(void);
void 	IDE_InitDrive(void);

#endif
