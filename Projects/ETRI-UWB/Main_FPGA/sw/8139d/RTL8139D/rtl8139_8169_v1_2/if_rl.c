/*
 * Copyright (c) 1997, 1998
 *	Bill Paul <wpaul@ctr.columbia.edu>.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by Bill Paul.
 * 4. Neither the name of the author nor the names of any co-contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY Bill Paul AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL Bill Paul OR THE VOICES IN HIS HEAD
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 *
 * $FreeBSD: src/sys/pci/if_rl.c,v 1.38.2.7 2001/07/19 18:33:07 wpaul Exp $
 */

/*
 * RealTek 8129/8139 PCI NIC driver
 *
 * Written by Bill Paul <wpaul@ctr.columbia.edu>
 * Electrical Engineering Department
 * Columbia University, New York City
 */

 /*
 * This driver also support Realtek 8139C+ and 8169(s) PCI NIC.
 * And this portion is written by Yves Hsu in Realtek<yves@realtek.com.tw>
 */

#include <sys/param.h>
#include <sys/systm.h>
#include <sys/sockio.h>
#include <sys/mbuf.h>
#include <sys/malloc.h>
#include <sys/kernel.h>
#include <sys/socket.h>

#include <net/if.h>
#include <net/if_arp.h>
#include <net/ethernet.h>
#include <net/if_dl.h>
#include <net/if_media.h>

#include <net/bpf.h>

#include <vm/vm.h>              /* for vtophys */
#include <vm/pmap.h>            /* for vtophys */
#include <machine/clock.h>      /* for DELAY */
#include <machine/bus_pio.h>
#include <machine/bus_memio.h>
#include <machine/bus.h>
#include <machine/resource.h>
#include <sys/bus.h>
#include <sys/rman.h>

#include <pci/pcireg.h>
#include <pci/pcivar.h>

/*
 * Default to using PIO access for this driver. On SMP systems,
 * there appear to be problems with memory mapped mode: it looks like
 * doing too many memory mapped access back to back in rapid succession
 * can hang the bus. I'm inclined to blame this on crummy design/construction
 * on the part of RealTek. Memory mapped mode does appear to work on
 * uniprocessor systems though.
 */
#define RL_USEIOSPACE

#include <pci/if_rlreg.h>

#ifndef lint
static const char rcsid[] =
  "$FreeBSD: src/sys/pci/if_rl.c,v 1.38.2.7 2001/07/19 18:33:07 wpaul Exp $";
#endif

#define EE_SET(x)					\
	CSR_WRITE_1(sc, RL_EECMD,			\
		CSR_READ_1(sc, RL_EECMD) | x)

#define EE_CLR(x)					\
	CSR_WRITE_1(sc, RL_EECMD,			\
		CSR_READ_1(sc, RL_EECMD) & ~x)

#ifdef RL_USEIOSPACE
#define RL_RES			SYS_RES_IOPORT
#define RL_RID			RL_PCI_LOIO
#else
#define RL_RES			SYS_RES_MEMORY
#define RL_RID			RL_PCI_LOMEM
#endif

/*
 * Various supported device vendors/types and their names.
 */
static struct rl_type rl_devs[] = {
	{ RT_VENDORID, RT_DEVICEID_8129,
		"RealTek 8129 10/100BaseTX" },
	{ RT_VENDORID, RT_DEVICEID_8139,
		"RealTek 8139 family 10/100BaseTX" },
	{ RT_VENDORID, RT_DEVICEID_8169,
		"Realtek RTL8169(s) Gigabit Ethernet Adapter" },		
	{ ACCTON_VENDORID, ACCTON_DEVICEID_5030,
		"Accton MPX 5030/5038 10/100BaseTX" },
	{ DELTA_VENDORID, DELTA_DEVICEID_8139,
		"Delta Electronics 8139 10/100BaseTX" },
	{ ADDTRON_VENDORID, ADDTRON_DEVICEID_8139,
		"Addtron Technolgy 8139 10/100BaseTX" },
	{ DLINK_VENDORID, DLINK_DEVICEID_530TXPLUS,
		"D-Link DFE-530TX+ 10/100BaseTX" },
	{ 0, 0, NULL }
};

static int	rl_probe			__P((device_t));
static int	rl_attach			__P((device_t));
static int	rl_detach			__P((device_t));
static void rl_shutdown			__P((device_t));

static void MP_WritePhyUshort	__P((struct rl_softc*, u_int8_t, u_int16_t));
static u_int16_t MP_ReadPhyUshort	__P((struct rl_softc *,u_int8_t));

static void rl_8169s_init		__P((struct rl_softc *));
static void rl_init				__P((void *));
static int 	rl_var_init			__P((struct rl_softc *));
static void rl_reset			__P((struct rl_softc *));
static void rl_stop				__P((struct rl_softc *));

static void rl_start			__P((struct ifnet *));
static int	rl_encap			__P((struct rl_softc *, struct mbuf * ));
static void WritePacket			__P((struct rl_softc *, caddr_t, int, int, int));
static int CountFreeTxDescNum	__P((struct rl_descriptor));
static int CountMbufNum			__P((struct mbuf *, int *));
static void rl_txeof			__P((struct rl_softc *));

static void	rl_rxeof			__P((struct rl_softc *));

static void rl_intr				__P((void *));
static u_int8_t rl_calchash		__P((caddr_t));
static void rl_setmulti			__P((struct rl_softc *));
static int	rl_ioctl			__P((struct ifnet *, u_long, caddr_t));
static void rl_tick				__P((void *));
static void rl_watchdog			__P((struct ifnet *));

static int	rl_ifmedia_upd		__P((struct ifnet *));
static void rl_ifmedia_sts		__P((struct ifnet *, struct ifmediareq *));

static void rl_eeprom_ShiftOutBits	__P((struct rl_softc *, int, int));
static u_int16_t rl_eeprom_ShiftInBits	__P((struct rl_softc *));
static void rl_eeprom_EEpromCleanup	__P((struct rl_softc *));
static void rl_eeprom_getword	__P((struct rl_softc *, int, u_int16_t *));
static void rl_read_eeprom		__P((struct rl_softc *, caddr_t, int, int, int));

static device_method_t rl_methods[] = {
	/* Device interface */
	DEVMETHOD(device_probe,		rl_probe),
	DEVMETHOD(device_attach,	rl_attach),
	DEVMETHOD(device_detach,	rl_detach),
	DEVMETHOD(device_shutdown,	rl_shutdown),
	{ 0, 0 }
};

static driver_t rl_driver = {
	"rl",
	rl_methods,
	sizeof(struct rl_softc)
};

static devclass_t rl_devclass;

DRIVER_MODULE(if_rl, pci, rl_driver, rl_devclass, 0, 0);


/*
 * Probe for a RealTek 8129/8139 chip. Check the PCI vendor and device
 * IDs against our list and return a device name if we find a match.
 */
static int rl_probe(dev)	/* Search for Realtek NIC chip */
	device_t		dev;
{
	struct rl_type		*t;

	t = rl_devs;

	while(t->rl_name != NULL) {
		if ((pci_get_vendor(dev) == t->rl_vid) &&
		    (pci_get_device(dev) == t->rl_did))     
		{
			device_set_desc(dev, t->rl_name);
			return(0);
		}
		t++;
	}

	return(ENXIO);
}

/*
 * Attach the interface. Allocate softc structures, do ifmedia
 * setup and ethernet/BPF attach.
 */
