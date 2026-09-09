/* $Id: flash.c,v 1.1.1.1 2001/09/10 07:44:10 simons Exp $
 *
 * Flash-memory char or block device
 *
 * Copyright (c) 1998, 1999 Bjorn Wesen, Axis Communications AB
 *
 * This driver implements a read/write/erase interface to the flash chips.
 * It probes for chips, and tries to read a bootblock with partition info from
 * the bootblock on the first chip. This bootblock is given the device name
 * /dev/flash0, and the rest of the partitions are given flash1 and upwards.
 * If no bootblock is found, the entire first chip (including bootblock) is
 * set as /dev/flash1.
 *
 * TODO:
 *   implement Unlock Bypass programming, to double the write speed
 *   fix various loops for partitions than span more than one chip
 */

/* define to make kernel bigger, but with verbose Flash messages */

//#define LISAHACK

/* if IRQ_LOCKS is enabled, interrupts are disabled while doing things
 * with the flash that cant have other accesses to the flash at the same
 * time. this is normally not needed since we have a wait_queue lock on the
 * flash chip as a mutex.
 */

//#define IRQ_LOCKS

#define FLASH_VERBOSE
#define MEM_NON_CACHEABLE 0
#define FLASH_16BIT

/* ROM and flash devices have major 31 (Documentation/devices.txt)
 * However, KROM is using that major now, so we use an experimental major = 60.
 * When this driver works, it will support read-only memory as well and we can
 * remove KROM.
 * Our minors start at: 16 = /dev/flash0       First flash memory card (rw)
 */

/*#define MAJOR_NR 31 */
#define MAJOR_NR 60

#define ROM_MINOR   8   /* ro ROM card */
#define FLASH_MINOR 16  /* rw Flash card */

/* dont touch the MAX_CHIPS until the hardcoded chip0 and chip1 are removed from the code */

#define MAX_CHIPS /* 2 */ 1
#define MAX_PARTITIONS 8

#define DEF_FLASH2_SIZE 0x50000   /* 5 sectors for JFFS partition per default */

#include <linux/config.h>
#include <linux/major.h>
#include <linux/malloc.h>

/* all this stuff needs to go in blk.h */
#define DEVICE_NAME "Flash/ROM device"

#ifdef CONFIG_BLK_DEV_FLASH

#define FLASH_SECTSIZE 512 /* arbitrary, but Linux assumes 512 often it seems */

#define DEVICE_REQUEST do_flash_request
#define DEVICE_NR(device) (MINOR(device))
#define DEVICE_ON(device)
#define DEVICE_OFF(device)

#include <linux/blk.h>

/* the device and block sizes for each minor */

static int flash_sizes[32];
static int flash_blk_sizes[32];

#endif

#include <asm/system.h>
#include <linux/flash.h>

//#define DEBUG

#ifdef DEBUG
#define FDEBUG(x) x
#else
#define FDEBUG(x)
#endif

#if defined(__CRIS__) && !defined(DEBUG)
/* breaks badly if we use printk before we flash an image... */
extern void console_print_etrax(const char *b, ...);
#define safe_printk console_print_etrax
#else
#define safe_printk printk
#endif

int flash_write(unsigned char *ptr, const unsigned char *source, unsigned int size);
void flash_init_erase(unsigned char *ptr, unsigned int size);
static struct flashchip *getchip(unsigned char *ptr);

#ifdef FLASH_16BIT
/* 16-bit wide Flash-ROM */
enum {  unlockAddress1          = 0x555,
        unlockData1             = 0xAA,
        unlockAddress2          = 0x2AA,
        unlockData2             = 0x55,
        manufacturerUnlockData  = 0x90,
        manufacturerAddress     = 0x00,
        deviceIdAddress         = 0x01,
        programUnlockData       = 0xA0,
        resetData               = 0xF0,
        sectorEraseUnlockData   = 0x80,
        sectorEraseUnlockData2  = 0x30 };

typedef volatile unsigned short *flashptr;

#else
/* 32-bit wide Flash-ROM
 * Since we have two devices in parallell, we need to duplicate
 * the special _data_ below so it reaches both chips.
 */
enum {  unlockAddress1          = 0x555,
        unlockData1             = 0x00AA00AA,
        unlockAddress2          = 0x2AA,
        unlockData2             = 0x00550055,
        manufacturerUnlockData  = 0x00900090,
        manufacturerAddress     = 0x00,
        deviceIdAddress         = 0x01,
        programUnlockData       = 0x00A000A0,
        resetData               = 0x00F000F0,
        sectorEraseUnlockData   = 0x00800080,
        sectorEraseUnlockData2  = 0x00300030 };

typedef volatile unsigned long *flashptr;

#endif

enum {  ManufacturerAMD   = 0x01,
	AM29F800BB        = 0x2258,
	AM29F800BT        = 0x22D6,
	AM29LV800BB       = 0x225B,
	AM29LV800BT       = 0x22DA,
	AM29LV160BT       = 0x22C4
};

