//`define TEST

//`define DOWNSCALER
`define CHIP

//`define PCLKisACLK

parameter WID_WIDTH  = 4;	// AWID/WID/BID width
parameter RID_WIDTH  = 4;	// ARID/RID width
parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;
parameter NUM_BYTE   = DATA_WIDTH/8;

parameter ImageSize = 11;

parameter MaxBurst = 8;
parameter BCD      = MaxBurst>>1;

parameter VIFCTL  = 10'h00;		// Control
parameter VIFSTS  = 10'h04;		// Interrupt Status
parameter VIFSPOS = 10'h08;		// Source Position
parameter VIFSSIZ = 10'h0C;		// Source Size
parameter VIFADDR = 10'h10;		// Dma Offset
parameter VIFDSIZ = 10'h14;		// DMA Size
parameter VIFSCON = 10'h18;		// Down Scaler Controller
parameter VIFSRAT = 10'h1C;		// Down Scaler Ratio
