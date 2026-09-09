/***************************************************************************
 *             __________               __   ___.
 *   Open      \______   \ ____   ____ |  | _\_ |__   _______  ___
 *   Source     |       _//  _ \_/ ___\|  |/ /| __ \ /  _ \  \/  /
 *   Jukebox    |    |   (  <_> )  \___|    < | \_\ (  <_> > <  <
 *   Firmware   |____|_  /\____/ \___  >__|_ \|___  /\____/__/\_ \
 *                     \/            \/     \/    \/            \/
 * $Id: sound.c,v 1.15 2005/08/29 21:15:20 amiconn Exp $
 *
 * Copyright (C) 2005 by Linus Nielsen Feltzing
 *
 * All files in this archive are subject to the GNU General Public License.
 * See the file COPYING in the source tree root for full license agreement.
 *
 * This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
 * KIND, either express or implied.
 *
 ****************************************************************************/
#include <stdbool.h>
#include <stdio.h>
#include "config.h"
#include "sound.h"

//#include "i2c.h"
#include "mas.h"
//#include "dac.h"
#include "system.h"
#include "hwcompat.h"
#if CONFIG_CODEC == SWCODEC
#include "pcm_playback.h"
#endif


extern bool audio_is_initialized;


#if (CONFIG_CODEC == MAS3587F) || (CONFIG_CODEC == MAS3539F)
extern unsigned long shadow_io_control_main;
extern unsigned shadow_codec_reg0;
#endif

static const char* const units[] =
{
    "%",    /* Volume */
    "dB",   /* Bass */
    "dB",   /* Treble */
    "%",    /* Balance */
    "dB",   /* Loudness */
    "",     /* AVC */
    "",     /* Channels */
    "%",    /* Stereo width */
    "dB",   /* Left gain */
    "dB",   /* Right gain */
    "dB",   /* Mic gain */
    "dB",   /* MDB Strength */
    "%",    /* MDB Harmonics */
    "Hz",   /* MDB Center */
    "Hz",   /* MDB Shape */
    "",     /* MDB Enable */
    "",     /* Super bass */
};

static const int numdecimals[] =
{
    0,    /* Volume */
    0,    /* Bass */
    0,    /* Treble */
    0,    /* Balance */
    0,    /* Loudness */
    0,    /* AVC */
    0,    /* Channels */
    0,    /* Stereo width */
    1,    /* Left gain */
    1,    /* Right gain */
    1,    /* Mic gain */
    0,    /* MDB Strength */
    0,    /* MDB Harmonics */
    0,    /* MDB Center */
    0,    /* MDB Shape */
    0,    /* MDB Enable */
    0,    /* Super bass */
};

static const int steps[] =
{
    1,    /* Volume */
#ifdef HAVE_UDA1380
    2,    /* Bass */
    2,    /* Treble */
#else
    1,    /* Bass */
    1,    /* Treble */
#endif
    1,    /* Balance */
    1,    /* Loudness */
    1,    /* AVC */
    1,    /* Channels */
    1,    /* Stereo width */
    1,    /* Left gain */
    1,    /* Right gain */
    1,    /* Mic gain */
    1,    /* MDB Strength */
    1,    /* MDB Harmonics */
    10,   /* MDB Center */
    10,   /* MDB Shape */
    1,    /* MDB Enable */
    1,    /* Super bass */
};

static const int minval[] =
{
    0,    /* Volume */
#if (CONFIG_CODEC == MAS3587F) || (CONFIG_CODEC == MAS3539F)
    -12,  /* Bass */
    -12,  /* Treble */
#elif defined(HAVE_UDA1380)
    0,    /* Bass */
    0,    /* Treble */
#else
    -15,  /* Bass */
    -15,  /* Treble */
#endif
    -100,  /* Balance */
    0,    /* Loudness */
    -1,   /* AVC */
    0,    /* Channels */
    0,    /* Stereo width */
    0,    /* Left gain */
    0,    /* Right gain */
    0,    /* Mic gain */
    0,    /* MDB Strength */
    0,    /* MDB Harmonics */
    20,   /* MDB Center */
    50,   /* MDB Shape */
    0,    /* MDB Enable */
    0,    /* Super bass */
};

static const int maxval[] =
{
    100,  /* Volume */
#if (CONFIG_CODEC == MAS3587F) || (CONFIG_CODEC == MAS3539F)
    12,   /* Bass */
    12,   /* Treble */
#elif defined(HAVE_UDA1380)
    24,   /* Bass */
    6,    /* Treble */
#else
    15,   /* Bass */
    15,   /* Treble */
#endif
    100,   /* Balance */
    17,   /* Loudness */
    4,    /* AVC */
    5,    /* Channels */
    255,  /* Stereo width */
    15,   /* Left gain */
    15,   /* Right gain */
    15,   /* Mic gain */
    127,  /* MDB Strength */
    100,  /* MDB Harmonics */
    300,  /* MDB Center */
    300,  /* MDB Shape */
    1,    /* MDB Enable */
    1,    /* Super bass */
};