enum {  ManufacturerToshiba = 0x0098,
	TC58FVT160          = 0x00c2,
	TC58FVB160          = 0x0043
};

enum {
	/* ST - www.st.com*/
	ManufacturerST    = 0x20, /* 0x20 */
	M29W800T          = 0x00D7 /* Used in 5600, similar to AM29LV800, 
				    * but no unlock bypass */
};

enum {  D6_MASK           = 0x40};

enum {  maxNumberOfBootSectors = 8 };

/* internal structure for keeping track of flash devices */

struct flashchip {
	unsigned char *start;
	unsigned char *bootsector;
	unsigned int bootsectorsize[maxNumberOfBootSectors];
	unsigned short device_id;
	unsigned short isValid;
	int size, sectorsize;
	/* to block accesses during erase and writing etc */
	int busy;
	struct wait_queue *wqueue;
};

/* and partitions */

struct flashpartition {
	struct flashchip *chip;   /* the chip we reside in */
	unsigned char *start;     /* starting flash mem address */
	int size;                 /* size of partition in bytes */
	unsigned int flags;       /* protection bits etc */
};


static struct flashchip chips[MAX_CHIPS];
static struct flashpartition partitions[MAX_PARTITIONS];

/* check if flash is busy */

static inline int flash_is_busy(flashptr flashStart)
{
	/* this should probably be protected! */
	return((*flashStart & D6_MASK) !=
	       (*flashStart & D6_MASK));
}

/* Open the device. We don't need to do anything really.  */

static int
flash_open(struct inode *inode, struct file *filp)
{
#ifdef CONFIG_CHR_DEV_FLASH

	int minor = MINOR(inode->i_rdev);
	struct flashpartition *part;

	if(minor < FLASH_MINOR)
		return -ENODEV;

	part = &partitions[minor - FLASH_MINOR];

	if(!part->start)
		return -ENODEV;

	filp->private_data = (void *)part;  /* remember for the future */

#endif

	return 0; /* everything went ok */
}

static void
flash_release(struct inode *inode, struct file *filp)
{
#ifdef CONFIG_BLK_DEV_FLASH
	sync_dev(inode->i_rdev);
#endif
	return;
}

#ifdef CONFIG_BLK_DEV_FLASH

static void
do_flash_request()
{
	while(1) {
		int minor, fsize, opsize;
		struct flashchip *chip;
		struct flashpartition *part;
		unsigned char *fptr;
		unsigned long flags;

		INIT_REQUEST;

		minor = DEVICE_NR(CURRENT_DEV);

		minor -= FLASH_MINOR;

		/* for now, just handle requests to the flash minors */

		if(minor < 0 || minor >= MAX_PARTITIONS ||
		   !partitions[minor].start) {
			printk(KERN_WARNING "flash: bad minor %d.", minor);
			end_request(0);
			continue;
		}

		part = partitions + minor;

		/* get the actual memory address of the sectors requested */

		fptr = part->start + CURRENT->sector * FLASH_SECTSIZE;
		fsize = CURRENT->current_nr_sectors * FLASH_SECTSIZE;

		/* check so it's not totally out of bounds */

		if(fptr + fsize > part->start + part->size) {
			printk(KERN_WARNING "flash: request past end "
			       "of partition\n");
			end_request(0);
			continue;
		}

		/* actually do something, but get a lock on the chip first.
		 * since the partition might span several chips, we need to
		 * loop and lock each chip in turn
		 */

		while(fsize > 0) {

			chip = getchip(fptr);

			/* how much fits in this chip ? */

			opsize = (fptr + fsize) > (chip->start + chip->size) ?
				 (chip->start + chip->size - fptr) : fsize;

			/* lock the chip */

			save_flags(flags);
			cli();
			while(chip->busy)
				sleep_on(&chip->wqueue);
			chip->busy = 1;
			restore_flags(flags);

			switch(CURRENT->cmd) {
			case READ:
				memcpy(CURRENT->buffer, fptr, opsize);
				FDEBUG(printk("flash read from %p to %p "
					      "size %d\n", fptr,
					      CURRENT->buffer, opsize));
				break;
			case WRITE:
				FDEBUG(printk("flash write block at 0x%p\n",
					      fptr));
				flash_write(fptr,
					    (unsigned char *)
					    CURRENT->buffer,
					    opsize);
				break;
			default:
				/* Shouldn't happen.  */
				chip->busy = 0;
				wake_up(&chip->wqueue);
				end_request(0);
				continue;
			}

			/* release the lock */

			chip->busy = 0;
			wake_up(&chip->wqueue);

			/* see if there is anything left to write in the next chip */

			fsize -= opsize;
			fptr += opsize;
		}

		/* We have a liftoff! */

		end_request(1);
	}
}

#endif /* CONFIG_BLK_DEV_FLASH */

void
flash_safe_acquire(void *part)
{
	struct flashchip *chip = ((struct flashpartition *)part)->chip;
	while (chip->busy)
		sleep_on(&chip->wqueue);
	chip->busy = 1;
}

