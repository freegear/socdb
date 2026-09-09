// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name             : ICAhbifReg.v,v
// File Revision         : 1.4
//
// Release Information   : ADK_REL1v1
//
// ---------------------------------------------------------------------
// Purpose :
//           AHB Interface block
//
// --=================================================================--

// ---------------------------------------------------------------------
//
//                             ICAhbifReg
//                            ===========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//
//   This module decodes AHB accesses and generates the write strobes to
// the appropriate registers. This module also contains the output read
// data multiplexer.
//
// ---------------------------------------------------------------------
//                    IC Functional Mode Register Map
// ---------------------------------------------------------------------
// Offset  Read (Width)          Write (Width)       Description
// ---------------------------------------------------------------------
//
// 0x00 ICIRQStatus(32-bit)       -                  IRQ Status
// 0x04 ICFIQStatus(32-bit)       -                  FIQ Status
// 0x08 ICRawIntr(32-bit)         -                  Status before mask
// 0x0C ICIntSelect(32-bit)   ICIntSelect(32-bit)    Select IRQ or FIQ
// 0x10 ICIntEnable(32-bit)   ICIntEnable(32-bit)    Intr Enable
// 0x14      -                ICIntEnClear(32-bit)   Intr Enable Clear
// 0x18 ICSoftInt(32-bit)     ICSoftInt(32-bit)      Generate S/W Intr
// 0x1C      -                ICSoftIntClear(32-bit) S/W Intr Clear
// 0x20 ICProtection(1-bit)   ICProtection(1-bit)    Protection Enable
// 0x30 ICVectAddr(32-bit)    ICVectAddr(32-bit)     Intr Vector Address
// 0x34 ICDefVectAddr(32-bit) ICDefVectAddr(32-bit)  Default Vector Addr
//
// ---------------------------------------------------------------------
//                 IC Identification Register Map
// ---------------------------------------------------------------------
// Offset Read (Width)           Write (Width)       Description
// ---------------------------------------------------------------------
// 0xFE0 ICPeriphID0(8-bit)       -                  Peripheral ID 0
// 0xFE4 ICPeriphID1(8-bit)       -                  Peripheral ID 1
// 0xFE8 ICPeriphID2(4-bit)       -                  Peripheral ID 2
// 0xFEC ICPeriphID3(8-bit)       -                  Peripheral ID 3
// 0xFF0 ICPCellID0(8-bit)        -                  PrimeCell ID 0
// 0xFF4 ICPCellID1(8-bit)        -                  PrimeCell ID 1
// 0xFF8 ICPCellID2(8-bit)        -                  PrimeCell ID 2
// 0xFFC ICPCellID3(8-bit)        -                  PrimeCell ID 3
// ---------------------------------------------------------------------
//                 IC Test Mode Register Map
// ---------------------------------------------------------------------
// Offset Read (Width)         Write (Width)         Description
// ---------------------------------------------------------------------
// 0x300 ICITCR(1-bit)       ICITCR(1-bit)           Test Control
// 0x304 ICITIP1(2-bit)      ICITIP1(2-bit)          Input Read/Set
// 0x308 ICITIP2(32-bit)     ICITIP2(32-bit)         Input Read/Set
// 0x30C ICITOP1(2-bit)         -                    Output Set/Read
// 0x310 ICITOP2(32-bit)        -                    Output Set/Read
//
// ---------------------------------------------------------------------

