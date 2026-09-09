////////////////////////////////////////////////////////////////////////////////
// timera.c
// This file includes timer utilizing function
////////////////////////////////////////////////////////////////////////////////
#include	"uhal.h"
#include	"MOON_type.h"

////////////////////////////////////////////////////////////////////////////////
// GtxSetUpSystemTimer
// SetUp Timer and Assigns Associated Function and Symbol
////////////////////////////////////////////////////////////////////////////////
GtxSetUpSystemTimer(void *timerFunc, const UCHAR* devname)
{
	if ( uHALr_RequestSystemTimer((PrHandler)timerFunc, devname) <= 0 )	{
#ifdef GTX_DBG
		uHALr_printf("System Timer or IRQ busy. Registration Failed\n");
#endif
	}
	else	{
		uHALr_InstallSystemTimer();
#ifdef GTX_DBG
		uHALr_printf("System Timer Registration OK\n");
#endif
			// Starts The Timer and Enables the Interrupt Associated With it
	}
}	// of GtxSetUpSystemTimer()

////////////////////////////////////////////////////////////////////////////////
// GtxSetUpTimer
// SetUp Timer & Assigns Associated Function & Symbol
// Additionally Sets Timer Interval & State
////////////////////////////////////////////////////////////////////////////////
UINT GtxSetUpTimer(void *timerFunc, UINT timerINT, enum uHALe_TimerState timerSts,
					const UCHAR* devname)		
{
int		timerID, tState, tInt;

	if ( ( timerID = uHALr_RequestTimer((PrHandler)timerFunc, devname) ) == -1 )	{
		// Gets Next Available Timer And Install a Handler
#ifdef GTX_DBG
		uHALr_printf(" The Requested Timer is Unknown or Already Assigned\n");
#endif
		return (-1);		// If the Timer is unknown or already assigned
	}
	else	{
#ifdef GTX_DBG
		uHALr_printf(" GtxSetUpTimer	: Allocated TimerID(%d)\n",timerID);
#endif
	}
	
	if (timerINT != 0xffffffff)	{
		if ( uHALr_SetTimerState(timerID, (enum uHALe_TimerState) timerSts) == -1 )		{
			// Set Timer State and Check The Timer Specified Exists
#ifdef GTX_DBG
			uHALr_printf(" No Such Timer Exists\n");
#endif
			return (-1);	// No Such Timer
		}
		else	{
			if ( (tState = uHALr_GetTimerState(timerID)) != -1 )	{
#ifdef GTX_DBG
				uHALr_printf(" GtxSetUpTimer	: Verfied TimerState(%d)\n",tState);
#endif
			}
			else	{
#ifdef GTX_DBG
				uHALr_printf(" GtxSetUpTimer	: Invalid Timer State\n");
#endif
				return (-1);
			}
		}
	}
	
	if (timerSts != 0xffffffff)	{
		if ( uHALr_SetTimerInterval(timerID, timerINT) == -1 )		{
			// Set Timer Interval and Check The Timer Specified Exists
			return (-1);
		}
		else	{
			if ( (tInt = uHALr_GetTimerInterval(timerID)) != -1 )	{
#ifdef GTX_DBG
				uHALr_printf(" GtxSetUpTimer	: Verified Interval(%d)\n",tInt);
#endif
			}
			else	{
#ifdef GTX_DBG
				uHALr_printf(" GtxSetUpTimer	: Invalid Timer Period\n");
#endif
				return (-1);
			}
		}
	}
	
	(void) uHALr_InstallTimer(timerID);
	
	return(0);
	
}	/* of GtxSetUpTimer	*/
		
///////////////////////////////////////////////////////////////////////////////////
// GtxFreeTimer
// Free Assigned Timer
///////////////////////////////////////////////////////////////////////////////////
UINT GtxFreeTimer(UINT timerID)
{

#ifdef GTX_DBG
UINT	timerINT, timerSts;

	if ( (timerINT = uHALr_GetTimerInterval(timerID)) == -1 )	{
		return (-1);
	}
	else	{
		uHALr_printf("Deallocated Timer Interval = %d uSec\n",timerINT);
	}
	
	if ( (timerSts = uHALr_GetTimerState(timerID)) == -1 )		{
		return (-1);
	}
	else	{
		uHALr_printf("Deallocated Timer Status = 0x%x\n",timerSts);
	}
#endif

	if ( uHALr_FreeTimer(timerID) == -1 )	{
		return (-1);		// No Such Timer
	}
	
	return(0);
	
}	/* of GtxFreeTimer	*/

