/*
 * Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2000,2001,2002 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     draw.c,v
 * Revision: 1.12
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : draw.c.rca
 *  File Revision          : 1.2
 * 
 *  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
 *  ----------------------------------------
 *
 *          PrimeCell Color LCD Support
 *          ===========================
 *
 * Example basic graphics functions.
 *
*/

#include "../apcommon/aptypes.h"	        // Basic project definitions
#include "../apos/apos.h"			        // 'Operating system' definitions
#include "../apcommon/apbitops.h"	        // Bit manipulation macros
#include "apclcd.h"                         // API (public) header
#include "apdraw.h"                         // Private header

/*****************************************
** Static variables.
******************************************/

/*----------------------------------------------*/
/*
** Description:
**    Set an individual pixel to the selected colour.
**
** Inputs:
**    bpp         - the currently selected number of bits per pixel
**    offset      - the pixel number (from the start of the buffer) to set
**    base        - the buffer base address
**    color       - the color to set the pixel to
**    pixel_order - a flag which is set if the pixel order within a byte
**                  is bigendian.
*/
INLINE void apDRAW_SetPixel( apCLCD_eBpp bpp,
                             UWORD32 offset,
                             UWORD32 base,
                             UWORD32 color,
                             UWORD32 pixel_order
                           )
{
    UWORD32 log2bpp = bpp;
    switch (bpp)
    {
        case apCLCD_1BPP: // 1 bit  per pixel
        case apCLCD_2BPP: // 2 bits per pixel
        case apCLCD_4BPP: // 4 bits per pixel
        {
            UBYTE8 *dest;
            UWORD32 bit_offset;
            UWORD32 shift = 3-log2bpp;

            /* Calculate the address of the byte that contains the pixel */
            dest = (UBYTE8 *)base + (offset >> shift);

            /* Calculate the pixel position within the byte */
            bit_offset = (offset & ((UWORD32) ((UWORD32) 1 << shift)-1)) << log2bpp;

            if (pixel_order)
            {
                /* Swap the pixel order */
                bit_offset = bit_offset^((UWORD32)((UWORD32) 7<<log2bpp)&7);
            }

            /* Set the pixel */
            apBYTE_SET_FIELD(*dest, (UWORD32)1l << log2bpp, bit_offset, color);
        }
        break;

      case apCLCD_8BPP: // 8 bits per pixel
        ((UBYTE8 *)base)[offset] = (UBYTE8) color;
        break;

      case apCLCD_16BPP:    // 16 bits per pixel
        ((UHWD16 *)base)[offset] = (UHWD16) color;
        break;

      case apCLCD_24BPP:    // 24 bits per pixel
        ((UWORD32 *)base)[offset] = color;
        break;

      default:
        /*
        ** This apASSERT will always fail. If this point is reached.
        ** the BPP is invalid.
        */
        apASSERT( bpp == apCLCD_1BPP ||
                  bpp == apCLCD_2BPP ||
                  bpp == apCLCD_4BPP ||
                  bpp == apCLCD_8BPP ||
                  bpp == apCLCD_16BPP ||
                  bpp == apCLCD_24BPP);
    }
}


PUBLIC void apDRAW_SetPixelToColor( apOS_CLCD_oId oId, 
                                    CONST t2DPoint *pixel, 
                                    UWORD32 color
                                  )
{
    UWORD32 base, offset;

    offset = pixel->x + (pixel->y * apCLCD_LineWidthGet(oId)); // pixel offset
    base = apCLCD_DMAFrameBufferGet(oId);
    apDRAW_SetPixel(apCLCD_BppGet(oId), offset, base, color, apCLCD_PixelOrderGet(oId));
}


PUBLIC UWORD32 apDRAW_GetPixelColor(apOS_CLCD_oId oId, CONST t2DPoint *pixel)
{
    UWORD32 base, offset; 
    UWORD32 log2bpp;

    log2bpp = apCLCD_BppGet(oId);
    offset = pixel->x + (pixel->y * apCLCD_LineWidthGet(oId)); // pixel offset
    base = apCLCD_DMAFrameBufferGet(oId);

    switch (apCLCD_BppGet(oId))
    {
        case apCLCD_1BPP: // 1 bit  per pixel
        case apCLCD_2BPP: // 2 bits per pixel
        case apCLCD_4BPP: // 4 bits per pixel
        {
            UBYTE8 *dest;
            UWORD32 bit_offset;
            UWORD32 shift = 3 - log2bpp;

            dest = (UBYTE8 *)base + (offset >> shift);
            bit_offset = (offset & ((UWORD32)((UWORD32) 1<<shift)-1)) << log2bpp;
            if(apCLCD_PixelOrderGet(oId))
                bit_offset = bit_offset^((UWORD32)((UWORD32) 7<<log2bpp)&7);
            return apBIT_GET_FIELD(*dest, (UWORD32) 1<< log2bpp, bit_offset);
        }
        break;

      case apCLCD_8BPP: // 8 bits per pixel
        return ((UBYTE8 *)base)[offset];

      case apCLCD_16BPP:    // 16 bits per pixel
        return ((UHWD16 *)base)[offset];

      case apCLCD_24BPP:    // 24 bits per pixel
        return ((UWORD32 *)base)[offset];
        break;

      default:
        apASSERT(   apCLCD_BppGet(oId) == apCLCD_1BPP
                 || apCLCD_BppGet(oId) == apCLCD_2BPP
                 || apCLCD_BppGet(oId) == apCLCD_4BPP
                 || apCLCD_BppGet(oId) == apCLCD_8BPP
                 || apCLCD_BppGet(oId) == apCLCD_16BPP
                 || apCLCD_BppGet(oId) == apCLCD_24BPP
                );
    }
    return 0;
}


