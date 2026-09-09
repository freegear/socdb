#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdarg.h>

#include "sw_fs_drv_fat.h"
//#include "../../sw_fs_system_string.h"
//#include "../../sw_fs_rbunicode.h"
//#include "../../../../drivers/storage/sdmmc/sdmmc_post_drv.h"
#include "sw_fs_system_string.h"
#include "sw_fs_rbunicode.h"
#include "sdmmc_post_drv.h"


#define	swap32(x)		(x)
#define letoh32(x) 		(x)
#define	letoh16(x)		(x)
#define htole16(x)		(x)
#define htole32(x)		(x)
#define betoh32(x) 		swap32(x)


//------------------------------------------------------------------------------
//	BYTES2INT8
//------------------------------------------------------------------------------
#define BYTES2INT08(array,pos) 													\
			(array[pos])
//------------------------------------------------------------------------------
//	BYTES2INT16
//------------------------------------------------------------------------------
#define BYTES2INT16(array,pos) 													\
			(array[pos] | (array[pos+1] << 8 ))
//------------------------------------------------------------------------------
//	BYTES2INT32
//------------------------------------------------------------------------------			
#define BYTES2INT32(array,pos) 													\
    		((long)array[pos] | ((long)array[pos+1] << 8 ) | 					\
    		((long)array[pos+2] << 16 ) | ((long)array[pos+3] << 24 ))
//------------------------------------------------------------------------------
// FS type
//------------------------------------------------------------------------------
#define FATTYPE_FAT12       		(0)
#define FATTYPE_FAT16       		(1)
#define FATTYPE_FAT32       		(2)
//------------------------------------------------------------------------------
// BPB offset
//------------------------------------------------------------------------------
#define BS_JMPBOOT          		(0 )
#define BS_OEMNAME          		(3 )
#define BPB_BYTSPERSEC      		(11)
#define BPB_SECPERCLUS      		(13)
#define BPB_RSVDSECCNT      		(14)
#define BPB_NUMFATS         		(16)
#define BPB_ROOTENTCNT      		(17)
#define BPB_TOTSEC16        		(19)
#define BPB_MEDIA           		(21)
#define BPB_FATSZ16         		(22)
#define BPB_SECPERTRK       		(24)
#define BPB_NUMHEADS        		(26)
#define BPB_HIDDSEC         		(28)
#define BPB_TOTSEC32        		(32)
//------------------------------------------------------------------------------
// FAT12/16
//------------------------------------------------------------------------------
#define BS_DRVNUM           		(36)
#define BS_RESERVED1        		(37)
#define BS_BOOTSIG          		(38)
#define BS_VOLID            		(39)
#define BS_VOLLAB           		(43)
#define BS_FILSYSTYPE       		(54)
//------------------------------------------------------------------------------
// FAT32
//------------------------------------------------------------------------------
#define BPB_FATSZ32         		(36)
#define BPB_EXTFLAGS        		(40)
#define BPB_FSVER           		(42)
#define BPB_ROOTCLUS        		(44)
#define BPB_FSINFO          		(48)
#define BPB_BKBOOTSEC       		(50)
#define BS_32_DRVNUM        		(64)
#define BS_32_BOOTSIG       		(66)
#define BS_32_VOLID         		(67)
#define BS_32_VOLLAB        		(71)
#define BS_32_FILSYSTYPE    		(82)
#define BPB_LAST_WORD      			(510)
//------------------------------------------------------------------------------
// Attribute
//------------------------------------------------------------------------------
#define FAT_ATTR_LONG_NAME   													\
									(FAT_ATTR_READ_ONLY | FAT_ATTR_HIDDEN | 	\
                              		FAT_ATTR_SYSTEM | FAT_ATTR_VOLUME_ID)
                              	
#define FAT_ATTR_LONG_NAME_MASK 												\
									(FAT_ATTR_READ_ONLY | FAT_ATTR_HIDDEN | 	\
                                 	FAT_ATTR_SYSTEM | FAT_ATTR_VOLUME_ID | 		\
                                 	FAT_ATTR_DIRECTORY | FAT_ATTR_ARCHIVE )
                                 	
#define FAT_NTRES_LC_NAME    		(0x08)
#define FAT_NTRES_LC_EXT     		(0x10)
#define FATDIR_NAME          		(0 )
#define FATDIR_ATTR          		(11)
#define FATDIR_NTRES         		(12)
#define FATDIR_CRTTIMETENTH  		(13)
#define FATDIR_CRTTIME       		(14)
#define FATDIR_CRTDATE       		(16)
#define FATDIR_LSTACCDATE    		(18)
#define FATDIR_FSTCLUSHI     		(20)
#define FATDIR_WRTTIME       		(22)
#define FATDIR_WRTDATE       		(24)
#define FATDIR_FSTCLUSLO     		(26)
#define FATDIR_FILESIZE      		(28)
#define FATLONG_ORDER        		(0 )
#define FATLONG_TYPE         		(12)
#define FATLONG_CHKSUM       		(13)
#define CLUSTERS_PER_FAT_SECTOR		(SECTOR_SIZE / 4)
#define CLUSTERS_PER_FAT16_SECTOR 	(SECTOR_SIZE / 2)
#define DIR_ENTRIES_PER_SECTOR  	(SECTOR_SIZE / DIR_ENTRY_SIZE)
#define DIR_ENTRY_SIZE       		(32)
#define NAME_BYTES_PER_ENTRY 		(13)
#define FAT_BAD_MARK         		(0x0FFFFFF7)
#define FAT_EOF_MARK         		(0x0FFFFFF8)
#define FAT_LONGNAME_PAD_BYTE 		(0xFF)
#define FAT_LONGNAME_PAD_UCS 		(0xFFFF)
//------------------------------------------------------------------------------
// fsinfo
//------------------------------------------------------------------------------
typedef struct  
{
    unsigned long freecount;		// last known free cluster count 
    unsigned long nextfree;  		// first cluster to start looking for free
                               		// clusters, or 0xffffffff for no hint 
} FSInfo;
//------------------------------------------------------------------------------
//	FATBPB
//------------------------------------------------------------------------------
#define FSINFO_FREECOUNT 			(488)
#define FSINFO_NEXTFREE  			(492)

typedef struct 
{
    int 			bpb_bytspersec;  // Bytes per sector, typically 512 
    unsigned int 	bpb_secperclus;  // Sectors per cluster 
    int 			bpb_rsvdseccnt;  // Number of reserved sectors 
    int 			bpb_numfats;     // Number of FAT structures, typically 2 
    int 			bpb_totsec16;    // Number of sectors on the volume (old 16-bit) 
    int 			bpb_media;       // Media type (typically 0xf0 or 0xf8) 
    int 			bpb_fatsz16;     // Number of used sectors per FAT structure 
    unsigned int 	bpb_totsec32;    // Number of sectors on the volume (new 32-bit) 
    unsigned int 	last_word;       // 0xAA55 

	// 
    // FAT32 specific
    //
    int 			bpb_fatsz32;	
    int 			bpb_rootclus;
    int 			bpb_fsinfo;

	
	//
    // variables for internal use 
    //
    unsigned int	fatsize;			// Sectors in FAT
    unsigned int	totalsectors;		// Total sector in FAT FS
    unsigned int	rootdirsector;		// Root directory sector (use FAT16 FS)
    unsigned int	firstdatasector;	// First Data sector
    unsigned int	startsector;		// First FAT sector
    unsigned int	dataclusters;		// Total Data cluster 
    
    FSInfo			fsinfo;
    
    //
    // internals for FAT16 support 
    //
    int 			bpb_rootentcnt;  // Number of dir entries in the root 
    bool 			is_fat16;		// true if we mounted a FAT16 partition, false if FAT32 
    unsigned int 	rootdiroffset; 	// sector offset of root dir relative 
    								// to start of first pseudo cluster 
    								

	//
	//	for multi volume	
	//
    int 			drive; 			// on which physical device is this located 
    bool 			mounted; 		// flag if this volume is mounted 

} FATBPB;
//------------------------------------------------------------------------------
//	FATCacheEntry
//------------------------------------------------------------------------------
#define FAT_CACHE_SIZE 0x1
#define FAT_CACHE_MASK (FAT_CACHE_SIZE-1)

typedef struct 
{
    int			secnum;
    bool 		inuse;
    bool 		dirty;
    FATBPB		*fat_vol; 			// shared cache for all volumes 
    
} FATCacheEntry;

//------------------------------------------------------------------------------
//	FAT static variable
//------------------------------------------------------------------------------
static 	FATBPB 			sFATBPB[NUM_VOLUMES]; 
static 	char			sFATCacheSectors[FAT_CACHE_SIZE][SECTOR_SIZE];
static 	FATCacheEntry 	sFATEntryCache[FAT_CACHE_SIZE];
static	ATAFunction		sATAFunction;

//------------------------------------------------------------------------------
// PRIVATE_Cluster2Sector (c)
//------------------------------------------------------------------------------
static 
unsigned int					// [o] sector idx
PRIVATE_Cluster2Sector(			// [d] cluster idx -> sector idx
FATBPB			*pBPB, 			// [i] current FAT BPB
unsigned int	cluster			// [i] cluster idx
)
{
	unsigned int firstCluster, sectorIdx;

	// check first clusters
 	if(pBPB->is_fat16)	firstCluster = cluster < 0 ? 0 : 2;
 	else				firstCluster = 2;		
 

	// check max cluster
    if(cluster > (pBPB->dataclusters + 1))
    {
      	/* Bad cluster number  */
        return -1;
    }

	//  get sector idx
	sectorIdx = ( (cluster - firstCluster)	
				  *pBPB->bpb_secperclus 
				  +pBPB->firstdatasector
				);
				  
    return sectorIdx;
    	
}

//------------------------------------------------------------------------------
// PRIVATE_BPBCheck (c)
//------------------------------------------------------------------------------
static 
int 							// [o]: return 0 is OK
PRIVATE_BPBCheck(				// [d]: BPB check availity
FATBPB* pBPB					// [i]: current BPB structure
)
{

    if(pBPB->bpb_bytspersec != 512)
    {
        return -1;
    }
    
    if((pBPB->bpb_secperclus*pBPB->bpb_bytspersec) > 128L*1024L)
    {
        return -2;
    }
    
    if(pBPB->bpb_numfats != 2)
    {
		/*	Warning: NumFATS is not 2 */
    }
    
    if(pBPB->bpb_media != 0xf0 && pBPB->bpb_media < 0xf8)
    {
		/* Warning: Non-standard */
    }
    
    if(pBPB->last_word != 0xaa55)
    {
        return -3;
    }

    if (pBPB->fsinfo.freecount >
        (pBPB->totalsectors - pBPB->firstdatasector)/
        pBPB->bpb_secperclus)
    {
        return -4;
    }

    return 0;
}

