/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_tx_buf.vhdl
-- Date Created: Thu Dec 21 22:42:46 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_tx_buf.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Vusb_Hs TX Buffer controller
//     
//  Limitations: (PE interface)
// 
//    * Reads must occur no sooner than one cycle after switching the channel number.
// 
//    * PE TX Idle should be deasserted at least 2 cycles before starting a transfer and
//    
//       --> PE TX Idle is only used when outputs are registered.  The controller
//           takes advantage of the dead time to pop first works into the
//           output registers and set the flags.
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
//  $Date: 2006-06-23 09:54:50 +0100 (Fri, 23 Jun 2006) $                                                                       
//  $Revision: 87 $                                                                   
module vusb_hs_tx_buf (clk,
   rst_s,
   rst_a,
   rst_local,
   rst_local_a,
   dma_host_mode,
   dma_tx_tag_wr,
   dma_tx_data_wr,
   dma_tx_full,
   dma_tx_mark_down1,
   dma_tx_mark_down2,
   dma_tx_wr,
   dma_tx_ep,
   up_tx_burst,
   up_txfifo_addr,
   up_txfifo_datard,
   up_txfifo_datawr,
   up_txfifo_wr_tog_en,
   up_txfifo_wr_be,
   pe_clk,
   pe_rst,
   pe_rst_a,
   pe_porst,
   pe_porst_a,
   pe_host_mode,
   pe_tx_idle,
   pe_tx_tag,
   pe_tx_data,
   pe_tx_empty,
   pe_tx_rd,
   pe_tx_ep,
   pe_tx_ep_early,
   pe_tx_early_val,
   pe_tx_flush,
   txfifo_up_addr,
   txfifo_up_datawr,
   txfifo_up_wr_tog_en,
   txfifo_up_wr_be,
   txfifo_up_wr_handshake,
   tx_buf_addr_a,
   tx_buf_data_wr_a,
   tx_buf_wr_en_a,
   tx_buf_addr_b,
   tx_buf_rd_en_b,
   tx_buf_data_rd_b);
parameter usage = 1'b 0;
parameter eptx = 2'b 10;
parameter eptxa = 1'b 1;

