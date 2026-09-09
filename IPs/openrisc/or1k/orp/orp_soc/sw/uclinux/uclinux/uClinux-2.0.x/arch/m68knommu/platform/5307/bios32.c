/*****************************************************************************/

/*
 *	bios32.c -- PCI access code for embedded CO-MEM Lite PCI controller.
 *
 *	(C) Copyright 1999-2000, Greg Ungerer (gerg@moreton.com.au).
 */

/*****************************************************************************/

#include <linux/config.h>
#include <linux/kernel.h>
#include <linux/types.h>
#include <linux/tasks.h>
#include <linux/bios32.h>
#include <linux/pci.h>
#include <linux/ptrace.h>
#include <linux/interrupt.h>
#include <linux/sched.h>
#include <asm/coldfire.h>
#include <asm/mcfsim.h>
#include <asm/elia.h>
#include <asm/irq.h>
#include <asm/anchor.h>

/*****************************************************************************/
#ifdef CONFIG_PCI
/*****************************************************************************/

/*
 *	PCI markers for bus present and active slots.
 */
int		pci_bus_is_present = 0;
unsigned long	pci_slotmask = 0;

/*
 *	Resource tracking. The CO-MEM part creates a virtual address
 *	space that all the PCI devices live in - it is not in any way
 *	directly mapped into the ColdFire address space. So we can
 *	really assign any resources we like to devices, as long as
 *	they do not clash with other PCI devices.
 */
unsigned int	pci_iobase = 0x100;		/* Arbitary start address */
unsigned int	pci_membase = 0x00010000;	/* Arbitary start address */

#define	PCI_MINIO	0x100			/* 256 byte minimum I/O */
#define	PCI_MINMEM	0x00010000		/* 64k minimum chunk */

/*****************************************************************************/

void 		pci_interrupt(int irq, void *id, struct pt_regs *fp);
extern int	mcf_autovector(int irq);

/*****************************************************************************/

void pci_resetbus(void)
{
	int	i;

#if 1
	printk("pci_resetbus()\n");
#endif

	*((volatile unsigned short *) (MCF_MBAR + MCFSIM_PADDR)) |= eLIA_PCIRESET;
	for (i = 0; (i < 1000); i++) {
		*((volatile unsigned short *) (MCF_MBAR + MCFSIM_PADAT)) = 
			(ppdata | eLIA_PCIRESET);
	}


	*((volatile unsigned short *) (MCF_MBAR + MCFSIM_PADAT)) = ppdata;
}

/*****************************************************************************/

