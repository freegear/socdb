////////////////////////////////////////////////////////////////////////
// This file contains test code used by GTX CEU-SAR device driver
// add your test routine here and use it.
// Prototype definition should be added to gtx.h
/////////////////////////////////////////////////////////////////////////
#include	"uhal.h"
#include	"MOON_type.h"
/*
/////////////////////////////////////////////////////////////////////////
// GtxSendSign(Loop,DispChar)
// Continuosly Put On/Off Misc LED in CM Board for Singing
// and Print String
/////////////////////////////////////////////////////////////////////////
void GtxSendSign(int loop, const UCHAR* string)
{
    unsigned int	*CM_CTRL_REG;
    unsigned int	reg_data;
    unsigned int	i, j, k;

	CM_CTRL_REG = (unsigned int*) 0x1000000c;

    for(i=0; i<loop; i++)	{
    	reg_data = *(unsigned int*)CM_CTRL_REG;
    	reg_data &= 0xfffffffe;
    	*(unsigned int*)CM_CTRL_REG = reg_data;	// LED off
    	for(j=0; j<0x20000; j++)	k++;
    	reg_data = *(unsigned int*)CM_CTRL_REG;
    	reg_data |= 0x00000001;
    	*(unsigned int*)CM_CTRL_REG = reg_data;	// LED on
    	for(j=0; j<0x20000; j++)	k++;
    }

    reg_data = *(unsigned int*)CM_CTRL_REG;
    reg_data &= 0xfffffffe;
    *(unsigned int*)CM_CTRL_REG = reg_data;		// LED off
    
#ifdef GTX_DBG
    uHALr_printf("%s\n",string);
#endif
	return;

}

/////////////////////////////////////////////////////////////////////////////////////
// GtxGetSysInfo
// Get Various System Information About Timer, Memory, Etc.
/////////////////////////////////////////////////////////////////////////////////////
void GtxGetSysInfo(void)
{
UINT	cnt, NumOfTimer;

	// To Increase Heap Size, Increase The Address Of RW_DATA_BASE_ADDRESS
	
	uHALr_printf(" First Free RAM Address       : 0x%8x\n",uHALr_StartOfRam());
		// Starting Address Of Non-Used Region (above RW+ZI Region)
	uHALr_printf(" Top Address Of Available RAM : 0x%8x\n",uHALr_EndOfRam());
		// End Address Of Physical Memory
	uHALr_printf(" Start Address Of Heap        : 0x%8x\n",uHALr_StartOfFreeRam());
		// Start Address Of Heap Region (Above RO Region)
	uHALr_printf(" Last Free RAM Address        : 0x%8x\n",uHALr_EndOfFreeRam());
		// End Address Of Heap Region (Below RW Region)
	uHALr_printf(" Size Of Heap                 : 0x%8x\n",uHALr_SizeOfFreeRam());
		// Size Of Heap Region (End Address-Start Address-4)
	uHALr_printf(" Heap Available(A/NA)         : 0x%8x\n",uHALr_HeapAvailable());
		// The Heap Available Status
	NumOfTimer = uHALr_CountTimers();
	uHALr_printf(" Number Of Supported Timer   : %d\n",NumOfTimer);
	for(cnt=1; cnt<=NumOfTimer; cnt++)	{
		uHALr_printf(" (%d) Interval For Timer       : %d uSec\n",cnt,uHALr_GetTimerInterval(cnt));
		uHALr_printf(" (%d) State For Timer          : 0x%x\n",cnt,uHALr_GetTimerState(cnt));
	}
}	// of GtxGetSysInfo	

/////////////////////////////////////////////////////////////////////////
// GtxDispSts
// Display Various Information
/////////////////////////////////////////////////////////////////////////
void GtxDispSts(void)
{
#ifdef GTX_DBG
	uHALr_printf("Display Statistics Variables\n");
#endif
	return;
}

//////////////////////////////////////////////////////////////////////////
// GtxPrintLogo
// Display MOON Logo
//////////////////////////////////////////////////////////////////////////
void GtxPrintLogo(void)
{
#ifdef GTX_DBG
	uHALr_printf("\n\n\n\n\n\n");
	uHALr_printf("=======================================================\n");
	uHALr_printf("Welcome ! Glotrex Co, Ltd. August 2003\n");
	uHALr_printf(">>>> USB 2.0 MOON Demo System <<<<\n");
	uHALr_printf("   USB 2.0-Ethernet Bridge Demo\n");
	uHALr_printf("=======================================================\n\n\n");
#endif
}

*/