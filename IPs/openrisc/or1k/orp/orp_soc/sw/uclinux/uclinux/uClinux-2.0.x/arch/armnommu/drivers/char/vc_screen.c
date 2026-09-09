/*
 * linux/arch/arm/drivers/char/vc_screen.c
 *
 * Provide access to virtual console memory.
 * /dev/vcs0: the screen as it is being viewed right now (possibly scrolled)
 * /dev/vcsN: the screen of /dev/ttyN (1 <= N <= 63)
 *            [minor: N]
 *
 * /dev/vcsaN: idem, but including attributes, and prefixed with
 *	the 4 bytes lines,columns,x,y (as screendump used to give)
 *            [minor: N+128]
 *
 * This replaces screendump and part of selection, so that the system
 * administrator can control access using file system permissions.
 *
 * aeb@cwi.nl - efter Friedas begravelse - 950211
 *
 * Modified by Russell King (01/01/96) [experimental + in development]
 */

#include <linux/kernel.h>
#include <linux/major.h>
#include <linux/errno.h>
#include <linux/tty.h>
#include <linux/fs.h>
#include <asm/segment.h>

#include "vt_kern.h"
#include "selection.h"

#define HEADER_SIZE	4

static inline int vcs_size (struct inode *inode)
{
    int size = vtdata.numrows * vtdata.numcolumns;

    if (MINOR(inode->i_rdev) & 128)
	size = sizeof (unsigned long) * size + HEADER_SIZE;
    return size;
}

static int vcs_lseek (struct inode *inode, struct file *file, off_t offset, int orig)
{
    int size = vcs_size(inode);

    switch (orig) {
    case 0:
	file->f_pos = offset;
	break;
    case 1:
	file->f_pos += offset;
	break;
    case 2:
	file->f_pos = size + offset;
	break;
    default:
	return -EINVAL;
    }
    if (file->f_pos < 0 || file->f_pos > size)
	return -EINVAL;
    return file->f_pos;
}

static int vcs_read (struct inode *inode, struct file *file, char *buf, int count)
{
    struct vt *vt;
    unsigned long p = file->f_pos;
    unsigned int cons = MINOR(inode->i_rdev);
    int attr, size, read;
    char *buf0;
    unsigned long *org, d;

    attr = (cons & 128);
    cons = (cons & 127);

    if (cons == 0)
	vt = vtdata.fgconsole;
    else
	vt = vt_con_data + (cons - 1);

    if (!vt_allocated (vt))
	return -ENXIO;

    size = vcs_size(inode);
    if (count < 0 || p > size)
	return -EINVAL;

    if (count > size - p)
	count = size - p;

    buf0 = buf;
    if (!attr) {
	org = screen_pos (vt, p);
	while (count-- > 0)
	    put_user (*org++ & 0xff, buf++);
    } else {
	if (p < HEADER_SIZE) {
	    char header[HEADER_SIZE];
	    header[0] = (char) vtdata.numrows;
	    header[1] = (char) vtdata.numcolumns;
	    getconsxy (vt, header + 2);
	    while (p < HEADER_SIZE && count-- > 0)
		put_user (header[p++], buf++);
	}
	p -= HEADER_SIZE;
	org = screen_pos (vt, p >> 2);

	if (p & 3) {
	    unsigned long d = *org++;

	    switch (p & 3) {
	    case 1:
		if (count-- > 0)
		    put_user ((d >> 8) & 255, buf++);
	    case 2:
		if (count-- > 0)
		    put_user ((d >> 16) & 255, buf++);
	    case 3:
		if (count-- > 0)
		    put_user (d >> 24, buf++);
	    }
	}

	while (count > 3) {
	    put_user (*org++, (unsigned long *) buf);
	    buf += 4;
	    count -= 4;
	}

	if (count > 0) {
	    d = *org;
	    put_user (d & 0xff, buf++);
	    if (count > 1)
		put_user ((d >> 8) & 0xff, buf++);
	    if (count > 2)
		put_user ((d >> 16) & 0xff, buf++);
	}
    }
    read = buf - buf0;
    file->f_pos += read;
    return read;
}

static int vcs_write (struct inode *inode, struct file *file, const char *buf, int count)
{
    struct vt *vt;
    unsigned long p = file->f_pos;
    unsigned int cons = MINOR(inode->i_rdev);
    int viewed, attr, size, written;
    const char *buf0;
    unsigned long *org;

    attr = (cons & 128);
    cons = (cons & 127);

    if (cons == 0) {
	vt = vtdata.fgconsole;
	viewed = 1;
    } else {
	vt = vt_con_data + (cons - 1);
	viewed = 0;
    }

    if (!vt_allocated (vt))
	return -ENXIO;

    size = vcs_size(inode);

    if (count < 0 || p > size)
	return -EINVAL;

    if (count > size - p)
	count = size - p;

    buf0 = buf;
    if (!attr) {
	org = screen_pos (vt, p);
	while (count-- > 0) {
	    *org = (*org & 0xffffff00) | get_user (buf++);
	    org++;
	}
    } else {
	if (p < HEADER_SIZE) {
	    char header[HEADER_SIZE];
	    getconsxy (vt, header+2);

	    while (p < HEADER_SIZE && count-- > 0)
		header[p++] = get_user (buf++);
	    if (!viewed)
		putconsxy (vt, header + 2);
	}
	p -= HEADER_SIZE;
	org = screen_pos (vt, p >> 2);

	if (p & 3) {
	    unsigned long d = *org;

	    switch (p & 3) {
	    case 1:
		if (count-- > 0)
	    	    d = (d & 0xffff00ff) | (get_user (buf++) << 8);
	    case 2:
		if (count-- > 0)
	    	    d = (d & 0xff00ffff) | (get_user (buf++) << 16);
	    case 3:
		if (count-- > 0)
	    	    d = (d & 0x00ffffff) | (get_user (buf++) << 24);
	    }
	    *org ++ = d;
	}

	while (count > 3) {
	    *org ++ = get_user ((const unsigned long *)buf);
	    buf += 4;
	    count -= 4;
	}

	if (count > 0) {
	    unsigned long d;

	    d = (*org >> (count * 8)) << (count * 8);
	    d |= get_user (buf ++);

	    if (count > 1)
		d |= get_user (buf ++) << 8;

	    if (count > 2)
		d |= get_user (buf ++) << 16;
	    *org = d;
	}
    }
    written = buf - buf0;
    update_scrmem (vt, file->f_pos >> 2, (written + 3) >> 2);
    file->f_pos += written;
    return written;
}

static int vcs_open (struct inode *inode, struct file *filp)
{
    unsigned int cons = (MINOR(inode->i_rdev) & 127);

    if (cons && !vt_allocated (vt_con_data + cons - 1))
	return -ENXIO;
    return 0;
}

static struct file_operations vcs_fops = {
	vcs_lseek,	/* lseek */
	vcs_read,	/* read */
	vcs_write,	/* write */
	NULL,		/* readdir */
	NULL,		/* select */
	NULL,		/* ioctl */
	NULL,		/* mmap */
	vcs_open,	/* open */
	NULL,		/* release */
	NULL		/* fsync */
};

int vcs_init(void)
{
    int error;

    error = register_chrdev(VCS_MAJOR, "vcs", &vcs_fops);
    if (error)
	printk("unable to get major %d for vcs device", VCS_MAJOR);
    return error;
}
