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
#include <ctblt.h>
#include <aablt.h>
#include "swemul.h"

#define DISPPERF_DECLARE
#include "dispperf.h"

DEFINE_GDI_ENTRY_POINTS(EMPTYPARM,LEFTENTRY,RIGHTENTRY)

//
// Local functions
//

void
RegisterDDHALAPI(
    void
    );

void
AAGetMaskBits(
    ULONG * pRedMask,
    ULONG * pGreMask,
    ULONG * pBluMask
    );

//
// External Functions
//

extern
int
AllocConverters(
    void
    );

extern
void
FreeConverters(
    void
    );

extern
BOOL
GetGammaValue(
    ULONG * pGamma
    );

extern
BOOL
SetGammaValue(
    ULONG ulGamma,
    BOOL bUpdateReg
    );

//
// External Variables
//

extern BOOL (*pfnDrvGradientFill)(SURFOBJ *, CLIPOBJ *, XLATEOBJ *, TRIVERTEX *, ULONG, PVOID, ULONG, RECTL *, POINTL *, ULONG);
extern BOOL (*pfnDrvAlphaBlend)(SURFOBJ *, SURFOBJ *, CLIPOBJ *, XLATEOBJ *, RECTL *, RECTL *, BLENDOBJ *);

//
// Global Variables
//

GPE*    (*pfnGetGPEPerCard)(int) = NULL;
HMODULE   g_hmodDisplayDll       = NULL;

ULONG g_BilinearMasks[4];
ULONG g_BilinearShifts[4];

const BLENDFUNCTION g_NullBlendFunction = {0, 0, 0xFF, 0};

//
// File Local Variables
//

static BOOL  l_bUseAAText = FALSE;
static BOOL  l_bUseCTText = FALSE;
static ULONG l_ulTextCaps = 0;

static
ULONG g_RGBPalette[] = {
    0x000000FF,
    0x0000FF00,
    0x00FF0000,
    0xFF000000
};

static
ULONG g_BGRPalette[] = {
    0x00FF0000,
    0x0000FF00,
    0x000000FF,
    0xFF000000
};

//
// Dll entry point.
//

EXTERN_C
int
__stdcall
DllMain(
    void *  hmod,
    DWORD dwReason,
    void *  lpvReserved
    )
{
    switch (dwReason)
    {
    case DLL_PROCESS_ATTACH:
#ifdef DEBUG
        RegisterDbgZones( (HINSTANCE)hmod, &dpCurSettings );
#endif
        RegisterDDHALAPI();
        DisableThreadLibraryCalls((HMODULE)hmod);
        g_hmodDisplayDll = (HMODULE)hmod;
        break;
    case DLL_PROCESS_DETACH:
        break;
    case DLL_THREAD_ATTACH:
        break;
    case DLL_THREAD_DETACH:
        break;
    }

    return TRUE;
}

/******************************Public*Data*********************************\
* MIX translation table
*
* Translates a mix 1-16, into an old style Rop 0-255.
*
\**************************************************************************/

BYTE gaMix[] = {
    0xFF,  // R2_WHITE        - Allow rop = gaMix[mix & 0x0F]
    0x00,  // R2_BLACK
    0x05,  // R2_NOTMERGEPEN
    0x0A,  // R2_MASKNOTPEN
    0x0F,  // R2_NOTCOPYPEN
    0x50,  // R2_MASKPENNOT
    0x55,  // R2_NOT
    0x5A,  // R2_XORPEN
    0x5F,  // R2_NOTMASKPEN
    0xA0,  // R2_MASKPEN
    0xA5,  // R2_NOTXORPEN
    0xAA,  // R2_NOP
    0xAF,  // R2_MERGENOTPEN
    0xF0,  // R2_COPYPEN
    0xF5,  // R2_MERGEPENNOT
    0xFA,  // R2_MERGEPEN
    0xFF   // R2_WHITE        - Allow rop = gaMix[mix & 0xFF]
};


#define CLIP_LIMIT 50
typedef struct _CLIPENUM
{
    LONG    c;
    RECTL   arcl[CLIP_LIMIT];   // Space for enumerating complex clipping
} CLIPENUM;                         /* ce, pce */


inline
GPE *
SurfobjToGPE(
    SURFOBJ * pso
    )
{
    return (GPE *)(pso->dhpdev);
}

class TmpGPESurf
{
    GPESurf * m_pGPESurf;
    GPESurf   m_GPESurf;
public:
    operator GPESurf * () { return m_pGPESurf; }
    TmpGPESurf(
        SURFOBJ    * pso1,
        SURFOBJ    * pso2  = (SURFOBJ *)NULL,
        TmpGPESurf * pTmp2 = (TmpGPESurf *)NULL
        );
    ~TmpGPESurf() {}
};

TmpGPESurf::TmpGPESurf(
    SURFOBJ    *pso1,
    SURFOBJ    *pso2,
    TmpGPESurf *pTmp2
    )
{
    if( !pso1 )
    {
        m_pGPESurf = (GPESurf *)NULL;
    }
    else if( pso1 == pso2 )
    {
        m_pGPESurf = pTmp2->m_pGPESurf;
    }
    else if( pso1->dhsurf )
    {
        m_pGPESurf = (GPESurf *)(pso1->dhsurf);
    }
    else
    {
        m_pGPESurf = &m_GPESurf;
        m_pGPESurf->Init( pso1->sizlBitmap.cx, pso1->sizlBitmap.cy,
                          pso1->pvScan0, pso1->lDelta,
                          IFormatToEGPEFormat[pso1->iBitmapFormat] );
    }
}

const DRVENABLEDATA pDrvFn = {
    {   DrvEnablePDEV           },
    {   DrvDisablePDEV          },
    {   DrvEnableSurface        },
    {   DrvDisableSurface       },
    {   DrvCreateDeviceBitmap   },
    {   DrvDeleteDeviceBitmap   },
    {   DrvRealizeBrush         },
    {   DrvStrokePath           },
    {   DrvFillPath             },
    {   DrvPaint                },
    {   DrvBitBlt               },
    {   DrvCopyBits             },
    {   DrvAnyBlt               },
    {   DrvTransparentBlt       },
    {   DrvSetPalette           },
    {   DrvSetPointerShape      },
    {   DrvMovePointer          },
    {   DrvGetModes             },
    {   DrvRealizeColor         },
    {   DrvGetMasks             },
    {   DrvUnrealizeColor       },
    {   DrvContrastControl      },
    {   DrvPowerHandler         },
    {   NULL /* DrvEndDoc    */ },
    {   NULL /* DrvStartDoc  */ },
    {   NULL /* DrvStartPage */ },
    {   DrvEscape               }
};

GPE *
SafeGetGPE(
    HANDLE hDriver
    )
{
    GPE * pGPE = NULL;

    __try
    {
        if ((hDriver != (HANDLE)SINGLE_DRIVER_HANDLE) && (pfnGetGPEPerCard != NULL))
        {
            pGPE = (*pfnGetGPEPerCard)((int)hDriver);
        }
        else
        {
            pGPE = GetGPE();
        }
    }
    __except (EXCEPTION_EXECUTE_HANDLER)
    {
        pGPE = NULL;
    }

    return pGPE;
}

BOOL
APIENTRY
GPEEnableDriver(
    ULONG           iEngineVersion,
    ULONG           cj,
    DRVENABLEDATA * pded,
    PENGCALLBACKS   pEngCallbacks)
{
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvEnableDriver\r\n")));

    BRUSHOBJ_pvAllocRbrush = pEngCallbacks->BRUSHOBJ_pvAllocRbrush;
    BRUSHOBJ_pvGetRbrush   = pEngCallbacks->BRUSHOBJ_pvGetRbrush;
    CLIPOBJ_cEnumStart     = pEngCallbacks->CLIPOBJ_cEnumStart;
    CLIPOBJ_bEnum          = pEngCallbacks->CLIPOBJ_bEnum;
    PALOBJ_cGetColors      = pEngCallbacks->PALOBJ_cGetColors;
    PATHOBJ_vEnumStart     = pEngCallbacks->PATHOBJ_vEnumStart;
    PATHOBJ_bEnum          = pEngCallbacks->PATHOBJ_bEnum;
    PATHOBJ_vGetBounds     = pEngCallbacks->PATHOBJ_vGetBounds;
    XLATEOBJ_cGetPalette   = pEngCallbacks->XLATEOBJ_cGetPalette;
    EngCreateDeviceSurface = pEngCallbacks->EngCreateDeviceSurface;
    EngDeleteSurface       = pEngCallbacks->EngDeleteSurface;
    EngCreateDeviceBitmap  = pEngCallbacks->EngCreateDeviceBitmap;
    EngCreatePalette       = pEngCallbacks->EngCreatePalette;

    if ( iEngineVersion != DDI_DRIVER_VERSION )
    {
        return FALSE;
    }

    if ( cj != sizeof (DRVENABLEDATA) - sizeof (pded->DrvGradientFill) - sizeof (pded->DrvAlphaBlend)
         && cj != sizeof (DRVENABLEDATA) - sizeof (pded->DrvGradientFill)
         && cj != sizeof (DRVENABLEDATA) )
    {
        return FALSE;
    }

    memcpy(pded, &pDrvFn, cj);

    if ( cj == sizeof (DRVENABLEDATA) )
    {
        pded->DrvGradientFill = pfnDrvGradientFill;
        pded->DrvAlphaBlend   = pfnDrvAlphaBlend;
    }
    else if (cj == sizeof (DRVENABLEDATA) - sizeof (pded->DrvGradientFill))
    {
        pded->DrvGradientFill = pfnDrvGradientFill;
    }

    // AATextBltInit returns TRUE if it's not a stub library, and
    // FALSE if it is a stub library.
    l_bUseAAText = AATextBltInit(AAGetMaskBits);

    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvEnableDriver\r\n")));

    return TRUE;
}

