/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_pe_datapath.vhdl
-- Date Created: Thu Dec 21 22:42:31 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_pe_datapath.vhdl $                                                    
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
module vusb_hs_pe_datapath (pe_clk,
   pe_rst,
   pe_rst_a,
   pe_up_host_mode,
   portctrl_rx_data,
   portctrl_rx_valid_b,
   portctrl_rx_err,
   portctrl_tx_ready,
   portctrl_tx_data,
   portctrl_tx_valid_b,
   portctrl_tx_valid_early,
   portctrl_tx_valid_last,
   portctrl_tx_ls,
   portctrl_force_bit_stuff,
   portctrl_pe_busy,
   portctrl_rx_data_r,
   portctrl_rx_valid_b_r,
   dp_tx_fifo_cmd_dev,
   dp_tx_fifo_cmd_hst,
   dp_tx_fifo_set_eop_dev,
   dp_tx_fifo_set_eop_hst,
   dp_tx_fifo_ep_dev,
   dp_tx_fifo_flush_dev,
   dp_tx_fifo_flush_hst,
   dp_tx_fifo_tag_r,
   dp_tx_fifo_tag_r2,
   dp_tx_fifo_data_r,
   dp_rx_fifo_cmd_dev,
   dp_rx_fifo_cmd_hst,
   dp_rx_fifo_data_direct_dev,
   dp_rx_fifo_data_direct_hst,
   dp_rx_fifo_tag_direct_dev,
   dp_rx_fifo_tag_direct_hst,
   dp_rx_fifo_err,
   dp_rx_fifo_overflow,
   dp_rx_fifo_cnt,
   dp_tx_port_cmd_dev,
   dp_tx_port_cmd_hst,
   dp_tx_port_data_direct_dev,
   dp_tx_port_data_direct_hst,
   dp_tx_port_transmit_early_dev,
   dp_tx_port_transmit_early_hst,
   dp_tx_port_ls_hst,
   dp_pe_busy_dev,
   dp_pe_busy_hst,
   dp_crc16_rx_tx_dev,
   dp_crc16_rx_tx_hst,
   dp_crc16_rx_pid_dev,
   dp_crc16_rx_pid_hst,
   dp_crc16_valid,
   dp_testpkt_start_hst,
   dp_testpkt_start_dev,
   dp_testpkt_done,
   pe_tx_tag,
   pe_tx_data,
   pe_tx_empty,
   pe_tx_idle,
   pe_tx_rd,
   pe_tx_ep,
   pe_tx_ep_early,
   pe_tx_early_val,
   pe_tx_flush,
   pe_rx_tag,
   pe_rx_data,
   pe_rx_full,
   pe_rx_wr);
