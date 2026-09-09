
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#include "sw_fs_typedefs.h"
#include "sw_fs_system_string.h"
#include "sw_fs_dir.h"
#include "./sw_fs_driver/fat32/sw_fs_drv_fat.h"


#define MAX_OPEN_DIRS 2
static DIR opendirs[MAX_OPEN_DIRS];

/* how to name volumes, first char must be outside of legal file names,
   a number gets appended to enumerate, if applicable */

static const char* vol_names = "<HD%d>";
#define VOL_ENUM_POS 3

//------------------------------------------------------------------------------
//	strip_volume
//------------------------------------------------------------------------------
/* returns on which volume this is, and copies the reduced name
   (sortof a preprocessor for volume-decorated pathnames) */
static int strip_volume(const char* name, char* namecopy)
{
    int volume = 0;
    const char *temp = name;
    
    MAX_STACK_CHECK();
    
    while (*temp == '/')          /* skip all leading slashes */
        ++temp;
        
    if (*temp && !strncmp(temp, vol_names, VOL_ENUM_POS))
    {
        temp 	+= VOL_ENUM_POS;     /* behind special name */
        volume 	= atoi(temp);      	/* number is following */
        temp 	= strchr(temp, '/'); /* search for slash behind */
        if (temp != NULL)
            name = temp;          /* use the part behind the volume */
        else
            name = "/";           /* else this must be the root dir */
    }

    strncpy(namecopy, name, MAX_PATH);
    namecopy[MAX_PATH-1] = '\0';

    return volume;
}
//------------------------------------------------------------------------------
//	release_dirs
//------------------------------------------------------------------------------
// release all dir handles on a given volume "by force", to avoid leaks
int 
release_dirs(
int volume			// [i] selected volume
)
{
    DIR* pdir = opendirs;
    int dd;
    int closed = 0;
    MAX_STACK_CHECK();
    
    for ( dd=0; dd<MAX_OPEN_DIRS; dd++, pdir++)
    {
        if (pdir->fatdir.file.volume == volume)
        {
            pdir->busy = false; /* mark as available, no further action */
            closed++;
        }
    }
    return closed; /* return how many we did */
}
//------------------------------------------------------------------------------
//	opendir : support POSIX filesystem interface
//------------------------------------------------------------------------------
DIR* 
opendir(
const char* name	// [i] full directory name
)
{
    char 		namecopy[MAX_PATH];
    char		*part;
    FATDirEntry entry;
    int dd;
    DIR* pdir = opendirs;

    int volume;
    MAX_STACK_CHECK();


	// check filename, need absolute full path name
    if ( name[0] != '/' ) {
        FSDBGPrintf("Only absolute paths supported right now\n");
        return NULL;
    }

    // find a free dir descriptor 
    for ( dd=0; dd<MAX_OPEN_DIRS; dd++, pdir++)
    {
        if ( !pdir->busy )
            break;
	}
    if ( dd == MAX_OPEN_DIRS ) 
	{
        FSDBGPrintf("Too many dirs open\n");
//        errno = EMFILE;
        return NULL;
    }
    pdir->busy = true;

    // try to extract a heading volume name, if present 
    volume = strip_volume(name, namecopy);
    pdir->volumecounter = 0;

	// open root directory
    if ( FATOpenDir(volume, &pdir->fatdir, 0, NULL) < 0 ) 
    {
        FSDBGPrintf("Failed opening root dir\n");
        pdir->busy = false;
        return NULL;
    }

	// open destination directory
    for (part = strtok(namecopy, "/"); 	
    	 part;
         part = strtok(NULL, "/")) 
	{
        // scan dir for name 
        while (1) 
        {
        	
        	
        	// get directory entry by  pdir->fatdir index
            if ((FATGetNextDirEntry(&pdir->fatdir, &entry) < 0) 
              ||(!entry.name[0])) 
			{
                pdir->busy = false;
                return NULL;
            }
            
            // found matching named directory attribute
            if ( (entry.attr & FAT_ATTR_DIRECTORY)
               &&(!strcasecmp(part, entry.name)) ) 
			{
                pdir->parent_dir = pdir->fatdir;
                if ( FATOpenDir(
                		volume,
						&pdir->fatdir,
						entry.firstcluster,
						&pdir->parent_dir
					) < 0 ) 
				{
                    FSDBGPrintf("Failed opening dir '%s' (%ld)\n",
					         part, entry.firstcluster);
                    pdir->busy = false;
                    return NULL;
                }
                pdir->volumecounter = -1; /* n.a. to subdirs */

                break;
            }
        }
    }

    return pdir;
}
//------------------------------------------------------------------------------
//	closedir
//------------------------------------------------------------------------------
int 
closedir(
DIR* dir
)
{
	MAX_STACK_CHECK();
    dir->busy=false;
    return 0;
}
//------------------------------------------------------------------------------
//	readdir
//------------------------------------------------------------------------------
DirEnt* 
readdir(
DIR* dir
)
{
    FATDirEntry		entry;
    DirEnt* 		theent = &(dir->theent);
    
    MAX_STACK_CHECK();

    if (!dir->busy)
        return NULL;

    /* 
    	Volumes (secondary file systems) get inserted into the root directory
        of the first volume, since we have no separate top level. 
	*/
    if (dir->volumecounter >= 0 				// on a root dir 
     && dir->volumecounter < NUM_VOLUMES 		// in range 
     && dir->fatdir.file.volume == 0) 			// at volume 0 
    {   
    	/* 
    		fake special directories, which don't really exist, but
          	 will get redirected upon opendir() 
		*/
           
        while (++dir->volumecounter < NUM_VOLUMES)
        {
            if (FATIsMounted(dir->volumecounter))
            {
                memset(theent, 0, sizeof(*theent));
                theent->attribute = FAT_ATTR_DIRECTORY | FAT_ATTR_VOLUME;
                snprintf(theent->d_name, sizeof(theent->d_name), 
                         vol_names, dir->volumecounter);
                return theent;
            }
        }
    }
    
    
    // normal directory entry fetching follows here 
    if (FATGetNextDirEntry(&(dir->fatdir), &entry) < 0)
        return NULL;

    if ( !entry.name[0] )
        return NULL;	

    strncpy(theent->d_name, entry.name, sizeof( theent->d_name ) );
    theent->attribute 		= entry.attr;
    theent->size 			= entry.filesize;
    theent->startcluster 	= entry.firstcluster;
    theent->wrtdate 		= entry.wrtdate;
    theent->wrttime 		= entry.wrttime;
    


    return theent;
}
//------------------------------------------------------------------------------
//	mkdir
//------------------------------------------------------------------------------
int 
mkdir(
const char	*name, 
int			mode
)
{
    DIR 	*dir;
    char 	namecopy[MAX_PATH];
    char	*end;
    char 	*basename;
    char 	*parent;
    DirEnt 	*entry;
    FATDir 	newdir;
    int 	rc;
    
    MAX_STACK_CHECK();

    (void)mode;

    if ( name[0] != '/' ) {
        FSDBGPrintf("mkdir: Only absolute paths supported right now\n");
        return -1;
    }

    strncpy(namecopy,name,sizeof(namecopy));
    namecopy[sizeof(namecopy)-1] = 0;

	//
    // split and get parent directory name and current directory name
    //
    
    // Split the base name and the path 
    end 		= strrchr(namecopy, '/');
    *end 		= 0;
    basename 	= end+1;

	// Root dir? 
    if(namecopy == end) 
    {
        parent = "/";
    }
    else
    {
        parent = namecopy;
    }
        
    FSDBGPrintf("mkdir: parent: %s, name: %s\n", 
    		parent, basename);


	//
	// open parent directory
	//
	
    dir = opendir(parent);
    
    if(!dir) 
    {
        FSDBGPrintf("mkdir: can't open parent dir\n");
        return -2;
    }    

    if(basename[0] == 0) 
    {
        FSDBGPrintf("mkdir: Empty dir name\n");
//        errno = EINVAL;
        return -3;
    }
    
    /* Now check if the name already exists */
    while ((entry = readdir(dir))) 
    {
        if(!strcasecmp(basename, entry->d_name)) 
        {
            FSDBGPrintf("mkdir error: file exists\n");
//            errno = EEXIST;
            closedir(dir);
            return - 4;
        }
    }

    memset(&newdir, sizeof(FATDir), 0);
    rc = FATCreateDir(
    		basename, 			// current directory name
    		&newdir, 			// 
    		&(dir->fatdir)		// parent directory index
    	);

    closedir(dir);
    
    return rc;
}
//------------------------------------------------------------------------------
//	rmdir
//------------------------------------------------------------------------------s
int rmdir(const char* name)
{
    int rc;
    DIR* dir;
    DirEnt* entry;
    
    MAX_STACK_CHECK();
    
    dir = opendir(name);
    if (!dir)
    {
//        errno = ENOENT; /* open error */
        return -1;
    }

    /* check if the directory is empty */
    while ((entry = readdir(dir)))
    {
        if (strcmp(entry->d_name, ".") &&
            strcmp(entry->d_name, ".."))
        {
            //DEBUGF("rmdir error: not empty\n");
//            errno = ENOTEMPTY;
            closedir(dir);
            return -2;
        }
    }

    rc = FATRemove(&(dir->fatdir.file));
    if ( rc < 0 ) {
        //DEBUGF("Failed removing dir: %d\n", rc);
///        errno = EIO;
        rc = rc * 10 - 3;
    }

    closedir(dir);
    
    return rc;
}
