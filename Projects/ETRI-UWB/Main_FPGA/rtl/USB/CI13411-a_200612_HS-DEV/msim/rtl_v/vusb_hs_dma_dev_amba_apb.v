/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_dma_dev_amba_apb.vhdl
-- Date Created: Thu Dec 21 22:43:23 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: svn+ssh://porus/ci/svn/USBCTRL/HSCTRL/trunk/HSCTRL/digital/design/hsctrl/rtl_vhdl_ahb/vusb_hs_dma_dev.vhdl.tmpl $                                                    
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
//  $Date: 2006-10-03 09:46:48 +0100 (Tue, 03 Oct 2006) $                                                                       
//  $Revision: 333 $                                                                   
module vusb_hs_dma_dev_amba_apb (clk,
   rst_local,
   rst_local_a,
   m_haddr,
   m_htrans,
   m_hwrite,
   m_hsize,
   m_hburst,
   m_hprot,
   m_htypeinfo,
   m_hwdata,
   m_hrdata,
   m_hready,
   m_hresp,
   m_hbusreq,
   m_hgrant,
   m_hlock,
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
output   [31:0] m_haddr; 
output   [1:0] m_htrans; 
output   m_hwrite; 
output   [2:0] m_hsize; 
output   [2:0] m_hburst; 
output   [3:0] m_hprot; 
output   [BUS_TYPE_INFO_WIDTH - 1:0] m_htypeinfo; 
output   [31:0] m_hwdata; 
input   [31:0] m_hrdata; 
input   m_hready; 
input   [1:0] m_hresp; 
output   m_hbusreq; 
input   m_hgrant; 
output   m_hlock; 
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

    MTI!#es@\)u{!$i-[-$r'-vkH1@I2[nnTK\u]iNo@[[":CQ~OI,DQ2QX1?&[nJ\[Vir{js[WIipR
    lA1rQ~\zjp{}_[i|,kwAl<-VOAlWLVz*A2E<Eb#wDAk[C+_Z;!a51?XGBIevz+^G2?BHJzz3~aEW
    VA\X{\C=$Q\Qm>[_;uoWl_cMVw_;T_jx=EJ3B?<v;{Vp1xRU#[5j{YixoDn}ImTQHra~jc=>]$~Y
    mk$Wp-nAV+]@zQ[-Y[2N2\1jrZRAX_Zv*w@^om1!=m[jK*xHv{rB$_[@B3[ArsK@A,A7lA7}!YVY
    I}X!i+5sX=5_aX<X$Rpk7GaXI2mC|\eoj#A2_}rlWk[Y_rZ2AaGznlmmC-vTZ{nzKB!Q1WAp>}{V
    !k=#2!C'!xcJQ*,{{<=9>pT~NzY<*_OfoED$};5]E2jO=\Z~X}13+>RZhFBR\zdK$Ursm3T~zQK0
    eJDOre~T'2mF!a=\!OA3G!E1s[$QkaV~lzU7)+H5l^B2W,$2U@DD_Alff]'\Okz@V$2\u=Y;mx!H
    -T$=7N']7k-}#pI3HprOY{?soHS$^~zF#q^2w@}Ye2';uYQW21,-j{IW=BiU+-!vsruHUA{wHHVo
    n5"P}p{_q-Aw2o+3?N;9[#>V,ivY~-YooO<v}]VT*ir$9mR3WZ*!#53sJ;$XB7v#EV>Vkx82ro7w
    R-Xs1pHjlDQ1x-^LVj$17^7O;UA#\D5!NG13-BxrvI7Rn]+5J{TE$FAw[uDOGs>w'73ww$>*iwL~
    7l^]\k33=vJA[CSSiv}3'w$3~]>WB,'Il{[H?v=]_zn#h3{Ap'vR+Swr<,?X>m2]'^/lUole^IO3
    T*~-\*Ju1\]OVOVmT}[G^n+zK<*~$ITpo2\\{7Tj#VZnVR!ul$HKaJ{1{>[dB}oaIH_iA]l=6nE#
    ~hDT~2$jo^7I[_=rvusxE]wCn+z-^2Q\j-pB,C73uw*UAKD2>uDlEUx2RaDp\a+vC3[<rJY;C[}*
    {}rBJs*i,'h5-@DsZ7<vF'P[^zC-O+uTvOC7VWXsp-]XvCDR+_#s:u[\ojn]YE-)uG[=1Qp2PA+D
    R@w0'eXIG7Z2[ZQTZ5uuW=7^wC73iTADa}roI#T>lVw{Q]}_:.:"?YAQVV]Ql3saWs,1sYG[r=~O
    lBIBj[$T-5W}Y=?+%T9glz]ZRmQ]\z@BiYppQUo{HvD#e~aYeV>\o1n+SY#o7;RkWKrO5g;$O#o{
    KxT<rTDO\mT+V15R1C[<wU<wp*ApiC@E\>O[-Us*Am]n3*K<pjX>o>2^W<-or,9;T>[GpZBR21=@
    eEk_mGR\5mZz@<mm_pV,sUx;Cns@pTo}j5Q,-RsN[JA*Y{7WsJ!#_,QH-_Zk2Cm1ZH{2Dzi1"UQ>
    k^*7#GBx>A(]m_EriY-w_'C=5+7,Vv+o{vI!prk}5e5QuA]>_o,R^an))k[r=P$e#2+$-'~<V*l@
    x7\#T}^4~Uxoq',v#i5IU^ZX2{G'{Q^Qv:x$UpMV*B!-C>C\<+uR=O@3pAes*7uo1Q>!^[_eCT[e
    ~Je*<sK>Vv{)rQ>?_Jx#BpYBpJBrt^X$}XlOo*lGno{Q_t.'J[mf1DinCalHs*{aQi=_xnl\(?]x
    *zKozE1n<kr\zp0C{>o5A>W$=5'QmTz*Ymw>wR]oZ~?kH~^oW-l?Ow}'?7}}>a<x.Ekvl*5X{JTH
    kY]*\W_x'^3]*x+=3Y^Ixl1EB'x{\rjAG1KD>p1^^2[kWVo5Qovx#eIiGrgCE~u7oG?\AJ?Q}$er
    UE~vT}m]*Io5I>QV-5Q_aH!I_GH\W_>jAQanAG{zxm+C=mWoH1Ws1p[}n}kn+Zzr_}$>n,eCRBvY
    51=BAZ}o'UQx>;sU}w[+s?mbYv*^\sA@Q+jKVR[GV;u^\5+w=<DQ#1YR<7C=;ez[Y_Q>j}a~rB#j
    oeQlaaAXTawkC'@-0AoX#<ej2HCowo__*X1}\--'Zy};K1OAlC2'mxzHnk@'xQB~2VokX1^-,nRm
    G_[-Qa!Vi<DTG@SZxU#?R[IBXj#noQxK75\GeHTp5Q{^V32+HJTHY_iOJIwX*3@5WAJU}K-a'kxQ
    aKvU+\}*sBu[>G>BpEr}}EOrZBOBlQQ%o}um,{7$WCz-'3Hle^AD,Y$TtY=R55W_o-\U3*w]1}z;
    XyA$J]{s!u,v>~']'2W5OV{AUnVeX,Ztt$<]T'z=,(z$\pi**VOG@,75~#x+n'z[DHDCJj1YjZ>x
    ^OVzXj|{sTG'p3Y3sAa-{>[V]u~e>Y7!vm;j'OEJ_'X'z?',O{{kB7R*T!7u+z7}WU^Inos!e}!*
    Ro5>zAE+'T+K^O;^zU-hVz@},>WEWEg5DIp6kD\Bl4Q~^[<TDG>+=X7Hnu~>zZ1-wvKYE;tB2125
    ,x}z?RRZl$~#Uo+~jCE,BsomB3?Q]aJ_2pjO^{~YCJAoC3}}2XJ@EWA}+HT_R-rQ-vlf4?suR{5u
    jIGRZ'2C\!ws(Q#DiDsIC7m[WIR=VoAx>Zo;,pkeHsuOANiUBVNK{Ja[@KATEJ}[?7WR1J[eYjBe
    o~I+5+?c#wG}i,3'FWD?nkl*p]an,Y~smX1wu{A<pCa\3^pnj5zr7}>zRm,^TvTYB[m;'$RJ-vX3
    ]p$][f(<'!nKVJ{Ni+5zz';>l'3IwEXUL+$Ye#oWAtVA$DCG_u>pnmmr3m,jjW2]nu{}AGVY%tjx
    I2AsenOHYl2^[=,Z!UHAXnSz?pa3H+2<BezG7nYOl$sXYHKo=ko=Iws,2\UV**Vm'eA=X;^~s~n2
    Y32^]Ro"^Av{H[Y_[heIEv/5!7Q4v2l*2^@~_\3u]$IoMk_Hx*e^T,a{Cw5^]p5oXD1lm$Q$rx<>
    ?A>+;GP='}G<,PGDYr<>*i>>Xuf^~7JQEj,}s?;FBCelTzH3x?U=p]oOo-D}WDEQs'eDREpVQAm,
    C0n]vu7AIxg:RC<BAar7*XUClO$3!e;Jop1sRmH}iV[D=JC*IE3$O@{vmoQ^!n]7J(iU<RA>>\Ga
    p-BA=au{^*Q\}YEk$Qr{A;0=@<z>+>=v};E/D=$Wj,5rXQ!$"!R\{_T3p;_}=ITz;,nWGlWviXR{
    2,Zw$mxAG=JOGpHYuCjDiRQ>\sO+\ZpaTWEE+iA5Ci1-wk<URBQ<z',}==?e}[BGRkeVxZDvO=OC
    >[WHpF\=e,jI?];IRHs;}~7Cw,C]mCszBGkRGD<,@Vj\#X~]anG1<pPC\x=Oam;+o1TOwwOrQEGz
    d^>+WFJ^x$H=ZWA1@ov#O[aQzWoWa@;CE^HG3YpV~G*'I5kpC}p^Znza-{*m{s-U;2;ezZZR$>#I
    [pT<}E_{Ar<r}{G$wJlW},p>2',3;^VR?j[3^!T-,uGwK3;lwEYvEH07knTp_ArB-<U1+uoC2UIC
    !][9,oBoYx+^/dv#uTs7-,_5oV=K~ex5aC?n'oJCru=Yn~N,EG+z<rUl}ajB;!DBmAmU$'zU$R<K
    T]udU\i<5U,X6Q2Wm<a^'EG}}zWTuI>~G}aj$Q'1}[pQj6F'{5A$*?Oz\=ZZvuE[Z3?{*#W8$@X[
    i';{Qpi,I7CsE?ji<[xw>+X5n\!AQ\E@57lZWI@ruaumBeB$;$QzBB?TW$ZHQ+1<OCa>qYYZo:I{
    !'rB=Yxzw<lun#j1?T1TC?kNQuzGI=IxQ!-CB{\K@1]piRv=@s+_.B-vwo,Y{O_$?4Wjej(Z7uC-
    +zz\}x7xI-Rxiprk5-H{s>=IIW2vA}j^m>O#1i1asC;X7DH#Y[srKnn?vZ>r*Js]zr_>7AVXE!XQ
    U3w#<\3CJ>K{7A7x@aY\lJk%1C#UX\!@BGn_V#QxG>v<IHKG__1_,k>Gv@l1Ookv;a{O5Eu*[JT5
    J,<TeW!oB5RZ[#AUPD1QrW<B~p3<]v>>vDpVz;E+x*$~7u[17+_k@Zne['j+sKVm7x7BG*$7_G1-
    lD1xw'O$^z&AD}X27#Z*H~[Cv1w\#*^Uw,JnlUj[w'#qd$x{mDIu?("D1X2>,vBW]RYUr?_keaYq
    3vZHQK\~]n;RRzn^.Q+{Az[#eEQC]O~+[^i=A7o<[=V!mUv<2]s-C~l5E[UT+RT17+$#22EVUj~R
    Wo^3v@Tpe3AA{a,_C?li<lHIZ~H!!R@mGk}!s1sK;r_AXXp2@<CX[^Yp'J'p$U__DxeUV=O3}geD
    A[{G##h#_YY1[??S,AC1Q'PDKwk5/<B-V0J$[VE~n{Hn}VTL];l=BmaQ!^U#)@R+sqIBssoiBuS=
    JB5=_Q,QH*nzjIG1%o$,O5{Keb~75^MQ@EBPEl>]5}Qw/7pJBH<l#^jZ\+\k#sC~]67AYOo~-Q~n
    j'r$r'SkROpJrAvCW+TCIUWk7pT'j!DuCEXG]n}[~E1[FP#]#a2TV=@Y-*IV=m'XDwhG<!R#wD@a
    GI?C[a!BAv[}>K-=ZV]?VpCur?ClK<l<=uw=Ae[~HH<dE{jC64K\-]@*o<5[H'!CVpip^pBknKB]
    B!a-2@5U>ut%3G5xD-UY,aZ}A$7R,7}lW<CWb6}?}TF*H=\v{Q;;v,j]7>X\#{Za^Ee)-]OG1'eu
    [Rv1vo5{QnsE+wZ2&7<vBia{<UV'WJSo'k>HIpZ-w\_~jV5G<>@yUs<pWU\#]U~Kpoi!-}35]nT1
    @U+^2_TB$I2^,j{x:sH{_u-vEqBY@#EX$3x,[WGa<7fB_r1lClX=D],r=$>D\?Ql2Aww][,[*u~o
    *$Z@[]@{a@#~]'vc41OmYiDp5E#[ZPIURve2^oB=[r3p]<&I!W@UQ-J$Q?2ET]UK<Yl-_eX)Ox}s
    +j;aj\B!A1-0[CY}R7zEiI+E@l~DErnU^a]QDO'B#<o#i1j5sB<Z_}YI*uE+wB=!rmV@z!Y;_#H!
    Cl]BnwDke<-v?{aJYw\2Hx_>WejoCprGoH-<lnIohv~eE*B,RHB=ee@D3T*[<MEW<{*'Zow7i_O@
    ;-knZr/e\;{SETGoOOCaRCDKQo*nr@s[\IQV1T32GZTx?v[pp_r\h#>*+-wC?Wv?GJI\2p}X{_5C
    Dz?_>Zp@shvR@jW(r!U@@vYXsC,V}2]@<wQB~RmJs=^^e;Dv:lD}s=xO~xF\V'AnE+E\XE1J<TBm
    Cn-n*w)V}ml^_1Z>'7m'AnC}G<vi_3r+T,}1s,>ERsIUx\oro'K1AE+k[+sDxA@Da3{7'exeaUwz
    zD$!xixpu<-{-W<={ss2Oa#*2{ZvpmH]EO!,],A-_]WC7$GIAK@aes\u*T!s$wwsoRB__[uE5ZT2
    wQUroC]8Dp>!J-o=$paKXCTC'#K]zs=n,n*+m[,U.JS;aeimAW@gKh&Rg4$i2Ehe!oQp!e7^uHpo
    aY*mIxTOrIx^Rle#AYj^W<Jt1K!\ie^JMWI{;u^nrI$R3So?AW<wpz(kUxjirEG'zTTuIWHJ9"I~
    j[E~7iw'<;I*O@vGIx^pv7|gJ];+1~HkRk\~lxX#?IQ]/on-UYnVw[3WV<e_2WwlDE=?xJXpsO_{
    [5T*3K68#<]{;<Au5<ap^2<xl+nD8D+,I~Ek^'Zoi*?V[vxQukl;,?OEIT1{7X_U[HoK;2n*],Pk
    BvvH{_*n*oU]e}v3*z'[~_Wo=;7c{j;xg>lGT[,-l}>_,H<r3R{u[JRi2OAT~SWN]G?KIDIo(p'-
    OpE\$s>IX*Ep^XxH1_aQ@5;[k=o[3YaJz]@=QUTXxIE7Krk\nD+R}X_v_COo-V]jkv2]2rK;\-nu
    GBUEVXxj@2-o<W]mm3IlTV-\z]aGJ~\[3p3pw,1Ap,E>KQwVOej*UvuQkqB{J2p?--Y3-]Ek<7Q?
    7Y$1XOT}D{,lKk)=pl~zG*,-AD+I*m-s~DTBY3p8e'5KT}ORSeYsn;X774>eHU][p?j^{B=#]n|I
    4.f5R]=a{r3{5kB!vEZXsYo*51wp'$mo'7CCX2_Te@w(QjrB_a=2YjOpvCAoQ#B<EC^VmRC7aRr'
    Cm1Q^-jeJvs@fH*mu!,J'D;-[^\<ArB<lYr[Qv5Dnu]}3Qp+^_kl}JlQoYp3!;\@5j27E*^nv$E?
    1Hs,@x7>]-1<>+e!Kzp~1$UDw^sEed*zr;\pekmO'vXBTeI'>3I{O?eK~_1Q_lC-EY7Y3kk'Q{XY
    aUEOA*S}$@1zsjR@-!]IUuU\@jZ,knY;C<u]<{{9Y'+]?s+}EOJ1Y^?Gx!+<m-!v7i5o**;TR\xU
    JVK+E1H-Ma+axjrUO2pWao7o-u<v+ezR]xGTOG;nV'EJa$GK?pO3Z1mapWsnD\Xxz>}OeiYlBbok
    UuBRmutVAV<$Br^,?auz#717i+xiAU?YT]CKjX+={-QBoE[e5Ir-Um\_>@p>Hl$gD!+O<D+kkUn7
    <n1E"pEra3Y]Z!sj'vrDe$1eD^I]D\233u,AvDCpB?a}up^]TUBe{~>v+3+_1\wJ,^i+upbxkWrR
    X7u1}OUA-pG<p7X<HV7Br>ro]lXQ3spVJr}CKOUevmXu[,CZz?~m-8!XIEzDe?\wupzTBvoB'#=;
    <{Y#[pcQ{T32Hvs_]iuR+;Bx~^@{+]$OKIK\Es]qVBoI,\Q@G]R]_^@@5RBoB'KACO<_l$'WK^a!
    Dk[!$DB3*CU\sOeZI@]!/B{'YZzak>7B^;R,z*CuA)#a*C\7rOQpZlEkHTl7V@7#pi;[mDYLC3{r
    s{|IQQ5m5oeBEjio+Du_,o#I/K{1+Y}W?j$'{Ql51=rDWRY-a'CC*\!jl$5}n=7x;z?5jk${k^ID
    jaLmE-=m'kp{jKRTDvVe3-uYs_-GkYj!\_?e^<Cbw^+u2=_jZIRAlPji,xw-_x%m}G?e?Ajv2O$M
    v1H$YQ<^['@xXXvG.17@mtv+QiWxH~zV1x7WW7Om+=8^RA5luJ,]2=ro-Usi'w;Sq\E<@3X!!L#R
    QV[2Qv?+Ej13ZejW~I)IQ>\n<aoC4e*peE,KwLZR~*eT<sC3mDP_B<jlYBmz=ZY_Vl=5xn!k<IaT
    [2nvE!H[veTm\XzK*<}zaJ~\5',j&^wsJ,Be~kBT7+_pADU-Ei+==BZ^GQYXXs-OE;T!V[}e[aDH
    sxZr<8-{}>V?wIB{nEUl@u}\Q>~^Q'H1KZzs,K}~~Ocr*i1}}E5AX>KY=zx+z\7eWBp__ikl3ok=
    DR!{_O5,}xra$@arZ\]I!,s&x\s=)EH,EeaA!<r=25*-ZJe3Wk>Dv3Ira5!!JWv,El~\OoUwo+rX
    ;O{nl^*17!^2'x;XJ@1}1\im~6iGARK+Wvx=_,$]'wYsXU=TJ]CI$Qap1C~e^'wGz!zr$JrB#o]'
    1mzE{3+C?f~{xu{G<HH{ZTRHDTI#_wn^mo?U[};C@pJY*=[e{1,<3ZEGA^ElH>I>DJ$~B{+srs]Q
    BU=n'C@\ksDuARoeUsET+Tl7xIH*lpGSZoiCd=B#T}G\J3l@rKCY{'k,jQ'BEEkKjsK+1mwxUz3+
    7Z[#![Z{_K--~UBjac^[1=v==]UrJQ%XoCe61ZwVx:<TQClE!ovkZDW,l{\A-'Q2s!fKVG?}R}pE
    $Ca3zn*\HnoGHG[QUO~OnJZ~QO'5j$Ju7a3RGPX\Ie<6pu1{Q^Ajdo}s<j#<j5Jl2A[_WTNEQ*@}
    LNO>s^kR<_wG_w#jz@rB<A-*BWT[57awAZV}paI=T,v[;J1WTCC0N!^o'>__T5Iz\m_e!R*!1%xN
    QwW['Y${,vE\1o2{YBl2wpp+Y\>u$2w;V3<uQmvrnnBGlz3*!wOH\BGr:jJX1[AYC>Q~3r~;[Z>A
    Qz]mHK]}[pREjW\n-D#E'2\*+1~m]in]xIA}EYH7ji5~j2nJ-W[n]@Aj\D81x\!x2XWr*~Y8'kz]
    $4;=[ikU2X-xU1X7u2',Xk<]r^_jKIoQnA>AY@zU+^VY-=AHTCRY}ex@3^_{CHJ*Au-x#A$7D72A
    Z1KQrK,5?[2C_JIu^#x2w$2,IA+eB}7Jr+vu7k?<QWo!=H1ur3B+R]C<TBT1an{C-$(_!YnIv@w]
    kms0mUnW$+Zrz5VUR'GR?x>_@{T2!x]?g/Z}'Y?*Er!sp{V@Bv1RxO%],CQ5!!s\x<pr*}DM}vrC
    7RYG,?Ov]^joH'ok\RUj-wKwG,ls*umpCn@TzM5}#-C_HQQm]sWe<Da,nK@o>Us2uXmeG}xjmu_i
    -RVeT*iC,wrzAe<Qm$a'<u;pDKBD5Vi[A^E~nJ..2Ci-Fr[X,7A[Z#I>>5:xWGC*Wo^#Q*W3{$#7
    sKTo@'!mn~X[1X_!\2GXCaJ_auG"oi$Z+w\QN3'RC<vBZa*mV@7\+ps?~\=[D^oY=>I{Ceq&[[=,
    '-BjEl7QB@<+)'x<{G#{G2x<a+a-^3A5TeE2VR^'Kx1puDBuCIQ7Kp#BZGOj,Z*DJ,!U[]#5ieW;
    \'T+O|*z]5]@QT^H$k}*-rIjR]=GXvz66[n~'O1*D[OQTQ,*{uIs!k,~*o}p>4T^A-al]\lDpCi5
    kp*0v2x${j-#{lKK#xIi2{Qs.iwI!M{pv2lDDr}?>;+_7{zB?]5sH][3GG3\!\[=na[Zw[wA!Gsi
    'Z=\[<J$_uGO~TI_z#l2sv1_K@VuOw2VRQwwaY%'bo/XsQ}kT=$o$zj\Zeu#pTTRT>7po3eGOkD!
    QU}zE{IJrCG+a^}RV]rOlrj{UBmfaG<Ynx@m!YB[TEmQ5w*[r1XpE}{2,G]T{Il[z![x['>3ZHrR
    Rn]Bq5A*T']ArZ$_U-xlTlTBu7=DIzKA~/\e,J2^Q^.kY$u;5+O(7@V$?_[,\BT;3,oI1mUkBQx<
    ^$2Drw<e2pN5!W-sI!'<vK@$)yx2B,zDj_raB]1r->\'*}sET!vBU-*^~rAT@z5H,TKz3Q$URB3^
    X_"kt16v~ZQCnu'V-WKImCD~5H<~=E>$$j1v?EEUw_vCTCiHO_oIj}]lx~'Y+K$-xIl_JWxmES21
    A@VOsH{OxxEATm'Ee<\Ko1&DomTi$jvR;*XVzs#:heCkW5v-55(^$=uvD5?};pC{>nmImW3GxY!I
    1DJMS=,!Bv.aepIQs-ue]TI:xpEW.!x<G<q/ezLvo$CD>TuxK,#Ivajp<mI=.x2mJaB]l_eYo,3$
    sreawO!-B:Z'+DpiE-zC7?2-xzGvwG{$Ql*B~AXo~U<oi$=]F};V7_2zX$^W'RvT;Dmj,a'Vv^[<
    ^+=$Ij>aw#9VBeB>=EnK_KE5<xiwUY~[_2>2EO23=D}13vi,kjZFoa{{=~pzJI#EBvoH'2ZQ[/}^
    QE4W_z!z]}+{<UVG5#acB_Aa\l?#=U_+B7{@\=,UOUE+pk1min7;{*-#}3oB5IsmskoUjJ@EXO2!
    Jj{WlCv+ro7=k{V7<1nkE0=ING]*#=a}1e$xUIw,vZ[s~YH{{<eXK~YBX.9Cs?[N~BZIDE!>Y;<~
    'JX53R;W<R~@L&"[BKXpKpWE;D{~{QG$VvD<1$[l-+*s?E!=ZYEQDDuK<}2Z>H+=iu]Z}AU;'Ilz
    !Oi>s-?feX]GcN8Wa$ARf]2*'LO+z=7O~H*?EQJI*R\_kI3rkE&5UlB'Aj3K11Y_Y^Z1XV>8x_\x
    2n}E}X<KQ}kU<o5,WG[G_5][uw-v@-A3XCE_v]k_GRU>Kj]]O@ei~^B?vU];ixg%6Ol_2X=iV7\>
    [{<]T}E]JaR^#%G{RoCYOKTO_;~rG~cbP;_7Y\X'mEXUOoOp<^z~U~5~rV<>A_I-!h*mA2CKX3<$
    \<,#H2C*;ZJ$,Q-j<B;Es*Wln7|3Va_~U!KI*'WneO],p<uB}IsvV*vnVm}us*zLGWB3<|?[+,'V
    IOQ@=Q#RWvCk+o7;J[+$ZTxxmp@owxjPFnx@_IHT_*3<1OsvG!V=wl#>UTwsBzzm-|l-{D_1p2_=
    ;zh+'lQc!-RD2lE?3]D?jWn,ROrKieB+KQC5TO}uK1Epr1n,toIrrO#CjV{sD,H2z@v5=zpru?Y]
    >u_;[=2rE/2j'Re{Rv$X@<[^E}l1>ClXGmOC@2vT<BZT{[!loj3*wENe=p1BV>Z*>THK_+wu+sHe
    XUm5sA>]{1zZ$G+-w^?joGR-+o^_iDKOW+7WHKklnXkX^w>Q2sKY_Jv\re@sVj2!Y?R#s^R]~oen
    }RKJ,7noOwkv]7v!{>xY2zzxX]DrHYul-CXpu+j;1wQsDmDKwvirs?UUV~JBG\1!C3}>}##ls2Ga
    *=xzw7@Tw[xJT!K#-a3z7UIHTV2E1'7+zD<Y!^XwEm@EZ[r1<^vR\Bj3o{v#O\_MLyl%7opW@An3
    eA^]D![z?tD;p[1[~p,i
`endprotected
endmodule // module vusb_hs_dma_dev_amba_apb

