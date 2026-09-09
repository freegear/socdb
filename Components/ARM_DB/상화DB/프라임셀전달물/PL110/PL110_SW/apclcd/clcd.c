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
 * File:     clcd.c,v
 * Revision: 1.37
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : clcd.c.rca
 *  File Revision          : 1.4
 * 
 *  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
 *  ----------------------------------------
 *
 * Code implementation file for the CLCD (Colour Liquid Crystal Display)
 * controller.
*/

#include "../apcommon/aptypes.h"
#include "../apcommon/apbitops.h"
#include "../apos/apos.h"
#include "apclcd.h"
#include "clcd.h"

/*
 * --------Data declarations--------
 */
#if !defined(apOS_NO_STATIC_STATE) || (!apOS_NO_STATIC_STATE)
PRIVATE CLCD_sStateStruct CLCD_sState[apOS_CLCD_MAXIMUM];
#endif

/***********************************************************
** Functions
************************************************************/

/******************************************************************************\
* Description:  CLCD Panel power up sequence                                   *
* Operation:    Apply signals in the right sequence with appropriate delay     *
* Notes:        The sequence timing required may vary between LCD panels, so a *
*               delay value is held in the state structure. The PrimeCell      *
*               manual recommends 20ms, panel data sheets may have other ideas *
\******************************************************************************/
PUBLIC apError apCLCD_PowerUp(apOS_CLCD_oId oId)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    UWORD32 CONST Control = pState->pBaseAddress->Control;

    // Check it's at least partly powered down
    if((Control & bmCLCD_CONTROL_LCDPWR) == 0 ||
       (Control & bmCLCD_CONTROL_LCDEN ) == 0)
    {
                                    // Make sure it's powered down, otherwise
                                    // it will wake up a soon as it's enabled
        apBIT_CLEAR(pState->pBaseAddress->Control, CLCD_CONTROL_LCDPWR);

#if (defined (apCLCD_USER_SETUP) && (apCLCD_USER_SETUP))
/******************************************************************************\
 *** NOTE: Because of variations between panels, there may be setup that    ***
 *** must be done for power off that cannot be generalised.                 ***
\******************************************************************************/
        if(pState->rSwitchOff != aRNULL)
        {
            pState->rSwitchOff();
        }
#endif
                                                        // Enable it first
        apBIT_SET(pState->pBaseAddress->Control, CLCD_CONTROL_LCDEN, 1);

// Do NOT pause before powering up the Sharp panel, if there is more than
// 20ms between CLCD_CONTROL_LCDEN and CLCD_CONTROL_LCDPWR being set the display
// will latch up.
#ifndef apCLCD_NO_POWERUP_DELAY
        apOS_TIMER_Wait(pState->PowerUpDel * 1000);     // Pause before powering up
#endif        
        if(apCLCD_WaitVComp(oId, 1) != apERR_NONE)      // Wait for a sync
        {
            apBIT_CLEAR(pState->pBaseAddress->Control, CLCD_CONTROL_LCDEN);
            return (apError) apCLCD_VCOMP_TIMEOUT;
        }    
                                                        // power...
        apBIT_SET(pState->pBaseAddress->Control, CLCD_CONTROL_LCDPWR, 1);   
                                            // Power is supposedly not applied
                                            // by the PrimeCell until both
                                            // LcdPwr and LcdEn are asserted
#if (defined (apCLCD_USER_SETUP) && (apCLCD_USER_SETUP))
/*** Apply panel-specific power-up sequence                     ***/
        if(pState->rSwitchOn != aRNULL)
        {
            pState->rSwitchOn();
        }
#endif
    }

    return apERR_NONE;
}

/******************************************************************************\
* Description:  CLCD Panel power down sequence                                 *
* Operation:    Apply signals in the right sequence with appropriate delay     *
* Notes:        The required sequence may vary between specific LCD panels and *
*               so the correct value must be in the parameter structure.       *
\******************************************************************************/
PUBLIC void apCLCD_PowerDown(apOS_CLCD_oId oId)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    UWORD32 Control = pState->pBaseAddress->Control;

    // Check it's at least partly powered up
    if((Control & bmCLCD_CONTROL_LCDPWR) != 0 ||
       (Control & bmCLCD_CONTROL_LCDEN ) != 0)
    {
        apBIT_CLEAR(pState->pBaseAddress->Control, CLCD_CONTROL_LCDPWR);

        // Wait required interval before disabling the LCD
        // PrimeCell 'default' is 20ms. Needs to be set for the panel
        apOS_TIMER_Wait(pState->PowerDownDel * 1000);
        apBIT_CLEAR(pState->pBaseAddress->Control, CLCD_CONTROL_LCDEN);
    }

#if (defined (apCLCD_USER_SETUP) && (apCLCD_USER_SETUP))
/******************************************************************************\
 *** NOTE: Because of variations between panels, there may be setup that    ***
 *** must be done for power off that cannot be generalised.                 ***
\******************************************************************************/
    if(pState->rSwitchOff != aRNULL)
    {
        pState->rSwitchOff();
    }
#endif

}