BOOL
APIENTRY
DrvContrastControl(
    DHPDEV      dhpdev,
    ULONG       cmd,
    ULONG     * pValue
    )
{
    BOOL   Result = FALSE;
    GPE  * pGPE   = (GPE *)dhpdev;

    if (pGPE)
    {
        pGPE->ContrastControl(cmd, pValue);
    }

    return Result;
}

VOID
APIENTRY
DrvPowerHandler(
    DHPDEV dhpdev,
    BOOL   bOff
    )
{
    GPE *pGPE = (GPE *)dhpdev;

    if (pGPE)
    {
        pGPE->PowerHandler(bOff);
    }
}

ULONG
APIENTRY
DrvEscape(
    DHPDEV    dhpdev,
    SURFOBJ * pso,
    ULONG     iEsc,
    ULONG     cjIn,
    PVOID     pvIn,
    ULONG     cjOut,
    PVOID     pvOut
    )
{
    ULONG   ulResult;
    GPE   * pGPE = (GPE *)dhpdev;

    if (iEsc == QUERYESCSUPPORT)
    {
        if (*(DWORD*)pvIn == DRVESC_GETGAMMAVALUE
            || *(DWORD*)pvIn == DRVESC_SETGAMMAVALUE
            || DispPerfQueryEsc(*(DWORD*)pvIn))
        {
            // The escape is supported.
            ulResult = 1;
        }
        else
        {
            ulResult = pGPE->DrvEscape(pso, iEsc, cjIn, pvIn, cjOut, pvOut);
        }
    }
    else if (iEsc == DRVESC_GETGAMMAVALUE)
    {
        ulResult = GetGammaValue((ULONG *)pvOut);
    }
    else if (iEsc == DRVESC_SETGAMMAVALUE)
    {
        ulResult = SetGammaValue(cjIn, *(BOOL *)pvIn);
    }
    else if (DispPerfQueryEsc(iEsc))
    {
        ulResult = (ULONG)DispPerfDrvEscape(iEsc, cjIn, pvIn, cjOut, pvOut);
    }
    else
    {
        ulResult = pGPE->DrvEscape(pso, iEsc, cjIn, pvIn, cjOut, pvOut);
    }

    return ulResult;
}

VOID
APIENTRY
DrvDisableDriver(
    )
{
    // by the time this is called, the driver has already been shut down.
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvDisableDriver\r\n")));
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvDisableDriver\r\n")));
}

// Configuration / Intialization funtions

VOID
APIENTRY
DrvDisablePDEV(
    DHPDEV dhpdev
    )
{
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvDisablePDEV\r\n")));

    FreeConverters();
    delete ((GPE *)dhpdev);

    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvDisablePDEV\r\n")));

}

VOID
APIENTRY
DrvDisableSurface(
    DHPDEV dhpdev
    )
{
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvDisableSurface\r\n")));

    EngDeleteSurface( (HSURF)(((GPE *)dhpdev)->GetHSurf()) );

    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvDisableSurface\r\n")));
}

HSURF
APIENTRY
DrvEnableSurface(
    DHPDEV dhpdev
    )
{
    HSURF     hsurf;
    SIZEL     sizl;
    GPESurf * pSurf;
    GPE     * pGPE = (GPE *)dhpdev;

    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvEnableSurface\r\n")));

    pSurf   = pGPE->PrimarySurface();
    sizl.cx = pGPE->ScreenWidth();
    sizl.cy = pGPE->ScreenHeight();

    DEBUGMSG(GPE_ZONE_INIT,(TEXT("Primary surface is at 0x%08x\r\n"), pSurf ));
    DEBUGMSG(GPE_ZONE_INIT,(TEXT("Format of primary surface is %d\r\n"),pSurf->Format() ));
    
    hsurf = EngCreateDeviceSurface(
                (DHSURF)pSurf,
                sizl,
                EGPEFormatToIFormat[pSurf->Format()]);
    
    pGPE->SetHSurf( (unsigned long)hsurf );

    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvEnableSurface\r\n")));

    return hsurf;
}

// Surface creation

HBITMAP
APIENTRY
DrvCreateDeviceBitmap(
    DHPDEV dhpdev,
    SIZEL  sizl,
    ULONG  iFormat
    )
{
    GPESurf * pSurf;
    GPE     * pGPE   = (GPE *)dhpdev;
    HBITMAP   Bitmap;

    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvCreateDeviceBitmap\r\n")));

    if( FAILED ( pGPE->AllocSurface(
                           &pSurf,
                           sizl.cx,
                           sizl.cy,
                           IFormatToEGPEFormat[iFormat],
                           GPE_PREFER_VIDEO_MEMORY ) ) )
    {
        DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvEnableSurface\r\n")));

        return (HBITMAP)0xFFFFFFFF;
    }

    Bitmap = EngCreateDeviceBitmap(
                 (DHSURF)pSurf,
                 sizl,
                 iFormat );

    if (!Bitmap)
    {
        Bitmap = (HBITMAP)0xFFFFFFFF;
    }

    pSurf->m_nHandle = (unsigned long)Bitmap;

    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvEnableSurface\r\n")));

    return Bitmap;
}

VOID
APIENTRY
DrvDeleteDeviceBitmap(
    DHSURF dhsurf
    )
{
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvDeleteDeviceBitmap\r\n")));

    GPESurf * pSurf = (GPESurf *)dhsurf;
    HBITMAP   hbm   = (HBITMAP)(pSurf->m_nHandle);

    EngDeleteSurface( (HSURF)hbm );
    delete pSurf;

    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvDeleteDeviceBitmap\r\n")));
}

// Cursor control functions

VOID
APIENTRY
DrvMovePointer(
    SURFOBJ *pso,
    LONG x,
    LONG y,
    RECTL *prcl
    )
{
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvMovePointer\r\n")));

    SurfobjToGPE(pso)->MovePointer(x,y);

    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvMovePointer\r\n")));
}

ULONG
APIENTRY
DrvSetPointerShape(
    SURFOBJ  * pso,
    SURFOBJ  * psoMask,
    SURFOBJ  * psoColor,
    XLATEOBJ * pxlo,
    LONG       xHot,
    LONG       yHot,
    LONG       x,
    LONG       y,
    RECTL    * prcl,
    FLONG      fl
    )
{
    // dpCurSettings.ulZoneMask = 0x0000ffff;
    
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvSetPointerShape\r\n")));

    TmpGPESurf   pMask(psoMask);
    TmpGPESurf   pColor(psoColor);
    GPE        * pGPE = SurfobjToGPE(pso);

    if( !pGPE )
    {
        DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvSetPointerShape\r\n")));

        return SPS_ERROR;
    }

    if( FAILED( pGPE->SetPointerShape(
                          pMask,
                          pColor,
                          xHot,
                          yHot,
                          psoMask?(psoMask->sizlBitmap.cx):0,
                          psoMask?(psoMask->sizlBitmap.cy>>1):0 ) ) )
    {
        DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvSetPointerShape\r\n")));

        return SPS_ERROR;
    }

    if ((x>0) && (y>0) || (x == -1) || (y == -1))
    {
        pGPE->MovePointer(x,y);
    }
    
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvSetPointerShape\r\n")));

    return SPS_ACCEPT_NOEXCLUDE;    // It is up to GPE to avoid cursor interference
}

// Palette Control Functions