`include "vusb_hs_greycode.v" 		// file containing translation of VHDL package 'vusb_hs_greycode' 


`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   clk; //  system clock
input   rst_s; //  asynchronous reset (power-on reset)
input   rst_a; //  synchronous reset (power-on reset)
input   rst_local; //  synchronous reset
input   rst_local_a; //  asynchronous reset
input   dma_host_mode; //  host/device mode
input   [3:0] dma_tx_tag_wr; 
input   [31:0] dma_tx_data_wr; 
output   [15:0] dma_tx_full; 
output   [15:0] dma_tx_mark_down1; 
output   [15:0] dma_tx_mark_down2; 
input   dma_tx_wr; 
input   [3:0] dma_tx_ep; 
input   [MEM_BURST_LEN_CNT_WIDTH_WORD - 1:0] up_tx_burst; 
input   [8:2] up_txfifo_addr; 
output   [31:0] up_txfifo_datard; 
input   [31:0] up_txfifo_datawr; 
input   up_txfifo_wr_tog_en; 
input   [3:0] up_txfifo_wr_be; 
input   pe_clk; //  pe clock
input   pe_rst; //  pe synchronous reset
input   pe_rst_a; //  pe asynchronous reset
input   pe_porst; //  pe asynchronous reset (power-on)
input   pe_porst_a; //  pe asynchronous reset (power-on)
input   pe_host_mode; //  host/device mode
input   pe_tx_idle; //  pe is not near starting a packet
output   [3:0] pe_tx_tag; 
output   [15:0] pe_tx_data; 
output   [15:0] pe_tx_empty; 
input   pe_tx_rd; 
input   [3:0] pe_tx_ep; 
input   [3:0] pe_tx_ep_early; 
input   pe_tx_early_val; 
input   [15:0] pe_tx_flush; 
input   [8:2] txfifo_up_addr; 
input   [31:0] txfifo_up_datawr; 
input   txfifo_up_wr_tog_en; 
input   [3:0] txfifo_up_wr_be; 
output   txfifo_up_wr_handshake; 
output   [VUSB_HS_TX_ADD - 1:0] tx_buf_addr_a; 
output   [35:0] tx_buf_data_wr_a; 
output   tx_buf_wr_en_a; 
output   [VUSB_HS_TX_ADD - 1:0] tx_buf_addr_b; 
output   tx_buf_rd_en_b; 
input   [35:0] tx_buf_data_rd_b; 
`protected

    MTI!#J{sxRxY*GQRQO#{,7Jesx]wWO3ATDr_C7ZYO,1?nW]k=2}li}C+wCjmr\5lTkE-BBZ<\e]l
    kvs>l2<}p/e53I2,oUFYn7r*@3u?1i<nrDGRA}]w{Dk=!{]@Hu@1z;57_Y],GnJ,jVx6o**#kx1n
    jirrVuQ!,x}1=O]*=~@Rr<GA#w;Vli*xBl~YZ}k{=nroY\7#i*'7<X!!nA&UUAx[?wpl]<@0&TsI
    7IjJ~Taw7+TaEC2uWQT{lnpA{KVRGG,5r,u;Qd\=v2uzXu/?Gl=}*IKygT\>_5W35L|1xr#^QQOj
    Kj*1IW1[#3[;zKBR!s,X1<$eI7ilO$*LeZ_V~p5[MLg+*e#p@T5Kn};U$+E>1_#upu2s^#Hv$#U=
    wG$:2l*2x@]BE+ra,}C1=!{3Mij\\1WOXOp]r\1Tnie}icxir;mD+^a[8'a,Rm_iZCYIHB#{;es<
    OH$$C3>=]=tSfQ+uoi1k<I7X#Zj,1,'?oZSn<jv}k>;OBD]J+$leiQAq].x^WrVjBoHUox^eA{'Y
    R>K<rG7z@>tz+EpDY<7"wj\JwQJxG3z[z7<J7w7XRwDnTp[?F.oR]Cl3]Z2r7'VI~e]-;=m}w]Vw
    @jpKmDRv;w{DejDi=1@GTG$XZ>)wU}XZO3}ro7WziDn}~+uv~pV2r]m#5\j]oa@?j|=\$W<s<BY}
    AxI-G^1L5^;n2D*#Gv2^7ueJAwRoU'$#\k3Q|{7o>ao-On{ZC?xOi>+ZT5gR\^2hIjY^$3QVY!2U
    (<>Tn>Amum=HpxGioriDwokYY[A9'BK#a*<n-Y<HxeE^Z}D7Gk;G{1v[>n^@BTKX+D$5<RZOtEE3
    Z1Y\THR3,)S7_2>Q#-^jYrVrW<-xW@1[2-w,~ZI_U3=;a*~iDCmAo!\[}D>>CGn+=AnD!;\5(1\,
    ^wHxE#T[T]IG#wRB}kXZ_L7V}=PZa-?m7Z{F@Gl~CYTDVTAIGB2Js[aTQj-E1B2vOv>3!$_T-1-{
    Y{7Q7lH*wvjI3Bwo;AjrTpU#piTa}={@=n>f%Nxe*Ui[B$Q,{?VReZpipE5C3TK$z!6+Ov?ezZ@k
    ORzI>J5j,ZjHU\]i{lD8\n6k$_[+O^z5?U3aCm*njEE_-nCXDQu${ue4$#\YrB!oB,jIY{wK{UD>
    h=\[{Ae{X?^C{[jK]DaT<JHR2nxY*2LQ<vjUX1[IUVj?7ewpzyJv3{HHT[9*-n#Fm'1J!j^2aY<\
    OruQvj5~h-}exo]C{7[EG3=xo#EjkonuI+wBBH}7B/<+D$vTWI$Bv+Rs^~VuTw!CuE$Du{3Hjjx+
    7}5?;m5\mRUaaAX_so:QvurXvn{ji<asaK#m^QRs1zWAGH-WB>kZ*1^Y<KvIilK7>u]5'sYTs,vB
    sTAws_ez#;Al*Z1?[\vZpIaE!rOR\;J{o7lOIJQ,EXGGEpRDAJ2-V]IY2-vE=KRMIkoDp3!BueI$
    QwZKAA+XSBHJu;'sVWU>+IslrO#o5CU$>}<s#p[u{l<[?hC<!VnO{[z+Gmk,ssCwUQl$r=,-^o{p
    k=pa2Q%q8NDu1iXp'mDAm;,vw+s#A2#lp]5K+E~C<]JUsH7ABKH}l'^QwOCjZZ8,O@]n7Ku9JB3r
    EVZ71X-e?<Be][w]psBOQC7I;zK^y_l\U=ZQ]@*?}X,$^]X}BZQmxj>IWYUw-~+Z*lEmTi*,TU^J
    GTv-w{$*z'-;UDG-A@UV;GV\R7,B1I*[=S@nu>iz{[e:3Qoe?em\:2_jzJU'x>I5]{evn!A1#EDp
    UO2C5i{_ju,$![Ww}.@O}xKv7j?je#?5}T6s\vZ-5{e/![R~sim~#U!Z*A$rOUQ@W[[C!]kj^$#@
    2[$5\}+~uUHz#}}D$VjJDs}r^+w^e~_-Yi<]G}1XQ'p}C;{e3>[2mOI~kws?!O3^Q\KpQ5Vl^wEo
    %-zD'>]Hwpx$~}7eTIRZ{{Oo1Ka;_ZeAC?Dxenz>YiV\e\2T$71QrW5ABoA@>]oH52B+![@oHT}m
    vF'e!CPRkp_k]lQ~sOH-on3*pKD}o-19n>\[p+[@Q5x#u*Qvq#DA<RUKAemJnR]-U4En}BKz{7So
    Wzz7I^C@7n*~XD*urA#G?wv\QTj<'{D]Iz3*{D3#\o~yx]!-G1A26U57Wz$Rmxm*i;>5z7]-u,Up
    $b2}vZfu1#[JV_x=>~JU'm+rnK{TQ@BVilxV\-~{xY@xHRso@vwpC3v5kmU[aej{jTr'a*v@o_$,
    {uJ$#pB>]HV!=\$ssDKrgZ{'=UUQI2^]l1RTIl7DOHvs@$\ZQAVm+[C2]!DGun]\pb[r'7\E3I'=
    '#@,K?e;OQEDXeCiWX)E=5W5>Jz#,B17d^=_#3skwp^A'V$EW\V?sb_sDCUI27QW]sYO@vGwHkZo
    Q[[*AnwBAjz=>DeI^zGE**^7;2GC^Z^u~mO+~]7}!5]OT~yS'GXz4z*5aYDTBIGrCQPVB<~E>\_5
    eK=l1^[1?7#B2lameaxOQW{Tv_CYmz@j=_Kn_D>zu@^7ks\p1#n<7*p\smR*m_>Y2BQB_!^>5>1V
    Cjo_}v;7R}{,>m+]ol;OZK,e\1G}Vzo94Ew$C:>>oDo<=5mjYCDaR}jQ12lW*#TE+w@aJ<k,pQF{
    AYY9.^{YIo!,@[3IxWTes^HUvlG5\',T2Ix'w#Q_vj7TZf$5BOHsemg])2Hup5s._sZaw>R[<RTr
    [l@1BAo=$EvivzK;lDQvEHpU{X'wvIwro]GC'}\C3]Q3aQI}<v^~sk7#U[GejOATT=^_i>ZA>IHE
    zkD]?YO\3V$u1pJ>/rAEBpjeTTe#Dn1O{fx5]a1C[eViO[Ya[mj:rBe2?'Vzoj?$vQ{+=>nRT,[I
    s1U_BZ{CizmAK'>~7;^rBm\@}I;mIY}oeim]7[OeY=CJz'$-Cuozv7,5x->7qKQixGZYm$?IAnD<
    ?Uza_#={IFrWa$9RDDDO-wwSOi2CLH>x[u<$e{l>#4-]*]z+}Vmrz\zxTVm}JR\Zpv,RGYBxTk=k
    DEQE@-GRR~*UXm1I-~@o]?a^r^T]$T__mDEBATekw,K<+ji[n[N'^Ul{oX~EK~vb=w=ZT,$!GYZk
    .\3{>.C[X],$kTU]@=:5$Kp'1#kvB<a_zEn5D>J7;BC^YGj0n[nlOk5^Czals\rzCoaj-{{2s+1E
    2o}l&XwrD^EA,\@IQ!7!7ZIu<,\QV4-p{aiI+QeU*IOUACQaGI*^WE9?Gw$UTCzAt)C]Gn\oAjYe
    pikBwE*E>Rvu.ir*k$$Yz<ow<+X=[~<[#\?nBU[B1>s3!J$<Ae>+[v$XEi5[uD?D=5AR's[5@_m,
    lk\'5AwrA*D?Z'+llZBl7a[2IGsJ2^$V_maGi\Jnz"3}#<7uU#1,KH=3YEO[_mJ{>+KBG<'w$Z$r
    RkRHnzQ@Jv+';K^ZWnhz;Drf^j'RZHCj?V=BsHA[rXK;%!r3R5v]_]ejBoGTvyDHQ2Ew;~ve'{BR
    JZnwK~Iz*iOZaY-lD*yaRz[4><2l$'xB{HUxvE+KKGZmV!xvxk^Kv!{X)'Tv@wT\GfiDD2s<m{$E
    QYGICl~D1#|D}!!a}@WGj@kD^{Jw$To7Cnja|YU~IqWse7-C$Epu^5uVs<#|yEJp_UEv{,KE5rY>
    $TaAzC3H#jOHs}O[VI2QD@$Y^;rpoe72anvIBKv1rv^-p]k^pi=]Hr*x$~*<v{}{Q}Rn!;nT^w'{
    C'A>Xvm5*{+7W:HDj3b.KIDOrZ}zpk>m@EDJ<]=Y9/[K^H1J}_w'}?<j$3iV$JGHaRe*1X]}]ahi
    7B'xD+rl!ZxQXQYZAG=w'[nQuu+v;To0!aBE]i\e\Q,!j2XvUYA1C,Xej\k@qEj7C=u5*I?<7GSo
    ;<_arir7,eUszzJle+RBZRl'H@Xy75=luOYuv!@uF*I{[I+$ikTap*n@73CepQ${IV#eu3$BiVuJ
    s^A*#)rfGI_H3AV@[6b*5BU+],}6vx7^{]?U7r+sVi,]N5$zru_x[=H551M>*r\rxxD2^x3_gVxY
    }#5Ba>lB$IXw@ATez}_VKESjeB!|7Z;-OY5\Zr_,KlCC/;]x,_=lnEWD2z#sEIu\]p\TJsEG!a[?
    @RC>\w7T?maBT*$7#mw\WrKpC*YQ<#D]iE#Z}{zT>$B{\-=-+57zjV<XPIGI@BJ2#(Qxj='jYPr'
    UvR;b^R]7E#c[w5>@R~T{1~xZ5<B+T+J>[Y+e[5uJHR}{-{BBlKA'Z'_T,s5mD_ms^Iv,5J'x_^#
    A*n=}sH1l]>WL;YJ1z\@,*v+$Ri@?0J{'?e<EYV!O_lrxI2Us,~LQm@$lI5$]+BlDa[J2o7\|n{[
    ~=msG.<rVO}XnkBUs{iD'=*GK-o}k'$$QW'~Znj,V@XeTG7karP,=<w*^3U-$zE~v,w[UR]edO@=
    <=2GR)[m<Y=2Zuu'Beg<1k[T5w}h[AziR;77W*@CL*K@axDlzcYs+W]=^_YB[5a5@1GT[[KR#+lo
    ]5V,^a7+GBR-G-]$7DBITrO[]soE}[0!\+Q-OepQ;>]B};-fQn7i,~=me[vJ'v=Xs6o[5ED;'u!,
    VpR?xw*Oj-1*mlo'E$ei8,zXBDsJ5\-2#DGYREBoIV[W3E;22>Ce<[KW,>71a2>j#s'r]5TxllD@
    GTe_!@sE=3oTwzU\aQI>!Y3X'a*'Y;aG^Wsji>oe'9A7l7<Dk^zU3'J{\J:[jrsgyV+G~fXwn5*~
    Y}d_Go@QY3Ofa<Vnr@{{l[kz]Cw2D5nIUD#Oi*2YYZv~!R?p".~r@;:oRQz!G!C=i_sRu2W][sav
    TuW^$[Z~aQ7?-uRfi-mQw>DHL!AlI1m}OJj#A^{o;Ta\UmpvI*u$l+<KCcQ-m$%T}X35>[#KGrr=
    z>nv,3[/>R![)ka*?mY,W[GKmD[Y}lzE!lnR?:q%[kTE~X>;Z7p}t[ir-2[J?BHDj;o5Esk-Q(K]
    ?YUUj?ERWm2s7!=2YEDx-}C<=WkAl<(6C,k;eksCGrmQTvD\Q~~7[j{s#C{GI?m2@_DQ$3\j%zjl
    V%0KU{H2{EX#$uEXlvnC2-kZTwV+DZUQ=IijUBvb>';k|X\p]_E=e#]CIp<H[ROiaXvI3XY5r$?3
    jpH;u_8@]<~v^nW1kBoES_+QmT_Xp]T;+31DlX+5Ys'wljz5C]!\iilaAv^CwIxVO5jmJ{QHxvTr
    m)j=r^pa{GO,,wj2^oQv$[WGOOA>pW^K2wC>Hs;r$s=!$-.m<oY]=?EQAsndc%2Y;wR-p>pa~[m$
    Zsa'R;5t^x2nK<G'nRuTv*p;*^[e7J1RGB$j_@YG^_Z#u7ZkW7[rglU9='>_,5A>:_>voz'W@ev~
    '!pwGQ.kxT]'CJUzw'~H^TDhoHm$[$r3NOp]mT5?zy~Ap+vjOwr$IH}Jo$)c!*$U%_B]EL\uo+_V
    ksa[ZxCamA=2Wj5K{@'KYD<GDYa>77'HmrEs2;LusZ2XArOmYaX#zY3}5]_PWQ9GG->ir#'j~{5r
    sCC=CH*$>eX|U]GzEnAk;p#v,K-nTGnjW5$,Ox_o@n@}kO1ZO1^Xsu-j{^[\K_#o}in!P}uVX'Zu
    ]/w[C<Yl$@xHWKsQ[n1ABV7A!U1B>rV>KXzUOx|XUYTqGvr]F@lWv#pK$Qv=w>A}wdm$-Gu*V'k-
    mOV3,}7aG1!'$+mrdvX@TD-<'m]5VaU1+H\o;(,rXaOVp5$u{3tAVZ@E\u5rZwUIX+v,Iz!e-G1<
    CUBV-j5u*1,Lz?R]]K3VG\{$w[+5kVzU{z1#IK=$Lv!e@aEG>kC[;WRjGZ=[H<Gmu@aQ3=,~HU$^
    nB?ZGpk1$I\$k0s?3Eil3x'$i#IQ<1O-KaJ*psH1#Qek$v_e~<;Gi<K5GT>ws$;vZ,kI>wE4W1Q1
    AnGIY'+Bm=!5xB^i71j^<YA}w{Z+l^A5IKK?U}s-]X\22OiKWp$A_iYp=*BJjpi]~}IKrW\kmn_a
    9Ixl';Aa2nVzii\m]?,^,v^_#qgN7C,<o$v'MZ^<1Kw^3~A[~62e-{\\!{}MDBlxG\m+*iU\?5[\
    \CZp};T#DJ,}csC*2Y[TJ_3Esp>CABRaHwraJLyC:11#a'Be="+$TJDj5<~VppUlr*Rv@wlC--@Q
    nB-=[u-$W{t5Y,}hin2,#Os^?Dw=OX3p*\$,JXV=zsQ^QY?kC+I@TvO!E!aR!p?{}$YT#>_j{^A#
    4~sen2Ds<]r~Ba<2]>_^m\3uojX$!lJHw.X}<Wm>,^152kxQ"QQs{jzXU7=aY1uA-I?'#+Ecun3-
    z7*BzV@=4A+Oj$vwzonO3ws<kwE<]-+2]z+V+;,+GzV$T&?jQmji}Iq\T2,UYlB^weGDQ{Q];$iO
    }RJ*V_~N8sz?'Kl+I>^$5IR,nXe;[w]G@\'mnY>5p?wpkwo^D,c^5*<dGO7w?l-3[wTj,3HEIi7{
    wY'_]17{vEA$Iu*,6pjuI(i'T7G,5}TX}K|Z\!wzzRJ3VU7b\+vV_p?ptW_Hmmp*^*K1,e^IuzzB
    D'eW>t5,{TI_V,xD25K{2C='p3zl<C?U\CBC>^=X1aIkT~-RA^e2@VoB5>,iuOWv_TDQu#b5-]oE
    ouoJlKpA-xVrd/|<>CD#I1@Vjz?o/NzH+1}'o]l2x@^OC@Vw{-vsTI~l}#_]_-Gp+JWv;e@l[~?}
    ,OdO_$wlD55"BrQ+4j,H5zxE'=s@r{C~=_E_ePOH!#]xDEx[OV7T@Ox<{~Y?}Jpran+}uz@Yi@l,
    ;UQ>J1E@3[<$u7aa_iE?BU|?6=Oa-p?C{5Y#[kX>XQ@eEATV@P?x7x!znu{7~Iw*'Rz3!xOl*l:<
    ^C>poR\jsn+sWBw4-[Y2==Dv3e#=D4i,Gpp_^>N:E;CI**e2>1QeqG\ro{pn5!=YjZ$3H[*zKYal
    rZjA'VK;TaaO_G1r3asJUBOUmA1CAQ\EaQ'=1QsR}TA,+7,wTUUJ7lDijDW27fAn;W.HxTujAYiy
    17ozx.5IDin<HY}'m,BP+Um}xOWjk'+ma>w>KT7CnEBAG*#EuUp_HQ>jk1$CWD1Y2{7RnYHO1=7=
    X^?n{XRur\vo(~15XCpjK7we>IZG}b'aVr=Gea;E,1YW{>,GBJ_Kp=_CvVv2rxNXReO$eJjB-IvB
    wJG^}BW$-^x'r'reR+Z};}E<oe5#OAW,iB13]Wr1sB$/GVlxmjx@_ZARFWB^m\u{>1*InV{!jLRG
    i53p!w?>@a*_+rZl[<xAOGQ}x-@Gjn$ll_zZGnmnTE=}zp]<,'x,I2vGraOr>?@sAOvGu~l5'}$<
    {-u\I~_$<ueKE+ov{m~^+r*IrzGX>#)UAXX)enj^qw_Z}O!7Eij2u\#u>UwT}i,vz$R}@^B}]vQ+
    Y}_l!:{H3+Cl?-oseXQ@V~ko!}=XXB=6CgwD!HFE?pVi,EYTw;sZ}~=5iTJ=3Y<Uz!>qTDkoYDZ~
    oQ~'}QzHcDTVu^^-Hrv}vz'DHoAH{fVY+u1HnV=aIH_[uA;C2<+z2V5DKV$mDkfH|McO{Ral^C<'
    pWD1Y=Z1w2O%W^Ioyd,M<'A1Rws$9XD+CQeH<l>{TC'OKV=+j,XRj~=*weD}*,op$r?CukDo<5]J
    eZTw;R-BYT,>T}*3#gHpKev&l3QiIW}m#O!KO57z*[ZeTDrnvk^WQQ!Jj$}{XQXWoGoGQQ7WGGsH
    o!~x'o-nWDnn've^=sGogYvp~2'Cj,?$e@$<E\r,r]TDl7@nw7Z\CCDkECGA{^$^C[lCW<YUDKoA
    O'e5T>L$E*A,=[Z^[*\QVJW\*$X3p*k<CRE/]k5>,Zv>UGHzCo#\AYiZe2'1'jHD1K},_9^JE=-G
    !VueIaQ@$;v[jAlUxEO>*GUO]lt2w*u,r}w]'muHzj?WIBsc>'[5sDHz*az{{B[;-t^;ml&![Aub
    lTIncQnrRl<*[eiWx+Up-l2uO5J'Rr\Ex[<@z-H!3[+Jx(6$O^*~n\K.oDY5B_3])BjVv~DR~^l@
    U]apmnU[pDWeoa,L'*#VZHV>[Q{pr{u*n<nn8~^T5w]X~=TXY+$1l;5,<G-V>Ts\'EJaxvw+UC5z
    7XBC3zXvU_Y=@xiYX^;E~~ol@^;O3xDz]$Q>1?jK~xYp7Qmj5}#E]z]T\_e~1w\>T5XO\+Ijx-$x
    W3TCpYi\,"7VU$,I1Tjunz1KDDTa1JA}wGKCI$IJv_(kQ{'QwOz2Ie>@UWoGX@,%,^!@ZnXk]43{
    @pHN/,,,=u<5Jbyzj2]$1=uk'5#OI~HiVmv$2~OuHU~VCBU2OY+h{U]as7x~sDm\kR\kY*R'xSx4
    SNCRT]DoYB5=hlsO[v8MpBTu11X~}$u;Xw]J3Dv7{B'+3C+Q>zn!ewpi~p,2r^#~rozK5_{^IEOw
    X]QZrkxBlT;?HV{<>(5G^BN#VXIi{7a~GoBZ5*Bl_*H}2=jH7,+oTruzJ@GQY?D}sWA=wDY3=Qi$
    UXCEmA}*!,wDrmlGRpoIv5*B$*O>];2[KXB&CkH!#AGs-HG'*Ds5GIwV.B=5j!jj3A[Q$?{]CfVM
    CK<}jx{;(5mxH>\a3E\-uzYO[IxelieH*xIw[x~JkP}$}XZ$mu[m7;D_AR|Sv2O;{-X=uO'zl^Z<
    7lB~%kn'HRAVJJCeIV-Yvr5D{XewGx!7!B3Qay?';2,-2$]E^!er1A{{VkEoGO~xrTp<z+,}A,^=
    ;{a*ou2'v'rWAQ*1EI{>r@W7+VK\j1-_wH@[W}=ov^iva>n]VmlEI{_k+?=]VK#r^{Bu[T*K_ur#
    wAk=vZ[U{~TO+2GHR'DXX=DWu$-EDwj,Wx^'mTDCETA{n@{_=!m{OCk^KUM@+s[*2Y??nll-UH]V
    *}o<DjApo=BBwUZ]EY3T<B2aav_[#z'RU}A3Y}TAIvCWVHozsuo+$j'J>2_w\!Es-p#OZW[euWDH
    v+G@UT1Y5[KB2B]X*j]6Y=GQR+v^#1Hx,Dp{C7_}scp:n+zI4@vT^#UQ^^\\O1{A2BRpU2vvi*kw
    kO*QlC_+{Omr~sc&ZxUp'DT@AD$AK7>1+QW}QKx^HB_jz3jpP%qT{7=8xp;l6OTGoA<n,ewAZ?}>
    m->,5o5?jEG*^nza~!e,3K'rB%4m\vJ7C1nB2Oz{}2!'z1EURG;^AjlA^=j4l\'3&P$xQDe*2'}[
    C5L7wDs$p$VQk,GB+Bj.~G?5m_3^I;;vJ+EIZCXjUnwRiQD}Vj3ez]^AV5RR,U$ool[l77BpT]3H
    -oKm{x3=r3Z@[UO7YBewT8pv=O5JHI?sn;H>OOFmGE{M_<C#('m\-wO'Y,O*\ZeXQ1[;BAOi=r?a
    VlWOH'H1e*?snB<@~^a$U3E-p$A-I]nVXCv+Q_RTrwv~3}=]]pm~Clm5Vl2G=l^U__>7+oNUp>uA
    xK72+ARG]$p]1_k#HK]b_zwT|+5m#P.[~7u$JxoG@*w}+JC(_!oOm}YsuanlLU+2Z<_Vu-5EI>oJ
    uX\vvB\we3G^W${,KUeU-^opT[C+Vc[I_JX]CQ'~1IHopi}5mkFy)zXvkl2!'NTG2n_@Jr[vB+3A
    3]*]Bp'$WaS[WGCv?Co,D+Qo-ujB,Gu=r\$XlCDKIepUl>-)UX$;p'I5'p*BF^=in=>V$R~rW[i7
    3$R-^@X$i[aZ\G+-?ACa-es@<)h~}1En_K^v5^Z7C1V^>we'x,>uzu3NTjJ1rG^K\o*@llm32XU+
    A7{lQe2<:X$?#pXG57-2;}iH=#TxQo?nOBsri^zeT>T{HU^]WC4j={\o7aEQTB<Q*n}<+j@Gvss\
    <u-]\x2o}2{IEzz+\BZCK,nR>$$\t=*@Y,@p$5$CvXpBA{BTTG#=jlK=_w{]\lL:YvrwVs_K_\AV
    TB7A?'+I[JG#j[r#UU\OAD]Z$VIirzlIHEnR<su#+>OZvaH![7H_zv3Z,<\G_Y$p''^O_3v7Uaou
    ;jYjB']*sX7Oq[os[{jnw<s7=-lwkv,C-@vZOke$zI?$wx3Iip0)kDlY[1>3E\nU-*#s}El\^#5H
    UHQrb*TB#*[-n_p\_'5<T*7>}^XK>I1n3m5+$Q@-1vl)'5!H+]JKOWmpBzDrQ;pQ5-$K2>!$zsnH
    pyOYTuVU]UNgz>7~H*CIVjCHTRKsmV$r1Tn1osQzppz;;_[7_;}{Twpie\zo9HOmkI2AwC2l{eKs
    Rg2O\O#wX_*pYZ_uX^B'kW5_K}W>uvOm$\pi~>vR!K;8L_Z1G\u*Hj2@lIO-eozOxl}\YAAE=,>@
    G~Yk12EiC2D>KWpv+zi+]D^}!.G!>!eOvEZR\'JR,E$rxweAz\_e#\7w,$J*5KsH*$i7-H${\+O5
    =K'eKKAz}V[lwEl}C?=Yw''}H2]ZQY{A*,Uv]K,1WU=7TvGs[+.SlKTO;+e<&B_Djj>7-~*\VkeV
    5;1w5szVew]sHZajiiH2CaY<pYxr>?Ap'B!pZY=v[8CxEz}z!Dv;uHJRVRv5!<Y3uw]-KrxQR+4L
    'pJ!asu1\^BI*k+*@a<UvG@_Zs1#iHI_CETWk1=a\@Ga31a~77Tu}XJABJUpDTr3vO3+$R[DIK7i
    ^^QnGpp3j>=<+\UQwXl{/7R!=lHY~|B|eLsiO$Wr@^#ET_YJn<:TalCgn[;C[s2pv<e[i\[V?QKH
    !<Q@En>xnOHz![s-\ZQ7{6@^A'5mn_jC_?m-RDq%ROAspBoK<Xlp6"IKJxC5vp^*Cu+lW~vajThl
    7kTaHEGOB*n#E^Be;-3ljn<YIBez45HwTj1-\ZO[3{,3UmCjA9{e?k^H]2j#X~e?3k>^uGJOnxOY
    3rr=u\)XTsnmU$i5$B_k=arAIGOmp-a[hXz5G\m3I$Q;1rBxR5ZXI''x?QxDO(axRup>J3JxZKOE
    EnVZ'XdR}<@T]vK_TEX7#Vnds@{=n<\iD{,';-Hkvi,,Y>I',EmX1d'aW#s,wHxjOKEovUl*-\,i
    _\A+T7]v-e=_R3[u*@U*pJGwX$BE#v=piGHxTX3pj[\@aKB}3]QZo#+D^<]Nl{CChh$ix~vF3Ci$
    wD*<o}n<zvW_>[Z]DB3$U+pJQz=1V?TnR=}_A&4rH[A>es@]22jn5]}5!;Xxj3-_piRaDm_+O_k2
    >lx]Kp1=Am>'p3vmQ>@1lj7A]ADE;Eika\a>EnR"+Oz>=Q1~b'JHYGZ7H8jZG]+l+^]7Jsw+eY[Q
    [Hs5AmR'!nK_QjE<X@VYY~5noOG3B_iI;'ZaOoj]\{%\Tm[x\JA]UnXh~IlI'z!^y5Q!xQ',YliA
    oQj~p2ps+pp2upJo+wnUzRm-2g{n}W5I~7*?K*xun<W9j;[7*vm_]~;#.quAH}jAzZCE^TJYTK\a
    W^zCn~/:}szn!Am=+_~}({loC+r3elT{w^K-_onBeOpl7\?Cx%pKz=?5'p>Au'x&Z-U!2E_^r5A\
    ;'+#5^*O5Om3A->B@R#G)r*xX1ExlT,IR?,3zAQE5;wB>inpH+r+R+XpCp!QRmARIm+'GmwmXDsm
    2)u-}[{[vK>H1}OY$X^n*sIIm@jT_$>'{Q}I=7Ox@?$BneT};a{=}o31\a4;RWa12^aa{j[~sXv8
    ps<r5\eEVo'uEXXl{OxuEC<kK_O;37<w]l\ljA@'#B2?E[n~A*#x-j-mk7*>kD>pQTu]@_=HWT{x
    ~G,iGUn~v<W--UCU~,QB,p!TxHO7DeZjwrT$1GjXawBj=+IHO2DXKQxAd;nn2m+$*2}u{ZjHH[,W
    Ciz!Y/wz[nGGu<=TmYJ=Jn=>R#UIrxR]@D\Y=]1D7r%52!7Ng@1I;}TrK@+X5\@Do^oIp/Rvv#-Y
    @?'zT[U$Q7ColU4,CsGFa'>BD--3_'TZY!<o=Zx'E{^'~sZ\,K+^f-n{~m[G]HxWVB?-7vR3E{z\
    -J5uswUO#}ps>O6Wx{D[rZaQ@Cr\>;<wY{R~HzZJe*X_k}aws~<]D6zJG'2XEHwH2{'2^ly,KZGk
    <Cl\X+w];WTTD\vOU@,a5J,o\V~]Bj5C-XoOaD^'ARGB#2DaeE\1W3Xj21AmX-,S1U;e';TjW,Vw
    s-A<i*<E!}>,5XT}HUzC#\HT7aUvCnBA\2{5'wa!{\6a_nnknjmx#ae7YHjGk7VID~@DvsOVBX+Y
    Om*BvEa,AX<as#$Jo\InE~;/Oa\,WxiJp<A@'k@J+qvgknQ!IAC\jO{X,sji;V~-1J1zrJ,7jQi,
    XHK]RiRjGGRwAIG~Aoxpa+A[QK@BTXaU,W!7]#AoKXE[^bRV+$~}*{#=Jp#[Us,>;J1+erDx3[j1
    V2eb/>I[5wUu$>-2zRZT=}=2r%HAo1Gl4?r[p\s$~n=+@ia^[{<'>IGDwdY!$7e,k$71YxI_GwB{
    rT$[rGK]EAL5QoKKn,1d(FIBoTruQV-_n-+lK2VE;1}l!a8$2Xs0']_ip-GDX[,7PW\}Wtk7Kvv?
    \UbEa_X'?\@p=AlHCAX?lp-xWx!ze@x=B*#;VZW,unOlj$[$m;WJQD5#-}QzrZo!,_[1p^>mXZov
    jk,*n^Bp\Kr)G>1Yw$*XGz#K[*ijV]kV+'QK,Tw@uOUszX[k>O~oxXHe_Zp3^m$WX*npO={DsDZ!
    rk,1\51^{R;7XsTK_\TC<U+B#'A-zep,,CkCT7Gl2IpDUU=JJl[$;AJVt=Yam+n<Y|T1Q7w-Ip}?
    m3ZC,upk}vUAJjnlv?=GTG<rrVijwm*WVw,H_'zQXKv@55oDRn'o;B?wJ-j@,kxGJAYDEKQ1aAmI
    YY@px#{$wR@_'Xjj]Q<z@v+UAnD$OYe^+_Dm;Xawz=L;=J,ax3>'UA3'#aYivG\WeoQj-;''i-?u
    ,OW=UZChR*DWkjUsWjWz-nVA2\,HDo2{*;;^s.cj\2_R;@]=]I~]TZ2orU;n=vnRVXY+xZmQ12D.
    ,a-ZXjVRKIBW'IneWv*BDBAIpKww)5K!zK,+WV[xzAzmIuaT1+'[\${7sO2<p+^*nvr7'G#;\A+C
    sTBwp;RVz^!Jv"#DOx1{^O}<<$ji@vxpkD1}QeZhRa^]o#-r[s#3KnZTsE?1E]KK[5K{Q71\os,-
    Fe5*G6e2Tv-{$52_QK]KKmVC5;O[\QmjZ{[,1}?aeu*wR]QHm+ZI']U}pUDD'1TQOs_U1{-^$=cU
    e2$BIVJF#5*s63a$7ZoW{UB;E\>sZ1J<Z-I!r;jse,#l}v<.pK!p]KK^lvZXB]>18Gz7?KOE!P~<
    zQ7BOeH<5WC]_C,<RezOR7zYaXD,ZIAeu'JU@!GYn]*s\ZCZ{^zAHRG}+U/-D<']Xr+,E553v'~e
    2]{QkaE-B1QI{KoAClBLHR?GKEK3v=mK?=O?,{akpv<@KD[IzDXZj#]\DO']H1G@\i,pE!s1emzk
    !z}\@s$_D,na-siGY5nAE1;jZ*p_=U1OG_XJDCvu,pOk'lp2f;En-zE;jZje=,]U}=oTD;>mU\zD
    K2w717KT5+SRlDr-oTVX-15iYZ?0Q}>WEBoT.+1,_jXl!eGl[9l;@$\#zpj;;7vJ5_I5xu~p{*IW
    UOe,__2^u*eau5+,Zalxm+>e<v4kp1[@YHj>{V1e\[[D$Y5jYXYApIHnauT>H=>cOeJ!=23x'}]1
    $2^;Wl#I}37l[{YV,pK5{x1pnxAD{[3nJ',IujkB.uCOCDw3^,{s5axK[RIUnzr$>V?7QOO,i^i~
    OZVpRqV\lJ@+H5W[v5$BJn,E?pYm_*;*1YN%:v?51BvjxE~FH\zx1u-?qZ-j;]{YnjT[e[2'r8/3
    aUOK'l~:ZY-?BDAIv3]so7X@s7a+~RHa,>+Cp5XpvUp'aA<CR]_[g*]@sAoh$CQY?,1BY83AE\>a
    ;CzroJB7=>9C3Dp@11]wE1Ui7]a^mvB+-~+[ena\Zw?@\Ho#[mHtr~5xk{<>B+!xk\~RRxiO,iBJ
    LwH^xQAzDz@w@<RRCde{@^W*DH!lBuRsenYQ^p\'!;\ap!;E{e$oQ;V>aIlrWKCpEGz-JrT-l$G=
    =72'D;'e>!^<]nrC7^^#vx3O!$pJC]?7_>$A,C@RsxUC,HMR5#V@HR]7a\Kx[e\.juBj,$UuDT2'
    \EQ{,\2_lY[#,GmHmC;!o$w,Ym32;1;~/B@Hz<x[a7_^}[1w^qlUUAtFOG4='3D\2jGUT[E@=[H\
    ]Tw3r5'VG}2jD]@?+G@s}^a$$mw$VU\i'CPi';HQm$^<^Q?5zGx&nnwQt?+VWVH1!ECVYD,oi]ZY
    zXTG$Iprv{s{H{]${YGk=H\~Y?15;p<J*n|8IYXxv[kB81OI*u'RwWRu2_\B>hKa>,~OX^'Vxu[n
    OWB52Dy=$v#2+v>B]x5$AnRenW\[!r-{OJ'>Y273B\;8ej,+UGs_G_!@=u+moi[j2&5+wrZ>ooDW
    T'$@l[;n'QU6=p7jTR}D~HV#*xX7>7poD1*O5[Tj\[+z7ApVajaZpZEICA],,-W!Wwrw6axG+[!w
    J-zDv2<+D8$*DZBEU{[rj}nr,$>+X^\uU\|^lJTBn\n05Wz\7j'k;-Q+$Yx+VC?p~$nu&k7]Jo[Z
    ,c,{ZX0pvBk,+Q}IQa!@n^[aY$U,U_o+^z}C{ADC-3_2^YQ3\#l]@13~'Wu}w3I_![-^[,,$-*Yp
    ^-#3n<v,O;'RPshWQU\@v*_lk1-qCHu~r2X<yED<DCp[[,?uYDpp}u&uns*^^ZB/pUjBs{@>,J@#
    P=#ZoA<p+VD[s6sTR7;BCJ<$ZD^2^ic?A@uK*;E^E}]eEX}8pmC^a{2CVZU!$?J1$K_GDIjXo?*>
    vEpO.s7!OCQ+xal-Qw1B\WRmCnQ#xo=l$lr>'1?WO[#XG3Ae^*Uj;^WIsz'~Q@U\KE1\ozI<]GY@
    oDRE{E5OYk=_O#QpUaV=pjs-p_}kkjH1+p,z$6H*{GYx7!&lt%1nz#CkI^ur=R@zzW=isr_=rpou
    zs|K1Y?7=eZ,>Ws6V>CjS*$Ax!rQR*Y@GAA'\V@Q7]{+5UHsKO}Bn6~R-$mjj!TDxEfIR#$BC[K*
    Y^}EH~\>+G1x]e>8G@~uA}Y5Gz+YEuZ2~R~^iO#K6?._s{sT-2]XvET~jA=1=3+t_\5Js,W7EAI\
    UCAasI2j'_@'*9DemX*u*Oi[s\?QmWxAoa$jIlUAvr,W{Q_zAZ:*j-HHzwD8aTIR>O7#7l23<rOs
    J}+5[jC^?COZQ3sIeET7AwUOd,{zaZSlZ>zEo[Z$BY')CpZeiDr!1l~avC>TFOT=z2UG3MD'7?k,
    ?V!I}H1>BA$GVWi$h=UKpK'D?GsuGYV!oJ=a<bu1AmR?>1#'3*r_HR1w,WK<',Y5x;a<K{aRj?W_
    'nv3!C_>um9vpIuY]O5E1WeFNfO'ZXoG7vfoC3a7wamI@!{_DD3EXQDU=~K{}DwATx3<sHB[j^$e
    <\GvXlWKaAD,^e>1W<Zr?xo+pe\|@w~xAXxZ>U~xaR@p'C1\RT@_=R_o2HDI+[pCflp$^uI~rOxs
    vQPo>B?G!Q'[@*$5-H;Bpwp2s1V;BX5p#EiJpwQnOsJ[lT{toFEW<\o2axccJo}J,EBAozW+}E=[
    X,\!u$}_^\iRTs]\X_?Ce2UT[55\\+I}4=pCVI~w5V[_QloHsH\GwHTDxrYJKeWJr\iUxGsOW+o'
    }mG>[D2[V>-Vm<=5I*X;v1OvxoWCUaa<EyLO!^~jV*Eys*qJ*lB;X}UKpnk[^r<ER#r*R2[}OVan
    lDOHru@[1WVI;R*lYskYk!ZOZ2[M1[5@-j}Re+WC&w1j>j''KkpnH)5]G>xE;OE-XT:;+ji,uzzE
    _'=/JsQH^V='aVYI$^mDVwpJSyp>WjA1>B_$>l1$$YY!Tu^;T$W,VI_Q~#E}m[#*'JzXY$?'e{^k
    ^}CCO'7iVE=^klOVCwZ>o=Em-Wo<w>4OKQY2U3uG'}O|iT,lDs[<Gs*ve_CGn-j*B>WIn,l;'_2Y
    ,CO-kXsDh;-D'EkxAk>l^n=$^M_2EYO*VIJUAAn^m7kE*xp;mEB2U}!s;kDpkOHO#!oAamDu>n'=
    l?jB!ueH\,pW}sJD'}~XrXX-]'~7_\qu=Hsg$,IZ+>ZEx2Hlg{+ZKR<>QReQACUJJBYOesw+vlpe
    \nA7j3H~j\~Xwza!BjGIma']K+YQZm\,5wO[OBs#<2AoH0A^,Y1eUlqjOEx:P{]U3zQzz'oe>D-Z
    rGaQj^E+GNEuU^@=G$>1+1=ROu%!QeW2I^{5Cjp:i5+15v}<BScxI-m=3!pz!<+vo]ee-2XiUTkn
    Y,wIBAYHH'5{wAZI'<B2YOAs&nn1!=jVYToWoKLY-{>bUITU1[DX!XH\G=>*\ZKEx-CT7nW^ZT^@
    DRwUQ\7;1'xwT{C,xo=w+HTe[[iB,<=s@{\+B$\XBiB,~rO,3V+wppa{VE~_-H,Y+1=?!,@vEaIH
    W}Y]iC*nSdQaT?v+Ixli;k5OX\oAr1DET3>Y1izZ@Bywouv[Zn7=rBi'<[Zi$A>VjTKxEAG7{'wX
    p$5[7nrm<z2D+HB4[IHYp_nGWDu2\H{Qp[2Oe$Kz>R%lJ]!1x!{a]]G'psR~z==GE1QE@7~}7DD+
    j>z$O<{H$'+TUQE!+u@=Z5^[HVB&#jA}3=DX<r{>5m}X1d7VA^9w}j[MZX}e2HJs%$[\Y1jpsR?7
    #B;+[UO#'*-$\<Ho3og\,$aY2{!1@$3[?WO=;@^XU<WC@X+^[-XTOHpA1CVJp~p+z-Z+QkQdwGC#
    o>nsC=(&=17@PO{D~REapus?]5r'}'nspO1IlI5>jp5>wMoDZA*kH_i9+EpJpiou}r~^@vepGkCJ
    [<+GjT3Ey\O$uv{\zsU\O[$7$O;$XKr1>^QY<'l!2pA5]{>JA1i1OIOU,<v3pzT,{J<JONICGTR'
    >U-7xu5>Hx>^R+Ue}*tB*IJG#7lfGH*XdZnOnB?^YoTo]s_Z*v?Cms}*mv]a3hCA[Em=+3I'kv%*
    U[!PdVoB$3YJns>}~HpeH^3AwY7-2x*Uoz+z2CwAU#UJ]-$GjV3e#B2[~i1;B<7p-a*E#mvW]<V^
    u8=i,7_EiA1{*Y]urT^1oI8HEC!}IY#z27wJ5oO$IO{YBnGrP$;ozGM+'XI>re*s~GrTH~eoaAHC
    CD\#w]QYo]zD7,Ik[YoKAsw]X-j\5<-pu$ZWHrCu{+TelQ#4EO^27vkvL-'oVk>OBI\J?EU>BOaZ
    ~z~n[Hs''u-oi52_+w<Re@Io1naAVrTOK&5sx+IrvVv[{#R$~mnTT3Gv=m?>m@a{@^RQwHOBoYel
    I#WYj>YG{{[+xJ1A>v;'{5r@-*U{Q'}7v1;7xlU+]~CxYoeK~+1_!G5Ulvk*~=BZRj_!ls55;[Ev
    kepxEHRueu~UR{*Z_oQ-EV4_Q[5#lQ*5n12yx7A<}+oGcv5G_XOEHiQ=o]JX}}}a5(HzYI}B]G'J
    uRUe+[B3z,K.s^IIxD[mk*Vpc,m*#7}?n-X\R27Q~nATBJVr7LO<o@Qo*pB,@Z+B>B{-@W+[W=Y@
    ERmG;uzwjATY5e42^-Y^i$Vg<UmU?v+T[@~3x]I-B=Q],}Oa)ERn<Q[w~7lrK,R1[R\Kx,inG\z[
    iEZ*Ax=>aelsB[E!R@z5['Yas[CxY&ZH@\ev2~Tj,<W[wO{TH$1oU3Dw{HpB73Qpi-\[CU4+_vJ2
    15VW7Ew;Erv_UlpD\Zac^13R@}iTg]~@TY@3xKO5vkQ+?Z^XD1r7UKR^^+O22|r35O#AHwc7IE#U
    B*^}3OO?C$G(+_;r8\?BYWHlvIXZ+I}l{,m7$DKT=#XD>kBrnB=.5}iee=XBW]_p'K~>Dxv2[k{o
    wO'-Iagl7_$KxnH!,VVnU3j*{ZpoA~?>j2D;vW~.A^,IGWanFUYiC&(j~~U0YW!o,E;Y5*mVIzHT
    =v>A^AKrR'~*tMVnp'V'Q7E];$tGs<\rED{r^u~1W*[ZAWGzAKBrBjznR'A}(v]\E+npOzsvUw.'
    TK[R,HDErZBF[Q,?l>s3$i>nu+Y<-+sO~C3v*'wC^@uG;5Xek{3l3wA=UvEkZl~ZEX;A?<HOCAaJ
    XGI;Om;K]WOizxK1@UR>[P2e\KH[D#MTI!#PlJx;<\+V^{auvBmlH'^km[Z#eK7vi_h[4pP0d@B7
    Vr/;5i-+=w'O}aQy{Cmnzz!sp$BIO$zkS[!R}[pAv.TpYG3+\es!mzopemRgp^OaY_=l(>]n?lKY
    GC)zA*1D4Yw75;=pV@RAHrxYK+}3I2_=,7,#W^jO?p!-7f?H*!C[#lOkez}mpi,=[=cACZjICJ>K
    AGEivmx>jE@B?;a7~+}BAm]Ch='+m#B>#s@B3^{BzW&H|59aq3_vB#*l~/gY+RpqH_<r^BJ;VvW7
    A=m~#xwxYC-{l^Qm;lQ}Z_Ie[H$@&I$jIG2Za',nXJ\NiIVG=p}<bgR_audR<-om<A[br.%}XO7j
    X5s(xD<\HYl^TzX]XRIUO@<WN,JX[48=C,oKSAUpn0z{Ymh5!K}=8v>]Q,s2,=@jET7?vsul,EB$
    Doa+A!Bs,FjZJRe?I<<ER>Kn=VAQY$@HJ<ZG<wl^QUtI=3@]>CW<w@_uT_R!EH>J]?D-XvOg%7Fm
    jB3[Z=JCz\R'-!}WsHz{A,^#XYGno\B?1Cjnv!Ji$>GO#.Gx}TO,*57_kBj=<%BYmAzAIz1m>nlN
    u7}j9xjrp*~*'GasZs%ee}zAEC~$>@TYAC;eBoIQ&'\k'Y*B>+e!12]lX:n[Os@H<a9r7l^*XsQE
    ^^C^\[I_*^K[e-J-]wD2}vCrTuZk<$$=ExjLO/}iUG'pTJK9b3o#B's]{!1CHx[I=f5Yi7z|UDXG
    GVa@Y:O5o{^Hn#D]R,,T}AUExpHv_k;_A>$C2U>'UR:lO2Hk'X?$Q>p>AnkQT-u/Bz'_bz5o;mo5
    U,u[#yG^k~3B{OK=^mB2I$U+V~OxETKzxi2n{[R0-C#T~=DEXO?mu*5V*BxI_}Z?H=eH7>;7'\#E
    iUzA+7+[z3=VR#1Xoh,W_Oou=ko'D[vBrr\vo5],7QAsB!&nR+$CUC~Y2^,5]*kiC~$?e#{@U[z!
    n!+xI_<_\3BQ;-e0E}e!}>vHS_YVm5<&J[lilk3<wGr]z'l?P1M2xUUO2$R~ls]t(|}euAH_vCR+
    zZd1[ZDkYru,kvjqE+3G'~*RZU[*jGK<YA{o^3+?9e_{ERs<lK'V,2EvA#E]Oi{oV]ZvO|N'O^~+
    *BmW97D\iEQ!Wk7jDQZsE\RO<CxKze;jskBsmo\?lWXZGuR2l6p@sYQ~Hwv[TwV7kJ}EOBonYZzk
    H75H'~}5rm}{vuC[}:*aKRC7X7M?[[[e,_;ATZ[tv$Z'v{wl7X~DqaX-1!rWlOvOeKEAK\?_+3_B
    ^K$->IUI,pp7YBH=?QG}Ki<a=\aeoNUVK{V><[I@VAxZW+{OG#skx1BUAoR1p}9z'X$xe'!c_\Q7
    [GZTBw'}opY<YvQYp-=Z]jGECJ3}HwNFc71?X3=ar!5Av=^O^T_vToQe[AH3ZE?[Y5T,ZO?Gsi[$
    Gje7Tvl{1_JlGeJZ?,2oC$~G5}}k3U*i@mOHAu5ws]-pZQ*,<OM^@*ss_$O?Tm>kI'aRv=OAwU]J
    1#-V'YHN]mTIIT_^QOI5IRiuOTjHY\}UV~o+D_?XEZ>$03sj=wpaxQ],+w<U\p^mkx;XDWY$1B3n
    -R>ea$Vr:2]p<^Gz]-Ejw_<z55p_37Q=5?I+eXQK?D<KA^Q;kIJ2*H+<w-O'*e!Y1JDoRiHR~VGl
    X*B*iIv[1]!71F-pv1]}iu,s3ZkwureHQZ?rr2?<^-eDUj5E}7rZUEQ1;OA1C_2npmD}<DIY]@p+
    E?OJVp!]R=E{5Q*rrnR@I]$TrvDa+m?]}G7R}xs+T@CRB^'jB}eE1Hz$*GmI\Dpezm.p3D,WXj^)
    lXr5=v7u@^a?=s--,rRHTAR'_L5*Al,Y1TV@IwTYevA>A!55+]eVuIvwpKb>HA@QKlJ>>}pD],*,
    !^l,<\HXCoey^KX@Wn~aUDJR\3RRr_!o$Xp;R*GA*oo{v^V==RXeCsu<.QrI<kp@3zG_$DJp@63(
    k5ekxk[kT$D*:C!p{CGv*HRauG],$jiY<^RKw~*;Exr5D.AV=K}BG*lkQu@\A=X++3Qk_<1_nz#{
    >W-sm[ri,C=3ZI]d2*O!TrU'oYpU[#z$BT7YCXuWmzHT1tpXQ*ro-et+r}'3{Q<9+,5oJCjkvTx<
    V!p1pQ^s\jxZ;j-lO_W=Djjm~Uvxknz@z{e5RB5YCGozIWTQE},eo?YeJnT]wHCuA+{DmQOlO{-[
    JwXGa5JAlHrO(s}\z~,e''Ek+1zGW$^#n+pkaB\eKED!xD#lQqzrpAznQ2fdls<zyDl$l,Js=Va3
    kDVwLA{AO?sviDx<_S8;U~3j\p^B}U[1lTX1CUWq3'KB?=<]en3;LX,Xle_^n,P^i,2];73=^~2=
    i$e<>]z,2{vDpx-yaRW}d<s$n'rC{e*ro'G3T*D{[pJm*2j2o(kr?$i]Yxk]B<iUYzFv4]U^J@j2
`endprotected
endmodule // module vusb_hs_tx_buf

