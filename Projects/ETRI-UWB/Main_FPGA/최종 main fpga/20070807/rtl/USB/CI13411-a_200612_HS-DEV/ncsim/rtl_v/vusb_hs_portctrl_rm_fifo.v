/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_portctrl_rm_fifo.vhdl
-- Date Created: Thu Dec 21 22:42:03 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_portctrl_rm_fifo.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//                         VUSB_HS Ratematch Fifo
// 
//     Handles asyncronous clock crossing.--    There are no software or user configurable registers in this block
// 
//  Block Diagram:
//    Transmit usage:
// 
//                        .....................................      
//                   16   .                                   .  16 
//           data --/---->.-\                               /-.--/----> data
//                        .  +- data_in          data_out -+        
//       txvalidh ------->.-/                               \-.-------> txvalidh (*)
//                        .                                   .     
//        txvalid ------->. write_en                  read_en .<------- txready
//                        .                                   .     
//        txready <--o<---. full                   data_avail .-------> txvalid
//                        .                                   .     
//                        .                                   .
//          pe_clk ------->                                   <-------- PHY clk
//                        .....................................   
//                                                           
//  data_avail:
//    synchronized !empty
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
module vusb_hs_portctrl_rm_fifo (wr_rst,
   wr_rst_a,
   wr_clk,
   wr_data,
   wr_en,
   wr_full,
   rd_rst,
   rd_rst_a,
   rd_clk,
   rd_data,
   rd_en,
   rd_d_avail);
parameter fifo_data_depth = 3'b 110;
parameter fifo_addr_width = 2'b 11;
parameter fifo_data_width = 5'b 10110;