BOOL
APIENTRY
DrvSetPalette(
    DHPDEV   dhpdev,
    PALOBJ * ppalo,
    FLONG    fl,
    ULONG    iStart,
    ULONG    cColors
    )
{
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvSetPalette\r\n")));

    unsigned long Colors[256];

    if( cColors > 256 )
    {
        return FALSE;
    }

    cColors = PALOBJ_cGetColors( ppalo, iStart, cColors, Colors );

    if( !cColors ||
        FAILED( ( (GPE *)dhpdev )->SetPalette(
                                       (PALETTEENTRY *)Colors,
                                       (unsigned short)iStart,
                                       (unsigned short)cColors ) ) )
    {
        DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvSetPalette\r\n")));

        return FALSE;
    }

    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvSetPalette\r\n")));

    return TRUE;
}

// Drawing functions

BOOL
APIENTRY
DrvFillPath(
    SURFOBJ  * pso,
    PATHOBJ  * ppo,
    CLIPOBJ  * pco,
    BRUSHOBJ * pbo,
    POINTL   * pptlBrushOrg,
    MIX        mix,
    FLONG      flOptions    // Simply winding mode - we ignore for now.
    )
{
#ifdef DEBUG
    if( (GPE_ZONE_POLY) && !(GPE_ZONE_BLT_HI) )
    {
           ulong oldSettings = dpCurSettings.ulZoneMask;
        dpCurSettings.ulZoneMask |= 0x0034;    // enter, exit & blt hi and lo
        BOOL v = DrvFillPath(pso,ppo,pco,pbo,pptlBrushOrg,mix,flOptions);
        dpCurSettings.ulZoneMask = oldSettings;
        return v;
    }
#endif

    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvFillPath\r\n")));
    EdgeList      edgeList( ppo->cCurves );
    PATHDATA      pd;
    ULONG         cptfx;
    SCODE         sc1;
    SCODE         sc2;
    RECTL       * prclCurr;
    GPEBltParms   parms;
    int           bMore;
    int           moreClipLists;
    int           i;
    BOOL          bFailed;

    // FIX xFirst, yFirst, xLast, yLast;
    POINTFIX firstPoint;
    POINTFIX lastPoint;

    // Set up Blt parameters for GPEPolygon::Fill to use
    TmpGPESurf   pDst(pso);
    GPE        * pGPE = SurfobjToGPE(pso);

    sc1     = 0;
    bFailed = false;

    // We don't support overlapped brush and dest or mirror fills.
    parms.pDst          = pDst;
    parms.pSrc          = (GPESurf *)NULL;
    parms.pMask         = (GPESurf *)NULL;
    parms.prclDst       = (RECTL *)NULL;
    parms.prclMask      = (RECTL *)NULL;
    parms.prclClip      = (RECTL *)NULL;
    parms.xPositive     = 1;
    parms.yPositive     = 1;
    parms.pptlBrush     = pptlBrushOrg;
    parms.bltFlags      = 0;
    parms.rop4          = (((ROP4)gaMix[(mix>>8)&0x0f])<<8) | gaMix[mix&0x0f];    // mix -> rop4
    parms.pBrush        = (GPESurf *)NULL;
    parms.pLookup       = (unsigned long *)NULL;
    parms.pConvert      = NULL;
    parms.solidColor    = pbo->iSolidColor;
    parms.iMode         = 0;
    parms.blendFunction = g_NullBlendFunction;

    if( pbo )
    {
        if( pbo->iSolidColor == 0xffffffff )
        {
            if( pbo->pvRbrush == NULL )
            {
                parms.pBrush = (GPESurf *)( BRUSHOBJ_pvGetRbrush( pbo ) );
            }
            else
            {
                parms.pBrush = (GPESurf *)( pbo->pvRbrush );
            }

            // If the brush matters, and it's still NULL, fail the blt.
            if (parms.pBrush == NULL)
            {
                DEBUGMSG(GPE_ZONE_ERROR,(TEXT("Failed to allocate brush\r\n")));
                DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvFillPath\r\n")));

                return FALSE;
            }
        }
    }

    if( FAILED( pGPE->BltPrepare( &parms ) ) )
    {
        DEBUGMSG(GPE_ZONE_ERROR,(TEXT("Failed to prepare blt for fillpoly operations\r\n")));
        DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvFillPath\r\n")));

        return FALSE;
    }
    
    // Create GPEPolygon(s) for the path
    PATHOBJ_vEnumStart(ppo);

    do
    {
        bMore = PATHOBJ_bEnum( ppo, &pd );
        cptfx = pd.count;

        if( !cptfx )
        {
            break;
        }

        if( pd.flags & PD_BEGINSUBPATH )
        {
            // Start a new subpath - just remember the first point
            firstPoint = pd.pptfx[0];
        }
        else
        {
            // Continue old subpath
            if FAILED(edgeList.AddEdge( lastPoint.x, lastPoint.y, pd.pptfx[0].x, pd.pptfx[0].y ))
            {
                bMore=false;
                bFailed=true;
            }
        }

        for( i=0; i<((int)cptfx)-1; i++ )
        {
            if FAILED(edgeList.AddEdge( pd.pptfx[i].x, pd.pptfx[i].y, pd.pptfx[i+1].x, pd.pptfx[i+1].y ))
            {
                bMore=false;         //The reason we don't return an error immediately is that
                bFailed=true;        //we used to draw a partial path. For BC we will continue to.
            }
        }

        if( pd.flags & PD_ENDSUBPATH )
        {
            // close the subpath
            if FAILED(edgeList.AddEdge( pd.pptfx[i].x, pd.pptfx[i].y, firstPoint.x, firstPoint.y ))
            {
                bMore=false;
                bFailed=true;
            }
        }
        else
        {
            // continue this subpath with next enumeration
            lastPoint = pd.pptfx[i];
        }
    } while(bMore);

    // Now, loop through the cliprect(s), calling GPEPolygon::Fill (via GPEPolygonList)

    if( ( pco == NULL ) || ( pco->iDComplexity == DC_TRIVIAL ) )
    {
        DEBUGMSG(GPE_ZONE_POLY,(TEXT("Calling PolygonList::Fill() with no clipping\r\n")));
        sc1 = edgeList.Fill( &parms, (RECTL *)NULL, pGPE);
    }
    else if( pco->iDComplexity == DC_RECT )
    {
        DEBUGMSG(GPE_ZONE_POLY,(TEXT("Calling PolygonList::Fill() with single cliprect\r\n")));
        sc1 = edgeList.Fill( &parms, &pco->rclBounds, pGPE );
    }
    else
    {
        DEBUGMSG(GPE_ZONE_POLY,(TEXT("Iterating through complex clipping for fillpoly\r\n")));
        
        CLIPENUM ce;
        for( ce.c = 0, moreClipLists=1, prclCurr = ce.arcl; ce.c || moreClipLists; )    // <- Note , & ;
        {
            if( ce.c == 0 )
            {
                // Get next list of cliprects from clipobj
                DEBUGMSG(GPE_ZONE_POLY,(TEXT("Calling CLIPOBJ_bEnum\r\n")));
                moreClipLists = CLIPOBJ_bEnum( pco, sizeof(ce), (ULONG *)&ce );
                prclCurr = ce.arcl;
                if( !ce.c )        // empty list !?
                    continue;
            }
            ce.c--;

            DEBUGMSG(GPE_ZONE_POLY,(TEXT("Calling PolygonList::Fill() with complex cliprect\r\n")));

            if( FAILED(sc1 = edgeList.Fill( &parms, prclCurr++, pGPE ) ) )
            {
                break;
            }
        }
    }

    sc2 = pGPE->BltComplete( &parms );

    return ((!FAILED(sc1)) && (!FAILED(sc2)) && (!bFailed));

}

