/* config.h.  Generated automatically by configure.  */
/* config.h.in.  Generated automatically from configure.in by autoheader.  */
/*
 * mad - MPEG audio decoder
 * Copyright (C) 2000-2001 Robert Leslie
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * $Id: config.h,v 1.1 2002/03/28 20:38:50 lampret Exp $
 */

# ifndef CONFIG_H
# define CONFIG_H

/*****************************************************************************
 * Definitions selected automatically by `configure'                         *
 *****************************************************************************/

/* Define to empty if the keyword does not work.  */
/* #undef const */

/* Define if you don't have vprintf but do have _doprnt.  */
/* #undef HAVE_DOPRNT */

/* Define if you have a working `mmap' system call.  */
/* #undef HAVE_MMAP */

/* Define if you have the vprintf function.  */
/* #undef HAVE_VPRINTF */

/* Define as __inline if that's what the C compiler calls it.  */
/* #undef inline */

/* Define if you need to in order for stat and other things to work.  */
/* #undef _POSIX_SOURCE */

/* Define if you have the ANSI C header files.  */
#define STDC_HEADERS 1

/* Define to be the name of your default audio output module. */
#define AUDIO_DEFAULT audio_null

/* Define if you have mmap() and you want to use it. */
#define USE_MMAP 1

/* Define to enable diagnostic debugging support. */
/* #undef DEBUG */

/* Define to disable debugging assertions. */
/* #undef NDEBUG */

/* Define to enable experimental code. */
/* #undef EXPERIMENTAL */

#define EMBED 1

/* Define to enable pcm output trogh or1ksim simulator */
/*#define OR1K_SIM 1*/

/* Define if you have the getpagesize function.  */
/* #undef HAVE_GETPAGESIZE */

/* Define if you have the madvise function.  */
/* #undef HAVE_MADVISE */

/* Define if you have the strcasecmp function.  */
#define HAVE_STRCASECMP 1

/* Define if you have the strncasecmp function.  */
#define HAVE_STRNCASECMP 1

/* Define if you have the <unistd.h> header file.  */
#define HAVE_UNISTD_H 1

/* Define if you have the efence library (-lefence).  */
/* #undef HAVE_LIBEFENCE */

/* Name of package */
#define PACKAGE "mad"

/* Version number of package */
#define VERSION "0.13.0b"

/*****************************************************************************
 * End of automatically configured definitions                               *
 *****************************************************************************/

# endif
