/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_portctrl_rm_fifo.vhdl
-- Date Created: Thu Dec 21 22:42:03 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_portctrl_rm_fifo.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//                         VUSB_HS Ratematch Fifo
// 
//     Handles asyncronous clock crossing.--    There are no software or user configurable registers in this block
// 
//  Block Diagram:
//    Transmit usage:
// 
//                        .....................................      
//                   16   .                                   .  16 
//           data --/---->.-\                               /-.--/----> data
//                        .  +- data_in          data_out -+        
//       txvalidh ------->.-/                               \-.-------> txvalidh (*)
//                        .                                   .     
//        txvalid ------->. write_en                  read_en .<------- txready
//                        .                                   .     
//        txready <--o<---. full                   data_avail .-------> txvalid
//                        .                                   .     
//                        .                                   .
//          pe_clk ------->                                   <-------- PHY clk
//                        .....................................   
//                                                           
//  data_avail:
//    synchronized !empty
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
module vusb_hs_portctrl_rm_fifo (wr_rst,
   wr_rst_a,
   wr_clk,
   wr_data,
   wr_en,
   wr_full,
   rd_rst,
   rd_rst_a,
   rd_clk,
   rd_data,
   rd_en,
   rd_d_avail);
parameter fifo_data_depth = 3'b 110;
parameter fifo_addr_width = 2'b 11;
parameter fifo_data_width = 5'b 10110;