static const int defaultval[] =
{
    70,   /* Volume */
#if (CONFIG_CODEC == MAS3587F) || (CONFIG_CODEC == MAS3539F)
    6,    /* Bass */
    6,    /* Treble */
#elif defined(HAVE_UDA1380)
    0,    /* Bass */
    0,    /* Treble */
#else
    7,    /* Bass */
    7,    /* Treble */
#endif
    0,    /* Balance */
    0,    /* Loudness */
    0,    /* AVC */
    0,    /* Channels */
    100,  /* Stereo width */
    8,    /* Left gain */
    8,    /* Right gain */
    2,    /* Mic gain */
    50,   /* MDB Strength */
    48,   /* MDB Harmonics */
    60,   /* MDB Center */
    90,   /* MDB Shape */
    0,    /* MDB Enable */
    0,    /* Super bass */
};

const char *sound_unit(int setting)
{
    return units[setting];
}

int sound_numdecimals(int setting)
{
    return numdecimals[setting];
}

int sound_steps(int setting)
{
    return steps[setting];
}

int sound_min(int setting)
{
    return minval[setting];
}

int sound_max(int setting)
{
    return maxval[setting];
}

int sound_default(int setting)
{
    return defaultval[setting];
}

int channel_configuration = SOUND_CHAN_STEREO;
int stereo_width = 100;

static void set_channel_config(void)
{
    /* default values: stereo */
    unsigned long val_ll = 0x80000;
    unsigned long val_lr = 0;
    unsigned long val_rl = 0;
    unsigned long val_rr = 0x80000;
    
    switch(channel_configuration)
    {
        /* case SOUND_CHAN_STEREO unnecessary */

        case SOUND_CHAN_MONO:
            val_ll = 0xc0000;
            val_lr = 0xc0000;
            val_rl = 0xc0000;
            val_rr = 0xc0000;
            break;

        case SOUND_CHAN_CUSTOM:
            {
                /* fixed point variables (matching MAS internal format)
                   integer part: upper 13 bits (inlcuding sign)
                   fractional part: lower 19 bits */
                long fp_width, fp_straight, fp_cross;
                
                fp_width = (stereo_width << 19) / 100;
                if (stereo_width <= 100)
                {
                    fp_straight = - ((1<<19) + fp_width) / 2;
                    fp_cross = fp_straight + fp_width;
                }
                else
                {
                    fp_straight = - (1<<19);
                    fp_cross = ((2 * fp_width / (((1<<19) + fp_width) >> 10))
                                << 9) - (1<<19);
                }
                val_ll = val_rr = fp_straight & 0xFFFFF;
                val_lr = val_rl = fp_cross & 0xFFFFF;
            }
            break;

        case SOUND_CHAN_MONO_LEFT:
            val_ll = 0x80000;
            val_lr = 0x80000;
            val_rl = 0;
            val_rr = 0;
            break;

        case SOUND_CHAN_MONO_RIGHT:
            val_ll = 0;
            val_lr = 0;
            val_rl = 0x80000;
            val_rr = 0x80000;
            break;

        case SOUND_CHAN_KARAOKE:
            val_ll = 0x80001;
            val_lr = 0x7ffff;
            val_rl = 0x7ffff;
            val_rr = 0x80001;
            break;
    }

#if (CONFIG_CODEC == MAS3587F)
    mas_writemem(MAS_BANK_D0, MAS_D0_OUT_LL, &val_ll, 1); /* LL */
    mas_writemem(MAS_BANK_D0, MAS_D0_OUT_LR, &val_lr, 1); /* LR */
    mas_writemem(MAS_BANK_D0, MAS_D0_OUT_RL, &val_rl, 1); /* RL */
    mas_writemem(MAS_BANK_D0, MAS_D0_OUT_RR, &val_rr, 1); /* RR */
#endif
}

#if (CONFIG_CODEC == MAS3587F)
unsigned long mdb_shape_shadow = 0;
unsigned long loudness_shadow = 0;
#endif

