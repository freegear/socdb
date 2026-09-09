/*
 * linux/arch/arm/drivers/char/mouse.h
 *
 * Prototypes for mouse device driver
 */
#ifndef MOUSE_H
#define MOUSE_H

extern void add_mouse_movement (int dx, int dy);
extern int add_mouse_buttonchange (int set, int value);
extern int misc_mouse_init (void);

#endif
