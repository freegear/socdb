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
K<ONCSQV5DT^<R`id9XOo3^aEZe[_0EO>AI>hBn:8^?0MYc?mNk=qg3P:OV<_JA6
]iD<[F^XZAYO;:eD[ThN?EYLda[8\XThfZ[[Z0HXkqd@5JD4hnk_EI5e3S[4LYLf
g9TH=K0Gq`ARfZmp^0AO2dN0:V6[M0iJN<BqkZ[GJY1ek?\N\Dd\?n9F4:I0ecmD
hIe8T6AqcmgCPWI4a_DI9=]6BMObqT\8^1N:UIFiYbB83>RMol4fp]eIcGUM=]Z^
BYJNYEJjH>Zq`OJUFNY0\c<]MH8X4HLhWi1H:@H_p?Vg9iOZ67@[I[DjV@QJlOkC
1kbqnTUCFNF7ckW98jc9<7q53VQ7eI6HBlZD^hWJUfS<Jpk0:7cG^BnhleYZ0cS5
b0iS08efKf9YB=q;ALiljHn:32OC3dN_S_Ykg471iXUn5jHlAcoE?o9>SF:DLWaP
5V7=cV3Wg4PhZ2UJTDYN_T<a1TLYS^8pbaIi8;I2Mn8dDeXHDDn\@:S0IlbaHEJI
Am[SL>HCT@6kWA_m8C;D];bFdi6WgBchQ1hDAYhLTMN22@12pmMZ@hd`e;U<]]Z<
jR29;4`P1?l;Ff_K7_l@l1mqV[6i23=Q?l[LJmVeZ6?_9m_kTJk4CaJe=1>j\3NS
qK]R7>`@cQBU?P<?QkiHed:Ld@T1d`c<WLSJR6IMKVap?ZNGae_YgYeTN=]]SM8F
FSed?9kG22US1Jlp6MSicmd1THjRlFd3;4I?nkfb]dfZ1L1ejfRMJd_hIAqEF44:
:oY@>bHg_dZW5<Y_LNl2EeI_epCC`<TfXUM>QdNledT]_2^b6?NaemD2INjgFbl]
KZ`=TB6cq\UdcBKEL62^YjAO[<:oO;H9M89TYQ:`H9BZqHKL40NVjonIASK[<bFi
V>f\9IU6gdnY9jUJml=S[FY8pO[`CPS^PGQ8G5cF7Y0S6B8nm5lFD@8X23hT6q5G
E0O58meP[b<bYgaO8W1c4V_lJ1KGG?ohe=dE?ApSM5b2<f7PRnXB6DKokR9C;1Fb
O_n:^P4=HUUG6DCc;LO7I>qb:ZF;S4MV6\94l7_koRPjmH`Q>_L_4qZiJiNA`d=M
PZVjRfW4V^C>XADm0K5=SOAi2J0Hp:4j^mBEYc0P8;2U0KSVYX5X:3^BK;NP:ALQ
CLh?nAkQg=_JMp;\;BEOi;^1_^_;6G^:JC<09l1BG:YKT==fY::><<:FZeW0g[2X
C[<GeoqHd^hAhVME5Um0EA3>\nP8MPm:Wk<UHWEhCQn[l?MVCFo4K:5Zil0ln2LW
R`ead=kdPpUnZJio0YA:6K3ZlT_Y9IgUa^]eD=k`5LUN0\@6dcEb8dld=ZdfRq6_
`I@2XY[o4RnBNmELL?Pc@3[?jc3;MmJB@4;a[]fV>^9EqI483Y99n<VaSaS;[aon
<J=Zd:X`k<jK8]E=cgD0<ZAhc7g=>KX1d0LDjb4HNcL5LINcPg[pdblL_\CMe@8n
T1EZ`0fZNO\GL`[]^=6RfnL4M1ahQSS\8^5oUAEMaoaai5aNP:N>dRl2maqHZM0g
[mBGacXkMAc_V2Q0FenF?hdje5>Pe1D4788gf[U\k6nn]T:FXh9IR_\UC\@=B;0E
c[p69[l>=0R7QPI>BAQSK0ERJ?U^U4ZF>JJ7b1S<FOZ::W0?X:Y2>9CQEY?11P]d
X7IJ0LpMlk3\PSFPmhh=Y8=iDCLnP_L_0^_[iV07i[`GA7h651WcJGChce94jgL_
U0GGQV5LHYq^4o46B:\=daagQ^\eIX_YjMOZD0ZM8PAUI1RqVBTC_ofD?obWgVKb
KFM2Gf8a?84D;`AEl2]MZRMfHa]h=GWD0[WhAf>dcG<ZnQfj8@Lp8oG\<8UU1>g<
QNW[hV?KMI>1i0eoTVm^oV4mB6oKgIogk\?UXk1iWITY=iY^WQVL@Xoqo099^gNh
=Fjc3^MO^c89365XVc6lMndFSoXSiCkVL>l?eGi2=:_;8Q22BWhbDTfa4Jbp0B^:
f\oJ6eP?T:@61OjMHboW54G`6PRD7hb`jdadHM@:8f<YOBUV@nCBn3N_=22p0Yic
PP6=mMUXg;aC;SaIM:hANX97hbCSL2=N:>8:2Cq8hjWRVmKh?KRYa8b[556F?Fa<
7c8@;0GIlE7pLd[^Te35Ab:;jeffKH:[Zgl:H<WK]5Z3H\Ik=;1p;ZV80kcdlYH5
1CE6f5772DLA0FdPph[gTO3<1PG9^9=4d5kM4nAI4l@5O?3WKXC6jOM:So9T?I1o
4\V^^HcBa9Dq_Lk_c]M;c3XE8R[5DdS>DMg5EFCdn`RcVLX^6JVmeaL59fR`Nm4@
[MB\qZCn`fiFb`^mco@gRfhElne3D2NJD4YecTe7SKI=B>hhV3DeV]aHUWc:4JgF
5fWpUTPW6ZVH7XA5__W]_LIiVF1hfZWXnYl@8\4oS=HalanLnYgKVLUN4G`=QHbP
CMJpmE:2KEaXk7>e`l8:oIdQ>Ldg4cU0E=Y@Jc;N7lSZ`1YG7YYM4G3=lCQ=WXO@
;AIeQ=q@gFcc8Nl7H5d`jiUJl5albO0glq8eg6c<3[kBgUW[\6AB`<`iBR_@c]Xe
dR>6J?SXB?^T:b\M`[2X?;P[C9JDlPQ`YK:>`q0=TRThUlI[RlInC9=n=WL9G:e:
MKTepXccS\FPogdLP:2`AHW=hk6LgR<_BT4Ri`@;WX0hNFUqXXK08UR<j`H:?aa=
oN=mCi4Hd4B:ngf\TR=qR5OJ[;CG;FDMnIQYW7pFcGGEOcJ:T82je[:DER8hc4CK
5h`j4P5FPp7eWKcjK0]ACBca;O7>knk4IEV6CdP2eSFEg6951pQ<X`j=0OM]e4ZR
Q`8T<0cOn@a>aJg5YTo3fT1hP4U5JX9d0>`h26JdMN]M2Ri2KDI2CapikiiU6;SZ
^7@GGJ8V^2bFiS]KG38BHR<dIgV^4Sq[LRC[FHUJ0g7>AB9lAae@;DYU<R07D6fF
^aq:eMVK4lCj>eIC9]3Q1hpkY@85\@N2;MIlc@OnaF:BiZOpgXJX\3GChMLCe69?
<>c70nJ3JTYP][VZ1P07loKMQ??n`TW\6^Q=Afg9:?8lPWao;9FKn2oYpIYIMCiO
R7?X4LAj=1j;X\3S0NJGB0`LD5\f`[Rn_XmGljX6oE2Yn7iFCC[\f\I8nc[XoZEY
>RK[q7QG`;=q@_jR6a^aedNF01LTjFI==dLBg9:qYQefS4q\3oKh_W9>Y=c:5IkX
C8ilg9XIG4p5L2jh`qLc_GXO?HL8ej2lU;ReZH`DTl^J3DoV]PH>gQ`W@DqD9UG]
OpOK9]GRkL?\<kD2i?RTclSUbep`Q]_WRZAnfCekTUNK[?4=lFKATSYdd8^l?`ih
Op2<cS>fNZMbYi=od\C=RT^R?c`L4^:`qd;D4ibH4:=DR2o]Q?c0UDJeQk0jYG7P
ApboAV9]RfgJ;UZ^HldOGB2l5?>CFm2HjJK1Apa^F:nkX??hFKn;7oc2H>T@VSaP
haahceWK6q37F?cAnN=NDLUE=MZ2Zgb?m^dGQ>a>JIo\Cq0J@QWD?XTU]KSJG=FK
LR_XqT8Q4N2A:dhU<C_TmmEQW^IdJa_bYaZl\JILpFTVTk_QdQ44A4<8YZAX^9V0
339R;4nqLFi^FaqVZeHUTSJHYDh;R;aS58\N@^KCJI24hRILcKpSkJ5Egpn05CVg
RBZA_PlnlJj``C^G9IRKl\l;m^imiEkWZ[O6_5E[=01Fm^N2]gPCW`3X^W>epR@4
L`Z`[:R[eAJYT2\RN8cYW3TZTD5\2;KB6^`1C2iXp6lKBNEp0L\FJI91lWoGikBN
O`CImLZ;LMZf7O9`[SboKYSn8A[pfCl9`Yp3TOn]VS4?_e2onfgf[44<V9GCIkTM
oB:;YET4Wp0VY[c`m[@><9cPd>1g7a=mR:_>^Kkah:;Y^ScKBNKQDdq942?R6qG=
IQA`2T4\=:loH^@m?SkZ=1\?Ea8kFa=6qJ9`MeEK:TZ]^oNkDHn\]:_HMGeoHFaX
DDTJc=]BLA>H5hhVAggj=\BWC4nK7]\jd5E]G?ee[:YZ:S[fc]j3Y\m0oO>STDIS
Eh_KZK:N9Z>gRZ^pE:dPYB9DN7HXn>2TgbTpZ]h564qTTkT?`Ndn3_QnS988nka`
ZTaA9Xqc1?k4mp0_ThMfSZmEZ]YQHC1W2[5cRj^NCKg^e@8MN5>@3dYBP]6aXTWi
m@\Y_40`QdhfHopT\_2DFJQk8iOh?aNh?ICPeE[f`:pCTGG9JpQACIRd>664Ea4f
5U5=@ilek7NRN\4DO;IG_calp0l1g^R\2QlcUEX^GLQ^Q=GIkKi8^M=I>@4VkA]d
Z5dc]eA>>Y_W7Nlpk\96nlqURTI]AjjRD:]iS3`APE2n12>1c5T3EiFB33on]YGB
GOqooRM?Ap7lV76KRDIICMhNmGT?`FIE@Ye<0d^>Xbq74Uo`:q];nNLbS?feZ2MJ
^bgJiHV662cg7=I\q=NGQIBq_fklM\Ja;SlO0CHAOTB9OVHDBcW6d@F_Ij6paM0F
0?TK\X_FWb<67L;e=?`SQ9QWj25VoO6L7ga12C40V:H^<]YK4jhqX;XSgjq;Hj9E
W:AoZ@EAQ3FXZ[e?c;?:R[NBO?Am@8j^5PJA0=qQhi?BYpk7XdE\\XoFHPb^m70O
W6;]K;5QQ7;I^fZ<?SAAXffYepf`]]Z^qV;mI[<>BLhjlj]OhcTmPM8ZIdR57\a_
PkfQHiIp0XP:3kdnK^fE;?\WOH_bBZ@KJoEM]6mfRG^F_P1mHm[QBXbo13dXQa@E
3Yd?DIm\RA0fU6Lp7lMNFbpU[A?h290Q0N3bok:aL9^^`N56;1i\gEAp8_50EHpG
FIE8@<2PMF<FVN9I]]7__aXT<>]b?bI7`aT[Bpg36GOWfZfckECY:W_>cYB>US49
EQ=5P[7oH1CP0GJ3]n]nS20LYliNhqLc\\hZqYT;>?]`]SKXPZg1P>4@SR?oWaR=
DbMP;lWG:e9VAgY:o@A6_<S`pJ<h<gdph`04YogeSV5N8JD>MXSQN0;TPTB@cn2h
iekDHBY>MY^O9K9`VifJ]c0\_[_HAT]nq]=Vh>a[NGlN;1LoBO`CXe2fP@PFOco<
@i9\97ffN\0KlX<q_8]2]CqYmn42\\cMd=[U_[8FV0iGD:WZi?TKPq0HJPJ2paHV
33`Y[ZI=6g]GmQZL`>SaoLY9AOlfBh_W5`Df8q5g:Ca<qO;Gi[[3lkl4UUo<JS_F
O^bCD56Al7:NI5VE:\P4J[Bo=jEbS_[6\NQ3^AW5qHi8FS=qHUo?Gf13\KA:QK_H
:?;F>7?@L<g`Vj[[9];P2iGN3DjqRg\chIRod3@J[F?7QO6d8UjDE7M`XeY7Eblp
_FBHmIqPXh_baWdo3=2mO6Jd`P[5:[gDnSPAG2U[lL];4o5U[fpdXVDb7pf>PWZX
:5`0W>cQO2P:EJO41hJTO1dhLanafO8NTLIR=pDnmPfBdNEVH1\hn3IC8JY]Hh^j
[Nj3\]:<JhE:[FoW7XS4V[;3V]C;oeQcSp<>NCOaq<n=:l5KgPiaH89PHXIeYSRM
@4\;=gefYi\?UF3jhH9^XldHQpDUMANcp43bZm9WeT4HOYFfl^3oB_UQHLOB7=Tb
AUOO^aX9J=36cQ\O[q0>Sl::pNNV\;]7h;_Jl]b@jaThJ]M<DDSp3TR98ZnKglL9
CCHDko_=iIlBcHImB093CAW8K6p68jl?0p\HV9IgM3GDEJl9S@?BCGo\OaTLE>O?
5JM0a1X5]N:doi\8I^oi`p^H;Uo1p[WW[R^112;Fi\UhfoVTJ_aoFScZ_VJgZPf^
l[SS`7Rk4HflMUi;DROVnKd^`kVLpUSkcE7YHSRo63CHVJ7?UYf4BlijNMXiDgm?
@IJJ;]f67I=d:]<dledD27K_l=<8l^9eqQ;_L6:pJk^XJ?<9YcUn6f0m@o]m2e2V
]anKU^;<Hb>]]TeVZ0[QndNE44;44FUb9H=^ZjU4XECN:NpGZ_fBSpbgjJ^kI3dh
Bh4:V?AlVJW`AEn4n?:PI6b90SV?mbU?6fX=59gdW`EhG1j6:k4jp6h3Vgnqd;?:
oQVgJ@jmLjSH[Y^f;0ICd_CqE7ZnJ^XbZc_X?aYd2^P3meS71eC2mgXCCo4lEl\[
SOW[h:bleOENT^Ed`G`CUnqbH6N`[qUH<;gMhAo?^<2\8P46L4m;Ef\fQEfdjSJe
\PT3KoXG\To6O_8U9W2X58l1NWBaqD5BngIp[dgfLUPiYQ0b>Dl^Tl\53G6<gYmP
96J<^;50SJmOOA::6VIYKd]N7:SkY9]M28S^ZgR\QhYYc\Pqc0IhOap`UJP>4=ER
@cLJMH@Z0a:ThAoT4@9^>bIkVdeGSZT9;K5A`h:@efSHPa8T_N?UN[ZkMaKfdqL5
9Hh`q?99f;f89bSD<o8lI^@5g4WbSn_HY>J[;;P=\`T^L3b?[NHQ^ej71NH`pUjW
UZBAhmUTPNh\]1`Cf_m_kFJ1SoH@lRR?kIcL@EBmG\cI3VBKSo7RBhG2K7Xp`4eh
`lpjaK<<Xg1`8SlLdGo\hMShgbB;hnjkKAYn@8_T3Ln9^2cmLH6\lMpE@[>><p;5
<>K\WmJWFiFb4\89=S^dSHDMh5SBY4MF3TXHj9Vf32^cL@bol7cIakqefb`ODp4G
31e][5EPA0iOJZoDS0engDiIPgSmfhRJ6HZlm@<g?6cfS=\cEE]X<Jp^NNUd4qD4
_^ZID?RK[b4T@0S8ETde:5NL?Lfk9:daA53d4IHjjWa>dUDb9eIX3K58:A:V@MqF
DZofC4@Z<`hOAEJZ9=TOJ<3c]g9HkNLiJ2Rl[\ZE>eEjQhLq;_GES=q[^5X<H?mf
Kf;C`UO2POX8o=D77J=bBh5`NWe7cQU1e`F2@ff]d3<^cql7=:_mp2dLBBEE>>So
ZOcTdZc2n0=O8R>Z=769Y25e=VOUEJ<Ll5MoY`i0>6;Ya@U172ih4oD4XM_jLp`O
CTIbqOHNYSYK1:O_UTafCb:\Hf:WSLlMXTXOP1a?WjPJfqY0^@0QT3lClR;YEC]2
E?V;:Lb42IS0kU\iLlG?pnZ@n[Dq@FaBJC5o548BOE;mdHTX75\SnJO1UfM083`B
TEVl31mCeNp@^NbJRqg6\]c\L<2O<Vg93Ygd3fXOJBR_\li<B8?HYlLdhUAgb>P?
q9nMhbDqVBI:K`^hACb?dRn8QXq@QNo90548kK6CbfZ<<ZM@:>o8f:7=PY>OWo_m
UCh[UH4\a]?RYZUCnp4T7JZ^p?nDVAi>5W5N=2_9;:YXXHZgXGd<\A]gde5G`F?0
e4eZqEUHa\g@oM6]c\K6RHN?Nk1qBe`SnZqLb0IfDgiPmhX_2NbDX30iE?_F]`_e
=lh0\=8M<ddXiZZV?hB68JCHSR4;4f6:CqiJSH8`p1bLUTKlS@bbmDF@f_b=io_I
OJiBA>\mnLQA@h_AbjaLWJ:jG@Od6m3I60HBq906nT9p>m[UNb=8eB_8T]VVg12D
NY`g7;9AjLJ6dW8eA59R4HkL@:ooPF<KccI74kCp<\H<YNm315>7@i8@CAfDZoi>
8X2DcO3i=;2Ul>:@AlXWG852d@bS@?4kD]oDlbLjU:5np9JPfV[pV^@39SG?RGOa
OFWiiYHH@?N9m6@HG597LmXG5Pno>P6QZB[7jlMP_8\A7X:p8:LcGeqWWQ@DKSa^
caSHEZ5P3>gUaVHgC\<5ZMmLRm7N2EQEWA@e>\LEF3N^QfR`7=pamFV8Kp]mPJ5@
^\d^\D\SI3m0kP?Ok[C0[D6R>R4M]hmgaUSP<l^NR_bn`_NE@5=>h@e<dgGc[pZY
PYAeqD[Qc;jLSZl^M3Ji>ab_GE1FAUSNn3b4P>0B:XIPnk6:NOjY5=mklB3Q:]]h
2Waf8P0mqkfblNcpM\DcD6l<]cPC79NCAQbLMOjVcOn@_G1XeXY<gL`\4^OI9AVC
7f93chYiTRmBJl2lc55^qRF1413T7S_4E6:XEmM2Kk=DL1^9d]0EH`ULn]:eKhKM
;NCEI9@H@>bZP1LY\E_FK4DVq4i1FKYpi\id=;9]W9LBM>oIdQeSSbP?JF\6KG?C
RRXYJ=Bj7l0V4QQh@aC4X9DlgRKDmQPjf]:pd?88@kpN;LKQ5CgT3iVofC`OIaf@
?1P_7ERp;Pbb@nnCh[ZFfIXlmkZlZH^iS;S4YG:HDBL3^l=BV_C4ia]X?^Y5g1Re
j_K_A^8h6ZmpiPmVZhpk?f]CYGhchDURN<X>EXkX30OF6aT>kL8>NL=Xidm><Vk[
dY[eZ_eJ;RkIV7D<bYgLFdpCha[[epQTKOI;o9fT?=;X=qo2[g=3ik5CNA7VaS5:
go:_nFg19lLeg1bgYcAhKDNm0T>h_WP_ENS?eA4kVT9_=n6X>q^0Z9mIqF^_=aAb
7UKO5Ic0OBm^Y5@R59iFXb^Dn_cNWc[Q2jc[ndONTVFeW6^6402T??DcTAF4qZA1
L[oqnLA]9;]@Q6Wl9l7Lc;@0;b:jIOiSdQNq3;Pko5D57BC0jghCS=RHkH3TG60O
o67202C@KelVKK1=ERD8;CLGHCn]Ici<jXa;=?[qg;g^KQqaf2X?m3K00VQ5B38J
M9U?aYaV]iBX<:kG=em6cLeKEhTRUlimgUJNf^c?KD3j2H@]o<p5ITZ\Mp?\5AAb
UV;8;S3;oe;<[0m@?07VZhj1E[d4J3cIM1C5HE\?:221QjJHYo3DFRm^AkGFHC?G
qMRhRV8pLe=TEFe1K3OJYLMF?]B2JNbaMU<CN\lehIEf:RoBKO1FHT:aQAClTeDT
ABS@l@dSCKV8K<p6Bdnl1qMDP1^fBj^gQ7:fbK\OfN^n<F^3;Pa<^ca@WCLTSEk@
6oo@L<:VlcKb@GJaY>lR3aA]AO;Ajqmo8Ehgn56dWKf_?8=e?h<JBj0WCHk8`M6h
C1bRgAon@JkCP[JN`3R29Hdh67=6iXClFI3QpRPAWQ7qJEL6@hj8<X]=5?2QFkOS
N2]I9@]7O8oa4iB9Hf5Wn:ad>gC`KXbfOT\H5=o=`4H_;c8DD[q1NG=_oq9Vh=F0
L>LcQVlZ9R__<oUeL\eXNc03S4_mGIa`0dk5onR1DR>lS=0jHm:Wd4@iP=aci6J6
p]mn4Bhp9oaaf\n`30>cdN?d9fOk]]bJ_FWdCE?BdPOAGh<cS:JCCEUDjHLW5KfP
M7:_ShKooiaYKaqcBYEnQpmGeW@^`6LQC=]=U>H>=CeSfoUUFNX3_\^h2=L7F>Gb
1jD4MLMLdn>hO<eJWYDAfpZP`iFGg^R_E\9FEFlQ3cj7ff<@j46M7EF1MCPn<=i`
OmE`;9kU`DI5NaY4:>JKnfkcjl;YqGBd?XMpFPR:T2BnU0f<<2[oAS57P@<Z65HI
^;9>7nKZIKGOhj\IEe=Pm6KW1hHB7nQ8230Qn;BMPZqbIgZgTpWHkGjeQJ7kb2mY
JfE?iU8J3WKV4CUK\K<;2g921NN38LHR>;5VCHZ4CCann_=Yh^RlWNj`pc6d0]dq
eI0N_5_jbZ=3TQZAaH=Ion7BZaL8N>1[MSjN7KbX:a_ID;4LfaOd@[ME=mfgQh8e
meOh7IpbIjL`[MmWAYEZQ@>diHc2nJ]nJGS29LbW7Y]0\^jM^he25V4UdqmDVd2e
qZb[AggO>9UU9[;3V0CLfjggd]a\MPmL<7:;McCYj5;jV1V202ab[lGFeP>X96gE
1hddaDeq[IPo5Pqm?=nQUaOQBCV1DJlPddXA^P6:E^GkHK9:9=Fo31_K2XCK7a;0
E6C\>RRZ]H<iTS7h<fiYVq]5gK9apmZ;\A<6dGbM0NED\@BRXaA6f_Z28dZSGRQ8
5o[;NR4:k:\LJal5j]TDN@fi`5n7>OY`b[6p7R>C]>pIZDenhf]ed6^3RLhFR0;I
DLOiJ79aGG=N3agU0TBQb<O_QIG20d\RiB<Je4C5hAflhlbnAqWY3\SQqc36cgP2
m]?DXE?iADB@SfMZI:3=j4NTjn[18g[TN:CW_ODpmGO^`ZVeTAIEUS`Uc_5GX`O]
J04VUB9FmjN=HiZ?<^VQWG^iH`]V05hJoB7o[RU1l7C<[Rp=hhT]WpP3h_FUA1:_
3L3RP>kA\ICCN4U0\k2P\Ef\0[dPBe\S=[?VZjMe:kmMg?Hb14^Th4cofMfmqab=
8DHqDo@gZm_K`1dSbn9o<hAK;RLT]ek<UE__<JB9daY:eaFFn_=]NP1M[0G?T3HQ
S4Q2lFfTKGq]bJV`Wq@JPP@c]`8KR8l;2HB<UO0bdcW?9`1G[ckY?h6J6jLC=Zqa
?SVAVYk2:Tj?[N<^?gn`eP[E_b\MG>\ehA5G^_4TeB:PT>cf6k>kLmjO2@Q1AEUb
:Xh45pOJ>ID=qm<LGTlf85eEbNgPnjPWTKcY`=Y]ENQI6c\I3OXaBie[`_a[nREh
=d=fP=agd1XLbA>;DcJpLgbG6:p:TmB0OQ96n_>QhN64IANA=DDjbK\A8>1<hI1n
lN9_kD:mO;hI@:__ca1Y:lJ4o9YM\1G:NqLbl`BSpMM=6SNMFcS\B02<J9OMNl_h
lR_i4FT1J?Z0ec[<:48lPoZN2KA\I;XBWLaIOO^Yh?DO<fcq>^8kc<q\2Nb_gV0J
OoSnMk;<i>`Fnjj0j[`IFFjUYVR:XT]Od3gfO4gjEXX_k;SCNhh]NGaDBkPK<qcF
VM76YhL1G27GoJRRI=W;cTXBdh_8fVlRgCj_Cc?LLpZS=0L6qXiRj9K=\GV929iG
jOB=MBn0aCL`]J3l<A45[TAl1dom0D^[;:EN6a?1X=\VG7SpO_QH3^pB3RV1:UJ3
Co6_mG1>4Z`oWRZL;UY^\\8BYL>>QYb`_8oRB8fK1Mp_]chi=p8\[]4:VUdfC2?O
?c<F\==PIgLjPTAlk_;\G41DPJO<TR4JO[GkPe<BcB>^MG;b>@oGYL=BpHO]UFbq
V_2D^chFn_J>0\R_OWbIPRbn=JH;e<1kUdA_3b@EJWpPX]HkL^gWfH16QI@GW8FU
ij<LlWTdHhfPDjFKijFU^WcD;AWWQ@^We`\:OQq\]59I^q0<?X`L7]N5H<b3_ha0
H?I_jk?7>1AGa4@T3ZSCj5?cLLJd8S0`cWYD_=JC^;SIl:WY5Ob<ND[P_gm8qnEe
2c9qPmQMa5mVVVU3iIa?`NNT0Fc\U[2QTbY_LJGPO5B184N?]JYAo[3cId;O^iIa
diS`:kSJ>Wa2bMjc5^qVL62XWpTj5<Rl@6m\PD5CK;0a82Ygk]2WOZc_2jicH6jE
Dh:9beCOi5YoiOao3AF[<4bE36lNRMHoK59C=^Zjqb831[E::?:7HebL5BYioZlH
hci[Cp6MXo^gpjj02_[UU=h9?5=9MIW6\Y]P9TZe48CRfAF3Sjce9g5R;eW?Sl4P
57T5A[IDgHfi1F]E7=j`TTTH0cimEq^BN_3Wp?9]GchloeN8J__T>mnMBhU>RAA_
ce52;d<V7iaiejnVlen=5:;9_>R2EF_d702BnWCEcoVLIqcQ@Id@p^BoY3=g]MFZ
aU;=gC1=GLmC[B7mD;6oZK:gh2UeZW]MoAWT[ToZAT`]<9gAmGP?`3ZnS4^nbq9=
FJi2q?7JeT`_JKG_Sjmj4IeW@Z`733C:cjQS>]Odc;egf;<GcT]=dF>\Pa78c=J2
H<Uji1gEgJESaqhiIgSHDWcKP`UL4T3>0YO6a6g\e2qeLB_Slqe5`_T68RR@7j=>
jj?4BCRo7_L`?;AMdb]\EC[0jMIRg\F^]IYm>n5a63g60cX?Ubf1b0SGm;p4iCei
nqm]SO6c^N?SN\4onMS:8Jn8Ybe[b_Y3>lh:8jW<IXLFY=>=RM20CfOLlRoS]Ch6
Q=G91_J4H=pChd`T9p0=lZc0];?4XT0P3VB6H`P?nV_RiJR>LC=IT^CVg2q6i_Li
6en?d>U:NHlNEXLXHP>3>0BSCMafUeL8K]Z1iN4>f\L]^YW>EeYdeOR:QlID@l97
66PcY2caN<=<KYjQ7N`qlko^[epH1eI25LPE?2eQlQhg8i2]?XdiQOI=Pg5SlK_7
\EdaOkGEoZHcXbh]FZB]1NIWdZEq5[dmeGpE4RU8if<PEVSP5^;;Zn^F2G[c1Ggi
D=aUPJXVKi=ogC:j9]iBV7@B2W_qAngeX5q@6dP[?:J\\QVA5fmE_Lj1ble70phR
Hm;oY0FImW9=La61j9<VKn7d6o56cXJL6jE\kfh[28P<jSTHGd?k[Ep4o@>UapA5
Ik[X60T?X:7GnnbAFdL2bGV]jT]1clflQ1^VBG9:fL44NYg0hVQhZVq;6Hb\0qJc
IUdUXX:S0Q1B]XJWQoLlPD<0T]GKa7PNaI2:M=I3dWRlZK=D[aU]2_q`OCTI?pS9
5Td4AlM;CImQ`J=j\giXG?;VcafJ;UX1If>gcbb;SCjhW8c1h2`O1Hpb?j]=@qUW
PK\fO:ganj1GcPK;Rb`6BE?`Q1hD=AclGZQc:8c7DoQE9jSSL78@6o6F`G<VU\^7
B:9>8lq1c<1FSKCB15?HZFS;Eim2H[HiX1eS2lVN9_>>jFEe>W@5FK]PE0:HIjZp
GFldc9q\WM6YG?`:^Hk;gl=ZEBDZ]h`8aQ>905V__?cUn2]2G^^MUQ?egLWI60lq
1[^1j7pKCmn1kI=\:Q6PC1H3Ie>PUJBSkLY@4<W3j0=23lmfm:=fj^Ok]BKC1^`q
b2:UCSp[odiD_X1XMj6fMJJ:LK3WEhW84chMB>V6Um7DSWm_VP5THHT>6JqXLXDL
>pAbAj02Pclnl;CkNWbaIJn3iU75X3?2Jho7c@D[m]KH=iR:LNgO<Vp59XF`[aOk
9iP?73aMDf3i`TQRO?2I>cD]:LhCm1Joi1nn6p64:ClnpXlODR5AW4NSFB2TBDX2
ACBSaSa=FiX[b3D<;T1F6nPRZ]Y27\7IqmkAdCop<jcQUEaZ9COG79_hk?GF8nHM
<gRIB\j00IYcRXK;Ea43M6KBV:@ZA3q]cMKAnqK1Y=nNIQlaoeA;kaIo@^8NX=UG
LkKKCX>a`HG8;SG=MnHc37XY5lZm0kmX4=]1YeOclnm`q@f6Uh=qOLA5\NbaU`6;
TJJf__1R>ob8jh_ocoY[[@p;oicmiS?hKoPKAhlO0YA\CB728Xb5`lBEIl]LdA79
9H\m1BP]U`q7QYS:?pg<1Fgchn:ASD8QP4=4afWM6l7n_QA@MCMbR=cVnTYgSP:h
>J>k]@HQ>d^I_4AQk2;Tf@jllMKhn50JpB?0ME1q1e56L\IP\Lk]f`GLfXYJUeNH
PiYSGIO7aRC8o`74IjLm<Y?g9^CSg:Jc=F?3AdpBcX0^Qp@L\8]3Mf\7X5h@a;N5
9EMAV5iWSmaD>9F:3L9N<kXg:3oN4kEXR9OE;XO9a^n>]0qm<AYLIpWaoeGbAio=
J=UdG@3EU<1nZ;M?d:UoOiFVFcW<Td<AWLbh`GJ>5I^M56C_q5:kOC][33dC@WZh
>h7ahAQU9Fh;Sno@ToRfMDS3WIV\YM]Q?jG0fNTEMDmcQCcJBq>k]LACp3k>em?4
amhIj:nVaAkFi3MbjaM<Y]XhOlc_O[@<Zm@U7ZVgLm2@H<oBckS^1?ip1]NDKVqT
YCV;@EDT@J;Hl5h?lGINE2`MZ^==ZXbOHGeo_=JkikmWEnSQbTH1XX`UQNlcWqcd
<VH0q>V4o9`ViDI=b;lX:\9?Jj68Pk[9>25KklC49WPK>BUgZIokNpNM3D7WcQ;?
b1oXXU?7JmUOj9TAk=h=Zh^iaMV]V^X\i:nelgGM1`e<8m1a1KjYqPOB8]aqR^QA
lF=`;TEAW2ccn;`nWP:48L7?FFAjXSMlc@]DOCC6lD5E56d9c0`4ilGlb3THph=f
h>bp1f`mBfoonI6cSAAg3@DAXZZ0=i?^LJcKh]LYF9VT\EocXDKMfDgiF2@lmWP>
AH^VDKYcHbqU9j94?q@Af0LlDAXQn8m<RZc8Slj2hn0ePg2W<\E<>K48>5Q\eo?n
:B5JYc3eWOTfTYTXfn9PBAJRgqc`mnmlX8^Q<V9fB6WJLJDHL>X5]8iIaXYA2`9F
J]1VAIKDJ815==UiViE=i<YmQdeSQG1P<gqgnj]2dqEH;?hj^nN:?baW]h3lcC:B
joXhCIUk=AIMYGhkg8H2N5e=>eAA1l[8p\^R4U9q1V4Simb5>d_oX38MdmF_5;1K
G_[462M>VI3_bd0ZkBVEb7g1COGA\=H=@FCM;Y_j<jiFZ`MpZISk]H?EB?bU^GFc
<JH1aiUE;;=\o=oV6RGWbbFck@PR@aOap@PajhXq7ZVGEPQ@4A1j]`dY@Nfn`jf:
dlnIHg6kUQFE^T\4<K<lK2cYph7RcNiplU_=4ffcNfeR93CQP69hTgO\iTj]UfjN
]LA6<hp:4edOmqdP5e=:]<`ihe`37kN1S_oNSQQ=ThfdVjOhVA_];_qR>G?=SnXF
QfVjbL^DLQkY2Y5JRP\;I9fgIf;m7HOQgqKYTYFVpX>4XZ69R`c6WH`4G]3F=fGd
ET88;l<CjRcCG5nq2Df`GWpEK0_>16N5d[HUlOoF3_a<Kc?_d9ci[82e5>aK=<7C
lJ;`B0]b\MBdU0Vh9Dg5iE[D4o?R6lDSM71UiEYJ^1GZep[I@h5Qq0[CB]5N=^PG
@_9HnRIcU19heBE8f^TWhL5H6S^42^mXTgUg7WTJf`Wbe8TXF\X4;d=9UPF?E_iA
pl6S6n>p3_h^7<5]c\fiXYkJ^3l6LS`VRZZWQB\5Rkn`]U4A\<g5NBYHh]6O:3LJ
c<4gGl5lfZ?NS>eOTf9qkDBG`dqHe;KnIfO7l5<l3]ZoQ>?A=If\fAYH]f[8XgA3
S]ic`?8ZbX9eeV>b0X3F_?lq\a>K_jnD=F^GB1X;N=:]JJ4:NTPfII5H^OYF<_R5
\mYIIoa=l6_\Q3GRq=XfQ^6p\S[I1dSU5N?T1]>4`<NG_H>YYiA;NclG=cJa_\CX
3J=?RSRSIMHV2W\3@<a2j1eqFAT[dC_kH`H[?BZV42O34>HDM[TgcUS_IoTE8;O6
>d$
`endprotected
endmodule // module vusb_hs_up_int_amba_apb

