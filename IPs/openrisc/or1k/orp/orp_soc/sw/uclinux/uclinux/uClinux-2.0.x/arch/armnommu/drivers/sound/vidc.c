/*
 * sound/vidc.c
 *
 * Detection routine for the VIDC
 */
/*
 * Copyright (C) by Russell King
 *
 * USS/Lite for Linux is distributed under the GNU GENERAL PUBLIC LICENSE (GPL)
 * Version 2 (June 1991). See the "COPYING" file distributed with this software
 * for more info.
 */
#include <linux/config.h>
#include <linux/sched.h>
#include <linux/mman.h>
#include <linux/malloc.h>

#include <asm/io.h>
#include <asm/pgtable.h>
#include "sound_config.h"

#include "vidc.h"

#if defined(CONFIG_VIDC)

int vidc_busy;

void vidc_update_filler(int format, int channels)
{
	int filltype;

#define TYPE(fmt,ch) (((fmt)<<2)|((ch)&3))
	filltype = TYPE(format,channels);
	switch (filltype)
	{
		default:
		case TYPE(AFMT_U8, 1):
			vidc_filler = vidc_fill_1x8_u;
			break;

		case TYPE(AFMT_U8, 2):
			vidc_filler = vidc_fill_2x8_u;
			break;

		case TYPE(AFMT_S8, 1):
			vidc_filler = vidc_fill_1x8_s;
			break;

		case TYPE(AFMT_S8, 2):
			vidc_filler = vidc_fill_2x8_s;
			break;

		case TYPE(AFMT_S16_LE, 1):
			vidc_filler = vidc_fill_1x16_s;
			break;

		case TYPE(AFMT_S16_LE, 2):
			vidc_filler = vidc_fill_2x16_s;
			break;
	}
}

void
attach_vidc (struct address_info *hw_config)
{
  char name[32];
  int i;

  sprintf (name, "VIDCsound: VIDC %d-bit sound", hw_config->card_subtype);
  conf_printf (name, hw_config);

  for (i = 0; i < 2; i++) {
    dma_buf[i] = get_free_page (GFP_KERNEL);
    dma_pbuf[i] = virt_to_phys ((void *)dma_buf[i]);
  }

  if (sound_alloc_dma (hw_config->dma, "VIDCsound")) {
    printk ("VIDCsound: can't allocate virtual DMA channel\n");
    return;
  }

  if (snd_set_irq_handler (hw_config->irq, vidc_sound_dma_irq, "VIDCsound", hw_config->osp)) {
    printk ("VIDCsound: can't allocate DMA interrupt\n");
    return;
  }

  vidc_synth_init (hw_config);
  vidc_audio_init (hw_config);
  vidc_mixer_init (hw_config);
}

int
probe_vidc (struct address_info *hw_config)
{
  hw_config->irq = 0x14;
  hw_config->dma = DMA_VIRTUAL_SOUND;
  hw_config->card_subtype = 16;
  return 1;
}

void
unload_vidc (struct address_info *hw_config)
{
  snd_release_irq (hw_config->irq);
  sound_free_dma (hw_config->dma);
}
#endif
