/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: sound_api.c
	Description		: 
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/
/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sound_api.h"
/*/////////////////////////////////////////////////////////
        DEFINE
///////////////////////////////////////////////////////// */
#define	SOUND_WAVE_PLAY_BITWIDTH			(16)
#define	SOUND_WAVE_PLAY_CHANNEL				(2)
#define	SOUND_WAVE_PLAY_SAMPLERATE			(44100)
#define	SOUND_WAVE_PLAY_BUF_NUM				(2)
#define	SOUND_WAVE_PLAY_BUF_SIZE			(8192)
#define	SOUND_WAVE_PLAY_GAIN_MAX			(30)

#define	SOUND_WAVE_RECORD_BITWIDTH			(16)
#define	SOUND_WAVE_RECORD_CHANNEL			(2)
#define	SOUND_WAVE_RECORD_SAMPLERATE		(44100)
#define	SOUND_WAVE_RECORD_BUF_NUM			(2)
#define	SOUND_WAVE_RECORD_BUF_SIZE			(8192)
#define	SOUND_WAVE_RECORD_GAIN_MAX			(30)

/*/////////////////////////////////////////////////////////
        TYPEDEF
///////////////////////////////////////////////////////// */
typedef struct
{
	smtInt32		HeadPointer;
	smtInt32		TailPointer;
	smtInt32		RemainSize;
	smtInt32		UsedSize;
	smtInt32		BufferSize;
	smtUint8		*pStreamBuffer;
	
} StreamQueue;
/*/////////////////////////////////////////////////////////
        VARIABLE
///////////////////////////////////////////////////////////*/
static SOUNDWaveInternal internal;
/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////*/
/*----------------------------------------------------------
	CreateQueue
-----------------------------------------------------------*/
static void* CreateQueue(smtUint32 bufferSize)
{
	StreamQueue *pHandle;

	pHandle = (void*)malloc(sizeof(StreamQueue));	
	
	pHandle->HeadPointer 	= 0;
	pHandle->TailPointer 	= 0;
	pHandle->UsedSize		= 0;
	pHandle->RemainSize		= bufferSize;
	pHandle->BufferSize		= bufferSize;
	pHandle->pStreamBuffer	= (void*)malloc(sizeof(smtInt8)*bufferSize);

	return (void*)pHandle;
}
/*----------------------------------------------------------
	DestroyQueue
-----------------------------------------------------------*/
static void DestroyQueue(void *phandle)
{
	StreamQueue *pHandle = (StreamQueue*)phandle;
	
	free(pHandle->pStreamBuffer);
	free(pHandle);
}
/*----------------------------------------------------------
	QueueWrite
-----------------------------------------------------------*/
static smtInt32 QueueWrite(void *phandle, void *psrc, smtUint32 len)
{
	smtInt32 SrcIdx, TrgIdx;
	smtUint8 *pTrg;
	smtUint8 *pSrc;
	StreamQueue *pHandle = (StreamQueue*)phandle;
	
	// check buffer overflow
	// if buffer overflow state then don't write date to FIFO
	if(pHandle->RemainSize < len) return 0;
	
	// write buffer, check linear, need 4byte align
	pTrg	= pHandle->pStreamBuffer;
	TrgIdx	= pHandle->TailPointer;
	pSrc	= psrc;
	for(SrcIdx = 0; SrcIdx < len; SrcIdx++)
	{
		pTrg[TrgIdx] = pSrc[SrcIdx];
		TrgIdx++;
		TrgIdx %= pHandle->BufferSize;
	}	
	// move cursor and len
	pHandle->TailPointer 	+= len;
	pHandle->TailPointer	%= pHandle->BufferSize;
	pHandle->RemainSize 	-= len;
	
	return 1;
}
/*----------------------------------------------------------
	QueueRead
-----------------------------------------------------------*/
static smtInt32 QueueRead(void *phandle, void *ptrg, smtUint32 len)
{
	smtInt32 SrcIdx, TrgIdx;
	smtUint8 *pTrg;
	smtUint8 *pSrc;
	StreamQueue *pHandle = (StreamQueue*)phandle;

	// check buffer underflow
	// if buffer underflow state
	if((pHandle->BufferSize - pHandle->RemainSize) < len) return 0;
		
	// read buffer , check linear, need 4byte align
	pTrg	= ptrg;
	pSrc	= pHandle->pStreamBuffer;
	SrcIdx	= pHandle->HeadPointer;
	for(TrgIdx = 0; TrgIdx < len; TrgIdx++)
	{
		pTrg[TrgIdx] = pSrc[SrcIdx];
		SrcIdx++;
		SrcIdx %= pHandle->BufferSize;
	}
	
	// move cursor and len
	pHandle->HeadPointer 	+= len;
	pHandle->HeadPointer	%= pHandle->BufferSize;
	pHandle->RemainSize 	+= len;				

	return 1;
}
/*----------------------------------------------------------
	QueueUsedSize
-----------------------------------------------------------*/
static smtUint32 QueueUsedSize(void *phandle)
{
	StreamQueue *pHandle = (StreamQueue*)phandle;
	return (pHandle->BufferSize - pHandle->RemainSize);
}
/*----------------------------------------------------------
	QueueRemainSize
-----------------------------------------------------------*/
static smtUint32 QueueRemainSize(void *phandle)
{
	StreamQueue *pHandle = (StreamQueue*)phandle;
	return pHandle->RemainSize;
}
/*----------------------------------------------------------
	QueueReset
-----------------------------------------------------------*/
static void QueueReset(void *phandle)
{
	StreamQueue *pHandle = (StreamQueue*)phandle;

	pHandle->HeadPointer 	= 0;
	pHandle->TailPointer 	= 0;
	pHandle->UsedSize		= 0;
	pHandle->RemainSize		= pHandle->BufferSize;
}
/*----------------------------------------------------------
	GainFilter
-----------------------------------------------------------*/
static void GainFilter(smtInt32 gain, smtUint32 buffer, smtUint32 size)
{
	smtInt32 i;
	smtInt16 *pbuf = (smtInt16*)buffer;
	smtInt32 tmp;

	for(i = 0; i < size; i++) 
	{
		tmp		= (pbuf[i]*gain)/SOUND_WAVE_PLAY_GAIN_MAX;
		if(tmp >= 32760)	tmp = 32760;
		if(tmp <= -32760)	tmp = -32760;
		pbuf[i] = tmp;
		
	}
}
/*----------------------------------------------------------
	AudioHandler
-----------------------------------------------------------*/
static void AudioPlayHandler(smtUint32 address)
{
		int			i, j;
		static unsigned char Buffer[SOUND_WAVE_PLAY_BUF_SIZE];
		static unsigned char GetBuffer[SOUND_WAVE_PLAY_BUF_SIZE];
		


		if(internal.playRun <= 0) return;
		

		/* call writedonw callback 
		fnWriteDoneCallback(pWavHdr->lpData);
		*/
		
		memset(Buffer, 0, sizeof(char)*SOUND_WAVE_PLAY_BUF_SIZE);
		for(i = 0; i < 3; i++) 
		{
			if( (internal.pObject[i]->config.mode == SOUND_MODE_PLAY)
				&& internal.pObject[i]) {

				internal.pObject[i]->lock = 1;
				if(internal.pObject[i]->run) 
				{
					if((QueueUsedSize(internal.pObject[i]->pQueueHandle) 
						>= SOUND_WAVE_PLAY_BUF_SIZE)
						&& !internal.pObject[i]->needBuffering) 
					{
				
						QueueRead(
							internal.pObject[i]->pQueueHandle, 
							GetBuffer, 
							SOUND_WAVE_PLAY_BUF_SIZE
						);
						internal.pObject[i]->writeSize += SOUND_WAVE_PLAY_BUF_SIZE;
						/* samplerate convertion
							SampleRateConvertor(sampleRate, pWavHdr->lpData);
						*/
	
						/* bitwidth convertion
							BitWidthConvertor(bitwidth, pWavHdr->lpData);
						*/
					
						/* channel convertion
							ChannelConvertor(channel, pWavHdr->lpData);
						*/


						/* volume control */
						GainFilter(
							internal.pObject[i]->config.vol, 
							(smtUint32)GetBuffer, 
							SOUND_WAVE_PLAY_BUF_SIZE/2
						);

						/* call sound effector callback
							fnSoundEffector(pWavHdr->lpData);
						*/
				
					}
					else
					{
						internal.pObject[i]->needBuffering = 1;
					}

					{
						smtInt16 *pSrc = (smtInt16*)GetBuffer;
						smtInt16 *pTrg = (smtInt16*)Buffer;
						smtInt32 tmp;
						for(j = 0; j < SOUND_WAVE_PLAY_BUF_SIZE/2; j++)
						{

							tmp = pTrg[j]+pSrc[j];
							if(tmp >= 32760)	tmp = 32760;
							if(tmp <= -32760)	tmp = -32760;
							pTrg[j] = tmp;
	
						}
					}
				}
				internal.pObject[i]->lock = 0;


			}
			

		}
		memcpy((void*)address, (void*)Buffer, sizeof(char)*SOUND_WAVE_PLAY_BUF_SIZE);
			
}
/*----------------------------------------------------------
	AudioHandler
-----------------------------------------------------------*/
static void AudioRecordHandler(smtUint32 address)
{
		int			i, j;
		static unsigned char Buffer[SOUND_WAVE_PLAY_BUF_SIZE];
		static unsigned char GetBuffer[SOUND_WAVE_PLAY_BUF_SIZE];
		


		if(internal.recordRun <= 0) return;
		

		/* call writedonw callback 
		fnWriteDoneCallback(address);
		*/
		{
			smtInt16 *pSrc = (smtInt16*)address;
			smtInt16 *pTrg = (smtInt16*)GetBuffer;
			smtInt32 tmp;
			for(j = 0; j < SOUND_WAVE_RECORD_BUF_SIZE/2; j++)
			{
		
				tmp = pTrg[j]+pSrc[j];
				if(tmp >= 32760)	tmp = 32760;
				if(tmp <= -32760)	tmp = -32760;
				pTrg[j] = tmp;
		
			}
		}	
		
		memset(Buffer, 0, sizeof(char)*SOUND_WAVE_PLAY_BUF_SIZE);
		for(i = 0; i < 3; i++) 
		{
			if( (internal.pObject[i]->config.mode == SOUND_MODE_RECORD)
				&& internal.pObject[i]) {

				internal.pObject[i]->lock = 1;
				if(internal.pObject[i]->run) 
				{
					if(QueueRemainSize(internal.pObject[i]->pQueueHandle) 
					>= SOUND_WAVE_RECORD_BUF_SIZE) 
					{

						/* call sound effector callback
							fnSoundEffector(pWavHdr->lpData);
						*/

						/* volume control */
						GainFilter(
							internal.pObject[i]->config.vol, 
							(smtUint32)GetBuffer,
							SOUND_WAVE_RECORD_BUF_SIZE/2
						);

						/* samplerate convertion
							SampleRateConvertor(sampleRate, pWavHdr->lpData);
						*/
	
						/* bitwidth convertion
							BitWidthConvertor(bitwidth, pWavHdr->lpData);
						*/
					
						/* channel convertion
							ChannelConvertor(channel, pWavHdr->lpData);
						*/

				
						QueueWrite(
							internal.pObject[i]->pQueueHandle, 
							GetBuffer, 
							SOUND_WAVE_RECORD_BUF_SIZE
						);
						
						internal.pObject[i]->writeSize += SOUND_WAVE_RECORD_BUF_SIZE;						
				
					}

	
				}
				internal.pObject[i]->lock = 0;


			}
			

		}
			
}

