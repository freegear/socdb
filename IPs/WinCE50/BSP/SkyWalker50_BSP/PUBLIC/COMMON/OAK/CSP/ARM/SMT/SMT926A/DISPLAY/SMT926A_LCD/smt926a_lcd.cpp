//------------------------------------------------------------------------------
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
// /*++
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
// --*/
//------------------------------------------------------------------------------
//	
// Copyright (c) SANGHWA MICRO TECHNOLOGY. All rights reserved.
//
// author 	: Yang Yong Tae
// history	: 
//			  2006-10-24 1:44AM first implement
//------------------------------------------------------------------------------

#include <smt926a_base_regs.h>
#include <smt926a_lcd.h>


// Hardware cursor control param
#define	LCD_HCS_ENABLE			(1<1)
#define	LCD_HCS_FMT_RGB332		(1<1)
#define	LCD_HCS_FMT_ARGB444		(1<1)
#define	LCD_HCS_FMT_ARGB555		(1<1)

// Hardware cursor blending control
#define	LCD_HCS_DISP_CURR		(1<1)
#define	LCD_HCS_DISP_LOWER		(1<1)

// Hardware cursor layer operation control
#define	LCD_COLKEY_ENABLE		(1<1)
#define	LCD_COLKEY_DISABLE		(1<1)
#define	LCD_NO_ALPHA			(1<1)
#define	LCD_GLOBAL_ALPHA		(1<1)
#define	LCD_PIXEL_ALPHA			(1<1)


// This prototype avoids problems exporting from .lib
BOOL APIENTRY GPEEnableDriver(ULONG engineVersion, ULONG cj, DRVENABLEDATA *data,
							  PENGCALLBACKS  engineCallbacks);

// Start with errors and warnings
INSTANTIATE_GPE_ZONES(0x3,"MGDI Driver","unused1","unused2")						

// Static varible
static	ulong	sBitMasks[] 			= { 0xF800, 0x07E0, 0x001F };				
static	TCHAR	sszBaseInstance[256] 	= _T("Drivers\\Display\\SMT926\\CONFIG");	

