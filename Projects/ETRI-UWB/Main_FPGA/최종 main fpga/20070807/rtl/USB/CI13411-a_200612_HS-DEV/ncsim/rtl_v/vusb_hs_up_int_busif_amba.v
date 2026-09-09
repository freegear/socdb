/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_up_int_busif_amba.vhdl
-- Date Created: Thu Dec 21 22:43:31 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_up_int_busif_amba.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Vusb_Hs AMBA to Ld/St Interface.  No splits supported.
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
module vusb_hs_up_int_busif_amba (clk,
   rst_s,
   rst_a,
   up_endian,
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
output   slv_en; //  read/write request
output   [8:2] slv_addr; //  address bus
output   [31:0] slv_data_wr; //  data write bus
input   [31:0] slv_data_rd; //  data read bus
output   [3:0] slv_wr_en; //  byte write enable
input   slv_rdy; 
`protected
CHO]_SQH5DT^<H^hL^OdY?CDp1?D[Ji3U[B5G1;d<R>p8?3PS<LCM`RiN34RGHc\
UIK^f\X8NN8Kl_e3jHC\Y?J5XTQ?1mA_o;9^ZYqDmM1\0qb>c1bNhFak_`6NE2H>
Y3kkB6Q7J]J`0>kLip4SbjOoV5LZI;]dF45@\mHUlA0GqGX>ij:b8@7ZX]iD7]<9
mSEI5AcgNbl6HqWI?lJB;cb8:URMAiKaJ@A_:kf^[]N>0HLXD1A@?D2Q_lWV4j6W
1PgIcIbcdIh[HpFbU8h6CaPNJ?_P?[_7p32eBG_Y_eG_69]XHEIgQP1V`N1S?61B
5]>qe]N771@jQC]CLXMk_gfba476>b^D@obKbiGZfe3p:`H22oH\3JToC^ofK8:l
jAg:B9]Q^O1bCN2qM>WOD7GGPGBOPZgY@ClL58Jd;h0T_AMfVcaSo_HV1:UBj8<9
c@^q5hc^>23C;m320efQ;nW47A]IpFRU?_T2`n;Ni17kNc@0W=?X^S>lC^`q6oNF
c2I0LS3GQkmSi@25CXS@KgPVE\:?QDHceS77j^UXpBTW`8bo7He59?R``ej]]h4<
03M_Dk^n9XWYoI2ZW85`Dq6DbjJXS@SY3]c\dSBADoef3e5O9LP`6Q<<QT:F\3]9
nqDNW?LQ<X9QSBf<[L]=DnTdRY\HoAO3kkM]L0a>^BTNiHb8]q<<9Al0WV4AmHkD
[<oTcXoNbFC;Y@X:7]2?HkfU\FO;OqEL`cF^bP6QElQ5R_eLM99V6An3cA8Ye_b3
OB=Pb:U0<<7<GYO;ISjiZKS=_@en4>N;Nok`5@q3Jho`WW39D;15M>>kEYBO0EkO
MdAOgQIALW?oISF05<dp0D:YXjFNQIS]\:CdU?YC6QNc^0`^`TPXF`OjA?>H2HZF
q@d[TkKojAQl?A6>a><cDe54_C<bUh0B=H=D=CTjEfh6Yp?3BXY738nj]YT8SZjK
0<G83o7JH5j\n=D^7c=dmdoI6qXV<d]ZEl4I6MBXNgjVe]?XBmm:@OM6lm@LVPBW
f_kM9PhA\D=67Q4`qZTN6^gQRZGOTmGS\HG0>gJR5n>lXR]@LnhZ<NTEi;gDX_F:
N=fSSLg4hVPqg_ZTl@W=L<[lUL9B]>=jK6\6BgCpUjo=Y:dY2EdXBG6J^B1KHLl>
>Foi0j]_T3nDTJ5]^N\ig0K4@Cgjl\=CmnqEWSAMY3?7?hUH>\A@OJcGo73_V\\6
PW@hKjZA?pIl;8TniVSN_]4ADSQ]7DHRMADl3XDK6C>d]Kq]ie:Hc7ZGJTO:J5_2
EW]]Bb`^hU\l94TlUAhSMWeQ=qZ0REMDeInP?_U5@b7S_eqiDXn]_:D8WO`T`PPE
PH^?V\X79g>aeLB`YLC_Tq=38QLL[KBFYC0H:X6LGkHig3AMmjWSA]G43p\II:S;
QW4JVA:;]M4?:Jajo0EGWTgg;;5B4;B>aVj9q?ocDd@JBJW2Ze661:eb[ONDYD45
bkc1XWh^G0H6]pQJ;?SUSDF>0CS`:4=I9J=mcN:nboUOPZE75fQ@Xq6dnd;O<aU0
n;]4ee6^63fabi[W7iM2ThQKq\Hd2ncGEHTf6;Q>L2IE=::nDDmQ:p43A`\WgOW2
PEXo8V?`4<IeYVUncAE\1qL[3XE?OI4Sehd^;U>>^9>1PI?dR3G`FWbMq?loWlQ>
pfR\41Z?k9XI\Q5UCTIkR20=iCQED<N;mB[D5=nl91gOcmUUb<m`:<mpC0d>X=J7
FUDF6Yc3dhN;73`PbPWc8g?Zj>0jH>bD3;4i31pW0S^DMLP_DeGe_\BZHZ]EZ678
Rd3mVPBWEa]]coMa[j8Y@9Oh5dqf=2G4KelX4PGjIXJ\dLQ1;NRT:YURTD=>epmT
U7Ql6WFD0UbLG=o12R[=Ecp`d8Fj9lUn0M5mNVoR^oig=3WVSGaa41=_S4\JNgJ=
lp1G=FR\@AeSC5?SfgZ=djjG>daDc<CieJ_8?49N8q^oAD4Q4b`G>H;2iR?5KhV8
ebWD]mKI\[bd6flG47eH11q76>5I4XcgDQ5ib_0dlAL5OY\QO@cG<IE<?bDQSS4^
HgSq6bS]8:?pZ_Tn7Kide@iA^jTe45J18S1RaR3cF;IL6F]V9LLXdBTZi6O7E;Kj
F0agU]?pD_o>HZPq@IPe_:WqYhW=Xk\e^FbnQdi60R>QDLO32lFeJ0c6?EqH4\ni
KX3V]M>TngaJKf]^NO@0aASd?1CX03[3^2n3lEf>>8[N\J0mDQkbX?`D1f=N_IMV
MpKnFdFFCpS3_EOWAWNBSOWhI6;aeO\WP]cKhU9HXEMN@0@>G`5X]VFi3UQnOThP
p9nAo[A6em^eomjPT>>`Lh^]k0DBQaYQLD0m5]IRI8YZJ37pBP1b?1lXch9[c3hj
Q6AaVHBQ\V=:3KN_K4CPgcOZZXhR8iCmb=VpXhoLAlFJgN5<LgCF]G<PeUD]k?3f
^P36?^pZk<3CRI7eF073;LOVZ[PlR=TCT<a<]keaf?H:AhaY^pR`eGiNE:R`JZa`
[D6bIP[G;DZf`7<c58F@BL[LaUEcLFUgN[I5VFbP33]QmJKJdR_1qOHc]l6I1biP
MPT8^dX?_YERV_cVkf@E<Y@9O<JKqm:ReKYhNfW<P?^H;DbkXDC:;S]PPOSlY;^g
b\QM>LdOZqie;NnA5PMP1f5_39Y[;2>`fNWRRd<eC=\8oK?ZQ8]Ka@q2NN;TY7qB
\DAWS7baBjE>==<gVBU>gk0g<l7<I:KK6Od8RK>]Ze=DdRii=Bjd`9Tq3>Q496>p
X^f<BK=p`09OEQmaRgCHK^_S;:?dT488\Kbp0E0AaV@@U`C[>M0EEf83N@WRW^hZ
RaJD9iqANE\`dVi@:X=5kULY>]O<WWp6dm_j2^qGZ5kmfClE6dOVa`1@5Q;>QmL7
Jlh8o\Ti\7PVM2q5MJPI8KdHmE@<>Cl6i;kMi]eXG762:SdTEq;[djN8>_[\UW:D
59fe`<4W74iZiU`GNel2EJe5EL06qnB2hC\5aY\P\8@A6SDQN@mNU6LJ8YgcQD?m
\@CQDhVn>7]:D3c98NJh6:V1^]QnTn`225k2q^Ab:QFR\R<SB0UMUoYVl>X^i6?m
`lnfUnUUUOJD=W=9e]UOoUgD7T8ChF2eP=352fC[1VTTolRPcel6QhCo3;SDq6m<
W34RphQF^U;T?;Ra24HonekF7=;^fMOJS\0Z5mRm@MaSq_f:_^Hgo>Wnf7D=^^`R
_lTWa7P<^JO?W=NABSEJI9^h3<0VaWJF6j^gPID2Rh=N3HF_XC>E:pU627YgU<;L
;m3BDWJ;Z@nEaXTLcPdM:WGTN]qHb9@HDC[9o`g83ZDSn3;_f@W:3oKK4ANmcbX4
mpdIXfCj=qY=H1jEPWgGaNN]U`_l>^DHH0mgUm`f<UeX2VfYNYjL;6I9LlfP[no?
pf>h0F0bqgUnkmClC<fUV7Gi^?TA`YeD;I`of<=a[@@UdI:S@lj61ToO]l2713gY
RCH8>DEoVgFJ8p`iU3B^8aAnOiNSe@\Klc@E]c7S^Sfbm1D4_qaScXK[2pEJDl;Y
2pbObkeiG>?VlUnDEL1:bF8=`6]Qm[O>kCf@I`QJ;0jB9^<75DHbMH;j3pF4TRGh
4qBQOb=6=3g3nZD>bkQXggLf=f;=0KNY05YBl1]b5W3l>77bgQ]CmASPKRGNF7VC
A>BBAWq7LD_[iY:co\g[:M<Sl[gIBfjFc>PIVRY\cRW^:_54WpTk\S1b>[cFA@c5
;L@SLolBRoAgiL7c=kIcqk`9[Ij=T\UKGdF<hNkPR[b@b;1aOEKmYV[BFd9QIhne
]D3VDLI]\OG?]Y9WVlYNVQkSF19<8T5;G?Lgp9l`j@E0qD3g]4li1iQfFfo>kM\l
8X7=10iC4WaThAS14m6OoULT]l=hLiI@m98EqjNL2n^BT0QQ_oNFNO6ZOjeV`7YW
V4S;[A2fLb80WgKpJRE]l;`pTVOeQ^ZI3D5:cT_2NIbC]3]ffThU1FL6XVDI`hYE
<_oAKi;A;gQFfdYOen488dk\Jc9T>4L>2?IcJ<_C6P?p^;n]?>9q<dBgkZEeSDdb
D6B?XB>j<9;<jeXEEkM\26m18X2F31q\UF1Q[hq[c_CIRQ]I34Eoi\0YTnUZ>D9E
018ob>97hJ06D3VlTq@7:>CkYqWEjC=07[^fh>2Lk\F\9G[HJC3]cYXP?FHLJb\@
9c^2<nHUHXO19Z`a6dGW@U^<GcdZ9f:mq^ndm^mmqNjGSFZVpH?XoHK=f3LDR=84
j3^LPP?4UcBEig5^=HRPFBoDVE2pnVl\GJ=gDl`iQfX:BiFoe1c_=Z6b6PS_g6HS
Zh7ETn39<FLAFY>lE[;nqflnAo0=qZK2_g3eqa=;b>WHZW7P9UIcXU5UFOWhn<LZ
BH^]5<8lK8N;AEf9SRR6p:O=U;8KqS<R_J>a08o[VnkiEFgKkBJa>cGe29HG5M0^
S<ge6?^peb`o;]_pY:L\icgYIUe5NSVZi8k[;?5AQTqXF;[XejCh4N@OdB0PZfg;
ND>YnaX[IY]T@]JR06]FcpkZa=\e^q5=i?@eGq2dfZ[1?YTSW44BTmlgj5Uj0\M3
Y5=O[YHVFSB\]b7Rj:_??W[gq55QW4XEp2965:[b\C5f=a]2[NkMLlZVQfL[TPea
_V:jNI_hnMDpn[=>89cqUU[D<>9fUDTTeJgd^g<o]NRDMTD<fo>@TN]MfNdeH7Va
U0^Rpj>>l;ATqB03CDJaRQBjPQ;4<=^[P@^iF?bWFYMWeCdPZf5@NeJ[[1<J`NDM
G6Wp<\JWFkDq9H9`X\MVIU[LCRiY0L7fcWlMS^BQ`mD[ELf33j`_Llq?5]RoHbp:
<lX?_Z0[dK9VKoU7c9[B0a3bQ8mQUVDVaj6kS;1I`pJ1c1oTEd21V8E]H8p3R``f
VfpZH3Qca@p>1lRYS;pM6=DT;?8P;:^?0dFV9bfmUn0N_5[MBnOdCB?eDEH@1q]L
8hU:2ZiF][40IcFddTJ<89FbPITURc>c=FPlcmOMJS6jZLfdASVTCF29>Sp8mWf7
Q3p2mFff?nqiMG`^EUX1eM1Qj>h6E9feZ9CDBQOjm>132]?Q0A6CcKD>0n1O:@Rb
WpFhl[UgOpFD<5O\C5fooDmbUOp:?dAHTIbXg<O:<UNl9T<H3]d\Nbd2ihLVkQoP
PT>9nq8Ma:U_CqDHjk?]ZPGG8@11K;l3ne95YkkM>RamYgKJc0WPG=glq`:nCbl>
pcVT:FAOO58WN2kIGlmcIh<`2qmChFf9mpE8;n[X1p]hGjoLd[e7AZ``<1H3S:QI
WZBX@8hekF_L9\LNTC74q_fXV8G6pU?on5:Eq_@@SBhBonE`\2[:^9\=RNJ<GJC]
7fH6CdDCFhk<d7SiaglR9R^`jVNDqR:QGiF[IdHi?n7<bmd?:Un7JO25bjIP<DB0
\kNC08fLGmnHa[LDQT[p`jm_<E^q8ZPROnN31Q7hBhR@C@i;\[8fo;b\_M>>U9L^
dUo_F8p[GD2emPqQ1i^7B]:Ea5KCkkO2431``6T=N]a4f?8neXhBP4eBMpA[47Q\
LqHXTFkShqLb<c56BpM9h8f;Q5?j?6TUPk;f3nbA8N[KRLUB2ZR3CI;RP]E;Z[6W
Zq=mIh_HIAUC=X929ke_CbHHP6P]?n=V0CgnF\VTema0q7Y;n0h_pc3UKN4EqLkM
HV9lqd_oP0m[7A^R@jGE3<Y?f3Kn?_Hq70Og1@ZqY8V]8<DXeX=j<fMLej6b[K[F
1YNH;]KPK9AgdMQdRlpnJ3Dh:@pXJM>?cK\FSm7ofN8kFImHb\Z:]=Xd;dNX`E`2
hjE<mqS3^g>Z6pl\A<]mWqi4RhgdnqTDb]PKf0PFiTE[8VmZbF79_ZUG7D5@PlO:
XV[TbU6_q3UXjgD2qRBDE0J?D7XJ?Rookh=qD52Vd:JpmM62TJiqAWDL1i@q0Ojc
o@Ep2]3?\:Pp2J0I@NBlZZ0;UJL4H=hQWGofObRd^Hhi:GdRD0IIO4NcM@BCkW6[
n_99GZ_RP>ikq3eGX@gaT11j2J6e>]VU<Mbk]FKHnI\UNcVpYoC0JoO=jBHUjm1h
GdK>lnA[RNDUP2>[8RHU_9fOGb7\lN@Aq8Dk>28Kq[bDeEJ6qAhE\C`YqB]9elZK
LQC[coTbHR3oNT`TeMFgRAEUnniV3J<@_3>onqgg8E\Uap4DkGk0^BPReJ\URW^E
<DT^hp=gY2SW7>;hnIa:lPADdT5oVM2`4V84YNBlpS3G2\mN]XL1b3hBh`7Y\@2f
I\?GUokMaW]h8pfb`:WH4pbXV6je7g3Og9i<YmUR\1mD^c\_6K\>2^=_M0lAL_68
];c<CTFH>3n0p=587jA;YoQ9VH8W=ief4J;0TKiKU3@81Q0W3MgY<TGdFjZIU[YJ
4A]h>AKgq[TB`gB\Y0UXM>[nM@IUEBD[@]RZ`ZDZQTl3S<N9pOmF=JR8eO\MPVia
jEi5D]a=[>X785fBmAfSC1\4qWi:XIMKq4\f4^b>pDL`4]2:UBl3V62m_5i4=T52
aM[6j4>ZLW7Jg77dbED0C`6Maq8OU6Q\QpeLRRfi4^=TDPn^>@h5R^pT^A:5K=70
ge?R<T[;`D=c;?Q\C3>LS<J@V>l8b^\I=oJfCUdmJF=afGeUfVBIT_YTB6fpI^f8
;]lW6cO`\e1^_Zj\PPRg>VJHJdYo58LT2[dLU;qbUm>PPdR4V`]Iieb]GUR^oEh>
jQ[ZecT9Cp4\o3XNVoS>9@64hS[glg_@CNC[9;DJhAL3SB06i\TU?eaLaRaW\cO5
C7\]^;gKWe[J1a39gTgTS=J4_I[<50pAB;B2N]q0jbg\8=k9iZ1m1qDag?m`olX=
0IN>>`S??XE1`jA^f@eUIkZmF`PeFJ02q[QkK;ZBqmfAW[;]W8oW<g4Na=\fBhT:
K?2WTQUZEebSm@=OQEX>PINN@cV]_JKT<0oO0gKYgbEF36Mob8fhN93_fg8=O`Z^
Wf4qPG1Ro]aq[HHHcIQhmN8PTmR;XZEVgI6VCSO7f\L=nn41KH1k76pcdNDA:Xpe
e0HU\i@X`fkmeP@=6iqOeX^mJl_9=I<kcV;Sn8ZY;ZiO<TIBRi2=Z8M`CCh3ep1E
ijMfLpD;G`JG=pG@?fQU2pgiU3\7E5E>;hN^9Fd_VYPb^Oa1UUZh@GSbOJ0J4mGP
q7:Gb??3q8eIJnD]pG<12fiEjcOeB47^o=>m2fN599;1iC\X;9\c6:d=>ci1@EiT
bdBpT^486gBpZUZ0:DE4\?RCO6SD`R>nLD32loL0pe\RfOCe>jT6OlgBZ7oK_DoS
L<VQ@aePO55GS1i2ZX8q_<DgC^dq`<40YgZkm:J<EE85ec3BSd<R[[]^3R_LZHFk
MT>=GoqUeJ]?GlLW:6j7D4icYn1lQ62Z8Njqe8h00^7pI\dS:`[qUIVlA_@p[Ybc
j:WQTWM_i;VETcaYT<_cjb]o>a3EJHPXCgKCTmpVcQP:E`qCCo8MQ3q[8<XbQ^1J
PgaRJ`[EBS>JNQShDADV>nh[`ohQL74?WKqI0I?i^5;EW=?CVPNlM]^QYODLjV]R
jCWVd19VYgEO9h>]8OFJP\[5^5oLmq]@AYjRQqD3MLRAa^?8G\9_4^FWCGUZS]^@
]3C:il`3T\4>_kD1q7a[14]bpi5770hALoj]lDl=5\o6j>X_22aBMME8d[VME`mg
E3=pZ\67bPfpAUF;8i;pW?3DeMZEG?gZ]T01;SV>mMi6kI6Dl6Y=9Tk0Y=Eac9ce
UVm?f:O2HENI35S4KjS^p??nS6:aqocaV96X9Hm^O0L_:1NkTgChT\D`:U\_Xld<
hGEMB8Wp?^2f[@9q_f>1;T_p7d[SE=3YXa:C6R=KNnf7BJRFkZhjILd>GKU^]4H5
EJi]CEEc=jXVoWA]\1p:Y^>;kRp1:AB9MJoWEZRaO`XSiZ43NE>bY4<hlB@ni>B;
LhQjgqd?1I_bTpYCmN:f\Ge5?Xj7ff@Gok`@ITY`2`95g=[gReeSB6iDq3XlQSf:
jN1EYZY4qNN[J=:cqMQdCE=Wpi>_;hLSpC?;CA\IHCjFIBYL9Z[K:f:=?]A1]bVA
nGXDigbXeUVqkQN5KnepLai<;Kjq[lO=Zj_VPKa^_lKfIl>8n`h_Go6ZEQ[EoEJW
iD_WUW_`]CTEDoAJ6@DlmnBVgdqFH>L5i2d@DQfI\[^2MogVHi7OkCJYV\1MBe;E
W6Y6EWP8EVm?GlIT>MHm4p6oaRVHjqSmgUkTc`eC`G;BeAP3MG9E41L2V8fW_n<R
kUe\2P7mqm<8bPZKqHi]GOcSYJM;kV22ETL?=><<Xn[f;CoB<]<SQGifa<Hq;IPS
a0Gq?A]bkE?qP8K<@4mqSU=QogTJOfJ4<I2UlN9EXcKfS2_HKRXXMTZVDJUVB7p<
B>;QXM2ViWFNQ2ga62DTTJRedRciRAK>`OMR92\`[0QIR^p_B^jGSQpnL_lj3ZpG
3jNG2Iq5fJBVHMpSV[Ul>H;9L;fJVZNq6\COnN`49j=^YmnJTfOFV0QEFHLJ>bVb
^J=BLmkMXDp;J98DK[p^mA>AN67JA3^jTB:ndRTMcF3`;c[0WkC=>54i\0iR[pJH
h4ZHmp^5W;`7m[>:8Wa^ICITTDP5V?V0WOdNoc=Z;f>2H?5nCl<K^1NH4pcJ]JJF
YqdcAR;IBp7V2jA=A6Tf\G^`eY?SnHO\AXFhiFMQP>DW6Y]0O:DhqNIkengJq\WY
87fGj2kcZ86jliSChV@R>p?e4iDXlq?Vm[o6hp39\Y3PM7pTQjT0;=pF0VZBjHAo
\^LFoTZ@:f[T07DU1K6K1]YiF1ZJOIO3HAXDk3Iga[fGN[G9mPOY2XQ?FXFpUA8f
INTCUA0;0JeN1Z8XIR0Z2j`X^2]YF6qlNMR0T2CKk`D00lGG`oI>cCW[n1Ra^I=>
`Lfp\f\_VV]pDb<ggTMIU22SfYDObN^:dn>4:PSJaRJe?WYX^h2>_DLGQLe;FlY>
kApee7AGfZM1HHgcEYKPN]LUU`W?25KEcGjQocE\1RpV:2?[JQF^H00]g:IiIL5W
YX94R@84X?iKSfB^gBaQ_<`1ZqjHklV[dS=9A_OA;e7\XREd=JPgmW@FB8lXlCeU
GkdOpba7FhVMqXPBd2^hpl?b<o`[piV]8T_:pj0QTc^cgOonW^5Od<K]78L>:nYT
jR`=:Qg5jZo5kSTCg8^5Ki;APk?@SW8\9;;7fiQ4pAn??Yb9qX[nmjj_q_f`9i_T
gE:Q6R6iX1kl\`>3m?0;lO?b00Nd?\C1\P4A5UdMDmgWp>jFi_mA:W6gi50MT3S`
h>4k6deofMNm:H5G^9XpW6BKPL:9\>5iRhRQ<bC0L?N`\[NZ2fBac?qK4kTeH][c
m4L>l9ma1J9;6>g2n>KmJWK5@4P^Vmd8:8dV9Oq?]cY[5;I<2gIJJlNV91]GiLPG
BGQgQeilMJdjnKU]\$
`endprotected
endmodule // module vusb_hs_up_int_busif_amba

