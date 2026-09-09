/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_dma_up_int.vhdl
-- Date Created: Thu Dec 21 22:43:12 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_dma_up_int.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//              Vusb_hs DMA Microprocessor Interface.
// 
//  This design is a simple slave to the the main microprocessor interface
//  one level up.  The purpose is to localize the DMA specific registers within
//  the realm of the DMA design.
// 
//  Register Definition:
//       See Reference Manual / interal specification.
// 
//       The subset of registers contained in this up_int slave block
//       can be gleaned from the signal list below.
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
//  $Date: 2006-08-09 19:14:11 +0100 (Wed, 09 Aug 2006) $                                                                       
//  $Revision: 169 $                                                                   
module vusb_hs_dma_up_int (clk,
   rst_local,
   rst_local_a,
   dma_up_addr,
   dma_up_datard,
   dma_up_datawr,
   dma_up_wr,
   dma_up_host_mode,
   dma_up_async_adv_irq,
   dma_up_frame_roll_irq,
   dma_up_usb_err_irq,
   dma_up_usb_gen_irq,
   dma_up_sys_err_irq,
   dma_up_usb_hstasync_irq,
   dma_up_usb_hstper_irq,
   dma_up_stream_disable,
   dma_up_list_base,
   dma_up_plist_base,
   dma_up_frame_list_size,
   dma_up_hst_fifo_fill_level,
   dma_up_hst_sched_overhead,
   dma_up_hst_sched_overhead_tt,
   dma_up_hst_sched_backoff_health,
   dma_up_hst_sched_backoff_health_tt,
   dma_up_hst_sched_backoff_health_clr,
   dma_up_hst_sched_backoff_health_tt_clr,
   dma_up_ahbbrst,
   ep_tx_prime,
   ep_tx_prime_clr,
   ep_rx_prime,
   ep_rx_prime_clr,
   ep_tx_prime_break,
   ep_tx_prime_break_clr,
   ep_tx_prime_break_set,
   ep_tx_pprime_break,
   ep_tx_pprime_break_clr,
   ep_tx_pprime_break_set,
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
   hst_complete,
   hst_complete_short,
   hst_complete_fail,
   hst_complete_periodic,
   hst_halted,
   hst_reclamation,
   hst_frindex,
   hst_frindex_last,
   hst_frindex_inc_hs,
   hst_frindex_inc_fsls,
   hst_async_en,
   hst_async_stat,
   hst_async_doorbell,
   hst_async_doordone,
   hst_async_addr_ld,
   hst_periodic_en,
   hst_periodic_stat,
   hst_async_park_en,
   hst_async_park_cnt,
   hst_tt_astate,
   hst_tt_aclr,
   hst_tt_aclr_hshk,
   hst_tt_hub_addr,
   op_context_ioc,
   op_context_ios,
   op_context_hor_link_ptr,
   traf_task,
   mem_arb_sys_err);
