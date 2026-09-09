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

    MTI!#Hj~QW1B?X\wWDVu#1G~xjWZp[~jCu7l1""|_|r?x]SIu'2lXQ@$Zj?%aom*mv!BD7?c+Ue;
    z}ipop]O=2BRQoX!rxrQ*<!wT^DnHQ2+IcTER*Rt{n-^T's{=wYmEzxi=^?2YE3H3S\Y;$m\rRd,
    =^-a^$l2,z@i]aR@OT^3SR@!7qE_5T#\eBV5jn_D<<jZlJmjw\yjjZ5*H^uu7]D<z+{~oR>s2UnD
    \[ph#YCJ-Hu-}u<1g!{o]=WTYwGlQf#Tx@_$#@n]\i2$+[BA_<S@R-}o13Up;Bp+sXDG5DWp=AHy
    ,H$pIJU~;\{?0T[[OBRp@l]@,Iu]kBG!kCR[aE{uE7~@{?},,]jKOD;lT%EX}~|v#W~$75rs{ue\
    KCo=m{oIj##R^j*EzU]e;$zrOv>$'in5^1}Yi7fDNV[n_qjeIjP_,uJU$1KE$\[-Q-aSR\XTaw<r
    jm\2}EK?ZSDjG[luzZpXoQ3V!T!o!?}sk$oZIwGD<\JRv5rO@oD'\GoOue.n>RTpyG;X,!D{1OJZ
    H^UsvA=UC}'#zeI;v\D1TxlG*_IEKUX3X)>*_E*mX\-x2=7-UIavRk>EHTWvGvP^5}2~\$W@pl~Q
    1{!!DmsNB@{+$iCTD5AWJ,=KXH_RxR#TYKg85p?k]Y5kh"G{ToD']n1Ov-$lK=@5,\nGe=7JOxKr
    i'KQVKs'JxN*GDO]B22E32jpn{RVH3+G;Q~C}2VEzujlirO[T'\pj+rUsm#;o#3>rXX}d)oT\!]H
    _{JxnU>anUww-{a<IrsEkX$KREXC!n)GnQB\peZ^3JB,'Z>T>G+7VX*^X[<,;<ojXQOvB>-E;jxu
    $mJ^-NrZQ[YQlK{+m{8{Q>G]a^i1,rT9-jR{KU,+;}J_On2;}GQVYTjQzU1n]*WH8-YW[yQ#O$'u
    BY[llEI+Hp^@BVYAQQYZTGYZ;<2{}eY@;$eV+kPip?+8v;A^27Y*,~'u,~r1\+eA.*VJwH]m,^~r
    oa1HUVQ;B}W1i~-G[5+T~VoZV^1B;R*eZ+E_B"N13jiDnH_7>W*Y$RC,o-7:R-\BaIv$\V<KGxuG
    -D[mpE>,<e>>~XaAbc2awOlT-joZO<QHRAw\1Q;1XA=rkB';K>l3qKDm$];^l*{}'1a;O;=m{un2
    #|vOXa,7^~/6oj_py,-<YI/\};75k~^d'a<-<C*A+7JpbrnAEy-v<$Z=X{v#mHX>DQY2R;r4VCU*
    z+;7Ulm[RiZY1HK_ru[ssU][GpDY7FKO#''K->AX>~9Da@u}#'=7us>$?O]G[VeXe~n=@ZEA$BkQ
    wesHX]!XR<Xklru[,Ju7iZVrku<?BvE[JexHUEQJ>xRjb^;QsTDA5=;AJ2wEe~\A}*YaUTO+jeXC
    rfCDW}^RO-YjVs,aeD)lJJ$7x{p^><veEGH,{r5pH;$vTxv^C#<;aQ]&[TnsI!DMmaXslX*!l,lJ
    $U~E5lnV_WVTyV7UrX,W[X++lRD@Y]YkH-7{vV{AjCYCCsv1\rs^;b/^~vTpG$n\#O{6AV=Yz{Ts
    7KT>$A$BO>mwO_J7#{@BKTRIz!l2]iA7*KZDT,^=G}2Oj$}ix1Wn{lA]%DUnJTVUG=352YTDzoKx
    j=2}#R5_vCW}we5-$COwWRpw-I[?uu<$l_Q^BIm{,XC2I,[l3M/Fl+}l38iI+!Ss$'l$3v[#Xl1&
    -'l~=*2}]+V<i1e@AIaKZv@]#5+Da51iC7-u681Z{A5*EG46[CR_pZlO{w@VR#}i2o*~<_!vWD?Z
    x^c]-jCQYW5:f"p}H]>7p@pdiDBpiYX7$p#+P@vEjl7+'p<XZ<{xV/*uJw|,zoG<Q[IoJZr!we+]
    pmUI>=w\BkR&RT]l@,JuOZ7I\w3s(EO,-->eT2v@-X{BJ6vG5_BDa#wzOxG~O@'DK\zU-UZ>A7Aw
    sz6_J;j}ZROkXBni5r\YC]!paJ@>B3ZwaWk;A[U#r#UDp<>[Y~Wn]$?Go1R*WVzRszUus_UTsKK1
    VV]"!$D,6B@z=X}1-pJZW@YEZIa@wBWsGa7H,fu^un#B*k!<AY]2n'_ZFC~K;>[]a9oY>+v#{=~=
    [XVs1A=~*5~5#A<\A={$[Q7J>J';KzJeXuj{ueg,{p-?<2#8^iD?!wo$?>WG<\+]HCVAQ!!R^kWo
    hx2T+IOkV+5oX_=@!srj#wlz@IOHw}/3'WVLQ_OW}#@{I7U='HllfBoICe1,!}E*m-^C2kT-mT5n
    Ie*u=}}Xa_VQ<l<n3m5aYa}UGsCQ;@H'JA>wO>ar;lX_TtCGZr^rE^{V@rTw7CkTB,;GlO[l1OCo
    O28uO+CTRl]B~3ZfI<jO#}>k**i$;T=J?RB#1]vl_o]rlsJGEV7U{DJY}~QWgn]'^]WT_AlA-mn,
    ]<1X#Elw3e{>KO3^l$z,xIFCd]@r8r-K-Rg>hw_1~xJ^zE7=]<+}vJ'[\7$lJ!},$>*j=[JoOi<=
    k*WZaU=~l[nJj->K1*xkU*wETUx<V,"ao+}%<jQa$A11b5>>TjPeOoerwGR_EI^'z+@d={uC=O3{
    O-IjOiDoSI_E;?wx{H$~K%jvJ#Ro>kE<x=/'Rw,mEX7*=Ii}Quk6$2Ax;HQI@Dz?7G@,j/7W+GYH
    C}ssr$}nH1zo-uOl2sovo<@<'@@n}o{=x@CXEK:zAA1O~<pKO!Yizj@@BV@,'$D1rEG_s1{tAE@}
    2a=U[5[^GYY;rg|e1xw^AB<w-'I-EA\}zV^njv$G'u7v]ArTp@A9$mz#<aUxK[sTXpk@'2lTeBmY
    BI+R9X=^I->J$8m]vKJ*Ck4'on=s]n5B?$C7=kJ-Y1=@X+15[CjRD7,VHj7KnV>x;^@D5+Qd}o{s
    xE'khv][oOE}i2o13rpKT!^pB~>e=uE2[A7~{GWuA~ev1z=rlQ1XkE-Jkr^RaDoERlZXH!=J!Yus
    kDi+lm\U\>H_s,OAxIsG[k<@\I=i3-BQoUOV[;zR*0=IvJs@eakBp@pG1$7+^[T[j;EC*^H<C<pZ
    ~n@5lkZUn3-+K1?V<E$Q5RQnr'{tT8sC+@~l<_?7DC[uGWxOQ$Iu@#Qm]lU<,XC1awXjU!;aK=Xz
    nxH,^[>{zGln]s3Yk=r$RzeO$Z]D<Xr*7>5!CemzX@<=>{$sZxmrvIueT;=D;_>}V31O3^*ER^bg
    o,5xpGV'>>*K:XIlOkHM;xoD_><r;lQ,m'eQ7J\pUEG7Qs2sVK1YmYT'3BUHs1s]1,5Kwz?@sZl*
    1p*V{T7o4CqCz7pkOp?1#]$wY\>CD$sH*J_N.o~_nBR}xUpQaa}aE/>UXJsxs!v~K=Y!TZdlmw{H
    j'x?$R?Eu{D*NH7>-UA{G[pBvQ;I5I'$_[pOEB+!B*@2}VmzjVWVKNvZu'=];rRk!V*TpJ25<xhw
    ${KvI2sMlm[@i[*[)lY!r*k+^n['xw_lm{]2DxowJr8l#2K=6B7]i==i$2Dw^8UIW>*;u~qW\^e=
    8D+pJye}^K)elv=p?=j\XEr=uQenU5^_BX;v!5o#E7jiez!V<p~-C[B[n-e?*D[yx@m{uUC$_1AC
    z{JWp{2TEKHrt|eED5MG{o~1YJ@;>R1.Quu?5H+pK{Zk\2sw5jnV;lGY^_~DvlaKt5!D2uGWJX}x
    @1#p@Zlu@wwAQp''5$?O$$CjkuCKuk]IomH7]_iEkJej?c&u'IIwOrR,Tpv#wsrno>]l^R<V$##n
    RJVGT{>k>z=mv,1-Ul<In\o-erlUjp<[b5!jWuRJTAB'[Dk*5jJ_n$uw,4eK{O[?2RE?vGiAx}hW
    Y7?v;r7W[Qpu{VBWVEi2HH*%n];}2*K#Z=e+vO*XKVHB?}G<\Kn*AI{3?}5K<o!@UzZpwpv~@$#@
    ='{C6Yx_D^#xV]G+a~1Q_o,=k{aX[rY[U**<J;rU7UDXerNiTU+r>H*-AE>6}_,Hw\KGV=!D6+qj
    WUxB.\OA5]@1aef5R'KujY3B^BAR[YV,]Vs(js_2pem5V?+l*+B=3e#,wzT?'};C7!Y?lv53'Vr<
    &p*kXHAwX$ov<YY$'!V'YQXZ[$k1X2Iv#rkWRo^E}VwBo+A_\3^?pQwoeT7*w}{<@x{p5ur;kiBi
    O7ijI3vTJHl]-A1EY?zTo;}~r~'sJ375-x<z?EwlUnzAz>]V+rD#v*U!Ta*ZW~<@_y*<1l~\_J]N
    B~\D]aOQpJ]KPJQ@}-r#ITa'>_Z>w\sYT]H5Y15Jp[\mKe_3RGE#sB#G{[HW,~l^+^C-3XO>DfTI
    -HZsvQy5nWY1rvkVTWB$3REAHWp-e!zZ\)}r?@vB3e~_u<X,[i;xVr,n<^0Im~']!]uB~O^tzVkw
    -x-zDOeu?>Hs{G\eC3C?J$J1PrTu_~_iBjwvAW>ous#ukeRzQ*E#Va7I^|I+m#O.+E?^s-=7B$X$
    G~B?\x+~;[]~.R+C?ajm1a-!lH1u$>vQW25p\mrQKK*mp=1*;sJj;AH7a$aQY!*'*qECO}v]pUe#
    pas5Vo$w=rD>mm-a[Wns3E,o_Ru=irI!oQ({Dl]YP,]5Kr*iC[b#}HKoj$kO<*,<sxT2]VD^YO]x
    5*;B3p@GJ;>~v?Z|gr&]rE*}B}wj#Y2IROjo\vDO7+Ul=J=Jn$>zmWK*OnE~5}nBu+>N{>J{,#Vi
    &YH,'%ieUAQ|@n^^C5DrR;Kopkjr\?{<mD-w\siCsR^7hIWH-KSsm@#qkL\iB$Yijo,{W>Ko{_o2
    omC"[UeZ>E$O7$[^}G@;LQ2R{YIwV3v1sE$u]!Bx}qE>n~c--ouGr{~UvTBTp<@<wI,_3VGT}7-s
    oxxw'pv=1#nUx;K3wuU1^?15{<jy$mTJlR-bGZO7t]OK;m=o#xZrj!5Vl-5<wnr?!=3$w135m>1]
    ou5VsJTrk*WwUWXK3+o{jEW<>'aO^}a7z6@'\@'H-?j'ZV,[1#1<\ao+mZLH5}pUxTTVi$BWEvj[
    ~JClV}>Jo2<N^x7okH]e;G$pHI,v'TljDnZT}'-n1*3[C;OwxJ[YsO<r2Rel=@}YGpvKwCZH'X[l
    T\^L%BAjuS$x*@DJmK["{paEX\IO
`endprotected
endmodule // module vusb_hs_pe_timebase

