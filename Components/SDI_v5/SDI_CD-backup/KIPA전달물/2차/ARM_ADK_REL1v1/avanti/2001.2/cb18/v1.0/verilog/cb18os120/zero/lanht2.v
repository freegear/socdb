// ****** (C) Copyright 1998 Avant! Inc. ********
//  --    AVANT! Verilog Models
// **********************************************


`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 1ps
 `delay_mode_path
`endif 


// Model type   	: zero timing
// Filename     	: lanht2.v
// Description  	:  Minimum Tristate Latch with Z-output only and Active Higher Enable, 2X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.5
//
//


module lanht2 (D,E,OE,Z);

output  Z;
input   D,E,OE;


`ifdef neg_tchk
wire d_D,d_E;
`endif



`ifdef functional
buf b_D (D_buf,D);
buf b_E (E_buf,E);
buf b_OE (OE_buf,OE);
U_LD_P #0.01 (Q,D_buf,E_buf);
bufif1 b1(Z,Q,OE_buf);
`else
reg notifier;

`ifdef neg_tchk
buf b_D (D_buf,d_D);
buf b_E (E_buf,d_E);
buf b_OE (OE_buf,OE);
U_LD_P_NO (Q,D_buf,E_buf,notifier);
bufif1 b1(Z,Q,OE_buf);
`else
buf b_D (D_buf,D);
buf b_E (E_buf,E);
buf b_OE (OE_buf,OE);
U_LD_P_NO #0.01 (Q,D_buf,E_buf,notifier);
bufif1 b1(Z,Q,OE_buf);
`endif
`endif


`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_e=0.12,tsu_d_l_e=0.23,th_e_d_h=0.00,th_e_d_l=0.00,
 tpw_e_h=0.31,d_lh_z_lh=0,oe_hl_z_hz_1=0,oe_lh_z_zh_1=0,oe_lh_z_zl_1=0,
 d_hl_z_hl=0,e_lh_z_lh=0,e_lh_z_hl=0,oe_hl_z_lz_1=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (negedge E,posedge D,tsu_d_h_e,th_e_d_l,notifier,,,d_E,d_D);
 $setuphold (negedge E,negedge D,tsu_d_l_e,th_e_d_h,notifier,,,d_E,d_D);
`else
 $setup (posedge D,negedge E,tsu_d_h_e,notifier);
 $setup (negedge D,negedge E,tsu_d_l_e,notifier);
 $hold  (negedge E,negedge D,th_e_d_h,notifier);
 $hold  (negedge E,posedge D,th_e_d_l,notifier);
`endif 
 $width (posedge E,tpw_e_h,0,notifier);
// Delays
 (        OE  => Z) = (oe_hl_z_lz_1,oe_hl_z_hz_1,oe_hl_z_lz_1,oe_lh_z_zh_1,oe_hl_z_hz_1,oe_lh_z_zl_1);
 (D   *> Z) = (d_lh_z_lh,d_hl_z_hl);
 (E   *> Z) = (e_lh_z_lh,e_lh_z_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 1ps