parameter usage = 2'b 11;
parameter eptx = 1'b 1;
parameter eptxa = 1'b 1;

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   pe_clk; //  pe clock
input   pe_rst; //  pe synchronous reset
input   pe_rst_a; //  pe asynchronous reset
input   pe_up_host_mode; //  host/device mode
input   [15:0] portctrl_rx_data; 
input   [2:0] portctrl_rx_valid_b; 
input   portctrl_rx_err; 
input   portctrl_tx_ready; 
output   [15:0] portctrl_tx_data; 
output   [1:0] portctrl_tx_valid_b; 
output   portctrl_tx_valid_early; 
output   portctrl_tx_valid_last; 
output   portctrl_tx_ls; 
output   portctrl_force_bit_stuff; 
output   portctrl_pe_busy; 
output   [15:0] portctrl_rx_data_r; //  delayed version of rx data from portctrl
output   [2:0] portctrl_rx_valid_b_r; //  delayed version of rx valid from portctrl
input   [2:0] dp_tx_fifo_cmd_dev; //  command bus to tx fifo controller (device)
input   [2:0] dp_tx_fifo_cmd_hst; //  command bus to tx fifo controller (host)
input   dp_tx_fifo_set_eop_dev; //  set eop no received flag (device)
input   dp_tx_fifo_set_eop_hst; //  set eop no received flag (host)
input   [3:0] dp_tx_fifo_ep_dev; 
input   [15:0] dp_tx_fifo_flush_dev; 
input   dp_tx_fifo_flush_hst; 
output   [3:0] dp_tx_fifo_tag_r; //  1st stage tx tag pipeline
output   [3:0] dp_tx_fifo_tag_r2; //  2nd stage tx tag pipeline
output   [15:0] dp_tx_fifo_data_r; //  1st stage tx data pipeline
input   [2:0] dp_rx_fifo_cmd_dev; //  command bus to rx fifo controller (device)
input   [2:0] dp_rx_fifo_cmd_hst; //  command bus to rx fifo controller (host)
input   [15:0] dp_rx_fifo_data_direct_dev; //  direct data stuffing to rx fifo controller (host)
input   [15:0] dp_rx_fifo_data_direct_hst; //  direct data stuffing to rx fifo controller (device)
input   [3:0] dp_rx_fifo_tag_direct_dev; //  direct tag stuffing to rx fifo controller (host)
input   [3:0] dp_rx_fifo_tag_direct_hst; //  direct tag stuffing to rx fifo controller (device)
output   dp_rx_fifo_err; //  bit stuff error detected in data written to FIFO
output   dp_rx_fifo_overflow; //  fifo write attempted to full fifo
output   [10:0] dp_rx_fifo_cnt; //  number of packet bytes written to FIFO
input   [3:0] dp_tx_port_cmd_dev; //  command bus to tx port controller  (device)
input   [3:0] dp_tx_port_cmd_hst; //  command bus to tx port controller (host)
input   [15:0] dp_tx_port_data_direct_dev; //  command data to tx port controller (device)
input   [15:0] dp_tx_port_data_direct_hst; //  command data to tx port controller (host)
input   dp_tx_port_transmit_early_dev; //  transmit look ahead (device)
input   dp_tx_port_transmit_early_hst; //  transmit look ahead (host)
input   dp_tx_port_ls_hst; 
input   dp_pe_busy_dev; 
input   dp_pe_busy_hst; 
input   dp_crc16_rx_tx_dev; //  crc16 source from rx port or tx fifo (device)
input   dp_crc16_rx_tx_hst; //  crc16 source from rx port or tx fifo (host)
input   dp_crc16_rx_pid_dev; //  crc16 from rx port upper byte (byte after first pid) (device)
input   dp_crc16_rx_pid_hst; //  crc16 from rx port upper byte (byte after first pid) (host)
output   dp_crc16_valid; //  crc16 matches residual
input   dp_testpkt_start_hst; //  run test packet
input   dp_testpkt_start_dev; //  run test packet
output   dp_testpkt_done; //  test packet s/m is complete
input   [3:0] pe_tx_tag; //  tag from Tx fifo
input   [15:0] pe_tx_data; //  data from Tx fifo
input   [15:0] pe_tx_empty; //  empty flag(s) from Tx fifo
output   pe_tx_idle; //  indicate to FIFO pe is idle so FIFO can populate output registers
output   pe_tx_rd; //  read from Tx fifo
output   [3:0] pe_tx_ep; //  endpoint (channel) select to Tx fifo
output   [3:0] pe_tx_ep_early; //  endpoint (non-registered) select to Tx fifo
output   pe_tx_early_val; //  pe_tx_ep_early is valid
output   [15:0] pe_tx_flush; 
output   [3:0] pe_rx_tag; //  tag to Rx fifo
output   [15:0] pe_rx_data; //  data to Rx fifo
input   pe_rx_full; //  full flag from Rx fifo
output   pe_rx_wr; 
`protected

    MTI!#{+ae\z$}kIB\?oBe@a-3dETD?}13$m[}[:|z=i7}+1aOZv[95&[;UoKEx,&1z~vuXQplu+r
    Gzu#o'Kavv}>XHBO}J-V-C?,7JK*SzR32J,oB_7#28v~Tp<j{G#t=J,*v5oI;O<kE;>QqnrQ1;au
    COal@R*EB\mwkuz*$OpiTMKAYD}<L\EJoChkv.x_DTmRH7{+21Y{mOb$Z_p?j[}6X7kVxJTuo}{J
    vpUv:RC[3G)s7u_E;p7Hw1;IZ-'u^l75ruH:sQDuxbqKnwO5CRY2=W=Z<-aa&'?[[i$_mvWH{~{7
    ZHE\ur:*enmIvTG7JBz7mQnW7wZ3ekEm]17"1Dw{xV}kIvRr-'zp8@'j~&"B5>_EAw$J{BG"#[>Y
    tuYJ}tmGQ7qilR=oUu$XSER+,:UE][$BnX]~+jZ\G[=$U?rOI_'EzO6w$K[I!1;K*rC[Z$~}^Awn
    G,un+~eC@O^li3!>rV?-}nGGYRZV=paz5o^El2xGu*2x;{;O^<WYX\I'v\j*s\u5Dx\dUz^]*i]7
    ~REn7B{$-sHw_u-<{\'Q]=m;[Pn<p$dC?<JXj!T>]BpUOiex;B<17@;7uYOCmZu}rlEZ$o-A'z]'
    TnoN=@-*xKHA#*RuE]Bku{rQEkAJ>7\7z)T]7~FlA-n:vL7+2Z*UHV~H}HsYW~jT)Q?zrv~e;ur[
    \zrJ[AOOUWD1Q]R[,rTDB6Z'71iBYZ6[E3'vU21V+KU1**ItK1U1o32}C5X5qYZ;<|Vl*\Z]A3\a
    Hs*r^AXCpsB=p,mwprTR1sl#X~4mC<5wO!ua-ZWCHOA!lK{yIkx\AG}@}FIAR1^]=j:AEoI'<Au<
    G^5~V75e_oDjra+2$V*UElZ\<>1QjuYCAG;^\*1@-*O*rwovo}}HeeoZQk'DA1zUCa2p2sA#U>=m
    Vi3S$YTCpEYm#}W1}+!K3xI^Ia**=>*m}R?xjlD!@{*^&57wnxg5ZO212-^~aax!_?_pV'JoB+[o
    *e@'1-1@RX_j8xs3DA*;^[TnWxT22$}kU1;[<8#^{1wX2mo-J;V<X1uavT@Y'i~C}<;GKj#TG;;D
    S*CR@[7A#IVX!VrrG$*UR'7TKA<nJ{aZZ#sTsM2*oI'1oK7E^@UGQzRm@TTI1H[G1=sR,KR{'1%c
    ~Tz5Bm{>]}@<+_!QQ]?Ku_\RmnnVUQ~k\[7aA{C\e5EuI#xW=HTk{+1U\,-GApBJqomX^,{WRL>+
    u~w(VsJ7:X$D[nU[$x>Vz=<u=F#Y*K-jQO^z$Q7~@OA1nWV#~H<\o20^On=|Ue$'O<*ZsV_#H{fO
    'Xz6YZelEWx_Aru@$$jGP>5WO({BX#HGoHmnX-4XtO;UI[mpU$+<'a-W<[8{Iu_=1oG,_Gwsr$x-
    r#G[nOi7UGT{XBbiTXEDP;v2]=-B7IZ2Z;T*p=IeJn+j$}Rl'}xE1lC_#p>Duln1E{B?'zTX*4s2
    3pli+!wXEi;nm-ACzX+o~I'+wzv5BAToY]BJzo0PEao7Gi*?fC2{,CuuXVqc<U-#YlwuqG\B{Q*U
    #NB2R>v!1}RT<~r$e\+Un#+aeu5jC~~HoCJO<Apo'!T=Yun]^vfOa=@s>H,Ef>l}_})OG1*#jKC5
    \K'vsmlqMp?Y@+}@$SuU7C%r_{C$lnw5W77(~xVI}THo^\kj2olo=QQ+j9sl=<2TT^TTwHA7-=Aj
    !]2l3\{wDO},Ir@-7DoBoj\QoE#<HR,e^l[Irl=#UOae;;DT'Q&(1UnV3]B$jm<jeoEeiv*]$_RW
    ei1;,p;\JqmwlxAo3B!TWWs^5QE,G[UeveXnx]x*@nGVDu#wl@'zvvI^Wu]WC*$U[ZHV<XKsKBjO
    -RO~[Ap$puBD<[r}HQVU!1'{*@UB*l2wTksul_G>^m)ls3_#}nYo-}e=?D7CgxBE*BXEK5WWnOAD
    Az~jj=/VVr3?{Xel?{kjzWn;O(ye~HrDnlWsZ]Z,_27e;BO*G@pB<I[!&H+Na9L{o$rx;G@OwVlB
    3l<VIZlR[RzczZpTLC!T{pU[}Vzi?ZxoakvUur#-onxV5@DAaV\m@1<XZmHI}oAJ5]cYnj,]KX-8
    OxX^pk=[s[*!w[?aVvum1uJ3UOU!az$TYJ{Us~V>.jw7p~aGKU[kGpK5pTVGaR{<B^=;am$-^G+E
    VXA]7I!5ZN2Y=D7~BT_Q]~1B#{T<ZQvI=Tx}1<<VrAR[?#5=5w%_sA_GD!O!w[+G>C,I2~5]LAnv
    KXoCY}{B2a\>u-$-!=EjjneCki\m}1#+sj@DWQuz@p+^BNe_iQ){>ZO^G!}qQW;QTV#v1>V<WQ]3
    -hG3'a;$uY(>7pWBiuQvs[*rIB^{C_m-U2xSm[[zp#GoXeOBl_ji}UneT[>2GN@vlJ=]]w1@x!T{
    =APxF|5wlr?BlU-_DiEk'AwQ*1SfHA3VQ{@$*$,K$XU5[w,xIY2KtdxvGVLEx^RYTlD*iojG~I^o
    Xl_Gmv=S$u$5op2uO2'EUxaaEv$T3opr)OC5m>1xXv1_j;>Xxm,17,j,Yr$sK,*!YB[mu-<Kp6G@
    v^v![;}YXWs7R^*nG26f$Kx,yfc@OZw:f(_wUpIi73D?>~o*EC{a>,[xeE$+Dr:O23;q!ED=#$Z3
    ,Y+KHp-E}{Awp#jad];!au{u3pRW]7ZTAW-D~*}OI+XZjR+]~l,xKu>^Ta}k@'s#<Z(GuD7q;C*a
    }-7\]ap^_wQ!E$$$Vl<K$nw>KY<[@<<?@jV;_[w?)$en_lzYup[$uBR1+lo!I-jXXW'1ir1>=V~,
    'L]DC+[aXkenH'k.s?OU.,oD$11J{zi+A=HfY{5@-\xue5n1F^aOVX'oUlJu^%jjlxswl$E\~7C$
    77aEnR}AdC-~^i*>o5n1przC]/Bl$?]@Z\!AoG3VNUz+?skx;#a7xi]?}e{]#?'HUfs\Ve';zuIB
    z<sv@K07HQiYz}U6:|<Rw7BVC[0JwB<a<l@EC3+KOQB\jOi2U$~o1+KxxsT9t|E#2lT]*G#C~=i=
    YHa[X^,B?D>R@@=_B$>pn?iBz>}u\=}U>j[IEUz#*;j#j2)}'BJw'Hp!n=pQ+]o^K<oa]^teU1}1
    QOpwllW8HYD;$7D!jOmZ!jr]85K>+[O>seR,p~Y5!D'Ag@=QThPp>*T^\j>Y-!3^{Yv,\e1Em+?U
    px}QpCi5/vUZ*,$e#2sK!;-VwQi$Da_EQ|[H]-7juG8}'1EO{Ge#BZl<B'$Q+E,9$\<nlHKvUUsr
    z]ikQHl@[@Q>*Io'2YX3Q{QIQ2ZlU\W[7T@+kQ-#~$?@53I1*]JrsOG!ioY^W-@][T*T6oAJB-sT
    kYr{u#e_k*yD7^?<eK<3X][1_5iy^DvouBnni<osUowHJSFs~]OGKn;A|#z>@s5+K4{o7m+Gzn@[
    7~esW[;w$?@-2<]W_XRD>JUaAW^!'u~Ej$7J~z~s*\o?Qr]C^KB[R7(BrrVU+CsV{XRIx]!]}Z;C
    @}][uC[$]'^.<Y*lQ{>5EwA3}R>-Qu6t_,xo)|fGPJV!@tT\J$MzYu+l^<{kRri*'<zCnXm84Y@u
    GOja],GkDKv=ImU+[^aKV>z$m.;>ue~Iw}U*Gpp{TB^tzQ]!_Yvz*@T<@{IU+vBBW^~WB;x]HRU$
    I}ATR'pVaH_aYx'Ov}-xxW5YVa;*7Dyp@ERXR'xO\V-qYxe\/WxiRTO?{s7O=JY}{a&?$Wz1D$]B
    [z;*CTK>aXx9@v,R9HrZ{0~$?>sp12!rkExr#pYj'Bs=!#WCOvh$ZU~?a{p}sIwp5wpvJovB~Yak
    $\Wi+VrvAT^'u~5?}Z1H(X,i3WHXGw]11$o{n1npo&kHVvIvn$G^lpzl5,]pY$@Tr{kGjv7Zm~,$
    DZOE$vLVH!IBX{u](5KZo!rHOEx3aVRW$IKH$]2VQ0=a1iO72w>jYH?'R+jIzwACO<Q-7+{oDvHT
    w=jZnxCn=x/*~3*Va,-JE!YdeoO$s?=u'*+eUBmZy/E[~JvY]H,B,kKB~vpj]j+,kUl**kpECj3X
    r,#,lI];QI\^v+]^3l*kDW%>*QOJ{R@iD<>,We>N}3!a'eWVas-Tt_~s-PxHjVYOxXyh}IpGuD~=
    7o,s!V;K[]m\;_'a2rO?,uRwCPk}*A![,^27nHC6;H@=D;n{Fa5~@DE>'!{T^x5I==D3E+<j7'3=
    @#OU#B^1;D\U5(a]#j5~x'Ae=G5xOo.ealHATEOpAuatr'{K+=n1:f]mAJ1js*#TH_pzZxOsXExp
    a*o?,eCoG[3EnrDpw$?5XK<l>,$A$^-DEKIya+D/zW-!$={'v{x]Z&.#<3!$IXK93rJ^DW]GQJoi
    aX2T=-Q$u>~?I]x\la~GzsD2+s1u'{Te[RQYuO7{+p2rKC$K~G$ixe>'$E7vCIi5--lzPn[o-\vA
    ;iTv;n]+_(\!'O[-XI!}ez,v_!JHe7$A@s7BO-RaTDF]l4\G#_jU-ED_#U<jAW\!K-!e2a>^mO[j
    BQ]Zp[IHuAD',YQY^~asA2{G~_=W<YrUm\BJO_{$$W8m*Q1;<QaD[pp<xro'DlXmpX7O=xuA,->M
    ktQE}J,\r~mY*i\v-=a\T1rC7ib}G^wM<E[{feom=o;-K|Ka=@QH}TU'a[3{Azj@G_p?D}Hrn5R5
    =Tg]{]x8V[2p@v?<UOY1,*@\B=J]l+3HO\BRPO<X+w<}$*<_\+z#+bY*wsVj#5w]1R7eU@aG']IV
    }U;11}[C'j_~!-.nUR[{zWD};HKwVX?>}+ee^}mj5x3wpI^,>Iw*$^!*Q*#nRG2$!YasEx{a1}'2
    Av]09}K}@jYkm5pxvb-}3{[_>KsuA@\2=$]CAvIT<#mOKQm=?m$n\wjj_A5Y3uza}m-DCQ$r}2jl
    _KCzRDnC]Qc*w\E?YjXIs1Cov'vZ-pl4BT==O;7~2Hm$NX]3#@BWp;Y7~GU1\+{=]B!OeCz,Ga}2
    3isOpD3C?:znXuonD_eOBeYHmAD\{R[~_a@^,5^3<~6TYJ5R!GU;qvjiQ^'Gul#{!|DZKlJ{7{=7
    !<-}v*7>E1>\*OsGkua{{AHO}#IrRKV^{K=I_j5zvwB_*U:IMEO<,uAXsE_+\\^<vVY><2s@Jl,^
    37J-v3$Y,}E}i%Wsj,MFD}J5\w=xM'A'I>x'a.x<eQ]N}p,Gkn*@z7Y3[U=]<[7{OCX+Oi_7~a^B
    p_nKzm!=FpQ]U2Izx2[mHr^#l_z=_zJ<AR\a_CC[7=r-;@$WV[KT^w$zG^GEs5jBu=V,DxI7C*]R
    !TeHKO5i'3L=$=UxJ}U1@>CHvi!KaW-EOn;nv7rpZlj@GE#1Xx$rn@YO;wminC2vsWk;xpk]^R^|
    >BW\M%PpK--7J\$]$X!#x+\B7-1Mzn,<7QJoWX@R^wu5BaeGjL'2G;qCaD$^zJ3O|_B3=nVw^X*n
    <'^GUIAH52VJuVnsH?TvAoxCeWw[}DI'+~E<Jza-^U$=pGGjkrB_kL~s\J(C[YDOVjknBVn?n,TC
    ;3*'mZvOEZTCp<A^K',DBEKn$UGr$C$uoz;3^nxs=#54T=w{P,;OBq7$H>YkHQ$JmVGZoRgisIiH
    ${@fWwr~!xwwDm=VMvjz\{[{A}Ouj^'>Y\l^;;r?B;{=e5?Tm,Y-zkzXGlnejT7C3u7=I7[2s[ss
    pJBz2)?HEXse}ahG,Cp1$Os;r^aaE7r+_oI%=ul;\Bo@{Ru\j{sn*C3v[X'x=WE[a]ZZ{T,ZCY}^
    5Z1j@s_}~*ICk--$oeRv^$R-4~h!]+*E2Uz_2+W3He*Zp[W'Ao[WGoJl5l{}$poT=H>$]GEqt+}a
    1{'zHqEZ*1?s=,r[D2kj1T}[+A>S}<ZoxHnp=k'KHE<@#{KOeaW_OlW^U}I][x*C_u{_3p\J-}^x
    $r;BbE^r#*1z$oZxu5\pZ;nB*(=X2T'ZU*kaH1_3^AD*pEHx,so^OUg$XvjFU+oB[^-\:WeD>-[p
    <%$a_<z3u~,Vm2D*@{IX,exW!v1+mv8KHBkfSQ<;Kfm<K<$F5#C3^BIk@7U>QA+a2XG@,O?~B<oC
    z#akp+e2N.}BuomE!]KelsJGp,u,.g2o5\?Y3<QxA]2sT'A\VK@s>k/DZp\7srHU+C@UvQ,YJE?]
    CY_)p|R7w\m'op;=Ik+RnJkh_UY76\'OZ3<};)2x}^jmDr[3TT=s_Gp@uH1{,'$V?;o-Ul@YV$C7
    vBC-TzB{WBmr!!!<<702_'3{7RTva$HQVzQ#}R+U5'v\O_7Y\!{LOr[1Lvvw1rU*]D-HDBJ-$MJR
    [nOJT}WVwnW}3nSCkRJm*\wkD\sgevZ3Im<ApJ\>E+5>#_-'R1+Oiv=<=R^!k[Vz}o^EvzRnjRjr
    ,#_}-pe7p-CWu7G7?wTBEB^<(vw,mW<]2VZUYmoDD<{aO%~{1I$1[,,p;lu^e]Wv_w5-]3sr[{aw
    p!/w*Z1mp;A03eOjEA}zu+~7$~X[Ta*DSIx>U=^VGeI,srOV<_=mo0=ap\rZ\-GacIE[5^:m]Im#
    Hl2!Cj*\!Z@[i$<.'Q3ji\V5JI3H]>{Dvl_j?]-!w=Az3'<KHUXTBJU;dGnO<TUAxIlApl^xX=Ze
    JG3DvgK1!!8+Y7Qs_1XBDVY}Z^+_sY_Aor[K[s{{5aUGET-1{m>BJa?&HzA*}J_T|kHw,K1Gvf7G
    _H-Bll"~*;+AO7HR!<uZz1Ih'RZx-<!X=x*oizY_Y1[Gz*D#uDJaFvH*?E{Er;}e7seEjlpR;rZ+
    ?;+<O^nBA=Zz>{>VDzHX=m55e\@\k}u-L73pUoE,B@^erGi<9D~1O7DUYiaBs,+U@hG-Z,iH=wps
    Y#=wVB<G2Bs[]k&E;mn,<ZK+{C3,<x2rO#AOx'5!xk?xUwxHa~J\W[s5O~vr_k$=Qs+^2o#$ZWnE
    :4@$$^B[!l&'xQpT]j[OkJHI~Ae3=[!Yre+j]Qe>}T?H=zUxER]Vns-w\e{ECzvT13!Q,Xn(_Q_Y
    mIXx:Cknn:naYx#'/gDrrRVW1!Tn{*ozq,-WZnA]OE+Qew+ju-OoY[xzEi7B,p;1juCKw-,C~K^^
    15erG5isioI!;p;KY5az~;':MR#{]pW_E\l$C/'s1W4z[Z$OvZ{@]]^_?~UYDm\>__rXwODKjVV=
    ?3znOY*-jBK*IDD"'DB2ckB1aQk^JlaG_zKB5zIwJj\Js_W-CEGT1RdxRaU[WHvmex2Tv3YWA~nP
    Ke,_QxpOY23+Z>+~mTI7z=pm3Ue3%W$T1RV1{\)g)[<~Yj_To}~ZC#,e\5nCi\+VB,YGDnQp^~vs
    CpPrTZJlmn?Bf='R\S_5a!/@EsWY+*-Z+Ao'26*!Du_E3^IXv^]RTkUUX3BT,!!X^o;n]}/Dp<I4
    wzwm-U3ZRj#^,!w#4YaQo%+<sz2[<-$mW=k7*>n<5mx{B_XeWn~w\$|=us{F%[DwD&]vv~NA{EOl
    ^]V}R-m>v-@}HoY<HpJl<[[Rx!E_sel/r2G}D5XHsDKRo5'*7'a\Ko\1=nwQ>'lX\Rjm]ZJ2S+_H
    ]~}T_uU7De/-t2H7^BrXw|Q=DJv]_kQ1Ju-a~wRk=a7Z[U5,~rK_j!in5*m5AoD=AHWz#v[>~'r@
    V]pXp[#'+rOlEC[V-[eXH}D+W#J757}XzCO}-OQ3a^p32ex23$v^Iif{V>=o\+=_p>luSs3^7+IT
    D[Q~IulpZBe_~Mw\]JiI;T2{\HY;U$m=iu$#lXNi\s@k{1Gb\jK?Ws\$<_+x"O?YT>[JzGBXA!^o
    TVxBrZ\;[*X'Do,<\E<~@~VYw5RDJv;2~B\AZz+eIxsp;OZ;[>B3r18+,,rQjnYsGWDt/^$[7x,r
    ^7a\p\mzzD]VGlauB5#~l/xmKeGRu!lYCoU=ETBtpO$B~53Q<URjYVzE}OA,K1DV(3pwwxHHVZ7l
    x/R]vQBGz'!}-^r7inlsX@fXjH>=x@$>HzSYEnvO],=Xa~H_DIsjT}'Z7GHvlk@n^Isqm'r}OwHl
    XVuopR}[C*vI(mD@p,}W,dwV5r[}nml2,Zr1ao4_-wWDq$l@G$[iBV5U')BU2lf{j3oS-I[~(]vs
    lO][V~Cmp3pmpxXuRl-rBuYHev'2p@,3@GJ=~eWzTQ-lIG@K$8xS1*HQ[\mZ[]?jz2n?u<7Cu5iB
    3{\i}E2EvR#j2xs3UG_ZY,mkRQ'W,C!BWH[~Pn7R$^[{BAG-*,ZxW}B?]],\~GVuArl]Xu7C^wE^
    ]T=^X:o5o<Wzzi]='aBOe'C<Bk?1zWeQK'4eC5R}#3^lU~nX1JHxk[Hk'<^]W~ljCpi}s5l<Orrj
    psuUnxjeKK3=3*^<$kuV;sJ_kYiQKDlu}r~+QOKJ&C_UjVKWHGl-R>QBjsm{$2z#2$E#]TB@=O5A
    VI_k2%snVJnzVAQ*$}Yx2B,vR[mU~aU7o}55*Ve,mTVw}[$aQrhpsO'*pkkkaw2([voik\Tpd7w3
    @}]Bx[Ae!q{|3[RQE5YVW5,ED*JeVg+VHDA=n-[uU'1,EX3[{[VO7@VlT=o_=H_VO~3]w~127p_*
    AZMmG{lK-$s{-3ZIrZOC[,O~R?lIGx+I$@1'XZ*1;p7s^zs+5K<T]2Vl*?w1^3mE<zAO_OWG^UEn
    p>K}5au?parWT{pC+Jmeu7,@,Z>]lwBmaT2#$K}$^TAaDjHpX5<5nB~I\jO]HZHM$QI$(zWz,IRe
    _[3*+e~I#!qz/UD7}u{A=$juK9z2TQ{o7[ohRYBJQvpVZL:B27oLl;j[n],?G(Z>{-ipO>s$HoW5
    !W#+r1G>{3=D?~=B_BIlsB;T=@aX+@6&T57p}~rEUD<VBVam=Ao2l-]$i}G{r-wm-nr?!['B:o=l
    ul<@O#w$kQQi2{7D#DI^uuV2Y*R[pBGs;YEpJ7zrs2ViHDV}H1-KkR1YJE_>-BOE7k_ZDke@sJ'n
    ?Ykwp+H~XaCX{Ur+GW,_Z8{$}J{,U-swXKl1\x7'pYz5!Vqa'wQ~UsY}vY^UowD[]KkCov?Ul7QE
    z5+fa[R--j!+3<}+Y?3ZY$KYY7B\s,DTv\Z+vZr]@E~;=OJYQv?Uqda15uV=_anVQ,U^{p0wsT<Q
    +wK-l1EGx@X#+XE;Gm$nGQsKe'}o1~>U1EmIJ@URjs\m1k{)}$BTo]!^OJ<_i}!$&O*}Rx=pzC=X
    O}>z#GGXj3zk[T1m{A]lA<$v-TUD<e^Ojas^Afu[]I^RwKx3Zr+w>mg$'sJZ{p-[A+KxKvn_!x3|
    q!*k]pzpWX[Q3pBuIoa+JGKT3En@<ADJ<+XVo)$1_IUp,}Y+W3nAw^{URu!BR@~Eow,5VWB+-Y7H
    1rax3z0Rmjx$@}7$Kl?W,J3v7_{4}+vmF)[5J@g;V7+JH{e3j-Xl7DB0C[]?s_^V<1-z(G*e'Eaj
    VBG;?ol'<=4,jaVA7;Ji*>/}{GC^E~r!lOAp,B#h$xsXWX[j]mmWfl]=wb5$!OKQYYie>IhW}>~J
    jZauY*[$[H~3VYT@C{B3^l-D@G@[{'JIu~xA1''KoDwKR-jZ_XQo\>m4Z_T=7DW+R;X;_R*Kps@Z
    >]mkN3}]o/<HQ#'O2{o2zUQmZ1(oiIwUD!'p>UUz5DuAE_lfdQIVQ7JQY=jrQ<D[p3oq^DiIzU}T
    Y*!#D[I>[);+uY"]ZZB;_,]W[=AV1}Y#lw;pOeOjA;TUHRIL9]Ul5#R##d|\H*w{_@eOW]ThbQ~+
    J_sOuU^DT.px_2UGVu^ap7JpX}B2Y$Qo*lM!<2;0j0h~Dx1<+>Jgeux;Q]^eq3l_=!G']KrTC]l;
    V|Zv're}]?]2m>m<A-zA3n-EG7i5lo,<W<2o'DCWORj*vlEVi!WoE-Vi,OZ,I\9+n<[,$;ap[rD+
    TY2fWpmGTUv>=YW#G*Q#^_>ZqElJ_Uom{#-I*]$?275viT\w@AsDY]3}DGe;G7x<ep_B?''jB}Y#
    1^{E^HDDElK~vUG;vI@HC?wZCG}uT>+Zl1nu,Q1Z@p+Ij#DG'v}BoQB}}B'^VuRTxZU5;yxT}vB?
    ^Kn<$pE[!QNCW}A]o2B&:([oX>bA>n<!U{_2jH}=[D>$?$mwAHvkC'p2E\C=I1wtK]Q,ZwOH=3n_
    W=<+KGs#w}Q$*I7;yo)@UHoMdupAzo+^a;IC>HO2>$1IQ\V#juC3QvX[s]5np3_TW1rpH\RTY>Ea
    e]#n_K[\1m5\xg5Xaw)gWnAk>I+*va'i9G2;l>7ps\}^s$7+>]-*=&NS52_m2R!s>>KXBVJjB*xE
    [?R]+Y'5yH$Trv{[@+1]\;U7D[$qAB@HGj>CE-WrH*H<\viRv$pOC=\AGT~,\=wBAQnxF}2I{f]=
    zTI\,5VEL>Rk^pnGOeRWu-'3?X<1kBZB\i.Bi~u1\}3WRl@_Yk!U,pIYX+3DoeDj@l}wDRm]?mB7
    ~wwdiX[><VkXFJ}~ji]H!GH=J7$mGE;UlkIso"BUCv#XQWBO+Un[H#^W1[FosjY]+=m#^>!nB~l)
    XXGz,_X#Xo^O-xkvfDp<_IiQ;h$'JTAa=C#_Ol#Tj@u>pp}Ar{=Zl!'[@#Qa~?nzu~}#G>>XA*AE
    nGZ13~Yyu$Z@E>{^vW_ul{p{x=[>+x?10z-s~J\WX=KBoO?Dr*9tYJCaRV*37a,iH>K}BEKU2Ts<
    [^5D'?{7l7-o--p+z'E>*Vz>qd#}uWe$_>p'VX{*!EXC-s!YW2x~[1$7R-@vl{CQ!'-[*?nBl*ax
    eOzJ\#meuj#1k*laY{RQQ]r!<HL7=EaZr[$c@A}Y@BX=X*X1Y=XQ?VvRPv|^J_#7Q3QpUl[OeXH'
    Tv{R5kJX]VYVwV'=_,kdu$vQVKH@i_oaSQkz_D>nJlD#DABZE#DkCp]pk]B,+Q=pBq25X~zn-IB7
    BpVr$!EkU*],K[vk,xx0mr]AYT';]k<z@x}*5Qz@K}?uH+UX^Y_H3Q<Q7!5Y|J}7R7ZRajU_>FCD
    +>XU,ln---~5QsF$Y5r$l3,@xo!='To!'{u;n=vHo$x,V+1^~+l^*ZO.]RxG%p7EmI?l+\)KnYV3
    D@^!5s2='HkaOBp,CXE2=Tps?!3r{@ZEJB>-R~\RliT'a\+[1[zVa<^e#1sM/On!11zjusrj?YXu
    OGx*}HQ#C2$BRGAQuQU{BBJ$kVE,pVu}^\1VrkQuG4vk@]?\iuM7BuRT7Kk_]$D+EsT07awD'^'$
    3a5247\u~%liA@p-V]_O$-]EWZVYYB5@;TpKp$lA55~<<-Ibs3$uwBm+j[
`endprotected
endmodule // module vusb_hs_pe_datapath

