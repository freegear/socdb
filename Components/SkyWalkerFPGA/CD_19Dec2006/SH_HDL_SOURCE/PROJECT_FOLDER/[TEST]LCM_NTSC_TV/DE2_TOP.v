// --------------------------------------------------------------------
// Copyright (c) 2005 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	DE2 LCM-TV NTSC Demo
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Joe Yang	       :| 06/04/12  :|      Initial Revision
// --------------------------------------------------------------------

module DE2_TOP
	(
		////////////////////	Clock Input	 	////////////////////	 
		CLOCK_27,						//	27 MHz
		CLOCK_25,						//	50 MHz
		EXT_CLOCK,						//	External Clock
		////////////////////	Push Button		////////////////////
		KEY,							//	Pushbutton[3:0]
		////////////////////	DPDT Switch		////////////////////
		SW,								//	Toggle Switch[3:0]
		////////////////	TV Decoder		////////////////////////
		TD_DATA,    					//	TV Decoder Data bus 8 bits
		TD_HS,							//	TV Decoder H_SYNC
		TD_VS,							//	TV Decoder V_SYNC
		TD_RESET,						//	TV Decoder Reset
		//////////////// TFT-LCD(3.6")  /////////////////////////
		LCM_DATA,
		LCM_VSYNC,
		LCM_HSYNC,
		LCM_SHDB,
		LCM_DCLK,
		LCM_SCEN,
		LCM_SDAT,
		LCM_SCLK,
		//////////////// TV-out(Encoder) /////////////////////////
		TV_out_Sync,
		TV_out_Blank,
		TV_out_R,
		TV_out_G,
		TV_out_B,
		
		SW0
	);

////////////////////////	Clock Input	 	////////////////////////
input			CLOCK_27;				//	27 MHz
input			CLOCK_25;				//	50 MHz
input			EXT_CLOCK;				//	External Clock
////////////////////////	Push Button		////////////////////////
input	[3:0]	KEY;					//	Pushbutton[3:0]
////////////////////////	DPDT Switch		////////////////////////
input	[3:0]	SW;						//	Toggle Switch[17:0]
////////////////////	TV Devoder		////////////////////////////
input	[7:0]	TD_DATA;    			//	TV Decoder Data bus 8 bits
input			TD_HS;					//	TV Decoder H_SYNC
input			TD_VS;					//	TV Decoder V_SYNC
output		TD_RESET;				//	TV Decoder Reset
////////////////////////	GPIO	////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
output [7:0]  LCM_DATA;
output 	LCM_VSYNC;
output	LCM_SCLK;
output	LCM_DCLK;

output	LCM_SHDB;
output	LCM_SCEN;
inout		LCM_SDAT;
output	LCM_HSYNC;
output   TV_out_Sync;
output   TV_out_Blank;
output [9:0]  TV_out_R;
output [9:0]  TV_out_G;
output [9:0]  TV_out_B;

input SW0;
/////////SET NTSC//////////
wire I3C_RST;
wire I2C_RST;
wire TD_RESET;
wire TV_out_R;
wire TV_out_G;
wire TV_out_B;
///////////////////////////////////////////////////////////
reg		[10:0]	H_Cont;
reg		[10:0]	V_Cont;
parameter	H_SYNC_CYC	=	1;
parameter	H_SYNC_BACK	=	151;
parameter	H_SYNC_ACT	=	960;
parameter	H_SYNC_FRONT=	59;
parameter	H_SYNC_TOTAL=	1171;
//	Virtical Parameter		( Line )
parameter	V_SYNC_CYC	=	1;
parameter	V_SYNC_BACK	=	13;
parameter	V_SYNC_ACT	=	240;
parameter	V_SYNC_FRONT=	8;
parameter	V_SYNC_TOTAL=	262;

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
assign TV_out_Sync = 1'b1;
assign TV_out_Blank = 1'b1;


assign TV_out_R = (H_Cont>H_SYNC_BACK && H_Cont<(H_SYNC_TOTAL-H_SYNC_FRONT))&&
						((V_Cont > 100)&&(V_Cont < 200 )) ? 9'h1FF : 9'h000;
assign TV_out_G = (H_Cont>H_SYNC_BACK && H_Cont<(H_SYNC_TOTAL-H_SYNC_FRONT))&&
						((V_Cont > 100)&&(V_Cont < 200 )) ? 9'h1FF : 9'h000;
assign TV_out_B = (H_Cont>H_SYNC_BACK && H_Cont<(H_SYNC_TOTAL-H_SYNC_FRONT))&&
						((V_Cont > 100)&&(V_Cont < 200 )) ? 9'h1FF : 9'h000;


always@(posedge CLOCK_27 or negedge TD_RESET)
begin
	if(!TD_RESET)
	begin
		H_Cont		<=	0;
	end
	else
	begin
		//	H_Sync Counter
		if( H_Cont < H_SYNC_TOTAL )
		H_Cont	<=	H_Cont+1;
		else
		H_Cont	<=	0;
	end
end

//	V_Sync Generator, Ref. H_Sync
always@(posedge CLOCK_27 or negedge TD_RESET)
begin
	if(!TD_RESET)
	begin
		V_Cont		<=	0;
	end
	else
	begin
		//	When H_Sync Re-start
		if(H_Cont==0)
		begin
			//	V_Sync Counter
			if( V_Cont < V_SYNC_TOTAL )
			V_Cont	<=	V_Cont+1;
			else
			V_Cont	<=	0;
		end
	end
end

TV_SET NTSC( 
.iclock_27(CLOCK_27),
.iclock_50(CLOCK_25),
.itv_data (TD_DATA),
.itv_hs(TD_HS),
.itv_vs(TD_VS),
.SW(SW0),
.otv_hs(LCM_HSYNC),
.otv_vs(LCM_VSYNC),
.orst_i3c(I3C_RST),
.orst_i2c(I2C_RST),
.orst_lcm(LCM_SHDB),
.orst_tvdecoder(TD_RESET),
.otv_data(LCM_DATA[7:0])
);
////////////////////////////////

I2S_LCM_Config		u2 (	//	Host Side
							.iCLK(CLOCK_25),
							.iRST_N(I3C_RST ),
							//	I2C Side
							.I2S_SCLK(LCM_SCLK),
							.I2S_SDAT(LCM_SDAT),
							.I2S_SCEN(LCM_SCEN)					
							);

I2C_AV_Config 		u3	(	//	Host Side
							.iCLK(CLOCK_25),
							.iRST_N(I2C_RST),
							//	I2C Side
							.I2C_SCLK(I2C_SCLK),
							.I2C_SDAT(I2C_SDAT)	);
							
endmodule