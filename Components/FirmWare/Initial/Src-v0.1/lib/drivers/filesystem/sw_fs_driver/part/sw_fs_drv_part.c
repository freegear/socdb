/***************************************************************************
 *             __________               __   ___.
 *   Open      \______   \ ____   ____ |  | _\_ |__   _______  ___
 *   Source     |       _//  _ \_/ ___\|  |/ /| __ \ /  _ \  \/  /
 *   Jukebox    |    |   (  <_> )  \___|    < | \_\ (  <_> > <  <
 *   Firmware   |____|_  /\____/ \___  >__|_ \|___  /\____/__/\_ \
 *                     \/            \/     \/    \/            \/
 * $Id: disk.c,v 1.10 2006-08-31 19:19:35 dave Exp $
 *
 * Copyright (C) 2002 by Björn Stenberg
 *
 * All files in this archive are subject to the GNU General Public License.
 * See the file COPYING in the source tree root for full license agreement.
 *
 * This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
 * KIND, either express or implied.
 *
 ****************************************************************************/
#include <stdio.h>
#include "../../sw_fs_typedefs.h"
#include "../../../../drivers/storage/sdmmc/sdmmc_post_drv.h"
#include "sw_fs_drv_part.h"

/* Partition table entry layout:
   -----------------------
   0: 0x80 - active
   1: starting head
   2: starting sector
   3: starting cylinder
   4: partition type
   5: end head
   6: end sector
   7: end cylinder
   8-11: starting sector (LBA)
   12-15: nr of sectors in partition
*/
//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
#define BYTES2INT32(array,pos)													\
    ((long)array[pos] | ((long)array[pos+1] << 8 ) |							\
     ((long)array[pos+2] << 16 ) | ((long)array[pos+3] << 24 ))

static PartInfo pinfo[4]; /* space for 4 partitions on 2 drives */
//------------------------------------------------------------------------------
//	PartInit
//------------------------------------------------------------------------------
bool
PartInit(
void
)
{
	return true;
}
//------------------------------------------------------------------------------
//	PartReadMBR
//------------------------------------------------------------------------------
void 
PartReadMBR(
ATAFunction* pFunction
)
{
	int	i;
	unsigned char sector[512];
	
	pFunction->ATAReadSectors(0, 0,1,&sector);

    // check that the boot sector is initialized 
    if ( (sector[510] != 0x55) ||
         (sector[511] != 0xAA)) {
       
		FSDBGPrintf("Bad boot sector signature\n");
        return;
    }

    // parse partitions 
    for ( i=0; i<4; i++ ) {
    	
        unsigned char* ptr = sector + 0x1be + 16*i;
        pinfo[i].type  = ptr[4];
        pinfo[i].start = BYTES2INT32(ptr, 8);
        pinfo[i].size  = BYTES2INT32(ptr, 12);
		
		FSDBGPrintf(
			"Part%d: "
			"Type : 0x%02x, "
			"start: 0x%08lx "
			"size : 0x%08lx\n",
             i,
			 pinfo[i].type,pinfo[i].start,
			 pinfo[i].size);
		

        // extended? 
        if ( pinfo[i].type == 5 ) {
            // not handled yet 
        }
    }

	
}
//------------------------------------------------------------------------------
//	PartGetPartition
//------------------------------------------------------------------------------
PartInfo* 
PartGetPartition(
int partIdx
)
{
    return &pinfo[partIdx];
}