static int rl_attach(dev)
	device_t		dev;
{
	int			s;
	u_char			eaddr[ETHER_ADDR_LEN];
	u_int32_t		command;
	struct rl_softc		*sc;
	struct ifnet		*ifp;
	u_int16_t		rl_did = 0;
	int			unit, error = 0, rid,i;

	s = splimp();

	sc = device_get_softc(dev);
	unit = device_get_unit(dev);
	bzero(sc, sizeof(struct rl_softc));

	/*
	 * Handle power management nonsense.
	 */

	command = pci_read_config(dev, RL_PCI_CAPID, 4) & 0x000000FF;
	if (command == 0x01) {

		command = pci_read_config(dev, RL_PCI_PWRMGMTCTRL, 4);
		if (command & RL_PSTATE_MASK) {
			u_int32_t		iobase, membase, irq;

			/* Save important PCI config data. */
			iobase = pci_read_config(dev, RL_PCI_LOIO, 4);
			membase = pci_read_config(dev, RL_PCI_LOMEM, 4);
			irq = pci_read_config(dev, RL_PCI_INTLINE, 4);

			/* Reset the power state. */
			printf("rl%d: chip is is in D%d power mode "
			"-- setting to D0\n", unit, command & RL_PSTATE_MASK);
			command &= 0xFFFFFFFC;
			pci_write_config(dev, RL_PCI_PWRMGMTCTRL, command, 4);

			/* Restore PCI config data. */
			pci_write_config(dev, RL_PCI_LOIO, iobase, 4);
			pci_write_config(dev, RL_PCI_LOMEM, membase, 4);
			pci_write_config(dev, RL_PCI_INTLINE, irq, 4);
		}
	}

	/*
	 * Map control/status registers.
	 */
	command = pci_read_config(dev, PCIR_COMMAND, 4);
	command |= (PCIM_CMD_PORTEN|PCIM_CMD_MEMEN|PCIM_CMD_BUSMASTEREN);
	pci_write_config(dev, PCIR_COMMAND, command, 4);
	command = pci_read_config(dev, PCIR_COMMAND, 4);

#ifdef RL_USEIOSPACE
	if (!(command & PCIM_CMD_PORTEN)) {
		printf("rl%d: failed to enable I/O ports!\n", unit);
		error = ENXIO;
		goto fail;
	}
#else
	if (!(command & PCIM_CMD_MEMEN)) {
		printf("rl%d: failed to enable memory mapping!\n", unit);
		error = ENXIO;
		goto fail;
	}
#endif

	rid = RL_RID; 
	sc->rl_res = bus_alloc_resource(dev, RL_RES, &rid,
	    0, ~0, 1, RF_ACTIVE);

	if (sc->rl_res == NULL) {
		printf ("rl%d: couldn't map ports/memory\n", unit);
		error = ENXIO;
		goto fail;
	}

	sc->rl_btag = rman_get_bustag(sc->rl_res);
	sc->rl_bhandle = rman_get_bushandle(sc->rl_res);

	rid = 0;
	sc->rl_irq = bus_alloc_resource(dev, SYS_RES_IRQ, &rid, 0, ~0, 1,
	    RF_SHAREABLE | RF_ACTIVE);

	if (sc->rl_irq == NULL) {
		printf("rl%d: couldn't map interrupt\n", unit);
		bus_release_resource(dev, RL_RES, RL_RID, sc->rl_res);
		error = ENXIO;
		goto fail;
	}

	error = bus_setup_intr(dev, sc->rl_irq, INTR_TYPE_NET,
	    rl_intr, sc, &sc->rl_intrhand);

	if (error) {
		bus_release_resource(dev, SYS_RES_IRQ, 0, sc->rl_irq);
		bus_release_resource(dev, RL_RES, RL_RID, sc->rl_res);
		printf("rl%d: couldn't set up irq\n", unit);
		goto fail;
	}

	callout_handle_init(&sc->rl_stat_ch);

	/* Reset the adapter. */
	rl_reset(sc);

	/*
	 * Get station address from the EEPROM.
	 */
	rl_read_eeprom(sc, (caddr_t)&eaddr, RL_EE_EADDR, 3, 0);

	/*
	 * A RealTek chip was detected. Inform the world.
	 */
	printf("rl%d: Ethernet address: %6D\n", unit, eaddr, ":");

	sc->rl_unit = unit;
	bcopy(eaddr, (char *)&sc->arpcom.ac_enaddr, ETHER_ADDR_LEN);

	/*
	 * Now read the exact device type from the EEPROM to find
	 * out if it's an 8129 or 8139.
	 */
	rl_read_eeprom(sc, (caddr_t)&rl_did, RL_EE_PCI_DID, 1, 0);
	
	if (	rl_did == RT_DEVICEID_8139 			|| rl_did == ACCTON_DEVICEID_5030	||
	    	rl_did == DELTA_DEVICEID_8139 		|| rl_did == ADDTRON_DEVICEID_8139	||
	    	rl_did == DLINK_DEVICEID_530TXPLUS)
		sc->rl_type = RL_8139;
	else if (rl_did == RT_DEVICEID_8129)
		sc->rl_type = RL_8129;
	else if (rl_did == RT_DEVICEID_8169)
		sc->rl_type = RL_8169;
	else 
	{
		printf("rl%d: unknown device ID: %x\n", unit, rl_did);
		bus_teardown_intr(dev, sc->rl_irq, sc->rl_intrhand);
		bus_release_resource(dev, SYS_RES_IRQ, 0, sc->rl_irq);
		bus_release_resource(dev, RL_RES, RL_RID, sc->rl_res);
		error = ENXIO;
		goto fail;
	}

	if(sc->rl_type == RL_8139)	/* Yves: distinct between 8139c & 8139c+ */
	{
		if(pci_read_config(dev,RL_PCI_REVISION_ID,1)==RL_CPlusMode)
		{
			sc->rl_bIsCPlusMode=TRUE;
			DBGPRINT(unit, "Rtl8139C+ detected !");
		}
		else
		{
			sc->rl_bIsCPlusMode=FALSE;
			DBGPRINT(unit, "Rtl8139 detected !");
		}
	}

	if(sc->rl_type==RL_8169)
	{	// Change PCI Latency time
		pci_write_config(dev, RL_PCI_LATENCY_TIMER, 0x40, 1);
	}
	
	if(	(sc->rl_type==RL_8139 && sc->rl_bIsCPlusMode)	|| 
		sc->rl_type==RL_8169								)
	{
		sc->DESCRIPTOR_MODE=1;
		DBGPRINT(unit, "Descriptor mode turn ON !\n");
	}
	else
	{
		DBGPRINT(unit, "Descriptor mode turn OFF !\n");
	}
	
	if(!sc->DESCRIPTOR_MODE)
	{
		sc->rl_cdata.rl_rx_buf = contigmalloc(RL_RXBUFLEN + 1518, M_DEVBUF,
			M_NOWAIT, 0, 0xffffffff, PAGE_SIZE, 0);

		if (sc->rl_cdata.rl_rx_buf == NULL) {
			printf("rl%d: no memory for list buffers!\n", unit);
			bus_teardown_intr(dev, sc->rl_irq, sc->rl_intrhand);
			bus_release_resource(dev, SYS_RES_IRQ, 0, sc->rl_irq);
			bus_release_resource(dev, RL_RES, RL_RID, sc->rl_res);
			error = ENXIO;
			goto fail;
		}

		/* Leave a few bytes before the start of the RX ring buffer. */
		sc->rl_cdata.rl_rx_buf_ptr = sc->rl_cdata.rl_rx_buf;
		sc->rl_cdata.rl_rx_buf += sizeof(u_int64_t);
	}
	else	/* Descriptor Mode */
	{
		sc->rl_desc.rx_desc=contigmalloc(sizeof(union RxDesc)*RL_RX_BUF_NUM, M_DEVBUF,
			M_NOWAIT, 0, 0xffffffff, RL_DESC_ALIGN, 0);
		sc->rl_desc.tx_desc=contigmalloc(sizeof(union TxDesc)*RL_TX_BUF_NUM, M_DEVBUF,
			M_NOWAIT, 0, 0xffffffff, RL_DESC_ALIGN, 0);
		for(i=0;i<RL_RX_BUF_NUM;i++)
		{
			MGETHDR(sc->rl_desc.rx_buf[i], M_DONTWAIT, MT_DATA);
			MCLGET(sc->rl_desc.rx_buf[i], M_DONTWAIT);
		}
	}

	if(sc->rl_type==RL_8169)
	{
		sc->rl_8169_MacVersion=(CSR_READ_4(sc, RL_TXCFG)&0x7c000000)>>25;		/* Get bit 26~30 	*/
		sc->rl_8169_MacVersion|=((CSR_READ_4(sc, RL_TXCFG)&0x00800000)!=0 ? 1:0);	/* Get bit 23 		*/
		DBGPRINT1(sc->rl_unit,"8169 Mac Version %d",sc->rl_8169_MacVersion);

		/* Rtl8169s single chip detected */
		if(sc->rl_8169_MacVersion > 0)
		{
			sc->rl_8169_PhyVersion=(MP_ReadPhyUshort(sc, 0x03)&0x000f);
			DBGPRINT1(sc->rl_unit,"8169 Phy Version %d",sc->rl_8169_PhyVersion);

			if(sc->rl_8169_MacVersion==1)
			{
				CSR_WRITE_1(sc, 0x82, 0x01);
				MP_WritePhyUshort(sc, 0x0b, 0x00);
			}
			
			rl_8169s_init(sc);
		}
	}

	ifp = &sc->arpcom.ac_if;
	ifp->if_softc = sc;
	ifp->if_unit = unit;
	ifp->if_name = "rl";
	ifp->if_mtu = ETHERMTU;
	ifp->if_flags = IFF_BROADCAST | IFF_SIMPLEX | IFF_MULTICAST;
	ifp->if_ioctl = rl_ioctl;
	ifp->if_output = ether_output;
	ifp->if_start = rl_start;
	ifp->if_watchdog = rl_watchdog;
	ifp->if_init = rl_init;
	if(sc->rl_type == RL_8169)
		ifp->if_baudrate = 1000000000;
	else
		ifp->if_baudrate = 100000000;
	ifp->if_snd.ifq_maxlen = IFQ_MAXLEN;

	/*
	 * Call MI attach routine.
	 */
#if OS_VER < VERSION(5,1)
	ether_ifattach(ifp, ETHER_BPF_SUPPORTED);
#else
	ether_ifattach(ifp, eaddr);
#endif
	
	
	/* 
	 * Specify the media types supported by this adapter and register
	 * callbacks to update media and link information
	 */
	ifmedia_init(&sc->media, IFM_IMASK, rl_ifmedia_upd,
		     rl_ifmedia_sts);
	/*if (sc->hw.media_type == em_media_type_fiber) 
	{
		ifmedia_add(&sc->media, IFM_ETHER | IFM_1000_SX | IFM_FDX, 
			    0, NULL);
		ifmedia_add(&sc->media, IFM_ETHER | IFM_1000_SX, 
			    0, NULL);
	} else */
	{
		ifmedia_add(&sc->media, IFM_ETHER | IFM_10_T, 0, NULL);
		ifmedia_add(&sc->media, IFM_ETHER | IFM_10_T | IFM_FDX, 
			    0, NULL);
		ifmedia_add(&sc->media, IFM_ETHER | IFM_100_TX, 
			    0, NULL);
		ifmedia_add(&sc->media, IFM_ETHER | IFM_100_TX | IFM_FDX, 
			    0, NULL);
#if OS_VER < VERSION(5,1)
		ifmedia_add(&sc->media, IFM_ETHER | IFM_1000_TX | IFM_FDX, 
			    0, NULL);
		ifmedia_add(&sc->media, IFM_ETHER | IFM_1000_TX, 0, NULL);
#else
		ifmedia_add(&sc->media, IFM_ETHER | IFM_1000_T | IFM_FDX, 
			    0, NULL);
		ifmedia_add(&sc->media, IFM_ETHER | IFM_1000_T, 0, NULL);
#endif
	}
	ifmedia_add(&sc->media, IFM_ETHER | IFM_AUTO, 0, NULL);
	ifmedia_set(&sc->media, IFM_ETHER | IFM_AUTO);

fail:
	splx(s);
	return(error);
}

