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
#include <memory.h>
#include <wingdi.h>

// The "static" keyword here makes the symbol "_rgbIdentity" local only to this
// file.  Thus preventing multiply defined symbol linker errors.
static
#include <syspal.h>

INSTANTIATE_GPE

GPE::GPE()
{
    m_pPrimarySurface = (GPESurf *)NULL;
    m_nScreenWidth = 0;
    m_nScreenHeight = 0;
    m_pMode = (GPEMode *)NULL;

    GenBltInitialize();
}

GPE::~GPE(void)
{
    ;
}

BOOL GPE::ContrastControl(
    ULONG cmd,
    ULONG *pValue)
{
    return TRUE;
}

VOID GPE::PowerHandler(
    BOOL bOff)
{
    return;
}

SCODE GPE::GetPalette(
    LPPALETTEENTRY *ppPalette,
    unsigned short *pcEntries)
{
    *ppPalette = NULL;
    *pcEntries = 0;

    if (m_pMode && m_pMode->Bpp <= 8)
    {
        *ppPalette = _rgbIdentity;
        *pcEntries = PALETTE_SIZE;
    }

    if (*pcEntries > 0)
        return S_OK;
    else
        return S_FALSE;
}

ULONG GPE::DrvEscape(
    SURFOBJ *pso,
    ULONG    iEsc,
    ULONG    cjIn,
    PVOID    pvIn,
    ULONG    cjOut,
    PVOID    pvOut)
{
    return 0;
}

ULONG GPE::GetGraphicsCaps(void)
{
    return 0;
}

// The following GPE methods are only used for DDHALs - the default does nothing 
void GPE::GetPhysicalVideoMemory(
    unsigned long *pPhysicalMemoryBase,
    unsigned long *pVideoMemorySize )
{
    ;
}

void GPE::SetVisibleSurface( GPESurf *pSurf )
{
    ;
}

int     GPE::FlipInProgress()
{
    return 0;
}

void GPE::WaitForVBlank()
{
    ;
}

int    GPE::SurfaceBusyFlipping( GPESurf *pSurf )
{
    return 0;
}

int GPE::IsBusy()
{
    return 0;
}

void GPE::WaitForNotBusy()
{
    ;
}

unsigned long GPE::AvailableVideoMemory()
{
    return 0;
}

int GPE::ScanLine()
{
    return 0;
}

SCODE GPE::ProcessCommandBlock( unsigned char *pBlock )
{
    return E_NOTIMPL;
}

BOOL GPE::GetScreenDimensions( GPEScreenProps * pProps )
{
    static WCHAR s_szGPERegKey[] = L"Drivers\\Display\\GPE";

    // Default values for the physical dimensions of the screen.
    ULONG ulHorzSize   = 64;
    ULONG ulVertSize   = 60;
    ULONG ulLogPixelsX = 96;
    ULONG ulLogPixelsY = 96;
    ULONG ulAspectX    = 1;
    ULONG ulAspectY    = 1;
    ULONG ulAspectXY   = 1;

    BOOL bResult = FALSE;

    if (pProps)
    {
        HKEY hKey;

        bResult = TRUE;

        // Open GPE's regkey and read the know values from it.
        if (ERROR_SUCCESS == RegOpenKeyEx(HKEY_LOCAL_MACHINE,
                                          s_szGPERegKey,
                                          0,
                                          0,
                                          &hKey))
        {
            DWORD dwType;
            DWORD dwValue;
            DWORD dwSize;

            dwSize = sizeof (ULONG);
            if (ERROR_SUCCESS == RegQueryValueEx(hKey,
                                                 L"HorizontalSize",
                                                 NULL,
                                                 &dwType,
                                                 (BYTE*)&dwValue,
                                                 &dwSize))
            {
                if (REG_DWORD == dwType)
                {
                    ulHorzSize = dwValue;
                }
            }

            dwSize = sizeof (ULONG);
            if (ERROR_SUCCESS == RegQueryValueEx(hKey,
                                                 L"VerticalSize",
                                                 NULL,
                                                 &dwType,
                                                 (BYTE*)&dwValue,
                                                 &dwSize))
            {
                if (REG_DWORD == dwType)
                {
                    ulVertSize = dwValue;
                }
            }

            dwSize = sizeof (ULONG);
            if (ERROR_SUCCESS == RegQueryValueEx(hKey,
                                                 L"LogicalPixelsX",
                                                 NULL,
                                                 &dwType,
                                                 (BYTE*)&dwValue,
                                                 &dwSize))
            {
                if (REG_DWORD == dwType)
                {
                    ulLogPixelsX = dwValue;
                }
            }

            dwSize = sizeof (ULONG);
            if (ERROR_SUCCESS == RegQueryValueEx(hKey,
                                                 L"LogicalPixelsY",
                                                 NULL,
                                                 &dwType,
                                                 (BYTE*)&dwValue,
                                                 &dwSize))
            {
                if (REG_DWORD == dwType)
                {
                    ulLogPixelsY = dwValue;
                }
            }

            dwSize = sizeof (ULONG);
            if (ERROR_SUCCESS == RegQueryValueEx(hKey,
                                                 L"AspectRatioX",
                                                 NULL,
                                                 &dwType,
                                                 (BYTE*)&dwValue,
                                                 &dwSize))
            {
                if (REG_DWORD == dwType)
                {
                    ulAspectX= dwValue;
                }
            }

            dwSize = sizeof (ULONG);
            if (ERROR_SUCCESS == RegQueryValueEx(hKey,
                                                 L"AspectRatioY",
                                                 NULL,
                                                 &dwType,
                                                 (BYTE*)&dwValue,
                                                 &dwSize))
            {
                if (REG_DWORD == dwType)
                {
                    ulAspectY= dwValue;
                }
            }

            dwSize = sizeof (ULONG);
            if (ERROR_SUCCESS == RegQueryValueEx(hKey,
                                                 L"AspectRatioXY",
                                                 NULL,
                                                 &dwType,
                                                 (BYTE*)&dwValue,
                                                 &dwSize))
            {
                if (REG_DWORD == dwType)
                {
                    ulAspectXY = dwValue;
                }
            }

            RegCloseKey(hKey);
        }

        // This is the screen width in millimeters.
        pProps->ulHorzSize   = ulHorzSize;

        // This is the screen height in millimeters.
        pProps->ulVertSize   = ulVertSize;

        // These represent the number of logical pixels per inch.
        pProps->ulLogPixelsX = ulLogPixelsX;
        pProps->ulLogPixelsY = ulLogPixelsY;

        // These represent the aspect ration of a pixel.
        pProps->ulAspectX    = ulAspectX;
        pProps->ulAspectY    = ulAspectY;
        pProps->ulAspectXY   = ulAspectXY;
    }

    return bResult;
}

