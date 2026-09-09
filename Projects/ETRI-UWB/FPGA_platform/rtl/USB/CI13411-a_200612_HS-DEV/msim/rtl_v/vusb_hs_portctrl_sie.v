/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_portctrl_sie.vhdl
-- Date Created: Thu Dec 21 22:42:17 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_portctrl_sie.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    DPLL for full speed and low speed modes for the vusb_hs.  This block
//    takes the nrzi encoded data and outputs decoded serial data and a
//    derived clock.
// 
//    Interfaces:
// 
//       xcvr* - Connections to a serial tranceiver
//       ophy* - Omni phy interface
// 
// 
//    Notables:
//      TX start delay (1.6 FS bit time w.c. assuming pe_clk >= 30Mhz)
//         @sysclk : 1 cycle sm + 1 cycle fifo.
//         @60Mhz  : 2 cycles sync (wc) + 2 cycles output logic
//      RX done delay (1 FS bit time w.c. assuming pe_clk >= 30Mhz)
//         @60Mhz  : 4cycles sample (wc) + 2 cycles sync. + 1 cycle FIFO
//         @sysclk : 2cycles sync (wc) + 1 cycle edge detect + 1 cycle s/m
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
module vusb_hs_portctrl_sie (pe_clk,
   pe_rst,
   pe_rst_a,
   pe_porst,
   pe_porst_a,
   portctrl_up_suspend,
   portctrl_up_phy_select,
   pc_ophy_phy_serial,
   pc_ophy_disable_bs,
   pc_ophy_hostmode,
   pc_ophy_port_speed,
   pc_ophy_port_state,
   pc_ophy_tx_data,
   pc_ophy_tx_lowspeed,
   pc_ophy_tx_valid,
   pc_ophy_tx_valid_en,
   pc_ophy_tx_valid_last,
   pc_ophy_sess_valid,
   pc_ophy_data_pulse,
   sie_pc_ophy_clk_valid,
   sie_pc_ophy_linestate,
   sie_pc_ophy_rx_data,
   sie_pc_ophy_rx_err,
   sie_pc_ophy_rx_valid,
   sie_pc_ophy_tx_ready,
   sie_pc_ophy_tx_done,
   sie_pc_ophy_bto,
   xcvr_ser_clk,
   xcvr_ser_rst,
   xcvr_ser_rst_a,
   xcvr_ser_porst,
   xcvr_ser_porst_a,
   ser_rx_rcv,
   ser_rx_dm,
   ser_rx_dp,
   ser_tx_enable_n,
   ser_tx_se0,
   ser_tx_dat,
   ser_dppullup,
   ser_speed,
   ser_dppulldown,
   ser_dmpulldown,
   ser_pwrctl_suspend,
   ser_phy_enable,
   sie_rx_rcv,
   sie_rx_dm,
   sie_rx_dp,
   sie_tx_enable_n,
   sie_tx_se0,
   sie_tx_dat);

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   pe_clk; 
input   pe_rst; 
input   pe_rst_a; 
input   pe_porst; 
input   pe_porst_a; 
input   portctrl_up_suspend; 
input   [1:0] portctrl_up_phy_select; 
input   pc_ophy_phy_serial; //  one of the parallel phys is using the sie
input   pc_ophy_disable_bs; //  disable bit stuffing
input   pc_ophy_hostmode; //  host mode enable
input   [1:0] pc_ophy_port_speed; //  indication of port speed
input   [3:0] pc_ophy_port_state; //  used to decode control in phy char blocks
input   [15:0] pc_ophy_tx_data; //  tx data
input   pc_ophy_tx_lowspeed; //  trasmit Low Speed
input   [1:0] pc_ophy_tx_valid; //  tx packet framing
input   pc_ophy_tx_valid_en; //  port controller transmit lock
input   pc_ophy_tx_valid_last; //  port controller transmit lock
input   pc_ophy_sess_valid; //  indicate valid session
input   pc_ophy_data_pulse; //  indicate data pulsing
output   sie_pc_ophy_clk_valid; 
output   [1:0] sie_pc_ophy_linestate; //  linestate from serial block         
output   [15:0] sie_pc_ophy_rx_data; //  rx data from serial block           
output   sie_pc_ophy_rx_err; //  rx error from serial block          
output   [2:0] sie_pc_ophy_rx_valid; //  rx packet framing from serial block 
output   sie_pc_ophy_tx_ready; //  tx handshake from serial bloc
output   sie_pc_ophy_tx_done; //  tx done from serial block           
output   sie_pc_ophy_bto; //  tx done from serial block           
input   xcvr_ser_clk; //  60MHz clock
input   xcvr_ser_rst; //  sync reset
input   xcvr_ser_rst_a; //  async reset
input   xcvr_ser_porst; //  sync reset
input   xcvr_ser_porst_a; //  async reset
input   ser_rx_rcv; //  receive indication
input   ser_rx_dm; //  V- input
input   ser_rx_dp; //  V+ input
output   ser_tx_enable_n; //  output enable (active low)
output   ser_tx_se0; //  SE0 output
output   ser_tx_dat; //  V+ output
output   ser_dppullup; //  pullup control
output   ser_speed; //  serial edge rate select (optional)
output   ser_dppulldown; 
output   ser_dmpulldown; 
output   ser_pwrctl_suspend; //  suspend xcvr_ser_clk source
output   ser_phy_enable; //  serial 1.1 phy is selected
input   sie_rx_rcv; //  receive indication
input   sie_rx_dm; //  V- input
input   sie_rx_dp; //  V+ input
output   sie_tx_enable_n; //  output enable (active low)
output   sie_tx_se0; //  SE0 output
output   sie_tx_dat; 
`protected

    MTI!#_HH3OQ]E4FUV~Xc^o*pH>ITWDnp(VsR[Ci=@FB|b<}UO[Z{1~<YJOWo_O6NY;K5|eqihpu<
    ZeHBXlEZeT$JGv^5,|0iC{~OYu1KC^7!]i!'\#^^wU;[1;<CzAULI!lV\iIi[C#5BW5,x+x2}Y,w
    (T}u]}naJKUH<#e;rrD=p>{Y^@<mJM'}Y#V7JaM,o^RU{^kskE?rs^V1XaK<'*{~r[o:~sigp'r{
    [>*kT}#IEjO}r@X~=Az1>r/VJJ{_;\$|!Yj,-TEZ'HQ7d[~KU[RoB5KJE<7u@R'nJHGB~QQeB,kG
    ]\O{_RO^DJAjjFj;{,eBD3uU8=n\\l5BZ#_lRXR[VrzK^G;E_]2]>[e+!U+*ko'CA^HX+Ul;2p,V
    *v\r2@=eUt^?TK=[Eio~}7ZQRE6&WzRY-TwJ>YJEVH@DBx;<[{^eu=QQFmoXE]9~om}T]u[Y"YkA
    e2]D^vJ6rmr};R{$2E<v^iH_{eE{}@$eHsO]pj-#[CuT-n*,!,$znxJ#!,Ker#j>G~ZVD2$<le\e
    Q'5w1Zo[_@-r[3U[TH31+1B;V?22Bi^~!SXsv>}G-@|xn]}O?$X;$5Qz?uCRr5lV_<m]~ewwC>2j
    Z\[KXwuTsTu^1'7YTRKxxn1fQpXk8;jwKFBu<Row03][AHlX[<E?3GJ@OxWZ73+eu}wa$U'p>e?A
    uep1k}5G{rv]eH-uvEmDZwI!+mQrOsEweoux5>{2VYkJ[-zKvs#-I--\wHpV}U_tuCuz3\=B]^HX
    ,E;+J+EonRr1OU{j7D;=>-jl^R!ZUG}+p[Xo'T$^o7KK--_-;DD#Var7kwuU<IiaOP;{wQi|x!=}
    [<,KY-{mJ_mV!AmpHa1AGUJ*@BnJI^x7E!u[]z*@#x@o5r*DOu>X*zV<!sAOvDQT1!*_l\-X&=JU
    v_N62E?2]@=;Sz#5>2Y@wBE7x5oG5+H!^{xVT*lisDAUsYri@hqU>+='UC[~zZpksUu,]xoz<Q7F
    4c&rS6Izan'~uk5Xj52EZ2j3CkjR+~e>u2jJ2kW-D3iYoWk]lw[^'EG?xE'O{']sl]EO#o8vZToA
    7<Ue+O;DQG!llYw?<{;+nVuGWO*+,v?3r3^Kr>T#\[@[e3*#vsw~}HKmV\eawsO7mY[o735sp@eI
    {\<$2@+BY,zb#GQXYv7~l{[ZF7ITT;{@p$<>ruA]#z@j1s7_5e-U#aaRed!,io*7}+*wn3sz7vz5
    TvIw,J'<4x71ok7!k-a$JUT,Q}5_VW>,w&sQTlxkKU^<+ppRxkeQZIE>Q_F@Ru!u[a>BO\QD_Emk
    Ce'GDl'A5CGruaZo#@{I3Tv1-z_vKnYf\1,kj_oUG2Ue[r1]j2Y,UamxJ[Q2v3D}VQmAJ>@Zm'B,
    xUn#!zZ,3}GJH+\GDH7Y5r\lQloI][M{}A^ICjVU==;I=x*3UQr2_KJeviCYAr2xEAp{n=,LWo?!
    X<~>!D$p&2{Jo~]GUmDBoB!*H,[,Z>&yOksu7$@sp1}l3_3$^?m3drc$JXrKEC~#CCn<O?I5}Qp5
    #52OXY+Ne3sK^v$Amo?J52!OR!~R1u@R^Ms+^{v}+'E#3-8Ke~j]1^+7+w_=n<CMQ-uJBoi],+B;
    PLOgG@'7=dliH{IUnB\IZlsZZQ!_{],j+7I~W-He<};U2D=TD!|jvD{xUZX:7m=oko-wrK;K1Ga5
    wC#z#V$#*Q~JpZ33vHBI_YEiG^aojaDsOV$5}}$i<[}a}iK\4{CHRhY+TZ1CADVDs<G?lwvE<\U^
    V$VV!Z!'X}Wz-*veQv\2T@>5{^GD}?Q>B{@sT=A\nXlvvK]WYIw$lTN:_7EE,#[pC$vv\WpQ[TEl
    G5jZo+CRB>[Kewj~@p$21J2yn{~v!-$@qVs3*V'K$a'+\gz2-pC-=v'T*IIjo_+,#~K\o\_-s7jC
    7Xo[+?lCK2QR\pe2J]+ECXwIm^^C^UX+jU5E5H>G+<qcYX*iZ=euxv!mjQu'Xq>s_m;rD,!]~o@N
    ueECj^Ok[m!+<_a>U7!+j\A~.v>VwiG?Y>T[aZU17pv$nZ}<]Rw+Bl#UpA-$Q}XRlA-l=L]U'vJv
    }w;]JzeHHwHUVVs~576e!73V+rj{TXDi'$!,\XW{Yvw[s52\aWBn}Je>\1~rBK^XUr?Up$QjR{Jm
    =E25T};^U3mYZw[*5@kv3\T>X^=[Kn@[Op18*\+x{^K+u]}-HnQ;2G_@$pI{,+,J#_R7'eK2;5s-
    ^!am<Ijp^BjZ1o,Q~X,Ils\a7-}Jba-V~M'KJ\pl_#[E#H?,{==?p1@woU3'VzW.,5wA=k,DD_?3
    BOO1V!HQ~_oG#]#pI-lpaEzoI*[<IW+52O3mYWX2rwsTRDu1%+[#$l7~DW}CX{HB2peeD\8{+p*U
    -z@[]U$-G'[-+7!_*<rp;W*p!E_^$e~X[5@E!W+_Ur~;tXIY]]i<2\]RJzQ^=,rZB'i^{X1H*i=]
    Xv!1'wnH\B3GV@UD@brZR^QuQCR=XTZvoEz2YxM'-<YC}lCitUH!TI-W=I,rzcCe;Bsr~V\T{KTx
    ]Yjo'Dcy#D"[+V{Ii+l.Vz!,H]A>{I#1'aG==tpm~\bRX~pE]-Em=ATT<@B'3QR]pe]+5\+Qx@n=
    Ojp'H1A#,VXh1@}=&'EjWEev>BRl=r>7<'c4<},OHp^?k}JWe?u'g{+H!e5W21mw@Y~~e~>;a<o$
    Uz{o7Ja[5X}oeXXCYEm1ir[s*Wj{=tiGR-*R^>C2Zvbp_iu}WH^>w}v^}Z$;pUxsAC$Jj~eWaJHQ
    2'D{Ta*~Il;C-xGY;uaZ\UQ(jiX=RekCWx+}X<2]B[=>6a[mw/OzkrKnEXo[-n9(^YG?s^YQmU!o
    Q!7i!AZ~<{ZRg'''_GT]~@UT*vJl;g=RKAk7Y'[Hn!5R}'^4_ErD'?R>knz_@l#':i+G{]5pu[zZ
    >iX}]Q=#\*Ix!mE$-Yw2r7a!+mEmK3_\I^2IR{}-$rK*2I.7GHv?e^;@}<upC<1lox>?Vl;[3QYw
    +3A1w<'[6C>j}lw<U\}v\>$=}#A{W_G?s7Ae]rEKI~v?UJ]z-leal<+^-O#nolW{[uoUA!AHn0Oi
    ,x{}T}=QCK5B1uiC<lxE,Qv[+Y*jG@?Gp^f&Y=wAsG^VHC<!ed1*Vms*G*7{}QXw7pCawz{U<rg{
    >GaTGRw=W2@-o1I3}jYQ@![jr<aCC\+pi-Qz\Ql?C_{5;YGQ'Z!av+[*,VXrR!^=L5QH?V+J2%l<
    Y;m>x_a<^!I<jiBe>kl{uZ!G?<1YkBaBxT[NHEeow[s!wY~{#$#+~-~@lW,JH-R-O53pw=\@F:4?
    s!$pI3pPTROX=~oen*1jQ,lkZl<p{BKo~z1no;{unXv1=D<TCe<>Ci!A['Jop<~#]UQ]2Iw\j>R7
    a_}3N\V<APV?ek2<^?'io{F3{>ZMQ*W!IUKOuwOjovs2'ws$X'B-w7+vBKu^R+s[H,U~?12{/Jnu
    @^5BaW*]kO[<^V,O_uC\Xezz>YZyYw*uJ'WT,_+5U$je8=\i}=3z<><@ZO7\l~Q;X\?~Ob==BJje
    a*]sm#a[7Z*sn1T'R3q.z}IUmzlvB7\=,E^=$xi\V>nWjk{z}[__nz~Z?_oE2x>Aj<eO^jV\1n1v
    -I;?sm}DXx<KKn}>:Xx@^CsA>@1n<mj7w0;VpkjW'C,eYZOuxumz$ie}?}4{ae$xa<CIxI7eQ*B]
    z\=hDIl5|F(RZzZZI'Wg2X\{,'@>:4D7\7[^^U@BjWanrXs<5~7T_'mwRn03Hr+Zj7'TVw<XDz'K
    A1ln<A*QY?AkQrn$%G5Xu,};E}[Y-2EQGxQmAVwei\#*>7n^BH[a@r{~OFlQp5l2B+~U3[C*;ElH
    C3LBJ@[Wz'].CiQHJ7X&*ZK~x#Uk$+X\?xGnx^?8e*T,iQH{~X'x{__-]=zuJ,evKew#p7ZO]'AW
    n,nm^iEE217'IOBDOXr#9c7eYrU5K;A+>[D#~kQW17?{a*Y*OJf-B?*Bl>^2*v~_aep@pnun$#XB
    _mI\n,}zeA_],;QXEX>hl7+zXI~Ko{>?iTR?JoX!F-\{7{DW!kTH@=oI#T5YIsea\wa3l8LE!QTG
    jeVuDk5D~*{Z7m#V<3Qa(!QzzO7U@i{-xEDa!Az;GeW]Ji=kaDV?}\zm!a]]o^#{VTp-1/exKC$l
    ;^|C1X'}XAO<[pB5>~UY2[[Er-*{x~[=5e77QB>u+Y<ejs,OxxX}Xe?}z-au{\<I3Z=@xj;$*I<7
    lkTeYlC[)g_*3{i52Z$y)<j/x]+$:>j?~klHT=aQ=)kwUYvCprp,j*0e#vQbivIil#lWEp1W2s>]
    <jX}D{CQY#DrIQ]-K7?Q"f^*kvIkn@iz;@}2{ZWE,$vA@RZR3V^n!sk+}$hmC;Y1ze_R5l{!x?x-
    C,k9'A^'5z{-spH[_U1pp<mlVp^^<+u<<R5W'[@*?E@v#Dsw_5XR=;1{[1[oBK^Ix}\tR^rDC7Zx
    !}Xz'G#kX-Ik<o=elfp<<Ij23uY5XQeksI&^WYwr#eJEWV;-sxl51,+[E$U&}H{sRK};}\,TGJ<z
    QenG^ZAv{>^QIln=RZszz\#CUn@$Gq3jaoJ_=ZIJs#C7R\H1al?C^u6*0b0.=X[B*+[5=mJ^}D$>
    _1-2}{2JDC\RazY@a=\EJsQJmGBo_mV_+}jGn[QV=}3B,nj$z~[*p~]vPa5n}_-lTa=]-@TR{lWT
    EEII[$2@<$N^\V'Np0u.oJvw]j[^!rYKO_DUvX$[7qH7A'QxXV7Z!{)JT*In\>XKUj=M?\e2l!~K
    Q+jCrRBAAzDBZQ#{1]QnZ[p^]}pW$x1DxC!R~w\2<RrIO+l,7Ir,~Az7oml+C#a@<,lv,H}ef3^p
    uk}QBGfPd,p$vD;^2q%vAK<rDYEz~]>Q3'v1HGrU5Az}$RE3$YYeQBC>xw~@zopWC;e!Uo_k'C<F
    @=z72BwK.jBAOGY!?)VvW$-xYnn$+EYJH[mGD_}Dw}ao?YkHU[E?+?=^rw>[TJrmY2CW3G^ul@>\
    =nlr~udreixP*wriW]5QrBIZuXDlvnCIG|=vCox5;Wo3aD#],Rwn}1Q]VC|1xYTET1Y/QC;{H7eK
    ?Qn1![_lY$YE\<2$UO2}:~HeWp1#pQ'CR}~zppKa{X*xoU^5Y>hsx7$XsRX;Ek1ERlkeOk~g#-u-
    sUpR--Qwz}aGiQp;pXlTU^?;,33$G'j#8[vU=U$Yo'+ZvlbYnYm!lBvF2Rn[CaYrjIwR'((xU{o+
    Vr2PKG{7QxIIR<Zjlp2;,rkx}QH$%_/7}*la[l12'eiw+pWTOV[rY!xe,]<I!7CQmOvs3mz,XQE]
    Ouz9F-BKBir~V=Yo>]u,5&EHK^3apikUJu}?es\!!!Q~l=HCVR'XE^=A$vwojX?_jZzwaCAtO7X$
    #YQi#QV'!+CG.<jK>K1n\\7-}~s@;-1vBV$#QxT1@BTW;#7I+R^J=wT'z(^1$jO{D-IroCKEvX\!
    ;5I73R}w-[E<aJI:cCCjvB_Jm9,sR~rIxkY5jKVVkap@e51GUjO5TJWeri5=5>UwJR{*-Qi>H3r;
    }@z-Te5,p5Y$X=V2AJ!>3CV-I*[{AQ@5!_O'HVlq7o7{KE=j7iD^wDQCC2nHlC=p2^Z}nB{Ej3Gr
    =,>U^]iVh<-<?DwvE3O$;^R*zB_3+$77pQGrsC>r]1^;e}u75v^[E#Tj>7>**Tvk+n-Q^ym=?B[Z
    +XHQ*D1"kaBH<IV_5,VGjw!5[%z-nOk>{$o=]*l)i5Z^$K_+J'A[QRoBFKHrEfFN{[v^$+jJgv]H
    O<wX!ZaZ]xx3]oZJuv%Gl^GDlAnxW[z\lZuzi3Z*JT?eW@[]OD!ZD=}/uC?no_BBUo}iE^1uFuB5
    jDr=s%!Ha^nU>v^ev-BlB@#n=3*fK]B2aT['Gp;k,euE;O*A+T3uO7i!Z[$$vaG{H_axOH<RK}HC
    $^*$l>r1=*5!u9DDOe?_ll!AK=v.HQ>OjDGrM7w1-z,pWjkjBo'k2BleY1ow=\BUQz)}ps*+]owC
    #*pz!TDC@p{]T!}n$3H,\_>-VG2$zDW\}HOuVQ$gkn'WHoZok^~,xTVo^R31C^x*-]evOr-EE?@V
    oj;ZRk21K=[JTBBrar{E|qsVZ3OXRKm|xKliP7aY'*5puY~}ICR[3^I2WF{12<U$U\K>a;5#zrz*
    Zk,5'*1,d^W7s{Y1svBEZRj=@8*l*]rBpv\zk!upDU7^!Cw,=5[?uXZsWTB6QY_a*a+W,TD{f#pW
    74A-JKa=ZVDw17D!{3'~nvnY{#Moelu}Oe'=TlYf'IkARB5*-av,KaK}T=;[,#oW}x?AYo=iiGD}
    YW_si^H=]DV-]HzUDn^rOT-nUjv~uI$k5Z5Gy\*@;G#@RW,*7,7>]^%G}u^HHxix[uO3\=;BpTpY
    'x!@QxW3<D,{T{K;E;p7X,;[46j;lBgCJ<W4r~HJ-[G{35>2<]-,u^xYlD2uR#uDXe}*{a*=-*}J
    YpWE>O,?_xOCQUuR'^vwPF,Al<}jji|xw~3CPUDU;5%qB!@>'lO+525O[G#=pkxw!s,7J^<]u^'_
    ^au!<xXK}o;jkB'R>nmz>w>@GJ~s{H[YK<K{er~m5Y]VD~Y;\n\$ssr$u$H$1ririjK{T]\WY?j+
    I*\K#}2DHB1Dz#@H#E'=p*gB*H-{roxQ[UHXw-@!TvxrkeA8<{X\Ne,-oZ^_]jQ<Z,WX#.w\W+^_
    o[aRjvF1/D}u;1;\KA7Ir=waAnE-]u_WlCji$gxX5IL@XD1BG!}YUYRI+5[Ds-YrnT1zj3znlT2N
    >Q'k&?*Gk(m11-W1}ANJ+IwyA}''1~IG%?EQoRU_{:sT!#+-ur<>-l>B~>VGXuKO$K=p1E-pK2j<
    Ikw=1wyze'Hi[7i0H\x1('^+Ul[2QO1uVuB2san5edCej>EG5v+]?{vkeRpt7jeBy'{x,sJ}'mU{
    }=2{>?A;-$@^B3'J{:e}Q1luv!,W'I3pei<$Aux<lK2sx[_N@_Ii,v\j_,B1-rB3j>Wo-lBGK_i<
    <_wKAIiQ;=VO$I=jsJUB-DtUR_isaZ}'JFwC#l7\KxjZ+{oBQ_2_#?*oR'ZEu{[Te~O4pTImcZve
    oD3CaQOv~s@R$kIUVlX*1v~ox_Xv#sr\J$JJIf1kuGHv!-'DATo]1@-w\e>a,}^}aX_21[rYYs,_
    X_<Xr$O2ET+V>D+}@!H1Xj*sn^zWe,l~!orK}p_YDW'$X<s'+ukokr{<K${^RC!o{{[}+lc,rCC$
    CEE1QJr7p>^sw1sDj!T_CC@RnT?+<pj|O5rr_ru@u\3~:R<][{,$v$aAp3GkOC}\IsZ<o6nqa{1;
    e7,3-lDTpCQIKOJRJrV{v?WO?Tp~QXvHzu1nI]'{GGZYpJmonV-@-nI,I;{XiTQnRT,,OJuR8-R*
    #xE',eE^Al@\r$x-2PF=3!m7u+=fArI1$iBp<e+7Oe7A*$Qo)JaGQc2Eua'KV=o\r[DXK*x2<vd"
    ok=1Y5n!}#jzQp[o5EB57jvEe!eQQ3r=#xDmZ$sDKx+o/E>j'3a}AooTE2D_;nH>XYsw@oZ=kaeX
    aeOa+YD$1k[?w@U~ORs-aAekXR*'3xn@VJs5ED_1?[>Br-'\u^[-w\@IUjYxEY!Bxe[K{NtVXlJ}
    C]<^H^JjuR*RT<*\pBBh{7mBkOVl[m1^C^GGu^<vJ$e]U]]j_-s5Blu!$X>$$+DlSmRXUIV\!6Em
    z!\G-}^sx;r1EzAC*_EzaVzXZ-]Iwxv7DRiAYiR<UTK=V?^T-$jv!$Xsxwo+BX+w\KvJ{5_Uv^z~
    E;}]<k#]nwnC1$JeRnI^'V8#XHx~YO\oVJzi*Vm?[pXaC2}'5RWC}H\^}+u?RarC;=;E?m7U[]E,
    vk\lssvrA=xQZ;x'?WC>+AG.KpVv&;BU=E$[iY1$\b:-IExPue\a(XVY5?HE?<Au~&ZrIpw{Q7^m
    vHAA1>uX~*Gu3}|$u^}Q}Te#I\,1-paDU5OOue~[*G#v+H=RZRieX~v*asZCI\!gQnV5,lQH1KOX
    -HCR8cRvvEQGQ]'EWYreA]dOl*#B1a{uTv!O"7=[{ESG^+[_+{JYLK$xOE-3nExzDG^3e.bIG*~|
    tD-+\lw}E+'+]bK{OWEV}1Q!j$fI;BIU'u<HIln-Ro*G~^1,KlxOC#aL[kKVTjS/?{_OzpaGxA*7
    K$nXs_n]Im}zITmm7jJRR#'#dQ~a1;Tp2f}ap*1IOv'rXQs@IlJ{^V1;o'e/!<HvO5-7REpn[B1=
    T<x'mw*1dI;J${D]^>lp;qWRY28*-Z1=K;v&eI']BwEY#T*Z9y^XW;2IEC$[A'=GJY<D*[#}C]AU
    VB~DJ=en_])uDkInCH;!HJTK,D1,UowOD;2'a;xQ-luGTnxA\u_!\Xu*V}'Ox@oWA@o1,zo=Tvmf
    8,;5_nR?,e~mC|IoIxD[jAO}YZiD$Y3^k<[!*z[EJAnHuKX<C2zo<2{r?l@OmXzRRYOillg?*#],
    C>{-{7[$asTP$CGCC{1-a**u[Ea7H\mTW={m]mD)tB[Q=(]e$3?Y1C[\KelAv{Ja<1R!K26}R^{}
    aW7h^\[=K_X+EBX}eTOZC~{<C[*HT-lno2l$W'?s*=puM~'e+>IJvJ-Dz}Wn3?QlXR}QRu(wwYCB
    T$uf@+-nY<s3oIOKna\'?axUQi1EG]w*B~m;${~vx7x2@l[vHTB#}_aYCCrYyTTa^*#DAn<zmxX5
    l7}]'vZs6HpH=SmQDQI7x-$lU*w5T_xU=l]Z11wTzW]o=$nw'K@r[u]77R}IpAvq.vauEqlJ>5VW
    Q,>xoRU+=}3[}^@E+CVlA2mX2*@+opcls$IRA$7Op,vB1,a>C+<GU}pp>'Vx<'ET7s5I<E5OQ#>&
    f'V]+HnE>soV5@D^[hr7lA?=5@4PB2ve#OVK~D$H(D<J<boVK'v311m>_?3<5wXnlp{j{Z?<n[fb
    OjP!nKXH+Axj^TTAw7'*_X}lO1BPB5W'KH+^v!z1I?7J<lv-m^);Y=mTx7B9e_JBvWaC.kY3Z<p{
    [DJm<T5>m(*$jj7G[~eU}Z_3xo[X~j\$@Vu\lZ%5,=7xV@]E<1Xq-V'RTU71G,}7*JBO~xl-iO]1
    ["hzA2w-G<<j$J1MJBnO_{J]j,Aa<UADJxDzzHHkCZ*G}D#2*~[-?E;Q5j[[:w]<J]-5Gu<+EY3+
    ;4'K]=8V>eC$55O2vXlZIz>OzaAyX[OW6"T}]<2TwQx3es^,k;*7$_\[W7'^m#.#QI}bH{{!B1YA
    UDx7?jYGxMwR#UU]@reU[^Q5;G{G\1rn5'[melv<loi=oU=u}CBrp#=DYUknuB9sCCUp*+FYxo#2
    {Barm=GEo;a}JjZ;^>AkQK}*?p+Z^QD"7_r=Ia5xu-=_;IK{?Uolp_YZDUoa,s\,.oBWpa5-[/2C
    Aw]ZO*0~]vIkw~*DB@IR=K7E}o;}iX]E]x!H^='Q#nTlBQ5@^Kz3rOrkO\!u{p2nQK2,zz=4&sK]
    iRX[;+s[[r*,TYQm$C>^k}pr*b,Rz;Ar~wP%Gv>7=;@p1}2*+,BD1iT!rEV~Go-e\v{;^\HK=~p>
    v'Q!=#'^Ajv5ER2r<DY$ZE\o<w-X|TUR-W*{,yM>xBKX,k55mj]eCWa$,K}d9J[k]xTEKC=]*Lma
    1Vl*]D[^kB_p}C}Q}$xz>1!v;U>G5$@ae#Rs{7.Vw'v$VJ3[Wa{5=7wrU~zWQv,-lOZ^Zra{jG[a
    $?VxZu#dG1KT_/+5HsZ_uZAG;+>A,'Hx_](HGs2'5xoC+^{?1Ameo'z*-V]({OIsT\R=$7GajUp,
    P*$QTl\{#17777_ik#<CH+C_;C^5^D+Q^!&^RKIYua,DUzuE$o5zCEA!L|BQ-*DDzjK+n'_HnmUe
    ^*OwnXp@z_F{$Olc2p@-4EE-xEae*z2^~pVC[x?z<4OWo-3RJ](m5D'Dpa]5un#w[<T#<{Q[?<A\
    jHszeE-j2eiYw$#mEC;t~lZ]m>XU[v[+f;I^@sA5G*~37$2^+r3;<ExB-PH^nj,T7v;$;2/>j7uM
    ,sTHD.\z[u}-!b<UW3[Yo$a\Yzns]Gp[pxp;E]8cCww1rAe_xxieI[#sJ}2^_Ks1P?\Y]B$2TK_a
    \w+';o-~2vi7V|eo1^:Qnw<V5m]bcb}j'+-IHxmR'1]$A,!^X{Wn{2ks=~~-<=A,Z~%Yon2x,G?e
    T;7I<3XE>Gr~x5v^vj#9"Tno;0siZUV=CHYD5RCY#5e=s+D+n_QBwZ%*!e-hVwUY![C@l_l*u$DG
    v;vJ9nVVQCAIT1ie<x{jWnCDT|-_R~o52sQH^w0z'+\*lXBKVjVDIkB/T]]!-[2ryJXZ}xk53-H[
    lCo@vz,RGG]zwj\Em\1{{(P9B-E3XGm*>vnsw$~{GG,[AGp2cjBTJ2RV-R>HXemu>n}k;jav7HjA
    Ij{>j$[2zUUX>3jVeIB7RlI?#H*v@mxWKmr{]zrnWHau-la-s=j1\\C1C*2QVuYUzD-wn;<TJrOa
    ?Zs~~s>-,iI-TIe<*^7nj(nIJ1G?{*q*WOoxPj?]ZxBQZjp1#l#+Rl!~TIEaBW*UDZ$zo*oDubOr
    l1YZB7,saI'T]+S'#HvNn7'1[E>A2xv{BcR5=3nnr}|srms=}=<1m>7Em}]dk>^KXrVAb'#YGj*I
    5pzX]xkQXV2x3AnZ^pZl@Bv1pzI5I2ek,X}*$\e?RU+K{fsuvv*=!<&x#,XnvI3p;5r{r^R]r1U?
    }u>]eX^A-2C$*^ewr}ix>73@_p*k[IG\~Q#Ax5#Z]@m^kAZhv\u_}Q773H{Qj^s}o{>Ce+;^Ymsp
    K5]Je\$T(WsGsMVRrE_@,3p{*W[x]jO=j;EGa'nA'z<]OrsBXs[Oo>x~Al-Ce37O5UiX_woYJDyh
    WO\5vLpH{Ut$},T~>BsUaGegrXZjYBs+GTpn1?27,;52m\<GwYZVOH!*qlJsw_aa'lk'EOo!_aET
    ~u$G-peEWeR=HS*}RAQDH{YnnK7T!x;B~1ZwQ5-$Z5+CvpQXR~*mw=snOWIaYu,@s{=W22G{TR7W
    $wzXmk'~OT-l1,<]WH^B;B>+2}\jEUT[XnlDRD+=Hol~CkPN\$+EMG<*!5,jwuVl'#$,pdO}G^j?
    >YjuCZeBe\#=\uv>=eGrQpr$wZi[Zrloi]1xW~O>BUq)0f,I;+q{V?mYmx+eW<p1;}{C\;WHo*DM
    Q2D{leYCpw}'+Cv[63n+D@'IVVQYvixV$O\vvU{B1Z<*Cm7[EX<[nkRE<W<OeasA{rVOK~,<+KvT
    @Tr=J^Z2?PaTuROI=z5IJ}GRz!TY<u+eAs*Bsj#}[EYn>kG>~Gw}CiDPvwn]@r+Dx+=uw{rHua>~
    v_+]Q',*Q7OT61JTQO-3Kd]kvV5e#kd:gk\?{z!+7m*}@re~?KC<#sk*Z_Vm@*W^-C_*V{Twl~E7
    K[C$llD!VO_3n@{C['c3ps@'+v>'zE@i={sA7'mwsJpCk'[tDk~[mq-lVx9[2e\>Eu;G1T]a{{$Y
    eG;s;OCJIuv+<Rr5~r=T*U\oY_XB+5?v^-=@]T3JTD3Ix?V8(Hj^UEz-v'r<!V=wU|Ds,C#Du1E{
    ='O?Q{?l}JW5eRv!m!*mH#C[ARG!+W\11GKxeUvCw^n=EVGdXjKI@<={6w5Z{Usk#l1BED^+?V+3
    !tv^oIV2+$!eimJ>a@rUZIx'!CxW;Z7iTB/H_oQC2J^>UBC=CY3_*QsjY1lG<n-X}5*}7EV"YEGD
    HDEr,s5Q'~RH}BJnP&V3C;+[n$DzAe#1Ak[QvDs^epH<2[_e~#lO}rl;TDv@>[kr'BBX[_!AZ=k+
    $J;1Cp8uA<?Y',u.QT=E,-Jo^;<uu+gm$33![uEO'!{k-V2tQma=!>=R4K,2'%iVjUcz$Ax]}IJ5
    aUXs-7QD'GBCZpKu\l,Y2mGW^;kIaD>s;IGWBK+F@}~>UE1XO2wRr#2oRIU{E$CEX^]QQUKa7^WO
    mr\+OUOnlKA5j'=,[;5T<G'5,*33rUO['<_k*+RE1ICn-${5=umJ;HJW^$1QA^V[U=zepzYH<oYX
    x^A-ox]X]JvGV?XTspuImsK21x{r_<rR=vKC"|p1xks*T[p#{JYCus)2_UAB%aeaD|_wvVQD{@AU
    GlEOsDJG~X<Eu_C@>-ZCmz"XHG~CBZVks!7Zh#OlE0j,Q2ZU@v#jZ3vQH<|*k+RI_7s]\QE,$$kk
    >1upY=~k+>3mXr#1e+26iXH=u7]u'rV1]DJ}Z-AB,rZJQH5$xG1i+}HJTQzXOT]3xM-x$V,~oC,w
    ovETE$[\pDCo7;[H]!^ATE^';o-[{_HYOJkwKJO'#~^~3Il7WGsjC+X\kjin1n@><zE\j{U'ZGO>
    +*<,3,]K1Ux$wk?lxTGH,u!pO!5#[?A_XJC3]iHl-UGO1~>OUX'a;?7k$oe+\Z~]p+mx<@A{vW\@
    TDZ7-C'uHZY1'iOauH#Y^v^zrqvxT'5\z!@1RTWnv!%r?J3yo-IHH{wvYwUJtB@+1H_5i<**^U],
    >BH+'oZV+KU7'nlu?a{_TE++]BE[]?z}~+C>v:HC\-M]TJj9UnD!p^pQ<8E-='lp@Bj_1U'-u\'s
    n},^=sIj'Dz=iZ{DDu~>U-J-7s#C+QU=1kQ+X$3^B\D^\DPY_}Yi55jqa+HksRInZA@>,Ja\WrTB
    XUm]YGI7$e=GVA>=)1?KRT-Dz^\OJ5rW_}GzVvG_Cz"{A+JrVz#Ijsap5oO8YY{uI?m$Zaz{$K=1
    1Xp{p=uK^>2p#C]U,k<\s*m<Z]=J^5VaGji>e-,mU_XG-nBrI,eZaE5{MrRwJB(1k$!!7plw<Ys+
    x~omseHpWl7KlJ^t:Vo<^=<wot[3pEV=31,o-QUI}$43jTa@'L$D;A2D-D~\{U|['vp;nZ@-_AQI
    Y<Hkrn\;ev=e]mlGZY;7u<Y4^U5oT5HlA_EICpa?{^5{p3@V?{=][OH{;Xuj<D+<'<;Ip>X\EYnK
    ->sO[YRj'EVHjYBoR*Ip?rr#47uAX~XAkrea}Q1v3a^O#RK!kQ<H<_Z3_a$@m$,sQ3^-ZV'vz{IJ
    k*Z7Q#1+R[E}CiH}zxi7u!XKEH$1~&Y+]i%[]^aw*Kw_HD=QoEQ,IQl#=3DTAU~8?lBk#XwJ'*k5
    fo>Q],A-IB;u?<DQW0weYizwXX4ru7=}DI+B)\W-;7+3_scIC]!Oe2TH=el&~1Jn2H_2xeYn^}kC
    ~oB<$alJRexC)TTu~,*E-R=;')Vvm]vvz!Z<JQQ@^JhvXZ]Z]<5p*HUl-Za_7RYeJ@Z1DTHJ^jRw
    ^mI$Z!W<D!QK><]zH^Xkew=R>5eB$+2P@^a!!HuJ]kOkEDjY1NNl]{\ilV_oD#ls{RC$>H>rpelx
    vD<XlW#Dk{KnQewIv#7Up>u{$,Rjk$K$vZ?-R@}9B,k],,53xHss$mzkCIrDK<n,iRK]g^?!7z,}
    =THpEQ@!wOJ2$;\lZ7>U@'o'n5oB~}={wW<V>XRBo*_iU7B{pRaBpkve\w[WVuv?l&KExI]piQnT
    xIa1VnmU1'pkzKua!jBwj5#7k^bnC\K5@@\IAwaij5~;9z=EX_^7u2>nW[E5e-{;^Ym\XNen]v=l
    k}MEu=sEW3H'El{z_A#]a,U,xZ=lQk'r+~@#j*3,=>;I[kRjn}Cs>3{B?+<tE!,#Me7DQz{+WuU2
    HE*~E,GIuZ&Xep#WUT]_As[,JH'p>2\:mr{;rXopK_Z7I#O~7[<@ryI#{kIs$pf!XABlu5[XV3B]
    WO^ewZaXz27aQUrvWxu~l;C_20-7Cw{+H#LJ1j_j+xAsv]xJG3=u5=JEGT{53+3A1[amHwRKRrOX
    l#TkB$sf}+ROea$!\ER<r>o#arp7H(I_DxKDB!Y*+I3'Y7UlX7<jD,5R<jpVZAjG@\*<1\ID11vj
    oZ{nTBTH}=}k]{wsB}iDo#~>vj~lT'ZR\RB3EZRW;-ep?3xaB<MjW@exeoCp\GjWp?Vu*[o{wu~Q
    i=HMHj3]TYwJV1jx?}A2sa_V#|RB1z\Z[vIC@jDq1/DY=-3Ga[>[H!lU<saY@]}mpCZ]CJ]3!2#{
    $\jHK}YI2=g_>sJlulR}~IsAGC$vKo3la<*k1Crj1A'>xTrrs2eUe[UEww{1w]!XX^-*#5Vx-!*]
    -^'3Iv+#'romBKRl{@,x\?\unBVoAKxe3Ya@[e{lUm$apx;[qm7D=GiAk1r}-(^A\vOK1?z^GwBw
    <Qn,E7FqDJn<x,ru=^HKOl^^B}5Zj#5WEk2OD{*VQ_HWHCxa+CirvAwD^v;w9x+23{-O<m,GI#_[
    <_wV_%BC~}]~Jk{Ar~p;vK].8~sHn]Kx'oimW5K+[AT1vK5s~T\asx=WG,2[Be^{aDZrGgpvQi!j
    #^2nOn-CK,JY5,h7=+j@wTx\m=BSVO3^JrA2pujXu+HY5\BX3Dr}?nAJ}nrplJ@x'pI=Ow]vi7wZ
    &EHB5|pGjo0HCGT!AxHx\v{OV5oQWl^~>,KpA{B^}+uaX-wbo5mkDUm#-{<seY$<zJ1~$nK}nI1D
    eZ~!AHwnXvY<2rn?}i@}$oE^x{U+'avjzWa'?U1O3BW<|[rZl,iv5pR;5}UBkxzRm%jmZ5wO'R5S
    K_3]LZGK+&{^UBb/7WmsGJXsBJRG)oJ{pW>m\aej-x}[~5=B?]nl_1D]E+^@r=H2JG#~!azl^QCO
    i;v!QKXxX,'sE=@Aaan3=x3GlkN2aaT!=~QKv,Ql}urxF"e_iZ1ex{O+*K>Ej><*sGvHp;6j*S57
    Y1xZeZl<K#_a11i_GUp32KZ*+~oY'xBWs5b/Ae<]=KJ{HG7}rfsk5YBI-QGxO+:'{A+UlZD=>Ga)
    nG1mVuXelG-Q8?,rlFliT-'W[$D~3QzTKZ=IeGE(/Ozi*n[pwR7Yo$iowR^j>,i;#oGX^n{\K'Ts
    3k>IrnEx}&X-W]xkukm<uK,l]@p[T5*_Zlg:ujQGle{QBaEw>[<{3oG~OWpDiz;ATAu#wQ^$IO;]
    7kp]-ej,=Z+p}^Y-#x+vG3YAlF(QAw]IumZU6\1VHx?G<<I!,[O;O}*vzsOpo^WUsv;I}{s#@tx<
    [[]G+sw={3JH>O%7YxI*V5v2lEp+6O[GROo[u{o;-Q*T-Z*Jz7{~{mYi!xz$X]+{pAxRr'Ez7m-_
    R+5HQ]xJvIujv:*[$v,C[\X[\ne<xU#,a#Vm*HI[iTarGvsDDn~\m*Y{YCtKVVRBiIAN55#>^Y==
    E-CA66_GKV"R2YuKlo5Tw}#m5uKWx\lDnE3zwuEUUv#OpC*nCTxXYnm|AI\'\vO$k-\wme+viG[n
    eB?U$$CmAI<UGs#$.TTDHzvo-+H_JoeJ}j1Jp{w<\DTxz_G_KV!xG4Q$1[RE,aE=$GXT2Vpp=?Ci
    KZ=5sY:avE'^=J}uI*Qm{+;V*-5{DTJc:KYG\w[@{s}jY*BelCk_j}+~5>_D1pA'W>-'\~XD<Sfp
    BT;]\!r?s=]_jjQCsv,]l>YR_eKR+<s60cUDHoR#w=WIJT%x2_UD3++>+C\4Xw7;@*#ArrrBluJC
    p1=lREW$nIJnT[Y+uj^!BXECaoJmW7KTICXr:a*xK7I@BCI[HJExUDJX#YG#n_DWen5}wC_n'iBE
    k[jw$o&}3nXpR<U\3+[#Vws[V,~D;&z-{+n>A!25v$]Q>O-xk[eUGJUQ~ALv1+\za<j0r$V1pzrx
    6UU$s7_1,?_#?[:=5*;Bao<11xTCZaz&a1T=XG=GR'22\uaTl2wCQ}x<*^CXx,-s?^]Gp<_is]nw
    3{!kGB#QJXl^BUe!z3>^w_A~@EOakXA@*=*Hlv}G\wV1a^anmo}5@<Z@Zok[<r3!PEOKx=v;YGY!
    TXjv'o+,sDT,Zmz7Owz,_jjVo2{!w-\O26IUB->R$2lvaU_<^GxOl?J+!!z=5R_p_pEx=wIZYYw,
    II]ABBJ-@an'J{I*5Jo]QRjG=^UR@+Q7=[s^=7e@A$I1I;E!ow0?$DG-x11*'=Hr+,W3A~>e_j#e
    ~eW$XYRv,5XG-\XYH$i]s]YHp#,rXwXqOK$se2~}B1>-OBI{XOVle-o[p{{'1a;zok375G!^:JpD
    UKeQnw*_}=CHe;VWrdvrWY*5\>xYJ^P]k1B~AGTAYoD^5W+xK-?=}Uk!*D<^5QXo[u!smGl<I5Q4
    VjG,,Hm>~5,A-VTowUU5JBZ'}B22C*'pP=r}?$Y$\7vDIO^$x{'52fQHmjq(_dT-J7GClnVHa'FY
    5!2Y~T@<X[E*?RA{<};B_*\BAW$nA><25W-ls1X!OB!3'kma]@>H[UWJr+@Se1n]B?$aC_}KossR
    Ovk!?_^<WDR>@Xp#s}A?K]uDpA=3C_x]A[i7{wx=<$s?_#-!!-Jz,}jG{$@Q/;*j\F7TI+#om>5s
    x=zs#ep3;*\,~Qv*+xg!CZ1J^#}Emo?^)<nlp[e@^_@;rrGEx53{@nO<CA<RZ]rTC7wA-%\@<H}$
    z{\*<13-Jx]Vs'$'w_Qe@W0jiIp'1$rX^B,xanZ'O3zKR;;>}A#*,=1o~l\O=ex*Z{H5W-a4C1uZ
    -GY-BmaH/,<H\Y!!ni\*UE;x@'s$2[9E\@QA{r]G>TQRWwsY5>j-x#J*_+!wYro=DGZ]O!rw5++u
    *,!>7EJ^v;nOjl<lop@=RxAn\ZDO<VY~pH\GIEu~1E5o$7XD3xjIG#=5AVu,{WpBU;CW>XDG'aW1
    j-ZQm'eP7iw'1]X+G=]^DwlV[lp]72pZ72UI{anE*UC~D=G^P?wU_)W>5TQ^js^><eV#l,\3V[*u
    U{oO1CerJ[Y;CwB<_=O]QWW_j350vouGkw>@lTjC=VOWKAjiu${xYRaW*OZI]=<oR3;RHz1s#Ewa
    ve<*?^se[c*!xi~vu~D>+59mj?-=w$mW<sTq}vkA'Y\V'K=2k5Qj]<V=3zpZ}*3~D[v\5jI'RYJp
    kpRGjv71jETZE@T!k_uY7'^I'3{BsKj!$D$-xie{B^+^x<pZT[K?]5G>5z_^U_,oEkK$Bs_Cec$B
    KIx'!To+CKHjaCHU{VI\$_,IVuAQ+OTn^E@Y=D-B35Q<!]*A@H-z#ZaTv>!T,a=nC<\n\DlOBw*C
    l@eA|OCp+o'QIGU;G?Voo=a5;Nov#*<w+}hx$!7f8{I#@M<UTGx?'vnG]mD?pi*sR-<QL_ew]5Oo
    ,{DQ#$Z^}nLiaGr>{pBe*@pE$s[nH@[Dal7]GveBzQ;~{p\p{vYB]VJ<$3]yZ{I@BD;v}v7uw1_O
    @DOrne-$~E,U-A*B?HVj'p^l7~V_>B!x$aVY'G-X1e!\!YAaROV#D_>BvAHYhG^<Ia_n@5E;wz']
    +oV=pN}^euJ*_JOw\[v~]2O5,H7>@k=vT,oA@G\knn+o7j@QW!AV^I:jkV]1O$GU'3]Gtv#-Xsvr
    D{o$'XB;UyJ]3T*k{^Z1KX?>B1h$JxAlO#WC*pV$u'2Cvz1>jAu}GBY=>=3OJT_I3-R'VUK2\e>_
    7@AvZ\Aa<{w_7Uu@VT-I_v_janK}r'Uw+G1V}J,l[ansDZ'~^?Zv}']?zK!|WTC^u*rH~Cl3*\VG
    l~1zujDub,zD2CzkQBonm<j{W&|WC7UYrip=>@-kA*55EWB?[5u;}BAb'ZD[DH@+v@<!Kz?WsrJk
    BkaQIIBlksm{-H>7Y\Y?dkD+w$&lKJ[>G_oC{Z_\i2Goa-,\1^<e?n@DEp+]H-jV@}Y[u'$*_Y1{
    5#z\Q@Y*b#1[ZT*U,w+EkBIm,mv?k[Bv{]G,_DOI[^X$B<a')QBuXO~YCd]aYsZ15m=j{Y[m;'eU
    }ED$nB[?lR!RRlhis$BY_m'tq]eD'<'3<8\~~];{<Jp>AB+CpH,k7xdTRnXoD+eA1e]$vm1Q_kl{
    l;aCu;K$<a,tP1x\HEO,#r8\{,T=DE7RVQ!*QB,?GZaLuj!+3Unm0sZ]EsJK_\1j*O#s-UXTvJ$!
    Ks~$]<=;$Ie~[wp;-r\iKE?1-k-l_12Z!3n1I5[>uU+BmUQxvDKV<dhD*no8?x?vjj<W#vC$p;}]
    I9"\Bmlv!,[wHZWY<GV[IAI}Gr?g*!'Ql<^W,mav0|'JnYT7,QQ}Q1zKR3I[2w[ZRkMi&*OCHX{5
    AB!7mGoIrE_CvX{Uri\XKlR=We#AEka,}!*;U=E\_]_s>C^T!jmp*mr'G5Tp\upmXp}nl@<namU^
    m,n>nID'jR?rwZsW2Q^xz]]H]en>K2V#!e#OYwDD3KVDK#X;^sWlw[nrOwpU3A5I#a1]@ae_<<vk
    m1*U#x*^s+lwUa+EE\nEC:[@$pE=r_)K_7Z3]1w$n$nHasmC_3oDpz~j=JjaQ-<seBBvia{!T}lI
    +s,yV;v$a]Q'zA>YtA>sWoQT2pH,H[!5Z{&Q*uRwwj!J<lJ5B_?KC,dajx2vW2?$p*v}R[Bw=*Zh
    0?*#ASO<<k9$2aR]^A@J>_>mC*pI!z@)]-w]}wJC]D*O7n}G$z1iV!3r7!I[C!^Zp1[OR7YTZp{r
    tD-;@O7QYymrCW^,-[suA@*DnDJ]UE]m@^m]*3IHzDwIU1~5?1I+1[R2RQY+!<!7OTQn37sz,IE3
    UIUaoGHvQ1~++OxeA[cLIk2#5k+C7oA'xl@T?x3lw]YG\{DCz3}~g]a2]wBK^l<e#Y$]mUjk!wU<
    ^QHIx'aeeO-ezfnR'#MWBk_ioTl9E=iZ]5+jZrk5,IK{>]]_#l}$e2l@@H-oue2>fXXVpxsxz}k=
    sTw'GF|E3BDTU{<]^,Ru'*R@{W}T_51IQu>zjW5\C?Cx;wH_1]{Y=?wA[XU\?l#VkK<1-<^m7TCQ
    lR~Teu=p^E$e^u#'}?nEpv,<Y'?2rE<p++Y#oer{5<xs=Y+il@DbepEDMUlW~mR7+xm+jz1i;?BG
    @>D<n$XBYrUx~s~>!1={+@'jUiv[^2_Wa43'ewfTeGHQ'R'^}>;V#o]-zw}oEYiek]rismz%RXY5
    ,o=;q4mCDrXQemJT$l<D@Am{A$mQ,^[+oHC-$#=jVV}7O<r{Bk,}}CY?mlE;2nTl_rp$i<Y3UE>^
    j@rs'wk>rG[,TIG,za5e{AzF}-[VJX_D~x\xz_$zl32sW5e,*GpeTVi,TB<V>1AGH6IueUCnsw<Y
    eUBeUx*@uoH]Exix{UUh9-,UK+[1BMTI!#ZGJZG_>~$3_IW1Qs4!rk<ji+G$GK1^>)jZsm=mli2T
    !}"7JpDNL[u~5RR;R~BToEiTHO.^CGKos1,IzYx\[Cac}5a}=71i\DH+NrAukWQO17{5YjJR}iC!
    s}iUWKono=C7iEAQTi$2}5ZT]'?thLkO5$z->H:,lJW$sRzq<w\_l-[C9?A~T-I!+~ewe2BKZXY\
    Z]T,[#az;uRCaa}p!I'?O#,sD+]5O7@RArO<n4wG1jWDsswG]xonDJCv+Hk[Q\#BKD{OE[r/RCwX
    TRnVDoEUXs#@$2o>CUV~?YU?z!5i$<z$I-zJx$\}?7s@z3J+G><;C5l{_{*p]@wo~AE,BYWpzUDr
    -D<WY<@DZw1<HUrGYKuXWU*5V=XzX':7?o]~ns-Vs@=BA\;cv;AprH]e7#VUx5[p\,{[>R,v}!<-
    4]x+nJrkxJV{pem;nm'[7#<526TwZBn=lK[{QJ-B3peJp{[noI'@p2Q;Yorol!o+VAv@7k7;}VH,
    2<u6CK['I}=5z#psB#VZ\Zg_'V={awA\*aOe?]\]sA^TrEpWY2Ki$vB="Y0WRTu*^QWn+e5p@AW#
    =[lzOCz';r==~\-xITo*+<od?\<[}lH=li^Gu,Vo_TCB}E@I[m@a*}+oBlRK5J-;AzW7H{nre}U[
    {RY'=+o-UTnuo_=}pZB?huB*~B;IRY^]#l\h$\meKT^@s!]75<Wn<s2<>wZl+-;W~^3!~wl8*@3T
    'W['a{u#]^qEaG'*l~B[CDiwa]vAD[Y@a{TQt>Gj2B_=V4MmY5}{a*A[]Z1'e'~<|8[!C_T=;$xx
    $\7T7'wVlj-^g)=r_e[xa<rx*z~IpGe5k{>s1}@C=^&\}V11?~EE?_a=$EkRei_?1G<a=W's_joO
    TR;pX1G$<a~YZo}PjXX#;RI#-*uu}w*$--wu]TT-K5$lR.R=lvP"xZ3z$*aa]o1?f}5$1]+E3Uw=
    '/jV$[de{{jl{xoqU[YwHnpkLu\2Q}!KA\WaI0)JV']j?D2zU[p|z_zYxDAs>[WD$ZDs;UmvC3$}
    jUsvjfz5x]yOTHx)bk,vK7n3=t^<XGjI~^Ap?sU+*lBCX]H*CxUjrXh]AZu<AB^-1aC-RY<[W,Bj
    $TsU712ht]O5T^<zIQE\2N[\'J6=#{K.?rA=_vKUATZ*BZnY|p23amL0Qkw[6W1+{I=aB}U^5H5E
    Y2zBZ<+25lt\k;~}#Y{<{JurjZ,+7^~YW<?5w,>G=YsCK$;5-!xNGi=H9w<~!x@]RC5*I@Ao}*n!
    uC?e#T-QI;,Zvm1a#a[B[1uaxoe[G9^j3{sBQ<C[>u~rZa1z2+*s2Ue#1Ua--7]O2[[m~]Uo?;[T
    <w3$}il#R!V=vQRiZvGmD7C'z'l~nK#GB;GRC\EUTk|r^x1=rI,J7Z;2[EwrT\]l\?Crzm+-GJD{
    <~\s^-$-}Bul;O7TRRmaDI7''<=(zZX''z++Vr\_aroGY>TOm<Vz_@Xztok]-[JGYprp-e[VkfO*
    n$e-1R~UnJ5kp>qUwp*Q#s72w*jiGOD-$xrrW3{d#pEw_wn+pR$C:E}unFiRVuD#>1o3GA'ee!=Q
    r=%RBkZ\H5U;v#KXXaj}xV@1#errDp~XrDWKXY~kOBz-zlA=|[kD^@Aa]+^+^tQMup>]XAXACTQK
    }mzQFk-V*Wxs3Rk;Oij,}v,DI91!n!jZ~\o?A?xk=sf^RakBrE$H$5@}lC1K-]\_ppp|GzQKBIk=
    1lxr^JjTEB[w=I<OE1Gj,pE27XnnvlikOY~aj;CCxH'z+j]{JlTVKlRD3CZf]vDaqL5mQQ-I#u\3
    7ImTOGn{jx,;DR8{TYzD|W_WAvTW>Q5@[XVoDTInJKXe?Y=5#@{;K5H2K);']=RBA3l'J=jsU@NI
    +CvcI@^}3V[5=u*{'1J~VGsBmX5W*Ip5kUJu[^_jD]nkmU_-5eIlzxlWkxQ{73J\EArs!oCoreJl
    x$#k*?E]a+z{a-C[;]BE=+U]r,lB@BAWWBYv+QGjIDU[<}{v!8mj<{i8_{<E}51KkvraD}7u,7+;
    U7-7#Gn-ClKv,-5\{G#xjkHx}e;eO,Jso#Qp@',QT,D1;GwOI*EGo\^1wXl^B*]E!vxm=,=Ro{*W
    Xo'$eW;Kj_Xx,V$*{_X[H}!^\K3zPQWK*{*QDg3z+B>+-w;[\eAoBHu1YRY'nOBI=D~eX<o'Dk11
    u$*-lZQ2]ZwC+p{R>_|3\wVi'{UbJTCj2_#,#}D=hru5AnQI!ili#!&6e1+o_K]I"/Y2uUPiRmT9
    }evB$Z!@MBIT3-}p?-_{]C{[Hk{$OZDX$r?H_sow}*-v-j<ZVY,]7^5-nKExU!Tm{?D5]$i}<2G{
    V#^i5zuzwc1TK~><\-Tns=5{x*^$!>pm+J[J;RX*K^eQmYn{O>Gr<{x@De75e}z=#5H\,!CHOxxV
    5-C\>V~7DH#lVjWYE~Lf3x#<BH\<aRajwVe}BE,}Yv'^F?Ap~Arsx[]kVF{zuaL=Jou01w<xEJ[<
    xBB\EA1*kpEoZO@BoK;1Y{Aes$rrJ$;Ko{5XE+\<dk__lJ>>?:[piCLQD]Tcu<'!i5]G!nsmB-Z#
    S^*O^VYik52X\UVVA[{E#_sik#=,kJ{,jkr@{JDA>dJjupR]>z}_U!'}=jWaw=~Xml-a2^k^AjDe
    K~EBk3]OO5QnoXEvIOv']1'~GEPXDU2U=nei*wWIV5}NRf3}-wh7k*A#}m1?e~zeCYA#+fImOj?l
    [KwrkQBm}TxPWwVj]pm]z{opjTAp'D2x$eY\lp?nYe*[x'vo~'\xrKTKVx9lQIQmX->Li+E?C$1*
    TRI735KAllB!%(O']>fWEAo*H}D)V,J{>-$}Q?eZDp\W4T>a77{l]H\xVr+D~k\w23au,'#T3oDY
    Qx!p^^W~aZGv*i\G_5*XVslenMK{osei}lvC<5IyDmXpw'+;^*-$1*?JluBA%R=,*->'kWrOEK6$
    <Rp^zXr_=7m{}7um>Wc1H\OKn]A->=1Ae*>[ao_z{H\$ABIsBmk]a[w;wpje<vKvR^IRVsUIe3!w
    D@2%z+zAjes29ExI@EHKA>$_x]}IA#\<U1H<alU<R1?\KIQi,~R]X/RD7$qTnQEY@G\Te+;Xjll;
    8AA2UrOK3_o[1K+ojD*~Bn-5s*CssVw+['ZlX};<?vmH<,'luB5KCQAQjrs^O_VW+^P#TBV?1RJI
    oEWV!_H#,mp]I]=DK(]j{a'e,@jAmlQR[],x#C}AUGjaBvn,#>O7=k}2o>H5k{Z]>st~RCOQ5lrV
    D]~O5D;${e5OaOlVaZT\ZDTov;>I,k<,s08Mz~vxrn;JO@A7*\nU5IoG,Hl\13a3(Y;Ga}eVlwI2
    =\@'JJl?RB73W1}Tp[\iE'U!eb*-BZCk'xj!XZAe>n[eCI.lp[{m>>5oiX~E1E;!QkRZ]ar}Avi.
    mel'UIIvTr5Ier1$q!*+Wl}$3'oxKsISqa};e}x@1z}kHo*xJ0$1H+7A!zH<W7Unn\W[#s~eR^AV
    u^Gm-w{R=T#E5*(GWQ@Bi~J^U\mJDEr<XsKO,OjP=iI2u|#1mvKY@ka&Y'E\;=[74}wQpSl-Aw-Q
    -K_JmoG?s$1;Hl;p$@z{Ize>GUB~CO7:PT]$JFVv+}<-5u:[Gi5o<ruBvnZ;8Ge3=v^Hm1$<kFH]
    }xzY57aCB2eoDR0-x==ouzvO@HE1-q!VB]EREip+~uET;<bt#avx_1*;;7KYG;$n{=sl,JIkn_i]
    2p=w$WV?EW*+)}ZUR=D__j-xx{E'a-_lV?]ee~EeGpRuDre$lZoVYU5zv*@7KDC*i[#w!l:iR<Ul
    Y'@kQ@uBeYsBS>pe5'ar$RDI[8:ysJEV'-Vp\@RQAoeuuR*@[SH1!l{,eK82l7;H_@HIUQvlDBW*
    <AO#7x}*m,v3hJXj*wpKT[UXQC*G1pX;pB{'a@]sxjW;XO<ERY5_rC~;HT7C5DKrGZ{e>oJ2We?H
    ~o@Z@fiRKOv33Qx5WInTu~CV\j{jV'5B-ILx=o}vi]~>5o'a'G}/K]~~517GCTo{_'UD[;;UhLQo
    r>8w<eGxJY@ulx]|3X{Z,Q~__,xo;$}V*]ae=Z<RaG,rlu!w3<QBz6uDE35EmC7]AJO\EDm+lU?+
    1]+$H}^{_vv=zUTTa{]ri3<UG7OE?7jB>Rup>zIGG1];sH+OIvm<=CE2C*+<,QEYaE7}Ov}*VGT$
    iz=A_aSV#XOI,Zn\2a2CZwZGRC1%Ro{'O7\l'G<HH]r]p{5]{-,u~'z,Gxv=:v3TkrpzsIsVD]{\
    urpO'bfYAu+m5uA],#aXvu]-nx{UUpG[EC,'eQBfm*}5z}kan]^v8*e5@Ml~1z2$v~V]#1_lH\uz
    H,\^<u+QsTR]\VH+Xp$mp@BuHEli5zVC<!7@vaaHC_!wxm]-D-$YwznEmuWn3zvAQ_#aS;$Ak>sx
    [Iv-7HwDaKT$Kge#eoh}[W1Gj@z#l^>Y!Q@#=*CzX;[Z$o?a7u-rRuA,W@Y\3$l[r<+KoYn:B7!*
    V+x7j*pZV{-~[pZ1Rux}Hn*U=<7!@\,=uN}o12'B\oe'$uuV7'v2~j<QweV{y=]_Cms*[5B#HxmC
    k0/i7j~oe3n$O*ARpJj%>,5zFqb\^5~BN];*2m{R]OU+zIaIsJ^!x,uZvn1*$7z7'@+Tl=x^23TV
    Z[voz*7@Q#oZAQxIB&Hx!=3Tns=YX57X;H2U+=x\,=Up7Bp],]R~C;51DW2Yi\W{OZL_ux@3p@XC
    }s^]l\71$'QkT7jC}a=5B$3xUx'hU\AKViK7FPB's>)3\3sPE=5_:7CK}e>@<eHmQQpUW<oT,awD
    sxru=cY$@Vl^!J<aD^ieO7=us}>T*mB<UQ~Qxe#B$i5v>A'![!^?HQ{U]]76Bz]ks#'Y0HE\p7^A
    B2s<lij<p:a5I3,*j}Uw*$"iI51U[nzPr-oErW5v'IR^}[A{{xkw]XUUqzW<Bb-]oo]i[uYaB_fK
    aZB>5a?7Qx,KzA-|l^x;KY*TR~H>:R!E+=joo'Bu37mJp@BkXUDH^vkVA72xT*oGr,aUT'CT~XUX
    D*H{J1vI]eeR^\w_{#lup}W'Cz~R>'bs5Y~'z*OABBp'kzll@<kpwmIQHW$zV>nJ+TZBXplCv~2z
    rl'djUr<De{VEa+pnepHk]5AoC[Y*DTX$\*<Wxmu^>X$HzVxI~[u4awjiV!Z2Ce*Ew,Ciw>m@WYT
    sskDZn*WlSs[mzmoGZUXX,S*sVi,uW!#=@z*2@7nEX7Q,u1;,x1xJr[}HKeW^{WY]*HjE^<:_-[~
    !TD_(fw$Y1Y>=]le+!^~WXz[$2e_p@2Vo@Q3w$_pWU?^wenC*z)\KAut5\w'RC@TCO\=HnK[_s]?
    An@JpklA5e1G#D5Ch'HKeG7aI3rj{RGxsw+>w=pZ=C_uAz,V<buTU3EsT+<_>w[knO-5Em#=-n&t
    $^^ojkUo2[Tm]Hr!=xekK=+!]$<#z5!}/=\nwICms?\2+-XEEK,\[!w<p>(^=z3^FcQeRwf'Q{$y
    ckHCZY3<Usuz[^\,[%vo_T)S3Yk]]3OoR~[J['lA<^W'awO{_ew*OYX=6"a*o]isT]'r\JxywVmX
    UAm{A'DJvp#KwHs<2}5=]]TQ]#<o5Qu>#r<>;a!Rtojlsm^QO$o>T++uWgnrnG*xvzIH*z3B*H=B
    T<-xX;n_Av$#~5?\+a*vr?#QCr@VHZDsHeNyk}7RH=^3R1']]R>V}GOUJY\Zf%fE}bY"b%c25THG
    k{]'G?!HTp{SHrvYYOUa#AFHQ7e=KoC$ZV#v\Wo,>nBpQTBnn]vwUpv0h,W'QYD+#I@I-S{a=!g9
    l~EIS>C5>A]mv^x2sEHj;lI~*o1Yl>v3nz>A}#.E@pHQ-n^*muY?Ie~[r@HI[?Q1>l@w*r>Rdhq1
    ExuKoo2[mZJzAUGu+riw=IA7/$en\sWYv"O1E!]ij$k{r]RKn;^j-[^=RU,?[AR]piDu1e*-jAk6
    $R>-y&}W~p}rD2rIB,'C{<xs!@#CaJ_[ZCGX{A@BlnQo@5]vTZnE2rsnnzfz-^r1uA-{lZsSBW!'
    z\*'H+<GY\=-2GzaRGzUaOC$>HUoI?=anX<W<V>R>Ykx,mx[>Ql\!XZp"Bao[jkr_?5-U*5DwC!^
    TzkTu~ogO[}B@pp~kYR@nhV-!*D;Ol}2li5+<}Ym_Jp2<QL=?I?mEu-p!KvC5e;B'AV[kr[WY}sq
    Q#7Yo}?eR57B=K7zDW^YDv2
`endprotected
endmodule // module vusb_hs_portctrl_sie