/******************************************************************************\
* Description:  Find the required ratio of the Panel Clock to the CLCD clock.  *
* Operation:    The Panel Clock is generated by a divisor applied to the CLCD  *
*               Clock. This function uses values from the parameter structure  *
*               to generate a divisor that gives a refresh rate close to that  *
*               requested.                                                     *
*               This is done by calculating the effective clocked area of the  *
*               LCD, and using the requested refresh rate to find the Panel    *
*               Clock frequency that gives the desired refresh rate. From this *
*               the required divisor is derived.                               *
*               The ratio is often a small integer so the refresh rate set up  *
*               can be (considerably) different from that requested. Because   *
*               of this the actual refresh rate expected is computed and saved *
*               in the parameter structure.                                    *
* NOTE:  The LCD display is clocked across its active area and additional      *
*        regions around its edge. These extra regions are the Horizontal Front *
*        and Back Porches, the Vertical Front and Back Porches, the Horizontal *
*        and vertical synch regions. This affects the total number of clock    *
*        ticks needed to process a single frame.                               *
*        Since each LCD pixel is made up of a number of discrete elements,     *
*        another factor determines the number of elements clocked by each tick *
*        so there may be a non-integral number of clock ticks per pixel.       *
*        This value varies between different panel types.                      *
\******************************************************************************/
PRIVATE WORD32 CLCD_ClockRatioCompute(apCLCD_sDisplayParams * CONST pParams, 
                                      UWORD32                       NumLines)
{
    UWORD32 PixPerFrame;
    UWORD32 PanelClockFrequency;
    WORD32  Ratio;                           // This could be negative
        // For TFT displays, PCD can go down to 0, ie the ratio is 2. However,
        // if the ratio is less than 2, the pixel clock divisor is bypassed,
        // and so that this case can be detected the minimum value is 1
    WORD32  MinRatio = 1;            // This gives PCD = 0, the minimum for TFT

    // Calculate raw number of clocks per frame

    // Firstly find the total number of pixels over to whole display, both
    // active and inactive. This is the total clocked width (Nominal width +
    // Horizontal Front + Back Porche) multiplied by the total clocked height
    // (Nominal height + Vertical Front and Back Porches)
    PixPerFrame = (pParams->LineWidth + pParams->HSync + pParams->HFront + pParams->HBack) *
                  (NumLines + pParams->VSync + pParams->VFront + pParams->VBack);

       // Deduce the nominal required Clock frequency for the refresh rate
    PanelClockFrequency = PixPerFrame * pParams->Refresh;

    if(pParams->eType == apCLCD_STN)    // This enforces a minimum > 2
    {                       // Adjust for number of pixels per clock cycle
        if(pParams->eColorType == apCLCD_STN_COLOR)
        {
            PanelClockFrequency = PanelClockFrequency * 3 / 8;
            MinRatio = (pParams->ePanel == apCLCD_STN_DUAL) ? 6 : 3;
        }
        else if(pParams->eInterface == apCLCD_STN_8BIT)
        {
            PanelClockFrequency = PanelClockFrequency / 8;
            MinRatio = (pParams->ePanel == apCLCD_STN_DUAL) ? 16 : 8;
        }
        else                                    // It must be 4-bit
        {
            PanelClockFrequency = PanelClockFrequency / 4;
            MinRatio = (pParams->ePanel == apCLCD_STN_DUAL) ? 8 : 4;
        }
    }
// Check here to see if BCD is needed, this will be the case if PCD
// would come out as < 1 for an STN display or < 0 for TFT
                                    // Convert to form needed by PrimeCell
    Ratio = (pParams->Clock / PanelClockFrequency);

    if(Ratio < MinRatio)          // Ensure value used is sensible
    {
        Ratio = MinRatio;
    }

    /*** Now work the formula back to  find the actual refresh rate set **/
    if(Ratio < 3)                 // We'll use the clock frequency
    {
        PanelClockFrequency = pParams->Clock;
    }
    else
    {
        PanelClockFrequency = pParams->Clock / Ratio;
    }

    if(pParams->eType == apCLCD_STN)    // This enforces a minimum > 2
    {    
        if(pParams->eColorType == apCLCD_STN_COLOR)
        {
            PanelClockFrequency = PanelClockFrequency * 8 / 3;
        }
        else if(pParams->eInterface == apCLCD_STN_8BIT)
        {
            PanelClockFrequency *= 8;
        }
        else
        {
            PanelClockFrequency *= 4;
        }
    }    
    pParams->Refresh = PanelClockFrequency / PixPerFrame;

    return Ratio;
}

/******************************************************************************\
* Description:  Timing0 register setup                                         *
* Operation:    Generates the appropriate pattern for the Timing0 register     *
*               from the current parameters defined and loads the register     *
\******************************************************************************/
INLINE void CLCD_Timing0Set(CLCD_sRegisters       * CONST pRegisters,
                            apCLCD_sDisplayParams * CONST pParams)
{
    pRegisters->Timing0 =
        apBIT_BUILD(CLCD_TIMING0_PPL, pParams->LineWidth / 16 - 1) |
        apBIT_BUILD(CLCD_TIMING0_HSW, pParams->HSync  - 1)         |
        apBIT_BUILD(CLCD_TIMING0_HFP, pParams->HFront - 1)         |
        apBIT_BUILD(CLCD_TIMING0_HBP, pParams->HBack  - 1);                
}

/******************************************************************************\
* Description:  Timing1 register setup                                         *
* Operation:    Generates the appropriate pattern for the Timing1 register     *
*               from the current parameters defined and loads the register     *
* Notes:        This is only called during initialisation, and so can use the  *
*               apCLCD_sDisplayParams structure                                *
\******************************************************************************/
INLINE void CLCD_Timing1Set(CLCD_sRegisters       * CONST pRegisters,
                            apCLCD_sDisplayParams * CONST pParams)
{
    UWORD32 NumLines = pParams->NumLines;
     
    if((pParams->eType  == apCLCD_STN)      && 
       (pParams->ePanel == apCLCD_STN_DUAL))
    {
        NumLines /= 2;      // Need real number of lines per panel
    }

    if(pParams->VSync)                  // Make sure it's not a silly value
    {
        pRegisters->Timing1 = 
            apBIT_BUILD(CLCD_TIMING1_LPP, NumLines -1)        |
            apBIT_BUILD(CLCD_TIMING1_VSW, pParams->VSync - 1) |
            apBIT_BUILD(CLCD_TIMING1_VFP, pParams->VFront)    |
            apBIT_BUILD(CLCD_TIMING1_VBP, pParams->VBack);
    }
    else
    {
        pRegisters->Timing1 = 
            apBIT_BUILD(CLCD_TIMING1_LPP, NumLines -1)     |
            apBIT_BUILD(CLCD_TIMING1_VSW, pParams->VSync)  |
            apBIT_BUILD(CLCD_TIMING1_VFP, pParams->VFront) |
            apBIT_BUILD(CLCD_TIMING1_VBP, pParams->VBack);
    }
}

