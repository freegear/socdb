
module FPGA0(

        /* BUS for Video Encoder tester */
        BUS_CLK,
        VIDEO_CLK,
        BUS_RESETn,

        //Read address channel
        ARADDR_VideoEnC,
        ARLEN_VideoEnC,
        ARSIZE_VideoEnC,
        ARBURST_VideoEnC,

        ARVALID_VideoEnC,
        ARREADY_2_VideoEnC,

        //Read data channel
        RRESP_2_VideoEnC,   
        RDATA_2_VideoEnC,
        RLAST_2_VideoEnC,
        RVALID_2_VideoEnC,  
        RREADY_VideoEnC,
        
        //APB bus
        PADDR0_2_VideoEnc,
        PWDATA0_2_VideoEnc,
        PENABLE0_2_VideoEnc,
        PSEL0_3_VideoEnc,

        /* DAC output signal */
        DAC_CLK,
        DAC_OUT,
        SYNC,
        BLANK
)

//Read address channel
input  BUS_CLK:
input  VIDEO_CLK;
input  BUS_RESETn;

output   [31:0] ARADDR_VideoEnC;
output   [3:0]  ARLEN_VideoEnC;
output   [2:0]  ARSIZE_VideoEnC;  
output   [1:0]  ARBURST_VideoEnC; 

output   ARVALID_VideoEnC; 
input    ARREADY_2_VideoEnC; 

//Read data channel
input    [1:0]   RRESP_2_VideoEnC;   
input    [31:0]  RDATA_2_VideoEnC;
input    RLAST_2_VideoEnC;
input    RVALID_2_VideoEnC;  
output   RREADY_VideoEnC;  

//APB bus
input  [1:0]  PADDR0_2_VideoEnc;
input  [31:0] PWDATA0_2_VideoEnc;
input         PENABLE0_2_VideoEnc;
input         PSEL0_3_VideoEnc;

/* DAC output signal */
output         DAC_CLK; 
output [7:0]   DAC_OUT;
output         SYNC;
output         BLANK;

//Wire signal
wire   [31:0] wARADDR_VideoEnC;
wire   [3:0]  wARLEN_VideoEnC;
wire   [2:0]  wARSIZE_VideoEnC;  
wire   [1:0]  wARBURST_VideoEnC; 

wire   wARVALID_VideoEnC; 
wire   wARREADY_2_VideoEnC; 

//Read data channel
wire   [1:0]   wRRESP_2_VideoEnC;   
wire   [31:0]  wRDATA_2_VideoEnC;
wire   wRLAST_2_VideoEnC;
wire   wRVALID_2_VideoEnC;  
wire   wRREADY_VideoEnC;  

//APB bus
wire  [1:0]  wPADDR0_2_VideoEnc;
wire  [31:0] wPWDATA0_2_VideoEnc;
wire         wPENABLE0_2_VideoEnc;
wire         wPSEL0_3_VideoEnc;

FPGA0Core Core0(

     .BUS_CLK(BUS_CLK),
     .BUS_RESETn(BUS_RESETn),

     /* BUS for Video Encoder tester */
     //Read address channel
     .ARADDR_VideoEnC(wARADDR_VideoEnC),
     .ARLEN_VideoEnC(wARLEN_VideoEnC),
     .ARSIZE_VideoEnC(wARSIZE_VideoEnC),
     .ARBURST_VideoEnC(wARBURST_VideoEnC),

     .ARVALID_VideoEnC(wARVALID_VideoEnC),
     .ARREADY_2_VideoEnC(wARREADY_2_VideoEnC),

     //Read data channel
     .RRESP_2_VideoEnC(wRRESP_2_VideoEnC),   
     .RDATA_2_VideoEnC(wRDATA_2_VideoEnC),
     .RLAST_2_VideoEnC(wRLAST_2_VideoEnC),
     .RVALID_2_VideoEnC(wRVALID_2_VideoEnC),  
     .RREADY_VideoEnC(wRREADY_VideoEnC),
        
     //APB bus
     .PADDR0_2_VideoEnc(wPADDR0_2_VideoEnc),
     .PWDATA0_2_VideoEnc(wPWDATA0_2_VideoEnc),
     .PENABLE0_2_VideoEnc(wPENABLE0_2_VideoEnc),
     .PSEL0_3_VideoEnc(wPSEL0_3_VideoEnc)

);

endmodule
