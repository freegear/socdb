// ===================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech
// -------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : CMUL.v
// File Revision       : 3.0
// -------------------------------------------------------------------
// Purpose            : This module is Chrominance filter mul.
// ===================================================================

module CMUL(
            MUL33IN,
            MUL123IN,
            MUL131IN,
            MUL148IN,
            MUL70IN,
            MUL81IN,

            MUL33OUT,
            MUL123OUT,
            MUL131OUT,
            MUL148OUT,
            MUL70OUT,
            MUL81OUT
           );

input   [10:0]  MUL33IN;
input   [10:0]  MUL123IN;
input   [10:0]  MUL131IN;
input   [10:0]  MUL148IN;
input   [10:0]  MUL70IN;
input   [10:0]  MUL81IN;

output  [19:0]  MUL33OUT;
output  [19:0]  MUL123OUT;
output  [19:0]  MUL131OUT;
output  [19:0]  MUL148OUT;
output  [19:0]  MUL70OUT;
output  [19:0]  MUL81OUT;

// =======================================================================
// Wire & Reg assign 
// -----------------------------------------------------------------------

wire  [19:0]  MUL33OUT;
wire  [19:0]  MUL123OUT;
wire  [19:0]  MUL131OUT;
wire  [19:0]  MUL148OUT;
wire  [19:0]  MUL70OUT;
wire  [19:0]  MUL81OUT;

wire    [16:0]  tmp0_33;

wire    [18:0]  tmp0_123;
wire    [19:0]  tmp1_123;

wire    [19:0]  tmp0_131;
wire    [16:0]  tmp1_131;
wire    [20:0]  tmp2_131;

wire    [14:0]  tmp0_148;
wire    [17:0]  tmp1_148;
wire    [19:0]  tmp2_148;

wire    [17:0]  tmp0_70;
wire    [14:0]  tmp1_70;
wire    [18:0]  tmp2_70;

wire    [13:0]  tmp0_81;
wire    [18:0]  tmp1_81;

// =======================================================================
// Multifly 33
// -----------------------------------------------------------------------
assign tmp0_33  = {MUL33IN[10], MUL33IN, 5'd0} + {{6{MUL33IN[10]}}, MUL33IN};
assign MUL33OUT = {{3{tmp0_33[16]}}, tmp0_33};

// =======================================================================
// Multifly 123
// -----------------------------------------------------------------------
assign tmp0_123 = {MUL123IN[10], MUL123IN, 7'd0} - {{8{MUL123IN[10]}}, MUL123IN};
assign tmp1_123 = {{1{tmp0_123[18]}}, tmp0_123} - {{7{MUL123IN[10]}}, MUL123IN, 2'd0};
assign MUL123OUT = {tmp1_123[18], tmp1_123};

// =======================================================================
// Multifly 131
// -----------------------------------------------------------------------

assign tmp0_131 = {{1{MUL131IN[10]}}, MUL131IN, 8'd0} - {{9{MUL131IN[10]}}, MUL131IN};
assign tmp1_131 = {MUL131IN[10], MUL131IN, 5'd0} - {{6{MUL131IN[10]}}, MUL131IN};
assign tmp2_131 = {{1{tmp0_131}},tmp0_131} - {{2{tmp1_131[16]}}, tmp1_131,2'd0};
assign MUL131OUT = tmp2_131[19:0];

// =======================================================================
// Multifly 148
// -----------------------------------------------------------------------

assign tmp0_148 = {{1{MUL148IN[10]}}, MUL148IN,3'd0} + {{4{MUL148IN[10]}}, MUL148IN};
assign tmp1_148 = {tmp0_148[14], tmp0_148,2'd0} + {{7{MUL148IN[10]}}, MUL148IN};
assign tmp2_148 = {tmp1_148,2'd0};
assign MUL148OUT= tmp2_148;

// =======================================================================
// Multifly 70
// -----------------------------------------------------------------------

assign tmp0_70 = {{1{MUL70IN[10]}}, MUL70IN,6'd0} - {{7{MUL70IN[10]}}, MUL70IN};
assign tmp1_70 = {MUL70IN[10], MUL70IN,3'd0} - {{4{MUL70IN[10]}}, MUL70IN};
assign tmp2_70 = {tmp0_70, 1'd0} - {tmp1_70[14], tmp1_70,3'd0};
assign MUL70OUT = {tmp2_70[18], tmp2_70};

// =======================================================================
// Multifly 81
// -----------------------------------------------------------------------

assign tmp0_81 = {MUL81IN,2'd0} + {{2{MUL81IN[10]}}, MUL81IN};
assign tmp1_81 = {{4{tmp0_81[13]}}, tmp0_81,4'd0} + {{8{MUL81IN[10]}}, MUL81IN};
assign MUL81OUT = {tmp1_81[18],tmp1_81};


// -----------------------------------------------------------------------
endmodule
