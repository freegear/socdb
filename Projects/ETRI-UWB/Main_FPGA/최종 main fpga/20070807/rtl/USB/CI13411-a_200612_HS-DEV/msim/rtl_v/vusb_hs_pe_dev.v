/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_pe_dev.vhdl
-- Date Created: Thu Dec 21 22:42:37 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_pe_dev.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//     Top level PE structure to combine Protocol Engine block necessary
//     for device functions.
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
module vusb_hs_pe_dev (pe_clk,
   pe_rst,
   pe_rst_a,
   pe_up_dev_setup_mode,
   pe_up_addr,
   pe_up_datard,
   pe_up_datawr,
   pe_up_sof_irq_tog,
   pe_up_dev_sus_irq,
   pe_up_dev_nak_irq,
   pe_up_wr_be,
   pe_up_wr_handshake,
   pe_up_wr_tog_en,
   pe_up_dev_rst_irq,
   pe_ep_prime_cmd,
   pe_ep_prime_cmd_complete_tog,
   pe_ep_prime_cmd_fail_tog,
   pe_ep_prime_cmd_handshake_tog,
   pe_ep_prime_cmd_tog,
   pe_ep_prime_num,
   pe_ep_prime_rx_tx,
   pe_ep_prime_max_pkt_len,
   pe_ep_stream_disable,
   pe_tx_tag,
   pe_tx_data,
   pe_tx_empty,
   pe_tx_idle,
   pe_tx_flush,
   pe_tx_rd,
   pe_tx_ep,
   pe_tx_ep_early,
   pe_tx_early_val,
   pe_rx_tag,
   pe_rx_data,
   pe_rx_full,
   pe_rx_wr,
   portctrl_bus_reset,
   portctrl_suspend,
   portctrl_clk_valid,
   portctrl_test_pkt,
   portctrl_test_se0_nak,
   portctrl_force_bit_stuff,
   portctrl_pe_busy,
   portctrl_speed_sel,
   portctrl_rx_err,
   portctrl_rx_valid_b,
   portctrl_rx_data,
   portctrl_tx_ready,
   portctrl_tx_done,
   portctrl_tx_valid_b,
   portctrl_tx_valid_early,
   portctrl_tx_valid_last,
   portctrl_tx_data,
   portctrl_bto,
   portctrl_flow_en,
   timebase_1us_tog,
   timebase_125us_tog,
   vframe);