parameter usage = 1'b 0;
parameter eptx = 2'b 10;
parameter eprx = 2'b 10;

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   clk; //  system clock
input   rst_local; //  synchronous reset input
input   rst_local_a; //  asynchronous reset input
input   [8:2] dma_up_addr; 
output   [31:0] dma_up_datard; 
input   [31:0] dma_up_datawr; 
input   [3:0] dma_up_wr; 
input   dma_up_host_mode; 
output   dma_up_async_adv_irq; 
output   dma_up_frame_roll_irq; 
output   dma_up_usb_err_irq; 
output   dma_up_usb_gen_irq; 
output   dma_up_sys_err_irq; 
output   dma_up_usb_hstasync_irq; 
output   dma_up_usb_hstper_irq; 
output   dma_up_stream_disable; 
output   [31:5] dma_up_list_base; 
output   [31:12] dma_up_plist_base; 
output   [2:0] dma_up_frame_list_size; 
output   [HOST_FIFO_FILL_LEVEL_WIDTH - 1:0] dma_up_hst_fifo_fill_level; 
output   [HOST_SCHED_OVERHEAD_WIDTH - 1:0] dma_up_hst_sched_overhead; 
output   [HOST_SCHED_OVERHEAD_WIDTH_TT - 1:0] dma_up_hst_sched_overhead_tt; 
input   [HOST_SCHED_BACKOFF_HEALTH_WIDTH - 1:0] dma_up_hst_sched_backoff_health; 
input   [HOST_SCHED_BACKOFF_HEALTH_WIDTH_TT - 1:0] dma_up_hst_sched_backoff_health_tt; 
output   dma_up_hst_sched_backoff_health_clr; 
output   dma_up_hst_sched_backoff_health_tt_clr; 
input   [2:0] dma_up_ahbbrst; 
output   [eptx - 1:0] ep_tx_prime; 
input   [eptx - 1:0] ep_tx_prime_clr; 
output   [eprx - 1:0] ep_rx_prime; 
input   [eprx - 1:0] ep_rx_prime_clr; 
output   [eptx - 1:0] ep_tx_prime_break; 
input   [eptx - 1:0] ep_tx_prime_break_clr; 
input   [eptx - 1:0] ep_tx_prime_break_set; 
output   [eptx - 1:0] ep_tx_pprime_break; 
input   [eptx - 1:0] ep_tx_pprime_break_clr; 
input   [eptx - 1:0] ep_tx_pprime_break_set; 
output   [eptx - 1:0] ep_tx_flush; 
input   [eptx - 1:0] ep_tx_flush_clr; 
input   [eptx - 1:0] ep_tx_flush_set; 
output   [eprx - 1:0] ep_rx_flush; 
input   [eprx - 1:0] ep_rx_flush_clr; 
input   [eprx - 1:0] ep_rx_flush_set; 
input   [eptx - 1:0] ep_tx_status; 
input   [eprx - 1:0] ep_rx_status; 
input   [eptx - 1:0] ep_tx_complete_set; 
input   [eprx - 1:0] ep_rx_complete_set; 
output   [eprx - 1:0] ep_setup_ack; 
input   [eprx - 1:0] ep_setup_set; 
input   [eprx - 1:0] ep_setup_clr; 
input   ep_complete_short; 
input   ep_complete_fail; 
input   ep_setup_tripwire_clr; 
input   ep_addtd_tripwire_clr; 
input   hst_complete; 
input   hst_complete_short; 
input   hst_complete_fail; 
input   hst_complete_periodic; 
input   hst_halted; 
input   hst_reclamation; 
output   [13:0] hst_frindex; 
output   [13:0] hst_frindex_last; 
input   hst_frindex_inc_hs; 
input   hst_frindex_inc_fsls; 
output   hst_async_en; 
input   hst_async_stat; 
output   hst_async_doorbell; 
input   hst_async_doordone; 
input   hst_async_addr_ld; 
output   hst_periodic_en; 
input   hst_periodic_stat; 
output   hst_async_park_en; 
output   [1:0] hst_async_park_cnt; 
input   hst_tt_astate; 
output   hst_tt_aclr; 
input   hst_tt_aclr_hshk; 
output   [6:0] hst_tt_hub_addr; 
input   op_context_ioc; 
input   op_context_ios; 
input   [31:5] op_context_hor_link_ptr; 
input   [1:0] traf_task; 
input   mem_arb_sys_err; 
`protected

    MTI!#^Z_DcRTDucY-AZ*b}^VxETD?}13$@au[:|e|Pe>&OVvE|5xo\xc*V/@RK5<1z=h]BpU}3-\
    1kQop+D?aa7KE\WH,o}C&wa7[Iw'mrK_>p^AUDsju-jz?n$vi+sXlk{H+YMaA]D1[I#FY?;z_6pa
    5WU7YojCeA\$[^liQi$Xn@G>DQVED}R.21*mTsc1i_~sl=HHzI!TjJUwD>HeCAjMJC\^G$}IjW\Q
    }oVpr][ODWxA?oz2HG2,RZu[?THllX>]$X;<O_G!#57+Q\AO+Nr;CQfiHV]YHK$mBi=I_C@=r5z!
    ^5}Y<+r47eza;*]B{eJ!IHlT#=T72EI@,mpw2lQ{U$uV*Bi?x{^3/3pb}v}7,!Em}IQk+Oo=X]uY
    ARB,Cq}ux]mU>_2])6,$O2@CoT.qGRe^ri^*N[Uz{(#\@A}J;#z5az{E$Yeu=j~-,!_'Qa!XAYsl
    z7!'<TmBR}5Gk@{[O3<X-HeT>A6E{B3[{;OBGr\]e{5VOAC~w=p:YY=T,mmQIn<'s;-u]n$#C^Q<
    -Y=!A}?_5{<DnoJV"_#wuVx2w\2XnVHE$*3Om55zGX=TKHGuY-R*A,}A;8#HI'X<~\7}A$E;Goj~
    \;gpK<>Yfm[m[eTnD;8uYB\{XaDIO<T~RA_$YHTEI-J$2-jYG^OLl5*J^i!a$xoQD^^5UzEkj5aY
    EX{ZI_5[_'VlYvwE7weI1k]JKX7w8ieQ<V,o>2RAm_5Jme?Kp]eX_XROm57{?T^XkR-z?v2-j-UJ
    ['#rOecI2^?-O,<t#A,e3>v7j$~V$O*v9e23wNIuX}A+_nUo*1@}J7E$kQZ_sYd%\JAl@'r[mUTJ
    x~Tr{QXrHs5ZV<oW#+,pGUWv}.eekD>'?#Vjz[rwD$~Br5?Yix(-aA~WoYppZYWI{ZmZ}XAB*7;$
    &Je{'}#C_w}'o_'u-?C{acDj@2Y>2n<-mm~a$-;[Tu*$XK3oUBQ^aIuO*</UQAD%}Frx[}=Dl]^[
    YA]jw[K]2}4f^J!}Q#T'rQDk|BkWO*zYTs;n}j9sT'i1XI~$@*V6P\@5?_Zw'?R!CpIRInBeZ^V,
    k2xCn<,wUB2@aJ{${,*>V1*1]I{>AG1oKVB}HarB=e5JByjo?~ok^;PvK*\]zXUb=~CH3h^3s]\X
    72?-v,X>!K[_sw#GrjU1VX}'$]=QaHWOUX5Cm;^\A]?\OWVC{xIC{Ys$?G"U1k^5?C[n[+OOok!#
    X\Z~B>G9rr2U>VBDxfZCJQg%Q=O1w[E^eWmAVvK^a1,Y%a[7mUw$Hin}uVw$v1w-w@Up>2YD,.U5
    Q5#o^~(J}=DlxnvRpl^K\7Kz^o7$27!*UzYen]X~^_}2xU5U>a~}O>>)TT@'YIsrE{oQrHQk3Xl@
    1T+Z[~1Y]-UzN{\Tk7UT7Ax==H7n$o(uCYT?T~K#G1#zz~e2[?@p\,=9\=AKVO]$}~\>hBnp2fUR
    Y^!OCWkI<C\=H;x@1lr{Y5WIY1rarQI;+HI_Vm215=+O5}Re{Oks5ZZn5$K7o{:B3\$V!so3r<U7
    C$~T1am^@W~ZO2n{rQTaCJoZ_5T#$+^v_5TZHYOyDO<*iA1CU,jvDDWu9Io'@V>7pawnv*um'J5z
    [T\e3oKYlpVQTX[j{*3^Ee"=@7YRr<#cqnaj~_m\;N-\-EK+5-[}i\S)vZZxI>2<+_E-%$<A#]\<
    p<l7]'+<=gi}aA%@*\!~--vo+G]#=TZC_TY];W*5u~U$eOUnOC[+_s<CXl!BBGE=&$JG1!}Q]g-I
    2?R-{r$TXjxxTVjWpEupkpv\~KKCE29_A5ILzmXs*=$2,O*]>'TxGfzxzUAsYk4~Qo[kEw1kU>Ru
    YE@U<Jv[iTW^!eCyYY^@~{-Y5\>-]v?ecInKkLJ<5}3{,Hzvji}o1RlvY=>aR7TDo3[#2Ji$oR_e
    [7Qja]*V<REn]C{^5'pKuZCw<sz7;wrs+AOR5oja\v=>2A,kjHrG-n$jxpKjI\XVisR=?<#<V$H*
    IU;N;I7wDXE;-je+eC(v'xrTEOHWDw7cmwVare<ToIKU$;W#aD1EzVzo3UIpevnm+*zvT55ICXp]
    ^2l5Yrp=?l_Go;wQR;Oz]?2aejA$p_KeSv1}o}-E$j@5@J{\^Qi+[?IC}=WrjT]#<rO;?'U~>kae
    C@RA2n=3!sv[>LJ5CpF,JU\\WwOD@-![Tz;D\uXu==-_U27<}_$]~O}^n[\7u_2z-x7MXBb5m+lX
    VH_vsJDxKUxT$VjUDiWAoZDk1[<i5]K\rX]WGKXwG+@G>j$\mE>Gp@=Q*'@37O=!s=3{[AQ!V\lu
    H!sL,CDKx]BAdaI2~V$uDaXop$@J^aG*12DBsW\Z3X-GQ=oR^i=3=E;n!EYV>IaG3)r}QEh($k*x
    D}invWB3+x{X7#=VoVo1S)iXEAvr1_>Am=X-UKkhCunvBxl^CerD<Q-2d_OB5P-T+<m*w]5ao^vz
    5>rK,Fos?OlQlpfwz{--Uh)ZwKE^EIjZovvEQw]ue#2,sGQov]v^V+uEVjzG2l2![j3_j-RB37${
    Cu>6wXE]Oe#>Ik+ul^O~WIWG$7#Z\@aXH$EG5mUE~5HvIOBG?a*Qv-K}-Co5IGm?Rks^E>=OzB}A
    [\spm_e-$PGR7=#T${D]zCE$okDQ]wpms3<CuJYm-;x+}}5O#@3,DJ+Y[vR}U!R,l=iC?3C;$-+N
    6@\JA[,]w1T+k;Rv,EAl=CA1eE'-QAsm;Vws[,ee^K<wE5Yli,mB!'1R5,*#?u7E5ino~52\Ip?Z
    K,Xl{{tK^7!n'>!=ZO$1^<}=7w;EHe=_*ep]rwWc3>;j@1#a*2X<j^#@QU{or^#K}*=vv$'*IXR[
    Or*}v*?e25O^v?${Os{!\nDXhG={*wz-BaRa'Kr,1\DHX}?<O{\}>Zw,TEk1J5\#JVezUhm_mGz]
    OBTHEzp73V$K_^+\+[K]5aE!qj>AWJs\+Js#GH^j>5J$+p5_7Gn;Guw@D(]~I-B*i'_OR<nYwGpY
    xm$Da*/TOzpKpnac8Qmr;qTV'}EeDYl=j_--}~&bFOVCn>o~ae_1RYB@AJY@z[GT~BuIo[nxEzkD
    s}?(nD[I5!j[L7kK-]cl'z3C~m^C;-ruX{5R}W!\$\{^Z@Yt}VqHe@Eo[a[~]R+'Tw5C[7u?^['~
    n@}2vvU*r]AezR,euskI}Czl]AQVW]izluk3x7#==7#>1Z;x~leQ>5KUruWe[*Jl}@1rD_wp-V<L
    9XYnAC3axs#WzJ+s^1UUY1}KI*?1xX']$=^5We82C^-?v5p."GXEmxJa~|?E-1*jGToi<-e!D3$U
    lVr'RDYvvYjv;Q*H\jaz#kp'_xAaU\\J0JI<CRH5u(+*VA#e>JiexnKpoz";voY+1;WDR*eepX*_
    cV2,B6&IAR*}Q~E,aJ!p,Uw>}<!u_aGS*H\kjECJ7a;}IzZ--Ar]p~]^7@BrHVYv~-1JM"=Q\^^H
    wOH-!O~Y$k0O]3]}eE1j_#?$~DrIB>B:YO@o7m5^QH@J&vD<lpZ=$Z,[353a{V}wk~Bm,5[JoGW3
    $qeD-2-D$v'2w{O=jCX$]v+EwW3Eemx]V#j$+pK^Zs&xHDXI$@>xwjA7U<vW>>v}W3W4rB=$5p,K
    pqeZnQ#[#=Rkr;~vTQ07zBAvXG\VY<x<5*1e{HApuE[*ko3Y_O'}>Am\s~uVl[BI53E*_~@-XsAZ
    ]+'4Br_!rD#EUw=?=pZwl*k;57One)C73CpU_*-O'pP,w<jr'aT!YUJ!ealx!'p^@VjR,O}D;e]#
    vIQHvKo27ZH5WO$eV5ZV'mn9~xv!nH2^G{m$UOZz*DzABG_OC=u[_=IR_}iV9xEj@JYsioTeo91T
    Ql;Y^DRG273BIo*wmoQ7Do5>HXRCZ^eEuxrx1w'^lkBB_oV}lQE,oDnC?W=npQnzJeM!+D;[;;B5
    G$Aa{{nmxpXIRe>u\,]YJ{*qj-DZ<U7G/sGs?Te2u{_UZk$*Ju5DEvU@Yls\+nxIn&\2lRE[nvKY
    !5(#B'='3Ev]7D'W1n#>wWBB~Ver**sO9mO,owTV*&\>Q{HYQsHDTv@{QEs?m+JEQw}OmDvGji9,
    VOGDnA^0sXAOR{DmRDX?,1s,S\*ak=+nV.ga}aBmsIo4B'W@jv{T,AA<IKp="d5w[nrrAE{ln!V>
    j3{(IX]C7AJYEpAmROQj'i>nIs*YR_Zep>m;x5l+k1iXIozzYTY1.uE<OAQC^iYBup[[i1<vY]KW
    $[X]Ui}U}^>;$W7I@_Q#55jTskVH~so{-KOreuG[#\}K@8x?KY>lQIx+~D;HsDoVp'@{wl#=Do_j
    j[^p;I-I^C7B^j,nBv+XY+X';B-p3ADOW<\E},?l$OEVjXmIGRJeG;'v@+-,iX<s]13waT-5#pv_
    l@p;ACmYUJpe1?2Q\BL*vBx#o{'iazvP@1ERe}_~uEm]m-1u-DGl#Rz][[x$CmHVzXsVN}'HZSs~
    1$YO{uIOva\X\Vk,u{'EH{KEa<v_\W1DTUv?T2Zj1~D=Aog2_@1v_i'rWM$D@*'OzCv7[{5vAB7K
    UKD1<DIH+=HwQVGxuD+*-T|'KmB,!l]07puel!wme$kTzlR=\CD[&C!skj]'Tw_[GoOzUH_eEHE}
    ;+YCw!1xR]o>\dB^}HR^E^rsB]l*lK-1Euwj1{r#EIlG]rnnK3~1eXvZE3I1j^^2!@r[aYAB?@tr
    JJ+sT~V*>'>rixG$![@v$uOe6rI2$Oj]#QiXeI1}xsAxvQ<Q[m=Il-To>1#sV:aApm{v,kQ_XnQe
    ~u_1rW'vVOe,6P]U+<x1,V7DoO{Hp7lBp}{e]=E;,2}j}D+arX<H-=9,^uGOOv5\<(^DaJQYiZsR
    npVZTjzxIm%pjG{IVm3Z]!u,5vQ,urZFF/G{u~[WvXj__l^$KXpOC?jG;X*J{O_[A~d2$_w;\VKf
    enIj}<u5R-~<QWV]&]#_}uIO>mC_5^BoID#]vUI?<\KjC_wen=Rw#]~7QB;DiYC]=Iu'>xn'nCp@
    @pO,n<5Tx3,palusB]xT[j!WsS!5Exj!z]ERzYqI'[3p;_5G2DV8r~@V#aw#UV+~[i*UA>v[^n^$
    $C?Yrm<-@<l}kpGx^{2;Y]\RV5Bm=I2nRzCDU5$~!wl#T-[OeeI=uA]po$es@+^j@*B3O>*Yu{sZ
    Hz5!-Rj,p7*i^jvsCBB^QW7xDu2=wpou27V[o''CDsDWNzWO^uE5pxm{up_wDfBilz;zx#r+AHlm
    E#8QxxxWIJ7IF^[Wnr*#A~v2s_;n#Dp>p|CC7EZlp^*xiTBmj*qKDazun1o-==}QvkU%@*YWrH*i
    Hj[}{D,OxrunZaJlWn,{_AoIzIIwYza]oD};R;B,wj{\R{Tn'lzQjxXEeBQ--7vav73ZN^jZJtp=
    m]GVomr*YX5eiQexvwTYs[QKU'b(><Oj{o~BWA>K|1,n}_'#jU1ARLC<V7W=G_"2T,$s?*DlIo!h
    ,7wrRD'Tf[_$KL^Um{<^;[D}C[1~,O)Bv;Z]@ZE5vTI,Q'kOJTCH$:^Ao+>U5GbnnK>Yr';wXH@&
    HXp#[\]2SPxj2x!o#evET[Zvm!3s]<Xo\DX\R=9C'k=>=<~G<TsD+,_VY'U2oIrrT'7?RX5?l>oG
    *;D7Ixo2*Ex>7Hw@_KJGJB7z:>l2X1~*-}lI\\[1TR3TE~Un}T}#(~nxo<lTrjxAo!CiJkaA^Czs
    $Io1TUGG':J+VC3EeG^@WaV=B[_k~*:cW72;Kv,B5=o$R(Ux5ze]EU-$[C=^K?A<O_CjXnaswH^<
    KTTxB<49]OBDJE!A>l,~7OzepGRI>zm+%w$KUZREw#Hn>3xvJWCR2T\auA[I2oRGWG4w1e$?l*pY
    nWIPD@]~{XBYn[v3^T5s'^iZEaX,#nJo=vkuCW{o^K*Z(z}QXO7Bjp{JKAADGXDu!up5>+on1XzZ
    O3^D=Bw7Tr}ujU1mV,X{H5uQIA\Xoi1VGMQ,Y\~*T'l^'[rC?XWaX=^T{k=QJ7CLvu-E+O~]~_-H
    !>npO+{Y5+R]Bpl*G}uT#w[vHBv@I^]j0x-]]$eWlma]Jx'+$,#TOeo?V1rB>?=DRza3;~VX*"G~
    ,Ia^A@<p-C3>vO!5<lA>3zWU[CQNxKGvLl~!K*;wUjjYp,a~BTY$XVek#paWlQQ,$_Gmzh;*xIE-
    -Wxx3O,k2,['}{yY5RUG7\,HHz~1Z;@C<wVH[GXO~CDZo51*?s[3n$m*C$~i(uoeuVC]+oKjQJl]
    5w>+2vxnxqE>V,-COJLvIC_R};*i\m]{GYrQVio=\r+H'UWZEU??RRe_TjskY?\I?Wr$2s2('WlW
    ~>r~kE3vAwlHRRoQMeiDeFrzn7onr2W^Ka3o?vqz@@E0wDRpl3Qjk'}mpvVBR+m?G2*lo,O7FUe^
    u^IYslCI>VV'vj>zYE<7#gs@T\1v'i^Gmsf^WYa;OZK$k-WsvJ^iIk[ZAv152]EemQpA{D^xeBZQ
    mWjq5?exY$Gi5kn=Lvo2}]K',#1A\v:Iiz5^\w}tj$+ZZ*$eR]\}'$?{uYl3_iQ];'XE!,{\YIXX
    Yl$[3]$JQ;n_JEZrE<@]REGKxZJYC2O#E{>^$?=JwlY[<Y*G1mUTE2};sAlQuDZD,7m'sTY@2l=W
    2o*ETvw1VxZsC^=n\K@E;rvz,A.jZWBkvZw?>H[ruHT$*EZ'u7X-5xG)nsK<2A_7.GBCK<CCUH$A
    3vX'u+G7@1[lvEZez!xssQkJ+ur#KYk-@2>3K_^sJ2spRJR''fVjD~-qJ{+k'T}A%[2=5r/ICE,\
    =Z#![nT1m3BLj8v#>$\C=m-qB'nARX@C=oJ>*x}n9Is<KJT<[OYjA1-]uzBjrB<Ur'O,l"w]$l3]
    kBA$=sPaHI=p7xAnCV@k>]}pGzUD+'R]so*=?>'B_]UAsBx2o}lI2H3~]sEzdlfv3GTvIAnB[3*o
    X3UkD<p^k=IR-+TD^R>8[:'J^VQIaj71KrlvTA,u=v35{2DEpRA7X!OVDI+A*e*mX\0V=Y!A,-lx
    OEo^/av|OvKZiRBih#$pZHl[#QU~^2+_xB[A@r'O\_ok2zHKJO<I*p/jEu,ldJ&^-\{uB;OOXI![
    ]W$snZp$kJ[BaEI&l!HxTHl=Yx2!AGwIk\J#=!j{\*x;Gw9l,\mi1>]f9}KOvXD;-wBkluOp_GlB
    jVrjv%Luek=(A*KJ~[xVAU+<nCeY3EaO$7^;2-G2<IVa_nl'XO$!OQ2XI71r1KunE!uD=nVp@wr\
    ^\3~KCJI#-Yk-rrJaxek71'Qk[WsT$>,[<oxTQC2svm<*VvUx;>1ox-]=j3?}XZkTo{m4jG>Gl>z
    {D'=}TvzEH>pOxOi;^jXWYj@{=eDA=*1u,wJ?p,'l~\^KFsrU*QT[C-j23Q,w}g2EU{,-{H}nVs{
    5Q3[?VaDzw>Uo}W3'$@v@EILsAm^@z35a,V?sQJ~^DWZq*V7oNoWzn_.rx;~TU^nK,'-W]^ZE$^O
    2<5up{_iCkpOCV]_>,1W@srX9I-;BXB+UKRsG?OZU@X_YA*_+~B}RGVXY>D7X~]e=M>v5Ew]_2TV
    jz1o;2Sv-_K;OiI~E!^,[7Aj_?uC]V<AXG@UO^knD?R9,$\<L+t,_E!LN'p_X[l,u;}-~$KaEHw@
    >G@[2^uU]&K,E=0J=<p-={nm<m?VpIpn$BlKz]vw5*urA$iGG\ww'A+$k\w~Y1JGrAT@$QI>lIO7
    2}W6YiAZ\$Xsox7[wnHDp^2EydzJ=^C'5x<n>_njo!nQ,\-]AICDvv]sjmn-IEY<*H^jl^'Z[T~^
    nrEX,E$E_2}3AuKezY$J_H}YIlrw*?+^1#5<31'00m|YVx>21*lZ11U\l1OZ7-@1nOlpWw'sIlBQ
    s1-eo[EnokTar1psZuI7u{J=!-DQBri?Hw#kw*}BQiw?pN|$UH[lW;+NS{[<l<{=k!XKB,~}zUDH
    ^4QD]BN+U3~B?7?y$-TlE+{*DgO^ne7#IE(f;+-[HIIrR's^58F31*J-5<em[+}AD-BoGn]wOC;m
    YJKcB}*Vf@.T_C$)=m]2[epQa7@1o#Oo$[#z[,vnBeIzK,#BQe3kE52nW=xED!{^d|l3@W';rouX
    ;m7{v$%[>~_:Fgk{Qv_sW@7RT$![WK^imVvk7COMG+;-=ZDevRknr*>!'B7?8R5k[mUAv}?''w5,
    zG';@@YKxlEzus7-Wi\ouZ,o@,}jE.#1Js/f,-eJYBs!AQl,{'zTb~jj$s_<D<Hlwv[B3?jjVCEY
    YYx*rB^JR=5IID5\}uDul^h;T^^g#EsmRw$wCl}i>7nJ$}HxOCwIR!5>~YH]_s@p,''W@QR3XCIr
    \W'eGzi<5#E1sJ3oooz;0@\^RD[-2a5J7?[;#zn,Q0G$J-UzY5ilievv2$e+j353>?}3AlJVn?Ex
    uI@B$T]JJV?_OrVix311x[vk,![{ort7aQ{rm,_;7~+2$D=wwlR'pABOvZ$pznAHn<;lpajxz+oD
    wU!4wACxyi'XTi=s}tK=}k{VJ5_!,Bp}r=~'GCy72wn-]{5lj3rk5DG+lYlekAG<ODvm&Ci~li1@
    XVQ;>E{BR]mjn{{_-O7iJ@n{AV,xHZV]-a^]pXTJvsvu#\AQ{vB]JG7'Y?Cw<d{$'3=w[$eiCifC
    svA{AHaaIAUaUGlD$#+$T;z_O_5V+oDH}J5O[VnctbL#+Q'A,YQAeQG?j{}QO3oIFvT3InG,<nN/
    -x+[KrnrLoA=obxIQ*nR5YEx];AVQo1@]e-[,A<-uaZ77GCp^'=^poG=V,Ws>^J_K$(G'3A,eQT[
    11=oEwr{<lrrw5s1@m5^unVN>=vHHo\_UC?XVxA;QazoEA~UJ>Y;o2I#7$W;7!@_$szid~Tn=#$l
    =ra+oVuEwwrie~r{siUTe"T-[i;pDw]jj;QJ]VjvU;=wlYs<7,D\[zzr>lkQ7iE!3Q7Xo+j1?B0j
    rOU$W{m'[vsxVrO~+Cn!V@o;n!Q#-K*tuUC]BKv[eTVT?C^ORUE2W\i^U}apCYXkuwe*J5xX*s#e
    Q<RQI;2^E^<@A+Ux#{>@iO#Yz57sOew\5*p~$]2ZD+\wi]kBg\7CQt_'[XFC\B<IRO+QAlo_x3#]
    XQHu'K~ZGuuR3ulI=AoP\B^GppOAv~v@Y>Za7!]uS{>\-HD1THx<Q3G#-:UA]uasTlJrYaiGAORo
    Um5o@#-wnXmVH@TRa;71-K#[Hn_@DQ"KUHUejC==@Y^zpen&CZ=Vfa+pu7,wAVR#'sc6*ml7i6IH
    Vap^=Qp-mZjJ*,Mr_sBUIS<s=lYz[[CmJ[!}[@Fx>*ioZWlorw3r<
`endprotected
endmodule // module vusb_hs_dma_up_int

