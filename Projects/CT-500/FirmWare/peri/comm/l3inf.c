/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: i2s.c 
	Description	: I2S test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/
/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/
#include "sysinc.h"
#include "commonmacro.h"
/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/
//-----------------------------------------------------------
// L3 interface definition
//-----------------------------------------------------------
#define GPIOWRITEBIT(x, pos) 													\
	do { 																		\
		unsigned gpio_data;														\
		unsigned gpio_mask;														\
		gpio_mask = (0x00000001 << (pos));										\
		gpio_data = SMT_READ(GPIO0_OUT);										\
		if(x) gpio_data |= gpio_mask;											\
		else gpio_data &= ~gpio_mask; 											\
		SMT_WRITE(GPIO0_OUT, gpio_data);										\
	} while(0)
	
	
#define GPIOPIN_L3MODE		(21)
#define GPIOPIN_L3CLK		(22)
#define GPIOPIN_L3DATA		(23)
#define L3MODE(x)			GPIOWRITEBIT((x), GPIOPIN_L3MODE)
#define L3CLK(x)			GPIOWRITEBIT((x), GPIOPIN_L3CLK)
#define L3DATA(x)			GPIOWRITEBIT((x), GPIOPIN_L3DATA)
//-----------------------------------------------------------
// UDA1341 definition
//-----------------------------------------------------------
#define UDA1341STAT			(0x16)
#define UDA1341DATA0		(0x14)

#define UDA1341STAT_RST		(0x00)
#define UDA1341STAT_SC		(0x02)		// 256*Fs
#define UDA1341STAT_DC		(0x01)		// dc filtering
#define UDA1341STAT_IF		(0x00)		// I2S Mode
#define UDA1341STAT_OGS		(0x00)		// Output Gain(0dB)
#define UDA1341STAT_IGS		(0x00)		// Input Gain(0dB)
#define UDA1341STAT_PAD		(0x00)		// Polarity of ADC(non inverting)
#define UDA1341STAT_PDA		(0x00)		// Polarity of DAC(non inverting)
#define UDA1341STAT_PC		(0x03)		// Power Control(ADC on, DAC on)
#define UDA1341STAT_DS		(0x00)		// Double Speed(Single Speed)

#define UDA1341DATA0_VC		(0x00)		// Volume Control(0dB)
#define UDA1341DATA0_BB 	(0x00)		// Base Boot(0)
#define UDA1341DATA0_TR 	(0x00)		// Treble(0)
#define UDA1341DATA0_PP 	(0x00)		// Peak Detection Position(0)
#define UDA1341DATA0_DE 	(0x00)		// De-emphasis(no de-emphasis)
#define UDA1341DATA0_MT		(0x00)		// Mute(No Mute)
#define UDA1341DATA0_M		(0x00)		// Mode(flat)

