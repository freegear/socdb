#include <linux/module.h>
#include <linux/ptrace.h>
#include <linux/interrupt.h>
#include <linux/sched.h>

#include <asm/hardware.h>
#include <asm/irq.h>
#include <asm/io.h>

#include "mouse.h"

static short old_x, old_y, old_b;

void mouse_rpc_irq (int irq, void *dev_id, struct pt_regs *regs)
{
	short x, y, b, dx, dy, db;

	x = (short)inl(IOMD_MOUSEX);
	y = (short)inl(IOMD_MOUSEY);
	b = (inl (0x800C4000) >> 4) & 7;

	dx = x - old_x;
	old_x = x;
	dy = y - old_y;
	old_y = y;
	db = b ^ old_b;
	old_b = b;

	if (dx || dy)
		add_mouse_movement(dx, dy);
	if (db)
		add_mouse_buttonchange(7, b);
}

void mouse_rpc_init(void)
{
	old_x = (short)inl(IOMD_MOUSEX);
	old_y = (short)inl(IOMD_MOUSEY);
	old_b = (inl (0x800C4000) >> 4) & 7;
	request_irq (IRQ_VSYNCPULSE, mouse_rpc_irq, SA_SHIRQ, "mouse", NULL);
}
