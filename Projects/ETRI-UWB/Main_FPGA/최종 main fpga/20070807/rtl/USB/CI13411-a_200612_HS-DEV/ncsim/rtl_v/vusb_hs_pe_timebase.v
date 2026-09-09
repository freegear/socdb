/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_pe_timebase.vhdl
-- Date Created: Thu Dec 21 22:42:29 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_pe_timebase.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
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
module vusb_hs_pe_timebase (pe_clk,
   pe_rst,
   pe_rst_a,
   portctrl_speed_sel,
   portctrl_flow_en,
   portctrl_clk_valid,
   timebase_resync,
   timebase_resync_faked,
   timebase_mark_clr,
   timebase_125us_mark,
   timebase_125us_sof_hst,
   timebase_1ms_sof_hst,
   timebase_1266ns_tog,
   timebase_1us_tog,
   timebase_125us_tog,
   timebase_1ms_tog,
   timebase_aggregate,
   vframe_bintrvl,
   vframe);
parameter usage = 1'b 0;
//  see usage values below

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 

input   pe_clk; //  pe clock
input   pe_rst; //  pe synchronous reset
input   pe_rst_a; //  pe asynchronous reset
input   [1:0] portctrl_speed_sel; //  Speed (from port controller/EHCI encoded)
input   portctrl_flow_en; //  port packet flow is enabled for vframe support
input   portctrl_clk_valid; //  pe 30mhz time base
input   timebase_resync; //  Resync Timers to received SOF
input   timebase_resync_faked; //  Resync Timers to received SOF and toggle 125us
input   timebase_mark_clr; //  Mark that 125us has already toggled (clear)
output   timebase_125us_mark; //  Mark that 125us has already toggled.
output   timebase_125us_sof_hst; //  1 cycle pulse every 125 us for host SOF generation
output   timebase_1ms_sof_hst; //  1 cycle pulse every 1 ms for host SOF generation
output   timebase_1266ns_tog; //  1us timebase to dma
output   timebase_1us_tog; //  1us timebase to timer bank
output   timebase_125us_tog; //  125us timebase to up_int/dma
output   timebase_1ms_tog; //  1ms timebase to dma
output   [14:0] timebase_aggregate; //  Output counter values to SOF timing checker
input   [3:0] vframe_bintrvl; //  for vframe support
output   vframe; 
`protected
M^f7:SQV5DT^<\ViE>dS<j;]Y5m23ef<2aJDIdP5mfZpBCTXf@>DHkR`R`i0h=@i
]T72PRqoN=LmJ\jXNANf8_\cVB7?n\h10O95QFRD?Tg>]?fF<>`JYR<CKlP:F=55
Hd`kSDkqMO?2D=pZ8DgU]U`A1<oo7FdaCYmV8_\VnI?BYXSa23p[:AX4==_mJ8_[
Q=Job2OA8X_WYPZZ=nQMA:YLNKq;QClbXR7UGD>G3DX^;[:EBgCZN36ccCoe2bap
`[^F9\nVFR7=MB99S9mWBETl?he>V\=9fFa^Ql5?KO_c@a`LJ=>8UcP_[?Mqe[TW
XXTR=kSA;^@;CfG4eZNiFO8_fURYjA1pTU10nNYdBJe=DnDJI87dZifgZ;9XV5Xq
C]X5n:6NQYclVL3k0M[7gZ;6bFiNjR0>^dpM:9DDRK[<kX3@jE6TQ7oOB@\@5D2=
amp\NAPoB@C2m\`BXZ53Okao4I2gMK^:jjNTNU:=KmOB]9c`A7bqdYb8V237IXfO
k6j:Abqk5QLmMf:2<9@mX0oTj0g7i[M1Fli8_?IC70XKL16JTpYCPfTGj>KG=o@f
0?WPff>mib1G[[GWEbYhpPQf`E^BB4HfK=:_40403W6nc0OJ8efRqJ[N`O[S>;G`
Z`NMGF;`oPES@IH5QHA8h_>h_o]9qC^9IQVR[0d10`GJcL1\:7H3nYfceeapoKij
9XDDlg:VEHH[CC1iGJFLf8LlFgo\FSB_N2p^0;<IK`N405_<Fn6O9;QkHD^5DY`p
>Q55`XRW9SNA66OVbS\0[R@YM`Afm1M`@Wp918kLFkmPe@cE?X\SE8I<_A0Q;40Z
AL\2Qk\:2ph67EIgi4VFkJCmga14=W_Xo2=`3S=a6K5YN7mg6p`cG6m`?8iDd5\Q
9J49d3^FW05fc_6`qgm2UO]aVQbf=@BnW;e;\]mfM>l0G6O=?V^P?Kj@pJSG]HHU
T==f?6?bjA=7M2:IdCQ_9g]lEc9@Mqi^SFG:FNahFbQj_XOI<^cYGe>3@d5Z:<hm
BBSopNO0E6?6::WR=eHC?>WT5`YQSd]k49k>2`i5KBmqE\a>E2ln9@?JHeeAMTM]
R[i6M1<\]=6bmc3MoJpm<:Hb78cCfdhXE8;P]K[<@Na4=W4@<1D3DqDKmR@CSIRL
fZ`mX\jm@5k50]iL>36HilV9GqC]MdIg;aU>F=?3?EV3LZ?MDF669<g]FP^0WpJb
M9\^fJ_gn4jQIOIB<@\Io22`6lUSgP::Te5IaViS^9L_l<oT6mZap:mFVe@LPF2Y
W1QTQn4:nZA=kOCiIHiP5TOXpG^h=QG29E8cndaAW]h:_;[Cb402Ubl<?066q5EF
\UKRL[mL5VhB=;O@[NX8RT7E_9Smdj<]@pb6K6WlPVLM0f1\p\Yl<<n>bjT@7OTb
V3NNkkJHM?G:B@V9BS65nqXZQ[:4?UEHBVj6>XVFOTZUUOUhWIF9:g6EMjcifMpa
>Q?jGjb8P4C@aXmX<1;qDD?>E_g?4M5?5EoQ]49cjZ:>[X@CdSF7Gnd\1^pij`5M
Wg]Ie\8SEBG]Nj4oL?XjQ:Q4\0=\XIDCiohNN8pj2hB[f0H4??:IY5p2UTd3:RDN
[bn9MUXkA19e^8[noA`MoSF3LXCo8MQ8CqjNMjYmTaKCQiWd:FllX]:enGkOZ94=
O3\Eg`bnR]qdPN4LZ02X0[PO9S2c^5ieNFXT]DgR86:gQT[E?plcOg3[E9i8dj17
?E>hU5:nVf@8VM:N9Y?\`9WAB\`XR[8`hVcnNX0ac1gVX\0Fe;kf[JJ;5@V<SbbM
EaOOp9`D`ATJR=`g350nVMiI3ea<OgO7O[gO[G6SnR7i`QFKaj@>lD\aHbIE[PV8
]n\Oc]n9XE1l5?O5SaV\[]SYk`TepO9Y801@=OJU_6@gi620\Y`8GL2Q=Pn:m@EU
lCJl6MjMCdaZKIL[hiV69T2kj;TVjc@jb2J@dSnoES=8=WVYOqW46CoMI6h06AMS
doa6n\cLi;QWT0\Hc5Uf0oSi:n[GJbH`coFm6Vd6mnoSR<JVbg6YYJ2]OTSkqGbh
[VNQOl?\I637_7aq@?M3kaW9I`h\2c485cqRNHdJENRM732G6ff93H7;4V6aY<Jc
MM4NTTgGJS:W>cDGgiKbUVE?Mc2OM]bH@Veb3MA5MXK47L[58PYqjU9L9o6mc7@U
iZ8UaSWjY>7FmeI:Z;hESd\E4B]=>BpAN`Z;0S1dkIT0Z@=E[Bn9AaTo^NO7lpGX
b4[KVEYVOCQVI:PKX63=d@7m_X_`ac]Y2XGYqo=dM[H6qhM0Z>noiH6W1d;3a:3R
AEkOcb9U=<17Cc:k1WmS\85QdT]Q:HCHWqIiC7WcGDR:kbhSVYlEeVSeJ\LQiD;X
>]L`837U<BB^A[\kYL0hipeekFNoGTl:H\h9=38JZjkKekH`?K6?PNdXLQ@i<1XE
XL960pFHSM<EJ7Cec8[bK<ZLPVWWGB\[bk@J?`a`F8GIUcbXhC_E[\gH4pX<IkE2
0kDDN@A7[SYA3c2DGHYaoI@8R1mR_=`bW9]6DGU8PY?Yq@T=fYX:JONFNE<1:Q`1
eSnXE23T61Z205Y20S>N1<h46a:np@[N<jh=FcKhXX]S_Bg6YZfX<5T>;oRo=5=<
NhDmG7KNoS6[pbhUEQaLYMaWVZOn6kY3@d>5E6HlE2G2BEg6?1NZJ`4_i4akToNj
p[kNeWHjLPH;ke0H7^1bOom44Gn4ObBU\5lgC9]P:22K0[Bc4lS_ep0\FRRQB9cN
7RJSh?l=gaS8b0g7k@`fLlXcRPGgBZUdUTm:@9i>j`q9>Ri51F\2?ZmE^1>l6heB
095^Q99_1431X7<O:SH?HSXITBfqo1Eg]BDFiZY^nZM`J@5_7UbE1CYf\f]oPTZl
JW?RldfDhG]E7e>]b?gTTERJFn_jR5Ipfn41TD7Ec9f_Ndge34ada[hdlddQhLTQ
I0JM7K`A?ZjdhA>ZjbqL^V7J21a8ST9`L6LgI`fcgi`\?9kkP]TBZ_XW0lEA`;nP
5__@Ap^c`l9>CRZ5;VWn2>ZK:>[E>_F53o<2Oj==HREI]4CfRdm4QFJQp_0kC^OR
0l4[LF33A]DVFfmLc?OSWPST9^gVe_kSYV\j>jMC`4A`pi0Fl@>XXdJAYN3F1HUM
PH\=`k?J;DWR8Y4nWO1h5hIVI5nTAM;Sp4fKX;^Vd7\Fi22S=9fE7je:HTX]jF9k
^4o54PYmN1OA]D]>9Rcgq81B_4<lL4dVIXF>[PD[1fGf]kX7\nRF>XbSk@X5cgQC
j9DcqBl3j]Ra6BK_J^CJ\O3d=ZeeE@kM[O1ZnSG[aqj4g7o7_2<Z2APm[Q0oLoZ@
aRmXI@RJF8BCJLKe;SJ\i9Qdmnp<Ge1L5`_=AT26:9MPT^@m7>[52`ID`<=CR3=?
1<RT\6TZ0Qcp3:GcPTcbo8<]]kZ5\TWZ6dN6II1WKRC0l?^eXTlA99V@YFR`p2j6
4UnTpl>80bc\UHI?kh1H]=id^GfWimhT8kAhE7g`q37@C^DiqEQ5VM>dp6nQWOQg
@GD0U\?;\<m2>AnjN5Zlbcm[mfGRq=NGmGC<p\]SZCIXmNcVg<JKhV<aV4X8dcmE
\goeS>c\2_gd5^kQfV]^;h;hipDdJLhY>33RJH@KKGcLLB[6PnKd6a_Q>QZSXm3S
d\VZ`k;9lp009P4Hof^Ti00P3]d\:lW00@1F2U_Ob\1F\d5<cfkQ`FP3UKLP<pVm
KILa74QMOl;Og7b1Vg:Em@d:DD?ATH<9bM@Ubp=FLgPFQD?V?YC4Kbm`dRKCFhXm
R?F8j3SaWb_c^T4BR:\RQnjnpC@JBJ6;9T<IjmHl:;64d6^92<`dc>h;Dk4=o?K4
X;;H3YMDqhVK20]hAhdJGk`V1Sn^:ifUR:na[VkcWVEd87`oIeRaihaPq;^G:Kd1
JCVWV^Y=NmN>jlQI7`77QX6aV7;AE58L@SVB`9`bZ`cPph9C^PT19@Y?]@D[[cnA
1ZF=<8_C]Na=JHO5Bb]MSH^P82<_hc0W_qF_0KZ2`P3OcU<1PZ60=YWa9GA0Xi6b
ije4YZV?`I\QeZhiB[0aP4qAEX_3b[nN4RH8Cp_Z3j<Bcg6FU6KQRNofJOf2a:3W
DVTZ=6QJ<=;P_^k5Vg4K=Gpfe;B?\9lTU]VXW^K1N[E>68E^7nAGnDM:BA8?E:h=
T>_RBe[E[qBK?G]T_RVmb7N3`5:AkAYVSegaam`a:TCoPFijF3Ao4>O7KK:9qV;T
RW1m[U28cLc1[cO=^]o^IY;h`6D_kL;ZOoA`^M<>IJZb?h9qjgoClS4gSnH31f1l
BJM5\36GYK5?@ZE:=ZVOh2EQZl=@TMB8Ef7qO:Ea1T1bi=V;m_joP6<3:;2^i61\
MF;eUjaIcXAHg9Agh:UFeoRqEf?l^@3K[TXBU51hl7PFRJSng<=GKYF45H?EJa<n
YKD`DGDjYmbq_TiB=M\MD\HYXMY0Pc`AO:eh5:PPbO=0oHlP20Q?Q7@^2O99[^a`
m:ncVjTQUB<7c8>gpCRER8WEKV?2ZO03OAKE>@2@0M7BE9WLYR3PBSXnAZOUaZ5i
qgQU;POZlmeMgbjceSU4Kh9G3=k@O?UclYiISO?Bl<a`BY[Dip?jTD?cQDAoj7;J
2oZ:T^;oV9k[]6HN4o>aBT_J[4Y\DkID42pd4^O>LB6g@][EDQO\BaNl9B1KcPVD
b<:O5oFdBE`P6]b:WkMq]]132b49TaoJf6HU=46`8lDolFbCFEIOB5F^co;lD;;b
bKUD=eV9?OAq5Eh_3^eqn[mKZ2<pe;]7Yc8qXB>WAaNoOO3JIh6ll=ST16>`k1B6
4>bO3NnEbhmGKkZ;kNJE1cV73LXkUaLD;_Z6EnWMpmYEb[d;=O:2W0=S;YHS<YZ>
iXKWgA[cV_8bLkL11V>oA[11[HQOUi0n:42XN_E<_EDSPn:_q5Z<mAQ3`cH_<^WU
cVJ]X\A^9>6TAo>WB67K\cUA1GUDAcMd?_53GT7^;=T4SeEQJWmBXHOdkqJY[_Xj
mBFLMl;cO8L=NHo3H:MPPnmEjPE7;MSO85jmJ]ZafkchE[4MP\Gc8J3BLG0^pI\@
Moj3S__i0@hE15@A1MbZmiam2E?TdEmM]B:A`mmm=hAa9P2>l?elf36V4Y1IUA6?
p^8\;YQm]Sc2ijEl@HldO:2L^HLMFEdVY8MfCEUZYHRKH^M21G8k\oVNHKZ1cYaM
=^m@BqYdMHOWF\m>cXXPNf?[^_5kFE`ciXOdL;RJgQGU[9V03KM>i2dLk2GD:Cg;
]=A>?J[\CE[Mqf2nhAlIDI3>>ULk1?`7>Z5]EEG5]nEoe2fL\@n0GG7[nfR71`K0
A2<aW]Z@`G6gpgM\R7EekL_ESZMJ?24=DQnq]<ES^BGL^\W8aSidg41Ih?VKf<F]
0Ggnb?NRdoh[`i\D=0Md@3b?VchPTXgU^L5Dp0N;8BJJT?[HHUFB[Q0dH5=VKDCa
E8E?WI\S`1]TX8@:<6IlN1\7q2^j]8F_p>gWT@ACRUNEUZCNWM`KT;GQCLXChFj:
8@l;56=cb;PiE]13OBBblmiJI@KPZgbDG`L64kBN0cV3q6fRk6InL8SdI8>k3?Ae
0ZEdjDALi3M:DDa_75:EboFSPLSb=_mV^Wd_PF^jdRHq4eRS?55pbCUagkPeLb1f
J<nC=gnDTgHmP\Jb`O`@c=X00GZea=ijk<ceQ83=q2cBO1<SS2Ejo>n?XC5SR5d6
5=5g:QT^B:d>NQ\TgJnIF@g>m4FjJXh@l_[?LbL;pVEV?ZY2q?_OKfAWqn5c?J?a
q[Ea>i<<5MA89h\i3U7d^YEYlOR6ZKD=ASTUZ@?kKaO9Xm\e4S[kV]NMF=71nFXR
N[M[4p3Ff;oa`qfQjRdTKio_aT`Q\XN\CoReC6qR_2cSC9qm5=_ZT]dGI5=0]oh2
f07Fh;0cK8]I7VCE[bfX2Ln<0ZVM\ULjQ2p[2o<ZF:p6mQZ\DG=:5^3e3OQcJSRf
7nG^je@Y9\6F7L>F0jhMJbV19[g8\bo8Z@?:>@N]H`m:]oB_2pTZfMS44pZB@Ij_
>;Rj13A[M]Gi1^kj4c9h=0kl?h@N`BaU[>HEIf9>1pT33flVnmja=aSUiXXT?Baa
XQg5clR9kVb=[]\50gP6DOpFWoPJ3;[;T`:hamH5TGWLFQ:0AabcoLc;B]gCRo6T
Y?gjcPll_=QSZj`:lM=mlX7GlPOW;f;Xd:pX^f<BKjqB=70NecXI46o__aoHoP_k
8369YnaR]2<R0f?VnUDi6>Nna]]M@q1Q>K5_8[Y4C6[D8JNN[I1CfZG2e^I8DG\b
V<fHg]U^HPJjW^oOjODeSdT^CSjA4O1dnJqi4XgAnkWU;<>VIo7VXbV>cQeS5B;J
mV_QQ@>EjkZJ4lbbG8_Cb<o23C3aOoKjK>kS1q0D:Y4CW2kNgTb1XYml7K05oM30
HFG`^;kQG>_No\F2o7knW3V[QqX0cR@afRUg3M;IRHja9DL:<M=GQdZlkN1hO3Ib
M^gcj@]=R6j61`=NSK5liOUgdP58:`C1q?>0NfNlq0?UZDmO`fHa11:q0feQLebi
gV\T`>2GB>nKS;CB[VnlY2hiNIJj`832>95HLa:pUgDL]IB5`0RZ;6IYhJW``WS0
8FBK3j?KLc_H][1d`AY`BI_A\jYRYBloT`_`[kKpWY3lQ>H<:f9c5k1iDaNUB1JX
cDZ1?Sf]j<5P5D1JE\gaAWHYq;K@0HK_goJLgWiNUYaIOWh]oF[6olM8M3;9LUAX
k=mg42;JcZ2POb_CkHWbq?l?l9F:pYi0\Z\:pg17e:mKpCORHbJ=BMijg`R7U^7=
2OEkEpk:ZRBG>`M@c^4k8P1AIQ_LSW6E[;75WLW:oRabjEW@56_`flM`R7e1iKH8
pcBWFj8Pp=Y8M:JPq32oGGOjH?FX^aR4:92g;iWGG;H5D9Hh03@9nQVl4UY1D:>L
QBN4?`nb2:We;K;3iL`Y0j^:DUMlH=Wq64C[m\2pNK?U<A7[jGVR^j[^0[EFcm\d
;J@ihd8IO539X8]^M^hCaXGc[^Z<P]6JH2g2knD1eap@kX_80;oX3_UQKeNj^eQk
QGNf7aHh?\TKooK1MGjF5<]8_R\<WdPdh0c@oI13`9pnC^K;U9qIXJhXQJingRhD
aP<@MhbIfFoC?ZeO?i5TBCnKc8cf;k0Z[BdG2^jF]U:Kj[PG;_cp0iPhOV;qOT4E
\]hqQ9=1<GhZB_U1ao0>MVF0_QJ@:3@<n@kaA`N^`79F_IX<i6GhkN;XKSQ:?NCh
l2;p53?6OQmqD_ma[?;qJMhFlUbqgT3]>D:qGhhh3[3DMXYZ_`2BGk5K;j;TVJM\
kUKjbXXm0gLJ4_mUlCBEl`YQ7VZ44mpNbPni^KqW46S\oEUC2E5T:NJC3\JYUi>X
Y<hjQXap<b0HB:aq9]=Sa_15?kAnn^]_N4@ClEMQS0F:>NKEh51^\Q0KPcJ8RB?7
LZnX]?7Hcg7`in?jOi^:T8JR2H@ZHZ?B:1PTQ>pfe@]OoEV:NR[ljd:=ZABh[c05
_A1Kk=p^hgJb:RqAa9ZY=?:7T[\iE<gQI7M<aKEoJ3:A`2Y98jKEBomIY`7\96P0
h4[i3c6FkWOc`3EY>THSRfWg81h41p5;6E7^TqkcC3<\L;6?g7giKZPJHcC9c:nm
n8eTc]:c0XIOJ=hTJQen755o2peG8?hlMOO>W<R7j@mlXkaIL7bPE\W7?W[f5nU>
gmfJ:KOB]B4iZF0QJf@I;<fONV7^<SY@JqgiHbY^8p=2M9HV[VKN3T`NGq3:9_Ic
=g4OUKWe@EEagd`k5oMT_W]ocIM^;R_79g0\SVLl@aJXX5cecVKKdU338RY]hBEn
PGj:P[<MjBVYMe??gK@\\9H=ah0S8K1E4@>`^o9a\O`430XZJE6NXWCfia323848
FZh<\jN4q\_X2VEZp2BlDFF_E`d7`Kbg\45<4=BaFZ151imWX<b7NeC;YE5Q?9<b
LPF3qfl2HF@m]jSVCOUYbq?mPXmDkpXQe6j>fqd<QkScdpN]iMXHSQHKPK;@h4\]
d68ML9O:51>]1>ekF0@ihW129HPSl7SYg2c_o^ZROK7Tm9h:p]W01d3gN2^;ak1K
\Doj_?;e:cGo>^Rd1eYiIWHfqlb=j9^4qY\gbL^7qN6<dC16F<\`NHmfJ5W:bX7O
0aA>lL:^cN5`EUDfYgT9Il`YPdW^Z>iiF=mHfOJlfhZOXbJe@:GDE8]cqgbGf]1@
4]gU1am:ih7?:X]bg03YdAPFkJ3ToK?h_dK`K9YdbUV4c5OUjm6=Z_O9]Fk6Q^9q
Bk2BI:9pf?WSA[G@hQ4`gXOaSQnOdFEOd6FhdRg_HjeDk8QM9lW[_1Pq=HH]P7bi
H_i1LCkFK2YZ9Z4:\UO=b[68dlK67Lb6jghZmlMno:p>CFA`eg<4Rjc6CDV@k9dk
adm1nioHI6VYaHFh6G0CcG8U\LK97?TFW1m:3DqVfPMOFnqVdi?]Jd0;oQmjB>5_
hFAGg4`TQHckap_d>`5G5LINE==Te9ERR^Nee3LE3XLbnWR=TPHVdm9eMhQ@ZpHo
OSR[Y2m:gd7dW0O0X9VZ1>X@eH@19WYfn9mCh>A[iCk6ELG^a^0eAlgfJ;^B__H4
<8EhM3V`aI]cmF0i=FN5hIoj61Z9L;JmKCp]7o;DG@q6:eo<]FL?id`BI:KEgjO5
;VI8`cfQ]7i>LHe<<ff3lc`=mC>AZ1dmP;l[=U6=?0q^^TRBe4p0G;m<\Iq4OfXN
7kCF2277kX6I6;I]S51]?OKIf@Y5;f0OSY`a9V<YR;WXXS:AS<hC:qm`o68<<mkR
bcMSj>lQ@<`BTL8:U@5=XdL_k6C_X2:eP7W;=Gm53KAJ0DHkI0gNe0?e0P301DNn
mcK?EhP:9Y`OTmlZZ2lOl3YbY8lhb8RB6p5AGIe7Gp7aCTK2<KW^?YRN?ZRgPfMC
1NWQam\DN?hKO<a`odjRF3W]eLH;RoY>\HYXqh@H7DHMUA0DVckahg9WOPY;VX>O
A18hHHX2MRkdBBh<^E?jU8G79P3[27V^pLl0CLX<I2BROZ^6Q]>CFefI;KN;HUoe
]38;hOgR]X2nkgBgP[bUCj5aVWE??=PMQRf1c96q1?6jHe^qMi1WJk@[ahYg^Q\g
PWjV9eXA3N7:_Z?7kcTUaXQ\PRWhefZXH0bdIWP3A_1XEDBqUL603bhqW@Qk^j>q
4V15`nomBi6?N?SHJkfFcNah>RHB]de?@Y=<LZUCSW@@\<oaEWQYVUA1eXhVRUWF
44XcjblMOb^aIZT1g?fo4Nm_GgU6@SM>a\DI]`[q89IRG4Rq`SXZOMD8^Y16K;O_
ZIeB^Ean=T2kbQicjD:N7HjS5=A01K6KZ?JRLX10UBiH]Z<\`4?Zp[M@\CiUn9M`
Xi;:PV^[GC3Kel=9D:EO<nSBVk4?>aLl1UT68G<hoJ_A6HSLMi0T]1`pkQUD=P>j
0O>SoWqa^0UJgMpdbMWmPMiblW^@YN@VIaY;Mc0Wm2UiH:l5E7\h]h\H?mSWn5aE
BcqabKMg9N2PeR:>KUP3mD?o:GC^j4UUGZoUmS28E21hS_32cj;p;\Yo3>aq_>CU
j02LhJTN^c3pWFcDA]=EN=]heNE=6lXiLJ`EfCIlN==Z@VeU9RRV;OQRJbU@8VdP
ZTR_I7aG0T@i[DZRfOlL^U04LC9Q7_qFe]o1BM^STG3CMZk;G45cHJ]1U<I^QHnP
@:I1Sl64K[7a;fL5ogU9aeJdK7_KhR[0JEg7Tp\L4YgbDq;3BYCXCDkO;6Ef2\M0
7joFMCBHYOm?>U>Q3IVh\`SD3IRK1eChPpfVREAC99D2VRh5KPB[70H[3J?=m4[L
@Pf1J;b5RKlkmHE4HYfcWflYnlZe@0?M7@AS^C?36q[R<Jl_\461Ag:[NmXYlUH1
i^lDb@i=<;Yh74?H1NoO_99<7nq1EYd_@mp:lRRdC7qUk3:?KUqOSC7?D0p;F5Fk
ZRHOC3CCCYH[Lkh0;T87ZTIc89bh:WAO:Jk1hbSX;W9om_[ndbIhF3jO3c=4[^\<
aGbJce\6H@_A3AgSUFHn3U?0ZC^DjW0SH?SVGE\F4EW0>Y?[H9EfCXE6agl8:R98
_JC`GVp>?<CYLTWBbO:47ZS`HpD:_l>3Za:e9bJYG2_ZBN]bf6B9AVA746:cXidE
^DLAe5V4UNg:`^IcXHXfnjFGX4W^D0MPeX>[e5FI3dXMnAfNiQU\cAA7;V:\TNEZ
diXSVjIkk5IlO3cXHGha?dVD?EEg^pYDX:2mX\]UN^I2lD2jgFq75G9Pk[<n3_=g
7jn9mpk`UKZL<lKCQPn>kADiLAbMdi]R`lLI2Uhg3VZSVhHXBk2SAK;2dG5J^[=d
nRX0KAJKnoj`]Q1KIG>oicV_0GIC2E3OJ0JHMlMdK=??;5q23E^dn[R5Kf8G?gDb
[g`E\=gnPVcAg\IOBBK][3l3lH[m:P?\9:Jo:Ib??=<1oEXaEBoeYe^k>aSfGHZH
Y?faDWB@jZQbhcp[eM6Cj98IJf;GKX:bQ1bO[LI;Dj:pA`l_CV2<niZS[EaWcXnc
M_5_XFdNDO15:4Va3j651CUoF^o@JljjPSClZCKnGWfAb;U?8?TbniZS[EaWcXnc
M_5_XFdNDO15:4VaWO2Lq]5GQ^?I6U`WVc?9_17q4Q;ZchX412h<2UBleCCJ?5e9
54F?PSf;8c0X\K18URiJ71O^QEmklQiXKC4U@9hH9Ogp>kFe<:J]a9YJjcM8D@^Q
eD]9?U5Em\8pF\WPG[`5jC4=COY:cQ<LM50H<?FY9m[HgNlW5Oi]:>Q6YN;>j7^]
E?MDI\N6T@q8dcE8398;YVRIWoc`Sn0jbbm5Zj:NS\dHdAAPZO7EJF^<`WkcDm8?
^k613eg47_[O0lkl>0V;mi8AAg0IWO<7BTPfU[QNSfU7Ffq]iHE]j0P?Ea473?j:
MI5cObVV?elOcn@`>J86>0jgEWioZo\F?g4`;n@]::V>ao_G40Gj<ES6[kq`LEg2
kNW:]Gd=CaNRmqVIh6kci4V1_0T4XG9\3dBTH4X[KVJNBBEFl8_UBAAZTV<Ng[e?
nS0?@@PjnCpKHQVI4URYaKU3o8fVSfRJcpiC_dBIK<5[<[JJlj:h?^ZdV?HhJRmG
AIPX8A8R67ThpM170lC=LlgMP^_1`nRCk2OQMiee62[haa]Cp;CeiP;^@1j?O;TO
S4_^JQ[ECG7Wa>k4J\9DkboqX=dWS4?pnT;3G7GX=5O<dYWAnfD?;Xk0X7F<PY9A
6CKL=a2Agod40<S8iTqB9dGF_Mpe=h8JmopRASWDZBpe:]102ANIoFJN]lkDGo5X
G69<8>LHK]4IlVM`Kk7af?njGJcDV]@biRMHdZ<G_4Q;5i1niUnpXUPlM=<R9FKm
G]<Vn=EQJ95X5W<pZ2f1c`?qRkh]M6]9HG^WZioBCHA2d<dKe\6?f[Sf82JkINKc
F2;:<V7ZC]plL:MYh>q=FA4P:_qRXCmWgMpWUQCUDVmh?<<8CCNTG:<c=b?O\I:a
>l8LFcPgY>C?f<:;6TYq[Pb0F;mqgB<U5;A2?PmL[GUhhO]h`_RP^5K1n1dE?G_K
q\aMGB<^_QOf0bPi?1b66p0G8U2Pmni_h`MmmI5i0X:99@B66?cCKpGIh3GXfqFI
JIjZ45bIPb9TblXaZjc_`3S]5PSMaVl<L`Ta8WUeS`683c:mqXM4oF9gp_iNAIQM
NhmVg2EQAaB=;66Sne8pkFWPN\Qqb:7CZU3em?X8=naL4hhIgIEdDfK\?lhpoD>U
UR`LEE3S>eFe;J8cBW?XI^eo1S_G4ok6?:C0BcMC5GCKhbm5HOeGhS8TC@g`VNd5
DJp62VSkH]g^7CVAJcEO@lC6Z^fL=<PISn^ZQYJN<j[OU6]_aAT@SSOfofE`Zhi0
=PDFN_;S?qd9HnGc>p`HK>TE0I0P`CJYeD7=B74aDoJ\M[1Hee30c5Fa_YiV>j59
pbWAR\9MHE3A570HFoInDF>Wh4DEUNj:qGi;KagM<c@^LBd6DaM[GGmqTV:f=k^p
B8Y0MF\D3GhCl6aW^Ob>mTIgJK9R;U7b>ho@aRCEW^e5W?6N?J];>Gm^P@Ld=3^:
0odqcL_22JUjLEO7M6[XXb\Z`7Q5HYRPBZO?ZVNocAoe96Y\S1qgDDSgU@qS3iVD
K>cN4Vfgh?NAPhEkEpZBJ1b7>qm7cmhJgIgUO;Dg?XC@C^[ZB2fgPjj58BIg:Whb
d9mTECT]qERgJ3inq:e5`i5m[c]CFhbc>bU\3Cbp27ARagAjmEP=KiEe;gbGj=gQ
[4DRcEWTX@<d2mU7g\aE_mdY]imdY1]23O<>AD^Qp8ie5MF5qnakS=m3M_]8`T^M
cS7jM]ia:dH`Aj:QIWB<lOfb;ZoARDCqnBLlR62p4D7fQRLk1LQhgI9[>O2>]0q4
cNl\4UpA5kN>4C7Bl71Pgi7Jb:7;95_=RdP_CGl_DO;OJ\@dT8nYGpi<<CiDb92m
^CA;jB:[X3hRZZd82EQ@Q\01qKmWX6g:q>38V0njnIKMd7?FEl_SC<lp=fn9XU4q
^@d=72\WGb5285aLYKBjZbTof>Lf9C^fUAa`<F1h:I7OOgqQ7\a1F<q:mkmiBTeB
dQ_LID;>J:g=Yp=f7D4VMpj37Y;BWWcd2j;ZN=NGkdSbBRUZV?YmBKX`k9<@MC5S
>UdmqEJ`C1DZq;91\IGg5TcUO3DY2gaE4iS6Z`ielqfGokI\m[VbcaQIFgY`PW7e
qBkJ=1@2p`9=MS>lR0OGb7njoObe`aCn78TMh=Ako4M[i=?@3ID<3BdpUB;<N6cq
lL<3>k5^dCE9XHP\cGT7gL;VWOQ7oW=p=YoQOg;VhlU01FVhcXVmRhp>Ni5;\]qG
2Mo^l5lDL8CFDK4JS9gVMOSLS8fO]Jk8:]ND3E9]F>aR[p>G?l71`pbHDGKdH_AE
T`^NSidGX1[`plSlHcGjCjjdkX[@LRMGP<YiH>^1A[5C[7]@00a0lZ=R[\VD;D5`
^ehp:YhBC]BpMWECJ53c;U[b>`K5ONi]I\K:?ii`3AcQC2P8LZcRULoU>XqOd1Hc
i=q0SDC@<j_Ri;iWfdGQl5BcAq>JZFeD1qF1hc:amORRXJo6G4E73aVNPhVo`?eR
?egc]>e?D@b112SlM49Dp7HL99dIL5l;W[=>Q5g3RKUC9TLAcYkGJ1KATK2_4V6R
`ikqWoOZ23hq1lB>b@P3]0kO[ANbNS2lPMq24Ib]>0qe]h74J621ITAJ[;le=]VE
^na8Nk4IMTEPMJkchjH3Nb3LBPpLoP9<51Jckm_NI5:HVJb=eYo@lV<5X]6aA7MI
IEZpEJAdKgYqHE\Fb3n`ehRadDQ28`=;glpkIneDFLqEW>_RK8f^FX4D]EV@>T?Q
4]DLVfJZj`8oH8nFh\a?m9>W5Wp4Lo6OcJp5PhG>DYYE1<`TdFiAe5EdCMIC4XNb
[Sa]nEllH7K3l?e4<_P[XFC;NDb4GTa;a2q^Uh@T^21eXljEC<iM@?Pjlpf6h6P:
mp\cAn_\gcUn]>SPhBfGd9:>ilNhF\4n78ckHg>;ES[<LG`5[qI1m3D\Fp>_18RM
dd;eVYYS;Q[O02V^_HMf9RK@NpI17Um;TY4lT\mTcTc]]J5hqdMRiVeRpdPKTjB6
Ye?g=3IRR125BhlH;XPS2:?kO5d`=^F2TT7HK=O[p9B1X>9mp0Z77:AQ]@Y[iTif
lP_JA<eplHHfJ8ap0cacYNo;A5YRPQNoJ^_@DWUiRWMDG:7AG:jU6K?E2SDl_c^q
ZBM8NSlqW8hZhj88pQld;Y_i]6JaQ_HK:>KI:3C:5`]l<EjfY@KUG<5B8;C4`P<q
d>ND9Hmq3Od\dekpa@3KCeDqTX4cCk_N9M7^]8aM3a^kjhf\MSPE4`_MEbRE[lBa
K`3L3^eU\KJ9UfB_h<09lBiD`M44K\Z<KJI45ZgBmPJijNk74SQI=JN6Bb^g[]82
Q^>pSbVm3[D693gk9NQPA^Fi3UR47A\Qha]m;MakdnjR1bIPdaPPaWF7mR>l^FSp
CS_<I_Qp27>]S:O]1om[NFMXL4ahZ2V>oFB55<1oiN\RI9ee<`ooj8ME]OmTYS?a
7@mMqCe3o@DZq7iYQ8anp3B20i[F_pWZ^Glfm@HBQQT3jq4]PdH`QpnIT=X5GTiQ
\nRLJeKG]2en>WnVA9HDgfemSfDV8_EJ[X;`2M\H1]j<A:@GOOYPC[n9M8qBX?_Y
\TpCWdYeM`[4Hd\h9NhB7IFl;lMA8<@A7SG50SNXSg3AQ\43[_aCQ=?o\jM30gIq
>\O[iNGpiN2A<>FMa@@VEiSjTY=m[bmYIa[j^BBJgBW3[o:n6[W<b0KUZ`\a6H92
fl3lYKFB8[2GeNEYAeXHB5V\j7CL1lFD<c8ilNVhaBa>[<WPXD7qji_CL6@p4eRI
k`^3WD??oOT0TkoUgE5AQhJaOBjS;IXO=m>:5@8;h4lo8d]^RQYcXb`1piNA7Zhn
p9^2KVdNO8k>EgIA_K?Wo5:JNQg57NMdj\RhhLA96`@O76gIU_g[mX;5nY6d<q^d
iXgYBqPbim9KQp:kC[Fgnq;ic2=c1qHP1jb^[p0QX0KZ@c1SkR5`[5b\J\S6UP]g
fkSaWH4N5HgcL5_CkPMB2UoP:TYffCY3co^<?JIgiPp7bV]X>1PHJQQ[YlE;m6f2
8EWnCHO2jf^N9i\5WO;DYI:lig[l8pg9QIl:TpKmWX6gPqAAZlL64QA<?ZBYhfP`
o]A1R8=E@;Ui8A`]EDkEGj^WITWJQ;9?gjG<?m32ei\6gGi6pmeJAe7Lpoi@HX^6
pWFlmdojW4J6Fa:2f4jn]co^AWPaXb\mHRZV^\4=TgNpN:<AQHmNXGbTMTkWb>UB
7FOBUV9E]mq[^ncMP5UEOC?Z\JCf[X3dT05YKL]7ZQ^EGI;V4q=:CjNgep0C\^9H
R`kb1NoaT\WP887g9X]M<;BoXSJZq_Z\[ZLSqFQ8A<jkVF1\WZj`NZVOJS\e7HCB
0WS6o:_aH^O[bQ`[IEd^T_cn6UDicnoLE;lp6T\T:7YqBKClOmXpA0nCCl8lTEKm
aNQ2UJh6Qon^XVo3dE_>7g7815]=WJ>KTi@kmd]1FXb^LK1UoVJCJg^[7djAqJC\
_hVHqCKRmaaUfaVTaIG]0l>b:qZZ3^[Q079CB`dGNMO9SMddImV9jP9SNB[5p6N@
HA]bqTU@jm_6pdM1^@KRqd2JPK9X8YEj2W0YUbB9IZ1E\@iU`D^e97^FQ^]SHPn`
\Pg0Yq?7PDZO6qYi1oN5GBo^l<LNRI[o]cb_oModO5A8F`<C:mN8^?f33O1j_4`Q
T@a\iBmC=pU1]gA8OI:T8=4DeP5;JUD7o^PMKeCY:8>3S[p1kBR9OZ>Hc`BA>TD_
e5iP]L^_T;g6cWq<6>4he^q^@Q2h=RD\=jElU4GI4=S>L?pn5MHUE<mSBSCK:RdE
6@]Y>0]ZMi2K^ekMop`26H59Opmij;CoImD;`JHWf0NV`]NMQI85q?bbBYh1pQ9n
ecm@l0M5X\cJF:1;]2kFEXa3T?01Kf1ZN6^0:POIToRelg=qNjQcRaM;aRn]<@?>
WGj?BYMO=m4hg^bMjKUl6O3XjSh7CI7BeC]3CPY0G2]^q[nZRn_apW\XJgaFm6bS
gG1Q`n8_f9A]kPR54mRDWj7OPMVnX6jGQ[RR[8d@PA6_@I6V@S]f\WQ0Zbh_pE\^
[Ah=qI1\gW\:mE=f>JOln01aQ:cFd3XFEB7CkX?A3]:GSTMh>MDS3ZFYZ5>kQ=BW
1@Wm`e8K7a>:;J379YFCJO@j\`lqAX]g>cJpnbP?j_;p^0jH\QXMieYa]^ee3INc
]1q>\?5NX_qmk=oNdYpE\ZEWBYP5INZZZIh2VXA;_8?K9]P:McW8nKadh]Q8`l71
CTY`?ZDFTm=2POh>^A_E]`_4YeoHSojUd`ndVXJ8_bAdNffkX@S]kbi^CKq9PRYd
I=qC8P1B:ffbb:DAeeNfj5:4TIV8nW0:2P]T;45pGODKM[UpLA9C2Y2pS;Lf<VBq
9NR2aEL]pXV[EjIdAmlN5KDmkMB>DDTFkcg6=iT6JPEk9=m4?df^^K]>lU;HhR\f
H9In0oW=iHi2^H9D_q5=8BAgTqZ2;ijS;V;95BO>H>Yb`T3iL8I6\cLWZZ1^_b2W
S7oY1]R8T=q:V>>mH>pacLo7d5QS?6R5j1KZiOD5fjBeCE3>;884hq_BSFR\8n_6
mk2??g`Ip2Z1cAdkpT:jT];=qLAT;9k3q7EZ?^:6Lh?B3TY1l9:SEN0og8hcm0C>
4dEpoO4DIj3pD]KVJ8Pq2M8MOgPqPn<0W?J?C0<[\>RNDD<p?n8n]:;peXAoL2]q
gSAFgn^qL\^UAA\@ki2RWjHhdFnL2IL85Db[C0LGNJp\^?1C\ipDER@TDVqGKS\`
>0qTa[Me\=RB1FAn440=65gpDc4PFe3pJiE7c>Zi7il<nRd4K15WLIJEIDJQ\JQT
?[fg;_Fffh@a3DS8;nJm<`QRFGd2W:?7FUEl>AjCq>P4eSe6F5CB0U>U]MM$
`endprotected
endmodule // module vusb_hs_pe_timebase

