/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_up_int_busif_amba_apb.vhdl
-- Date Created: Thu Dec 21 22:43:32 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL:$                                                    
//  Author        : $Author:$                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Vusb_Hs AMBA APB 3.0
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
//  $Date:$                                                                       
//  $Revision:$                                                                   
module vusb_hs_up_int_busif_amba_apb (clk,
   rst_s,
   rst_a,
   up_endian,
   s_penable,
   s_psel,
   s_paddr,
   s_pwrite,
   s_pwdata,
   s_prdata,
   s_pready,
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
input   s_penable; //  Read/write operation enable (enable phase of APB)
input   s_psel; //  APB slave select
input   [8:0] s_paddr; //  APB address
input   s_pwrite; //  write/read enable (1-write, 0-read)
input   [31:0] s_pwdata; //  write data to core
output   [31:0] s_prdata; //  read data for APB
output   s_pready; //  Slave ready (1-slave ready, 0-slave not ready)
output   slv_en; //  read/write request
output   [8:2] slv_addr; //  address bus
output   [31:0] slv_data_wr; //  data write bus
input   [31:0] slv_data_rd; //  data read bus
output   [3:0] slv_wr_en; //  byte write enable
input   slv_rdy; 
`protected

    MTI!#}eV?BQ~+pAllu_D^'I!nd~AO;-]>}WEe[\;W{7"@Co'exzRJQWn,YC[KUAn7,[n.YQo}[DX
    QZ_sA3D_zwnKBR"|,kwAl<-VOAl<LVR%2Eur{B1]G#[iUX-[p[?p$m5s*~e3Be{RS#5E7u]Hr,4q
    ;<*\!<J[mR7J'qEeERl,G]Av5{GJ>Jvr[kYWAk'}H{_kT^b^_1YZ,R'wzm5;H5rKxDm!1Gxg],Vn
    ;A5~y+$krHBaBz3AXe1V,KIi~Xoz{'_+?<_<^lus[;=V<y'WBoY>7D=a]m[<*7OV}^w{o}QO+53E
    3wI;Zw^}jronn}K1UGEQKKO-sGiX1359uD5n6x,_ZYp$@+j1j~G5]]u>}:C!mQ'*?s>T[#eWaY'2
    BKXU_=nQ;W#eCem'J#oXur;DHr,*O@,#jJ>\1@maH'Q;EE,;ZUYCOXkDB[\O@~x3s3B_<>Irix1s
    ;7rk;waC{xG{IO1E+<GtR$aV=>CsBXz>=A's1J-@/>q{X2]Fi7wBj"~xpisG-E:,2529k1uJG3YI
    o5pHmD^HIWK5tG7@'7?o;7J2_5ZOz3_(}3m2:p3A]I2~WaplWL9g<XeW$_W*]*G3<<+G!ap<k*;C
    H>!O5sJ!}~D3_='{7I+HCZ^iTO?IJe\a|Ao*\bv[BE5kXk*Ba?aw*v\S^G]7p@lWk.5%Hri+7JZo
    ![^]A\k[^JTQ\#Vk]8N/*)@YX,D,#pJ$Z>{a;5~[nsU<]iczm$1T]\Z@CQEIEpajl>;D^uj[_[>,
    XW^'aJ^STI/]RHWHvW~#Q~kmU2'K-$}[;rT1@a,!,?1}@E$i.Ja}Bjxl@:BCjmuRXGO5aDJ.3TQD
    5{Es3IQ[]X~{7{G\CT]De[!Bn>D!2QO1Tx^$Cave3pkTq^U;I&;oxp<OjI@r\?^6N?\?YsX]y]K}
    o-GW=$3_YEVsx#ei3e'mp!Q[B-pa]IOX[WDB>O'*3%7n5_UDU!l\~J7^a10mT\Eb@[DED5}vKGXE
    VsiY,Q!KYOJEb7],XD?w-6^+vE^AeHDO=x^Ur=:Q3rUI*wKrG~<ZUvBEO3]D~O{'xIk*r~lBem]-
    E!OBw,CgC<'+s~;Z>={o:GYDB>HGeFE[Gi*H3BF9WC_K6in],]E,Xx*!rXw5-QoxBWw+lw'<GY<T
    {,A=kAU-rXYeIL},@G7zsk$<D>*,s{,a;XKo,2oWO?;z,CGk{lHw-pF8N&_z>Ye'^lACE,jxRI4Q
    E}2:E!A]vuVoaRo'EOmI'?9lEY>~oX]>]Zpf%|)];W7a'>5uCYVXo\U{\msx5j+[An~]3\k];'\N
    Hs2}iR{o7vA@7^ZvQ1v~[\Q*a[,pOmv3>\[Z.-D{lu}Dler~H;vuJ-<+k$1CQ[~E!!*=i!=Di/LE
    \5anw}!]vn;qYHoj:@,G=kt#lQ{llHC=?B'O<aDlZ_5'^VCvx\Hxssp+DvY,p']"BZe7h[-__u[X
    >smD,$RvYU55lGsl_jXp5Y~ZA]>5>u\>oZ{OJ[{nA{,lpm_3VR>!7+[sup23R_~}xY5'*KD*$O_A
    HlOB{V<A7seO[E!@ICriJEX,Z}'OiOUrDP,J]OE3v[}=?T_j~{r?@W!<]}7!z$zdY89HEKCSB~[=
    'ZnrnY[:aDJ@MX7?UGq'a]{'ow}Q3I]u*<IGHDRBB*F|7k>o[>5XCkB~*u;mbH1I_E3-B!zuK[:R
    z3{qI_V=^T,=$#{jbPKO+<nn{$hREwvaGBrajluCeakpsZ{D$X7#v!p@1D>rBC!evl$#CBK*\2{Q
    ^b["^C>K#H]=]Z!}zejIc~X22$rXV2Y5wjrrW'@\^_=Kn}*UpT7a#?RxK@A>,g']KsjGsTva^jsB
    ;^vwC\r*zWz!7Y\^@^z-5slK[1r@Vp@-xuovHQL?rT+CDBQp?5ru,=T\o^mk5wZ-aa>0a[w+1j*V
    &WlCOXA;@yOQ,_r^*po5Z2CB_o>xnH6#aY#aU5A_lW,iI}7e;u+zkK!DiZY_ku'mH@-dOB$*bl7;
    *c.nzW@\?3n$Y{Z-H^?#]lKCUO'G}1jHx$js11ee^?^eunpm}zUHlBw,@[_YAI1Z>;=I5U=Xena%
    *3$-Uh*w[<r'AahE[eRgQAH?u5?UEY-,_KJpO-JQyrnwB<>{]}x!Enl;!v2[o]Yx?^5[$,HHJTX+
    HE>T<J|uBYO~H>XQAWB12^Q@{p*#<E,Qmu<7}QOQC\5BZA=W-J<[k<$5^$#x#s~Y(BuRTqx(BKpk
    jD,i+sJ^MT>1B2lIHzIjrRY;+s2vX!<[Xv'rHC,W7e!@'k{EmnI?eWYQCo?XlU*[xaQsra[kC]z5
    \aTYwxhxG'z*$U3'\[x*MK-v>WjDn<eUzn'I5gZ]Qa\W7=6]K$5D}$j=w}5!rH<xJl^{{}1iG'xk
    }VDWXj3',}Cpa@^73l+>oOA-AOeMFC-~*^}>+Npn5=S]2RQ/EHaIdXQz^'5UJI@xse^lsCRuB}'K
    1=1KTfYi3Gw{Q^]CiJ>YmTTU8I>A<]0,?UIoD>~D<
`endprotected
endmodule // module vusb_hs_up_int_busif_amba_apb