BOOL
APIENTRY
DrvRealizeBrush(
    BRUSHOBJ * pbo,
    SURFOBJ  * psoTarget,
    SURFOBJ  * psoPattern,
    SURFOBJ  * psoMask,
    XLATEOBJ * pxlo,
    ULONG      iHatch
    )
{
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvRealizeBrush\r\n")));

    TmpGPESurf      tpSrc(psoPattern);
    TmpGPESurf      tpTrg(psoTarget,psoPattern,&tpSrc);
    GPESurf       * pSrc = tpSrc;
    GPESurf       * pTrg = tpTrg;
    GPESurf       * pDst;
    void          * pBits;
    unsigned long   stride;
    EGPEFormat      patFormat        = (pTrg->Format() == gpe24Bpp) ? gpe32Bpp : pTrg->Format();
    int             temporaryPattern = (( pSrc->Format() != patFormat ) || (pxlo->flXlate != XO_TRIVIAL ) );
    ULONG         * pPalette         = NULL;

    // If the Target is 24Bpp, we convert the brush to 32Bpp because the EmulatedBlt routine
    // doesn't handle 24Bpp patterns (they cross 32-bit boundaries and this requires
    // extra code)

    // If the pattern and target have different formats, we need to create a GPESurf to
    // contain the pattern but since GDI destroys the brush without notifying the driver,
    // the bits associated with the pattern surface must be in the same memory allocation
    // to avoid memory leaks.

    int memoryRequired = sizeof(GPESurf);

    if( temporaryPattern )
    {
        stride = ((( pSrc->Width() * EGPEFormatToBpp[patFormat] + 7 ) / 8 + 3 )
                  & 0xfffffffc );
        memoryRequired += stride * pSrc->Height();

        if (pxlo && XO_TRIVIAL != pxlo->flXlate
            && (pxlo->iDstType != PAL_BGR && pxlo->iDstType != PAL_RGB))
        {
            memoryRequired += XLATEOBJ_cGetPalette(pxlo, XO_DESTPALETTE, 0, NULL) * sizeof (ULONG);
        }
    }
    else
    {
        stride = pSrc->Stride();
    }

    pDst = (GPESurf *)BRUSHOBJ_pvAllocRbrush( pbo, memoryRequired );

    if( !pDst )
    {
        return FALSE;    // memory allocation failed
    }
        
    if( temporaryPattern )
    {
        pBits    = (void *)((unsigned long)(((unsigned char *)pDst)+sizeof(GPESurf)+3)&0xfffffffc);
        pPalette = (ULONG *)(((unsigned char *)pBits) + stride * pSrc->Height());
    }
    else
    {
        pBits = pSrc->Buffer();
    }

    pDst->Init( pSrc->Width(), pSrc->Height(), pBits, stride, patFormat );

    if( temporaryPattern )
    {
        GPEBltParms parms;

        // Create a color converter to handle depth changes

        ColorConverter::InitConverter(
                            pxlo,
                            &parms.pColorConverter,
                            &parms.pConvert,
                            &parms.pLookup );

        if (pxlo && XO_TRIVIAL != pxlo->flXlate)
        {
            ULONG   Count;
            BOOL    OwnsBuffer = FALSE;

            GPESurf   * pSurf   = NULL;
            GPEFormat * pFormat = NULL;

            // Set up the destination format information.
            pSurf   = pDst;
            pFormat = pSurf->FormatPtr();

            // Only query the palette if our palette isn't NULL.
            // This works because we're really interested in the case where
            // the palette is actually masks.
            if (pFormat->m_pPalette == NULL)
            {
                if (pxlo->iDstType == PAL_BGR)
                {
                    Count   = ((pSurf->Format() == gpe32Bpp) ? 4 : 3);
                    pPalette = g_BGRPalette;
                }
                else if (pxlo->iDstType == PAL_RGB)
                {
                    Count   = ((pSurf->Format() == gpe32Bpp) ? 4 : 3);
                    pPalette = g_RGBPalette;
                }
                else
                {
                    // Either we have bitfields, or a real palette.

                    Count = XLATEOBJ_cGetPalette(pxlo, XO_DESTPALETTE, 0, NULL);

                    if (!Count)
                    {
                        pPalette = NULL;
                    }

                    if (pPalette)
                    {
                        // The realize brush doesn't own a buffer, GDI free's the memory
                        // automatically when the brush is destroyed.
                        Count = XLATEOBJ_cGetPalette(pxlo, XO_DESTPALETTE, Count, pPalette);
                    }
                }

                pFormat->m_PaletteEntries = Count;
                pFormat->m_OwnsPalette    = OwnsBuffer;
                pFormat->m_pPalette       = pPalette;
            }

            // Set up the source format information.
            pPalette   = NULL;
            OwnsBuffer = FALSE;
            pSurf      = pSrc;
            pFormat    = pSurf->FormatPtr();

            // Only query the palette if our palette isn't NULL.
            // This works because we're really interested in the case where
            // the palette is actually masks.
            if (pFormat->m_pPalette == NULL)
            {
                if (XO_TABLE == pxlo->flXlate)
                {
                    // Do nothing, the lookup table will translate source
                    // palette entries to destination palette entries.
                }
                else if (XO_TO_MONO == pxlo->flXlate)
                {
                    // Do nothing, the destination format will handle this.
                }
                else if (pxlo->iSrcType == PAL_BGR)
                {
                    Count   = ((pSurf->Format() == gpe32Bpp) ? 4 : 3);
                    pPalette = g_BGRPalette;
                }
                else if (pxlo->iSrcType == PAL_RGB)
                {
                    Count   = ((pSurf->Format() == gpe32Bpp) ? 4 : 3);
                    pPalette = g_RGBPalette;
                }
                else
                {
                    // Either we have bitfields, or a real palette.

                    Count = XLATEOBJ_cGetPalette(pxlo, XO_SRCPALETTE, 0, NULL);

                    if (Count)
                    {
                        pPalette = new ULONG [Count];
                    }

                    if (pPalette)
                    {
                        OwnsBuffer = TRUE;
                        Count      = XLATEOBJ_cGetPalette(pxlo, XO_SRCPALETTE, Count, pPalette);
                    }
                }

                pFormat->m_PaletteEntries = Count;
                pFormat->m_OwnsPalette    = OwnsBuffer;
                pFormat->m_pPalette       = pPalette;
            }
        }

        // Blt the bits to the temporary pattern buffer

        RECTL rcl;
        rcl.top    = 0;
        rcl.bottom = pSrc->Height();
        rcl.left   = 0;
        rcl.right  = pSrc->Width();

        parms.pDst          = pDst;
        parms.pSrc          = pSrc;
        parms.pMask         = (GPESurf *)NULL;
        parms.pBrush        = (GPESurf *)NULL;
        parms.prclDst       = &rcl;
        parms.prclSrc       = &rcl;
        parms.prclClip      = (RECTL *)NULL;
        parms.solidColor    = 0xffffffff;
        parms.bltFlags      = 0;
        parms.rop4          = 0xCCCC;
        parms.prclMask      = (RECTL *)NULL;
        parms.pptlBrush     = (POINTL *)NULL;
        parms.xPositive     = 1;
        parms.yPositive     = 1;
        parms.iMode         = 0;
        parms.blendFunction = g_NullBlendFunction;

        SurfobjToGPE(psoTarget)->EmulatedBlt( &parms );
    }

    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvRealizeBrush\r\n")));

    return TRUE;
}



typedef struct _DRVDEVMODEW
{
    DEVMODEW        devmodew;       // DDI definition of mode
    GPEMode         gpeMode;        // GPE definition of mode
} DRVDEVMODEW;



ULONG
APIENTRY
DrvGetModes(
    HANDLE     hDriver,
    ULONG      cjSize,
    DEVMODEW * pdm
    )
{
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvGetModes\r\n")));

    GPE *pGPE = SafeGetGPE(hDriver);
    if (!pGPE)
    {
        return 0;
    }
        
    int           numModes  = pGPE->NumModes();
    ULONG         bytesReqd = numModes * sizeof(DRVDEVMODEW);
    DRVDEVMODEW * pMode     = (DRVDEVMODEW *)pdm;
    GPEMode     * pGPEMode;
    int           modeNo;

    if( !pdm )
    {
        // GDI is asking how much memory is required for the entire mode list
        DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvGetModes\r\n")));

        return bytesReqd;
    }

    if( cjSize != bytesReqd )
    {
        DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvGetModes\r\n")));

        return 0;       // In this DDI, we insist that GDI gives 0 or sizeof(modelist)
    }

    memset( pMode, 0, cjSize );

    for( modeNo = 0; modeNo < numModes; modeNo++, pMode++ )
    {
        pGPEMode = &(pMode->gpeMode);
        pGPE->GetModeInfo( pGPEMode, modeNo );
        memcpy( &(pMode->devmodew.dmDeviceName), TEXT("GPE"), 8 );

        pMode->devmodew.dmSize             = sizeof(DEVMODEW);
        pMode->devmodew.dmDriverExtra      = sizeof(GPEMode);
        pMode->devmodew.dmFields           = ( DM_BITSPERPEL | DM_PELSWIDTH | DM_PELSHEIGHT |
                                               DM_DISPLAYFREQUENCY | DM_DISPLAYFLAGS );
        pMode->devmodew.dmBitsPerPel       = pGPEMode->Bpp;
        pMode->devmodew.dmPelsWidth        = pGPEMode->width;
        pMode->devmodew.dmPelsHeight       = pGPEMode->height;
        pMode->devmodew.dmDisplayFrequency = pGPEMode->frequency;
    }

    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvGetModes\r\n")));

    return cjSize;
}