static int rl_detach(dev)
	device_t		dev;
{
	struct rl_softc		*sc;
	struct ifnet		*ifp;
	int			s,i;

	s = splimp();

	sc = device_get_softc(dev);
	ifp = &sc->arpcom.ac_if;

	rl_stop(sc);
#if OS_VER < VERSION(5,1)
	ether_ifdetach(ifp, ETHER_BPF_SUPPORTED);
#else
	ether_ifdetach(ifp);
#endif

	bus_generic_detach(dev);

	bus_teardown_intr(dev, sc->rl_irq, sc->rl_intrhand);
	bus_release_resource(dev, SYS_RES_IRQ, 0, sc->rl_irq);
	bus_release_resource(dev, RL_RES, RL_RID, sc->rl_res);
	if(!sc->DESCRIPTOR_MODE)
		contigfree(sc->rl_cdata.rl_rx_buf, RL_RXBUFLEN + 32, M_DEVBUF);
	else
	{
		contigfree(sc->rl_desc.rx_desc, sizeof(union RxDesc)*RL_RX_BUF_NUM, M_DEVBUF);
		contigfree(sc->rl_desc.tx_desc, sizeof(union TxDesc)*RL_TX_BUF_NUM, M_DEVBUF);		
		for(i=0;i<RL_RX_BUF_NUM;i++)
		{
			if(sc->rl_desc.rx_buf[i]!=NULL)
				m_freem(sc->rl_desc.rx_buf[i]);
		}	
	}

	splx(s);

	return(0);
}

/*
 * Stop all chip I/O so that the kernel's probe routines don't
 * get confused by errant DMAs when rebooting.
 */
static void rl_shutdown(dev)	/* Yves: The same with rl_stop(sc) */
	device_t		dev;
{
	struct rl_softc		*sc;

	sc = device_get_softc(dev);

	rl_stop(sc);

	return;
}

static void rl_init(xsc)		/* Yves: Software & Hardware Initialize */
	void			*xsc;
{
	struct rl_softc		*sc = xsc;
	struct ifnet		*ifp = &sc->arpcom.ac_if;
	int			s, i;
	u_int32_t		rxcfg = 0;
	
	s = splimp();

	/*mii = device_get_softc(sc->rl_miibus);*/

	/*
	 * Cancel pending I/O and free all RX/TX buffers.
	 */
	rl_stop(sc);

	/* Init our MAC address */
	for (i = 0; i < ETHER_ADDR_LEN; i++) {
		CSR_WRITE_1(sc, RL_IDR0 + i, sc->arpcom.ac_enaddr[i]);
	}

	/* Init the RX buffer pointer register. */
	if(!sc->DESCRIPTOR_MODE)
		CSR_WRITE_4(sc, RL_RXADDR, vtophys(sc->rl_cdata.rl_rx_buf));

	/* Init descriptors. */
	rl_var_init(sc);


	/*
	 * Enable transmit and receive.
	 */
	CSR_WRITE_1(sc, RL_COMMAND, RL_CMD_TX_ENB|RL_CMD_RX_ENB);
	
	/*
	 * Set the initial TX and RX configuration.
	 */
	CSR_WRITE_4(sc, RL_TXCFG, RL_TXCFG_CONFIG);
	CSR_WRITE_4(sc, RL_RXCFG, RL_RXCFG_CONFIG);

	/* Set the individual bit to receive frames for this host only. */
	rxcfg = CSR_READ_4(sc, RL_RXCFG);
	rxcfg |= RL_RXCFG_RX_INDIV;

	/* If we want promiscuous mode, set the allframes bit. */
	if (ifp->if_flags & IFF_PROMISC) {
		rxcfg |= RL_RXCFG_RX_ALLPHYS;
		CSR_WRITE_4(sc, RL_RXCFG, rxcfg);
	} else {
		rxcfg &= ~RL_RXCFG_RX_ALLPHYS;
		CSR_WRITE_4(sc, RL_RXCFG, rxcfg);
	}

	/*
	 * Set capture broadcast bit to capture broadcast frames.
	 */
	if (ifp->if_flags & IFF_BROADCAST) {
		rxcfg |= RL_RXCFG_RX_BROAD;
		CSR_WRITE_4(sc, RL_RXCFG, rxcfg);
	} else {
		rxcfg &= ~RL_RXCFG_RX_BROAD;
		CSR_WRITE_4(sc, RL_RXCFG, rxcfg);
	}

	/*
	 * Program the multicast filter, if necessary.
	 */
	rl_setmulti(sc);

	/*
	 * Enable interrupts.
	 */
	CSR_WRITE_2(sc, RL_IMR, RL_INTRS);

	/* Set initial TX threshold */
	sc->rl_txthresh = RL_TX_THRESH_INIT;

	/* Start RX/TX process. */
	CSR_WRITE_4(sc, RL_MISSEDPKT, 0);

	/* Enable receiver and transmitter. */
	CSR_WRITE_1(sc, RL_COMMAND, RL_CMD_TX_ENB|RL_CMD_RX_ENB);
	
	if(sc->DESCRIPTOR_MODE)
	{
		/* enable C+ Tx/Rx */
		CSR_WRITE_2(sc, 0xe0, 0x0003|((sc->rl_type==RL_8169 && sc->rl_8169_MacVersion==1) ? 0x4008:0));

		/* set Tx descriptor address */
		CSR_WRITE_4(sc, 0x20, vtophys(sc->rl_desc.tx_desc) );
		CSR_WRITE_4(sc, 0x24, 0);

		/* set Rx descriptor address */
		CSR_WRITE_4(sc, 0xe4, vtophys(sc->rl_desc.rx_desc) );
		CSR_WRITE_4(sc, 0xe8, 0);
	}
	
	if(sc->rl_type==RL_8169)
	{
		CSR_WRITE_1(sc, 0xec, 0x3f);	/* ETTHR */
		CSR_WRITE_2(sc, 0xda, 0x800);	/* RMS */
	}

	CSR_WRITE_1(sc, RL_CFG1, RL_CFG1_DRVLOAD|RL_CFG1_FULLDUPLEX);

	ifp->if_flags |= IFF_RUNNING;
	ifp->if_flags &= ~IFF_OACTIVE;

	(void)splx(s);

	sc->rl_stat_ch = timeout(rl_tick, sc, hz);

	return;
}

/*
 * Initialize the transmit descriptors.
 */
static int rl_var_init(sc)
	struct rl_softc		*sc;
{
	int			i;
	struct rl_chain_data	*cd;
	union RxDesc *rxptr;
	union TxDesc *txptr;
		
	if(!sc->DESCRIPTOR_MODE)
	{
		cd = &sc->rl_cdata;
		for (i = 0; i < RL_TX_LIST_CNT; i++) {
			cd->rl_tx_chain[i] = NULL;
			CSR_WRITE_4(sc,
			    RL_TXADDR0 + (i * sizeof(u_int32_t)), 0x0000000);
		}
		sc->rl_cdata.cur_tx = 0;
		sc->rl_cdata.last_tx = 0;
	}
	else
	{
		sc->rl_desc.rx_cur_index=0;
		sc->rl_desc.rx_last_index=0;
		rxptr=sc->rl_desc.rx_desc;
		for(i=0;i<RL_RX_BUF_NUM;i++)
		{	
			rxptr[i].ul[3]=rxptr[i].ul[2]=rxptr[i].ul[1]=rxptr[i].ul[0]=0;
			rxptr[i].so0.OWN=1;
			if(i==(RL_RX_BUF_NUM-1))
				rxptr[i].so0.EOR=1;
			rxptr[i].so0.Frame_Length=RL_BUF_SIZE;
			rxptr[i].so0.RxBuffL=vtophys(sc->rl_desc.rx_buf[i]->m_data );
		}
	
		sc->rl_desc.tx_cur_index=0;
		sc->rl_desc.tx_last_index=0;
		txptr=sc->rl_desc.tx_desc;
		for(i=0;i<RL_TX_BUF_NUM;i++)
		{
			txptr[i].ul[3]=txptr[i].ul[2]=txptr[i].ul[1]=txptr[i].ul[0]=0;
			if(i==(RL_TX_BUF_NUM-1))
				txptr[i].so1.EOR=1;
			txptr[i].so1.Frame_Length=RL_BUF_SIZE;
		}
	}
	return(0);
}

static void rl_reset(sc)
	struct rl_softc		*sc;
{
	register int		i;

