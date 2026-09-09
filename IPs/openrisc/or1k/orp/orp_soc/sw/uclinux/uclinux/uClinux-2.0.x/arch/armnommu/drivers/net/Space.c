/*
 * INET		An implementation of the TCP/IP protocol suite for the LINUX
 *		operating system.  INET is implemented using the  BSD Socket
 *		interface as the means of communication with the user level.
 *
 *		Holds initial configuration information for devices.
 *
 * NOTE:	This file is a nice idea, but its current format does not work
 *		well for drivers that support multiple units, like the SLIP
 *		driver.  We should actually have only one pointer to a driver
 *		here, with the driver knowing how many units it supports.
 *		Currently, the SLIP driver abuses the "base_addr" integer
 *		field of the 'device' structure to store the unit number...
 *		-FvK
 *
 * Version:	@(#)Space.c	1.0.7	08/12/93
 *
 * Authors:	Ross Biro, <bir7@leland.Stanford.Edu>
 *		Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
 *		Donald J. Becker, <becker@super.org>
 *
 *	FIXME:
 *		Sort the device chain fastest first.
 *
 *		This program is free software; you can redistribute it and/or
 *		modify it under the terms of the GNU General Public License
 *		as published by the Free Software Foundation; either version
 *		2 of the License, or (at your option) any later version.
 */
#include <linux/config.h>
#include <linux/netdevice.h>
#include <linux/errno.h>

#define	NEXT_DEV	NULL


/* A unified ethernet device probe.  This is the easiest way to have every
   ethernet adaptor have the name "eth[0123...]".
   */
extern int ether1_probe (struct device *dev);
extern int ether3_probe (struct device *dev);
extern int etherc_probe (struct device *dev);
extern int etherh_probe (struct device *dev);
extern int am79c961_probe (struct device *dev);
extern int cs89x0_probe (struct device *dev);

static int
ethif_probe(struct device *dev)
{
    u_long base_addr = dev->base_addr;

    if ((base_addr == 0xffe0)  ||  (base_addr == 1))
	return 1;		/* ENXIO */

    if (1
#ifdef CONFIG_ETHERH
	&& etherh_probe (dev)
#endif
#ifdef CONFIG_ETHERC
		&& etherc_probe (dev)
#endif
#ifdef CONFIG_TRIO_CS6800
		&& cs89x0_probe (dev)
#endif
#ifdef CONFIG_ETHER3
        && ether3_probe (dev)
#endif
#ifdef CONFIG_ETHER1
	&& ether1_probe (dev)
#endif
#ifdef CONFIG_AM79C961A
	&& am79c961_probe (dev)
#endif
	&& 1 ) {
	return 1;	/* -ENODEV or -EAGAIN would be more accurate. */
    }
    return 0;
}

/* The first device defaults to I/O base '0', which means autoprobe. */
#ifndef ETH0_ADDR
# define ETH0_ADDR 0
#endif
#ifndef ETH0_IRQ
# define ETH0_IRQ 0
#endif
/* The first device defaults to I/O base '0', which means autoprobe. */
#ifndef ETH1_ADDR
# define ETH1_ADDR 0
#endif
#ifndef ETH1_IRQ
# define ETH1_IRQ 0
#endif
/* "eth0" defaults to autoprobe (== 0), other use a base of 0xffe0 (== -0x20),
   which means "don't probe".  These entries exist to only to provide empty
   slots which may be enabled at boot-time. */

static struct device eth3_dev = {
"eth3"		, 0x0, 0x0, 0x0, 0x0, 0xffe0   , 0       , 0, 0, 0, NEXT_DEV  , ethif_probe };

static struct device eth2_dev = {
"eth2"		, 0x0, 0x0, 0x0, 0x0, 0xffe0   , 0       , 0, 0, 0, &eth3_dev , ethif_probe };
	
static struct device eth1_dev = {
"eth1"		, 0x0, 0x0, 0x0, 0x0, ETH1_ADDR, ETH1_IRQ, 0, 0, 0, &eth2_dev , ethif_probe };

static struct device eth0_dev = {
"eth0"		, 0x0, 0x0, 0x0, 0x0, ETH0_ADDR, ETH0_IRQ, 0, 0, 0, &eth1_dev , ethif_probe };

#undef  NEXT_DEV
#define NEXT_DEV (&eth0_dev)

#if defined(PLIP) || defined(CONFIG_PLIP)
extern int plip_init(struct device *);
static struct device plip2_dev = {
"plip2"		, 0x0, 0x0, 0x0, 0x0, 0x278    , 2       , 0, 0, 0, NEXT_DEV  , plip_init };

static struct device plip1_dev = {
"plip1"		, 0x0, 0x0, 0x0, 0x0, 0x378    , 7       , 0, 0, 0, &plip2_dev, plip_init };

static struct device plip0_dev = {
"plip0"		, 0x0, 0x0, 0x0, 0x0, 0x3BC    , 5       , 0, 0, 0, &plip1_dev, plip_init };

#undef  NEXT_DEV
#define NEXT_DEV (&plip0_dev)
#endif  /* PLIP */

#if defined(SLIP) || defined(CONFIG_SLIP)
	/* To be exact, this node just hooks the initialization
	   routines to the device structures.			*/
extern int slip_init_ctrl_dev(struct device *);

static struct device slip_bootstrap = {
"slip_proto"	, 0x0, 0x0, 0x0, 0x0, 0        , 0       , 0, 0, 0, NEXT_DEV  , slip_init_ctrl_dev };

#undef  NEXT_DEV
#define NEXT_DEV (&slip_bootstrap)
#endif /* SLIP */
  
#if defined(CONFIG_PPP)
extern int ppp_init(struct device *);

static struct device ppp_bootstrap = {
"ppp_proto"	, 0x0, 0x0, 0x0, 0x0, 0        , 0       , 0, 0, 0, NEXT_DEV  , ppp_init };

#undef  NEXT_DEV
#define NEXT_DEV (&ppp_bootstrap)
#endif   /* PPP */

#ifdef CONFIG_DUMMY
extern int dummy_init(struct device *dev);

static struct device dummy_dev = {
"dummy"		, 0x0, 0x0, 0x0, 0x0, 0        , 0       , 0, 0, 0, NEXT_DEV  , dummy_init };
	
#undef	NEXT_DEV
#define	NEXT_DEV	(&dummy_dev)
#endif

#ifdef CONFIG_EQUALIZER
extern int eql_init(struct device *dev);

static struct device eql_dev = {
"eql"		, 0x0, 0x0, 0x0, 0x0, 0        , 0       , 0, 0, 0, NEXT_DEV  , eql_init };

#undef  NEXT_DEV
#define NEXT_DEV (&eql_dev)
#endif

#ifdef CONFIG_NET_IPIP
#ifdef CONFIG_IP_FORWARD
extern int tunnel_init (struct device *dev);

static struct device tunnel_dev1 = {
"tunl1"		, 0x0, 0x0, 0x0, 0x0, 0        , 0       , 0, 0, 0, NEXT_DEV  , tunnel_init };

static struct device tunnel_dev0 = {
"tunl0"		, 0x0, 0x0, 0x0, 0x0, 0        , 0       , 0, 0, 0, &tunnel_dev1, tunnel_init };

#undef  NEXT_DEV
#define NEXT_DEV (&tunnel_dev0)
#endif
#endif

extern int loopback_init(struct device *dev);
struct device loopback_dev = {
"lo"		, 0x0, 0x0, 0x0, 0x0, 0        , 0       , 0, 0, 0, NEXT_DEV  ,	loopback_init };

struct device *dev_base = &loopback_dev;