/******************************************************************************\
* Description:  Timing2 register setup                                         *
* Operation:    Uses the current parameters to generate the Timing2 register   *
*               and loads the register                                         *
* Notes:        This is only called during initialisation, and so can use the  *
*               apCLCD_sDisplayParams structure                                *
\******************************************************************************/
INLINE void CLCD_Timing2Set(CLCD_sRegisters       * CONST pRegisters,
                            apCLCD_sDisplayParams * CONST pParams)
{
    UWORD32 reg = 0;                                    // Start with a blank sheet
    UWORD32 CPL = pParams->LineWidth;               // Correct for TFT...
    WORD32  PCD;                                // ...so is this
    WORD32  NumLines = pParams->NumLines;

    if(pParams->eType == apCLCD_STN)
    {
        if(pParams->eColorType == apCLCD_STN_COLOR)     // Adjust clocks / line
        {
            CPL = CPL * 3 / 8;
        }
        else
        {
            if(pParams->eInterface == apCLCD_STN_8BIT)
            {
                CPL /= 8;
            }
            else
            {
                CPL /= 4;
            }
        }    

        if(pParams->ePanel == apCLCD_STN_DUAL)
        {
            NumLines /= 2;
        }
    }

    PCD = CLCD_ClockRatioCompute(pParams, NumLines);

    if(PCD < 2)                 // This can only happen if its TFT
    {
        reg |= bmCLCD_TIMING2_BCD;  // Bypass Clock divisor instead of PCD
    }
    else
    {
        PCD = PCD - 2;
        apBIT_SET(reg, CLCD_TIMING2_PCD_LO, PCD & bmCLCD_TIMING2_PCD_LO);
        apBIT_SET(reg, CLCD_TIMING2_PCD_HI, PCD >> bwCLCD_TIMING2_PCD_LO);
    }

    reg |=
        apBIT_BUILD(CLCD_TIMING2_CPL, CPL-1)                     |
        apBIT_BUILD(CLCD_TIMING2_ACB, pParams->ACBias)           |
        (UWORD32) pParams->eVSyncActive << bsCLCD_TIMING2_IVS    |
        (UWORD32) pParams->eHSyncActive << bsCLCD_TIMING2_IHS    |
        (UWORD32) pParams->eDataDrive   << bsCLCD_TIMING2_IPC    |
        (UWORD32) pParams->eClockSource << bsCLCD_TIMING2_CLKSEL |
        apBIT_BUILD(CLCD_TIMING2_IEO, pParams->eTftClac);
    
    pRegisters->Timing2 = reg;
}

/******************************************************************************\
* Description:  Timing3 register setup                                         *
* Operation:    Generates the appropriate pattern for the Timing3 register     *
*               from the current parameters and loads the register             *
\******************************************************************************/
INLINE void CLCD_Timing3Set(CLCD_sRegisters       * CONST pRegisters,
                            apCLCD_sDisplayParams * CONST pParams)
{
    UWORD32 reg = pParams->ClleDelay;

    if(reg)
    {
        reg--;
        reg |= bmCLCD_TIMING3_LEE;
    }

    pRegisters->Timing3 = reg;
}

/******************************************************************************\
* Description:  Control register setup                                         *
* Operation:    Generates the appropriate pattern for the Control register     *
*               from the current parameters defined and loads the register     *
* Notes:        It is assumed that the LCD is already Powered down, and LcdEn  *
*               and LcdPwr have been set to 0 using the correct algorithm.     *
\******************************************************************************/
INLINE void CLCD_ControlSet(CLCD_sRegisters       * CONST pRegisters,
                            apCLCD_sDisplayParams * CONST pParams)
{
    UWORD32 reg =
        ((UWORD32) pParams->eType         << bsCLCD_CONTROL_LCDTFT)    |
        ((UWORD32) pParams->eColorOrder   << bsCLCD_CONTROL_BGR)       |     
        ((UWORD32) pParams->ePixelOrder   << bsCLCD_CONTROL_BEPO)      |
#ifdef __BIG_ENDIAN
                                    // Select appropriate endianity for target
        ((UWORD32) pParams->ePixelOrder   << bsCLCD_CONTROL_BEBO)      |
#endif
        ((UWORD32) pParams->eReload       << bsCLCD_CONTROL_WATERMARK) |
        ((UWORD32) pParams->eVCInterTime  << bsCLCD_CONTROL_LCDVCOMP)  |
        ((UWORD32) pParams->eBpp          << bsCLCD_CONTROL_LCDBPP);

    /* Only set the STN fields if STN selected */
    if(pParams->eType == apCLCD_STN)
    {
        reg |= ((UWORD32) pParams->eColorType << bsCLCD_CONTROL_LCDBW)    |
               ((UWORD32) pParams->ePanel     << bsCLCD_CONTROL_LCDDUAL);

        if(pParams->eColorType == apCLCD_STN_MONO)
        {
            reg |= (UWORD32) pParams->eInterface << bsCLCD_CONTROL_LCDMONO8;
        }    
    }

    pRegisters->Control = reg;
}

/******************************************************************************\
* Description:  Report the number of bytes of memory needed for the panel in   *
*               use at the current setting of palette bits per pixel           *
\******************************************************************************/
PRIVATE UWORD32 CLCD_BytesPerPanel(CLCD_sStateStruct * CONST pState)
{
    UWORD32 PanelSize = pState->LineWidth * 16 * pState->NumLines;
        
    switch(pState->eBpp)
    {
        case apCLCD_1BPP:
            PanelSize /= 8;
            break;
        case apCLCD_2BPP:
            PanelSize /= 4;
            break;
        case apCLCD_4BPP:
            PanelSize /= 2;
            break;
        case apCLCD_8BPP:
            break;                              // Nothing to do
        case apCLCD_16BPP:
            PanelSize *= 2;
            break;
        case apCLCD_24BPP:
            PanelSize *= 3;
            break;
        default:
            break;
    }

    return ((PanelSize + 3) & ~(3));
}

/******************************************************************************\
* Description:  Set up Bits Per Pixel in the control register                  *
* Operation:    Works out the correct apCLCD_eBpp value for the BPP requested  *
*               Updates control register and parameter structure accordingly   *
*               Calculates the DMA Base addresses if needed                    *
\******************************************************************************/
PUBLIC apError apCLCD_BppSet(apOS_CLCD_oId oId, UWORD32 Bpp)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;
    WORD32 TheBpp = (WORD32)apCLCD_1BPP;            // Seed the computed Bpp
    UWORD32 Loop;

    /*** Check requested bits per pixel is in a range that's possible ***/
    if(Bpp == 0 || Bpp > 24 || (Bpp > 16 && apBIT_GET(pBase->Control, CLCD_CONTROL_LCDTFT) == apCLCD_STN))
    {
        return (apError) apCLCD_INVALID_BPP;
    }

