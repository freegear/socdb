/*
 * Dummy serial functions
 *
 * Copyright (C) 1995, 1996 Russell King
 */

#include <linux/errno.h>
#include <linux/sched.h>
#include <linux/serial.h>

int rs_init (void)
{
    return 0;
}

int register_serial (struct serial_struct *dev)
{
    return -1;
}

void unregister_serial (int line)
{
}
