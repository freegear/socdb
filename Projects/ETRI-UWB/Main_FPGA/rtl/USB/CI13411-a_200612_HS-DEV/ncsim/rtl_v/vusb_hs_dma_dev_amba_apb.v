/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_dma_dev_amba_apb.vhdl
-- Date Created: Thu Dec 21 22:43:23 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: svn+ssh://porus/ci/svn/USBCTRL/HSCTRL/trunk/HSCTRL/digital/design/hsctrl/rtl_vhdl_ahb/vusb_hs_dma_dev.vhdl.tmpl $                                                    
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
//  $Date: 2006-10-03 09:46:48 +0100 (Tue, 03 Oct 2006) $                                                                       
//  $Revision: 333 $                                                                   
module vusb_hs_dma_dev_amba_apb (clk,
   rst_local,
   rst_local_a,
   m_haddr,
   m_htrans,
   m_hwrite,
   m_hsize,
   m_hburst,
   m_hprot,
   m_htypeinfo,
   m_hwdata,
   m_hrdata,
   m_hready,
   m_hresp,
   m_hbusreq,
   m_hgrant,
   m_hlock,
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
output   [31:0] m_haddr; 
output   [1:0] m_htrans; 
output   m_hwrite; 
output   [2:0] m_hsize; 
output   [2:0] m_hburst; 
output   [3:0] m_hprot; 
output   [BUS_TYPE_INFO_WIDTH - 1:0] m_htypeinfo; 
output   [31:0] m_hwdata; 
input   [31:0] m_hrdata; 
input   m_hready; 
input   [1:0] m_hresp; 
output   m_hbusreq; 
input   m_hgrant; 
output   m_hlock; 
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
jc0gOSQH5DT^<]IHC^g6CGS8BaMn5R^p0A]_7W;c`[:K?Y9E36qSNo?[mW]6GBIJ
b8?8F@`REEQcJD;Zl4N1NFWKDI84mS_4^b=S36bqR5:UK=q>VgceCRm@JYKMn2OM
5W@?W9O7db3m_`NoGq^2fj2=JHi\oIUj>2MVmF;JA6UUa^Y>mS01q1[g?8@OkRCS
ebP8W6JD?q9m`49<A`Zd2d?nJNjioHM_`gZ18Fk5EEq8LYd>81gc8Ai:<lBlY[?h
M9E4\@Ab^@:LW6_H3Roh]E2ImHkbLhpWoOTDACnj13nRTYi1VWoIXEBXQ@e^Lh5c
Dq8Q@[OBh5BHjfAV=dY\lHbjj<5^WLVWlhpTFV3R;43hdRefTGT5bOgif_LHIemZ
K5ZT3jJf\Q_1GXOUcQ\?F<^BZPKFjEcPAHhOHR=qJj3@B54>cP;Ef`4iV0V5eFP_
VSmdNm:\WEbp]?IIDmj9`IM6FHPFmMaG]7p8eRg`?7J^F55RXBR4k\q2lSB`UPiS
:gT`>Gb\^FMc6Z@a?q_J\3dMD@1>35ageK5QVTVB090Q`R8aMSQ[3Pm4ON`np3^g
bEcM]87OlN1YYYk<WYXh7Wjg93[@X1aoYY`>f`apZi0o5h0W;1fXUgH\4g89RD8A
;VhMiZBj6OY4p?ndn^d7G[4Vn?bRR<<Sci\3CHKef00^g6J\=]EpD6a2l2j[S9A6
D^SeYNn7k;maceoikcb=H[>Od;>]iLIQj0mLl3QAg=`cq4W0Um7nG@LV@Y5W;P5K
MhF@9dnW?L77fH@q=c@fDlm8LGlm_J:@SSY@N_<^oOhUL?963ep6JPYWjAm4bQ>b
0LmJD70=L^DP[DClT5C\Kq?Pk[iZj<5D`dFja21_n[g3Y:WCGClP3M@c3;3HYjCL
_gp7CMca[HBXRU\]7=k6[8^2IO]oCoR3Jc1Z6p4YFDX`cToE`ZUS3MPl8iH:0loO
D1H8O`m_b0ScR:41q;n@b^mc\1YQg_oZe;U_lH7l5Za_NI_@TBNd3`:bA\^X4\QK
0i\AfQaR\pmOUEoIeoH7K\1Qn@h^Z@5O1N34B@7@G__9QVJV[@O?YPpGAnGK3>`@
XF93LTlf6YFg<JS=:O=CRNg`[clp[mXbOf:43;K:5KbP04F`^iQ[p9M?WTY^d@AV
TXK]RA>l@MPTJNfQ0nlMmBO6fjcp^B<Mh98hN0o84nY1ImC\ao3fO3`Z^T6kZCh^
Z>@Nq;6QNom>d2NAYm3:EOFi8M_a03REf3nLB6XgNaGd_5S;p7?mUP[S7fXOaW3H
XV8cm;Xp^8nHJ8a:08@;Y`^<D^mWhYZ6Kgo4d]HPN72pe?:>Z2dhKcXGERn`[l1:
T6pkMU^W?mMW6Z2A<=:ehW@TedB\;]>iATRI@b`[>:9njSq9kB`0Pe`Ro0j2QmH@
WAU?PBUagKHI@l^=KpSN0<2Vc?Jf<YLQjl8OK9JOG_bE;6JaM_>\d0@WfmSYIl[:
CgZAXSmNDp3;HD0mAYU^c9ZCWcF9_X77naMTLQiR`R\jo;k@1nBb6\EHnKpBoF4Y
<a7?\;7lI>5OiObbD16Ve:bmYcN8Jik^5Z3eK^MH8jJFCJN=DpnWQA2ijERS^e6[
LC;W\G`m^<m>cZn\UT7UK5PDXVAI4k6P8ipk>1fPg_^_oYCkknRlc[Y[JZ2UB<72
P`\ibNoGJL<CH>0UYag>D[?40qmnNdkEZ5:HYa[`N@hEm9nDH^0>nE73H;[b<BSW
UUob432gUjbakV6`kOqS07bbl]kS1_EUDkf\1i35W_j5k`H7kRdN9`^?8R9X1JB>
m[]nmnXMK9k<I49H^q>T?LIAHW5oOEl4j3a?<k>DGSU]4kUW5Y6=IQGRNkPeIhLQ
`D?=IgCdV@0a=io>qR@7Kh\Ag>eJ@0Knpm4Eo^XJAIWh\SB7mRWBVM_`;EDgAYGX
`bINkj3mW1Wn2]Lijm`[QVIdo57q_W^Wh@n8BE_Pi4[k?o:LMb4LmZJ;SZM_em46
FHF0\8FPRFj=E4Ze:YKngIQYId=qYgA<:m_nJI@7Q\YhDjVlMneFT:bYka@C1SRG
JYYMYHHoN\U]LZ\d?EMG@LB`MK:qESLi6Dd5UU:6hb]]@nEkC[:e3NR<gKB>LVOd
RAHmUA;fbWQ6q:Xo<G?ofWd96Tnn]4[gS@od28?F_I9Z@g9elXQU8f3WRjMU>CmE
RA[p[I\<C7HNJ>8^>Y8LF<JMUoanD;QESQQHnR6kQad;n>A[]P40VR2]RcpYIMh>
Z0nZM;fEK`?\9heRR]^pOQ[gZ?ED:E66B@a[aMT72ORKVZ0j2km]aLOBiCeflGPI
FeYYq0AENaDXb<Z849P0hKk??D2<mQY`[UK`9U6_dg9=J6Ej\l<PCP?fZJDp7aS9
gM8<Jf?YF]_fJ`2I2B39][h9L3T\\M?jceR;ZODj93GZHBT6e6q<<05k3ANgB;KY
hM]<e0bXDoScHF@BeBjjTbj2lf>g5Z?G[0oZ5qUdZ?a?g6k<ND8H4UO]^@]TRgRI
JMcA3m]4;b?2[hhR8mW\Y[j<pZ>[:C=Tj43=`;@\U[_FbESaUlRn7BbgX3jcVbD6
en;FSh@A1;jN693lX5jp_`2VAeNUL_gYG2S58Hnon]?6eShl=aTqJ;ZlkEYPmTI=
`B3GPSG;K`k2IQPoWJBcAi9Z^=^1jd3n>dP68S?K]4>5f:qiUhXOoT2_RUY\`0k>
>1cHYo<elJ]k\VSkBS^5l\=MOG0@0S07Pq5fPjJlgP[LlD5Nb^TiO60U\a9\Lai]
5^gBF^12L8QPoV>liJJCqE4<BRMV3FSHNZlVLdUZ@n@7gl7aoLDl<d2?dElg05;D
4cg`:h9q<=7Na?`kY5j]Yc@LO7`93Dm8d:U>2g6;pTYBj9:^i6f\CInWN=]1;KmB
;7S:]T<1q7ON>2gZO@0`_Lh3Xd5Q_Di:NaF]TF`<4YSeFWhpT6oPNVc0[7LmV@92
mViYIKdW04q`jHi8he7S=<Q[YZLb5>`QCnIJ^_S0U<U><>J6Eplekn:Td?FWb3BV
Te]T7Ojec6]np>SEOJRe?RhWWNBPFXR7AbNUPh7mdIT2kc:p2m1U7V:\4aiOk5;V
6bV[]d`co\O3c=VKqSmoh2chM`HOP<<]hoUfG8_7k@XYMTCcSl]oS1np_8R5MYA>
56UJ]S\<?]3eBK4qH[on6g;\<=XQ_MB<Z7Zb@jE2em7N3JqD`>7D`kiID7bE6CSK
D]XqVQ0R[gd=aLNTcR78>FXKS0N?Y[;5G?SdaQ8GSN\qjRTjD[431Wg9:SeTm4j6
Q_a_ND=Z2Xb6_MSA;9iHV9J6aBqKJ5Di7FMfC_9NG^C_LjLodRLG=c]`\5968qA[
lo7VEZ^X7njB`Y]F;4k5<kIO=jEX9@@So2qW=_=SfjCbX?NC2lQ?4af7T`V=YqV2
?ZZ?BCD:>UPAjED2[^J8;:ENLFq<9ZWYf7NFamfSjmgP]gjUF:\N99ee3`?o=pXX
GbYL@=N@k^49=hL9CUO>kao8N>mfXJ>=plbC4Kda1jZ\E6fF^7bD9I_:Q3o8ImZc
MqbL`C02U;2NEA@_ZUj^46WkQeekEabnKlZkl3M^NjhNnJRM>SiImRCZ4m?44]QQ
YTLJq<?^KQ@T4cRY44X\H>eGC55R61:3AY`piGdKZZN2ZAO^YmWi>HloHJ?KW8YW
9]MZpUaMdiG?@ISa<J:4mDQCWL0h[R9knRH53qnhQD0]OB>R_KKBSLThW3QiWiT;
YMRE^2RBalD^dgEjDEH5hp8m:bj3<NVI1a5DfTIo9f>\c^I5Gp6eDkiOPTPb8]Ba
@Yj]l]HIb8qPk]HOKcGXfmb77h3_XcFCCEaNJlQOOmp4EVi8_DU:6g5M]@dI\lOk
6ELEXjI2]@TZQ9PWFVlgeYqW`jD?k8ISVDI?5@mKeD2YL;1Xc17Kd;o3AT:f82]T
C8o8WpnYjJS<1^\D2LMoG8c[2=SG>FVgQqia\SOjSg=A>jb:BkC=0L8N`Q4??G:d
ACOW]gX>QO6ci7Uc6Tq]5W1]ABbP5<bKd_VW?SjF\A25M_B3OcZ7Bgl3hi^?>1o6
@DJVe2<q;AIWQAj5e]16c=`ed:e53>Z6ZcmBq4oMT^RI`_5La3@U?Cna^e5XFO5>
=pT?5BKYbS26\aERZdGo\DKI]\HB=Q8f\Mp[fH?``\4L196b8`9X_^<BLYlH<o9L
gQ0;@Bh49EC=_JmpSfCX;5X^iD28D4mRf^38MjhK<=K:a[bmp@R7;I5oYnlffG6T
kC>fM2d=4U[G]BYiDq<Z5\7Rb=k1`iLC\RWkP0@nN]8`m=KSE[X7pOQ`dD;BIBNG
Yfm[SWS0V?>X2daMIDHV4BhaaqjaGnZeCD^gCDd61HXO7mDU9`gogH2]ifmokgpe
inUDFkJeN^1;e6[G4[QSeN>K@G0Y7A8h>DL7cRpm19C4AGkPWjamK3D6SNY0RI][
i>3j7^19^k@pS]Y^T>]HJG[aWMFmN@5DRAK8UU;Y:nPoc9o^m5:a5@_3DWbIJWq:
_^dI9nC5OTh3jmCP=fCH_Tl0TIUn6K?Cl?QLb0;[NO<HC:@Z4fc3f\kAYWIbK=p<
SRcK?59eFeLm0Lh]>P:[bbeY57j^4UBSi`7dBZQ_eFlI[QKJP313U\pD=am][^@C
hE;AO<=;5_C<2^=?[n]M4EE]PcZTT19SOjp\KcEik:]LUHL4h]`i>iF1^9o6gK@n
gLImTMS<VfZl<FO2H3_p6V07T[X<AP6ddi]b]fb\cNQIKKKFqLSaVIBYG8\b4=oI
K;?BG9`B<mOU;bCLZj5ZY8GfUpjj=?@JSV^42;BkMW7`k6odT1]\>Q`i6WAUgnOW
DWJ\SU\C4X7Zp[0XNafX[jP_Eg=7lYKlak@>LqDYdMSKD\0oh^k=Em_XHnk2beFK
M72MH@1d;4jYCm2:PL4C\O<^kVpX`5F65O8d6YLZPEAd`Degef2GKeDNj:6@T\Ab
fPiW]iVa^XTq[bX9\XO6e\2X4M=QFnO3B[kL59GUZHVWCh6fjbA282a\1OFXq72f
WV`9BDOUfaI8B4ep7IEXDHiMQMe2BK:W9LSLX?Q3a0R^fgRNEJl4951qdQ@Na9^a
;HiHFBD:H^k_n6U=>JI<niZ^6^ZdEa9DeCqeD[P6gWjginf82_S5RBiDhAAnU@_8
^>EXnSJ39m<hGcpJ>bJ0Y17XMfRRA9iXX08mc:JGM7U<DW5AHhEKge`T7DWDW[Ei
@Npb_Qi93[^1_H`inZU?dd1o9C];7MJVS:fVk:_1jboAAb^7BCpiniln45:VICDl
Zm_l7ALiB`KCabh4JjSGg:6X^KA[1XnIM24B<Lk6cpS=O=2FCef:7ETWC0bD`_fh
n0ehiU5?DKjF?LMGlHZEdf6@7@hRfJ1Aq2TcWhEI1]]K`0oHYj[^UA7QidG:X8B<
[;`7n[LK`=YV>:hGR\Qgp\85\]BKi^Cl^KZNPQ6VS`M@F3K6JJ@H;EdAcJLCaINN
7T9VEJmDX65_IVFne;leGk_l=HDGJp@F4^8LOm2LXT9;_loW]82b:TXGTmS@j;lU
PjkYqIMD8@0<SNEiPB?_Ra__\iFQI<f\4R:AAl360K3hpb;@YHE_j[2Gmk>2h@7U
7?SUkR?Qd_HH`YU7bm3UC=oP`M@OiFXJBqITE6_F:6XOe4n=bOB_>C1DfO?;9j=U
QCIYcLTi>mq<S74kIC7n=CCliK1;[Eg=ho_kL:0P1T>d>I;S7\HaEVYRB[SpQ>DC
I@eGBA[QaWN2TPX2FNmIYh[JFFk?]XUfakqYd;HJ\5OJZYQG\49f^L[2lZVWiVQh
_Z00cYQ0CpL5WH`6iH4bXWSU^Jbe:I^M8f2Fn0Kh1NNQIYCIWGiJEE4E7OX`qdlH
38H0Q@e_Ub:LJ7WU=;aj8b2Cgin;KFDVkWCccca=B8T9\bepK;mJ;BFhXjgo6HX:
1dWecWXBn]Hf0o:jkaji=6RkV>JJQ2?[6[j2q?\l0^0;ll\PCDd[eg4g?i?3k1hJ
TGdLZ_=6;3;E^oWfeeHM;Iml;1m38?]9cQeZP<EOQf@Mp\Qa[PT9bZHbgPRO?8Tm
LS^i2glmhNA=@i@Z0h@@\n5n0Ooq@?XY35QdR0RcKj?AoJV5emd4;@?mQGnWN3ZF
6`kdQ4c:>^pOme3TG?7gU\USB1m8DNSYJ\dkaTf;E=c6hfOLQ6RNFDp_m?AHE547
T@QH2qnQj06kAQY<hhP?XenGa<b45Ao7?_9`[8LOmaR=e0FTKqb^K1QZnP2<6CGo
G?__8H_TfcYNRoW>?>H0Zi?dg3D8lKq6EYF:bYk2[5<7FF:b^Fm<PEH;2bdG06LM
[la_c5`peVce6nNYKfZ1]1>COUKB^3OPB[KJ\3FG446950:iph>3K=]jPR:oZVKN
fc6f]Ta?[F>]@PR]6Re@L^TCZ@dqhZA`LINI=E6jFe\>f:?R<?J0No1Jo4OBbhVP
TSM0aB5NUAF[9]WC8IWMm@Km@nciG\Jdp[`W<GLelR_5;o`n6aRGMege@RiXj]GK
n3fN:b8<G6apcOkho\CMP9hgNoHZhigWV>>q1oDC>@SEQ=^9nn4_Kd[9]=q?7kK8
4T9B3Ti@FM_g3=bIkMqccj2]FETSCbd5=;:D1ZM6fo]kce6L<f3XnkPIC`p>cG^f
b6Cbn<2bn]aL2QQE0UA_fF7Q1X<cCI>qeo1`cT9`ZJjeBo`F6TZIS=Qk>`8pl9gL
B9:Jg7Y@haU6@AZoDUD>6op`KQB`kQ\@RIdRdR<P9KN`I=Q]GO2TeVkBA?NE@?dC
Dh5YS7RCEd_ojfQIahpckYX6Un0Y^2>VcQX7IjZCmXL>CMq`^9YoE81o^>ZHY@e9
N?feA\\Bg8XMRm?0HOTnhfVglYq1E>LWeR=oGTgM:eB2>A_fNF?HQSegZFPHjGAS
_EJq5e1a:=3[HN<>3MCnZ`o34a2V9<NBQE^K20BFn2k?=F2^>Qjq>2Ug`jfSQKjW
jNl^nZ3\A1eTidl::eCoIm_M;_1@SeJ>i><Dn_D\1lV9g5KYXRAiMnXbBK^Fb537
i2`XgX`Loe:blDq^;5eEA>k<b^2\31jLZMiZkcen3;Nm7iALmq_W^W<FiUH>GlLX
WDTZ1X[m`bmgTIh8jHfi4L8FG\E;l<R4g3AmpUfT@:YF_eA\jlU;FToJK8XPG6SV
cEA\m3XDCdG2iW_D^6<BU:6qJe_TV5CbSPcUE6hQlmDRQ]K8:HLhki1NPE=^=1f[
1?ZVoIHe<:pm1H7F3QoKVLgB9WUjmJ71d\4[U8K<gM1b3PYo:T9SjH>diBQPWpU4
<CT=Mn4Ef_<k9l@Vi5fAFXJ0HCJOAip1DOW49W?bAiIZk0Dh^nnYJo?Y:1HLS7cb
RA2em_cS3VACj52o34?pB^MA:AFQK;_f2TQ18L]iHSfIb3UlCh8lR4Q3HFcLe\:N
R\QJjV`p]>;XD8>a99o3]jN\f9iUfHi^_EjdRRDSnf9VN6Jq=PEX4UlSYDhkY0Gm
EK9:oK?^YIR_0?5<96KM<Cc6beAe^7\M?b39E^p3FN>RKVLWa0DoUg?OEi@aFHF2
IZBf@ERaB0A2<CKKaMES:YKmYh2PRcp20[mmN5g5fb^=gk0>g4NV7:I_MJ2PnH7E
Q^WhVbe055eIF5YHNeqOoL`;>Gnn8P_Bni<IVm`VTSgL\NFIZRoSiYkQGf=M:Tc:
6l`T4^[Nhip@>;\?TX`[4DW?;adWe>N@9jojEn8DY_cpe\l>1hGXM@GPA=a<B:@A
nY<a0h0W7KMU<oaf6S>THTohIcb3gQAHq11cGdBmFQ8@OVLh[TAOTX?Z^2K0[cE>
^O=:5?\4qAo`eH8`PR[mmKN@l2@7^kQKjecZjLhBeiC_3XN3EfE5iGV6MaDH@O=p
6Ro=`T9bBa7e3D5A7KiD_d7i0IY62?2MLR0engK@@>4`;G]8Lm<9CXEp_VjcDN:a
VAOhEealBBSk8;L:eh8Qibj<d24amSOG40\07lE:CCC]\Hp[SB=1M_l6lOQKd0eW
nhORDR2M::qjLT0Eh6;f\>JDUg[OA3n9TBVB]57<>I50I1=iFLBi`6n@PJZ7b0a4
IqfHa10[NUVA]eP8SVA^_`Xn1^f2KNUcLcn8Mj@[pmn:K@4;8F1\2CAJX\Z2Uf\X
bE\_Pd0ckgKPbNYVFM8o@OZLhW>5pfS[]6\DTVTcm=9b8\jj]aJj<PVkAoe`Ao^B
Mi_WVTRHFoVfa=ip<@;]C>OG?2C9b`Sm3WT90_ic8np1mBRBdkQP2b3SnCRZB4V9
IZXB6iUPnLZD@1:79V>=2VWL?GIbhq7P`k?VQW`\oF`>4OTfQ=0Wl9[EoPL]1OoQ
S7<k71L_UcRN[;cP<p:<eo3;]5HRn1B6FSj[KJ5ABh5OW]NSCDQMa?lDHm@hIZ:Z
7A_@qDECZUK6I\hWMVO;bS;G5P\Zd75oiLb>6EVe6cTC>hS[6PS=IpT4JJ=hibBB
XoFN\@k9Y:VEGcPY`mmW=;Bf@bNAYhj4XDGK2p^A]IIEJ;7;[L]GaN`UlORdgBjY
ioZT017A^Vd4eKL?UFMKKXOIqLla=7?L6Y8lX_[4__aHaU`LXMTK27MiS<Zkbbm_
7OgF6@Kl]_kAl]Sq<e3mhHGad4?l^<P6_YX=C`I5lf;VkiI4YMj\PU4aT0c8g99_
8`coHd@nY_Q7PL\jWG:[lH<;q9:=`m792Ma<=eiU6j^Q`]BZV_4H[c62KZ<@HPL7
::]JW2BhjPU0qWg3[8]610\=A@MTXE>HiNgnEd_Mk3N<Fje=[0K2eV0He]RAFBf^
INcSqFYW=lA5=IkN>``;FY>2Cna4dE\CC@V=X`9=78FnhmYi]LCp5FHiMOTI?fhK
@F;`^f`QnP4:lmkKj[RcgTVHU4_1XDkhQVhSmo<]9CqU>8T0Sj?eib5m`=_R\bZR
Qk];gYbFVoCD8BRf5Y]OO\<Wc0WT9=ip;C?5jPFoAASIle11d_JXJ_K;=<44B1Co
=0]Z_^FcQR[PKAf<2gDUDI:Y`fmB6m^HG9qk5ZkMQ\]FRS6]RfkSbPRV1l[d0m7<
70Pg3M\I7dpJFD<[@X<efN8g?KLZ]k_QJ^`Bck@7\T?m:4fjIFZKJW@5T5VXfj:S
XhgWkAkmdihERfO=D\2pNj2oUcYe:2SN9HQ:f_hae^[gjo1AEi9QdOWjH@q4cN?L
\AL6<UI?ZihHfClVP2fE_b:T<ckXA2356Jf=LFYmg524AO]a5YcW2p04Gh^`[?Km
hJ;M>5]<^_h2[M?M:ea8;op2@3fGZoRI`Rb:H;\ca@O39l\dlP@a9f^O@WFT<ejW
Iqn\Q5JkKB_U9W<a9G9jLQ4:I8MFUjoJZ1gF2h6\SqQ9goL^ZniW7hgG8l;iEhmH
qFl2JJh<Bmdl0eoVXN\5meb?9m^DmCaRbFa:nPaiTC74qW6cU6P@BON_8OoTE]HP
MMe0iBjT0lR>4q^Q5>R=dXdTd]6@iF_S44@Y2hn>UEP>R\d^:eP6q2R6^:6<aWi3
`5DJ;FdfeX^=U>4`[FJJ@oe5_\nVb2Xq2c6P[_0a3k^F[6Dc5V]g9@OTV9S_Gjd0
0WXL3B0]qhAlg:;Yc9aU:3U];d2Bn4<ApdjlKf\4KXn2Q3]Yo`40Fo;p\Q_n4eNk
iWS2FbmT@hgebDGqBEbX=IT9:9G_fi_g3imECOc8;lSqA6@3=:[ACVgS0CYCF\Si
i81Eek8akdP91DGaVc?<aFm9MG5a6@1F=^O:4ZQ2Y\@cp9e>egN^[D22d?Yj;D8H
GU4h=B`qh@no?mD1<hhAHKP^7>DKXP7o1U2qnD:2<=EVf5fX1PWcbA]ZRPapDe4V
;\J<[nW\YWP_]mdiRSq9_kI:E_USYZVJNbo8577:8mqU50VK3ZR7S`S^UH61GFjA
Zlf3gOKSo3KCEe5O@0q2n:03:3b7MkKb67[:f5dl`Rb35h0AaJe=iS7QdCB[;KO`
6<ah:2DWL36qCnI2L2hm_>4o2XQXZCWNf_BV^\LhF?VE2ap9MOH^XBfbkh>l5LBU
Sll51jQ;=b3]nMZ3DCHiVNSj?MXT]_oZ1<j1R;o>ma>;_DO`d?^nKLN`R5MhR`mB
gqn;m49EP?:;;j:D0YGDkBOlh^LCq`^UWci0HdCP1d?VDg<S6eMO5Y4QfcE6Q_d9
fRiQS0Op\e0WH>1UTUEZh>YSb^`?LO0c\i9@=7;705dJ<hFa9<^<cRmCmnGY_1J\
c?]7[I:GUAGpA[aEQ@JmL1Oo@5<X?]WWI8KT7[G<`ToWV6[UU<>iZnbAXX_pBd8P
mm@0ai`;b1Oc?cM]l>S4B590>46n8Tj73VdRT;RFGIlUVbG=EfMn^nSWObTnQf9a
M:V\\@X2aRW1X5c3q0?^D7U:DA:2@^Y6Z6NQMA=i;eR^E4SBkXo1SgKpKH]=Z6h1
B@2G7acbRH\[nh5Bq:WW9L@NVF]JikNkGFhXp<fHPS\;:^JFZW:C7@<TWTd\pTjg
9\CCYJ4cI?PJJ>9F3m^c:pPi\fVN3cN4BgdJ[FEd[]]?K7C:2M]:hDc9\5q\2D9<
jKo@lQ;C9FP4dL:R07oalBKPFYT8TmCP5bGqeU8eVoF2\\W=baA0LfUdVn`kq5SU
9dM[[YKd\KV7^DJ7AVg8q@D1^i4E?41AX1jed?m?YSe\Cpg38i0Zg8gXME58T6Cl
RR:0kn6b1OJMLh8jbDYfoG8JVpk52P>T:9]AQXSK3Lm^`N@j=7nh7F:ej56JeHEo
q7bXHB^ST[[BND9llgO[TT>57:2WBIIJlZ`:AP6iVUJjbBoH[CSQV\g0Vg3DFWZE
Df5OOJcjqLWc:KHiCHI7cOZj^;[H]FOZ\edCXPm<9n[ODZ`aP7jja1A3i[:oBHg8
En]5LSj=>=<4R=2KScLen2_WIVO__74qW5?=4IbRCJ0L1`4]@90ZEcno`GdNUMq]
ejF@QD[eAJO?@Ac0kL=hTkYe]^AlHl51NHaZ^LZCk<gI`pSDQK]A]J02o\1eUFiL
UaU5Ta@l0E`JaZWmd5i<I[ca;?:A`Sfdbq`V5:?m4;IPk?]OBJo5gm47DhDQACCZ
7Tf:<L3o212>4EK_VIN6@S?Yel:dh;BI=Mgk^aIn1HHdjYDlKY=an9[nY1p4XI1R
9_;G<7nSLP0LZO<bm\MPH];p5UJU?C@>cMCk;;F?cnWl`W\I6cHZ]V4AY=`_10U@
_E0nY\Dae_VImKFlNaW`4;7VS?k4VTXp]\1?gLDPLokP`8?`;DRZGNObEBCqRI^D
BW1n;cVFDIg9FDM6ReQL6Y2Fq@mJkLkb_O3mQJF==DbBkb\;XH<bAPT:@gPNRof0
NI\U\qUd_g69@IP`ZG>E<m6fhT^S;4@jb:NjL^4[E]^7kGUD=EcaV0P8MC3E[nYk
iaR7cpZ7C17`J7\XM2kbWbeI2iMnFjM8P3qHK=l@adna_IKRCNGn9VY94\A_edqJ
\;\UEG_WV7g;;c?VAPJZ6kEIZO_qQkWa;KMQ^YR_D9=EI[aY@FaDq31Q<SliLD]a
V;V_Q1?YApDHJWMR]1N:85Y9lK3;:5@b^UcR`Kcg_<pTH\DiN7ZW\_YJD5Y3Yg[b
=A<U6ZmLJY\qlTd8USBG@A5V:5141;mWL350pD4M6Cd<EfZnMMZ1od9a1b3W_CRq
5\jjdKFoB;Em=;EU7XEF@^4W52inJ4P9eKpBTd^jgi^i3gdn<`N^f[<Y3jIaR`pI
^48S]f7:5k7b9HXPeXXTHdNJHeJYgX??k;nBVg9P5;6DmXMPW2kjGO>N0n=W\E9A
3Jb0Snm[FNXZA]_P7QpX1hm8<<XliZc00hI9[O^Q1bTQI9Qmci[lS4p?EdX;JD^`
kYVEC:GJ_Kn^@mKd6^_Fb]S@cMGBbq8X83h_9_deLMfB4PO:;gTjmF4GGXi=2;oM
@DGh9gfhn?ZnI3hjHMM4;b[f9>_Fbmlo=8e@l\\D`j9T^RL_Un98MZYhSG^`4<iJ
q\T3iDYK5<]dHjW9f4ma;nNWck:ZU?B0SBUVahL5Go\YlW8Xi7[]J>0mY]40Z6GI
T=T?:ooiLIk1Sb5n0DWNVTkS;`YO5cDkplmGDnEMYZ@3V]ELWkI\mIKi^f_\44of
@g;NQ9JO27BKJ]W6HW3l6:AB2Wbb:0R6_9mFWFP>dWd4lS\gPfO7bHd\LAn]4i>h
Mn<T1MNYpQ1MM:]8KLaO]Om<`J>>fSe;o?1R^N^<cXAjH;YEA5U2^CQll00ZdJK0
ePJF?R[1_BBm_R1cTTP>Tg\@8o99O1C::AM\8Wjfn\64OS]5_>FVh[^ApjJ`DBK4
SYfMWUA2OV5qnm5\N0R<PfgYllWVUNLOo4OSRel;lZ4J2lPknJ_hLP9VEPge2NWL
g6a^8Qbb32kTnQACaO:La5FLA1oJ]=Af5`ORP5?W_G2DKB@`b`P?8HmS2OIh6NG=
nbdp@fk[W;RRV;>jRMEj6LSRkT`fMciHKR@R1GZ4cC3j^KREJC;HYJnI@khDpdQd
ff5gXc=MWG@VWkJdm;=Nh^e8oXbJ`4OX=ec:ge]S4EIedLVT9fc9g1hH_qBVUU_:
_4HdA\KS:fnXEWI0>cP?nn7ACM?^A<>RfJRcfRqBF\QT;Kg`XlIo34q:_JKgPCD9
\LH8GGB;^LT]:6Hb@4H<]G3VZXXqJ9=emdM]:LL>5J45Bd<mIL@U@2W2nYMk1;a9
\>85R[Q_B;Y\:k=paE;QF<V;0jfW\1HHeZDaGOHm2WRj0=nb4[^l>kK:pI`TfRI@
`?>iHV:kdK?>YdO`<8__KYM5Jb892::2qgVD5TB_L_?ZnNP\PoKE:`TS6E^XLQ=`
0[P9D[7]=K7?m8c0Y[M8hC?BqV59YFR[ik<cAfQmUjjkXC0T]R[KhJ6;CU9]DFL^
l^f^k3PK6p`1l\4o8NIA0S;VG@S7\cL1J@[[FBTSpHCV3PFR2n0h:1FOC0<l@NJ@
?SPM8g_kqN5^d;4NVeY>QQ0CI]0ciaXj_Qd:`5_h:K8nOc0W_qb>CUYRWW_^H26V
Z31a@a^]Sb=38>^6:Ffo9BOWqhb2Qm1DCge5Y8k6dd;Ccle=qdQIDK^lMUMF5BW0
oY:`0J\fbaTf=E=L2kT;B@MHIpBK6GbfnEg=;YREjJ0?\bS<CMWOe@\h4ilUL[No
>[mdGqocn1Vm;@hD6D]WM`@2`1I?L8:i>6qT2B?0cgK_VlSnh?hUA14SGX3P2pg5
Al_?L>W\EkK];HUU37jVdCEI^mJT^R:9FoF@Qkpk>ic_cjM@E;NiTcB9SjjUM]N>
]nDo\R4IOF:gDG>A>kqI@F]N?ha9gVH=MNQV]bGJ^@Hm?KYiJbD67AXa]TQL3lfB
mc^^6X6>WEYFCL\l8jq?Bg8\@L@1l0mm0K]NNBMnA6`d>`>AOqOi_T63MjK9>IdA
KPG`JNS[PW9jp3:=mJRaL]Q;L^Pm?Ske7nKc4nlBQh7_n<c26`A6@m6Pi>Vfjq:o
Da1jc;WEFXS]LFIB[;>;2Wd7V\1c?g2P8bmR^aNJRmGS6O^8Ll4i7Xh^QT6JfGB3
4Z8BCYUS6VeeD>FHGbRofk2ACMA9E]^lgQ=cnb\8\;GHo@e[_q@fi`CHh][_jLK8
ij1ICH5@4[gZK;G>K6DLQnL`q@5`L69_A;YP2D\KE=U4OPi\kbCkacjQ4SA]G?Q>
_P`JpEOdLE=\aA7AY`>;jA\AEb6\HkXRocbbn5BN26ZA<n02pacNQbY7X2[R`l0A
A@DCB6Y:7@o2_1iK3]016Sff5W^SFZY;NqmQekV0J45bEN2bBi2RH2Qkm^[US9k3
^K5PClD@WaS\94GdFOqnMf=GnTXXN4I<me0G?6pDZPRP]@4i[5iRUnk9FXj]VDVI
N=mKPWDJo4CRMqe7>:GYVDfY:8[lfh3Giilo<B2HXX1`OAj0AdOT72Ce9HT\Po_>
oRK^FP7M?E[]BXYmbq?leC4Ni3mH<4nn9XFO=]7@Qfd1g1Y@;f_3[5clQ8ljVBSl
9;Aa8c=_g9MkU5ck13fB_Q:CpGMBZ\Df@75jEji>e7Q46\]ZBl3`iUiRZNciAdOc
i52_SM\fEC]:j22W>?Ug1cbqaVDcM`?fF>2BHD37oGk=KiC>WeC2nG>KDj1@;1Z0
=Zg;qeVHF;]J[eO`8n3fNd\S?[Tch91iSln@idjk8:[Y:1nEiK;GOl]B<0[OUkYQ
c7IpKbddJHDmVa9934CJ[m7gPgeT[[?dMVQD7Rj7PMeE68keYTf5oW>iZeHFR543
XmqPHXZAU_g6\HUXR9bMTfJ[UH1YIhST^^:M^Sli_k=Y<7fL:^lB=KP:obDP19dG
Bi44j3QTY1lA4CpTdHGRl3=`3TH3UWPfd<7g8jDY9XnNhL8oaBiak^?<dLW4aOij
m?e86gFb<QJ_meXPPWng6qhcl`KcFVLaSFVA9[oPlXK8a11R]F0fOVQJeOFm<oVX
NZ:OGa>NcBG?LEq1SGPPj;A]FfK`eG]fJcjgCF^jAQ6^7h<WCZ43e2NflB_4`F05
M=LO[SOYnk3GchYhBLP[6qgTQ6c29;7?lN41YBB3FXH6]i0E>kC2N2`2?Y]oajR9
KnU0NG0PmJ?TIYpMg5nE@j@TAWfMU2h98PR4FR]<RQn49>gpR80BGX9igjNN2?g`
<21>cZb@N2OIUkL]NfkU8XLn<IWUWTWNlAOI=ERRo27qB4hO4AbiK83KTl0]JKQE
KnAUbN<2d9aBcdfBDQ4_GE_ZSGPV<fW\6>iA_@G8IEHZZkm@AbjDqbH;Z6d>3PTT
<i34KPTVhbjjdKaoeYXnH_[AbHaDoPYU>7\ULRG1dXE@WEfnDg6RfmA<fY3gY@4U
B>NG75jTq\K<9?>c7@EMHgTJkB:ZFBO4@okXKVL6@2:h[8E`MYISmiimf;FBm__K
iIm0EUlL`4QNFG>Q[NY;ECEn:p;WBa;jGG5]IS7=O0Q=:XUaSGAP>MkLF224D3K9
j:d<hi:?ldG?e3XC3AT6KTMJdNiPR_;i4`0fW@;;JIShGA;Fk8qSTmZg5do6SSQd
YabAWbWja2j]F<>f7^O\f^YdOFMeRF?ZWT][T=1e4X;A5Ll70::>DS;e5GC1LR6G
0d<l7@3d8:m]G7FK?BjpSJT^W`E=>W7Pb]D9]h\bSOK=3cc^\9n:Z_RA>lqI9Eoj
Pi1NMZeEI^m^Y36`_11T49G8lAM_N\IY@7R1T?g;EYX?5MXmn;3068B@iiY3`F4@
HBm]SbkZI^PDe:6M:kjYg^PHBT\ORoh=:g_pLoNg0<8iUUf6\b:BBS8fgNh_BjJM
]NhdZK9C`6X6B^2deDAo_ADn_E[:kUC=j1XfUDd_JZTiH;2<Dl?a36c;W3<`PO1F
DnS9I2^dbKn`;FDqMgWU;Kc2KdmHZi303J]_Bn3F8Db:KbnOc6f59mA_ne04nIFm
G:EK];iZ3OcEC`=^FJE9AK1M65k2MG=mT19\ln\l:fP@kf5noc;AYkD6\JLfkmbi
FJ5pELG4glZL]J:HA=k<P7oLlkSSRb0F];dJ@a5V:3<4TBZh3Ck:a<`MJ7p6DcYL
\?Ok3l:J7bKVfXEXa6i6Ob3nB@SnkFQCf>fkK1p^N7g\o_?gQMZU8LCGm7R19dAP
MW\mU0BNWHH8Be3lJ<;Q1Vbe`=?OCq\NaZcUPRY=d?9E0:1BoA^`NWM_f?hc^P?a
gi>aDdnG_p;OEU`fDk7MVM_PPV50GH2KUi1\Q4V5Je;ValSG]4dPgHGd6@[OmfJ>
p1>_gm[Gi<4]Nb[8f9PQYeR<p[3\cKJ;LcfFk4PPRbLEBcUC`;ff4Ro5Cij_0=^l
Z61Bg`4:Wkn=l0G1I80mpi4l_V0kn^EP<eP=4JDIkg`8ohg?MmbQ`Q1Gdj_K_VCD
f1on[Ab=?lIn1n\HPK3b8giA0<kqdbEG<:APSF\GKB95QJ:976:Xb=IJ0fISndeD
4c:foeBAD=>9=XKN]43e`mX40[@oTJM:WKq[XfE>hbgbW^^l]miOj`H\FcC7nP:5
S`27<c`I\S?T<D;2C4DoW0[Qd:?@bba^eqAdPPG>bMSa=>:WYN56ijVbIXHV8N[A
m1>^hU_NK;RUL:XPEmUd7M?UOE^U:fhb]]@nI1;?I1p9CTa6G3dKF^WZ9_7i@3HO
72PMjHhbKcA0AN?1jb4N6\TfYl5F4A@d3n`Xg0SQ9EUA;U_2cGHqX_gi7HCCR8oY
\3k4P7S^1U;ha=Odo:Ece35n6QBM`af>ZQZp8RPNm4C?2`GMKL4LUBhB:9H@m;>6
IEX>gOokE4XH7=lpn20mj;HMZ:ogc]eG61nl1S\4hZ0F<`l8c5Oo5Vh:WgjC;C5I
aFb6=`p3L96ObaG2=P_=V\IO]<TZ3[D`mb08=kF9ZYjm9_H<giDh[9enH>Aahp8I
3BNdPh8W538Ngbkk>iK8A4KRib_TR]?92L[Fj6[G^qjSe`aZm0E6H`gf8@=Vfj2i
K0]:Wh?iAQTD6SBaP`02E7GZjIIGIo8EqHNYGQ8cj<jjRK1TMB\[0mIH7oaekc?P
=^oCN?H@LD>NIF\_^E048Uep?;29JV\Z1d9Z\dcg47nAK^745WlYE75j=HXRS=46
ADXX5apXlLj=[FB[dKnNVBFnS>GSdC`o=0<gZbmC[i1oQ5PhTXlP=M@UHE`[6a7p
T=obcK=g7nnRQ^X>VFZnel8;Z5X\=FgI49Wl:JFSKbHk9Qp5UjVbV4;`L>VZ2YF0
35944YG9N6NYAocZdm:l_fjY=4Xb6eOOLU_H8U?\;\Wm@pSUHY>h^:K_SDbVA<_>
DRe^VOZd^=G@46GbPdWU>MPC\bkVh\\eJX<SYAagFP>1pG9lUEJ?FHYicFD_aGQC
e@74chYEoDo@_BLUdi>egU5Lh:1qF<MlOGkB2SV:l<_LZ1ZLZIocQ<KZ=VZDV>1M
Wd0?M[F==HqU84E9WVN`>?QSYQ3]_U=OVhMUQ2^caQUmf_]:0DL:9OKYDqjKli2k
nFH[8[HYZGp3_SdY6VW^_Hbimi@UMiFIQc8]E^kI@Z;BK?NaL81iHSj<300G`CjU
SY_DTPq9@f1IUiLIJLG6^k3gd5fkEi[ce3Rj>XY<f\VgdAAHnN7g=M_fSY;SMLXq
M>@kLS:V34d@^;6id;=k:4Aoi8S=SE4l2la\Zlo^RCG`oik:ULc2_<ePZ:h2S\aA
6NTK@^p9i4n_TS2fFDJVEj?@WRaA^>8BgJIajDQiKMaB\T]A=K1639ZYYS<\kYU4
W^g1R?^_GL0CapHL9c<PU@C<^CH]6O^ce:h1aSEQ3e[DNkJ_T4i0MC4Mdc4Bp^Kn
o=^[ZY8G_;[TP?PT?RDFISa963nHD?9p92PG1QHcI1T3fd9mZ8YeU^PUoSnAA=h=
WOFW?JcEN;aHKYXB[W9UbO=:><lR7JpgDTIl6FCWg4BQToo2J1Y:3d7fgSgTP]Vf
efBmWd[I`7bWljcdo4BZ3G3Z]`q_\GXJXmVj6D5n8OOPXVCWO?[;?TPNGO;@6B<6
Qd0UO7Ik^36:^d8`2Hc_BLGGIlGkbMNK8p1G^M7<OUbm5kFgK]T0jjHRGb\<VKKm
T?E0d8R=g9pf<kk;Pbbi0@i`7MNddDQ2fVMF36W<k0]<Y9C:?faWC;k\E=MUdA:<
=p=LG?AQZ:d69]8bb8W]>HlPle7=fNLNgVLl<Ud6>TSn<q5I58CC5aE9GRK;]4GK
ldPLUZS;Zi8C5VIXFDoOcV=JBP>b56F7O<3VnbqZOokaj\SO@RA:JVU;eaqE>Vj?
=N8J<CMX<IF4\L3jC0VU\6>l:F^Q1J9LoE[d00=3]N7A>ECoib?@=8_V=q61gBEn
;0UGl[b4YG@0]K6;:]PhAkP1KNj65G_WR>=`7j:34`WAlnNG=8?CKS=X^l@G[pSj
foMHHBI4=lUUiL7R2DVf6n@d8_PSMd5P7ZoajG3OHBQ^q?NoE2OCh[Fk:aGbH^]]
T1SIK7D;ACi:Ra9FVTUl?o0R51YPbnc7pYbcn^8@fZ?\F8;HU\SbVL>Qf^Fka1\A
V\ee[2AY:Kd73BU9DQ`10T>6ATGS:;Rpj_m\i3:<NUF?h1VNg]`g;mYN>dkKJPN8
RgHJoKG^Me>;RNJE?E^ogPbf8WiXa?q>DAB[HJ\B42icIWgUn2bW\HE;@5_Xk5X9
4K9Ye:@S^DN5_YU][W@`>mj?kSqN\hBPg[]m?BW`0M7d@lLfVM2mUfi>;1R1^@2`
DA[=I<Kmf]4jel2^?p3HSi^jGMPm^gcBG=J3=<I^AC7ckREeA4m]lPgc:=hWNNpk
Th>lU6DX:[:R04;IVW8dBGZ0A0NdfEjTa9O7^UK\Tm60gM;B]KG^;6k68`p59XFh
\2]\H=n?1?S`YeFW6P;0^YW[O6LSNIOO?m0\@M6nT4?6RYlBZ[_Ag:pe[K4]l5JS
Hlm]hY[LTS\8]oDInD=G[[IcjDE?K>?TFNbKb5WW;3Q<22QbRB2i2p6n`G3FRQ:Y
m\Y^qCidZA@jj@a_DTj9VnHZTVTGYBkWVdLcEC<NBXhOCTJKQHiS9pTdZ>KEid5e
[cNm0Qg4S\^0VZ`BJdZa9dEU=iC>D8A>Yp6JiiQQ4OQ73?V7Y5]PF\f`;oOEP\5J
fXg54:CAQK9;]8iPT@kQOgRDi2p\^UHHngA[F44W8oQRZW5H>7QA_J[iIU4O:\LG
eU@TF:ndh^Sh]X_6Xq]Le:8hEPMRMEa?k2R?KgI@El_9nH37O`=hN\:0DZd_cTaD
[:;2Mp2o@AXaI<mbYM_<`j@I@4SoGo41]nY7baA<cSQ[AK2E22U>d3MZcqBmGY0A
chT;[k];>^]\=7>;din=<G^Hj0O9Ddf2>[Hi8]=70=P[ePl1FYSk0hRGgl]WXl1j
2\Uk1qk6IiI50TM:]^A[Dc_145jVE?Zj4Pg=Imb;bCKfCqY_Jb2[eTA;^eXkfP4V
P0O7Z<:Jj8J7H6@;aBemp@?0108_fkVf17Ycm8k<cB0gjL0cV`olTQ@?Jb<ZTPRB
7bXnjD93?Y:=pf6kP\UF6[gMb^Q>K4mL:3m4JXN3DHKP__P<e1f5RELg41gQ0L3Y
B5[KEaLK=R^E3T\YFM@TpXbfYX3aYOKkefoaheI4cO3Ge`7KVjfMVVAKMk9<;dQQ
j\LEko4o=adMD8]3k3W<ndboPjK[jOKn>Fg_j5iXbEk>7S65?oaalSV@S<68lNQq
;oM9efjZ@6U>5lb5>01l[8P?CIPngiA98FF^[mq9L3QGFDAS7K=_m^HiJC[c4i0J
aPQJbWN<joTSb3JYUepPG@Q<NIOIDK7LB@EN1YYYk<WYXdW=lk5>\dP=QW@Q1VWo
P`CN:YiNAiWqe4@6hN\W44:g=2Q=2N@_O[eg\6?m^6n@5;ChfMNJTV0H6@ZV`Kj;
Ub9afN0InjSD^aa3[bpm;1U>b93oM<175XEGC61@bXWX]Ej3dQ=7Z?q5eL>W@5Bd
FRoCJ?a^dnEBLQI10a0I5]S^En@NZZHM[hpiHIR@`K[h@]9o93eSfE:ePm6G7fIU
\@Pe>BGGZWRID5RK\L9]nTUcJq88Q?X<PE=<RF3hEgXaEg7Q1AQoSBkXn4@A_AGV
jc\Df0RBM8@bTFIBQ5k?1pKR^LL[R_j\cb^I:UUOkdo>0Rdh>CPCndFMmid8d36H
SC8XSJeSboIa6[TnJlJXJg6>D640qNGU;m57ID<k8T[I\kOJ^:^oPe<T7<Td6?If
hZ]5CQ@7KS64HMCXV7^KUa@Y?A\FUF7Tkn=p?:c9d7DRH@;]nC[dYZBQGe7IhMU9
Xf05Ln>JlnS_?0BB:cRZVZcYpk:KW]akPd;l9600\1@nE_?1BlRNA>QkEAWKj:k:
XDSS?U9IGGjRjncneP>@6:;qd>l2QJ04_UoGIP=9P94XGYY45;^NL_e>S]8kYQ<F
l6m?dJJXb;O;NLmNF34lAP=jUdF^;LY?qQa@3]1>C=MekFnNKmH=l^cAETZgh?g5
4PEN[i:]69I_lnh5Ji?hM5\hLRSKf<___3SXgmA4nqIYO8B0_3FmlFb40aGoD1fe
P2V@4OQFhP[30<8[Kde7eqjREd8\AJdLnNi_MWRVHf8M=87_1]8XQ@An9;a0ocdB
_10U<U\?JLoEpIV^^Jac0^6\ckiL7n`m@^\mjf1g90fbDAeLehS6gAd1q7]XBQ`l
^G_Qk3Z[85\QUE?HcYRN_Fg3GC32gHj4=a;2j6cj?I2`[h2pmkN7bXYV:gkX7ZCi
4G]HJCbgK^;FI9HFK87djgB@ElNiGnkjEHT`bMpd1JlfQ;k>JL`8kHcFLhNo`GIf
hEIRTT<Z:Gk5XhElKVqmCMFZCZ5cCYYXh0ep=P?^O0Nb^E>\<O=^I:go^k<?RiXo
CcZ`>OVR<8CLm4abfM48bh_Y8oqVhgfPel9bBM_A\n1Ge4Lk7_@P\IHVMdc@F?CI
?bnYFE1P44kS=3m1SqSFE1c[ME;Qn?TjlMQ0kJaYf`Z?IA`NA3h2V\W9TH@<ml?m
qe_?\C;k_`PBN4l4X`VP1F3oFFQKlQ1F;4OMeIg;\c;]]OOq79i`P[TNVbYI6YP=
m0FhaQ;54_ghOL03IKbY=ZWRZ2N3UL<U`1WnW7hC@[=Z>Gbg1DTFIJqXXX?ed^;f
>H04RTe@ZKAGDUkKJ\ljG^5emM<K\Z=\K[E5fI?X`m0=;F[mZYj@dp_\3[?f<A`L
5Db\EdbNcg2`5aMkV6Z=Y2:<M2M25`<J4PLLWZPS9TWZ`ZijCa_9pX_bNE:\@8ZH
^31jdOeSL@H\jh_a6ZUnGX@En=6Zlcn@]UJpR6KjBK27Cc8U:V@2:cCOBh96b4@g
K00X[3OXQ1H9<gO5S_qH3Nk5]EOJcb_PkK?\oIm<<o<NFN14G>P@G8=<`W4OT?BC
hp<VAL]QD6fFbC>>8::Khj5Ae:eR7?T[eXo]D??mXTUC`YQVH?VK18YJLJ>S60Q[
pmbR\GmgPH::dV91LG\8NL@?Une@W?gE61meg\<jAZFVDURFBRoNinFYJ8e\pHdK
I7ETgXPUlU=0N<CI9R0HE@m5WD]O:UVV8[P?V\\faIka121OKX9TQpG>3\Va`\bM
VSA;WC8:V9U_jFNW]0Fe\@9<ESGkaj;Rlo\e`78glaM6Q:6U=]im_GO6N9N@qg=0
Y]J\1@_fBSHe1R?CnlYXeDA_n?_WIC@hCl[T6Z<=FYZAL]<aIe402omFaGZBNTKg
QO6p@>9o\H?>W1OI@^Kaam<JGOeC[4bUTdjao_FfbkllTaBn4<fX=ONWc]YWSZ?p
@VV2=5lB8bU<2UiBL\^RY`dI`:mFeDMkeil8g:fPFBAY?Z54\G;YZmC9X:cqDX9\
HodS7RnL;I^g6@Zd@ZNGAce7\9T7EbkW^_cK`iFGAiLeH:aCMW^3SMTd:7p_CHgC
e]Zll39Wb_5E934m3<M8Dh9U\8RXM=HUQglThR^T6D1_hWYSbS2M]@\mk65FDMpD
b9eiko9h\GIbLCO:YUimPkj`>K1G36^@1oPN4SP43g@:8;O[59?DAJak1BK\VAPZ
mXqKUTNWo<PMkN99I3P7`IV0BOVOC^E`Fl>AeLVMn7q\4>`ce;?f@U@X?cOCY5i9
eKKnbAbEJRdLlhNFC]PFPSOLSW?fU75X6p92SkLQ@oa@`cLfi\Q7YGVgTb9=Id2;
V`FWe7IJ9n2kQIEA`Jhj;o>J`OTcffF`mNq0A?S6A1dm@Ii?_Q`]B;UT^NdX[K8W
b;_9:_UY5mNJ6H2`^PPejlqEZNO1NU?SCg6LWeCV4eTn\TWD2ClUUOfd>iGCBiV6
IV@2\W\=i5nNafeoMHQ@0\EEJbRMa9k6@D>;oaeqYd?MKS=BNJ>\g=6ilf;h@4?l
Jb<6IGEP@d5[ZlCGfS\@eD:[]A4Xj?RXlYjem6B=Vn8GT^0Yjg:HNniU:4bq>`9N
\aSa6[_QcNY1G`Y5I6JcoT6VlV5IVVSlo\W]h<EI7U[89Y@Peej7Slhd<_NZOJ73
UkhDBPep_jo[Pk66<fo0[IFdT\HGDH3@;A:cNML45fAg@;KYB=bMEa\bK^Lf`h]1
>dbJDfn`bTZGI\U1;8Aan4pb\olTG1`hY:aQAVJoYlQ3]X__7Jdbc?9e[C87HAgh
oX\?Pq;cVSiUN[P[\E3SOHjMHDh3959ONO;Y1Db0a8RPlPko92naZG7Qi`nhAN`Y
>Ea<cT?XaEZWfJpPPJNJ<CW5STQMm5mEJ;68df76@`5R3<\bkM?9M6\qG=TSEC0Q
a_n02^YVR<:<M3R8oQ3YEXNBgQ4ZK]NLhUSpA5KP[nc=EaDAGILoc@h?e=1;R9P\
^Wk;]<VN8SDTV5cbbJ3><YKD:^XXq38;h[BKWJ\eTSAB8LA4FkWHK15V>mb5ccCo
OM^X?_5YgFGIKD[_hJ=]1bDPj7<p9JT1Y0lgMX_HiaOQ986PKXY?LKE7MFEj_fG3
E6_19j8k6d;jGPc_E1CXq0M4A^9ROjmW:h4n8AnOJqhCRCTK\Tlh=ej\NDGQC^I0
1G[ZQOI;RjaC>N`lZR2[P6n39<eA4?^f>OYYEb5B7nPVSq_X=L@^RcGmjfY`VGY3
SnV3XK>P8kfP8QZgk54]KWNhT2kh^HM1V`SC2>QA`ARGX?FX6kmMao@]N>e^WAE_
S[_`P0T7Ghhnq9?bMCHfdXl`oc;daRA4_kFEW^Zc7jDfa6>]SYJjfgO]l\jZGKCb
80SaRF?Sabl^W0QEC6HW55>kg`hWZ8^oKS?Sn;IQq5ke0UFZ4IFXNigeZ:DL_^lF
cG1na1U6]<o_Zj9i5Sbclo`oP;AhBN6HhG^AEd@607bcMe9G@MggGlccMpdk>ONA
0R3eKcH2RL4?Hh7M=L0inHQMZ>Rg<[=ZCWF[mPULMjHnWTQ;\T2nGCOmQ:nl[Vk0
0IRAKHZ9LmKA_Pi>>Re[GA]?P\:4UkjKqo5JiKbIZ2GQ@bN?M?>GJiTRHVb\\eRF
aq]N^LCI5hKLWG_g7LM`D=YK2geco<Mn<]1QLADU0g?[eWd6k0@X9I9;LoAFPPHF
m:fLCI6Wq_ajCL4<=CV348=6U9\h7l?Ci^U`P=bX=cjgYZ<cdRFaJUglOnGo9i5K
AnP?96=C;42L\2\DNkb2Uo=p?BE\V>hknZYIl;dFT76M=fACS?Zg6R;FfBlL[nKA
Tbc<NY:WAaQB<Ng\6RJNeBb04<j]`2M<oNRklbAn0oae;QqkeZRD_3Sj4k9AQ4LS
?L0Cg2^3fOZX8>SBBFeW;>d8hRD]J]h^iE=RMkU1:M[AoXbK7VKf81OBdB1TnVLJ
Q__jXZ`@ocM3S1^Y<NC_6pc6g[HN7dA0da>J^^F=YFUk:HQ?Gi0U[lTG>W^<0ebT
7G`8R<id?CHSeOVeY<d6\3@mmNV7:j80[onbcAZF^P7e]VHETRjX7DOD=qE=UB\\
9D3b?f1mP2Hn=VnEaaEJ`00M=gC846k0Wn:fRh2jFLCLoUF[3Ia?L5j>A2V=i\U5
XFPbKO^EB9HkQVU\=7lYX=AeVkq2ME]ljY1mNCd0QcGocS^L3V1Jjj^PFkD_ZMM]
n@VGQC3iIEgD2=NPg_KiGRqMX?SR>QIf1WhPXm<jfN26:UmGQ]gK^E9@28OSdQL9
Eg;T`DkiIK;UZXD4nj];:?;4`g@:mMfpo4_BUTZUCV0jDn^n5HDHTiYQU_j9Z1Dc
Bd4P:bA8HYOl^XgRTYZ;l\X9`8Zan1UJILUI=k44pU?NhJJX[`d1<YXqSdlEdR5d
UFP]i\OEFIEo3_RZk5i?Z3D[6SCUPZ9BC5W5gJ?dZCg4<R46h:V[bhX>ebC0@`]n
?E?qn42>FAS_EZh_FeI8WAcW]8^Hd\7S]GWcJYeBebe^2`3RVilbgodnn4DcPA]1
Y_6_l@5]Wi?ckYRY5mpHL`dJeEc;m<_Z17>>m?AR^nOTLTO70e`876D0NjFb]ClJ
RpC15AP>FY;^[L;j9UUiJ]?XiUIYC2W5OVE>?^>MP9>M5dA1J72TN3H2pILhJ9<W
i:J_N:H_M9<Z81Sd1Uj93S^4lh9V0?k_E;mXS3o\bObYR?;\c3KOpi@SobnMMGe^
UbamlK[hRBaAO`kUc:kFk1AFQohjIS?<^4b>[g5EB;iXefBD4aV]VBGink6pCBLK
Q`4L?74QJ:HJfZPh<f?m2Q37:Z]a<H@LlAfb_emWZD1ilP^Mf9^NNHNc:`J0Pi`\
5]hd2GQ<WmpQKgDf6KOY3[1RR@`TCpT2C1LZ]>MO98\iEmUFfV@:8jE^1dA=W`g:
Y`fHQ\fFMoQFlJGDWAd7Gj\2RedM[V\@J]?f_lk_UqacM]bGeag;a1@?^T46GOig
MQ=okSc^O>cA48S2@Xq7CPEAmSWRQmOnj9GOU^c6jbdLTh9VM;SD@T;\mp_DPjXM
GTPe<<lQ>KoY5YPE\gHI<PW>n:XJ@HVRgNf`qSQOmK43UaZ:iE1Q4DQ6Mc06>`R5
Z@[FXkH2e[QVK>RlOL>I?nj9lXk^LT3_KGhTZm[qSIJ5SEa0[II`B]p\4>`XeQfW
[ZFJ1d5T>PVMe>mJghnI;Y^IeDBl=ddenYm6EZNN;j\;:kl[Vm__iROl6\KHFQC6
0HT`UCbXJ4h<F[hnm_Iqj[g9bIZ6Jad5E@LoaIi7H[RST_dahR=FmAMfm6qiTlX^
3TYR_o=h<0M?46CV;B6idoA1[n2Jl6YeNh7<MXpK6904[2E^hSe?>Q>ZXl3E>d8d
FUk[5nNlk]3Lda52dV4iAIKSLlL5789qHRJm^^`0_;11hc9`DHPJ_TBog?]L=FG2
N;`WL[ML>G55I=4InW4;2d5ApaOWkePZTA[OJ0TB_7Ec7fnOE56ePKV@_fg9fbI8
di2@XNmb:cMNIRif`n[=p7h17h<X_]APaRROABTi0?hB:c4_P_ebhk9PA;9ZLSDK
Vb^a2]F2Y6h4fdAXP]m`=d5i1;[9Fpi8?d9FV7WMS2Z^HoPCHVaFk@L>`DTidZYf
_M?7Vc8VEnF:661R4p:H>^37]>0DNSK:fj2U3k\;[m2ccE:6J^[Z;cZgWB1bdQ>2
Y5bJ2pb4ELF1lOnYidE=n4@Y^`kD\bHV?GaJ`GEVWa0YM\U[2_RnB?W4]D;omCof
RPVB2FeH3Mclq_??13<i0JKB][iUg?DMclmR14:_>RVJDKe172M:0lCdfXjGWjci
cn>qk0]8Oe@W^bTlBcjf@VY_bZ`l6iilal=h_:WD4[j4oUepbAQW_SeKkal0<AXD
XZWeodhDk@IUHb>CkI2[fC12YhqE19oWWdb7anAZO_Q5nnISDglnL=^FkgmY:2p]
XRF?Tn6DXgIYDDkR;P3mdWjY4SD>\259PH8anM:15P<4\aVn1240NoVgZK9ba:N;
MHK0nqLgeDHK3MggXW3hPSbAD`@8a<4[6\o>genhFmeCB3DM0pH`12gj1@JEUB[R
HR:NGmJmnHYQG6;AI6=AlKdG47344Be5efQ8UiXTmbAFAq;h6U0d`\leQ26DLD_h
@>I68PZZECOC8WO@QIE6A_F4S1gQaKX]f=DYMTh2hqfK@>REZ<i9:Ald3l3EbjH>
l`ODcH:BEDC8jlm`VnT\90DjmOg3g2f8aZ`TcqJQ<PAQ6C^Vj0H>GceGZ1E;Rd9O
ae2g^ABM=go83C8IBhl_S8\[KUSjYh0KXPo>po0e9o^F[ji9[gAm4>==I?GaJk6;
l5?mXl=E0GjLZ\[TgD_<fjla6KE8]2]GO`FQ^N=dp8k1Qm8mhP:U=<kIkZojZD_I
H3g1P2YD[8Io;;^RnME4SHlYc80RYhVXTAVVbIFaKUAfpK;F;T8_VTB6l4F`X\oH
86:YC>9bF42JYFVBkYTkkDbEZFFVmZd9U1DOfb\kh><93lAkp7dShZ90@5Gi<Q08
C6iFYhZgnRcbM:f`:e0kN7IDE]W\D4G^YXnY`3Ud3=>O9J9Fn1E>`?I6XpSb<Haa
N8U>;NURb7[P\IPlX]S_DS>[<Se^bS353KFE[F72Z1C00hoQLR:V`<iA?EYP`pOU
MML;BOP?BeHAYD1f:JjAZe9Wk:]DPXK=__occQT06ON2@g84H:7V0T@ok>mYgmCh
=pi09h9gghCPKQ?O2:^B7;dcd5XM`^Umka4OINel0e7@`^G1Ue6mhg7^3cULW9KV
SVd1o[d@LmR;\qd54hgaH`Yn6E=5f8_2Gm>ml?j[FKGYkG4?Z3T>6THYS^8AM]kH
3jlNpC22IA=adfo\HBgaVd[D`<fDFN\3nW08:S28>UYUmOcEMg]Y5ES50kb>FWE:
lIagnpG@ALlMIoLgH0jIS]WWEJOXL9_HmncZ:E;7MI@?eY`mp:1AJRlWUbOTYoc4
:0Wm?_Wcej<maM4[6M@[jj7WdR>@oV6Vnl;FpoX\3420Y`58^E^R=KY>iK@;?<Tj
o<9n>Jh5JC9n`iU_HAIV]F]7GeNFh_Zb_GgHeBTI_K\CDdmbq;]I@HHSh?G3aBH8
Y^AaR\^4GJJWCV[<CW9R_KJU`I;9FKf8SadL@4X91W<0E;TTGWoaq=JQ9AE3=_I[
VPd:gLYe51Q>8;R@0[<`@BQ4c7g_G45]8?IoB:;bJ;T`^WXVbR[?HY2VDl^k<pET
dd3b<FMI^CfBMNRiQ8mO;R=?4@D7W\?]iC:RnAYoZim0B[c?_VI8HhjjRW3Ci1ph
9ljLd>D2Lb[e2RQGc:5GPRo3BiM;J=hIEWoU`BRVe>:LmM?]]O@h3iTGE[\6cp42
W1;<R?nFe<NWRGhORKH@BeO5Yj>8=6n@5jgbPc6lbBVkklk7C78;G1ngkIHI1Dq7
oZfiT1\H@@nE0CEI?HO66Y2bCX`U4D8go=dI<F2S6dZk^:>G0C<4kc64=_SEfKB=
Mcn@H7\pa44dP8QdRReQGIn`lP<hg13HGG=lQAEie_=YD`jf1JM2;SL6Ia^pM1DW
k8gBol_Hc:_73g4G@[o<QEjfm:kS^:mWXK2MTK1]gdGU;]lWM28T`@@Q^9hl_X5X
gYh>jRQj^3SJqHoS9UdDSO>BoLJZk_H]WCjK_gW_nF1p8?1eDOJRKWGOMdZBB_1G
NCKbHF:]3`\RFUlB]<fnB_9bTYFDW5WoJQE?X6cc8BUHji87bIqJ8l^59h:0Jhgg
YO`aXj3^f01Y@8oVZC`5b[82;364o<m5olk_h;5WAJA@3Y_RCqW\]C1D?OQ>4\6d
gKb7daailXV?dIPnN1?dY]4U?S5dfYjM_gOWX:UmL;?Lc7R=4hdTZCKIHL=Odq`[
NCL4k:gEjJ8B?:cf;dYVoB`iq:f4JOc<ESl4gj4j[NR:[<1f;KSIa4GB6R9`D8IZ
b_8>]9`I6>d4eQc8G`Xb\<k4:4RJ[_SEKfW^p6lk9Afg5_3YPl9nDI_G][eLciEW
TOW=H1U:Q[Vj1gn[VcX]g735i7Z\\hST;`mmh0E=A=WpGE_gUol8;hYnk:4nU86G
NbZY4>Cd58NObJS9Y2Mc4U@cT:hY0KBSiXSZ;d>W:K]FbOi^H6q8GmSW7SNQn?V[
^V;i:UnDIhcLQP>fOehc@HSFB_4U?KKH=XWSOoG?o<_ZHM:2U\jSXiM:d?Lp=fY@
Z6I<1O0NNbimed798S\b:gC;SL8hT7giiVaDGFig<of=F7bFQiR<:]aKHPNPk:UX
?C@Hp4h1Q0hbl:XEaG0i9>TT`G?NV^QIT`5oM15U^_2=QZ7H:YEIYqk;POdNV]FR
8b7fMNd54gl^g<DU[?a8XTjmD5WfGj6S7Rf[Rbmg4TJSLbb[7o3Kg8<nlb\Kp6@G
\EbAYa7W9iAR6DJ<nG0M:e?B9=LXjnfaA_lA=8DFE^o?8@Uqj:AkoGh_9RW1>1T6
LISoJnHCaC4j55@5mA51LGTiIl_`8Y7kOjMEG4FXdRVS;>=?H>nDMkp_2S[=66WT
Yb`j1iOi4R\D?7Z]Q<`a`QlLo8kCa@oA<\@MSS]?:neIS0ND7gB8O]`J>>EOn`cI
R`MdUjEqDVmlZd?@37?lABkDXkBX^OYC2GEJ4>?gh<>Tb;b^>c>\Ime^EG]gWHEG
7hIWREZSU;1A4VBoS@hUJ;W\3DKpm?a<c>\cAGH:Dcn@`g7CYK93QWZK`=^^OWU2
CHM@Yhf<DMalGE?L>R6C;T7mFUP:kia9U2BH_h?p7I?Y<AehR]HKPZ]c?fd4SW60
`6FPH`4[YQT<:@5J_WFJjFZY0ITeZU:@h_1Rja[b;X:_maY=29JpMMQ^Lm`5KMVb
9]lRGR9A9naniDZB;W9b0\7UC0fihT60MKFj1;?PHB^KDmENQD[7[_ZoJ^5p2dLB
o>Jbf?5GAh_Ce4FJ;fR]eKb6]]I]meZOYiFn>>5`[6?<@6o3o;5X5e1;cM]oghVh
FXMdj0f426p[lPbNA0al@BV^2UmL@GC>HCGe=\8Ylf9@EEKHhQX2SDgj99?YX?m\
Pb7>bj7;H_KSdQJRoVHe1YMmlp?0:bL=3T>DXT`b?Y7f;jF=lo=8O>=e\ToK3P<d
ITj=<FD0D5mXV2[nf8\;Uqc99Vo9`Sk7YDmo:i3j1iF>iPG>[Z0Zba`ac_BfK]13
iE9RoYc5Z69LMIO7:Y0b\^?NgnI?EWq_mZKf]D:\<W=\E\G<Cia^@S\ISeGNfQ2J
G1k0?:ZkSRmAFMOmXA>^Ta8k5a5hEaG0S[=g]PiqEh;dLK@>U:bNITaRk28\TfI<
gka5@mMeH5MD`E2eCl<nUZc85WhMBWWSd6c4:CoGe:SU`d61G@2p?cNC;Ogf_cST
[nCmWV65V;XTA1_IHF_HO1BQm`KXQ9no6Gb0=\84\Zn3;C0K]XR6mekKDYlSM<\e
F1qX5F0J9kkdFIX9VW^^\26Z6OONmiUeH;8ILY2KEb^]^^QkcZ\lhe4_Qkc:VESa
k:e>N:OgbdJT_>p3N7O@VV6Ud[W`_fK6aU2IXHO6c\3iBDWX]jeVRF^Pk17B5gDT
4Kei=f_2\DQF5Ji6kQUgdW`;<[3;`>_eZ]>ISWUO[9IZ<l>PTjo<=qn8khBX36YR
bJU`iYna_Le0N9Wgh=2=Xf4HXEBMGi9DGho5ANGCQ5pBC?o2Z;3QIePZlVLeICOZ
n3hV?K8T5?L@kS:fb0Fl\n:amiO]obPkS38GiN[A^?a3j<K96Cd9me`4^NVhGPfF
:eQ3FmZmLO`<?3WhdpK3\D36dB:HD8=h\O;kFRli1AkjSecED5Hhg;BK4[SV>B7I
`l\BE>V8F2DhZ=nF^:<=\4V2qTddALRW0@BmAB`3P6XXQBRIR7DiR6Q5nZA`Y4>S
i3A=dZM[^jOfZcKkKL`BVMfg`]0<QJ=qKA7dB^BRi5=UF>E_EiX?PMTk:]QG]FhD
VT\d7K\b=K4?bR09eK\TEbZcKYn`:X8KYSQI>>J9`NGXN8lbQ;:]RQc>NbhMaSqD
YCY1d6^jX^5=23UI=Um`d>CNo3OK16QCm8JIiYjXD[f>R:W:h]c\3O80KbH84F_:
bH:Bd<QI=cWE4fn>an7:WI87Rc`mKpF6`ZQD^QDLLUAK>\4VVPdH;\O=BbWKkMH7
0[kC\07AFFaAV>dDUP3?Ko^h0Q0JG]HUdIA_4:H>9EjK>m404heLP93BcKT6mhpS
6VX@Pjh4NRnONO@@\mEUb7VhCBNCJY3De4MSC`\A8n;L_im1K9qRb7bJVZ;9NMkk
D8\mF>V<0R^1\<@`Q953bC6;nS>POSQl7=AO^hk]ilEjMPmZFY]lTR4Y[ZE?e_CP
[:>NMN]NM21Ea55hLqK<l0>P5\WC]BY0kf:GRRO8a6j68Jhd?U7YoM[P\4knUO5N
l<QFLQ1TFeZS0K:oi1obGnY751HCRk0bEF:hkn63dUja>pd>i:L_FH]f5k`7<b6[
IL31=@VfQ7oC=gX_CaPPlNXkAd5F22PE@2BVni13\0QX^aHTY3Cb;8]2o7`]2cBm
^i;5P`p[jnB;C4CFL4oYXmh4GBMKe43R4K2PV1^lPG<jX?@<[RXANkS5H^>]o<49
eUK7nLFjWTpkSkQ8VHI^>\4Zb3Z>\Lm8C;h>Lhk9cnZK?<ncOoe7g`@S7@n=fSTi
N;>@T8q1f`mA]H<n7W=:nS]O@B6DD2;lMlEL7h3`NYEFg]@o:X`BP>DBmAX00Ojl
0c[Di:79d^38j[`pj26LNlg4ZhWaUDIV87ZEK=Vp[\O0Wl^QRXlOSecmMATJ]LoF
]SfhG;FO=f;=Z_82hUnmW>Okb`J1AILXmJ0UNaeZDn>Z4JMSpjK3RQkEH<ZNX2f;
Dl2^Fid2?JTnlHlEMI0OMWE@8g_:5B[;?=QYC0cnEM:`kY4R<2nLME_4mn^mqViH
9M:8a83^F]F<@8JHH58f??UGom<AhQ34Vn>8YT^JPMR1GWXEdI:56[i?XlV@lG[1
R:dPLQ^WddRq;nI@7F]h<AP7oHgPKE^MkZhbQHS6965Y=1FAi8aYmC@Wmjk4j[0X
UA2@c<^`2h[D=B==6U<]R3PKHFYXk2_aOn50:k>HXBQWZZM`i1pM1Pn:fMYV_88O
N>k]?7LGaNa_R0FOb@GdH\UH0j^k330LLkm`la2\:bb4iG2NW:jb\COIlqXSU`NR
FMWUgYknGg\i5XZnPah6=gY42WO2\HWSN0[V1BDV3OD9jH^V^[X8bFjnfGnRXeS]
9S=LK2<?q>g^j[4Q8jFY9AYBn7HgbYJ\TIe;27fCi^82TfKLQl6R=T`FmO=6:l2E
o5f@36Y`fAG@O<^=j87CMAoW1m=X?l9pQ1S;BkcGEod=O`1j=NmPP998TP5]_U0n
HIRANe;B0;0ngBACkCNk;U8PBP@fi;\a:mdqb<C^l@h08H4hOS?6S1JCZOKBLPmM
]_ZNZDAeA1K666[g>e5LOGLKTW6NHFZLgDWiElJV:jRHP2OQF8BL8]e7D@_OP4Y9
2U@2F\K5kNq9ea6?mB?FZ\:j<>=<38\HAf:BlE1n9h`_@Nbj?<2JTa3`5b@JAbBn
Y[UmiATnWTkBFH>oRZGfZ0`\0jcN<>j7j::_G2dFUH4X4AqUMVdP91\H16m1^nXB
I@if;SmI15kn;Sd9VILC=6Q>PgggN_22Sl3mNFI]nE;hNSULPYkj@`Q>1O<=\D2B
lm<:PN]2BA1[\NMpVaRVV;S=DN5;oJk4b=JPRIUVlJ0ocA=CLOc?ZMFnbnZenQFf
:Jiko^gPBV99A@p?2aG@YQO9oYIaOb=[Y`Djf^m]4A@H\^?HKJSo31[JWQ=3Fh;g
>@ciRXnJj>jS0?<F0oJ:SQ:e\;l81fKUXUDdMqK:Ao`1XoB3LVn=m8V9R[@DcnMB
9KNHUF76O=`D^UM=UbWUSSB@3i_Mjni\GW07q`_no1_CiP3eJ=SH0PBPMgKFRkVC
Zc3gZ[dQeYDSmC9d?2TSbQW:cPGRiD5m[82[lqIW`70VoeEKES8hE^gDH<iDT>Mm
?Ca7lh4BYg712ROoi[F`::98jp<6JP[7;4O\?[Qk6OlgK6Q<g<ALm[TORE?;fALU
bDSWQ=@h2L7`>>8_K>6mZGWXfH2AEp>Za86KID>9PmO<cWh?AY3AHBgXM:0=ZV:h
aAb:lT_>6RVeS`T=2dNj12@7o6djHnp313GR7J353=CO`?`BmCF4h^:I8b<0P0UR
17MNI\og1<P@]d5RML`OE9?HZmbU:qd9IPoAXo6[ZT4_96f=TaX`2jP2fMebR_YG
iH@P7WRCG`:j_Af9JdKi7EAmQNDDqh5bjH=SBeFEjXV6X9CQ\?ZcQ2n[eTOn754O
<WnN\Y_FNjm>ON1b\]R2?Z:>iFfZnM6X3N0qQTZW6?QHKQfgHH6jofgYnWYff`M=
[F8JN<Um`\gWH`N:9h5PE73cT942pni^gZ1INg8SV9BdZ\cI=UY6OoPNokE:S<VZ
dE<4a7KSiW5RMc_CWj>SWCK:q^?=Qe7K9YOR<Xj7Xf0Gk@8\hZK_n;[@]Y9\9dTP
;dA2]ABFGR5[qSNaR4U<OXAH2Q^HLdIo[5@[P>SfWW\a2?jq4?eREWa>393=Gk_3
XTNc@hSQW;gb`8mf]cCRHB>lAlbNmZQR?NXHZVD;QYAZd3b3Gi6pL[8c@\JKBYCm
8@:8>MXDY]dKl?7PKXRIm@F0XYWo;9kc?HWYL?LCGS=M0Sc6HHIe>\`p^cJE1WQo
aQ\?B:7JXfZ70ZoXe9L6cocPJXPVOg>OVY33o?Z@PfKGYhWh<gYM^93klH0fIeof
haTqCcCUSQI\NW9N^djmj4NG\jb<l\e4U_I`Gg_6RfZ\7SM7B<g8NL=_9@@BjLTc
NWbOQbE7`>T?3@c0plI[_Q1:3LFN79VQN`Q^>AZHn^0lD9_PS=?P?1JnOjej];iU
khK7NlLROKfcdEoUfRl[a>R0^Z:82H8>;iYYVSZNb4Hn[dnkHT?7i92pFJUObLVF
3Cc3c_?_lSO7H4:UH:8K\WgcBV5U[apQYk4S`LN?[<JHZ:W<2IKa2mF^F`?BPkF3
C\j6L44CaLp=c;^h`AJAUgKF4J8@f`\9OioJWLaVCFa?R?87CLP07D?m<Z=Z;VdH
H82pcaPjFFHicimb4^4oA3TJW`C8OQi9O2l_Y=2T`d69K9JjjNMi:hj`HZK[fdMq
W4C\[0oFMJ]P@Y9MXbln[F5LAUY3En@<kF2DXMHm7g^H<WAj>@m@gAo5AfoCaiTR
c2U\W?qhCC9Ukn[EYZ[MO0hKRoUXUU>9[LSi2ASLhM>;f=`;]jR?2QYTE@17i6]b
Hb8m46nN\_RJ6nl3iDi2k94c=]qb?aG?WTJKeVflN2kcaERlXPedihQ>3W>[S=5H
XIHXEUp_aOBgVRWNjg1>`86mFnPBo:O9OQZi\RH6M7EF<OM=Z_q8dUc?B>S886gi
1mcF?@>17@5=1hYf1G\eL3H>Cqe9=6BO;:@kKRF83ik[mhA9qDINiIabM03WASLo
3Mjk80bIYSIJRFRo\HJgq<>AcF;2V@d^0P8ac=FZAX6nf[PA?\GR4bmUAlD93\kR
V@gYj8e9Lb0PfCg1qf<kkMP40NR9d3W9Vd@P36T8`F:P9FdNFk0@c8G>Tlg^\QWn
mRS7?GCVEDJ7pCjO9XL\Y;R:m?jhHo;>3B?ED[FHknUDngWN2W<dfg9@lK]q=bOD
f<G8U8UkiWoVi@?AYd:=8A?@dKjUIL4K\QW^NF\A8d2XpR_E:l?:]XE;3:N<oGD`
g4;DDgYS0;DnA81<\A@=^=J:0]D::qAn^jK=UREJKPS>a512`=2f0o?nHGemG4V=
^;;10FWBYqB@V08hR3mk[R\IiP@iLM?^Y4:ROd7430JWL\fkZLB8i9<b`li^IV3S
^SNJ:pD^N;dlWJIF]MEU_82>hPG8BLc;B70mE3WLh1J`5jIbf=gWdiCXGWOTCOoB
hqHl`IGiW:59fS><pQBK4j5mfcAH^aUj`1Jk1nnAAF?DIH2\g?<RQLa??qmPRboI
S;dXM3]8WC6g^L@\P?A3]24nV>n>?DJg]]FEmNhcpdP05eVe4WlRFM?A[Z0d4aOi
<JjM7Q@B3O_HO3Yf1TY2m?ec4393mlX6kj5=plDoaT?]7<VA3`H]>Kdl;Ecc@<J4
^ei]K`9e9jlJ;mIdhCDWS4\>5c`q`@D=22@XA2EcbWE?T8YRZAY\X?88j]A:0\1R
ck?[[TmfIK3^_Y=USnp5Y>2oP7FSU:?NILWMV6NZ5VV[Rn>`Me4lG4E`gIOL`4CI
Kpab@GMMcEFn7SBMIfRX0@_2NQ4b_kg58B[:;Ta0\0b^T99W:Pq\nBhiNWmkXNUJ
R=P=h`nn8k0VChA4<@DkT4LS9FN`XUimQ@9OCSBj<E3XbA0C7B>hJ_37]pemm4lC
MVd[Vf\BR[41J>Bj4N>4KHH25<M1M^8QHDn:jSQfIY4n0_B72Q]^K:1eXUPbEc0]
nbDYV4e6M4qJUh^7\m\3Lm34HGYmHY`5XQEEoZ?IJ2c7R7lH3InmYE9UNH?7ILS2
:YVBT8q8CIJ;7AZfZX>:VBK2c1D>bne1Q8khmb3gj7YmQ:fSjg1PEjkQ<[Oo<W7:
E7Vn42NPmFD4DmU_SMOimqPh0k6m[VZD?YDY5QYG68WP98ldqA:VZ?a`\W7WR=_=
jYb[;1bKiCCLbJgJ`nMU]RC2?Ea=RVLpmmMPG`X4^2l48eEZ`5i>0iRTBIlB=f0j
L9C[GBLFPO6Q1\Uijik77Bpd]@Uj\HONjL76H>TY]\A3@VDCO=<IGUl9bjMC<[XL
PmeR8Ca^`\:1MNeYAfq46AeSh5]43HJ[4`j@f6M>[Tgg0S0Jkca<866d[37`IQ`Y
__8Mc9I1aUC`811:9]nUIm7M=qb;H?Nh1UPTeGV[m0?cnX6fKFdVAP;4i8eRE\VM
eE9iTaWU6m7ccaqD<\V^VO_FA;\G@3[OYk[G;X:8k\7N3bjQMSdO1:^OI@cgbNo5
5>c7Q1eiQgj9aH`cK\YI8BENKa4oaqHBlSfJ72fWDYmof]CIY1bS:W?lMi_GfbXQ
Z2ZZjbB\S\8D=>\_J`0MOE\9fkGlV=SdQ2DUJf=f^pHbm34F`WT8dH5]hg]mCM=K
dl5XQ3<a9RCQ^QX`1<PKdA7eq<9K9dMP<AKAnO9W;1UkZMFB^_jBQOU4cL`V9PTZ
PVaElAH]DkK9ZnKg7[KF8m6pn9<B9oiiZ@3[@5]TO0cS]\>32W]YC4R_H7G[R:DD
1Od=Lk?5BRbd4C@^JUAE5_cYCIm276pHQ2iT\0H97JRGNnD`J]SmNZ@_I6\\[E<^
8TGZ92IVl>X\?ql8<gdN>]kQVM9I_\m2SXcE23hR?>AGlGWb4L[YmoiiQn:_3BqG
O8kQbZOD>2:^JBa:0p[=N\8ORVi5khMmiTSF1dS069OJBX8K[JkZ9mhbOj@MCQeV
DQL;9ILd]WqJ=dJjnS`R8NHSY]9CHC]AfX8@T`S\;Be1cL`XU:2;abWc<oG4_>qB
:\NWN[XU>_RFJYJegLFePi9U=4^?3e[XQ4JUM?SLHZqT3\ZefWgk:P\L^3ATOLhK
6V\a@DYm^LPYg7i?U7@Lo<pjR9Kj\@\D13:a[8?<<3P4SSA\S=JHDNMA7HaYo_cp
F;M88^4ci4mo5TE1@4DgM18ORFE4agVb:Kkg3[<6[Hepbo<I=D[[<je35A_8;a`N
LDe^G`qMj?cdI3>c5VdS@\melKB^kdP?MJAf=0S6??S1EaQqgN;?DlKSTBV^>fOH
I?kU0ADcWohG9i;V290]AZ;cDki\9iqbc0:aVg<KVVa;g?eHb5_YedkO=@41204H
gl;MHdniYbq20d`T?@Uo88KH5>k[aIdTolLh5=bmXfkNaJfR?jSqkQEb^a59fK7S
_nVJll5LD3Pjf\Di_Bj7G53L]dhg4?RqC4MJY8X77aOD<JFSObTiNJ1g6E=BiIB>
hdad?o9nO>DjDJKDD\ZLa2RFLaND]NqNS?l?InNCBFG?Dn_FYA;H@CfBIfUgF]:o
m70X[doKenLjFOJ?=c2MFIH1EQXg0qL7Gl1fXbmB2WaPj6oEn\EUA`p]IbBK\0CU
^gL]BE7;A7V1=n[b8h@d7k6>oM0@f;fAF=gH=c9iS:i6EX52=G5==K9g\5@;:qk6
1D;mGgf[Wh?F232:cCl`Jc6Gf^8d3fbB2bAlnn:S^co3<chI[FHRkMpXbn\dHF5S
00`0:R^i0lI`g3k2DUQIORLWEX=032knNQ0S5P6VVD=8T8`Jk1p9[Ob@C5U0XgC^
bnmo8\?VHTFa?F4aKSmi@4R8]2nAe8IhS6giZapVoMUb<[H5\:alflI1F=A0@DS6
E3^a7LN8c`F4\\2mI4:hhfRQg7p\`?FS1<V^[Vf3J73Zc9]^>I]\;C_DoD=LLX?n
_aV0K6IA90>GSG5]@a7XCkemEj3gF1qVk;C=]^MNn<C;1`35UXCPY=\L:a\PZL<E
lTAi;\48NjQe6m?mec_L6inaA7kkVd9V^?]p2lDChGGXok\WgFA3?VN0DmZYCNXG
GX?Fcca5G@<d2PN?M;2\Uil[f^2Q19^hH<A\XmOf?kH?gCkOWQSXNFbLY^DYCDB0
TY3Q`W1pLC3mkVnfI;N`]`Xj_hh>j3V;`HXCk[GKJKDY85WXfEdPJ9<gK2pEgW`f
KYPS533dOl_RA6JUF;Y^_Sje`3P84?2aSpcXT<[CEe?oeJhVCmH>K<87[nR1>SmX
haMWOCbGo]PWbqVC4:X<7<TfPhl9UUSRbo[?GSW\b;CiVHq9QKU?Zon8YlTGl;@G
KE>78MCN:_oS@G0cV<qdOhDCU7Ef6JLZ5aPA_1Q6N=?CF:GF>M<?a_pmUnFCdI[2
64P:e0JndkKNnj_d?V^nnU4qJB7=g\f:7FcAgSe``FXV5Id2mJ[ZD]Xj`70plYRK
E8j76=79Qh07IJ:6]Wd_`<>p`U;G^G?d^KjMPTH>2i>DMT\YO^EPHZBJpk<:W=YR
K`?e90W1k;X4CH=<?BG5Rjm4H`TH9a5XLNJ[pgLUnb_>G0`<SXL=`OP?U^5=E:YJ
D4`1lD8]pWHgcDa<mCZ^k4fNFDJ8=BCa5ao\ES\o:[oGp2o@Ah8e3^n6FM9iQ8eW
?fbGkLFUS@7mEKFlqROUSni;l?hIMF__oCWkDMX9FI1a?No6ZqS1Yn9TEgS7Z]m5
Y4R8]GcM5U5Q<adeY^S7l[0ep@NnM5@9H6I1<m2KeB?5LgY]T4a@ag[f@2Z2EZS?
mE0jkH75kFRg7l:np?DFYY9UjdOXNUZg76RU>ERPCgVWVa5^I<dbpLdg4JdR<0VA
cJeeJ2>MUjnUBiamTQ@1:pDD;1AVh73T>IPU=Pj22diCd5C0XIcVQKm6F5`N`95U
9p`bQYdPCaoBX96PSo<UYVF:^24A[FMcHIImGSM38;GWII[7<I5WbM6oqZ@5Q]nF
HaPdkea@_P7>IBe7VYI9NpPVaNIMbiaW>L\FTK4S<\IY2je[I6bbN?DRfe_Y4e`9
gV6>3cpMUV6eTDWTa\IB829E6_1S53JU0QZiCmEd?RGLlpUjWUGh1T>\<WO]S`88
6]\Ub7Qa<PUPm]h69NjVlCXlf3\B_jqjSojV@c4]UL^GW6lFKlI>ba<7<[3\TC0a
GT4n^f0G6ZYa5FjPJM?kkckpd:JOPndNXn_CjLGSHK6AABP;KC5_<i6;ccA2T4Ql
<SVJ4ZL=qFOV5mk6WF42KN[C80hDXA@MDh=W5Wf=8YU[0C@l2lGfj4SHF:]npn8a
@6cLW90VGbBo0HQL59ff1=5WE;c]WbOA<<Pqhl3fAkLj12;F1DPUUEXZX;19aoge
@o<Fi1oQ[lq?HLBLNUd?Ycfi@fE\gfL3?nJJT<cfGdjXJlB\6iCKU[SeMK;peH8A
^T4J0?n[EZ;?ImZgQ_<GT:K^k1NQEIOPLl^0Q7QM3E>hO<\7^k7[pI7W51D44J4T
fI:FNX:36ZU^6@;:lI;B>2<Ah]4WJNJ15QfbJQ1dpM<R8V@?Z[Z5Fm@ELe0HA2E;
:Bdg\jm;^2VJ;KlW1k8@^9AqA>5E`O5Q53HUYh6i@3m8c8b2UC9DEK?cC18?`7Wb
pSf98j9Z@`=YObSa_J_9UWB3L4l`8\WClJZGoG[RF;hbWTmP9IXbH^5ejqX\F?49
<0J0TcLn2cD3o4L\AXUhlILUSYC3YkFRlI4GgpiFaY6BYJ8LF9OnS0Le?o]Xh6n@
85DR>G^\KnM1X^1lJYM@qG0ce;N7YfQ0V^2ME3ZU03i\A`hRjR2d@8:ffdBHGJc_
V8MCgZf8\X8`8Z=>po9bd`N;3A2[g:IMZCAlA>nOAe]2:_WmdJhdWR6ccN8Nk9c=
K\d6Rh;?kpMk;ZDJ6GT9ikS[1IHl6K3X[fUjeY:`^H4fYjXaqD9a3_5i^4dPUe@M
DCYENi31@:GO14AU<3:AZdM7geoZdC775pgFRbH_deD^kWP@30gZAiCKg]h@Z2\E
cPQ;DNMcFX0\3fFbAcDF:pDHe6G\KDo:TeQF7H<0c]R5E^\Mg]ZGL:U^=INOC@b<
?a=Nf;hlUOAF<kq7k8LA:Q=B[NYC6j8OV_?dYO`1UiHFLRa3C`_XVYmg=7Gi:O\8
ENMA^pH7\EdY>HEfHk5NEYj:CgMi;Zd3Z?0M_H_MTd\iP_MkRcNOfTSH?6R:bGJH
0GZgGRqFNeD_hAV:GM^O7j5Qgo>AlI[?<\?ZIE@4FD]E>TTo;i9a1p;]CHHkgPMK
1426<?BV?kf?TN5g2:aje3[57p4F8jK7KSIScU:]9jB2^;OeJ]X1nc]XAdPF:@2U
L^>XijgD=iZ^>BH2p[2]B1Xg@JXF<0k`j95E@AmPeY1<akJ3G@gQaImmbYO^G3@K
JPA4@FI:W1HSqJ`Z6C7Rg@@a;=ER^06nS\Qb5:cY0f1bDHbDfLVPNS<GiG8WIVWZ
GibV2BZJp?Z2G<7^Tb94@EXM@6MB`S1Q7CRL>;EGfTh@DBNCYn^^:7YpH0Zm^I6>
^YB[fPk?C:>]@B[3m`>6<53^KejWP_PGMmhqBPQBN;NXU[6_ZCNjMDQDnjYmVQoR
H1YELONXe;heOMd=MKO]poLX1L:E>>P]9]=>maJM[SlDAQ;a0ZX:3?4FB2L_@@nB
;\=lOq:aPFgUc<Oiolcc9RYoJ\cC6XSZZHEdCP2XTbZVY>mLE=F7qX6U6Zl8BKjB
N3Ig<[a1SO6g4p2nCD?^5kZ\ld[Cgjh:6X0C4^B\=MF@Z]]3LeaiMlR=?8H>iVla
]j6:VOTi>LDepYd?MK2F?T7SH1=DA<M?a[;C8G5ML_kR@[fUX5aa<]CI2TKnZnAQ
ZdQ:[hU]^DH:BPhhL<VpF?o1<eZ@mMMjeG[7noi@P>nh;i5dFHD>;Kjdn]\Ic?nC
DVq^49jj34hdMGfa66`9QG<]R?a8hYDY[V[5?nPPLe]^4`_g6jbpO1YhmJEH1X>E
ZHH]oCD<FARYi^FifEe[aLZ2\2H<gk<BJJf1O`977[7EpaTIZBcAZ31ce=OLR6oU
E_KEIWHI?[noRP:RH0IcmIbT01\`:HbeqkhbGJE_`I;iJTJ2j07cNm:ZCQ`XZ8Nc
V]kH39i\C@92pLG8dF\BB45PhhBb7Kn4V]2T<WmmQ0j5MUH4GAEg\ARIo^ogXNAY
O^a>5]5^ZX7dg^B>;7b:Qq0Zl0TO53[oE]3N=@KAN\;UJg3D7mJGAdA^4C8N5UQ?
Pq?KI:S:LgSfT2kcJOUS>0]O1EH^ZbnBGIH=d]jY45qZERC:1F4jM?7B`M8WmB2l
kEGI3dCbV9nXe?0V?bFWW;qB^I8IHATkO8FQh035BY?g_>T<T1lQ9EnLIGbq5YcC
8N^MU>@77gM09A\cn;ahXmEIHS9:MIeRS_JBq65bl7?`]a:`IhRm67XiZ;[oCR_\
R[0GFeK48LOD:f2Wl4XpWL<:nQ6;SFTL<og>1:jhMfPFfS>KL][f?ifmG^c1BOip
AeOR[e2l76\?EPRWX<9bfD2IcgYK7i[KoN>;4FEAqSbO`]I2bg7gh68oY:J@L[QM
c\5MV4a7;lCOgbZJYF@0pIJ7R>md71l`e]jQMk4i?RXKN6^`nAVNY:S4XQhZD[nN
XRN6ILN;9LobfI<Za74PAg_bqIoB_XCUJ?[fPQ3lSn^N]XOk_]bFQG]Z]UC]>E5Z
mXPP9dfD20M7n[gqlkKhg<FY>[@Whc??VLnQ5gNOWA@Y3HIk09:0D8b4M6lePGn5
VAEFdXF5[5RE;5E2<8SRQ3qlm>\VV<<kj\75o_fLH_cL;:Nc6onR97Vn1BZJEF8_
ZI8IA<[5f][PSTB5Q2G;2o:8^ie;8<UR>fB[4qkFEgm7HC3^6gm64iSBL<PD@]0E
dUc:Q32L_0HL2doKPoXFZ<[GX;;Xpd1OTgOGf7h^hB9\>FL:f9@U4lH?OSk`S9`8
KST:`]fBKM2`YhNKVVEA09S1]\EYHRmNWG>qR\MfXgXCAU0687IJnd0nmIfbWF;Y
]?Y=l^VJ7\^E;V?h1BCej40RJGc?q6khcHOn;G>V;:8K?GJ`oc@aehDlPQWbk2g_
j8DoH2OUa7[55_;G=f3]S75U=V0ODq9Wc?1YeJjShO[ff9?MPe812LPEoEf^M^Oe
>lhj:PGWC0F96=>?H]iDd;im:q]0no4Fm]?\hV@ZnLMl4<EdjDSH9OfRin04?a6m
SV]8YB7g89FV<p2B_>fVgOGfg_O`mgVOSg7K6oR>RLaQC1Th`E^jbeXSA7@B3=q]
U6m7^X3Ge`YhcB`aMK_@4qk;T>[YLY^3`W?0ce[]3dGRKVHLEKfd\j7Q[aQH8>`b
AF:Nm8R3bpf]5XMk]^Lf\8D1Q4\aTQ1OUhS2jB[S9XlJP??m>D2Z<]a@8hg@j4c^
q4n:>;ng_WOC3WU9LMKmFAk3W]X<ZT^nkB[DJ[123Gndc?[h4n7jpEc27QLl1k@o
SC`W[ViQ9J<0Q<P7=aSIm5ObFjgT5d>iBQOcCd@PHjB4F@i[a9njNZWpSd^Z^OHk
9M25V]0SSh;Kkg1[9Q@bibCCFo[FX>>[UGTnl^]Vq]`\Fi3?BBjAYM:f=9?nWY`3
6D1`7GA2U4DoniaA>\aK>CaJm17mpB=Fd^>5h7W>Sf6_WMj]V@a0Okbg_e]iC<LL
nP>>Qp<1YhR>ni>oZOOeUT9K^nf_W:h6Bg<`bafcKn^1q@dCOXJX_WA@i\O72dU3
`el4G=^k<2PJ7FPLh22g8p;R5eam`j07kU;M]VRkdfgMiFk01LLBU\=KD>d7j^pB
5h`=\aGWWPEXEoL?gQ;M\?6;K9F>7WD27N`6TpjDF2KNOT059Y\on@oQDW^ULf]T
h?3Z`H0[faK9a>Nk0U=QX\2aWkgli=p6?UAd`ncPlhDEh=bnTTk3GJODb`3[LJX2
2^^_e]Dq]fUXlM7ZdPOSKcR7YW;fE57F^J^MgcD]L7`?mXTjq3;7BXo2c_g:0R1o
Bgi<UB<00L:X46R72FE\@O>h:K:hpE\of4k9MWPOid8M;cJZJnR1XOL:m@iZnmJo
<NCiifPV>Q4I6p\BFRA^nm_H`UkdeF0]Sh6SXG0ha18bC`8cqcEB`Q1JE3kbEWa=
n_Jg<Tgj7d0mP`Tk9RPTac4a;?0T?0Ap:PeQmed;_[m<K^@Y;lP?SDob2ZW8RI[H
Aj3T3P0;7AViOAW?pPCPTH;a?MMDTe[=a@m8k84i5I@=D31`CYl[h:_;B;=@XB?6
Dq;`GKjIVW0Ji9:`G\F0`YhQIIoNJ:]_;o\L\=^\7ER\m3Nbpfe<GZ`NB]YL>?Hc
W<EGBK`XAL`iRa<o`JPUW9`B;GPcl;3VDQ@KCkNnEl5D\h4f=Y]YLpmf:BgUmdoD
cdcfg@hG8Kj4<KM`Kd62XS_Uo?N0gBBaoeY8b;q^Y1_A^M@Dc@l0`04?GM8>J6EV
SBdU2D?CZ^XeXDYZ>ACAfeMq26@UJeaaIRh0KC5>0c<T\V4FN;aS2oE^D>R8XOkF
1m<Z52=BH]=p`VR=^WC3FfFgmKIfWg=0;oMB7[2IQBknF\iXeXEoqXGM\N[923U1
Fgo6AXYm]3U>mROZS@MXbQ:TJSlpUeNMokS5@_\36jZJQ0Kb:Vil:f^hYE7bXfcH
X9FNqcJ2G1MB4I>c4ElLH?3SKYAg@?8U;jdUhGB`ZncBhnCFfQ5T01o8N@IgRfIZ
\R\p17RlY2FTem^`;Smi_G4\_ADN@S]fk4N@Y\Kd;E?DJUH1c?V\TTHM9iU`bdZD
g3KaBEL@OaF\^^g7j<3Z4XMRhoq5^LGoSUVC`kXBo65\T1CUB?D>b3AX7WaRAl[^
aJ1P]4LpeWPWFLiIo0i@5hRRT`9DP\15YCO5KL3KGQdU>N82U4h^[GoJnRO]Cinf
SNKQ`_pL1LX93:5:=JibKXA32<m_53C\EIa7mPG1hV[nA\iSX3MIGD7JXQ]\bF?=
ZQhG@VCqFKfG1\mQU`n^?W;1cQTFVQJjJ:h\cnbE?bA\Z;S[U?[e^OMdf1FXSP_E
`_C>YTUk]9Ap<^iOUKA^SX6o_kTDYTP;@8]d1;;U[cKO0C6GeV?ClgBgM9h2b\VS
oJbU5Y`6b62?p[@m^S[<?bfBMTde:dTF8^`eePL8UP;2h[03mK5`N[m\D3e=000n
5QonpF9bnnknRLgLBDU<7m@P7SUPSkS=W_3D:MYee;]\W35]7EI[>6hl1N13pjTX
?K:[8h=LdUj:PlK1d[]aT7_FJCbV:JPX16idZf0oW9_qgAYA:SYbBBaA^=X]c<nf
:K=9K[>EjUkI[G1hAIHFZifN^dOGN2he;iX4[^YPO>8S29E`H8dCdMi><0AjbbaY
9P4MoDfehh@LGa`UR=LmRL?MD2:`YU0gR>jCK[jNIGh]Ym3lhYS[o]dZp1<CnkWn
Y5NIaOCEDoSaL;SYPf52K4>c[9Yj@S6nf\lB?FDXhP2Z2c?4:Oa7oobOP]Gd`l<F
^Dea3QDGgY5]m8FTWckX5bJcEl04GPH<=E2>WlRA_O40gVCD[1WbHbROh:YMabXS
bNek^@K5h=YofqgMHKioY9NhejP]N>:^ZCi[Se8E?JbIpd_c@XCbAEMTO:?R070W
\7]]iiMeF4K3o]mR4G>FUa@hpHh=lB6W7<M3jXbnIPnW6Gg6>7\g?RPLbDF`:[;>
:[DR?Ia6e0eJp^@>]bkhSPdbeAfj@K^9kfF`L@4=FciF`ATk0nnfW?IQPke`]O1=
_X=WNNE;qEQC@ON1@8[7n:@7AcZF7`JbB5NcJ_]Y8F;0YUnB0=Q@ST]h>693NaXp
ZVc_\1iX1hP;>39^Dc_K?BW02EGcelDSk9QC:\k9T3=oq0?c`9inFA0:D@;PM2SR
?Ba6XN?5\MH=i4kKN=4^Tq1YI^`fi6E76F8Q8OE5QP4kOb9l]haJ3A`[jo]6JT]C
TJ?eDa]HMh4GXA>R[V0OPSjJCp4WkSUYX@gUgmPaPDYNSD7X2XAg;0WRKC4m=PlW
UNGf;<c;:ZpWXDBXMbLCGJfZbDJeR68YiA^jIT:SaCYFUNSUoO8b=3:YBbqF2XY0
a:DK3QDXUJ0g1=1SOnW0k?kK>O]V:5T\mM696mnn4KjKTDQpDEXZU<8C?icR3>Mm
`;4b2T=436oj79OR[F28c_p7aFPEhj2QQY5I<q?PXO9^ZKD7Sm]V=RZg_[c7mD?>
fh]\W@b;[cG1fgRjN4pP8BQcKE]gXd:Y_@nY5iGiTY9E:gJ6UX^2]M@BQb\D8=G4
glopAYc?K2bl^R3b7kjG`7R05@UCn4YQ]U<`Z3X9@KVG:6m[B^BbI7>p75]BSlZL
E\>Nm>jE8GLSfjTf=o^]ZRD27ohdjLcRAH?qCdA6\gAR61fZZ4AIQ@1K<CO=Qnq2
I9X^11jN`Nl2cW]klCaJ=4>oML3RC8d@=]QN^>RWP09kkfOq3lg5ITHUHejJgf4i
L23QL29_]3ELg73mK\klF2c`RRY2RYjqYPl1F1^En:J3g1Je\i@?PE07[Yl[cY[E
QFPE]Tiim[]@6P@qXKa9Bh9N:nl0bZDOP8HF7IFl>OT_=RZI<<735bTOP6pA<=kf
m3l9]2O4EIgJdS]V5lSH7BK]_`nJ:E;6P1ZPcUCOTp?Kl?j_;KdMRk<DQolnIfQV
D]jR1k@[mY14l]8C>oSIS77LQpb`6jIODL?;a>FZgM8X88Z5;:mBRQMNej`>eM=n
bS]947Ga<0]m=gV6IAUIRd@B;qoJLgMc3Oin0Z0:aH^2YQi]Z7?XekS5m@0_33:f
n[cbh@]]LI69mE:U_EkPUnQ6TbpS<kn=a82h>?CMP7Ne2\K20<03A<o<4=fOEoE0
]FI5>R\OOOHZ]P1@2@RG7C3D0EU=^pPDJD3OOJOQB;gJYVB`kIFgaSe><Hn4X4>h
5kTZncOH[?=5`kLVeIVgK=:od1]2CV2?KWbGbp6CDdbLA8XNT1da\ddd342@NF0<
nHKKRgI[GmISQ>f4DkAQJde13A4@5Q[O=RfBP8QapgJP46I7K7e5lg9@97mT77TG
WVAO2H97:_8`o9=VHS@UVnN^77]PManDoWASI4SeeeJi4q21Z=k4Io9Z2\>Ha_i[
1KHC9ccc7kgUU=RBhWF5N4c[dMl_kTcQGG3dXJ\6O3C22P^9AGpBTMNHc:X7iZ`R
TD?TN`]EJhPThDPeCQY@8eh\VmTC4S:EM^PGPheqf;V3RK@^B=Pj]^[0MkOhmo`9
ejD[\Yk[JY[78?SLRdib5TAHTRS5@PXoP^`XS7pCbi4=JeNmI0b4inb58NfIGSH;
[nNOoBAgiVTkSahPlfT0AnEng_CF:[gI0=7Mm`IpmZ]HmS61cL=e35^ASa74Hg9e
\m2Zahg9VH]@\`o`n^jbjNIEBYaB<ik@Q`HY`0o5qCUFjVRQSNkc<b5\^@`XNZbm
NPo[CFc6L]oDO=MhNk2^U7N;TEnC^LQ0>PDH9KW;QQ1q=]Wkg6<H2KJSJjlKTjgm
9TU^HK]]YF_GjX`S6ig9T:IL3AES?aEI_n_od;[pm\UCF^CTGLZX7>UiXLejW?Kc
B2iM9?o^UN2CL735YA3\4^NHMWAIP7SAajEN_1MVpgloT>P>2YNE>BLTWPeTCO@Z
8UL>[9L<HOYQ3Bd1D=EV]XZdOkM=C=O;C7eA9BI<qD[_dVjY8=]fTV\INXeX7EnZ
PojH_B`2cahjd?RA1MO]c:cnSE=`5?\iaW]jB?ApSb245]]3FZP0a`KYbRNe776Y
bY<:7fTEN2FnI00_dA7?Qob]iKq0QJdM\]5>D[PPn\Qm57P:85Y:l8O?h`EdCCiD
8@K8`Rn<A;4YL_0pT0XS[\hBYai5K4\ml]2aS@Lm:c1aBl`o=@>Ya]=\>2U\PG1m
a21gK6KUb0pn\_5<GYA?9D\HFFddR=RYUf]_jOQY\K0JCYP6TZPYBegSU4?HPb4:
cKkA`aIb100AmGfphQ]mA7IUSDTlGaED7bQ5P1=Fm2:_giNRPNlZ8mqfE6_9M`AY
olPZV<O];UjWkKeZ1iSUoUm[1b<q91A6XEX^S6KE=gmnPRGa9i3D09[>h>\44KK3
L?eaTJ8;IZYKYHpLH\bEZ\Go:dj[oVK5PqnCi@O?;?:G=RnWhficoAZjh``ceZcS
51>hm>PNiAg=b2U22p6nL9f86FRH13HBW2bXQY7dS0T7T:h@IG]`eKHCpG>8FnYD
l3jCoVP_a0Zj;3TE^<no^>I38>Z`Tp<]FP7EWbi5_\X4]If@R5WX>Y1TKOIdbAaf
_bdkb8QVp?eRXRECXb7W>62XTaLP:3PeiXLgkl4dc6Mk4j:]jpVFeLcWFG=c7QWM
f_iE9DDR^4lZ=aYiB7SB_n7V`Rf>^5TK7fT_`mahpJ9PF8UPXO^iWZMKKB?j\?63
lg3Xi3:j0@ff4b_dEOmgg^3eqKmmD;=mHmKGCNF2W0YbcleF4a_Kc:E8j^9E8W_;
;K=iadmMH^1Tp@oOTSCfMc4hK7MN1MMIdPSW[5X2WL7fikYIV`:de6EqnhB?b>PT
:f6h:?T?HAWAVm28ZkPRadSZ:WAaG7U6p9`gBP>He<YKDQoKNdhPM;>F6:E1omRh
\8ULC5HnGiY<LeB74RY_5WCq]b8[mXkRXc_djTJ02PF:hmmJ6DQ5IVingF6k_SG]
OS4SSYIh7O]?pLTAB8>d512@AEZcfhFI=ZF^j1T8cMV3`_Gk0nMClRdYol]^Wc4:
DI8i;B[f:N;DmOeK<F7Fh1P\a3CDBSP;CFQS4HW@mA:N17[X=Q?FIPEY>X3\[;_m
p?IXA2a5`KFg@dGabk_`5GoQmDPUn:?YDjLZo\VbV49:5W_=[11Zc>ilEpMOX^gY
amWUEmIW1X2Q_6X:Td@?D2R5?S\AQ5RkA;q<F\B^WiFgZXeeIK@__=JUmI49I`B\
EOLHIJlZda4Sc=\ScM\cjhYAHA6mDV=q_RU0B=cZo^F46fG60bT=mZ:Pd9RRFjcR
m<=`gTW@g@`hfWHjkVlBoJV;1e3U[_NYDS^58=VPDN6Zkiaf_i=_di:^<I;TP7=i
TfP?fZiWCnRcG5[kOOFM@6p`jaN?D7B>AOUCY37K`9QY3m[oQdd6N9G4j1:6FiKR
oPqIUo>=HhTiR2fNMC<\n4^LhIlGWT<WcVd_\N?3lL@jcp7CRcGkj?b>oCX0_H``
j[9g`H^`=?CO3@Rl7Sgo5L5=hLFO5kT>he8hOp5WZ8mUV0OlbG8PMSEKoQJR[G0o
mSAjo\ilTJ_li=:TEf>UlQRMG9qBm2di``7lAKTIAcLH<01Z5[ha51SabS^CDM1A
gU>cSFpVX2?NFDB[S\mP1?LL?Gk?<2C;dPOdOmoL9b;=a3Kd6q=h6_F0b7LJBZKk
Nj\62_W2:275iXBoD>@?<l1DePDR2Lbg_oc`0=H<TphS;WSP^dFLVLhm23O85=7f
oMn_]1B4We>mbDYFOnY1MH;oD04C3\EY<HmABGlY>Ocmqh[_k;2H[fRZJbdBbZKK
;gYbdgBQRG2XNO27T:gW15JYdAIhB<JmV1jG0:g<$
`endprotected
endmodule // module vusb_hs_dma_dev_amba_apb