int pcibios_assignres(int slot)
{
	volatile unsigned long	*rp;
	volatile unsigned char	*ip;
	unsigned int		idsel, addr, val, align, i;
	int			bar;

#if 0
	printk("pcibios_assignres(slot=%x)\n", slot);
#endif

	rp = (volatile unsigned long *) COMEM_BASE;
	idsel = COMEM_DA_ADDR(0x1 << (slot + 16));

	/* Try to assign resource to each BAR */
	for (bar = 0; (bar < 6); bar++) {
		addr = COMEM_PCIBUS + PCI_BASE_ADDRESS_0 + (bar * 4);
		rp[LREG(COMEM_DAHBASE)] = COMEM_DA_CFGWR | idsel;
		rp[LREG(addr)] = 0xffffffff;

		rp[LREG(COMEM_DAHBASE)] = COMEM_DA_CFGRD | idsel;
		val = rp[LREG(addr)];
#if 1
printk("--------------------------------------------------------------\n");
printk("%s(%d): BAR[%d] initial read=%08x\n", __FILE__, __LINE__, bar, val);
#endif
		if (val == 0)
			continue;

#if 1
printk("%s(%d): BAR[%d] after all 1 write=%08x\n", __FILE__, __LINE__, bar, val);
#endif

		/* Determine space required by BAR */
		/* FIXME: this should go backwords from 0x80000000... */
		for (i = 0; (i < 32); i++) {
			if ((0x1 << i) & (val & 0xfffffffc))
				break;
		}

#if 1
printk("%s(%d): BAR[%d] size=%08x(%d)\n", __FILE__, __LINE__, bar, (0x1 << i), i);
#endif
		i = 0x1 << i;

		/* Assign a resource */
		if (val & PCI_BASE_ADDRESS_SPACE_IO) {
#if 1
printk("%s(%d): BAR[%d] IO assignment size=%08x iobase=%08x\n", __FILE__, __LINE__, bar, i, pci_iobase);
#endif
			if (i < PCI_MINIO) {
				i = PCI_MINIO;
#if 1
printk("%s(%d): BAR[%d] adjusted minimum size=%08x\n", __FILE__, __LINE__, bar, i);
#endif
			}
			if (i > 0xffff) {
				/* Invalid size?? */
				val = 0 | PCI_BASE_ADDRESS_SPACE_IO;
#if 1
printk("%s(%d): BAR[%d] too big for IO??\n", __FILE__, __LINE__, bar);
#endif
			} else {
				/* Check for un-alignment */
				if ((align = pci_iobase % i))
					pci_iobase += (i - align);
				val = pci_iobase | PCI_BASE_ADDRESS_SPACE_IO;
				pci_iobase += i;
#if 1
printk("%s(%d): BAR[%d]=%08x alignment=%08x iobase=%08x\n", __FILE__, __LINE__, bar, val, i, pci_iobase);
#endif
			}
		} else {

#if 1
printk("%s(%d): BAR[%d] MEM assignment size=%08x membase=%08x\n", __FILE__, __LINE__, bar, i, pci_membase);
#endif
			if (i < PCI_MINMEM) {
				i = PCI_MINMEM;
#if 1
printk("%s(%d): BAR[%d] adjusted minimum size=%08x\n", __FILE__, __LINE__, bar, i);
#endif
			}
			/* Check for un-alignment */
			if ((align = pci_membase % i))
				pci_membase += (i - align);
			val = pci_membase | PCI_BASE_ADDRESS_SPACE_MEMORY;
			pci_membase += i;
#if 1
printk("%s(%d): BAR[%d]=%08x alignment=%08x membase=%08x\n", __FILE__, __LINE__, bar, val, i, pci_membase);
#endif
		}

		/* Write resource back into BAR register */
		rp[LREG(COMEM_DAHBASE)] = COMEM_DA_CFGWR | idsel;
		rp[LREG(addr)] = val;
	}


	/* Assign IRQ if one is wanted... */
	ip = (volatile unsigned char *) (COMEM_BASE + COMEM_PCIBUS);
	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_CFGRD | idsel;

#if 0
	addr = (PCI_INTERRUPT_PIN & 0xfc) + (~PCI_INTERRUPT_PIN & 0x03);
	val = ip[addr];
	addr = (PCI_INTERRUPT_LINE & 0xfc) + (~PCI_INTERRUPT_LINE & 0x03);
	i = ip[addr];
printk("%s(%d): BEFORE interrupt[%x] line=%d pin=%d\n", __FILE__, __LINE__, (int) &ip[addr], i, val);
#endif
	addr = (PCI_INTERRUPT_PIN & 0xfc) + (~PCI_INTERRUPT_PIN & 0x03);
	if (ip[addr]) {
#if 0
printk("%s(%d): setting interrupt line...\n", __FILE__, __LINE__);
#endif
		rp[LREG(COMEM_DAHBASE)] = COMEM_DA_CFGWR | idsel;
		addr = (PCI_INTERRUPT_LINE & 0xfc) + (~PCI_INTERRUPT_LINE & 0x03);
		ip[addr] = 25;
	}
#if 0
rp[LREG(COMEM_DAHBASE)] = COMEM_DA_CFGRD | idsel;
addr = (PCI_INTERRUPT_LINE & 0xfc) + (~PCI_INTERRUPT_LINE & 0x03);
val = ip[addr];
addr = (PCI_INTERRUPT_PIN & 0xfc) + (~PCI_INTERRUPT_PIN & 0x03);
i = ip[addr];
printk("%s(%d): AFTER interrupt[%x] line=%d pin=%d\n", __FILE__, __LINE__, (int) &ip[PCI_INTERRUPT_LINE], val, i);
#endif

	return(0);
}

