/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_portctrl_utmi.vhdl
-- Date Created: Thu Dec 21 22:42:10 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_portctrl_utmi.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Vusb_Hs UTMI characterization logic
//       This file contains the logic to translate the omni phy
//       interface to the UTMI interface.
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
//  $Date: 2006-06-01 20:04:00 +0100 (Thu, 01 Jun 2006) $                                                                       
//  $Revision: 75 $                                                                   
module vusb_hs_portctrl_utmi (xcvr_clk,
   xcvr_rst,
   xcvr_rst_a,
   xcvr_porst,
   xcvr_porst_a,
   utmi_data_width,
   xcvr_ophy_disable_bs,
   xcvr_ophy_hostmode,
   xcvr_ophy_phy_sel,
   xcvr_ophy_ser_sel,
   xcvr_ophy_port_speed,
   xcvr_ophy_port_state,
   xcvr_ophy_test,
   xcvr_ophy_tx_data,
   xcvr_ophy_tx_lowspeed,
   xcvr_ophy_tx_valid,
   xcvr_ophy_tx_valid_last,
   xcvr_ophy_sess_valid,
   xcvr_ophy_data_pulse,
   utmi_xcvr_ophy_disconnect,
   utmi_xcvr_ophy_clk_valid,
   utmi_xcvr_ophy_linestate,
   utmi_xcvr_ophy_rx_data,
   utmi_xcvr_ophy_rx_err,
   utmi_xcvr_ophy_rx_valid,
   utmi_xcvr_ophy_tx_ready,
   utmi_xcvr_ophy_tx_done,
   utmi_xcvr_ophy_bto,
   utmi_xcvrselect,
   utmi_termselect,
   utmi_linestate,
   utmi_opmode,
   utmi_datain,
   utmi_txvalid,
   utmi_txvalidh,
   utmi_txready,
   utmi_dataout,
   utmi_rxvalid,
   utmi_rxvalidh,
   utmi_rxactive,
   utmi_rxerr,
   utmi_dataoe,
   utmi_ddir,
   utmi_hostdisconnect,
   utmi_dppulldown,
   utmi_dmpulldown,
   utmi_enable,
   utmi_serial);
