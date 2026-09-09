 // ** FILE : SynTest SRAM BIST top module file
 // ** NAME : sram6144x32x8_top.v
 // ** TOOL : srambist V1.2.0 r01 (05/30/01 09:35:47)
 // ** TIME : Wed Jul 19 01:22:32 2000


`timescale 1ns / 10ps

 module Bisted_sram6144x32x8 ( CLK , CEN , OEN , WEN , Q , D , A , BistMode ,
 BistFail , Finish , ErrMap ) ;
 input CLK ;
 input CEN ;
 input OEN ;
 input [ 3 : 0 ] WEN ;
 output [ 31 : 0 ] Q ;
 input [ 31 : 0 ] D ;
 input [ 12 : 0 ] A ;
 input BistMode ;
 output BistFail ;
 output Finish ;
 output ErrMap ;

 wire [ 5 : 0 ] mem_ctrl_n ;
 wire [ 31 : 0 ] Q_n ;
 wire [ 45 : 0 ] bist_ctrl_n ;


 assign Q = Q_n ;

 BistCtrl_sram6144x32x8 BistCtrl_i0 (
 .Tclk ( CLK ) ,
 .BistMode ( BistMode ) ,
 .mem_ctrl ( mem_ctrl_n ) ,
 .Q_i ( Q_n ) ,
 .bist_ctrl ( bist_ctrl_n ) ,
 .BistFail ( BistFail ) ,
 .ErrMap ( ErrMap ) ,
 .Finish ( Finish )
 ) ;

 sram6144x32x8_wrapper_sram6144x32x8 WRAPPED_RAM_i0 (
 .CLK ( CLK ) ,
 .CEN ( CEN ) ,
 .OEN ( OEN ) ,
 .WEN ( WEN ) ,
 .Q ( Q_n ) ,
 .D ( D ) ,
 .A ( A ) ,
 .mem_ctrl ( mem_ctrl_n ) ,
 .bist_ctrl ( bist_ctrl_n )
 ) ;



 endmodule

