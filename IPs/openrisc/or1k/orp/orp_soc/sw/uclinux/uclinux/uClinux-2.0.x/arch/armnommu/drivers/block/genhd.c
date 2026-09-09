/*
 *  Code extracted from
 *  linux/kernel/hd.c
 *
 *  Copyright (C) 1991, 1992  Linus Torvalds
 *
 *
 *  Thanks to Branko Lankester, lankeste@fwi.uva.nl, who found a bug
 *  in the early extended-partition checks and added DM partitions
 *
 *  Support for DiskManager v6.0x added by Mark Lord,
 *  with information provided by OnTrack.  This now works for linux fdisk
 *  and LILO, as well as loadlin and bootln.  Note that disks other than
 *  /dev/hda *must* have a "DOS" type 0x51 partition in the first slot (hda1).
 *
 *  More flexible handling of extended partitions - aeb, 950831
 *
 *  Modifications Copyright (C) 1995, 1996 Russell King
 *
 *  Origional from linux/drivers/genhd.c
 *
 *  Altered to find image files on ADFS-formatted hard drives.
 */

#include <linux/config.h>
#include <linux/fs.h>
#include <linux/genhd.h>
#include <linux/kernel.h>
#include <linux/major.h>
#include <linux/string.h>
#ifdef CONFIG_BLK_DEV_INITRD
#include <linux/blk.h>
#endif

#include <asm/system.h>

/*
 * Many architectures don't like unaligned accesses, which is
 * frequently the case with the nr_sects and start_sect partition
 * table entries.
 */
#include <asm/unaligned.h>

#define SYS_IND(p)	get_unaligned(&p->sys_ind)
#define NR_SECTS(p)	get_unaligned(&p->nr_sects)
#define START_SECT(p)	get_unaligned(&p->start_sect)


struct gendisk *gendisk_head;

static int current_minor;
extern int *blk_size[];
extern void rd_load(void);
extern void initrd_load(void);

extern int chr_dev_init(void);
extern int blk_dev_init(void);
extern int scsi_dev_init(void);
extern int net_dev_init(void);

/*
 * disk_name() is used by genhd.c and md.c.
 * It formats the devicename of the indicated disk
 * into the supplied buffer, and returns a pointer
 * to that same buffer (for convenience).
 */
char *disk_name (struct gendisk *hd, int minor, char *buf)
{
	unsigned int part;
	const char *maj = hd->major_name;
	char unit = (minor >> hd->minor_shift) + 'a';

#ifdef CONFIG_BLK_DEV_IDE
	/*
	 * IDE devices use multiple major numbers, but the drives
	 * are named as:  {hda,hdb}, {hdc,hdd}, {hde,hdf}, {hdg,hdh}..
	 * This requires special handling here.
	 */
	switch (hd->major) {
		case IDE3_MAJOR:
			unit += 2;
		case IDE2_MAJOR:
			unit += 2;
		case IDE1_MAJOR:
			unit += 2;
		case IDE0_MAJOR:
			maj = "hd";
	}
#endif
	part = minor & ((1 << hd->minor_shift) - 1);
	if (part)
		sprintf(buf, "%s%c%d", maj, unit, part);
	else
		sprintf(buf, "%s%c", maj, unit);
	return buf;
}

void add_partition (struct gendisk *hd, int minor, int start, int size)
{
	char buf[8];
	hd->part[minor].start_sect = start;
	hd->part[minor].nr_sects   = size;
	printk(" %s", disk_name(hd, minor, buf));
}

static inline int is_extended_partition(struct partition *p)
{
	return (SYS_IND(p) == DOS_EXTENDED_PARTITION ||
		SYS_IND(p) == LINUX_EXTENDED_PARTITION);
}

#ifdef CONFIG_MSDOS_PARTITION
/*
 * Create devices for each logical partition in an extended partition.
 * The logical partitions form a linked list, with each entry being
 * a partition table with two entries.  The first entry
 * is the real data partition (with a start relative to the partition
 * table start).  The second is a pointer to the next logical partition
 * (with a start relative to the entire extended partition).
 * We do not create a Linux partition for the partition tables, but
 * only for the actual data partitions.
 */

