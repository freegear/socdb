/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_dma_traf.vhdl
-- Date Created: Thu Dec 21 22:43:01 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_dma_traf.vhdl $                                                    
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
//  $Date: 2006-01-06 17:41:13 +0000 (Fri, 06 Jan 2006) $                                                                       
//  $Revision: 2 $                                                                   
module vusb_hs_dma_traf (clk,
   rst_local,
   rst_local_a,
   dma_up_host_mode,
   dma_up_stream_disable,
   dma_up_hst_fifo_fill_level,
   up_rx_burst,
   up_tx_burst,
   traf_task,
   mem_done,
   mem_done_go_again,
   mem_done_overflow,
   mem_pipe_sel,
   mem_underflow,
   mem_burst_act,
   dma_tx_full,
   dma_tx_mark_down1,
   dma_tx_mark_down2,
   dma_rx_tag,
   dma_rx_empty,
   dma_rx_empty_ctrl,
   dma_rx_mark_up1,
   dma_rx_mark_up2,
   hst_traf_req,
   hst_traf_req_backfill,
   hst_traf_req_backfill_pid,
   hst_traf_req_done,
   hst_traf_req_rx_overflow,
   dev_traf_req,
   dev_traf_req_ep,
   dev_traf_req_done,
   dev_traf_req_cur_done,
   dev_traf_req_rx_overflow,
   dev_traf_req_update_fut,
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
   traf_tx_ep,
   traf_tx_data,
   traf_rx_req,
   traf_rx_rd,
   traf_rx_gnt,
   op_context_buf_cur,
   op_context_buf_fut,
   op_context_buf_offset,
   op_context_bytes,
   op_context_sbytes,
   op_context_mpl,
   op_context_zlt,
   traf_context_buf_sel,
   traf_context_cnt_act);