//------------------------------------------------------------------------------
// PRIVATE_FATCacheFlush
//------------------------------------------------------------------------------
static 
void 							
PRIVATE_FATCacheFlush(		// [d] write cache by sector buffer
FATCacheEntry *fce,			// [i] cache structure
unsigned char *sectorbuf	// [i] update data
)
{
    int rc;
    long secnum;

	//
    // With multivolume, use only the FAT info from the cached sector! 
    //
    secnum = fce->secnum + fce->fat_vol->startsector;
    //rc = ata_write_sectors(
    rc = sATAFunction.ATAWriteSectors(
    		fce->fat_vol->drive,	// device driver number
			secnum, 				// sector number
			1,						// sector count is one
			sectorbuf				// source buffer
	);
    if(rc < 0)
    {
    	/* Could not write sector */ 
    }

	//
	// write backup FAT
	//
    if(fce->fat_vol->bpb_numfats > 1)
    {
        // Write to the second FAT 
        secnum += fce->fat_vol->fatsize;
        //rc = ata_write_sectors(
        rc = sATAFunction.ATAWriteSectors(
        		fce->fat_vol->drive,	// device driver number
				secnum, 				// sector number
				1, 						// sector count
				sectorbuf				// source buffer
			);
        if(rc < 0)
        {
        	/* Could not write sector */
        }
    }
    
    //
    //	update dirty flag
    //
    fce->dirty = false;
}
//------------------------------------------------------------------------------
// PRIVATE_FATCacheControl
//------------------------------------------------------------------------------
static 
void*							// [o] cached sector buffer
PRIVATE_FATCacheControl(		// [d] read fat cache
FATBPB	*fat_bpb,				// [i] Bios parameter block info
long	fatsector, 				// [i] wanted sector
bool 	dirty					// [i] cached or dirtied
)
{

    long 					secnum 		= fatsector + fat_bpb->bpb_rsvdseccnt;
    int 					cache_index = secnum & FAT_CACHE_MASK;
    FATCacheEntry 			*fce 		= &sFATEntryCache[cache_index];
    unsigned char 			*sectorbuf 	= &sFATCacheSectors[cache_index][0];
    int rc;

 	//
    // Delete the cache entry if it isn't the sector we want 
    //
    if(
    	fce->inuse 											// cache inuse condition
    && (fce->secnum != secnum||fce->fat_vol != fat_bpb))    // sector num and volume is diff

    {
        if(fce->dirty)
        {
            PRIVATE_FATCacheFlush(fce, sectorbuf);
        }
        
        fce->inuse = false;
    }

	//
    // Load the sector if it is not cached 
    //
    if(!fce->inuse)
    {
        //rc = ata_read_sectors(
        rc = sATAFunction.ATAReadSectors(
        		fat_bpb->drive,					// driver is zero
				secnum + fat_bpb->startsector,	// source sector
				1,								// sector count is one
				sectorbuf						// target buffer
			);
			
        if(rc < 0)
        {
        	// Could not read sector 
            return NULL;
        }
        
        // update FAT entry flag
        fce->inuse 		= true;
        fce->secnum 	= secnum;
        fce->fat_vol 	= fat_bpb;
    }
    
    //
    // dirt remains, sticky until flushed 
    //
    if (dirty) 
    {
        fce->dirty = true; 
    }
    
    
    return sectorbuf;
}

//------------------------------------------------------------------------------
// PRIVATE_ClusterGetFree
//------------------------------------------------------------------------------
static 
unsigned int 						// [o]: next free cluster
PRIVATE_ClusterGetFree(				// [d]: get free cluster 
FATBPB			*fat_bpb,			// [i]: selected FAT	BPB input
unsigned int	startcluster		// [i]: start cluster 
)
{

    unsigned int sector;
    unsigned int offset;
    unsigned int i;


	//
	//	FAT16 case
	//
    if (fat_bpb->is_fat16)
    {
        sector = startcluster / CLUSTERS_PER_FAT16_SECTOR;
        offset = startcluster % CLUSTERS_PER_FAT16_SECTOR;
    
        for (i = 0; i<fat_bpb->fatsize; i++) {
        	
            unsigned int 		j;
            unsigned int 		nr 		= (i + sector) % fat_bpb->fatsize;
            unsigned short		*fat 	= PRIVATE_FATCacheControl(fat_bpb, nr, false);
            
            
            if(!fat)
            {
                break;
            }
            
            for (j = 0; j < CLUSTERS_PER_FAT16_SECTOR; j++) {
            	
                int k = (j + offset) % CLUSTERS_PER_FAT16_SECTOR;
                if (letoh16(fat[k]) == 0x0000) {
                	
                    unsigned int c = nr * CLUSTERS_PER_FAT16_SECTOR + k;
                     /* Ignore the reserved clusters 0 & 1, and also
                        cluster numbers out of bounds */
                        
                    if ( c < 2 || c > fat_bpb->dataclusters+1 )
                    {
                        continue;
                    }
                    
                    fat_bpb->fsinfo.nextfree = c;
                    return c;
                }
            }
            offset = 0;
        }
    }
    //
	//	FAT32 case
	//
    else
    {
        sector = startcluster / CLUSTERS_PER_FAT_SECTOR;
        offset = startcluster % CLUSTERS_PER_FAT_SECTOR;
    
        for(i = 0; i<fat_bpb->fatsize; i++) {
        	
        	
            unsigned int	j;
            unsigned int	nr 		= (i + sector) % fat_bpb->fatsize;
            unsigned int	*fat 	= PRIVATE_FATCacheControl(fat_bpb, nr, false);
            
            if(!fat)
            {
                break;
            }
            
            for (j = 0; j < CLUSTERS_PER_FAT_SECTOR; j++) {
            	
                int k = (j + offset) % CLUSTERS_PER_FAT_SECTOR;
                
                if (!(letoh32(fat[k]) & 0x0fffffff)) {
                	
                    unsigned long c = nr * CLUSTERS_PER_FAT_SECTOR + k;
                     /* Ignore the reserved clusters 0 & 1, and also
                        cluster numbers out of bounds */
                        
                    if( c < 2 || c > fat_bpb->dataclusters+1)
                    {
                        continue;
                    }
                    
                    fat_bpb->fsinfo.nextfree = c;
                    return c;
                }
            }
            offset = 0;
        }
    }

    return 0; /* 0 is an illegal cluster number */
}
//------------------------------------------------------------------------------
// PRIVATE_FATEntryUpdate
//------------------------------------------------------------------------------
static 
int 							// [o]: zero is Update OK
PRIVATE_FATEntryUpdate(			// [d]: FAT Entry update by value 
FATBPB			*pBPB,			// [i]: current selected BPB
unsigned int 	entry, 			// [i]: cluster entry
unsigned int 	val				// [i]: cluster maker value
)
{


    if (pBPB->is_fat16)
    {
        int sector = entry / CLUSTERS_PER_FAT16_SECTOR;
        int offset = entry % CLUSTERS_PER_FAT16_SECTOR;
        unsigned short* sec;

        val &= 0xFFFF;
        
        if(entry==val)
        {
            /* Creating FAT loop */
        }

        if( entry < 2 )
        {
            /* Updating reserved FAT entry */
        }

        sec = PRIVATE_FATCacheControl(pBPB, sector, true);
        if (!sec)
        {
            /* Could not cache sector */
            return -1;
        }

        if ( val ) {
            if (letoh16(sec[offset]) == 0x0000 && pBPB->fsinfo.freecount > 0)
                pBPB->fsinfo.freecount--;
        }
        else {
            if (letoh16(sec[offset]))
                pBPB->fsinfo.freecount++;
        }

        

        sec[offset] = htole16(val);
    }
    else
    {
        unsigned int 	sector = entry / CLUSTERS_PER_FAT_SECTOR;
        int	 			offset = entry % CLUSTERS_PER_FAT_SECTOR;
        unsigned int	*sec;

     

        if (entry==val)
        {
            /* Creating FAT loop */
        }

        if ( entry < 2 )
        {
            /* Updating reserved FAT entry */
        }

        sec = PRIVATE_FATCacheControl(pBPB, sector, true);
        if (!sec)
        {
            /* Could not cache sector */
            return -1;
        }

        if ( val ) {
            if (!(letoh32(sec[offset]) & 0x0fffffff) &&
                pBPB->fsinfo.freecount > 0)
                pBPB->fsinfo.freecount--;
        }
        else {
            if (letoh32(sec[offset]) & 0x0fffffff)
                pBPB->fsinfo.freecount++;
        }


        // don't change top 4 bits 
        sec[offset] &= htole32(0xf0000000);
        sec[offset] |= htole32(val & 0x0fffffff);
    }

    return 0;
}
//------------------------------------------------------------------------------
// PRIVATE_FATEntryRead
//------------------------------------------------------------------------------
static 
unsigned int					// [o]: next cluster 
PRIVATE_FATEntryRead(			// [d]: get next cluster in fat32 table
FATBPB			*pBPB, 			// [i]: current volume BPB
unsigned int	entry			// [i]: current cluster number
)
{


    if (pBPB->is_fat16)
    {
        int sector = entry / CLUSTERS_PER_FAT16_SECTOR;
        int offset = entry % CLUSTERS_PER_FAT16_SECTOR;
        unsigned short* sec;

        sec = PRIVATE_FATCacheControl(pBPB, sector, false);
        if (!sec)
        {
            /* Could not cache sector */
            return -1;
        }

        return letoh16(sec[offset]);
    }
    else
    {
        unsigned int 	sector = entry / CLUSTERS_PER_FAT_SECTOR;
        int 			offset = entry % CLUSTERS_PER_FAT_SECTOR;
        unsigned int	*sec;

        sec = PRIVATE_FATCacheControl(pBPB, sector, false);
        if (!sec)
        {
            /* Could not cache sector */
            return -1;
        }

        return letoh32(sec[offset]) & 0x0fffffff;
    }
}
//------------------------------------------------------------------------------
// PRVIATE_ClusterGetNext
//------------------------------------------------------------------------------
static 
unsigned int 					// [o]: next cluster
PRVIATE_ClusterGetNext(			// [d]: get next cluster
FATBPB			*fat_bpb, 		// [i]: selected BPB 
unsigned int	cluster			// [i]: current cluster
)
{
    unsigned int next_cluster;
    unsigned int eof_mark = FAT_EOF_MARK;
    

    if (fat_bpb->is_fat16)
    {
        eof_mark &= 0xFFFF; 	/* only 16 bit */
        if (cluster < 0) 		/* FAT16 root dir */
            return cluster + 1; /* don't use the FAT */
    }

    next_cluster = PRIVATE_FATEntryRead(fat_bpb, cluster);

    // is this last cluster in chain 
    if ( next_cluster >= eof_mark )
        return 0;
    else
        return next_cluster;
}
//------------------------------------------------------------------------------
// PRIVATE_FSInfoUpdate
//------------------------------------------------------------------------------
static 
int 						// [o]: zero is update OK!!
PRIVATE_FSInfoUpdate(		// [d]: FS information update
FATBPB* pBPB				// [i]: selected BPB
)
{

    unsigned char fsinfo[SECTOR_SIZE];
    unsigned int* intptr;
    int rc;

	// FAT16 has no FsInfo 
    if (pBPB->is_fat16) {
        return 0; 
    }
    
    // read FS information
    //rc = ata_read_sectors(
	rc = sATAFunction.ATAReadSectors(
    		pBPB->drive,								// selected device
			pBPB->startsector + pBPB->bpb_fsinfo, 		// seleced sector
			1,											// sector count
			fsinfo										// fsinfo
		);
    if (rc < 0)
    {
        /* Couldn't read FSInfo */
        return rc * 10 - 1;
    }
    intptr = (int*)&(fsinfo[FSINFO_FREECOUNT]);
    *intptr = htole32(pBPB->fsinfo.freecount);

    intptr = (int*)&(fsinfo[FSINFO_NEXTFREE]);
    *intptr = htole32(pBPB->fsinfo.nextfree);

	// write FS information
    //rc = ata_write_sectors(
    rc = sATAFunction.ATAWriteSectors(
    			pBPB->drive,							// selected deivce
				pBPB->startsector + pBPB->bpb_fsinfo,	// selected sector
				1,										// sector count
				fsinfo									// fsinfo
			);
    if (rc < 0)
    {
        /* Couldn't write FSInfo */
        return rc * 10 - 2;
    }

    return 0;
}
//------------------------------------------------------------------------------
// PRIVATE_FATCacheFlushAll
//------------------------------------------------------------------------------
static 
int 							// [o]: zero is all flush OK!!!
PRIVATE_FATCacheFlushAll(		// [d]: FAT cache flush all
FATBPB* pBPB					// [i]: selected BPB
)
{
	
    int i;
    int rc;
    unsigned char *sec;
    
    
    for(i = 0;i < FAT_CACHE_SIZE;i++)
    {
        FATCacheEntry *fce = &sFATEntryCache[i];
        if(fce->inuse 
        && (fce->fat_vol == pBPB)
		&& fce->dirty)
        {
            sec = sFATCacheSectors[i];
            PRIVATE_FATCacheFlush(fce, sec);
        }
    }

    rc = PRIVATE_FSInfoUpdate(pBPB);
    if (rc < 0)
        return rc * 10 - 3;

    return 0;

}
//------------------------------------------------------------------------------
// PRIVATE_FATTimeGet
//------------------------------------------------------------------------------
static 
void 
PRIVATE_FATTimeGet(			// [d]: get data/time/milsec information
unsigned short *date,		// [o]: data fat format
unsigned short *time,		// [o]: time fat format
unsigned short *tenth 		// [o]: mili sec fat format
)
{

	/* later time implemeted */

}
//------------------------------------------------------------------------------
// PRIVATE_FATLongNameCopySegment
//------------------------------------------------------------------------------
/* Copies a segment of long file name (UTF-16 LE encoded) to the
 * destination buffer (UTF-8 encoded). Copying is stopped when
 * either 0x0000 or 0xffff (FAT pad char) is encountered.
 * Trailing \0 is also appended at the end of the UTF8-encoded
 * string.
 *
 * utf16src   utf16 (little endian) segment to copy
 * utf16count max number of the utf16-characters to copy
 * utf8dst    where to write UTF8-encoded string to
 *
 * returns the number of UTF-16 characters actually copied
 */
