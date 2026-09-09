/////////////////////////////////////////////////////////////////////////////////
// This file includes ISR used for CEU-SAR device driver
// The main IRQ handler is mapped to external IRQ of ARM
// GtxIrqHdlr_Ext() : Main IRQ Handler for External Interrupt
// GtxIrqSHdlr_SarTx() : Sub IRQ Handler for SAR Transmit Finish Interrupt
// GtxIrqSHdlr_SarRx() : Sub IRQ Handler for SAR Reception Finish Interrupt
// GtxIrqSHdlr_BufReq() : Sub IRQ Handler for Buffer Request Interrupt
// GtxIrqSHdlr_MacTx() : Sub IRQ Handler for MAC Transmit Finish Interrupt
// GtxIrqSHdlr_MacRx() : Sub IRQ Handler for MAC Reception Finish Interrupt
/////////////////////////////////////////////////////////////////////////////////
#include	"MOON_type.h"
#include	"platform.h"
#include	"gtx.h"
#include	"uhal.h"

/*
extern UINT		GtxInsJobEntry(UINT,JOB_QUE_ENTRY*);
extern UINT		g_test_isr_call_num;
extern UINT		g_test_modulo;


/////////////////////////////////////////////////////////////////////////////////
// GtxIrqHdlr_Ext()
// Main handler function used for processing external interrupt generated from
// Each communication module in LM(Logic Module)
// Required Information is extract from LM and stored into g_job_queue for call
// callback function
// This function should be registerd by uHALr_RequestInterrupt() at the main()
// uHALr_RequestInterrupt(UINT intNum, PrHandler handler, const PUCHAR devname)
// Usage : uHALr_RequestInterrupt(EXTERN_INTR0, GtxIrqHdlr_Ext,"Logic Module")
/////////////////////////////////////////////////////////////////////////////////
void GtxIrqHdlr_Ext(void)
{
UINT	cm_irq_sts, lm_irq_sts;
JOB_QUE_ENTRY	job;

#ifdef GTX_DBG
	uHALr_printf("External Interrupt 0(LM0) is generated\n");
#endif
	cm_irq_sts = *(UINT*) IC_IRQ0_STAT_REG;
	if ( !(cm_irq_sts & 0x00000200) )	{
#ifdef GTX_DBG
		uHALr_printf("Interrupt Source Mistmatch 0x%x\n",cm_irq_sts);
#endif
		return;
	}
	
	lm_irq_sts = *(UINT*) LM_IRQ_STAT_REG;		// 0xc0000020
		// Read Interrupt Status Register Of LM(Logic Module)
	
	if ( lm_irq_sts & MASK_FOR_HPIRX )			{	// if HPI rx interrupt
		// (1) Extract Related Information & Save
		// (2) Attach JOB_QUE_ENTRY for callback operation (GtxInsJobEntry)
		// (3) Clear Interrupt Source
	}
	else if ( lm_irq_sts & MASK_FOR_SARRX )	{	// if SAR tx interrupt
	
	}
	else	{
#ifdef GTX_DBG
		uHALr_printf("Unknwon Interrupt Source 0x%x\n",lm_irq_sts);
#endif
	}

	return;
}

///////////////////////////////////////////////////////////////////////////
// GtxCbForHPI
// Callback function for HPI interrupt
///////////////////////////////////////////////////////////////////////////
int GtxCbForHPI(JOB_QUE_ENTRY* job_info)
{

#ifdef GTX_DBG
	uHALr_printf("CallBack : GtxCbForHPI\n");
	uHALr_printf("CallBack : JobType = %d\n",job_info->JOB_TYPE);
	uHALr_printf("CallBack : Parameter[0] = 0x%x\n",job_info->REG_INFO[0]);
	uHALr_printf("CallBack : Parameter[1] = 0x%x\n",job_info->REG_INFO[1]);
	uHALr_printf("CallBack : Parameter[2] = 0x%x\n",job_info->REG_INFO[2]);
#endif
	return (0);
}

///////////////////////////////////////////////////////////////////////////
// This is a test code for emulating external interrupt
///////////////////////////////////////////////////////////////////////////
void GtxIrqHdlr_Ext_Test(void)
{
JOB_QUE_ENTRY	job;

	g_test_isr_call_num++;

	g_test_modulo += 1;
	
	if ( (g_test_modulo%512) == 0x00 )	{
		job.JOB_STS = OCCUPIED;
		job.JOB_TYPE = CALLBACK_FOR_HPIRX;
		job.REG_INFO[0] = 0xFFFFFFFF;
		job.REG_INFO[1] = 0xFFFFFFFF;
		job.REG_INFO[2] = 0xFFFFFFFF;
		GtxInsJobEntry(PRIOR_1,&job);
	}
	if ( (g_test_modulo%256) == 0x00 )	{
		job.JOB_STS = OCCUPIED;
		job.JOB_TYPE = CALLBACK_FOR_HPIRX;
		job.REG_INFO[0] = 0x123456;
		job.REG_INFO[1] = 0x234567;
		job.REG_INFO[2] = 0x345678;
		GtxInsJobEntry(PRIOR_0,&job);
	}

	return;
}
*/
