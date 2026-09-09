 // ** FILE : SynTest SRAM BIST memory wrapper file
 // ** NAME : SPSRAM256X8_wrapper.v
 // ** TOOL : srambist V1.2.0 r01 (05/30/01 09:35:47)
 // ** TIME : Tue Jul  3 15:05:48 2001


`timescale 1ns / 10ps

 module SPSRAM256X8_wrapper_SPSRAM256X8 ( CLK , CEN , WEN , Q , D , A , mem_ctrl ,
 bist_ctrl ) ;
 input CLK ;
 input CEN ;
 input WEN ;
 output [ 7 : 0 ] Q ;
 input [ 7 : 0 ] D ;
 input [ 7 : 0 ] A ;
 input [ 1 : 0 ] mem_ctrl ;
 input [ 16 : 0 ] bist_ctrl ;

 wire [ 7 : 0 ] BIST_A ;
 wire [ 7 : 0 ] BIST_D ;
 wire BistMode ;
 wire CEN_n ;
 wire WEN_n ;
 wire [ 7 : 0 ] Q_n ;
 wire [ 7 : 0 ] D_n ;
 wire [ 7 : 0 ] A_n ;


 assign BIST_A = bist_ctrl [ 7 : 0 ] ;
 assign BIST_D = bist_ctrl [ 15 : 8 ] ;
 assign BistMode = bist_ctrl [ 16 ] ;
 assign CEN_n = ( BistMode ) ? mem_ctrl [ 1 ] : CEN ;
 assign WEN_n = ( BistMode ) ? mem_ctrl [ 0 ] : WEN ;
 assign D_n = ( BistMode ) ? BIST_D : D ;
 assign A_n = ( BistMode ) ? BIST_A : A ;
 assign Q = Q_n ;


 SPSRAM256X8 SRAM_i0 (
 .CLK ( CLK ) ,
 .CEN ( CEN_n ) ,
 .WEN ( WEN_n ) ,
 .Q ( Q_n ) ,
 .D ( D_n ) ,
 .A ( A_n )
 ) ;


 endmodule