void
flash_safe_release(void *part)
{
	struct flashchip *chip = ((struct flashpartition *)part)->chip;
	chip->busy = 0;
	wake_up(&chip->wqueue);
}

/* flash_safe_read and flash_safe_write are used by the JFFS flash filesystem */

int
flash_safe_read(void *_part, unsigned char *fptr,
		unsigned char *buf, int count)
{
	struct flashpartition *part = (struct flashpartition *)_part;

	/* Check so it's not totally out of bounds.  */

	if(fptr + count > part->start + part->size) {
		printk(KERN_WARNING "flash: read request past "
		       "end of device (address: 0x%p, size: %d)\n",
		       fptr, count);
		return -EINVAL;
	}

	FDEBUG(printk("flash_safe_read: %d bytes from 0x%p to 0x%p\n",
		      count, fptr, buf));

	/* Actually do something, but get a lock on the chip first.  */

	flash_safe_acquire(part);

	memcpy(buf, fptr, count);

	/* Release the lock.  */

	flash_safe_release(part);

	return count; /* success */
}


int
flash_safe_write(void *_part, unsigned char *fptr,
		 const unsigned char *buf, int count)
{
	struct flashpartition *part = (struct flashpartition *)_part;
	int err;

	/* Check so it's not totally out of bounds.  */

	if(fptr + count > part->start + part->size) {
		printk(KERN_WARNING "flash: write operation past "
		       "end of device (address: 0x%p, size: %d)\n",
		       fptr, count);
		return -EINVAL;
	}

	FDEBUG(printk("flash_safe_write: %d bytes from 0x%p to 0x%p\n",
		      count, buf, fptr));

	/* Actually do something, but get a lock on the chip first.  */

	flash_safe_acquire(part);

	if ((err = flash_write(fptr, buf, count)) < 0) {
		count = err;
	}

	/* Release the lock.  */

	flash_safe_release(part);

	return count; /* success */
}


#ifdef CONFIG_CHR_DEV_FLASH

static int
flash_char_read(struct inode *inode, struct file *filp,
		char *buf, int count)
{
	int rlen;
	struct flashpartition *part = (struct flashpartition *)filp->private_data;

	FDEBUG(printk("flash_char_read\n"));
	rlen = flash_safe_read(part,
			       (unsigned char *)part->start + filp->f_pos,
			       (unsigned char *)buf, count);

	/* advance file position pointer */

	if(rlen >= 0)
		filp->f_pos += rlen;

	return rlen;
}

static int
flash_char_write(struct inode *inode, struct file *filp,
		 const char *buf, int count)
{
	int wlen;
	struct flashpartition *part = (struct flashpartition *)filp->private_data;

	FDEBUG(printk("flash_char_write\n"));
	wlen = flash_safe_write(part,
				(unsigned char *)part->start + filp->f_pos,
				(unsigned char *)buf, count);

	/* advance file position pointer */

	if(wlen >= 0)
		filp->f_pos += wlen;

	return wlen;
}

#endif /* CONFIG_CHR_DEV_FLASH */


static int
flash_ioctl(struct inode *inode, struct file *file,
	    unsigned int cmd, unsigned long arg)
{
	int minor;
	struct flashpartition *part;

	if (!inode || !inode->i_rdev)
		return -EINVAL;

	minor = MINOR(inode->i_rdev);

	if(minor < FLASH_MINOR)
		return -EINVAL; /* only ioctl's for flash devices */

	part = &partitions[minor - FLASH_MINOR];

	if(!part->start)
		return -EINVAL;

	switch(cmd) {
	case FLASHIO_ERASEALL:
		FDEBUG(printk("flash_ioctl(): Got FLASHIO_ERASEALL request.\n"));

		if(!suser())
			return -EACCES;

		/* Invalidate all pages and buffers */

		invalidate_inodes(inode->i_rdev);
		invalidate_buffers(inode->i_rdev);

		/*
		 * Start the erasure, then sleep and wake up now and
		 * then to see if it's done. We use the waitqueue to
		 * make sure we don't start erasing in the middle of
		 * a write, or that nobody start using the flash while
		 * we're erasing.
		 *
		 * TODO: break up partition erases that spans more than one
		 *       chip.
		 */

		flash_safe_acquire(part);

		flash_init_erase(part->start, part->size);

		while(flash_is_busy((flashptr)part->chip->start)) {
			current->state = TASK_INTERRUPTIBLE;
			current->timeout = jiffies + HZ / 2;
			schedule();
		}

		flash_safe_release(part);

		return 0;

	default:
		return -EPERM;
	}

	return -EPERM;
}

/* probe for Flash RAM's - this isn't in the init function, because this needs
 * to be done really early in the boot, so we can use the device to burn an
 * image before the system is running.
 */

