//
// Copyright (c) Microsoft Corporation.  All rights reserved.
//
//
// Use of this source code is subject to the terms of the Microsoft end-user
// license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
// If you did not accept the terms of the EULA, you are not authorized to use
// this source code. For a copy of the EULA, please see the LICENSE.RTF on your
// install media.
//
/*


*/
#define DDI 1
#include <windows.h>
#include <winddi.h>
#include <gpe.h>
#include <emul.h>
#include <ctblt.h>
#include <aablt.h>
#include <memory.h>
#include <wingdi.h>
#include "dispperf.h"

extern ULONG g_BilinearMasks[4];
extern ULONG g_BilinearShifts[4];

unsigned long
ProcessROP3(
    unsigned long dstValue,
    unsigned long srcValue,
    unsigned long brushValue,
    unsigned char rop3,
    unsigned char dstBitsPerPixel
    );

unsigned long
RGBError(
    unsigned long v1,
    unsigned long v2
    );

class PixelIterator
{
public:
    // Fixed upon creation:
    unsigned char * RowPtr;
    int             RowIncrement;
    unsigned long   CacheStateNewDWord;
    unsigned long   CacheStateNewRow;
    unsigned long   CacheStateIncrement;
    unsigned long   CacheStateIncrementDirty;
    int             Is24Bit;
    unsigned long   Mask;
    int             BytesPerAccess;
    int             Bpp;
    unsigned char   MaskShiftXor;

    // IteratorState
    unsigned char * Ptr;
    unsigned long   Cache;
    unsigned long   Value;
    unsigned long   CacheState;

    void
    InitPixelIterator(
        GPESurf * pSurf,
        int       xPositive,
        int       yPositive,
        RECTL   * prcl,
        int       xSkip,
        int       ySkip
        );
};

class BrushPixelIterator : public PixelIterator
{
public:
    int             PixelsRemaining;            // Pixels still available this row of brush incl cache
    int             PixelsPerRow;               // Width of source surface
    int             RowInitialPixelsRemaining;  // PixelsRemaining at start of each Dst row
    int             RowsRemaining;              // Rows (incl this) left in pattern
    int             Rows;                       // Total rows in pattern
    int             LeftPixelOffset;            // Byte offset from beginning of the row to LeftRowPtr;
    unsigned char * FirstRowPtr;                // Pointer to first DWord to use in top/bottom row
    unsigned char * LeftRowPtr;                 // Ptr to *left* of pattern of current row
                                                // (RowPtr is *start* of next row)
    void
    InitBrushPixelIterator(
        GPESurf * pSurf,
        int       xPositive,
        int       yPositive,
        RECTL   * prcl
        );

};

void
BrushPixelIterator::InitBrushPixelIterator(
    GPESurf * pSurf,
    int       xPositive,
    int       yPositive,
    RECTL   * prcl
    )
{
    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("BrushPixelIterator::InitBrushPixelIterator\r\n")));
    // This is necessary because 1 is subtracted from prcl->bottom for bottom up bitmaps.
    if (0 == prcl->bottom) prcl->bottom = pSurf->Height();
    InitPixelIterator( pSurf, xPositive, yPositive, prcl, 0, 0 );

    PixelsPerRow = pSurf->Width();
    Rows = pSurf->Height();
    RowInitialPixelsRemaining = xPositive?PixelsPerRow-prcl->left:prcl->right;
    RowsRemaining = yPositive?Rows-prcl->top:prcl->bottom;
    FirstRowPtr = RowPtr - RowIncrement * ( Rows - RowsRemaining );

    // The LeftPixelOffset member is the number of bytes between the FirstRowPtr
    // and the actual beginning of the row of pixels pointed to by FirstRowPtr.
    LeftPixelOffset = EGPEFormatToBpp[pSurf->Format()] * (PixelsPerRow - RowInitialPixelsRemaining);
    LeftPixelOffset = ((LeftPixelOffset&~31)>>3);

    if (!xPositive) LeftPixelOffset = -LeftPixelOffset;

    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("PixelsPerRow=%d, Rows=%d, RowInitPixRem=%d, RowsRem=%d, FirstRowPtr=%08x\r\n"),
        PixelsPerRow, Rows, RowInitialPixelsRemaining, RowsRemaining, FirstRowPtr ));
}

void
PixelIterator::InitPixelIterator(
    GPESurf * pSurf,
    int       xPositive,
    int       yPositive,
    RECTL   * prcl,
    int       xSkip,
    int       ySkip
    )
{
    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("PixelIterator::PixelIterator, prcl= l:%d,t:%d - r:%d,b:%d Bpp=%d\r\n"),
        prcl->left, prcl->top, prcl->right, prcl->bottom, EGPEFormatToBpp[pSurf->Format()]
        ));

    // Set pointer to start of first row to use
    RowPtr = (unsigned char *)(pSurf->Buffer());

    if( yPositive )
    {
        RowIncrement  = pSurf->Stride();
        RowPtr       += pSurf->Stride() * (prcl->top + ySkip );
    }
    else
    {
        RowIncrement  = -pSurf->Stride();
        RowPtr       += pSurf->Stride() *  (prcl->bottom - 1 - ySkip);
    }

    int StartX;
    Bpp = EGPEFormatToBpp[pSurf->Format()];

    MaskShiftXor       = (Bpp<8) ? (8-Bpp) : 0;
    CacheStateNewDWord = (32/Bpp)<<8;        // Initally 32/Bpp pixels in dword, 0 offset

    if( xPositive )
    {
        StartX = prcl->left + xSkip;
        CacheStateIncrement = ((Bpp<<8) - 1)<<8;
    }
    else
    {
        StartX              = prcl->right - 1 - xSkip;
        CacheStateIncrement = (((-Bpp)<<8) - 1)<<8;
        CacheStateNewDWord |= (32 - Bpp)<<16;        // Initial offset points to last pixel in dword
    }

    CacheStateIncrementDirty = CacheStateIncrement+1;
    
    if( Is24Bit = ( pSurf->Format() == gpe24Bpp ) ) // deliberate assignment
    {
        RowPtr         += 3 * StartX;
        BytesPerAccess  = 3;
    }
    else
    {
        int StartBit = Bpp * StartX;

        RowPtr += (StartBit&~31) >> 3;

        // Since the first pixel on row in prcl may not be on dword alignment:
        CacheStateNewRow = CacheStateNewDWord;
        while( (( CacheStateNewRow >> 16 ) ^ StartBit ) & 31 )
        {
            CacheStateNewRow += CacheStateIncrement;
        }

        BytesPerAccess = 4;
    }

    if( !xPositive )
    {
        BytesPerAccess = -BytesPerAccess;
    }

    Mask = ( 2 << (Bpp - 1) ) - 1;

    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("BytesPerAccess=%d,CacheStateNewRow=%06x,CacheStateIncrement=%06x\r\n"),
        BytesPerAccess, CacheStateNewRow, CacheStateIncrement ));
    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("Mask=%08x, CacheStateNewDWord=%08x, StartX=0x%04x(%d)\r\n"),
        Mask, CacheStateNewDWord, StartX, StartX ));
    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("Buffer=0x%08x\r\n"),
        (pSurf->Buffer()) ));
}
#undef SWAP
#define SWAP(a,b,type) { type tmp=a; a=b; b=tmp; }

SCODE
GPE::EmulatedBlt(
    GPEBltParms * pParms
    )
{
    SCODE (GPE::*pBlt)(GPEBltParms*) = pParms->pBlt;
    SCODE sc;
    BOOL bSaveBltFunc = FALSE;

    if( pParms->pDst->InVideoMemory() ||
        ( pParms->pSrc && pParms->pSrc->InVideoMemory() ) ||
        ( pParms->pMask && pParms->pMask->InVideoMemory() ) ||
        ( pParms->pBrush && pParms->pBrush->InVideoMemory() ) )
    {
        // If we have a pending blt and now attempt a software operation using
        // video memory, the pipeline must be flushed.
        WaitForNotBusy();
    }

    // Handle improperly ordered prclDst resulting from stretch Blt
    if (pParms->pBlt != EmulatedBlt)
    {
        bSaveBltFunc = TRUE;
    }

    pParms->pBlt = EmulatedBlt_Internal;

    // Check to see if this should be handled by the ClearType(tm) or
    // AAFont libraries.
    if (pParms->rop4 == 0xAAF0)
    {
        ClearTypeBltSelect(pParms);
        AATextBltSelect(pParms);
    }

    // Check to see if this should be handled by the emul library.
    if (pParms->pBlt == EmulatedBlt_Internal)
    {
        EmulatedBltSelect02(pParms);
        EmulatedBltSelect08(pParms);
        EmulatedBltSelect16(pParms);
    }

    if (pParms->pBlt != EmulatedBlt_Internal)
    {
        DispPerfType(DISPPERF_ACCEL_EMUL);
    }

    // Check to see if we need to use Bilinear stretching
    if (pParms->iMode == BILINEAR)
    {
        LONG DstWidth  = pParms->prclDst->right - pParms->prclDst->left;
        LONG DstHeight = pParms->prclDst->bottom - pParms->prclDst->top;

        if (pParms->bltFlags == BLT_STRETCH
            && pParms->xPositive
            && pParms->yPositive
            && pParms->pDst->Format() > gpe8Bpp
            && (pParms->rop4 == 0xCCCC
                || pParms->rop4 == 0xEEEE
                || pParms->rop4 == 0x8888)
            && DstWidth > 0
            && DstHeight > 0
            && DstWidth >= pParms->prclSrc->right - pParms->prclSrc->left
            && DstHeight >= pParms->prclSrc->bottom - pParms->prclSrc->top)
        {
            pParms->pBlt = EmulatedBlt_Bilinear;
        }
    }

    // Check to see if GeneratedBlts can handle this operation
    if (pParms->pBlt == EmulatedBlt_Internal)
    {
        GeneratedBltSelect(pParms);
    }

    sc = (this->*(pParms->pBlt))(pParms);

    if (bSaveBltFunc)
    {
        pParms->pBlt = pBlt;
    }

    return sc;
}

