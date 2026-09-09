/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_up_int_amba_apb.vhdl
-- Date Created: Thu Dec 21 22:43:38 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: svn+ssh://porus/ci/svn/USBCTRL/HSCTRL/trunk/HSCTRL/digital/design/hsctrl/rtl_vhdl/vusb_hs_up_int.vhdl.tmpl $                                                    
//  Author        : $Author: hhsilva $                                                     
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
//  $Date: 2006-08-11 14:40:20 +0100 (Fri, 11 Aug 2006) $                                                                       
//  $Revision: 177 $                                                                   
module vusb_hs_up_int_amba_apb (clk,
   rst_s,
   rst_a,
   rst_local,
   rst_local_a,
   rst_gen,
   s_penable,
   s_psel,
   s_paddr,
   s_pwrite,
   s_pwdata,
   s_prdata,
   s_pready,
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
input   s_penable; 
input   s_psel; 
input   [8:0] s_paddr; 
input   s_pwrite; 
input   [31:0] s_pwdata; 
output   [31:0] s_prdata; 
output   s_pready; 
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

    MTI!#jzEs$z}_eVl'G>x_J^@O%~AO;-]>}3x,[\;mp7"mBJ'exzRJQWn,YC[KU{n7,[vgkooK^sT
    *?z\A;D>zwnKBR"|,izA[Ju[B+!aHEkX}=VQwnZG]WpX_Hx!xH-!}<lW=KXXutiUU#lw>!}r<rZR
    sZGCaW^-pe0ff,AA^rjBrb_s1Q"~HrWQ=w5r!+U@TE{V_GokXUBk}#x!VzDU<aZIHa~L$>Jo5'{O
    Dja<uRVTnE$,17+Q0l{A3$Km?[mK}c95j_{7HG{5@*enUX1\Ow#5GQxFr!2,]e=CZDH>i+G3lC$3
    iB$^vzy\+-@er;Q!=!Grm_vr'eiP]KIOGe*_Q5I_B5a']$E<D23l@T{sCU*K@7W$TXK[|KpalkC7
    oOU$~'j+=7YvRN1#DO!n_BIRuTj[v{E?,KXQQ\7!\syRETEQ7Z{IJ>W5AI\sF_!mRs~1j+<RQDa-
    ;{zw=^oI~]1?A~\T$lzK3n\G,z3*l+TjkG_XO${@jpk[_@D$2*Bu+V**rpm}wok~K=!}E|;DU5^?
    ;HX}=^![5QCemH7K*T^H<zZvRTj2]xk1axH[v3cp{Yi-E-oq&jvaD%Qaa!37U,"tm<X5-GKk$?QQ
    tIUn$H<3=zB?H6Qr}r@IXu~zl12=vO{[Z[p-e1Q3'{1#HTQpCG&Ou7$37VoAoKZww{2xRTCv_#Wb
    gpYAY,'Tz>R52C;Q$TDJOV+}$!jxU6uY]s'RXjr(gpaYW5+pvKGZa<eil\=CE<+>Q~OvsmrK3CQ{
    ]gvKwZG2z_Y?73}2<G1*E!\I{,";1B{-HZrvTB~D5e{tm-$}neCJ9#1YvmDH~{a7v'\A_2=AAv3m
    A?VIX{X-DNn7JOm5$7Cem>7^KsjZGK&7zpOb,vZOx2QvpXlnS"AURoR+HJKnwE.JYR'Op_RfZs@}
    @_zXeAJC'>!k(m-D}^pG7\7~o$\VjbHS5[--'nXnYwCD#+jIWI#m$,Bmk{+'Az+'WvWE!7arv{K3
    xX[sR#{]VHB?axH.,pJYu<Hso>CE=rkw,pIaR]Yi4ji<-B=~I[31E77oovkZ2;RC_}T{{up!C*!J
    'TUArU-A~}2UV!j#U#-_$'>!]=?_R~62-CAE>7j={TVB#D>v#DQ+sx*/i,v17,iK1I1_k&^pi]p=
    +Q$!jD*BxRGkpeB?}[}\=EJGR+u53+HjI?:aX7Yk}eJC>3!DARu?e>jMK[7=rVC^H[#_[XVY]{JB
    Ym_v7i\!YN(,@C?Y3Uz=@z?jiQWW<z*OVTO9=v,2ZTv@XY=YX7k}]pU5wR>r$7srk5Em'ZYO1?IW
    7@z~uvC]D#,Cn[^?w1DlVQmsSE7ZG?<p'PtGoo~o+[Y5x1iDT_TwRvKzT>xT7*7"'a{erQ,x+wI\
    2B_W{{@H\}'V5k_-G?{a]B\m\BIknO$!;vRB*=YHelA3h_OjK+[Q7;$=Ik};2K7n=Q#2n,<lEf,1
    5TRkE~O{CU\ODOE5DZC{VWVAE,0OvjuTEmkKprB9kajOp^VKk$X?XE125UWU}v[,R]@?!U<#I!]o
    ^<*,KX@u)Cx[x]^Z{lHo[ij;k=u-jW[R_z<Y}Ml$2}UzCUj<]2w]YVeUHj^@K?;wU#usI}w{xY\'
    nw2'Q!25RxR~O>pJ~#G2]#Q2lQz5DERDW'x?&Wr_~<^\\^~*,\lKIw}TJqTYwA/AHK~+1k'5~H[3
    a<priA?C%D!\jYaG'5];]:DG2X;euRp^kHC'CCY$xW>\oZn+-O'EzTEV25DrVDTDeplIKuv<<{eR
    ]V+pmGu15V,_'s-lpzowmDYixez[u=~l@C5{B+V?mv5m3_vU@kEKvDTeOZ+zCn0]3x\^m!@1T~Do
    _k_~+j~i11iWHCwY1l#BEzZ[+BnsR\Y[,Y?(jRx]^H3zB},5R}T?WXwT&9q{[Tv$}->m$Zew<[[:
    $=V#rBu\vE[K\~I@L+G2]UVZW_uC@7o]]3*J@JxHj]kE@/#T*k\\+J\OaDxW\1ex!+Z=+WsHK~jm
    I_CSp#K[^+!v~G^@,j-xJx\@yC3YVuU<3s#E3+<1jrl*mXwlo5#rmT+T#}?wl#$eW-+}A6{7j*~U
    \51[~A@exiQeo2M?TwOisn=^+$@F!]@!H5=TU1B!D,EH6l@wY>-wp^@!~<Y]TEu-37O=O},ekl^<
    VG}r+I31uC}^A~t71YG{=mzCU-3xW1mV@_w|zpT*1?H_EqeY*GQ>;rX+K~\ZO3J->7R=IW->!KfL
    zA@HI5xU}!]#G[V^O0[u<I1+=V'!O>9avvoE>r7TG@C9r2=irQ@JKo]TC:#+D]FD@3uj1:lT=x21
    >CzR_uuwH2^ejmlC+a1Z$vWs1[rx-Q2xWwFI_AU&Y@-E^fp8~1knrsT>x}jA7+wCmRl$}vw?cZj2
    _$7BkXv2a=^+3{5^T,Tj!7Bnv3C@u~aYUBOrYeEak{oo!Z_Z$g<-B}[Q+TTE;-op?sVU\+,G$m*p
    Ej"'YIo<B[O$?a$'k[BpmJe'2Qo7vV,TQ^Z5*<j#piv!^\@pka<*OamGzp2'uvsp}53p=lK'CBX+
    VG2vi'lH_weuAR&xU}opD_wUGlsJvmwmpB{R!^r$YE<aeK][9'EI[g5\EC~r^jz[^!lD^a&*]ux=
    lelEo3k0UY=\vDRWTxEWJG=;UlCD"uQUx1mA^ia^=*,;-I[RlDzB';nzpHH~!77Us}j+oVV^G(~x
    >Qz>;Hr'XBH|>wSez-=YZ'mp+Oxe[z#Xwj$Q=kXw*mjEjnRtG#}}Msw\5-eTD5@H<D5+v~wW~,sx
    pKC}DTG$$\wC!CCp~^=7u*7^*;CI!\He_-Bpjv}szp3]{~eIaL]j,VrRXZ~[kw!^m1:o}BDgHVX{
    /#>l!ke{[okz@$p->;=\[$,r>D-GQ^Ok7Kj?v{X+UmAC7dpA~*$kl^^?>uiA-l\^-Y5YueK1?\Y=
    A5Zwa1Q^2}qY}nKAx}A?nEnoHQjSRW}s?=n5hpMiz7QuaJsn_j_:H<@eip!1,I}g*o!<4x7j$Oza
    JuDu}cn5U+*z@B'ow!:uoR?'C7^1+Ij-,57IyZzA$E?^ag*vEA$G+C}3sD7Wvep\~~AVGn!*YHTs
    >WvWDD5iI>ve-\!YWaju!,x,$=kwHYQ!Yzmsa$Gnm2ZRuT7w\\\,S[k*nU,jnO~xU${DmjTG?XI<
    \3wo$xuIHO*!ojlV>RloUY!WI#T_Gv[O5jmE^~{+BozawZCV$]iVQ}TDC*W+=1Zmu!+oA-TKQJ^n
    v<]1Vzu{_jJx>+{_E'[7z!s+zm1*Q$\XQ3*UWvz_ex2!@QI~QTn_#ZGYxo/zK2ev-\>c}Ju\7Cr?
    s-~U=-]ZR5Cn~XhDsUo,O=E\+CEp#;_}#mjHwQ$$TA{Tz'k!]aQ.x=OTz'{@s[GRH*r$I=W\t~Cv
    -Dumu;z@@ZO;wGl{r4[1+wpsjp~=Z!su'U$n{Tr<>;3UXja5lEODCO_K${KnR1!HOsJ[5YD<U[jf
    i}k~$>@2CX-<5{j>GspJ';g'#Xpv;ul_YXu=>Ei7;mBo}apL
`endprotected
endmodule // module vusb_hs_up_int_amba_apb

