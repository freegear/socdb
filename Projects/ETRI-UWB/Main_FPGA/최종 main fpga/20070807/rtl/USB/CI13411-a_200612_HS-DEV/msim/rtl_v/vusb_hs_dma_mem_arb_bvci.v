/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_dma_mem_arb_bvci.vhdl
-- Date Created: Thu Dec 21 22:43:03 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_dma_mem_arb_bvci.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Vusb_hs dma data traffic movement & channel arbitration engine.
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
module vusb_hs_dma_mem_arb_bvci (clk,
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
   dma_up_endian,
   dma_up_host_mode,
   dma_tx_tag_wr,
   dma_tx_data_wr,
   dma_tx_wr,
   dma_tx_ep,
   dma_tt_tx_tag,
   dma_tt_tx_data,
   dma_tt_tx_wr,
   dma_rx_tag,
   dma_rx_data,
   dma_rx_empty,
   dma_rx_empty_ctrl,
   dma_rx_rd,
   dma_tt_rx_tag,
   dma_tt_rx_data,
   dma_tt_rx_empty,
   dma_tt_rx_rd,
   mem_done,
   mem_done_go_again,
   mem_done_overflow,
   mem_pipe_sel,
   mem_ack_sub,
   mem_underflow,
   mem_burst_act,
   traf_bus_req,
   traf_bus_req_again,
   traf_bus_req_typeinfo,
   traf_bus_gnt,
   traf_bus_addr,
   traf_bus_addr_np,
   traf_bus_burst,
   traf_bus_ep,
   traf_tx_req,
   traf_tx_wr,
   traf_tx_gnt,
   traf_tx_data,
   traf_tx_ep,
   traf_rx_req,
   traf_rx_rd,
   traf_rx_gnt,
   traf_tt_bus_req,
   traf_tt_bus_req_again,
   traf_tt_bus_req_typeinfo,
   traf_tt_bus_gnt,
   traf_tt_bus_addr,
   traf_tt_bus_addr_np,
   traf_tt_bus_burst,
   traf_tt_tx_req,
   traf_tt_tx_wr,
   traf_tt_tx_gnt,
   traf_tt_tx_data,
   traf_tt_rx_req,
   traf_tt_rx_rd,
   traf_tt_rx_gnt,
   hst_rx_req,
   hst_rx_rd,
   hst_rx_gnt,
   hst_tx_req,
   hst_tx_wr,
   hst_tx_gnt,
   hst_tx_tag,
   hst_tx_data,
   hst_tt_rx_req,
   hst_tt_rx_rd,
   hst_tt_rx_gnt,
   hst_tt_tx_tag,
   hst_tt_tx_data,
   hst_tt_tx_req,
   hst_tt_tx_wr,
   hst_tt_tx_gnt,
   dev_rx_req,
   dev_rx_rd,
   dev_rx_gnt,
   op_context_bus_req,
   op_context_bus_req_typeinfo,
   op_context_bus_gnt,
   op_context_bus_addr,
   op_context_bus_burst,
   op_context_bus_data,
   mem_arb_sys_err);