/*****************************************************************************/

int pcibios_enable(int slot)
{
	volatile unsigned long	*rp;
	unsigned int		idsel, addr;

#if 0
	printk("pcibios_enbale(slot=%x)\n", slot);
#endif

	rp = (volatile unsigned long *) COMEM_BASE;
	idsel = COMEM_DA_ADDR(0x1 << (slot + 16));

	/* Enable I/O and memory accesses to this device */
	addr = COMEM_PCIBUS + PCI_COMMAND;
	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_CFGWR | idsel;
	rp[LREG(addr)] = (PCI_COMMAND_IO | PCI_COMMAND_MEMORY);

#if 0
rp[LREG(COMEM_DAHBASE)] = COMEM_DA_CFGRD | idsel;
printk("%s(%d): command[%x]=%x\n", __FILE__, __LINE__, (int) &rp[LREG(addr)], (int) rp[LREG(addr)]);
#endif

	return(0);
}

/*****************************************************************************/

unsigned long pcibios_init(unsigned long mem_start, unsigned long mem_end)
{
	volatile unsigned long	*rp;
	unsigned long		sel, id;
	int			slot;

#if 0
	printk("pcibios_init()\n");
#endif

	pci_resetbus();

	/*
	 *	Do some sort of basic check to see if the CO-MEM part
	 *	is present...
	 */
	rp = (volatile unsigned long *) COMEM_BASE;
	if ((rp[LREG(COMEM_LBUSCFG)] & 0xffff) != 0x0b50) {
		printk("PCI: no PCI bus present\n");
		return(mem_start);
	}

	pci_bus_is_present = 1;

	/*
	 *	Do a quick scan of the PCI bus and see what is here.
	 */
	for (slot = COMEM_MINDEV; (slot <= COMEM_MAXDEV); slot++) {
		sel = COMEM_DA_CFGRD | COMEM_DA_ADDR(0x1 << (slot + 16));
		rp[LREG(COMEM_DAHBASE)] = sel;
		rp[LREG(COMEM_PCIBUS)] = 0; /* Clear bus */
		id = rp[LREG(COMEM_PCIBUS)];
		if ((id != 0) && ((id & 0xffff0000) != (sel & 0xffff0000))) {
			printk("PCI: slot=%d id=%08x\n", slot, (int) id);
			pci_slotmask |= 0x1 << slot;
			pcibios_assignres(slot);
			pcibios_enable(slot);
		}
	}

	/* Get PCI irq for local vectoring */
	if (request_irq(COMEM_IRQ, pci_interrupt, 0, "PCI bridge", NULL)) {
		printk("PCI: failed to acquire interrupt %d\n", COMEM_IRQ);
	} else {
#if 1
		printk("%s(%d): setting auto-vector...\n", __FILE__, __LINE__);
#endif
		mcf_autovector(COMEM_IRQ);
	}

#if 0
{
	int i;
	for (i = 0; (i < 0x100); i++) {
		if ((i % 0x10) == 0)
			printk("\n%08x: ", i);
		printk("%02x ", pci_inb(i + 0x200));
	}
	printk("\n");
}
#endif
	return(mem_start);
}

/*****************************************************************************/

unsigned long pcibios_fixup(unsigned long mem_start, unsigned long mem_end)
{
	return(mem_start);
}

/*****************************************************************************/

int pcibios_present(void)
{
	return(pci_bus_is_present);
}

/*****************************************************************************/