static 
int 
PRIVATE_FATLongNameCopySegment(
unsigned char 	*utf16src,
int 			utf16count, 
unsigned char 	*utf8dst
) 
{	
	
    int cnt = 0;
    
    while ((utf16count--) > 0) 
    {
        unsigned short ucs = (utf16src[0] | (utf16src[1] << 8));
        
        if ((ucs == 0) || (ucs == FAT_LONGNAME_PAD_UCS)) 
        {
            break;
        }
        
        utf8dst 	= utf8encode(ucs, utf8dst);
        utf16src	+= 2;
        cnt++;
    }
    
    *utf8dst = 0;
    
    return cnt;
}
//------------------------------------------------------------------------------
// write_long_name
//------------------------------------------------------------------------------
static 
int 
PRIVATE_FATLongNameWrite(
FATFile				*file,			// [b] file index
unsigned int 		firstentry,		// [i] first entry idx
unsigned int 		numentries,		// [i] number of entry
const unsigned char	*name,			// [i] name
const unsigned char	*shortname,		// [i] short name
bool 				is_directory	// [i] directory flag
)
{	
    unsigned char 	buf[SECTOR_SIZE];
    unsigned char	*entry;
    unsigned int 	idx 	= firstentry % DIR_ENTRIES_PER_SECTOR;
    unsigned int 	sector 	= firstentry / DIR_ENTRIES_PER_SECTOR;
    unsigned char 	chksum 	= 0;
    unsigned int	i		= 0;
    unsigned int	j		= 0;
    unsigned int	nameidx	= 0;
    unsigned int 	namelen = utf8length(name);
    int 			rc;
    unsigned short 	name_utf16[512];


	//
	//	read directory entry
	//
	
    rc = FATSeek(file, sector);
    if (rc<0)
	{
        return rc * 10 - 1;
    }

    rc = FATReadWrite(file, 1, buf, false);
    if (rc<1)
    {
        return rc * 10 - 2;
    }

	//
    // calculate shortname checksum 
    //
    for (i=11; i>0; i--)
    {
        chksum = ((chksum & 1) ? 0x80 : 0) + (chksum >> 1) + shortname[j++];
	}

	//
    // calc position of last name segment 
    //
    if ( namelen > NAME_BYTES_PER_ENTRY )
	{
        for (nameidx=0;
             nameidx < (namelen - NAME_BYTES_PER_ENTRY);
             nameidx += NAME_BYTES_PER_ENTRY);
	}

	//
    // we need to convert the name first   
    // since it is written in reverse order
    // 
    for (i = 0; i <= namelen; i++)
   	{
        name = utf8decode(name, &name_utf16[i]);
    }

	//
	//	
	//
    for (i=0; i < numentries; i++) 
    {
    	

        if ( idx >= DIR_ENTRIES_PER_SECTOR ) 
		{
            //
            //	seek and write entry
            //
            rc = FATSeek(file, sector);
            if (rc<0)
            {
                return rc * 10 - 3;
			}
            rc = FATReadWrite(file, 1, buf, true);
            if (rc<1)
            {
                return rc * 10 - 4;
            }

			//
            //	seek and read entry
            //
            rc = FATReadWrite(file, 1, buf, false);
            if (rc<0) 
            {
                FSDBGPrintf(" Failed writing new sector \n");
                return rc * 10 - 5;
            }
            
            if (rc==0)
            {
                // end of dir 
                memset(buf, 0, sizeof buf);
            }

            sector++;
            idx = 0;
        }

        entry = buf + idx * DIR_ENTRY_SIZE;

        // verify this entry is free 
        if (entry[0] && entry[0] != 0xE5)
        {
        	FSDBGPrintf(" Dir entry %d in sector %x is not free!");
        }

        memset(entry, 0, DIR_ENTRY_SIZE);
        if ( i+1 < numentries ) {
        	
        	//
            // longname entry 
            //
            
            unsigned int k, l = nameidx;

            entry[FATLONG_ORDER] = numentries-i-1;
            if (i==0) 
			{
                // mark this as last long entry 
                entry[FATLONG_ORDER] |= 0x40;

                // pad name with 0xffff  
                for (k=1;  k<11; k++) entry[k] = FAT_LONGNAME_PAD_BYTE;
                for (k=14; k<26; k++) entry[k] = FAT_LONGNAME_PAD_BYTE;
                for (k=28; k<32; k++) entry[k] = FAT_LONGNAME_PAD_BYTE;
            };
            
            // set name 
            for (k=0; k<5 && l <= namelen; k++) {
                entry[k*2 + 1] = (unsigned char)(name_utf16[l] & 0xff);
                entry[k*2 + 2] = (unsigned char)(name_utf16[l++] >> 8);
            }
            for (k=0; k<6 && l <= namelen; k++) {
                entry[k*2 + 14] = (unsigned char)(name_utf16[l] & 0xff);
                entry[k*2 + 15] = (unsigned char)(name_utf16[l++] >> 8);
            }
            for (k=0; k<2 && l <= namelen; k++) {
                entry[k*2 + 28] = (unsigned char)(name_utf16[l] & 0xff);
                entry[k*2 + 29] = (unsigned char)(name_utf16[l++] >> 8);
            }

            entry[FATDIR_ATTR] 		= FAT_ATTR_LONG_NAME;
            entry[FATDIR_FSTCLUSLO] = 0;
            entry[FATLONG_TYPE] 	= 0;
            entry[FATLONG_CHKSUM] 	= chksum;
        }
        else 
        {
        	
        	//
            // shortname entry 
            //
            
            unsigned short date, time, tenth;
            
            date 	= 0;
            time 	= 0;
            tenth	= 0;
            
            PRIVATE_FATTimeGet(&date, &time, &tenth);
            
            
            strncpy(entry + FATDIR_NAME, shortname, 11);					// write name to buffer
            entry[FATDIR_ATTR] 	= is_directory?FAT_ATTR_DIRECTORY:0;		// write file attribute
            entry[FATDIR_NTRES] = 0;										// write NT resource
            entry[FATDIR_CRTTIMETENTH] = (unsigned char)tenth;				// write create tenth
            *(unsigned short*)(entry + FATDIR_CRTTIME) = htole16(time);		// write create time
            *(unsigned short*)(entry + FATDIR_WRTTIME) = htole16(time);		// write write time
            *(unsigned short*)(entry + FATDIR_CRTDATE) = htole16(date);		// write create date
            *(unsigned short*)(entry + FATDIR_WRTDATE) = htole16(date);		// write write date
            *(unsigned short*)(entry + FATDIR_LSTACCDATE) = htole16(date);	// write last access date
        }
        idx++;
        nameidx -= NAME_BYTES_PER_ENTRY;
    }

	//
    // update last entry  
    //
    rc = FATSeek(file, sector);
    if (rc<0)
    {
        return rc * 10 - 6;
    }

    rc = FATReadWrite(file, 1, buf, true);
    if (rc<1)
    {
        return rc * 10 - 7;
    }
    
    return 0;  
}
//------------------------------------------------------------------------------
// PRIVATE_FATNameCheck
//------------------------------------------------------------------------------
static 
int 
PRIVATE_FATNameCheck(
const unsigned char* newname
)
{
    /* More sanity checks are probably needed */
    if ( newname[strlen(newname) - 1] == '.' ) {
        return -1;
    }
    return 0; 
}
//------------------------------------------------------------------------------
// PRIVATE_Char2DOS
//------------------------------------------------------------------------------
static
unsigned char 
PRIVATE_Char2DOS(
unsigned char c
)
{	
    switch(c)
    {
        case 0x22:
        case 0x2a:
        case 0x2b:
        case 0x2c:
        case 0x2e:
        case 0x3a:
        case 0x3b:
        case 0x3c:
        case 0x3d:
        case 0x3e:
        case 0x3f:
        case 0x5b:
        case 0x5c:
        case 0x5d:
        case 0x7c:
            /* Illegal char, replace */
            c = '_';
            break;
                
        default:
            if(c <= 0x20)
                c = 0;   /* Illegal char, remove */
            else
                c = toupper(c);
            break;
    }
    return c; 
}
//------------------------------------------------------------------------------
// PRIVATE_FATDOSNameCreate
//------------------------------------------------------------------------------
static 
void 
PRIVATE_FATDOSNameCreate(
const unsigned char *name, 
unsigned char 		*newname
)
{	
    int i;
    unsigned char 	*ext;     
    unsigned char	ch; 

	//
    // Find extension part 
    //
    
    ext = strrchr(name, '.');
    if (ext == name)     
    {    
    	// handle .dotnames 
        ext = NULL;
    }

	//
    // Name part 
    //
    
    for (i = 0; *name && (!ext || name < ext) && (i < 8); name++)
    {
        ch = PRIVATE_Char2DOS(*name);
        if (ch) newname[i++] = ch;
    }

	//
    // Pad both name and extension 
    //
    
    while (i < 11) 
    {
        newname[i++] = ' ';
    }

	//
	// Special kanji character 
	//
	
    if (newname[0] == 0xe5) 
    {
        newname[0] = 0x05;
    }

	//
	// Extension part 
	//
	
    if (ext)
    {   
        ext++;
        for (i = 8; *ext && (i < 11); ext++)
        {
            ch = PRIVATE_Char2DOS(*ext);
            if (ch) newname[i++] = ch;
        }
    } 
}


