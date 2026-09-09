// --------------------------------------------------------------------
// Copyright (c) 2006 by You-Will Inc. 
// --------------------------------------------------------------------
//           
//                     You-Will Inc
//                     978-8, Yeongtong-Dong, Yeongtong-Gu
//                     Suwon-City, Gyeonggi-Do, 443-812 Korea
//                     email: niosii@you-will.co.kr
//
// --------------------------------------------------------------------
//
// Major Functions: i2c AV config
//
//---------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| TAE-JIN KIM       :| 06/12/27  :| Initial Revision
// --------------------------------------------------------------------
// Project Information
// Project Name  : PAL
// TOP-FILE Name : I2C_AV_CONFIG
// File Name     : I2C_AV_CONFIG.V
// --------------------------------------------------------------------
// COMPONENT TREE
// I2C_AV_CONFIG -----> I2C_CONTROLLER
//    ( TOP )
// ---------------------------------------------------------------------
module I2C_AV_Config (	//	Host Side
						iCLK,
						iRST_N,
						//TD_DECODER
						TD_RESET,
						TD_HQ,
						TD_VQ,
						//LED
						LED,
						//	I2C Side
						I2C_SCLK,
						I2C_SDAT	);
//	Host Side
input		iCLK;
input		iRST_N;
//TD_DECODER
output TD_RESET;
input TD_HQ;
input TD_VQ;
//LED[3:0]
output [3:0] LED;
//	I2C Side
output		I2C_SCLK;
inout		I2C_SDAT;
//	Internal Registers/Wires
reg	[15:0]	mI2C_CLK_DIV;
reg	[23:0]	mI2C_DATA;
reg			mI2C_CTRL_CLK;
reg			mI2C_GO;
wire		mI2C_END;
wire		mI2C_ACK;
reg	[15:0]	LUT_DATA;
reg	[5:0]	LUT_INDEX;
reg	[3:0]	mSetup_ST;

//	Clock Setting
parameter	CLK_Freq	=	50000000;	//	50	MHz
parameter	I2C_Freq	=	20000;		//	20	KHz
//	LUT Data Number
parameter	LUT_SIZE	=	52;
//	Audio Data Index
parameter	Dummy_DATA	=	0;
parameter	SET_LIN_L	=	1;
parameter	SET_LIN_R	=	2;
parameter	SET_HEAD_L	=	3;
parameter	SET_HEAD_R	=	4;
parameter	A_PATH_CTRL	=	5;
parameter	D_PATH_CTRL	=	6;
parameter	POWER_ON	=	7;
parameter	SET_FORMAT	=	8;
parameter	SAMPLE_CTRL	=	9;
parameter	SET_ACTIVE	=	10;
//	Video Data Index
parameter	SET_VIDEO	=	11;
reg [48:0] HQ;
reg [48:0] VQ;
assign TD_RESET = 1'b1;

/////////////////////	I2C Control Clock	////////////////////////
assign LED[3] = VQ[48];
assign LED[2] = HQ[48];
assign LED[1] = 1'b1;
assign LED[0] = 1'b0;
//reg [9:0] HCNT;
//reg [9:0] VCNT;
always@(posedge iCLK or negedge iRST_N)
begin
    if(!iRST_N)
	 begin
	     HQ <= 0;
		  VQ <= 0;
	 end
	 else
	 begin
	     HQ <= { HQ[47:0],TD_HQ };
		  VQ <= { VQ[47:0],TD_VQ };
    end
end


always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		mI2C_CTRL_CLK	<=	0;
		mI2C_CLK_DIV	<=	0;
	end
	else
	begin
		if( mI2C_CLK_DIV	< (CLK_Freq/I2C_Freq) )
		mI2C_CLK_DIV	<=	mI2C_CLK_DIV+1;
		else
		begin
			mI2C_CLK_DIV	<=	0;
			mI2C_CTRL_CLK	<=	~mI2C_CTRL_CLK;
		end
	end
end
////////////////////////////////////////////////////////////////////
I2C_Controller 	u0	(	.CLOCK(mI2C_CTRL_CLK),		//	Controller Work Clock
						.I2C_SCLK(I2C_SCLK),		//	I2C CLOCK
 	 	 	 	 	 	.I2C_SDAT(I2C_SDAT),		//	I2C DATA
						.I2C_DATA(mI2C_DATA),		//	DATA:[SLAVE_ADDR,SUB_ADDR,DATA]
						.GO(mI2C_GO),      			//	GO transfor
						.END(mI2C_END),				//	END transfor 
						.ACK(mI2C_ACK),				//	ACK
						.RESET(iRST_N)	);
