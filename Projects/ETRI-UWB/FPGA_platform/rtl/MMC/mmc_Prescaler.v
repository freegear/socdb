// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : mmc_Prescaler.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : Prescaler module of mmc/sd 
//  =============================================================================
`timescale 1ns/1ps

`define PRE_IDLE             1'b0
`define PRE_COUNT            1'b1

module mmc_Prescaler(
	PCLK,
	nRst,
	SDreset,
	SDIPRE,
	ENCLK,
// Outputs
	MMC_CLK,
    neg_CKPulse,
    CKPulse
                     );

// Inputs
input        PCLK;       
input        nRst;   	
input	SDreset;
input  [7:0] SDIPRE;    
input        ENCLK;    

// Outputs
output       MMC_CLK;   
output       neg_CKPulse; 
output       CKPulse; 


// Outputs
reg          MMC_CLK;    
wire         neg_CKPulse;
wire         CKPulse;



reg  [7:0] ClkDivCnt;

reg        CntState;
// Counter state
reg        NextCntState;


wire	ClkDivCnt0;
assign 	ClkDivCnt0	= (ClkDivCnt == 8'b00000000) ? 1'b1 : 1'b0;
assign 	CKPulse    	= ((ClkDivCnt0 & (~MMC_CLK) & ENCLK));
assign 	neg_CKPulse    	= (ClkDivCnt0 & MMC_CLK);//& ENCLK));
//assign 	neg_CKPulse    	= ~CKPulse;

wire	CntState0;
wire	CntState1;
//assign 	CntState0 = (CntState==1'b0);
//assign 	CntState1 = (CntState==1'b1);
assign 	CntState0 = (NextCntState==1'b0);
assign 	CntState1 = (NextCntState==1'b1);


always @(CntState or ClkDivCnt0 or ENCLK)
begin 

  NextCntState  = CntState;

  case (CntState)
    `PRE_IDLE :
     if ((ENCLK == 1'b1))
          NextCntState  = `PRE_COUNT;
      else
          NextCntState  = `PRE_IDLE;

    `PRE_COUNT :
      if ((ENCLK == 1'b0) && (ClkDivCnt0 == 1'b1)) 
          NextCntState  = `PRE_IDLE;
      else
          NextCntState  = `PRE_COUNT;

    default :
      NextCntState = `PRE_IDLE;
  endcase
end

always @(posedge PCLK or negedge nRst)
begin
  if (nRst == 1'b0)
      CntState  <= `PRE_IDLE;
  else
	if (SDreset)
      	CntState  <= `PRE_IDLE;
	else
      	CntState  <= NextCntState;
end 

always @(posedge PCLK or negedge nRst)
begin
  if (nRst == 1'b0)
    begin
      MMC_CLK   <= 1'b0;
    end
  else
    begin
	if (SDreset)
		MMC_CLK <= 1'b0;
	else if (CntState1/* & ENCLK*/ & ClkDivCnt0)
		MMC_CLK <= ~(MMC_CLK);
	else if (CntState0)//| (CntState1 & ~ENCLK & ~ClkDivCnt0))
		MMC_CLK	<= 1'b0;
	end
end

always @(posedge PCLK or negedge nRst)
begin
  if (nRst == 1'b0)
    begin
      ClkDivCnt <= 8'h00;
    end
  else
    begin
		if (SDreset)
		ClkDivCnt <= 8'h00;
		else if ((CntState1 & ENCLK & ClkDivCnt0))
		ClkDivCnt <= SDIPRE;
		else if (CntState1)
		ClkDivCnt <= ClkDivCnt -1;
		else if (CntState0)
		ClkDivCnt <= 8'h00;
	end
end
endmodule


// --============================== End ======================================--