void
flash_probe()
{
	int i;

	/* start adresses for the Flash chips - these should really
	 * be settable in some other way.
	 */
#ifdef FLASH_VERBOSE
	safe_printk("Probing flash...\n");
#endif

#if 0
	chips[0].start = (unsigned char *)(MEM_CSE0_START | MEM_NON_CACHEABLE);
	chips[1].start = (unsigned char *)(MEM_CSE1_START | MEM_NON_CACHEABLE);
#else
	chips[0].start = (unsigned char *)(0x10c00000);
	chips[1].start = (unsigned char *)(0x0);
#endif
	for(i = 0; i < MAX_CHIPS; i++) {
		struct flashchip *chip = chips + i;
		flashptr flashStart = (flashptr)chip->start;
		unsigned short manu;

#ifdef CONFIG_SVINTO_SIM
		/* in the simulator, dont trash the flash ram by writing unlocks */
		chip->isValid = 1;
		chip->device_id = AM29LV160BT;
#else
		/* reset */

		flashStart[unlockAddress1] = unlockData1;
		flashStart[unlockAddress2] = unlockData2;
		flashStart[unlockAddress1] = resetData;

		/* read manufacturer */

		flashStart[unlockAddress1] = unlockData1;
		flashStart[unlockAddress2] = unlockData2;
		flashStart[unlockAddress1] = manufacturerUnlockData;
		manu = flashStart[manufacturerAddress];
		chip->isValid = (manu == ManufacturerAMD ||
				 manu == ManufacturerToshiba ||
				 manu == ManufacturerST);

		if(!chip->isValid) {
#ifdef FLASH_VERBOSE
			safe_printk("Flash: No flash or unsupported "
				    "manufacturer.\n", i);
#endif
			continue;
		}

		/* reset */

		flashStart[unlockAddress1] = unlockData1;
		flashStart[unlockAddress2] = unlockData2;
		flashStart[unlockAddress1] = resetData;

		/* read device id */

		flashStart[unlockAddress1] = unlockData1;
		flashStart[unlockAddress2] = unlockData2;
		flashStart[unlockAddress1] = manufacturerUnlockData;
		chip->device_id = flashStart[deviceIdAddress];

		/* reset */

		flashStart[unlockAddress1] = unlockData1;
		flashStart[unlockAddress2] = unlockData2;
		flashStart[unlockAddress1] = resetData;
#endif

		/* check device type and fill in correct sizes etc */

		switch(chip->device_id) {
		case AM29LV160BT:
		case TC58FVT160:
#ifdef FLASH_VERBOSE
			safe_printk("Flash: 16Mb TB.\n");
#endif
			chip->size = 0x00200000;
			chip->sectorsize = 0x10000;
			chip->bootsector = chip->start + chip->size
					   - chip->sectorsize;
			chip->bootsectorsize[0] = 0x8000;
			chip->bootsectorsize[1] = 0x2000;
			chip->bootsectorsize[2] = 0x2000;
			chip->bootsectorsize[3] = 0x4000;
			break;
		//case AM29LV160BB:
		case TC58FVB160:
#ifdef FLASH_VERBOSE
			safe_printk("Flash: 16Mb BB.\n");
#endif
			chip->size = 0x00200000;
			chip->sectorsize = 0x10000;
			chip->bootsector = chip->start;
			chip->bootsectorsize[0] = 0x4000;
			chip->bootsectorsize[1] = 0x2000;
			chip->bootsectorsize[2] = 0x2000;
			chip->bootsectorsize[3] = 0x8000;
			break;
		case AM29LV800BB:
		case AM29F800BB:
#ifdef FLASH_VERBOSE
			safe_printk("Flash: 8Mb BB.\n");
#endif
			chip->size = 0x00100000;
			chip->sectorsize = 0x10000;
			chip->bootsector = chip->start;
			chip->bootsectorsize[0] = 0x4000;
			chip->bootsectorsize[1] = 0x2000;
			chip->bootsectorsize[2] = 0x2000;
			chip->bootsectorsize[3] = 0x8000;
			break;
		case M29W800T:
		case AM29LV800BT:
		case AM29F800BT:
#ifdef FLASH_VERBOSE
			safe_printk("Flash: 8Mb TB.\n");
#endif
			chip->size = 0x00100000;
			chip->sectorsize = 0x10000;
			chip->bootsector = chip->start + chip->size
					   - chip->sectorsize;
			chip->bootsectorsize[0] = 0x8000;
			chip->bootsectorsize[1] = 0x2000;
			chip->bootsectorsize[2] = 0x2000;
			chip->bootsectorsize[3] = 0x4000;
			break;
			//     case AM29LV800BB:
		default:
#ifdef FLASH_VERBOSE
			safe_printk("Flash: Unknown device.\n");
#endif
			chip->isValid = 0;
			break;
		}

		chip->busy = 0;
		init_waitqueue(&chip->wqueue);
	}
}

/* locate the flashchip structure associated with the given adress */

static struct flashchip *
getchip(unsigned char *ptr)
{
	int i;
	for(i = 0; i < MAX_CHIPS; i++) {
		if(ptr >= chips[i].start &&
		   ptr < (chips[i].start + chips[i].size))
			return &chips[i];
	}
	FDEBUG(printk("Illegal adress in Flash: getchip(0x%p)!\n", ptr));
	return (void *)0;
}

