
// AXI BUS Define
`define SIZE_BYTE	3'b000
`define SIZE_HWORD	3'b001
`define SIZE_WORD	3'b010
`define SIZE_DWORD	3'b011

`define BURST_FIXED	2'b00
`define BURST_INCR	2'b01
`define BURST_WRAP	2'b10

// Internal Bus Width
parameter AW = 30 -1;
parameter DW = 32 -1;	// Data Width; only support 32 now
parameter IW = 4 -1;	// ID Width
parameter BW = 4 -1;

// Image Size
parameter XW = 11 -1;
parameter YW = 11 -1;

// DMA Maximum Burst Length
parameter CPlaneMaxBL = 8;
parameter GPlaneMaxBL = 8;
parameter VPlaneMaxBL = 8;

parameter CBLQCD  = 2 -1;
parameter CBLQD   = 4 -1;
parameter CBLQW   = 4 -1;	// Q Width

parameter GBLQCD  = 3 -1;
parameter GBLQD   = 8 -1;
parameter GBLQW   = 4 -1;	// Q Width

parameter VBLQCD  = 3 -1;
parameter VBLQD   = 8 -1;
parameter VBLQW   = 4 -1;	// Q Width

/*
parameter CPlaneMaxBL = 4;
parameter GPlaneMaxBL = 4;
parameter VPlaneMaxBL = 4;

parameter CBLQCD  = 3 -1;
parameter CBLQD   = 8 -1;
parameter CBLQW   = 4 -1;	// Q Width

parameter GBLQCD  = 4 -1;
parameter GBLQD   = 16 -1;
parameter GBLQW   = 4 -1;	// Q Width

parameter VBLQCD  = 4 -1;
parameter VBLQD   = 16 -1;
parameter VBLQW   = 4 -1;	// Q Width
*/

// Register Address
// LCD Master
parameter DMCON		= 10'h00;  	
parameter DMSTS 	= 10'h04;  

// Plane Mixer
parameter CPOS    	= 10'h10;  
parameter GPOS    	= 10'h14;  
parameter VPOS    	= 10'h18;  

// Cursor Plane
parameter CCON    	= 10'h20;  
parameter CBLND   	= 10'h24;  
parameter CBMOD   	= 10'h28;  
parameter CBASE   	= 10'h2C; 

parameter CADDR   	= 10'h30;  
parameter CBLINK   	= 10'h34;  

// BackGround
parameter BGCOL   	= 10'h40;  

// Graphic Plane
parameter GCON    	= 10'h50;  
parameter GBLND   	= 10'h54;  
parameter GBMOD   	= 10'h58;  
parameter GBASE   	= 10'h5C;  

parameter GADDR   	= 10'h60;  
parameter GPALM   	= 10'h64;  

parameter GGAMMA00 	= 10'h100;
parameter GGAMMA01 	= 10'h104;
parameter GGAMMA02 	= 10'h108;
parameter GGAMMA03 	= 10'h10c;
parameter GGAMMA04 	= 10'h110;
parameter GGAMMA05 	= 10'h114;
parameter GGAMMA06 	= 10'h118;
parameter GGAMMA07 	= 10'h11c;
parameter GGAMMA08 	= 10'h120;
parameter GGAMMA09 	= 10'h124;
parameter GGAMMA0A 	= 10'h128;
parameter GGAMMA0B 	= 10'h12c;
parameter GGAMMA0C 	= 10'h130;
parameter GGAMMA0D 	= 10'h134;
parameter GGAMMA0E 	= 10'h138;
parameter GGAMMA0F 	= 10'h13c;
parameter GGAMMA10 	= 10'h140;

// Video Plane
parameter VCON    	= 10'h70;        
parameter VBLND   	= 10'h74;   
parameter VBMOD   	= 10'h78;   
parameter VBASE   	= 10'h7C;

parameter VADDR   	= 10'h80;   
parameter VADDR2  	= 10'h84;

// Video Scaler
parameter SCON    	= 10'h90;
parameter SSIZE   	= 10'h94;   
parameter SRATIO  	= 10'h98; 
  
parameter VGAMMA00 	= 10'h200;
parameter VGAMMA01 	= 10'h204;
parameter VGAMMA02 	= 10'h208;
parameter VGAMMA03 	= 10'h20c;
parameter VGAMMA04 	= 10'h210;
parameter VGAMMA05 	= 10'h214;
parameter VGAMMA06 	= 10'h218;
parameter VGAMMA07 	= 10'h21c;
parameter VGAMMA08 	= 10'h220;
parameter VGAMMA09 	= 10'h224;
parameter VGAMMA0A 	= 10'h228;
parameter VGAMMA0B 	= 10'h22c;
parameter VGAMMA0C 	= 10'h230;
parameter VGAMMA0D 	= 10'h234;
parameter VGAMMA0E 	= 10'h238;
parameter VGAMMA0F 	= 10'h23c;
parameter VGAMMA10 	= 10'h240;

// LCD Time Gen.
parameter LCDCON  	= 10'hE0;
parameter LECON	    = 10'hE4;
parameter HSYNC0	= 10'hF0;
parameter HSYNC1	= 10'hF4;
parameter VSYNC0	= 10'hF8;
parameter VSYNC1	= 10'hFC;