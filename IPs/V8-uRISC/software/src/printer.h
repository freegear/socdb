// printer.h

typedef struct
	{
	BYTE	Tstrobe:4,	// which is the length of the STROBE_N, 0=1 clock, 0xf=16 clocks.
			Tsetup:4;	// which is the amount of time that the data is stable before STROBE_N is driven active, 0=1 clock, 0xf=16 clocks.
	} CTRS_1284;

typedef struct
	{
	BYTE	STDIS:1,	// This bit when 1, disables the automatic STROBE_N generation logic. This bit is must be set before setting the STLOW bit.
			STLOW:1,	// This bit when 1 forces STROBE_N low. This provides a software controllable means of communicating with the peripheral.
			DRVDO:1,	// This bit forces the tristate enable on the P1284 pins to the ON state. This allows the V1284 core to drive data onto these pins without activating the STROBE_N signal.
			spare:1,
			Thold:4;	// which is the length of time that data is held stable after the deassertion of STROBE_N. 0=1 clk, 0xf=16clks
	} CTRH_1284;

typedef struct
	{
	// When the respective bit=1, the signal is driving, when zero, the signal is in tristate.
	BYTE	fault_n:1,
			select:1,
			perror:1,
			busy:1,
			ack_n:1,
			selectin_n:1,
			autofeed_n:1,
			init_n:1;
	} CTL_1284;

extern volatile BYTE		PP_DATA;	// External Parallel Printer data register
extern volatile CTRS_1284	PP_CTRS;	// External Parallel Printer 
extern volatile CTRH_1284	PP_CTRH;	// External Parallel Printer 
extern volatile CTL_1284	PP_CTL;		// External Parallel Printer control signal register
extern volatile CTL_1284	PP_CTLZ;	// External Parallel Printer control signal direction register

extern BYTE USB_PRINTER_MODE;
extern BYTE DEVICE_ID_1284[];	// dunno max size yet
extern BYTE DEVICE_ID_LENGTH;

void Init1284(void);
void get1284id(void);

