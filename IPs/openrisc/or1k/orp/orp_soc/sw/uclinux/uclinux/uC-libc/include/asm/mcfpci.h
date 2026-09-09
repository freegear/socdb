/****************************************************************************/

/*
 *	mcfpci.h -- PCI bridge on ColdFire eval boards.
 *
 *	(C) Copyright 2000, Greg Ungerer (gerg@moreton.com.au)
 */

/****************************************************************************/
#ifndef	mcfpci_h
#define	mcfpci_h
/****************************************************************************/

#include <linux/config.h>

#ifdef CONFIG_PCI

/*
 *	Address regions in the PCI addres space are not mapped into the
 *	normal memory space of the ColdFire. They must be accessed via
 *	handler routines. This is easy for I/O space (inb/outb/etc) but
 *	needs some code changes to support ordinary memory. Interrupts
 *	also need to be vectored through the PCI handler first, then it
 *	will call the actual driver sub-handlers.
 */

/*
 *	Un-define all the standard I/O access routines.
 */
#undef	inb
#undef	inw
#undef	inl
#undef	insb
#undef	insw
#undef	insl
#undef	outb
#undef	outw
#undef	outl
#undef	outsb
#undef	outsw
#undef	outsl

#undef	request_irq
#undef	free_irq


/*
 *	Re-direct all I/O memory accesses functions to PCI specific ones.
 */
#define	inb	pci_inb
#define	inw	pci_inw
#define	inl	pci_inl
#define	inb_p	pci_inb
#define	inw_p	pci_inw
#define	insb	pci_insb
#define	insw	pci_insw
#define	insl	pci_insl

#define	outb	pci_outb
#define	outw	pci_outw
#define	outl	pci_outl
#define	outb_p	pci_outb
#define	outw_p	pci_outw
#define	outsb	pci_outsb
#define	outsw	pci_outsw
#define	outsl	pci_outsl

#define	request_irq	pci_request_irq
#define	free_irq	pci_free_irq


/*
 *	Prototypes of the real PCI functions (defined in bios32.c).
 */
unsigned char	pci_inb(unsigned int addr);
unsigned short	pci_inw(unsigned int addr);
unsigned int	pci_inl(unsigned int addr);
void		pci_insb(void *addr, void *buf, int len);
void		pci_insw(void *addr, void *buf, int len);
void		pci_insl(void *addr, void *buf, int len);

void		pci_outb(unsigned char val, unsigned int addr);
void		pci_outw(unsigned short val, unsigned int addr);
void		pci_outl(unsigned int val, unsigned int addr);
void		pci_outsb(void *addr, void *buf, int len);
void		pci_outsw(void *addr, void *buf, int len);
void		pci_outsl(void *addr, void *buf, int len);

int		pci_request_irq(unsigned int irq,
			void (*handler)(int, void *, struct pt_regs *),
			unsigned long flags,
			const char *device,
			void *dev_id);
void		pci_free_irq(unsigned int irq, void *dev_id);

#endif /* CONFIG_PCI */
/****************************************************************************/
#endif	/* mcfpci_h */
