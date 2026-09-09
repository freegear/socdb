/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_up_int_busif_amba.vhdl
-- Date Created: Thu Dec 21 22:43:31 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_up_int_busif_amba.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Vusb_Hs AMBA to Ld/St Interface.  No splits supported.
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
module vusb_hs_up_int_busif_amba (clk,
   rst_s,
   rst_a,
   up_endian,
   s_haddr,
   s_htrans,
   s_hrdata,
   s_hwrite,
   s_hsize,
   s_hwdata,
   s_hsel,
   s_hready_in,
   s_hready_out,
   s_hresp,
   slv_en,
   slv_addr,
   slv_data_wr,
   slv_data_rd,
   slv_wr_en,
   slv_rdy);
input   clk; //  system clock
input   rst_s; //  synchronous reset input
input   rst_a; //  asynchronous reset input
input   up_endian; 
input   [8:0] s_haddr; 
input   [1:0] s_htrans; 
output   [31:0] s_hrdata; 
input   s_hwrite; 
input   [2:0] s_hsize; 
input   [31:0] s_hwdata; 
input   s_hsel; 
input   s_hready_in; 
output   s_hready_out; 
output   [1:0] s_hresp; 
output   slv_en; //  read/write request
output   [8:2] slv_addr; //  address bus
output   [31:0] slv_data_wr; //  data write bus
input   [31:0] slv_data_rd; //  data read bus
output   [3:0] slv_wr_en; //  byte write enable
input   slv_rdy; 
`protected

    MTI!#-CR2Ta^T2GYB<Hm-As!v\kT,Q$HJ1?XT=~QQ*P52}1O@BB=#*$m_2]KE?3y[q,I;np''seY
    ^@b+jR7IGUl=@]e\Ei\TVw7><wVVlkK*s{-YB,>Vma-RnjHy<<-24zzOZ!r#WEA_}s;s@#UQHv}=
    !EYGJ#{oXlC13G^!H,+D]'GVjuQQi5<OBE7{2*uVaB+~Z5/R7o''BYORNxp$*BJ=\O#wT6Wppr4H
    Az,C;~XspX5x5[=jo;evax!Jo'^vz+{uQA!A\W#9HY![[mCo3+om'4}w}1?<]GI1i$aoQkQzZ+7i
    Y_*Z!B27\ByU[+_+RlmlB]K<V2<g_"yf]U~p'^#n7kQi<U}m=$(-Up3a[T}ao-eQ[?a;^=Qe_22p
    k^s-5IZ;{+uz;2jBvY^Gi~r5TBr]Kuk[z;1x>X;[\I?&%e1Wa'#7Am-oGi[QpO7H~uR<sE4Z]_[-
    o!@j7Zv?R2T*ksU<}ikisA~$DK~w[nO7e@?,!rRyO*YiC-BQOEW7?HrrH57_}\Znc}-}ATo-^(ls
    J7]DpO#wVV"62j\~^uUTrI!l,P[{U+]Z$ZBWZ=PGT}33-J$<n5BsBoQ@a+^\YY~s3_{1]mDO]K;V
    C}<DKB~#>;OJ\?-i>7-O$j~1]'ZJD\TT_\7]C[7q#X$xY!DvkomK#1^-@5\l#oB3{\,^$w>njC,W
    w*s~YQ5Caa7R?nRE#B@B?5Ip<X[{BYOIEyFiQE[yRp5|@1,+lRXIVmBHF,@'aR22Z*~r!^1[[[E>
    ^y3Q,e!{VB)7+mm$N|Oc-U\Qn<>3u+r#z=mV^R}BUx5'#1H]z2K+UsVTKY*7UOaWQtZ[I~C*2[b?
    {D[C|\&NWQl<6{V>$P[ppQ=Z_3%x+@mt$3Jx=AlKAU\wpYK}S;l_k3X<YUEu<aj#rQeAs;Q1:-<*
    v?,?IVE23Z>z@X^K'}!<,R#-W}~wu[l{O7CD]sJ;rj27k#{e[!^p7|G@5DbnYT}jr$nRm+^h2=Y7
    EIa<oOl5rV~!XG2z-A{}^!\Uk5jpuA^'G>ZA-]H{l'@a]>,BR;~>&4a}@A=>AC~hl@rmQ3m@73pn
    oD]H^?uK&]D@k}CzV3s>IVzu[F_!v*@l#{ARWnpQ\k\7?2_]ei[>R>=KpAJ+JEDxm@1+\7=p$sEW
    *Yz+l<~zl/,s$ANI;[7c~<@uP_JG\9#.Lt=B[Z-[]_?*G~[ua#Q!Yrrsj}*!@xI;p>+H_'jxQW!^
    v1?w{2n^VEi]XaYBmBRG2@i]I}!D#s<r!1oxw?Qr,jr,,;O[-U,vo\x^7>pU'>3r<J7zou-U[lI}
    2G[Y~_wn$]B-w<>[JGOT[2\,Y]i5<<r\?;BK@+=n5#>-}'^Z1o}s7Rx]*]^uwOrVJ3JlZm@o_l#}
    A$6QK~{.Q!Z2GU[{ejvr>zr~$\[$'_K7uUnaw5iBGip^~aWV_az-)|e~YJ^;OUnH~BH5!;}ZDTn>
    n]r?+?3_pTP)YUj;zD-J7FiQ1U%ezVDQQ!KIi3#[xw}5vmG)}_]wj#Xs|xxoB{wH@CQ~#Ci5<[[E
    VT1kvvp=H>U3lEKIKNsunWr\pG]}r^#V^?[a[[O;ukG{{1r!a=$n37KwxxD!7-Q1<'Y-\_iG+Gr'
    O,pezo:w'=R^?Kw'+X,/q{Yupl{jEI@o!8DUB=7#}ri\nH6,X^TYuUuXY}J}!u?3l^;I{+Xd{YXX
    B$Ip*T~r8|_mJ3Q,<@Ul]+MAa7;:P-wDjGk1;A_Yn|yo<wUE~B]rRr7sn'?uEr;bA]'sRC,@EE-[
    Z[Ze7H<OTGQDO[,ZC,rC;=\1^5\jwIBaYw;m$**1,BE*Y{-B,@x[,!XX7@]mjV@W+vR3vE~OGin,
    MH-aT'5sifCr{a;>Ta{_+,rnro'!K}r=_@,T1}r=To}IDKo3*7-H^U>vBZY-TsQJRu$!Qs}_l,'Y
    ~'IilWzvAe@}@eKUu*}[jnpEajA,eQe@WUHz3,ZG\D3<-A=RQrI*@EehTTojO\ilT5kx,V\7O~E7
    gz27JRrux!al#RWu@p$}B-1!7o^#ZuURI%_,v#\na?_JWWQI<+]CD5x{e\I1__!sTR+*}w\a'w\l
    KlAU=QCD*s~[j]3sI$r?[C+leTJr]wHXn}B1>_OB]j#OQR5i37QM,~jo#V@TvQi[~>X;;a+s@O;;
    iD}'k*]nx?@IUG;j]mY~_]_$AjKR~sir;vXm,OK>1Q5so2Kz"=xGuVY$_WATIc+>J^WlaVN{=]BT
    HbR>!=w5-Vp'A=;OYRAVU\L$T{,C-J<[T=aOmJCO1^r>oQiss-E|%uY*!yMQ5lTnvWY,TBT\$^rG
    @{{NROewn7K>P;SxOU,;D+Zh5u[#xm]X1D+RWE*~~X+rqK*z*M*X}EXplJ*n7GX[1Bm--7YRAOx{
    oW=IZHRXQ2vw}klm']oU++YY#[CKD^sU1O7?lxa=7;y}I<#CpWKlu]Z7u<5BZY1x<uGG$V+C{'Km
    \IAsp_;@-8o1[paDeQ@C->N>BC1XoHYBi~a$DE<vw,rAR{Z-=k?nD=;6DO>ZQ!Cx}mYpQ<_X,@2?
    :w5U-CwQ27El{WBuQJn>A$UDZ1e^JZ81e'5YAxal!pk2>e^p!2K,aWp_wjI{=UCRozj1!DTx7=1_
    ]1aurZ*BA$w$3Y5A5K<g-w3usnI!oMp?Jpt_w$'!<Dr^jnX$lR72l}~OQim%[^puKIm{1/}\-D1r
    nT5H73E_\z$3~1XD@}kj*B<Dmk^7A3Cue<GxH<\?ZW?{7?WY@U(x!{}]eI-~+s~o~@5G3nv^Y!1z
    j3Zr~HVixAr=HGI[z{o"p"[TDI{$eHi52obQ_\aIe?as5K[+UQ]R25$rLYE}Ol;ej7Y-3Y,OAZTm
    avmC77i7KX]$[&Q+KpfRaA~hPoBYZp/Gi}ip3\T~e<xeVW[I~aG{eH#/
`endprotected
endmodule // module vusb_hs_up_int_busif_amba

