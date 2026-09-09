/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_portctrl_sm.vhdl
-- Date Created: Thu Dec 21 22:42:20 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_portctrl_sm.vhdl $                                                    
//  Author        : $Author: jabreu $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Vusb_Hs Port Controller state machine
//       This file contains the host and device connection state
//       machines.  It also deals with the multiplexxing of signals
//       from the pe and pe_tt and driving the pe and pe_tt interfaces.
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
//  $Date: 2006-12-12 18:12:34 +0000 (Tue, 12 Dec 2006) $                                                                       
//  $Revision: 506 $                                                                   
module vusb_hs_portctrl_sm (pe_clk,
   pe_rst,
   pe_rst_a,
   portctrl_arb_force_bit_stuff,
   portctrl_arb_hst_frame_babble,
   portctrl_arb_tx_data,
   portctrl_arb_tx_ls,
   portctrl_arb_tx_valid_b,
   portctrl_arb_tx_valid_b_en,
   portctrl_arb_tx_valid_early,
   portctrl_arb_tx_valid_last,
   portctrl_arb_bus_reset,
   portctrl_arb_clk_valid,
   portctrl_arb_rx_data,
   portctrl_arb_rx_err,
   portctrl_arb_rx_valid_b,
   portctrl_arb_speed_sel,
   portctrl_arb_suspend,
   portctrl_arb_test_pkt,
   portctrl_arb_test_se0_nak,
   portctrl_arb_tx_ready,
   portctrl_arb_tx_done,
   portctrl_arb_bto,
   portctrl_arb_flow_en,
   portctrl_arb_tt_force_bit_stuff,
   portctrl_arb_tt_hst_frame_babble,
   portctrl_arb_tt_tx_data,
   portctrl_arb_tt_tx_ls,
   portctrl_arb_tt_tx_valid_b,
   portctrl_arb_tt_tx_valid_b_en,
   portctrl_arb_tt_tx_valid_early,
   portctrl_arb_tt_tx_valid_last,
   portctrl_arb_tt_clk_valid,
   portctrl_arb_tt_rx_data,
   portctrl_arb_tt_rx_err,
   portctrl_arb_tt_rx_valid_b,
   portctrl_arb_tt_tx_ready,
   portctrl_arb_tt_tx_done,
   portctrl_arb_tt_bto,
   portctrl_arb_tt_flow_en,
   portctrl_up_datawr,
   portctrl_up_host_mode,
   portctrl_up_phy_select,
   portctrl_up_port_owner,
   portctrl_up_port_power,
   portctrl_up_rd,
   portctrl_up_run,
   portctrl_up_suspend,
   portctrl_up_wr_be,
   portctrl_up_wr_tog_en,
   portctrl_up_port_chg_irq_tog,
   portctrl_up_rd_data,
   portctrl_up_wr_handshake_tog,
   otg_pc_data_pulse,
   otg_pc_id_state,
   otg_autoreset_connect,
   otg_pc_autoreset_proceed,
   otg_autohst2dev_disconnect,
   pc_ophy_bto,
   pc_ophy_clk_valid,
   pc_ophy_disconnect,
   pc_ophy_linestate,
   pc_ophy_pwr_fault,
   pc_ophy_rx_data,
   pc_ophy_rx_err,
   pc_ophy_rx_valid,
   pc_ophy_sess_valid,
   pc_ophy_tx_done,
   pc_ophy_tx_ready,
   pc_ophy_disable_bs,
   pc_ophy_hostmode,
   pc_ophy_port_speed,
   pc_ophy_port_state,
   pc_ophy_test,
   pc_ophy_phy_reset,
   pc_ophy_tx_data,
   pc_ophy_tx_lowspeed,
   pc_ophy_tx_valid,
   pc_ophy_tx_valid_early,
   pc_ophy_tx_valid_en,
   pc_ophy_tx_valid_last);
parameter pc_usage = 1'b 0;

`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 


`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 

