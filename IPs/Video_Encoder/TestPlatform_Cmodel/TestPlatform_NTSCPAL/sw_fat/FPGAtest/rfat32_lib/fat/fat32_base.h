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
#include "../ide/ide_base.h"
#include "../ide/ide_access.h"
#include "fat32_definitions.h"

#ifndef _FAT32_BASE_H_
#define	_FAT32_BASE_H_

//-----------------------------------------------------------------------------
// Globals
//-----------------------------------------------------------------------------
typedef struct _FAT32_DATA{
	
	   // Filesystem globals
	   byte SectorsPerCluster;
	   UI32 cluster_begin_lba;
	   UI32 RootDir_First_Cluster;
	   UI32 fat_begin_lba;
       UI32 filenumber;
	   //Long File Name Structure (max 91 LFN length)
	   byte String[7][13];
	   byte no_of_strings;
	   
	   UI32 FatCacheAddr;
	   
} FAT32_DATA;


//-----------------------------------------------------------------------------
// Prototypes
//-----------------------------------------------------------------------------
UI32 	FAT32_FindLBABegin(void);
UI32 	FAT32_LBAofCluster(UI32 Cluster_Number);
void 	FAT32_FindFAT32Details(UI32 pfat_cache);
UI32 	FAT32_FindNextCluster(UI32 Current_Cluster);
extern 	FAT32_DATA FAT32;

#endif
