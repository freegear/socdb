// ad1848.h

//extern volatile BYTE	AUDIO_BASE;	// External AUDIO BASE address
extern volatile BYTE	AUDIO_ADDR;	// External AUDIO index address register
extern volatile BYTE	AUDIO_DATA;	// External AUDIO index data register
extern volatile BYTE	AUDIO_STAT;	// External AUDIO status register
extern volatile BYTE	AUDIO_PIO;	// External AUDIO pio data register

void AudioInit(void);
void AudioMenu(void);