//------------------------------------------------------------------------------
// randomize_dos_name
//------------------------------------------------------------------------------
static 
void 
PRIVATE_DOSNameRandomize(
unsigned char *name
)
{
    int i;
    unsigned char buf[5];

    snprintf(buf, sizeof(buf), "%04X", (unsigned)rand() & 0xffff);

    for (i = 0; (i < 4) && (name[i] != ' '); i++);
    
    // account for possible shortname length < 4 
    memcpy(&name[i], buf, 4);
}
//------------------------------------------------------------------------------
// PRIVATE_FATDirEntryAdd
//------------------------------------------------------------------------------
static 
int 
PRIVATE_FATDirEntryAdd(
FATDir		*dir,			// [b] parent directory index
FATFile		*file,			// [b] new directory/file file index
const char	*name,			// [i] new directory/file name
bool 		is_directory,	// [i] directory enble flag
bool 		dotdir			// [i] dot directory enable flag
)
{
    FATBPB			*fat_bpb = &sFATBPB[dir->file.volume];
    unsigned char 	buf[SECTOR_SIZE];
    unsigned char 	shortname[12];
    int 			rc;
    unsigned int 	sector;
    bool 			done = false;
    int 			entries_needed, entries_found = 0;
    int 			firstentry;


	//
    // Don't check dotdirs name for validity 
    //
    
    if (dotdir == false)
    {
        rc = PRIVATE_FATNameCheck(name);
        // filename is invalid 
        if (rc < 0) 
        {
            return rc * 10 - 1;
        }
    }

	//
	// inherit the volume, to make sure 
	//
	
    file->volume = dir->file.volume; 


    // The "." and ".." directory entries must not be long names 
    if(dotdir) 
    {
        int i;
        
        strncpy(shortname, name, 12);
        for(i = strlen(shortname); i < 12; i++)
        {
            shortname[i] = ' ';
        }
        
        entries_needed = 1;
    } 
    else 
    {
    	
        PRIVATE_FATDOSNameCreate(name, shortname);

        /*
			one dir entry needed for every 13 bytes of filename,
          	plus one entry for the short name 
        */
        entries_needed 
        	= (utf8length(name) + (NAME_BYTES_PER_ENTRY-1)) / NAME_BYTES_PER_ENTRY + 1;
    }

restart:
	
    firstentry = -1;
    
    rc = FATSeek(&dir->file, 0);
    if (rc < 0)
    {
        return rc * 10 - 2;
    }

	//
    // step 1: search for free entries and check for duplicate shortname 
    //
    
    for (sector = 0; !done; sector++)
    {
        unsigned int i;

		//
		// read directory entry
		//
        rc = FATReadWrite(&dir->file, 1, buf, false);
        if (rc < 0) {
            FSDBGPrintf("Couldn't read dir\n");
            return rc * 10 - 3;
        }
        if (rc == 0) { 
        	FSDBGPrintf("End of dir on cluster boundary\n");
            break;
        }

		//
        // look for free directory entry 
        //
        for (i = 0; i < DIR_ENTRIES_PER_SECTOR /*128*/; i++)
        {
			switch (buf[i * DIR_ENTRY_SIZE]) {
            	
              	case 0x00:	
              		
              		//
              		// Found end of dir 
              		//
              		
                	entries_found 	+= (DIR_ENTRIES_PER_SECTOR - i);
                	i 				=  (DIR_ENTRIES_PER_SECTOR - 1);
                	done 			= true;
                	break;

				
				case 0xE5:	
					
					//
					// Found free entry 
					//
					
                	entries_found++;
                	break;

              	default:
              		
                	entries_found = 0;

                	// check that our intended shortname doesn't already exist 
                	if (!strncmp(shortname, buf + i * DIR_ENTRY_SIZE, 11)) 
                	{
                	
                    	// shortname exists already, make a new one 
                    	PRIVATE_DOSNameRandomize(shortname);
                    
                    	// name has changed, we need to restart search 
                    	goto restart;
                	}
                	break;
            }
            
            
            //
            //	found empty directory entry
            //
            
            if (firstentry < 0 						
            && (entries_found >= entries_needed))
            {
            	
                firstentry = sector * DIR_ENTRIES_PER_SECTOR + i + 1
                             - entries_found;
			}
        }
    }
	
	
	//
    // step 2: extend the dir if necessary 
    //
    
    if (firstentry < 0)
    {
    	
        rc = FATSeek(&dir->file, sector);
        if (rc < 0)
        {
            return rc * 10 - 4;
        }
        memset(buf, 0, sizeof buf);

        // we must clear whole clusters 
        for (; 
			(entries_found < entries_needed) ||
			(dir->file.sectornum < (int)fat_bpb->bpb_secperclus); 
              sector++)
        {
            if (sector >= (65536/DIR_ENTRIES_PER_SECTOR))
            {
            	// dir too large -- FAT specification 
                return -5; 
            }

            rc = FATReadWrite(&dir->file, 1, buf, true);
            if (rc < 1)
            {
            	// No more room or something went wrong 
                return rc * 10 - 6;
            }

            entries_found += DIR_ENTRIES_PER_SECTOR;
        }

        firstentry = sector*DIR_ENTRIES_PER_SECTOR - entries_found;
    }

	//
    // step 3: add entry 
    //
    sector	= firstentry / DIR_ENTRIES_PER_SECTOR;
    rc		= PRIVATE_FATLongNameWrite(
    				&dir->file, 			
    				firstentry,
					entries_needed, 
					name, 
					shortname, 
					is_directory
				);
				
    if (rc < 0) return rc * 10 - 7;

    // remember where the shortname dir entry is located 
    file->direntry 		= firstentry + entries_needed - 1;
    file->direntries 	= entries_needed;
    file->dircluster 	= dir->file.firstcluster;

    return 0;  
}