int pcibios_read_config_dword(unsigned char bus, unsigned char dev,
	unsigned char offset, unsigned int *val)
{
	volatile unsigned long	*rp;
	unsigned long		idsel, fnsel;

#if 0
	printk("pcibios_read_config_dword(bus=%x,dev=%x,offset=%x,val=%x)\n",
		 bus, dev, offset, val);
#endif

	if (bus || ((pci_slotmask & (0x1 << PCI_SLOT(dev))) == 0)) {
		*val = 0xffffffff;
		return(PCIBIOS_SUCCESSFUL);
	}

	rp = (volatile unsigned long *) COMEM_BASE;
	idsel = COMEM_DA_CFGRD | COMEM_DA_ADDR(0x1 << ((dev >> 3) + 16));
	fnsel = (dev & 0x7) << 8;

	rp[LREG(COMEM_DAHBASE)] = idsel;
	*val = rp[LREG(COMEM_PCIBUS + (offset & 0xfc) + fnsel)];

#if 1
	/* If we get back what we wrote, then nothing there */
	/* This is pretty dodgy, but, hey, what else do we do?? */
	if (!offset && (*val == ((idsel & 0xfffff000) | (offset & 0x00000fff))))
		*val = 0xffffffff;
#endif

	return(PCIBIOS_SUCCESSFUL);
}

/*****************************************************************************/

int pcibios_read_config_word(unsigned char bus, unsigned char dev,
	unsigned char offset, unsigned short *val)
{
	volatile unsigned long	*rp;
	volatile unsigned short	*bp;
	unsigned long		idsel, fnsel;
	unsigned char		swapoffset;

#if 0
	printk("pcibios_read_config_word(bus=%x,dev=%x,offset=%x)\n",
		bus, dev, offset);
#endif

	if (bus || ((pci_slotmask & (0x1 << PCI_SLOT(dev))) == 0)) {
		*val = 0xffff;
		return(PCIBIOS_SUCCESSFUL);
	}

	rp = (volatile unsigned long *) COMEM_BASE;
	bp = (volatile unsigned short *) COMEM_BASE;
	idsel = COMEM_DA_CFGRD | COMEM_DA_ADDR(0x1 << ((dev >> 3) + 16));
	fnsel = (dev & 0x7) << 8;
	swapoffset = (offset & 0xfc) + (~offset & 0x02);

	rp[LREG(COMEM_DAHBASE)] = idsel;
	*val = bp[WREG(COMEM_PCIBUS + swapoffset + fnsel)];

	return(PCIBIOS_SUCCESSFUL);
}

/*****************************************************************************/

int pcibios_read_config_byte(unsigned char bus, unsigned char dev,
	unsigned char offset, unsigned char *val)
{
	volatile unsigned long	*rp;
	volatile unsigned char	*bp;
	unsigned long		idsel, fnsel;
	unsigned char		swapoffset;

#if 0
	printk("pcibios_read_config_byte(bus=%x,dev=%x,offset=%x)\n",
		bus, dev, offset);
#endif

	if (bus || ((pci_slotmask & (0x1 << PCI_SLOT(dev))) == 0)) {
		*val = 0xff;
		return(PCIBIOS_SUCCESSFUL);
	}

	rp = (volatile unsigned long *) COMEM_BASE;
	bp = (volatile unsigned char *) COMEM_BASE;
	idsel = COMEM_DA_CFGRD | COMEM_DA_ADDR(0x1 << ((dev >> 3) + 16));
	fnsel = (dev & 0x7) << 8;
	swapoffset = (offset & 0xfc) + (~offset & 0x03);

	rp[LREG(COMEM_DAHBASE)] = idsel;
	*val = bp[(COMEM_PCIBUS + swapoffset + fnsel)];

	return(PCIBIOS_SUCCESSFUL);
}

/*****************************************************************************/

