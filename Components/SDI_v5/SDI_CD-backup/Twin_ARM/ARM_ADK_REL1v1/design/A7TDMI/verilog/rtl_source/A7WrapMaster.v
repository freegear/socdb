// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// ---------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : A7WrapMaster.v,v
// File Revision       : 1.4
// 
// Release Information : CPU_AHB_Wrappers-RELv1r1
// 
// ---------------------------------------------------------------------
// Purpose             : Bus master interface to the AHB for the ARM7
//                       core.  Takes simplified AHB-like signals from
//                       A7WrapSM and adds the ability to deal with
//                       split/error/retry responses from slaves, plus
//                       the ability to deal with loss of grant
//                       
// --=================================================================--
 
`timescale 1ns/1ps
 
module A7WrapMaster `protected
1]O@?SQH5DT^<lEYVf_SQlBd`R<aI2=1\A32XZmQ\M`d;TUpWO]NYG4@EO@NPHj\
N;U3Y0Q\S>1\kIT8=QQKT0?ecaYM6N4^^N;7Po^1CI;Xi<\cp=Fna87mONi;KJaO
9=c4@4>On7`Z79?EXkeSWk4\?ACJ[[<PCCPj653XZBdqoLiFlQJdgaeb0^4DIL00
Enfi1GWn^lN[<Qk9j;UgSQ6GOMgNQ7TMfdAa5N8MiUZD_8BQ?ARe__hl4i]^B;Kd
pjKAOgcPOaZ8Uf6V=F<CBJX:3jbb5Wh=Ba<H38ofA`W\DkQ6CFQ85109>nXZCWlb
@6>Ri86Roqc5KJTY0OY\:c<g8gbIcBgQQ9T;nEQM=^FNE2LU@DRmCIN>h1c@fOc7
TKUF`5:P9p5:djl0fn3CAWMO4bo2biI^CX:6@hY6nHi^^8LPMZi:dcg^58bZm2<<
`dam@Y1fmpg3ng;XAonCmZkH?Q?Kq`U]<:Wp\c9JQoWjQ0PJ2gcVp1]8e\_>QCVB
cIEnM:B4fqBXB<Mg68@9B9AB8<?i1IoP^@If]`oOdfR9:YEFnM_YPqjX99;QQ31S
j]=jKbUVbpF^aPOZ^PL_65<WJT[hgaa1`HeoK3J>1q2]BmOX9\4T?fT>GbSWBpkC
VH3gdoel`0FNAkMnqb]XBdSa3l845A>>XffTnRZmJD:0VG5EjqbcnF4\[UE2_G>4
]M3_^KI2I6Wh@=hN_npX8oE>\6`R>khXFaQT2np\[cHAWif25nUTkAOi8oL7aUnn
fIa2URpl6=Wl3=iAgQMnMKJ^WO<LW8fVlN5e^d9jS3Hi73DQKEO]]KqJ^E1_>_Z_
344KlH=[fUb;TQ`l?6djA9OqBT8U0OhJ?]0HmV?l?H<P4RbOJkd\DgDpKQZT3I;5
2f4GW3^5P=p3;ZRA]QMJ>a=GcOERLC6q`ZH]6@JoE1j:`JNAC0FRXi^ii1j]L2bI
pX:RHPMHI:o;dlj?nIOM5Fl>c2bTE[mGXqcCaJ]HS`hEQMDhLjkWKq6;DcZWk3:n
d=>fJkCLl@JSR0ng`_L6YH0^C?Z?IS6[D6V?]Vc==1OnKQO7fmSid]b8QkpKZdOJ
8Zf77`ZiDaNedBQ]B`o0D5eM\Yp4>^;<T:e6JU`^YkR9;d5T?^N4kn\H6iRq8M<R
QAYKnKilNH5V;0W22n?MFnGDFbfqa>P5g40QV@oX5BWS7DM2qkD>NOTQU]A[P4o9
XA9p0Z1<P=jeP2G:3mQ]0_Kp?gO]>=QD24[;3[LdM>5pJh0@fJqT^J\UBgWbeTYW
XjO2W:8j@VllP8fM2QopZILOn`d8TA98a>9VL5d1QQcjj6?8cT;;HXhBBnpLFI2\
3MHkobLFTjQI>jgKl5X9h82ATF?pi19[F_F5m`miikl^NDH\HXco__=jS@_BfOXq
HYB<X=]]7]]<LBa9Q3[S85;XA<ZD7i2qJF_FFaq[G3;9Ya25:3j0<g2Ude9AP0f`
ccSgdckChWdpi=7>nk6cW<1o>[_31o6]QkBoi962_^R:REqfG<?kK8OBd<JEg`;e
l]d_[<>??:3HDOH75QpFX?:K`P1f>=7]WS3=OF\\`KH^G1q8bS6Jd:jb>h^mdWP7
W7>_La]DhB]=jJ[?B3p\J5>\=2J6JGS`KbNFIn2o]=4>USWnhh_hTIq^1m89WL0W
oHdgVSDTDY864ZD=:ViXY=m<n\pdOMeDoC<DT\@eKSXOXhhnc@4:4X@Gdd=cc`oq
D0]a]nj7cjB19bOJeXU_R0>`1FYmNKMM6?=]BQQJ4n6LRYWin?UM@8h3QA^B8]X[
4ap>l;Q2WRN<N6XP>W<Gn__K37DK;CVMLdH^fHYqVh<@>bqFZf<I?QVC\R0o^3KB
Hg:J:IZ_^URa>85p>aKlHd;=UVDH5AFZQo0XN5U^_Pc46;3]4dqBObnKO[SkE56l
S`TGA1`XL631Y]VGWO1[oqKoRSBKm?MBN<]8G[2FFYC1]Ob>EQ;SV7>@N;Zaj]q0
;OJ0^hbROC_e6CJXKP\2dI_=fLejllR=JpgiBnBmp[<`jP@3a8@e^^;>L6T><RTZ
=l\>ZpUdjQD0iK=8Z[=8_pAJQK:2cf;>DhZTbbBfS?l?3Im7qkTZG^BGJ3;\QU]J
eYio8qcQSBCo;F=]OEF_<Yd2RGp@me_oGZ=kD]6Ek7h1Z`AOjISC2peo6V24haK_
<THcl;U_D?q;^]O\k0cNk4A8M^`hD84W0[p984K4;E3Y2:5GGT6:7<pk3:]SO<5m
:9TInj=_RY76`=q3_nSHef5W?i>YmB<PoMVJWhqST5ZF:1?H]:^O]hV65E0gYSCq
_d7]f=XOI=I[RMWpMnimG48:IJJnmL9PHWP\pC_;^aGaS<CNm;YgRZZAh^nJp>DP
9Z`W[F]FnS25Vm8:[Mkj@?A6WN5C69iO03WL]U1BHcYDm76qHB69W^fhXnkKf[E[
;g1PlY=MOD[K<_o_?6QXp4lgAb2\9He:ZGM3Fg^PQfo=OTXbG9^BZB;ZYpk5<5Q6
5V6SDKCP272Kc\`YjFqh[T71fC9G]jVF[GO\U7Wa2TQ=RqV:a7EL`N>ak3e8mUW_
8fcEibOR:J`eQX;8Fn\Pq[Y>l66dS4lNBdBgecMpAh3g@PP\RUXkBF[A4>MZ8[fC
mP=b5:2\NAZnq7EQQ^8b0ONbeLUnf_g7D9kO7k9F56lepYZ``UQY[7cZAhC`o@\0
4DZ@:i2KKZ5EqPoab4f`mOS``F3:iWI:pmeDJO_LNXG=BiP_=Bb_n<2:Rg_?eLmU
]o<MSqf@^5_U1[WODf6n\akERXE2b^73Mb0\>FqX3@^?g::MR9Hb6h71D`]H[[Hn
5O\Fnn2VMX_cOX@aFTHJkU1KnJh]GSThXoF59pRYCa3kRKaPdekY^NkTP52PCq`b
g3DALQ3Koa4Xk9@hA3`^Qdlj[;d3NZY[_@3V:6IDk`L\E9]h=OPKC;A5jJcO0pJS
JT0AWqPSAgj4DTP273m2<jb6dNgdTJq63<mNIn5;9=\l8PHJ\4D]a6cQ:C^]5Wq5
A0gH>kQ]9W1gW1@oQe\Y3cE<oNBRoqhSb`Jj6jQkI8<hNiHmcmdZl<U1`ePBi1fi
pa9cjVCk;>JDkeONi[E;C_1gBLoD;pQFollid^?`jWAd6:[AJ@V;UM>F`5TYDp[J
9en6^pcMc0Wl_g?<5M_UnJP7[h7]G72h9cBQoq8<6kYLTpd>0CdhSc_UCeoZb]PR
o7F]IZ=e=IedVqCY_dK@`iSe^hS@97o@meV<Tl96XMPHP7O4YXmWpQEZe[9EpALO
OC2qA:F9_W?4lCIFGagIe2ARj<Sd[OoQ58JhY6q7QMDJncEd^nY>GTJX8f\>4JZn
lR_QCJHLLcGPMq1^acl=XpfNM_O^n8dgegl?^^=cf]eVQ?:mW>YWDDiBfGJ_3=:a
;MPfAOJiU07^N8pnhaH4aPe:0=ThXAaA1SY]IQmeh=P=Gq^gEZ^OBB8\c<D_JB=8
LAk\FgR]nh9=>8kmO:3Z_m61jnJYW[L9l`6XDLaBnqm`oWZEdpH93=_aeA[mBK]\
HE5k_8DnJk;f_KDdp<iQkE2@qW5aU:?p_MIPmc8QZYe8m6<>NfkE<;M47438QCg[
5]a6C`baYJd@=?RGR`p1UF45YqWa;CQi5;R4NO1bQ0HnkBlgh73aX9@^=[hc^@G^
3hL^R`Unjf_]d:<Am=C4>NWP88S1XRqSX?AC=qRQmXMVMD;lh3N`;9Bh\ao:W:\m
?;^;8L27Rd:b3nfRDOAiTXGFDU41pdh\ikf?F2RCFQC\ibFn8YN@EXAA1b:3E^Xo
gX41hERlc2>@pKNP[5Aipdjii_[C;\dK=klXk9n\O3L9pki6cnB1qc66eEdbahPI
EaRbViVjM9Mi04oVnc9Le^1=HD3epb9F^jBQTLTI^KJ81@2g=3]o=n\[\VUYB\Tp
ONeY4B]LMYgfa8C:^QaM5RdKBO_WL3ZJU9q`BL4P7hpXe4hE^FNEnXc[R:oH<0XE
OGEVTmfl5W\UOG30R76k7FS5]`Hm^lW?7lST5F0Yd1DgQcUL6pbAIc0D1qnW><Ia
4qBeX4fZ0j@aD^JkbD1@<jq6a9ac?9qi_n8icSkLQL]ZSZ9mPMP_Z<VU7TV1L6Z<
P3mAY8peo[oJVN71Q2]jI6e1U<0>jS<n27;?Q_=;okY<Sq;_X3Lkcqc>iSeL=qAD
YoSeUqhAQ_ln9HS?_cK[g@3TaUPE>TU9]@KIjY_4l]8iRhEN7>9[9HAmoJYR<F@?
pPdLJ?6q=92b?:Z_6MoG3g6[@KnOaX8b6SA@@24cOQYo`f:onHk1[T\XjX:FPjcc
onK=KRBfK>9Li9l`V1PLp3;Kg\2\iWHRO]OY039Kb3ldJNSK;VaEeYGP>9RM`[Ik
XB^L2bTZ1jf=h@9k8N\:dRFOg>Vd<Y5Ta4KXoS0\:]_`]KY;AOoq4fc`elc1W]T6
KnEa\g4833aAYilb?\9LbMAOS84gGjh<7XZp8GEhS2n@=2^m6c3V0CZ5lKOJ\Zce
YQ_L2<[FiU5[gZDTWba?p9@NNb4aq<ElBd?j5FV<@166o^9[6L4;pESKim;1FhkV
^C0B4a=:gMdNQA9q3Km2<5Jme8;\gR`9dMa4ldI[jeMc@0F>`1IaCD@Mlc6WQVWA
\\g;qNEM8]FVqQ@]b7bQ;SSoESH;JLJn4DBqjeo4_9Bp^GbhZ]qT2;CogPJlajF5
g5m?XaoV<:1boXQPon=W4f?kghbC7L04NemgGKG@UY<LlpjQM\Kj4[c9oX95dOBQ
2095=4dD]MTllN80L5ecPV^S^Ej:XUo?oWEh[jkY_mQaqUo@LKG_VN]``E@n0`0i
B8f99bT22a\Ggb>3T`=h:GMHI97D@7hekn\URBWdkDJYAOjAOc6Kcq\\?04oH7\C
l579D]FI3:H<Y@B^7^bR30P9AKc6f6gKO:4iMUhJk1n]BW;4[56HED5g0=V;gaT]
\hC[HApVOj]V9KTDU7I<XnOXhWnSafT_=@\W7qI70JX[@j5lG1J^RmiiejIDHA:k
\Q=F84Q1AoD4f447?8?kVM7W`3bWANZEXb0YEd8Yq@[hnAUcRfPHAHj:Y9h0cBlL
hOa8>7VUIKCgcn8^:F1l6ib:;N2RHQ[E\k4;K0A9M@mLPn]D[?J;2e?j`FC[q7aU
<HR<fW^?YRNg=R^bo<Ef6kHG:Af7n8D@1YU2_K9C^@g]YHd:8X>g:=\Y5`]RO7G[
Z\c?F[ocdMN^=1hqeN?ZWiIEfiRV8TZX=h>9KkH^52X^K062>YblWigCg4Lim:Xn
i<>[6cS>]i]\]2[0>eFe;dq7hndQ@^^BdH@ZS:hi[l5ToBJSbBWHL6oc6XiP]GDa
C[ejZiPc_2oXgR?PDBjTb=p4?kl_JUg5kIk3_lbkdf2IH\:BNm>fgU`_bX]gY[p5
mZY7DPWMRZoD4RIOVYXC@9Y_kVYFec2;6M2F\kNK[4T>Ylp@`;NcB0qP`9:l=lT0
WdC3OB]h5]:9LnpIlJE>c:[S@6GO>XLW8;`EZa\B9\B395pD>JSijmp:c@HW;[XJ
Moc[9pY>8i0VhaN7gW3>6RbQFlL\^kJe_M2b0`[W?ALEpWFFAWL1pb?IfH0pOPTh
FK2`F9BWjBd\h8^NUeKlG?jFNO0;3C==\o=fO7;FKd3qRSJ3Y:2p_>P1S0h37E\B
BM:5XUU8\W1pAa1CcZQqSbGM]=71_Y[[S4II;^8EV2DdB>E]:O_K\:YN5VC3:4>T
;7pnSaDE[mcF[Yih1<43R@=<UFRDmd8KiV4e8BdgcgKR^_H4T5J\?Q`]?I=ed?9W
8GP9dOUfjNOq_1IMFH;RYC5WjMV3;^WKDKd_i;UbXf^;3`mqGaid\dJ;<kl;l3Nb
GnA:KABWY\H55ZV0ThgBqag=Qa9\2X4j@OMl0@`O@SbC1l>G2bkIeo^p6ICb3jZ[
W;RIMbWWZa6\oW78hdO8A2`]Pgq5C=`<eGqdhUYiUc[<JUfg]M91_g029_3pYF7b
\oZpb1Qf]lXqMmdRT5U\:cBBA3g?9E5`Ddq8BHFmUbpSY6\ReX[a@=oL_eZW:FVC
C`0=L\WOL\nq1^;BQaXbeEn2:n8LmB8\^WiTFMejhggMBXgql9nNd;M=13SC79<J
4cVmEo935`bDB_[^pJ@ghLKRmU3?_6BY9O_i?m9VF;?L?f2o>q<6ebXc7UEBGU]A
onXGX@gY:b5FMZU_:bqL7XfO1YZAPGf2aR1ch4OP^lO5KANW:RW\]ib\eGB@:o6A
G8Ri@X?E=:XGEq<=L=`:EpEOG@<2^p8I[l4c9pYDgH]BqGBl3M]TVYe_;4>qfFSK
MRjkiGaJ;mL<9`f8`QG=Ma<=LUO21Y@Cf^F`>\=B`_4S4Ch2CYk=783kN8L:2Zk?
]BXB<AX?IIlDq2>l3R76gV8MlJfUQB4aa1RPQ6G=lLm<ZWC4;W7OcGL9:ZlX_e\8
kV0hCoWieUi8^H4ekhRgoK3Eoi6qog21BM4D8HAQ>n6Ld:8]fISVO;NO:TSHGeV7
06_WC;i5]nkFX0q?_F2[O5p\I931M3kOF<6cegBR7V5QSpmim8;59pTaE`W6DPNU
F>:E87oVgi3FLOQO;k0]mIpACV9lULiZ9Hek[m^NdLRNMdo3P=:WjD`YEU@e@<pV
a^T4OeUY1I`ZAOZ7l[o@L9:<bk1@OBeVLe`5e4gAmF[Zc]dCYA0ElcA:e`Z`_E\q
D`H>?nSR0bLdQ@@caI1Wb>`YkalifdRGd_?qV@\mW5n@eQR3P2b=YmWQLZL:\hY7
XiYEpQPB]3mP46mfm?9?jIkW^HiK8GXLhJKhnqJNWS3:NB\N49:0h1m9o5a^\JcQ
FCJ9m8bhE`pKbh65A959SUdE>AaLiX[bTMSNdhKoiSSpZkUIlN:qIa6NXZcqEl]R
6D=:4O<H<[mD;cX=f_TQ1d_lqn@5oj`?pEEQ^EU1eD^]KDQ<B@:[\0<MYZJ:pQ;1
O?3mQKIe]O8D\1Hbm@CTk?OA6h^I\Heq_P88;5LHg8;gK08>iBCfXb`_dk4U=BqA
G9go8R6cMj_D3_1O[@SGRQ`[Y@qmd;o5@mOVcbH3XB?A@\WQPC<bT<q:Ek]JNgj`
>P2d>;O;7A40iP>R[j48>ia?1q3`?M[6J\K`IMT[p7XMmN9GSK1?:8Vjgk<nohiS
bQ_Bp]cZK2o1qZlXS>PnpXkce0Ep6g\O[V=<<[a2=oSBKZZ6IkmQW1PgY<k5mN:V
U=i=eH3JJRhP9o0`7PRXnjnP3K?QW]502j3InhYSc6qnjGL0k`VYVNal>hcCC11M
9AXj\1k[H4lFNOkH``CjOdFQDOGGfI?`oVBR=^>l4CKM2Z;cZUAq[jBdM]DHj]Ec
<7:8\JF<iIlO;E?lbOkDgMdH4M^5ZChKHi8jY<>fThBe?D6D[ko>mXpc:eZjlc4^
?]JAUXYf9RYjPm8[M;[1fb2Kg8WkNW`NN8i]n<BhLF_iWWY\i=RTMiCWS?qFZGB7
gdA2O0;3CS<\m=NgL`L\HY[]FB^lRlLBN[6ncX:AlRpM<JQlY?p]@`Za@6?9@;V5
P2IE3CkWRfpm>2aERSHo6D<57E`[7A7Bf8GN`aDcUeU6Cqdf=\D48qaBGLZhIiPX
=k8ji9h0edbQ\P9>LDUQe^A7h?1VP`0N;pOm@RJ<?AI=;J4BjWBg00M[[q_CeaH:
oq0hU3gQpoCVdREJfcJlVAZk`=k]VaSi26b9VPmGH[L>e86UQmX751<oXAT8K7oY
4VW1X>Z7\m@=LXbgG\`a78Tl45dJMMKpXhGOKPqEmN6$
`endprotected endmodule

// --============================= End ===============================--
