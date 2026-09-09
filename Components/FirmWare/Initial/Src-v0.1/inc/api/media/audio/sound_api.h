/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: sound_api.h
	Description		: 
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef __SOUND_API_H__
#define	__SOUND_API_H__
/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
//#include "../../../drivers/media/audio/audio_post_drv.h"
#include "audio_post_drv.h"

/*/////////////////////////////////////////////////////////
        DEFINE
///////////////////////////////////////////////////////// */
#define SOUND_WAV_MAX_OBJECT	(3)
/*/////////////////////////////////////////////////////////
        TYPEDEF
///////////////////////////////////////////////////////// */
//-----------------------------------------------------------
//	SOUND_WAV_VOLUME
//-----------------------------------------------------------
typedef enum
{
	SOUND_VOL_0,
	SOUND_VOL_1,
	SOUND_VOL_2,
	SOUND_VOL_3,
	SOUND_VOL_4,
	SOUND_VOL_5,
	SOUND_VOL_6,
	SOUND_VOL_7,
	SOUND_VOL_8,
	SOUND_VOL_9,
	SOUND_VOL_10,
	SOUND_VOL_11,
	SOUND_VOL_12,
	SOUND_VOL_13,
	SOUND_VOL_14,
	SOUND_VOL_15,
	SOUND_VOL_16,
	SOUND_VOL_17,
	SOUND_VOL_18,
	SOUND_VOL_19,
	SOUND_VOL_20,
	SOUND_VOL_21,	
	SOUND_VOL_22,
	SOUND_VOL_23,
	SOUND_VOL_24,
	SOUND_VOL_25,
	SOUND_VOL_26,
	SOUND_VOL_27,
	SOUND_VOL_28,
	SOUND_VOL_29,		
	SOUND_VOL_32B	= 0xFFFFFFFF
} SOUND_WAV_VOLUME;
//-----------------------------------------------------------
//	SOUND_WAV_CHANNEL
//-----------------------------------------------------------
typedef enum
{
	SOUND_CHANNEL_MONO,
	SOUND_CHANNEL_STEREO,
	SOUND_CHANNEL_32B	= 0xFFFFFFFF
} SOUND_WAV_CHANNEL;
//-----------------------------------------------------------
//	SOUND_WAV_MODE
//-----------------------------------------------------------
typedef enum
{
	SOUND_MODE_PLAY,
	SOUND_MODE_RECORD,
	SOUND_MODE_32B	= 0xFFFFFFFF
} SOUND_WAV_MODE;
//-----------------------------------------------------------
//	SOUNDWaveConfig
//-----------------------------------------------------------
typedef struct
{
	smtUint32 				bufferingSize;
	smtUint32				bufferSize;
	smtUint32				sampleRate;
	SOUND_WAV_VOLUME		vol;
	SOUND_WAV_CHANNEL		channel;
	SOUND_WAV_MODE			mode;
	
	void	(*fnWriteDoneCallback)(smtUint32);
	void	(*fnSoundEffector)(smtUint32);
} SOUNDWaveConfig;
//-----------------------------------------------------------
//	SOUNDWaveObject
//-----------------------------------------------------------
typedef struct
{

	SOUNDWaveConfig			config;
	volatile smtBoolean		needBuffering;
	volatile smtBoolean		lock;
	volatile smtUint32		writeSize;
	smtUint32				buffering;
	smtBoolean				run;
	void					*pQueueHandle;
	smtUint32				objectIdx;
} SOUNDWaveObject;
//-----------------------------------------------------------
//	PCMInternal
//-----------------------------------------------------------
typedef struct 
{
	smtInt32			playRun;
	smtInt32			recordRun;
	smtInt32			ObjectIdx;
	SOUNDWaveObject		*pObject[SOUND_WAV_MAX_OBJECT];
} SOUNDWaveInternal;

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////*/
extern void			SOUNDWaveInit(void);
extern void 		SOUNDWaveDeinit(void);
extern smtInt32		SOUNDWaveOpen(SOUNDWaveConfig *pconfig);
extern void			SOUNDWaveClose(smtInt32 handle);
extern smtUint32 	SOUNDWaveGetGain(smtInt32 handle);
extern void			SOUNDWaveSetGain(smtInt32 handle, SOUND_WAV_VOLUME vol);
extern smtInt32 	SOUNDWaveAvail(smtInt32 handle, smtUint32 size);
extern smtUint32	SOUNDWaveCount(smtInt32 handle);
extern void			SOUNDWavePause(smtInt32 handle, smtBoolean on);
extern void			SOUNDWaveStop(smtInt32 handle);
extern void			SOUNDWaveRun(smtInt32 handle, smtUint32 buffer, smtUint32 size);

extern SOUND_WAV_VOLUME SOUNDWaveMaterGetGain(SOUND_WAV_MODE mode);
extern void 			SOUNDWaveMaterSetGain(SOUND_WAV_MODE mode, SOUND_WAV_VOLUME vol);
extern smtBoolean		SOUNDWaveMaterGetMute(SOUND_WAV_MODE mode);
extern void				SOUNDWaveMaterSetMute(SOUND_WAV_MODE mode, smtBoolean on);


#endif
