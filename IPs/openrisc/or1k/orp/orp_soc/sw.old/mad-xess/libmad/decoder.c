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
 * $Id: decoder.c,v 1.1 2002/03/28 20:38:51 lampret Exp $
 */

# ifdef HAVE_CONFIG_H
#  include "config.h"
# endif

# include "global.h"

# include "stream.h"
# include "frame.h"
# include "synth.h"
# include "decoder.h"

extern int test_button(void);

inline void mad_decoder_init(struct mad_decoder *decoder, void *data,
		      enum mad_flow (*input_func)(void *, struct mad_stream *),
		      enum mad_flow (*error_func)(void *, struct mad_stream *, struct mad_frame *frame))
{
  decoder->mode         = -1;

  decoder->options      = 0;

  decoder->sync         = 0;

  decoder->cb_data      = data;

  decoder->input_func   = input_func;
  decoder->error_func   = error_func;
}

inline
int mad_decoder_finish(struct mad_decoder *decoder)
{
  return 0;
}


/* Both parameters are required.  */
inline static
int run_sync(struct mad_decoder *decoder)
{
  enum mad_flow (*error_func)(void *, struct mad_stream *, struct mad_frame *);
  void *error_data;
  int bad_last_frame = 0;
  struct mad_stream *stream;
  struct mad_frame *frame;
  struct mad_synth *synth;
  int result = 0;

  error_func = decoder->error_func;
  error_data = decoder->cb_data;
  
  stream = &decoder->sync->stream;
  frame  = &decoder->sync->frame;
  synth  = &decoder->sync->synth;

  mad_stream_init(stream);
  mad_frame_init(frame);
  mad_synth_init(synth);

  mad_stream_options(stream, decoder->options);

  do {
    switch (decoder->input_func(decoder->cb_data, stream)) {
    case MAD_FLOW_STOP:
      goto done;
    case MAD_FLOW_BREAK:
      goto fail;
    case MAD_FLOW_IGNORE:
      continue;
    case MAD_FLOW_CONTINUE:
      break;
    }

    while (1) {
      if (mad_frame_decode(frame, stream) == -1) {
	if (!MAD_RECOVERABLE(stream->error))
	  break;

	error_func(error_data, stream, frame);
	goto done;	
      }
      else
	bad_last_frame = 0;

      mad_synth_frame(synth, frame);
      if(test_button())
        return 1;
    }
  }
  while (stream->error == MAD_ERROR_BUFLEN);

 fail:
  result = -1;

 done:
  mad_synth_finish(synth);
  mad_frame_finish(frame);
  mad_stream_finish(stream);

  return result;
}

inline int mad_decoder_run(struct mad_decoder *decoder, enum mad_decoder_mode mode)
{
  int result;
  struct dec_sync_struct sync;
  decoder->sync = &sync;

  result = run_sync(decoder);

  decoder->sync = 0;
  return result;
}
