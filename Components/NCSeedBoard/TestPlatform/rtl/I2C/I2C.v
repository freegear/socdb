
/*-----------------------------------------------------------------------------
	- project : B2B
	- design  : I2C Controller Top
	- author  : East
	- file    : I2C.v
	- version : 0.1

	CopyRight(C) By NCSOFt CORPORATION. All Rights Reserved.
------------------------------------------------------------------------------*/

`timescale 1ns/10ps
module I2C (
       Clk, nRst,
	   PSEL, PENABLE, PADDR, PWRITE, PWDATA, 
	   PRDATA,
	   I2cInt,
	   I2cAAS,
	   ISCL, ISDA, OSCL, OSDA
);

input         Clk, nRst; 

input  [ 7:2] PADDR;
input         PSEL;
input         PENABLE;
input         PWRITE;
input  [15:0] PWDATA;
output [31:0] PRDATA;

output	[1:0] I2cInt;
output  [1:0] I2cAAS;

input  [1:0]  ISCL, ISDA;
output [1:0]  OSCL, OSDA;

wire       Enab0, GCEnab0, STA0, STP0, IFlg0, AAK0, SoftReset0;
wire       Enab1, GCEnab1, STA1, STP1, IFlg1, AAK1, SoftReset1;
wire [6:0] CCR0, CCR1;
wire [6:0] SlaveAddr0, SlaveAddr1;
wire [7:0] ExtendAddr0, ExtendAddr1;
wire [7:0] WriteData0, WriteData1;

wire       SetIFlg0, ClearSTA0, ClearSTP0;
wire       SetIFlg1, ClearSTA1, ClearSTP1;
wire [4:0] Status0, Status1;
wire [7:0] ReadData0, ReadData1;

wire PSELI2C0 = PSEL & ~PADDR[7];
wire PSELI2C1 = PSEL &  PADDR[7];

wire [31:0] PRDATA0;
wire [31:0] PRDATA1;

reg  [31:0] PRDATA;
always @(PSELI2C0 or PSELI2C1 or PRDATA0 or PRDATA1)
  case(1'b1) // synopsys parallel_case
    PSELI2C0 : PRDATA = PRDATA0;
    PSELI2C1 : PRDATA = PRDATA1;
    default  : PRDATA = 32'b0;
  endcase
  
I2cReg	I2cReg0	(
        .Clk		 (Clk), 
	    .nRst		 (nRst), 
	    .PADDR		 (PADDR[4:2]), 
		.PWRITE		 (PWRITE), 
		.PSEL 		 (PSELI2C0), 
		.PENABLE	 (PENABLE), 
		.PWDATA		 (PWDATA), 
		.PRDATA		 (PRDATA0), 
                     
        .RStatus	 (Status0),
        .RSetIFlg	 (SetIFlg0), 
        .RClearSTA	 (ClearSTA0), 
        .RClearSTP	 (ClearSTP0),
        .RrData		 (ReadData0),
                     
	    .REnab		 (Enab0),
        .RGCEnab	 (GCEnab0), 
        .RSTA		 (STA0),
        .RSTP		 (STP0),
        .RIFlg		 (IFlg0),
        .RAAK		 (AAK0),
        .I2cInt		 (I2cInt[0]),
        .I2cAAS     (I2cAAS[0]),        
        .I2cSRst	 (SoftReset0),
        .RCCR		 (CCR0),
        .RSlavAddr	 (SlaveAddr0),   
        .RExtendAddr (ExtendAddr0),
        .RwData		 (WriteData0)
);
  
I2cReg	I2cReg1	(
        .Clk		 (Clk), 
	    .nRst		 (nRst), 
	    .PADDR		 (PADDR[4:2]), 
		.PWRITE		 (PWRITE), 
		.PSEL 		 (PSELI2C1), 
		.PENABLE	 (PENABLE), 
		.PWDATA		 (PWDATA), 
		.PRDATA		 (PRDATA1), 
                     
        .RStatus	 (Status1),
        .RSetIFlg	 (SetIFlg1), 
        .RClearSTA	 (ClearSTA1), 
        .RClearSTP	 (ClearSTP1),
        .RrData		 (ReadData1),
                     
	    .REnab		 (Enab1),
        .RGCEnab	 (GCEnab1), 
        .RSTA		 (STA1),
        .RSTP		 (STP1),
        .RIFlg		 (IFlg1),
        .RAAK		 (AAK1),
        .I2cInt		 (I2cInt[1]),
        .I2cAAS   (I2cAAS[1]),
        .I2cSRst	 (SoftReset1),
        .RCCR		 (CCR1),
        .RSlavAddr	 (SlaveAddr1),   
        .RExtendAddr (ExtendAddr1),
        .RwData		 (WriteData1)
);

I2cCore I2cCore0 (
		.CLK		 (Clk), 
		.NRST		 (nRst), 
		.ISCL		 (ISCL[0]), 
		.ISDA		 (ISDA[0]),
                     
		.CCR		 (CCR0), 
		.SlaveAddr	 (SlaveAddr0), 
		.ExtSlaveAddr(ExtendAddr0), 
		.WriteData	 (WriteData0),
		.Enab		 (Enab0), 
		.GCEnab		 (GCEnab0), 
		.STA		 (STA0), 
		.STP		 (STP0), 
		.IFLG		 (IFlg0), 
		.AAK		 (AAK0), 
		.SoftReset	 (SoftReset0),
                                  
		.Status		 (Status0),
		.ReadData	 (ReadData0),
		.SetIFLG	 (SetIFlg0),
		.ClearSTA	 (ClearSTA0),
		.ClearSTP	 (ClearSTP0),
		.OSCL		 (OSCL[0]), 
		.OSDA		 (OSDA[0])
);

I2cCore I2cCore1 (
		.CLK		 (Clk), 
		.NRST		 (nRst), 
		.ISCL		 (ISCL[1]), 
		.ISDA		 (ISDA[1]),
                     
		.CCR		 (CCR1), 
		.SlaveAddr	 (SlaveAddr1), 
		.ExtSlaveAddr(ExtendAddr1), 
		.WriteData	 (WriteData1),
		.Enab		 (Enab1), 
		.GCEnab		 (GCEnab1), 
		.STA		 (STA1), 
		.STP		 (STP1), 
		.IFLG		 (IFlg1), 
		.AAK		 (AAK1), 
		.SoftReset	 (SoftReset1),
                                  
		.Status		 (Status1),
		.ReadData	 (ReadData1),
		.SetIFLG	 (SetIFlg1),
		.ClearSTA	 (ClearSTA1),
		.ClearSTP	 (ClearSTP1),
		.OSCL		 (OSCL[1]), 
		.OSDA		 (OSDA[1])
);

endmodule