/*** Convert Bits Per Pixel into an apCLCD_eBpp type ***/ 
    for(Loop = 1; Loop < Bpp; Loop *= 2)
    {
        TheBpp++;
    }

    /** Check that the bpp is possible ***/
    if((apCLCD_eBpp)TheBpp != apCLCD_1BPP  &&
       (apCLCD_eBpp)TheBpp != apCLCD_2BPP  &&
       (apCLCD_eBpp)TheBpp != apCLCD_4BPP  &&
       (apCLCD_eBpp)TheBpp != apCLCD_8BPP  &&
       (apCLCD_eBpp)TheBpp != apCLCD_16BPP && 
       (apCLCD_eBpp)TheBpp != apCLCD_24BPP)
    {
        return (apError) apCLCD_INVALID_BPP;
    }

    pState->eBpp = (apCLCD_eBpp) TheBpp;        // Plant in parameter structure

    pBase->Control = (pBase->Control & ~ bmCLCD_CONTROL_LCDBPP) |
                     ((UWORD32)pState->eBpp << bsCLCD_CONTROL_LCDBPP);

    // Set up the DMA base register(s), which must be on 4 byte boundary
    // so DMA can handle it. Single panel displays use only the upper one
    // and Dual panel displays use both
    if(pState->ePanel == apCLCD_STN_DUAL)
    {
        pBase->LpBase = (pState->DMABase & bmCLCD_ADDRESS) + CLCD_BytesPerPanel(pState);
    }
    pBase->UpBase = pState->DMABase;   // Single uses upper

    return apERR_NONE;
}

/******************************************************************************\
* Description:  Set the Refresh rate requested                                 *
* Operation:    Stores the Refresh rate in the parameter structure, and calls  *
*               ComputePCD to generate the Panel Clock Divisor, which may      *
*               modify the Refresh setting.                                    *
* Returns:      Returns the value actually established                         *
* Notes:  1) This has no effect on TFT displays                                *
*         2) Uses the parameter structure passed in via apCLCD_Initialize      *
\******************************************************************************/
PUBLIC UWORD32 apCLCD_RefreshSet(apOS_CLCD_oId oId, UWORD32 Refresh)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;
    apCLCD_sDisplayParams * CONST pParams = pState->pParameters;
    WORD32 ClockRatio;

    pParams->Refresh = Refresh;                     // Save the refresh rate
                                            // Work out PCD (& ammend Refresh)
    ClockRatio = CLCD_ClockRatioCompute(pParams, pState->NumLines);

    if(ClockRatio < 2)                 // This can only happen if its TFT
    {
        apBIT_SET(pBase->Timing2, CLCD_TIMING2_BCD, 1);
    }
    else
    {
        ClockRatio = ClockRatio - 2;
        apBIT_SET(pBase->Timing2, CLCD_TIMING2_PCD_LO, ClockRatio & bmCLCD_TIMING2_PCD_LO);
        apBIT_SET(pBase->Timing2, CLCD_TIMING2_PCD_HI, ClockRatio >> bwCLCD_TIMING2_PCD_LO);
        apBIT_SET(pBase->Timing2, CLCD_TIMING2_BCD, 0);
    }

    return pParams->Refresh;
}

/******************************************************************************\
* Description:  Convert an apCLCD_sPalette structure entry to PrimeCell format *
* Operation:    Takes the Red, Green and Blue bytes from the Palette structure *
*               and forms them into the PrimeCell the 16-bit format defining   *
*               a colour:-  IBBBBGGGGRRRR  or IRRRRGGGGBBBB                    *
*               I, The Intensity bit (only used on TFT displays) is set if the *
*               total padding is on average greater than a half.               *
* Returns:      A PrimeCell format palette value                               *
\******************************************************************************/
INLINE UHWD16 CLCD_ConvertPalette(apOS_CLCD_oId oId, apCLCD_sPalette sPal)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);

    // Make up a reasonable value for the 'intensity' bit.
    UBYTE8 intensity = (UBYTE8)(((sPal.sRgb.Red   & CLCD_PALETTE_PAD_MASK) +
                                 (sPal.sRgb.Green & CLCD_PALETTE_PAD_MASK) +
                                 (sPal.sRgb.Blue  & CLCD_PALETTE_PAD_MASK)) > (CLCD_PALETTE_PAD_MASK * 3 / 2));

    if(pState->pBaseAddress->Control & bmCLCD_CONTROL_BGR)       // Red and blue depend on RGB/BGR
    {
        return (UHWD16)(((sPal.sRgb.Green >> CLCD_PALETTE_PAD_BITS) << bsCLCD_PALETTE_G) |
                         (intensity << bsCLCD_PALETTE_I)                                 |
                        ((sPal.sRgb.Red  >> CLCD_PALETTE_PAD_BITS) << bsCLCD_PALETTE_B)  |
                        ((sPal.sRgb.Blue >> CLCD_PALETTE_PAD_BITS) << bsCLCD_PALETTE_R));
    }
    
    return (UHWD16)(((sPal.sRgb.Green >> CLCD_PALETTE_PAD_BITS) << bsCLCD_PALETTE_G) |
                     (intensity << bsCLCD_PALETTE_I)                                 |
                     ((sPal.sRgb.Red  >> CLCD_PALETTE_PAD_BITS) << bsCLCD_PALETTE_R) |
                     ((sPal.sRgb.Blue >> CLCD_PALETTE_PAD_BITS) << bsCLCD_PALETTE_B));
}

