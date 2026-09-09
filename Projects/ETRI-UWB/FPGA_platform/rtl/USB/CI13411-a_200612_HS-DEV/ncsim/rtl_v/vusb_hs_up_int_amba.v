/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_up_int_amba.vhdl
-- Date Created: Thu Dec 21 22:43:36 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_up_int_amba.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Vusb_Hs microprocessor interface with BVCI Ld/St Interface.
// ------------------------------------------------------------------------------
//  ChipIdea Microelectronica - IPCS                                             
//  TECMAIA, Rua Eng. Frederico Ulrich, n 2650                                   
//  4470-920 MOREIRA MAIA                                                        
//  Portugal                                                                     
//  Tel: +351 229471010                                                          
//  Fax: +351 229471011                                                          
//  e_mail: chipidea@chipidea.com                                                
// ------------------------------------------------------------------------------
//  ISO 9001:2000 - Certified Company                                            
//  (C) 2005 Copyright Chipidea(R)                                               
//  Chipidea(R) - Microelectronica, S.A. reserves the right to make changes to   
//  the information contained herein without notice. No liability shall be       
//  incurred as a result of its use or application.                              
// ------------------------------------------------------------------------------
//  Last modification   :                                                        
//  $Date: 2006-08-09 19:14:11 +0100 (Wed, 09 Aug 2006) $                                                                       
//  $Revision: 169 $                                                                   
module vusb_hs_up_int_amba (clk,
   rst_s,
   rst_a,
   rst_local,
   rst_local_a,
   rst_gen,
   s_haddr,
   s_htrans,
   s_hrdata,
   s_hwrite,
   s_hsize,
   s_hwdata,
   s_hsel,
   s_hready_in,
   s_hready_out,
   s_hresp,
   interrupt,
   up_device_mode,
   up_host_mode,
   up_run,
   up_endian,
   up_dev_setup_mode,
   up_rx_burst,
   up_tx_burst,
   dma_up_addr,
   dma_up_datard,
   dma_up_datawr,
   dma_up_wr,
   dma_up_ahbbrst,
   dma_up_async_adv_irq,
   dma_up_frame_roll_irq,
   dma_up_usb_err_irq,
   dma_up_usb_gen_irq,
   dma_up_sys_err_irq,
   dma_up_usb_hstasync_irq,
   dma_up_usb_hstper_irq,
   dma_up_hst_frindex,
   up_txfifo_addr,
   up_txfifo_datard,
   up_txfifo_datawr,
   up_txfifo_wr_tog_en,
   up_txfifo_wr_be,
   up_txfifo_wr_handshake,
   up_pe_addr,
   up_pe_datard,
   up_pe_datawr,
   up_pe_wr_tog_en,
   up_pe_wr_be,
   up_pe_wr_handshake,
   up_pe_dev_rst_irq,
   up_pe_sof_irq_tog,
   up_pe_dev_sus_irq,
   up_pe_dev_nak_irq,
   up_portctrl_datard_0,
   up_portctrl_datard_1,
   up_portctrl_datard_2,
   up_portctrl_datard_3,
   up_portctrl_datard_4,
   up_portctrl_datard_5,
   up_portctrl_datard_6,
   up_portctrl_datard_7,
   up_portctrl_datard_8,
   up_portctrl_datard_9,
   up_portctrl_datard_10,
   up_portctrl_datard_11,
   up_portctrl_datard_12,
   up_portctrl_datard_13,
   up_portctrl_datard_14,
   up_portctrl_datard_15,
   up_portctrl_datard_16,
   up_portctrl_datard_17,
   up_portctrl_datard_18,
   up_portctrl_datard_19,
   up_portctrl_datard_20,
   up_portctrl_datard_21,
   up_portctrl_datard_22,
   up_portctrl_datard_23,
   up_portctrl_datard_24,
   up_portctrl_datard_25,
   up_portctrl_datard_26,
   up_portctrl_datard_27,
   up_portctrl_datard_28,
   up_portctrl_datard_29,
   up_portctrl_datard_30,
   up_portctrl_datard_31,
   up_portctrl_datawr,
   up_portctrl_rd,
   up_portctrl_wr_tog_en,
   up_portctrl_wr_be,
   up_portctrl_wr_handshake,
   up_portctrl_phy_select_0,
   up_portctrl_phy_select_1,
   up_portctrl_serial_select,
   up_portctrl_port_owner,
   up_portctrl_data_width,
   up_portctrl_port_ind_1,
   up_portctrl_port_ind_0,
   up_portctrl_port_power,
   up_portctrl_port_chg_irq_tog,
   up_portctrl_suspend,
   up_ulpi_datard_0,
   up_ulpi_datard_1,
   up_ulpi_datard_2,
   up_ulpi_datard_3,
   up_ulpi_datard_4,
   up_ulpi_datard_5,
   up_ulpi_datard_6,
   up_ulpi_datard_7,
   up_ulpi_datawr,
   up_ulpi_addr,
   up_ulpi_rd0wr1,
   up_ulpi_cmd_tog,
   up_ulpi_cmd_handshake,
   up_ulpi_wakeup,
   up_ulpi_wakeup_handshake,
   up_ulpi_sync_state,
   utmi_pwrctl_suspend,
   ulpi_pwrctl_suspend,
   ser_pwrctl_suspend,
   pwrctl_suspend_clr,
   pwrctl_wakeup,
   pwrctl_wake_cnnt_en,
   pwrctl_wake_dscnnt_en,
   pwrctl_wake_ovrcurr_en,
   vbus_pwr_select,
   up_otg_datard,
   up_otg_datawr,
   up_otg_wr,
   up_otg_irq,
   up_otg_id,
   otg_autohst2dev_start_reset,
   otg_autohst2dev_set_dev,
   otg_autohst2dev_set_run,
   timebase_1us_tog,
   timebase_125us_tog);