parameter pc_usage = 1'b 0;

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   xcvr_clk; 
input   xcvr_rst; 
input   xcvr_rst_a; 
input   xcvr_porst; 
input   xcvr_porst_a; 
input   utmi_data_width; 
input   xcvr_ophy_disable_bs; //  disable bit stuffing
input   xcvr_ophy_hostmode; //  host mode enable
input   [1:0] xcvr_ophy_phy_sel; //  characterization logic enable
input   xcvr_ophy_ser_sel; //  characterization should select serial for FS/LS
input   [1:0] xcvr_ophy_port_speed; //  indication of port speed
input   [3:0] xcvr_ophy_port_state; //  used to decode control in phy char blocks
input   [3:0] xcvr_ophy_test; //  enable test mode
input   [15:0] xcvr_ophy_tx_data; //  tx data
input   xcvr_ophy_tx_lowspeed; //  trasmit Low Speed
input   [1:0] xcvr_ophy_tx_valid; //  tx packet framing
input   xcvr_ophy_tx_valid_last; 
input   xcvr_ophy_sess_valid; //  session is valid (used in device to disable pull-up)
input   xcvr_ophy_data_pulse; //  initiate data pulsing
output   utmi_xcvr_ophy_disconnect; 
output   utmi_xcvr_ophy_clk_valid; 
output   [1:0] utmi_xcvr_ophy_linestate; 
output   [15:0] utmi_xcvr_ophy_rx_data; 
output   utmi_xcvr_ophy_rx_err; 
output   [2:0] utmi_xcvr_ophy_rx_valid; 
output   utmi_xcvr_ophy_tx_ready; 
output   utmi_xcvr_ophy_tx_done; 
output   utmi_xcvr_ophy_bto; 
output   [1:0] utmi_xcvrselect; 
output   utmi_termselect; 
input   [1:0] utmi_linestate; 
output   [1:0] utmi_opmode; 
output   [15:0] utmi_datain; 
output   utmi_txvalid; 
output   utmi_txvalidh; 
input   utmi_txready; 
input   [15:0] utmi_dataout; 
input   utmi_rxvalid; 
input   utmi_rxvalidh; 
input   utmi_rxactive; 
input   utmi_rxerr; 
output   utmi_dataoe; 
output   utmi_ddir; 
input   utmi_hostdisconnect; 
output   utmi_dppulldown; 
output   utmi_dmpulldown; 
output   utmi_enable; 
output   utmi_serial; 
`protected

    MTI!#TelE<I.O{uakx\!<VCpT>ITWDnp(7QX[Ci=oFB6KD?_zF~5*I\Ri~W'-~Ro7~3E*Z1wR}ro
    !z/eAQA3$TeQ\Z#fxWrwm5Xz]pur}'H@Pe++E:/aRB>]<=j\A[@Qi~rKTHp[W5J!>oUz'*$*>EZ_
    <J3RR#\;$<#Bw~=Z772v3TA's_52{O[\;~[2[T3~BgCs\J[mHouE<1Q,RsOB}up>[KOpQK*U<>Fg
    ]}G<,Ske?rY{=2!aoaxiaOQ;~o,G^!<}o~Z'r$FfsD$\znDu{Uu@Q_?n2RpO^\w3Sjn{JNlIss&?
    GXasF+'<seI=s7]XYAoi@EaEn2s=^iTo~@>p$Ee#!]^?rp#@pp,O@]EVGzYw@eZZkis?XI'k>s!]
    ~*Hu_S_;z<TETv,Du]<aBn'lnGN,UEj#H17VKn']mHsEknOV-73C!<lKBOT@oe']L11k_On5Q!1+
    =[GmIz@us!1T1xP2}+QZ_7jBe;1gI_X;]$pHijHQx-nDCajms$+#}='p7!js"Dvm;o{IWN"];BD.
    rwWm=ZKe;T'\{5DuyLDI}=9jZ2TQAOT~1#HxG>RsW\T<aRsa731{_a<o7=#5p}\7Y?j'@aee}X$k
    {[AxzGuIimk5AQ@4?Cu{V@_Kb5k*zjRmo=_lmI]J'5^AGzQz#1^nIm}z}_vz[{1KmN|4[}?BxO*u
    noIBY,-j[E+,{vH#Y$il|'Qa=7HU'jw]'RW7YrRkm^X'z'[U<EQO_/#$X[o$X;^W7>K'n$=1E?;=
    KpY>-KUG-Hi]J?9+UlWovE}I1k3\*xDT5!3ekV*5-35s-VCjr>xw+{I\SXCIZe\@7@H}RJsUp&~E
    !uW<UZ\A$\*,'lXjs]G@x3',i^><YTQ$vk>Q{!v,ZVHC{$,^m;v[V2\J;wK-xCMB-V]F*,R5Gu}]
    >7Fw$ep'j-n\[ZJR;$VM}Uv{]>r2Irnz&Jop3[wXB%lDT,wHwZ+_G;P?R['#t-G5*AA]2y5VzUfB
    uGuV5[o_h*~,mV\Z[<<<{>H}<uat<1D~RXH}|~\1^QRK>K1m7QVXR<7RR>nl!jvr$?[!DeKT#;v]
    zWDC[IUA3U[Juh]wn?Kr[$_iWus1A7C#5^m+1$[v,2Bmpws2AvC{O}Ixs#Zok1rs.&>r+-V?WpgC
    !A7Y1<zu{H]qE$Ur[aHEHjRG_uCjjZXsRwOuxj>mI<ekI,1RI2+wBH'A]j\ZB^DGi-uIC7Tp8X=z
    Tul2_2{D2]l{$R5~=QmjwQa7X;=TuA-{=_Is*[iQCwn>#-\X^CR$33IV*or<lOGV^fKQmpRX>oTC
    ZEs<@mBWTu}CwRvBZORD]TY!vp|^7u7{-~j(xm7'_D<3Y[{T75rap_@nBe?ED1lH7GlY+rY,}5Tj
    _kQ?-r-s_Ja$7WzRz=5<V,+u+TY^~wWD&vTWu5[-@}i_;=?*WQIJ>RvK]?zG}Di{$'Hoq93*~=2E
    aaJOZ1oo;OH[Cu~UC]#a@HaIlD1U!R@<!s2DWK'[,*3YUz{lK?$VKTQuoUtom-'}+s-%BDIA'^Va
    in^K4yB?<}^+x^Gmv$V=Dj7G~,BDTpDxDT?'~>!jzi7{}x#}QnXEYG^2lm5*QK;_~Yg$>QDZQo!i
    z>DoD_$}Y}j_XeCOXIDMxU{IU^K?Qk;V?osR8ZjA1U^*H7T^=*=V{(#Rz$X_wG$OJ=^1Jl[=R<W5
    i#xm{=x}2VmO$iN}-Brinnpo+e{!+<]-^QOOBB]&7Tuw_'A7@^]Z&>\+Kq-$#w+BC~qx3o[6Ilp1
    U+nQ;=j?S+oWJ1HW;1O7a=D+Yz!lB=rB?k5EK-]rrn&l[nQ=uls*AlD7JzvBi={KsEwTVYJ+Y=I^
    ?,viVJuov7DC7?2[++#]xGZm$k,eo+VwG,-_C{XpY#>:~5Z1xp#p^G'3'OW;w+<W+']U[+{[B#WY
    YnF[~{W<l+7-{Ga<Ox?]*3Ge;{mNN@v2[aAA_nrOU6Z=?KwA=Cb^X=_~jZ26iB-3<^-_-*2Q1a]n
    DRIv%!Dk,g_&2Ej'^-HDsuxlxC>Q_bUY{~\#UYQGiknHYl0HaXR}V~!xPo7{#%Vv>;0}7z7Dw-n$
    \vuC#G70~r3$>TJx2o;a+5;k\n@^T5[?n${Dz<1,;oDOFwI<U'=#,[i]Upx5p\u5ZIkrQ}m2V*7j
    <D5wBQe3a_]"97@>BtU$iJZrV;$pwseC]p?{\J@X,!_+@p!*B$EiB^]Ioi'Yjk|7aTosn*WGC#$0
    ,u3@rn]='#QDBVv*A+<B?<ne,<$_7;,XGI{x5=E5)C}BOxH7w=;B5kI_x{B+[1Z~R*zpC~rY][=#
    O,\iRgg$6ge*>s=_3\JH--,OQ@\=xvvwQ7GXB-T^#o9@+{[nOJToJ;ai_$_m5bBJ21?SzVi}3R?>
    7z}eVs>@$7j@7,ia^+vU<\t',jTlJ!>mwBJ*]5OV;\?S7^ET!G2AB3T@^ZQpx!'?o;'TML;na~)[
    J^usA3IRs-\maD'jC72}pK!'H5vMD1ZQ>COo"Cvev$X_H{OG7lJ]k%3vp@D7<m&s[<Jp=Dp2QHVj
    >X@-^~vs[ZHg12!uX-^#NxEZJ*~>}p:iV,uuBA?PL|J,TBuj~@ilnXr>Y+-O5u*w>W=2s5jwI<(7
    YZ~B9sY^TSHa=UO'D>z'Hm)OQmCiQz<J-ozp(DjXT=mAZW-z}_Q}]IG_XDZY~+1'<]Bukz}mHHE^
    72sG>Tww}l_I,>X^@jj7KBe!]-Cl,&\Z!7#XYpuRTw>GY?hI=2['J1>$Vl@D+x@A<1K=!\XI_\o_
    vEDEojoph[v#oEvR#w'=a-s{<OT*5V1GiT_?IrpT@[1!3azk]2UzrR;J_zQaHWszzO~,^Z'#D6y/
    V"PDD*>/xkweLW7oU#5-{A<]}YQjxaXYnf$2w-N[@uBNJ[@T!B{s:IAoIVk_Q+rAuK7G]{^W!W5?
    K]vZo8aaVWh=VXu}_CVm}T=BsR{MKED_6^$zw=V*vv#l3,!AX3},zQR^B".T\$$hA}=$#-H~k=EQ
    =;\Tq15!siHO'uTZ]N-5~wm5<U],vAzKZTl_I~e<;uTs7Tvx!=}A1HqlG?Q#x+-BiXz$#QI4I=]'
    M-Dr\ue,iv;K[|ar<J>5X72--]YI@}x3E>_UsT}vmev@l}?I_Cw=vE?<-O3<Q@r#~ur*XXpCi]6>
    Hu$oXwk];$XIDa~uTpGuUT]\O@wDOK3$Vu{_[~jUr?7;TeB;s?xz'^D7n$'^5IRHv?rDpu?v@s\[
    'o$Y3Wn+\m[QD;x\X<<pIU'[kBuh$Ipi[FYg,vs@Cx~5.zXZ~?5-Ik\lnUsm\]IB=3=lv2'ziA5D
    -KDZ=~1wpr}_YA[r2GokEL]Gr[l#@oIe]-?IW<Io*s[w<GWIXR@CQ+2E'T{5{ZI\u{C7oe~nBiPL
    X}5RBW_z^=x;]IbIjvRn*^R=LR>2GusBuzQ\ZJlT^G2-ArpeGTQ{,v$U\Tj$Xi\+xuUjBA^Y*lpi
    _c=]uo~D!Y|oi\x*!OE;<JDzY}AKVX3j5*CQX23j._*3V3<J~WX{?^,#}N517+=;K[__o[l@x1Mn
    Rr5ybx^#?9o?z}7BJA7e]]*{A3$BY^j_@v_I*G[*mXj'=VM]swl=n$;@-<UkaB[==EEnaK<j*v,K
    1J{=GRsBREvNpRo3JR>eel$-[ieu*!7$]BGTBw7Gy'xV]^~X7dJT!113m's5_]z1\QmpZ=H65Q$k
    vsZoqJ7kC}EDjUXo!EJ]rGi^O:}AWuCG?[m5B^N=:o$;~GvC!g,,kYz,O?s{;V{j3@'@\,mz1#H<
    A}6t!TI3lT<row7YI5[UeV*BXo[~A7TwK+HziHC*:xVn=Yi5mpC}}Y+7r}37o>[@kp|$ErTD#AY#
    EHBv81m^HzDj3nw,,hxV-2*Gaw3jiX?}GKYuvV8Ha3B$E}\x'm2,5jK_kaT<'$kD=--x5JRl_Ov1
    EiO!jX+zw;G#_>+gWwRK=l7*+z#e(Z<zwlm<JNsz#2x/KTI#Lr<[DDkr<kU2I_\WZnp~#KQ@':Oa
    ww$>{w-\'jgqiDV]K_-Ul=ER+j]nwBoZ%d6'7z=v$>uwe7ZTviTm[}O@7Q-*&V@!uHs2+QmDuAYU
    Klv!aY+p2h-5IG#}vnz^nKHa-AA-cWlV2HS>_iV)$*nGB=ivT]Qzqe+7e?r@5SuoQl1QrxlT-l5,
    {3QIsYR,u}x5>Ukr+K,BuIXN:2BZ\AlmZe2CQKUTWjZHBwar+xQu^$DT~UIGi$Au>IWAvc*,+T\U
    e25zHEUS#>ZD#o?Hu=5l_}#[%2r-_2+m\z!uCV^Ro~]s[V{@@]Znu+DTn#\]B\5-mVH~H+A3Y2Oe
    lQ_=~e*57t{UGZCC2+}R><d\O;<*]^$Q\AVj;$=<5i!AHj#BG'l$m>'V?K>+5eQvEzJ*J5uVU[<<
    Qm3YDUXi<OQ]Um>wQNi{Z+$;Jvc={}{KYv~2BjRaHj'.UajrxCXeY\~'5EwY$s{$c@eHH<B=V8HR
    _!5-'zr-xrs}R^=5+>R,^U&)~oBOrjxCjQE1lG+pC<;l;<--+nQ1l57'}E'KYVjaKo]R|tLv-jA?
    O~p,_umseY]ul\ps*#E^;_!uI]wF'V=2K{Y7lzE~Ssl{B'$-$B-lXVsJ^1lmC]X~R=GCH><IXg:z
    #wTU,~VN*ODu{H~\2V#~#{T+]jK2KIT?*e?D"JaeK[JTAqx}G<VX~#5vYE+r$sOs<j3x;m]0E*lV
    $<$wk{^a:W$?$1xs;4?}QEi'T*Y8HC=};ox3=5wxGI<$FoUAH[_pv~{1wQXw<8iY7#o;K?CiQWZa
    };?YZm}epo0j2nT!rQ@pzl+{hl7[@<<-l}i^Z^^C7xvE^Y!w[WYlp)Jr*j5riH*&_LkDV$DVrzwB
    r2$pziZxvBhi<UXB?~}r(HX2=u+<^\JA@\}BTi{mH:wDHvVE@eKnnE:_*a}r3},[-TZQW5<-+Z2r
    ?u@VI=*oHVK9SHV}z;HH5pJA}L}x?=R2GTWEVWFclVG]mo_,]#rR>7IpWaXClD_5bu'zmD?*we7!
    ,D#muRZO+w>,<>zzJMavIQeZX!rXJEvu*sZ*\;~O\l{_x^sTEmvk}*>->?C2aA1KViVjYYu\_#<<
    ,pTG5@CK'Ze_VT7k]mEi'^AOTV{>j!5#w>[]$\maAsE>;nY{IVso!AY#[^>zZ}lpnQQBAo';w1p\
    z]$QVunnKNA5D-eTaml3X}xeJXj!\'f,3px#V@Ve7$Go}}a4]<ru!oOVC+*nyIJaT2n[;_]$^?VX
    n[Wn'0UrkYI'w}'Q\Js^75xN;OlT\}Z?2ToGE#$+[?}U7B$Vekv^xvB-5!~Z@H~_rG#?@V[UgjEX
    H<=E1#>w~~^[$X,v~Sa\,j]nor'Exl{UenI$aHsVJ}r5]OA'-=xWl'!lt[xCI[Q]ee*^~]?9mx#>
    mD!>a'X{,o+z+}[Of\@{EDjOansn*73!],{<>+rJWA_}3+ORkruIQ>5$op1Er?][J,3+;,F2<]Z>
    Yia,ml=xam'la5K;1QW^.Ij~GuzZvIr}#@7I#G[\,NIvpWHBQXR>,xka+I#G<EnX>-}K~}/?B?x_
    +B5i<@G7V1~1>Uj}7?BK_VGw\rX*B;;2rV]G>a$VE\-'l57W$C'XT^xrDCX}kDW\\[!Twe5k,<k$
    $V,w*+alAWo5upHjSk\eDXx^BR[Jk9D?<O4EH_>SWsj?AEza13O7ip5^u}-]V+2[WE3,>x-n[CQ[
    (N,IjH>Q?xLe<[=RQ&V-wQ=W>n|1[}@]1zXsNr>'lhw1*#l<$EJSwUAU0{GDEF-[vE2E[HHs?sZn
    ,QsZ+OrZzGj?U=B]52-T;$I5e]19U7DW~TsC+,V]O'#r+[i$BpXm/=C<p&a*[*5RI5e_\E~_}@-X
    ^zsojx3\vra53!k$D]}}+YsG<2G+2ndl$+5Rkm'iv?[m<r{q9KXp>nUYHSIQ3^!]![aw=+sA+xpK
    2\p\?oQ'zWj^Ol5a,{{pCO*E_sv7luOA3=Gwa$'uw=Lx!;!Wr+s#xT~57k{~ez;urQ],^}pEksXR
    $z~<IXH$Deke?'n@lHU^xnI^_^K^BTT\nKwgICExx?'^[K\YP2=#uI-H<3X$H1JHrO!{C}B{kvV+
    ^-X]!A1rT\=#DX+THZAx]&5G*@pJ2jCKYO>DJk+j;^z7e;?*o+pQBwKo+Av>@O?V;>QCisSAwJK^
    @'jwCw]=DA>xG_!z2zAq|w{w*V3O~rG2uhsx1GaB^\}_!$!CRo{Ue*5UeWB?{;__;Xs_;,<EV?7@
    7$LYilUTUDVr]Ra%f3e2=r1euQ?2~Y\p_>1U~Y?zras^lYD!,[H\lxK+p$uKz\A[}d*s>*KoVu\\
    TGY?+VB@;se,]kRUGUKRTv{B@Gz{EA'}3lvV*,T*zk5IlA&Ka1TX{m#e^mk6m[QT@7I<_T}xp}C;
    lzmH{DZ>W{o@q-E[;Aoz3s,Zov{>-'jRIm+I]<l?#Ga@J*;vxz$;~Q@o[@[vB,]1}l,s}uz}VC*C
    _k-7rs!COC5KR]mrmno]zpv=3E_{oVWvelmnG5's,=B=<yOO]1<UYGG}}T~Bm~_Trjp,iw@<o=xB
    xr1B~uC-W$=?Qi=Bk2ZX,!Ctv?KkhTNI[v1blulK!B#kLNoC,TkOJCu-=Q]nI1{7;E+RsnGjn]5_
    <RR^u=n=T^5Xr?>wsuazE~UTpWJ'$DXn+ucJa]zZT$5O*w-o&O*aYi7r[ykQvZGl2_VD$Wprz{o_
    5\&\<a!AT*Xj^?Hk'I-r#Oo_oe{v]RWO_'W5iKzHYpC7-D^>$-jelkEZ|V3[7j*>5oQ;e<*7eCh@
    =Cs;Cw[{}ZCwIUOC[o,1Cu5RuO'L,Aj}{{>>v}[Wa_},,}=!yQ1Glo>U~<\zDivK#C3Ce&[~Q;Dl
    X@9N!X;^N*mCxr'n-*pi<J55v?nj$zOvD>r#]z?+Y@T[C?L=W}evDV{ZDkpskt1YWpm>3smvlE<r
    '[=[5+e3[Iz&V:>t*7JjH+;OHB#axTHQqi[UHN__i>1EC+JrI2xH~p~lAxel'+j>B_,iCEx1\#,Z
    2nfCYuApTW5UE[+@Ve=rk[?L6-T[[(8u>,7AR~[C?Kw*KX<D[k7(sv7mqkU+_53]5mN+UVopZnzD
    mz[DGI$j{Ds~C^E3nX@Grv>Ze]=]31,[J\K7~O;!7v*-X2]xVI\F7peJz{pu,QR\x7121\BKlPr'
    WV;juVwo@VHTo$ODk1)ZXeHTO<$>=KxE~!G=1$'7+>*/12vumO2@j<Z}LQ,w*lOV<Qo54uRj2s;R
    ,r_Q[E[7G}uG7<RR_;<,@>OeIjRY@zRspr!RaiL*\;^l{=7DV_~uTU?Q2-AQ=*\k1!>D5I#e~l]A
    w<l1^WIt^qQ?jJo>nHzflrm,WYBXMe[+?EpR^3x\xvHUHkV*mIl*zF73=v3a2Q[oo+asCY8UUv_E
    Gnui|mrBDvTjU4<$;\exukG}pnT1lee++UT*[$kDQ<N'B3+W,<pv[;+lu]\lCwJE]-[|gL<n~Qz{
    u7]DKnshGl^lvKRia5KOnnuwz<R,s7z!YIeupqRr2I%|E\{k\E5]}oC$#'rZ~1l+I@o;Wzj;fkwn
    XAxY$!=>+4>\je?>A]m{lK/)>7r=+7D\+R\OY+3vX}os,{K+*BV$C{_1a$#2-DkXH{1?vx}A;-$Z
    mR5;CvB;kz~Xxzam)!Da}pnO@\<)C_U{[3<>EGQK{lz!G3}mR2=mtlpoUoEQsrn@>\iW5{nv{Bl?
    ;orjapiR<[]\^olkEH+I<eU->V+*jtiXjwVzT<a,[X2(U}r3$'}AIeO2\Q>K?'@Z7#u@MbGAGxIB
    uRmn~-j5uX)Hoj?DYim~vmv=Yxr\oXXD?[{^_i]GTW-U<eHDCl!^xOEc>Xsn3eeeWqXxA+To~+;G
    {?,1Ik,KV1uD'_"Tp={sxA_$*7=zC3QU\e1<DpRs?}}I=?1[e7YkrkZoMYZoGiCwe}ue[cje5iFD
    3o2DEjE?*Q{sH3AZ-~p}kRluG@wyR{>e;\VnA}oO^*KpxwR#$?HH1DRE~\URU5?AxK^RKwTVjn^j
    *WXBl:R2mznUrk$EQQ}];#'#5T1*C-'?;?=/}1axOYU*-}51ZXew13_e4BBH;vXT^;5=C1^n}^+]
    irosew,^ZY#Dzs{2YK*AwbDE;<d5e~+mYVeaazO+*1{NB'KAOE7~AQjslTB@E2u2rw]Op$mTM'G5
    vjqz*l1KVlJ=G]!ZYKuRWoAS?'D,^HC[#R{T~O@2llJKp-]D[mZn5]sUvi,7oA}j2,1iCIm>QBk{
    g[u<!.=A^Q_m]O}#5zl!piQ\<3H$=^?vr-lK-5<p$5@O!I^l}CfD{$K=E#7,Rn;z\3EQin<TBOp#
    s_ihLOko?aamIN9C^,I}M1U<JDlBl?pi>p)wVmO7XRJGj12$@UlB-]Q>C'_A,vpsjG}UE^sJ\;GO
    $@u(#1Y]iB>DpT<,G>~mBX+Kq{RZ?sR<?I+x^CBUIyzxm,C,rU=15_LlRRB;jI+.BrJUVEBR]A[{
    THr]\m~?}kwDws+~P*K@Tr=YZ:Tw5TsE$IB\O#TVuOlviY~O,=,]IWn7n1,<EpY!HC^$iD.4sx#\
    5t^K*#{w!]=j7Zq@C$B!zI^Y[*5s#Xlqf8wq+X~r=W{UAjYG]xRnoG1Z>RR}$B^?j!luzUKIk<ez
    ]5?Z']IIZ}~ZrUI1mlwV=2UoiR-kF(,uUjHXB>mGv~W^jk;p+$}Rv@nD\mpwxWV<}e3T*^t[rE30
    r$T#c$sR$\{>Kz*?3a$7?lU2GH[CWuY_+^X-mpRwrRze?uYC@=J_UQYp>?Y\}>_;~hO'rjex#x2Q
    3#R?zJo<$BIjZj_>GV<7Z=1HHQ9e!5oWp{U1r'+bw<V'U<z<<$;$bl,1CAHC3<8V.}A@TjjDw1>;
    DV5ZKus?==rr+OX<1-T'3A->k$3_}{[\3H5X5ZQ*l2v3D1TR=\B1iC?,,lHo}mT^$F\W@s!OKQBE
    n^bRy{^^x7[>BlZn!sA_l"IE_#GIwRrUa@6}^YVsrJO@-OIY5sov+zO71AkExDK!E#$qekxrK$VJ
    z@JO[HQAJzm^'jXQF<]#@'Olo${o^!>vXGml-7>a1n_!@A^};emIewXaHvOoCr^k^\\AOGpUsQ/f
    fE1kDuX2kI>]!>o+Z.EuXZJXDTez$E~<Yk3Y3__U\,{7'?@zIa6{jB']3Ev2XxurITG9SLpuXV<v
    \>z=mU3G{']Vv3RczrD$pk\e52-o!*A=T1Dkg1n<uE;+Z,RU#v'w_:[I-nY3WBvZEOvUE3pkl_#Q
    upCTJ~R^zOkTvvQOZB\;npeZ<?Gqzx,'Nwp>o"n\zp+*+^erZjvOw@CYE7BlCijR2IBu13Bn[~Ts
    J}k7VEJzJ1}nT^P/n^xTyv^GeYk5*#<e~W++JO\{*}XmCTsAE_wp@\C\Ks:u'mW5a-J}/l\AT;=j
    A,4GkxKpzD7GTYmC,E#elQIIR\'V,iJxJnmM}>Treu*RH_a?GaTxRw~Ee=I@G7kY\@,*KnauC}~J
    r@pWXl~Wr,<'}V5oD+2WmHeQ2o_peO*5hz#oCrVuon[]5d*EGawjHl>>1o=W2o!+E~t[ZWZBVoDo
    i}JK+e*5YZjsB+plHHGzIeu~R<rYJU+3>oK\-TO*V+srRCQ_G?n]K-x8O#U]D{+>>>=~EW5v]s~R
    D{J]7K+C]-=wUU3{8:jQl\gZXe\TC3*#r~+=7Di$l~u|<rp{,m2C#xA;m51emO1+W7OuljOW7eQK
    8Tl,R4IJ+O=}T;rQBuKCC5YuA-=e>_KHKE2\D'5]*H'^1o6x'J__'W1Lr3HD=E@!SDQ~XBjGuavk
    }Cvil*?z$Z}'az}z~+*$HGmjkRRXx[ZxZK{2;pk$+U>A<T+}Jrz]2k_Qw_]R;};Cs[zA}Rw2KBi^
    I\ZW$}$II{-$]Hw,Y*H+2#Q^{;5\B2aXY'ODr.5K=lOHY<X}DJK[IAv2<Tonon%\'+jlB]_/ZI^;
    p'V#e!U?(o{5@AH~}\X^JDn>R1UrsDv?=C2<]oC_eOiaH+YTw;-1AkI+2<B$2d\DvJTBuO:'\Xuu
    QZlUne=[~{G!D+J{OiB${+$[3O$HUIDqaIW_#,=lB2X$YIUvK_v~Oko}R]?G_A3[G-pVee^HJj=C
    5^i;Gnv?OX$~<$z{x]JT1r=}52Cer,s!!Ll=}VYZuRY]AWDj;zDlIa,RCx$KWTD+EW-T}jR\?C$?
    7JA^I>okjE7\Hmsm@sTV^n^@Opr;au@R*VIxu7#H~rBGBZY,Io7pC[|phB<]QeH'l$e@}l#E$[']
    Z#]]*G}wp3+@<xn\_DNWXB>sa1U7KERZC3]s@Qs=uuVTluXenCJUX{YvoQ[XI?vvrJXDU]T}T1[n
    xJ,'5_O3X;v=rQxm$2eRKK;sw}W^lW,bt^L0B*!l^z5^x~}xH5E{rW]^vOCR#*ulV?vspmT,$R7!
    l3YwWDowM\ruX}VrEoY_o+H>C+_[z{vK]$_\XQXJHtOwwDG+v3yYpKJQj>_Kz;*G^ABwnxeE+2Cq
    ZTaCrmTK*CV!vWj+WH3-]7Br#XTkQ\Z?a,$[;C,@V5,Xnx<1x$exrKTxh^~sU|^HIT2Y,+211m-1
    XXH{oj2Rl_yHHCkz#>G,V^x@_5<C3+=oJlY+I<X;'v-$~jY@X*Dh"UIm!TX=Jsh&pJv=]h5IHCQx
    l^#lkA+GUn'I'v@UJ?x=Ux$=}VW-QjG[AYw}K,vo\[*+<@RUv!wUXCDDpAQCz[1{^llY\OIx2{}\
    !ewBx_ezw@B2m;O<$KH]}ZDi3Dd5BR#ICA@!\DHQ~!=C_YQ]'Ip(#1i_XsYxY_K$x^$_!$O{Ur7$
    I7x2%X[KClVK}raRnFEw]xX}A@R-B\sznE{zKpQv'w[_iW*Te~C$D]eD@#rWX_,knY;*=j+}^k}{
    Q$+}2E@R3~JCnZ,!<sR'Q<cnHV{urDX8w'<rz\+?gE\<JtI^+u(\Ys'?C2=^,=7ov_B]IH3EQXoo
    ?>rn[!{]@eH4QD7vIO~V,+jDxX[[?op{BD'1:1ZYja[p,Yv!=xo-G]Twz"II\{o?u^rm@e@v&O?D
    _]KTQfUxD?]Qn;RHlJ!a[;@RGVeUQ'xR'>,Zw1TSl5JexK\pXE,w<\]e$js@AA;T[XD,eV_p$QXl
    dvH=Hm>\jwTTWZxz!$^<pr+]K>}A7^*k}xQVI'1~OQ,}u[RpRK}zQ0}T>ZC0KD75,T7,.^!zBe*#
    Ji]o*bT5]}I5pArAG{lmOZSJs-kU><EoOo}5w=\uaolXa+UITYI3DQYQEKvo]~eYi11R~31E!nT_
    *CJQIUkF?,,'?EUE_yeZ[V}wE#B\Qutdj-znSO_w2Em;[viRlErDJ]BKu[BY$e{]$Qja;_iT#l@Q
    1@TvGO7sX,_+GX,#_;Q{=rs7K[BV??'<nFv<YU5lpWGa^3='+BO'vZB;UuQzn>v3EGYD@\*_*[TV
    vinDW!>[7W=7D*vR2}THl]5YiBl#AJBx-=zQ713'_z7Jo7noJOr}K=[[Hmk]RA2EA2mAn^O7UU:{
    $Jae[pTp[Xxa,+>{H3!REG,@=z-K-~\w[OuJV;BX7J>27ZKO*~''ee>N?'uw7,'wCp'BY}sY;>nD
    l];zcDJu[GPH^n;[uRxzp>-Bw{XZ>j@lI;!jQVr"8$Z!z>CXTw*[iY=3ar7=7lX>3sY'uITRV8B>
    ~mIUu@E=\!^<3;r@,BG*IUs<a+e<5#p7YX\O~~U_!CnpB,J+KjV2's;{7\E?Gk_o>+J^Ol_mB;D5
    'J_zGlMJRGO1w=xG~nV+z}px\j1Un15UEX}&ko{!=us{@ExwJ*IxYBsZHCZ'ip#Hm-Hx5k_T,IrY
    *GYiC41+Ck5uZD$r2rdZH]m)Tsz+3I{2XUpphVA\j,}*UOzA7~zI7yVQu;r1HT1W'1DBGr+>+pW}
    ;2#vR$JDuTGQ~DOl=KI}1T*A*eQVk;+oH~S+eZ\C>>[J]7v^BVDO\[1=R<G2H<YlXRu2-<;DnW3z
    pX[%2aHGU,D=x#v;Q<V7tz:3CYZ6R_G#[7}uHGpTm{3^[U5eI,[@wl@[,;3A,W$WD<-kxU5eU'm'
    uDD$v;nso~e\K5_12sC1'@-}mr-}V.xEuB7]^z1CmTE]Q^"{w'r[]jO,e_,*=aKl}\-ZHJO]*ipC
    WKn;5zaejAKr2a{vkB#w_#w++,]xx=QI>jA17-spW*@r!KRXX}xj'HmIIjXyrQE]C1J<X|3=BxYu
    W-I,K[\]xHn<Ws<RVmWTasz1jQ,Ca@o#uEQHB,#vK'%?5Rk$'$+h2*-##_X77TZum'Vipj;pmj_?
    %Rk=Zt>^rw+752E3I=A_1EvBT@j@=X-BuTY=Biinws@jR#!x~WAoYjm=]x>{3'>9$G3YG=,s!5k[
    s_RYsJ2CO2G<<HC'^}G-18w_u=Dk=}/6e'\Uj?aa,}7lz1O$!<<wYT{VMj^Di_ZI=bfLxRRkr*G'
    =BJJM|9aVwDI!D;oJB<lW}O]a{G\+G{MjHDI$R*kM[;Yx1a7@s+_7ne@_T7'YmXUW^DUUWHJ>*H5
    XD1Akk<skgH8IZ[<$kX}z3,AMz?{BVi3CxevukeUA{G7{YkO~*=5!j,kwuG1WW{HWpW5e=!Ix~-A
    nZn{T8\OA,avC~?livPB2;=Rr=Z+r]UojREo^I=1[e$]9~o*olUn,;sz>W-XYlRK5D7eml;p3xA_
    ^cT>pRe3Eozw\-Tl_OC2!B\iH+U>EArv=muGTJ:V{WCjDYWR'*!llsp$Dj=D'vH\ECHa}[D{rR#o
    #Ax]?^W1*xx}5HR^^z*s,Z?-Q[_EZpnzozEGW]mup+3mG3[sX7,pV-vx{E]l\-<_n@T1\{ze+mJw
    C{YU=3GRo7vi_'r0^{GI,mIx2pwnvm=HR{z!*XWeIAR5<n+@1>!vkAQ#c+OYD'jV_?-v<U*?Gj-v
    llJ}w>IK^'[i+sRWji,m+J>vHea_o@<Y-},m'pAoHy7Bj}&Rk\p_[Xe$7EwoCYJ^oQ@[$iVo%~r~
    UAOjj#j,RQ+U[*B+p]ZjlzG^=fc3l37}s~BKhXAeRC1=X4x*w,?XwTG\a^C]Gs>H'<;r}Hj2o37I
    7X!,,@vHoVY[XII\zl=woI27((J7E3OH^^e+aGVQzTv?V$qDpJXM)oUmszEZRip;UO#>O.UA*GO,
    wD_i$HQBUWz2$,9w$*oY5e^E7CnYYAEk^DkQD$*YB$D>X7}HHp_uX^RrBQ}]x@'G^[+[j1W1inU]
    XzwX{\TpzGXA7@~m$A;Ri,!!oUEmeuAa[5U7CJ2VsZm^pleVX_nPZ5127lHK}WTQlkZCKx5?1wDU
    B$>$ZB<zH11ZR27OHUYi6zI[zZwV7A^B}u1A<WjmIKTlQI-AOOZvIK>+lHR=7pE-T_r+vQzZ;*Vw
    {^oTR<Hz<mB!1-TvYEe7!jwT@Uv[eG[}'J_J;Wl_rhYDC!-[x,AQAe&CHBUm]52{O;[VlI@J[IvQ
    #\rV[?V?Re+!pk<l@!Vq,XQR7-E$QVok%Ho~\UnzjKE=au{{K_Krnx,sDdOIs2O=a{:Zz+O{'j]e
    [?Ypv$B.5HT!DzC2~Q=XQQlT>x=K_aa20i,~w>+uem_3R6Dm+uBOo5\zH2-]np-_{_=CB_a-n_US
    aXAu,vi1wY,Hn$EB}J!wCgip'Wuz}zxllxoD*m$HHn{<!-AO'wsD2A7<uRBp!nz5lI@YB#sW=V9K
    A>Z$XlY@A;Ovul2zA[{+C?xmYAXqTjn!RIn$}[Ivl^Yp,]A$[nmp|lUBs{D,lrX=Rx[n=YKoVGeT
    XU^AlA,_D__[;z[U5C7nnK]BeXT}?ReuY.=^>*(JT!Vi\-X|-Uo_j7<Ve<!zuYRa${-1x#wud7aj
    zODwXa^;waU<E4OllA[^Y7y{eBHp3@[OBkIye~aID5D[*EvD7v5>Un^_rVkKuBOOu_,Z#VD;ZwTO
    a=3U[a={o2GoH,UzKr7iQiA5j=_7*TEw$ml_C,u{p,Ej^~>3'B5neTOQ2$ve**{MY#jo}BAk>=Yj
    d'[Ii1@W-QRH5sv<p?5WzPGn>C1,^pTE?,\1{m*T$kXIE@T*7ze_<$(:@>X@rT=+l,ls^vzkkD~C
    =Q<$Z\5Zoe\e;UYKr+3#;B<T]i{ue+ElJn~x<_kR2w'$<HoWU[QnsD'lZ=JkvEXrA*W=7sk@as\C
    2<@{'Ep__x1-68^#jBW7uIe$$_}uuaKwE2IZs=p{wvYG_@_.p?u=UO<-^\[=Q^>}*k;*ClJZfY&z
    -5==KQ\GW<[RE@K#A7?2U$1lioZ'-x;[s-wXX;zY<3Yq*7kTznJHlviw$n}!g_R^;rskZ*~]',+^
    oH{^Vs@I^D#<$Kp7o)KUT]]WzACku?Dz;,e*~u1V^}J^Ir]o{#ROE<zT*{pEnUc$DmU5^_2Xw='-
    _X~z1>5J$VA1l=X1>2C>R2o\R?2ro\K^]J!MTI!#n]Gj?U==RQps2R}IBvX5]C[@,Cm{se7p73B,
    O0Ok~I8fm[i]mH2['y$Qk32X!W{+|Fsz?<|.>TO~qRL[mXX+^D*_W$T%2vCo"0;&g[~p<Zoo!,ZT
    z%Vj?TxTo;J<x[URj\VR>KTEB'v+u3LJDmkyr*XlWA\i(#,?j[eG1DDJkvlax,!QQ#5!v,s}^];K
    QZTG};rwlUYU#[x^'$vjE_Wxw'W5G\HBZx*xkUnnEB23HZ-G<HXctA$1QW},':l#U_1[ar1Xv$?5
    +-_ok~wUueRH[[}!7VOlX;1~$X{r<[:Qvk5n{j*}annCsvwAGin\#mRX^m+rG_YQWV1prxKRvXIz
    mH2H11j'3j^>-mT7BG~=R>m_CH[Js2=1%z#>W^G\kjeAn*;p^MsaDk\DY^Z^Cw<oO3v+'73ju{_z
    lXCKX#|Gww?T}YCsU+2o3Ra<DO2xKs>[H+Z6V[CO2aB\=1,V#o1p[*5{2s$CahXXPw_276{DJIcl
    3rx+v[Ik\K^Ko_<]smB,W*oD?z-5x?IR[Zm0,7xBKY?\D1'WOmB3}k3aYJ-<E~NxW'>avoGj*?]{
    Uw>^EQAwrn1awDah7*XUXC+rUD}\xx1!*{nwOvU~3v77Fk^IK#jC_Qv+#7Cwm$@T?A7s+Wz}'QBw
    Y,Wo=inmv:G_WZXzw}"Dsa3paJw=Z+Wxxspjr-jV-ICQAQE~j,v]wv+[{^w!-eE=ojUv)vC2#lwX
    []vl}*eQNJvz@p~wJgEa$_[HKzuQ2?Q,@+~Ar~FvVZ2yEZ\Ymo[j8K|2E!}H$uuL[2u=G?ZZ_=?I
    '^Kw>OiH#&rHnDte+C#(>sv@N$)F\;oHA-'!zCmCpImZ=u=J=k-?mVB*F'O~;eaB}Dw2R=awoy:k
    5Y,1Ge2{^3A<XVA7*?mHoxa<s]CKAV@l5GKZvlCjRHIr;lQcOuETpzorEZH2YnA])zk@u).:D^UD
    n5KkP:<'p*q;wT@4uV?A&-Y5'l:8=2B5[D2QjEQsa(++'7=#Xnr~\AsTzv>Xl[_OXOU,iCY}{nC}
    Q'ir3YuR_*OOEXf>DElj}zrmann7]_B7,nH/B~{=}[J*()#[_iQ#3]h'k<]f5_!I{nBGpU'+=*-B
    *~D[\7rzp~l$e6I7A5'*J5GJCVJVH[{]eX}3[#=$m<ZCOoDJ_Gsnre=?FAU]+HE\U$r{~s7Ak,2s
    aVuj[N,JuG|w]{u\@_{;DiK6H_#UP\a!*ICOJS*H<r1>CQ%BHXQ[Ho+W9@p7EQ-KH|BT~zoE'r}i
    zA5rxIvQTK0ToA[_M;x]vl(><N\]BJ}QNQwYBU,V{}n',{+mr*v~$'3]iB}]2OzTHZs*Ijl1}o=B
    _*E1K6,BoWB^Z~}'@u<U*Z9[k;s}F#<\uj_m,KHQ_?IrTISQ=z+k_vHsUn\0pu,p'CZ1n_nIO2[H
    T-T]TjKv_BYE%VR+kV7p~T}-21e!Wp21}*U\_3{@Q{w-wIz#I*7zODrQ[UT!K_fjzlphTvo\pW$=
    eOOao"[_B7]@n}BTzEtwIxXz1<s^Wux8xaA#dB}wU5]2!qmwJDww1k}j_AnA7eK552z{!XJ_r$sC
    A>$?H\.VauCfE-AI9}-eu5Gv2O5VGa1'wDpV~Z<U35BdMvO,w-+u2(A5]Ux?m$JA^E^xV^NHnR5=
    5KCnr<k^}<zUrZ3[r{+<,w@-,-~^B+[lea$Y_!\'1DaZYz-u_$H]7^zxB=kB1xT.18u$z!{lAHYu
    ['JaTBt]wDaQz~2ko7??1>knHRTwVwzJOjDECj5?E!a2$3\?eUBvG2}~XW{Z1{3[i~K(0^=-Q_[=
    Vm}$'M^uRmXqwU,D,YUD}#[$3CE}iw=ePOG<_TQ,Ja[7E1E+3xh_~W$#nT<O5$<)-_z$rQ_iOWK7
    HAHC1u[xjP{[#GQH{G3p+'YABn-HnKllY\xm!nCwpYBk-1Q[E}DX7u'Xr\+a@}HA~n5ZIX-CzihU
    [zOYpJvoIk~sv6Vs*]5'->plWBT=sO\CTWTpCeoUVTzfFwDT-?]DmONICEo,AU3=gqBlzepUe+B3
    75X=+_a=rOIekD~17X!}Bm+_?Q-\aC[-j?eer_Jj*!:^E$WHrJW;]aJX^Z}cGsi\|=$]aLmeaUZ.
    {]szT[oaDAa{QX5+l_I*m[Wa>j<QDBBXiH*r%"vRvQ:WnO+$CK{t>CHj=,o2D^;R]\z_ueo$c2=J
    'WH2Uo,AW6gVGDKp~B^Zxmr<_I^eu=}v{a$zCreoGn@@A1'QZ1@@VO1'I<+WBxs(e@A_Fza\Y]Bj
    {!VY3xvC2^*k^=j^'G,maK5V?hUDp]@Hjmv}-jqeVnRRR[-J]Z}-]HKJ-9SuTK#O5j[#YzYT*;5a
    IT_"~OEVY\7oUI1Upei'_IZ@jJRG?Xlnx3Hk=-enlv2D7Z-rmjr[<5Qp]{m5U=xU-]?eBj2sr3jn
    g7;*2/YA;mw.*z1Z%Hjp{=XWam9UY#[Y*nAaAou#w_1m}C78{EpBYiE<ACV<?OYRoo2[pypI!^Kj
    pnHEi<&/z{D+I@+,WV+u!s[7',xO<_';vJa+Bw2lsI+C'GX3?C$7>,weHGz[;'2k#';u1{Tu>T-z
    [ka-'=Ks!w^jeY}oIqVjTA~.$pv>MLz_G^o^B<=$Avv5+^xO{EYY\>WrW\,;W*2\,R-+j\QxBiMO
    ,X~_^spgKs,$17a~$~D*RD;urj+oZXXRJ5\*aYo7z[\D\K>+;+[JjmOOvQA5H5O@YAu{l-n^wITX
    27zBo7A='we}*R&ezH\=V[R+-+BK<r$XCH*3,_x^troJ~A[#O3A<I~D[Q,=J=Goj$5RW1rK7]o1[
    5;s={/,QV5~QDUH^r0,3KO\zuR{XA<lE,'r]j!mw$w~<Y3|U*v[eDWU@*BQp@$vn*nl3HCx25pD]
    pU]zzzp+YzW>$n21>rjv>GVpKD>''=JnX2]V#jDu'Q5xH^^6AIrs;BE?m>e;rV3lYmR@DI;$EXX;
    =x*5U\+o\X<exJ5e$_<~xpwvf$5*G_+oVoTp2V'7kx5nle}\i%Q?<m2}*Z>*?R7$t6>[^_wA^~9m
    O7kEm$1*Bu+}-1HFOj+-v;HIx#DrHI5]kI\Be#Ga{[inKxa^-hlln_<H+3TvipV>\^Bxj](6}{>k
    rskoXo*_k'e'q}^1H=[2,BR{lAl<ooixo3<1B*OO!-C-k;+BaH}<ne6ooI#9x<o-pOA},z;;O@T@
    UG}uvYn3roa}I{-vwla7wTl~x2Zz=JXR3o=@~l]VD@I_zej;jHpX{]'2XO75f<==-2XvkQ/''jIj
    C[ni]_'Y5mHenZ7zJlv1pxjXXCj)GYZIu^AY<<<Ci-xHCW;>qsQk{?Tu{)$x@kY5OEZwr!BDW*!D
    DIO[FBKn^>pi-^W-#%TO[IY'-j,*lA[aswTE55&[\sz_p-7Q1r{rA7XVC$A@n]B~E2=DQO^j1:/M
    Q;OR^;>}l7m2jY2_}EEITEs7SpLu,K3-DCO][o2IW,m1>3exHW\KH-uaGu<(]aAQ_vxZ9_K2\=#+
    $;p[!r=onQ3eErrV'ACZ$+aDu|}soAGE5vlV+W*zI^!'w7$v*>nQ\^DL\^ORVa]EB7Ae7n7X~IeV
    CW<G31zUp!sV3l\W@rrj{TRJVR]<TEkU}ojpG,i1?H^O{$-]o.QWX+~Y<YZHV\T|iH1vy1Ik@Te[
    Us@{JV'am'1uaL_j*]eQsYRmw2xji3$<};WODE,^O1OwVxWzJ;1337>]OGGsUj+n+3,JoJ<][nC<
    QknlJ?ZsW*1KYZV'#]>--OF1C\Hij'5UED-J[DHY<a}a-l<^'77V~5Tl/RDW3Z\}GO\avj[Kev<X
    Y#<~UV!-W!UW?I3YxEs-B'mV7o-l}'BlHM1,=n$mKmjBm<2,_+K-eEqaRZUtn=7U7@'UHTDZQROn
    1!wI&^BzV'JepT7?]9J_][~*Eil;,,-7AD,=+nIQW{lo\BGXa^#\7>,>7VC>@><a;<=p>IGlY?(1
    AZnK_Q_UGY-aTvB47'<vIBWm<G3=w=u;L$n2WEe-!2Y~'EF+p'@gO,U[xiG53+D@h
`endprotected
endmodule // module vusb_hs_portctrl_utmi