int pcibios_write_config_dword(unsigned char bus, unsigned char dev,
	unsigned char offset, unsigned int val)
{
	volatile unsigned long	*rp;
	unsigned long		idsel, fnsel;

#if 0
	printk("pcibios_write_config_dword(bus=%x,dev=%x,offset=%x,val=%x)\n",
		 bus, dev, offset, val);
#endif

	if (bus || ((pci_slotmask & (0x1 << PCI_SLOT(dev))) == 0))
		return(PCIBIOS_SUCCESSFUL);

	rp = (volatile unsigned long *) COMEM_BASE;
	idsel = COMEM_DA_CFGRD | COMEM_DA_ADDR(0x1 << ((dev >> 3) + 16));
	fnsel = (dev & 0x7) << 8;

	rp[LREG(COMEM_DAHBASE)] = idsel;
	rp[LREG(COMEM_PCIBUS + (offset & 0xfc) + fnsel)] = val;
	return(PCIBIOS_SUCCESSFUL);
}

/*****************************************************************************/

int pcibios_write_config_word(unsigned char bus, unsigned char dev,
	unsigned char offset, unsigned short val)
{

	volatile unsigned long	*rp;
	volatile unsigned short	*bp;
	unsigned long		idsel, fnsel;
	unsigned char		swapoffset;

#if 0
	printk("pcibios_write_config_word(bus=%x,dev=%x,offset=%x,val=%x)\n",
		 bus, dev, offset, val);
#endif

	if (bus || ((pci_slotmask & (0x1 << PCI_SLOT(dev))) == 0))
		return(PCIBIOS_SUCCESSFUL);

	rp = (volatile unsigned long *) COMEM_BASE;
	bp = (volatile unsigned short *) COMEM_BASE;
	idsel = COMEM_DA_CFGRD | COMEM_DA_ADDR(0x1 << ((dev >> 3) + 16));
	fnsel = (dev & 0x7) << 8;
	swapoffset = (offset & 0xfc) + (~offset & 0x02);

	rp[LREG(COMEM_DAHBASE)] = idsel;
	bp[WREG(COMEM_PCIBUS + swapoffset + fnsel)] = val;
	return(PCIBIOS_SUCCESSFUL);
}

/*****************************************************************************/

int pcibios_write_config_byte(unsigned char bus, unsigned char dev,
	unsigned char offset, unsigned char val)
{
	volatile unsigned long	*rp;
	volatile unsigned char	*bp;
	unsigned long		idsel, fnsel;
	unsigned char		swapoffset;

#if 0
	printk("pcibios_write_config_byte(bus=%x,dev=%x,offset=%x,val=%x)\n",
		 bus, dev, offset, val);
#endif

	if (bus || ((pci_slotmask & (0x1 << PCI_SLOT(dev))) == 0))
		return(PCIBIOS_SUCCESSFUL);

	rp = (volatile unsigned long *) COMEM_BASE;
	bp = (volatile unsigned char *) COMEM_BASE;
	idsel = COMEM_DA_CFGRD | COMEM_DA_ADDR(0x1 << ((dev >> 3) + 16));
	fnsel = (dev & 0x7) << 8;
	swapoffset = (offset & 0xfc) + (~offset & 0x03);

	rp[LREG(COMEM_DAHBASE)] = idsel;
	bp[(COMEM_PCIBUS + swapoffset + fnsel)] = val;
	return(PCIBIOS_SUCCESSFUL);
}

/*****************************************************************************/

int pcibios_find_device(unsigned short vendor, unsigned short devid,
	unsigned short index, unsigned char *bus, unsigned char *dev)
{
	unsigned int	vendev, val;
	unsigned char	devnr;

#if 1
	printk("pcibios_find_device(vendor=%04x,devid=%04x,index=%d)\n",
		vendor, devid, index);
#endif

	if (vendor == 0xffff)
		return(PCIBIOS_BAD_VENDOR_ID);

	vendev = (devid << 16) | vendor;
	for (devnr = 0; (devnr < 32); devnr++) {
		pcibios_read_config_dword(0, devnr, PCI_VENDOR_ID, &val);
		if (vendev == val) {
			if (index-- == 0) {
				*bus = 0;
				*dev = devnr;
				return(PCIBIOS_SUCCESSFUL);
			}
		}
	}

	return(PCIBIOS_DEVICE_NOT_FOUND);
}

/*****************************************************************************/

