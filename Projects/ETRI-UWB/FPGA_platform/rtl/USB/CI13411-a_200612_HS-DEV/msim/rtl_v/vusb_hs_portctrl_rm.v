/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_portctrl_rm.vhdl
-- Date Created: Thu Dec 21 22:42:07 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_portctrl_rm.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//     Provides clock crossing logic & metastability registers to
//     all signals between the USB2.0 XCVR and the VUSB_HS core.
// 
//  Register Definition:
//       There are no programmable registers in this block.
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
//  $Date: 2006-05-16 17:13:13 +0100 (Tue, 16 May 2006) $                                                                       
//  $Revision: 58 $                                                                   
module vusb_hs_portctrl_rm (pe_clk,
   pe_rst,
   pe_rst_a,
   xcvr_clk,
   xcvr_rst,
   xcvr_rst_a,
   xcvr_porst,
   xcvr_porst_a,
   otg_sess_vld,
   otg_id_state,
   otg_data_pulse,
   otg_autoreset_proceed,
   pwrctl_suspend_clr,
   pwrctl_wakeup,
   vbus_pwr_fault,
   up_ulpi_datawr,
   up_ulpi_addr,
   up_ulpi_rd0wr1,
   up_ulpi_cmd_tog,
   up_ulpi_wakeup,
   ulpi_nosync_drvvbus,
   ulpi_nosync_chrgvbus,
   ulpi_nosync_dischrgvbus,
   ulpi_nosync_idpullup,
   portctrl_up_phy_select,
   portctrl_up_serial_select,
   portctrl_up_data_width,
   portctrl_up_suspend,
   pc_ophy_disable_bs,
   pc_ophy_hostmode,
   pc_ophy_port_speed,
   pc_ophy_port_state,
   pc_ophy_test,
   pc_ophy_tx_data,
   pc_ophy_tx_lowspeed,
   pc_ophy_tx_valid,
   pc_ophy_tx_valid_early,
   pc_ophy_tx_valid_last,
   pc_ophy_tx_valid_en,
   pc_ophy_phy_reset,
   pc_ophy_phy_serial,
   rm_pc_ophy_pwr_fault,
   rm_pc_ophy_sess_valid,
   rm_pc_ophy_disconnect,
   rm_pc_ophy_clk_valid,
   rm_pc_ophy_linestate,
   rm_pc_ophy_rx_data,
   rm_pc_ophy_rx_err,
   rm_pc_ophy_rx_valid,
   rm_pc_ophy_tx_ready,
   rm_pc_ophy_tx_done,
   rm_pc_ophy_bto,
   rm_pc_ophy_data_pulse,
   otg_pc_id_state,
   xcvr_ophy_phy_serial,
   xcvr_ophy_disconnect,
   xcvr_ophy_clk_valid,
   xcvr_ophy_linestate,
   xcvr_ophy_rx_data,
   xcvr_ophy_rx_err,
   xcvr_ophy_rx_valid,
   xcvr_ophy_tx_ready,
   xcvr_ophy_tx_done,
   xcvr_ophy_bto,
   xcvr_ophy_phy_sel,
   xcvr_ophy_ser_sel,
   xcvr_ophy_disable_bs,
   xcvr_ophy_hostmode,
   xcvr_ophy_port_speed,
   xcvr_ophy_port_state,
   xcvr_ophy_test,
   xcvr_ophy_tx_data,
   xcvr_ophy_tx_lowspeed,
   xcvr_ophy_tx_valid,
   xcvr_ophy_tx_valid_early,
   xcvr_ophy_tx_valid_last,
   xcvr_ophy_sess_valid,
   xcvr_ophy_data_pulse,
   xcvr_ophy_suspend,
   xcvr_ophy_phy_reset,
   xcvr_pwrctl_suspend_clr,
   xcvr_pwrctl_wakeup,
   otg_pc_autoreset_proceed,
   utmi_data_width,
   ulpi_up_datawr,
   ulpi_up_addr,
   ulpi_up_rd0wr1,
   ulpi_up_cmd_tog,
   ulpi_up_wakeup,
   ulpi_drvvbus,
   ulpi_chrgvbus,
   ulpi_dischrgvbus,
   ulpi_idpullup);