parameter usage = 1'b 0;

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
input   dma_up_endian; 
input   dma_up_host_mode; 
output   [3:0] dma_tx_tag_wr; 
output   [31:0] dma_tx_data_wr; 
output   dma_tx_wr; 
output   [3:0] dma_tx_ep; 
output   [3:0] dma_tt_tx_tag; 
output   [31:0] dma_tt_tx_data; 
output   dma_tt_tx_wr; 
input   [3:0] dma_rx_tag; 
input   [31:0] dma_rx_data; 
input   dma_rx_empty; 
input   dma_rx_empty_ctrl; 
output   dma_rx_rd; 
input   [3:0] dma_tt_rx_tag; 
input   [31:0] dma_tt_rx_data; 
input   dma_tt_rx_empty; 
output   dma_tt_rx_rd; 
output   mem_done; 
output   mem_done_go_again; 
output   mem_done_overflow; 
output   mem_pipe_sel; 
output   mem_ack_sub; 
output   mem_underflow; 
output   [MEM_BURST_LEN_CNT_WIDTH_BYTE - 1:0] mem_burst_act; 
input   [2:0] traf_bus_req; 
input   traf_bus_req_again; 
input   [BUS_TYPE_INFO_WIDTH - 1:0] traf_bus_req_typeinfo; 
output   traf_bus_gnt; 
input   [31:0] traf_bus_addr; 
input   [31:12] traf_bus_addr_np; 
input   [MEM_BURST_LEN_CNT_WIDTH_BYTE - 1:0] traf_bus_burst; 
input   [3:0] traf_bus_ep; 
input   traf_tx_req; 
input   traf_tx_wr; 
output   traf_tx_gnt; 
input   [35:0] traf_tx_data; 
input   [3:0] traf_tx_ep; 
input   traf_rx_req; 
input   traf_rx_rd; 
output   traf_rx_gnt; 
input   [2:0] traf_tt_bus_req; 
input   traf_tt_bus_req_again; 
input   [BUS_TYPE_INFO_WIDTH - 1:0] traf_tt_bus_req_typeinfo; 
output   traf_tt_bus_gnt; 
input   [31:0] traf_tt_bus_addr; 
input   [31:12] traf_tt_bus_addr_np; 
input   [MEM_BURST_LEN_CNT_WIDTH_BYTE - 1:0] traf_tt_bus_burst; 
input   traf_tt_tx_req; 
input   traf_tt_tx_wr; 
output   traf_tt_tx_gnt; 
input   [35:0] traf_tt_tx_data; 
input   traf_tt_rx_req; 
input   traf_tt_rx_rd; 
output   traf_tt_rx_gnt; 
input   hst_rx_req; 
input   hst_rx_rd; 
output   hst_rx_gnt; 
input   hst_tx_req; 
input   hst_tx_wr; 
output   hst_tx_gnt; 
input   [3:0] hst_tx_tag; 
input   [31:0] hst_tx_data; 
input   hst_tt_rx_req; 
input   hst_tt_rx_rd; 
output   hst_tt_rx_gnt; 
input   [3:0] hst_tt_tx_tag; 
input   [31:0] hst_tt_tx_data; 
input   hst_tt_tx_req; 
input   hst_tt_tx_wr; 
output   hst_tt_tx_gnt; 
input   dev_rx_req; 
input   dev_rx_rd; 
output   dev_rx_gnt; 
input   [2:0] op_context_bus_req; 
input   [BUS_TYPE_INFO_WIDTH - 1:0] op_context_bus_req_typeinfo; 
output   op_context_bus_gnt; 
input   [31:2] op_context_bus_addr; 
input   [6:2] op_context_bus_burst; 
input   [31:0] op_context_bus_data; 
output   mem_arb_sys_err; 
`protected

    MTI!#pnjJlY$wPOr3l[[u$kp}HETD?}13$Wz'[:|s|PIkRaOuxrw+^HvRk{~{n^w]lmIvri,R^ju
    opxTYE]Izrom5\IFI#X<[vJ?osJUXO:K\5Vr=@j6'WT+?IzIn'{]D#=vl<!\GIDoOIx;R]\\F.|*
    ~nk}l'-=5s+I^Dr{7<3RCi]1^B{;=po]jX?'KoQ/?[11V,!\[}j,fO=*YH1X?Ts2soe1#pQueD._
    ua#}mNBrklYHE~]^p7Iul~h@<5=fRWA['l'\OJ3T=J_'=ax\&,C@~v*[!?G=BQ=EG2DV7e1!aJ\V
    u*-sAVzv;u{a+bLT5+x'[s?_k-u&}zE@Wv[>;DnYB{Y3j>piWpn#aOZXrKnaJwV^X*!3Ur>'x12x
    -+]Y~1H'';jII5uJ[aw_Y*Te,4!o1w@^-xH5#p_]Aez*,vQ-o-;jrs/+$Z?n5DRps@^oY~}pp$?K
    DQO^ll>w+v!t=Uxj2o$=]wv1jVGo=Zp}]'*s$X>[e#'WY#O\U<Z-,*K~W'$~QVnEi'#Tge\V;x"i
    [zUvCup_pCX#5v@QaR=@5[OVm-*Y,vWOV{res*];^R1v$}$k-ou!w6w\n{x=-_}w!U,:3v\[R}la
    3HGkLKDKJ~[[R2[Cv^a]w:1z@VHT]pweD?RmOu@}'OAXQO*'$w}BOOU__e}[Yk>*<Vk*Wu.F<=<u
    ]nRo2Y$r^nn~F@=_oio-Gv,;s$,+e;7RYgP[T<?:@7p!UD)CV;HHI$p5\*D[bB=,B\HG5'W[;h'x
    +n'[X+;XEjxn{\$K*2\O?7GEv'K^es#R*u'v@}pc_7e\YONsxjH-De{=+o^m=ZE1DAp-[p?DokIB
    XexV\G?IB_]=ZTu!s@UvT1[$@Cs[j,r[ZKO5@o@*j7ruY7ls=*IJBso1ze?H<o{GEj;_W1z{H5?1
    Z!#OXeHWa=p*k^\Ik[JU+ju7xz@;lGs?T;VY&$8AI~Ak1?p<D3[K*<59F'=-R}alw-=Vxt>p#l,-
    TKo+Vs06<VT*rYQY\,@x)o]xOv{XCe11^\Z3DUDUuaBIrQ,?BydC{n#Bz~v>O#z^Z!v*7{Vx#!<z
    [owJ1I5AIY2,sQ2U_^$}vEs?vD_k=GkB5zQ<T+B1n2mk{7Ydm}$^#_\,>^B's<E^m*CuIV#[)D!K
    x2^J1qlz<m\>!C/AB734VBJ}~anIaXeQY^v]Va7H}OsH<}YT]iQk/T}uW\pk^oHA7?'RUAG#T/jW
    nz$x*eo=K}*-p!^~Y^1!<X!&E7pX7l<ZKYR#e*#DRB$p3a!<=Aaj'CE5woK>1jZKtMfXA5kWoil}
    }{wJzwB3_pke{X-rVvWBIjzTDD}=ir>u^!s'#B]{Ou},Y;[ru7\M12]EXj,WE>jar7wj*rpaOCYG
    H_;[r^YV_5C-_T5$ua\CQXOWm<xYuT7\sXB]IHRpBxWnqQj>~@<RTeKB'l1u{Cor5Czj-$vDuUw3
    zKROUx72#7me!'T@HQ{JX+HZpyp#1Bv2jR'oQsWYTx'>3uk==WvnVZ\[-3GYuav3V$pZowZTlv4x
    }?7c*]DwSev+2$kl]$X^#{=Vlqr,ja{^{$x[T@z!<zJp[>?7lo$2oodsXCXInQpGe2R&VnI>iBa#
    c'D$XWC,]h&vk~Tjp_~9\^3x^@E^gGr@zJ1=sr3j+\\K+]L1Gpwls;^p\[R!_AIvDwI&B>=~$>G3
    0s~R^VY2XY;*Z/_x>e,7IK-w>*UITkouUGK,}<$<3An5o11!52HDw~5eVDxK<!V5znurm=]U7DiQ
    EjoW^+?lHvO,-x=T\<r1lJ)'li;Y^k<J$=mvUX\h_o-'ueas[~IKlKBp]k3n'D7@gWQRj|Q?VHxE
    nuw^O2$AY*dCw+_$^'3]\!]c!1k7-,>Y5HwQ'Dn~>'pWjQj-$?us_T,jOJnwWv-uC/;o*]lm}{Kn
    YiB$1oRDDwv$\_@{ReeUO>xKQ!ne_oC\K*p_juEnEOGJ[Ynz$]IrXx^G${CXwZJvxeEiD?h(^sRa
    opH_K[=rY+o=$2[{BK\a'r#'WoBT(B#QU5Wvp&/nlkp},morE{VEa\*C$v{R3e$~s?U}!-EVI~T5
    ReYWIoGkp2Jr=AvKEeG9?w;VN=Q>r:{={$,VR5>YZ_l_U{D7O1&%'a2#6;>eB$?a@emo5"em_U\x
    ~$^OZ#i-=I$I$EB$AenaA[YvEak_B<^w3V!7RR,'G$eWoa^<T?]JBZ'$'\Aasw$De!rRvTd=GQ$J
    E$;3xJHVn2RQ~^1<Cvu?1{lHY\HH}EG>+Xa:,+U@mO$@^~us'x?OH_]s*}71u,I<,RJ@4*^_[]WR
    _-H-UT$Ul\l3,7-Is~L,!@]28!lr'O<JXv[m>7nrQ@zXY&,]U'%RRIiTO@\MQl#o;o5!j\]U2[XU
    }OBe+_C'S@RvG3CJ?*X[==-+?GC=#H}+v@T\>\-*Ud]~JZUE,]nHu<B@3TOnK~H]}WPBB{lj*<>*
    55<[i>[\pa#*xXU:l]O@RImjc!OeJ3Rp-a'OHz,*}!RZsK,YETr>$<Yx_4--*<$l>sO[@D3^iAoC
    {$HlYsm1+T#^V_noIG?,*nzx~n7-2?1laWbw5?WjrVxh[aw?E^'7Nv><sC'\OO5pE,3C}RE5{z]!
    J_JTJ@<j_\_?Cz+AG=7G1b^+{THj,Gx^CJYu^a'RxW7EkWz?o=TUUAfVC@{O=1EkOoAR7'3XXaZs
    *=+u$]DREo#*;npV>{l2R?,WapiE5es#Gu[H*<pKRQ3ywo#u7(j2Cw<7R~_ivziwD]DEQ#iIJ-9c
    ts*+n8Ci$Kxn!oE:5vZXK7T7k*\,/Qv,RuBG,Y]ml|F'n<jA{oURsl2mo2{e<B1[1=5M5Ee^BuC{
    l}wYuD}'uD$J,R{x_-(Rm+\o[ves3DW*ra}50%'R#-$^*I}Z^kN>CVAO-IEXBXoUlm[Q_5<~>]3X
    Cev@A=<!l>He:e<X+HD'warU,K}J*x5kYQ#>}$G*dQOO!gp>3aFQCVe!DVw'DK#,$z=z!C<}}}o'
    l!=Bws[_AABY'W$,rYzZA<kAvn+=k}C1;'@nV@roevr^azlfIOJR'EsjQK7]E/=Yp>G55{pr'roZ
    3XgLEW2[v[EwkTaR5=xA<\?+lUrp,?wH>*B#)s,3OmHY!=T{*zUC;llY[+-.IU!V1YzWCn=}QHKv
    /,p_srY5<!*K;OTDev-;T_eZE,O><$lT^K-zEvII\V'$##'{UsuU=o<7G[~v?R$I$"3TX2-E;*{|
    ^KoT>pmQHD,!us-AKwepdJOY[7~_xHaD?+[U~;IBI\Ue<>1<W!XQ$e!~QywrGORuOE!xo7ZGexe1
    X<La8x}m;L1zRCrrElVU*JD#DRx~[V50%UDxoL})PK=Y$"(en3+CsI!ETmCxa{v]as7C]UQ{\+V5
    C?Q]=XaK_'72Ow@],BCie2u[UOR!,lVe<UJjY1^}^l=LE5A;n>WDeAB<!^}D$]*'C/!wEljB-O-D
    \m+=CwxmeBU=u!1m<j_JKZ{$?eKw_l^!}Gu>X[snT#*rXK'D\!#9q1!3eoQ>v^e<#v~nn_AWlv#7
    _"5QRuvE#,5w~$D\o{C,Q2(H+n<JD;aR*m3wBI*oEw5aTn]}!Bi9/Za<p<Rr'WEJT*sWDixv=rAU
    57T'E+V{WG3A_${r!v,oV^I]i@[ajW7\!I'3]>>W{hjUj\fR]eJAI=pe~uJ}eIXveTVwY$V5J[x@
    D*5}z#;K>KDv_GBjwX+qZD'<6cuH[J]Z3koET@y$nr,,jYK3Q![,<mOaDn'rZlrGA{7<1A+ZGn[<
    +=xeGnG'rrpUeaKXp*7'GZ{9}s5[[evX-D}o~<X^G}+klA^[q^9nVA'il>[p2,![+,l1Al}Ko!pu
    DnJpJsie+p2@7D]8axwliBm7EV=-De,D7Us{AVHQgox^en{x5KDu_XexX?QR\smY_/H_B;J5wm_G
    zXjr{AJxGRNK'pDoiW@O+3#[IoXi>2'C2_\jvZm\Izi(mIri*Gp'aCEV;TB[}v<nVk-k}Rxoxs!\
    IX1,R3eafo#~e0viI_zHTHp}uJw_7Y^laX>'i$UzJrBEWaXIKvb%^VH7Vmj'B3{$1!WlV]VaiD]A
    e,pJs,pv,~Ii6[,l3IAOv=,7CO72ZOGGYGODj*^TmH}@vlQGY%vWYe:17;k>T=\v\CmL7IYmBn=H
    kV]]iY!7F925P?5}OrmIwH_kT]_QBtZT[1\iaZ|*"a'\?C!DXm1wa!xJGxnU@3ApAB#{k,sH;\xk
    V,z!QRiKz7wYRmHj]\Gu?wloXr^{$rvUw;zR{In5s>*1zf-{-=pa<pRiz$5u1$=z_1}G<xxE\iG@
    Z52[ZOjo?z%o253p]O<\OKw{Xso5#ZwJ+E~moWn$>*vo>nvE,e{-s@>Swaxi3TBAFU7Hxl|]5]]y
    B?r?*-u~~]H$3<}uIRk^nR@C+w$_)^Bb\?3Z\*}i*z}KoEI7B_VQ@X=Bfz]v>cjZ3'Ex[*VsIJIH
    p^}Z+Z>oQsS1HHs'G<#2*^UKYGiZTHIl^~C2e;~xW>kB-BBi*]rTDw[eTxEl\i#eEY<BEBMJVxEb
    e-xmRup>w]=Ix5<7Cx{+xezT2AnZ*i[Z_VexDn~l7Yra>XIu[~Ii~TAXlHW$PqZXY_TxQoe{OW<j
    1xmV$JyT[<CT}2Vu[Vl#Vs@?AJ\FI2,_.;O[AB<wG'RW!pzmu$~V=r[UD>_Ow}h$r3e2Qm3vOs3$
    eXK'$>Ku-plT$zmujKE*ao\+sH<KTZDr>-{f<$'I)_XAE$K!]doaar'2sQqivT]iXVC4CW,*@Dsa
    v$;~B!ZvAIWreB'!ez}ws[sm8G*3K(TXsrF0@B1Z#IpA|EG*xr~n^]{5m8rzJ#-<Q7e5JjGGIiXj
    7x+wE#-B12IkJ@pTB[gI-lAz'lIC]u@sHACls*Z*{!IZewo1KDBI?*-C?>a[_u}]x3xeH]u,QK*p
    We[gI;EZ,o*$yie,wDp<,rYo^?&ll*CU=@A\3UsCr@AV#K!]3DkTeAnD!BW1[T$Qs-$x$Y=tRs]@
    e>Tkn\{WJ=rJKj+Ki+Twsm~O=uOEm\]K'5o@sHGuyyEi+xs3$[ggUHET]$O?-5,}5oUzp^,+<DKl
    6^wWGI$,GIju=x<Kn^H~''GHrO!{!vZ7e^*;G{OJ1D!pV}}I$+BYDtAA^En'1KkessXx]v*H$\>U
    _aj+Avc<Eips-v\xr$!3U}JoQ7Wwrl^yX-$>:iAU7I'JJ\![_A1I7X$3QxK_2QkJ'Iu;w(/#E!GC
    saBY;{o37\IQj)w1QKzp5^Cw;]2lHrBD{_B5vHmSEZ_Bp#o^W{+*_]1Ez{CE?Q$]Hwm^:ZlY'Q9H
    vr{?rvH_3C-BD=Rs#3{VxiQGmB@%RX<[>UO-=1mri^pZ<e}$ARAssYQARRi'InGimI}uIkE;G+,\
    5kO;{emWwAVl2>XGG\{s~QW]^r+{{rRH{V!C]7G=\@1$3epXz7<vQ#E{#l\E2pG~/wGla=Zauns,
    lB'JHuxn!Se3{EB@=uBZCV=VK#]{};I^Vn~->!,5+]?Y3-={rk]Ypz[HYOhgE*i]'H@,DGBJr^@!
    zjz@}jn3<e25V[7Wj7+Xvo$@Ws+#ep*CKolJIkpiNxa>GHeGYT^Kw2-Q2fjvU2ueJC1>H*~}'k$>
    uX}\$Tv=X,*e#!3=Rzg~>;B\}5BU-He3=3W)I+IRYlmoOun2C?<Qe@^ApWW7ttuT7*eej~#B5Y<^
    m[~awok5o~'nJn1>j3paD{KrBA1x\Gz{_,#_ln<XJe!^3K@VHKo2\Xfl;T'M,{p\DI}IUQZaB[*@
    R$*;~=Zzb}FWCp?e>eQFUnQ$jTowS\pOmc'R#sqbB;3w~*GvBzo\'zK3rG$mk5lU{G^>QD<WC5;z
    g'x5vFb'*IU{UXQvojBzGZ]@=1i1{]Z3AQ~w*>*C]\JYD#E{w'm+Aonp+m<<,{x>V}DuH7pmp1,-
    VC1=r'wi<I{Ja}uJQwO8~x*Y,-*^~[*7BeAn><\s;s~o-o3r9uXD@~^D,+xil{=ke7B_WVI$].~1
    7R$'^w?D';8O3wC3^YrwsWpJ*22{<jwlum@I$*@WjW[$]{_g*Q{j^<'snn_j$'W}B>2ul'Bmo?[j
    ZO3@?XAVKG,]o=m^9'ZKI>XK>7HI5gO@_m[u5U*um')}@-xKe{s^U[YGD<QTE?7^{2~>aD@^lC?e
    ]A@Tx=eVRTmm[R>@enp$]~Ev#3l_ERoJp{m[lACR~;nd[xW+Ca3#OB@vn$vzkoi$'kB\R'r^nw@x
    lDH,sznRM]w+'0rsO!*#j28^?Q$lkW+CE3kzCQG1;sm=wVvjuQehzKA+$,W}3-zT3-]BpiDnfS3C
    e1?VXUsZjI\K;XyhM7rC!}*O_7knJ5Tzl$ul[zR,-aV,kIJo~@15jWG@ZOW317\,EBYCkG~@oj^e
    k+TT2[a$lL*]jE8dO]YQ_n1TsC^kD7G1$G$j[v[~]!rZ@H[DO]jw.Hsv~T{\7^'OR?'rZ\]}[8*V
    =J:vn>k}~{JlGperHvl$>I*K]sr_!m{3oTE>ODmaE1B.Ok+Tb3{@+HOiE\+@VIZ*Y'ZQkCxuBoT7
    Ce?l[+DsG>OJ*C$BD{T_v$7DamV]@zHp#]$BVz3[n?a5iQ^BEG#<O;]kDaX;Gg$Yll[^,GVss2Cw
    3r-1}V~Y_Rxr$XV,EUxX3;1iXAE$+3I?EwTTr\p<YD8sun[z;H^D#+>faDiTjjr?GUK_Tjv\JjA<
    _+>lR+jC?,mVpU!X5@GxP#C>CXX_;znC]Q=olOSV3$}VTI<iCR]?*>73rVp[D-$AAl5lJX}*wKZ;
    \a*bvn\{o\Kzlm,i1TI]C*'r7Yrul~\Tlxjxeo]]R#\C]u']2DI[;[\vZ_^[Iv}?'Tj+=#*?7ku@
    2V\='^nW=e3]OIY}[JH+nspY0D!w'^jkra';KIZYVv$ewxmo*r*seC$ri0C-rU^uv@dnI@lnT+=f
    WIJo]C-n_@w73Q>e\QW;3|wzw\V;K1plJTXvll4Y?^*He_ZrxEvV7I$4^?K5n<w>),e+k1m5l]'j
    xJ5Z_[jiCF*B>{v'oGU>Z_WEjvulWDy2D?O\'~Ab\kGIC~~R!_\$v;@=G]aU$~'wUo<-a_$I0#On
    @'Wn_=Kaz0,^p?VIep,n_K/_Gs>sl5T/e<*+^@'=TzCil]<B+E[1\j!xOKuD@5H*uXZxEKHVms,p
    mA$x*mm*~tScvK251pzVC\j-~r]>#A-bW{zR3e_1Btp^mxXO1Y_lp]-D,\9U-I-Jr]$ED{D3oeK;
    +Hl8D,pKC;}s;{<3#-uo&O1TRqQRB!!Lp7iu6QRuHElRVKQ+3\VB*>,OvsAjBhnaHu<\JvbYx;*J
    VEiEG@TmwA~Y*JWV]Vn.Oxu!,_j<-Tx[,o[1wjJ;@o{#SP#T'!$7+O-smY'2ZBE~eGTH{QGz=Wh}
    :i^#-Tv?[[3;{xFR$U#Or>*l_l<GY@]s{av*7noWNXwzIxZU}#xU1aei}TDOGD~+=9'GoX}YQw#7
    <2oK'I[QsDTpDC0-I\U:7XwQxIp^DO'iYH[j[*=*]EJr^?Bsul\_lnw^J*N.n-E]j-!XP'voJ_JJ
    +a1Q_zu@lXrQshB]>~|";OlH>EwBVgRX<uJ}sT:G]lv0^}prHeAH3]J,[2e<@*#j[n~XD]<\=UQX
    JVEDO{Z_EiK[VT!Q-+CHGy,p3AzJA-y4<]QCs*n'J{ru7vo5Vp'Ue,Qji-I@;]!eLADoa*}AB?_H
    rc0<'O,!I@T;$e{,Wn\zEHCo~xr)@B+C[2X~o-^O53BuxRG$5\T\IYDu;]vDWBDa'OlRvR^>jl1>
    m'\}$2w]Va@-[$,X>+mO}-;=r;,lX_5e?O@zEC1w5[m1[HYm7prXppaCs_+Dj^+x[oYeGH5QQG,k
    X^XYXwVuVOuO#VJKC>oDFE5X<5GU7pS5}WD[Y5~B^iX?5W~kYs*RJ75\}K'I<vas57!X+;WeWz*g
    -O3\D_AODw^3iYu_2_XAT7w~jjlegdp[-lwlUTewIuBGR_>1s!CWQre#OviE,1oB@@Y1ApQzw^,z
    HkBJX'CzX5kU~~tX5OuP=aXVwTG_>vr>[_X@u=#;@__W)FjuHkOGwOK-V>$^?mE1Ex}C~om]n{];
    ^Vm9-n,lQo-J'Y{$p]i~.O+]@*I'rJ_F'J^o-[#[@1GuU9\nTY#E}<<\^vjB1!Kan_w{_5Kp<KIU
    Wx)oY;zoW[A#v=Bx@31BAJw,_V<^$KmxKxTa\pkY7\1pCr#}nun^;ECer{m!=GRUTXvYU'iH'$p3
    aaHrT{5C;ZkEJDE^-=VB{xW=G;Zp>]w5mG7QxC5wGn#r7G!]r,j/'r?nl$w;UDvWoIXua'z+V\~V
    "m$+;k\l?%2>nTeIvZBlJuM9=Zp@1,!u,{vBY=UV9|{n}Gv=GU!157vTx@3s'$l5;n}Y7Q-e;Uur
    [w$Y'35-QIEnpG.YTTl+tHLJ^DkpBaD'JHjT$JpzWXDBI*]bGQGZX5!QX=BJ{=E\C@\s;x~w}jBx
    @A[!,mmeI[C3Djn$VKj['=wJB=K!^2YCj<rCv]>3WUX\mz$xIE-l)7>T_\@BKQtaw>RVu$DeXm3}
    <xQ-I2GDGm+u>Yr}YV^gjL{'U3&w>qGc'<D*\Y[oWslAC-TYaR\VQO=}nYC}mBlGz{ljxasuhJ=#
    j4Cx;5slu?3{BOHAClKsC\T^>*v1jK>>WDz@Gke_W[$jH[7+CHc,]wu>1pwu<^~B=Up{Qn3]QTIN
    T<B\kYw5Y>ZwmU5m;XAe4RBXJmepR_T*{D7eYXT!Ek_#=+qjHs@Oap[w^zo]}{p]^R[2_Xj.Z{QB
    4-9p#>HVl<;?Y]kYr>_RS8{e_pCWV$r^WkR=OC=-rpE}+jDm!z.VI@rJQm@A$H?k{ROz}j\I!DXO
    *Q{'\^D{COZGRZK5lCC*W=WUVewksz{llG>]@zI<_ZmuXwstp.N=}viWna?~[e[177,D-Bpe;-,;
    YrBp'YH^;I{Hj\n3z=+3$AIweI!;aY=ZBZ~$sTKeMp~I2ji}{>G{7^XE+}UOKv#r}_pB,Q#BwI#[
    n?amwn=Ip]>$=K'K^3[^piDnp}A$B5va1__H@x1x\{aZkL\2;W$]>Y@-<E[Hwx]Rl?T^GK~++cH'
    VU'D13K*@!XpJ*+AAuC*222>3,aEX@K-n[~II7<>$BwRp7eKzTB*mr-auD1IXUv+}Xm_'szZT-ap
    !,kQn*Y}D}oQD@#[7mi_>BlA=>'[SjJwoaD>2E[]\~>UJuH+YH7><w'1Gi\En^AX#mER\.]QUpx5
    Yo3zzWce;Y'*'QR{AO_rC;s-G1Q3HnoO7Rp^#<@e_<Cq/Zj!\Dw!ReV}5]I#oHr=]'a~pRpZ!C=z
    Zn$?^7;$i]olRD^KGTeAG[H1le>Y*\<ekrJzj&}Gi_spWRK-^R[,+]I~w<Ca=UfiV#[O'>v6I'7@
    WrB[5[w\VYJ?KIU=3jxHa=K,3IUB#aZl_3U~eg*a1@$}?~~$kG?n<r=~52\w-E;\V?ZYlEkQBu!}
    7xCEmKo/eT^T!n!~2Q^pHTwu[EX\Ro{}~RT@o+3BzZ=]pOET$H7'~T~lmw]{}l[Tc;^Z,9#,5o|m
    OGj[+;UZDH+-vV[!\a~T^ClDnr+,=eW21ZG--aWPzI?DX}_-&E#@o,1nQE-'lz7'IJ$3U3\$zE!J
    uC7C*G}>1zIkpWA!ZA<^n]Hm\Em7BM++H!hCa,RiY?,D2o;-vVvGn;Y#=1@ZsjTX{1UOj5Bz\r3=
    {jw21Wa^eBKf5!{Ep,a<E-7,z*WzwGRCG_YUjlp,cB+^?,J{lIv!COu;_ww<rcZ]Xuj}*jDiT]2U
    J>\z@5XoTvx'l{HvUj\},V}Kw_bpWCs]X-<+xAmG-xr@D~[v5s$gO#Jv@R}@yI@KHU_Ok>UR[[3,
    GI7KvL$C[oA}GvY<aCzj{lHV1u\n7,eKAaw-slx[Q'v_#~S7Tz]$}[is**5\1Z-VK27R^?jh>1k5
    pE5!'e=iCC!jeVwl^77>$![Qo21B|3QGk7;^xV7Vbhe!B^*VUZ3s2@j]VY!QzmHpO2W_1+K'<wV[
    _,rVBuTl~le{KB:y]m]7f$?!u{-z@52UJr'<{E+@{xR\wH[@5>'HGI'3Ux1o*!RDv?VvTS!pW#Xp
    ~#?}_1,E@pVr*JR#[n}<azxIp_BBep|+\en}CiuZR-xZ+vD[_A~v6xn\,QlA#@7T^{I1QpsVUC?+
    C}v\O]Y2YCH<lpJouEV+o$IW\h}#QE\^{Bn{j#W<nZ]wEm^xvujCuJUHU<,nz{E3jAaEJoC}*V5J
    $#*\3ACJ]~?X'Q^<j7Ae==%p[1Z3*AOGe=^{IjB{6dxe{K5p?3urOr^WX\o77rxsOJqpwzamnTE*
    BBJpY[Y}=l^=RY5['4=T<G=-T=@7E1q^1CH!E^KrsXKzXxX',UZ$uAj\o+^>^~-$_oaITX[v7]Jn
    H!vm>ZQQR=;'wI*apTG(*UB]3^]YYWEQ;OI2l,+Tv;}~rI-xvvKBgL<x<OJnmAY51<~HUvJl\Q,V
    p-Rj${D>ws_3xl/!Rrpj,3JMHX+x;[*-wGp2-nYW$z~ur-u*'=nT;\wUF^CCK'ZA[m=+G<*^\<_^
    1S"ljvQ_7<Ca=E=Bn*=Q?3n;55~7px_FUHvGQpI$B@WAZUIp*vG+-U'JNsf}@mmkUpGDO$^Urll\
    wwlHeG[GeVGYE}D@TH_Ia!C?l$Qr[#\IU[kyl=*_{]#2R7-k!<ps!Bl@SC_m{/-l\w$vIW^YX;ap
    \+*wEu$Ym-,W{GbPE~-Xt;YoOlT}sri5sRCr'HsBmB<3?;-^j!IVnA*X1jYxGBa~En}k]SeYH[]E
    z>\1C]]7L62Tr<Y*k@~{==u5^*@53>l;r>[@[H$V\p'=weaOIOGjI5!rBU#_Qv;[]Qo@^x.}v{\j
    /B{+lOUOxZUCuOl$O2n;v*rp{RJ,pT+*$p>HI_Xo=BW3_YC+_mp-==1u$J[3W=Wa{fWE|4eG@QD+
    VJ1ok5$^Az)~vsWITsJv)REkn]fs!]_riOXxK<@Q1aae$[iJDv~li>n[sAKOCG,e]wGHj>'YAV7Q
    Y?o'5r]vnA#Jwu}9/\HeT_Ql5vV?Xl=GZQ#]OBZpBCXU[}Zxs)'+[\]@aZ!T;X\@A**px2M*p_OJ
    U\BTDp{#I-^HDoZm-YW1nD$e9\RR[5kZCiTH{feK7i?T$QG#j@~}@mr!'A@D**2A^zQpxnpYH[}l
    <A*3Jam>~Ku{l,I$A[,cG,a#GC3jx5TY2AVz?VREs-x=.[kOQF}5UA^=^_~GRUZp{',\OHl7okG2
    [z\Gu11BTA7X!YBrJA}{<KBV1k]lC,*!{$7?E<5HTweI37s_B+_K[VYZ>O,,H$7K+C1+~X5I<XK_
    7@jClppAJ!Ik^7Ei1#g2lJVjIm$QmsRa(ws1'@n=A|[1ri';X,=2E}kC5>Gz,p<$$m*YT*^\C]D_
    Y\]jA@:!QWD-IkQ|rjvj]'-j[i]^>XQ7cPC+KZv'$=;Vu}*%<_RpeZQ^j#v1_r5KTO\am*C*huHr
    vPra~>l'D^T7RYzk7;NTHm''3V1oJsz4$DnmjA7UO^E>KDHw6s\_@}O/dDiuA\H2wQK3B<o==6jZ
    lT1}"yX'>_bfry,uj~W5U=7HXnB$zU6Kl~Qqv?$u|RUe3k-\rD_A@X{@BHD;eI^maEDD5=0&]@*v
    VE-U9^]I<=;+\s-r5uU;5oJ>_k\OYm}P#C~O2<J5$AK-z*$;*,a!R^@GiV+-wOsGctFxI<jaVJsx
    D+1FOBR2@YB7][5v[nD^A\jw=r-[D2}}Y-}Jr;[n=WWWO$i'o\,l>Asa0{pH'|BI7CC^1H{<YTns
    w~[ImuQR<R.]e,~;sC7Oxa~oTeHY5E\[$XpCnuGi}XA2sD#[J'HEr[#V_U[#w[7RoeG,nt}Z>l#X
    D7{w^~z{A![@1E=_3osl+RT[RT=?Giz235uUo*\>]7?Q3;]D5U!|WToz5_2_A}iUADX[_J<[LChJ
    B==u*\#|!,2~\#o~F{6nUn^ulp[i1'7]2!>C?A?2ER@yk7R2t/57up^ABl\]jV[JA[]*om5}A<7l
    ~U$@Dlue!\ok5upl'@HYo$BoI11Cpu\3'a}m,R7X-riwxk_YDx]m<?T'<I$+<]3}iU!-Hxx-aueD
    ^Y*7zJ'>qD'+x,De-Y@[?a1iQlaGrgv;,Bm=DBO1}@#}_{T]-sE@KT>n1aJnQT(;^lK=dBI*1[Jc
    CM]_GAW'a^&a5+Ga'}]915ZTvI1ZG@<_C<mZ\VB~wxK[~zA]^lA{vs7O7=m~@,,T2]QrR1Zrj[ro
    XG\n}~]E{Aapz+!J2BUju[R*iAX7W>DC2TOxpe<\H$@]iU}$V1OD:n_RIY$;5ujCVxWue1XBZ^B^
    @==ODu}nK$juZ/]mGADA,>U'C-DE'm@1mIvojurr{7pp?RCornw^iY@am{U$v2S?>BW,zRGdJ1xT
    l$D2p5A>}pDGX,*oQB?spC;*RX2K~|rAKl'^[$]EU\LIw]Tw7'Cxk>Y'!@}IlQKY@_jeI]o'anV_
    mG=}]?aWr--w-5A+Xw7a*opLl@~D>UQ>=O^\^wY,AnB'ZIZ#{Yv5(hd(lff#YYVie-$*n~o(V<]x
    ,$3Rv]H}uQK'Or!wxI@ve*!A~}JT[~;uRr@lj>su,z^E[s{2W^ooXInX%B=![RE}nzlwZV1EY[zz
    x?aIzWj~wQ-'w:]QAw]K,'e}<u-oz3!o@$=]{uQ]|CoZ^$|IIJkorRH+H;G_W@VYl>Z#1w*NRZ5v
    K-[?dk]AsG?e?;^une=~OJRnjux-nC>[IE{e\xKWQ=^7u#=H,s<n_ToCvR5ZD\]1;MIa-Y^rkQ{Q
    $Gm<$Zo[DREQ[joE<WTsw]Ir-jVVaZD}'*R<I;JxA'wr@-Ax-ps]{V\1DHOHBstGoouR[$2/r@W@
    3-w^aR-'D~s7l;R!zH@l[;3a\Evv?$}T7~CE{j>EvADZ3zHjHQR,pjwDR,_x=5B=11oCpTy[]j5n
    l_IvlXQSmnjZ-l35$T3kpJo1+BG\ABiIr'Uj}7Krw*,7o5K>_KW@gI<GAG+<$oH_BuB<*q[$U3pu
    ml7a[roDR}vi{2;v^=AsEA\a7I3=#3iHTkvY,pJl\,;eDeF'_ETsf'}eYo4djp-!$*j+t1I{\D[G
    n*$[75wB7aQQm7=aR3\eu[Y=!K5Dx~YuB^K,oxzoRnp{upJCTWrw<skv$+T=B/I'_r'E?'@'YlTE
    3I{Rar'sn1=EoHl}HJrE>X>{K7n->Ty_W_zb[7EiZxC@1,smm<uXT7\GF5D!OHlB_Y7^$[uxBR'X
    X}aoX~\o'#-J_lnuWBQ!aD,a!YB5nQnDJewJ?_#=\:?B[D1'JUJ<'ruCOo}9VB$$I!Kv*HoXvk'p
    EmTsBX{VB#=^a{TEir;$R'K'emRT,e@Usu![V?B,s>+C'XJwKX2@?I?;xo,2>G#7=]e$f\]r>urU
    Z0^l;ko1?Bz5+e,Woe*\=5];>2GoeRKRWplGHGlAlUloV*z?]]Ge<lsHpUM5OQz'^YOTGKG*5onS
    \rsJ^^\kYwGmmj,<1[uC_A<#Oc^x#7K],i/xK-nZ,>{m,_!RCKj'3Eu=+\J^\\UW><*\<,z'[5Dz
    nx~Rn13[@~!^WQicO]k1j>A[k-Vuy@Tra5Nsa1Bkv2oc_<n[vn'AVx2a6=_op5_A2T^-mxG'3:7(
    w[1';{X#TprCx<A*1H>AriD$Dzlr,i=l'{[eDTn>>pr=ppQ{JTCsr~xRA}XV0WoG5xW[AMO*\i#]
    ]jG*rmj$l,?'u<&e3<IPKRrK3ol77}Eaj;$ev<w@uBl$7p~]${]2enQ#nj]wapj5]zi^u^w,sZx@
    G~^,V~U[j\<Ih{ampG|l27JH,K7V3w2lDex=5Om2]'5_KwWV5]{xk;1z~5l2I'xpXO]V\ljO5#KJ
    xQU'D*{_!t\vsam+@w~IZZal>~b_kR2\@zVeDYx5epuRa'[,\$C1VTBC\\,C;3v57Q'O\>~ji@\a
    E[AB=U7@a-5csB-AIAnJeo}x;}KBc;'RT[DZjPoQR'2w1uHr>]aw+*}KJB89'-7#]+[Z$<YV3V!J
    >rwWr{pK~n_@EJ!'oYC=M6=I3k[-_D2|?Qer]'_#YkXl*k2^P;j_2OAXzCV5=iDw~]VRX*xCXX}U
    Wvw*IC_aQ7#X{]o]arXA9Q!-@($iCWae}x:\YLG#E*V]A5]>]YJxs7<Q]>@o*l6U7RieH15p?u@f
    WH*RYp><.}u[O*]1mr{W3GO>=i<Ksf7UlY-<;@^ha5wD*m=\KBR3KQl5;Ev?HO~5AsZr[};Rol'G
    $OE+lp+#]TeQuj[*[~a;o*ZVOi[GA,zZ>sJ_nV]z}u!'D?7j*~J1IpEe_mIpdlsJzx5Ou&IiQCM!
    O-<R>v,]Ro-_~122]-*iRW3TRaE@+C]6RUwAJxr#a>o<da_WT{C1]uVVZQx!?pA{C^p7VeR#1Ol7
    HhEo;+2>DW5C]Q17r;=J-{_E{=vQ2C_#u{2$iB:g<w2IGl+IBI+zMlJ7Y_3ouzD5};]#KwH]}DO7
    JZN1IEXW=j#$X@32Dz[?}io@o$mSE{<^s1ZYB2RRjpE]YZ{UB$Q^~\+_}JVIZs{Q,+m!nl?Z<,VJ
    oV<x2s-YVr~B@X5@Y\Zv'I@]iB=K~a\G{[=n<sIRSYXCO>sr#jIzle=_i@H!e4ju$]o;I'qAvEzC
    CrHPe2j[b,;.'w<w,,'zhGK2~l!HrICX}5~^\D'$wO1REoDGWnaxA3eYs\CT7@AQz\s<$~O3Tpv2
    QvTQwsGX~,R?Zjnp7^@osK5\s,~psI>6qxU3~V*IXkH!GU5>-BR',},e+@Qx<*Dz^2XUXHB*vv7Y
    kiYr{Oe+$pXVHww=E[[,@E]_sU\',Z}\TlAZ-eAeRCO>k7r3wq"l*2xYUQv@Oe{<z,>Dk!Ymr,[M
    m>T\T}*zC'DT@<7<\O>H>D*<v_C\l}J7,x+mH5wr3Bk'{^UY{rrlAjEY^;vlpzQDk7$v?e}*->pY
    &;+>ClKsBY;pow'Jxpaza>[Cnj7aXGg_1R^A^u[PeB{x>x#x@e[Q~_#]}W{$GJ-ZIavDV?\QxpX<
    ,#VoVQ?W1H_3y8H>e^$KT=]I?@^kwwOJ97Vrae?_3GaX]uUBmP{ex7!O}z2aCYT\zOTVjX.@e$~s
    DKA]EDZ(=p}up-R]j?UlTlpB[brlD*j4u>~xJe[m:x33ku]*$+1ZR*$*[$['<'}Y+.li;;<UK$jY
    h#jwYXa5?s73Tu[@VX\m@>_;7ssvXOQ@KW-7C>}>]jQp3=aArTU^@Hqpwe{2-BD'Dm3RxX@oi'5x
    'WkAvE7-n{Qk]O2I='76\=5m\HT^1GX5y*2>^u>!}_r]T3V,OB;IC$_ADD52C>]{~{YRs~sTR!Cv
    Ol2H2p,A}#j@;5Q*i*{$CO2_wls}C=+$psQ\5#7$\Z7>m}m__(oQ7je;=iD7zeIm=-l2CjHBmaIp
    ~13[Q>$B+5E,V7wr_!=_+$;=~jCr!*K(J1!Yk'EV]-<Cv5'3^3WkfE;O;rDa<O;@1vWWue@Q>7~-
    >#\~2,![=Qo~3v*52?<DJWjxVkr,JGi;WdpC!j=vI@TEQB~nV}R$-o']e@A'Qo\-Z?,e$R/<+^HP
    o1!*}rji_!+GprI7'mw?_OD+gW}lZVO;e]wX2V&@sJn\'Y!O_{OR@''Q$?x.2I+W_*oUp}lsJI?E
    <DI{iD=7r{mA+oi'URWIvTVro6\+U!U<IX#{ri?<w~9Ei{{v3{!zZVY+{]-]z1WCI3T;Hdzm2m-B
    opWUVHH5R-DTsxl*p35B{2C@!]0$YG--,$,;(<<Z;>'*jiYsTnVnsO@BXX},\^_lHT=lv{]=E.1k
    ;nE'<lC>n<{EYeSvTX?O{mB#A7xOBOGwn;3,1Kw'l!Y'eXY_*TAH[TJKe,[!'-UwwE$$ACuIpz,*
    EQ3*1lW^l2*BWn>0RWDuvAuu[1?Cw^*7v07IDuTOxpu]jOUU<m5$w7~}a\A\7m[;Dem+s~4R;3_N
    kD2JYH>\QRK-x7,^{RY--ABK-<m;Z1n5~wT3]*i{7pu_oEX[^D>U@HIEz3mv'rA~G7j{z@Ws]V5=
    s>GJiv^a*m]H@p5u;r3~1VQC}WeGZYj1e?!?*}!^=wu^E>--]_=ipxl^|UTll!_z-mn>e;5nAykR
    rj*z\Uv(7IQE;x^eW1{GsYK;,}a;UH2TD@T7pz\RH}Dl'?JnUj5~XYzIJ[=kVx*KD7Jv]e;7AOn{
    DD2@GKp5pWY]ZR-e[G^uYkRTWDKU,J{jx+>Kp@m=xzJp__={u^x]jQUEVD=V;l{+Y?^*]BnKJ]@,
    Ua3s^JuQCDz5,&QIX2{z+IVoK-XY?V_~^'G;mBV\C#B{o']HXDTp{E-{Oxh)U*AK$X@!I5wZem*#
    OAJ3'7kxrtF^3\'ro1!IxBK#eVWUSQm}}0csJ}ipG>KCY>#{'#!rQpaOW\z"9:&EV}l$]G-C$J{L
    i'R>GZ{u$A7u>,E$25mWEcD[\T!GK~;{I#v@-Z7YD2471HZfa1pl~wp1^pAZ)}{;r31+VBD+Z=nK
    D+TGw,WeCs[$7$a-;~&?S['l$JlZmlCovC2U>\o#vklpsXR'K_aaI7I52u*pz,3}CR[?}ejBINTe
    7YBJ]le752HQ5WBv_E9#VGI7IQ{gC$<nozaY-oD}_r#$w_T{<.9\hm]A=|_$\7loZ@j]?@vksK=B
    Z$$BGza=k\-=p-1J*5^HKTj;7BH^!nH}}H_]$2ZsCw>-zR,~3pzm*]i-7VGOa<tq'I}_wo_3>1Q~
    o?;*]O$E]p2Z7W\*!}Ql0lEH<[^I+d7~l3?17^G|2$uYI5i-*b;opK$05j=Ga<\_n\B;77;*GT2+
    9m1rD<,_7rpWn$u~G,Ar~{EkeBm@a1Jsk1RC7~=UB+5uXz@E3QMz!KUOHG^b^a^D};QT%DX,}v+o
    T=ko*l?(k*a3'k{\=sk~I#TB^Ia]T=#nx[sQBHsWUa5BlJ;3L!AD=@]i$+$UO3-*vj{]xC?K$oR[
    W4lxVi*jX;3B7vmwsZeRZ_I=I;zial3a-!p-_X+IBE%]xi'i*s#W>pn$1VDRe1K@G'A>$J$@]el3
    12pT_m*I\pWl#T>3],~'erB$~75ACAj3peG,{$rX+Q7]IeX~C[-n]iABN+}}z$Tr]wQQlzjC+&za
    m3Dm$QvIK_,oHAeZEB3w_<mIU[m,]=sp]H0fB.0HOvZwwz2\i]$1K*[]V*H^==C1]Ve@[vAZ51}C
    }{3X7[w;wx~{>xuCw=}\~DT2Y^XOOlAG!<mb=7JxY\lDsWJ_r$JE_HWx*uDAYH77iBHA\p;wrj>I
    >Bn'EU-W\'IYs$i[{pEu4?R#J#eU;C1Eu{e@>VUXoW5kZXU+I$_eCKzx$J13_<[HvZ<B+~T**[!B
    zp+uA*IOG#G]KiVp;QDkO5@^YIO#pyjo$kEix~D7pUR+1ei-@x(I[i?^DNA+7Axp#aQW1Wv$xVB+
    ]Y_pQ3;xVp!a7~KE+O+OoQ|FzYD@ZeD;B-22j^*DQaxj<7-;51i{6iI#z5~oT]z1JH$H;pZ$pQRR
    #.WjpvTr'-EwpKH\n{o_VnL=!}G73ToGY/HQRRte^X[vjw2Q^X[C7_}[#YJf-*upr_x>BnBr2xuE
    G,17]uX;T77DDkV5DW5uxx;#$Jv++}i<nTOn@U3D=?e^@xsE.z*7{YU[v$1JZ\*R]2l?l>O#}n}J
    $ao}?z+x]#a5EB{~GmYO=(T&knB*Us\}!'x+D[Zp5}*XGl1HCiBD'urjwN~H*5>-7W<Q7}R*#;37
    !K~L]kr3;=VKB{v]Ij-lnCG]0,ru3n'~JeiUk^2='YJ~;u^=Ho-1-HRvVlC]p+[<zxU,ODA2Ge;'
    p$Tsvl7$m$K[Ei=Dj@<QA$[mEM+o'}kN>-F>B$T-DQisUw3}3O{g3,_i+>zI5^E>CU_O,p?]io''
    k$ewH]TuCUoav{[AGUJ$=lzZCs!KfmU-'*]>=,;A}mB7us,\UBE~[ZR@=OD*]Ho~}@_JC-n[p?Rp
    n3Ck,nT2*yUX1w=Ds2gHs<,=m{uk,jAw-oC5OYu={op$t=J_[+j>]Hst*r{GxrgaQ+H;sE1]R@UC
    z+212=DR]R1R~*T[la~/[x?o;YmQ*naTrVr2^^\v&7Ijl)C@XlQ,+^IrWu'O_Rvz__O;A>D;Ua]O
    [1vZmAGX}{_;rV")8~<o\\Y?Trk\K~rZ=
`endprotected
endmodule // module vusb_hs_dma_mem_arb_bvci

