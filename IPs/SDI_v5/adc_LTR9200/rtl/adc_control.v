// ===================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : adc_control.v 
// File Revision       : 1.0
//                       1.1 Read register modified
//                       1.2 STBY mode modified
//                       1.3 ReadStart mode
//                       1.4 IDEL -> IDLE 
//
//  ------------------------------------------------------------------
//  Purpose            : ADC controller (LTR9200-T18)
//  ==================================================================


`define ADDRREG0  2'b00      //0x00  ADCON register addr.
`define ADDRREG1  2'b01      //0x04  ADCDAT register addr.

`timescale 1ns/100ps
module	adc_control(

  //APB interface
    PCLK         , 
    PRESETn      , 
    PENABLE      , 
    PSEL         , 
    PWRITE       , 
    PADDR        ,  //[3:2] used
    PWDATA       ,  //[15:0] used
    PRDATA       ,
    
    INT_ADC      ,
    CLK_ADCCLK   ,

  //ADC interface

    SOC,  //start of conversion
    SEL,  //Select channel
    SHDN, //shutdown mode
    EOC,  //end of conversion
    DOUT // [9:0]
	);

// ADC interface
input [9:0] DOUT;
input EOC;
output  SHDN;
output  SOC;
output  [2:0] SEL;

// APB interface
input	PCLK;
input	CLK_ADCCLK;
input	PRESETn;

input	[3:2]	PADDR;
input	[15:0]	PWDATA;

input	PSEL;
input	PWRITE ;
input	PENABLE;

output	[31:0]	PRDATA;
output	INT_ADC;

wire  	[31:0]	PRDATA;

//
//  ADC register
//

reg   [15:0]  rADCCON;
reg   [9:0]   rADCDAT;

wire	ADEN;
wire	EN_INTb;
wire  READ_START;
wire  STBY;
wire  [5:3]   ASEL;
wire          FLAG;
wire  Valid;


assign  ADEN = rADCCON[0];        //ADC_STATE = START --> clear
assign  READ_START = rADCCON[1];
assign  STBY = rADCCON[2];
assign  ASEL[5:3] = rADCCON[5:3];
assign  FLAG     = rADCCON[15];
assign  EN_INTb  = rADCCON[14];
assign  SEL[2:0] = rADCCON[5:3];

assign Valid = (PSEL & (!PENABLE));


// STATE MACHINE   _______________________________________

reg [3:0] ADC_STATE ;
reg [3:0] NX_ADC_STATE;  // next state
reg [2:0] adcclk_count;

`define IDLE      4'd0 
`define HALT      4'd1
`define CHK_READ  4'd2
`define START     4'd3
`define WAIT      4'd4
`define READADC   4'd5
`define INT       4'd6

wire  READOP  = PENABLE && PSEL && !PWRITE && (`ADDRREG1 == PADDR[3:2]); 
                // Read operation
                // add (`ADDRREG1 == PADDR[3:2]) Ver1.3
wire  WRITEOP = PENABLE && PSEL && PWRITE;  // Write operation

reg   CLK_ADCCLK_1d;
wire  CLK_ADCCLK_M;

assign  CLK_ADCCLK_M = (CLK_ADCCLK && !CLK_ADCCLK_1d);

always  @(negedge PRESETn or posedge PCLK)
begin

	if(!PRESETn) begin
    CLK_ADCCLK_1d <= 1'b0;
	end
  else begin
    CLK_ADCCLK_1d <= CLK_ADCCLK;
  end
    
end


always  @(negedge PRESETn or posedge PCLK)
begin

	if(!PRESETn) begin
        adcclk_count <= 3'd0;
	end
	else begin

    if(CLK_ADCCLK_M && (ADC_STATE == `START))
    begin
      adcclk_count <= adcclk_count + 3'd1;
    end
    else if(CLK_ADCCLK_M && (ADC_STATE != `START))
    begin
      adcclk_count <= 3'd0;
    end
  end

end


always  @(ADC_STATE 
          or  EOC 
          or  READ_START
          or  ADEN
          or  STBY
          or  READOP
          or  adcclk_count
          or  EN_INTb
          or  CLK_ADCCLK_M

         )
