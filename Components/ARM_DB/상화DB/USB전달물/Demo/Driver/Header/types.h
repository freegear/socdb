////////////////////////////////////////////////////////////////////////
// This file contains type information used in MOON device driver
// (1) Structure Definition Included
// (2) Constant Definition Included
// (3) Enum Definition Included
////////////////////////////////////////////////////////////////////////

#define		UINT		unsigned int
#define		USHORT		unsigned short
#define		UCHAR		unsigned char

#define		PUINT		unsigned int	*
#define		PUSHORT		unsigned short	*
#define		PUCHAR		unsigned char	*

#define		EXTERN_INTR3	0x0c
#define		EXTREN_INTR2	0x0b
#define		EXTERN_INTR1	0x0a
#define		EXTERN_INTR0	0x09
#define		RTC_INTR		0x08
#define		TIMER_INTR2		0x07
#define		TIMER_INTR1		0x06
#define		TIMER_INTR0		0x05
#define		MOUSE_INTR		0x04
#define		KBD_INTR		0x03
#define		UART_INTR1		0x02
#define		UART_INTR0		0x01
#define		SOFT_INTR		0x00

#define		NUM_OF_SAVED_REG	0x04
	// The Number Of Parameter Saved For CallBack (Adjusting Value)
#define		NUM_OF_HANDLER		0x15
	// The Number Of Handler Can Be Registerd
#define		NUM_OF_PRIORITY		0x02
	// The Number Of Priority Supported in Job Queue
#define		NUM_JOB_QUEUE		0x10
	// The Number Of Entry in Each JOB Queue
	
#define		PRIOR_0			0
#define		PRIOR_1			1
#define		EMPTY			0
#define		OCCUPIED		1

#define		MASK_FOR_HPIRX			0x0020
#define		MASK_FOR_SARRX			0x0000
#define		MASK_FOR_SARTX			0x0000

#define		CALLBACK_FOR_HPIRX		0x00

typedef struct _JOB_QUE_ENTRY	{
	UCHAR	JOB_STS;					// JOB_STATUS
	UCHAR	JOB_TYPE;					// matched to interrupt ID
	USHORT	empty;
	UINT	REG_INFO[NUM_OF_SAVED_REG];	// Interrupt Related Information
} JOB_QUE_ENTRY;

typedef struct _JOB_QUE_CTRL	{
	UCHAR	WR_IDX;
	UCHAR	RD_IDX;
	UCHAR	FE_STS;
	UCHAR	QUE_SZ;
} JOB_QUE_CTRL;

typedef struct HPI_REG_TAG {
	USHORT	hpi_ctrl_reg;
	USHORT	hpi_d0_reg;
	USHORT	hpi_d1_reg;
	USHORT	hpi_d2_reg;
	USHORT	hpi_d3_reg;
	USHORT	hpi_d4_reg;
	USHORT	hpi_d5_reg;
	USHORT	hpi_d6_reg;
	USHORT	hpi_d7_reg;
}HPI_REG;


// JOB_STS : Occupied / Empty
// JOB_TYPE : indcates the service entity. JOB_HANDLER[JOB_TYPE] means service routine.

typedef		UINT (*PrFunc)	(unsigned int);

