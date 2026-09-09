//------------------------------------------------------------------------------
//             __________               __   ___.
//   Open      \______   \ ____   ____ |  | _\_ |__   _______  ___
//   Source     |       _//  _ \_/ ___\|  |/ /| __ \ /  _ \  \/  /
//   Jukebox    |    |   (  <_> )  \___|    < | \_\ (  <_> > <  <
//   Firmware   |____|_  /\____/ \___  >__|_ \|___  /\____/__/\_ \
//                     \/            \/     \/    \/            \/
// $Id: fat.h,v 1.14 2006-07-31 22:59:45 raenye Exp $
//
// Copyright (C) 2002 by Linus Nielsen Feltzing
//
// All files in this archive are subject to the GNU General Public License.
// See the file COPYING in the source tree root for full license agreement.
//
// This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
// KIND, either express or implied.
//
//------------------------------------------------------------------------------

#ifndef FAT_H
#define FAT_H

#include "../../sw_fs_typedefs.h"
#include "../../../../drivers/storage/sdmmc/sdmmc_post_drv.h"

#define	NUM_VOLUMES	2
#define SECTOR_SIZE 512

//------------------------------------------------------------------------------
// 
//	Number of bytes reserved for a file name (including the trailing \0).
// 	Since names are stored in the entry as UTF-8, we won't be able to
// 	store all names allowed by FAT. In FAT, a name can have max 255
// 	characters (not bytes!). Since the UTF-8 encoding of a char may take
// 	up to 4 bytes, there will be names that we won't be able to store
// 	completely. For such names, the short DOS name is used. 
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//
//	fat_directory
//
//------------------------------------------------------------------------------

#define FAT_FILENAME_BYTES	(256)

typedef struct
{
    unsigned char	name[FAT_FILENAME_BYTES]; 	// UTF-8 encoded name plus 
    unsigned short	attr;            			// Attributes 
    unsigned char	crttimetenth;     			// Millisecond creation time stamp (0-199) 
    unsigned short	crttime;         			// Creation time 
    unsigned short	crtdate;         			// Creation date 
    unsigned short	lstaccdate;      			// Last access date
    unsigned short	wrttime;         			// Last write time 
    unsigned short	wrtdate;         			// Last write date 
    unsigned long 	filesize;          			// File size in bytes
    long 			firstcluster;               // fstclusterhi<<16 + fstcluslo 
    
} FATDirEntry;

//------------------------------------------------------------------------------
//
//	fat_file
//
//------------------------------------------------------------------------------

#define FAT_ATTR_READ_ONLY   (0x01)
#define FAT_ATTR_HIDDEN      (0x02)
#define FAT_ATTR_SYSTEM      (0x04)
#define FAT_ATTR_VOLUME_ID   (0x08)
#define FAT_ATTR_DIRECTORY   (0x10)
#define FAT_ATTR_ARCHIVE     (0x20)
#define FAT_ATTR_VOLUME      (0x40) 			// this is a volume, not a real directory

typedef struct
{
    long			firstcluster;    			// first cluster in file 
    long			lastcluster;     			// cluster of last access
    long			lastsector;      			// sector of last access 
    long			clusternum;      			// current clusternum 
    long 			sectornum;       			// sector number in this cluster 
    unsigned int	direntry;   				// short dir entry index from start of dir 
    unsigned int	direntries; 				// number of dir entries used by this file 
    long			dircluster;      			// first cluster of dir 
    bool 			eof;
    int volume;          /* file resides on which volume */
    
} FATFile;

//------------------------------------------------------------------------------
//
//	fat_file
//
//------------------------------------------------------------------------------

typedef struct
{
    unsigned int 	entry;							// entry idx one increase per 32byte
    unsigned int 	entrycount;						// total entries
    FATFile			file;							// file for direntry information
    unsigned char 	sectorcache[3][SECTOR_SIZE];	// 3 sector cache
    
} FATDir;



extern void 		FATInit(void);
extern int 			FATMount(int volume, int drive, unsigned int startsector, ATAFunction *pATAFunction);
extern int			FATUnmount(int volume, bool flush);
extern bool 		FATIsMounted(int volume);

extern void 		FATUpdateFreeCluster(int volume); // public for debug info screen

extern int 			FATCreateFile(const char* name,FATFile* ent,FATDir* dir);
extern int 			FATTruncate(FATFile *ent);
extern int 			FATOpen(int volume,long cluster,FATFile* ent, FATDir* dir);
extern int 			FATClose(FATFile *ent, long size, int attr);
extern long 		FATReadWrite(FATFile *ent, long sectorcount, void* buf, bool write );
extern int 			FATSeek(FATFile *ent, unsigned long sector );
extern int 			FATRemove(FATFile*ent);
extern int 			FATRename(FATFile* file, FATDir* dir,const unsigned char* newname,long size, int attr);

extern int 			FATCreateDir(const char* name,FATDir* newdir,FATDir* dir);
extern int 			FATOpenDir(int volume, FATDir *ent, unsigned long currdir,FATDir *parent_dir);

extern int 			FATGetNextDirEntry(FATDir *ent, FATDirEntry *entry);
extern unsigned int FATGetStartSector(int volume);
extern unsigned int FATGetClusterSize(int volume);
extern void 		FATGetFATSize(int volume, unsigned int *pSize, unsigned int *pFree);





#endif