void *
flash_getpart(kdev_t dev)
{
	struct flashpartition *part;

	if (MINOR(dev) < FLASH_MINOR) {
		return 0;
	}

	part = &partitions[MINOR(dev) - FLASH_MINOR];

	if (!part->start) {
		return 0;
	}

	return (void *)part;
}


unsigned char *
flash_get_direct_pointer(kdev_t dev, __u32 offset)
{
	struct flashpartition *part;

	if (MINOR(dev) < FLASH_MINOR) {
		return 0;
	}

	part = &partitions[MINOR(dev) - FLASH_MINOR];

	if (!part->start) {
		return 0;
	}

	return (unsigned char *) ((__u32) part->start + offset);
}


/* start erasing flash-memory at ptr of a certain size
 * this does not wait until the erasing is done
 */

void
flash_init_erase(unsigned char *ptr, unsigned int size)
{
	struct flashchip *chip;
	int bootSectorCounter = 0;
	unsigned int erasedSize = 0;
	flashptr flashStart;
#ifdef IRQ_LOCKS
	unsigned long flags;
#endif

	ptr = (unsigned char *)((unsigned long)ptr | MEM_NON_CACHEABLE);
	chip = getchip(ptr);
	flashStart = (flashptr)chip->start;

	FDEBUG(safe_printk("Flash: erasing memory at 0x%p, size 0x%x.\n", ptr, size));

	/* need to disable interrupts, to avoid possible delays between the
	 * unlocking and erase-init
	 */

#ifdef IRQ_LOCKS
	save_flags(flags);
	cli();
#endif

	/* Init erasing of the number of sectors needed */

	flashStart[unlockAddress1] = unlockData1;
	flashStart[unlockAddress2] = unlockData2;
	flashStart[unlockAddress1] = sectorEraseUnlockData;
	flashStart[unlockAddress1] = unlockData1;
	flashStart[unlockAddress2] = unlockData2;

	while(erasedSize < size) {
		*(flashptr)ptr = sectorEraseUnlockData2;

		/* make sure we erase the individual bootsectors if in that area */
		/* TODO this BREAKS if we start erasing in the middle of the bootblock! */

		if(ptr < chip->bootsector || ptr >= (chip->bootsector +
						     chip->sectorsize)) {
			erasedSize += chip->sectorsize;
			ptr += chip->sectorsize;
		} else {
			erasedSize += chip->bootsectorsize[bootSectorCounter];
			ptr += chip->bootsectorsize[bootSectorCounter++];
		}
	}

#ifdef IRQ_LOCKS
	restore_flags(flags);
#endif
	/* give the busy signal time enough to activate (tBusy, 90 ns) */

	nop(); nop(); nop(); nop(); nop(); nop(); nop(); nop(); nop();
}


int
flash_erase_region(kdev_t dev, __u32 offset, __u32 size)
{
	int minor;
	struct flashpartition *part;
	unsigned char *erase_start;
	short retries = 5;
	short success;

	minor = MINOR(dev);
	if (minor < FLASH_MINOR) {
		return -EINVAL;
	}

	part = &partitions[minor - FLASH_MINOR];
	if (!part->start) {
		return -EINVAL;
	}

	/* Start the erasure, then sleep and wake up now and then to see
	 * if it's done.
	 */

	erase_start = part->start + offset;

	flash_safe_acquire(part);
	do {
		flash_init_erase(erase_start, size);

		while (flash_is_busy((flashptr)part->chip->start)) {
			current->state = TASK_INTERRUPTIBLE;
			current->timeout = jiffies + HZ / 2;
			schedule();
		}

		success = ((flashptr)erase_start)[0] == 0xffff
			  && ((flashptr)erase_start)[1] == 0xffff
			  && ((flashptr)erase_start)[2] == 0xffff
			  && ((flashptr)erase_start)[3] == 0xffff;

		if (!success) {
			printk(KERN_NOTICE "flash: erase of region "
			       "[0x%p, 0x%p] failed once\n",
			       erase_start, erase_start + size);
		}

	} while (retries-- && !success);

	flash_safe_release(part);

	if (retries == 0 && !success) {
		printk(KERN_WARNING "flash: erase of region "
			       "[0x%p, 0x%p] totally failed\n",
			       erase_start, erase_start + size);
		return -1;
	}

	return 0;
}


/* wait until the erase operation is finished, in a CPU hogging manner */

void
flash_busy_wait_erase(unsigned char *ptr)
{
	flashptr flashStart;

	ptr = (unsigned char *)((unsigned long)ptr | MEM_NON_CACHEABLE);
	flashStart = (flashptr)getchip(ptr)->start;

	/* busy-wait for flash completion - when D6 stops toggling between
	 * reads.
	 */
	while(flash_is_busy(flashStart))
		/* nothing */;
}

/* erase all flashchips and wait until operation is completed */

void
flash_erase_all()
{
	/* TODO: we should loop over chips, not just try the first two! */

	if(chips[0].isValid)
		flash_init_erase(chips[0].start, chips[0].size);

	if(chips[1].isValid)
		flash_init_erase(chips[1].start, chips[0].size);

	if(chips[0].isValid)
		flash_busy_wait_erase(chips[0].start);

	if(chips[1].isValid)
		flash_busy_wait_erase(chips[1].start);

#ifdef FLASH_VERBOSE
	safe_printk("Flash: full erasure completed.\n");
#endif
}

