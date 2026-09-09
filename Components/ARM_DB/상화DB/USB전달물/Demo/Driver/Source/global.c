////////////////////////////////////////////////////////////////////////////////
// global.c
// contains global variables used in MOON device driver code
// each source code should decrare extern global variables
////////////////////////////////////////////////////////////////////////////////
#include	"types.h"
#if 0
JOB_QUE_CTRL	g_job_que_ctrl[NUM_OF_PRIORITY];
	// global variable used for control job queue
	// 4 bytes structure used for managing job queue


JOB_QUE_ENTRY	g_job_queue[NUM_OF_PRIORITY][NUM_JOB_QUEUE];
	// job queue used for saving ISR related information or
	// self scheduling procedure information
	
UINT			g_default_IRQn;
	// default interrupt number assigned to LM
	
JOB_QUE_CTRL	g_job_ctrl_idx[NUM_OF_PRIORITY];
	// Control Parameter Of Each Job Queue
	
PrFunc			JOB_HANDLER[NUM_OF_HANDLER];
	// Array for Saving Habdler Function

UINT			g_default_IRQn;

UINT			g_job_scheduler_busy_cnt_prior0;
UINT			g_job_scheduler_busy_cnt_prior1;
UINT			g_job_scheduler_idle_cnt;
UINT			g_test_isr_call_num;

UINT			g_test_modulo;
#endif