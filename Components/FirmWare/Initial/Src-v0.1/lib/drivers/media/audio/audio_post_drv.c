/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: audio_post_drv.c
	Description		: 
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/
/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "lib.h"
#include "audio_post_drv.h"
/*/////////////////////////////////////////////////////////
        VARIABLE
///////////////////////////////////////////////////////////*/
static AUDIO_DEV_INFO	sRXDeviceInfo;
static AUDIO_DEV_INFO	sTXDeviceInfo;
/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////*/
/*----------------------------------------------------------
	smt2AudioRXDataHandler
-----------------------------------------------------------*/
void smt2AudioRXDataHandler(void)
{
	
	
	if(sRXDeviceInfo.runStatus) 
	{
		AUDIO_CONFIG		*pconfig = &sRXDeviceInfo.config;
		
		// write 
		
		//DMATrans(pconfig->buffer[sRXDeviceInfo.buffferIdx].bufferAddr,
		//		   I2S_TARGET,
		//		   sRXDeviceInfo.config.bufferSize)
		//			
		sRXDeviceInfo.bufferIdx++;
		sRXDeviceInfo.bufferIdx %= sRXDeviceInfo.config.bufferNum;
	
		// read
		sRXDeviceInfo.config.pAudioHandle(
			pconfig->buffer[sRXDeviceInfo.bufferIdx].bufferAddr
		);
	} 
}
/*----------------------------------------------------------
	smt2AudioTXDataHandler
-----------------------------------------------------------*/
void smt2AudioTXDataHandler(void)
{
	if(sTXDeviceInfo.runStatus) 
	{
		AUDIO_CONFIG		*pconfig = &sTXDeviceInfo.config;
		// write 
		
		//DMATrans(pconfig->buffer[sRXDeviceInfo.buffferIdx].bufferAddr,
		//		   I2S_TARGET,
		//		   sRXDeviceInfo.config.bufferSize)
		//			
		sTXDeviceInfo.bufferIdx++;
		sTXDeviceInfo.bufferIdx %= sTXDeviceInfo.config.bufferNum;
	
		// read
		sTXDeviceInfo.config.pAudioHandle(
			pconfig->buffer[sTXDeviceInfo.bufferIdx].bufferAddr
		);
	}
		
	
}
/*----------------------------------------------------------
	smt2AudioUnderRunHandler
-----------------------------------------------------------*/
void smt2AudioUnderRunHandler(void)
{
	if(sRXDeviceInfo.runStatus) 
	{	
		sRXDeviceInfo.config.pAudioFIFOEvent();
	} 
	
	
}
/*----------------------------------------------------------
	smt2AudioOverRunHandler
-----------------------------------------------------------*/
void smt2AudioOverRunHandler(void)
{
	if(sTXDeviceInfo.runStatus) 
	{
		sTXDeviceInfo.config.pAudioFIFOEvent();
	}
}
/*----------------------------------------------------------
	smt2AudioInit
-----------------------------------------------------------*/
smtUint32 smt2AudioInit(void)
{
	
	
	// todo: stop DMA
	
	// todo: init DMA
	
	// todo: init audio IF 
	
	// todo: init audio codec
	
	// todo: init software index
	sRXDeviceInfo.volume 		= 0;
	sRXDeviceInfo.muteStatus 	= 0;
	sRXDeviceInfo.runStatus		= 0;
	sRXDeviceInfo.bufferIdx		= 0;
	
	sTXDeviceInfo.volume 		= 0;
	sTXDeviceInfo.muteStatus 	= 0;
	sTXDeviceInfo.runStatus		= 0;
	sTXDeviceInfo.bufferIdx		= 0;
	
	return 0;
}
/*----------------------------------------------------------
	smt2AudioDeinit
-----------------------------------------------------------*/
smtUint32 smt2AudioDeinit(void)
{
	// todo: stop DMA
	
	// todo: off Audio codec
	
	return 0;
}
/*----------------------------------------------------------
	smt2AudioSetConfig
-----------------------------------------------------------*/
smtUint32 smt2AudioSetConfig(AUDIO_MODE mode, AUDIO_CONFIG *pconfig)
{
	
	smtUint32 bufferIdx;
	
	
	if(mode == AUDIO_MODE_RX) 
	{
	
		// todo: insert audio codec control code
		// 1. set sample rate
		// 2. set sample bit width
		// 3. set channel
	
		sRXDeviceInfo.config.sampleRate 		= pconfig->sampleRate;
		sRXDeviceInfo.config.sampleBitWidth 	= pconfig->sampleBitWidth;
		sRXDeviceInfo.config.channel 			= pconfig->channel;
		
		sRXDeviceInfo.config.bufferSize 		= pconfig->bufferSize;
		sRXDeviceInfo.config.bufferNum 			= pconfig->bufferNum;
		for(bufferIdx = 0; bufferIdx < AUDIO_BUFFER_NUM; bufferIdx++) 
		{
			sRXDeviceInfo.config.buffer[bufferIdx] = pconfig->buffer[bufferIdx];
		}	
		
		sRXDeviceInfo.config.pAudioHandle 		= pconfig->pAudioHandle;
		sRXDeviceInfo.config.pAudioFIFOEvent 	= pconfig->pAudioFIFOEvent;
		
		
		// todo: set buffer size for DMA
	
	} 
	else if(mode == AUDIO_MODE_TX) 
	{
	
		// todo: insert audio codec control code
		// 1. set sample rate
		// 2. set sample bit width
		// 3. set channel
	
		sTXDeviceInfo.config.sampleRate 		= pconfig->sampleRate;
		sTXDeviceInfo.config.sampleBitWidth 	= pconfig->sampleBitWidth;
		sTXDeviceInfo.config.channel 			= pconfig->channel;
		
		sTXDeviceInfo.config.bufferSize 		= pconfig->bufferSize;
		sTXDeviceInfo.config.bufferNum 		= pconfig->bufferNum;
		for(bufferIdx = 0; bufferIdx < AUDIO_BUFFER_NUM; bufferIdx++) 
		{
			sTXDeviceInfo.config.buffer[bufferIdx] = pconfig->buffer[bufferIdx];
		}	
		
		sTXDeviceInfo.config.pAudioHandle 		= pconfig->pAudioHandle;
		sTXDeviceInfo.config.pAudioFIFOEvent 	= pconfig->pAudioFIFOEvent;
		
		
		// todo: set buffer size for DMA
	
	} 
	

	
	
	
	
	return 0;
}
/*----------------------------------------------------------
	smt2AudioGetConfig
-----------------------------------------------------------*/
smtUint32 smt2AudioGetConfig(AUDIO_MODE mode, AUDIO_CONFIG *pconfig)
{
	smtUint32 bufferIdx;
	
	if(mode == AUDIO_MODE_RX) 
	{
		pconfig->sampleRate 	= sRXDeviceInfo.config.sampleRate;
		pconfig->sampleBitWidth = sRXDeviceInfo.config.sampleBitWidth;
		pconfig->channel 		= sRXDeviceInfo.config.channel;
	
		pconfig->bufferNum 		= sRXDeviceInfo.config.bufferNum;
		pconfig->bufferSize 	= sRXDeviceInfo.config.bufferSize;
		for(bufferIdx = 0; bufferIdx < AUDIO_BUFFER_NUM; bufferIdx++) 
		{
			pconfig->buffer[bufferIdx] = sRXDeviceInfo.config.buffer[bufferIdx];
		}
	
		pconfig->pAudioHandle 		= sRXDeviceInfo.config.pAudioHandle;
		pconfig->pAudioFIFOEvent 	= sRXDeviceInfo.config.pAudioFIFOEvent;
	}
	else if(mode == AUDIO_MODE_TX) 
	{
		pconfig->sampleRate 	= sTXDeviceInfo.config.sampleRate;
		pconfig->sampleBitWidth = sTXDeviceInfo.config.sampleBitWidth;
		pconfig->channel 		= sTXDeviceInfo.config.channel;
	
		pconfig->bufferNum 		= sTXDeviceInfo.config.bufferNum;
		pconfig->bufferSize 	= sTXDeviceInfo.config.bufferSize;
		for(bufferIdx = 0; bufferIdx < AUDIO_BUFFER_NUM; bufferIdx++) 
		{
			pconfig->buffer[bufferIdx] = sTXDeviceInfo.config.buffer[bufferIdx];
		}
	
		pconfig->pAudioHandle 		= sTXDeviceInfo.config.pAudioHandle;
		pconfig->pAudioFIFOEvent 	= sTXDeviceInfo.config.pAudioFIFOEvent;
	}
	
	return 0;
}
/*----------------------------------------------------------
	smt2AudioSetVolume
-----------------------------------------------------------*/
smtUint32 smt2AudioSetVolume(AUDIO_MODE mode, AUDIO_VOLUME level)
{

	if(mode == AUDIO_MODE_RX) 
	{
		
		// todo: insert audio codec control code
		// for set volume level
	
		sRXDeviceInfo.volume = level;
	}
	else if(mode == AUDIO_MODE_TX) 
	{
		// todo: insert audio codec control code
		// for set volume level
	
		sTXDeviceInfo.volume = level;
	}
	
	return 0;
}
/*----------------------------------------------------------
	smt2AudioGetVolume
-----------------------------------------------------------*/
AUDIO_VOLUME smt2AudioGetVolume(AUDIO_MODE mode)
{
	

	if(mode == AUDIO_MODE_RX) 
	{
		
		// todo: insert audio codec control code
		// for set volume level
	
		return sRXDeviceInfo.volume;
	}
	else if(mode == AUDIO_MODE_TX) 
	{
		// todo: insert audio codec control code
		// for set volume level
	
		return sTXDeviceInfo.volume;
	}
	
	// never get here
	return 0;
}
/*----------------------------------------------------------
	smt2AudioGetMute
-----------------------------------------------------------*/
smtUint32 smt2AudioGetMute(AUDIO_MODE mode)
{
	
	if(mode == AUDIO_MODE_RX) 
	{
		
		return sRXDeviceInfo.muteStatus;
	}
	else if(mode == AUDIO_MODE_TX) 
	{	
		return sTXDeviceInfo.muteStatus;
	}	
	
	return 0;
}
/*----------------------------------------------------------
	smt2AudioSetMute
-----------------------------------------------------------*/
smtUint32 smt2AudioSetMute(AUDIO_MODE mode, smtUint32 enable)
{
	
	if(smt2AudioGetMute(mode))
	{
		 return 0;
	}

	if(mode == AUDIO_MODE_RX) 
	{
		
		// todo: insert audio codec control code
		// for set mute
			
		sRXDeviceInfo.muteStatus = enable;
		
		return 0;
	}
	else if(mode == AUDIO_MODE_TX) 
	{
		// todo: insert audio codec control code
		// for set volume level
	
		sTXDeviceInfo.muteStatus = enable;
		
		return 0;
	}
		
	
	// never get here
	return 0;
}
/*----------------------------------------------------------
	smt2AudioPause
-----------------------------------------------------------*/
smtUint32 smt2AudioPause(AUDIO_MODE mode)
{
	
	if(mode == AUDIO_MODE_RX) 
	{
		
		sTXDeviceInfo.runStatus = 0;
		// todo: RX DMA wait end
		
		return 0;
	}
	else if(mode == AUDIO_MODE_TX) 
	{
		sTXDeviceInfo.runStatus = 0;
		// todo: TX DMA wait end
		
		return 0;
	}	
	
	
	
	return 0;
}
/*----------------------------------------------------------
	smt2AudioStop
-----------------------------------------------------------*/
smtUint32 smt2AudioStop(AUDIO_MODE mode)
{
	
	smt2AudioPause(mode);
	

	if(mode == AUDIO_MODE_RX) 
	{
		
		// todo: RX DMA stop
	
		// todo: reset audio IF RX
	
		// todo: reset audio codec RX
	
		// todo: reset buffer and clear RX buffer idx
		sRXDeviceInfo.bufferIdx = 0;		
		
		return 0;
	}
	else if(mode == AUDIO_MODE_TX) 
	{
		// todo: TX DMA stop
	
		// todo: reset audio IF TX
	
		// todo: reset audio codec TX
	
		// todo: reset buffer and clear TX buffer idx
		sTXDeviceInfo.bufferIdx = 0;		

		return 0;
	}	

	// never get here	
	return 0;
}
/*----------------------------------------------------------
	smt2AudioRun
-----------------------------------------------------------*/
smtUint32 smt2AudioRun(AUDIO_MODE mode)
{
	

	if(mode == AUDIO_MODE_RX) 
	{
		
		
		
		sRXDeviceInfo.runStatus = 1;
		// todo: DMA write first
		
		return 0;
	}
	else if(mode == AUDIO_MODE_TX) 
	{
		
		sTXDeviceInfo.runStatus = 1;
		// todo: control audio codec
		
		return 0;
	}	

	// never get here	
	return 0;
	
}