/* Write a block of Flash. The destination Flash sectors need to be erased
 * first. If the size is larger than the Flash chip the block starts in, the
 * function will continue flashing in the next chip if it exists.
 * Returns 0 on success, -1 on error.
 */

int
flash_write(unsigned char *ptr, const unsigned char *source, unsigned int size)
{
#ifndef CONFIG_SVINTO_SIM
	struct flashchip *chip;
	flashptr theData = (flashptr)source;
	flashptr flashStart;
	flashptr programAddress;
	int i, fsize;
	int odd_size;

	ptr = (unsigned char *)((unsigned long)ptr | MEM_NON_CACHEABLE);

	while(size > 0) {
		chip = getchip(ptr);

		if(!chip) {
			printk("Flash: illegal ptr 0x%p in flash_write.\n", ptr);
			return -EINVAL;
		}

		flashStart = (flashptr)chip->start;
		programAddress = (flashptr)ptr;

		/* if the block doesn't fit in this flash chip, clamp the size */

		fsize = (ptr + size) > (chip->start + chip->size) ?
			(chip->start + chip->size - ptr) : size;

		ptr += fsize;
		size -= fsize;
		odd_size = fsize & 1;

		fsize >>= 1; /* We write one word at a time.  */

		FDEBUG(printk("flash_write (flash start 0x%p) %d words to 0x%p\n",
			      flashStart, fsize, programAddress));

		for (i = 0; i < fsize; i++) {
			int retries = 0;

			do {
				int timeout;
				/* Start programming sequence.
				 */
#ifdef IRQ_LOCKS
				unsigned long flags;
				save_flags(flags);
				cli();
#endif
				flashStart[unlockAddress1] = unlockData1;
				flashStart[unlockAddress2] = unlockData2;
				flashStart[unlockAddress1] = programUnlockData;
				*programAddress = *theData;
				/* give the busy signal time to activate (tBusy, 90 ns) */
				nop(); nop(); nop(); nop(); nop(); nop(); nop(); nop(); nop();
				/* Wait for programming to finish.  */
				timeout = 500000;
				while(timeout-- &&
				      (*flashStart & D6_MASK)
				      != (*flashStart & D6_MASK))
				/* nothing */;
#ifdef IRQ_LOCKS
				restore_flags(flags);
#endif
				if(!timeout)
					printk("flash: write timeout 0x%p\n",
					       programAddress);
				if(*programAddress == *theData)
					break;

				printk("Flash: verify error 0x%p. "
				       "(flash_write() 1)\n",
				       programAddress);
				printk("*programAddress = 0x%04x, "
				       "*theData = 0x%04x\n",
				       *programAddress, *theData);
			} while(++retries < 5);

			if(retries >= 5) {
				printk("FATAL FLASH ERROR (1)\n");
				return -EIO; /* we failed... */
			}

			programAddress++;
			theData++;
		}

		/* We should write one extra byte to the flash.  */
		if (odd_size) {
			unsigned char last_byte[2];
			int retries = 0;

			last_byte[0] = *(unsigned char *)theData;
			last_byte[1] = ((unsigned char *)programAddress)[1];

			do {
				int timeout = 500000;
#ifdef IRQ_LOCKS
				unsigned long flags;
				save_flags(flags);
				cli();
#endif
				flashStart[unlockAddress1] = unlockData1;
				flashStart[unlockAddress2] = unlockData2;
				flashStart[unlockAddress1] = programUnlockData;
				*programAddress = *(flashptr) last_byte;
				/* give the busy signal time enough to activate (tBusy, 90 ns) */
				nop(); nop(); nop(); nop(); nop(); nop(); nop(); nop(); nop();
				/* Wait for programming to finish */
				while (timeout-- &&
				       (*flashStart & D6_MASK)
				       != (*flashStart & D6_MASK))
				/* nothing */;
#ifdef IRQ_LOCKS
				restore_flags(flags);
#endif
				if(!timeout)
					printk("flash: write timeout 0x%p\n",
					       programAddress);
				if(*programAddress
				   == *(flashptr)last_byte)
					break;

				printk("Flash: verify error 0x%p. "
				       "(flash_write() 2)\n",
				       programAddress);
			} while(++retries < 5);

			if(retries >= 5) {
				printk("FATAL FLASH ERROR (2)\n");
				return -EIO; /* we failed... */
			}
		}
	}

#else
	/* in the simulator we simulate flash as ram, so we can use a simple memcpy */
	printk("flash write, source %p dest %p size %d\n", source, ptr, size);
	memcpy(ptr, source, size);
#endif
	return 0;
}


/* "Memset" a chunk of memory on the flash.
 * do this by flash_write()'ing a pattern chunk.
 */

