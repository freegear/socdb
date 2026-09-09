/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: audio_post_drv.h
	Description		: 
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef __AUDIO_POST_DRV_H__
#define	__AUDIO_POST_DRV_H__
/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
#define	AUDIO_BUFFER_SIZE	(64*1024)
#define	AUDIO_BUFFER_NUM	(2)
/*/////////////////////////////////////////////////////////
        TYPEDEF
///////////////////////////////////////////////////////// */
/*----------------------------------------------------------
	AUDIO_VOLUME
-----------------------------------------------------------*/
typedef enum 
{
	AUDIO_VOL_0,
	AUDIO_VOL_1,
	AUDIO_VOL_2,
	AUDIO_VOL_3,
	AUDIO_VOL_4,
	AUDIO_VOL_5,
	AUDIO_VOL_6,
	AUDIO_VOL_7,
	AUDIO_VOL_8,
	AUDIO_VOL_9,
	AUDIO_VOL_10,
	AUDIO_VOL_11,
	AUDIO_VOL_12,
	AUDIO_VOL_13,
	AUDIO_VOL_14,
	AUDIO_VOL_15,
	AUDIO_VOL_16,
	AUDIO_VOL_17,
	AUDIO_VOL_18,
	AUDIO_VOL_19,
	AUDIO_VOL_20,
	AUDIO_VOL_21,
	AUDIO_VOL_22,
	AUDIO_VOL_23,
	AUDIO_VOL_24,
	AUDIO_VOL_25,
	AUDIO_VOL_26,
	AUDIO_VOL_27,
	AUDIO_VOL_28,
	AUDIO_VOL_29,
	AUDIO_VOL_MAX,
	AUDIO_VOL_32B	= 0xFFFFFFFF
	
} AUDIO_VOLUME;
/*----------------------------------------------------------
	AUDIO_MODE
-----------------------------------------------------------*/
typedef enum
{
	AUDIO_MODE_RX	= 0x1,
	AUDIO_MODE_TX	= 0x2,
	AUDIO_MODE_32B	= 0xFFFFFFFF
	
} AUDIO_MODE;
/*----------------------------------------------------------
	AUDIO_BUFFER
-----------------------------------------------------------*/
typedef struct 
{
	
	smtUint32	bufferAddr;		// Audio buffer
	
} AUDIO_BUFFER;

/*----------------------------------------------------------
	AUDIO_CONFIG
-----------------------------------------------------------*/
typedef struct 
{
	AUDIO_BUFFER	buffer[AUDIO_BUFFER_NUM];
	
	smtUint32 		sampleRate;
	smtUint32 		bufferSize;	
	void 			(*pAudioHandle)(smtUint32 address);
	void 			(*pAudioFIFOEvent)(void);
	
	smtUint8 		sampleBitWidth;
	smtUint8 		channel;
	smtUint8 		bufferNum;

	
} AUDIO_CONFIG;
/*----------------------------------------------------------
	AUDIO_DEV_INFO
-----------------------------------------------------------*/
typedef struct 
{
	AUDIO_CONFIG	config;
	smtUint8		volume;
	smtUint8		bufferIdx;
	smtBoolean 		muteStatus;
	smtBoolean		runStatus;
	
} AUDIO_DEV_INFO;

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////*/
//-----------------------------------------------------------
// audio(PCM) post driver extern header
//
//	- smt2AudioInit/smt2AudioDeinit
// 	- smt2AudioSetConfig/smt2AudioGetConfig
//	- smt2AudioSetVolume/smt2AudioGetVolume
//	- smt2AudioGetMute/smt2AudioSetMute
//	- smt2AudioPause/smt2AudioStop/smt2AudioRun
//
//-----------------------------------------------------------
extern smtUint32 	smt2AudioInit(void);
extern smtUint32 	smt2AudioDeinit(void);
extern smtUint32 	smt2AudioSetConfig(AUDIO_MODE mode, AUDIO_CONFIG *pconfig);
extern smtUint32 	smt2AudioGetConfig(AUDIO_MODE mode, AUDIO_CONFIG *pconfig);
extern smtUint32 	smt2AudioSetVolume(AUDIO_MODE mode, AUDIO_VOLUME level);
extern smtUint32 	smt2AudioSetVolume(AUDIO_MODE mode, AUDIO_VOLUME level);
extern AUDIO_VOLUME	smt2AudioGetVolume(AUDIO_MODE mode);
extern smtUint32	smt2AudioGetMute(AUDIO_MODE mode);
extern smtUint32 	smt2AudioSetMute(AUDIO_MODE mode, smtUint32 enable);
extern smtUint32 	smt2AudioPause(AUDIO_MODE mode);
extern smtUint32 	smt2AudioStop(AUDIO_MODE mode);
extern smtUint32	smt2AudioRun(AUDIO_MODE mode);

#endif