DHPDEV
APIENTRY
DrvEnablePDEV(
    DEVMODEW * pdm,
    LPWSTR     pwszLogAddress,
    ULONG      cPat,
    HSURF    * phsurfPatterns,
    ULONG      cjCaps,
    ULONG    * pdevcaps,
    ULONG      cjDevInfo,
    DEVINFO  * pdi,
    HDEV       hdev,
    LPWSTR     pwszDeviceName,
    HANDLE     hDriver
    )
{
    // Make bFirstCall static to allow this func to be called more than once
    static BOOL bFirstCall = TRUE;

    BOOL bInitClearType = FALSE;

    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvEnablePDEV\r\n")));

    GPE *pGPE = SafeGetGPE(hDriver);

    if( pGPE == NULL )
    { 
        DEBUGMSG(GPE_ZONE_ERROR,(TEXT("ERROR: Failed to instantiate GPE object\r\n")));
        DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvEnablePDEV\r\n")));
        return (DHPDEV)NULL;
    }

    // Only initialize display driver once.  This may be called again by
    // printer drivers that leave most of the rendering to GPE.
    if (bFirstCall)
    {
        if( !AllocConverters() )
        {
            DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Failed Allocate color converters! Leaving DrvEnablePDEV\r\n")));
            return (DHPDEV)NULL;
        }

        // The ClearType library needs to be initialized.
        bInitClearType = TRUE;

        // Make sure we don't execute this code more than once.
        bFirstCall = FALSE;
    }

    if (pdm->dmDriverExtra == sizeof(GPEMode) && pdi)  //if gpemode, means it's display driver, so set the mode.
    {
        if( FAILED( pGPE->SetMode( ((DRVDEVMODEW *)pdm)->gpeMode.modeId,
                &(pdi->hpalDefault) ) ) )
        {
             DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Failed to set mode! Leaving DrvEnablePDEV\r\n")));
             return (DHPDEV)NULL;
        }

        // GeneratedBlts needs to be notified when the format of the primary
        // changes.
        GenBltSetMode(pGPE->PrimarySurface()->Format(), DrvGetMasks((DHPDEV)pGPE));
    }

    // Get the properties of the physical screen.
    GPEScreenProps props;

    if (!pGPE->GetScreenDimensions(&props))
    {
        // If this failed, provide some defaults.
        props.ulHorzSize   = 64;
        props.ulVertSize   = 60;
        props.ulLogPixelsX = 96;
        props.ulLogPixelsY = 96;
        props.ulAspectX    = 1;
        props.ulAspectY    = 1;
        props.ulAspectXY   = 1;
    }
    
    GDIINFO *pgdiinfo = (GDIINFO *)pdevcaps;

    pgdiinfo->ulVersion     = DDI_DRIVER_VERSION;
    pgdiinfo->ulTechnology  = DT_RASDISPLAY;
    pgdiinfo->ulHorzSize    = props.ulHorzSize;
    pgdiinfo->ulVertSize    = props.ulVertSize;
    pgdiinfo->ulHorzRes     = pdm->dmPelsWidth;
    pgdiinfo->ulVertRes     = pdm->dmPelsHeight;
    pgdiinfo->ulLogPixelsX  = props.ulLogPixelsX;
    pgdiinfo->ulLogPixelsY  = props.ulLogPixelsY;
    pgdiinfo->cBitsPixel    = pdm->dmBitsPerPel;
    pgdiinfo->cPlanes       = 1;
    pgdiinfo->ulNumColors   = 1 << pdm->dmBitsPerPel;
    pgdiinfo->ulAspectX     = props.ulAspectX;
    pgdiinfo->ulAspectY     = props.ulAspectY;
    pgdiinfo->ulAspectXY    = props.ulAspectXY;
    pgdiinfo->flRaster      = RC_BITBLT
                              | RC_STRETCHBLT | RC_STRETCHDIB
                              | ((pGPE->IsPaletteSettable())?RC_PALETTE:0);
    pgdiinfo->flShadeBlendCaps = 0;

    // If we support DrvAlphaBlend, set the appropriate caps bits.
    if (NULL != pfnDrvAlphaBlend)
    {
        pgdiinfo->flShadeBlendCaps |= SB_CONST_ALPHA | SB_PIXEL_ALPHA | SB_PREMULT_ALPHA;
    }

    // If we support DrvGradientFill, set the appropriate caps bits.
    if (NULL != pfnDrvGradientFill)
    {
        pgdiinfo->flShadeBlendCaps |= SB_GRAD_RECT;
    }

    if (bInitClearType && pdi)
    {
        GPEMode          gpeMode;
        LPPALETTEENTRY   pPalette  = NULL;
        ULONG          * pBitMasks = pGPE->GetClearTypeRGBMasks();
        unsigned short   cEntries  = 0;

        pGPE->GetModeInfo(&gpeMode, pGPE->GetModeId());

        pGPE->GetPalette(&pPalette, &cEntries);

        // ClearTypeBltInit returns TRUE if it isn't a stub library,
        // and FALSE if it is a stub library.
        l_bUseCTText = ClearTypeBltInit(&gpeMode, pBitMasks, pPalette, cEntries);
    }

    if (pdm->dmBitsPerPel > 8)
    {
        if (l_bUseAAText)
        {
            l_ulTextCaps = GCAPS_GRAY16;
        }
    }
    if (pdm->dmBitsPerPel >= 8)
    {
        if (l_bUseCTText)
        {
            l_ulTextCaps |= GCAPS_CLEARTYPE;
        }
    }

    // DEVINFO Graphics capabilities beyond normal uDDI caps; eg, grayscale text output
    pgdiinfo->flTextCaps = (pGPE->GetGraphicsCaps() | l_ulTextCaps) & GCAPS_TEXT_CAPS;

    if (pdi)
    {
        pdi->flGraphicsCaps = pGPE->GetGraphicsCaps() | l_ulTextCaps;
    }

    DEBUGMSG(1,(TEXT("Bits-per-pixel: %d\r\n"), pgdiinfo->cBitsPixel ));

    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvEnablePDEV\r\n")));

    return (DHPDEV)pGPE;
}                    

//  BLT Functions

// All exposed Drv Blt functions are translated into a call to
// AnyBlt directly or indirectly:

BOOL
APIENTRY
DrvPaint(
    SURFOBJ*  pso,
    CLIPOBJ*  pco,
    BRUSHOBJ* pbo,
    POINTL*   pptlBrush,
    MIX       mix
    )
{
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvPaint\r\n")));
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("DrvPaint (mix=0x%04x)\r\n"), mix));

    BOOL rc;
    ROP4 rop4;

    rop4 = (((ROP4)gaMix[(mix >> 8)&0xf]) << 8) | gaMix[mix & 0xf];

    // Since our DrvFillPath routine handles almost all fills, DrvPaint
    // won't get called all that much (mainly via PaintRgn, FillRgn, or
    // complex clipped polygons).  As such, we save some code and simply
    // allow DrvBitBlt to handle it:

    rc = DrvBitBlt(
             pso,
             NULL,
             NULL,
             pco,
             NULL,
             &pco->rclBounds,
             NULL,
             NULL,
             pbo,
             pptlBrush,
             rop4 );

    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvPaint\r\n")));

    return rc;
}

BOOL
APIENTRY
DrvCopyBits(
    SURFOBJ  * psoDest,
    SURFOBJ  * psoSrc,
    CLIPOBJ  * pco,
    XLATEOBJ * pxlo,
    RECTL    * prclDest,
    POINTL   * pptlSrc
    )
{
    DEBUGMSG(GPE_ZONE_ERROR,(TEXT("Entering DrvCopyBits! - SHOULD ONLY BE USED BY PRINTER DRIVER \r\n")));

    ASSERT(0);

    return FALSE;
}