/******************************************************************************\
* Description:  Loads data from an apCLCD_sPalette structure to the PrimeCell  *
* Operation:    Uses ConvertPalette on each colour value to produce the 16-bit *
*               colour definition, and packs them 2 to a 32 bit word into the  *
*               PrimeCell palette.                                             *
\******************************************************************************/
PUBLIC apError apCLCD_PaletteSet(apOS_CLCD_oId         oId,
                                 CONST apCLCD_sPalette sPalette[ ],
                                 UWORD32               Entries)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;
    UWORD32 palword = 0;
    UWORD32 I;

    if(Entries > 256)
    {
        return (apError) apCLCD_PALETTE_TOO_BIG;
    }

    for(I = 0; I < Entries; I++)
    {
        UHWD16 colour = CLCD_ConvertPalette(oId, sPalette[ I ]);

        if(I & 1)
        {
        //   Add the high half of the palette value and write to the PrimeCell
            palword |= (UWORD32) colour << CLCD_PALETTE_ENTRY_SIZE;
            pBase->Palette[ I / 2 ] = palword;
        }
        else
        {
        //   Set the low half of the palette value
            palword = colour;
        }
    }
                    
    if(Entries & 1)        // One left over if given an odd number of entries
    {                                      //  Add in the current high half
        palword |= pBase->Palette[Entries / 2] & CLCD_HIGH_PALETTE_ENTRY_MASK;
                                            // ... and write the new value back
        pBase->Palette[Entries / 2] = palword;
    }

    return apERR_NONE;
}

/******************************************************************************\
* Description:  Disables all CLCD interrupts                                   *
* Operation:    Disables interrupts and clears any that are pending            *
\******************************************************************************/
PUBLIC void apCLCD_InterruptsDisable(apOS_CLCD_oId oId)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    pBase->IntrEnable = apCLCD_NO_INTERRUPTS;    // Disable all LCD interrupts
#if (defined (apCLCD_VERSION) && ((apCLCD_VERSION ==  PL110) || (apCLCD_VERSION ==  PL111)))
    pBase->IntrClear = pBase->MaskIntStatus;     // Read interrupts pending and clear all pending
#else
    pBase->RawIntStatus = pBase->MaskIntStatus;  // Read interrupts pending and clear all pending
#endif
}

/******************************************************************************\
* Description:  Enable specified CLCD interrupts                               *
\******************************************************************************/
PUBLIC void apCLCD_InterruptEventsEnable(apOS_CLCD_oId oId, UWORD32 Interrupts)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);

    pState->pBaseAddress->IntrEnable |= Interrupts;
}

/******************************************************************************\
* Description:  Disable specified CLCD interrupts                              *
\******************************************************************************/
PUBLIC void apCLCD_InterruptEventsDisable(apOS_CLCD_oId oId, UWORD32 Interrupts)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);

    pState->pBaseAddress->IntrEnable &= ~Interrupts;
}

/******************************************************************************\
* Description:  Set required VCOMP interrupt event                             *
* Operation:    Sets the Vertical Compare interrupt reason. This is always     *
*               done, even if interrupts are precluded by the LCD settings     *
* Return:       TRUE unless the setting requested precludes VComp interrupts   *
\******************************************************************************/
PUBLIC BOOL apCLCD_VCompEventsEnable(apOS_CLCD_oId       oId,
                                     apCLCD_eVComp_ITime eVCompEvent)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);

    pState->pBaseAddress->Control = 
        apBIT_CLEAR(pState->pBaseAddress->Control, CLCD_CONTROL_LCDVCOMP) |
        ((UWORD32)eVCompEvent << bsCLCD_CONTROL_LCDVCOMP);

    pState->eVCInterTime = eVCompEvent;             // Save in parameters

    /** There is a group of settings that preclude interrupts happening ***/
    return (eVCompEvent == apCLCD_BACK_P  && pState->VBack  == 0) ||
           (eVCompEvent == apCLCD_FRONT_P && pState->VFront == 0) ? FALSE : TRUE;
}

/******************************************************************************\
* Description:  Save User's Interrupt handler                                  *
* Operation:    Stores the Users's interrupt handler routine address. The CLCD *
*               can aperate with no interrupts, however they can be useful to  *
*               application. eg For synchronising display, or switching        *
*               display buffers                                                *
\******************************************************************************/
PUBLIC void apCLCD_RegisterCallback(apOS_CLCD_oId    oId, 
                                    apCLCD_rCallback rCallback)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);

    pState->rCallback = rCallback;              // Plant the User's callback
}

/******************************************************************************\
* Description:  CLCD Interrupt handler                                         *
* Operation:    Carries out the basic interrupt handling, and calls any user   *
*               function that has been registered                              *
\******************************************************************************/
PUBLIC void apCLCD_IntHandler(CONST apOS_INT_oInterruptSource oInterruptId,
                              UWORD32                         DeviceId)
{
    CLCD_sStateStruct * pState = apSTATE_GET(CLCD, (apOS_CLCD_oId) DeviceId); // The state structure
    CLCD_sRegisters * pBase = pState->pBaseAddress; // The PrimeCell registers
    UWORD32 Status;                                 // PrimeCell Interrupt status
    UWORD32 CursorStatus = 0;
    
    /*** Deal with interrupt as soon as possible    ***/
    apOS_ISR_InterruptDisable(oInterruptId);     // Disable & clear interrupts
    apOS_INT_InterruptClear(oInterruptId);
    
#if (defined (apCLCD_VERSION) && (apCLCD_VERSION ==  PL111))
    CursorStatus = pBase->CursorMIS;            // Check cursor interrupt
    pBase->CursorICR = CursorStatus;            // Clear cursor interrupt
#endif

    Status = pBase->MaskIntStatus;              // What interrupt(s) occurred?
#if (defined (apCLCD_VERSION) && ((apCLCD_VERSION ==  PL110) || (apCLCD_VERSION ==  PL111)))
    pBase->IntrClear = Status;                  // Clear the events in PrimeCell
#else
    pBase->RawIntStatus = Status;                     // Clear the events in PrimeCell
#endif

    if(pState->WaitForVComp && apBIT_GET(Status, CLCD_STATUS_VCOMP))
    {
        pState->VCompReceived = TRUE;
    }
    
    /*** LCD interrupts may require user action             ***/
    /*** If a callback function has been registered use it  ***/
    if(pState->rCallback != aRNULL)
    {
        if(apBIT_GET(Status, CLCD_STATUS_FUF))        // Upper panel FIFO underflow
        {
            pState->rCallback(apCLCD_FUF);
        }
        if(apBIT_GET(Status, CLCD_STATUS_LNBU))       // Base address update request
        {
            pState->rCallback(apCLCD_NEXT_BASE_UP);
        }
        if(apBIT_GET(Status, CLCD_STATUS_VCOMP))      // Vertical compare interrupt
        {
            pState->rCallback(apCLCD_VCOMP);
        }
        if(apBIT_GET(Status, CLCD_STATUS_MBERROR))    // Bus error interrupt
        {
            pState->rCallback(apCLCD_MBERR);
        }
        if(CursorStatus)                              // Cursor interrupt
        {
            pState->rCallback(apCLCD_CURSOR);
        }
    }
    apOS_ISR_InterruptEnable(oInterruptId);
}

