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
 * $Id: audio.c,v 1.1 2002/03/28 20:38:50 lampret Exp $
 */

# ifdef HAVE_CONFIG_H
#  include "config.h"
# endif

# include "audio.h"
# include "mad.h"

#ifndef EMBED
# include <string.h>
# include <stdio.h>
extern FILE *fo;
int printf(char *fmt, ...);
#endif

char const *audio_error;

static mad_fixed_t left_err, right_err;

#define AUDIO_DBG 	0 

#if AUDIO_DBG
//unsigned short wave_dump[(0x40000/2)];
//int wave_seg_index[0x10000];
int wave_seg_nb = 0;
int wave_index = 0;
#endif

/*
 * NAME:	audio_linear_dither()
 * DESCRIPTION:	generic linear sample quantize and dither routine
 */
inline
signed long audio_linear_dither(unsigned int bits, mad_fixed_t sample,
				mad_fixed_t *error, struct audio_stats *stats)
{
  mad_fixed_t quantized;

  /* dither */
  sample += *error;

# if 1
  /* clip */
  quantized = sample;
  if (sample >= stats->peak_sample) {
    if (sample >= MAD_F_ONE) {
      quantized = MAD_F_ONE - 1;
      ++stats->clipped_samples;
      if (sample - quantized > stats->peak_clipping &&
	  mad_f_abs(*error) < (MAD_F_ONE >> (MAD_F_FRACBITS + 1 - bits)))
	stats->peak_clipping = sample - quantized;
    }
    stats->peak_sample = quantized;
  }
  else if (sample < -stats->peak_sample) {
    if (sample < -MAD_F_ONE) {
      quantized = -MAD_F_ONE;
      ++stats->clipped_samples;
      if (quantized - sample > stats->peak_clipping &&
	  mad_f_abs(*error) < (MAD_F_ONE >> (MAD_F_FRACBITS + 1 - bits)))
	stats->peak_clipping = quantized - sample;
    }
    stats->peak_sample = -quantized;
  }
# else
  /* clip */
  quantized = sample;
  if (sample >= MAD_F_ONE)
    quantized = MAD_F_ONE - 1;
  else if (sample < -MAD_F_ONE)
    quantized = -MAD_F_ONE;
# endif

  /* quantize */
  quantized &= ~((1L << (MAD_F_FRACBITS + 1 - bits)) - 1);

  /* error */
  *error = sample - quantized;

  /* scale */
  return quantized >> (MAD_F_FRACBITS + 1 - bits);
}


static struct audio_stats stats;

/*
 * NAME:	audio_pcm_s16le()
 * DESCRIPTION:	write a block of signed 16-bit little-endian PCM samples
 */
unsigned int audio_pcm_s16le(unsigned char *data, unsigned int nsamples,
			     mad_fixed_t const *left, mad_fixed_t const *right)
{
  unsigned int len;
  register signed int sample0, sample1;

  len = nsamples;
#if AUDIO_DBG
//  wave_seg_index[wave_seg_nb] = wave_index;
//  wave_seg_nb++;
report(wave_index);  
#endif

  while (len--) {
    sample0 = audio_linear_dither(16, *left++,  &left_err,  &stats);
    sample1 = audio_linear_dither(16, *right++, &right_err, &stats);

#ifdef EMBED
#ifdef OR1K
#ifndef OR1K_SIM
    *(volatile unsigned short *)0x40000000 = sample0;
//    *(volatile unsigned long *)0x40000000 = sample0;
//    *(volatile unsigned long *)0x40000000 = sample1;
//    *(volatile unsigned long *)0x40000000 = sample1;

#if AUDIO_DBG
//    wave_dump[wave_index] = (unsigned short)sample0;
    wave_index++;
//    wave_dump[wave_index] = (unsigned short)sample1;
    wave_index++;
#endif

#else
//    asm volatile("l.mtspr r0,%0,0x01234" : : "r" (sample0 | (sample1 << 16)));
    asm volatile("l.mtspr r0,%0,0x0FFFE" : : "r" (sample0 >> 0));
    asm volatile("l.mtspr r0,%0,0x0FFFE" : : "r" (sample0 >> 8));
    asm volatile("l.mtspr r0,%0,0x0FFFE" : : "r" (sample1 >> 0));
    asm volatile("l.mtspr r0,%0,0x0FFFE" : : "r" (sample1 >> 8));
#endif
#else
    printf("l.mtspr (0x0000FFFE) <- %x\n", (sample0 >> 0));
    printf("l.mtspr (0x0000FFFE) <- %x\n", (sample0 >> 8));
    printf("l.mtspr (0x0000FFFE) <- %x\n", (sample1 >> 0));
    printf("l.mtspr (0x0000FFFE) <- %x\n", (sample1 >> 8));
#endif
#else
    data[0] = sample0 >> 0;
    data[1] = sample0 >> 8;
    data[2] = sample1 >> 0;
    data[3] = sample1 >> 8;
    if (fo) {
      fputc (data[0], fo);
      fputc (data[1], fo);
      fputc (data[2], fo);
      fputc (data[3], fo);
    }
    data += 4;
#endif
  }
  return nsamples * 2 * 2;
}
