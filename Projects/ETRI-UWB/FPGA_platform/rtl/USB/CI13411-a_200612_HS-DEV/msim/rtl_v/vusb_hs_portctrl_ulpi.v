/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_portctrl_ulpi.vhdl
-- Date Created: Thu Dec 21 22:42:13 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_portctrl_ulpi.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Vusb_Hs ULPI characterization logic
//       This file contains the logic to translate the omni phy
//       interface to the ULPI interface.
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
//  $Date: 2006-05-16 17:13:13 +0100 (Tue, 16 May 2006) $                                                                       
//  $Revision: 58 $                                                                   
module vusb_hs_portctrl_ulpi (xcvr_clk,
   xcvr_rst,
   xcvr_rst_a,
   xcvr_porst,
   xcvr_porst_a,
   pwrctl_suspend_clr,
   pwrctl_wakeup,
   up_ulpi_wakeup,
   xcvr_pwrctl_suspend_clr,
   xcvr_pwrctl_wakeup,
   xcvr_ophy_data_pulse,
   xcvr_ophy_disable_bs,
   xcvr_ophy_hostmode,
   xcvr_ophy_phy_sel,
   xcvr_ophy_port_speed,
   xcvr_ophy_port_state,
   xcvr_ophy_ser_sel,
   xcvr_ophy_sess_valid,
   xcvr_ophy_test,
   xcvr_ophy_tx_data,
   xcvr_ophy_tx_lowspeed,
   xcvr_ophy_tx_valid,
   xcvr_ophy_tx_valid_last,
   xcvr_ophy_suspend,
   xcvr_ophy_phy_reset,
   ulpi_xcvr_ophy_clk_valid,
   ulpi_xcvr_ophy_disconnect,
   ulpi_xcvr_ophy_linestate,
   ulpi_xcvr_ophy_rx_data,
   ulpi_xcvr_ophy_rx_err,
   ulpi_xcvr_ophy_rx_valid,
   ulpi_xcvr_ophy_tx_ready,
   ulpi_xcvr_ophy_tx_done,
   ulpi_xcvr_ophy_bto,
   ulpi_up_addr,
   ulpi_up_cmd_tog,
   ulpi_up_datawr,
   ulpi_up_rd0wr1,
   ulpi_up_wakeup,
   ulpi_up_cmd_handshake,
   ulpi_up_datard,
   ulpi_up_sync_state,
   ulpi_up_wakeup_handshake,
   ulpi_chrgvbus,
   ulpi_dischrgvbus,
   ulpi_drvvbus,
   ulpi_idpullup,
   ulpi_avalid,
   ulpi_bvalid,
   ulpi_iddig,
   ulpi_sessend,
   ulpi_vbusvalid,
   ulpi_dir,
   ulpi_nxt,
   ulpi_rx_data,
   ulpi_carkit,
   ulpi_enable,
   ulpi_serial,
   ulpi_stp,
   ulpi_tx_data,
   ulpi_tx_data_nxt,
   ulpi_tx_data_oe,
   ulpi_pwrctl_suspend);

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   xcvr_clk; 
input   xcvr_rst; 
input   xcvr_rst_a; 
input   xcvr_porst; 
input   xcvr_porst_a; 
input   pwrctl_suspend_clr; //  1 for wakeup from low power (from up_int)
input   pwrctl_wakeup; //  1 for waveup form low power (from pin)
input   up_ulpi_wakeup; //  1 for wakeup from low power/serial state (from up_int)
input   xcvr_pwrctl_suspend_clr; //  same as pwrctl_suspend_clr except synch. to xcvr_clk
input   xcvr_pwrctl_wakeup; //  same as pwrctl_wakeup except synch. to xcvr_clk
input   xcvr_ophy_data_pulse; //  initiate data pulsing
input   xcvr_ophy_disable_bs; //  disable bit stuffing 
input   xcvr_ophy_hostmode; //  host mode enable
input   [1:0] xcvr_ophy_phy_sel; //  characterization logic enable
input   [1:0] xcvr_ophy_port_speed; //  indication of port speed
input   [3:0] xcvr_ophy_port_state; //  used to decode control in phy char blocks
input   xcvr_ophy_ser_sel; //  characterization should select serial for FS/LS
input   xcvr_ophy_sess_valid; //  session is valid (used in device to disable pull-up)
input   [3:0] xcvr_ophy_test; //  enable test mode
input   [15:0] xcvr_ophy_tx_data; //  tx data
input   xcvr_ophy_tx_lowspeed; //  trasmit Low Speed
input   [1:0] xcvr_ophy_tx_valid; //  tx packet framing
input   xcvr_ophy_tx_valid_last; 
input   xcvr_ophy_suspend; //  1 will put phy into low power
input   xcvr_ophy_phy_reset; 
output   ulpi_xcvr_ophy_clk_valid; //  30mhz enable
output   ulpi_xcvr_ophy_disconnect; //  output to indicated HS disconnect
output   [1:0] ulpi_xcvr_ophy_linestate; //  linestate
output   [15:0] ulpi_xcvr_ophy_rx_data; //  rx data
output   ulpi_xcvr_ophy_rx_err; //  rx bit stuff error
output   [2:0] ulpi_xcvr_ophy_rx_valid; //  3 bit rx valid state (as defined in vusb_hs_pkg)
output   ulpi_xcvr_ophy_tx_ready; //  tx flow control (no path from pin nxt)
output   ulpi_xcvr_ophy_tx_done; //  
output   ulpi_xcvr_ophy_bto; // 
input   [7:0] ulpi_up_addr; //  8 bit address (local controller determines if extended addressing)
input   ulpi_up_cmd_tog; //  toggle causes operation to begin
input   [7:0] ulpi_up_datawr; //  write data (will be stable before cmd_tog reaches block)
input   ulpi_up_rd0wr1; //  when 0 - read; when 1 write operation
input   ulpi_up_wakeup; //  same as up_ulpi_wakeup execpt synchronous to xcvr_clk
output   ulpi_up_cmd_handshake; //  handshake to cmd (return data must be valid before handshake toggle)
output   [7:0] ulpi_up_datard; //  return data 
output   ulpi_up_sync_state; //  ulpi is in serial/carkit/suspend and can not take parallel command
output   ulpi_up_wakeup_handshake; //  wakeup acknowledge; set to 1 after wakeup completes and keep 1 until wakeup input is 0
input   ulpi_chrgvbus; 
input   ulpi_dischrgvbus; 
input   ulpi_drvvbus; 
input   ulpi_idpullup; 
output   ulpi_avalid; 
output   ulpi_bvalid; 
output   ulpi_iddig; 
output   ulpi_sessend; 
output   ulpi_vbusvalid; 
input   ulpi_dir; 
input   ulpi_nxt; 
input   [7:0] ulpi_rx_data; 
output   ulpi_carkit; //  decode for a carkit mux
output   ulpi_enable; //  ulpi phy is enabled
output   ulpi_serial; //  ulpi phy is using serial mode
output   ulpi_stp; 
output   [7:0] ulpi_tx_data; 
output   [7:0] ulpi_tx_data_nxt; 
output   [7:0] ulpi_tx_data_oe; 
output   ulpi_pwrctl_suspend; 
`protected

    MTI!#o_G-#*n}${x~EoXCjC@3}mITWDnp(VUY[Ci=-Fi|ba*CB$QJ[tKs+nRimZ\'k$.NJpKst.D
    T;*h=e^z2}p-oL3sBi-slz}:-l>?Rx7Deeva$R{zT$@lT*Vhi[7K.{5^nFrRl{cE-]e9_DA\iX,[
    !vA-Y_;~Vi\+OxYjeYZn1JD[6e[-{x*AjK{^ZApT\0hCmB\va+xG$iI,_A{|>{VDAYnj&m$'2BVu
    $<}n^7=w-r!}<,=;HB2jOYOz{G2W,x\r'Zzs;W[A=CL!7o3jWBXE?p@aC3'aRr~i-Yp5zG*<$>e#
    5Tf&ms-$blC3G(^x'C~TYJf;z,!'({][Y<+(Cj'QFgl]>Ov;UQ|!S>v-ueVx$~1Z-m<-Q;j5mZVV
    u%?x{KnDKT7w]wXoKnlAT^05wU~wjCZ:7x11~<H2o[<Y}*@w*aT>3YeUQxMD?R?ZAjk{.Fw'!r$^
    YB.D+;r{av]FGvjvY+$;{aC;uGoT]]#nZD@I7>Xm3BQoDkzI6xYOz]wz!8\l5wL|eCwAY>zeo0?o
    zGAV;[/"*'so]\7Jir{$$xw^EvGs[$[\1+Hp|[iuU6{Y;ujeXe5iAplpmO~TV[.x#~OGC-_]v{5u
    xlR<.j-U$}+nJ$FvxK;%0^KmssQ#OOzBpmI>-_w4suIW'^znGOiKRrp=a'pCzQHxDsIJ0>rD$r]3
    7Q~V1r^u]E1xrisau}CmkiQ=_<+zr~$\BUXuY}H<an$Kmw'Op;T_;ko<@)v<m7$jlHe5GshC{\iu
    jG5f}Ba*<Hj<s@R^_!Uo0-{*_uHEnLC_VOar[HsYZRKw}ib1Jaln}o$v+<1g6(;<0HrUD'Qp@Y1e
    C6B35Z3zQ{kX*ELOupTlX>;']7BKaUu&+QE#]KjvV={e=vBV]Zj[,*Zkl7A-]CxG_2r[xQH?e<6J
    Q!sG\JJeE}BjZ{>7=VE<Om]<\$;=@EAi6~aUa^Zl];UGi~oi[IWOY~+m>}QU;VDnZ{{x52r|x@*_
    "=-AV47[-]F4<[ixp<Xj'KXTDwDe=2rmZsXmp\$n\2]JNdxp\OiIOTvUm]XoYp5Dz[mY]#-e!~[*
    23jAY]k7oV&*'{OA<-DsK]jYBDpl#}HJE_uR2;ks<ej*x#@v+5,2{ZT53}T1<=MlsEREA'?TO2_}
    :w_?zH]W2$*57)V[U]r5X+W(s;'@,[*2}3{!GY'~k_[W\vsrY{\Os@L|jo[V^oju>[Q_XO,#zY_~
    Xa71eIAXG*<;'rQn~.y*v#mYZJDT}5a_Uzpj@ok~UGn3H'm7~W\3R[xEBTYHoU<WDX!iVZs2[X~z
    7#Rj<[#3Hl=2]TCE@3#';nn7I,ApazY\DaOj27\=?*W:#=X@QBw!~V~~,'evBCCZH$xG]'pJYZC1
    xwxo7=K'kE]CTQKA@EY@lxsR1*Al[ZlZ/[j\@8NRN$@rG4v;;RoO,3p5Jk~Rr7!su\V1!5-*3~va
    x<?,}xz,Z7!,K@\CImj*{\(c^M6-GalC=+l=,zlQrx{oJX7v2aa:Na+T!lT{m${nv5)wxa31YO^l
    z'#B\Xm>'Zl2wQ<&~Y_AHG{~{UZu3X-a4UY@3ij<@I8vCZ5#\H2d,K{^E!sO}G}Io'klks<5Cs3u
    E,e@CQ[Q^UVvf$H3lHw!l<r<?S1-['AH=l[KJ?-HE<$-EmrO$J*2WOr'!Y-_3B^jV?[5#Qj,<R'r
    zaFp?2H;'xw{,?K_,~A^t,25DBHsl*>aVOp>[sJvJw+WIswp5^~$C5}U1q@[<p'rZKfADwZR\a{k
    ^>=!EV-'^xZfep2u,{VQ^+'J~rY<@]GuaeQ2#{^rk^?VvCjO[EI5Esr[pICswG?+*W^!lAD_Kp<T
    uG_1DkWV_1m{^U!1A57x-e5!o_nv|x>+U6}>;|$K<w/]sYAr)-VEv*-]5;jXE]?m^rz}V^alu!YQ
    @H=W~n+KX6>5GZB~<\Qk=CGKOx#GYn/-H_nUQr_eXxYD52#s@$WDT_[n8\I\erQ}rG]A3~Oj^CAB
    E{Y-DE2Z[GI'_DB]j7E=EzzO3H][{7*rmr[}sI'pqpCn_mYXe\K~Qb}A;vpwB~;sl'W=,CG2n^+5
    \E[r]a$BU#B[w5~asnUOKYGRVJS-=n7v-[k^3_i(eDC7=Ci^lj3}7G3Z51x<*QAICI,*<s_xQiZ@
    u>><}<p-l5kTxe-WsE[O*Gu}^fn]\}$B#7$,pE=izJ'r=v^eY}/K,HB<'Dkr*I*W[TuzTUs+{uUE
    <Ir691O2Dgtei=]GkETEXsAC1ADAoI}GC5CZ=r^5<o'j*@]f212v'Uw!=@JltCzVv#Dns7@<u'w5
    JNm6xowem-'>(W^T]Jee7~zU\@U{YG{2}^@vi@,De/BDwXu,;5[*^?pk*R,a$=g=mXZnT>^(W1;1
    <HCO[B5ayM#n}Jd7\Tk';_UT}!xV73~[]W]En];HnpZlpGYLWoT$l!DK}$DE5YkzeJA~$R_G.*;v
    ]TsA[o\IO~-U<I9S1n'w9&'VN_l3#T=Em_kJ{Y!W$;r\XT}5ILKC=s_'u?n^RZu\C\*A~YaH71Ma
    'DXT1u1EG5!12W[krZ=}z$"CH<R%z~>#OUK<'YO#jIu1n^Y<+a2Yx]1;]-Jr5oq^+jk3+B#zzU$J
    vp*Y+v>elAnz'7]6\[jwxHB*Cm3-2]K=~1WZA53xA}uU+e<VQuD5j=IOaT_5ie]r[pKm]O\1R~rR
    5_ux@\QrRTH]E_k;:rT^QfWY<p4DaBm$pm-lWJolZ~[E5G-,0bR]O3[z}kGj,Ye22#EJW[!\E+sT
    Z\7**1J7j$zVTT{-7Za{X-@1^E*lY7[]j3!=<!*EETl+2@{ER'I^TI-DD^:w7~aJEJej>!~oSsC$
    oV+zwoO$e/=Du[1{<-C_KZIka]7O>Xvl-=oV?oDX;JRieGVCzi|<v]^zVRjs<;--s$]Ao?Kb,UQT
    5!7l<H[B*+R^ar{-qvE$I![_*YBkj]qK5j[bYvV*D3H\K_OGGueHj,nRmU^,OjxlX\vTIQZW5X-@
    CJ7^a'KwCzUn1>TnDps}oo\u#};zVWTHl2QE[wX=R!QXLB\7#voY2X]rREjA@Cu=#5ma$TOkD2B!
    Y[QE@]X-lLs>-XIWvU0^km}b!'m1C~x}zBKR[uwjj?GIB27U_,[p=eu#l:#XopH[=@p[l=R>[jIp
    TCg],'{^p5]=Uj;Eo-ezl*Xpv'JCE=ps<-*4U\*!{lTv"*KjTQ2A7\x*!+<~q7<-GzzuuEWw[kDQ
    !p<HRA[ovdiDoZ2}Ru6j+V#\H{5QI5WArv+m}aK5W<mrP(u^YR,ElG^-J\!OKz5~B's'+,e;GrC*
    ;BE$o\'O{5{'aQ;'GZKGTx\8\YD[aeO~ZrVGr,w51{TYjXI@a},w:}zD;trQvsQw>YjaJET-_BoF
    1-!Zmz_ac==Cvb~{VU#D7xr2uo^alsNK>D-DTwD[=lejIG;O]xuQmQ}e*-Jl2[J;TV@-n2mj=I?Y
    #[1tBVT!ZvA$Bv@*cBET{b_t+C2-[oV@]#E^"#svG<_@#uDz^?+=GYQiBDW}K]@E'Rn~j~s=^Ir]
    z+Vkmp+$r][!n&?sRx=B{lV@vQE5H$7}3O|<a-Ke=sG1~E3U'i$\,^2sCEawC=2vD~J[&a{3?!U+
    [oeTrE|3'kn$X5;~T]e?=xCuBx2!UZ2T-O+<j'-%A\<]@nU~,?V$\mEV-YnI1m*,h3Ix>r$I$~>[
    $X+7n[jwYG-3,A5''=u2j[oY}D~!GPOI=WIal;Q{}_\R-A=2v]_V+UG#QW;j*{I\\u(OOHA\A3j-
    QVDs!XQX-5ieTUDKCoE_JH^Wxp~{Y3$1!~u2lx#U_]OCk,U1a$5$Y#^E"r3{Euj?U5=}T*+3@rIY
    VZO>=ex=}3s\ln$E];}IT#}I<{V?l#U@="Ur,7ma.[A5##QD}Fv|:lR]kBu5<iIR=JQmRhKGuI>C
    QO~-Z<0e'~T+x~~QWC<}aW!mzp-o$lDG'iY|Oal5oZ}2ZQK7IU3uxiva*H~1!>eJ<O+s?U;mKQ^O
    *{!uX*V@}~WQv'V[xD-,0V#{a@V7l8EIe]c\G~w]wzo$?xWY5C3=_R33UaDBWOn5U@vs}?rz+=ZD
    dQ2GuH1ZTB2\XMYBsCQe>35ZnGeH7J5\Y]~<1~5pkIZ^Ri^[,AJBk,,T1i)7!5in1+Vz6?-Yo)$l
    '=UO=e=U<1Q_m3r'o1j#IH#pHuTIX-,z(Ql=s]p?x;XUeEY*~w*zxWII3=J@[5lr#N~nns!7BvF}
    jJ#_7YEZCn+V1,A\G^I!5-mTYTJrE*sJ{;BjO<ODV\mIo2}7WAxz'HZ>Iv$xUA@XaAOZD\J8^_5_
    |$Ip{x]wGGCKU[}w\wTe2JI=-$JCUP97zvJ>Vwu*:]Oka&y>+vX)X\}-PU[rQjZU[R$__OGX?v}1
    ]A7BICr@\.D,Es?{A}VrmQ'apI$.C'WQNHAT#'YUaDiw_wlG]ZX<Tv\#JCXY>W[#[RxalXI}'OiZ
    HXN)#HnZ/OoWm*OmXs>v_^$YK_woV"O'??\JnXom+lY_l3*a1z>*B?Ij{zX{\EI-Ql}J'RA[mTz<
    Iwq}i!5w}?35_owRlei{=vstCzD?F7ji.AVVJf.EjA2IE@[2Ej}bIpZ,Yn27}[zX*Q{p5uJCGW!}
    G^akQk!zrO3$YrE_aE?]YARC[~qv_<5llBQmHxRtn'B-Gu\IO-!nE$U<UoB#^mu{@RZET}e<e-3V
    u,mKpz's<$?<<lQG]d<&J7>]iVu,3^]]rD3E}|Qa^Kw_mHHDiXl>Hx77\@:Y7!KIn7^$HCn7drxH
    m)VVAE~>[H,jizl$l}BAQQ/C{HT>EB'zW1nJEROUsECn\\K^?Q#Ny15Q5T^7U0!=#3!$2?Ciru[W
    31AA+]CX!Yo{u$'\x@BKOa{'3@}?W+TQ\ZV+Aa3{I3*ZG3XTBYD5u18DK3UzVlB+z!HC3J^#=53<
    1Wn;$UBu[*J#emTrl!Kus#A~,mHn}oE1GV<sQeUBCY7+jiwjsr?F7U*s-]=mBJ2ZXjC>7TY^X^Ee
    7G#VI5#mR73@~E[X2A$o^xOl3U^}}aUkliB\pTYCC;G-T5Upu\ToNH<<e"[AQTIn;WD\sK2QVv1W
    j^:~zp;R-!uD?ouHlAZ~|.Jw_:rY<;!EI[p;@ERVY\ao{O5Jw7u*3kQZV;#lKvO5?YuzllqGeplE
    p]ej'i':$B{uWsk{8-B=uUC=$ArZI2XRk;[E{d\XH'KezuCn'D<>[w[QD>$Hwj>nK3-VxK)ok_{j
    _+EzlR1,m,}kD-}Bgw'VII3@wm]*DlC3^E>$=s2\C{{n=sonEmRakDnK53Asn'A\TrdmluHe,TW&
    s$uYUl[z5@&pOJ^-AWsy1jKWG]}l=@Bi{GV'P$pe~OZ3_E8&;+5~!r~zY5}w=2mz'X\^5r,U\u;_
    l#[+lEiCxw,*O>u\jBDR|*5*$H7#p"GQ@eWG;<8irXm3Q+lp?_Y{,AQKnRe]s;>5nY*TrTGB^7~#
    1~uUra~/vUwV_Am,WlK3$vunL03-HrOB++eZm'@Rw!w{@{>w==<_Bx+E^jPpJUGcX7T+Q7'sQ_vl
    V_HYI>TYY!U]Rr5UI-~G6fQ1uJ9B~E\a++^Kl?uv?p-p>eW!5k+<D^,!$k{znAOD72~I>sT:^G@{
    s!}W/YIK~xBVYiG_GdWjFE3$a*_<or3[Cp3=>B;!J}UrKfbR~>\wD[Z5w,G*W_rE-XsR{}^Dj$CG
    JA5$JHo*'}2>X]rAA]In}XX>R[$R^,@Z5j$p5jo='=uEjR#;-N@TTn;'32C-V{Lt%$w*Zvv5wLl2
    ^$u-\ZUjxD>l>KmpeG5a$V^i}\x[}5'Ja>J|Vln!C?2j3xj7$z$lEnr^nG}kIG{XK^WX_DJ,@{Ir
    Ewx'ma{@xB@HH]i{=7Z'KXU#uz!HD!}U2o!o^u-D=9l31orEj,'=n2V71?j51G8B{wpAL~RH*Aok
    I}Fsxl['W~!rD}vX[B{z=G[ET*e.eYkevs[G}$\;RYWaE'vR0qotB_BR,5ECiv=~d^}*@b+TR-r_
    s=Y)+5j!z;1=E>{><]mHD$7+!vrB)yYe$O6Yr2}W\YOC!z<I,K!wx[-pk<'Y+DAm=Z=5t[K<[|?T
    zGGqVZvwHQx1}?nYkoK=C~XjU[!@vCEYUVCAxiZvW,@VE[-5]k{l-EEHp7m]lpTDoRB=}ZC^hSv~
    JuUX'_L'!uJMHXX=^I?+OB\{vuH}sa-e$U^o\ZmeFHjY+Dz+Bm_?v1;ClOuBRx52B\OJo*DB^E*o
    T$u_UxYTe}E;o@p,p3a@TsWVW1o[D1mHQ]GiTxJE[[OB;b>*jW#j_R[#pUR;G^q7W=vGX>eX$H^[
    A;]on'7wXQlBI'$UjGxh@5X_luUVJYuvzD,G3oW$1m'jUxv5D\Ia$C2jH5@a!n7w1A3\V#$AR32v
    ,a_B%7pk;r7?Z@_}$i8E_]UlO'I}OHTD*Jo_$7G\{Hs+E^jU_VnOaOeXh7mm*A1-=r#VTa<z*#I#
    JEx$IkBnvfD73X2_Ja}m=r-nrwH'$uKz!JnleuwrGQvpW-H<nDo=]kTp_RTTjp_T>k:xp}Hl-I>x
    KRmxRGx]5?O8[p{<5D'E_Q}$(MlU}Eo[D?j[lau$V\7Vwm#+J]T+x{CWU>=#,-a}xE',{\V'YR8*
    >+5xaBA[=[T@]vAC@OGAQ<TQQ5!/XY{a;wli;TR@lw+*;YCIR+^KE5w=#NaG*jB}wxUsG-EBuvsW
    E-C\1np$YkBGzR'C#-*3AQzjQ<[ZO=<D{u[BHX/dHGCo~o1vjnTw@sGQY'>v\zB{t,Z+Iro[D59@
    H*ooq>]H<\;u[!C]k;|}xK\ZCXxTXZreYj7iRKkBZJ]3]?G='aeHHDsQo<m~x{pN}a'V]YpHmp!o
    _X1k>EDAk_X-DViz^VknC!{Q9Aq'?A}S<z;;{A[r^nI<J*W+DHo;}CvWC;eeEeO]L~>To=wTu.Da
    lI\#\UlpzXp['wVZZ!+,$2=T]^z]Jmnow-I{U]0~13A^{x$U'5[<[TG9Xj]YwpT?v'+kuv3mgS!{
    w5PosTIAU5>)+e@j]u>+l5paHVBi,Ce{$2!Gj~aC^O;1l-WQTXa;k$i3PnsDmw[ViX]DC5{~Q=_*
    s'p}l&},_DSXB{wYnDpw>V}ml<IR]><cp'>r}VzWxOI@luZW=Rm;Vm$]*wzrnD7lmp15cIiHE5^[
    _lvi<~e.s!DXJU@H\ioZG$$'BqE]il=+or[1#s5I2QjCXW*3T@jr-j}rsurgpK7z\1}~Y-@]2<*;
    $\R]Jo7VXTDT'OkjC@Zo?7HeQ$np-=_BR5VvGN)ls^ZECTrrs'7?{jo?l>GAx^z0DA!5HYnU\X5W
    iSC'H$B{V-7suo:CGa@];!A1AED}*'GG;WE[PeX~pZsiQ1oVD@<~<X>l3uUKH$<+v{zD7+[2~-oa
    H]*\igiRe1:=5We=~umSQ[mjT^7krjH!{TCwqao!,C>wXy'~>1RK_3m,E<JQI\,}uIz@O\\5\x2s
    \ETpkG<VO-V=Io<H$EyQ?_?pr7+]weQ:9kp<=gV\vKV?W2VXRxQTXHeWWsyTw[ru}*$Rpp29DiX*
    Qol*s$TVI5Y$~>G{OjKw-^Eif#*U~G>B!2Y+!2{U2RED$EX[uC5Ap77XR#e]@$AwjsHmQU[JJu7X
    UaEY-i\XT<BlZr<G2p2@lQRO3:C+>?v5wJm\zRBu7[RJDaR}-]kA~?oDAu]eJsu}l{X,Q#y~={U;
    E$#X<p=2vxrQi,WY5nEr_Z]o27~XGou>R2U<EO3D$5s,Tj##nzu@8X=VlB]JT723x#l-Ev_-k,Cu
    ~pQ5H^aK#nA\,[n5@b9JlT2R}z=#I,RPmDOl0NBB5J8$1*2Y2IoZA@pp9=;xRR\mA/y${YXAoK\B
    Vm$C*7-K$O=~vXj<},JX7e2ojXx#]QKRmC1bO=VwC2[\=Z@<^oOHDC^$~pQBV'Hep;-oeTEo^<m3
    EzQY25!1Y15_zxxxu>xvyQj}]WX5#^}d7;u@]5oJp1~[K'@V^GO^x?I1ire{mNz2aGE,EV',wIsD
    zpHv~G~X~e%.p+1;}6Vr'+-EHX=}5Ia{E>;wYol5AvCe}VPE_Hez&[o]V>jT-xHW3TR>?HT]'-{u
    nmU-#QWV[{EXmWUQw'X'xB*#@>,p3l,173=Re_mH@\~'ZY-Y^B$U5JjpC;T+uq:=13*5e$Xm}#<#
    A><sRUWoAZpQGXGpJ=m{IUmGX>2.U{HD,_uv{5#,*=127W5W*zAmo$p[nVjaTR=+$1Ok'5A~Vz@A
    >}Qxrx3;=?$JU$~'jB7[BmQ-J7e};-AwvDYi}!s!RD$z0]?Ype^[T1O=o1eVYIB2*3oGD~>n$Z7^
    aK'X=lIEBJ^E!^3Hz$,@[r1vz[v1WjJGRIE+R;]Ywn=1k1VxK4}eGA{R*!WAE^[j-s7iVz$Ann'<
    os-,OE^pc_~T,f<Q}=*W=Ww<Hv*5Zj;o]7X,_@^x\=YD*Tz-nTVvZwBz;KR<![n_l!6D$k]Q@H{o
    ?3_^^G^@_Z=-Hx$l^!O5OXU^iW${p{erZZu3]U,}Ar^TR^Cgv^wXB'*mebuAWG,+Kp$[A\ZG+RUD
    D@GDj$TjXmaV7$w|LCn]HBAIV|:zwCw>}I@k<^i^EWOB#*{G5a2x}uwOisw{q2>*oQKeA$Z]Te}[
    \CrD23C@2wG{?}]<1i=_nIUZ3[BTj+U;?7i=i9{$?;s-I?'apw.vK1+C@sA[^mr#zoG|-ne;IVwV
    #7zB)r3Jwr2_Kv1,ObxlERmX5oH+a!fxGnTQE_osA7H@}A5]BBi}Tp~'HD,k7sT_]so.{x@}B1B!
    XlB_{YWK,I=$'[[w]]>jVKvVEnHGeXul-B7B?]jA~$A3ODoEuRV-x-vanQ@]}O!Ym_,2n5'HTUAO
    Sl^$}>{nsxlx^eRu[,^Tmo==X&I{vnr;p$K1\CIlupWC]lzO{kBEO'4p?-$b2Y7lRXex=3YY*]KU
    s^{H!j~sK1vV'O'i7O@-RH5JIAQrR!pX>__]#liD[U1,BI}?,Q*!OwWWe];\j~e3eYOeYAriQ5k[
    ;rwG.<[TEG@C2rB{Xr'A2\k*>WB+*_-l5[;}Vk*O;@IG;_3RV;T!;Z*QUOv?ELusj{'D15V[ls~e
    D}v3leHHJaEvr{L;z@X,Oe]f7apa7j#jw7^+@TsI+XV]vAGBnRQk#^i!^Ql;il@pZ^=[{=W-=A2J
    tXsYGl}3!y]'!jlViJAR,kllan]=U$f[R3ZDVJj*A$E}v>YRXu@!\EiQ+vsW[n]Dx#QR{YQOR\@z
    {emdKsxsmT~;CwXayQiu}i_rwwajZ]5'zX}o1;}1\!zYC{_,$:r<w3^1x'Av<}^jKr$+W[vC=A|>
    lE[lax\8<^*Em]W2v^UY?[in;p}v!wZ{$TUGD2w5;{eTQu,,-Q!WGH3o#]aR5.~DXK>s<sQ<j,m7
    Y16~r[vpO-B,[KTz}~pBw,#,}wEIQ+~zJ+336Uael[U[T@1Wje<7GHsWQz@Tn@t@w'oGo~n5KCQv
    @_p=j'Xl$WC=zuHnYnr;]o_2HB#2H1C|QZl\I-Qo!Sm=D*1nV1:zD}BvM;<\'Sma^I3]pC^i'HlG
    k!j9x^}uQ!V5U+_sjp-#wXv]@[>E.wG7AY{*T?j[p!CK5<^xCX]<H1=3uEv'T]][J-UmQ!nxERgk
    $l!Qr_Wz!Xk[L{L*_H?#sjjevkBzE@7:,O[mEQ[Opz7nuA2pEYJu;H]>j@zXrw[Ris{HnBV'M}wT
    ZE57ol[GOxD,[pu2A]E>1I3Wko~a-p1j=@Ij>H_7YiR112v}QW=->uDp[~[Uxsr1'wQ,'/J**='D
    YBUYp+qloBDwV?mCBTEsxR2@$al*s]ITl^,s$E$#T+C#s>w>aU@TUOi\O3*<{lRCC,1TXVpoxmGR
    aJ@NzD3nyz#reV$[\*D+>%${rjxVTW%{_!<.^[I=7w$>u{ZHr,Clvrp@5uJ*a,RY7EGQC!vI5[O~
    Y!}[X{Rx@1E!I]m]7XIre#;{xUaUZ\Q^%@sv'~AnWC7]r5aE]CK;'kUJxY$;I7*YAxnErImYp(7U
    5Yo=;Cp_]oD5$#F<l[=oWYp}p\?awz]B_!3i^U,D+j=U=o^#--COvWv3Guj)H$IO_m$]71Z?J>\B
    OvmGo~;,P\-GXC7$$Z*~\{[uUO>au]AeUB_-27mp<Oi1!]UYD2w5D?$aWkv=IA{<<NpYAOue?ZK}
    -jepx15{x~%[Bu7Q~{}WUjXHY@5Bj^]JDT12w7DRUn+y@1{K;lw2#wTD{-YjnrQz^#Um{}_IIU[7
    ~{UpqB~2W$kv'Qm5l*p#Bal!e~lsRmAHVl;@Hq^3zGQW^Ys'^D_HAo=\v?jUjD3+{IB31>pl;2gx
    Kp3avD^RTWxi|h$eOHXw\DRD#\Bi<#3=Bv-_~A{a,rKexp\AliDKInB.W>sZ\rWT/S^Q^],AmCz5
    _WZDrD;e!2lpK1\{OXB+[R]**$,x'jzCZYe;W-D2BrisQTVvo+\1sw5]Ak*GV-+w+'4Y*m+v'}5~
    E-W{,We5HC_,uR$?}+Q$1'Hvv1+tZz?e*!;CGx'Q.5>AUY}IA<[--.G';*7sDCpva7kNye}}inRv
    3C4l@2Ve}@_I#]ERRxnCmoXWj^~7)zr=KheT;}yC]3ZJYWnIQJe^!W94zl?131=lPRX\HB1e~[k2
    xG6=JB=VnR[zuDB35U25;*fD?}7A_TCg^C}:,C=z>oZ}a'#,Ps-OJ_~CZx_?C=lJ>jJ{,lqp1CZv
    WXD;qj]^dmt7~]$(Qa3-O1rIRN{},U7~soY5nmr3<l<Iuj#Vvr'U;w*XXWw+sJ$o=nsQssr;>Tp3
    >#G\1QiA7IjTmCW}JT#oZveAvG8[xCA[WauwCG-\23ucv^^Q<}pl^KDU)\L_{~}VzlU'U7,$p]wv
    $R>nAexi{CViBYpeX^J#D=sQW]w1vB>B+^J#$;wQmxIAUY?}p;QK'XejX3rsW-JIa+}l*~J_X-Iw
    Bn^;B{e51^k$szZ_zkGrBBlQXnDO!E\kAz51~};Y_Vwx;>A^HY+7o<T#]Xj>=]mDJU]*SImOH>eI
    EC_;oj~<A:p;rw,_I@jD?'v';<,uZrHBQojG^{Ov<V=$rnzIDi_-X@WvE'k]}!Q?_>l<~$wGo~a'
    e\>X{'eQ=$-]QH>jR^V_r_+'zH5_GXzAI_-ppWl#wOV!H^+'nXD3oZC!'UZ+YX,r?n*R[3z,A@(Y
    U!D^l;oiR2A@l5CMAo1<-XKpDjrQ#jA#j\[CnlxOq$;,Y-x}3}2ja^=>'D#}ja*GBK=zkXvmry5<
    E>n$3,ma]>v!K2Ca-mRaYe,;IxG(Z_\nd2a}QZojY^<;>,\K*~D[@d;DvZ[xHuEG\A]l!OU<Z#}w
    Y;^_mR~v\eV$B5Wo@kARZ;:s!EHi*Uww8UhGprx<D+@4g41vwIp5aWIROX\*IAUDD@5A{[EkB}}r
    Yns5^jG#J^vCn2>C!5<>aDE^j-OpBu75-s]E\DuQrr_'$Z<}]Bs}r;X>ln[KxH(>>\5t^vU{!7Bx
    Qari#7e'(YX4=rRGVA]5eWaVB1EB><$DeQ=J_=vr}p\\SBVa$1'{<{5$!vV7~@}BkGC?WQk@E1iJ
    =5Y^psim+:Wl3k2UB^QHm'-BBBs*i=ATjVE|@w+*csjaY5+j5DQW}}+5O@-KRAnRu<n3e1RuvI[k
    u}W~#R->$m\JX:{U,ZIm<@x7m@ee_A$pU2*skj*=GpWz,Q^xT@p}@mTVD{sA$@p#Oom+UmF'~r\z
    v[mUYOl~$jC<=]UX&7H'-EC'1s2Q_7$r![,,2Q=Y;%Dpm\^>~VA7CznVe{B5'7!BY5_ZXsrs<^V[
    n>-QQn5uJ]X}=A~VG{QZRxEnVw*+G15vJ>'\a['!Ev,TouCM4:V]E^^MUj7uNWpUmsZOane\Osw!
    U1_QGV!']sGB_e>>w|D]op!s!{Gi$zfIe?a$z'J5?lH<Oz?UIp11-<ICTozEl7sHp$^EvAw\=GQl
    1[X3^m~_V^en5Zp2EOpZ-lwJ_]^rUTYi=IvZ*\G^X!IR@\;i+>3VTOH^mosA'uo7\-]T{s2H-BB*
    'xRgKU;]}}WuCzlx1Ho56r;\~OrCAa$D^<A<!e,B5=1@jSRAp-O7~pjZs<CxO$a]--dOeAu'2prv
    seV[]@W,mmpN2'@}oOH[o{I3YZZn|+z^{*J!#-X<[n$$u,ZQk'sTJpBwY(#-QAO{*oQRXapk_uzA
    wC=;vi_@evp'zZ*}G3Enz3GXoK0*BQTUB-D\<V}#,z#R[UV1[-lR1s##O>_QT~>Y\V3-G^]+VWYu
    =Z$3Xe=?vw->YG;,aorJlK-!}!ZH*a>GAo3#]3'<U<;O*l,j{nX}\\2#$<}#^eC!}sK^;vsWs[wa
    pwJz+u$!vX#lW{wVvE>2Y>O<{AA^~OQQ}lRk*=m$elje>CiE3<zeo?kraBC=2!~;,]TB>K^VY+I7
    eks5=G@G_D*LwXA'@n]~[BVn*Ik!m^VrhrGDZiaU^257B]+oU*e*=X,eWo+s[RD<Q5JwZgBw_,K$
    @3mD]isau[cY;O-}W$=[GJvDVH5mHj]sR\}Z7Xax+]Cww,siBvVUnEiI[XJ#*Kj?_wDZ1=jsUorj
    a]?nwjW9]xw*^WQ#jC-O>xl\x5ma,G~n12x!$+m]]3v32URJ_W;zv,;W]*WJewClBI#2{Y^W6Il>
    n%7J1U\7i1-EpJYZQ<_VQ]D;a3P==j'j'nUO@IkBY_~:v*jK)3\oEe~G_SFpmAuEYzRB!VueJQ*V
    5BVF}?Q#lw<]W7z{sOCv\*>5pJ5JEo,x0#rj{,H_;$=aClJ_J+wXra}1Ij}j??*}jkG7$<>}JOm'
    23[Vi]'l5[Q1[!Y{'\HQOBJG5;R}BzJm?$il,JV#JGWw2^vJ>*rIR7x+D_J3?-aOB\-o+?=@7jC!
    p7~1X~]<QAQlGQYD22aYJz[O<WGX~D'vpAO_aj\T]B!z;x,++R-lYja'XskJA<+o?.<Qe75}>3QI
    {sj>u~{>4kB!D];1I>I+z7J]s1V~z>_H7j,o@zy$Xz?p=A<_Bz_7UWYA_r'XYol!1'aHn}Wz87O-
    QBEn+\nT?={A<AlUlsi>*oAA>,T\$f,EmGI=3{$CGV?Ce#-YD}i}2=snZH!QRO_w5Bn_OTpWjz^>
    j~D=pA<,+@lZl@Hwj}}HXponK\*weDs^$a^DT*-[^AZzaV^K+s($mR=5HG'7G~~PeKlii>D}+G\u
    Z,EvXE@2BZM-'$n5^,aA[BR+p<pIJ{*W{^i+jOia^[O!Xv5_]7I;ekGwnY-sR}5*uj2ir@ZA]QGa
    Dww+B!Em,Ri#+*sDj1C~I{=#CVp!O'2ZRlRD>QCr!BlD\kv3-p#jHjDZ}a;a9ws<CY_nW.zQ<1C~
    smU\Cou\;sVHKIT'DYTlwz=HTD3YDGA=5wQs@;)_U,B-en^R~]CbLw^XEtv]=@pE[j'_Q^,D\2[n
    nWO!R@U5'Oy)$R,O[K1w&2VH_In-]ev<v]zp;gvX~$\Ha}TwjWi5TGVT'wDTJmR32>OYrC#AZp/Z
    C]j*7Tz1]XWLKxQBesrEZYOAQ=;5~'>e[A*;l]K53,YY3R^A>Q-ZI=]VuR+5;vUs_E1[TI@31@Co
    xV5r-_EG}s?;k>Wmp675@~j>X;mz1_HRp!enj]?}j;\jD!zlA+5jx1%V{5ms5~evRDl+e3Z(nz}U
    m]D2ZR{pv0DWxn@+v'xXRUUT5v{nCuE3EQBasxsjpC,s3eFrpJm1sDC~[{!nTGHOJDeeRUW1pGWZ
    CHBI?]2}'eXz>[J1AY<Cjj$$*oESP,Y!mR<VpEEkJ*n=T!B?pBsVV>Y53U'XX*w7;JBQ1^]I;wzz
    K5TXja+W-{5!U#>]GxY{*ivrV"&HV^ovV1a@IK[BVxWN<Dk\XR5}|vn{*tWaY<cA^\TrkrpEIiJ1
    ;D{U9M[C3U=n<I1ozr>\jHoYgCHejZTv33IXlU*nrO0}EQAI7}?|@^}WB=XXFmS<>3?;nB;B!,+J
    sH53s]j@V^ed\+KY>5ixc"%l'5[Jna!^zDe1;nzJTWaCJVK]k[w\=5Z'~XADsIB\@aR>j5w,>5^N
    ]o#zjB1!'7O2iIoORX2BM2V'*d._)*}C,~r?YyU^!@RC>@y>AlGi9R+WI5v'-GA,@\zXJDo<3^^#
    Hp7Q~&xG_lrAQa><@vpRVv5A2#g~o?#B_-$^<<=bi_G{'@3pPz\V;p#R5GXx7B!3'DuR\x@[axHo
    e2lB**>x>k={u*5@+VxGRo<[sVHO^5CpGY~l5\-j}}EV~#B3Jr;~m,wEoR1UQT'J*vUmkQOk=+1Q
    ?e2IzI~np]aCr6V!!@mnzJ8jjQp>UOC$ex{I$z^S$E>{G;*AYk$uD!U?iBVvJ<!G3,OJxe<*o[?7
    xpT2.Y+7_AEa[llw{k'o\<]{rg"=rJ^_[E$z-<aRoe-;=wIsWV!0j]Wwlz>*'#-,v5urkj>sBG[]
    jo!1Rc*,koEpO}QUo3aj]'sxvCekG2?57a2au3!|wv^OQ3wA[HWDVs=!+jYl;T>?^_zlQ@jU*?WQ
    'R{@3H_vGw*2uX$HZ<\iD<eCEYT?=nl*?>^7(VG$XnV*Q?<uA!^;?,{Z+W=e@YzYH$KKy@]A@F]w
    3xBE=Z8Y2V}U-=V'y3'uG%=J+n71l52B1AFR-p?#QZB:SIY[pJ71^a>KE'G+x^#>pul1Ui*Ke$X;
    !'r>^uzsRXT![?jXA-=CR:IC;;p-=j\G<*;<QE$sB3aD7zc^#m^BE,Ie{+~'!VV[-mVivwueQkms
    K^rG<A-!}WjTpm{pw-GRZ4?I#=.1U~x=w21#AZ>,#e~\roK(JrK=^^Q~ujk^B!xWA[pO%vZBZpXG
    _(1JT@$^-,4lO;EQYABGt/3e5>.b}$rBU_'j=u@m}ZQ[>A=DvA-z]1@#YKU1suor>=rkH-o~x3,Q
    -xTG@o~e]I->r{<?zR4ACz~uev7suIK=V'sz-,sH=iGAUDOXARBh2C}B\kW--[X#rsv=7^E7zlzj
    C_p~/va}[Rn<Jk\YI|zvB={5xwp$2=1V2$l7V}]uJ#}es\ZCrYh->@="E+!^-Rn[Ii3*8WTbRs#j
    \s}At5E3CW5au^]}G@xVT5,GUuU+]|a}-ar]E2o1?<prlTz?vJ#'VWo<[#&rowukeJn_!WGXoJa,
    A;>P~]Y^i$J!<vj@=;*-mC_WM,;<YJe1o{1_nm7{$kRkHj\x^l<Ews1Qu-n!],zGip~m$<V$[^\s
    5m,QUAs{zP1jl[^,V<vf.0]iVmg\RK\jK}lQQ7@J'3VXOnG}BBTDjT<E!1YvBD^p,Y}}uu=4@rKU
    ^HvVlOQ2PrsjnVmDDjEE^<V,JmnQl0AT7HIi_32[Jjx_pW?CRRGWEeS~Ew<[OoI1@>_]pTzAqR_a
    Ri<*J6RBr;Ka7Te*Kx'$mDh]a>vRC!l{CeXZ]Z@{Toll;]zlKIU)x'iACCk-_5#VEG2T5'VzK5GJ
    2CwQz_lHrX>7;U@GZArr#5iw1*1R|[mGD7X=_v3Bjp[VE7i>3^smmvp!,eA_O_k,~3TRR=J\lIzU
    zC'xBp12ZnEE=l!}Xg*i,Z['+Vz~TpMi^U-${GxzG^EknWv!1*i[Gw\}a_pv<+-c(31xk~D<oB~R
    v__?*3ROab{Xs<cM<[,Ek=~[e-m^91^1vz;[;>CwZEp~vCR+Y1G[IFR{DXqpzre!XI{uE[j_GGop
    u1H#>Ba1+,Y,<opHV>z'{E~5GXjHp1@gzZuo3Gr3YUn-s;!@$R<rUUB2i[u-q5Ni'nAET<CZ>zH*
    },VDZ!nLxelz*TZ3I]spHxY5*^#'D1K<E~x3V>ZznVExCo-Xxw_G;I?Wj'v?lQez]V+Up<_Xa+II
    }*'<3,rW=IY5aQ>3*@xsZ$x'^RBJV<j*W71^K'Jk4@.ACpkv1?UW5In_usOR'OQp{raZz1kY]'@j
    p!Gs-WX#[1@JEkYM_>7u\<l@oW='xvUH-pD#EHH?o5@-wB2+ipY$^e=D,pn,J$Ci!_,\Yj,$uCp?
    zn_V_@=2z!nDw,2uCsWpKn;^euUpsh@z1;;XI$'#-;p>To,#-VaXQWvsTX?pj,C%lC?@!*lK'V?p
    ls{X{-1wHRo=;IUwKs^KAR?p[$BO}YXl<,@QHV+R&Sqp1v3i7H,ixC#ZpOVuz>2=<mI$W=wO,=Q_
    ]>1+en#8oVAmZAWX]O>IC3l]nEsYplpJopBnD_aW)R^x@_m@wouTT,2=7#_TrBa3Jss[O[o7!R1x
    'jx{1/ri_WCOnO{5m*;eVo,+7-dCj<^_QKJC#wm(#xz;eKH2u$Js;_jZQ>XR\?ExwQa{5Ha=Y>V,
    v}^?sws7j{!_UGViwYr'1ET?s7+zh1oj}1l_OIT+R,IzpEB5}FHD,>ziQ5EE}'sBHHoIVK'{Z!%T
    +\;,UZ2=wYXveX2KpGV%DTp<Z'!J{7>12nHrkY2;Vo$^n*xV,op+%i7v!Q$zQ|">e3o[<ouRuUl>
    V~VHazo,2Y1X{B5klK@TeR[YAJOKpvwf[2Ywx^Ewj?1lr$\@HvYYmDX''?A^0T\j>l5}]vC,Vu_W
    1J1uA^Z'7F<jpKV77WsgXX;\XaXG/ff}jJOH}WnV^T~snlUeUMbGDII!D;#s^va<IYA9rjk!oGBT
    ]Q$T$,XVe}x?2e1WG=G5X]l57+U]'BxVI'[zzs{Xa=sAz1Zmec[B*[TBR2:^$R<QGirjC,$SN><{
    [?Y3],ru^?5}lV]1W6_p\Gk]->{5mpRj1]Fp\1R${\m<vj,SE[5nre='GAKO,lx{>OVjl<E'z1^U
    C^'1qGkTVHITD5<\YTUs^>\2U#[s'^;@7zCuT3D#'rf!7E*+7@X;IO!*rW5V{2r1'-ExuQB_35jB
    }I$HE*<mwl?WT5?QVZw$+7z,?psPaaTpaCI,v_m$r2p5%mQ*~p^^,~<sB]r'1@]R_z_QYp1{+@lG
    QEje-pp=s;BTaJ_,_o~Ae?Iz?)(Bpi<zj=Q.<{v?|(3YB'AAnwp>,C7a1{X}vl{=KE7+1=B5XmUe
    slA+Qv#Dw$H}Jv2He~JDk1yYz3QH+K^s\V5<}YEDje'uXVZlCR{a-Er#G?v'O>mr!YvEne~3ok^Q
    sur+eO$1O}>3\av;a1<,5\7xQ}uqOkrk}=o]e<AsKO3+A=p7osTUgzHdk}}><5TGH^RirJnxe-rj
    V^\RK}?w;zw$(:ODk>-BJ>R~=x<CH'@OmpIVJRQnwHwYsuziJ-;_JUQoUI#Do3Wz~x~>^p7a\QZ>
    mR5z=7[NxCl~=AHa?U@'fC?XK]K\z;O_';U75=1VO$~r1]R*ru5D[oV''g]C@W!avY1~*U,-uw\W
    ZOF<+l{2Tm]'{o!uzI<swJku=@O#5YW]$\Y,iEH(O+~5>'sKg_rTC$o!,D(=.a1G$ssW;,;7Hp3*
    EWQ'^^@,Htq+7WK@\;nT<<V[jsioGT?H+r;t^3}28okwCrHKmn\HoR>;B3He[l~Op;>vTAvkxc=m
    j]RmZoi\Tjxe+{1bOA}eX=V{l[vw;,oRxA'pmsmw3spmrQpuuG>=Zx]pws'B=Y}_57<a#rUpiAp\
    (\}G_QA35]zWD,JUm*Z1[?OXRKr'$V7@wlARV'+,1Q3A$Qew'1_}-XR^G'on]a+QJAVr?In'7a*@
    7Gvz@\2oOH_w5,ueA,z>nz*\Cll]}EE3jjD*lG1AU^e#}{QlOYw-oC,vUnv!1wCl'G?a~e^A_eOV
    *q'OKUxDR+R>;]_vHjyK],QZ<Q@~OJ=>-<?W=$em'3@@arv_#};$Ere4~A5WU<3rvUrOOKxKw]3R
    vVEnjxWk&;-n=}wW}]EvZrD?e5YO7)}DY@,$;plvIu(EKQGOpvZ,-}G.@xA5XE3kV}zK\[Yr~1'2
    z7}U_O~@QQ<3UnRAx$=Y?oT!owOzAoo?h*TCek_?HQsDm1='WI7Ok!oj5J$=o=vTC's<W'K=_mzY
    H'[V<.WXH_1u;3!I27?jD1?wBn4~\~_avDV&meo;!]i?{,R'zH+>*zr<Y=p]RI3QuEmKN$sCX}!^
    R%aR5*/LoOp;]kuar[wOo3TE"'Jr{GTD*G?lA][@jpH=U-EK$8~,wxYse~t;C[@,Cm{s^CA73B,\
    R"g!v1I~$Gr$Vn[,"H-zEU7pWo/}@{2^CR5r0<s'CvHBsY*z'ZE1oQ!B~yY5]X|]x_;p!2mX{xRl
    pu*q2$&E+Tz$u}'[u=O7#U[7Z*D#D$$7JlTplj1isGl-IOHc[,p!y}uMj_k'mE}VeGTBUTzOu+m$
    D+lD>op#75#Q'k-+]TvszVVuH<^*Q;A!w->u'$5ZVVsO{BV\;IkT1<X}BzYlx*T>^nlKaCx#$Ju5
    mjXKHaD^KsiHiU*+,CGXWI+Ck5ss^npR]aZ7D*eu;1!j7{Ck7FO3lO]B}ZTY1;|0Rt<VOnV#!okC
    _=T}7C2T[^p}V~:oQBRB\7*2$T@Q7k~|,px*o;;'@T1o6"I>vU'_*\5FQul+ORzE4!R]jIP!|]Hm
    7{rC},W2]uO*rwlVD\O3*v{uR=1lwwa<arWBp,c;$JuIzIYp#UxOQ,n$<@BoGsi'X}kBG3pBY;GS
    ]u{V,=iuFv'[?;B!Bh>Qk!!,zVz1W1w-$Q?w!TWpjr5ZKBR=Y$ZwOjIwrU+*2EQlT7?<jsa+!ke3
    zk2vrvQXHj><XA>>Y!V=w_7i_m*7[I>$owke<{DXzYNWY7_-U^iHEuav[?OOG+w*1pIsJ\$lARJh
    e[-Wr@@m*m7A3YBG[{AB2'uCl&K]@_=plJE+xm$gR?;I&/^GU[l,pO'[Da<Q#@Eoe]R*3CB!o_CA
    !Iprrl6U\RVk\o2[XQuiVUjI++$]Un<m<[U~jrU?x_3]sJ<]gX\!uG,R[?=viD<,=+^^@CK+aBiQ
    \xZ5[VmsQu{*^ArTaaEpX=Jx}GO<V_{p[-z1=5oV#s^$$PV,I5{>vOo5KXHzjZ>n;*x!17;^eoB!
    x{=!{pTlA]Y<m-,;p[I5Av=HOl0o!Qo]Rakl\[Q"$UwOA>\CIA}E$s-vus\vO!,=(EpI2^^75Vy<
    OzX$TX'p7OvS_SN@e;V7^'+RJrUl!Xp{RA+?A!Q'?Jn1V<ow5CJrk\m?z~[%x~oV!I+o}L1'V_Ex
    +2R7[rJS>'XDK1w^7R"hGn<l^<XW*}V+k^$2[T]!h7ID1oO~J'DA@9V+-Bp#-[}XD'N1~-{}adr+
    +HW][1DQ\D<aXB0,o_;~=i]![_~sQ!1DAQ{_WZ5up{QD\\_>nDmQRR7z\';(=,=ie'Ql}@\eJokJ
    J>s+X<Kk}MisJe+wDVk-*r5T'X%^K5T_5!B-Yu,9<|mRTV[4+_sx1}R1]'QG~Ym}aB\GNw,Y^BBR
    RvkXxB32T;\B[IkUYuBmXO=1Xnslu'3D^7l~+$G'3(/V3;1|57'{2pYl\kE'al3vz_iRQDA2ly3s
    =>\Q+UxrnA,z$anT+BLoGex?Unv);^+]}61Ro-+p#UD+BeO_A?T]_iMe1\pG?sJ}nXT9};RE-BZW
    7>{oK5BQmQB<-T{5kQI,2_t,TRVaAZH]jmRR>U72OUV~rHr3{lk>_<<&^SGjWX|]3~a~pjm2E\J\
    5\OGpX2f*E-QuwZW{U*IX'HCB~Gn_X[u6[K<?}C?R,J{Y?]OE{HUViA5}FvVVXgEWU<-D*]4AwZU
    VeJ]wUGrE,,aKzA2Cu!C]]x=I@Ts8I!Vp=TEIUx!{=jxw<AZ11?2*#Cm1$E']vQ_K\m\JfpkVu1#
    [5/>*>rs\HH<Y->~v$e!UvVVZ^;xKsD:^_3JijOx7#2CHVrs*'VTKQ}3'xnxn}os+D+Bwp~$D^G$
    )2Y?1tE/eD={H-I,A{+vjho,O7x1j2@$=$w+^Q^-+EKrX*]W;3rx\,#7XV0e_er]^{x\x\2ovvlC
    WW_UzJUrKaos<,YwE*naTupjVxs=-W=ZpjE]JD{$G^OSXa<;$]*1,+G@[^w{T\!7g>Oas^,w%J]v
    eC@H@Gl1#w7ReEYA-q825ok[(S{{-{Yp?Y$<@R67!]![>wBkh1K*'[j71n<K_3ne_wv5]oBBXrV!
    l':3r^urawJVj?'jeE@2>x<A=^Ta$$r7l+7W^mV!<J*O9wTQYlB<o1k~T\R^$WnVkz[X5^5w},}W
    pYx,CU+=;X-+<[#V=uV[Q_jl;vWB]-Q3_xk}YKUTY[~{[]pEIj3=IFND,!B9&$v2<)tlO!o~Q~1A
    r,oZ]n+U[zuZ{$5GTBH+Usk;X_z1}R5Nj!l=s]m^Ir$A[w*5tfjo{*csnz^eZl*9>vT<_;T]W^!2
    uOeIH{^'E+5B*k\~<ne}^[<kj#Apm*Axv!+}Zzpl][XY}7;o~XBjeu}^:E5<o^p7K=Y?=QiJIx1O
    \*v_zxWwp\V?kYJ=O\XTQ$>EQl_Zr~{ZOzsj$(SL;R=X3}Xn{<]-jyC'jG][I!U>KzTR;EdfWjXn
    {7V{I]1r2s<5rQkVkC+RY\^\usDum1B\{EYWD73^be!TpVE7@x7[Y1w*mWAYxoZEk{eI<}]',]1r
    }R;lK$V,[bRMXA_}J<B]8YG;lpBDpj;,pI*RZC\p-ql?;G'[*B=*Qa@Gr@=+m!,!$Qz}AouBXE<Q
    -QJ>GIo*T]rW!{spC7jKX,3L$C7<*<pDf@GQ'n([3aOAo7i|zr?Q@B+BUI<mj[BlQj,JE+\vs,AX
    []KIiVGT~.#R}E'iTr*p_sl}o]Vx^ACA[s,U-\_*$>RQZ3\{Z2E>j[[_KZ1mRJ[DI1lian*[U-#E
    Y3Ve\25WpvaIasTYYI^li@9Yv2;kaUsOGHArIC=Co#v>EwW>t#7De}<=K%2s,v#[=D];K<Ks#2b[
    k{s*!}I*\!B7}=R{l2j'YKCp;u!>sXWW]T_*.'_nVO'I-#as'vV-'5k_X7Y5{L8[ED[<'*p'Ao],
    ,xAu1_RXoZeD\?T^$oQ5UDW=o@xZlGGV^x!,Z>Q#pOJY]zk{l[Dp[axXO#pjX>3QBl1*Zao;>TJC
    ?ZXpTEOC}C<Ww>r]Bv'K}aC,pEjOl~pS!eX{mw{@0q\E\OIT]G$^uK4eET^LcwlHXBH^_,k\{m'Q
    GFGm@n?a{<us-U7D,ZaT}_kE>{OEzi]q$C}\>5Rx=EI3lH7+rnR=?}z}'^?}U'k{^EliI12xIi7o
    O@<KO@=I1_oC$s!Ij}@lsvKuvm!=wH~7w[\#:oK2,XV2?5x[+K^!K2'V1+^[#5RYASZ'~>DXn1zk
    o;eDl#-D{Q8V2@}v1He}K3X2^Wo#,*Z'JAV<nT3CI@Z12U]>]m[WB$xV\2Dya-s*A&leXGHeYE)|
    x=JJCEsA~7!mB[X!?OspT_AnOUlnj^IvpXz#lvzmmEX3Aa*EFy]Xl-WGYie5>@~E2a(s7o-];Xx,
    [1euDXAVK13b$]O-os,n][>}n'VAs~Vv'WYK@U^}@o}EW-<x'#n7Si^J1*b]15HaDk;F7@W]7o,<
    ~+>J<x]_T1QoZYZ]V;_B)sABBlZ32:P?$37Al=3I4v-Iv']j$bOCTJo,J*o*jApn2a_m^@ka7QaQ
    $#TR<*x\Dw}WYO*^pv>1Zl}I?z>swe[]6sV*$E$=22pW#'U1u/TDkV*;~v[-{'op[?[iO=(V![oW
    ['vbJa1aEJTW}ea7H'E_^WQ'B6\G7QYvO!<QWuD*QKx1DalIe]1H;*msZwVDXB7?-x7UsO[viJ{q
    1mamRnV~~,~O'<zZ+sOrx]Hl*\RBnR[_}Y+HGX*QEs3@Ra']WO~~oEe7jsV2nTm^F>a15n>HC[EI
    =0z?}~,G]a,21]mD,eGX--;IRv"DXQmdpTQGiX}eEJu;!+sD2e>=X*Oi;xQu-eUx#+[5Vv-OFvk1
    eO2xQiw'G=B>'D4^wr?ZY'_$3@v_'BCVej7W[lC\_k^Xx^YZxaYX9'D+_732u4x2nKv\@YDaXRX5
    iz?$JzvC!K85RO*ORAE}Y!Dfz-X[\ipXU}\@:XRFVE!@~e~}F#$]lUH=r%A+a7BJx3p}I]baa~vI
    xprr~*jy1>sH#CK,jVloA-UT>AED=r*VCnlBQB7'I#RnB/hQ51pjo3JDmo\pis}1Y$i^OD{31k1{
    oA23A(Belvb?\@{Irw'~-zCDXRi}C^n'6\P&1{V+NC-@<YsYvy^@$imo~G>rBuiBAV7u$*4A\B>u
    1JIJErk>{G<oT;IDjA12>e{7n}I5#n$=*;{a_7z[v{E-[]<,H+V-YKE7Gi<+7u^7T-3}ol$,[*T5
    ~Yn3o\13\2~Eu\{*M^DE^VljxH$*[mj<5G1Tk&Mm[T5^{oleW~eJ^Iz,pX51&>1DGJ}GvK]oJjvR
    UpY<oJRo~1EXnbITj7'iZ'7+<mVv[I'D-ar}^'YVkGms,7!rB-;+vEH$mnBovOK}#^Al3!@nTrXn
    }iRn*vK=i$^Iwa'm!z__Uuc*=KAz~o-HUEUpHaxj@$V+\Y2e[u1nUXuQQIDEaKU.YrlZMDYlR[$X
    J7BYioA=wi7sem[wV[\eQJOepXOK*&rH$WA}Wzs2z1rW~p*G}eIXQm>j7Xpv=-|j*E\~nA\_XjXu
    1U#?>^xCCe=^|#zQ;YXY_x{x<+_X!*H=JT,ewI}1aVT]X,s>ZU_o,~s<vEZZoJT=T]j>zx+mXWp'
    3B3lGpVQal^klVnG@Uevj'=$}K5O@]UTIkEB[-AwU[\#\AsC,mHJs+l,WA}W'D!vsE@]~Jxs2[iU
    EYK3U<UD2AVBKg$Q\a*$an<U^l{CaUIY\TbnU!sOkUr#_xZ9vi=K+A\^~papu>}n$JXR5El@T5Yu
    CKz_>C]Xi\JjToB,j?=KmDVlxV#k!}?aC5Y[YpTm^HBK_5sElIH~'KDE]Vv<VvI^YZ[]\Ae=Ox^@
    DCI7<_s5x^A\p1LF=J{2,!a-X,7v$[YBV52!Y;XJN$aOI1@o-cC!'^\m2A!v1pr\}BA>HTwzIn0U
    zv?XTl1}sj7]Eo}E;J\wHxp\+lipbZAAVB2-C&!A<!x][Un}ipTaji-AR!$\]71(c$rj![#m'U]Y
    j11xGdoOenaY@s<X\rq)Y]sii>Q*:1U5z}QVmzHD$XpX~1DivhIH,ESK$D-^x@ui-xk+lZWD_2=k
    w*#v?npz5Ko:GO]GCV!JI]Yp)'xjmJ<=HEwTDz_eINz5YzRv{m]jpr5{x--Dl1<ovZt1CT,2{;O^
    JJv<TVeQpAzzp;OWRG!mj$W[U7]>XY!j_JK;Qp!aw5kpZQVs}E+@<[zL!]z*:!pOQ?IW_3'k{$=v
    ~7+'$QTuo_r,5~VB1U^\Je^]#Z_\HCq_X>KU'O}C~+nz%lU3C[^,r+*JU75n\d+e+15Dv'#_~ww7
    a-O]-J?peX-QZ_1[kIl3p^j1QIDC+W_[pE*[ox~emwvHH@BV;5+^UVHHv_u[>G6G@KZYwpCo_<Z7
    ^m_@\;5;oxIEeGIwaTOQC-$}>Gj?R+ZOOX-cbBT<j"uoC<2*e{_u;1['u}y8Om!K>$?R]$x<KY~X
    =;e]cVV?[R@u,7\_G_2ruZ'1W4J[>TO72GZpnAD,#Z*WY^xjI>Zxwzskz-jip=\nWY5yexKO+wBj
    Rm_$Bz]-x_>zvmR5riWO5WovlV2z*Vw{e][Dz]?O[>2uOm+;$DjR2{;$R23mebl$o!;UYKi\227_
    w*:*,^?AG~U)Hv;OPvQXsRRRuz$[iaV}D3Y$T7^pv=$IG_,?=YEa^GKa^Ysx7K>ps!l^BC$B[Ar1
    l(\Q5zO-}p{s[IURZAliVw?XCB!_B7>*Y$zeJTlVUG7<Y?j>w$g{l=Vze\^OIa]\iB}~OYuID!G.
    =jAB.}n1}>_-3f38D[RGBoW}jsA=KGw{i<Ajl2DD;Co'_urZx@O_-Hp-ZDW%:3><j"Bh{,i2[aD[
    ?UnKYKx@;^^rp<YV*r2s7W2{lz;[r@+v}IZ~95"{[Gx_#sDlZ;ZfOj{u#5YnRkDQ?\rp1nGj[m\r
    rK[KXU_3j{O+vz7a=jAz2{fEiCj=@+e,Ei<'r[<YAHmrZ7$E>Ce<V$aZ-U<_R_JQ}^2<5-~#Aa^+
    =5H][*v@+>{F7Qoa&XB#pp~n!FiHEag[$[3D7YzQym}]B$'sXi\xkT_H\ATXAU=$Q>*^GQ,K!W+2
    <#$KI~sQ\WH~;$lD>HX[e3oi$t2B;+~,~~;5QQ]\s7n}QxI-jH=BQ+-_u_Dh#UG:@Hxaol^]}?Rn
    I#VB6i>}X[;$,B%o;jQ[G*~#1>*=<Io#D5[}BU3C2}OD.3rGZ(21XA[KOz{r<Rrr+<15@'n+YEe,
    -Y:73*E~njojmEsus^lI[2$~RY;ka']ABKGkY[rtJGe[Q5Ev5j][U'rj\jnlW[D{5Ja<!IiI}iZI
    =U+*aCl}*{=U<r5#!*3sFU}wm_GTJQ%V1kDx;w=@=T~jA7j=r*$'rIkX'?[\iZOY#YWn^;I>n~3(
    D,?AUn*ApU\O<'$!;n_;i{jW~9ZXA{>ErZo_1l6BQVZ5j![hC@TjI>]$BQi>W$vieuTW|OoDQ%O7
    *=B;{Yv3D>A|]v^7W]xOXX,uOw=e)Ixk{^a33v>KXs}a5n]#<;Q_Dj>!}1XCDVQwo7K~=7JQOcr{
    [GkD>z+&Vm+wR>=Gk,wBu^>\Q,T2_X_lQ;j;[=7]iEJ\7]7~9v1-^O\Vso?@#}lvJjVWmwIJ?Iaz
    sUj_,G#U].u,=;+r[OoE^Kuw@o^ms[]KVIRJ$Q;o#m+=Yi6NBA^K;xwAH$R^"k_HaaI]UL*Z\7Pi
    pC#ll]x{I<*rE*V5~T*ZEe]G_QYvCHY5H77zr!r8BW~O7==][3C<]V5Y~we?_o-;ZaJ=f@HpQ,={
    RlURa}2REi'ze5k>OIY]eeTW^IE~;#EDA]X!-Vm*_}D#@n_vvrVKJZom$,E_3-1so5o!a^[[1=x;
    >Vl;_]{E_WOKZso#~(,}x_rA=@)^bmH'XJ],kKXBjYpEH5n2oG$Ii^T!][{QkEolQa>pTe\uV^7D
    #,G];j<}'__g$_2p]pYU'CT;$}@Z$/JORD>>m!fY>eBoInu3s!>}^pkBmx2\X$,iCUKuE[a6{|\o
    @[JG#;7mp7<eGi^\{Hwl]3EYomHx_ksGW;qnOa3==wK;7Xo@_QuFB{1w/ASJ,;3+ar@\;1XRpl~z
    2psQ~\-k,$DYnCG([Z5-{nPA\\_;Tp\#7G!r1[^%T\\rF;z1lsR?G{5kX2}vCWAWmVDei8<1kj=H
    ~^V3WQ+VW]lOUu_z\n^X~{p\7xClRaaG[~21iDH{5@0&uGV_v1Oapo}^gOCU}h=3a1JT[K[i]*vA
    ;3FjsA[*uRl0*G^IDu~T'+aJxr]uHxv{lG,'!C]5X[<K.\zKV"T<1O:.I]l^~sl]G{JVr'oDW7@E
    D@_QE'mQH*Yz0oj*lA1{^;>$@O]J-2jV<o~WCusE5$$!n$;T_-'e{avIrKj@,^V\KIXXuQ*w7Cx=
    7zVaOQ3\pxV5j&/$[$@o!G@[ExnfpEE@HU-!wG*Yv-'pQ@U7*xjK$#mx3a@vJGYG(Q^_]![]T${Y
    =RXCDBV+;I?+#jZ~[EDUx_e[G,%GXvu!__':l?*'A}\]+QeBlOx'|$C~O}EE,zv3,5i7wd7$o[^O
    Ua6\jmKwX,U@e#-7rIJQrQTMCzEZpE<=!X7C3O-@3AC>{_V1v?{xY]X^wT+3J-B+@,5H3a[G_Yx_
    O\vEXO;;cv[aJWXn57_GuJpCso-Rlr5i$T'H;QRXU~IZ-?5;'HpBihUsj!sEE>'U<n=n]U2CiVOu
    nOjzl?AsA=oICa1Z~U2V?3jl-va[zrz'jUp#_ljU[1-z\[RAwuIu5i1'+1K]E\+C=T,sm,UnzskE
    E>k7_W\kpO;O#Ij'+1zUG^eOD,kl$'^K7w6j}#2y@z*@J^~D=vDHGlxizor{$wH<G#,J/?|'@z=f
    GZ$ZDQIelKm[($E!*^nT#j@D@m,o[*osXh\vW<@rQ~Q@~J?Ga<]lr#3QA@_R#~^D<sYj=k^}iIf$
    QAX$ajEI$YZ71p\a^-ev@vognIOnHx>x{vsvo!;0/rX'E#sVVLp7@}Y;SS1Cp\=~'Ur5-r}uEKbv
    I$s[1<sAO\I=7j1HRZlsI2ZV_E]'I?[k<z@^,U+sm0r{ZvCkECn7YuQ]^CB5@r<A--+$o;l?X#]J
    5Q%B8i+l$R$5mJY7]Q@[wxejV+_s^H<+xF$_u#Tx*O;=rx]=3z]Wo*NmC{->ja>v$wYarji,QK\?
    ORRVeUp_e2vC?O?,r}!?v2a1}JD^~T1DJD5nz-'opusp?Z$Z['sG5'Y\#;aTr{v[QB?V<u]j?a7f
    c\G->J]R5v\YuEI]z5'Tsy=vzoC#QTDsR]sZnQvxaI+73-(uE;m2'+_'A,n;-X2COw*$Qv!1@R#\
    uv$V2-_z'AjUaC^)8@Dpl_oYpa}lI=i1s$T3$}~wmaGO_UU1s77WO?E~RC+~vYO$<L5GO,L'Z<!T
    YGjHVZ!p;\rx*W!Za<WlUPgsz~+v}3}=n;$Ol)iRl^BI@QT,x>kx1Q!B{59i,A+[V5r-Q(p]?r\s
    QYVw<DnlYH'i7W1iX["lem+}e$}0Aw+nvOr$-Bi*Hs7']Y^@*#-$3$RE,XYIRJ=]-5ksonx>VQ-j
    iDY[1U{W#e{\z3TeN_KaT7z5Rao1@o{WKGl5BUVCap@7QC>-xO[p1emVzf7*sKHY;GKs<TBmo3<+
    <$2VQ$Xe=~CZnKpHm^5aoA;sXX2BI;bO!*KuY#$nVYAc=RnEn*[z@U<p*K3RVJVkj7v7oZjpu'+m
    $ol!_\EI_vV1n&Jr\s-jo'i{B;,X-kxIT3,Or=nj!WExG=iI@,o~*Yy|O~ROD}C#,X2?m[_isp$O
    pmnX#<$Xa*HsHTtK+Gn7BpWJX***BQj{nA$>GjRUA[*OkKpIJXOZQ5j{EzVL*>V-~z{A'zD_b5;x
    }5_voT*$OJ_pZACB'd}1@=UrY-D!>*JlXJl~]EaB>EUEJe[[G#!wU{gZXTrZja?BCO?Ajk55\iC_
    {vH{l5riHnsj2s<7}RXC^U1GO5xge>Bnh1,YTr5@!OsQ2QJzm>YZzu1~2^x'lTxOb~$kz.IRl#Jx
    2Jel=7&*[2;vGpElFT=RUrsW=as7;x_;s5aI=mxa[2Q2B<+Q\ujJoTj5Hz<1iVwJXL|Xwj7[@+Hs
    T@G]IH<?H\,T^pj!o7ZT_3n{sm^5>H1mo-;E7~_!'u^eBT]@$[1YI5xDjO?{Ei^WU2#v<2#F^O5?
    mO;<QO^A0ri'k)<1jRGOmZ:)=mj<E[7X$JvuH[+B=Tp\OsQ}YBbi_51pjV^1_!G5X<]V{1ADUQvb
    nwp=I#Z'C3HAK]zev#Hx[p\wZr.)nX*#+Q3ub^X},-+\K=eWQ@$}=jOIz>+DO}^<VoIJ;573aTD<
    w*K7W,R#BG@Zu1^?wY2xs^Zj-k]X@#OvWW5~3nE7+l~ZQ)97uU]'ax7G_[w-Uz#A^?<K_p_b2<'3
    }An$^>e2r}DJ}z*?gzHjx1[;kC]R$X>nw*3x<["[AmTE-ZO7CT,'xKIPX^<Z2}$u8YGp=a$m2=xw
    l5\?;,*Rz^vv*_=iZ1J5pQYUsg7An-<}vuQGGB#}!w\~_B,jK<kxRW!>R@]znr[QiUz{m]5RzxTA
    o{|m>1iAnDkpw]X|_3v}=Z\*-p^]wQe{CmXQ~>u$3.^z!+!_~EpTG}*XY#a_nCCRoWuVrr+wJTm'
    J7mYz{e}}{I==CxH[jnRW^}H<[<1;_axmuDWY#8LKaYuo!C$G7+2~EkY:}=@*E2;o^Gk?k-2'K]i
    +Y&cm}Kp"j'sv]mZpn<e?7@!_<wjx[axpK(vTu\1Q<v@ejDi5*]DD57rVAQjC[+]Z'*,aaefO;@G
    #5kn>1!Q>57AiH{k+x~\H]s1ETW+wV{pb4*mj<WTsHk_]Bk1*{lo;H-]T@G}WC;o'+TsK_;Bs#?'
    ?+W$!IVv}I4TX;Zx^\DCazEs<<wpBrx*1vDD>z~BkW2zGG~j{ep-7V]DK>WOa\llw<uK*n,@+oQc
    zOv3Rps'k+DieTXOT,T~\m@*rYQ->OVZ\GV>pT\7]JJ~,-sV/T^?'Bi+-xGi@A-{A$A}A^XT?Aon
    -:AUT>^+zwVuQ$coQ]OBY~jYw*$r'$5Bi1+#UGe'JV~k6'j~oe$RR1!,{vOu{*;o$^"xa^ZD#*p<
    ,*xY>ri*<{Dhv~3pUG1~1CW*;sZ,]vGrvw'o0GnKJ{s2s5+ECVAe~95DpXI,1QW=<{[DQTQ-'xoZ
    ZH}}?2#I1!Vsvpjn=k{p_prTUwOp[o?\rHBOYQsBbH1Aa{xAH'xV>3,lB'D$O\JC'XeH77]X{Awx
    3d3vG]=\@5^HK#eDx1uraalnJCCU>wielYYpo+*m@=5r,Zl!5R)o-3#B2R$usz;dCU-$^=]?[;CY
    aGp]D?,_B]7R4^BVU'B_ZC}U>D{5WYmmpVv@WVrReAEKv?_{H>1RJV]XxnU'>&@zn;5KRsesClrG
    eC3+BV*WRO7e$BHzZw~'~nB2j++5X#!$GK8]aRAT,7V>AxK5$;-.G1-KW]IvUv]vKa{rQo7B*3+Q
    [?AoT,C@tO}J<buTwXx}xBI,wn>5W]jQQ[zmxC8EKXmh)r2olaGlR}A_rUG'3rJjzEO']Ge5xv-{
    ^I]Ikn5Kuk'vVo_Cw}*[e"]GAwWj}Bz=l{C>l;j=O!OT57Ba+uuh1\aYmrzu7XpxC555n1!+17E[
    ZQr$<r,V+=n=e?;po\'+Ia7{s{<xQO}Gm*1w++ao1lQW>>*AdKC71sIC}2wJ!'D1{xiv;!$CTO_w
    lrA7IKAYv=J>u77p35O>Q0QIRuxv{B;}=m,k5m[=k{x*p21HEm75lCS{*$3^r_2nrV?is}-I?~~Y
    Wn76@O'XD'OZVTOjyu,<}$I,>w$,KRv7r^}@$HHJW\U5U@$imbXl+2{1HE2zBZsr-~'r=*rHO>,+
    7!a>Ivn'z?[VIu#\3Xsvp5,m_rJe;uBD7pk7l]ulRU~Yw>+{oU4]{m~E;Q?[,2Ropvppe1oFVJjT
    ffC>!>j+pmQ@Ho=OO5^Gp#CW\Rzpkr+a\IJswE]r@]eY^?7H53is}},kJ2u_s1p;rs7-I?;xRwKQ
    z{cO[_jRQj<:;Y^Cj;X]VXjz;1A<YiQnoGWna}v+]A,1\?[K^1p{Y=i+?EZOQxzX2a-*>H!5J7]C
    1AzUGdK<<!Xvw3ou=RAA52[~},RQHeN=>$2-A*BGwDHh3-aw+rVoR]x@o+2v\7Giy3OTm1\BsW1V
    ZrHT;[l#1HUJ@HO\H^3}?]+\Jj[3r7mK^e]\R5s_J,JuA~v}Ee\<>g}RDOl'3KW}%2O\KIE3n
`endprotected
endmodule // module vusb_hs_portctrl_ulpi

