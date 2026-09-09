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
// FAT32 File IO Libraryi s distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with FAT32 File IO Library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
#include <string.h>
#include "../base/typedefs.h"
#include "../drivers/driver.h"
#include "../file-dir-io/filestring.h"

//-----------------------------------------------------------------------------
// FileString_Path_to_Folder: Takes a pointer to a string, and a sublevel 
//							 required to extract. The found directory is 
//							 returned in a pointer to a string.
//					         Returns 1 if sublevel to far, 0 is found.
//-----------------------------------------------------------------------------
int FileString_Path_to_Folder(char *Path, int levelreq, char *output)
{
	int i;
	int pathlen=0;
	int levels=0;
	int copypnt=0;

	// Get string length of Path
	pathlen = strlen (Path);

	// Loop through the number of times as characters in 'Path'
	for (i = 0; i<pathlen; i++)
		{
		// If a '\' is found then increase level
		if (*Path=='\\') levels++;

		// If correct level and the character is not a '\' then copy text to 'output'
		if ( (levels==levelreq) && (*Path!='\\') ) output[copypnt++] = *Path;

		// Increment through path string
		*Path++;
		}

	// Null Terminate
	output[copypnt] = '\0';

	// If a string was copied return 0 else return 1
	if (output[0]!='\0') 
		return 0;	// Found
	else
		return 1;	// Not Found
}

//-----------------------------------------------------------------------------
// FileString_PathTotalLevels: Count subdirs in path string
//							   A path is for example C:\Folder1\SubFolder2
//-----------------------------------------------------------------------------
int FileString_PathTotalLevels(char *path)
{
	int levels=0;

	// Count levels in path string
	while (*path)
	{
		// Fast forward through actual subdir text to next slash
		for (*path; *path;)
		{
			// If slash detected escape from for loop
			if (*path == '\\') { path++; break; }
			*path++;
		}
    
		// Increase number of subdirs founds
		levels++;
	}
	
	// Subtract the spurious last addition and return the value
	return levels - 1;
}

//-----------------------------------------------------------------------------
// FileString_SplitPath: Full path contains the passed in string. Returned is 
//			   			 the Path string and file Name string
//-----------------------------------------------------------------------------
void FileString_SplitPath(char *FullPath, char *Path, char *FileName)
{
  char *NameStart;
  char *s;
  
  // Move to end of FullPath  String
  for (s = FullPath; *s; s++);

  // Now move backward until '\' is found. The name starts after the '\' 
  for (; (*s != '\\') && (s != FullPath); s--);
  if (*s == '\\') s++;
  // And copy the string from this point until the end into Name 
  for (NameStart = s; (*FileName++ = *s++););
  // Finally we copy the portion of FullPath before the file name    
  // into Path, removing the non-root trailing backslash if present. 
  for (s = FullPath; s < NameStart; s++, Path++) *Path = *s;
  if ((NameStart > FullPath + 1) && (*(Path - 1) == '\\')) Path--;
  *Path = 0;
}

//-----------------------------------------------------------------------------
// FileString_CompoundSpaces: Take the source string and remove trailing spaces
//							  before and after the extension (if exists).
//-----------------------------------------------------------------------------
void FileString_CompoundSpaces(char* source, char *dest, int removemidspace)
{
	// Rules
	// - Dont remove space between words
	// - Dont care about pre-string space
	// - Remove spaces between last word and possible extension (if removemidspace=1)
	// - Remove space after extension or last word	

	int i,j;
	int inputStringLength;
	int lastNonSpacePos=0;
	int midNonSpace=0;
	int lastDotPos=0;

	// Find total string length of source string
	inputStringLength = strlen(source);

	// Convert string to all lowercase
	//for (i=0;i<inputStringLength;i++) 
		//if ( (source[i]>64) && (source[i]<91) ) (source[i])=+32;

	// Find last position in string which is not a string
	i = inputStringLength;
	while (i!=0)
	{
		if (source[--i]!=' ') break;
	}
	lastNonSpacePos = i + 1;

	// Find last '.' in string (if at all)
	i = lastNonSpacePos;
	while (i!=0)
	{
		if (source[--i]=='.') break;
	}
	lastDotPos = i + 1;


	// If removemidspace=1 remove spaces last character before extension
	if (removemidspace)
	{
		// Find last non space character before '.'
		for (i=0; i<lastDotPos-1; i++)
			if (source[i]!=' ') midNonSpace = i + 1;
	}
	else
		midNonSpace = lastDotPos - 1;

	// Copy from beginning of string upto nonspace before '.'
	for (i = 0; i < midNonSpace; i++)
		dest[i]=source[i];

	// Set indicie of next char in destination string
	j = i;

	// Copy from last '.' to the last non space character
	for (i = lastDotPos-1; i < lastNonSpacePos; i++)
		dest[j++]=source[i];

	dest[j] = '\0';
}

//-----------------------------------------------------------------------
// FileString_CompareName: Compare two filenames to see if they match
//-----------------------------------------------------------------------
int FileString_CompareNames(char* name1, char* name2)
{
	char name1_nospace[maxLFNlength], name2_nospace[maxLFNlength];

	// Crop both strings for excess end spaces
	// Note: You can use the same destination and source for this
	FileString_CompoundSpaces(name1, name1_nospace, 0);
	FileString_CompoundSpaces(name2, name2_nospace, 0);
	
	// Compare both strings and return 1 if they match
	if (!strcmp(name1_nospace, name2_nospace) ) 
	{
		return 1;
	}
	else
		return 0;
}