int
flash_memset(unsigned char *ptr, const __u8 c, unsigned long size)
{
#ifndef CONFIG_SVINTO_SIM

	static unsigned char pattern[16];
	int i;

	/* fill up pattern */

	for(i = 0; i < 16; i++)
		pattern[i] = c;

	/* write as many 16-byte chunks as we can */

	while(size >= 16) {
		flash_write(ptr, pattern, 16);
		size -= 16;
		ptr += 16;
	}

	/* and the rest */

	if(size)
		flash_write(ptr, pattern, size);
#else

	/* In the simulator, we simulate flash as ram, so we can use a
	   simple memset.  */
	printk("flash memset, byte 0x%x dest %p size %d\n", c, ptr, size);
	memset(ptr, c, size);

#endif

	return 0;
}


#ifdef CONFIG_BLK_DEV_FLASH
/* the operations supported by the block device */

static struct file_operations flash_block_fops =
{
	NULL,                   /* lseek - default */
	block_read,             /* read - general block-dev read */
	block_write,            /* write - general block-dev write */
	NULL,                   /* readdir - bad */
	NULL,                   /* poll */
	flash_ioctl,            /* ioctl */
	NULL,                   /* mmap */
	flash_open,             /* open */
	flash_release,          /* release */
	block_fsync,            /* fsync */
	NULL,			/* fasync */
	NULL,			/* check media change */
	NULL			/* revalidate */
};
#endif

#ifdef CONFIG_CHR_DEV_FLASH
/* the operations supported by the char device */

static struct file_operations flash_char_fops =
{
	NULL,                   /* lseek - default */
	flash_char_read,        /* read */
	flash_char_write,       /* write */
	NULL,                   /* readdir - bad */
	NULL,                   /* poll */
	flash_ioctl,            /* ioctl */
	NULL,                   /* mmap */
	flash_open,             /* open */
	flash_release,          /* release */
	NULL,                   /* fsync */
	NULL,			/* fasync */
	NULL,			/* check media change */
	NULL			/* revalidate */
};
#endif

/* Initialize the flash_partitions array, by reading the partition information from the
 * partition table (if there is any). Otherwise use a default partition set.
 *
 * The first partition is always sector 0 on the first chip, so start by initializing that.
 * TODO: partitions only reside on chip[0] now. check that.
 */

static void
flash_init_partitions()
{
	struct bootblock *bootb;
	struct partitiontable *ptable;
	int pidx = 0;
	const char *pmsg = "  /dev/flash%d at 0x%x, size 0x%x\n";

	/* if there is no chip 0, there is no bootblock => no partitions at all */

	if(chips[0].isValid) {

		printk("Checking flash partitions:\n");
		/* first sector in the flash is partition 0,
		 * regardless of if its a real flash "bootblock" or not
		 */

		partitions[0].chip = &chips[0];
		partitions[0].start = chips[0].start;
		partitions[0].size = chips[0].sectorsize;
		partitions[0].flags = 0;  /* FIXME */
		flash_sizes[FLASH_MINOR] =
			partitions[0].size >> BLOCK_SIZE_BITS;
		printk(pmsg, 0, partitions[0].start, partitions[0].size);
		pidx++;


		bootb = (struct bootblock *)partitions[0].start;

#ifdef CONFIG_SVINTO_SIM
                /* If running in the simulator, do not scan nonexistent
		   memory.  Behave as when the bootblock is "broken".
                   ??? FIXME: Maybe there's something better to do. */
		partitions[pidx].chip = &chips[0];
		partitions[pidx].start = chips[0].start;
		partitions[pidx].size = chips[0].size;
		partitions[pidx].flags = 0; /* FIXME */
		flash_sizes[FLASH_MINOR + pidx] =
			partitions[pidx].size >> BLOCK_SIZE_BITS;
		printk(pmsg, pidx, partitions[pidx].start, partitions[pidx].size);
		pidx++;
#else  /* ! defined CONFIG_SVINTO_SIM */
		/* TODO: until we've defined a better partition table, always do the
		 * default flash1 and flash2 partitions.
		 */
		if(1 || bootb->magic != FLASH_BOOT_MAGIC) {

			/* the flash is split into flash1, flash2 and bootblock
			 * (flash0)
			 */

			printk("  No partitiontable recognized. Using default "
			       "flash1 and flash2.\n");

			/* flash1 starts after the first sector */

			partitions[pidx].chip = &chips[0];
			partitions[pidx].start = chips[0].start + chips[0].sectorsize;
			partitions[pidx].size = chips[0].size - (DEF_FLASH2_SIZE +
				partitions[0].size);
			partitions[pidx].flags = 0; /* FIXME */
			flash_sizes[FLASH_MINOR + pidx] =
				partitions[pidx].size >> BLOCK_SIZE_BITS;
			printk(pmsg, pidx, partitions[pidx].start,
			       partitions[pidx].size);
			pidx++;

			/* flash2 starts after flash1. */

			partitions[pidx].chip = &chips[0];
			partitions[pidx].start = partitions[pidx - 1].start +
				partitions[pidx - 1].size;
			partitions[pidx].size = DEF_FLASH2_SIZE;
			partitions[pidx].flags = 0; /* FIXME */
			flash_sizes[FLASH_MINOR + pidx] =
				partitions[pidx].size >> BLOCK_SIZE_BITS;
			printk(pmsg, pidx, partitions[pidx].start,
			       partitions[pidx].size);
			pidx++;

		} else {

			/* a working bootblock! read partitiontable */

			ptable = (struct partitiontable *)(partitions[0].start + bootb->ptable_offset);

			/* scan the table. it ends when there is 0xffffffff, that is, empty flash. */

			while(ptable->offset != 0xffffffff) {
				partitions[pidx].chip = &chips[0];
				partitions[pidx].start = chips[0].start +
					ptable->offset;
				partitions[pidx].size = ptable->size;
				partitions[pidx].flags = ptable->flags;
				flash_sizes[FLASH_MINOR + pidx] =
					partitions[pidx].size >> BLOCK_SIZE_BITS;
				printk(pmsg, pidx, partitions[pidx].start,
				       partitions[pidx].size);
				pidx++;
				ptable++;
			}
		}
#endif /* ! defined CONFIG_SVINTO_SIM */
	}

	/* fill in the rest of the table as well */

	while(pidx < MAX_PARTITIONS) {
		partitions[pidx].start = 0;
		partitions[pidx].size = 0;
		partitions[pidx].chip = 0;
		pidx++;
	}

	/*flash_blk_sizes[FLASH_MINOR + i] = 1024; TODO this should be 512.. */
}

