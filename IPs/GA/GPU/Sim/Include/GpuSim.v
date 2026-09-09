//-------------------------------------------------------------------------------
// Command Queue Control Register
// 1	Start Flag(SF)
// 1.1	Operation Start Command Flag
// 2	Interrupt Enable Flag
// 2.1	ECI : Enable Complete Interrupt
// 2.2	EEI : Enable Error Notice Interrupt
// 2.3	EDI : Enable Download End Interrupt

wire			SF  = 1;
wire			ECI = 1;
wire			EEI = 1;
wire			EDI = 1;
//reg 	[31:0]	QDAT;	// Command Queue Write Data

//-------------------------------------------------------------------------------
// Command Buffer Control Register
// Main Memory에서 Read할 Command의 시작 주소
wire	[31:0]	RSA0 = 32'h00001000;
wire	[31:0]	RSA1 = 32'h00001400;
wire	[31:0]	RSA2 = 32'h00001800;
wire	[31:0]	RSA3 = 32'h00001C00;
//------------------------------------------------------------------------------
// Q Memory Download Control Register
// 1	DE : Download Enable -> GPU Hold -> Reset GPU
// 2	DL : Download 할 개수(word 단위, 2K Word)
// 3	DA : Current Download Address
// 
// Q Memory Download Data Register
// 1	DAT : Download Data
//------------------------------------------------------------------------------
wire	[10:0]	DL = 2048;
wire			DE = 1;
//-------------------------------------------------------------------------------
