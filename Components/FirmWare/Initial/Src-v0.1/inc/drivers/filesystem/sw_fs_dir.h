/***************************************************************************
 *             __________               __   ___.
 *   Open      \______   \ ____   ____ |  | _\_ |__   _______  ___
 *   Source     |       _//  _ \_/ ___\|  |/ /| __ \ /  _ \  \/  /
 *   Jukebox    |    |   (  <_> )  \___|    < | \_\ (  <_> > <  <
 *   Firmware   |____|_  /\____/ \___  >__|_ \|___  /\____/__/\_ \
 *                     \/            \/     \/    \/            \/
 * $Id: dir.h,v 1.13 2006-11-10 08:03:31 miipekk Exp $
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
#ifndef _DIR_H_
#define _DIR_H_

#include "sw_fs_file.h"
#include "./sw_fs_driver/fat32/sw_fs_drv_fat.h"

#define ATTR_READ_ONLY   0x01
#define ATTR_HIDDEN      0x02
#define ATTR_SYSTEM      0x04
#define ATTR_VOLUME_ID   0x08
#define ATTR_DIRECTORY   0x10
#define ATTR_ARCHIVE     0x20
#define ATTR_VOLUME      0x40 /* this is a volume, not a real directory */



typedef struct {

    unsigned char	d_name[MAX_PATH];
    int				attribute;
    long			size;
    long			startcluster;
    unsigned short	wrtdate; /*  Last write date */ 
    unsigned short	wrttime; /*  Last write time */
    
} DirEnt;




typedef struct {
	
    bool 	busy;
    long 	startcluster;
    FATDir 	fatdir;
    FATDir 	parent_dir;
    DirEnt 	theent;
    int 	volumecounter; /* running counter for faked volume entries */

} DIR;


extern DIR* 	opendir(const char* name);
extern int 		closedir(DIR* dir);
extern int 		mkdir(const char* name, int mode);
extern int 		rmdir(const char* name);

extern DirEnt*	readdir(DIR* dir);
extern int 		release_dirs(int volume);



#endif
