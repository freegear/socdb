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
#include "../base/typedefs.h"
#include "../drivers/driver.h"
#include "../fat/fat32_base.h"
#include "../fat/fat32_access.h"
#include "../file-dir-io/fatmisc.h"
#include "../file-dir-io/filestring.h"

extern void PutChar( unsigned char data );

//-----------------------------------------------------------------------------
// ListDirectory: Using starting cluster number of a directory and the FAT,
//				  list all directories and files 
//-----------------------------------------------------------------------------
void ListDirectory(UI32 StartCluster)
{
	byte i,item,index;
	word recordoffset;
	byte tempitem=0;
	byte LFNIndex=0;
	UI32 x=0;
	int statusreturned=0;
	  
  	FAT32.no_of_strings=0;
	FAT32.filenumber=0;
	Printf("\r\nNo . 	   Filename\r\n");
	
  
	while (statusreturned!= 1) // Do while not end of cluster chain
	{
		
		// Read Sector
		statusreturned = FAT32_SectorReader(StartCluster, x++);

		if (!statusreturned)
		{
			LFNIndex=0;
			for (item=0; item<=15;item++)
			{
		 		recordoffset = (32*item);
 
		 		// Long File Name Text Found
		 		if ( FATMisc_If_LFN_TextOnly(recordoffset) ) {
		 			FATMisc_cacheLFN(recordoffset);
		 		}
		 		// If Invalid record found delete any long 
		 		// file name information collated
		 		else 
		 		if ( FATMisc_If_LFN_Invalid(recordoffset) ) {
					FAT32.no_of_strings = 0;  
				}
		 		// Normal Entry and Long text exists 
		 		else 
		 		if ( FATMisc_If_LFN_Exists(recordoffset,FAT32.no_of_strings) )
			 	{
 	   	      		FAT32.filenumber++; //File / Dir Count
 	   	      		
		 	  		if (FATMisc_If_dir_entry(recordoffset)) 
		 	  			Printf("\r\nDirectory ");
		 	  			
    		  		if (FATMisc_If_file_entry(recordoffset)) 
    		  			Printf("\r\nFile ");

			  		// Print number of file or directory
			  		{
			  			if((char)FAT32.String[0][0] == 0xac) return;
			  		}
			  		for (index=0;index<FAT32.no_of_strings;index++) {
		 	  	  		for (i=0; i<13; i++) {
			 	  	  		PutChar(FAT32.String[index][i]);
			 	  	  	}
			 	  	}
				 
			  		// --- Print CLuster number
  			  		if (clusterprint) 
  			  			Printf("    Cluster Number 0x%lx", 
  			  					FATMisc_ClusterReassemble(recordoffset));
		 	  		FAT32.no_of_strings=0;		  
		 		}
		 		// Normal Entry, only 8.3 Text		 
		 		else if ( FATMisc_If_noLFN_SFN_Only(recordoffset) )
		 		{
       		  		FAT32.no_of_strings=0;
			  		FAT32.filenumber++; //File / Dir Count
			  		
		 	  		if (FATMisc_If_dir_entry(recordoffset)) 
		 	  			Printf("\r\nDirectory ");
		 	  			
    		  		if (FATMisc_If_file_entry(recordoffset)) 
    		  			Printf("\r\nFile ");
    		  	

			  		// Print number of file or directory
			  		Printf("%d -  ",FAT32.filenumber);
			  
			  		// Screen Print Name of file or directory
	  		 		for (i=0; i<8;i++)
					{
						if ((IDE_SectorByte(i+recordoffset))!=0x20) 
							PutChar((IDE_SectorByte(i+recordoffset)));
					}
			  
				  	// Dont Print dot seperator if is a directory
				  	if ((IDE_SectorByte(8+recordoffset)!=0x20) 
				  	 && (IDE_SectorByte(9+recordoffset)!=0x20) 
				  	 && (IDE_SectorByte(10+recordoffset)!=0x20) ) 
				  	 	PutChar('.');

		      		// Print 3 character extension
			  		for (i=8; i<11;i++)
					{
						if ((IDE_SectorByte(i+recordoffset))!=0x20) 
								PutChar((IDE_SectorByte(i+recordoffset)));
					}
				  
			  		// --- Print Cluster number
			  		if (clusterprint) 
			  			Printf("    Cluster Number 0x%lx", 
			  				FATMisc_ClusterReassemble(recordoffset));
		 		}
			}// end of for
		}
	}
} 

//-------------------------------------------------------------
// MatchName: This function can be improved... 
//-------------------------------------------------------------
UI32 MatchName(UI32 Cluster, char *nametofind)
{

	UI32 clusterchain=0;
	byte item=0;
	UI32 backupcluster=0;
	UI32 recordoffset = 0;
	UI32 ClustertoReturn = 0;
	byte index=0;
	byte i=0;
	int lfncount=0;
	int x=0;
	char LFNtoMatch[maxLFNlength];
	FAT32.no_of_strings = 0;

	// Main cluster following loop
	while (clusterchain!=1)
	{
		// Read sector
		clusterchain = FAT32_SectorReader(Cluster, x++);

	if (!clusterchain) // If sector read was successfull
	{
		// Analyse Sector
		for (item=0; item<=15;item++)
		{
			// Create the multiplier for sector access
			recordoffset = (32*item);

			// Long File Name Text Found
			if (FATMisc_If_LFN_TextOnly(recordoffset) ) FATMisc_cacheLFN(recordoffset);

			// If Invalid record found delete any long file name information collated
			else if (FATMisc_If_LFN_Invalid(recordoffset) ) FAT32.no_of_strings = 0;  

			// Normal SFN Entry and Long text exists 
			else if (FATMisc_If_LFN_Exists(recordoffset, FAT32.no_of_strings) ) 
				{

				// Copy LFN from LFN Cache into a string
				for (index=0;index<FAT32.no_of_strings;index++)
		 	  		for (i=0; i<13; i++)
						{
						// Check string isnt to long for array
						if (lfncount<maxLFNlength) LFNtoMatch[lfncount++] = FAT32.String[index][i];
						else 
							{
							Printf("\r\nError: LFN to long for string memory");
							}
						}

				// Null terminate string
				LFNtoMatch[lfncount]='\0';

				// Compare names to see if they match
				//Printf("%s --- %s\n", LFNtoMatch, nametofind);
				if (FileString_CompareNames(LFNtoMatch, nametofind)) 
					{
					ClustertoReturn = FATMisc_ClusterReassemble(recordoffset);
					return (ClustertoReturn);
					}

		 			FAT32.no_of_strings=0;
					lfncount = 0;
				}

			// Normal Entry, only 8.3 Text		 
			else if (FATMisc_If_noLFN_SFN_Only(recordoffset) )
				{
       			FAT32.no_of_strings=0;
			  
				// Copy name to string
				for (i=0; i<11;i++) LFNtoMatch[lfncount++] = IDE_SectorByte(i+recordoffset);

				// Null terminate string
				LFNtoMatch[lfncount]='\0';
	  			
				// Compare names to see if they match
				//Printf("%s --- %s\n", LFNtoMatch, nametofind);
				if (FileString_CompareNames(LFNtoMatch, nametofind)) 
					{
					ClustertoReturn = FATMisc_ClusterReassemble(recordoffset);
					return (ClustertoReturn);
					}

		 		FAT32.no_of_strings=0;
				lfncount = 0;
				}
			} // End of if
		} // End of for loop

	} // End of while loop

return 0;
}
