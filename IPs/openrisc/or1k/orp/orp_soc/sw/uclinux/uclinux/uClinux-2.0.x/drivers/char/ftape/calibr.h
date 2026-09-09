#ifndef _CALIBRATE_H
#define _CALIBRATE_H

/*
 *      Copyright (C) 1993-1995 Bas Laarhoven.

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2, or (at your option)
 any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; see the file COPYING.  If not, write to
 the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

 *
 $Source: /cvsroot/anonymous/or1k/orp/orp_soc/sw/uclinux/uclinux/uClinux-2.0.x/drivers/char/ftape/calibr.h,v $
 $Author: simons $
 *
 $Revision: 1.1.1.1 $
 $Date: 2001/09/10 07:44:17 $
 $State: Exp $
 *
 *      This file contains a gp calibration routine for
 *      hardware dependent timeout functions.
 */

#include <linux/timex.h>

extern int calibrate(char *name, void (*fun) (int), int *calibr_count, int *calibr_time);
extern unsigned timestamp(void);
extern int timediff(int t0, int t1);

#endif