SCODE
GPE::EmulatedBlt_Internal(
    GPEBltParms *pParms
    )
{
    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("New Blt. rop4=%04X\r\n"), pParms->rop4));

    unsigned char rop3 = (unsigned char)pParms->rop4;
    unsigned char maskedROP3 = (unsigned char)( pParms->rop4 >> 8 );
    unsigned char unmaskedROP3 = rop3;
    int complexBlt = 0;
    int quickWrite = 0;
    int width = pParms->prclDst->right - pParms->prclDst->left;
    int height = pParms->prclDst->bottom - pParms->prclDst->top;
    int x;
    RECTL rclBrush;
    int dstMatters = ((( pParms->rop4 >> 1 ) ^ pParms->rop4 ) & 0x5555 ) != 0;
    int dstXPositive = pParms->xPositive;    // These differ from pParms->?Positive if flipping is being performed
    int dstYPositive = pParms->yPositive;
    RECTL *prclDst = pParms->prclDst;
    RECTL tmpRclDst;
    int xShrinkStretch = 0;
    int xShrink=0;
    int xStretch=0;
    int yShrinkStretch = 0;
    int yShrink=0;
    int yStretch=0;
    int srcWidth;
    int srcHeight;
    int rowXAccum, xAccum, xDMajor, xDMinor;    // only valid if xShrinkStretch
    int yAccum, yDMajor, yDMinor;    // only valid if yShrinkStretch
    int originalMaskRowInc, originalSrcRowInc;    // Used if yShrinkStretch
    unsigned char *prevMaskPtr, *prevSrcPtr;
    unsigned long prevMaskCache, prevSrcCache;
    unsigned long prevMaskCacheState, prevSrcCacheState;
    unsigned long originalSrc;
    unsigned long SrcRGBMask;
    int dstXStartSkip = 0;    // Number of dst pixels to not write (left if dstXPositive else right)
    int dstYStartSkip = 0;    // Number of rows to ignore (top if dstYPositive)
    int srcXStartSkip = 0;
    int srcYStartSkip = 0;

    // Variables used for AlphaBlend.
    ULONG RedMask;
    ULONG GreenMask;
    ULONG BlueMask;
    ULONG AlphaMask;
    ULONG RedShift;
    ULONG GreenShift;
    ULONG BlueShift;
    ULONG AlphaShift;
    ULONG SrcAlphaMask;
    ULONG SrcAlphaShift;

    BOOL  BlendPalette = FALSE;

    // If the BLENDFUNCTION isn't Null, the destination pixel value will need
    // to be read.
    int alphaBlend = 0;
    if (*(DWORD *)&(pParms->blendFunction) != *(DWORD *)&g_NullBlendFunction)
    {
        // Get the format of the source and destination surfaces.
        GPEFormat * pDstFormat = pParms->pDst->FormatPtr();

        if (pDstFormat->m_PaletteEntries == 3)
        {
            RedMask   = pDstFormat->m_pPalette[0];
            GreenMask = pDstFormat->m_pPalette[1];
            BlueMask  = pDstFormat->m_pPalette[2];
            AlphaMask = 0;

            // If this is a 32 bpp surface, try to add an "implicit" Alpha mask.
            if (EGPEFormatToBpp[pParms->pDst->Format()] == 32
                && !(0xFF000000 & (RedMask | GreenMask | BlueMask)))
            {
                AlphaMask = 0xFF000000;
            }
        }
        else if (pDstFormat->m_PaletteEntries == 4 && EGPEFormatToBpp[pParms->pDst->Format()] > 8)
        {
            RedMask   = pDstFormat->m_pPalette[0];
            GreenMask = pDstFormat->m_pPalette[1];
            BlueMask  = pDstFormat->m_pPalette[2];
            AlphaMask = pDstFormat->m_pPalette[3];

        }
        else
        {
            RedMask   = 0x000000FF;
            GreenMask = 0x0000FF00;
            BlueMask  = 0x00FF0000;
            AlphaMask = 0xFF000000;

            BlendPalette = TRUE;
        }

        // Compute the shifts for each mask.
        ULONG bit;
        ULONG Mask = RedMask;
        for (bit = 0; Mask && !(Mask & 1); bit++)
        {
            Mask >>= 1;
        }
        RedShift = bit;

        Mask = GreenMask;
        for (bit = 0; Mask && !(Mask & 1); bit++)
        {
            Mask >>= 1;
        }
        GreenShift = bit;

        Mask = BlueMask;
        for (bit = 0; Mask && !(Mask & 1); bit++)
        {
            Mask >>= 1;
        }
        BlueShift = bit;

        Mask = AlphaMask;
        for (bit = 0; Mask && !(Mask & 1); bit++)
        {
            Mask >>= 1;
        }
        AlphaShift = bit;

        // If this is a per-pixel blend, get the source alpha format.
        if (pParms->blendFunction.AlphaFormat)
        {
            DWORD SavedSrcAlphaMask;

            if (pParms->pSrc->FormatPtr()->m_PaletteEntries == 4)
            {
                SrcAlphaMask = pParms->pSrc->FormatPtr()->m_pPalette[3];
            }
            else if (pParms->pSrc->FormatPtr()->m_PaletteEntries == 3)
            {
                // If a fourth mask isn't provided, GDI guarantees that
                // 0xFF000000 is a valid alpha mask.
                SrcAlphaMask = 0xFF000000;
            }
            else
            {
                ASSERT(0);
            }

            SavedSrcAlphaMask = SrcAlphaMask;
            SrcAlphaShift = 0;

            while (!(SrcAlphaMask & 1))
            {
                SrcAlphaMask >>= 1;
                SrcAlphaShift++;
            }

            SrcAlphaMask = SavedSrcAlphaMask;
        }

        dstMatters = 1;
        alphaBlend = 1;
    }

    // Handle improperly ordered prclDst resulting from stretch Blt
    // Note that only prclDst is ever improperly ordered
    if( width < 0 || height < 0 )
    {
        tmpRclDst = *prclDst;
        prclDst = &tmpRclDst;
        if( width < 0 )
        {
            SWAP( tmpRclDst.left, tmpRclDst.right, LONG )
            width = -width;
            dstXPositive = !dstXPositive;
        }
        if( height < 0 )
        {
            SWAP( tmpRclDst.top, tmpRclDst.bottom, LONG )
            height = -height;
            dstYPositive = !dstYPositive;
        }
    }
    // prclDst is now properly ordered


    if( pParms->bltFlags & BLT_STRETCH )    // Check for stretching or shrinking vertically &/or horizontally
    {
        srcWidth = pParms->prclSrc->right - pParms->prclSrc->left;
        srcHeight = pParms->prclSrc->bottom - pParms->prclSrc->top;

        if( width > srcWidth )
        {
            xStretch = 1;
            xDMajor = width;
            xDMinor = srcWidth;
        }
        else if( width < srcWidth )
        {
            xShrink = 1;
            xDMajor = srcWidth;
            xDMinor = width;
        }

        if( xStretch || xShrink)
        {
            xShrinkStretch = 1;
            // Convert to Bresenham parameters
            xDMinor *= 2;
            xDMajor = xDMinor - 2 * xDMajor;
            rowXAccum = xShrink?(2*width - srcWidth):(3*srcWidth - 2*width);
                // loaded into xAccum at start of each row
        }

        if( height > srcHeight )
        {
            yStretch = 1;
            yDMajor = height;
            yDMinor = srcHeight;
        }
        else if( height < srcHeight )
        {
            yShrink = 1;
            yDMajor = srcHeight;
            yDMinor = height;
        }

        if( yStretch || yShrink)
        {
            yShrinkStretch = 1;
            // Convert to Bresenham parameters
            yDMinor *= 2;
            yDMajor = yDMinor - 2 * yDMajor;
            yAccum = yShrink?(2*height - srcHeight):(3*srcHeight - 2*height);
        }

        if( pParms->prclClip )    // ONLY happens if stretch blting
        {
            RECTL rclClipped = *prclDst;

            if( rclClipped.left < pParms->prclClip->left )
            {
                rclClipped.left = pParms->prclClip->left;
            }
            if( rclClipped.top < pParms->prclClip->top )
            {
                rclClipped.top = pParms->prclClip->top;
            }
            if( rclClipped.bottom > pParms->prclClip->bottom )
            {
                rclClipped.bottom = pParms->prclClip->bottom;
            }
            if( rclClipped.right > pParms->prclClip->right )
            {
                rclClipped.right = pParms->prclClip->right;
            }
            if( rclClipped.right <= rclClipped.left || rclClipped.bottom <= rclClipped.top )
            {
                return S_OK;    // the clipping left nothing to do
            }

            dstXStartSkip = dstXPositive?(rclClipped.left-prclDst->left):(prclDst->right-rclClipped.right);
            dstYStartSkip = dstYPositive?(rclClipped.top-prclDst->top):(prclDst->bottom-rclClipped.bottom);
            width = rclClipped.right - rclClipped.left;        // Calculate fully clipped destination width
            height = rclClipped.bottom - rclClipped.top;    // Fully clipped height
        }

        if( xShrink )
        {
            while( rowXAccum < 0 )
            {
                rowXAccum += xDMinor;
                srcXStartSkip++;
            }
            rowXAccum += xDMajor; 
        }
        for( int skipCount = dstXStartSkip; skipCount; skipCount-- )
        {
            if( xShrink )
            {
                while( rowXAccum < 0 )
                {
                    rowXAccum += xDMinor;
                    srcXStartSkip++;
                }
                srcXStartSkip++;    //  <--- this is the srcSkip inherent with a dstSkip
                rowXAccum += xDMajor; 
            }
            else if( xStretch )
            {
                if( rowXAccum < 0 )
                {
                    rowXAccum += xDMinor;
                }
                else
                {
                    rowXAccum += xDMajor;
                    srcXStartSkip++;
                }
            }
            else
            {
                srcXStartSkip++;
            }
        }
        if( yShrink )
        {
            yAccum += dstYStartSkip * yDMajor;
            srcYStartSkip += dstYStartSkip;    //  <--- this is the srcSkip inherent with a dstSkip
        }
        else if( yStretch )
        {
            for( int skipCount = dstYStartSkip; skipCount; skipCount-- )
            {
                if( yAccum < 0 )
                {
                    yAccum += yDMinor;
                }
                else
                {
                    yAccum += yDMajor;
                    srcYStartSkip++;
                }
            }
        }
        else
        {
            srcYStartSkip += dstYStartSkip;
        }
     }

    int transparentBlt = pParms->bltFlags & BLT_TRANSPARENT;
    unsigned long transparentColor = pParms->solidColor;

    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("pSrc=0x%08x, pDst=0x%08x, pBrush=%08x, pMask=%08x\r\n"),
        pParms->pSrc, pParms->pDst, pParms->pBrush, pParms->pMask ));

    PixelIterator src, dst, mask;
    BrushPixelIterator brush;
    src.Ptr = src.RowPtr = mask.Ptr = mask.RowPtr = brush.Ptr = brush.RowPtr = (unsigned char *)0;

    if( pParms->pSrc )
    {
        DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("pSrc depth: %d Bpp\r\n"), EGPEFormatToBpp[pParms->pSrc->Format()] ) );
        src.InitPixelIterator( pParms->pSrc, pParms->xPositive, pParms->yPositive, pParms->prclSrc,
            srcXStartSkip, srcYStartSkip );

        // If we're doing a transparent blt, we will need to know the real RGB
        // masks.
        if (transparentBlt)
        {
            GPEFormat * pFormat = pParms->pSrc->FormatPtr();

            // Make sure we're dealing with a known format.
            if (EGPEFormatToBpp[pParms->pSrc->Format()] > 8
                && (pFormat->m_PaletteEntries == 4
                    ||pFormat->m_PaletteEntries == 3))
            {
                ULONG * pMasks = pFormat->m_pPalette;

                SrcRGBMask = pMasks[0] | pMasks[1] | pMasks[2];
            }
            else
            {
                SrcRGBMask = src.Mask;
            }
        }
        else
        {
            SrcRGBMask = src.Mask;
        }
    }
    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("pDst depth: %d Bpp\r\n"), EGPEFormatToBpp[pParms->pDst->Format()] ) );

    if( pParms->pBrush )
    {
        // Calculate an rclBrush so that the correct starting pixel is chosen for the brush iterator
        DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("Pattern depth: %d Bpp\r\n"), EGPEFormatToBpp[pParms->pBrush->Format()] ) );
        int topIndent = (pParms->pptlBrush)?pParms->pBrush->Height()-pParms->pptlBrush->y:0;
        int leftIndent = (pParms->pptlBrush)?pParms->pBrush->Width()-pParms->pptlBrush->x:0;
        rclBrush.left = ( leftIndent + prclDst->left ) % pParms->pBrush->Width();
        rclBrush.right = ( leftIndent + prclDst->right ) % pParms->pBrush->Width();
        rclBrush.top = ( topIndent + prclDst->top ) % pParms->pBrush->Height();
        rclBrush.bottom = ( topIndent + prclDst->bottom ) % pParms->pBrush->Height();

        DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("pBrush depth: %d Bpp\r\n"), EGPEFormatToBpp[pParms->pBrush->Format()] ) );
        brush.InitBrushPixelIterator( pParms->pBrush, pParms->xPositive, pParms->yPositive, &rclBrush );
    }

    if( pParms->pMask )
    {
        mask.InitPixelIterator( pParms->pMask, pParms->xPositive, pParms->yPositive, pParms->prclMask,
            srcXStartSkip, srcYStartSkip );
    }
    else
    {
        mask.RowIncrement = 0;
    }

    if( ( dst.Bpp = EGPEFormatToBpp[pParms->pDst->Format()] ) >= 8 )
    {
        quickWrite = 1;

        if( !dstYPositive )
        {
            dst.RowIncrement = -pParms->pDst->Stride();
            dst.RowPtr = (unsigned char *)pParms->pDst->Buffer() + pParms->pDst->Stride() * ( prclDst->bottom - 1 - dstYStartSkip );
        }
        else
        {
            dst.RowIncrement = pParms->pDst->Stride();
            dst.RowPtr = (unsigned char *)pParms->pDst->Buffer() + pParms->pDst->Stride() * ( dstYStartSkip + prclDst->top );
        }

        if( !dstXPositive )
        {
            dst.BytesPerAccess = -dst.Bpp/8;
            dst.RowPtr -= dst.BytesPerAccess * ( prclDst->right - 1 - dstXStartSkip );
        }
        else
        {
            dst.BytesPerAccess = dst.Bpp/8;
            dst.RowPtr += dst.BytesPerAccess * ( dstXStartSkip + prclDst->left );
        }

        dst.Mask = ( 2 << (dst.Bpp - 1) ) - 1;
        dst.CacheState=0;    // so it is not marked as dirty
    }
    else
    {
        dst.InitPixelIterator( pParms->pDst, dstXPositive, dstYPositive, prclDst,
            dstXStartSkip, dstYStartSkip );
    }

    if( yShrinkStretch )
    {
        // Back up the source and mask row increments because they will be altered dynamically
        originalMaskRowInc = mask.RowIncrement;
        originalSrcRowInc = src.RowIncrement;
        DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("yStretch:%d yShrink:%d yDMinor:%d yDMajor:%d yAccum:%d\n"),
            yStretch, yShrink, yDMinor, yDMajor, yAccum ));
    }

    if( pParms->rop4 == 0x0000 )
    {
        src.Value = 0;
    }
    else if( pParms->rop4 == 0xffff )
    {
        src.Value = dst.Mask;
    }
    else
    {
        src.Value = pParms->solidColor & dst.Mask;
        if( ( maskedROP3 != unmaskedROP3 )
            || transparentBlt
            || alphaBlend
            || xShrinkStretch
            || ( rop3 != 0xCC && ( rop3 != 0xF0 || pParms->pBrush ) ) )
        {
            DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("Complex Blt!\r\n")));
            DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("transparent:%d,masked:%2x,unmasked:%2x,rop3:%2x,mask.RowPtr:%08x\r\n"),
                transparentBlt,maskedROP3, unmaskedROP3, rop3, mask.RowPtr ));
            complexBlt = 1;
        }
    }
    brush.Value = src.Value;

    while( height-- )
    {
        // Handle y Shrinking or stretching
        if( yShrinkStretch )
        {
            if( yShrink )
            {
                while( yAccum < 0 )    // skip source line(s) if shrinking
                {
                    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("yShrink - skip line\r\n")));
                    src.RowPtr  += src.RowIncrement;
                    mask.RowPtr += mask.RowIncrement;
                    yAccum      += yDMinor;
                }
                yAccum += yDMajor;
            }
            else
            {
                if( yAccum < 0 )
                {
                    ASSERT(yStretch);

                    // repeat source line if stretching
                    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("yStretch - Repeat. Accum=%d\r\n"), yAccum));
                    yAccum            += yDMinor;    // yDMinor is a small +ve number
                    src.RowIncrement   = 0;
                    mask.RowIncrement  = 0;
                }
                else
                {
                    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("yStretch - Switch to next after this Accum=%d\r\n"), yAccum));
                    // Switch to next source line  (after this row)
                    yAccum            += yDMajor;              // yDMajor is a large -ve value (i.e. |yDMajor| > |yDMinor| )
                    src.RowIncrement   = originalSrcRowInc;
                    mask.RowIncrement  = originalMaskRowInc;
                }
            }
        }

        // Move all iterators to next line
        if( src.RowPtr )
        {
            src.Ptr = src.RowPtr;
            src.RowPtr += src.RowIncrement;

            if( ! src.Is24Bit )
            {
                src.Cache = *(unsigned long *)src.Ptr;
                src.CacheState = src.CacheStateNewRow;
            }
        }

        if( mask.RowPtr )
        {
            mask.Ptr = mask.RowPtr;
            mask.RowPtr += mask.RowIncrement;
            mask.Cache = *(UNALIGNED unsigned long *)mask.Ptr;
            mask.CacheState = mask.CacheStateNewRow;
        }

        if( brush.RowPtr )
        {
            brush.Ptr = brush.RowPtr;
            brush.LeftRowPtr = brush.Ptr - brush.LeftPixelOffset;

            if( --brush.RowsRemaining )
            {
                brush.RowPtr += brush.RowIncrement;
            }
            else
            {
                brush.RowPtr = brush.FirstRowPtr;
                brush.RowsRemaining = brush.Rows;
            }

            brush.Cache = *(unsigned long *)brush.Ptr;
            brush.CacheState = brush.CacheStateNewRow;
            brush.PixelsRemaining = brush.RowInitialPixelsRemaining;
        }

        dst.Ptr = dst.RowPtr;
        dst.RowPtr += dst.RowIncrement;

        if( !quickWrite )
        {
            dst.Cache = *(unsigned long *)dst.Ptr;
            dst.CacheState = dst.CacheStateNewRow;
        }

        if( xStretch )
        {
            prevMaskPtr = mask.Ptr;
            prevMaskCache = mask.Cache;
            prevMaskCacheState = mask.CacheState;
            prevSrcPtr = src.Ptr;
            prevSrcCache = src.Cache;
            prevSrcCacheState = src.CacheState;
        }

        xAccum = rowXAccum;

        for( x=0; x<width; x++ )
        {
            if( src.Ptr )
            {
                // Read the next pixel in and convert to same depth as destination

                if( src.Is24Bit )    // Since 24-bit packed pixels cross dword boundaries:
                {
                    src.Value = ( *src.Ptr ) + ( *(src.Ptr+1) << 8 ) +    ( *(src.Ptr+2) << 16 );
                    src.Ptr += src.BytesPerAccess;
                }
                else
                {
                    if( !(src.CacheState&0x00ff00) )    // Check bits remaining in src.Cache
                    {
                        src.Ptr += src.BytesPerAccess;            // increment src.Ptr
                        src.CacheState = src.CacheStateNewDWord;
                        src.Cache = *(unsigned long *)src.Ptr;    // reload src.Cache
                    }
                    src.Value = src.Cache >> ( (src.CacheState >> 16) ^ src.MaskShiftXor );
                    src.CacheState += src.CacheStateIncrement;         
                }

                // Save the original source for transparency.
                originalSrc = ( src.Value &= src.Mask );
                originalSrc &= SrcRGBMask;

                if( pParms->pLookup )
                {
                    src.Value = (pParms->pLookup)[src.Value];
                }

                if( pParms->pConvert )
                {
                    src.Value = (pParms->pColorConverter->*(pParms->pConvert))( src.Value );
                }    
            }
            
            if( complexBlt )    // brushed, masked, transparent, unusual rop3 etc
            {
                if( brush.Ptr )
                {
                    // Note that the brush will already have been converted to the same
                    // depth as the destination (if they weren't the same).
                    // The exception is if the dest is 24Bpp. In this case, the brush
                    // will have been converted to 32Bpp for simplicity.
                    // See DrvRealizeBrush for details

                    if( !(brush.PixelsRemaining--) )    // Check for wrapping off right edge of pattern
                    {
                        brush.Ptr = brush.LeftRowPtr;
                        brush.PixelsRemaining = brush.PixelsPerRow-1;
                        brush.CacheState = brush.CacheStateNewDWord;
                        brush.Cache = *(unsigned long *)brush.Ptr;    // reload brush.Cache
                    }
                    else if( !(brush.CacheState&0x00ff00) )    // Check bits remaining in brush.Cache
                    {
                        brush.Ptr += brush.BytesPerAccess;                // increment brush.Ptr
                        brush.CacheState = brush.CacheStateNewDWord;
                        brush.Cache = *(unsigned long *)brush.Ptr;    // reload brush.Cache
                    }

                    brush.Value = brush.Cache >> ( (brush.CacheState >> 16) ^ brush.MaskShiftXor );
                    brush.CacheState += brush.CacheStateIncrement;         
                }
                if( mask.Ptr ) // This selects between two rop3's
                {
                    if( !(mask.CacheState&0x00ff00) )    // check bits remaining in mask cache
                    {
                        mask.Ptr += mask.BytesPerAccess;    //  == +/- 4
                        mask.CacheState = mask.CacheStateNewDWord;
                        mask.Cache = *(UNALIGNED unsigned long *)mask.Ptr;
                    }
    
                    rop3 = ( mask.Cache & ( 1 << ( (mask.CacheState >> 16) ^ mask.MaskShiftXor ) ) ) ? unmaskedROP3 : maskedROP3;
                    mask.CacheState += mask.CacheStateIncrement;
                }

                if( xShrinkStretch )
                {
                    // Handle x Stretching
                    if( xStretch )
                    {
                        if( xAccum < 0 )    // Repeat this pixel
                        {
                            xAccum += xDMinor;
                            mask.Ptr = prevMaskPtr;
                            mask.Cache = prevMaskCache;
                            mask.CacheState = prevMaskCacheState;
                            src.Ptr = prevSrcPtr;
                            src.Cache = prevSrcCache;
                            src.CacheState = prevSrcCacheState;
                        }
                        else                // OK to move to next source pixel after this
                        {
                            xAccum += xDMajor;
                            prevMaskPtr = mask.Ptr;
                            prevMaskCache = mask.Cache;
                            prevMaskCacheState = mask.CacheState;
                            prevSrcPtr = src.Ptr;
                            prevSrcCache = src.Cache;
                            prevSrcCacheState = src.CacheState;
                        }
                    }
                    else    // xShrink
                    {
                        while( xAccum < 0 )        // Skip pixel(s)
                        {
                            // Move to next src pixel
                            if( src.Is24Bit )    // Since 24-bit packed pixels cross dword boundaries:
                            {
                                src.Ptr += src.BytesPerAccess;
                            }
                            else
                            {
                                if( !(src.CacheState&0x00ff00) )    // Check bits remaining in src.Cache
                                {
                                    src.Ptr += src.BytesPerAccess;            // increment src.Ptr
                                    src.CacheState = src.CacheStateNewDWord;
                                    if (x != width - 1 )
                                        src.Cache = *(unsigned long *)src.Ptr;    // reload src.Cache
                                }
                                src.CacheState += src.CacheStateIncrement;         
                            }

                            // Move to next mask pixel
                            if( pParms->pMask )
                            {
                                if( !(mask.CacheState&0x00ff00) )    // check bits remaining in mask cache
                                {
                                    mask.Ptr += mask.BytesPerAccess;        //  == +/- 4
                                    mask.CacheState = mask.CacheStateNewDWord;
                                    mask.Cache = *(UNALIGNED unsigned long *)mask.Ptr;
                                }

                                mask.CacheState += mask.CacheStateIncrement;
                            }

                            xAccum += xDMinor;
                        }

                        xAccum += xDMajor;
                    }
                }

                if( dstMatters )        // The underlying rop4 utilizes the dst.
                {
                    // We maintain dst.Cache valid at all times if not doing quickWrite
                    if( quickWrite )
                    {
                        switch(dst.Bpp)
                        {
                        case 8:
                                *(unsigned char *)&dst.Value = *(unsigned char *)dst.Ptr;
                                break;
                        case 16:
                                *(unsigned short *)&dst.Value = *(unsigned short *)dst.Ptr;
                                break;
                        case 32:
                                *(unsigned long *)&dst.Value = *(unsigned long *)dst.Ptr;
                                break;
                        case 24:
                                dst.Value = ( *dst.Ptr ) + ( *(dst.Ptr+1) << 8 ) + ( *(dst.Ptr+2) << 16 );
                        }
                    }
                    else
                        dst.Value = dst.Cache >> ( ( dst.CacheState >> 16 ) ^ dst.MaskShiftXor );
                }

                switch( rop3 )
                {
                    // The compiler sorts these and creates a binary search set of tests to
                    // get to an entry quickly.  Branch "prediction" helps this a lot.
                    // Remember that masked rop4s makes NOP and SRCCOPY quite a likely rop3
                    case 0xAA: break;                                             // NOP
                    case 0xCC: break;                                            // SRCCOPY
                    case 0x00: src.Value = 0;                            break; // BLACKNESS
                    case 0x22: src.Value = (~src.Value) & dst.Value;    break; // no-name
                    case 0xB8: src.Value = (brush.Value & ~src.Value)|(src.Value & dst.Value);    break; // no-name
                    case 0x11: src.Value = ~(src.Value | dst.Value);    break; // NOTSRCERASE
                    case 0x33: src.Value = ~src.Value;                    break; // NOTSRCCOPY
                    case 0x44: src.Value &= ~dst.Value;                    break; // SRCERASE
                    case 0x55: src.Value = ~dst.Value;                    break; // DSTINVERT
                    case 0x5A: src.Value = brush.Value ^ dst.Value;        break; // PATINVERT
                    case 0x66: src.Value ^= dst.Value;                    break; // SRCINVERT
                    case 0x88: src.Value &= dst.Value;                    break; // SRCAND
                    case 0xBB: src.Value = ~src.Value | dst.Value;        break; // MERGEPAINT
                    case 0xC0: src.Value &= brush.Value;                break; // MERGECOPY
                    case 0xEE: src.Value |= dst.Value;                    break; // SRCPAINT
                    case 0xF0: src.Value = brush.Value;                    break; // PATCOPY
                    case 0xFB: src.Value = brush.Value | ~src.Value | dst.Value; break; // PATPAINT
                    case 0xFF: src.Value = 0xFFFFFFFF;                    break; // WHITENESS
                    case 0xE2: src.Value = ( dst.Value & ~src.Value ) | ( brush.Value & src.Value ); break;
                    case 0xAC: src.Value = ((src.Value^dst.Value)&brush.Value)^src.Value; break;
                    default:   src.Value = ProcessROP3(dst.Value,src.Value,brush.Value,rop3,dst.Bpp);
                }

                // Perform the AlphaBlend
                if (alphaBlend)
                {
                    ULONG SrcRed;
                    ULONG SrcGreen;
                    ULONG SrcBlue;
                    ULONG SrcAlpha;
                    ULONG DstRed;
                    ULONG DstGreen;
                    ULONG DstBlue;
                    ULONG DstAlpha;

                    BYTE  Alpha = pParms->blendFunction.SourceConstantAlpha;

                    ULONG   PalEntries = 0;
                    ULONG * pPalette   = NULL;
                    int     AlphaType  = 0;

                    // If the surface has a palette, get the BGR value of the
                    // color.
                    if (BlendPalette)
                    {
                        pPalette   = pParms->pDst->FormatPtr()->m_pPalette;
                        PalEntries = pParms->pDst->FormatPtr()->m_PaletteEntries;

                        // The mask isn't always applied to the destination value.
                        dst.Value &= dst.Mask;

                        ASSERT(src.Value < PalEntries);
                        ASSERT(dst.Value < PalEntries);

                        src.Value = pPalette[src.Value];
                        dst.Value = pPalette[dst.Value];
                    }

                    SrcRed   = (src.Value & RedMask  ) >> RedShift;
                    SrcGreen = (src.Value & GreenMask) >> GreenShift;
                    SrcBlue  = (src.Value & BlueMask ) >> BlueShift;
                    SrcAlpha = (src.Value & AlphaMask) >> AlphaShift;

                    DstRed   = (dst.Value & RedMask  ) >> RedShift;
                    DstGreen = (dst.Value & GreenMask) >> GreenShift;
                    DstBlue  = (dst.Value & BlueMask ) >> BlueShift;
                    DstAlpha = (dst.Value & AlphaMask) >> AlphaShift;

                    if (pParms->blendFunction.AlphaFormat)
                    {
                        SrcAlpha = originalSrc & SrcAlphaMask;
                        SrcAlpha >>= SrcAlphaShift;

                        if (SrcAlpha == 0)
                        {
                            // Just the dst.
                            src.Value = (DstRed   << 16) |
                                        (DstGreen <<  8) |
                                        (DstBlue       ) |
                                        (DstAlpha << 24);
                        }
                        else if (SrcAlpha == 255 && Alpha == 255)
                        {
                            // Just the src.
                            src.Value = (SrcRed   << 16) |
                                        (SrcGreen <<  8) |
                                        (SrcBlue       ) |
                                        (SrcAlpha << 24);
                        }
                        else if (SrcAlpha == 255)
                        {
                            // Source constant alpha only.
                            AlphaType = 1;
                        }
                        else
                        {
                            if (Alpha == 255)
                            {
                                AlphaType = 2; // Per-pixel only
                            }
                            else
                            {
                                AlphaType = 3; // Both;
                            }
                        }
                    }
                    else
                    {
                        AlphaType = 1;
                    }

                    if (AlphaType == 3)
                    {
                        // Both Per-Pixel and Constant Alpha

                        ULONG uB00aa00gg = (SrcAlpha << 16) | SrcGreen;
                        ULONG uB00rr00bb = (SrcRed   << 16) | SrcBlue;

                        ULONG uTaaaagggg = uB00aa00gg * Alpha + 0x00800080;
                        ULONG uTrrrrbbbb = uB00rr00bb * Alpha + 0x00800080;

                        ULONG uT00aa00gg = (uTaaaagggg & 0xff00ff00) >> 8;
                        ULONG uT00rr00bb = (uTrrrrbbbb & 0xff00ff00) >> 8;

                        ULONG uCaa00gg00 = ((uTaaaagggg + uT00aa00gg) & 0xff00ff00);
                        ULONG uC00rr00bb = ((uTrrrrbbbb + uT00rr00bb) & 0xff00ff00) >> 8;

                        src.Value = uCaa00gg00 | uC00rr00bb;

                        BYTE beta = 255 - (BYTE)((src.Value & 0xff000000) >> 24);

                        ULONG _D1_00aa00gg = (DstAlpha << 16) | DstGreen;
                        ULONG _D1_00rr00bb = (DstRed   << 16) | DstBlue;

                        ULONG _D2_aaaagggg = _D1_00aa00gg * beta + 0x00800080;
                        ULONG _D2_rrrrbbbb = _D1_00rr00bb * beta + 0x00800080;

                        ULONG _D3_00aa00gg = (_D2_aaaagggg & 0xff00ff00) >> 8;
                        ULONG _D3_00rr00bb = (_D2_rrrrbbbb & 0xff00ff00) >> 8;

                        ULONG _D4_00aa00gg = ((_D2_aaaagggg + _D3_00aa00gg) & 0xff00ff00) >> 8;
                        ULONG _D4_00rr00bb = ((_D2_rrrrbbbb + _D3_00rr00bb) & 0xff00ff00) >> 8;

                        ULONG _D5_00aa00gg = _D4_00aa00gg + ((src.Value & 0xff00ff00) >> 8);
                        ULONG _D5_00rr00bb = _D4_00rr00bb + (src.Value & 0x00ff00ff);

                        // Saturate the ARGB values.
                        ULONG TempMask = (AlphaMask >> AlphaShift) << 16;
                        if ((_D5_00aa00gg & 0xffff0000) > TempMask)
                        {
                            _D5_00aa00gg = TempMask | (_D5_00aa00gg & 0x0000ffff);
                        }

                        TempMask = GreenMask >> GreenShift;
                        if ((_D5_00aa00gg & 0x0000ffff) > TempMask)
                        {
                            _D5_00aa00gg = TempMask | (_D5_00aa00gg & 0x00ff0000);
                        }

                        TempMask = (RedMask >> RedShift) << 16;
                        if ((_D5_00rr00bb & 0xffff0000) > TempMask)
                        {
                            _D5_00rr00bb = TempMask | (_D5_00rr00bb & 0x0000ffff);
                        }

                        TempMask = BlueMask >> BlueShift;
                        if ((_D5_00rr00bb & 0x0000ffff) > TempMask)
                        {
                            _D5_00rr00bb = TempMask | (_D5_00rr00bb & 0x00ff0000);
                        }

                        src.Value = (_D5_00aa00gg << 8) | _D5_00rr00bb;
                    }
                    else if (AlphaType == 2)
                    {
                        // Per-Pixel Only

                        ULONG Multa = 255 - SrcAlpha;

                        ULONG _D1_00aa00gg = (DstAlpha << 16) | DstGreen;
                        ULONG _D1_00rr00bb = (DstRed   << 16) | DstBlue;

                        ULONG _D2_aaaagggg = _D1_00aa00gg * Multa + 0x00800080;
                        ULONG _D2_rrrrbbbb = _D1_00rr00bb * Multa + 0x00800080;

                        ULONG _D3_00aa00gg = (_D2_aaaagggg & 0xff00ff00) >> 8;
                        ULONG _D3_00rr00bb = (_D2_rrrrbbbb & 0xff00ff00) >> 8;

                        ULONG _D4_00aa00gg = ((_D2_aaaagggg + _D3_00aa00gg) & 0xff00ff00) >> 8;
                        ULONG _D4_00rr00bb = ((_D2_rrrrbbbb + _D3_00rr00bb) & 0xff00ff00) >> 8;

                        ULONG _D5_00aa00gg = _D4_00aa00gg + ((SrcAlpha << 16) | SrcGreen);
                        ULONG _D5_00rr00bb = _D4_00rr00bb + ((SrcRed   << 16) | SrcBlue);

                        // Saturate the ARGB values.
                        ULONG TempMask = (AlphaMask >> AlphaShift) << 16;
                        if ((_D5_00aa00gg & 0xffff0000) > TempMask)
                        {
                            _D5_00aa00gg = TempMask | (_D5_00aa00gg & 0x0000ffff);
                        }

                        TempMask = GreenMask >> GreenShift;
                        if ((_D5_00aa00gg & 0x0000ffff) > TempMask)
                        {
                            _D5_00aa00gg = TempMask | (_D5_00aa00gg & 0x00ff0000);
                        }

                        TempMask = (RedMask >> RedShift) << 16;
                        if ((_D5_00rr00bb & 0xffff0000) > TempMask)
                        {
                            _D5_00rr00bb = TempMask | (_D5_00rr00bb & 0x0000ffff);
                        }

                        TempMask = BlueMask >> BlueShift;
                        if ((_D5_00rr00bb & 0x0000ffff) > TempMask)
                        {
                            _D5_00rr00bb = TempMask | (_D5_00rr00bb & 0x00ff0000);
                        }

                        src.Value = (_D5_00aa00gg << 8) | _D5_00rr00bb;
                    }
                    else if (AlphaType == 1)
                    {
                        // Constant Alpha Only

                        // red and blue
                        ULONG uB00rr00bb = (DstRed << 16) | DstBlue;
                        ULONG uF00rr00bb = (SrcRed << 16) | SrcBlue;
                        ULONG uMrrrrbbbb = ((uB00rr00bb << 8) - uB00rr00bb)
                                           + (Alpha * (uF00rr00bb - uB00rr00bb)) + 0x00800080;
                        ULONG uM00rr00bb = (uMrrrrbbbb & 0xff00ff00) >> 8;
                        ULONG uD00rr00bb = ((uMrrrrbbbb + uM00rr00bb) & 0xff00ff00) >> 8;

                        // alpha and green
                        ULONG uB00aa00gg = (DstAlpha << 16) | DstGreen;
                        ULONG uF00aa00gg = (SrcAlpha << 16) | SrcGreen;
                        ULONG uMaaaagggg = ((uB00aa00gg << 8) - uB00aa00gg)
                                           + (Alpha * (uF00aa00gg - uB00aa00gg)) + 0x00800080;
                        ULONG uM00aa00gg = (uMaaaagggg & 0xff00ff00) >> 8;
                        ULONG uDaa00gg00 = (uMaaaagggg + uM00aa00gg) & 0xff00ff00;

                        src.Value = uD00rr00bb + uDaa00gg00;
                    }

                    // Convert src.Value back to the appropriate format;
                    SrcBlue  =  (src.Value & 0x000000ff)        << BlueShift;
                    SrcGreen = ((src.Value & 0x0000ff00) >> 8)  << GreenShift;
                    SrcRed   = ((src.Value & 0x00ff0000) >> 16) << RedShift;
                    SrcAlpha = ((src.Value & 0xff000000) >> 24) << AlphaShift;

                    src.Value = ((SrcRed & RedMask)
                                 | (SrcGreen & GreenMask)
                                 | (SrcBlue  & BlueMask)
                                 | (SrcAlpha & AlphaMask));

                    // If the destination surface has a palette, src.Value must
                    // be converted to a palette index.
                    if (BlendPalette)
                    {
                        ULONG Error = RGBError(src.Value, pPalette[0]);
                        ULONG Index = 0; 

                        for (ULONG i = 1; i < PalEntries; i++)
                        {
                            ULONG TempErr = RGBError(src.Value, pPalette[i]);
                            if (TempErr < Error)
                            {
                                Error = TempErr;
                                Index = i;
                            }
                        }

                        src.Value = Index;
                    }
                }

                src.Value &= dst.Mask;

                if( rop3 == 0xAA || ( transparentBlt && ( originalSrc == transparentColor ) ) )
                {
                    // we won't write this pixel
                    if( quickWrite )
                        dst.Ptr += dst.BytesPerAccess;
                    else
                    {
                        dst.CacheState += dst.CacheStateIncrement; // leave dirty flag as-is
                        if( !(dst.CacheState&0x00ff00) ) // Check bits remaining in dst cache
                        {
                            if( dst.CacheState & 0x0000ff )
                                *(unsigned long *)dst.Ptr = dst.Cache;    // flush cache
                            dst.CacheState = dst.CacheStateNewDWord;        // clears dirty flag
                            dst.Ptr += dst.BytesPerAccess;                    // +/- 4
                            dst.Cache = *(unsigned long *)dst.Ptr;
                        }
                    }
                    continue;
                }
            }

            // Now, we are ready to write the value from src.Value into the dst pixel
            if( quickWrite )
            {
                switch(dst.Bpp)
                {
                case 8:
                        *(unsigned char *)dst.Ptr = (unsigned char)src.Value;
                        break;
                case 16:
                        *(unsigned short *)dst.Ptr = (unsigned short)src.Value;
                        break;
                case 32:
                        *(unsigned long *)dst.Ptr = (unsigned long)src.Value;
                        break;
                case 24:
                        *dst.Ptr = (unsigned char)(src.Value);
                        *(dst.Ptr+1) = (unsigned char)(src.Value>>8);
                        *(dst.Ptr+2) = (unsigned char)(src.Value>>16);
                }

                dst.Ptr += dst.BytesPerAccess;
            }
            else
            {
                unsigned char tmpShift = (unsigned char)(( dst.CacheState >> 16 ) ^ dst.MaskShiftXor);
                dst.Cache &= ~( dst.Mask << tmpShift);
                dst.Cache |= src.Value << tmpShift;
                dst.CacheState += dst.CacheStateIncrementDirty;  // sets dirty flag

                if( !(dst.CacheState&0x00ff00) ) // Check bits remaining in dst cache
                {
                    *(unsigned long *)dst.Ptr = dst.Cache;    // flush cache (we know it was dirty)
                    dst.CacheState = dst.CacheStateNewDWord;    // clears dirty flag
                    dst.Ptr += dst.BytesPerAccess;                // +/- 4
                    if (x != width - 1 )
                        dst.Cache = *(unsigned long *)dst.Ptr;
                }
            }

        } // next column

        if( dst.CacheState & 0x0000ff )
        {
            *(unsigned long *)dst.Ptr = dst.Cache;    // flush cache
        }
    } // next row

    return S_OK;
}

