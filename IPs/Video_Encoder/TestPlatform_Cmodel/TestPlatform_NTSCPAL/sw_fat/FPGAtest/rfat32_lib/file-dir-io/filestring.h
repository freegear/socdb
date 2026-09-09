//-----------------------------------------------------------------------------
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
//-----------------------------------------------------------------------------
#ifndef _FILESTRING_H_
#define	_FILESTRING_H_
//-----------------------------------------------------------------------------
// Prototypes
//-----------------------------------------------------------------------------
int 	FileString_Path_to_Folder(char *Path, int levelreq, char *output);
int 	FileString_PathTotalLevels(char *path);
void 	FileString_SplitPath(char *FullPath, char *Path, char *FileName);
void 	FileString_CompoundSpaces(char* source, char *dest, int removemidspace);
int 	FileString_CompareNames(char* name1, char* name2);

// Max filename Length 
#define maxLFNlength	100

#endif
