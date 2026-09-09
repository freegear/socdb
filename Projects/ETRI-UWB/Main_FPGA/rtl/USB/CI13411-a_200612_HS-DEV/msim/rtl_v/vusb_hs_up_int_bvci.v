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

    MTI!#Klua5m+_pBQuBARxE'CO]{T,Q$HJ1?55=~Qo\h"PE,oOVz=>2I+s~ji^l~+?s?X}kolKOsn
    ?iz*QWD>zwnKBR"|,izA[Ju[B+!aHEkX}1K_W7wxl3TnHUTE#7~Qr2=j*@YI3zO\K,p[M\;B$;I1
    I76JEo[Zj5u[;DakEXKQaK<v}',e!I1#7x'B{I3E_rQuE3^r<xOBKRii7@_[;3QQkX!!Rrr/*#C;
    7#1EaAXZ\5WnGV\HzY1JElHZ>V+<C;J]VwJA!=$Y_=VA2Rx@P?h>1kC,nam#lOua,~j[mvn<VAvU
    }-A/pC#_9X{]xeBKYJ'nlo=v\#_v{'=#wZo-}wzz+VkLpR15^i[*]OC$EX,u$?3*w[R*C3{Y<^Yk
    Q^>To\<J8*Qk*\K{Tf{_r?$GjZkjUIR7lJT*mxcaEvI8=NtTTK]1Bowv[oCRHo}*IeR3T>zfWwu3
    ovm5T8qV2VJOA7u;lulrU5ZI7Dw;,V<CQ!VDUzAzJZne]-7{-jW2w3k5uEYZ<@#D3w@l5naLroT1
    4eEnxx{Y[m'mspskWT+!{E2}onD<A7DC-3{*K1?7{%VH>T^^w[,,U'aHn-BrvK6=Zs2\uo*,!xjR
    E*jIpZp-x8~<+RB}>B+p}}$<nO),<@Iy3,jv^J@U5a[C}Twk}vxvY>*Y4:E?lBslQ3P+RR\}e>ro
    DnB;-OmxQ]s_a^2ia@#1H11\Vo^REDm,Ds#=~>Iz$$EZCi>j_kxiX3+7k-_r33]<^[wOZx~V;~zT
    }QrRraX,5l?ywYY3;v#!\@)IW=VDp)'E1C;[l#BvTj*3K=wHR't#+,}WrG{kB5X#O?ZUE3K\jB5x
    r1_eJQ3m}Hk*D7^]TC<ij!;6}*vUl2Ko=JVri]OO~rBk}K~IGB~R=GonvfG?{=s[szOW\l@A'XKa
    {W[#2#nB;{v~;k*]+~Cn,B7HH2Ekx\@o~Bk-81GwV^ZUU+1?C=GC[seQK@U[=S+,'RV7D~Za$>!5
    J1kTnr\j#B--7R!_Y1]D@unEU'&|sC=m@x!7=UwJ+[T}}{KE[[ZW,[uoH{V$fxZe,oC<s-aAXA$H
    sJz}TI>I,!<7Q)pa@=0>n]_f7T@;u=?Bl^3R=!z5O^-'dRw~n-^^Ov&sG~Caso7U,Vn$~'lmvkWK
    1@[kQlJ,^ZkQ2~!aV+s+V>Q5+3[sZ;H5s@!D!J3Bk@~Oa!vTRpAlBG[w$l=v5Q<Rm@EDYB=i\2BY
    ZWIIp,z5AC{Tj$J]R!<b*RD<}zV25@'ZQGz,WXB!E\X~5gx@zCj+[^o5>5x#KX+A~KOT_>M}@Ju5
    I#V7n>#4^xRGD_v$1}'^5oV;3A2^sw*H]v^Zm7JExhx,1~R}vznCR^=Sl@jO-ABYG|p+^DI!RY6[
    e$>n7~^I+=x'jZ;LWCo5a-I$aj<1N.mR^]}@!<RWQrxiT#K_QaUE/j$#?N?Ci;*QD\DQkm,~aw$#
    B?7unYfGm=CiEeX={U>aQ<H$+*<9k$52m[xv7T]YC@p{^3ne]XHm]GCJI!]^x@XWS>*52#IYU4^K
    zK]sHTX5z~?*3aB'5K?wK?Q^]\AXTom<FTD+\]3<^^?Qe<7<<,;3-[-DrO?T+Qmpexl[2-|Up*3z
    ~lv{G5ZE}J*3Y};_k!wee7xoR$GTR-K7U{KABE_\zv'euAvv,?'K17nl+2Ko-\ZrOAunOsEM@^Y@
    #$QQ'eVUZU@wv[p[v[ujuo]n^^!U'Q}VY#wOER,;JvarD_?~lls!Y;-,Ke!volYW![}_#zE#RVJ[
    +7C]@^YkfGHwRv;lH+DA@lxD;O*=nxDnj^?Rp;=}o5}{~I#I,Ve!=AH;'Y^CIQIk,Yz1#;^']!<o
    IY$vHUllaB7ouDj>X5i4SYJ3u;>=}W>Zx8"pQa,!T$]\#X*^wBXNCxm<4l=k_+h.jla{m<^OJEGI
    Z$+#<<x#|NWGxHv!XJ]xCexmBR+wHE!'+Gxav!m=-lmD-JluvvLH',l3G!GXYA+Q#K~a{]Xgi|Ba
    IZs[-VW^r<jQeEkz^o4l>2oou\ajNJ{AOR<uXVKom1-K~b{+_Wfpsi-BJ+ws-\_j]}zYOzpD?7s2
    AnB,Bk{+zXJGxUI&z{$m\-C,BV?]p!H=$Kj1@1\;uj}3x*1T\cCjQ]BwG-l@jK!^Wn+'A{-Eo-x[
    BEC}7Zor@'qVa+!CaQa'I[D0WY\^{^wwE[1pQ!J<kov2((Rz,-#BoBhEKrr{_$<Tew;@=o;qz@z?
    Q5_Q7Q+vBKV*QZRWaQYn.<IvK)Qr?Bos$TaTwukpxEpD;XA$pHo7DHuI;K:[IB]*QEEKj\nRl]}h
    Z1[rBeH]xNL'sEW,#}~h+Rl*~^}_Ez,'#5-3QI}w>T@JDo>lBU\Xc;+<IJ7E$;w+CvJ@2|UIw<Xl
    31?x~G31-ZQX3r:pN]Q?~I2x@'xYTtu7<_!R\Zf#[p>3jwAQ<UkTvT$I]DvouOur<UoI['\H'AeR
    joDZ_\TG4T'z7z*<#x3E!$D55TvB}OBCowwE!#x<oUU~j~IZRxyQljX+A+*6^reUGpG=>x{!!{{j
    ^.YlZ<E}@-sras'<7+vmZD{vA-o!jr${^7z*mrIk\{YEA<5^eH=keKk-{!ODnH9Y]Zx=lE-I13o\
    DwsCGlsep>w*Be5?\2+C[u<3zklB;_}RYz+-11ZpRz,exCE,sR+a]zI@=>3e3{;~wrj]1<wyT,l-
    >D5{3CAOFalXVxV+^#eWeei!@r_~B\Yi'G{V'=8l2$uv7-V_Z]?r7Xp}}K1<77o,;ZJ|lU[-~ov\
    !>+eQTj+q[z-k;]]lDxQ#~>;^y+p$@{a1J^5vO{O{{}6z22EGQA-Y+II;e*7lwn~#YKZvIzp,}rR
    [~~[L~}x?77U~lwnn~p\R[GZ>^YOsk7TsDlQEC}_m5[>CIWzOs7$77},npDeiV^RZEUpXxw53UY-
    a<{DCI1s^$Z\J9E,ZZ9<Rv@W{xaD!$2CY_m$i~Q!Ge<rO6!]xDiEKGO2+!z*vzO*-AI2RVD~IRo]
    -Y^^\YnE{WDUH1)3\]$+xr'yAA+pZY3A.]kGXEljQ6Re'z++x=oesDunz$Z^+e;eo^J>lYeX'G>r
    zzOK!unBsp{R$J%cuw5mYVE$z+aZ!O3vNjER]$7<JOlA3G<$BIB+H6s^K^al#JUI'>V3O#+1Qimj
    s]S>5+R)eZpWzE5#6b7pJ,h|1i^EAEWkr'<;qm^$#Q>jQ+Ua!PVD*Crr+ub7C}lgkV-JIWrpA+DU
    neZA]mXDq)0'}aaX7$~oI\3&emU{_TzWx;H2;8Yw@v*{a;\CO!iBnvLo-a#AH^,~hskHu5>DxIH>
    xK[eIT',zd^K7{v7o2N$GRolaBKRWn$or2xZ]R>:#RjD\ZTemIm,l@n^:l1{TEij\D7{rRoYUzB\
    $-vQi]([[R$!}pj^{$2oiWr*lGR-v5_"BXpV?xl[H*!oxVKB\\Z'i1YjQa^_=!E\=ja\yrN\}C?a
    >GEGB]ss<n#QxHU1r;J]mv*YAZs'$@$W7lzpHA#-E*H}ia7ueCG1nsKTB\iD'3v8?EDOIw3QP[>e
    W6'Z~}cJjWm?5aVDI\3C2>mp<aTLC1ITI=QkB_BI^t0ewEEK[%
`endprotected
endmodule // module vusb_hs_up_int_bvci