unsigned long
ProcessROP3(
    unsigned long dstValue,
    unsigned long srcValue,
    unsigned long brushValue,
    unsigned char rop3,
    unsigned char dstBitsPerPixel
    )
{
    if( dstBitsPerPixel > 24 )
    {
        // Break into two halves, otherwise the brushValue<<=2 below will overflow
        return ProcessROP3(dstValue,srcValue,brushValue,rop3,16) |
            ( ProcessROP3(dstValue>>16,srcValue>>16,brushValue>>16,rop3,dstBitsPerPixel-16) << 16);
    }

    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("Process rop3=%02x, numbits=%d, pattern=%04x, source=%04x, dest=%04x, "),
        rop3,dstBitsPerPixel,brushValue,srcValue,dstValue ));


    unsigned long result = 0;
    unsigned long rsltBit = 1;

    brushValue <<= 2;
    srcValue <<= 1;

    while( dstBitsPerPixel-- )
    {
        if( ( 1<< ( brushValue&4 | srcValue&2 | dstValue&1 ) ) & rop3 )
            result |= rsltBit;
        brushValue >>= 1;
        srcValue >>= 1;
        dstValue >>= 1;
        rsltBit <<=1;
    }
    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("resuult=%04x\r\n"), result));

    return result;
}

#define FIX16_ONE   0x00010000
#define FIX16_MASK  0x0000FFFF
#define FIX16_SHIFT         16

