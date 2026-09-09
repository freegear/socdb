/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_dma_mem_arb_bvci.vhdl
-- Date Created: Thu Dec 21 22:43:03 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_dma_mem_arb_bvci.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Vusb_hs dma data traffic movement & channel arbitration engine.
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
//  $Date: 2006-03-15 14:25:45 +0000 (Wed, 15 Mar 2006) $                                                                       
//  $Revision: 42 $                                                                   
module vusb_hs_dma_mem_arb_bvci (clk,
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
   dma_up_endian,
   dma_up_host_mode,
   dma_tx_tag_wr,
   dma_tx_data_wr,
   dma_tx_wr,
   dma_tx_ep,
   dma_tt_tx_tag,
   dma_tt_tx_data,
   dma_tt_tx_wr,
   dma_rx_tag,
   dma_rx_data,
   dma_rx_empty,
   dma_rx_empty_ctrl,
   dma_rx_rd,
   dma_tt_rx_tag,
   dma_tt_rx_data,
   dma_tt_rx_empty,
   dma_tt_rx_rd,
   mem_done,
   mem_done_go_again,
   mem_done_overflow,
   mem_pipe_sel,
   mem_ack_sub,
   mem_underflow,
   mem_burst_act,
   traf_bus_req,
   traf_bus_req_again,
   traf_bus_req_typeinfo,
   traf_bus_gnt,
   traf_bus_addr,
   traf_bus_addr_np,
   traf_bus_burst,
   traf_bus_ep,
   traf_tx_req,
   traf_tx_wr,
   traf_tx_gnt,
   traf_tx_data,
   traf_tx_ep,
   traf_rx_req,
   traf_rx_rd,
   traf_rx_gnt,
   traf_tt_bus_req,
   traf_tt_bus_req_again,
   traf_tt_bus_req_typeinfo,
   traf_tt_bus_gnt,
   traf_tt_bus_addr,
   traf_tt_bus_addr_np,
   traf_tt_bus_burst,
   traf_tt_tx_req,
   traf_tt_tx_wr,
   traf_tt_tx_gnt,
   traf_tt_tx_data,
   traf_tt_rx_req,
   traf_tt_rx_rd,
   traf_tt_rx_gnt,
   hst_rx_req,
   hst_rx_rd,
   hst_rx_gnt,
   hst_tx_req,
   hst_tx_wr,
   hst_tx_gnt,
   hst_tx_tag,
   hst_tx_data,
   hst_tt_rx_req,
   hst_tt_rx_rd,
   hst_tt_rx_gnt,
   hst_tt_tx_tag,
   hst_tt_tx_data,
   hst_tt_tx_req,
   hst_tt_tx_wr,
   hst_tt_tx_gnt,
   dev_rx_req,
   dev_rx_rd,
   dev_rx_gnt,
   op_context_bus_req,
   op_context_bus_req_typeinfo,
   op_context_bus_gnt,
   op_context_bus_addr,
   op_context_bus_burst,
   op_context_bus_data,
   mem_arb_sys_err);