parameter usage = 1'b 0;
parameter eptx = 2'b 10;
parameter eptxa = 1'b 1;

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   clk; //  system clock
input   rst_local; //  synchronous reset input
input   rst_local_a; //  asynchronous reset input
input   dma_up_host_mode; 
input   dma_up_stream_disable; 
input   [HOST_FIFO_FILL_LEVEL_WIDTH - 1:0] dma_up_hst_fifo_fill_level; 
input   [MEM_BURST_LEN_CNT_WIDTH_WORD - 1:0] up_rx_burst; 
input   [MEM_BURST_LEN_CNT_WIDTH_WORD - 1:0] up_tx_burst; 
output   [1:0] traf_task; 
input   mem_done; 
input   mem_done_go_again; 
input   mem_done_overflow; 
input   mem_pipe_sel; 
input   mem_underflow; 
input   [MEM_BURST_LEN_CNT_WIDTH_BYTE - 1:0] mem_burst_act; 
input   [15:0] dma_tx_full; 
input   [15:0] dma_tx_mark_down1; 
input   [15:0] dma_tx_mark_down2; 
input   [3:0] dma_rx_tag; 
input   dma_rx_empty; 
input   dma_rx_empty_ctrl; 
input   dma_rx_mark_up1; 
input   dma_rx_mark_up2; 
input   [2:0] hst_traf_req; 
input   hst_traf_req_backfill; 
input   [31:0] hst_traf_req_backfill_pid; 
output   hst_traf_req_done; 
output   hst_traf_req_rx_overflow; 
input   [3:0] dev_traf_req; 
input   [3:0] dev_traf_req_ep; 
output   dev_traf_req_done; 
output   dev_traf_req_cur_done; 
output   dev_traf_req_rx_overflow; 
input   dev_traf_req_update_fut; 
output   [2:0] traf_bus_req; 
output   traf_bus_req_again; 
output   [BUS_TYPE_INFO_WIDTH - 1:0] traf_bus_req_typeinfo; 
input   traf_bus_gnt; 
output   [31:0] traf_bus_addr; 
output   [31:12] traf_bus_addr_np; 
output   [MEM_BURST_LEN_CNT_WIDTH_BYTE - 1:0] traf_bus_burst; 
output   [3:0] traf_bus_ep; 
output   traf_tx_req; 
output   traf_tx_wr; 
input   traf_tx_gnt; 
output   [3:0] traf_tx_ep; 
output   [35:0] traf_tx_data; 
output   traf_rx_req; 
output   traf_rx_rd; 
input   traf_rx_gnt; 
input   [31:12] op_context_buf_cur; 
input   [31:12] op_context_buf_fut; 
input   [11:0] op_context_buf_offset; 
input   [14:0] op_context_bytes; 
input   [6:0] op_context_sbytes; 
input   [10:0] op_context_mpl; 
input   op_context_zlt; 
output   traf_context_buf_sel; 
output   [10:0] traf_context_cnt_act; 
`protected

    MTI!#1IxIGJa~'\1HvuWkxCeHYwp~[1W*C?7zF:|I|2N7~Y'Ajl^5p\+=#!p~{DY(w=2+[3z2u^W
    IAvAEOWA,2YV^R&Ik_Rj[o1\;{k+E}JUlJ3'xO38=Z=jmC3[z>Xkl1Y5u>2H^=z{]*,>Rn~*f1T_
    O}VV*Du2;}}v{YIkQ'#]CA_{$k=%'LO^!COYl@qV1d@^'wzVJmcT*QVCURY+,XJh%D=D7WYGkVZ!
    }3}zH'GO_DiE{@A};Ii3VZnIBxTTp\5;U=hy-<8b}$}iUon\in7Tjx<}WX+l=7nQ]D5Zk-BTw[!U
    sKJz_mEUiaTAEzo'*?[nsR~*=!+mC*R@v,TOQkHaE+BA&Fm-g?'Vni*-}L'7npm'IO^W''UjVe5u
    d5?@Du}#@rG7s+suwE]ezWekp^kD\0}m\BG>XWgR,''JR'WxlwucKj-'V,K\11+,X_]kDaRr2[BO
    @w7pIr*a+<YiHDrR.*Y]7UI{*;lRpT<~x?AX{ITY$[#;W5BEon=Z,ylG,AK]!GWajVnGv_BnXBTH
    '7o'ZoGC!,H-V_!C{O}[nnKDnu'[#OyIXm?[WDzUsJ#tvTvpD?l,7JlD2Du<D1Arr~,v!<lYK+3<
    wV~p@OY-uO-*]3=i91@zkiUY_oj2;)^ksZ$sBn'XX~pp1s*dI}2n}m^7=uAW#_*~e$kx*G}\K-!~
    LaC~H<7X})BJ{=uHBkcF>v?Z$#]1j-DIy$nxOJvQnF;-{1:JnqAVW@E*3n+A@Dp,VJ6#z\,*-j<.
    tWR<AAvQ<Quz[G{=_[H];WV]UPC'QzLB2V?<vj5sH5{\\oQj\n+o[UUC{sYr-$aNNax7]lWOReCQ
    V.YHs+zl3j7;;VH+Z$#1>CURT-5}o;h,7CA]~j_p#\OCuuZI;B}KY$?!T7pOlKeY,B>GVQEwl>Ok
    =nI4/~I,O+=Y'C'Ho^pU~H>uX<Bz=lW{\X5KGuCz12smTr{5mgx#{[YjYVU]^Uw1OZ'^5^jnuUIs
    E1X}<@eaWTt7TY]!rw=^#,u$JR2sK^},rr,G>pOu1YsiT}VBQ?7reuX{eJo]Y^uH{,<QGn71zDRJ
    lXGgYU[5^37]\I@-Is}Eu^{uOxp!3A^QW^5k)j${XSJjv3;Uws#7<*VvXjwz#;rp@CAslm}]][:m
    AJ#+HVWz[m36h|X'iDx2Z@Z5]~E+w>Z5[J-7z3\3x15<_O^aJx>{*K^-CsS5j?7D[7'Q=R;N$~!5
    \~+>wTr]*ekC{Te#w}_[U{IBK}_=uOx==\~;nrk^HG,$:eI++nGz*AUR#'l#p.eX\W-r!DYBe;~D
    Vir$j7ore@RaKrH]GIBGK!IW}oN)<=I{1H@o1pY;oqGnpW]m[-~EpjI32<apD3[JA_1f^*XZ%ERi
    5Ip*#ZDZ1[Oa$aw1_:I>C>UYa^j{Dp5=D#$DRx^mY{X1,2jV-rY3H#L!DvwdYLQ;n[mjIwrm5jEA
    a}|duR@R?n>^3r7Na1{-]Q^}9oxBR1+\kOp}!+E?upQWIIvRKsH5[5^vYRmjKHUrEI@)_xRx,^+7
    ?1o~1n5'SnB'OK}k{]m^-[ox}O{o7/v<\HI#zBRnOTYmB+)K<HexWDVn\$#s;jV0,TooqZU_r?sj
    JE5OUEi5H@}5O_!2!'^-{3w[5[R]sjiV'7#<J~{\p[3K![iX*yV^?'Z1uH1{QpxVV\X}5[rd-o]D
    ^vkZ?V=[TxKY+pYai}w'{zBEmXeB@r<T*nCw'AjKD@!p\=lG!>WH,QzeU^kI5QBDnevz7#eEOWQ&
    $swX~$w{UweIAU@,s_evW51Tzan}@>*;3'~2_$ipkQ=]}Cm7yBCv#nGJC{AQ29l^<I[Z-k,uI*!C
    aK,-Eo."]I{~i7*]_!n1+'EnKXAu5ZnoWs'V\W32@j>#-'RiIeYe],#${]<=,II<x]r-mD2YNs@}
    ?UU>;vkC~*6I{D{\~O@+$=GKTwT~55C21-?WHn\xu[j<vYi<xEW25^Uj3vHl*{X'K53~Y-HVZR\i
    }?I'#aV~a\YysnG[kY@RYHAknD;n~<[XLb&]jn@'Tu{'}}[-,-r-Q1]#}p2;x?KPB-7CEkB_^HoY
    }u[pO5GC&hEvvi>,ZT![1U*!-uT,><1<>\!VQB0V~~2A[,aGa!K^pkK75Q>RX[\?xp;Q>Ee?S-Aj
    a\}_xe+$$R3TpRYV-RX$E*zm$X$iwC32{G-ETuB_~*,#_eZYKNe*spg<jX1vDIB^"=$Du%r?Zx!{
    ]+p;z{jojA99[C~*G\I$1H\$l5w@1?u{GKD7xHnuS1WR-lTZ_'^XKs5<R*<XoU|jk+7\#QZ]H=5=
    $arU{QYQTTJ*2{e?UJWe{3Z]H,v>XslwqpB=2lxRDkrInV$7oY;T1+XRZs7V7;rAXkG![np_VQ~7
    {jj*HVzB#5sjGa[O3XrIZp^HK(Kx?[$=z<^)qs<XRYiA=F94>Y=?WDW^E@CvxBVsi+<}B++3x~17
    D>l<#H[x[7l^?'O$j3!lEX{n*V=$T_x!{=E~D\@W,j$YI#5l^k'E\Bw="[k]?7K<>rn71U'+*zPo
    H=CJnx,i*!\~Xx{'EI[V_THJ>ln^7X+&o-]$CxQ^-Dy#e}Q"}5erxxi7mDBuK.jqeeQoiR7u{Dmu
    D2lJ,dpX!l}IVr[O=A'!Tz1=^Iv{Z]c)]W~aB>Oi2Q={$@$YTrB*IlkZNX+]ilGJW7A$YaA+{>aW
    R'x5,T}xn<VZ-vBjWjn\R.7=]_$ix7-rRu4'3[JHIJosDHo]gXA+70B=5>c[Ux1(as]{)Yp[oKnY
    J,vi>nCTul[O@z>7eIDWx6wQY>Ba-70|$a!-_v~U)rJD#z5?$iaOjRKB_:^!K{yHEpeI;$m_V]*l
    ?'J-v+o}/E,!O*zl\$,x~@xC<a<7m{jnl$G,xs-lr72*5hJX*C~O!Ve}xvpv-@$cH-V]:CJE^XV1
    #Er+1o,Y_@'[*,~Zxi_=!z=x;o@2JCY>XoQ]eNVHCRueUHo3+H7Esaep'J#Ee2[3w?GkjuxaGIwH
    p,'iXaHD3AO}m!A\EO1Zu~%=1\r'Er7(OEp~\\\?_#Gk$!*m3'*e>*ZkrUQ?p3CzT,A~WVUK5K^V
    o<DuGZ_k\>URiRr'D8kIYp)QEB\leVv+I;;wjVp5-H!FvAYBWUuJiTE3Z']3\CBmDkBKsez2]_*{
    JQ!=.Jze-En]DiU5>eiUoj$W-DYJveAVnUaQ{oD1JIn$Eq;YZC?5O{\I+2J'u!]JAnqA$-w^MGma
    #[Q*1-z'aj+;\62{-u+pl[L*ieZ1Q[-xuuk-]V+3an+HXns[2>XorGu:$ZvRQjB+$C*I\s-X?jU'
    ^QTDor~!'?@on-}$4lCT]pHmuE7J!sl{R+RpKE2{?-+Z^|BX;ur[kUi5U$'lC*wa@_mRk3AlBWpZ
    BK{=H^,'nX:xI<Jj7\KCi>+2T[+fl''R%q-Q~@A<vYQaJ]JvO#r!e#}1]'~5X5KlC5{a2n3T'p6}
    *oCs,mAj5J]\VOKl?T$\Rs=oA=*}^j~;o$xB5nv}O32!OQ_,RoRQ1aHJ>H~p{p}Q3T1OzCIQ};og
    >v~$W$vY3xu]3oZ5B\vB*TrY<-EXs[AaHGZ\oTz<qm7!^{*ZU{7A+*TjvJ$4,kAU}w+p:^jOjVZm
    Ygmnj;~-!Wbd6a<yXE3uFG}[]++@G3-uoXRwR}S]H[KUGQQjW^lD5GXnO}wy#R!+s7}X}QI3rBY'
    A\@[Y2']m'ov]"ZU>+3[$'>Tj7X1X}Al*2GvW^RG5$}vB{xE*}BmxC}aC[|DY+xon>m\?'CaQ_Xo
    $p]Y^VIuTA1TCoD-AxReB$G5u+-]x,{*Dl>OZ,=vDze^\i]!N'F}$Z*-EG[@D7B*k<37wA!T{pnQ
    onX!R*^'=KklxOoBW1H7WxW[D[-CGK;lBkKJ}A@u<DlBW+Tv;T=]1U!|bbHE?!rVU=7kE@O'l@|n
    wOVhuQ+~T7{V!X=?eZK{MI^kr(F=pB5[;E[T'_a}[^Q=lmaRAQpXo}z2I\m!S[V}=Bs\_X^R{_1I
    ,Yl~Ze+]-I=uAj}BU@lIz]H}CzkwG,}m}'VQ'}-=vZYZ;a6<B]!nn2A**5j\s@<s^oIu*l<sIB2C
    m@D#xWUd<lZOn]BTm-\zxrOw+wvBL+z>us[jUD+DuZ+\Ez3XmJ}R^,CnO$Q\z:xX*r>e?xBU^^H\
    nZ(w\z$@8wXvm<^]QDdOZuHha<]nUroEOv+2x<^_\U1JVYlJkD#>r}mkG;<5a>[jD53KvU[$.11O
    C-OCBMu{_#uwnQ__V5iD,nou*#oizDClxDt5~@G^\a$UH-Up1wjTTZ+G+CU:}~p#^KJ'jE7Glzae
    IQuw$-ujKA1u6lzsB3{Z~G~2oYI'rs~}@QX7DZ|!veJzxne6z#~}6=lzKUAQ=EQE'soe$'T*;A]V
    3{{A?YU27CG!B**->QO5j'GC@&+DJDw{;prB@'bY=?{kxa,CAD_ueQ;Wr]r!w>~4JU\lw}<B\'>,
    mH-RO,x2=kwDI#Z<=R1jm*!#^6veJQEnn1[+{-#7eAp#n\_5[Tpk5r'?Ip#.=3zjerAHI_\wlH8$
    GwR5_I<uVm>KE_*"pl#r=j3=qiUJp1Cm~]22EV+}!!D=lp~AJ*kl7krTWGp!lUsD_7{5Is}#l4/,
    ;@A[6Z-1$}ap1WRkvIz<z{]sO7u>\s{^GopY\A\X>7~BDIJQCZz@,R+sT)u^JT1#p^iawHx@si_z
    <5,^r;}e2nJI_pc-$<p=@>l=?Q#\}m'HGxvC$Q1+1BUF0+,u]o-D-pKxCY[3s<a1O^a>WC?~}55U
    TVlBmu+5Qp<I=Ca1<XpXkxl]{FOu[ErJZr^lra1Zv#o~7[-rk}*C?]rl7{Q{R+JUA?beHKXok^e>
    pjY-aDTQI{@jH<[21=3T}[j[zTnD-nvb@ri\v]em'E=Vn}T<=ek<sADWL}G_=L*mm?)w^+<g$T^U
    ~D;k!_nHA7]7upC<[tTV'_)=JK'~X^^pI<xe$<@BTB~=+Iinno*f#OnQCR^JDkvaCpri;$GE!7'-
    UaeJe#OZY$jx3CT1?s,U]~5=KO?=;[',~-$EsD1Q^UVzk7a7Q\+~Rm~BBX^Or72G+{vY*kWJR;W'
    v-7o-_}1b$=O\{QmToZHuTwAkz};eyv\m{\KDD_!B+'~=Qp?jY.}$@\r<@j']{VWVIrrxmRJ>OmI
    K@_G!UHd-Ul-lrQ{_xwD#$^oUDI-\V!+7$XA^v-n!UAj\DRz6|T7\GCs_@UoOw>[Yu\@ZoOn{~Z<
    eQrO!<xs!e;^Earn3?$DJVrUG?j~l?A<zeI-Z]J[53[*Ur%CW^u!xlY2E}}+pJ}-O*v:k}IsZDvi
    -}>r}5ep]BCCR~-{OV\B$xm1Q,C?\GK1H<5\$*xQOu<mL#$=>uH*V~sJ{s<<JIj+<z>T$kE!Olv@
    sCU\V<]E*~1iGIe~CCETw%=\eHWo<eka}KKC<[YK*UfskxmG]J~1Iw*sxKwZ'B[UzK?ir=!$^j=g
    N8Yi\11_-,z-<,0XOD_E=<{^r@!?OYIe3_u:Z\vkjJZT'Go\c>lu*WA_=_XY;1V}Q6D}ZvlsG,m5
    vU1[arwU<>>_\Q:]]aDs!x\l:G35?a+=*47_HOyE|"vCYmAEjIx+_l$Xls=omml^uer^_wIo7O~]
    RolOnz_O>;Ze^w=}CTY~XBj-\\oAI@<a~@E\Q-#To](C=+},TE{UR7C5{I<4}wx3.xX{Kv>rW,3C
    Dxv'5tQRw?+vo>O<*Zl2pil_;v7Teuo+@DB7=U}@A#v=v7]p}@*WvxBa=$U$]W~Y]5rBn5W7Ts}}
    <kVa}#OZEAX$OY\}#!0-H@#eu^R~<,rlZ{}em$r^XOQ9NnVQr=uRj?z[1GJW>Y2ji@OHuwDk_?zU
    r]Rwn~,RT\+mVT$_?WUmIzD=BsDEoOYRi*pA?E1p>;UQI\7T;BmOA)mn<^\@3Wp;n~o\K{}@}A5;
    D+_kr;']55OABX1p$pAHwG-_muGGOVXnpnl?o[*1]xZeUp==X5LMR\-Du_'*,k}+jXHG7Wo]RbI]
    mH\r+?^B;I1w7<s'7xJIJv"UpDE98pE<Q3vw@vB;H,p\3?RG~'_Jo,D2R]=Cp]EDzJ'=?JD^$ee1
    71mvj;pB^;I2?$E?pTxm!e{RGuY3U0zX[>N+5wZ=mpClv5!sQGvqrQD$IBYOleJXI?!{!n,a~+K3
    %UjI#zX^jw'~5KxvQke75^Y2\jDHDDr5!ZAJDj?au3HYn<1@os!~^X(-oO!v#$KvlVm$DCQirsU>
    [Ws{o2EPbRn5Y:e>Av-o+]o'v$HU7z^=W__no2f~^^Vkj%,{YWDu+QeE@,YmEY$RGe,o\Kv<2UQ?
    sZA}m}*uCGj@wYK'ETV?u<M_,1@]$kR>A7eV'?!'j\ift^Vo5(7QO-1*lCJAZ#/xIk]!$BAt?-\G
    G_m$~jJuk$D,V{J+5p*@?,Ev[v#vmB{;1eIp_#!$FzEx3B)hGjZEI23,Vz[@^R^anG}7mGTaT[iU
    }1Y]X1{w>]sW<*GG*K_@BXY,uR{<IWzUUa>H\>VJ_AA[l^;syPZ\3#=;n~71Y-=NK,mQ=m1z]EoC
    <zr\e_,'DK1CIoB[p7U}yb+CUZ?x3,TA;{YO'wa1aQw1a7>I;eVxsYvi3?l_A2zuu[HV<DA-s+}o
    iJ1oZ^fU*{H~vzrza-$7<\Dp^W1eeOJ-v-<7zD=M:ho_BQeTl1m,#=IE-Bf=3RuIjYCQOelQ3a?l
    Krvq;o*w}#vi7)R!}G,[nagj=5[.>B2I5?2R]-Uw7W+~O]]#KDXVxK{~E<=,V~A}QBi\_="QG1sB
    zRn<X@@!<I#@}}uu,5l=-Tr_s*JpY=1,W@Rq1~D_=^u\i5!2RHRltur>#^lOxA^\H5@XRknIurAz
    D]$lJC1,Eww\>@C3;CCJ]r#_YQ>r@UzsIAY@r1DA;}[r$TB!n{TaDn1B$3soJi<O@J_5zZa=<Na9
    _DAYtXs]sEFl+!<f6Jx<E^u$=lCE<^XrD?U{rrGQ-Q2$!e)oB[>{[}{GCOiD~Da^2=ZriH{w',eQ
    __I*5Djx#;<rD_wv3n^.>}TAuxeD;N%qGeznVqE~YHuTHZ[;-=o,[pa{']s_!',s;?tvW5zCDRp>
    [6]eY;-BH]H_V']!3-^mUKc{]UI.VGI@s[$lOg++*pIJ\Qrml{W'+I~nC<LoYjXRZDr__{kEkGZn
    Rr#Bn;]j{oG5=z3]HX1t5D^CF}(!]vY{hZvuYAD?B+EKp0cIWpI@ew~arXuj#\^!X,$&1UnZV]o-
    lK<p=JJ}n9Yi-OsnjkYmT*7c*)GZJ3\rmnI;pj?I#nE>-p>sJ+29*,s_%#UQ#_}K=#<~5SK=_HzK
    suBz~BBv15>X5~HUGl-v{kIBWeHQoBM"IUz[^RAvj2l-,rCI"5AC3K\3K-17]3{>j**RnTH[3dZ*
    @j4TI]_ZrX#Y!Ol;]XJQAH$1<jEeA5*eGav*+a}sEee7$O}eUOinznw*R-m=lJR^EB\1Cl2tDOv<
    ;o=A0Kn+GO~eAYkJ@n=BRQuJzewE'^,;],rAlCT~Z[zKlmO'J}>aGsjjn$bjTx5S$zJZb\*_\a5Z
    xI}\2Y_~wi\k1+E5rWrRC\x+oO$XCe$iGEo,]asK^n+X*,MW&YI@+GQwln1{OOKD[B*VjOs>BzZ2
    ZvvZHY,?K8K=AxaskIjem}<_Q>Sfv+e-B#*o5E~O|\!T$GG5rYjsBbl7i$}<*OTs~@^_Xx'vHau\
    JCx<mO71-Vzxk\TEVZI~]v0AIDeRI?U{}@-e2]Yv@vB;X*]7Z{BiHBDz=~wh1YI?PGaYv1pZv$nm
    ++a~{CEZ]#YmJ};@o]De7z_}Zz,${t>=\elY@uepwj#E2#*#U1vv77cEAAl]Yv$v\i??]-@jaAu~
    lwr$k!K7=D^[wlsVlYwJ=Op2xCH,@*]kel<%7m2CCGx@<-1mPK[7'TrD$4\IB5@+j2z=O3OZ$w7r
    Q1~\C}IW_ngsD;3-5veZUseEkvl|LQJEDJ[Il:s~+k[wBudB};o5G-wHC?u[aTe8[oaO"wn*{E?_
    u.eY=RH[Z;viAW9er3WxxXBe\kO*iavlO.w_{RyR$5sQEH+M4Dpl1~{WW$3Ok({lE]>_W^=r_D@=
    DK,}{Z1QGOU,_e]1nam-Dr\Gx\xGv2Q@RaG_-W~X=p^#xaPB*oi_'Oit4_D~=Z$a8e_3wCm@3{w1
    zrwO</sR;3yx_HJD@nV!YrK_e]1$VDE-^BZ@Xa-6G}WVGea#ViW^[J_;GVDE2Y?]_^Ck$eA_aUV=
    E3{Il^l<\J,}u7Q:jAG[<]uJrlJ<k]EeMw-e1Ru,R{}DO;$njs51_o;T!'!;1}>xCzu[2,ECsA'n
    n#[Ezq']m?']+GC'o]p2_E\~>+&D>_1",W!O.GmlnjBpmCo>px7}$BCU3OS3AC^IoQeVD]sOGQv_
    3rv#DwYIT2nG1#?m^BOvnBktzU}1]Q--k=1[@LW\V^ZVX~,Ok^O{sVfq}uvxt7*#]e*3]3*mE<\V
    jf#{VQGJrIcxjsCo_UQ4TIrz7V,K_a@T5pTaiQW$?.AChI'>Q${aDG{{WF5?[CO7,vU[laa[I\p-
    C*lEkTwBiEJ{[*qj}\Y*$oE@[>jKBw1+v22\[~~uDE3k,zE8Z$'}7DDeZC_Xeg$J$C=\]_5_={H_
    +AC[<-8n\w]rkI[w]xoJ>=EEGH#m1WY#Y$>pJX;lxW~\+$5_Y_sQ?BHTeZGReX=>D=n7u$TLBkaJ
    -[,#OQvOTHCHdA[3pR3rC1{lJ72o7h^x}@lmx@VX5T|q;AU'HhUIJ#JjvmPi7Tj$_{3*xK7Vlp+M
    v{{X?oX!ZeUlpwB!,$]aYmeA;Xp_I^ee@5Q+1sT7u$]xrYOQ>}sok>^CfRK'hQ,psrOCW5apIED+
    wuvUrBB,V^+>~z1,u^le2X-x=R^z->D<7Qx}G]<--*]eD-}+ej3a;)rQJv-s>3=Z<7po\'gsuXRF
    vOn$BonJ'luU7u][SnvYwp5H?Apo31GQZIXW^+OpvhE\V\_kZmnGIDK1ju8>D'u[en3>HlrCO?}o
    XaI,7OHl5o>!x$zkBQK[V^saI]rET\UIaWJu}U!)omjDHTl<?+oZnnmKxG2BLdJrw}wRa<@R?1je
    k2z>3!_-Oe5U~!{,+BQ[lj#9p{'W#UA='C_oQiOVJ7X^AEJD^JE[vm^lXRO*v|OoZIQJXafFmhLa
    ,HIBpr[l*Ka!'W}s{UK=X>5vmxn>v\BHEY~H5EHWYo,${GX>,sR\aK#aV2EjU}Zj]$?>X{GOU1o6
    =!WY<I^;1^?VC~eIU<s~J<w=ISI[GCVM@V#XDaVo$AGki<0~\+\Q[wzD}>Aczz$jr[_Ap7jC$=w[
    a_@zxwp\XQ-UOUxZp<;wlRC>v+-+Gm{uVes$sGjCjw$Tp_UlvlvrgQ=j]UIwp?nXk>{lYXje'#{p
    ,GEj;}<oj-XJ31]G*qOE#1Y]oz3s{I]*-leiB}=2]mV\ZT^aXxv]anUCECw>Y='wj^zw1U,HRwE^
    Ba7C=C^CT'3B!G7_$xS1weiD{Z_2Y[xmzv5rz@3,BOr2RpnvXz]RC,;mp'wIW]W5>n+SJ=u'J5RX
    (?lT]AHEKJA[2*^p;GH+C-}KTY_\]$D\?xYe]Hr1T@<JT5_f--}{AEO+BQBDQGWU\KU_C|pDp'9}
    TGHrpEaNK-j?$#'n%!+EEpI}Tx!<_JAVG%Z]Y\mI;>~w;3XU_l?o5,EE{j!vj-4#XI[]G_wKY$Uo
    -'ro!}KsTjC/6?{-k{n^uY1?R.=-BoVgl=p7?-nU}5ie9xmV+(ERGk>_X{[OpIVBZ,o1IHG?}u=,
    ZTpkXXiIo@);ARu\~!}~OH7Ro{Zv!><i$n!^rI#eCGBA73Z[+@BYHZ=}k{_pn+l-R^WQ(QIxsu5T
    Tp~G>|e@}o7Zpnu[om}{Gv+C?mi>Ij?_}XMlYms3Cn_\XX@S!,;st~pA[R~D=Vn13'$YC^7lXDD7
    jX-\Tn{jsDrr^;HviuUD;YR-x@^sz<5Xxpz^OoOGJ-\~;}sv[a_^!e^3\xWv+^yQZEiYJYz-Bo-r
    ORCZ}ApWTY}@^{{-aew@{,1"HXBp?\CUnsv$,B^=TD_E]p!,,C][RfI;<vWXws$z\>)>_*OF3>GJ
    0ryp{~Wz<z;TvAH>aOsIz=VOu>J}@lQ3vBZJQp'=VCU^Ej1,l}oQ[YjTw-EQgC3wj]>w23x#pn+>
    JM+G?K?A\;,'Vi2'*+'xj~YZBEB-B\!ROJ,oGz+>HCJ]jX<D[_vG7;_I;R^C>njZXYRXRv^[e2QJ
    B$qP]T;_rvv\FYVaX.z!RiK+TmBG__B\-K@BQGC+[zWGx2;o>RC+<GcmYe?i}-\'$j[cX>m]3^;1
    _ie-<X>*]]G-+smpk,K=_#I3#'JkCYeuurA#&j~QZ;<->.2x^[FHDB~7ia@;p}DWrHEg?+,[kYKO
    A5CJ*p7-xQuaI@>KZ}-wD+7$1s<5pwAwXpi*=YC~UTUuI13k;C?7<l3zYR>#!Rr*gI1BmcQe$*p2
    unoJoARR@K'uBm5+ex!CZ\l_Jj?<!\2a<ICkl<RRpJK++kR_CG>-Hom}UnO}Jzj$?j;Uo=lW>voI
    XzOBZn#5>e+-G~G*w$P'}TOpi'rA1I?6I(:n>rTCH~<F;5r!,\W,a-+u]3['t5A*?@{_?p?xpmv[
    @Wh1;Z]K_"m$\Kn^T@]!~\uIlOmToWrH[[iS@H*]roJ}0!,7iLr!vrD+oA,-]U)jD[u1,kl]R>==
    *]ZrIC*rWI?{1_;d+[GDOrYWH7Q@+U{2$XaJW\EiAYu[^+al*7-u,e_e_v*A\'1TwX@'QeJ}fD_U
    ;AxDp1~*BEj2$K>3C&UI*VzJW,!<EElvX!ERv1-B*eRQ3YOVkQ<Q]eQDs*W]_UO+r'4e5{*UB]Q]
    nnRYoio]VJ\1#12$~QZ8~>-?iCjIm>z}'*_~m_[{5y;vwQU1G@*FjkD@x~n?ZoHuf,o#521*Tl!{
    $$2Z$,jDmBo*3'U'x'V}n}dROu>f\eQ5JVlyv;5r_*[^'D2u:-}5]{TGY$]xQ;s;lZY{l{{JYKV-
    }-XBZBK+v'ReC}x;CJXY]Ta<@V=AHK5W[$^IpeKHj;-w,Vx#VEQ'jxe^IzD1mc7MKrolX'B_',@Y
    UAl71l$Aupssr_r-3elo*3'e=Y}R#1m2jIDO*QV*WnC{3v2@3Du[-T*+lRKu\2{Ha7Q\hE9>a3R}
    }C\aC}[*5e,$E@oEmV<\x\_CrD\vG*lnOr}mQ-*}kZ]*r<BzrAT\T1w#-a@ejk'Q_R'@rrJFo#oA
    d=ZunUO]xmERuze;1kD}*~{GW#CvDo!W!~DECoC<}j?_D}#IDVe!FB;B^A5@psjXKT1\Ba}Q3kQ=
    >ZQ;5~Rs2-VuYVJjGv~@_A<KCxi7lTpzEl7w]w1};v{O\eH-ud-TYW%Oj-IXn;{1touDXE?az%Oe
    A+U]Y_Zz$u4{1QeI^?aGJ2~\F8e<O@xpV*t*#\zv,U^@\XJG*\KLv<--GmeA!]@pW7YBFvq,Va;?
    QIk=i_C11^vCW>{Gw_X2nKe7s2>Nw\{z[mTxB]xs7C2{xi12z*B@1]ET1{57H[paKpOlY,C$'ra,
    v!HG'eZ7RY>5$mz^*^1o\\a3(&IJmko2=KIAYi6rjWXKOv@@<GaTo;!J5[v*i*~\nr$jE1iwDAwF
    7}u]+,,$GuQ!XQ{QEr*oVxxR{=T[H=DHi*~m*U5V)ZRwn#e~$&35B[AvKCaweR?^]_k9YGGK;_7G
    3+Al8m[\OO=zk[]m]Jpx1r_m+]pwI53=]=n!~e?B]X'$X}*w5u+HB1{CO?a{*e*>R2{;-DYED7a^
    Dl}p^5>AVVio>~__DHs[{XB!C^_!5+U5a;_ij_^Knv=K^wvnlx-@wSX_^Ev*vDR#,[wGD?1sUWNE
    QI^n\jj_*!C'UI1F^DoQ.2w-_mOxr7\we3755Y1WKVCx<2YWA='!TgUG_Y'YY5#5e>X<,{qH{2;x
    ^mGQ377rs}WP3QipoRpUDa;kX+72GOUupezG='@=YK1\z!\ue'5]TOv~VC1plWG365<r;@7sEY=X
    $oD,3jpr@:{arDf[t1;_<nr#B-j*!1AIzE~{z^WAI;z>x6}kwEOp[2~jQ*[VnIE@!k\wnoK1^B?7
    Y=>$mYDa5GAoDxC]]7l*jH$:eku<G?wG9>l'K#*on(=Ua?eV7l@-KC}-j;<[21<7siE[[*rxs>B;
    $k^-UupoJknUJ;=[oi@v<D'X}ra}YBGK@W7jJw_rjw17R@'pv*Bx+{Jr*r1Tv-YUn_xe7Q]=UH]]
    #XG~wDi]]#xZEsJ{+]G*xm!5Z,RI,Y\C_!K^1s7YsJ,Ys@Tr;HT&D|5}x,UpJJen[KBro=T'}X!a
    \J2TORp>uH[\u$$p-Qk<HlIR<ZI{v#sw2}_Dw2sVa=\[Y=D_UrC,]kY'x[OXjHT+srLu^Tr7uRvM
    1{'A4*IZjnxE[oa~@;lBn^U_pzE*}vZB_|;\2HB_a?ZB~1Y[pa[HBk*o^lIVo1urR!-n\nsB,_sD
    3Zx:\eQ;C}G\DvvEc[u73\"p=?\+_~kxw5z1p2~+Y}vbK'3kKrK5uQ{ppQHu=<wnw<{o5nzx'Emx
    ?nR<.@7Ww%/~rU,wDejlHBJ\[OUpp7>P3GH\oQCQr\JT^K\QszQO'oo*Jlrv![_;OT\<t)t}?]G+
    Bi[*<@rVwTp*!Oljo$]J_r{{X}3GXT3j2I+$#@zU]R{On*oQv'm4ep!^'z3#6/'7-k7U_pkx{o@G
    G2n,xBi^?$K$-vHHsvW]1RVK2\s]Vr(Ov,wJOV+}QZm-RB>Br-JBBZAE~^#wTGioiG~CcTz{V=^7
    K=C?J,{nv3RI$9TI7n?,DW=ZG7@VmVD*ooCU~~zC,3si5I?zvjIEZ>#1Qe#v2_2l]^xPlB>Vm,*=
    (?*$VQ-BnOQmKACVYss~RZR<Hp5,xSIeT\Or$\3]++aC2HP>Q5-XV?}D!U*pAZ{TOln$a<C]]-\{
    xe}@eo^_W}pPI_7U57=R8?Rs2rKH3e7Ajove!*~ZUs@W>CJ'?@+Dp$x7EoH$E~^#H_=B_OB!_KlZ
    1BW'Q\srm/I#\ET*WH/JC\G%QRDTGe^s--vxDGuQ2\l-,E=^G^~Z?6{GzJ@vp{{zKC7azH3B;rnC
    2,^H2a|vE5Cn+;suYAoa}zWu]WG<][O,nw{2w>YXpV7MjRYI/VZ}#InWu19jOiJ:UT@]}B$E#lpw
    TD$=l!v'IrKXzJ]O@*ReY?Rl0^kzJReVZCBrkgEoY?X\{z';zJrEp2zWAkV#1!I5>-x#rrVT>ZQ<
    C3Ysu3*_7^loUX_A^}@hQn!#65xrYX5}*Rw*<\COB*+IoTC#u'v#$UsuUQ92YnZ1e<,O**7Ze7r,
    $+nDaW<H=,Y^|]?};b>7Q'J$<2n1'l2,@sQR\}<>lW,w!zpj!3^;Q?J$<?wps31B\jJ5s@v5j$,^
    +2{R^#hp'n<1<mz>Ez!oia>z+2ns-zU.lvWarA=!3aUz1w-DGTo}rDXXkX=HZ12>;A2]p2}^;E}2
    r2pnZs={V*-]1=K+@^17GQ^!#lm#'i]H2^jip<~;uv;vEsAK'-w{,!V#'^6B=;2X,r~G{5<~1~D$
    -5J,jAjW1XOZ+^B'iv,z_HXB1,p@,-oRY*U2*OKCU2RRzz3^1G~w^l{R][U^#mGJn*;dsAj<@B_{
    @Y@Yp]7@QBpkIE77jr;?l7C=wj?BgY7CGxi-,jn*'sRD3c'Co_U['j@-^pOx?OB3ZZr*xK#>o]aw
    1VpT~xnaH<Y-aEl~C$5*!@_\57FuXWRiVvZx~nuI~eii{n[@DRR?^13l5}rPHCuauz[r>oJDQl5K
    <]ZUmEr+-Y^]JO+Jji5pv^CV@o7A,T*BG;w@7U<>>sx2]CenYD*Xzi_^}VE{z=s<CB@[We3YE{UZ
    ]\uOG+@k-H=m^Q\>XTeuGRm7x5l\zCUKo?sDJO3X!7G[v@[kVaWKB$>Z#skIvUKAz3;G>T~-wO2\
    T\7xD]7p-OaE#,O2}m-~KDH?k1]O[>>reKOsE|C->DEnC,K}!<w\s}'>lVo~rkRX$'s]s\/=l[U3
    'QYHRn!QzC_I<C}Q3OoGuW5+*5i!G@T+OAG[p+:O-5wwoUE?_[uxvl5\z^p_RHU=la]U*UD{{uz4
    AV?z_m~\Q^+Yc,'I@\^aAAxo;W\m_1,np2GV1jQnJUE25iDVJBQU-k-@D_e1Cxxsv~x{n#81R-Ki
    p!}<'$3K$5'oh91u]OMc=^R*#[n<<QUnfAe]VZ{d~A[<eB+,<AVX,^A,%rG~QI?@mQlXTpCr2x\1
    eVVCn?7k7@v+^lER[?j+2pu=ZDxjT\kE}lD=T~TRz~HV3|xlqS*j#@+eAKeK~G\;{w7Z3<xi^m@-
    1<<p,1IQ7@olvOp]w7R^#5}Y*CwUpze+3C3_p@{aw@w<B#{[o#7H+nIB}?U^I}V'H?C=[U]Q@OOi
    2rGY#[<Vr_pW$E;x-n3U'[v\K_o;uk<],<asIawUv3nvu2}lIs5w+1HUm,^^m!R?''{>[pxHsu$G
    ,a\iAa}HuQ}?o'=V{~vkHz]vUKWEmxlziBW<usm_rp9Ei]m++YGkl}JYO{2^CX!?aD2o7W@rDR!z
    eAU,+J2Bv_K2<^_oxp=a$=UT7o+B{7ib!]}@H_V<[{m-j\*]Wn7VOoR_*o+Z^w'rGxJ;ZVm_3lv#
    l^!lkOzWY_3TDw$uv2m2@$u{,s<?+VjX*^^U{{XTvE!Amo}WX*v={p5?v\BUvjj{=uDj<-7Oz>[X
    r!^lN55n_[2ApD;z>3<-AW,'YJo>@kII}yUs?n2OC]&HX~a]3}UY1+EoseD?UTX-{@D[$R_OE_Q,
    ZzmI>-_DZUJ]aa~]sY<vrr3\32#YE[J?]BGl$k}GBwQk}V~lCYKx;C*)VW+^,vv@~OA_vC{v!T7Q
    ]2;Gl-j$I~}E^~njsGr^OHO\Hz1;_QAaw|x#IkV}DBAl\+eZ<~luja+7}\ECoE#(Vu+Hl*_n/-HW
    B_swemV_RX}Tumvl1Gk1^~\)'iw@@'a1\A!e1R=v[_72_ip*W$k?;T~\Rnn26RVj1e>{2Ul{zYOe
    ]urY-BX2wRDRBl]D-7u{sEgelDA]*Qx:e?E^A$+JwH>CG~plp;Vv#o>wK+UCl@K^r>,=w<]~*<]<
    kU>rf~<5J!v72Vz>^3$[2Z'vJ;[(i]1mA'\?*u]>YOX{z#s^;7p-oE;poQ-nHVJ<j2~*k|j*1i7@
    !U?}{Ux}{EX1v1=R{;xIJQ~5TA5r3K]W<z31R<=J]wET$w)j]u3rgXCHY[rDv]iK-m[\73emeiCH
    ukos'=nnl0_-AriAA;XD_lIw_BDtuC@vv<OiV?W#-]@OVOza\!mTsXo<caC?nz=$jo3@<d<av'^e
    \^Zn{EN#B}rE;Zp=o}35@]nGX}?L@}R==K*<$HOsk{Bx{e>VYJB[tz[$5ovV\iO!5O$@xpxOVL*u
    '-biQI2eC~?Z*OzsDEHaowQ}3J'I^I+(%V~CZiVuu;<HsI1p@2^<+k=R*pBn*5p]VCRwACpl]@R3
    KlK^x'V}}oEAGQj{Ooxrl9#'#+IrIpG,Q;~<eDJa7jDQolmDUeo?E7lrV=.>Q>Da.FlT*_AlJHC'
    ?R%<>H2R{W3_XQ@jeX~tNEa^xlX<Rsn{Dv-{vGT=!;-,AKnOGu5AK1r2jkxjZ7~JEDQi=URvxskV
    B7#VIE[lHps5?3U'vn'Qo&m\^v3_]HG[{3nxYsm{$<w\2rUo2[TS@\<G]jW<%Et'^]+]w[+pXv5A
    VljTe{VFTaz\xH!rOp1kV\e2<OZvela^?VRa!<<;<IE~(o;K?;,,'Xp^V1XQoYz-zQra3R7V2R5@
    }tXa'om=nsnvGIRCuuOok<7OUCv;!G7A{'OSQY5'3>K5R5m^#Bz~LHxw{Hp7ap;\JGD;>7s$EO]V
    RD!1uo>BIe]ZUDBjCasa2-[wmEiE^RC"E7J^#D5mU=Uz_?p?UBmGY5oKzOj@^z2uz'7zo~1>w]U;
    #pZ}w{upm(Z,U\2^z=^R5*=*}DxiZ3aDTs$e^[eZ,#QoTs_}xJ+$r{2};~+_?R_m*[uG^3R\avC_
    v@O77>,{Hr5o<EV<$^xW~H8XAD=ex^\MMVRvxsuxOruW$}A^x2<7HmIXeCzVRA*l]n\Y$\^zoXV3
    ^BEr?\2wQIzvi7ezexk5Cx1R'!x}YD},QnHx20$YwZpXXWQ,xGp$j=>IE=(\;@XC!GR+';;zx2v^
    wp]CxepOUIKH{Euulj@6rW}p='VplJ,=e2n7r-R]<_<p{7jmj]X!>[_uCXIJ7WZe*=T<j3Kxrkae
    faX-I7B,{^us3wv$?YsoIe1A3@oTY3l@~#$#O7*Uu=u~X}HvWGx2I~XY>,G?@d'UJ-p32~l{~W:{
    Ch>V+$=ZT$1!w<7D^WVG\KvYV\YH2wYe,5;1D3Z'nTd^@sun's1"mV2n>>]5-+<~WDZ<-\jjI;C@
    .Qzv}xla{V+}2@Dn@RaJB^l}7n'O_IHY\tfU>EKa'I-&EpA{#(lOY5wVQUY~5WEZs{p!rmw5>,Cj
    #}_<<*bn1W_QkxokvzR!==5IjZ#T1}W~1J\BYTTO>\YZjnW5*up\-wCL-C_#o!jm5Ze<wX'^Yse1
    p-vEp}peY;AO0U'\IYw_kue~OXxUD*YeB]e+n%es>Wan>p?p!x]l+m>,I!VT~E\VQiI~r+e021>X
    vls_T<2TCYuDu$eCVoDB1!RI0'!lZV{+OWaX+zR;I+C+^G[E{_'O#1m7v]Jjs)%tmT<;l,C]a>js
    VUY{Q_T$Nnv1x,z#x<H@xIAs}{_!W)V-W\98p<Z2sG'oIEekiG<WqeHU-[YZZPjY[,x#,Ao${Cr{
    Y?w8}[*v,Y^V\]1Gx~Kw3oY$l?<rxT@z*s+{Io~HvV[@)#a\a7nJ+CBa^%OzHlY1**Imsa^Vxkv'
    {J[>[s\HUB^a*I@${EAU7_i{uYk]we^QjCjd3Xv1A,X_^WKw$-*G@-V;!UWx;TYsOo^1aHKn73Hs
    2H*Y$ZX1lWX<,eAr>7ks>[mTnr^BYzn7Bs?vlp_=C+5z5i$p'<x;Ii^x1DCRG~nR._xwz+E@_)JG
    R3j+YYHX]-^{{A'2H5rI#-G#D!CiWH_2zOPGDW$Lt&Cxel#>HHm^#eNp<$3WCl]yFAYur)O{;p$J
    \aqcWI7ar}@+D\\-eKW3B\H+v57{^2H]VeX~EG*Xln@RnH_zGRERpBG?v$1ilk}i\iv+ZwUDTw=k
    Ov]i5'$;*e33j>*i=sUR7},x]~XZ!^}r!$G#OC+I87EaH$~TmsIKZ2<Es_a;;eAapRBlDXEYwJ$;
    T\HsRYz~l>C~2Gl{TT,BpzC#KV35k;*Dn?UQK~{KHk\\[iX]X_x<?V,_mCGp5AIlk!YH1\uIpc@r
    D[8!v<<An{zB$<IB$BUlO7BoBj5?$Yk8Z|7;~#o[>V\*lA][@5[!=D;<E<JT<zG11mqp\RvZG-*a
    =lT=$k}Gnz"u\*j}m+j51I=1vr;w7[@orr{n**+C3!_Re-wyJDAV-<Iu*[s*QA]O977Z@eu==]zD
    QD^R!K|}jWAx;K-d,Gm;i71O{]m,ROQ-[0ZD$$"!>A>_dHa*E-^v-?5<-3Ba^K_E-^ReOCp@U,HW
    knrA[z{Cl7WO?O-K3~BsO4'z+2'Zurhe2zRcplrkyU+_;[?AzzsRw_eu[T=iTIH@wB<mDlIR$H^}
    ->w=Klj@XZRp!/uwrueoaUs#IEro#>i';G7?}Oy7r?-n=+s~$^=^j~=7\n$|lxix?HYR,WEr'K2T
    ]v*]xXpDOA<v&uD_'_p~}-'KA@QVR80@z}7$[@H?=X],o!3jCiZupz5}2WTyZQz!XY*nwe{kGT~D
    zlz*x0pWUAl<IGjeiE9\}EJx5Xz,w2xQ<wnru>RSkHlD5,5IQP[$[71~HotD>'YI!lT^-@!kw5-h
    eW-\N*UJj!C1IY<m{_OV<@+p]zDwlY{pa{xT<{TmD=V5impvT2BKO[cDzG3$K+2\+Io[**Xk9MDr
    ;WC-U]X=}gW*ow.+wQTmpvpNj>loB+MJs;@w1$kaD<a7z],!D,xMZ<1k~<z1mnV5@vXBmC?jT}Yk
    crxD7[?*$'Ql$'A,vz1u5Rr-jjG$*}sZ5Q>r2nUs_maO;s2DClk+^n53u$]R]1'zEFBoaAI_XHHG
    r=$ZzGKeV2Qle@?[VKua[Za]oT,Xr$IARTv}xx>Cm@@Y>r,jWj0>7,[TnpRYZQW~jxAF')iYDrD_
    1J8w7G#lxx7EA{mON~}Z~[~$GstBMsD_!V+=;4e+IJLR@@{!n,2QRJBjrKaz-D@YmJl?]oRvUXwz
    s']:gUxDuxaBiW}>lQ#u'YN7,JW2'[\YD]xMa{Z}ru3[EV>3LE?]Y7\EZ17m?s]j@*h'DHWD^1<Y
    i};]p\?c=w<Hzk*pO@]]Pgv'WeH7Z_]C>ZZIEzRsZa/W}upYv5[r>e'%gI,]if\xa2lm~5|^#VV?
    o7G^jxmQnV<CU5noAeEDu&@Cs}v>YTAs\I)1_7~uaX'<wRDaT2ZpZ]J[Nus7u[~I,xb_oIai9']a
    O9,@RoGlYoa1Z^<[#[.m]nVA}k\Lov![c<=Z;G?mC<}$umI+lz@}QXw~e$vl+H1-eUE!I'QXY:Fr
    _el]ZnH^?a;=!~B,sQo5T=H&B3n@^_BQ}vsr}p!B[z*I'v7U!H-;~+W~Kem>mEz-^k\]7E}-p!jW
    2E*!nO#1@YTI\kxH/e_l*aXDu+,~@,j<Xf?NFUzpRaj=#1@JJ\C?Kj~,2]IT==zop:meiua'u]x?
    u?Q1]>Y$\YbEa{Dx2jTln'RlQQp$%=u5;DRB+17_VbIqBZXsUIe$eMzp'uZ<ozD/{r@,ce;;Vr=[
    ]4GZVv=KA'5EO?V$YV6Ur{Y/Dw5AH6hAs$IGs?\;ol^Bw^kVEk3~\HGe#Wz?OE_;-sje,Ul<YG~l
    O[*DV<j-pr{}@e+WB@;7';a!oI~YoArKzn{Dw\2IV>[JR=^?1i=<7>I+'+-JG}YC;[@v7Jr![uQ}
    e'Qv2[,77VIkVsYO?,RW__l77eipCJ<Y{smaoQ538yt-aj$uB_1EuIY{w[}61palGEbIsiAaHKv$
    ^uH*3!x!zg\_KHG@o1M525^1KDx}*p+S,X}HT-ex}g7O,p@oUZX{nxBUYH}z1~E<n-IJvvpWv1r3
    Wn[KV2TAOVVR-pz7{^CmH[d7!\QO^B>'C$UvQDUG1WXnXZ#$,~39QEH~C\-u8U.KO_\X=\WTwj}z
    n'?k{V]VW-T>]=}H=+,!]X#A{Eo=YB]KI7#!]D7z<,sZw_~k'\7{8Qwo;*aZ!<n5^ven;oG5Ec,s
    Y[Bioip3DTEE+TYvU[Ci{_k\1w27
`endprotected
endmodule // module vusb_hs_dma_traf