/*
 * This function is a raw interrupt service routine entry point, 
 * which can be called from the interrupt vector
 */
PUBLIC IRQ void apCLCD_RawISR(void)
{
    UWORD32 oId;
    apOS_INT_oInterruptSource oSource;

#if !apOS_NO_STATIC_STATE
    /*peripheral instance 0 if only one in use*/
    if(apOS_CLCD_MAXIMUM == 1)
    {
        oId = 0;
    }
    else
#endif
    {
        /* retrieve the peripheral instance */
        oId = apOS_INT_InstanceGet();
    }
    /* retrieve the active interrupt source */
    oSource = apOS_INT_SourceGet();

    /* call the normal ISR entry point */
    apCLCD_IntHandler(oSource, oId);
}

/******************************************************************************\
* Description:  CLCD PrimeCell driver initialisation                           *
* Operation:    Plant the register and parameter structure pointers into       *
*               the state structure and set up the interrupt handling          *
\******************************************************************************/
PUBLIC void apCLCD_Initialize(apOS_CLCD_oId                     oId,
                              apOS_System_eBaseAddress          Base, 
                              UWORD32                           Interrupts,
                              CONST apOS_INT_oInterruptSource * pSources,
                              void                            * pInitial)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    IGNORE(pInitial);
                                            // Save data in the state structure
    pState->pBaseAddress = (CLCD_sRegisters *) Base;

    /*** Set up interrupt linkage ***/
    pState->WaitForVComp = FALSE;
    pState->rCallback = aRNULL;                     // Unhook User's callback
    apCLCD_InterruptsDisable(oId);      // Disable, there may be some waiting
    apBIND_ALL_INTERRUPTS(apCLCD_IntHandler, apCLCD_RawISR);
}

/******************************************************************************\
* Description:  CLCD Panel specific initialisation                             *
* Operation:    Initialise the PrimeCell from the parameter structure          *
\******************************************************************************/
PUBLIC apError apCLCD_PanelInitialize(apOS_CLCD_oId           oId,
                                      apCLCD_sDisplayParams * pParams)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

/* Check the parameters are sensible */
    if((pParams->LineWidth & 15) != 0)  // Lines must be multiple of 16 pixels
    {
        return (apError) apCLCD_INCORRECT_WIDTH;
    }
                            /*** Check that the display type is specified ***/
    if(pParams->eType == apCLCD_STN)                        // Either it's STN
    {
         /** For an STN displays, check it's fully specified ***/
        if((pParams->eColorType != apCLCD_STN_COLOR  && pParams->eColorType != apCLCD_STN_MONO) ||
           (pParams->eInterface != apCLCD_STN_4BIT   && pParams->eInterface != apCLCD_STN_8BIT) ||
           (pParams->ePanel     != apCLCD_STN_SINGLE && pParams->ePanel     != apCLCD_STN_DUAL))
        {
            return (apError) apCLCD_INVALID_DISPLAY_TYPE;
        }

        if(!pParams->ACBias)    // STN displays with no AC bias deteriorate
        {
            return (apError) apCLCD_NO_AC_BIAS;
        }
    }
    else if(pParams->eType != apCLCD_TFT)                   // Or it must be TFT
    {
        return (apError) apCLCD_INVALID_DISPLAY_TYPE;
    }

    /*** Finally ensure that all other required settings are present ***/
    // Firstly some ordering definitions    
    if((pParams->eColorOrder  != apCLCD_RGB              &&      // Colour descriptions
        pParams->eColorOrder  != apCLCD_BGR)                 || 

       (pParams->ePixelOrder  != apCLCD_BIG_ENDIAN_BYTES &&      // Byte order
        pParams->ePixelOrder  != apCLCD_LITTLE_ENDIAN_BYTES) || 

       (pParams->eReload      != apCLCD_RELOAD_EARLY     &&      // FIFO ready interrupt timing 
        pParams->eReload      != apCLCD_RELOAD_LATE)         ||
   
    // Finally various signal sense definitions
       (pParams->eVSyncActive != apCLCD_LCDFP_H          &&
        pParams->eVSyncActive != apCLCD_LCDFP_L)             ||

       (pParams->eHSyncActive != apCLCD_LCDLP_H          &&
        pParams->eHSyncActive != apCLCD_LCDLP_L)             ||

       (pParams->eDataDrive   != apCLCD_CLCP_R           &&  
        pParams->eDataDrive   != apCLCD_CLCP_F)              ||
        
       (pParams->eClockSource != apCLCD_INTERNAL_CLOCK   &&
        pParams->eClockSource != apCLCD_EXTERNAL_CLOCK)      ||

       (pParams->eType        == apCLCD_TFT              &&
        pParams->eTftClac     != apCLCD_CLAC_H           &&
        pParams->eTftClac     != apCLCD_CLAC_L))
    {
        return (apError) apCLCD_NO_SETTING;
    }      

    pState->pParameters = pParams;          // Save the parameter pointer

    /*** copy parameters that need to be preserved into state structure ***/
    pState->ePanel    = pParams->ePanel;
    pState->LineWidth = pParams->LineWidth;
    pState->NumLines  = pParams->NumLines;       // total height of the screen

    if (pParams->eType == apCLCD_STN && pParams->ePanel == apCLCD_STN_DUAL)
    {
        pState->NumLines /= 2;                  // Really need lines per panel
    }

/*** These are neded because of the perverse behaviour of the VComp Interrupt */
    pState->eVCInterTime = pParams->eVCInterTime;
    pState->VBack        = pParams->VBack;
    pState->VFront       = pParams->VFront;

/*** These are needed so that drawing functions can map the memory ***/
    pState->ePixelOrder = pParams->ePixelOrder;  /* pixel ordering within a byte       */
    pState->eBpp        = pParams->eBpp;     /* bits per pixel. This might change...   */

/*** Display unit specific values ***/
#ifndef apCLCD_NO_POWERUP_DELAY
    pState->PowerUpDel   = pParams->PowerUpDel;   /* Delay between LcdEn & LcdPwr on    */
