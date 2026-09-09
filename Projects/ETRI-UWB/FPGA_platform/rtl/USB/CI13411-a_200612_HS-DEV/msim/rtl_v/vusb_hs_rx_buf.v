/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_rx_buf.vhdl
-- Date Created: Thu Dec 21 22:42:55 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_rx_buf.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Vusb_Hs RX Buffer controller
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
//  $Date: 2006-12-11 12:52:51 +0000 (Mon, 11 Dec 2006) $                                                                       
//  $Revision: 502 $                                                                   
module vusb_hs_rx_buf (clk,
   rst_local,
   rst_local_a,
   dma_rx_tag,
   dma_rx_data,
   dma_rx_empty,
   dma_rx_empty_ctrl,
   dma_rx_mark_up1,
   dma_rx_mark_up2,
   dma_rx_rd,
   up_rx_burst,
   dma_rx_burst_est,
   pe_clk,
   pe_rst,
   pe_rst_a,
   pe_rx_tag,
   pe_rx_data,
   pe_rx_full,
   pe_rx_wr,
   rx_buf_addr_a,
   rx_buf_data_wr_a,
   rx_buf_wr_en_a,
   rx_buf_addr_b,
   rx_buf_rd_en_b,
   rx_buf_data_rd_b);
parameter usage = 1'b 0;