//------------------------------------------------------------------------------
// PRIVATE_ShortEntryUpdate
//------------------------------------------------------------------------------
static 
int 
PRIVATE_ShortEntryUpdate( 
FATFile	*file, 			// [i] directory/file cluster information
long 	size, 			// [i] directory/file size
int		attr 			// [i] attribute
)
{	
    unsigned char buf[SECTOR_SIZE];
    int sector = file->direntry / DIR_ENTRIES_PER_SECTOR;
    unsigned char* entry =
        buf + DIR_ENTRY_SIZE * (file->direntry % DIR_ENTRIES_PER_SECTOR);
    unsigned long* sizeptr;
    unsigned short* clusptr;
    FATFile dirEntry;
    int rc;

	//
    // create a temporary file handle for the dir holding this file 
    //
    rc = FATOpen(file->volume, file->dircluster, &dirEntry, NULL);
    if (rc < 0)
    {
        return rc * 10 - 1;
    }

    rc = FATSeek( &dirEntry, sector );
    if (rc<0)
    {
        return rc * 10 - 2;
    }

    rc = FATReadWrite(&dirEntry, 1, buf, false);
    if (rc < 1)
    {
        return rc * 10 - 3;
    }

    if (entry[0] == 0x00 || entry[0] == 0xE5)
    {
       /* Updating size on empty dir entry */
    }
        
    entry[FATDIR_ATTR] = attr & 0xFF;

    clusptr = (short*)(entry + FATDIR_FSTCLUSHI);
    *clusptr = (short)htole16(file->firstcluster >> 16);
    
    clusptr = (short*)(entry + FATDIR_FSTCLUSLO);
    *clusptr = (short)htole16(file->firstcluster & 0xffff);

    sizeptr = (long*)(entry + FATDIR_FILESIZE);
    *sizeptr = (unsigned int)htole32(size);

    {

        unsigned short time = 0;
        unsigned short date = 0;
        
        PRIVATE_FATTimeGet(&date, &time, NULL);
        *(unsigned short*)(entry + FATDIR_WRTTIME) = htole16(time);
        *(unsigned short*)(entry + FATDIR_WRTDATE) = htole16(date);
        *(unsigned short*)(entry + FATDIR_LSTACCDATE) = htole16(date);
    }

    rc = FATSeek( &dirEntry, sector );
    if (rc < 0)
        return rc * 10 - 4;

    rc = FATReadWrite(&dirEntry, 1, buf, true);
    if (rc < 1)
        return rc * 10 - 5;

    return 0;    
}
//------------------------------------------------------------------------------
// PRIVATE_DirEntryParse
//------------------------------------------------------------------------------
static 
int 
PRIVATE_DirEntryParse(
FATDirEntry			*de, 
const unsigned char *buf
)
{
    int i=0,j=0;
    unsigned char c;
    bool lowercase;

    memset(de, 0, sizeof(FATDirEntry));
    de->attr 			= buf[FATDIR_ATTR];
    de->crttimetenth 	= buf[FATDIR_CRTTIMETENTH];
    de->crtdate 		= BYTES2INT16(buf,FATDIR_CRTDATE);
    de->crttime 		= BYTES2INT16(buf,FATDIR_CRTTIME);
    de->wrtdate 		= BYTES2INT16(buf,FATDIR_WRTDATE);
    de->wrttime 		= BYTES2INT16(buf,FATDIR_WRTTIME);
    de->filesize 		= BYTES2INT32(buf,FATDIR_FILESIZE);
    de->firstcluster 	= ((long)(unsigned)BYTES2INT16(buf,FATDIR_FSTCLUSLO)) |
        				  ((long)(unsigned)BYTES2INT16(buf,FATDIR_FSTCLUSHI) << 16);
        				  
        				  
    /* The double cast is to prevent a sign-extension to be done on CalmRISC16.
       (the result of the shift is always considered signed) */
       
    /* fix the name */
    lowercase = (buf[FATDIR_NTRES] & FAT_NTRES_LC_NAME);
    c = buf[FATDIR_NAME];
    if (c == 0x05)  /* special kanji char */
        c = 0xe5;
    i = 0;
    while (c != ' ') {
        de->name[j++] = lowercase ? tolower(c) : c;
        if (++i >= 8)
            break;
        c = buf[FATDIR_NAME+i];
    }
    if (buf[FATDIR_NAME+8] != ' ') {
        lowercase = (buf[FATDIR_NTRES] & FAT_NTRES_LC_EXT);
        de->name[j++] = '.';
        for (i = 8; (i < 11) && ((c = buf[FATDIR_NAME+i]) != ' '); i++)
            de->name[j++] = lowercase ? tolower(c) : c;
    }
    return 1; 
}
//------------------------------------------------------------------------------
// PRIVATE_DirEntryFree
//------------------------------------------------------------------------------
static 
int 
PRIVATE_DirEntryFree(
FATFile	*file
)
{
    unsigned char 		buf[SECTOR_SIZE];
    FATFile 			dir;
    int 				numentries 	= file->direntries;
    unsigned int 		entry 		= file->direntry - numentries + 1;
    unsigned int 		sector 		= entry / DIR_ENTRIES_PER_SECTOR;
    int 				i;
    int 				rc;

    // create a temporary file handle for the dir holding this file 
    rc = FATOpen(file->volume, file->dircluster, &dir, NULL);
    if (rc < 0)
        return rc * 10 - 1;

    rc = FATSeek( &dir, sector );
    if (rc < 0)
        return rc * 10 - 2;

    rc = FATReadWrite(&dir, 1, buf, false);
    if (rc < 1)
        return rc * 10 - 3;

    for (i=0; i < numentries; i++) {

        buf[(entry % DIR_ENTRIES_PER_SECTOR) * DIR_ENTRY_SIZE] = 0xe5;
        entry++;

        if ( (entry % DIR_ENTRIES_PER_SECTOR) == 0 ) {
            // flush this sector 
            rc = FATSeek(&dir, sector);
            if (rc < 0)
                return rc * 10 - 4;

            rc = FATReadWrite(&dir, 1, buf, true);
            if (rc < 1)
                return rc * 10 - 5;

            if ( i+1 < numentries ) {
                // read next sector 
                rc = FATReadWrite(&dir, 1, buf, false);
                if (rc < 1)
                    return rc * 10 - 6;
            }
            sector++;
        }
    }

    if ( entry % DIR_ENTRIES_PER_SECTOR ) {
        // flush this sector 
        rc = FATSeek(&dir, sector);
        if (rc < 0)
            return rc * 10 - 7;
            
        rc = FATReadWrite(&dir, 1, buf, true);
        if (rc < 1)
            return rc * 10 - 8;
    }

    return 0;  
}
//------------------------------------------------------------------------------
// PRIVATE_ClusterNextWrite
//------------------------------------------------------------------------------
static 
long 
PRIVATE_ClusterNextWrite(
FATFile		*file,
long 		oldcluster,
long		*newsector
)
{

    FATBPB	*fat_bpb 	= &sFATBPB[file->volume];
    long 	cluster 	= 0;
    long 	sector;

    
    if (oldcluster)
    {
        cluster = PRVIATE_ClusterGetNext(fat_bpb, oldcluster);
    }

    if (!cluster) {
    	
        if (oldcluster > 0)
        {
            cluster = PRIVATE_ClusterGetFree(fat_bpb, oldcluster+1);
        }
        else if (oldcluster == 0)
    	{
            cluster = PRIVATE_ClusterGetFree(fat_bpb, fat_bpb->fsinfo.nextfree);
        }
        else // negative, pseudo-cluster of the root dir 
        {
            return 0; // impossible to append something to the root 
        }

        if (cluster) {
        	
            if (oldcluster)
            {
                PRIVATE_FATEntryUpdate(fat_bpb, oldcluster, cluster); 
            }
            else
            {
                file->firstcluster = cluster;
            }
            PRIVATE_FATEntryUpdate(fat_bpb, cluster, FAT_EOF_MARK);
        }
        else 
        {
            return 0;
        }
    }
    sector = PRIVATE_Cluster2Sector(fat_bpb, cluster);
    if(sector<0)
    {
        return 0;
    }

    *newsector = sector;
    return cluster;
  
}
//------------------------------------------------------------------------------
// PRVITE_FATTransfer
//------------------------------------------------------------------------------
static 
int 
PRVITE_FATTransfer(
FATBPB			*fat_bpb,
unsigned long	start, 
long			count, 
char			*buf, 
bool			write 
)
{

    int rc;

    if (write) 
    {
    	
        unsigned long firstallowed;

        if (fat_bpb->is_fat16)
            firstallowed = fat_bpb->rootdirsector;
        else
            firstallowed = fat_bpb->firstdatasector;
            
        if (start < firstallowed)
        {
            /* Write %ld before data */
        }
        
        if (start + count > fat_bpb->totalsectors)
        {
            /* "Write after data */
        }
        //rc = ata_write_sectors(
        rc = sATAFunction.ATAWriteSectors(
        			fat_bpb->drive,
        			start + fat_bpb->startsector, 
        			count, 
        			buf);
    }
    else
	{
        //rc = ata_read_sectors(
		rc = sATAFunction.ATAReadSectors(
        			fat_bpb->drive,
        			start + fat_bpb->startsector, 
        			count, 
        			buf);
	}
	
    if (rc < 0) {
    	
    	/* Couldn't %s sector */
        return rc;
    }
    
    
    return 0; 
}


