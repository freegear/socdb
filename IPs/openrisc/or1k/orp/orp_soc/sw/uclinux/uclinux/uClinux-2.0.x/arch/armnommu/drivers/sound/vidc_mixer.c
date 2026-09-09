/*
 * sound/vidc_mixer.c
 *
 * Mixer routines for VIDC
 *
 * Copyright (C) 1997 Russell King
 */
#include <linux/config.h>
#include "sound_config.h"

#include "vidc.h"

#if defined(CONFIG_VIDC)

int vidc_volume;

static int
vidc_get_volume (void)
{
  return vidc_volume;
}

static int
vidc_set_volume (int newvol)
{
  vidc_volume = newvol;
/*  printk ("vidc_set_volume: %X\n", newvol);*/
  return newvol;
}

static int
vidc_default_mixer_ioctl (int dev, unsigned int cmd, caddr_t arg)
{
  switch (cmd) {
  case SOUND_MIXER_READ_VOLUME:
    return snd_ioctl_return ((int *)arg, vidc_get_volume ());

  case SOUND_MIXER_WRITE_VOLUME:
    return snd_ioctl_return ((int *)arg, vidc_set_volume (get_user ((int *)arg)));

  case SOUND_MIXER_READ_BASS:
  case SOUND_MIXER_WRITE_BASS:
  case SOUND_MIXER_READ_TREBLE:
  case SOUND_MIXER_WRITE_TREBLE:
    return snd_ioctl_return ((int *)arg, 50);

  case SOUND_MIXER_READ_SYNTH:
    return snd_ioctl_return ((int *)arg, vidc_synth_get_volume ());

  case SOUND_MIXER_WRITE_SYNTH:
    return snd_ioctl_return ((int *)arg, vidc_synth_set_volume (get_user ((int *)arg)));

  case SOUND_MIXER_READ_PCM:
    return snd_ioctl_return ((int *)arg, vidc_audio_get_volume ());

  case SOUND_MIXER_WRITE_PCM:
    return snd_ioctl_return ((int *)arg, vidc_audio_set_volume (get_user ((int *)arg)));

  case SOUND_MIXER_READ_SPEAKER:
    return snd_ioctl_return ((int *)arg, 100);

  case SOUND_MIXER_WRITE_SPEAKER:
    return snd_ioctl_return ((int *)arg, 100);

  case SOUND_MIXER_READ_LINE:
  case SOUND_MIXER_WRITE_LINE:
  case SOUND_MIXER_READ_MIC:
  case SOUND_MIXER_WRITE_MIC:
    return snd_ioctl_return ((int *)arg, 0);

  case SOUND_MIXER_READ_CD:
  case SOUND_MIXER_WRITE_CD:
    return snd_ioctl_return ((int *)arg, 100 | (100 << 8));

  case SOUND_MIXER_READ_IMIX:
  case SOUND_MIXER_WRITE_IMIX:
  case SOUND_MIXER_READ_ALTPCM:
  case SOUND_MIXER_WRITE_ALTPCM:
  case SOUND_MIXER_READ_LINE1:
  case SOUND_MIXER_WRITE_LINE1:
  case SOUND_MIXER_READ_LINE2:
  case SOUND_MIXER_WRITE_LINE2:
  case SOUND_MIXER_READ_LINE3:
  case SOUND_MIXER_WRITE_LINE3:
    return snd_ioctl_return ((int *)arg, 0);

  case SOUND_MIXER_READ_RECSRC:
    return snd_ioctl_return ((int *)arg, 0);

  case SOUND_MIXER_WRITE_RECSRC:
    return snd_ioctl_return ((int *)arg, -EINVAL);

  case SOUND_MIXER_READ_DEVMASK:
    return snd_ioctl_return ((int *)arg, SOUND_MASK_VOLUME | SOUND_MASK_PCM | SOUND_MASK_SYNTH);

  case SOUND_MIXER_READ_RECMASK:
    return snd_ioctl_return ((int *)arg, 0);

  case SOUND_MIXER_READ_STEREODEVS:
    return snd_ioctl_return ((int *)arg, SOUND_MASK_VOLUME | SOUND_MASK_PCM | SOUND_MASK_SYNTH);

  case SOUND_MIXER_READ_CAPS:
    return snd_ioctl_return ((int *)arg, 0);

  case SOUND_MIXER_READ_MUTE:
    return snd_ioctl_return ((int *)arg, -EINVAL);

  default:
    return snd_ioctl_return ((int *)arg, -EINVAL);
  }
}

static struct mixer_operations vidc_mixer_operations =
{
  "VIDC",
  "VIDCsound",
  vidc_default_mixer_ioctl	/* ioctl		*/
};

void
vidc_mixer_init (struct address_info *hw_config)
{
  vidc_volume = 100 | (100 << 8);
  if (num_mixers < MAX_MIXER_DEV)
    mixer_devs[num_mixers++] = &vidc_mixer_operations;
}

#endif
