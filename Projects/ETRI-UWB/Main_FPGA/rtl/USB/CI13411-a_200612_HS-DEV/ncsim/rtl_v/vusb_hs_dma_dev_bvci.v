/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_dma_dev_bvci.vhdl
-- Date Created: Thu Dec 21 22:43:17 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_dma_dev_bvci.vhdl $                                                    
//  Author        : $Author: hhsilva $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//               Vusb_Hs dma engine.  Top level structure.
// 
//    This block is a purely a structure level design to connect the following
//    DMA sub-designs:
// 
//      vusb_hs_dma_up_int : Containts DMA specific microprocessor interface
//                           registers.  This register file block is a slave to the
//                           master BVCI/AMBA microprocessor interface  one level up.
// 
//      vusb_hs_dma_traf   : Moves packet data through the memory arbitor
//                           in bursts of configurable size.
//                           
//      vusb_hs_dma_mem_arb : Data path arbitration & BVCI/AMBA bus master state machine.
//                            Communicates to RX,TX Controller and generates BVCI/AMBA
//                            bus master signalling.
// 
//      vusb_hs_dma_context : Context storage for data structurambae.
// 
//      vusb_hs_dma_dev : Master device controller state machine. **
//         ** Not provided to host-only customers
//      vusb_hs_dma_hst : Master host controller state machine. **
//         ** Not provided to device-only customers.
// 
//   Block Diagram:
//     See internal engineering specification.
// 
//   External Interface Specifications:
//     See internal engineering specification.
// 
//   Internal Interface Specifications:
//     See signal defintions below (signal groups represent
//     the  block-level interfaces).
// 
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
//  $Date: 2006-10-03 13:51:19 +0100 (Tue, 03 Oct 2006) $                                                                       
//  $Revision: 339 $                                                                   
module vusb_hs_dma_dev_bvci (clk,
   rst_local,
   rst_local_a,
   i_cmdack,
   i_cmdval,
   i_address,
   i_be,
   i_cmd,
   i_wdata,
   i_eop,
   i_rspack,
   i_rspval,
   i_rdata,
   i_reop,
   i_typeinfo,
   i_xtra_in,
   i_xtra_out,
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
   dma_up_run,
   dma_up_endian,
   up_rx_burst,
   up_tx_burst,
   dma_ep_prime_num,
   dma_ep_prime_rx_tx,
   dma_ep_prime_max_pkt_len,
   dma_ep_prime_cmd,
   dma_ep_prime_cmd_tog,
   dma_ep_prime_cmd_handshake_tog,
   dma_ep_prime_cmd_complete_tog,
   dma_ep_prime_cmd_fail_tog,
   dma_ep_stream_disable,
   dma_tx_tag_wr,
   dma_tx_data_wr,
   dma_tx_full,
   dma_tx_mark_down1,
   dma_tx_mark_down2,
   dma_tx_wr,
   dma_tx_ep,
   dma_rx_tag,
   dma_rx_data,
   dma_rx_empty,
   dma_rx_empty_ctrl,
   dma_rx_mark_up1,
   dma_rx_mark_up2,
   dma_rx_burst_est,
   dma_rx_rd);
