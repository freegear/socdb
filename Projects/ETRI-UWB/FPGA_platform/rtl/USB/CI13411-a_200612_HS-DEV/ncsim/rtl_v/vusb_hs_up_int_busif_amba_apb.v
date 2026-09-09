/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_up_int_busif_amba_apb.vhdl
-- Date Created: Thu Dec 21 22:43:32 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL:$                                                    
//  Author        : $Author:$                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Vusb_Hs AMBA APB 3.0
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
//  $Date:$                                                                       
//  $Revision:$                                                                   
module vusb_hs_up_int_busif_amba_apb (clk,
   rst_s,
   rst_a,
   up_endian,
   s_penable,
   s_psel,
   s_paddr,
   s_pwrite,
   s_pwdata,
   s_prdata,
   s_pready,
   slv_en,
   slv_addr,
   slv_data_wr,
   slv_data_rd,
   slv_wr_en,
   slv_rdy);
input   clk; //  system clock
input   rst_s; //  synchronous reset input
input   rst_a; //  asynchronous reset input
input   up_endian; 
input   s_penable; //  Read/write operation enable (enable phase of APB)
input   s_psel; //  APB slave select
input   [8:0] s_paddr; //  APB address
input   s_pwrite; //  write/read enable (1-write, 0-read)
input   [31:0] s_pwdata; //  write data to core
output   [31:0] s_prdata; //  read data for APB
output   s_pready; //  Slave ready (1-slave ready, 0-slave not ready)
output   slv_en; //  read/write request
output   [8:2] slv_addr; //  address bus
output   [31:0] slv_data_wr; //  data write bus
input   [31:0] slv_data_rd; //  data read bus
output   [3:0] slv_wr_en; //  byte write enable
input   slv_rdy; 
`protected
UnEnYSQ:5DT^<lcYLUcYNbI9V@;edO4Jn9UOM0o_l6\?>NmWf0K;=]BREel1j^Qn
[JhHJeHPlgq3TR6Pl=WaVD`\YfcgUd9\4aAKmRb=aAeeJ[Dic]_S;GoNaXIbERKL
<e5ef8CfnG:=XFjj=:q<^AdA]ON0LIgMkA\?C5IpiKAA9LpP0`M0A0f:D<22Ddi9
3Vd2aYZJ?S<nRoZNnHpSaDQ_nVnEeeERE7[GFc^qAK3d2nWEPgdh0Vo:L<pUUWb0
S2U^:_Sm\Rm^H7dS4hlnPaJBmkEQJjMH2TKmVPHi7ihHM`j\QO]p27G::5Z5FYe_
I]HR1P3EWX0VhifN:Wn66aqIhZ?j9m2Zc=BFS>onW;l7n^KQ469lQLXd\gZgN]p1
P>>m611PNOCI24ffcUEIegLeMmR72?]WMDpaO>2ohm>WbIUfSAQAKP4X<=>BCU?k
71SaH\2qgMh1T<l]hBA26mH6IZjj_RYYDa_7m[fC];FfD<9_>CqHEgaP\e[9V4OI
k6cXgXi^43d[6;]CPH:OL:SK1qmBXmf5Pd]oE>63<<H;W^BEGq?45JoG2MNk9\k4
a:e2e@o>6p2NS[^^iiNn_3o]218E<eoCqF2kdYd<l6=<U;60lkCd4p1G1RCo5Vb_
398n45Zg1aR^p_S2Fei[IHY@AXVY6VHXUX_>106bn3LRSbX_O?BmqIf;k`@W;g:K
\ml[[6[h4=onCdEIJV07EbTgh2VR7dZJT0jMqW6kj>FdXV\f69RL_TbmciH;cbQK
^RG9Kf`m?LW0<a6qW6SaT5Vk4knAbgo=3\ZDOgK:BB:MVFBkZ7OW@:5]gF=LhBGY
hEZ^e?`p;5F4jDMSTmfH:T=6mM[kSl\U1?Cb04Y`m<kF_G6Xq3O@V:\EeoV42\\K
24:9dqlATY>a90lddaXjGMG?LJ\CF>]U01HId52_S_q5EAP9LX^QC^1W`d<nl=iV
l`Ifo7MlXnG_SqYYSZo4mf@XgM3I<JdQOabTC^qci9g<_aj1NSC>Lb^=O@aS8YRi
S[cY@Ch\Yp:V>>mHCp5^=\hP\c>G0S?INAW9]QGJX;27aPCgZY<SS`c1Aggmq;54
L]lCoE^;^9CU4[9d1:jG^TPMjoDIW[6:>l^IGTlnT_?n8Th:p`Ih;llLV[IehYTb
ZT2igOdJOX[2[Ch@4a]EP]1KY2;?]SIqB:WCYojJ<o6A<mL]cm];k=CWogGe<W0H
m=^`7<IM`?Uik`7G=JAmJ_H5PjCXDl[=V]MRCJpFb?S\oe6=mRH49bn:]Wn^=CVL
bd8k>aj>Ml]p4eKbWNHDk>6=TGORUcdCJU`<W@e>C3Bg1?L4qT\1K:92<`i`Gl1Q
AaX4?1ON\P;oBWNZm6npd3d_?LWc0Ch]>gj0U]]PnS<<]DH08j_`9Zmpo<Y4=]Bp
ba]JdUape6dIOM;pQ`KQ[8P7R1nO>fiYf>I1VXb[_LRX<]Cj>ip<[n@@eDqCFK\k
UEjA6DCYGZ>;_Qk^U2SN1PmPg0LjXV^M5BIAmAeGV3o6c:21Dh_fia>oo[qQdc13
CaIED4W>h`N2h=ZL`=ee2EZMHd_h\WM?0@3=6paggK?3=h00L1CTj[PDO3QU:8j\
Aj=eY1U\fek1ahe:7\TE52_chp=Q:Z2HWNa0D1nFoP3AH[QIZ3\`=0`Nnck?oNa]
A9mcDoJXqm]oj^>3Y9ib><d@oFI5d7]n6SDBb<VnfnK6DpQUT?VI=DD51\V^kcji
h;G\83>P`VC\N6XR;F\YH]cYq7RbIF^fVP5TgcE470SKa[7<PnQFOX5gXOK\\qn>
P`>i8BjTmUZ:<_9;IVfP66o]WQMWE_YmpWSaOJCZlndc^?NjNdSKH1CkWmT[j<NS
H>cKpc;J=]@^1kQ5XPa^l@hjLYYf6aL_<RD\DV=oHSoA5Wl_OiP6J:54i4[hFYXp
GjI30F7qhcN=Y]Cp\BH;HV>p>3BH`YGbHV>H`LEN;Q8eV]@TCcXDc<3_G6TLMaEe
_O7hYneEg;X;c?U\^kqBcXfB`H[\UNS4]l4L;\cPA0fLdZl7]A]mMIUZ<hJZQ<Hf
FQBQI?Ee^N]`gQa@`Bl?J`pk`CZ:h`pOS9aA?RkRd35<>?G2KbaIc^DiEo<^2`I=
UL?3j^5hI`lj1YAqn2YK72UV=CK5Ig2nMDYeXTaP@8DTZoj0>Q\WpPGdR8X:Fhgc
e=lY;;dOB2N=3RgAMofTBWle\q[@9gHNUohFLPgIc4W[2iTj;[OOK@2C8d`mf?>f
mO>^pK2c8fiD[hi@`HfgH8QU59MblnMG?B1_M<mP]9npJV^T0VTp;0T\@3dLKB7Y
[CW=JG8:XF]l5WqnULVIeI^XncVG_DD9RVAH5=Y>fZZBQY9:1lTb1Ne46qbIIMX:
X7CFFfkUC68753L5NPOAF\acfR?bp^D2dTFfML;[036O]nnN9nK:@`ObF69<^;=a
pUL603bFp@MSE40KSlCR;dU=BU1502426c@:pbPdRYD<p@=7:^9`qmZME?fTacFN
G\8H7H=5YgeB<3P:m_FG0Mmp:XiY>]jpiDLKgJ<38IX8?C=US91HBK;2aPPV[3HO
gZ2S`8===][8R7]lkd5494g8GngTqU?Q@9mjqT]Z6:G\\2n^\oW<o80h4=PgR>8g
8IETdhK0jfER0o78FI4@jn^IPE99BRaE^Zj;gT4Z6\QZq7BD7L<beZ5hnclEZc6:
6k44j2oC>Lm>Pm:dpG:S;Q[UqGBbFH=W=G\`U09JSI6g2@d<I>SSH<m_]\TY5pd^
fmBVd_]0>@Q4hK>Qd0@LZaT]dEJ8?kMVX5K=0qFCTXWb7qS4hY`5NPC<m6Wj1I=G
6_Kl@]`[E>UN<eHaM4q`;J2a@03jnUH4YS7;b0EK=`2C[X=I2LE_X[TfeaZ5`ZZc
;K^M5`dmaImYBpL]CU8<F56ieec[m0RP?D5HhAR:WKZG]U8\NPGURIX9qY4Q2X;C
q]?e;TJ3qZ\J4\moqkoS`jm\]Pd6dXBF1EEV9P?OUml3Ze^L:0ZGXpB@GeTn9fRM
ik4U;:af6iO@G\[ie6F=i]E9o;NZo><\e>];fbE_5T\Rif0UZ\FKJpV[:ZoObq7U
_5`>=CRRYAkD;ARR\F\:Y:Z@Z9AFZ2IFV[YDMg<JjVFod<gY>EoT<CFA\D]:237>
n9pn>^G]j3q]:>CFUiRJT_29F?omA\a9EM<[0Zq?3;J;fk=F\BAc7`d[23N?`;il
L8WTHL6A^qan7T\hZpU3=bTa>qdX1gD;PGF>1?;LS>d[0WC=X;l8S?Q4PM^bAWjX
6<>b\G65d1iXWHQ;>OOCk3GTZJd`1OLTjp1?`@Y?baj4D\iej?[GIcB<K=VnCbON
mnOB_q[]Vh;d5gWNkDFDST=>IANg1MoQObB=hfJ8;T=7bZ9\Bh8@SkCeDUo1pFF5
5o`ipP_EMQB\;2LOdncG7LVi60L[XIRX;k0f`iiLcq:Rd3339pKm:kbWRn6gLI\\
Xj0NC3@nj[M_nU`C4cQnmPp>T_IG\d=NnbEI8b>F@kb5Y[JM8dYID=OLdqQK;786
QU`:87A;FF0UYWVZ4g2YV[GQ6:`6M1@LHm[YXb^HM]<\8eXQpe1^H=o7pZ7j5dP>
q9IP4YEnpMI3Xigl1DCXjJWGMiHFi1OT\@AM19Wkck_k:pPRLoi`8mG@PNJo]:jK
_^Eo;Q8Qd4Kk1>3hp?UIRTVlpS_^ZFIRc1<J6fXhiR8@HYf@bW<Eo\kEl]HmHcLm
_5hq79bGC>Dq8olG5_8M0WN[8LZ[YXnTiJ^Jc<FJM<9WU[^i`Vaq3F14b`gW3Xn0
aFMaGPAa?E1l\5]GH5b?TTZh>8bckc0ZC5E@D9?OTmK>Hm5UN?9M8C3qf71PPFnq
MPJM\<N8`>F2H4JO^\jZ:F:JNSE7\f8WibYQf4LC1Wp`POcZmIj]SLGg_;WCf@lV
Sl=9hJhJ6SD9^LopgZTTYXHUOfm1BDGBhSY6Uf8G?imfALKoNh7=pgcK88D7HYE9
QGn9U^nmJR@=^74aCCSF6<Iqi5QIK69Cc3M1f0aCWJNfA0b@9>L?e;3Bn:fpM0Aj
G>EqHn>BAj<pZ7]WZfPKP:A0biDEcS3=]E<jSOH6KlI\8]Wg>jfLMFV2\>fG7m`P
]ZiULWLA860lqi_A7nY1qP0h\XkO$
`endprotected
endmodule // module vusb_hs_up_int_busif_amba_apb

