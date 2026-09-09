/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_dma_dev_bvci.vhdl
-- Date Created: Thu Dec 21 22:43:17 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_dma_dev_bvci.vhdl $                                                    
//  Author        : $Author: hhsilva $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//               Vusb_Hs dma engine.  Top level structure.
// 
//    This block is a purely a structure level design to connect the following
//    DMA sub-designs:
// 
//      vusb_hs_dma_up_int : Containts DMA specific microprocessor interface
//                           registers.  This register file block is a slave to the
//                           master BVCI/AMBA microprocessor interface  one level up.
// 
//      vusb_hs_dma_traf   : Moves packet data through the memory arbitor
//                           in bursts of configurable size.
//                           
//      vusb_hs_dma_mem_arb : Data path arbitration & BVCI/AMBA bus master state machine.
//                            Communicates to RX,TX Controller and generates BVCI/AMBA
//                            bus master signalling.
// 
//      vusb_hs_dma_context : Context storage for data structurambae.
// 
//      vusb_hs_dma_dev : Master device controller state machine. **
//         ** Not provided to host-only customers
//      vusb_hs_dma_hst : Master host controller state machine. **
//         ** Not provided to device-only customers.
// 
//   Block Diagram:
//     See internal engineering specification.
// 
//   External Interface Specifications:
//     See internal engineering specification.
// 
//   Internal Interface Specifications:
//     See signal defintions below (signal groups represent
//     the  block-level interfaces).
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
//  $Date: 2006-10-03 13:51:19 +0100 (Tue, 03 Oct 2006) $                                                                       
//  $Revision: 339 $                                                                   
module vusb_hs_dma_dev_bvci (clk,
   rst_local,
   rst_local_a,
   i_cmdack,
   i_cmdval,
   i_address,
   i_be,
   i_cmd,
   i_wdata,
   i_eop,
   i_rspack,
   i_rspval,
   i_rdata,
   i_reop,
   i_typeinfo,
   i_xtra_in,
   i_xtra_out,
   dma_up_addr,
   dma_up_datard,
   dma_up_datawr,
   dma_up_wr,
   dma_up_ahbbrst,
   dma_up_async_adv_irq,
   dma_up_frame_roll_irq,
   dma_up_usb_err_irq,
   dma_up_usb_gen_irq,
   dma_up_sys_err_irq,
   dma_up_run,
   dma_up_endian,
   up_rx_burst,
   up_tx_burst,
   dma_ep_prime_num,
   dma_ep_prime_rx_tx,
   dma_ep_prime_max_pkt_len,
   dma_ep_prime_cmd,
   dma_ep_prime_cmd_tog,
   dma_ep_prime_cmd_handshake_tog,
   dma_ep_prime_cmd_complete_tog,
   dma_ep_prime_cmd_fail_tog,
   dma_ep_stream_disable,
   dma_tx_tag_wr,
   dma_tx_data_wr,
   dma_tx_full,
   dma_tx_mark_down1,
   dma_tx_mark_down2,
   dma_tx_wr,
   dma_tx_ep,
   dma_rx_tag,
   dma_rx_data,
   dma_rx_empty,
   dma_rx_empty_ctrl,
   dma_rx_mark_up1,
   dma_rx_mark_up2,
   dma_rx_burst_est,
   dma_rx_rd);