BOOL
APIENTRY
DrvAnyBlt(
    SURFOBJ         * psoDest,
    SURFOBJ         * psoSrc,
    SURFOBJ         * psoMask,
    CLIPOBJ         * pco,
    XLATEOBJ        * pxlo,
    POINTL          * pptlHTOrg,         // Halftone brush origin
    RECTL           * prclDest,
    RECTL           * prclSrc,
    POINTL          * pptlMask,
    BRUSHOBJ        * pbo,
    POINTL          * pptlBrush,
    ROP4              rop4,
    ULONG             iMode,             // DrvStretchBlt iMode: eg, COLORONCOLOR, HALFTONE
    ULONG              bltFlags
    )
{
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvAnyBlt\r\n")));

    if (iMode == BILINEAR && pxlo)
    {
        g_BilinearShifts[0] = 0;
        g_BilinearShifts[1] = 0;
        g_BilinearShifts[2] = 0;
        g_BilinearShifts[3] = 0;
        g_BilinearMasks[0]  = 0;
        g_BilinearMasks[1]  = 0;
        g_BilinearMasks[2]  = 0;
        g_BilinearMasks[3]  = 0;

        switch (psoDest->iBitmapFormat)
        {
        case BMF_16BPP:
        case BMF_24BPP:
        case BMF_32BPP:
            if (pxlo->iDstType == PAL_BGR)
            {
                g_BilinearMasks[0]  = 0x00ff0000;
                g_BilinearMasks[1]  = 0x0000ff00;
                g_BilinearMasks[2]  = 0x000000ff;
                g_BilinearShifts[0] = 16;
                g_BilinearShifts[1] = 8;
                g_BilinearShifts[2] = 0;
            }
            else if (pxlo->iDstType == PAL_RGB)
            {
                g_BilinearMasks[0]  = 0x000000ff;
                g_BilinearMasks[1]  = 0x0000ff00;
                g_BilinearMasks[2]  = 0x00ff0000;
                g_BilinearShifts[0] = 0;
                g_BilinearShifts[1] = 8;
                g_BilinearShifts[2] = 16;
            }
            else if (pxlo->iDstType == PAL_BITFIELDS)
            {
                if (XLATEOBJ_cGetPalette(pxlo, XO_DESTPALETTE, 0, NULL) <= 4)
                {
                    ULONG Count;

                    Count = XLATEOBJ_cGetPalette(pxlo, XO_DESTPALETTE, 4, g_BilinearMasks);

                    for (ULONG i = 0; i < Count; i++)
                    {
                        ULONG Mask = g_BilinearMasks[i];
                        ULONG bit;

                        for (bit = 0; !(Mask & 1); bit++)
                        {
                            Mask >>= 1;
                        }

                        g_BilinearShifts[i] = bit;
                    }
                }
            }
        break;
        }
    }

    BOOL Result = AnyBlt(
                      psoDest,
                      psoSrc,
                      psoMask,
                      pco,
                      pxlo,
                      prclDest,
                      prclSrc,
                      pptlMask,
                      pbo,
                      pptlBrush,
                      rop4,
                      bltFlags,
                      iMode,
                      g_NullBlendFunction);

    g_BilinearShifts[0] = 0;
    g_BilinearShifts[1] = 0;
    g_BilinearShifts[2] = 0;
    g_BilinearShifts[3] = 0;
    g_BilinearMasks[0]  = 0;
    g_BilinearMasks[1]  = 0;
    g_BilinearMasks[2]  = 0;
    g_BilinearMasks[3]  = 0;

    return Result;
}

BOOL
APIENTRY
DrvTransparentBlt(
    SURFOBJ         * psoDest,
    SURFOBJ         * psoSrc,
    CLIPOBJ         * pco,
    XLATEOBJ        * pxlo,
    RECTL           * prclDest,
    RECTL           * prclSrc,
    ULONG             TransColor
    )
{
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvTransparentBlt\r\n")));

    BRUSHOBJ      bo;
    unsigned long bltFlags = BLT_TRANSPARENT;
    int           iMode    = BLACKONWHITE;

    bo.iSolidColor = TransColor;

    return AnyBlt(
               psoDest,
               psoSrc,
               NULL,
               pco,
               pxlo,
               prclDest,
               prclSrc,
               NULL,
               &bo,
               (POINTL *)NULL,
               0xCCCC,
               bltFlags,
               iMode,
               g_NullBlendFunction);
}

BOOL
APIENTRY
DrvBitBlt(
    SURFOBJ  * psoTrg,
    SURFOBJ  * psoSrc,
    SURFOBJ  * psoMask,
    CLIPOBJ  * pco,
    XLATEOBJ * pxlo,
    RECTL    * prclTrg,
    POINTL   * pptlSrc,
    POINTL   * pptlMask,
    BRUSHOBJ * pbo,
    POINTL   * pptlBrush,
    ROP4       rop4
    )
{
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Entering DrvBitBlt\r\n")));

    RECTL rclSrc;

    if( pptlSrc )
    {
        rclSrc.top  = pptlSrc->y;
        rclSrc.left = pptlSrc->x;
    }
    else
    {
        rclSrc.top  = 0;
        rclSrc.left = 0;
    }

    rclSrc.bottom = rclSrc.top + prclTrg->bottom - prclTrg->top;
    rclSrc.right  = rclSrc.left + prclTrg->right - prclTrg->left;

    return AnyBlt(
               psoTrg,
               psoSrc,
               psoMask,
               pco,
               pxlo,
               prclTrg,
               &rclSrc,
               pptlMask,
               pbo,
               pptlBrush,
               rop4,
               0,
               BLACKONWHITE,
               g_NullBlendFunction);
}

SCODE
ClipBlt(
    GPE         * pGPE,
    GPEBltParms * pBltParms
    );

// The AnyBlt function can handle any stretching, color translation, masking, etc
// and services all of the other DrvBlt style functions