//------------------------------------------------------------------------------
// FATGetStartSector
//------------------------------------------------------------------------------
unsigned int 					// [o]: get start sector idx
FATGetStartSector(				// [d]: get first sector idx
int volume						// [i]: volume idx
)
{
    FATBPB	*fat_bpb = &sFATBPB[volume];
    return 	fat_bpb->startsector;
}
//------------------------------------------------------------------------------
// FATSize
//------------------------------------------------------------------------------
void 
FATGetFATSize(					// [o]: get FAT(file allocation table) size
int 			volume, 		// [i]: wanted partition number
unsigned int	*pSize, 		// [o]: all one FAT size in byte
unsigned int	*pFree			// [o]: free one FAT size in byte
)
{

    FATBPB	*pBPB = &sFATBPB[volume];
    
    if(pSize)
    {
      *pSize = (pBPB->dataclusters*pBPB->bpb_secperclus)/2;
    }
    
    if(pFree)
    {
      *pFree = (pBPB->fsinfo.freecount*pBPB->bpb_secperclus)/2;
    }
}
//------------------------------------------------------------------------------
// fat_init
//------------------------------------------------------------------------------
void 
FATInit(
void
)
{
    unsigned int i;

    //mutex_init(&cache_mutex);

	//
    // mark the FAT cache as unused 
    //
    for(i = 0;i < FAT_CACHE_SIZE;i++)
    {
        sFATEntryCache[i].secnum		= 8; 		// We use a "safe" sector just in case 
        sFATEntryCache[i].inuse 		= false;
        sFATEntryCache[i].dirty 		= false;
		sFATEntryCache[i].fat_vol		= NULL;
    }

	//
    // mark the possible volumes as not mounted 
    //
    for (i=0; i<NUM_VOLUMES;i++)
    {
        sFATBPB[i].mounted = false;
    }
    
    
    

}
//------------------------------------------------------------------------------
// FATMount
//------------------------------------------------------------------------------
int 
FATMount(
int	 			volume,
int				drive,
unsigned int	startsector,
ATAFunction 	*pATAFunction
)
{
    FATBPB			*pBPB = &sFATBPB[volume];	// bpb structure of volume 0
    unsigned char 	buf[SECTOR_SIZE];				// sector buffer
    int				rc;								// 
    long			datasec;						// 
    int				rootdirsectors;					// 

    //
    //	set ATA function
    //
    sATAFunction.ATAEnable 			= pATAFunction->ATAEnable;
    sATAFunction.ATASpinDown 		= pATAFunction->ATASpinDown;
    sATAFunction.ATAPowerOff 		= pATAFunction->ATAPowerOff;
    sATAFunction.ATASleep 			= pATAFunction->ATASleep;
    sATAFunction.ATADiskIsActive 	= pATAFunction->ATADiskIsActive;
    sATAFunction.ATAHardReset 		= pATAFunction->ATAHardReset;
    sATAFunction.ATASoftReset 		= pATAFunction->ATASoftReset;
    sATAFunction.ATAInit	 		= pATAFunction->ATAInit;
    sATAFunction.ATAReadSectors 	= pATAFunction->ATAReadSectors;
    sATAFunction.ATAWriteSectors 	= pATAFunction->ATAWriteSectors;
    sATAFunction.ATASpin 			= pATAFunction->ATASpin;
    sATAFunction.ATAGetIdentify 	= pATAFunction->ATAGetIdentify;  

	//
    // Read MBR	sector
    //	
    //rc = ata_read_sectors(drive, startsector,1,buf);
    rc = sATAFunction.ATAReadSectors(drive, startsector, 1, buf);
    if(rc)
    {
        FSDBGPrintf("FATMount: Couldn't read BPB (error code %d)\n", rc);
        return rc * 10 - 1;
    }

	//
	//	clear fat bpb
	//
    memset(pBPB, 0, sizeof(FATBPB));
    pBPB->startsector    = startsector;							// set MBR secor
    pBPB->drive          = drive;								// if multi drive
    
  


    pBPB->bpb_bytspersec = BYTES2INT16(buf,	BPB_BYTSPERSEC);	// get byter/sector
    pBPB->bpb_secperclus = BYTES2INT08(buf,	BPB_SECPERCLUS);	// get sec/cluster
    pBPB->bpb_rsvdseccnt = BYTES2INT16(buf,	BPB_RSVDSECCNT);	// get reserve sector
    pBPB->bpb_numfats    = BYTES2INT08(buf,	BPB_NUMFATS);		// get number of FAT
    pBPB->bpb_totsec16   = BYTES2INT16(buf,	BPB_TOTSEC16);		// get total sector fat16
    pBPB->bpb_media      = BYTES2INT08(buf,	BPB_MEDIA);			// get media type
    pBPB->bpb_fatsz16    = BYTES2INT16(buf,	BPB_FATSZ16);		// get sector counter of fat16
    pBPB->bpb_fatsz32    = BYTES2INT32(buf,	BPB_FATSZ32);		// get sector counter of fat32
    pBPB->bpb_totsec32   = BYTES2INT32(buf,	BPB_TOTSEC32);		// get total sector size of fat32
    pBPB->last_word      = BYTES2INT16(buf,	BPB_LAST_WORD);		// get Magic code

	//
    // get FAT size
    //
    if(pBPB->bpb_fatsz16 != 0)
    {
        pBPB->fatsize = pBPB->bpb_fatsz16;
    }
    else
    {
        pBPB->fatsize = pBPB->bpb_fatsz32;
    }

    if (pBPB->bpb_totsec16 != 0)
    {
        pBPB->totalsectors = pBPB->bpb_totsec16;
    }
    else
	{
        pBPB->totalsectors = pBPB->bpb_totsec32;
    }


	if(pBPB->bpb_fatsz16) 
	{

	    pBPB->bpb_rootentcnt 	= BYTES2INT16(buf,BPB_ROOTENTCNT);
	    rootdirsectors 				= ((pBPB->bpb_rootentcnt * 32)
    								+ (pBPB->bpb_bytspersec - 1)) / pBPB->bpb_bytspersec;
    								
		pBPB->firstdatasector 	= pBPB->bpb_rsvdseccnt
									+ rootdirsectors
									+ pBPB->bpb_numfats * pBPB->fatsize;    								
	} 
	else
	{
		// First data Sec = (Reserver Sec(BPB) + (NFAT*FAT/Sec))
		pBPB->firstdatasector 	= pBPB->bpb_rsvdseccnt
									+ pBPB->bpb_numfats * pBPB->fatsize;
	}
    
        						
        						
    // Determine FAT type 
    datasec 					= pBPB->totalsectors - pBPB->firstdatasector;
    pBPB->dataclusters 			= datasec / pBPB->bpb_secperclus;


    if ( pBPB->dataclusters < 65525 )
    { 
    	
		if(pBPB->bpb_fatsz16) 
		{
        	pBPB->is_fat16 = true;
        
        	// FAT12 
        	if (pBPB->dataclusters < 4085)
        	{ 
            	//DBPrintf("This is FAT12. Go away!\n");
            	return -2;
        	}
        }
        else
        {

	        //DBPrintf("This is not FAT32. Go away!\n");
    	    return -2;
    	}
        
    }


	// FAT16 specific part of BPB 
    if (pBPB->is_fat16)
    { 
        int dirclusters;  
        pBPB->rootdirsector	= pBPB->bpb_rsvdseccnt
            					+ pBPB->bpb_numfats * pBPB->bpb_fatsz16;

		// rounded up, to full clusters 
        dirclusters 			= ((rootdirsectors + pBPB->bpb_secperclus - 1)
            					/ pBPB->bpb_secperclus); 
            					
        // I assign negative pseudo cluster numbers for the root directory,
        // their range is counted upward until -1.
           
        // backwards, before the data 
        pBPB->bpb_rootclus 	= 0 - dirclusters; 
        pBPB->rootdiroffset 	= dirclusters * pBPB->bpb_secperclus
            					- rootdirsectors;
    }
    else
    { /* FAT32 specific part of BPB */
        pBPB->bpb_rootclus  = BYTES2INT32(buf,BPB_ROOTCLUS);
        pBPB->bpb_fsinfo    = BYTES2INT16(buf,BPB_FSINFO);
        pBPB->rootdirsector = PRIVATE_Cluster2Sector(pBPB, pBPB->bpb_rootclus);
    }

    rc = PRIVATE_BPBCheck(pBPB);
    if (rc < 0)
    {
        //DBPrintf( "fat_mount() - BPB is not sane\n");
        return rc * 10 - 3;
    }

    if (pBPB->is_fat16)
    {
        pBPB->fsinfo.freecount 	= 0xffffffff; // force recalc below 
        pBPB->fsinfo.nextfree 	= 0xffffffff;
    }
    else
    {
        // Read the fsinfo sector 
        //rc = ata_read_sectors(
        rc = sATAFunction.ATAReadSectors(
        		drive, 
            	startsector + pBPB->bpb_fsinfo, 
            	1, 
            	buf);
            	
        if (rc < 0)
        {
            FSDBGPrintf( "fat_mount() - Couldn't read FSInfo (error code %d)\n", rc);
            return rc * 10 - 4;
        }
        pBPB->fsinfo.freecount 	= BYTES2INT32(buf, FSINFO_FREECOUNT);
        pBPB->fsinfo.nextfree 	= BYTES2INT32(buf, FSINFO_NEXTFREE);
    }

    // calculate freecount if unset 
    if ( pBPB->fsinfo.freecount == 0xffffffff )
    {
        FATUpdateFreeCluster(volume);
    }

    pBPB->mounted = true;


    return 0;
    
}
//------------------------------------------------------------------------------
// fat_unmount
//------------------------------------------------------------------------------
int 
FATUnmount(
int		volume, 
bool	flush
)
{
    int 	rc;
    FATBPB	*pBPB = &sFATBPB[volume];

    if(flush)
    {
        rc = PRIVATE_FATCacheFlushAll(pBPB); // the clean way, while still alive 
    }
    else
    {   
    	// volume is not accessible any more, e.g. MMC removed 
        int i;
        
        for(i = 0;i < FAT_CACHE_SIZE;i++)
        {
            FATCacheEntry *fce = &sFATEntryCache[i];
            if(fce->inuse && fce->fat_vol == pBPB)
            {
                fce->inuse = false; // discard all from that volume 
                fce->dirty = false;
            }
        }
        
        rc = 0;
    }
    pBPB->mounted = false;
    return rc;
}
//------------------------------------------------------------------------------
// FATUpdateFreeCluster
//------------------------------------------------------------------------------
void 
FATUpdateFreeCluster(
int volume
)
{

    FATBPB			*fat_bpb = &sFATBPB[volume];
    long 			free 	= 0;
    unsigned long 	i;
    
    if (fat_bpb->is_fat16)
    {
        for (i = 0; i<fat_bpb->fatsize; i++) {
            unsigned int j;
            unsigned short* fat = PRIVATE_FATCacheControl(fat_bpb, i, false);
            for (j = 0; j < CLUSTERS_PER_FAT16_SECTOR; j++) {
                unsigned int c = i * CLUSTERS_PER_FAT16_SECTOR + j;
                if ( c > fat_bpb->dataclusters+1 ) // nr 0 is unused 
                    break;
      
                if (letoh16(fat[j]) == 0x0000) {
                    free++;
                    if ( fat_bpb->fsinfo.nextfree == 0xffffffff )
                        fat_bpb->fsinfo.nextfree = c;
                }
            }
        }
    }
    else
    {
        for (i = 0; i<fat_bpb->fatsize; i++) {
            unsigned int j;
            unsigned long* fat = PRIVATE_FATCacheControl(fat_bpb, i, false);
            for (j = 0; j < CLUSTERS_PER_FAT_SECTOR; j++) {
                unsigned long c = i * CLUSTERS_PER_FAT_SECTOR + j;
                if ( c > fat_bpb->dataclusters+1 ) // nr 0 is unused 
                    break;
      
                if (!(letoh32(fat[j]) & 0x0fffffff)) {
                    free++;
                    if ( fat_bpb->fsinfo.nextfree == 0xffffffff )
                        fat_bpb->fsinfo.nextfree = c;
                }
            }
        }
    }
    fat_bpb->fsinfo.freecount = free;
    PRIVATE_FSInfoUpdate(fat_bpb);
}
//------------------------------------------------------------------------------
// fat_open
//------------------------------------------------------------------------------
int FATOpen(
int 	volume,				// [i] volume
long 	startcluster,		// [i] start cluster
FATFile	*file,				// [b] file index
FATDir 	*dir				// [b] directory index
)
{
	
	MAX_STACK_CHECK();
	
    file->firstcluster 	= startcluster;
    file->lastcluster 	= startcluster;
    file->lastsector 	= 0;
    file->clusternum	= 0;
    file->sectornum 	= 0;
    file->eof 			= false;
    file->volume 		= volume;
    
    // fixme: remove error check when done 
    if (volume >= NUM_VOLUMES || !sFATBPB[volume].mounted)
    {
        /* illegal volume */
        return -1;
    }


    // remember where the file's dir entry is located 
    if (dir) {
    	
        file->direntry 		= dir->entry - 1;
        file->direntries 	= dir->entrycount;
        file->dircluster 	= dir->file.firstcluster;
    }
   
   
    return 0;

}
//------------------------------------------------------------------------------
// fat_create_file
//------------------------------------------------------------------------------
int FATCreateFile(
const char	*name,
FATFile		*file,
FATDir		*dir
)
{

    int rc;
    MAX_STACK_CHECK();

    rc = PRIVATE_FATDirEntryAdd(dir, file, name, false, false);
    if (!rc) 
    {
        file->firstcluster	= 0;
        file->lastcluster	= 0;
        file->lastsector	= 0;
        file->clusternum 	= 0;
        file->sectornum 	= 0;
        file->eof 			= false;
    }

    return rc;  
}
//------------------------------------------------------------------------------
// FATCreateDir
//------------------------------------------------------------------------------
int 
FATCreateDir(
const char	*name,			// [i] new directory name
FATDir		*newdir,		// [o] new directory index
FATDir		*dir			// [i] parent directory index
)
{
    FATBPB			*fat_bpb = &sFATBPB[dir->file.volume];
    unsigned char 	buf[SECTOR_SIZE];
    int 			i;
    long 			sector;
    int 			rc;
    FATFile			dummyfile;
    
    MAX_STACK_CHECK();

    memset(newdir, 		0, sizeof(FATDir));
    memset(&dummyfile, 	0, sizeof(FATFile));

    // Add the File Entry in the parent directory
    rc = PRIVATE_FATDirEntryAdd(
    		dir, 				// parent directorty
    		&newdir->file, 		// file for new directory
    		name, 				// directory name
    		true, 				// is directory
    		false				// is not dot directory
		);
		
    if (rc < 0) return (rc * 10 - 1);

    // Allocate a new cluster for the directory 
    newdir->file.firstcluster 
    	= PRIVATE_ClusterGetFree(
    		fat_bpb, 
    		fat_bpb->fsinfo.nextfree
    	);
    	
    if(newdir->file.firstcluster == 0)
    { 	
    	return -1;
    }

	// Update File Entry
    PRIVATE_FATEntryUpdate(
    	fat_bpb, 
    	newdir->file.firstcluster, 
    	FAT_EOF_MARK
    );

    // Clear the entire cluster 
    memset(buf, 0, sizeof buf);
    sector 
    	= PRIVATE_Cluster2Sector(
    		fat_bpb, 
    		newdir->file.firstcluster
    	);
    	
	
	    	
    for(i = 0; i<(int)fat_bpb->bpb_secperclus;i++) {
    	
        rc = PRVITE_FATTransfer(
        	fat_bpb, 
        	sector + i, 
        	1, 
        	buf, 
        	true 
        );
        
        if (rc < 0)
        {
            return rc * 10 - 2;
        }
    }
    
    // Then add the "." entry 
    rc = PRIVATE_FATDirEntryAdd(newdir, &dummyfile, ".", true, true);
    if (rc < 0)
    {
        return rc * 10 - 3;
    }
    dummyfile.firstcluster = newdir->file.firstcluster;
    PRIVATE_ShortEntryUpdate(&dummyfile, 0, FAT_ATTR_DIRECTORY);

    // and the ".." entry 
    rc = PRIVATE_FATDirEntryAdd(newdir, &dummyfile, "..", true, true);
    if (rc < 0)
    {
        return rc * 10 - 4;
    }

    // The root cluster is cluster 0 in the ".." entry 
    if(dir->file.firstcluster == fat_bpb->bpb_rootclus)
    {
        dummyfile.firstcluster = 0;
    }
    else
    {
        dummyfile.firstcluster = dir->file.firstcluster;
    }
    PRIVATE_ShortEntryUpdate(&dummyfile, 0, FAT_ATTR_DIRECTORY);
    
    // Set the firstcluster field in the direntry 
    PRIVATE_ShortEntryUpdate(&newdir->file, 0, FAT_ATTR_DIRECTORY);
    
    rc = PRIVATE_FATCacheFlushAll(fat_bpb);
    if (rc < 0)
    {
        return rc * 10 - 5;
    }

    return rc;  
}
//------------------------------------------------------------------------------
// FATTruncate
//------------------------------------------------------------------------------
int 
FATTruncate(
FATFile *file
)
{
    // truncate trailing clusters 
    long 	next;
    long 	last 		= file->lastcluster;
    FATBPB	*fat_bpb 	= &sFATBPB[file->volume];
    
    MAX_STACK_CHECK();

    ////DEBUGF("fat_truncate(%lx, %lx)\n", file->firstcluster, last);

    for ( last = PRVIATE_ClusterGetNext(fat_bpb, last); last; last = next ) 
    {
        next = PRVIATE_ClusterGetNext(fat_bpb, last);
        PRIVATE_FATEntryUpdate(fat_bpb, last,0);
    }
    
    if (file->lastcluster)
    {
        PRIVATE_FATEntryUpdate(fat_bpb, file->lastcluster,FAT_EOF_MARK);
    }

    return 0;  
}
//------------------------------------------------------------------------------
// FATClose
//------------------------------------------------------------------------------
int 
FATClose(
FATFile *file, 
long	size, 
int		attr
)
{
    int rc;
    FATBPB	*fat_bpb = &sFATBPB[file->volume];
    
    MAX_STACK_CHECK();

    if (!size) {
        /* empty file */
        if ( file->firstcluster ) {
            PRIVATE_FATEntryUpdate(fat_bpb, file->firstcluster, 0);
            file->firstcluster = 0;
        }
    }

    if (file->dircluster) {
        rc = PRIVATE_ShortEntryUpdate(file, size, attr);
        if (rc < 0)
            return rc * 10 - 1;
    }

    PRIVATE_FATCacheFlushAll(fat_bpb);

    return 0;    
}