//------------------------------------------------------------------------------
//	DisplayInit
//------------------------------------------------------------------------------
BOOL 						
APIENTRY
DisplayInit(
LPCTSTR 	pszInstance, 	
DWORD		dwNumMonitors	
)
{
	LONG	Result;
	HKEY	hkDisplay;
	

	// print retail input information
    RETAILMSG(0, (_T("SALCD2: display instance '%s', num monitors %d\r\n"),
    	pszInstance != NULL ? pszInstance : _T("<NULL>"), dwNumMonitors));

	// if pszInstance exist, set new registry information
    if(pszInstance != NULL) 
    {
        _tcsncpy(sszBaseInstance, pszInstance, 
        	sizeof(sszBaseInstance)/sizeof(sszBaseInstance[0]));
    }

	// sanity check the path by making sure it exists
	Result = RegOpenKeyEx(HKEY_LOCAL_MACHINE, sszBaseInstance, 0, 0, &hkDisplay);
	if(Result == ERROR_SUCCESS) 
	{
		RegCloseKey(hkDisplay);
		return TRUE;
	} 
	else 
	{
		RETAILMSG(0, (_T("SALCD2: DisplayInit: can't open '%s'\r\n"), 
			sszBaseInstance));
	}

    return FALSE;
}
//------------------------------------------------------------------------------
//	DrvEnableDriver
//------------------------------------------------------------------------------
BOOL 							
APIENTRY 
DrvEnableDriver(
ULONG			engineVersion, 	
ULONG			cj, 			
DRVENABLEDATA	*pded,			
PENGCALLBACKS 	engineCallbacks	
)
{
	BOOL fOK = FALSE;

	// make sure we know where our registry configuration is
	if(sszBaseInstance[0] != 0) 
	{
		fOK = GPEEnableDriver(engineVersion, cj, pded, engineCallbacks);
	}

	return fOK;
}
//------------------------------------------------------------------------------
//	GetGPE
//------------------------------------------------------------------------------
GPE*
GetGPE(
void
)
{	
	static GPE *pGPE= (GPE*)NULL;
	
	if(!pGPE)
	{
		pGPE = new SMT926DISP();
	}

	return pGPE;
}
//------------------------------------------------------------------------------
//	DrvGetMasks
//------------------------------------------------------------------------------
ULONG*
APIENTRY 
DrvGetMasks(
DHPDEV dhpdev
)
{
	return sBitMasks;
}
//------------------------------------------------------------------------------
//	RegisterDDHALAPI
//------------------------------------------------------------------------------
void	
RegisterDDHALAPI(
void
)
{
	return;	// no DDHAL support
}
//------------------------------------------------------------------------------
//	SMT926DISP::InitializeHardware
//------------------------------------------------------------------------------
void 
SMT926DISP::
InitializeHardware(
void
)
{
	WORD		*ptr;
	DWORD		index;
	HKEY		hkDisplay = NULL;
	DWORD 		dwStatus, dwType, dwSize;
	BOOL		fOK;

	RETAILMSG(0, 
		(TEXT("++SMT926DISP::InitializeHardware\r\n")));

	//
	// open the registry key and read our configuration
	//
	dwStatus	= RegOpenKeyEx(
						HKEY_LOCAL_MACHINE, 
						sszBaseInstance, 
						0, 0,
						&hkDisplay);
						
	if((hkDisplay==NULL) || (dwStatus!=ERROR_SUCCESS))
	{
		
		RETAILMSG(0, 
			(TEXT("couldn't get registry\r\n")));		
		return;
	}
						
	
	//
	// get physical frame base
	//
	dwType = REG_DWORD;
	dwSize = sizeof(DWORD);
	dwStatus = RegQueryValueEx(
					hkDisplay, 
					TEXT("LCDPhysicalFrameBase"), 
					NULL, 
					&dwType, 
					(LPBYTE)&m_PhysicalFrameBuffer, 
					&dwSize);
	if(dwStatus != ERROR_SUCCESS) 
	{
		RETAILMSG(0, 
			(TEXT("couldn't get LCDPhysicalFrameBase\r\n")));				
		return;
	}
	
	//
	// get physical hardware cursor base
	//
	dwType = REG_DWORD;
	dwSize = sizeof(DWORD);
	dwStatus = RegQueryValueEx(
					hkDisplay, 
					TEXT("LCDPhysicalHWCursorBase"), 
					NULL, 
					&dwType, 
					(LPBYTE)&m_PhysicalCursorBuffer, 
					&dwSize);
	if(dwStatus != ERROR_SUCCESS) 
	{
		RETAILMSG(0, 
			(TEXT("couldn't get HWCursorBufferBase\r\n")));				
		return;
	}
		
	
	
	//
	//	map LCD register
	//
	m_LCDRegs = (volatile SMT926A_LCD_REG*)VirtualAlloc(
								0, 
								sizeof(SMT926A_LCD_REG), 
								MEM_RESERVE, 
								PAGE_NOACCESS);
	if (!m_LCDRegs)
	{
		DEBUGMSG(0, 
			(TEXT("m_LCDRegs: VirtualAlloc failed!\r\n")));
		return;
	}
	
	
	fOK = VirtualCopy(
			(PVOID)m_LCDRegs, 
			(PVOID)(SMT926A_BASE_REG_PA_LCD>>8), 
			sizeof(SMT926A_LCD_REG), 
			PAGE_PHYSICAL|PAGE_READWRITE|PAGE_NOCACHE);
	
	if (!fOK)
	{
		
		DEBUGMSG(0, 
			(TEXT("m_LCDRegs: VirtualCopy failed!\r\n")));
		
			
		return;
	}
	
	
	//
	//	map frame buffer and binding phygical address
	//
	m_VirtualFrameBuffer = (DWORD)VirtualAlloc(
								0, 
								(0x40000), 
								MEM_RESERVE, 
								PAGE_NOACCESS);
	if (m_VirtualFrameBuffer == NULL) 
	{
	    RETAILMSG(0,
	    	(TEXT("m_VirtualFrameBuffer is not allocated\n\r")));
		return;
	}
	
	fOK = VirtualCopy(
			(PVOID)m_VirtualFrameBuffer, 
			(PVOID)(m_PhysicalFrameBuffer>>8), 
			(0x40000), 
			PAGE_READWRITE|PAGE_NOCACHE);
	if(!fOK)
	{
	    RETAILMSG(0, 
	    	(TEXT("m_VirtualFrameBuffer is not mapped\n\r")));
	    	
    	VirtualFree((PVOID)m_VirtualFrameBuffer, 0, MEM_RELEASE);
    	return;
	}
	
	RETAILMSG(0, 
		(TEXT("m_VirtualFrameBuffer is mapped at %x(PHY : %x)\n\r"), 
		m_VirtualFrameBuffer, m_PhysicalFrameBuffer));
	
	
	//
	//	map HWcursor buffer and binding phygical address
	//		
	m_VirtualCursorBuffer = (DWORD)VirtualAlloc(
								0, 
								(0x800), 
								MEM_RESERVE, 
								PAGE_NOACCESS);
	if (m_VirtualCursorBuffer == NULL) 
	{
	    RETAILMSG(0,
	    	(TEXT("m_VirtualCursorBuffer is not allocated\n\r")));
		return;
	}
	
	fOK = VirtualCopy(
			(PVOID)m_VirtualCursorBuffer, 
			(PVOID)(m_PhysicalCursorBuffer>>8), 
			(0x800), 
			PAGE_READWRITE|PAGE_NOCACHE);
	if(!fOK)
	{
	    RETAILMSG(0, 
	    	(TEXT("m_VirtualCursorBuffer is not mapped\n\r")));
	    	
    	VirtualFree((PVOID)m_VirtualFrameBuffer, 0, MEM_RELEASE);
    	return;
	}
	
	RETAILMSG(0, 
		(TEXT("m_VirtualCursorBuffer is mapped at %x(PHY : %x)\n\r"), 
		m_VirtualCursorBuffer, m_PhysicalCursorBuffer));		
	
	
	
	//
	// clear rest of frame buffer out
	//
	for (index = 0, ptr = (WORD *)m_VirtualFrameBuffer; 
		index < 320*240; 
		index++)
	{
		if(index < 3200)		ptr[index] = 0xf800;
		else if(index < 6400)	ptr[index] = 0x07e0;
		else if(index < 9600)	ptr[index] = 0x001f;
		else					ptr[index] = 0xffff;
	}
	
	RETAILMSG(0, 
		(TEXT("Clearing frame buffer !!!\n\r")));
	
			

	RETAILMSG(0, 
		(TEXT("--SMT926DISP::InitializeHardware\r\n")));
		
}
//------------------------------------------------------------------------------
//	SMT926DISP::SMT926DISP
//------------------------------------------------------------------------------
SMT926DISP::
SMT926DISP(
void
)
{
	RETAILMSG(0, 
		(TEXT("++SMT926DISP::SMT926DISP\r\n")));
	
	// setup up display mode related constants
	m_nScreenWidth			= 240;
	m_nScreenHeight 		= 320;
	m_colorDepth 			= 16;
	m_cbScanLineLength 		= m_nScreenWidth*2;
	m_FrameBufferSize 		= m_nScreenHeight*m_cbScanLineLength;
	
	// memory map register access window, frame buffer
	InitializeHardware();

#ifdef DISP_ROTATE
	m_iRotate = 0;
	SetRotateParms();
#endif //DISP_ROTATE	

	// setup ModeInfo structure
	m_ModeInfo.modeId 		= 0;
	m_ModeInfo.width 		= m_nScreenWidth;
	m_ModeInfo.height 		= m_nScreenHeight;
	m_ModeInfo.Bpp 			= m_colorDepth;
	m_ModeInfo.format 		= gpe16Bpp;
	m_ModeInfo.frequency 	= 60;	
	m_pMode 				= &m_ModeInfo;
	
	// allocate primary display surface
#ifdef 	DISP_ROTATE
	m_pPrimarySurface 		= 
	new GPESurfRotate
	(
		m_nScreenWidthSave, 
		m_nScreenHeightSave, 
		(void*)(m_VirtualFrameBuffer), 
		m_cbScanLineLength, 
		m_ModeInfo.format
	);
#else
	m_pPrimarySurface 		= 
	new GPESurf(
		m_nScreenWidth, 
		m_nScreenHeight, 
		(void*)(m_VirtualFrameBuffer), 
		m_cbScanLineLength, 
		m_ModeInfo.format
	);	
#endif //!DISP_ROTATE

    if (m_pPrimarySurface)
    {
	    memset ((void*)m_pPrimarySurface->Buffer(), 0x0, m_FrameBufferSize);
    }

	// init cursor related vars
	m_CursorVisible 		= FALSE;
	m_CursorDisabled 		= TRUE;
	m_CursorForcedOff 		= FALSE;
	m_CursorBackingStore 	= NULL;
	m_CursorXorShape 		= NULL;
	m_CursorAndShape 		= NULL;
	memset (&m_CursorRect, 0x0, sizeof(m_CursorRect));	

#ifdef DISP_CLEARTYPE

	HKEY  	hKey;
	DWORD 	dwValue;
	DWORD 	dwStatus;
	ULONG 	ulGamma 		= DEFAULT_CT_GAMMA;	
	TCHAR	szGamma[256] 	= (TEXT("System\\GDI\\Gamma"));

	
	dwStatus = RegCreateKeyEx(
				HKEY_LOCAL_MACHINE,
				szGamma,
				0, 
				NULL,
				0,0,0,
				&hKey,
				&dwValue);

	if (ERROR_SUCCESS == dwStatus)
	{
		
	    if (dwValue == REG_OPENED_EXISTING_KEY)
	    {
	    	
			DWORD dwType = REG_DWORD;
			DWORD dwSize = sizeof(LONG);
			dwStatus = RegQueryValueEx(
						hKey,
						szGamma,
						0,
						&dwType,
						(BYTE *)&dwValue,
						&dwSize);
			if (ERROR_SUCCESS == dwStatus)
			{
		    	ulGamma = dwValue;
			}
	    } 
	    else if (dwValue == REG_CREATED_NEW_KEY )
	    {
			RegSetValueEx(
				hKey,
				szGamma,
				0,
				REG_DWORD,
				(BYTE *)&ulGamma,
				sizeof(DWORD));
	    }
	    RegCloseKey(hKey);
	}

	SetClearTypeBltGamma(ulGamma);
	SetClearTypeBltMasks(sBitMasks[0], sBitMasks[1], sBitMasks[2]);
	
#endif //DISP_CLEARTYPE	

	RETAILMSG(0, 
		(TEXT("--SMT926DISP::SMT926DISP\r\n")));
}
//------------------------------------------------------------------------------
//	SMT926DISP::SetMode
//------------------------------------------------------------------------------
SCODE 
SMT926DISP::
SetMode(
INT			modeId, 
HPALETTE	*palette
)
{
	RETAILMSG(0, 
		(TEXT("++SMT926DISP::SetMode\r\n")));

	if (modeId != 0)
	{
		RETAILMSG(0, 
			(TEXT("SMT926DISP::SetMode Want mode %d, only have mode 0\r\n")
			,modeId));
		return	E_INVALIDARG;
	}

	if (palette)
	{
		*palette = EngCreatePalette(
					PAL_BITFIELDS, 
					0, 
					NULL, 
					sBitMasks[0], 
					sBitMasks[1], 
					sBitMasks[2]);
	}

	RETAILMSG(0, 
		(TEXT("--SMT926DISP::SetMode\r\n")));

	return S_OK;
}
//------------------------------------------------------------------------------
//	SMT926DISP::SetMode
//------------------------------------------------------------------------------
SCODE 
SMT926DISP::
GetModeInfo(
GPEMode	*mode,	
INT		modeNumber
)
{
	RETAILMSG(0, 
		(TEXT("++SMT926DISP::GetModeInfo\r\n")));

	if (modeNumber != 0)
	{
		return E_INVALIDARG;
	}

	*mode = m_ModeInfo;
	RETAILMSG(0, 
		(TEXT("--SMT926DISP::GetModeInfo\r\n")));

	return S_OK;
}
//------------------------------------------------------------------------------
//	SMT926DISP::NumModes
//------------------------------------------------------------------------------
int	
SMT926DISP::
NumModes(
void
)
{
	RETAILMSG(0, 
		(TEXT("++SMT926DISP::NumModes\r\n")));
		
	return	1;
}
//------------------------------------------------------------------------------
//	SMT926DISP::SetPointerShape
//------------------------------------------------------------------------------
SCODE	
SMT926DISP::
SetPointerShape(
GPESurf	*pMask, 
GPESurf *pColorSurf, 
INT		xHot, 
INT		yHot, 
INT		cX, 
INT		cY
)
{
	UCHAR	*andPtr;		// input pointer
	UCHAR	*xorPtr;		// input pointer
	UCHAR	bAnd;
	UCHAR	bXor;
	UCHAR	*pMaskBuffer;
	INT		MaskStride;
	INT		row, col, i, bitMask;

	RETAILMSG(0, 
		(TEXT("SMT926DISP::SetPointerShape(0x%X, 0x%X, %d, %d, %d, %d)\r\n"),
		pMask, pColorSurf, xHot, yHot, cX, cY));

	// turn current cursor off
	CursorOff();

	// release memory associated with old cursor
	// delete Backup, XOR, AND Cursor shape
	if (m_CursorBackingStore)
	{
		delete (void*)m_CursorBackingStore;
		m_CursorBackingStore = NULL;
	}
	
	if (m_CursorXorShape)
	{
		delete (void*)m_CursorXorShape;
        m_CursorXorShape = NULL;
	}
	
	if (m_CursorAndShape)
	{
		delete (void*)m_CursorAndShape;
        m_CursorAndShape = NULL;
	}

	// check we have a new cursor shape, if no disable flag for cursor, 
	// otherwise enable flag for cursor 
	if (!pMask)							
	{
		m_CursorDisabled = TRUE;		
	}
	else
	{
		m_CursorDisabled = FALSE;		
	

#ifndef DISP_HWC_ACCEL

		// allocate memory based on new cursor size
        m_CursorBackingStore	= new UCHAR[(cX*(m_colorDepth>>3))*cY];
        m_CursorXorShape		= new UCHAR[cX*cY];
        m_CursorAndShape 		= new UCHAR[cX*cY];

        if (!m_CursorXorShape || !m_CursorAndShape)
        {
            return(ERROR_NOT_ENOUGH_MEMORY);
        }
#endif        

	
		// store size and hotspot for new cursor
		m_CursorSize.x		= cX;
		m_CursorSize.y		= cY;
		m_CursorHotspot.x	= xHot;
		m_CursorHotspot.y 	= yHot;

		// get AND, XOR shape
		pMaskBuffer 		= (UCHAR*)pMask->Buffer();
		MaskStride			= pMask->Stride();
		andPtr 				= pMaskBuffer;
		xorPtr 				= (UCHAR*)pMaskBuffer+(cY*MaskStride);
		
		//
		//	initialize hardware cursor
		//
		
#ifdef DISP_HWC_ACCEL
		
		// layer control
		m_LCDRegs->CBBASE 				
			= LCD_HCS_DISP_LOWER	
			| (0x0);					
			
		// format control
		m_LCDRegs->CSCTRL 				
			= LCD_HCS_ENABLE
			| LCD_HCS_FMT_RGB332
			| ((MaskStride<<11)&0x6ff)
			| ((MaskStride)&0x6ff);
		
		// address and blend option
		m_LCDRegs->CSCADR
			= LCD_COLKEY_ENABLE
			| (m_PhysicalCursorBuffer&0x0fffffff);
		
		// position
		m_LCDRegs->CSADR
			= (0)
			|(0);
			
		UCHAR *pHWCLayer = (UCHAR*)m_VirtualCursorBuffer;
			
		// store OR and AND mask for new cursor
		for (row = 0; row < cY; row++)
		{

			for (col = 0; col < cX/8; col++)
			{
				bAnd = andPtr[row*MaskStride+col];
				bXor = xorPtr[row*MaskStride+col];

				for (bitMask = 0x0080, i = 0; 
					i<8; 
					bitMask >>= 1, i++)
				{					
					pHWCLayer[(col*8)+i] =  0x0;	
					pHWCLayer[(col*8)+i] &= (bAnd & bitMask ? 0xFF : 0x00);
					pHWCLayer[(col*8)+i] ^= (bXor & bitMask ? 0xFF : 0x00);
					
				}
			}
		}			
	
		
#else

		UCHAR	*andLine;		// output pointer
		UCHAR	*xorLine;		// output pointer
		
		// store OR and AND mask for new cursor
		for (row = 0; row < cY; row++)
		{
			andLine = &m_CursorAndShape[cX*row];
			xorLine = &m_CursorXorShape[cX*row];

			for (col = 0; col < cX/8; col++)
			{
				bAnd = andPtr[row*MaskStride+col];
				bXor = xorPtr[row*MaskStride+col];

				for (bitMask = 0x0080, i = 0; 
					i<8; 
					bitMask >>= 1, i++)
				{
					andLine[(col*8)+i] = bAnd & bitMask ? 0xFF : 0x00;
					xorLine[(col*8)+i] = bXor & bitMask ? 0xFF : 0x00;
					
				}
			}
		}
		
#endif		
	}

	return	S_OK;
}

