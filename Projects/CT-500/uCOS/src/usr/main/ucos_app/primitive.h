/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: primitive.h
	Description	: 
----------------------------------------------------------*/
#ifndef __PRIMITIVE_H__
#define __PRIMITIVE_H__
/*
/////////////////////////////////////////////////////////
	INCLUDE
///////////////////////////////////////////////////////// 
*/

/*
/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// 
*/

typedef enum
{
	HWMENUKeypadInd,

	MENUDISPStartOverlayReq,
	MENUDISPStartDecJpegReq,
	MENUDISPStopDisplayReq,
	
	ISRDISPOverlay,
	ISRDISPJpegDec,
	
	DISPJPEGStartDecReq,
	DISPJPEGStopDecReq,
	
	JPEGStartDecLoopReq,
	
	JPEGDISPJpegDecInd,

	JPEGMENUTestInd
	
}PRIMITIVE;

typedef struct
{
	PRIMITIVE primitive;
	void *msg;
}MSGSTRUCT;
/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
#endif/*__PRIMITIVE_H__*/

