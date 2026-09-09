/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_dma_context.vhdl
-- Date Created: Thu Dec 21 22:42:57 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_dma_context.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//              Vusb_Hs dma context storage & update logic.
// 
//    This block provides storage and loading, storage, and modification of the
//    various data structures needed for the Device and Host EHCI protocols.
//    The set of registers contained in this block form and aggregate that
//    can hold and operate on any of the following data stucture elements:
// 
//      dQH, dTD (device)
//      QH, qTD, iTD, siTD, Link pointer (host)
// 
//    Loading and storage of the data stuctures is commanded to this block
//    via the operational context "go" bus.  This is controlled from the
//    host or device controller.
// 
//    This block contains an update logic to set/clear flags and load
//    new values into the various registers as commanded by the host/device
//    controller.  The updates are commanded via the update bus and performed within
//    this block to provide all the necessary field manipulations required
//    in the operational behaviors described by the reference manual and EHCI specification.
// 
//    In addition, this block also contains an compare ALU to check the byte
//    count against the maximum packet size so that the the host/device controllers
//    properly decimate the transfer into packet(s) and detect End-Of-Transfer.
// 
//  Register Definition:
//    See reference manual, internal engineering specification, and EHCI specification.
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
module vusb_hs_dma_context (clk,
   rst_local,
   rst_local_a,
   dma_up_host_mode,
   dma_up_list_base,
   dma_up_plist_base,
   dma_up_frame_list_size,
   op_context_ioc,
   op_context_ios,
   hst_tt_hub_addr,
   dma_rx_data,
   mem_read_data,
   mem_done,
   mem_ack_sub,
   op_context_active,
   op_context_halted,
   op_context_babble,
   op_context_buf_err,
   op_context_trans_err,
   op_context_selcur_tail,
   op_context_next_tail,
   op_context_link_tail,
   op_context_link_type,
   op_context_hor_link_ptr,
   op_context_mult,
   op_context_mult_cnt,
   op_context_zlt,
   op_context_head_rec_flg,
   op_context_dev_endpt,
   op_context_dev_address,
   op_context_port_num,
   op_context_hub_addr,
   op_context_data_toggle,
   op_context_pid,
   op_context_ctrl_endpt_flg,
   op_context_nak_reload,
   op_context_nak_cnt,
   op_context_uframe_smask,
   op_context_uframe_cmask,
   op_context_cprog_mask,
   op_context_ping_state,
   op_context_split_state,
   op_context_endpt_speed,
   op_context_tp,
   op_context_inactivate,
   op_context_anext_tail,
   op_context_comp_bytes_mpl,
   op_context_comp_bytes_zero,
   op_context_comp_3packet,
   op_context_comp_mpl_cnt,
   op_context_comp_zero_cnt,
   op_context_comp_frametag,
   hst_op_context_go,
   hst_op_context_go_type,
   hst_op_context_go_done,
   hst_op_context_go_burst,
   hst_op_context_go_offset,
   hst_op_context_frametag,
   hst_op_context_subtract_arg_a_sel,
   hst_op_context_subtract_arg_b_sel,
   hst_op_context_tt_sel,
   hst_op_context_update,
   hst_op_context_update_set_ping,
   hst_op_context_update_clr_ping,
   hst_op_context_update_clr_split,
   hst_op_context_update_set_cerr,
   hst_op_context_update_dec_nak,
   hst_op_context_update_rl_nak,
   hst_op_context_c_err,
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
   op_context_bus_req,
   op_context_bus_req_typeinfo,
   op_context_bus_gnt,
   op_context_bus_addr,
   op_context_bus_burst,
   op_context_bus_data,
   op_context_buf_cur,
   op_context_buf_fut,
   op_context_buf_offset,
   op_context_bytes,
   op_context_sbytes,
   op_context_mpl,
   traf_context_buf_sel,
   traf_context_cnt_act,
   traf_tt_context_buf_sel,
   traf_tt_context_cnt_act);