parameter eptx = 2'b 10;
parameter eptxa = 1'b 1;
parameter eprx = 2'b 10;
parameter eprxa = 1'b 1;

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   clk; //  system clock
input   rst_local; //  synchronous reset input
input   rst_local_a; //  asynchronous reset input
input   i_cmdack; 
output   i_cmdval; 
output   [31:0] i_address; 
output   [3:0] i_be; 
output   [1:0] i_cmd; 
output   [31:0] i_wdata; 
output   i_eop; 
output   i_rspack; 
input   i_rspval; 
input   [31:0] i_rdata; 
input   i_reop; 
output   [BUS_TYPE_INFO_WIDTH - 1:0] i_typeinfo; 
input   [15:0] i_xtra_in; 
output   [15:0] i_xtra_out; 
input   [8:2] dma_up_addr; 
output   [31:0] dma_up_datard; 
input   [31:0] dma_up_datawr; 
input   [3:0] dma_up_wr; 
output   [2:0] dma_up_ahbbrst; 
output   dma_up_async_adv_irq; 
output   dma_up_frame_roll_irq; 
output   dma_up_usb_err_irq; 
output   dma_up_usb_gen_irq; 
output   dma_up_sys_err_irq; 
input   dma_up_run; 
input   dma_up_endian; 
input   [MEM_BURST_LEN_CNT_WIDTH_WORD - 1:0] up_rx_burst; 
input   [MEM_BURST_LEN_CNT_WIDTH_WORD - 1:0] up_tx_burst; 
output   [3:0] dma_ep_prime_num; 
output   dma_ep_prime_rx_tx; 
output   [10:0] dma_ep_prime_max_pkt_len; 
output   [2:0] dma_ep_prime_cmd; 
output   dma_ep_prime_cmd_tog; 
input   dma_ep_prime_cmd_handshake_tog; 
input   dma_ep_prime_cmd_complete_tog; 
input   dma_ep_prime_cmd_fail_tog; 
output   dma_ep_stream_disable; 
output   [3:0] dma_tx_tag_wr; 
output   [31:0] dma_tx_data_wr; 
input   [15:0] dma_tx_full; 
input   [15:0] dma_tx_mark_down1; 
input   [15:0] dma_tx_mark_down2; 
output   dma_tx_wr; 
output   [3:0] dma_tx_ep; 
input   [3:0] dma_rx_tag; 
input   [31:0] dma_rx_data; 
input   dma_rx_empty; 
input   dma_rx_empty_ctrl; 
input   dma_rx_mark_up1; 
input   dma_rx_mark_up2; 
input   [6:0] dma_rx_burst_est; 
output   dma_rx_rd; 
`protected
N6?IKSQd5DT^<gbahAW^3Dbl6LlT=cg<cc3OTkHbRJmZ8J1MWe<f4Ri=p5oTlaJJ
JoW@W39c[g3C8_koT=HK=PUmVJbUi71fC>0nLJI]0e]FP7M`Gog>E1S_kqG\liP;
20c42F3QJQZbl94hG>Z>OkaTTn51p=j9Fb?qb^97k4CU[PbL9OGSAgEPq3Ghb5lQ
g9KE;d8fQ?Nmkg8J8ZWei:kl[7CKHpH:=EJUoR\hP=VHfI:bP6NKI[Bo3XqGJkmG
[==9ngmabojb55kY2HDPR9cqH^=W0[5TOm29RHR6?AA7f2jD>NGZWDqRRVC@GV;o
c>YDkY=b3SC[Yh]mSZAAVCKLapD7]]];YACXN>fG0Sq7B2CH;d1CoPefF6ZDVdQq
6RURfa<I^fneaT\FffWiYD=SM3VM10X4N1ic=nZ;D]FXS8gdSo3Z3h9gjU?mCHem
NY`pO3b:g6[>?jVlFOo_Xb4adU?jW@PH?FSDW<XojDqjCRYTQg0QXG@ZM^@65B6G
M0\MgQcUfY;K79Cj]f6i3IGBUelZ0;CF3\b?hpF5>gL^AbH?>d^AiWMC^RYOJ=\F
L1g1;T[oePAYWbemp8\19@id=aP[7I4;Wad5\3kF^]m0F2N`QUL3;[nnP6Eqg39c
hP^_B]Re\;_`A>Z0:ADJF^[`^ce^1GYLp]2FTCKBYm2^ek@gdIH7U@g[W2NJ;F>W
Vn>@IGYqjRJS\0lVDo_<^U=LnkMc2GTa@::AQ6^VFAqNY4e=[9>m90e<4UFIo6?@
<70n`ULDc2BYaqS1QONa:8]GIERmY^2??5Xi<]_mh4]=gEQPp7fe1?_8jh9<=5Cj
ie`LM@_MAoOB1KYeWd:B8;N[ALHhcpbo3m9EQb`5STDCU33a1Sp4Q<KWhTk?dD\;
`X@QcjN?]ek00RgC9Ah>1pk0\[V:deZ@Se5CN6S2I9QGSkZW]X8CPZXcgPOIek8e
j[Q=lZJL0FlmeYq4oV=R8O[mi]1Mb?;=?i;e;D[^6Zf8VmdlclgbMZM3ZSCqC^Ec
=nMo9=o@>Vkl7]Vb9\4^<FbfF8D9[DETqLTb[oQCFSYQBBcMWB1l3<a=>\hKe:?O
]Q9di0Pq[MRJG2;bY1m\\YbR5FXH9g:AfMbUSk14e0b6>1\4p2Ok4ND;53cCcIFe
Rn_g0Q>ZK4]nJ=nmG;U\Bk:T_H63p7a:<Y9CAck=nALYaRQW:khpNDiN9K@IhR9;
Im<bJ`KFX4;iMlgfD46gREcpjJ`OJ79;QA0=^C7@g6aZ\2i0E7`<d[VF_;G<LHU=
YFbITCGMIRYP7ANVh1Ui`AhqiBBmZ_816jBb1eHQD5@\O\qHUiXXa<81oommBDaS
9gcm8RL7Zg@>?kE41bmD?aW5:lq8mYYCH<;_XNGkkZZT9YD2RQKSCRY`[>=:6qLA
?NW^nhh:4fj@c]0O8fA@U03[@h<JomVjC1XMg\f12d?g@Mp4IkDJ2l5VAS:=SG79
95WTmHkcNE_W:b>j56aKbki61f43QF`nN?WocqcA@=WjnJ=V[O?H`b5?9DU1QFW?
Q5KDb]M]=K]^W\]7^0aCP2pH[NLmMb`fK3eJ;h`;6B4@@f;E?eG_ZQ7K6GNnXfU8
GYG3T`G3>?a=^qQB`AZOl;ZhDTR]L_>[UYOke<1=R9ZVnG5e?PX9JRdleVGKDn=8
DY1XfqHm1ELcdNXf;d8C<]Rjl0[BcVFQ7QkRZbJ8<SMfTZD_=5^Gbg7K]oXlNdq`
:890<cK1UbFo:9kC`P2n6Vj;OH<?GILUV8N\3M^eN:1_T]blo=VIgZdg2eeb1q[k
mdUBN=>PglI4Ma7NB=Ne=C4]Sc\][BhmkR]0eC;cRPe;gCHiOan>DJ;YY<>[p=iO
\BZECo65K4E;^7g5OT;KK14SHo9`Af;[g:Z3ZF2A^L\8db6k\@I@6Dmq>HdX[D>W
X?^03DMQPMg5_XnB^k^[9A@=WEEghFaqK4kTmOe7=m]m>W9^<e0gTj9[<2X=mfJc
m>_?O^PEO?L5mcobK^B[1oV[AMGEm2JphAjjgLS`b5Z@aYQ0lh2cM[=7`958]Oc=
OFMnG\:KTB]S6HoAk==XX4^Tnk8>hImqi]6Rc;Mm887kR2JC;0YYRNSJLh]1F=;;
H;^H1V67ZS3JIkEApDlhmXf<:3691YlV4Pha`Tl8A2<gK5RlfQgQhdFl=F0VajcQ
TWefhTRq8X1heC2f@lO4N[@UE8;DVgI9BFHFA=_H1l<=3@6ZfDlE5?V_B=oDg=ql
eFSM2GVnBgm6E[V=MD\@onn;UHd1P8:1eiY0OIEYTVa@blbpeL\`Zl?M^Glcj3_m
S3RJ86ZWCff\cPW9Aa=T5PKdekC10QG4J]nfj5R18ll`pMnO;PBDjOC@8@b;F^4J
Xg^RlbLDof?BHM0am3N_n=J51<QS`SaEa@BpJj@`1T>@ePZY>4BfAD`Mc4R=CaCg
<[6S]a8o<5o54@UUR7R2jmJ`DOpMBU^c=Rde;W1<4GBA0]MC_d=_8?>fiFR3?EMT
0fWG8[oSleKHHqIOW\d[0TC5[UBYIBWj??>g0gnW0JP3:ooKIJl9<?a6jPXK7Hfk
pU2O7[FkEZ37_\VI6T]W5b491\>mg8EG:D66lAVfK4g2?]M?aMi=@FS\KDXpA1l3
>c334n:lX:QOW>Rb6GdY2`XDI7h]Y]IVgFVK_R324gj:3U85Z16e@JqOgYV?LfU@
[MA@[cW@k^:l>^ckmU4\S9T>V[BBmg1I8`2@CB:2=qmU<Ya7@jYEme6[4cVlhadc
S^DAhA9788]dSSXWnTk9k>P[WPGmpdT>`Z5CmXFm@aO1hH6jj74U\=Z5BnGk@L1C
7[NKnk`Jh?nLVT1qf`Y`>E?[UKhMAoa43mqia=1FBkLG`M1VAU8E^D9=640mKlC\
f<JpSLb<V<EV57`[P665^1@;JTOFISYfGO6qjmKQ[KC3C=K@^NLH]VYh2N5`o\9O
DO5MB6QIE5pgW[]Ia\B`I<PF<TXD2gle7KjoY0D\>lH4nccj6p]:oR]1nnAL_W;Y
\1MQYLX^Ffcap954hC]T]X_^4Yg5Zboelh36jKE]@OXGSXMp7>G[hUCE56QUGH6H
=eod1nKg>b6\D4W0qU?`:FSRdGD[8GM3MkmoakBmekiVZ^QkLEKHhZbpY\78KRgN
j@abiY@>UDWe91;gR4i_8MFOfbSh9UAo4CV=I?DmSm0P:?2TY5D]XmpiDZWW`=ID
6kCWB2<9?=APF>qPD?`kFVP7FkFT9\U]Ujn?[OPg>cd5dq4U7S>J24S6:;Vl1g4V
485h`b1H6XLi1dOo0nU_=pbe4;HO77DG\f]LOJGed7ej`B7Y:A_nT;R8V<]Ub4O0
Nc]7qd8Gn94k4:<ENR=jVHO^E\U5mK2S;XPl5GhqZc6cn`X<Gn1hhfkD;mXP^L>8
CD`m@<b@fLAZERQZ2HV<LV51_3IJ8iJ;Fm6=W3fWQcLq`^0K9[7QZMOh<1P7Fb_4
lcYchfoVN`>H[7cPqe:>9bbTh;G5XEF:UQ:_i_@>[FCq[PNNY2LVA0I[9ZbG>oBS
Y5>kGKLbq5kkKe7<oMle:OoURe?_<?bOWBMo>4MET:Xp_o]ST;bb@NO^^Zhe>QBG
jRfkSbPRV;QCmSqJ>IiaG9lQ27nFLnZ>1IJCG<Fo?@L:9m<pJeNTgbO?ABRhF_6V
hh8Z?>o[N2P:Ijqn=B[\4QC5BSGcF3AeocBG^204BE\<EWmpgU^OiQT;d[e>j[MT
^<ZM>l15MLddYc6gPViSGLbXVYoAmnkNf;VpW[mVa3K\\YHR_mc`J9fj9?=MF;ha
XG=BpT7EUOi3:HUB9G08Xfa@:ck=nj91WLkfEKUQbcL?`158_<VXqd6HBN8;;gh1
R]4N7^7P`M=moDH\pcUi=A1[9B_k1;NNnck<UM^^Tqgc\K:3WMJlW_2FKN6BcC\n
1cEnL1_B4qhl<>;G7i;PAQm[1KH6@aPLo3dlfW;[E<^ESXF^V1Y<<qFRM0bZQUSd
7n_RB`XI]gV<?nd9<DJP?`2ALNR?hk4WUoHnpXP<NmKlIhG:V\c`U:LD4f[HGU]g
JLn;fQW]63BBc=XXA@UQ9J_R0pR1]QXS>?^jCe`deU[U]T7[fDI2O?c@]?nT5ia<
BYh4=fWgU<p8@>Djdf_9d=^]@?YaIADohnnFEM6?Wik]m]@J1POT4Xl05Q[8;<<p
dLZ5>E5;Eih?SA\ooK@^2<BeGKdZq>2XXQJBZ\j?hME_SlomjHlZd:^T4pL[QJM=
60[VGRi6Q9nUkkHZ=<QmLK7o:Aq0K;HV8_\5M7On6ohhkaH<0Tm``XD?P>_p`l]J
:HhZFSfb65Fm1FV[8ao@C0bTn>Yipk:QoN\k98>FlS[<0f6nQRchb^Kp``bDbV22
lnXi^\`3l7J_^?CVg>J3058iTEp0WFF\G7YH89ZGQ<9VmGifEQTL\:W\f\hiO?Dp
9Vbd7SB9WX70dYXGKV;g;\YNX=J<_ZWIK:abq\BG\S_LBP=:=8bUbcc1noW[k7<n
FDUW<MECnfFlqkMi0nU\e0iNF6AJB0:MK22HQVl<ILjCB?4Lgp3i1lR@J0U=A8hn
O3e7lMcQ>2ll^A<nV7SQ?RM@VOQk7HD23`UoqG<cPI^Q@`C[QC0[f3@[[A95633\
SlTVD]fiUi6_IW=T>j?g]qlgO=Pfn>P8jAHnEZK4;=oQKDHglih<6kobQLYUfd4l
OEjS08VVaWPHZq1C<Q1<NBb_Gg_ek;O4=aiMdb2af\9Y3FBG1m]16XYVWq_I\e<?
b_M9^][8=fbBecmm9lifh8DCH]_Me\MlU;GYKc5gZhpMH47fM`dcCKLn@5aHFd:R
99EE@jnq\^_QbIaO8EdhgS7<8Q4oe7?g6fGU?Lde:NjhDl6jpnao]\2mPA<0V;XQ
8BJb[HFQdGHJf\FG`ZX^EJlI^eYC7H5XERCqZf`gk]Q5>0iMQ_4nJjX6^RmM4@>G
Wce^N8?:K3eBjXkFV_N@gR68^d^M[4cSf>VeZR\qUml^1eiiG:^FdiYfNKUIFFiC
l=?65keIg;0=gdeNBQVTb9CSofP:q>_jmM>g9Deg\5^;PN:WoXS=1B@7O62UBLV2
;bE>;TP3MjUmPqY]O4C_F12QYIJ1P^MY[>K>D[gSR:C3C;:^flfT;\Ah@^a8elpP
UiSO\8iIkiV<h8Zcfc;Y[2SC5KoZYCnSEOFk:Uq[`T3JN5fa7kL77C\N<^b;M3HW
aUV[7PeQbae@mAXF6qn9\80cA4n=BVG8aE;Q`7b8UmlMjV9nWMCGiJKl6a46WqaV
QP1k8?UBo@k540L<C4BN@F90X@jKYjh=OXLBf:^D6omLfGEgjTa0p5Z[EA=lLo\C
MSKQaFD19B:UC:?b?N57=69SZ7Q;V]hdnf=:[c:;q@X5S:Z?B\Dbb<DT0\ked];Y
:cl?47g9aIYk3If1jPTVc\VRpHdcc2jN[SV37]D\]KHl`WP[S<\M1Di4VGa>79`S
:Mm^^:lEH?aICDGp025[DVfCJ_0]g9P9h>Z[YAJ=iD@DSG>NAf_g>J26>DODo5SE
_mK9a7qf?69E2c0<D>9SJ:K<fcS\M9^eBO1dY\BOEiNUGHUN^Rhb<6RZ7=pd9AYX
Vb[Eg^ICK@RUFC;dgKGaTC;mAA0S3<6m2pTTY>K5?3ihFkOlZAkWp4j18[LC@`ZQ
nYW:3C`6N<O<NVmLZG6lW<CN2YliqHgk\EVlbf<@YRXJJ2EM<[lVP4N^70H>J_J8
_:Z>h\lc6fO=[BhXDp=5Q6O@beaiZMbfdZC\J@Mc=`=GOYkPFbjJCLEZ87p354<d
PVegiO4gnG[ZbCqGDS[KTV63fFmb1;bSCcjW<DfE5[K8Y?N4EVf@1piGkd7ihRLD
;WZT7cIcCjkn@kOHFZER9I7EcVJWqMK^W3EP@Dlm<l2_Io5OEF^Rad63J>^:MK]c
Dko:\;^PID]Z^PWpf7B2RL370M<j:8bM0Pe8I_TD]k1lCAHgnMEiIPFaOJ=SPj^I
NQpa@26iCQ8=HF5cPA0^SPfm^JYkjP2HKD1LRhXi<KMGn2U9bXA^V;OplV\Fc1X8
<S^[d]o`JiDo36eMgG<R<PT<]U\IC_:G[LgT>QpicA=QS[Y?eFDOQ5C;>7h3G[PN
fS5Q0JZeTKA7D^bI\P;IBq`H8io4Z8O[ORBFSkN\DJKT;hA8mN8JkYGmUS9d7kZ\
Wp>8j?ThdPjYUNU;@`DO`oChEZAZ5hk\lpPlP3kDNTJQl9H6Y[5m0iYC0PiVWXhV
31LQLhZ8jWo^=p?NZf<YKNIK^4dai<?E=;Mm5:ckhani@7o3SaZ2f5>oa<q1fen7
BT6=kf<EoBk@3[80mcBf55<H_2OW:j]R5S6qlhfL>mLDeGn4WO56:mL=0E3iIiAH
YYeja^jZV4?FqNS6RLmA=IPgVf4jQ3V1dPCOmO`i[FG4Kg^ke;`?i26pjeCjRCUW
MM;YN=bomiBeYF_;ooAR@e0RaaWEZc[JY8T;BI8N1Uahp;H@5kl??^<0]f1YYR@D
A0`G2YkJ^`hYPYnnTQB>FC>peVEaLT@:4nB9MNTbb7NkoiCqlV>24lj`=l?7H1QX
2FC\C[q_k`lON0D]RUnVP^X<73\B>S9IK:mUbc=\g4lQcMWl6p[U_I>gdY@b=M=O
;C7eY6m7[qomI_33hfl7k6dNE<K;8RIdS^H?S?ORS89[G9<2mpAo;2haPl^3BXMN
AI`cjWch80119k4>7Z2j@eqPP^^6nUA7[5j>XPW0aQV\>2FB0aqm6h1@f@2]f?YD
^7]1Mq]bkYe39D92@?l^Id41=^26=_k?qe81KULeTHIXKeTUO[2W;27GJU2LqS_T
@2nYoee\C6@>TI6aCbZjI@]:maFCMjSiDNl^8L:UpTjTFJO2QT\oWE@E4k=D6B<b
ElL_0W:ShE_Lgk9@Eq`]Y6l0FGo3bEke[>]5;oMalEb5KHQEX\LMPULT\mjTMI9T
kqmm4H@Eah=CaUJn=[49oWP5@989Ih8_::Ih\IBXb\9O7^Io3BJjSF`ZYEdS7mE\
3i78N7lbHbPT^P6[oDXZ@Sl4\CihpGdVTJReEZLj?\RgIKXK5QdWPOAM13blWY:p
8Bf5fYbm^3]@OCNBS4@dS<ZAf:5^akeCZG7^7ONjXRRCe`6OH1q=6DUf9kE@>`KW
[?]If9XOic[P97G:XR8ejFDSD7BS5P8Mc>eDgGNADW^[=jPiJ1AV57q^iP9X>LTb
lAgeK5m7gTO7ocT@_YS:Cglhj3UfYMYEO04n^k3K^p=MdSSnbXK`U16=cjHgU<6H
RZVoJRFO^1I;4i]7emoAGGWJ5HSBpNkHfFagjfb51Al]n@\g6F0]13R^QCQWCq?V
4WT9iS6b2E_49QYWmCnQ2m1jZQh_0bN1P@NX>:BcM^]^f<?QInq_Ld_G<FSFbb30
S=I6@LB5:]^1n\UM2GI91c1kARqC]?Uo03aV;3o^jCH>`k\[lWj?6W<:`^;^HGDZ
i6I[<aN1oM82ad2<<C\p9oZfBg2l]25GmWRIZ;>]N2?jXd;^C17VP>Z;TcYfj2G>
anCNX>^<22qBWKn01R0\aJaW_g<fZVo<j1ki<KU0DP_1F?<PGFFOel\fICSK]BUZ
=<pBJ5l7kiQ]K^EAQik=76^_`_Y7]g_n43?]:eSJ_;^Of[6Ah7b:R9EV`=q;85[=
4RnEi`H@a;kl_<NV?mBbhNA@1pR12FNm\S<KPKO`gG_DDo0b@@nOjhD<95p<H2\6
[AkAV[YSR=HDif[7I_K<STkeJLKA]Dk\D[D@`EWQOjM=CZ]q1W>C9o8GTL^6a[dF
>h8d3f2VKQ60oB>Vl@e=JEPp8A]?hgi_ka^3F1F2EO^NcNI=d12NT]Kbo?Vl<Z\V
hkH?B[Vc2>F@XlpX[TdBHXinkoh9Q]h`SYB^OYXn=VT6M:URhYMcDTUl\BdLDHOD
TQ9o7?qN<gLY2;6U?KiHoS90NTom>n4Ti^?aA8m^`_0ahKRa9m\@P:fm7:oA1qoc
aGY]Nm`H@XY]eB1W<`7NV9^=`gaVdiPF68:nGbdWNTY`hg1H3O<1p:QbV4HIMB54
7A3@P7VWF[Bdh0gWT53RGjDiE:lpZn5hBfiHLWi0KNk84VAAJk:I^XcM@?T0NMRg
TVe@QPI>fZ4@Ngl0@kmmcUHY>UBZ?<c_qD9kKANF:U4nB9UVCDV>Y=[?iMRoTUoP
a]Y8h\GW:\1W9ZVNZi9ep=f<X6RhojCPb5_gQ^CZF[c[iFQZ?O3ZJGIGKL@@7GKG
XF8fV_0qY;ET<FLaFJ]WOBT6mCjj<ZIlUW?n;Zk;_Z>j]OJL`L\SS:VZH0p\=FE_
dlJoSE9ne:@em@f3IKU2UC9<k8Y?UC<bZ5n]Co?b2FWlGAq7SORV4?NG`:CN2i1h
20\eVXin6>gBTkKGAbEd8nhb6SpCfN8W4k[^A7IO:B>AG?A^NG4gWkjjn@mCh2^U
6bDo>Z`d0iQDjqNiEhhK:19WDE8e0YEE:R1[Y6l<_TAHWl^Y]j7c;=26TKBTEhpA
h0ekgDF<S6j[457^jIJI\4?JSJmVPQQCiYaXUGhe=^X3F7p5cd`9Z:P59IIG2IGl
RJdVKP>>^LMK7VG5:cT204N69PdCc:M@hpES\jVLk1`_`MI6GjR\IkMU8:9PcSVe
WggBj<kneS[aW?[bO4fiLZ_kqMg90_fUHJDM<P]ac=HRTM_IYlSokkTbbBkgV3Jj
;d9F@Q>KnZTHq6Q4L5?@=:dSf=BB\YnH9DY1fIa<E<Y?b;_PDQ=qG_V1ofIQ9jQn
iUjPIRSnAmTUCm85mW7f9gO=0U\a9\LaiD5beK\?`7mpGC<>D<FVdocgKeP5O1>R
[^m62\_TaSQ>=85e8j6XWMIH@iqKee6[GOUF6MAMLbDRJ\Tcf`?JTdjeTLZSAlc9
6Nj`:L\PP`>O0H:0`pl]nKY:^7RJ6>gHbXkW1qAiHPb9UoU7iI6gB8eD1mbPZ;?Q
2c=_[X:4:6NTDka=3EF0XB9^jHqY5M]9YU@k9L;lmdO?7A>jdModJ<\POI?GWHW9
^>=bnJYP6A[dQ^i`?\P<G<Gf9nj7RqSQ:gndOW2DOZ4o`P7Fmc8:M7N0iJ5md>6M
F[o<MpS>fm:9?lO\1<7__ne5j6j=PfHiO]jR2]VAmai1pNfA_RTK:NIcS31WgAZe
lh2fF6ZkNEeccT@UYmW:amHmGWU=V2;bDc`[LCnqbe@UOLckRR2`GWa:bo[]8P`A
4[LWF@f]qHb1N>YcaElRAeMlha<PYah4;6jboW7dL8@1LSdSj]>q;b4TGlE;c8LO
ITff?@U3FFFf:PS35bRe0nHFjN3pe?8I6^[NW>j^_CR?X:3W3<@;\2?YF:Z\Ym[3
b]B>Y_Xqbb^Bl<ShCT\NKg8faWggXo6?[I=K_k<IUJbVIQ^ZZFo?o:1]I8AX>@LA
cDq@l4h5>]f2PZje;@k7Omnl3BMDj_X2hbAqT3]Rl2Wn;HBRkHfVAFJRKlBhK0]l
?3IlIM:nbnq103V7AO4I]Xad6gnbOjB7^S?FkiUXm[:=Y8G?NZQ7SpU=eKhRA:[K
37AVkCI83LCDMGY4W47_df`>ETc<SUqA?Kc]L;Q;=W0]`]4]b7F8N^BP6H1<77K_
V[G32QcQ@^=7G@Up@@LQ4T@X<cLZkLIHe1;jJY=qaC[R^C6mc[O\07eLJfQ2abpb
K[`ch<G8cU1>G0\h5QTVHUpbCDfNh\`UN\3T\J2e\]T<K5d2hbp7IXaZ`0YhCBb4
`@Ob30Xj<^NoeqWYHX4LiEFQ[i\3^^5;`?J07A8KpZA:\03LcPg>oH;8Lk<@\goG
Ub?DpnN3Ml0^kGhC0N`kYWFao@QJq:^R`3`OS@OZ^G3nocITEY5pA?8gHb6`S>gj
GZQ_15[6h]JBlW[Ol]<:[Xd=T<QPZMUblbP_dYKF^BTqT[i4fRIV=COA`_DlJa7Y
n<;qWF5;]W<DA[_Xi6]i4JjchiON0Bk;k?kcofFbnacqM2:NlhaD5fkTaTO7PP7Y
B>I=oSnI7AG;<np87CN39TPKCUQD6l8JV5oM0\lcJ3NKWh=DJ_:9aM_3A9l@?24c
;e]K4N_hOI5WRe@`bK2J5BE[XP`BKj<52q6AQ8M0beRTeCWNO04a>60``=H=q<@N
`LUcbaW:L@a?cN3AlOj74ADm`lnfHP[K4B<;_OWp127Y4Gj:6C?1>Sjca]I6ac`_
3^KXHSA[VW=HgUU0KGLdMjVp^@=Cc4eMi7^?0ZUG\60cS6Z3YnO04SIWO60A5KZH
`kO4NRg<K;e[`\D>CJ9[3Gm1M30Q2E=WR=W3X;dPcmE=q1C41PV74gM]B`kDM_GR
L6O02dReH=H2Dj05dE>Z8]?]cQeol[EX@UFC\BLZkG7d<`?782:qWIgXRl][bJm?
8GciGGJH015EZ`ldHo:^2Io[]cphcQPjcU82o02_Y8844JDo=YaqN\W=Y^d2NZTg
6a<`K;BS^TMpQJ0PYh0?V21bhnd4d5XaY:oLpX<Mo:093BSXK_@VC[[9a_GIEI;n
Ba7L6Lf:IHBECVE=5=e]F]Rqoe_aFBW>:]EElnKP;mdh;>bkcEOHhoVC<ob0q[47
I@AmjTA2UZC6W]a7GOTY4OPk_c81:5C^gKj>FpP2GHnlBoTSaSA=4FEoi_=1NBpi
8@ZRk=1GkJ\0D70MLj9O9jqhA=0^o2[e6lYSYh;^Ph2>PPGpk12S14ol>f`\JQ[g
R`[iXa@T@CEd]7JhId^2f]:\=1WpPUZDbVR<E[`?dbA:O8iUP>bBB4KL6AGU]8dP
:1q=3Z<gTKUho]dkOh8YMPi047gZ0;7UgM[VJWEVPS3nf90B2iJL2aJ`@;Z<]eDj
N^\C[X_`VRWicH40II_d\ccBmqGIjE6e?gIQ`BLg@Oo6>H=RVT<cqYbkkjI5`@3I
W:NiIZ9\B8VCF36H5eCq\GOCL1@2`=nHRKl8SlgnfLVbZX=AlZfB\bkDI41]?3cH
8Vpn=Qj7Ij\Hak:2Z4kM<>18]^6_LR@OD8;9DXG<9?cc9:Un:7K@2gp4FhdEO93`
DgK:C3:qI<`?ib>N4lQlFONH5e\DX?cG<g]mV<UcUX5fRHMTl7]3HdWGBHUDoo1b
TDM>g6]W_075[JnmO2Qfd7fL@8idJ^XLq91TaPUm>nNN?e@\;B7`N]i]ZJJC^q6R
n:H5g:f;FEk2S0]OHD6Z`o:Pcpd@ZXMS@oE=KfHo3]b8S5i:k?ekIKhT9YZ:\\qO
D_TlMI9R?Ad1PiLFbkl0YG5_3T:q99MDWNZMabfE5F6S]fSfdcT:\Ka6>Kk@VXN`
:G_Q`0kJp8E5dnUeYnR<R3fQVI[>;PO`d8\D4pT<41cKd<cXhTEDjl:k5YbGJaB<
c<^1Lo@YZ4:<KF^_4QHAfHDbqlnEbGMASHN@Y0C;5Pi^\=cFlSV<pmPLI1\aM`QO
S=ZbG:TmoW?>7>\mEq]>[=_871UIi1\SEdPiD4q1NNEV:SdFO8C339kgC9JeQZE4
kgC<KeGqG:he9<]VEMSGN3A@nAa3Ui:m]D;hj[[Gp0@dEIN17:7EISD@MfK?28Rk
Vp1UR9iFO[To<EX^IfaF7oT=n_YDq92jo@igM_6mE?<@mFFCX1QQ=JfdTA:YPa>7
p>>:Kf7BNCYUaf8gDb8h\Cc8eF>fpDUMm7?U1LE>85En1SQ@]n1?]AD\[B?2EHn\
Mg5BA5@jfW>ZCBQU\nifU922GeT1BPnl<n;;_;G>Xn8JkcJ<qKXQ3HIg;FIa^ci4
]0T8mlQW_lemmK`<lY:_pnF[_M03d;@Ii`9GenDZZTn@ZO@P9iNJ_O]\03BqV<KG
[NOb]eB7GW[ClQ2Yj>Y`i9Yk1mAA>R=B2g1YG3]00JnHod_8h[dnO=STR@k:pD=D
Pb15PI3>8lh;<]L6]gD7F]?Rk]TfVPb_e4WgN0iEEeZc2>mKQdA4bnP_EJEJUaod
OlU4N8Wj?[:o3Cg2dWCQP>X;0hc:7=2pN[ndW]O5Lf`cEAL@61ceZHJaMTlUAIEW
m?]B_gCdL?`\l35e[;Y3MA_;\fmb\\R@nVdWhHGbfCkSbDVYf5m4;6eZD=jHN=4p
T^RUnFS;<=LfUJXjYfGocUR@@=_[clJi81]eeOHamg2WNiRYLNl6@hh8i`JfhHYB
DcF4Ml062PenZ_l6BHfQdi:E\>?:0`3UC^d`GOgq]\0@<hVb@NeSL`\X0i9:BHg`
==Ygbo^NeZa^Lb[]UjU[O7BAPY\NMc<33oDC78XT^^6H@B2T`MfG5Ahc@X=bi^5f
Z1CcOe4G`h8;9E8]09W_NaVqlo:@m^gg>;WaGFQE`8ZJXSNIgE2Q3YgF4VPl\298
5<M8_J:WR:a=4oWIDSJf6XanlQ9HK=caj2JceZ8SX2Z59a\8[SSdQNgMcB:1SQ^@
HCK=EN:Gi:e;hE^pCl\9CimjYi3SbD04=:NOW1acT;;KV:FV;L?R^]L6C_eVQHn]
42`8DCOdq>cGX^_3lNmAZZFXS^FF9>PiED:@X`6<VB9Wb8@glPHC[5amFI0dWTh1
Rl_D;q>T9G=U3EHBf=kngDbW1SeYaIkEd]IEd]GnQnMFg3GDW=mBU@Ke`Tc;;7Z>
pXNI=30F@SA8=ZAYogf@:[LYGA7H[KOFIIF>DG>lkTjheq0[[1Z94Y[GUlZ@Y1E5
\I5NjndBhZ;nn[J=DMq13b\__@=IS@J[VB:eLPFOVQLOG>PDS`QAo_<3V8hGOf[U
i]iblBqac7O3@VF_^Y[oYnmb_MDf9fRGE0f1kH`LdmnP:lHqB^Ang<`S1W_<VD^M
E]adNXFXQ0jm:URUC^N5YT<SI]i>XLf?Q>@\Ho0`0Ba3V9kbeB08Onhp[85\i5mc
0j^@Xf154RR7o>>h5WhkmccFZOUae4`PgBnVS2?ToaPnB1Up_R3K8]KhRR9Kc1aQ
8\Mj]PHSDomV;cLNj7enXU0fdBd0Rljcp>QB2ATAANL<jD[W6Ik;@o=Y=`5e`Ckp
P;>2io`5S;]YEH@ZG6=P]g?8oKdUMfXpbAKeYfO21im^IF=1nL7qaDh\c\ZnFjh9
FQDhRm4k[I^DHfHTkPV[lTWj8Y;CpefLlXooS2G\2hEjRFfZR\Z0lgG<TZK_U:UQ
I^mq6c9gkgO2[3cGZ2Vm>5^jhLe>InDb8M2^mNUQ[XJaqCc3;i0;;Yb1\VBf[lK>
d^6oiUo3lD;E;04N55aDXFaaqKn:An?h;6g7bOdFD\n]fAMC;24llqO7mQFB4d92
m\mAlFA_iA23j;LCpCj2<DB[>kSL\>Ka1O=01NFn\KK4D[RW4:Z;Y\oN5p2;TiRF
@fPndmJBg@c8j13E<3ALn7YoldXW]S>l:V_j?qgFHk\n[Ommh=3^>N62V_\nN;:8
9AGeMenPamlfi8h<MLMEc>pK>[R<_KkWh8h;fPEQNQ<:;1W^:Il<8qL\_Ymo6I3L
6Q;G`al84MaRgfPnqo3bAbBB1]d=cNY=XW11[OSJ7?Te[<i_1\5h9kX]M`aOC;Yg
YpfR:TP8UKJ=aa>fInc[4WJfZ93gh=LMh\MjID_BnQYHC1MhUqoh?lnaKPK73?f;
bSXK60]OPJhPHI_2Z870deeLM<[>]7NK=]LH2KcYflkCJC2YAmnlbc61QJJ8mL=J
0OCNaYMYS@@5TiQM1MYXI0LdV=[O]<215I8kLqNMI[`cie<g0UUlPPo5c:7>`k7i
d<cgdJ<ZIVhTq4OJ3O=oYiCa0:@^X=K]Y<3mAWAjWhJZ<;9fNbYZ<0EGqG4g?c6N
^;<eZNDP1To7RbgbDeAdhR53L_n;=c[31VObq]2\od2WePZdddTd9LdIFkF9joQg
>n4Rea<M@IoFXLNQj0U8Jqn5jHkVkl0<Ca7i;kGSTh5BR_k3`fE:NNdd900546e^
`@Pb_Sp?4:9mF_22N^I3R<`QMlgH`[B_l6cf9EM?6S61_q4F\X;Ik6;mJ5hl2RWe
[fN5CZ<5@A7Y9ZQXP<BM5AfK8311:C=nQk5Gdm`9c;hi]fU_:q>SBZ[8T47[XXc:
6V;m?XWlj30:9=jGMo;Xk1\3JeQDHTWD_hU:`g=io\^GZ]`fb?^3gT44q8S_GESb
O4[O?2;K^SYp2JCJ4RXD\IfWHVXbWA_@LUHJ4DA3:POHi?b;Nh:XoVo?1fh6ke^7
OehPhCM?lQp<nI^:XFMFC2V[MLSN\7mO]<[JSQ<X69L;aUeb^\aYFX9O:^]VbmDP
J;=5K89Kop=\QaIG05WC:Gg`7Sb][73F:b4>;UUKa<D9U@ab]HLdGYG^G`0kJnjo
MZH5Fk;0p>j3M2l9@@>DdclNkF9SYY]Tkk`nXW79h^j?4GRnF>TkEO;0_GC>?2i:
MNcbU6A`o@H2dJN;V6IYpAk:KDG1UHB>S>EjWO;H:i0Eh3E@ieKF]1P7]\`=Fkk_
0<O]B>6\BDN9kj]9>\eWTE9<KclqNfZDjZ797;CZBEh?3IgC@FK3`ZHD`DNaMOLO
lK0G:V?Kf=gk;M4@jTAYqUOe2ga>]:T5XmID8]h4k_gCnL];I71B=i[L^dBOjRin
@WL\67c:H0HJ]9^Z>XkVOfo?>WJq5T\:EX\[_BkI`_XOXmjj@jfHL^KfoWK3AFE\
neeTTm0HKjkgYOkbB2<Dp\Kl?kP@D2biH7OMde;XMKJ:ogP?7?;7PP5EKnLG6eUA
2APPYjH67\Wb1Qb^qkTP6@HOe_C;cXN;EiO;]Y:[_T@o]J^kJf6XkcVHoXkH8LR[
=>EgiL>iN[W:p];:n<WO^BJPi4FQh?<_ifko1\TiSK:7L0JY`lji^TEcM\:7iIGK
06cC]9ChN@bG=0@9QmfcBp<ADSUR>5aXm_lHLbc5WR3cCkLRRkZ1RDljkKWfS[a0
21L9DZHa8CDC3cYGcl22_LBJmGed94jF3B?W9XM`Oqg:FP7MNG5@?GnbTJBH=n:R
]LcXI68cl_OWOfZGJED:W]O_R9a=`4^4O8n547VA[MdKJJ^MA`CB=9RmfIqXDOG>
I6EeF1G;3FEk5k<^jkcGU[Z<a1f>AJZR=cT]WfDRb>]oa7<85F_Nb0K_5Ag7>Zn>
>U74_\lLH@6hbBBXm]hqV:\>e5V8f06l@J:WoYO^5SeEPbcH:OdZZ`qNfd:>Gg5P
;58_hhkmZM3A`1:a>81MPCh2inc1ZHjOb^VLlOdSJ1<G[bVLRdmZm?\k3lWBMNDB
OHT_UDBTkCNO>jDa@UB]iRKpLFDW<XeXLc[El<e6f5o5@ToND1KK5`POS]0n76[i
=QAU>ec0GG[R<O4DJJ=C2I3?J>4_2AAg5Nk8Y<ePO6@3bCS7[LU83FQQHAkX52gl
pi5Mo5cjNSGVnlOcCOLNLJGgicHiX5iDRSAkma?0RJ2b4[X4ojOg602mNh5A25f9
je\fJiHV;WZAShXjWD<X<Q^1[UfAb=AF5[9^c=F<2<TaqeOEkmKfRXOVIa]V>V^<
GCZf0lBTJZQQ9EECHC1>E<eO\g;3n3G[7@CG9^SgV`iRioe[>MKEmdQC=Jfdg=LH
`mZ?Hk`CgQ`Fc9L\oYZ4O?NZ4`M[L:cSpPad]89ULfN;2WiXEG\NaGe`T:LZMAU7
EEnAUXWNg_VU1Goh_F^lR8cqVoK\_2m62k[DUYoPehgf?]k7iddiehLCDHLaXK3m
Sehp1SfUgFH>lN=QW?FbETVCk[;^KP14mlB]>6[IJFjjhbVYZVhJ_Y]Tl?p>gi7k
RR@fIYIm67monYg2hVgh?R8K\`X]_C8H:7?G?hq]`bGL@Ng\=bRo>Q0hliM_VneT
O==kKb;Kn>Rh7e^edOCn2mfbd:FEbpl2j;eSY>MkQb^9Y01;=UZ1IIVbWTHmV@P3
e76JDj>]Z\CbahCIMhbckJpKiDXZ_ClgJH=Se@MnSEGmD_dCWN[C2ETacMMV4<5e
N2DU6dS[;7?HR0g1@dp[OB[@1WG0Z9@cgfik]coWha^E7VPLQlnDHE7RBX=4BIKX
dldDOJndAMX:OKMF4k@I;2ZgYqJSLUOIKU?LFindoIP@WdjD6diR2>;8:G9^\nD6
eA`OgJ=TEAZkBFZ4M[4Sh0A7glYQPfF6qD70Ok??;0<lLUkYAL[VCC4QjYoFO\EV
>4jP<ibKPO0g6B07b?LPFoMRoWT;C1Apb>WgC:EQ=7bS:@@24I9Yn6jdU;8X4V1g
\B\7^3;\:GXa<RDmg477oDBT<m<;Pakb3K<Z>L[apS049Co8>6YELTh;mPa4WQbg
2LNZ=l=e0Eg8[aL`4==A`6B<GDZXpOPe<9HeQhnl:PTGoh2]FAF7N\<l\8]S6a9d
nkWnZ<R_Oe2@4<=Z3:47llMNPkfE\T@oC_8n2qFAkP=e_1=^IZG>FkEV9IWOkI;N
EDaDHQWU]_nL[Hc0fpUgkf]<6mZa?jK:1h65H>V43;Z>MOHZb7D_0meR5>dln?]M
NN[DN0V1pIf7DP>lDiNHLY@FX28b7n97`lQC?hfK2@LgEc0le6aJ:4Q>DCTJeAhp
9HSY9=[]4Ul2cO;nKJ25Z0eN83KPRf\MF_AGl6Do[B;p9c7eL4@W]MTIbfR2DA>@
:Sok8hi:;Mb`g9ed\gfBPB@WCm4cefCPOnp8_cJ]6TPj8G3=1]\9i6a>K^2QLnfX
J7UCCn77mNe2Q]`5og1P\[056qV<^iYc1eY`O9XBX?`<qLn=Okdc5<gkQOkQbQ=1
7nfZVPi6EBXH3J`VEkZDcR\AS=hp<4d^h<9TG>JIT>^=45m_lQXMO8^_\=_NC:J4
dWYe^N4BHhp`A_Q\mVA>G]g[?SLd?c52eZYfkP:bIZ`3]jLABTjb@jcKg2nCGb1>
O^7BBVAN=qE`7boW=E38O6RJ9d^WZ0oPI5[5P5O>VYbUSh=g3VXk>[21>VF9@BSA
4UOIdA8QpbAQW2?e1L8P=?f>:W4gZ9[:2G@HB_4N0k2nYTk^lG79XMRpGg;::HV[
RPoi?[ikkS76bk[\<b]n=4\fg[LEi5ka0LFJJ6q3ACTnbH;U?CebDc1hKKRfgXo[
I?adAfUga0IGoD1P^ElTBp@`Ye?HJ5^5[V9FjmLJcJH8:T?j7cJ9I;K]ga2F[Aid
i0H@<7GkkO=65k5bIq2nKTHoI]2mgMihd0Uc>R`<2[O6^cMRP>OMgF5BDmb^QZT3
dl\hP7UoC]pFRcYQAgk4>fVS4513E509V8E[1`Lm@iP[[5N?<HlmJ_pS`9HPVFZ[
53i>blb[`Zm`minXK]6G`k8P>lF?>J:=5D>5M<0Y]I]E`9QD5dVoJi;377jRdq49
9<\;0_ZT]LH@SVb`Km>Fj5Eb\\0O8?S`J<i;<c7ATK1boV640:OP2mHX:Y:h4_J9
J2Y=paO=O94QKbFF=o6A98UVBZ7YC\_2BHE]U\\C89H:A[FEBj9qCYNgSJmJDXUl
XM`CR\>Vm8=0B9O0<S=aDce3N_;Kg:Q5EK[[?e7Y5E<K3k:g4TqVIj]P3_8N>>8f
D:KiB8VE\;4VG?qe;XHi4dmnoPmXPI_>YC:7K\[A\cbS;U0limQVBB7JIiHVN[?8
WYJg:E?hjYqE@703M[>=7X;7c^:^g:hH5\AJJU\2=cd?;4^lK\iGmo^l7A3SEjFC
Q3\=QGgRY_GZ@1E;aqk@?noQ@lcc^Af_7l5GF[cH@I;ccIdHjIE9fc[H9AqS47iK
:Ao=`_Z1SU=>jnM_cb:70[]NEC3d?`O`cCInPY5i@;IjF3O>6qTfbXNDk38Lk4;f
:8P;5YR4iKBn[XQ9kL5=`2M<6lOXipJ\LhG?jGhGdaZOh<ok;PTiR=PbbX??o`dH
odK6BYp:OlK690ZnVo?VeW;J>3aGU]LW7CaW7M3iZ:\S1\LZGDRAkN60mD]dh4Hq
eACIcP;T@I8EdOI\Ae_o>9>[b6Gc99_c5@>abJ@G<9C6IRn]CXEQQAfG5@PA^BpL
IPX1=U<0]4M24fXe]\OGD;M`_JE<Q>Y;;]1cUZK1M4KeZH8fbIQOol3<m`IABigY
`Wp][X:AZ1H_:>`hbnLQEFYJ4iK1oZ3VJ1`gKJC5:5V:V0]a5pjGoNU[bmF:VB4;
g7lWckf0@BdkEQTWU5TYOh]cEkLfIoi[P?LO:qegWHTm?\iCJ47mYJIQi3<E1FKl
mX8?D^m`5bm8]g3UGVZa5L>D82odB8GmpM6Wb9KjaXP5`>oZX?bM7UT6d>ZIYMK5
AK<0[Nb6fMjUMb1[I``mZ7i@JSiT>>cpHVa:J?@UcF`IMB5n0B6[e=3GH?PC@6fW
U=]eGY7EoUVDe?Vdh_ZVZi^@c_NeO_qk9\:?aU22XLl<cfLRYEi2T2F157[g1PIK
GTD5IFSIbjTS3K8=?Uf[On39E@pomh\`bDWW>?bcCNP5A:NJHPO?ONh8Q_8kM0UD
B<hi6HNKY2pXbMLn2^KRdbP>7QZdG8_kRVUSX7H:i;ZgKAB0IEY1OdJ1f7aYj0BD
YqEl0_V5a5NS=LYXih_aXZQEnhOF]2Vmg\=lKM9G5V_8an\`Pm>R9;3@8DQHApXE
5\?e62_lk3eQXGi^7Y3CQ?i?Sik1DNDR_`?aadW]SC>ddfc`iT?3;]JB<p?33Yj=
dGcSJT]iO=6dLR_<ZnC^;X36jNQbeW^3CRol0SM<_0^aPDVdgNjCCIbXp2>X@fZL
0D@a?4L^k4IL<NP5me6WbgFiWCjh\PjNYHX\04^fTpg7B9M7]4BXOT@\c7@7N>gb
`W2\ZB@DTTnhW7RekjeBBq887ALHTCHKB6^C3_aQUEL[>N]:MPNHNTD5oU7oIXK8
\[M6:mfS6oO71mqcM=_@k:;>@\LFmp6`ULN97Uo0J[gWWO@nKf<XDVA@RLMLen?7
XaRDK26llNhjJ6]]2]g2p1hJCEd]?YKX=8cWo4OI`1i>B4ca2kLJ20LFX9j0SVnQ
T>6WM`ghqJ<Wl`gXRHcBBFMgNHM13^Mhj2egVn0HQD=2WJ4[8kUoVRFZXZoPpLMM
:Ke_<1m?]88cd\]g=0iTRCfk4Roim55caVoEC4Z_eVfi56UE^\_8O=N0gH\CLn@d
\B7kfl@QpKgJhVG0_MD<eBQPde8\Wd0HM:^nTUD6G9OCC6>pMG6mgGGc@C7`:Qmm
PDBUk>IXhNjeCL_QMgj>APV2aZKAHR=]`;E=L41qcX?N;4Y];HQb6kNl1deQOk7A
KLWV;WNX4FkdYNK^3^I\g96Uk]d8Aa@CTe_QE42^@=<]O[Mp`\?_lOPN8W3ACB9A
JkMi=QBHOfb`H`VFq2SE9Ye:f]ZT?B3BX07I16?`>?94UZa2E\20ie^cJ9km7BfU
A;FDlIC<ChSM4a1d9fSTl\Wh_]ZM?g9ARTJ\^2klGPS=<n9;A`C38md[`nZqLm9m
n?NFBNJ3Glf9focC<?42KJbl[IO=H9eOl6qA_kb5R^[mN[5imZI]@J^9KA17O@?X
G6MOI`m<PYW<`2q9i\bI`LL9k4[`eZ7fQ?K^SoMRCIVbD^L[U6^On36k6dXWam[_
5df>6Gdp?AFP6HdB[\_270FDOOBiHH@O2gh@:bB[SJMG0:WJWd^WhJp7ljC0G?a?
B@Cbc7SXShc7b9ED^ao=1@H9HSUFc\435OGVf4APP]8iM1:[Pc`Yi?aa4OMlIpe6
Q?cWJ`T?_SmdNIk3_\J;1@W^_Zajd<b__deTEoZR0qeS:YX=@=]G1dB]HPFZQi8C
ThjFOOkP4dlcRm_GVd30ncYD90k=5A@eqX@XT^T;N5hkagQ\4dQD2lbO`5jS;mL?
9^Zhmn960M2MR^2hCdHF1``][?DGq<chle@BO8@HhIbb?N4C0<G`0EZGiH6_6o<7
<\i4YbaGH34\YR1X\i>lj9eTmDH9m1X[NJ5pEI1`FQcZG[9^nd;UXR4SYO:QC2OQ
nn<HeCW\>o7aTcVif2E<fRVgAYTFXHUJ>\m94aQf;8q:h4Uc4cB=<NiDMh]je?Kn
CI][MYG_okV@bUlM=2LUQqoLRCnFHS`l2IDKCJ^b2g3aMO::QXJQO5jMVfF^@f7S
8dYIVN]Ig3V=4d^Na_k1phhTbQJUHD1V@kVnmen[Y\jcQKGS6Z7Hi;35;0U3;aFF
hk[Q3S^1b4jSnfSfCl8BA`I0];mi]p:9Y6?8J=bgT_K]miKFJ_:RGdJRO_YZOb2d
lVA10a7`2`gim@m8MC_mj9PM5?6l9W>4Fe157dpOCecJ3ffi03<EdGaaE>IP;aUS
oIeNEeZ9ECL0U?PKWiqFj4QUERb@^5FX>gG1iPa:JClXmlgLY;T_RYbl8Pld?qS[
AGSJKPfg9JlE3MOd]FFAKHi`4He2e[YG9IOm4UV`jA`GKBIPBgXhqHY7kHFaPGRo
^<lM_I?358GU19E:Y<_P0[eKVBYn>MFapbHQ^]VNi?BT0@V7_;\g1OhL28DKARCa
Y^=lZb>F5QkAomUj9W0GHLjpjkl[PDB6dMT25DP>TP:SKge]ZI>6VgN5cIkM>ia<
@YZnEEeW0=V04Xp1DZFQ8LCgANfK2F9\NY4\ZJS\BEM48ciL\mIj65lnhbpcQIf5
idYA9Em_F>X4ooCggR1LCmYDRD[a?U`AZF9D[X0RN=GBAQXjAZBK4Nql>\0hMg8Q
>Ycji0bea[eR_PP@YEDBZH@P4DS7]0ETLnU8gKLm3?:HSpnB5@DZQlTUG_Cndadc
IoClO8UEn6[ZhJS=XY]`^34:Ti4YolZSUl]EpnR@E^QaY^5LdSc0NTHSkN[6@R7P
BUaQE@OhIb59glSG9K4p=U[>PbT=oW7R[@[kARPXZV:eB3ITc60P_a;c;bYS\l_0
g^qY2P;R1B3g^bhi^fY>WZJcHG:T:T10JOJAFhVH8e5i=J16j;<a\29?EMG^LbE^
MqATTeL[@H;H82WbC]WUb`^n\Eafi?81IYWCCUMjAhYG=aKALMXiWhDk_WE6I>JS
p_Ec8^?UY5K0cn1_DmNE1aTU<DR?kLJ]h8m=Ao2oB9<Xc[1UUCUJlp]21BYGgEHC
S>>JkZ5j?WbT`d@6R52?741>9\9lAb?lPARhqm[a5ffH<`@j5gJn;60TZX6kP19U
0[D2?5iL[QnNMn2lFc`pM86;bUF<^:i::\o^7MJSW[LjSRd5Veg?f6VO]VcN5H;3
61qj0lF1J?HJ>Neb;UmK0i>:R[Ci^2J;<J3IiWgdVLDHX_WMUQ2>^QVAQ[haMPp2
e5l;_827Y]f7Y9[VD=BL7>gG=FMK?8odMM\f^?JLGgVKa;K]F^=MbXjq3mgi=GnI
PaKjZY=@lSqi@8H5YF7Y0L9<8JkJdaZ7olcnF?=3Mbbb\3@;c@JfaAI5`FMRCAEa
NE0ZHQHVGT@oODgC2q[iU=BnKFO_9o\Um16e^F3WL?9aFhXOM:aYP9Z0F7S:]8d<
<fB?gF?XEjCfAZ4^1=F`cllbphPOl[H@^nNbZMUQO8hJ1UJIh@g:4Tm2EcF>XS_c
WV[8G9n<4Ne1nQ56gLoUpm9eoF3RdUO]OMG5D9^O;STAl?2T0CeET8IJb=NieDTg
U]0efaP_@8>dcIE@qI6FP9YBoYAXLZM6Md_CJcoejfUJOXMV]IYj0I[XAJ]?>g?Y
2ng573Jn>YBm:JLpAn^j_K:F9b67J48FPDhK3f_2fJHNFZ45NGY0@5T^dAI_XX`_
Ih3j0A4mkVD5m?lb^XaphY:YSQf`gUaL[Fe[@HgSO^CnmDEdS:1CoCo>`W2MEe36
XaDVh8IV7\>3if^n_dRX0^=qonJUQo4KbRoES7:gWF^9[i7YH5W]LZ;LMV@8Q]B[
ickI?;N38h;F_`qMa82W=C;_cKA`Pk1kEDDNl6UgCV]V78b6?l>8bLQ^5HH8fni5
Z3d[blp89<L`<Ok7Oo5>]PZj92:UmKW5Libm`6>02JbX3E>3AG4El`oi0dQ6BLo@
OHc?^CJqif`hR32N`FDm:dWIEfe165E6i3Ym1aQWA6nDV:Bdf:6^CTZnd@9pIZDL
AaiBg^b8eAU[VHA`gFLXFY<N]DD0>cVe@=U`ZFNgeldPlXCSN4?]Hcj:8M::Ion3
:9C^ASlVaPL@pY?770_5:dFDlM:RXMJ\>\QZ_A5AiaCIX@a_g0n<Ui6h`Ua`RQI5
7o<cWGf9;6T`lmL4j:k:9R@]N`?Go;ZXp@W<EC8]94f>jm5317YhbmMW`kIBhGl^
>EnIkfWJFgoiFYHC?8`@ZS=]X]FE\C;b=NklhQ^9cA<XplH<4OjTeS`SWObIQVE1
8^Ai@\e[^^LJGJ<=DLh7\?dl:Ho;a5HnA?Sk;laYWIa@WHUgb>46]YFfXFXp=4KV
dChJ_6>9cWDlAb7kIkbVfCW>Ui]C?aG<:]HL]SA^R7q\8C@4bQc5>flcEZeIAFP^
CUCn52kN<L_3h=om_VBp@eiO?BoC=VZEl?7gXIl<7X:?I\F9>=ZXV`AaT;=Gi1>p
dG0@C<\Xo2N?=mG[QEceh5i:G\k@Cb=\mgZ5pf3m[=CX7V`A4Mm;DOZ5=dJiHDB3
FU\DOoO[>kfSaLihJ[1Kod7OU`n\ZpTcVd0PYK\Y9iVKZX4Q7W`m7>6[>CCQ9dJ8
L<eoV3P<\HS_aUCgYJL1eF2>MFF^qk@69:FZA_3@HWG0HZ4GMLnIk`<bh4>AK5Va
e^L4cMAF>XQOf\C^KAokapP_5mKVFhc]]?6Ae1A^a1Z83CBVT_9VUdE9G3UCfQD\
ZV1Mm5\CTHPUX^TW9h2_e@<GgqAnKcB2MK;g:oCKYkmcdW_=g4dGj3cZSVFj1Sb=
@WdIOM>IV?8idQeV@ZC?4MaQV2MXB_B>eQbmQFh\\NH6d[i[Sn4LW7BbpGPWla06
0=TO<cf`NRWW`nB5gLWkhli9am=mCMaQihbKh3>J[>7Dhigo[fNPWL^ZjnZa:S@K
obULiZFUmoDXjR16DJ8mq73^`[Wg8=U`_0a0M63Y\9:e>M:O\Gd0LCRl1`VAcAC1
PeRkGIV5X=X=`7EIfOJeMb9ON8Z9bNL3@CM3RqnWf1c?YXK:96;3QQkYnN:n9V0k
P=R?^i?SMWVC3Idi4Ao3DgYKX2nlBJSNS^hc>Q68gC7g>oo99QNbIiWMS_jmLeb1
`Qc6k<Fe9ILPq525mY\LZ0K;8OmfWeACehn\b;0Fb0\A2JOEE9:qISd]jk[gUWOO
IE`9XJ`0kX9b^]ddGQ7\E_13B4BJd[dfcQ333c?>@C\3E43>\<?S_NXk\JpY<bNP
h^keVFDCfNLK7AoFJEWHKibeSa1IcTDncU<d?IJLV;SGgbmoSb6_ag77fKFoKUcV
3BP?<;3<hq<X\B=?8dLGX]XI:NE>=CdfS2fCfbcZk9nfmeP`m`FakOCWAP<Ph9LQ
K;Ind2ARCY`0>lO^:HYO03Xg1WY\`\`[qQNdSDe6NeX<?^5SA3\>:m=LOJ5O5;=g
BEN8o^>LOPKXCfDce3[0PKc13eg0R\VSmmXMbQRG^j7BC5VM8`J43RWjdi9nhV:f
?`LUH86p:15ln_T5SQf[L@ZcLMGYQQjj=9=1U8@OCMdU6ECGYgH2LmA]aPO75C^`
W6OXZUhZZDWN<XPnSQ`Ha;eHVl>R^9]:UZGd`=cBkDnq;\P[>FSB=h\I11HAA[Dc
UQ3CB_K[WMh<KAO=?\IMjoOj:S<5XjNgdWZd9VdVMMUlWogY@^NmRho]B@95A]LZ
QeXFDI@FK9gKq2PL:?hNZBX>K`D^<BHBUP24lgP5lNo3<j_@U_D=d``M?]0DJ7`D
mKCTI@B5pfd>IF91YJXOlFd2=K2E56k7hGk`XVFn979jK>`Bl\4BiqmGO^bal8:8
Tco0LDN4LNfmT3NBkGUma^k>Lon8OUg5Pl[_9[4m]nZV2V[BG9Hc8bY0hcS=Ljq6
bdcCPT:odNK;_>^Rm`dA6l:J?TDZn71Pn0<dO<gIQ[6bc2:Tejnhk1l_;5B2M>>L
E6KM@9Tp8WWbhNW>ZR]0?XRKlJR?H]gdfI=C>d[6L`fmMWEYHFbLGb:Y:QVj0IXD
70ndjaP\[\P6eDkHAmMq9_?1ng0RXT\B3di?[H7bCIeD;RK:iRUSHjiQJ\HR99PX
CmEXPeJQDaL`O5QSgC_7nTNZ\LIZXfUM6MqHDTAF5Q\C=Pm066ReJJ4jRI>JA_Re
\6mU;DjFekFPnnXJDpS7g6`bQ8;AYA1\2F_f?9gkI?O3G6\4E7Eh3m8FGb@Y79\l
IBd1A:f6pT5^G`_X?:=;6U4@0IJT7gC57Vh?MdDM5?l3`J<]GCIafZYU=KMBd=NX
\LmTqlAC1>lL`7T<UUA@D9\5ARO??kE=0jIA^Ub^;3ok]h>U;GlLW:GI[jCgP5IP
pd7N=A[hDMLEGeD<OCTd1^>eY8j=ROJ;;h4X?F<fa_73QZcX56J4PBalnPkRR1DM
lXbHfl>q7c`^^<bAkHnB:hYmGUb3Y]iZZM@@R7OjB279LcKeB:jV7PlIQif3i4GH
A4Z1o]CijUIRcEd3S42alCp]SLim6B[eYK8fo@7AkL5=TMk3E10cDmS5]<A[=NW0
_JU7798FIeJj82LgWXjZ;T`R2`^LmEcDR8pl;RT=hM_3NH:XGW3@^YBeUghEXm:a
2RcR?E`LE_opYmn4O:jGadb1a5:B3M\R3Afn:k2mcT@oi\>dlCqkmDWT5lLi`hlf
3Cfk^E0:XVn;lG\=mk>mOYVWl]U^_EO]PPl2Mjmmh>a:lDM1[pD_BAo`g=o:A1gP
;P^Y[:j=\NnT?j5R<^4Pd>adN41Gq`@G`9gTX3c_gm1kCOhAioV=SZIn^_`@n?n=
[n:R[0lU]@:OmBaVfbQHKFnbO529CQ1qJ1O\BD7Wi^@ZjnGVA3b?@GA<eeeZ`>D:
F6:?EK_Kcb0Z9W=T1o3hA\7Vci0df5>mBL`n=;7[]RkZhR=f4k;U?@k>ecnGqMSd
kM4T_Y33lJfNS0RWPDV[<bNW8k?L@dT:J;PpP[?M7HBf0;1BkS\]5fKIed5h0I1R
:WN7[hLKD7cRNlmp^Rm8mOl?;f<QND2VEMm]7Dil8Z[19;@iOM>f`@mdZdQl4aKK
=ikXJ3R`pOf;KX50^9CQ\[\A\D>6ZTKJdAVcmWnYP]K2QY\fCN1Vf8Q=CYbI2KbX
@pcI;h@o4oeQdm2>S8QQi2lemkOTlB`R1=0Z=W]8]TX^9;LkS^PTEVg5>J7[Xp^d
m`GK?WAHQ9Vkg]]\b7p2:6<TER\I`NRZYbHVN2Qi3aEmn6APUihG3ha_BneYAhi:
H@RfoTUD40QYaRDSWb3X4RSHL3epPckK5^FoTJQbLK9XbgTC37^9e8kDGLO38D5>
71XDb4NFQYCK]`iqDT?JJm[bGF3CnLcN7hb2i7`VBhm8@@\_;:?=BcYdggZc_>JP
81=q;HgfD^JcT1PEbaXJO@\cY@7REgb@<[\A5gO[SD`nI5nRPKlRQSPEJ>qXhcD[
:jJ4E0Q8eVCAZEW3G_NWQBb4YmULW^L6;MT<6cqFB@5m5^g9MTdFX9D`j`S?`XS5
2bdc=6>h:kPDgfapj`LP`B^UUk\TB3M92Rh=NGmmnUd4QYVFeehpKRCT?4:3;6;o
?i=``_a[Y6PZV\\A@IZoS2p6cb>>W`aP_]fX:UIVb7_@QiYo3dfK[Z3GXjP:P61E
ORq38VVUl]J;9AA0gcSCHgP9\:@nD26KWh<YA=OhZLX`CgBN[HiYJjLJXO<8S6pc
@Hk@0^g7_9ok2>;^8e<H?02EG6KMbo3mC7kF[fD`f0R9h;68\OiCX6QA2Jp8^lP_
HP\J]3bC=UBj1iU:]PVGIGYfS13eF7;PX7n=:Ee185J4GLLXN0MeHSpiIGP7`hih
Ajb?n9NK7`J2TncX\bf@lkEDVme43N<RiK@DkHVPgLV]lJbM=K<0HpLG`;Vd8ci3
_1Q1<5mm?io]ZQUQE@AH]Y9<6;cSVX0C09?ojcm7Qdi4QK;KLBYVFWQ:bqZe9MVc
]0m?mGQ]KOGL\^Dh1Ga<jIc_0eP>WQ0N[KFQZ?BXHP1>=UY4Xf9H=GB:XGiD0pVb
TmD2cKg72>;FcI4PXNnJNf[F?n@aDMBWB9VBdU^2M`J3X[6[dj=mLEQ9[:==^GCm
\NJl9<p:@m5TL:?n=PG1?Z?d:>f\SP@k4S;B@lk4RGcaTTg:<WTFQl8[8JD@P3UP
PWU^A9UWgPpQU3d_[flAU?1fUlpId0o]]0LS3\bS8:EHUE?=VTFTWOGX>YLMNS`P
ROJWImPPTdlj57cl=02`BRbE]C=6oEpfZLg5mRLe69mnZSN>agf;UYf5dB3F3jMN
IN143ZZdYO8KE?57YG4ooBCWo[Ug`Waj?4:WHmBC_[qZZl4ahPA;dQ]>Zf`Ce2O@
_kLo?c]<@1<:L;4S2PKGHdhE^KElR2W8?pMLMb]j:^N[VTJ?7=ge1kNG=nQihRF0
mhKEN09P?<4c:0G?1Q;E_?olP_MB0oG`_dpNXFN7K8213YcT2Inm3eZ:QNh;KcEc
`k<0R`pLSjl<cg;IK3mKH?0gY0Ubmkf@^XUcYIN_j9ODGj\4Ce<a2NRm3Oq:h7gi
Bo8[<jcMcJ;;lIb3XZ>PMGR<SHk_cAK<EZGBL7gPM]hA3Xh6[oT>Mho3BPN3ke>B
<1N69<qW0T[>`8BhVIW7IZECR9A9F8LEmj3Q8S>2^R:o6c^]7Z092o[LQaE:e9U3
<\_Lil1U76p\<bblbA7Ii78RiR@EjR`3j>LP`JF;DSDan9;oIadnX\dbkS?nSBTf
J?A`b`I@3EIQCDge5[3qF`6`l1JbFb[\M8GBh6BVai6dZfU;7D;B1_[gm?lJUR7l
mBgYUAU=RM1PPlZdCNo?pJfVR6hWa:=I?hdP:?7ZaXN1eDP3B26ZlEgdOVL[[d\1
aNL]8NR6fc1adj6Lca^XWqD`Q:<6\HKEYZCeA@<bD6WnaIDgNiUSLd8QB3KfOcjk
h_`Yn^3Yh4KScS@]HAcVk@EXP;G0@>qoQE28<MaHU2]9Vn9NEGmnH3XOf>Em00:N
C67MP=>?Ih2i>IWY\14agRZa;8:mo;17JJfe:7iqlge3ai>A:^KOl4l`Y5LV>\b6
Ae1gEfaClWkCj>abg=nEm@PZDY3q\bT>B@b0XbI?0?:39SjEDh\RTXSeVOEb0;jG
JLn>0UeT;8Ym_dNcCKBnkTdL;R[Ej[`2@JDX0LOY^K5Zp^CEOIC3]?H6D[Ta8U@f
^XcAj?EeT8b4Z53@>hnM[3BI`KES]iP]\OCZMC[>Ef3111aP^QgpG9lU?TQFH;H6
Dl[kfgXA]V;ijB=VIO@QP1U@0ZLQQDFVGZc>g;=EIY[MgM3o4Tqo;@^[RW;Wdd2J
AgGg0:8Wiie6CcJd0L=4hfVjA7FnkU[fH:Z;Za0E7lMRnEoh?ZR?1JaDE_E8InqU
FN\G>LRBO`@?j=I0:D`mg8@k^JEP0UEN\okeNTQ>8gb\iQ1]PK:ce:dXa:\BXSLX
jF=:o_m4M2q^iDl@^jD\M@ZGik0YTHLF^;j414[X:PF_SCgZdOgfU102G0leo]JN
;6`8oW2FOicPB7mi7qKcWchGJC5L3^c>2Ife<gp3UUAI:GABBSOjSX`]iL=\Y<m9
V>b\NP70_E`C1N8<XoA]6\;i9gN^CAKUO>i=YodieU<UipjYHkD[L>2m72ilSBoD
e_]]fQGP=M;MIe?Zc@9[DbH:gK>TZ1ZS:Oa8Xo:NhDC?8QRU;>O;31pR6Kj8Kb_]
n9Q:n[IZ02df??j03?O?Nj?c2U6U12]a6]m>9@E01@gBVSm]UZaK7E9LoAbk3Okq
_BiXC9Yj>6:0;K1XP:=GUj@d4jNFBTBRdNEjFEKA4DW=Ce55pkGHWjD2\KdQJ@FK
QnLAH?Zhn`7@e;0[_fnBljioBFc0FDXc?a^Al=d4HIUA?GFOlZiLGe<p9]VeUC2:
8h;]fNZ>;>23]QHBGha\MF90LFiH2]Mi@XT=5NSiI`[PMTV77_@[PSZUL=H4>DqZ
?3ni6iTmUGgP;VUm6IjZ;g<?F\]YB]5=dLjkneU>m04`:hmEj\GR3jJ_Hnc=RoEE
J?=nc0I`T2j6kXapM8\Wm5U@7:]XhA:??KlFj[B7bCC=6ZCcMU4VY4h\FA[UA\]3
SNeO>mI@QIoLkP\]PZ7T1a;hN>MBMe8@UlEqgdo60^aGif1T?5GLSI6;D09fBhan
;YEM>@K`2533>k4dQ1S@ET8Upl6W_oW]g;7l0ZR[<c>jXC9dhdSdOmm_Y6C<827Y
08=?0JEHf<@[_Gh@b1]N0F2?ZiZH?W@Q^l:IqT2gcLH^[SSA2TNa[?Ro@:>6=HW4
a\:k3?E?6>nDB0o3d2O8<TFOoHo?15eP=YeG=CCbkXmg2_R5pXi^i0B<O75U[A@B
M?_Z;MI1Xf9fU0Uk?0mH^lEYB:M4Go7agSZ^`fO?aS@=mW4[17BM7^F]7dmk2?2q
AO^gQ8<J:F?c1fHb4ZK8UUj9E]HJ6E6e<XGnXb\C4;2hRQofDnMm1GN9:_j=W7io
n0dRK6?mG:S@m@pKXb3BnUV[5BE[Bo4WLa9@S9G\o:65>GYQR07`7eR;fAo`l^V:
fAo_ec5nTCpO;7a2OjI;42IgTnY=6;]QjnO@leEdP120_YZcn@J^5LI?Og\B8]6j
;9XkM?4Tkk^qY[i6L<inRj_7VAFE?RED:R^=4`1193Ah9CCVX\cn3X?BaC1<[P?a
c9m5i<Deek8^\gAAPDJ:pWe>YNl97GYQP@CJVX?G29`5Ei=0VDc65GJZDb8oR:dI
?=IMg8D@7kFVd4f]]QPRfH34=oB0PpPCPTQha]ih2A;N0<RI6^MWEMhikiFj`_;5
Fg]_;H2X>ZEd\Wf?F_o62`J2Wl412B;M70oR_1AV[p^hA@i:L<=e@V:GS\QU7P;H
b7AXBf`g]<NGDR4_RUIV8XY5ZSD5B[1XN@]Q=A:?d;0BP[f0DD:TBb_IqZ0cGf04
oLooHWFE17LFkWclbXn:AjWYiOmPm=URR_TDNWkaA7<8MOfc60bU`bgJnQi]@YI;
k:]Gq>9YU3Cn4a5_lYPWA1YI38TWb0FRV0mSj?U<Wl]OeFCL@=SL]ijMfeV<2X8_
dN4WgeBD4>ZY6TL_3Cc?d<D[L5[9TYnIb93\Lo=S_obpl[YV?;=cO[eJ67?L?Kck
f>VeX=GqJd]5<7h33hiH^0Q7\WDfndGG`dGH5nahV:KoRBF8eoW]NfBH2Sb9Y:3R
B:0Y4nAIU?5<d_XK88iLK7B0G:3f<2WT7;EaD7fFJ02Rj7pkSlHEWO:7PPl1IL<_
mfSITnnK55?0[_:]\[@GiYTYg<hCY@YYMNe_m]KZE`mUmH>A@6i1`ph]T[aNNJ4`
d@l@gT0Ki=HGkFReCIZK;WDHU`4g_PobI8DT6Y@dIjJ4V0fNFVT0i8Lk1;S7pT5E
3__\lV]2=\AL>bU??QBPC9Lb?=WIKj6>MZLG^Z@eRN<R0`PQa;<UfTY`7CZZ`iWe
[hm[Mji^9;SJj0[_ES_HWeHLQS_qhP2IgIe7b8g9>9O1adKofXF:O9m0VK8Sc@RK
0gRDVlPMe2B5YYBILcTTDKY?OfiRD1QdLie>Oj1I^_lb=9_M0Z31`6Yo4Vqj_m\i
;QlP?j[1`IkB1T1_@jA2<FYi@EgRg5J<]G]BB]3Y4U3<XnOff]fk8oh[PUh;cNAd
j[W?Td]SLIOBL@7_J;3h^N0BFbFpnD>b]<\F3H2KIZY6:W^Bn>AW845?]jm<:Nd2
@i;1ndm>6@S`X@k5oMOW8YX@U67PZf_HNX\0UII@5`Y?QZoQ1hnfSk63>IpRmM<B
]JhULCkNcV[?[:1>Q\FHN87HVB4;751j4Y_54B:TICE4Q8ZYa_Fg6^aCendOH_a6
mJTnLegT[>Y?5k3oO?BZlbqNh=8NdWB9GZVG=oD7H=db<``E[OiTN>fXKlT=D:ZI
^?iW>8DX8L=b?]j?iHDl[k@D4kp2IdOnS<?UK7;0CLo\Z^SgL=aDY8BAKfiB2E6P
1X=L3G6n=92djA`oYn1F?a1nE9SLH?nU?R?Ug:G0Db0@JfPBFI9p3K;T_U9Q8DaR
oX:>6JS_eH7@`jDKc9VVSAb98EUa3P4Ff`UMX0KC4gA9<K1bI^GOkhHqDTk;RTLV
O@0b56e186XmlY4dAZ0JE2]MbOSj1:N\H>IW^T4bS>FARXcH>9?p=YHFQ;X5gWO1
MKM?@F\NOeYZQHR;F=3TDLgG<nG0HG]SdeRK>gJ7FoFAAWa>_Y9;;C^gDS22q0L\
6A2n9KkghNe]PCU93QILId:D_G9OYU_`Ug=8@>L=iWD_783NL3\@b?QQe?OC]`mR
\E:diplQ24g[PXA_37l:5BAj0em^5^@G\bF;S^W63l:n9W7=Wblf2Dd;5LmB1Af_
75`[3=5BohY?UN\R6p9[Ob4hULHkTNO?D[TDZ<VijmgeVj:C[2O@:3PNbJ7NkEi\
=7EF2c\g@^cG=4L]`YX80EfSab`1_Yo=qdRJB4i`=25LniT010HLZ@d_i>jF[p7_
onPNZG2?Gd=UD86f0_0F\8m_nh3nQKAYCO9l8HC]KXGG\0PbX3f77iD2QYH^Rm99
Ga5bMDdEGEY;95AQBPa]bVd7dB7Z`YR[Wc8YpQP_oA>@2\k;g40j0F@bZIN2aOd_
cS2IOVEnF?ioNZinaOYi5\6K>36KGgfV<RQc6L>2hX?q>?g6X;IA:F;efkFhec5:
dX\04WQK0[NS\emZTi4e<@1>BV:ZmcggIDCPPiMVJ:[IO=5ndD0\K\U8G?p37F?]
A8>QND8bejoo6;elG0]gCljNTK4A[[[Wh=lJ8\Y6^EdE5=G4A1jnBB@=lAnL]ZeS
mM:EdG6bK=@]:KAHdpkkhJi1iZ?i8RKJ3RHQT7=K>Ag4YF34i4>JZ4o7gGRn58T1
OiiK>ofkHK3mCS9R6;YYHS^=YEjX^gMicmRa@0KTcTa3B@RHiMKd0U^hpfW;Ycho
fKRRC5hKLciNoUcEoFOXGTj4]9:`m2iA9afgD:ej_MlHY<YUNDMNg4F5EgZX>gGU
46R<?Fe0j53;5;9V:]X6OdfI:N59paEDDMYXn9^_NJDR]9lf:mHRY2@[d32eTXmc
IXGjMogV3Mn1Uk02SYlKY`dfeL;j8oOJ`2[>ak^DaZd`]9Pj161fiLDcNV_DmqHX
YV_4\5BcZ@?27AlmCa:8:<V3Lje4GH=OnRH31cG8RnERA@[N]ZCicMRUcgN=p54I
>L;h4Y[HWN\DEF3E]W2C9:84O=hNKiK?2O>CThfVn]eD^EePH0K4^R5^<F?b?ATa
mDKhQE=2fe1=1Qc;[DYqPNR@C:68l;nLi0FLR^egg@^k]lIB6?b65a?`YFS@pf9Z
Yan7;i[OTL`_VOHW3jW2W76H^Gi_iU0MYmH2aOCLbCnjA=>5?S2QAg0K1^?pV?kN
m2<8=2YS8Ui^<;Ygcf5_9@\B[oPO`4Wa\G@=@28V_NeB[C>@cdWJFfH3eXYQpbmI
5=3WO`hiHAbXWSU^Jbe:I^M8f2Fn0iCQ<>@ZFAE58=SBOo9m\99=h^2\3W_WIhHe
qH9cHaY=VgBUFYZh6@V;n4ULk89dXG[A5WMJ>52DB55hec=[;7I^nZR^b_DbN1[T
\qU1e]WE1f@D?EF=_LOI<T\b9@a=F7deE]RYnX9A^2CcGQXKH0He`<7ea?K:bB]?
qhk]GW83KTB>L8Z3_F2=o31J=S]1bh`f0k[UoNWS\8H:jn9OHTd\o@858HSmUZaq
>?OO;bSFIdG0[h@:O<]oAb0D\\i11FhoYeaLKiAn<T97;jLbC?nB=VWBBH^5A_Gq
EH;?hh;_ika6a<_T\l0n^W59EDZi\DPmO;]YK4Sn:CI27Ro[Oih>Z0cHPJcb[MbJ
;8YO1cp>5V<kJF^_1nb0hX4dVm2A8:??Y0]C[__[eYG]?i26C?ahTlm;PEd>BaTq
VhLioO1FK6;8\7Z0L]IoMV<Q?I876iAEQBfKXCn1R6Kh2nL9k;QWjVh<f@fqGcG5
j>lJ>M3HP2=LXU6M>oUGN3G@nd@dd@86DRj9NV]P:FLUN:XqDVBPChF<INL=L4bZ
P3FYOIIXci9j61Yk:j5cg`QOMgJKCCKQBYHS_A@H3HIk0o]bF83q6<<l]En8mPBe
QEiLCS5p:9]84<lm6]jBjj]hc?2VJe]cC[SE01A\UZ3Bof;<[TRo9>kA4o;2QS]g
e5kN\_]PVQnqgnC?:<I_BggZWGj4ln:::?XkJ4>BViK5GZ@9fB0JcGMlhioP@6Ld
S^AOIaKjQ_`k5KRNi4aXCJmpm]5maV4[]3U7cn^`B?[SI>C9oa^^WD`hBZl\RYWY
49VEQ5Ee2nEUPN^IfdkJf2B@b=oQNkA559N>qX6Af_`k3_FeTaoVGpT\CmSa8\53
<>Q9\f746cKEZmN];^7W`7bTTaMK]H1Fg8D972_HIZT@l]1Ck88:1ZlBBh00I0?R
l@\KdRQVeT3iEEmCL7omOFVT1WKPp4V?fEH5<?lnZn]eRm:j]YQ:eI:coFI;?6a6
F7nqgiYUfNC63U_5g]RYCQ5o`fTioF>JI_3gW4W5OLTjQ54pc97hS=IWJV0mQ0B6
P_DDLh\`<^64[6M_U1foAA<Po;N05a>6@ooUHMY>pOSko6R41<]NVLDF]3Of6RY;
F=cT2BDn_>iniOj4;Eo5TlIVeJ5PX`;0UhAcO;FOQ=P4So4p:XmicFKLFF<<:l>K
LCaP7=flK[A7p>7jA_afBRZTKMP>Ci=a>3ei?5JcF0SlXcbX>Ua]`3aWRSJZUnM?
FTO;GYM7:loQI0@E;>Og:LBbXDdJaflMpJ3MeELJ9[lRm=ajXT\Y55UB`o3^B88L
d1dN?1X:jJU6qlUB;S:YHaX@eLS_=P<dMP2@e?0ocHRAIgY:o@A6_X[3qBO`9W1]
82>M0ZVRocPfd\a>gg0m9:ARTC6N_\dqQf8O<a2U?8ZiMJ6PJkLWeh^5BU>?IcA;
9mYqjm^iEg?7NB3iDZ0g6VC;=OZRiM0\;k:Cgo_Bj?KolV?mf?TN5g2:aje342iq
?\d8lL1b7bh@VVB8BOH6i7[8mKHGV7G^ASjLVoXQg\S_Tjdki4mFO7JL8[op]Q3<
XI3jiKk630=UKAfLX[9>:]ZPKR<PZ9nDhFBdPS16U2q;Jm6IZFO4O]`H1NJP8YKd
Q66Vi0CR5=Va]3D3UO^=Lj?>AGhpc\E]aCKPMV@f\faKWIUiT;ead`qVmOY:X0O@
A99MYHI7M19@_4IH0<PXR9nMN^R_0i;8gY6R03Ip24D\haThGX?LO>ocbAUdK5aj
X_\i?B1T_cYBFKajH\nqm=dcIEP:=9im>T9`XN;[jP3cY>7gg?@9:fDTW`KoYYb2
Z??0A6Ze?8Q8YgQqQ0mjg^W2f_Y7JLaL8h_QcTTIeECA[4BY]U8QbDG<cA\lPf7O
W?9HP?jldO9qD0>PUPY06>[ELcdg19LYkE@K\>:fcOChgT91jlGgqNQM@@MbZF9g
=]F=M=?Fc^jmW[ESZ^Gm7<=VmEjS_KG>Ap?0:b8l45L6GN7fL7mBh0N705f8_@jY
D`_nWh9b1Z5?8JH0qC44CDOkJG8X>_`h;hRFdjQL]_]XkFmm;^]jdi@1FiGl\V_R
jI?l]gK2oOjIqH:3\]HJ2jQEZ`_WIgGHBZE=[6kWOhYm8QGA9;ncE>j;4_LRgiHN
T?bpZXf@BH5jf7S]:PCVMb3\N04ILV`0X:Z?j?72>XChb7lO7j@KCfhhXHp_6ULb
>na8XdfC0NRE;NLU5AKg:E^B>a_W_TJ^Sg@ifGPM9pP4mP;A_4n6Yg[ZTLk`fDgF
W`QDViK2iBkjSeK0hEe0@aoQ;b1ZL2faM\BVoi1?Ne0<GP;DpJ`lQ16[2YmHCX1n
j=g6cW_0:Ng@AGV6^dV2gNWX8DV^:DCWL5jLAERmLV72kfOP:W\WP=ZOM3^^>^UI
jpH1E=N`g\QOEWkgiPmXR9a^Udm`1caQ3QUbN27fGNj40FACji[>51N>6Yejjql;
]6T8Y8;WAd9@7Y]<[nWSNQ>GKjCM<>Cd0boUXkd=gGIh8H5j1U@C[dlX=M:>PR^W
XH`7I0iTAE7Nq?DQa=:1<mKHibT]4NlpDCPAM4Q0IhE>VCgYiY>WIg6gF4_JflSR
mW6Y7JDm=nU8BRp6Ci=jH1_Re_n]2NaWc@fjGgeYgJVNNLMi\RIl`=dG6QdX5ma^
OkUmQp>jUoYgnEO><eZC`kKR]M4EdH0>hdGiY<nSEg]]U0aZ\k:4Wc;^jA0mI;f7
SqdhL959c7V]9gnI_9JLD2H7b<kY95dP@PUVhFP9i\kcaY67J_clCAfiD_]M85m<
jMAP894Bq;J@O;M74bDgaGEK_MPoOM9;Yab=GDIL2L2>lT4XHn`b74ZEancYDd4P
j>DMo=BEXD=C<OBeC?gC;]:qZQa;6bM4@7UeYVBRFVdRhJZXnT:V@P_l87Jk>XLT
[U:lK[Uh[haCE_>S0b]G]f>;oY7_gOU1[LGp3]>LWSUh:\oZkA9VQKa8ND0QCWET
@38FojY<JfWdS[R3=UqhIK=L?LoM20]KA6dW?=k=CXXNLA?fSjOe1eeAKZKj260k
eZElkm8KHD[kSkU^kq8MFQGm<7h4Xk\[dmF8m6EK@5dbSH3V4e74PW]kp;NHN=;2
]j7?m:8D:>iP`RESiB7e0220NiNkohXVUl9Mj@H0P4joT;^i@@7mnOeY^F[^WVWq
I6FP]oQIYYX9ZM8MB`C0^RDVmS=P]7oH[Zfo;MRD>o6O1WpiU5heF6J7i71h<`N5
IWEGT2fEZ=cbYERbOmQKY>KE?]lm<>FqPR`U>?M\?kBEk3SIX]WnJU^hg;FMC>C;
ok4Qi3iC]?^HG:Gg6X\BdPCZpHUA:_k>>Z<C0<FL6eZS:\;jNQ_Na=7fKUGH20NA
RMN9lY\dH=Y3q[8I8i>j_CViPU9e2C^9V583<BSQX<_eil`]m5Nd]5=LpWXc:\l4
6\63Okk\6h^7OlRK7Zm<j89<^P;[0>@k7CB@qQjm2m:aDom2JTEQ]C[L7Ha`EfeX
^:9G:Eo@=E?qDJPiBZYd0HI2jPQfE5k?fLTO7?^ilkeb\:DG[4J>q>Z0@FTZdoAa
k12hFFVg^HeOdEWkmOZ9Yd24FfOa`69JpmC8W?kEH;4@dc0FR?Y5kW3=IX5bik]<
eH]OkC>hHpCOm]>CGHoAZ=6:IUb\dcMS<;WoKekB3[@ZOFD<4C`iA`ABqD8gmib^
:VL\D7Mlb?c45iQRR1624E_3E<l07J=J8VL\pMOgL5Fc7;mmlZ8k=BSmF]3>;OJ=
WMAMR?OHn?OZ4qJ>I9gd4bj4meETKgK?DZDV\YQ9R1FNJN3Fj30b6=2Geq7lBDVe
ObXne7aNo^1Q88Xapg3>V7W^W1e1>TXWQBT[WD?b<CFg0lRVd<EBZDB@nZaCcYHb
6hOd7Z]9C2]52D1pMR2?I@k:g_Nb^:Y2c@ed]fhK@:N`@G_h0c^_B^;Q8=IGBeol
m9hDfhEK7F5AiXp4=M\ZN]YGEQFH_BQKMZEiGY799flnIk]T_j7Z;9hSNO`9WhVV
Z<=7E5Q0T1MI@n>3L_?0npA=:PZmT>^W?[EWmY[5NNaX?D_gYhcPcAnNm0hSQmol
`QIQa]@<kXVPJgqFI^_X=;2Q76eogVn[fJR[RdTd<O0gM\1L?6IS;[<O@fEU\XZQ
LE<]OA[OA0qVHIQba;0gLnnbW4:^Z5;kP[V9QA6@^JKfCR@lLCTP[U]94j:o5`5N
gp<3Wh>0odhNCi?I@`eAaMDX9=e3ZF=LOcSGc^^RCHnXIdGTCdcAAqPgU0]m^TRH
Lk\Ki>IVMV<bV8^CZ]5\@0mNT?blkQDJY=BGM3dYSp[ik^idRRj<Q@?lBW>a2T8@
?oI[NeXmZGi9]HT[2M3E_hfbkRf:<2j0[a59bHbN5Ro?bpK6SGY9^D1J`I_5G>DV
2HJ@gAm_T7V6BZlJI]]5gO[CZi02:FRARVZ4H[\\\60RgTKof3p3:IC`CWKn<ZeY
_Ef::inFljdQ^FR[b5cSEg\Z2:4OBYMFSFSha`R\n2]clPWBdO2gW2CJX81]j3l2
nkUcOgj[nKKQ?HRdSR?V@Pq0<?l\0^MPXMTW:8iXm^GCOHl6Zm`SnC<E3gZ5<qHi
5F<2i8`Tb0IRCYg_?`oCTSIRDV3Oeh8b:^9Ahj6IGpCQgOiKD>PSSa>?o?4>oXU4
oKhF5Ie\>48G?ql_ho[I:QaFcYbcg9IR6g;;=B]0:cbW7XaXE=K<f\pIEk;?8BCC
b=lj9Q9\FH:C]YL\^EVWMD5[Gcq`7NkJ464F6M=KV05cZ]<UcAMYP^ZcC^nh[?mG
ApU^_3\g?KJ@@km@5>[XiP:IJap]6S<o[OIJWAh7GU]ob4W`E=ii76p1GGbLdC53
H_WLIWUI59kY:ZO?OCC`@Naq@Q>A_SQ0>bgAnROZQdjB\FhGoLZpE<;UAgfOXDj[
4Nca8_3MEB^\[0cH<?O=1UYgJO7K=TG99>nJ8G?5Ila0J3LBb6VpZM>B_@N:[eiA
JT225YNg:\C8[2lGgdJ2m6oqUOhZl:_^edi5MNoE\oaP;Ce:M`LhU>f<;RAq?OeC
L=IG:;AX\X`Dc3Om:Gi=0EVcM\`XpUVfdHm2?ko;hl7^[24mobc4X2XVAbbp90_2
aG]aE>Uo<MK3^?fADP0`VY[3e:i:\UE9TMeoq\^eF`CemjR2DQnOj_J2=]Ka@HC[
aX<c`N__]9:qSgAS>OhLK7aibZbjOk<nNg[U;OV;IoVnLRILkVBE@^T4_OXH5G=<
;V]p\gT3JJM9WC==>o5ILe55_X7Yob2S@X[9?iaJ<X?;q\:Q;:Q?9_GGZmkGTSh8
0=:7R@S0G68nL;X5oJ:F6P?I^2JP4qEWlDdZ1k509P7;;WVV@h5`B98YG>gh:c]@
UB5La55XIKa:9EP3iOf>C7qad8iMD[J`<T`6`I>ZVM5:=6MRX1gB\[<YXGe2<0\Q
7EJR]@IpjR7[K9igACDODFfaadcOcNoe43hLgZK3oe6RO5F?5Cl4n5aiPUJqgVl0
jI^I`iMbVBdd0?6O4G6Wc0?>S2SbTJYBH@p04>LF7VbXoVnB]8AlWL<q[nEiWZRV
Xk:Io`ZBUD0K`fTV1DJ\FPh8K:KF1Dpb]OLQHOP8QCT^ghobiP=14j>^O6S5=kBn
YR\3Y=CCKI^Mi]Bp5h=;_l0G?56:;j8:GmH;86j9?Belj5b0lTB;8lS@MK\TSI1W
h@EpIJZ0\cLQk@EcJ<0hQT370K2QYCD^bQlXf60cNVl7lC`RJ=p]<lSfAiQ@h9O5
4ejnAXoJ8KQMHZedL01R]:n04PNqob6PQ=U4`4X]:1<_hUUYamCL=dYWnbCE[kPi
V`Yn>7nqm]eeG@Y7G5MjQUG=feJHI>IGNG7Z7j1[SNFeX1\>o`Sj^9pHP]Y;jHf?
KL3P^HPbU>L?hO_I22[5m6oZ=CHdASaTR`l8J`CZnaS?;dTECkqfcoDn2_MajM53
MmkDdbRKo81bRD?AaCULOgPUPpZKB>7\YNjNNP5dCg4_0e=_lB@;X[@Z<mRQ]i:G
V7YDDKQmlqD1Z3ma]`I8]ik_a:Mc:S=i9cegd<0M8]2@0?Bd?<[XDb7E41qX[eiE
\\Hnjd@@=<WHSOIZgc;>c6hHi3e9WV;?_O;DVAbnJ;bechq^h031K^Mbl:>OVME_
PWI9R4N4lBSKmhd;aQ1S;e7WHjUAd0FY1dYQ6p_:T76HcPVHXH3hWPDC7dGo;ieY
eaUhcUZHca:GcDFiFARm`p@V5dCm2JGdP7c0j0<Wadce?f?cN41jAYSLNgg@14=C
lb@Rp9I@Pa?O3^ZaTB@NihTa^J>Fk8i0Wj<?g0Z<p[EXV2IZoREeAJO5I4Pka9U3
i]@nM8Tb_CW>2UVTToR54cSd>P=YZ4e@HbS2qTnI8@g?2@gXF:AUnbVUF<D?D@_Y
lngnk<ff<Dh[==XQOjOaNVaVgV<[Oo2HpJ@:Ua;^?NZf4[<8kU^_mmMl0>YRl[<@
J745F5L`]Y?T\g^qjSN18Ra[dn=;gIO0:T[Ec:9X51[8CUj<VR:9;o3Ff:GpM0Yj
k6iT8R;TbDNG=O7`O_RCa;^ZlLEcXTB`YL\Rg:GbCP7]q]1U:<W;5G1T:YFV\EQj
i?nYK`T70WXjM0]nSOo8Q9njW>dA=pL1Y1ekH=@l>kMG@=;P?c\JmRWI<\qZU38`
B_28aSg8W6N7XS=MSF;=SF1B\g_:JX=OJ_\\?O;_dqAa<2jJ_dO11aN2nL7TkU_D
H=[ZfPlY@WNADCkN5^]6D6JnQi2:R@2Go[J3U9[Dpge5jLLM1\;WScOf?19hoTdC
TcZ@=HC^]<cdS^0`XOnH:H^]A^JVOIP=nX8UQZcBn3=?XOjqGj[l1PMK=UhZ4H1P
6gY:::_Q2Gk8SgmRenSQUIR@@EY8ZSpPm]odNjI4;U=9@IihieQZU<8RZEq>b1M9
N;JJD2BESXoH9iU0bf<bj3SjMmC:o7MB=S4J]nUie<npD6Lj[X53]X`4TZeRnb;a
<]?=`@YIV<M1G7NY_WEdKka6Jl;P0Y:Q^a@bq7h172;0;3?KERj7DBn_c3OZ8nO4
gV9clH07ASOOJ^1K^N_:J[_PpY6l\VbYPZm?26UG6B]7VU0Uj]_1Df`Rkf8bE;Z]
c4^3q8lOBU2ehE8P0[_ADdZf09CE>DQC^i3:WFdT^EZTdDAKqaH]GN_CDfklo;O9
ieX5iXh10Q1?B1B0Q52j6dnEWpaccbjmR2jZN1IN57;aehllj=dG2<eZEoZKK7Sf
?VE:Yqa7^8`ggPm^ggGc?aA[WjM[SeMmi^c6DN=@9maXElYlRR`\5a;6kE`A[Kl_
BFlZIg=O5G5Q3pecVoE4Ze340hRjc4ZNZ::YmLha21NC[cd;D:jiN8pm3]G>h]9>
Zm;GKXIKeF?ODBPUW48oMQ]_Ze1I]gfGNJQOWq1>@QRi;RTN0_A_jlfHH6\0ESJZ
9?Rh24WO34>FRf7dap0Cgi0Ia1SZ5A?IVIP_JTFkMJ5W9a_`^E]NZBp4C?RXIGN<
DTSRPa=@dPaYMb18gfbkcnjGW01dPP8q@F5[nY1aKUm]l`VTJ8Xa2K?dG??RIjK[
FiQGg0O9^a<q6obSRXL=i:47k7N`]`2AEA\7YJS8W_97O6kfL70G`WCK[2JR3\R:
DBpHl:1Q?1lk611ej^BQL?89XT0:IEE><gneoVH<Z]oAfN@@9pY_Jb@<eTHn\=B@
Ue;fM<]@Z]^8nj40@Nj;jHTdhWBiW:]LZLOcTVJfT7;2>mIYOlIG@mXJpT2gcWfh
L5[A49_n^Z0;`::dg[H9`@VOMPl[14>3aVPc4IX0P^C8ON?ILf`9]If6>Cc]kld=
XK[X]MAqa]<MVL:S:`Yn?Y<edE7BDS:iYQ_lk102`:gSR;[]>BhbeJE;3Aim6?q1
W9>48;:FIeSBT[PQ7NGe7hB4;ilH2g5OA6\`PN1cY`oiATV3?Ij<I7NpPZW<b_Lc
F:<NoJlPkOZd^JKNJh5TbClg>hGH4C2JMM1eC^9WFXFT7A_?Zg72a3cFqn>3:iF\
Hk::EhU_SDF`Rk=Qd7;_D;?U`MNf;FU88j4j>[2\S^1@9cofOREGP^g002djKkmp
3O6Rc`<MQ2UC8J?@AKU=bZ:MHFK22f2ghdZQTjP\0Y>Ze8;b9XbJcCAMJI;pRk^i
P>bho0agbYg8Rf3`XY7@i;aYTB^nI;bg]E`GaPF7[fAWda:q?OXFaW8Sa=MlT9Uk
Hb^kJ=<9U[DeY05M6jSLE1mjZmkE`h2ap5=8Bf5Jo32b9G8bYSRDLFPV>gB9CeI:
jZR\DmAfJXEl?BH?jBjhqEZ6kCY;PXU:1jSg1d_k2hChl7:MCffYb_`jJD_`n[Y^
5GGOe1MlE0bqB7NZECMR[\:j0BiU;UDWaU=kh]UXa@oR=oB01m4C@I]nZ;UFmPBp
9mCF@FUf2f=<J]Sn\mSQD\;lCWSaZU:cZ`03_=Tf`>[g;l<FqB13ke:D88n<=I_A
017m=o9Q>5^PB;gKA>D_]eG5ZUo_Q:dHiaj[q9Z:@>X2jcJ>b;3cJO4fR6M?=Jg;
EK6qoI6CJ=>3ZF]JETa[1[TYSG2dehZLIEnmAFoCjMPWqoCA^;BINI2R9@U@iSRM
dhi88l=[IbcNn[j\[_SqCD`eVWNAFd2PcFTM_no:NR[ihok0:A>U9kJNJbQ<pbQd
BGdjC\lA:jkdRS7;[F7E1B\D_JZ>9?OBE:7[\qRfZlX:`::aYZ;kSoioGSRdT@:A
3O_Xb^=[[bB6qN;D_8L_CmbF>fQI<@fo0_l5gbcfRYGQm9PQJ55cPoo4UGkg5:jH
:86ldpLo@Pi7=Q2?Z5;2O\PV697>a^knFYNoe?gg5TJ7K5qEgd1^o6U[CoTV=9>M
GdUW<<5W34Y0^7@QM;5g5BKq9lgARl3PPiJBE<H=@9^o^[P>lhjMEU7B]cF>dBLi
kGcq?;29?ec:<[;<\Zc34lKjU0E?1m`EXFj3THl>_bI=C3dc`k>Cp5iCYZ\g`=W@
V5aPl^U2ElK244dKV5JUUbHe;LFLFdAOg8mp1X?IIj<]RKSPZeW<48HeBifH94KT
f81SSH0LOaRLdd9cf6XnqWof]CkUZCL^bfgV9k[qF9h1[FdPjY=@j;ToF76V8e2Q
`R9IRkh62_E0LcIog07<iU<>paNQHd^7RBL=ld4N5Fm:ohO?6R;Gm?15UcHZ^`8>
bTh]47eqA[7Pg]P:bZklc=0dS_c[e@hTLl=SK?o]5YfV;F;ELKbLFFISqOY:AQB4
JP]_N[]N>XG=D23:\A\n0CTG72W9_UIo23V?UR?C5pD??[43j4n\ddM<NMM]AZCe
M0SfJc52^Nd7hT]:7X3OC[_DcoO>aqcUY?b5f4E3mBSX4cUkl7GRYjGhc4iC5L1Y
aiAfIbp9IH7ZFl`52MFhaWchIT;S7Fj4YKC>`T<X`SOYdqbLFBKb8Y[f<mMXU7DQ
G03FNo@NdGWoYf79UUIfaXpBXh=WA1nZGFd8cjhAABEO[iXYgCDgh9TkEYM]IWZa
Ro^RXC6iCS=2<]DI?TC]G3MKCq@RVCl2@CYW8oo\Ph2Ld\nCEK_@2cXEnfIibJ[h
IbZ6fkaEQmYK9Fm@7iYO^FaXqKobn5[Ld6mb3Q<Hl@]k012FmaCD9=WLhQKIOST5
i5H\<9MmWd5]OjRcF0ClghhdZ<3JXV@LdcHhOoeK@oEWL5Cp5?EZ27BZac13V<CH
9E;DCo<G`Co6jHSLN;QX3R[Ke<F0[2_MDTg0SlWRF>BbmVq>K:8@6WNjZ<kKFP^h
>43_MUKfTiS`YBo7MJg1_<UX>mgll97EY?>eZB=I=\jcAF9p=5\`>d`j]C7aT?_i
B;Vd7_WiAM3eK1\>T5SR2Tbbh\49SbA6P5PifASSAf7^9_l6eK1q_0GHKY\PO9D@
\OGBn^aakc@i6@8L9B5Y8>A9QNfB1;P2@9ni>]Tc9_ZDgh6h1mTlqhQ2IIXm?^8W
<Q4O1?KKaHO;MeN@L1lUf^CXIMa9\hXT;6af0U_Om3R\qg=[DNG28bImA>N]ahSV
cd]\51kCqZA`2\X62YICc9jSG5_eEkg6:;??6hVKe;YmP\e?1o?=R6H_eAe3R<n9
pmjO53@W0f;gXlnMIUTK0cCbNOUTE8Cb4PQV[_Ag3PYR8<8\n[Qdo_Z=qaW``SSB
kO_@=LG>]ALfaJi<?Z9mOQN_;ZVI7f@RDAnY@gMqM`;[lg`7^m^QC:NnlEGIIZ1:
Ti26SdS_2UDK:;V>o@6GkHVVP8FCjCc\Q81W8n3eO5`doj]UhPL7I=8UPi3H2li@
<TG\Z>?;kPTYIbQMJDGca8hRn\`_>Y5OB0BG3_Nd^0eTK<5[nC4Fqdf5\890U599
mk]I5ebE4<l3QD1N]TQPD2If3ddfYZ8ibTS6_giTa]HLD6><ZPM^B?eHgCC^]GLC
]mja_c[O2^4<]WSB29YPEM;=F1QgT;EaAE:Ic\fnNWm:Z7ClC;b^7HjVLiT6hA84
h?PCCj>l;q^\OK?QomTM3o`R][oM_>cO9oLM?6@lh;MJ^En1M_2ThggR?dTcmI]C
[060lQEl:?aeqhOQd_0>j<E`YM5^gNC\?R=aXlNSlJ7_McdRbI23JGW4q@;R0N:=
EE^2djIn?9=TkLOe9cR5>5YoGg^OEj3cE4fQ92JjWQNMqkXk8YS@2l5\Ek48hCM_
2K_=1bLWhQ2J_n_jZQLTDLSdRBF;MO6O>aj1@8A6q\>CXbRVZPH9Z020iCa8em>`
C;jXAoWBaX]7eQ:NODZ_V2@4MmlliO`pcdQ>`4jm3;8FhBSJ2nH:Kl;]?31dRn3l
kd4<ZhQQJL:Vp=S\MlAHaLUZdIN^lFXKkKN@RE`95`A=<]jl2iQBNqbQ4]n?l@HQ
U?T9@d3lH9S1T[?8J7:MRk=:DM5XOO7YiZI0bBq^5CFh:JAQVK>S12GaPaMmJALg
@A6<O6FfnEcEGAaZe\UW>gpm@_BIW`bR5;[H9U9UG9jAJ3UkKloL5mo?JEe_T:m5
S`p1O]a?6K@008j1hCB4\SEX5<NUkcK0N62de=?2SHUMSHb1:h_onYlp?8WF86KH
DDLZLg:ji1\;>`Tad7[ZkZ;fR>E;^BpI<ZT2`G2c`BA[=8l0ioCK>`MAO2@<k\d1
FTL89QeYX<hpS>bPS>nX=cO49Xb2X2U]gMdJIV]Q2oj6EL3If<A`H6>R0dX6plg3
8@I64g78J`dnBj]f>2]Li4OAk=9F7BUb8`J4^XMfM1>A<Y8mpEM=F1kdNOUN^con
Ln]m]GjGPC[GTk@b`P9BnPHO1P:Oql__X>8`jSnGD?]V0lGKV59EJJ7_i<Ca73`C
@?NIH<`]TT[gbpnFao:BHh2ikG4eBk53nGmendm^@L6D_XT?H99C<7T5K6Z@Oq=K
d[B:G\<A>i]8j3=mo19nR^kWg<\V?1L?bDGSJZR`cXGR;h0Yp9A=c9KV85G>9HR?
=<N`n6aTSP^iHe6G79]LMCY8]SEbNVU3q37C:dT7C[DC1jkX2\lEURB^hNdQ[UPK
5YkgU3[WYOlpP\1N\P_JPIghSZ1SFSB2^U>iLkN^nSP[O3a[QZdF19HG4mq]5>Hj
LG0o7Em_A2JOQ]`1?__R0C_VHWOAYh651UQV?1]TeLq?bRA^c_Tj??1==9hNKB55
1[]5c@5GINOih[Kb2_\FIAGH\gYUjGINPVUUMSa[>7qSdX>_dj@:D2M=OZ82<c:X
@58AfbPcc[Kf\l[DVc07WQ=jH7Y9n[eS:Eg<m[LegkYpdb[jC=31<]JcAclo@[;a
b<f`dfLXNJoUM9^NMPnEc_[_\jTQKOO_9gO7FY\@P=9Z]4pj;iG\iN<Q0VY[6fbl
B;=\\P0LUJeM9Inb6P=]j[BA;WHUdFQMoAcEVdFmAZZi5Zj=6pGL:YG7;gAE=nUX
RB>6JVcO4@;:?NCV8[VSmfbLEokZ><6W2IACi=`XT\FLn\HO0Fbh?=pX7`WA`;mZ
=?;USOMgj68MU^]Rm`RP\4>GKUbY@6W4011JMHEK?6Mm^<;iRToF68RU2XqV5o<[
hfhG`Yg:EMHI\eEBl[``cVKhjI_9:iQ5>LNc0k;>bhV^^:QF7CiBgk0R^JYJ=0Aq
dDIPGH^adHX=Z01c1>>V7R^k>>VQP;4H]9iBACEN:h53RTaWGJfOqG]filjCE\Cm
mZ>QKieQl5o>eCjfAXI^758TDfBaG=3AK@8bjLOSU=bSkkWBfTnqckeeNEGGnH;h
i_fIn:=BIU^DY<OE8`db=R67[TJl5=]Ni_5Y^PR]Zj[Y]\^1ia:fp^UigH4P?a2f
M?_=BfOXeZ8l:ZWV5aJ:2FWSi86^R^R7PZd_F[J@Y4e?;TUUUi2ggpW7B7bfhB]M
02RQH3GZYk85J;hGLNGYoFoSOfDG`:LGY8ZZ\PFY6JaX4<ITRL6mchOVqO`DC4bY
JS2B89bTQUR2`XIXMX?6kWH\8f_OE1Fe1W[\PM22?d4TjKajj`3RTpAkN?RQK:hf
CgdZ5SJdWm^T1cUBJ9iH2QI1Y6A6\\0Fai\O4S_jafC]djFAT3_C`WpX?GHQF6mP
;ImLiTcmAT_KZ@MEL?<o[OXZVLYB5SAQl48[GBiM09JkjPfKRJ1RjCq=gY2SW7>;
hnIa:_`A\5d5W8FQ3>GW4oO]L;i4;fE\^VWGKS^FX;@Ye`oD_\1:epLX[KYIL8Vb
l?8<G0<RkNP]l1@mL:IO6\MC3W0iXe<22G^lTa5MpmZd\]QO<nUR`V2j>`oYGRCF
G@8Xg4Sgh1CA9iQ5e;gIba7S;JE;7pA1:IVBPJo<ZTR2JmP[:nkh1U8kkCnLI0ME
V1@DjT@AD=1VT]QP5^<o`9iBl=2`fO`m^cq97^N:^aE0b3koUFHSRZ^6NQek=eOB
7q4hjn\IG[@QDG>fS>`SPk\iS8cGTN9jb@>18jg8qhZAlIDoO0\;>MBcI268I7dE
f5kbCXHoad1J2p2^[_DkR:A4Q97jK>@l5ki3:6X_MJ`aca^0e[V^?DSTmmOOn^eM
p55FGLcaMiadF;=>qTIcK>]<IWS4eG^nBc3`G7N3U75^NP5OV1RAhn9YjU<Pm8nK
qTN7ffO4VR602PeUf_4\Km\SL_1YjmAB@?1:_F7p8\B;bid0\>QE3EUCKkjB1^fX
1^0MX7d3Jc;HpfR]9_V`iXkHRUSNH>1=hXXcOFIiKkK^f<cRZYa3iT>?\elqofkT
gn7j;333RXS5[igO2K7>103d3\iPdQhPYgdA@iqjAfa<eZeda0\mGXcm53^1Zl1^
;AHeWidgbJ;Ka6XpLQCKCYQ^jZ5e=]IbZHD5F;]fAIf]lLaU[8BSDdEgfVBJSYO4
aXm8GlpL:G5<B_JUknkMcC4lKYJ_fC]Rk0iGWO0\9CC[62VoXoP^B5``[L76Y>eb
HP:6];47]pS0i1J`of^amf`6YLi2o@o;S3i88Zij4ENPoiB51U?Dn63m<TAFRp;4
X9FZ@nZmNLTAl8OJ;:`3X_@_[K=TOKBRZL_94Thkp3`b>059Z:=04ib9]jXXc56d
Ljdk5D2h1>OBWk8Bfqa8`hkjLd=AMWR^cb`>[3k2=SBjon<1Y\\LF^J9;31LZ:N0
KLg<Zi81pm5FUe:81D=Lb=6VTU2bNVVI\8L6jb`9=F=ob3b<<STTA2878?ENgqZf
1=XafRV;DJQ1D:]S?;aKgm@`1GiJ6<U]_SB;Z^8aQ^d\KhCmE0YBL22N`D7fKn71
WcjeDBVBC2MH=E81??K0U[]W>SBU<=ZhY91m`_>ibS_oFORa9qgQVV=dak2FUg0A
1e0XLJo@inib@ok1X]h9>EmZg[?NQ_NNag;??aRDN2pPUKDAm;gf<InR7kmX4e3n
\?M0bP[4T`e=aKh]lKe^3WRA2;Kb\94CmNKTXGKq=:;68DgaZ?DX?iFl4\XZVW1>
Pc6^3EbXe`U5QfIVe>3>_Wh6d7nnbQln4:?h9@c1d7];ogN1g>iO>WK5I7M4S@1H
XPLL\dgUT<lMgegdH=j<afg:]0OG8npjQ:agRX=?V@KSg38KADUV8aVVEdQJ9DW3
jp1MoNc=21COK:?:8l54o?jlPhZ6ocI[]jPm>\`bB=AoTq<=W8fCjeT7>:LC1in<
ZUm?U=QOgONV<C\;BcO^E1=2qCY]GC5mMoPR3jFL9:C4kP:<U:M2>TdcgLeCFO8I
07YkYXj3ZW3^j<7@pifPf4R7g5Okboj9Y8VhKX90HM2>:GCXAKge=eDLY3<ipifY
ZXbZo:=0kE46:3`nHfm9L16MO3OWIEn0VA6O9=5pLf]hHXP;3CjlI>DomLLFjR<H
]eIM4f9Yj0UfW0L5nDhN8O;HY@MWjBTqFK:3>T<@06Q9m_^mDX>CL7O8QdBPYhTl
d14eo?BN?nnVTa4Yohie6@6d[KoVHk>dR6p:<nng@]66GkaZGY?F@CHF[b?mC6lJ
lX\_]@dYHJb@hIEkWF3Xk7c]0B4X2GdV63f72^c^faqMJWk1S\C5gH:c=1kUF_fa
987\ZWhILJ>e>3mLf`jcGGI9gNSPF1?H6e3lAi$
`endprotected
endmodule // module vusb_hs_dma_dev_bvci

