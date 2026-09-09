/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_up_int_busif_bvci.vhdl
-- Date Created: Thu Dec 21 22:43:30 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_up_int_busif_bvci.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Vusb_Hs BVCI to Ld/St Interface.
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
module vusb_hs_up_int_busif_bvci (clk,
   rst_s,
   rst_a,
   up_endian,
   t_cmdack,
   t_cmdval,
   t_address,
   t_be,
   t_cmd,
   t_wdata,
   t_eop,
   t_rspack,
   t_rspval,
   t_rdata,
   t_reop,
   slv_en,
   slv_addr,
   slv_data_wr,
   slv_data_rd,
   slv_wr_en,
   slv_rdy);
input   clk; //  system clock
input   rst_s; //  synchronous reset input
input   rst_a; //  asynchronous reset input
input   up_endian; 
output   t_cmdack; 
input   t_cmdval; 
input   [8:0] t_address; 
input   [3:0] t_be; 
input   [1:0] t_cmd; 
input   [31:0] t_wdata; 
input   t_eop; 
input   t_rspack; 
output   t_rspval; 
output   [31:0] t_rdata; 
output   t_reop; 
output   slv_en; //  read/write request
output   [8:2] slv_addr; //  address bus
output   [31:0] slv_data_wr; //  data write bus
input   [31:0] slv_data_rd; //  data read bus
output   [3:0] slv_wr_en; //  byte write enable
input   slv_rdy; 
`protected

    MTI!#'Z>X9}Gxzu_kHG*-H7}Zl~AO;-]>}P7RkU'=ei52wO}@GBkNxRv#yoZoWN,IV-}I3_qurpJ
    },-e1-QVDXQJN*@JEyx,HVfkX,KyOzk5TB^GKpi{Q>D]-DEX]7nU_3$7#^?_=^>_G~\XJ$GsX$v#
    BJw\|<ax}I<~5n$J\_<C_8I~x7luX;]v#lOj+sCFl[#COG$oH]]X<h];mx_U*B*;Hegx'mQV;v1Q
    W@7ix;o]ljm\kEjD}T+e(6L%nGAvHEC[HjZIxbr$7K]ZjQusj'Z$#QZ55*jeA#]*j!IYkG]^GCQW
    7'i\7GPJo{~-Dq-=+WRowK!'?v1oI;}@[u$m=!GT[]n>{X=pKki<Ovahv~}Tj3p^wR7OG?!]0s}X
    x'ao~_7D+NU*CU7+33^jYujBO'KprkFA|3R'RQ~QZ6?zj#&e\Csaa@ng-5>Hzu>O~r!3Js*[wQJ#
    Lv#os9\JWk7Y_Ar<DwDEpH7i^zLsG#1[Clp^NC[Xm19Qz1okR+CEXnz<|^Ij^oC?smD;~I3!p)oU
    \;vmwTq[~\_\+I>zKw5?a=_|9Y#K5lC;{=mKE+EGQ,]TlxHEpC-w-G]V<J7~oQ3w]GI<,!|dO/>[
    <Q'eKx<O}<QPVR+{pYR;pZozkD}B<V#OTYYZzE~Gs+JW?V'eS}Z'D]kD,j<O-,xlBH<12h{}j@_Z
    BB!Xu[H\>_>\Y$t2z<[\w2kH*D7^|dJ$ATJEm7_5#5[TEmj~ww#[@7E_riNv;K1a]3-G{oaCWVzI
    mCUVVs_sY7[g]ixk@rXwx[[?O~G2:m73~~}?JbevVYYi2_w}wp',-DTsJGLI@*sj+Aj}x,o>]~5}
    kmZ'+2GB<V2x3GVr*\K2a'??Y_~([WK>+a2ZSn-;?!TE^2>upKss;4CZr#ga+T[KX>BPa[]5'1[3
    Qj{,Gv7aR2Rn[<;1Roe<G>Qo'zs;=T$}KYJs#+u-'#<JviZU]qWoZyoo<a~AWHvBQ[8?='2K\oKd
    lQ>BruE>/*#A@'Xo@[=Ez{1Gm2[QT'\As"qiaAwjn!p>E~k*Sok\j~[R=[!C$$j?<N*3XQ,n*i<O
    #maDI<kp'ok]Z$CX2~QH@JEoe>W{7uoWZ{;Ra^4r{ur?XZvI3}x;s?nBU_}2HsxGvZ-VV!BIsEoH
    O?n~zZJDwQ=iEG-kvlBmHGvp_JI*VI-r<=j=!Q\BzD*jpz}x27E]iIpnN*#;u$!wrXe3w#a,{=mI
    maX][l&sjK1[2w?,w!\~RpAR=Zs\luBzw<5Lr\_*W=@,*J^U&}OY7RC;<s[7>*Zo[JV1;];W[OYX
    2>_!?NQrw[S^PeBXweWuH(N!1mX;\'jEori6wpC?,amk2reJ2\oUoI7*Q5Y?o-ms2{~!42-v=Z12
    n}3Xk<[G_oD\1;_[O-[$ZCCWTV2[Zo7]!l+UXK.{-w}2UQx^XAajD32vZT#J]+u}~Z7lRY-kAJ[b
    _BQ,d$=Eit=Q]<q~ju}3<\zsa*o#nKCe~*]LJ+2$#HUV1U~O<OlnYwJ#:&uVEB?',2$O<?jJ7C]U
    ls@_$Ex3=+e1B+ID?5i}^xpOnxhR}}DB-7J]*,7vme{U7z#b@pVr#HeW=>'O?B@k^^D='Aske1Ol
    ?*?WTE!e-w}w^j\*:N'xn_m*{kwzHmwOAa]z3=@V+O\<_#7?+<k'!-O$]Gm$!Afz@7\Dve*U+eno
    >3=}KYmQ<siX};_.Q>GYUEz~VE;*i[z~{}z=,$U+#_EE+}i,}opaHVE#<n!Wt!pxm_K^plK>{p_#
    7jjOC,3@3|}*lUNjzeiNeZ]5?r?<B>;aXls!jTT*=Jx*>5l'}\~pb=5b|#5kB/Avi'}K=Xr3Bo]7
    +[D4^nHJ>sY<C}aaTGCl~w_DB$3}3j@kL\@D]'~75_Xn_@x~TFAC,3lxoTIC_W~\i{ol!pxBECc4
    ZAO@'UpZ9as=}iEAQJOJp>sko<wmJGTJ*N~U@og1[~mJlQ,[<aR<wDJHrVlc<v1#\J_#'Izi5]x[
    {-QZQeQEwxln|aAwzzgH,Q#Z7X_RnB#5D[-v!rKr$~u5;1XsmD>AG[eci]\VzK<H.#p]r7Z][3<!
    !e'=RIpKQ6VRk?1XaJXCQ-BDC'{*#I{I3@#z,j\ZpW8>YkrSH\RZQ[-![VG{*>uQ=@]-T_!IzKo-
    'x7;qY@OzqBJY7$z@nl$iJ}2z~tC3I!xDCZpn,T[v'Z4k+s!RJ<_,Ex~HVTEj{KZx[,TO}>#YZnC
    <=kH<I2ZSua>AzZo^><VZ<XaID2,D2\ie$3'evAo>[33?K$]1Ix,>~oI~*WIvjjokv><#?Vo-o>;
    T=@We#'BrDDExBuH^?RwOrj@XWjAa?*mD[EdylDp1+D=[$BK-YIA_rGXo6!ane;}b*osHC?oK$[~
    Hx<YG?=73?$e\C~=#]Hs;K-nTrIWY,EEE_V1~xTx2'aH*3GVzHze\0>Q*=?D}G*_}uC?o[BD]aJ[
    -~ep[<Ua>+'!oK;B{z,ssZ8Wp[Al+mr5-~n6E$G2}Hv[YOiu[vsAu_u_&OX{RvH!xOXv2i7J-DUe
    ;IT!<'!'!'-*'2>C{#H=HGpru*+@kvkwQ$R@B?\?okC+Q<RiICr]XIle+s3BC9PW'unzxO5pk@\[
    =[U#rX{jkW2'Hs{*Y=#1}z@#'_W<n\2JR=I;Aj#tr~7{rR7\l2v]=GsIp-w^UTJ*\?@s^H+v~AXv
    52WIBW'H[i!Y9oo>A,HY2o+or^o,2,^H5Qz?Dj}ra968Ve?x=r]n{5YATx>E-5{w]QY;h6N^?ADg
    sEA5K_w>KvjE})9>Lrn~zIz#^]uBBEB~jn<I@f^<a[%]CW-/pC[iGUvE^m<m]]<T0Qo=ptr3QTjG
    ;W8DV>rp\vn#Us=G]{eo,=*>nl?-pmp@Aj5CA,G(l{^?J7+^~Bv#x,3ws5I~qwAKoRuCDoZ[TH>a
    +dlZ{wRx!uXr#$$}<azepGZV#p/s?)$k6j^Q^-YI#1$X}10koi;WTo]^KJJ#D7X~}[Rp\l*Rn[Gl
    klpOCYUOR]{xm+BIQa'H\}3B\75u+,K.Aa5mr7-jHY'xln;@0{wBVgUn}nE^3J3GWV$~<24Sn>A<
    @Ar+/}un<UD\2wBlowTHvRTaG[v?xD\G5x,jVi$J>x+>a\E*Ila=IKOo'~^,Ux_H$eR+?+w\3vE$
    Go@epj2r]ZGK^gDQu_{\{'wDvD',]37j>-&1kTx}z3?5GzXmRUz<Cw=kA@{OI1oYC_l!7nY\BQ}v
    a*K+7+RcKr^EW[~DQx-}a]=YWw3HsBj1,2^~7!=KRY<<l]G'h~5{Q]Yi}lHjXms[V5w$i}rjo8O'
    !~+VjnnC*-~<o2n-!'SBWAw$~1OAv=U,[-js{eX\H5]Z}#BS$lv]71<72VsJ1n;!'mJHpD~^TlY}
    55\xuv=~krx#Z]i[IZ_3]V#>O+!1$nT-+=p!FkCea!x<]'}[WVZCxA1oAzT-p=H1o&IW\wJH*@+V
    Bs$sHBnv_5}UJUJO+VCp$@_ooUOE25]xiC7ZBzE}#a*+zBP=\@G~CYpbeB?H!s!EBkZApz;CH_mJ
    UsZBqsD!_CCGl#R~p$'G2>jBV*2-;>]<{nv[5yis2@|^#J5kH;U0j2As$X<<zu5E*[\=2R1EA{RY
    nz[xt!T-QG-<V-]a,;]U[OervTa}Uk]<x~U+Urk*rCuVA{**_H=m#jVI~Di[O[_o+@}XweceT5#V
    9;U'~I}]YN7K^U>=@EwE*BbQxfp>2Iu1W<_t.|<C<$!e+ox{;]3AYv'eR!T<wT+n\!N)7skkgm^#
    Y^neW|S),X<3EV^D|>]^BZ7kYSA[@!UE=nI*@uwrKvJ5=wR2u]<EDv[Qw!'sjv3w5=?Smx1IvkCu
    .K^k$jJ_QE,Rin{wrF<{K\4R_w~zHSGU@-pJw]1pAj8YJ9[T-H7[#ZYo*OUOG;*P",7QQr'Jr$K5
    +URiWe<Kp_MH_$+W]kG^lz!+l\s^;xR"|[#![H\~OED$uxI?T(hKN"t9",}IV!U[5kh^?EVoaw=r
    7T;#Y=}D]uU]s*{[v}k2rCo-7-[Blj[?EBi~DrEX*'25v$A\[lp<7pW7>7T~_EvAnu}_^@O~lz[]
    ;]R[$<}a]TA^+5k#G}jB{@5Wrvo^*r}Tr}7]$*vvXBIFx*o^!e+EmsHxCsCCz3_nS}A}E#1?\o#7
    ~IBn^zOTnx~,,7;Czwj7BjK>V'e[D'}@>eUxBU]oi\li*D-ose;>!C[l-M2}!V=JZUj3~]3OZAB\
    e_Is\+jVuZ#jp**O>$}>u#YUYO&N#n;#Ca>ohXExI?pk~7R+Tb3\*UWYr?k{A*mee$wEn&Dj2aDE
    _W=?}]0\}Jv"|*Ol$R@jB]5>'s1'TO3VY/*H-+7J$\]io$tKx{HuXx<MKAJ<<THCC~U2>z]r@Xa#
    1_,{Cp<m!*nECR,[IozGQ}v+Dj^$EjC](WjDrOYGOD5~+QjZCEVw>v2[>Z$j~P[WpJijD7nY=V92
    I^OvJQzhZaGVFx~{G{ea#|
`endprotected
endmodule // module vusb_hs_up_int_busif_bvci