parameter usage = 1'b 0;

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   clk; //  system clock
input   rst_local; //  synchronous reset input
input   rst_local_a; //  asynchronous reset input
input   dma_up_host_mode; 
input   [31:5] dma_up_list_base; 
input   [31:12] dma_up_plist_base; 
input   [2:0] dma_up_frame_list_size; 
output   op_context_ioc; 
output   op_context_ios; 
input   [6:0] hst_tt_hub_addr; 
input   [31:0] dma_rx_data; 
input   [31:0] mem_read_data; 
input   mem_done; 
input   mem_ack_sub; 
output   op_context_active; 
output   op_context_halted; 
output   op_context_babble; 
output   op_context_buf_err; 
output   op_context_trans_err; 
output   op_context_selcur_tail; 
output   op_context_next_tail; 
output   op_context_link_tail; 
output   [1:0] op_context_link_type; 
output   [31:5] op_context_hor_link_ptr; 
output   [1:0] op_context_mult; 
output   [1:0] op_context_mult_cnt; 
output   op_context_zlt; 
output   op_context_head_rec_flg; 
output   [3:0] op_context_dev_endpt; 
output   [6:0] op_context_dev_address; 
output   [6:0] op_context_port_num; 
output   [6:0] op_context_hub_addr; 
output   op_context_data_toggle; 
output   [1:0] op_context_pid; 
output   op_context_ctrl_endpt_flg; 
output   [3:0] op_context_nak_reload; 
output   [3:0] op_context_nak_cnt; 
output   [7:0] op_context_uframe_smask; 
output   [7:0] op_context_uframe_cmask; 
output   [7:0] op_context_cprog_mask; 
output   op_context_ping_state; 
output   op_context_split_state; 
output   [1:0] op_context_endpt_speed; 
output   [1:0] op_context_tp; 
output   op_context_inactivate; 
output   op_context_anext_tail; 
output   op_context_comp_bytes_mpl; 
output   op_context_comp_bytes_zero; 
output   op_context_comp_3packet; 
output   op_context_comp_mpl_cnt; 
output   op_context_comp_zero_cnt; 
output   op_context_comp_frametag; 
input   hst_op_context_go; //  start read/write operation
input   [2:0] hst_op_context_go_type; 
output   hst_op_context_go_done; //  context load/store complete
input   [6:2] hst_op_context_go_burst; 
input   [6:2] hst_op_context_go_offset; 
input   [13:0] hst_op_context_frametag; 
input   hst_op_context_subtract_arg_a_sel; 
input   hst_op_context_subtract_arg_b_sel; 
input   hst_op_context_tt_sel; 
input   [4:0] hst_op_context_update; 
input   hst_op_context_update_set_ping; 
input   hst_op_context_update_clr_ping; 
input   hst_op_context_update_clr_split; 
input   hst_op_context_update_set_cerr; 
input   hst_op_context_update_dec_nak; 
input   hst_op_context_update_rl_nak; 
output   [1:0] hst_op_context_c_err; 
input   dev_op_context_go; //  start read/write operation
input   [2:0] dev_op_context_go_type; 
output   dev_op_context_go_done; //  context load/store complete
input   [6:2] dev_op_context_go_burst; 
input   [6:2] dev_op_context_go_offset; 
input   dev_op_context_subtract_arg_b_sel; 
input   [3:0] dev_op_context_update; 
input   [3:0] dev_op_context_update_ep; 
input   dev_op_context_update_rx_tx; 
input   dev_op_context_update_rx_overflow; 
input   dev_op_context_update_eop_status; 
input   [10:0] dev_op_context_update_frame_num; 
output   [2:0] op_context_bus_req; 
output   [BUS_TYPE_INFO_WIDTH - 1:0] op_context_bus_req_typeinfo; 
input   op_context_bus_gnt; 
output   [31:2] op_context_bus_addr; 
output   [6:2] op_context_bus_burst; 
output   [31:0] op_context_bus_data; 
output   [31:12] op_context_buf_cur; 
output   [31:12] op_context_buf_fut; 
output   [11:0] op_context_buf_offset; 
output   [14:0] op_context_bytes; 
output   [6:0] op_context_sbytes; 
output   [10:0] op_context_mpl; 
input   traf_context_buf_sel; 
input   [10:0] traf_context_cnt_act; 
input   traf_tt_context_buf_sel; 
input   [10:0] traf_tt_context_cnt_act; 
`protected

    MTI!#Uswojx+25,rB5!+@D7K5xB5AFnnTKr!}iNoHT[H|]?!~,,YQ}AD,?5R@$CUCe~CU%=m;#u,
    WxAvAEOWA,2YV^R&I#WzOvR!$O{n+e2TU77?==sXK'q5k[[\#@e?5v-?oz1&^}2aUEBoQQ*D~nep
    0T}+G~[TzVHE[^p^UpuI}[D8[xJuDar5ImDoG}2}[jAXTa!li{B~1C-l^sTuZ<Ix7C>$Z]+z0^Hn
    1MY+AkBZ^js2Op[A!=.;EOZu1QaST^m?II2^^2<,VImj{\<~;$+r557>#Oj,($Xa,OJE]zJV?VZ_
    1b/_BB>$j$ln{][=J*O}Ynk^GXZp3Y7Es_lWO'ra*@21o<,[xxQemTu<=Y1/OBV_Ha*^CETH*xnz
    G*$};$^~\sUT8]7H2T}=pVYe5^nw*&#X;!HX-}W_AuPjO'ltYKlJOx^CaIl{GH-?YzmvZTeDm{~\
    NCUmJ\T@k>+KAv2axZQBHKrCQ3QYK\oZ{KHvuV{3[rU^r=l~Upj@?I2Gn{\HrQx+{Yas7$,jD>RY
    GA$I+GQ=CFC5HY7oVG*ED<#<75o,?We2TzEHrZlQ7r]uI!7xRXxx32J+V_YCK7HAWU_K]Tu+x}Uv
    i!H_<V~^<+C[eQN+V27H-$kOH_3;Ev<9q@U]wGJRp$aV=;7l~K]x~fC3xoRo-p2V5lQ5-O-UE'6c
    ^Tl@oC{^T5B]D7TO}jl2}H$o'J,Jr@K>Bu>#]~mB\*OkvhTo[*RsT2n73[;[{_zg\JE5QRzJ7pO3
    jZ*r>zXVJpk'K\Yazu'5{rJDviGO<XGA{>s}x#$[I+RWxslXQZ_?jB@w$Vw\UaeY:}7mI]l+[p2K
    KSXap2UQOagFp;j!E-!G<O'$T5puv#*E><*2_O,$\1>]f\i7[?GAR**^Z?+u@GB}Gsua*~HHK||1
    xIaN*][n],v'pzJ_Bkp@@]V@vZjGnDJ2m[@Y#{KaanK@Q.RkK@(GOm]K<BBl,apzjXV:#7Jl^u[z
    l]zBapz77\luAxOkQn~sqUT}vKRRj8\Ik=Gall411VmaA+AEmD3Q-Vj1G1<Xe[mWVv'"gkTjBxk*
    v*3n*#'x@_=?=->wvzK+Ua]so\~$nl]{,5O{AJO^-r_TZ\vB#?\x<x#{I5*Yp;7oaG-;^I'QpI*X
    ^jI**sBs}+C@31#j[w]1;*JpZvmpQjOQ>?aT5Oa'TIaQ*@Ajw|fB^wpZ1>Io~wO$DZ~D9K[Z?+U<
    HAIenL;<,}g1zxG,,A{~>C$^e={OY1sRGJ7N+A[@?$$sQ+Xprmr\rk;?U$[1OT@Xb)[]mJ1{RVkE
    >u&i[lT)X}j_A]?n}k_{k}2\3IB#Q{msDQQ7CC'']r[JllJC#zK+$k]@cIOikh*;wkOsHwj!+EID
    IBm=T},@Z]UjlZYm^CW,DxpWH?TSAQ^Gs<A^vuEkE@uXwsk=UR'[wA3Z.]?={|MN9Dk]kPH*~\Q"
    O?@sSRI^ze]BYCTpp$AG^<.)$B~O7]TXje7>}!]ek7Q}nXV}^#}}isO!}w'=PV3X?WE?}kQ<]b^C
    <WQ7ZsKHlXHBD@b0CGYk'7jGpIOiDp=C#pV*8]7plMR~;a*q:EA'YR$;3QD_aZ^#<e]rK&pl,-pu
    HHv@<Y'J'#R'7koaa@}ZT,UIKXcl'?KGGRu~7Q#C+a,Qm!3lBoQn$7@]K<V=T;_i'2T>X*s!}J=v
    1J~5H{!jK>jl}#,*B?'B@=B0n<5Qz-3[=#YGb$@lV[A=$r@B>7!Q;ImnaxI>oZv_$Due]jUVne^z
    =e>G=ps1zRuZasDA,I*[IDsljf'az7UI$X<{We*wCZ)B=G~|1X]ra$^m9kr,vQ~]$:OV-V$3!=Z+
    JBEi$Vo_D;*Yja$Hzi?Qr>nU_ii'J7QsK25{,GcAekX]{lGE5=uy\^jHAVaZnB+TT$wx.a_Kz=E~
    WVB*?CEv$3C*uj#mp*[KB/vu!r[BlQ'A*2vzl'hO{1#D?GZ&m>I~=~Q,'}V{,[DpY;w_=5U#wGaw
    WjDDs*;O1E?JL]}]-@5K=x2CvC{>x@^uUC;2A:MY?rAmXC+e5keEQ;p@,<>D_jkTTKI@5^JJ<nUi
    BrGmB3[TziAj^AV-pUJk<@$$;^uAxeZUs1}rwp!B^?nIE*Af~sK1![}D}'tYJ$1[JH!NQz*[fWIp
    ~h3UAC>$<[VO-ekjp<[2r1?IeD#[B3[==nH=1l?-J7Z{B[oAx]pW7}}I{^IODAno#D2GCjKG?IB1
    @>OY7ChjV'*|KV{,xIsxkUj}Uw+al$CmH7rJ{a<jmQ@HyO=u_oowuOX=Tx@G^!U1n)\OZ}ZY^]*x
    _#*o=Jm5Y]M#=[3<VnJ^2'Y-ww!37T~z17I@CJzUXI}.Q_1v+n-E?R<rp?,3'H-no1Tv~j1#H7EY
    I?pk}IX@VX*swYxRj~WZ2[$^z~JvN$JSrpr-;$TABU]HZl$T8\7=E\QjVwU,${nJE85G{jH_@O$O
    pjyUsm#pn!?F'7E]xjp5wI*GuVDoUolT,HxoR{52I',kmUIOaeBQFKvaT;ArKt;>=m]B<1l^mX,^
    A'lI#UesBerl*}3e@-kYB?!DUur2_-'G-k1GK~C[p-1pQsPxOa]$e?3j=!Tl={Dp#eTX71GJCA@<
    E2~^_Wl2D\~\V?_Zw1Q'7i)GZw73U<}NMoa5$RuT\F.eYvW]K<EA1#^OH22I#IxX7+I@<_o[@AeY
    _;s5'3UI-<*q+7-$T_#XfW>HxI#UWl}a-VYX}KC3}75@s#{xY6r-!p]\Y+^-V^Gqd#'i\5u$i,iH
    @,3oxX<\E!$E_KI{3~{T3$WlnKCZzmT=wHUv,1v?3yS'-=xw,KX%>+WW)?+<;z_$7~nYo'B>Y7*m
    =WIWW-QW$K{p>xH]p#XRkE{=DET$T?a;E$K>{QE}'v+!+8aGA3mrnahO<m;B:H{Kj<>uvKeA{4XX
    'OzOY1!E32?p!xBCV'!B}=$l{-__>*bEK3jj7l*Z[#*prAJ7E{onoD]@Ck2-r;IB>C,!C3Y~oAe'
    mJxu<nE5+3QB\r<xUX^ennU,3l7{p$E]LH]I{7}_!w{J!/O~$V5on,n^@GH]-mv{Kp|1HHwuBX@c
    RX@a<[*B^}'Z5_A=UH2}I<1mIe5E]vE,RKbnXG\ZUoYGU-Q!ek_P>5_T_-j{0xOxn]+'rOkl$*xa
    \!lT>$5Dl\^,Ql<>R{]e\[>}iwX<we7x}Hs#ppB]pMZOZeY=YZe3JOmslUzEI,VE!zODiGOsBGoT
    Uv^+Q'SGOAk^?QY4z2T{<OBKxr^>TUDlXEz_;VGo)*kO{/URV]1;n$Qwn5pjw}_~wV>AW[_Yk3]1
    X;$~7U<Cr\'@[C~]Km~<+!eI],?vE1(]',XDWZ{r@z!bvW\TiYn,JEZJ,$5m^]G=ir*1{>2joWnx
    wAHCmH3G>-+a{sTHeul^J*!xy+5Oj7w@J+zHI%(l$CO\$G?@>{v!U$7#p<=HasYavB$9#^Wu,*j5
    W\=<sVZCl>@>ml>5JE2x}*k\{D^??BoD1x+eKI{WADpiOWQV}_s<)GnY371D!QDG'87J_~2lxE'H
    {eTDv}Uv?ID~vl'H$W1ACol]mk>p;TIcXwY+JA'jlW_e>BY<U_HWBm><IJEu*ks35afR}mULCuIr
    -5_u$7$V_^\u+TA'zQn$UrCwRoQ31V?=i<X2%IJ1=^Y}C[B><lBKaIV^KVw~VY#DBvB\E{[<'-ln
    [WY\RIYWCD@Ym]-ju$Jxpir?*L71wp'lwa@j5;O<ZIAE$=>o7sIspXHCV!.D]5pw7'i2\wOXBYZA
    plR$#B?^D'ZQVAl}Y@D$zvYEXUup3xRAzK~!R<R;$AsGXH2'^=aMpjzJH'p\p]DoiGRlz6R+G2O-
    m<[W,$~xWaU]<GUrv@5j3<)n*pUEuJrR|>^s@[zvo9'w}xYC!$'++TG#'i*R>BI#BUB<SIZe\sHG
    QGDi1HsOBBB[]mO<<T-T+^u-Ex<1}I3pi'BQW$n\Cx5]<'8IE-HA\~B$p+!#=}7g\x1i?[\Wx[V[
    $wD[rG],nR{3*lsnF[B[w[?OOQ2C]%V>{x7u-CaH<Z91A+s}_2<y97eI\{]vJUo>n#XT+BuCos=k
    J*uE#x$j7SloT]}=p2.*5[wp#}lB*z{!]G~l5=2!_WwB[z1o;~D7TU3P$*T;Ql?a;'TplaxU_wlJ
    1]TXAD*#{oJ5AU5nE#\A5W!QU><<}s[#:*irB!e=k^Wv1ce\,i!+W3O~BZSH_D^CZjO"zprnkooD
    Y>~=JTo;R<-X5[$<Va{m,ZAYp[{Eli7lI'D?}'122nxG_,_Hzn@7T=Zr?X5E$OJ,JI'raT<BG=Y]
    $]?~Nx@nR@53>x=>Wn,jQK_X+p{uOsA\^!Y,^3+]^0^DXTZ{*W'laXlBRJ\'}wTHA;j\XeAO5A$]
    D}$zT=Y[[*%xi3^A'QkIp@uLB#\Bj<rx9N-a-Z1R}xzAeAeJxIDzoT?U!U^pB;%(o0WR}nQe,;PF
    D-;{{>x@FWYX>}-*UGpR~a+[?!lwu3{]<+wsBAx[jrzB+rsnWpne]HvAK^nsr{Ej[4[i7TC2}pR@
    x\Bnxoo2Qp}\>B_Ro-lu,z*;n1$jaEJpz!d(lkO[A{m#HU-xBX\BI5oa<ek,oe#'owA]$F?-@*?p
    ?VrWRQ5mB[A[CAH^#GdY}q,Ajk,#DY_,AT6=>l=s+a2HQarB@D'GTDG!Q!D]{nYj~DjFF3AVoRz+
    ^lU\HDBKm!\X#d,?zu?*p1a[nj~.9t;B!O\Os7+R!BU-_[Tx#~\a4+oT3l5<UY^J#,\![V2zAIWB
    BWrTT3HRKW=,O[>*]1kZ,[GC=\Quexv'i&+*n>-axT$E;xST^T]jVlwaTXD^O}={<Zp~YXwu6z::
    v<Z_>IjYe,@{Uwx{$r]lp5w29-aOxvDAxsWj@DR<HIWeGd|[zJn$a*$%,w@m]RiBe~^!*-Kn)/]z
    Du\+U,i|oe>7*XW3YmARR5-'K{oazU'w}2BJ=K1XLv~xHm[^Zs@=&Unl~137ziCmkWjW~FaSYC{\
    Iw*Ic?sY'E=#~*7#I93XK~B+B$VwB7InDA>T1lQ[\1Qs2\p5*7=!IjRCo;rn*+5E*iX<r_I>-7e'
    !?x=Q@#rHwV3u}JEaXw5wJk\_e7>J7OOA_-&mD$l>9).[[UHB5FwRTp,7=KF$[?<Gv;{j~IBkHen
    *zY#VDXC2A!T:'z<xXzJl0hjHx]@+1RsO5!@zQe<C?wy\YerO+7_77mI6D{H3n$T#R]CQz!a+6CY
    K5Gp<ll{H{'1J^xVVQR#x*2aJ'$Gop<RZ}k\Xj*Owa%7Qu~lZ-^'lUCjiwn*k{l}RT~{_Y!,m3v1
    e$AK>{Q*N\}w7^YEAew-m1?wO^K^#oXvuIQ^mIT]]U,_{F<QaXRp5\"1%5u7UjBKW%IrBBLG^!]q
    (Vb;Yl~v#xnHVar[+v$]K]^q#vk2+GuocxbCr9}BJ[,{JU_[sC<<Q#3R!KHl,<EQR?VG]W9m<1Ts
    G[d{-5u#l+Y_3<^35DU#7@^o=ZErTzVR?eG}i;=^3m=w+U?'+RC$CIBzmRR'Y+@8>TKmApo[ABT@
    _@-J*-XDBV}uyRk,krIJ_^\7#vjY{w,H};}3\Q32]5<}l!X33-ex=Hv^sHa[;eopn*V\~giEQw=z
    2}BJ;mjBDp,2[^jRj_;U*;<oTJFnRx{E+;^HIO'\Lw>]ilwZAK]Gvs]i?A6#lo711B'Yx^iHsQD!
    j{2R>m~e1~o7pRigQzeo_{^OJHK<b/1B<+Y31In7?U0m,Y#6'GVm~YH*2aET3RY^D2>xwHv'jYsm
    t2_-W,O@H;^U?]-=mB{QTP2r]~joHez]<@Js>?T}m?+X7JI=5$1#BVA*D+?ICxp~CW>Iji[!<DPt
    :?l\Ban{EoTjTl~AE+'~VU^7wW}HHjO#>}i+vOW*WC>VsY+O}RZ[u=r+lVu,*CxK#Z^EajQ}AliD
    XH^T;eRrzRavw,jAmG4I'X=DvG+9}XI]7aBUoH*]$TpBr7+s=O]Ua[Ao$a7#uVH2H\!!@QFu^o*|
    i{7ao{V3rT[#L7E#>Qs*2I+_rX^xJ?XpuG]OZ;1J73nRijD}71iQezA_eriuk!nl}p~nX{1zJox-
    w}>w>;VzpcEz<W,1u3'<jr~[7I@[+>IAVl]AvIaUZY]Q'A~=#Kvde3@COIX,e_X5U}wk5[1x-<{D
    KoK<:"T1j$1G]\UQ-?IHKTXHIiC^RYYBWZJ7{WJ$DC$]vW\^Vo>r@1sn'^%RU+XHj;V\7$@VV'D7
    iC;W[Zop1poU1OCV_3@I[juYn=UQ5Io!IlU^-CCQAEG0p@TpoZo^I%;DnppwCAA5#GoYJV}!]m[E
    nQkT'e=R>5VCWu[3Q]G<}VDa-u3p?5U=3K1oZ!ZEY7e<V{UoT_[A7+GksJp_[ZO-a7Bo}{ZvaE*]
    prQv37p^CVWnz<ilux%ojelYn!G<7]^CWv[QZaU*}K{:G3,#axCaUApZsaoX)G5ppm]sU1xB2B!$
    *2EH7(F}@piQs*pvGOuXw_!sZ\KvT]<_YR^Q!G]72IKV-p7h7j3x-AjeGl,OZG3uw(u'GW*Z3,^E
    ^}LfA{BBV{w2+h@E]X,TZ7-TYB!RY;n--#'mJXnjs;mTQ?[z>pJlo?{ap*Zs'!A1=A$i7IWC=[OW
    GxD{]i>D{3G7+D}n1m:\=mYI^j@Wo~QEH!^[DE~a{5{ewj_s~xY*Md#pI,>}A3qhOB521DARzeQj
    \#s+A7pX,$oBE#K2<Dk]ZCH_kD$7fChbkQ;']R<-uIB3Z={R3w[7~AI@CQJEC~^$#UuXb'x_Ca_?
    $Oj>DIVmRz,BVx\#kRZIQ5E;n1oC1+n=XA*Hsen~=^Txu+Q>mJVOIw1+olHmRKGKe!HW?,s#]$TG
    ~vh$z+,><av5#3QN%0Nv<]i@OXs6DuTm,-X#I{QuUIJ-@-H#;z$@av^K-r$xKC-myD>v!re*C&Qa
    _Du$rji{TO,CU3x#w@@Eu3$^sm1T,XlK-]EwW2;p>k[--<yOYYZuOeo=Rmj|?n+*pZ^-JEm1:X,>
    _BXQAvYYnp!m~l}3QEXsTY~<<<BJK6^37{Q#X]8jkEGJXG#e]pupVmOrxX\35+DE+v#lz'TKO_-%
    H}U-Xz,,orY^CrTEWl;xpEer1HZGYBuCV7Nw+>j;^#BpCk^.s],lvQT+P'x>KoQEQR+{GB!*W12Q
    mZC#n5#p5TUxRKO~B(x5asKn_JAwC'Q1wQ,7j^vEVKv^*De?-QGZRIEER-_>mkf>Hmz'BDR3}?<j
    UKWtvYwa*HwV#x5lF^a5l?1{~oKDGD{AHBKj-x!7+$~_D,v-v'DJ2OD<s+zj+}Ro'+oAJD_lrN*W
    EH*>rEoa=wp>=oNE~G^7V-3QH'VHzA,Y1B"C5n@aRkHZ\J<YD]uAe_mV!j{xXr@sZm~D'QY3-7BY
    xe[1'+;^c*kD;2rA>+[@>HHoA3_7@u]=xfB^~#_#Q#\]p!D8mO#[Gy*22\XH+CTCuXWU;r?D$R+z
    OupD=!QQ{v8KY$VA_'k$'o,lT1p,DA={Hl+aUpe,OmBB21n(E@n~U{+H'5JkJB7pezD$=!-3|KxW
    Ae#o}tapWlGsA>GJQkbk_@#vNYmeV!QY=;e7Osmmavw5OT>{'n^=j'Ze~^Oi[RZ+I]KR7{]2[%eQ
    n!9anmJ+U\mz<z,2jr#,UDHr7}Gs}n[Ta=e2D\TAzpJwx31w-}xln^}ZxkQ$Zm@>S5C_O#>X57RZ
    aszT<\+C=R![T{AzCvV+-{{+l~\G<>B;oU'*3JI2s*xD]sBluixme!5$_ijZ;k=Kwl+_~vW2C^*<
    DU{vEU5uz|I;{Q'_G^RDBEy~w'-7C}}u>Q@aDA1,@Ro5uTZ*Jl$*YHn7Uo=s{J]*3>kD?YuH*A^G
    x5Q<5xI\j2val'K'ToJ4vs3lCkm<]'XmR5R^5*vv?\+k$V*WH55I#_@mDxAYcmsv{5V!Kw{;XAnA
    pmIv1YUAXi$nUs\7mx]BVYz'aOuWwB2Y>*oOn!{Q*?N47'YJTaj'tse57$?WQ,naU|<aLevQD]V\
    -B7!-jAo;1aX3AjDOZl<;\sl<!CV=U^Y?>lB}BEH#gK5smO1OI6R7,!zk-2'>+7R{X2eQZw>,v?b
    R;V!R#}s*'OmrjU2J^m#+\]DmYx>=!-ErY_xYsY*CEV<'E$~~Onr])x{VH\jQIgeU3JY,Ym'-*<I
    [KDO>7*7]\QJ'?l,'KI=!a+]E{=1meV#Ue;q)Y0/R@Qs,CkO;5,o[*Cwp;Y[=@W~\CJU_*2!4Yaw
    ,I5!O.t$!'J#t!x-YsCaxG{ClN,ksoXU1jAjUxv*!Ak]WWl~+I'mHHCY#~\\w7^V;@t=,'wXA3ow
    wC'eR2['m\K!prVHU+@Yo}G[u\Kk}l,D[<JpRp^]>oABCQ{=J3u*E7-_-7\yVX<5Ijm[*<K'g5V7
    ^_k_,IAXlZO;=VI7V(~I\Ocv3X[}v=Ee;\$aGm+rDrmdM]nAUkjBmIe7KpWv?'XnKI+Go>BmZeoH
    Z^,UT2'U*ID[>x!=I#+}KZ+<@5E!xr=J',RznoCCljuZ5I=>T/BAW3*GK^\}raOVY,w>*Gk${CZj
    rOS15*@i\EHjueWzA_2#,4!-C~<\Vpn1leETC1jV?jsC{e6L$[[AawzWIEQeIGsrE<R]0?wKXLD2
    +XAT$Gq$zTX7Z-$j~aJ;+]Ju-A[@aI\*[KE-GXD3riVls^Au^-2\VrQn]7@*H-UQ}<<EWeQlwV!'
    IRJD5m,zKpRT{=~CUH_mwr+iC,^OiTY?Tr1X*{2;VW;e[e$=~T\2vlr*5peY7Q>JU}kH,-r=ep;h
    cRAlj&AE;*6m=*wRO5Hn5*W,IrC[+OJpZY*QA$w'RaJ*T^Yeo$#rr@,v}2}7Qzkm1R26;],rrVK{
    uxvGtj[2BVmo$B,JoU<I3@Ol@kR?X2o-*njzHX]Wjk[-GkU}RYuD!xx5O@r]]#]KojIw5I}I*wx$
    3aD[E@<l*_E2Xk}vuj\p}Ix?l5>,@WH;n$C<v=;'IrX*ZsJH@1=wu]-xK1>A@+}{k+HKvEluUGD+
    o,zA<IOi$@$1XBv=RfUA+,OX{V{}X2nl$RZs5;o]O{-pUAl^7ju+!smoW_.GvmD'~'}11]sRk\5x
    ~m!s17'UweDHV~}s7u\uXO?C-KZK-RUKa5k!z!r;al!i]7<J}BJ=oKeh#}]asV2KuAu=:F8x@Q1E
    G_{)6{Gj3O[3!#5'3~{Q>ln[J]l@E$Gzs%=$kv3es'eu<aJ$*AI]R7@DV-$~]=vrH?$v!WOQ$@Rw
    oZ^iW@[{\*k<GIx#up~,msX$]aH+\vOGA-KeX[c_5T{vea=#oAA[~H*m=nmR;Q<u{xm]HBvxsIwD
    1K!EB#^\Ds#H$+s'[TZR*Jl*QZ7+D1-$-~H*?D-=KZ}V5$@+l3\kvK,|{_Xo%A=Js*3,RgjEeGA_
    [+T++;#R[1n\*-BKZ}QZ3H$U!Rkrx<oeiC!RH7*}HsaH;Vx32wtYp;,Dz_IQ>*OwI-V8xD'E_7;z
    VBZQ"2EZA@^7XOE7n7On5DkAll^_'<Xl\v7'AEz!@:/A+WlE$TYUjjvCm==B1,TeJVJp3QW1r@QI
    0CK{uN\Z@E\1$jxOw^13-\2{wZ7mezC=*D><]~vZA[vB_GR[lEE3<X@,r-!<J*q"U1~rD_x*G#;E
    QTOR5}v^I$2{QauZC>+IAaAJ}evJ1_\V+I1IE,#arkHpp%7E2GW{_mKQEr}2]Z%#BAUmpQn11O[1
    WHGC]-_KEr]'RnjAA1ijlzaa$iQkO2oZwViQjnUWCE^3][HV1pAwHA$ww_@/E7@n_G-n_1HYz2~^
    JrDs+w+m,]AmIOpjWDYKzS3Xz\DXZ@X}=+Gk!5C1TIA*HO?nEp8x1^^$=isSnB{J]!@{\WE3YVi\
    F{(=mQ_Rc,]HrZBTm)XQ{<G_>_jtLtQ{2okjmKz]z2x]I@7E2<eDpk\zVJRVzWxdy$k@2Hz@3lO>
    DV!ArHO~a^jlZ^K5U*KnwNE^!?iOV~l$Z-}V]>^w$A'zjU;r5;~=_<?jsU\r#+>&pwvW'lQ~#VoE
    !'m_*YR-:UQzG&@zQ3Gl}TaDa?27GGlT;?ex-H}_w]EeUG]G>E;Dx1n$o@XlU,7?~1?RGZs;pDBm
    x]@Ix<8@z@aN8I<s;!BEu,lv-I=vnBElX^;KQ-GZ[p{7G;_'XRAU#BKo#_OUADXxjpuJWs,EJzw]
    r5}UK_5<+GrIX^*iB>pG5ArraoAa#YGB;+j<~|WeCv<';#CKpml<*]y@<Z~EU$zT]R@HXK04D7vz
    Glk@@=V7(HE3Doo=[_k@aT],\U7z<sRj^AorYN]#]+T=_v#O=R=IKG+lY,m<^D3e~D<}ipO^HnEC
    1;]0>VW^S$1ECW}T2RkVlz-Q'A>srz5{a_x1Cx2D$DwH*(SeBXvJIV7TO~u9b]<p^loI=hJO^+vD
    nRICoo!X*5hp;^xjhpWm$mnA{ATe<'^zU$2G*>RJ'G^ap-'G7(AE{!7J\[#aaWl>o~1\pp?I<Ryj
    T5$Ys^W7[iJlEjB_}[a%zzuT3EaXC#=2@>!JX$AK\5!Q@H-rB?5J'm'>m7[z;Q{~LUIlYJ$#\s}Q
    i57\$$rmzX_?Y*Vm$aAz+*{p3JpGVwYR-,CZ@*qi'l5El@,YEm+YwQ]sW5EDIO;^+=TY^x<=C<Gv
    TAjwhO'JIlWYKI5JuBE\+;Dr{z--$eEwnZ'w{W>UUwIz]mvElfj\Al*3V*wl*3}zWI5oE{v}j~pm
    o]jp<AICa#<>5T_n,O>$H2;XupEXZ5V)1nzIK{l!I~J[wG~23<UKQp-XY!BvAH<x,WEEo#\Bsk@I
    %)><l'--'mwwx~6lzQe]4_JCZu\>?H+Unrw''ds[RC}7YR>rkDjk_XO,C=WCl]">D]'xO{jA>D[G
    +sHh5Qpo#r!a2x$>HYQa[+,^[s~p5*i}dwx_^3zXjq=3]n@a*Y,$uRmRi'7Gpv~vT$-IZxV{s\An
    HIu}Tjsn;n;_!RpZ*[p~ro'!a]Zl}-[k7kU]isv$w=z@e$ge2W$5t?n\TE$w^~-WU(]BK_,D++]-
    vC}wuvjm}Ii7+{rli>L'[w#C;3,Be=\WjeKK=Y2oz=2Q2!CI\vUZBTlv-BvKNV*]$}IKT6?Y[e~r
    E~QrnrWXXU>R'G>+A;5WJHtxsn3*GpJ.r}-$Dz2D~_vxeX_JB,QA1:^IAvQ-*pp<JT^IW#u7O'{{
    sj/<=R@B-HTXT-A~e5muCxrYXvnaHx~SwaX>,<jHlBEZd\_p'f"]/1Ox'>{Z1OY_'eR+~-$>!LQI
    uG=#.2x<TOYi{UoEB[r}i^=~I}?-B@_QeRn^\krkT?B~U>C'UCFp'~IDkav,_?ew5G;\lQO^C}$!
    -V;$jRv]KGYQC~V&25nY!-,Ri{lH'\C$w7'2QYuxe$>^y"*s>7[7\1-]x!#+E1:B%zADQ7nxiG;U
    QioV\rpY[(IwJ$qxEDX0DTDUQx}p#A$CTz#'rColl-2ump7^pr5x@UXj*izk[QuEA};U1K1}VVA+
    [QokN7}A~pC^D\IQ]},+$xHBEnrVTA[K5onI;0'DoVEk5B#V,nT[+}C5{^OWU$Une3_l~E4{IW[!
    OG]Y\DQs^wT#V_okBE?QHjrwxj5ajC[oxiU=QGZ!BvQ<+QZDA+QJ'~Z2Q>!$;D5!R5'/?VxWo$=[
    7kUl\#]]>^}!]WZ\DI~}=^*p$]@zneUYQ}Os(rDR#?Gl~DPvsrs_ul]>sm<vY{*,-TwjEwx*?Cn[
    2BipDmI?j+vkDmoHVGUQBR;^BI$[@{v4,='[V<!,jC]Io=p#L~l<Ke{W\RD=1DHK7XQ\j>l,TsIZ
    xxe=]Cz{rxu<Gk-BR~pvzT{OJqp3aW4lY#;$z<{ADCHKwvu{xr2!Y=Q]?R["Ek{r3E2a),@DUli{
    x3^KE^lE<B}Y!z\Bnk]JDzsj^G7ARk\?#xKpBf]<X^'?E-~<s[]x<\&~HKuI+r<UzA>oi*eAO3]r
    GOC3s1~*@!,iX^71x!{*3e~pxez4iE?[*nKG<>OB?DGnIN<12*yGjvu_S^~lY)+AsW25C5u\?o,i
    =QoDB2x{TD;sQ?#'+,sOH-EWr>[GnTi>D7DU]Tw]uE'dE>_~UjEBA-x=a5nulYJ$r\w-yAa[i^Bj
    Ok<sOmGiGirs>ji{!@>aGpIiWV2oRT}7+xR_YvD_EIg>A5$WR+=DIv~<x}7UsnzpiOH+XzYjYk*[
    KpV#7\OrH~@jz;'+aW$J,7}YxK!D@-$U}r!fSaU;Bxfm7p~oe-A=U<A#^]Tn]=1s7X$a\_op_#[X
    *zTTAI5'suXzrrD4~x3x#,#_t{{{[2BK*TH5+|zCZ<TVo+YE[Xe?a'X*oa*=\#<HBA$G[IDX\exe
    YCAUU+95az!x?13>o**\sk}AXI=wC;u5CxoOvrlx?HVTGBWle^~*!{{ip-QXVDZei+U]}1#2^-A6
    pi~<$U=-.~pH<C1}]_,e{DzH;m_-JZ$Cw{<VT3=+@pYrTl_jzeC^3O~vJpBe~Gn-A~+D*Xz{JEdY
    HA^Nj6eeOo~B$rooIwes=2TUKDle+XzU\o]-o}5G1,\jYp,*Yz!TC$;]pWr5w$']v7C^,AtwTK]?
    Hv#BDT*<OO7&A{+wYkeDg1kYABe$,:JoEEYT<m+jm~<OB{v9'v@X[R?x}^,A~CQk3UR@^up$Ul[E
    ',Wk$mE2h~wU[wUv1elOToWEz+CW#3,xkPV[jTBU7Ji[~z^7GH'njH?\-,Z}p_&Hr3DunuK;'JXP
    QivJfI#x^Q.u{7Q1=+Gp?UHmpDDz,s\Vo$*Ze_UZYjrE^W5Q\sU*svIQr,CQVo_.-l<I~{$^_A\K
    ^>!ICG}{OxlQW-xwmr#^BXaApXDZr{E,^8$I>vvUto]vQ\-CZZ\1[-TDOjE_$pIT}*Z2O1jX3v#E
    *mElr{a$VPCv-GY=$7cspH$'O;w!DnRtzV-k~e2X/k5}+>a=R1ZDAC5<Dvn;EE]zXeuKTR,pWA,I
    k$BI2\]E+xOJvlr<KC#;vCU>Qr\H,O}1p;TnJ7__I$=}@spHUmIXAHHW!-=>r1p-Ei_iV;Xm;+TO
    ~5"&a[ezO_\;RuC,?$i;'Ezs#HHj*w*-{7$~1I{U#>jC'k$?5rU}UU_K}37#ICku1X;U[Zox*xYm
    [m9CH@[UY*K,BYZC+A#Ds$n=Z=l.L==f@sn]!re=UNCi!Y2*xIHYW<R>j}.ZDX[Pp[!_}kHQ1m]k
    F0=A<U7nJG[s1=;XR-kT5$llxO5]-m^?uBTAzXa<>>=II[-s579!wx\]@7@Cl{RO"I3{BrQ[Y,eJ
    Tk$]oju!Gi{DBuR\]]*_;';aW|e[pW\D-3!Vo}xwJerC@}oK'?!]k>{Tap&+]BETo{HpTaZGE_=w
    v,e8-YZRE@Q\[TDeRz,]r>D+c?U3__UzW.o#7!wY!JjKw-rw,+JOjV+H1U9oje;B>lC@]#7D~AmK
    eH-proWZQl^n$+xx\}5CuIw#>C$OS^up?A]Rs;8sz-1\BJeYu7<e*Je>>xw[1e$\I#?XC'2W-}}e
    @XwGwn36dOor+<jB2?Dk;iRC$-D\{r-pDFlzUZn+l1#\{,\OExX^5rH,$m^u<11Q+Y[JVIRaprJq
    z2<J6xZmDnzKIivZ?$vj^]<+;*WCU$e_YIvzr{RB[$!w;sv]k+[AKwpK3eH]C+e7Y>Ei+EK,O[5x
    ZD27BE<=a5o-@GZlE)]H;G!zO21_1Dv|XTBrw[znKlw,P>le[vX[kSnx}zmoURU'aD5X~OVCuaGm
    {K\+Wx#v\J'*?JJA,-{Bo^u}EC]j]l%\ZZoZI@'W,V[JwWmkXW?$@*Klp>p&C5^I('-X!H=elpk*
    <a*oX(V}j?1*##!{_ZY\X=\,{uI+WY?s{,Z<<QOoI>>aU3I\R5^KeaRml}{^~GvnJ}TV+o#nCm!\
    AOBj^x,]i2_#5o]r<I#]YHlAIzKAuxsa{H>VKD,8+7XJtrErw,aE+#^,_Z,;eHa+okIQ{,W^OSVX
    n^ZG<JvwQpvz@Akw]a^zuwm>mr-j@Kp\lH<x5m\>BeB#UBK+rxloIwRYCQsKs}UE=,~*XofoG;e)
    VojRus!uHokWl<JU_}wmv\C!sGW+GXeG3I1I!^s7+IBa\^O-^-<eO~71]TB;[cIrvi;>m\m\KC[O
    mv(qjsT\l2<nBkjiNOJF.$K>D)%|JR{Al53a-XUTzbi7UJKRo\QowJo5_WKox7N@Glv98[GVD!V~
    ~pjpU<ECHObl^A*$mZ$}#\G8f*!1j5I}a1x}}OHZDSk^B5Wn7A-qejXI[>R_x-j?E?\o]iUT?I\A
    0Q+<Olk{*y!7JkDi_ibY}I_-x1]*UKa,>JT{V\ooX$'mj7U_;e@'==D6Irl+O^ZwBR55xB]?s\#W
    <'${TX!pDse->$}OYWmWU\'AGD=e}O+s*QxvVO@pmB?wo1rIuOAQ5@!7&p?1~eV7~sRTolV,}V>B
    Wk>,j,Y_?2{Yuvu~nnhR^vDRn_Esjw_[ajszp,x,p,C&#q2DV$W=r}:<,3XY[I@}{*I=i+$Riorr
    Xu'0;Ye3oCEW!_sw'W,k]pmCej,s[JnT_#\BKB*#xu@}tth]7+n^a1>}w*5\}+aG*2k6o>=V$nW!
    I'J;V~J1jY#oW+'k%zw[GraT[Dx?,oWpDlQJ1{I;[G7WGpeT>=>X?HC}iqG?1VroH7XT<2TRzJrW
    ]VtKHR>i<THH]Qu_!Ik;,]\Gvo'DIk1Ol]_AxEY1+7<@wKz>o+T$[$sn+x[;7l[j!u7'?*K4l7Io
    URQn-YQs&OAU'V{>\sHKa29_a]Jko-a/uT~>r~K<p=>HSTo#7P?E*TIDQCa1VJ1_lK%#EVlvV!!P
    -DuwO3~Q2X!uw}z7Y7x]lrOJoHHz1Ilvn\^[r:B72e_,Y[~OKKE3Zj~wRWw<KaWQJD}-s2OXuW5*
    =l^Q_CvK!wR=*p7{K$EaOk=(JsRBz>*xRo~RR5i3O*#A{[73tHI;u35{>G@C<=5,GhE-Y]m>YuDo
    7[#<5W^I\<j*5J#HQv+175TO{2+_AAxJK-D,nK,2rR7<deeI2,IpleWOmr}J~*_3$\[2T4I\$GiC
    >x${r+rD]>VH;\w}il{53C]<7$Qol@U1DpgWaoAI#GKNDxUzSC;o++T@pI1o+UlDHs1l@'O!7Gs+
    Ad/i*E<B~^K+_xQ=cN@jsDwhze}3#BA@5G_~C;Yv5G5Ko\{#XBp=oAzv[vGn>QskB3]nuTXwGW_e
    3_@GXws#+_*ZFR@Q=Zjm*(,E;^#1sIm{,aj;>3z=O}s5Q@zm{CR_[Q3UD!rE=xp;=B5Y-GanJ2,_
    1Bj^Js1Bx'++AvA{=m+]7DYm]Te_H$*~Z{kH['5_;@QVDzxlZ[aln[$C>A_@$I~Q>RMeKur@5Xu_
    lZ5Y=[I{IZGFsX$sDT}pipnH_G@}xGX#uCY\VYE}p]sGp'DKDR<Y<Ha^E=1\-{@-rT3sEW^a~>;l
    21Vj~751=l{w7{;1xKX@R17$vX1k+C,T;rYeQ<>]x#e]EO=3GeC7AsXZOpnR\psvxaviOiH<AB'n
    Mz>a>ux_5B[^#puR]"5\>KWOEouGJo\Q<XY1_'Ip{uxjT]YZn-Qr-YM;U<sVv\,4o|>NSeDUa*kv
    3'Z3T\7T+Kxn<1T-;zee;^m2@=;~OaIjZ?EUG~X7pPwY\Z$spp,$=vu[r'{,v[H}XQrH2+Bi$O1w
    1Z]!z^Q*3J,X!#d!E@j3$~OHeTr:\v[X]psQGzW<Rl+peE>J4HYX]{Evn$pC1nV;>+$\mqw1V=U]
    +CRUC;CKJR+[*p,?-v'5aaI@R[weHm7rGuJr}kQ2,V7rIp=j_<RH_]GuKzWA5DDX<movvi^Uo!UG
    \kCD7j-e5*5~p<QBT7vo^3_l@W1;5,^W{')xjHZIDoiar@<rYYKz[QUl7[iw_u}j_rYD?<@Q^55*
    Qr=-p}z<p-pvCHmB@<A^E#HsB>R+Ulr]vk5^YG;'=TwpD!Y>*z_Hs-skYwn1VKZ2+Zv~U@@x[7'A
    >;+0D!I]?'*-zQRkH-$,o>!~i5oGY<'D,'2>OVoU:-.RT'jljQebo=WE$eQ;UD>5kD\#{E-_LHl?
    #i+!_#x?=#a~uZnsxY?E]_;=HxBwU;IYVZ5sHX\j{{Nv$<IVHDBpY1B]*rnA*YajGWjeXxEXT2,{
    eI;QXBx1$*ZKr+<jz_v%f,[H5za,}R$JQ{o{wIV7GqJB5VU,[Toru+nwuReQOa7J3;x*CI<$xV~O
    I]xnJ,jklYIeU<_oAYwweJ,=J^s2A^ZE]1R'?HJ5*WY1CI<Q1nc\slRTH^EJE-!jO[RQ?<75<{\4
    [2^*]e>>,x~=QlmGEW5!E3w'Ja1_5j^'!<v$<vR;Cs*[xa[5B'X1OGTup?XQ*x53\U'$E%hBCA{#
    >v[7+BI$*}Z3sxsDlv<JpE;aR*Tx?us,vGHsuQl<nxKsuvpHj!>!XK\I?z5$<s{5BE2\<K=/GJzm
    2HnB;lZEe;Ev';HZ\;$!nRemVJW*9poQr=D,?p1XAJrkX]nuE1Q1XQQYY{vso*CYJ'wn+W*22=GT
    zaRAIU5n7ho-,2\vDStpI+Cz{3WE;3#}BI<5Rzr^^53'!xA1u$$*B[$sr_GVs}A$z*jE-;55>>+z
    x*UB;v'v[\zX_!1+xWjC3@zawW3-{mV(Y^_=BkroV@Xr=U+G5u$?y>VAR=#J$O2C@4K[vlnz=uWw
    {s{=U?BVV\I)EXE@_$Twp77ojrujx#!J#=75xw]DX{QJ(le;p'Kv1s'rqqInm=RQ?@2vCJO\pQl*
    CZ7KJw$=s>]ACk12A>X5krV'-EueTjMTI!#TXnp[_2\*-CZ~+YvC+2Qp{O1B=D~'--]|%}3Yitlx
    j}Das_Y7}3p21VC12r6U$nV+7i7FO_ilH7^G=iXCGghNo{WDLYsn5!Y]~=;uR2ojG:=?>OG]]E,#
    wT@<^?h6T]x?+7XlD}<uW]C'i7pD}~Bell\7xH@BGVjCC,_l]mv+Ap#K\uYiPh^lB=[C!uu^m@J\
    #!rsUrUwsKM-'_,!-5_Y>C{,e$@1KDpxTWpp+^*TRxX=J3pynR[*@OW7,@*Oe$p![<Wu>{,\V+AB
    J{Cm@Y!{(-OOYoR3E-CDxD}z$X,pi%}I-BB7zD,evR1K*m}7TO9+Ae?RxQk^9{>xORD-7=&R5_pM
    lz[-IZQ3NB"VwZ_vHx#R{B'}_s+#lxZCaW[.,$o$x'n]N}GK2yd1>opUp<B>z_x@xnTDYT'}H;EJ
    DZ]AE-Kz#xKu_RWAX{aU_'+=m7@7Msjr~;=l3^#X\epJ~W1#Wm]+3xU^Xrmpa^=OI^,}r?w3RFbI
    3u~Ic#=R'q]s?v4{EXan1$sLDZXKU+vpo_JUxe2IBsV@v~zr1Y$rmTx~B1'<v@j>AA^-j<CXs[o?
    A7TmkaXaRXWY<]BuWGC+R*XauE<U.RxalxB#X13'!'=1_qZsOjfBE15DOZrsmZjHD!*B~AJ1jxB>
    $m^Z}XQiplzOZl{'@^D=a>Y,!'C!+w,Rp_~zio~^T<r/7^rATE]W#Hx\<1j#-aCrj^AHrVupGI*o
    DL@Be_s$DsfrIX?C!@D:@+lXUU+DRo+Yuz'W?\=oa,RCiOoisa[rY-G#jErXR{_*BTovU\p,ZaZ^
    Z}V]]e@X3X]uBek7>_pk9--w[s^x7^/]\X]ZYO5i+X#\zXC>R},/nQ17!<|)isr?{5=ov*Oa^?>*
    Qj$aUE7aOp\~>s#^$,si[Z~o5X{#o3K{rA!>?]pj|bEn_uI(@<+rV#a$7Zv{25pYlz{QXUeI[;53
    uRmU\7i+EA][h>UzTI3+mO1<!^z]lYzQ\=~xe!Q#@-&/HDRoiBWA5a@a\*t)7-K[O#^@[_~VC{]w
    H9NbmewkuVl;oCs=jB+2Q!5]pKs;.-R$eUD#32X-T9ivol2Hp_];poR]Y_o?Za,KGsX\TKf#*!>x
    {{E@C+[7A>}bK^![}*#D~_,=jY2G=~l-&zoB~ox_,tROrvOz<V\D<}2su77Ue$7m-,2w\_xpp[UI
    hlj3aS"+a\OV7mk)H+X;KwKHGi']:Q+{l$*J]pG+?J_Ws)o!}-vUA}T{eQnwEz,2;vXYpBA}{R=B
    7\{zTVEvJE_-Kk1;b\3Hzxf1\v*dKGm,he}K'IR+rwsZHC>3'aa]]dN[SxIKWAD'V}Yn'&1v>EjK
    RUV!rRH1*E2}a25r!'p*$[Rz1AmCjQpJUmUCOA\T{2CU$_nCU_OWwpzQQV#HjH2Un,XOE]'=;2]A
    Kr<,osDuAm@^zV'+lDGmBC1>~Z7w^7re[}75!VQD{7el@WwIa+*oDr^u7Cp_w,V5IjOwJw3rwn1@
    H@{pYZZ[lv\?m{l,oYw5\+5smo<TVD='1Hce51lRHurI*As]uA@]Ws?!oDp-=\mQHj*!U7]R#${p
    >7;('mG}Cr+KUo\UpBA;-eZx[D@}+X]Z^CEX}-om?X\!\+m35U-a^!R,5xvk-\$]XV<<4xC$aW1a
    OC@*i\GD!wUCWV,p@pW~V9M5WQ-pi<G;U[iRoi@~'zVQeVW+G>\#viY~xAC]*VXr\>[*1r*+{xB$
    Cm=oA3\z~B\^aEI~X5Y0N!a{EVYR^nxE_Or!k;{]wZ,=C,!EiBw!r;vkC1w-<Z>aJ_}iqpXZT*_$
    [7Ta#E,Iu6[3,}R#Hm^~BYkTUJ=^AkLHoK;T,HKE!z,(>l_Zxp}sz~+^*!C>;zzIxY@'ZRp_~l1R
    *Wn7zrE$[p{<0_RO[,$wsW}tR75\$z!IOI<!bY{']es32+5<\\z<kZ{H$0TeU=HEq~'>?0Z*Z]D'
    k=-}RT1+1ie#5To[DZo]Z5a$\>~\VR]{>\lYBUIvRsK$o[VZnO}]R3KnHE2aajy'X<u)izvX^<wu
    t#YUzE1v'<BQ]VTDelm<Uf$\I?;-zK=li'\0HHAH3'*i,To_',*mE}={L}ljJkRnA{$+Ajn~plJ=
    Rz25@(fH^2],A@o2\$a<zej-rG,,EBnFV;l<+Re{lwB@ua@;GjEI$7532*IpazJujem*U^,Js7Q\
    u[E~m,wwgIu2'Qr+j[R!>W6Cemarn{[ylxAz}{^T<XU=Mw9eQVAOSXxEluCAQ}Q{T?pV=<l@XHao
    AZwIO-5j@3B<Kz]Cp<Ck^/=Ac]sHQ}uY~G}Y,]lpW,@*Kq'nA}r}_j=J>]$$K=1H\7]a~~+o'zIG
    @v-{Dk]]A='p#zo^YHYJ{O@Q_@\sUYlp__oz^#YIuG<n}jia}v5zUR1_TwQu\~RUs!$HzV'I*CiA
    C!{_R>^{>o\aW]U'e@IKGasm~oHaaCQ]#UvzK'sBO}oTzkwDw-2}v\]Ol'S/?[@e@<nVx1$TGTTA
    ED}VY{eOR[@=f#U8ma=W1m1jZH^wWe;2#IJookQ+K$VaGHn1+O5X0n*QDl<~lvmJ=.\{'#wVZ2Oi
    G{s+we7_[?xapG<n@x!1*I;Tr<~IuH-p7;]T,G:*rZ#enU-oW+O,;+7e*1@l?^n2Cur*Q;#i{'>g
    ;xDW><n};_zVaz{_Q~_Qw<xsBH+W$vT$Dk_UFI]=,7R-K1k_Eun!T#<ZYX=$H9i=_RV!owl+<z;Y
    =-,nX]aUs2_YZ1ZBmW$i@!JsJ{bz3<<!jmx*D3otvv*\?D#e#vCj#]K<VVx7Q}!Vzj!+oU$Z|=Oi
    -p{=n(Qm=1l'o{Bmj{|iDkIV@axj[K,ylBZ*UOvR=n@#l1~Tjn+m}ZXKaa<n7}X~p!+>E_[}Rin!
    J[-OkU]~C(jpzv2>W5sEk~.o}ZQa=w_iv~_P^D+~e2s1IuQ3*[K}2D{^5\UT!-<'apHm~<;X6'ok
    {s[\u'n!m.e@1DpAO2}>wV-as_BOUx2R{'!-e[1{m7^}v~U<3*|W7|ivo]Pl$eZWO1o$~X}|E5?C
    1+>W$2Q{zW\a0G}Z~G\U^6vB*Kp>~~G2B{OXBKxW3D'z!HKAa$p[Ovurs\d'CU~gU=k1j3ll6<7Z
    \<jn$dHrA>{_H51wDDq7+aRB,IXU[Ze,>^E,XnBH_{}'~G]1Io#*_HxQA-Z,xBzEX>K$+jz#vAT;
    =1v/U5=KEKWwCpCVO=Q<X+l>p7kwY]Er!l+oao3+JG$;F.DU~$/.]z$YvuwJ2A}+nH1XLuIQGAe-
    ay[zkTIJn1ouu-<z+}/()1Zur{*3Xd+[7ze>m3CDmH]r,x[VKAjr?r49[l;~OwKWhqmj{e'k]z~a
    <nVz2';DKCh5kY2^Tla>\nG::wB+']Jzx2'r2]Tp-j*7oA{,CKG[\W,{IvKXsCG!YC-_!<CoK3wj
    U3_$Y,B5j#D1o@Bax5Vv-7nY^AR,'cN)oeilV^41?5IoDw~r<
`endprotected
endmodule // module vusb_hs_dma_context