#endif
    pState->PowerDownDel = pParams->PowerDownDel; /* Delay between LcdPwr & LcdEn off   */

/*** Set up panel addresses ***/
    apCLCD_DMAFrameBufferSet( oId, pParams->DMABase);
  
#if (defined (apCLCD_USER_SETUP) && (apCLCD_USER_SETUP))
/******************************************************************************\
 *** NOTE: Because of variations between panels, there may be setup that    ***
 *** cannot be generalised, but must be carried out before anything else.   ***
\******************************************************************************/
    pState->rSwitchOff = pParams->rSwitchOff;
    pState->rSwitchOn  = pParams->rSwitchOn;

    if(pParams->rPreamble != aRNULL)
    {
        pParams->rPreamble();
    }
#endif

/* Set up all the registers */
    apCLCD_PowerDown(oId);                                      // To be sure

    CLCD_ControlSet(pBase, pParams);
    CLCD_Timing0Set(pBase, pParams);
    CLCD_Timing1Set(pBase, pParams);
    CLCD_Timing2Set(pBase, pParams);
    CLCD_Timing3Set(pBase, pParams);

    pBase->IntrEnable = apCLCD_NO_INTERRUPTS;           // Disable interrupts

    return apERR_NONE;
}

/******************************************************************************\
* Description:  Wait for a number of vertical compare periods                  *
* Parameters:   ID of the specific device attached to the PrimeCell            *
*               Number of retrace periods                                      *
* Operation:    Clears vertical trace in status, and waits for it to come back *
*               the right number of times. Exit at start of period             *
* NOTES: 1) The Vcomp status is updated so long as the PrimeCell is enabled    *
*           (LcdEn). It is not affected by the state of LcdPwr.                *
*        2) The status is not updated if the Vertical Compare interrupt is     *
*           disabled, or Vertical Compare is set on start of front porch and   *
*           the front porch value is zero, or it's set on back porch with zero *
*           back porch value. In these cases the function returns immediately  *
\******************************************************************************/

PUBLIC apError apCLCD_WaitVComp(apOS_CLCD_oId oId, UWORD32 VCompCount)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    /* Check for all the cases where interrupts do not happen */
    if(   (pBase->Control & bmCLCD_CONTROL_LCDEN) == 0 // PrimeCell not enabled
       || (pBase->IntrEnable & bmCLCD_STATUS_VCOMP) == 0   // Interrupt not enabled 
       || (   pState->eVCInterTime == apCLCD_BACK_P
           && pState->VBack == 0                       // Trigger on non-existent back porch
          ) 
       || (   pState->eVCInterTime == apCLCD_FRONT_P
           && pState->VFront == 0                      // Trigger on non-existent front porch
          ) 
      )
    {
        return apERR_NONE;              // Can't be done
    }

    pState->VCompReceived = FALSE;      // Clear Vertical compare
    pState->WaitForVComp = TRUE;
    
    while(VCompCount) 
    {
        UWORD32 Counter = apCLCD_VCOMP_TIMEOUT_VALUE;                    // Set counter
        
        while(pState->VCompReceived == FALSE)   // Wait for VComp
        {
            if(Counter == 0)
            {
                pState->WaitForVComp = FALSE;
                return (apError) apCLCD_VCOMP_TIMEOUT;
            }
            
            Counter--;
        }        

        // Got VComp
        pState->VCompReceived = FALSE;    // Clear the event
        VCompCount--;
    }

    pState->WaitForVComp = FALSE;
    return apERR_NONE;
}

/******************************************************************************\
* Description:  Establish the DMA Frame buffer address(es)                     *
* Notes:        Typically used to switch buffers on LNBUINTR interrupts        *
\******************************************************************************/
PUBLIC void apCLCD_DMAFrameBufferSet(apOS_CLCD_oId oId, UWORD32 DMABase)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    pState->DMABase = DMABase & bmCLCD_ADDRESS;             // Save the setting

    if(pState->ePanel == apCLCD_STN_DUAL)      // Dual panel use both registers
    {                       // Must be on 4 byte boundary so DMA can handle it
        pBase->LpBase = pState->DMABase + CLCD_BytesPerPanel(pState);
    }

    pBase->UpBase = pState->DMABase;   // Single panel uses upper only
}

/******************************************************************************\
* Description:  Returns the DMA Frame buffer address in use.                   *
* Notes:        Typically used to switch buffers on LNBUINTR interrupts        *
\******************************************************************************/
PUBLIC UWORD32 apCLCD_DMAFrameBufferGet(apOS_CLCD_oId oId)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);

    return pState->pBaseAddress->UpBase & bmCLCD_ADDRESS;
}

/******************************************************************************\
* Description:  Returns the Screen width in pixels                             *
\******************************************************************************/
PUBLIC UWORD32 apCLCD_LineWidthGet(apOS_CLCD_oId oId)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    return pState->LineWidth;
}

/******************************************************************************\
* Description:  Returns the Bits per pixel currently in use                    *
\******************************************************************************/
PUBLIC apCLCD_eBpp apCLCD_BppGet(apOS_CLCD_oId oId)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    return pState->eBpp;
}

/******************************************************************************\
* Description:  Returns the number of lines on a Display                       *
\******************************************************************************/
PUBLIC UWORD32 apCLCD_LinesPerScreenGet(apOS_CLCD_oId oId)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);

    return (pState->ePanel == apCLCD_STN_DUAL) ? pState->NumLines * 2
                                               : pState->NumLines;
}

/******************************************************************************\
* Description:  Returns the Pixel order                                        *
\******************************************************************************/
PUBLIC apCLCD_ePixelOrder apCLCD_PixelOrderGet(apOS_CLCD_oId oId)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    return pState->ePixelOrder;
}

#if (defined (apCLCD_VERSION) && (apCLCD_VERSION ==  PL111))
/******************************************************************************\
*  Hardware Cursor Control Functions                                           *
\******************************************************************************/
PUBLIC void apCLCD_CursorOn(apOS_CLCD_oId oId)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    apBIT_SET(pBase->CursorControl,CLCD_CURSOR_CONTROL_ON,1);
}

/*====================================================================*/
PUBLIC void apCLCD_CursorOff(apOS_CLCD_oId oId)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    apBIT_SET(pBase->CursorControl,CLCD_CURSOR_CONTROL_ON,0);
}