parameter usage = 1'b 0;
parameter numport = 1'b 1;
parameter eptx = 1'b 1;
parameter eprx = 1'b 1;

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   clk; //  system clock
input   rst_s; //  synchronous reset input
input   rst_a; //  asynchronous reset input
input   rst_local; //  synchronous reset input (
input   rst_local_a; //  asynchronous reset input (
output   rst_gen; 
input   [8:0] s_haddr; 
input   [1:0] s_htrans; 
output   [31:0] s_hrdata; 
input   s_hwrite; 
input   [2:0] s_hsize; 
input   [31:0] s_hwdata; 
input   s_hsel; 
input   s_hready_in; 
output   s_hready_out; 
output   [1:0] s_hresp; 
output   interrupt; 
output   up_device_mode; 
output   up_host_mode; 
output   up_run; 
output   up_endian; 
output   up_dev_setup_mode; 
output   [MEM_BURST_LEN_CNT_WIDTH_WORD - 1:0] up_rx_burst; 
output   [MEM_BURST_LEN_CNT_WIDTH_WORD - 1:0] up_tx_burst; 
output   [8:2] dma_up_addr; 
input   [31:0] dma_up_datard; 
output   [31:0] dma_up_datawr; 
output   [3:0] dma_up_wr; 
input   [2:0] dma_up_ahbbrst; 
input   dma_up_async_adv_irq; 
input   dma_up_frame_roll_irq; 
input   dma_up_usb_err_irq; 
input   dma_up_usb_gen_irq; 
input   dma_up_sys_err_irq; 
input   dma_up_usb_hstasync_irq; 
input   dma_up_usb_hstper_irq; 
input   [13:0] dma_up_hst_frindex; 
output   [8:2] up_txfifo_addr; 
input   [31:0] up_txfifo_datard; 
output   [31:0] up_txfifo_datawr; 
output   up_txfifo_wr_tog_en; 
output   [3:0] up_txfifo_wr_be; 
input   up_txfifo_wr_handshake; 
output   [8:2] up_pe_addr; 
input   [31:0] up_pe_datard; 
output   [31:0] up_pe_datawr; 
output   up_pe_wr_tog_en; 
output   [3:0] up_pe_wr_be; 
input   up_pe_wr_handshake; 
input   up_pe_dev_rst_irq; 
input   up_pe_sof_irq_tog; 
input   up_pe_dev_sus_irq; 
input   up_pe_dev_nak_irq; 
input   [numport - 1:0] up_portctrl_datard_0; 
input   [numport - 1:0] up_portctrl_datard_1; 
input   [numport - 1:0] up_portctrl_datard_2; 
input   [numport - 1:0] up_portctrl_datard_3; 
input   [numport - 1:0] up_portctrl_datard_4; 
input   [numport - 1:0] up_portctrl_datard_5; 
input   [numport - 1:0] up_portctrl_datard_6; 
input   [numport - 1:0] up_portctrl_datard_7; 
input   [numport - 1:0] up_portctrl_datard_8; 
input   [numport - 1:0] up_portctrl_datard_9; 
input   [numport - 1:0] up_portctrl_datard_10; 
input   [numport - 1:0] up_portctrl_datard_11; 
input   [numport - 1:0] up_portctrl_datard_12; 
input   [numport - 1:0] up_portctrl_datard_13; 
input   [numport - 1:0] up_portctrl_datard_14; 
input   [numport - 1:0] up_portctrl_datard_15; 
input   [numport - 1:0] up_portctrl_datard_16; 
input   [numport - 1:0] up_portctrl_datard_17; 
input   [numport - 1:0] up_portctrl_datard_18; 
input   [numport - 1:0] up_portctrl_datard_19; 
input   [numport - 1:0] up_portctrl_datard_20; 
input   [numport - 1:0] up_portctrl_datard_21; 
input   [numport - 1:0] up_portctrl_datard_22; 
input   [numport - 1:0] up_portctrl_datard_23; 
input   [numport - 1:0] up_portctrl_datard_24; 
input   [numport - 1:0] up_portctrl_datard_25; 
input   [numport - 1:0] up_portctrl_datard_26; 
input   [numport - 1:0] up_portctrl_datard_27; 
input   [numport - 1:0] up_portctrl_datard_28; 
input   [numport - 1:0] up_portctrl_datard_29; 
input   [numport - 1:0] up_portctrl_datard_30; 
input   [numport - 1:0] up_portctrl_datard_31; 
output   [31:0] up_portctrl_datawr; 
output   [numport - 1:0] up_portctrl_rd; 
output   [numport - 1:0] up_portctrl_wr_tog_en; 
output   [3:0] up_portctrl_wr_be; 
input   [numport - 1:0] up_portctrl_wr_handshake; 
output   [numport - 1:0] up_portctrl_phy_select_0; 
output   [numport - 1:0] up_portctrl_phy_select_1; 
output   [numport - 1:0] up_portctrl_serial_select; 
output   [numport - 1:0] up_portctrl_port_owner; 
output   [numport - 1:0] up_portctrl_data_width; 
output   [numport - 1:0] up_portctrl_port_ind_1; 
output   [numport - 1:0] up_portctrl_port_ind_0; 
output   [numport - 1:0] up_portctrl_port_power; 
input   [numport - 1:0] up_portctrl_port_chg_irq_tog; 
output   [numport - 1:0] up_portctrl_suspend; 
input   [numport - 1:0] up_ulpi_datard_0; 
input   [numport - 1:0] up_ulpi_datard_1; 
input   [numport - 1:0] up_ulpi_datard_2; 
input   [numport - 1:0] up_ulpi_datard_3; 
input   [numport - 1:0] up_ulpi_datard_4; 
input   [numport - 1:0] up_ulpi_datard_5; 
input   [numport - 1:0] up_ulpi_datard_6; 
input   [numport - 1:0] up_ulpi_datard_7; 
output   [7:0] up_ulpi_datawr; 
output   [7:0] up_ulpi_addr; 
output   up_ulpi_rd0wr1; 
output   [numport - 1:0] up_ulpi_cmd_tog; 
input   [numport - 1:0] up_ulpi_cmd_handshake; 
output   [numport - 1:0] up_ulpi_wakeup; 
input   [numport - 1:0] up_ulpi_wakeup_handshake; 
input   [numport - 1:0] up_ulpi_sync_state; 
input   [numport - 1:0] utmi_pwrctl_suspend; 
input   [numport - 1:0] ulpi_pwrctl_suspend; 
input   [numport - 1:0] ser_pwrctl_suspend; 
output   [numport - 1:0] pwrctl_suspend_clr; 
input   [numport - 1:0] pwrctl_wakeup; 
output   [numport - 1:0] pwrctl_wake_cnnt_en; 
output   [numport - 1:0] pwrctl_wake_dscnnt_en; 
output   [numport - 1:0] pwrctl_wake_ovrcurr_en; 
output   vbus_pwr_select; 
input   [31:0] up_otg_datard; 
output   [31:0] up_otg_datawr; 
output   [3:0] up_otg_wr; 
input   up_otg_irq; 
input   up_otg_id; 
input   otg_autohst2dev_start_reset; 
input   otg_autohst2dev_set_dev; 
input   otg_autohst2dev_set_run; 
input   timebase_1us_tog; 
input   timebase_125us_tog; 
`protected
?b9g7SQd5DT^<8MbZ2Ad2;kamBT\359=EU?7oVenYmbMkk\PRediGG4kX<co>>Lp
^\5IIG=DV;l>HPQ>X3AfHG@S^XQ8Wci:lZmUY19>\3j2FJE:mhJnK9G6283qLeTD
=bPSO_3XlP6Q>f`V@kTH:<DIP80d;;;lZ`jMUWGJ1QW;Sd?Wh\8>q6h3VgHqQ`Te
J`HBn`am`1bADOgq1[jcafb<gBAUA^@1AoOH=<I[>hm>nSHjT@iq[>_R\;f69>FD
Kmc=nZEdACeBLOq0IhBi:259?91CjImjo;20WFc7alomT0VGH>q`D_nJIBG9>:X@
AWNSP=J2K;53`0J4c=oqbjjdeD`7DMn=<Ad5E:1Q<cqTW[9Bf^R0jXlb\oio3K`c
YAmHUTZqJi9>2Q5OEHNCQIAc=jGGA8Q[=PqHb_UR0;9Lk8DAb9Ykdqg^@7a6_UjR
<6WCTkPYeGG?pen3^;W037R\1oT7kN]g7\d67O94^c?:jqDaXI=XFe7iPhKeCJS2
F8DA_1b>T:TU0eFHK_8dZ=ETbZ7UGfSjWUo1]nGNATSMWK\TefmJj[CCV6ZDGmp2
EZYPQ3gN3oOlmh;I[XD[:iA9BJpheWL;^G6Lb7[XjJS\027ZI;RGEnMG>P0aT3\i
UR?d4TZ5?X89Nl4\@E`dnLkV>\Ti3d932lbkW?BGL3Yp]Zemm0KO]hMS\nlN[h7h
B<Y]:`A:Im64F>h?9]pGDYWG841l=e6ETPb_VW1?4PH@_88>a>7@m4_=96m3=qGL
X[6B@BBKW`BiA2>QH]H?PYNni:^^c=R:gqb>9Rg6M7h1GWG3nB0\W6j@Pj8NM6;0
X1GHGL@\fT>YqXM182n^WnJdfLa\jeEREB_:WCj_ccklJjB6KkZMA^F4Yb?qB07:
:>dSH\`jR1dkTC51RV?_^lV5SkHbH75kUXkTRTj^[<IOL3o1pDdN[4:M]lbeEiJD
ZGPnf2lWiK>O33BQWV[`qRehOSV?FkABVgY[`lS:Ib<4a1G;_:Z`:`D5`HURVPgh
q:1>cSf:@QE:7i5BBac2RdJjDDGMCN[NEW`4jq^[NaZA2>VK^Kk=i6YTj]F6dZDg
P\?CoN?i0X_EJ;q:6WCRY6aKhi486mUkQIAlRo2V7E\gk1f0:TE`^bZ3>kRAnX2P
XjMngVVga1D7Kl^8LmG:HVqh?T3`]hC@PiGOgb3gemP@@G7d_ES@PpZ=>SIBDjMP
U@e0IlNM@4lHL@InX>;gdjS;FS^Bp<Ld\n:EoT6@bKGJ@[J`fWaKU?HILW[a9RRU
3X;cGc9Y]5Bl4pc>LUjAccD:i6CX]>953fUB^WnWWbMlm=IXQ]3CNajc\G[nFVWj
H?[2clqYLY?TnUjO9WjOJ?m4f;cYc:WB1H18o<=m=3@aQ_=eeMEUW46Tbboe4MN^
PW]dEOmmnpNI0@6?SQTj14nQ^n_OFgJ`^UUUUWa3=o6WWW5]J90f9V5]p5bbW\Zk
e5TFh4bV^JEVY``_^64[]:CXU:1KELOkRK\OCo[XC6Q7o?7ORGS]>Ni^=5BX1:Bq
`_KW5`J5kT`dST80IU;^BdQnCV[AhYaILU\FP]@BEQ5;c2?T<_h^QSP7E`;Xj^]J
`NWGT`p?3WB4nX;8R53L=7>DKgQ2UR@;2?n`SZ0`XXnR8mW<_FEQ5MnR7WgkamDF
CpB=c6edW6G>Vl7OiSL<T74j8K6oO]41ZEfmcN^8_2SM0QeVjLe>SbU`J>OC6JU1
O_CgbO^EeqRZM1M1C4Gj0b9?>EHKm_2M7C<B9WKGC555@O?4hgb`=PLiZ2eo8Gc?
^RWYTbJ]P2]2@qWC6@F3@J\iDDV\^lf?lNXLoA^gme^OAd5;laoHXbX6nRhLlY;\
KefK=So>Dfk?V2]WfpEPkVoXfGQR_cVRe11a1SXY4RhHfDOVN^jO2XH1`bf<6h=B
?GbYEXE7\OGHE\RoG^;NHpJ0oR?5V0jX6I\HQ24F<ZgXT>_[PH9]CF<_<h6fOfif
Ego7m\T8>l;731X\R\@\jCj9hp3nDKD1]Emc0`HQR[]Fm5Knq2=<D<MKFj\B:LCd
eLd>Hck0FBSL`Gn8ccLLbD1?:=Y\2T[b6\e<1Slck]P_12CYo_:gqIE4GD@aXKKW
AOT_dNoV@KDB;e2;g7ZL5l:0;43M<A`h=FlM_W:ZPP:dJiS>IJ=Uq208UXj_d[`d
ZYgH:@b]JnB2_liAQ0e`<9j7[fa@dC=p94oO?9502\G5lY_96c=>jPQ`Sdg@WW6F
AK_E4Sgpj8m>a=?RS1JF6n0g9kdcT@cNiR:kqEXnRQdlMX_k2C<9LKlHQj\1OmO0
fLPXoAniW=aGoqJ9OVGTMbQJLA5H>m2QCn]=\l[UnX\iWa]4i_4`b^a5_`Z0ajJj
1ETHi:7Yp;M>a9hHN`YDmgU?k\UK@N<VL[O4HJ9OhkJb4R8GioIm<g>1Fi?hbI92
cqZ\8L<<2:jHYI0[TdE\_0S<P8K6G>^G@La]KU:U]7FAiaeS3fEnTQC3bPL>T^GK
pOd?InX4SeLkN\RRe>c:OUkY@8A0\U=X5Lk4b0ZiGg\C8W5E@:S^MjVH5Rl\>@9?
p>0?XCIUibdbKU7Ki]4ZihLAg@o\c8l5WF6M_CI99G]Ym@PkYk@YlgdJ[<MTAdMW
?>JqfUKYKO9Hl@ba0]WlKd6lXa[1J6>U`P7_mSMQ9EL`]k7kafG`nD1n\:G@Pbee
4NqZU1]<>Mmdm5g`nUco@^`6Y\gi9ofe5EY26Z97n7J:I4?<SQDc^L?hP^`b]4KW
m]oZL8qN<In3\1[aMB:2dUaUal9nN7n1_bP^[qh3>g1oVYbjWgKUD63`:5Ef\k6V
OgQ@A\b12o198FMlq3UC=Lbhjo[2BabOXCk>:8SZSPRkILO^kGT:Ua61YM:><cb2
[\9hk]ep6NfEj8FB[EKO1NI>f2=hF9n:mSD[AiFR730qFmG[M7oL@I6dBi45P]qf
R^kRW0SWSGWYaeQOHZ>:k^f8R`8V80mN?pS0fG_<RbE48go2`ELPI4\]DHDfeI5j
[YT8;\HWbpEYY\SAn[c7cZ82@[?K\K@CATgfBNHCS03>J6<\fp=kmR9<USC992@]
aIXdl6fTb?VSo8JCTJoVgpdDZ`2;BUjJIQK]`QbKTqK?2TTHdhWHf_o>i>i\b_8[
P^qNK^d\3m4o_o0^>_kgeR3?A47_KM[>XhT7P<0InDV57fPW?[>aJ7?mW[L8Z25[
AQHTQ6`??pknK=Sgi[4UMNPP1<O0PWDUOK;8YM7VhQaloQGVR8ZcFle26KGCPSNb
1NHIpWZ49BCq8XB;UZm3SnC<_<1:=cZ;08hOnLMq1][A^hq`>AU<0@;FYnoBKQ2j
M:13oNZ@5RpP2<kk;q?OhR^_^8WGeL;Z;a2`]KAYTf@YnaB8RB71bnLAe`qD992n
lpR4:Fhn>OWX5D0kUl>@DAaOj3cd6ZCoYEq\eT1AA1E:91OOUSYiYAG<WLMYBNOH
\l;HElq0DX\5be<4TkhDmH\V5gbfgfXGS?i8Tiih51EL6MK5lGRF1kq59d<23llX
D7BhLmdR_Sl1XXXCjQ=H1NNZ0CpIWADX[ba66XSNT4V5EB9]A=Ih_OA;Ai7Yo2pC
6W^=J=Ab>DNe@8?Ob7;;Q;eiZLCCMTPpUAZccC4nFM5>Q70n`8j[3P1EKHc[nLVK
9h3p7L4ifb^a7`C4]TX2?K:g1^Ja6i_2AgqKIZh]8aE0EViS\N_RfBA0n<<3dMn_
FJ0>P\QlKifFc3qnTb<Tdi<_IbGO?M6\J]W2oiG<=XYD3=F\mFIZC32X\N2e5pTb
HPGQWF4?O8K04QFMgMCYRa=N852@JIqR]X?dNbHgCOogncFB<ldAo3QjeO45Ub47
S>bJ6\qY92CCjKKd`h1A2ZFU3;a]SSB?HCfc^p>83W8LpYS:@H>@@`458GCdn58J
LJBoSPAfP5`MD`3fqC6O@^lqGViOdP<Mb<K:Xn>o4?:1mgmAIc3lV:Ri<7T\G<31
l6>q]1?n_`qL`>W@AJmGOL7kBW>UX^U?EiE0P6lmMUXFSd=b95nm7ZqkJoNAopCD
OOndDB`@JcO<[b<P;7CAb\D;\i1P?i4W\e\hqg<[Og_INH>;MV`oN3O0EfoBcX=9
;pk_0:J9pC=Qhkd[TieNfDRo=_Z1P]6nD2^a<0RlCeIpbLFBgR`@R<Ooe6`<@^O1
MEWjlifcE`UB<ce>AMe=iDEZafgd;WX`SBoXFk_H3=ZUj\cn7OijDigKjLkiORQN
Fc?iXfY3YVX8lK3EOboC?DMOnBql3o9FlqkiABHIfGMbG@<dU[74k<;A[5P`<p^F
8I9]pO]bk4jVJ3UVJLZWgLAJ;ibV2H@Dp\?N_3469jibYofO9UkLJO<416QOigVL
MfZ?_3PJU^e^@RDgSdAO1ZcqHjFijGpRQ0JPEBj=3\88k0`iPZa]`d>3nZYX;K?U
Sh[JopX23bNEpdC:H44n4N9dUC^a3DhJ;B7Z`ZH7YA893eQT_9RYG]>[pSlNIi9V
[2`>@9egkRk9Hck^6Y9G@P`kWNK3Wk_<ikO<JMgDm7=_E@_c^kFZC5D4;V`X<ZNq
>gN=6]pe;QW5]N[@?7E:L^j4nl?]WDXN\PM<?GipkdWJ4MqV;;SYjK^Tke>YXDK?
o5f5?J?I^0Uhfb_;TP>l`MR_OA8>8]20EiaN62no5eEfE<@KHQoPmplJ2e2Rg<\?
LhD]ZTUD2??3?AHHJC\Qp>l1hCHq[ibUlk`[U3TDNJQo7^^LhTRKbTG\;b@=UY_q
3[bXZ^q7`0Y\^V_7^UO`KJm;dPJQO>Tg[oWQ7Tb6Rd;eZXkR=?pUC2[Y2?b[]CkA
YTLYl^fV]k=7KL^EPm=:K22jdPDGQm[KJbRj1pL80aE8qcfoIIYYoN7`Rl2mZZ2D
O3ROSe4KC`S4G@MNF7VR47UJqBBdb\lpXgPAM4<Bi;YLcQlRPRC8m:k]e35FnakN
m9gk;WpHR>\U9qj@W9Ne59Y]KNJf6PVldmL_NiVJCVVo]>qIYDbk:^Xh\WD:3ZL@
nU8YXgYODc9MMNGMC@Nfef\Gefpk4JXk2pc\h?:W=hBkk>ES:Rj8^H3DJ6Yg;7ec
NUHA93:Bq?1U`b<poFEj616TX@@g?Im;l<A3D47[:853^52b27cgMEOLEE=dSG[[
i?VpZ>W?a<qAk7nJ?m2kPBc5UFmN8mBdic6WnRL^6hha:mYeYU^1MX<llpM]1d>4
qY;JceAoPl?;:Pbb@6:UY>R9QcOSHHAqR`C36hqIG?E9]E7YmkG<bGVZf6F?H72_
5e[<Hmh9Np@RVC8eQ6FG`;RH:dSVfDkHK>oE^^:30BHVQLR\HDqEkeLZBpF1lB@E
G134V<H0M^6gD@nOfUNPL\>aC:JXmlL`od`ICh6747EiV1AaJWFG1qL[5Ym4qD_7
KYc2:Zd7^9?3b9c42C:FjUWPUg6Y\0i98dc1R0R8qW0?dk>7[hDjSGlZ?TgS<eLR
40c2B;35ZRZcfHaNCkEaGRYRnj7KM>Nf8Ddl3]nPaRBpn?LhB`pkPih0d3V`S3<E
LN=klmi20oM8N[XJ>WC[fd80P0`gYYpfoHeZQpZ?3nX56i\OIi4b1Z_\A`E:<f]I
Bi>?jofhSoY[mAoSaq?aBnXlpj1Ob=X<\>of4oHn6>:X>:Zb1WcLb7WC9]:;@POW
h>WX]AMh1q^6WGbVp\m@MJQK;lIY?19_aoCELjIlNPFBUCaJ4O]S`886]\Ul7bIL
hpOC?iUkWOi1P:3an@U4[i_aDC`_j_\4UD_cgEAPAXc@P6lSUpLo_X`IpGXj`BaR
MBC`X]KUoIf=e;Q0Og?8m5WH2hUaGnCqaRR?P5q38T5M?^F<nSJOML375=?aY^]e
miTLfKI1]DcTH:RoTaXEGo0\]hpS4haE6qgJ^MJ7m394gef^YX?R<`Xn2Q1`E:K9
FIkMlUG8Nea104?WX5mLe[9=<2na>e7NW<G_bqak@Q\EnPcG2=D0e2lB[A`3npmK
Q>hEpEOX9S6_BK`C:\c=8WUBH<annlH?M`Dg7=An<b@<Ykb]>YGGaU[@f8jdH[;o
j^Umo8:i^>QpAJ@]bbqDYm@=S7n<Xn^Pk1]>B7hTPRoeTH>EES\P2W7352VSdXB3
TmI0aDlXKR?HnDEO5pFTPL26p^UHQ\=RYYETT0[Yg>_BYXAm7LW^L6c7OKNDJ_`B
HN5j`ROA9OCICaLbH\^I;A0q=9[lhUhhLnL]_]B^_2TggY[>WB>K]F2>[cMA:K6D
ANJ^3^d0T^7TE1bApVCT7gTqYMf<SnJ8QnBb`QjUP23c<4AI9\S9hL8d\aYI6Hak
SYQ:jL:Ah2heKXPM3kaPXmpKFD[>=qUO9\Righ534>:dea:eI<gQO9hTd<H2jEn`
mKP_k?Hfn1ZmBWLlli[fbAK3kUEUB:bj?OaS0Q4N>qIWZQX1qYWNGBdiS0YF919b
kB`STWfZ4n;a]T`\6hQg903fEg37o;AIY2fTa^l]odh51XY?9>S6fdCq=GGL\DpS
i`1^<63j:8jY3II@ADQ;52a`f2T6ok=JZ=li4jO1T@k_]Sb=38>^6:FMJPXb6qaA
\^`XQfkCi]A5i:YlRA\RVpJlDRchqd90YfQc\[g<I=_d9b0RXomHEG5edb62AB\Z
nO6LZbDek8JQRY[IpJ7VBEgq]VdaK=aX8QkWXI6446f3Xe5EPQ]Pa:5fa>DUS;7Q
XaI@05B4QDbeWWXbq7=jf^mp^;a:=@8l:a[N9jLQ\^5j^=^AJnTGG35BZUoYFUT\
mW7YPYj;]kVCFIgep;BXgQCpJSLU8IN\cmA>\dO?PcZIjff111dE:Xdc_?ZgB1a4
Pj<D_bGCBaRH0Sm>PXYPA^DHqJAfc3j?J_W1_ch:ig9nQ2\Ne30B3g]NO2<NEYAW
DQ_mYccXQ[OoC]gQE>hY?>:_e9\FLe8ip?2B4APpT0BAM8no`6SAd_=Dha]=:h0H
Di8K6m@TcPLflOJ5^[STPCKo:b\U2XqiMjab?p<:[F2Oi3TU\WoFE;X@j=\W9I5?
cV;07IHXVEHhnj\VYc>_Z@o?\A<l0;^;34<]d65G\MYhG7p_7<9V8p]_EbFG4QLH
0C6D4OYZPFNUF>:020ih]1IZL0CcT6qQHgRVfVM59:X8c<C_V0@d^eU9RmMEaZe1
n2YEdSiPF`BJ6<dZjbYX8?AHQ53KgdbheGTZbLLp0_G7:9pRb>YA?]:A<6;a3Y7W
MNSN_kZMIfhfEaRmago@:D]U\8g:2p?aK`YBpjn6oY6F\8cPf<7H[nhWoV>aM4o;
k3d>:^hEk[P3U]ZaP]DqNKRFXWqE9\dcVmNgH[LAE07YhlSKJL_<I736F]j\HiMg
?Y4_OaceKVc7alYFaq>AgI:9p5ji=7RHJ4?XjULQ4:381j;GE7fUKDX[>mYJ8IK:
c>`mp7N@=d[p6Ijd7b2F0HEZSLXge<@>_fT8FIEF[TYBWm0MXo4GN7fX3CbHlG46
nm2LGUD]q?EaFel]4m9oU2D`_=2J3Mh==k^J3?9JBD<5bnQFEOdL6`8TCC5=C]5@
=j^9j9Kq=8I0bbq@5O^WdP6=BGXi44HAlZELlTFYFKY_RiE;3Slh<Y:@MIJn]3\Z
7lV9?EAW:Cq]0?6D8qM3bo\3oFRVA8EK`;`4DNb5DQ9dInCCL3fjOB4XYTN99f@P
ZSB3FXFWfAdBNq@o>Jji8k^0DjJkeFf[c8CY7IG=7LIXJQ[F8bo[mN2?q7Q;jJ:q
DF17QkFS5HoIM@:oQo9e\FXFm1XNba]g6U9ZlG>7GG@CDQVEd>>P:Y1j`<np>8Bc
kSpVKoHAikFBj4fIkY1dAF9Qjb5;Xl@e<^1H4M3Onn9migdo9SChSdQGBF[<XNpU
YLoV36oL@ZM63dK_YSU\Zi04H@RG7JYMmPNeM=MXG3YQ]f6@NHI7S<kVGT]HNQq8
VSoB9p[DSRcJL4@3?<R7>hG=K:^LNjh=aTGH?`^7\PnX@F<QM0Ae]jZ4nQ\O;IB4
c2>=BoFo_pXPe>OCp_R7Tb@ejSKB7nGm2b:BkLP`kLFgK0o`ISA:]8g]hg_YFAK6
BF?\]>;R@eAR0^k;YMJUpXF[GFlqUhR3XL3MEX1G7cAUK`4g13bbkeZK9@^gG\<7
dT@2FQlOB=TM5MNCTKhm4j]`a5a=^o`pGS4[H>qnb97cX=Vi4CGSUb^elUNjV3`\
4fIpdO7=YI]OjI:bIhG:E4UfF8U?n^R]VFA3]M`kKKHgab0OQ^\jW_o6U]98n3C\
:@`;e41pj?FD?IpO[8I_nh;9i=i8P;WRmnQnaac6<f4o^Q@>3Mc>WNcIjOGDf4L]
k`3l8<CW4o@WfSE0TMp@W7fSgpLYdNGPPX^o9@c68G5Icgn`h1W2lhnh[i\<ZHM_
G;V]mLC3o9XJEaHZf]<_T\XL[hCL4p=O`T4Xj6>Yl@mnkI=kF6KE\@A:mORii?=e
ZGSMXm7HpJma7?6p8LcNIL98iKZGAdSi`RJhABoFmEW\bd31dMLX199<eQ:TghI8
E`BlAbC[f2:_g_A?[I_pf2X?c1ph=Qjm5K\jIC\]5S>8ToJeS[:fEC0`Je`:9nhf
jBUiDbCG_ObOgi`hXBM^Chq4TaOl:eOHgYjT0ML^B=6aGAGLWWZbld3@lXc@U5RD
baCK3FE?]IeE_59CB6iG[mO\NUqNMSfSnqDPWKdYXjU`37SgP\0>;UPm?TnbD9d1
VX81RDjZM0jPP8NQAmfDikfnMZ8@8?eTLOnVlq>g>^ZPqfcDW<k6cRQMLLHZEP=Q
\g@f7::4:NZ^=l7ioN`dPQJ2_I>ZINgm]gejSi4gQ=kJGcnTpOdQJEhqc^UF4IS6
QS]4jik0?X[X`bTT`j`0JFBf24k_kA;I>:UB99m?JSPB=oY_@@Zk@1TGUbOMUip\
FN8dH7>Vi=3Xf9i]nb;q=]9I\\qkdo4?b7ai3Z`d`cc@LdIk@3>2@cXYW8l9he0T
@XogT?V1\5B]MKWYWbl;k[fejndQEK0j\p`ACPPnq?YBkijIia^[RfnX]0aH7C:]
Nk2l85H^Kn\5gd2`@FmoT7K5kJ4b5HBPobo2kDVVL]@jkocq]XYISgp>@C?b]KO@
0KF?DLB08`G[EoA;Hn<UKe\U63K<1>c6J0@]5CkfJJL\5PAFnRada3HaKYEB<q:l
fPAPpnQ@kA]GVe4?oeE;XAA>c1]mgM^IRj_c1qTk8Fj;f9CQn2O]HXBBANdBAdW`
[ViNblkH\;In05>M^`<iV]<KZCHeUFFcmjegd8FkE6Imq1]O>a1qPGR_Y[ga8RTn
nP4:dW0Njh\>M=ZcJ=A^YXEJZQTQHVMLa;X8oaMPF^@KkY[@V;[56Ob2^1pIIgQ^
ja6^h2C3h>0h:K3oR1WJYcSmjTGcTf`EH8\U`\Yfb0pfIC;DCq\>@LWAUGR3X>B2
N?bnnXfeeQGOiXJ?i6cKI5NFR6L3HC4Z<JSB@n?\mSG55d3gKNXM_YgPpgfbJ<Pq
kX3cHH_2enLHPT9eFniiPgL_=W2bFKlI:c[:FeE@7AiV7:a6^?j5K[AC^_gN<1nD
[e:EoWqMiacP5q6YMkRfL55co<5lQ4X:Th\Gm`]T\R\k>f\i\c;FKYeEgC@DXWPR
]8UkLlN3EZleUKnRLCMEq0@SkmeqZM2V?P?0]bA]:PUWQ`l^ND5QiKS;DA13aCIH
`b_l:?FHDRS21PJIj?5>200SFX^`@P\ULep<@Z]c:3NdId\426ZjF]c]CAIT7lO`
EWGB<:T23EfIepJbc:NEpeYc4ARC?HB3MhgF?S;m`Zc\;aYK?m1fg8;Q?b>BRMV4
R4DF3F>ZYG;LZ0B=]VTZS<ReK9SpGX13C5pVJ_2\S07Kg=GT5Q9iX5PQAHEmEG?f
H5Ed:4:CWJXe?FbYcjL>Xj<SG[`fSocaP3jSAGih0pkFhTD:9E53emaaa\TcaN^L
:TSl:0k3?SWI9_Ia3LD456`RbL<mQ]Chm9?aCG9ZQ;QhCBpoh\VC1q>T5bYakP?B
TUfZmiZOm16YG9PU<5L16K<LoKK?UlMdD;3KT]8A7oC0OMB@gg;ZLgkHRE@=qH?3
@64p?\X<Ub_k;hKJi3gCGQe2RAPlm?RP_d>2eEC[g_434UDa4fTD^@Z]l2HnXk<j
_\<@R>Ejn8pl<:Fg1pd`LEkM?FJgQ=5Pp?85EWK_;kiNEVc<ZC^^=6TEM9aUn2YW
eEk\E_Pj2FF@93T=hBBe^<jZ^TC[47Wi>A[_Tf?pPZ>3a=q^h5=\J2k@mfm?Q3cU
A6meX`baX<D3HcdD;WabPXO>2ZB5U[9k79VWUPIlEG2Cg=2TRjdSDpT`=BQ7qIJc
ighQBo]5b^j0@d<0m8H]7hIRU2f8lEX8<oJB::X0eQZmc1\8Uhl4_JIK\6cB9kDX
]A[p<Ug6Y]p9Wc?g1=KWI@\lT?b?ITBfeeZPe]FOhcG]H^UZYHC;VCm;JE<F?Hb]
NPX^?L`PQlOR884_`pNinAHnhE8[9m6Y\SGOmB50GRSJ?IIRHb1;L?@OSBXaRe=P
87^@53^KTen5?9lb0l^YTY_QqCFcSh6p`=c5G;ODIb39CoKI<KC9ATJ;Hl3?n:iQ
Dj8805kK>R@GJVY?@2YHCJdY59Uj8A?i9\l8[KqA4WTkep8XTOj]a8?l6]B?]W06
mFRhG`OVQ3IgK3EN6[b>gM_L6IXR\qSc5c?n_9DRTc8S3=QdnSoGoH6LdE<<T5Vl
n9U2Ld>K5>aFoCPT6ZN47ZT7KAi9]Ae5YObZq5]bRI?qYZ[P\J7`C_efCPH:Tmi]
XC_g?^=Lj<4U05aDYJWZNcfAK>A30Rfan_LVhCoP@:OTi`=a<`pLeB[:?qLC61d1
a>kiUj9ck:Z28Sc5EUE6CjRTUOBZ3bT4PcMcadlLf7QF_FGmbX48VC1nA_m\Xd0B
qO9QAndpWhJ>4dDZ4SdW7=MHU3k59R6>@_<@VO5fZIVh>A`Sm[j8j\VWOjE8NHff
1WQXBhqDk?=YJpRCL6;oQ@cVNKb[V<C8g6Z8ggSIRm;4KE>Ygb:>eSadEpnPGXme
KBR4l8dJ@7=>fI[`R02<ULD32IY_\:hbY=n<nPEJ5_^NcpEd\Znlp^L=S2ClfaIQ
5PIB;gEWKDlWGZN>UO]24?60G[:@[W4dN6a6MULJ2:m5oI_=81a3>RNBLWhqT@?h
a<pT@EE5H[]O7OJGA^F?YXHQ5_SN1[4kHZmd[?J0m1jQThcVA4jXe5iJ;3=f^5p<
T3VCnqJ4EnLHeaU5[AA=F`a9X@aDmMi\FinSDAV5]2k^b5Lj_]_K9\THF1<?VPIX
m:ZJdPKYG^nAG]ZQE1enp2OJ:mEq<kgWS_ANEi83njpU[73Qk@07;I=KI@dZea?O
Q]PP]dh[Q6=cBXeQ<J=L4_`N:>Wdj<]eSk@dk2cP9Gc3B;TQdoJbmVWKSqQJ3Ga2
p_Q^indIWLTRY2`d?CW5N930Md1@LekK5l@Q54e90\>DR8E4@4Lf0VOPJBZk80W[
R;C_`d:FSFH24bep?HI[nJpNjIbCX14A6b5]F:gElo^]6:jhRnQlK3`_VE^`]]@2
eMPCC979AiXQOCiiWNRN`0n>OM[WQ9eM^8RgojmpAe[M``pS28L<BF4k:ZP<7:6n
9DhlUY?ebPkaA6TOJo`K=_9XE<b8;^Y`cbecI3;`2Dck6a^C2LAl`@JpI_jSfLYN
ggY8MC>BdXhh;SOXQ9[TLOpJdFM5YqT38nThS4YbFR4\8aLbBXhQCU>hBoQP=kYF
1iaXn`[Vc2WEMBiEG@0cjog@;\hgVCK:]AZ1AOq=@TGgQpMXH@?mB4`n75BklhXK
afN^kfI2ad\fhSknAXcYBBWDX9:\:fOl3OIjaRJIB00VDm41=>8X;kp5iboe7qOW
XmEl7;:I;7K4Q4H:haL2=96<j0]X61da`;PZH`j^^\\G2IS48gZ:4Z\ab90jMHh8
MaJ07[p=ngUZ]pf:LndPOXCoQ1W2@156Um<cOV4>f9BQHD8V56XEdSBKJjG1:9bc
c`:71@CPfM\d=4l[fVg>GQpm@QPLTpWHHDnB3DC<@?kLk418bOcZQbcW6>2R@mi?
iJ?ISW`R09COaeDj<q0>m^ZZX5mS:Im3l:5oh[g`E7VE4>NN\<?SYoYlR\2]?j[d
T6SS@489klEIU27FKk>Hbo\VUflBOUd3Q\BAI7UeVdp]9KH80p`kYmjAbLBVC2US
TXf3WFI4mZ=bU`k1@jO9m_;iCl]Hh_ZjJ@\H\l<;T6d41VOj0MpJ7T5]aqg>b8KI
nX:LM]KB<60`n96lLThbiakcK6bf]WX>4`Y25H<_\gm]4Qej<Fpdg@o4Op7_nNY4
6bGNMgA9E7VKP1^5HN@h]Z;[P=lONgk0\iNY46\3:[emA46kO?qJX0i:7qfiOGI^
;Zm>NM^0AlIR2E>?@Aq\bJg2U17=f[6V?UGL5kI3c0>`eAZd3XSF^F55RfoAUGST
TQ4?AbO:BlKqMHj@;CpLe02XV]I5YSUhFIh>lII]n=h\l:79F2KC]AmlT0BW5Ekm
Dlf;3mlb@]jq64h7Y@Nc49N2QkCp^cB^fJpCjQ^A2a^5g[>@ZRmUhiFm`ICka<^g
GODeMX6h=_]Rf3<8_H_H@=VV6MOp<NE[F7q0Ic:2fLB1ZjJRNS18NNhO7_X8?2f1
QaecAS?H692FfcDQ8bMhT8G40hmq3am_k2ph4Pf\Dh:06Woa=B6]jWe^RQ\74kKS
mX<>]YI:YV_DS^4iK^QjC0A<iKKqYon?S5d==6\i_IKCcn\D0c<g]iV?9h?ZP_YZ
RDm1cCX\9J`Dj<5j:=?K1N1[f6U;m1cpod:Z>4q59XF\Lah\mff9E?ZJDdjD6=:Z
SQjfMT\[[1FODmJhRYBPO62I?IW7E@kq?QM04Cp:`b3ZCBh4g_PQ`fei3e?hDBQH
S1dBZgjRm^`Q0NUf<MB\;bAck<qT<6?iIhi[\WdQYc\UbFf3Ab[RjV7T6fm]9PG9
Nffc;gqgFDcm4qV=2P=^O:;B>Tb^d4=d5Njka>GhY37UR7QiVoH:UI`:LneNq0IY
JkRqTg_YHZ\P1R94k53:H]2f9N;Q?mAqAN3;WJ`VKQ4@Aj0\2SZ54H]?am:[n3g7
GJZ9_AXF7k`1Nj:WbcWq1[WWfGqDYZ0FD7RfR5Fd:B6>kG:SO5M>C>bZZ8?0J9fc
`7=QnLSThXXP1BI>jpD7mc7Xpl6?I>`K5^GaHn[5?B7i0SATcLK>\1hRck9d?L54
iaoOao`lSb\1n2]RSTmV20\Vk2PeDmUpm^DGhCpiGF?;lYfQJ_042BWjFXd0dD^5
=9@[JY_mU7BbR[ogZJ_;E0jDFUpO=W2AP7cC`Q3PelX?I;i[]\V_oM;Vc]86cTB3
B^qD7_aRUpM^_QJWcOJkLYJcF6DSamPc>4HSVJM;oHVU<fCH\Mo=D8I5^B8mC;88
<25Te_RTRfWAGJH^E<WCfleVq\Z`cZBpD;I3_<OjXd?cRHjXT_=92^_;Pn?nBHU3
Yi^0YC<Bi93<]3?FA8MSMiinbK0]Uipb2?:ZYql;]6LB=RE1ed=CgNR\[?0aCc>B
@Fa2g;dTl`eYK7^\<lD4I3b1FDPLg7GOmHkEV<p=m_3Z>pdYlGFDhIYYUUXhdFch
:mFIe`Mko9SaL0L=657YjAB\eDqk]SZ_0M]D780Ji>^1GmWced@4lG0m7T8CVbZZ
69233fV`^l7<;2K8oHkLJOWSZ^HqAl^1g5pPgZ7`Na7RLWCj1o:BDR3VE<iUb5A4
YC>9YV_HAJkLHF3Sa5V_PW4O>93m`YfgRqiSJ4D4qVe81^Zn3k]KWA1BL?`XK3T9
dX5fe2;T^SJ4W71nEGYO04@EP8jL1;fKn51V]WQqm0BYD=pH1HDc@l7X0SNmOL?C
D2iHD:S0_Pj]8ghT9ZenNQlRBcS>lJOqO527`G[l=CBMbho@E0lZXRR<h^n?6L_f
44<9Jlf\:fh4@1pHbdS]dpEi6<N:^CM_h8GWn0O[;61<4<L0F9Y173di2S<ZhlUH
l0dIhhB7Zmk;hcI3b]1eGhpL_LLZPpPH;N?=TPjiD<]U`:ZYcZoG]CAi@29]1DiC
RGU@P?Kj1GfmY@Kj=Z1\VWpWkTef7o1eNJM>Q2EG7KR_8Bg\3Z]M92?caCVLbAb:
YHNe6@M5bLnSlkb7F[:A>IT[WV7O9p5WFbEhq7:\[846?N11?U9h9:CGXP`25`]g
4j?2NPgfeJ7PRb[A[Ca0aKK^V`T8OnLL?<EV>CdSCJ_QIp@jZoH>pJG7S6_\7^kX
^UcH9YmT:dJI_8P]UBIoNZmnh^US]mEK4ilkh;W_V4ephY^:kkH83_nWVO=Ae?2K
=fPj`THH2ERL6opfF66hQpK;[YWc7cFT`MJ>O2VIOF<20fgDA[XVIO4kG82i6lcH
X:W[7=qNIWgEoq42=gIm`Q6HbK24[:Aj6AV<?=@@ehlXcD_CIjQ`PM<^>]ZS@2Nf
Zp7\0HH3=0[[mk82LcdZMUbm[S[\@MZX?eolO@3M@Z<N6LX0OHpJj19;=qTOihCS
<cAJVL\\KhLSE\jLicfdFD9RG3PPg9H^p@c3Q?6pJAdMI@IM78]]S\`OAV]Enfgk
1hj0MkU1Xn<oc1jmPmC[6TI?:V7TSen5gDWhddkP`F;JPQgpjeLS<5B@EiXE8NmH
51b2lWc^o[4OoVFiR0CoiG@Xq47VFV`q4Sl^D8K^eajZm6_HAU5jQAfAFeg7@ljm
OEi@??pKYKKD1q8`2iA`XkX_iH4D]]]Ba9XWS`S\XTG]2FVI4\^KZ=SSM[CIX8C]
]T]e;7Z0kiTTXFQNJ@FA:R16ob42]oiOHIIdpHfSVncqGI^XZV9TlmBnj<himmMS
QXT4[W6@E5[4cjjM@]fidRH8nTLJRZcVnZ7M];;jnYfnJ3^neZR14i6qT^\B;dpm
Q<3o;fX2<neI7cJ?D7JU<@RCd]L5ZiWm7b_9\=E0fKSoma^9UjPU]7CE_9M>EKi9
UkpE?BP:L_9li2ilBjn[F92fV?ZAHlNHa[_\>jQI3`XG0Ee[PndNQK=@JV6L3e]D
fG\FKbngX=nfFBqn1MD>4q@OLk<NUS]L]<bW;^NW6kRFBWTi=XeRI22Yk_=iW2fG
d?3hcN@ADMPS`ip80<1ncp:j=O;F[`F]DojKEV]M1bon@:Z;T;]1_chmAhEBV@fK
<8nda<DLncS\cMhRHhKSIp>2cYWjN1IR^`hNQTVXYVJUKTnHQje]D?`\EoU[8eBR
$
`endprotected
endmodule // module vusb_hs_up_int_amba