static void extended_partition(struct gendisk *hd, kdev_t dev)
{
	struct buffer_head *bh;
	struct partition *p;
	unsigned long first_sector, first_size, this_sector, this_size;
	int mask = (1 << hd->minor_shift) - 1;
	int i;

	first_sector = hd->part[MINOR(dev)].start_sect;
	first_size = hd->part[MINOR(dev)].nr_sects;
	this_sector = first_sector;

	while (1) {
		if ((current_minor & mask) == 0)
			return;
		if (!(bh = bread(dev,0,1024)))
			return;
	  /*
	   * This block is from a device that we're about to stomp on.
	   * So make sure nobody thinks this block is usable.
	   */
		bh->b_state = 0;

		if (*(unsigned short *) (bh->b_data+510) != 0xAA55)
			goto done;

		p = (struct partition *) (0x1BE + bh->b_data);

		this_size = hd->part[MINOR(dev)].nr_sects;

		/*
		 * Usually, the first entry is the real data partition,
		 * the 2nd entry is the next extended partition, or empty,
		 * and the 3rd and 4th entries are unused.
		 * However, DRDOS sometimes has the extended partition as
		 * the first entry (when the data partition is empty),
		 * and OS/2 seems to use all four entries.
		 */

		/* 
		 * First process the data partition(s)
		 */
		for (i=0; i<4; i++, p++) {
		    if (!NR_SECTS(p) || is_extended_partition(p))
		      continue;

		    /* Check the 3rd and 4th entries -
		       these sometimes contain random garbage */
		    if (i >= 2
			&& START_SECT(p) + NR_SECTS(p) > this_size
			&& (this_sector + START_SECT(p) < first_sector ||
			    this_sector + START_SECT(p) + NR_SECTS(p) >
			     first_sector + first_size))
		      continue;

		    add_partition(hd, current_minor, this_sector+START_SECT(p), NR_SECTS(p));
		    current_minor++;
		    if ((current_minor & mask) == 0)
		      goto done;
		}
		/*
		 * Next, process the (first) extended partition, if present.
		 * (So far, there seems to be no reason to make
		 *  extended_partition()  recursive and allow a tree
		 *  of extended partitions.)
		 * It should be a link to the next logical partition.
		 * Create a minor for this just long enough to get the next
		 * partition table.  The minor will be reused for the next
		 * data partition.
		 */
		p -= 4;
		for (i=0; i<4; i++, p++)
		  if(NR_SECTS(p) && is_extended_partition(p))
		    break;
		if (i == 4)
		  goto done;	 /* nothing left to do */

		hd->part[current_minor].nr_sects = NR_SECTS(p);
		hd->part[current_minor].start_sect = first_sector + START_SECT(p);
		this_sector = first_sector + START_SECT(p);
		dev = MKDEV(hd->major, current_minor);
		brelse(bh);
	}
done:
	brelse(bh);
}

#ifdef CONFIG_BSD_DISKLABEL
/* 
 * Create devices for BSD partitions listed in a disklabel, under a
 * dos-like partition. See extended_partition() for more information.
 */
static void bsd_disklabel_partition(struct gendisk *hd, kdev_t dev)
{
	struct buffer_head *bh;
	struct bsd_disklabel *l;
	struct bsd_partition *p;
	int mask = (1 << hd->minor_shift) - 1;

	if (!(bh = bread(dev,0,1024)))
		return;
	bh->b_state = 0;
	l = (struct bsd_disklabel *) (bh->b_data+512);
	if (l->d_magic != BSD_DISKMAGIC) {
		brelse(bh);
		return;
	}

	p = &l->d_partitions[0];
	while (p - &l->d_partitions[0] <= BSD_MAXPARTITIONS) {
		if ((current_minor & mask) >= (4 + hd->max_p))
			break;

		if (p->p_fstype != BSD_FS_UNUSED) {
			add_partition(hd, current_minor, p->p_offset, p->p_size);
			current_minor++;
		}
		p++;
	}
	brelse(bh);

}
#endif

static int msdos_partition(struct gendisk *hd, kdev_t dev, unsigned long first_sector)
{
	int i, minor = current_minor;
	struct buffer_head *bh;
	struct partition *p;
	unsigned char *data;
	int mask = (1 << hd->minor_shift) - 1;

	if (!(bh = bread(dev,0,1024))) {
		printk(" unable to read partition table\n");
		return -1;
	}
	data = bh->b_data;
	/* In some cases we modify the geometry    */
	/*  of the drive (below), so ensure that   */
	/*  nobody else tries to re-use this data. */
	bh->b_state = 0;

	if (*(unsigned short *)  (0x1fe + data) != 0xAA55) {
		brelse(bh);
		return 0;
	}
	printk (" [DOS]");
	p = (struct partition *) (0x1be + data);

	current_minor += 4;  /* first "extra" minor (for extended partitions) */
	for (i=1 ; i<=4 ; minor++,i++,p++) {
		if (!NR_SECTS(p))
			continue;
		add_partition(hd, minor, first_sector+START_SECT(p), NR_SECTS(p));
		if (is_extended_partition(p)) {
			printk(" <");
			/*
			 * If we are rereading the partition table, we need
			 * to set the size of the partition so that we will
			 * be able to bread the block containing the extended
			 * partition info.
			 */
			hd->sizes[minor] = hd->part[minor].nr_sects 
			  	>> (BLOCK_SIZE_BITS - 9);
			extended_partition(hd, MKDEV(hd->major, minor));
			printk(" >");
			/* prevent someone doing mkfs or mkswap on an
			   extended partition, but leave room for LILO */
			if (hd->part[minor].nr_sects > 2)
				hd->part[minor].nr_sects = 2;
		}
#ifdef CONFIG_BSD_DISKLABEL
		if (SYS_IND(p) == BSD_PARTITION) {
			printk(" <");
			bsd_disklabel_partition(hd, MKDEV(hd->major, minor));
			printk(" >");
		}
#endif
	}
	/*
	 *  Check for old-style Disk Manager partition table
	 */
	if (*(unsigned short *) (data+0xfc) == 0x55AA) {
		p = (struct partition *) (0x1be + data);
		for (i = 4 ; i < 16 ; i++, current_minor++) {
			p--;
			if ((current_minor & mask) == 0)
				break;
			if (!(START_SECT(p) && NR_SECTS(p)))
				continue;
			add_partition(hd, current_minor, START_SECT(p), NR_SECTS(p));
		}
	}
	printk("\n");
	brelse(bh);
	return 1;
}

