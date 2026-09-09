reg  [7:0]WEMDO;
reg  [10:0]PIA;
reg  [15:0]PIDI;
reg  [15:0]EEMDO;
reg  [31:0]RXD;
wire  [15:0]WIMD;
wire  [23:0]TIMO;
wire  [15:0]EIMO;
wire  [7:0]TROMO;
reg  SDI1, TI4, TXRDY, TE, TI0, TI3, TI2, TI1, RXWE,
     SDI2, XPOE, XPWE;
wire [15:0]PIDO;
wire [7:0]WEMDI;
wire [23:0]WEMA;
wire [15:0]EEMA;
wire [15:0]EEMDI;
wire [31:0]TXD;
wire [8:0]WIMA;
wire [15:0]WIMDI;
wire [8:0]TIMA;
wire [23:0]TIMI;
wire [8:0]TROMA;
wire [15:0]EIMDI;
wire [7:0]EIMA;
wire XEEMCE, XEIMCE, XTROMCE, XTIMCE, XWIMCE, XEIMWE, XTIMWE,
     XWIMWE, EXMBIH, SCKO, TO4, ADMCK, TO0, PRDY, TO1, LRCKO, TO3,
     TO2, SD2O, SD1O, TXSYNC, TXRD, RXSYNC, RXRDY, MLRCK, MSCK,
     XEEMWE, XWEMWE, XWEMOC;

reg	 SerialEn;
//------------------------------------------------------
SEIP SEIP(
// System
		.MCK		(MCK),
		.XRST		(XRST),
		
		.TE			(TE),
		.TI0		(TI0),
		.TI1		(TI1),
		.TI2		(TI2),
		.TI3		(TI3),
		.TI4		(TI4),
		.TO0		(TO0),
		.TO1		(TO1),
		.TO2		(TO2),
		.TO3		(TO3),
		.TO4		(TO4),
		
// MPU Interface
		.PIA		(PIA),
		.PIDI		(PIDI),
		.PIDO		(PIDO),
		.XPWE		(XPWE),
		.XPOE		(XPOE),
		.PRDY		(PRDY),

// PCM RX
		.RXD		(RXD),
		.RXWE		(RXWE),
		.RXRDY		(RXRDY),
		.RXSYNC		(RXSYNC),

// PCM TX
		.TXD		(TXD),
		.TXRD		(TXRD),
		.TXRDY		(TXRDY),
		.TXSYNC		(TXSYNC),

// I2S Interface
		.SD1O		(SD1O),
		.SD2O		(SD2O),
		.LRCKO		(LRCKO),
		.SCKO		(SCKO),
		.ADMCK		(ADMCK),
		.SDI1		(SDI1),
		.SDI2		(SDI2),
		.MLRCK		(MLRCK),
		.MSCK		(MSCK),

// Wave-Table ROM Interface
		.WEMA		(WEMA),
		.WEMDO		(WEMDO),
		.WEMDI		(WEMDI),
		.EXMBIH		(EXMBIH),
		.XWEMOC		(XWEMOC),
		.XWEMWE		(XWEMWE),

// RAM1 Interface
		.WIMA		(WIMA),
		.WIMD		(WIMD),
		.WIMDI		(WIMDI),
		.XWIMWE		(XWIMWE),
		.XWIMCE		(XWIMCE),

// RAM2 Interface
		.TIMA		(TIMA),
		.TIMO		(TIMO),
		.TIMI		(TIMI),
		.XTIMWE		(XTIMWE),
		.XTIMCE		(XTIMCE),

// RAM3 Interface
		.EIMA		(EIMA),
		.EIMO		(EIMO),
		.EIMDI		(EIMDI),
		.XEIMWE		(XEIMWE),
		.XEIMCE		(XEIMCE),

// RAM4 Interface
		.EEMA		(EEMA),
		.EEMDO		(EEMDO),
		.EEMDI		(EEMDI),
		.XEEMWE		(XEEMWE),
		.XEEMCE		(XEEMCE),

// ROM Interface
		.TROMA		(TROMA),
		.TROMO		(TROMO),
		.XTROMCE	(XTROMCE)
);
//------------------------------------------------------
// RAM1 Interface
RA1SH512x16 RAM1(
		.CLK		(MCK),
		.A			(WIMA),
		.Q			(WIMD),
		.D			(WIMDI),
		.WEN		(XWIMWE),
		.CEN		(XWIMCE)
);

// RAM2 Interface
RA1SH512x24 RAM2(
		.CLK		(MCK),
		.A			(TIMA),
		.Q			(TIMO),
		.D			(TIMI),
		.WEN		(XTIMWE),
		.CEN		(XTIMCE)
);

// RAM3 Interface
RA1SH256x16 RAM3(
		.CLK		(MCK),
		.A			(EIMA),
		.Q			(EIMO),
		.D			(EIMDI),
		.WEN		(XEIMWE),
		.CEN		(XEIMCE)
);

// RAM4 Interface
wire XEEMCE0 = ~(~EEMA[15] & ~EEMA[14] & ~XEEMCE);
wire XEEMCE1 = ~(~EEMA[15] &  EEMA[14] & ~XEEMCE);
wire XEEMCE2 = ~( EEMA[15] & ~EEMA[14] & ~XEEMCE);
wire XEEMCE3 = ~( EEMA[15] &  EEMA[14] & ~XEEMCE);

wire  [15:0]EEMDO_0;
wire  [15:0]EEMDO_1;
wire  [15:0]EEMDO_2;
wire  [15:0]EEMDO_3;

always @(XEEMCE0 or XEEMCE1 or XEEMCE2 or XEEMCE3 or
		 EEMDO_0 or EEMDO_1 or EEMDO_2 or EEMDO_3)
	case(1'b0) // synopsys parallel_case full_case
		XEEMCE0 : EEMDO = EEMDO_0;
		XEEMCE1 : EEMDO = EEMDO_1;
		XEEMCE2 : EEMDO = EEMDO_2;
		XEEMCE3 : EEMDO = EEMDO_3;
	endcase

RA1SH16384x16 RAM4_0(
		.CLK		(MCK),
		.A			(EEMA[13:0]),
		.Q			(EEMDO_0),
		.D			(EEMDI),
		.WEN		(XEEMWE),
		.CEN		(XEEMCE0)
);

RA1SH16384x16 RAM4_1(
		.CLK		(MCK),
		.A			(EEMA[13:0]),
		.Q			(EEMDO_1),
		.D			(EEMDI),
		.WEN		(XEEMWE),
		.CEN		(XEEMCE1)
);

RA1SH16384x16 RAM4_2(
		.CLK		(MCK),
		.A			(EEMA[13:0]),
		.Q			(EEMDO_2),
		.D			(EEMDI),
		.WEN		(XEEMWE),
		.CEN		(XEEMCE2)
);

RA1SH16384x16 RAM4_3(
		.CLK		(MCK),
		.A			(EEMA[13:0]),
		.Q			(EEMDO_3),
		.D			(EEMDI),
		.WEN		(XEEMWE),
		.CEN		(XEEMCE3)
);

// ROM Interface
RODSH512x8 ROM(
		.CLK		(MCK),
		.A			(TROMA),
		.Q			(TROMO),
		.CEN		(XTROMCE)
);