int pcibios_find_class(unsigned int class, unsigned short index,
	unsigned char *bus, unsigned char *dev)
{
	unsigned int	val;
	unsigned char	devnr;

#if 0
	printk("pcibios_find_class(class=%04x,index=%d)\n", class, index);
#endif

	for (devnr = 0; (devnr < 32); devnr++) {
		pcibios_read_config_dword(0, devnr, PCI_CLASS_REVISION, &val);
		if ((val >> 8) == class) {
			if (index-- == 0) {
				*bus = 0;
				*dev = devnr;
				return(PCIBIOS_SUCCESSFUL);
			}
		}
	}

	return(PCIBIOS_DEVICE_NOT_FOUND);
}

/*****************************************************************************/

/*
 *	Local routines to interrcept the standard I/O and vector handling
 *	code. Don't include this 'till now - initialization code above needs
 *	access to the real code too.
 */
#include <asm/mcfpci.h>

/*****************************************************************************/

void pci_outb(unsigned char val, unsigned int addr)
{
	volatile unsigned long	*rp;
	volatile unsigned char	*bp;

#if 1
	printk("pci_outb(val=%02x,addr=%x)\n", val, addr);
#endif

	rp = (volatile unsigned long *) COMEM_BASE;
	bp = (volatile unsigned char *) COMEM_BASE;
	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IOWR | COMEM_DA_ADDR(addr);
	addr = (addr & ~0x3) + (~addr & 0x03);
	bp[(COMEM_PCIBUS + COMEM_DA_OFFSET(addr))] = val;
}

/*****************************************************************************/

void pci_outw(unsigned short val, unsigned int addr)
{
	volatile unsigned long	*rp;
	volatile unsigned short	*sp;

#if 1
	printk("pci_outw(val=%04x,addr=%x)\n", val, addr);
#endif

	rp = (volatile unsigned long *) COMEM_BASE;
	sp = (volatile unsigned short *) COMEM_BASE;
	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IOWR | COMEM_DA_ADDR(addr);
	addr = (addr & ~0x3) + (~addr & 0x02);
	sp[WREG(COMEM_PCIBUS + COMEM_DA_OFFSET(addr))] = val;
}

/*****************************************************************************/

void pci_outl(unsigned int val, unsigned int addr)
{
	volatile unsigned long	*rp;
	volatile unsigned int	*lp;

#if 1
	printk("pci_outl(val=%08x,addr=%x)\n", val, addr);
#endif

	rp = (volatile unsigned long *) COMEM_BASE;
	lp = (volatile unsigned int *) COMEM_BASE;
	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IOWR | COMEM_DA_ADDR(addr);
	lp[LREG(COMEM_PCIBUS + COMEM_DA_OFFSET(addr))] = val;
}

/*****************************************************************************/

unsigned char pci_inb(unsigned int addr)
{
	volatile unsigned long	*rp;
	volatile unsigned char	*bp;
	unsigned char		val;

#if 1
	printk("pci_inb(addr=%x)\n", addr);
#endif

	rp = (volatile unsigned long *) COMEM_BASE;
	bp = (volatile unsigned char *) COMEM_BASE;
	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IORD | COMEM_DA_ADDR(addr);
	addr = (addr & ~0x3) + (~addr & 0x03);
	val = bp[(COMEM_PCIBUS + COMEM_DA_OFFSET(addr))];
#if 0
printk("%s(%d): (BASE=%08x)(addr=%x,OFFSET=%x) %08x=%02x\n",
	__FILE__, __LINE__, rp[LREG(COMEM_DAHBASE)], 
	addr, COMEM_DA_OFFSET(addr),
	(int) &bp[(COMEM_PCIBUS + COMEM_DA_OFFSET(addr))], val);
#endif
#if 1
	printk("pci_inb(addr=%x)=%02x\n", addr, val);
#endif
	return(val);
}

/*****************************************************************************/