`include "vusb_hs_greycode.v" 		// file containing translation of VHDL package 'vusb_hs_greycode' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   wr_rst; 
input   wr_rst_a; 
input   wr_clk; 
input   [fifo_data_width - 1:0] wr_data; 
input   wr_en; 
output   wr_full; 
input   rd_rst; 
input   rd_rst_a; 
input   rd_clk; 
output   [fifo_data_width - 1:0] rd_data; 
input   rd_en; 
output   rd_d_avail; 
`protected
NT;kFSQ:5DT^<ABRa]Za_eNdV^ZJ0k2BKe:L0JGp:^_bKWhYaIm@1\1q[^NLDA>k
?7PV8<3OhcBJ6eLi7amLERWMahRa21c:C5:9a1[_d?ANh_>j25@JaV0AB48q0l5=
P2q6gN_hDcYi66^LkoKH6<pgWnmnfL66KMh`I3\EoiiA1[]mg@M^j]J\5[8WcULj
k<hio=YNR:KN7bmj^qbY@<;;BoiCgG2@6HKYlTSL3pa3g=G^UCE3\1dSdd<_TSEG
?dN[fNYJg>WWc2hA9B1R78J2a=mWT^jfcEMi?L80Q;@^e:Bn5o:Q;>K<en<__JhX
CpD5fg33^Tnf7O2fYLXHFbVn;DWN8Y6F@=@SGN[=QHcD2dGh;o9m2<6FU3hRE=`B
kBAdpocbDc=Y@OLkIQP]6]_<aYW@D\il=ccImV][[>^Sb@<j6`?fn^;E@d?HJg`S
E1BBHqPklK=jcK\l]hb0nZa54BAS]<L:h2[KN3o[o@1Mb;T5e6fGW44M=DpVeWZ`
I2EnO`3AGbI66QZW_1W3B:95=U00QGoFMnibJ4phiJ[MB2IF:[04>X7jM3kC@Rc6
7MmS1<0@=08I\hLp2E^XG`C6dlTR8cjS=4`MU4Om<;`QiLGQi:YmH_\_<CXJ<2Kk
0h7[?U:CDoLNa@TJkY:fp8a5Kj:m<[TnALXhRc^?YQ:e^P_:E3Y8o:TQjefcY5iZ
VIYGUDgHRpkg]>ICg0Lnkk9IC<XK\<H3OLHZDk=l`1@n:76Wl=V3TcEEDM[4UNk]
Mca;NHZj6gI6q<nVnPJ0>kHb1Q2d_<k[1lCaXI6X3iC6\=L\WRS61g?]XNhd;2<c
:XkZ9;Qf;LTmbp14X_PDPBmbN@QJjD08_>2Hm1<lSd_cdV9UCh8d2BMjlqnL5Ul0
_N0kW?:3=J`6BeOjR[H0g1@=3BZGE0>kQ\qLkYaCA7Qij?C27g;_0TKCF@L41Tk2
JgBnX[ncfI`_E:cV<m2W[c08dZd7Cc39IKhW68JpoM[JNF?50aW2Y\FWFg:m4c\N
`AK69eFO^c5Eo\SY;[H?mI7Z9caL@o<G>7LOTlQCGlTp9>Bg]W[CfkQ\hd82[nOQ
DiUCN<`1l[meA`g[go:iCd1_PC8ljhWFbOdof<M?IlnLhQ9aFfLKc7ADIVfeK`pf
f46YA8`A;]Uf>9gJ84A9So^T0EnOZeZYJc`??3p1MGcb@TD^J2AZE?\lk^6<55;E
\4<S7Q3dV]90XhFN\UOXDST<Nbcj60Ee;EX[EQ?Hj01fUn5V:P_eVqG=?\\VJ>R1
Tj\1Ih8?l:]M_bQ@OYPG;:lWf`n2qBM5?1lO:VhB2<X;UffPLKD;OJh[>nB@TEmq
6INMJNCIX<oJGV\@i]]OoF@>bUkoe_80dCjGbQDN6LVVO=3HDEH19<A\amN3C@AK
3FW9n58R??Z<HD=JnNpbf5PYo]G5Koic3^?1DZOm[m>68e5THILOJM_bd?M:cNqO
84n3iifeK63[lVO2\I\:Uh:oc5nF8>`HUPF`\]=R9j=Y6>a\hkIV7DX<Ke5<>SS1
DX``[]OL;HeQBqaR<Lb42Vc>FDSLB8gPaY]0p7_jTX1CLReQOhGQ@?F3_Lm2UVZZ
4^Fnm6gWECo=]3P0=[`o<[7:[\cEi0k>oq1n?NECZAbN2l[e2\QPUWEHKG1lqa2<
eFfbF<?jTS`STY_M1nLaf0DM\Q`SY:G\HqHiK9[\dAL]maenBG\NgFWcXM`V63;d
G8:6qdY>dN=QZ>R5mi1h>boQnA`C2LIoSA2I`NZ1WA4XI\59K;aOYm7R[YA`USne
C^A8i4\KcN:G1bD];Y02Cn;<q=U5f^=1ZEQA`aSJCZSPGcCKDKoKWTS[PRaQV0==
LG5C?MIDGpjA^B7[ae7jNeeBg2J]11?M>[]27VlOFPRh[eqoKG@^DnXDRV4LBJei
<eQjg4Y:?klpHiDGTcN9]PIVSK3hSn^I1kd3VcOnf;jRAkp6FeBFLNOg8=Q57PUL
Pl\LZL@h_C[iRBJQDSee\@G@>pURD;>W_4G9U9EFobMoR0hi\W8l[nL89pIJgVD=
3<K=RNT4aS74a5GWN;fm>aXMFOC?QcP[p>;7c@Z\BI^n704dl;mXYSYdFR;`Sd>j
J\EpEdoOckWp2<]C6Z`>ADDUL]caV6bKm^95Io48S6f@]i]D9EJa6G65X=gjD5h7
Go3=\EPE7=Ak2;6fNoCB5VKkB[EFN4W;_g>8Nb:M^CfYg0fbb?eDlWSSHoYnj?\q
bD<nQ\LqHXTFkShqLb<c56Bpd:IA7Z1:TFbYRNRgMAKULSGEc:8CG<E8Vi>2ZAXO
OR<IO_lfJg_LZoOAP?Wld]ZAd^I70@\GdgeGRQ<5iJVE9DpGXb4l^76?RI@cTB39
43A9Z1jm2R\e<?kc;7]_BE:XZaL60RId@JFp^M06RgQp42Q3]HM>V9m?93Q;[e@<
<cYCL=WHkUm2dKC5ThQ1MVN2Zk5ln`:5nf\Egl74eSjW4[j_Zb?=kFnlY]Rhkn1P
`2Lm8Sc9eHmGg:5=bZS`[L=4[oJ]NjRpohQDb\;POl0iI4nM8a]@Y20jK5`COM7k
[P4Q3a8RDkh]YE@7nU?9DCp3FF;hD3p863aRZVpk1j_Y:oqBcRDn==l<H0\2NQDd
a2oBFZ:8\XRa\;SI<nH5HoM08dV[7YOHCBgV6BS[@H]\N>X\Jpg_SV6TOXX4:hjW
0j1^gS34nk9c59ihh0GjMNodpDkII3A[pGo3;TUGJTh25DWB=R5]do8f2m7jIL`@
`Bejf[PX9KWDYHd@OAL7A@L^TSRSe6lnOnlZ:5JG?7`<`\\Rb0aX`2gdZlAB2h_@
Z32nR<PXO5WD4Hd@OAL7A@L^TSRSe6lnOnlZ:5JG?7`4n\\_@0<``<O>Ikah2SHK
D6:^^>n@:_:oP?Qme@O@HI>p1V^JNHMqgSPMZDiG=fR6GcmoUQN^SFUenT]U`[O^
]o]nlWS7X;c@1`FeA2X`ahJ4oJCOp7c@YfnLpm?MBKhldf6[^S`^S5ko1RDHai8`
Im]In6L[B2=N0bA4L;iF[WmYKCn<`4]T4MeBW8PZmJf8R>]jNcbd3>i^<J3^WA9m
SE5HBGiB=24:19bGn];Fg<j72TFl6\cR?;AF5EK\V>[SI>M8;@5]`?>eY8n17Ba_
ihD^<URY92ANcIflq934BE2@p1j^5K`b2Qk6FA]B\eEKh39U\66eTB2P\b1p[1mm
=]a0=Y^aI[b0g>0K2XPWP`IVB:d6AgZE32LWaf?=\LfVQJ]J>I1JZR]QFbRNGBG^
<aXVfSGTGkj_YDYLD2HnN`DP[05AQXYMW[1QCb2`b?`RXC1Y>MKnoViYF6DNBOhi
<0Z;kc6RDS=:OjkBQ5q9S`>f\@p909RQmiq2VR^fgaq62`Gf7Gqe2]8l^4pPQ=RX
L6p;HEfLe_q6;X\ODJeLaccLB`h`:7WM6mYRe@LWR>5`hnZqCBQOIQeilSMa:XmM
kgTajKi2>H<i8X7eF?181hEOEnpkAmkKf<DkBA7Q;bCVnIAEH_FiW2]HnAVp^ALS
]ZHbCUZbej=oMn60BfC[`[eGOLma:44U>1p3IDVUmNqPSGW^H2F4?bJSF`fU:g>8
NR:gPAYCL]ZJHRNeeKh63aE]Nl6`1CUhmGfRcHb>0MkRaTf6CBW:c;^SVUe>l_UQ
>M8cP[L_CqO=:6EJVYe7ZN;4;H<@1AN7eP@^f7<^BADH7ank[e:L:QVU0i]RoL:8
Z60<16BIm>_7S;]QH3:2BdMZUC3jZA4CehP@4`pba7FhVnpXTBd1^;qkG975?K>_
C\=biESkahpG:lSGnepba?I`E6E`GKOdDABoP0TDaThOgn4N76nSIk8HNUWHEMn8
NVHVQ1n0UeC[Zo`V9keb6?IS<:J]i8HcgOZVn[\i=p1@do90o^@n\AdYo3Sii9f3
eM>n=b0nC5>IFTIR;`j?Gk]lnIFQV@qi=861UHpGK8^nR0cV?<M_0df=bI2IjFk2
CLShbH;>koOcjkS1FBM7oGD;8NI;9WYQ5M\]?_Ro;LD0\0RQTTL170hg0I__OLl<
C=E@hpFIMmcQ:;UG:Xkk?>\OQYRmkUhim94A6cc34CY^81FCmJ545Z<Y_]cieTa2
jV\^01LMh2\6cR;5G:<5S`;S\d]h9k6U_hpS93Q1Po;aVo;18KEj0kQXW:7@CbM0
nMHkTNZ2kTp7`INQl=p;o^55NjpnnjmHS4pmYUVkcS0`^61557V@ZU`KDeLZ\V`o
ajhaG1J?[UiEnEX_lUHjS62EC;KG_`dG`0h?nqcTSNN9BphZ_JUU\bIR<`aegAi1
KZoCJbQbT[XNVXjRbJSj7HRR@RUNA`omOpA1h2min_9knhD3Xfdh<7`]OZDE>P@T
3PSig9cL6jJAcR?BEIhS2j4?[Xj1\RYm>\A8H_qoYQL8Q^NVmNC:7]Gk?@gb6=gM
O9ip6]iQ^UhpbDPYJWRcVbm2L41oAeaS`^FZ2Y?2322?cMKlo4kP[UaFcFadB9Df
MA?Q]RXDpC;X5;^eq[F\I0\MqP;C@?SIpGg:\XEE8XTgWQQ4kNfI]XKV;i36:RIi
RVTNLOFmQjVB8Hbal[nUk87J@:UeBKKTdeI;nq`K75S5bTa?Q1cDaW;e^iXb?]N;
>2jILg`2P7`lV]9]Y:1c6\?i8_`NHKR<mMFZVbKBkXWlG[n05a_3^n^XPeX9To`>
jMqP?iWLN>qiG1iY3bqoDbH\:7p]Wki;8NFA<T87fclmB^hC94GECU[T@@qL_P_O
LOqY:lbRe@pgVBeSLFfKdlPkHmGcQ>PN3o?Tk^N88W5YVW_6[=0j\mh:baD<S1WE
lHk1[KML2g_WdiIAUI4=W[pImX5eX@PUmk3h:;:`\3jUbdag]=n5BRbI\VOOKg>?
PneeWPK[3Yj2o`fV5aHi[aCg?JeKThPF\emST2NU:ABWcYBg]AnWOGq=KT;^84cF
:O:7Bl6D4PZTYh46]ZXToeAj7\S_?Mjge1C?_E]28=d9JV=ZD0Rm0?]_lH6DBfV<
U:MAQ[>ZRVLHn=^q5f6?gLdCaGjY_Mf_20h7Uj5haN5lhn>7<I3FMEWP;MagI@LK
lR5BeN]4XA^ZPIXk>9f_1VF@7g]_\g;EdX2FPc1;95>^lO@NpKWIj@LkIUedeQNM
MmVZMJ3aEjIGSGCGlX=QC6SWKmapa[>BOF4<3]b]kbVIfNN;Kl@Z@ADgJeLp21AO
n\T`[2B<S=6LgWcXm`56U9YH1>b^qk=cV1JRZgQB3ohbl>[KT^jQ:;1hC831N2:>
<5]q[R`URELpNF3EF9_IWNfhBiQa40D\Vma8MndGbAO9XoDVmFHY`h`031WF`aSI
5a]\b6Se?N=Th_Le2jYl7j2WgB4R[ahggW`b9n`^SWp=6;DUTaC>R1ek?D5I]Dd`
1fOLmMFHXdk\Ph5;aIV:aeZb]jkE3aHZ0iAqgl_V0>eg;8_XZOF`3BF\GeVEh3U=
InM:bCWD]<06Jf;FJ;WWmE8S\<mB58gFYDIV5Hld=P@N<=ecaMd`Dn\i6K9k\=k[
qQ5na]Ajqo1bGMoZpV?lS]lXpMC7E2Z3[kC0eR4H\9On_V]YT92YLFGoO718D7LV
DOaDm2=A2NGnPOg0>i6TFMg?9M;7fSYSAJ0NkA3g?9Em]FdpaDmBi[@coWH21lCm
6gO;6j5TJO@jR9RXOHTdF9E;<n_k1?gGFUX@p4aYn]D:8ia016gIJlAFP]][8^AL
O_mm3Egg1T5ISRdD=kECTWV[W4ghnYfBhpb;]J6`1q_HLVX5?AoNIM1g>V=8<eWI
bHNNICmY`L066\MV]ROOmdh?\iZfjJElcP\1RI2im8IGg2oVndWAUADBH`kPT:gW
7;TNQWneqP7@BkjCbdY]:6J4O5EghFb<HZJ7;XXeAM^[eN4g<4nc68RTZ97ILP:Z
kea39>bnbSAIL@^7T<?ij\g0jQ5`C1I=R>Jj:qFK9WQ0gq3T]XoEopi>nF;Qnqf4
Ja07gFY5nWY_4^QY<^@RW2R8enU^_SfE3;HAliDJ3qEPQeH>:4KAFP0;_;8Ba73@
f1JWH9\J[KM3ALiOm<V5^C?JCnLGYIoKkA6:;GmUNiM>3oBIqFK>D:7Ep5il5Bb:
[dkXR@:dC^BWTS7TR\7^j1g81PTBTkdgnoPZco:NEeH^pPMbcR[_>C\eT@HiQ:>U
FOVTK=BbCA3NXN3]dgD8]O77hG73WZZ3iL;VjLoTnoJFOPWm_pnGOSgEBpNbJlf^
L0A[n\CoMi=GX@TOASHjmicXGl`MNWLRgY5JG\@WV?WOEVVd7<IlBXpIf:D>7dpK
B[\B]TqHcSN?gEUPClDVY9=AhMLGbQIH<g6GUo=:b[:_\d7AE`Shh4?1_qm5g>CQ
Bqe@l;fEZI93n8VRKg]`W=`nf=UG861T^HBUeEeDL^GoEGADf<W]bcT_MSGS<4fK
9fjgggW10mh3@TC@dcBgg81`h=mGeRqUWWKaU6plNC=MAWqfK]9i?Kp482ifmiq8
aLYigapRg\XW70mORMo6Rf=`7oJdfOPCjSd:62S@\fb_93jXY5nXjCVAZPqnBBL<
6O8Go0mmAGn=5RFX\``DCIFUV\;8>finRn]J\PLL>e3WlMXob<>=[3n8aXPbP:kk
1b:AD2qP23\eef0<;3@Hha_9^62McV5[NWd\T82mAZPbD\6Uc7PN7VSRj\YNF:bZ
@5\5<IlR<aF2>U=nfZPA9RfRaGP;l8U[NK?4mfpgllGP89SkJAM;alA`:chEFo>h
fkAF_Z:U?AHc7nQ6oddU@5hPhfoFZBi@V95V3fP0IKIn\\Si\6RFYe7[HVNdYK;p
2]4Fog]YJCa2h@e9mdSmYfT5kN^[8BhnNlCa3fbLj3p3S;Af;Gj=OnPUYl7eiFhT
QFF8^giN7JfCSZdq@]Ml8HAJ=FT9Y^TFL_YE][1hf@eAin3>?17ZeGpOjlZ>UVpN
F=gWDE:ih7CSZ=lXUHF1HBW6b4_TI8A>gG[@8Zi:]^g8Di_;I8lUc2_9`4;<02me
HaVO2aZl`P^`URNT?<YgV9EYcF^jDh_edG;J`h^C]gF3`qWX`=_mk_UY\J^k28i<
lIOKE?^]<C2HTYfk;^lg4J[YY_7RiL6;_pB1nf]9^8CV>`bhHoK^caiFfDJGJ\_R
LV?;PqC`8CeD:qe\NV@HVpUU5\aK3qNP8L]^JW=kiLT=XdMkaS51oYBeQE7Jd>:V
hhZ0Y`:1b?Pcbm<4m`nNH;oL@4h_[?N88L2JLmAmc9EYN12jCZ?hp0U@3>ZAo[N?
R\:IAA6QC?S:XmWH?MJIMd=:Nmn;ZVbg3gNM474PBqf4W0B0ERNW2FOj^0i0`A?c
YRc]Id^b5J>62ld=jYBg00;aBq:4V0eJ6pYj@LBBKbOFL><XEY6L;X;bZXY^R8=Z
P;aMPY6^5[YahIINCc=5R0g??[CeW444W7lQBlO17T=gO?AKDBH`@NjL1LF8_9:G
VKLeHn2TA4Ma3@^hq<8F_0MOUSRYOfOVZV5o^7J=Xmi6HeRd:H@L_SlVQhTVP\28
aP9UqYW4Y2UXq>XO:WXEqn1jAeLTpZR3N2CeO`?@]1SGc8_`MS\K01A[7LfUdY\l
3>hW<n4VRKXVY[]I^h2h]5E`05Kk`qabGCklYZ:H6O<iQoRcQXSJj8j[[a9Tj5[3
\LcnUiWO7gfoiRBio0UKpl\Kl:_1qgoefJ;TKKDf<=^[h9GeSm8ODoDf=h]AfmmA
nYb\VD_17]8?c[7VT_CCZk?qSP<d]XVp:HcheEHq6@_DTbVBJXSEdaOejOgbf3a<
8EKX<ndDaC9^L05Ma<p<IUZ7`Lb`GYd0I4XHcGhQ^B8;6S_nQJa[BqeeWImbi]<1
@nL>54L:eOHL1T1eboGC=\O?b\pR@ZM9F[Pf4>I9]U[W;LHcDJ=4;V`?3ZicaEnf
LpJBRW^\Tq_2V7hS\NdLEY5?0m0[1aAZFG9KM4do4CDm1Vceh<2U<XAJlZGlT93F
B7K3TElZ4WEYakm=<3<C\;N?mlY4=b=63<E_JAhHkCFPPBWM3[kDqJo=mN`X:K[`
4eX]n>=XJ>T\`[I\R;dRSW4:in]_jlG]Idjopn9F7h_=qne4mme9qQc2e_F]qVOc
he`Uk]=3_U[UgfZ;JkYENY=6=5L=d>LL]?OXZ_?Zfm;iOh6=EhL0H\X:q7HWZ8mc
?D\P1eZjml2\V<G[15eb^0=8h4PA\mdX_GE;BnCmae`494I6N;7BAjbe^7dWRmZ5
VlRd0]T[nN8jYh`q4aA58d=[GifEKc@1N030<0aTN3gWSL]lYeLmdfjA9S3\6Em0
[8g<p0lmiLmoq273XEKgl:NT\a=68;<cW3QkYQ>PFmC9WiWh:ecDQE>L]>ZENe4H
F4cCYlR=>J7`gDSFbm``0C7=M2QO3F9n8o]n][MQWF_gKT7JcE>gUPgqHdb@YEI\
9Ue8eCET47U9]m^XWQmY46]l<Y<BOE4e;>E=Dcnph7^R]ioqUQ]?9=EF\oL5X93\
V@]0hjJ7K`lXW^?3qe5mS>Pgq?gAGEc[pPilZTMI5a=k=lB?Xa<90B^[Bn@>E]1;
b1NO;<h?`<DcRIhnCOQTKWjBjIMOMo>[B5^oE4dmZHlo?qN:d37bg3>5?d]`1bbZ
c`b5C9O^7MBHICJHQbQV=95Ha1\OK0cRd;jf89T=M[l`ZE0lqE?7<gG1E\Wa5EOq
a7elZlXpk>3C:NhqiJ2VZhIp=M;_UNLo=M^lD[5TMG4f^]aJQ4HX4n\MUQ1MG237
EBp<NS=NSZ=CRjmUQ?I^UkXZg^Go<BPF330eC]aqJ3GimGN<lh=:`B[1m?JC\IQ;
O4J7PFh^Il;WZ8q`B6jM]9q:UX\:T<ViBMaV;b?WI`hNV>cWETHGnZ@dACSU^Z\`
;ZCMDPq\ZgoQP8Z3R6JK:YU<bei^[o;:bmW?^5BK<ib0O`TJk^XL1<i<kL`<n_lR
MRlgX8YVB;3J9214n5bMAOSaZS2[UaP\72NdRR3:RRUIU]jXk=P4apg\ERZ[Dq?=
dR0gJp_W:Id7XpVb[m_0dfMMTmgdSH`aDST]nCeo3ob_?Gk>ESU;MLh8<M30YJ`I
3<dcVFGC5ok\f\Vl[mcKk`o_lBnNFD\C54A2plV?G2OOn]R:0[N8L<]\:P62UVTm
ajDhPC8EoG@QnHNAM?[8@2bVoq5aHXV;7qcR<G_=@f4aU6F3M]4ZKYE:nF5f[GEm
\iWnXn?oN@8fig9iFJ81XDH0TVcha;JL0GDBGDg6^8ECC\HaDa9GB7o]j:D?L8V9
KSNBGYnn>Wbf^R96p9Q_63MbndI8VRZnqkA4B7D?qUS?HbHnpVeZAFFjpDhFR3hJ
^1^QoU7AecV4hZn><_NF:a3Y@UU^JS\0JFf]FMd]NE;Ni@Cm;1K:D1@0epC^`>AD
1pI[5inF3poi1E81m\kMUneomSPHG8D;EM7o:SLJ30MU3EaJJ;V;[Z0@h^pK_P4Z
ARp]:C\`TE=LdbTYM>ZRUnCNHEMV3WGIelYB1kcJ<a3IPqMY=0N[_BF;g0Gc0PB5
aKEL<gKR:E?QWlGFHkpL_8]b?5dGfRE>5@?E1b2N7n:d]O9?Q3=5HKASlqIHSmaU
Fp^6XDUURYjf4J8WSC29=2iPd?R=kgCbgQ`D3n;Ak^c;hSUoahAbDJ8RNW:_:0aW
hEY3=0:?0ZI[N>bCcYh\7M1f_@5<4jJ^C3nSO;<@VHl<pdS9b;?<N7HMgf>p^@j@
XM6q]hoJhG6pblY]=:aqmgc\W>G`\cFGARMo:>_9dQiRF5lGAjTD4RC[>bnNbGAk
NjRaFBGHmMC0ofb>N2>9mDc\]dUdTE\EheGiQ_UZ[\pXRMOZoN72828Z6Km@NoGh
k8Ckf7F616=FDW6XJio@MH\JE1pW[_:[GD1UDdc`@IeF=d5Mj__dW^_R`DQQ;Nki
8EV9khhf]<1c]6^p<lBoS`bpVh4oKE;NWAXQ8TR1eiagSaCL4U25mohGV@TaH`FK
l5<B=BV4Qjb_OBdfG=e>8LW=b;UC9G5G35dQMYHhL`bD>1DD;<Ih:N8]^GlgZCWd
FMp8`?kBXjq0noV9dfq<5Z^E;`qc8IgF6]mV1KkBHJmJ@T7iUhRd=US6YLS810^D
eaq8;khlLHiVkCcA5]NQRJ_WMoe?3fLZB?Gml=007A2cWaZgY52=k6AA:Cnf^<:5
OjHmhDeXmM=6@;iq9NBjba@pZ?NIWn:q`E4C;Zcqn\8h>2b8Q^S?VcaPD?[C\QIa
K=GTAZ@?h:IFfcJHcjpcM4cekSbQl;aIOk4;@^BOdAd>OERqPAIJ>G4UO[7elO`:
BJaeZIdPFHA8?`LMPT:769qWheCS\cd<NY`TC:228mHJXo^ploh<PgiqVh^<>`fC
9;YKNObR1ENgVBSaN0Zf2Ygcon;qMe^VSB=p0@CP<ICq^AOgSaXpN8OH4T0hG4>M
52mH;lXNKH4?=l;QYQI4a=Z:kQEk?SkkCRJ=hT\h4]iI:XehmOfjNIOhZjSU9DCW
:K9H3BnIaCpNLKD?FF=BDfJ_bWJ;iWN2\V5`8VJBF\YFQ[85S7XZ`j;f\^\J6l7q
H>>I;E7pMDP`9>aeRlDQV1Y3GmQ5kEL>18?BP:`ddD2q4B2Zi_a]=YoZ`96R_5i5
;m8LnRg;Tim@DcZQ]Foh8WQA`0nad_AVIJXh9;LKpPZ`9o=apO7aPDY8qeR;\PkC
q<WR]3?jZ8>PkA^0\@kRPC;I>@`TYdGfC5ZH`jb1pC45mgE6p8M^5FJOgL_TYGFc
i3k?>>T@1J>9XJQ`N1=S<VHMeUMILB`@0hhD>jnmX`ZFO=?]=^:X[FQ2_g8RAICl
QRmG]8gZZ9Lg\XbqkIneDF6q]Qc7QKDU@aVlF?g1c0W>0_BJ9:FN2WA>0o9p]2<\
<;ADdf=[HJK=DHnIoEAlRK=U\f>1aW:_>HL^5Ao7CdFXEK_2dj>d`bIalgiGX0V<
QSe]p0Mi60JIq=FbZXCXqfHTk`l;pbbJPRN^pgCE12e[^T6a9B\L@kGg]n_ZY7ag
C2_CcaE=4I4VEhB4Q@RVV`7d@F9APMD4[0Wb\p:DYa^NUpC75JSNfn6bIdXhhNhk
`j25nS;3VUWMJFlm_`c36?Cg=BnocnGXnqMfK\FYjbW_DF6aPBOToE1Gd?U2WY4N
\K8=<qX60ldX]qO==WaEfqXDXIaHLqa;8c<>8pJkL`Lh9qdi_C<BIgJ^Q[YoMYeb
nF>\[=ljmO1;AN6VB;B59d;hk9GWeHIFTL69Z]Ac?L?d]5Z<fBKCi606^<2S>dgK
9OFh`Aad_8;;aC6gXLMDMA>Qe]V1X[j5N70TXkcaUTG\B4`<Ki?6a76oYnXk<pJD
<LmX4XAJ[14edGGnq_7T9OQQe8@IoKURl?I3dOcZNi<acqV^CeNmi=Tcec`_Sa_R
MWYf3o6l\h?@b]X?_@BhL6mlU2LJTpP[]]?H:iOM1baOIGD8Q[InLEAkW2ALccCh
q4`Xbb_T=L:gb\1WTjXF@>XNcMN1[aE2_;MD`C_fE:BM8G:Z4\j8GDMkE>3`XiFn
UT?jhoab<[a5koS9EV[f:oX;3WXmiUL8K6;8=1DjeUA\f9\Tp]acB;J3Eg:jJ\]\
A@c<E]BAN\XW[g2HfT6WL4ciX[Ibn`g>RLl8>IQk@DnLPk2pdRYf0nW2OQUV0<5o
d0T>8D=_H7dEGfHWHWaFE:HKLT6]=e;h\j0aOf28GMM\GeoIH]FV9]W2?[1@55[K
1;@9Ti=hHTF;:DH@bmG[P:H\RT6D=e;h\j0aOf28GMM\GeoIH]FV9]W2?[:O55BX
1d<K8@A39i?6N>fPR6?B1Tn19Y=M1GN4\HcO^Mq_ZSYhLfp\5W]fZ3g`7eQT7CZT
hKf]\>]]KhUVHoIdLFoO?GbMA[08_T5DnhiMBmBCS_@lKXqmV5NIlV`KV6ocELEa
5_EnY>W1`]M0nQi5Rm0:TXdQW7KB[X:_g6Qd8]J<deoqJ`9em\TpcXQcS@?l@;bB
6XBnoYKXO`AJN53Qa91gFjmnm4];ZllQ5dm:k0_fd]EI@YIE;6pkm\4NK<p?h][h
67pWET>X2\=3BRGHj4\D:CAXMo4UGgeM040CTgpDcj[]hXpD[m:nnGF?5XR`gk][
QJR@\7Z__L<AU3[5UY10]W47GV39aofoY5;Q`Vj;?56LSq\4iU[nlq\>MQGG0j31
>b9<1[fg0DTL`NCgBF<A=gjcL^P`iA:YCTklRP3ZLJdG[h5jIJ`XaYdI_9BOAS_R
E\`[KfT<;R^HJ4PiK@]IbNEKmjP_SY:_MA9kfUV5E>?<d@=H5379]j^W\HB9P4_]
GGn0`:Hg`e46B=>M>>0Sd>TeL@PeiAO<XpOjm7jOfpN=``UA<0F4\o]^Ij=>US@`
;NLRC>4]0T=bKMokmhm2EYn^D;^o7G?KZBk83?TGRVcNGAb:h;8oG40@Wj3fdG5D
8_BRC>RV]PKRY[YaG8MJ024F:CAg7=><`e`[66NeGaNd9<e;B:3cRTW]1P3YdK58
2_b<CdLULdCSNiQNN]gl61S6WFgI@2E_`iJJ4@TkOGUA94Qn?lLA\0>\T3Qn@c5H
QkhmS7QiBWCSkTo7oRI5Vm1RlTXX_Xp0[g?X\iI<aS?8]lI;VF`P?UM\V\ZGi6n@
]UYm:TXm:DY_NopMR\ijbhdVFlP4:6PqQ?nJC\FqZ1lfES0q>AKQ]iZ7YEl]3>5l
Y:IQc[=A9nT7^T6F4oFO]<E6QJTF4j?iWQnGF1GIUJ8RpHmE=ee9pLG<3eUEU7me
5lY<GOZRkbAc`XCnk6`LnXNb3pS1MTfkFYiohaL5F\=7NG_QkeB5<^4BWO;0Afq3
^WW`f6<j_7<0=RWX34fW\OE:oA]8f167?WF5blFQHilLgfA13;JMVHEp8CDD`7a?
46[^f@a>NZnV<IU1Di?YGCecc6^aec2CEiUj$
`endprotected
endmodule // module vusb_hs_portctrl_rm_fifo

