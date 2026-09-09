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

    MTI!#gFoj[-l1lK=rYjED5!U^TpW'xJ-s[V]5kU'^zi5kRWO@*;z#O$D5'\YYn@HXGrAjCe"mV~@
    URn]TTE}IOrom5\IFIi1'pJ0j5,m81jax;GRlY\HR\-BTjRBY^^#Bpmjz55vUj<n3iH+_R#\>GmB
    \{l}},#e$GTBnp>**#]_jOoe}W+Blf!UVI"!,EXtp^2'B+lUxrxD=\xp*^QXuE$vKo]?o\<[E>p+
    B*v}2$Xk]3B-wAzI^k5?Zei\wj-X>X3@}3zxO{<G,2Tl4[+vY'oB#]DDZBiGi9}2='#E+B3O+3[k
    Alzw,TI$ODMCi+GTURO<^TE_01u[W#THRl'=<p[C+K5[#1irE<s'JQ^u3I3~IL.5n_aoQw73tE*p
    !xQJZmTv$Rdxkn#'r[<RT$pY^^=TO'b"7n{YYl}ai5Bn6IH<HeOU#vXH~Tr^{zrEY"^JI5DmpjJs
    $[9[uwDgxOT;u$$Rw1We2He-4s-CR=CC$A1;\@Ex=WB*^OOrklHswRA><[k'7~s7rY\n_VBB!|W[
    2o\U{WDn[oXE^\1C_pZXIo>n2QRE?,'cl{_T3v,VQuG;-$GWTaD^]5xEo@DIjIK=CxovW}zWB][A
    ?Br]v?X5wl,HNzmp*t^U$x-{CUW^k<3rZuw}pT^kWIHw+!5UB#1@<YqArrnY#evDG_2%-5Q[5Rw{
    =7iZ9V2WRlA\GG2=<2(^ZmT@V'\?O@C/{D1#U$a^GV$Jk_-J[z3AraO;YCoe>j,skeOE1AR1K>vl
    j}TspWwJ'D-;=[\v|L'JR-Hj*=zWY>uBju~5rwY?ruY+_BD3up\+{[-]E;IGR7?j5{Vj3Kr[Olv3
    xQeBakK=*x!qg2r;wj!mDv-m,s\\x'}<;1GmwC#uH]GxkCm!>aV<]Q]#GcQQXG<_=AD,;\+e=-,#
    1__^wYAT_l]uvA#UVn}XD*baA_u!1m<YiQ2^E~o|ax1\o&*,V{vks=nTu+'~}Tl~X#8IQI,,<u1B
    5=BG]k2-Axz1aVuwnx;}UaC[1}B^R{>XGnK-7upb}W1HV<xJx!--kTpGv<Q3#GVB~wjiF{O1'sH]
    l{[KR5AV3kwpYbf'<}il-*i|}m[3#UlK#}D'-1wQ.}\[o7+Q;]Jp](YH[o<{XV61s<r+{RYbH_Zs
    raH2o*eV,5=zWYpAV55o2QJ\D[Zu-$szO}u\NeB#'2=eoVH1=mCR#bQn5Eiprp$VHC9UQ]Xkt;QB
    QURp7g\vpKlsJ7BQG?Imj>AERv;7Ou\_#~=;2j}<<'q1T}?,'D5BVxoLuRX>GZu;cM.WXJY;o;C?
    7^K\AYKd^'j3BJY74D]2u7>RKIAppgOwT7'\Z2-=Z3O[@}klR}UeZ2QzlEIA{ZQ<oI]'VZ'HQ=5e
    JAx?I7~{]I!<_w@xp@$pn^RnY!Y*JBG3pwkwCl^j1+T[{x]uOY{Q}#2{nZ|BiwYC'CxeRur[3w'r
    =*'zr[;\Qr*H<<j&p'VOXe^z5=Rrue73nD\IIm}Z*,mGl7}Y$,+-ase=*]rG_{^olm3WEKe_$3BI
    __5Ri\xue[m*F,k$KFLYGijkGiRwVrX?1AoxAn2KUA72]#e}U-A^ARs(mTDoe@+X7;Y-X}'{6,g-
    *mH+VR][E>'0j5iwdHH2^{Vu3~BC,Zo1o"zv'_vmOre7l[IdH}Aw;Euj\++H58\YJI2Ellue{QpI
    mT6sVipT,]1$G1KB<p1=$G[UCz7^M5kZ{\*TlHD[EJ\A=vk]TT7Jz7W5k1Im-KEOsnp3TLV}I+z;
    uG1wAGaU1_Rw1z|w}\I>\_-\=IG+$?TWzB3s<wkX+Z[WBA<65QTlp^7IAQY#rk~m5WA]BJEe<nQs
    ~C+Ir$H-h7xk{#*,rcD2O+'An_QXe<_#eHAX1v7Y{]W+ATKz!+;DQv6<I<aH*3Di$K],~A@E*^}>
    *u{KU<VjVrk]W7v"2\Ur$DX]novT\\n^Vv1v=Z$WKCxko_*rzT=*~>Z#2pnA$O'@p!ZOL_,]prG\
    5V]*R6wQDx'GzuoBzJCplUG1XD_ve{)E*=QOieawrKB}#wUqzu+\brYn1(wp17RIzuQ>x'xGQ](I
    ke,=w}Br!oa'2*e~1uoap*V.^u,z>+{>Lf!e7*}IeOCxI'}Z@G=u{u3's#>_OVozUG#UID<h*sKs
    HU$cQEmx3YKJRG>A[u'?mU@w=Y3}03TYp$,q@n{7GQ<B]zOT/>>3]pUz,S"3Q;~,C;J@a-Qz25TO
    3@5AxRlv;z+I2V7'vl[mYUo'}\Iu_pv:DX]!Q_QrzAT'XA~B75rI~I]2.YTOz'!R^.=o]oAjK~Xr
    \lF$-H7zQ{rBVQ\#O<JDwTQB\?]}Cp*[I~C~v~QuA1ZXIw?puoKr!{p_2zuEj,IIw^B52>lXO3u<
    w7GB*D,[l8oVDvKso[rx-Q2xWwFI_AU&Y@-E^fp8~1knrsT>x}jA7+wCmRl$}vw?cZj2_$7BkXv2
    a=^+3{5^T,Tj!7Bnv3C@u~aYUBOrYeEak{oo!Z_Z$g<-B}[Q+TTE;-op?sVU\+,G$m*pEj"'YIo<
    B[O$?a$'k[BpmJe'2Qo7vV,TQ^Z5*<j#piv!^\@pka<*OamGzp2'uvsp}53p=lK'CBX+VG2vi'lH
    _weuAR&xU}opD_wUGlsJvmwmpB{R!^r$YE<aeK][9'EI[g5\EC~r^jz[^!lD^a&*]ux=lelEo3k0
    UY=\vDRWTxEWJG=;UlCD"uQ5x1mAj[ilZ9~VBp_mVwGY,#H[<31V@'o!+$w5AE$uRQsH'!~-T*il
    'oKj,3l{z;vVlGzk+@Xo$}es+}@a*#_ZKRE;p@N7eVsQj^xu[TH*1T3I,r+*pIn~+oWY-{GDlTz@
    Di$1XzVo@jG\&yG'r7=vl*7s]Geiu-x_(=2>}A]1u+\oZA_'~CYEa1D;}W^DvoO!oEm=$3plB(2p
    2!TXA3Rl2lE}--le^T5sO^]jXjh$<TVN[CpWN6**?kR}aXHCQUW{RsGDV]*xRvQ'eUV{!s}<~X.3
    v!D)j>TH0\G$'6_r<kaCOr*JoQ_Urk~U11GIkn_vYs-Y>D=e<5yIH='RUxB#><#72I,,}^^o^DYD
    B\3R,&NIEXHZ-K~1&K=[=-QE_f\G_J-$sDoEJTexX#?o_u?A_1#s_ERep,<I~D=J=*^?R^}+,[*p
    VWl{rxV~,##G@#7Vo71[-<!Dj!rs\;K'WD\^_-1+\-DslTxu!ve1a*lf[Dw-1RIQoiXnD@nR\]}l
    I^1TBri7Ye!Q[Z5+iDEIGo'5mD+_Y!HfCBT3V<<Cek*,ts$Dz/s-Z#s}i%BT+2Bx1j\BWG{Om{,$
    X]uOB~g2^,Z?\CVAs1sYKE$pA$2-=<XVIRwzi_G/RvIj<-l+HH,>M>$kAfVcz+7m!UIu-C-Z?'$+
    O(=EOewCQU;=\auYu^R$HDiDuJSnLUQK7!oW<ZO7CiQ!UK>In+p?WEje*#jJnwGmX03^+??,_KQV
    D_7aA+X7mRozp~=UB511n1=VpQ#CW[Dirms<'2[Y?eQzn+H7v>sKCV6_-~^G1{#,1#QYix*7qTRr
    1=HYK]Urzvsk12x[DJ=k,1IkT{UA$Ca@}I-AaD1#uZAlv'A{D
`endprotected
endmodule // module vusb_hs_up_int_amba