int
GPE::IsPaletteSettable()
{
    // This should be overridden for settable palettes with !=8 Bpp, or for a fixed 8Bpp palette
    return ( m_pMode->Bpp == 8 );
}

void
GPE::RotateRectl(
    RECTL *prcl
    )
{
    RECTL rclSwap = *prcl;

    switch (m_iRotate)
    {
    case DMDO_90:
        prcl->left   = rclSwap.top;
        prcl->right  = rclSwap.bottom;
        prcl->top    = m_nScreenHeightSave - rclSwap.right;
        prcl->bottom = m_nScreenHeightSave - rclSwap.left;
        break;
        
    case DMDO_180:
        prcl->left   = m_nScreenWidthSave  - rclSwap.right;
        prcl->right  = m_nScreenWidthSave  - rclSwap.left;
        prcl->top    = m_nScreenHeightSave - rclSwap.bottom;
        prcl->bottom = m_nScreenHeightSave - rclSwap.top;
        break;
        
    case DMDO_270:
        prcl->left   = m_nScreenWidthSave - rclSwap.bottom;
        prcl->right  = m_nScreenWidthSave - rclSwap.top;
        prcl->top    = rclSwap.left;
        prcl->bottom = rclSwap.right;
        break;
        
    default:
         break;
    }
}

void
GPE::RotateRectlBack(
    RECTL * prcl
    )
{
    RECTL rclSwap = *prcl;

    switch (m_iRotate)
    {
    case DMDO_90:
        prcl->top    = rclSwap.left;
        prcl->bottom = rclSwap.right;
        prcl->left   = m_nScreenHeightSave - rclSwap.bottom;
        prcl->right  = m_nScreenHeightSave - rclSwap.top;
        break;
        
    case DMDO_180:
        prcl->left   = m_nScreenWidthSave  - rclSwap.right;
        prcl->right  = m_nScreenWidthSave  - rclSwap.left;
        prcl->top    = m_nScreenHeightSave - rclSwap.bottom;
        prcl->bottom = m_nScreenHeightSave - rclSwap.top;
        break;
        
    case DMDO_270:
        prcl->top    = m_nScreenWidthSave - rclSwap.right;
        prcl->bottom = m_nScreenWidthSave - rclSwap.left;
        prcl->left   = rclSwap.top;
        prcl->right  = rclSwap.bottom;
        break;
        
    default:
         break;
    }
}

ULONG *
GPE::GetClearTypeRGBMasks()
{
    return DrvGetMasks((DHPDEV)this);
}

