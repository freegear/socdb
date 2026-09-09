// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech      
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : VideoEncInterface.v
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is interface slavemode RGB 
//                      signals from display module
// =======================================================================


`timescale 1ns/10ps
module VideoEncInterace 
(
	CLK,
	RESETn,
    //input signal
    //HSYNCn,
    //VSYNCn,
    BLANKn,
    Rin,
    Gin,
    Bin,

    //output signal
    //ENABLE_PIXEL,
    ACT_DISPLAY_INTER,
    Rout,
    Gout,
    Bout

    //setting signal
    /* not used slave mode */
    /* **************************
    H_COUNTER,
    V_COUNTER.
    RISING_F_DELAY,
    FALLING_F_DELAY
    ***************************** */
);

	input 	CLK;
	input	RESETn;
    //input   HSYNCn;
    //input   VSYNCn;
    input   BLANKn;

    input   [7:0]   Rin;
    input   [7:0]   Gin;
    input   [7:0]   Bin;
    input   ACT_DISPLAY_INTER;

    //output  ENABLE_PIXEL;

    output   [7:0]   Rout;
    output   [7:0]   Gout;
    output   [7:0]   Bout;
    reg   	 [7:0]   IRout;
    reg   	 [7:0]   IGout;
    reg   	 [7:0]   IBout;

    //assign  ENABLE_PIXEL = BLANKn;
    assign  Rout =  (ACT_DISPLAY_INTER) ? IRout:8'd0;
    assign  Gout =  (ACT_DISPLAY_INTER) ? IGout:8'd0;
    assign  Bout =  (ACT_DISPLAY_INTER) ? IBout:8'd0;


	always @(posedge CLK or negedge RESETn) begin

		if(!RESETn) begin
			IRout <= 0;
			IGout <= 0;
			IBout <= 0;
		end
		else
		begin
		if(BLANKn) begin
			IRout <= Rin;
			IGout <= Gin;
			IBout <= Bin;
		end
		else begin
			IRout <= Rout;
			IGout <= Gout;
			IBout <= Bout;
		end
        end
	end

endmodule
