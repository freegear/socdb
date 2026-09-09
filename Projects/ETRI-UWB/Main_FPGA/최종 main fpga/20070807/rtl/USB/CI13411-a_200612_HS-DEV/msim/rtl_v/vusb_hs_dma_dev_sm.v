/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_dma_dev_sm.vhdl
-- Date Created: Thu Dec 21 22:43:15 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_dma_dev_sm.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Vusb_Hs Device Controller DMA.
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
//  $Date: 2006-03-15 14:25:45 +0000 (Wed, 15 Mar 2006) $                                                                       
//  $Revision: 42 $                                                                   
module vusb_hs_dma_dev_sm (clk,
   rst_local,
   rst_local_a,
   dma_up_host_mode,
   dma_up_stream_disable,
   ep_tx_prime,
   ep_tx_prime_clr,
   ep_tx_prime_break,
   ep_tx_prime_break_clr,
   ep_tx_prime_break_set,
   ep_tx_pprime_break,
   ep_tx_pprime_break_clr,
   ep_tx_pprime_break_set,
   ep_rx_prime,
   ep_rx_prime_clr,
   ep_tx_flush,
   ep_tx_flush_clr,
   ep_tx_flush_set,
   ep_rx_flush,
   ep_rx_flush_clr,
   ep_rx_flush_set,
   ep_tx_status,
   ep_rx_status,
   ep_tx_complete_set,
   ep_rx_complete_set,
   ep_setup_ack,
   ep_setup_set,
   ep_setup_clr,
   ep_complete_short,
   ep_complete_fail,
   ep_setup_tripwire_clr,
   ep_addtd_tripwire_clr,
   op_context_active,
   op_context_halted,
   op_context_buf_err,
   op_context_trans_err,
   op_context_next_tail,
   op_context_mult,
   op_context_mult_cnt,
   op_context_zlt,
   op_context_comp_bytes_mpl,
   op_context_comp_bytes_zero,
   op_context_comp_mpl_cnt,
   op_context_comp_zero_cnt,
   dma_rx_empty,
   dma_rx_tag,
   dma_rx_data,
   dma_ep_prime_num,
   dma_ep_prime_rx_tx,
   dma_ep_prime_cmd,
   dma_ep_prime_cmd_tog,
   dma_ep_prime_cmd_handshake_tog,
   dma_ep_prime_cmd_complete_tog,
   dma_ep_prime_cmd_fail_tog,
   dev_op_context_go,
   dev_op_context_go_type,
   dev_op_context_go_done,
   dev_op_context_go_burst,
   dev_op_context_go_offset,
   dev_op_context_subtract_arg_b_sel,
   dev_op_context_update,
   dev_op_context_update_ep,
   dev_op_context_update_rx_tx,
   dev_op_context_update_rx_overflow,
   dev_op_context_update_eop_status,
   dev_op_context_update_frame_num,
   dev_traf_req,
   dev_traf_req_ep,
   dev_traf_req_done,
   dev_traf_req_cur_done,
   dev_traf_req_rx_overflow,
   dev_traf_req_update_fut,
   dev_rx_req,
   dev_rx_rd,
   dev_rx_gnt);