parameter usage = 1'b 0;

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
input   dma_up_endian; 
input   dma_up_host_mode; 
output   [3:0] dma_tx_tag_wr; 
output   [31:0] dma_tx_data_wr; 
output   dma_tx_wr; 
output   [3:0] dma_tx_ep; 
output   [3:0] dma_tt_tx_tag; 
output   [31:0] dma_tt_tx_data; 
output   dma_tt_tx_wr; 
input   [3:0] dma_rx_tag; 
input   [31:0] dma_rx_data; 
input   dma_rx_empty; 
input   dma_rx_empty_ctrl; 
output   dma_rx_rd; 
input   [3:0] dma_tt_rx_tag; 
input   [31:0] dma_tt_rx_data; 
input   dma_tt_rx_empty; 
output   dma_tt_rx_rd; 
output   mem_done; 
output   mem_done_go_again; 
output   mem_done_overflow; 
output   mem_pipe_sel; 
output   mem_ack_sub; 
output   mem_underflow; 
output   [MEM_BURST_LEN_CNT_WIDTH_BYTE - 1:0] mem_burst_act; 
input   [2:0] traf_bus_req; 
input   traf_bus_req_again; 
input   [BUS_TYPE_INFO_WIDTH - 1:0] traf_bus_req_typeinfo; 
output   traf_bus_gnt; 
input   [31:0] traf_bus_addr; 
input   [31:12] traf_bus_addr_np; 
input   [MEM_BURST_LEN_CNT_WIDTH_BYTE - 1:0] traf_bus_burst; 
input   [3:0] traf_bus_ep; 
input   traf_tx_req; 
input   traf_tx_wr; 
output   traf_tx_gnt; 
input   [35:0] traf_tx_data; 
input   [3:0] traf_tx_ep; 
input   traf_rx_req; 
input   traf_rx_rd; 
output   traf_rx_gnt; 
input   [2:0] traf_tt_bus_req; 
input   traf_tt_bus_req_again; 
input   [BUS_TYPE_INFO_WIDTH - 1:0] traf_tt_bus_req_typeinfo; 
output   traf_tt_bus_gnt; 
input   [31:0] traf_tt_bus_addr; 
input   [31:12] traf_tt_bus_addr_np; 
input   [MEM_BURST_LEN_CNT_WIDTH_BYTE - 1:0] traf_tt_bus_burst; 
input   traf_tt_tx_req; 
input   traf_tt_tx_wr; 
output   traf_tt_tx_gnt; 
input   [35:0] traf_tt_tx_data; 
input   traf_tt_rx_req; 
input   traf_tt_rx_rd; 
output   traf_tt_rx_gnt; 
input   hst_rx_req; 
input   hst_rx_rd; 
output   hst_rx_gnt; 
input   hst_tx_req; 
input   hst_tx_wr; 
output   hst_tx_gnt; 
input   [3:0] hst_tx_tag; 
input   [31:0] hst_tx_data; 
input   hst_tt_rx_req; 
input   hst_tt_rx_rd; 
output   hst_tt_rx_gnt; 
input   [3:0] hst_tt_tx_tag; 
input   [31:0] hst_tt_tx_data; 
input   hst_tt_tx_req; 
input   hst_tt_tx_wr; 
output   hst_tt_tx_gnt; 
input   dev_rx_req; 
input   dev_rx_rd; 
output   dev_rx_gnt; 
input   [2:0] op_context_bus_req; 
input   [BUS_TYPE_INFO_WIDTH - 1:0] op_context_bus_req_typeinfo; 
output   op_context_bus_gnt; 
input   [31:2] op_context_bus_addr; 
input   [6:2] op_context_bus_burst; 
input   [31:0] op_context_bus_data; 
output   mem_arb_sys_err; 
`protected
44893SQd5DT^<EaRlLZ7G\L;E=jfET=?XHmT7JAS[2=Y50k62jQJSI4VX<co0]]q
JgjQ\hl9cmRlgm\08=`NoJWiK^6gcWBZX9T5M97nL9:G035X^Y<6]EA[f[CTn;G5
VAjTE`qiSGmCjXcmOVG<]VB[>2IAL]59Z>;mFIhlZ=X5bgG8Y@N[RY?l^bR?FnqT
HULL^p5`URiJCRQo6?2Woi7n?`qeROhhgj]^mWImCESKAA3m1`ZndCPlJf[^^`:q
H?CN>UkQEW]A1IDUB^Pfd?TMcgGPpk8fLf3G7XE0k^Lb6`>PilS7kXESARlqnCMZ
CJISLAedmH_WYlDYV]m9CAB59F`M@DpISVMP3l6nXW>CG`acFa?_]M\md3e7U9G8
Am5[P]P1PZSkFB]?fAX<2p4E[<oXZ>QGBJ8WR;qUb_788bSXhj=MJRi2]PIpgTNO
<YP>F^M1\=BCK?KRge<GSTODdhE3:oSG;<_11fm:^0og9Imlm3Oek@NZQT8aC24q
OnGal4INb36d<kZec@5SZaH;bJj?6k65;0gdCJ=:K=LnhhK5\DXPi2TWV4QL1JMH
d>6pET]7UX:V^]KQQ>AoW@>j6ok?CZ6GRMX222AWm9qEiUhUlo]OBfi=FiG4jFFo
;8mmEDkE]=;;^=2SYfapdfO\N5RbJ8VlK:J4_`SKkk38AUagM;B@??nQSo:4Fe6q
nh2?JE`M]Z:bFfWRH`3RZopVfL8@F:o;8CGo<IDnlnSInmba?OZmh@lfl3B2_OQW
S5IMG4^gYT4D?g4>5@SAI:=30qG@dKQWhhYNeQV_7JhhR?Ij1;o]jCS6CMG:Yqd@
B5IMNR<J\[id`U]C_Gg7WeEgSjhJif`Wdh[agNqW_XYgU0f_^dCkdTj4P6jKSEX9
:?K]G^Yh`To0Ij>c:>qOSEcZa0=SYMSja3fCKmYgfkXG^pe\H>e\:dbEYed`N:BB
VN>0q3DGQI@f;R``ALBOn>WdmfGNeNePWCdi<CEC=ZC4bqJke2NXgI6F>VGfDk=f
\4=1@6b6qYb8h6]PWA]kNdR:EYh6WpA?@E@Df>EgLf\^]=SW_k6Rl1281Pdk[oph
@ZQ=V^4R3bRi^JZ6`ehi75YoOI4`[:<q^09S6eZdJePlWno5fD<PX:foDTp:98Oo
mHlDICGhN=GaV>p>C6M:`c6mLTGBjNCSD8jk>?`p1O=W9?97Q?3`UA3JFKD:WYhk
6P[pmiVR8_]meaDg^]W27dcZ@m:NEEk<=aNLS[@13f\Gg[@7?3h:Yl>mnN:=5BK^
UCMRnmBYQR7OJ@_RDfQ1giSpM0eFDdP3Q[Q^Ihk<4Um0nLV=I=UkqS2[P>j``O5i
PoCXRN2c4[=V8R^pOmE8Egf[jbC_D:8\5Xd0EnX[p3JLP9g^IdNF4_`XLc0O;k4j
CpW<^;nIFiRQT?n;n[]IS4SGWKNiKkCbqXhc?=KKcKf=WX<1MTKhD\>nTPe0`qV[
H]kBJIlQPV^8JcQ;ZFejOEAm:Wq@]@ngTFcEoccfKC>PKfno@Bq??P9<P=\CTYHN
BMPC?blXPTp]?S:6mgfZ@n\>Ame?B<OF?140bgq8A]I?`QOf910;Bj>ndDK6Qie^
8YEQQ::Z>1J487`qI3W^Fi?ieF6?<0f?Ph:Uo=a;blZq>V8YK0aXaX[3aNbMjKEm
V5Tqo@=734fAl9`>]Y>[6UH[o6Yb;cmU6MJZV4pQ5i3l4B<[Oak`QNJ@@D\bK^EG
0KiZDnY]^c2kn8>\n0jgFM5XSg3\Eo_g6Xmb1Th:HqZ\8LLW2O1IZ<bNDSn\;UeF
2Rb8Za5DqU;9dVn]ZIRdP7SOC;[?JF`KYVO_LYjkQh6pfo;9JSm9o2ggkN<13BI8
0164DaUBTcqSS<iR2[Gl;=AaBLF0=nFHWac_aNT>Z5f@VC<LCqjk2fXNcbdhc0RN
n7bWO9ZlM=kka;?QgqV5[HNKmPMBl1bIY05B87qA_7elj;[5cR>W2T4;Z><2U@CI
hT8SVENX8b8Y0aq;^?n@aO17@nmQmW01Ek9^K\IRhfQ@4o:\kpQT8ZjGh_8lY5:I
3jD9lhZJ`Lm`QNIDRDdXXkV?=HZFBpBSM7@B:X^U93o@DnlfNSh^^9Y0\o`1D?QU
Oj;i8BKYmqL=3J=ol;o]M\1\qXOT?@\@>Wd_iH7H<4GY=bX5R\`j8hROS^:WDDU?
ckGLK6Xp>d;W5eb;iU3TJ6DeJM<SLMnEdSFOCDE4Jfa]9`EBLN?`nYp?c?\WMVkJ
4>O@MCHFFmiIH[fBLb?AXeMEc1Ic^pmAZAd9mbf2oA^nOkGbHO979cX1i6\5coa4
DjGe:Ip@]Snl\<@VG[KPcE5I;5N:ESHPg?CS1M2FD[=F:DplfCU3^oaVH:RcV^LN
hE4iUQ5<K6iT?>0f_;J`SLpDDOiVo8<oQM0na6UF6kn0eQ0B3FZ6hPJZBdB_V;`L
=`C187@_L<Y:_PClH53\SEm\1NdK;>KYUgW\g@k^2P>nnp_c@ojm?CMX4`?1K\@g
_>LEZhmZa2felIWf>F6Z]S7<39HPTCa1FO4BW3`k>3U6lX;JVS1kiUSFG=lDjP[K
ji09ZYp2l:>]V3G8SD=gE3[UJd@G>c`IIf8CZaHl^OTIe0U7@@L?MTDqI<d:DEWk
bRFF7Gg;EWmAqP0n<Y1M`j6:55CRL4R3QSMRQ<hB4`3j0JT8@fdJ_X?24kZmR]o[
pl3YTDDQY=Z0MDUDEMRn5KTGJ]iYi<D=nfID<ZigBZ]_F\;H>G]V7G`GG<=4Fc\M
AgB5^Qd\H0>T^D^iZXcmYTmqI>E_j06L:TXHf6R@N8[o81gdjUS;;8S3V3nU=KR5
Z^`<S5:8^`NPYC1fglg_Lm]eMa5K7]J6XU0GQe:T@k;=dGPYqbRSZTR@ACJJJYYo
XF^5f>;1]CiOoOe7g]H_3_;TQkSi4NK=0qg?6N:QLV?`mFk[YCL3IAhlV_Gc0Ujb
;C?o0KQ9EnL;ncqI>E_j06LiFXAfRRgN3:Ra\X1;k:X^\QE7an2PK`i`HFB`P\]1
L6pR5:obcCWOKR5`]W>M`EWD<4CEDL2QdU68CZK:2;N]FC9qJ[f7b5<l96J\PfO@
4lRmPEL7kHNnE\Nkc`i[a8dL3\BXAWEnTnLe4ZI87AhfaQ7ib:Ug7i]VIQ0@2BlB
^7Yh`L4ZpRlViCoARWajjeL;;:aC>1k<^j7@[7YClCPUKo;?ePVQY22b3;;Y9k]j
R>@1PFG^S@2@dbd_b4[A^2GeAno=E[HqQIXLJ5oW^>h0_K5Ai1f:8n8M]TgCPMRV
\GH`QG1HWA51AJ=fWiA]U>[X5gLLk`iqlZG7NXA_6okVTL_O56=K?30@?onmoB]N
hK>VFKjUQdaaRbS[U3;pmS=MER[6JZlOJ4`07i2k7IJUe15:`6iI\ciq@gliEd9T
LWIFJnFonedVGhR20Cp>@3_nR\NWIOkZc21AeYKk=Q:oR`TqC_;eGm`cmbX4E6Oi
EflROFLp>W3Y1m>`?;lYB6^2anjN:GMidnqISBo:PJ5:J[f@N7`Gg3JR3K_NQKX_
DGFAc]jT6jc=XD\[^585ed=BT0pcj[62Z]:e;VKifZUe\j?G3`6maUD@]WLKE8qL
<0F8QHi6@3XALR;1K[>D_I0Vc:SKihm6C]n[>qKLnWS<3Ia4OXRnTQFmbPP^qGAX
:;h[FRZ:o<FQlGY0oUocXpL`4DXh4g10?W=Q\8[6_]lW[3EaWn`lpDKGo;8IljSU
C0o8mYn;[Sf3jfY?nA<2JqoIdnBViU@;jf>>PNY=<>pLY_jAm;o2ZFWORlNVboJZ
0nP\kk46RpA[k@3bC>ETS0@9\Y7fW3NYH_N3Wh116`pUafR9X=SV[9lYO^=5G2fd
O5GQQqjcf<FCiZ\9Dhd6i4Ud<eq@26m>M7Nh6ikP04F>FXekcXqh7hlDndE]jHQj
gShP3ho8AEaeXTKWINYMbeqPXe:bnK\f0Of_fbVWWZc]cXdAOp_ZfL`3NJWZZ_L0
n8RD8^DZ2H=KmZqNSK4RZRXiMo7YGEMdHm6UCjM42LRglqf>:WJ8TIbTbjIdJFQE
8V7OPEk^<;]0]HpkiSllUEaM2ide]N2WSoTQV3f?0X:n`Xl:H?EEMq0T6GiUZ<[^
_L5B=ei]nI1an7hgh[8ILeD\E<YdZ0qNIP8O4efLHV@cCigFPkI_^L=N`H^HiFa^
R6G>fmP7D_=g84V?f7KS`XS<h3<INL0lKT8B^0P_Q^1Q[5@j;@LMDqa8\Z1kM3R=
oTlAhdk>d2kXaCYo9QS__=WVp:ahH7C0]ik33SOMW?kka[Eo0Mk6j7\3S9[oLif9
=>\6ji[@gd4G7N;>pGanoN8[dBNQD4Cc`BnZg=QVXmY>X^:?L]N0TqC_@6=CV615
>U8kdl[\;KFjXa84KbF@VM:HL^5R;W?iUgFAcpT;4R`MAf0Uma8@G=68RHWJR4\L
<9P^2KXbliJ`g[baelMhAOO`qP:34n=AJRB<BTilOf<=mh388dje]R7VWi2D_X83
maG>apn4]Q<djZ?h_^TV3NPO3n4]23`K@AHAiZlW\7:5;5T;Rl@:jqle[=Jc_d<S
;J<TZ`4\\8[STmA1VE91i3VR4`g=Q>`>FbUDlO40qAo@m>i^UjQ1\]mU1]iN6QhJ
M0b3h5kZYbYa0j8kB@?YKqC9BAR8ij:miEGPWV^c``WOH2FoUaY0cXNEKP91N3CQ
2^ee[;=XXHKbS75Z_CHAd]07^XPeR\qZfK7g1[Ee6:><iE[\cM_aPPh5>Jjf?m\6
LMCLiamqFl3adVfRkNc=?;n8@A;gYo5FkD3dFW7iHFUfOo_cq02<TInJ@59londX
k65=OXNN[FahZqEcTLFgdG[hZSPIULPJ[b:[ZY?dgVA:Ij2`_^7>2UJL0pE5^1Z]
1TigE=ohYaF4lcb_OqQN_;ZPYY_>cjkIc=n8o_]cpPd9V:=9GSPck<6cNhl2VT]A
p^=_k5Ylh0eiR;HUBdg?4Z]9PY6L<>>^Aq<nVnP?g>=HCSQ9;all[ol4UMD2qO^g
o^Z\;9RW[L@kIN<AbCnpba=dcDWbJ>kXC:>f=@FR:[66qKmea4EMgBPhMQdICCIl
g6M@>K57F77NG[6T>q6lF[;bBXkI8O`<\=Kn<n^>L9CHfZ<j[Rec`b91WqXSSbn9
\;:P0EGBnnD]>LC;_oHR^qjF;5XH1eD6`0WM[J;mgH?LF^RdmqNlYEA?cZheFcX]
gX4l;685nm4M=aW<pS:;d32C=9FYNS8QCG=A4UHabdYqe5N==h;\V7Zd:fA]F\G;
57e;pdQdf@?7=_J>Ljca@33G7nmB@61Id[D\JLo:aqRN\5Kd[[F??[jJJl:DM:Te
Vq6:L^VJ?W4EL]5chWB1SoZ<b_hZ3p716i:ocYYAcBTWk0=<J9lTe?@eD0:[[Nqe
ldV:=MHk5c8_\AdhVOI3^L3REUUQEXAKA5Z3Yb[P[hG7Y4LOXHlGKm6>fIXq9bBm
R>nc80N=L?:@fH`?^ICC`RlWk>HGmBIUIDeNlnjQ:YB7@LUOMQjN`Ka2kZ_=^Iim
Ampo21cRUKNfC;eaQ;U^Z_;1o>ldR?`S;bSTKhh3U9]UEHH87Boo\gSCXAn[KSMq
OnaBnZj4@@m1Y?;V8ZIie>=`<]MI2aDQ\4@Vm6q?QPFN<U^9gXRZbn71m;l=`2_J
X81]4cKKTAT66WoCZjan__<Xan3KabWbk4geB>J26@]FnIeIIBk4>dJeIE2Ime5g
F2hIF5p==9GSmR8M5;>j_Gj:ne=4Oe5[l;>iJE]O^O][lngNm3c[<RI[2:Fni:dB
C3UI>?YET>22MnhTid`8`4B6<fA=[qc[d>M3nd6W]k\X6WZHRGJ9^5dm6`b>aT1V
8Z1S_02A]YWKdH1lS`3]JWfLGW0XPp@3gIa03:[B<\KLL4E_:\jG>W7lf3M1SZ3P
De]BQ:F\PX5ApHLXh_]GK6RVmZ59B4df24@KeSZ]dO8GXZ5an<3]MdMgd?eCF2T`
bCBB;]K\XnE`NJhGpHLG=`fAJST]T4TD:nOdAG3GO^XIL=WXKCEEJC1?\YakDZKl
ZPdHp8H^bMe`WUK@c42;ROAlCl`9Z]3\3OTJcTP0_PGl;H\OjA_MHfmR7^5f]C8J
R2FMJ5o\ok9o>F7_@l[H[L8IFk9Wc`nDcghOHaDpmTW5M8?gNU60bXI<aUZADO`B
ZQfCnf^TQ21^joZYkHn=iII0JX4TN6;CFWqU;^JA@NNM7BTM<8HQn]8P<5\7kJUi
4e\1:HGMEPWiG<fCn=nW6ooZnPm]A^KN1kVJ]H5Oj4VS`RQUI\BI7VBFZb5pb\_2
;I8U[mBS\HdPmjHhCIlRg`Y>0:I`7]ank6T52D5\HFRFEB_6;^WPomjpRMh]`\ZI
TCf6WHk\jg4bV4oa2F_GU3LlV0D[kM^FT^q^45;>=SMIglnDl12NCKPO1>GdGXAB
=\=WOi4aRmfhoJ;ZDdK6X3K?4TDK8pVALY3VDQf8Gio1WPDPDNR==@oSg8S1ABRJ
WJ<Y2`AnLb0biKBS\Feh>`21:Cp@Xdd?W2cIdYU]O:4TnJl?^l;Xhh;U<m0Ibg>N
?7ndeC1cR4lE7HY`=6I@0;;p4A=^bo8B<aen`Saa460[\aEg=P[ek^XJPVS\gb8K
5\pP;9bBOPJUSX:\Z;8OE5gPKj`Yk2LKTkM@cXVMF]cLlGlq@8N\0U2=1lL6Innj
FHKNCWd:VTYW0bXKCl\1Z;R3i_\4kMDaR5Uop`V?B1>M9en;L\XT_Mb>I5b4HAKn
lZ4MkLL:=hJV>>7BAo9VC1;DqmRaI\2eb?FLM7M;X\9E>X1CElXL:DmBFmMY\E1M
KPW^W?_XA=C92NV;p`JUPUZkd:oaAlDoEEL;B7VC9bQ2IQY]fE\<IqkY2JF2`2I7
@alo3Db_lMgCZof`PbDO4NLdZpRH51]\PG7aK:IA?;c34VS;X6h`Dq1Jg8Nhf@jK
94ZSd5U^b=X@c@I7Xm`jeo=4:=q6lF[;[BX\I8h:<e=0S<J^>L9CHfZ<L[eec`bE
1VqC_iCmHoQ>^W9l7dll5e6_?;KOgXV4@B6bXmKp8^BQbYD02X]KEIbXW@OoKJk8
4:n5nL?N]k9M>8Yq1:YSh9;nM5DA5Eg[LUjk>?l3;F`plV\>7NBAWKIRdIW@E_GE
aDcDW?ipP^CfcMI7YI?PE5<MI7ILfk0K^RdTa_qK4kXmHG5S@_g>3GUkIYG5EgCY
EX7jSHFOHd0KI0gp=4::f0W:`FRNE9RoK]kX0Pb`6UTEJ9Se:9[Nj<=p[P4G57kW
;72Nba:R:@1jGGFJTJk<L\[qc<O`TbOb:OcS82IKFEMEFlW1jmeRMPkMMfGU1<6_
qfeRB;Y_DeBJXGnNC@J;<F?9UFPgdOlFb@[dfoToQPXKqdD7KeoB0W=]j`:0aQ[j
=E5XI:dMXK=5Pg3J_;;\jph2U0S6P4Dik4U8ULBM[OXYVj`JI^]4XhF]23W5[\K4
PqKAR[j\Z:b:C6IJ`Rpml9nQ0KW1mQP`J?OgN80Bk2;TLjcS90q0K8H>QWO5[]EH
[WgGej0f0F@?P:@k?9D=2qD:i`O^VK]^@VC06hmKG5YUiF8lWD2jXVN^BYq;hRj<
TaE@LEH4KdUn>[l:bUJXfeU\4FF=:XqWaS8icTl;a37gCif=kQQ28Hag]gqj=LWD
3=dGOHP>31Q>S1l8B`m9B769X1`U3IVpO=Y;XXS>7YI>R1PfWQTZR<\d<?IL9CWB
NZiT6nVM3ngLpbmIdX\Q8?AgU\M4H[X2Ti[m3A7^<51OEmDaOA7:p6mhhLF6aU9Z
:ZVM2Q?[SoM4>e]5N3TTUncPBp?oJXPBI<XQjGcC5H1J?X_>8A=MC_0oWn^cb_4d
lqJKUVJ;RF`4U4BL\iD1S54CP]E`WYch]E?WX:E4_i8k@H`0X;oCk5qnbG;^iWJM
dkl>=KB=bG@RR@=]>?0@N[RZUb:9H8Y5Rn4>dZ6dZ[D4Fgp>[C62EA=^QDioIR\=
haof9WiVdi3QJ:4IIX7a=3X0He[YD99WB;qUA8XenB2ElG8>igA[A6C>j6hW[U\N
b0FD4?p6j_EHaH@]3I5ZbN3oaPeTmh<D:LX5a3VABf0hMhQq6`M9MB=bP;9=hWHa
^K6[fWCNcd:qYcoBh87U]KAdRAYiaAd>FUHY7ZNEC[qPC6QE2ZEfRCZ[k2RXN^[5
]0W:c5f2TU?`oF<[R7mqFld93RURd;fVf_]A1NAK47m1;jkCmY_`L7DFXZnp67Pb
mbRE]QgXl[]eC3[UOYJZ44;ZJ;5qGhDS88nmeY3@Tk3PdZC`na0e_gU6@V=8anGQ
HG^dqg]l`@XJf>i]W;amIlLl@BOI5T1D2VKZi<VM7UX0oYN2qe?d_?@<@T^<feMR
fD^K7Z9DC9CMhd@]J;HVHV4jObW?X8HER3cm^mLU0AA=D`<JJpgIMOV9J`IfJkLd
S`in\6?g4@DCg_7mIZ=Y\35E<Iq]QBHgfHmgW5PP_imU_SN7o3VcaC:mfFB;XFWo
o7C?X4pgAFdCc8akP3dPY0``on>fSh49efinDkcelLM=DobQdJX=jX2SKHo1FE?q
e;INOJk3Zjj?NFH<D]lHch676`o`aNK>YRXJoBR@B^jXHH@R9EE@e4VDAFPp9beG
_MZ2[fdJZEn^gf02kd]C\I`kRJVpNBjh=gl6>D8\[XPS=C1<K4WHOR?MI]h>HJpW
Ege2>hhf4]3YIL8WfWLRg7^`\5XbI8ciKS2MNE08VfT51eh3c5=p9dNRTfW9W`^T
L\@=4oBhbk`Nb7Nk7ebq?ZPdAG>^YL==HC;a?\?T:aD69oBHg2g7LmFdommXj1pb
blBVS@Qi30^YO81SZj80FA\glYg[BbD2I`Wj[n7n\Tbp9AZnR8fn=l<<<hg43<FN
MRN\hdXR]G]e9QQ9CYT8U7i\O?Hh`aTpUaJ>nhG@j;nVH3Bda]@i^TM`LA:YS6MB
lVXNn[0S@U4XDVpBHiV^AN;Q<CmG6aiY@`nYKe^:h]AcZV`WHF`Pjf?_41gj1q7F
lGKPa5S>EgD1b3=YO9EZ6QNmB>WLFXOlNBkmbD^mAJP@BeUCR;\a9ZMXBGGRqlCf
<4T<G5Co:?[aDnmkaW>N_6Vkn=Lo^J0=pSeJ=YhgBkdb`nG3BcaX4U>Rm7ESeifU
_bQRc8j7CX9SYMVe4g;cdFkm2SIE;^6pHZF?3>kNk;e8M2E<ZRUdCBNH;dGeg6:]
UJbb8P5IX:`5gTRg=85C6<>_odT_oUf_5Y\pck8\;9N=N@fnRQ;AWJk;50Q5ATET
JjKo@[ZLcOVh>COdon8lZUBDg9M\[_ofe:Co<A4pSLSOZ4V[9cFaZW:PeBKloV`j
d_B_ORdiGm9d0?=2QU9`>d1EV>Cl5D_^e5mNLW7g3L0cn=X7hIV<GY@nlM[?=oSX
9QR;B?lV@o4^2AY_qN6S^4V^df\o5:m]PJ5_LZ;nL78Wld<?Q14S<S\;=Tc]XViF
5UUI2HPp`H@>?\QWbmFYj1UmC\3ee]li:kS<6S8nb5V\=6Z?XSC^InoW^D_lQYJJ
EmOajDf;]QMkhQb>jL9k^Ng2LH@fV@bDNhX1H_ch`KgMR1G2qXmm_BRWR19Ba=ZM
`iG><I88`k3MhDN2Vb46HIWjJEG[k=@@48R=JOTO63T^T4Q[OPd7U\Aa>T8=hEbi
;41jUfc2V2TW1IUOd38?lj[jDpO8\Ze4f8mZJ:E=GnRGmlcmdW^d??cTL3d69Khc
PWE\eD0n0kDbOX]_@9g1:VlklClNpPl5ZJ5>KAi>a[;6ZpIe4:=DET;d^__45\m9
B08_P45n_l;A:l26>?SQ?9adaJHmJDZMMdgGI<jN];YAIJRQq^_83ZTG\M`H;gOn
XIj`e?>2`@=1MMJX4J4ZJgah:o7=8HRad?]BXY763hk>bSih<M;Rpg8_m^S?JPK3
FE]OhXAO4@Z<Fk4Y\?[cmi>Xk?hhSG595F2<==\CMT@dOoE`:O?;]:7Op]GlV@A?
OjFEZ?54B1ahADVc8El2SLK`Jl06XR_gkp<43ndkh:kBU9Y7j@_]mVd>a8Ci2j:M
KcY9EBbKn3Nn[allWqFH1kQ;<Y37Z_?V_QgY]PEH3@9;<lWNIDK^NRkg9`WSENqg
oJPb>@LcVNCI\LEI=L]>Nfd@X2oom^jcod[JRQ=U_3HcVaqSYNlm7d3Zh<;V\P<9
4cJbhB==i@;RKK]`fhVXZL:h:68qF3H[@Z5Fk?PJWWNCoIXR1]KgV<ZK5;dKbT:j
W\;[_[4nSDJD;`WUUfY0>>eG5lp09b>\]U41VNM^O7J?UXYgF9BD0^P6Dg9\YT^A
\9flHlDY4^=P05fSnq>Qgdn77a@621<YbN2iAH>6>fRnaIc\Q>b1AMF4Zj7gDo=K
pLg;VOY<HAY>mfg5I<RV5?T1jE@MVjW8B<jAP]0_P1>]P2@NdNWmm9EJmEaqSI6W
[eOfj@]Zm]gY;]_TWS_I1C@>P9COTEPlOS`_R\1[9UU1C@:3ii?[C?lpTI_QPo^a
<JRBJ:IWncR0Dl;a3lk^CU73>fA5ln0n]YJacMT`E8WYbdBb3id=AfdVS]_PC82c
d1JZWd]IG=hpFL2^[C:Lk?SdBd511:<C`36aBYEJ]SD_CSE5kNXe_Vg_6Vek3UKM
c<Q5cg<l7mCA3Ffq[bjQVVGBVF\hghfl`AIeX`d57MXXco7Qn[EP0GeUqUH`5n6F
5Dn8=cDK1N1PRS;nQ9O<p_eMgB_ZWL>YFjiZfY57lR0fa3mNWnlUYD2HH0T5^@FZ
a9cbm\HElgii8HkQdpJiZh<dJ0`H\_^GGRMOK7EO_I>`P\DOhe:j?LmdlEb:[e_h
WKDD6p<mdAMGRfen2TUc]T71QLKUi1KUF10<BR?KgXN6mpg=n2Q94;:G>lTUUOX2
Fo<nE5j>Y;k]\5M@>AfI7S=C4C_;W\QBPZJAY9:l[;59e79A]ApHKfAd2^D:aNBo
OW\T:G__?bbDGR`?bFAh`[L\>c0dM[6IR2UO_E9O3<P0GSqnVCOSDLUDa1O3@B0X
R1So?oLD3AF\o`0B;>H?WdmHW`qPM=VEdiPD4Hb4mKg0KVG:]hdhR;A@4ZFjA__8
lc8d0UKdGRFN5RYL=]DY9OkpNbX<BIei>kg^:1aK89anY]CNSX\;b=dKONFWWZil
[fNOmPU16HhqlaPO^E48`hHd79?W5B<_:j6XG1\YWfb9p37IgDdakYVhjBM``;PE
@0jU7TAYbTDERSlkKTYRpD6dCEPFneW41;m`b1XX24U4h4^bEhdSbU^7^GkBA79B
_OU7TNNaB\`SY`XL8mk17@ngSqgFmaJHXO\RNb:1b[[2@GGlfL0ffWM\FgPf^g_X
NKL7T:1Gd8E?f=EHI]H13p=;KNUkH:SbUQcZ504Y`VCGQW6clT>fXk_h2E30c4df
6p]3\ZO9ge>:P^f\EUC7SHTRWS9C860B7Sh7\YDEQdAfb?SPP?L@q1dOHm93jWNn
:gT]Be6EPjY<FnWc6>TP6ZP8J?^\631_HXaQB14DK5LVC`BTAC_V[h6od@:CVg@R
A0VjS7ijqI5RgEb=k\HnQg879lfLoPKIeP;Cg]5m3ACbff`@2ZZ3OP;;CT\QKC>:
d9k`3l77@f\fDlLhg@?R=V=56U7m@C>jAqed>e2kkB8QeNmQ=<DN\1?W7;<=ka@a
q^0;<92YG9eEdDS<PbaHaC=GhBO5J:cX><7WVPbLRYoF<po3=>_IEB2WSIm[hiQ^
LSAR_Bj>kB7W207o`;0JLOJcF5;Jf?9=doF26`Eeo2[f3dT7MPD^7=oKY]2R]YQb
1:8`Y5E:B=50\4hj:PGWo0R@ZkNgc8mcM@p5cPKIa7o^9cijal58K2mEDb3\adIU
EQKoNAOkZ`>AeQ8B;0K97PcYo7DhRkPdl89F?^kmMWQ3oMoJd2KTJ:SK`onal4;A
f62WAgohgm7_;Bfcdm=ST`L[eqGBcch@0GO<JdTA6W@g^?MmD9U@F[nbPpKUX]Mn
Y2EeL8^>laSXj<6Nqdc\Yd0FXK;9KV_07YW<=JY@0ES3bN7J2UK_][`df^JiG8Wq
lG__[ghWgFNH`CT]FHclfjH5oM=7\2gnXTH^9K=pKCLLX9XHR@kckcT1nk>lK[SG
^6C2:J\]Bh7k=95hhfS:C5>[dN;qgSOmCZP3L3>]_\\NCL06o>OGlYi?BX2R`XpC
hL87KoZWMV3cl0ZTCU\W\D17jMc369RdSZ6ABj[O`q\=BRUDPmAUROEbSCKU913c
@H[k`7G7@6ji2fO>bUO=@7fhYCRcLDg4gpaQAI[EOlCnlJ:lJhM6Z<`UE;BmLjmd
Xmde=[LS>p6M:T7_lXGX<YOLkU9g]630VhO`NZg6eXaFjKf4Lli]Y:GAGh5P6LhJ
R7\nGYmD2Qq>E:k4N?:cOI_Ai_`ZQ1K3k<\`;>pJ718H7ThLXV;D;9K1l86bIe@d
0SKOhCdXKq0HAR5G4qbjkiNnkYXR9Qb9fk^\d34?RRM7]VXV3E1no1UkO1l7I75`
LIk<>N`4l5PHXRZocFb2Zib4k2ARo1F]=5=BP\ZHf\Ae^iZJ<gqI[@UDl_\Idm:_
_K6KjPXOjR8Zm_hL5Q>YUObpTdXU;[CpA7La3OIN=1BREP90Ld2aA?H5222Z1S67
9PU\RXDc6kg2OGEc^=8DWHHAq=`VV=\9ZR^?aJladN0BoiOeEg[idZRYj7UBb2>?
nk^oA18X70A@J\?Lp8:D:NYF4neJZC^gQbV;j0VbUIEK3:1RR^apoZb;7o2pCmZ8
\P2p`jm_<E^qWH`Wkn?VY1d8\chi21>c^eb8A]h:^9fKBEI39Z1pmM^:<_V8[d;M
?F?RPmSO?;:9TIn76>7GUWG2G4;CPVJjhoHEF@lieOPI^C4:0]cGq6F43CY>pJIB
IobgfDQQ^ba7daebLmLa_?3YfY[3qk0EcX^5qNc9I<nTciH[Z8GB?bmK]Uma>6VR
cj=h9nVqcfY^UDBqfFgmlgEdIP7Xb_Nb]nM[mmO@3JQf^a_YVWZnNKV>Z?pZJ3jP
gASN_18kejAmXVmRPbcBX3Z\X:6M7EgXL1Tp@0ZD]mQS;@_^N[:=f6@5Rb^hlhTh
kEHQFn=gI`R]Da5eI^O@C=4C^>Ng[1jqW[c5n\_q>FQZo5H?edU^Q9027L;Sbo3?
Ebg4YX;o[dJ8pZahBUE?pQ\n=49e3TfDjaVIP]A[`Wg<3^17U6>0;jLdY]Uae1?<
[oAl0G3B_COS2Me?F5mdiXfcT7np[ZJJi^>qon?ggHSTF9_XS:79]CedR=6;[f=L
=NGjN1QESh^kJIiWhT:^6dbmM4nPCoP2@M99X3:B[HknIkqFClLc\^p>igdZ6QAN
2fm;=ITo5a`7XaJnM=hX4gfnfB20EXQnd^m]_4oEm\a4>Ma8a>fo8^AHTS3LOf?I
C5OeKCOOIV5RdI5do[MBIKFKgq\\4JGZ2@8B:P6Y2NST<YmZS^bjh^lc1f7>bi6U
YHkc^b;hoJcaIpLR1PJemp1VQ0k7f;0`eKIEEnZ]OiEcQn206PnCbBWFY<e:oOCN
m>^@0I]@551i7WqSoB^2nmS8f4ihboXDMO9gd>AW[hj2EQk<8q5TD>UlBYf9Y2i5
EeMK37jg^]2n4iDK7mi]CadCnF7Cc^O:bf\YXp=n`<AcLpQ0B_O_lpZ?mQhLNqW3
]LHne455HjLL@K^eSmj:\YM0MhI1d105VQkM`S<;b?L[HOA`R^i`o6\mEEY@Y^h0
noq]QBV`\]_U9Re8knWU1dd9\bg9GRe9g\A2QCFG?ToID[;A=ZibSKKUU?;qWV_<
<NcpL_ml:l4;BOK_e2PUCUj\J;b0KU4URRW=BdB<BbJp;aPb]4Cq0XX7AiKp[m1l
QUmKe0g7ESnap8VNd^\\pSa]5\ie`5kQ9XhFak:k\1AUYjF5c496>lj8i9f]dO:_
;H5jUVdCaJfiLNH>p?^2bR@Eqok4n5:LqR_8_AE:qRboMc>n9Mcb_[ObU9V:gHG=
f5_F7cegkpl:UcX2GqPn9i4@fY7cSP96VLLBilmRaQC4GC_klgnRI4o9M0SCq64`
Vm4DpV53MGi0qSN0?9O4mCP]nSK6O^aH@FjokRCD\?enNI>f0qOICD6``p]<lO?7
B5:cdj\E7L^0k1c;LWF=Rq[mDfi9GUlTPSe41lC:;W_PAU5CbY:Cb8Td<n>U^99>
YmIcG;NbbF=9SRcACEC2W\djI_Q9oU=<qh7llK\Dq]T>j7^]5oTA5SWUZcX_<g[W
9T78P3`@`TZ7^IVO[9PYRT3<:^PbZPI8lTf8DW696@fe`dfhm]k<d9d;XIa@gSf0
43g@XC2BF=RqCmVO8bApkDLhLjfejC;NM>0=OdY`WejO0RG<b<;Do7XZ^_EFa=Jd
a3;@T5afXI8Kp2f:IY]fjO>DAI;hB_8TZjAh8m]b\BhR>UcqX^dSJilc3k?Y;?Ed
V5geJ:XaSXSKU=eN^\gk;gAjKY>^iMPLTliqn64JAB=p_\X]oXc\?`0ZD?qlZ2]G
h<p0W@kgbUp[162Ve@`FTK0c[A8=4ge:fSoh3_JL@WA1@QW:c68?<Voh[\RcnnG7
lFMqCea^X:9^@MgkaR2Tpg?nlc>epWM\CS?nL<f0Db@oH2[8i87W8DbQS;fjm^g@
QTBDpYB7Kc7@p4\4K?lSq`DW1dUANq6jB9RTbGho0H3cCXVl\0akZbNbh^1YJNm2
fL7Sd@jVC8ZXBNbTa6jjn]]@`:[;]jUmpo7fZkFCqOhmEeR5L9_nWG25ONdmOe^l
[7\QPd]=BD6ae;43FCHTX^P8YWHlVkKm^pfGjRQ\\qBNbKnnUqo4@QM\Db0;eiVj
16]hb1W;?n6lROe5CJfBMl>1bDZMI9gWai;i`Pj?O[_kN^8D;=omDKpCgUcjE6q^
1_8dncQcc2<Mi[J[=3g87SIbS<@jBGkJ3FUQk[dY9o`B=RL7;0O_bdDfc0p]S00d
Daqlh:HS;VL35TBn^mp8BNCT6;_QkUNmg]WIYSJh>=7<XWEj\nM6;:VpF:3MCjmq
^73I@ZBp8aEjbnZp;iSiLAgLNnL\Bb1l@fkP8@@C6iJoHE\^:NA3q@k:7>ZS1Nm_
[:<0Jq=VLY>S4qT;K23Fdh;Xe;12^iG8<Xf\HcM;HB7T0P@Qme9@gSK0LUn=T71]
jI[GKSAYMYpo\T[X=Wq]AKJdRaJN>6IB?UD14XT5^]UHg=8e;`<5fc1pXJeAca=i
fIC0fUIh_TH:RaA375pCVXO^JIqg<Y]nAFqi7>b6DJpA<b9KSL5h>S>[eSI8BHNL
]D798d_^1=f^L<FplMCgNOU8gdnFZ^Zg;X<4@>g;RhWO4\4k\HORR]EaDfK\5o5q
0RZG82TqZAeZ=a?oK:b?K:3LHSc8Qab53ZmkM;7foa?=:L^LZ:5<d^S:mi2CR7;<
89>435HqJUn;kG9qUL30_CTnh49CFI5f2g?j:i9TR<V5HWk<fJGj;HeVY3BHF^[G
HTaqg6[ERD7UojP;LP0VgDORHkGBkTQe@L5HfbdZnVWGpS_W?YB=qEOYH8ICqGi>
EKaXqZhO7UTg9]UL<OU[CoCp@g17C;R5iIo0k4F>Bm8hRJ<Tcj=MYZ2mFo[LI78;
q6[:nd\\pFJGOTbPfg6?^K6n]VXjGLiNJPehTD_eFZjZm5n4;;ZXYTUCD^hWhdDL
o:nj2;e:9qjebjFI9q2E]?DG22n6IHk06_\m`@[>:5`kRmFQj^1<bjO=BHp^eGY?
\1qdeI?lngpMGE5aZ<pKleIWJB^?B7YnZ:dIFeSKbkahnog:D5Ddm8jeoNj4kfBX
bmTg<HkaB4od:gpD[R4@?S4kn34[KjGgBHl5HF2Zho\lFEh?5bZ0n6]p]Bi_KETp
FkHi@aMqB^3Y:bhqYRf^njZp39m>_OmnE>@1@OnGfdkUKNiBI:;P1WdaLKJ3qGK?
MXWYaRQn_QPe9Y0\[]UEec<6di\BTcLcJpU147L\:B<LPC7`Z^a`SmRE6`^<NBHG
WGC1Gbi9F_po`Oa=X3aJRTE\?Pc<YGZ<oOpBVLlBEjXmXEAW1G2cEF3Mgmje07He
ahfNhmk:VNlpjY<e?bnqVGM?T`5pd8@Eh]1GbkGIZdLS\B6glkZN7R:247mCWH4n
LmZAARTU<fmhI^M73eGf7jDMidimDKB]_JbRVGFRWP9l_m6QN<7GYS:h@6EXfcnk
j58NoFi=?Y]kMS5@3]3^:fiodiI1R?VD;Y3>plXAH7mOWYo=^^G11mcYX7c3eF16
3_iDEM^JYR=C6<KZMQ]8Wb\Z4bnmEdE]kncVgC0lLlH6`ZU\MLFElH_CIUHRFgT_
KpP_6Pe3kVEP;:KlojnX4jO1ITaaK1meLno<OHQZURLIYLThOU?>Q>;GQ>`WG7E=
>18gAO;kJ_@CSL?l2:j6MVm25;R3Nl1_C:5[4?S2UoY70M[@=f[YM\1I;N=:aHoF
YD8K[Ye>YXAJLlnhpEh@GgmD4BE[hKEl6j1DS<KQGO30:Ck]0h=2KOO8L53<oej_
h7`h2<fL\Vl]CPMJ^J1j0N^cfhfmhHXb<31fh[_QfcDCLH<g3>`2MO8FW2H<FG][
M7en`p8=5gnC5a@Pmk]=8U><fWE>f^HB_Sm]=`Qo7EllkoQ3EQABd68l[pI60<P^
mPB;RW@6Y]CSAeW8Z4dc?Hdaq1KT`C[=]NeEfh>B8kDj^8AAUTIIk=CNl48>6JVD
f10lGI6JqcQ7cF2TB@K^IJl4Z8Z:3962ik1cQ[Rl8OJK3WF?9Fc;6oKjNVHHh1jL
:e24qLe`4A_PDaY:`hX0^T3?i<3MM55WnPXnm=KhV;F9XncYch4m0oBel5SJ_EDf
qag>?LjA1ddXFBde5\;B_4aD^WmfMn03]KaGk4nGhQ;VEeBBO=9nbi32QZfG\S8^
XplVVgXo>gdLMS\RBf2>^nTANc972GeBYYe>g=>W_7EgT370O4KdCL7U09FcoG3\
?4qeUg[TfVDAL`f8hPA1e6XRV[_U;3;;feT3MmTQ9b_11F4A;Th<BDL^m^61OTlT
jFd[OFJ_PqFSanWAb2>HeJkPR\BejDB4WJ^7o]PLa?ORbiF_IYZd0GCgMRIU1SZc
?o\?A71Ye?cB2Zn7q88MF<dSXSH:[l<D`Vc?J:eAHDm3V7:?MV=HAZghlABO\P;U
RV5Z>IP^eYlkX:DW5oOb<?FJ<P5Th]5P@2F82E8A=\WhhfCaPU3:EME_YX54Oj^b
fYciHNk3ej57DbfEM8F`apNGD@^W<RC@5;hTk_VOUDlIj=Yd3YVke?pcL7T\n6m\
ibc;d76DZd^B0?jgZdk\fRE@>k[N>31ZcG3QhU6``K;1mNQnaHdOjAaI`K90L6Ki
:c7YNnCSXi8XH?KN<Ha=nk@^8_:a@D9VoXQHRDQ>W_48TUeIF6oGP^0cd@\q`aV>
A86O2c979ZnElKF7^=]mQ:_d^MEYb]Zgo`g:jMgjoPA\>c`@[ba\cCZI8@3PFHC1
o;N18Yji5_KmmK6nP1]LaC;ijkJeMiNe]O<1ITE;jS^7b7aW8BG^<iX:kg4b`N3I
pGElUHJo=0Gb1;kZaKfY0KW3lgU8k@Y2TEH6A6]2jj]FN90P9BWV4R2B?1MknaZ[
WG]AgpSh6ac18Khc4=PQnn0=>nOjL\PGmJDPaE]l?c3K2MHgGej5;DRRXo_8g_jJ
Q4[8`XS\AMpXWQ96XAW<EIL_<M=3A8d98HI@2JOIhBA9MZoOWIUg?IF_3YVch;0^
m5U7SLYkDG6FU^TR[CqSj[k9J6UZd]JB<N2aLnl;58TRhlZEV\9bngETQ4TbC0Xa
j0F7@_M>B5AT5CVLc24An>iS3Vp9g;TWoK`Ea;NY<fY?PT51kpjo5BJ\k;1bF:5=
SNfC5:?M^FD1nTQaj6\@Q0JOWkR]cjR?T?@kc;YQqMMZl<2BlFkZXW2?HSe18BBh
_FG8YZH0Iki]=MQf7NlcgkAb`<GH]5WV_5>FCqOB[a5mCE2h7<\KkoT3VmB^N7H\
f7IM9kRGA[A<X4IHWhiHggK]oO?HSn9lpGVbo?2T_6oMo=T@N<H8^WBLZ_ON`_2=
cO_g;JDgPc<gE@OTEBSV>5GTAcBp=UW<O835?cHe4HI]P\=GM<Fb:Oi2oPfdP@hZ
4LEFNJDhOE46[HojG=71N]H1\M[5=AF<51FnVoM6T1_J5OcRMghHBQEc?ba@l@cW
<AQQ63LWpRRkoRGXAi_91VKbJp2;234P>n[Rd933^9:\j5QhY_cQZN[G[G<BIOHb
oNEKg=N]3XZVjNhK82;2Y8T<mICh:5_ZT0ocIMIdq5kbUb0nbho@a:Mmi2K>d0D8
Ecj364<V2QMRWFMSDn:=NC>n9AN_0=XMaKfnpQLZ2L\jO7HC7<[bdgo1i]\b4h\1
P7]diO;>RFgJH=E7GRL`;AAZ54Aj_MCTe>HqW5F80C^A<KLLZiTXg4>WBfS7:Y2D
Hc@f_SRH0kS]b10=BZM3L<dKbRG;J5b9oTpU?=38lD]=e@:U9eQ1TMM6@chRHbNX
aG:3FT@:TBEP9?6eN9qh:NkQK[phi[cKPSb6@GMZHN5E>Up[88P::oXjMf22mC<M
TIFkOL<PUICGXZFE5bHfbKTMHPhXL8T0UCFEl:_IMGmgSE__AT8dOab]i=<\3hNo
3n]E_L39l;=HYDbEOQQ7i;q9=JcYPfqek85hol32>GSTc1EPhomanU18LTbY0cO^
n;:3>ALCQ69_hiZ`aJ4m64<9=F:9MWS\2loIAA]ekG3p7l7gHc<p\[4Qk8\4B0<c
b:5^;\UWYfnheJ`li<d=`7D9m3h0`8l1f^X4W=J3f`^faUGNCljai:3oW:SPUc[V
L:E];^^5i;FfMWEhYfkJpFoFdbKB2KRMfN<>p`VjPiUhpdYT_kDLq82D[hHMqcD9
\Gah1ZA4ie4=3^LAbhafZiWeDm6l:_Gf?2TjOeiS\33\7B9c\O0Q<^ZkmZ5CTL@9
fVOl9K[C2jT7]FhSTLiM_`MNP>PCMmU=URLeJK<;7Un[Tf6:1P=3`102OHmH88aD
=:7p]LLcaYCaG6lqY97<c6kqi<m7I_Eg3VhN[l]Z:TJ3M\cG46PM:3Lm0=im;[7H
8O\gl^L?Pl6k>cE6OG[FL@hJ8VY_9_VImmq[hMY>]Cq_PX_TU7qA[0WfE<kU5\=b
W\F3YVoHQ>j0fRU0?QT1FB]7:?q@D]Q7ZKq5Dj5jL3o^`>n6]D:^fEGXefaX4?Hn
jf91bCJ]Yej^_Je3M8Ge\ia2FKnflmK:lNN7IjJ0L94NdpdjVL;EPqJS?]?geSme
mFb<X58Mk6Rje2l1m957Q``T=VlcA<ZHl19<Aod;nX=ZAL3=8:Z6;b<@aLZ6S3NU
LSaT>HA>G_5:e6]f>CSOQ9HS<kL[pJ3>[K]4p1Ni2i9h0^n<g[EObMCKJnCaNFRI
04<XA3]T>2N??Yi?ii4:`2B^^>JX:AL@q\o=E8fG6jOgMY[45NOY5BPfS_k6dme<
I?^IK1RZ8?=BdPL7c42:MGJjo_YAS]fFC9Pk0YDGBmBW9n[4G<5ZS:3Y;9Ei=mR_
Jeh`Ad:o;J_HoeKTMab39PY\L`IqcPI5@BebYC;Y93m\1fRGKlc>B]:e^[i8<f<l
4oEWeHYJRhK6_R==WCImB:hi?ihcVW6T@:5e@R7HA??K<NkjQU2c6Y`l<94S1DN6
]fo4hGH@JHej4^q]57bM6hpaYcZ>\UO=UlVVIB<h0RB1RK`nTD_[gWb5D31Z=4bd
nU[UA@e3S<2lcP3kP[OI3X_a;8KLPLqIed1_dIpGN]e>Pd47m_OMf<6SJ3B96^g^
9:=`IKom=OAaj6P?POE;Ha4Fgg1a0pbjTgEh<q1dlA>:nq6GL8FY:`dEW9WLVVe;
eme8AlG`N37fhnXPf67n`TU>NnRDH^pjM7KGLKaIH]?cJ]6\l7dENo:TbP]a4TdA
D9_j?an3;UJ2`=qUH;ZD?fpE@0cE:Ce<CEo8<:K3Sjk9]Q;1B<60f3?3B@S>3N0B
CkdT`C4c>W>Bi`J<D8:j:eQO5XNNYCNhiMQ_10F2bkV3mZIU5l069oW3nD9;R0p;
oRjS@Ep@[loQJS679KbIb=HAfhV<RnCk`E^;^71HO4W8]c5\4H4gT9HEHmSaF>DT
e\8N@1a61diKoBGa=Z_pLhhU6]HpV@hVi;N<cL_TGe`d@9J]4P0lBCcgg1QQjS?C
@\5g\U1eJaC1Z\W:7:kDL7QWT5BNbNI:4Qa2H6:n:ED6@l34k1?WB:Y\XlLKqDmh
lliCp`L^7ZeXK]PTXlVk?fY\N98MF]3N\6:L44;FFiPWPJg`RT:OQ<i4QGR;I8X1
p0[B[Qk;q9@]PZH\pEgh4mXRlf;]1>Hinf?UaPnG\8DJMEnNYdIS?bUbXF[08m8[
mVlf?8T3=33W>MEbS`jV8k`E:[L]7aIHWHX;29S;gB^cNmn68>AIOjgkW?9Kk[gK
@b[Qi>KRlcbaO8f[eKeMcdDqJ:eT\NaY_Y\p0Ko298fpjoeV9621n=dLA?hB5LIb
k7IH;GYCFB;J884\eUaIXXWFGi1QJjd64XGHP]fI?:iH<D\T?6Tod<qjEE]c?DQ`
:M_DoBln=XbnDW:QOdNQeQ:P\o2Y;cZd8W3Lh:3FHHK@dImBb[pk<Ak]`Qp]G9fc
CjqaDYmO_hpS0C_YnNQ<<6HdFX>460Do7d9l3]Ujo[:Jh96:INN6_l:;3O@SoTR]
kZhaEWcjP_am55UOnN>17pZSDEnD=p]m:6T\c]PC5E:OQ5a4T<RijmKf8FVj\H`B
G;dDpUMLP5^<Dg>33EHW;?n:G@kgAA<Y4WCZZRdl8O7E?_^OgZR4`;I3DoQG]FIX
UKI40?if;lV4lYcPbO]T5b]_BCcgWbej@@GZcHGhKj6pLbWdbc>q071W1QEio;MB
c5`Yh<TdYhTMTjFdgkI?:SNKg8PEh39?NWOP5X[9>`hIH?Wc=Z4?@chiHcGVf2k]
QK`hO<T:<@L[B=ZZgl5?eESgTQ>feYPQTWS2Pll52hB<]Cp^lfQ_55INB?M4SJ\M
Kfo8ikDJ1^9HI5\ed<k7MIWGVd\nc[KEjBWic]8WMWpLn?R[KNqZk<3;`W7FkdEF
OSC9LgOFXhO:eVRKWk?SJMR_1@?6`63Z=9`3QPKfb3L5Dl^pI^<;a;I7^:jHV6XA
YoSc1<bnaPngC0Clo9VI;j2LBKc0eO@09IJ=FhXYql6M;B`XqFFCl<E7EcBU3D5d
DcW1jJU@Qk;oO2F_<ATecR28ek>lfgU789A9i[4UXI<G?IA=5nD2pTT5UjHlmK11
SQBJk1FeYf63a75N4k>@oMlkb_GcgERTBkkc[MP?Bm8>Ll49k3Y`j75d5<@CUG6i
BN38:dSbf8@MEqD\P2YcLq>^ZJ2F1XLDE]5TEGRi__3dOQ@;]Q`i[pWgNMn_9<oN
0IP>\?7fmb:7pUNhmUL5SgL3RNQNQaa45qIeCnTB]Zh53[m10K`k;5K7q1_9[0K5
m^:aK]<5nRo5`E_G9[mHbOX3Mi:eqIKK>I?kPkf]mm0^G3GL2=4p0g42EIQ?N`5m
k_[VmiF1DXq^^:SFH\q`c4TAKAg=cAaRS8a3VNZACYE[B@RjYjJR7b?3bGo2VUDl
ZIIVVP69RUX::Kp<fB2e55qbgQ[X569p8Q7n:JBpNj?a[mbqbl]Wn7@qj\fG;\<e
La_4bn3aHFQd6PN``\nib\o>Geqc0Z8AT=>FEda\EUGkKBR^CZ3@I<MG8m2Z?]ln
F7jd[J9j\MfOfH^@;6[260h<\FknGnnm\COQbX3\IM9?8`PSX6G]`Qi885XZ?]l8
o_DdmON9RXd?fe:04<hV^oHA4\aBQ<bIBJh4;J9TmbqT9G`>MVp6DKYQj2:OM<^?
on<H`h=Z3^M:Uj\3OYKIj:XfONe7GZ>_CeM1O[CjChNAWp0aD:hfK;<ho1Va2>gP
Y2bSAJhV@b?O;OC1o=X=H[LDl<Y>11X>id48M8Dj]ilMR?OEi_ZgTPSP21CKRlRY
fb?aR8hMi6\\NoSoOW9;h1Ph`QSfR=X``nq2n`SPDLq;7SZiaMpAmVLlb1qoQVc7
<Ag59AUg:eJLnMAcaF3e1F?iTfEQ][IX63`IQQHR`G122TgJF\mD>LO=iS0T=SO6
mJ>qgIbo;enXK[JLn0Kd@`1]RE:hNVGJ:Pc56jcGYG><?c_OT?4G_@`;??X9X`i@
\fmY]f=O5@KU^hN;LV31@>NNX^]Pa\BqfQLhah=pN0HM6VCJ1GV7e093cDQNFTd?
HbEaMn=FAcQNE3OPJkHgA<1NGg563mRU[23`Z>YgDR9S6_@NO[a305Ef>dZcKUPO
>PgVLo?W5GjV<[oaBmHF=F<?67nO77pW2WX^P4pLAKNMIAgjMAMEK>L1j>JQ^JbW
COgcmOE:hm_R6\<o3;kRRY>8hK56Q\MDOeQ2n2TL_RNTbc1RTTOg:I2;I[cg7USF
:h8nmIY[Ag;RMgj[`2\3L_6JH8K6TMd]3PEgRPn@Z7kYUXPP:AH[G2LhSUeL4UVF
:h8nmIY[Ag;RMgj[`2\DD\q^UCFh:JAQVK>S1M:ab2X;O3;CKN^CGU0O>hc3?QMj
LCgEW:k9f1hoV?RLngKdG=lYO[HAMLOh[m0;6q21GKm26qPoENS9cHZ3h3VkN?W7
X@M1L]<Mh1ST[@nAAZGi\fMocSOh<VdZmoJ\bjM76@<A7GYXH@\MYn:j?2fnla]N
Uc=HN@i3hX>DaRe?i`pBTHRhKASXT1>1LEd9FCE7=UXC?P;XB\CG0j<qI@TXAFCp
<Di`:8Ppa>XI_g0pW]1lnD7R>mRT`iABJ6h`lV>j?Cf;N1a<L\iE@Dk0WiS;EdZ3
`WL6F@Jb;CDkKjdoLdnqhR@;?:03SJcIlmBZMF9Veb9YB]Oja8SRCDf:WfWL7dkh
Sef?`QK4Bco;EU10jKQQ;UGB?f2T?NSZH2]6k@MhF_3dQT@;qWN5BTQ;I_fG8FN\
kU<nYl7T\^mjnKHUJ1:H:VYL2Qc\odd97HZ:Jj[PIS<b3J95KKIg?BMFpnRX7SCg
pahH9?NkqIS52>^:7Eg`OlNiPN>2f9C1a[FUaqZ7ih1ZKq>hb9Sn<q^UgOii4RYQ
FI?M4Qn`]7DVIOUg8C2A5?Jli`Kc^g9fbf8Z0Ll\g4BLd@=DSlfD5F^R7liiN2UF
FT__I:n`]7DVIOUg8C2A5?Jli`Kc^g9fbf8Z0Ll\L:L;qD9T_`dS;?n@ZU864Vfo
bcCTm]8flQU3jAHFa_A=5N<A;Sl?hF?clO<lmG5@Fnnl]DRWBp=O<lVKWqaOTaOd
]FFhc@SI`UY9:g:;[oT]4=];RNU4QSLhhH73]gFa:FSiKT<TT[;F?3;fh<ZSMIn3
k3?9C0eI`UA3e@J^[Y]]4>Zfnel]1^mJVCTVGSQ0<Y[17<SRH4pfPIP]6hChl:V?
Qd8g9MSZ9UN8RT`qJ4jdJId\JfA0aZGOG03[]JN]>kKiXmL1@OcekV<\_[JFR0Yq
6nc=2copPS?]QaSmiaGaZ^eQ[kG<<]<6X6Uahe897RalR4Hg55M^q[Z`X@fLqO>B
a;]?:Y^H341Q?\nAe@Z6o<BoUeaiS^d:X[b;R0NQBOX]MmE[=I7ligUA7;ME:W72
mIY=qBmc0N?GQ?G9G;^MZR5YCNE=L^=X3;A7SkjA9FTUSAl\Dk`S709`7S\;<ULO
_@neRDcdZYQd@KM]oBeJdM3;j8B4B:NXa3oH5BWhXqjIke7[GgWH1LZSFW8M=P67
5]RfD]=JA;2XSRe9Wd9g[e;cd85Eo1UD;ai`qH5oll7dqY7COQ[F7TLYUEj:\pNK
Mh@eCp@WN6@e_pKC7KSd4?5ANDc?F5]TdoSao1]QaNa??TgK8M[A0oP<eDL[\Oam
XMkmBS^_K@am1c0ZB_hFMBC4Z6V12:J\Cli^L`Z=FIMb^L?be1^Sj?C6G5<TC_PT
>Bf0N5Qj5een01=k6qFTIKI\c0LdKHSPM2Pj<>>ZYFI:KR>FbFf0=A0TJLpWd@AQ
>l1F_Ol0eWoRP=4eBY6kSN?^hb0\>WHFBd_1_mhK;n1XNQ41[3ZnjPPeHkBW9ieq
eY?;Hg=pSWH?EA`p3l]Xki`qY:GXhKeABbb42=]DS1L@9ZL8ndf8<>l\5XKSS`4>
\kS?TUnR`d8hainA\BIf@f8j7@mPL74pCHnfb^lqa?Q>LOShUTLPG1[]Edl50AbS
27MMFkMEok<elTFib\W1[>T:UB9[ojQ33e_lJ;6FlBT]EOSLU^Ld2j0VEJPOT]Th
27MMFkMEdhQHFhQidni[MMh:Mlj\j8oXQg>5WROD_I\jVRAce^;hfI_>V:0q5^W6
dHL:?YJ;PjCWJ>g8_bU=oXdhF_n=d_iA`89LZ^69`=1e2JY2RCaJe;=6O[apL;S;
AhTpJoEGoQTmG2h7i?@HG<[J2\Zbg_1MeO3[]SLDA[_DRO;7XhW_cRi=4\=I4]Ig
1<N:3eEIgBLhD:m;6Ji5G<8OMMT2h>`SPb6_U5E1GQ_R6T5WF6K:iZkY>_@lKGd=
nXcZAWqmAT8g?md10Q1RL55KlNFGHZV?_WnX=;ZhdaeYA@\LJU[L<=_LZKXDI4_A
KhBX`pjR1?8QhE]n:A>9@dVTF3=Ke9V1<oeJX7l\f<QnWR9d[U\aKBckf:3E7cQZ
NVam\hj3`^pl67o6M`nYl==DJ@e1AEc2_X186m<KNnGVUW0c4akoJ0^=24=W:b0B
=>mTPpaeHGiF7p_5OC>I=p9aoHYiXpQOb5Cl6e[^?X2?_A0e3ANd55@K0[Z72ki^
B6>4H^9VbFoFCO_I2`OL<7IkqmkX1@_Rq^=O]7`6qmNk11Sm_G57F3B_nVjc\GaG
7mO<;^6M]4ON5jfDHH_clECF7LO>SaH`4]AlhWh_[fNjk;UGNPe?]YVphfI73b<G
EQ1agAQdp?<PDRl40becYQ\SFf=P7hDM[R\Hlhf4Di=nA0MLfS6o9W91QV7>G=14
pV7F509Md@H0e_4=5JSO9pDT9KlYJq0BXH:AI_=TF=[TZp<^P@P9N4jHP<i1=Y]U
PN7jI_<SjDWdMSFGoa[KX9Xn`Xj?mL<nacZ>Pka:_]T4p:jT8_j3q<aPe9eRW5eZ
>6j_^Ocd`qk;jmG\UpYnPkO2Pc7oS<2OHIjo_>]DZ]J:[KoYgfV@^kP8M@^<ZPBM
8<mT87F^T2kBEJ4Kp;68hE7Lp:V5CaXSGa?1M9:ZS=<<ApCQadbf`R`hN=2<ImI<
17aDcQUoBfRURn1f4O253eZ]<Rf:?Ra^U6EN2NC4e7IbgNm6VqYEcMPg0pmW@=AU
EDP\2TAY]5`mm?[WZTAJd4o9U_bIGc`9gEPK]=Y0ObN=7532I6T[fWJ=p=C5W;AO
q_dRA=^_hCIWMMm^k:L4JqLBcAK_mplPTj=dK0H>nQYmWB[mb^K4W`7WNgd@`b;?
?:GZGEP6MOhCgZT:CakZZi7d5h9SpC0jd1n]q;=PZYfO=pRL3blB[qahPdSdm8R0
jV\[0Nib?H1Wh>PNQJJOGfcb<9b=kX3074:R@:84Aa9M7BWOd`^SbJWHMUp:M@f:
6XEA[Lih\aJc:V3Jg2f0n:k@@0U]777<>Of2cfoB^_>34O@[8:UHIDLZaqGEe_HJ
_pSFRNmm[q9E9;<01fN[l\TSZn>7I<9\]0^AGd8PBX0;Dm0RaFNeAOWM9p8T4Slg
TpOLijcH>Xi0O[N`Nnl3dN\k8`O?I8qbL9<n0gR2G6dVLUleU?qQ?j`CO2pDgO]=
IT^497mbgL^X4Xd:]T4E325jA]g_0>bB>[m4VTLZa0c]a4?F>bMS?Gn^L[adj[;R
nCS>B]KXUn[3:9W\ff`MG21X4hg6bd=74LS4G4h8kjImC<Hk6oNPgC^cTZC1gNBe
7HeU?4a?KGq_2CG^d^b=gibK]IIqZCak[9cqL0ag=W@Q2X:NKjDbQH8p`G^5[c4q
G`CbX9o754U@^egBVW5Ul;m]Qeh>Ml1E<Lb:Zc@2jOa=Yb>N94IWJl@51JR0j3e3
P58KYZlVCWZEY:nC^FGZESi?X>hgRgT`<lNo=H_EDN0fcb9P?7DnQ1E9[GbH^J0a
ac=\gc=D]bRMfYRl=^`Bqo\fRSFLqNoM456bcKJ50V??M63EZjRXLGF<TF?\JY@M
:C[hA><7ZCGknQ<`P6K^OI653^5hN>Efh^BHqhGW`]b013AC4S>:Ni3XpE[C=HkB
pX]FDcCQ?aj\0_i]]^V]X\BQV\3E1HNn2\QoaR22[lLo9Za49mM19@Y:2nA9Y>9E
UVMYNlh`e;YjDYhO8aGJVXILF9mGoEaW:]kMTj;UTQgiUVEgk@DXW2RoE4Sg046T
bS?==[d^BminmDS:p5U?DKKSpTWPm2kkmq]oocn3Zq5>:fE0;pI651@O3@QTkFLf
Gm;8Y`3cJGLDJ]]@jR:]ODUQYqm@57WJ6pZ]fAWW=NV@49F2A9QClEAnF3LC<RLd
c2j76lM]^L0D3\pgXHWHVlqGGcdVBX_a>XUDXm^IOj;`JYR84hKV4]7kbiD=9HPM
o_k0aBLcabZg@@5K<Z;LAL]K3E9D651F507@IGF]Wg4W@D^A0k`I6W2`Fc2e[cSW
e^nkOnB[HIL>mJ`h;^BbnEiC`>Na`Pd]HMhQFHa6:T0jdgMT7AK3\aQL8@;dORl8
e>P45FBAP1m7jWFOBUe3AQQlmMCgiW1FY=VDO59mNnW`I74MCM6aC0I@Zclq626K
olYqaCK;P:Nl]a=YP3Hh1lbYAQJMAQ_]d4IIEHKf01pW4Me[2aoNZoG[jIcFCNlE
7;<_WFLWUl>lcmEq3haZKMIBKHgDBL?YlH@\:m;1>Y1HcX@L4jhYA32^O\:PcKVN
<[[jf2;=DDlC>eg^a9Kq]OoPCaTH^X_PJi7PH<7ACocP^9YbkQB_o\0pfMAa0Z[2
^=Ao1Ae9bY[f2AYcWG`Xb_>7EO[q9S8kUZYD37^J@kJo:nB=nEKZ2^Ol:>_R^ATZ
QU^eXKpJn>QkEaSOUf<>n[of1h::?b?B0Uq\S1@=R]NdLK6We\j:2R\9SeB]^o]U
bBWZmpbSOKD_Gp@lah``ho5X?5LoR?k[?>6RmA_7:CJQO?6QE3e@9ENnY8oRi?WI
U[o?[@[9SqV6R=nNIj5>?bJ4g83Z?5<lVof;dg7KLAF`n@W^hTp\D=:IWFL<[[`Q
JYik>jL<DDQ@<KMB=U[<EK5jc[=G9jloMgBahIl2_@d_F^dZX:65bE2=W1Hn__Og
8d\hP7TWeCaRH5>oD=]WK`iONlRCPhhoHY3cUEo`32pX7<gV_aaNn798\3gg<4;;
gbb8?:cG__0dgG[PJ@;3=O]7LbQHb3Pp:GET6bTpOWIcChWNCcmYUT5XILnFXm10
J@GZQ09RcRL40ZDb1DqoHkF[nhq\01e^W1K>LQA=WL0dMiKGdY@PlJBH<U:VO?>M
J>jHjhgZ=c>:bi4T<;M8no7=Ac9W?gkp_G15;ikC7;_84a0=oF1EjM1XC_^bKf\a
^PZ[Tmg>1mlD@k1cJ9TS4F=kpE^555a^qD5HB7_;B^d<[IV?lNVQAeNmb8965nbP
iAjS9]4qcDmG^\Zq5Bk:MoGLiMPWLm^jI>hoL2W`<e7ga[=nNZMaAXU;ZA_K[\Ac
fZRkdB=\0LPH2SGPYJ1LiRGb[YeXZF6fn8`O07cNc\PBnPSAE`f3CbE`Jh:d\\nX
I@>J2UDmOmqCXd<T>2aQXI>8>[c[c0jd3aBAhRXDM>Mj3]FZ<]1\KNVhD8Z:T7e2
KaM4W\pOje>SBLp;\kNL<F[7nVh5cXhU3iOW@BADf26cEC3;@HOCa7Kejl\h^3[7
ee[7W>Vadp>d;W=6a5F1hHD34Y]nYW5Yg7`MFgeC8^;hgpo=e`APfqRUSlfi`qbT
m6>@R<DMk7jAZgB9IOdn4U0Q`Si?M9ag:@Jf@2oG9>HR^2X?`pC1\G?Z[AFm3Fmi
\fYb?A0TFk1__YSn2A6PeRpKL702<YpWhm;c9m^Aji?c92YkGd^@H]kYn:8J]\\f
Q;J3ooTSCjlP<QMhZaE2MZi81ol;AfV0fV0enpjcdOoIhqOha:Q?f>C]U0ogKO1G
^kE`9W83XaFO>b<73mk7Fi2Te9YLPO0gP1O7IgI[npG91gNa4pjDkEK3m7^LY8`7
:3B<lqGHh?kIg1==^ZSGkYYh\:moS0caPN?Pc_iR@U\Kp2`A@jSLqm6P@hcZ0o0N
<JJ1jd;jBFA`>`[j5J3acgKFEEGG9Vjf0M]0XnE2BJfRhn0cq]_CJB5RqoT685JW
BS0lXDWen9cfedk28KEhi?[80NHq3WFekfZ`b@CoY9mHDQB5aFYfp@D@3bnK7o7L
4LMqaNP@^iWq>ZZmJlLP=GVHUj^T@l:R[MQfWHkl=mlPgLB3pfL:14GPTS`BGVTV
6j4lO=n5E72jn7QTBX[R=E7qW_L9h7kq<YTMR4h]H=<HhJ7;IanRTd;C\54RL7gi
N_6ck?piKJJ;5hpJRE]l;8p0=CBLBVMa><M_60OUeo^mGMeB?qSkl4m\]SY34Z8m
gaPH[aOfeRU;IdjAf=6?Kf3;F=4mY7GCI=4g0KW>^:Q>aH4UH_mo^WqbG1=8FCpl
]<Xkh]baDDJ7;DMY9344h9T1Cha6m4<8fJ<HhQORHIPd2YNFnU8kX@8LWT1FRnij
ZL;D9pbO3c4VCpM`IA2Ad4?RhFEK4l5c[R`j[Up1NkDc^Tn6kEkfG=YG[j09GSj3
]_QZhd8L?Sf0=q9Zj`i<SELbJSH`SFajC;VGkO=D5@E1:j\H2_j9870_qfk_dkik
pHeo_Z?>qSJ[fW=Zf2MEnYeB:F6d28`G47N`;pHAKJEeiONP0E31K8?36Q5hchPk
>djD[Gpo6d2g:6p8PF<eIV:71JZD7TkG\ZYGI7l7Y;2T@F5@T3Y4J\E_]8Dq5SGj
eJiLRaghT?Uab>b0=8jkA;Ihd8B;\RAKpXnGZN[SfNJka`N:D[fdYU;P3Z065JKX
>B[4BTgqo@:8@imqb7lI6o_NAo0DKl>q<1Uh687I>Sn5N6XHe81QS7R6EM;Y:S6L
fA:TSJp`W1GNm00E=L=XnAJ=2N?Fhed8fdbL91c@TnG0AFbccD^?7k4W0n67L^a:
Ij^cApfc9M?`VqFgRaNiLaYj:WRC0DM2iF\Mk1nD1WkjlgeOJ_S\:oDDl<3N_hg?
[5BSaSi`9A_GHe8oLg@JCbq]:WRi>@9eGHNf^glOl:^^_BD<ldl<MDjY=:p5\?L6
LKq@YfoPbNpS=UeMd4qck3@gO<5beGC8]To]<o9623=hU[en0X8]gQ@\X;69CZi<
`KZ^9><d:bIm8A70n[_[J0PX6iRp^cU:1m\odL5ni;H\YeLIfPNO9MN`aDpchZ7g
E2bH=;;AgoFFf?C\0o_?O;m\UT\N=pPZM`6b2q^D=nl0Q[f]m9Vc2\9@5GkLjcCJ
YUgLOS_<O1f_LAZj7YdL2G2ikTnh<SBB4Y[dSHiH>U]dp]FV8lH[p8oCHg7L3:Gi
4B0YU4@GFd\oiLWS2@RKVR^lcdmpBgb@[MbB]?U5:S3oZehfF`L=dYM6MP:Bo3]A
`WC>59pKla?=3fa8MFeI>3okO1mDI>mb_bm5W:_S2LhNS0TM63e7d0UX@nO[cJ1e
fL9jhpZXFN5^Xq^@bYDb@91T@35U^Qo]GJi4Ua7o[L[U0_^7[2O:kGRNkiYg^bKB
>>QEK@7k74ofX]R3?;I`qh?6jHeO1i;2D0iGP\TcGEKdG33>53FU:`UbpX;H1enE
qanCR;5VpJL:?o5<BUN6UFI71CGWmakfG\Pjd0ili3bkbVI78K_kgYlfp^kLn@BX
pdnJB?81Eq7=^?IE1q2=hIMaMq8oc8Yb@q0:2?c>6_GO7@[8lSbZmS?9Blb7[enA
D8gj9gq7ITaNZOql]NAJ_LB`V?ii>M50[ITVadA4A=b88?Ql1N1\_\Z_2[bk2qeZ
Ho@\8VTILEMVQWCaG6lRRf\noX1SgVPQKmGIpdNJ7:eHp_TjVI@^^RZ<<?Sj>JN4
ZWMZmAIGCeEe`WQU[6M`DEmL<Ska>jdJmJNBeBfTpb@WOJF_qMIoC5]bfa6VXW[B
moZ\WQSi0U8eo=7><V4pV[_=Z?cb[@BK55NhIFL6ViWHq1BoULZ>p?DbV;WMPk3Q
[cX4``^g=nIYJckm[AfO3DNUkqL6K7d@7=LLm2cd`T_Q9Y1JBY4`>Ji\TL[Ekc7>
qCM;?mK@^jL=ed@7;BG4Mg8=Tk?hlQfbUNM`HFRlmo;m8XO;Rp5=8BAgipc1jQ86
\=HSFeQHLO63;0kA@kjQ3Ko3:;Z>EL\IqM_WN1STpN:CH0I_;8R7be17PVQ8Mn>V
;>>C^W48c_\12Pgg@AUN84cnolXn6fX>^3c8Sp9PXhljjqXBSL]1\@AeHh`8XDVA
kFnB\WNfWhqiN0l@A\Ao55VdIa?Eh5`b23OQPClokOLpJLMFnXemV53:08mB8;RZ
3O@@ZWdMS@3^NZK3NaqCgE:?ZmqO>ed9Fn0gg:KaoYPP9n`9dB]2WG2G4k`O4PDp
;=f:M;NMCin?SN;K>h7jUFKifXjC9:GjPW40_Aqn\On:_[qPD]^\Re3nG9OEN2\X
\_]f`[TVmdG6YNeldE;Ibq:m5`iI6[8@?N?V8N1>eL9:BH1_TFAYUe?`OPUP9feo
>TM\iLY;T>M_;@eVnAi=pG2lMTnf8?eeJ[;Ff:34h8@^:G>;6Q<<DgE7dLf`e`L>
fM;QlBaE89hP^cX0a;77p4b6\J^5pR\@0lUeV?V=2\?J_nIW7Q_Z=R3YI[6:M<ZZ
pW0k;Y5lp`DHKjS=CY0?g0>l=@l0YGM_`Q0m[Z3S=F0BY=Z]nC1772A0F?2[0Z=p
ZNML_?6qR2AENK`q]ElT\3fnp>=JKK^@pR88k3gaqaJX42B8p[B]1_cbYplSoli^
fp1HXGTOhpj?4HI`_[ng1Ra@c4>jC@?fV<;T>o@d1c]iC]aWdblcBY;7g[E63Aq2
D1AETXJac9CGmRK98f6]S3]SO<MkSnB`ITKa6UL><_B8f?amCd9>i@d]0:h7P[j=
H?fMjX^``4DOiHNZ4hnG4P^?[e1IQ3qe0:bPN^>X1HIJ5DnETO?Pjjm\AmBISGJh
>DT04YNnkFC34k^dkUe8[iJ?eS0SViPKik4No@h\Xk1f]DOAgk<_:I6A<1:IbkHE
FD1T;N\e12qQbNJjBSq9S8keZYD37^J@kJo:[Ean<FZ2aOON?obflnqkfFh:DoqM
6PND1ocNMQmUW]BcDiDkB<kkHG8gcXoc7EH][:6e2^AD<O^4CeEp`0<6[\b]m:ac
L71Pcm5I=\o]W_l\j3GjCjWQaH4QBlJW0k5KIFK3BaH03KH;><bpNWjDG4ZpUkUH
c0gD[XaAFI=Z1dC@;nIg28\M5\md3]AB3ZeKO;El0l_cA\N<IAeGVQpbZkkZ:;pP
VA=7;Q4KSF>h09oZWNHjO1S4M>:]Rjj`jhFeo^L4DmC\89UjH=?Em];:dK?<:D5[
?HQDko>4g9g0I[fc`B_65HbFc_T4egLIjAHZCIeD5YmBSGF7;e4FWkDgdldcD3<p
5HYWMlaFO6[k^`S6PL]fdHnSHiDcmbdX[^6243OYeXWW1O6okRTQhl_53NBTTU98
MB=8mgaSe5kYm<`Dkj9:cO<4BD1VBiFi;Z]GDF?nWZOcMSNbQ^q@HIIhbOKbD\Ac
>H]O`R`4aGXbG@N^A0Ta51H_58j:?W\peaKj;`O9Za01oPSY0egamDom]2hXG?Sh
]dDEdMSdTF8D4XD?Y;X>:C2@0kIaqgXHWHV=p?jDAhYXXJ=PJL>=CKWOWVLP9[Q1
KkS=W_a5=>So6Oh4JoTbP[V<`dbd<n26ZeHfVim:RZhpYPmQbejqGVZ>_\bp6XO`
0oCl?:YB3l8[JPZKkh\kfRWbHX:_Kf``Hm3RbmoJ=kX=?Ye1ABWgS\qhB4HT><q:
PC;n@Rf7mPO3C>@Xfm\gWamAjdkKJN[I_Ob0`I^faX7oIcNd7j=N6^=Wh[VUBJlG
oeX^]Lnq_DU_FU@qUR]^9C@mUfb=Xck[EKKTdggOM>Vi2[;PBe5W\4oGNo]4C_QF
Sn9QQ`^84Fgj3hSH2?9\qW7[]Tlo<C[=^YZ=]398;\:_^T<DKmVhebKBE\WchOMI
j=<>>O]D@`4]A]XW6RXL`kBoQc]O6hg;\j:RBWSTgUG=S`]5]6Bq`JNPD:8qoOXa
f=8q2Z1M?D:pKC=Vlf7XiMh1S95H21hV`k=NDTAPlB[S6R7KT2LY>anq@W?2=meq
;X3VJTljb^FAJA[JHJ`n`a9J2lGBMc`NOE=cH\473fCn`VfgeKg]8Z<jjTG]3;c6
NP4OJ4J_S94TKa8h;V^<dW`;Ofj`OoCnjhe==eGZ>;CFQP47a[l3g?p1h5_;cEq5
jIBV7EMnZJO;a>90g:ZEI=c6Oc?jP@XqC>d6jeRH_kKA5`7[[l:5SBbd69759a_O
I8FETG9>FCg`YA:\@4oeQ`5lg`AJ8Qq4FaNW`AqiZk3QDZpoba\a`?oFK=KeTi1<
X7gqO2mD2E`p1eUENSkA@fD5F`B3CK<oWP8KE:^`13nh[YkNG_gLpm0o9F^KplK>
KT78fP:X>RhA\l<IB]<MdmGlcPbh`0;P7WoXm1FXPM[RER>X>0iWf`82ql8LbJeg
qFRNT3e9p2f54:XPpdSfW<WO0]1D@iI;hRVF>O5kb8j?h946E=jHJLDTh]>0p9_2
oJ1CLAloBWg=A[Tdpc;m6:N4<jnlQl;@J3=B@8\1M21oW>[<oo^`1HCpUS9KfL`V
gA0hK5mTiO0:TJ9oW_QdobJCDTN;nMaYqJ37?JYBq]8k2_K@AD6TlF\b9?H;@ifN
NDB@Q7S@[Fb_PiDjh^e:<J<Di`5NJ^1cZ8EK[_8DpWO]RR7?p8UD413?FI=h7?Jm
8okWO@>Voa]CDZ;_k4B44QW<[EJljjhF4bg8k^Zg4A?8O^4WEoL6MSKilekdqEd0
MfoZnie<anB4cJP=\@RLD;1D@dlMT:gSC]\]ifEi5<>TL;Y^h=Hn[LSGH^05XilL
S3eT?bClTknOebfQi6h8IBHloHBo^i0AB\SFnlPDSlm76PRN0TT[IH17;OSF6?_L
YkSTGfXli45djLUV==Xpf^JK^mlRndfUXkf8MH^YW1ee?9Rb]NA]i8`nE1n>^Qe1
Znd=FHh[Li\mQC]E^liY?bo`2RKXD7ipN7=5JCa?bf6]Z4SX2:aBZ_3\ZXN=l:IO
TQa0m6pF1`g7a7QUhKiRTb?D;49[IXMnd2mhnnGNf3<Q]BWd]603Jpl?GTEe=N]c
ZkHAVEhPHnU__aUV1KIJgH`efmMD_mgb7J=1OdD;A???>l0N2H\INb@O=<m\SPf]
04^aCGpk_?J4e9p;g5OP\Ppo9<a5n:pX9L=id9XNQBe?P^Ma83XWBnSLMA:_RfX0
m4nkUYMH27Cl6l7?cc1Qn<]q<MG8cEHRIWAXHVQB\8oU;^a:BQj46^7n1_`gdE\d
\k3Kn8><Vi0WI?l<>gel>]=2cTcdQDYEYIK[QbJqkZE@;RnWA1?o<3^SUK8ZQ0CB
K0cJAMVhX7XN]CjgKGR^RkYTeWT<0dZAqHTkA7LPRB@oi\kSGk1S;^\7M6F27^\7
R8hC\=6UUqQ>^KnBl<GY0?EC@39Sdc=ZK:CJ`Zh?<<31MUXYYB>0AC8<`0l6T0iJ
VDqLE4Q6m1IoYXDH7o0?V[7h9j[EEYJ<Td@XmIfRi6hLB?GYTFd1:Ek6aLZpS;ke
>4RqAQkN>4C7Bl71PgFbJ\j`2i4=kXa]cP2<_D2f6Ob<K25BTK:DKWX^ng7_I_XD
eJoq\iGmNjFp_W_RfURN5aCWhRQK>7N`j5AQG?I88^^RBO28;UEK0HiUlUF_:idn
4@Loi;k`E3AM:dLdW\jcTVAqSa1ELMTRYa`GZ0CS7?dWf111Umk9VR3E;HO_K3:=
bfU07XSYGlf@A<8nmTJH5lQc^0GJ^1p?iQ:3L@>4m@]WAa`O;6lnP:gRQcPon4AH
6aK]0>N=SRT7R>IZ_@E[g`acFcl@:m6PD8bgjAa]^LXTB6n2\>0eE53SD]3nMk40
1`EojKjA0IZ5m9PRNIcX9>coTZlJn9BG\8P8]AblfmaC2KG1ZSF=Cq8]5N^>cel5
2oJge1hM?XkER8KV4N@kToXE3N_<ZV]B[CCeqjB2W9o7pMo8COP=pc3hFXoZeb5\
o1LJ9?C:8gG\2kfWO4Lh>4=^Kn^RcReE<I;_\DhI=5Y5gpdQ5D4^XqT:4h8bOFWQ
^dA]ZWSVlTaK=N4eXoP1Zh_G6ZO]c>YV?]IB<<i>L1LPj7qLC2\V485eJY2J]:02
90J;X9ldA@>[KKPOHSM:6;GWERBcTA<6oci64=V6EFMYH23GTGF6bHM\fmK]:Rq`
>`CfWfkMKORTL6?Lcl5OlWfLE=RBc5^0:Wkj`7j6j\E:i`[\Bi__0DHq^b]JG3iq
X59f^;GFl=M3141UmOeB_JgTJWjF2V_1YYICY@I_e4?loHi03\@i`H2M0Bp@Z[@<
KmqU9f@AQH;@9__o^Eo7nhAOg^<BB41bKXFXkn>6Wed09;YL^qF;@8DNea9J2mdN
RL4W=MW1<9CK_mZ_5EE\PR8Y?FZ^0a4:[<>:fq;QUoPZgq:?n]AU9qoB\N5>73>m
aT5KY_g8WG>2TCJ9]E7U2mn::3mK`;\oqIh[lM?Km>>Z:WIao=C6Bg_nd^=]OqJ@
WW[=APo0`:fR`UAlL^Ll0l:M>Qm81S]DKboaW2WapoPjSL?:qgVf^[PU?:d=F3bJ
c2cd@h6;OCV^6fi3Y<FW<N1FNmHiqmj0SZU_Y@UNAl?Ui99T7foo;_U\Ic@oL@gW
5Gf>g^kLjc^JbK94ih92<Y:3B7KbdJ9@p@dbTD6_8VokC^^0U9n3i`<3hf_90iXY
PS9kRmSdjnbiXllq@QCQ\V=8<1=M?900a2okE0UjInB^B=4K_Nm@qM<Q>HBK0?aO
5jUcAgg^j@gEZoFGI;j2CKGlfZnR[S8:De5:LQ4DMA>q@6<G\_JZ[RilP0leCKl4
3S\e[n88NYd6nieOqn5N3E[A88I@J<oJjh\>ck<C@O^[YO@EOP;Sd<SA47HLNAo6
oGkLq3:7U=hVQAR^NI:aG]iCjj:bOb@oi8YCn1IW_]<fcjd4K``H?qh71YXAk79N
U6S5WRbR`mDIGdjR?1FDg[l15KEMR_L9Kq5jTNh@1ZjaK0aD:mZncAhIK<Ti3Tb?
NHHC@lg=711=peXi_R;;T<BLb<E_D_gGXCT0Uo`S1SQ;oKLXaIFBqKF:\R7k:R<J
P[@n8JdWjlF>qHC5hfGT_JiAoagX<LSj<a;Qa7joTKB<2k]JL0=MMGDT9b`ep2kP
o5YkDR5Xf13nj=7O;GJMeH8KO<d\bQ_iU9nJ<6>S\4R7Rp?=[=CGGjZ8[=L=3_OQ
>CH1L;aTUX2L=e;=`@Oe8Gf7XdGTTYpgVEPYhdVlSjV`[:J?JAS@1SAFZQT`DT[n
QXioM>?ZdYq`dbGZ^En6@KP^6:9g]iY`BXm]L]ZGc5V@N3qEIjH=Um4lECHl>AG\
0^ijRQ2e6qM;PCaOaI51CXI3R3;6h0c7cnn8WGlBKVY:iY8oR6f<<9?H[?=4egnc
Qm6]ik<i7EK2?l42Tn?h=c3L6>WOaPR8cSO:4S?nXRAi5L]LNTHC@lg=8=kdp;5`
]HBk8_?OmjVD4aH[G5Y5oeIX:X34>>9kQAMPG4Pm;ZNCK30RF?noL8D^A60jHG<H
[U8[XC\ZERiU:M[IYc=5BlAW465_Hfji:1]7EHbdH9hO=\ip2G;V:GAC>;]7U8[c
5D==\CS6`lFB2baIcU>?DcmH=195mUX`LlpV@Ef;DZIeN<4nT^>\foRALEFF51MD
5<Kk`M28fFH:a@gkia=R>pM:=TBj^Oim7m3Yb01Mj:PL6a\5CmAYkh:QO[DKmVDl
l^=EDf]>pm3KY[i^?TBaW0E<M^4F5<CDSoj21F<VXJDE\7U:n:f7pY;\l1P>IVk>
L3RZFPZZ`@oPLfMhh570QYSB;3]c\BFBqCJm3RaBPXfKgICfI4hCgFiJOc5S0JJ>
_l`1REQ>B@=eDA0EgJg<WY^CEojm^?dFFkmEEmW5B:T5Ld:WVjFIOXBJaB=M1g4V
jSbA=[8^h7]0LdU6lKHqH7m1A<Ub`eOLSim^YdmjQln0<cFDkQRgFc]h^FMES4MF
9:LSI3I:SQ58i`pI6A22aQ5;oNV3O69^je@:ZM@AEQ>7^FQb4cHpG?Icjcbm=2Y6
N?ZWdnCZe?hT6EXL>[>c6jC]h^=q36;U^g\J70FB1R>CT`6leof[Y9L?C03Oo7Y0
R0akJ1^:CGD5Z37nKh16QGR=PG@gV=ZjG_k@>ck1_bcE3mcYP9fG54aS<[GXP8IC
lfiNN5P2@4EZjIq_NLVeJQ2U@LWjMkN:kP5W4[Ilh5Z3dD[QE3anVC9b8_?<4UgY
QhTA@B\=gFqC<Z]2`iNN[V7fJNhf\^SH;?FiD<Ega:<YYcV819aXOPnK=3RHE7=S
`J7e1=pf]=A_2N=gFN<hC05<T7IMMb>nlK>b9DlBAecADA1`kZMDcQYfT76;bW82
fZY<4Z7bE[_90HLgP7<6gOhX5InSF4i:F7?eMY4Ge;GpFlha6a9E]K:DQS7SRaA@
oFX_?Ei[jBa=ac[[5URqdP<[<eIX083625L7WGB=Y_:FR1?dm[^SF3Ia:2JW_[Wp
_g\b8md604BX]DOP_8Bej1AZZ3OBd:i_m8ImPi[IMMpFQ1:FOjbS08dcS[SoD91F
Q@\>mdBKhOB_MikS2qQga_if6n_9;P\[Loe;[bVS247]HlZKTG0AnQl=jF^fCq5l
\hFdfqQ6KaH;`qEh0F:kiqS0kBO]CF>iRJ;fcFB?HK@Ac>E5EAVcE4kh?1Y_Sq4g
F>`Uap70kLeL2o=Le>:iRBXC87>ob2X5H3Q@:6k_TO@jcHTZhq]enf`<iJUm9M28
@BfVPCFn^fE^]jg74`dGb?4:]n4MLq:T?63C4Pg^3JZ]P`=Y:8<FiR9K^5@lRKMk
@g9mD]HTU7jjpXZJU:=@?5;cj[29J@HjdQRNnBBNSS8gE:0Z6qD0W_hYPX7J7Cm0
M_PO[H<1m6dZI2\Uo7]6kMCWCL7b_UJUiTS5\Z9CqoS3SlmiOC1IOi=m4o<>@0Z?
^3:CeTh`Eb9O<pi^f>1\DC\_c_SeOWY?9q>iZXg_>5af[@:fSRSD6JK>CHU?Q8BW
J[`G:bZcdBT@OKI6VZq2\5dDV=h>EdO170eBK_MC:VZJhkK\Uf4TojWV_C0I51pY
Pl1F1^En:J3g1Ke\56[kLP?HZ8Wk95cdDO8_T\a1SpK2AlQ[jO=R2TaaiYN6DXX[
Q>]5_;nWLJ[fhCec^pB;XJD^5ACDGTSYFWIEl?IQiDmb4Si_2FP55Ie]1\eV13[J
mp[OM6oT[mFJ;>U6GZH\V>cKOI0j<JNM:So?43YZg<=@KK^m<]qYhl?4FfkRQH=k
cYicmRjR=OAR4K2oc0YP0lWoVW>^YD9R1n_qhdUJ4F4Wg7TeRWj<jj7UhQC[lkG8
`<8`]BL_UgUl_;D^::VmZm1B^i0c:H4AiJiep=33[a`7h<6]?;N::[7[`gWlIV24
GU?:MB8j\oc=a3U9pXT@@eARcN:47RDh=PF^9MI5<3X2Ha4:`FL:qj:TP5AQP\gA
9n]X:9NK=dGGIChOMKI]2VDdhMk`aJSAlOFc5@S=Y:iH8F5TL^IEo9G>:[0O8YkJ
3S`a9fYfi[<GiK?RN8c2`l]4UY^a@^=Mg<LElM^q>ihZajYYK@0l@VR=dG2ZLL^P
j7>LPYbHn`O6imaPjQ;L18IV629od`57a]MPiTpXF16Ad1ndT?BNMnOLBRLTG^o_
=dM<fJaB3I\H59^WY<l=RG<jIEY?6n]6UTlLXDleiRF1SIc?POCiG\5:PA_W_^m4
2Xhg>EYO[=]cM?EJZK95L43ekqLLNCA?lQM?0E7aRCehS8LNEbS>G3[:hED=IZdQ
>aBGkDY5I;<<p?a;7jTKFRSKU4@>8gc@A_XY[H>gBBIDe??=L=j?cT]<<MmaKNGp
O?:AY_j1Q2IL<89W8WT673JO7[Zcc49To]nXh87HIVO[9PaE4lp2WaU:FLPOgUo4
lOS<29LOGWo^m5]`HBYX??lW4VL8jbqg5Kl0mYC]Jhe>D30S0QHi6je7ZSaYJ4dc
\omYV9_7U8qYgTgNf[VHIkD:78A:Xaoa4@P?>:NKjDbf<WEEWP>=j<U8>gG8f=Ya
_YNXliO9n<3e6JnCFA7l<601@5]An1?4V@5GcnBdZ>:GcmL803k?an2>VlgTMqh4
W5JGJ9]bFm7XVDfQ^\A[4nfOIVE1LdX]7i@m;Xi7joq1B=XP_2XV=HDclcloQdT7
Bi]e@^^RP_LWTL9qVhW]Xfij9YWU6RUQl@_kG6:\5Mk7_LKfokENhIOq1U2o>57c
ZXdLMX^7VT`he_DWkMU6`b\22og\57_oB6TTQoE19Y52fWLJF4^UTf3ONaOfdn<F
FHiNF0eMfk16ESDXIIlNCE\T[c@dkWXoFX_HbB9NKOq;b5TC0<ho7C7F18SQ1BKT
V<3<l4mgaYc4D4>V^[aJk^P:7g@4]V2UZKb4;XpMS:U?VkkT2nYh^i@hk<Ta?7Nd
6^7B3V_:]7]=^cbL3d66XLimkbQMkXn1@]p3gVM9E7c>\cOMjXfIbgH73>WnJG`j
=HQ`VJc^^a[`KUI6iSmE6hN[5bTp_m]oHNIA:K\Bce7kIeDn:eJOhl7JS:E[0jUi
IOU1SE74>gC0VnmDRdPdaN8iD\fLThNEAhUQ:2VnXIRcifojY0i9mhhoGb_[;43K
pKkF2X<6R9CXgIBC7]jg_O=jG57ienSXXQ>P\JG6qT>Dng?Po6glj1PO=]TBhiL\
A9mFb3RefVThXh]=i?B3qd_c@XCbAEMTO:?[N76[\Zi]TiMeFJCM480]_E6pX69j
K;IP>cfj8]BFcIhjkWS4gb0PjeHHO[j72mk8TOjp^HER2NOp<?LRo4ipPH<GhZSp
;6;Z;:h@2B__lMLW`JE3MK=[9kn<R=;e9kZq\[5LdcfL>7jfjKBg86AabJhQhKEX
C7mNe`4E^?_kBoq]bb<SR^19m^YoQc6ScP`Gb58@@3`dNfMe1Ff>1q<og[gC2WWo
>J`B]S?[XjHi<cmbdX[Pb04>?U7ck6MS=8b^pVl\U^ND\F]]6bIU4DHEF1LFKIT`
LLm[\JDZVHg::S9Jqkd9>;hhF8FN8_PhLhc2baNeXh`k`ZQFe3MbKMZ=a?DW_7RS
MWB\6NIJbIj1QZHO19]XpK[3`@>O:hRQ`Kd\Ln?KO[mjDimYT3KUag<dQF5;^^6>
0g5BHW6EfU^Yepgga:i`<<SNKlT4g[dgWaf<GCDWUbam8@GjPL<@gW[I7qlEMX2M
^`1OKkRT6K6BmE_BYAd?[9kG;nEAJJA6<EfDEJZCd@ha:qUcf\`bY^\@ikn3e0kd
YbBMkFUUNB0iaXe>fa^kmbqNCV@5T_7YE7F;\gJPPch^mU;8BacKIUn>SV\nYQbH
97AX_U=03QCC?aC[CBXm<WejEpL`VJ>Rcd31GdhoLKmMZW00eSZ6<:CA60dl@lGQ
_VS5hpd5[03IMK>F]Enmo<5JN[0fQm>ZaACQe1;2=@VbVN]OMgibpYKFGJZ<CU5Z
VPl9mDDCL;ElHZLac1f^J@ak3Sh4@A@bp\jGNG89If4[c8TH@n]ID\N:HoDI]M0\
\GAhIPcdAGI\<01PO4UgEj?hndCe\q[W2FbH7qJVa>bJ9FjV8RFF:hRc=hVh]@n_
4Q<`hHlSfckXV\70qEf3_Jiop:i\cRElmZL1J8074[U<MOGgJd0NNH6kVbCKqD\T
4QUgq^^6JEhZp]Ze5WJ\em1TZVKZCGRom:V9AND<_YIEHIa=B]BS6WXq7YRh>U8q
WeNR6iAlSJ3J3>;V6j0UniVBU6YH?g>Igo1m8LSJSJeRG5;A]RKjSL[<9ZJn`bWJ
5]DqaAoScgL6E4H03P1ioJPnABcGNR;0e:Q2;WD@??qKg;9;l4q>=[S>iBL6S_<5
lT2XaWc4ZjCk=>:=OR?Ab^QAJm1?6PHX9MR>Z;2>bJ>Ll:IU4qS]ZNH1e5KI>^ce
JII9HF]ajJJUGSd0Nj;?]Q^H\3`Ik<gm@@ni7]E00J1HSHijCp3@PXgFX`W3gTVf
0`kMHT_dcbQn]:\Qe]m<2I1KKNW]JpBEPA3VG\nJ\FPmK]?I7AaM^N]KafRFc6R3
Mq`]V4eS;L@WAYkCh[JfC@QGloh1Bi]91K^64f>dfXXkf8MH^YW1L;<e>7q[S^\`
7L@<AoFfH]8mK8OFHO>fkdIn82QfE\bb]o7h8fg6XfRIP=9<CElp@=h?@j]_6N@D
Ia9<Mhap=U\RHhNf=m[GDd]\MocR>X0bd0<5mg^h0BQKD[IKS1_03DlRO6qjeU4K
;Ca?VdBba`alilf]L]Za:_EXU5>YS@M>O2GcNfZi@Sc]eq:o0cK;OCHMOeM7RJIA
n:1j7nkAUFOFnFE0XhH?5j7Z4ViH5?I0pG7c>nRd?VEQOBJaJ=OVlDBli0KbCEeB
gDbkk;BE6:ZXpW4DafjkA33;:JW:JCP`2G>DN>RJ<HX6jm]WDMAomDaWiDWJlM4a
oGk7e8]1C@fmpk=ocBVlVLcIh=;>3S`E=RX\aeC@XbGU@WIU[o?[@H8jqH`@cmVI
G1EVn1TOjo0PV2h^<32AYgkdC74S3F4dYpW_AfNMcEBI@R2\@doXQ5pGFn[QNcqW
Fi[B6Qakn4D57CX`TbIQ1XCVG]Y\63^6OFn7gnVea[[VdKV;R19ik=XT83T\27dk
Gl1=kA4b9g=GmSf9n7iQHXJPSC@>LJ=9kS[7C>9]NWE960q@GN5P[]pE;8ah`V95
Lm[W1Kaa5e>pAJWB>VA<SkeMd5PF8C^6=Rgd9X=Woih]bPRb_FVZ[HnOCh8gb2qn
XU:1ObC^eii7kV7hP38pinCH@d5N:Ygh6LT``2PFqZAA1kiXEbebhT\\]2flCqKO
6IdnUpHj5QLIU^Q@\\cU8=kkULa?AjdCUJ?8Tce:ZdV8Z7Lj?Ph6F8@jVd2kYOeJ
Y6S?N2b8lakmGNRTR@[YLL@EZAP`AiSJl53?bE<8L0_8VbWDQ]_A]F:SVdgaK]P4
02EmqMlDU1O2qGTI_Ma4jpXdi\D[NJWB01f9N7REmgH\UQaV6hi?b5<kSP1jAOHY
ZnnX[8L9RCn>aRmIbLq_\^OY;Cpjk=adH?nKX:>5oX6T\G:IOk]bIU7F^2GTjf6U
Wm[l^Wa>_1A9L]CNbn\cUI275Qlo3jXnk`FO\bo=fRFUFZ:V?0QTh?\VBZ`f0]oF
UmfMW4X?c9XEJ:8N]A=n]N4kSQqbYmU[^5qPe<h<`=p[o0HUSV2g=BVMF5bY\QNb
8<3`B4]RGMqg\^0k<]iZ:7kDB>8blgI6Den?TpN@N0inF]m^>hl]CNf9eaFF7WGf
\>aOqYK\gmXaZ?JY8:I7\LN9CENRkK<BNc@q`GSadZ`J?mJ:d]mmRbMYiVbXX0[R
3\EjQmqP;C@?S:q?I[a;8`9I>gb@9:?_D\1:?[D72@LQV__feT]pX_QYWH;X]=3B
;;:YWo>9^?6K0ek6l2fYSEm@US\<0A;^QfWWf\[j`>0_iIUQV;QCHTpR^SJLSlpV
V<8ln:WpV@`21JQpdb@gLVRF]d=eK`gf\4W^7=U9m3Db5g5H4;:0q5A>eh3PaWVE
R>4B0K1@@aH0keh;\IM\1C3RMpQK?Do?;q]W:OFDXpNUHH0OAG?W_hmhPYF]m[Ze
gXcj?;53e]1MLbjSl4M_[HD?XQ[TXdjfadS3U=Y=fZp^@PK[0jqU:P1kEnqFMn6@
4OpIb0I:MKY3WSSojc4De^RMoa5T6HOWMbhWLGDRdG?3a\pcj=Sg<;10<iSC\>5G
NfJF8P=WaoHX2q<4oKAmCK?Z7UA]`?lXB;@:2kB47V;\k`=dfRaVq758VNU^4mJ3
LNGHZNamlB:?^h9W:KRbeL<cO^G<:qELXTGND?1PBIP375\MNE7\cna\F4gGL<kS
^TlNFUf@FLoKHcQ_WV[QL4p<c@D6JFi29k3<baSGF4iAWnDJQkYh=h8NiCYZgQl`
co_a@X_cg@G@cdCp@:ZjIoS\Uf8:d]cVTSg1T5Ki:MnnNU;=RRLOJX0[CCLbNAP[
4F^28SHR1EAHY5lBS_UpF4X6KR2=6@J_0^K@OAb`>QXjM\kai:JVD<2gSKG?6:6V
J9=bgLkE3X^KM;G\5P1:BTkqG_@lNeo0`SMmBngLAXhhBU>9=l7:bZbdagJ5lfR=
iAK1Kg`DL=UZ;VSSp8NP8b5P95_IKj:hd@EHcP<q1R_j9OF:G8F17Z;PTm`_O1X=
>XLSe9FCIQellS?7`C2HDW4eoO[QAY4HqIKgZ7\5qBoA44>a?:K`<4d>`K^NRkg9
`REMB<8U:AX;T<?FKRN01Z3mjq3cCdNED0Qe\k\BKlak:GZJ5I>Xl[m0YN@Hj1F0
N7N8B`hf\e8loqZ81LAbmTAeOKI84F[GiKfFHNkRi7U0\<4e9OLdpcg>\kDiqVDW
;e=[j\>K][\[IaUnjHW43kZh9XTS:4Hb@e3`Wk4ABPGb25YGMC7SK?<>8JVS5OYe
Km4LfhWF=O;19?cG4]94M_^o3Pe^8adQEO0jZ7Yjdf:FMA]pf9Y:=moq[a:o8<cO
8QC6cQP;HbOMc?C3`5MLKN0P^@=SP8WKV2\IlGe_WOnqX1Bc2L7p>T8W4U`D@HTa
9]C05\Jb=3iEEXoX?;2XN1j`TMSU\<23N43RpYVehnfN[F7GMjj5LLg=ClOjb<J:
hNm@6hG>3B8RXB;\?UkkC\1Vd9f:FqA[j<Y:Sp?6i\S7e:e5??KM8aHNaX55oIcL
fo?`7P5\1M?ihnbXK2L:7F?SPMAOO3YO\Idg>[hR;M\7hCn:T2qF6`C<D1pXjoB6
aLYNLHa>gcP2W2jLX@L;9?mp]6ibo=LmV>MbB]Uo>D3qSiXiW8M<?PH<HJDZZ^\[
MOK_nO@[qcZVl9E[qMm:G?4LXGE9D5n:KXh5020A`>>YbMDaaF7:Zai9c]59YI4T
<=HDmbI_Aff3H8PT<Z4a<0XRh5e9;2d;lF5^:P:qiT=ZK]aq1mkX8YD^iUm8M;B^
E29q:BeC:mGp@YCdnJ[\\c[;XnZIWhf\`=A86Z8V?c^8@Ue7YVZ6`Ha1=Dgm_@1i
AiHp;hlbn>JPW`[70nV_dUkA\9:j<b1?R0TcC8=e=4POXkk1MoHS55V1?G2\W8^:
]M9VMKNQ=DY2R6b<<off6`DEIIU\q1Gh;COEq8inQkJEMi@glkVm=9R@ql>lB``b
:1e6fgN:Jc8<eIm@C0>f3E18a[?8q5f[To`=q\^R@ehe[09hD`G<@@AZ9eVVmMKX
T5]OjFj[m4K:nWM^;LnSS@eDE^7J]CblRmR?3SJK55[<`E?0UX3Y4]ddemTY6q\J
6dFKlqUYcP@7l<pMSbC;fJpWKAGFaGE6`MD8EUYD?M_7;bTWHS?o;dI_lELFM2;o
5Zf5nH<KeCq^>Eb5k;p`i0JhH\qDNPTn@f0A[kIGQK>A`NV^>cjFk1_8d_8[`2Rd
C1FTNOa;opRa\=S3Wpi4L9UGn=N:Y64h=CP2XS9W:9_\^]5kgl5<j>nCeBAiP_LJ
Dq_3_YfaF9@I^<K=KlLjH3@g268FLJTkYJ3S_N9YD?k`MEq:f95UOMq9e_XD5GEo
HJ8::YDBCUiY;eO7>TEGhT^GA?h9618D8:g;Z`LWNH^;f6fTW3OZ2]H9c8pa041k
oJqaZel?lgq1Ao6S0Wq:5\=ac@1OMWaST4NK>inHhofcag[B\AHdLg0L=TY<Qa>i
>Z7?dP2[WpK`P;f>9pFgPKiedflN6HCBHen=mHKC:nJbjA1[8;HaVWYBO2PG6[>e
>pJ6n@B^=]6feY`?=6cmqgZ5Y;[HpS?BIjDG9gLc_`ii?6TNGVTKbJ1GYdT1[74`
4SM]bN4M^g4GP3_N:j8aQLA53HMgJ<h^PKCpoPIZbXopS45l2LfqBZ3YHn0p:h:=
B>eKV]W4bk6MZf7;W1XkQn`3cPlhUFMU25S7jd`W57K2hEFi`KEp9Z^XJ][qfER:
;8b3fBQ5]:2P]E^]k[ACHC9A]mWimb3E<SQ[YL8P8lIpnIVEWKSpdkRo]cl\ffI?
PPeQOXLMEIS:RJajoJN<@M7Zej8\FYYEq1``cJP>9m33[B`iGA5ATR44;03cAKM]
b[WUj=OXQZH?1_BVB9QUfci[9IPOU8cC3WVA?7R>0pJeG^[UaqE>WJlkeqV:EkX6
]pk<H4cX1LjeGEX2\E:Vd50^=`Mjf8eWeQVR7S?E8OInXVf\1em;RlC40bqFJbHo
=jf3FF@h;BAVIekJ@@ckXKV`;n4Un;4q\B`]@84pM_WEeGYTkTaPbLcJ=]oK6JQ0
>5?EVbFk<TO14mmaEh3D]5fpA`454ObqIQX:AG71bkCogfdK\R0SK98=5\`K=iLn
H1_iWMD^32>5J00cbdD^^kalZ_aX0[hcXN^@33oVqTdOeUkIpX<IZc`fqgL_X0oJ
p8g@n4DmebI^Mm;`?o7?q1I4Nl<@a`Mhl_]?4VlHBX^fCJbFJOKa6B:@H]m?@@42
oaO=oAOB`1<A?q=QNdi^dpMFP<jiEK<B9An:_o_2^ck0jPY7g]pGkg=8jcfLFceT
W?\Yb7q2CFiVVGpTd5JF\\7a\^8k;fncKJSln[TPL_aj2dU7=iSJnMRDf_A2LW@I
m3Fbl9BKVAZX4GN_WNkl;fY3V1[GHch<6oFg6`0q=blF@bUV33h>@6pP9V<B9<po
K[`RPfIMFKWD3B^IHGq3c?BK;3qT6O89b>mHXonAk[4@8=]=?GP8YB??J`DYeD?H
;J<Y_0O<8_J<biRaHZS`dXHdQHQaLj`RLSQE_[UIHZI``3=`ESGpcI585Sip5maF
DU6@JD?_n19<WbCp2hI5fZBpPV[Aj8goFIJOQP7DnC5e_d]\n992FA3ag4@dLSmD
jPQ`cdg@WGXgFOkcl=ZnVPIDkG;dcjjH;Ti_Ao:>NYgi\>p1R>mj[JpHdLg9];CJ
C=AiBJp_G0[Dh`Np=QZaT`mpo]k5EeMpjg;mPjmqV44b6iJqRQhJC_VUTYb]W_QM
kiSSdkC@elj_Vh3=J^b5VP]TE;oC=X_8QlOpXe3l[9UqHX71TUXp54laS;:Mg7Y8
0I]l5Xmh7;@bJ<POWIX;Q5SN3hiY[AoiSgAlma70oMcV`gf^8b89nce^NgJHTnI>
T`@P;lf?71JI@gV?A42fkl7hG2Ti1Q=>3g45E:UQ=B0c?Z0]BRZTKZm3Cf0<1513
d11DC1KMpYFh>JMI?<GTf^miFM9HR<Nkbf;6c>giik_TD^j6T4[nI:F7eW<n0;R3
abApjeDo@_3ZSO0NFLb[?]]Iefe<C4?7;gKB[Z]KVOHHL^kHeaA9Nn]@@65e`YXJ
fjO9hOA5kGok3S\hU6BcnY6Ue_GnlQa?JdY5gVE=QYAC_Y0feCj0X8P?fl?apgb9
U[gJL2ATZW<OYCXJh@WLk?43aYc>q7Ang3jB>VXGL@bS6O^_KYBcKY3L2GHbACHP
mb8Gj<=pNJ5PYj<3Ub1Tn`@]]IX7m_e1h;_J>\eIIf_5f>amgFV>1L1DF7qLQn8`
D?Jg=ka0G0N=YBCC5^>i0n<]9h9EPp]7o0GfTS=UH;akLa8FMYZ=[CNY`Q`H9Ki9
q__8T6TP@D<iQD5T4AOB>k?HEhi8ggDbahLiH]a:ll@kOjRhpk:<TnHYmeT;GeX6
YB_f:6m[GAN>B`X56dIe^<ce\T5HFjh_GSFK`93UFVDYgE`:W^Ln17YV3>\X]]Bl
B:Z85abIYa;SQ\bU`>jF5QMe0cZY8LnbMS9EAYmWmQPecH`Y@9P1p=[<@:KMS_;2
HeP@9MJMM`mD62O\;=<@_7;31N8o5TH;EmLjI4_1\aIEJ0YHAFR2nbfnJT\e9Zg5
7U@HlP66FVeTgP;QeFZ6d[WLO0_TRSApnXYj2hK\E`H=oEbD:n@Ze=^^Yhl;?XJX
62hceI<\Y1>`32h38EAS3e_fkEZlETaE7Qk76@iC0UQ`I9:a5V\G?f[EY@]B;U3@
4>NObEbQcIqhgbj;4ggg86Bl425R0qcHcPi4Ha3_QHLk28:C85cc7jbAC6_aYHoH
FN1dBIWCja^edhR1=ekd4<ZhQQ95fI=>]1QN\\Di0ZX?IP2Ch;ZHYZf\9C_VnEO6
AFUf5b@@q29nU7_ZB3PZUo^haC214qcX`WTfGNYYmoebUA4BgXa^fd7ATi2gLEIH
n]Fd:83Sd7U5mGO\`<4DOGg2VD^@jXM:bB5HGQohDeA;e1ji?DVdpWHOR6`O;[MR
<:7]_5Xgmnc=gbl=L^kB8[FR6m?bcb0`6m<eF>mEkHM^O2m4a:0PM;Z`PQb0G@Yd
J\5MJ`0kQbak=@FMbgPIGMfaP]Xo2bjT`ZaA\ckAG9BfmMPek]hqjW49JO=P]?<g
mXRjIWlQ6biK^1J7lL2:L?m[gkOoZC@M]WUW1G^T8Xe>WdIe^c7FjZ;>cVBE4XDd
[1nR9<P@@acWmB5akmX7[`h^ggWReHG_\A=n?mKLN2\kFjS85>F9B0<ZGINSN1DO
XN^VVhh_=KA:Y15SVJ0EekT<IFJc[1K[p9jIUSTXoLl>NB:C1J4aUD]3M]Jm<bc9
jgYS_fi`n?5^c5cUej]SMd_hN9c8OJ]fGmjCl?XqXl?\h:WCM1hbg7ZUn0^T^<>2
Q=5@YSOV73Ehb7aW<B@Wn3=Y78;eT0n\>a4=HNaB?kh;;Pok`X2D_Y5Q5Sf5c685
LYE<hEj]O_8gbP`NBf34HJV7]_UB<`4SnMZXn`ZK[OJ0>:4T0GXDKaG9Emn94j]S
lMR?OEi_ZgKQTA^Yp4DTHNH=ng>SO4`1?:Q1J9ASA1cRen>EXd_19U4Z<WkGGdeF
H;nJ@FEmZDZV91]8H^1\=AfRldAI0\H2dWEM[Ob6a]hDBh6Z:4Pf7bl9Ek=@qiP7
Hd8h1ZdTiN?n3H=j2QOn6>bX0?l\jJW<Khf0abYjo=F>oe7gA=IhX]Wg?bR@ZpJ4
ol=^mmV`gFBZ7;l5PV7^[Z@NG>9IBR18YcDSFpUl]C\g`C<FQI<E`h;aQP;7:]7S
HPjDlcI2EK8Ge>ib9^<mGbT3nlR=7PCl7gHY;p3YidO0F@eL5TA@4FScV<4I@mFZ
n6K0ON::fdW?^;2CgMSFIHDfR3qYfN0og3e1n8FT7Sfc\YX^Kl8X]2e;R6b7XiXP
A6=foJc\Hih3NqR>fA5JG3L66G3QW_]2E\R8mc[7?Y5J=;B`HPKaNTSX[:kmU`6K
@Qq[XTDBA@g1l`LL6]hdSK84oJ7CKE;EFmSAI1pNR;[GCIP772YSRhiYTBiCGE>a
X`gi4KnhN`i5dY7Q_R>]lJ`^5?\@J3CVLY3?C?2?FZ:CAYM7X;F@n9pG:i;<>RZ<
6bH>jPZFe3230Zl03H4o=c^X007V6[DG@6Q9C:[PbD=6:`AVe6[:\<j\=S0GXFgf
:2MSKY40SIXSORpBn2g8Ec5QdfNjQfZiUQ5jKX\D08jXMbUf<k:NNDGT8;VJZGG?
OK]4=[4FbNLI7^1lQ[;j;V:cHeg3ZKkaU[QZ=YpaQ=h;<gOMD3f2Z[g8mAlhV2h<
LGMddNDYQ^A94p>lna^`d<VcC:lA1EnXK^dTA1C70_Bl5?1Af2^Cn`kgJohmQR9=
2Ho=1[=H0mI[2B1=2:8UYSVaW71bRbCRR>chWfb<?_PgfJcF[nE\bOD6j2M@OA8X
6Pk`B=2^95^\7K;FkA:^^j8[aE5odgbC>7Dg2;K5MJGWC\eGfeieVZq_b<WaN65b
c>QPTHM1dE1A<iFI2\?5NMg_`MTP=ENBf;W_Ee=lUmKf<\?fPqeNeHm6iWVZ=7FQ
G0S0\GPemWSDUg?QWdZc_cm\?8m<YJ9[?MR`mE51d9g^@n`KYV@89ip=1E;T1IX[
e5goBnJ41OT]11Gb9A94OZDX33KmIG7FFD29QdYe=eh<[K7ESkAgFPJACXT4cYLf
aHBIZ708:>m]eLB2IbZ02RoTTUjAg5XW^5>]T\@pPRU>8\aEFDNK@@SC4>h7hf]D
:j5`;S<M=geM?KLn`KPc9@IQc>f?L;E]jYAXmYp>CM:nZLC>fba^MbIZY1:?Z`Fm
;5Gc4X>\O?9HYMaMQ\8HY]FER>kCZf3OZ@CFT<L>kW8QcpT8iSd1ACW5Y?P`j_G=
6FW?cU:;ochb3eLg84Rfo4Jk@7M6m[KR1D8SoKMEb9Vcn>Q\iVMkJV158fKo;APo
7kBDmBj>I1HM_SK\1Wo3JnIRqiX][6G5XAYU^niEM332LAVU=X8NgaJaP\cfL;dA
4_`[7CX7ka1BL:;=p>A16AG]bGbGSf=Q1D<\RjUOB3?I=`aVGH1<LVUgX[OcNEYQ
X1^Snbg4pj@lgKNDOcVBW9MX1@mQ98IJobe3AcQ9SWU@>V9bmS5YdN0gb\98[Ra9
FIgPjkW=lRdjmm1po0][c9Ab=E8<N:HVgHbAggY0WkLJ>1mY26XkVOgmY>4Aj2VB
OW_[n47X7bl5En:>UNadmZ;[L=^2Y?9;M7HN[MHIkR`V]b=la0OX=^]GnU3Fh<EX
=2W@PD4@\WBq>A7[O^DYOF^NleTb>8XfPICNU[;p[3Xc9HdjUI^h8c]S0KU2H_`^
8;06]]D]MC?33[_N_Wf74G;=PNjVg;8\GVQO@E[5jePbKGD5>iK2a>cDElX`0?U0
Ad?Co<h7UWe]0DMl47[[65=Ldg5ke9TN><2f_Hb>[Y;Lh>pbbeQ\Y0Q@>g>4?0B2
mq;R=[>]1dfbA4=9I7PFWDBl=5F^CH>:\78g0DGlQb::fT>RW]1Fng1TP6@;QoCh
;>[U1CoLXBfcWK<XX]GL3DD^mVJHZZD1]@[RESDe;gWKln>]B@H^HoR6HVlYQ>kO
5M:oT4JjbgbP5h4Wp?3NP37KL1[QZE?3Ze]HcQmdMW^>`68]5GRQ3?E\<J6<gG2L
[8@SOBnh>`9kV4FRb^kNa96Wqd6RIgni9Y5[_3TdcEC0SgWQf2FCEn_\BmM@2Ghm
ef5<;=OVUQ<cd1PG8X\5?1OZodmEOiCfZNm0nf;K5=]d@T>YQ8M7>o<IKo0dA95S
anLQpkX1`G4SHnI9Q7Q?0DXeoeQ>o17nlZ1JK<LL4Km:MBS:Y>JgQQW8DHHpX[jG
mVnbfEPgn[Wl^6mPmjQng1Z8M=SbiIdU1\=\jCd;BZ3Mdf3\jEY5a`T9E\5c^?0m
LC@7DZoAk`PRe^:m:SbTneE1h[IeN061^_[Z^`RV_31?>X=baj:MGCT?D]?dpi`8
U>0Ril2l8Da;HNBCA_9cbGmp4k7Sa?[4Xf;bkJJBlR:_>MfYjl5;X6NkSkle:oKa
I_mP5No<NBDC[W`m=mJK@91TM8NjJhOPRjWcQhXPbg6bbbh>F1LfdoW5]\\D`n0D
UW1oGF>?9f3Wo5;H=m4Z?YWY5]7<A[NopM1ijH2gV?^<eXX`;[Qj=036LU7<?Bhq
^c`RhEPC2ERNF8d]PQ4`<46NGl\b?=]>PgeRUHIKY:BX6]2oodQCg5k6nieP5h<Q
RY:JT=CVSPHohjkQg44`gYZ97lf5KP^oS5d0OS9PXP7ao75B2RN_1<8^]J2G3bUa
07kPI^S3947b4]UEHn1<]oAkQk3?qUQbTj_;N6YH>_C]1Ehdb41@W59\hOefMC_R
?05]V`hA7iVJaZ;WlnS`\o1FNA^pMijbK03HoN;ldI63qEU:_JU;n3\CT5oekZL^
U\5FRL08pg]UaaN7EM9jPXYVMR888:nF6;GaTQV>MA<2?ZSDXMH_FL^bjcGd:LmN
i@ebpIc_MYcIiFgM=7[bJSaD<PG<@_]7KL5YfBm6Xm`@:fX<5\0alc>VAQc>?9R8
e\\K_=:`<:X=7120=>]ZM1h4]>^Afk5G8oRUFHB>J6P[fNFMND_4DP<I:GCTPpaE
FACP[Z=jjCJA[iQ6qNHb1o8CUdfnG^eMDSPQIH`>4KU0hdg8]i4OTMga?<=]@=j2
1enkRV:KV5JH`B><\d`q[jZd4n_[eD\_0PJ_5b[g@3emLoO=NX;Oj]N:f\kGGIRH
RoWm=mPF`apN\G7g8fFPdnB_9mB>UQ`4WZ]OVJYo76\R_1Th7I[]G6Ug?AmET1MF
SF7>DeY`^C`OejU9WoE\1X:><E0UEU1X;S]I0_dO?`2=YjFcY\SUm7bkhe>oB@Go
eR2=Z:c38b01XfKcF<B7`D]P9U<ZZQ4i?=T0>A<>J=pm6@1RWOn[khQK7O1e7Ri2
T_;?;=ZaZ0Y>;S@EHO7?dD5<B?g6ARNIE2K_U2YiK>=OYYP6V\4Z]W3Y[WAFg?V@
Z=Fpd?4<CL]S^\lY\U;UgP9:dN^T4G9Pj`Hl^^ea^^Ya?X0>^;RkJfeeLOk0bLaE
hE5DR<[gf8=aY_[LPg_j`U^pL`:F`@8:laGgSc=p@\KJ1eD>LCFoRMfWnFeTQLZ3
>bkSD^Na1EDIP8Dan[RL@8cWn`eb4EcP<ijlfmDb@\bC9j;`BC=Vgdd[d_PfN\B>
JncYDWihgEdjaAAFJBlDc_c]2Y@1iAjM7o3RVoQ[6ICR<MJaeCicdk_C>Fo[cDbp
kHAY3l\``i1aoKgAX<HKQN6EE5DUgBi@kkf\CE<1liDhJM^A9RZpd`T>BOm81DK1
Wg:3UAI@=BT<N1L8nNgK:b2l<KCM1Gae16_CK7@120o_Nde5qIo?1_^1QK_lUHnT
PJ7elIn5]69EpE@^Oe2]h9AaCSTHNQdcZ[5Cn7BH_\P>jWWd701WQ8MQAW2GMn1M
T<VE:]gU8[c3pg]i@CE:]S4\Wi0:338jP3h1g6RNUi9EaMk^gUKb4SFCF45EGp]9
i:S5Umb`o`hnW`dKEEa]f2D:bf2XcY8W_d]VY?4j>OM=p`@Ck0P`03W8coHTA;LG
j02KB7M1HRU0[EP_5;bG]_e0`?B\Bg:Eqa:?e;cX8BcV2ZYOXNH\f\_TNU4lZXD`
Q`hpkOQPANii[JbmiL?42Xe=gNa8d<a<5U=lON5FOkE]8mD:oGV`qEVIj`@lkIOF
0<22Fc[3Xic853?0QdW0[oj:d4FR;eU<2o?GjD@9MKZm:]9oo2K6jAVAg;;[VXQ<
Hn<I>Unm]pjdP`5o6_n=:^]8>NgFWh:2>7<[O1Y8MP;\PAhL9`Ul;k1k>a[a5V=j
k]>^@:I4O7?Vp;^VSHj:AXVd]1hnCe494:lin>cNH1?d4<ce<MBl`R>76Q`j^Ymc
8VDH?pN3\VLWeUl`<?E<\IJ4WohVg7BCChdL3:W^>n\HcQQA21?PIo7<q3<VOg>D
9M_Vf?_T]6b>MnMe^K`TBh@1ES8RIPL5=nV7k4giqGEjng4VnG]GhdgnWC[Q?i]f
SiZm^RDE>IaARed[@U><HnBn]NGpOokPcj9mfQ9hIXi`3FQ8oI^Vb?V0iT[LX]2K
[6mZEnEi88[pFZMSWU^?A7lHn^F:9=FLNSiYo4oVE>YH_DYj?PgTJm?SK6>Y5:C\
mA;<72=G6::?BmKK?7CplgA7JM^`Fi<W8c4VKD@FIb]lNGBB]OHN>CFdecG5F=H6
b8WmTglUnATpj\kCCAR3SD<i6e69<=o^^6G_VWTb_L:4dGIH<ZbPkNU>OHNRgPEb
Nl6>I=0LAVZ6oW^NgNf1=mp]fEk9SIWFZk\6lQKk>YiX;JiWW:o;j34j7M[3Z56H
:Xa2c1V;M:WqJNT7e`>Th=c]W;F0oD:elgo_U^T6NOCdK^6^8WCCJC^R<eZW_XXi
q66dC882H:YkH5BmMPHN9KR04:6gT0C@Da`TM\D_I>;=PLMO?_U12pJ?5fD`;0HV
3\;baFDm9G]=fS878\\L:Ak:GL3ZaQaHGLjIFh>f?9bTY^eYoiRonaSUho;?K<d@
6ebk0CHmED]nFbJ_M_]YqaBPAe7JYP@G<6\]\0bDEFkqdb<dhb:]1BM<<VU3>2[i
LYN0eXi:?;96h[HTGlWfbBI1<N]Z3`?BG`j^T\i9mI_gd0`H[L^BCBM_F8;9g_N0
5n>=?^>pS4Ic<4obmS_TPJ2A`M:Oq0QIYV\3LnLK95b2Fcf]Q462Q5k\G8>VW>JX
g_FjaV:6iEF6Nqng<;0kMHUH]251TE85PYJ0Mbn_J:V>ngO0T7c6bJE4O\=5Hoa@
PEC33gki;SGU^khmH@mlI_hc3YS?NXHL:p2W;K2V4m0DJIoUWZSJpkk9Xco0f<nD
hPNkM?=>fK:O7GZ^VNOkOa]3;I3XQH>0dN18[goRmC`7EeFo6;9_CD9_RT33WkH<
a9_2opI>]@fKRMS[YbkJQi?mqNPf7:]FRV<\idBSNE:XJ_Ua19SJXeZ:n_;l2[`B
BBgEQJe^khPf<KNSY[KHdb2KX9>;3k^mfN6ScILd>]\0PZLL]EDR`?EX1N3RDpIP
^\W[EB3ZZ[d4EjbM^P8;`jPA[qO;@E7SCi=[0gAQ[p8F2=NU]5<4^5^6CdneEgcA
VUK?ZO4SYV9b9O87KdNWkl][c<5O_UMBijdfXGWhX;8I29B<NFXSW6U\cGVAV9XS
4Vj`I[4RFcY79JeJ[dp3GYZHR5@@1A`=PNhQiJoEZOVTnCHpPP9YE:_]3RAFH7]H
1?UVhI9mOVjDaDD3j8oK`C?f^oFb[mMbFYV^kN5RlaOqf1CCm38dgbaOho;C?30Z
1@Qo4b3K3<CaEDE<B`efY=<oL>00kCiAhJmSXmBIIkk7i3\>B^fBNcYDiZi[?3AZ
MYWq8QDI0F`C\k<LY\4B7H9Tj<<ITVXf=h=S;<l6E=0T[QIdnUfTY_7dRVYHO@[c
eYVc>9oG]:qS2@a@Cbk4P\c`IQi7DICMmS>e72I5]]7:3YSd0>mAC3`8`cSoHhL=
@6U:Fg]]hPqjf6N;bmbgcnjOl_0>`p`VM]a]2l^E_NKC1@>?I[ijSe_VlS@^MV[`
f:Q=UE3JWkKldR:?=KcQ0oUdn<fDmZ1JMhce<daG_h8cDMAjoI2MN7JF<p557fLD
>B_VA?j^SH^h=AR]J2jAb1M;R?bMKA:D?C48YLB7VmNhmF;Ta`IZE8Ol_=?67WWc
^Y>loTjK@n@GIY4a11gOQFgidiNA;Kn6qmD:TPHYG]EF]V_E\Wcq>KP^7?aA;bHm
YU@`QKB^ikiAPH3eINm6RIA;LNSM6ERV30jog\I_;FUo?[h_:IBO^EPM9OTGIMH>
5\Tm^bX6oV@2iYcq3WXUk0IWFmT3GH;bPAaXQ0K7C>5TX4NKF>P@6U<HO9a[I\bI
o2cU??DTWiH;anbJ4KXlbC5W78QmGUWHoj4O6b3_I;hZgeb6eMO5[6pc[ZCNkXLC
g7kUIQ@eRqSFokV?FUPH>THN=ccO6fad4:fJ8DjcaeC<[XLi[?`8h`>6O;52NV6B
onqG?Ijj`Mn\Z2>OfT017hOXj;UO\:G<JdKj_0^qY3USS@ceAlj:MR^6E;P;9dd>
L4>6n4\01fOPi^\JFDJYmC4@NopoI7gYYWk1nmZJ^d^iPoIUIV_W>JKTKi13c:V7
m]73TWV9]9KdK9lj>;HXah5=QY9VD8hjj2;iFRQ^G<KWR]6CSV@[44P:eKnIWDXh
l1ZQB70D=69??cUEI^_p739b4lJ9eR9Tbhmh4ZpT[=I0WkVo^iZ6YaTY3:RaKY?8
=2<1a53oi1EHFPL55L]Zca<]Ml[pnT;3?7Gh4O2DZ5bf;6AeVKA:fWSg67Q7=IO1
8SZNFR`BUkMjJedP2<DY<T^f7]Kl_E56AHLFRcIlQQLC3m]^9`X5p8g_DZBOJQ?@
ChFQnG5>G\SZfCMlXlY<Q4]<V9RTJ2L3JS83TQ220XBQ892n\Afaa8NgjXnqBQB>
b88g=3Q?[l;5SD9;S<O=M\4cCTX:GQQ6^bKhTYiVeWT8]EYQFPokGEp5S@GeZl1W
lmjHE@fY=DWU9IoY8E?8b7`UYm9:o;6l]gkAKa8U93h<Ymp\2oe7]h8d9:E8CV?l
b837Kdh3edIA39PJJCC@?KL1iL=:=Wb;4;Q\Kd8`<pG=02T6Je^K]RmkOBHK\8Mi
NY=dH3SbRh@lo>LcNA:AdTlKGqR;h<G>T]:=2ad_93VTf[;RIR?JBR:j497DZLRL
ACPeCTb7]=0P=U9V^q>hV<?G7^V8bf3MaPoU1SEMjE@[E4Mi`Uo?Kkl\iRO1;9jD
[eaC1<PYF_[SUUEGO<Db9mHSGZE@LYYlVq;oZG`>3i37fRN2@Hh4`X8\@o__h1P4
YXZ7;]je3S^Jg2^2hdD2VZ=3Z3H8_KeSL\b=@;o7R2XUPRHb\aD`pXk^GbB>4ad;
7<HLediekP\^H2^g7?G^bjfY5Mal?>`9UFP];<E>WEQ;N5k;@1bc9XM3B3WGNUnJ
H9`c]WLFeC2U2P8aURenObhL2FcVQ>Dlko;J57ZgAEPTHGdpJ12W\0hB34TU>II]
<Jq9^U[5>E[PeM;GL^4ei>VQ:MJ1:To5S^[\dYEf;ljnmIllTnmccRb64IR:Xmo7
YiT9l8[o[0kX335P8;^[ChfF[3bCX[87aGJUBY2``KDn6a3<[HiP9_[6?]h7dpYo
Zn3B?Bg;?Bn72bcmq^NKCW9BSKHcAUY=`c5f@:`f2LJRS[3FR01ZW8<FCKeLl>f>
m7fmb9:KMqiT^>aKM:<PDJ_Zo:1C5Ln>3B[8Yc^4_?<Y\eUb5PLW8L<@=2AGb[lA
qoZ;^jSK9X]kJBQ;YmfL?fXU?APcp`igHWHMB70]ON1;\3DAW2OO3H`NFEi8jO10
a0Y0gDEG8\D4@JfDoPhmgqg\jK:^34jYLQbgXBYdO?6cONC^4hCA3@<T210kgDP[
mUFWaMbDGd7JqEK1acalg>B\NgMj\cYh0L2:W]DU>jOEn8UYjgje2[@;lJN<ePLl
=]LUgRYYaJA0p5XgL;nm;jmVeok9Z8RG37=7YacQYi;b0S6:]h>oZW02e@b7f7=5
_QO36Y]?hYAF>biAq>6^i>o[o@:KjAoB`ShLH`=8H3_@B8AIKc[QUhK33LfAd@_=
GRiJ_0h11C:\j697=>F2@9D99A=OdKVhROW:EH`\NFkPnc<4F;UQ8`A_ML3\hA7Y
Xi5ig9i27p`=80;N@gaZF5L?Pi?B\W\ck3\2jHkEFlC@0jbc?V8c?J__L[RSD5Fa
Kd1k0A<hUMZEaN;IpZ1:H<`eE`Gf9XI;m<Jq`B4L3?iC1<jC5o62GUZ6gb;26idk
KK1:Ig:D\ooSF70JRo;BjU6`l^aAUhO4dJik`VM\2ZQ7kI];JcZc]Vi8WWPLeJiZ
SaNmZ\LCSE9HFg[JAM]3V4=\US;9qJX:f56iB>\:J43[KYCq`dG<e`fZIm0;_eFn
K[g>S1fnEk1\4bB3\V5PTG6`g9c6k[l7YdT0c1A7lKE7X:UocM@XiKEfn`683eC;
gV7b]k162HXE2b:UJ>p77JLFkIeE@?l]Oij[QQ@HT3MDHG\WAE::1qJlC<CBUGfm
ChkR<a4SnFRNEAB;_Ha3S=nK2`6LEmEI0M[jRM`HXqg?1igXeK_ZN=QEK>4H9fOP
;oLI<Voe?NmTbMoJYb:N\og2>LB<>;AeQ=h<emBA8:hc2eAOVq[FXELP?@:i6RCo
mW?3ob4k::28B5FW701TQXBFC`cQnjN4bjkiHR0[iYkjjJ@Phno:<iLXki[XC3GS
[qD>d[nPQ7QK;YEC3j6lUVI\m5fe:9`7h05bGEFE>ON]bqUBGeWS9qAZ4k<8B;ZY
:47^VDI@E<?a@:Pd_E]`KmBoC_DJGV8B\fQA5O6FLBiP:j[\;kLk1IARWlVZbUod
YE7_F?B5l6=:?afn[D^e``^FFSOJUToPT[GYoqQ^5fRVOSQ0?6e7o`lVC]GJl6Dg
1M?lXHQW2DN86bTn@^K2<i8n7Dm]8B8gGg5a4[FgS^_a1gR[q2H5eAJcfiQCX\IN
Y@P^SI4I>kCo5Z;LHE5OAKjLIMSi8gnD5jmF3b6?Lo8Ok]JRcl3F`ZE]Pe:g_M3;
E;J1:i=PmAUm715\0d4ol^E_ILaW\R152R;L_D50c>]:X\FAb2FmKjK\EhVb5E3;
e0F^JjWE37A@f8nCjl;=m>ZdC1cfk4aCcL`@M>Yi\?eoq\E\m4:Rq_gZF_LBcSW2
E`^lT1k3DX<]W0MImMeNBi:B]IX=CD;7meZ<J?EY>Wic5[]S5NUi@5L]CkU:g`3A
b^48@oiIm^gaU95\^\4p@0f:=me8H2m00:bQlN5i4nO0I0cM\<HTbKLPpgf=\99X
n?EC4NM@mSHOOoddgNHL]2Hk\A]So8S0IBFZLA]5T>JnJDHjVaj[hOYJZEf?3I:1
Qk>KEUL:KLXe^7HB]jYp:=:CiLgdjL>>\UYMKagT1cRmH]kALh1[M:?4i^KIlN[\
cUn@]E?3hK@g^?D4]j5WC[OkFagYm0?Hf:mkqI9m<2B=pgbZlR92U5?N0J7e4V5e
;00ZV64d6Lam@SSg2RnOT\R?<03fZQm>bT5n\cPoK5afh@h1ebnh32UJYER41f3o
?XRGpXAB`NMgC3\Rg9cZPpW8Q<4KL5QdN3Rid5V<]C6mC0Cm?iU8>;G`i:6JVHf?
Z^ZCgHW?D0DHdi\bnAoaZPW5g33cE1_^YC4\il_X\JkmC0hB?15mh_G^KY0oF\b5
XGfAgg?Wj5_=DX5e?bEiWJi`4eQRQ=omOIIOQ<VF@]@mD:Niljk3>BXEm[17SXnB
OEf@Tl7Jpj4YGa]QLNK650IR\O\k?EQl5f;I9=nYEPGRFjmdC[QlMO61[lE;87E:
5`i1N3:Se0O16@DMFbK70;`3>onIp8>NKd>VpH4@1@h7q9P\^l:DqSDo?7eYGi]S
X=fKL8igVcZUM<AMm]doRlQjlNfJE?Z@fQ1=Y@\P:FbWO_C:\Q]=?SJG_q9Wd1F<
DdSb4gn85m[JUV4U?BoYkPMFgM^2;e=M6X;9`LC]XjCYSWg4<JXX2`[b7h`CP65A
mLMj5np9`DIg1BVG4LmC_jU2CV3OB5m;hT1gdUMHcDc`2F5i1E?;XXJ8c\81:IS=
3]1G4BW6>XBQ`ZA2fb\Kk`Aqb[37gSdgXT]>F??eXjn<R:JfEkR\ZNBW6S3`TKVd
a=E<\d=VDb`5?_W;9FbY8;RgB9iH?E<cMe1De8qaojG0QlB5b@Mh[lDO=Wc;n]_K
RTiYa\^O9N@YW7imZdn@1qC[Q?9?>qoXNW<Yb]A07jX<iPLk4Y=ddg8AfM[LWZ`P
2KiLXWk7^oPmEg5BSVS\_i6I\A?c?JWOK2UZoVSo6:7RLAVI26UXepTW=Ij;Cq6i
7A`?d:aQml^RKb]jmRjZ;RUgf1E>3>CI^kpFPiLj4hpPn[BAZKpP:O_CKg8DM_4l
NWI2BQ22Mm;2K>Vha@YdSKE4HYL8CCA3Cgd:Z7j5==aAYPGB<JZa@RkK1?L\>[YT
HZ?p0E@Z>8:pMP1^Km`pBZ;N_Mg`oW3Lg`W?F5aF<Q6<;BADklHla9OAa?>bNa0T
0N6nXWL<_k`0MHN_M1QbA\79l9R9k]3]g`W?F5aF<Q6<;BADklHla9OALj17pR>K
EHRL8XNj59m;TlFo:L;?G^nYAPO]Z7]>N8fn437OiC04:eZ7L<KbQ<7MYL4g=ma]
VhGq7mKe9:6;96i1P^nj3jRM]RJXZjQb;;\38i8=m4qfG5VoK5D=:Y?49Ye@Q40=
=j?ReLAQTp9jIUcURbegAk]mTYG:lm7kIT^\f>Tk[^HGd<ko=7CflGML5fKc_0S]
SdFJDOM5]O2P5KMkAC0IHXV24;7i:]j\HhfGK1^T[H7`aJfTSkKc]AAM3nIRhD9>
]CRM<\b_FBN]8?JQk`Hl>45ZTNNY[eql^I\WFXO_\0eCgH2=7F>^TmUl4k4Q6UCn
:6hJOn^c7=YX0MnQ6f`SL9EZBh]4WRI319Uef<5R[?l9:1>_mQT632W>XPS@:8;P
ojfib4B?6fe?Jd?`4ASY=:F39NAh:I:`lBfJa]VmMcDpFdGgHhbjPcDcA:Ybdmmd
U=\E<`V3W35??B9m2RFPf>F6]A?5n7HU<2B9KA1RT?f1ZMEQHW;5SYWaS0`JXKX?
>O@?l>9[4:MUIm6WJ8IhFD=gTW9iGZoYqYnNH4FCT8iOHP?=IjoAKX\>>Wc2\\6J
4YTA@PU=q]HN^\_?HB0lGC=]?ScmMN:GPjAPjI`ZIKCO8U9[ZRHfI;3NiZHR]]kN
LL>Sik[3>UP<9OAPZ]5Rk=oma764SB\FAPJWI:Nj5CDqWG8R?H^P3^3YUBLk@gN^
Ak?1`^1:Zn:n?Y>5UFC5]L_LdX2JM04KDV\e@ZV7G9iUmdGFBZ5pm]eeUR?1MBCX
U9iLcUEOkj=f8>RjZjM[<bl=RGfqG]?RLkZ@>>_@KMFe3i0Jl9n75U[iBnADj=B^
J@A[Y[EGca6\2K6[WZC8R7;T`^6>hnRM@bZ?Nb_MHO3G92:h2W6GENdYLjAf27Pa
i]8SNYq:4RkQNmj\mB`9OIYl:i[fY^]j?OD:9aIRNkl0ZD3=Yk<Q:kXZK`Kb@flf
QfeYA0bkjW\Kk;>5\?ph?06CaeFnl5cZGJ6XT;O2[KRSfNC35dgn0c5gMY]dfipH
_8W0`8AEWNj]4U5aS?ES6X@o1Z0H`L<P_T=igja:@1LkYM;Vg2RI1e4qE?`GCe\L
XBM63cEejJRB?ZCbiVb1d6Gab=l:PHR`iK8>Ql]DaNZFaF[i_9KfgEhjdb]4l5CO
PV<_a;fCEFXaZ>N:4Dme;6YYbY2fjHa`\:LW\cYaoi3b_SPGW_`5=5hTdbRQm7]F
:Za<Oaq0h3gTDQl2<bh6Bj1d0=?PME9C6GhCOiET`4noe>5dZ_I9\8>InT5Y[bGA
Z0LBBD`W]l_d;5lN[1n`?lk\RDeSR>>neT>:T23_<;PYDnF;3HdkeX?;dI@]jFRf
QWUcj:I0S35Jd;Ce\b6l_aPY1`6THY9PWeq7?EUWU;WYXO`2U4PhKSWSZ9U8DRfL
o=UOkSj[PH_J[9YF@JcFkj@cnNm:UX]dBeO2jP@X_mUbX;8=b?<;H\75Q2Q<M`4L
[127hKSXaU]:KRQm>b329<hXe9enJi<C8?d86Zqo6kX_>X4dCW2g7B5`Zf7@5V7F
aMTCi3H\4C_FG_Mm>3[?olR2B9n^d^@d2lYJUi>o73m^HSdkHI;j@ePdS<=3]^6D
ZRq=mP>6A3_ek_DeJ1elN8XPdjCONkQWn[g^hMLI\Kd<HJ6b;_Q\hhYJP<UiIGlZ
7b7JKq=95Jd8^BliWnA1;fcERo5CcYVenHjIo<3DRq;CeSEUAKD;Y775;:2[UWYn
;gR>YTEE]5@8FZ=\H7OhVd`mEpEZcDTO7OoO\Zok89j8D1lMU[UgUiV[[CpHPH]m
k@ToY^^6ShdYQ\Wn]l4^f>bf<CN4QXXDYW]cTeRJem^=0f?Uc<lm=lS>JV58[Qq9
>_BOW8od[oB]I8K2l`QVGV\O3<MRfKKU5D_h6_QT\0kSL9XZWHg6o4f;S4Kqmngd
=<Z9d\Ma0CO4T8g`Y@CGknNK`FNALd\=UQ`g=WB=c2?9;^9ZD\\X\4\7[M@hpjYd
YP^<;Gga>eP\UIc@fPWgjP65Kng\ZLa^d?[D4<d?;GYI6gbDXE\dmg=QMFkc\RnW
GnN\_9>HHE4jc><YRMRH@K3UaE^>QM@JC<dl@:W5OoP3NISOA94YL<5D?SM=NNf5
FIF7U8?<Q]oLQ2aKTXQ55h6]La4dB4AMo:e3pXEPUkA<qCXd<k>2hQXI>8>BA[g9
RN\X16FOfZU>hZI:Fc:3;<@B^G]LDj\4?m`Z@E\G4A6BWA>F:M>=oS9pA`454OTq
\ZjK`]@jJQC`lCcBc??cb7JDF[HPVfY9Idnf1l?_?dd9g>6?R0kdPc74mK@OE4YB
K2NO[C_Eh5gIjM4GGC1p3E]4M4b=:HGRabH9C5cR5iOFj4ZSIEOe[h9@fW?F_GT7
^XPhFC`HD9M4[CC04]ORqSgT5MDkK`AaW4?P3U1:Y?_E1K>C>B2Kf8UWfpB?P`dS
lqJM@1V3kqTO;R5Y`MO]fYWIiiF2ofXlSKi8dkDfb1ZWanR>GTPn24Jc_Y5mblDO
L_R6iQdRcPp;1bhYB`Y:?QQI[4^oJ`Rk?4cY[[D:lcCWABaP7V=DGX:[l:8g?FX_
\eUT7=7WeUN5EX1GQmHplH[Dkd2W2jUMD1I0G58FZ24ojgk3AB\TP]\=:<[f0`C?
_D75?Jm9T5MZGZOV@MQllhSRqAk>eFL=p\^P@lcMZEe<ldl3aY5^k`lGFd]la6]k
4FF`iPaI9a89W`nGi;S>igUc^WIPQ`cbk;5ALLN4^:T<Udl3aY5^k>J`:h1qmfcM
W2KpGP49=B:pba5AIf[iYWZMC2Pg<7_7H5F<@a5FYgaYO[16<DTS;_^Rm5fV4Q5?
HmBRZ9Qq;CeG3gMq4_40KA2PJ9J\281U<^b2FIS;;74b3EhK2mdDhoYIjd0>6HqE
HP;3\\p0c3_cmRp_>9@:;gOah72=:EL0gE<V7Qal1mI\M2JBc9mhNEf]lTAT?YLU
N^`G_lYLTRD1clfW]<mL>1ORG7Y9fW<;3SJ<IYOpji?FTMmSXRb;;]H_cX@5RcjA
VLHT84qAoOSai3:9VEaXgREUII7VHWo5M`S5GK0jj_?6o=U7U=5U=o<0a`dMUioH
EZ@eA7mqkjCS1h1:JClbO@iFSaSMRO:E:_=g0JWeF67qoo@7]W_oJNJ7\2c::nCU
k8I>A5XSH66K3UJS>7GAS:7m[o1GbJc4JK3LH8HD9Bh6NHLW8TLMhkAhbPY<MnLT
FA7aHk1=pL?9gh=EgnBV^Li\=:n]m?9`D3kUC9:^``[l9TTE6l`cW=D[L;g9UTln
hZgDlPoOZoZ7gp2n^0imf69P1o1Gb6YfhbfhJ=`dU3Rn:Z8^JQ0ap\LQBMmi@jQ=
l^2;1n1KkG>m94cbdi=Q?`ebRL0MeARcnl8hO>aPkH9l3Rc3JmkfKbc4cQ6bnC@\
][Z:L\ApXMKLg22;XKiDXW`SMQ\^Bg;QAB2bNUPQ5CT5R`a[<k4?lA7>cSBQbN6e
L@pVeWK_kXbRfHRB[EkbInO]2V`e214XWbE5Q>4SDJW::dq;AeXmLY2iSNE3mXOC
iF_^m2Ili7p@33B3oJanMaioe<TmQSKJI5<X=1Z2K3o4]VGa^oHIbj\W376ES8P?
H5iYISKH\>=@flSO@q7imC=Gka:PnJQ:n=^6@XOMcT;il_<X0@[66fPUgLm;0?JJ
0HAOoo7SiLcd<Tn7d^=]JJi:HZ3oYPcPO\F0DH`PTpg7A93c]?1\=igHV5JRP5=;
8VJm0h>88KO4?Oe`[;2D?=AWMfhTL0;?=@@>@@ai[qAo=EdU=W7?g6kln:NQkNWR
]2Y\CVe:FGLhn;HiKW8?22B@\2`02>2NqVDWB^c=UUajY[\^83VdTL_HlZY:\cYN
4:Xq;8a^RCD0jRAF66G7eh0lR6d_==j7]]1^7=H@F6IancFnpMlDk:n8_K7^OS2b
_?ieZ>2LoGO5[R6fG^=Bnekok8WZj2A2Ck`JJg<bp?35Y?Fj7IVhSolGY:VN2oR>
Kg[JPZmLJaF=_plJo1NfaT2lg5LnN<^1C9ZiSdO]Cj9@Vm>Y]>pLZaKCC5E9X?aX
3c;HD@aQ[=DG2Shb:HjL?Nll_eAWeCljZi@JH?d=<2X1POYe7`o@@=3C@\X[XXSR
Jfq4F9]i=>_1VOVPNAk1_3OKOjgi3R@5mmTS6d`QI[N0\im:39]RG6a?F]`AdU1o
iVZL<@f3Ynjp]WPSKQom@a[`@i?o[k03gBCERQk:[bm11kWdgl]ME@N;2o3_:4@9
85iST;AWo`7nc4glOP;2U99afdjh2P`6YNW=JWE>DSB@4lNE`NY9F5KXm;@UYeVH
ecAPXM^G[`CIf@\4D]UOZZMWA]7C1l0f\8Yo^:TWF>DHDQWIL8WZ\gK`hE;k:ZY9
XR?q\5S:>gKpJ_E7iCWWhAQ6m?MOT=aaKC>@V8m5_3]?JYo`k8=UCWkO:o;7>7=M
^b:if[cf@3\YhA@RAj8CUBH???4SeBp@HGPb6Lp\8Qg<hP^S3nUnWa\o\IIKM<AL
kN58;2d<^Qh6Yg^\GF0Z8YfNU\=kg<M[5]T95CF]DoFG[dgAd89XP08oYOST7Lae
N\R\L`qh]gQ>7kT1k[=6CYN7Yq?0NdVD;kJCdFcCa<PW7nZE@U65I93b]i6?<G9Y
[O;WHR46O0P4:`OW@PJh744l7CbA=mV[kNpRTLXcnEpW2_e=5PpS\6bNMP2e>Ja2
BWMl9<S26E0M6Q[@2e89JIk6jQH2jQ=QE;lK^YQN]j8O?HB[n\^338Y7fGQ5=16q
`5PVQhDEaPgJ^9ARB[?oKdNL0Bd3Z7Jg0j7_RG^HZ>ji4_n]FT@ChnB^18kNBgeQ
ZGBlN15M=afoij^ZO\J3qXRd3a@WMoUXPl:aOenb>[04PC];eQ6fLinEeC1Q6ccZ
66?7oJ:CMUA4?lY0AX0SDhH3Xf@>k\dA;qJMPeE__q1F3o2Doa4;LbUKR>`C:BUV
o\QC;DSDDa:i`dDi>f0B8pA1c==CPWXXU[B:OBU=R43GI<66]RXllk8UFeJ]g4:`
hjMfSa?UDTHO3SRC[5>PaN4Mgcf<8YXX;>I20CEVR56Nda4CH[dj5EIV1iG8qBBM
LMj9qUfd<48bpeFIJXggqYL0oN?01b?FQg@3IV:]2fm^PglkOS:L>A;8AC=2bc^j
^Bnif1mpg=8R@U6q2DABMSA8iO?FD3T=Od71VAEPVM8``5MSCX[C716SJn`TWf8L
1d[KmNj8hn7i_;kqQRTNZA=qRHBEYT8B?033;Fh5h22JMnQjEbD78Ao^Fg?]LCHc
`himo[?OgFE^n[afFf;eC88d2CMc<QV@`0TS^\;VZ=cPOgBEM[oTiepZQV^iVRiX
Vb<[i3DjQAV8?Ro6?BKl8\lFKOP=ncPD?@3QO<ZR_C^]HC9^4ceT9MVPH1Za=pi?
W<kTJc`Lj3H]Ej;c2f?gO`W:1VD:f9FUPK<Rb^0GgD=FjX_m>f>7>DT=@RJY7a7?
0J8QpN:L>`334Wb3_24EFYk?[CUVXZn:`[WOkgHGIW0NV9j?]9N6TLF8DNQgMf11
OWL1lYI4MCNqn8ZRok9>F8@l6LF68AaZcIUQPnD]<SE03_4SfNlLQR@HkTBMa=5?
^OogghjDB<@aOPG[OV;ZQ^S=4jbnX`7PFjDb0RV1cLA0>B`HqOf<7:B@alACIl60
;^8oe13Si;[fpO;]DLH;ZmH=HXGbHT7CLFdZUaUNhJImPRoPM]WMQeEjW9YYok5V
9B3X3hG?3LK?9G0=SILFR@6iZd6;SU\A0R;F\iOj97F2pDOb]2SnbPaT`cNSO>d^
YJ_e6lPM\GZC1BRCCOF2?jbUh[i]\ZCKL>B\mlKbQQb;ip8bKD58=JeT7]ZeJLGa
hJY:Q_I565WMBPO>_0Ld\\gfcXRnR<:l5BKdAbd46Td7llhZ]Z>oXUq6^VLeBod9
NLTSoNRKRW6gZ\2R1N6XK<DT1D3<dDMf1IV_dGF^@?ThIKEU9fPlNf?ASma44pd=
g9`YlFGEAVAJAIPHF>@7gQ[\=E707h@HD7gd]^Y6R=kKbL<gAOVGCbQJOJgTL60<
k6nFgbdlpYUhlXM\7G6SikaWdJ@BBJQNd9ga7QZdJPhUae[OEg942GM`SIBZNSfQ
kg]4QDIQ\<fm8[8M1j1mZ>le9]OR5jgoW^go[jKD6NYi:C7dpFhbNRg:QW@^DgFV
K9Y;GY\69c<DFqDeAWSBOM42Ck_7[O?:eR<FU4o=ac\LGW614K[IXjk3[:QemSfE
f9BD1^lJ34EYh4ah>1`CA\22h[fW8koH\Rk\8e[=0a^9M?f<qN`cX2a7[C0IFBlU
aFZcgK:QZRcXpdKX\8`FQI@Q5I_j5iWTB?AE0FkWkEW07SX;]ll[iOFYn4?IoJe7
blMDOU_NCiB?q3mmF0jjSH=D6P84G9[]_LaCjK=O`oBHJH17]Tf<WS:M4@]jc1n^
^<iDU:I7GakP87E[<ompo^jei;RQ?<B]AF1L3;mRDLK@G2bTY9WQBd[<3U]a58mR
G52`IQ5eWeA@gLgmYIfpiEGF3JU>8:;;elnCNHP82`_d38`=m;AWgE<DcIV\?bQU
\\XLnAZ\AG[n5XVdNkf;B^cReLCJVg_f_^c1LKTV\8=1b_BYpVHG7B=HL0LLC86]
1084X`W9i`W:Who?666Sn<@3k@dZpKC5B<hMSYNid7L0bckpB0H4TMnDYV>6a[72
`cD<m3>JSM1KTW@m4ef[\L;:[MiQZ0:gh?WnS5TZmNfm[]m_7?lCiIiQ6;:7o?n4
;hq]7TZ`]WlX[YLE5LBNbXeHW3JK?AkB;KeD>X3m8S8L_jQHc4qR>8o60P1_IVIH
8om:D]Fh2B\a6ZJgK\XpZY4UdRoV^JLaPKD>>nPa<g@J=]N=KUo4d=nnY896mLeR
^C>cDB^2T00eVI1jVTSk97Kq\Uj5QYGc_?cKKgMI7oLaAX=W;H`DYcJei0fhMc2P
oM2SMKVB9@iV\mPi_khH>IAoqenHV\\c__6Q@VY@8^f_0]6?YPMqJ_m7YBe1KgkS
U?clN4do?1m2[S:3]WX3\80<[CP?B<_cCF_d;WGfV?mCXH4GTllJ[lE@[R7M8dY3
dig_N=lLJ;N[gan>gH<kN\WLiMO0??RCfQlW_AJlUbAZ6Qco0MfEQin;T_N<N]c0
?ZKVo=IcHFQVCScPJNjm^XQCWIjph\hde7kp98JYBnJ=biihP5K<[2]_EN<h[ZcE
[5RKGG14>nkP7F:1AX`DU:L9IO6\GQM[<;B<PD6SLn^o[kq3?G2QMSFlI[?BFZn1
7IbRE70TKi4TiMl@ccEdVcp^QjING4p;gQjUN@Mj58SUWDVOB=3<=HSRMIMH`GPK
mnSo__i4;QD<SolP[S1gVE[9O^YUn1GAeeCn4Ka3ad3\BW<Li[pW\S`>cE`8NT_@
D1YNejcBQXCOC7l3A2TJ;>XbIc<d5SCj^AJ=RPE>:X==ZA`W0A_pH85R2A=p9@7]
Gi?q^i^K=2oW4\`L5gTYD3h?2HoAb5iIfV[?<6?6C4nnOQhm]0[j^HZV35B1@VX2
2Oa0pGC?>:h[PCASSTWX[7=9@m;;3L;`ZmSaR6^TeT5aTNSK\f>Uf1@`ei]JA@1_
[O<<5M0_S><jPpPX73dLPO0jM^@>JBWaI8=N\N=KjX3:dDFfIY7\HW8_OiA2HR_f
ci8EQYF_gaH]0WP4DUq76P\>JPp<2\Pmm_T9m]4=]a8KRjI3IQ<]R@YG=g1Biln8
>cqeEF>9d;o>^BlaBB8OU7Tfl`ES7K24gdK?:e=5fkMSN9Q8bbF7G9jjXjXbYmgH
;7;EYd8:2<dShBVaBB8OU7TNN9Gn6qgSjhYmFq7SCCY7fqAX`=^PYpHk12j`Slch
g28<cDaXCC7[M3A8h`K>Za;>Z[6oTkfY?\M0pUC`8Q@Zqh57Na:3qN\3FTB>n9I^
KLBf49BZ8\VZ>W6gK29@M4cC6Jok@D6[lg<E\Pj<acYl<5NM@X0=Vf4URWodC3:6
dBADHL1p1DH@kN8YVfmW82\UG7J3kl5q>?bfeAgj^1_Rd2;D8;dMm?W1A6G^J=;7
\nnF^][EdD1^XN<OB\HLhW5^>;qOVoKFU6IeZT@6[DY>UgEkH>[i]0qU;Z>6=^KK
XCoAgl85d]7ZHeoQ;JPkiN^PW@2Bo2`BHm8gd:9X3@[RHOQdWOh;B^HUVP;4lp>_
VHN_QTlQ\o9hLdSnKIN2KINBNTHjIRYO1:^1\;IiX\_CQ`on@dq\?K5bC^4a`0_h
J[<dY>30Ld6kIGUHW9GOH8KLjQC1Xk<<iE2Ml1`379qcLa62<1@\C<BL?:M6YBTa
`HGSoh0<O@?`j86qdYE[8P6X4I7aa``_dkR8A<SNoKAdfAg9eBoNIET?T\^14l9Q
758k?3YfHc`cbVbU@;Yg82IJCNlh4L2pIE_O6=j;MCA1I]DUohG1P>GgQ`kVebES
>_\aUR?_HaYX`VZbgGVB?dHAP4aR2[2WOWpcH<RQDYN0R8EmMXXV6h2gU4Ue==[d
kX>iR6>HSlkIUkQ0bAT038`ZWnjemFbJ@RIKlHC=aHYpe9Y2YTe7ieSCZ>AA;KIW
i]XO:0BOUdSRm>SS43aGP>?<lD_RdQnW4Z>;dWiVLLgm8_i=aobOR?oCFFVn2g6G
<=;_S8FI=gKeD5G]ki2AVJVGKIU5D6CMBn3LgK64FLZOi^LY\?>oIZ`oEZD>\oZb
dDWFfaA>596D69SheGYhWGVX6ZWAd?fbmRZpKSFg7:TqiPT]e62F[4k6^8D>C4MX
`o7:5J0^5?Q=IhJYA;bAeB0JT=h]9F10IZQGc=I]gSf=2[UNo23Pe:\g586UlWq:
:GE<E;qF5`5<A@0WFJUFM[84RkLNQflA=Bb@1I^GZ093RbdR6]KEFXm15o_>NK=W
jeP[`VH6^DVS09OBb1L[Q?i4jV2e0Wk\BDdo8>p1aXV[7aY[6Og4VLWZ[[2Z6HFG
X`omPY\;b<lgJR`a0g4lZ]f;3A12T``3]D9RF:aLfSSLiA^p[Fnh]keqmoIh^EeH
9Jm62FK0baFV0h0J0^n5g6qHbc1BA1qFA`H91TY;W1J5j[cJn;CWn=1Jnmm_7PAE
K3\@053`VGX=T_Z1fF65d[5KoV]_081IagBSj6o59j9po[mOR04Jb<>SI[BfeaBm
?g^O@43IOiek;K`<]H`?H]@EPS_44>2gE3K0jaAX:F;NDNM3\RLDkEKYn590NXXF
qDIjSoiMZU9f2c02`l?YY15UFgI__\=n_V>iJ=oZW\`]cPTnLm[O\AK2LMJ?W175
FF8chTi_=BbK4pL>T3BdI<JP_]IGjK:cga\6RcbT8JZ`EE_H5QT`A_RLZR_5DJde
Tq<E1M?_1qh05gnBa38JZ^3nETcZ@InhYJ7OeF2EV\@91AaS?N^=MgUU6M4^RQgg
YiQ2dgI^UCO6NoUfj5@[O^T7bicL@S`h3e`6YMNb_QJ0U3PTpGo9CMbPpQfNDW`Q
p]U170603S<h:[SVqTV8me:4p`m1ggM=DMmO[3dX7hb[XUC=2VRI\OFVQ1gQd4_d
kk4<=CB=R@1pO@bW4`Oq=`6hI_Vqc=_<LEb]iBg=f1RfD9nl4mKnUVjFLK]RB>dh
B^HReWFT8eRCc7H;eae8ZWZYC7?ACmGaPc2_7BYWmGbM^Z2a39iL`V5`c[L^oDq=
:idZK2QhPoCeUDl5WjFemAS;QHIAf`GGY@<FLlYII06ole:_J2[4TM6Rg6adKd:<
JWQX=p\mbkYFLaHSGHM2:dU0helAIXUkAcO9Zl4LNJY[5d02;6U2Ne0hh]o0B2E6
]=cnBqWUJ@Me=^Fi7\Hi>`FfNK_bNnoK^WL6oV<Ti3oeXb]6C\55;lcI\C^\WZQl
@_\j_2R4<8lipOA5ij>o\D0X>VjCV:N2b?WLZXQ]:R8f5Yb@l]jB^YFW>oPP6b_]
@<^_aP=9b0`Bq2@WNSo<R?AjS2`GlaHE=J`dXQmOWe[?^L8I5SH;_gb1S1G4@37G
Sl3\ie0=MD6\e2LP_<WXEGbJjekV_V=GT@XZd939\pA7iV:7akaH:SE9dlG2q7cF
XmYHG_02aGB6^mH3`lIaCc3n9?UQF0LZW5A>_0hM1I1_mVh88db7FWOB@[ZlX__N
U`mc>3V;H0dnk\8q_Cg\f[dJjeQHMCA<kC7K;h9j[ACWd<`4MDh;NWU7:^q^6_<H
gfdE]_0cWoSbhc2`onE`^pOO8NfEj`Oo5o3d]c^aTiFM4Eg]n>97LOhQ1oEZcZS6
qRLXj;>MOY4CH7\\fXf_Gc=6R[EO>VRWB?cWI0M?Zp8?M=OiSpOU8]5\\IO\]d:`
D\8YDF=^1:YLh4aE3io`SbVf[\8`?bR3MC@ggI9A`k9eTB<`K5OA5a5f4gh<d:0D
333e\j6A68pIM]DTV:<_O94ZRaFWUjCO1TQW63MSW=Ob;bOi^AAbn7ce:nTc^B[J
?U52E`3a:3[oj5SDQ?P@OSS2R`Tgo[paM84Zc[]2VJm[ScLBGa;eZNXW<M3maCNK
;BUVik@[C`MS_oLRV<pj;iG\iN<Q0VY[6fblBC750;OU4d3fMMdolJL]i0==9HKl
F3mpF?9k`=d]R4O0J:jESAo6`eQ:6I0mq>RF<:dAY=LOgZ>D56J@8lkdQhBi9:;T
]glA`_b4BnSIiJ\RSqiCCZi^W5jIH0Qa_T^N9O60SYLYL6`lI_=aW=\<4P8PTpm4
;96hmJD6`Vf<XUoljlKNbEg\G:JV7SYJeMEnKHFZBW1UkLpdN30\n]N\[1djmF4P
>OcfZ1>m4_5Q^>VkX>Q1TbXRM>DEf]7pDR5kLQQ0jJ[H[^NqOn4OXQ1A7OdoMTS0
M7DXaHoK^?7cI_N1]J9<UHeX1Rmqg46mRKhq_F>Eg\2q]KV>BAFq^>3X>TWjDP28
eHCS:\FHQR]=l7gZnC[Z:^15AfEpU?m07FDqIJUJ8b<FUEX;hbh0j07Sd2@F2XYS
G3ES:a3N_ChZdJhpO\HDV<K?Ym@LWLYE4Vg;IYN_[0Uc]NVIT9k=<D1Eb96>=cVA
aJW9;MRfOWeDX=JCOVA<4nkG`j_@XePEL;KBcH`gq2fRQQ3Ge1LcHUmb=jJ71^@L
V@Ea\IABcf[Hln2jOHJl?S_?h_DJ5<`PEL1^l3GBYOB53l8]JkL=Vb]O154ep`mA
M2Oe`SFM6a^XO<0Yo3BNDFn=bm7\UKo8FKd8R5i>:G4KUjE3qeiRDQCdP:<]_X=F
VALOR8UPZRn_KYf:8g0hmocW:=L2ooUe6pSke0=n=<egd6>EG_`K1_gPQ]khgo:M
eEARD`=VFTLD]m;nH4q\W<EmK<dK;GNOej6_ULgA8<NMRm>9De;U=QQ0n]YX97q>
KDV7IJN7NJOMeJ0[ci4^5HWLTCn;[NCMW:aTk0^3GW_8dP=q_44JhElJnakFD::i
^DiN5KF_VAYJSKK7:]UZN\YeS>?Ym916p1K61JGaUHK6lPnY`<XK]J5MlMeiLJLS
YGfaTgTSSVh[qgEZMiMDWldSLGmWEkUjEf=H9DV1FHL1SV23XT[kP0TFAoSYRqeC
EW8>Eq9=KF@7mqo=`Fd]5q8ELVN3fAg;FPO:XJhQ]7SQYAOgj451DJODVlP3eBK8
0cX7pTgnL`aAR>D4g;QDU_]37TKDj9L`T_BNXbn>>aZKMJ5SZU<pS<VmAQ_Moj<;
MO<3CH<>6DcBf>VelYTp\h>>Wg?aT6CoiFnJQJW7bc3F4316`UK?2TLo:WCa<h4@
H@G?TFLekDp`58>GeSoHIi[7=dSa1L=?0T6YXhLi[ga7NAa]F^46OWq@TcSKK;gd
n>]6I<VZ>Nc52<mL2f[li5nm[fo0j9:n6[q<\gmeje=oeiPF^83H8?4ceKqmC;G7
9SN:cUL7Z;^2=hP0l;50G9:doAY[9N^V90FL`<Segcd`^^pmlmhNHF]2caJSUNQ>
hBB@TPiU@0<\]>YkNkEeciU?d3pkd9>Pbhi[2OT::KkQ6Xk\m=M;G1O[kM1hIZYm
KlMFfLpIEk@VLGek]IMXhk=7>b3g3?3NGe8B[bUY@jMafak8C7diIdf6a:qn40U@
ncp3@Uka@=pQdAgSC6pY:6dU\on?BiUIjk<gVY8hnbKaMFYk9nFU6BW3j[dB3CiV
GXH<\KCII0Hd?XbOQaIW6hL4IkS;O]J5^OkWZVf``bMf1?KWOSWP7mI]\V0F?ZAR
91q;CK@V[aKY]:Ik5cK6Z2CBg=2_VfW=[gd22SX9Wa]1]ph0=WKngi7TeoD9@gJ2
0kTbIX_51DMBB8`c?kUoWG]HR]E3Z1pBjC>k`i0SVKnKkVhklO3Z\VLFI@>[?TGn
7gfWJ9:I=qOS@Yg2VPOX=EWKR\iaUX<Sj\MnLhO=qPSAlASTVBNm<105J;KSm8m?
O>]0kT3C83OlRQjZ0dVpID9f8K`pQK`UNl1K?]Se9f2T]AWUWU1@emc<ST\GU4[6
SccLd3a<UB@Enm4]q_fHkaJl?AG<Hl20PK3?S=3n@X`W`TPm=KZfRXE=WOd?<JHo
LS5IBq0QHk_^D^o6oC;H1f]?a9CnhkMBpE@0c?:CJ<CEo8<TV3Vn\8=U7U]@c6UX
`ZUnjj=oh7:\AMj2qJ]cIX7^2V;?Qeig\LW>TD?iL6DXDSBTd^CbMB1iik\EJ[E>
a4jXJpCT^@Zf3KB?E0@<3]b>YDA[gBiLd5JmQGn@I;kl\g1ZGR=BKXl2Neq__T]@
[@l7jdmZ_>kmT_JhT6hmHi\^QXVBEXF<d`^f5Ia>j]q0TnLK_6pVdKa;IQXHC_nP
YkCc]^g:J0bZU<QF;hao;E4AWD_=JOI5>pf29eA?Ap>G@^Qmjq4D50^WbH7E1V]m
^JX>mG[H<2YZ_?\0CX:=DAPNAAoSFM?>no>Ib=75XYiWHV_mmVHf56Ua=651p^TH
bbQEaaV_EELkZ`5<b=HW1bd1`bOIT;b[cOZA=F]KCLLTq<ad;i6KjbRF:DTSW]Pk
OAd<1k>:keV;H]?@XVSon:3EOMTjPfM>OA;OEZ:UVShX>]InBdkcU<fT\c]^qVkU
aTgbqSe80P[LN;9^GgP7c@H^M2R]=W[i]V?V_n7iY^5OZJn:n?Y>5UHK?pQBmH5a
dZcO\mQ9;f:0JZk=7UIZgHWT`KbgE1NmJ_Wn>C9iM\2Z1Kp@oOTSCfMc4hK7MD1M
DAkU<Vl2R=HV<c58_b]hWFXi[g>D_Nqk_lXIa?D_XGo<=]oRBLEhj;ZMUo1VH0=[
[heV@]VlFhM]91OfBF>q52HQ89[@`^O5kBeoAeMha623TiNon508nE5e9FYOX7fV
HMKIl7Nlp9_1Q69`AM6TNdKE>]bb7CR6>1RHD_mP\@`o`j@XE;E\FL1`qFcGoXhI
p2O;kZAQ@7<>\Z1keA[=6PGLc?GBHhh1T4a3LYn=_^G`hElCX[2k68fjpTJ4M1m<
qKcbM:ZVpjhiZ9ekEQnWDDa38mU:e937c1X>Yg34j;LR@ML]<`flTcf@MS5;pb8C
JRnC<DfYgh4_TcH?LP0<^Q8WC`afeGD3mhNCKXFO:Y\bmk`QqRI3M7U\G>9gV_k6
B2mgDSdcW]]q9N2=b9\lXhjnC@=QPHS[2h35lXK]J6_ZI3c34EaFTLXi2SDn90`h
_J;\QKhp9_oIj\_USTZVlAGoeI2e__5:jCfH6@3LBFODbBPQhc7Bh[YZ?=Dp_TJ1
C0e<WjTDUf0=0FQVjMRPC_^bh\RA<eJETSd8]^IRbVLlMhOp6KN=oYBjZ6CJWEik
2mWjVlUEXf5IK0;QWi=Mj`F?YU>S\fcj7lP<khRCJS2qO8FAm^8pCj7nDWMq:_8L
6N[qZc1k3FZLheWXY\2T@X`7AeYCHaZYTFC?FO3DhZflMd?\LQR=@YVF^HejV`iI
7S[m7eUBi^b]41Gnj]7ZM7Enb5aKhNXcge5qUaNK4gUNQE]SHa5]GC:L9[96_i:=
mie2_FX63WcOR6Pkl1_APbP3EmpHNd8_fkB9[Jkccdm2lG3j[;J_nhIXD^l706UA
U_d9J4]MkVYUVQ0D`MGN:@l3Vf;ZPXnQPCADQHMj9PZdUI=SK1q=Q:ULD>5Y_]UE
LORKQJh1F<=pT6b>=[_gVlh_KQ8dSn^O6DB;PgR`8PU;l8dIl4cddDC`^B8:>\U^
XekO<76=XO5Z\GBdoE>UGH\gMi[n^0djOEKAd<A\pQ:C<hMn\]IOkG1oHKIoCb^1
3Z7WXV^3kdECil?Cffl2CjSLYSc8q>Knim`W9WJ`P4ia^G4PI4k8@Zji5\Ed?\7@
f3ILCeWN`7PMdFC;US[HZQSL?;EGgAjPZEMN[TS<hm5=TPdZ>p9]\IfQY[QMaFhO
6Ye]e;D<p2g\Rd_NUj1I7>XaF>_nMiO^`KdVJ2n3ZPQAb0g9=F;`Mni5X?H8JHWi
GlAXik]k>ImYWhSJo0E2BV^b[lBP^EJ1A5M\PkmpcTNcJ7>Qf?4VSLSnOB_CDC=@
1jZA8^ij6<[a1Nk=MXoEYb\CbXhXcXFRYXTEG]`8TdHhJ0gP[7e7T<=@eM3HK6qT
4RJd>@Ad?^WC;Y?k_P1fP8qZ<mOYLi]fD@[@d0ZHmU7ESXhP\o\i=mPU49E>:8nQ
oEj<_b5I\O8A?_:m55UOnVZZF`SY=o4;nAOeeJY\UfI<nq6hjLge]RF12jH]jc5W
]7nA=a9DDn_I;8;SO]dTI]oUmi81hRU32MSeHb]GI0kM<qJ43;=BbK\Vc2iF7LKo
eHCe0GfYM7agXb9IBi`Vcin0GjE^0>@Vo35eiLfB06kUiSE7>pXkLWkj?b?E]^NR
YOodNTokn]YoXV^[eWD8QAal8A9[KWo_LYS^nMNFSnGZADO=TU4F3pdUN]fHSZYW
1SSSSC07fW5F[h]BBZ\1U;RaUQ`R_MmDUi2O0SWcZ6h4AKH^=Mb=6@MPUpO7Z\DE
a9Z1oScGLUcjM@:DpBi?U=fPeYUgYa7g2NgH@i=mNBgWcNkSP?5^T?JkoLGYIo>c
e6`[N=V<K@2dd>SlLEOUe6RJVY9lH?[f^bWQ?YkJcO3A[<LB\q>D3]i;GbO70kaj
^U06M\7AN<PZDFH95BR4PmI6en86RLa6DX2PC]Kl6b58G=d2ia^nh2`GQ;Cf3G1A
9WWiZ1F^C8bkcO@OX^FOdJe;=AMJJZh1<<Jajoa=BXH8TlpBb3EBT5hAL=FS=^3M
cVIIo6dMA44h\K091?RNYaR@O^>UgKO5ha3WF]_8jc\>@4;WJ:4d5_PLb[\TmYa@
<DEakPZNQiTW2cSVoN6:<T[CkcQAG4b7ShPBO3>^[=8j3Ep3_fWX8b5H<lWilNSh
j^a@F_ha7<l9Zc4>cK9W]eiO8RgNgQFB]D96H>7PIUL>McN9SU3aY`?WWmGhiIU`
]0\NP4[pLN5N4:];2YGiS4o0j33S6ThHTnPVnPal?8iGkR7QPgDgL9^DJX27q^bf
hQikWBS3jG80`KAgY8_O<;Z_BIgIX>X2T2aS14]>Bgd]UUg7E0G014=jnENj_`DA
5HKgB>3>n\Xk`AW=S[_V6FSeAIPW_qUBC?ElCZVHYi[ZSa1cBJN`m2dQR`bU\W54
M6ONN@c[mDCLV^J`g@E>iD^Y0b;4h4lH`JNiTd[bK:[V:6F?eV`]QK8MlWM;nlBD
I=9AdXbD?QbPD3;j]G7:VO;?Bm_EWqQ?A;P:KN2BTH;lSZHIZEK7e_2RlF2B9\[U
JPgU]PJjXVlaG<HEBDeamU0Ai[0<Hil^AU1maQ_aQcWMC;bBan9]i4ELW@`Den]Z
_1Oilno_T6f476\lOddKmWX;=eUjHp3Ni3jUfHfj_fJ3NU[h;?`ESdMGOnb<\APa
5d:EJEW7TK=90mWPI@K7hJPQ]T^Y:3_fS9A[[LcD=PK=l@h\I4Qnq;5Y1ZhVV`ek
G:`d[mM[k6\03_bB4ii?:7^7;XI9EE966SBg\e[H3p53aV4hHG<[E][V:o?BD6:O
MN6Yp3j=l@F_]`>^bC^SlCU8OhC82?BaDQTN[=kgJ`UJ@;\nOJOIpnm8Z9S66UU9
29U0^XZASBQ^@ElUe4MSUn2][Fa4R4g3]MbiqI=d3mPUmdgaEYLL3O;4H^i[oh51
D0hl]d`B;AABfq_=GKR6qI=9>]YNpl=A@3G`GOhOi>iR;k_d2?C<NaAb7[H`EYa`
\@3n5G_7Z9omZhF@_@\@eMM?BO:aIJC>W6HSPVS_q@\eV8EOgJ[9?F6KiR>VW3lQ
Li^c4\k[C^?gGEiT3ZGbCi:U=`J5bSL]gY6k6nfO48C<N_dA7OiQKKPgJU^DZ07>
=7l>@h7oNIU7DfBBm\M7Cc[U3oLIJ56GbWWabUaC=@`ZL:gBhgSoD:Pg1;UDJA`4
R9eV[4g[;l6HF5EenER5?P3dhIZ7[cPD\6=IpS]ocBJLqLE[RS:RaL4<QSCj27Ul
O3\gPXgod7Io1c?7QqMOnfjBbD5_2o=?[hdBm[`M:Ej28egoDW85[_Y4\385@ejH
Z_>em:qj<Kl<_IpOUUF0<c?;V1ZoR0CBMlSI^:<UXQm50IN1O]1QU;C2=:F9]G3X
fPX`eG9B2nF22=1QMaqn@L@cjXp1Ok1B8aqRXCmWg6q66iYR;`Zgc=M4ddYT7@VS
m8LE63H`LR36Xd8dU6:aRbb?11`J]A:?9F5@FGbJoY?3]Lq909RQmNp2VR^fg<q_
h4IY8FL9bK3JMVVQ?[@n_8OV2`@S]Uf@ofZYXBB4[3aq8en[A[Jb9<\S:Ie:Hbg7
aVZc9_OBi\dMBX37\@p?h<@Zn@q4?G0h6q[J8;FKqO@6kkK[6m;i?BhSf=i[dY0f
S\gEW_X6l`_mEHlPBP^16pB3M5YTHMQi[FaPFk=jgnoJ`4AO9qmF<7[Xbd4?CPC_
1llMdLbLOG3Z_<Y`1EqeTmV:RRW553?^fDcnLfmK_JO`]7ge]POJk_eko`pR`gTi
egTIWR`_@@T?icZ_Gj0f^kU<=3iHSb=Pa386k`_=1MpN[C_ZmqcYFT?UiqDUVBSn
g:S_0[C[VoG^l]koJOj>f=cXc7WbLkV2L?K>L]:UA?QBY@8mq3^:PI0OifbJ6`3`
0]mV<5bdC74UWZ<=9Oka8_CNbR`qmb8Yco];nQnR@\]lDbo<nMjNlmTRnZJ;JaeC
SAkk_9gH5\jb<Gl]mEA0g>PLYJ:3`H[RM;oUcf\7AEdVS5D7Ng9MB<0?X2lGVbMO
[7CNfBTL53o06fZ:Ph?A>WkX8`>4iY2L\dbj=V9oLm:YR^AnL0?BD0mcL6MMeRgl
SjJ1IP?OcoGbOD[TE?La5ZV9i0f@mOPE=D1q`jm_<ESqF[XgABB]Q?1;<I]F^N2l
QC>l;0?l5=ZA??LC\H82Ielh`Bjnp7DlNTU3bMELYCWF72\5?[oGAUncOlE]?Y3O
eKKnkkTc]U3NlGmg38\H?HJ=qgn[j3A;q7hf^bjChfUlIaSlnf=eOcOjl@Q6V:\O
QPVP?o>E]URVDfVjNjiKZOW@6AOnAL@>FjUDdNjJB1Dq@9l`RXLpX?ARnLTp`HK\
Ub@p5cYENRCC\[L2DX:<8aFbRN\LWgKMXad_nZ2G\F?;WZOc21jnNe;HRI=99Khi
<:Z>k7TNKRWF]IpHF<l^H5pU>fA3ZW63jV1^51IN@mI7I_jS6TN91:f?B\qoF6[9
]6po1Di@lYiHbaJ]RM:4Bk7hCYbZkIP<hR]Xc6hT1EQjbT4p2Vo]]iZpndR7EnqS
o1kn4$
`endprotected
endmodule // module vusb_hs_dma_mem_arb_bvci

