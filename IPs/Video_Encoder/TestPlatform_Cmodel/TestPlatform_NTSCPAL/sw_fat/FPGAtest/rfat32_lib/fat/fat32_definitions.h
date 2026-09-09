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
#ifndef _FAT32_DEFINITION_H_
#define	_FAT32_DEFINITION_H_

#define 	clusterprint							 1 
//-----------------------------------------------------------------------------
// FAT32 Specific Statics
//-----------------------------------------------------------------------------
#define Signature_Position						 	(510    )
#define Signature_Value							 	(0xAA55 )
#define PARTITION1_TYPECODE_LOCATION	 		 	(450    )
#define FAT32_TYPECODE1						 	 	(0x0B   )
#define FAT32_TYPECODE2						 	 	(0x0C   )
#define PARTITION1_LBA_BEGIN_LOCATION	 		 	(454	)
	
//-----------------------------------------------------------------------------
// FAT32 File Attributes and Types
//-----------------------------------------------------------------------------
#define FILE_ATTR_READ_ONLY   						(0x01)
#define FILE_ATTR_HIDDEN 							(0x02)
#define FILE_ATTR_SYSTEM 							(0x04)
#define FILE_ATTR_SYSHID							(0x06)
#define FILE_ATTR_VOLUME_ID 						(0x08)
#define FILE_ATTR_DIRECTORY							(0x10)
#define FILE_ATTR_ARCHIVE  							(0x20)
#define FILE_ATTR_LFN_TEXT							(0x0F)
#define FILE_HEADER_BLANK							(0x00)
#define FILE_HEADER_DELETED							(0xE5)
#define FILE_TYPE_DIR								(0x10)
#define FILE_TYPE_FILE								(0x20)
#define FILE_TYPE_MP3								(0x55)

#endif
