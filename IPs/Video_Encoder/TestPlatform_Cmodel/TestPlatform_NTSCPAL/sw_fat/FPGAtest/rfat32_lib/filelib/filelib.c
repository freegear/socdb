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
#include "../file-dir-io/filestring.h"
#include "../file-dir-io/dirsearchbrowse.h"
#include "../fat/fat32_access.h"
#include "../ide/ide_access.h"
#include "filelib.h"


FILE_DATA FILE0;

//-----------------------------------------------------------------------------
// fOpenDir: Cycle through path string to find the start cluster
//			address of the highest subdir.
//-----------------------------------------------------------------------------
UI32 fOpenDir(char *path)
{
	
	int 	levels;
	int 	sublevel;
	char 	currentfolder[100];
	UI32	startcluster;

	// Find number of levels
	levels = FileString_PathTotalLevels(path);

	// Set starting cluster to root cluster
	startcluster = 2;

	// Start at sublevel 1 , i.e. Bypass the C:\ part
	for (sublevel=1;sublevel<levels+1;sublevel++) 
	{
		FileString_Path_to_Folder(path, sublevel, currentfolder);

		//Find clusteraddress for folder (currentfolder) 
		startcluster = MatchName(startcluster, currentfolder);
	}

	return startcluster;
}

//-----------------------------------------------------------------------------
// fOpen: Return start cluster to a file start
//-----------------------------------------------------------------------------
UI32 fOpen(char *path)
{
	char dirpath[100];
	char filename[50];
	UI32 startcluster;

	// Split full path into filename and directory path
	FileString_SplitPath(path, dirpath, filename);

	// Find last subdirs start cluster
	
	startcluster = fOpenDir(dirpath);

	// Using dir cluster address search for filename
	startcluster = MatchName(startcluster, filename);

	// Initialise file stream data
	FILE0.startcluster		= startcluster;
	FILE0.currentcluster	= FILE0.startcluster;
	FILE0.bytenum			= 0;
	

	return startcluster;
}

//-----------------------------------------------------------------------------
// fGetC: Get a character in the stream
//-----------------------------------------------------------------------------
int fGetC(char *pch)
{
	int sector;
	int offset;	
	byte returnchar=0;

	
	
	// Calculations for file position
	//sector = (FILE0.bytenum>>9)%FAT32.SectorsPerCluster;
	sector = (FILE0.bytenum>>9)%FAT32.SectorsPerCluster;
	offset = FILE0.bytenum%512;

	if(FILE0.bytenum == 0) {
		
		FILE0.currentcluster = FILE0.startcluster;
		
	} else {

		if(!(FILE0.bytenum%512)) {
		
			if(!((FILE0.bytenum>>9)%FAT32.SectorsPerCluster)) {
				FILE0.currentcluster 
					= FAT32_FindNextCluster(FILE0.currentcluster);
			}
		}
	}
	
	if(FILE0.currentcluster == 0xFFFFFFFF) 
			return 0;
	
	
	IDE_BufferSector(FAT32_LBAofCluster(FILE0.currentcluster)+sector);
	*pch  = IDE_SectorByte(offset);
	
	
	// Increase next read position
	FILE0.bytenum++;

	// Return character read
	return 1;
}

//-----------------------------------------------------------------------------
// fRead512: 
//-----------------------------------------------------------------------------
byte fRead512(unsigned int buffer)
{
	

	int sector;
	byte returnchar=0;

	// Calculations for file position
	sector = (FILE0.bytenum>>9)%FAT32.SectorsPerCluster;

	
	if(FILE0.bytenum == 0) {
		
		FILE0.currentcluster = FILE0.startcluster;
		
	} else {

		if(!(FILE0.bytenum%512)) {
		
			if(!((FILE0.bytenum>>9)%FAT32.SectorsPerCluster)) {
				FILE0.currentcluster 
					= FAT32_FindNextCluster(FILE0.currentcluster);
			}
		}
	}
	
	if(FILE0.currentcluster == 0xFFFFFFFF) {
		return 0;
	}
	
	
	IDE_BufferSector(FAT32_LBAofCluster(FILE0.currentcluster)+sector);
	IDE_SectorCopy(buffer);

	
	// Increase next read position
	FILE0.bytenum += 512;

	// Return character read
	return 1;	
	
}