PUBLIC void apDRAW_DrawLine( apOS_CLCD_oId oId,
                             CONST t2DPoint *start,
                             CONST t2DPoint *end,
                             UWORD32 color
                           )
{
    UWORD32 base, offset;
    WORD32 max, min, count, countdown, long_inc, short_inc, scratch;

    long_inc = 1;
    short_inc = apCLCD_LineWidthGet(oId);
    offset = start->x + (start->y * short_inc);
    max = end->x - start->x;
    if (max < 0)
    {
        max = -max;
        long_inc = -long_inc;
    }
    min = end->y - start->y;
    if (min < 0)
    {
        min = -min;
        short_inc = -short_inc;
    }
    if (min > max)
    {
        // Swap 'long' and 'short' increments
        scratch = long_inc;
        long_inc = short_inc;
        short_inc = scratch;
        // Swap 'mix' and 'max'
        scratch = min;
        min = max;
        max = scratch;
    }
    base = apCLCD_DMAFrameBufferGet(oId);
    for(count = countdown = max; countdown != 0; --countdown)
    {
        apDRAW_SetPixel(apCLCD_BppGet(oId), offset, base, color, apCLCD_PixelOrderGet(oId));
        offset += long_inc;
        if((count -= min) < 0 )
        {
            count += max;
            offset += short_inc;
        }
    }
}

PUBLIC void apDRAW_RectFill( apOS_CLCD_oId oId,
                             CONST t2DPoint *pixel_topleft, 
                             CONST t2DPoint *pixel_botright,
                             UWORD32 fill_color
                           )
{
    UWORD32 head_mask, body, tail_mask, offset, panel_width, *dest;
    WORD32 width, height;
    UWORD32 log2bpp;

    log2bpp = apCLCD_BppGet(oId);
    dest = (UWORD32 *) apCLCD_DMAFrameBufferGet(oId);
    panel_width = apCLCD_LineWidthGet(oId);
    offset = pixel_topleft->x + (pixel_topleft->y * panel_width);   // PIXEL offset
    height = pixel_botright->y - pixel_topleft->y;
    
    /* Set up the parameters depending on the pixel size */
    switch(apCLCD_BppGet(oId))
    {
        case apCLCD_1BPP:               // 1 bit  per pixel, 32 pixels per word
        case apCLCD_2BPP:               // 2 bits per pixel, 16 pixels per word
        case apCLCD_4BPP:               // 4 bits per pixel, 8 pixels per word
        {
            UWORD32 shift      = 5-log2bpp;             // log2(pixels per word)
            UWORD32 ppw        = (UWORD32) 1<<shift;
            UWORD32 pwmask     = ppw -1;            // Max pixel number in a word
            UWORD32 tailbitnum = (pwmask - (pixel_botright->x & pwmask)) << log2bpp;
            UWORD32 headbitnum = (offset & pwmask) << log2bpp;
    
            body = fill_color & apBIT_MASK_FIELD(log2bpp+1,0);
            if (apCLCD_BppGet(oId) <= apCLCD_2BPP)
            {
                if (apCLCD_BppGet(oId) < apCLCD_2BPP)
                    body |= (body << 1);
                body |= (body << 2);
            }
            body |= (body << 4);
            body |= (body << 8);
            body |= (body << 16);
            dest += offset >> shift;
    
            if (apCLCD_PixelOrderGet(oId))
            {
                head_mask = 0xFFFFFF00 | (UWORD32)((UWORD32) 0x000000FF >> (headbitnum & 7));
                tail_mask = 0x00FFFFFF | (UWORD32)((UWORD32) 0xFF000000 << (tailbitnum & 7));
                headbitnum &= ~7;
                tailbitnum &= ~7;
            }
            else
            {
                head_mask = tail_mask = ~0U;
            }
            head_mask = head_mask << headbitnum;
            tail_mask = tail_mask >> tailbitnum;
    
            width = (pixel_botright->x >> shift) - (pixel_topleft->x >> shift) - 1;
            panel_width >>= shift;
        }
        break;

        case apCLCD_8BPP: // 8 bits per pixel, 4 pixels per word
        body = fill_color & 0xff;  // 0x000000Cc
        body |= (body << 8);        // 0x0000CcCc
        body |= (body << 16);       // 0xCcCcCcCc
        dest += offset / 4;
        head_mask = (UWORD32)(~0U) << ((offset % 4) * 8);
        tail_mask = (UWORD32)(~0U) >> ((3 - (pixel_botright->x % 4)) * 8);
        width = pixel_botright->x/4 - pixel_topleft->x/4 - 1;
        panel_width /= 4;
        break;

        case apCLCD_16BPP:    // 16 bits per pixel, 2 pixels per word
        body = fill_color;
        body |= (body << 16);
        dest += offset / 2;
        head_mask =            (offset % 2) ? 0xffff0000U : ~0;
        tail_mask = (pixel_botright->x % 2) ?          ~0 : 0xffffU;
        width = pixel_botright->x/2 - pixel_topleft->x/2 - 1;
        panel_width /=  2;
        break;

        case apCLCD_24BPP:    // 24 bits per pixel, 1 pixel per word
        body = fill_color;
        dest += offset;
        head_mask = ~0;
        tail_mask = ~0;
        width = pixel_botright->x - pixel_topleft->x - 1;
        break;

        default:
        apASSERT(   apCLCD_BppGet(oId) == apCLCD_1BPP
                 || apCLCD_BppGet(oId) == apCLCD_2BPP
                 || apCLCD_BppGet(oId) == apCLCD_4BPP
                 || apCLCD_BppGet(oId) == apCLCD_8BPP
                 || apCLCD_BppGet(oId) == apCLCD_16BPP
                 || apCLCD_BppGet(oId) == apCLCD_24BPP
                );
        return;
    }

    if (width == -1)
    {
        head_mask &= tail_mask;
        tail_mask = 0;
        width = 0;
    }

    /* Draw the box */
    while (height-- >= 0)
    {
        WORD32 count;

        *dest = (*dest & ~head_mask) | (body & head_mask);      // Write the head
        dest++;
        
        count = width;                                          // Write the body
        while (count-- != 0)
            *(dest++) = body;
            
        *dest = (*dest & ~tail_mask) | (body & tail_mask);      // Write the tail
        dest += panel_width - width - 1;
    }
}

