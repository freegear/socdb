// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : IO_PAD.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : IO_PAD[ASIC&FPGA]
//  =============================================================================

`timescale 1ns/1ps

module IO_PAD
(
Dir_En0   ,
Dir_En1   ,
Dir_En2   ,
Dir_En3   ,

Data_Out0 ,
Data_Out1 ,
Data_Out2 ,
Data_Out3 ,

Data_In0  ,
Data_In1  ,
Data_In2  ,
Data_In3  ,

BI_PAD0   ,
BI_PAD1   ,
BI_PAD2   ,
BI_PAD3   

);

parameter  Data_Width = 8   ;

input [Data_Width-1:0]  Dir_En0   ;
input [Data_Width-1:0]  Dir_En1   ;
input [Data_Width-1:0]  Dir_En2   ;
input [Data_Width-1:0]  Dir_En3   ;

input [Data_Width-1:0]  Data_Out0 ;
input [Data_Width-1:0]  Data_Out1 ;
input [Data_Width-1:0]  Data_Out2 ;
input [Data_Width-1:0]  Data_Out3 ;

output [Data_Width-1:0] Data_In0  ;
output [Data_Width-1:0] Data_In1  ;
output [Data_Width-1:0] Data_In2  ;
output [Data_Width-1:0] Data_In3  ;

inout  [Data_Width-1:0] BI_PAD0   ;
inout  [Data_Width-1:0] BI_PAD1   ;
inout  [Data_Width-1:0] BI_PAD2   ;
inout  [Data_Width-1:0] BI_PAD3   ;

wire   [Data_Width-1:0] Dir_En0   ;
wire   [Data_Width-1:0] Dir_En1   ;
wire   [Data_Width-1:0] Dir_En2   ;
wire   [Data_Width-1:0] Dir_En3   ;

wire   [Data_Width-1:0] Data_Out0 ;
wire   [Data_Width-1:0] Data_Out1 ;
wire   [Data_Width-1:0] Data_Out2 ;
wire   [Data_Width-1:0] Data_Out3 ;

wire   [Data_Width-1:0] Data_In0  ;
wire   [Data_Width-1:0] Data_In1  ;
wire   [Data_Width-1:0] Data_In2  ;
wire   [Data_Width-1:0] Data_In3  ;

wire  [Data_Width-1:0] BI_PAD0    ;
wire  [Data_Width-1:0] BI_PAD1    ;
wire  [Data_Width-1:0] BI_PAD2    ;
wire  [Data_Width-1:0] BI_PAD3    ;

assign Data_In0 = BI_PAD0 ;
assign Data_In1 = BI_PAD1 ;
assign Data_In2 = BI_PAD2 ;
assign Data_In3 = BI_PAD3 ;

//FPGA
assign BI_PAD0[Data_Width-1] = (~Dir_En0[Data_Width-1]) ? Data_Out0[Data_Width-1]: 1'bz ;
assign BI_PAD0[Data_Width-2] = (~Dir_En0[Data_Width-2]) ? Data_Out0[Data_Width-2]: 1'bz ;
assign BI_PAD0[Data_Width-3] = (~Dir_En0[Data_Width-3]) ? Data_Out0[Data_Width-3]: 1'bz ;
assign BI_PAD0[Data_Width-4] = (~Dir_En0[Data_Width-4]) ? Data_Out0[Data_Width-4]: 1'bz ;
assign BI_PAD0[Data_Width-5] = (~Dir_En0[Data_Width-5]) ? Data_Out0[Data_Width-5]: 1'bz ;
assign BI_PAD0[Data_Width-6] = (~Dir_En0[Data_Width-6]) ? Data_Out0[Data_Width-6]: 1'bz ;
assign BI_PAD0[Data_Width-7] = (~Dir_En0[Data_Width-7]) ? Data_Out0[Data_Width-7]: 1'bz ;
assign BI_PAD0[Data_Width-8] = (~Dir_En0[Data_Width-8]) ? Data_Out0[Data_Width-8]: 1'bz ;

assign BI_PAD1[Data_Width-1] = (~Dir_En1[Data_Width-1]) ? Data_Out1[Data_Width-1]: 1'bz ;
assign BI_PAD1[Data_Width-2] = (~Dir_En1[Data_Width-2]) ? Data_Out1[Data_Width-2]: 1'bz ;
assign BI_PAD1[Data_Width-3] = (~Dir_En1[Data_Width-3]) ? Data_Out1[Data_Width-3]: 1'bz ;
assign BI_PAD1[Data_Width-4] = (~Dir_En1[Data_Width-4]) ? Data_Out1[Data_Width-4]: 1'bz ;
assign BI_PAD1[Data_Width-5] = (~Dir_En1[Data_Width-5]) ? Data_Out1[Data_Width-5]: 1'bz ;
assign BI_PAD1[Data_Width-6] = (~Dir_En1[Data_Width-6]) ? Data_Out1[Data_Width-6]: 1'bz ;
assign BI_PAD1[Data_Width-7] = (~Dir_En1[Data_Width-7]) ? Data_Out1[Data_Width-7]: 1'bz ;
assign BI_PAD1[Data_Width-8] = (~Dir_En1[Data_Width-8]) ? Data_Out1[Data_Width-8]: 1'bz ;

assign BI_PAD2[Data_Width-1] = (~Dir_En2[Data_Width-1]) ? Data_Out2[Data_Width-1]: 1'bz ;
assign BI_PAD2[Data_Width-2] = (~Dir_En2[Data_Width-2]) ? Data_Out2[Data_Width-2]: 1'bz ;
assign BI_PAD2[Data_Width-3] = (~Dir_En2[Data_Width-3]) ? Data_Out2[Data_Width-3]: 1'bz ;
assign BI_PAD2[Data_Width-4] = (~Dir_En2[Data_Width-4]) ? Data_Out2[Data_Width-4]: 1'bz ;
assign BI_PAD2[Data_Width-5] = (~Dir_En2[Data_Width-5]) ? Data_Out2[Data_Width-5]: 1'bz ;
assign BI_PAD2[Data_Width-6] = (~Dir_En2[Data_Width-6]) ? Data_Out2[Data_Width-6]: 1'bz ;
assign BI_PAD2[Data_Width-7] = (~Dir_En2[Data_Width-7]) ? Data_Out2[Data_Width-7]: 1'bz ;
assign BI_PAD2[Data_Width-8] = (~Dir_En2[Data_Width-8]) ? Data_Out2[Data_Width-8]: 1'bz ;

assign BI_PAD3[Data_Width-1] = (~Dir_En3[Data_Width-1]) ? Data_Out3[Data_Width-1]: 1'bz ;
assign BI_PAD3[Data_Width-2] = (~Dir_En3[Data_Width-2]) ? Data_Out3[Data_Width-2]: 1'bz ;
assign BI_PAD3[Data_Width-3] = (~Dir_En3[Data_Width-3]) ? Data_Out3[Data_Width-3]: 1'bz ;
assign BI_PAD3[Data_Width-4] = (~Dir_En3[Data_Width-4]) ? Data_Out3[Data_Width-4]: 1'bz ;
assign BI_PAD3[Data_Width-5] = (~Dir_En3[Data_Width-5]) ? Data_Out3[Data_Width-5]: 1'bz ;
assign BI_PAD3[Data_Width-6] = (~Dir_En3[Data_Width-6]) ? Data_Out3[Data_Width-6]: 1'bz ;
assign BI_PAD3[Data_Width-7] = (~Dir_En3[Data_Width-7]) ? Data_Out3[Data_Width-7]: 1'bz ;
assign BI_PAD3[Data_Width-8] = (~Dir_En3[Data_Width-8]) ? Data_Out3[Data_Width-8]: 1'bz ;

//ASIC[TSMC_018]
//module PDU24DGZ (I, OEN, PAD, C);
//  input I, OEN;
//  inout PAD;
//  output C;
/*PDU24DGZ uPDU24DGZ_07(.I(Data_Out0[Data_Width-1]), .OEN(Dir_En0[Data_Width-1]), .PAD(BI_PAD0[Data_Width-1]), .C(Data_In0[Data_Width-1]));
PDU24DGZ uPDU24DGZ_06(.I(Data_Out0[Data_Width-2]), .OEN(Dir_En0[Data_Width-2]), .PAD(BI_PAD0[Data_Width-2]), .C(Data_In0[Data_Width-2]));
PDU24DGZ uPDU24DGZ_05(.I(Data_Out0[Data_Width-3]), .OEN(Dir_En0[Data_Width-3]), .PAD(BI_PAD0[Data_Width-3]), .C(Data_In0[Data_Width-3]));
PDU24DGZ uPDU24DGZ_04(.I(Data_Out0[Data_Width-4]), .OEN(Dir_En0[Data_Width-4]), .PAD(BI_PAD0[Data_Width-4]), .C(Data_In0[Data_Width-4]));
PDU24DGZ uPDU24DGZ_03(.I(Data_Out0[Data_Width-5]), .OEN(Dir_En0[Data_Width-5]), .PAD(BI_PAD0[Data_Width-5]), .C(Data_In0[Data_Width-5]));
PDU24DGZ uPDU24DGZ_02(.I(Data_Out0[Data_Width-6]), .OEN(Dir_En0[Data_Width-6]), .PAD(BI_PAD0[Data_Width-6]), .C(Data_In0[Data_Width-6]));
PDU24DGZ uPDU24DGZ_01(.I(Data_Out0[Data_Width-7]), .OEN(Dir_En0[Data_Width-7]), .PAD(BI_PAD0[Data_Width-7]), .C(Data_In0[Data_Width-7]));
PDU24DGZ uPDU24DGZ_00(.I(Data_Out0[Data_Width-8]), .OEN(Dir_En0[Data_Width-8]), .PAD(BI_PAD0[Data_Width-8]), .C(Data_In0[Data_Width-8]));

PDU24DGZ uPDU24DGZ_17(.I(Data_Out1[Data_Width-1]), .OEN(Dir_En1[Data_Width-1]), .PAD(BI_PAD1[Data_Width-1]), .C(Data_In1[Data_Width-1]));
PDU24DGZ uPDU24DGZ_16(.I(Data_Out1[Data_Width-2]), .OEN(Dir_En1[Data_Width-2]), .PAD(BI_PAD1[Data_Width-2]), .C(Data_In1[Data_Width-2]));
PDU24DGZ uPDU24DGZ_15(.I(Data_Out1[Data_Width-3]), .OEN(Dir_En1[Data_Width-3]), .PAD(BI_PAD1[Data_Width-3]), .C(Data_In1[Data_Width-3]));
PDU24DGZ uPDU24DGZ_14(.I(Data_Out1[Data_Width-4]), .OEN(Dir_En1[Data_Width-4]), .PAD(BI_PAD1[Data_Width-4]), .C(Data_In1[Data_Width-4]));
PDU24DGZ uPDU24DGZ_13(.I(Data_Out1[Data_Width-5]), .OEN(Dir_En1[Data_Width-5]), .PAD(BI_PAD1[Data_Width-5]), .C(Data_In1[Data_Width-5]));
PDU24DGZ uPDU24DGZ_12(.I(Data_Out1[Data_Width-6]), .OEN(Dir_En1[Data_Width-6]), .PAD(BI_PAD1[Data_Width-6]), .C(Data_In1[Data_Width-6]));
PDU24DGZ uPDU24DGZ_11(.I(Data_Out1[Data_Width-7]), .OEN(Dir_En1[Data_Width-7]), .PAD(BI_PAD1[Data_Width-7]), .C(Data_In1[Data_Width-7]));
PDU24DGZ uPDU24DGZ_10(.I(Data_Out1[Data_Width-8]), .OEN(Dir_En1[Data_Width-8]), .PAD(BI_PAD1[Data_Width-8]), .C(Data_In1[Data_Width-8]));

PDU24DGZ uPDU24DGZ_27(.I(Data_Out2[Data_Width-1]), .OEN(Dir_En2[Data_Width-1]), .PAD(BI_PAD2[Data_Width-1]), .C(Data_In2[Data_Width-1]));
PDU24DGZ uPDU24DGZ_26(.I(Data_Out2[Data_Width-2]), .OEN(Dir_En2[Data_Width-2]), .PAD(BI_PAD2[Data_Width-2]), .C(Data_In2[Data_Width-2]));
PDU24DGZ uPDU24DGZ_25(.I(Data_Out2[Data_Width-3]), .OEN(Dir_En2[Data_Width-3]), .PAD(BI_PAD2[Data_Width-3]), .C(Data_In2[Data_Width-3]));
PDU24DGZ uPDU24DGZ_24(.I(Data_Out2[Data_Width-4]), .OEN(Dir_En2[Data_Width-4]), .PAD(BI_PAD2[Data_Width-4]), .C(Data_In2[Data_Width-4]));
PDU24DGZ uPDU24DGZ_23(.I(Data_Out2[Data_Width-5]), .OEN(Dir_En2[Data_Width-5]), .PAD(BI_PAD2[Data_Width-5]), .C(Data_In2[Data_Width-5]));
PDU24DGZ uPDU24DGZ_22(.I(Data_Out2[Data_Width-6]), .OEN(Dir_En2[Data_Width-6]), .PAD(BI_PAD2[Data_Width-6]), .C(Data_In2[Data_Width-6]));
PDU24DGZ uPDU24DGZ_21(.I(Data_Out2[Data_Width-7]), .OEN(Dir_En2[Data_Width-7]), .PAD(BI_PAD2[Data_Width-7]), .C(Data_In2[Data_Width-7]));
PDU24DGZ uPDU24DGZ_20(.I(Data_Out2[Data_Width-8]), .OEN(Dir_En2[Data_Width-8]), .PAD(BI_PAD2[Data_Width-8]), .C(Data_In2[Data_Width-8]));

PDU24DGZ uPDU24DGZ_37(.I(Data_Out3[Data_Width-1]), .OEN(Dir_En3[Data_Width-1]), .PAD(BI_PAD3[Data_Width-1]), .C(Data_In3[Data_Width-1]));
PDU24DGZ uPDU24DGZ_36(.I(Data_Out3[Data_Width-2]), .OEN(Dir_En3[Data_Width-2]), .PAD(BI_PAD3[Data_Width-2]), .C(Data_In3[Data_Width-2]));
PDU24DGZ uPDU24DGZ_35(.I(Data_Out3[Data_Width-3]), .OEN(Dir_En3[Data_Width-3]), .PAD(BI_PAD3[Data_Width-3]), .C(Data_In3[Data_Width-3]));
PDU24DGZ uPDU24DGZ_34(.I(Data_Out3[Data_Width-4]), .OEN(Dir_En3[Data_Width-4]), .PAD(BI_PAD3[Data_Width-4]), .C(Data_In3[Data_Width-4]));
PDU24DGZ uPDU24DGZ_33(.I(Data_Out3[Data_Width-5]), .OEN(Dir_En3[Data_Width-5]), .PAD(BI_PAD3[Data_Width-5]), .C(Data_In3[Data_Width-5]));
PDU24DGZ uPDU24DGZ_32(.I(Data_Out3[Data_Width-6]), .OEN(Dir_En3[Data_Width-6]), .PAD(BI_PAD3[Data_Width-6]), .C(Data_In3[Data_Width-6]));
PDU24DGZ uPDU24DGZ_31(.I(Data_Out3[Data_Width-7]), .OEN(Dir_En3[Data_Width-7]), .PAD(BI_PAD3[Data_Width-7]), .C(Data_In3[Data_Width-7]));
PDU24DGZ uPDU24DGZ_30(.I(Data_Out3[Data_Width-8]), .OEN(Dir_En3[Data_Width-8]), .PAD(BI_PAD3[Data_Width-8]), .C(Data_In3[Data_Width-8]));
*/
endmodule