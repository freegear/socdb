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
 * $Id: minimad.c,v 1.1 2002/03/28 20:38:50 lampret Exp $
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#ifndef EMBED
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#endif
#include "audio.h"
#include "mad.h"
#include "fsyst.h"

volatile int button;
//#define OR1K_SIM

#define AUDIO_DBG	0

#if AUDIO_DBG
extern unsigned short wave_dump[(0x40000/2)];
extern int wave_seg_index[0x10000];
extern int wave_seg_nb;
extern int wave_index;
#endif

#define SRAM_BASE       0x80000000
#define SUCCESS_CODE    0x11223344
#define REG32(x)        (*(volatile unsigned long *)(x))
#ifdef OR1K_SIM
#define BUTTON_STATE	(0)
#else
#define BUTTON_STATE	(!((*((volatile unsigned long *)0x40000000)) & 0x80000000))
#endif

void report1(unsigned long value)
{
        unsigned long spr = 0x1234;
        asm("l.mtspr\t\t%0,%1,0x0" : : "r" (spr), "r" (value));
        return;
}                                                                                       
/*
int test_button(void)
{
  if(BUTTON_STATE) {
    button = 1;
    return 0;
  }
  else {
    if(button == 1) {
      while(1) {
        int l = 0;
        int i,j,k;
        for(i = 0; i < 3; i++) {
          for(j = 0; j < 100000; j++)
	    k = BUTTON_STATE;
          l += k;
        }
        if(l == 0) {
	  button = 0;
	  return 1;
        }
      }
    }
    else {
      button = 0;
      return 0;
    }
  }
  return 0;
}
*/
int test_button(void)
{
  if(BUTTON_STATE)
    while(1) {
      int l = 0;
      int i,j,k;
      for(i = 0; i < 3; i++) {
        for(j = 0; j < 100000; j++)
	  k = BUTTON_STATE;
        l += k;
      }
      if(l == 0) {
	button = 0;
	return 1;
      }
    }
  return 0;
}

# ifdef EMBED
int main();

void c_reset()
{
        register unsigned long i asm("r5");
        register int longgggjump asm("r3");
        register unsigned long main_ofs asm("r4");
//      memcpy((void *)0x80000000, (void *)0, 0x1000);
/*              for (i=0x100; i < 0x13000; i+=4)
                  *(unsigned long *)(0x80000000+i) = *(unsigned long *)(0x0+i);
              main_ofs = (unsigned long)main;
              asm("l.movhi r3,0x8000");
              asm("l.add r3,r3,%0" : : "r" (main_ofs));
              asm("l.jr r3");
              asm("l.nop");
*/
	      main(0,0);
}
# endif

/* Root file location.  */
unsigned char *root_file;

static int nchan = 0, speed = 0;
# ifndef EMBED
FILE *fo;
int output_s(unsigned char const *ptr, unsigned int len);
# endif

static void
output(struct mad_pcm *pcm)
{
  unsigned int nchannels;
# ifndef EMBED
  union audio_control control;
# endif
  mad_fixed_t *ch1, *ch2; 

  nchannels = pcm->channels;

  if (nchannels != nchan || speed != pcm->samplerate)
    {
# ifndef EMBED
      control.command = AUDIO_COMMAND_CONFIG;
      
      control.config.channels = nchannels;
      control.config.speed    = pcm->samplerate;
      printf ("%i ", pcm->samplerate);
      if (audio_oss(&control) == -1)
	return;
# endif 
      nchan = nchannels;
      speed = pcm->samplerate;
    }
  ch1 = &pcm->samples[0][0];
  ch2 = &pcm->samples[1][0];

  if (nchan == 1)
    ch2 = ch1;

  {
    unsigned char data[MAX_NSAMPLES * 4 * 2];
    unsigned int len;

    len = audio_pcm_s16le(data, pcm->length, ch1, ch2);
# ifndef EMBED
    output_s(data, len);
# endif
  }
  return;
}
#ifdef EMBED
void report(unsigned long value)
{
	unsigned long spr = 0x1234;
	asm("l.mtspr\t\t%0,%1,0x0" : : "r" (spr), "r" (value));
	return;
}
#endif

struct mad_pcm pcm;
/* Generates beep of 32 samples with sampling frequency
   freq, vould = 0..31. */
static void genbeep (int freq, int volume)
{
  int o = MAD_F_ONE/256 * volume, i;
  pcm.length = 32;
  pcm.samplerate = freq;
  pcm.channels = 1;
  for (i = 0; i < 8; i++) {
    pcm.samples[0][i] = i * o;
//     report(i);
  }
  for (i = 0; i < 8; i++)
    pcm.samples[0][i+8] = (8 - i) * o;
  output (&pcm);
  for (i = 0; i < 16; i++)
    pcm.samples[0][16+i] = -pcm.samples[0][i];
  output (&pcm);
}

static void short_beep ()
{
  int i;
  for (i = 0; i < 5; i++)
    genbeep(44100, 8);
}

