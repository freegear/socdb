/*
 *  linux/fs/proc/serial.c
 *
 *  Copyright (C) 1999, Greg Ungerer (gerg@moreton.com.au)
 *
 *  Copied and hacked from array.c, which was:
 *
 *  Copyright (C) 1991, 1992 Linus Torvalds
 */

#include <linux/types.h>
#include <linux/errno.h>
#include <linux/sched.h>
#include <linux/kernel.h>
#include <linux/kernel_stat.h>
#include <linux/tty.h>
#include <linux/user.h>
#include <linux/a.out.h>
#include <linux/string.h>
#include <linux/mman.h>
#include <linux/proc_fs.h>
#include <linux/ioport.h>
#include <linux/config.h>
#include <linux/mm.h>
#include <linux/pagemap.h>
#include <linux/swap.h>

#include <asm/segment.h>
#include <asm/pgtable.h>
#include <asm/io.h>

int get_serialinfo(char * buffer)
{
	int len = 0;

#ifdef CONFIG_COLDFIRE_SERIAL
	extern int mcfrs_readproc(char *buffer);
	len = mcfrs_readproc(buffer);
#else
	len += sprintf(buffer, "No Serial Info\n");
#endif

	return(len);
}