void sound_set(int setting, int value)
{
#if (CONFIG_CODEC == MAS3587F)
    int tmp;
#endif

    if(!audio_is_initialized)
        return;
    
    switch(setting)
    {
        case SOUND_VOLUME:
#if (CONFIG_CODEC == MAS3587F)
            tmp = 0x7f00 * value / 100;
            mas_codec_writereg(0x10, tmp & 0xff00);
#endif
            break;

        case SOUND_BALANCE:
#if (CONFIG_CODEC == MAS3587F)
            tmp = ((value * 127 / 100) & 0xff) << 8;
            mas_codec_writereg(0x11, tmp & 0xff00);
#endif
            break;

        case SOUND_BASS:
#if (CONFIG_CODEC == MAS3587F)
            tmp = ((value * 8) & 0xff) << 8;
            mas_codec_writereg(0x14, tmp & 0xff00);
#endif
            break;

        case SOUND_TREBLE:
#if (CONFIG_CODEC == MAS3587F)
            tmp = ((value * 8) & 0xff) << 8;
            mas_codec_writereg(0x15, tmp & 0xff00);
#endif
            break;
            
#if (CONFIG_CODEC == MAS3587F)
        case SOUND_LOUDNESS:
            loudness_shadow = (loudness_shadow & 0x04) |
                (MAX(MIN(value * 4, 0x44), 0) << 8);
            mas_codec_writereg(MAS_REG_KLOUDNESS, loudness_shadow);
            break;
            
        case SOUND_AVC:
            switch (value) {
                case 1: /* 20ms */
                    tmp = (0x1 << 8) | (0x8 << 12);
                    break;
                case 2: /* 2s */
                    tmp = (0x2 << 8) | (0x8 << 12);
                    break;
                case 3: /* 4s */
                    tmp = (0x4 << 8) | (0x8 << 12);
                    break;
                case 4: /* 8s */
                    tmp = (0x8 << 8) | (0x8 << 12);
                    break;
                case -1: /* turn off and then turn on again to decay quickly */
                    tmp = mas_codec_readreg(MAS_REG_KAVC);
                    mas_codec_writereg(MAS_REG_KAVC, 0);
                    break;
                default: /* off */
                    tmp = 0;
                    break;  
            }
            mas_codec_writereg(MAS_REG_KAVC, tmp);
            break;

        case SOUND_MDB_STRENGTH:
            mas_codec_writereg(MAS_REG_KMDB_STR, (value & 0x7f) << 8);
            break;
          
        case SOUND_MDB_HARMONICS:
            tmp = value * 127 / 100;
            mas_codec_writereg(MAS_REG_KMDB_HAR, (tmp & 0x7f) << 8);
            break;
          
        case SOUND_MDB_CENTER:
            mas_codec_writereg(MAS_REG_KMDB_FC, (value/10) << 8);
            break;
          
        case SOUND_MDB_SHAPE:
            mdb_shape_shadow = (mdb_shape_shadow & 0x02) | ((value/10) << 8);
            mas_codec_writereg(MAS_REG_KMDB_SWITCH, mdb_shape_shadow);
            break;
          
        case SOUND_MDB_ENABLE:
            mdb_shape_shadow = (mdb_shape_shadow & ~0x02) | (value?2:0);
            mas_codec_writereg(MAS_REG_KMDB_SWITCH, mdb_shape_shadow);
            break;
          
        case SOUND_SUPERBASS:
            loudness_shadow = (loudness_shadow & ~0x04) |
                (value?4:0);
            mas_codec_writereg(MAS_REG_KLOUDNESS, loudness_shadow);
            break;
#endif            
        case SOUND_CHANNELS:
            channel_configuration = value;
            set_channel_config();
            break;
        
        case SOUND_STEREO_WIDTH:
            stereo_width = value;
            if (channel_configuration == SOUND_CHAN_CUSTOM)
                set_channel_config();
            break;
    }
}

int sound_val2phys(int setting, int value)
{
#if (CONFIG_CODEC == MAS3587F)
    int result = 0;
    
    switch(setting)
    {
        case SOUND_LEFT_GAIN:
        case SOUND_RIGHT_GAIN:
            result = (value - 2) * 15;
            break;

        case SOUND_MIC_GAIN:
            result = value * 15 + 210;
            break;

       default:
            result = value;
            break;
    }
    return result;
#endif
}

#if (CONFIG_CODEC == MAS3587F)
/* This function works by telling the decoder that we have another
   crystal frequency than we actually have. It will adjust its internal
   parameters and the result is that the audio is played at another pitch.

   The pitch value is in tenths of percent.
*/
static int last_pitch = 1000;

void sound_set_pitch(int pitch)
{
    unsigned long val;

    if (pitch != last_pitch)
    {
        /* Calculate the new (bogus) frequency */
        val = 18432 * 1000 / pitch;
    
        mas_writemem(MAS_BANK_D0, MAS_D0_OFREQ_CONTROL, &val, 1);

        /* We must tell the MAS that the frequency has changed.
         * This will unfortunately cause a short silence. */
        mas_writemem(MAS_BANK_D0, MAS_D0_IO_CONTROL_MAIN, &shadow_io_control_main, 1);
        
        last_pitch = pitch;
    }
}

int sound_get_pitch(void)
{
    return last_pitch;
}
#endif