	CSR_WRITE_1(sc, RL_COMMAND, RL_CMD_RESET);

	for (i = 0; i < RL_TIMEOUT; i++) {
		DELAY(10);
		if (!(CSR_READ_1(sc, RL_COMMAND) & RL_CMD_RESET))
			break;
	}
	if (i == RL_TIMEOUT)
		printf("rl%d: reset never completed!\n", sc->rl_unit);

        return;
}

/*
 * Stop the adapter and free any mbufs allocated to the
 * RX and TX lists.
 */
static void rl_stop(sc)		/* Yves: Stop Driver */
	struct rl_softc		*sc;
{
	register int		i;
	struct ifnet		*ifp;

	ifp = &sc->arpcom.ac_if;
	ifp->if_timer = 0;

	untimeout(rl_tick, sc, sc->rl_stat_ch);

	CSR_WRITE_1(sc, RL_COMMAND, 0x00);
	CSR_WRITE_2(sc, RL_IMR, 0x0000);

	/*
	 * Free the TX list buffers.
	 */
	if(!sc->DESCRIPTOR_MODE)
		for (i = 0; i < RL_TX_LIST_CNT; i++) 
		{
			if (sc->rl_cdata.rl_tx_chain[i] != NULL) {
				m_freem(sc->rl_cdata.rl_tx_chain[i]);
				sc->rl_cdata.rl_tx_chain[i] = NULL;
				CSR_WRITE_4(sc, RL_TXADDR0 + i, 0x0000000);
			}
		}
	else
		CSR_WRITE_2(sc, 0xe0, 0x0000);

	ifp->if_flags &= ~(IFF_RUNNING | IFF_OACTIVE);

	return;
}

/*
 * Main transmit routine.
 */
static void rl_start(ifp)	/* Yves: Transmit Packet*/
	struct ifnet		*ifp;
{
	struct rl_softc		*sc;
	struct mbuf		*m_head = NULL;

	sc = ifp->if_softc;				/* Yves: Paste to ifp in function rl_attach(dev) */
	if(!sc->DESCRIPTOR_MODE)
	{
		while(RL_CUR_TXMBUF(sc) == NULL) {		/* Yves: RL_CUR_TXMBUF(x)==>(x->rl_cdata.rl_tx_chain[x->rl_cdata.cur_tx]) */
			IF_DEQUEUE(&ifp->if_snd, m_head);	/* Yves: Remove(get) data from system transmit queue */
			if (m_head == NULL)
				break;

			if (rl_encap(sc, m_head)) {
				IF_PREPEND(&ifp->if_snd, m_head);	/* Yves: Case encap fail */
				ifp->if_flags |= IFF_OACTIVE;
				break;
			}
	
			/*
			 * If there's a BPF listener, bounce a copy of this frame
			 * to him.
			 */
			if (ifp->if_bpf)
#if OS_VER < VERSION(5,1)
				bpf_mtap(ifp, RL_CUR_TXMBUF(sc));
#else
				bpf_mtap(ifp->if_bpf, RL_CUR_TXMBUF(sc));
#endif

			/*
			 * Transmit the frame.
	 		 */
			CSR_WRITE_4(sc, RL_CUR_TXADDR(sc),		/* Yves: CSR_WRITE_4(sc, reg, val) */
			    vtophys(mtod(RL_CUR_TXMBUF(sc), caddr_t)));	/* Yves: RL_CUR_TXMBUF(x)==> (x->rl_cdata.rl_tx_chain[x->rl_cdata.cur_tx]) */
			CSR_WRITE_4(sc, RL_CUR_TXSTAT(sc),		/* Yves: mtod(m, t)==> ((t)((m)->m_data)) */
			    RL_TXTHRESH(sc->rl_txthresh) |
			    RL_CUR_TXMBUF(sc)->m_pkthdr.len);

			RL_INC(sc->rl_cdata.cur_tx);			/* Yves: Move current Tx index */
		}

		/*
		 * We broke out of the loop because all our TX slots are
		 * full. Mark the NIC as busy until it drains some of the
		 * packets from the queue.
		 */
		if (RL_CUR_TXMBUF(sc) != NULL)				/* Tx buffer chain full */
			ifp->if_flags |= IFF_OACTIVE;
	
		/*
		 * Set a timeout in case the chip goes out to lunch.
		 */
		ifp->if_timer = 5;
	}
	else	/* Descriptor Mode (C+ mode)*/
	{
		while(1)
		{
			int fs=1,ls=0,TxLen=0,PktLen,limit;
			struct mbuf *ptr,*ptr1;
			
			IF_DEQUEUE(&ifp->if_snd, m_head);	/* Yves: Remove(get) data from system transmit queue */
			if (m_head == NULL)
				break;
			if(CountMbufNum(m_head,&limit)>CountFreeTxDescNum(sc->rl_desc))	/* No enough descriptor */
			{
				IF_PREPEND(&ifp->if_snd, m_head);	
				ifp->if_flags |= IFF_OACTIVE;
				break;
			}
			if (ifp->if_bpf)			/* If there's a BPF listener, bounce a copy of this frame to him. */
#if OS_VER < VERSION(5,1)
				bpf_mtap(ifp,m_head);
#else			
				bpf_mtap(ifp->if_bpf,m_head);
#endif
			if(limit)				/* At least one mbuf data size small than RL_MINI_DESC_SIZE */
			{
#ifdef _DEBUG_
				ptr=m_head;
				printf("Limit=%d",limit);
				while(ptr!=NULL)
				{
					printf(", len=%d T=%d F=%d",ptr->m_len,ptr->m_type,ptr->m_flags);
					ptr=ptr->m_next;
				}
				printf("\n");
				printf("===== Reach limit ======\n");
#endif
				if (rl_encap(sc, m_head)) 
				{
					IF_PREPEND(&ifp->if_snd, m_head);
					ifp->if_flags |= IFF_OACTIVE;
					break;	
				}
				m_head=sc->rl_desc.tx_buf[sc->rl_desc.tx_cur_index];
				sc->rl_desc.txHead_buf[sc->rl_desc.tx_cur_index]=m_head;
				WritePacket(sc,m_head->m_data,m_head->m_len,1,1);
				continue;
			}
				
			ptr=m_head;
			PktLen=ptr->m_pkthdr.len;
#ifdef _DEBUG_
			printf("PktLen=%d",PktLen);
#endif
			while(ptr!=NULL)
			{
				if(ptr->m_len >0)
				{
					sc->rl_desc.tx_buf[sc->rl_desc.tx_cur_index]=ptr;	/* Save mbuf address for rl_txeof to release mbuf */
#ifdef _DEBUG_
					printf(", len=%d T=%d F=%d",ptr->m_len,ptr->m_type,ptr->m_flags);
#endif
					TxLen+=ptr->m_len;
					if(TxLen>=PktLen)
					{
						ls=1;
						sc->rl_desc.txHead_buf[sc->rl_desc.tx_cur_index]=m_head;
					}
					else
						sc->rl_desc.txHead_buf[sc->rl_desc.tx_cur_index]=NULL;

					ptr1=ptr->m_next;
					WritePacket(sc,ptr->m_data,ptr->m_len,fs,ls);
					ptr=ptr1;
					fs=0;
				}
				else
					ptr=ptr->m_next;
			}
#ifdef _DEBUG_
			printf("\n");
#endif
		}
		ifp->if_timer = 5;	
	}
	return;
}

/*
 * Encapsulate an mbuf chain in a descriptor by coupling the mbuf data
 * pointers to the fragment pointers.
 */
static int rl_encap(sc, m_head)		/* Only used in ~C+ mode */
	struct rl_softc		*sc;
	struct mbuf		*m_head;
{
	struct mbuf		*m_new = NULL;

	MGETHDR(m_new, M_DONTWAIT, MT_DATA);
	if (m_new == NULL) {
		printf("rl%d: no memory for tx list", sc->rl_unit);
		return(1);
	}
	if (m_head->m_pkthdr.len > MHLEN) {
		MCLGET(m_new, M_DONTWAIT);
		if (!(m_new->m_flags & M_EXT)) {
			m_freem(m_new);
			printf("rl%d: no memory for tx list",
					sc->rl_unit);
			return(1);
		}
	}
	m_copydata(m_head, 0, m_head->m_pkthdr.len, mtod(m_new, caddr_t));
	m_new->m_pkthdr.len = m_new->m_len = m_head->m_pkthdr.len;
	m_freem(m_head);
	m_head = m_new;

	/* Pad frames to at least 60 bytes. */
	if (m_head->m_pkthdr.len < RL_MIN_FRAMELEN) {	/* Yves: Case length < 60 bytes */
		/*
		 * Make security concious people happy: zero out the
		 * bytes in the pad area, since we don't know what
		 * this mbuf cluster buffer's previous user might
		 * have left in it.
	 	 */
		bzero(mtod(m_head, char *) + m_head->m_pkthdr.len,
		     RL_MIN_FRAMELEN - m_head->m_pkthdr.len);
		m_head->m_pkthdr.len +=
		    (RL_MIN_FRAMELEN - m_head->m_pkthdr.len);
		m_head->m_len = m_head->m_pkthdr.len;
	}
	if(!sc->DESCRIPTOR_MODE)
		RL_CUR_TXMBUF(sc) = m_head;		/* Yves: Save pointer of buffer to sc */
	else
		sc->rl_desc.tx_buf[sc->rl_desc.tx_cur_index]=m_head;