GPESurf::GPESurf(
    int        width,
    int        height,
    EGPEFormat format
    )
{
    // Even though "width" and "height" are int's, they must be positive.
    ASSERT(width > 0);
    ASSERT(height > 0);

    if (width > 0 && height > 0)
    {
        m_nWidth               = width;
        m_nHeight              = height;
        m_eFormat              = format;
        m_nStrideBytes         = ( (EGPEFormatToBpp[ format ] * width + 7 )/ 8 + 3 ) & ~3L;
        m_pVirtAddr            = (ADDRESS)new unsigned char[ m_nStrideBytes * height ];
        m_fInVideoMemory       = 0;
        m_nOffsetInVideoMemory = 0;
        m_fOwnsBuffer          = 1;
        m_iRotate              = 0;
        m_ScreenHeight         = 0;
        m_ScreenWidth          = 0;
    }
    else
    {
        memset(this, 0, sizeof (this));
    }
}

void
GPESurf::Init(
    int          width,
    int          height,
    void       * pBits,
    int          stride,
    EGPEFormat   format
    )
{
    // Even though the display driver won't allocate a surface with 0 width
    // or height, GDI (and the font engine) might.
    m_nWidth               = width;
    m_nHeight              = height;
    m_eFormat              = format;
    m_nStrideBytes         = stride;
    m_pVirtAddr            = (ADDRESS)pBits;
    m_fInVideoMemory       = 0;
    m_nOffsetInVideoMemory = 0;
    m_fOwnsBuffer          = 0;
    m_iRotate              = 0;
    m_ScreenHeight         = 0;
    m_ScreenWidth          = 0;
}

GPESurf::~GPESurf()
{
    if( m_fOwnsBuffer )
    {
        if( m_pVirtAddr )
        {
            delete (void *)m_pVirtAddr;
        }
    }
}

void
GPESurf::RotateLineParms(
    GPELineParms * pParms
    )
{
    long lTmp;

    switch (m_iRotate)
    {
    case DMDO_90:
        lTmp = pParms->xStart;

        pParms->xStart = pParms->yStart;
        pParms->yStart = (m_ScreenHeight - 1) - lTmp;
        pParms->iDir   = (pParms->iDir - 2) < 0 ? (pParms->iDir + 6) : (pParms->iDir - 2);
        break;
    
    case DMDO_180:
        pParms->xStart = (m_ScreenWidth - 1) - pParms->xStart;
        pParms->yStart = (m_ScreenHeight - 1) - pParms->yStart;
        pParms->iDir   = (pParms->iDir - 4) < 0 ? (pParms->iDir + 4) : (pParms->iDir - 4);
        break;
    
    case DMDO_270:
        lTmp = pParms->xStart;

        pParms->xStart = (m_ScreenWidth - 1) - pParms->yStart;
        pParms->yStart = lTmp;
        pParms->iDir   = (pParms->iDir - 6) < 0 ? (pParms->iDir + 2) : (pParms->iDir - 6);
        break;
    
    default:
         break;
    }
}

void
GPESurf::SetRotation(
    int width,
    int height,
    int iRotate
    )
{
    m_iRotate    = iRotate;
    m_BytesPixel = EGPEFormatToBpp[m_eFormat] >> 3;
    m_nWidth     = width;
    m_nHeight    = height;

    switch (iRotate)
    {
    case DMDO_90:
    case DMDO_270:
        m_ScreenHeight = m_nWidth;
        m_ScreenWidth  = m_nHeight;
        break;
        
    case DMDO_0:
    case DMDO_180:
    default:
        m_ScreenWidth  = m_nWidth;
        m_ScreenHeight = m_nHeight;
        break;
    }
}
    
void
GPESurf::RotatePathdata(
    PATHDATA * ppd
    )
{
    ULONG      cptfx;
    ULONG      ulPoint;
    POINTFIX * pptfx;

    cptfx = ppd->count;

    switch(m_iRotate)
    {
    case DMDO_90:   
        for (pptfx = ppd->pptfx, ulPoint=0; ulPoint < cptfx; ulPoint++, pptfx ++)
        {     
            FIX fxSwap = pptfx->x;

            pptfx->x = pptfx->y;
            pptfx->y = LTOFX(m_ScreenHeight-1) - fxSwap;
        }
        break;

    case DMDO_180:    
        for (pptfx = ppd->pptfx, ulPoint = 0; ulPoint < cptfx; ulPoint ++, pptfx ++)
        {
            pptfx->x = LTOFX(m_ScreenWidth-1) - pptfx->x;
            pptfx->y = LTOFX(m_ScreenHeight-1) - pptfx->y;
        }
        break;

    case DMDO_270:
        for (pptfx = ppd->pptfx, ulPoint = 0; ulPoint < cptfx; ulPoint ++, pptfx ++)
        {
            FIX fxSwap = pptfx->x;

            pptfx->x = LTOFX(m_ScreenWidth-1) - pptfx->y;
            pptfx->y = fxSwap;
        }    
        break;

    default:
        break;
    }
}

