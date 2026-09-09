 // ** FILE : SynTest SRAM BIST memory wrapper file
 // ** NAME : sram6144x32x8_wrapper.v
 // ** TOOL : srambist V1.2.0 r01 (05/30/01 09:35:47)
 // ** TIME : Wed Jul 19 01:22:32 2000


`timescale 1ns / 10ps

 module sram6144x32x8_wrapper_sram6144x32x8 ( CLK , CEN , OEN , WEN , Q , D , A ,
 mem_ctrl , bist_ctrl ) ;
 input CLK ;
 input CEN ;
 input OEN ;
 input [ 3 : 0 ] WEN ;
 output [ 31 : 0 ] Q ;
 input [ 31 : 0 ] D ;
 input [ 12 : 0 ] A ;
 input [ 5 : 0 ] mem_ctrl ;
 input [ 45 : 0 ] bist_ctrl ;

 wire [ 12 : 0 ] BIST_A ;
 wire [ 31 : 0 ] BIST_D ;
 wire BistMode ;
 wire CEN_n ;
 wire OEN_n ;
 wire [ 3 : 0 ] WEN_n ;
 wire [ 31 : 0 ] Q_n ;
 wire [ 31 : 0 ] D_n ;
 wire [ 12 : 0 ] A_n ;


 assign BIST_A = bist_ctrl [ 12 : 0 ] ;
 assign BIST_D = bist_ctrl [ 44 : 13 ] ;
 assign BistMode = bist_ctrl [ 45 ] ;
 assign CEN_n = ( BistMode ) ? mem_ctrl [ 5 ] : CEN ;
 assign OEN_n = ( BistMode ) ? mem_ctrl [ 4 ] : OEN ;
 assign WEN_n = ( BistMode ) ? mem_ctrl [ 3 : 0 ] : WEN ;
 assign D_n = ( BistMode ) ? BIST_D : D ;
 assign A_n = ( BistMode ) ? BIST_A : A ;
 assign Q = Q_n ;


 sram6144x32x8 SRAM_i0 (
 .CLK ( CLK ) ,
 .CEN ( CEN_n ) ,
 .OEN ( OEN_n ) ,
 .WEN ( WEN_n ) ,
 .Q ( Q_n ) ,
 .D ( D_n ) ,
 .A ( A_n )
 ) ;


 endmodule