	return(0);
}

static void WritePacket(struct rl_softc	*sc, caddr_t addr, int len,int fs_flag,int ls_flag)
{
	union TxDesc *txptr;
	txptr=&(sc->rl_desc.tx_desc[sc->rl_desc.tx_cur_index]);

	txptr->ul[0]&=0x40000000;
	txptr->ul[3]=txptr->ul[1]=0;
	
	if(fs_flag)
		txptr->so1.FS=1;
	if(ls_flag)
		txptr->so1.LS=1;
	txptr->so1.Frame_Length=len;
	txptr->so1.TxBuffL=vtophys(addr);
	txptr->so1.OWN=1;
		
	if(ls_flag)
	{
		if(sc->rl_type==RL_8169)
			CSR_WRITE_1(sc, 0x38,0x40);	
		else
			CSR_WRITE_1(sc, 0xd9,0x40);	
	}

	if(sc->rl_desc.tx_cur_index==RL_TX_BUF_NUM-1)	/* Update Tx index */
	{
		sc->rl_desc.tx_cur_index=0;
#ifdef _DEBUG_
		printf(" ==== Desc one time ====\n");
#endif	
	}
	else
		sc->rl_desc.tx_cur_index++;
}

static int CountFreeTxDescNum(struct rl_descriptor desc)
{
	int ret=desc.tx_last_index-desc.tx_cur_index;
	if(ret<=0)
		ret+=RL_TX_BUF_NUM;
	ret--;
	return ret;
}

static int CountMbufNum(struct mbuf *m_head,int *limit)
{
	int ret=0;
	struct mbuf *ptr=m_head;
	
	*limit=0;	/* 0:no limit find, 1:intermediate mbuf data size < RL_MINI_DESC_SIZE byte */
	while(ptr!=NULL)
	{
		if(ptr->m_len >0)
		{
			ret++;
			if(ptr->m_len<RL_MINI_DESC_SIZE && ptr->m_next!=NULL)	/* except last descriptor */
				*limit=1;
		}
		ptr=ptr->m_next;
	}
	return ret;
}

/*
 * A frame was downloaded to the chip. It's safe for us to clean up
 * the list buffers.
 */
static void rl_txeof(sc)	/* Yves : Transmit OK/ERR handler */
	struct rl_softc		*sc;
{
	if(!sc->DESCRIPTOR_MODE)
	{
		struct ifnet		*ifp;
		u_int32_t		txstat;
	
		ifp = &sc->arpcom.ac_if;

		/* Clear the timeout timer. */
		ifp->if_timer = 0;

		/*
		 * Go through our tx list and free mbufs for those
		 * frames that have been uploaded.
		 */
		do {
			txstat = CSR_READ_4(sc, RL_LAST_TXSTAT(sc));
			if (!(txstat & (RL_TXSTAT_TX_OK|
			    RL_TXSTAT_TX_UNDERRUN|RL_TXSTAT_TXABRT)))
				break;

			ifp->if_collisions += (txstat & RL_TXSTAT_COLLCNT) >> 24;	/* Yves: Add collision counter */

			if (RL_LAST_TXMBUF(sc) != NULL) {	/* Yves: Free Buffer */
				m_freem(RL_LAST_TXMBUF(sc));	/* Yves: RL_LAST_TXMBUF(x)==>(x->rl_cdata.rl_tx_chain[x->rl_cdata.last_tx]) */
				RL_LAST_TXMBUF(sc) = NULL;
			}
			if (txstat & RL_TXSTAT_TX_OK)		/* Yves: Case Tx OK */
				ifp->if_opackets++;
			else {					/* Yves: Case Tx ERR */
				int			oldthresh;
				ifp->if_oerrors++;
				if ((txstat & RL_TXSTAT_TXABRT) ||
				    (txstat & RL_TXSTAT_OUTOFWIN))
					CSR_WRITE_4(sc, RL_TXCFG, RL_TXCFG_CONFIG);
				oldthresh = sc->rl_txthresh;
				/* error recovery */
				rl_reset(sc);
				rl_init(sc);
				/*
				 * If there was a transmit underrun,
				 * bump the TX threshold.
				 */
				if (txstat & RL_TXSTAT_TX_UNDERRUN)
					sc->rl_txthresh = oldthresh + 32;
				return;
			}
			RL_INC(sc->rl_cdata.last_tx);
			ifp->if_flags &= ~IFF_OACTIVE;
		} while (sc->rl_cdata.last_tx != sc->rl_cdata.cur_tx);
	}
	else	/* Descriptor Mode */
	{
		union TxDesc *txptr;
		struct ifnet		*ifp;
		
		ifp = &sc->arpcom.ac_if;

		/* Clear the timeout timer. */
		ifp->if_timer = 0;	
		
		txptr=&(sc->rl_desc.tx_desc[sc->rl_desc.tx_last_index]);
		while(txptr->so1.OWN==0 && sc->rl_desc.tx_last_index!=sc->rl_desc.tx_cur_index)
		{
#ifdef _DEBUG_
			printf("**** Tx OK  ****\n");
#endif
			if(sc->rl_desc.txHead_buf[sc->rl_desc.tx_last_index]!=NULL)
			{
				m_freem(sc->rl_desc.txHead_buf[sc->rl_desc.tx_last_index]);	/* Yves: Free Current MBuf in a Mbuf list*/
				sc->rl_desc.txHead_buf[sc->rl_desc.tx_last_index] = NULL;
			}
			sc->rl_desc.tx_buf[sc->rl_desc.tx_last_index] = NULL;

			if(sc->rl_desc.tx_last_index==RL_TX_BUF_NUM-1)
			{
				sc->rl_desc.tx_last_index=0;
				txptr=sc->rl_desc.tx_desc;
			}
			else
			{
				sc->rl_desc.tx_last_index++;
				txptr++;
			}
			ifp->if_opackets++;
			ifp->if_flags &= ~IFF_OACTIVE;		
		}
	}
	return;
}

/*
 * A frame has been uploaded: pass the resulting mbuf chain up to
 * the higher level protocols.
 *
 * You know there's something wrong with a PCI bus-master chip design
 * when you have to use m_devget().
 *
 * The receive operation is badly documented in the datasheet, so I'll
 * attempt to document it here. The driver provides a buffer area and
 * places its base address in the RX buffer start address register.
 * The chip then begins copying frames into the RX buffer. Each frame
 * is preceeded by a 32-bit RX status word which specifies the length
 * of the frame and certain other status bits. Each frame (starting with
 * the status word) is also 32-bit aligned. The frame length is in the
 * first 16 bits of the status word; the lower 15 bits correspond with
 * the 'rx status register' mentioned in the datasheet.
 *
 * Note: to make the Alpha happy, the frame payload needs to be aligned
 * on a 32-bit boundary. To achieve this, we cheat a bit by copying from
 * the ring buffer starting at an address two bytes before the actual
 * data location. We can then shave off the first two bytes using m_adj().
 * The reason we do this is because m_devget() doesn't let us specify an
 * offset into the mbuf storage space, so we have to artificially create
 * one. The ring is allocated in such a way that there are a few unused
 * bytes of space preceecing it so that it will be safe for us to do the
 * 2-byte backstep even if reading from the ring at offset 0.
 */