#endif /* CONFIG_MSDOS_PARTITION */

extern int adfspart_initdev (struct gendisk *hd, kdev_t dev, int first_sector, int minor);

static void check_partition(struct gendisk *hd, kdev_t dev)
{
	static int first_time = 1;
	unsigned long first_sector;
	char buf[8];

	if (first_time)
		printk("Partition check:\n");
	first_time = 0;
	first_sector = hd->part[MINOR(dev)].start_sect;

	/*
	 * This is a kludge to allow the partition check to be
	 * skipped for specific drives (e.g. IDE cd-rom drives)
	 */
	if ((int)first_sector == -1) {
		hd->part[MINOR(dev)].start_sect = 0;
		return;
	}

	printk(" %s:", disk_name(hd, MINOR(dev), buf));
#ifdef CONFIG_BLK_DEV_PART
	if (adfspart_initdev (hd, dev, first_sector, current_minor))
		return;
#endif
#ifdef CONFIG_MSDOS_PARTITION
	if (msdos_partition(hd, dev, first_sector))
		return;
#endif
	printk(" unknown partition table\n");
}

/*
 * This function is used to re-read partition tables for removable disks.
 * Much of the cleanup from the old partition tables should have already been
 * done
 */

/*
 * This function will re-read the partition tables for a given device,
 * and set things back up again.  There are some important caveats,
 * however.  You must ensure that no one is using the device, and no one
 * can start using the device while this function is being executed.
 */
void resetup_one_dev(struct gendisk *dev, int drive)
{
	int i;
	int first_minor	= drive << dev->minor_shift;
	int end_minor	= first_minor + dev->max_p;

	blk_size[dev->major] = NULL;
	current_minor = 1 + first_minor;
	check_partition(dev, MKDEV(dev->major, first_minor));

 	/*
 	 * We need to set the sizes array before we will be able to access
 	 * any of the partitions on this device.
 	 */
	if (dev->sizes != NULL) {	/* optional safeguard in ll_rw_blk.c */
		for (i = first_minor; i < end_minor; i++)
			dev->sizes[i] = dev->part[i].nr_sects >> (BLOCK_SIZE_BITS - 9);
		blk_size[dev->major] = dev->sizes;
	}
}

static void setup_dev(struct gendisk *dev)
{
	int i, drive;
	int end_minor	= dev->max_nr * dev->max_p;

	blk_size[dev->major] = NULL;
	for (i = 0 ; i < end_minor; i++) {
		dev->part[i].start_sect = 0;
		dev->part[i].nr_sects = 0;
	}
	dev->init(dev);	
	for (drive = 0 ; drive < dev->nr_real ; drive++) {
		int first_minor	= drive << dev->minor_shift;
		current_minor = 1 + first_minor;
		check_partition(dev, MKDEV(dev->major, first_minor));
	}
	if (dev->sizes != NULL) {	/* optional safeguard in ll_rw_blk.c */
		for (i = 0; i < end_minor; i++)
			dev->sizes[i] = dev->part[i].nr_sects >> (BLOCK_SIZE_BITS - 9);
		blk_size[dev->major] = dev->sizes;
	}
}

void device_setup(void)
{
	extern void console_map_init(void);
	extern void adfsimg_init (void);
	struct gendisk *p;
	int nr=0;

	chr_dev_init();
	blk_dev_init();
	sti();
#ifdef CONFIG_SCSI
	scsi_dev_init();
#endif
#ifdef CONFIG_INET
	net_dev_init();
#endif
	console_map_init();
#ifdef CONFIG_BLK_DEV_IMG
	adfsimg_init ();
#endif
	for (p = gendisk_head ; p ; p=p->next) {
		setup_dev(p);
		nr += p->nr_real;
	}
#ifdef CONFIG_BLK_DEV_RAM
#ifdef CONFIG_BLK_DEV_INITRD
	if (initrd_start && mount_initrd) initrd_load();
	else
#endif
	rd_load();
#endif
}