parameter eptx = 2'b 10;
parameter eptxa = 1'b 1;
parameter eprx = 2'b 10;
parameter eprxa = 1'b 1;

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   clk; //  system clock
input   rst_local; //  synchronous reset input
input   rst_local_a; //  asynchronous reset input
input   dma_up_host_mode; 
input   dma_up_stream_disable; 
input   [eptx - 1:0] ep_tx_prime; 
output   [eptx - 1:0] ep_tx_prime_clr; 
input   [eptx - 1:0] ep_tx_prime_break; 
output   [eptx - 1:0] ep_tx_prime_break_clr; 
output   [eptx - 1:0] ep_tx_prime_break_set; 
input   [eptx - 1:0] ep_tx_pprime_break; 
output   [eptx - 1:0] ep_tx_pprime_break_clr; 
output   [eptx - 1:0] ep_tx_pprime_break_set; 
input   [eprx - 1:0] ep_rx_prime; 
output   [eprx - 1:0] ep_rx_prime_clr; 
input   [eptx - 1:0] ep_tx_flush; 
output   [eptx - 1:0] ep_tx_flush_clr; 
output   [eptx - 1:0] ep_tx_flush_set; 
input   [eprx - 1:0] ep_rx_flush; 
output   [eprx - 1:0] ep_rx_flush_clr; 
output   [eprx - 1:0] ep_rx_flush_set; 
output   [eptx - 1:0] ep_tx_status; 
output   [eprx - 1:0] ep_rx_status; 
output   [eptx - 1:0] ep_tx_complete_set; 
output   [eprx - 1:0] ep_rx_complete_set; 
input   [eprx - 1:0] ep_setup_ack; 
output   [eprx - 1:0] ep_setup_set; 
output   [eprx - 1:0] ep_setup_clr; 
output   ep_complete_short; 
output   ep_complete_fail; 
output   ep_setup_tripwire_clr; 
output   ep_addtd_tripwire_clr; 
input   op_context_active; 
input   op_context_halted; 
input   op_context_buf_err; 
input   op_context_trans_err; 
input   op_context_next_tail; 
input   [1:0] op_context_mult; 
input   [1:0] op_context_mult_cnt; 
input   op_context_zlt; 
input   op_context_comp_bytes_mpl; 
input   op_context_comp_bytes_zero; 
input   op_context_comp_mpl_cnt; 
input   op_context_comp_zero_cnt; 
input   dma_rx_empty; 
input   [3:0] dma_rx_tag; 
input   [31:0] dma_rx_data; 
output   [3:0] dma_ep_prime_num; 
output   dma_ep_prime_rx_tx; 
output   [2:0] dma_ep_prime_cmd; 
output   dma_ep_prime_cmd_tog; 
input   dma_ep_prime_cmd_handshake_tog; 
input   dma_ep_prime_cmd_complete_tog; 
input   dma_ep_prime_cmd_fail_tog; 
output   dev_op_context_go; //  start read/write operation
output   [2:0] dev_op_context_go_type; 
input   dev_op_context_go_done; //  context load/store complete
output   [6:2] dev_op_context_go_burst; 
output   [6:2] dev_op_context_go_offset; 
output   dev_op_context_subtract_arg_b_sel; 
output   [3:0] dev_op_context_update; 
output   [3:0] dev_op_context_update_ep; 
output   dev_op_context_update_rx_tx; 
output   dev_op_context_update_rx_overflow; 
output   dev_op_context_update_eop_status; 
output   [10:0] dev_op_context_update_frame_num; 
output   [3:0] dev_traf_req; 
output   [3:0] dev_traf_req_ep; 
input   dev_traf_req_done; 
input   dev_traf_req_cur_done; 
input   dev_traf_req_rx_overflow; 
output   dev_traf_req_update_fut; 
output   dev_rx_req; 
output   dev_rx_rd; 
input   dev_rx_gnt; 
`protected

    MTI!#GYXz+p$2\nHsm}GCIJ@;QB5AFnnTKe~$iNo@2[i|]?~OI,DQ2QX1?&[nJ\[VirEjr[oR,pi
    oOxToI]zjp{}_[i|,k>@Bu}z7?u?LrwEkkRixXzE[=K}pPDp{KBCorVwoKLKjUKYO~o~H7!{1Ja\
    h~j7$B>UV{'<ku{$3}''*2r7pwI~=uQBJYJD7/rXww[l>{rzA1+o>3EY,A*aep<YiZJDQT<_Tx\#
    a5-<E!'BCJmR15Aa<!<=+!U^v;M-pY^WowH/=a!H*C72!*na^hC]C*,UY>eKx$cC1D,$*U5KUA<7
    u2pmH\{V<>z?1e,rCJKoQ@@rO@7#XlK>Y#ECZ~O..^+!#aE>poKKwk5[Q;7n57x+*Gn;Cso7Z*5A
    [][E]^,]<7]K~le\;1]s3VUY{wn3nETI-1_{!6_++7Vj5Ysuo$5HKQYVTT35xTZTw}Qz'[BCEG'P
    \BwQ>L]K2U?o]'s9+jCO^vsvv*r_s;]!t}>Qv|1[ZnO>7+E5w1GU'oDQ<okR!G7*n'BnV$p<GOnx
    5]rIwV,1$J2X3wR+mCF7YkEH'uV_*I#xGC{\,^e=WQ}mB5m8},'A~a[Afp-1U#{xuQ{jHJoX!7]7
    r==wm5$_GvYJB("EUx*I<VZ@waVr]EI&}%.n'ZoCur*\f[-~GP_XSx1<[i^v-VD{;~zF?'=1jV>D
    2DD~z~X,\Q*zv@Y*#p3Q-+J2#O@@pm1>np,{_UT$X^m''suzI)YpUXVE7BrXu1'<ne'2=E7uB=}-
    zTwR1}[R7E&*eu,R$jsvN}ol_uUK;A>C@Q-BaVK;u0ok!BI^{BKw'+?}o$liQ[7sV??a7N}Cx{k1
    +j@lm[[>o@D+@{a]-5,V+W'J=5r@]w&}ZWXes7Olv5YuC-eJs1rjY\xQls[1FG*Rp;5r2o-+>=KB
    !EWwD~lx<jGmA\R*eB*A2,;lK,]vE]rB!uD?^$pjpe#Gw{*=JXq5Ja@U}UC3A$Ue}f3UB#cU_GOj
    l?e$ovB,5Kp[QxY~{[R~[-GG==YmCD_$}us\$JUL*1w=>GAVzIXj}v;z?[2u?&7VxAeF!G[TB!!Q
    g!=Bo1Z]2=O-!VDRWD}+IC2]oBE]A$1a!KnuEJ-Bv*-j-j1VsaR;po=kkJz1zXE=T.rAo=$H;sYT
    X'diQ7^rTUu,wj'f#oJBl?n5j~U'V~U=<{>?3,UC)CwA-5\zajs?3+ppR"ze~DYpqH-=G^;{+6W{
    5]*1mC_CBiKzX+BYZrxTYT1AQ\Cnjo^lowVE}AbeX^<93+O<n1Ga\A}'Uvwov7#kHevH1Ue,Kn}+
    OZvi'#j7N}{j1]s{~T]=]Y.Dx~O,Y*3ER]$uR?m}R*wDOepVvk*BJ2vO!pVo5{mI*Zoa{Jvk=TY]
    ~'CC3]Ho3Ro.lCEI3VwJeDo_,5+zpm3eFo?uBToxV3<+s_s}5qEUOXJsx]5'$z97Jn{GeD',7zUk
    <!Ce'r@5Q2_V~|["E>B_Di3r2zoxo\rAGIEZ:}[WT,Hjw65C,k|Y#[rYTzWP,QI?B{zm]Y<j$Wxk
    K_=TkD*rgZ7KuZBopv@wksUUmYu*<*$Y;/xv3kM\Az>-^3[+II[A'=$5^Ar3asWl8xCR3\a7$=tD
    ]K[uoJ]#O7Z5DGi={Xl=-Y5i5BvuwlaTB_$QIka}{j;,OWXjoDKCU@*?Qzx[*1i,3IT5#{{^ooDa
    }p#jnY$KB#VWTBDcr?{\~+z^hP?=+2~HH1?}?~vxmE9s*'K]ZW$W7?7}kVkCN\YV,k\D\J=37rvB
    *]=<?{-Rn''HAl2j,X+I~wxXxzAH[}oB5@T{\?n~e"x\xvGTUBa_]W/ElVki'i1vI7BY+[w/xG]o
    G{GKTDUeuE^{'5~DN?DA+i<xu\>mEZ\UnEx*7lmKrDR<Yj]EkX<G{|In-7\jBVYnvTHDXs2eZurr
    u_HxHezJDuc@QWup#Y1oEmO\ZsB5HD+Orj!|}lz\e!EoQJsZ)$Xn3w-H#$k7-K>@2*~e2{'Cu#p#
    1xwa$n5a^Bxa{C;OVKY,K$eKV_p>]93+TWBCE$5~*o!A{J3-<o3+ZnxkG5pTX;<^,xz5WjmeQ};<
    '}_{-5IB!?j*Jvp[WuV<UI}3Caka[WKj{$!=HK*s1Iy'!Qu2jnp7D{Q]Cn^IEg^ZX>DX[GbWEwlX
    rrE#{5kYwHY,]lIVJ>pZvWlpz+Cv-!^+&-$HnxoEso2xH;o1;ZjVZH=IV@X~@3+evl7_jDX2n=x7
    nIY<a!NE3x;}Z@\AAno!V<n$_a^Js]-1_Z\WU!w'^3@'x#Q]z]K>\RwI]aTx#=kV7>\;v<sAaWC-
    r?D:j,5V*Cp#p1T?+1*BGH}A=jo}*Q=Y=J\kjn$Y=>ZWa_<*~>T3V*!TqwnTUJB[w'VK~soO$]#X
    $5T]+VG>EOz*1v$'DkUA3YI\~i>D{H^*}_zzA}QXrSX1+D=}@*1#+^{B=jeO[1?IJs2OrC]2jWD7
    T{uBWZAv[BVG]3[=i+}Jeiv>*5PB$vn!r]?>U~$srA$_RK!H5,$Q_v2eBA{Fa'ou$@5A<\5YkDJ1
    $^G1j}{ak}^3=+2JE[K{qx$j'Bqo-worHnvx;TjlZIU1k\\OU2U}W2Yl3V!I!{+r]3R1D2}[*1RI
    Ei!;rTHW*$DT}!pCKu5;-oY<B,7U<vU\<_#xspp$=<VoeJ~Ur3@>za@*1E}<-+zT]X-RzzI\OiD]
    5\Bz-Z<,C~<>*O^N,mm~pRZQ-_^5s#w[2U=p4xIkwwzp_I>skRJ~;}2v[B<'iIK{X$?}@ee3^5DT
    p=<Z''u}$}CamY{J>B{<}rIAoqeJ!=V{~;6xoo}N*@Qn;v[AET9EQ5uGZ}sW[7TL=k[?[0JD-+IE
    ><+^iEH]*p{xa!{T5iliH<<r*G5,iTl{z''}C]+GOi0UY#JQWTpY3$A,sH2^*;=={^Q+<[iGrk@O
    0^E]m>E]uBu>@pQRJlv$;fEwaA}jkC$Wr{mC,>CTZ<C:Enw[t]G@nb^RI?s[W3~&xomupkn]2rz,
    sBH^S=eoX=3YA~YvuokXR7Z]@3Tpi>\i]Hnm{lU~3q|s<\^$;xY/;ljpes>&X,X[Ev^5l:o{Ceyk
    HT3a5lYOK][E}}k27=>YBk\j{>WE^H{zJn_[nB!QpxG\21TVw+w}:3T,vHp\]6lk[2U,3GLVwx[v
    KB-@o$J[Bpm}le\x2tG5Q}'HVR_D>sV}vl,lkJ$a\O$'u'jj@#E}Qu25ITO,_?Ja>$QxnjJIY3U\
    J+~LgH57uYAUDB_l$,U!YH1YR[r\'i5QWzAX#+$-KP\^uuH9rsQxG{VYrk3@1l\*Ev<u;>*D3XsG
    velk*x-m)r!Ei)5$XV#-_@qCz<IDes^W1vVZ$)fCY\3uCzDivZVBi@RE]#Rw<+H4HjjU}G'~k}lQ
    [<2X1DB^#+xB"1xajeoVz!.2n7@$jUWQexDS=B_^*x'IL][!zj<J\-SZzlQ7A>sjPzJssw$}{l2w
    aXszGE7}vBHb^j2~{r<rrmT!Dpl-xw\u4vHv$J[WsDwv^_!Wk3E\a-OT]el\m2wx1ATmOZjveOZD
    UxOk<pG5@?T]{0vC=;$2peO'{#ysal3GRZ5p@=YV=}@E<AsQ73-A+AZ\!]G|m_Y^uQ3;'7O[^2^k
    _5]IR2BoG=!R*pe3*Xu]eD5]Y_!#7]JBB7_vE=QB?lZv^u^kV]RJKOAxp^Am<>1e]*'Jlks[Oa7_
    ,Z~x+GV7[x1Y?[2CVG\ZxYGi|ABl{#^~rbm<Ak}}YiE1eo<YvE^HRoCJlrnwzI>GkY,-2VAqCU+e
    [Q>Hk-ue2s32n&yIZB-H7-~?.{[p@rjCmo5Di;Ero/ZUVBrWwnwaWW$~3Gps[WQli'Y[K*w=i{0N
    ~YC@p3s7Zp$#^22ReO'>||;=>Ol@AREE{!_?2zA7,r(P}['oBBjZ7sR,.L5RsH[;>}5w1jHnvu@5
    aKl9LY+A!C[QIdUw@r9FZaX+m[@$,ZTR|,e@HmlBjYX,\'CE$rX'{DjUx@'-E$IQ^ZDrmT7mQw=7
    5B<}[]O$-iAYxCUBnFnU@1l*<U^BYY|I2@$1-as-U,l$HWQEIeV]}+j8ojoC37i-]\-1,;Dmu,Q5
    |aXnrfo+e-p!Z<Ra!u*iZEIAVv5salO~;-S5{r}*OoA)O@\EB#Wsps2ZlUfE;A\'1oYC}1#>pnrT
    $##je,KaD~DaG1^Ue2#HIwCU1=,?1{n<jiBv*kUB+\kG<l^w>'\#w'@C3W};+K~FA{$u^\mB}IWp
    [zC{okH!*kvsooBVZew[WT!ZDsJ5$-^;a{=z11GHx#o~5=3lp<73?IGwEZU'lA@Oz7V^Y=eG@\jD
    uCj$Hom5_nC\e2^R$l'lp~KXVvn@D1>meY=e71okvU-Gc[BJW0[o=pBmBRp5B*iIwWQ72ou*]x!5
    ^n3B;>~aYorp@sACiZ~,B!*+o=!'#ab=BsVEBQsj{Z5D7ZTf[KX_E5?G|t+*1{i1_@3a>TY/Qs$K
    TG{pa-<K1i{lH*jl!{{CusI]@}!H8veluIDVxo#zXw}U5,$JXI},7UxO3#G-_?IG\+vrsnnr3-VW
    ^TV@uy"!pXx\X_+or~zx+UXx,;+ZGO^%sY<Wb5?_T#A+=2*AC$krk>on-*/r\275,=dPDA{G4o~=
    H,~{+f++R-iEGXonAkVUe$AzQakvnTGHE;<1-CeOjX>C$]}u^5qN-D[3nR+=oIoa2vVj\~a-\$Z*
    pzpT*IC$=\!{Q=lUg@\WjmQ~GYo_jFVs?j2s{veQkAaYEDQ3aGE?>@zI?jjB{3j+8YCiZpKXzKhE
    ZEuHaJj~=;2C$4pN,7p_{>pY$dzA1[<IuozpI?R=R-nCvT4]1+xB\EX_Wv@{^ECY}wJ^2I*$7^u#
    Aa~o[{+xIZD=w,]f2Q~?}5mz?D,uBXo7>VA5]pXWEu+z'JoK_Xl~1-}I+Iz5[{XZUGVrxDlRY<R7
    }+R#>Q![as{mI#Bn==[*\HARIm~EKXI-@<Z~?T]CB2wO!^@wU7#3@+<k:E?3\3=uXeuuBfX<Ds_?
    -1qTT5~!^]3o{nmXa'^l~aH^lu$Y3V@xpx,VQ>QBG<wjW7>=<2m|8B!BIwYs^rTWYmTvJW[RYmsn
    U=mBs.<$uH,#1x]@aY/'*K?QZ}pM,'x7$lr[t'vw,{'?n3Tv>V1uO)O}{Wta'OD$3u3Wa+~3_#2A
    QODOY{a7mz^BB,Xw^#WGQ\BI\WpJsip}$!Y~6a]n*Yw*s$iA'EeE?@s@<Wz]J].e;7'~aa@iB~m'
    UV,[i^GaQJI-sVi4w[O$rzIu]m$*=E[\7o3Y4"px#'|E-u3;7}lYA$~zC-o$gY>'Uj-ml):TX+*E
    :<]V{BOxzI];>eBA>8'D<*Pl{xXRXxa?+QvE;Q<U{{aMC5iE^EwAWpWYAVr~$,Av(WDwuyp@nk<$
    k;Z{@a7vp'bDe,Gvm++,K5W$<O+G2uHAQ#?[DDXmTKQy\[]H^;3\Dvl!ezEQXsxil#Ap>rDx_{$]
    PV@H,^TjmurQleNqYn$osG$RrJe;^RT~ZQ$XkpA2l2m$K]ir7}*?s*=Tc8Ap5#]i[;Q{j<#]n15l
    {Zt{I7,3XCREVwxGsUKGh++X3;sDC;,Jever'E<3KW{X,K=k2#\mVZ+oQN#=VE?=VI={Wv$nB2GQ
    i@BHrC>Ceuv;3]Tpaa1olzQo~G,!3<1A5aFWDzx?UV^3CI's\{3l<;Ae5}G'5p<eYA3CnYH<>pk3
    TjD\jjx^e+?^3$Z&~5{jr3poDuVxC}=,MuRR1C7Aj*+@\\GT'$*iKV+]Ezo7Z2]i\H5+T?xGID;u
    u^xW;@[*k1;}DR3v=QepeEl['A\^E#I5ClunT-+2s\\[Gv!I2+A;uV^<KE@;_RA1@r]'n=O;A[O5
    Jw-ZXXC#DlXantk*pJA1{GC<n@z7HW)zpIWJH'G*A>JvB?eer!{ajYXlKroC=U@ian~UD@5xC=p>
    q~<,{#{njH[?kz=n{kXZr'kD2&nDY^@aTuTV7!*2KQl]$^BWK~?Ys{,e,G\{Z?1WDRR!'{_>\Z;v
    ${*r^wFMHDT=Nv?JB}l[[3\'CurTJO3;vQ!!A*2JnzVx22r!]$XUGz<;lE~aJGeoReu*;OETw{>l
    }\UWw1RD!J}EIj>pQltK}oe,GZ!B<'\HUIn~\A1)B@AmxwAW5J,@U_<;{>[,~^vauX1m-Ys3BnXp
    o5CruoXnEERZxxuHzjC\7RXT7kHG{5'Jja-p2^H\R>;!59|+}iK'n!V[2R{-}HUr1J2-ez]<7'\p
    tPOHje11;>ToH>Tw*s[i~a*_rp"zQ$nC\n<q|DirxVOZ-zC3}^Xla*]#lwwvk.T73-e?C*G{$Ceu
    {UVv^@$o@<oO'jDHs\J<J1}Y'xuV2EmD?mEE!#i<*v]@}AXjGD1<+wx#GC,5XwNBCA1NB;@R@I=>
    %(Q3mw25*ZIp$E$QvExri-sJOCxjzzlZ>BZGGAvj;^)Q+UH-\{~j*3\s[x~nn{l,KIQz\*}r5H5[
    5^]T{!YCCw^ZEX\<z!_c#>EU{E3??NW{Xnv=1UV]}{m\HwC+[1e?z^$DHBzTV2JO~TOG<@j+_H1>
    >n[op1sVzr2vIV,$xv:lXws#1p@?5nHi+5;vV-]BuO$JonY?GzBv1lZvm-Gr~+pvpB+B@nnR+=OC
    UOX#evwBTK,o$\Xjj#5g3E2o>e_iB#5~RA+Dp1^p5;Rrkl!'Y2u>LKA$x7pn@p!ljUG5#D>w+[(O
    B[uoA+<,;X@R'}Y]*{G$[><?'mjC1'3pWEGjQi^Vpu=}*RDlJ,i-ol[+As5DXGnWjsD<X-Wv@WkI
    o}3xDJ{G$V1.MHU[EHX;VCnVK~nzZc,@~!2rK[8*RK*D<IIz#a]~r?VZY{+k}}i&02D{_<<7?vV1
    {z-@x'>jX=CK^7ZQrZ'\'7RVYe$;r'BPu}W>5}*i{Rrm\XOa3_o+x3a${jArCOw}!Vwjhuab2v#O
    8nG]X'V_uQmRJeT3[NS=@;_K_\k1?KB<x;[j\#o]~v[U'$xvnp<RoD$,*IH{HYvUN%sv}#$VX$c~
    BxnKn'2=e7J=RD*@wn,;Gu5UsWOeU;*kOw!jKQZ(E@<[hD2K;CZJ$,a!{z@~<>wTTe'1-#lCZ#e3
    j\\IviXV',E#!sU}jaAZ#MBzR3xa=mr^!~K^z\\TpKhjD<E7Rs!n1=E]Y'$1uwV>ars[iQv=jka3
    9~<1=o1a3Un@>1_aY{=B]ln~\N6xo7Uwl_!8E5Gspe-?UT!p2U<?oDAl@,$n_BYxk'Q=#*\U^ku=
    X{X!dn-,W(]3}>o[=lXBo,Ej\R)u[;Blu;nbx?-C-o,O?nKJWllQ'?+@JpO~'@zj8UnJJv5Y]u^H
    ldQu5H/\PGT*rDYi5S?_-xrajeWAVuG2Q~Oio!|{[]>za>#aBGvzi+x^Cv5mV5s*an$PxY+Kjk;z
    KnQYrm+E\w}E._R\^p}^_nwOzBTCE$?Kx,^s-O_^o><u#Fr=ea1~l'UXR=GT1@YGvW1mUxHEx<]u
    ez;Oj?zkn<EHW3]X@jo?z'3o;l{se=[I};7=V\#9Y#Y];=v2xC,rp*nGW7zo,E=Ix3Dx,z$nCJ[C
    n[Qi}*mCwIEoz\QiarR,n1#@xBsH_?W]D$,UJ1z$}@m]k+m!cA_a$plRr[=pTww=wR&Y$o[]8J]o
    r7pwD=im;XD,VGE2H}Ap!#+l-t=_={1keHu{@5I~<xWXmAzfa+_kEWn*vUKUaDE!An'+Gu_{{1]U
    1AAB5oe#aUxm+-ORwlD[DQZ?KG5Umwmr,I>u$xAE8Q+'rq,+oJ62[<pz@~s-OsBjV'CnB}m&xjp>
    P1i@ToJ!]<,O115?j/6=3R;}k!7J$2#XR#uoA_vJ_K@Oo1G?+U[\rK!OQYeN#U,vi\7r3EB_5e#D
    <wsICirK)'_a$QrTWB,z<Yo<m8+<B{V3AZp@lGy>Ar[FU$Bex9}<@sH9GEma-p,BR@BO]+!v>UYe
    [+JV,Gzue6u}As|ie@]:ee5oBk!v<jw5-zv\^nN'U!<Yz3;ssaEfC?A[nGx$O-\pu-B#-^A$Ko~B
    YQ?>geUBseQT]eojXk-@=A<XV6@]BO@E#pA=ia\],zBBJvKxsKjla@z5Dx7~*^vTa{#Vw\eH7oDX
    womO[\=VuoZBaTC@!2L!\Yi{OzO+xVr-+osD#{_A,AKY1U'0zC{w(W{K^ezOC+vjG$G>alKv$Bj^
    +E?H715Um~Ox3Yli^GR>?[xV^Zw55%V+BB{C2Jk\K>f>r^WmoE@>XQn~p-QiQallmA+n->XpTo<D
    _YUe{7*saQxwnll"-l[oC\Y7;<@u5GS_kIz2B#TB1k5;,GpIrjJAEmEy77mCRmxH)z,?7)IExI%+
    \2AhjO-Cpzsvvi!3IH2[v@\Ve,D]WT^$QEE*up!ossnD>BK!$XaJY]jllo~HrX_@Om]l&uz}IGZ<
    5R?1RG<\?\G*[AaBo]ZxzHjVp-B$RR>J5al!;VRE=;_?XR;,@m1uQv*A]7DX=='<3vGQvo\XE_ms
    JEi2$w\m~62l*n!BX>#H_Ue=Vp$ozo,^^vonU76@Upn$/~{'A,C[>)?<,zw7@5P$\Ywe_{-Ewm5{
    r1VBeE2RG#7V^i~O@Xx5Tn[['1[1=5uO7Y$m]-l[j@sV<5-7BrZrEDR\x+jAO~3K*G_Z>5-iq#e^
    GQKsYU}$?xH1aW_D'=p+@f^Ue,65QE_YCz'XECi'>jD]D-at2{>#nQ~+$IGpAv=CvWQAEt^33?l<
    JDMp{R3},Gl;7Q$Qn5CLB\r+^a@Gxla<mn}@o7_K7=I#pjAa*}Hw<Y[?m,##aEC,tzCszOn-WnaW
    JO*l~\n\}*u<;Ge2oY?O@wsj#Uz5H7<+sA+eGstQKen2^Opu'xw'=13w5EKzw2{1QGm=RmUuan*l
    G{H_rwkWn{GCmQE1,k>iTEae{TrZRV>)}u~Oj*su{Do1T7]W&+=!-NWY>u4Bj?YDs!C9\~}Ipt}@
    ~[x~u{osn~jDn[l5X<\CJ{r_I>DDe-/ow-2JxCY]}'=vKn['[>E=vWw|RaXOk>]JEO;xirx{L)W[
    ,wT{_T]1=>]~7?<$vuh+'\5Tn>>ao$J{<s5C[->O;VUJY<H\a~w{OlaV,nev7Y]o]~5u-!\n51@*
    B1Y7\Q{)A{ee^;+uKU,-D\U+oX'a~wu@n>GRCuVjH\7OvKn''e5w]5]*j?UX_@l=u,['4r?n;gp\
    jUp?l7em7Rw<nCvsUV^+1#$Y'?rDQnz,3amYs72w3$I{[Bl5?]%'D#HV9E~Jm:xz[7XUB{W\!mgX
    aK;j1?lQoV!RzI}[ime*$]~@^k-!H=ls{{R1oD58l$O[GDmX{5-!B#^U1on?apJHb~-l7$Yr;v'E
    2I>^-j2nv*zp!HY->'!IW3^uW_iCV],5^mA{W5=D-r#pBx{=^VZI}\eVZ>U-{5HH<OI}ZGAauw$=
    -ev5]9Da;n*$DI;+u@9CzKXW>~lI+C+M7e\+Y;j<!DVBP9YnOYQGuD\'VDET3OB}KB'*JI,OJHWT
    EE~*sGQ2V_EW1@]1+w!nlVR_#V#e1R]l;+-[p,QC-nhAOwwUOC>{XXx@Y;=CQlvZzRk];Zrk,@#E
    YjX$\I*]ZxD_EID5Q{?R2$@jpRa'^x,rR!C_3JoR,Ok\mE\|-}AAi{rExQI{l\mx1We-zye;G'X=
    6,T=x\}W=/$^oGXslC5vI5=Br#r-TkY@A~u\J'e<z#UQZD!Vxvpk,E\A'-s]J!l2;+rSkA$QvvZp
    O$#J2,*Tl*uuzsZJ?'O_}inmGR!k?s=k<E]KuI{EX$i<W*jGW]v,z5TsqM<VToViwHQE+RX1I_+_
    <R>^1w!vwsvd(hQ+Ae__JrmD[HBv}xuxX?;U\@^;]#~pHlp,{ZIAKO7;;wmE}*BQH3HnWa64qS?5
    kK=Wr5xv7$VIGBW>oU2^_~Z1aA}v~<RO,upDAo*TEj1vKGhomoEZBj*vm[=Re?*1$*33>O;(V{p!
    #HOseXspZ,$1BoJoO?[Ol;,zpm,v7l\DeX~nz3wAe$CH*]B2z^nmK+1iT'reC9?VXvnQ;!~UCv5X
    Xwir,v2DOY}nv+QOls]=lv.Vpw^YrZY]#waE*IOHGzp5A;oopi5g^'s7a+j~.!B?G7zG?o~Bs=m!
    a:1Zu[;_!uXDoaD<<j*JA{EHIZR2HZw{rnOJ=D7v}[QGBu*zvOe;135\+s2}n@{<*,i=1K2*pwZp
    3p3U<aD*#^Y,=_'Aar-EHQ5l;O|x-^j{ViHNuG>W'}R>,5xw.qC1>mj,HpE@p7ZXGOk{{n]Hzr+$
    uA?5$1r_oR7]pCGo[ij[k^:<nmxJ}nOpj@!<rG!\@B^8kv-s8Cu+A~vRp*'71-=O}U,B=YHCB|~D
    E=Tr3uT*w,IR<1E[7~[!xpz-sxs-$X3VGR^TVVsYAC!r[KrRTm,p5+^njk^V_noTGZZ7}6\#\BKj
    +YXTX,rB!s[&n<C!Bv^2+ql{s\sIE3o}R?-vVHs;Uz$wvT2+$G$vE@5p+'M?qo3+>svUZQ}*k3z#
    X$lsW\}uJpww7OskGU73$-\w}1zI~TIwp5jZo45{2C>DGsC~Bz3DeU_+37c(^_-I#Y#;vlC$uB2C
    Oz*55]ZKawT+j;mnoG7ORZO}$GTTmO2nCge1-Bur*7TjrQwRikL,xEoJC+]1~xp=jlA2YkoE]oC&
    e?^7\H,nrlQa4E@5JYm'7zZWeI^\ncapjY\}nExRYr@5k>'VOBlv*JOK}p-AXTC~a<z+2wyp]<Av
    7v\$lGu]e$Y.l&YvCw;<Ukofver~p*<-oxWeqWIXs]z<JI7}O1CQ}^Q,[cw{a,PVD_H2S[+Bup][
    U*pw@YJY=T{Qkn[<<KROCHpK74'nuVWA}zp#G~[nlIV?OOQC-5eO=IlVs,Dpr3X{B\=\5^KpEi]*
    m@}lz@H1'xVwanwRGxh-5I_o;AO$=Q{b]oiA5[[\]>W^T1sxE*@G=7}#>7wv3D{J'-a\17-B/6RK
    mvOKm7>vuu?-uG%}&=;-p**GzaIj=~]s!-}}3$@~G=zA,o}BEz__>_WR<1@\*sR_*=km,v,=_7;=
    +Uo1?Y_G;*#2r'GJwBxvjevE#r**A2=@HE3G<7-}![[*=5Q^r|Iia#[O>aiw+Wv;55l@[\$5vvJD
    DJf~7mH]A<1rWoIZYR5srA7DQmx7~-nD$?\'{^k?[pZ|s5kAwU[Dm=e+BH*'p!rC2XvC$a^ro{[?
    (3><\)BYG[!9@Dia5J+BCvwU$!E![@*}sVHB9~1*~B?[}VQ]T+$B@E5*5i'OKr#{]LOx?5VE[wuo
    7u$^DR]rk!^7;+\u^1WYO+*>-_',Qp(\TB*_x+#1B^$<<_\kLv>@1-<RB-1#$oYznD^Iv}CBHz^+
    Hn$B[BIX^7oHHoo;w8R+x<xIJGX]-exx@O'NWUYTlCkE\RDOrOu[=uw7tG:lOwZI~,G\+CA}Q2Ei
    o'iDa7u}E$r3=}uDYuAB<VJ{Ajpv3'e!a,eO5'KmH;[_l)l_}ip!Amr*'x8]2s1?QazR[No\iwY<
    BE<v,BRW-vv>$3JT\iQ2v'$eso.YCXp,#3@W>H=JCJ[F<I~oKIZW7-h&TR2}oF#GKZ=M3,s+iTX]
    <]TKENz*r}YwAW;$<!gs,<;Kl73lGEpMAHz_p2e]m1-<Bplermo;{DQ@TElBxa'B;sXG<BO['-3s
    -EiUW&O},TY?W{Vv$'pUQB7TC+>wDO2lK?A,oDsJsOsDw5|\}T!Rll,sCEw?D3!D*';<X-=]]=TG
    D*>nl>GQHB5{lEGuAG,{n]sHRu?iO{Zrz}$vi!Y^[EoJY'YAQ_K[3JB_=>GVl['+[aWQ!ojwz1l;
    I!7ReBQsl@!XElXOQZGSn5EX_R?>firmK[_JGrRYRa>-~Q~~#2r2$,r@rx]K?hZ\K^U>^{q@eQeC
    ^--TA>?wCn['x<nZHQwB>W=a^{G$JEo_vnB?<vZG<!mNRwr@}r@RB3O="'amX9mr{UD7G?cBj!2{
    l_'LIUj=DzK7DEEn~I2DR\,Z;<I5gH^lDrUY=_!p=@^_1j?[Y:,5<[}9flRTTQp]z=s\QAn*}4Av
    $e*=<\IGi+=pxUC|6rDH}~1w21_>UB?7RWr'^Uos2&k>;DZBK@.*W-kF7n3EjQoEvx[oDvr!J>vA
    Kr^!v;uTa,??v7kIQO=2J][u3sAZ7AX--oTBla3jfR+UIvAIoEZ!G,zZ~$UV@'m3{ZE@#y_u-@$w
    *1GE+Qx;j}6D!lriDKj?rQ,\r7rV;AWK*kZ7@~,BJ*IE~o5W<HHK>7zWRp[sv{>=xlxC];?[i2IU
    Vmsxp_OJ{\[}AlWG^<jmI5o+T}Z@e>#PEYrXuCmnV+u!/pZ<'l{2j]'Q3@-e_I#55BVG;v#oX]<]
    QPdr{T_u*GCo'iAX}7_vDIxo}Kw=OKRTOuO/N[-zTWY3Wz3$^i'oWA'sp''Olg~$RHE[Duyy#<>I
    yRG7<B*IBaB;pcR#;V8*[72~-OI^}r'>oRJI[uo=H<j-jRraVEExBs=eW'sa}'O>j*plZ2rI2Cvr
    lDKrEw+3<wA2\aRrovR'_{ICw}@WzV-3QZBr#<G{',ke=,$cc{THkj[QBJaom3z!lmwwEnaazsTj
    3<n~o9!pCkvj#-$zKTT=-J?7v?#_Av+s>O1UXoO[_A7lnDGO=?Dou<s+3ZzE2+#EIw>*T{r]-#TG
    VovC1QZ'?E~1p@2w*]ipA*MC=TZ#o1Q]$>e0Or=5;*}n0$R,+nr3Ky$TwmdDApK,,-Zs5j5s?jpF
    [KjWjVCGZ7=~}Z<#O=$7!T_G{^Zup>jO@ss$os[,=eD5a_IkCearee,TG!KuI2+lT-AUmHVOVAR]
    _eaBeA2G-e0]R-?C~IXmVwD{EIT-xvupm}jXz7u.UI+r^xOp_R]1]HCIKC+p+jjI5Y~OR?oeex[$
    u}z3!B\A?s]B]ioeB<amlv\=px's.mR^J-nYABC}GE<@#rjeevK}>Ex+}1<*>]-eD'1u@3e~np'?
    IH\^ACj7j{}R<:T{+WT=>rSVX2#3YU5!V\a3p,WCz73l5uQl{O5c=N=2OUcVDxDI5JI]xXO1m1G/
    5s+K^#$wQ[\-jn<KeAxZWOVR{[VEOK\EW}\}==1}oBJ@gI,vR*jYCJO@HoL,uRo3\r3[5GJ}=ZeM
    'G$B!{rm+eA2!Q?l'eYRD$p^[*3B+5mo!+,Y\'}O\]WT,IDC0Q5wDoR,;vzW1J13U_zoDOiQaBp<
    $ATY~pG1u3w-;f-G}@9KpsmYWGI5Qk{vFRAe\$;DBBdtmpZeR+H,?sBk^.l{@o5W,!bv?D#*R!Hq
    EE#GpezJK}=>C*o}qBGHodCzpQ*A-ssZEG^<r_p?p*G>-nWVZCDeUC<AVO*.z@\#![iAfv?*39t^
    m7#XDan'V*G~A>*Tls*RHamVDuxr=areUR^!T=Vur}l,>Ra$YuuxV~p$'}G:^3l]eHH,'!npe\2W
    ,=$J_+UxH=R~stA_AuT]em1m>3FVC_J3$CV>o;An52j1Q?nxnjT+O++^}zOp}eJzL}\CY'lZI_[R
    'X]w!VeJEUG}x,5X?C'<}DRG;x2x[;Y7^r7I_t;Yn;]UJ2A>jz#<GIQUGA]Y5VQVEkLI@uD'OC$K
    \\1Z'n2CZ{Xo@_^oJ7I&?C5!pCTB?T5>D?3n{znTq[CYHBQ?[cN~\*ZRs>p7[lKOko+=[Tv7Y?Ur
    Rp>2_DzTeG~R5pz?I;>J$o_D;1Q$t$;lKR?uKzQYzKrB??]mveWGj<H<+J,vD@vRx'5RxQIux~A,
    nlxK{1_=VOBD_ye_Q3pOe2X'wszDGn5{,Z-+*=K5vH\#Qk#j]e~5n~q=AYVt<XKu?rB~~z_5<C23
    {'Gr*#r+>s1~f\U{G<5a7HIwXu'n,PMa]<'*@*-XrS=nwQ5AYzk]Xjl<]j-o}~;7uUEx@*?BKku1
    v1l?RuH52'dpXIkg3]via'XYD>+C+DJEX<UU;D$ZzoT{eUGEp$QEj}n{|+sTT'w[@9'xECI=*Wzw
    CW@DEnK=G{AsaokArJen2ljp72Mu+_VO_r5m}\*T,+7PGe<w_essO-UlQWD_YKHmO{>lX{'m{EU{
    gJ\G;=3Y~#{O}uneBVvZo"js'2-'z]m+<OK{W_w5mo3[_<=K$#}xpvlWGQG1-G,oOim]a#w$jeg]
    r*RQYWxFL0xG,5wp?7iApumjjmhT+1irZm}|%e*Bol[B<_{rJAC[m+j]{j2<>[O=in^<?2tmY7_L
    <\1Yn,#R]>aO]@+3>+XmV;eWn*];_WIB/xE;;=iQ]CsAw@=}*7u5$a5YUGWmlC'v,2>>I|bO5s?H
    nKU~wzIT7=X1C[}pZWT,]xx_IQj8>nA=DvT}R-eDz]l?IKz~0KVp;O3K\W->_Es'})K-A7^zmXe*
    v-6I^y>}}X}1DKsE_!'2x{p13wiG[iVKej^++\u^'mma=z*]^>j^sGXX<*RV-EJ*AOn9LB5,i,2w
    D?VU>dV<zI+>1s\CEQPh}VvjyWDl?=z,ZSov!_Qo'Jv]nn\>$],oDs}5xzI7i_Y>@7>*YGuTu7pu
    1XEOJTx?vpp{n7]]>?j5vsZG7]C}J=B@<2MIRJURzCzZ7JwlR?#Bir#E3vpCIEZ~TG#D~HBl_Z5F
    XAo$@T[=Q+<w_2^K$mX;x_vJ,\QWdI~]@BIDze7G^5]uXw=KZe}T!kIH_(D\@u{+Z*-zo>?R0=)o
    [V@0Cnv[@l@nRenT9Op#2bw(@{QZ=;'~Xr]IWn;\ua<RdlY\ni7u+]K$kTsp\G>;'a[zOX-~C<B!
    JHxx}]t}hD]OIDeOzl,=+VlrjzBTYqHITk7^Z52$tKVG!>HvZOT@Zon5+GT=#V>x1RmXXIv]}KE{
    Q*_Tavn+~[2e-WV[j6Qoi>dxl@o3w}K]Ex3iGxXnn,z#+IuOu1X]u,,<$I725ma5Y--1H37HeXII
    1#D^aCBX]onB=A-3E}m>eEZ%Yv[~$vk<><Yl1QY'uX\-w[n~Vrol!j_!+v~WqQ$oWsGs}#DvD,r}
    uH^7mVTQ7Hq$1ku5J3?1$Cki=Epm$u$_UwWrYjQ4hZj,v*a]j_,QrGTInI$[5QxDpO~'pl#Qz4pe
    [U'ZHaBTCp*-$CKT@CU**u@o^EPGZ}i$np{p$p\R[~_y@w{vpi3!*DIZo^!WyD5<1jOoumC}{va{
    D,'O>e@m[:A5AlNQYn>*~P?z*$\w$n7_<-iQ!I+G{BWs'{RZrW3D[]']1CY\uAvlrC]o]!'D\_*#
    V{_iUe~UBAnB5e:o~<\5BnHWvJCE2u[]Y={_n\\}^GH-Hpmnz7H,aIVBX]Y^zUnOI+>AGRW4$s]x
    O#crDnnWQ;@Y21@>,I3z_$WYe@_>Lbuz$p*^HI5T\=7VX}W,s}?$sjx'GTA^>ZsUQK,+~!$_l_[l
    _!/!$<OC*s-25?=x0.D2lv2Tp^MTI!#zDU[r32*c@Dw_xQGH[j,;KzEZYa\l?B@[%}-1it-AEEvw
    +TD#EZp>GI1p}@lcjv?^yXY\VUx{vj*<3rB;a[#,wReQje>{#Vor@2${#Q;Z~G'#2o1u]kY[G)7+
    *luDVJA7az}v>!r-}[kVV~{Ru$_!pz'$~?E-7[nRAvxZ!B;UTBDp?5GKWp3UlieZ<e-^[KD2<W$$
    =pVrExN}JpkQr?QE*-}G\e;KR5llD-^,i!2v#*El!]T!Q=U{V@>'vji:Q=Ipc3xQ}Kh1J~7D{z(e
    2DnnTEnb@nAUrKv7}wx}}CIQBnB>rE7w7puwwQ?Bv?~RN(X\-ow8nj\ia}U_1lj'l!3[H5a<\m[Z
    z1lX|Y\]*+AJB]sDTawX?E(*o2!4zwp+K<5p!su5L}o}D'7X*\}^<N9(TjnIUokuPgvU}T*>YHoW
    Zxc<{!u$X{[;V*jSB~+KGaYij[WZ_j-7UszV5Us+Y}j*;sx^$l3mlKU=2L7H-W<E}=pr<XIlJ?|i
    j*V\B3\$EC?@}<,:DX~aY<^;!Q$!Oe#[sJOzN{Ga!!lSI_sOp2Dj,X7X5-;#j+pBtC=2e/C3e37_
    A{@]?C\Lt.wTFp-jx7]\Za_vE}DB_BGIz}_-{mGKX?I3lW1ZUGK\iHO~2G5K7^s!{!\_QU{nB|5I
    $$}^JJp>5DXlG-v$^Ei_{\CJR}rwxWICusxJ5@*T'5C9*KOVivD7AAp>]{5Jp^V+Aj$!gO1JD}~I
    >=JTv!vOXUw+17umjk^x<D\[E\s$R@aalx]C1Ni=jHoZJR!{]Vr=OD^\vUrDb=DZR=xV?Yuj>3j~
    7^XIUO[J^5,VzpQJWY#v~#G2{'kIv_=WTG_s{ga]WT^IwmZ_v1='VXIs@'7HYR3oGT,p+nQqWrGT
    !>rO5$s$Vz^_6T[vX2n]{gxu=}D3{5A5**D,W?mooRZ{IVlze+rZ{B:pUwu3CAp5j}W^J*A9p${v
    n*pa{x2Y\,z1]!*k4wUV=,-}gIZ$#aaO;VVUKAI*Cu};wRv_RjYp_*=@YYru2lDz^pp~jJ$p<REK
    U{^lQq'W+-]eQO[QO;#'\vsX<u#EQor+B;YUCmoR;lOB=_Y5C7~EKr@>zHUQ55*!_xAR51]5[D=K
    _wnU7*70Iz3mwAv[^X^\VU177Y1YUxIJzv$a#TJT35^n:c@[{7vz1au]uKpVUm~<_VJE#]e2Z_r,
    5sA-YR~7&>wH$jG<>%UaUC9]~*=QE\v}x~znvl]Ka!j-Q*R?QzJdo*OiGRo=wluQ"nQX<[D,3}uB
    mUX[IGu^A>^<E}^p{=Q$B|_+JZ+R@QHl<xe$!!5d_KHzokv}5[#px}X[i'X{jOQu+r\>WXCD:QQ{
    [ZQKWTTY+Di^r~Y=ah@XIvrB#B[=*_'>mGrn72lin7\T1QelCxG*'3Qe^puVkU[KGskA{3[J$2u$
    QeoR7!TQ3n2n@<b+{ADk$s2>Xp{*Q7]HaB@/O_j2@r#51s~n^\iClX\T5sO5h]{<*z[7~J}''[v=
    J}a'K@8![A@p+BTk>XUVX'@AB\ZWV=pb-$!xW1_22rRw[s37KoKv+ww-_x?RUsnGVKQA>vvW3BK_
    7BiUpQD]5x?OS*XD?VD#3#vxjZ5p?Ym7}KnjZ\~3o$DRajeI<$Mk}]v-}Vx!x-=o\=H}'~]|C!s~
    lAIJtYJV[Z=[$AIOCH=3,ICOrV+$eHEjnYj*r][[RIpW,BWnAB};IvGwvkx;5^W'eBxTu=IG!lVs
    e$]1,wee;]s[r1!_I}C#OUlRG,,pJa>$O'=+GQJ-BEW!}(lRVu_B3JIO77T,!e%(HBY#'8+_A>GZ
    R5Qm3~=YXRH8v+E$z}[]so[Kh{jH@AaUH$TOul}Vz>'n~Xx5a[wHooxYs?_?+HO3C3<_2x,>Z_<a
    W{a;p5$Jm^aIH(^vlCG\)?e=ri1e;_C>JA7_>^eoi}D=X'_?=K<u[_aI#,1m5^kGnWQ5DezB3~Gr
    p'*3!FK}[}w+Epp2R;XHv\@5?U,~A#}73=sZl+CYABVn3JX1{*#EClX=zEusv+<'BJkA^~WjQ]W{
    pos'aC=^Cj~+^!}~n}1XX_rZ>3al}<mIxOQV'@K-w~=2[_a7#ZeU1Z2\r2*Zn22rC=}BYj[yy7kB
    ]|~HT[HA!^A}[T-[V]r@o~Gm*QK,2C?vm~=Z}k>VO]_JT*z#u7^Oj<iUvEIE#!HzxOnwB,f=esaY
    A~mWQiJtAaE-nVxpS^}zAt@SFn_n?ww_jI>C5h?euK@5Z!7R2mg*x?2-<!+pU>-;\o_&-=^}!Te#
    a{A_=KvCJ[_](Sou]3[=H<BIRjpZs36^yw7Jk\ZW{w5jn!HrieVXT>T]uo@=@IRrJYi'i<V\pTDj
    iTzWGD'$ViVa!BCVw?xEGQlKAEAGTk^]}aBRe!{o?ZaD=|5k}'"Z,A}=X]CRK!G~\aJY>'p)EV-1
    PY[,B\2XT*wrGR$EEREVVZes^X^KWJ5up$Q@<1}<@}Q{_XX}~D;6zuR}Wn!3RpNp$rBNp__*)aw'
    1H$ZU]rrE_uR{(-rX$O-OHNoe7j~aReAYe3$3C{Z-O<a$}!fjaKarV<p:BEZ_1Xn[MzZJ}~IQ@@1
    Y,rmK#D<~op!'>oJ_G^{^-h{{R}5!'BIBTW}rjn=TJEsaG;];Q[[vWedHa,]3]*^vi-Czaex~nY-
    a]H,MK1mERElD3+~E!oXBKn]oU+uopm[Zm{K7@X_AvDojZ_p\NYfsZw^5m'C>]#QTz![Jwu+p}3}
    O#+K7iap5RDl1x@>~wURrDX3j$H[D_H7j]*=r1Com<VDr>\xYDKk0@j7DE'ZlB-K5b#sa_5a2ER_
    VuGA@Hk$p\35s\$TSreB5cn,ApY@oesK}H7iH}3XW{Plm+UrV3YwlsmV,#HEx>EaO_rz*~sA^rO5
    rKT?OwE~=I^[rJexnw]I51-:r\}$jGJ2B1InepT2J17nQCmVEm3[l+=,++~Vu<~?Ae=@{'!5Qu;E
    \\i^RQ{l13T-UTJw2UW<{Il>A{-AY+3#GKV>[\$C'3-RxR\V'Oi7@jJ\[]7a7*r-^!1Js3;]WnKs
    g^R@nv{=e\iOk1EY2lBoKZ^\K1}#WY'pVr]r=A_XrC7HnGGj^:*1[[|:1jKXliXE($~_,<slHPv?
    ;K|;[$Y5^T*sjwWnY1#,7o<L<QO_YV!Ei\_*JBOAwn_EtO@]+s[]i!QAXp~<nWGEH]ij,zC>XIJn
    RxWDzI{'j[#1?b\Vr7;OV2ZxaBi1HX\w~$I#s{?<lW~nX@[=rZ4)7zZ}E1V-?VmBX{po@Y-v{lY-
    +C<X{T}CX^@]Ql\W_CzJCxwH=rlB_,^'ix^RrlQE"GZn'^^4j{Qv!a\T{zm1{}_13V\[RZH*fg=*
    -I!l?1f#>@lB*QD13CUs@wlvA^]G_o[OY!#}B[@][Aox$nl-5rO+lV^vFekDGpCu]pQ^~a=J->p{
    x%sGRjJvI\eXoJDlwz+v{?o3;=0r7YuB>-^7R@;$XUwnCwO#Tm^OWuzEJWuEmxAn<Z~JH=Wl=Gr(
    v'Z1H}=eMnU{=2j+}Dx*^,e+5KUZo$MRoujmO>UYg"^kn-1<Yuu-uG^H'=Q-A_}J7m^w2lO5AnG?
    [{c']GoKB]3]Jr*WED2|zAZ]9l*>Dn1!I?=B^N,EZ<E@v_=?X*M^<A}*woJTj!#z<X@<GGj*wWX5
    Hw_Iiw}50}oRGx{O3*!QQ%DoK~0]naQ']B+1h,Joa3v;RY#>Uo5IaEmo!*O[ks5v-Jw~]iAr;}kZ
    X<G_i[C~vSO]W$Tj*,gr-jD{-K1ka{*pWzpBkux2_a7[EHV\D,-$aX-oGvOUa6G;K?=\J;IT}U#l
    KoR=VpdSeZ;$|'\T-v$\]sOKYE\DJdUzJ2MG2rY]}$WlsE3=A}j_''XSx{\+7+m=OjnvVm@Vrl~~
    <IkVmV5K^srUCx#YY+WB-[@$e]_[-}+TEk\}_E}Q!v>o4y,rkCFE3>^z'oo_1'!kI<@<}w?^Ra5Z
    _!~'>T7ma^Br$kn[Vw=1}pzr>5[7Y7WlUC@QYD<J[#}MT{5w57Hoe!lZ]pwxlEC'Kj\{w{GVQp@=
    sOX,tUs@oOWU=,KK><DH[};;IG[*_BnV2Ej[5_)Uee[D;[D\^BoG}Z$b*ppwIijKnD7CekR\^*Q_
    {-GHj!nu}DCXvW'o#E?r7i*^8oDwx0-5!m*_DuBXl'B>!w#]m-pAnm',vD{x]+!sH@BA7G-,r#H$
    VlD)!Rm77\^#3pYjTH!=lBm^e}VpowVVSa{X-wz{uf$$rG3I-Y[iV'?we\-n@DTR_{*B@'\}HY}v
    $D1OK+IZszETxjH7@~Z=2sK*oxs?;B.I[uB)g$>+H8=K!kKXWBHl7ew_WBBj_m]=Zm#H=>@p[*w=
    D[w=}T2>1YraKJA$n2e~nJr+XYOkO>=~x[-x<UWYnUXa>>hxlv,pa}mwE~#^Je,x*T_sB=z~xOCq
    rA;x?1w2hBjjKov@;*TKwe+<_Bj?xX$'*]A,CR<<VI$K~}c\X^HVkW}Wx7J}3H_w[_RUC_,qIxwO
    >$jJ5*BG8CT'r7=2-e<}nVjw\f$<oa}*^!;Y{p--rlKho={,kYZ]iV;[[DT}ozOkG.r+ApivYxVW
    -[#'EYY=nW^ap}l7;o^]R1!_j?h^JRwGGEj:#DlZna_v^^x>KGlY<xHvv?H_Y*AKIQY!E!GD=UA{
    ET3;J&GI}DAEl>=4Us2T_[=[,3B=N'O+$]C7DDO>~fr7j-9'w7ssrv'-e'H$M\E^E~A,UTo-x#HY
    UfKl]]Zww>[Ve;*b$^$C^C[Zmoi1[*O;BmE$7>E$+[Qnu1?}2jo5\,#-?(#I<Jkn{5\El{ZE!Br_
    #Xa5^3!7oJ\V]24JBlOr@BHo$=+'A[ARErixWN7Z[Ia1+KQWU<*#*r]WE$W^>!=K5$*\5OlAAD,s
    lepEvs3CV*7k+[5;K,9ie#W>=+H@ekI9Gm~ZE_{QQ;R},'JVwr;sA^Q29e[1{{,uRANLc<TB@<'s
    B&p_V,^\B~]O!W~wT_fQ)<{=I=K_==$n}"=e$DIeB@,V*kvH'Og>1Q$5V=n[m!?=uOv_CwnZQJEl
    WC$/_='JsH<CK7\,Xs<#7+sXA{G^?O#a7[sw|~'*QT+K7vh<rY!CCHao?T_IRY5,\E~O@r>^+{Wc
    2v<*I$3!2Xlo{_-*[_WD;^o7[Dp?l%AD#!'RUsKQj-5m-ZIpBC<7m$sie*k]~k%y:f>+nJ52ZJE!
    I]$iJKO2YlGwGi@$V3sXI$OV]B_*T7UT*Y&[]<QApmAjvIJDX'#:ns^$Wz;$7A-?EimoTHs@jxzp
    x;$Ub,pT+$>_]oJH7VCC2l#Ir}<CYRX}o35i>l#_Hv{BAl<vR_KE!RG??T<wk(>RnIfo\<7WYKwD
    w*?A]<G@w}^iYUaR@C3pjUB4K+A7U{@+UxYpGIQBo<5~rT{v\zi^8oC{YQUWYc>5Yr^ZpwFZU$Ta
    nXE^@^@eu;{Qk,C=@KoJ';roO<[}Tz*use>~B-o|{nX{B!1W[2[sm$o@dJ\]R2[ulCTIZH[]l<1l
    +,o5p,xZ,QJGlDJ}rKz!37,En.m-2^c;x;rVwo,T&jmD[UCim>5kv_D\[*J<ApT$D:
`endprotected
endmodule // module vusb_hs_dma_dev_sm