BOOL
APIENTRY
AnyBlt(
    SURFOBJ       * psoTrg,
    SURFOBJ       * psoSrc,
    SURFOBJ       * psoMask,
    CLIPOBJ       * pco,
    XLATEOBJ      * pxlo,
    RECTL         * prclTrg,
    RECTL         * prclSrc,
    POINTL        * pptlMask,
    BRUSHOBJ      * pbo,
    POINTL        * pptlBrush,
    ROP4            rop4,
    unsigned long   bltFlags,
    int             iMode,
    BLENDFUNCTION   blendFunction
    )
{
    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("AnyBlt (rop4 = 0x%04x) rclTrg=t:%d,l:%d,b:%d,r:%d\r\n"),
        rop4, prclTrg->top, prclTrg->left, prclTrg->bottom, prclTrg->right ));

    GPE*     pGPE          = SurfobjToGPE(psoTrg);
    RECTL*   prclCurr;
    GPESurf* pSurf         = NULL;
    RECTL    rclSrcCopy;
    RECTL    rclMask;
    int      moreClipLists;
    SCODE    sc1           = 0;
    SCODE    sc2;

    // Declare temporary GPE objects.
    GPEBltParms parms;
    TmpGPESurf  pDst(psoTrg);
    TmpGPESurf  pSrc(psoSrc, psoTrg, &pDst);
    TmpGPESurf  pMask(psoMask);

    // See if source matters
    if( ( rop4 ^ ( rop4 >> 2 ) ) & 0x3333 )
    {
        parms.prclSrc = prclSrc;
        parms.pSrc    = pSrc;

        if( !prclSrc || !prclTrg )
        {
            return 0;
        }

        if (prclTrg->right - prclTrg->left != prclSrc->right - prclSrc->left
            || prclTrg->bottom - prclTrg->top != prclSrc->bottom - prclSrc->top)
        {
            bltFlags |= BLT_STRETCH;
        }
    }
    else
    {
        parms.prclSrc = (RECTL *)NULL;
        parms.pSrc    = (GPESurf *)NULL;

        // Check to see if the destination is well ordered.
        if (bltFlags & BLT_STRETCH)
        {
            if (prclTrg->right < prclTrg->left)
            {
                long swap      = prclTrg->right;
                prclTrg->right = prclTrg->left;
                prclTrg->left  = swap;
            }

            if (prclTrg->bottom < prclTrg->top)
            {
                long swap       = prclTrg->bottom;
                prclTrg->bottom = prclTrg->top;
                prclTrg->top    = swap;
            }

            bltFlags &= ~BLT_STRETCH;
        }
    }

    // Always set the Format masks so that GenerateBlts can use them for
    // color conversion.
    if (pxlo && pSrc)
    {
        ULONG   Count;
        ULONG * Palette    = NULL;
        BOOL    OwnsBuffer = FALSE;

        pSurf = (GPESurf *)pDst;

        GPEFormat * pFormat = pSurf->FormatPtr();

        // Only query the palette if our palette isn't NULL.
        // This works because we're really interested in the case where
        // the palette is actually masks.
        if (NULL == pFormat->m_pPalette)
        {
            if (PAL_BGR == pxlo->iDstType)
            {
                Count   = ((gpe32Bpp == pSurf->Format()) ? 4 : 3);
                Palette = g_BGRPalette;
            }
            else if (PAL_RGB == pxlo->iDstType)
            {
                Count   = ((gpe32Bpp == pSurf->Format()) ? 4 : 3);
                Palette = g_RGBPalette;
            }
            else
            {
                // Either we have bitfields, or a real palette.

                Count = XLATEOBJ_cGetPalette(pxlo, XO_DESTPALETTE, 0, NULL);

                if (Count)
                {
                    Palette = new ULONG [Count];
                }

                if (Palette)
                {
                    OwnsBuffer = TRUE;
                    Count = XLATEOBJ_cGetPalette(pxlo, XO_DESTPALETTE, Count, Palette);
                }
            }

            pFormat->m_PaletteEntries = Count;
            pFormat->m_OwnsPalette    = OwnsBuffer;
            pFormat->m_pPalette       = Palette;
        }

        pSurf = NULL;
    }

    if( pptlMask )
    {
        rclMask.top    = pptlMask->y;
        rclMask.left   = pptlMask->x;
        rclMask.bottom = pptlMask->y + prclTrg->bottom - prclTrg->top;
        rclMask.right  = pptlMask->x + prclTrg->right - prclTrg->left;
    }
    else
    {
        rclMask = *prclSrc;
    }

    parms.pDst          = pDst;
    parms.prclDst       = prclTrg;
    parms.xPositive     = 1;
    parms.yPositive     = 1;
    parms.rop4          = rop4;
    parms.pLookup       = (unsigned long *)NULL;
    parms.pConvert      = NULL;
    parms.pBrush        = (GPESurf *)NULL;
    parms.solidColor    = 0xffffffff;
    parms.bltFlags      = bltFlags;
    parms.iMode         = iMode;
    parms.blendFunction = blendFunction;

    // See if pattern matters
    if( ( rop4 ^ ( rop4 >> 4 ) ) & 0x0F0F )
    {
        parms.pptlBrush = pptlBrush;
        if( pbo )
        {
            if( pbo->iSolidColor == 0xffffffff )
            {
                if( pbo->pvRbrush == NULL )
                {
                    parms.pBrush = (GPESurf *)( BRUSHOBJ_pvGetRbrush( pbo ) );
                }
                else
                {
                    parms.pBrush = (GPESurf *)( pbo->pvRbrush );
                }

                if( parms.pBrush == NULL )
                {
                    DEBUGMSG(GPE_ZONE_ERROR,(TEXT("Blt w/ rop4=0x%04x and parms.pBrush==NULL !\r\n"),rop4));
                    return FALSE;
                }
            }
            else
            {
                parms.solidColor = pbo->iSolidColor;
                parms.pptlBrush = (POINTL *)NULL;
            }
        }
        else
        {
            DEBUGMSG(GPE_ZONE_ERROR,(TEXT("Blt w/ rop4=0x%04x and pbo==NULL !\r\n"),rop4));
            return FALSE;
        }
    }
    else
    {
        parms.pptlBrush = (POINTL *)NULL;
        if( pbo )
        {
            parms.solidColor = pbo->iSolidColor;    // This is used as the transparent color
        }
    }

    // See if mask matters
    if( ( rop4 ^ ( rop4 >> 8 ) ) & 0x00FF )
    {
        parms.prclMask = &rclMask;
        parms.pMask    = pMask;
    }
    else
    {
        parms.prclMask = (RECTL *)NULL;
        parms.pMask    = (GPESurf *)NULL;
    }

    ULONG iDir = CD_ANY;    // default to clip enumeration in any order

    if( (GPESurf *)(parms.pDst) == (GPESurf *)(parms.pSrc) )    
    {
        if (bltFlags & BLT_STRETCH)
        {
            rclSrcCopy = *prclTrg;

            if (rclSrcCopy.left > rclSrcCopy.right)
            {
                LONG swap        = rclSrcCopy.left;
                rclSrcCopy.left  = rclSrcCopy.right;
                rclSrcCopy.right = swap;
            }

            if (rclSrcCopy.top > rclSrcCopy.bottom)
            {
                LONG swap         = rclSrcCopy.top;
                rclSrcCopy.top    = rclSrcCopy.bottom;
                rclSrcCopy.bottom = swap;
            }

            if (prclSrc->bottom > rclSrcCopy.top
                &&  prclSrc->top < rclSrcCopy.bottom
                &&  prclSrc->right > rclSrcCopy.left
                &&  prclSrc->left < rclSrcCopy.right )
            {
                GPE*    pSurfGPE  = SurfobjToGPE(psoSrc);
                int     srcWidth  = prclSrc->right - prclSrc->left;
                int     srcHeight = prclSrc->bottom - prclSrc->top;
                SURFOBJ soSrcCopy;

                if (FAILED(pSurfGPE->AllocSurface(
                                         &pSurf, 
                                         srcWidth, 
                                         srcHeight, 
                                         IFormatToEGPEFormat[psoSrc->iBitmapFormat],
                                         GPE_PREFER_VIDEO_MEMORY)))
                {
                    return FALSE;
                }
                
                soSrcCopy.lDelta        = pSurf->Stride();
                soSrcCopy.dhpdev        = (DHPDEV)pSurfGPE;
                soSrcCopy.hsurf         = (HSURF)&soSrcCopy;
                soSrcCopy.hdev          = 0;
                soSrcCopy.sizlBitmap.cx = srcWidth;
                soSrcCopy.sizlBitmap.cy = srcHeight;
                soSrcCopy.iBitmapFormat = psoSrc->iBitmapFormat;
                soSrcCopy.iType         = 0;
                soSrcCopy.pvBits        = pSurf->Buffer();
                soSrcCopy.pvScan0       = soSrcCopy.pvBits;
                soSrcCopy.dhsurf        = 0;

                rclSrcCopy.left   = 0; 
                rclSrcCopy.top    = 0;
                rclSrcCopy.right  = srcWidth;
                rclSrcCopy.bottom = srcHeight;

                sc1 = AnyBlt(
                          &soSrcCopy,
                          psoSrc,
                          NULL,
                          NULL,
                          NULL,
                          &rclSrcCopy,
                          prclSrc,
                          NULL,
                          NULL,
                          NULL,
                          0xCCCC,
                          0,
                          BLACKONWHITE,
                          g_NullBlendFunction ) ? S_OK : E_FAIL;

                if (FAILED(sc1))
                {
                    delete pSurf;
                    return FALSE;    
                }

                parms.pSrc    = pSurf;
                parms.prclSrc = &rclSrcCopy;
            }
        }
        // Check for overlap since source and dest surfaces are the same
        else if( prclSrc->bottom > prclTrg->top
                && prclSrc->top < prclTrg->bottom
                && prclSrc->right > prclTrg->left
                && prclSrc->left < prclTrg->right )
        {
            if( prclSrc->top == prclTrg->top )
            {
                // Horizontal blt, just set xPositive appropriately
                parms.xPositive = prclSrc->left >= prclTrg->left;
            }
            else
            {
                // Non horizontal blts, just set yPositive appropriately
                parms.yPositive = prclSrc->top >= prclTrg->top;
            }

            // In case we enumerate cliprects - determine the order to use
            if( prclSrc->top > prclTrg->top )
            {
                iDir = ( prclSrc->left > prclTrg->left ) ? CD_RIGHTDOWN : CD_LEFTDOWN;
            }
            else
            {
                iDir = ( prclSrc->left > prclTrg->left ) ? CD_RIGHTUP : CD_LEFTUP;
            }
        }
    }
    else if ( parms.pSrc )
    {
        ColorConverter::InitConverter(
            pxlo,
            &parms.pColorConverter,
            (unsigned long (ColorConverter::** )(unsigned long))&parms.pConvert,
            &parms.pLookup );
    }

    // Add src masks/palette so that GeneratedBlts can use them for color
    // conversion.
    if (pxlo && parms.pSrc)
    {
        ULONG   Count;
        ULONG * Palette    = NULL;
        BOOL    OwnsBuffer = FALSE;

        GPESurf   * pSrcSurf = (GPESurf *)parms.pSrc;
        GPEFormat * pFormat  = pSrcSurf->FormatPtr();

        // Only query the palette if our palette isn't NULL.
        // This works because we're really interested in the case where
        // the palette is actually masks.
        if (pFormat->m_pPalette == NULL)
        {
            if (pxlo->iSrcType == PAL_BGR)
            {
                Count = ((pSrcSurf->Format() == gpe32Bpp) ? 4 : 3);
                Palette = g_BGRPalette;
            }
            else if (pxlo->iSrcType == PAL_RGB)
            {
                Count = ((pSrcSurf->Format() == gpe32Bpp) ? 4 : 3);
                Palette = g_RGBPalette;
            }
            else
            {
                // Either we have bitfields, or a real palette.

                Count = XLATEOBJ_cGetPalette(pxlo, XO_SRCPALETTE, 0, NULL);

                if (Count)
                {
                    Palette = new ULONG [Count];
                }

                if (Palette)
                {
                    OwnsBuffer = TRUE;
                    Count = XLATEOBJ_cGetPalette(pxlo, XO_SRCPALETTE, Count, Palette);
                }
            }

            pFormat->m_PaletteEntries = Count;
            pFormat->m_OwnsPalette    = OwnsBuffer;
            pFormat->m_pPalette       = Palette;
        }
    }

    parms.prclClip = (RECTL *)NULL;

    if( pco )
    {
        if( pco->iDComplexity == DC_RECT )
        {
            parms.prclClip = &(pco->rclBounds);
        }
    }

    if( FAILED(pGPE->BltPrepare( &parms ) ) )
    {
        DEBUGMSG(GPE_ZONE_ERROR,(TEXT("failed to prepare blt\r\n")));
        DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvBitBlt\r\n")));

        return FALSE;
    }

    if( pco && pco->iDComplexity == DC_COMPLEX )
    {
        // Non-trivial clipping - set up the Blt, then iterate through the cliprects & complete the blt
        CLIPENUM ce;

        // Request cliprects in a specific order to handle overlaps
        CLIPOBJ_cEnumStart( pco, TRUE, CT_RECTANGLES, iDir, 0 );    // don't need to count

        for( ce.c = 0, moreClipLists = 1, prclCurr = ce.arcl; ce.c || moreClipLists; )
        {
            if( ce.c == 0 )
            {
                // Get next list of cliprects from clipobj
                moreClipLists = CLIPOBJ_bEnum( pco, sizeof(ce), (ULONG *)&ce );
                prclCurr      = ce.arcl;

                if( !ce.c )
                {
                    continue;
                }
            }

            parms.prclClip = prclCurr++;
            ce.c--;

            DEBUGMSG(GPE_ZONE_BLT_HI,(TEXT("Calling GPE::Blt with complex cliprect\r\n")));
//#define ALLOW_MODIFY_BLTPARMS_IN_CLIP_BLT
#ifdef ALLOW_MODIFY_BLTPARMS_IN_CLIP_BLT
            GPEBltParms parmsCopy = parms;
            if( FAILED( sc1 = ClipBlt( pGPE, &parmsCopy ) ) )
#else
            if( FAILED( sc1 = ClipBlt( pGPE, &parms ) ) )
#endif
            {
                DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvBitBlt\r\n")));
                break;
            }
        }
    }
    else
    {
        sc1 = ClipBlt( pGPE, &parms );
    }

    sc2 = pGPE->BltComplete( &parms );

    DEBUGMSG(GPE_ZONE_ENTER,(TEXT("Leaving DrvBitBlt\r\n")));

    if (pSurf)
    {
        delete pSurf;
    }

    return !FAILED(sc1) && !FAILED(sc2);
}