/*====================================================================*/
PUBLIC void apCLCD_CursorImageSelect(apOS_CLCD_oId oId, apCLCD_eCursorImage eImageNumber)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    apBIT_SET(pBase->CursorControl,CLCD_CURSOR_CONTROL_IMAGE,eImageNumber);
}

/*====================================================================*/
PUBLIC apCLCD_eCursorImage apCLCD_CursorImageGet(apOS_CLCD_oId oId)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    return (apCLCD_eCursorImage) apBIT_GET(pBase->CursorControl,CLCD_CURSOR_CONTROL_IMAGE);
}

/*====================================================================*/
PUBLIC void apCLCD_CursorSyncOn(apOS_CLCD_oId oId)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    apBIT_SET(pBase->CursorConfig,CLCD_CURSOR_CONFIG_SYNC,1);
}

/*====================================================================*/
PUBLIC void apCLCD_CursorSyncOff(apOS_CLCD_oId oId)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    apBIT_SET(pBase->CursorConfig,CLCD_CURSOR_CONFIG_SYNC,0);
}

/*====================================================================*/
PUBLIC void apCLCD_CursorSizeSet(apOS_CLCD_oId oId, apCLCD_eCursorSize eSize)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    apBIT_SET(pBase->CursorConfig,CLCD_CURSOR_CONFIG_SIZE,eSize);
}

/*====================================================================*/
PUBLIC apCLCD_eCursorSize apCLCD_CursorSizeGet(apOS_CLCD_oId oId)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    return (apCLCD_eCursorSize) apBIT_GET(pBase->CursorConfig,CLCD_CURSOR_CONFIG_SIZE);
}

/*====================================================================*/
PUBLIC void apCLCD_CursorPositionSet(apOS_CLCD_oId oId, UWORD32 X, UWORD32 Y)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    pBase->CursorPosition =
        apBIT_BUILD( CLCD_CURSOR_POSITION_X, X )  |
        apBIT_BUILD( CLCD_CURSOR_POSITION_Y, Y );
}

/*====================================================================*/
PUBLIC void apCLCD_CursorPositionGet(apOS_CLCD_oId oId, UWORD32 * CONST pX, UWORD32 * CONST pY)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    *pX = apBIT_GET(pBase->CursorPosition, CLCD_CURSOR_POSITION_X);
    *pY = apBIT_GET(pBase->CursorPosition, CLCD_CURSOR_POSITION_Y);
}

/*====================================================================*/
PUBLIC void apCLCD_CursorClipSet(apOS_CLCD_oId oId, UWORD32 ClipX, UWORD32 ClipY)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    pBase->CursorClip =
        apBIT_BUILD( CLCD_CURSOR_CLIP_X, ClipX )  |
        apBIT_BUILD( CLCD_CURSOR_CLIP_Y, ClipY );
}

/*====================================================================*/
PUBLIC void apCLCD_CursorClipGet(apOS_CLCD_oId oId, UWORD32 * CONST pClipX, UWORD32 * CONST pClipY)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    *pClipX = apBIT_GET(pBase->CursorClip, CLCD_CURSOR_CLIP_X);
    *pClipY = apBIT_GET(pBase->CursorClip, CLCD_CURSOR_CLIP_Y);
}

/*====================================================================*/
PUBLIC void apCLCD_CursorInterruptEnable(apOS_CLCD_oId oId)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    apBIT_SET(pBase->CursorIMSC,CLCD_CURSOR_INTERRUPT,1);
}

/*====================================================================*/
PUBLIC void apCLCD_CursorInterruptDisable(apOS_CLCD_oId oId)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    apBIT_CLEAR(pBase->CursorIMSC,CLCD_CURSOR_INTERRUPT);       // clear interrupt mask
    apBIT_SET_NOREAD(pBase->CursorICR,CLCD_CURSOR_INTERRUPT,1); // clear any interrupt pending
}

/*====================================================================*/
PUBLIC void apCLCD_CursorPaletteSet(apOS_CLCD_oId oId,
                                    UWORD32 * pPalette0,
                                    UWORD32 * pPalette1)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;

    pBase->CursorPalette0 =
        apBIT_BUILD( CLCD_CURSOR_PALETTE_R, pPalette0[0] )  |
        apBIT_BUILD( CLCD_CURSOR_PALETTE_G, pPalette0[1] )  |
        apBIT_BUILD( CLCD_CURSOR_PALETTE_B, pPalette0[2] );

    pBase->CursorPalette1 =
        apBIT_BUILD( CLCD_CURSOR_PALETTE_R, pPalette1[0] )  |
        apBIT_BUILD( CLCD_CURSOR_PALETTE_G, pPalette1[1] )  |
        apBIT_BUILD( CLCD_CURSOR_PALETTE_B, pPalette1[2] );
}

/*====================================================================*/
PUBLIC void apCLCD_CursorImageLoad(apOS_CLCD_oId oId,
                                   apCLCD_eCursorImage eImageNumber,
                                   UWORD32 * pImage)
{
    CLCD_sStateStruct * CONST pState = apSTATE_GET(CLCD, oId);
    CLCD_sRegisters * CONST pBase = pState->pBaseAddress;
    UWORD32 I;
    
    if( apBIT_GET(pBase->CursorConfig,CLCD_CURSOR_CONFIG_SIZE) == apCLCD_CURSOR_SIZE_64)
    {
        // 64x64 pixel cursor
        for(I = 0; I < 256; I++)
        {
            pBase->CursorImage[I] = *pImage++;
        }
    }
    else
    {
        // 32x32 pixel cursor
        for(I=((UWORD32)eImageNumber * 64); I<(((UWORD32)eImageNumber +1 ) * 64); I++)
        {
            pBase->CursorImage[I] = *pImage++;
        }
    }
}

#endif

#if defined(apOS_NO_STATIC_STATE) && (apOS_NO_STATIC_STATE)
/******************************************************************************\
* Description:  Report CLCD State structure size                               *
* Operation:    When used with apOS_NO_STATIC_STATE the caller must allocate   *
*               space for the state data and needs to know how much is needed. *
\******************************************************************************/
PUBLIC WORD32 apCLCD_StateSizeGet(void)
{
    return sizeof(CLCD_sStateStruct);
}
#endif
