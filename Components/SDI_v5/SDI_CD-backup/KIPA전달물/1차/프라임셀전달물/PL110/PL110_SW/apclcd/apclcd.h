/*
 * Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2000,2001,2002,2003 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     apclcd.h,v
 * Revision: 1.22
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : apclcd.h.rca
 *  File Revision          : 1.4
 * 
 *  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
 *  ----------------------------------------
 *
 *          PrimeCell Color LCD Device Drivers
 *          ===================================
 *
*/

#ifndef APCLCD_H
#define APCLCD_H

#ifdef	__cplusplus
extern "C" {	/* allow C++ to use these headers */
#endif	/* __cplusplus */

/* Sets the revision of the CLCD hardware because register structure is different between
 * PL110(revision r1p2 or latter) and PL111
 */
#define PL110 110
#define PL111 111

#define apCLCD_VERSION PL110

/*
 * Because of variations between specific LCD displays there may be some
 * initialisation which cannot be generalised, and that must be done before
 * or during power up.
 * Provision is made for three user-defined functions:
 * 1) Called before any initialisation of the PrimeCell.
 * 2) Called at the start of the standard power-up sequence.
 * 3) Called after power-up is complete.
 * If these functions are not needed, this definition should be removed and 
 * the codes that uses them will not be compiled
 */
#define apCLCD_USER_SETUP FALSE

/*
 * Time out value for waiting for VComp bit to be set   
 */
#define apCLCD_VCOMP_TIMEOUT_VALUE 100000

/*
 * Description:
 * General errors for this module.
 *
 */
typedef enum apCLCD_xError
{
    apCLCD_PALETTE_TOO_BIG = apERR_CLCD_START,
    apCLCD_INCORRECT_WIDTH,         // Conflicting LCD setting. Display
                                    // width must be a multiple of 16 pixels
    apCLCD_NO_SETTING,              // Required configuration value missing
    apCLCD_INVALID_DISPLAY_TYPE,    // Display options incompatible or wrong
    apCLCD_NO_AC_BIAS,              // STN displays must have AC bias
    apCLCD_INVALID_BPP,             // Bits Per Pixel cannot be achieved, greater than
                                    // 24 for STN, or greater than 16 for TFT display
    apCLCD_VCOMP_TIMEOUT            // Vcomp was not set during time-out period                                
                                    
} apCLCD_eError;


/*======================================================================*/
/*
 * Description:
 *   Color LCD Panel Type Enumerator. 
 *   Definitions of the possible LCD panel types for the color LCD. Used
 *   in the display parameters structure.
 *
 * Remarks:
 *   Set the appropriate value in the apCLCD_sDisplayParams structure
 *   passed to apCLCD_PanelInitialize.
 */
typedef enum apCLCD_xType
{
    apCLCD_STN = 0, // Selects an Super Twisted Nematic display
    apCLCD_TFT = 1  // Selects a Thin Film Transistor display
} apCLCD_eType;
 

/*======================================================================*/
/*
 * Description:
 *   Color LCD STN Color Enumerator.
 *
 * Remarks:
 *   Definitions of the possible types of STN LCD. Used in the display
 *   parameters structure.
 *   Set the appropriate value in the apCLCD_sDisplayParams structure
 *   passed to apCLCD_PanelInitialize.
 *   Ignored if the display type selected (apCLCD_eType) is TFT
 */
typedef enum apCLCD_xSTN_CType 
{
    apCLCD_STN_COLOR = 0,   // STN LCD is color
    apCLCD_STN_MONO  = 1    // STN LCD is monochrome
} apCLCD_eSTN_CType;


/*======================================================================*/
/*
 * Description:
 *   Color LCD STN x-Bits Per Pixel Interface Enumerator.
 *
 * Remarks:
 *   Definitions of the possible parallel interfaces for a monochrome STN
 *   LCD used in the display parameters structure.
 *   Set the appropriate value in the apCLCD_sDisplayParams structure
 *   passed to apCLCD_PanelInitialize.
 *   Ignored if the display type selected is TFT
 */
typedef enum apCLCD_xSTN_Iface 
{
    apCLCD_STN_4BIT = 0,    // 4 bit parallel interface
    apCLCD_STN_8BIT = 1     // 8 bit parallel interface
} apCLCD_eSTN_Iface;


/*======================================================================*/
/*
 * Description:
 *   Color LCD STN Dual Panel Enumerator.
 *
 * Remarks:
 *   Definitions of the possible number of panels for the color LCD.
 *   Used in the display parameters structure.
 *   Set the appropriate value in the apCLCD_sDisplayParams structure
 *   passed to apCLCD_PanelInitialize.
 *   Ignored if the display type selected is TFT
 */
typedef enum apCLCD_xSTN_Panel 
{
    apCLCD_STN_SINGLE = 0,  // Selects a single panel STN LCD
    apCLCD_STN_DUAL   = 1   // Selects a dual panel STN LCD
} apCLCD_eSTN_Panel;


/*======================================================================*/
/*
 * Description:
 *   Color LCD VComp Interrupt Time Enumerator.
 *
 * Remarks:
 *   Definitions of the possible timing for LCD vertical compare (VComp)
 *   interrupt. Used in the display parameters structure.
 *   Care is needed if selecting start of Front or Back Porch. With STN
 *   displays these values are typically set to zero and in this case the
 *   corresponding VComp events and their interrupts can never happen, even
 *   if enabled.
 *   Set the appropriate value in the apCLCD_sDisplayParams structure
 *   passed to apCLCD_PanelInitialize.
 *   Used as an argument to the apCLCD_EnableVCompEvents() function.
 */
typedef enum apCLCD_xVComp_ITime 
{
    apCLCD_VSYNC    = 0,            // Start of VSync
    apCLCD_BACK_P   = 1,            // Start of Back Porch
    apCLCD_ACTIVE_V = 2,            // Start of Active Video
    apCLCD_FRONT_P  = 3             // Start of Front Porch
} apCLCD_eVComp_ITime;

 
/*======================================================================*/
/*
 * Description:
 *   Color LCD reload time Enumerator.
 *
 * Remarks:
 *   Definitions of the possible DMA reload timings for the color LCD.
 *   Used in the display parameters structure.
 *   Set the appropriate value in the apCLCD_sDisplayParams structure
 *   passed to apCLCD_PanelInitialize.
 */
typedef enum apCLCD_xReload 
{
    apCLCD_RELOAD_EARLY = 0,    // Load more data when FIFO has 4 slots
    apCLCD_RELOAD_LATE  = 1     // Load more data when FIFO has 8 slots
} apCLCD_eReload;

 
/*======================================================================*/
/*
 * Description:
 *   Color LCD RGB format Enumerator.
 *
 * Remarks:
 *   Definitions of the possible pixel component orderings for the
 *   color LCD used in the display parameters structure.
 *   Set the appropriate value in the apCLCD_sDisplayParams structure
 *   passed to apCLCD_PanelInitialize.
 */
typedef enum apCLCD_xColorOrder 
{
    apCLCD_RGB   = 0,     // Pixels are in R/G/B format
    apCLCD_BGR   = 1      // Pixels are in B/G/R format
} apCLCD_eColorOrder;

 
/*======================================================================*/
/*
 * Description:
 *   Color LCD pixel order format Enumerator.
 *
 * Remarks:
 *   Definitions of the possible pixel orderings within a byte for the
 *   color LCD. Used in the display parameters structure.
 *   Set the appropriate value in the apCLCD_sDisplayParams structure
 *   passed to apCLCD_PanelInitialize.
 *   The ordering of pixels within a word is set to match the compilation
 *   options. Rebuild the driver with a bigendian target set to change
 *   the LCD word order selected.
 */
typedef enum apCLCD_xPixelOrder 
{
    apCLCD_LITTLE_ENDIAN_BYTES = 0,     // Leftmost pixel is at bit 0
    apCLCD_BIG_ENDIAN_BYTES    = 1      // Leftmost pixel is at bit 7
} apCLCD_ePixelOrder;

 
/*======================================================================*/
/*
 * Description:
 *   Color LCD clock source Enumerator.
 *
 * Remarks:
 *   Definitions of the input clock sources for the color LCD. Used in
 *   the display parameters structure.
 *   Set the appropriate value in the apCLCD_sDisplayParams structure
 *   passed to apCLCD_PanelInitialize.
 *   
 */
typedef enum apCLCD_xClockSource 
{
    apCLCD_INTERNAL_CLOCK   = 0,  // Clock is HCLCK
    apCLCD_EXTERNAL_CLOCK   = 1   // Clock is external source
} apCLCD_eClockSource;

 
/*======================================================================*/
/*
 * Description:
 *   Color LCD Interrupt Type Definitions.
 *
 * Remarks:
 *   Definitions of the possible types of LCD event that can be set in the
 *   PrimeCell status register. These events can raise an interrupt if
 *   the equivalent bit is set in the interrupt enable register, or
 *   alternatively the status register can be polled to detect the event.
 *   Pass a bitmask formed by ORing together these options to the
 *   apCLCD_InterruptEventsEnable and apCLCD_InterruptEventsDisable
 *   functions as required.
 *
 *   These are also used as reason codes when calling the callback
 *   handler (for efficiency).
 */
typedef enum apCLCD_xInterrupts 
{
    apCLCD_NO_INTERRUPTS = (UWORD32)0,      // Mask with all interrupts clear
    apCLCD_FUF           = (UWORD32)0x2,    // FIFO underflow
    apCLCD_NEXT_BASE_UP  = (UWORD32)0x4,    // DMA base address update
    apCLCD_VCOMP         = (UWORD32)0x8,    // Vertical compare
    apCLCD_MBERR         = (UWORD32)0x10,   // AHB Master error
    apCLCD_CURSOR        = (UWORD32)0x20,   // Callback for cursor interrupt
    apCLCD_ALL_INTERRUPTS= (UWORD32)0x1E    // Mask with all interrupts set
} apCLCD_eInterrupts;


/*======================================================================*/
/*
 * Description:
 *   Color LCD VSync Active Enumerator.
 *
 * Remarks:
 *   Definitions of the possible LCD VSync active states for the color LCD.
 *   Used in the display parameters structure.
 *   Set the appropriate value in the apCLCD_sDisplayParams structure
 *   passed to apCLCD_PanelInitialize.
 */
typedef enum apCLCD_xVSync_Active 
{
    apCLCD_LCDFP_H = 0,   // LcdFP pin is active high, inactive low
    apCLCD_LCDFP_L = 1    // LcdFP pin is active low, inactive high
} apCLCD_eVSync_Active;


/*======================================================================*/
/*
 * Description:
 *   Color LCD HSync Active Enumerator.
 *
 * Remarks:
 *   Definitions of the possible LCD HSync active states for the color LCD 
 *   used in the display parameters structure.
 *   Set the appropriate value in the apCLCD_sDisplayParams structure
 *   passed to apCLCD_PanelInitialize.
 */
typedef enum apCLCD_xHSync_Active 
{
    apCLCD_LCDLP_H = 0,    // LcdLP pin is active high, inactive low
    apCLCD_LCDLP_L = 1     // LcdLP pin is active low, inactive high
} apCLCD_eHSync_Active;


/*======================================================================*/
/*
 * Description:
 *   Color LCD Data Drive Edge Enumerator.
 *
 * Remarks:
 *   Definitions of the possible LCD data drive edges for the color LCD. 
 *   Used in the display parameters structure.
 *   Set the appropriate value in the apCLCD_sDisplayParams structure
 *   passed to apCLCD_PanelInitialize.
 */
typedef enum apCLCD_xDataDrive 
{
    apCLCD_CLCP_R = 0,  // Data driven on rising edge of CLCP
    apCLCD_CLCP_F = 1   // Data driven on falling edge of CLCP
} apCLCD_eDataDrive;


/*======================================================================*/
/*
 * Description:
 *   Color LCD TFT Data Enable Output Enumerator.
 *
 * Remarks:
 *   Definitions of the possible LCD output enable settings for the color LCD 
 *   used in the display parameters structure.
 *   For STN displays so this setting has no effect and the CLAC output pin
 *   is used for the AC Bias signal. For TFT displays it is used as the data
 *   output enable, and this setting is used.
 *   Set the appropriate value in the apCLCD_sDisplayParams structure
 *   passed to apCLCD_PanelInitialize.
 */
typedef enum apCLCD_xOEnable 
{
    apCLCD_CLAC_H = 0,  // CLAC pin is active high in TFT mode
    apCLCD_CLAC_L = 1   // CLAC pin is active low in TFT mode
} apCLCD_eOEnable;


/*======================================================================*/
/*
 * Description:
 *   Color LCD Bits Per Pixel Enumerator.
 *
 * Remarks:
 *   Definitions of the possible LCD bits per pixel for the LCD.
 *   Used in the display parameters structure.
 *   Set the appropriate value in the apCLCD_sDisplayParams structure
 *   passed to apCLCD_PanelInitialize.
 */
typedef enum apCLCD_xBpp 
{
    apCLCD_1BPP  = 0,
    apCLCD_2BPP  = 1,
    apCLCD_4BPP  = 2,
    apCLCD_8BPP  = 3,
    apCLCD_16BPP = 4,
    apCLCD_24BPP = 5
} apCLCD_eBpp;

#if (defined (apCLCD_VERSION) && (apCLCD_VERSION == PL111))
/*======================================================================*/
/*
 * Description:
 *   Cursor size selection.
 *
 * Remarks:
 *   The cursor size can be set to 32x32 pixels or 64x64 pixels.
 */
typedef enum apCLCD_xCursorSize 
{
    apCLCD_CURSOR_SIZE_32 = 0,
    apCLCD_CURSOR_SIZE_64 = 1
} apCLCD_eCursorSize;

/*======================================================================*/
/*
 * Description:
 *   Cursor image selection.
 *
 * Remarks:
 *   Four cursors are held in memory if size is set to 32x32 pixels.
 *   Only one cursor is available if size is 64x64 pixels.
 */
typedef enum apCLCD_xCursorImage 
{
    apCLCD_CURSOR_IMAGE_0  = 0,
    apCLCD_CURSOR_IMAGE_1  = 1,
    apCLCD_CURSOR_IMAGE_2  = 2,
    apCLCD_CURSOR_IMAGE_3  = 3
} apCLCD_eCursorImage;
#endif

/*======================================================================*/
/*
 * Description:
 *   Type definition for the User callback handler used by the CLCD
 *   interrupt handler.
 *
 * Implementation:
 *   Establishes the User provided function that is called whenever a
 *   CLCD interrupt happens.
 *   When the callback function is called, the interrupt event has
 *   already been acknowledged.
 *
 *   As an example of an interrupt:
 *
 *   a double-buffer display swap could be performed when an LCD next
 *   address base update (LNBU) interrupt is enabled and generated:
 *
 *    + if the reason code is apCLCD_NextBaseUp, the current DMA base
 *      address could be read using the function apCLCD_DMAFrameBufferGet
 *      and stored locally, overwriting the previous stored buffer address
 *      so that only one of the buffer addresses need be maintained locally
 *    + the DMA base address can then be updated to the second buffer's
 *      address using the function apCLCD_DMAFrameBufferSet
 *    + the LNBU interrupt will be cleared by the main LCD interrupt
 *      handler. You do not need to clear it in your callback code.
 *
 * Inputs:
 *   Condition - the reason for the LCD controller interrupt:
 *     apCLCD_FUF - FIFO underflow
 *     apCLCD_NEXT_BASE_UP - DMA base address update
 *     apCLCD_VCOMP - Vertical compare
 *     apCLCD_MBERR - AHB Master error
 */
typedef void (*apCLCD_rCallback) (apCLCD_eInterrupts Condition);

#if (defined (apCLCD_USER_SETUP) && (apCLCD_USER_SETUP))
/*======================================================================*/
/*
 * Description:
 *   Type definition for User functions for performing LCD panel specific
 *   operations.
 *
 * Remarks:
 *   Because of variations between panels, there may be setup that must
 *   be done before anything else, before power up or after power up which
 *   cannot be generalised.
 *   If these operations are needed, provide functions for them and set
 *   them in the apCLCD_sDisplayParams structure passed to the function
 *   apCLCD_PanelInitialize as rPreamble, rSwitchOff and rSwitchOn
 */
typedef void (*apCLCD_rUserFunction) (void);
#endif

/*======================================================================*/
/*
 * Description:
 *   Color LCD Display Parameters Structure.
 *
 * Remarks:
 *   This is the definition of the structure holding all the static and
 *   variable color LCD panel display parameters. The User should create an
 *   instance of this structure, and initialise it to reflect the LCD device
 *   in use and the configuration in which it is to be used. A pointer to
 *   this structure is then passed to the driver in apCLCD_PanelInitialize.
 *   The driver keeps a pointer to this data in it's internal state structure
 *   so it should not be destroyed if the driver needs to access it again.
 *   The circumstances under which this might happen are described below.
 *
 *   Most of the data is only used at initialisation, so there are no run-time
 *   speed implications.
 *   
 *   Any user drawing functions need access to the parameters that describe
 *   the LCD panel's DMA memory area. To facilitate this, the data is copied
 *   into the driver's internal state structure so that they can be accessed
 *   after initialization without problem.
 *   Other values however are needed if the refresh rate is changed after
 *   the panel has been initialised. These values are not copied, so the
 *   structure must be preserved by the User if the refresh rate is varied.
 *
 *   The current system, where the driver keeps a pointer to this structure
 *   in its own state structure, may not be suitable for some environments
 *   and memory configurations. In this case, if it is required to alter
 *   refresh rate after initialisation, the data values needed should be
 *   recorded internally by adding them to the driver state structure and
 *   altering the driver to take data at run time from there. The pointer
 *   to this structure could then be removed from the state structure.
 *
 *   It is possible to change the Bits Per Pixels used after initialization,
 *   but all the data needed is held in the driver, so the parameter
 *   structure is not required for this.
 */  
typedef struct apCLCD_xDisplayParams
{
                     /*** These should not be needed after initialisation  ***/
    apCLCD_eType         eType;        /* LCD display type                   */
    apCLCD_eColorOrder   eColorOrder;  /* RGB or BGR                         */
    apCLCD_eReload       eReload;      /* FIFO reload timing                 */
    apCLCD_eClockSource  eClockSource; /* LCD clock source                   */
    UWORD32              ACBias;       /* number of line clock periods       */
                                       /* between each toggle of AC-bias pin */
    apCLCD_eVSync_Active eVSyncActive; /* LcdFP pin active state             */
    apCLCD_eHSync_Active eHSyncActive; /* LcdLP pin active state             */
    apCLCD_eDataDrive    eDataDrive;   /* edge data driven on                */
    apCLCD_eOEnable      eTftClac;     /* CLAC pin setting in TFT mode       */
    UWORD32              ClleDelay;    /* Delay before line end pulse...     */
                                       /* ...(0 to disable)                  */

                    /**** These are needed if the refresh rate is changed ****/
    apCLCD_eSTN_CType    eColorType;   /* STN LCD color type                 */
    apCLCD_eSTN_Iface    eInterface;   /* STN LCD x-bit interface            */
    apCLCD_eSTN_Panel    ePanel;       /* STN LCD single or double panel     */
    UWORD32              Clock;        /* LCD controller clock in Hz         */
    UWORD32              VSync;        /* vertical sync pulse width          */
    UWORD32              VFront;       /* vertical front porch               */
    UWORD32              VBack;        /* vertical back porch                */
    UWORD32              HSync;        /* horizontal sync pulse width        */
    UWORD32              HFront;       /* horizontal front porch             */
    UWORD32              HBack;        /* horizontal back porch              */

/*** These may change after initialisation if the configuration is altered ***/
    UWORD32              Refresh;      /* LCD screen refresh rate in Hz      */
/*** This is needed because the driver must check the type of Vertical       */
/*   Compare interrupt requested by the user.                                */
/*** It is held internally in the driver ***/
    apCLCD_eVComp_ITime  eVCInterTime; /* Vertical Compare interrupt timing  */

/*** These six are needed by drawing functions to address DMA memory       ***/
/*** LineWidth and NumLines are also needed if the refresh rate is changed ***/
/*** They are held internally in the driver    ***/
    UWORD32              DMABase;      /* Base address of screen memory      */
    UWORD32              LineWidth;    /* line length, multiple of 16 pixels */
    UWORD32              NumLines;     /* total height of the screen         */
    apCLCD_ePixelOrder   ePixelOrder;  /* pixel ordering within a byte       */
    apCLCD_eBpp          eBpp;     /* bits per pixel. This might change...   */
                 /* ...after initialisation if the configuration is altered  */

/*** Parameters for LCD panel specific features.                           ***/
/*** They do not alter after initialisation.                               ***/
/*** Except for rPreamble they may be used and are stored in the driver    ***/
#ifndef apCLCD_NO_POWERUP_DELAY
    UWORD32              PowerUpDel;   /* Delay between LcdEn & LcdPwr on    */
#endif
    UWORD32              PowerDownDel; /* Delay between LcdPwr & LcdEn off   */
#if (defined (apCLCD_USER_SETUP) && (apCLCD_USER_SETUP))
    /*** Apply special LCD panel requirements ***/
    /**** LCD panel specific setup functions ****/
    apCLCD_rUserFunction rPreamble;    /* Right at the start                 */
    apCLCD_rUserFunction rSwitchOff;   /* Power off sequence                 */
    apCLCD_rUserFunction rSwitchOn;    /* Power on sequence                  */
#endif    
} apCLCD_sDisplayParams;


/*======================================================================*/
/*
 * Description:
 *   Color LCD RGB Palette Structure.
 *
 * Remarks:
 *   Each RGB palette entry for the color LCD consists of a byte value
 *   for each of the three colors, red, green, and blue.
 *   The top five bits of each color are written directly to the palette.
 *   The average of the low three bits is used to decide whether to set
 *   the Intensity bit (which is used only for TFT displays). STN displays
 *   use only the top 4 bits of these 5-bit fields.
 */
typedef struct apCLCD_xRGB_Palette {
    UBYTE8   Red;               /* Red component in top five bits of byte */
    UBYTE8   Green;             /* Green component in top five bits of byte */
    UBYTE8   Blue;              /* Blue component in top five bits of byte */
} apCLCD_sRGB_Palette;

/*======================================================================*/
/*
 * Description:
 *   Color LCD Palette Structures.
 *
 * Remarks:
 *   Each palette entry for the color LCD is either a greyscale value or
 *   an RGB color. A greyscale entry is a byte quantity, but only the
 *   top bits are defined for a physical palette entry. An RGB color is
 *   a structure.
 *   The definition gives the combined greyscale and RGB palette 
 *   structure.
 */
typedef union apCLCD_xPalette {
    apCLCD_sRGB_Palette sRgb;       /* RGB palette entry */
    UBYTE8              Grey;       /* Grey scale palette entry */
    UWORD32             Entry;      /* reserved */
} apCLCD_sPalette;


/*======================================================================*/
/*
 * Description:
 *   Enables and powers-up the color LCD controller.
 *
 * Implementation:
 *   The LCD controller is enabled by setting bits in the LCD Control 
 *   Register. LcdEn is set first, and then after a delay, typically of
 *   20ms, the LCD controller is powered-up by setting the LcdPwr bit.
 *   The clocks are started when LcdEn is set.
 *   LCD displays require that this sequence is followed or the panel may
 *   be degraded. The delay may vary between LCD panels, so its value is
 *   held in the parameter structure. The PrimeCell manual recommends 20ms,
 *   but display data sheets may specify other values
 * Inputs:
 *   oId - selects the LCD data to be referenced.
 *
 * Return Value:
 *  apERR_NONE          - Power-up sequence completed without errors
 *  apERR_VCOMP_TIMEOUT - Vcomp bit was not set during time-out period
 */
PUBLIC apError apCLCD_PowerUp(apOS_CLCD_oId oId);


/*======================================================================*/
/*
 * Description:
 *   Powers-down and disables the color LCD controller.
 *
 * Implementation:
 *   The LCD controller is powered-down by clearing bits in the Control
 *   Register. First LcdPwr is cleared, and then after a suitable delay,
 *   typically 20ms, the LCD controller is disabled by clearing LcdEn.
 *   The delay may vary between LCD panels, so its value is held in the
 *   parameter structure. The PrimeCell manual recommends 20ms, but
 *   individual display data sheets may specify other values
 *
 * Inputs:
 *   oId - selects the LCD data to be referenced.
 */
PUBLIC void apCLCD_PowerDown(apOS_CLCD_oId oId);


/*======================================================================*/
/*
 * Description:
 *   Enables interrupt events within the LCD controller.
 *
 * Implementation:
 *   The events that generate interrupts are set by OR'ing interrupts into 
 *   the LCD Interrupt Enable Register.
 *
 *   This function must only be called after both apCLCD_Initialize and
 *  apCLCD_PanelInitialize have been called.
 *
 * Inputs:
 *   oId - selects the LCD data to be referenced.
 *   Events - the interrupt events to enable, formed by ORing
 *            together apCLCD_eInterrupts values.
 */
PUBLIC void apCLCD_InterruptEventsEnable(apOS_CLCD_oId oId, UWORD32 Events);

/*======================================================================*/
/*
 * Description:
 *   Disables interrupt events within the LCD controller.
 *
 * Implementation:
 *   The events that generate interrupts are cleared by clearing any bit
 *   set in 'interrupts' in the LCD Interrupt Enable Register.
 *
 *   This function must only be called after both apCLCD_Initialize and
 *  apCLCD_PanelInitialize have been called.
 *
 * Inputs:
 *   oId - selects the LCD data to be referenced.
 *   Events - the interrupt events to disable, formed by ORing
 *            together apCLCD_eInterrupts values.
 */
PUBLIC void apCLCD_InterruptEventsDisable(apOS_CLCD_oId oId, UWORD32 Events);


/*======================================================================*/
/*
 * Description:
 *  Register the user callback which called every time a CLCD interrupt
 *  occurs.
 *  To disable this and prevent any call being attempted, register the
 *  pointer aRNULL.
 *
 * Inputs:
 *   oId - selects the LCD data to be referenced.
 *   rCallback - the function to be called on interrupts.
 *
 * Implementation:
 *   The callback address is stored in the driver's state structure.
 */
PUBLIC void apCLCD_RegisterCallback(apOS_CLCD_oId    oId,
                                    apCLCD_rCallback rCallback);

/*======================================================================*/
/*
 * Description:
 *   Defines the palette for the specified number of contiguous entries
 *   (starting at zero). The palette is used for either greyscale or RGB
 *   color output.
 *
 * Implementation:
 *   For each of the entries defined in the physical color level palette, 
 *   palette[ x ] is converted and written to the appropriate 16-bit
 *   field in the CLCD Palette, where 'x' is the current palette
 *   entry to be written, 0 <= 'x' < entries.
 *
 *   For greyscale output only the first 16 entries of the red component
 *   of the palette is used and the green and blue components and the 
 *   remaining 240 palette entries are undefined.
 *
 *   For 1bpp color output only the first 2 entries of the RGB components of
 *   the palette are used. The remaining 254 palette entries are unused.
 *
 *   For 2bpp color output only the first 4 entries of the RGB components of
 *   the palette are used and the remaining 252 palette entries are unused.
 *
 *   For 4bpp color output only the first 16 entries of the RGB components of
 *   the palette are used and the remaining 240 palette entries are unused.
 *
 *   For 8bpp color output the RGB components of all 256 palette entries are
 *   used.
 *
 *   For 16 or 24 bpp, no palette is used, and the values are written
 *   directly to the PrimCell
 *
 *   In all cases, the palette entries and components beyond those that
 *   are used for the LCD controller mode can still be set even though
 *   they are unused.
 *
 * Inputs:
 *   oId - selects the LCD data to be referenced.
 *   sPalette - an array of physical level palette entry structures of
 *     either greyscale or RGB components
 *   Entries - the number of physical levels to define using the entries
 *     in the palette
 *    + to set greyscale palette entries, entries can be any value
 *      from 1 to 16
 *    + to set RGB color palette entries, entries can be any value 
 *      from 1 to 256
 *
 * Return Value:
 *   apCLCD_PALETTE_TOO_BIG - more than 256 entries specified (Entries > 255).
 *   apERR_NONE - The parameters are correct.
 */
PUBLIC apError apCLCD_PaletteSet(apOS_CLCD_oId         oId,
                                 CONST apCLCD_sPalette sPalette[],
                                 UWORD32               Entries);

/*======================================================================*/
/*
 * Description:
 * Initialise the CLCD Driver
 *
 * Implementation:
 * Stores base address and interrupt values for the specified CLCD
 * and sets up the interrupt linkage.
 *
 * Inputs:
 *   oId - selects the LCD data to be referenced.
 *   eBase - base address of CLCD registers
 *   Interrupts - number of interrupts used for the LCD being initialised
 *   pSources - source of interrupt apOS_INT_LMCLCD
 *   pInitial - pointer to initialisation data structure (unused)
 *
 * Remarks:
 *  This Function must be called before any other action is carried out
 *  on the CLCD PrimeCell
 */
PUBLIC void apCLCD_Initialize(apOS_CLCD_oId                   oId,
                              apOS_System_eBaseAddress        eBase, 
                              UWORD32                         Interrupts,
                              CONST apOS_INT_oInterruptSource *pSources,
                              void                            *pInitial);

/*======================================================================*/
/*
 * Description:
 *  Initialises the LCD panel using values from the apCLCD_sDisplayParams
 *  structure passed in. The contents of this structure are defined above,
 *  and the usage of the parameters in the PrimeCEll is described in
 *  ARM PrimeCell Color LCD Controller (PL110) Technical Reference Manual.
 *
 * Implementation:
 *  If LCD panel specific initialisation is required, the specified User
 *  preamble function is called.
 *  Copies any parameters that might be needed after initialisation into
 *  the Driver's internal state structure.
 *  Sets up the following PrimeCell registers: 
 *   Control, Timing0, Timing1, Timing2, Timing3
 *  Disables interrupts, and leaves the PrimeCell ready for power up.
 *
 * Inputs:
 *   oId - selects the LCD data to be referenced.
 *   pParams - Pointer to the initialisation parameter structure
 *
 * Return Value:
 *   apERR_NONE - The parameters are correct.
 *   apCLCD_INCORRECT_WIDTH - Display width is not a multiple of 16 pixels
 *   apCLCD_NO_SETTING - A required initialisation value is missing or invalid.
 *   apCLCD_INVALID_DISPLAY_TYPE - Either an unknown display type is specified
 *                                 Or an STN display is selected with options
 *                                 that conflict.
 *   apCLCD_NO_AC_BIAS - STN displays need a non-zero AC bias. If it is zero
 *                       the display will degrade with time. 
 *
 * Remarks:
 *  This Function must be called after apCLCD_Initialize, but before any other
 *  operations are carried out on the CLCD PrimeCell
 */
PUBLIC apError apCLCD_PanelInitialize(apOS_CLCD_oId         oId, 
                                      apCLCD_sDisplayParams *pParams);
 
/*======================================================================*/
/*
 * Description:
 *  Set up the Bits Per Pixel to be used.
 *
 * Implementation:
 *  Stores the bits per pixel in the Driver's internal state structure so that
 *  it can be used by any drawing functions that might need it later.
 *  Modifies the Control register to apply the setting.
 *  For dual panel diaplays the Lower Panel base address is re-evaluated.
 *
 * Inputs:
 *   oId - selects the LCD data to be referenced.
 *   Bpp - The Bits Per Pixel required.
 *
 * Return Value:
 *  apCLCD_INVALID_BPP - An unobtainable Bits Per Pixel was requested
 *  apERR_NONE - The parameters are compatible
 */
PUBLIC apError apCLCD_BppSet(apOS_CLCD_oId oId, UWORD32 Bpp);

/*======================================================================*/
/*
 * Description:
 *  Sets the PrimeCell Driver clock divisor to give a refresh rate close to
 *  that requested.
 *
 * Implementation:
 *  Uses the values in the Parameter structure to generate a clock divisor
 *  to produce an LCD Panel Clock frequency which will give a refresh rate
 *  close to that requested.
 *  Since the clock divisor may well be a small integer, there can be a
 *  large difference between the rate requested and that actually set. This
 *  is particularly so for high refresh rates. Because of this the resulting
 *  refresh rate is computed and saved in the parameter structure and is
 *  returned to the caller.
 *
 * Inputs:
 *  oId - selects the LCD data to be referenced.
 *  Refresh - The refresh rate requested, in Frames per Second
 *
 * Return Value:
 *  The refresh rate actually established
 */
PUBLIC UWORD32 apCLCD_RefreshSet(apOS_CLCD_oId oId, UWORD32 Refresh);

/*======================================================================*/
/*
 * Description:
 *  Wait for the requested number of occurrences of a Vertical Compare event
 *  by polling the status register.
 *
 * Implementation:
 *  Clears vertical compare in the Status register, and waits for it to be
 *  set again, and repeats this the number of times requested. 
 *  Note that:
 *  1) The Vcomp status is updated so long as the PrimeCell is enabled
 *    (LcdEn). It is not affected by the state of LcdPwr.
 *  2) The status is updated whether or not the Vertical Compare interrupt
 *     is enabled, but is never set if Vertical Compare is set on start of
 *     front porch and the front porch value is zero, or if it's set on back
 *     porch with zero back porch value.
 *     In these cases the function returns immediately.
 *  3) Except for the reasons described in 2) above, VComp events will always
 *     happen, as there is no setting in the PrimeCell that disables this.
 *
 * Remarks:
 *  This function works by polling the status register for VComp events.
 *  Because of this the User must ensure that the settings for VComp are as
 *  needed, using apCLCD_VCompEventsEnable, before calling this function.
 *
 * Inputs:
 *  oId - selects the LCD data to be referenced.
 *  SyncCount - The number of Vertical Compare events to occur before the
 *              function returns
 * Return Value:
 *  apERR_NONE          - Vcomp bit was set requested number of times, or cannot be set
 *  apERR_VCOMP_TIMEOUT - Vcomp bit was not set during time-out period
 */
PUBLIC apError apCLCD_WaitVComp(apOS_CLCD_oId oId, UWORD32 VCompCount);

/*======================================================================*/
/*
 * Description:
 *
 * Implementation:
 *  Sets the Vertical Compare interrupt reason. This can be one set to 
 *  occur on one of the following events:
 *      Start of Vertical Sync
 *      Start of Back Porch
 *      Start of Active Video
 *      Start of Front Porch
 *  The behaviour of the PrimCell is such that if the interrupt is selected
 *  for the start of front porch and the front porch value is set to zero,
 *  or it's set on back porch with zero back porch value. then no interrupt
 *  occurs. The requested settings are always selected even if no interrupt
 *  will conditions will ever arise.
 *
 * Inputs:
 *   oId - selects the LCD data to be referenced.
 *   eVCompEvent -  The requested reason for Vertical Compare Interrupts.
 *
 * Return Value:
 *  If the settings requested preclude VComp interrupts happening FALSE is
 *  returned. Otherwise TRUE.
 *
 */
PUBLIC BOOL apCLCD_VCompEventsEnable(apOS_CLCD_oId       oId,
                                     apCLCD_eVComp_ITime eVCompEvent);

/*======================================================================*/
/*
 * Description: Establish the DMA Frame buffer address(es)                     *
 *
 * Implementation:
 *  Sets up the DMA Frame buffer address(es). If the LCD in use is dual
 *  panel STN device, the second frame buffer address is calculated and
 *  set up.
 *  This function is typically used to implement multiple buffering in
 *  conjunction with LNBUINTR interrupts.
 *  As implemented, the Driver assumes that for dual panel LCDs the pair
 *  of buffers occupy contiguous memory.
 *
 * Inputs:
 *   oId - selects the LCD data to be referenced.
 *   DMABase - The base address of the LCD DMA panel memory. If the device
 *             dual panel, this is the address of the upper panel.
 *
 */
PUBLIC void apCLCD_DMAFrameBufferSet(apOS_CLCD_oId oId, UWORD32 DMABase);

/*======================================================================*/
/*
 * Description:
 *  Retrieves the base address of the current DMA memory block,
 *
 * Implementation:
 *  The DMA memory address is held in the LCD Driver's internal data structure.
 *  It is typically required by drawing functions that need to write to this
 *  area. The implementation assumes that for dual-panel LCDs the Upper and
 *  Lower memory areas are contiguous.
 *  NOTE: The driver must be modified if it is to use non-contiguous memory.
 *
 * Inputs:
 *   oId - selects the LCD data to be referenced.
 *
 * Return Value:
 *   Address of the current DMA memory.
 */
PUBLIC UWORD32 apCLCD_DMAFrameBufferGet(apOS_CLCD_oId oId);

/*======================================================================*/
/*
 * Description:
 *  Disable all CLCD PrimeCell interrupts
 *
 * Implementation:
 *  Clears the interrupt bits in the LCD Interrupt enable register, and
 *  clears all pending interrupts.
 *
 * Inputs:
 *   oId - selects the LCD data to be referenced.
 *
 */
PUBLIC void apCLCD_InterruptsDisable(apOS_CLCD_oId oId);

/*======================================================================*/
/*
 * Description:
 *  Retrieve the horizontal size of the LCD active area
 *
 * Implementation:
 *  This value is held within the Driver's internal data structure, and is
 *  typically used by drawing functions for mapping the LCD onto the DMA
 *  memory region.
 *
 * Inputs:
 *   oId - selects the LCD data to be referenced.
 *
 * Return Value:
 *  LCD active area width
 *
 */
PUBLIC UWORD32 apCLCD_LineWidthGet(apOS_CLCD_oId oId);

/*======================================================================*/
/*
 * Description:
 *  Retrieves the current setting of bits per pixel for the LCD
 *
 * Implementation:
 *  This value is held within the Driver's internal data structure, and is
 *  typically used by drawing functions for mapping the LCD onto the DMA
 *  memory region.
 *
 * Inputs:
 *   oId - selects the LCD data to be referenced.
 *
 * Return Value:
 *  The enumerated type value describing the bits per pixel
 */
PUBLIC apCLCD_eBpp apCLCD_BppGet(apOS_CLCD_oId oId);

/*======================================================================*/
/*
 * Description:
 *  Retrieve the vertical size of the LCD active area
 *
 * Implementation:
 *  This value is held within the Driver's internal data structure, and is
 *  typically used by drawing functions for mapping the LCD onto the DMA
 *  memory region.
 *
 * Inputs:
 *   oId - selects the LCD data to be referenced.
 *
 * Return Value:
 *  LCD active area height
 */
PUBLIC UWORD32 apCLCD_LinesPerScreenGet(apOS_CLCD_oId oId);

/*======================================================================*/
/*
 * Description:
 *  Retrieve the pixel ordering in use for the LCD
 *
 * Implementation:
 *  This value is held within the Driver's internal data structure, and is
 *  typically used by drawing functions for mapping the LCD onto the DMA
 *  memory region.
 *
 * Inputs:
 *   oId - selects the LCD data to be referenced.
 *
 * Return Value:
 *   The pixel ordering in use
 */
PUBLIC apCLCD_ePixelOrder apCLCD_PixelOrderGet(apOS_CLCD_oId oId);

/*======================================================================*/
/*
 * Description:
 *  Size of the Driver's internal data structure
 *
 * Implementation:
 *  The Driver maintains a data structure for each LCD initialised which
 *  contains data that may be needed after initialisation. Typically
 *  this is not accessible to the user.
 *  It may be that the driver must operate without making use of any private
 *  data of global scope, ie using heap space. In this case the user must
 *  allocate this data and pass it to the Driver using the opaque data type
 *  apOS_CLCD_oId in the apCLCD_Initialize function. To do this the size of
 *  the data structure is needed by the calling program.
 *  This function is conditionally compiled, and only exists if the value
 *  apOS_NO_STATIC_STATE is #defined TRUE
 *
 * Return Value:
 *  Size of the Driver's internal data structure
 */
PUBLIC WORD32 apCLCD_StateSizeGet(void);

/*
 * Description:
 * Handles interrupts to the CLCD controller.
 *
 * Note:
 * NOT FOR GENERAL USE.  This routine should only be called by an interrupt dispatcher
 *
 * Implementation:
 * All interrupts are routed through this Handler.
 *
 * Inputs:
 * oInterruptId - The identifier of the interrupt
 * DeviceId     - The instance of the CLCD peripheral
 * 
 * Outputs:
 * none
 * 
 * Return Value:
 * none
 */
PUBLIC void apCLCD_IntHandler(CONST apOS_INT_oInterruptSource oInterruptId,
                              UWORD32                         DeviceId);

/*
 * Description:
 * This is the raw interrupt handler for the module, to be called directly
 * from the interrupt vector
 *
 * Note:
 * NOT FOR GENERAL USE.  This routine should only be executed as a branch
 *                       from the IRQ vector
 *
 * Inputs:
 * none
 *
 * Outputs:
 * none
 *
 * Return Value:
 * none
 */
PUBLIC IRQ void apCLCD_RawISR(void);

#if (defined (apCLCD_VERSION) && (apCLCD_VERSION == PL111))
/******************************************************************************\
*  Hardware Cursor Control Functions                                           *
\******************************************************************************/
/*
 * Description:
 * Switches hardware cursor on
 *
 * Implementation:
 * Sets Cursor display bit in cursor control register
 *
 * Inputs:
 * oId          - selects the LCD controller.
 */
PUBLIC void apCLCD_CursorOn(apOS_CLCD_oId oId);

/*
 * Description:
 * Switches hardware cursor off
 *
 * Implementation:
 * Clears Cursor display bit in cursor control register
 *
 * Inputs:
 * oId          - selects the LCD controller.
 */
PUBLIC void apCLCD_CursorOff(apOS_CLCD_oId oId);

/*
 * Description:
 * Selects one of four hardware cursors to be displayed
 *
 * Implementation:
 * Sets Cursor Image number in cursor control register.
 * If the cursor size is 64x64 then this setting has no effect.
 *
 * Inputs:
 * oId          - selects the LCD controller.
 * eImage       - Image number to select
 */
PUBLIC void apCLCD_CursorImageSelect(apOS_CLCD_oId oId, apCLCD_eCursorImage eImage);

/*
 * Description:
 * Fetches the number of the image currently displayed
 *
 * Implementation:
 * Gets Cursor Image number from cursor control register.
 *
 * Inputs:
 * oId          - selects the LCD controller.
 *
 * Return Value:
 *   The current cursor image number.
 */
PUBLIC apCLCD_eCursorImage apCLCD_CursorImageGet(apOS_CLCD_oId oId);

/*
 * Description:
 * Sets Cursor coordinates synchronized to frame synchronization pulse.
 *
 * Implementation:
 * Sets Cursor frame sync bit in cursor config register
 *
 * Inputs:
 * oId          - selects the LCD controller.
 */
PUBLIC void apCLCD_CursorSyncOn(apOS_CLCD_oId oId);

/*
 * Description:
 * Sets Cursor synchronization to asynchronous mode.
 *
 * Implementation:
 * Clears Cursor frame sync bit in cursor config register
 *
 * Inputs:
 * oId          - selects the LCD controller.
 */
PUBLIC void apCLCD_CursorSyncOff(apOS_CLCD_oId oId);

/*
 * Description:
 * Sets size of hardware cursor to be displayed
 *
 * Implementation:
 * Sets Cursor size in cursor config register.
 * Size can be 32x32 pixels or 64x64 pixels.
 *
 * Inputs:
 * oId          - selects the LCD controller.
 * eSize        - size of cursor
 */
PUBLIC void apCLCD_CursorSizeSet(apOS_CLCD_oId oId, apCLCD_eCursorSize eSize);

/*
 * Description:
 * Fetches the size of the cursor
 *
 * Implementation:
 * Gets Cursor size from cursor config register.
 *
 * Inputs:
 * oId          - selects the LCD controller.
 *
 * Return Value:
 *   The current cursor size.
 */
PUBLIC apCLCD_eCursorSize apCLCD_CursorSizeGet(apOS_CLCD_oId oId);

/*
 * Description:
 * Sets Cursor position from top-left corner of screen.
 *
 * Implementation:
 * Sets X and Y coordinates in position register
 *
 * Inputs:
 * oId          - selects the LCD controller.
 * X            - distance from left edge of screen to left edge of cursor image
 * Y            - distance from top of screen to top edge of cursor image
 */
PUBLIC void apCLCD_CursorPositionSet(apOS_CLCD_oId oId, UWORD32 X, UWORD32 Y);

/*
 * Description:
 * Fetches current cursor position relative to top-left corner of screen.
 *
 * Implementation:
 * Reads X and Y coordinates in position register
 *
 * Inputs:
 * oId          - selects the LCD controller.
 * pX           - pointer to location to store X coordinates
 * pY           - pointer to location to store Y coordinates
 */
PUBLIC void apCLCD_CursorPositionGet(apOS_CLCD_oId oId, UWORD32 * CONST pX, UWORD32 * CONST pY);

/*
 * Description:
 * Sets the distance from top-left corner of cursor image to first displayed pixel
 * in cursor image.
 *
 * Implementation:
 * Sets X and Y distances from top-left of cursor image in clip position register
 *
 * Inputs:
 * oId          - selects the LCD controller.
 * ClipX        - distance from left edge of cursor image
 * ClipY        - distance from top edge of cursor image
 */
PUBLIC void apCLCD_CursorClipSet(apOS_CLCD_oId oId, UWORD32 ClipX, UWORD32 ClipY);

/*
 * Description:
 * Fetches the distance from top-left corner of cursor image to first displayed pixel
 * in cursor image.
 *
 * Implementation:
 * Fetches X and Y distances from top-left of cursor image from clip position register
 *
 * Inputs:
 * oId          - selects the LCD controller.
 * pClipX       - pointer to location to store distance from left edge of cursor image
 * pClipY       - pointer to location to store distance from top edge of cursor image
 */
PUBLIC void apCLCD_CursorClipGet(apOS_CLCD_oId oId, UWORD32 * CONST pClipX, UWORD32 * CONST pClipY);

/*
 * Description:
 * Enables hardware cursor Interrupt
 *
 * Implementation:
 * Sets Cursor interrupt bit in interrupt mask register
 *
 * Inputs:
 * oId          - selects the LCD controller.
 */
PUBLIC void apCLCD_CursorInterruptEnable(apOS_CLCD_oId oId);

/*
 * Description:
 * Disables hardware cursor Interrupt
 *
 * Implementation:
 * Clears Cursor interrupt bit in interrupt mask register
 *
 * Inputs:
 * oId          - selects the LCD controller.
 */
PUBLIC void apCLCD_CursorInterruptDisable(apOS_CLCD_oId oId);

/*
 * Description:
 * Sets hardware cursor color palette
 *
 * Implementation:
 * Loads Cursor palette registers
 *
 * Inputs:
 * oId          - selects the LCD controller.
 * pPalette0    - pointer to array which holds the Red,Green,Blue color components for color 0
 * pPalette1    - pointer to array which holds the Red,Green,Blue color components for color 1
 */
PUBLIC void apCLCD_CursorPaletteSet(apOS_CLCD_oId oId, UWORD32 * pPalette0, UWORD32 * pPalette1);

/*
 * Description:
 * Loads the hardware cursor image memory
 *
 * Implementation:
 * Transfers image pointed to by pImage to dual port memory in LCD controller
 *
 * Inputs:
 * oId          - selects the LCD controller.
 * eImageNumber - number of image to be loaded. Ignored if 64x64 pixel image.
 * pImage       - pointer to array which holds the image data 256 words loaded for 64x64 pixel image
 *                and 64 words for a 32x32 pixel image
 */
PUBLIC void apCLCD_CursorImageLoad(apOS_CLCD_oId oId, apCLCD_eCursorImage eImageNumber, UWORD32 * pImage);

#endif

#ifdef __cplusplus
} /* allow C++ to use these headers */
#endif	/* __cplusplus */

#endif  /* APCLCD_H */
