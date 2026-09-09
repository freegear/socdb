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
// File Name             : ICSynctoHCLK.v,v
// File Revision         : 1.3
//
// Release Information   : ADK_REL1v1
//
// ---------------------------------------------------------------------
// Purpose :
//           This module synchronises signals ICRawIntrCo, ICIRQStatusCo,
//           ICFIQStatus to the HCLK domain to remove metastability problems.
//
// --=================================================================--
//
//                            ICSynctoHCLK
//                           =============
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This block synchronises the asynchronous input signals
// ICRawIntrCo, ICIRQStatusCo and ICFIQStatusCo to the HCLK domain.
// Synchronisation is achieved by passing each bit of the input signals
// through 2 D-types clocked by HCLK.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Component declaration
// ---------------------------------------------------------------------

`timescale 1ns/1ps

module ICSynctoHCLK `protected
F[HFVSQV5DT^<2lDOQcONbLqj83amSCZZTWCTLGdRT3><dW418TIBK4fDLGmRT9m
Cg^]3bSfP6p2M55:GV[:@Y]edc]E<UU[^m;[i7iJKOHq9fjlY5\C@U3G2ZGfQTb2
NN>4_C>dd>LCU=S;5DEom`?bhN6F?3;hUEBKlLXRUXLQG\HJ;_A>iSfHZie`6=Ae
dNnWeTqmAE57j4LD^9@cO13jCPU_KC]lH2Hn8_M8Fn5^i`Z<>eH`VX:bUk9KMRkh
c@lO:Y_o@fP_k>3k;1qm`V2PbKSNhUoY]l2q7eKN6KS6jY]OG<YQLHbOpQ\hI;a\
i\P;_]]UTg7KZT0_X?llKJ:O<9cjFm9N8p7Kc2GTS[jih5>FDik;?9K>WG1RhlCN
m<<4M8;D2Lj\=qZaZPG_XcIY76cf55bKSJjiG>DM[4LbXLK4CNhUKf?S[q]@Nb9m
`@1j^OPLC?jl[L_lZC6L[iJALeImNXShag>Bmp5\]`E:Q[jLFM[P[62ZCef3PCTc
6>8n:[1E`K\Kj:pQgFO2_]<UMNFn1BKBi@dGeUPCMkDYR33Mk<MR3njT]g>j[qEW
ji]ETQ=aUDa=Hnc>WGLRkAVTA:gJ?>3T\Y0S?<Y`6?@6p=<iWbj;UZj5k9GnWpmY
Fb_EHl<ba^Z=7KdgI4qP^=ilnPR9U`YQOA^]K^Y>:I8XGm]1fT`@5NP_d=Fq70bn
U?4Ib3BCF]JkM>>Y53Yd=XdRKSGI2P5N2Cc@LOIqZ5DbLSQ<A2L5f;o6=?FEnT\V
C[XEJ0UO3X_39ADDhl0YRZ\`haIEil2Hf^NM3X[^3hJ54YbVpNOT\RDddbdPDVo[
T]\[OfjeGAc5CAhd[g<ha@PYc9fPqPN62K=pQ4Hf<JFCg@D:EERmYCbbNJW9:BJW
kk]@XTWlD;C9h8EqeH1K=fPLmP8Y2DElNYQC3cI5f2=hF9n:m3FXd]]lbNZ?=`qR
Nb5JClEf0;5FX9T>aB4gZbGO3of?i9K0K]7?jBPd=Wh6npQ;_L64qGhaE37`iYEF
OG86O=0jW]fJP8b89nce^NdlXO7P<Qk3hqM=<lg;1\0jTdJBYZ]41OWKk:NQQWMk
h>hZSGdXk`426aq8[INQHDAiDlaIM;Pq0]6YjLD6Sg^j@IL_n<o;\JG?bgHh;mb]
e?<g_WWJ2PCKqLoi^Fi][`hWeJL`eEGR_Df?diHL80ZJVIQi8`4p8R?=75moDjV7
5OI?\RD84_d1POB`OOJ[kbHKjcVWqeHb35oh><8=GL3mU<oOa3ocXg\4hJmqZZKd
`DA_0I0n0L:RW55k617q=31dXQ6pTR[SL>]6Jjn]=PeDlZ^cQ1UIa=Il8@QF1jNA
@^P68B2p_N@QRT[G05e;7]jCUj3_1[>PRTkiJP4abGIN6::oOe7EWOKPq@QmEdS`
YF=77^NSUfCJbHQn624=<3PaQV^4B^jAR9<p`DJYYJ49C=UcgS;4ijeFafThfBA4
dJ[eh7RI2E<O9EAqAnIRQ3lP[fEO<eKmn3\4h<SIc^93N:FoI813NMM^PdUgqnWD
MZU1kHe>Y8j_;3KF25=m@QP1SAlLolGL44QL7fFLq<ZGR@?Qn=9OE5O7k\E_\\Hc
0mL]mVLbA`\39C3o:6I57q?AoJb>0qg^g:]UNDDEnI^RYFf]U7G@gPa]<Zn;_^?g
_G5mDfNlhEl]=@FNbEqN:Dj9lgphc7650Xq4A9[U_i69ha47N`9LJ1HJeVXA0\_H
cF8HC8>GiJTnTV?]K3qOLA=^7k7FEal9?HPKUECf]36Zn8Na:P^cX6?Y^bJIjdeG
;c[M3qh;2QQ1ciECNiHLWDgdO1FGVA]_g3k`GYm?OYXbWY>M?>QB\ZU`qlE\agQm
8Z>mZ\RIe\^E:a=>\1`aLM30?fTR]0=8c]A_3Bf=Tcg;KpXl?Y?ei8IO0;<G;93>
k:f;42@_ho3BIdNbP;0m0EKPf2?Dc\bPqBeJ[TURg4aPnKEBRnUhS1`JBKJCZZ9`
gcV1]_4_4n0hQJ7[4VfV=p89EHJ6[q<Hd4>lLkR0oHSi0_e8W7d9kamF4k<G4FCi
2g0=P7V5?>1ipR^o:jBSpKKdn$
`endprotected endmodule