PUBLIC void apDRAW_FontRender( apOS_CLCD_oId oId,
                               t2DPoint *pix_topleft,
                               UBYTE8 character,
                               CONST tFont font,
                               UWORD32 color,
                               UWORD32 background
                             )
{
    UWORD32 base, offset, y;

    offset = pix_topleft->x + (pix_topleft->y * apCLCD_LineWidthGet(oId)); // pixel offset
    base = apCLCD_DMAFrameBufferGet(oId);
    y = 8;
    while (y-- != 0)
    {
        UWORD32 x = 8;
        UBYTE8 c = font[character][7-y];
        while (x-- != 0)
        {
            UWORD32 plot_color = (c & (1 << x)) ? color : background;
            apDRAW_SetPixel( apCLCD_BppGet(oId),
                             offset,
                             base,
                             plot_color,
                             apCLCD_PixelOrderGet(oId)
                            );
            offset++;
        }
        offset += apCLCD_LineWidthGet(oId) - 8;
    }
    pix_topleft->x += 8;
}

PUBLIC void apDRAW_CLS(apOS_CLCD_oId oId, UWORD32 c)
{
    UWORD32 *wscr = (UWORD32 *)apCLCD_DMAFrameBufferGet(oId);
    UWORD32 wcol = c;
    UWORD32 bitpos;
    WORD32 x = apCLCD_LineWidthGet(oId) * apCLCD_LinesPerScreenGet(oId);

    switch (apCLCD_BppGet(oId))
    {
        case apCLCD_1BPP:
            x /= 16;
            bitpos = 1;
            break;
    
        case apCLCD_2BPP:
            x /= 8;
            bitpos = 2;
            break;
    
        case apCLCD_4BPP:
            x /= 4;
            bitpos = 4;
            break;
    
        case apCLCD_8BPP:
            x /= 2;
            bitpos = 8;
            break;
    
        case apCLCD_16BPP:
        default:
            bitpos = 16;    // No scaling needed: we want the number of halfwords
            break;
    
        case apCLCD_24BPP:
            x += x;                                 // x := x*2
            bitpos = 32;
            break;
    }

                            // Replicate the pixels to fill a word
    for (; bitpos < 32; bitpos *= 2)
    {
        wcol |= (wcol & (UWORD32)((UWORD32)1 << bitpos) - 1) << bitpos;
    }
    for (; (x -= 2) >= 0; *wscr++ = wcol)
    {
        ;
    }
    if(x == -1)
    {
        *(UHWD16 *)wscr = (UHWD16)wcol;
    }
}