static void rl_rxeof(sc)	/* Yves : Receive Data OK/ERR handler */
	struct rl_softc		*sc;
{
	if(!sc->DESCRIPTOR_MODE)
	{
	        struct ether_header	*eh;
        	struct mbuf		*m;
	        struct ifnet		*ifp;
		int			total_len = 0;
		u_int32_t		rxstat;
		caddr_t			rxbufpos;
		int			wrap = 0;
		u_int16_t		cur_rx;
		u_int16_t		limit;
		u_int16_t		rx_bytes = 0, max_bytes;

		ifp = &sc->arpcom.ac_if;

		cur_rx = (CSR_READ_2(sc, RL_CURRXADDR) + 16) % RL_RXBUFLEN;

		/* Do not try to read past this point. */
		limit = CSR_READ_2(sc, RL_CURRXBUF) % RL_RXBUFLEN;

		if (limit < cur_rx)
			max_bytes = (RL_RXBUFLEN - cur_rx) + limit;
		else
			max_bytes = limit - cur_rx;

		while((CSR_READ_1(sc, RL_COMMAND) & RL_CMD_EMPTY_RXBUF) == 0) {
			rxbufpos = sc->rl_cdata.rl_rx_buf + cur_rx;
			rxstat = *(u_int32_t *)rxbufpos;

			/*
			 * Here's a totally undocumented fact for you. When the
			 * RealTek chip is in the process of copying a packet into
			 * RAM for you, the length will be 0xfff0. If you spot a
			 * packet header with this value, you need to stop. The
			 * datasheet makes absolutely no mention of this and
			 * RealTek should be shot for this.
			 */
			if ((u_int16_t)(rxstat >> 16) == RL_RXSTAT_UNFINISHED)
				break;
	
			if (!(rxstat & RL_RXSTAT_RXOK)) {
				ifp->if_ierrors++;
				rl_init(sc);
				return;
			}

			/* No errors; receive the packet. */	
			total_len = rxstat >> 16;
			rx_bytes += total_len + 4;

			/*
			 * XXX The RealTek chip includes the CRC with every
			 * received frame, and there's no way to turn this
			 * behavior off (at least, I can't find anything in
		 	 * the manual that explains how to do it) so we have
			 * to trim off the CRC manually.
			 */
			total_len -= ETHER_CRC_LEN;
	
			/*
			 * Avoid trying to read more bytes than we know
			 * the chip has prepared for us.
			 */
			if (rx_bytes > max_bytes)
				break;

			rxbufpos = sc->rl_cdata.rl_rx_buf +
				((cur_rx + sizeof(u_int32_t)) % RL_RXBUFLEN);
	
			if (rxbufpos == (sc->rl_cdata.rl_rx_buf + RL_RXBUFLEN))
				rxbufpos = sc->rl_cdata.rl_rx_buf;
	
			wrap = (sc->rl_cdata.rl_rx_buf + RL_RXBUFLEN) - rxbufpos;

			if (total_len > wrap) {
				/*
				 * Fool m_devget() into thinking we want to copy
				 * the whole buffer so we don't end up fragmenting
				 * the data.
				 */
				m = m_devget(rxbufpos - RL_ETHER_ALIGN,
				    total_len + RL_ETHER_ALIGN, 0, ifp, NULL);
				if (m == NULL) {
					ifp->if_ierrors++;
					printf("rl%d: out of mbufs, tried to "
					    "copy %d bytes\n", sc->rl_unit, wrap);
				} else {
					m_adj(m, RL_ETHER_ALIGN);
					m_copyback(m, wrap, total_len - wrap,
						sc->rl_cdata.rl_rx_buf);
				}
				cur_rx = (total_len - wrap + ETHER_CRC_LEN);
			} else {
				m = m_devget(rxbufpos - RL_ETHER_ALIGN,
				    total_len + RL_ETHER_ALIGN, 0, ifp, NULL);
				if (m == NULL) {
					ifp->if_ierrors++;
					printf("rl%d: out of mbufs, tried to "
					    "copy %d bytes\n", sc->rl_unit, total_len);
				} else
					m_adj(m, RL_ETHER_ALIGN);
				cur_rx += total_len + 4 + ETHER_CRC_LEN;
			}

			/*
			 * Round up to 32-bit boundary.
			 */
			cur_rx = (cur_rx + 3) & ~3;
			CSR_WRITE_2(sc, RL_CURRXADDR, cur_rx - 16);
	
			if (m == NULL)
				continue;
	
			eh = mtod(m, struct ether_header *);
			ifp->if_ipackets++;

#if OS_VER < VERSION(5,1)
			/* Remove header from mbuf and pass it on. */
			m_adj(m, sizeof(struct ether_header));
			ether_input(ifp, eh, m);
#else
			(*ifp->if_input)(ifp, m);
#endif
		}
	}
	else	/* Descriptor Mode */
	{
		struct ether_header	*eh;
		struct mbuf		*m;
		struct ifnet		*ifp;
		union RxDesc *rxptr;
	
		ifp = &sc->arpcom.ac_if;
		rxptr=&(sc->rl_desc.rx_desc[sc->rl_desc.rx_cur_index]);
		while(rxptr->so0.OWN==0)	/* Yves: Receive OK */
		{
			int bError=0;
			struct mbuf *buf;

			// Check if this packet is received correctly
			if(sc->rl_type==RL_8139)
			{	//8139C+
				if(rxptr->ul[0]&0x100000l)	// Check RES bit
					bError=1;
			}
			else	
			{	//8169
				if(rxptr->ul[0]&0x200000l)	// Check RES bit
					bError=1;
			}

			if(!bError)
			{
				MGETHDR(buf, M_DONTWAIT, MT_DATA);	/* Alloc a new mbuf */
				if(buf==NULL)
					bError=1;
			}
			
			if(!bError)
			{
				MCLGET(buf, M_DONTWAIT);	
				{
					if((buf->m_flags & M_EXT) == 0) 
					{
						m_freem(buf);
						bError=1;
					}
				}
			}
			
			if(bError)
			{	/* drop this pkt */
				rxptr->ul[0]&=0x40000000;	/* keep EOR bit */
				rxptr->ul[3]=rxptr->ul[1]=0;
				
				rxptr->so0.Frame_Length=RL_BUF_SIZE;
				rxptr->so0.RxBuffL=vtophys(sc->rl_desc.rx_buf[sc->rl_desc.rx_cur_index]->m_data );
				rxptr->so0.OWN=1;
			
				if(sc->rl_desc.rx_cur_index==RL_RX_BUF_NUM-1)
				{
					sc->rl_desc.rx_cur_index=0;
					rxptr=sc->rl_desc.rx_desc;
				}
				else
				{
					sc->rl_desc.rx_cur_index++;
					rxptr++;
				}
				continue;
			}			
			
			m=sc->rl_desc.rx_buf[sc->rl_desc.rx_cur_index];
			m->m_pkthdr.len=m->m_len=rxptr->so0.Frame_Length- ETHER_CRC_LEN;
			m->m_pkthdr.rcvif=ifp;

			eh = mtod(m, struct ether_header *);
			ifp->if_ipackets++;		
#ifdef _DEBUG_
			printf("Rcv Packet, Len=%d \n",m->m_len);
#endif
#if OS_VER < VERSION(5,1)
			/* Remove header from mbuf and pass it on. */
			m_adj(m, sizeof(struct ether_header));
			ether_input(ifp, eh, m);
#else
			(*ifp->if_input)(ifp, m);
#endif
	
			sc->rl_desc.rx_buf[sc->rl_desc.rx_cur_index]=buf;
		
			rxptr->ul[0]&=0x40000000;	/* keep EOR bit */
			rxptr->ul[3]=rxptr->ul[1]=0;
			
			rxptr->so0.Frame_Length=RL_BUF_SIZE;
			rxptr->so0.RxBuffL=vtophys(sc->rl_desc.rx_buf[sc->rl_desc.rx_cur_index]->m_data );
			rxptr->so0.OWN=1;
		
			if(sc->rl_desc.rx_cur_index==RL_RX_BUF_NUM-1)
			{
				sc->rl_desc.rx_cur_index=0;
				rxptr=sc->rl_desc.rx_desc;
			}
			else
			{
				sc->rl_desc.rx_cur_index++;
				rxptr++;
			}
		}	
	}
	return;
}

static void rl_intr(arg)	/* Yves: Interrupt Handler */
	void			*arg;
{
	struct rl_softc		*sc;
	struct ifnet		*ifp;
	u_int16_t		status;

	sc = arg;
	ifp = &sc->arpcom.ac_if;

	/* Disable interrupts. */
	CSR_WRITE_2(sc, RL_IMR, 0x0000);

	for (;;) {

		status = CSR_READ_2(sc, RL_ISR);
		if (status)
			CSR_WRITE_2(sc, RL_ISR, status);

		if ((status & RL_INTRS) == 0)
			break;

		if (status & RL_ISR_RX_OK)
			rl_rxeof(sc);

		if (status & RL_ISR_RX_ERR)
			rl_rxeof(sc);

		if ((status & RL_ISR_TX_OK) || (status & RL_ISR_TX_ERR))
			rl_txeof(sc);

		if (status & RL_ISR_SYSTEM_ERR) {
			rl_reset(sc);
			rl_init(sc);
		}

	}

	/* Re-enable interrupts. */
	CSR_WRITE_2(sc, RL_IMR, RL_INTRS);

	if (ifp->if_snd.ifq_head != NULL)		/* Yves : Data in Tx buffer waiting for transimission */
		rl_start(ifp);

	return;
}

/*
 * Calculate CRC of a multicast group address, return the upper 6 bits.
 */
static u_int8_t rl_calchash(addr)
	caddr_t			addr;
{
	u_int32_t		crc, carry;
	int			i, j;
	u_int8_t		c;

	/* Compute CRC for the address value. */
	crc = 0xFFFFFFFF; /* initial value */

	for (i = 0; i < 6; i++) {
		c = *(addr + i);
		for (j = 0; j < 8; j++) {
			carry = ((crc & 0x80000000) ? 1 : 0) ^ (c & 0x01);
			crc <<= 1;
			c >>= 1;
			if (carry)
				crc = (crc ^ 0x04c11db6) | carry;
		}
	}

	/* return the filter bit position */
	return(crc >> 26);
}

/*
 * Program the 64-bit multicast hash filter.
 */
static void rl_setmulti(sc)
	struct rl_softc		*sc;
{
	struct ifnet		*ifp;
	int			h = 0;
	u_int32_t		hashes[2] = { 0, 0 };
	struct ifmultiaddr	*ifma;
	u_int32_t		rxfilt;
	int			mcnt = 0;

	ifp = &sc->arpcom.ac_if;

	rxfilt = CSR_READ_4(sc, RL_RXCFG);

	if (ifp->if_flags & IFF_ALLMULTI || ifp->if_flags & IFF_PROMISC) {
		rxfilt |= RL_RXCFG_RX_MULTI;
		CSR_WRITE_4(sc, RL_RXCFG, rxfilt);
		CSR_WRITE_4(sc, RL_MAR0, 0xFFFFFFFF);
		CSR_WRITE_4(sc, RL_MAR4, 0xFFFFFFFF);
		return;
	}

	/* first, zot all the existing hash bits */
	CSR_WRITE_4(sc, RL_MAR0, 0);
	CSR_WRITE_4(sc, RL_MAR4, 0);