`timescale 1ns/1ps

module ICAhbifReg `protected
Bj_ZXSQd5DT^<V`M2FXmJ[0bHlPcLVb1VcHedF7MLUOJMYc?m`k;qQm>`Mk@eJei
;62D:X=JVLkI0[[I5m7kFRe]NaJI6N91Y63EHGmSp1O1PhPgg[KaoJ8CfMKYE:9X
aFHq6Ql3FDRqj`4KZmpV5Z6Oa05BfY7A:p]X0h;j<nLj`76_@e[Q_VeCa@`\acW8
FD00NT4LVE2]Q>DjY@?ThaO2?b^[[qYESL`0`<E42Pm@ik^dqEQAZ=3BS8[m[LGk
NpUd_aZeQG^fYi7\[Uq]>O[:i4YM@ADY374q^O7Y83Do]diS[Q_pM^3Qfm_I\cdm
3aB2q;Pb0B4K1hM0LHU^_X;Yk;XT^OnPg644@>Oif51k=@[7IPM53PV9UM_:_FFT
Kqm4:\WJLCf0>25gjqe_L\12<:<F5Q`lQdq9<\9H0A`V:=k<8@qLDG;B^>DJUBV8
]@SgPgp7<XQDHY_NlF3WRZTh1f1SPbq62fN^CpeBSGa4n^AP@8>9ZSDjfF=Nn_4G
QDVKl[o>J_Z:N3pWX8V7Yn4ij37fS_2TRLpJOeklG6e;^b>@Y@f:PDp[o?b0hX?`
AoDRi0P2opKmi@lcZJF0:^\`lU:3CM\_RXqmfIbD6qWP:^8;aNbn:S7XjO07m7IK
Mh_gC0q:o^j]f8PfKPAI8m73C\CTW>IZGpDM]ae5cD0;dS\kFO1X:C0DFZ]9@V>R
j[o8bgL``]P@bpn;OjgeRFolch`J3^I`^>^100YmQ1qIR=TUXIEjUl@MDN[nM4D7
KZ:[c]GpKTKVYOm?>WK`8aKb7nFbDK6q3\Q\NEgg7UA?dG<;[a>Oq8=h6[hQJhMg
@0@e?JOH[qSZHKa\i:M;jBO[:qB3N@3LSC<Ha2nOYO?bP<@Nf[Y@`LZ^9NeL[9mN
AS8ifS1PT9XMAWpBY:<AJ9cLJ=ek>gJ\M\n?KFgpSj2ToLb@FBmTRogKFc7RAY?@
Q6pegHl=8XOlC;SHk6Ip2DK[h:7@Zl3E@UJ2l;944iBMP^p`3bVJbic\ZQ>8iQUi
B=Nl^\`d@pL[DSOT18>ng]>jS0q]g3Y\3McCYiPZDFcjS4a]\7qXO49M:1b7@[C4
O_\TmpEiZLY<p<<78A[WYHoUR_QQjq[Hb4jlF?>AnXk3?npMAoI:lL0j37iXiWVG
QEjqELRX0jbTL[]P0B;:7l;q=^Y99>^GSE\JIA5;<TQp@Q:`j5RGLSLOKJGN0`3q
`UlL`n\nIiKPGa_0[aq4GGZULbhkI09C2^N^I0pNFBNde>RXbHHW1ko_EBQQJFZJ
;_:qL_cFD`oDLQgDKaf=Bk7\^WShIJU?Xjdqb`hh;ZO4\KhYJfMHH_7DVPQc4:D4
5\UOBPp4TZM@cJ^\;[Y`R1jUHBSj20K0O8k8;c6qZ@6_lfY1fK\XiVEOB8KGHZ5;
R6jHOO;8F\^GSE=P>ABqW0kckjU_nY:joG:96dHQIUN<[CG6^ElfKOTpCaAg2e=h
dSW]AajP>o8VYRTK8YFHmMnWKnc`cba4qbTBdaH8OG`SS^i8b\52T^hqDcdcP@\N
0X;NBeh^F;1JI^>L@2@ikIoV8ZG_?b3F;m=q87084<_TSJHbThPonl:RPYq6QAN3
0i4cXoe[oB>HY>>qW7m:RJ>d18koH?O3Y0bN^Og;T>o6`KXO_`]2K1jS^Mq<@[Qn
YL]JQMf3bVfXZJI[aonBOXYBbk4:dTK49KdXIJ1\Sp<d:@S^C=[?3X`MZSmiE2X?
EZJYfHZibHj_14f6U;[P=p:Qc?Td1NoiB@@B_>fbiO_ZFUg<nbV?g:8glHN:AG:Y
Qq_DOMa;81TUOPeHHfMU0CXCbcYbUgNnJD;`:XDEc`UR2KAWp9@e[>JC\L;UgIm\
DMEB?2:5[8C@YYCC]cBD8\_`jnGYU6gq?@o_3d6D>`98[CfG1mVSc3=gU1pakh`M
fchd02I<:K;i4]:Ko:QS<D?RA7jh6KDA4>f4g_pP3XB<9a40l^j`mUSmG6IX3cpP
n69h74OCWm;b?6I?Pj\VA[qACgfJB:8IWnDL28jT@bC6O2_G16F70dpfJKX18gXO
^19okBY1a_mG=Z8_gbq_ZHZkB3WfSCgKW7Y`;c87g7iAke]<QG:NG9A2ljS]c:qK
1Nj]V:?9:NE=oCe8ejqd`2lYfZ\SAPEdBLaNFB<\jQB21aI8f^ab`\]hM^f1>9qf
WU2j<]n@An3MZdlZA2f]731mciD;8kF[QDJ9S:ddgSqHGTo84Y86B3Sk7?RNSNf5
mgWNH5_?TjIW:V6[YEdqC\lkaJlVUDofT]YgdgZQDo5cUS64JEp6e?k^ag=8emaR
]R[f4I8bBV6:]0dd1RLa6qCG4KDladlF2@E3oWoCoXBBX^9kJ2i><JmUbq=LjfPP
^?C131GRNle9M:F9eMZopQF_<1GMTn7E?1A`@J8f;kUfQch[piHJ=_67:GO6YW8o
aGM_c7WkCqAn3QY63gDWU8H]YEPMZ9OmVIF3OSkOgM<DH<9Y=ZFS3q0Q:LIDDZF?
@DA;ehjYP1\_53]2pNoe_903h]894:eUe`67k59IYXH=::E07GQgHU=<L8SX3MSg
J6f8ha<Km=4[hc;V:3@:B4MQ?4d0[B2;ijSRTZgS<\N;`ZaOH?5S:ga\qIe[2R60
X5L<hi;Z:23h2o]NA0f3=kd5gnMZ24n^dVT37E6:T`3EL__3Q_Rl]7?<I91\>=]e
_I>Qn3RdMlWoaP;0WegPYZ_NleWH47CQpg^`3;7FXaS^L31nW?7P\5bnaG5OO\S7
jCf3cE4YnJ7pa]:gK[GdaZ9<E_EF_U[j2:n3`:kN3bGD[Pc?cj:kHnh;TBPWaG78
?OIPDA^[iM<CLKX]EVF=VZaH83Sig4:m?7D@W[:V=aB559_@C:?pEcanaS?0^?79
_6fgFJ=[W7ThV46_92eN2f39eQoHPTTgF5@Y_ROfQSAl1VH2=QldFEVS]1T>7J;9
TWX\LRkhi:PJ=eK5QbkL839h[I9pV[E@nDHD6R?`hl;Zm?gXj0G6;DLZEY6UIkae
V7g;AO076`_:dU86PXQo<R8F4mKS6Le`U8FJf[Eof?U`J]6M`gUCSmM@PLmn25EP
e?lq[lJ<1ALBaDX7R=NQ3g=HQ64N<m2Ud@cDDA1GidS3fPHH=E4hRE?0h3e[8Wik
?k==U_4l;LAhjhWc6Ua][NX^POe40C6;CLkbj6OgAePpWU6M1NN9;Y=l5V]eS53E
5@Pd?kKi><<0]Z[@jISlX`WP>PX<BOEmeb=m2Xe\`NgP]^p12<B;_d`l55nU[YBO
FA:\PkGFI3b07odK5N6GNMm[^^W1IdRWT2oW_1M\RP=d@15@\B<0l;=05@\_j^CY
eY^1S<PImTojh]>GPE@TdGp==<3\c:oXlGEI90=XMQVTT?M[aI3ZbmH=7W_1P\dj
b4Db8XROFW>CT3RVjHLMi]m`baHT:NU5G42_Pb4eX3Q\[QHJMglYUYBYQMJV1]pU
9CY`F:h?KE<eeG6TM`Tf_2Tkc<>MNiA@RN`[19Y:K=7`LZa5h9XJN7]Kl;jaA_27
ieZJ2GIN32]`?bXFD^Z33;IiTZZQM7I;BWNJU`p2iOT1P1a];\M?EQkhXXhTKIOQ
??1Mc9eY<R<RKn0ck9UnR:f<bNR6=S^nWL<j5G>nEaa]G`Y7;h:n?Pg0_ej9H6fM
ZoQIFmjUZbYQ`lp7oC5IKNA]PCU6V^naEi3=fNUgV\b1Lb6H;nO<=_\><ZPibNBE
RnF9NddY3Y;5EnV^1AZo81oMcK4FOl[SE0j9n[ed2]kXLRN4Wae]^Tp51RkMI0h\
KN@45<ohC388?0Z8Ag\Ieln5DZ3V]6R9GMkEZF@JoF1fiLLSP9NF]0GJ1=[G7V^o
LoEO1=:b<`]:K:T<hD0L7qeWFW_=bPQXj@bCnhLYggA2Je;B]X>O8c\8VRC<BXXP
FY>ljOQjBc8i7UeT?FN>O;ZWl6NQkO2iD70ll6\ZBm2Kie_h^`leqW@CnHb9B\5d
D3`8]5OOaVAUBjPn6Jbae_RY8dhPQE[gdoG\?M?F8AKhoJLF^h6XaZ@^nJi2Y5WA
BJ@79:WGOk06GRUZfbDqR@c>e@7VXfi13VhoHL_Fi0lNe1Bd76RDQHaR:U1B8?e>
]O83pnG46_[D4g>8RdOM7EWW@EK8J?UoHSDJ\n3X]E[6CTR[kj0I;N6<lo?Ele^k
a`@VjSGMN0O?DlIPKCG5\1QahoeFM\9m?`dq`APc4ODM_:QR`Tf0d]e>@NJSG?\N
oLCM>U8Tk@BAnGR3H:1oe4oSU8M^;NL0bX7F<A>;GhQX8oLGPPTn]c3?PCVRcL08
U`pYRi^15VRKhT6l^TDTbfK4aRZRnOo6SBPM<3AUoGcD6BU=2@DhWDl7^RTnQb^c
aKbaR:SgSBV?aS8BZC:NaJh41VS322baDkNHY]poZPRCGOjFJ?I1a?ImjD8NGQW:
DQM<o`hlL=QPH3N29\TFU]EWBR`WfD5^<CoIA]a0Z9d979a]N\7gOh[S@n9G\leh
eI44T4`;aDpI:1Dobd8]GSRe]lGD_i;;D;nY2B1B>Ac;]^:]cSTZGY04_V2`eB`F
Qe8<H^1n3Tb\:mDN4nJ>0=5oCAITbfgJaQE105Dk5QY\<SpZVf7ULhNTBgm89oGW
402RI[mO3NK;DON^0h^L8?j<bDO\`2\:AH]DbFGf<>2qm>8XLlHQ]9>;7H1D2jTP
?cj2Oc@8K2Ii=\H]6I_3@cN=iFhL1G[WieFhGB8oiG`3]>1^E0D;L9^:PG=L?L>g
^`9LCmLP\@IaBWbp@?BP6HTm:i;3e?00om4D[H3Ve?@Z5jDJLlfHBNU>>^Oma=5P
2KFh:@lh1I9Hi2<cH?K\eXM_Uoo>V_[3_M;4:8m5\i2?D1Z_J0qBTRNcG^XX\aOX
f?V7QH4SF8RUQlmUPLXL]A_LY@RQJcWGBH]bnUPgif2J7Oi\OV1CTWPN@4GK7GVI
M]eUAeLmj5E^A38SRTFCHqM_m:2JBoUXhReVRoMdK@QLgpeHQV:a5hjaRWeG_35m
M6^e`9`>INl1bE3c<V7O19FBMMfOX=SJ=c9QTAPGGX@d[=2H[FZK?O<@4n^mX\:9
lm@lJoR1f>HB0EMCqoMYMlei0cF4X]V9[Q<N335=hjJP5k9Z17Q;Yn7e`h5F\h6Z
bHFbZ0:gWQeAUfCV:nMH`7mBJG71WcXe0WMk\DHYl4UoX=V0RC=qmZ^OBH\Y?\nn
GAgmqoccGohfTcl[j:?R:i@L\p__`[dKAhR0n1_nb5JhZp\O[0kcjQ]n<j1DS4DW
7NAXVVA<G0X;[G1ZnEl^:pCLMQNXagH[kheU4bie=q9P5GjFl^DGjoR[0=ljIp:b
`bcD:dBJoJWbWllmp=bVlCnY\6;BTjfL^NV6qI_d<<QhXkB^o]``pX87I`E230M2
CToOeVK<Wh>;^fRKB_9<pM8QicC;RhFa`fRYY7<QlK5W9^EPXY3cZ9Kp\cC:?lCl
N_Z]Y6j1JJSbKOQo406XJZ`;p=GcnX6End>8O_;4XY^;V:2mc`PL6olTfGA6p:KJ
7a5g>2F=1HPgh5Vk?NL8@;7]iblA1iMYjL53`qA`f^@^:ZnBY22mjfBgY66bp]iM
7Z?hYUkGh:EjV_KR8?lGLp0?PVaWTb=OlQjMj_F3G\AApUAiDBCU4?oSN=JE`1h>
XpoXBHW^0=`3MYbXhUGd?>6lQO1[g?HhPb\Q[>=5H@SPpS`UERQ8E6n>=bMLlQg1
`59SoA64Qn^8Q5Xg2ABO>blhB3YpDZ<:3iDM]=UXm7U55U^`SX8UmTI@WFmFi\g8
Ji]\X^3qkaOP9aP3U1S9mfaY>0YA?@Q[J^W5QZ=MpQCf]jUXEVR@Zd]LXMI7]VUV
1>aY2QQKHMGm\kM\d2UgP\Yq5ZdVY=Ff7<Zf?kT`nl;kUdka6Q9JE23F:_@\9T5l
ZLVdmbq>d9U0R^<WbU5QF\1D4;]fQ;Qijp0dAna]kSYIdJVM2T51<oZkjp9i;03F
]i5@9Z@L:jQa30FHSU3emp<9]K_bkLm5Hc6A\K9PZlkEYAA[1;64^QJHl2bLMJmH
4q`@R_<aOh^EjWn91aCBnjWWiNgI]2mbnC;k=Oiemf<\4cDH?q=FPKU2M:T\QDJ^
@lRd]qLbl;QWfVNgeJ=m1HP:f2_Zjk@ZWaa7;i_ceo=eDR[OgpgM5T`gbh?Q4fj>
edge:b`2938l_TNa]JE`i]Mo2XF1AqY8An7N>T5J:J46KjP237M9cGfBKWRGK46Y
]NHKa7pFI23I9qlDUMB@BH=9^C6M7K?[NL@F<q[D:XeTJI37CLcRTef5aVXdN>R<
PQFXkqlfZ]C=J=F6@Gc8F^nVa9;\@BAdE?>LC:\jqUeaQ3HE<:WfA4n0>eL]8f47
7B?iaI`eIW=EM1S=a7_W22Z:aFAa3`mKD5oR[?Q8qCMI`QiIM61C34YAVDm1FaXQ
naNqW6jFk56=H^kkA04OeZLWmHSp;HX_H0V32LbEC:?GkR4UB5k<>2KCF^NiEW==
qLa@?GK@4kPad9idNW^T0VfDq_gPdcSQ1gJOl3;4V`DqJBlLZga83U;SGLnVhQ_h
>>a>6[5fF<mFkSq`SKbAk_mDNJZFOL?@QlaLZb9qWSOY=eAolV;oUfA]?g09KZCg
QDSqP>CR;<8VkoJlPa]KBcP4QPDnOP:5I6ChHabpj7<=:U=;jg_`JNFbo@0a`1q8
D``>gR3KX>agmjIlVb8gNaX06CUaR^F5YiYq9SOm[eU75S`m?T;9`G9bJ3TqAe^_
3Ug^HS1L[78odRA]?HjM<>MPJZXR]QijNL6cDScn8V@5ODR]SoQZ;gT\KPEFTl@R
`Sq[V`3P\84[?o38G^WRkOg6Dq[=9]JEi@]jJh4BLcm2oUbV[pWM^h1@8?0]aUi;
3]1jim`DqeADccUU5`T[E3Uo2GgSdN0fcN7MPGGMY`m`MMF:q?InaLiT8ZNiD=8m
f\0MbI3XSC5_FpAcUdcM04Q_d>BD<2LcfdS40R?GYldnqZMI2gfU0V5=@8oQM`3P
ISonkM3>:mNZ@U:hREU2NT7aHR\l39OBRVaV2V6a40iKp^9F<mX<\G0Ql_efSaZ8
dckEJAPUcCNq9GW]^`V9<SkR2V35C1Y9:UHnnDPD@Rlp;h8m4B8788]h_:?EJRPM
IGHZfP4pEPeMPdQ7>0Uf7o6`7GnSS1flBLcBNk9qY<09SP853=E`aG=o8hb`Db2m
6ej;I7Dp:7j\g8CYMEY@0TWZIfB4[iPao0]po]SeIOgITlC0icQEG02\K_1pVQ6Z
NeA_1]noDL1qGQoVAHAfURM3Sm=;d1>VnFd[pOk7f9dChTVRoOQ[IJOE@;e^ApPM
m?X\JGLHRa@c6`p=lZODh42Cc1Vogl[q=;TY@bnWRN?Te^VLKI^ALE34NURlTSYe
MfZWAUK1fmObqVZ`?\Ym7Pd2PDGRXcQ`]h=HKFZhXSF[L9mm`<AfMkD@;q_\K^dQ
JCNhO7VUig:R6WAac@kk<>g0gIf?>fH9<;<dqGdiM=bP<K9SdWK8Jf]g\k<eZ`F2
LN1kG@<4VhBCo3<0JH710?]gjNJLfk>PV;5o1m:>?>HqV2V:JZh5kZPLGY:Ge`hE
O1LH?_T@`_C887::DSJXqcgFaoFiUH<IS?R:ja66bn>b:>JLe]Y5>_lPZk?lIpCX
8e2jBB>on]72P:i5<X5Q5^Ha=M:DgA5g5X3[pR]PcTb[P3S2oPXlIje_9h>X_[D>
q3Mijj?eN<fmXiHEnHFf0=VXG=K02W6>0fgBGd@oERH7\J]HdZ6h9ejUnGP`fR^f
lGa4YNlaMq;SP=5d5mfNlhf;0I6\LN1H5@UC^1U2o]9A10ID\QHVM3p\DCm>ffXc
ebod@jhh>@qNaXHa@NeH\1cD2<3<g^c1KjFh[cIfkHV9mpI7KTDM[DMn>WWX_@a\
Jk4i3BDn;BXP1>5[1pH>1HlnSYh5^9Vd4W??ilDGPVPgZeK9Q0]OVpWfU=Q_I<Xi
k?faCA^L`E4UaA7]C[<RbIh6>Ih6\pf2AOZ<1TcKijj<Cb?LJ[?<=:VH16<:ihbK
FH3RGqbjF?Lg3oPVkSh9X=4U1@OMQK2Z\l`INfFBdT?i3qfV3T:RFWQ_D<Rl:l`\
B@:o6S363`T:n6]1Tg7S3pPPll7>]BXMRoE_MERAO4N81ffjHP^0^_KTW=fVp?Ei
@QT6E_i0i6S7E?VL_0BPYIbNkHG^SVVGCiBqURK6MY_5fMEngmDMjh0MbG?U0A47
o66>9AP=e1pS<BWok6Q;KiI;PR`M\PlXI07UXfBpTZAnTbFgkd3G5Ja^e;>;6l3^
NIThgjUbhU6:edpgJF`oo:QC@Q^`KUbbOeB6SPFd=XAqG@CQXnJW3joYnXRiHo@9
?N7Ylc@3q4eGf<U>A@Oj3PdDI=HGPVlYJ[j4b_4pTRDcKd4U@\?7`hV;WPW:\Wc;
Fmpg2UYeT2I^jDlJeF3hjEPMdaC:bc65<XU;Jp2Bh@8fX;nJEM:mBNZCmfZDdD;K
onXDp5[E;?1W_XRBo@^Fj8MNN6kjL36<j`7p;FUiV[864FeF5568IdHoDL19C>@P
S6jq=GdY;\\RPU`aRk0=n3KCYJp01GiJE3CNgIg83cENIbgI9eq?P9JKWFI793C=
jJCmEi\>oDcXnRb`ETN\ADZ^5Mmi2OBqgnZkCK>f8:N0=C4Ocfm:HQ5pD>e_>4TS
eTVm[?Z9O_BUd7Zoel:mo43XOleHRFD@Xe2ap6m5oTXI;P0^>>dfY:Q6aQf;hUmm
b]\nTc`bEG9[9:Zomq?DXfUM6`FR40QoDHE3`i;M_Ajm^X=Z1RGI`_HOXHFcpS@L
XfI4aO`D=2AAo[^FgYlV=cmGIIWDqID:n5YkIORAT2[Jk07NT6aoij7eHoF5Sf8k
n?\G5bgpT;fbnTX8;cKQ1?d8^`n53Hbpg]P;3U_fWJ>k_NN?e\QXM3a3F>N?FoJM
K\bPJKqhQKebRRmWZZeUa`lN6m\SF0\oA9`9M`IW`W`TKFp;oRWM;>_kB5<lh>XD
GX4LCfRIGS_ONA6S5Q[eO8iX`R;D;fC6m^ln:6JeQ?Z==LeT@jD;8q0m648Gf57i
JCB^;9Q=iM7ld58[n48`S0g4^JN1qFJZ15ST]R`K[dU;dV\n]eh`af3Y_1JE1cdP
Yq2g5Qg6\2?P6okWkIe8m@bQMqO;=_J^Xl<e<E1khTZ4PPC=[^hPnq3=?@:_m\Tl
9HJ1IM:PE_qXA3N@GQ6ecWK]R`Jp8m\?ZTGj4iUl^I_OldlnQR7[aVO^5^U9jbn@
6m>hk6GZpE>QioBLb7`N5?la=nN451QT@6jJLmk8MnSLTE[FpUXE36kK\;Q;k:=U
XOE^`Zh>o`9Do]ARK:ijkABXqU=[c`b[91gmgcBZ<FP?RG^YL?o@l80IYXe5d;J6
?F3jEWYo^pWo[bi7>CV;=Kdgm\SgOn38fpXg5W:[j3mjga4;>\HFTThh3TNWVQbo
gRV94\=FZZDWI2Xjc\q:f`dC[MI?IVnlagg?7;OPf;LkV8G>NUO@Wf\XHVJF>Wpl
XIXU?PD3OS]?DbB3o<DX<SU]5G4ENS2UJ<[YY?oc?54OjV9p?eRX4Y0URZ0aIf]h
BiXDh:TGc3I`<G^\Vb8FLbdVGf?fD]`pgF[FE;3AFoXIbM@Ye1<o=2Q3UZdGLd=0
F\b47SNKLl4Wig9DNFTYEWqGcgj^C>lGBOAmnM5SA\EGJjUEmlg4K6Vk\8GdZQiK
7]X_H^qj@1H18ZA8SoP4dP8dJ;36XL<7CadUB?;mR9HFOLKYnmbmP9p:km@;GS;A
8Ji>1K:LXSPMZ1@LACdNJNIXVCi]US44\U1=E@pgW9m\F2UO@PdLDmJnflfW0DYA
<V2^F=\6nXlNC]`a:\d^Sl71`4Scmh4OS;KOji@aeA;k[Nmo;Mg[7WlaP659[^6G
<GCmmJ0=7Jp=:XSS:aXl29KU8Dc2IWa`3VLWdGEmjHcafDZG0SA>mGShaEGjY_nk
3Hl5c\@>591`DiQjj8m0a6b1UiRR?o;50^cn7GUWj^SnVq0>DY^4j_eLaA>gRV>g
jhTNU\5[2e\37iIPJdOaJY6]0C]je7M`DPVRcanm`TCb3YVXDbpX_4=oca^k`197
LJF]PN0[<4JJegJoUdgMaPpM?jWOdC>_B<B:OLi<c[EFSVN49RV7LD:M<q^76DBK
Np]hD9WnDUc@dbh6h9A_2HM4<ZG=m[ecoeYbVTf];8Kgkjj5SkVT5^70X8Wn58[N
ME:EnGZ`B@_GJG7DG`FG9\T5l3ke4R>ZPekIJq[RC;;WGE3JWlm1[PF[mghnbF9N
k_DHd2dQ@WqAdb\JLWq95LPF^FK]<M]Y@DPodfRgR?SQmD3T5bY3ahgqbVLfJl1q
@6OGMgkVnDBLY=Zq6hQ1FBUp\5daLD`q?k5m64Hh5bAKRYi5M7n38g7?[g]fY;=Q
mDl5YgKp::>aAk2q<NL=BUbpGO>HaXJ8MG@QF[=k>7jNo]IUXj>eNhDl9?mAL7SF
p1?6GFMG\Je15n:8L45f1EZ:R7nC5Bk<b\cp88PVX]\d0g0eVP7U6;01CZWpBEPA
3dZfR7Rk`0GaS2HXB[9:2^JCe[KBq0c`Fk8S\^GgG:e[13U2IL?M<YVLige6>EVC
4fXC7;__eFF`0\nZ^1a0@O8KoGU<CO1ZnSfe:poZM:TG@q6PLMYmEbOYQ:Dfg9Q>
8nIT;ZP21P^>kAE6nn\R5q_=5hhLfpeHRBIMAn`6Z4mKRK1IkMCm=hc0_9GoQWl[
>k`P:Hi6T1k<bGGFMV4YS?B74C@4LH4R\j;?79M2Wo<G>pIGIKK_eCLj9DQaecO4
]NlO1WEM]5gYGqjh<jfJqUY57ZJqlD4KWZInD808@5HDDONP_n3[7eM9aFX5G2gJ
GaNpmPZ@nKdR67OBg5[2b`ebK`^]pj3cCd`>p>jkTNJ=Ej8T@M00>;HMEdc0<KYn
ANc`ANLWZaU2q984K4;E3YlnhSS^5S8lUb5K]oGKoAGk5>>p=kLR<3ZcBb<0`Tm8
7YOi2DmNNh=SV_oMO@9Qg\p;JX9a:aq;7]o:B@MF?nA;S7OTWcg>28TMoDOUM;hT
OBhqDIZW:\\qf_IZ6\qg05Do:bgmGc9[:4X8aP@[>]jI`f35TDkU65oX:`O?l6qX
ne4\1p=9Ifj9p[h0LO7[b3]XfA6VC<DZCGLKBj03o6Lh=:[k3U<B\@<1C96V^@>1
qC5^M8_UqLkZVoZV^Gi0ka3ES2P9cnG3`83\=2CY\J[D<N=q1WLMB6L9T<3Ha7EX
Tn6TAdLcG>77R76>0=p;GD]2k`EG5SG2>FY?`WUYS;V7Ub_;nT>GA3=:K:0RJV4n
OhHQo7o>0hI:1a4c5N>j?XI_RqUjYH<:;F\3M_0C@k27ET21QbU0X@`6<MVRS8A^
qc`N;?>p_;4aC:qg?a5J:p?Hm1EHqkVNfCn4>S7FVFBMe77kT4_]e3Po@O2fDS2n
HnmBMk8[df5hJgeGmSXS<;c=?<OY3gbCIXKFdqg9FL>=q1@`nA<qod`_<^7pO<]h
cL[q4HCa:4@pK>Ge`gX:fRod6OC_hAI_2]V_[CO]I0>Lll\K[N`qUGZ`3VBX7aW2
a_B0;F>2LT^4YhWLCM=2qeTn0nQX<`<OWe]daUEcVZk0ncBT@hejNNN:GeUp4SV8
RHjoY1W=<O`8=NFZ`YL_HaL\3=RdcE75;Z52q?ZEod>Uq=lD5YJp4Q0;TVRp=k3U
N^4q?P>\OL?pTg9XKH2gUkMWTMhS9BDWq?n?UDDYTK2GoJUf2J`RO<h8oWGgQ3a5
Rm\L`a6EqSc0hncfan5<G2O417:VO?jd]QahBKO0kq3[Z3oK`QlOfThZ^J1]_D^P
AGdQ:[HhWL83lgIKq;XO6l^Qqn5@;12^qQo\NmgmIRGgRJC9O?igdg3dZi:D`TS7
cQMXhel;Xq6DoTfl]g\ciZHJKC?QH^NgUfT:T7c6pg\gn8FM9f_QSd>=K^M8U?AI
pi5dVV2OKAMZKWCTND<alXE0Y:GffOX2kZ7<;F^OH3WNmgab7h5Z5<LEWq_EhifL
1p_I9]29;LohJBC==0BAIkFcXQadMHG<S63VSpL?kBieoK]EG5j=DKaZ[IP9:PoK
QlqY<R][54oh[`@BF3_GTIFa:B=;gfYLVF@[2p5B33d]?qe6D1OYNp4JJQW_NqSD
LY2D`9PjFA1mTe3:E@=U0UFMaFJCI0ZJE28XWh=Bqh1Qgca0bi3QijITFS[=qL;8
NO5:6CbigKFXDJA]ZjUL3LDBIE0Vp=1SFYDLYo<F2j7g7B6XS40K8ZLWmNE>O22W
MZKKlJmqN]o@QciqWTT;8NQpKgEkU81=cTOkhkCMQIQ==MEAK6QO5YZN6]^?gl:d
R<4Nob\Q1[U@UNMifGma0fIjJMdG6?V`i[Qc:S8eKZ\`W6L[p4f<4Q_H;LUZIWbP
9WEjcdiMkP=EUHBY@A7@]WVXaZHBGokHIN\g5`O2?:4?pmnXFk5n4i]JVNS[fSZ=
ga\B4^=JdIF=E9TpD5Z6D_[EQP9olQP??^>RijagKUFSXiPUe^<9H:;WN?qO6J<H
6@Ce[=XiGR\BOOBPaVkH4:q87OSbE0@h0nZnhGoW8:Sc^2AZ?><aLcAq1PBT9=C\
\?@E0=>j<BM4;BCJYD>?jc>qZNof8C2\jQPgqjd3A`F<Y_nkPURao\X_TBU_nG6E
:1d=5<hMnj4[o6kNk9<VNALQ^DA1Iq=Em?:L?p?^a?AeiBcEMjea6i^RlNTOi0j]
fW]npl4\jZ;la=WMCD0o?noDjh\=l\f:Y1E>]bjXe3@iPa;1qD]a@9X`q@Yl4TEa
pW8ON2Ld<3NfRZYfLQ>[=VEDE1DjXWc_bZApg6_OU5cgIlQF11??ePD\?NJF@1dB
@UZfDNDCBDn=8Qg2kgiRcNGGAYk<>U9ZU[[OMbqhoF:dWXmF4IE:]L2VC@H\4;\4
Ljg\^dVqI:e;Z=Zi8EWaqiTLY49Ae<_`ZVkjEcf1Z=B^dgFUc??_QY^E1lT\oU0J
XHBe\i2@NMXXAp?8En;:HpPRYTQK0TETPVEUIgmhl;alH7P]]73=p^BC?EIhnT]]
L7:a_VRj=_PM[c9d8jbSU6Z`;j3`4D9JqJWd2ZV;p5B33d]TpL57oGTO5@U[HCQg
]`T@p:lYdJ6_q`M15HL5OCJN:13R\8e^L7i^53GZZ0PGoBnCEVVQ?TGRbVTF1Ha]
hZS:<YLAGbUTTRL1CHL5OCJN:13R\8e^EcJmWJDARZdq9T8IkSNT8[W^RFI?2oIU
@EBD6Ib1H9lp1oNZ`bMX^L3lSiEjl5cAPQb0pJ[L8B=d4INgfWIgeA_;;>R=@BXc
BYkbSQf59_LZ8ZY[^ORTpJ8>E:E<B0KBOilU2PPhQU_M[4O<WcCqIaPkUb?[B2RO
k`SR_^mW><PU0:ePinpS1K`>m_hdZ2HqPKC<;RUD\IHg9R>Y9eobKO=`YgHMH@eF
NV:b\>R9d6;5P[k@BiI83[nq]9oQS4=4Q=EB]XZhqecd2<[4q9^bZZQe@:_ml8jS
`e4TLO4^dn@AOh6qRAIi>8oh<GOZiAWiL8I4Gc7XRRjB<JlFnjT3k;\C5GSh9Aq<
X>3XXhqkO0ePLZqHPaKUGZ5m:\N3gc0KQcD6lJSEI1o]G8`2ap4X1^]KO2AaLjNl
1YL?_VD]j>6[Mb8ehiGVP3me81PMXYO;jA^KV7=48hgO]cJBof=:_KqFacCZS9;^
[6<k2YVk9VGoB<Sb:2eF2qYg_HmPc>LK8IqHg8K<XOJPW33eFZFE?6]G]6^blA:6
a_ig7^<E]S9YdQP7<KXVaX5N3mqj^:@>j=pcnm[Wid`QWJjSenFLTF?E8cCMA`L[
Bp6QS16ido>do_1M7lSM;M`Y]_<<M8U52K[UI1_A6kHdfFk1q2V[Bc=3p7Sh0cL4
pT8CNAGC_\KbIVDS1mXUTJoWj7BTO?`M96ELZFomnLb8GCTpI=c;k6Yp>0ZURhlc
F^1XbaH2^EI8c6Ge?lP>i^;i`>hPGin9KEbNMTXIK8TQNkR<]DBSi8SkUT_2<a_V
ZRSnqGdgJ_TiI\V^_ffQH8ZPSF2=E1kBeb_kHl29]R4QWJg0;22?MVG^4iT=N7gP
h>R`l:IE4d9hbL7WUMI>KgQ;aU=f8T8HSGd\UXLd5pT72]3oEGG9j2hIP_Z8nXCS
2@oGObGjD5<alNq853XDQEIZ7EDh?o2lMaenoCeIFWo34qBdcMZ<Eo3lJDAJ`[AX
Ml6?YSe4fFc?Dbb7:Dp[;1VjknE]JM`gJXnPaeLC[ecm8ZLVKS>Biq=K;;7]mqmV
]3@P6kZdkN?1NY?NTEUm5_fh4BTdDDZXpKj:KnLRTHP9<>GX?3TOm<Jk1^4LO4\G
0bFFRackHTWh^dn5\dZG>267T@XX[=LDoqoES>:19AUR][fj]63PiD:UV>]?6;Jf
fn=?BY1Dq<Z?K2<1B_i?2IZ`oAY<NW3846=\oOKTXZRpBh3CSLXq0Bd_i6Kq_a\M
G>Iq]ahBLGR\[ii5]XOkTZNiN`1Y\H1m51IhdNg:p<Ui6H5JdR:`QKcSV:BQZif9
V[\P^EmnOMEc>X7pdnY0SaG2VYkNS1<8Mkh[Ro@=X_G1X;dNIj>qnD?WMB10;55\
hHh<430[NS_6Hkeem`EokmOKKBqNO`H2<jp3kRBlX\pff557BnW<BgTLM02RF\Ye
@Y0]G_JgM8:aBXO_i@Mp0Y\lb>;S<lNa8bPe`HPQnoSh>`o>q8C1S?^mkIVJ[9cO
U6UDF2Qbq]Ha@ADfpN]nK^_UK:i1aXbi2<>XaYOc\M`OgO7HfflG`pR==>4dVjY6
cCBok]=N:AV[I^PNeI\i\on7qR\1d9AXC\2bRJ:K^Rj4N0jlG\7I`IFDK<gnlm7D
YR2RT<2pXT[VYJ8^2hGT;0a\\XjnlNBcXo=0N`@=G5pk<i<a]6qB>2X3Tipn4TfR
emp`85e:AZCNNbcT^WJgQ3M@HK9MV2T5O8<3D9`G]pIU:MkLfA_Pe>X3gc?6DNCL
_bARRVhi0e<KWVh]3DkmDQ><U36mc7=;TNU[;fB6_C?lRnqM4ZO>5caF`6UdPT`^
Y]=eDlQ;AnCB\gaeSmpQ3Bbh:TP`ZhAm4gMe22;IbJ3L427V6R4e=aBkBqij1Mbe
mqi[lQ2e7qPK`<Yl_`G4cDAJQW0_kcIJ^?@>8Qam?NmU`iKIJkpo[S3JgV`A^O[7
>0a\`0GO_:7li@HaiXSqlhb4bM3MTkI`Rl^[M><mM=PMlPnHqJY2=Q]bkNI=9^IB
]E4iLVkLqSW5Ao:NpmC608I05VB7e4YJUKWQUkHFM_BLh_@=4p9SOaQZi1QI9Qb:
L\Jn]W`UQ4C[gYa5;GpmC0FGDjEK]05`eNf8?TV`e9IT=;_IH2[ng\X^L]BcYAjY
jPUkjOaUM2OT5?fh=M^99ApgB8jBDepbV]4;Z`qT9oh6:9pT?P2lHih5MLU=I\Wo
@T4VN@WHC]C?i\]qMCc@Q4L;Von2[GKHW243:9dI?Oj]2ZT]pNZGmc?SNjKU\GM2
FU;NOWV<JTdGJfSISQdR2RJH?]OLhSd4gEa7E?YKKjkMBh:qf@Q^6X]pNl1aJLfq
MMeklgM^5Y4Pd\1B2b5hk1O:SG^hLUO7`>>57ZJ=]ETi3CcGjSgeTNBkhjL\6G>=
<SR7XJ@lmKL\eR>75[N_Z1WM1\MK>`AR]KhRq3Wm8?P_HC=lT[R?@W2n\A6F0mGZ
6SnZAJIU6oLMIP]kfYN5Pn9al799U>nQbPW3a\KdeoL2:OlX0Q8:QUjVk5THZ4MQ
_n7?5^Lb0>Wlq5P8LeUKVRUCa0jRJaI[1iinSK`BUOA\bVOP3QBY7qJXJ1G4aPEG
5?IU3;SoD<aZW`4OA?7ZU:aeUFK;lTY6[La24[@Qk7VOnMbh9IGCdPlKj`hQ6:W1
l?>nlPY?Dh>o1K^U@d==[?k]9oWSjpUG]57d`ge_@caQBZ7YXY5f_G`R9bCW_nSJ
aEU2A\LlncA:?<XgDLjdHZYj[MC4PfS\`i8jkPWEkZaX0H6Xl6j4R]_@4EP=7eX:
Z2ZP2;5eq5AgZNXWA?3YD6j`TJiSH>mKon>i[II3Lo8?Vh28i8giSiUhCV6o9Hk[
b1fnDZd5Y\`]Gh03^=39@4LGMeg<jm8\XTFCF8O4DcnpXPVMiMZMU`cD8h2\aPB?
bIG@YeKT_FgmJ<Gg\hdlL@P8<iR]@:k^JdClZXHMP@LZN3C0SKV4odC]832`[RU1
i<:>Z7NDhk7C3hPIRLAFKPWNqOVZB1I^dnQeoQ@f6<c^:KTVUL<hf^c>mFEMIh;k
7gmn\N5k@n:_]XHC=I@NS_1DK;]Bb=A5M>F65QjVkk6gafEAT@N`EMlfX=@=oS_i
??9pbka<QT?ClagO4M5hjJL:Ia]N[32YQ[L:clia_iehb_VKnVHUcZ^7h4]<O1M^
V;9lU8F3Gk5OR;Zb?1Yng>\LC5QVP2Ue0F;GKmB__NSp9V1l9InQ@QW2o:PgY:H=
@O1P6JfMaeNLHhAToXoCU>>ZXahaLYqgan_WS7RPhhh4MNBFJ5gKO>F5aFCba;J?
hf;dIC@Tko]i]QL4OQ`fiAemX:h=g5Ocn8jed`WBb0CP<O4?TDS9Haj]>p]F:aV3
Z<`3G7N@\7_CL[ZDW;FIEE6UOD=CH_N8BI?_31L>SSG[:[Hl`6[T@Kk6Aa2aQLcD
dZZJm?jDVJbI5QQXGJb0o^qUTVNgU197NBk7YOSZ<gCd@6Uk714DcgMW0n[c^L@O
]LN;\nQNX8enf_Ab=20[DWY_EEbU?dkokEO057K_m1@VLCcT@m8pfBNa8JGn[a6E
fWX>l]nFUcL^CoVT;EA0JTKU<l]M^o^_MoFHE8mlUW]7dJN<DONggI^BFie0JMgT
0QU^m]VF?2>b0:FSQ3AXiRYqmYKZbV3oSnjlEhE3aDgI?U]:hSnR957AYd>1A_64
6:;Z>2B;Go\FacmZFJ2c`k>p\3BeIf:KWNUS_6;7ST?3dj_;2ko:U`ngQQX01NkB
Q<\o3mIi<3d9McKF5F;`Z@gpCmnogLJJca>bGL9jA]jlHiB6eD;@QULNPI265lRf
AkV23=156O0f[WP79e<S>]EXV[pPAF6L_HdETHVQDalIe8W0TH_HPC=:_lji[e41
93C@j<jOeWGFl29?721dCp?JKSK[D6YBIm`d1XE8e7mS;;dFX[@25e@A`VMTGcgM
@\<jic\gaKnEdVgdKXI\@319qlbTa_LT>D=2bH4h7OZ7G^8<0@`:CpSjboMI3g;>
deWi><lA<;nIG]d[6oe9O<Dg7UWaTRV1e;Ln;;=B0?>RA;Xd64JjSd9TqK_l4g5[
JfY<J5WIIcK`M2]b@W_fX>`lK16H7FX1hNLe>k@_<VRT@cOXFOm?qmVc`If26252
NaW6^^[n114knba5ff^:37e_RHWI^97:]VM\2T`l9SBY3Y2Jn3N=pM8ckmiachl[
d@;^G>4C\O[?g]FT1I^nhHdhaKVL>nHCfo8k5]nqfKoFZ<J>f\<hhn_N_If4@:d7
5DSVSQWfCR6b@DZWMEekO4GJRVe6T]e>4hZcplZaV6IQPW2HXKbeME?`cBRof9Ii
M4J_GVmRPdD;U`2U1EX6W]E<<p4>^kK\cA>gm^>JW34F89Xc[G1A\\N=PZ`E?Q@b
F:Yb^>;R[8?HmTq\4>PfN80ML_fn06aV;nF9`@8Vjb3Z>Q[11L3oa1MT_PdDm\a1
52fK;2;l\\FMkVjN^=a@FA<Rf90emDV@WVLh1IgAf>Q\CS7B8>mfFaqeXn@NM]>L
7dmf:N7_Bb8F@YgZgWhGeSIP13b:OeZXB=iEkE2;ABDNbNN^9p>HW8EljDMeo8]^
O^fE\j48e220`=\dYc3m0?iBhc@567_R[MNf4l[[<3i\ml?ii91liLlFcnTT>=RK
UcVOWjE[24QJcQN<?m@5;T\YcpVlIAH2@G6?SjRbXIT^Ab2LLhcO\`0H>chU_2gF
M\Bonhlg026X90loK;L<SCKIH72f3n=C=9S<cAl@7i7L^aU]G`7NB]5n>=eW09qg
6X?J8l21gO\4nK0HDC3;L9m9?7<c3alEQM;Ua`\]V6ER9W<lc:b=_1]?H[0a5^:U
hnU]HRTX`LB1UF`9UMPL`3LVC>o;7>4<^;3`;[5bBTpABLmc`5d\i_mAXfbhJc\^
]0bh^a^V;;n>@T9VAm\deGeWkHCRB_EEVDfRfApL]mXcjL><LhKciR4INKI6?<HH
^9dXIPDH8c9nfc3PTOEbncTgm[l:CT8:D68U@EP1ShMHS:?WOMCq:i?Ze6Z_<C0g
BnnS`9^CD5C8cQ5PU6a>2Mi`Hh2D8hH?4gmK=\ZfRUOHAQAK2PNO@^<3h69T<<J<
?kA93:?ai6qDZmf=h^nY0\3EP4JO787<CD4E9LGUOk]@l5c>I9NK`mTdo`dNa>MN
ZXE<>d1:`n;>NfQi4QX96qF6HWYC5eBXH3j1k4a1B7l2Y_fKGA_g``8Nc:SV3Tpd
5\]?fP?aggf9DOb\?\1`]4pB4LElWSUdXUYn<\]Yb?Bp74cC8<Bin<^2YYolg=b4
YZhqka3Onm<pH]h39EC0Eog7MGPWQ<7MSTObi@UCO?LLU=9><JKpe]Eea6Wk\X02
\\9S_Qb`mDI<BJNKU\MY\lH3=ed?6^5CcVFMb4e0Yd[KIKebSXpce5j:QbSZ3;h[
C46l>e2@^JN2BVbaJM_6l5XTg1q5FKWFXPA\5XZ7GN32lCSWI4gjXVk[gBXHCSWp
BoZ^]AACG<`NPEK_WZiM7FN==dFBgO\\9`9VAkpiI;YR^>PZ0Ha<>SEljGk]OX]k
;mZB?XgLlhEJ\\4SSaphAmCNH8J8Y6e=Mj]MDBXBJ=2JV2oHCqWQY>`IL\AZnJ0T
Yk0E\>iJ@@3Cm4FRQGqD3PBdMAM6[BFmZLmqD1_cijl?53>^=>fbDoSlg5on]D]H
dR<n6ipTnXaecTqJKl]OV`pOT4E\]dpY:]71CQcF^9G\U\3EMI2jf[9MT5GZWAVc
eo:^O`6B3WGA=5q`>NL?j[O>iDdaU3b?a7BQ8_]FLfSjY74nS:DnX?d^;V7AIVqP
G<6l8\GTFXWkBQ1=PO=lRVNPe=XJWhSX^oIM@4RFDqPP`cF8k;:gT18WYiPdn9Qn
pXd2JN^?k4=45WP:l;HY`H_?edLXYLI07VWA0AYYfKhMOA`9F3bp9_B\<0F9oJQ^
A25ojE<3>JGgADSLYFii@Tm?odiW70g<^nk1p>48OBd:E;G7kIoXFh2?A;ET8FI8
1GdY9Ylp]?3jSa]a`@JNi0UORk9S46:?6WX[B@n6MI:Yp?jQ7^0^[TI^n[`lJ?RP
Nd>8dB558ijg_oUmRp<][_[Y?VdP=LVdCNF2P;2`1_L]NQH?a`W=4AJ6_\Rf?qb1
hHL6YqN:Z_ZKcq?6<XJQP0OgNcO3MS_e=cT>ne_fb_YkpdmWoM>L4BSeihQ?eQD9
A1@4]<c^Z4L?]]MR2ZnO\A`92EP\JX;Y>]o?ZQ]@f]3lldc=Vkl]ZaJ7T2RBVAf=
l`Gdem@g@p92_ZXKdgH3J@5oSL3a9Q`h>@HlfiR__aHni?gW>ImnIS1o2Hc@VZfC
Am^F=noYL79g8@bU>pDGa:\i^2IU`Kb;Ne:]:6XVo]5]7\q5M9?oNl4Ujl0IE>:7
Y<19n<FP6dg[UA3dIn=I7D_MN;ZNU_YgIYP:cYV5^>Xe:Z;\EpA[O??iP_>aH>aR
L65Z1kZOZ?Q2oOTTJikA<1C:\aoim`?VqVacFI]k1beR6U0Jc0hDI6IPI_j_=cVl
PpE=P8geOC\MlUqUOW<BYG5MG^\[QTL]XG@M_c0QQIYW99VWaoakbXfCWVE9;L\j
7b8O[iqNmDo3PnqmNFl]X^9o^<jA[i>9b89]CY_=lDY=MaXpF<;0dh3pK4k=iSR7
BXc;?3_Jgn_aEC1mmB:W?<;h6DAmUZKWPD2Y;W9\7KkKe?pWG?65AD04`7PCP=l]
dnan0lPW5\65[]P=1cI;C@9f[C8iPbkeC\kBZ[Vn`TkAS\YRdMbp0^]\IB:d`<S\
_:S3Ccj1C@LlUmJ6a]Wc8;@W;YnjR^V;<1q30IMAEApHKd<iHbq^8__?FEq[oibR
ACWJli:J7_>oK8[2L^1[Snh4?^7GU1lGQB`8YLMJBq[kILVHf5a`R9P0`of3`gcB
Jg>h^4Ph7b8ADdc>@<4lK:I07^lkmjmbp8ZnG`j4qUjJ9TZKp;YJ2`m=q^nj7I=B
nh4UEM9bf88^16I_\qR3`Gl9]ajjHkS?031JhW7h6:Hji3L=VGU_LIH160U6ac>L
ZRR2]EDg6e]WmB8cb5RTKQ[0kBhX5Rk?;PO5jkZR9IT@@DHfVKm50<9mHZSeiYQU
7pnDG8hN?IT:O0ihHnhbKZDJgmZcNg?cOTN=G=22>_[>OQ;GmLOR2Z3M^BgBf\]o
7FnUPCO>j0Yn_=6h0:]767b4]nHA:KDf0lpIWFKl9=eZXZHPmI<5mJWd7XZ0C^AK
J8f7X@EX@GU\;nd9DPHXSRT^7Z5cmE8B?<@IdH8GE6^E[F@ImY<2RhKk=^@Yc40h
n^eqEbjMfoJnH[9nKlOWL6@XD<kNTXM2>A[6K6Xil7^@QKJaB300]FE2X8XbkX=V
AHHfEbjMfognie:a19n?TX1CW^D4PYWBk6kORo6qE8^4diUB37QoOgQjSM`VEOJH
1f8eN5En]>m?1V>BJoDIQ5:Zg]529Hi3OXRe2Ka?E8^4diiK37QoOgQjSM`VEOJH
1f8eN5En]m`cpZoKHP]1PB0ZcA`ll2UjbnB5FOKenlBh`Ubc1ALe@TYcmbQjQeHk
n`]O^n[5h8T@7ZoKHP]13B0ZcA`ll2UjbnB5FOKenlBh`U84?q?5]9i7V]F;;LnM
\MY8fAjO3[Fb@m0l:PUKl5ZYKlLo>CHXmUEGgmLgkPb>[TQ:bd?5]9i7;]V;;>nM
\MY8fAjO3[Fb@m0l:PUS46q4U9F?>M?2em2O20X4[C[@KdNLZj=flmWO@S[DJ1dH
De7`h]F4D8dG3dnV=X[aZgU4U9F?>Lc2em2O20X4[C[@KdNLZj=flmWOM?2qcAc=
?dK[gigNfJ[[\hNDH2b]WPXO1HeSe;h0k>]kCm4Q:GS5BLjNP=@`=m_BLjnVcAc=
?dDZgigNfJ[[\hNDH2b]WPXO1HeSeIPBp;SkmKghcD^XoIhhnS?`LMHd53ZlWa34
ReLHCO=X;qD@k?]WbH3MhCkeb5?ZG<c5Q406?K<A<Uk5RGc7M1H<Z=15>[K^DD1P
AWbE7Jh>jUD@k?]W0H3MhCkeb5?ZG<c5Q406?K<A<Ukg`kqAg^Ao7>E@l[fWn]`J
2hZe>79alM2gREIU]:EMjjhdQS>lOl:`RF6mAXbe7:?gJ;fOT;j`9>m@l[fWeBdf
3hI2AfpcH6;_3IV6<=7B3FVkA<ibA8o5YU>i[cm6BXqU50h_0RDZ@RS3?eiG44?6
08VSe2MFL=5H>>V779=H6GAj]UiVOM:l8VkNN9`cZW3UGVUhIH`3C:0O1bM`AU42
>?>]8q>GnO2IdPLDAfIi^CHa`Aam;GI`fSc`HUKR1QFigboledAH]\F\hEg>bn>B
c638n30<pMd:d9fR=OSHIk?NhFWZamBJRJOHW8;U3I541i[8@Do^^5C2IhG8E6RV
JChR]lGTnk4qJn^e<:OOkOaZo[TFn;Sk7<LG9a\O<9;XZVl0UanfKXLE`nm2NEeh
4mq41o6=ADQ@DBeoH2ZRJmH8@>NO2?SUaXmjnSjaMK;6MQJZ7VK^f_6ch4HcI;5?
?dKK0q=^CdOQ:jRSTkVmBXd4lGk^_afPPjN\`?DG_kNlD6:O@NhH11bKF54g0lcN
k@cOkVA2qPgY]3A=ZN[eUXV0Q9aC]N=X_;`6n?S]OOLXC@HVIY3?Vn`@^BE6kJ;g
?J^Y6jNl9P>E\pc]fd:alRU7CDMfl<dfibN105N@FIgIjmR5`[NJXhe[eO`;oi1I
:kbhc3M`fpE`g7NhbeP<^A^TNU^lV@Ug^bSC[KKMl[K=N`i4C:S>W95`>^Q5JA\`
Ml>@S0n8\:EGEJpG6dGVkhOSH_@`J;H\M8XbhGFViLJg^e]bdAfgeGiaVBZ<go5R
2T@MMdiX]WHK^b^GWVPp_?bg7?]mQhndjYjQ1gL3WGCY:X8[bTjQBlF6jcXDD9f9
j32iQ:>=Y?XbPB=]E9nl_]Jfp0L^TH3_XZ60]J@CM20`4ifY04UKBH56`[FbcVW=
7clk35Y4WKWn9P0]ELT[F3?]c02Ejq=BM??NZNQG5>lfU`^E@YHLe7o6lJ=dYEdj
?U2^lQRfW@4h`NHb6kYo>5cj7UZ9D[=I0Gp?PUE1EF5iik3Q>lI<ZLGEY\Wg<MYp
o6d5^mjo;>Fc`fFbf4P1Ph;AgWK\WEIHO?3i?07ZQ4`J;h\W[NS9>^cQb7Nj?mXl
oje8pi1]LVohMdTB9W1Vg>>RNlncj9AAa1R>hcEES=ab>cE]]mN<VR7C5N?8?b[7
afbIQi_JEpXDA`[B2I=CKVIHkTCY4nhX7UM^MZ_c?NIbVLVe15Ya?OJO\4aCZko>
^Ae7Pi60CHXPRcqF9XO:AFbeTF]l28kh=ZnUQmA=]<p6>=4g56bHb0k[>G1UX93]
`khK;><]liJVSaLbb9CHAY;Mc97V<[>PBk\A:G_[LV36oLFpT`0e\869g<bSL@XJ
292?\4^A`Z0`\PjFTaK:U]a;UjV6T>\J_nM`P_25U:g@Z]BJYM;q^U[^RY21aF@J
@`H20Z8aIZkaAnU]T<BPhh8W[IFa7ccXLFR3<TaVqi::8L^Kc04XYd?8NioLifE>
9Ea?c0;b31NIW7EhbdV9;FfSc4ZF>JD:@gdBG;]Xl\oS]o3o=KkEnq27<DIjQn?o
[:oiG[>>86G>D0Dj0Vo[@ONmNEFkUn04H2\gl4go03M;3A1FXq4;YXghn0c11]`V
kW0_MfGlYJ^D]<R[LjT]aL`Wn\]n[?dTN2M0nl[Kad]E[ok[3j4Df=n8S4e=Ql:7
:]0lF30;ZqXMKCRP4mdd1n>Cj8RHCbJjoLM\HA[``e0ag?G=^2JmZW>a7b>iYh_U
TVpDGeh3fTK2YFYVKOP36BX^XkRQB>=GWo<JABQ@k07fBRn9Don42`:TnHSQE_R>
X61DGehCYZ_=:hLobAPbFBbXKk@Q<QiW:Chn<^UKcqkVi;o8An=g2fPMo;279cIM
\]fY9FB0;cFJSZCgM`2h9Hh_[R8[`@1iiWV0?WU6@Y9GLJF]OV9hU`cOdAp>04n?
L9BM=c<G7JXil:fN6_IC2^f^=?V9<S6e`MZa[A[1jF1;5:G76I6ES_kM4B7YU:HH
ZkmcEaP5goZpf2T7?bJoCSgC`YRNZ7dl3c?H;7Kndghh@6lWGOS3i@n4?doJ5h?k
O^ecHI3bbW?=eD<gBTj;D<Dl_3cogA09F=`qn4?88mJLVdO:nPfWT=TaAN]Za?RQ
paDnXjjHIhRNL=8EEa;Md>=lIMG0i^1m8`KDhmdoUX?hl`oRnU<BWl]FW3aGPdih
l^=Hfh<@_1A[fP5dYq:[[>A6EIc^7UeR:T2OXBR]KYNJT[dm]]NXNUKmW714BC0H
mQlfYW@3X8^>S8;]Ohao@a]iUUNh8681qMHJC>n2[K_OMLa?n]8oWT@`JE3T_JIh
=qSikM`:>7HG6FfeJRCmqnf\>5?CqGOB>j=j@a\L:F<WG7oNGlMN2`A_c_h[Zl9B
GkKgP1N7Xn<h\i050<NRRoXQbX68Kc:GqT@EWAh=:@M4O?1;fU<NQ6TbqFBV6RAD
mhXRNWla5nD^2dfN;N31km_L<kI2IM`>NjKMK:OZnhDe?@gJ;b]YZhJb@F:TUiVl
:O=;>8k<BKlS36INVfagE7DEe[omWQDqC[EaEW3hlVF;JaW\VhNgPjF89a1_iHU7
1hLcRoh^mnn8E5ekad1eJPD>G0pR8o@\[WTgnUU5DHRV95Iqj44gC7i`J0X<l9ce
BaiXJ5Th4aXPj0oEYB>Lgb4fSUPQOe:7hY9b\l]0enpH=DL?JX\c<gjMPo`<eUSD
?XT`Mjk`2H3FJ:HKL?[N9Zi\SanD=9;QBm:?\K72?QWqP\l^LeSkb<OPAGQJI28K
9:k6[XIO=<?VSB4?Vl2fmV?XZcO?<V5Hc<[F6X@?Qa;_PIK2q7:Y@cL2Ye1TjVRg
]AO?IH:38UJe^i^co1\AWBHN1TS32jPe3J38N9ikJZ]KEO9\;Fh1;n7p;GYj^:2Y
jmhe9O\ce5cW1oP@Q@JNl>;XjkFRg_6;c`Uk0;de:1Un6<1ZZi4QI3b77cdoqS4B
gQXBLP3>UQoKAY<2;i1BnGmelF8XE2IEEn\KAk<T@Ve]S>liK`YRP:E@d<cgY]7_
C79p=RFakl^Y3BJ<?hd5DTDbf\Ln?0A@X=[TL:M5l=bMULL[3YKnm@_^G`ShI<5=
mQ<iqH4lnUm<7bob=PWBBT`>]4\^ADSjh?<X?;8E7^V5SENUR]:n`f2fCkb^JDjE
7a;Xc[IaP_Y[;765ApMC]AATVG>2^iT6Z61W;TVfc_=^ceZo<]l`^jEaAddg5OKB
TT=kHH;k33Y<W4Aoo^pm;7^IGR0\eOCTXf?B>Q[E1[4c]G43@NJ1@6B>Lm:^M<\D
eH[22T];ok>YeG\R_1np^R0``1]=8@E0H1XnJ:E]nm>BYBXP0\[J7[>hk<F50eTh
YEjNLI7]3Xd;Tj8pd_Xfn=NOALVlWHKC9SUTbDD5B:1NJ4E4P[OdBb1Xf2P3TGa_
Sdgmb6KWB`Jm9653?L4oTg5m3J\I=d7AQ2N;Cc`;<a<dq]<9>G;TGKCk9g^7S2Tn
`39JRb6AlLg2^ZdFcN91kJP<HSYZ@<O?m1Lh9LaPPQCk61UVkcf\qfPIhhU[<b^:
i[V@8BNM9AZR72lb=Qhk05IBRfbXOEjg@@][XmfDMcARH]UETGeCcWRP68WghSn8
1W]o8D3:5GFSp:\hLZQDS4?a]Maen[6L<P@K4TNk_deA`QBaSoY^S8U[JOo79m5B
E0jIGjcmpR\g2lNe;a];nmR0WQZblYI6@Pa@QEMfPBVXl>Z9:[]Iddg^QJfXkgS[
IFQghhcYe[6:7gXG_WWfEbaMNWkIbeRcqiTJbjjC]IS2W4SJATX5Hn9YV<gB_Q8C
dh1L\DM1h`Te?ToNP]jI\;jL>dX6:@CGU^jlh:aV]9Q4MheJndRaI_<XZV]R9]2b
;QH\h:>pfKLcJAk:_Ii6ikIHaC3RL`nhUaASmEIeOLM[d?DNW:f]>[Rh]?YKY91`
I\]H<4JIFM=\kNaO^h=0e8fl4S\L=LGiqF0bgH4afEMkP2i2FL>O6kmR4nQLDVC^
h4M[NHWFcq>A43<WVA7CB8[=803AJE^Tk:06LH2e0Tm8^]5=b8;HLYM87Q[GXF^<
FgC9bmV0_iB2TJ1MkdMcODBJ\VAb88KdpY8S2<joR9G]S;GVVISW?eV?MFkimeA[
dA?9OA1:I7k^L_oVL]=W:YEIiLfjXoH0e8T9aS]MaP^3Cm@EO5eF08MpXH=`2VjF
[ODUVW;Gi2O2QH49]f>1WS9R5JI70ae16Ch3dgIM60K4Xj0Q<AV52EHmV`6>51Hc
\8TD[Z1PLQ^0M8p<Uj?dnSjkX0S0iE69[WZ@El@^<W;<4^DLokI961Fllm=UU]j]
@`J\0kUfmh:Ll56_2AXDA4\nNC0fVPbZWDF2PpS7Ya7O]0Yo>L`XMOTDd\12DG9]
@IVV6hHFDa@CqX1^N;V>q2a[FAc0pA^J<cRF6ZIm_3@Y_qKQb_4]Mq3\kQo7mYk^
Fo3WXVY3bmJBaiLZo4^X<3qZGgF8c1pZF8QFC1ioMN08aF:QXWUQJTZfW02<hIfI
4EPWg9_XKWBR`3NIhA<pZA\e2O?WBiRd6L@[oAG]^iTMTmXR1Dn<A\GVk4Z6SUE8
P9`PQS2\p9WoeSWdLR^BjJOM^UGnDH1]g]]OBf4CWWMhBhMATLh7\7Y<@HbZT^mQ
[XAEEPOJE2:9dBJ:pWHfeKi0OdjNcA>Ul=2N7Wc8OFI9J8dT1i0kD0@D20@N@m;o
HmAC<qcDMD\W:FC2K^C@<8Z3b[\d2m?m::JgZFV2:fdeIQWJP6Dl>qfGZgT^aMO8
f:eWKZ@0h6:Ake_IiE;=`:kUhmVRg73Wqa3N4$
`endprotected endmodule