#define UDA1341DATA0E_MA	(0x00)		// Mixer Gain Channel1(0dB)
#define UDA1341DATA0E_MB	(0x00)		// Miser Gain Channel2(0dB)
#define UDA1341DATA0E_MS	(0x06)		// MIC sensitity(27dB:max)
#define UDA1341DATA0E_MM	(0x01)		// Mixer Mode(Input Channel 1)
#define UDA1341DATA0E_AG	(0x00)		// AGC control(enable)
#define UDA1341DATA0E_IG	(0x00)		// Input Channel 2 gain(0dB)
#define UDA1341DATA0E_AT	(0x00)		// AGC attack and decay time
#define UDA1341DATA0E_AL	(0x00)		// AGC output level(-9dB)

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: L3Delay
	Prototype		:
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void L3Delay(void)
{
	int count = 20;

	while(count--)
		;
}
/*----------------------------------------------------------
	Function name	: L3Addr
	Prototype		:
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
int L3Addr(unsigned char addr)
{
	int i;

	L3MODE(0);
	L3Delay();
	for(i = 0; i < 8; i++)
	{
		L3CLK(1);
		L3Delay();
		L3CLK(0);
		L3DATA(addr & 0x01);
		L3Delay();
		addr >>= 1;
	}

	L3CLK(1);
	L3Delay();
	L3MODE(1);
	L3Delay();

	return 0;
}
/*----------------------------------------------------------
	Function name	: L3Data
	Prototype		:
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
int L3Data(unsigned char data)
{
	int i;

	L3MODE(1);
	L3Delay();
	for(i = 0; i < 8; i++)
	{
		L3CLK(1);
		L3Delay();
		L3CLK(0);
		L3DATA(data & 0x01);
		L3Delay();
		data >>= 1;
	}

	L3CLK(1);
	L3Delay();
	L3MODE(0);
	L3Delay();
	L3MODE(1);
	L3Delay();

	return 0;
}
/*----------------------------------------------------------
	Function name	: L3Init
	Prototype		:
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void L3Init(void)
{
	unsigned data;

	data = SMT_READ(GPIO0_OUT);
	data |= (1<<GPIOPIN_L3MODE)|(1<<GPIOPIN_L3CLK)|(1<<GPIOPIN_L3DATA);
	SMT_WRITE(GPIO0_OUT, data);

	data = SMT_READ(GPIO0_OE);
	data |= (1<<GPIOPIN_L3MODE)|(1<<GPIOPIN_L3CLK)|(1<<GPIOPIN_L3DATA);
	SMT_WRITE(GPIO0_OE, data);

	L3Delay();
	L3CLK(1);
}
/*----------------------------------------------------------
	Function name	: UDA1341Init
	Prototype		:
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
int UDA1341Init(void)
{

	smtUint32	data;

	
	L3Init();

	//
	//	UDA1341TS first configure
	//	
	data = (
		(0<<7)
		|(UDA1341STAT_RST	<< 6)		// Reset
		|(UDA1341STAT_SC	<< 4)		// Set system clock of UDA1341
		|(UDA1341STAT_IF	<< 1)		// I2S mode
		|(UDA1341STAT_DC	<< 0));		// Use DC filtering
		
	L3Addr(UDA1341STAT);
	L3Data(data);


	//
	//	UDA1341TS second configure
	//	
	data = (
		(1<<7)
		|(UDA1341STAT_OGS	<<6)		// Output Gain 0db
		|(UDA1341STAT_IGS	<<5)		// Input Gain 0db
		|(UDA1341STAT_PAD	<<4)		// ADC non inverting
		|(UDA1341STAT_PDA	<<3)		// DAC non inverting
		|(UDA1341STAT_DS	<<2)		// single speed playback
		|(UDA1341STAT_PC	<<0));		// DAC on, ADC on
		
	L3Addr(UDA1341STAT);
	L3Data(data);

	//	
	//	UDA1341TS volume contorl
	//
	data = (
		(0<<6)							// [7:6]:00 volume bits
		|(UDA1341DATA0_VC)				// volume 0db
	);
	L3Addr(UDA1341DATA0);
	L3Data(data);

	//	
	//	UDA1341TS Base boost & treble
	//
	data = (
		(1<<6)							// [7:6]:01 base boost & treble bits
		|(UDA1341DATA0_BB<<2)			// base boost to 0db
		|(UDA1341DATA0_TR)				// treble to 0db
	);
	L3Data(data);

	//	
	//	UDA1341TS peak/de-emphais/mute/mode
	//
	data = (
		(2<<6)							// [7:6]:10 peck/de-emphasis/mute/mode
		|(UDA1341DATA0_PP<<5)			// peak detection before tone feature
		|(UDA1341DATA0_DE<<3)			// no de-emphasis
		|(UDA1341DATA0_MT<<2)			// no mute
		|(UDA1341DATA0_M)				// flat setting
	);
	L3Data(data);

	//	
	//	UDA1341TS peak/de-emphais/mute/mode
	//
	L3Data((0x18<<3)
		|(0x00));	// ExT ADDR 000

	L3Data((0x7<<5)
		|(UDA1341DATA0E_MA));

	L3Data((0x18<<3)
		|(0x01));	// ExT ADDR 001

	L3Data((0x7<<5)
		|(UDA1341DATA0E_MB));

	L3Data((0x18<<3)
		|(0x02));	// ExT ADDR 010

	L3Data((0x7<<5)
		|(UDA1341DATA0E_MS<<2)
		|(UDA1341DATA0E_MM));

	L3Data((0x18<<3)
		|(0x04));	// ExT ADDR 100

	L3Data((0x7<<5)
		|(UDA1341DATA0E_AG<<4)
		|(UDA1341DATA0E_IG&0x03));

	L3Data((0x18<<3)
		|(0x05));	// ExT ADDR 101

	L3Data((0x7<<5)
		|((UDA1341DATA0E_IG>>2)&0x1F));

	L3Data((0x18<<3)
		|(0x06));	// ExT ADDR 110

	L3Data((0x7<<5)
		|(UDA1341DATA0E_AT<<2)
		|(UDA1341DATA0E_AL));


	return 0;
}