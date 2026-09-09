////////////////////////////////////////////////////////////////////////
// jobs.c
// This file include functions used to schedule execution of callback function
// (void) GtxJobScheduler(UINT) : Main Scheduler Task
// (JOB_QUE_ENTRY*) GtxSearchJobQueue(UINT prior) : Search Reserved Job Entry
// (UINT) GtxCfmRdJobQueue(UINT prior) : Conform Job Entry Read Out Operation
// (JOB_QUE_ENTRY*) GtxAssJobEntry(UINT prior) : Assigned Job Queue Entry
// (UINT) GtxInsJobEntry(UINT prior, JOB_QUE_ENTRY* jobinfo)
// (UINT) GtxRegCallBack(UINT handlerId, (void*)func )
// (UINT) GtxDelCallBack(UINT handlerId)
// (void) GtxInitCallBackEntry(void)
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
// Include/Define
////////////////////////////////////////////////////////////////////////
#include	"ceusar_type.h"
#include	"ceusar_emul.h"
#include	"uhal.h"

////////////////////////////////////////////////////////////////////////
// ProtoType Definition
////////////////////////////////////////////////////////////////////////
void			GtxJobScheduler(UINT);
JOB_QUE_ENTRY	*GtxSearchJobQueue(UINT);
UINT			GtxCfmRdJobQueue(UINT);
JOB_QUE_ENTRY	*GtxAssJobEntry(UINT);
UINT			GtxInsJobEntry(UINT,JOB_QUE_ENTRY*);
UINT			GtxRegCallBack(UINT,void*);
UINT			GtxDelCallBack(UINT);
void			GtxInitCallBackEntry(void);

UINT			AgJobQueueFullCnt = 0;

////////////////////////////////////////////////////////////////////////
// External Variable Definition
////////////////////////////////////////////////////////////////////////
extern PrFunc	JOB_HANDLER[NUM_OF_HANDLER];
extern int		g_job_scheduler_busy_cnt_prior0;
extern int		g_job_scheduler_busy_cnt_prior1;
extern int		g_job_scheduler_idle_cnt;
extern JOB_QUE_CTRL		g_job_ctrl_idx[NUM_OF_PRIORITY];
extern JOB_QUE_ENTRY	g_job_queue[NUM_OF_PRIORITY][NUM_JOB_QUEUE];
extern uint		gTstTxAvailSAR;
extern uint		gTstTxAvailAAL2;
extern uint		gTstMultiSapTxAv[NUM_OF_SAP];
extern uint		gTstTxAvailMAC;
extern uint		gTstTxAvailATM;
extern uint		gTstTxAvailHDLC;
extern uint		gTxAal5PduCnt;
extern uint		gTxAal2PduCnt;
extern uint		gRxAal2PduCnt;
extern uint		gTxMacFrameCnt;
extern uint		gTstUsbPktCnt;
extern uint		gTstHdlcPktCnt;
extern uint		gTstAal2DelayCnt;
extern uint		gTxOAMCellCnt;
extern uint		gTxRMCellCnt;
extern uint		gTstOAMKindTx;
extern uint		gTstRMKindTx;

////////////////////////////////////////////////////////////////////////
// External Function Definition
////////////////////////////////////////////////////////////////////////
extern void		VoiceLoopback();
extern void		VPDriver();
extern void		CSarPollMacIntr(void);

////////////////////////////////////////////////////////////////////////
// Variable Definition
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
// GtxJobScheduler()
// check queued job and process jobs using registered handler
////////////////////////////////////////////////////////////////////////