//------------------------------------------------------------------------------
//	SMT926DISP::MovePointer
//------------------------------------------------------------------------------
SCODE	
SMT926DISP::
MovePointer(
INT xPosition, 
INT	yPosition
)
{
	RETAILMSG(0, 
		(TEXT("SMT926DISP::MovePointer(%d, %d)\r\n"), 
		xPosition, yPosition));

	CursorOff();

	if ((xPosition!=-1) || (yPosition!=-1))
	{
		// compute new cursor rect
		m_CursorRect.left	= xPosition-m_CursorHotspot.x;
		m_CursorRect.right 	= m_CursorRect.left+m_CursorSize.x;
		m_CursorRect.top 	= yPosition-m_CursorHotspot.y;
		m_CursorRect.bottom = m_CursorRect.top+m_CursorSize.y;

		CursorOn();
	}

	return	S_OK;
}
//------------------------------------------------------------------------------
//	SMT926DISP::CursorOn
//------------------------------------------------------------------------------
void	
SMT926DISP::
CursorOn(
void
)
{
	
#ifndef DISP_HWC_ACCEL			
	UCHAR	*ptrScreen 		= (UCHAR*)m_pPrimarySurface->Buffer();
	INT		ScreenStride	=  m_pPrimarySurface->Stride();
	INT		ColorDepthSht	= m_colorDepth>>3;
	UCHAR	*ptrLine;
	UCHAR	*cbsLine;
	INT		x, y;
#endif	
	
	

	if (!m_CursorForcedOff && !m_CursorDisabled && !m_CursorVisible)
	{
#ifndef DISP_HWC_ACCEL		


#ifndef DISP_ROTATE
	UCHAR	*xorLine;
	UCHAR	*andLine;
#endif //!DISP_ROTATE	


#ifdef DISP_ROTATE
		RECTL	rSave;
		int  	iRotate;
#endif //DISP_ROTATE

		if (!m_CursorBackingStore)
		{
			RETAILMSG(0, 
				(TEXT("SMT926DISP::CursorOn - No backing store available\r\n")));
			return;
		}
		
#ifdef DISP_ROTATE
		rSave = m_CursorRect;
		RotateRectl(&m_CursorRect);
#endif //DISP_ROTATE

		for(y = m_CursorRect.top; y < m_CursorRect.bottom; y++)
		{
			if (y < 0)
			{
				continue;
			}
			
#ifdef DISP_ROTATE
			if (y >= m_nScreenHeightSave)
#else
			if (y >= m_nScreenHeight)
#endif //DISP_ROTATE			
			{
				break;
			}

			ptrLine = &ptrScreen[y*ScreenStride];
			cbsLine = &m_CursorBackingStore
				[(y-m_CursorRect.top)*(m_CursorSize.x*ColorDepthSht)];
				
#ifndef DISP_ROTATE
			xorLine = &m_CursorXorShape[(y-m_CursorRect.top)*m_CursorSize.x];
			andLine = &m_CursorAndShape[(y-m_CursorRect.top)*m_CursorSize.x];
#endif //!DISP_ROTATE

			for (x = m_CursorRect.left; x < m_CursorRect.right; x++)
			{
				
				
				if (x < 0)
					continue;
#ifdef DISP_ROTATE
				if (x >= m_nScreenWidthSave)
					break;
#else
				if (x >= m_nScreenWidth)
					break;
#endif //!DISP_ROTATE				
				
#ifdef DISP_ROTATE

				switch (m_iRotate)
				{
				case DMDO_0:
					iRotate 
					= (y-m_CursorRect.top)*m_CursorSize.x
					+ x-m_CursorRect.left;
					break;
					
				case DMDO_90:
					iRotate 
					= (x-m_CursorRect.left)*m_CursorSize.x
					+ m_CursorSize.y-1-(y-m_CursorRect.top);   
					break;
					
				case DMDO_180:
					iRotate 
					= (m_CursorSize.y-1-(y-m_CursorRect.top))*m_CursorSize.x 
					+ m_CursorSize.x-1-(x-m_CursorRect.left);
					break;
					
				case DMDO_270:
					iRotate 
					= (m_CursorSize.x-1-(x-m_CursorRect.left))*m_CursorSize.x 
					+ y-m_CursorRect.top;
					break;
					
				default:
				    iRotate 
				    = (y-m_CursorRect.top)*m_CursorSize.x 
				    + x-m_CursorRect.left;
					break;
				}
#endif //DISP_ROTATE					
				cbsLine[(x-m_CursorRect.left)*ColorDepthSht] 
					= ptrLine[x*ColorDepthSht];
#ifdef DISP_ROTATE
				ptrLine[x*ColorDepthSht] 
					&= m_CursorAndShape[iRotate];
				ptrLine[x*ColorDepthSht] 
					^= m_CursorXorShape[iRotate];
#else 
				ptrLine[x*ColorDepthSht] 
					&= andLine[x-m_CursorRect.left];
				ptrLine[x*ColorDepthSht] 
					^= xorLine[x-m_CursorRect.left];
#endif //DISP_ROTATE				
				if (m_colorDepth > 8)
				{
					cbsLine[(x-m_CursorRect.left)*ColorDepthSht+1] 
						= ptrLine[x*ColorDepthSht+1];
#ifdef DISP_ROTATE
       		        ptrLine[x*ColorDepthSht+1] 
       		        	&= m_CursorAndShape[iRotate];
					ptrLine[x*ColorDepthSht+1] 
						^= m_CursorXorShape[iRotate];				
#else
					ptrLine[x*ColorDepthSht+1] 
						&= andLine[x-m_CursorRect.left];
					ptrLine[x*ColorDepthSht+1] 
						^= xorLine[x-m_CursorRect.left];
#endif //DISP_ROTATE					
					if (m_colorDepth > 16)
					{
						cbsLine[(x-m_CursorRect.left)*ColorDepthSht+2] 
							= ptrLine[x*ColorDepthSht+2];
#ifdef DISP_ROTATE
						ptrLine[x*ColorDepthSht+2] 
							&= m_CursorAndShape[iRotate];
						ptrLine[x*ColorDepthSht+2] 
							^= m_CursorXorShape[iRotate];
#else
						ptrLine[x*ColorDepthSht+2] 
							&= andLine[x-m_CursorRect.left];
						ptrLine[x*ColorDepthSht+2] 
							^= xorLine[x-m_CursorRect.left];
#endif //DISP_ROTATE						
					}
				}
			}
		}
#ifdef DISP_ROTATE
		m_CursorRect = rSave;
#endif
 
#else

		m_LCDRegs->CSADR  
			= ((m_CursorRect.top<<16)&0xffff)
			| ((m_CursorRect.left)&0xffff);
			
		m_LCDRegs->CBBASE ^= LCD_HCS_DISP_LOWER;
		m_LCDRegs->CBBASE |= LCD_HCS_DISP_CURR;
		
#endif
		m_CursorVisible = TRUE;
	}
}
//------------------------------------------------------------------------------
//	SMT926DISP::CursorOff
//------------------------------------------------------------------------------
void	SMT926DISP::CursorOff (void)
{
	
#ifndef DISP_HWC_ACCEL		
	UCHAR	*ptrScreen 		= (UCHAR*)m_pPrimarySurface->Buffer();
	INT		ScreenStride	= m_pPrimarySurface->Stride();
	INT		ColorDepthSht	= m_colorDepth>>3;
	UCHAR	*ptrLine;
	UCHAR	*cbsLine;
	INT		x, y;
#endif	

	if (!m_CursorForcedOff && !m_CursorDisabled && m_CursorVisible)
	{
#ifndef DISP_HWC_ACCEL

#ifdef DISP_ROTATE
		RECTL rSave;
#endif //DISP_ROTATE


		if (!m_CursorBackingStore)
		{
			RETAILMSG(0, 
				(TEXT("SMT926DISP::CursorOff - No backing store available\r\n")));
			return;
		}
		
#ifdef DISP_ROTATE
		rSave = m_CursorRect;
		RotateRectl(&m_CursorRect);
#endif //DISP_ROTATE

		for (y = m_CursorRect.top; y < m_CursorRect.bottom; y++)
		{
			// clip to displayable screen area (top/bottom)
			if (y < 0)
			{
				continue;
			}
#ifndef DISP_ROTATE
			if (y >= m_nScreenHeight)
#else 
			if (y >= m_nScreenHeightSave)
#endif //!DISP_ROTATE
			{
				break;
			}

			// get current and backup cursor pointer
			ptrLine = &ptrScreen[y*ScreenStride];
			cbsLine = &m_CursorBackingStore
				[(y-m_CursorRect.top)*(m_CursorSize.x*ColorDepthSht)];

			
			for (x = m_CursorRect.left; x < m_CursorRect.right; x++)
			{
				// clip to displayable screen area (left/right)
				if (x < 0)
				{
					continue;
				}
#ifndef DISP_ROTATE
				if (x >= m_nScreenWidth)
#else
				if (x>= m_nScreenWidthSave)
#endif //!DISP_ROTATE
				{
					break;
				}

				ptrLine[x*ColorDepthSht] 
					= cbsLine[(x-m_CursorRect.left)*ColorDepthSht];
					
				if (m_colorDepth > 8)
				{
					ptrLine[x*ColorDepthSht+1] 
						= cbsLine[(x-m_CursorRect.left)*ColorDepthSht+1];
						
					if (m_colorDepth > 16)
					{
						ptrLine[x*ColorDepthSht+2] 
							= cbsLine[(x-m_CursorRect.left)*ColorDepthSht+2];
					}
				}
			}
		}
		
		
#ifdef DISP_ROTATE
		m_CursorRect = rSave;
#endif //DISP_ROTATE

#else
		m_LCDRegs->CBBASE ^= LCD_HCS_DISP_CURR;
		m_LCDRegs->CBBASE |= LCD_HCS_DISP_LOWER;
#endif		

		m_CursorVisible = FALSE;
	}
}