unsigned short pci_inw(unsigned int addr)
{
	volatile unsigned long	*rp;
	volatile unsigned short	*sp;
	unsigned short		val;

#if 0
	printk("pci_inw(addr=%x)\n", addr);
#endif

	rp = (volatile unsigned long *) COMEM_BASE;
	sp = (volatile unsigned short *) COMEM_BASE;
	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IORD | COMEM_DA_ADDR(addr);
	addr = (addr & ~0x3) + (~addr & 0x02);
	val = sp[WREG(COMEM_PCIBUS + COMEM_DA_OFFSET(addr))];
#if 1
	printk("pci_inw(addr=%x)=%04x\n", addr, val);
#endif
	return(val);
}

/*****************************************************************************/

unsigned int pci_inl(unsigned int addr)
{
	volatile unsigned long	*rp;
	volatile unsigned int	*lp;
	unsigned int		val;

#if 0
	printk("pci_inl(addr=%x)\n", addr);
#endif

	rp = (volatile unsigned long *) COMEM_BASE;
	lp = (volatile unsigned int *) COMEM_BASE;
	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IORD | COMEM_DA_ADDR(addr);
	val = lp[LREG(COMEM_PCIBUS + COMEM_DA_OFFSET(addr))];
#if 1
	printk("pci_inl(addr=%x)=%08x\n", addr, val);
#endif
	return(val);
}

/*****************************************************************************/

void pci_outsb(void *addr, void *buf, int len)
{
	volatile unsigned long	*rp;
	volatile unsigned char	*bp;
	unsigned char		*dp = (unsigned char *) buf;
	unsigned int		a = (unsigned int) addr;

#if 1
	printk("pci_outsb(addr=%x,buf=%x,len=%d)\n", (int)addr, (int)buf, len);
#endif

	rp = (volatile unsigned long *) COMEM_BASE;
	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IOWR | COMEM_DA_ADDR(a);

	a = (a & ~0x3) + (~a & 0x03);
	bp = (volatile unsigned char *)
		(COMEM_BASE + COMEM_PCIBUS + COMEM_DA_OFFSET(a));

	while (len--)
		*bp = *dp++;
}

/*****************************************************************************/

void pci_outsw(void *addr, void *buf, int len)
{
	volatile unsigned long	*rp;
	volatile unsigned short	*wp;
	unsigned short		*dp = (unsigned short *) buf;
	unsigned int		a = (unsigned int) addr;

#if 1
	printk("pci_outsw(addr=%x,buf=%x,len=%d)\n", (int)addr, (int)buf, len);
#endif

	rp = (volatile unsigned long *) COMEM_BASE;
	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IOWR | COMEM_DA_ADDR(a);

	a = (a & ~0x3) + (~a & 0x2);
	wp = (volatile unsigned short *)
		(COMEM_BASE + COMEM_PCIBUS + COMEM_DA_OFFSET(a));

	while (len--)
		*wp = *dp++;
}

/*****************************************************************************/

void pci_outsl(void *addr, void *buf, int len)
{
	volatile unsigned long	*rp;
	volatile unsigned long	*lp;
	unsigned long		*dp = (unsigned long *) buf;
	unsigned int		a = (unsigned int) addr;

#if 1
	printk("pci_outsl(addr=%x,buf=%x,len=%d)\n", (int)addr, (int)buf, len);
#endif

	rp = (volatile unsigned long *) COMEM_BASE;
	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IOWR | COMEM_DA_ADDR(a);

	lp = (volatile unsigned long *)
		(COMEM_BASE + COMEM_PCIBUS + COMEM_DA_OFFSET(a));

	while (len--)
		*lp = *dp++;
}

/*****************************************************************************/

void pci_insb(void *addr, void *buf, int len)
{
	volatile unsigned long	*rp;
	volatile unsigned char	*bp;
	unsigned char		*dp = (unsigned char *) buf;
	unsigned int		a = (unsigned int) addr;

#if 1
	printk("pci_insb(addr=%x,buf=%x,len=%d)\n", (int)addr, (int)buf, len);
#endif

	rp = (volatile unsigned long *) COMEM_BASE;
	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IORD | COMEM_DA_ADDR(a);

	a = (a & ~0x3) + (~a & 0x03);
	bp = (volatile unsigned char *)
		(COMEM_BASE + COMEM_PCIBUS + COMEM_DA_OFFSET(a));

	while (len--)
		*dp++ = *bp;
}