`include "vusb_hs_greycode.v" 		// file containing translation of VHDL package 'vusb_hs_greycode' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   wr_rst; 
input   wr_rst_a; 
input   wr_clk; 
input   [fifo_data_width - 1:0] wr_data; 
input   wr_en; 
output   wr_full; 
input   rd_rst; 
input   rd_rst_a; 
input   rd_clk; 
output   [fifo_data_width - 1:0] rd_data; 
input   rd_en; 
output   rd_d_avail; 
`protected

    MTI!#[<2K8M^Y;A!Y7,QvrluG>BI|\H$Akx$"|A|"K*@am$'2lC_DDjeiZwxaAe#x$<w2rm]pa^E
    T$^Z'ZR?'1KuzKr]}Q#[n#ww@u\]D=__CZ1o=Xl<3'Ym~P+sj[y>o[lJ*<xFf<Ymk%^vju${s=[5
    ^V?1DIY<{pOR}XeVo;AQk[VT_[=eZIN{>\$}s~Rs>xWQ]BxF#lDJ$0EjE@72[pE?oONAara*WEjp
    =RX,=V#==s~wAD$QJz[mr}Zo+n2mx}n<Y;x7j{p3Ox%N^r$-y=*OouC5v7Qrs\TXsX5]BN}+lo>{
    ,7g/okW{i1Ep:+B,3?oRJ3C!5!jw\1VeOrQs=,X=[;=#Zo^J1$Zn\D3W$hWE'lfl^Zk+U><,#Om=
    m[,^i[!fR[k2T1~!]TJzR>Q#Y+J5+[><Y#Gmsmzoq~n1]n<2;IWpT<\CAn]@j^=B>x#>1_]\u^RT
    1"*7#T=[jDF6m$$sj[V<QW+D'\#;K*<#a[-<{Dk=Y9+5<^G[#}ae'amz]~aw\?UD{pks?stQiv_C
    J+5*21XD51Cpa7_MYJlUq?Y?KVR!X4Qw7k4~H5Cc$>ojJ_#W#xs*'$!ERm7n;*_1ijz!'v^a\Q,_
    H[>_uEIUBRRin'H^J5DY<X_l@A!jI!IiD?-^_mv;$&R*Xr2a[H5AnJAIJlGp2r[7}vCUvkonQ3g@
    CCiiY{>}^mkQD}va{A-jzk*!,BY%>QZQnnK,:=^_RlC*CAV<'Va>Txp#5j*p?~|Fb~*~'#T7KE>p
    @~_E-uDkB-^Ua$=~Re~ZUuezsk^(eX@ACHD'J'vC6Y$\<CXQC*}mO'JQW[]<Qcr&=BD$R,oioQ!*
    *}]3l\5JnYYG\iX@fT11ZD^GHsX$xK5Y]I-!!dxm;[k->HDYEiNn=j!};5^HvBv"UYi57l*Vr>!Q
    }~7A@=R$3oA71^2Ii7<p}[iTV?Y-R-a};jj@s<^=p}G@7j-VepYvKE@rgjn3J#z[Il~nI7@<u@o#
    ><T{xeHK\Ilk^J-ZDevHX>Y;V7a$_^E*Ez@7OOX}e[{Y~7[Z'2U_a!zx!MPk<w,r@{j_O$mr3W7L
    wDr}7D'#TX{-+_\e5[\rW-5@Ur5v[TCzQl;^nnG]KBD7\CpClX|@_ei0@_vA=[OYu1[KE<Q\3}X_
    5jC?Q\H;-vn{7C#Tk<_4#U{e]PD^_]=x${5Gixun2~sX,,}3nk7I^Vo>1IvUu^sQ?@#1lv1{lZ~D
    2[-<lTH1X3:i'kw#5?xO{Dvp-r3S)*IuJHADOe5Dzpnv1wRZ{,[=p=^}7syD@+{l^GVAjDzznC#h
    p$T1LG+]iCZ;nA}?G}}12YvX-uw1{;U->cU-zu]~~D]]_kF}l{-Hs5_zvJuD2x@e]OG_[Z^ixl{=
    $zJZ*V}G:xoKp~{}u'QAv@xi!jzU{}no~'kZB}Onl!'TrUBQGLmEUD3x}Q5^nZxYZuT^Do<Rx'~1
    xa>rs+5J_<JXl_>AY+$K@!RnB35HuGrcZ]HlBTnGo?+~n<lZxzi]Csx[p(d>rTOx$DlfAaw]X=}+
    :CB?'^JvTb,ev#7,JQdo'l1gFUEvW$jo#_K'QQ[^^ImvGR*<1Ivj2~{>H+{zz-I~XBGKO]VXzpCH
    Zkjv@d2Bl1!Vj^%,$+YsuEaZ^CZ>\o>iRi^!XZU5\AunrajRxnr[ErEQ]OKpe~2V'B^'b_UEG"Zz
    U{B\7?R]Kl$4Zpl'[5eADmZV2,VaxD+Bm+'^gQ5w?pOV?ZH^uZ*W!,~>eH{B].~aADUOHUu=naHC
    ?'"n^XuEav+Il5uKo!^'j3@UA=e0%njI!WTQ~\ZH$'H-<~BJe=mp~Yl[kF+o]\D*ur[HOs&F@r,r
    1<H#]kYOH+wT}QI$K^z!w,?7uA~^#e;lW<a7wU^I[x3U^XnK*}@;*uaBRxn_U$_j7KK@#j@pw{VE
    !Cws,?In}2O{R;x_V;7]_<Xr7go3KX-XOIRD~EY1W7zo7!.5K-Zv@~[e$7\7E>KCn+;QH^w$2$kW
    1$WruAYOjoa,aajBQC'9@Ejr.\W\ABJ*B@X-T^}[,EswIRpuQ}~\[,@1Tjef9Y{}s>OwpmXRT_]A
    H}$7{ZBlv?YK_?|jCXRn+GVQr!@_'ID~<n\1+v;=7V+}\mVNK1BrJxzB*E-oEU+#i,#jOJ^R]BnH
    ^GE7w*-D3'u<9R;+w,}RlBvD~'3j2^tCkIoM)w5~a1nRKz27a2lxwjnYjs[-r;<,x,YZKO+\'ICa
    OEC7DT^U!Bwra-CkZoX+!lo'K#'<-r~1H]cPe_{r\G?IH^_Wkl$~+C~DTH~1Je]-3xapdd3}Xm~-
    5Q'G[eA<H@6&Iju7oEIeHvjk5OoIZ^z1er}w3{HU2p,]^eT#-$Uo7<-18v~,QjR12X<r~'@D@Z]B
    #D\vljC?W5B!W$\C$wp_#VG+C\EZmW$H~k}V[oW>#Hj>'oYTj\[sV:kp!s}H1T1j{Qs_X;lrzlhc
    K^,GBCUrAGJ{F=rvwjiwKxuI@'Y\<,k,$eOz{TIR'x3]<HU,@Dn=G-,Bu{_=;g#Ar;e31oQ=+Ay,
    ~3R\~pAHlnl71_<*!uuBeY*ouZw/jR+Zw_D+IEe[ND~Ipwe[v~\+TVL<VT'$'lQ~A=l_-ezLDD~<
    !=nEE=vES_-GslOB~DVa?ilr]{17C$5uamo?m-]<WrjD<BeD}tpQOii=l<:N'M{_AJ5lUTY,!ulu
    ![7iT\XeEGY-x{+5QKlsOi}T<R$>Kk1B;+YH;j7E},D[_~dD@]oo>Tj8+1}KlYX$zR?3$V<uD-E;
    ]ooQRA@7pj=J^G7~nnl}xZD7+[>jRzjn?la7eo'$;E>RkE}aq3GA*;'@Q83DiDz+Y>^+j^|EoT}j
    Ou\7xQ,sE>C(F*-{}oOwY\swK'e5BpG<>V5koYQ-33D[Is]!Vhdnj~\Vz!xx1I[HnIEUpA?Z=umZ
    }wEgq^oI=3z>5e={r3Yox_xW=|ssno5Dw^e_lk<{r's7e@]BeK[}H}S*EYoiCl'aUA$esHVkGRWa
    -1EV$jT>C>WVa_$"[C_*Z*Kk5R!~iDiT2+>KuUQs*[7[BZ+uz>sDR!=<IC?~\]*=RYo#t{R(u$<l
    ,\;kb1_xU@X~J2,KBw=BOY\msR{Y$YpkTR7_2#wYA50(<VUK+s,C
`endprotected
endmodule // module vusb_hs_portctrl_rm_fifo