////////////////////////////////////////////////////////////////////
//////////////////////	Config Control	////////////////////////////
always@(posedge mI2C_CTRL_CLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		LUT_INDEX	<=	0;
		mSetup_ST	<=	0;
		mI2C_GO		<=	0;
	end
	else
	begin
		if(LUT_INDEX<LUT_SIZE)
		begin
			case(mSetup_ST)
			0:	begin
					if(LUT_INDEX<SET_VIDEO)
					mI2C_DATA	<=	{8'h34,LUT_DATA};
					else
					mI2C_DATA	<=	{8'h40,LUT_DATA};
					
				mI2C_GO		<=	1;
				mSetup_ST	<=	1;
				end
			1:	begin
					if(mI2C_END)
					begin
						if(!mI2C_ACK)
						mSetup_ST	<=	2;
						else
						mSetup_ST	<=	0;							
						
					mI2C_GO		<=	0;
					end
				end
			2:	begin
					LUT_INDEX	<=	LUT_INDEX+1;
					mSetup_ST	<=	0;
				end
			endcase
		end
	end
end
////////////////////////////////////////////////////////////////////
/////////////////////	Config Data LUT	  //////////////////////////	
always
begin
	case(LUT_INDEX)
	//	Audio Config Data
	Dummy_DATA	:	LUT_DATA	<=	16'h0000;
	SET_LIN_L	:	LUT_DATA	<=	16'h001A;
	SET_LIN_R	:	LUT_DATA	<=	16'h021A;
	SET_HEAD_L	:	LUT_DATA	<=	16'h047B;
	SET_HEAD_R	:	LUT_DATA	<=	16'h067B;
	A_PATH_CTRL	:	LUT_DATA	<=	16'h08F8;
	D_PATH_CTRL	:	LUT_DATA	<=	16'h0A06;
	POWER_ON	:	LUT_DATA	<=	16'h0C00;
	SET_FORMAT	:	LUT_DATA	<=	16'h0E01;
	SAMPLE_CTRL	:	LUT_DATA	<=	16'h1002;
	SET_ACTIVE	:	LUT_DATA	<=	16'h1201;
	//	Video Config Data
	SET_VIDEO+0	:	LUT_DATA	<=	16'h0701;//PAL
	SET_VIDEO+1	:	LUT_DATA	<=	16'h0701;
	SET_VIDEO+2	:	LUT_DATA	<=	16'h0701;
	SET_VIDEO+3	:	LUT_DATA	<=	16'h0701;
	SET_VIDEO+4	:	LUT_DATA	<=	16'h0701;
	SET_VIDEO+5	:	LUT_DATA	<=	16'h0a00;
	SET_VIDEO+6	:	LUT_DATA	<=	16'h0701;
	SET_VIDEO+7	:	LUT_DATA	<=	16'h1741;
	SET_VIDEO+8	:	LUT_DATA	<=	16'h2be2;
	SET_VIDEO+9	:	LUT_DATA	<=	16'h19fa;
	SET_VIDEO+10:	LUT_DATA	<=	16'h3a16;
	SET_VIDEO+11:	LUT_DATA	<=	16'h5003;
	SET_VIDEO+12:	LUT_DATA	<=	16'h5124;
	SET_VIDEO+13:	LUT_DATA	<=	16'hc309;
	SET_VIDEO+14:	LUT_DATA	<=	16'hc480;
	SET_VIDEO+15:	LUT_DATA	<=	16'hd201;
	SET_VIDEO+16:	LUT_DATA	<=	16'hd301;
	SET_VIDEO+17:	LUT_DATA	<=	16'hdb9b;
	SET_VIDEO+18:	LUT_DATA	<=	16'h0e85;
	SET_VIDEO+19:	LUT_DATA	<=	16'h890d;
	SET_VIDEO+20:	LUT_DATA	<=	16'h8d9b;
	SET_VIDEO+21:	LUT_DATA	<=	16'h8f48;
	SET_VIDEO+22:	LUT_DATA	<=	16'hb58b;
	SET_VIDEO+23:	LUT_DATA	<=	16'hd4fb;
	SET_VIDEO+24:	LUT_DATA	<=	16'hd66d;
	SET_VIDEO+25:	LUT_DATA	<=	16'he2af;
	SET_VIDEO+26:	LUT_DATA	<=	16'he300;
	SET_VIDEO+27:	LUT_DATA	<=	16'he4b5;//<<
	SET_VIDEO+28:	LUT_DATA	<=	16'h0e05;
	SET_VIDEO+29:	LUT_DATA	<=	16'h0e05;
	SET_VIDEO+30:	LUT_DATA	<=	16'h0e05;
	SET_VIDEO+31:	LUT_DATA	<=	16'h0e05;
	SET_VIDEO+32:	LUT_DATA	<=	16'h0e05;
	SET_VIDEO+33:	LUT_DATA	<=	16'h0e05;
	SET_VIDEO+34:	LUT_DATA	<=	16'h0e05;
	SET_VIDEO+35:	LUT_DATA	<=	16'h0e05;
	SET_VIDEO+36:	LUT_DATA	<=	16'h0e05;
	SET_VIDEO+37:	LUT_DATA	<=	16'h0e05;
	SET_VIDEO+38:	LUT_DATA	<=	16'h0e05;
	SET_VIDEO+39:	LUT_DATA	<=	16'h0e05;
	endcase
end
////////////////////////////////////////////////////////////////////
endmodule