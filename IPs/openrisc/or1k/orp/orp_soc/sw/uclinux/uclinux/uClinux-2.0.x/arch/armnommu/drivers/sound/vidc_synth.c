/*
 * sound/vidc_synth.c
 *
 * Synthesizer routines for the VIDC
 *
 * Copyright (C) 1997 Russell King
 */
#include <linux/config.h>
#include "sound_config.h"

#include "vidc.h"

#if defined(CONFIG_VIDC)

static struct synth_info vidc_info =
{
  "VIDCsound",			/* name			*/
  0,				/* device		*/
  SYNTH_TYPE_SAMPLE,		/* synth_type		*/
  0,				/* synth_subtype	*/
  0,				/* perc_mode		*/
  16,				/* nr_voices		*/
  0,				/* nr_drums		*/
  0,				/* instr_bank_size	*/
  0,				/* capabilities		*/
};

int vidc_sdev;
int vidc_synth_volume;

static int
vidc_synth_open (int dev, int mode)
{
  if (vidc_busy)
    return -EBUSY;

  vidc_busy = 1;

  return 0;
}

static void
vidc_synth_close (int dev)
{
  vidc_busy = 0;
}


static struct synth_operations vidc_synth_operations = {
  &vidc_info,			/* info			*/
  0,				/* midi_dev		*/
  SYNTH_TYPE_SAMPLE,		/* synth_type		*/
  /*SAMPLE_TYPE_XXX*/0, /* SAMPLE_TYPE GUS */	/* synth_subtype		*/
  vidc_synth_open,		/* open			*/
  vidc_synth_close,		/* close		*/
  NULL,				/* ioctl		*/
  NULL,				/* kill_note		*/
  NULL,				/* start_note		*/
  NULL,				/* set_instr		*/
  NULL,				/* reset		*/
  NULL,				/* hw_control		*/
  NULL,				/* load_patch		*/
  NULL,				/* aftertouch		*/
  NULL,				/* controller		*/
  NULL,				/* panning		*/
  NULL,				/* volume_method	*/
  NULL,				/* patchmgr		*/
  NULL,				/* bender		*/
  NULL,				/* alloc		*/
  NULL,				/* setup_voice		*/
  NULL,				/* send_sysex		*/
				/* alloc		*/
				/* chn_info[16]		*/
};

int vidc_synth_get_volume (void)
{
  return vidc_synth_volume;
}

int vidc_synth_set_volume (int newvol)
{
  return vidc_synth_volume = newvol;
}

void vidc_synth_init (struct address_info *hw_config)
{
  vidc_synth_volume = 100 | (100 << 8);
  if (num_synths < MAX_SYNTH_DEV) {
    synth_devs[vidc_sdev = num_synths++] = &vidc_synth_operations;
  } else
    printk ("VIDCsound: Too many synthesizers\n");
}

#endif