//------------------------------------------------------------------------------
//	SMT926DISP::WaitForNotBusy
//------------------------------------------------------------------------------
void	
SMT926DISP::
WaitForNotBusy(
void
)
{
	RETAILMSG(0, 
		(TEXT("SMT926DISP::WaitForNotBusy\r\n")));
		
	return;
}
//------------------------------------------------------------------------------
//	SMT926DISP::IsBusy
//------------------------------------------------------------------------------
INT		
SMT926DISP::
IsBusy(
void
)
{
	RETAILMSG(0, 
		(TEXT("SMT926DISP::IsBusy\r\n")));
		
	return	0;
}
//------------------------------------------------------------------------------
//	SMT926DISP::AllocSurface
//------------------------------------------------------------------------------
void	
SMT926DISP::
GetPhysicalVideoMemory(
ULONG	*physicalMemoryBase, 
ULONG 	*videoMemorySize
)
{
	RETAILMSG(0, 
		(TEXT("SMT926DISP::GetPhysicalVideoMemory\r\n")));

	*physicalMemoryBase	= m_PhysicalFrameBuffer;
	*videoMemorySize	= m_cbScanLineLength*m_nScreenHeight;
}
//------------------------------------------------------------------------------
//	SMT926DISP::AllocSurface
//------------------------------------------------------------------------------
SCODE	
SMT926DISP::
AllocSurface(
GPESurf		**surface, 
INT			width, 
INT 		height, 
EGPEFormat 	format, 
INT 		surfaceFlags
)
{
	RETAILMSG(0, 
		(TEXT("SMT926DISP::AllocSurface\r\n")));

	if (surfaceFlags & GPE_REQUIRE_VIDEO_MEMORY)
	{
		return	E_OUTOFMEMORY;
	}

	// Allocate from system memory
	*surface = new GPESurf(width, height, format);

	if (*surface != NULL)
	{
		// Check that the bits were allocated succesfully
		if (((*surface)->Buffer()) == NULL)
		{
			delete *surface;				
		}
		else
		{
			return S_OK;
		}
	}
	
	return E_OUTOFMEMORY;
}
//------------------------------------------------------------------------------
//	SMT926DISP::WrappedEmulatedLine
//------------------------------------------------------------------------------
SCODE	
SMT926DISP::
WrappedEmulatedLine(
GPELineParms *lineParameters
)
{
	SCODE	retval;
	RECT	bounds;
	INT		N_plus_1;				
	INT		cPels 		= lineParameters->cPels;
	INT		dN			= lineParameters->dN;

	// calculate the bounding-rect to determine overlap with cursor
	// The line has a diagonal component (we'll refresh the bounding rect)
	if (dN)			
	{
		N_plus_1 = 2+((cPels*dN)/lineParameters->dM);
	}
	else
	{
		N_plus_1 = 1;
	}

	switch(lineParameters->iDir)
	{
		case 0:
			bounds.left 	= lineParameters->xStart;
			bounds.top		= lineParameters->yStart;
			bounds.right 	= lineParameters->xStart+cPels+1;
			bounds.bottom 	= bounds.top+N_plus_1;
			break;
			
		case 1:
			bounds.left		= lineParameters->xStart;
			bounds.top 		= lineParameters->yStart;
			bounds.bottom 	= lineParameters->yStart+cPels+1;
			bounds.right 	= bounds.left+N_plus_1;
			break;
			
		case 2:
			bounds.right 	= lineParameters->xStart+1;
			bounds.top 		= lineParameters->yStart;
			bounds.bottom 	= lineParameters->yStart+cPels+1;
			bounds.left 	= bounds.right-N_plus_1;
			break;
			
		case 3:
			bounds.right 	= lineParameters->xStart+1;
			bounds.top 		= lineParameters->yStart;
			bounds.left 	= lineParameters->xStart-cPels;
			bounds.bottom 	= bounds.top+N_plus_1;
			break;
			
		case 4:
			bounds.right 	= lineParameters->xStart+1;
			bounds.bottom 	= lineParameters->yStart+1;
			bounds.left 	= lineParameters->xStart-cPels;
			bounds.top 		= bounds.bottom-N_plus_1;
			break;
			
		case 5:
			bounds.right 	= lineParameters->xStart+1;
			bounds.bottom 	= lineParameters->yStart+1;
			bounds.top 		= lineParameters->yStart-cPels;
			bounds.left 	= bounds.right-N_plus_1;
			break;
			
		case 6:
			bounds.left 	= lineParameters->xStart;
			bounds.bottom 	= lineParameters->yStart+1;
			bounds.top 		= lineParameters->yStart-cPels;
			bounds.right	= bounds.left+N_plus_1;
			break;
			
		case 7:
			bounds.left 	= lineParameters->xStart;
			bounds.bottom 	= lineParameters->yStart+1;
			bounds.right 	= lineParameters->xStart+cPels+1;
			bounds.top 		= bounds.bottom-N_plus_1;
			break;
			
		default:
			RETAILMSG(0, 
				(TEXT("Invalid direction: %d\r\n"), 
				lineParameters->iDir));
			return E_INVALIDARG;
	}

	// check for line overlap with cursor and turn off cursor if overlaps
	if (m_CursorVisible && !m_CursorDisabled) {
		
		if((m_CursorRect.top < bounds.bottom)
		 &&(m_CursorRect.bottom > bounds.top)
		 &&(m_CursorRect.left < bounds.right)
		 &&(m_CursorRect.right > bounds.left)) 
		{
			CursorOff();
			m_CursorForcedOff = TRUE;
		}
	}

	// do emulated line
	retval = EmulatedLine (lineParameters);

	// se if cursor was forced off because of overlap with
	//  line bouneds and turn back on
	if (m_CursorForcedOff)
	{
		m_CursorForcedOff = FALSE;
		CursorOn();
	}

	return	retval;

}
//------------------------------------------------------------------------------
//	SMT926DISP::Line
//------------------------------------------------------------------------------
SCODE	
SMT926DISP::
Line(
GPELineParms	*lineParameters, 
EGPEPhase		phase
)
{
	RETAILMSG(0, 
		(TEXT("SMT926DISP::Line\r\n")));

	if ((phase==gpeSingle) || (phase==gpePrepare))
	{

		if ((lineParameters->pDst != m_pPrimarySurface))
		{
			lineParameters->pLine 
				= (SCODE (GPE::*)(struct GPELineParms *))
					EmulatedLine;
		}
		else
		{
			lineParameters->pLine 
				= (SCODE (GPE::*)(struct GPELineParms *))
					WrappedEmulatedLine;
		}
	}
	return S_OK;
}
//------------------------------------------------------------------------------
//	SMT926DISP::BltPrepare
//------------------------------------------------------------------------------
SCODE	
SMT926DISP::
BltPrepare(
GPEBltParms *blitParameters
)
{
	RECTL	rectl;

	RETAILMSG(0, 
		(TEXT("SMT926DISP::BltPrepare\r\n")));

	// default to base EmulatedBlt routine
	blitParameters->pBlt = EmulatedBlt;

	// see if we need to deal with cursor
	if (m_CursorVisible && !m_CursorDisabled)
	{
		// check for destination overlap with cursor and turn off cursor 
		// if overlaps, only care if dest is main display surface
		if (blitParameters->pDst == m_pPrimarySurface)	
		{
			// make sure there is a valid prclDst if so, use it
			// if not, use the Cursor rect 
			// - this forces the cursor to be turned off in this case
			if (blitParameters->prclDst != NULL)		
				rectl = *blitParameters->prclDst;		
			else
				rectl = m_CursorRect;					

		
			if ((m_CursorRect.top < rectl.bottom)
			  &&(m_CursorRect.bottom > rectl.top) 
			  &&(m_CursorRect.left < rectl.right)
			  &&(m_CursorRect.right > rectl.left))
			{
				CursorOff();
				m_CursorForcedOff = TRUE;
			}
		}

		// check for source overlap with cursor and turn off cursor if overlaps
		// only care if source is main display surface
		if (blitParameters->pSrc == m_pPrimarySurface)	
		{
			// make sure there is a valid prclSrc if so, use it
			// if not, use the CUrsor rect
			// - this forces the cursor to be turned off in this case
			if (blitParameters->prclSrc != NULL)	
				rectl = *blitParameters->prclSrc;		
			else
				rectl = m_CursorRect;					
				
			if ((m_CursorRect.top<rectl.bottom)
			  &&(m_CursorRect.bottom > rectl.top)
			  &&(m_CursorRect.left < rectl.right)
			  &&(m_CursorRect.right > rectl.left))
			{
				CursorOff();
				m_CursorForcedOff = TRUE;
			}
		}
	}

#ifdef DISP_ROTATE
    if (m_iRotate) {
    	
    	if((blitParameters->pDst==m_pPrimarySurface) 
       	 ||(blitParameters->pSrc==m_pPrimarySurface)) 
    	{
        	blitParameters->pBlt 
			= (SCODE(GPE::*)(GPEBltParms *))
        		EmulatedBltRotate;
    	}
    }
    
#endif //DISP_ROTATE

#ifdef DISP_CLEARTYPE
	if (((blitParameters->rop4&0xffff)==0xaaf0) 
	 &&(blitParameters->pMask->Format()==gpe8Bpp))
	{
	    switch (m_colorDepth)
	    {
	    case 16:
	 		blitParameters->pBlt 
	 		= (SCODE(GPE::*)(struct GPEBltParms*))
	 			ClearTypeBlt::ClearTypeBltDst16;
			return S_OK;
			
	    case 24:
			blitParameters->pBlt 
			= (SCODE (GPE::*)(struct GPEBltParms*))
				ClearTypeBlt::ClearTypeBltDst24;
			return S_OK;
			
	    case 32:
			blitParameters->pBlt 
			= (SCODE (GPE::*)(struct GPEBltParms*))
				ClearTypeBlt::ClearTypeBltDst32;
			return S_OK;
			
	    default:
		break;
	    }
	}
#endif //DISP_CLEARTYPE

	// see if there are any optimized software blits available
	EmulatedBltSelect02(blitParameters);
	EmulatedBltSelect08(blitParameters);
	EmulatedBltSelect16(blitParameters);

	return S_OK;
}
//------------------------------------------------------------------------------
//	SMT926DISP::BltComplete
//------------------------------------------------------------------------------
SCODE	
SMT926DISP::
BltComplete(
GPEBltParms *blitParameters
)
{
	RETAILMSG(0, 
		(TEXT("SMT926DISP::BltComplete\r\n")));

	// see if cursor was forced off because of overlap 
	// with source or destination and turn back on
	if (m_CursorForcedOff)
	{
		m_CursorForcedOff = FALSE;
		CursorOn();
	}

	return S_OK;
}
//------------------------------------------------------------------------------
//	SMT926DISP::InVBlank
//------------------------------------------------------------------------------
INT	
SMT926DISP::
InVBlank(
void
)
{
	RETAILMSG(0, 
		(TEXT("SMT926DISP::InVBlank\r\n")));
	return 0;
}
//------------------------------------------------------------------------------
//	SMT926DISP::SetPalette
//------------------------------------------------------------------------------
SCODE	
SMT926DISP::
SetPalette(
const PALETTEENTRY	*source, 
USHORT				firstEntry, 
USHORT				numEntries
)
{
	RETAILMSG(0, 
		(TEXT("SMT926DISP::SetPalette\r\n")));

	if(firstEntry < 0 
	|| (firstEntry+numEntries) > 256 
	|| source == NULL)
	{
		return	E_INVALIDARG;
	}

	return	S_OK;
}