/*****************************************************************************/

void pci_insw(void *addr, void *buf, int len)
{
	volatile unsigned long	*rp;
	volatile unsigned short	*wp;
	unsigned short		*dp = (unsigned short *) buf;
	unsigned int		a = (unsigned int) addr;

#if 1
	printk("pci_insw(addr=%x,buf=%x,len=%d)\n", (int)addr, (int)buf, len);
#endif

	rp = (volatile unsigned long *) COMEM_BASE;
	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IORD | COMEM_DA_ADDR(a);

	a = (a & ~0x3) + (~a & 0x2);
	wp = (volatile unsigned short *)
		(COMEM_BASE + COMEM_PCIBUS + COMEM_DA_OFFSET(a));

	while (len--)
		*dp++ = *wp;
}

/*****************************************************************************/

void pci_insl(void *addr, void *buf, int len)
{
	volatile unsigned long	*rp;
	volatile unsigned long	*lp;
	unsigned long		*dp = (unsigned long *) buf;
	unsigned int		a = (unsigned int) addr;

#if 1
	printk("pci_insl(addr=%x,buf=%x,len=%d)\n", (int)addr, (int)buf, len);
#endif

	rp = (volatile unsigned long *) COMEM_BASE;
	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IORD | COMEM_DA_ADDR(a);

	lp = (volatile unsigned long *)
		(COMEM_BASE + COMEM_PCIBUS + COMEM_DA_OFFSET(a));

	while (len--)
		*dp++ = *lp;
}

/*****************************************************************************/

typedef struct pci_localirqlist {
	void		(*handler)(int, void *, struct pt_regs *);
	const char	*device;
	void		*dev_id;
};

struct pci_localirqlist	pci_irqlist[COMEM_MAXPCI];

/*****************************************************************************/

int pci_request_irq(unsigned int irq,
	void (*handler)(int, void *, struct pt_regs *),
	unsigned long flags, const char *device, void *dev_id)
{
	int	i;

#if 1
	printk("pci_request_irq(irq=%d,handler=%x,flags=%x,device=%s,"
		"dev_id=%x)\n", irq, (int) handler, (int) flags, device,
		(int) dev_id);
#endif

	/* Check if this interrupt handler is already lodged */
	for (i = 0; (i < COMEM_MAXPCI); i++) {
		if (pci_irqlist[i].handler == handler)
			return(0);
	}

	/* Find a free spot to put this handler */
	for (i = 0; (i < COMEM_MAXPCI); i++) {
		if (pci_irqlist[i].handler == 0) {
			pci_irqlist[i].handler = handler;
			pci_irqlist[i].device = device;
			pci_irqlist[i].dev_id = dev_id;
			return(0);
		}
	}

	/* Couldn't fit?? */
	return(1);
}

/*****************************************************************************/

void pci_free_irq(unsigned int irq, void *dev_id)
{
#if 1
	printk("pci_free_irq(irq=%d,dev_id=%x)\n", irq, (int) dev_id);
#endif

	/* FIXME: need to free up irq... how to id it?? */
}

/*****************************************************************************/

void pci_interrupt(int irq, void *id, struct pt_regs *fp)
{
	int	i;

#if 1
	printk("pci_interrupt(irq=%d,id=%x,fp=%x)\n", irq, (int) id, (int) fp);
#endif

	for (i = 0; (i < COMEM_MAXPCI); i++) {
		if (pci_irqlist[i].handler) {
#if 1
			printk("%s(%d): calling handler=%x\n",
				__FILE__, __LINE__,
				(int) pci_irqlist[i].handler);
#endif
			(*pci_irqlist[i].handler)(irq, id, fp);
		}
	}
}

/*****************************************************************************/
#endif	/* CONFIG_PCI */