	/* now program new ones */
#if OS_VER < VERSION(5,1)
	for (ifma = ifp->if_multiaddrs.lh_first; ifma != NULL;
				ifma = ifma->ifma_link.le_next)
#else
	TAILQ_FOREACH(ifma,&ifp->if_multiaddrs,ifma_link)
#endif
	{
		if (ifma->ifma_addr->sa_family != AF_LINK)
			continue;
		h = rl_calchash(LLADDR((struct sockaddr_dl *)ifma->ifma_addr));
		if (h < 32)
			hashes[0] |= (1 << h);
		else
			hashes[1] |= (1 << (h - 32));
		mcnt++;
	}

	if (mcnt)
		rxfilt |= RL_RXCFG_RX_MULTI;
	else
		rxfilt &= ~RL_RXCFG_RX_MULTI;

	CSR_WRITE_4(sc, RL_RXCFG, rxfilt);
	CSR_WRITE_4(sc, RL_MAR0, hashes[0]);
	CSR_WRITE_4(sc, RL_MAR4, hashes[1]);

	return;
}

static int rl_ioctl(ifp, command, data)
	struct ifnet		*ifp;
	u_long			command;
	caddr_t			data;
{
	struct rl_softc		*sc = ifp->if_softc;
	struct ifreq		*ifr = (struct ifreq *) data;
	int			s, error = 0;

	s = splimp();

	switch(command) {
	case SIOCSIFADDR:
	case SIOCGIFADDR:
	case SIOCSIFMTU:
		error = ether_ioctl(ifp, command, data);
		break;
	case SIOCSIFFLAGS:
		if (ifp->if_flags & IFF_UP) {
			rl_init(sc);
		} else {
			if (ifp->if_flags & IFF_RUNNING)
				rl_stop(sc);
		}
		error = 0;
		break;
	case SIOCADDMULTI:
	case SIOCDELMULTI:
		rl_setmulti(sc);
		error = 0;
		break;
	case SIOCGIFMEDIA:
	case SIOCSIFMEDIA:
		error = ifmedia_ioctl(ifp, ifr, &sc->media, command);
		break;
	default:
		error = EINVAL;
		break;
	}

	(void)splx(s);

	return(error);
}

static void rl_tick(xsc)
	void			*xsc;
{	// called per second
	struct rl_softc		*sc;
	int			s;

	s = splimp();

	sc = xsc;
	/*mii = device_get_softc(sc->rl_miibus);

	mii_tick(mii);*/

	splx(s);

	if(sc->rl_type==RL_8169 && sc->rl_8169_MacVersion!=0 && sc->rl_8169_PhyVersion==0)
	{
		static int count=0;

		if(CSR_READ_1(sc, 0x6C)&0x02)
			count=0;
		else
			count++;
		if(count> 14)
		{
			MP_WritePhyUshort(sc,0,0x9000);
			count=0;
		}
	}

	sc->rl_stat_ch = timeout(rl_tick, sc, hz);

	return;
}

static void rl_watchdog(ifp)
	struct ifnet		*ifp;
{
	struct rl_softc		*sc;

	sc = ifp->if_softc;

	printf("rl%d: watchdog timeout\n", sc->rl_unit);
	ifp->if_oerrors++;

	rl_txeof(sc);
	rl_rxeof(sc);
	rl_init(sc);

	return;
}

/*
 * Set media options.
 */
static int rl_ifmedia_upd(ifp)
	struct ifnet		*ifp;
{
	/*struct rl_softc		*sc;
	struct mii_data		*mii;

	sc = ifp->if_softc;
	mii = device_get_softc(sc->rl_miibus);
	mii_mediachg(mii);*/

	return(0);
}

/*
 * Report current media status.
 */
static void rl_ifmedia_sts(ifp, ifmr)
	struct ifnet		*ifp;
	struct ifmediareq	*ifmr;
{
	struct rl_softc		*sc;
	
	sc = ifp->if_softc;
	
	ifmr->ifm_status = IFM_AVALID;
	ifmr->ifm_active = IFM_ETHER;
	if(sc->rl_type==RL_8139)
	{
		unsigned char msr;
		unsigned short lpar;

		msr=CSR_READ_1(sc,0x58);
		lpar=CSR_READ_2(sc,0x68);
		
		if((msr&0x04)==0)
			ifmr->ifm_status|= IFM_ACTIVE;
		else 
			return;
			
		if(lpar!=0)	/* support NWAY */
		{
			if(lpar&0x100)
				ifmr->ifm_active|= IFM_100_TX|IFM_FDX;
			else if(lpar&0x80)
				ifmr->ifm_active|= IFM_100_TX|IFM_HDX;
			else if(lpar&0x40)
				ifmr->ifm_active|= IFM_10_T|IFM_FDX;
			else if(lpar&0x20)
				ifmr->ifm_active|= IFM_10_T|IFM_HDX;
		}
		else
		{
			ifmr->ifm_active|= IFM_HDX;
			if(msr&0x08)
				ifmr->ifm_active|= IFM_10_T;
			else
				ifmr->ifm_active|= IFM_100_TX;
		}
	}
	else if(sc->rl_type==RL_8169)
	{
		unsigned char msr;
		msr=CSR_READ_1(sc,0x6c);
		
		if(msr&0x02)
			ifmr->ifm_status|= IFM_ACTIVE;
		else 
			return;
		
		if(msr&0x01)
			ifmr->ifm_active|= IFM_FDX;
		else
			ifmr->ifm_active|= IFM_HDX;
			
			
		if(msr&0x04)
			ifmr->ifm_active|= IFM_10_T;
		else if(msr&0x08)
			ifmr->ifm_active|= IFM_100_TX;
		else if(msr&0x10)
#if OS_VER < VERSION(5,1)
			ifmr->ifm_active|= IFM_1000_TX;
#else
			ifmr->ifm_active|= IFM_1000_T;
#endif
	}
	return;
}

static void rl_8169s_init(sc)
	struct rl_softc		*sc;
{
	u_int16_t TmpUshort;
	
	if(sc->rl_8169_PhyVersion==0 || sc->rl_8169_PhyVersion==1)
	{
		MP_WritePhyUshort(sc, 0x1f, 0x0001);
		MP_WritePhyUshort(sc, 0x15, 0x1000);
		MP_WritePhyUshort(sc, 0x18, 0x65c7);
		TmpUshort = MP_ReadPhyUshort(sc, 0x4);
		TmpUshort &= 0xf7ff;	//w 4 11 11 0
		MP_WritePhyUshort(sc, 0x4, TmpUshort);
		TmpUshort = MP_ReadPhyUshort(sc, 0x4);
		TmpUshort &= 0x0fff;	//w 4 15 12 0
		MP_WritePhyUshort(sc, 0x4, TmpUshort);
		MP_WritePhyUshort(sc, 0x3, 0x00a1);
		MP_WritePhyUshort(sc, 0x2, 0x0008);
		MP_WritePhyUshort(sc, 0x1, 0x1020);
		MP_WritePhyUshort(sc, 0x0, 0x1000);
		TmpUshort = MP_ReadPhyUshort(sc, 0x4);
		TmpUshort |= 0x0800;	//w 4 11 11 1
		MP_WritePhyUshort(sc, 0x4, TmpUshort);
		TmpUshort = MP_ReadPhyUshort(sc, 0x4);
		TmpUshort &= 0xf7ff;	//w 4 11 11 0
		MP_WritePhyUshort(sc, 0x4, TmpUshort);
		TmpUshort = MP_ReadPhyUshort(sc, 0x4);
		TmpUshort &= 0x0fff;	//w 4 15 12 7
		TmpUshort |= 0x7000;	
		MP_WritePhyUshort(sc, 0x4, TmpUshort);
		MP_WritePhyUshort(sc, 0x3, 0xff41);
		MP_WritePhyUshort(sc, 0x2, 0xde60);
		MP_WritePhyUshort(sc, 0x1, 0x0140);
		MP_WritePhyUshort(sc, 0x0, 0x0077);
		TmpUshort = MP_ReadPhyUshort(sc, 0x4);
		TmpUshort |= 0x0800;	//w 4 11 11 1
		MP_WritePhyUshort(sc, 0x4, TmpUshort);
		TmpUshort = MP_ReadPhyUshort(sc, 0x4);
		TmpUshort &= 0xf7ff;	//w 4 11 11 0
		MP_WritePhyUshort(sc, 0x4, TmpUshort);
		TmpUshort = MP_ReadPhyUshort(sc, 0x4);
		TmpUshort &= 0x0fff;	//w 4 15 12 a
		TmpUshort |= 0xa000;	
		MP_WritePhyUshort(sc, 0x4, TmpUshort);
		MP_WritePhyUshort(sc, 0x3, 0xdf01);
		MP_WritePhyUshort(sc, 0x2, 0xdf20);
		MP_WritePhyUshort(sc, 0x1, 0xff95);
		MP_WritePhyUshort(sc, 0x0, 0xfa00);
		TmpUshort = MP_ReadPhyUshort(sc, 0x4);
		TmpUshort |= 0x0800;	//w 4 11 11 1
		MP_WritePhyUshort(sc, 0x4, TmpUshort);
		TmpUshort = MP_ReadPhyUshort(sc, 0x4);
		TmpUshort &= 0xf7ff;	//w 4 11 11 0
		MP_WritePhyUshort(sc, 0x4, TmpUshort);
		TmpUshort = MP_ReadPhyUshort(sc, 0x4);
		TmpUshort &= 0x0fff;	//w 4 15 12 b
		TmpUshort |= 0xb000;	
		MP_WritePhyUshort(sc, 0x4, TmpUshort);
		MP_WritePhyUshort(sc, 0x3, 0xff41);
		MP_WritePhyUshort(sc, 0x2, 0xde20);
		MP_WritePhyUshort(sc, 0x1, 0x0140);
		MP_WritePhyUshort(sc, 0x0, 0x00bb);
		TmpUshort = MP_ReadPhyUshort(sc, 0x4);
		TmpUshort |= 0x0800;	//w 4 11 11 1
		MP_WritePhyUshort(sc, 0x4, TmpUshort);
		TmpUshort = MP_ReadPhyUshort(sc, 0x4);
		TmpUshort &= 0xf7ff;	//w 4 11 11 0
		MP_WritePhyUshort(sc, 0x4, TmpUshort);
		TmpUshort = MP_ReadPhyUshort(sc, 0x4);
		TmpUshort &= 0x0fff;	//w 4 15 12 f
		TmpUshort |= 0xf000;	
		MP_WritePhyUshort(sc, 0x4, TmpUshort);
		MP_WritePhyUshort(sc, 0x3, 0xdf01);
		MP_WritePhyUshort(sc, 0x2, 0xdf20);
		MP_WritePhyUshort(sc, 0x1, 0xff95);
		MP_WritePhyUshort(sc, 0x0, 0xbf00);
		TmpUshort = MP_ReadPhyUshort(sc, 0x4);
		TmpUshort |= 0x0800;	//w 4 11 11 1
		MP_WritePhyUshort(sc, 0x4, TmpUshort);
		TmpUshort = MP_ReadPhyUshort(sc, 0x4);
		TmpUshort &= 0xf7ff;	//w 4 11 11 0
		MP_WritePhyUshort(sc, 0x4, TmpUshort);
		MP_WritePhyUshort(sc, 0x1f, 0x0000);
	}

