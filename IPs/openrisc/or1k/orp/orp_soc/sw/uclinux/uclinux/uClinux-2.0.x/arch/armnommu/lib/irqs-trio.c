#include <linux/sched.h>
#include <linux/interrupt.h>

#include <asm/io.h>
#include <asm/system.h>
#include <asm/hardware.h>
#include <asm/irq.h>
#include <asm/arch/irq.h>



/* The trio AIC need to recive EOI command at the end of interrupt handler,
   These command is compossed from previous IRQ nr and previous IRQ priority.
   So we maintain this value in the trio_irq_prority variable.

   The trio_irq_prtable contains the priority<<5 for each IRQ
*/   

volatile unsigned char trio_irq_priority = 0; /* Current IRQ number and priority */
unsigned char trio_irq_prtable[16] = {
	7,  /* FIQ */
	0,  /* WDIRQ */
	0,  /* SWIRQ */
	2, /* UAIRQ */
	0,		/* TC0 (Timer 0 used for DRAM refresh */
	1, /* TC1IRQ */
	0,		/* TC2IRQ */
	0,  /* PIOAIRQ */
	0,  /* LCDIRQ not used */
	5, /* SPIIRQ */
	4, /* IRQ0, (ETHERNET? )*/
	0,  /* IRQ1 */
	6,  /* OAKAIRQ */
	6,  /* OAKBIRQ */
	3, /* UBIRQ */
	5 /* PIOBIRQ */
	
};

void do_IRQ(int irq, struct pt_regs * regs);


inline void irq_ack(int priority)
{
	outl(priority, AIC_EOICR);
}
	
asmlinkage int probe_IRQ_interrupt(int irq, struct pt_regs * regs)
{
	mask_irq(irq);
	irq_ack(trio_irq_priority);
	return 0;
}

asmlinkage int bad_IRQ_interrupt(int irqn, struct pt_regs * regs)
{
	printk("bad interrupt %d recieved!\n", irqn);
	irq_ack(trio_irq_priority);
	return 0;
}

asmlinkage int IRQ_interrupt(int irq, struct pt_regs * regs)
{
	register unsigned long flags;
	register unsigned long saved_count;
	register unsigned char spr = trio_irq_priority;

	trio_irq_priority = ((unsigned char)irq) | trio_irq_prtable[irq];


	saved_count = intr_count;
	intr_count = saved_count + 1;

	save_flags(flags);
	sti();
	do_IRQ(irq, regs);
	restore_flags(flags);
	intr_count = saved_count;
	trio_irq_priority = spr;
	irq_ack(spr);
	return 0;
}


asmlinkage int timer_IRQ_interrupt(int irq, struct pt_regs * regs)
{
	register unsigned long flags;
	register unsigned long saved_count;
	register unsigned char spr = trio_irq_priority;

	trio_irq_priority = ((unsigned char)irq) | trio_irq_prtable[irq];



	saved_count = intr_count;
	intr_count = saved_count + 1;

	save_flags(flags);
	do_IRQ(irq, regs);
	restore_flags(flags);
	intr_count = saved_count;
	trio_irq_priority = spr;
	irq_ack(spr);
	return 0;
}


asmlinkage int fast_IRQ_interrupt(int irq, struct pt_regs * regs)
{
	register unsigned long saved_count;

	saved_count = intr_count;
	intr_count = saved_count + 1;

	do_IRQ(irq, regs);
	cli();
	intr_count = saved_count;
	inl(AIC_FVR);
	return 1;
}

void trio_init_aic()
{
	int irqno;

	// Disable all interrupts
	outl(0xFFFFFFFF, AIC_IDCR);
	
	// Clear all interrupts
	outl(0xFFFFFFFF, AIC_ICCR);

	for ( irqno = 0 ; irqno < 8 ; irqno++ )
	{
		outl(irqno, AIC_EOICR);
	}
	

	
	for ( irqno = 0 ; irqno < 16 ; irqno++ )
	{
		outl(trio_irq_prtable[irqno]  |  (1 << 5), AIC_SMR(irqno));
	}
}
