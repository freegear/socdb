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
//			
//			  2006-10-24 1:44AM first implement
//------------------------------------------------------------------------------
#ifndef __SMT926_LCD_H__
#define __SMT926_LCD_H__

#include	<windows.h>
#include	<winddi.h>
#include	<gpe.h>
#include	<emul.h>
#include 	<../../inc/smt926a_lcd.h>
#ifdef DISP_CLEARTYPE
#include 	<ctblt.h>
#endif

#ifdef DISP_ROTATE
class SMT926DISP : public GPERotate
#else
class SMT926DISP : public GPE
#endif //DISP_ROTATE
{
private:
	GPEMode			m_ModeInfo;
	DWORD			m_cbScanLineLength;
	DWORD			m_colorDepth;
	DWORD			m_PhysicalFrameBuffer;
	DWORD			m_VirtualFrameBuffer;
	DWORD			m_PhysicalCursorBuffer;
	DWORD			m_VirtualCursorBuffer;
	DWORD			m_FrameBufferSize;
	BOOL			m_CursorDisabled;
	BOOL			m_CursorVisible;
	BOOL			m_CursorForcedOff;
	RECTL			m_CursorRect;
	POINTL			m_CursorSize;
	POINTL			m_CursorHotspot;
	UCHAR			*m_CursorBackingStore;
	UCHAR			*m_CursorXorShape;
	UCHAR			*m_CursorAndShape;

	volatile SMT926A_LCD_REG *m_LCDRegs;

public:
					SMT926DISP(void);
					
	virtual INT		NumModes(void);
	virtual SCODE	SetMode(INT modeId,	HPALETTE *palette);
	
	virtual INT		InVBlank(void);
	virtual SCODE	SetPalette(const PALETTEENTRY *source, USHORT firstEntry,
								USHORT numEntries);
	virtual SCODE	GetModeInfo(GPEMode *pMode,	INT modeNumber);
	virtual SCODE	SetPointerShape(GPESurf *mask, GPESurf *colorSurface,
									INT xHot, INT yHot, INT cX, INT cY);
	virtual SCODE	MovePointer(INT xPosition, INT yPosition);
	virtual void	WaitForNotBusy(void);
	virtual INT		IsBusy(void);
	virtual void	GetPhysicalVideoMemory(ULONG *physicalMemoryBase, ULONG *videoMemorySize);
	virtual SCODE	AllocSurface(GPESurf **surface, INT width, INT height,
									EGPEFormat format, INT surfaceFlags);
	virtual SCODE	Line(GPELineParms *lineParameters, EGPEPhase phase);
	virtual SCODE	BltPrepare(GPEBltParms *blitParameters);
	virtual SCODE	BltComplete(GPEBltParms *blitParameters);
	virtual ULONG	GetGraphicsCaps();
#if defined(DISP_CLEARTYPE) || defined(DISP_ROTATE)
	virtual ULONG   DrvEscape(SURFOBJ *pso, ULONG iEsc, ULONG  cjIn, PVOID pvIn, ULONG cjOut, PVOID pvOut);
#endif 
	SCODE			WrappedEmulatedLine (GPELineParms *lineParameters);
	void			CursorOn (void);
	void			CursorOff (void);

	void			InitializeHardware (void);
#ifdef DISP_ROTATE
	void SetRotateParms();
	LONG DynRotate(int angle);
#endif //DISP_ROTATE
};

#endif // __SMT926_LCD_H__.

