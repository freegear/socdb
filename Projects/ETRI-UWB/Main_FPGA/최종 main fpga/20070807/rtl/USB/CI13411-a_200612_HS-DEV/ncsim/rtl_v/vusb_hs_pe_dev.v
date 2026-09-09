/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_pe_dev.vhdl
-- Date Created: Thu Dec 21 22:42:37 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_pe_dev.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//     Top level PE structure to combine Protocol Engine block necessary
//     for device functions.
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
//  $Date: 2006-01-06 17:41:13 +0000 (Fri, 06 Jan 2006) $                                                                       
//  $Revision: 2 $                                                                   
module vusb_hs_pe_dev (pe_clk,
   pe_rst,
   pe_rst_a,
   pe_up_dev_setup_mode,
   pe_up_addr,
   pe_up_datard,
   pe_up_datawr,
   pe_up_sof_irq_tog,
   pe_up_dev_sus_irq,
   pe_up_dev_nak_irq,
   pe_up_wr_be,
   pe_up_wr_handshake,
   pe_up_wr_tog_en,
   pe_up_dev_rst_irq,
   pe_ep_prime_cmd,
   pe_ep_prime_cmd_complete_tog,
   pe_ep_prime_cmd_fail_tog,
   pe_ep_prime_cmd_handshake_tog,
   pe_ep_prime_cmd_tog,
   pe_ep_prime_num,
   pe_ep_prime_rx_tx,
   pe_ep_prime_max_pkt_len,
   pe_ep_stream_disable,
   pe_tx_tag,
   pe_tx_data,
   pe_tx_empty,
   pe_tx_idle,
   pe_tx_flush,
   pe_tx_rd,
   pe_tx_ep,
   pe_tx_ep_early,
   pe_tx_early_val,
   pe_rx_tag,
   pe_rx_data,
   pe_rx_full,
   pe_rx_wr,
   portctrl_bus_reset,
   portctrl_suspend,
   portctrl_clk_valid,
   portctrl_test_pkt,
   portctrl_test_se0_nak,
   portctrl_force_bit_stuff,
   portctrl_pe_busy,
   portctrl_speed_sel,
   portctrl_rx_err,
   portctrl_rx_valid_b,
   portctrl_rx_data,
   portctrl_tx_ready,
   portctrl_tx_done,
   portctrl_tx_valid_b,
   portctrl_tx_valid_early,
   portctrl_tx_valid_last,
   portctrl_tx_data,
   portctrl_bto,
   portctrl_flow_en,
   timebase_1us_tog,
   timebase_125us_tog,
   vframe);
