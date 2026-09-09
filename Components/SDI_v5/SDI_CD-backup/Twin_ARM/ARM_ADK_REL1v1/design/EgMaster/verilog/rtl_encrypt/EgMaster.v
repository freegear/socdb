//===========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//
//-----------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           : EgMaster.v,v
//  File Revision       : 1.11
//
//  Release Information : ADK_REL1v1
//
//-----------------------------------------------------------------------------
//  Purpose             : This entity ties together the sub blocks that
//                        form the example bus master, namely an
//                        example AHB-Lite core and AHB-Lite to AHB wrapper.
//===========================================================================--

//-----------------------------------------------------------------------------
// The example bus master is made up of the following blocks:
//
// EgMasterCore - An AHB-Lite bus master capable of initiating a fixed set
//                of read and write burst transfers.
// Lite2AHB     - A wrapper to allow the AHB-Lite master to interface to AHB
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module EgMaster `protected
C`hf3SQd5DT^<nCHnWCl@jYediAcL2?@mOHnfJ3eq?>CK>GCic;a\WEfO]Von_?U
]bie7T5OHIK3:gidnpBi\DF^U72Do?\Q9kb_;dqXMBf3?q6ckkW0XpZhL=2X2MVS
Ba=mq3j;OhKAPS[0?VJjo0`qG]E5j?Efcne6cE4>p[n<F=F;VFV[L5mf3p5Lb:NM
56;B^UiDNqlaK=iKMDef[;`Y\_p>;8DM1nPBKP9FF8SYHE5fU70HJUTjH=Y0gWId
XjcL\2oW6lKef>fcl67YIF1:=6[ASQ=`diqkBdek@b[H9M=Vb5pb]@N6kdb1E?Mf
l3UqlQ@cj[G8@2@@b]Yeq8Fo1h2b0CiG<@cap>52>M6j:S@g3FN[Bpd<lTGRhEdP
mgbnip4Q:H9^VEP5<C4^<7qm?Nd1b0fN;eIIiH`RX;M8kRjL;Dd[HjmI[?AT<\8k
eAbH5H^J7SYE<gH27:pen8=Q928mH\deVm5eTp7lWJR<Ie[`WFjLIpm>XedachF;
:iGNc7GHa5ehpD?AQWI;_CbMf2HmRD1o9fjY:U?jeXnI8K1KHC<01fg:k9hMiJ??
O2nYhg8J<2h^136na\IJpYc3l1JoPZ@EZ>eUdGciA@Bq@5<c^Z8ZM:=W1<@\;G]H
[nqgihEaX6^pXMV<gnpVaEjbQVOaG:GZNk[gYg5=\fOLJ5LL67pi\HUH>p]d_6U_
pCf;^TQ^^Gnd>_Y6^o1?JRg=24o>Qd7TFDEK\9J<ApN35heGpU]KUFjOBN6i\<c?
0`>Sp?^`jAIpKGj;Q\YUQc[<J81HPidUAm@mCLVG6>H7D9jVRhai:<qK;i4FKqh1
_<9KqE6EeHV?S`_DTlY_C:SdJAelKPgNZA7HhkPi:PWR\1S8:q<_1fC5pgGc[LXe
\Nge3JmQ2p9YdcV<L<YfR@<mbB[F3=pL_YMo48Vf6Vc\0fk471TcKJ6c9_eN[;qP
[6OV6pQnLB;A6WgJFRV[I06=]Fo@oi2KWLo[4_d7q?KQP`D<o:4jES]9`8c2pVI>
8\a2m4]AcohCJ9X8gIl@j`NVj_;`q3Y^LOBg5;G;oOT^CReYqbfEGJTp\hKeO3PZ
JbLifdAk0YlO7D2hfIfk5b<p=mD;Ad_@4gSJm50cPU]QdL5gRVE3^XE4qg_[8Fi9
e`2@3LkRZHVV6U<G2VJdKg:c<q]Xe5]QDA:l53X41Z;6XqE`hV:5@]I9R_71f4Md
H=1c^O6n8V4:epQeOVSb0]^lIoAjF:9PKU^YF>fXZ?=HQjD4cGDAIB54A7j;R8@U
qkL<RQN[?ebKjJ7=YdaM[4CT7LKG3efdXp8VZMF]j92<mIHea`bNXLcdf_MHdghK
>q[]9gd9?LhJ<S1fjP<Gg?`09<F]m1_NF]EXp29UoT?]STb[@9iWmcd7fNd2IWW?
C3ngJ]42W;BbP>EZCF:;8R8bohX=pd82aJF[DSh8QB]JLEGTip04N\60P^M=HLkU
lJ2oqYoibjXq5e>FBaY^oX;VHXgk7I63Wl17qf9ng82=dW\B1bBLS4BKQ]^>Mq=i
XTdMbDL]>gi1VE^1d9o:iQkhq[D>lZXpZ]RfH>q53G3kmC\h4H?6Bh9pIc]Zi7AB
^E:A4JBL6R^2C3a[a>3nQARD1m]hqAj77b6IgD4HW:2W^Y@G0pf3abE<<O`if3mN
QQ8EIWaR9?;22UZ`dLooqcOFegT`3C9@O=k[jlSbp2:5oYM2WQjF2kBMZYeW]?54
QBAPaM68qNjDEbj`;=0Y9ED`c7Si`_Ap2oo3>Gl69Y]lVIahVd]qDPQiMdh1:>OJ
>jW:=kC`oInF8b3[BH[OpVGgTGF:kEMgoEjed:nnTe=o_LGZAIZ]CpBE0A];;@O;
j@`:G:lFMqMmad5_I3PO72WIJ=8^f4EeTklfLLF:KqI=OoJ0olG?SX3XYmK1CV9m
nlgiNUSRZNTM4GRERliHJWp;3HYA@QJ50eSd7V6?JLaK1NGaXG_0WJ0poK8B2hEn
A3l<of5o7oTkWjK5KfWgkhSq\1Rf1LgS`82]LQJRXO0W]RNKYECP2A``anq6odN\
<;9gfUBSje03nd\q?[Va\X]=LI07jb<WWVN>MEFd41EdelZjmD837c8P4f[pThbh
;k\Ve^lBojnJLlp]X9CM6<EnVXC7B6]VP7cW<GhpBkYj`8e^m]j_Z15Y\iMfAaeS
q2O54Fm:gQa4Ake_TfEHC[Fm=Pkq:8gRmKp2Q@:cWN\Ne4XPb=DBn@KcW`lJnAH\
ek_8Cq8mH3Z3@``c`Y``IaNm:qI@P[\dD7`Z>M@o@maWo02FnbYnNV8F62qOPiXl
XLF3ECE9H\Q:EVKkdY94HSAZO0DqJmCT2jiGdHC5oP^mqB=CI_7;S>3[<3i9dcJk
q0CcQQUn7Oe_NOL2@LZZGM26c_ClDi5mq4Nj<R^jng_HG3oTNdhTaGn1J920;@G:
Wq7[5b5IANAhW;:[A2`6d;gEmpcB==JkJAmJPP1H;>@LCZDI6e4Kc]8N0p49SB3E
id>NTXWF>`ZSN`An6K9NCCVGANf2pL?bY8ZG^2gZ@EKSh<E4p>Gf5h5`Rj``J;@c
7R5ER[m\WFK\Tj\7A8FXAf__MTe0U9@mOe873Ye:nOn1186OFm]:MqR5WEhMqN3n
9Z=q1h1k@9eEg5ok33PJB>8=Wh[q9kM8Q;B<^I<P5B^N[0Ah;Dj^[60qhdccS4p1
XNjQOpc@ZaJI=abL81`<4cADKgd_Zp]MfCK?^oi:2DWXGbX08VSh4Z3f[:i]c;g?
JPC9EXHS5ZJYE=WJ6aH8fbjQSCYCST\^Hp2T>Q=@p2GcRn@eT;LKQ1ZZe9;DD3FW
<6<ddL6QlELk<?PGTZZ`F_^Jf@f<7C<899N<28cX1=dD4mRF[I3cQfM8GW[ql9T?
\C1=5]2bHgSajdW3P4\2qPL]AP9IqHn[@^c<a`aBj5V05mkG5h9o6[Wpd1JlT@2Y
g1B<m;l_lV5gmHnYJa[=_e7d>JqIGSHbP42:NiTAJ_jNR_DZN66?WLIp4eUmI9SE
JBjX1PP[GPIKBnH72Jf^jYZp_Q]G9lHWKBl7J\43l[oLYW^dAIk5dEfqLVRX5cMm
hIOi=[2_OZDVD6l_:KoT2LBgW>Y@UafhCi7YlPYUahqK6aWUheSAA4V6^DYVV:QK
biQNJI8qT?g:^<>d?3R<Q[LM>KB=<;PhoL_aqOj8A2MYio^=\J1D`CH:m>3jY_]8
a8:1pd0Gol7f>k49j<1VCXXPfB\cGUGdPLL6qFa5>:kE<hkV3Fdk2?jFTPio3CLP
1m:\q15^\2UWXl?QCYk:7?H`6@GgF0VCI>2h0Hh4a@8:IKRGpD]m]\h;;Jl?U0k:
^8Gbk1AQd<SQ^e417[EIFn`3q<Lg=2L@Bh;Z6O19KL0I3REgH_7fRVN@p7^mQ@\F
e6SJFYlc`K_M>5cM]>:AN?cpReN`21ZMq3V5K`MqYI9bCADeC_UI@0><C3P;DkkL
Fd`PRn\apLKXFXSJpIiY1k4nlCDLWl2aVQioR]m?l;6b2NJZh31qKH^LXYe]HET?
XEWiELoc\jhR>?qV[E4hFL>2mcGih[=^aJQVV`ZGDa0I4]>YmpMX]XN^pBKYLo:Q
D2o0L\RZ2i^QBi15ac\alY?5qo;Cjl:5En9MH1kAkGMEkBaoEEokDEIgqE9\dC@o
7T_QJH5aHbIB=;?ij??]HqCP[:J=D9e<Fj7RiV<kTiE^Dg;7<hI3OpZm\8S\@HL:
;D<4D2?kDhQk2D`0ehoWO5<U93OfjDel1qjnJh9><PG4PJZo7PoVVO73MD8O3Hp9
mKdgho]PG=0NLon7=8imBhVNgQXm3npgR7OYH:J`\XGKg^abGgHU_g5k\9`J_Cqo
;EX]dhQNOTmLFm=ZXTMd7[n7:5`pj^1<WY8OlSf4==m:\fmQ2e3_A8O[aoop]^\A
EcjGhEE87k3SlQT1?LdP;[@4qAOCHYXm8bChlKHOTgmd:hO6\DTXd6:?pJ[c@IkE
0OQA_Ejf[Th6M65oH`=PbcR[USEpADe\8KIFDk;Yjo7nBhWILE@jcZ_Tpg4b;[4X
Fg:R?o3^Al9qhPmC`[p>_5fbg:H=CAnZQPA0JnF7UZ8n8M6qo;497W?Ngf_\LS;_
\Q^eONjCdEmXFT=p9[b<0?Di;[Df5\kn5o:N1K3VFN;LXlNqS;P>a;YQ?K>[?k0`
_Y_eG;<Mn<IHq6Qe^4MWHke4Ym[U83j8D?2mOfYh?c07h@fYLCgGq2Abm8[hKIT4
M]1=mBdLCS_jEko]^j`Wj[XSnUn<hPXE@a_hhNoqK7NOc@OE\:0JnPPMlm@S=:;V
FS`Pq`8RXNf@eQ5IH:l_9L37KQn6O8;8QEYNq`nn>4SR?=CSe\IPVTE=2e^ibWDM
noB1q6FV5e0iQNRl@ji7>0T7kc1Ih9O946eOq^XYga_e7baj>na?j6G?_nPlB^^Y
hFL8p38Go;\G;=kJ<XHLWmEhF?W:[;E0F3b9p\ci[N6Mj8dC2icTpJc]TZBqiDAY
R7HmcZjX5:TeaA>YoIFLZ0;C5WiRK33jQ^WJqgIT1[X_e_PbZkCRUl^JQ9Ff8c?9
1MI8m?M;XIORJpAK3D[fW5@@4k8DO\e7c=:5k6ISA]FgR9;eO7lENT[G7bpIQLT3
d43pJYGh0;5om:8LldT3i0=Kof6aH:<bPZe0SGbPqC\fKPPj2NcPFj6cg\kac<Eo
2UQ_boeGjo_f>H0[LPR6Dp852P$
`endprotected endmodule

//================================= End ==============================--
