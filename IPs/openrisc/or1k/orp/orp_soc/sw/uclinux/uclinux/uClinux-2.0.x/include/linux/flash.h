/* $Id: flash.h,v 1.1.1.1 2001/09/10 07:44:43 simons Exp $ */

#ifndef __LINUX_FLASH_H
#define __LINUX_FLASH_H

#include <asm/types.h>

/* the ioctl's supported */

#define FLASHIO_ERASEALL 0x1      /* erase the entire device, blocks until completion */

#ifdef __KERNEL__
extern void flash_safe_acquire(void *part);
extern void flash_safe_release(void *part);
extern int flash_safe_read(void *part, unsigned char *fptr,
			   unsigned char *buf, int count);
extern int flash_safe_write(void *part, unsigned char *fptr,
			    const unsigned char *buf, int count);
extern void *flash_getpart(kdev_t dev);
extern unsigned char *flash_get_direct_pointer(kdev_t dev, __u32 offset);
extern int flash_erase_region(kdev_t dev, __u32 offset, __u32 size);
extern long flash_erasable_size(void *_part, __u32 offset, __u32 size);
extern int flash_memset(unsigned char *ptr, const __u8 c, unsigned long size);
#endif

/* the following are on-flash structures */

#define FLASH_BOOT_MAGIC 0xbeefcace

struct bootblock {
	__u32 magic;
	__u32 hwid;
	unsigned char sernbr[8]; /* uses only 0-5, but is 8 big for alignment */
	char brandname[32];
	__u32 ptable_offset;       /* offset into bootblock where the partitiontable is */
	/* ... */
};

/* the partitiontable consists of structs like these, after each other */

struct partitiontable {
	__u32 offset;
	__u32 size;
	__u32 flags;
};

#endif /* __LINUX_FLASH_H */