/*----------------------------------------------------------
	SOUNDWaveInit
-----------------------------------------------------------*/
void SOUNDWaveInit(void)
{
	smtInt32 	i;
	AUDIO_CONFIG audioConfig;
	
	
	internal.ObjectIdx = 0;
	for(i = 0; i < 3; i++) 
	{
		internal.pObject[i] = 0;
	}
	internal.playRun 	= 0;
	internal.recordRun 	= 0;
	
	
	// Audio Play initialize
	smt2AudioInit();
	
	audioConfig.pAudioHandle	= AudioPlayHandler;
	audioConfig.pAudioFIFOEvent	= 0;
	audioConfig.sampleRate		= SOUND_WAVE_PLAY_SAMPLERATE;
	audioConfig.sampleBitWidth	= SOUND_WAVE_PLAY_BITWIDTH;
	audioConfig.channel			= SOUND_WAVE_PLAY_CHANNEL;
	audioConfig.bufferNum		= SOUND_WAVE_PLAY_BUF_NUM;
	audioConfig.bufferSize		= SOUND_WAVE_PLAY_BUF_SIZE;
	
	smt2AudioSetConfig(AUDIO_MODE_TX, &audioConfig);
	smt2AudioSetVolume(AUDIO_MODE_TX, AUDIO_VOL_20);
	
	/*
	smt2AudioInit();
	
	audioConfig.pAudioHandle	= AudioRecordHandler;
	audioConfig.pAudioFIFOEvent	= 0;
	audioConfig.sampleRate		= SOUND_WAVE_RECORD_SAMPLERATE;
	audioConfig.sampleBitWidth	= SOUND_WAVE_RECORD_BITWIDTH;
	audioConfig.channel			= SOUND_WAVE_RECORD_CHANNEL;
	audioConfig.bufferNum		= SOUND_WAVE_RECORD_BUF_NUM;
	audioConfig.bufferSize		= SOUND_WAVE_RECORD_BUF_SIZE;
	
	smt2AudioSetConfig(AUDIO_MODE_RX, &audioConfig);
	smt2AudioSetVolume(AUDIO_MODE_RX, AUDIO_VOL_20);
	*/
	
}
/*----------------------------------------------------------
	SOUNDWaveDeinit
-----------------------------------------------------------*/
void SOUNDWaveDeinit(void)
{
	smtInt32 i;

	for(i = 0; i < 3; i++) 
	{
		if(internal.pObject[i]) {
			PCMClose((void*)internal.pObject[i]);
		}
	}	
	
	smt2AudioDeinit();
}
/*----------------------------------------------------------
	SOUNDWaveOpen
-----------------------------------------------------------*/
smtInt32 SOUNDWaveOpen(SOUNDWaveConfig *pconfig)
{
	SOUNDWaveObject 	*pHandle = (SOUNDWaveObject*)malloc(sizeof(SOUNDWaveObject));
	smtInt32 			objectIdx;
	smtInt32 			i;

	for(objectIdx = 0; objectIdx < 3; objectIdx++)
	{
		if(!internal.pObject[objectIdx]) break;
	}
	
	if(objectIdx == 3) return -1;
	
	if(pconfig->mode == SOUND_MODE_PLAY) {
		

		internal.ObjectIdx++;
	
		memcpy(&pHandle->config, pconfig, sizeof(SOUNDWaveConfig));
		pHandle->buffering		= 0;
		pHandle->needBuffering	= 1;
		pHandle->lock			= 0;
		pHandle->writeSize		= 0;
		pHandle->pQueueHandle	= CreateQueue(pHandle->config.bufferSize);
		pHandle->objectIdx		= objectIdx;
		internal.pObject[pHandle->objectIdx] = pHandle;
    	
		pHandle->run = 1;
		internal.playRun++;
		for(i = 0; i < 2; i++) 
		{				
			smt2AudioRun(AUDIO_MODE_TX);
		}	

		return pHandle->objectIdx;	
	} 
	else
	{
		internal.ObjectIdx++;
	
		memcpy(&pHandle->config, pconfig, sizeof(SOUNDWaveConfig));
		pHandle->buffering		= 0;
		pHandle->needBuffering	= 1;
		pHandle->lock			= 0;
		pHandle->writeSize		= 0;
		pHandle->pQueueHandle	= CreateQueue(pHandle->config.bufferSize);
		pHandle->objectIdx		= objectIdx;
		internal.pObject[pHandle->objectIdx] = pHandle;
    	
		pHandle->run = 1;
		internal.recordRun++;
		for(i = 0; i < 2; i++) 
		{	
			//smt2AudioRun(AUDIO_MODE_TX); other audio codec for record
		}		
		
		return -1;
	}
}
/*----------------------------------------------------------
	SOUNDWaveClose
-----------------------------------------------------------*/
void SOUNDWaveClose(smtInt32 handle)
{
	SOUNDWaveObject	*pHandle = internal.pObject[handle];
	smtUint32 idx;
	
	if(pHandle->config.mode == SOUND_MODE_PLAY)
	{
		internal.playRun--;
	}
	else
	{
		internal.recordRun--;
	}
	
	DestroyQueue(pHandle->pQueueHandle);
	free(pHandle);
	internal.pObject[handle] = 0;
	internal.ObjectIdx--;

}
/*----------------------------------------------------------
	SOUNDWaveGetGain
-----------------------------------------------------------*/
SOUND_WAV_VOLUME SOUNDWaveGetGain(smtInt32 handle)
{
	return internal.pObject[handle]->config.vol;
}
/*----------------------------------------------------------
	SOUNDWaveSetGain
-----------------------------------------------------------*/
void SOUNDWaveSetGain(smtInt32 handle, SOUND_WAV_VOLUME vol)
{
	internal.pObject[handle]->config.vol = vol;
}
/*----------------------------------------------------------
	SOUNDWaveAvail
-----------------------------------------------------------*/
smtInt32 SOUNDWaveAvail(smtInt32 handle, smtUint32 size)
{
	SOUNDWaveObject *pHandle = internal.pObject[handle];
	if(pHandle->config.mode == SOUND_MODE_PLAY)
	{
		if(QueueRemainSize(pHandle->pQueueHandle) >= size) 
			return 1;
		else					 
			return 0;	
	}
	else
	{
		if(QueueUsedSize(pHandle->pQueueHandle) >= size) 
			return 1;
		else					 
			return 0;			
	}
}
/*----------------------------------------------------------
	SOUNDWaveCount
-----------------------------------------------------------*/
smtUint32 SOUNDWaveCount(smtInt32 handle)
{
	SOUNDWaveObject *pHandle = internal.pObject[handle];
	return pHandle->writeSize;	
}
/*----------------------------------------------------------
	SOUNDWavePause
-----------------------------------------------------------*/
void SOUNDWavePause(smtInt32 handle, smtBoolean on)
{
	while(internal.pObject[handle]->lock);
	internal.pObject[handle]->run = on;	
}
/*----------------------------------------------------------
	SOUNDWaveStop
-----------------------------------------------------------*/
void SOUNDWaveStop(smtInt32 handle)
{
	SOUNDWaveObject *pHandle = internal.pObject[handle];
	SOUNDWavePause(handle, 0);
	pHandle->buffering		= 0;
	pHandle->needBuffering	= 1;
	pHandle->lock			= 0;
	pHandle->writeSize		= 0;
	QueueReset((void*)internal.pObject[handle]->pQueueHandle);	
}
/*----------------------------------------------------------
	SOUNDWaveWriteData
-----------------------------------------------------------*/
void SOUNDWaveRun(smtInt32 handle, smtUint32 buffer, smtUint32 size)
{
	smtInt32 i;
	SOUNDWaveObject *pHandle = internal.pObject[handle];

	if(pHandle->config.mode == SOUND_MODE_PLAY)
	{
		if(pHandle->needBuffering) 
		{

			if(QueueRemainSize(pHandle->pQueueHandle) >= size) {
				QueueWrite(pHandle->pQueueHandle, (void*)buffer, size);
				pHandle->buffering += size;
			}

			if(pHandle->buffering > pHandle->config.bufferingSize)
			{

				pHandle->needBuffering	= 0;
				pHandle->buffering		= 0;
			} 
		
		}
		else
		{
			while(pHandle->lock) Sleep(1);
			if(QueueRemainSize(pHandle->pQueueHandle) >= size) {
				QueueWrite(pHandle->pQueueHandle, (void*)buffer, size);
			}

		}
	} 
	else
	{

		while(pHandle->lock) Sleep(1);
		if(QueueUsedSize(pHandle->pQueueHandle) >= size) {
			QueueRead(pHandle->pQueueHandle, (void*)buffer, size);
		}

	}
}
/*----------------------------------------------------------
	SOUNDWaveMaterGetGain
-----------------------------------------------------------*/
SOUND_WAV_VOLUME SOUNDWaveMaterGetGain(SOUND_WAV_MODE mode)
{
	if(mode == SOUND_MODE_PLAY)
	{
		return (SOUND_WAV_VOLUME)smt2AudioGetVolume(AUDIO_MODE_TX);
	}
	else
	{
		return (SOUND_WAV_VOLUME)smt2AudioGetVolume(AUDIO_MODE_RX);
	}	
}
/*----------------------------------------------------------
	SOUNDWaveMaterSetGain
-----------------------------------------------------------*/
void SOUNDWaveMaterSetGain(SOUND_WAV_MODE mode, SOUND_WAV_VOLUME vol)
{
	if(mode == SOUND_MODE_PLAY)
	{
		smt2AudioSetVolume(AUDIO_MODE_TX, (AUDIO_VOLUME)vol);
	}
	else
	{
		smt2AudioSetVolume(AUDIO_MODE_RX, (AUDIO_VOLUME)vol);
	}	
}
/*----------------------------------------------------------
	SOUNDWaveMaterGetMute
-----------------------------------------------------------*/
smtBoolean SOUNDWaveMaterGetMute(SOUND_WAV_MODE mode)
{
	if(mode == SOUND_MODE_PLAY)
	{
		return (smtBoolean)smt2AudioGetMute(AUDIO_MODE_TX);
	}
	else
	{
		return (smtBoolean)smt2AudioGetMute(AUDIO_MODE_RX);
	}			
}
/*----------------------------------------------------------
	SOUNDWaveMaterSetMute
-----------------------------------------------------------*/
void SOUNDWaveMaterSetMute(SOUND_WAV_MODE mode, smtBoolean on)
{
	if(mode == SOUND_MODE_PLAY)
	{
		smt2AudioSetMute(AUDIO_MODE_TX, (smtUint32)on);
		
	}
	else
	{
		smt2AudioSetMute(AUDIO_MODE_RX, (smtUint32)on);
	}	
}
