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
#include "../drivers/driver.h"
#include "ide_base.h"

//-----------------------------------------------------------------------------
// Fetch_ID_Max_LBA: Reads drive parameters and returns Max LBA address
//
// Parameters: If silent set then no terminal output, else prints results
//
// Returns: Max LBA address (32bits)
//
// Port: identify device, currently none
//-----------------------------------------------------------------------------
UI32 Fetch_ID_Max_LBA(byte silent)
{

	Printf("\r\nLBA sectors is 0x%lx", 1024);
	return 0x40000000;	
}
