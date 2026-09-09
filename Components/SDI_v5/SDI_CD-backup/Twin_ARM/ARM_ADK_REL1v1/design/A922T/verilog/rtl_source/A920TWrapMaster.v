//  --================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999-2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  --------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : A920TWrapMaster.v,v
//  File Revision       : 1.24
//  
//  Release Information : CPU_AHB_Wrappers-RELv1r1
//  
//  --------------------------------------------------------------------
//  Purpose             : Bus master interface to the AHB for the
//                        ARM920T core.  Takes simplified AHB-Lite
//                        signals from ARM core and adds the ability
//                        to deal with split/error/retry responses
//                        from slaves, plus the ability to deal with
//                        loss of grant
//  --================================================================--

`timescale 1ns/1ps

module A920TWrapMaster `protected
U8lYUSQ:5DT^<\=YHGfYfRVea3lnFH`=nh=:9RF]iVl5h9:fWkn5Ejo4GB;>:oqn
hmTai=gFI;feQ>[<Ic]_65@IEdO;2S=Mk4DcM^c=Gdeb9:`\[?AQO[SKN;HpPA53
LLo<AFSkJmI@FC]D^6ZB1KVqSeRGTeE]NeXK<WbZF6J0dU4nakXk=TNiF6kGVJD>
n1\8aBDhP1<mS\FMVeia6dZVS[>3gWNkiZ@cSXq\@^5ET^QF1[gbf^\M0MO;<GBg
0<N2:a:da51GN=Eeb<9g3BCfnkT?Gf2XlDU0A>DAiN\5Zdiqe2dcgAT;?COj[Yb[
Cl5bEllLL9M3AYa`m4:4<ogVaoKUnP^?_P>WSl@[Y_Z@R4a2>Rmq<KFF16a^[TY]
WVQA1fPD<D9R2AS4M5LLHHJce:o8QRO87l`?iBeZQcNP;g6P>DDnqf3JN5WgiL[R
Mo[l@IXcbW9bm_P`94IS\TNnIFiHHNSb>TdTUPF6b<\VWK47XKXIQFJ59qLL01kD
]2YZA0_8AO6OgCLSRP<QHe>bqdmgb?ApglG\Ij?617Sf?VG:pUKDL=lHH7TjmL>1
2nH>gqKn]3O[Do8@2T3l1kT=AGqST9nU[Dn5YF7P51FaX5acZ6VD\ffQ9mJpiGcL
Po0FhKQ4jg38MdbBq8LIJI=mm?@8DeY3<\mpa7Za6@_mTBl01BD8g3aeL<=QGfe3
75V=HUIV1N[gFe4fdbOVE;MqhE`1CIq5eGaojq@4ek]3OTjQ:X9f8WOAbI630GVD
>YWW=FqL[7mk8LjYL2O>TIXB?F>?BM0XHV6@dEGpDNBFLih3lAna5;=Rml^qf69W
cfo`:1bNA>\LCW\l@6fQBkoMInIqoFRQW]4W:=@@Ud<2E0H?=mO_YLLjBJX>0=I:
P0pP`8XHfa:V9R=\_OS`D5IG44WH@8BCQaiq`lPbfYnMV1S94JYK4YHn:NcNH0Pe
jb[p4e;`^1PI^ZZe5_DM96q6U2mDPSkWO5ZjkHYle6BqB?0MEjpb8fZRH[:\OoiM
BYFo1]kPk:Wcmc[5A>A:BpTX[cNnoX7NO4SLUmmgS2H5EWCJPEP<ScS`pT@Aji`B
<b`oFGhnd?=\iqUUDFkkMCZYG:=l4>J9<j7?cSB0]d;:]=p=^IHFbn]BmDkaMQV\
1WV8LA64@>pekkTim@_\`B\91CIaKFDl`SPN8b7c@^Z3aq8n;ch\j:hH?Ea?Qkel
]`8L:WgLePibGTp`EjfZYMC2lnU>A:KQXiP]9p3`4NNDH1hc\XgNR<SUUq1WIA6k
q=9X[hSX9SE6co_Fo1j6pf2J:YB8;4H_F5S@oM\]Ikj:Ee9=q@N@I>i`j]hc1]L6
:J8`pXB`]T]F[8fUaN50N3QPmcA70VI`4dUjT0=pmi3jBiIN9LFe?:CjEdSTpi26
Zl6bKQCX1<G6F`Ia8E_7=pY8\^GfE2D:]N3<XO_5gKS;T@]lkNSC=NpXTi1i5;H;
IYbODC5X5BQ_SIfKlA\71^KpU[0=i6`I[VHGl=J[DB=pL`;N[=k>HSgM`gfMXlRq
P5TjX[pgJNb[`oe\]\<njqgPXaKeq\H?<GeqQH9SJ9pj7ZGdfVOO1Y]I9IfM:9]6
DdbiTi::NpNiHJ^JHYGf7>O?IG;OhGGAjN9iIWbHBcEcXYc^lU_`KM@<^GEB11cj
7jqNk[I]XgQ3]F_7DE=X3o=?CL9cl^\e6pU^Jj`?]RWKm6fd^1M??]8ODQbgd8co
_gqNU0dNd8n1jCmYc7:m^bVajoGU]Qfp\2XCMTV^VJ<IkHP`]<FQWUL@jmfAA;I:
8@bmZd1WceD?9bJd_jF?RXAb4GA=GS<pkkDg?6p=DciFh\>CoDWG:BYia6ZlXCR:
8VQZEQAT^qA=1[M>gk7J3BIVml<jL6Q^EDX`i62V<p_3efkD4[_8\hG;>6iKT:ZO
V5jmaVmTU6qlYEJdeSNn8?@lSD5>JjbOgSDU\jgJ_IQqE3_mT0ER:WBjCa[nf`5o
Lh6\5U\D6gY?qHhKOAX[knAT\kG>>;ElVM1C;=^dTZ_o8q3N;geMB>P1o`BBOI8f
b:@h?lQ]VR0ged94;lgPm9mD\b08_V?<Cge8l;;IEEXW7`pjogM[0Z<FnMXbi>21
el36^B;EfVJ@:Roalq`jh`;jWVmP9XiC\N?E`5mFA05J]O`6RUS5pAo15YCp[iT>
mQ6aAiBIYVg`haG\k`42_5S<Smpho>;QmcA8R`03OIV[^jWh5k039IYNmiq>NhL\
60k;Riaa9_Veo1YUj`MSGeoh8HpNZ<7CPKHdA@lIE[]cOVKRc9c=kB:iA>p2cSXU
`qo>;]>`pFm8YJe;9TA`EBLIa<Z49V5dE]OHPhniSlVNA=0gATkfJfD?qR\MDF2p
nNGoMiBcUYS?`c[KSbjSpDdNfdSgO?UC>];MCLkBNKbFkMmneVkPT;L\IqZX`[[g
KRJ8YK<UOhD<B_gO6q03mA=i8A3ZkmKR33T\gd6d@BZHO\qD>>kLUhbSGfkLeh0l
U?:E?GYEQlgHKg4^4gFbTf]m>EXRA5pBhEBO:P2T^;GDFLVk;nJ_IIFLjb@bEa\3
T[QqF_VI7;USREdF4?[THfnedlnlpVBbFFd9bDZ:G6=33MaT=Ndhp>9i\SRgJX?f
9dPlVGXi@=6KqFQ5\A_3m:lmC8JG:_nDATQGP7X<p;SKL>JCSa9K6UH=^UiSm9eP
]Dmpf?4G@Y6[nNjS[eep8SSo3XkP=4NDJM9qjQ^HWX95YDUn8=eS?TQ\V3JHDSpS
J23TQ6L`k>k`nLho6K4IChqUb^fPH>RkDEfKGlnGlL]qej;Y@Q347H\A]U<i:nCH
q6`b?Rlh:ISL>CJ0L<RHY\Zn>91pd;LnJHhHV`^VDW;B\GdkpbMMB^Nfa@m]@_dF
lR1Y9NFPa;]bjWSDL_SVJl6pW>V87]g5d1;UhCnRmTdW8Hobq^>L;F72d\c\7^BR
Yk1P;b9RD4jH<4n[njLhUqOc>mKdcIm=bIY7S]^<D_0VB]9NKd[>EYDSSOpU`FW?
BF:?mof@mflfhP8mCV;HYF@WZQ?;EZH_9plX;a@>l5D^=2CFJTRBoB`1`q@0Z503
BJ`TS`L^K6D@6=:SAolb2kEXNPd>Bo1Jq\bR1;kBGZ^NDXPWXj:4oOR^GYeq4:@:
Flqi]J[hXp1HP0O8TUJTO>nO51njl8qd>`[\opm>2Nfep@HFT9]qPmMoY]q2c\XU
`p50Lj:`q8^mJgnq]mGEF>q`JX1TWdg9NhdGg\DmHAB[lFfSa9JT02VeTK4P18oU
<GO@5Iq]^1hgSqb8`c<3QPLb52^Fla4CBP]D423f3hOI=:_5N`XMiWCSoST[4oTn
FATlYOV1jl96BaSRqJAJ5ARjVjFomMd[LVR6opD9Q[?<\kHgobolGc6L0JE0pa3o
TBW05VHC@0l9@FHehMQSkpkV3VYB6pl18C^2ETiGC>Y^?GoAIm_WdPb8mA0J^1qO
TIBi?Dp9ki>X0JWQ8dd65iGJEgS[;`h1RKp[nHV=\gq3<UV;h3BTfTjT2b?caQFm
dYXTYWPFU[b0<1dRTA>R?6HqY><H4EHpJNf?<GU9T<hASCMG>>7ghGW2;o@Y8j\F
qI8R7UmDqBR<fdU4A9Q6F<@8Ya0<KD^NSCQ3nhIKlGk8RU5BBU0Wa9Gk<i>Df7LL
Lo@F@C;5E7]Hpm3`6OmGpRgAmYgoqP;eRF<a1\GZ04J`aNE_T[nBGP5S\AFJ_qoS
B1QEnqL5eDKD7IFPYmS09<19aqA:UI[PSp[Ng]kE;qEb5g9Q8piGdY:Og=S96@:U
hcPLBBJ^iXZCgZ1`CLqIjldHiEpelaB\?epGO[gQLT;`89Ym44:HVKmFDa055`O5
;bcO:_DFPSbNDc@jP]2gVfp`BIdVBLDR<Qia=Qf0P32gA@3jQb_Kl?EDblp=Sd`7
Tqh68XVUqeQ5?_Up<fMQGdYk?X\g<QVSKKakBndSiGV<QOI5?ho192AjqPkh5aT_
KEVOk6bnC?=4Dp02GLA7adCHOeCS_=RS9mQYYWg6M:[NjgT;gEVVNM=HSD\;gc<X
i5A=lZUA?ql_k06c9pTHjL;mi:k4;ZFj0MQc`eO1IjNKQF@=MCRBKV8kjbBO[1^4
O57=mq7?eNJKdWIiKAN_lgV203\MdYL>i3FJ3poKNkj60pSnZm1JRqkcT\?Aoq22
KjkG18kL2\Yd47Ye=@R>>li5KQ>h9hl@`VM7J_Hc7ZSapl_X82KXhKcNZCLg0>B<
iOA?AlV9C@`3qMeV]DB4pPmILKIUpLVmR^@pW>[Va2p8\n<O2p5JF\_=\1T@Sg<X
GmbLYEIFObCdjpVVLmm4qG^maYDpX5EI7>pA<_@_6p3_k[gmWPH>]J;ED5RTc;M0
P>_hGTJeIU1idjcQ[2h6[R1PYc=gEXUNhp6lLBNcpjhePiSpMU4Ycnpo2J1JUfn?
8>e5CkP2KdC?<\<HG8Bq6TZZFbq4\mQh`qamF^FLqhK@18LqKnO]63VB;`S3gWDh
Dini35akBc?SE5QQk^FE11TT4c0[hY_gIHV>oWSqJ3=GVP_HPn9U;BLGZge:S^ba
jMe]eL07fmL\dZbepmc;BUS_9F^7Cm8Vhc`\9^0Jq:khgK^F6d2?jhj`3;63MI?7
n9Q^Z\DU;oJpF:P<YfWhIUNiNk5Y5CHMgd<2PO5SjgS2l[BZ4[TN:C\EZCqKC4KE
n4qU3[IH;_HiCSb5RPN91R`Y5L4E5eAkE;PNKgqB?Book]ibj6LA8KWJOZB`5R\:
HP2Z=3cCI<q88=gP`6p6;MKE_>p8;gNijop`QcoE;Bh_LZUWca^\UUbb?p9XdCmJ
_q409R5P0GUDicHUD85dcN<4?Y`ib>HkPcE_lJd;f4pPgI[2;O;LmLVCj4Yg[[5c
?HoPVV@no3b`8<UK[6;aKq_abC?o_4EJ16ee@AGaKY4b?=e1:1l9lBAebO5M2p6O
PJa=9q73O0ALaqZ2VkUP0q=lYJal^:TlFiBL<n]SDJi2LX?9poG]i`TpWgcC^TqZ
@65e^qJHcSe^p]D6@4^phnbojGpWER<eGqe8k?bf7IfO4]AHm@9Eq^kSoD991mV:
QSIoW<3MBOaVLomZ<gdQ;0lTO1SLFecdNGI<Wn94_DdN0_k2TFMqJ19Q79EX9B3D
>aBS;_F3hI`EdiZjmHhTg1WmlNR1e2i0nH5PjVgj^PAT9Akng0dX`HmqjB:k=?5`
533Le`?G:6F:E0F_9mg@]cq7S=KGOJ0DOgDo;\9>ebB1A@G];Ilk3X`K5n[NomJq
KnKIJHm:PMO=lPE77In[q6RY9lHPB]ajCaJURBC5_HHKFPf6@IkZQc@pR<f[FnaV
e1EN6Ul4oh\dVHa;eVCR;Vb6ZA[[gc<mS6q8K<3l=7qZo?kRf[HHhn5YRMd5nPA?
eDY6;TpQZhP1AopCUm_G^Tq0dO9]LOp;:6RaCbm1SPO7>0inlAdhFJq[]?L6nPTT
aeLZMh;0XXREWk_;Dj_8VGJWY\NSY?C\4Wa?eX73DKS<B5oCcRVoT2h;m]p0F9el
giqOPjea@Ep?HT4?kqWha<C9q=Rbb:9paDlTKlqcf8fKlqEClE_lq?Hm1E=paAEP
9?ZAk83mKa:6@IMRf5;h]c\ZT6jYkb3S4M6LBCJ?;GSZ2XBO>[PEID2\9;U?gbCI
X[FAqoHnX[Cq>OFE:0HLA0mW5kMoX^NCDV]T?fb[LiM:FJ>:dYY63DEUpSXVNMD:
@=>5:D`C8oFdYALTB[Q;8GkN9JdAP[FCgAa0DSP]_LlJG@`IG3@N=@4D>\KMqL2;
>iiPO7CVE<f\X5Wa4@G`EBJ;=V>q80aFaQj`:QERlJTQ[>N;NAO3kTX_eKqP1RAN
iqi7c[<YpE\`=2npS9jQ4npOFQf[>\YVP=3c51m6Ad:4RT[W0mFR9ClPl0GMMeBc
a2N6?`SpBV^m^Tm5?1^3=0O8lZVcCS<>WkgV;Vei=B_SD\3[MoFE];3MGXgN3F>B
TEF[DlUPa3ZMe]>6:iW2C3i79968<93K8ARB;lNCC`mq091inbq?HN7KNpNFR:_N
pCMoY]EbBP::2mW9Ecej6oc84:DcNPI8SDg7Q1D][@\^dd0=Q][bjC[^d^KSR5ZW
3UFO=<B]6b6;X1EOoVo1oMm5f^H1=>KBJgJ<p?VWZ>;8I95=0:TD^NfeAP^^[^5W
bbTpl0Q54OqF:D9?6p2MKOmU:<>cXHT9ko=P^chcgCqYBQNAX?N]T:Ym8_n=cYRJ
f13RLf1Fcm8W4=7R[@K1OAgcUHLjgRUgJPWiOaNJ@f01ZilA0kQ=6[O5<@WAAXb<
P8KbO_Thim??>7o;<pBLi=lIW1;M^>22CfFESTJbb?OFN<i:69\io]5OGJqI^TH]
QTHD>dnh6<fL[b:JfDLbapb6U43E00cLLN5Bc]dSM^:=`UfRDOH@nTWBcqi]\fXD
ZF^QS^7<\j?og_GDlKiHJV8:ljJn42m4q]I21\kJp\TTd9UTGDSf>Di1Ghl]1X4d
4WoAX_lHKpdJC?nn;qRUUO2K=q[hQFoH_EO<UO54bhH?m0k41UUOnQSlSND=Y3cD
W3bDQO0_i@bnijAJE9WICeS<YRE0WTSeq4?UGB@kqk1[S7Z2TRCPS2E`3elURCYF
mDT<>9E_IcInL;Kkp`LP@6^lpMJQa7\1p9VDNOiqNe@hN<Nc<bk79L]peU=TYaq[
7Y5Lap`:TbkCpo?W[?2qlgA>\\pKiS\\\qTO_Z=;BK?NX7bFLPd4GcYLC=GeXE\i
H;@4I:GD6jpg?Did\\MFPm6X=fhBXZ4[ebCq=B6>En@Q2C[W81Pq79WR8OCVSP^f
G?[`X;FRjKVW0L7Ok7c?cjNNq4EZWLZlq_MaYeE>RLKfO^5FIj3bRbeak6E]1`>W
L1WY4:RZj`G>_qcZEdjZeK5X2Q2@3ESF6J2`nbEd;:>PX>ZBbTqb1mIG3LX\_?^>
F_ek0WN_IodcQ19WgaP4^<[l7Y;7>c:K28hhf3pR>LMeN6<Jf32KXReQJ0dSYh:[
][YZ]XnmnHJDjbCE3@p@6A1[TCWMiiY;VFMIZb3C3W\QSmFM;aH9<ood:ITachqg
M6EE\WY>TOOR=0AU?SLn\927N[4cd2WN?aq;2B`?_RZgknb9[@iCbIVH]dcHkiPT
I[BkS[hY:n\B=<^q1EZH@G38dA4@Y>10FU3LE\=ed:JT?hOlASaW3;pMdZoWm<q4
Hm^\9<qOiHcHeQYCeLk`3W7bUGqCH@=Z^5qWV>ckPm=Wfn=`1SUL9CnNUpon0][Y
2qmjQ3P_BD;^K:7a8=D@2n;Y@\`fQ9n\8`5npbbj8W^OWam^d0JjFga_Oe42iUSB
MJ\<OU[ghqOmXF^QHHh=UM`R4fT4K^WmBLJ7gm8_o@L`qJ?e3:QXRVB<LF9kSW6Q
S9BNF7S1QEHdE_V`Ofm@YPbcMGidfaVAWSLm6P36ipoGGi3b1P=1HAMi@N\7F`d7
NHoWaXdWke[>p8b^SK<_N?3BL6?PJ_fTdL`3J^l76g?G5Fjp0aVZ`_\aX9<CTGC3
Vi1QdDMi9PHZbg2]RU7dBUcq0@`?T0EZA5fDoB?4V>NFfA:Vg=JMmXb=M<4pX?[l
>I_pbRX:P@Y9__C3J0FG=:8699j2b?E_dO94Gko5IKqXVbCG5R>^jXk]HK[2J\`K
<<^IMGE@VLQKYS9PMB@f5oq5PI4nE:jkY>;=<I;ND>^3;HA^Kj_f4]fDcJ2h9c`g
M[39ccEm^7ZXYqZdE:G`fqDb[BkDKp2JSO=0XqAf^0Ncp@A:@cnp\_;8RYD\KAK1
;FleeG4Z^JCCMdU^`J@K`gj[4:_f38?Vhn8RKnUZU5:0QD0DX7Up0jX@F^qcXi5c
Gq^9AO]OpBLWIE[Pb397Sd9@[Z6KH:PNlP55@DZYkcDPIo<cBi_3mWcPB_>GRk2W
F8BWLPWnKXi?SFE@U8Y[AEQGc9G_D\4ZcX8?KAZeM0YpHjR0APcHfNfU619hME88
aAm?h_dMGgLKKgKD6_SUnZM`hMQT9FNeV7^3D:IVGahMh`E7<`L:?4E6Tl9gYkXG
=oOA2cd1mdcq0U;?C<DE_02gG<o]6FL;5i<]Q:5<Fg[NJ4EqOG[j;E9S8MkhODUe
=PcdLlI\AFn>2nk?R`i2llRISd=REN]:_5n1BYlJq1JSKFP_hX5D[RJO^_7Lq>B`
maZ2M^k?g0[Yiea2@3eq\NJjO``q6E5USTMO[6aIQNBR53d37H3D6hiZe1oj59`p
iFH=bL9@B>lQBTQ6:<48R_VYdRdm6ERf4RA<l_5<q2bUJ68;cNF:?HPe5`I@YXNR
^jF<WK1KJ4Io5BBqW5aTbc>Gg3n7]4DoAbgRdTV1\0Uh7Qf?ZbgpXXi>BbTo@kkS
[S[0GU2XGL9@4\`9hkW:`XbqXe20CPh:lbcIcR?;Zg=9DUOe1fRV84E3=N`K2YT7
RXQchnBbB0HO\]57ZQ0B2@=_o6qQ1IM0]a4Am:MkoXd>DN7A`8UWX>AN\1^P><;d
naUqZfjGZ6jGkhTEEi1VGl3n4CaOhb>j\e49fIaqLY4]7S_pIJhUcOWqg5UMS9lp
TiBe0>cEdgLUS4Pq6hloHmch<g;AK<J]AQAUJ?M>X7bS@lq29adbL4JXU52n2PS8
Z`10E9<kXhnD3]h=efpJ8`_J]UM;j1PYD0R[deKB^bGcM9M7E?9qKNHQQNDFSIB3
oPjjk7_iKG3?`b9S\1q3lXbF:?_LOhT]5A4?\WBPkC^:IdSKDp^O3;8Ch\h_3]0Z
mPg0mM86ikP1^Rd7C^^FAqUDW\P\_B9T5W;6>H=RmBJcqM8:G1\a[>Ke]0MfEGFP
]^kil_g`>8kqQWK71\;q^4GOhmZqIT0M>Cpm030YJp5X1d7Tqj?=:_UpD=HU^CqQ
m84\=A=NV4gZEQ=?I=kPVD>h]47<QlPmc`[FcPQAML4J3i@7j2G<XcYh]DMLXdh1
e<p6h=?b<pL=`[FlpTK60hXq:FD@8aqMDja:9qkZ[db9p;VChI`4WY>S8WU7^d[_
Nk;NUHJgo>]HG6aOo^0E^:ia0Y=372NM^gnp@]iQ\iq`hdeOiqlWQaS=qJ0TLZYp
nkIX3Xq<bP=O8dhdDbK_Nq[3LC=_qB^J7T_qnk7iACq\AT;ACqDF7ZkCp=^Q`=e`
1V:S<<3QW7WSNb8\j]lRDTeKWc<fGd8oJVi:8:A^>>Jo[M0N@Z=o>QCQ_9>qd8X^
DjqY;O3PnqlZ_3NEqkgjQWPN\XA41J=P4E>bPjU]LfBnmAO02TfDDVY2[lJlcMWA
V5P`cCg9B9S30e=9n0bE::W_KF>jMJCj5PQjfLPOQLnCPiEbk0m]0O:dN0fgW5S3
BA=N3pFUn1cnegHaYkZdJclblXf?m]kU^eZSHBG[[BZOX4O^^FB3Sq=P<53Pgq@=
ON3AB;@RT<@J>UBRH>E8Kq1oVB?KA4F]\]hP_nN`d\]4?hbZf;GWo3gF8]p^NATZ
9epEh:?^VEKUDe_6EWI2N]oeh:ll<jGEb4RiQ4VPoZiR_nWJmf^2HAMT@Rp_EflP
\6XUQ7A`0HcUMNZJjSiEKjZHIhfkF^Xa;FbEhoJq5=d2Smbp6]XMSk\\3^k9oVXY
`hcj7T8Kl0?<71kGSGQSh\D]WfEGO\b4HUa84AKb4BNZU:986UXMeS`pOGO_1OT6
SfT>mW1<MXFI]4F[3i0j5S84@RJ8ik58q5E^@H>EPKg_P\^IpEUcZ4Q9bZXlGUic
jVV0L]6Sd^2HMLEmhe?4jUQc7A9\M?]gHO1aeDY;OdMI[nM2Afgkf4oMa?]`S_^o
TYIFdVDRCO4Eqml^8`5Z_Ui7lP5TZHB2WY4`XKf2D1]CUkJJn91<bph2h5CnpJLN
0c1p5jfMIBqISIi^[qn8]ba<pbd7>iRBmNeY`o>Q77AbCHHWdKSe7mK;oDQPEe78
B2QiFD7[o@QeUR7V@jTnb8gpSS\c4^pcNE`=SdXQk8Q>T[JL@41OOV9i<eadOEnK
<cIj@HmGnkT\JdPMH2Uhk1Nb8_DF40nQeFmM69RdWJ<DaUHq0lLEjFfFgeX9Kael
W5ISegdW7IKQ3hPC6\5l4nXfPQID8fc4Pe`o6BMhcoiEVY9QgHTq\83:aLjIhdh7
hgnGbEo_Eg09H^<mQ[Hja8_Si>6YpRbjCHIM=nn5W?RL5QO79h`beDFH]pRKdnJY
U`Tjd^bdmhJLc82FYPO0p92Q7@Oe`ROACLj?U>f`]l;HgmV4CbNfk9\fp5RR`TaK
qdA`1REO?5Mb=HH5P2]cHAm5g`C2kcRc6cHOp5d:nH9E:=3h>ElkeOCG>Ii]_Rjf
q13MJAOhp]=;FAZ>qH7`D]2@qG1fdTA2MZNIo<cJ^_Of[l9=fdf2a>=RqTST^19L
U;cf_7KW5N8F8QJ]eWjdR=GR\9I7Ji7eZX?iSp`:<CHlXq^7L`UNbqS2kD4N8:J`
40kWIJE=:NCg=oLZYm\f7nCAG]NGUXmG6\>:>Y6L13=QLR92<GjQ]3jn>^272m8X
6=<X2cX`WEcB;WiJpXj;[$
`endprotected endmodule