	// Step1: Write our capability
	MP_WritePhyUshort(sc,0x04,0x01e1); // 10/100 capability
	MP_WritePhyUshort(sc,0x09,0x0200); // 1000 capability

	// Step2: Restart NWay
	MP_WritePhyUshort(sc,0x00,0x1200); // NWay enable and Restart NWay
	
}

void
MP_WritePhyUshort(sc,RegAddr,RegData)
	struct rl_softc		*sc;
	u_int8_t				RegAddr;
	u_int16_t				RegData;
{
	u_int32_t		TmpUlong=0x80000000;
	u_int32_t		Timeout=0;

	TmpUlong |= ( ((u_int32_t)RegAddr<<16) | (u_int32_t)RegData );

	CSR_WRITE_4(sc, PHYAR, TmpUlong ); 

	// Wait for writing to Phy ok 
	do {
		Timeout++;
		DELAY( 20 );
		TmpUlong=CSR_READ_4(sc, PHYAR);
	} while ( (TmpUlong & PHYAR_Flag) && (Timeout<100000) );

}

u_int16_t
MP_ReadPhyUshort(sc,RegAddr)
	struct rl_softc		*sc;
	u_int8_t				RegAddr;
{
	u_int16_t		RegData;
	u_int32_t		TmpUlong=0x00000000;
	u_int32_t		Timeout=0;

	TmpUlong |= ( (u_int32_t)RegAddr << 16);
	CSR_WRITE_4(sc, PHYAR, TmpUlong ); 

	// Wait for reading from Phy ok 
	do {
		Timeout++;
		DELAY( 20 );
		TmpUlong=CSR_READ_4(sc, PHYAR);
	} while ( (!(TmpUlong & PHYAR_Flag)) && (Timeout<100000) );

	TmpUlong=CSR_READ_4(sc, PHYAR);
	RegData = (u_int16_t)(TmpUlong & 0x0000ffff);

	return RegData;
}


//------------------------------------------------------------------------------
//	8139 (CR9346) 9346 command register bits (offset 0x50, 1 byte)
//------------------------------------------------------------------------------
#define CR9346_EEDO				0x01			// 9346 data out
#define CR9346_EEDI				0x02			// 9346 data in
#define CR9346_EESK				0x04			// 9346 serial clock
#define CR9346_EECS				0x08			// 9346 chip select
#define CR9346_EEM0				0x40			// select 8139 operating mode
#define CR9346_EEM1				0x80			// 00: normal
#define CR9346_CFGRW			0xC0			// Config register write
#define CR9346_NORM			0x00			//                                         

//------------------------------------------------------------------------------
//	EEPROM bit definitions(EEPROM control register bits)
//------------------------------------------------------------------------------
#define EN_TRNF					0x10			// Enable turnoff
#define EEDO						CR9346_EEDO	// EEPROM data out
#define EEDI						CR9346_EEDI		// EEPROM data in (set for writing data)
#define EECS						CR9346_EECS		// EEPROM chip select (1=high, 0=low)
#define EESK						CR9346_EESK		// EEPROM shift clock (1=high, 0=low)

//------------------------------------------------------------------------------
//	EEPROM opcodes
//------------------------------------------------------------------------------
#define EEPROM_READ_OPCODE	06
#define EEPROM_WRITE_OPCODE	05
#define EEPROM_ERASE_OPCODE	07
#define EEPROM_EWEN_OPCODE	19				// Erase/write enable
#define EEPROM_EWDS_OPCODE	16				// Erase/write disable

#define	CLOCK_RATE				50				// us

#define RaiseClock(_sc,_x)				\
	(_x) = (_x) | EESK;					\
	CSR_WRITE_1((_sc), RL_EECMD, (_x));	\
	DELAY(CLOCK_RATE);

#define LowerClock(_sc,_x)				\
	(_x) = (_x) & ~EESK;					\
	CSR_WRITE_1((_sc), RL_EECMD, (_x));	\
	DELAY(CLOCK_RATE);

/*
 * Shift out bit(s) to the EEPROM.
 */
static void rl_eeprom_ShiftOutBits(sc, data, count)
	struct rl_softc		*sc;
	int			data;
	int 			count;
{
	u_int16_t x,mask;

	mask = 0x01 << (count - 1);
	x = CSR_READ_1(sc, RL_EECMD);

	x &= ~(EEDO | EEDI);

	do
	{
		x &= ~EEDI;
		if(data & mask)
			x |= EEDI;

		CSR_WRITE_1(sc, RL_EECMD, x);
		DELAY(CLOCK_RATE);
		RaiseClock(sc,x);
		LowerClock(sc,x);
		mask = mask >> 1;
	} while(mask);

	x &= ~EEDI;
	CSR_WRITE_1(sc, RL_EECMD, x);
}

/*
 * Shift in bit(s) from the EEPROM.
 */
static u_int16_t rl_eeprom_ShiftInBits(sc)
	struct rl_softc		*sc;
{
	u_int16_t x,d,i;
	x = CSR_READ_1(sc, RL_EECMD);

	x &= ~( EEDO | EEDI);
	d = 0;

	for(i=0; i<16; i++)
	{
		d = d << 1;
		RaiseClock(sc, x);

		x = CSR_READ_1(sc, RL_EECMD);

		x &= ~(EEDI);
		if(x & EEDO)
			d |= 1;

		LowerClock(sc, x);
	}

	return d;
}

/*
 * Clean up EEprom read/write setting
 */
static void rl_eeprom_EEpromCleanup(sc)
	struct rl_softc		*sc;
{
	u_int16_t x;
	x = CSR_READ_1(sc, RL_EECMD);

	x &= ~(EECS | EEDI);
	CSR_WRITE_1(sc, RL_EECMD, x);

	RaiseClock(sc, x);
	LowerClock(sc, x);
}

/*
 * Read a word of data stored in the EEPROM at address 'addr.'
 */
static void rl_eeprom_getword(sc, addr, dest)
	struct rl_softc		*sc;
	int			addr;
	u_int16_t		*dest;
{
	u_int16_t x;

	// select EEPROM, reset bits, set EECS
	x = CSR_READ_1(sc, RL_EECMD);

	x &= ~(EEDI | EEDO | EESK | CR9346_EEM0);
	x |= CR9346_EEM1 | EECS;
	CSR_WRITE_1(sc, RL_EECMD, x);

	// write the read opcode and register number in that order
	// The opcode is 3bits in length, reg is 6 bits long
	rl_eeprom_ShiftOutBits(sc, EEPROM_READ_OPCODE, 3);
	rl_eeprom_ShiftOutBits(sc, addr,6);	// 93c46 =6,93c56=8

	// Now read the data (16 bits) in from the selected EEPROM word
	*dest=rl_eeprom_ShiftInBits(sc);
	
	rl_eeprom_EEpromCleanup(sc);
	return;
}

/*
 * Read a sequence of words from the EEPROM.
 */
static void rl_read_eeprom(sc, dest, off, cnt, swap)
	struct rl_softc		*sc;
	caddr_t			dest;
	int			off;
	int			cnt;
	int			swap;
{
	int			i;
	u_int16_t		word = 0, *ptr;

	for (i = 0; i < cnt; i++) 
	{
		rl_eeprom_getword(sc, off + i, &word);
		ptr = (u_int16_t *)(dest + (i * 2));
		if (swap)
			*ptr = ntohs(word);
		else
			*ptr = word;
	}

	return;
}