//------------------------------------------------------------------------------
//	SMT926DISP::GetGraphicsCaps
//------------------------------------------------------------------------------
ULONG	
SMT926DISP::
GetGraphicsCaps(
void
)
{
    
#ifdef  DISP_CLEARTYPE
	return	GCAPS_GRAY16|GCAPS_DISP_CLEARTYPE;
#else
	return  GCAPS_GRAY16;
#endif 
}

#if defined(DISP_CLEARTYPE) || defined(DISP_ROTATE)
//------------------------------------------------------------------------------
//	SMT926DISP::DrvEscape
//------------------------------------------------------------------------------
extern GetGammaValue(ULONG * pGamma);
extern SetGammaValue(ULONG ulGamma, BOOL bUpdateReg);
ULONG  
SMT926DISP::DrvEscape(
SURFOBJ *pso,
ULONG    iEsc,
ULONG    cjIn,
PVOID    pvIn,
ULONG    cjOut,
PVOID    pvOut
)
{
    if (iEsc == DRVESC_GETGAMMAVALUE)
    {
		return GetGammaValue((ULONG *)pvOut);
    }
    else if (iEsc == DRVESC_SETGAMMAVALUE)
    {
		return SetGammaValue(cjIn, *(BOOL*)pvIn);
    }

#ifdef DISP_ROTATE

    if (iEsc == DRVESC_GETSCREENROTATION)
    {
        *(int *)pvOut = 
        	((DMDO_0|DMDO_90|DMDO_180|DMDO_270)<<8)
        	|((BYTE)m_iRotate);
        
        return DISP_CHANGE_SUCCESSFUL; 
    }
    else if (iEsc == DRVESC_SETSCREENROTATION)
    {
        if ((cjIn == DMDO_0) 
           || (cjIn == DMDO_90) 
           || (cjIn == DMDO_180)
           || (cjIn == DMDO_270))
		{
			return DynRotate(cjIn);	
		}
        return DISP_CHANGE_BADMODE;
    }
#endif //DISP_ROTATE & DISP_ROTATE
    
    return 0;
}
#endif //DISP_CLEARTYPE