SCODE
GPE::EmulatedBlt_Bilinear(
    GPEBltParms *pParms
    )
{
    int width  = pParms->prclDst->right - pParms->prclDst->left;
    int height = pParms->prclDst->bottom - pParms->prclDst->top;

    int dstMatters   = ((( pParms->rop4 >> 1 ) ^ pParms->rop4 ) & 0x5555) != 0;

    int srcWidth  = pParms->prclSrc->right - pParms->prclSrc->left;
    int srcHeight = pParms->prclSrc->bottom - pParms->prclSrc->top;

    int dstXStartSkip = 0;
    int dstYStartSkip = 0;
    int srcXStartSkip = 0;
    int srcYStartSkip = 0;

    unsigned int xratio = srcWidth * FIX16_ONE / width;
    unsigned int yratio = srcHeight * FIX16_ONE / height;

    unsigned int xstep = (xratio - FIX16_ONE) >> 1;
    unsigned int ystep = (yratio - FIX16_ONE) >> 1;

    unsigned char rop3 = (unsigned char)pParms->rop4;

    ystep &= FIX16_MASK;
    xstep &= FIX16_MASK;

    if (pParms->prclClip)
    {
        RECTL rclClipped = *pParms->prclDst;

        if (rclClipped.left < pParms->prclClip->left)
        {
            rclClipped.left = pParms->prclClip->left;
        }

        if (rclClipped.top < pParms->prclClip->top)
        {
            rclClipped.top = pParms->prclClip->top;
        }

        if (rclClipped.bottom > pParms->prclClip->bottom)
        {
            rclClipped.bottom = pParms->prclClip->bottom;
        }

        if (rclClipped.right > pParms->prclClip->right)
        {
            rclClipped.right = pParms->prclClip->right;
        }

        // The clipped rect is empty.
        if (rclClipped.right <= rclClipped.left
            || rclClipped.bottom <= rclClipped.top)
        {
            return S_OK;
        }

        dstXStartSkip = pParms->xPositive ? (rclClipped.left - pParms->prclDst->left) : (pParms->prclDst->right - rclClipped.right);
        dstYStartSkip = pParms->yPositive ? (rclClipped.top - pParms->prclDst->top) : (pParms->prclDst->bottom - rclClipped.bottom);

        width  = rclClipped.right - rclClipped.left;
        height = rclClipped.bottom - rclClipped.top;
    }

    int skipCount;

    for (skipCount = dstXStartSkip; skipCount; skipCount--)
    {
        xstep         += xratio;
        srcXStartSkip += (xstep >> FIX16_SHIFT);
        xstep         &= FIX16_MASK;
    }

    for (skipCount = dstYStartSkip; skipCount; skipCount--)
    {
        ystep         += yratio;
        srcYStartSkip += (ystep >> FIX16_SHIFT);
        ystep         &= FIX16_MASK;
    }

    // The destination must be at least 16 bpp.
    PixelIterator dst;

    dst.Bpp = EGPEFormatToBpp[pParms->pDst->Format()];

    if (pParms->yPositive)
    {
        dst.RowIncrement = pParms->pDst->Stride();
        dst.RowPtr       = (unsigned char*)pParms->pDst->Buffer() + pParms->pDst->Stride() * (pParms->prclDst->top + dstYStartSkip);
    }
    else
    {
        dst.RowIncrement = -pParms->pDst->Stride();
        dst.RowPtr       = (unsigned char*)pParms->pDst->Buffer() + pParms->pDst->Stride() * (pParms->prclDst->bottom - 1 - dstYStartSkip);
    }

    if (pParms->xPositive)
    {
        dst.BytesPerAccess  = dst.Bpp/8;
        dst.RowPtr         += dst.BytesPerAccess * (pParms->prclDst->left + dstXStartSkip);
    }
    else
    {
        dst.BytesPerAccess  = -dst.Bpp/8;
        dst.RowPtr         -= dst.BytesPerAccess * (pParms->prclDst->right - 1 - dstXStartSkip);
    }
    dst.Mask       = (2 << (dst.Bpp - 1)) - 1;
    dst.CacheState = 0;  // so it is not marked as dirty

    // Initialize the first source iterator (src0)
    PixelIterator src0;

    src0.InitPixelIterator(pParms->pSrc, pParms->xPositive, pParms->yPositive, pParms->prclSrc,
                           srcXStartSkip, srcYStartSkip-1);

    // Initialize the second source iterator (src1)
    PixelIterator src1;

    src1.InitPixelIterator(pParms->pSrc, pParms->xPositive, pParms->yPositive, pParms->prclSrc,
                           srcXStartSkip, srcYStartSkip);

    // Compensate for srcXStartSkip and srcYStartSkip.
    srcHeight -= srcYStartSkip;
    srcWidth  -= srcXStartSkip;

    // Force a read of the first row.
    int ystepOverflow = 1;

    for (int y = 0, SrcYPixels = 0; y < height; y++)
    {
        bool IsSrc0Valid;
        bool IsSrc1Valid;

        // Initialize the dst row pointer to the next line.
        dst.Ptr     = dst.RowPtr;
        dst.RowPtr += dst.RowIncrement;

        // Initialize u0 and u1
        int u1 = ystep >> 8;
        int u0 = 256 - u1;

        // Check to see if we need to advance to the next row, or go back to
        // the beginning of the current source row.
        if (!ystepOverflow)
        {
            SrcYPixels--;
            src0.RowPtr -= src0.RowIncrement;
            src1.RowPtr -= src0.RowIncrement;
        }

        // Initialize the source row pointers to the next line.
        src0.Ptr     = src0.RowPtr;
        src0.RowPtr += src0.RowIncrement;
        src1.Ptr     = src1.RowPtr;
        src1.RowPtr += src1.RowIncrement;

        if (SrcYPixels == 0)
        {
            IsSrc0Valid = false;
        }
        else
        {
            IsSrc0Valid = true;
        }

        if (SrcYPixels < srcHeight)
        {
            IsSrc1Valid = true;
        }
        else
        {
            IsSrc1Valid = false;
        }

        SrcYPixels++;

        if (!src0.Is24Bit && IsSrc0Valid)
        {
            src0.Cache      = *(unsigned long *)src0.Ptr;
            src0.CacheState = src0.CacheStateNewRow;
        }

        if (!src1.Is24Bit && IsSrc1Valid)
        {
            src1.Cache      = *(unsigned long *)src1.Ptr;
            src1.CacheState = src1.CacheStateNewRow;
        }

        for (int x = 0, SrcXPixels = 0; x < width;)
        {
            // Save the old values of src0 and src1.
            unsigned long OldSrc0Value = src0.Value;
            unsigned long OldSrc1Value = src1.Value;

            // Only increment the src0 and src1 pointers if we haven't hit the
            // end of a row.
            if (SrcXPixels < srcWidth)
            {
                SrcXPixels++;

                // Get the next src0 pixel.
                if (IsSrc0Valid)
                {
                    if (src0.Is24Bit)
                    {
                        src0.Value  = (*src0.Ptr) + (*(src0.Ptr+1) << 8) + (*(src0.Ptr+2) << 16);
                        src0.Ptr   += src0.BytesPerAccess;
                    }
                    else
                    {
                        if (!(src0.CacheState & 0x00FF00))
                        {
                            src0.Ptr        += src0.BytesPerAccess;
                            src0.CacheState  = src0.CacheStateNewDWord;
                            src0.Cache       = *(unsigned long *)src0.Ptr;
                        }

                        src0.Value       = src0.Cache >> ((src0.CacheState >> 16) ^ src0.MaskShiftXor);
                        src0.CacheState += src0.CacheStateIncrement;
                    }

                    src0.Value &= src0.Mask;

                    if (pParms->pLookup)
                    {
                        src0.Value = (pParms->pLookup)[src0.Value];
                    }

                    if (pParms->pConvert)
                    {
                        src0.Value = (pParms->pColorConverter->*(pParms->pConvert))(src0.Value);
                    }
                }

                // Get the next src1 pixel (if needed).
                if (IsSrc1Valid)
                {
                    if (src1.Is24Bit)
                    {
                        src1.Value  = (*src1.Ptr) + (*(src1.Ptr+1) << 8) + (*(src1.Ptr+2) << 16);
                        src1.Ptr   += src1.BytesPerAccess;
                    }
                    else
                    {
                        if (!(src1.CacheState & 0x00FF00))
                        {
                            src1.Ptr        += src1.BytesPerAccess;
                            src1.CacheState  = src1.CacheStateNewDWord;
                            src1.Cache       = *(unsigned long *)src1.Ptr;
                        }

                        src1.Value       = src1.Cache >> ((src1.CacheState >> 16) ^ src1.MaskShiftXor);
                        src1.CacheState += src1.CacheStateIncrement;
                    }

                    src1.Value &= src1.Mask;

                    if (pParms->pLookup)
                    {
                        src1.Value = (pParms->pLookup)[src1.Value];
                    }

                    if (pParms->pConvert)
                    {
                        src1.Value = (pParms->pColorConverter->*(pParms->pConvert))(src1.Value);
                    }
                }
                else
                {
                    src1.Value = src0.Value;
                }

                if (!IsSrc0Valid)
                {
                    src0.Value = src1.Value;
                }
            }

            // If this is the first pixel read set the old values to this pixel
            if (SrcXPixels == 1)
            {
                OldSrc0Value = src0.Value;
                OldSrc1Value = src1.Value;
            }

            // Combine the pixels according to this algorithm:
            //   s0       = OldSrc0Value * u0 + OldSrc1Value * u1;
            //   s1       =   src0.Value * u0 +   src1.Value * u1;
            //   SrcValue =           s0 * v0 +           s1 * v1;

            unsigned long s0;
            unsigned long s1;

            if (OldSrc0Value == OldSrc1Value)
            {
                s0 = OldSrc0Value;
            }
            else
            {
                unsigned long A00aa00gg;
                unsigned long A00rr00bb;

                A00aa00gg  = ((OldSrc0Value & g_BilinearMasks[3]) >> g_BilinearShifts[3]) << 16;
                A00aa00gg |=  (OldSrc0Value & g_BilinearMasks[1]) >> g_BilinearShifts[1];
                A00rr00bb  = ((OldSrc0Value & g_BilinearMasks[0]) >> g_BilinearShifts[0]) << 16;
                A00rr00bb |=  (OldSrc0Value & g_BilinearMasks[2]) >> g_BilinearShifts[2];

                unsigned long B00aa00gg;
                unsigned long B00rr00bb;

                B00aa00gg  = ((OldSrc1Value & g_BilinearMasks[3]) >> g_BilinearShifts[3]) << 16;
                B00aa00gg |=  (OldSrc1Value & g_BilinearMasks[1]) >> g_BilinearShifts[1];
                B00rr00bb  = ((OldSrc1Value & g_BilinearMasks[0]) >> g_BilinearShifts[0]) << 16;
                B00rr00bb |=  (OldSrc1Value & g_BilinearMasks[2]) >> g_BilinearShifts[2];

                unsigned long Caaaagggg;
                unsigned long Crrrrbbbb;
                unsigned long Caarrggbb;

                Caaaagggg = A00aa00gg * u0 + B00aa00gg * u1;
                Crrrrbbbb = (A00rr00bb * u0 + B00rr00bb * u1) >> 8;
                Caarrggbb = (Caaaagggg & 0xFF00FF00) | (Crrrrbbbb & 0x00FF00FF);

                s0 = (((Caarrggbb & 0x00FF0000) >> 16) << g_BilinearShifts[0])
                     | (((Caarrggbb & 0x0000FF00) >> 8) << g_BilinearShifts[1])
                     | ((Caarrggbb & 0x000000FF) << g_BilinearShifts[2])
                     | (((Caarrggbb & 0xFF000000) >> 24) << g_BilinearShifts[3]);
            }

            if (src0.Value == src1.Value)
            {
                s1 = src0.Value;
            }
            else
            {
                unsigned long A00aa00gg;
                unsigned long A00rr00bb;

                A00aa00gg  = ((src0.Value & g_BilinearMasks[3]) >> g_BilinearShifts[3]) << 16;
                A00aa00gg |=  (src0.Value & g_BilinearMasks[1]) >> g_BilinearShifts[1];
                A00rr00bb  = ((src0.Value & g_BilinearMasks[0]) >> g_BilinearShifts[0]) << 16;
                A00rr00bb |=  (src0.Value & g_BilinearMasks[2]) >> g_BilinearShifts[2];

                unsigned long B00aa00gg;
                unsigned long B00rr00bb;

                B00aa00gg  = ((src1.Value & g_BilinearMasks[3]) >> g_BilinearShifts[3]) << 16;
                B00aa00gg |=  (src1.Value & g_BilinearMasks[1]) >> g_BilinearShifts[1];
                B00rr00bb  = ((src1.Value & g_BilinearMasks[0]) >> g_BilinearShifts[0]) << 16;
                B00rr00bb |=  (src1.Value & g_BilinearMasks[2]) >> g_BilinearShifts[2];

                unsigned long Caaaagggg;
                unsigned long Crrrrbbbb;
                unsigned long Caarrggbb;

                Caaaagggg = A00aa00gg * u0 + B00aa00gg * u1;
                Crrrrbbbb = (A00rr00bb * u0 + B00rr00bb * u1) >> 8;
                Caarrggbb = (Caaaagggg & 0xFF00FF00) | (Crrrrbbbb & 0x00FF00FF);

                s1 = (((Caarrggbb & 0x00FF0000) >> 16) << g_BilinearShifts[0])
                     | (((Caarrggbb & 0x0000FF00) >> 8) << g_BilinearShifts[1])
                     | ((Caarrggbb & 0x000000FF) << g_BilinearShifts[2])
                     | (((Caarrggbb & 0xFF000000) >> 24) << g_BilinearShifts[3]);
        }

            int xstepOverflow = 0;

            // Loop through all pixels that can be drawn without changing
            // s0 or s1, being careful not to write too many pixels.
            while (!xstepOverflow
                   && x < width)
            {
                // x only gets incremented here.
                x++;

                // Initialize v0 and v1
                int v1 = xstep >> 8;
                int v0 = 256 - v1;

                // Compute the SrcValue.
                unsigned long SrcValue;

                // See if we can take a short cut.
                if (s0 == s1)
                {
                    SrcValue = s0;
                }
                else
                {
                    unsigned long A00aa00gg;
                    unsigned long A00rr00bb;

                    A00aa00gg  = ((s0 & g_BilinearMasks[3]) >> g_BilinearShifts[3]) << 16;
                    A00aa00gg |=  (s0 & g_BilinearMasks[1]) >> g_BilinearShifts[1];
                    A00rr00bb  = ((s0 & g_BilinearMasks[0]) >> g_BilinearShifts[0]) << 16;
                    A00rr00bb |=  (s0 & g_BilinearMasks[2]) >> g_BilinearShifts[2];

                    unsigned long B00aa00gg;
                    unsigned long B00rr00bb;

                    B00aa00gg  = ((s1 & g_BilinearMasks[3]) >> g_BilinearShifts[3]) << 16;
                    B00aa00gg |=  (s1 & g_BilinearMasks[1]) >> g_BilinearShifts[1];
                    B00rr00bb  = ((s1 & g_BilinearMasks[0]) >> g_BilinearShifts[0]) << 16;
                    B00rr00bb |=  (s1 & g_BilinearMasks[2]) >> g_BilinearShifts[2];

                    unsigned long Caaaagggg;
                    unsigned long Crrrrbbbb;
                    unsigned long Caarrggbb;

                    Caaaagggg = A00aa00gg * v0 + B00aa00gg * v1;
                    Crrrrbbbb = (A00rr00bb * v0 + B00rr00bb * v1) >> 8;
                    Caarrggbb = (Caaaagggg & 0xFF00FF00) | (Crrrrbbbb & 0x00FF00FF);

                    SrcValue = (((Caarrggbb & 0x00FF0000) >> 16) << g_BilinearShifts[0])
                               | (((Caarrggbb & 0x0000FF00) >> 8) << g_BilinearShifts[1])
                               | ((Caarrggbb & 0x000000FF) << g_BilinearShifts[2])
                               | (((Caarrggbb & 0xFF000000) >> 24) << g_BilinearShifts[3]);
                }

                // Advance the "x pointer"
                xstep += xratio;
                xstepOverflow = xstep & (~FIX16_MASK);
                xstep &= FIX16_MASK;

                // Check to see if a destination read is required.
                if (dstMatters)
                {
                    switch (dst.Bpp)
                    {
                    case 16:
                        *(unsigned short *)&dst.Value = *(unsigned short *)dst.Ptr;
                        break;
                    case 32:
                        *(unsigned long *)&dst.Value = *(unsigned long *)dst.Ptr;
                        break;
                    case 24:
                        dst.Value = (*dst.Ptr) + (*(dst.Ptr+1) << 8) + (*(dst.Ptr+2) << 16);
                        break;
                    }
                }

                // Apply the ROP code.
                switch (rop3)
                {
                case 0xCC: break;
                case 0xEE: SrcValue |= dst.Value; break;
                case 0x88: SrcValue &= dst.Value; break;
                }

                SrcValue &= dst.Mask;

                // Write out the destination pixel.
                switch (dst.Bpp)
                {
                case 16:
                    *(unsigned short *)dst.Ptr = (unsigned short)SrcValue;
                    break;
                case 32:
                    *(unsigned long *)dst.Ptr = (unsigned long)SrcValue;
                    break;
                case 24:
                    *dst.Ptr       = (unsigned char)SrcValue;
                    *(dst.Ptr + 1) = (unsigned char)(SrcValue >> 8);
                    *(dst.Ptr + 2) = (unsigned char)(SrcValue >> 16);
                    break;
                }
                dst.Ptr += dst.BytesPerAccess;
            }
        }

        // Increment the source y pointer.
        ystep         += yratio;
        ystepOverflow  = ystep & (~FIX16_MASK);
        ystep         &= FIX16_MASK;
    }

    return S_OK;
}

class PixelIteratorRotate : public PixelIterator
{
public:
    // Fixed upon creation:
    unsigned char * OrigPtr;
    int             ColIncrement;
    int             Stride;
    WORD            IRotate;
    int             Width;
    int             Height;
    BOOL            IsRotate;
    
    // IteratorState
    POINTL          CurrentCoord;
    POINTL          RowCoord;
    
    void
    InitPixelIterator(
        GPESurf * pSurf,
        int       xPositive,
        int       yPositive,
        RECTL   * prcl,
        int       xSkip,
        int       ySkip
        );

    unsigned char *
    GetPtr(
        void
        );
};