parameter eptx = 2'b 10;
parameter eptxa = 1'b 1;
parameter eprx = 2'b 10;
parameter eprxa = 1'b 1;

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   pe_clk; //  pe clock
input   pe_rst; //  pe synchronous reset
input   pe_rst_a; //  pe asynchronous reset
input   pe_up_dev_setup_mode; 
input   [8:2] pe_up_addr; 
output   [31:0] pe_up_datard; 
input   [31:0] pe_up_datawr; 
output   pe_up_sof_irq_tog; 
output   pe_up_dev_sus_irq; 
output   pe_up_dev_nak_irq; 
input   [3:0] pe_up_wr_be; //  write byte enables
output   pe_up_wr_handshake; 
input   pe_up_wr_tog_en; 
output   pe_up_dev_rst_irq; 
input   [2:0] pe_ep_prime_cmd; 
output   pe_ep_prime_cmd_complete_tog; 
output   pe_ep_prime_cmd_fail_tog; 
output   pe_ep_prime_cmd_handshake_tog; 
input   pe_ep_prime_cmd_tog; 
input   [3:0] pe_ep_prime_num; 
input   pe_ep_prime_rx_tx; 
input   [10:0] pe_ep_prime_max_pkt_len; 
input   pe_ep_stream_disable; 
input   [3:0] pe_tx_tag; 
input   [15:0] pe_tx_data; 
input   [15:0] pe_tx_empty; 
output   pe_tx_idle; 
output   [15:0] pe_tx_flush; 
output   pe_tx_rd; 
output   [3:0] pe_tx_ep; 
output   [3:0] pe_tx_ep_early; 
output   pe_tx_early_val; 
output   [3:0] pe_rx_tag; 
output   [15:0] pe_rx_data; 
input   pe_rx_full; 
output   pe_rx_wr; 
input   portctrl_bus_reset; //  to tell uP there has been a bus reset (device only)
input   portctrl_suspend; //  port has detected suspend (device only)
input   portctrl_clk_valid; //  30Mhz clock enable
input   portctrl_test_pkt; //  tells pe to send test packet
input   portctrl_test_se0_nak; //  tells pe to test_se0_nak
output   portctrl_force_bit_stuff; //  indicate to pc to enable bit stuff err generation
output   portctrl_pe_busy; //  indicate to pc that a transaction is in progress
input   [1:0] portctrl_speed_sel; //  port speed to properly generate handshakes (device only)
input   portctrl_rx_err; //  Bit Stuff or other err
input   [2:0] portctrl_rx_valid_b; //  Byte Info of PC rx data
input   [15:0] portctrl_rx_data; 
input   portctrl_tx_ready; 
input   portctrl_tx_done; //  PC has no buffered data
output   [1:0] portctrl_tx_valid_b; //  Byte Info to PC
output   portctrl_tx_valid_early; //  Byte Info to PC
output   portctrl_tx_valid_last; //  Byte Info to PC
output   [15:0] portctrl_tx_data; 
input   portctrl_bto; //  PC has no buffered data
input   portctrl_flow_en; 
output   timebase_1us_tog; 
output   timebase_125us_tog; 
output   vframe; 
`protected

    MTI!#^7_o=vwGaaO@wCak\#!@@5Zp[~jCu7\e""|B|rK3zSI@|lJ7k7ZR*sW'Q[+m{uC$vl9w5]+
    I<;m7^*+XBG>\JR[LC$+<'5v*r@*TxTu7E5Gu+x,H~OpzRHW'D3Y_]{j1;vBl<R5V*_|m>zDTIuO
    o\'X=<C}ZsR1f+jB1$DOsTX1i_c/,+e\q8-O^Q6{{'=l5AGNsksY?TD1_Rv71rI?K1n^(i>Yn-a3
    \sR>1s_}fS\[~Y-X$\mG*nj!OAu=QaD5w,mCa7r_J5&#Y#UvrYIVRIij_*k}j_TJ1=[wzu]mv}3d
    _RdaA~]D/D\]?7WE;W[!C1,@J}{EmKU!BQR?wrxr**CJ!-XoH=7VTmvYBv~r*<r=~D-*Q[U{BCW{
    W],HuU[p@sCZXSfn*ejpgm,^HV7;a^xa_*e!>u[z}>]KG,WQuOoVe,1*+oyX}vHva5zQzwW'[{lX
    T[#*i|lD\]>j-v4O_aCI;$BIAppVw5mWDO$Xzu$,Uo_pj-eB']YydodI^JG^{_5?NHBjCWaID[YH
    1FBXS#zG{&l*r5w{G}P~BUkel+-qi,2=2R-}=pu'&s=S<-u^-Rne!r?CHwR?Vn2Q=#!Vl^e-.SV,
    lvEBs1wV\3Z-n=rroCUr+KK>sud2IU!$}mnIE!l<eU}B-Jo6~*1YOmInETT7RH>WImQuI@we_ZW[
    5DzipBaXjRkRIZ}Y'TJBGG_U,_sXrX>vaE5U%'zsWWCswYrrK|>_xoRm;3Ilk2plk+'_kA$3TV#$
    -Uar=nYr~;}YVI2j~JZ+lp%CX_J^xrzI[l}n{aB<B\a%,k!a*mx5EU<ElE7W{CEs),Iw*n>!XKjW
    CTT<=jlAW^oBwRK&Xjx*ovUX!V}k=j~B'T<j;1j#&Npun<VmCKI'R7X^ImA+a7^n\QBW=a<UB-#^
    K{\,z-=xzp:[15lQmCl2o!uvuVsr=,C2]e<U+RkeZCTs*!HSU5m<UEO\6*;[i~\IEj~^$oU]Ow+$
    ]ZxppIx#\2EVR<qo2IetlI<aVsCY5UIC+7p~g*j>DrkVO3x'<Qsr_#Cr>oVs77xeUA1?Gp[^7ba$
    Y#O;=175Q*lC[T1J}=03,iGs~X^,1R\aa+~;]+E',mACn1iyJEu*1a7G^uwu17DaWw-n5#=xW7'-
    aY$ulVi+uvW\Wl~o[e_;73O3-7RZ;\VI[mp\sDXQk,pm?vD$T*On3TaGG;wk}HK#3rL*n51,]PmB
    !+['pT=7vr_?}vj;;5V,Yw4;t/c<OZ]D'K-Oip^jkIUx7H#z?ojzW'K|[@CVrVpQ7#o!0>A=-BDm
    ?Ym*-3*R70_'mXWTWT,\Wros1D1{~[zuvzxKoX~^[uDij2nE>'PqqHC%?GZw;7>[DTJZ7-!l$JJ~
    Cg@wl]}D1^pUI*%~'u*}G{+,;KW$jpOeE<K*QW,esuA'uJpnXIus-eO7#1ZVTK_J<O;p@[B:2>w$
    5=1sYrZ<]x$v(n}{EWY2U{9_U_B\?_$lwlAivC~?al]$OiB7+Kv#HRiowno^mjiqB*2aJCvi6Ci^
    w^nlj#osoRra;3QE3BH5C#>sZaaG]BT3Cew>er,iw,m++Xo=OG{n[{w*Q@5m-BJZQi5-X=ElY^-7
    ;r[IE522nT^mpZl$YH$X\1[FH$H@k[O?Bi5O=!Em'G5obUUXlCsiG*mYIQoi^$~[r0sJZOVv2\A_
    #$4%zS~{T5Qe5i7~{]I1ejWB-HRUenVRY<ABHWxk+=ojIueiB#|D;A~$pJ2k5VxRQ,[$QIa_U1^i
    rV_JT+$}AU+eA]QC\J$8,pWeOQCKLW7@QiVcC;mnC1$i%<n2pY*J1#v>IcuA>e\U=_E}?mBVsp4;
    II}1m[egs\YpIr=z[Ex}2R!{rUGp:*9arT>kr~@xi5e1,B??7<v$g?xsEnoBu+zIpIVWKV7>s,@^
    p*Vi]Cj\K2,+'zaBozXzG^H+ADiW*D2{GG[HoSJE-*O\\m~1j+ToJ<T>AV)D=HJMrxiZH\+vUG*U
    9h/\,VuqO$xU~G\pVe}5wD5^<RoO\Z!Keov,,jKT5OmvMXOH}7_V7<TK*^_1#EJ{p@HROv;o^a$o
    Tm=?YCz3{*zKA*K5II21@3+3^~>lBH=}aI<xZJ<KT-G7pHQk#U+BKKY{Dr^+VBK]$OO^Z]_OG,1@
    {rHe=rzGrQQ;rp^Q@]uXDD+R[VKD}^@V#Y+np/W1=H'!R{_BspwE;#U<\IVR7Us3Qp}ZOwD_+GNK
    VTo*}DG-Gs'H,,2s*}}Bz[WkO\kl!-s2,-nJGGGIA_-()T_sDRBQrXEXT[,oa+XCvVeXOv3prm1^
    1$5-]_pGuHE2]nG!TJRZa\c3x$Vo[lu7?UEO.osz$ilVRv=jaT'AX_V{s0KE+2H_urw_vHx;7}F'
    W{5Jj[=B+'[U}wr,<WE5leT7slCBrvR0KE{5,]s<lvp]d+<-@M37jD.wpJJjuY[v5>z-]jE$lZ?\
    nlZ'}D_~='pOZH@J|]=mY$2~],QG}'oJ<9#**z\a>e]2eJC-w\C#V*vrvG+Y>~#7CwaA3>,2C1~G
    sT:hAln}w*W{w\}X*3a5e>+-zJu[_dy9p-Cm@>o>iRYWeURpBiPeQU_r$e!EVY\j.[p}Clw<^Ml7
    }V@vO1*1$nw<rvIK]@-_V^9e'OEIv!W!<T}E+nE*H[Ev{$wmj-7,xa1jC+U%;17X=eY~sDv^rA,o
    }xpajkEE3an}7Z{O[om=>{x$R5aKTI{>5xzGqio_OsIi@ETswu\Z]zEO<oHA>_7*3(v+<J,[!>jG
    #T__j2BBTax=\u>GV$sjDUo,zl5Y<@+lI;{a$Yz{{A(mQ;?o@\$RpVD7[*+l;T*s2_z$ep3{U,EP
    {{17pK*G{xB$O;_^zY{KX[aom\QEC>7{,iazr,m-ZoJv<o'Rpx!VOa^jBOO==\on3A\rrDIz$wu^
    jG>^AE<$m\pIb^5^$9pa{Z2[@aAXoO#]*{*JGGx/3'\svX{@K*JpRl}VLZs+Om]]5&4O-T};^De>
    Bn<z_p?e\\n{*\2s_'*QTulBnoeBE{7{Ijw!Q23]'#]OzwMyOsm]++HkG#]~_;}u>piu1*-Q@+,O
    o$3xzA1Y,iesQQ!B>I!@qUQrG;B}-&o,T]4jj1]3-Y}n5QoEVEZmeExID*pI|PnrOumB;{^m}V#'
    \T_sl]jHHV}?^E^[ivD;~fBp[~Azakru*>]Yo,z5ZHODo[^K@VP^2@#7,l<-O[Y<<G'I#I5[B@OB
    $A*DuA@&]_{A=CD*ZsUlRG{RPD#\@;R,w(p}~O&7ZjiGJ7QSY>T?A-Enk[_@GV3WnD}D_#v]s^Q]
    ~<XBd3\*H7,uAxYI#,uA!Y3~*QV[s5j]i!A1RaU_mE$A#ioY3UQQ$^Z+=xW!_XTe@,d)T$-u;r{_
    0{*YJjOJz|$C7-5?vo}QIipr~;#[*=r!e]\w'k$!n2lwj@m]Us,*Xm?D{C:HaU?IDWHFYxEx"Cvw
    z@YKZKCE+ma,KG#HxI$v\ap]\l5{<{XC=9^'}+AaZuw'W7~o\Zs]IoA5w]mTnKlU\onp-3Y@oC2,
    r[OCu_cv2T+ZvZ3+pzp\HawIEH~!*<C>e?ev'wEu1o@@{,Q|@H<eWLBApX$2_UY1m-W'@AWA'2<E
    _R(i]}G=r73}-*}OwB_a]G}*}!A~[53^]J1s32}P|v2UxkQ1p^D{be]_]"-_zR;17z3rZ[K7aB1K
    [<pX!s1?O}d3n+OZG#!W\A=E?I#IV<[+weQ7n+Zl,7BG;v,?{;s1xHVQ<pE^KGpSajK@r1;$vVje
    2Re[EGYnTY}2xu_BGVxf%qKs-[t{zAvUsu$>{nk[/'{ZnB>'+
`endprotected
endmodule // module vusb_hs_pe_dev