parameter eptx = 2'b 10;
parameter eptxa = 1'b 1;
parameter eprx = 2'b 10;
parameter eprxa = 1'b 1;

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   pe_clk; //  pe clock
input   pe_rst; //  pe synchronous reset
input   pe_rst_a; //  pe asynchronous reset
input   pe_up_dev_setup_mode; 
input   [8:2] pe_up_addr; 
output   [31:0] pe_up_datard; 
input   [31:0] pe_up_datawr; 
output   pe_up_sof_irq_tog; 
output   pe_up_dev_sus_irq; 
output   pe_up_dev_nak_irq; 
input   [3:0] pe_up_wr_be; //  write byte enables
output   pe_up_wr_handshake; 
input   pe_up_wr_tog_en; 
output   pe_up_dev_rst_irq; 
input   [2:0] pe_ep_prime_cmd; 
output   pe_ep_prime_cmd_complete_tog; 
output   pe_ep_prime_cmd_fail_tog; 
output   pe_ep_prime_cmd_handshake_tog; 
input   pe_ep_prime_cmd_tog; 
input   [3:0] pe_ep_prime_num; 
input   pe_ep_prime_rx_tx; 
input   [10:0] pe_ep_prime_max_pkt_len; 
input   pe_ep_stream_disable; 
input   [3:0] pe_tx_tag; 
input   [15:0] pe_tx_data; 
input   [15:0] pe_tx_empty; 
output   pe_tx_idle; 
output   [15:0] pe_tx_flush; 
output   pe_tx_rd; 
output   [3:0] pe_tx_ep; 
output   [3:0] pe_tx_ep_early; 
output   pe_tx_early_val; 
output   [3:0] pe_rx_tag; 
output   [15:0] pe_rx_data; 
input   pe_rx_full; 
output   pe_rx_wr; 
input   portctrl_bus_reset; //  to tell uP there has been a bus reset (device only)
input   portctrl_suspend; //  port has detected suspend (device only)
input   portctrl_clk_valid; //  30Mhz clock enable
input   portctrl_test_pkt; //  tells pe to send test packet
input   portctrl_test_se0_nak; //  tells pe to test_se0_nak
output   portctrl_force_bit_stuff; //  indicate to pc to enable bit stuff err generation
output   portctrl_pe_busy; //  indicate to pc that a transaction is in progress
input   [1:0] portctrl_speed_sel; //  port speed to properly generate handshakes (device only)
input   portctrl_rx_err; //  Bit Stuff or other err
input   [2:0] portctrl_rx_valid_b; //  Byte Info of PC rx data
input   [15:0] portctrl_rx_data; 
input   portctrl_tx_ready; 
input   portctrl_tx_done; //  PC has no buffered data
output   [1:0] portctrl_tx_valid_b; //  Byte Info to PC
output   portctrl_tx_valid_early; //  Byte Info to PC
output   portctrl_tx_valid_last; //  Byte Info to PC
output   [15:0] portctrl_tx_data; 
input   portctrl_bto; //  PC has no buffered data
input   portctrl_flow_en; 
output   timebase_1us_tog; 
output   timebase_125us_tog; 
output   vframe; 
`protected
Wn7KLSQd5DT^<\dXAMdRKLlE4m;DH`h_iSY_HC\^TS3m:IqhamWG^dPbKlj3:c0l
baUYHSBe\AMRjCj_lJ5Uc<Sh7pRXK5HKQ1RgTJZjNfbaF]GE6Y:G\o[2`Oj=>VcT
:MHfFEDkZNI^q8F2HHmq;o1Q\]RU2F\e?=mG>Y?RgM>B7aXd3`\L\QTY_7agq9Ii
IhZ?@j>BFkGIJ]^Y]8hiKlUnV53XcpH6XcMX^HkTAOBJ`WLgj4NgQO<f9eh1[EpY
Cg<L6Ro[S14j;Kg@W4NobEl@IDX0cJ<q3PGOe7NclEJAIQ_p=bg?3>oCJ93L;]E0
8dI[TjQnZ_lnml4859q?k0NW?7\jMoY@25gUF0>gKG^5Z[XNFV?p>57hQPTE8>`k
^MKGZnRE8PGNilR]?[R][P8G5VYk8>gg5]epB[5Hc`U=3GKL>\o^=oZaIj0bWn?:
b[;i=Y^BNCh9B1pdoLZkj_`X3_=EMbdBh4?4VDCdEklND2gg]6AVZY5k4BJ]f4=p
FPL6@3bZej1UcWZiMf3LXV5q>j2J;^M4g_^B41B195=1S\_GaZ`10Q23RVnADIGp
9j:dQ?F?WR=0<@AObHcmqJ[HIfOF_2hZGAU[UA6>L`O:mZVkMj0K0c6q6RPXni\4
;n@S>eIS@jE915df;j6;Z0:1HVEXEoAq7CXC;mFV`ClPJ_;[Ogm:>6`^c_Yg6b93
T_AOQkVh`8qld0E56>;Z[L?_^^VRjm:dEe@IATHJ]qNE[nPGd2[Y=k3j;a`8:A3D
GNhjT2UL63UamqXklX^gTD5TdWU[l]^dSTi[?Q08Vfj\knPTIEU2qe>`T;=35@Hk
cn02GSLE\Y?jEld?Fn:Skc[:NIPJEJJ@f<a4qOM4fo<^3`FC@?G_8DdSJqAN0:jA
oL7E>Yc[9RI`feD;\]1]V;_UdLa=hBk[jL1<q^37UmeF`hRTK2hf<`O9<2^dfOPZ
[F07qCC5<RnEJLF<A4L14gEU017U0GMhm2R\HPgJ=f_\^UG>7bbRYpLOADTeCo3N
\WOeC=lZL]JgM<M8___ZHli?M447kcqT?i:2[]TYN``Hm=hhTX5d0c<Wf7>1Rk63
o[8iLopPY`YD:_YNg@1ciD^`H1B1fAZ@_L6DZL@:A0hoICi`_KCHSmWgCWdqMR0W
hiY2=kH[<JJFNWbAJ54m_30_:C2e?c99:1Z1JgWKYnpn><HQi9IQY17IZHaVIG@b
0VLGM\91a3qM8]1gBCQ`8mBM<nk@0J9MD3eFABlH8MB\kpJGCLcjRWaTa2<CaY1a
pJNSo6ccJb:1nK@8Q>APZ<5GSX;@@81eG`>pi^h^F3;6R8bo8:hp9b2Q0EK<BB>g
F\W:T>oHDQ6BAk^8=3eIjG5eU_bCLKSm8k@WqXY:22ZZ1dEd1XYCm:7?=nnoAd@B
2SAglXm0XWd[iE3IYn1J<`Z`poE3PQMUBB=@g33J;QJdbXGFCE1=10`16:XTmE<B
hk\bOqj;8T1d1QWNEnmBl09PSP[ff`l>[o6bIo[S>o7M6PPkUVAapK_<dYEc;YVl
JP29k]GY=bW@k2G>a@1mlQXiQKYkdKJ=EC_;p?TO^??]l>ZlKlGRVBibY3hQU;\M
AFcYC=[h7`8EplD>P_c37^gWadI5K_QnLb9;O3i48Q^XSGBfjH1eJk<LmLlqU7ge
Oj@3Z;0b\Ae7deT6F]89`S0K?fKJOD<?cWmSh979m1_S5bLpM]\j^Z;AXEQ:_ajT
163o2nZS87S7qFillJY<WQQS:^=KFd0DdGgYHWbK=BVBFJ>Yqnd7Q>k2Yj_g_\iH
3CKn=leTjneNUi98TVcKqIe9Bl<?6<VilgQ>4c_DFiM5B5@5ZXISgKOb>bI4^H4E
qeeJREd^ohRN`nG;K\CY1XbEWF9EbA9XYGGf2M451A<8[E_gq]RNonQQ\^iI?==l
lohJPGFoh_Ge_<La\qVl8;B8AjVCWo]Xa=BQTWOF;cX^ei8NkcMBW`2[C5en=`>_
caQ3aIAUM[@QLpTI_Qg;XZOi785XO2:_RFAI<7I<iIZSde>aXS0D1OE]50A2XQ\L
27E?Japae5EEI:PoOMm[VeeSdd9W9DfdSn27ECT\>=XiBUZhN5flM9p8<@e\\c1\
Zm\2@:lI6CYQ3gE`nB1^[VNWh6BhU^W_ma9JdI0?YLL2AWNdR5p6Yd7=8Ic_AXhU
UQ`SGRGZlFGCfE3i1LdinmFoBMjKJ6hHTLHp`jgH9lGd2X7[`GeID39?W`3?H2Kc
X0MpaA66oVVONfJUO<maHYMFIQ:?EHA]qD7e8b;`j9D7Pn=\dTnIR]\TA_a7RY6?
Zh=qCOVmMh6bSM_^?H=DnWjgLQao;okQA8CVjbMq45T30QhcDZJ7j^RL10_l8i<b
c;V;NVdQD<hFp^:b2_eHXOFkh:?A7RKa>1;\?Y0UKp?fA5l`MMB>9=@B7W:PBad2
ZaUbQD`NB>\g1]q`[^DB0J76QS1E[>LJEQ3P[X4=?`30=q4SD_?2W4UZYXaV370Y
\Xo5T1gUD`:RnX2^=41:SJW?A36\QXqM>lZ>i@f9nQ:<dQXD<]k:oF=DHf6F=p`K
9UB8cQG>bjKNj59]Pe90ojDHO9mHOmn8Ub]9pn=8GXmBi8hk5X`5_748hNM<LUEE
5INA6p16;<5T=nPM:WcH1EJdLQo3OKagO`IY>Wj9Hq?J__j^3CP:Gf=?Oc9lUJZg
igJ4k?6Q9JE23F:F?59T5lZ3:8qnbd5;IJ>;3FBJhR:14To0`WH[:75g=J3KJ41Y
9p\Zi8_2_CAl=IS1b[fE;D:KVDlTScP]q`[S]M[;ABCG6i14^Fi4jTHk39g2G?93
[I281@iLQdXNfC3[qIRMW2J[I?4I\e81P:j96AT;54edO24NaEgNUa4VG`?VgHXn
QZjCn:6OeY[1emO1:fQ^d\__qG07Ybe9k9c_F8b:_=;F_U1]f2EnO@aTLlJk=\<d
qgVS:VUCfFV0H3Hn_GN?RKHJLj2dMP[K[^GK<@UJEVMfR[MhpWKlESA@aWMc;RVR
L5nH_M_`j7C=VH>GY5NS:YM^9_aHMl9\\3eIEH?Qlc`Eq6PcIK=B_KAT6gEcp66D
fQe[jL2R4bBVWfiTgZ_jH:WI1j[[h:gYiY3;U]5h3RKGUJR_<\^1Pp91d9<\_3@I
Qd`<0M0eJ3MS3m04Wf9h5eRCImB4o0N<0[nlkpL?=;XZk:2_Hhn?7hbj>bNFR4Tf
HbQhXo;RNQ[6kOi]SKbG5_hU>me8eg6<FpGAaTPklFX_AQno3RAY8BDWH50\`=c^
PgZIN4>Fd<f99JEl10qGfAf4BXihlKRNPUB?LSh\X>Ghk0X_k7ipMShX5_8MZA2X
D4`:Y\fk5MbZ>k4fIi??HiaoVF9c0C3eplS?o4OS>4;gEZ=RNk[>R?]N;i?V_4jT
dM<K\o@E5:m1aKY[pKnBLA0`KmVmS5=h0o4]m?UK5PYCdnKKAWZfNpD[=NCdW@_N
bj5UVPGRXh1@4:]e9`q@?A1^[6kA4IJ<Ac@[BVci;ETRTOd5O=9><p8SdoJg9c6=
oP>bL0iYjAGj?O2@19<1aVV6<qj9F][YEI_=MBmE\Difa\UA@N01M<T?BN8QHhqH
HGf:kLbTa9;G82V@=\?B7J=ikZXDIf]@IA^0J6p:\Bn?^46RYo3KaIF8;ochm8lJ
cR4d2V7EiW;:a\U6cC;GIfEZXUNmm8pEUc<\<]0:Kj0cIOZD>U91E5Pi0JR5;BfN
l8qaFGa2c@EI?FLIAYHF_Kd]inOC^2nGF`ZK;4FpCR6L<Sf5Alia`g?HQbVRk;of
1Y^o0\7ph6jgbgG_l4@c4B:oJfFoPSVkbZ]Zpg<o65LcYZg^Jn5L7@YmR9oO<O[;
N?YV:?KY3BC:]iWq6<lN<I`UBiilbR@LP[CKDYbh:\O8dKDCjUi2h;Bbkb<=4lTL
CQ6e[a2mO1kkAEn@<Am=6B\dic^Z[hYiUOGOY[1Fc0ZK=5FYMbjJk[i5_5MW]IG8
iClYjn0J;eCa[E3<JopOPI4m8pbJ]G<_R0T;kkN_V7elI8J<Rq_AXl;<gn2]ajB3
RR3d\LOj4bNLTF0`p61g>D1p:\XKfU:4j?4LjG<R3]iZH:X\@C75HA9OQ3CpX;[d
F<q7d?ZPNB:YPR`PLDVHT`VgY5eXUnBih\^YcbMUkl0h_bBFji1^omBVmqAki<BY
4a8_8SHSF4dk]nB2NXmofjqYa]PBTpPLmfL9>Ebe@bWK6gnCHS0Ra5So@P`QGNXT
<ES[UHf7dOlJO?E>HCD^[G=fnDY1o]74Spd9RMSiqo3?ahgLhb3PV?2RRib]8DEm
AV2PZh75F=CT_3?8=pAGY5UlJflGcL]LoFK2UU_[NMQA_6KSKqiBDlS=qjjMoIV<
SnROeBgEWS;];];fgF64F8L>k>ih1jRL3kCNjj1p0?oaLTqL=Q2Remb1\;XXPT3N
M?McbKLFDcj;;?VS=Gki9o=6oq>D_N>OHcc;_^Q^`j@lGm_9[CFE?`:GKkgZ^G[F
oPJ^RN>4q8o@FJRq?>Hj==\gINJLPU7bULUJCLbaI_F]_1kCYDj1@dn9RgiI8;hO
4:85[^`\E?J_iB0Y>mi[YoqEj@GV4qN?NPPcVc812mJ9Iji;VLhfOJGXFjZXm7E3
lm@I2WoeBDTTV\B>O[K?1\2J]iWBpJ>lEKlI_k\33M:dl]5Zm?mX=0A<^fohURhS
LfhYcmHfOgDG>Y]=3i;P=6@Tq:GTn<^qjog4n;PCe[d]`Jg2L3[gf[X1H_@\HnD`
Ti]`A`R4aGf?faRUNY]]BR;HmYipcdCDXlpCXK;18C?e6]@]g6^F=H0H6@clg`HD
Z8FmY>;@h4oBRTDYM4^DBGqDQ1<?[eC^4aBD7n=jWV1b;a2]B4dm0B_naEQGTCd5
]1qAW<5E=p9U;6DdFoHV1S2f>18L]dE58I>9XFlX6^nCQ4\f8kKKX24bimIP\^F=
k2>RnH77pAGhA>CqPPJkS`VV1CSD25mb0^31AedfhRhn@;RiM\DL8f\E\cQ_[`Ta
UVBNh_p6j4Dj2qL_C3R]<I0Fi=HDomkD[;1KXn>SH96>dGjJ8[nELNUc3ZD7<Th5
]aQIAQf=Mq6`blXMLiD5]B4bUjLR\F6S<qe3I7feq>1]^H7L04]IoSATK4L07fCl
W8EcEgnZ>b]g`;F<j7NRF4_Blefmf>cp0YdUBhqP5C3T52TGI4P@BUF]8kCIoSmj
5lgU@:QibJGX`3;gKH:FaHF>oaIc\S5oD\3<]n4Ji94m4ek0SNT@W8:N7\bmJGIp
fMCHFVpmFK4<bUeIIl;YUH_[<e\a700S6G3ZOge089f2G<Lo>@0SNG_;d=lFh8mW
eoqDGHBk1`[2k:Z<Z98dTAD?nliLn_Gg<V\moSXhTd4DfVE5Cl@Y1]U\:TIl?NXG
d3HeH;Si;HVoEQOBDpUZScNcpdC:Hil<]G<k3\Y\KQ_1bPUam<]Wj8CEJ>di?jO5
:_HM@PEFoil]<n3DOd<`M5m?mH5oF]DAP`Zh\ko9^EX@KI@]QZFgp1WB0>=pZ`W`
64P7IZVZb<;N4AnK^[cM6hW8@UQ=K>SV`2Dl;EU9^`mVhjMaIhPab;1i\;PAqL>0
iC_]NkBT0B`FHk;hl0h1BbK;=g1AN:jHRJ9V3dG0MVQXqW<BVnkq2EYT\[n:GC5e
DWXa9OXE<[6\8::0@ClJGVhAGK;MT0e^1=3hJPYDm?q1h24k;q@\\0AJHVR5ZoNA
>jn[C<;iYOWWAKkC>dGbFggXQH4j@;:m0E9lRi8F]C>X>qG<FlEhpYb5>=TWT3j;
m@0:37kHXiJe>`LQ9:X4Aa[`OW3NAP1laQYB;Cn=M<1=ZTk0\ofPP>fb3CEZXXH=
qTUcbB1piZo2:@9^^OUh3R^O\4AANhSMPWidaLjIAVGI]5<X]P\@@a[1=e<mm@YX
Qg7DeKm39f`q4;?>_mq@]U=hjmO;9Z:QHXFbacE:kMc@XNG=`Q\YU>[CAGQ4CfDf
ne0K]FmTT1Kj5XUZJB=pXn[gdVIF1VTK`04m9e:DK:W<E5aTBEQB7NK^c]S60T]U
j5NM7<5>[WOkHCS_CSp2;IEZ<qg7YjXdceMRJ7OJfZVG1Im:0_OYeADUg9_nGC]G
^G9j=o5SP:KFP<jE[ZP;3pNd3^IkqKIaS@?LBflFFeWgOXWT56HnfNJN^3WbU\gK
g`IMXOZ[T:GAT<`35\Z>SZ=hUjdH]CcRdnCqL4=BZmqa^DRcPF;`YfCYd`1Ja9^3
2na<G>AgNh_gk`l4b<_X>Lf2cAb8oJKA=q]=37X6Z<Pe=BR6S`6mThA]EVbXG1Qd
?ac0dn4m\Y9^L?@W[SkQT32B;8edFMhROOL;emN@lOpIO6jE8p8LaaUVm[JVa=Qo
C\f?j@lMmj4?J]Wm]PV=2FmWgGi`]AHSA9]:Y>cL1c:3EndBTBpRFbi^hpAO=ndV
9AV>;CYeJdVA1mlV0]2a;fa@c[1Z[9VG[klCQaCH=KLbT\J>oRqW5nS\WpWe>YHR
`a?`NicX9<ZWGS7SK56=InRX7F;NDS>;G[3nhaG[MUNnKDRYFR1Q4qO3Bm@cpBm?
nVW1iUF6^1V4eo@Z2ak\dCGCYc57jAEC>L:k5o\3@5kNTP<WOYMIRbIGH<1p<2]<
DJfE4HCCQ9:ZZ=jBbjm;A]]iFDk]\8_l]a<F5BnWUEEj;<GP3LZ5qdQQg0Eq9mP0
]]`V5PE_IK9Q<Wb2PV<bGO=68TnKM4\C=ckEDknBUJ0K<lI;Mj9@WGYh<QqG4=GB
YqZcjmDG9QM0?anR>[H2LM9C2a\mX;hUooWKh@\TSDJMYS3HfJM?CUX:LRq]d_6U
aq5@KB7nQHcSIgNJ:c5:\oD3=LL<D9LF<1<H^L<226>eGA3bpnZd\hMpmmRAmnZ\
^<A@0n^keObGl6DRHIS:WNKIbU2aEVG\pmbA;bdm[@cE[hiLPh`3h`Hp:iLEh`qo
2d;KjR]8<eG3G;X:M^:3Yg;JAPFPTImkf[FM3icO?hpSLoZBGp`91SIiEX9UB;nH
R5AoFRZQMpUCe>;>K3e<]3A1b01Ua@Pn]7lK0\9Fc=cZ>0[eC?b<^heDh<J:8=lP
mmYCZ]Z^qISmTZ6q7=ZQTNcV[[h0EJM\VFK4;TEb7L8fCQUC31T9jmRK?0HiYeU5
B5UOiHAn>=B@49OLaR62Lmpd\@:J9pXfRQN]`QW=NJ6R1mPaF@PSA>Z9]H6nbeT4
aP0P<8g3II@A5H3G\?h]4Fqm<k5k;pjZfj1:bW80N8U>MO\3XffCIof?XW@_^G_P
ggaF2Jf1Wl^XW@_@<2kG9[dj=p=<GH2914S4Im@;M>eB5f9VC4K:@PQRn0dRDKj8
ITWmj6gYjSWX=qHkH6ncpDgYc<FaC3jcOYLX9Bfn5JCK3n`7FG]Gc1[>[0UH=A[X
l0<_:3f@o`>c7iN@?8lqKIg<>4pSl`Oh4Ye:@D_9T^R^2AGKOOHX=90PGTYVLQe[
`AFF4eRH88\`;Z\Ei<F<9N9@_US2j;2iC[9qdP:Q;7<1<c??5l@HJF6;;j7IqM<c
BiYq6k9?ZODn3@oS3K0BPXWDhH3nQfQfG[c8PIBnng_^4_Jno_DIf>dW_=9747Uq
9KZ@Z<q`Y;Xfm\@;^XnKDC;MQT]:Li6E<6fg@ZhX]GNl11IQg8E5IX7k2X9<j2mg
EfbITnWp^_S0PL]FXTQm5]2QRn?Ti6CT_5h8cS1XhPXDTXjdhnLVmYccF8FY0WRK
j==JbgAO\YBqZdRBa1pK6^e3LcYOfG`Ve^=j19KQ`C]099WlE6aCAPS\FY[7n_35
V>k2PSpl7=:_dqb7co5j__TTJT1lL]4EO8<MkYFUBhQ_jcb^4hES2WEDb@BJD<4:
GBk0oa\k:]`mfFp9L<D37pYS:@cjXL`81J54C1F8J[dolh2@310K`SWkRhRgOjO?
VW4^3oeo^pHTjXZPpA]D[j@_<LI9i6\<DU?U[_i:?3i3<eLAA8BR7HICZAi3ed78
G;b?Oq>\CEG9@n_;VQ`glMTol25Yg7`_jgRYi^Ln1ie8]ER9TNBG\]aWj9:Hd>N2
Do4NpGJd^?Apf6_D@XCKEn`n[k1o8BHMDI=40og]8oiWE\67@WgRjUXieZ3:a21Z
;4lP5a0<h5likGQ:Vf6nEMl]0YP96d:plG?8U_q^NAXSicD0lRAF;PJiQO1[]0gN
<;Gh[TFEX<:I:VB_=FITcR;7AL8?fSd@V_10VIWF5_VLggSane3\4m9p;jY<nQq[
m=YD>:HI;``ZaUCcP:EEAYWQKgP99mIRU9>W4iWBTfhcQhhB;RJJ[67dKbFTPpEV
9:oSabSbTabohQ6aI`0>qVO0ZUaqFG1<oWi4R?:DV0MJoeEXS71Ib?;g85QM3=S8
l_[62dE_eXNVR0I3bI@eT8>`ULP_GTTMZo]OR]Ymel^d\^fq[GYKn4p5LmhDE^5c
eNLjK4Rd_3[\gG4CFZWB5dmcM37bNCF]o?QiCmS=_>?=T5ZQWTH7YNgDQXIB2fjm
lPQBTT3d[V5e2;6l@aq7CfAACBAi7KSANG[_GED21`Gd5jZREBW@m@o<=lB45Cl\
7NVT^CUDW=d:IkF7MOdR\cb2iTpJ:oa`7pkfY_;_ka8dFX<Db^Sn0G<Uk_E1_NJK
;Jemh>CLEPQj>]X``IjciqWnA8^6q5V4P0M1M]D:W8TjJEgEU0>Y[CQYURXfdXfO
E>HX^SaiPBaEmmlgcO>P?`\2UhCqN?HU`SbFS`;H>V[3Pi>]khqRPO7nlp_I^^OD
mgdV^^X96TL;5F\8X>6cn7S`74RIoP_nVbMlZ[M9K[\>1N;_<b40Z3[VP=q[b9^Z
]q7Z^Nh4QNRCNko69La?E@QS<@2IGMb0Pf9VM]77YXLmoCXM7NQ56q62SMa9oebi
L2kT@dCgV=R5^\[jc`SJmOE:QCHg`piIYaKVq_1?ibEo5IEch4;EUUQEc]:WN1NI
N_YfVOil`6^iX34oDAS2<O]COh7RmYgkWo_Ca3c@p4lSYfop[ibU`J[iE3?Rj]dQ
Z^QfbM4FLlnXHN`?_gRHf?h6WbDbL3F[Fm4<43pi;ZmkephNd>W:^WP9]eG_aKd^
ja3@U`Ial`N=d^DESCWF;]J\hl^9j=i\n4`Eqm27UkRpd\hRRgC4>::5@3J<UGkl
[PgM4m]6]AQ449@>l`Jm3L`7R^_\?bl1cH8F^Boig]LBPJO1foqaSY68>B_`<QjH
hg8qLSNUcGp4@7nbJ;][9eRY_UCGLF2MOkmS=S`[jUI_l`ZTN5`[m<m\T_T`<;Gk
:nF__ZpP`X4^WqM:HD\=aTR_O;Yo7o?@Q4;6[nmiE@_n0F:hbDKQW7<GP=Cl6I;5
i_J0dZ39gc6gf[q9l6E`g6kgYm=Q8DLLib7]=5[D`f]mdB=4fWMF9jPO<HcY[E=@
GGdE]BPU:dM[obKIPp=:@aC;pjYcBm2H2n<1aHYfb0527<?^PodBZYAEWdb0m5DI
jjbc8@CPaco\JgY2^g8>moPq1]6C3XpeVBhO1MAgJgaA]43n\ghR4mOgeH<1:c0c
PC[b?eGTE<n>dJ3jgATqVTWE]BCDMG7PnUeM@Nj\F1P8d4lkIN=`X_^iMD<Dn6_7
n3;@VUP?UT62BK8N?EYf;9q2g=A5>Y>Qaf03dYE81BA6:egE]Q]M>@[n`Q8l79mL
D?\I_\bQZdHCEbjhK8]i=<Z9gSDeQZh`D_8c]M6BdWo>f^a3N>Q0HoXm0Uj[R9:_
g?KKX1I>4Y>i2qkhj^d@p21W87>7gM\Gk;mBf_\Xn<HSLWb`WPkqZV_dhKCk=iY3
P>3JK6L]:6YQ[Z6fZ6Ij@Ioo]7TnMA_?mUhMqnCPcmPp0JlR8B:\6Y\e34[2Z2=o
A[VY;E;3HfM]@2TpBMdaHmpQLTO02`J3;UBbEFMKO2c00eF59gG<Wic51W=McP8h
YV>PEU?\5L9T6p<OVR:?p2>P[>Zh7?MU546NDn2jQ@87o2bh1mVD3kKJS;?\iE91
Qm]fI@iXdfUKLq`J[hZ6pfSlTeRASRFW4SWFbLFfWO70<TET>JHCS?@Ag@k=BCOJ
;7LQdE?;E@]N;NhSN<6]QpKgJf@kp709X:P>?T53^M?5FdJ:dp]YfTk7_g>QbHA\
@O@@?JTWjb<?N\X0`NDEKYoMeHT1AGDb:L37BPZCq<I^TH^p`_8VGIdXGKJhKZ2X
2HlGG9=>o3OmT=B\KoUfUef_n0FWTdR?]mli<R[T4CCp7`R?7Xp<i9T;19]]OG3n
YP18S1g?Em1Y]M]K]olcUgO>EP>KA@7iD1NkQHhiCbGpM[1a26piBB`YcSC0EccO
nO6ADIKaYq][X:LBIW7\<bb00;Qh?2TJhk^8nHXlX@PK;aYIXSBb:G0Wi@P4`Q?U
ZDMI;kIXIZqGmaUBhq_9;VDB=<NiobH@?k\SRBO>jlaHW2=O7a?V6QQ:7XS][n<:
_NGN<]cZab74daCM?eUOVo6oGRZH9p11F3L6qcgjGj=30WVdc`i2N]HZfn7fi3PG
5O7gUKm]EhhCT2YMC2g5=Y84dkYHj;G3892IGX@H?H^cTp:c<dkeqHcB[`FkjTne
Y30CP1@gZkK4cWA5@bKS0N5MO6K@Y`6jaPQkB4D;qJJkDKQp6a>103ie@PaLcS4`
jUIVY2f3VQ4Mm]mGd67gH>GheNOF]D[<d;Ije<i3BQ[ZWSkKI8cBLB^feRNoYnq?
LB0@d75a2JE]gHMbng\Df>?q8\n<O1pP5_DEY>ej_SMT3BX3^k9Iie2B^[`0A7QP
`e0Bn^n=gZAZJKU[BgA;Yj4q<XHi5YqgSdFM\>U\@a6X?_`XRTL[Wm`AK9NPbB3;
[nj22PmH9_hoOY>ZRn\3ZUWh^oDTIpOWSkIc[P7FLGo=KYi0UR45j?Z]DVONKICn
3cce0AAiKKO7jq=iSGFep_BVcIY2Gf8mKmmb74V;ih=<^S8`oM6oRdck<BA68G4g
^b1l7@5fCeOE4`[a?PJk:V7icU9qldl2`[p?o_o]6_X9Z`NWJi2bQdON>a@iP;?g
2[i]BLIDdLhf\MEJX?a`LY`klo=CIbKS\q56J;n<q]gH49cllgkn85>9dhaV4?`T
U6_G2o3HDRejChc<Z\7;=SBFmOj17iDO<Zje:RAp4=^6:nqf>>;9hg[]PCTR2L<<
?BUWR@6^2J6SnKg3?dXL3597aBLU@YER3D[oH2m6=G=@^eC41QiM_X_qIlP]P;N3
E\3h3=6a1CQ^AC69;H?6>gP_]ofgN5@1ZW?4O6qFoid[oqV;[Qg4oS[g4G\5EP[O
FQCD?_V4F^TSgRLA5ik`QU>g7\]FbTA7RTU?_HYf6kS3fWeMYKMORLqN0Xodkq\Y
nf1<]7HP=o@CYP9o\M;T;Q^]I?l<4S=KTDp?MfmB>NF0SMfTk[MgP`E=Ac<eV8Y4
OD2AEdd4Znj:kobCC;CXKQIOZOC:l_pkO;IJ:q>`9NdFjR6LbZ[NBV<`23A`:;5T
@7[kPM=WNCSQK3QBEK^i@BJ@Hh=Hj?F\T<?N85iMAphm=aF0pVZ9<C@AobVk[0@7
<A5]`O6\:G66c>kF9Q:S[BN<ZILgTQjc\CEjS`o;c=J]^EkQNPBJpaOTYBmqIDah
9eVRUd7b:jhKRjo[T_?9OhW_TeP2gaK9mObcZj3Z:NUKX40fMiT]qR9cW:jfRnRn
P:QW_:FjVj6O>b0QkILFcn?62d\1iCXpSA78?7q;:5D5\nZ7F=bT`2]U4a:Lf@Gn
Z[AfMaR<YnQ=HRCi]dSnT91bkG=P7Y6<k0pA7ZSP5p8\]@5\\nlcU5UnR?CD?WTL
fg_oO?m5fXX;YMU0B9hWN=\nRYgamekod4EDlqDZPM_oq?>Hj?^keIlAPSU]]lJ4
5URV?I_cdBC3I@9aAgAhoYmQGi;0RDOB<W^U69dCB1Xpn0cWF2q]dNZ1LRe=lnTQ
[hh]QCc3<>=W5>MZPI3G4PNB_:Co?HOH4B]n9:`;W6M>T`KAXqnIb96fNnGFLDQ[
G3acQ`OhioFOOKk==UFE=B0k<3^UJ0G7SgbW2dbKpHP`?2IqBdT>Q];5`SUF2l<2
dP3c=hVP3@^ERaC<?TZEaQh;=AiMBL:V\SYbIim`?F2Ld\JAQAJc26KO`_@Mkgh8
fMTqXi5WQDpOZgAVVFjbJZ@6K2Y2Rf29=6>n5Dk9A1g0G<PKVoj\Q3^7JmU0<KLk
Jl6W1gj]4FT4@YkU:bBb];7nIBHFEJp@V8oZmp\80Ii1f?HO7Ek\`K_Y`iVYggOR
IG\l0Wm09Fa7n=H<7FF<=RX^CIOf324;ageKl?iBeRh58LTTB^3CEBqS;5e5OQHg
6glWPSkU6Y`S>D`Z0o_QDBU^i>k0Cll22Wj8WTGT[YLN]1JF<:gi7\DQCpH1oHH`
pGjAmfWFoaL4UWc\l2fo3;5MQZ:ICQXe@9Hf?7O:AHbaD2dS;<Fh7SL\MUb4F;D`
8HMXOH4]?A2Ek>ULTpLW=e_Up[gLoongJX26IO]W`gibo4@IEJKmj]]2k>ZB9f18
LjE2_2924DGOpBoQ@?Aq[h2UM0Rd9MjQi6oZVZcOn>H3dND4UKCZB53@d7F\Ffim
:dcJ_V?ooUX:i=DDD:^;pQ8nQ^nqe[@deSaSLfM[hYLGJkJB>0@N@e8hk_hG9\E:
iA>D:AN3q92SkLQ@oaWBkN7i6AnSFP_c7LSC@C`@KnUn;ISMLN`Q8U2_<Q8Bpfj:
_AIqf>2N1hR98n2E>fLXK_jHANl8KKhTeeIhn59O0FN]RZYThlT;IOlnm691Ne9U
1MqEZjo2Ip\Phjb@5nKY;4Plh@mEe8TdIlT:HPdH1<mWW5BfIbb5fl8I4;T>GGim
6L;;8?h0qS1fE>Dq74VOPW07:78\9fAcJ;c8BNV0=LV4S>f`Ui^mKQ^3;YaWU`he
Y8FZABZ8SeT^:NHFdID0dGO7:HmAGm0L;<YqZmXW@a<1TSik>mMQZ6H5MObXA@nj
l@eY5dDCZOnMhWWAeoX@DVCECQO:=\kFI;c]p5a=H=@qJgC18A2GO6H\ak<R1GSB
T9KN@2g612NW^7@CUG4C38lgABd2SC\:F:i[0^j:5`SNMk^@M8=MOSfMA`>H1DXp
0>@VDCqXSASC<:Ij<_ZRPP8h^]e8<gegjj6Tg0YF0hd14VGUm_m@m:1J1J;kC5og
OC:hNPGR7M=kiU[KPC0Fh>ShlSoo5X<YF>qMR;8T9pQ8Ze4faoC0J2<mQa@hceBC
W6>l5U@TD:@fi`fAIj>RlK<f5Z>>J4\\P6OT5VYO>BBB\U4jX9jeIjVO:k@42SVA
0JUDIqnJ:JUcpgYZEM;=;RkbHES4lIED4Rg7S08fLm8N@OJhL@N8IlUEhQ;8CQ0l
_33<96R9qEH0[Nip3I2iI58f1<5d8>m`\iQD\EMSgVWe6BU?Eoe[bKmXh:6@_1pc
PVE^EFBim[^?IY<J3WbnJ3[CVV?P7mo@L3;?>`ZlRhgU>i8IlBp^aL_0EqWWQn;X
Xki6S6`SR::KEIVeL3@g;0c6Hl1UL]FB37LkVAHd\IAQLq2U?FZBqUH`n8BGP>[?
OBYV]1Ab0DRmHn:MOkbUgoC8WEa8n3OSZP<cda`ARL21S\\PPYIq]1?n_6pO6RGL
Tg63d=[nK1Ac1m=M8Qc:ESY6e1:XnEg;Q;GNjKa\`k`Z[XRpKZ?daib_=Mk_ULRn
IZHAMm8c9aPKM?oMLInAhnMn]Wgd39JJ@o5X?NAS4Z4]`CqRGCU^Xq;AWYJJTA=:
=g_a0l<5^lK>g96o6XTaj\CZco;8HlR?`NLQGYONMSmld_5@8W]^;fq34b_Y<qIf
7DPf@YiCgP:_5[]6UHa=WSB;J]R<Y1DL[E@SP\LDCSi<oB8Lgoi^k>S67>QG>\q<
hdLH`paVf>c;?BkQZE^]oF8HZ4J0d5V35Dg0[Hq@K73nRfJ>8oigOZL3F5P@3P:]
MCZ=mfO>2;PY1:M=1b1HF0;llnq@LnO[Cpb8H0gk[GRGk<Lm;8lKj3KjXf0^a@Sc
K:Ug[ag<foD77JU`d9U>M:4>2dD^EGF>A^MkKpm27Uk2qSog@O]WjdN4i@fiZE>8
]@TI2A_0n;bcg1=7n@=]2;Qj3DOCU8;MH;U7V]i@^qhoR6<ZJ_cle:oHeA`7ehO5
[JU3_AG`KK41TcKhCVMGDY@TYb3];iifVlT5ETkj\L^j<qc@b_\\qR66VRo1H60:
CB>Ed0:5INN:Q2C7[lPj:>]32IY69>bYRPK]G]XMi\npQ`mmZ1pVM[YoPO@ZL9AW
dJk?DV^GTUH\X2:mH]ZcIgT^ApG7^lH0pSjfoBBC[99\h7SHk^C_f4eISadQ0OM1
GXP0EZg`Kp^[VG`0eRJ97Q4biq_a:Ad@p:libmL[HbofZL<<OHJ]34O5cR9bocHX
U3`48g;a4L5Bp4n3eYnpLR>joSVVbBN78_nZUoT\mnKN9;Pd5iW]a10XU^:Cq7fV
Vngp?_5RT=0;hV7DXG?X_;0mDYSLAQ8n7FL]A0QqNWW@b?p1S\>M@F^\<E`U\379
g>RT?5n5@2LISq_R853J1iXM<;]JSg^e>DBIAS1B^hEgbneKSpE3oOSlp:C6CH^B
nC5_7d`jgf[ESFSeQUHZ^m9mL6=0cK6\<M6?6gRbUI@np3XNLBaoAZ@jVQYcO8Gm
U6`0UK2@Gf38Ph75UN4i`bG>6A2FqdJQ8n?p[h2Ujg56MKEIh=A77@Z`eOVmP0aO
CY6m?ImZ7Z[C7AiTW0@h[Z1YAWqf:5eYJqlnF=iA<==7`K^I1l6a2DdnIg7>H4:U
^MV0`C>J9Vjg1pkESYH:qRT>>R7ghAb04BO;K>^KhDcOI;N`7R8b\_Q3AM<p:id2
d4pV`Wa5;^kRFiF[5AK\kYLA2Lq_Pf3\`K@1GbDSgX6@:0QN^6TZ9U\=>1JiejIP
IQ<p3aCL:9q^4F`5E6IIF:^Rh8k>0EkARTAgOLOP_GRMSY1ZFJTqPM6:c1qCFPMS
<6QZ0gi43WXOlX]DZ@DZAbRc_;a]YQ\q@gId5UlXG?3`b8c5Pa`Z=noE[6I<gefd
]g18_S>6@0\dL8dPgTB4FFeD93KW8l<I;SnS;^CpR3c:gF@KXi=?RJ0]F>iBnDQV
=bM5L@SiT<7XU?P^G<02T>n4Id^En]R5@XK^A54?F1D8Ym^^]io52@K=N7Ia4^^9
c<>leS4TY:adpN^2j\2qo]^=jk^75[>dk_3QWb22:913_gH>_kpNEoRm4pm6S>mg
AlB1ABNG@B:L_?J4oe=:PALjgk[BTp`7mgnJpX1EePX9D44ZL0NXaNO2SJH_RT7K
7cG`Dokml?jDOH1dF[OAHeWZ<Z^Chf<hbDdqDlXlka1:deXnP0lYHKW4El;4fIVb
HKbK[>RjNiNQ73gPBoUqQG88Z^p\@eMnQT`]5f6RCogYV]cQ[nDhE<haK:?;_mmE
Xk<^HFMWd?b57[^8kik5M?<C^pQNW<77p:nF5m<eB2BVLSc[RECPXh1Hl18@HWlA
:VSX9A[@V=fDh;RAHn_kCPFHUqBG=O`Cq>6RFAlL9I7gn]G3a4CCD66m=EAG:G>L
2cOE4@aX[ohUMAklPJc_6F8qbkH_WQ[P>PT]O>3Q\A^MMim1dMKgCJ9mVm_SJ8K[
gRnD\e[RNVGNdRna\XO?S1:;RWOgD9Fq62Z]AmqJTfiai\jcKad]Ea7=hAcG6O_O
ejbIKPOYjP^J55>=n363ijj<gZ=1Q\:_hV=n:N57AOc6Wq]101>`p^;VS;h8KEO^
f[l@=XAHP1bAmJnk<S4o7[HlmDBHP4F]hXAfL`:A>A=4:TYTpXjcIK68d2:`9d;H
8RB1b5jOWgIIb4AYGdcD`jT9_NZA?L_@AS^hYq@^A=k9q_IdM_9QPAEoGIa_D]:O
0Q<n`h>D3KB]:MV`i0R9S`Te9VJ=F1?0iGFb\Y^X2deXbpdHi?Dop43HC>HLli8B
M9LEfLiaUN03iBD@hV\B1@Xi[;20SaG7<O_DEN[jSP[N=gOmAmc4f[i12aZL5q@?
P4_WpRZSBFTnc[^YR7TGXD``<i9b2=7giS4dSQJF?SFeE10RAcWD=hXBK3BkFU?^
6[A14RUhpkAn^PPjc>mhaVV=cA3N0cIV7[nW<b]@7:cd:>:hYmBWE8dW7E@7XqjQ
AhF^q[kD8h4@W[[B=hBDO^NOF0:NRKEI`G_1[=R5G\eV\Xlb]b2R4WWNmo?EfpAo
15Y=qo8A57baW:ZVSIEkDW>YYi?k9JTY^\<d@<3]ZJNNhEbSJkPOfYX0[N9BXMkB
>;@19pT@?haVqH]V4I40Z91=b[L\1J1aPfLOi1MaDb6@Yh\GZS72HQbMbXdhDI6U
EVK_:FSn6e>2GqcO<m=Jl6^l[E=^U6HEi1<]:>JfZM]X9GF0mj^gXBmloSd^O`ST
eFeCQ`PO9i0QpjdG[hkqc9E@@c8S<72HQJ@Rl2HOed_N7OgB8fEod;mGKjgC[>n<
]lB6TV;d_l88p287=H1qSB5oI]TcAjXF;h:W2TK5loD?A3KhdD3mgc:f=GoWAW\>
E;^Oc2Tohe:4YQ?;AiqTZ8l6XpP8TnlJH1WDRln7F?hD`D4fRK58ahjlZd2RM8b]
e6SD`ORk`@4RCq?^J50VqI_:\VIC`S<9ZaB6pX>7:A3`jT?^>BP=eb6=S\EL]dIF
VOc6pZAnZ?IR89d^=ikOXlJ8cE0XHARKciU<TiJ4im<jc=n1Nq1Gk;PNQgANTgii
nRXkXPBMGQ4T:::TDCMA5FGU;UPCb7BnIbZT2iE>XTFNqnbIn5i\OBB?FN:`D]dY
hT\TIlj7=o74E;2d<2fE\Jf3oe;kWc<fAPQqD33H[hEg6G`H@4nqiP^0JRP`U?4j
:bGVKlP?T8<:3oUI\?L02le1lZai4OG=5IXj]jKpagAkd=T:VS7IC==5lAEY73AQ
X=hn<@mbbYmXK_l<<?fhJdX0WWhP]HOoYTpOo<iP7ljP4K9=>VMSh<DZO=?c8c@Z
d9XjT@F651JQJ3i2F8UO4H`=_jJjbedBY7JOHEF[UpShVZ:C7H425844Waf1mM:6
FIcVgPo3=kgY\]4J4DPF=\JV0QXiRc_n0EgC_WN:T4`afFp>NLAOS2amWk9MAR0@
N2igg8O;bNG1l0]bB^AVi@90dgSb@BP`g0]T`LK]KV=[@9flWLq]:c_hJOWhQdEH
I9[:DE\ObNbK>_UZdBg<elTn7D^d?:Ek]@>h8JP\U5OISpSXS?8B7aM7h4Pi1Hn_
D[gfb`L2@k>:jNM]PgRT=MdU@aFQlOBbTRkeDC2;f<X]4YSADSHBqBVRmB0@XMYQ
Eo08f6iVT_81=\dMob]lhU3[Wg5D56AL=CUZHWilZ3DZaImZb@\HpghMIN`=[X`o
QdfRjd=SAPF5LKcZ8JdW>di\N4WF=ABS=M\NqcH<RQDYN0R8EmMXXVGm?0dU^9aS
fdiCWi4Z>92MZ:[NpUQBi]l5DcY4W8gFS5]?L`<;<\[i@0\CP5RPIL7FG9:XE2Of
TpL7aWKF[X3Ja<i[f7^=S8odkmj3Q`njDd^Z_G4:7joRdPSVWIPaPGR17L[22VXN
daU?DYX?efq:7TR]bHN_iM_O\XLHbS9b7fd@R54fj?85ITm2k:YMJKmY\ElU<q\D
kfIn:LSdEG?K[Am`7YbZnMCZ0\5eJc?O]?1CTfU2SF\gIO_8Y$
`endprotected
endmodule // module vusb_hs_pe_dev