void
GPESurf::RotatePathdataBack(
    PATHDATA * ppd
    )
{
    ULONG      cptfx;
    ULONG      ulPoint;
    POINTFIX * pptfx;

    cptfx = ppd->count;

    switch (m_iRotate)
    {
    case DMDO_90:    
        for (pptfx = ppd->pptfx, ulPoint=0; ulPoint < cptfx; ulPoint++, pptfx++)
        { 
            FIX fxSwap = pptfx->x;

            pptfx->x = LTOFX(m_ScreenHeight-1) - pptfx->y;
            pptfx->y = fxSwap;
        }
        break;
        
    case DMDO_180:    
        for (pptfx = ppd->pptfx, ulPoint=0; ulPoint < cptfx; ulPoint++, pptfx++)
        { 
            pptfx->x = LTOFX(m_ScreenWidth-1) - pptfx->x;
            pptfx->y = LTOFX(m_ScreenHeight-1) - pptfx->y;
            
        }
        break;
        
    case DMDO_270:
        for (pptfx = ppd->pptfx, ulPoint=0; ulPoint < cptfx; ulPoint++, pptfx++)
        { 
            FIX fxSwap = pptfx->x;

            pptfx->x = pptfx->y;
            pptfx->y = LTOFX(m_ScreenWidth-1) - fxSwap;
            
        }
        break;
        
    default:
         break;
    }    
    return;
}

void
GPESurf::RotateRectl(
    RECTL * prcl
    )
{
    RECTL rclSwap = *prcl;

    switch (m_iRotate)
    {
    case DMDO_90:
        prcl->left   = rclSwap.top;
        prcl->right  = rclSwap.bottom;
        prcl->top    = m_ScreenHeight - rclSwap.right;
        prcl->bottom = m_ScreenHeight - rclSwap.left;
        break;
        
    case DMDO_180:
        prcl->left   = m_ScreenWidth  - rclSwap.right;
        prcl->right  = m_ScreenWidth  - rclSwap.left;
        prcl->top    = m_ScreenHeight - rclSwap.bottom;
        prcl->bottom = m_ScreenHeight - rclSwap.top;
        break;
        
    case DMDO_270:
        prcl->left   = m_ScreenWidth - rclSwap.bottom;
        prcl->right  = m_ScreenWidth - rclSwap.top;
        prcl->top    = rclSwap.left;
        prcl->bottom = rclSwap.right;
        break;
        
    default:
         break;
    }
}

void
GPESurf::RotateRectlBack(
    RECTL * prcl
    )
{
    RECTL rclSwap = *prcl;

    switch (m_iRotate)
    {
    case DMDO_90:
        prcl->top    = rclSwap.left;
        prcl->bottom = rclSwap.right;
        prcl->left   = m_ScreenHeight - rclSwap.bottom;
        prcl->right  = m_ScreenHeight - rclSwap.top;
        break;
        
    case DMDO_180:
        prcl->left   = m_ScreenWidth  - rclSwap.right;
        prcl->right  = m_ScreenWidth  - rclSwap.left;
        prcl->top    = m_ScreenHeight - rclSwap.bottom;
        prcl->bottom = m_ScreenHeight - rclSwap.top;
        break;
        
    case DMDO_270:
        prcl->top    = m_ScreenWidth - rclSwap.right;
        prcl->bottom = m_ScreenWidth - rclSwap.left;
        prcl->left   = rclSwap.top;
        prcl->right  = rclSwap.bottom;
        break;
        
    default:
         break;
    }
}

unsigned char *
GPESurf::GetPtr(
    int x,
    int y
    )
{
    unsigned char *ptr = (unsigned char*)m_pVirtAddr;

    int bpp = EGPEFormatToBpp[m_eFormat];

    // Even if this is a 15bpp format, 16 bits are used per pixel.
    if (15 == bpp)
    {
        bpp++;
    }

    switch (m_iRotate)
    {
    case DMDO_90:
        ptr += (m_ScreenHeight -1 - x)*m_nStrideBytes + ((y * bpp) >> 3);
        break;

    case DMDO_180:
        ptr += (m_ScreenHeight - 1 - y)*m_nStrideBytes + (((m_ScreenWidth -1 - x)* bpp) >> 3);
        break;

    case DMDO_270:
        ptr += x * m_nStrideBytes + (((m_ScreenWidth - 1 - y)* bpp) >> 3);
        break;

    case DMDO_0:
        ptr += ((x * bpp) >> 3) + y * m_nStrideBytes;
        break;

    default:
        break;
    }

    return ptr;
}


