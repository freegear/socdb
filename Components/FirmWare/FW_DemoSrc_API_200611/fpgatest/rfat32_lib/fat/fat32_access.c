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
#include "../drivers/driver.h"
#include "fat32_access.h"
#include "fat32_base.h"



//-----------------------------------------------------------------------------
// FAT32_SectorReader: From the provided startcluster and sector offset, load using 
//		   IDE_BufferSector the required sector into memory.
//-----------------------------------------------------------------------------
int FAT32_SectorReader(UI32 Startcluster, UI32 offset)
{
 	  UI32 SectortoRead = 0;
	  UI32 ClustertoRead = 0;
	  UI32 ClusterChain = 0;
	  UI32 i;
	  
	  
	  
	  // Set start of cluster chain to initial value
	  ClusterChain = Startcluster;

	  // Find parameters
	  ClustertoRead	= offset / FAT32.SectorsPerCluster;	  
	  SectortoRead	= offset % FAT32.SectorsPerCluster;

	  // Follow chain to find cluster to read
	  for (i=0; i<ClustertoRead; i++) {
	  	  ClusterChain = FAT32_FindNextCluster(ClusterChain);
	  }

	  // If end of cluster chain then return 1
	  if (ClusterChain==0xFFFFFFFF) return 1;
	  	

	  // Else read sector and return 0
	  IDE_BufferSector(FAT32_LBAofCluster(ClusterChain)+SectortoRead);
	  

	  
	  return 0;
}


//-----------------------------------------------------------------------------
// ShowFATDetails: 
//
//-----------------------------------------------------------------------------
void ShowFATDetails(void)
{
	Printf("\r\nCurrent Disc FAT details\r\n------------------------\r\nRoot Dir First Cluster = ");   
	Printf("0x%x",FAT32.RootDir_First_Cluster);
	Printf("\r\nFAT Begin LBA = ");
	Printf("0x%x",FAT32.fat_begin_lba);
	Printf("\r\nCluster Begin LBA = ");
	Printf("0x%x",FAT32.cluster_begin_lba);
	Printf("\r\nSectors Per Cluster = ");
	Printf("%d",FAT32.SectorsPerCluster);
	Printf("\r\n\r\nFormula for conversion from Cluster num to LBA is;");
	Printf("\r\nLBA = (cluster_begin_lba + ((Cluster_Number-2)*SectorsPerCluster)))\r\n");
	Printf("\r\nMax LBA address on this drive is 0x%lx",IDE_Internal.maxLBA-1);
}


