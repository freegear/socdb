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
/*++
THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
PARTICULAR PURPOSE.

Module Name:  

    emulutil.cpp

Abstract:  

    Contains bits and pieces required by the emulation functions.

Functions:


Notes:


--*/

#include "precomp.h"

const BYTE bFillMaskLeft[] =
{
	0xff,
	0x3f,
	0x0f,
	0x03
};

const BYTE bFillMaskRight[] =
{
	0xff,
	0xc0,
	0xf0,
	0xfc
};


BYTE *
GetBltBuffer(
	int cb
	)
{
	//
	// Need to allocate a buffer large enough for one scanline (plus a 
	// little spare).  Note that we only realloc when a wider blt comes
	// along.
	//
	static DWORD * pdwBuf;
	static int     cbMax  = -1;

	if (cb > cbMax)
	{
		cbMax = cb;

		//
		// Allocate the buffer DWORD-aligned, even though we
		// return it as a BYTE*.  This way callers may perform
		// DWORD-stride operations.
		//
		delete [] pdwBuf;
		pdwBuf = new DWORD[(cb + 3) >> 2];

		// If allocation failed, try again next time
		if (pdwBuf == NULL)
		{
			cbMax = -1;
		}
	}

	return (BYTE *)pdwBuf;
}