void GtxJobScheduler(UINT idleThres)
{
JOB_QUE_ENTRY	*job_que;
UINT			cnt, dummy_cnt;
UINT			dly, j;
UINT			tmp, tmp1, sap;


	gTxAal2PduCnt = 0;
	gTxAal5PduCnt = 0;
	gTxMacFrameCnt = 0;
	gTstUsbPktCnt = 0;
	gTstHdlcPktCnt = 0;
	gTstRMKindTx = 0;
	gTstOAMKindTx = 0;
	
	while (1)
	{
		if ( (int)(job_que = GtxSearchJobQueue(PRIOR_0)) != 0 )
		{
			g_job_scheduler_busy_cnt_prior0++;
				// global variable used for counting busy loop count
			if ( JOB_HANDLER[job_que->JOB_TYPE]((UINT)job_que) != -1 )
			{
				// call registered handler function
				// the parameter should be casted by call function
				GtxCfmRdJobQueue(PRIOR_0);
			}
			continue;
		}
		else if ( (int)(job_que = GtxSearchJobQueue(PRIOR_1)) != 0 )
		{
			g_job_scheduler_busy_cnt_prior1++;
				// global variable used for counting busy loop count
			if ( JOB_HANDLER[job_que->JOB_TYPE]((UINT)job_que) != -1 )
			{
				GtxCfmRdJobQueue(PRIOR_1);
			}	
			continue;
		}

#ifdef LPBK_TEST

#if MULTI_SAP_TEST
		// else if (1)	{
		if (1)
		{
			for(sap=0;sap<NUM_OF_SAP;sap++)
			// for(sap=0;sap<32;sap++)		// (TESTF)
			{	// NUM_OF_SAP = 34
				if ( gTstMultiSapTxAv[sap] )
				{
					if ( (sap==AAL2_TST_SAP) || (sap==AAL2_ETST_SAP) )
					{	// AAL2
						if (CSarChkAAL2Sts(sap))
						{
#ifdef	TOPSIM
							CSarTstAAL2Pdu(sap); // (TESTF) Performnace Problem
#endif
							gTstMultiSapTxAv[sap] = 0;
							gTxAal2PduCnt++;
						}
						else
						{
							gTstAal2DelayCnt++;
						}
					}
					else
					{	// AAL5
						CSarTstAAL5Pdu(sap);
						gTxAal5PduCnt++;
						gTstMultiSapTxAv[sap] = 0;
					}
				}	// of gTstMultiSapTxAv[sap]	
			}	// of for
		}	// of if
		
#else	// of MULTI_SAP_TEST

#if ( SAR_LPBK_TEST_ONLY || SAR_AND_MAC_LPBK_TEST )
		// else if ( gTstTxAvailSAR )	{
		if ( gTstTxAvailSAR )
		{
			gTstTxAvailSAR = 0;
#if (USE_EXTENDED_SAP)
			CSarTstAAL5Pdu(AAL5_ETST_SAP);
#else
			CSarTstAAL5Pdu(AAL5_TST_SAP);
#endif
			gTxAal5PduCnt++;
		}
#endif	// of ( SAR_LPBK_TEST_ONLY || SAR_AND_MAC_LPBK_TEST )

#if ( AAL2_LPBK_TEST_ONLY )
		else if ( gTstTxAvailAAL2 )
		{
#if (AAL2_CUTIMER_TEST)
			if (1)
			{
#if (USE_EXTENDED_SAP)
				CSarTstAAL2Pdu(AAL2_ETST_SAP);
#else
				CSarTstAAL2Pdu(AAL2_TST_SAP);
#endif
#else
#if (AAL2_SW_LPBK_TEST)
			if (CSarChkAAL2Sts(AAL2_SW_SAP))
			{
				CSarTstAAL2Pdu(AAL2_SW_SAP);
#else	// of AAL2_SW_LPBK_TEST
#if (USE_EXTENDED_SAP)
			if (CSarChkAAL2Sts(AAL2_ETST_SAP))
			{
				CSarTstAAL2Pdu(AAL2_ETST_SAP);
#else
			if (CSarChkAAL2Sts(AAL2_TST_SAP))
			{
				CSarTstAAL2Pdu(AAL2_TST_SAP);
#endif	// of USE_EXTENDED_SAP
#endif	// of AAL2_SW_LPBK_TEST
#endif	// of AAL2_CUTIMER_TEST
				gTstTxAvailAAL2 = 0;
				gTxAal2PduCnt++;
			}
			else
				gTstAal2DelayCnt++;	
		}
#endif	// of AAL2_LPBK_TEST_ONLY
#endif	// of MULTI_SAP_TEST

#if ( MAC_LPBK_TEST_ONLY || SAR_AND_MAC_LPBK_TEST )
		// else if ( gTstTxAvailMAC )	{
		if ( gTstTxAvailMAC )
		{
#if ( !MAC_STANDALONE_TEST )	// (1120)
			gTstTxAvailMAC = 0;
			CSarTstMacFrame();
			gTxMacFrameCnt++;
#endif
		}
#if ( MAC_POLL_MODE_ENABLE )
		CSarPollMacIntr();
#endif
#endif	// of MAC_LPBK_TEST_ONLY || SAR_AND_MAC_LPBK_TEST

#if (OAM_CELL_TEST)
		if (gTstTxAvailATM)
		{
			gTstTxAvailATM = 0;
			CSarTstOAMCell(gTstOAMKindTx);
			gTxOAMCellCnt++;
			gTstOAMKindTx = (gTstOAMKindTx+1)%NUM_OF_OAM_TEST_PTTN;
		}
#endif

#if (RM_CELL_TEST)
		if (gTstTxAvailATM)
		{
			gTstTxAvailATM = 0;
			CSarTstRMCell(gTstRMKindTx);
			gTxRMCellCnt++;
			gTstRMKindTx = (gTstRMKindTx+1)%NUM_OF_RM_TEST_PTTN;
		}
#endif

#if ( USB_LPBK_TEST_ONLY )
		// else if ( gTstTxAvailUSB )	{
		if ( gTstTxAvailUSB )
		{
			gTstTxAvailUSB = 0;
			CSarTstUsbPacket();
			gTstUsbPktCnt++;
		}
#endif	// of USB_LPBK_TEST_ONLY

#if ( HDLC_LPBK_TEST_ONLY )
		// else if ( gTstTxAvailHDLC )	{
		if ( gTstTxAvailHDLC )
		{
			gTstTxAvailHDLC = 0;
			CSarTstHdlcPacket();
			gTstHdlcPktCnt++;
		}
#endif	// of HDLC_LPBK_TEST_ONLY

#endif	// of LPBK_TEST

#if ( VP_LPBK_TEST_ONLY )
		if (1)
		{
//			VPDriver();			// (20010722)
			VoiceLoopBack();
			for(cnt=0; cnt<idleThres; cnt++)
				dummy_cnt++;
		}
#endif

/*
		else
		{
			g_job_scheduler_idle_cnt++;
				// global variable used for counting idle loop count
			for(cnt=0; cnt<idleThres; cnt++)
				dummy_cnt++;	
		}
*/

	}	// of while
}	// GtxJobScheduler

////////////////////////////////////////////////////////////////////////
// GtxSearchJobQueue
// search JOB_QUE to find a job to be scheduled
// First IN First OUT
// return value : address of JOB Queue Entry
////////////////////////////////////////////////////////////////////////
JOB_QUE_ENTRY *GtxSearchJobQueue(UINT prior)
{
	if ( (g_job_ctrl_idx[prior].FE_STS == EMPTY) &&
			(g_job_ctrl_idx[prior].RD_IDX == g_job_ctrl_idx[prior].WR_IDX) )	{
		return (0);
			// If Specified Priority JOB Queue is Empty, return 0
	} 
	else	{
		return (&(g_job_queue[prior][g_job_ctrl_idx[prior].RD_IDX]));
			// Return the address of assigned JOB Queue Entry
	}
}	// GtxSearchJobQueue

/////////////////////////////////////////////////////////////////////////
// GtxCfmRdJobQueue
// Called By CallBack Function to Confirm Usage Of JobQueueEntry
// Increase Job Queue Read Index
/////////////////////////////////////////////////////////////////////////
UINT GtxCfmRdJobQueue(UINT prior)
{
	if ( g_job_ctrl_idx[prior].RD_IDX == g_job_ctrl_idx[prior].WR_IDX )	{
		return (-1);
	}
	g_job_ctrl_idx[prior].RD_IDX++;
	g_job_ctrl_idx[prior].RD_IDX %= g_job_ctrl_idx[prior].QUE_SZ;
	if ( g_job_ctrl_idx[prior].RD_IDX == g_job_ctrl_idx[prior].WR_IDX )	{
		// This is The Case That Queue is Empty
		g_job_ctrl_idx[prior].FE_STS = EMPTY;
		// uHALr_printf("E\n");
	}
	return (0);
}

/////////////////////////////////////////////////////////////////////////
// GtxAssJobEntry
/////////////////////////////////////////////////////////////////////////
JOB_QUE_ENTRY* GtxAssJobEntry(UINT QuePrior)
{
UINT			num_que_entry;
JOB_QUE_ENTRY	*PAssJobEntry;
 
	if ( g_job_ctrl_idx[QuePrior].RD_IDX > g_job_ctrl_idx[QuePrior].WR_IDX )	{
		num_que_entry = g_job_ctrl_idx[QuePrior].QUE_SZ -
		g_job_ctrl_idx[QuePrior].RD_IDX + g_job_ctrl_idx[QuePrior].WR_IDX;
		if ( num_que_entry >= ( g_job_ctrl_idx[QuePrior].QUE_SZ - 1 ) )		{
			// This is The Case That Queue is in Full State
			// uHALr_printf("JOB Queue Full\n");
			AgJobQueueFullCnt++;
			return(0);
		}
	}
	else if ( g_job_ctrl_idx[QuePrior].RD_IDX < g_job_ctrl_idx[QuePrior].WR_IDX )	{
		num_que_entry = g_job_ctrl_idx[QuePrior].WR_IDX - g_job_ctrl_idx[QuePrior].RD_IDX;
		if ( num_que_entry >= ( g_job_ctrl_idx[QuePrior].QUE_SZ - 1 ) )		{
			// This is The Case That Queue is in Full State
			// uHALr_printf("JOB Queue Full\n");
			AgJobQueueFullCnt++;
			return(0);
		}
	}
	PAssJobEntry = (JOB_QUE_ENTRY*) &(g_job_queue[QuePrior][g_job_ctrl_idx[QuePrior].WR_IDX]);
	g_job_ctrl_idx[QuePrior].WR_IDX++;
	g_job_ctrl_idx[QuePrior].WR_IDX %= g_job_ctrl_idx[QuePrior].QUE_SZ;
	g_job_ctrl_idx[QuePrior].FE_STS = OCCUPIED;
	// uHALr_printf("O\n");
	return (PAssJobEntry);
}	// of GtxAssJobEntry

/////////////////////////////////////////////////////////////////////////
// GtxInsJobEntry
// This function is called by main IRQ handler function
// when an interrupt is generated and queueing is required
/////////////////////////////////////////////////////////////////////////
UINT GtxInsJobEntry(UINT QuePrior, JOB_QUE_ENTRY* JobInfo)
{
JOB_QUE_ENTRY	*AssEntryAddr;

	if ( ( AssEntryAddr = (JOB_QUE_ENTRY*) GtxAssJobEntry(QuePrior) ) != 0 )	{
		*(JOB_QUE_ENTRY*)AssEntryAddr = *JobInfo;
		AssEntryAddr->JOB_STS = OCCUPIED;
			// Copy Acquired Information Into Job Queue Table Entry Space
		return (0);		// Success
	}
	else	{			// If No Entry is Available
		return (-1);	// Failure
	}
}	// of GtxInsJobEntry

//////////////////////////////////////////////////////////////////////////////////////
// GtxInitJobCtrlIdx()
// Initialize Job Queue Control Index
//////////////////////////////////////////////////////////////////////////////////////
void GtxInitJobCtrlIdx()
{
UINT	cnt;

	for(cnt=0; cnt<NUM_OF_PRIORITY; cnt++)		{
		g_job_ctrl_idx[cnt].QUE_SZ = NUM_JOB_QUEUE;
		g_job_ctrl_idx[cnt].WR_IDX = 0;
		g_job_ctrl_idx[cnt].RD_IDX = 0;
		g_job_ctrl_idx[cnt].FE_STS = 0;
	}
}

/////////////////////////////////////////////////////////////////////////
// GtxRegCallBack
// Regiser CallBack Function to Table
// The Entry Of Table is used to process queued entry
/////////////////////////////////////////////////////////////////////////
UINT GtxRegCallBack(UINT Id, void* Handler)
{

	if ( JOB_HANDLER[Id] == NULL )	{
		JOB_HANDLER[Id] = (PrFunc) Handler;
			// JOB_HANDLER is static global variable for storing
			// handler address matched to each type
		return (0);
	}
	else	{
#ifdef GTX_DBG
		uHALr_printf("Handler %d Already Assigned\n",Id);
#endif
		return (-1);
	}
}	// of GtxRegCallBack

//////////////////////////////////////////////////////////////////////////
// GtxDelCallBack
// Remove CallBack Function From Table
// The Entry Of Table is used to process queued entry
//////////////////////////////////////////////////////////////////////////
UINT GtxDelCallBack(UINT Id)
{

	if ( JOB_HANDLER[Id] == NULL )	{
		return (-1);
	}
	else	{
		JOB_HANDLER[Id] = NULL;
		return (0);
	}
}	// of GtxDelCallBack

///////////////////////////////////////////////////////////////////////////
// GtxInitCallBackEntry
// Initialize CallBack Entry Information
///////////////////////////////////////////////////////////////////////////
void GtxInitCallBackEntry(void)
{
UINT	num;

	for(num=0; num<NUM_OF_HANDLER; num++)	{
		JOB_HANDLER[num] = NULL;	
	}
}	// of GtxInitCallBackEntry