//------------------------------------------------------------------------------
// FATRemove
//------------------------------------------------------------------------------
int 
FATRemove(
FATFile* file
)
{
	
    long 	next, last = file->firstcluster;
    int 	rc;
    FATBPB	*fat_bpb = &sFATBPB[file->volume];
    
    MAX_STACK_CHECK();


    while ( last ) {
        next = PRVIATE_ClusterGetNext(fat_bpb, last);
        PRIVATE_FATEntryUpdate(fat_bpb, last,0);
        last = next;
    }

    if ( file->dircluster ) {
        rc = PRIVATE_DirEntryFree(file);
        if (rc < 0)
            return rc * 10 - 1;
    }

    file->firstcluster = 0;
    file->dircluster = 0;

    rc = PRIVATE_FATCacheFlushAll(fat_bpb);
    if (rc < 0)
        return rc * 10 - 2;

    return 0;   
}
//------------------------------------------------------------------------------
// fat_rename
//------------------------------------------------------------------------------
int 
FATRename(
FATFile				*file, 
FATDir				*dir, 
const unsigned char	*newname,
long 				size,
int 				attr
)
{	
    int rc;
    FATDir		olddir;
    FATFile		newfile 	= *file;
    FATBPB		*fat_bpb 	= &sFATBPB[file->volume];
    MAX_STACK_CHECK();
    
    if (file->volume != dir->file.volume) {
        /* No rename across volumes! */
        return -1;
    }

    if ( !file->dircluster ) {
        /* File has no dir cluster! */
        return -2;
    }

    /* create a temporary file handle */
    rc = FATOpenDir(file->volume, &olddir, file->dircluster, NULL);
    if (rc < 0)
        return rc * 10 - 3;

    /* create new name */
    rc = PRIVATE_FATDirEntryAdd(dir, &newfile, newname, false, false);
    if (rc < 0)
        return rc * 10 - 4;

    /* write size and cluster link */
    rc = PRIVATE_ShortEntryUpdate(&newfile, size, attr);
    if (rc < 0)
        return rc * 10 - 5;

    /* remove old name */
    rc = PRIVATE_DirEntryFree(file);
    if (rc < 0)
        return rc * 10 - 6;

    rc = PRIVATE_FATCacheFlushAll(fat_bpb);
    if (rc < 0)
        return rc * 10 - 7;

    return 0;  
}

//------------------------------------------------------------------------------
// FATReadWrite
//------------------------------------------------------------------------------
long 					// [o]		sector counter
FATReadWrite( 
FATFile *file, 			// [i/o]	file index structure
long 	sectorcount,	// [i]		read sector count
void	*buf, 			// [i/o]	source/destination buffer
bool	write 			// [i] 		write enable flag
)
{
    FATBPB	*fat_bpb = &sFATBPB[file->volume];
    
    long 	cluster 	= file->lastcluster;
    long 	sector 		= file->lastsector;
    long 	clusternum 	= file->clusternum;
    long 	numsec 		= file->sectornum;
    bool 	eof 		= file->eof;
    long 	first		= 0;
    long	last		= 0;
    long 	i;
    int 	rc;

	MAX_STACK_CHECK();

	//
	// check writable and EOF
	//
    if (eof && !write)
    {
        return 0;
    }

	//
    // find sequential sectors and write them all at once 
    //
    for (i=0; (i < sectorcount) && (sector > -1); i++ ) 
    {
        numsec++;
        if ( numsec > (long)fat_bpb->bpb_secperclus || !cluster ) 
        {
            long oldcluster = cluster;
            if (write)
            {
                cluster = PRIVATE_ClusterNextWrite(file, cluster, &sector);
            }
            else 
            {
                cluster	= PRVIATE_ClusterGetNext(fat_bpb, cluster);
                sector	= PRIVATE_Cluster2Sector(fat_bpb, cluster);
            }

            clusternum++;
            numsec =1;

            if (!cluster) {
                eof = true;
                if ( write ) {
                    /* remember last cluster, in case 
                       we want to append to the file */
                    cluster = oldcluster;
                    clusternum--;
                    i = -1; /* Error code */
                    break;
                }
            }
            else
                eof = false;
        }
        else 
        {
            if (sector)
            {
                sector++;
            }
            else 
            {
                /* look up first sector of file */
                sector 	= 	PRIVATE_Cluster2Sector(fat_bpb, file->firstcluster);
                numsec	=	1;
                
                if (file->firstcluster < 0)
                {   /* FAT16 root dir */
                    sector += fat_bpb->rootdiroffset;
                    numsec += fat_bpb->rootdiroffset;
                }
            }
        }

        if (!first)
            first = sector;

        if ( ((sector != first) && (sector != last+1)) || /* not sequential */
             (last-first+1 == 256) ) { /* max 256 sectors per ata request */
            long count = last - first + 1;
            rc = PRVITE_FATTransfer(fat_bpb, first, count, buf, write );
            if (rc < 0)
                return rc * 10 - 1;

            buf = (char *)buf + count * SECTOR_SIZE;
            first = sector;
        }

        if ((i == sectorcount-1) && /* last sector requested */
            (!eof))
        {
            long count = sector - first + 1;
            rc = PRVITE_FATTransfer(fat_bpb, first, count, buf, write );
            if (rc < 0)
                return rc * 10 - 2;
        }

        last = sector;
    }

    file->lastcluster	= cluster;
    file->lastsector 	= sector;
    file->clusternum 	= clusternum;
    file->sectornum 	= numsec;
    file->eof 			= eof;

    /* if eof, don't report last block as read/written */
    if (eof) i--;

    //DEBUGF("Sectors written: %ld\n", i);
    return i;
}
//------------------------------------------------------------------------------
// fat_seek
//------------------------------------------------------------------------------
int 
FATSeek(
FATFile			*file, 
unsigned long 	seeksector 
)
{
    FATBPB	*fat_bpb = &sFATBPB[file->volume];
    long clusternum=0, numclusters=0, sectornum=0, sector=0;
    long cluster = file->firstcluster;
    long i;
	MAX_STACK_CHECK();

    if (cluster < 0) /* FAT16 root dir */
        seeksector += fat_bpb->rootdiroffset;

    file->eof = false;
    if (seeksector) 
    {
    	
        /* we need to find the sector BEFORE the requested, since
           the file struct stores the last accessed sector */
        seeksector--;
        numclusters	= clusternum = seeksector / fat_bpb->bpb_secperclus;
        sectornum 	= seeksector % fat_bpb->bpb_secperclus;

        if (file->clusternum && clusternum >= file->clusternum)
        {
            cluster 	= file->lastcluster;
            numclusters -= file->clusternum;
        }

        for (i=0; i<numclusters; i++) {
        	
            cluster = PRVIATE_ClusterGetNext(fat_bpb, cluster);
            if (!cluster) {
                /* Seeking beyond the end of the file! */
                return -1;
            }
        }
        
        sector = PRIVATE_Cluster2Sector(fat_bpb, cluster) + sectornum;
    }
    else 
    {
        sectornum = -1;
    }


    file->lastcluster	= cluster;
    file->lastsector 	= sector;
    file->clusternum 	= clusternum;
    file->sectornum 	= sectornum + 1;
    return 0;  
}
//------------------------------------------------------------------------------
// fat_opendir
//------------------------------------------------------------------------------
int FATOpenDir(
int 			volume,
FATDir 			*dir, 
unsigned long 	startcluster,
FATDir	*parent_dir
)
{

    int rc;
  	FATBPB* fat_bpb = &sFATBPB[volume];
  	
  	MAX_STACK_CHECK();
  	
  	//
  	//	check volume name
    //	fixme: remove error check when done 
    //
    if (volume >= NUM_VOLUMES || !sFATBPB[volume].mounted)
    {
        return -1;
    }


    dir->entry	= 0;

    if (startcluster == 0)
    {
        startcluster = fat_bpb->bpb_rootclus;
    }

    rc = FATOpen(volume, startcluster, &dir->file, parent_dir);
    if(rc)
    {
        /* Couldn't open dir */
        return rc * 10 - 1;
    }
    
    return rc;

}