#ifdef LISAHACK
static void
move_around_bootparams()
{
	unsigned long *newp = (unsigned long *)0x8000c000;  /* new bootsector */
	unsigned long *oldp = (unsigned long *)0x801fc000;  /* old bootsector */
	unsigned long *buf;
	unsigned long magic = 0xbeefcace;

	printk("Checking if we need to move bootparams...");

	/* first check if they are already moved */

	if(*newp == magic) {
		printk(" no\n");
		return;
	}

	printk(" yes. Moving..");

	buf = (unsigned long *)kmalloc(0x4000, GFP_KERNEL);

	memcpy(buf, oldp, 0x4000);

	flash_write((unsigned char *)newp, (unsigned char *)&magic, 4);
	flash_write((unsigned char *)(newp + 1), (unsigned char *)buf, 0x4000 - 4);

	/* erase old boot block, so JFFS can expand into it */

	flash_init_erase((unsigned char *)0x801f0000, chips[0].sectorsize);
	flash_busy_wait_erase(chips[0].start);

	printk(" done.\n");

	kfree(buf);
}
#endif

/* register the device into the kernel - called at boot */

int
flash_init()
{
#ifdef CONFIG_BLK_DEV_FLASH
	/* register the block device major */

	if(register_blkdev(MAJOR_NR, DEVICE_NAME, &flash_block_fops )) {
		printk(KERN_ERR DEVICE_NAME ": Unable to get major %d\n",
		       MAJOR_NR);
		return -EBUSY;
	}

	/* register the actual block I/O function - do_flash_request - and the
	 * tables containing the device sizes (in 1kb units) and block sizes
	 */

	blk_dev[MAJOR_NR].request_fn = DEVICE_REQUEST;
	blk_size[MAJOR_NR] = flash_sizes;
	blksize_size[MAJOR_NR] = flash_blk_sizes;
	read_ahead[MAJOR_NR] = 1; /* fast device, so small read ahead */

	printk("Flash/ROM block device v2.1, (c) 1999 Axis Communications AB\n");
#endif

#ifdef CONFIG_CHR_DEV_FLASH
	/* register the char device major */

	if(register_chrdev(MAJOR_NR, DEVICE_NAME, &flash_char_fops )) {
		printk(KERN_ERR DEVICE_NAME ": Unable to get major %d\n",
		       MAJOR_NR);
		return -EBUSY;
	}

	printk("Flash/ROM char device v2.1, (c) 1999 Axis Communications AB\n");
#endif

	/* initialize partition table */

	flash_init_partitions();

#ifdef LISAHACK
	/* nasty hack to "upgrade" older beta units of Lisa into newer by
	 * moving the boot block parameters. will go away as soon as this
	 * build is done.
	 */

	move_around_bootparams();
#endif

	return 0;
}

/* check if it's possible to erase the wanted range, and if not, return
 * the range that IS erasable, or a negative error code.
 */

long
flash_erasable_size(void *_part, __u32 offset, __u32 size)
{
	struct flashpartition *part = (struct flashpartition *)_part;
	int ssize;

	if (!part->start) {
		return -EINVAL;
	}

	/* assume that sector size for a partition is constant even
	 * if it spans more than one chip (you usually put the same
	 * type of chips in a system)
	 */

	ssize = part->chip->sectorsize;

	if (offset % ssize) {
		/* The offset is not sector size aligned.  */
		return -1;
	}
	else if (offset > part->size) {
		return -2;
	}
	else if (offset + size > part->size) {
		return -3;
	}

	return (size / ssize) * ssize;
}