parameter eptx = 2'b 10;
parameter eptxa = 1'b 1;
parameter eprx = 2'b 10;
parameter eprxa = 1'b 1;

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   clk; //  system clock
input   rst_local; //  synchronous reset input
input   rst_local_a; //  asynchronous reset input
input   i_cmdack; 
output   i_cmdval; 
output   [31:0] i_address; 
output   [3:0] i_be; 
output   [1:0] i_cmd; 
output   [31:0] i_wdata; 
output   i_eop; 
output   i_rspack; 
input   i_rspval; 
input   [31:0] i_rdata; 
input   i_reop; 
output   [BUS_TYPE_INFO_WIDTH - 1:0] i_typeinfo; 
input   [15:0] i_xtra_in; 
output   [15:0] i_xtra_out; 
input   [8:2] dma_up_addr; 
output   [31:0] dma_up_datard; 
input   [31:0] dma_up_datawr; 
input   [3:0] dma_up_wr; 
output   [2:0] dma_up_ahbbrst; 
output   dma_up_async_adv_irq; 
output   dma_up_frame_roll_irq; 
output   dma_up_usb_err_irq; 
output   dma_up_usb_gen_irq; 
output   dma_up_sys_err_irq; 
input   dma_up_run; 
input   dma_up_endian; 
input   [MEM_BURST_LEN_CNT_WIDTH_WORD - 1:0] up_rx_burst; 
input   [MEM_BURST_LEN_CNT_WIDTH_WORD - 1:0] up_tx_burst; 
output   [3:0] dma_ep_prime_num; 
output   dma_ep_prime_rx_tx; 
output   [10:0] dma_ep_prime_max_pkt_len; 
output   [2:0] dma_ep_prime_cmd; 
output   dma_ep_prime_cmd_tog; 
input   dma_ep_prime_cmd_handshake_tog; 
input   dma_ep_prime_cmd_complete_tog; 
input   dma_ep_prime_cmd_fail_tog; 
output   dma_ep_stream_disable; 
output   [3:0] dma_tx_tag_wr; 
output   [31:0] dma_tx_data_wr; 
input   [15:0] dma_tx_full; 
input   [15:0] dma_tx_mark_down1; 
input   [15:0] dma_tx_mark_down2; 
output   dma_tx_wr; 
output   [3:0] dma_tx_ep; 
input   [3:0] dma_rx_tag; 
input   [31:0] dma_rx_data; 
input   dma_rx_empty; 
input   dma_rx_empty_ctrl; 
input   dma_rx_mark_up1; 
input   dma_rx_mark_up2; 
input   [6:0] dma_rx_burst_est; 
output   dma_rx_rd; 
`protected

    MTI!#1XHpD-{V+UvWCT\n!GKsH-5AFnnTK\khNo@[[Lo~U7kUs[rKZ\r7Q;_uvu>7v;IxOX,o}WZ
    r8-XQ[,x}]^+[el9_A$O,n-<~57TDC{J7E@r$+7np_j$WVTBQ?CXNI5Ej5]Bw][~~7C5XI@m;EWB
    *Yh-7!Gx@uYo}ZIeAsO/K]kOHGZu1muIFL_{TJvT3xbjtIvA_J5AQ,=s3UYk}oHGiaT\~3*<{3_#
    nQ,eDj}X=!rZC=jkT{>X#<7l=xT<B*W-<,V@_3+YR!<[azK<'zU}oaA1HO-nsUT!J_*!]W{TBDW;
    eVuKe${rXrVA-KOVn}]-j,>O{@<3!z'>R?{Q]3C\#>q*Gzn:xm!xjl#\B-mmz~jT#_;$#1X,eVaw
    NVw_pPD*-e4%j1WG+O7~^YI$S+I-]W]$p]+JZ,G5jD@o$AUsi7>'@!r{lxz^k=DH[o@v^1U~_5el
    o2UxQ~Tgal>RInJe-$iuH-~#Ip7AR^J@pVqkv+#2,XK$O[eY_;$?}!uBJ=_BBXkm7Aauw@A\>wad
    g-X,vv\#Z2EY-Do='*kzJ@Tj;lNG[po][HKH-AzC<Jk}#{#l}1?iUXl>skZ@zWAjH-K#A_=l.vHI
    I_1#ITwp_lG#!zC[O'iR~$[O#LAOvE_uZ7IWE>n_^BB9YvAw^p->C1nX#*e?R?'kEZVQa[<~!C\r
    N!AD]@\l?o-{lixxoo}XT__KTs-,K]UeBY_2zQmu']']W;>T!<G!u{TYGG9W--Z*SEsl@p_<xCDH
    ,iBk,[mm_VHY<~rZ1!E\J+\p!YQKVXHj't*TEn73'#A,A3WD\$\7Dsazm?M<=s{u^k<vVKTWa-!*
    n~sO<DOv~uol2eC|I\2n7ls3n'nxG?o*x1CmEz{I'u'2u=k{]kIulJ3~B;exQpz}<{$D$5#[{QkB
    gkv=>d}pR7oY=]!OmAOj$JA=HWBe5l2]e~J}{I312K7?+<^O+<#>'EBJX!.ZOQnZ$I5e;]IroomI
    5W,cJxJZ$pKo$[W^V^rAdU,A\5}ViR2+]{Y25T7m$=aT2^!JTn-~nF'5#,mol[[Y>U'pwBpJsH#(
    zIVGhOml?/?N7HQk+1zG[W@-z\V5>Be;V'\w2[xvo}#7V!CAK=@OZx7@cx<C^SxzV!N$w<Ds?KH)
    I_2[}U!WXn+B/cr}UJu17Wj3!?dBZQO\jQB#SB-HmI$pszJlAYw,Ug(loeD5_RWv*\1$nv+;7G^W
    ^DuDv*k_!XX^U2VpKmC=~ekU[zJQ^^]KAAU1^1mPK*$D*2$npjXjSKnXr[;''+O^!wwUWkwJ_3$k
    ].T<~J*K<E~}nE2*5DZIJ3aQ-=xu+7uXE@iCV7vEx]FFX5pJlX53>+W[J\nEEoHJO3$?G1?\rexU
    lUHOn'+1G#o@TG*Gj;[!B'RT!j>syviE3d2_OoZ\R;pQG=AV<,EX<=Ia>+x!nQnvvE5V\JB@$Zmo
    BuQ$K@Xa=Ug/f$D!Bo^YD[D=j12@711zUYr3uGW{54ne+{BJ,7[1[o^BJ$Z5$sB2^B^l#]iB\oG^
    >Vem@n,Wa*vHs{fLo[3uCuU$X]ET>sAK;7#oCy=BXV*kXGm<TY5wG>Qwuje*jZiCRD+V$3pAoE{E
    +@^;'p(u5E#SD#YjN<jT2S?vn>xO-o7#BEvQ[xq;*i3[DR=NM==7XE>ED=oI,;\;}1<Xm8}Ts7]\
    5GR!OUEknULRnAp>{2Xpri!O:i$kI[R]*MD=z2CokwnQ5[5uGruB@2w$u~YUKaJU<+s<o@W+j!XQ
    5~]!A{Q=I,5},V*-$U=d!T3;aITQawWIJjV\A1--p3{}xV#vmXx_aT16oEGe&"Lx{U]l-zu-5^a'
    7#VpG?llQ+^_'DZv"owJ=pAR]XGm!!<u$JTBB\Zp>sw15lrV=uVs2^wD]V^uWI$AEMslu~55EA$\
    >zmQo?sGwXVz5TRp3CDX*e@*+WeQvJmjo2'!nD*i;1*aT]\>CXRuW#Q1Y_z#lDBO}B4*_xIz_w=V
    x;Cja3@5;sm[+'XAYTI{'=2DXCWBIK{t@_l<GV22v5k$}BRzJ<eWX*3@5WAJU}K-a'kxAam3.T5[
    !_@>#'IKZ5EYYYERK>x44'RQKi+s*,i75jvZ[6iwITVE\3/UI'7Q^!TrA=2#TX5-1_w![WoZ$R[Z
    -m']WT,kYQU=xD*Q1-A;C#~\X}s^Wl>nrk^.O[s;VvsRnoV<ZH@Q\3=27=TTTCKu,n<>=}xWOeCA
    EqY'K$~vIOIXa>ABQ[T[w1nseiZzaUpv*5_Wv7<_?Ayf%%BUUDx^n5]'>Q<Ci{,\*->Qk@({DHO]
    JURD?2j5D+1[Iwm1^CE!,;DraDzK^},tCra$XEA'?'[[G3m*]YTD*G<'@^sp>aev_GpaoDEa$?[a
    OCXwZIa1ip[~m<sZn1]_uYDklY_*>nraDE>AIKURmB=\3YO5V[Z,+o#ToOvG~z7WaU,V!U1IvW_U
    7YUBEx!u(kaKwQvVisi,\m*_~;veBWBaI&vh\rQH3-WA%ZU]>vH^DJ8Ujv+w}1-(r$j@y)5k$~1x
    >AU^'Iw,;W|wjs+RHAn[GE<F[?Wm2G-7iB5D}"+AnB"Ej-@\T<_[T<]V1?1XVX*2',}I\x}B@*#Z
    7+^E55aJTeuixQ=O[*Es@,u*$~eo=O#!qvn7GxpGE_WWY$zXzu+m\<rsvvcpz@A|qsH\izz7\1-F
    @v[<Rx#=Y{[T{[]B#><mYA1XU*<Hlo#=#IBlrIepl$Cn-5,jFe}@W<H-,Wp!5ilE@fz/sTz{L7Yl
    '2^7r*VZ@+GV_gCJC<%*s[\J-~{kL=H>XQC\xj11>,23;|4RQKx=2\[U=RJn[BmjKQ3+Q?~sk!Tr
    !A@=m!uaw]_Z*U@{7a];nm3j>)q#=Dx\H!VB*eR7_E{q@wWJ*;RWv}'x,{*E&<_waV@sDv{KDeB3
    Z><_xOJJrnVAj6'Tp<lkKCR*mx,C,kP>vRV{R#?cI1I1Www,^+W?[];5Hej=O=,mlYpEGXj\Bl!G
    G]oY}[]HD2H!PTIv{EKZHL'U-!$pU~Yp3X0}C#j?'I;B5uwo-IQ9Tpj#**R1,HzvW_QlVI#o>RB<
    pI@G{zz$}Q~^e']n!C~YlXX1^y(?a]+@Tu^*5T{,BZ>uj-lG?~r*mAzr3wzV3~GB_\+swE*!as,\
    iJ@$@{o$ECnBU[es1GwGWJGzCI<:u^Rk6CHeH$XpQjx'\iX@!2^jv-wv']K~^3>zT,Q}WB+Ha}$,
    TmQ\#TXI~[[@_:wC]m}BV;7GJHE2s\'O=R;auRm]!D[OTxxJ3aV']i@r=OD;+OnTvRJr+{$Tx@w*
    \viCJ+-VOVE\\uEUmk5_xRd<jTj@]TID!\GRS2nB,U5Y]l<Qz{{G?D]G,u7TTmE\E!xluJI!O8VH
    {;|Cv<prAwu1JC$Y,l+s@$nTj[$;}T;B~HzXl}R17!]-[!Z>B#\xG<jYW1o_T*_Ly2-AKwr3o@*P
    sYp$NWa_nj]~Q=mD]C!jX05w=i[2+pW,^Tgr5i[A]RGDu^X<1pmLA\lWGwmQRk*D'@r^KXlZH}\W
    x_Kr?H\2_-KzXoj;rQX[j,!_\']^re?O\1[]CJ*7-OT'T=V7U{'Q^;wW+XKl9vHK1n*\mEk3G7H@
    GBE**C7za$x5CI$?mXX<#>^-Z[=#ZDI]T[xKe!D7x1Q'D\-\B5*Q+~{+r1OA^zMBCv}vMIVz$jO}
    r[ZZ33}*7DsO'-BKZsuu^b73}5Be3],Bu_X1ij*UBeKoIYq$v3E!UA;_XwXV{ZJB+D?;T>s>7?7I
    @<Y\$uTVAT]_p,@+aV;6wB7Geo]-YBx'8Y3~$Oj+Yv_Zx*I1CDAxrdV+<2AlIEC-Jw[FioO,'Z\X
    lHB,?-JCi=2@vuwV1amnRjW'B='2EUEv#$$wo{lK_oK'z1IYG$o]v]7GQ.g?l$rU>Y2k*5{]w]?A
    _[wU*N#,e-}7!xrrl5XY$3^{-$B,^mk,OHr#_w1?JszHq*R#a${<uDuBH[vu-11keEi\ax;W<j_v
    Ofeue@P$OZA^ceA3Uv"C2mWj2[A1[]^K,1D7Zw\2w[vQ,@U'U}_s5UYjXEa^!QD~{CmrYWUZ_j{Z
    T=o,i\]mUW-{U{nb#zY'H[v7xup1?,Q\sx1ZnVYYl-aRaEO_^,eaj!VX9tG7RUlCIiOUX<aRe=XA
    Qv%~UK3@=K_RfHUJ=dHCms$RErU]XzK$ZD==lRGITTQkuroK[7!{Q-YX5[]b;s]=s{Juz-K~';'z
    [XY}x^CUv3X1iX'WY<=k1I[Joal5NL'O{\CBn!?wZ--D<;/o!*<$+~]&75}J!aK<[x$_wo3,T'k}
    rlTRBJJv[1<n=GK??RV7qI[oG~}-W_s]]]?{^:D,[{E#@[#{[-x1s2u'~]f_<o5[J!^#Am'EWU$y
    p[<{%&ABi1?Enom5?Kc'3\pvV~Z@.4{GCs!_*m%^'E155~~Bi+^\a+O9rYO1A'RV']#[^ZVlQ#V,
    G#ZQ+*7pxXRG{^}<Cm>7xxZa'T>eDepzv7Uw2$35@+pHD_H7Q{17m$>zjBu=>BZXd5nE~U1OxGaU
    lG_vz]1#o}pZW}+C?7!-$gu}nAMlxuW}DsCV1@uTqF=XDjl~!aQV1?zlT$;nDr#=]I^jW\]$YRLv
    Enx$w$X5~I2DBA=$O}$^z#]*{rB|^[!vO\e$zRHU5@rK3Y{E"W<J-;XQ\1\e*I~$Yv2<V7[HO{OZ
    ?IZX<Z,u>',uZvXx+Os3us-BI]#zXk.k1>{ex']#-TQ)0n_[wf;]5uBpR_=@xlZ{{?7i!j|+]pra
    ,!a0QiI{asCa,z<}C*!I}'rv1jsB;1-rQVn^.{,5'v{{IHw57$s\2I1mpi[^7B@X7xBnGgeR{#s_
    K2xYY>}IYjn^^_QwR7>OsHRTAwe2$D7uXpI[=ZsG}Z]GK<Es=@a\^*>\~R^VW5VI#@QBAZ=oxX%s
    -}?HB]B@H7CD-pH|"*Om~lRxs3n+Y~anBlh]~pm\!+_eJ>7DH1r.U^'-Z5r\q3x'EfpsC2+eUBk{
    ZTxC;jHU7,B!{'Too;C1'!gBnQZ71}lyLJ\BT+YpV<pll^'}GkG,!l^]?_aUr]2pK1\7HTvWrvQG
    [w7OYnC;vxWRowz_GHCR];IKH^?H'<Y-3H$57u<7m2,TD$z#>R{DD-Y[']?;o[>Zw2-7~VQjl-5}
    w$$Tun+TD]Y@<Im<#E$aGc2,+Gr>HsQUrWHGIUzA@EZ7rBso_Q,>ZJx3''QpJ-'K=u^,l+GTvji]
    k$xApT.)mz<npyzT>,Qk,@s~5sTAnAJsY[lW-llp]OlIGT]Q*z\{]E^ma>sp7*EiuH$}@73^^-8O
    >x;TO[;7zi$rTro4'YmQQa-V^5eV$U+-Dnu;An=kRpoeW1>RV=#pIY^2ICaJ;1>IAnE2Cs$A^x2G
    7<BY!Gxp*?OZaO?Cc|-{-wKs+?frzkXZ1JD5I1CE{ojH<@;+-'n3I<CDTnlTRp7i$-lmInaI_m#T
    Ae*V<+pX}=$Kr?VmHw{$;Q>,rHn$UanwVI7zsErLI-$DrKGxf-=l@}VK+3pkHO#-BzK]HV2-lwvC
    K7Vaz@e$pAB<Zm}7;zn{jkwp~Jeie8!$wxdYJG$;a\JD\VlOW]'LE5=T^U~o?*\?Lp*K$p5+-x!;
    ?c1JJ#Zjq'V]z,2>}T[k~{aHp1?J7Pn\Y#6j}}nT<o<O^>C\<_l=@p?_sXx@U^1ns35~'lRCBxaB
    ;ODavV#5Ces5Tn1kxBwUC2\PWEzj*$}InDljmU;^84wR-7AeQuWpYH;Xnu~{u;-jRC&3Y\^:[q[*
    KlB:#D1k]~T2SRmTDo$KwGj{'j3;;^X-KDn}Y1pz-}zsG.eauR@sI$7s?YGT]}Y_HjL%vV<R>>zj
    :XeHVxix'^>E=kDT!eU[X_C7n3\paZ7;3?_Bu]3Dw*?-]ZO!R~[B{!AVvV'w}*!<o^}pnsI]B@-[
    jFHpei}z^[6earj7JXJux_!@[<W^#<p/@{1UrUaI:G?zBu,w2~RlV>}Rav#ACX1aV<a+3,umTU]m
    xlQG2x+A?5'n7ApOYB'Tp5aDII]>1Wz~=m$,Yk}CK@_sVu>{[XOr1YGU;#>YnL2aK3v{C1B^^Exs
    Xk27!C~<Y@~p,n{Hmpn_'Bspr]Qevp$WIT1xwDwYW3/<aXk*YWXLuGQ>p5TZU+5\3\i>m$H>nO$?
    CID=Qrsemn;!>EE7c<w{wO?_#G#UE=KJZL5<ViekOCaTj**p}s3_}^s=Qm_W'_+U^sq|3o#~MH5J
    ?k<7]^{DwV1EG2Om3=>7+k&3{KTAlxu~ED>$aZHe~^axdX,#<IB]z[s?XCU2WzRzBs$__ZQ!}-=s
    jir~!VD}*elpQ['l?2,IVnBls%m}AkEU;AT}};I2{}kIB<s3m5oq^}TupB+IUV;ZvP*@lKZA1Qia
    CDjB#\!vmVb,\~G{+En<+X'[5~klAT?KzC-I2{\}]I1VEn?sp$rCWJEl'j7Y^>ZHG**VnwnvWa};
    a~[R~7p]rV[AIIu^YjEx,Vu|AUT{CCQic5nT2'^}5g]B}IpXDnizZ1Aj51hw}C-[Q]_}+_nsT>@|
    -Ue3Y=*K<rkrx_TUaH!j1k+^R}}]7_IkG-KwOTJ3lO<IRK1~G<Z[o1k~Ej5ulRo<VKC~4Cdbp1!?
    ^=VHn,Ze,C=I^1_{U_EW52,vC+$pv-Am<o;>m572j8wC+r=]]]@}X'BnEH+O]Uz!{BI2e#jG^!DR
    j$ZQ}Qt!5_swUw3t^2<I'pj^H+~V3\[s<VD+IYQz~I+]Iv#z&lx*Jz}__DG$E^wm}ZE;R^}\-rpe
    '\EjT*5\uQUQs~<\<RJR}skAv@H_k@S.0N*mQ~GoWm3eCp,\{Vo!uB$5r7HB$j:m_r\=#2\7k]xK
    aHe${H[^sxi-nzO^5,lvI*{vsDKw=Aj5sCx,7vzBr}r^]-J+E@Rx2aaoe-\rZEepE3B|;}Uzs-CJ
    $3ZW3YKCBs7DE'<DvaYT<{z#qe3,2z!;K\7w\BGJ3~{IR(7zTVmoek3sBOAr!?jOro3ol-Ii3D,Y
    s+;I{}a'jZovCnZX!2|]z7z*aU3jw$CcJllD{B*wwRVs95}pK6'{E#-wTUpZY5a>XOKa!krxYH7R
    ,{G=InC+QlWe*WY5luHTXkF@}$3!lC<_<HD_2-*<pW,TD,#WHK$8^2@p[KGD}@,Ju^we'lp-?CWA
    kqY<EVgkT!*[;K\bT-<W{O*D]52D*_''@C}wr+_=Gj1z#AATZD+Q}~2GDZf\QA'?$oV)T$xY|-aJ
    [)l=jA5YzU{jY}CoXU>U{TuU+~7H{s;U!Iv[2Wn7*Q8R#maL|5r,r@sJjYo=@n_o^AojZpw'=PZU
    <$,OA]^k0)pTnR\p*C2TQ}zWAK<ToamTl36ormI[?WYr<='Wxv,AY;_JxU>tk[Ga=uo]I<lEXw*C
    *Y>5F<<3J%}~R21oC#p'#a=KYTr-ns)B~BHkH$xKAnm=ZaYTv\O\Y7JT5+!^ct]IZ^$3*j1?=p>$
    lo2}uj7vr!V=IU]u_=#$QWT-nT/KO]oI<X-uXR$~[DJVmnJI}pj4BWXV]'-_~}B{QjsRWr'Q,Zu3
    w$'-Z{~TrGTvxO!_IaC!5-E1@<QW,CZjpe2B|,r<{+7}v!GX@-l}W_5Av}m]3=Zm;9e,!wP7$,T3
    G-sX-VI!<@eK_@,p_s,lusXK[_A-UCTW_+=^'Z^m_ZZ8!5YuEe>;;,I{p5o$!<IU$z-Uq^UQrJa^
    kJ,2~}Xr<;=p*KD-Heisk%<EuaZ_!oQH[ECVpZK>*>]aD?2eCoC!HkiDB~,\W>lwVx\orB)7oHj'
    QE^Xs5*BR,lu'+?Epi!QokO^vURxV?~]Ives=]?6Q;wQmsrC_R_]ulXDG>~*V@5n]{W3[pr2ZR~@
    ?OUE2s-p<R3>}[3+?B+2G?EEGs3O4Wl^7ji$ef,[h2]v@=_@e~Y!{=ze,0ce!xomE=#dLEHU*zsN
    ~<aY]}?+S^_>5?_;737@WDmnZmT3>,#;ovK5\<=+@2pA}_Y2$5ojz<$jQXa,{1^Ri}C571zIO[Jl
    px!>WdxB}s,\7k++upru2X$_-}#O,v}>zZJ>aIiBKz<5*$F_o^rIG'DUsDA<w-O@72ONUY\Q~'~]
    <\#EI']2|^x\nY*7\1+-_<Y[sfW[Gi'n@54eCuu~O[[VJ7evz-_Z7+{rk2s>[?UKI_C7s^oDp_k?
    s+n]TABs'1>k5$AI_VeOeWYVA[A|l}*}wTZE#{epX7VxEmvC'XZ'"paQI$UQ_%vnEBWCe+Q-3!ZO
    #]f>n^vmri{zD-Z~QBCL-$}^*WTY<BQ,jlauBJ}D['BAu$B[i-Arx1Vjm5QGkaG^5'UeK\$O~EK1
    X1Km-Gvs+C_rw-CDf*!;2\>^vrywrjr+H!Wz^!KuH*im[R3-HoI#salE7R\=uaKHrXY[=VezU1Oo
    Wa+KBpKp*_5A5$*U{K*x^D3e^eJxAwwe|-\1DQC3WqgxWjWnQ*X)e~UR!}[Z[&FgKxven]?sen^>
    G]A1&R!1zeY@viB{*[pDpCz~7G;^}0n>!sb_pD\1E^Gp><]7#W?YwhKo,'sks;jG!+v{X5c'RGp,
    >&7_=Y3weB?Q*=swlsax{j)-[pQi}Q5Y|-_><I'W~kq'sp}taQYawArW6k=R3#-W15,(i]!@v*BR
    $YI>z[,rN$|[vX!eR+2YXva74XDQranCI2lsA<55pm'53XoT~;Ekk'Zr7rDo?XwAT;1j~Jjpe7Vp
    k~vKm',+ZAn(}p1Yun~$*j;5l}=^~{!uDZEi$]lHuj*Z^@!}pY3Y$ErZyZ7V=&GOKAYa3ZAnEp"o
    C3o=Z,5R_C5,xaTm$}$<o~7@jzo[JBswO!p]aD_szx7B!U=IQ2EpnB~UA^vr2zeGZ7Z3}UlV+BkV
    ']Z<pK-}O]iD5'pxW!?^Zaj=!Z-h[A>3\Rj,O}KJWrsDkQR~?Eiv?*@T=*z,~*z@preAr1E!|znI
    37!QE,VG5w{~<&I~w=izoW*C=XmE\HI+vG^<1^tRx+nXBC[{=7?QCwGe-sK[#=Eo_]D0<[{Kj25_
    eZG_{wGZrA}JRas!4B[1i]@G'"Me3vQ=K'\c(*+_[1knW~aY2<]U}l@[Ui'J}QX-H6KYHooZDU',
    +?O{B!@UXn^*3D{aV$Vk;K2=<v}j?a}YzYj!nz,Ia52=l$-Dw3*r}-_2jZv1>=.[l_p~X!^1sO-J
    S*7+oC[#G7Yz+.'ookx8C}}G{<Z!RbjOwG5#3u{X{Y[II?RArD#a$-sol][!QQ'_V~o#XEjnmz(a
    HH'1*T;yj]?WrC^\{{lpG+KIA$}[pu+EMjR{WunpZr7k@.\8*_nW7o^uaRia1\<#ggu=A1vpwAS{
    Q+~W\D}q#,wrIHJx]jiTD-R~kYH3nU+=U5u=J5T=es~'F9k\[[]z;llO-{'QDoC_uW9?{RWx@Ol^
    JD-=x~aEV>5Il'IR2,3iQ,#vQrH'3E3szOWTOQIx*X}8es<H_iY,tQZweT<nr_QXsojzla5_xO5B
    \7o(QwpeBEzaBR,+I\-G{r#R\7xu=W+=L$Ekj_aG>oJ=v7\1#2X$-q~sVQZrOCOvGAz\zE>C1+7z
    1DVV2n,,;IzH3$p,;,\JI^s@xDHemng_HQvKAJI1_x>5!AHLAz,2vQQuu_}+<HCBI7!3V[GE+H]*
    oTnz2]{I3CHI3+B2+7musrY*krE\rTOi{${{\RmYCV$UIR{1XE+aE[{Y*!EWj3ZT7?j3OeekVaZ@
    erKvZ{=$d!=}Z>wrX/];oGI>CORiVn=ZXo5Y{Q#I;+aAX!Rl-+TpBl'*7*RcJ_~?j<p~Z++T+Cum
    !ojEoP<,ZJ]XGxmxVjj@}a=ojp<Clm?s5BeE<woZU*3R1BGQxIWe!3~Y+]]s[Y-C$IUHwuvx2m\s
    m<zmw5~TQ['uV;;r5>~nKKr'Bl=Wa^V\YwIKToC;CBn7eQG?}#>e~uBQ^w4j7aR~'Cols{3Hx>]1
    JOCao@x^soXH}+jwEeT|1#Xj|+BQ]ZUrD5FW<1;ZwA54OwC=r~,2,Vl>+G}$rvJ+Y]\oA{ekV;+-
    ~1R{fqF@=I!BEQvur-!B=JQ{*sH{QCi%j}\<++,]~DWOg*ee^HA3~4-AW?p<]wBVepX,1uzilQI3
    Z[aOGn;r}HpjORHzu__,vT97V*~}ZIs54I_;7s:71i]2H\nHX52
`endprotected
endmodule // module vusb_hs_dma_dev_bvci

