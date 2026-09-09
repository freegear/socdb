/***************************************************************************
 *             __________               __   ___.
 *   Open      \______   \ ____   ____ |  | _\_ |__   _______  ___
 *   Source     |       _//  _ \_/ ___\|  |/ /| __ \ /  _ \  \/  /
 *   Jukebox    |    |   (  <_> )  \___|    < | \_\ (  <_> > <  <
 *   Firmware   |____|_  /\____/ \___  >__|_ \|___  /\____/__/\_ \
 *                     \/            \/     \/    \/            \/
 * $Id: panic.h,v 1.3 2005/02/28 09:48:35 jyp Exp $
 *
 * Copyright (C) 2002 by wavey@wavey.org
 *
 * All files in this archive are subject to the GNU General Public License.
 * See the file COPYING in the source tree root for full license agreement.
 *
 * This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
 * KIND, either express or implied.
 *
 ****************************************************************************/

#ifndef __PANIC_H__
#define __PANIC_H__

#include "_ansi.h"

// Modified to avoid compile error by DJKIM 2006/11/30
//void panicf( const char *fmt, ... ) ATTRIBUTE_PRINTF(1, 2);
void panicf( const char *fmt, ... );

#endif /* __PANIC_H__ */