void
PixelIteratorRotate::InitPixelIterator(
    GPESurf * pSurf,
    int       xPositive,
    int       yPositive,
    RECTL   * prcl,
    int       xSkip,
    int       ySkip
    )
{
    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("PixelIterator::PixelIterator, prcl= l:%d,t:%d - r:%d,b:%d Bpp=%d\r\n"),
        prcl->left, prcl->top, prcl->right, prcl->bottom, EGPEFormatToBpp[pSurf->Format()]
        ));

    IsRotate = pSurf->IsRotate();
    IRotate  = 0;
    Bpp = EGPEFormatToBpp[pSurf->Format()];
    Ptr = RowPtr = OrigPtr = 0;
    CacheState = CacheStateIncrement = CacheStateIncrementDirty
               = CacheStateNewDWord = CacheStateNewRow = 0;
               
    if (pSurf->IsRotate())
    {
        // Set pointer to start of first row to use
        GPESurf * pSurfRotate = (GPESurf *)pSurf;

        OrigPtr    = (unsigned char *)(pSurf->Buffer());
        RowCoord.x = RowCoord.y = CurrentCoord.x = CurrentCoord.y = 0;    
        IRotate    = pSurfRotate->Rotate();
        Stride     = pSurfRotate->Stride();
        Width      = pSurfRotate->ScreenWidth() - 1;    // 0 indexed
        Height     = pSurfRotate->ScreenHeight() - 1;  // 0 indexed

        ASSERT(Bpp >= 8);
    
        if( yPositive )
        {
            RowIncrement = 1;
            RowCoord.y += prcl->top + ySkip;
        }
        else
        {
            RowIncrement = -1;
            RowCoord.y += (prcl->bottom-1-ySkip);
        }

        if( xPositive )
        {
            ColIncrement = 1;
            RowCoord.x += prcl->left + xSkip;
        }
        else
        {
            ColIncrement = -1;
            RowCoord.x += prcl->right-1-xSkip;
        }

        BytesPerAccess = Bpp/8;  
        Mask = (0xffffffff >> (32-Bpp));
    }
    else 
    {
        PixelIterator::InitPixelIterator(pSurf, 
                                         xPositive, 
                                         yPositive, 
                                         prcl, 
                                         xSkip, 
                                         ySkip);
    }
}

unsigned char *
PixelIteratorRotate::GetPtr()
{
    unsigned char * ptr;

    switch(IRotate)
    {
    case DMDO_0:
        ptr = OrigPtr + CurrentCoord.y * Stride + CurrentCoord.x * BytesPerAccess;
        break;
    case DMDO_90:
        ptr = OrigPtr + (Height - CurrentCoord.x)*Stride + CurrentCoord.y * BytesPerAccess;
        break;
    case DMDO_180:
        ptr = OrigPtr + (Height - CurrentCoord.y)*Stride + (Width - CurrentCoord.x) * BytesPerAccess;
        break;
    case DMDO_270:
        ptr = OrigPtr + CurrentCoord.x * Stride + (Width - CurrentCoord.y) * BytesPerAccess;
        break;
    default:
        ptr = OrigPtr + CurrentCoord.y * Stride + CurrentCoord.x * BytesPerAccess;
        break;
    }

    return ptr;
}

// when calling this function, either src or dst or both are the primary surface and rotated.

SCODE
GPE::EmulatedBltRotate(
    GPEBltParms * pParms
    )
{
    SCODE (GPE::*pBlt)(GPEBltParms*) = pParms->pBlt;
    SCODE sc;
    BOOL bSaveBltFunc = FALSE;

    if(    pParms->pDst->InVideoMemory() ||
        ( pParms->pSrc && pParms->pSrc->InVideoMemory() ) ||
        ( pParms->pMask && pParms->pMask->InVideoMemory() ) ||
        ( pParms->pBrush && pParms->pBrush->InVideoMemory() ) )
    {
        // If we have a pending blt and now attempt a software operation using
        // video memory, the pipeline must be flushed.
        WaitForNotBusy();
    }

    if (pParms->pBlt != EmulatedBltRotate)
    {
        bSaveBltFunc = TRUE;
    }

    pParms->pBlt = (SCODE (GPE::*)(GPEBltParms*))EmulatedBltRotate_Internal;

    // Check to see if this should be handled by the ClearType(tm) or
    // AAFont libraries.
    if (pParms->rop4 == 0xAAF0)
    {
        ClearTypeBltSelect(pParms);
        AATextBltSelect(pParms);
    }

    // Check to see if this should be handled by the emul library.
    if (pParms->pBlt == (SCODE (GPE::*)(GPEBltParms*))EmulatedBltRotate_Internal)
    {
        EmulatedBltSelect02(pParms);
        EmulatedBltSelect08(pParms);
        EmulatedBltSelect16(pParms);
    }

    if (pParms->pBlt != (SCODE (GPE::*)(GPEBltParms*))EmulatedBltRotate_Internal)
    {
        DispPerfType(DISPPERF_ACCEL_EMUL);
    }

    // Check to see if we need to use Bilinear stretching
    if (pParms->iMode == BILINEAR)
    {
        LONG DstWidth  = pParms->prclDst->right - pParms->prclDst->left;
        LONG DstHeight = pParms->prclDst->bottom - pParms->prclDst->top;

        if (pParms->bltFlags == BLT_STRETCH
            && pParms->xPositive
            && pParms->yPositive
            && pParms->pDst->Format() > gpe8Bpp
            && (pParms->rop4 == 0xCCCC
                || pParms->rop4 == 0xEEEE
                || pParms->rop4 == 0x8888)
            && DstWidth > 0
            && DstHeight > 0
            && DstWidth >= pParms->prclSrc->right - pParms->prclSrc->left
            && DstHeight >= pParms->prclSrc->bottom - pParms->prclSrc->top)
        {
            pParms->pBlt = (SCODE (GPE::*)(GPEBltParms*))EmulatedBltRotate_Bilinear;
        }
    }

    sc = (this->*(pParms->pBlt))(pParms);

    if (bSaveBltFunc)
    {
        pParms->pBlt = pBlt;
    }

    return sc;
}

