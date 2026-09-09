/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_up_int_bvci.vhdl
-- Date Created: Thu Dec 21 22:43:33 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_up_int_bvci.vhdl $                                                    
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
module vusb_hs_up_int_bvci (clk,
   rst_s,
   rst_a,
   rst_local,
   rst_local_a,
   rst_gen,
   t_cmdack,
   t_cmdval,
   t_address,
   t_be,
   t_cmd,
   t_wdata,
   t_eop,
   t_rspack,
   t_rspval,
   t_rdata,
   t_reop,
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
output   t_cmdack; 
input   t_cmdval; 
input   [8:0] t_address; 
input   [3:0] t_be; 
input   [1:0] t_cmd; 
input   [31:0] t_wdata; 
input   t_eop; 
input   t_rspack; 
output   t_rspval; 
output   [31:0] t_rdata; 
output   t_reop; 
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
2F3mgSQV5DT^<FhhPD_Q5F6TA;<6RW5lZGiB48mV\M`dc`Eq@Kc[dHD`PXi4Gk:Q
O6f<=?<2C<jXY2;2JNSk_^?6L8Nogn]J32=KZlSXP0pFjOL?V>\34neKCp8aJ8`?
q[Li`lmd?SaS3_d;GNAApXl\63?SQ\WmbZSbo7>Gjpil;JVDUVo5l]K:5R?o<cqm
gg99SQc9J[mNS;CZ_4lX7RSfKhMb6S1T<pe5>2Hc\`JZc_Td=o?8po3bA17bCR\;
dcVj[^HJmAmqcT2Kle]3XCQ6@HAJdCf`bPVGl_IoG64?@fb7qSjl9Mi;?dX@@Y2S
JA2jkiM<L5WbOqTOX6FEIQ3\N_@VI\c35c47f@T6q4c^X^kAbBkh<Vg28<6q5WDC
h`\]D[>R@B4C;o@V>cp>GgHgcZi5bgVm;MQa\H7GA;qC9Z[0aiX8@KFF4OD5g43G
CdbLAc<32;Nq27AXoHVb59RZZSm>PXe0K05=lc;o3G\3eZjd[ZdmP@3X>>DXi2CR
]kjEHSZnD5b0HcZMRnBPRo^15T6Mp7mk6>T_2onlHHB]eS`Cl;1KFY8o2^B@9N7b
V`gTNYohaY35W;o4NOSn0<J@QbnJJZK@`EB3SQ487m@MSp?3^DLGalP0bZkBnJ_K
iBE[U=?XVmjJjm0lHZ\hpP`giHN9`8h@Q3];C?6T^Q9D9hbQAVLnPhBNPUo6m>:p
b6A0lRTTVKNL=W7mk@:_JRg>H[`?9DgfML;pnRa[fd_[K`mOcG8bCb8<]M:oO9V?
`5oOdghUX<8imDqH7bgUVm?_RJ\_ThkG\R;c6acnW3lj::oOR0CBfRoqV5MINQ^J
U6[B2?3UI;V]2R2US95V0=]C;@f<;[5BLDI0mKq<X\Q4OYI6dPFb2FUO\A^3FfMB
[C28Ni`J\\p@2g4cMWGYn0F=9FHNVjkG0A7n<Eg;MOdF4E9QE6ki21qlZXk5[AdZ
FGijja6FoUL?mNG46m;l:9fa>_;q@OeoCZn?_0QGlAM?<GEX::cH3KDIIeZc:6q^
ZOd8iPFc_m9gHgeFEg20ce\l;QH64n8PJ1WE^=0p_V>\`4hBj1NO2ncaK8>;Q64M
A@LlCkp^924YN^4[4@JCR<6ISfe:WWCZ9VlnKQnCP\819q;\[A6UfJTi9M];lWRd
0a7iP?FlRCl^TjEfEVkEPhDJ3Q;bKRpdVC:_3k`WR_o_[gW0[CZhTefKFOc@fG`3
`LaF1TUA7H1TS1nJGVC:SKdpIbIkl71;KOZFRRG2i3LeGhfIXB]gXZAU?j=]mhKK
[7SZ<NfY]0;<=_mkZfTF62@jJSpbfgWmU7i:C^^iF@TgdC\adLmQc=E[DBhH1aW[
<>kj_aj1Gq;oh_CDP?oOP3cTgk7ad>@<VW5M^IPNPOhBjH9jDopFc0f4Y64TA@W<
\NQ5oA1USQlL8aFlnO9ZOn^[:25`8Eo`iHIgQ9ScfSi?X>UV;LIFVf?1DpO[Kd[L
PXjc2]FGlAQQd1i6BZbX8Jn6g4`iCHU1;W8I\KHo:m5fm@0af@E]E@L4DBOU?T73
q>AE=31bhCZ]ZLNZam4E3^Y[[KCk5^o0B=i80n]1AYMGE<c0VQkml>@VdQ]lo9jf
P]DYJ;?SpTI315=`o=PS\NeU:RVVofiN\>0;;d_jlaMo2^OMb3?1i:0i1JBkEWCi
llj=I49<CgSBqR5K?DO]WYd><\5[WU9e6:EYVJXNMY3Fl@I>oI=iH\::11Ehq`ON
3^NDb^nZ5KNonae`aHM4:mo8e?7]2Z;PS4`_R]Oc^=:Z>=8WWTK[TM1Y=0Y3ea?[
pWeY^gh;UC0]93F;];jEckAIQERcjI>4KWSCWFj3<_P1F@9aao<QSHL:f4H_ZCH?
78BdpRKTITh42_a7PVHUR57387VcIT^Za1a`fSi>^e;am`\noDF;^AMQ4jgO>[]H
h]EEEP]cqiLg]VSAEL14WFUE5QSb^@4oVhGFHh7PTQ7ENaN2pcR85i7lfX?UXSb_
b8nEd]IFJYbF=f<A<CCn?<[:T2I=Y4]=T3^fC]5oS7Y37a=9WhACp:9_[3hnj`d9
32]JkdHmVG>LfCP7YU]ZUL9gdF3h\ZieHJHgZGRbT1XP7EhLanf2qZ06hL3Xk_63
ZG=aQ^bZ?Ij;\MPM<O93U34i>JdF:Dcpk\LRBeMC1lZ>Vl0G<f9SUEnm`=0ST^:n
?O;7joTpk3C^Li;RGMlVEA9IZQk:IOSX15`CqV56ign[IcOgG99Fh=Rh8UXDP`\j
@78f1UE]D^=G`;S?kJM<4^aQjQ4M]OQp[H2UTV^_1V1GOW]CEd:fd3C8Z:][HAFC
@V35\Bj<`Q\aJZJoLFn5C2X0p0^i4T\DHeigL>EYG\0fL<Sh;K@IRlFLLX:AJA_7
BcQZODaAf8ZAPEJX3GNdkm6q85`3oYbmj3\9d5N5<:FONjDR9JiOC\i^gEc\c5T0
Og[m0ahVY[XceHdap2`9I7fO=c7nU:j8g^XD7UZJfJDTZVJ3fFTi>@M30S3i`?Mf
YPEleno_j\BZ@mj0qY;>NV[<XPoQC7HmdRQJ^H=1kUK2k>eGVZ3X1M0PfGN><Sjd
jO^L5PhURU@fD\]aB1Cp5=E72<nN4aAeH:9K`6Ci7BCg<>JWSi`UWSnd\FLU628j
QKL^nBH1lf=bSBZZE`2``FBq5M\Pja<D7C[Hg1BBN@5a9e?UJTC@ZmqYPR>?G6g9
jB1<YFRef52kM?OXiM:^b\XjJU3EeHYNkqC>84Ykea\QRbad7LoVN<YLaV<oN0Mg
Ah\9HqREnb:U__iEG@oL8b>]p5cd`o5D^QLSNcEgceC`13YEbn4V<LiY3CNq\5Bk
lG[S7^LX6HLaZQeZeJfjQV4Z:>dKoYF9cg7qRY;K:50Z\`o@mlY\W^]XKLn;VE^8
Z5FSjSq0AKhH;gPZCQBe1`2\BQ1O[S0]N3I>lS@eagK`ehqm1fi`@:ebmHUQl4aZ
cg:<D^N6jkZi@49B0Mq1W7SGS?3kgnR[]?[U@6qUQ`4Xm^Mh@;0T63EP7]belTWq
4N]KGfV0\EabhL3RjE9[X]1Y5=34>_@4JjT4e3[Kg>hdJE26S7XK^6EcDRp1=P?>
?_NA57f<3A]]@2^YE?:?37ZAejRTJ\N5e?P5]0ghj8TI^NF[Jo?OaV=EUL0>;=GH
WqgoG5i`q7eiGSh?an32C^D;k_94_J[YjaYlp3LVcEXqYbGb\iYZ:EA0_9a??QRf
lGI2nGK2kIK3RlqTE8l6XRKhMoNJ3W37Z:>lKifQ_nqBob?D8p\oC`RE`7AA7Q^]
SJFW7P8Maf6`mb0ng0E8m6[==Jq[7fGIg^B[W2Pa<`>kGIj>K2kn_06[jIIFBi4[
5??>0MdZOk@e1iX:J=KqB9foF<pJZ<g9c[S\2`OR59:LioGLekF=Y]PiB;B<Y@pT
0GJLepVAoXGeCFSf<<22`RQVCVSi<`\V6F:UgC4L[qeBJC6:q@f^8QfIcOkD=Mb<
hYX`QE0BW;ghVhLlMN9YfgVqX:l[0PqcC@n4f=^LjJc:8<bK<]d0;Oep0bbeEhp`
Pk\hi3J_eD@a9dF>a97@LfN=IW5^599`cb@Ml^?96j6JlCRZ\5QZLJ`3imYf4A37
a352:6pV?kHRhYMOU>Ph]b^bNE?dk<J`0mp?gDELapOjWLKHEVCgKI9Q\X4P8;]k
TU^oeNFlahqm\0Qe^p:o]=@fgTC?`ZW8Een5\Gk]jH^dC^CPfT?9p4OJ33lQG;`O
o?S2FR86:bZ2536gqCV`[H0q\jmW0cj49QZ>YLV5=UGHSVahSD@0J?[^eW5qJh0@
fop[ibUVLfCC\DUHWQJ7f7\WMkLbdHb;b@=;83pg8Jo6^p7\`kMW\dHi[W11k]eM
Ga@@08U=`P\LnJqYREb0_ScM63]bXOmKMQl25SJT4JE:[@<cf76ZoE8=j825?8f5
jnfFlg5iO>7SDJW<\JqOM>mHmq?J?gU]X]X:U\YiNY4FM3?Z<1T6gMdQqo6igZmp
K9m5eag=?Tcf=eY;pP`<?WMgE@C6^O6Un>^82=ohaOe33ompMUjP=@qD2_?b=nb5
lnoPjNGLN93dTY6\Ngn7]A[Ya9qUP][Odp1Zk<T?<i?]7Rb28cmmF`?EkajJ>GX2
5RC\2g]kg[<eQp8d;HSnq`EAG;^APneFM9FX11f0JTinIU\fOMhHa<2[fNZiZ0@;
pgQ^K^;]^5\QVFkfFYV:HAYIX]2k?_BNAc7_BhVj@3FeD]mp8D[K:WqQ<A3OV_k9
XbMSGBY?kU_Ml:ShNOM5XXc:d:4@9qZ9b0VUpD2bNH3>kZcDU6KZF0gP8]AIeeW\
TAB?ScVpcJWahII3h20o8TDObT<;?B4Ymk1X@TmTDP`^lWeVe^6[FeJ0G^FDePl>
61fd1njgQCWYW]8D6a6dhefcI>LZH_QC0HOjFCLh7_60EA[Kn^a74XpaOQ?UBWMR
74`U=A:W^;A]X3W\G[8lU;G>g]=O\EBf>iBX1q1Gg:RKqmOUM=K3e2DkKlnD8dnC
]^?bl?Gmpe0PV\1p_aLM4SBH8;M^[^2AfZ5H]TFMBIbp^QNV4Cpn>OdOckZ<RQKd
N0Pb]f`HT^`7AS5;TE88`J\`ApDn1iDoqXPMJ]n:YVK8GhY0Z4FoZcY`nG0Pdo_L
LDMP7]h]2Y:XqjX=nKlK8k[7gAkGNa3d^BejJ2:TUKX``nA81NU2^NLJGF\;LAIN
<?PU]>A[qiGV_\0pg[@>QNEA=>FXoC\L7ZOd19n@U;S9e9gXp<bJ_XjpW;W1d8X[
No\<XZ=\]dUn^c>XfOJO^Tj2RE=OWE1_fhQ6qoi8L9d4\EYPaP^l:n=aBk9_N_FU
KC`qUOY?Z^q=d9mDY5hHKnE@011gMleJSk;ePlU:JWjLTXpWcAi_dpRWUZ4ROY;_
g7A@nE=]^<<a5ZSneQE9Fia1fWA0_GdW@pd?<4c8pK=`WAgN`d@`b;?02XD>4d]e
EhCgZT:Ca<`DR7b9=gMUpS>YO`Cp^g5bm^_k`cfg]PDV=4DBl;K=o4I;;nJR;Vb=
kd\o5Tb`][JL>a8<onIC3<A0p0QIfeC7R55iX2X>`P0_2gJQoI_i6_EKW3Pm1:Cp
=H=ne7p3iL>FSNlJ8>=o;eH=[\n`9@\0`g4D\BOp=hK2RlkZSK5n\EmSA=FUP44i
dWKSQ8cg7;63Lg5m3S4V^SbjNiU_SO87_EYFXFZN3I?2Qcipi8kk2>pTk\UZIU89
]KC0_=80EjfC2G_0DO;@]^[mZ^JT1q41;92nq<;fNjYg[SJPjM]?7bX??:@d`\Lf
mJi<?HMlk9;c4b39o]Zi<UOCpjfP>IhpTYCVL@SoX14nWd8M`d5<bM@ZAT1NFaai
1dGJfeU22jkNI<p1V<BH0pUBI?V`OVa5nbfnMDD5FmGSS@GFcR`R\2JQFfoBBeVd
G?17Jeb?;lNXETV]4^NocP1A1\K3Yp;VXNA2dLIH7KY?mbH@>3lM^`J8:_Tcp^In
]`Kpl?oV^S3d1FQGU6]==4ROWJj8CN7jHC@9?UOOIK5`pc6col2p`UWbb2fTOi8N
<E6SJ>Zl?VXH=UC:AAGKg?Z_AB14;i>H5:8i@n`9FaTOWLSqbj5J]U>Lne_n51Re
Y_KXqFPX;L^pOW?SV?dkHdeGO44FI<Z2aZ3Zmkjoaea5V1li<LT]Y5<qH^=IV8qQ
NdSQ1Hn@jBCTUS::WHYd=oORiUH;9H17b3Y0d`8m76qXYBkP1q3W^5_cT_@=^j0i
llgOBF7[YZMO5FBj0><gDWM]X3;a6ph:Xicm<fK3ZKFH0Z3bkiChp<aDn`CpK55R
X=5WHH=>mKJJaO_ISAY@NPS45TSAo6RI?9o5[@R74G]CqL[0m3kpo\RLOjl45`OO
Ml^^\ClKFK[eA:S2C?SAZ<Z<Q:a`NNk^WX2bpZ3`7eJq_bIfChOOXCFSaLE[4VK>
]6KhSJgOV_c>@m1?e]q2L4?nG@?=hV;[iIA=?iEd69?_EaS_1diTdADUh<Z4UJN7
\YcQ0b:ODe_?1fGa\CM]O1pOnA2F>pYeQ0hnilZYB[k@4o?3feMEnToMS:NihfD4
A=W3bRZMX?QcADDYmpGG=hVNp@OLk6LQN]`o4NWN]S@S6J30lc8jFD<;e1]\71i4
eSG5Q0cGeUaCe?27:V@WJl2>LMe]pDSfRNEpjLhBDOSMDKE7akBR\h=N^6AhNFJj
c6ALea]M\Kn<:3CbfdVbocS9^dH9S61H_O2lBg9k@Sq3X^Z<<Ln0iPMdbLejF^?a
6HCllDpLUTPUaph118aXH1aCW`YKcOnC0fC?NofWb][aJXHR6D?8DWBGBR1^N]ZY
W=LTOd[?>>b2pCk0F;=qT7=^LK<;Q^4Vjb5S[B?T2Dhm<dbTbQ<g`hZgJ51_fCI[
d8VW@9e`e3B[kU9;@mqBe:b9LpVg6aVDhKnon9Q[24O6HRZWoNHN^h4W:KPI;JO`
[PhMLaW2U^A?]Y]S>TReSLn=qI3DHSlpeE;W3XE@AdEIa2a2fJ<77jmKUP2hNc]c
aEn7b?<kfiA6EARD7018qAnSnd7?do5:o12mQXR8a=??O>49`aKT2:bYmeEGRT<S
]F6RI2HQQK\8^_blJn>5D6dJcQ5T40S1pP\oZBCq3oGQD2<D:=`R@2gcl^MFVC0^
h`64>91TfeX6^5dWg8nO6>GA49f[374Ul7lJ67>0ZGh7O9qn0cWF7p]dNZVBTaB6
BPE[jW1Cm]JNMO3l>0ZP613kH\_6\no7bgSb^e=dfQQW6]>TD2kkp;g2WP5phQmP
UYS\]fCkOm8BECmLBDEGnL9jW@?9S]l\f@[HjRdFWbmYEW>qI3k?GgpUWHc81^`j
c@\UAGLW16VC<ID^24?YQm=:2:\5`mfVL^:LB?FFV81F>\nq=GFESSeC3Z[<]?8\
LN=@URVLFJVN5[6q\InCnEpUH<;l9bCS_6o<l0;^;34<]d65G;ZVIifUT\?f\Q20
[l7f6O08U[1eEf>p_:Ggh6qQl@dlkL01T0=fCM1Q6Nle]KXWV4A^HGYe^gfDHYMX
0gj9CUNlHD7i2GXa<UXBE@ip]do5H]p0WnYiOIi4Ll>\;JS>Ne6@`AAFXVBOiL=c
WFmKLhWU`9MNRUbJRADH0q_U5cngqQHM=^BEDaZA3acV]T8TP3THbQV=7J0HDBm5
Wc0OVglk9l31O@OeOW]NR;e2HYS^e9g3EYJXVqd3;2cGq6dV:o4FOAiD0:A3ldN9
VRfa\`\ZOpWSE_>QBC9HY8nEfleG3Xk\`J22FJ3eURCfd<d>G5qW5aS\lq``]FNH
QAaVf5i[3Dc9JSMgXo<`kK2ROV8OC?jWFMh3;1Ohq3ofX?9qh1:1bkM1?GGo>HlX
8e<DY`UKScMPc^1[0Pq=R09mccPn[aX3GTfO>7EfZU0EKKHL6NVdCATaNa>XDSoc
4q\LdaODqS`TelT::73]cRNo3c@?[om67_G;[@=eZ]UJf<Y<B<NiK`\?O5B>m>Cp
WofjJ2q4C?R3cGCUHTh?Z2[VYR=AQUNMg=P@VLCkSRAVgI]\hgpalIbb<qcMSad@
=hI48m05T;^B8jVML1i3Ih<S4;9gK4\oUbUU=X1FRE?O62;N`59_>T=6pglH@ILc
kJZ@knIYAW\Cp8aR<LapD<kW6S5oFb>WQBXQ<>g9ghH99;<K:Qg0m3YY\K3@ID15
8m6c?AWTXnehG5BqmK`I5Vp<ljO1n_\_:4U;5nSjFNG5T9AQTPAl7l[kk;9A1``G
mF:54h5Y3iO?o@]e?[p<PPB9Kp3cdEZnWmoi9792I]fhYLMG];\92PkfbQ9U:O;h
8]kBHJXmMMaYI4_ikD0]BpcUQfLRq9MZRHQ_7>B@\D=9Hg;]FY]0PPOm03`Q:VXc
RcFZV^Ff7O_gW`6XPFol24IeqKGQe\bcXhYE\0NJ3?JQm[A6MqVdRhnOq5]87:WI
j59FSiPgNiC\R:@@i^4HG9G3MGIG@5>S[9;]ak8n1e?KaD<iHL:]D8D9>oT_pfnk
bnlph^nVi4CU3454BFhWiEYY8L[N=[84=mi1g@F3fY3T;1Z<R6>CAESfkS;9KS[P
G3oZN8NqlYF\KYphk^mfB0n2_S1>o>od^IHRC:^Ui32>^8ED0MQZb`h9nJf@^noB
4LYGWZ^QBO[RAO`ZI:pO@JVZKSBM:AkcF66:^@]c8];p:j0R\lp1Te\_?[Z7iJc3
K3>1GZZOQ7BF9`QRJPoib80;c=i<8:;PSb:TAQ5`A`h3YR>@[EI07PpbV0:_Up6H
6P7U`QOFEUE=hT\>5GH[bRTFjIf>H]<GlCbDoOO676Ed9651cR]@Ved^l6M[04_4
<p1VOcniq?4m_S>8`RA?ZIGVD:n=A^5B7A>cP`1kdVbATcK]g59DaTGm2DkQfa^I
=9SO_Z>d\lKhpGZ?61UC:jBKdbaQg_NqbN@9=_qW_E<Kl]G1QJTfVTXKeBg5:bY1
2no[Nn;IoJNfEIP?KoF?Sf:32J`6[@\iELRME]iC?Qp=>ooDjqa?SVAe^:eB^Jn9
`N7kZB?TCSWcTA<5=:o1<kRZbQSe8gg?G_[fkd\KH1g2@cf`o45LXpHZf7:Rpec?
<gXY:9^CbYm@WlH@<Ukmp8]:<1YJYZDm6_?`OMJbS8^o^Fe@1S:ZofXFK1cJ;_5g
ML\1ZRd:4REIgVM8Z_lBPZ3>p=PnYQDqI>MGZoH=;LYPc@WAo]dS>2X03U5ek\Ye
lJTNKHkZML0;cU@YaJk>>BZ4UXA0>ck8FIPpT3OK@>p;oicaoiWJW[VWLQ?TWHff
e7W5Kd1nR7gQm170jc18EX:YVUmW;5CG\e^=DN788Mnnfn;G>qN15`D8pm]0nGFN
V:mOTJUSdfcdaAmXXi;Q05Z=h9\[h_6CDJc8I`8;f8bB<?Z@3iH8JmFnPF69R2Kq
e@XHU1ph;;e>A85F@e4Y6[4g8L;7>Q0GGgXq?l1[l6?NTBo@Ife`5_oM\`UOG@n7
?YZlUe:YC6@IieIV0<mY>B[`6^O1Q4C;IO;1e\42MDq8bjU>Cq`nC]VLjA?0P0?`
a2ZcJ=cDCTNGVJg?FlCGW^CeceRP>8XS`GIC?Yc3ooZn?IkC?YcMOKVJp7aQ6Ehq
I9?_Qh60fWSoZa:dO0U5U?;fbbCMn7Oeo3?P=W8D1QQ2;I^f;ZHamnNbb6Tc^h1Q
bPTLUiqYMF_ZYp7HeWbEU^oFMQN@a^<[F8B^MXQGFE^IdRo>QBQE:@Z[AEOCBFDo
<A2JYIlcR3<>I;UIajY^pcDXcnQpM8\W9G`VmlDQ?XSe_SJRJn_oFoaH`B6<BXa=
AKbS@JWE_E]NVAe6ah;nCf:`3VmTZhmGMIqS=IF>@Bg:G=eo1@PfCZSa7Z454]7@
lJ^No1W[FXDFi^_A7`=dWPpc8H>Oaql0=j8bf4ENCJceMo4Z42SL<;`:V901SlWY
U]BgDUlMk96_UH@FCP>RDGFZhE0J7b[dcR[dqi=`o8Lp2<K3FLYohF1MK@[e@oea
X<`849oC37D_JeXjca?AZD;VV>_d=GD271536I44[K\@\G:05?pGHm?6Qq7obnO`
:0i;@S0WTX0VWhO4M1eCH^WQV?[]Gp`OE4aSAAfEC:W=Ob@d8EWb<3Z44\_=GFN`
S6GeL1UZ`l6iilalc7dSDZA@gIPlEnR7L4lUpSJSFIDp1@>>b>Tain7^2[5h?JEY
KKZJZhl]>`TfaUBlV\LW1V<QC[i@MedLdeDj\cf<nodAl9a?fCpJgj^H^pGg^<AN
JGHX75f:QSUSbi5dHh_D_NWK65BMXk:83AK>JAgDOYRkp\DWl;Ii3LWe9h0<icAn
gADX685CP[RXinB8ndjeY>WA<nQ:7gfK9i4S[43n0:^6ogKG3bEpbh?Pb9qI>H^?
87Y;fkoe6J^ik>aW:4JaQ?;9?QSR]>n7QlR:f1GAGQX:Q\<n2f6Omf6GAO=:H<3j
6q;H@jH\pW[XfTb7GiS_\6A]UMM2??K4EaFhh6ZDQ`Z8l[^?Y\l;BbJZXTf\AdVG
a^43DPRCmJbL\B4p5`bONEqOc]o^5gj\b>Bj1n]IC8Ih=A<f6f;^GY<iEkAkoQ3T
f5HW_Q79A;6k<i_GgNV9_R?X=1`YSpRgQ0dM<7`^_T`MmiLjUUgNn1dK?F\jckgK
J[mHVSaSKQ4Fb_kQ[VI6\ah=K7VBQ0_RqD7mc7>ql6?Ig4djAOLFf[XNBfB?87E3
ba^21hRck9\DG3g9A>;^oBlS6Gg:@0@7?0VP0\Vk2P@>G`qY1VEgTq4>ZhU2UOU?
He=Ij_?<<COYF6;TH4Aa>MYhkQb\m\QNU@WoTcO7NRlLVQS>f`Lnf[`EHUJ`qg<4
?O@^`lTboC@H]MXOd`R=RIl=FFUZ\YOOEI3IQk<9=ZNXD^RCV912Iqbc5^o1pZRh
XHJYW>VL4:NcO?I`>jHmBIjUGPT20R6^Q<F[`Qabl6ek9WmcS1312UbnLnM9b]ka
W>hqV6L^^6q5V4P:N]YfmQ9Cf88ETVSg1m<70^1cQ1S3cORXd9:4@ABX?\PR2D_4
?A_5^F7PmAa2eniIapXUO?RUpo1FI=hQHUj?\@f=9@;mJ:ZMm1Pk]VCbLkRZ_E4J
WC4U89TYlS^mh_<eh:9U<a1L]4G[`CTqkd:VBSq3Ibgj@6S`[[liN=E=GSnClRAa
A6=1<p3A<5jnmS^978ehfl=XAlGc5BNen<lW6UGHfC4XiIiS8j>1\?CRCnPDK\Sb
]oh=WO`cPG7bpi8]n_KpNCdDGo_lM:e[WgX\hQ<1>CQh>Nli=WLn_[6k<d8eLN]:
`@\fU:4oI2XhcV^JHLceYk:dUaqLPhHB2pE]5@JW[:YF^mULQSg0jI<hGc7YqZaH
F[Ygm]_^1ZYD3:5In@\C[eHO6Cg[4OM\gSV1k_D^bg:GlNcioRnQV4OP[f6pE7mX
\]p_:D3;nfVnZon:?`_Ec<DSl]D3ZmWZSAkPLHkD]=0FI`[h@T:oKcp44TWRWUd:
6W48b8JYJT5hUS`UA;gnT8:CB@qi_fInOp565OX\E0H_Hb[^ZK=3_[L`Y_0gIR5Y
B4nQU@YY@`VSif\n_<d4[C5a;kec:h]eSUIM?og1qCZBg?Op`E:R3nMCXQF@^;UG
4e5CUYDT0AeX4iicG<HBhWS^;TEc\_OY@\_9^SUf;0hq:j90PhVYE6>\mfY19g7=
2BS94ja_b>TnOEU\8nBo]E=V^I?@Tob;29C^mgK7[MTiMUH>DG]Rqc<[hnkp^b?P
3Y4[Pi:kHIEifeOc^;I4OURVagGIe]D4o:c?>k9]<mg5ah0K@Zn`;3[\N]5dM2<Q
?_8F2`dJ49qgNTg]Cq\m?7Bi@kLW5GH;FKN0C42NaWMf2RI4L:_^5`mEi[ck0DHo
aJhYWYQ4aWO86W_j@OoRNe8O`O2?L5IVqY<Z5A1pAgd^38R9:6=;P3g]md\YQcm8
WL04DOEnB7EEA1HFLlTfFlf?nQ@kYZ3o<`cA\kZjo_@lQJ>C8D_\fop8GZ[So=A8
\ig7^hXV?:O=148R__[kj<ibm>la3T0RI^CbZgimT8HG6QG2EDaJ8S2Uo1BAnqC_
OlDjp6[@TB=W:V2ILQ`M?RR;Y>3_I4F`Ng^dg2X9WPJ]WkdA>nYU[j@E=aKoPm_?
YC434CB7IHFdT>l5L9Dc\pdm:SUap7nSaJ4PY^U>^k1?\eojM=KJB[LOQ`HjnUJ;
46@\KhI5]1ae0O76OpETXGHlh[h8DFKS;BG2Jm_[Ri6EBZTQGUQTb0>B\`LTa:b^
;Ef\Q@>eVXG]Io^[49VUjKAk@>p0hBC\Mp^?d?G49JN`Ri4PBT6e<a=\4<T]=dF>
c1fBFTc_ihd`7kQJSBX`nKI5?Qjmj4Ief@g6m2;Q0Nq[m<LOdp4UD>fXAlmAPIEG
N[D0XPnokK0Zd7]^gaG^naJUamc0WUIFiQ\ZASoFlNWca^a@eelMU6CYXipFO8Yi
Cq00O2\;bEK[<SE>3<:^ACB[^R7:HQCeFXG2?FbiC0Yl_>Y]X;DnZloPjYB8EEa3
I:KHZ3^TGQpNBFke7qE3M[=Ya@PiCI4nUaKB>XO:SV>4Tg\SAicf?BcXc=6bO@9B
q=FZlm@`n9A4IV5=iT\;dLSLLJb]QiTn6lk_[4BEgFAJ>[P0dfP4Y@K5BMoR:emO
V@GY`gRd?p4llNNiqVi__bn^;a<PQCIo1Q\T@j=]8aRfAYY_3^TSljcDSHl8SN4o
1Z>8263ePW\jnoWFH;h\BU2fjaRH7TIZEgO9N^hnGqo50]ihpLYWWKn5079_IjSG
1SMgL;[X^LGcK4\0llL;:]C<RN9glkN[G2W01De>^^hiKb6YTpe?`3;2p`57iC:4
hMl\3m^Q0XFTaGj1oc7]B9a\VcQJf6X`:UVTeOZEUARXRa`GkqQdfYjDqWJ>;o`1
:m:^9eUH<n5CV]4n<e:hHgL5@TDH8nIRj89TBjSSQEDM5kYLoq4b@mMWQ3OO:@bi
2a2dn_2joaAOA3YTin]JNMq8=cDfGpffRdlMno>ES`6mKC]mI7XZ8>@QPcHDD^f4
aM7TM>OEP6\mFQAU0R?>ehp0JLB7Xp8_IlE@K_??k<a7V3fNRe3G@CVJ3R]C6;hH
YjQJaXFX<JhaCXchB:gP`>q9YaNE8qCdPB[L]ZKHU\B4`5>gQ;`VD541c=dmBnZH
5o8G`F3=aKGGkjJaSI?Q`Zpn<DdOh5A^HkW<Pc;_j29o[W^iGoHWO9;<9ag1DJ8:
c3lNTi6Mo2JdJmdO5^B=XAE8YM=S]6Cq@7`CeJqkiEbh5TJ>W\j9QBV@?@eAD?mJ
NaOk\h;XY@JA88kRI_I6U[KSJSNGegXqBhgRa<q9]VehF`k:3;Picnm2a:E_d`Zk
R8TOJJ1XXko6Id\NQf1=8YnJT]AO?@lqcobQa<pQel`2FjQWILN<>[eIC9>W`dYT
Lnh`?8\NQZ?7L;=T^0lTVjYPeeUgMRepMAm=hEpb\oG8Q:fVeM49mWjDl[@Gdd2_
GKY_<`2djMGGHN9=k\U_c_2[a8p9lM88KqP2lUDl>`_VBKROo8V0d9nF2Ve360L2
\nL=Qe[ODFm<CjqHP`NERO>D;Vgld^S23O<jOOPL\lB3EeB^5Nok`L=1MY[53pkn
GTV4qk0GE^667nmg68lB;KgU@A1gA<TLMFm^aWZljGf1_7]Q5mVcBU:>p`9aV\[>
C5_8>Me[RA[BGhihcVn=TU;EcBXp^FIU4OpHaD;78`GfAQ<O8oFQk@Phb8L1nI=\
`=aO8H2e2G6DMlKdKb>1efEJBpof=mcGqiVMMPJclD`bk;<jTHR2Q\9NaS=d_2_1
g1P[G4WndHMAEf@mN1R20\IkUOcLc?nZ1JcL4jOpFR<AXlp`PK<P_]cai>C4YUYC
aS>J=00MCG:ghZJ[k]lCnYPJFBf2FDfMiaqLUHCVjQ2n_oQ6FX8FSVDDa^g8C0nI
HkI@O^Yj]I^SkWPfE:cT8257D<MESVl<gH>Lmp[720\Dq8I8Ioc6okVJNjXi]@75
V4SUXlgkHG18\ak@_K:YH5AIZHSF6W11[kF[ic?gH;@kBBG4=MZ04<l\9Q;pdc7>
mmpYM@L=dm8fKV]S?nG@a3O@fGVW;GnVCL\dYDDej>YUh6A3LmncBG<V<5LT8=1k
>pFRPN:`qS0V\fTf=JNf0Q9;jHde4cDkgINV95>PmXh\Oc:\]=>9m7o8hU^@GB^6
R<Bg2`Q@fp6\eO3E<@KHUE0Gq=QDV`TqH9cHQ]W];[BFZKE\@IBI=5A5SJkGI[A=
kOPW7<ILmcl2c_]OQL[GmIN^eDbN1oTAqeS1=KVpdD]I55<`JNKkOc0l^gU93i@]
>fP7i8Bk1NJX`Mn\4kV5[`>M8L\WX38N4Z0Ag2qOYN[IApo2[gF=_Di6>5ZQP=Jl
7^a_P=fMbkG[=1i@Y`AdHD43@0e8cGP_3noa?jW^;hjop7ZC@60qBk:DGLDRk]`1
2N`bOW5d^D>?8UiEG3ZYH:P=glK;INj7dYGVqGFlCi`p[m08AhN4o1k:mK`3f2]n
ALmJ4OS4cc2E6<qA>5S>807HGhU1[ejeol<__W;F:QWE<njeE`Qf\Q`VTGI@REKW
>icOP?5kdGM9f\6qNkm`]dqJ=dJi[]TXja;5JL@CZj1J]c8GTbN\accnIQXLUAe]
^neA5PUaDn]N5gJXVQH@Ybadh1YhIp`F4nh7pN3EMT0K;<G>V0oj]H5YmkQD>68<
PabGgal\<>\6dKO=bRl?]\<Y]FOaDl`UC:2V1kE2=So[=poIHm]^qKmiF@V7_cWV
Hkha9gIPnqZERC:ID@R74HBiT\8jAn;B^I_NYYWP`;8el`\[ckG?XF9DGk>mJOn>
qcSJ7SiqdES^7^A8dJc17MCTTPdIliAGnZ]bZ0l1Jc8D>Ji:gR1f:RQhqibBEZ]p
m1k;BSBREB66FA<W`9Z76P`D8MhkXaUk842ZnRZ5L^_n`O5oqdE\4mNp?kMR72E8
eh:YQ4kDWh`XWY=Y5H:fhDO?Sk3RUlpUG>8X[q47b;NYnDkJR4i@n_GR8_U60Apf
ol^FmHf14HBThSA3KMhJh<Dg5P;XRnEMOKd77jYpMMDd8KpS]_OZYlhCV4fA]D`U
XYb3>>5LgT;8VO7MP5LB6qMa3;V@pV^@3hfB@TncVM5oCAiH<NK?Q776k>\@[0oQ
KEaoRJc9RKUPgA:IaGomILi7mSIFE4J35GIOWZ:P=MmRB@:]g1>q06Qm0cqKeXQe
LkPbRF:eH789cPgn2;jI1D27:lOGIR_D;AP>W7>OdC\AVNX5W3[eAPoNAKV6T4L?
mLE?hkpIZWggHqo=eMEcCAcU=;[=ROm?>\pB8>4E691AagO560E5]X]VNGFQMMQ6
Za@3CTi=0oO<Sk];RBXPZ]>H\<YQbZlnaAeY7k;3JVoeJ\qd;NP77q:4Q_N;N]QE
58^g<<3m6X>EH>`3?\XhQ@APSNVK6<:H7H0MH[b_A\boiSpkO;IJ9qRTAM;EI8^5
]<D^;1BGIF?^7:AQUKg<ChE;6YCHgOMQ6Y3JDd<D3:=7e3Sh1?fSMaqKN]i>SbFZ
BJIXEU9]iFfXeA;I79I0@gDlIDX3>`0QcSa?HfGljk1<l;=<[\IB00p`d<?9QHd\
55SNY6[Gd5AaR>M5lZ92>cbAlZKL7Gk2>$
`endprotected
endmodule // module vusb_hs_up_int_bvci