#ifdef DISP_ROTATE
//------------------------------------------------------------------------------
//	SMT926DISP::SetRotateParms
//------------------------------------------------------------------------------
void 
SMT926DISP::
SetRotateParms(
void
)
{
    int iswap;
    switch(m_iRotate)
    {
    case DMDO_0:
		m_nScreenHeightSave	= m_nScreenHeight;
		m_nScreenWidthSave	= m_nScreenWidth;
		break;
		
    case DMDO_180:
		m_nScreenHeightSave	= m_nScreenHeight;
		m_nScreenWidthSave	= m_nScreenWidth;
		break;
		
	case DMDO_90:
	case DMDO_270:
		iswap 				= m_nScreenHeight;
		m_nScreenHeight		= m_nScreenWidth;
		m_nScreenWidth		= iswap;
	    m_nScreenHeightSave = m_nScreenWidth;
	    m_nScreenWidthSave	= m_nScreenHeight;
		break;
		
	default:
	  	m_nScreenHeightSave = m_nScreenHeight;
		m_nScreenWidthSave 	= m_nScreenWidth;
		break;
    }
	return;
}
//------------------------------------------------------------------------------
//	SMT926DISP::DynRotate
//------------------------------------------------------------------------------
LONG 
SMT926DISP::
DynRotate(
int angle
)
{
	
	if (angle == m_iRotate) 
		return DISP_CHANGE_SUCCESSFUL;
	else					
		m_iRotate = angle;					
		
    GPESurfRotate *pSurf = (GPESurfRotate *)m_pPrimarySurface;
	switch(m_iRotate)
    {
    case DMDO_0:
    case DMDO_180:
		m_nScreenHeight = m_nScreenHeightSave;
		m_nScreenWidth	= m_nScreenWidthSave;
		break;
		
	case DMDO_90:
	case DMDO_270:
		m_nScreenHeight = m_nScreenWidthSave;
		m_nScreenWidth	= m_nScreenHeightSave;
		break;
    }

	m_pMode->width 	= m_nScreenWidth;
	m_pMode->height = m_nScreenHeight;
	pSurf->SetRotation(m_nScreenWidth, m_nScreenHeight, angle);

	return DISP_CHANGE_SUCCESSFUL;
}
#endif //DISP_ROTATE