`include "vusb_hs_greycode.v" 		// file containing translation of VHDL package 'vusb_hs_greycode' 


`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   clk; //  system clock
input   rst_local; //  synchronous reset
input   rst_local_a; //  asynchronous reset
output   [3:0] dma_rx_tag; 
output   [31:0] dma_rx_data; 
output   dma_rx_empty; 
output   dma_rx_empty_ctrl; 
output   dma_rx_mark_up1; 
output   dma_rx_mark_up2; 
input   dma_rx_rd; 
input   [MEM_BURST_LEN_CNT_WIDTH_WORD - 1:0] up_rx_burst; 
output   [6:0] dma_rx_burst_est; 
input   pe_clk; //  pe clock
input   pe_rst; //  pe synchronous reset
input   pe_rst_a; //  pe asynchronous reset
input   [3:0] pe_rx_tag; 
input   [15:0] pe_rx_data; 
output   pe_rx_full; 
input   pe_rx_wr; 
output   [VUSB_HS_RX_ADD - 1:0] rx_buf_addr_a; 
output   [35:0] rx_buf_data_wr_a; 
output   rx_buf_wr_en_a; 
output   [VUSB_HS_RX_ADD - 1:0] rx_buf_addr_b; 
output   rx_buf_rd_en_b; 
input   [35:0] rx_buf_data_rd_b; 
`protected

    MTI!#XCn~oa\@1Q=?Ok7-i$,p>UGlDKor@TCa[%HsEiP5,~<Qz3,AX[G'E}naDk[x@r*|Y3BaGmv
    ^-<ZO]HC[=i^X]'Bo[Y$}!r-O7Q'E7ulE*XZ^\\_#+Vrlv3GGwB!!I4"NU,wwc'YT[B3JXO1I,x,
    x!~E',">OjZED_sX7Y-z,<H{xT]FvH\G[K}mD_]^#,xznx>rp$\^mUDZ@H'<{O_-JC^<2Di_v'TX
    3{OCY2,uq{\OGpT=$gCZRB1V-]ds67n+o~}l<9[+DW~\zie_}2(\-H{]?7ZrRnx[{*1ZY1svR~#|
    B+7WoW;?>'V+[!CvqW7zz_ZX,$rBo=aJ'JjG3%m=kud\s~vH[kVaU<<O~'laU1<'Jezl>7a]wuoA
    <o1r?wG@CQ-?>{U;QYn'@QBE+G=m<l^i5'~Y\C_o+Z}qGvrr5Kw7RO)AXEYY>lkD1#ke>IijCOsi
    ]]I(^K,EHs<;k^7B\frY@1"<5X[9TDiCRGA\uU^D>,#>7vjr<{_<:}{V!p3zp|vTBV5Y}')$'mDC
    O;3#vVpY-mr&x5i?>pO#IT\<=xACWsvOi[jZ77ik!as[5'Hw1-lYi<Yu!--[z;=oUV}~[TmG^?}B
    :LiTCE>wnsCu]Jo{a'YppAnzr=MZ1iIVJbp{sH<B]H?I7*X,3Ow-e#>A_jMWsD_'RD*5m}ec2xx7
    B4!,*]52HQ!,Ux[=DwxTCZ,VJGcOZCk'BzJIz<lwBv@RvERj>\K$}CVU9^~_3Ho{+Q^V[T1UHX]@
    jm7*3u'{\'G~s'J[})Y>U<US1Y@zGZv7oks['ZwOcwRBWa$^^@=@ZxEllG$}lHp}G7AT7P>RIla]
    u5,{[J@}7o#XjlpJv[M;]'$$nJZza@zls=z{^A$RVip>a>T/}QlU${QkVK--7oRiJ114=-z5lD~v
    ,]TClj]unU'wQwA}Kz[E^a;{j_5;o{,RD-^uzmw7pzKaCjj_?Ok,]fJOn^mju_B/F=Z=OiXrV7K]
    +FQG{x_ZokZGwzajX*5EiJ>l[iIx'o^+]e7Cn1RY!^,RmaVvBVk1J]DxeiKsO<}*u'G-a}^?=pYm
    12D\A?1CH'~OeZ7Km'~H3mR~Nr-\2~B[Kk}^D^'mvzW+2zDmIQR*wACuvHh~z<2(K}A,'V\lQ*{e
    o;}U?eBm&*iJX4-zQ31IJsx\eJ3RsAzzw'>5+o-zEOxLD5nrY$u1BZllg;pIi_]KQBxR*Y7aoR}E
    VVK_XK<pBC{'Z[i;-[?=+Ri@Xi7Rm*xGeh\#G_XY?,*<Q3o,TW;n]s_HaC*e%D_T*W*E<2*@WVD!
    E1!73=}VUHsx_ps~<o#r[k1*x_75YO#>$Y}jnXX1#k'?21v2OoKs?UGp<!vXk^?OKo[7OSJ,->#-
    7<Yo{#*{I>YB$l-[Q3*a*=axp*EZ\K|Ylr~k'uY^Ra'ID+EUI+<v#R}^[<\,^3B^3ozVkvT?BUpk
    wA^]elG>Hl5-vj^\A_H!-v]-\CDWO~-[TY=&2X!1]@aXen$i1;]Ai}[O$umYRK3CkwQG7-Km*Exu
    a_K7OXau7r{<a_{2hM#eJKJ}i~mp=<0C*HW#D~U2jQoZ*#]yEQGR~_**K']1X5,\2_}k!^lV=Yl*
    J'<@/OUepvU5p(dlz^39HRpUZo]x$+Kln>avu+XV5'%GCw2VR?AY+*O<a{Zx}3m-{57\oxpzXI;d
    dI=TkCTPWEwEmC<vmVIR!R!mIm'~p}Kk-{X@Aw\~UnZ<kEjBvexGx'2Ch]{YRaB~j]p}_-Av1\*{
    GvW+5K\prsU}v]*#zHlxE2*W[TQK@cvsE]$Bz^_S;s;R~n-J.kU7k~O>Qi{}o5O!XIBkB>Uvp~q.
    %,e$a$3-u?e7mowwGC2TCHrQx^5R{=eBXC8'Z5nEusop?oQCL"wjv~.<-W~]mGe\Ekwl{[AX7+Wj
    Wz'dETxOln{n=o[1?-]xzU^n7-KI"y~s'#=*!E=u>@s=_#!sa_(?$,KE?{VG(iU]!$Q~eT=$-y6C
    *2*[B~3#r@AC!JaT*RR4,{rD1Y{u'YVC4w,RiLm7BsQjjRLwHO#I1k?H1=+z=pU-E[lg^'5i#C$I
    uaX'Tr^{YD-JSCZ=\%mGsD#<U+|#6JI;*5?\C(^TIBP\wxe?j-RI#}'=rG^7KHRNdIabBX]v7~j{
    x];=n+Kaolk'YT*IG~UVkC}om5*Az'>ReG3mz7}Hvk[R3Gr*!x]Y2_!@vRW!Zlp\;xj$DG5ki,sO
    ,,_R}KWQ2+o$*TY<@[#]1C!#U$Q@=on!'DIl]r]{eVOvF2Yo*1-m+arH^~E+DdOu>w6EEjK+OE#0
    '+;poWH35lwW3a+?5WYz1C}J^ja+|kEBp-UH{m1vu1+wRAr+1<_<\PZ$V>Yn!G}i,lU$#V~=>v^K
    vw?Y,=Uo{^o5DRXamjYGuD<H=1U7apA7}ooQ?wTeZ[e*iA<X+D/v^1u@{vTT7'I,*<^W-_Z:kBwo
    cGRlA=H2_$71n0+jp^$^{uTv[W?z^lG?]GC*~D'A'kO@I@hp{~Wm5u]{wA7]5{zUnvAlD>?'-'v#
    wwvmwA2n*ok#=;7LOae_SY<zpC3rskCxUo_H[RC3=loI,\;1ll!EovD],1Loze+TDr?Wr1^l^z5v
    5zJ$D5zVkoB?j}i#H\r7}C#\WHRAV/IA+okn1ihrDx*B5zQCO3z]T_=Vz,=na}2jlA+rIB?kDYUC
    !jkDO3>~UxUgE9g}WpH}H[BXTJ?^mAwC]$z';5[[<*ayUlw#XD[B)}|>l!1a[V'K[X\+|_2B1$\{
    Y1$poRI<>$-D[7%_kY@knXeF-lji~x!77}[3]=jJ^{ZI[;,rp[->_n[Uqa5?Gpn=s%,Cr3i$B\]_
    x?K=*T52>AvVRTOi{1&0O_l7Cxv~wpOWs5=_h\B'2nar'X<D!_xERXoA3l-EKsER-xeUAkXY<'pH
    ;-<X;,rz>aC<3aO5eVD#s,!,Vvn2oqW]JRQWl>,XV7_$2*lJDw^W=EiDA#8~7E!'PaBT!RRJ#l}K
    Bh<XBv$m=+r1GE@7~'Hx_!7,rVJR*kJ]?\JqeTW*B2]imoZ^R\2O'$EO|A'BnCED-d[I!a~plv$\
    ^l|w=ppU*f:"GmBDD8,~@]=?!;lKA!\12-$[oYdA^a{7H_,ij)$ll#mT]I=,<vGe~We1oirrXRSS
    ,U\[DB<o@G^lQAHY!-*lajzTl1{Qy4on*Wy6CzzG[~(OY2>|$GYjsAjzRN7'737H;jCVm=p3ZTsT
    2AE@7!!5*C723DxeR~waAG!<X1C32BkGzp'OD-*=]z,io^G~7x}Ko~6EU2<,v]zz!5~UVU2uQA_C
    CY,ms_-O@J]9-Ev$lkjsx?>$VnQG1/x!uO=I7iQ;BY=_p>j1@,d5&a\v7lw}3=sXX,^i\_ZWA'"}
    n_'1uv2}<5;^r\+OY1Z*BapE@sDOKCYwjX#I#\7FHvQi^nVv4w>_5T<$#K-r$fAH3HLo]ZHG?73,
    z*XbbsUI,p@W7vkvam*zUQArZC!vV<l5'S,XAu,=@$znHj:QKs*E$@w2-ez;lHD\U]-;AOEo1T+7
    EAB1=7Y}ZQ,v7Z{#IeZX-!eaC?jC2>7XClYeZ,J}Cr?eE\WU}!rI1aZUO7{GB*s&z1Q[7A]BoVoI
    !1lD5kY,GWX^Kx*QVn=Q\{m3aI#UBa7QmGUj_pzX,\;s^<_O]^n2AQ!<Ek\lGUusWGuIz2HxDePq
    4Y1UDjW-^max7=A>DV,vBizOu*ODnV$nBY7w^V#;Kk7z1U[+T?_AU_zmH{TjQ,v,KoB\i1\lX(z@
    T}\~Yjj,*o;<2R(Ls7<#>*J5ex[!=D]Vi{A>'+{}s,e#0wBk[]@^\rQBY?Y?B]kW=2UCUR?^>Jsz
    G_{1^VE2R.,;*GI~Vm>z==}B}#vinT7~<rUV\?Y}s;*Oz7=ieWDCXlXEs~AVvWo!ZG^HB-j_!VCG
    D[GZ{ZKwejz=}j;x;3owZ>I*r#7k1AYa{<'*QzC7,w26VA>]VUe^5$lu&w*n<jZ={-GVKl\wn;au
    K7<zJyr>TE'XAOHIaHRjOeEZ2=*j~ARAT_y@H<wbowY7jDT]>Ym+}WU=:)}irUNiHBDa]kODO_'w
    p5$^kUme'{]eXHK!lX>,i^,^;<W^@{O]EGW=Iv;cv?'G$G*GzBA*mG'5EGaJ<U^-~}E!l5rTHQ~n
    e_G]KzlWHH^Z3REU'^}zA|Znx$ev7=?1_YY$];K'KXcolID[5C-tkaBpiluOGlE5V=o<COA^=$oV
    On_p_1;;EQ@\kn_sK$vG?VzICK{Y_j^R2OQrR_h7[okBBCk7Q*!7^H\5GwU@s7?$>A3]~ri5v_Ve
    R\@w=jr[>v2#a*3G'2p5R<Zp2_!anA3JR1pE];Z]OCUy>lj\lC[rB2jG_~3[DaOGIjEJW_ZGsj?~
    7!5{wCI;BDazx?_]bdYK]{!rO=EHBX*\B-1i1kh%V~;nEzvae2_*C?Z@@rD\Q*WE3B'DKjX*<a_x
    R]iG;vlX<TCULWDTv~aW_13puRGEvg\__jnGO5W_T<*Zj~v;r{KEI#Rv^z\_<~'@V{Uj2_1K\Gkj
    i[U'_U^CU!-wrK98CT)epG?]iHwh>T<1]-J\WeY1),ex+IzYzjROv21e;lIOGGGOa~15;zEuw8np
    ,Bk=\H?5pu\4D2Z}YDTG1>]s7D5p5>mH6^>+<CR=$5Yjw^kla8mj-+QmT?-*lsr_1@a\wo\T'X'i
    }_=rVpEnEvG?YlW,Tk,sYz$;p[2v+YCI-17OQxVlYzrwaQYa,}ZDjs!<Bnml{>H_x<J+3n=_7{s+
    Ok{ejCnQmoT$G3vs~v,5wDA7DAq@ap}t4p\kkOkK<ev{}\?zz/QGX@L4lU-@sW+E2B1X1pxovz3l
    -w}+7@-AzJ}<,WT5@\Tp]1u!p_m@n\>eGK3#WIEpWX+=ciAW^Y\WUoaa1.eYJ]|V]2ACHnu<[>+=
    D^a2z,\C53e\pBK=>a''e,el2D=xV<XjO'UIO=3{v1_=[HO#l+kD*VBE<{3Q3Z^eJT$o3X$Y'[<k
    =RrIGire_xwmBXBwV]=CW@[FBUa=oCj;5.mToUl5Z@:k1x7Vnr}?+$ICkuu-EkA2UKJ'{>3Un>D?
    $r,lzQIb1@ekujIRUr?2<r'<5s!a13'Qzpi>HDQX?jORXO]GJn$}[$eC*2_O''_Dx7#@jC#x2-'_
    _A!J$O*WzDwQ_fI?TZb@ou3vW5YJ_ZZPzwI,&}J{IUoD@@_<p^u~zTrD*@]srp@japi]B27]@'Un
    '52;U5@n'lD!IV''}Z{z5Zt=C*>XeEAD\OIYwZIzuW]Gsa-Zj1QBrE7wpK3D2*\@^2,7Il[*mADG
    s1AGpD[5>1Rp&q_v!{c]+V}_z-wVBzG^Z2X'Jlur!zB:2E3AqQ5X]D<-QY}x>EiTEU<*[Hz@Tji@
    '*~CWNTrXCpJ{\Y]@j7UIDpDowYA*pmCU+?I?1HAaJ*J}?'V,mXj1_GDQ!/Ws>]>B,K2+,ow}{Zz
    TmuQo>op>!$#E1~xW_E:Zn<HV'!s&Uw=2*uU3Qw[xIRT\u+o+*Y?Ie?vi!r^,K^}1qnAr5v+V2{a
    o5R}Wn}i@!p,Q*^iBB%A<]!;pr{W-1ukV)RBCR*I?7mw,~6C{\H$>++qz7~jpa,>r#U$6+E;;Oji
    QE+3JoG+7yoXV{nl-=/G_r+Hji^Vpwx#zETH5[=D#5Z{<J@B{YBE<_!TAOv}>~*VOAWCo#DrkWx=
    RZw~nlRL+R,WCY?'2>2EAO~jiExE^}#^<1Gr5BVp'Tw_B,*x=&us-^R@mnwnIil^?ov{lmc1j}+(
    DHu]a5jT}^jWzI?JuV6HpI<WvATsekQ_mp$A{v#Cx-$uXrDC-]YJB~#R>!-zuaw]D+TEQ*!r5719
    ITe@je~joa-+EC}\N~{Jsp#$!}xpXT\T,Tns}Ok^l<}eZ_Tn5^Wam*K{z$Dl!1ms}H&+HIVLV~G3
    ,k[j#T_#xHUoljCA-Yz#+qe<vU2}r!13p\TOX_eh'-uZ@+U{U}m;J[zi?I=2i+JwICx<G#m}W\2V
    )/O;_kQO]R5'D+A<}~,DH-J}a@{5x2{e!\#}-}e]xWBIEwaH_sECHBBeEe@RlIeeO17OnkkR={~j
    Jjz<Jr+'Ks-vJpo*A'DnUoQ2n#-=[ef'v$[}$=eD=A5[,,B=O7JlYz+yv~{rwNE*Jva+'K#AVRU,
    vGVsK7?[;l6zsVY=Q+_e'{{5-X$p:\ZpoEDiw*1Il[}^iGDn*U1z#w$op\!$u}oWCGJAGoi_@,B#
    ?1*m7*7R*D1I*jaBiz>xp/a\XA,rW10#1_<Qux_C~IlC\+*Wx[i[{B$^pEeUY1i=r[[Z7aI.'~Y~
    e^ik^gzT3WpEWo=zi{v[i\k>^,xaCV|n_RapB[<'I*u,vIr>Eke{w^ixa!XXCAQC<*Cl]'}\CYAC
    1Z[o*^>2vBpmGB,~+@5^e~3V^ZjzJA'Te;3=#na$i1?!UJ@VGIY;w$>lku?]Gm!Cx2Z;X_7!I_oE
    ujBaURRp_QTC[^H+]JuL}@o}aH$K/QIs?V#v2]in,w{oeu^<~xlAO2]<+STz^?kr!C'3K7$\^*zz
    THj>s$@l+]7'+wV\m}IpDeT9$5p$:#Dp^x1UWD9AT\=eOnm5BT<_rH_]>x?'XVYX13xA}i7T7z>1
    H<@,Po<m,Ys*e@'ZU^@Bx@,sI<rnQ5'3$jYkln\j'eH$2<HF?+,>ip3!lo,v*x,~^i!'y1EkK*Y7
    wpkv2vIpRm[A?+GJ$h>DwC+GKH7Q=Xr$'ITp1Q5]IZ=uOIQT^R:BAwI}$Ri=3;*HHz>{oZ@D5;>?
    s[[4'Z3Gxs=5[eJTx0HX2mWG?Gpnp+=[+\,A-ewRQ5}WV~E5evqN.KoumSqR7,eR=T'-CG7]H,a?
    _~}-V;jKDB3W\D_S$DD'p\5U}~[T#QraE_ap{G\uwT;'U[KrDs?}zADCIHuHrrAEwH1-*DhCEjJ#
    {C!vaz]m]!Jaz@2^i][OT}$~>EsvRQ~WoTCWIvsmU$*;[@R5mHC;n>a[_==#nW{_=VXTRl{aAo5j
    D?3@1rz;<UT*3oHtw<xjnAU3=CIaL?TQ1n-]]=}^=3={wE-jis1-~ss*3T-R>axAp!nV3=X^{h1#
    mJev*iKD?K'kaVm<^3v|esh^i>RG<uV;D?eC,JH,1T$2BDEj=_GQUCOuzv\n}\kaaZEjvR2fz]I]
    _uXZ;]'OoAOx:5QC+$r*vi=jw#joxaV]!%}o!Q7o2W7>-<1rRe7rks;=aAZXRn\#*^5UpD^Riv55
    ^,;H^C}7{2V+]uj<ATr;+7-pZ5|9rTG>m'<G@}uWs@mE,i7T\IBjz''IyHYCm$zm1#o-s,JHH;H]
    #i]{7r[x1YT;k_IiU,#CxkzmErk~ToHO2TU!RCIimzrBk*oivz~2=vTA-A5El.}=i>m$C?}5{Hw>
    'JZT=pV}nZy&CGoJIv-C^%i{+CJX}v'\wVRe2OUzIl6#rTY><OpcE-d}5_j8s5D=u\kKUX,i-Qo{
    pElJ|XTBz(-O[=LAHm][Q3H~aaU'@U]Eo7rIKj]4'pj<__=#@|H+{kEw{*!I?EIV]A&L^Xm,dAHp
    p1^?J#xB1Pv#5aY[1YC_x=]z@1wjjW@$v>ktIk<x1$'nCn+XT,k,#e7Y8D;OEY*]jv*T[13[$$*@
    Bwh@vZ@w^+3?xu5J7JW~^Ciu[Jo!,Kz2V!vq/OD<^+-nk1kG~CUE\k-Ds_GEJ%p3e-@^zAWlwe-Q
    V#zRWHpAxi0sZp35N3D+Z\B,Cjw\mO#~D^2A?l^kj-E!W}x?Z:j,*R>Vo3;+G\^Hzl3jw!}*RWi5
    ;p:k1,@3,Dz8XD#okQaa[,^j-Gnrm'[psZ7=,lQA?s[w#<@oCssVT,;T~-KW]BI#]a5$osjVl+-u
    v^I!D1T@&OrEQD;m@k{$CzeJm__<nys\xA^-B3#j*l*JEKZ{<BE<Z@ZOGu#e3n{BHR?*r\E*;!>E
    5viAQ_5D[a'aU]HnT~21jVIT'G85DmTQ*Xolx-l_xUO*BzZ?>oz3t^Is$]{=*W{1pow[3Rmoj$xK
    *w{^e;l2TDWewX$n]ykz'A]7p<0B2BIm\opxW5^o571QZ1C,H[3'U2>j~e>T1zC5!WA#BBX}AG@*
    }+rr^a#oO+?B\CuIIX1;jGIlIBG\v]i>nj'6#7$E5_K{jOo$^U5r><,D0xD?T2QsGQE5wVvYXs11
    k-oT3~s=Aa>\D7RoZ\xJjiCppZ_[k}^Q{L^Wa<GA-kmEAX;X7<[*oi.lv!uAo#XVw\2k-Kp];_[[
    9YRxpnDe*ssw2*aEo!5T{[J}<NQ@As{RjQ|x@^Bz$eD[1Y-^AJI/BZ<rDr}I<QUZnAuV^32<iCw^
    I5J!zH}<^^=>?oU;3nAI)*w$AxWuIB{-_eATwE1nj*V-D#CB@orBxr~1lUE4h<QJ?lR}Km5eG]}W
    QNHARI{*uaVV*kDRe]\zJW*hA5#;=axjpADxp5z,S3xZjus]C4Y]{RLOm>jTIse{IiC$_<3Zx1#t
    EsVwSG=<?\ZV+:{e7z_>lpD,QER,ImHY13UQDTm'Ho@+,DU1YOnEozR'X#QEG#Y#nn;AE'O8~GH3
    J>x^p$ZEmx5BI57l)I@Yw}EA~H1X<z\o<eWB_^'@mVZmUI_7k?e2HQkC1[aeY]GzvDr*V[T^Dv*1
    'pj$$jr?!qGZEE+e;T;H_-*3>A=UmjUV}TuYWV]HR<5espnwOp);,;[SXI$$IJnYxZnUJn;?<_![
    }G=H_$-'r^,s@r~;s5OXxDTR3=@Gm7!CfasH$[+HOQ5\',OVk]OkvBK]oVx,jrGGrgPpAa!_;~Zk
    p*sr{x@wCAo\HX3eJWWKRG#lJ^ZheeC[>]$3jEInBrmEo<-w1/TXDUeR^vUDGW'\+3j1am*xWIxo
    ~xW\J<CAC1m]{_>V?Zu^+[puK*m55{VTAl}^VBi8CKmn?7{Jh[R}@:WH>B*CD3R{ezM1B*D_>UTw
    r~+Js]3@HlwXI?GolEEYoHxpwT-{X2_XQ{G#oWXDDKHNI{'R3ri1pCZUTsTCp#ju7k{^$iA!({jA
    _5rJenEoux_2w1-ll2}<mX,H'Koxls+,G<QCH2TV>;Y}\EYz[<5x~O]-z+^kJ]X[JRw*TxCG{_p*
    =*,~{dua5~l',j#>]@q1TRX6'-2X}>=3]@+G]rJWiGR?V+mo_~_$yK_{R!wKH_2-!OzHQ}Gsi0]2
    AB3pJ_T-rj,u+J]a'%;6XIj;j7Ceno3E}wKGnA}rY?,!2xD2Kj1=QO~jCkR<;1E^7p#{@Ia2GKv\
    5_1EC+YH@VIi{Xujv;Y^'QZ}$+wknX+2,-KJ<*j52D1'l+^2Ybf[3wZv'j#=>@G]++COk\{\Te-$
    {;R-G~U<[1V+-+~='m@K_Hw:;{mJBjmA[V2;Y+C*XI^$,Jo3?YrA'l}5d2s{2E~5D\@YBI!T,>,_
    Cu'n[OeDuDD}VY@CExjrZqYATE]^Zos'E<CRVvUT.H{=*ETRv*Wwv-UIa>]}~EY=i,*O^Tr+BmD^
    Rp,UYDrkpkeEXB>33Epl*$W@V2=W1{]H~o_Xe2G5p<sZJRs5j}DiQRO~s-'nr,woC+YEA%5_=-vm
    \{Vx2-#eiw}~oATe1G_{@z=s7x2wH<xx+\r+_-TY-eD;>G#wGu,~H;=\5*mp\z>[7]mpE[}>]D\p
    VzMwV'm'Q;J<G]p+H+Zze;$^12zZ7_1V;m10f_Gvsr+w^Q#32'E>$<|-X_OOQ!!DH=rIUTWeVxD!
    >[^3De#B]$$nj_l?5<H${pHY]xa+DeY@\OG@Au#_~T{+BrW.7EV{BE3u%RQi22=B3*i^E_;KEEU~
    k{G}QB$PEm[*^=O#>V-*xsHZa]V[Qz?W!TTuB2E7Kjv{aaHU*<T!FKD!Vs^e'i$_H7e*}H-@~9o|
    v}{U'!mH),Osu_JO{ir{,~]k!2$Yv+R0ez<5jnv!3'_\,\i;?pIw*HQ{~8zoY'C[I?;le]T'vsIx
    >D1kJZ',wv]Bn~YwYiT+vzEBUB)H^~KyUE;5$r<-uOBs9z=Z>HrEap[]^3'i+#A\ucH$KV3U3vO'
    VU=,@!!e?Y*OpO2eO-,*#'-w1wGT-s!GGzm1KJR?CR\#aCy*CzE).sHV,,)(!}JH6+_X#7[+Q'\C
    ^2B>r{5Ra+<Y<2[przlK2~>JrlCzmiI*-H{e!IOzAo+ADW^-]SCG_u~<W2!>*CK7*s63OwmGB'\}
    mT@G$zKU]'Q-p?pvDI>>12\7VT$E~+7:m^Kze}Z1l-!^B-GW-Qj$oIZrd[}'r^QKoUTs2~xZ!O;U
    JQe\WCxC_*7{WvIRXKT=n=UA{@*21AAHrA[TUp21~!j~<A']+^WE2Ba;u_OVXo*7=-}!@e1'GaDK
    x1o,vErTTAv22B=pY7V!^Vuei_zm\{=>'HnmoAnnx[Zu{G}R-]KG5rC{T@AX#-A;W~5$T=+;Z;we
    Q,\Q[+1OzdrGme-Glw.;CKr7[YKl~PQ52VM6{'<sV;{HVoH7*#TZz$?VaAnO&a[r\3nX5nHQk~Gk
    #{sz],e-ulwXX=Y]ZI#1eDJY[\lw=v"_5aGC!1>RI3Y,ilu=ABU<xXeo{$H.-E#AWOxUmjD@]<HV
    U^TGou+r_+~\aQzXRs3s\1aul+_pzAjY]K$uOV_3HT!!Ol=$G1T[((Gk;1~Em?VZn]0CTU~zsIE}
    HIX(?=Q7+j1JxTZkVD!Ua'}iI{*UaOAr\\lXbZOaB{=jkV'z-pQGal[*DH1K}Cz{>C_O^a>DE;wT
    z+vi#kL6%O5-pf.E{{H2j-?_1zxvOJnW}oGD'~?RYI^}7-JzKj@>]+\37XxYb]~<KEGU^p3OK3+x
    X^|1lA?_YU{1m@uJI2DWaxeXp,spRojX1v;,Bz!lIl*l<uU=*js&'*X{^~_@Q=O}vvXO;\7~kr{+
    RCal*#'KJRO$_D\}^UvHxz2-<l}_12O[gMQ&+^@XgG'oOGzU]Pldon)+VT_VDR?r1-nVCl-}*K5{
    e$rzW=5e{ARGT<}\;*Ruz{UW}1vY_!wjUsu'{pm|$V;enABWMuBe3pVeU#wsz*ZI1[oOaC5i+1un
    HjUsvRn}[mXjuGbo*{]1>wJCAa;enr3s2^o-RBH&O?la,}_o5tDw_J+j7-A^_7Iv}UmA\13<+^7=
    -o=WE-,5o72H7ujTQ_vx>_3nOzp'HII+mUX\<z$O\i!1nI<D^[nQUD2CXbw]m}EWevxIQTAD?@>e
    e^>ea~AN_HnX@pm=11xlI,7Wsl;>*3j'6;RXRJx3nYHpYxv5#iTGaun3Ie}>B?Rn{dqTw~u$TRRN
    u^1r'xR5!G#nE?23_01*G=YV-n+5[p>1{~^?Q[?]>DYCR}lCH[G?E{Z1lO:EACn=Es->-Aj*#K30
    {p[$a7]!%7?m,xJD!GX_i>jiImDTswB,He2-OQVI]Cp{2}O?jTDim#,5nTVr=_dV]Z^<Ynn<nwC}
    #}Q'MhvUwXQ$~YariGH]nA^Ze!$'WVDo_>Za!X=I[1=kxxI5\i37J{zCaj!_BGW=QU{'e;5[Zk!5
    Q<$w-kUpE3WA52e^R]vHZX]W<rXvGD-,I5vz'>^1ln\G~wdeuGC*zup$*l[~5VR2GEH,Gi]U7AT3
    5mx{HX=l#=AHHE_*;wObSYi+K%GHZD^WvIpOa[}km?JQTVlDekI;C;KHI*HIZTYII@]HJ7Ra~$xi
    -!jBzB_sU@+]~<zZJ>uw+n&hY>l,''!{Q<xVeVUuI<j+sXjO]OH{*7<[W_AJCAZV2v+wFk\7w/QR
    G{O*E]mC<z57i7G2BxK+R>@s1,3pzA~<~@DJpemC$$0}j}uGAT}$7pv;CYiuUDBQEIwApo<sAWlx
    IX5fl<\=oAHrcq/k}p*o'k3BpQYs53;T^ZYnoX\pw-Kk_7Yrx,HD<VjzU]EjZ*Cj_lvs>wp<,iua
    n,?Z\U7QKT'"UV<UI\R^MQYn;#UTT{,Ts@53;;zz+Q+H#m$KQH+u-5XQuC=J33[1W;D+EdZQ{GD>
    _ZpIl_<O*x{7(@CaHvDWk^E~{Z=<-WCHQj~@ar$^]*#o$qsX5~+IRoZAWO>AH}7QT24>VZm1oQT^
    OTx!}u<rCZpklQlA<Rl}lEZ_$B'\^;G([<B#uzo[2}oa]j,lsA$Z-p_Veo3Gv?XC+aQn-XXlZ{<\
    ^{$_}EH+[We#v<2r[^+\j?=X<x#p3O<orr7<@[W~A<ze{}Tw7j@oH<~]1Z!{8]RlZ1j]pElKe={+
    KW_7v#+_~%CR@2\w$Rq+7p[[OR1tYWT\EtlU_-h\!ls+}X]\aKehH+X?jxuCx_pH9Ll,*^'O]T!^
    7pRmn]v3$izQvkkHK}fla5kJUzv<Onw~rYCTrD<Ov}~[C{kdMOIsn2w+krz?z_2~-]is^[B7D1T,
    ZA5Yz\}#*^[EEJUe+JO#jmBjvAz=alZ{k-HHRCOz*lwK~7X)VV1{E*a}x\{D1RnvMEVV17eeEQa^
    I,CJ=I,C+,X}\vup],rT'@IU>ZQ5~io'*^YC_-aE-JYw\1zumrjT,Br1uOHwjVpw@wE<?{zXeG?3
    p>}inBQwAXA~WR~<jmewlElV]3,-~mE_'+7vE{>~Y,VBCRB#rR@T3*lR>Wr$U1e5+^U1W\'lVr5=
    Gu=X3+YDnEUzX1GxC]!JQ'V]aa'?sx?=^K>XA?IJpBR^o#$GX,**WGmK~\i7sCDpp_Hr2s+Q-pW_
    [Y';l$e+*^3^r-15~_x$x#^'AzK1[YEKQ?DmB3vEljm23Q-ak~\u3sT,+y]CEZ]Bm=QH_7jxOoj*
    @V$6OZ;rb!+TU_[An}T]]1Y7{=e{$B+I2rTaQ5+mO*_*l{wQKNu-[5hJVn[^]j^5@Kr,i$D3G}UQ
    ZCr7U_C~UeEo'vlQ?\5vW{?;]n}zm\[QZWlorw3r<
`endprotected
endmodule // module vusb_hs_rx_buf