SCODE
GPE::EmulatedBltRotate_Internal(
    GPEBltParms * pParms
    )
{
    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("New Blt. rop4=%04X\r\n"), pParms->rop4));

    unsigned char rop3 = (unsigned char)pParms->rop4;
    unsigned char maskedROP3 = (unsigned char)( pParms->rop4 >> 8 );
    unsigned char unmaskedROP3 = rop3;
    int complexBlt = 0;
    int width = pParms->prclDst->right - pParms->prclDst->left;
    int height = pParms->prclDst->bottom - pParms->prclDst->top;
    int x;
    RECTL rclBrush;
    int dstMatters = ((( pParms->rop4 >> 1 ) ^ pParms->rop4 ) & 0x5555 ) != 0;
    int dstXPositive = pParms->xPositive;    // These differ from pParms->?Positive if flipping is being performed
    int dstYPositive = pParms->yPositive;
    RECTL *prclDst = pParms->prclDst;
    RECTL tmpRclDst;
    int xShrinkStretch = 0;
    int xShrink        = 0;
    int xStretch       = 0;
    int yShrinkStretch = 0;
    int yShrink        = 0;
    int yStretch       = 0;
    int srcWidth;
    int srcHeight;
    int rowXAccum, xAccum, xDMajor, xDMinor;    // only valid if xShrinkStretch
    int yAccum, yDMajor, yDMinor;    // only valid if yShrinkStretch
    int originalMaskRowInc, originalSrcRowInc;    // Used if yShrinkStretch
    unsigned char *prevMaskPtr, *prevSrcPtr;
    unsigned long prevMaskCache, prevSrcCache;
    unsigned long prevMaskCacheState, prevSrcCacheState;
    unsigned long originalSrc;
    unsigned long SrcRGBMask;
    int dstXStartSkip = 0;    // Number of dst pixels to not write (left if dstXPositive else right)
    int dstYStartSkip = 0;    // Number of rows to ignore (top if dstYPositive)
    int srcXStartSkip = 0;
    int srcYStartSkip = 0;
    POINTL prevSrcCoord;
    int    quickWrite = 0;

    rowXAccum = 0;

    // Variables used for AlphaBlend.
    ULONG RedMask;
    ULONG GreenMask;
    ULONG BlueMask;
    ULONG AlphaMask;
    ULONG RedShift;
    ULONG GreenShift;
    ULONG BlueShift;
    ULONG AlphaShift;
    ULONG SrcAlphaMask;
    ULONG SrcAlphaShift;

    BOOL  BlendPalette = FALSE;

    // If the BLENDFUNCTION isn't Null, the destination pixel value will need
    // to be read.
    int alphaBlend = 0;
    if (*(DWORD *)&(pParms->blendFunction) != *(DWORD *)&g_NullBlendFunction)
    {
        // Get the format of the source and destination surfaces.
        GPEFormat * pDstFormat = pParms->pDst->FormatPtr();

        if (pDstFormat->m_PaletteEntries == 3)
        {
            RedMask   = pDstFormat->m_pPalette[0];
            GreenMask = pDstFormat->m_pPalette[1];
            BlueMask  = pDstFormat->m_pPalette[2];
            AlphaMask = 0;

            // If this is a 32 bpp surface, try to add an "implicit" Alpha mask.
            if (EGPEFormatToBpp[pParms->pDst->Format()] == 32
                && !(0xFF000000 & (RedMask | GreenMask | BlueMask)))
            {
                AlphaMask = 0xFF000000;
            }
        }
        else if (pDstFormat->m_PaletteEntries == 4 && EGPEFormatToBpp[pParms->pDst->Format()] > 8)
        {
            RedMask   = pDstFormat->m_pPalette[0];
            GreenMask = pDstFormat->m_pPalette[1];
            BlueMask  = pDstFormat->m_pPalette[2];
            AlphaMask = pDstFormat->m_pPalette[3];
        }
        else
        {
            RedMask   = 0x000000FF;
            GreenMask = 0x0000FF00;
            BlueMask  = 0x00FF0000;
            AlphaMask = 0xFF000000;

            BlendPalette = TRUE;
        }

        // Compute the shifts for each mask.
        ULONG bit;
        ULONG Mask = RedMask;
        for (bit = 0; Mask && !(Mask & 1); bit++)
        {
            Mask >>= 1;
        }
        RedShift = bit;

        Mask = GreenMask;
        for (bit = 0; Mask && !(Mask & 1); bit++)
        {
            Mask >>= 1;
        }
        GreenShift = bit;

        Mask = BlueMask;
        for (bit = 0; Mask && !(Mask & 1); bit++)
        {
            Mask >>= 1;
        }
        BlueShift = bit;

        Mask = AlphaMask;
        for (bit = 0; Mask && !(Mask & 1); bit++)
        {
            Mask >>= 1;
        }
        AlphaShift = bit;

        // If this is a per-pixel blend, get the source alpha format.
        if (pParms->blendFunction.AlphaFormat)
        {
            DWORD SavedSrcAlphaMask;

            if (pParms->pSrc->FormatPtr()->m_PaletteEntries == 4)
            {
                SrcAlphaMask = pParms->pSrc->FormatPtr()->m_pPalette[3];
            }
            else if (pParms->pSrc->FormatPtr()->m_PaletteEntries == 3)
            {
                // If a fourth mask isn't provided, GDI guarantees that
                // 0xFF000000 is a valid alpha mask.
                SrcAlphaMask = 0xFF000000;
            }
            else
            {
                ASSERT(0);
            }

            SavedSrcAlphaMask = SrcAlphaMask;
            SrcAlphaShift     = 0;

            while (!(SrcAlphaMask & 1))
            {
                SrcAlphaMask >>= 1;
                SrcAlphaShift++;
            }

            SrcAlphaMask = SavedSrcAlphaMask;
        }

        dstMatters = 1;
        alphaBlend = 1;
    }

    // Handle improperly ordered prclDst resulting from stretch Blt
    // Note that only prclDst is ever improperly ordered
    if( width < 0 || height < 0 )
    {
        tmpRclDst = *prclDst;
        prclDst = &tmpRclDst;
        if( width < 0 )
        {
            SWAP( tmpRclDst.left, tmpRclDst.right, LONG )
            width = -width;
            dstXPositive = !dstXPositive;
        }
        if( height < 0 )
        {
            SWAP( tmpRclDst.top, tmpRclDst.bottom, LONG )
            height = -height;
            dstYPositive = !dstYPositive;
        }
    }
    // prclDst is now properly ordered


    if( pParms->bltFlags & BLT_STRETCH )    // Check for stretching or shrinking vertically &/or horizontally
    {
        srcWidth = pParms->prclSrc->right - pParms->prclSrc->left;
        srcHeight = pParms->prclSrc->bottom - pParms->prclSrc->top;

        if( width > srcWidth )
        {
            xStretch = 1;
            xDMajor = width;
            xDMinor = srcWidth;
        }
        if( width < srcWidth )
        {
            xShrink = 1;
            xDMajor = srcWidth;
            xDMinor = width;
        }
        if( xStretch || xShrink)
        {
            xShrinkStretch = 1;
            // Convert to Bresenham parameters
            xDMinor *= 2;
            xDMajor = xDMinor - 2 * xDMajor;
            rowXAccum = xShrink?(2*width - srcWidth):(3*srcWidth - 2*width);
                // loaded into xAccum at start of each row
        }
        if( height > srcHeight )
        {
            yStretch = 1;
            yDMajor = height;
            yDMinor = srcHeight;
        }
        if( height < srcHeight )
        {
            yShrink = 1;
            yDMajor = srcHeight;
            yDMinor = height;
        }
        if( yStretch || yShrink)
        {
            yShrinkStretch = 1;
            // Convert to Bresenham parameters
            yDMinor *= 2;
            yDMajor = yDMinor - 2 * yDMajor;
            yAccum = yShrink?(2*height - srcHeight):(3*srcHeight - 2*height);
        }

        if( pParms->prclClip )    // ONLY happens if stretch blting
        {
            RECTL rclClipped = *prclDst;
            if( rclClipped.left < pParms->prclClip->left )
                rclClipped.left = pParms->prclClip->left;
            if( rclClipped.top < pParms->prclClip->top )
                rclClipped.top = pParms->prclClip->top;
            if( rclClipped.bottom > pParms->prclClip->bottom )
                rclClipped.bottom = pParms->prclClip->bottom;
            if( rclClipped.right > pParms->prclClip->right )
                rclClipped.right = pParms->prclClip->right;
            if( rclClipped.right <= rclClipped.left || rclClipped.bottom <= rclClipped.top )
                return S_OK;    // the clipping left nothing to do
            dstXStartSkip = dstXPositive?(rclClipped.left-prclDst->left):(prclDst->right-rclClipped.right);
            dstYStartSkip = dstYPositive?(rclClipped.top-prclDst->top):(prclDst->bottom-rclClipped.bottom);
            width = rclClipped.right - rclClipped.left;        // Calculate fully clipped destination width
            height = rclClipped.bottom - rclClipped.top;    // Fully clipped height
        }

        if( xShrink )
        {
            while( rowXAccum < 0 )
            {
                rowXAccum += xDMinor;
                srcXStartSkip++;
            }
            rowXAccum += xDMajor; 
        }
        int skipCount;
        for( skipCount = dstXStartSkip; skipCount; skipCount-- )
        {
            if( xShrink )
            {
                while( rowXAccum < 0 )
                {
                    rowXAccum += xDMinor;
                    srcXStartSkip++;
                }
                srcXStartSkip++;    //  <--- this is the srcSkip inherent with a dstSkip
                rowXAccum += xDMajor; 
            }
            else if( xStretch )
            {
                if( rowXAccum < 0 )
                    rowXAccum += xDMinor;
                else
                {
                    rowXAccum += xDMajor;
                    srcXStartSkip++;
                }
            }
            else
                srcXStartSkip++;
        }
        if( yShrink )
        {
            yAccum += dstYStartSkip * yDMajor;
            srcYStartSkip += dstYStartSkip;    //  <--- this is the srcSkip inherent with a dstSkip
        }
        else if( yStretch )
        {
            for( skipCount = dstYStartSkip; skipCount; skipCount-- )
            {
                if( yAccum < 0 )
                    yAccum += yDMinor;
                else
                {
                    yAccum += yDMajor;
                    srcYStartSkip++;
                }
            }
        }
        else
            srcYStartSkip += dstYStartSkip;
     }

    int transparentBlt = pParms->bltFlags & BLT_TRANSPARENT;
    unsigned long transparentColor = pParms->solidColor;

    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("pSrc=0x%08x, pDst=0x%08x, pBrush=%08x, pMask=%08x\r\n"),
        pParms->pSrc, pParms->pDst, pParms->pBrush, pParms->pMask ));

    if( pParms->pBrush )
    {
        // Calculate an rclBrush so that the correct starting pixel is chosen for the brush iterator
        DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("Pattern depth: %d Bpp\r\n"), EGPEFormatToBpp[pParms->pBrush->Format()] ) );
        int topIndent = (pParms->pptlBrush)?pParms->pBrush->Height()-pParms->pptlBrush->y:0;
        int leftIndent = (pParms->pptlBrush)?pParms->pBrush->Width()-pParms->pptlBrush->x:0;
        rclBrush.left = ( leftIndent + prclDst->left ) % pParms->pBrush->Width();
        rclBrush.right = ( leftIndent + prclDst->right ) % pParms->pBrush->Width();
        rclBrush.top = ( topIndent + prclDst->top ) % pParms->pBrush->Height();
        rclBrush.bottom = ( topIndent + prclDst->bottom ) % pParms->pBrush->Height();
    }

    PixelIterator mask;
    PixelIteratorRotate src, dst;
    BrushPixelIterator brush; 
    src.Ptr = src.RowPtr = src.OrigPtr = 
    mask.Ptr = mask.RowPtr = brush.Ptr = brush.RowPtr = (unsigned char *)0;
    
    if( pParms->pSrc )
    {
        DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("pSrc depth: %d Bpp\r\n"), EGPEFormatToBpp[pParms->pSrc->Format()] ) );
        src.InitPixelIterator( pParms->pSrc, pParms->xPositive, pParms->yPositive, pParms->prclSrc,
            srcXStartSkip, srcYStartSkip );

        // If we're doing a transparent blt, we will need to know the real RGB
        // masks.
        if (transparentBlt)
        {
            GPEFormat * pFormat = pParms->pSrc->FormatPtr();

            // Make sure we're dealing with a known format.
            if (EGPEFormatToBpp[pParms->pSrc->Format()] > 8
                && (pFormat->m_PaletteEntries == 4
                    ||pFormat->m_PaletteEntries == 3))
            {
                ULONG * pMasks = pFormat->m_pPalette;

                SrcRGBMask = pMasks[0] | pMasks[1] | pMasks[2];
            }
            else
            {
                SrcRGBMask = src.Mask;
            }
        }
        else
        {
            SrcRGBMask = src.Mask;
        }
    }
    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("pDst depth: %d Bpp\r\n"), EGPEFormatToBpp[pParms->pDst->Format()] ) );

    if( pParms->pBrush )
    {
        DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("pBrush depth: %d Bpp\r\n"), EGPEFormatToBpp[pParms->pBrush->Format()] ) );
        brush.InitBrushPixelIterator( pParms->pBrush, pParms->xPositive, pParms->yPositive, &rclBrush );
    }

    if( ( maskedROP3 != unmaskedROP3 ) && !(pParms->pMask) )
    {
        DEBUGMSG(GPE_ZONE_ERROR,(TEXT("Rop4 = %04x but pMask is NULL\r\n"), pParms->rop4 ));
        return E_INVALIDARG;
    }

    if( pParms->pMask )
        mask.InitPixelIterator( pParms->pMask, pParms->xPositive, pParms->yPositive, pParms->prclMask,
            srcXStartSkip, srcYStartSkip );
    else
        mask.RowIncrement = 0;

    if( ( maskedROP3 != unmaskedROP3 ) && !(mask.RowPtr) )
    {
        DEBUGMSG(GPE_ZONE_ERROR,(TEXT("Rop4 = %04x but mask.RowPtr is NULL\r\n"), pParms->rop4 ));
        return E_INVALIDARG;
    }
    
    if( (dst.Bpp = EGPEFormatToBpp[pParms->pDst->Format()]) >= 8 && (dst.IsRotate = pParms->pDst->IsRotate()) == FALSE)
    {
        quickWrite = 1;    

        if( !dstYPositive )
        {
            dst.RowIncrement = -pParms->pDst->Stride();
            dst.RowPtr = (unsigned char *)pParms->pDst->Buffer() + pParms->pDst->Stride() * ( prclDst->bottom - 1 - dstYStartSkip);
        }
        else
        {
            dst.RowIncrement = pParms->pDst->Stride();
            dst.RowPtr = (unsigned char *)pParms->pDst->Buffer() + pParms->pDst->Stride() * ( dstYStartSkip + prclDst->top );
        }
        if( !dstXPositive )
        {
            dst.BytesPerAccess = -dst.Bpp/8;
            dst.RowPtr -= dst.BytesPerAccess * ( prclDst->right - 1 - dstXStartSkip );
        }
        else
        {
            dst.BytesPerAccess = dst.Bpp/8;
            dst.RowPtr += dst.BytesPerAccess * ( dstXStartSkip + prclDst->left );
        }
        dst.Mask = (0xffffffff) >> (32 - dst.Bpp);
        dst.CacheState=0;    // so it is not marked as dirty
    }
    else 
        dst.InitPixelIterator((GPESurf *)pParms->pDst, dstXPositive, dstYPositive,prclDst, 
                dstXStartSkip, dstYStartSkip);
    
    if( yShrinkStretch )
    {
        // Back up the source and mask row increments because they will be altered dynamically
        originalMaskRowInc = mask.RowIncrement;
        originalSrcRowInc = src.RowIncrement;
        DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("yStretch:%d yShrink:%d yDMinor:%d yDMajor:%d yAccum:%d\n"),
            yStretch, yShrink, yDMinor, yDMajor, yAccum ));
    }

    if( pParms->rop4 == 0x0000 )
    {
        src.Value = 0;
    }
    else if( pParms->rop4 == 0xffff )
    {
        src.Value = dst.Mask;
    }
    else
    {
        src.Value = pParms->solidColor & dst.Mask;
        if(       ( maskedROP3 != unmaskedROP3 )
            || transparentBlt
            || alphaBlend
            || xShrinkStretch
            || ( rop3 != 0xCC && ( rop3 != 0xF0 || pParms->pBrush ) ) )
        {
            DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("Complex Blt!\r\n")));
            DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("transparent:%d,masked:%2x,unmasked:%2x,rop3:%2x,mask.RowPtr:%08x\r\n"),
                transparentBlt,maskedROP3, unmaskedROP3, rop3, mask.RowPtr ));
            complexBlt = 1;
        }
    }
    brush.Value = src.Value;

    while( height-- )
    {
        // Handle y Shrinking or stretching
        if( yShrinkStretch )
        {
            if( yShrink )
            {
                while( yAccum < 0 )    // skip source line(s) if shrinking
                {
                    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("yShrink - skip line\r\n")));
                    if (!src.IsRotate)
                        src.RowPtr += src.RowIncrement;
                    else 
                        src.RowCoord.y += src.RowIncrement;    
                    mask.RowPtr += mask.RowIncrement;
                    yAccum += yDMinor;
                }
                yAccum += yDMajor;
            }
            else
            {
                if( yAccum < 0 )
                {
                    // repeat source line if stretching
                    yAccum += yDMinor;        // yDMinor is a small +ve number
                    if( yStretch )
                    {
                        DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("yStretch - Repeat. Accum=%d\r\n"), yAccum));
                        src.RowIncrement = 0;
                        mask.RowIncrement = 0;
                    }
                }
                else
                {
                    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("yStretch - Switch to next after this Accum=%d\r\n"), yAccum));
                    // Switch to next source line  (after this row)
                    yAccum += yDMajor;        // yDMajor is a large -ve value (i.e. |yDMajor| > |yDMinor| )
                    src.RowIncrement = originalSrcRowInc;
                    mask.RowIncrement = originalMaskRowInc;
                }
            }
        }


        // Move all iterators to next line
        if( src.RowPtr )
        {
            src.Ptr = src.RowPtr;
            src.RowPtr += src.RowIncrement;
            if( ! src.Is24Bit )
            {
                src.Cache = *(unsigned long *)src.Ptr;
                src.CacheState = src.CacheStateNewRow;
            }
        } 
        else if (src.OrigPtr)
        {
            src.CurrentCoord = src.RowCoord;
            src.RowCoord.y += src.RowIncrement;
        }
    
        if( mask.RowPtr )
        {
            mask.Ptr = mask.RowPtr;
            mask.RowPtr += mask.RowIncrement;
            mask.Cache = *(UNALIGNED unsigned long *)mask.Ptr;
            mask.CacheState = mask.CacheStateNewRow;
        }
        if( brush.RowPtr )
        {
            brush.Ptr = brush.RowPtr;
            brush.LeftRowPtr = brush.Ptr - brush.LeftPixelOffset;
            if( --brush.RowsRemaining )
                brush.RowPtr += brush.RowIncrement;
            else
            {
                brush.RowPtr = brush.FirstRowPtr;
                brush.RowsRemaining = brush.Rows;
            }
            brush.Cache = *(unsigned long *)brush.Ptr;
            brush.CacheState = brush.CacheStateNewRow;
            brush.PixelsRemaining = brush.RowInitialPixelsRemaining;
        }

        if (dst.IsRotate)
        {
            dst.CurrentCoord = dst.RowCoord;
            dst.RowCoord.y += dst.RowIncrement;
        } 
        else 
        {
            dst.Ptr = dst.RowPtr;
            dst.RowPtr += dst.RowIncrement;
        }

        if( !quickWrite )
        {
            dst.CacheState = dst.CacheStateNewRow;
        }

        if( xStretch )
        {
            prevMaskPtr = mask.Ptr;
            prevMaskCache = mask.Cache;
            prevMaskCacheState = mask.CacheState;
            if (src.IsRotate)
                prevSrcCoord = src.CurrentCoord;
            else
            {
                prevSrcPtr = src.Ptr;
                prevSrcCache = src.Cache;
                prevSrcCacheState = src.CacheState;
            }
        }

        xAccum = rowXAccum;

        for( x=0; x<width; x++ )
        {
            if( src.Ptr || src.OrigPtr)
            {
                // Read the next pixel in and convert to same depth as destination
                if (src.Ptr)
                {
                    if( src.Is24Bit )    // Since 24-bit packed pixels cross dword boundaries:
                    {
                        src.Value = ( *src.Ptr ) + ( *(src.Ptr+1) << 8 ) +    ( *(src.Ptr+2) << 16 );
                        src.Ptr += src.BytesPerAccess;
                    }
                    else
                    {
                        if( !(src.CacheState&0x00ff00) )    // Check bits remaining in src.Cache
                        {
                            src.Ptr += src.BytesPerAccess;            // increment src.Ptr
                            src.CacheState = src.CacheStateNewDWord;
                            src.Cache = *(unsigned long *)src.Ptr;    // reload src.Cache
                        }
                        src.Value = src.Cache >> ( (src.CacheState >> 16) ^ src.MaskShiftXor );
                        src.CacheState += src.CacheStateIncrement;         
                    }
                }
                else  // src.origPtr, i.e. rotated surface 
                {
                    switch (src.Bpp)
                    {
                    case 8:
                        *(unsigned char *)&src.Value = *(unsigned char*)src.GetPtr();
                        break;
                    case 16:
                        *(unsigned short *)&src.Value = *(unsigned short *)src.GetPtr();
                        break;
                    case 32:
                        *(unsigned long *)&src.Value = *(unsigned long *)src.GetPtr();
                        break;
                    case 24:
                        {
                        unsigned char *ptr = src.GetPtr();
                        src.Value = ( *ptr ) + ( *(ptr+1) << 8 ) +    ( *(ptr+2) << 16 ); 
                        break;
                        }
                    }
                    src.CurrentCoord.x += src.ColIncrement;
                }

                // Save the origianl source for transparency.
                originalSrc = ( src.Value &= src.Mask );
                originalSrc &= SrcRGBMask;

                if( pParms->pLookup )
                    src.Value = (pParms->pLookup)[src.Value];
                if( pParms->pConvert )
                {
                    src.Value = (pParms->pColorConverter->*(pParms->pConvert))( src.Value );
                }    
                    // pParms->pConvert( pParms->pColorConverter, src.Value );
            }
            
            if( complexBlt )    // brushed, masked, transparent, unusual rop3 etc
            {
                if( brush.Ptr )
                {
                    // Note that the brush will already have been converted to the same
                    // depth as the destination (if they weren't the same).
                    // The exception is if the dest is 24Bpp. In this case, the brush
                    // will have been converted to 32Bpp for simplicity.
                    // See DrvRealizeBrush for details

                    if( !(brush.PixelsRemaining--) )    // Check for wrapping off right edge of pattern
                    {
                        brush.Ptr = brush.LeftRowPtr;
                        brush.PixelsRemaining = brush.PixelsPerRow-1;
                        brush.CacheState = brush.CacheStateNewDWord;
                        brush.Cache = *(unsigned long *)brush.Ptr;    // reload brush.Cache
                    }
                    else if( !(brush.CacheState&0x00ff00) )    // Check bits remaining in brush.Cache
                    {
                        brush.Ptr += brush.BytesPerAccess;                // increment brush.Ptr
                        brush.CacheState = brush.CacheStateNewDWord;
                        brush.Cache = *(unsigned long *)brush.Ptr;    // reload brush.Cache
                    }
                    brush.Value = brush.Cache >> ( (brush.CacheState >> 16) ^ brush.MaskShiftXor );
                    brush.CacheState += brush.CacheStateIncrement;         
                }
                if( mask.Ptr ) // This selects between two rop3's
                {
                    if( !(mask.CacheState&0x00ff00) )    // check bits remaining in mask cache
                    {
                        mask.Ptr += mask.BytesPerAccess;    //  == +/- 4
                        mask.CacheState = mask.CacheStateNewDWord;
                        mask.Cache = *(UNALIGNED unsigned long *)mask.Ptr;
                    }
                    rop3 = ( mask.Cache & ( 1 << ( (mask.CacheState >> 16) ^ mask.MaskShiftXor ) ) ) ? unmaskedROP3 : maskedROP3;
                    mask.CacheState += mask.CacheStateIncrement;
                }

                if( xShrinkStretch )
                {
                    // Handle x Stretching
                    if( xStretch )
                    {
                        if( xAccum < 0 )    // Repeat this pixel
                        {
                            xAccum += xDMinor;
                            mask.Ptr = prevMaskPtr;
                            mask.Cache = prevMaskCache;
                            mask.CacheState = prevMaskCacheState;
                            if (src.IsRotate)
                                src.CurrentCoord = prevSrcCoord;
                            else 
                            {
                                src.Ptr = prevSrcPtr;
                                src.Cache = prevSrcCache;
                                src.CacheState = prevSrcCacheState;
                            }
                        }
                        else                // OK to move to next source pixel after this
                        {
                            xAccum += xDMajor;
                            prevMaskPtr = mask.Ptr;
                            prevMaskCache = mask.Cache;
                            prevMaskCacheState = mask.CacheState;
                            if (src.IsRotate)
                                prevSrcCoord = src.CurrentCoord;
                            else 
                            {
                                prevSrcPtr = src.Ptr;
                                prevSrcCache = src.Cache;
                                prevSrcCacheState = src.CacheState;
                            }
                        }
                    }
                    else    // xShrink
                    {
                        while( xAccum < 0 )        // Skip pixel(s)
                        {
                            // Move to next src pixel
                            if (src.IsRotate)
                                src.CurrentCoord.x += src.ColIncrement;
                            else {
                                if( src.Is24Bit )    // Since 24-bit packed pixels cross dword boundaries:
                                    src.Ptr += src.BytesPerAccess;
                                else
                                {
                                    if( !(src.CacheState&0x00ff00) )    // Check bits remaining in src.Cache
                                    {
                                        src.Ptr += src.BytesPerAccess;            // increment src.Ptr
                                        src.CacheState = src.CacheStateNewDWord;
                                        if (x != width - 1 )
                                            src.Cache = *(unsigned long *)src.Ptr;    // reload src.Cache
                                    }
                                    src.CacheState += src.CacheStateIncrement;         
                                }
                            }
                            // Move to next mask pixel
                            if( pParms->pMask )
                            {
                                if( !(mask.CacheState&0x00ff00) )    // check bits remaining in mask cache
                                {
                                    mask.Ptr += mask.BytesPerAccess;        //  == +/- 4
                                    mask.CacheState = mask.CacheStateNewDWord;
                                    mask.Cache = *(UNALIGNED unsigned long *)mask.Ptr;
                                }
                                mask.CacheState += mask.CacheStateIncrement;
                            }
                            xAccum += xDMinor;
                        }
                        xAccum += xDMajor;
                    }
                }
                if( dstMatters )        // The underlying rop4 utilizes the dst.
                {
                    // We maintain dst.Cache valid at all times if not doing quickWrite
                    if (dst.IsRotate)
                    {
                        switch(dst.Bpp)
                        {
                        case 8:
                            *(unsigned char *)&dst.Value = *(unsigned char *)dst.GetPtr();
                            break;
                        case 16:
                            *(unsigned short *)&dst.Value = *(unsigned short *)dst.GetPtr();
                            break;
                        case 32:
                            *(unsigned long *)&dst.Value = *(unsigned long *)dst.GetPtr();
                            break;
                        case 24:
                            unsigned char *ptr = dst.GetPtr();
                            dst.Value = ( *ptr ) + ( *(ptr+1) << 8 ) +    ( *(ptr+2) << 16 );
                        }
                    }
                    else 
                    {
                        if( quickWrite )
                        {
                            switch(dst.Bpp)
                            {
                            case 8:
                                *(unsigned char *)&dst.Value = *(unsigned char *)dst.Ptr;
                                break;
                            case 16:
                                *(unsigned short *)&dst.Value = *(unsigned short *)dst.Ptr;
                                break;
                            case 32:
                                *(unsigned long *)&dst.Value = *(unsigned long *)dst.Ptr;
                                break;
                            case 24:
                                dst.Value = ( *dst.Ptr ) + ( *(dst.Ptr+1) << 8 ) +    ( *(dst.Ptr+2) << 16 );
                            }
                        }
                        else
                            dst.Value = dst.Cache >> ( ( dst.CacheState >> 16 ) ^ dst.MaskShiftXor );
                    }
                }
                
                switch( rop3 )
                {
                    // The compiler sorts these and creates a binary search set of tests to
                    // get to an entry quickly.  Branch "prediction" helps this a lot.
                    // Remember that masked rop4s makes NOP and SRCCOPY quite a likely rop3
                    case 0xAA: break;                                             // NOP
                    case 0xCC: break;                                            // SRCCOPY
                    case 0x00: src.Value = 0;                            break; // BLACKNESS
                    case 0x22: src.Value = (~src.Value) & dst.Value;    break; // no-name
                    case 0xB8: src.Value = (brush.Value & ~src.Value)|(src.Value & dst.Value);    break; // no-name
                    case 0x11: src.Value = ~(src.Value | dst.Value);    break; // NOTSRCERASE
                    case 0x33: src.Value = ~src.Value;                    break; // NOTSRCCOPY
                    case 0x44: src.Value &= ~dst.Value;                    break; // SRCERASE
                    case 0x55: src.Value = ~dst.Value;                    break; // DSTINVERT
                    case 0x5A: src.Value = brush.Value ^ dst.Value;        break; // PATINVERT
                    case 0x66: src.Value ^= dst.Value;                    break; // SRCINVERT
                    case 0x88: src.Value &= dst.Value;                    break; // SRCAND
                    case 0xBB: src.Value = ~src.Value | dst.Value;        break; // MERGEPAINT
                    case 0xC0: src.Value &= brush.Value;                break; // MERGECOPY
                    case 0xEE: src.Value |= dst.Value;                    break; // SRCPAINT
                    case 0xF0: src.Value = brush.Value;                    break; // PATCOPY
                    case 0xFB: src.Value = brush.Value | ~src.Value | dst.Value; break; // PATPAINT
                    case 0xFF: src.Value = 0xFFFFFFFF;                    break; // WHITENESS
                    case 0xE2: src.Value = ( dst.Value & ~src.Value ) | ( brush.Value & src.Value ); break;
                    case 0xAC: src.Value = ((src.Value^dst.Value)&brush.Value)^src.Value; break;
                    default:   src.Value = ProcessROP3(dst.Value,src.Value,brush.Value,rop3,dst.Bpp);
                }

                // Perform the AlphaBlend
                if (alphaBlend)
                {
                    ULONG SrcRed;
                    ULONG SrcGreen;
                    ULONG SrcBlue;
                    ULONG SrcAlpha;
                    ULONG DstRed;
                    ULONG DstGreen;
                    ULONG DstBlue;
                    ULONG DstAlpha;

                    BYTE  Alpha = pParms->blendFunction.SourceConstantAlpha;

                    ULONG   PalEntries = 0;
                    ULONG * pPalette   = NULL;
                    int     AlphaType  = 0;

                    // If the surface has a palette, get the BGR value of the
                    // color.
                    if (BlendPalette)
                    {
                        pPalette   = pParms->pDst->FormatPtr()->m_pPalette;
                        PalEntries = pParms->pDst->FormatPtr()->m_PaletteEntries;

                        // The mask isn't always applied to the destination value.
                        dst.Value &= dst.Mask;

                        ASSERT(src.Value < PalEntries);
                        ASSERT(dst.Value < PalEntries);

                        src.Value  = pPalette[src.Value];
                        dst.Value  = pPalette[dst.Value];
                    }

                    SrcRed   = (src.Value & RedMask)   >> RedShift;
                    SrcGreen = (src.Value & GreenMask) >> GreenShift;
                    SrcBlue  = (src.Value & BlueMask)  >> BlueShift;
                    SrcAlpha = (src.Value & AlphaMask) >> AlphaShift;

                    DstRed   = (dst.Value & RedMask)   >> RedShift;
                    DstGreen = (dst.Value & GreenMask) >> GreenShift;
                    DstBlue  = (dst.Value & BlueMask)  >> BlueShift;
                    DstAlpha = (dst.Value & AlphaMask) >> AlphaShift;

                    // Figure out which of the three alpha blending functions    
                    // needs to be used.
                    if (pParms->blendFunction.AlphaFormat)
                    {
                        SrcAlpha = originalSrc & SrcAlphaMask;
                        SrcAlpha >>= SrcAlphaShift;

                        if (SrcAlpha == 0)
                        {
                            // Just the dst.
                            src.Value = (DstRed   << 16) |
                                        (DstGreen <<  8) |
                                        (DstBlue       ) |
                                        (DstAlpha << 24);
                        }
                        else if (SrcAlpha == 255 && Alpha == 255)
                        {
                            // Just the src.
                            src.Value = (SrcRed   << 16) |
                                        (SrcGreen <<  8) |
                                        (SrcBlue       ) |
                                        (SrcAlpha << 24);
                        }
                        else if (SrcAlpha == 255)
                        {
                            // Source constant alpha only.
                            AlphaType = 1;
                        }
                        else
                        {
                            if (Alpha == 255)
                            {
                                AlphaType = 2; // Per-pixel only
                            }
                            else
                            {
                                AlphaType = 3; // Both;
                            }
                        }
                    }
                    else
                    {
                        AlphaType = 1;
                    }

                    // Perform the alpha blend.
                    if (AlphaType == 3)
                    {
                        // Both Per-Pixel and Constant Alpha

                        ULONG uB00aa00gg = (SrcAlpha << 16) | SrcGreen;
                        ULONG uB00rr00bb = (SrcRed   << 16) | SrcBlue;

                        ULONG uTaaaagggg = uB00aa00gg * Alpha + 0x00800080;
                        ULONG uTrrrrbbbb = uB00rr00bb * Alpha + 0x00800080;

                        ULONG uT00aa00gg = (uTaaaagggg & 0xff00ff00) >> 8;
                        ULONG uT00rr00bb = (uTrrrrbbbb & 0xff00ff00) >> 8;

                        ULONG uCaa00gg00 = ((uTaaaagggg + uT00aa00gg) & 0xff00ff00);
                        ULONG uC00rr00bb = ((uTrrrrbbbb + uT00rr00bb) & 0xff00ff00) >> 8;

                        src.Value = uCaa00gg00 | uC00rr00bb;

                        BYTE beta = 255 - (BYTE)((src.Value & 0xff000000) >> 24);

                        ULONG _D1_00aa00gg = (DstAlpha << 16) | DstGreen;
                        ULONG _D1_00rr00bb = (DstRed   << 16) | DstBlue;

                        ULONG _D2_aaaagggg = _D1_00aa00gg * beta + 0x00800080;
                        ULONG _D2_rrrrbbbb = _D1_00rr00bb * beta + 0x00800080;

                        ULONG _D3_00aa00gg = (_D2_aaaagggg & 0xff00ff00) >> 8;
                        ULONG _D3_00rr00bb = (_D2_rrrrbbbb & 0xff00ff00) >> 8;

                        ULONG _D4_00aa00gg = ((_D2_aaaagggg + _D3_00aa00gg) & 0xff00ff00) >> 8;
                        ULONG _D4_00rr00bb = ((_D2_rrrrbbbb + _D3_00rr00bb) & 0xff00ff00) >> 8;

                        ULONG _D5_00aa00gg = _D4_00aa00gg + ((src.Value & 0xff00ff00) >> 8);
                        ULONG _D5_00rr00bb = _D4_00rr00bb + (src.Value & 0x00ff00ff);

                        // Saturate the ARGB values.
                        ULONG TempMask = (AlphaMask >> AlphaShift) << 16;
                        if ((_D5_00aa00gg & 0xffff0000) > TempMask)
                        {
                            _D5_00aa00gg = TempMask | (_D5_00aa00gg & 0x0000ffff);
                        }

                        TempMask = GreenMask >> GreenShift;
                        if ((_D5_00aa00gg & 0x0000ffff) > TempMask)
                        {
                            _D5_00aa00gg = TempMask | (_D5_00aa00gg & 0x00ff0000);
                        }

                        TempMask = (RedMask >> RedShift) << 16;
                        if ((_D5_00rr00bb & 0xffff0000) > TempMask)
                        {
                            _D5_00rr00bb = TempMask | (_D5_00rr00bb & 0x0000ffff);
                        }

                        TempMask = BlueMask >> BlueShift;
                        if ((_D5_00rr00bb & 0x0000ffff) > TempMask)
                        {
                            _D5_00rr00bb = TempMask | (_D5_00rr00bb & 0x00ff0000);
                        }

                        src.Value = (_D5_00aa00gg << 8) | _D5_00rr00bb;
                    }
                    else if (AlphaType == 2)
                    {
                        // Per-Pixel Only

                        ULONG Multa = 255 - SrcAlpha;

                        ULONG _D1_00aa00gg = (DstAlpha << 16) | DstGreen;
                        ULONG _D1_00rr00bb = (DstRed   << 16) | DstBlue;

                        ULONG _D2_aaaagggg = _D1_00aa00gg * Multa + 0x00800080;
                        ULONG _D2_rrrrbbbb = _D1_00rr00bb * Multa + 0x00800080;

                        ULONG _D3_00aa00gg = (_D2_aaaagggg & 0xff00ff00) >> 8;
                        ULONG _D3_00rr00bb = (_D2_rrrrbbbb & 0xff00ff00) >> 8;

                        ULONG _D4_00aa00gg = ((_D2_aaaagggg + _D3_00aa00gg) & 0xff00ff00) >> 8;
                        ULONG _D4_00rr00bb = ((_D2_rrrrbbbb + _D3_00rr00bb) & 0xff00ff00) >> 8;

                        ULONG _D5_00aa00gg = _D4_00aa00gg + ((SrcAlpha << 16) | SrcGreen);
                        ULONG _D5_00rr00bb = _D4_00rr00bb + ((SrcRed   << 16) | SrcBlue);

                        // Saturate the ARGB values.
                        ULONG TempMask = (AlphaMask >> AlphaShift) << 16;
                        if ((_D5_00aa00gg & 0xffff0000) > TempMask)
                        {
                            _D5_00aa00gg = TempMask | (_D5_00aa00gg & 0x0000ffff);
                        }

                        TempMask = GreenMask >> GreenShift;
                        if ((_D5_00aa00gg & 0x0000ffff) > TempMask)
                        {
                            _D5_00aa00gg = TempMask | (_D5_00aa00gg & 0x00ff0000);
                        }

                        TempMask = (RedMask >> RedShift) << 16;
                        if ((_D5_00rr00bb & 0xffff0000) > TempMask)
                        {
                            _D5_00rr00bb = TempMask | (_D5_00rr00bb & 0x0000ffff);
                        }

                        TempMask = BlueMask >> BlueShift;
                        if ((_D5_00rr00bb & 0x0000ffff) > TempMask)
                        {
                            _D5_00rr00bb = TempMask | (_D5_00rr00bb & 0x00ff0000);
                        }

                        src.Value = (_D5_00aa00gg << 8) | _D5_00rr00bb;
                    }
                    else if (AlphaType == 1)
                    {
                        // Constant Alpha Only

                        // red and blue
                        ULONG uB00rr00bb = (DstRed << 16) | DstBlue;
                        ULONG uF00rr00bb = (SrcRed << 16) | SrcBlue;
                        ULONG uMrrrrbbbb = ((uB00rr00bb << 8) - uB00rr00bb)
                                           + (Alpha * (uF00rr00bb - uB00rr00bb)) + 0x00800080;
                        ULONG uM00rr00bb = (uMrrrrbbbb & 0xff00ff00) >> 8;
                        ULONG uD00rr00bb = ((uMrrrrbbbb + uM00rr00bb) & 0xff00ff00) >> 8;

                        // alpha and green
                        ULONG uB00aa00gg = (DstAlpha << 16) | DstGreen;
                        ULONG uF00aa00gg = (SrcAlpha << 16) | SrcGreen;
                        ULONG uMaaaagggg = ((uB00aa00gg << 8) - uB00aa00gg)
                                           + (Alpha * (uF00aa00gg - uB00aa00gg)) + 0x00800080;
                        ULONG uM00aa00gg = (uMaaaagggg & 0xff00ff00) >> 8;
                        ULONG uDaa00gg00 = (uMaaaagggg + uM00aa00gg) & 0xff00ff00;

                        src.Value = uD00rr00bb + uDaa00gg00;
                    }

                    // Convert src.Value back to the appropriate format;
                    SrcBlue  =  (src.Value & 0x000000ff)        << BlueShift;
                    SrcGreen = ((src.Value & 0x0000ff00) >> 8)  << GreenShift;
                    SrcRed   = ((src.Value & 0x00ff0000) >> 16) << RedShift;
                    SrcAlpha = ((src.Value & 0xff000000) >> 24) << AlphaShift;

                    src.Value = ((SrcRed & RedMask)
                                 | (SrcGreen & GreenMask)
                                 | (SrcBlue  & BlueMask)
                                 | (SrcAlpha & AlphaMask));

                    // If the destination surface has a palette, src.Value must
                    // be converted to a palette index.
                    if (BlendPalette)
                    {
                        ULONG Error = RGBError(src.Value, pPalette[0]);
                        ULONG Index = 0; 

                        for (ULONG i = 1; i < PalEntries; i++)
                        {
                            ULONG TempErr = RGBError(src.Value, pPalette[i]);
                            if (TempErr < Error)
                            {
                                Error = TempErr;
                                Index = i;
                            }
                        }

                        src.Value = Index;
                    }
                }

                src.Value &= dst.Mask;

                if( rop3 == 0xAA || ( transparentBlt && ( originalSrc == transparentColor ) ) )
                {
                    // we won't write this pixel
                    if (dst.IsRotate)
                        dst.CurrentCoord.x += dst.ColIncrement;
                    else 
                    {
                        if( quickWrite )
                            dst.Ptr += dst.BytesPerAccess;
                        else
                        {
                            dst.CacheState += dst.CacheStateIncrement; // leave dirty flag as-is
                            if( !(dst.CacheState&0x00ff00) ) // Check bits remaining in dst cache
                            {
                                if( dst.CacheState & 0x0000ff )
                                    *(unsigned long *)dst.Ptr = dst.Cache;    // flush cache
                                dst.CacheState = dst.CacheStateNewDWord;        // clears dirty flag
                                dst.Ptr += dst.BytesPerAccess;                    // +/- 4
                                dst.Cache = *(unsigned long *)dst.Ptr;
                            }
                        }
                    }
                    continue;
                }
            }

            // Now, we are ready to write the value from src.Value into the dst pixel
            if (dst.IsRotate)
            {
                switch(dst.Bpp)
                {
                case 8:
                    *(unsigned char *)dst.GetPtr() = (unsigned char)src.Value;
                    break;
                case 16:
                    *(unsigned short *)dst.GetPtr() = (unsigned short)src.Value;
                    break;
                case 32:
                    *(unsigned long *)dst.GetPtr() = (unsigned long)src.Value;
                    break;
                case 24:
                    unsigned char *ptr = dst.GetPtr();
                    *ptr = (unsigned char)(src.Value);
                    *(ptr+1) = (unsigned char)(src.Value>>8);
                    *(ptr+2) = (unsigned char)(src.Value>>16);
                }
            dst.CurrentCoord.x += dst.ColIncrement;
            } 
            else 
            {
                if( quickWrite )
                {
                    switch(dst.Bpp)
                    {
                    case 8:
                        *(unsigned char *)dst.Ptr = (unsigned char)src.Value;
                        break;
                    case 16:
                        *(unsigned short *)dst.Ptr = (unsigned short)src.Value;
                        break;
                    case 32:
                        *(unsigned long *)dst.Ptr = (unsigned long)src.Value;
                        break;
                    case 24:
                        *dst.Ptr = (unsigned char)(src.Value);
                        *(dst.Ptr+1) = (unsigned char)(src.Value>>8);
                        *(dst.Ptr+2) = (unsigned char)(src.Value>>16);
                    }
                dst.Ptr += dst.BytesPerAccess;
                }
                else
                {
                    unsigned char tmpShift = (unsigned char)(( dst.CacheState >> 16 ) ^ dst.MaskShiftXor);
                    dst.Cache &= ~( dst.Mask << tmpShift);
                    dst.Cache |= src.Value << tmpShift;
                    dst.CacheState += dst.CacheStateIncrementDirty;  // sets dirty flag

                    if( !(dst.CacheState&0x00ff00) ) // Check bits remaining in dst cache
                    {                    
                        *(unsigned long *)dst.Ptr = dst.Cache;    // flush cache (we know it was dirty)
                        dst.CacheState = dst.CacheStateNewDWord;    // clears dirty flag
                        dst.Ptr += dst.BytesPerAccess;                // +/- 4
                        if (x != width - 1 )
                        dst.Cache = *(unsigned long *)dst.Ptr;
                    }
                }
            }
        } // next column

        if( dst.CacheState & 0x0000ff )
        {
            *(unsigned long *)dst.Ptr = dst.Cache;    // flush cache
        }
    } // next row

    return S_OK;
}