input   pe_clk; 
input   pe_rst; 
input   pe_rst_a; 
input   portctrl_arb_force_bit_stuff; //  force bit stuff error
input   portctrl_arb_hst_frame_babble; //  protocol engine detected a frame babble (host only)
input   [15:0] portctrl_arb_tx_data; //  tx data
input   portctrl_arb_tx_ls; //  xmit pre-pid for low speed through full speed hub
input   [1:0] portctrl_arb_tx_valid_b; //  tx packet framing
input   portctrl_arb_tx_valid_b_en; //  port controller transmit lock
input   portctrl_arb_tx_valid_early; //  start SYNC early
input   portctrl_arb_tx_valid_last; //  start SYNC early
output   portctrl_arb_bus_reset; //  bus reset detected (device only)
output   portctrl_arb_clk_valid; //  30Mhz clock enable
output   [15:0] portctrl_arb_rx_data; //  rx data
output   portctrl_arb_rx_err; //  rx error detected
output   [2:0] portctrl_arb_rx_valid_b; //  rx packet framing
output   [1:0] portctrl_arb_speed_sel; //  indication of port speed (device only)
output   portctrl_arb_suspend; //  port suspend detected (device only)
output   portctrl_arb_test_pkt; //  send test packet
output   portctrl_arb_test_se0_nak; //  enable test_se0_nak
output   portctrl_arb_tx_ready; //  tx handshake
output   portctrl_arb_tx_done; //  tx_done
output   portctrl_arb_bto; //  bto
output   portctrl_arb_flow_en; //  indicates port is in normal packet mode
input   portctrl_arb_tt_force_bit_stuff; //  force bit stuff error
input   portctrl_arb_tt_hst_frame_babble; //  protocol engine detected a frame babble (host only)
input   [15:0] portctrl_arb_tt_tx_data; //  tx data
input   portctrl_arb_tt_tx_ls; //  trasmit Low Speed
input   [1:0] portctrl_arb_tt_tx_valid_b; //  tx packet framing
input   portctrl_arb_tt_tx_valid_b_en; //  port controller transmit lock
input   portctrl_arb_tt_tx_valid_early; //  start SYNC early
input   portctrl_arb_tt_tx_valid_last; //  start SYNC early
output   portctrl_arb_tt_clk_valid; //  30Mhz clock enable
output   [15:0] portctrl_arb_tt_rx_data; //  rx data
output   portctrl_arb_tt_rx_err; //  rx error detected
output   [2:0] portctrl_arb_tt_rx_valid_b; //  rx packet framing
output   portctrl_arb_tt_tx_ready; //  tx handshake
output   portctrl_arb_tt_tx_done; //  
output   portctrl_arb_tt_bto; //  
output   portctrl_arb_tt_flow_en; //  indicates port is in normal packet mode
input   [31:0] portctrl_up_datawr; //  register write data
input   portctrl_up_host_mode; //  host mode enable
input   [1:0] portctrl_up_phy_select; //  use serial phy interface
input   portctrl_up_port_owner; //  core has been configured (ECHI only)
input   portctrl_up_port_power; //  port power enable
input   portctrl_up_rd; //  register read enable
input   portctrl_up_run; //  port control enable
input   portctrl_up_suspend; //  port low power mode
input   [3:0] portctrl_up_wr_be; //  register write byte enables
input   portctrl_up_wr_tog_en; //  register write enable (toggle)
output   portctrl_up_port_chg_irq_tog; //  port change interrupt (toggle)
output   [31:0] portctrl_up_rd_data; //  register read data
output   portctrl_up_wr_handshake_tog; //  register write enable handshake (toggle)
output   otg_pc_data_pulse; 
input   otg_pc_id_state; 
output   otg_autoreset_connect; 
input   otg_pc_autoreset_proceed; 
output   otg_autohst2dev_disconnect; 
input   pc_ophy_bto; //  tx output registers empty
input   pc_ophy_clk_valid; //  30Mhz clock enable
input   pc_ophy_disconnect; //  port disconnect detected (host only)
input   [1:0] pc_ophy_linestate; //  port linestate
input   pc_ophy_pwr_fault; //  port power fault detected
input   [15:0] pc_ophy_rx_data; //  rx data
input   pc_ophy_rx_err; //  rx error detected
input   [2:0] pc_ophy_rx_valid; //  rx packet framing
input   pc_ophy_sess_valid; //  port power is valid
input   pc_ophy_tx_done; //  tx output registers empty
input   pc_ophy_tx_ready; //  tx handshake
output   pc_ophy_disable_bs; //  disable bit stuffing
output   pc_ophy_hostmode; //  host mode enable
output   [1:0] pc_ophy_port_speed; //  indication of port speed
output   [3:0] pc_ophy_port_state; //  used to decode control in phy char blocks
output   [3:0] pc_ophy_test; //  enable test mode
output   pc_ophy_phy_reset; //  SW controlled reset of the phy
output   [15:0] pc_ophy_tx_data; //  tx data
output   pc_ophy_tx_lowspeed; //  trasmit Low Speed
output   [1:0] pc_ophy_tx_valid; //  tx packet framing
output   pc_ophy_tx_valid_early; //  start SYNC early
output   pc_ophy_tx_valid_en; //  port controller transmit lock
output   pc_ophy_tx_valid_last; 
`protected

    MTI!#G;X2j\aGR='C}]DT!o'Jz,ITWDnp(l}k[CiIVFi|b<D'\[+A<@<EJ};[CAwOmsg~TYws3<Z
    Iue~B^}XNQ?\V*jI?_J3Txel_!-eG7sr$OQ3VH,3}YV>s|EHH{E1_^r][["Yw{Txe+l*TVR\-BY:
    []m5ER-=D=s#RA\K=k!kZO!vr}s>wrz,5saviQzW2<ZKEH<v2QY~Bu+[e$jpp~^_5ezr}D?sno3-
    pBa}y><u>C;xuQ>{C,nCkxQ$uB5Q]WauVmEas.{*1[<5i^#p'E<Uz1CVC@w]2[xZ'kV<rDt^l-'I
    _@spmp>u}}U*!X7T\DDpcP/<$HKB-oovBzeV_lm4jw_zV4UTDVOm>O'JQK#}\eu=jHz,'zSw}<Xr
    O{$w,~CsjK*WVU<gUs#^H',n,2XnRSu>rwoEve7A'Cn{;*D@DZOVTlWnxTo,;3q";en_*LmA!r}?
    nlQ<[;MvlKpKwOvR1W!7![CQjCunRolwonspE~>]\O_CZIY!]*_}Z+$BW1$>TR{|-Au'>QE*I3zQ
    \8eBvr*?<an+67uHo'\QD-pR}_!}AYx+_7kq3UBG!zYi'L2ET\Q<zANPU\x@Y[v!Kzr@A_?+$R{[
    [3~*\'DIK\D5[Vx^j=r1QD];'PCzH@A_X>:[rj1L_m3r>>XV5KX'R7';,#V]pX1l+X1TnT@HEQ1Q
    Di^>G]wD@Qn^qGI@rr3HY#Vp!Ia;Q-$Op}Z'Z:@B\ud2s@DV1?>p^K7I]Go5Q>woQ,BEK\O~_=Bg
    G'7[r7+@!7Qrs*A\u,^DOI@R]Vn#$6~ne]Q+Zw\7%w>{Bj,aR\,lwn{p;qO7?;OeKHj2!z$#TOQY
    ap}UVOAT1U^KVHI<X[JU[^K+Yw#a3-:?V_]6V5$wcIaWjyijeJp]p=AN!sl>U-AH]6CUv*IsXv?+
    E@cx1uK^vXOowIR~ri!kVGK}C{;'n*XiNB^jx]RQ-OiIrU_j[7wn,~7jG2X5#@D=oIC>57r1i>Ox
    r^-@~~jv5AjEG+Gc2R{II,Z>P'+_l(R-wlY>*rBRn'5YH@Q;5<K6ot$!-zNS)?*BYfz+3OqpH[H7
    oX}PA[r5}K\?n]\}YH'ICT;lfij_YrOZ\9OI+,esir|GzAZr<>[ju$kBz6pz!vH-7U@sTjkD5w_[
    #e)vZ1T'K-A^R_3!_QCwnCXZl0]?xk<EU-2E[wl]Ii'@3$7#T\r[BTi+Y@C9*V2^REk<$oH{Yu}{
    }IR,h[$T7iI$viA}u14VAnsTpsp@x{[s[iUff-<-kf_H!{L35A7~Yp!tr;,CX^#}*KWmK5$-K}KH
    uOIJ,s217@1@w<nvs~5#EZG327opjJ{^YQaGOmz7/~AOIiTYJ$n-~I\WvH^Vj1X7-W}-5=lkH|O=
    [wxCJYPQHXkN0?n<[:H'OsI/l{7!x+!{-z}o=$KkgK{2^CC~lx;pO&O5}iqmll@)cKwH{OusuMjK
    A>f0=oCi{B2]YEsCXTp!8"\C-OiY#3sNC7XQ:"~so}<DjGB7^aGO3=-{AT}KY{UjemU+!G$7kD+*
    pKoU;jOk+_j!}}Ox1*LVzi7xw$vq@5JTs;*1QD$D[jRi=s\o^IKC,?3xdZA=[az5vUBzHskm28X[
    1mDe!]VUA7=0DQHnAr=~wC9{D\2ks7D7DK}7|OKJBDQz59#15#'SR<w$UU^7"^RQ1@Y\~rT\r3>5
    5l>pnR6krnoZnn-++*Z5}-WDzl7xVX_^+=~V5]_}s*lEOrnI~OoA[i1}2jolURi3-^1HQ7vrW+z^
    =m^,BvGD%BG$KxYDj2+23/z*i3x]>pUj7$=I=xE5UzD^\Y1TeZb^nI1k}op#^CuMx![o#5n]3{jY
    aAQJaC}?Pl_0=[r?T_{Kl;vXa-s@')las;UU3T'G\#~U*wx-=[+1mB=Rr]\a'jl#~!IVpjP>E?[O
    m-rj\EC=Zx3>YA?VTUK2<@a#jB@&^@~Te5uOIV\izQvRmx@]'_YTRV}aw+Uk1DeY2X'@s<uju{>X
    #IH{5u;YwTax5ip73n3IYx[ERmGr{{oz*Wa*v-lGBTYpmD2{'x-_IAp{Ccli3rEi'n+}s*#R3;vi
    QW|B'1RNKTmUOb!1x3n=nr,D!sj+^]e=zx'T!}O^a,pn,Vu=-n{>7a1n--vK$wQ*eUS~UWlrEAsA
    UR?5zcwsJHCa7!mzZ=AYDl@Xp{''KIXr#l/l[{W)RvTx1{_?vs2^M?,W^[e*>BiaxK{VzveU=![-
    aDm!{3o*~|q)]7v2W<HU=X]Ct<GB*C#}s7$k$&[[>@5<\RwAzB'Ok_[v],EH!AIfP,a${=!^I~]#
    sD}{ZvAY}''VV,!B~OYuBHzl5'i=OHTTTIepsK{pi$QaraR*u51s@DkZ-'J_$BvU^fK_A'GxO'[n
    r~kUrna1IVY=n\E2Z~[l2sWC5]HnYYo!-D,D*JIs@noD}<K5{O*ZAE?IZHz;}T;R\lk'AGz<\sKn
    pYCMZajuW\?Ie],RO!B_$7aTvrj!uO?\^Tvu8B-lEA}we3jC5Y2{>VA]n=;JB$_7i_~zm!HY-[1A
    j*D1A4[=<7T^^~]v{5^v~e?wIz5kT!wvs[vKuQ\**z-,e!'7iG;'puDkBvXYjD_U*#{<B,NKUsxO
    kHuvB3~VQlvn'vT(Ov;~{[;@s;SB*mpRo\VZ>,$<aW=iBm>H+Ku-RaBV^j*-j-<5'U~WAwoDaKUv
    Y3m_k5zEw'YuG?Z&eJD<>V>2t3X^Q;GeB!R{{8a,kJoC_j?1awp)wEQ<vJXG]kH@w]YpaTT!F-5I
    7V={wG;VHU\G,&s3A\pwl^],U,*RI3(eR$@TaH35lr+65Dw~$,p?y?OWuG-{a7{*Rx^+3]\}I}zi
    ]xRUoQ[lwKCAWlxevw=*{2wICrUHAi\axUr*3QOW\1GX{'DHa7!V^jB;;X{\I@w=xEr=;$X<>Q+@
    vK=kxV'#klkTr2>X>5z~p3TIB7kT^A{[Axu~~GIY@QsoeQI+5BZQJ5px'W{r5j}\IW$Xn^,eD+A,
    eun7RwUz[[T*{A5BG;1~v,3[-wXxxi{j*lYJDF8Bwe@<AJjl?HHUv2v(,KOTCnoTHGXZ?vqIl5=A
    D-!oAX]X]ZwGsYT]\a_'uCku{!kb%u}!oW}Ao1Q2+!awVp2}waj[7~l$@e}X<r@}^MH15Wli+#a]
    pkY<3+:\Wme]~@R8^&ZY}KG3pnC@H2E;_BWRo!*!*,$Glo%H,>U7;oHs^J,~}R?/Ya*7^2[*sCDX
    \Bao;G<<[u_[-E,[E=4zvEiE_G[Y3uB,O5o-^o'#$sOs{eO,Zpa#x}Z5z*[Ve-2r^wYekrYt.*+W
    *~-r3OGiza}#$QEo2jK=[oJO1}_J+[0}T<K7(K_O,JY!$5Iu#_zikuS1.#As5[sOxI!Di[C}@9k_
    D<rl~Ro!*V0DKU3#C2>gBeZ=Uw@p[z'IU*v5{a^k;_2!VKnr9QnW>H*lE1-<@Q2+!1{aU7H<vr}k
    xq~QnEEC1OKpw_=u*Z>**#$R~XQu$jOAB*2]OIh,#{#jkxi4F<XDuswW>,mOD=1Ka2G~O_$Ou!-K
    17?~<-,aKEWjkLKQs+sD3]gZ=Gk*A{QI]O'YCV7C>@;Iu}v7REanO__YYrw,CnpRkA1Ixsxo3zk5
    A;'3>=+,7^#\-[$7#z^GZH-$<8bD#9(02l%<vw[X*?WtX$@!$k$GD5#jO+OG(1IVTD,J>u$TXeDn
    H,?a~o?<>Iz'#IC{a-I_IEpWxo!YnKsiHz2+ApWJ{koBs0}=FE7KIkv\spm'{fC7O[ko_rY1\o}+
    }2zUALH5m+x+BwY^?}Ysn$sm\X^*W\->~]3[#nGQ!=.jUlV2^ATc5Z<RsE\TZa~B8AzGiEr$rYvC
    _Y4\D{3LZv*'fxQxIjXYlUzADnV@mYuW$$U5[]n{TO7H<ue[]mwW2*@YB;TrRZHzBra*Bf[A[Omn
    <{]D~2+**wv~XK/aRK}++V!ZjxoQ=KK-j1^EmA?KG=-RZuR=[[l[S{5JxnnG\zzZ1eO@k!8r*m-e
    =2<Yv2Jo~2@]$[_jC@13{n=fvZ1o"='>,D]{p{EY^3B>mrsaaRklX[AC3(=0IRE]yQr^DH\a_[H_
    >tX[3V<{pA7+!s*3V+se*==sH\7>G_ro3s~OACL!oD#g]5Il[I$WZ\=W_>T2G6|QVE2/?=?WZHuC
    TQnB=k*m]Kx~5u]eQ=mA=-_aO+I]i*}Ql3Z,*zps)xa'U_sA~xZE;jYz;}*}lS~v[e?QG}YGr=U^
    2loO#m4[{Y54#ADZIa<TmT$KC?OEWOKmr*R[JC'WuXV\Z17VQ\vXVs7JvY$JAT5QW\RE:~-Yi1xV
    TC0Z_]BpC*rZDViwoQ7H{[G}p?Z(W7rQW'=YVI#DRu>V"~xW2a-[V7,nDY1T]3IK-=zJGaT@#i7E
    vC,+V]2}'p{Ak&-T,I>GR}O@j=uz?pEO[7aTm$$1#Zsrl1h}nmZ5<>Q?<olmBW;k$xHWDB!uBB3Q
    QAUM|}ApUG\7YDpvikrK@m71$jZCW;UZRYB7~v[Tab3$**JrGe4&YHp>e,pi.FWGzl=YK#]AGaoH
    \Xv!p^5}p]Hqknx7MrUQ?'jl<.=e_T'[={7o=wDis~}+xCXDpHGEUE@aB2=[wBDiUG{-Jr]T7;^x
    wk&Q\^}eTIA;$5}]#BCv$kpQnV*qWIu~oK{;^7~Ge7a]/O^}7iXm'e+aT+8<jYV]i<,wzE=b1Ivl
    _v\ZxeC!H+XwvQ[DOoKTIsQO'j?v?1+p'=zTj5Er_2GJ<o]uei$l3I>+(u1?D}C!A+7QI*i7lnjA
    u}m[YYX]joJs26;},]2\5Vi-~-fiVB2iV{;1.Uv]}$TJDHXjsuOT^'C-RsTu3C1\pewB>,,zoOV~
    R\[AO7Kn,~O{{vA;@<U$QpBH}a_E,n1-Cdjs{7?waEBVrJuITY^5<-$^lAY,pa(zV=z}+YRWY#xa
    Om=C@aW/!_![\oC,?}eUm^JoO,*3K{<~YJIuuRVTx+aviR_[SsiX{^{Hn[x=x5DjGzv~5l5Qu_^r
    3eP2YApJoEu$_-]<\1seseB%ZV}vI^VKm^jeow>zE<D+RTp?@=e\rr5nlno1IH7rD\~'!7m>>[Jj
    RuK~U5ITE+{Z-CkTXvpO(\!D]E0x!e5}mIG>Cl5>jsH6[w;*QZa,Vz?\a{X-A,*<G'UR]@TrJ[DG
    le}*TpJ?Z]KQosC^a7w-XOCXaUA_So~R~kDanB!*^29.K]CRi5!ai*BO#eu}iRQClZ$ZG*YKeW7$
    ,nA585lZG+5HTGc\_3$pYY>SiwvK,<$!u<5xw7sGkv+1$$xGDWUj,32*GX{e"FIE!s~5#Bg9hwT!
    YU1,EYBX2?EEeGrAwA\HwxkIC~r@Xq=,}a$]jWs_Oskr;5ee?VTE,O1=5r'TIUH1VoADK*haR_zT
    v_C$<Jx[KvQeYiD[DO=UT>,}$,x^!nro!{ATOR]$W2DRkparA$[kH~G>[@R]MGK},majKiYCUB;~
    *\{]n4V2w=]#ZYck7!E1E!ep5jQzj'V/@l3#uV?CGJ+I-<-D?z>s1#Tx^GeV!e_uC->37Co1=pja
    3}ovYWmmmE5^1k\$Za]}c3LHn-\UA*iOr;=$xu}cAez?$DkK(k}}-TY5<?r{Y71kj^m@eYP-zHR+
    HuHE5Giy<-uu+U>l055[KK5Tv$[Z1BYQkhkwlV#>\rRZ_s4Q,KmHD[kIJJUE<>'P&EG@li<[HK7u
    ;-7Ip,;;*m,}kQV7lBIa3gBuK7pB>=e;IY~n+lyY\RZI!p<r*u,i=o3[nZEQ1<Yr*!<daOV12AX^
    ZQ~HB\v=+$[va-_2;,$j6x3e1,,vX!1V3?1>[Q2Rp73Keu6}{}XLlJ>Ap?+VJz@}6GjMe@p$Fl5>
    H}aa;]]AkEIRT;*WC#j,E_Ij=RdJ*z!qB-G!'nJZTEIQ5Ho1N{e#-JB1jdQU{V/rZ^XB>-E^]IvY
    oG\O$aX[}7<'j*}zzJ>#G$wKGC3p{nT#vp@lu[CGo3jiY?Tk+12Vz@kQAGxK<!v.ilK,';llM5^x
    !X5]RrOK7VC}#Gi<@rHD3Ixu>zBI#;_lo6e,)g"_joA12WWG_GX,_ZR3U{,$\2^l5!xj{$TJ^>lJ
    UCYi{-[7^nxEk\*viZ=>aw>MDZ1i,slsr-*-jB#=DJ1>UD,wR2zuVE}@]{Tjn,1>z{an;{7GYl5D
    x<'3d=z;Yv2Gl>YI]{t;>-2}aREp[-j3O'D=R;jgp5+#Nr!D,8z$EBR-\B>*$CxxYkM*s3}{EV!5
    ?E_BwrJBH,2\vnBa-KCE<Q@+wlr@ITHyPCkrkO5xus~EZ|su*w,o^Br+CX7!$KH[}mkR=ZTaQ['l
    Ur?YBKUYusHlnmV@!@lI1{?-n5p~UA=u!r_GD1EAe\Hjmvlv$5Nlm]kwn!KrWp;E7?rOG,V's~>~
    v_\JY{[z>D<~ClTvk@Epsi3Y}aG!e>rN\@e[JQ#,2l_C+woU7AW2[W1I7u~WhW,JK=JwnTx,^_TE
    p\zJoY<~e.m[?IKVV*-X7Q@}J@jjavUT}'*_k~#]kXW-Bx@$[[5w+2O1;-VH~1AQj7{1ikU1lD2Q
    21>=-l^KX]xk!W}>]CU*vn@Oxr85IXHy5K>^x<K_ZnDi-tV5o~!5zK3o]vDe-*g,+\ub*Q\BaIA1
    Jl['1UYjrpBQ[GiWUQpksRB?CZK$"iVT;F^]2KfEZ\z6_>TW%Y-\X73<R*?~R~z+Q>[Y]x!!>$!+
    p<_Ovr*C][X7T<'#H',5[3vK!^7GU@x~v_WRRz^x~l{@=A$R3523r%nwZsU=O'=HQ5S*~+eP=k{~
    rrT1?lxkO'n;!CoU3OW<X*u[5TRW=+7v<9}{A]'@'J1_W}?<3a,s2UwRi_x'naD]p{MjjR#G_]X'
    l};gg1]k,PX}XOajXAQxz#+Q'[l+;k9kx;j\I\#7Jmk*1H-*+-k2C7BTq*7YO1;'?erYi$6&Via7
    @wZ}!Ou!V@,,6EOo\^OxrbE]aolXIEG~5TE7B#aa$G"ewDzGi!,rFF]L_PsO3T{CO>;=i^+AmZlX
    v3BXo!Y|zKJQs7rQ(^>up3lAp3{\D}UYwY!'}HBVzO3H^@HzkepDKDmYni[e>*R5!oWK-ZGo+(HX
    Yms7[Jw7AZz5*ITB<pHl=v@oY!{IQ$Xv#mi5mEmp3EQDj+5^Q@$]J,15=E/CT<nU=CxjXnr7AlkR
    ^zH'Jax-vBYC;w5-C~TQ5^#l3j}RI$o~rpuKYi*V!T$x}E24rsAorXs~;j^Rr>r-*pm2{*p[$po#
    ->]Y*p$ziI2Aepv-E~*n<A]'A{+u_Tvz7-lw73[2CYOUZTZ#uXv=-xAGV<p\gZ{J#Kv+vBQ*HmE=
    [o=U;z;j]9JD7Xwo'pR<_1B+!<jG,l>--R#1R!BwnBzw*!#jYowT^[QoY2#lWA*aI\7jGV=nXQo_
    xmpQG'Y$?#^7lp,'+GI_iV?Dw+{X<sKVoQ2aa~Iz~J@Tm\,\=n_xbDXs~lE3mZr_TlPi$<7~Uq}i
    xC[U*V\ZApPY7Y~[axak+nUa^HI,+Epm=XoGT$x_1@=WU7kZxsnXnOoGT~-#GK#=2;pe#~;;_~C$
    ?3D,YZae+H=ev'^>x32J$UW*iJ#Ykz'anIUY'e]j{[*G'jBsxUe#\^-o7${1TAYvTr3QA~R/3},B
    <sQjO?Z2v*5B)Rz@_l!u@[mU5]2'UOXsDV>[R/sRjR=CoEv+zupxjYW$+DqIXa+<-vu;*KJU>_}U
    UHHI+IRnE\u1Z~+VJ!Wsf#V^~oK[[U_--bYJ!rv{w1,D7A2s,K-,_<CB$;riBaW^GA4}TlV$]}[1
    [$<r?{BEQ5JGURA#${U@IU~Y_sK5}}>?n;@$AuTYHr2]}*[fkoA3BY^{1Bk{;$}K]Q'mD]mvoIYO
    }VZsi-!2IkEe*HV3Y@{am_R=,n-2#OQK',~uGDme^a*KO<KsO[WD.7}1o->EWk93XQwJYx{JIwVU
    Q!D'<+oUvkEWX_K]xk<h7ozW31WzKa{\lw$2X[_IG!DEp!U!;QB'sw<p1UDi?aWWup;]AVejTH~I
    ZrKmpDv'wGvik[j+fY5au=r#}uQvQ/=-@VuO^~WB{YpUH*ZC=uJOiGKT~5=H$ivjBGTBjHw7-wEJ
    O3B?{xCCQx6}Xp}DXeGl2]+Y{ZwBnX^*m',S$\}!E^[{D5-,p[H=R{A3DH~jgp\-wfe_sKWO$'zH
    $UVVJO<YUE,1mEK_$Q']\-hoK3;iBv$GI^W3Qj$jF]x~$wR$C:7RVJ~n*svO,roino6:xDr^,~J]
    awGWJan>j'7BPm'{}~7X[5]RFT5ezJ<;R{Y[@1l1}X*=Ae;21Ln{@#D.rJm7v3$XCUx!vr*jxTQK
    QT$!XBD^luIV5j>W+a3_Ix]H;a{TQOsAH\RGG>Yl@=pe15Jk[Xpo,>mZYBr<mD~mV_oD]-JWpTRm
    pzao.+aA+[V2R7#E[T[kQ_T2W[p<RQWsjDHYzV-@=7cl[YxoG1v\y$r_Ao-a7Wzx\XY<mk-zYX}o
    5Bv\Ui7+TBHCHu$~x$K;xzov3Zs~n,e\$iI+V-Y!zmv7DvJ;ViXe>s-$io'a[x_,]nXARP-Ya;E{
    Wzi<[?]}r}v5<Ccp,aOOTl=nE3TW><]7jCRp'5GV3o1\{piwBmR;5iYE*-Zm*\JOjlarie]YZY#]
    jEpJIUJU.IUZD7@z~;O$3#D\5[Z!paVpD,J57-oa^^j,n*5\Rjksa(4*B=@}B[{1w2z,XR=po\3:
    14lRQ^K_+ZxmoV=jBIYx"Y^VI/ZG-!T[x7lluVl{JDD[5^_BXWv;G*asK]}B@{DpH+}%lC^V^{GA
    la@?xz-5oC3YODZ@_+njpm@Q]]D?#Eu<IQ'Ef$Y']tE2WJ7x#1lH\B!_az]c-Q?!xv^Rp7=Ol$?;
    $EY-=iJ!R*-TOr+1DOGZF5oOuB#>~GBlB;B!+R\_++-{5$HxD5_{xQ*VX=j7;frv,pZt5i'n\jG=
    1$V'+QIw==pxOBXK@$jCIuuUoY1i($'xs}>>?fRTm>*kn+:ecQV$jE3~jxB+3!NlH}nb1QknKHY>
    |,@_QF5@>!!Er2EB=5w_,TlTAR%u}2n$1psRJern,K*GWZjHXe@3V<2SVS}\x3K\3jkvmWGX$[Y]
    v,vWaGeo3\+}H+G?_BWGjG-,px#*pw#}zvfH^HHFYI*+5;]<WO?VU-v=ieY;;axeO[}3m][\GI?#
    Y1kTrQA@v]oj<wQame+'>$_7Mhv+\pSSbpX+s'EDXJ<*rXj2?5!>$ZEG+iwaIyTjkC_uB<KV'1^K
    eKlR+n<Q?\}JKZD{YiG:{<3'75xCjvn5&V?7J^3xpEIVm?n7=sV[$tg;\s;5*j]j3sW*3!n-}VJl
    m[Y+ARjU[K*|Q'WGOeuY\}jUr_Hp_U,=w'V3fT1mKO73zSi[EC7evTMz+p;so5o!D}Z]ojjT>OQH
    }xU>Dome/|4WnIBwU2jrJ*@@>GW<'Q'31Js73,HS-GYKO?<lI~[Bm5o7joY$2q=Irs5kOZhHHWl>
    GU~=*UBw>Yoma!2k'=El;plssVBU.}>uDfxA~,BlBaJ>sZW<;>Z{n;$*Rv_JB$iA;A2CYKRK7p\w
    _HImO}rpHJs1+~E]-[)^[xjpwZ1^5l{B}EHHI^}Vj*JlV=It$*v7pv;~6eD[7XQ^Hsz'3wBa{[Z2
    e.}{*~&Z_#UBovQeue!{N'#[i25NI~e[nTW$!R5D=>>z,_-@jTe>+-zvXxH>2xA@.U>au;QO5;rx
    VMHQ>EBABZm_\jBHoeYX{UYOWe2Ixioy13V}-+;>QD5<aeQkRz!+6OeK2HRE,$ws!}<{p3+w=Uv'
    lzh<-IvNBa3n^@oxO[*Wh'23=c{DoRD2<~=3>E0V[KO*z-nUa3H]!J1p?nI\T<oQ{2lK_,^oOjB>
    XTQxnsW*A=}GD@>^]i3\@Va7]Y2l44wXZe~eCBETuD]V$s^}e^F\DkHCRk}=w7\'knrS(;e[1C&]
    n}Rg_B#[YHU#&wB$znvvQ{RxRo'H_n>5T,sVX*m-QrnX,Yu{*w<**GoT~i7,3^s{{=EJ\VI<#r5>
    -iQs]F3Dlx^$HKi*;_Dx;#D!]APU}_@xT@\O1'IQx<117,Yzx[^ir+QaElp;}^+=Tj[DKr^ZXo<w
    B{ktlinp$j#~&<'sxW_#oaR\CK_HAsUabH_sehaa,WI~o2U]21p2@k\v1R73RR**V>R>$5l%[zK\
    G!ZrwQ7@vl\;Xj\v3*Z@*Ae^e2163j\2mx*I$YR<*!$V$ZYR^ooD0,G\]~$lu<UxA[]'xs;HZIie
    p}}]<_CoR;<3#<Rr?z%EkDDv+BJT,_CI>3=W]Q[*=@\x[5,nI~QCsVYK'LYs*ap2\Bse_H?zETq|
    *+z+B@_sRBxax!+-nOO3AG,}vH<-(C;GYtTv[1Zx5D#e{V-Urie_Wo['=a!{;Z;_rB_!!7zlA3>'
    },}ZJJ}xR'O}HmkUHI;sRY5eu}DCsuHT=]EW+eTAz=Y]<#DJeHnD>>DC3'=HQ@vuumREDGzZHn]p
    ~?yJ>YwQv3@<Ok_\Kl]6)+s2r@=31Ew*B_Kj}j~ouw$H!nHnw>$2C{prW$\-@p\J{A>eJW>zXm\T
    $P{XT$lH22t$}-'mrpU,UI?~<DV@H[i++u#,\>+3E$HvHvw'Gk7Rz=pmrU{R>QZk_53z}p,r<$W7
    $2pbJnWn76<,V!DBQpml#pdx;Yo#om!hoJz20\asvl1>,[7[a#[$p5w2u!HsW]+\@p!spF~>3H2X
    r*BR\*'xsOIVp']#p]|53Y2EdVQXK?HAa1Ano[\\BMDE]^[{*il7UGI\vxn5>u'D*2wa=*~vk_X}
    7<uO]C#,C7]H7vD7AelX!Do2O[O\2CaUo#i>Kl*m@EnX[#biUU>x#[mLI*R=3>}~rT^32'su}pVW
    h2j5H!rV]$I~llDZ+JDi+zzK-ks+_@oQ^Unvau}n7}-m1T>H^#^nWH'lUzHWH3r73~xDRzCV-vv>
    ~@OAInQY78}+Y{+_Vm=wK>k^e(sEb8r,T@^G,@>z!av\kmu$BYA$?xJpZxZBK~sj=Z-_\m$i{H+{
    $\(Y2>=2B@e[DB{;{!J\I'B$1ms^R<zC7-;{'+s!>uVYz~@B3X}/5oI+l1*}J5G{[O>J[*QJ~G'-
    y0_K,7Vr3'!}Q$+_;DY@<~OIk{3,-m[]poIA,XJX-ul-_#;l@~25jpHlTTTl5CBa1ROiCpg'mOrM
    YUYXza1sWw-O("*!>;uo<TQS#IzeQ$YGwr#]rjjuhRV^OE}rZb,%WjQ5Hna${H[;okZes+]2B-HZ
    e1z]x'X3C#J7zmZG\j2+HjZEB*3-3G'IzddcIr_rI[lRjn'_[O{G~GX<=}\uYBAp^G~*jYpOC^xA
    2rsYOE-EB-Z^q7mC]UXJz+5{;xXZV5,R{GUE#wTo?)Em{eK+U2$i2[(@lDT}rz#I__}>V@OXe-Bk
    VO_oQ*_xO;Xg{C*[HB5e\@;5_ABB'uQO'[zGQ{a\}j5ie$xsKI5C49?=a*YW*R3->Xr1au>XH;#A
    mY-Il\'ZnRP2=,u]5!O;tWx5{aI<C2GCRwX5VIrYiDzAuG]HwY>+<!XV\<T><kHs@Q^kp,Rjvu^{
    ->[2k~Xm#iAe2o_Y-f;CRsYSs{zD$nwTi++k]_nnGAwuuBr@%uVzHsm!K1wA#j5!}Aa!U-[_l1U=
    K*mlG:nUDs@+RQ]Ol#JvpZD]>v^O}--BpR-AlA5*@v2V-<jXUY\w!;jCT\eekO-^pWa$DCznXsKX
    Wvk[1>C!+7;Ojamx[3$;p=w=T,!Gj_Ge<$^x{@q^Ar1XH1DX*5*_U\Q[uOQ)BC~Tvn@rRK_=wY?~
    }_3ElK5En+Wp%8!^^#lkU_2eQ#h#Q@$O~B^7~=>hzWC~EAlxo7mw5}-E3<D=EV7UHTTwD;o@IXxi
    7I^BD-z;RnuUJB\-B-<GK_AZc=U3zO<,'o}{@2CDHP#XG!T--7_'s?ep2,e[kQr01{J5i=u{oE?5
    _#,uma;<?Q~sEa+3B@E~oZCn[H+wqEBZ~I,]eIWm^QB^k,7EEZappvODCQ{]k]Y5D"s*nJCA;ucY
    *;j:/xZ>K[{s?xEC!ojDsQB5;V_jz&fzU3'eE$YHjZ7*r^?U-{v?D!vA=pass!_7YQw[OuosT_l,
    EeA];uz3E-zj2G3[$1e?CBZ:z3n'jv2H[EeoejZ;A{3sTQ5HHn$a+53r)@]'WB3zD!V3m4I='e;I
    w*3CizTo<O+Qje13omP(nBjo'Y7}DBjlD_Yo{G^W[o7_xBen4~w^z'\a[Vezp=Tz[!SQwVv7lBoi
    >w1kD!23$<Cwlu{*WVokU+l(G[{*B>*+_+]K]]Rx'x5]j1JA\{sHTG^]XA1-uxe'xO~;,$;C{\_H
    j\RTK*$r}GKJ=QU{W1lGN$j51!*{oN-vHm'ua1l\;G_uVX==RK_+~X_'n~QTW35lD5Q<^+#_Cw{Q
    1Cj'I7wHI?5o{+EkrOC7=#I~m]dX'Qkfz2w38HtAolEMAvK]<lv+mDli3]^5JBCY*Cs3n*[V),@l
    IoaR7b1Vo5^C>p_^VWwQoYIB/BZ'3j^5!kXW7XUZ*81[X?Y\[mr?U$xVY{px?K3QB-l!Djx;>xz\
    jWlj*\~CavYw_mk}>^o}irLUEGGVw+^%/@xv[?le\y,\_sE'we7!salwYTR5vV1,J@][=OmQG+xV
    z,M_5KDM<Ykvsm=7>]x~O-jIX+XIjjw3_1<2_@jODVIQ-xK!qq'o_\z-Bs~]G1Ol^][iRYK[v{4n
    GI~>'{D~o*@6KG37^}u3B>Vzi{G@3YTJ+Azs\UwV@$i^1jlTQe@*3\k<vOxmk]*@oo7r'!='>_zC
    jHCvY,O]TIr,^js_[Tlm7wR,Y$VuH_<Vq1^?e1v~*;-DJ-1'r'-eVTzWpC-GKAl+3DZA}eEw;Ia'
    wR1[7;ewB?rVl#a+jpRaUKerAS$Zp3op?7HR@$l{*a*kBjJrBUmBCT&2,nK1i]W\UxI^]em%!R#v
    >Dl7lZ2E72~,DzxnvJ_R]I*\fzDk~w>]ECJT#&injv<lVXj2eC=p[OivKQ5;zv$xTWkl2wIkH,YZ
    7XDuV2IO^Wl1kOMfI\=[|Y-G#EAjaxZRK1V7>op[Y5n*Cb9:@UOzv2zD'3B[#B_'\+Kv=1W>++>=
    rk^~_!s~*R+]DqGE[w]b,hO>sBKanxwQ@sfBDIp)\?\]W*1p)u>lJ&oS8]9G#$5W${ul2n@1s;oz
    >lxJe@[l,_,z.n\zrB^WoXXJvXI=i/{UJonGe<',HsY-_X5IjwDlIUsrn!+_e+35*25j}Urr7aD2
    }G?$QAnGTKxIx18/TjWYZ5{wW<B${=XY3w1-7UT+D3>[[V'@W_]IXlKuql1IKYB53fnIBsQ5{,|1
    XJnnlnQr^CZTA1owY'!x7Wo$u>-OXGnM.R[_v;{UQ!73Ae;sxDp^$*U72GIHK0=HYYp1X7',spG'
    @j!pAZDk5V#w[TYvDi!\!D*Yl35$s1Vsv3xWUoJweGJTol>l]]Dp1j[z#ZnO!I*5Y3^IBzswpuIk
    paD3a!(H1VO15{IUXQ>io\rwY<;uqY#;2jQ*}v3a2*lTO{+~_|#XLZeUA(^\7Y5BW[z_AX_Z]DD+
    wJa'T;lQOT7,jEms\@[2A2llemmTAXD_Qp;w}E5JEJI+,YEjluTB;[y{72>XGIkD5{,pICwxm*Wp
    @R=o+xxd$}sKZ<B~s3AeH_nVuQDoR~+;?oD5E8lC^OIm+rneUWNO}]CdDvvR*1-{=51u9}x2jEQB
    Q?>{3]=-JBa,$rI^-B57-Fc=o]]l-[Uv2A13s^\"7Wunx-zmI_vOe2{1!v}k[iGkkC+CG;1JConr
    w>(0Jv'251WOI=vHKB-1s?pJ$#cZ=HQT-Iu^p}p4rZ1G]>{RDvRJnC]15B;>mY'!*~1'eXAnU5\m
    >Q5U$Iw+(IkJ+zX'@]!5C]K$*i]Q1+,IXY_k'x*Qx1\z;v[X~lID,mUT}l<J]VHQwT-;HQ,IGQr]
    ,J^Q}*:3RJj,T;~><K1'E?##HBKoGj,!_KAoH*[,Cm,R5O+=7*ZJG1jWjx*,I*VI~^!=ZDu]R>2\
    xZj)W1Rs'pZIIi*p0B.Y@sEmVnE3Yo']o'~x~qAzw#An1'KRYn!{t'_ZRymUlWueD3eq,[,-rXE3
    f76^mD]=-YGr*;}_277zmrB^GHx1UOkhV5ue>I^<fUBG*CmjZvEU{an2RP5#]^x]I]QY?^xWnvYG
    HooXnE>1_>lGTJqpn{K}aFr=2U~pKwr'#$~<~vDTw#KelooYRpOv^lI!~aa,VQVTOk1$;>[1l11Y
    zY2Uv\5Q*u!]i7v^iV|<l5;2a<zHHTZ4jUb(nv2kG5A3j}ikA*'n-DvaV;Iz37ViGR><a=UrwRC}
    ];oW__zzC{mj_KjX:3zC'[l>#Bo\7B+DOl=XkE^DmPR,jGGHj}Baj7CmjAY;]Gei@+V"%fQ^zC+*
    JIC~\o1W^sQJv<?7{#[R@'I,^{uB,<qK}K]=o^;JaQvx$wAX'$rx!r-RV?-@A33s]n\=#\Bk,QDn
    ]nHu[Ivo5,l,?zxjU2QvGJ;Q'l'p,vXAavG]1>l<n7v"EVzX{w+ukajA_BoYGC'GRim+7R{v?a=z
    m'RlKHX\"rJ-sBv+__5rR|l'GucCZv<~p_?6=ER3UAXp#CpwXzTJ$W~X1^s1}@C$>[RoY}3zWjT!
    usonXpeGh,<xe(RBT<D7e7euHv3emZ]nHXiBT{rD?YQ=]@lI3C$QolA\]*G;]>Ul<>7$pxZG-Y[k
    [GI~E{=J3}8[EB]x\#wkB!#>lkWFV(?*R;zXCJ'57_'?X}IoQQ'WIzsa;!pDFwa,o_<_]C_7DURs
    >DYmmUD<uX_Qz#,Yw~',3ZvOKCGsR*5e{vwsO~G;$_X@v*;>WUnek'siaGk_,-D!l,!nk<s^2ser
    _=wxTv;evejYWqCoj[xHR]DCwe7piRJlX~-w=nu}K1W}uXPGnmU'^W'kIClvWEGhY*2$!'3![\uT
    ^?>=HU\>BD@oOf7p^v^M@tU]Am~lkzQe]mN@eRO@_3}7<s&&zJvW]VT*jHW!],iB}l<x^E<xT\=s
    vG_xOk2Z{5@{Ei=X-aop43]?$B}u@>I>v^3}$>,plT\n[;wWZ$u@j{Gk>=<j#JXoUQU5v%Bw=z7<
    H\de~CA|e!>DsOxl"sB{11Qk3^VURzDuvYjUWBT}QW_@Wxk+E$lo2nUaXiD_<HwmI$iUsE$R-$AC
    x\vU-5Xl;6GzeR7rHZ?\Ye$B7uUUWOI_1_'AK's7T\;Q=rUH=@#7o{l1;1_I+71m$ET1+R~U}I:7
    ?j=\[p!c}m+<Uh$=e3<''V^{**Z-r'CG;<7m<+ZI*@\1Bz~<Hmj+TALrppx]a<@*wvQAHx~{nR25
    =l+Y,@\jWw$_plrz''VqWv#s;<5G+,s!j]3mVBm1;s]a*1{uD_oE[VJra_pIIs=RB@r}<B@'QC[G
    m,!KFuaB*vOx#3{V>O-IJV~DsZQ,X=xljW[{^l!R},HQCROl~${EO';$@\]7XuL'Dx{!Y$JDO{YA
    as*;zEj$isBA6^]lr3x,CUDDQB\#3o=Zw@CrT2U^Qrr{-e[E}OWcs(OBA^;7r?}EZHvhL;n@~eDD
    >1'}DoX-O^!AU!U*!p=lT_k[vOm}~7TYEnBz^T1al\QzX?=!IAVs}YvA_C9nC$#=W'-.BoE<=TmW
    z7v<j]na~O#X!QmR[e$;\s?7HwI_'>z5EOJm1eB'"Q[vEc]O!!+s#O5VX,MHox-N5_$xv]m=w=RB
    E7}AlenK&zVXR';A!j$p7pzUT|@U_Dj]VXUrp\K*,lW{;z]vl3]5+]e[W<lk5#nRr^4YWDniYsX2
    aE;[AAJ5#z#']2m_kUp{'mwX'JBV$RBi^rxIaxlfYiz*#UnV;ATk-}3KELm8[Vr3':]BC7W*n^js
    $W*BE^!Ym;,~$B6x^u7r=#Ia$?{rx^#H7@}-7sWTHm'{r>;'Qo?WEZ^![-pGCI3/^XlQmx#\Nv-[
    @H7G@w'U~7mzxw<nnu'>,IrlUUIE!aUAD|Jj-A{EEGu<YEl$'+sjaaB2ev(p=X;:[JR1aovpDKU~
    'sYk0#r@Z7Jvpl$u^NHD#$!^~!;}!<2>^orNiB,1Uo*,aawv/WUUmf@$\2{-[U3CmR=Jp;A'pI$W
    a-z_2EEHVGl<J[G~IlDJvWQwaw}xiB^{H@''iOuDmX[<Iv~B$'v?rR-Y7oTG,i_*;$oW_#G!@'Ov
    <sC>l7e=QTRjiX,=eYxIj[lmm~oYalB*lA][u]wzpw2zDHoN#l2UBZ,'*C[@,Cm{s^ox73B,R5kx
    @R#5K7U[.azx7[mx}y3R[z<{w}sUTmYHZ@pa7_7uJO|#oa!p!KO$BlK,,U+N.*mvA2>O^t[A~OLi
    N=vxQN_J@Ta>xsRi{O7W$z#A;Uw]{7Z.z2W;Y*r*rx-V)YTaZ|{+5,7U<D>=W<+1Uu*7<\73J<no
    T]1_,@ceI=[o;,E'iBKB_#V<GloQ!r}|{Ln|">,>$o,xl7eo_=oD_dwh=c-DiBBy[kmGC]]E*K2s
    ^vCA*O!+\RDZDl\JBB@I[Gko(*oo*{vpOQ2$-US1![X5QT[H<-!<$\_}vk@;UR]a12v$,3lwHj<G
    [!^We[^k_k?\UAC=v=w~OABvVo$hx}>H7#_+1prJiv'JlUOi^EXemYH[K}+CYi\<?oo^[jCHoK]V
    r]JX1Q$VxH,G3G7'U,@lplHWE1@XISr'm2;rUpg^7n73I,El'Q1KoQ*jQT_**Zse2BTQJa!Q?UYI
    iR[5;*lekx3$>3K(dVonOunU\a]ei^uj=\GCBtDD~]VvWJLdIUuXn7@DJCek[UEl1eKOuD<]We-e
    QHQG]Vplnl3>j_u7uDDOJ$vz^aBAe>e{'<X1*$WR;z,;%-vYlsQ57l~*=Q}<j'!+UIDIx>[1a|7B
    E?r=m{BJBk^-K7{aoXvz-sKr5n]J*#B]rOz3;OuR-VP_Oa5_\Y@x\2IF3onWKp2u7\{OOl~JRmXA
    neUl+Rji_mJatYA[Z#HZvl;}["rR\?xsJp]ml{;=zou7$'12n#^eARrXZs5{$C3p{\<j+Q5|R2Vi
    l@[;pu,}OJ7pDGVA6k]gj\\jNg^FhB-'>7mlXE0U<j=ITmseOt>sZTpZ,wE3vnIYzWHo>>l'w1]}
    ?I;V=J7I<V62r7eCU5o:jXxZIQm!<X_rneGps;2x}sumHI_xR}aQ1@JR'e1i;OT=iv-O}0#QA}1^
    5p,;OT?s,!j77@<7/xGCjI3*5GIToEnn[YzzakwKRj\e}H'AHL},lOC#I$#a7CC]?[r_}pH[1C*B
    <l*<jJioEBv^xDmR*-p=uEmrp#BK_-=?,O>][3B2rlQ_?QaY$5AUl>$H{^'i^*|x>X,2j[wXU]$5
    ]I[,J2e3[lu*gus!r@jKX[nX^D1VVOevmL%>Ik~<VEkY+wO?'u]J*-z77sV=Q*=Ha7H5e_j$j2rg
    zVjo|+r!@(>$Qi'2['3*nTi{!Gvl<lN<$wOte2}uB35!7nlXJnIC#[a!'xY{cEC?K^7aTsZ]7=K+
    C^?Kw&A,WC*=-Ue5i}I[9K^!37JXK*$I#kUj-'Ov\V_uHks~JWr~XV,Alsn+*zWe;n]=WQ75ko-\
    sHIZE]3RARjX}]wA5$_T@C=@AaID]z[Gi,-3x=_!lD]lExiT#x6_nmD7!D_,E-KpZUlmrKQ+C_KV
    eGT9[W<BOBORoCZoZvxCP1p$>ap}x>-7'a^!5eWpoHO5*~<[J7@$~9IXxO+.}fG;l7^5$uOk'}C@
    Q[vC!>[1$n8Taw2x+=iUAr$E<AO1sj]]T7j$<WVu]jaj\U~3CEX]^=<nQCTl[l_7WzTAO{,dNRic
    nQiY=N'7[n^5AxJlC7<j\np15n,Y[Ap@T\e+B<iazrOB+r\IYA**5$TUG#7rXmnUKj!\!<I_~I<X
    E-$$\*0VsK!OlGs@+v~VZQE1o\$]IA[2[u,aRZe$W'AjVU3dRv+Qd>Ea@D\2}EupH~-e<v@5^VWO
    a,C-DG{W\JO[X{,oJq-G#joFr^mz<==$WDeTZD<+~vR@YA<UV-{!R-K$X\mVq\^mlU_''5{aO&ja
    ,o$K-B:*!CYkVu~~T'D[Au?Fm&faI~k}z$xf#s5ZCUZ\D_wA*2ex=Vs@VJ]in5*u'sIm7mB@7ZW*
    *,uOpo$ap{}?}ZzsL*,^z*exu?H\zpu7$Q>!=AS+}jwKz\H1sreR;U-5FpX5{;{!'e+33b1^R}J8
    +RJ?U'Z2E,X>aU7e+]7s'!nC{jx-sQ=OO_~xz!+,xmov}]u}naxJHa*WBz77q{e[-K^~$7uH*1p?
    QEHl#,;{>,K^'JR-TV>1lE*<+R,=m$?*eMjAY]u'Ozf=#7Cb_BzY7i'#oxp>[I>#uw[;on<zaYr^
    N7u;r}K-k{Evl"K]Vxml+-b'Kmv'i+}sY}B+1Y_Qv-wrjzZG<jASIsAB7NmIK$GTn#hBxk[EkRKJ
    Cxne\Bl3xjpV%'\TEB~He[~G2{wBH-+@Raw+!2tCj~m(5v^2,_E7BDaOvG2wIa],YRk1[^~C&rDH
    'x\{kraY3Jo<oEkv_KEYGSna->lz52~CYU,'{3;p'uO@B7-\T7"w-C~yD-\}GpC5I7TRnaOup'mp
    7R#U\]Jars{xi>GpI^JE#a5<C#z1I?=Ks#*$r^#5?*kGzRx+mo!s3a,A?^{2lQ+~\[~vNGHI<>IT
    !sT_OJo-{r}reme-T)2GB=*B!=$XCEvuQ-e'mn-]EO}}7A#1Be}JCuCuI7j,O<!>K]r*}UVj>Res
    ^Bjpene_*anH!~BHs\'n2BxZB}JoC^GjYur{D#zxuAH+I2<DB3$Wn!po,_W[WjD]}5O&f*;ZrrE}
    ,v$VT9;[~Z_}k1E${>kY1~BC\U=S+ao@E~3^Gn<$x<ppx7-z-B?zW=WQ\UpuXUj#\JQRXe]z=Z5;
    rZK]jW~$,^5<>58)UX2C-}\ZxIK!KH>ow'Cpa5pesarT$3(>Q,I<TxkI5oXG$;emIjHU5=Or}CzI
    a'2#A'@Yer^vWC5j=W<K1wkVw+K]?e]<Oa?;_?T]D=rsw*rWl-[<w**QT+Nuxi~sTv7c#T$[FHsI
    moB5Ko&-1e}JnB~#aQ_X[>r1B[=p$EVq-'p$5+~ZxU4n[H?0GK7[Trm!vaC>$,JzQ=zY]I'E=R!7
    ZA@{.>{O_\Vu!)$/BmU^ORvR<Cw~KxU>5Co~Xe~z3Bsir#J<cPVsAlwjoUCeo?VZwRIK=C3p}@z\
    ;*jCkrei<KPLm1w;s_v>\M>T\IN-77@jp;uj}V1'+DRO5vxYA7*R?eIQJ]T#5Aj=@+J<wea}@XOa
    QD}c**nX<lk^Kl=*e!@Xh,K\wr\Omjl@rFv3C=!'$>*kw!J{wE<auCg}mvJ_C!OJ\-Gm_5J[2;Gl
    pR>#'H1XBnoV*X!Tz]zrRC?2TBk2s},m5xW\+e>Jl<jho}@rBsC<ji\Z2=QB5Im[W<OnY[$-\ru#
    5>VK1zDuBKwEmErEd{eoITH!vQB$=JjCviD{ns1wUxp;BY5VZ^rzUx\VUV$RpiO*Y1UI2QruO1U_
    !yl,'GCOwJm\Z5I"'aaGJn=Ek*lRBUx*i>!Xjk$KT'HZsGi^)o'5rIv_'B1}o*rX,lJW_RU5Vx4k
    axOM*B}xDUJ}QH,G"liwOaQ>Aqp3$uE,!vu'rHj$>?HweGK{hBUQr2IYamQK=7~>k-<-K7KE_UI\
    O/p}<$[1pvJ6}-pJA7o_}a}JC+[VA$JK5Wy,,]A2^YBkA~]rxpD,}x<p<T*?o${<x}@K^#Hl^T\3
    '?nVvsXcG;RvpBo\[AY~DoYGd+azoR*-R}lXlL6]#]XkOrYsleRWQCC7I-;m1U>zzA};D;u5WR{o
    io#Qu=7+^UT[8$E'>5#++YoYjp}?kR1[]*'rj^$>xQ?T=qVz7Z>R=Uvn+^Xr'r$r-KHTo~uYl$>Q
    O#RT<oQ_UkGV^3V}s]=5Z#aTUE.#EEId5HWp!.o@_D{1ne@x>jG?H]yCjG!oX\7&s\m++p<ClQY3
    OX+'>wl-_|DJlo}uDwJw1In*TnRXs_4J*$ohQD[CvHQeU-$!2\$T\_waOp-s3UXl^CTUl72=A=z;
    KQ]HHA7Q)\olrVC@5JTWneYuWUI}H-T}+CK~@TBm=rmWI5,VpB?XR)rlQ=oW+nk*eTO2R$,_<Vn\
    Buk_E'WCR]jiWG.ADHzVm2*r_\*rKXAmTCDmGvO[>^DV<n2Io_z*W=].Ezp?pI}~rORm}A>x?r[B
    pX7'xn5n}De*A9#[5},z]XvA<2GzRC>w@rVJZj0DGx<!^A+sWor^OTu\RZ]-j]B|M5;]Yss7r_-o
    RE7{jn.KVETQn;s;x'+tUX[<3R;uWlADZ[vT=[5Exs~wkp-vnv>_Z1T]2TD!ve#w*-2]HU>?)2V#
    ]-lj]?Uro@>vA0fk=1$qeY]TKj3s}Ru2*RJ[5oQ[=ine1IGkxTIDan[XoD}sM)kO+3JGjBlmCU;$
    QaD;,x<w-ouG?z-*e?m[<39s]ZUtlU3l![^AR5[$z?KRPblIme1U+<GJR!BeeTBK[#X-$xY;o?3=
    m_^epZg0na_}ar2{{AY}pTRAP$'O#o~Z$$V^iSIT\l?TYpQEoms-{,~ruE{$ZCvw{Os;^w+o#^7x
    G?z-T<za1]Gw|-onUV3A-~zu+1@=TWOww{sV,GurTKT}^|Q*_\uGz$hi+@PnX!*X[ABr/lO@#kr}
    !}Z=uH>2u>wsoR5Y1?'[^Ts$sG|E?pA_-E[Mr=pB\s[Dt\#2;>'oX1Ou7btqxVJ2O+vR}]7uo~@j
    cN0{=Vx!O=<DQ!p''KYIuUszxJ^>lUuJL,>@zPe{}5;$~eekxa9#=\\TBQC1Yo>EGCp\!m2GV]!&
    +Rv!ADX5$3H>T,TRJ_ue*@zmMv,R#?jal=$<]J>Z?vI\l[kr#.H>2mDpV,)QaAC}]#Z?v15x[UD7
    }{1;oi-;Ys@dE#sjCmY-Fx~R?*=^5aC>GH+mK$kz-zU}Epl@{JnIj~Te*Fs'ej,mRQ}~*r}A'n~$
    ?Bl7uGiDCXpoJD3wJ3n[>DKa$KsO'QwVX}]#Q1~{\rGnUs]u2{=,+-Y^#^4aCQAnV+X-7KZ\C778
    V*3KCpC^@IkO|5oiD#EJ[g.A+Tv=]IeusiUklCBe1~3?oZn$3\E>\EOUj7CZ-Brl^J>w<51eH\-u
    H@II{OD_iOW+^3T5l]2I1jpD@1?-as[Oe$=eGV=mpi+>'*I5m*}@XYmB'zDOjC^plTo*ZnUBWO{<
    rH-6]u=UjpZYm=]C=<2XBr2lpEY@{lYw$prv6=HH'w[2jB{\x#w)N-oHY=~XG5s$v'-S*?Y@-7oJ
    7r_-rp@AQmV=>=Q]Rv#vrg2UGXYx,GBiO[G;^OGma~AR?CS"D3R-EjzWNz[KRwBw~3$j_sY<_;s2
    j?=XJ''5E5#a[p_sueZj>\AV'bc$3J$;-'<O-p<>AIo';Bosu5mQmaOT*!59I3xIe_ID@aY_(_;}
    @^\K3HU5_^u}wkQsl{T^+V$we3s?B%CGvjWX!=H,vK2Q[G}^EK<$=H!CA5RZ5;pYmJ1$JI**l[^n
    Y3\wE2vG[ksK>*opV~=nl_VQHD_r7rP6"ZB'aHX5'_]^^C1m-I$1rxB5Ya7<vRu*xIfisi!Hsoi}
    _leCeE?_wl{j*H717]?VGVw?>,T*l+O5KCE@>w*m*mB~aZI@eKRpxG3cv?Q\VOG$kzVzX}UVXR-\
    mEv~?a'IvJ$+Y*xwoUx'x][~5[Xt2Hx5x$l3DpU\01J-H_K*EV@\j]=mG~B~;'e@vD'U$_u^D:E^
    }>o]H#*>E{~>]3+-X336v_uxBXojk\s~,zm,E1@,?7X~3o=sOw+O*W{rmI}nZzKu_jX2vDnWDGv{
    +Q]G+*;p;l>Ak7xXY_'H->GaC_le~p~DBRoz=^,^*nu-D!el]D]/l~jp4rr\Aj#_JRl*U'+n>75;
    DuBnYBvUulBkvEU_Hb{>lE}rVTap'?2H$wUpux[UEz]R@o"1QAn1N$1mmn>nK!C^+p<3HaI![ZX<
    zWRE<#T_*h17KH8O2I~@x@rUHxmsV]5BY;!HnlA;T]J17BEHXlsCK~z3rY>FInj#^G=XOTzIur+m
    iQKV;<WnG~l,OX2+7+2knY@K}A\H*KB,er$]!^,Rp#*avD>O$AU}s3,unVe<elJr-{\E,Xv~p2I2
    @_[}nORAulW=Zep'jX1Oesi!Yx7=|G_~?V9+=YU6glZQB#-rs>*RUoij2*Ez?xm\pp5$Vrs[{=5D
    EY:DrAG7~;D_,z^]vi,;Cis@$v#2A[jB#{H<Ir<2veiCv_?VzWQwY@X,x=l>-u7~$]Bg?+E}>Bx7
    ;w@NBr\U#BlUDo!Rl3Exk\[V${'-owz,re[eJ$<#g!Ra1~>UwNO3$YV3jT}u-!lsJ-9'RK@kDr,*
    {}j9TO3[y\xv*vI!TurV5]R?mn\QKQkTsK<m!U=uW%A+COs,GK*Hj5-HQ<bA_Y#iz=]Cj*rp7C'W
    Tsn<[-U,p7ZIo-!kT'-x[VQ'hp[Xv\3A$>EkBul@v[!!@7;j^{_-m}=Bj7zO{=5pQLUozjVe+;W{
    {X+p<$O2]{m5_+<1xl7!<]ERkYx;{TwI\*I_{-vBC$WU3,]i<jDH_C#'oRBC,jH\X*5AQ'PXD^G2
    R,x*+G^m=5}]{A$xg#\pJBRoz@pOR.l|kX<*}_a3&^,z^J<@r]AA{Y|};15}$vJj7@3z[{=aq_Z}
    JY_A]{]\C2X[Uvoo*Y\OB)csw-m[IZTITACB2!l=vo1$YBTX7i3xmKp3Nj]+21Vwn]=m'rIBA$g'
    ZK?J}D5,Y2ZG*KBrZ]+lA=QZXB>OIv[Oop}1Rlu-I\e=e=uO+O!_~'^a9>}KB%xi$lWXG79C{@[J
    w7m][5,X^$"f-]Yx7'<]Bzjw$*n[u\=aa1\,>D=C4,rw1pr\E\?u\iCv~+*xwYT@w:7_spXVmzJT
    X]a*sv~E'3oa[C}!ljiTYur5H*B;=#>,},U,k$@RB{qH7AZ~U!+r'7R2vJsHA1j!j!H$}lCE!R~C
    _ZZ<QGEfoY}[m<UrVl@{I{Q!CuH@CD7wnRVvQReJ3n-p1jrv^==u}7D}D=_n=ueQ7QeO3xi=URJ3
    _W7+4@jU;Y1sxV_!AoBwnOi+TQ?[_fE*Wv]s+IduQek~<AC+]\2ZBCeD;nv?X3Gv>Yrcw\UueYs<
    @G\>Y?;Eeizs{vOOGXZH8eW7TCj1k/^x$J@XnB/Yp'@A7\w}?+_+EO;GvQ_+\-\=,D#KCzm,_nBp
    u{zWR!#1kwn?[<G#X}n-Qf;X$3-X!x}*;-n1mk=>l2!rE;QG>{IG_x\iA>DZR7=@HQCvA]jj{3*3
    VGO3pnmzzEiTnIe><IB@VwjGnGBkHzJo=?Ps'EjDlw>B}k~VQ?rbC-u>]\T;4\m1iK{EJul5nW'V
    pDG}ssQw^X,=rGu^u]i<H&#zJ*#svKl*BrQi2l$;CKhQl{<AUAuajV7CVZV]2'nxxGs-H}$+U1i2
    O3K;_=rTxaUoZG2xQ3#iDw_DUsee^~m,m{{_p7HG$DV{AmrXGlC,'oAwz!5@oQQDU$skE+EnUx=E
    +A^1G]3Rm-=\>Y~3'zk4LYvQ*3o}Z)zk3+$5ZT>$#;~'CTQCwT1Br!)r1z2D7z[CKn7<<{;D|Pev
    -;n7=\Xj}=e}XT]n~?JDJ[[[-sw\='EBm@hl2nOkCE2kYnU};Z*j;]KG#>JJCHwD\--c=RAns#[$
    ijX}Gn]m5$BX;l#lo^YoIUXO8vpnK\R-o65l-;7B++-Qamcow,A[k_5oeRCI'oup\Y3[YKJE{v+!
    \IE}B+kr^1>K,W*{U^s1X}Z*CTOi{j++Be3tO_D+.01?THj,GW\pvj>n$onX\GEi$R'_jHnz33ka
    -QZ7^Ymz~jDG?}E{R5Hr5*sa3D3I5^7J][m[beLoiR7sps,\(sGK+|[@5~$!D*mD;R#=QRLHv$v5
    z,}ka[GYp!@^9'Z'aIeiRG}wrGriXZ,zx>Hr\2V}#k_[Bh\a,=zOKT1X~nxI<~&\T-Cn1^U$I\T_
    UXa5{[*(KG>E-rpA'Q#$BGj{2\X3C1C^^XRnX1IsQD-lrHmUwO@\ajEZvA*?<<G,V~YO?z?T&n}V
    2HC^urTW-w=-DE~Yvlxm;25vr*sCs7H!zXOiEz*!Qo-wW,'_7xw\ws3\'a\W'o+wZ_?1RdKC>j1}
    KI-zIs7GJ;jpap%:rp;}@U{Vl+{Cb2oj!1aETvrDVrZpV3-BlJXKAHx$5meQ*a5l13B$H!B]--'E
    BO$5CNc$G<v+zQueJ'J5ECXE~Xe1YR@xr[-s]aIvWvxTAKe*Z1iITWW%mAxw\RI,wH+pj~=?_?u2
    QDzzk,1T(VTnQkIHuBXB@_}p}!RjA["C"Rj^5y}=wGQteQ{~5Dx21^7?9-n1DV2oC7HA{w=Y3^O?
    RC]Oxm^IRiVT'aaY*Q5Q{7TQx'zZRjZ5~~^K}X+@sK>IB,HQArXmv?YXsbCKIBv'pRcE@$r.Y>37
    $aX\F;D,;QI}l]R@en7THv!E{~p3DOEQlY31,rJ,a]za3pWwQS^zV='^l?gd,_G\i<YC${;A,IVs
    3em-nDXr5KmvR#oCSYwYGvA!-T]w}vQ-xq],7Z{n322^jKZ-YKI<\?S&$Qexh?zu_KGUG#E7{}_v
    rO]GeJeU2>Oawp7k$}DwD;*5[?^rBWOT\y,?[HbzUD-,KUpO+'!Do{UBT-CWr1mm<W,$Ex]eH!7\
    7kX?l7ZJn>3s+xT]''2~\$s>B37xxa>MX==T@wOZV^?ZKo^TXG3B[+~luYzXEHWzUn5zGvDG5nRr
    >GHe_AU';B+=i'>@^Ex_6eXe1'2x2|np5']+IwjW^mk=uB6^xlRlUG5]{eVBB~=eBWa,]'j'pA_]
    HTZ1zpW^#=<]X^<2<HG,}KXxR~xTlH'AQ\>Fi\>psGK?zRQR0R7R_p_mzOi=ke~RplWrOEa>CA_,
    ?3w<}5Ou@?5oB~RE,A[sr7@;#xOE1>-=U0_5YRNY-vH$7xu<rjAH7BBGe<,$sl@IGIZ@e+wDw2n'
    4s?r1sarvi]$V@^~[$^z$^A_zsG[V>_{X!RxjVU*7lG]l?E-rR]1OsoQCV1,}B<Vx(PGiJBRHA{V
    QR,j]j=Ja~;#Ea1Y>I>o{\Ezmo-Ge]ef>=l[*#na>[,zWUOpzDvEjpz3~+_p*H~e};ur?HwYUTl-
    %L1Cj1RUAUx+neY*+D+$<IQ/5l7*5EVHi<lml7X[I'Uv(q-_-'or]mp5XJu_j'roW!po~Io;~[~n
    OmC5BXOUe{<$Tp6]x*2Bo[?wB7BrpZmp?zQWpI_v^,7#nY~WBVrD7WX[F51]nll7{Hr];}$a3Oj?
    jV_YuZB?\j;$jvv?5l@a#m-WIC?77Io!;F*;<osi,!=@lm>zI~\<ViF,Z@I$ZzeGk'J2V}p3$\}^
    K2?[2T}#V1zB*\vuvs=Ae2VCYB=pOC+R<1s'OOzje%cahz3XBw5=u,rOaWUJspT>#lUu>o[['qa_
    E<]BG<5^?ni{_KG@!GY>ZzCz*V^&v$\]<5\1^s_^#I*nlI2#zG#R-nRZ+C-$(I}IOFmXD<Eor7u,
    iE9ekD2wHuu;<p^mI-wODUYCTQ$USlUBE[W}>8L}KmGVEs=E|K5-nQ+Q2J{z*sw@nBmwjY>2Rzu2
    1{zw#\^HOJrlZmo\^}HE~+^EEYQZj|&x>Um#V,aEDB+PN6D3O7T'^j,x~R^KHK^m>KKz;Ki=TsAA
    <*;S?]nE2=T]^sQOh@*D2oRKA3vC7"[T=~~z#vTO.R.Yfus[r*w385lQ}B)$#Ymlgro,KWo?Tqlo
    lu1BKTI1;@r@CZk+'uB[AJlW>utEJ$Ux+wV}V33HprQL{{]=['{-ixJ@srJORD_'+wCJSj'#![Q*
    3;eX{Oio!@s^upQ;>CH~\V']5C_o~RiD}1n2ZD#B'_@OV%E<0x}}Z7r@JrnJ@A+[u^oDi*G~YR@G
    D+,B]DsaA=HD;+V?rJC!G)ZaHQi>@~isBnZ>E#\Rj=:NrrJ\I1RlY5Orj>lwE'i3Q}i!T5<k2QTD
    E$?szR+s9X5QpBU3r(Gl,[=iZUQa!Xq^']>~]Y7J1['unJ7[ekYjuRa;Va1URm77XCxE2jIB!aJV
    <>>Jx#uDz?-p8GsHe?*>KZaBmY*aHK<+B]H'?=w2>CQV;$V4z#5];->!l-2E12R5#j^Wj=UZ>VR{
    hZETBeopaPQn{!V{=B;lUvC^HKUC3a$Ae}j+X<Ql#OBOaD@UTp]>;Z=jpn9r[-xeHv[pRr]"$iGR
    3a+?:=,jVg"k5O[nYK}oq#'l5YH7_*E';EOR;_<xD=}U^6il5U^3nraAna{TX;iav]8cZvRJ\noY
    '57R&IJs?!Olu'2ro(Ws*B8rpD-V@HjCX}KVhqV~Q,T9Tv#r,>JTuv7'Kvu?#e,[){GK~oxD26g#
    -K7[RJukQC*Q\X!_oYwr>5al+zI$5JWw]T#4>^xY=<B]R^RV';GD-xAj%Uj-<8kIUnpRJI%o3G@M
    IM#TzQD_YzvROQe_@TiIVxBV~2x.QRKBjaT{PEART=@Yv0lIDzt+zrpKB1z}e?Ha[#ztR1Q[;Oe*
    ,TKI{V_ZSw_>#,TG!NypW{^T|Ul\_]EQax{{IxH+k_Kz?uz,KQ1\+=W,jn'a;Y#D]a$<r1RrE++7
    xD<=j[Qr7$W'1tX}1QiU!kP=xD*TVHmJ{WnfUV}=R?_;b{{z!xl?DK}-v7K*#pICmoaXuj6Y>~[A
    {\,Hz{$rkr[os[;#Ge*{}KK#}Ce[WjkCpTY$U@{5I~CEB+]YsZ'O4'HpjC^zkCCmW)$Y@juRw@]<
    11Ojm_uEUD]~^oiY=Ue^zA+7!D=@227KBZ/VG3[}lR,l!,nssR5>\ko{zz\*$<G2+oK@Ej+r~\ke
    Jm>Y-nE>C~z}@~'FJ\,1'IC\x>1C=?X?'X=_R?~BqqHH2muHn<W{'[r!}[e[GspKWWp)uoR;DnAJ
    *<prW*?xs$;O-rZu5TrvQ>v~}J\Vv_AuO\#<C_z}q}a[!eO7;oujoRX5#A$^[+rjY[{uXd1am>x2
    [}^'ivZ$pZ}j-<!wvEzRVZO~~\I^5U+5rDae,$H$$ap[?H5@vu';+T5l@#r8lKV+lG'khZwXa8sl
    7_jZlE@Yk*Dz#,}$pJ]2]{~+]RnOCu&*};ob7/@nBsRDWU*6#^GA|#TRJ?5plKB^{Q3-r%\{-nrW
    x3jD,aGW;je!l7Css>?EY{)=J,WZO$D!HVVO?$ZI5YBUEW@HE]zJDv+vT@!bPlVo=;HpWDJ;${Tn
    $RAK3tC<pI+e-jO_zQgVTDvm'vsD!<A=2QiZ*G1E-e]#su{EBn1LboC#eY>liHH<eV#U}lm^}Cnp
    Hd5DZ#eRZ!!r~EW=Vrx[5-}\!3r[xi'}2C$Yx!]=D\>DQa$^W\6n99XC^$[V5@,]wKVwR+8T_*;O
    u*ss3E<?nl^[[GCR'oQ=TukX]ZrUDTmN|+$7#lX~L}2e7R+w'z\B}a=Z\]lkOln^55xO^DYCI'H;
    ,J*U=O$pYsE57D^YUv?3ruYHJ1rr2jxBOrIAW$a{YQV+KqY>+e{DwkRV^Zat!OAQjCv3Y{Ex=EW5
    1HT<BDTYTR]2bBGx3V2G>SV1mJ!Xr2s}T;\$mVQ!5,s\<w#,Iu7-}abpUI5=WI;^*=us~o>;'OE~
    TDIBi22[BZ5ein-;}[@;z#AI*o{-}G!\<~j5*E=uew*\z#1oA@}_]Q$E;{OsR-@],_+~e\YU_=+5
    B2{z^wCBuZs$RxYw]k1mC-H#a_]E\_1$}R\S>zJK}?ZD5Wp7[j7i5o7]slOnY$kX/$\OvnIeGGXV
    k]XXTCsW5,_GDkvvmJHKA,px$,XuYekE5Q=a3+v~xqzkl{@o@xx!J-LG$^>$Yp2}~]z*-~x2{@QZ
    }I<>8*)Bo@swR#G=zi\<}^xkjZru*}AUAv5Vh7_DwJ=HBg'kA+j>U,-x,TJEoGDlX}^!l{qilUwT
    RX2^I]GBZ-xB<~$+vC5p'V='[@~Y@WX?B=]}s,TK^BJ\uxieIp]U}xYs2TUu5Vz2ol'2CuR3<\*A
    TG+mw+OX-QpZx=^!nJ,~1YCEp,@aD3?skOZ!-u25bAs?Cx27;l2<X^?2'O\#3-r+rnp!}G9Xx,kh
    J\a}s+*[,s7H5\V1IDlpEBJo]2Cz1j2Z1vI?><~nJNDaOB'A~GBx~loP7aRaC*7zs@*i[<@,r~Gi
    7HUGFKGTQ@Vrwde?zmjp@rN;Y+xII+}M~'B,a+5i3O;7\3x7\-Uo#**?!lG~D\T!>>e3Emo?Up'1
    5@3uA$Y<#XY-k7'1D-,lYi[-jZE[/BlVoPp@>Y^T2z-,v<Gd<8G$QiI*z_R@2>)/=HQ$rl5k'n_B
    pvpeo$*n+1UA_+Ue~oTGe#5+QW;-HLCDu]RepOqJ5a,i*p#{UU!I2}VO},#xxo+%Ow@njEYB=XT#
    >[v]RVEKR@HXlXU'1R_U}#'R%T[H-q'@8G=Z?DZK#E-rxZ]uom$EX!<]@u-@BT,e,_A2TFD#x[v\
    l]YzXIa}wW#A@EB$u3exmJ.!1nV}?+D=$TpeiGHOa^Ts,ee!wj@QixW=UGaQs17P1xp]nGv[(_{j
    \WrR!l$^7qk$l1OCX>ypBssl5HO>,p\KBu1@+7@Yl;RUQH;o1BB6Rn=YxkIBm-Q?[vIJF.65_!er
    !Rl;T=U<\'R3j]$wX1?$<Q\]3lkYja'OE{$C@Cu5Q$zVA*I"KVX@@]pDn+^p}G^#Avs^jRvoTH~\
    q}O<nz]hs@w>?vxWvJ~G@T]2}?ps7iE[sJGu4g\@{;oXImF,sA<_#uraC*{xYwIBk2@QHs~OQUw+
    XU;\z<I+^JCG4s3R=^+TKBQk5?zj]IJjpXT~CRn!1aoJKr$lu~>E-E!@X$\I'Te[JlA4~luC{6O2
    '11Z>sVAwEx<R>JeHnlw!]l^3>mEA5l#emW6D{mCK]{uAXC,Fr}V]7'[Z2eDz6[oaG[7wRs=e?@5
    \I7H1>_@JaCp7>s<,K[-;G<BJAK}Aw\urCuDmni'i$Z'7r1H\v?BVz~sOJIN<p'w=B~vHCesQJW]
    Wo{ui'T\Bxk[vuT4*#'k!'5{lv?7z\R=rk<CN,BnY2rO]\~@D5$3OGew[\ZoDFiOK'[G[IG!jx]5
    ~ntCZ+^j#mZVw*xI\5e;H2rYl@wE?XvCVWm\]1nDn_Is7r'i<Oi![e\Ta,xUt#O]A3Aw>ia-';^m
    ^OA,;W\$WlW_-JCun(G3_Q#<o@w-'vEWW>vK=[xUDT+&I1v*r]v7"c2_x-?_Vp1oEJ+1'7zv>kkX
    >r)I[<T6;<(26G7sB^]w?@nQTC_U8G]uCCZ{s1,~UI_O]I1VKzD?!#D;{8JpATV^r\{r}e|sUYZR
    Va5B@>a{lJ]s]!px'KI*1OkWE73z3[$0FKo+DGVxWTG,XVxx]r}]x<Apl47~Gp<x>xs-!7av5ZDr
    D,l~2amCe2^rv]3<a?5}Zm[E!}DnS}i^GT{Cwru}CvH<E<apk!I$Imz$}v^VZ+^wl\/eP;w==@>X
    Q#TZT\]kj;_j'7$C?E~2~W>u-V5DXQZ[1yOoWQx3K17{sr|Zo>;)1}[^NZx,KGAuUhaTn>0uliuJ
    e_I5}j'Q^{~1rXDrs>XImm-&1A1{dmnZ#&Dn77o?o?Q~}{#UV=HB,,p~s>RRiY5^<We^O-^i7Gp^
    ~oK5XYv's[R(QU*#7^uzj5,v.jH35BV!k<[uR7}pHSW7;$Y;AlUs'Ow[j5Q-e[jmzva+XUZsv!ov
    BiW*?R37DRGlv@isAj#Yp!2YHneHHo4{e@HMRexAz-}p\VZGeO*@Y2GjEeEW8URoTYE=!nqDJmEs
    X;wJ$mRIYE+Gs5]5+VQVj@WsCKGEh\Z$+#'sjY~YClJ]AY>!?J$zC{j;~ji'mXpn'$JDBj_<xJOG
    rkCrBAn~n6]K}aK$?Yx!=k4qoe,n:@V@jme[,^-=evGj?7({Bi25WmZVD!x~o$]n<\}1lEIT<K@y
    $-D27K_uw_+oRCXV5;-*ODuo1--'pz;Gl>*?]iE_+e32HG!OA]E<-IK$2YDu_UTe.}uK^y}E{v${
    Os?=*Z~5;*C+l5>+\uVi^_7Z+-K1Q]IQ!vXH2Vov_!i=x>ll1^H5\wxHXr~E5Cc7^r{H>-;/D;\j
    {^W#rO@1RH+E|GaKOjVo,mrTWWa<a5zv-(^+DW_zA^YH{nuA@n'_jk2V,r'Krn$p?R^;[A~_T^-x
    u'57VwO1!B/_,HO5pOEqE1WXCCX!kw<vAUDl,;}kdGE;x]I,'IkHC^ZY}w5,mp3pp7C{u|TVpJcA
    \O!cWDVR?aT=BDkl,s}j~TH1C[3*z3<XOp<B!$'Y@r}{o[BWv@+=*\%CO-XE3>js]A?o[7O_7;Js
    iEaZzGaC$pW3X_sg9oxGQa1zG3_Ko>E}EwGxBE-J=AX[i.TzkYZO2QJ-Z?,K^KEK>>WsR?GVW@mH
    O~#B3z~AD$s]Q,]CVEjj*K+*5At"W-\o-C@Cve'1iGlo[C@OZ}!pq_e_{dD1]?4PAEH[~OYO5V>R
    pU-[j3l;\-s#C,k[k*1A<11@&aOp37Hp[}\BnBI{$XB2!^_+#/rX7CzoZH=EJ7WQZ7T+E1QlIRbB
    O1$,DV+_Ql$w|xa\A5\a73QozRA]nI+wO]n+3='I}?j+1I_u#fI[$Q1r5!?&<s*<{lF,2Yk<>=rR
    vWR'i$*j>VD;Y@V]jYz\^151BK]{+-u%CC+mkp~[=E^{G1r][kB*a-}pRmTv<w}DpUGV{5~puOzj
    bzYKp]OVDj]\DEG]+5AEO']'[Y_e{/Oz#zLW+H=v51^1~Wa*;_^T,orunoXpDD*<^i>w>ywr}r?$
    OZ2G2}KQQT$Il;aQn5rTAR_{rZzjW<pnRQR$~W}3$$R{H^j;CvlRDQTGzB3*W<O>o#%@eH\;Inu;
    pAW[1vU^r@]\U\mOw_zUY$x>BlrpUQ@rOO#^Yej0[Y5@EijJyu+ZKulRO2V1<m5uJr+_i#-SpUx_
    rK\rU'{C,o\DQlO}^ma)iQv{2E]''1[sv[GChEvEp~XAX5-Qi/o1aED[o[MTI!#>I{?$w1\UC3Q;
    5mO5gy']~Ex<UZ}3HDN1mj#=@oG!peI\#3[-Y>s"felQT31=I<AH2$E?v}@x[Y51ik57K5'B;eGu
    wOX,n1*;TKDD[q]ixm^uzAhe}@;G[Q7[x<+KoI;7JO<$i\*ws$CJwZ#l~>[d=1p;@7]~}3;Axeix
    G;,2IKXIAlH2=YavIi,QBWuXoC7ll'k']ns\]-zGN3s@VCi_AS!zXm@Y#5YZQJCk~#Z<XY+1?GB,
    _-QWo.v_IeITsmv06EnoYAvs-QRa+Ee;Cn1UOl\rY~5rpCAK!Ka@QDZZ(lVKu7Gi]Z\K}TUWjlQC
    *2$r7#YxpB;I]<XVU(p'1sLNH,ouWom\}a>Oms?u3z!*n1Ymiexxs=;CIV;!Ks+$~n*=M\4JelpQ
    \Op:m{<BjI:O2-7p\GZi=ViHljo%133~i}!!UB-Bx@+HeDi#4i+^UkU[}2tvc|Jxi<=aO~c~[*zh
    ^GZX?7rxCW+V+}YC_'2xrX-$BvWlu$7s3{K*YAY>{Q-GiwXke'H[vO{>E\<sxkn5MQi'3MPF-[7~
    DZ,7zALKxEQ.irHu)1EwvCrw#]l=r1iAV*ijx]#s7x!,D1B>j~*G2'^[~AE#,NQVQ+Fl'a]z]KBj
    ODsXzE*;Bv'@pjlplW$Ek,JCi^#ae}<eZ$~'CD\lx>C^mm*zp+]j!mo_w~,lr]ml='QYnTJBmQoc
    KwH<T=\Qi17Qi}Z]m=#jVaz!xQ!p*Ksn|_~ErC>@',7
`endprotected
endmodule // module vusb_hs_portctrl_sm