SCODE
ClipBlt(
    GPE         * pGPE,
    GPEBltParms * pBltParms
    )
{
    DEBUGMSG(GPE_ZONE_BLT_LO,(TEXT("ClipBlt continue phase\r\n")));

#ifdef ALLOW_MODIFY_BLTPARMS_IN_CLIP_BLT

    if( pBltParms->prclClip && !( pBltParms->bltFlags & BLT_STRETCH ) )
    {
        RECTL   rclDst  = *(pBltParms->prclDst);
        RECTL & rclClip = *(pBltParms->prclClip);

        //rclDst is not necessarily well ordered for DrvAnyBlt!!
        if (rclDst.left > rclDst.right)
        {
            LONG tmp = rclDst.left;

            rclDst.left  = rclDst.right;
            rclDst.right = tmp;
        }

        if (rclDst.top > rclDst.bottom)
        {
            LONG tmp = rclDst.top;

            rclDst.top    = rclDst.bottom;
            rclDst.bottom = tmp;
        }

        if( rclDst.left < rclClip.left )
        {
            rclDst.left = rclClip.left;
        }
        if( rclDst.top < rclClip.top )
        {
            rclDst.top = rclClip.top;
        }
        if( rclDst.bottom > rclClip.bottom )
        {
            rclDst.bottom = rclClip.bottom;
        }
        if( rclDst.right > rclClip.right )
        {
            rclDst.right = rclClip.right;
        }
        if( rclDst.right <= rclDst.left || rclDst.bottom <= rclDst.top )
        {
            return S_OK;    // the clipping left nothing to do
        }

        int OffLeft   = rclDst.left   - pBltParms->prclDst->left;
        int OffTop    = rclDst.top    - pBltParms->prclDst->top;
        int OffRight  = rclDst.right  - pBltParms->prclDst->right;
        int OffBottom = rclDst.bottom - pBltParms->prclDst->bottom;

        pBltParms->prclDst = &rclDst;

        if (OffLeft || OffTop || OffRight || OffBottom)
        {
            if( pBltParms->prclSrc )
            {
                register RECTL * const prclSrc = pBltParms->prclSrc;

                prclSrc->left   += OffLeft;
                prclSrc->right  += OffRight;
                prclSrc->top    += OffTop;
                prclSrc->bottom += OffBottom;
            }

            if( pBltParms->prclMask )
            {
                register RECTL * const prclMask = pBltParms->prclMask;

                prclMask->left   += OffLeft;
                prclMask->right  += OffRight;
                prclMask->top    += OffTop;
                prclMask->bottom += OffBottom;
            }
        }

        pBltParms->prclClip = (RECTL *)NULL;

        // Perform actual Blt
        return (pGPE->*(pBltParms->pBlt))( pBltParms );
    }
    else
    {
        // Perform actual Blt
        return (pGPE->*(pBltParms->pBlt))( pBltParms );
    }

#else // !ALLOW_MODIFY_BLTPARMS_IN_CLIP_BLT

    if( pBltParms->prclClip && !( pBltParms->bltFlags & BLT_STRETCH ) )
    {
        RECTL       rclDst;
        RECTL       rclSrc;
        RECTL       rclMask;
        RECTL       rclClip = *(pBltParms->prclClip);
        GPEBltParms parms   = *pBltParms;

        parms.prclDst = &rclDst;
        rclDst        = *(pBltParms->prclDst);

        //rclDst is not necessarily well ordered for DrvAnyBlt!!
        if (rclDst.left > rclDst.right)
        {
            LONG tmp = rclDst.left;

            rclDst.left  = rclDst.right;
            rclDst.right = tmp;
        }

        if (rclDst.top > rclDst.bottom)
        {
            LONG tmp = rclDst.top;

            rclDst.top    = rclDst.bottom;
            rclDst.bottom = tmp;
        }

        if( rclDst.left < rclClip.left )
        {
            rclDst.left = rclClip.left;
        }
        if( rclDst.top < rclClip.top )
        {
            rclDst.top = rclClip.top;
        }
        if( rclDst.bottom > rclClip.bottom )
        {
            rclDst.bottom = rclClip.bottom;
        }
        if( rclDst.right > rclClip.right )
        {
            rclDst.right = rclClip.right;
        }
        if( rclDst.right <= rclDst.left || rclDst.bottom <= rclDst.top )
        {
            return S_OK;    // the clipping left nothing to do
        }

        int OffLeft   = rclDst.left   - pBltParms->prclDst->left;
        int OffTop    = rclDst.top    - pBltParms->prclDst->top;
        int OffRight  = rclDst.right  - pBltParms->prclDst->right;
        int OffBottom = rclDst.bottom - pBltParms->prclDst->bottom;

        if (OffLeft || OffTop || OffRight || OffBottom)
        {
            if( parms.prclSrc )
            {
                rclSrc         = *(parms.prclSrc);
                parms.prclSrc  = &rclSrc;
                rclSrc.left   += OffLeft;
                rclSrc.right  += OffRight;
                rclSrc.top    += OffTop;
                rclSrc.bottom += OffBottom;
            }

            if( parms.prclMask )
            {
                rclMask         = *(parms.prclMask);
                parms.prclMask  = &rclMask;
                rclMask.left   += OffLeft;
                rclMask.right  += OffRight;
                rclMask.top    += OffTop;
                rclMask.bottom += OffBottom;
            }
        }

        parms.prclClip = (RECTL *)NULL;

        // Perform actual Blt
        return (pGPE->*(pBltParms->pBlt))( &parms );
    }
    else
    {
        // Perform actual Blt
        return (pGPE->*(pBltParms->pBlt))( pBltParms );
    }

#endif // !ALLOW_MODIFY_BLTPARMS_IN_CLIP_BLT

}

void
AAGetMaskBits(
    ULONG * pRedMask,
    ULONG * pGreMask,
    ULONG * pBluMask
    )
{
    ULONG * pBitMasks = DrvGetMasks((DHPDEV)SafeGetGPE(NULL));

    if (pBitMasks)
    {
        *pRedMask = pBitMasks[0];
        *pGreMask = pBitMasks[1];
        *pBluMask = pBitMasks[2];
    }
}