SCODE
GPE::EmulatedBltRotate_Bilinear(
    GPEBltParms * pParms
    )
{
    int width  = pParms->prclDst->right - pParms->prclDst->left;
    int height = pParms->prclDst->bottom - pParms->prclDst->top;

    int dstMatters   = ((( pParms->rop4 >> 1 ) ^ pParms->rop4 ) & 0x5555) != 0;

    int srcWidth  = pParms->prclSrc->right - pParms->prclSrc->left;
    int srcHeight = pParms->prclSrc->bottom - pParms->prclSrc->top;

    int dstXStartSkip = 0;
    int dstYStartSkip = 0;
    int srcXStartSkip = 0;
    int srcYStartSkip = 0;

    unsigned int xratio = srcWidth * FIX16_ONE / width;
    unsigned int yratio = srcHeight * FIX16_ONE / height;

    unsigned int xstep = (xratio - FIX16_ONE) >> 1;
    unsigned int ystep = (yratio - FIX16_ONE) >> 1;

    unsigned char rop3 = (unsigned char)pParms->rop4;

    ystep &= FIX16_MASK;
    xstep &= FIX16_MASK;

    if (pParms->prclClip)
    {
        RECTL rclClipped = *pParms->prclDst;

        if (rclClipped.left < pParms->prclClip->left)
        {
            rclClipped.left = pParms->prclClip->left;
        }

        if (rclClipped.top < pParms->prclClip->top)
        {
            rclClipped.top = pParms->prclClip->top;
        }

        if (rclClipped.bottom > pParms->prclClip->bottom)
        {
            rclClipped.bottom = pParms->prclClip->bottom;
        }

        if (rclClipped.right > pParms->prclClip->right)
        {
            rclClipped.right = pParms->prclClip->right;
        }

        // The clipped rect is empty.
        if (rclClipped.right <= rclClipped.left
            || rclClipped.bottom <= rclClipped.top)
        {
            return S_OK;
        }

        dstXStartSkip = pParms->xPositive ? (rclClipped.left - pParms->prclDst->left) : (pParms->prclDst->right - rclClipped.right);
        dstYStartSkip = pParms->yPositive ? (rclClipped.top - pParms->prclDst->top) : (pParms->prclDst->bottom - rclClipped.bottom);

        width  = rclClipped.right - rclClipped.left;
        height = rclClipped.bottom - rclClipped.top;
    }

    int skipCount;

    for (skipCount = dstXStartSkip; skipCount; skipCount--)
    {
        xstep         += xratio;
        srcXStartSkip += (xstep >> FIX16_SHIFT);
        xstep         &= FIX16_MASK;
    }

    for (skipCount = dstYStartSkip; skipCount; skipCount--)
    {
        ystep         += yratio;
        srcYStartSkip += (ystep >> FIX16_SHIFT);
        ystep         &= FIX16_MASK;
    }

    // The destination must be at least 16 bpp.
    PixelIteratorRotate dst;

    dst.Bpp = EGPEFormatToBpp[pParms->pDst->Format()];

    if (!pParms->pDst->IsRotate())
    {
        if (pParms->yPositive)
        {
            dst.RowIncrement = pParms->pDst->Stride();
            dst.RowPtr       = (unsigned char*)pParms->pDst->Buffer() + pParms->pDst->Stride() * (pParms->prclDst->top + dstYStartSkip);
        }
        else
        {
            dst.RowIncrement = -pParms->pDst->Stride();
            dst.RowPtr       = (unsigned char*)pParms->pDst->Buffer() + pParms->pDst->Stride() * (pParms->prclDst->bottom - 1 - dstYStartSkip);
        }

        if (pParms->xPositive)
        {
            dst.BytesPerAccess  = dst.Bpp/8;
            dst.RowPtr         += dst.BytesPerAccess * (pParms->prclDst->left + dstXStartSkip);
        }
        else
        {
            dst.BytesPerAccess  = -dst.Bpp/8;
            dst.RowPtr         -= dst.BytesPerAccess * (pParms->prclDst->right - 1 - dstXStartSkip);
        }

        dst.IsRotate   = 0;
        dst.Mask       = (2 << (dst.Bpp - 1)) - 1;
        dst.CacheState = 0;  // so it is not marked as dirty
    }
    else
    {
        dst.InitPixelIterator((GPESurf *)pParms->pDst, pParms->xPositive, pParms->yPositive, pParms->prclDst,
                              dstXStartSkip, dstYStartSkip);
    }

    // Initialize the first source iterator (src0)
    PixelIteratorRotate src0;

    src0.InitPixelIterator(pParms->pSrc, pParms->xPositive, pParms->yPositive, pParms->prclSrc,
                           srcXStartSkip, srcYStartSkip-1);

    // Initialize the second source iterator (src1)
    PixelIteratorRotate src1;

    src1.InitPixelIterator(pParms->pSrc, pParms->xPositive, pParms->yPositive, pParms->prclSrc,
                           srcXStartSkip, srcYStartSkip);

    // Compensate for srcXStartSkip and srcYStartSkip.
    srcHeight -= srcYStartSkip;
    srcWidth  -= srcXStartSkip;

    // Force a read of the first row.
    int ystepOverflow = 1;

    for (int y = 0, SrcYPixels = 0; y < height; y++)
    {
        bool IsSrc0Valid;
        bool IsSrc1Valid;

        // Initialize the dst row pointer to the next line.
        if (dst.IsRotate)
        {
            dst.CurrentCoord  = dst.RowCoord;
            dst.RowCoord.y   += dst.RowIncrement;
        }
        else
        {
            dst.Ptr     = dst.RowPtr;
            dst.RowPtr += dst.RowIncrement;
        }

        // Initialize u0 and u1
        int u1 = ystep >> 8;
        int u0 = 256 - u1;

        // Check to see if we need to advance to the next row, or go back to
        // the beginning of the current source row.
        if (!ystepOverflow)
        {
            SrcYPixels--;
            if (!src0.IsRotate)
            {
                src0.RowPtr -= src0.RowIncrement;
                src1.RowPtr -= src0.RowIncrement;
            }
            else
            {
                src0.RowCoord.y -= src0.RowIncrement;
                src1.RowCoord.y -= src1.RowIncrement;
            }
        }

        // Initialize the source row pointers to the next line.
        if (src0.RowPtr)
        {
            src0.Ptr     = src0.RowPtr;
            src0.RowPtr += src0.RowIncrement;
            src1.Ptr     = src1.RowPtr;
            src1.RowPtr += src1.RowIncrement;
        }
        else if (src0.OrigPtr)
        {
            src0.CurrentCoord  = src0.RowCoord;
            src0.RowCoord.y   += src0.RowIncrement;
            src1.CurrentCoord  = src1.RowCoord;
            src1.RowCoord.y   += src1.RowIncrement;
        }

        if (SrcYPixels == 0)
        {
            IsSrc0Valid = false;
        }
        else
        {
            IsSrc0Valid = true;
        }

        if (SrcYPixels < srcHeight)
        {
            IsSrc1Valid = true;
        }
        else
        {
            IsSrc1Valid = false;
        }

        SrcYPixels++;

        if (src0.RowPtr)
        {
            if (!src0.Is24Bit && IsSrc0Valid)
            {
                src0.Cache      = *(unsigned long *)src0.Ptr;
                src0.CacheState = src0.CacheStateNewRow;
            }

            if (!src1.Is24Bit && IsSrc1Valid)
            {
                src1.Cache      = *(unsigned long *)src1.Ptr;
                src1.CacheState = src1.CacheStateNewRow;
            }
        }

        for (int x = 0, SrcXPixels = 0; x < width;)
        {
            // Save the old values of src0 and src1.
            unsigned long OldSrc0Value = src0.Value;
            unsigned long OldSrc1Value = src1.Value;

            // Only increment the src0 and src1 pointers if we haven't hit the
            // end of a row.
            if (SrcXPixels < srcWidth)
            {
                SrcXPixels++;

                // Get the next src0 pixel.
                if (IsSrc0Valid)
                {
                    if (src0.Ptr)
                    {
                        if (src0.Is24Bit)
                        {
                            src0.Value  = (*src0.Ptr) + (*(src0.Ptr+1) << 8) + (*(src0.Ptr+2) << 16);
                            src0.Ptr   += src0.BytesPerAccess;
                        }
                        else
                        {
                            if (!(src0.CacheState & 0x00FF00))
                            {
                                src0.Ptr        += src0.BytesPerAccess;
                                src0.CacheState  = src0.CacheStateNewDWord;
                                src0.Cache       = *(unsigned long *)src0.Ptr;
                            }

                            src0.Value       = src0.Cache >> ((src0.CacheState >> 16) ^ src0.MaskShiftXor);
                            src0.CacheState += src0.CacheStateIncrement;
                        }
                    }
                    else
                    {
                        switch (src0.Bpp)
                        {
                        case 8:
                            src0.Value = *(unsigned char *)src0.GetPtr();
                            break;
                        case 16:
                            src0.Value = *(unsigned short *)src0.GetPtr();
                            break;
                        case 32:
                            src0.Value = *(unsigned long *)src0.GetPtr();
                            break;
                        case 24:
                            {
                                unsigned char * ptr = src0.GetPtr();
                                src0.Value = (*ptr) | (*(ptr+1) << 8) + (*(ptr+2) << 16);
                                break;
                            }
                        }

                        src0.CurrentCoord.x += src0.ColIncrement;
                    }

                    src0.Value &= src0.Mask;

                    if (pParms->pLookup)
                    {
                        src0.Value = (pParms->pLookup)[src0.Value];
                    }

                    if (pParms->pConvert)
                    {
                        src0.Value = (pParms->pColorConverter->*(pParms->pConvert))(src0.Value);
                    }
                }

                // Get the next src1 pixel (if needed).
                if (IsSrc1Valid)
                {
                    if (src1.Ptr)
                    {
                        if (src1.Is24Bit)
                        {
                            src1.Value  = (*src1.Ptr) + (*(src1.Ptr+1) << 8) + (*(src1.Ptr+2) << 16);
                            src1.Ptr   += src1.BytesPerAccess;
                        }
                        else
                        {
                            if (!(src1.CacheState & 0x00FF00))
                            {
                                src1.Ptr        += src1.BytesPerAccess;
                                src1.CacheState  = src1.CacheStateNewDWord;
                                src1.Cache       = *(unsigned long *)src1.Ptr;
                            }

                            src1.Value       = src1.Cache >> ((src1.CacheState >> 16) ^ src1.MaskShiftXor);
                            src1.CacheState += src1.CacheStateIncrement;
                        }
                    }
                    else
                    {
                        switch (src1.Bpp)
                        {
                        case 8:
                            src1.Value = *(unsigned char *)src1.GetPtr();
                            break;
                        case 16:
                            src1.Value = *(unsigned short *)src1.GetPtr();
                            break;
                        case 32:
                            src1.Value = *(unsigned long *)src1.GetPtr();
                            break;
                        case 24:
                            {
                                unsigned char * ptr = src1.GetPtr();
                                src1.Value = (*ptr) | (*(ptr+1) << 8) + (*(ptr+2) << 16);
                                break;
                            }
                        }

                        src1.CurrentCoord.x += src1.ColIncrement;
                    }

                    src1.Value &= src1.Mask;

                    if (pParms->pLookup)
                    {
                        src1.Value = (pParms->pLookup)[src1.Value];
                    }

                    if (pParms->pConvert)
                    {
                        src1.Value = (pParms->pColorConverter->*(pParms->pConvert))(src1.Value);
                    }
                }
                else
                {
                    src1.Value = src0.Value;
                }

                if (!IsSrc0Valid)
                {
                    src0.Value = src1.Value;
                }
            }

            // If this is the first pixel read set the old values to this pixel
            if (SrcXPixels == 1)
            {
                OldSrc0Value = src0.Value;
                OldSrc1Value = src1.Value;
            }

            // Combine the pixels according to this algorithm:
            //   s0       = OldSrc0Value * u0 + OldSrc1Value * u1;
            //   s1       =   src0.Value * u0 +   src1.Value * u1;
            //   SrcValue =           s0 * v0 +           s1 * v1;

            unsigned long s0;
            unsigned long s1;

            if (OldSrc0Value == OldSrc1Value)
            {
                s0 = OldSrc0Value;
            }
            else
            {
                unsigned long A00aa00gg;
                unsigned long A00rr00bb;

                A00aa00gg  = ((OldSrc0Value & g_BilinearMasks[3]) >> g_BilinearShifts[3]) << 16;
                A00aa00gg |=  (OldSrc0Value & g_BilinearMasks[1]) >> g_BilinearShifts[1];
                A00rr00bb  = ((OldSrc0Value & g_BilinearMasks[0]) >> g_BilinearShifts[0]) << 16;
                A00rr00bb |=  (OldSrc0Value & g_BilinearMasks[2]) >> g_BilinearShifts[2];

                unsigned long B00aa00gg;
                unsigned long B00rr00bb;

                B00aa00gg  = ((OldSrc1Value & g_BilinearMasks[3]) >> g_BilinearShifts[3]) << 16;
                B00aa00gg |=  (OldSrc1Value & g_BilinearMasks[1]) >> g_BilinearShifts[1];
                B00rr00bb  = ((OldSrc1Value & g_BilinearMasks[0]) >> g_BilinearShifts[0]) << 16;
                B00rr00bb |=  (OldSrc1Value & g_BilinearMasks[2]) >> g_BilinearShifts[2];

                unsigned long Caaaagggg;
                unsigned long Crrrrbbbb;
                unsigned long Caarrggbb;

                Caaaagggg = A00aa00gg * u0 + B00aa00gg * u1;
                Crrrrbbbb = (A00rr00bb * u0 + B00rr00bb * u1) >> 8;
                Caarrggbb = (Caaaagggg & 0xFF00FF00) | (Crrrrbbbb & 0x00FF00FF);

                s0 = (((Caarrggbb & 0x00FF0000) >> 16) << g_BilinearShifts[0])
                     | (((Caarrggbb & 0x0000FF00) >> 8) << g_BilinearShifts[1])
                     | ((Caarrggbb & 0x000000FF) << g_BilinearShifts[2])
                     | (((Caarrggbb & 0xFF000000) >> 24) << g_BilinearShifts[3]);
            }

            if (src0.Value == src1.Value)
            {
                s1 = src0.Value;
            }
            else
            {
                unsigned long A00aa00gg;
                unsigned long A00rr00bb;

                A00aa00gg  = ((src0.Value & g_BilinearMasks[3]) >> g_BilinearShifts[3]) << 16;
                A00aa00gg |=  (src0.Value & g_BilinearMasks[1]) >> g_BilinearShifts[1];
                A00rr00bb  = ((src0.Value & g_BilinearMasks[0]) >> g_BilinearShifts[0]) << 16;
                A00rr00bb |=  (src0.Value & g_BilinearMasks[2]) >> g_BilinearShifts[2];

                unsigned long B00aa00gg;
                unsigned long B00rr00bb;

                B00aa00gg  = ((src1.Value & g_BilinearMasks[3]) >> g_BilinearShifts[3]) << 16;
                B00aa00gg |=  (src1.Value & g_BilinearMasks[1]) >> g_BilinearShifts[1];
                B00rr00bb  = ((src1.Value & g_BilinearMasks[0]) >> g_BilinearShifts[0]) << 16;
                B00rr00bb |=  (src1.Value & g_BilinearMasks[2]) >> g_BilinearShifts[2];

                unsigned long Caaaagggg;
                unsigned long Crrrrbbbb;
                unsigned long Caarrggbb;

                Caaaagggg = A00aa00gg * u0 + B00aa00gg * u1;
                Crrrrbbbb = (A00rr00bb * u0 + B00rr00bb * u1) >> 8;
                Caarrggbb = (Caaaagggg & 0xFF00FF00) | (Crrrrbbbb & 0x00FF00FF);

                s1 = (((Caarrggbb & 0x00FF0000) >> 16) << g_BilinearShifts[0])
                     | (((Caarrggbb & 0x0000FF00) >> 8) << g_BilinearShifts[1])
                     | ((Caarrggbb & 0x000000FF) << g_BilinearShifts[2])
                     | (((Caarrggbb & 0xFF000000) >> 24) << g_BilinearShifts[3]);
        }

            int xstepOverflow = 0;

            // Loop through all pixels that can be drawn without changing
            // s0 or s1, being careful not to write too many pixels.
            while (!xstepOverflow
                   && x < width)
            {
                // x only gets incremented here.
                x++;

                // Initialize v0 and v1
                int v1 = xstep >> 8;
                int v0 = 256 - v1;

                // Compute the SrcValue.
                unsigned long SrcValue;

                // See if we can take a short cut.
                if (s0 == s1)
                {
                    SrcValue = s0;
                }
                else
                {
                    unsigned long A00aa00gg;
                    unsigned long A00rr00bb;

                    A00aa00gg  = ((s0 & g_BilinearMasks[3]) >> g_BilinearShifts[3]) << 16;
                    A00aa00gg |=  (s0 & g_BilinearMasks[1]) >> g_BilinearShifts[1];
                    A00rr00bb  = ((s0 & g_BilinearMasks[0]) >> g_BilinearShifts[0]) << 16;
                    A00rr00bb |=  (s0 & g_BilinearMasks[2]) >> g_BilinearShifts[2];

                    unsigned long B00aa00gg;
                    unsigned long B00rr00bb;

                    B00aa00gg  = ((s1 & g_BilinearMasks[3]) >> g_BilinearShifts[3]) << 16;
                    B00aa00gg |=  (s1 & g_BilinearMasks[1]) >> g_BilinearShifts[1];
                    B00rr00bb  = ((s1 & g_BilinearMasks[0]) >> g_BilinearShifts[0]) << 16;
                    B00rr00bb |=  (s1 & g_BilinearMasks[2]) >> g_BilinearShifts[2];

                    unsigned long Caaaagggg;
                    unsigned long Crrrrbbbb;
                    unsigned long Caarrggbb;

                    Caaaagggg = A00aa00gg * v0 + B00aa00gg * v1;
                    Crrrrbbbb = (A00rr00bb * v0 + B00rr00bb * v1) >> 8;
                    Caarrggbb = (Caaaagggg & 0xFF00FF00) | (Crrrrbbbb & 0x00FF00FF);

                    SrcValue = (((Caarrggbb & 0x00FF0000) >> 16) << g_BilinearShifts[0])
                               | (((Caarrggbb & 0x0000FF00) >> 8) << g_BilinearShifts[1])
                               | ((Caarrggbb & 0x000000FF) << g_BilinearShifts[2])
                               | (((Caarrggbb & 0xFF000000) >> 24) << g_BilinearShifts[3]);
                }

                // Advance the "x pointer"
                xstep += xratio;
                xstepOverflow = xstep & (~FIX16_MASK);
                xstep &= FIX16_MASK;

                // Check to see if a destination read is required.
                if (dstMatters)
                {
                    if (dst.IsRotate)
                    {
                        switch (dst.Bpp)
                        {
                        case 16:
                            *(unsigned short *)&dst.Value = *(unsigned short *)dst.GetPtr();
                            break;
                        case 32:
                            *(unsigned long *)&dst.Value = *(unsigned long *)dst.GetPtr();
                            break;
                        case 24:
                            {
                                unsigned char *ptr = dst.GetPtr();
                                dst.Value = (*ptr) + (*(ptr+1) << 8) + (*(ptr+2) << 16);
                                break;
                            }
                        }
                    }
                    else
                    {
                        switch (dst.Bpp)
                        {
                        case 16:
                            *(unsigned short *)&dst.Value = *(unsigned short *)dst.Ptr;
                            break;
                        case 32:
                            *(unsigned long *)&dst.Value = *(unsigned long *)dst.Ptr;
                            break;
                        case 24:
                            dst.Value = (*dst.Ptr) + (*(dst.Ptr+1) << 8) + (*(dst.Ptr+2) << 16);
                            break;
                        }
                    }
                }

                // Apply the ROP code.
                switch (rop3)
                {
                case 0xCC: break;
                case 0xEE: SrcValue |= dst.Value; break;
                case 0x88: SrcValue &= dst.Value; break;
                }

                SrcValue &= dst.Mask;

                // Write out the destination pixel.
                if (dst.IsRotate)
                {
                    switch (dst.Bpp)
                    {
                    case 16:
                        *(unsigned short *)dst.GetPtr() = (unsigned short)SrcValue;
                        break;
                    case 32:
                        *(unsigned long *)dst.GetPtr() = (unsigned long)SrcValue;
                        break;
                    case 24:
                        {
                            unsigned char *ptr = dst.GetPtr();
                            *ptr       = (unsigned char)SrcValue;
                            *(ptr + 1) = (unsigned char)(SrcValue >> 8);
                            *(ptr + 2) = (unsigned char)(SrcValue >> 16);
                            break;
                        }
                    }
                    dst.CurrentCoord.x += dst.ColIncrement;
                }
                else
                {
                    switch (dst.Bpp)
                    {
                    case 16:
                        *(unsigned short *)dst.Ptr = (unsigned short)SrcValue;
                        break;
                    case 32:
                        *(unsigned long *)dst.Ptr = (unsigned long)SrcValue;
                        break;
                    case 24:
                        *dst.Ptr       = (unsigned char)SrcValue;
                        *(dst.Ptr + 1) = (unsigned char)(SrcValue >> 8);
                        *(dst.Ptr + 2) = (unsigned char)(SrcValue >> 16);
                        break;
                    }
                    dst.Ptr += dst.BytesPerAccess;
                }
            }
        }

        // Increment the source y pointer.
        ystep         += yratio;
        ystepOverflow  = ystep & (~FIX16_MASK);
        ystep         &= FIX16_MASK;
    }

    return S_OK;
}

