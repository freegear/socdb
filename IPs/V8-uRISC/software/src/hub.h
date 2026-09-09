// hub.h

#define PORTS		3
#define PORT_BYTES	((PORTS+1+7)/8)	// number of bytes for 1 bit per port

#define ENDPOINT_HUB	1	// some devices demand 1 (dec)

typedef union
	{
	WORD	w;		// for clearing both bytes
	struct	{
			BYTE l;
			BYTE h;
			} b;	// for and/or operations
	struct	{
			WORD	local_power_status:1,	// 0
					over_current:1,			// 1
					spare1:6,				// 2-7
					spare2:8;				// 8-15
			} hub;	// individual hub bits
	struct	{
			WORD	connection:1,			// 0
					enable:1,				// 1
					suspend:1,				// 2
					over_current:1,			// 3
					reset:1,				// 4
					spare1:3,				// 5-7
					power:1,				// 8
					low_speed:1,			// 9
					spare2:6;				// 10-15
			} port;	// individual port bits
	} STATUS;

typedef struct
	{
	STATUS	status;
	STATUS	change;
	} STATUS_CHANGE, *PSTATUS_CHANGE;

extern BYTE	ChangeSummary[PORT_BYTES];

typedef struct
	{
	BYTE	frm_int:1;		// 0
	} HUB_INT_STAT;

typedef struct
	{
	BYTE	frm_int_en:1;	// 0
	} HUB_INT_EN;

typedef struct
	{
	BYTE	pwr_stat:1,		// 0
			over_current:1,	// 1
			bus_reset:1,	// 2
			rmt_wake_en:1,	// 3
			ls_rsm_oe:1;	// 4
	} HUB_REG;

typedef struct
	{
	BYTE	hub_suspend:1,	// 0
			lseop_req:1,	// 1
			lseop_dp_id:4,	// 2-5
			wakeup_det:1,	// 6
			lseop_det:1;	// 7
	} HUB_RSM_CTL;

typedef struct
	{
	BYTE	spare:2,		// 0-1
			suspend:1,		// 2
			spare2:2,		// 3-4
			dminus:1,		// 5
			dplus:1,		// 6
			resume:1;		// 7
	} RP_REG;

typedef struct
	{
	BYTE	spare1:1,		// 0
			enable:1,		// 1
			suspend:1,		// 2
			over_current:1,	// 3
			reset:1,		// 4
			spare2:2,		// 5-6
			resume:1;		// 7
	} DP_LO, *PLO;

typedef struct
	{
	BYTE	pwr_stat:1,		// 0
			low_spd:1,		// 1
			spare1:2,		// 2-3
			disc_det:1,		// 4
			dminus:1,		// 5
			dplus:1,		// 6
			trans_det:1;	// 7
	} DP_HI, *PHI;

typedef struct
	{
	DP_LO	lo;
	DP_HI	hi;
	} DP;

typedef union
	{
	WORD	wREADONLY;		// for READing both bytes ONLY
//
//	NEVER USE wREADONLY TO CLEAR BOTH REGS, THE COMPILER CLEARS THE SECOND BYTE BEFORE THE FIRST
//
	struct	{
			BYTE l;
			BYTE h;
			} b;	// for and/or operations
	DP		dp;		// individual bits
	} DPREG, *PDPREG;

void interrupt HubFrameIntService(void);
void HubSetConfiguration(void);
void HubReset(BYTE bPowerOn);
void HubSetDeviceFeature(void);
void HubClearDeviceFeature(void);
void HubSleep(void);