parameter pc_usage = 1'b 0;
parameter fifo_data_depth = 3'b 110;
parameter fifo_addr_width = 2'b 11;

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   pe_clk; //  protocol clock
input   pe_rst; //  synchronous reset
input   pe_rst_a; //  asynchronous reset
input   xcvr_clk; //  transceiver clock
input   xcvr_rst; //  synchronous reset
input   xcvr_rst_a; //  asynchronous reset
input   xcvr_porst; //  synchronous reset (only power-on)
input   xcvr_porst_a; //  asynchronous reset (only power-on)
input   otg_sess_vld; 
input   otg_id_state; 
input   otg_data_pulse; 
input   otg_autoreset_proceed; 
input   pwrctl_suspend_clr; 
input   pwrctl_wakeup; 
input   vbus_pwr_fault; 
input   [7:0] up_ulpi_datawr; 
input   [7:0] up_ulpi_addr; 
input   up_ulpi_rd0wr1; 
input   up_ulpi_cmd_tog; 
input   up_ulpi_wakeup; 
input   ulpi_nosync_drvvbus; 
input   ulpi_nosync_chrgvbus; 
input   ulpi_nosync_dischrgvbus; 
input   ulpi_nosync_idpullup; 
input   [1:0] portctrl_up_phy_select; 
input   portctrl_up_serial_select; 
input   portctrl_up_data_width; 
input   portctrl_up_suspend; 
input   pc_ophy_disable_bs; 
input   pc_ophy_hostmode; 
input   [1:0] pc_ophy_port_speed; 
input   [3:0] pc_ophy_port_state; 
input   [3:0] pc_ophy_test; 
input   [15:0] pc_ophy_tx_data; 
input   pc_ophy_tx_lowspeed; 
input   [1:0] pc_ophy_tx_valid; 
input   pc_ophy_tx_valid_early; 
input   pc_ophy_tx_valid_last; 
input   pc_ophy_tx_valid_en; 
input   pc_ophy_phy_reset; 
output   pc_ophy_phy_serial; 
output   rm_pc_ophy_pwr_fault; 
output   rm_pc_ophy_sess_valid; 
output   rm_pc_ophy_disconnect; 
output   rm_pc_ophy_clk_valid; 
output   [1:0] rm_pc_ophy_linestate; 
output   [15:0] rm_pc_ophy_rx_data; 
output   rm_pc_ophy_rx_err; 
output   [2:0] rm_pc_ophy_rx_valid; 
output   rm_pc_ophy_tx_ready; 
output   rm_pc_ophy_tx_done; 
output   rm_pc_ophy_bto; 
output   rm_pc_ophy_data_pulse; 
output   otg_pc_id_state; 
input   xcvr_ophy_phy_serial; 
input   xcvr_ophy_disconnect; 
input   xcvr_ophy_clk_valid; 
input   [1:0] xcvr_ophy_linestate; 
input   [15:0] xcvr_ophy_rx_data; 
input   xcvr_ophy_rx_err; 
input   [2:0] xcvr_ophy_rx_valid; 
input   xcvr_ophy_tx_ready; 
input   xcvr_ophy_tx_done; 
input   xcvr_ophy_bto; 
output   [1:0] xcvr_ophy_phy_sel; 
output   xcvr_ophy_ser_sel; 
output   xcvr_ophy_disable_bs; 
output   xcvr_ophy_hostmode; 
output   [1:0] xcvr_ophy_port_speed; 
output   [3:0] xcvr_ophy_port_state; 
output   [3:0] xcvr_ophy_test; 
output   [15:0] xcvr_ophy_tx_data; 
output   xcvr_ophy_tx_lowspeed; 
output   [1:0] xcvr_ophy_tx_valid; 
output   xcvr_ophy_tx_valid_early; 
output   xcvr_ophy_tx_valid_last; 
output   xcvr_ophy_sess_valid; 
output   xcvr_ophy_data_pulse; 
output   xcvr_ophy_suspend; 
output   xcvr_ophy_phy_reset; 
output   xcvr_pwrctl_suspend_clr; 
output   xcvr_pwrctl_wakeup; 
output   otg_pc_autoreset_proceed; 
output   utmi_data_width; 
output   [7:0] ulpi_up_datawr; 
output   [7:0] ulpi_up_addr; 
output   ulpi_up_rd0wr1; 
output   ulpi_up_cmd_tog; 
output   ulpi_up_wakeup; 
output   ulpi_drvvbus; 
output   ulpi_chrgvbus; 
output   ulpi_dischrgvbus; 
output   ulpi_idpullup; 
`protected

    MTI!#.x5RVXVUAoHrv0D~,'Z_s_,,[<birBQ[4,}o[xJYURMvbQ!,J]=*_O[v2\eAZJ}zCQi_]kr
    DJX'_B\;2W}1C<xRB$sYU#=$RY}J1KZ5Qm\pZ'(j-*z$Y+<|,[7r!nV~NB21uN#UQEN;,^=?7\}%
    iOI'iRpQaozJ>rTV\$T+^]lrk1OmRV-mpC?BCR,?E~p+e^vrv$*G^_xuosTkunJE$/^[!7B3V?@'
    <5I+_'%+GX{DJo5UERev!Ck\a+[E7lE[nBR)fel?zg,~=<lJw1j1uR\,!C5mAU?_<l_CnaCXZ+Bm
    ]'EAw,;nT<iT[}M'f}Ik3$!1AEOrAQi][7uB;i|r2^nGE},F%%A]_erZ>GmXp@!X=s@-O$GVssTO
    TV@T'i,OV3$T;v,uQ>G7GOG[X}B@n{-|kop!<_?<=K{'li!_oH<]aV^3QRCklYj\;U>k~D;v,$!J
    8+x3]BoXUjGj>oQO*3B!;x}>ToE_s9([J_;a_J;x+H1Iw_>}ERO4~+mzlX'#OeY[l'A,9B>V^;V-
    5[[JkGWIlUvAopkQO%R7};zQwn,K3*wp*Xg}m+JW17U}xmIA>B_l9InCZOR]A@Q1E?To,QlA>z@{
    Y(dhKaK^[ec31]{-H@2w=Jn^$YBmazpA$w-lpiX5kH?K57-YW-_Qx}a%zL<wZr9.$[$+mXwp.PRm
    Azi-1+i$3*-apprB+#rm=\ls]a3B~}rHBVrs\+]jV}IUWHJpkT99l7{HD\ju1[RZBJ,v-DKv%"x[
    1}L1nBH<z5H[}O}}^1~>YTGj?Y_Y;wD[;I5]^Vo@B{^{1_ioNk7CG5s/vaAAio${BDI]E2X[AX=H
    F0?s-Bl1T2BV*XsM=2+-;oppv52x{I<{}J]TZjwnZv'Tz;+xIjx1zze''R>v,v'^w5nw'7Tml-T#
    jBu@w+>vH{Y7K<EZ]__~Qp~?|\~$@B>sKZE~'RI-@YGI]sGizn+n5K_R!Y#zAlIBi|925>+=3Uk>
    }iXq!\X}ie#[k1wIA^?s4%,JEUr=lQ1X}IpG}o#,1K{a^'\WB2<eQ>RzKR>nH\R{uOA>+uvIs@Nm
    lHak]v>;^JJipUzVA>]]-D>GQjz+Ee[\nGI#->r*sVi>5TuHT5v#+Iix[V@[kG<k]@1$=+BHDwYR
    2Uja+*\]K<@|1Qwz,iW{}U1?kze}x.nv?H_x+pza--lCplo{C~Ix>U<>HR75aTCsAG]!=<IH7571
    ?ox7I'&eZC~!s_=)E*v~!pO,a=<;0W$BTvZp#O<<EiHA*W1Ix}#AJ}AHO1YD-&2E7m^+{aoH,-,u
    EA!Esup{]GqeWAOC,<Ba5#AfW5UOm6Q37[xevID#]~}a-7rW\l'?x!xWQkk1~^E[<J!A^5OVZW+E
    3e?_=@eHv_.YoW2pWBU},ew[vu_DzB~l_juBDT5i-Xu^I[U[W7UTAjlr-$QUTz\*K\\Vj_D_O]#E
    ;H\OmEekwv1rG13Ia}Y,;'ExZEm3}es{HVe1eUHY'A@#*l\5]mWH'k*1v,lUx>Z~.BX5_7o<@e^~
    zR1Tl*2Rm0tl\mAz}H;HR$3ra2mOCpYMGKoT_E=[pv}@[5[3)+XfTROX@Ee''rU^^w]}|k'W=lAE
    5OU2$^7G?]nTAjAAQpE1V3wr7G7JO&e=Dx$GA5AIjT*}2W0WE3OQ!Uw?o,{WjD<,2*[?IR=CKJ*x
    EA=]v=}oeRj<O?}YXv;jp3YO;7]rITR?,u+@O3Z7~=j=E7IAxJH=O{?poIB|1u*nkT76"kN*#}-O
    ~Q*+V3siCOw'CAu9DX3H\D#s^x+A;[<E{H<VoxV]'Ke_?7npOaY_II^[?[Kz[#>O7}#{mY~HH$QB
    R*\Zx^ko]zUr,C1e\1A]X]#![#dHUGAJ$<^jK~Brw7[|*\Yiu+YuAEA<DEDWprQ[\uI?,Te$>9t~
    YlW<x?'}:os}<K<{+[3$Ams1a~GCrs'u{]~ve7u1KKnr@m,!Ag,;]T!U>vxan7^\]]ujpk77,2?<
    n?#xQ-D~W^$_^HIZ-ITR-=UOr>}eRen,w+$uZxtY<o}#v{}BO@Yxw=r8vw!Y5x#exKYl9D[^wI<p
    B-jwTVMi*kjK|K>1=T7DeC3C+DmC~77Gu~XvZ{zK{=Ze#}-aBOVTC,f~>n7C'E=+EpRxKZ-IU*'z
    #R<<GRWnGvV\<X=+r_VAI#*MLn&x=J*{BU#E,Tr.@Ar='ZKOm<VIle,uQ3aE|zZKrV=!YHpCKFTa
    @mpo#o-nKv<wJ!N*3RXAU;U?z?XE5}VZ7CIYH=-T_R<I5W^1}R+Uw\v;wY~p5UQ*+zR7~C^IGOYI
    H27oJ}G-e_X^>sl-]xi]37\^7Tp9V_sX^?]vx_7={E[aJDV#=p'3nUuXZ*Ca,^VQr'i\CQQ#uGX=
    jveKQee,{AADWnEp(QR;7HI\^\BrCW12E5GA_^@>sqXTU]S6WI;E]WTp%MgUE[]^a+sXOkw+>[p;
    ruY,soBA>^^M3nW,ZH~r-zT3PHpBK]oq<-*^=EvO~t;[D_}[5^++sj(u}TwclYWYRwD+QOC2C<ri
    canGsMx*#zwlQ}<{n,CD\p^n@7-'Z~WwAwTe*Hzz^OlCVB+lmVI~[,mD;X{Dk#ys!E{Y^+wdF,a+
    vU[lv#>K17A@;Gr^!{\XrW7'W_@7onR$#DRIn15W]xS^R_@Yi_,E"aRn2K{Tlu=5[;,j[aaE!$uj
    CoBD$YWR52OeaxP^J^]=_{Q~e^TpqkrB7e,XGGZeY=_@O15X$1a'#Z>X{lZExDWTx!-=p>eGZ<e]
    p<CC=bZY1+1k+]Dl=An+V*,r2p,wzne;C!qr=_zr?D+sYCaVa$H'oR1:=^jYIAQw5v7_G=+*4G[X
    5h+}Y@T[~R7e#on7lOu\'wljBW$X[aO\Grg{j<5]+7;$Rz{*5Xr7'ij1QovYkrnaj?^oKu<R_OA}
    o]m;<[zztqCn5!+Ta{a]\^7B!zZUz>{oHZeOo,si~1zC\V*Zj<IG<3D=oQ.N7>U;iQ]2CEtRoJ'R
    CH@ujQn3C!5Ca~^<$m!JC5vWG1AO#;YP-IH$IH<H^jQHl{*]DJe}]>-R@IzHZD*KbiU{p0y!o=!\
    oBY]Ke3eQzW}"*>^,&HR>pzVnkU>j*6Qa!*-I=#\l!YcE+vK@\VjnG'aj>3zQumTyC-X}-|x<C[j
    Q$pkYo@^vmVV_xDE$z>>]Aa9ok-DviA{Qv_i+}saFQ5Bw*^Y>O7+OX8HzsT5w_er,W}RT3Cl2Qx_
    c1;XQ=7=;e^&MaUar0[r=_]TUKB{W^~L!sZ<mz5el,~mzKQI95R-}eZ=UHA'Q,WpG(1lwe-5;]eG
    {rJ+UJH*<psx@+A,[,xIZX7?55OZKGOH;7|s=\D^s5T!YQK;Q~Bc8rB?JNA_)7>pA^$zA;qDuZ$a
    \A\\}JUo#rQPlKA1i\3}3GG-y<U<>5s5I[CZ{lSQx';I3Rs'T;^H-<=ls^G$J2@>oIrn*R~?,D{E
    W<wRdwaT_=7\,@nw]FVm2[B@+Q'Zr*NwV;OC8RuQ!<$n-P@7WwNK$@]Q\3K-+W[Fk+Y{7Ux@QXvT
    ?rl=a7@YQ\{5Du*\*w-X*B5YZEj}S{v#[{]l1oa7rD[<p|@-!lo]jn6n-AWXo@IIU>Q0C[X}UvW$
    sl,'*,3ZqT,e~uH_G!{a257m~TH~>lkV!n$!$x+J[b?r+*ImGoK\*n_}U$;OZJVzQ;=lp,C;OBKQ
    BIIOu]z{$D7}=i{$Cv[v+m@>o<h->[5)CQ1$Bk'$Vj7$CX'~8]O\ki${s\'rOm5K[R^#A#QV_PCu
    QlsK,G-vz[\^;kNlap1IHX@Kzv1q=+1G7n!o<{R[oTGm,K5mzQ#2tDiD<fsK<3!7;>][ZYjRe#3Q
    XokQCUH17~4wpHv;l?#|s'Q{=ReToGw~l7r5Z-{K>rJ{n+KVQMRJseM$/Iz$\e3j$^'OxTOa7TBk
    l1vxsn1BR?-zEoG~VHVapWI?l0_Zpw3>Q@-\xR$C3zzO?pvZoBsTH1YX-x~RYu'X+TlpQEzTAQw_
    =^#,<3rko12wE]IA5>&\N+aE?!5l=V>Cs+OUCu>\$-Y>I']{j^K]7xrm@rJU'C{e^L7]]-cO[Uu'
    w2_}s]RD@>e=;7n?C$r-*2#K^T$\mUlB2nHT<\Qp^+E(^jk_1;_=BzDjv6u]2v'}\ipa(A,+-~<=
    I7-u}>^saA*YV<Em$7vQQ^w>!a]+lasViSRaU[ObH<x?1G@nW5oGy1E,#qO;[O&ms[{?Tr~$mxjX
    n7X}{;RB5xuUxlGeBzCHO#UE2nCDJ-sW51H+DUso*l5U*uIpXZ^ez^j,JT{n\{wt$m'U]^Cs?jQl
    ({=3T->A-Z,^21R3,OKQ'/Ie#IAvZ7r^'k2ro;esp!Enu#Y_JVnHHH0\Aa;YVJHodVj-O}>>;LG^
    @eI{Qs]2I[$jukTY$2ri'VR_RwC2meZzI?^RCCJ${I-A+o>$EUY\QTkVGzm,7ZXjvu7YWWk[xjo@
    oY,,!Xj7sI3oIv~RpYDCi<Ax_YHD5'tfBk-[=x^*=7eO=vT_Z8G=n[eAT>aXDrseBUv2+GCm\G#[
    ]$}jCQKYRm'3J_rVssB1-*1Dal2eUBBk7r0D@A,RCa1u7?*^{wl5]1U>11CaxswxHRG{{vOOr}i_
    U-xPj,CR\iJ]zpoA!l1D>G^K\pjsu71o@CWe@I,uBe3}E'ZpB9TV{^)GrRY=fJxRTvZren*AK<vs
    >xC}2nG1TE3<mGJX?V(='kIU{Op.3]pi[Bk*G^!\o>I$js<Wlzn!;=vm;_?;EYkxKv?Gq01'An]-
    K3f+AV-xZJJ#TKuZ6^+w\W$uV]Ge[cXTu;Dl5m?vjmCi@2*#jauvpwQ+;UevUjRk;e$J_o1<o_#I
    3?sbsjW+V*^E!U\7'3jm'\xmkV=r*!-Tx_~BA'UvIdE<Ru}T1GVV3UKjD#>\Co^J@al@u[wl@>vC
    kR'W}HQp?ExE{D>Hj_C@ZaXoE{}1Z7oXCiKQ;DGUu@@I<r)>5^\=11Z?5G,-Rvk~^3x3]Rl2'Ou7
    TQiBwAY7e7}Cz5nlm5<E,auAQ>x5J-$CEBDUR[n!HzIpl*1Q<]~!>Q!k}K&QKm=Ce-W<]RaI!pUU
    j5AjG@1eG#!I}*Ju+pBD7\l*W<}Rj-''VW2W_Z@zsC$=mI#51_<2[TjxUpD5}77fk5B?5Wpwc@wI
    }B{O3x{xG1s{rRusXGl#$5[er-sUE7m2u7K}W]=3^VsX77BYpXp!?y)JIBu}AY'BRjWle~^\7['U
    vmBTs>,i[5?eA!kB2O$^3onC>1v\O?\z*T!!=-OrYnuXs\Jl{3']*YZrExQ-v_$ma,#}iIsE[T[I
    UrZJowz#BZ-CG-<a1?IWTaJ]1{+sn-\\|Y[Z7n[Ul~UUn'#X-AU*TC#{GGo5^OZl\L3Sl5-<KXs,
    \17\+Tlm}3_wCUaomRI<Cpekno\k1vWZxwYl^[x;D=>l{I\eJjpr&xeW*x}ZAjJ-ll<J\VrlnfsA
    ^WXjJ]7lC^+$I]l-1CxTWG,u>DAE>7Lrx;,HURZU[VA.xH@^=\GK>oCD0s]JQzs@J?*;@nsG!Tv=
    z]s=]mGjDj?@<RR$aYG;_5_X=i>Yr\Au3>T$upZ^{TYw^v{xAz?Qms}[$_l#K}_VIma+'?\l5^=a
    nV,$B^3o+e!G_7W'x*E:d]K,B"Arl<jA~w.r@TBe<Io{|e@{ZB_![+'*aj\UBY]BnB{[OOwDuBZ.
    _K5!l#a2s/k5xQYrAl-76'HaQTCEO@A<@J=#,yv*wrUso_m\T]l?5EO>Y2\e+n$a,Ykr>5mE^'N,
    Q_'!}r;=Pju-',^#!Q-{?\[=GJ[mk!58VDZ;&fBp}KX>}7IjCOWB^ie,KHo-wHu,HOImKYl-2O_v
    ==GkOEu[@^Bn2z$<C_-''r\'KV$Cww{n;*=B,=Q*HIDC7^-+!+r7r2$o,$1vz>5^K1k}IHl_W#UU
    @EGrWD@\r@7#Ev2<_K@V#${IZ@^{ls@{xY2XBRT^}A)Q]-T7!$E^!OC}ix'>rx{0l+Yi?n*WBZwp
    W'UvBYO~wo+D#-eweA;#okV,{'K=a5m,zu5;^%'-1\*C=p|R3ECI<jEgJlueae#'$IV7TpRXse\G
    mDu$2a5}\#AOGK\w.!HBaV-lwJODsWXOr!$s]@rW2+rA2lA[]oH\a>Y@}e_GB},W+}e>$D_5TJYV
    ipU_>!}CxE_ZG"l5lr?rolJplE7G\ksK-ZUV>WI]@\?\mk!\uu01AA7~-=!JwUriO2sHw$lDi]~U
    <zs\8tVm77ie?^_XZ#'5XQK5}oO,n5!>D3525YEP1wnnEWEw|KH7WP^p=eknB"lE@>irW+]?_'~7
    BklTJ]~=7izQlK2'inD!C{V#v<yIr[[-,{?A{<B'Rz=eVKKz!*sF3,Tk6r@2Wmeo]1i1?37lW*t@
    j52x5@$Oi{r^;^<U^VsTIIT{A;^L$YjB-hs<l[~7C[,onuETXX]z'mEH<\djEK1@>[]DBrU(cH*<
    +H]}O^JzXTl,lSklJJ*U\+zH_2e!RQe@U*BKoHHA+7\]#!2<R*Aj}@eAX3sE'W[w]pBdQos23T]_
    jH,lXoYZ$H3\6_}*i+rj!7uGZ7J\2rA}^4z^1}B:iE7V7UmxXQQY}!w-\{x7ouC!DJv'_1*V+s<+
    0\2>W%=KHs[kXQR?A5mpiEn+A1QK2~SBk=D!}~p<\s=[,H#RQRDXV-XJww,l*XT}{lO0:lwzulHl
    K$oR*Y{1^{&5In?V<!;Es<Cs>1*H+li#+-7]D"OBwQmCxj^EeRC\<,z#5G'aGi)m]-{Vja>Ywos/
    8Zs'[DAW{\?Bp:|BsIJ=^@,aG7_a]C@s)H}?Y@[Y~v'O'o^HVD^wn^V[1I}p}r}2n#7-[ZYu+$],
    2;^_n1upx2*v}JD~Ri'@O^T=V(\B'z*HC\TH_-ouYuXw~p17YC}V^p:GnAwYODG~8AX'H?_3@os{
    <GUBDiTKK/tsJ<x{Va[-{TOZ]Z[I+m[[U'o?DY~7<aW]^j;D~p'#IIx7NEA5n5r^}*DiKB?{'*G\
    [XQGu8<>I]KR3=~=E1Aso,~Ov}[]=3K}K5YiD7wCeAOgS3$xD?B~Z?+UGVT_H<XIvb>_#ug;j3V?
    VA$[zX;YnZAU\XDe<{kG?'Dk>!C!}kY'@]E_xI{A_*J3**wERj/2lRDKeRasoeD+*,J}skjouarE
    3Xe%?\w-s_O2pY<7BI[T+_Gov3{*d3x$xs+$=@IA;w$TUz$wrv$,]\>wB.[Ogv;>R~<{rN5A{v=T
    {aBisJ7O[\"vWHKW,=JQC7iBrRK{[n}Yu}r$-;{1{Tsb1iITBWv!@=5*zY71]+B;?\+Da'Z,_JJ{
    \[,zR!5_!<orU]=-JUw_-jn<TBCp3eEmd+}JC7iO+KUIz{D?-pW*BvXKUI}HJ*-ElII*BG^jvRW{
    c?noI%@^QOiGjvINAjLo3s^\$#GJeCi\rEJE+-G7>3U:O[15*elQy7ZErQcvmK7j,ZDsna<T$$Em
    I'?Bg$'YopiYRV*',+-v,'m!{s;<+VUoI-=mB-^2DKn7Ian3Qr_,_1!_}{X][TR?[3$-nCKl$,=[
    <#]"~[{YLo]7w6".iB~?w'XGgq+'?XB*U_s;Kmr[Y#CG[\TC'A+7vw\awTOlXue>>BzrVi^Y1K1k
    1,G-Tp97Ovu1>K]#+,oX-3na=Z7VuB2<X'7owI\15Im'Z^@eS=m=$7=Y#~n_D]=Aom{OC;Ym2Ir}
    Z*iV7}aO+*pzUIin$<B_ke}XooE3x'iHW{IOa<aArRC'_epk[6S02zop8+Vnri5<O3[ow2Yv>^wB
    5L(#{J;Y5aI!z-E$BkkjCY$'iH$z@In(^=!J}UpxuvU$WoT<($woiRrlQToo=/oHHC\$#BD8x5*U
    UrZ!2[kH<xO?Q{az;T,={\+j_1ioQ#;5D{7[zuzDSDBA,H=>p0[\2-2C]T7nD=['ko175QQ@lTIZ
    jx_!73G=Q!r*GB,~O=VXK?;[eWu>aAO}DHbQ+w}mxZ1@n={:'']!WxZ>KRGAO1k@1JIl'G[Ameo5
    W}*!s}27XT-BT}Ez@<G@*zHA1TD,\Hp~nOZ-?[75m]JJ:[n\z*pJl6==vV]TGQ,*11p_YUEvkl6}
    Qk-$e@H_DsBI[v=Uwal6J[]=5$7Z!+Ii:<V]}7TaE6I2=\UpJ1VcWsa;BsnY-Ha;IdlTAp{lj<H>
    =aY{u~|\<}}eX]!z$*RCm,uHY?uCH31CZ-DboVlx;<53RX1ovu<'kY;74UAD\EGVIeC*7EY1+%2,
    YrZ6+r'uHps,wX{BO{D,Cr,53+*ooR5uAz[a^DY58}}zuHo<^K1R=7QH~<OQ1[Yzx1zv?R}_jI-'
    a^pB~~RI+yr\K@2zI]2nHT[$rARH\~^EwA{lTu1Al,XT$X^Y2_3L2$pVCJvpDpDDVia7CKIx]eov
    i_{<p*r~1n]'P!^l*$[^Ea'n[>{DOr^@GCwQG+n5X<w!Ti1Z1p-Br\w5rj7E@-GZeL<TJmYl#1[-
    5<|lZ}l2Ul$}*Z}s~l+=$!+#9#G]Ql*@aQZ'KkVP3v$?K_ZZ2Ys3:>5HYQOU$$B7a-,vu_mT3'}R
    \r1DrnI7$oW3{nRD;(];{{Wx\!l=GmuC_JW]H}1DKA~X>;UIv[IKVB^l>URH7'oYlsYo5#w=lA$#
    lxZs+TRjAEX_~Vxpws'spx]XQsIGoZl=,[^X']"K]T*VZsQOiW=oi]wu5{H1OmIf^X^Y<*a<~R[_
    }$<]CR2-FoJas%Az\^l}=^XG[-Oa1+K7vkVapQ<su5"8ZBx<B=iJR6k*nCQT+#NxjW1oHQ1@r}WQ
    \?k+zkA!>$WpOVG<QIp'1]m^I*xza_RU<u~<eRT'x[RA,,^>O+mZa@eDonZPkr*W3[>K(r>jVDJI
    7LygAw*rv1X@SVzO3@TWIIuv1YW[^upTuE;K-5H$},+K-\,@!]xj2LI;mp2_WADGn2^JT]($HaV<
    v[J'W-ZyKC~]wjjzekCi!s[{WlR\Q5U=Y'^$QBoaYa$\!E\p1Wv$2v*Q,CqWRnG<wuwm[=Op;=<z
    *~K121TRi=IC>Y$l>u{@IKu=T@eXEU1G]s~,GCuJ{OTNO5#3*US[\uYEB#172Du_E+J,JWo,~~xC
    i;TmVe*qKXjU-XQI'v>sD>e{m-C-AEpk#'H3UzG]/Lp]ex(R~^YRT$Dla7Q*5-3CskOQeR~5D~x$
    ]opO'wjDGAQB7\uE!-j6zT$Y4.Ex^xE5]C<D$ZW53k$R+pQw7'&A$CZ\CEWxRv;+\Hp-AEU@AmuI
    K@ZB,_-z'lzGpj,*7BZ^KjYsW5AV'+Z=@}[I!J<kRCZ+OH+1G7eE{o@elZ{vu{eIiQ<Iku}*nDA^
    anf'3v]u+O#wIaTx*}ahr2Z5~]1WzAC;pclD~_[]@;yoaZQ[;r@1^x3H_sJOj}*Q~p-~AFp?AuZv
    vB>G#zHOil[R=i>Ue_]2AU:2GrWlky-{;+r=p+uIw#\oI>97^uA[npkm,*n}*kJ1[*'S/n-$}['3
    ?*aY^{,\=~IV2X{rnlzKDD:t^q}Vi]N[k+?l?_O+E]zbks}Q}=nXCx<{H1mzeYRYVEDI*YZ\\oO#
    :DwHs_D(pY[!*RCH5<3kb_>W^7Z@AZepn8Q'W>$zO~naUVIO+E,B!B;XxJ=V_WZ$@2~Gv#CYa{PL
    ^Z{p$TAV*k2*V}l2@G>=nsen(+I3r!EBBTX{s1jVIrHrH@'v>FJ\mzD]OuGEOi7?<+M\}oeY'>*s
    H-jsf{a*srx-D51sX]$Bi=wVHca>aH&o2a5vun~x]jR"WooS'C<@pn1wu,Wa#E-XY!-'X-,as'ev
    xI,{{VXzCC},zu{1~TJw\X\#oGZnsk1apTw1'5VjeYi*xlpi^xxZx1i71pY}rlRB]K'Dv>}+_Yz#
    3'l]I$QJ#BKK;DN={W7*eB<EN]rWQ&@]2UUrZw^C=,KlCi#]1u*xm@!z23eTVnx!wHTB~E_sVsv!
    Z7K[^xK^Baele3xJK^-e?}zYWZ~'YaxZW50YXE!=X=l4OB*Ay3VX*Yz<=oJreV_j[D)Ip>aAj52i
    rQrOGXzRr+[VUvnn1zVe$*E^'3m7eDCwOow-v{!BY=jTs+^=Cl>T[;+[GiTixz2oIZou]X3=I;@'
    Olex$Q_H5}z*vWCz+T22$I}UR.2}C[@rk^#p~x#saRpDCz*{KorzaGw8IEov2SV+;op[UCjVHk6l
    ~E{>zZ^~YwD?a_vQJ}'5u&\;UnVJe@#EIa,-pa;'&ouT==@n77$K\$V;!Y@Gl.'wIuH-H@iBirV5
    z7W\<nxWBzR+rsYXOv;<Akk5oE!He=JXIWj]2Ka<@?_U2pDB#*#Esngf|*KYkBEQn1W2C2xCa@$+
    nj'7]QNAU!;an;Ue;>[Dg^YI2oU@uLoC''Q-Xvw^zlI<I!2_s'\_#=1ko^_rlOecixTE'5z~'1Bk
    -V@CnDWAiar@#7#R/_q]3TD^CX\IOA?:TD1sxX-U'O@W$w_K$;u=DjV1_R-VKeAwAr?H_xR@Up#+
    Rp_kDijV#x]>ei{X\>>nekRWw1l5DJR3a6x7JCgb'woV{[ACl'v^i=$DBVvOl!{m3H;<Q@O1r+s^
    8Ew^3$~reEEXOvYruYr$;kpDae3=;+BGr{Em^~TDa*v}G17K'4s'Tno_zoDs>V-=;G#$7~=VID*k
    @?eG]j~lxU\.]mDw2<1Bkp#Tfe]wji7vAuv\,@YUalRYW'Z{]CnEr$AzR5~;>sO75LQwz*lI[O|j
    O-^vBY{xZG{{*w!*pv}X*<3]{$D!p@km*TlKxal<_]j_x7+XD*e;e>Bw*\?C^kpDo~$m5sV>7rno
    E<s+7JaYz+{GAEa!D[k3[TooBD;UH,$!p<V.{5i>Bj~AkI!K73_$]As!CWfXxsHrOAvWH5wOaCBh
    \KE^LoG\\]GX*?BiC^,GTYUuW{sH2pC7,5VxufroHe-^u}yvHpwrV+nsVvziO@w3$>e*$on*_J1o
    p$Xs~uj$]=zT]T;o{mwUv@?YV<xa*$Jv?$>1e+l-$+A-aE;O[U;x\'\KRO{uesx;sQ&9mve1xks_
    |{YDnmIeRazQwl{mD5'kWK[GJpJZW:omZ$ro1;pp$;l7[A+sH}^uo@Y-$?IW$Ot"oiV5K5Dli*]K
    zU3ZCr??aBi<b^Uj3?p$DgV_;?1Zv=BArv.ra=Hfe'<pvRW@T1<]0T$s_}Ex+v>'TG+{1nO7mr]U
    Zre,!@sJ\VA<p,7rxeD]*^:eo$3UU<UDG5!iE+se7K{=;7O-};{!Y1?PZQZs#D@[V@3^^CxuTR2Q
    Y$!a|H=3U[emaY1?@st_'5WraDQ}Vu71{*2R;A>Iu^mk=BA'7rYTwAki{'EWT,3nl{T=G$];Qmz\
    +_\&jAvT0C2{{@{UEO~x]-Q?Qv@uBI[$\Dx\}aoRIin7,,k1]XwBA3^ziXsWA/t5Op'u}8V{_<fm
    {!Qdz@e5Xv{,,+AalzSM6QKK]io5arHQA{A^-Z>}WDYDwlIsRXVHzm9XpCXW*+o:wv}HCup^?vVr
    Ax=pDBOX'oe,{o7YioVDSnVxaIzX;3<Q;}KuZpsi,O!2^e,Z_*Ez[5iB,'-E#@,}rC'v^E?pT$;l
    l<C>~wGmA9jTO}^Ckp'{Ql2x^_v+<2%Du\-i]o'@lew-TUpIRG^;5{EJD=IbYss^*=sDKGKrM$BW
    7CO7DI>u#CWov?Q$[{\U{zB@,U{xQQHerzxjQY'7}21Dr?'{oB*^CY]Yx'\{O6i}l=De}=ATOnv>
    m{,=jZ{[eHQx{aorE<E<]sxKaQxU!1l[l;qf<Cvw{Q^kYsR_<O]+=3UT^up#!UZ^~==W_J-u*,is
    1BsTCC5Dp0ei<G=Z!{KXX_ZTK^Je_7-$HlapossOA'Vo,KE_EO,'IZQeOaCJ~7mpzDMI{{AzkC3i
    v<2k}ZBq\x[BwRV{EmvvVC_wn{>>'#5[T\,rpEJ#j~l2Ze~v3\_i(k_o32*<K0,-'$eaZI[EE>7!
    BpkVO1{83eaKZww]X>zXG;e-Dl#{[X2sZ\5#+5'R~s#@X={5-X2Km>U#Yr*$(m+-n$m!?UGz+_[a
    5x]DXHIr+^>sHk}^aU5wxA]V!nIn,1=Q?q8v@Kp,,TnFHnXp;[,U-OI\DI,>yT5i#*QzV'\5v&;A
    2o]}j}wnV$Q#x^3nKnzHXV^J!U,v>s{CZ@#j}D=}V^-,={Y}euN-YO+V7GvDv,'vEGIUx2u]O?IY
    +nRjU$3<*i5O^J;AC[k~{TsV]kHGmVZE5ze?n7oo<Iw;AA}oGI{AY7s+<+}slk?;pek&3l^XHj3r
    Op[o#a>xhojJAPWr@m3pi]OrJl!TIipIIB]E?a?,oA9E{Arx^*=x7r\zHOshsuWrUe*?IY;r8,9,
    =#p:6y/zKuaD>w2@-O$TC$[dWj+uZp[AR_uXgkV1}aUU<PQro<kG$5~_K;x;5\UaeG{C}e)1B?E=
    BAW$GTV]\]*C0@jKxL@l$Rka@U^ACJlXelvlJ$Wv<R_KU@_n=u|v2-]]sJIH>z,j\Oe};mkCnoj+
    CxsxC?nv]+G$R$5-oKJxkZ?K=s2C[#Z$NFw}J*E>T7Q[AxjYn>T]j,\=B@?S,Yurl7iJ7zYR1'*1
    e]Ol~nuHGk=uVjX=QHj[wD7$HejI\<VW*2z_3<[OpuU'}ZlDd1RoK[v*-k}-wlwevJ+W'IWRe>5A
    +3{7V$,u#E7<*R?Awfz7]1KOxHPj$O#Ul_UR>vj+A<D_\DmGrJAI*UH[j\xBGzi?^O!.{CH@pa;s
    !_-U{Q5Zw*)*usknQW$TBmE#U=~B@\uS}~3zx[C*'ewOjUT7p;RX^J=$0_v'z=#ZWzi1]HnC$Vlv
    1H5mnyWzw_u'r^9e,##AnxQC[]Irn*UxJ+B.GX'3+{AaH{,5OXxGl!I^=@e36v^eCEEs,V=m,Q$]
    a>Ep>;'l=iO71iIOZRCrOTIR-Ou2w]H[exmwsCQ>oJp=Bb}D'5zuVVn^,eQ_$@H^<_$Zz^+ajwB@
    {ubU*XXB4V2n>}_n#R^R{v/'{'${T[@dAjCCIAUHHwv^RzUmHHJsWo1}nGmm}^nYPB_Xo{Hw~!+Q
    ~_0v1_=<C;'pOQ5xU,zo5H#X<~~NEr!vj='KAp!~zXx@Reu-lk$~uaYH@zHzeiQRi>e+rRaUH]-\
    =<7+~.35UV^*X[VT\;ux9y_2Tau,VurYt>\j7mG$=3_x;rEv''OI+=Xp?}Q{\Bn!Z';@k,kZG(o_
    D#kC77CR@YQX2,wAW-:XU=]j^Xa#E\!eQAxs~R2M'Bm[<EEn_XlAQv+wX[n3nQo7^r5~f+,K3'+z
    7QHU3:e[vm\v=Xk(W[Y^O],]Z]\U2BKBkv,w]E+5BKv[InjVOHu>.Tpe!rs=5R2OG,!Zj)e{7jFs
    O}7Gc>\_=A7Ex~7vl>j'\EB[@EE!C*'AQKj,rDQ{[:;<21kR*a{I?H]G'vN\VClX_BT]7;HC_mOf
    ^xxZeEn;z<=>w^-mWQmjCs,n+V[*;vkOioXrwo^AnnB3Me_Xe}Ij_'T}@['vm(m$IV+O#['Y522o
    ep'GXT=u7;$G!nCC>_z27TU=Ws^=]};$'Q\$3J/u5zuDOi;ElezOxaGbM(BB1,%*D'[{Q?[f5i='
    ]$OsA_IxmzI[s\$29p<$WW>xJ;Vl?q}{}v]kl^5#Y_f[;!p$J7{wlzQ'$z2~5<lm{<J5\?+sFtu]
    '~O\lXD#o2s-VxI{;2T'mkGA_X\5ERZro3,HXKH>W$'[+=oDQKxiQAYpkJ*I7X>GnU=jar\CWDcu
    z~o:\O?uFzH3#YE'm1B\ikToKW,C,<j~][KBU!apo2NBoPKe\?5{!sw'$#Ib!-.WYK~~l],wG!][
    1<7ET(g;w@w5LAw~H|era!+}k2}2a5-,AK^o_=q3rT#pC^x|VW,YGapWw7
`endprotected
endmodule // module vusb_hs_portctrl_rm