//------------------------------------------------------------------------------
// FATGetNextDirEntry
//------------------------------------------------------------------------------
int 
FATGetNextDirEntry(	
FATDir 			*entryIdx, 	// [i/o]	directory entry index & cache
FATDirEntry		*entry		// [o] 		directory entry information
)
{

    bool 			done = false;
    int 			i;
    int 			rc;
    unsigned char 	firstbyte;
    int 			longarray[20];
    int 			longs			= 0;
    int			 	sectoridx		= 0;
    unsigned char	*cached_buf 	= entryIdx->sectorcache[0];
    MAX_STACK_CHECK();

    entryIdx->entrycount = 0;

    while(!done)
    {
    	//
    	//	get entry information in sector
    	//
        if (!(entryIdx->entry % DIR_ENTRIES_PER_SECTOR))		// when first directory open
        {
            rc = FATReadWrite(&entryIdx->file, 1, cached_buf, false);
            if (rc == 0) {
                // eof 
                entry->name[0] = 0;
                break;
            }
            if (rc < 0) {
                // " Couldn't read dir 
                return rc * 10 - 1;
            }
        }

		//
    	//	search entry in on sector
    	//
        for (i = entryIdx->entry % DIR_ENTRIES_PER_SECTOR;
             i < DIR_ENTRIES_PER_SECTOR; i++)
        {
            unsigned int entrypos = i*DIR_ENTRY_SIZE;

            firstbyte = cached_buf[entrypos];
            entryIdx->entry++;

            if (firstbyte == 0xE5) {
            	
                // free entry 
                sectoridx 		= 0;
                entryIdx->entrycount = 0;
                continue;
            }

            if (firstbyte == 0x00) {
            	
                // last entry 
                entry->name[0] 	= 0;
                entryIdx->entrycount = 0;
                return 0;
            }

            entryIdx->entrycount++;

            if ( ( cached_buf[entrypos + FATDIR_ATTR] &
                   FAT_ATTR_LONG_NAME_MASK ) == FAT_ATTR_LONG_NAME ) 
			{
				//
				// longname entry? 
				//
                longarray[longs++] = (entrypos + sectoridx);
            }
            else 
            {
            	
            	//
            	// short name entry
            	//
            	
                if (PRIVATE_DirEntryParse(entry,&cached_buf[entrypos]) ) 
                {

                    // don't return volume id entry 
                    if ( (entry->attr &
                          (FAT_ATTR_VOLUME_ID|FAT_ATTR_DIRECTORY))
                         == FAT_ATTR_VOLUME_ID)
                        continue;

                    // replace shortname with longname?
                    if (longs) 
                    {
                        int 			j;
                        unsigned char 	shortname[13]; 					// short name + null
                        unsigned char 	longname_utf8segm[6*4 + 1]; 	// max lone name seg + null
                        int 			longname_utf8len 		= 0;
                        int				longname_utf8segmlen 	= 0;
                        
                        // Temporarily store it 
                        strcpy(shortname, entry->name); 				
                        entry->name[0] = 0;
                        
                       
                        // iterate backwards through the dir entries 
                        for (j= longs-1; j >= 0; j--) {
                        	
                            unsigned char	*ptr = 0;
                            int 			index 	=	longarray[j];
                            
                            //
                            //	select tripple buffer
                            //
                            if ( sectoridx >= SECTOR_SIZE ) 
                            {
                                if (sectoridx >= SECTOR_SIZE*2) 
                                {
                                	// select second buffer
                                    if (( index >= SECTOR_SIZE) 
                                      &&( index < SECTOR_SIZE*2))
                                        ptr = entryIdx->sectorcache[1];
									// select third buffer                                        
                                    else
                                        ptr = entryIdx->sectorcache[2];
                                }
                                else 
                                {
                                	// select second buffer
                                    if(index < SECTOR_SIZE)
                                        ptr = entryIdx->sectorcache[1];
									else
										ptr = entryIdx->sectorcache[0];
                                }

                                index &= SECTOR_SIZE-1;
                            } 
                            // select first buffer
                            else 
							{
								ptr = entryIdx->sectorcache[0];
                            }
                            
                            
                            //
                            // get first get 10(5*2)byte ucs-2
                            //
							longname_utf8segmlen
								 = PRIVATE_FATLongNameCopySegment(
										(ptr + index + 1),	// start pointer
										5, 					// ucs-2 	length
										longname_utf8segm	// ascii 	length
									);
									
                            if((longname_utf8segmlen == 0)
                            || (longname_utf8segmlen >= FAT_FILENAME_BYTES)) 	
                            	break;
                            	
                            longname_utf8len += longname_utf8segmlen;
                            strcat(entry->name, longname_utf8segm);
                            
                            //
                            // get first get 12(6*2)byte ucs-2
                            //
							longname_utf8segmlen
								 = PRIVATE_FATLongNameCopySegment(
										(ptr + index + 14),	// start pointer
										6, 					// ucs-2 	length
										longname_utf8segm	// ascii 	length
									);
									
                            if((longname_utf8segmlen == 0)
                            || (longname_utf8segmlen >= FAT_FILENAME_BYTES)) 	
                            	break;
                            	
                            longname_utf8len += longname_utf8segmlen;
                            strcat(entry->name, longname_utf8segm);
                            
                            //
                            // get first get 4(2*2)byte ucs-2
                            //
							longname_utf8segmlen
								 = PRIVATE_FATLongNameCopySegment(
										(ptr + index + 28),	// start pointer
										2, 					// ucs-2 	length
										longname_utf8segm	// ascii 	length
									);
									
                            if((longname_utf8segmlen == 0)
                            || (longname_utf8segmlen >= FAT_FILENAME_BYTES))	
                            	break;
                            	
                            longname_utf8len += longname_utf8segmlen;
                            strcat(entry->name, longname_utf8segm);
       

                            

                        }

						#if 0
                        /* Does the utf8-encoded name fit into the entry? */
                        if (longname_utf8len >= FAT_FILENAME_BYTES) {
                            /* Take the short DOS name. Need to utf8-encode it since
                               it may contain chars from the upper half of the OEM
                               code page which wouldn't be a valid utf8. Beware: this
                               file will be shown with strange glyphs in file browser
                               since unicode 0x80 to 0x9F are control characters. */
                            //logf("SN-DOS: %s", shortname);
                            unsigned char *utf8;
                            utf8 = iso_decode(shortname, entry->name, -1, strlen(shortname));
                        	*utf8 = 0;
                          //  printf("SN: %s", entry->name);
                        } else {
                           // printf("LN: %s", entry->name);
                           // printf("LNLen: %d (%c)", longname_utf8len, entry->name[0]);
                        }
                        #endif
                    }
                    
                    done 		= true;
                    sectoridx 	= 0;
                    i++;
                    break;
                }
            }
        }
        
		//
        // save this sector, for longname use 
        //
        if (sectoridx)
        {
            memcpy( 
            	entryIdx->sectorcache[2], 
            	entryIdx->sectorcache[0], 
            	SECTOR_SIZE 
            );
        }
        else
       	{
            memcpy( 
            	entryIdx->sectorcache[1], 
            	entryIdx->sectorcache[0], 
            	SECTOR_SIZE 
            );
		}            
            
        sectoridx += SECTOR_SIZE;

    }
    return 0;
   
}
//------------------------------------------------------------------------------
// fat_get_cluster_size
//------------------------------------------------------------------------------
unsigned int 
FATGetClusterSize(
int volume
)
{
	
    FATBPB* fat_bpb = &sFATBPB[volume];
    MAX_STACK_CHECK();
    
    return fat_bpb->bpb_secperclus * SECTOR_SIZE;
}


//------------------------------------------------------------------------------
// fat_ismounted
//------------------------------------------------------------------------------
bool FATIsMounted(int volume)
{
    return (volume<NUM_VOLUMES && sFATBPB[volume].mounted);
}