/* private message buffer */

struct buffer {
  unsigned char *start;
  unsigned long length;
};

/* 2. called when more input is needed; refill stream buffer */

static
enum mad_flow input(void *data,
		    struct mad_stream *stream)
{
  struct buffer *buffer = data;

  if (!buffer->length)
    return MAD_FLOW_STOP;

  mad_stream_buffer(stream, buffer->start, buffer->length);

  buffer->length = 0;

  return MAD_FLOW_CONTINUE;
}

/* 4. called to handle a decoding error */

static
enum mad_flow error(void *data,
		    struct mad_stream *stream,
		    struct mad_frame *frame)
{
#ifndef EMBED
  struct buffer *buffer = data;
  fprintf(stderr, "decoding error 0x%04x at byte offset %u\n",
	  stream->error, stream->this_frame - buffer->start);
#endif

  return MAD_FLOW_STOP;
}

/* 5. put it all together */

static
int decode(unsigned char *start, unsigned long length)
{
  struct buffer buffer;
  struct mad_decoder decoder;
  int result = 0;

  buffer.start  = start;
  buffer.length = length;

  /* configure input, and error functions */

  mad_decoder_init(&decoder, &buffer,
		   input, error);

  /* start the decoder */

  result = mad_decoder_run(&decoder, MAD_DECODER_MODE_SYNC);

  mad_decoder_finish(&decoder);

  return result;
}

#ifndef EMBED
static void *init_flash (char *filename)
{
  struct stat f_stat;
  void *flash;
  FILE *f = fopen (filename, "rb");
  if (!f)
    return NULL;
  stat (filename, &f_stat);
  flash = malloc (f_stat.st_size);
  if (!flash)
    return NULL;
  if (fread (flash, 1, f_stat.st_size, f) != f_stat.st_size)
    return NULL;
  fclose (f);
  return flash;
}
#else
extern unsigned char flash_data[];
#endif


void __main() {}

int main(int argc, char *argv[])
{
  int i;
  int result;
  

#ifndef EMBED
  union audio_control control;
  if (argc != 2)
    {
      printf ("Usage: minimad image_file.mfs\n");
      return 1;
    }
  if (!(root_file = (char *) init_flash (argv[1])))
    {
      fprintf (stderr, "Error loading image file '%s'\n", argv[1]);
      return 2;
    }
  
  control.command   = AUDIO_COMMAND_INIT;
  control.init.path = NULL;
  if (audio_oss(&control) == -1) {
    printf("audio %s\n", audio_error);
    return 3;
  }
  fo = fopen ("audio.pcm", "wb+");
#else
  /* In EMBEDDED applications we have flash data linked.  */
  root_file = &flash_data[0];
#ifdef OR1K_SIM
  asm volatile ("l.mtspr r0,r0,0x0FFFD");
#endif
#endif  
  button = 0;


  for (i = 1;; i++) {
    struct file_struct *fs, *datat;
    fs = find_track_no (i, ROOT_FILE);
//    if (!fs) break;
    if(!fs) { 
      i = 1;	
      fs = find_track_no (i, ROOT_FILE);
    }
    datat = track_data (fs);
    short_beep();

# ifndef EMBED
    {
      unsigned u, v;
      u = swap(datat->length);
      v = swap(datat->data[0]);
      printf ("Track %u: %s\n", i, track_name (fs));
      printf ("%08x:%08x:%08x\n", datat->data[0], v, u);
    }
# endif
    result = decode((unsigned char *)&datat->data[0], swap(datat->length) - sizeof(struct file_struct) + sizeof (unsigned int));
    if(result != 1) {
      while(!test_button());
    }
  }

  short_beep();
#ifndef EMBED
  control.command = AUDIO_COMMAND_FINISH;
  if (audio_oss(&control) == -1) {
    printf("audio %s\n", audio_error);
    return 3;
  }
  free (root_file);
  printf ("Done.\n");
  fclose (fo);
#else
#ifdef OR1K_SIM
  asm volatile("l.mtspr r0,r0,0x0FFFF");
#endif
#endif

#if AUDIO_DBG
report1(wave_index);
report1(wave_seg_nb);

report1(wave_seg_index[10]);
report1(wave_dump[wave_seg_index[10]]);

report1(wave_seg_index[11]);
report1(wave_dump[wave_seg_index[11]]);

report1(wave_seg_index[12]);
report1(wave_dump[wave_seg_index[12]]);
#endif

while(1) {
                REG32(SRAM_BASE + 0x00) = (SUCCESS_CODE >> 0) & 0x000000ff;
                REG32(SRAM_BASE + 0x40) = (SUCCESS_CODE >> 8) & 0x000000ff;
                REG32(SRAM_BASE + 0x80) = (SUCCESS_CODE >> 16) & 0x000000ff;
                REG32(SRAM_BASE + 0xc0) = (SUCCESS_CODE >> 24) & 0x000000ff;
        }
  return 0;
}

