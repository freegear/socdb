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
#include "fat32_base.h"


FAT32_DATA FAT32;
//-----------------------------------------------------------------------------
// FAT32_InitLBA: This function is used to find the LBA Address of the first
//				  volume on the disc. Also checks are performed on the signature
//				  and identity codes to make sure the partition is FAT32.
//-----------------------------------------------------------------------------
UI32 FAT32_FindLBABegin(void)
{
		byte tempdata;
		UI32 LBABEGIN;
		
		// Load MBR (LBA 0) into the 512 byte buffer
		IDE_BufferSector(0);	
		
		// Make Sure 0x55 and 0xAA are at end of sector
	    if (IDE_SectorWord(Signature_Position)!=Signature_Value) 
		{
		  Printf("\r\nInvalid MBR, Please Format Drive");
		  while(1);
		}
		   

		// Verify Type Code as 0C or 0B for FAT32
		tempdata=IDE_SectorByte(PARTITION1_TYPECODE_LOCATION);
		
		/*
		if ((tempdata==FAT32_TYPECODE1)||(tempdata==FAT32_TYPECODE2))
		  	 Printf("\r\nValid FAT32 Partition Found");
		else
		  {
		   	 Printf("\r\nNon FAT32 Partition Found 0x%x",tempdata);
			 while (1);
		  }
		*/
		  
		// Read LBA Begin for FAT32 File system is located for partition
		//LBABEGIN=IDE_SectorUI32(PARTITION1_LBA_BEGIN_LOCATION);
		// for storage
		LBABEGIN=0;
  
  		// Return the LBA address of FAT table
		return LBABEGIN;			
}

//-----------------------------------------------------------------------------
// LBAofCluster: This function converts a cluster number into a sector / LBA 
//				 number.
//-----------------------------------------------------------------------------
UI32 FAT32_LBAofCluster(UI32 Cluster_Number)
{
 return ((FAT32.cluster_begin_lba + ((Cluster_Number-2)*FAT32.SectorsPerCluster)));
}

//-----------------------------------------------------------------------------
// FindFATDetails: Uses FAT32_FindLBABegin to find the LBA for the volume, 
//				   and loads into memory some specific details of the partition
//				   which are used in further calculations.
//-----------------------------------------------------------------------------
void FAT32_FindFAT32Details(UI32 pfat_cache)
{
	 byte	Number_of_FATS;
	 UI32	Sectors_per_FAT;
	 word	Reserved_Sectors;
	 UI32	LBA_BEGIN;
	 int	sector, i;
	 
	 
	 LBA_BEGIN = FAT32_FindLBABegin();	// Check Volume 1 and find LBA address
	 IDE_BufferSector(LBA_BEGIN);		// Load Volume 1 table in 'clusterbuffer'
	 

	 // Make sure there are 512 bytes per cluster
	 if (IDE_SectorWord(0x0B)!=0x200) 
	 {
	  	 Printf("\r\nError: Bytes per cluster is not 512");
		 while(1);
	 }
	

	 // Load Parameters of FAT32	 
 	 FAT32.SectorsPerCluster		= IDE_SectorByte(0x0D);
 	 Printf("SectorsPerCluster: 0x%08x\n",  FAT32.SectorsPerCluster);
	 Reserved_Sectors				= IDE_SectorWord(0x0E);
	 Printf("Reserved_Sectors: 0x%08x\n",  Reserved_Sectors);
	 Number_of_FATS					= IDE_SectorByte(0x10);
	 Printf("Number_of_FATS: 0x%08x\n",  Number_of_FATS);
	 Sectors_per_FAT				= IDE_SectorUI32(0x24);
	 Printf("Sectors_per_FAT: 0x%08x\n",  Sectors_per_FAT);
	 FAT32.RootDir_First_Cluster	= IDE_SectorUI32(0x2C);
	 Printf("RootDir_First_Cluster: 0x%08x\n",  FAT32.RootDir_First_Cluster);
	 
	 
	 FAT32.fat_begin_lba = LBA_BEGIN + Reserved_Sectors;	// First FAT LBA address
	 
	 // The address of the first data cluster on this volume
	 FAT32.cluster_begin_lba = FAT32.fat_begin_lba + (Number_of_FATS * Sectors_per_FAT);

	 if (IDE_SectorWord(0x1FE)!=0xAA55) // This signature should be AA55
	 {
	  	 Printf("\r\nError: Incorrect Volume Signature");
		 while(1);
	 } 
	
	// write FAT table
	FAT32.FatCacheAddr = pfat_cache;
	for(sector = 0; sector < Sectors_per_FAT; sector++) {
		
		IDE_BufferSector(FAT32.fat_begin_lba+sector);
		IDE_SectorCopy((unsigned int)pfat_cache);
		pfat_cache += 512;
	}
	 
	
}

//-----------------------------------------------------------------------------
// FindNextCluster: Return Cluster number of next cluster in chain by reading
//					FAT table and traversing it. Return 0xffffffff for end of 
//					chain.
//-----------------------------------------------------------------------------

UI32 FAT32_FindNextCluster(UI32 Current_Cluster)
{
	UI32 FAT_sector_offset, UI32position;
	UI32 nextcluster;
	
	
	static int First = 1;
	
 	unsigned char *pFAT = (unsigned char*)FAT32.FatCacheAddr;
	
	//UART_printf("+FAT32_FindNextCluster\n");
	
	
	// Why is '..' labelled with cluster 0 when it should be 2 ??
	if (Current_Cluster==0) Current_Cluster=2;
	
	// Find which sector of FAT table to read
	FAT_sector_offset = Current_Cluster / 128;
	 
	// Read FAT sector into buffer
	//UART_printf("read FAT sector: %d\n", FAT32.fat_begin_lba+FAT_sector_offset);
	//IDE_BufferSector(FAT32.fat_begin_lba+FAT_sector_offset);
	pFAT += (FAT_sector_offset*512);
	 
	// Find 32 bit entry of current sector relating to cluster number 
	UI32position = (Current_Cluster - (FAT_sector_offset * 128)) * 4; 

	// Read Next Clusters value from Sector Buffer
	//nextcluster = IDE_SectorUI32(UI32position);	 
	nextcluster =
		  (pFAT[UI32position+3]<<24)
		| (pFAT[UI32position+2]<<16)
		| (pFAT[UI32position+1]<< 8)
		| pFAT[UI32position];
	//UART_printf("get cluster: %d\n", nextcluster);
	
	/*
	UART_printf(" 0x%08x---0x%02x%02x%02x%02x\n", nextcluster, 
				pFAT[UI32position], pFAT[UI32position+1],
				pFAT[UI32position+2], pFAT[UI32position+3]);
	UART_getch();
	*/

	// Mask out MS 4 bits (its 28bit addressing)
	nextcluster = nextcluster & 0x0FFFFFFF;		
	
	// If 0x0FFFFFFF then end of chain found
	if (nextcluster==0x0FFFFFFF) 
	   return (0xFFFFFFFF); 
	else 
		 // Else return next cluster
		 return (nextcluster);						 
} 
