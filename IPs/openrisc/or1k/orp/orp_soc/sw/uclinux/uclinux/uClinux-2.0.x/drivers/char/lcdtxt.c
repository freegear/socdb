/*****************************************************************************/

/*
 *	lcdtxt.c -- driver for a text based LCD display
 *
 *	(C) Copyright 2000, greg Ungerer (gerg@moreton.com.au)
 */

/*****************************************************************************/

#include <linux/config.h>
#include <linux/types.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/mm.h>
#include <linux/delay.h>
#include <asm/param.h>
#include <asm/coldfire.h>
#include <asm/mcfsim.h>

/*****************************************************************************/

/*
 *	Define driver major number.
 */
#define	LCDTXT_MAJOR	120

/*
 *	Define LCD hardware address.
 */
#define	LCDTXT_ADDR	0x30800000

/*****************************************************************************/

int lcdtxt_open(struct inode *inode, struct file *filp)
{
#if 0
	printk("lcdtxt_open()\n");
#endif

	return(0);
}

/*****************************************************************************/

void lcdtxt_release(struct inode *inode, struct file *filp)
{
#if 0
	printk("lcdtxt_close()\n");
#endif
}

/*****************************************************************************/

int lcdtxt_write(struct inode *inode, struct file *filp, const char *buf, int count)
{
	volatile char	*lcdp;
	char		*dp;
	int		num;

#if 0
	printk("lcdtxt_write(buf=%x,count=%d)\n", (int) buf, count);
#endif

	dp = (char *) buf;
	lcdp = (volatile char *) LCDTXT_ADDR;

	for (num = count; (num >= 0); num--) {
		*lcdp = get_user(dp++);
		udelay(1);
	}

	return(count);
}

/*****************************************************************************/

int lcdtxt_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
{
	int	rc = 0;

#if 0
	switch (cmd) {
	default:
		rc = -EINVAL;
		break;
	}
#endif

	return(rc);
}

/*****************************************************************************/

/*
 *	Exported file operations structure for driver...
 */

struct file_operations	lcdtxt_fops = {
	NULL,		/* lseek */
	NULL,		/* read */
	lcdtxt_write,	/* write */
	NULL,		/* readdir */
	NULL,		/* poll */
	lcdtxt_ioctl,	/* ioctl */
	NULL,		/* mmap */
	lcdtxt_open,	/* open */
	lcdtxt_release,	/* release */
	NULL,		/* fsync */
	NULL,		/* fasync */
	NULL,		/* check_media_change */
	NULL		/* revalidate */
};

/*****************************************************************************/

void lcdtxt_init(void)
{
	int	rc;

	/* Register lcdtxt as character device */
	rc = register_chrdev(LCDTXT_MAJOR, "lcdtxt", &lcdtxt_fops);
	if (rc < 0) {
		printk(KERN_WARNING "LCDTXT: can't get major %d\n",
			LCDTXT_MAJOR);
		return;
	}

	printk("LCDTXT: Copyright (C) 2000, Greg Ungerer "
		"(gerg@moreton.com.au)\n");

#if 0
	/* Setup CS4 for our external hardware */
#ifdef CONFIG_OLDMASK
	*((volatile unsigned short *) (MCF_MBAR + MCFSIM_CSMR4)) = 0x0001;
	*((volatile unsigned short *) (MCF_MBAR + MCFSIM_CSCR4)) = 0x3d40;
#else
	*((volatile unsigned short *) (MCF_MBAR + MCFSIM_CSAR4)) = 0x30c0;
	*((volatile unsigned long *) (MCF_MBAR + MCFSIM_CSMR4)) = 0x000f0001;
	*((volatile unsigned short *) (MCF_MBAR + MCFSIM_CSCR4)) = 0x3d40;
#endif
#endif
}

/*****************************************************************************/
