
// DMA Maximum Burst Length
parameter CBMaxBL = 4;

parameter DW 	   = 64 -1;
parameter IW 	   = 4 -1;
parameter BW 	   = 8 -1;

parameter BBLQCD  = 2 -1;
parameter BBLQD   = 4 -1;
parameter BBLQW   = 3 -1;	// Q Width

// Register Address
// Command Queue
parameter CQCON		= 10'h00;
parameter CQSTS 	= 10'h04;
parameter CQDAT 	= 10'h08;

// Command Buffer
parameter CBCON    	= 10'h10;	// GPU Write Only
parameter CBRSA    	= 10'h14;
parameter CBDAT    	= 10'h18;

// Q Memory Download
parameter QDCON    	= 10'h20;
parameter QDDAT   	= 10'h24;
