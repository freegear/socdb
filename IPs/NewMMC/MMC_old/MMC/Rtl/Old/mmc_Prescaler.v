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

`define ST_CNT_IDLE             1'b0
`define ST_CNT_COUNT            1'b1

module mmc_Prescaler(
	MCLK,
	nRst,
	SDIPRE,
	ENCLK,
// Outputs
	MMC_CLK,
        DIVlevelCo
                     );

// Inputs
input        MCLK;       
input        nRst;   	
input  [7:0] SDIPRE;    
input        ENCLK;    

// Outputs
output       MMC_CLK;   
output       DIVlevelCo; 

// Outputs
reg          MMC_CLK;    
wire         DIVlevelCo;



// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg        NextMMC_CLK;
// D-input of MMC_CLK

reg  [7:0] ClkDivCnt;
// Clk divider counter

reg  [7:0] NextClkDivCnt;
// D-input of ClkDivCnt

reg        CntState;
// Counter state
reg        NextCntState;
// D-input of CntState

// Indication that the Clock Divider counter has reached 0

wire	ClkDivCnt0;

assign ClkDivCnt0       = (ClkDivCnt == 8'b00000000) ? 1'b1 : 1'b0;
assign DIVlevelCo       = ((ClkDivCnt0 & ( ~MMC_CLK) & ENCLK));

always @(CntState or ClkDivCnt0 or ENCLK or MMC_CLK or
         ClkDivCnt or SDIPRE)
begin 

  // Default assignments
  NextMMC_CLK   = MMC_CLK;
  NextCntState  = CntState;
  NextClkDivCnt = ClkDivCnt;

  case (CntState)
    `ST_CNT_IDLE :
   if ((ENCLK == 1'b1))
        begin
          NextCntState  = `ST_CNT_COUNT;
          NextClkDivCnt = SDIPRE;
          NextMMC_CLK   = 1'b1;
        end
      else
        begin
          NextCntState  = `ST_CNT_IDLE;
          NextClkDivCnt = 8'b00000000;
	  NextMMC_CLK   = 1'b0;
        end

    `ST_CNT_COUNT :

      if ((ENCLK == 1'b0) && (ClkDivCnt0 == 1'b1)) //&& (MMC_CLK == 1'b1))// 실제로는 출력부분에서 clock disable할 수 있게... 수정..
        begin
          NextCntState  = `ST_CNT_IDLE;
          NextClkDivCnt = 8'b00000000;
          NextMMC_CLK   = 1'b0;
        end

      else if (ClkDivCnt0 == 1'b1)
        begin
          NextCntState  = `ST_CNT_COUNT;
          NextClkDivCnt = SDIPRE;
          NextMMC_CLK   = ~(MMC_CLK);
        end
      else
        begin
          NextCntState  = `ST_CNT_COUNT;
          NextClkDivCnt = (ClkDivCnt) - 1;
        end

    default :
      NextCntState = `ST_CNT_IDLE;
  endcase
end

always @(posedge MCLK or negedge nRst)
begin
  if (nRst == 1'b0)
    begin
      ClkDivCnt <= 8'h00;
      CntState  <= `ST_CNT_IDLE;
      MMC_CLK   <= 1'b0;
    end
  else
    begin
      ClkDivCnt <= NextClkDivCnt;
      CntState  <= NextCntState;
      MMC_CLK   <= NextMMC_CLK;
    end
end 
endmodule

// --============================== End ======================================--
