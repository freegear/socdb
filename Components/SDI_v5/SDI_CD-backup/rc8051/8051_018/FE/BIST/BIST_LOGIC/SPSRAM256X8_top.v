 // ** FILE : SynTest SRAM BIST top module file
 // ** NAME : SPSRAM256X8_top.v
 // ** TOOL : srambist V1.2.0 r01 (05/30/01 09:35:47)
 // ** TIME : Tue Jul  3 15:05:48 2001


`timescale 1ns / 10ps

 module Bisted_SPSRAM256X8 ( CLK , CEN , WEN , Q , D , A , BistMode , BistFail ,
 Finish , ErrMap ) ;
 input CLK ;
 input CEN ;
 input WEN ;
 output [ 7 : 0 ] Q ;
 input [ 7 : 0 ] D ;
 input [ 7 : 0 ] A ;
 input BistMode ;
 output BistFail ;
 output Finish ;
 output ErrMap ;

 wire [ 1 : 0 ] mem_ctrl_n ;
 wire [ 7 : 0 ] Q_n ;
 wire [ 16 : 0 ] bist_ctrl_n ;


 assign Q = Q_n ;

 BistCtrl_SPSRAM256X8 BistCtrl_i0 (
 .Tclk ( CLK ) ,
 .BistMode ( BistMode ) ,
 .mem_ctrl ( mem_ctrl_n ) ,
 .Q_i ( Q_n ) ,
 .bist_ctrl ( bist_ctrl_n ) ,
 .BistFail ( BistFail ) ,
 .ErrMap ( ErrMap ) ,
 .Finish ( Finish )
 ) ;

 SPSRAM256X8_wrapper_SPSRAM256X8 WRAPPED_RAM_i0 (
 .CLK ( CLK ) ,
 .CEN ( CEN ) ,
 .WEN ( WEN ) ,
 .Q ( Q_n ) ,
 .D ( D ) ,
 .A ( A ) ,
 .mem_ctrl ( mem_ctrl_n ) ,
 .bist_ctrl ( bist_ctrl_n )
 ) ;



 endmodule

