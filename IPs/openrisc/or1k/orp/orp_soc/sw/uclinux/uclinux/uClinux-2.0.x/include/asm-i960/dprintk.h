/*
 *   FILE: dprintk.h
 * AUTHOR: kma
 *  DESCR: 
 */

#ifndef DPRINTK_H
#define DPRINTK_H

#ident "$Id: dprintk.h,v 1.1.1.1 2001/09/10 07:44:41 simons Exp $"

#ifdef DEBUG
#define dprintk(fmt,x...) do { printk(fmt, ## x);  } while(0)
#else
#define dprintk(fmt,x...) do { } while(0)
#endif

#endif
