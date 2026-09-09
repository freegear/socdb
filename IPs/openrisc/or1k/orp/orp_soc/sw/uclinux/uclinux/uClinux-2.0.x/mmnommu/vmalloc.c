/*
 *  linux/mm/vmalloc.c
 *
 *  Copyright (C) 1993  Linus Torvalds
 */

/*
 * uClinux revisions for NO_MM
 * Copyright (C) 1998  Kenneth Albanowski <kjahds@kjahds.com>,
 *                     The Silver Hammer Group, Ltd.
 * Copyright (C) 1999  D. Jeff Dionne <jeff@uclinux.org>,
 *                     Rt-Control, Inc.
 */  

#include <asm/system.h>

#include <linux/signal.h>
#include <linux/sched.h>
#include <linux/head.h>
#include <linux/kernel.h>
#include <linux/errno.h>
#include <linux/types.h>
#include <linux/malloc.h>
#include <linux/mm.h>

/*
 * These routines just punt in a flat address space
 */

void vfree(void * addr)
{
	kfree(addr);
}

void * vmalloc(unsigned long size)
{
	return kmalloc(size, GFP_KERNEL);
}

/*
 * In a flat address space, there is no translation needed
 */
void * vremap(unsigned long offset, unsigned long size)
{
	return (void*)offset;
}

int vread(char *buf, char *addr, int count)
{
	memcpy_tofs(buf, addr, count);
	return count;
}
