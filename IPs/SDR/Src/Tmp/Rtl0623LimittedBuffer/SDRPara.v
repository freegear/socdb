
// Bus Define
parameter AW  = 22 -1;  		// Address Width
parameter DW  = 32 -1;			// Data Width
parameter BW  = 4 -1;			// Byte Width
parameter BL  = 4 -1;   		// Burst Length
parameter ID  = 4 -1;   		// ID Width

// Write Data Que Define
parameter WQCD  = 5 -1;			// Q Count Depth
parameter WQD   = 32 -1;			// Q Depth (Command Depth * Maximum Burst(16) * 2)
parameter WQW   = (DW+1) + (BW+1) -1;	// Q Width

// Read Data Que Define
parameter RQCD  = 5 -1;			// Q Count Depth
parameter RQD   = 32 -1;			// Q Depth(Command Depth * Maximum Burst(16) * 2)
parameter RQW   = (DW+1) + (ID+1) -1;	// Q Width

// Burst Length Que Define
parameter WBLQCD  = 1 -1;
parameter WBLQD   = 2 -1;
parameter WBLQW   = 2*(BL+1) +2 -1;	// Q Width

parameter RBLQCD  = 5 -1;
parameter RBLQD   = 32 -1;
parameter RBLQW   = 2*(BL+1) +2 -1;	// Q Width

// Memory define
parameter MDW  = 32 -1; 		// Data Width
parameter DMW  = 4 -1;  		// Dqm Width
parameter BAW  = 2 -1;	 		// Bank Address Width
parameter RAW  = 12 -1; 		// Row Address Width
parameter CAW  = 8 -1;	 		// Colomn Address Width

// Ras Que Define
parameter RasQW = (BAW+1) + (RAW+1) + (BL+1) -1; // RAS Q Width

// Cas Que Define
parameter RWW = 1;
parameter CasQW = (BAW+1) + (RAW+1) + (CAW+1) + (BL+1) + (RWW) + (ID+1) + 1 -1; // CAS Q Width

parameter CD = 3  -1;			// Q Count Depth

// extra sdram commands
parameter erc_powerup = 6'b000001; 
parameter erc_epc     = 6'b000010; 
parameter erc_ar      = 6'b000100; 
parameter erc_mrs     = 6'b001000; 
parameter erc_idle    = 6'b010000; 
parameter erc_normal  = 6'b100000;

// bank commands
parameter bc_null = 6'b000000;
parameter bc_mcas = 6'b000001; // multiple cas
parameter bc_mras = 6'b000010; // multiple ras
parameter bc_pc   = 6'b000100; // pre-charge
parameter bc_sras = 6'b001000; // single ras
parameter bc_scas = 6'b010000; // single cas
parameter bc_epc  = 6'b100000; // extra pre-charge

// extended bank commands
parameter ebc_null  = 7'b0000000;
parameter ebc_mcas  = 7'b0000001; // multiple cas
parameter ebc_mras  = 7'b0000010; // multiple ras
parameter ebc_pc    = 7'b0000100; // pre-charge
parameter ebc_sras  = 7'b0001000; // single ras
parameter ebc_scas  = 7'b0010000; // single cas
parameter ebc_epc   = 7'b0100000; // extra pre-charge
parameter ebc_bstop = 7'b1000000; // burst stop