//-----------------------------------------------------------------------------
// fRead512: 
//-----------------------------------------------------------------------------
byte fReadCluster(unsigned int buffer, int Count)
{

	int i =0, j;
	int cluster;
	
	if(FILE0.bytenum == 0) {
		
		FILE0.currentcluster = FILE0.startcluster;
		
	} else {

		if(!(FILE0.bytenum%512)) {
		
			if(!((FILE0.bytenum>>9)%FAT32.SectorsPerCluster)) {
				FILE0.currentcluster 
					= FAT32_FindNextCluster(FILE0.currentcluster);
			}
		}
	}
	
	if(FILE0.currentcluster == 0xFFFFFFFF) {
		return 0;
	}

	for(i = 0; i < Count; i++) {	    	    
		
		//FILE0.currentcluster = FAT32_FindNextCluster(FILE0.currentcluster);
	
		SD_TestMRead(FAT32_LBAofCluster(FILE0.currentcluster)*512, buffer, FAT32.SectorsPerCluster);
		
		//IDE_BufferSector(FAT32_LBAofCluster(FILE0.currentcluster)+0+i*4);
		//IDE_SectorCopy(buffer);
		FILE0.bytenum	+= (512*FAT32.SectorsPerCluster);
		buffer			+= (512*FAT32.SectorsPerCluster);
                                                                
		//IDE_BufferSector(FAT32_LBAofCluster(FILE0.currentcluster)+1+i*4);
		//IDE_SectorCopy(buffer);
		//FILE0.bytenum	+= 512;	
		//buffer			+= 512;
                                                                
		//IDE_BufferSector(FAT32_LBAofCluster(FILE0.currentcluster)+2+i*4);
		//IDE_SectorCopy(buffer);
		//FILE0.bytenum	+= 512;
		//buffer			+= 512;
                                                                
		//IDE_BufferSector(FAT32_LBAofCluster(FILE0.currentcluster)+3+i*4);
		//IDE_SectorCopy(buffer);
		//FILE0.bytenum	+= 512;
		//buffer			+= 512;
	}
	

	// Return character read
	return 1;	
	
}
//-----------------------------------------------------------------------------
// fRead: 
//-----------------------------------------------------------------------------
int fRead(unsigned int buffer, int size)
{
	
	int SecIdx, ByteIdx;
	int MaxSec, MaxByte, MaxCluster;
	int ReadCount;
	int ReadSize;
	int ByteSize;
	unsigned char *pTrg;

	ReadCount	= 0;
	pTrg		= (unsigned char*)buffer;

	// align byte
	if(FILE0.bytenum%512) {

		int ReadMax = (512-(FILE0.bytenum%512));
		size -= ReadMax;

		for(ByteIdx = 0; ByteIdx < ReadMax; ByteIdx++) {
		
			if(!fGetC(pTrg)) {
				return ReadCount;
			}
			pTrg++;
			ReadCount++;
		}
	}

	// algin sector
	if((FILE0.bytenum/512)%FAT32.SectorsPerCluster) {
		int ReadSector = (FAT32.SectorsPerCluster-(FILE0.bytenum/512)%FAT32.SectorsPerCluster);
		size -= ReadSector*512;

		for(SecIdx = 0; SecIdx < ReadSector; SecIdx++) {
		
			if(!fRead512((unsigned int)pTrg)) {
				return ReadCount;
			}
			pTrg 		+= 512;
			ReadCount	+= 512;
		}

	}	

	MaxSec 		= (size>>9);
	MaxByte		= (size-(MaxSec<<9));

	/*
	if(MaxSec/4 > 2) {

		int size = MaxSec/4;
		int i=0, cluster = FAT32_FindNextCluster(FILE0.currentcluster);
		int tmp;
		
		// cluster chain이 연속적이지 않을 때까지 안거나
		// cluster size가 다 되었을대 
		while(1) {

			if(size == i) break;

			tmp = FAT32_FindNextCluster(cluster);
			if((cluster+1) != tmp) break;
			cluster = tmp;
			i++;
		}

#if 1
			if(!fReadCluster((unsigned int)pTrg, i)) {
				return ReadCount;
			}

			pTrg 		+= 512*4*i;
			ReadCount	+= 512*4*i;
	
#else		
			
			for(SecIdx = 0; SecIdx < i; SecIdx++) {

			if(!fReadCluster((unsigned int)pTrg, 1)) {
				return ReadCount;
			}

			pTrg 		+= 512*4;
			ReadCount	+= 512*4;
		
			}
#endif
			


	} else */{
	
		for(SecIdx = 0; SecIdx < MaxSec/FAT32.SectorsPerCluster; SecIdx++) {

			if(!fReadCluster((unsigned int)pTrg, 1)) {
				return ReadCount;
			}

			pTrg 		+= 512*FAT32.SectorsPerCluster;
			ReadCount	+= 512*FAT32.SectorsPerCluster;
		
		}
	}

	for(SecIdx = 0; SecIdx < MaxSec%FAT32.SectorsPerCluster; SecIdx++) {
		
		if(!fRead512((unsigned int)pTrg)) {
			return ReadCount;
		}
	
		pTrg 		+= 512;
		ReadCount	+= 512;
	}
	
	
	for(ByteIdx = 0; ByteIdx < MaxByte; ByteIdx++) {
		
		if(!fGetC(pTrg)) {
			return ReadCount;
		}
		pTrg++;
		ReadCount++;
	}


	// Return character read
	return ReadCount;	
	
}
//-----------------------------------------------------------------------------
// fScanf: Read a line from a file
//-----------------------------------------------------------------------------
void fScanf(char *args, char *string)
{
	byte datalast 		= 0;
	byte datacurrent	= 0;
	int stringpntr		= 0;

	// Find string
	if (args=="%s")
	{
		while (datacurrent!=0xFF)
			{
			 
			if(!fGetC(&datacurrent)) {
				
				Printf("[fScanf]: end of file!!!\n");
			 	
				}
			if ((datalast==0x0D) && (datacurrent==0x0A)) 
				{
				stringpntr--;
				stringpntr--;
				break;
				}
			string[stringpntr++] = datacurrent;
			datalast = datacurrent;
			}
		string[stringpntr] = '\0';
	}
	// other find types go here
}
