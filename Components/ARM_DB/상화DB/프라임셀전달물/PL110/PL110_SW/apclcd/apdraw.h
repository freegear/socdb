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
 * File:     apdraw.h,v
 * Revision: 1.9
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : apdraw.h.rca
 *  File Revision          : 1.2
 * 
 *  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
 *  ----------------------------------------
 *  
 *            PrimeCell Color LCD Support
 *            ===========================
*/

#ifndef APDRAW_H
#define APDRAW_H

#ifdef	__cplusplus
extern "C" {	/* allow C++ to use these headers */
#endif	/* __cplusplus */

/*======================================================================*/
/*
 * Description:
 *   Type definition for a two-dimensional {x,y} point.
 *
 * Remarks:
 *   Used to define pixel coordinates for the graphics functions.
 *   Each pixel is mapped to an (x,y)-coordinate on the LCD panel using the 
 *   following axes:
 *  
 *      - origin (0,0): top-left corner of the LCD panel
 *      - increasing x-coordinate: left-to-right across the LCD panel
 *      - increasing y-coordinate: top-to-bottom down the LCD panel
 */
 
typedef struct tag2DPoint
{
  WORD32 x ; // X coordinate
  WORD32 y ; // Y coordinate
} t2DPoint;
typedef t2DPoint *pt2DPoint ;    // Pointer to point object.

typedef UBYTE8      tFontChar[ 8 ] ; // Type definition for 8x8 character.
typedef tFontChar   tFont[ 256 ] ;   // Type definition for 256-character 8x8 font.

/*======================================================================*/
/*
 * Description: 
 *   Implementing Functions for each Pixel Depth
 *   
 * Remarks:
 *   The following functions must operate over each of the possible pixel depths 
 *   supported by the LCD block:
 *  
 *      + apDRAW_SetPixelToColor
 *      + apDRAW_GetPixelColor
 *      + apDRAW_DrawLine
 *      + apDRAW_RectFill
 *      + apDRAW_FontRender
 *  
 *   The pixel-map is defined in memory as a one-dimensional contiguous block 
 *   with each row of the map starting at the next memory address for a pixel
 *   after the last pixel of the previous row of the pixel-map.
 *  
 *   The pixel depth defines the number of bits per pixel and, therefore, the
 *   number of bits that must be added to the memory address for a current pixel
 *   location to update the address to the next pixel location.
 *  
 *   For each function, therefore, it must distinguish the pixel depth set for 
 *   the LCD panel by calling the function apCLCD_eBppGet()
 *  
 *   Each pixel location in memory is then defined from the memory base address as:
 *  
 *   ( (y-coordinate of pixel) * (pixels per line) * (bits per pixel) ) + 
 *   ( (x-coordinate of pixel) * (bits per pixel) )
 *  
 *   These functions must get the address of the frame store by calling function
 *   apDRAW_GetDMAFrameBuffer(). The functions apCLCD_LinesPerScreen() and
 *   apCLCD_LineWidth() provide the height and width of the active screen area.
 *   apCLCD_eBppGet() is used to determine the memory usage for each pixel, and
 *   apCLCD_ePixelOrderGet() gives the ordering of the data.
 *   For dual panel LCDs these functions assume that the frame store for the lower
 *   panel follows on directly in memory from the frame store for the upper panel
 *   (with no padding in between). Thus only the start of the pair of frame stores
 *   in this case is required (as these functions treat it just like a single panel).
 *  
*/


/*======================================================================*/
/*
 * Description:
 *   Sets the color for the given pixel on the LCD panel mapping the logical 
 *   pixel color given to a physical color appropriately for the pixel depth 
 *   set for the LCD panel.
 *  
 * Implementation:
 *   For each of the possible pixel depths (see Implementing Functions for 
 *   each Pixel Depth):
 *  
 *      1. locate the address of the given pixel in memory
 *      2. write the given logical color to the pixel's memory location in the 
 *         correct number of bits defined by the pixel depth
 *  
 * Inputs:
 *     oId - selects the LCD data to be referenced.
 *     pixel - the two-dimensional coordinate of the pixel to set the color for
 *     color - the color to set for the given pixel - only the low bits of color, upto
 *       the bits per pixel setting for the LCD panel, are used to set the color, any
 *       remaining bits being ignored
 *   
 */
PUBLIC void apDRAW_SetPixelToColor( apOS_CLCD_oId oId,
                                    CONST t2DPoint *pixel,
                                    UWORD32 color
                                  );


/*======================================================================*/
/*
 * Description:
 *   Reads the logical pixel color for the given pixel on the LCD panel as
 *   appropriate for the pixel depth for the LCD panel.
 *  
 * Implementation:
 *   For each of the possible pixel depths (see Implementing Functions for 
 *   each Pixel Depth):
 *  
 *      1. locate the address of the given pixel in memory
 *      2. read the correct number of bits for the logical color, as defined by
 *         the pixel depth set for the LCD panel, from the pixel's memory location
 *  
 * Inputs:
 *     oId - selects the LCD data to be referenced.
 *     pixel - the two-dimensional coordinate of the pixel to set the color for
 *  
 * Return value:
 *   the color of the given pixel
 *   
 */
PUBLIC UWORD32 apDRAW_GetPixelColor(apOS_CLCD_oId oId,  CONST t2DPoint *pixel);


/*======================================================================*/
/*
 * Description:
 *   Draws a line of single pixel thickness in the specified color between the 
 *   two pixel coordinates given mapping the logical pixel color given to a 
 *   physical color appropriately for the pixel depth set for the LCD panel.
 *  
 * Implementation:
 *   For each of the possible pixel depths (see Implementing Functions for 
 *   each Pixel Depth):
 *  
 *    1 locate the address of the given starting pixel in memory
 *
 *    2 determine the modulus of both the x- and y-coordinate pixel distance 
 *         between the two line end-points given and the maximum of these two
 *         distances
 *
 *    3 define a local counter which is initialised to zero and a copy of the
 *         maximum distance over the (x,y)-coordinate distances
 *
 *    4 starting at the line-start pixel address loop while the copy of the 
 *         maximum distance is non-zero, decrementing the copy of the maximum 
 *         distance by 1 with each iteration
 *
 *    +a write the given logical color to the current pixel's memory 
 *     location in the correct number of bits defined by the pixel depth
 *
 *    +b increment the current pixel address to the next pixel memory
 *     location either by adding or subtracting
 *     (bits per pixel)*(next pixel incremeter) where:
 *
 *      - the increment is added if the coordinate that relates to the 
 *        maximum distance is increasing between the start of the line
 *        and the end of the line or subtracted otherwise
 *
 *      - (next pixel incremeter) is either the actual next pixel
 *        location in memory if the maximum distance relates to the
 *        x-coordinate or the number of pixels per line if the maximum
 *        distance relates to the y-coordinate
 *
 *    +c increment the local counter with the smaller start-end pixel
 *       distance
 *
 *    +d if the local counter is greater than the actual maximum distance
 *       update the current pixel address by either adding or subtracting
 *       as in case (b) but for the coordinate that relates to the smaller
 *       distance, and subtract the maximum distance from the local counter
 *  
 *  
 * Inputs:
 *    oId - selects the LCD data to be referenced.
 *    pixel_start - the two-dimensional coordinate of the pixel at one end of the line to draw
 *    pixel_end - the two-dimensional coordinate of the pixel at the other end of the line to
 *      draw
 *    line_color - the color to draw the line - only the low bits of line_color, upto
 *      the bits per pixel setting for the LCD panel, are used to set the color, any
 *      remaining bits being ignored
 *   
 */
PUBLIC void apDRAW_DrawLine(apOS_CLCD_oId oId, 
                            CONST t2DPoint *pixel_start,
                            CONST t2DPoint *pixel_end, 
                            UWORD32 line_color
                           );

/*======================================================================*/
/*
 * Description:
 *   Draws and fills a rectangle in the specified color with the top-left
 *   and bottom-right corners given to define the rectangle outline, mapping the 
 *   logical pixel color given to a physical color appropriately for the pixel 
 *   depth set for the LCD panel.
 *  
 * Implementation:
 *   For each of the possible pixel depths (see Implementing Functions for 
 *   each Pixel Depth):
 *  
 *    1. locate the address of the pixel at the top-left corner in memory
 *
 *    2. determine the modulus of both the x- and y-coordinate pixel distance 
 *       between the two corners given to get width and height of the rectangle
 *
 *    3. starting at the top-left pixel address loop while the height of the
 *       rectangle is non-zero, decrementing the height by 1 with each iteration
 *
 *    a. write the given logical color to the block of memory that covers
 *       from the current pixel location to the last pixel across the
 *       x-axis that defines a row in the same y-coordinate plane with
 *       width number of pixels, writing the color for each pixel to the 
 *       correct number of bits defined by the pixel depth
 *
 *    b. increment the current pixel location to the pixel in the same
 *       x-coordinate plane as the first pixel on the current line of
 *       the rectangle but one-row down the LCD panel - that is the 
 *       memory location of the pixel at start of current row + 
 *       (bits per pixel depth)*(pixels per line)
 *  
 *  
 * Inputs:
 *     oId - selects the LCD data to be referenced.
 *     pixel_topleft - the two-dimensional coordinate of the pixel at the
 *      top-left corner of the rectangle to draw
 *     pixel_botright - the two-dimensional coordinate of the pixel at the
 *       bottom-right corner of the rectangle to draw
 *     fill_color - the color to fill the rectangle - only the low bits of
 *     fill_color, upto the bits per pixel setting for the LCD panel, are used
 *     to set the color, any remaining bits being ignored
 *   
 */
PUBLIC void apDRAW_RectFill( apOS_CLCD_oId oId, 
                             CONST t2DPoint *pixel_topleft, 
                             CONST t2DPoint *pixel_botright,
                             UWORD32 fill_color
                           );

/*======================================================================*/
/*
 * Description:
 *   Renders the given character in the specified color with the top-left
 *   pixel in the character given, mapping the logical pixel color given to a 
 *   physical color appropriately for the pixel depth set for the LCD panel.
 *  
 * Implementation:
 *   For each of the possible pixel depths (see Implementing Functions for 
 *   each Pixel Depth):
 *  
 *    1. locate the address of the pixel at the top-left corner in memory
 *
 *    2. define a local counter height and initialise it to 8
 *
 *    3. starting at the top-left pixel address loop while the local counter
 *       height is non-zero, decrementing height by 1 with each iteration
 *    
 *       +a. for each of the 8 bits of font[character][8-height]
 *
 *         i) if the current bit is set write the given logical color 
 *            to the current pixel location to the correct number of 
 *            bits defined by the pixel depth else write the background
 *            color
 *
 *         ii) increment the pixel location to the next pixel in the same
 *            y-coordinate plane as the current pixel location by the
 *            number of bits per pixel
 *
 *        +b. increment the current pixel location to the pixel in the same
 *            x-coordinate plane as the first pixel on any line of the
 *            character but one-row down the LCD panel - that is the 
 *            memory location of the pixel at start of current line + 
 *            (bits per pixel depth)*(pixels per line)
 *
 *    4. assuming the given pixel location for the character rendered is (x,y)
 *                define the return pixel location as (x+8,y)
 *  
 * Inputs:
 *  oId - selects the LCD data to be referenced.
 *  pixel_topleft - the two-dimensional coordinate of the pixel at the
 *                  top-left corner of the character to draw
 *  character - the character to render
 *  font - full font definition including the character to render
 *  color - the color to render the character - only the low bits of color, 
 *          up to the bits per pixel setting for the LCD panel, 
 *          are used to set the color, any remaining bits being ignored
 *  background - the color for the background of the characters
 *   
 * Outputs:
 *     pixel_topleft - the two-dimensional coordinate of the pixel at the
 *      top-left corner of the next character position
 *  
 */
PUBLIC void apDRAW_FontRender( apOS_CLCD_oId oId,
                               t2DPoint * pixel_topleft,
                               UBYTE8 character, 
                               CONST tFont font,
                               UWORD32 color,
                               UWORD32 background
                             );

/*======================================================================*/
/*
 * Description:
 *   Clears the screen to the specified color.
 *  
 * Implementation:
 *   Forms a word filled with the color replicated as necessary, then
 *   fills the screen memory a word at a time.
 *
 * Inputs:
 *   c - color to fill with.
 */
PUBLIC void apDRAW_CLS(apOS_CLCD_oId oId, UWORD32 c);

#ifdef __cplusplus
} /* allow C++ to use these headers */
#endif	/* __cplusplus */

#endif  /* _apdraw_h_ */
