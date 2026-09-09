//-----------------------------------------------------------------------------
//					    FAT32 File IO Library for AVR 
//								  V0.1c
// 	  							Rob Riglar
//							Copyright 2003,2004 
//
//   					  Email: rob@robriglar.com
//
//			    Compiled with Imagecraft C Compiler for the AVR series
//-----------------------------------------------------------------------------
//
// This file is part of FAT32 File IO Library.
//
// FAT32 File IO Library is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// FAT32 File IO Library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with FAT32 File IO Library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//-----------------------------------------------------------------------------
//	code name 	: knight - read only simple file system port
//	author		: bf109up
//-----------------------------------------------------------------------------
#include <stdio.h>
#include "../base/typedefs.h"
#include "../drivers/driver.h"
#include "ide_access.h"

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */

#include "sysinc.h"
#include "Commonmacro.h"
#include "irq.h"
#include "lib.h"
#include "adc.h"


IDE_DATA 	IDE_Internal;
//-----------------------------------------------------------------------------
// IDE_SectorByte: Function is used to retrieve a byte from the 'currentsector'
// array. The value passed in must be between 0 - 511.
//
// Parameters: Word location within currentsector
//
// Returns: Byte of data requested from currentsector
//
// Port: read 8bit from IDE buffer 512
//-----------------------------------------------------------------------------
byte IDE_SectorByte(word sublocation)
{
// NOTE: This function is to be used whereever access to currentsector is required
//  	 by all layers that are higher than the IDE Base functions.
	byte data=0;          
    data=IDE_Internal.currentsector[sublocation];	  // Read Data from specified pos
	return (data);
}
//-----------------------------------------------------------------------------
// IDE_SectorCopy: Function is used to retrieve a byte from the 'currentsector'
//-----------------------------------------------------------------------------
void IDE_SectorCopy(unsigned int pbuffer)
{
	
	memcpy((void*)pbuffer, (void*)IDE_Internal.currentsector, 512);
}

//-----------------------------------------------------------------------------
// IDE_SectorWord: Function is used to retrieve a word from the 'currentsector'
// array. The value passed in must be between 0 - 510.
//
// Parameters: Word location within currentsector
//
// Returns: Word of data requested from currentsector
//
// Port: read 16bit from IDE buffer 512
//-----------------------------------------------------------------------------
word IDE_SectorWord(word sublocation) // Return Word at position specified
{
	 word data=0; 
	 word tempword=0;
	   
	 tempword = IDE_SectorByte(sublocation+1); // Get MSB from Buffer
	 tempword<<=8;							 // Make MSB word half into byte
	 data = IDE_SectorByte(sublocation) + tempword; // Combine LSB and MSB

	 return (data);					  			 // Return value
}

//-----------------------------------------------------------------------------
// IDE_SectorUI32: Function is used to retrieve a 32 bit value from the 
// 'currentsector' array. The value passed in must be between 0 - 511.
//
// Parameters: Word offset within current sector
//
// Returns: 32 bit unsigned data as requested
//
// Functions Used: None
//
// Port: read 32bit from IDE buffer 512
//-----------------------------------------------------------------------------
UI32 IDE_SectorUI32(word sublocation) // Return UI32 at position specified
{
    UI32 data=0; 
	UI32 A,B,C,D;
	
	A= IDE_SectorByte(sublocation);		// Read the four bytes which make up
	B= IDE_SectorByte(sublocation+1);    // the 32-bit value
	C= IDE_SectorByte(sublocation+2);
	D= IDE_SectorByte(sublocation+3);         

    data=(D<<=24) + (C<<=16) + (B<<=8) + A; //Combine into correct order
	return (data);					  			 // Return value
}

//-----------------------------------------------------------------------------
// IDE_BufferSector: This function recieves the LBA address of a sector and reads into
// an array of 512 bytes (1 sector) called 'currentsector'.
//
// Parameters: 32bit Unsigned Logical Block Address
//
// Returns: An integer error code: 1 means read successfull, 0 means read fail.
//
// Functions Used: WriteReg, CheckforError, ReadErrors, Wait_DRQ, Set_Address, 
// 			 	   DataInputSetup, Printf
// Port: read sector by LBA
//-----------------------------------------------------------------------------
int IDE_BufferSector(UI32 LBALocation)
{

	extern void SD_TestRead(unsigned int BlockAddress, unsigned int Trg);	

	UI16    i;
	
	/*
	if (LBALocation>=IDE_Internal.maxLBA) 
	   {
	   Printf("\r\nIDE_BufferSector: Out of Range Disc Read of 0x%lx", LBALocation);
	   // Return failure
	   return 0;
	   }
	 */
	
	// Dont reload if already loaded
	if (IDE_Internal.SectorCurrentlyLoaded!=LBALocation) 
	{              
		
		//GPIO_Write(LBALocation);		
		IDE_Internal.SectorCurrentlyLoaded = LBALocation; // update current sector loaded
    	SD_TestRead(
    				(unsigned int)LBALocation*512, 
    				(unsigned int)IDE_Internal.currentsector);
	
	}
	
	// Return Success
	return 1;	
	
	return 1;	
}

//-----------------------------------------------------------------------------
// IDE_PowerOn: Function set port directions, default values of output pins
// and performs a Hard Reset
// Port: reset IDE port and set SectorCurrentlyLoaded value
//-----------------------------------------------------------------------------
void IDE_Reset(void)
{
	Printf("IDE_Reset!!!\n");
	IDE_Internal.SectorCurrentlyLoaded = 0xffffffff;
}

//-----------------------------------------------------------------------------
// InitDrive: Drive Initialisation routine, required before you use the drive 
// for reading or writting to the actual media. 
// Port: initialize IDE device, tranmode, and get device identify,
//		  currently, fixed LBA byte 1024
//-----------------------------------------------------------------------------
void IDE_InitDrive(void)
{	
	
	extern smtBoolean SDMMCInitialize(void);
	
	SDMMCInitialize();
	IDE_Internal.maxLBA = 0xffffffff;
	Printf("IDE_InitDrive!!!\n");
}
