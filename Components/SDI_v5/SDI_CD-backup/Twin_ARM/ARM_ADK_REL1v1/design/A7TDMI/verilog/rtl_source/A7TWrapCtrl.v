//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000-2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : A7TWrapCtrl.v,v
//  File Revision       : 1.9
//  
//  Release Information : CPU_AHB_Wrappers-RELv1r1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Multiplexer used to drive the core control inputs with
//                        test data from the A7TWrapTest block.
//                        When the test logic is removed, the TestCtrl bus is
//                        tied off at the next level of hierarchy, allowing this
//                        multiplexer to be optimised out during synthesis or
//                        removed by hand.
//  --========================================================================--

`timescale 1ns/1ps
 
module A7TWrapCtrl `protected
YhF>RSQ:5DT^<VlDOQcOP9EqR<XM]BUK3E0A0ElC`jcAjIoXO?k_d=Pco7;loQ3Z
fO`OFTB^a^CTg6UiKaH<dLVeP0pVT0;FDQ6?lkbE?na;JOf4AHPh1B=D`iBL5T8C
B0?@>0^;=SP]Sq:2XlUg:p?Wh=_7FFCMQaWn\gIBQ`?[iC9mKDgjBS0]NNmdWIJU
L<a>\=6<LN502>fZTMbTIQABGiABmBL7jpHR?Ah7_WcjdB>CZE]Y9Li1]iiC:MnW
feMIFDjf`N2l874W0ODGcLCnGC?jocc>7TGk>;Xdl@dLo\Pj5`q4UPQG7]j]V[XJ
T^4Km@?]Y^d7AL3^5Z?o2CTGj0P`eHGO[@b1[\OGB]iBV9Q:eg>C`SoG7aed75En
i[6p1lAl9ocJng0_<GOGUQHC?;U[`OJ4nV\iA4OJRcHJ@n1^X_=Fc3M2:^YSad6i
Hg_E1lDK\Ic0nj\dqO=>manWJAU6nJRL43<7]Pob_77IWOd\38^Z17lhW;P?Hfo]
0kKVibW3LihEGI_l<;<lR=;4QRhqmPAbJEFUQQ\R7?hg1\nmY;kZJCGMC1T6[C92
6i@MA=3n4YT\m9k5YBqG0[bYHYJqFI^kchqI][kQ3?]R772R24j0?Nh;H?eYM6Ao
J3pGj;8M1L[@Q<?LfECqa[5_;gQ_c]b`@l@`=QbGpkn_T?Iqm]e^a0hfC5GVkdb8
FC2dqN^nX2V90WEOR?O0b7mDcEm:mN0;DL:1OMDF;bHINHTiKo?noN`A:OHKSNWP
oZ\7>g6p4_c^>D7BIFP21Zk0g_3AqF2nJkeqMN>5Gb>Gk<=@mlSmSkDp8Mm_W`<C
Rc3KRMjpdnSkNjP>LR1OS\6?pVAX>8[8WfL72U?K>pFc`?b:DPh1LCH=llpnK9BS
4qTlM\nOpTMFQSL8S27TMJ^PGD=;2<GpEDehh`p6lkfR5]?<HU>BRT]4lMD>lpTK
jJ@kVjN^5Y[Jlg2I8`Z^fd1h1=822ncaV9Kh`bfCpcUHX\1pnnGS5U<MJUmaC0f4
DRRcpjM[OL?p3[j=U\DkUEG3?^8dnoA`MoSF<>fFFn[4;JSMp>>f56^qjMCJD;ha
7S^_^AYT5Oq<<SA7=@cI>:XclS>pn5ef^DW0=R6e;@3qaMG>MK?T]AQ_MO;RqFS1
GB;=CjGLGohb57LOpe_HQbR\\S3d?2C<p:bBmU<S5IIm?@GFqA5mFhg?FK6e]PLI
q0>6^L@UUSicOI@0VgCqfQ@ALBqFW=Wa]nYe6DVD<M5UTY=TQeW3SFU5KGQ8Z]mW
=h2\ahUDnPIilpf52CI4pPBd3bUD_:0K_:GCpB:aLBKb2FZea8W`q8\BV1ASIdJ?
W6mmp:9YJAamfUBG>^>aSKW>qdJEU;82CD4f9CQoWlBXUEn^g0mdhOWCgH7A]mS7
lfQi_0H1ULY^QjhFkgnqVjG`5lJ[SY[iA<^Ede66^RBP@Y=qdR_E>Z7Ql^gH\N^?
jC:PpW]@8eI8QAn=g[c1pGSnLFo=J0>NLEWWpIC^<:O[4i6`io_?LlSq6hC3miZ8
V>69JU3>7VqA^g=OiLkEn_\FC0Vo`5JqlhYZ8XfmFHC[O?0^cl25kTO9Mb2Odo1N
L_X0=n_g>QZei?gCGS4YUhPY<g3pcXLCOdIiP8<[GXMOo1TSq4Fh[E_8EH9a4Ro:
BBKq6M`E_ZAoLmdG[YKM2QpB_^d2djZVLVX8k`5ZDkAq[:cP=Pg\0aBEAogpO3;=
2fgU[\im]SJjL7m4=PmN8V3BI7A:p_]\4D=pFZ87LmpW`=B2S9j1o_`6b6_`Gq[U
d__f3^1M?bkfcp:Q>ioBMif1`kYl>QJlpFh6Ah[fX^WN_Ad\F[?qDPk<H@Q8OUj4
7i`oqmTL4OY_S;3GU22Mqmm4JjPJ>3]_Z_4BCq2>6[FZj9ZVAREF\P;lBqY<m9Dj
eXP2OCEC`qCEPAJJ]e>Maf0KEqdjXi]F[EMg;35cG2>>gA3E;79o?Woo>YMbn<@H
9JQFfce[C=<:qO[6n5SbbLP5dDc>p`]l_PE@Ke<5UP<hIV=pUclPR=U=Y0\3bX1p
nR_5LD006mX@;75_m:Bg<=W13h7[Aoi3aiOb5IgKT3\]]VGYZcM;dKY9I_VGGee5
;K8kp=YCM5;[YlcP[Z??pK6J?9=\cO3fMAc=pcke\?M93o9O0N_5ZLSIpI_a6f>@
DW=>^6fb0H57MCV]1oh><qAc7CQZ<Z]e\]BD<\ih>Tp3dj:9[:<3W6hTG<qfcklR
27KF=D5PY^q3NCAfVmVc0=?XNZKqTi;95K8_?a2mf@;jZmp0^;<E3UVjMjS0;HT?
EpdN\Mg1Kf`9UKbNaZAi;VqaMLT6V:0A=JUBX<LYNgIqBV4lelW3jacSE1fF56p;
YK7Nf^?OT]=aH;?TIp\MNKi8og_hja_dChg6Zhq`JUQDM[lCB;E9=ZfWf5]n2U`1
JAXbX?WoRV1_anqC`m4V5c\ee3<]Hcq:ODUdB6Ug5G;8Y>BVbKYjS7J8d<?HaVRb
9aoh:a7?cfHQZJ;@BA25fEZT\5CKNfRFhl0dK0k1bCRDBcOL_TnqjEZ>5]3DnRX\
G>>>A\j@Q]?RT0a\E>fl6VYMCn[OO;7XRHI]lc?W^2^G_]0dNd92j^UQqGAWL[jm
?9Qoh@SaaH]Sb1eJ]6VE?qP]dfZj<D<JA4GYCpm\5C;10V\Vab1SE42Y<AchRHP4
0fm^pP@h0OBZ<FPgiGTlCQMZAQnH\Zoa7c0\dg3LY]jp;QX8^m<qHfATALWe4dO`
_QPT>6BYa^PYG`jpPF^jSl=E?bf]o9^O81l?B;gcGE^k[Lo^qmQ?UL2FkYcYnB2J
L:[de=9\?H[MpR5d`5:UMV;oOYk=aMS6[:@h@Y^;qS69Z?\:0iQJOAh@UF[YNLDj
3FgeV=\Wqh?TckNh8R2eQfQ`Ga<@a_?0MT6egLSigC[nPTBX0OD0QXYiRnaq9=FJ
i5p9k5F:ADmCY55B?MfEO=]jO=QXBK4lnL9p\;GnH1mOG2UQjX^FG?[DGLK7[AN_
0B2@qP2DRkMnAkoeNNmOE4J5]fSfGQ`kRMKBKqk`Q6^PF3Rc;o>B6h`EV4=nM_>1
@=@[oAq9@0C3Do0<AVEA4F[^QdTi@oeh]1=H9\`p_m==afCHjm1<QTHRTkA;[`\A
[e4plSPKlK\;\kA3?_Vm[@^c=0kPo6?dZYk2e@8N;mWfqgOkC58VaOgFfmIU<GVg
d`jc7Lb;qc2l^P;LI]:iVEEPk0\j:LA7b24TMQ<p?kTNah[BlkH>`cmdfOLRk4h=
VGTkV8qc85>d2;hh\ZK;n:SP8eZPDn?DKlA2fPep]mSS?QU0EnEX_lB:j=`e7V;B
fPR20i4_pD^>9\6\]W<2_4HVa7BkM:YKk9N@h>QqkggFEF0l5Z;G5`>Jl[d9C_=j
eWhKVLNb8^SZ6ghfF^3GB?RVb]ZjWGTlM7^dhJIkp>MhXEmqSXa?CXj]R^^37kNK
keF@jHnW:iKGAlqZj`6WG?aVK75oO0e3QYIDLMV5e:TC8p9Gb]I9mnL8XVigKf_e
<ON5^691?X_H=`qB>=>\F_]\RKNk@LJn];38XT^ZWJGK6p=2eW`ZXjAlB[Ri^E7C
TP9n=BNe]ViojKB>J^Sfn3VHAaWJJoA;5TdAkOoOp<_mWZ>^J@Ghlj1Q^:05Y05o
fU6V<^TJOp:Fn?IFZa5>o5i4`1_m9@Y;o7>L[TChpbn>2h<3YAlG`[o_mN7j:Xie
TpFIH]?gHAMKBUF1BF<3<\HhTlpT=?[aUabUI9iT0>TUNBfZKGHXoZ_FM^8TH^Qn
IWKb:KgJ\VbkUZC<EOQoBQpEmKWmYRU6lZAB50MV3P9BNTbpO>QSN>QeWcLQ2?5V
VlSJ[fdak]9p13kWK0jp8ocEKESpWjM:<46q1L>AiEjjP?=X1kXONSS]TO9F?2G9
kYenc@UEp:BDYZ2S_?V099HSOkAhCc640j@<YGn>mN28<mIUqEHL^gXZ7bCl5?1H
NnW;:M[@bAmG8@5]JBiNEq8@VPT]fNf5@j@l[1:nQI\Xok4N28K1KY\8Mf<BqVg@
k[0jl:\Po8d<oj[QW?6QO3B;mQBJ=;oH8QP@76S@VgaFZ\9kLD@d;3HDn=Dp;PZb
1bAAOk0Q1?WdC2FVLeGa7Jh3jjMAZ>Q:VC>:Fap_d8]J`fB\c95UaL\V]S4l=;YQ
<T4D2IADWdXiEmT3ZL03oik=EPe9OMP19jfqPS8Y_G;;^9Pk[TaB5l:ffHQH\@G4
4V[Q[Pe4llAM\7Z9lD<D6dC]HfechVenpjL^Z@L:jNZ3jY2`h4jMIR95b2FSM1U\
K]5\9QQX2=b4oAb5kK1M5MMSYmLO2q=?ljS7aDcTHhLKDUhj9M085]:oFc<]jmkZ
nLKM12Oh[l6\i=:E5hM>IdDJ05pWjk_IULiEVA5<0ZP_5:d\;@mIRdbAPed\[dcQ
`g;IgOp=^1Pof>K<QJ]klSBf_he3?jNA=@<cTKR[BjBqZAODkTZY;LPbIecXBkgZ
1\TmYYQglQlGcjA<p^N`MQ`Pkbo`X1cbHbdURB]fn50U3]H^MAaR@^LRa_dq_f2]
mVGfS]a7W\F9]8f>iUg[VWX^[>gQ4gM2m3?YpcNeD:gh6CdUGPNXB;b>L1neJQ9A
7iNMB1j1^X?A5qSm:FfVeRRjnmLImQmK8TaID18OK\iCmUin1[iYRMJd4p4BN[U6
[j^540Y_2Pci`7PaN2<HgQ=6RCkAdTdTVQNKIq:Zi>;6n2JEFM:dXM>aVSiaDni:
U=Lc81S0_n[;B`p`Eao5`V_F3P:Jo3YL8;o;SHV1TlFKfXGIJL>dZ=ZhJ4kh`PIW
h>?D9Lh@4p8jkJB1^;<ROkBm6\3jaJii6Zom754^KFSb]k_Kpf8^JiD1Ed^neb[:
:cb_RFc^HgmnD>XK^D1AR02q1_KN6@B:nm<h_;dD:Dg[4aAAER7XlSZR>j8_:0fK
q5`lPlO3oU^Dg^YA<i@nLP\_DjPa0IW8cGZA6K[o[>HC;2KkWmD:m5`41poY^;4N
07HXeP>LT@SnJJBNAGUPGjfUV0WB@>:4HiM5oqkCh<RD`bh86bjaE=JeeTLA@KLo
5ZGL:lYDU27F_UqD90X`d>A`L:C[\X1GW4pUBX\=o7QKe^;Eeb\ccgbT1bomO5nS
QPgjVPX8mBYXW3[EcC0CQmK^3M@9QVh1VnWbI>XRo`QaIq?GPL`K=@0][[Q5I5]N
G90_D5c4lUKGg@3T4TcWp;P@OC]m\CDY^KNALX:>\I4^GJDJI1X7O\b<WFUpnS_K
h:5TgndULl::I\06Q^cBCeLaXA5Ij]kAL2p>a4]1gGq=hD=>LA2Wc8oWY\e]P\^1
[WD834Y<XZ^0IX>]RIMV:g8SXPP^JgWp?WWmaA=qnoV=1DM2n\NUSDJGiI=04@Ae
_2H;Ad`[qWgND^^B=Vba;6[`\SZKH_2A[PU>DeXp2`eIk>f5S]MJFLibDO4LAnHK
ool8NU9<pEbNV$
`endprotected endmodule
