/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : display test memory map.h 
	Description : display test memory map description.
	Created by  : SHMT SOC Team
------------------------------------------------------------------------------*/

/*
//////////////////////////////////////////////////////////////////////////////
        DEFINITIOIN
//////////////////////////////////////////////////////////////////////////////
*/
#define DDRRAM_STARTADDR	(0x63000000)
#define DDRRAM_USER			(DDRRAM_STARTADDR+0*1024*1024)
#define FRAME_BASEADDR		(DDRRAM_USER)
#define CURSOR_BASEADDR		(FRAME_BASEADDR)					// 2MB for Cursor plane 
#define GRAPHIC_BASEADDR	(CURSOR_BASEADDR     +2*1024*1024)	// 2MB for Graphic plane	
#define VIDEO_BASEADDR		(GRAPHIC_BASEADDR	 +2*1024*1024)	// 4MB for Video plane	
#define VIDEO_SRC0_BASEADDR (VIDEO_BASEADDR		 +4*1024*1024)	// 4MB for Video panorama0	
#define VIDEO_SRC1_BASEADDR (VIDEO_SRC0_BASEADDR +4*1024*1024)	// 4MB for Video panorama1	

