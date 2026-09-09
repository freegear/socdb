/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_up_int_busif_bvci.vhdl
-- Date Created: Thu Dec 21 22:43:30 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_up_int_busif_bvci.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Vusb_Hs BVCI to Ld/St Interface.
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
module vusb_hs_up_int_busif_bvci (clk,
   rst_s,
   rst_a,
   up_endian,
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
output   slv_en; //  read/write request
output   [8:2] slv_addr; //  address bus
output   [31:0] slv_data_wr; //  data write bus
input   [31:0] slv_data_rd; //  data read bus
output   [3:0] slv_wr_en; //  byte write enable
input   slv_rdy; 
`protected
adcU<SQH5DT^<bZiI11H1U>Ym<`TnkIUmlK`pAMOS;<\m@hR`56lE6=bX6T`pKj8
o\B[fCRRJPJPNlDA37fO<al4`kOHEAB=ihXFH6\2T=5q3\K4cnqhiYN7UhVP@0f[
mQJ4_WMqm=:X6CO2QZURLVnkX_oUq63bNjBMQkXn:0l[A9G<R]en_5o[0Mf<_P=p
N[X`X>P7o7nd>1O=NSpm80CY3emiAWm]gWGRXpkdB9N80RBJFVof0BK06@gAf>jB
eO]J1\]4p6c_4`XGe87:_n[=I8_l>\6LYbJAdCImb]S[0amZq^OUYUiLod4Ea:]E
=W?nQ^gFXfWbN2af[_`?V4B4M0GKJY;NWB66YFIqhR>0F<YCf184fkXJWPm0cH7m
m`j2h9nIg\gp`@NP@RmU2_Ob89T5eg8AN:@X9VD>T3Bl5^dDQ5pf>]=4Qdkcmj27
3Ja0ae2YMX>FBoR08`h14kW>?Vp3PnP<R8d2idV_k\?flFjBT=^JHlGK?P4R2C:g
XH6pd5TbPS74R\R9KhNaOY<=XS9`3XRE8@PM[P25h?4Un2qbOl;K9DU25RkN9VPC
S5\KSBpHSPl5Q2;ObI:oFHlNl4Y]iU:UfbFib[OdeL1>_D8dN5q`^j>E]B37=9nU
OVoA35_3kME`T_0@H4qG2MohKT5A[c=NIj^1EnbOa`U_W<H77?qXZYJY6YXoeVDK
gdKiEPkpoAjDMUZ]kGhD^c\Y[WA<a@]2:P5E8<nDSSNLi[cGS3nE>>ZZN?0_gkqY
CV847QlhXNdY8AL7nSL_nn718PhG:Z[okpGlRTnn^FncGnoP;QQ?1iq_VYMEX:7:
Kh66LeINBhUcmSek?p]2o;ac`91YXKDBof`<J7mLdpiPLi]b^CI5FOgn0eMFU8fo
^oYV=]Eco_3U_ZHhRUL_6\jd3fK7ijGP?eYIdNpiOWZao2C?7mojeR;1h36U:RkI
\OCSFk:Q:ncUAm87n5j99bjEm7XpXN[;<CHHbcLLLJO7dVZbp\dC=5_GIekFH7BS
VNdL4_G^>BnoKLl>2>KbDF4H2QH^?`[hckU3H]8aC8iXb;<fpgl5F^:JYL8I3@gm
]]\BZZKkip?89Zf=A]b^54_k\Y_GPWpK97_iDfX\^mYQBD_0H=a?be0G?d5;i]h\
iYXWUoG5X7?mEXLUS>6Nm1SDUZN9B;pUfQBj4GFT8VeTG@V58cbqTLjmCgPVd6N5
RTe53:X0pfH68;oDnC>4Z0_VFDGc@qFeM]2b=7^gn;X@MD2EIo05>^KD9^1b_>UY
26<?K6U0_qdQg75DgYL[0Ec``qUi>iE@jiRm<9`9i3c6pS0b_Ln21j@oCZJo[?]V
jDD]O;0onRe61l;[RgA94Wk1kfdP;NIpSmkOc9[57fjjmk4c?NZJ;J]\L]IOEM0d
pno2kRbF[?o^S3[91YdSOmT=pG1oD@W]LoOLJe35CPb@f70:PEf]kgQ8I>N2EQ32
_EbA<1B0`c2WIoU=9^\V\V]9NIJcPcWq[L?L3FRhfE3fl1gOCmOpYK:8Ram1F>O8
a`TTeb>=Z?DnVTala>:C]S48c6Kkc=0[F@7<m]lpYnmf7G2H]PR\jWAa4NO[92hc
:9E3>WR4WoI>Y2=mI`@DK1Kmk3c4HNjiJPglO0qd`\R7KW[SAASeH;Cnn27G=9H2
UaIWj4XQ792bbZK@WgL65M6eOUISR:o\TDhd`qXmRF323jYQfYakQJpl5DHN\QIR
PEeN`F2b?8p4cJS:IC\\KaHKZ_cfD39je\PKTSQA?Ec\dq_;c8=Z\SGeXU0fTEa6
49hU:inaUeOgbVFZ0pkXM]e@di=DSlWDiemhjUVMbaIi;l`Vhj`8oApfbV;J;1YN
oKAdIGgFH@lR79PIjWfTg:D90Ykf[o\8GUdm7D4ILYZ2mAqdYXh?6>OXG?fS]d^8
in5FFhZiYYkVkU0KF`gqIC8b5ojVh;iXbUA`L1[U>[NSBYmC9OHL_IqXM=5bNLI5
\YlcMKY5IGoWJkdTY1DFBFUP?5P0hqnLPjT22TSLfaXGXXI`3X]?CTbSB<2Km;\m
qjOVPQI>pj`Hh4df7E\7>hd<5?=E9;hc2D2\cB<@<gepn6ZWUllc1HG;3M;3@LnA
@<JZ?XHU[fXbZYgcnlE^gDM5QLP<UQC1Faj?JClAm>gUEXT7IGJCPKWY[N>:8bq\
=Y=I=98EJRcfZ_TkD]NHBb;LTb]O`Ti=GbSmm9^gTO=@P2:X1p2YBQbb3;=Q`>44
]moc6TTdWOfP9I92WApGN]eTPdf7m_OMf[ESS3B96^gh9@\@K[clopDZ<@XcU^Q3
W?jka3[;Zb1h3kA`=i6jWfmkYkqVOb_EhI@W<c<ZE4HIdGbk2BR520^oO051WpT`
d6O:k_oEZ7=aUH`bdn33Y6R?BK:MjNnaa]ViPSZSdTnKjA1K_QLOM[>WNgI8B2NZ
bU=T4hZ\bn`==VpfYbK<k><l4l7SC0fhA:7?IN^I:I:@TN_4mD\^\;ZQUX0TDWmm
[^EV66VmmM_V9`Kof2E_C6HGeoK=F_6\gQ5PLNf?K>qcSl]K]Yp\SZCIVfp8Hl1=
EAQVV44[?loR3VkfNMpAAM5fLmpPSAlASTVBNm<105J;BSTbO>MP5oSdbX3aOp^b
bgDn=qbhiXjjCmfn;`V52GTf2Ull5gCCJ[k1Wk9lpm:0d93h;m50lYPH>kI4eUQc
AIfRa\=FNRFCcf`L^1J8<Z>17Hj<Z;G7EknPLQG?R0d\:<``YNQLT3VNA[kq[i_0
2QQ;Gk]0Cl4^Z\9efl;3=hdJmYghpn1e0>b9b]FCY;gD;9g=1I60h;FZjgBe2Nf=
SCTh=14modXi9V]=Tl5ANJG:D5o:qfoS]ZO]c45QBh\1?aTi4QEoT9`>ga_T_bnp
0FFTO6H7;ZAkI\VJ613VQCWOQ\14dLQaW=B1p_37dZGUU2Wn9mK11]=A_MgD4P_I
NE@cG6GqiN@[U1o]NIS8HnI_J\^MTdRCbHG;hJ83Pa>Ynf5<NYOLWFm3A2;;oV`Z
jHFBOf38M50jo?hfV@cCGl>Ap;TEon]<?HhBFb<G`XObKaOZN]T@K`1]d\Na\U;Q
W8bZShS_eP2RZ[c@=@kE\bIPWohj<VZmkKV`;Be<M\^4=`GZcnA2p?^K?YSLpcOD
HnMGnnl;eC1g[Sf<Lo_49f`Y[i9<l4E<cRD61pL>bQk]?q0dngA_aqUFmW3T7feV
3O:DS5Xcf3\a5WS?jB4mmL@8\C0n;iQ?NR^R6>QD61Eo9mZ13]IE7HUFmWO`Bd2G
FFP9A4Xf5eHaKWEQ;jn^@9Z76l<V`qcfl3IV4e480m\Vm\O5Z=\b<lH^UlLLDYd1
>A1:n[ED8>4\hincCi[:Fll4>d:PD>c7l]@5JmF>i^Zo<_Vg9=b<Hp3lEgHA25Cb
RX3i\_LPO85?[4]@`@FkL47cdf6WOOge=pRoWD`M\ADNZDHBKKP;48YOYI2hE>I:
hXEQ^7@LdLIXXqUFZIU[[9RTIRf^@OibWMPKYGSZcHLHJ;oQOOnK_XambpEk9YCm
ip3SmZ_bU^UKLDR0_R:jHFZT\`HfofHKNpGR`K:[KUM>I@PjonCD6aUJ_Z`D`blg
IFplZ]Vd[6<2eLMZ\_[lgS4bdJ:]PDMHG>qoYSfaog]m]>gi3J9ce;F1HFo\Pf4Z
Ik2T1@q7MRe`DHq09896m_9ZhAW;==mTheZ7YWSSb<AUhq\A2CT\DqGQ]JN9mJ6[
M<bmcUohG^ZUc=AF9F;k[lIPIl?24I<Pa>]fa?Z?2\qSDD;JjDpkgHO]Z=pY2I]B
VY[lHQh?`@eNi1ST2N3>BoOK7_MoG_F_7kFDE?XM9FaSfVM`O\:;UgebKi=@o1E_
cgK>NnVMb?QpUKco[9Op<O9_n^LqCDB\i2VGIH5<Z?CI6DZ?h7QfXC2jGc4aMoJ0
:SZoCX2CYm>[GKNgH<F[p]2eD^n@k`A[d_GQeIA7?34Ue3o2B<81Xe1OnU@BjTbq
5d1bKkipfLFPHiPlnkQO[I?JDikUc0TC[H210_]0L7pi2[_KP3ZU\?L:IBVV\aoA
25EXP1`_OHoIBl2>U61W;RVP7Y5AEh5EikioE0];S8gM]Za>e^<\mYYaL=Mp`ohU
_kgq>??Y9=LaOAN;VX2en_P9m0:c`j?LIXgbI??PZi8Xp7`]6ReKqf>[IHc^4l0O
]b<LDHU;Z^ekWl40EL2^=mCYG@]Hq=@KE>WN13I8L]cVDZ8C_d<`AnX:Yd6?In4C
nPc53QRJpkh:4__cpI?NSo=W8PahDKUd=LXlEYKS;JbfC58d4QIpG?8:^:aqlfYF
2@VPU1ddK]nFL?hcCgc`9<mVCL_Vh^J\bVIFp?aN>LSfEb2[BQ89_TF1o=XNHbR0
d0lM6kLmTR=UVZ9WNmJ2[qVjDmB?Iqe[iX;6EK?[IfiZ\o2:>\TNN9gB[H?6foTY
q2S`Ga?cqPP9QS_NpaHKB>b3bNKJ5SW:18o3>U>aaoT44NhNZS?:Ti1fQ<GL@<d2
SFfY^UY^WQ3gaHN7=FXSU7dWVp=hJSBVUp_=HKBOmp\Do1RN7Cm8h=o]4>QX3j09
\LMDC8V?Z]oSlYqG8Cc?J9pI8a;@ITLD@A\GiZ[11j@j\<Sm5<6;KBbhWq>ld0bH
iq97T\Y\5Xad7LTjT[\>=pWSDeL_eCEQako8laFSMHXjM0eS<T@6L5hi?ain7eVN
<9bGIqMl:@Fc4pCTi2a[9518Sm0mU^dSGUim3CD5kji`Uo@Qqi<gDe>0pKS>8@c[
pPkZe<RSDbcL<f=]=4<8RbHhAj;P;@Vm45GG1B_a3`=CDiDR?37mQ@=`O_M78QWc
[PHBjqlSmGmTj7JU]00[GKnNQ2N9Q?J<8BMMUFT?KVGQjq<\7>Wg:phFQ@`SKHnU
;8eBeKLF73e?6aRGajW6Loo1KaOWpV36gD`a16UkH_7AHc7Y_MfCFbGN0EnkA`;n
qG?fObAMqSBZcUO@1`bC[c7BkV0jLQG_;04MmDOnbFIZ]pUSWE9mbqJfN<B7Ap3i
oABAk1>Gim4iB<jTB[l35MVWc2]AOcid8?m=RbPBBh^[W4ph>?6JCTpgCb1J_QpK
FY9UlSq@`:QcEkX4g@MlH[bSB^BLal:ZofLF^JmNYf1J[?U5m9hmonDh3YWEO_58
PqOS7T@GZ3EKlnC7aDmn]jPbnFUk1Do2annAIoRj8fMG9?l3:MP8YA[eXTHcF9LB
n\XkoD>8nUh6:5a>IDe9NW<FJ;l`3KmAq^PbfNkSE8HfLf^8S@Tjch<2_=:\X<\[
MPYl?3a:K@4[@XW8N;j7abHhJSNikQB3\l?2ckFclgSbI`>iO@_44p1?6DT89JHe
69V=3f\_[OV]5Q[GmiMgcO8^UXq6><LMC^SL3Jnbj0:3^eW:YlZaaM^Oj4X?9qY_
6OE49GGNL1:6SHmVfKE?o?lC<aE@TVI0RP]jO^j_lME]\Vmn@;1CB1P4A[O:6]2K
[TTeYqoLPIZkc\_UVX<=]UOT?ZT32LPlTKFc6PhLH4=JpG=:`W7;9AE=nUX]B>J`
]g_MV?eF3\^:2\2pE\BIOVnqCDCg=n2>cmTZ4G;C2[GA?YnBcFjFLVTRc7qin5jV
M\jH4BCl<Ik<KV?dXcWodkI;jCoiO[RBT?2_m`_1kISU3Zd>489FC7p0WNVT_93D
B@W=RSjaeDB9LJOo6Z]Km_b9<pWV<bX\a7jN@IDk_bJo`lC@8KeSN:WLZ[hXR\RH
hAM01<=<XP`:h84=5KN[\XDh>VMJXEnjY0>A9ahgC8cV<JCZ8`;J9qLAnRZKhqYQ
0fP6nqQC=A[kBpSkjMKVT4fB=N3K5\_;=hn[POBm@7CSCM3aqDNUXYHLqK6Zjc`R
_QhRUEJFC^Jhoi7l]f`^5WjC4<BpYaK3]5mcH18XOHS`B;oDE8k6HQH`;b0n>Jp:
I8?[6e\[49bmP]?Im02dSH[TZ1pj3f=TRm71TL_J==Q0Fk8ibgUID3:SAkWc;XS@
`P3ES\Y:R<Lk<hGMMg2CYYh8U6C12FG\B\89EZbg\\QPoW>JCg?O^Op@]:JR:9p\
>DSn`<CcbNk3hQNZD<NA9e\:Fe5UOB8GJGeWJiLRaghT?HabPLh;B@gHR\eHTlnA
XFni2>Gp<[n@@eDpZf<Z]FXl<nA>S?]\h;h9V67ghBTaa57`c:82@7GTiS=8C0Sd
HL\48Ap]YRL1gRN6lLlELaJ>M^cVfT8ek5QY^9^WTlo>ZPcN<TlGd5c6ZGXqjgff
>Ya=aYlZ\4kbO=Lc>MBF9BAdD`U9dW3dnlULg8QbLAo]@XZ=4>TKQJf^JRWFX0=p
87GhL6`kjj^\a@Rn`4;OP1[YJiJdHldUD6dlGP?m[>`K=^[69jJP<`2N_ma417E3
8bGlZmGq9^]cGlS[8L1F7YoO00Q_TQG0M?WZCZ=eRNh43\@pWZQkGj<pe?lfNk;A
Uc1X0mNd2T9mfTn=o^3:90]?n1[65hkp=k\FDCTq5HNO@]Hp791H]SBW`]I^D\:N
U0qPJP[\2@q2bOQh]jpNOS^\5]2I3N?^W<=2SKTfod10Z4B2Bnbm5O50o9LPjd>d
RZaP_19jULbLZgDqg<Y?cU<^9E@hoG5[CoHcb]B4LYUhC`;[7m>7__<DUI`n[ndP
eGlIC<15c>[^U4:4KAl?XZ9OSVQSRoK@:@7=hQIXin0[T9Bd`iU1L:XXGg<c6DSq
c3841N3?FaA1a0gN[nDe19YDNmEDfBajB??Mq;]3E\D<TCMAXol`Q@42AKi2AW]5
aRYn;VeaC8KfgW6pSg0lF49J2;H8[KH\_IS?PE>8IXPK=5o7OLVJbhUfPj^9dXNo
8UN1QJQc0iA3;hn>KT?I;XJlM`oV[^_mHV]3GjlAXkZ[9TZ@\Ai?:6gCi0MGqQga
i5Mi6]i9oLUOO\jXiJZnXM]eWkTSCOfVoi>oNbnnBYMXkD;lqUeMk?SCZjE4:=`8
AfAcJbanAO>Qg@fCD<;1nph7jS?I^ilZ[93=6eQghL`HbqL:ZDL@6?no6ZoQS2GQ
\8BfB`RKU9@i_@R]X8LQ?:a<nZll8G<IE^3B37S^^Y?G^TL2k6UOHJX;B_N5H3iH
ndZZZS1GN_B75Wl^c9JW@`ZGJM9:\FqLhF2hJ@AF=RKPjm\AR6DpfUKSOKhkQa7_
d;OI2TUU@AoTL;dLkBTH0;fPXV6J4aHL63KHUDDn5f:7GC8elkifRRR5S2hmXI]`
QSmPX2e7\X<94Xq>S:b0f=<`FlHRGgJXhgh=dh2<=05;7`7K]P\mj?k1BB7^F7P1
nSb8hjif9doabd^oWBhSe52@4PGi[K\[XpJGN^h3Pn_cX8]]CnFa?V1bRaLVNS:1
n<D:^jGhL;_5YW:<RGVnROp1B<=C9Y\434me<iMF2VQpESgblY]9d[;5Alk7h\TD
1M[omR>agVA_VS=LaU5WoeU>q_@3Z9QGJf_ij[6J<B]:g[:N0<N9ViG4EB3:6f6U
jKb=ZW[NoIoBlmFo1=O5?MlE^>6l491G@kSQ@eeZag_HHhE`e@Z^pgb@aiiXkk7Z
nL^fCPe^^62J[j;Wj_[D6@Ll7JXZQEJiQM]GG^0mPWdlTNJa_YKOiH:[e6^Dd0eg
O?NgSF:qf61h?IFhH_J813na_Hb5`j;bB]E:@k^gDKcaBL7:gIa@f5IR;jjqK9@[
PVC60Tc;mZ93m<PJ<GK0@?A@GODkASnN2j^oR17>lEGq1`KUM8QQg205X<>Cqh>3
=b`o;]66HX3c1R@SC`Bc>DYlXO3N1F[3lHo0FOV8Tc[_`=S;l3>Ik\768jg19e1L
_1EoDJ0\0:H[?f[U4iZcUL]H^F2p7BGV7JD^VVbXYaT]mYXEQcZ?j:6Lh?B3TY]l
9:SEB0oTb9X70CFQEEpYO1oBeW5_2W1n@CBR0qI\1<aVM2O<^5SR3Q[YPP0P`3g9
7_Ec\]:?^hna15V_6I=kb_K92kPBHinaHWVd3Aa;1SFFM1n\>iOW=HP=>Z[c1Y\Z
ep`B`:?4FFMJ<OaeSin7<W\YYhijP<bo1>k5B?:;ZkN>PP8:Gp_8_fcJQ2U@LWjM
kN8JYL5^8f8E@0>bC;Ad^ig?^S\B6dKi51E^KQ6TB[Yj@k\4jilkYTLWGEib2@95
acglqT1c>KPK1^22]`Yll9`0X\301RaWo16gC>7T78mLm9\^YY\jSjMPpS_7f[81
oi3GW5OWq``8U9A\FnnF^i[gT8BCaTiDV86@02;3L]kcQMe6H1=JAHdPBZKI054?
a=3egJ?TXiP8kTd\GnjRdI^HKOdh<]4T6kAPD>H]8d`@_n=gRe_E0fJOZeX7<dnb
p9eNjW@Q<RifDmm5G:W:3=n\:2f4dYDiQD\faXMd>B0Z_SK54gSd3i5XIAQ\KPF0
<p3YDdO=DW_eOTLS8b3D?21oWXj_P;q0;XAQYgRYQAS[=Y6jDe9Bn6o^UZ]HN4om
B93oh2`7j;<^5ih79?>=aR^CD<iWWKflBXQ]3Dgdfd2JNYcI>:h76WD4UFDDEia?
<`jkAG5L1fi?0pVD?2kHU]>H2Ao:^jaHM?oKJjaPh91d^6M<CVl_>^;o18GdB77Y
fXcW5@9mA_NlR1qLhP9[FYmR5Y8<@bf3J;F:YZobmMmHgnV`SONZmOIRA;g2@3SW
TP3aS@nLLUQ?jPokKcV`E<a]4RoUXClEd\pcM]82K5l4m\<kXNIR@5UDHG0\3P:c
Gol7I15BKV\ecSLj5`?ca1@]F]@8aR?Rl0[k8Id3>5l_YONeY3I3GHIFC0a3b8Bj
;@pBVdhaAAIol8^Mla_ofZcCYIknNIG9I2RkA<d_CFBGJBC[6oMNWh3JIH5AJRj5
AlEjG<gB;A[jRIAQ6lG@<q3Vh9NiH@::?7^L6h\Nf=PYDogg[Ain_JiYOnoEabHF
e5^USmJKQpcU^EY=IDffDT4WI;qe89EfljM1`3Gn41N3gX]jL@n5D@NB?_^Q]gpV
:dQ9dRkfAO@SIP3`7;iIm4f8Ca\e[jVf^OKCkN\`?FF]3ZnoVia5T=eB<jZOeL52
;e0ffR=d7I1BH64iZie0JJd7e:pM^>E06YYig\HOLI]^Hd=YP9ghP?1^o\_^^]FR
H^^B@\QR<CnPG>q=L397IiNAPUnO2n\_F^6YcndZ;1>GMDhdl@JhVlG;XVU09QJg
WQaIc8n4gTaOJ2o5nS;5AH6Wop=1bMPa6Sn1AWMlLTZ5[ad8CQHbeH0oY615_9gO
A2jD_AOalBpSjIN?HE=mfa>Q0Xl1m8P=h@_dImZW1nVh@PSjGj5:G6RNTfRPRmdg
2f5B:In_Nm1p1[MMlei]1NF69gU@[Ncb`lFL`]AXpFEm987U[aeFL2K35h?8VEk<
HF>9N0>0@Hl`@0_3J]0IjmcpGJAZ0[SCPBc@>:hb:eVSM33IWeTTo?]J@[X3hcE[
gKqVAQhkVjGn7hlZQ[ZV=>MAG:NA2O1MB<66_JRqGmiFgIJ^NQbRC4UqoI^0TJ=C
CYKi<@25g9>IQ_VKXf^HZjjpUk1:hjUlGh1b=e;V>N_=4;kViHTIoQ:BV13KbmJY
oY$
`endprotected
endmodule // module vusb_hs_up_int_busif_bvci