begin
  case(ADC_STATE)

    //synopsys parallel_case
    `IDLE : begin
              if(STBY)
                NX_ADC_STATE = `HALT;
              else if(READ_START && !EOC && !STBY) // Ver 1.2 add (&& !STBY)
                NX_ADC_STATE = `CHK_READ;
              else if(ADEN && !EOC && !STBY) // Ver 1.2 add (&& !STBY)
                NX_ADC_STATE = `START;
              else
                NX_ADC_STATE = `IDLE;
            end

    `HALT:  begin // Ver 1.2 add
              if(STBY)
                  NX_ADC_STATE = `HALT;
              else
                  NX_ADC_STATE = `IDLE;
            end

    `CHK_READ:
            begin
              if(READOP || ADEN) //Ver1.3
                NX_ADC_STATE = `START;
              else
                NX_ADC_STATE = `CHK_READ;
            end

    `START:
            begin
              if(adcclk_count >=2)
                NX_ADC_STATE = `WAIT;
              else
                NX_ADC_STATE = `START;
            end

    `WAIT:
            begin
              if(STBY)
                NX_ADC_STATE = `HALT;
              else if(EOC && CLK_ADCCLK_M)
                NX_ADC_STATE = `READADC;
              else
                NX_ADC_STATE = `WAIT;
            end

    `READADC:
            begin
              if(!EN_INTb)
                NX_ADC_STATE = `INT;
              else
                NX_ADC_STATE = `IDLE;
            end

    `INT:
            begin
              NX_ADC_STATE = `IDLE;
            end
    default:
          NX_ADC_STATE = `IDLE;

  endcase
end


always  @(negedge PRESETn or posedge PCLK) begin 
         //state machine register

	if(!PRESETn) begin
    ADC_STATE <= 4'd0;
	end
	else	begin
    ADC_STATE <= NX_ADC_STATE;
  end

end

// ADC input form ADC_CONTROLLER__________________________

//assign  SOC  = (ADC_STATE == `START) ? 1'b1 : 1'b0;
assign  SOC  = (ADC_STATE == `START) ? adcclk_count[0] : 1'b0;
assign  SHDN = (ADC_STATE == `HALT) ? 1'b1 : 1'b0;
assign  INT_ADC = (ADC_STATE == `INT) ? 1'b1 : 1'b0;

always @(negedge PRESETn or posedge PCLK)
begin
  if(!PRESETn)
  begin
    rADCDAT <= 10'd0;
  end
  else begin
    if(ADC_STATE == `READADC)
      rADCDAT <= DOUT;
  end
end

// INTERFACE READ & WRITE_________________________________


// ADC register write 
always @(negedge PRESETn or posedge PCLK)	begin

	if(!PRESETn) begin
        rADCCON <= 16'h4004;
	end
	else	begin
		if(WRITEOP && (PADDR[3:2] == `ADDRREG0)) begin
            rADCCON <= PWDATA[15:0];
        end
        else if(!WRITEOP && (ADC_STATE == `START)) begin   // clear 
            rADCCON[0]  <= 1'b0;
            rADCCON[15] <= 1'b0; //FALG <= progress conversion {busy}
        end
        /*
        else if(!WRITEOP && (ADC_STATE == `READADC)) begin // clear 
        rADCCON[15] <= 1'b1; //FLAG <= End of Coversion {not busy}
		    end
        else if(!WRITEOP && (ADC_STATE == `IDLE)) begin // clear 
        rADCCON[15] <= 1'b1; //FLAG <= End of Coversion {not busy}
        end
        */  // Ver 1.2 remove
        else if(EOC) begin
            rADCCON[15] <= 1'b1; //FLAG <= End of Coversion {not busy}
        end
    end
end

// ADC data read Ver1.1 modified
reg  [31:0] nextPRDATA      ;    // Mux, Register and Enable for PRDATA
reg  [31:0] ReadRegs        ;
reg  [15:0] iPRDATA         ;
wire ReadRegEn;

assign ReadRegEn = (Valid & (~PWRITE));

always @ (PADDR or ReadRegs )
begin : p_ReadMuxComb
  nextPRDATA = ReadRegs;  // Read as zero default
end

always @ (PADDR or rADCCON or rADCDAT)
begin : p_RdRegMuxComb
  case (PADDR[3:2]) 
  //synopsys parallel_case
        `ADDRREG0 : ReadRegs  = {{16{1'b0}},  rADCCON};
        `ADDRREG1 : ReadRegs  = {{12{1'd0}},  rADCDAT[9:0]};
         default  : ReadRegs  = {32{1'b0}}        ;  // Read as zero default
  endcase
end 

always @ (posedge PCLK or negedge PRESETn)
begin : p_PrdataSeq
  if ((!PRESETn))
    iPRDATA <= {16{1'b0}};
  else if (ReadRegEn)
    iPRDATA <= {{16{1'b0}}, nextPRDATA[15:0]};
end

assign  PRDATA = (PSEL) ? {{16{1'b0}},iPRDATA} : 32'd0;

/*   Ver 1.1 removed
always @(PENABLE or PSEL or PWRITE or PADDR[3:2] or rADCCON or rADCDAT)
begin
  if(PENABLE && PSEL && !PWRITE ) begin
    case(PADDR[3:2])
    //synopsys parallel_case
      `ADDRREG0 : PRDATA  <= rADCCON[15:0];
      `ADDRREG1 : PRDATA  <= {6'd0, rADCDAT[9:0]};
      default  : PRDATA   <= 16'd0;
    endcase
  end
  else begin
    PRDATA <= 16'd0;
  end
end
*/
endmodule
