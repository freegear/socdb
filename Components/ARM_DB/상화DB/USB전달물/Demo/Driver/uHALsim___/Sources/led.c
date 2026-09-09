/***************************************************************************
 * Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
 * Copyright © ARM Limited 1998.  All rights reserved.
 ***************************************************************************/
/*****************************************************************************

   This file contains all the drivers etc. to interface with the LEDs on
   a ARM target. The aim of these routines is to provide a standard
   mechanism to access the LED(s) hiding any target-specific code.

******************************************************************************/

#include	"uhal.h" 
 

void	*uHALiv_LedHomes[uHAL_NUM_OF_LEDS + 1] = uHAL_LED_OFFSETS ;
U32	uHALiv_LedMasks[uHAL_NUM_OF_LEDS + 1] = uHAL_LED_MASKS ;


/* Get the state of the specified LED */
S32 uHALr_ReadLED(U32 number)
{
U32	*address ;
U32	mask ;

	if (number == 0 || number > uHAL_NUM_OF_LEDS)
		return -1;
	
	address = (U32 *)uHALiv_LedHomes[number] ;
	mask = uHALiv_LedMasks[number] ;

	/* If bit is set, return TRUE if uHAL_LED_ON has a bit set too.
	 * For clear bit, return FALSE if uHAL_LED_OFF is also clear.
	 */
	if (*address & mask)
		return ((uHAL_LED_ON)  ? TRUE : FALSE);
	else
		return ((uHAL_LED_OFF) ? TRUE : FALSE);
}

/* Turn on the specified LED */
void uHALr_SetLED(U32 number)
{
	uHALr_WriteLED(number, TRUE) ;
}


/* Turn on the specified LED */
void uHALr_ResetLED(U32 number)
{
	uHALr_WriteLED(number, FALSE) ;
}


/* Report to system how many LEDs this host has */
U32 uHALr_CountLEDs(void)
{
	return (uHAL_NUM_OF_LEDS) ;
}


/* Routine to set all LEDs to OFF - handy on reset/power-up */
U32 uHALr_InitLEDs(void)
{
int	i ;
	
	for (i = 1; i <= uHAL_NUM_OF_LEDS; i++)
		uHALr_WriteLED(i, FALSE) ;
		
	return (uHAL_NUM_OF_LEDS) ;
}
