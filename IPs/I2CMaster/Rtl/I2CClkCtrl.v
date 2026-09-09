// =================================================================
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from RichenTech          
//  ALL RIGHTS RESERVED RichenTech                                
// -----------------------------------------------------------------
// File Name        : I2CClkCtrl.v
// File Revision       : Ver 3.0 
// Revision History    : 
/ 
//  ----------------------------------------------------------------
//  Purpose         : I2C SCL Clock Control
//  ----------------------------------------------------------------
`timescale 1ns/1ps
module I2CClkCtrl
(
	PCLK,
	PRESETn,
	SW_RST,
	
	StartDet,
	StopDet,
	ArbitLostDet,
	DSCL_in,
	DDSCL_in,
	DSCL_o,
	ReadUpd,
	WriteUpd,
	WaitCnt,
	CntRst,
	ClkEn
);

input	PCLK;
input	PRESETn;

input 	SW_RST;

input	StartDet;
input	StopDet;
input	ArbitLostDet;
input	DSCL_in;
input	DDSCL_in;
input	DSCL_o;


output	ReadUpd;
output	WriteUpd;
output 	WaitCnt;
output	CntRst;

output	ClkEn;

///////////////////////////
// SCL Control
// Prescaler의 출력이 SCL라인으로 나간다.
// 중요 point는 Start와 Stop 상황이다. 
//
// Start +DATA + ACK + Stop
// 따라서
//        
// ________    __    __    __    __    __    __    __    __    ___________
//         |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  
//   Start      7     6     5     4     3     2     1    ack    Stop
//   ____                                                        ____
//       |_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX__|
//	master모드에서 stop을 만들때까지 clock 내보내기
//	slave에서는 clock을 내보내지 않음
//
// start 날리면 clock을 내보냄
// clock sync를 위해서 ... ㅡ<- 추가할 것 .. rev 2에서  



reg ClkEn;
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
		ClkEn <= 0;
	else if (SW_RST)
		ClkEn <= 0;
	else if (StartDet)// after start 
		ClkEn <= 1;
	else if (StopDet|ArbitLostDet)// stop
		ClkEn <= 0;
end

wire 	ReadUpd;
wire	WriteUpd;
assign 	ReadUpd  = DSCL_in & ~DDSCL_in; // rising edge 
assign 	WriteUpd = ~DSCL_in & DDSCL_in;  // falling edge

// for Clock Synchronization
wire	WaitCnt;
wire	CntRst;

assign 	WaitCnt =	DSCL_o & ~DSCL_in & ~WriteUpd; // input clock
// Clock state -> high 유지

assign 	CntRst 	= 	DSCL_o & ~DSCL_in & WriteUpd;
// Clock state -> low

endmodule

