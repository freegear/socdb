`timescale 1ns / 100ps

module I2cReg (
            Clk, nRst, 
	    	PSEL, PENABLE, PADDR, PWRITE, PWDATA, 
	    	PRDATA, 

            RStatus,      	// RStatus Register(read only)
            RSetIFlg, 
            RClearSTA, 
            RClearSTP,
            RrData,

	    	    REnab,         	// Bus Enable 
            RGCEnab, 
            RSTA,          	// Master mode STArt
            RSTP,          	// Master mode stop
            RIFlg,         	// Interrupt flag
            RAAK,          	// Assert acknowledge 
            I2cInt,         // process interrupt line
            I2cAAS,         // AAS Interrupt Line
            I2cSRst,    	  // Software Reset
            RCCR,          	// Clock Control Register
            RSlavAddr,   
            RExtendAddr,
            RwData
);

input         Clk;
input         nRst;

input  [ 4:2] PADDR;
input         PWRITE;
input         PSEL;
input         PENABLE;
input  [15:0] PWDATA;
output [31:0] PRDATA;

// i2c
input  [ 4:0] RStatus;
input         RSetIFlg;
input         RClearSTA;
input         RClearSTP;
input  [ 7:0] RrData;

output        REnab; 
output        RGCEnab; 
output        RSTA; 
output        RSTP; 
output        RIFlg; 
output        RAAK; 
output        I2cInt; 
output        I2cAAS;
output        I2cSRst;

output [ 6:0] RCCR;
output [ 6:0] RSlavAddr;
output [ 7:0] RExtendAddr;
output [ 7:0] RwData;
//--------------------------------------------
// Address & Command Decode
wire RegWr =  PWRITE;
wire RegRd = ~PWRITE;

wire I2CSel     = PSEL & !PENABLE;

wire RCtlCs   	=  I2CSel & ~PADDR[4] & ~PADDR[3] & ~PADDR[2];	// 0x00
wire RStatusCs  =  I2CSel & ~PADDR[4] & ~PADDR[3] &  PADDR[2];	// 0x04
wire RSlavAddrCs=  I2CSel & ~PADDR[4] &  PADDR[3] & ~PADDR[2];	// 0x08
wire RDataCs   	=  I2CSel & ~PADDR[4] &  PADDR[3] &  PADDR[2]; 	// 0x0C
wire RCCRCs   	=  I2CSel &  PADDR[4] & ~PADDR[3] & ~PADDR[2];	// 0x10
wire RSRstCs    =  I2CSel &  PADDR[4] & ~PADDR[3] &  PADDR[2];	// 0x14
//wire RHStatCs   =  I2CSel &  PADDR[4] &  PADDR[3] & ~PADDR[2];// 0x18 hidden reg

wire RSlavAddrWr= RSlavAddrCs & RegWr;
wire RDataWr   	= RDataCs     & RegWr;
wire RCtlWr   	= RCtlCs      & RegWr;
wire RCCRWr   	= RCCRCs      & RegWr;
wire RStatusWr  = RStatusCs   & RegWr;
wire RSRstWr   	= RSRstCs     & RegWr;

wire RSlavAddrRd= RSlavAddrCs & RegRd;
wire RDataRd   	= RDataCs     & RegRd;
wire RCtlRd   	= RCtlCs      & RegRd;
wire RCCRRd   	= RCCRCs      & RegRd;
wire RStatusRd  = RStatusCs   & RegRd;
//wire RHStatRd   = RHStatCs    & RegRd;
//--------------------------------------------
reg [7:0] RExtendAddr;
reg [6:0] RSlavAddr;
reg       RGCEnab; 
reg [7:0] RwData; 
reg [6:0] RCCR;
reg       RIntEn; 
reg       REnab; 
reg       RSTA; 
reg       RSTP; 
reg       RIFlg; 
reg       RAAK; 
reg       I2cSRst;

// i2c Slave Address Register
always @(negedge nRst or posedge Clk)
  if      (!nRst)       RExtendAddr <= 8'b0;
  else if (RSlavAddrWr) RExtendAddr <= PWDATA[15:8];

always @(negedge nRst or posedge Clk)
  if      (!nRst)       RSlavAddr <= 7'b0;
  else if (RSlavAddrWr) RSlavAddr <= PWDATA[7:1];

always @(negedge nRst or posedge Clk)
  if      (!nRst)       RGCEnab <= 7'b0;
  else if (RSlavAddrWr) RGCEnab <= PWDATA[0];

// i2c Data Register
always @(negedge nRst or posedge Clk)
  if      (!nRst)       RwData <= 8'b0;
  else if (RDataWr)     RwData <= PWDATA[7:0];

// i2c Clock Control Register
always @(negedge nRst or posedge Clk)
  if      (!nRst)       RCCR <= 7'b0;
  else if (RCCRWr)      RCCR <= PWDATA[6:0];

// i2c Control Register
always @(negedge nRst or posedge Clk) 
  if     (!nRst)        begin
                        RAAK   <= 1'b0;
                        RIntEn <= 1'b0;
                        end
  else if (RCtlWr)      begin     
                        RAAK   <= PWDATA[7];
                        RIntEn <= PWDATA[5];
                        end

always @(negedge nRst or posedge Clk)
  if      (!nRst)       RIFlg <= 1'b0; 
  else if (I2cSRst | RCtlWr & ~PWDATA[4]) 
                        RIFlg <= 1'b0; 
  else if (RSetIFlg)    RIFlg <= 1'b1;
  else                  RIFlg <= RIFlg;

// Control Status
always @(negedge nRst or posedge Clk)
  if      (!nRst)      RSTP <= 1'b0; 
  else if (I2cSRst)    RSTP <= 1'b0;  
  else if (RStatusWr & ~PWDATA[5]) 
                       RSTP <= 1'b1; 
  else if (RClearSTP)  RSTP <= 1'b0;
  else   	           RSTP <= RSTP; 

always @(negedge nRst or posedge Clk)
  if      (!nRst)      RSTA <= 1'b0; 
  else if (I2cSRst)    RSTA <= 1'b0; 
  else if (RStatusWr &  PWDATA[5]) 
                       RSTA <= 1'b1; 
  else if (RClearSTA)  RSTA <= 1'b0;
  else   	           RSTA <= RSTA; 

always @(negedge nRst or posedge Clk) 
  if     (!nRst)        REnab <= 1'b0;
  else if (RStatusWr)   REnab <= PWDATA[6];
//----------------------------------------
// Software Reset Register
always @(negedge nRst or posedge Clk)
  if      (!nRst)       I2cSRst <= 1'b0;
  else if (RSRstWr)     I2cSRst <= PWDATA[0];
  else if (I2cSRst)     I2cSRst <= 1'b0;
  else                  I2cSRst <= I2cSRst;
//----------------------------------------
wire aas;

reg I2cAAS ;
always @(negedge nRst or posedge Clk)
  if (!nRst) I2cAAS <= 1'b0;
  else       I2cAAS <= (RIFlg & RIntEn & aas);
  
reg I2cInt ;
always @(negedge nRst or posedge Clk)
  if (!nRst) I2cInt <= 1'b0;
  else       I2cInt <= (RIFlg & RIntEn & ~aas);

//----------------------------------------
// Register Read
reg  [15:0] RData;
//---------------------------------------
// Status decode

AASDecode AASDecode0(   .RStatus(RStatus), 
                              .AAS(aas));
              
always @(negedge nRst or posedge Clk)
  if (!nRst)        RData <= 16'b0;
  else begin
    case(1'b1) // synopsys parallel_case full_case
      RSlavAddrRd : RData <= {RExtendAddr, RSlavAddr, RGCEnab}; 
      RDataRd     : RData <= {8'b0, RrData}; 
      RCtlRd   	  : RData <= {8'b0, RAAK, 1'b0, RIntEn, RIFlg, 4'b0}; 
      RCCRRd   	  : RData <= {9'b0, RCCR};
      RStatusRd   : RData <= {10'b0, REnab,1'b0, RStatus[4:0]};
 
//      RStatusRd   : RData <= {11'b0, StatusOut[4], REnab, StatusOut[3:0]}; 
//	RHStatRd    : RData <= {8'b0, RStatus[4:0],3'b0}; 
    default       : RData <= 16'b0;
    endcase
  end
  
//      RStatusRd   : RData <= {11'b0, RStatus[4], REnab, RStatus[3:0]}; 



//----------------------------------------
assign PRDATA = {16'b0, RData};
//----------------------------------------

endmodule

//  - design  : I2C AAS bit Decode
//  - author  : Duck


module AASDecode(RStatus, AAS);

input   [4:0] RStatus;

output  AAS;

reg  AAS;
always @(RStatus)
begin
  case (RStatus)
  5'b01100,5'b01101,5'b10101,5'b10110 :  //60h 68h A8h B0h
      AAS <= 1'b1;
  default :
      AAS <= 1'b0;
  endcase
end

endmodule
