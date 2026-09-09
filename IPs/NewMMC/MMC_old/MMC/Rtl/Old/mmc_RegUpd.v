`timescale 1ns/1ps

//----------------------------------------------------------------------
// Sync to MCLK domain
//----------------------------------------------------------------------

module mmc_RegUpd (
// Inputs
		MCLK,
        nRst,
		SDreset,

     	iSDIPRE,   
        SDIPREUpdSync,

		CmdArg,
        SDICmdArgUpdSync,
      	
		iSDICmdCon, 
		SDICmdConUpdSync,

        iSDIDatCon,
		SDIDatConUpdSync,
		
		iDataTimer,
		SDIDTimerUpdSync,

		iBlkSize,
		SDIBSizeUpdSync,

// Outputs
		SDIPRE,
		SDIPREUpdDone,
		
		SDICmdArg,
        SDICmdArgUpdDone,
		
		SDICmdCon,
        SDICmdConUpdDone,
		
		SDIDatCon,
        SDIDatConUpdDone,

		SDIDTimer,
		SDIDTimerUpdDone,

		SDIBSize,
		SDIBSizeUpdDone
                  );

// Inputs
input         	MCLK;         // MMCI adapter clock
input			nRst;
input			SDreset;

input [7:0]		iSDIPRE;
input			SDIPREUpdSync;

input [31:0]	CmdArg;
input			SDICmdArgUpdSync ;

input [12:0]	iSDICmdCon;
input           SDICmdConUpdSync;

input  [29:0]  	iSDIDatCon;
input			SDIDatConUpdSync;

input	[22:0]	iDataTimer;
input			SDIDTimerUpdSync;
input	[11:0]	iBlkSize;
input			SDIBSizeUpdSync;

output [7:0]	SDIPRE;
output		 	SDIPREUpdDone;

output [31:0]	SDICmdArg;
output          SDICmdArgUpdDone;

output [12:0]	SDICmdCon;
output			SDICmdConUpdDone;

output [29:0]	SDIDatCon;
output			SDIDatConUpdDone;

output	[22:0]	SDIDTimer;
output			SDIDTimerUpdDone;

output	[11:0]	SDIBSize;
output			SDIBSizeUpdDone;

reg     [7:0]	NextSDIPRE;
reg		NextSDIPREUpdDone;

reg     [31:0]	NextSDICmdArg;   
reg     NextSDICmdArgUpdDone;

reg     [12:0]	NextSDICmdCon;   
reg     NextSDICmdConUpdDone;

reg     [29:0]	NextSDIDatCon;   
reg     NextSDIDatConUpdDone;

reg		[22:0]  NextSDIDTimer;
reg		NextSDIDTimerUpdDone;

reg		[11:0] NextSDIBSize;
reg		NextSDIBSizeUpdDone;

reg     DelSDIPREUpdSync;
reg     DelSDICmdArgUpdSync;
reg		DelSDICmdConUpdSync;
reg	    DelSDIDatConUpdSync;
reg		DelSDIDTimerUpdSync;
reg		DelSDIBSizeUpdSync;

reg		[7:0]	SDIPRE;
reg     SDIPREUpdDone;

reg		[31:0]	SDICmdArg;
reg     SDICmdArgUpdDone;
     
reg	  	[12:0]	SDICmdCon;
reg     SDICmdConUpdDone ;

reg     [29:0]	SDIDatCon;
reg     SDIDatConUpdDone;

reg		[22:0]	SDIDTimer;
reg		SDIDTimerUpdDone;

reg		[11:0]	SDIBSize;
reg		SDIBSizeUpdDone;


always @(posedge MCLK or negedge nRst)
begin 
  if (nRst == 1'b0)
    begin
      DelSDIPREUpdSync    <= 1'b0;
      DelSDICmdArgUpdSync <= 1'b0;
      DelSDICmdConUpdSync <= 1'b0;
      DelSDIDatConUpdSync <= 1'b0;
	  DelSDIDTimerUpdSync <= 1'b0;
      DelSDIBSizeUpdSync <= 1'b0;
    end
  else
	begin
		if (SDreset)
		begin
		DelSDIPREUpdSync    <= 1'b0;
		DelSDICmdArgUpdSync <= 1'b0;
		DelSDICmdConUpdSync <= 1'b0;
		DelSDIDatConUpdSync <= 1'b0;
		DelSDIDTimerUpdSync <= 1'b0;
		DelSDIBSizeUpdSync <= 1'b0;
		end
		else
		begin
      	DelSDIPREUpdSync    <= SDIPREUpdSync;
      	DelSDICmdArgUpdSync <= SDICmdArgUpdSync;
      	DelSDICmdConUpdSync <= SDICmdConUpdSync;
      	DelSDIDatConUpdSync <= SDIDatConUpdSync;
	  	DelSDIDTimerUpdSync <= SDIDTimerUpdSync; 
      	DelSDIBSizeUpdSync <=  SDIBSizeUpdSync;
    	end
	end
end


wire	SDIPREStg2WrEn;
wire	SDICmdArgStg2WrEn;
wire	SDICmdConStg2WrEn;
wire	SDIDatConStg2WrEn;
wire	SDIDTimerStg2WrEn;
wire	SDIBSizeStg2WrEn;
assign SDIPREStg2WrEn       = SDIPREUpdSync    ^ DelSDIPREUpdSync;

assign SDICmdArgStg2WrEn    = SDICmdArgUpdSync ^ DelSDICmdArgUpdSync;

assign SDICmdConStg2WrEn    = SDICmdConUpdSync ^ DelSDICmdConUpdSync;

assign SDIDatConStg2WrEn    = SDIDatConUpdSync ^ DelSDIDatConUpdSync;

assign SDIDTimerStg2WrEn    = SDIDTimerUpdSync ^ DelSDIDTimerUpdSync;

assign SDIBSizeStg2WrEn     = SDIBSizeUpdSync  ^ DelSDIBSizeUpdSync;


always @(SDIPREStg2WrEn or SDIPRE or iSDIPRE or SDIPREUpdDone)
begin 
  if (SDIPREStg2WrEn == 1'b1)
    begin
      NextSDIPRE        = iSDIPRE;
      NextSDIPREUpdDone = ~(SDIPREUpdDone);
    end
  else
    begin
      NextSDIPRE        = SDIPRE;
      NextSDIPREUpdDone = SDIPREUpdDone;
    end
end 

always @(SDICmdArgStg2WrEn or SDICmdArg or CmdArg or SDICmdArgUpdDone)
begin 
  if (SDICmdArgStg2WrEn == 1'b1)
    begin
      NextSDICmdArg        = CmdArg;
      NextSDICmdArgUpdDone = ~(SDICmdArgUpdDone);
    end
  else
    begin
      NextSDICmdArg        = SDICmdArg;
      NextSDICmdArgUpdDone = SDICmdArgUpdDone;
    end
end 

always @(SDICmdConStg2WrEn  or iSDICmdCon or SDICmdCon or SDICmdConUpdDone)
begin 
  if (SDICmdConStg2WrEn == 1'b1)
    begin
      NextSDICmdCon    = iSDICmdCon;
      NextSDICmdConUpdDone = ~(SDICmdConUpdDone);
    end
  else
    begin
      NextSDICmdCon        = SDICmdCon;
      NextSDICmdConUpdDone = SDICmdConUpdDone;
    end
end 

always @(SDIDatConStg2WrEn or SDIDatCon or SDIDatConUpdDone or iSDIDatCon)
begin 
  if (SDIDatConStg2WrEn == 1'b1)
    begin
      NextSDIDatCon    =  iSDIDatCon;
      NextSDIDatConUpdDone = ~(SDIDatConUpdDone);
    end
  else
    begin
      NextSDIDatCon        = SDIDatCon;
      NextSDIDatConUpdDone = SDIDatConUpdDone;
    end
end 

always @(SDIDTimerStg2WrEn or  iDataTimer or SDIDTimerUpdDone or SDIDTimer) 
begin
  if (SDIDTimerStg2WrEn == 1'b1)
    begin
      NextSDIDTimer    = iDataTimer;
      NextSDIDTimerUpdDone = ~(SDIDTimerUpdDone);
    end
  else
    begin
      NextSDIDTimer        = SDIDTimer;
      NextSDIDTimerUpdDone = SDIDTimerUpdDone;
    end
end

always @(SDIBSizeStg2WrEn or  iBlkSize or SDIBSize or SDIBSizeUpdDone)
begin
  if (SDIBSizeStg2WrEn == 1'b1)
    begin
      NextSDIBSize    = iBlkSize ;
      NextSDIBSizeUpdDone = ~(SDIBSizeUpdDone);
    end
  else
    begin
      NextSDIBSize        = SDIBSize;
      NextSDIBSizeUpdDone = SDIBSizeUpdDone;
    end
end

always @(posedge MCLK or negedge nRst)
begin
  if (nRst == 1'b0)
    begin
      SDIPRE           <= 12'h01;
      SDIPREUpdDone    <= 1'b0;

      SDICmdArg        <= 32'h00000000;
      SDICmdArgUpdDone <= 1'b0;
      
	  SDICmdCon        <= 14'd0;
      SDICmdConUpdDone <= 1'b0;

      SDIDatCon        <= 30'd0;
      SDIDatConUpdDone <= 1'b0;

	  SDIDTimer			<= 23'h010000;
	  SDIDTimerUpdDone <= 1'b0;

	  SDIBSize			<=12'h000;
	  SDIBSizeUpdDone	<= 1'b0;
	end

  else
		begin
			if (SDreset)
			begin
			SDIPRE           <= 12'h01;
			SDIPREUpdDone    <= 1'b0;

			SDICmdArg        <= 32'h00000000;
			SDICmdArgUpdDone <= 1'b0;
      
			SDICmdCon        <= 14'd0;
			SDICmdConUpdDone <= 1'b0;

			SDIDatCon        <= 30'd0;
			SDIDatConUpdDone <= 1'b0;

			SDIDTimer			<= 23'h010000;
			SDIDTimerUpdDone <= 1'b0;

			SDIBSize			<=12'h000;
			SDIBSizeUpdDone	<= 1'b0;
			end
			else
			begin
			SDIPRE           <= NextSDIPRE;
			SDIPREUpdDone    <= NextSDIPREUpdDone;

			SDICmdArg        <= NextSDICmdArg;
			SDICmdArgUpdDone <= NextSDICmdArgUpdDone;
     
			SDICmdCon        <= NextSDICmdCon;
			SDICmdConUpdDone <= NextSDICmdConUpdDone;

			SDIDatCon        <= NextSDIDatCon;
			SDIDatConUpdDone <= NextSDIDatConUpdDone;

			SDIDTimer			<= NextSDIDTimer;
			SDIDTimerUpdDone  <= NextSDIDTimerUpdDone;

			SDIBSize			<= NextSDIBSize;
			SDIBSizeUpdDone   <= NextSDIBSizeUpdDone;
			end
	    end
end 
endmodule

// --============================== End ======================================--a
