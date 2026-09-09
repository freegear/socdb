/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_dma_dev_amba.vhdl
-- Date Created: Thu Dec 21 22:43:20 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_dma_dev_amba.vhdl $                                                    
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
module vusb_hs_dma_dev_amba (clk,
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
;KBa6SQ:5DT^<2iaSYAlfo84SX:IW\?e\[LOX^Yld:Y@_kO=KHhgMa:LADJ9l]QY
_JhRJe1nogqoMAKS=gQg@lMA`36_`h^`>^Ie80nqYgC;C=M9QL:DdB;LA?o4=K:B
j48F?3;4KI\`YUhVDd8\m@8Kj;cY=OAhn^OfU:1VK3BZR?Sq`O;LmGq:VVgAg:aH
em;GQ66=e4N;:f=2o4d4fUXZdqkE<ijYBkgmi;fi4TgkieokI^^^F2HRUMG1qloG
=Dd@Jb74Dib04_QckqP\hAHUnYRa<<Ll33n]5[>_20idIjLS`<qJJbEZ7JcM7B9B
NoDUMO9R`An^1;7Hc\@kcp215En2Yn?k_:9HFkLCHc3HLFf;caXFPGpA@K`F7]<C
mdbUNlN]P]VFP]C2<:K=B8BVmCYGB@kp]_41<TE\bd]gZlcUM3>R36dGjc]7JKT<
3o`Lb1mB1nU26^5KcIg\60h^Si:h?C1o:3SApPJ[h8cNH^MaLSXS6QNB\hKgH>;?
DL`mCkE1p^cMl[l3;oci9jeojZGK[ABq8U<cAZI`k_b=P=E3YHiqm7ecNU7aDRCl
Y8@X9dOe_JXEWZ\J^<UZK1m6n?aVJWp:N:=a341VR59SMnOiCR6hZa3QKbcICMk[
FG?\<^jj1q1<h_]LbiPR>_`G2>66ZOFPUfWM3Bj[M=RU?bq^E<oek6CZa;UCiEPN
4UYm8fBi8[>@3U]\cVIA\1aSYPn^o\UJTKQG6p;RcR<j=lG;\8B[4=NBm:4V=229
[TGFn?mYF]gapC7Wda^MR]=VBTH?>;dI;2@b4T;k5l:6Vmkq6?Y>8OD[Ki_?[OX;
aBlT\@Qa2WAOGGSk]QqE@@4M<;ne^X_gMTOpfmlgWNZ?5HHj=Qi:aE=8>d?_aKd=
@EI?5Rqb1\R1\USbL`GSN9?fUNLbE79oKhj:c;og1F6]5L?1gM0p5BY2];cemJF=
g[_B<fO14n\FmhF51h>X58pDWEikEIYJ1FR<;<6HS6=AmM60?e^Y2OeMVaE^lfH@
P8=OTV<60lGL_YJpcY0IY_Fc?[\Th\Z79;CmV_M7DXX`A9P;0IG87]cOkYAnVO<f
I[;a8eeDNS?kaTVb:VGZ_;5opm@j][536VgfNW7cjFM9ENZ6cY3bIIGNZFD[bQHi
ecMO5qbGC[1]GJoWXdck7P5hk2Re2EU?@44TkVD66Zq<@C:RZ]B>kD6TL2Z_HQ;]
EI:TLV6BfcA?1^_i9p?KAkCX>1ka6bhQn`EkQAod4ieoT^;ELnZG:coToBkGn5p:
2<DebYkmNAK[\@MM52_IKOF>\:><Pi>I[0g\I2^qQ@iaQS;bQ>\T^WY0jPbO^G66
;Dk;O@nMg`bgoT0F\FlpIQ?1RFkDE9molKkS0lTX2mq5Fd:=U?9IeK=a\BfoodS9
?MUlF<7Gbi2<8jpL4og\8Qj8R?9da_IQCFbbApZXB@edO3\gWIdXfl14E4GWBQ@B
>5=4`\J^NN=EnN1bLpAf4J<QEU>PNQL><]N9_K[]CR4UTk\1Yic6q58\Pg[INoP`
c121Daa8]:cT4LV<=K_QUPJ_VS\;=`MbIgJ?fq^He41QNe<oN\@UW8bO8k04SUHA
o6e3VgbeMRb]ibBkIXd^PHl?EDcbpQ7ObDHYEfG[@Mbk3l7fiXhl[e[N0a?9\nVp
3nlI><Ee]AW]1W]J:]_X_RiWTW9UKfJF`b9gJo:X:88iUX]Zp8@ZR]9g4oYbNC6W
bT4N;64_<G8[5S;L910HiBJZhJ_I\N5C5PkIma1qcN?\hRneO<2]l4fb?XFamaH8
CU\ob>>:e=5bVYk;J\KBWOXGC>P1P8j@p_TDKoa6e4W<o<aRS1ki1[oH<[l]6CSJ
a>^`S[BgG1X978bLDL:Q=GYjj416Z7Iqlg8YknnmPBJQg^h5J\_1\eNQKbOV7K`Q
]egm06:G<b\m@^1h_D1QVQVh:K:Mfmq2?^3>>lUUCFM1BcidGQkPPVKbQ\Bg^VZl
<\08?QRmc0g=Y:0UP]ZQ?HK0Jq5j2;^FH4WnG7icaaOdPedLKAVEel8JQ`65YC3o
TL<lA`V60ibc:i;Qb_4M82IhIp39gOJn;JLOo_`>:aU;]4KV<h_eLIi75aJKHS[S
@VJbifYoc@Oo66m0fB<6P9M72p4WndE4c<iWk`C1i4b[P4bmqA<U;>PW[[XBJ>51
NGHP=KhV:S<L]UUJjai;hAALYL>elmBR4pi_@_PBY;@o6SPi0oNgB<2Vg5FZM1lP
Ye][e[ngSh:]2EP1KQ=0XL38p5E4EngK34U`1YmIOH`<JiK7`FOgb:P:Na<PmjCc
CBLV9>QJ8Q>OLiRp\QUOA;V`5Rg`Z:l:kh4TCKBQ^B0mZ0N>`f:SSRhaS4LJmG5I
qRG;@UIRXbY]jQd]>2iiL5kZSE[SVihDCaZGAY4aLO6L5Ccc2:YL05^qn9A7T\lj
Se\g@I5QTO51WZ>]HE7gK_K6X1gBFW75gGW]QMRNnfmg;mq6m9S]VI9Ul@FnH?e0
2C[<iG;0FZ9Z]a6d2RSE[L8TVLbQQK_S1qb4b804Ro77n0fQBJh<G7TKh`hoD4S:
bXfUQe4?dC;Hj58k`V<:qiKCSA^bj0ADUA<\DXb?phU7SmCB?3`EG5eP4:2d`I^1
BiE7?;eiiKmaf1?eBcIOR3]Q3GB3TXcXWJCqCe@UXE3FZ@9mZikG?jSQBID6W;dH
>jLONc75f9hB2[HVQU99haEG_Em<V1qfR2h?c=`_0PaiR<0_90`_1XAQbY>]4?<0
nk0cMj[Q>9b[kji3CpFMKCKOYg6e`;L3@Q@6EEGm@EeQdBAH9XnXO=TB\DBanfRY
5IOXp<dN13GBV@Y=O^PknP;J<QXoAE^;a?`jWA96KFl:4iPJA;DGi;^pkc\PJILZ
8PIVZXamPW0OYAgQRL1Qa:inq[Y1cbglmiY[N:?<W9GC]C?U_Hflh[;VqKOj^j8D
`64T@H:o=<X?j@Gh=;B3WRVfG_BnJMEXmh;IiQU9BB]fdD9_fi8kaqW:3hC1[CWF
HG6Gl]8fAUJCM@cU1]BTb_A_a8;<qc6mBR6;O\22=AK1aahc8gTfCgP>aHfeBe0n
nnnq2B_HoNCDWU2i763XMHJbQUD[^6pZhScXWZ16OG^PY;0LiNEDVfOaMhFB];1?
cp5KbXH]]PE0^UGm_o_I7dL8Z:EN84;e0ApG19Ji;L7kQInOQTgI^DHabk`c?Oh9
a3moSk8T1pEfT=@ZAXO9mT2O>PQN7d`VcpK8I;bIGL2AObH0G?[]P?NA;QY]bGe8
qm5J>8bT1J_i4<OC\>7aT1nDHlWL040V2MRl?jS4q52UW1m=hD;d>H`lmS_?0`AM
;9XDBiPEDm@BdOW<pg^i8[N5h>;KBgfE6<gR`2=R0QPfc8GI4K>i9eoeI^n727Dq
eedeCKo:=oQF3aTUo81:T>K2A`60hSg^nkq_J;k9C1SC5iU:nXeNdJ^gOlf0N5ln
o1?g<ZYpU^RNiT8XBRa`3nGS[4dU[R8GP4pQTgY>HJiVci>j\8^9@\Gk?O=NQ6JT
SWDU7M^oo<A[]gk=\f>@4clMcm^U5kfQnqhOkaX4E_6ZjbT<1[ofg[E]P=QWO<pd
4E]FRn_hS?EN]cHHHS4OCRXAL]1^4U<CNqU;j=7Igof?3b1Ti@oVMG`:n:8HgeEm
N]RVqO?a3S`F0C1SQCjTVeg8SaHCW]oYXjG`Jq4LMbQo2IdnUXN<[PgUIi23VU5o
LaOlqU;Zd?D@Ze:G_^MFjJ1\I[@;PL3A57;=Aq31XAMBaW9O=YRi5m<CP7me=^o=
IF:Z9\pMSCS0QTCG@KGi`<`f3HK2Ne9bZGc3`GT6=OW^aPem6<Y]Eiq@5e>HodAh
[m<gkBZXfJ;SkJ[6RjXA]Y08k:e1DgO=EjCXbSncLh`FVU\pdf5;^A_i184ZPb4e
=2_EbjAR[k`q`J@;G8BC[caT7PdhJ2ObZ[K^pXc0PjMJnGOe01EVS:9AjURFM0XW
EM[7qnlLGOLSl<:]<FfASUic]FJB6bS1VU@me_L7VU08Xe_P9cKBNKbHAp2nENHo
]dNUT3IHYaA??hZMN12gj]8^VN9cJJ\8c:>\5qUi7=Nik=g?<;obBNX@gP3Dj=94
A9E53QZ7<W>I;c202`fkqc23CZELKK0bO`i;<Pek]QQ4gBjW<WAU@Oc:PW[i;ECk
1gmJgpGTI_COcVn<Ih1ng?[8heaEfcajh4Q37<ijjckIQ0DJ^@G>29MORGp\EmLX
1QATFh7YGaG[ZBZlcPHm^BmqSC=A@iKn^8fYce2NA_k5Y<HVNE29pc49e>5Cj4ll
3]:1I6m^jEE:3FW[1]8;Uki5qH?[Nj48HEi?963hbkL[XiQ2C3lNnJ^B2p<ncX^3
h1ZlW7<TDS9?1GD3hmm6O20<5aq14;1ITDP]I`E=^Ug6@2UljB5oT;eA@IJp8jW@
3M\Z4>WG8U1Y;IgOfd8Dj\Lo6>a<dlqh77<o;aob0;Lg1DOaYYSa@]oUgjX46<3F
H;aqHLD[4bHi_=9AkE>8SDOQjmg<]R?T20ZN`=1np`0kU@3[J3EfR?_F4NZ_[ZTK
5VUF9PDpY:MLV:81A[lEdLF8A3Hn?gC@ga_FQCYhVNfFU\XqQ>4AYdDB2h_\nA8`
TFVfc1T<5gM`o;@I`m\6p0>GmJ<:7YUOSoJDJAg98fDC`1OAOQTeUiR15GRaRnT:
F^F@>\?piD9N<SOi:g5]NeBZl^CGI^2lJ6R1gTUQ>Y>na;b[Fa`PPPJ0lYZ7Y3pS
2SPeD`Yf8`T^Cbb81;=SAK@TgFRA;AcAeaG6H@@k3A[l64Sk8LhAa;qR?ON7kF?8
`Pn^i]k3eToU:YLYTm2:`@?hh:JA\Pl2]4q=5^6lSW[ac>[2f9_D165[R289>FCd
f39S;Zdg16SIlH_4n78p=`X`iLiD4D>]Jjj1]2kfSZNHa>=Lp_DPW>A8U^5`g64]
hQEMFB3Z<?WgDo]o;j_9I244;pSPP_d`jak_UKGCfFa:9VXE32SOGhcjYNM_8=YU
db^KS\_4?8KJp`oWIVeODT6h:dDMUbbkiH6f6AAj6Ri2f\kT[CoBCf6D8Wd^[3gg
apVX<9Q8K\79E=@2TAT[_Ri;k=a`mO5WW`0?X0<4P:[1G@bRIfpha]K7ZP_LPT3d
V4XZ]fTM9^N4JMh5?S7ig4;N_`O:3g5I5a_E_8iJXpc_^mJi0P6eK3n8Ab^aD=nN
?\:ecT7fakVb?XleDHa?BiEPmap;84kN6M94HeW39j5l]RASLL1H@@[1kNSmcH]9
0Oq9gO5@c3XbIBLZ3lUd=>TJK@c=H]WOk`lF<MiCALGIDqhM35FB<PbUhR?3<nZg
8SPJBU8cdW00F0Vd48dOf]<_EpYZ?a=Uf9jdbgJF[2@KleF@mAIRjFgF@e@TN<m7
FBWR5MGIoI1Afp9^DKhglYYYgSUJ5oSaO7:DZVMdUQ<Z9B<9`?lL=blCe?D1?q=M
`BS`9oh52k1li7OB@15^b5MTd[f93i2Z0TWX^hHnR1EJYUMbAi5jp??C06fKKNgO
Mgd=6R4>EmcMZmN43A>]:ood6G^BY_TJZ?ZnIe5jMIB;C@KVpoF]HB4Sf`=9XUB:
WaH:i?<@`38`J[>liHDNJi`PB`Fj?6;_gCGWA;TqhRZU;QJK`48Bf@BYcO0lj_12
;>4aW=I2Q5F7JmhmFRY_:go]_bCqkPMjFb0PK:7kXeRCLUoY06N4G2;Qa=Sc^]1H
P9p=d08aeTlL@TNS_2dK\U_J[cgf[]^\A@CfN<YMoHq;aSFeonGe1cR>AX0\XhW2
75GVm^Jc[3[Li4[JXXZVU5U_S4Ii`SWqD>01e0_0egcb4^e:Sg0PUn`T@8<DJ[SD
mUQeD[RQpX2ohZP<JZ?Cba7NV>;AOD3joJln2iIOljnFK>lqX=iPYTl<6UFcg`A1
OhbQ>ba``G2P7\o68ajQ06q1HQKUi;@ECOGTH:5[Od__A8a7e@E1NFWRWcQ7:hqB
l<O;?a\iSF3fO<:ibJ^o2:bNl8@O]eb_oGC[e212igb:Wd0hPpmfWTN8Th@U8F?G
Fcl<3jJ`S<ZchCTG903l>99]5JQb@?3UkQ=bp@D>5VgT3:G;HOUmmlYi1NKWNNZ2
Z46ZY7\92g\gQn^Vd<o0Z?BPGq5ha^[4I0cDl:kWXRCEfE8^ZdS\<0ld1iYHYcdT
O4bIJo]Xq?=Ig5a5Q>lBN5C5:\MB?F<8bG6Da\FfheG1Z_P[Q;N>IVopgVl@o=l?
o<MPV6F6b[<\9hf^8hF9??bM[5LZ2JRe@PYp>E7oBM]VYhP]0D:4=3Q>\8Of?8[?
KG=c\H:41_g@P4QN_fYCaBAM:4ALi;hQIGZpXica=64@RJVX^mQJeeRK0`7:4l5Q
_2YUVG:SVe53Z=1p[D]l9<9nXVeQ37FQaE906X_Mo3_]16iCm8@WiEfI^f:lqI6a
2oiL^I3i;]Wo@a7O2@hYiRadEd`dD>b8:2fZip0AY0PmL:AcV:RI9QK5?9cFUYM7
?WJMHq:EIZ`:mMVkWl;0j9K:4d\ICR5^joTaZg@k>do=>ap:^Db^ef@gb;X=DG[L
@J6]PjGXWek66@baRF=G::JohqDS26ZfcFeLBZ^kGRT:f>G0gP]=04CImEUVIc7H
?8JBqX8B4Gn`<W8gfhKPYK[8]DQ1qe]N771SjQe4Hei4UMeSHXKqk_TdA8a15f9`
a@=5\=IeE6gqH@f2Q7AcF8:4h3OBf_CLgUAOOUa8BA_6FLQf9g1pKf_^_U6YG>K9
BWV2Ze`jgQk][AXSFNNkH5C\EnI50dGa\]_hoZD?D6`UEEPpBdfX25V]Yen4lQXD
UdkGX6P<O5>Y>13;7e@TpMTNlUomWJ0eOWGDo8=6WM5ma1V<pDHkjIfg`7Cjdkl5
V=k11B_6;>XqUjmE9IF8cD>OZ>V2mUNnAGeLZ[@qhZDGaEPD4FSJOUEP9ZO<Y<BW
=HGT@TN\Kj]]IN>:_4ApTkY6o00oR:[UjE9L8nSd`LYPPT1Ec:7C\MI:Wf=iqVlI
E6fcNXP=faK905o4h8HV?O4LYR07oalBKPj^h>GmWW^Epon:?l^::G`16ER7ZX[U
2\M0aCfbdOcl39YSc=Q?kBU0=SVFRDX>dXc8\`1FleA8j<hW>D8^CAVIg;3l7<2d
GfBR6FaqaMkom]g]:ZdM3i36a7edWO?6RVfT`hLYKj^nJi;PIeMWdUYAkn7HF0mq
@;^@eOPKbfZdBhi`lnSUBPD^JWJ9e_fl1Jpo[Z@3Gh4L5VAhJddTVk75QCDaPb0C
nUi4:>^S6i@mO\EFLN`;hqKYKR\]O]]6VFfA1:UgEijX7WiPgPX2Koj;FG3ancc3
if4kV2DWpES;jloIZb^LOXRYDCm4i5jKSX0RFUMO2RLLdkJ2nZ23;j>niiaq_1ie
J2cHBE42[eJKDM4]LDRJe`bfeoK1pnXlUI[[fj63ZQK`ib];oBQ;ZaWP2o0`bG0Y
7Zo`V9E964i`[H@@8XIl\ZhRqKkig[eHZ9SR=?5cHVCAQFCNHF9S8FbmT@hgKXSf
j;]1NHAEOZYIGpK@H>L[5W`R?Wb1e7:h>]a:L?hEg;dOHih5o_lSJpQ^1@B099_4
Il47P5JPa7:OF696Jg>G6_8QbV:h[h9:al?j1fggBfT@qYbaaTePF`j<Wcmhf8MG
[kDGXem\]^bo2ck1eg:`j<bWCk:Eh0bO@CEVq8h<d:EBE:9J3b_3H4>=9d<0]=;]
Bo]IgV>=MV^\fYLn^JYQ7dgR0d<nqD7gl_DZdFJU[Oo0MbKIJIi_SDPglU;Zbf3O
eLBo020YiPB1fQG=BQO8qcRX340\m6;UN;bXe8E\90Gg\@[Z\^XGfp1ZlW0JElVH
:2;0_`h<`<AM[;8RYEeIJPhS?B?JEhc:[?ohe=d0L=pVR0ohiLZTVNY29>T[0]b]
ol^@CPPH^i0C;=9^O\q9Y4bk^4Zh309ka[<E=JhNh;]_lhR0ZX7bBP0aLa<C5W@K
cDU8edU5Cqj=TFF1AQI3HM8ogAMjT^^kYDZnGUadCM=_nI\?<PEEJGf0U\PeSQ7^
9pXh4LOoK3^;k[PB1PoiCe588?L1MP3E8<LO7b8]J95gLg1LZjOWojj[pm<6dkM@
3K5;8Og2Qn72WaQRLN8U_eJ6]N:BDbDQ@dd7DYe40j;`OIlp>FWPM^LiPC`[[EgL
0m2AW;\dbBGo\0LgL=6HWXpc@FoWNMPSHaSbN^`SKLOYSh[<f8oi6qbiA37S^Fok
WNCb6d_7MZ[:NYa_9^Ci@=LomPHO[7>]E4_2_V`OnpO:YGHnbbOV:AUS5mgLTgk2
GY7BV8=PfEYCfS1E_hg?1Rhh;gfSphoX]DBbO00bLVNhm5WTn6ocm>;;kPm=[c03
mda[?P\6C5a2;QNqLPkd9F\kO@03:X8Qh3I0SQRO]6p_V_=O>05Rhbi=@0dWkHbE
D7L4N6I2VJ8TmWTD1AW61c4B\O7^]Hp7?BKW=81ROhiOPfD\;37^93E=9:_;\F80
8BidmVcIFX7IYB6K7q^c?jdViO^<]<7?1GeX<8K>H[AF@VIbLh^F6IklkS3B@MTL
V5pd7_[GZ^65^j^eI[1f>l3Ng4kd6`UZ8JZ1R`j16E34D[?imCNR?E=do\aJT7Ql
UqW7laE;CLW^hUA`G9H>SXZ4l=<1dRIi?jDR[2L?@S88a]BYLpoY`YOL1AG1PI`B
bAH6^?cAMnVl?e]\56C;TfFJXU?FSDW<V98Dqeof;YNCVoJZNj62@9>18P6aZ;E9
30==Xc8^_k5>5iSIdXl>nZk\QlYp:9Q5@WkC7D38LR@PS:9<dlfJTNilHP]<0iP:
D8SWi:^l:Fo9:EmpM_dF1iAP>ZgVQXR^cKIEUB^WWG5ROOcW`Y=d7aZUj3K2^\:G
4YjGN\`qJ`_:?0EP2`@`S:i<nROOYhWVCU<<jim2OYOf5bfScgY?fbq^W>?;^clL
cH9T>f^GCB:_8i3l;AILHoKPGiJOm1Tm`8el]0jQi5[hnp^BbIQfoe@Ko5PLjJbA
Lol9maTf0JC9=7758=^Q[dMZ1T`m`LLl<op8gC`K=U9BXCchb^cJGRin24i3M8_W
e05^g`1>hoQR[cXF8a@9X[4WE]G2`eJT9eb[2pZOO2FR<6??8BU>_7mcC04T:q_<
Xa4EFm9LMUV?liY7<Ldc`>@NmUGQ<79W]RZDCpD0T56J4UL<IO7cSb1fK]eGB;E:
VXk3K:TI\YB^pDBlm42jec]Gak2F]ae_I`8`Ck]3;O\WI`XJ[@m:NEEk<=aNLgQc
k3aW5nOpBFJ;CAVTDm:VBNZb5Fkboa14m9p5\3fIXNH^[6VaKH_\>9jMaI4Gf[:;
:9Dp_LDnho6C[jb<e2_3;Xd6<Gelm=^^oBeTLI7IKMCQ`lqX6X1B?GYn]DZ2X395
65]9m5KWjP\El2D^F:gM=]qmbFH<EQ\3]V2oibf3GC?ogKQlGi]]^VLGVmLOnhFa
i[p77@d`7he;A[;RYTAIe0Ki;?7;MQ\6ee;pi@:AlnZU:n39U5A@Z@SBZBF[X3Pk
>_i>LnYd6SqXJGj5>R]1:CQ_dQcW`aff6nX[T:o0S^CkcaLC^cfNnp7]?O_=imWD
;h1`QeC0bN@\CiU6OZ]W3Eh2Jf<SdbpLcb8dCRTPBlgh[m4[ckmaQNRL;Cl3;o2n
S;:8;CXBLFL>ZQZ8Ap5cYKWE6VeDa<UU>2Zig;Gc6pmV[oGnmh3JF<KC9>FAYd0@
q^dN1=ERmi`>1OJAa?L2oOX=q7VBDJC<16P_A9^gYU2_MoXeYQ8UqEfgBJgmOF\7
JCjd@PXAg24<QWPqQJc\lSGXNZ;@<FYg8_?[QC:Z>TnqPeLF_GMI?ojbVEo0AeE_
`9ZqinH6<hcbP;S9XZ5?_@aWT`q2ETCUIUGRTLGIbDZAGS3Y_\FQdb06<m=B@YnT
T:60FAU7<q51n0[?S9F=:SNj3ad?PEb]lqdb>P607`I4=3oP<f?3Th<F7U^9kc84
oN3mm^d\UqF]ol0D_@W_lh4B1<[m>DTeFDMSdY=l?XF1q@N^<;kkbI`Za=3Yb=HA
:AD\aYfX`Y=]4ICIdPj]nBPG34;j9LL0pC]KMLD0=]Q1CQHjRgOSQbN]Y3\dIbCO
mO2\<niZnbKFB3<n>B=UY:e0BTel8Wl;nJSXaIo9`IZ;Jb3kkW=q^9]K34Nl55Yn
0]\]<\aUD4DN?hqHbF^4ee:9ZfQgM6XiGi<j8^:@CDD2lijAJ=kSdMg>kp1D9^bG
3hGE>FUNZ3b8e@m>GY3XI]T=AKmS_BaCFH=oQ]^lApF[P7MTifKL8[ZIKSoIL9bE
B:V:l8_h0CWl5m>7knahN[iPjX0JgS_aHdKTTh=8;Nnh:>G5DR59E1CkUf_9nQqj
@8WQG\==DelV2R^LdW8WRhE[2=`[j5>diBo:XpZk<9CE^_>`2Y4c`dk1>PM8`^qm
G_;iohm<gYnSkU6>QJ8HDhqoSN;?6DeR0ajLKQdjlEOJIl3lG03LLRbZN1XlNTZG
Q]1i5L_Jabe5KEodeMm^Q2p4F<BHiIaU0<cL]N[addZM<k\qE0HXUgoUWYQggd9A
UaHgUIGJ5\C_ccOI^Of_q:bW[?n8=bBPC7ekJ5:XTh^bl?LFBH]@N9OLNo65Hq[B
jhRRdcKU<K?H5=`3WEF]71qQ]dM;6XgDoV0\a;bQT3W1XHog^cmM0OBhTI=G:h[7
Wd6:?l]KfZm8gpO7RK;ASLnoJA6H5iED=NCH=p>hf=;PQIPH[OP@;HeTFNY_;[pc
okSBKC;_j6EAS]WGJYW]YMnifXeb`WTY[<ii9KnO7Pq1LIYZJo_Bg6OkRo`BE@6=
Q?;Igi]G6eKc?2Q2^qdLH1?D3M8m6`[j]e@ni`8mY?14ljdIIWheemP07_`[A^]6
]BYFafPLTE\@3aF1RYo8c>?SbS[3aLL?i9O?[4]Pp1SPaa><FFUO?`U:M44J[BeY
IhI@R2`qD8dQGKlOeKj8aa\3Io[KLAFf[@_TW]7?3=XKdOcGnaTJcCqe]]H[?MWf
OA6_cC_hClEIj[JlHLne0lZeR?_^@n`3mA4J:n@Ghmq0?o>GT1oa7HYJP;VU7Voh
i_2T:IO3b;L[=E2@UglBOP1meAdm:P3VaLC>IUnlfVT]B84\<F]=bfPWRO1XZ1lP
6Gjp1hKjYUZQ6NUY>M[FYn6\BLaMUEe?lg[1_J^L>3?cdS04\\=<>W\;?K?bS>QW
h[^6aU^h\o[5pCYXPLJQ51Wd@d0>l7K<oZYO`OX4Hqc<<PlSLM1;l9eZo0Fjlj5:
fbGZHpgLaS8IkM>7=mSNFG0JRVfDlha5UQpj]m;Y1:XlhoQCj<GZS5XRFK:m98;a
h>1@D^nKOnVXPZ4qH=FTkOBoMM`0SNJ:na1ZDF>2PcP?pO^i`C1JmOY8kXE>]G6k
@5]2Xh7e3S_eJDlkf`5Z6nl9gc36^:`3VA^;IW@Pg\^l=p05>_PNje:oO[\J?M=H
1nVZ[PPo@p]\I6GQ[cK4iU^`_;bgAY2d91P8?WpB_lDVjLaj]inRVTG9]6nq]Pcf
mFbS\14a4Ao4>`Ql9lTNjLe5``>[pU:S>]VC231Q;dL3?1m]d6gRSWbe:AK>DpMS
JgDi49kbMMinBf\Znh18G8p\l@cm:E=`2TdRVJ_SEnh6[:DI\m3kVJVHii:RgYP]
;Kk0o3oUe2A<^`ghhI@ZPmS:E4=IaqondRI3oge\O<UoNmB>mo;GWbFnqcN;DU1f
?OQVQEKL[<`Zf94;b2MlpY5jf<A?CXJU9o3\7VbC92aEoX97d]7PQW<UN=oaZ3Ln
=7EV;nR2OVhIaLINLS^GK706Ok_WQ><BdZ5XeYG?pnVgWQC;\L;9l1Wa4;[KD@=e
`6PJ`0\?[=\1pd]<Xj4E99^`HUO3dBGXT6CRTS:ZM[Y^TM4ddBaq0=e@FT]WWDiB
@dCnRAlXbZMGX7>JKS[P8^9c@<H8ZVf5Ak_Y^a]62T7QCgIJNMLeJ:\_hB:0MMIk
^^Q4:\=eAOfPKFEBW:@@AEp4^50B2Hm=\`TLGm_gA;h<Qi]b4P^X?Li?R;65d?g^
jTdP8m[6DR<TggIjKkmMW]4n0gY4VdBQ5b5Tmi5:VKV1_1YTd]JDhAqi\Bmd[MCi
dM5`nMdan@OmX`675jQKI9fEYeVi]>LOhQd1`=VHF3[@oBPMaoOXT7M<m:QK`nSl
e`of96WT4JJl1g47B1f;WYMg:m=9g@pm?E[hQ37<K`Co39G1M8X3W9Pl;>]nm]?b
h4:OI5eV6qLjfVfb_<TT8]13KoHO<]SIAD;dh4i0[CgoOmoKZJLTgbWnNP28Rj@b
<oO`Gm12LkdJ<b<CQ0fPkM@OP9ig=L6K6ILSPhjVBd[1c9eaJ8fG<TJ<oq:\QI^?
Se4[^hA>5LXMQ>1k2a_`Aen:>U7d4C7?3h5eK6Uhm`O<CL^GeD<e]ea\0Q:1LIQf
T@CIdi^TUo;ni@8;WDWeamAFdoQAS`_J02=k1Z@?V[\<:[a`9pTF7j8U^b\aE6h=
ThjHBZPf<i5l0W:XOeDTUPe>cKjmQHoNAA]KUh4N0IqDF1YLjMI>0dcmZhh\E^ho
MXXC1KIUI=X4LkAGB62=4aj@FL@A?B8C?<hLfiPp`4HllMXmg1\\T40i748?jn80
U_B8a2ZBViVTO5Wj;]7XqUeEi4F5?CgbNY?^bB<E0ARiOB2Gl@fCD<KT8q=D9n1X
WA29c:24ZO<k1M65WciCfcS`C_6V:[^`dV`kn8WLHO1bIq7f[e2@NB;XB[F9GDRc
dFE1K?:l<0BMLgND1]gQ[kpI`;KFMMI\II0`N5d5:Rgdj8X=GR[gM0f<KHW>=JZ5
k:?YMYUm4UiaNOi2BgUia3q7n\hd14hm[?hSB0fLnlMMciL7H79BJ4Qd]U0Mle]^
\@n1Q1^>OS9;J4qK0lV<E][0Bk4HOLC]RU06UPel>695IVc`a2<EaMiA4Fci@XFp
3SNM`@U`n\X`YF_48jHOYEh<BREPTOpG;fL@PFOco<@i9\97fmNk703ZhPhakQqg
C?d^3:VPn^[3>b?XRK8gA6FACOgQR;:ga:^ZiTJpk5C3=F0`3U2cIoARO8FajYX]
H9_XK@J;km_J<CpXM6lOVf5UJ]3]@ZEIM2N:hTD<eYheW>9k]^?Gb8UWJQRKf5l0
JhoXaITL3BlpoAg5Lckf4eHSodYTK<Bd<c8^HY:OLMcIcHK[91TWqD;W@SAASe5K
Oo1I2o0I6GgbS6f_GCQ71<J;I5=Z\@Y2pGh<@Vb2HJCmV@_PABO2DQd>\Z[5iq6G
nOndJK07PLDR7aoDVo770>MXqYKcMYR@@\hh4G9X\RRI[Z6mS?0XP1kR`_FGZCZS
1q91;XT^ClUAJCnG4<HKE2<M;Q=UMP;Q[ol6accZ8=\g0qeVc0\V=SN@2`feO?P=
>NEdPn64ICOXqVQNaXPZQlBRQHT7YWRGf0CDeeopJgIo?hh2DkB^<37BYUI5En=I
0VmaG^qmL5kKjW5I7l5?0i;[U5AWH^ko3QKT;HJ8mTHJkO0aZ=7Jn_Cqj@W97Vk2
X5On6;d6GoQCLN[[fC`>;URG>_UY14:XHCic_a4nV9UBCTFQ=J5^3D5feDN`3OlO
hV50LiJK2F?\]WK^9GMicDYc5;T_LZb\?a\=:C>bSjZpXfc_DVQB0:FAhGRFQZid
G^n`TGXGW3LaG@?@3Xpcn]WCTAnXIbMWff2VDF0m_0>XPY1ISbi3CNg3GNYDZ<qm
_GYP_D`0eA9lNoJ;;OEil23ZD5=AU?EX0gf@IgCf:pfSlTFCA_CjdTaW0o>S5VAZ
CS4_K@JX<^GZAnhXoYc[ap\kOoD]VKg]EMi<mL9YnMfD?9oN9Hi>jCeGO?P:B=e8
i?eKI\p3iZ^\3;A4e:IJYgQnZc\RRk0UQPF^:8ZT8P1aSD2fZ>li>j7pX?5T=Tme
dffeVmj2AHHFd39eW9cWXH_aWei;lCqHmE_:<8KLEe0n5BX8IfSlR8QGJePf36D9
iL>jPHT]cQqjK3RJKiV096Bdh?Ieo<ndKoc4TD:lR3eGN7U=F@=lK3h^6Rg\E5Ud
gO[S:laNLckagBp>3UKFGhhk;C3dgZC1c\:_]3PV_9fWVJB@HocHda304P19Me32
2<V7?L59<fXc5[7k46c=<qi9Joo;XRT>8W2E`G6WTUMafP@Jdjg4aSWfe:Hn^K@2
L<`5Xo[a:6]P3j]f9Q20p^<IaVFTGo^6PNCilWZoeVMX3EF0_PmO5X8Sg8[`@6mS
VUi3OLANgc>BHEk9<]Kp8aliGJoo;]g<T[c]cGNY^3j9k;G;AF5V1g14_g>:I[BQ
2QGFQ^Xfd8aZgRVE6<p;N<:4DW<d?MAV7I@gOkLTM@h<b3<PGWn6eja1Gij0NhhX
5@lGOZ@f^7oeY^dXAUNM^ac4Ll[@OXqlfh8>I=l4YhSN`Fi695ik?d9G[01K8LCe
SD7m4j@^gi8OW<13S4_h84MDIbC1<_[nRo8W^qbW1mRNnGY2iR<m3WEH5=?kfC4d
V^MZW5l@^QLMH^LHYai:Rd\>[Jb1mjpUS<H>U9Pbio6D7G4Jg7>C<=@\d@9QhdiV
IL32Ie?bXDYT4ZKkB;eiGnT[OmH524K?[m1@8q3G8N2WAAl5NWj?eSc7pW8HW6>K
BDAOlK^gZbM<5><>31FC59]Q3dbhbic:6<AMc63:XSK[^T\jXqmh?CMZPU[GSYSK
^Td\oi?CBoYo^oU2UiF40IOW[`=d_[<mV?l5iTQ9ZFXaTpAn6LEZ[4WBUb?PijE^
JZ2[CQoQX3<L_I6nC[CQ<joTCNO31^Vab=7KLe:Q7K65D98^XWN57Pp2iOafVPVN
?M0Dn`DXk;0QBUXeFXKN4:eC=P;b?^W:1ETPLe9:63gh2pYn1cUiX[;TEYWHTL5L
I84aUTTHTdNW\;\?WN6EEfCXMgkS2I@OEMi?3iVb6VN]\0<I[2Vk1=_kY7KkhI2M
Up>ML8R<bgX4AB[ZCjnGDc`\VDM9aZcO]DBfgQQ;JoKc1N1\CIS`dUfZ[9P>Ra;:
C;U5_jo<\?kMiYWlnPqK;6WCJCbUKfg1Aod<`QZNNilBM>UHYCEZ6JDNjOBLdfli
4jMX@3XR<2DhiCEX`F]in<GCd0b\\Kh6dcE[Si<LS1oq@Zfj[LP8><]@R;IY9[]4
P;PWb\Dh3def2DR]dDjC2DON?5YfEYkABW?[ejUoFBQnEQ2D]`a=ilanPZNghS9Y
:`BJbh:LN`]aqG\dBPYX7<DNkM3JSl4EYNYOc^L<[BReYld_472316kQf?0@kL^T
cW=8_Il8F^]NVEcG:oKkUbfoZ83Jo:G69oI>K05:ZZ\@0S5QBBca5p]EOJgfa9K@
j2?Jh7\[`BXo_OmdL<1TdDY@al;4cQ9DSD=\D0mh<jH_e7=796XaBJ@BbZ6g2WX3
GiUV\LTD7f@^J\CVjeeKDQb[jJ3`UiHMVq[j9IljSJY_7giXno5MfFD>>d]A5b>L
0Doi^4o>hD?O47PFBEOTCD0FZDIALR7<<_gFE_\jBPl8eWkYFg[6EcJ>]J0ki\be
PP8mhX0J:R=_bGfgN1;<Jq3H^hi>hK9BEfJ2U?eQWm4hOkV28od@G4=GIP<T0GGT
6`^dk;AD4AlAqF7:XD1A<joo1J@JM5TPc5cb5VP3=a@G4i[JJjlT:>I=pmWfXU`S
BDB5ohHLejoFbjW2Z?XkN\Wfj0Wmh9@Vl7PkLZN8G8DTKK>WSKMiOaG]qZD2jH[]
;N>Ng<F3Ug5DCngV0k37i4m;4SCG=SKZkAkfnmRY2I`Y6X?qFjH^DAJmZhfR6n76
37AQQM`80C:LZoDkZhF35h[bPH3p3noTD8FcQ0H73c9C>Ao1Gd0^<mT^;nBQ0[<`
Ti^DLGe9A<Ti1GOQRjpVKoH^c03>l:`?1:CS1Fbagb7;Yliei9@<[^_4@?1gd64o
c_FhS@WGBF[aXSp5]UC2ST<D3fQf_SQFP@b`>\i<P^SG>coGk_?K9651`Z_\gfHF
KCSPG?TL><JSC]nV1?im8q@5cFfbUlE:M0<:nM`c:7Q_Q9KAj]9Uobgnd6_YT^29
B\O7^O9jTS>Mh@PfU^[U@3imk949pD8GFVb2:mFF0>ae>LIQfFS7RfEkE\Qm=4Qd
Q`@6Uj5kjHBhQ2O@:UQEY^n6R?Cp8LNKach;Lg5g<HiTLS]8OBOleB^lL\PEd:`U
O0@aF;G\cQ17UF2`EnZIC`EkK4R`;HUooRCfpBT@YCUVM?U5M2:90XReYiR>R[kO
2NFRkM<K0`G4T_M>6mU^`MbZQOV8ec[i4>BZW_EI<iooEpeh786l4BkfVG^EL?:X
Pa?dinDPC7mNc[QWPJRfQR20oSe5JQML@`Bgmb2<LRWGImMQc4DkLAqkU^7?nh?@
Si:kfEjYMXUmPT_7Ym\n_;YZZ@;gY^<BiIpCERNi^=^KkRLi^XDBGT__24^m7H63
iYgMN9kich8?Md8j9?oeI?[EbqJKcW`Mf]Clo?8Z6D;9H17bf]03IQ>UXIL71<d8
=V]Nh:UgaPS7eOa0qD?Ymf`STHPX4b8WZPkBb6F[:Z7fk>;U@eNj\12mUUSfq8:R
Hb]HFn9lZ<XV\UFHejTeP=55Y8ZRM>Md1^SMQ]Ed:C<Jle4MIFjq:lB\5P6MRh3e
3kB1Q>mBbEWAQ0hU2`SeG8ALG<Fg;cO8Nl`WZ_J:jH_jId6mkU18q27JaP;RD1_\
H\XfML\9W[YIF=Q7X@S1UCAeiK46hUUmJn1`HobRRElqhcl``A43nHb<f=D[oPYL
5dlm=3Tha01eSW_`bg\\NknG58qX]]^=ZOfmaF1Y3CY7G4i<aehN@MIM5L?l^09=
i]P4`hlh9plg1cQ5JP^l=0dEnkfWbF<E8Yhe>]A7cU0:]R5F]PKe6ni6i5DVc]j?
TC?lC3_Gq36H:d6MPWlNj6L6XUc7iK2_eVEm;>f_jl?VeogSK6KB33iF`KY@ehi_
lbdYlc1q;>3<OWKAM\g4fk>E?ae6oBoe:QC\Uo9U0mJEdDE5Jm>TaapAKL_iS8[E
6POWR[6EoZSYf<]E]fol<41TPY6CPQOQH5mP@qeAY<UHDg6FUF7C4C@:a:Ia9A<^
XJH_3<7LaK35j>EB6j0aqk7ZLETRG?Q0AP39a3fR>kT4k0WpJL_<>U>T;?HHL2RC
SYnVm@PWA?3MN^3:`;_4P1ZRZK^9ofQL`6e_VhcWSa^piCgmcVo>k`oegWDO5U56
1lXlDn3_<BKk@a88SWcDD1WNR0>264Z65?l^qnmW1KN0n=D5Z8Md=18JK3]\AQ]c
_G3dcke6A\5Lc;]CZ;^YMPY]7[hEBE3@:o1eQB;2\3Hq8mnNfDQ?HV;6cA[XQD7S
>5bnNmln>aYSdo\Ml1f2YDNmfN3B6TFc;?AW>@`HZl8n>EobT7ph<CDG5868YRmd
eEDNHRHMM^]`8]RYHLGV`Q1H7TmS^gaKUqhYIEF`UESKlNI:=qB>D;Lh0fm8ogg]
gGf>MNEGcPOE6\j<jf[ol0nFgP4iMAMn`FP_SKZ5C9aD3dIkqc0[A9a392Q4XI5Z
l?E[1^FB<XXE[Smb70Ge=n`J2`WTVGU0[BkYoPBT5h<^phke_HicV9^74GZRlVNY
7keX@7ebc9774?G>nMdhOVF:QDXm<VgLJi>WDm?1lXB<WO3W2:6p4@`D?Ma`DjJS
FQ>8X168GdILBDXA20mT6N@cE=iL?JRReKX543G2j86<K=??U6^FdhnNMBpJ`Z6R
8=ePNNXBCCUhN]6\KVHOT]^OIAkT2?bM;WCp0C7o`N]K@0o_eSHH\gfkl^AH^>N_
kO92a3mE<3f6[Qln^InF2K]mdDp8=R;LU;3P?jYXTg:L<3PG1NVDhe:g93b?Q9R>
D6LY1lp1IKe@MSXIMS_m<3Mo1ZJVdIm<RabIQW858lD5I?IoK9TeL_P7[9b^VK1q
W:kVH0?4b1^Be1;M<kbBOlFiRHI<ATV8XU`EGBW765F23<l?MG;=Ub@=IFCAVmqg
dT6Ud[0RfhK`dmZa8XDFnS=`0EIOgN2EckCQU;90g>U1`Z>[im`GX\:YC;R:H9Hk
_npe6lMDiC7\<FOFokYdZ>COb?d]gi_^kSB^TVV;k^J3U5hT0`;J;gY\kepU>RTY
HmeE>@C<l]_f9>J:F`Cch^7neR@l@9P=m9OfBZ58=q3AC7Q]kCiCOeRY@hiS;;T]
o6Rig>dTT3h4i^EXEQRB4H_iX[;dRpSV_1dKUb?DgE90aVT?M8D2RTYKCBXB21US
N^NW[[MJHQhUIXhn1T6Q08;L7Radp5@A?MZcC]CCSV;FOek_PR?`9?e^P[kk1Nkm
?Y>XiX5kGgS_UXbb?n<b_b97U:Np4JT^kT>l1IK3jI4PQni`\N:>JYhZV`=GXnN0
2UAEWi6J>GBhfbodU?[XCn1p\Yh8hb[HEXV3PDL?b?dNFDTp`cTm[Y7bb_e;1kjN
mSg9Kf>6XL5`;HIU^cLIioEePQd6NKTNdm0Qjep:`=9j]UiS;Gfd09I>AV>bg6:m
42JA<VH3g:AFDEg>^:Iob[Y7WY=dm=jFR?pCiSN_2PPOCdB9JhB^QfX8og[@_ZPm
i442dD`7J@:B@?Q7n;EEhXiC`f`^n[p7A0O\BG;ZW=Qe`dQ^LS9:`WVo\I^i^5JA
nf0bM9J?QoTHZm4B>VDeLY];4B02<q]H7h>?J?O7O^aRj1d;YgK<01U2;BlMLIOM
[^J6L=X_BQ>Qn8qO<D\5Od4>6GDH1CZc^HKE`:[Zg=:[;Jj]7^fc]`Dnahqd9lS2
JAbilkj[jA:B4l?m^\RkCHQ_dAHG0`:b]Yc;I@K8HV5AcM4E062q5coj7iNHFf7>
=o=i3f6Pf;Ck[FS9TF3Y>fYcL::R_6`2XB6]?N823KqeC[Td\b1ZAV6Kf>S`_O9>
6O4`U]bIPJN:[X2d41W96U1IS`YagWq7mJa0>FT<_R]j_liYJ72TVP`b[pX?Vi0d
?kjfFY_81c5dFP8Scl1c7FaFbTb2XRLI@gjec6U_3a:n3pgBVY;=P<EYS>?oKJJ@
[3f<O`RTnfcWH_inMS0fm<7Uo90icY8j[UQ5\m:bSfd7SHh6_:<@X0Cf9pRF14G=
L3<5;R6ll7KgdeNB0md\DJDaET=?WkGWpemiBIcmnb0BA_Gl5Tk^>24lC@ULHc8b
?:TV`c]WPdROeqZbk8fhD<;8=ol6\3XC4eI87SQo\m2an>lPG8ScAb6H]E6TR1UI
8Y;3Vp@eb\76304MhX7MFPYU\LREideFEJbDe^AKA:\EB`bj_cV5\069;G^fP0hn
6;<4Ue\mS>F[6pd>Gi?aaC_c9@<oE]A9n:m2nVPZZJA2leZ6CKi[=oaVHKfjdV<0
k=[WoTZTJH0RU@e>9o^kX0_cQCg:e8Gl?RDT_cMe1DV2TB6PMIZ@@WKbp21gY@W@
8IdSLjT7hPRkX=[_00>9lTcl2AaNW:Xpen3b?29ZCN_M0MWPdTHSH92MeecMdhkE
5>T]:JWj6S4qHa:MH@VWM_I_b:Tf]PaoPhR953_lh<jNMY]K4Z_XJb6S]ZieHKWB
>QX0q^5bYck^8S9HLg37PJcnc1P9Anb]5?PfS;=?eK4Pl_6Q07QZ?_`GSSf8J;Em
M7[YjX]ePm8pWCbk@WZd]aA<Z8YY37b^MKi^hYII;T8mUO0BHG:SCOjqVI`D6VSg
?AlPdF6;\WM_;EohCE<9Sdilj@ai9PebqJm[BJE<geD4dD;@F<dP;id5nKX9f@cF
?VS^5<C7OWeB833;ADQo1lapH467C2lVMe2g_3;Oi\Z?m\40W\V27E5V<gcO^QJN
QiH?obUgOeSL@k5L_1np>5SgVkMmX5FX<h=A^eC8^T@:27mlah^06Fi\3SaNglZN
ABZ_@Gk4=<_MI41^k:5JF<kQe_pMGfj\125V[ha1QHhibHH]2VGMKiE[iKH7O]i7
:Yd1InV9;joWkZ=>j29J>k8baUF?7MnRcqTm1Nn4YG5WASIE7RL[c60USl6XlT6Q
MK]1CR`S3=a9BO<fRV:WR;4o_o^aZ3e6p[58>bF^2WR6GkC?]lnNR0eYAnS9?1D1
5N8^8VL\>g2>6:[`h5LKmPNBLJglhi7NoYSR=h2KLqQ]\YN^nm1kaG\0G5h9Hh2l
LWo_j:=T^P>QL;ekj578Z[_`cSSDTo7a5STVik5Xd3c?SQC@d^qog_YGCGAYS[GP
bR:YUU@@;0[eXMU:VF8^6C`i\M_hl3q^>?gahY]Kg>4CNR7QdTbmJNO5KkbKZ6oF
ULn5WAD1UckegKdRSN^AGqCPhn?^Bg4^HOXKK?CA20<:?>7RCN@5LX:S5:TnW=UB
MRKT\<34Mj@GbJ2IMJ\lp=6E[SQmK@WG8CDP_8<Pn1jO?Po^edLk]=RUbbSG]CMb
pAO=naOgFY_^PH8jDOK58MUhnZ@Zg1]V>]maK`]ZO0CUBZD@nXQW;iDpRDk?nb2O
He\hanE:H2ge5hBlhiO79D3TY:h6^MnbeC5CXOAIRG<Yo_qJff@\V_hcVfFOnaUc
cf<3emV:Nd[ZeSLAMYm7[7i<cXqo]2?5Oc2g@]=3_U;2>j6K06U9I9XT4@TL3H3P
ZR@JOg^ZIQG^mUYq7RJ\kQj[;EfjS@F=KD@:6j?C^@@]1X>KH[@T?fII?VIJbdSl
UHFNC<q7]XB[RiaG_Qk3Z[85\k?E?HcYR^<6:3GC32gHj4=aD2j6cj?I2g2l2p1F
1kFQdC7\dE6M_KeVUa7?icNI8BKERTQee_I6L4Y5f@7np`PTZlDRU\CGVdFhV]LM
bLWOM9VAC:;KbCD<gffAj8;0SVPq6]:bh`D4dVNUj_Q^Z:<[<jF\00^lHOaeX67[
5HA\_>@R63X2iTF<D;GV@]2JM@pTj5<JJ\dR\Rn5M>0B@TbY[kcR8V[j1NP\`BB^
UVJin3VSo2[j@HEY>1ZY<U7E`qc<XKg[gQ5J^[C4\OM1KJl?SI44\9bZj>RWh7@c
=c78H13dpZFoeg8ZTc;3E=B0k`3>G9GQj?00]TS`[m^p20Ve>T35\cEOGkcGe7`5
Y9D3`E2FmJmf@2T]NX_0E2@58?qVbP;]k4CM6QAD5Xag7K[1O1n3aL=GkHOf\9GT
h;YVCmF`Qqh3R5L<ViSm60^[J`h?B\RVadVDZ3cNb?eP\R:`k>5A7E16EC:o:\O0
HcoGLpi20WRA^\0Q[_:VoVE?4cdI^h[c?XedR6jI9NBDWZD>[:PmNBhJa4B_`=Hd
8OCTBdTD^:gJ>pbTPlJBQ^4Y[bZ<ViAIl_Qi^W1U?J25kEFkW0B=n5H>XEMn?YVe
OATcS;pjdVKU4BK2mS^J8Og8Ocomb4E;hFoH6_?:kg1CM13SgD3KKU<f[AEXF282
?\bG?e_?HK2ElqikRJ7e;@l0QHTcUS^6_4=P?65Db[64c1Y^P]j\37DHbm;SPjlb
:JVJOf?P>YBh3IRh^U9XqcS>2NaVTFkm:14BGjR_``LN@;eG6;DCb?PIbMTDMB6V
OWO;6Q<MFolH<?I]pg3k?TFh9TYghVW2Qk6:;EKP<E4IF\ACcR2_[o<Nk85ZJ[n?
f`B]@h<l0baOqG0;QbDX7S48KjfIRB>`CTN:g_WBODc3BA`]nK4RMUOil<R>O^65
V19jNCL8G@Yqf3mk[gL`[=dTa8Z_kW;]lP;[cbKfXj]G45?\nEBaJKI75cng=jAn
=a?OTQQG7]1PF@=pMWHP@>2>AGC4DICcplge36ind[bMkdcl3dZONC\D?YPQ;EiL
A98WdVZWH>Of?KYkSA9mW;e6HHmYdWe?8ZAYp`iUhoLNA@K>W^Ql3=W3APJeQjFF
^XNAc09GkW`]I81k3HFRoD?oANlp8aQEE`jX6;cVR64hUNZ;:EoAc=MlYoRlgE96
L4B]L@g>QlfiN4gfo2d@N\Ri6;fNpf\7lN4c^?e11`K]29N3=A6gB_lRJC]Ua>O:
;=M:_XZL[aa1M5jZqMN`MGJjS43LSPFBO5h_<lj;fm:UDQi5VLT8AMYWQjYD8Kk0
L\1O6<KkX3YROE9f?n1a_?j3RD?Ab]L95p^T=S]:Fi9jIAJH5?0F;<6P<>jeE?mH
Uh=?Q0`GhadCF@Y\jd8aggaV8[ZRXi035:G0aBThDE5k0lPe1k@ZXpNffX[kIa4^
24DH?RB@7OiCUHf\oSn7jW2I8@_5DIFjOn[_iRZWn?JWVXoV;WgA1:UHFidZ38g_
3q?k7mSM0h3UB06>0XR5H<qmEhA]9EWT^1o\X9AaX1VnR?EoVif\;Y`HX64kn?L8
c3LmO6hSDXlO\LXmTI]>3bT5\;kYGSE`ljo]<pBZ2]>j?jZ@3FXGD?S]<BF79Pkd
kG:mhJEj=V=C7DDTH<`HpdTR:jWLTWiD3]2k_PhO9;\@A4[L0c9R>13]C`I2UqKb
5Vf23eOne<l>If[2bCeAHdBWEKc^k<b5O<DhYab:k<5UnqSHh9M=6USY7PVm944]
beTl;clbl49Jh7CXYZK>So9:Rq2@E@Vl6CFij0Z6QfF:ZLf@[=O2H0KV?:VLkgLB
?XeBbHH<gn:M]iDSAPp1lM0?I8LH3X\:[[cNDf:cL_gZJWV7:e[AW\:CNXnH1XD2
AmhbVoB@Fj^egXFG2q<:_;;\DUl=fm_9CleHRV?PZDn5A3QEXeRGXnFJ<ZhcJ`0a
@=fVN=Sb8^qDT?J2m^AGa_M5oOe14\\iJd8PD^cB_1nZ3>h@R<>efcQHiY4HXYLl
Qb?8=1Zbh`OJ;Wp6Jii2=T>iN9B22HhUC4PDAAOE:iKRLh9cSe8XleKKkjfEB21M
RF>1eD`[YRRkUEBB96??^?j:P3c6a72I@4]4Cg>FeELRYp8j3F3g?Z:7Xf[T1KkT
7^iAPiVB4KIXD^f=e3XFTMnZioRCLkXA6MN:IW7OgZ?<7?8>>ABj]G5kL[6BXfFJ
J0nb5M01Jq<QU4YRH5IKeibYHcR^m<kCNc2cLc<>WVF[:@ggafG4][;H7\5nP>FG
b__7kO[>Fe8_Kfhim5]XXhb6W2qOhLI49jiNUjL;QIFJdBIIR7A<NdS05kI?[?Kg
<LY<a3Nih<kBV^20l:Rj58h;GY\BX6_iV5]3RjeQG96nh65_Y2dJUaH3=V=6_>W:
7pYBOmnhHXfgil9TR7ZYaA6\e?bJ6e<SSdK>UVTeXLJ>K?@3fg_NmmqN^j5:TOd_
`j10da1i7bB0ae]Fbmb12a?_bgQ2G\3V@i^j>Z`16TId26JXB7cNiAZ^CZWaIqdA
<24Z2@8A5gCGaif<O`RTnfcWH_in:S1BAhMei0;hd4Z8ES_m_k8ikd>P:klMn3n1
Fb5:ji_[mKe<pA6bQ`a383Uce9W]Z5P>FZ9l9ZeKH1FRi?BH3WFkSKYQ`Zjd?R^Y
81h7EGi[[KhgW;Te;Wa19L8^R9KigO9ZJ6mp^E]9MTJhfOj>A51e64<c<=4J[C0k
ljYfe=HQlhR:52G7N4B583_klRncWXii<VU:liEeWblKMNdmS`nZ[OXAB>3m8T\7
eN=S_^6DFnq>QcKDeGj=:Go56c?VBW>i9bDe]W]N0@dCnaj\nA:0:d[_CNaDf<_H
o?4>?MmWQUQhWgSYFCQU::]Ln^NEE:B`NFU`;^lQLmSBX1q:KX`L9jgH83D32^bG
CXO06[[YEN]TNe6eFCg`^o:OZFK3n`c1ZPFFiP>J<H?Qf@fQA];j4L7Q8FdQ=33G
Dg3f`>84SlHEOd>plQhoMQo^2BW`AAkjmE2CH3KhM5AaPcBecl<AO1Hqc89URjW:
ZHbA_<Om`j`k\`l?94i_KiMn2c\GE4>meJO1M4SGM6XS`CjQWXHq?T_P=YKL]Z^O
4`5h1`gU5hNh^YUjaa50GhI\I:?2kmh>iI<<YUGSmHno:K4cMNN=jJ1BCgSHqd_J
ANXlPNA9MDi=h>b;X]V;UIFSG[M^]?WDj8\<Y^db1[C?MDk1[jo[VFRSM1nCIgG\
co6fEqIEMCA4b\\GdEfb3_c?HR\=<1[^QGRCMI`k9U94KCk7m63:\PWDVQZ:9F7d
Nl31]c609L3Jn0]IEqeVV8TM5VTnE\VTn]Y<eCjo]k5Vh26:7d<iRihLEaET4OX:
J6`_M7kIhh4?Ii=`9YDI@2F<Zgb\_mJhpSXcKXDJ1a;N1fQneClBSgFN[\3THKoh
V?S:nA:1mSF8?@1qo9LN<UaNfP;^V\VQ[O]nCG?2<DBPmnXNV\jL3NZSJfDg:1pc
e2oQoZ=DH16<@Z8h;@IHTgC80`k97QG=^P6c=b3a8;GcnPRUdbkW^p@W2c3c`X7i
:5H1eCRYhljGWakhZP6@LN\ccnl4oV:@_mNb8:Q5=^h0ijD7FqJVW`a`N;59U?E7
48cg<Qb_k5`@FbVZU_`<AMh15k@_Zem?NNU?bfESTc[I=XZLgV43d1^YpUY6E@DK
]<6=130SMQiLPbOK;E2ioO_K`3<b@39_F_=7ODOjB5_KUEo=F90NOSaekc;\7LGR
0i_lg[6p_Vb4UBH9[H9VlNaDO9n@6YiE]R>LGcU92@jB;:TKbC02]iWe`KFmX;_E
2eXGKgU;XaQn795BhCgqXhJ?^:N`M:LWh<Xe]`E8?;W:N:EmYYO=UjSP1_EbqW?a
B=7EMX?jKHhn;QH074Tg1;eej@mjCYYQ9@PqG34W[2nFo[?@4F_^hQ]\9@=qk5h9
^F:H>:RidXYO\ljPG19dX9onf40Z_DjMDWA7`4q61f2ciVc1VYU1ZE22V0U3UGVm
S^;C5^7fL^7?@fGEa6iUKGENEG2_X<eoW@0i>9RnDpnLC]F6A0=Nf=W52H;BoFlf
JNL`B`0\0_PI;@W>gOZg=9:RE5N7AZgMHI47^I5\ZU:gTH`SA8Z[Xii5\f?kPfBE
XIRckgqhoA4G;@GlQa:_ZM?9QDgC[I^?`8@<T83:HCE\EqWiOeG_6W>M0NI00g7C
@3FTiPnBmndB>8aoJfJ@=K@0oqm0Z1X\Q7`QP121VfTj4kPnT@oaoRfb5S>R[DX<
LXDULLd:1_]A9DG2:0q43HCjHRMk<X490h@F`iR5Ol3Ba6KVCK0JPFHKk?LaEnfH
J5:oa[eHe46qHCU?TL3XDLmHc;@igGa>4NkKI=\KbJIdf5dblS>80LJN4=`^C2IU
2a5Lm4g@A@qPO<ZQP7R40UQ^OiUfEG[X\oAQjoPahjG`^Dh804W\kTQTGTXk:ERa
knO]T5pG^RkQES2[HUDh=[AT8Bk=T>@VTA=nH7?U]PGDkaVRF6FFAA\]E[aLPc^Y
on^XdgQae0X;g2eqMUZHf0^mXngG0:a44iB]Rh?DBJMVchPR`IH]keE29ljP4B6j
aOHqR]5Eh\Y_U];Ee6Rb[NfJ_4O0mL@7YidolR<BH1hX\CFT^F=XWV=pMNMnI<Ne
RGJ9P<k[a4:kY9c@X3j^<ik0_Nn:GD4Qh1I<GhDZAQPie?p?bf:H;?FohLhH`jY;
361oO^E6H[d=6iKkf<Ud[_U1U8p>=YLCSTR3hO]8eZPIL6_6@Kd`k7ee;le[aLUJ
;0=anqcoUKVOH7A_H5ADd2?<\Q8Eh4OnqBdT>BEl?4IG[2i99_o@<Ei;lC<Oa9\<
iiBKpYiHSOiQTJR?4UeDH\^UDKE[8GG_jAa13]hX_@E2;2Xiq\ka3EW0ZN>OH23[
Q<5dP_o>4>1b?:KnV5020]1gYgQ3ncL5<Dbb[MdYX1`lqVC4:^\W78JSe`BTH@CD
BjoGW4m6n43@D`R<G<_UcXIOdHZ]K@oJ9aGRB`GeqW8\AGNXmN`V9dR16\b@GiLC
OZOld[U<``XNgd5@PCiNG2bg8VbYAI;L8\7ZqTS8YSc@UAmH[ACm5^nVKkfV4\HH
1d\Sl1=YamhO@i_KKRVHW=OnP0J65\^LpCUQJ>[Y[kVZFJ\@4NP<D6TZdGhE^W_6
K<OT`\^[2oBci6;;\a?`@4G0D61]XYZpD94V:H0bAAV`jVRmA23niVBEf:3H[LgM
nkDoQd8Fi<[MbZD1d3?ijZ;^YAO_]gcA3UBqL8dSf54<M]AZ>KnbBUTe25:;oShh
T3lamlP\F_HK]K=]H72ZFI0k1POeA6J\J=F1eXoqgdIF^UceKjZho4a64ngG57cj
eG[3ch5=6Q]D<L>SYHIcLUIo54GYEL6;aF3P^g9[<38AXaOlq>DE]cWAo7[e?0Ne
A8BlObIf?AQU0D9QCRGG7G<kMOF[ooD?`kdCfO6cjWMf:Bagc9U6=R?2GpT@0A38
6j>^3lV1jJ;Y4hgVV0e:KXgoj;MnoWH;C:G^`YO`kaVd>MF68jnGKJ2CeX>kCq3P
3R=GW1WV0D\D;c3D2UJUUo1d>[FCBhCnICUReWYd]k>NJ31lPclO4@K4F]o4e;6g
^q6\l4H8?=AV`VK`6eWGaZhUNao:EDVc=Z[YoAaAX]NLH6<H?LL0N;4^1;lgg;<N
_eQ@0?[o@Dm@^q>TifAf_bY:f4o]FL8O?ABbUdgZI??lfZS[[Bl=ObVM759ETA5_
LG=8Tgl\OmGOB;W;J;@YqJ`Z6U93j2jX:Z4:A5chX=eUC_\RQE]j8\VaSL8IN>WX
2ag;d8RWLH?qCknDl:J3:19EM1b>I1\0_^CM_;k46oKCD87W>7gVL6A@LejBk3kC
jmm7n99jL\79pTFILmC4gVPnXkee7e@0dhF0ZHeHP>>O6n;Ah1@^EHhUajDM<g@U
q<\5U8;UOAgWZQT4bIbSa6f2[C;l8d;:N\I`XhQ1=N@5QcFKOLf>`BV=i;nl1RdF
09SJX=\^[`@eqbnD;mD;j5kPYiShf\i=Co3GGao0EgoGWVNj8I0LY21aDXP>Wm3?
VF7UiMeR5Q:Y`n2Tp8]cg_;7@_n3]GZ1GC:L?[HZji24@K7MWHW[ENW@D:HmL5A:
?];cnSeb<G=kIN`DT]AG5E?SapCKH<TKO6IJCfbaB5D3ai;OR_AQT]bB1VUQ45h8
XTo`j5oPad=Lg@[=Ai;3V\0oB5N:T4`[g`q^nGX2ZchNM^eWLk_G=JoNfF@g[VC2
22gjK8lWFJ`SW0lIWDK^Il[o]oJOZbYoD7mqH?`XN]SG^doGQJDe4>QIZ<SNi<2f
UW]]hAjSJ5>9l@]^h<Io2[iO?j[>o`CGk@R^p;Pk2foOU^I`Nk0AjA@S7KkNaEK_
YBiDDZ=N@VGbNF^G<Il0WE>i5]W8?k`6?lbbdnGlP1ff6qk<]I69k\I01WH3hHS;
S1JYQQI`Q^fFckcLk\<]Td\LgMi:7Y=A0q1N4f=gF_;ihd\Z0`BE5mknS9FFDkbd
XiFQ\fP=AZ3dW5WM8A7Da0@Vk]k1Hm68l19JSlJHfN9ZSiT:O:q5kKAc4gPYcoPc
cZ2>RgQBE8B8n=WRiMO?FMZ3CR<I>`VSV3mZ`m@Jc^heRFd6?1\JW94[:pCk8MTU
]9nYHhICP>R>kFCd`dL_J^a4`D38??RX1_\0WUS42mnFP1bY;Ua44Y0:pJeAeEVh
TWHJ3c:91W\>\]Dajk6F08LZbm\m29MUb4SH@WW80M`5=UQ=OlUkf?KJM<2Rfi]U
DdNVq6@ZTQ0C=S7TKC]aVZMC3GjW9doUhmO1N<I3c^OB8\UcNhd6f5Uj0X\PU:WQ
aB^A;mR2@eS\Yi_;qDET6UG6e@^<L5mVqIU]947l5FjjE\0]PoS:jkN2>K_F8iDg
B=N=\B7?\Rbf:E@aUo_5P7G`UCRmYU@7o6`[_aAp^_=UEk<3@6gL0SgWMhTcHP?X
][FcoL5[_hQFgJ=oBPnma:VMZ3L;T8mI^OnCMYh7j8_gmXqEnSZTIFBlobb2[mKB
V\OSTe1=84[8Uo^3T>_<bTc=0WV:Q7QY_QU>>J9`NGXN8lbQ;_?Co5kqZ^b3?[Nl
Y6GRQm;OH>QAMO9]JOKBV`aMkkNVWMc9igHEPJ4SOTSj_^fgh<\]QUkd^d1O[lA7
q9VMm`[Y@TcEdYf?@geRaT@]>1cO?QfgAKh^VYjZi0nF5^Q8?qOo`U1cBlgan`J1
ZikL?VFhi`mka_^KkL5;_6[\R?G2oP74Se_BXCgX[:>W4[WPLZ=17CNmp9T8Sf_T
CnR<:^n>6^N\DTB<LNEU=EKY6D91`;VMII2hf3;09<^D_6h:6Mgom0[>c\ZL9o?p
jK:gm?GWfZnRSMW8=<4Rna2^;I@`Q@gah?g<;5b6LKC:l8L1La7K3>oRn_YZETe7
9IOIH=OZaIEHe7E3pY_3VNNh0F8mN_2dk9oX7@aFcUT5Aj7]70RfaP\O1\KG2aLJ
mnMHeQ]hg^lq7lkjY]LBH;A:[W7ZQBN:6Wn6QFFfebd2:FQ0PP=T2G<Tf]^[R_b:
K]jPXD5eZ:Bi3_0I1[VYH>bFi?`kHkIpH@\IWaWBAZS43P7nA@_HoKOGh[L2aFe7
nHSMgf=;^G9D@4Eo]jj:;Tka`9`3TbJlF[J>a?>WbI`qG`PXBKiI^53TCXn;oAKJ
>f>;Bk6N<ER^M3j_1cN@MoEV:32CHES[GKHd16Qe]0nL3f6jgHdo0gQpk1n4C15^
d44P8_5SO^\RQ>TaMUZl3dO:YW=eqEkke9Z_ebZnXbFB@j3Hf;@^`L0aakGViOnc
OAma?^Z7V>dbC0H4\T6OEbLDT>nFCJX=kRgHF3oBg3<q5PXTElAlYKLXgT[0\\Q4
P`@iEW=J3dTL[@MHlFn[fU[OMGWE2\SRW5a[fNB\6oIbgS1hYm8IO^<@H7qWFZl<
^8;j>1Wb1Fl?<K^18Y2R0f6Ri7FoXRPO4ZcHiR`0Y3T1b3NBYV?H^`pVoK\_ANNA
=MGjVHlghVY_BmimX\deaaPTBl?GgWZ_G]\94d8:>d_6_BjhhSN6A0U>8L<C>aHp
J3WdLKE4b=g28dd^GOVGE]]B9gfSBh0=]KATN6`Ude8`MbNe<V7ad@KlOBW0AbVO
Ye2^]l8p\\kMNf`:ZGR2ekWb\4BjeU9CN8?kVEbmcFDOSDlDbN1[[n65CUV@LE`A
Wj_QCT<TOJaRB;jXp07fUCN@cEm26E?7YSIoW<4<]O6a>m_WW>i=c:55>^AI_jcS
56J[:Z;@PgWQ2bdJIeFPDHEW`D;Tq6B5YXQYDSJmURGeNTZT66nU`Aad7Q;bD[Xn
kS\dhD@1`1WOQmh6@4?M8mGKh@]Z_4S8<O=`e8YlKocq0T>kibhM\P4[F2<`[nH3
f>No<<?;h>od1Y5Y8BC3kLH98;XgKV>Mc5keIAYHoDF8SOP6QCX\2P8pD;I3T71O
=8??0KWiIAhUeXWYmCbRiT@:<Qg:L^TTS5_ECjoZ7Y^h^1NC_7cPkPIeFN]G:<Fj
=d?cfkVGSe>8Y9JPK`i0@Z_7f7Afj4pi9cE1=_3[U`1LeXZ=n<23JlN_c`P>?E2Z
i=EeiIg4o<2\k0Z_fgd7U9fk[E]?gcCi\90R0BiL[`Tm?59J@ON=kbUZ1SC^8nbm
O3;B:q?SgAc_A3cFbcb88\BZXg2:W6^bG34F9C=CdI=ajAA[2_NPKO?eEjZ8KTCP
0L\:V33j[KhOqIE9gK26daL`5VUdf2:Uk:Kal_0OcggXLY]nd9_8iZQQpjLge>;m
T43WWOYe`ZeA[EX@7U_KVB_`=1C`V\WbTMGUCeJ6]N:BDbDQ@dd7DYe40fMZLR<p
7`0Yd<HY0LQRGc^T>bK5AmSFg5dV\nFn]750La6R[T0`k9ID]6Xf8@gQ0kWk_dQo
lALQSY\JlZb=@K6mUKHbKGXF=6^N71qCahKF3M2okhn]3NPa5^`UB65ZJK_>aK7W
lXZHa?S6Sm\MeLVW]@ie<NjB?UnN5[1SnAG]H2eD]CdH];ScZI@aPSLQMToA<pLi
kLUQc@h=mikU1DBPT?dZkA[bREBV8Wk@ZV<AYGo6^KlUgm[Aa_[>Ulf5Vc1OEkZP
noo0W9kb^iQU1gB??VSNkU\CUEQ6eSqLa_GkhH9^e[CofBk@:K<Foh\IiZDP5n<l
j:dQU1\6U1f?Y26KI@@<^QPn=5IJ]T0^OFF7mHP7jK0C\dX<dG4l3EVY>@;n4p1B
_A<HB<oe4_>gfHICnT=>5;idOId]MCe3cQTM8gDJ1LB^IGNn89B`N3l\BkRDZ3AT
JV^GBfXe9<5K7oISZBb[44OAZp0`k:kJ>3H9ld3I0i=U4dJ0[H3>\adj9n1X1Vg4
9FLd=d4>6I>WKXIOn9omc1Q1@D2dkDE>GLHTJi37dW=kYNPT6gpS9X0LK:i=HVla
a7S:nhncIj:SmCNSU0]n>QLR@3f2;q=hJBDUR[\_F=daS[lFJ>P_@JO]:8DmhaVH
_i0=?HMWkiNgW2MRb`kLAUc1_[k@9CX;mpb@3?`VMH0CDdBU8FQnPCmneULd1L2;
MF`]BMDbZI;jR5d^>\mhe?jI]^8m2qXheWJT7e^7FUOLFH925A@XgSO6j[k9@`>g
ePNXQ_UZ;\jfU]fGO>Dkg`1j=3XYm4:ZVOE;f?pba]D8^g;L<Y<6Hdej1^`mlK8<
n58RY0;?N]EDDP:a<d08D;XNMdJ7Vgb^8Z4[AC@ijTf9E?:p4T]K;\Tk@Cl;HF5A
UD?KV<=;>\]h<BkVAWQUj5W8XOE;DZc?5nSViSn]N]Rd7aCf36f=;9BY>7Mq=T7S
2feNITC3LJY0]IRD5JXI[KIg1>G`D_WOgmLc;5=^UiIXfF1lmJh1IhQE25HHZVie
LHoB7SE<eApdEmRMXG24bIN=B<?I3O[Z^OEK>466URiX6=ja`CSf9ajgGXWPHS<c
fhNZdN<?YJe;M6TD9hPYbI70ff<HOiBWdFdMn<WPe:KO1DU6^pfRA@_[LEVfYARC
daYN2gOZHM@1NTW^8caFiFg`3Jb6nV9oI4LbAI?:9aV:62Wg:O9`W2RHq^KmKn>\
m9GCkDiH0n?mjpQY2C\5ol5VEoBY0OgbC0MU\3a`jAoen51Xb9jT8fOOemeEN2SE
M3j>\C_o6N^T=m=S^VRVL2hbk0g1q25_H6QLaFLTJC>?B73jRC=XO0Lh`2kO@17X
\NfoR=6[EY`U=<SVQTfKUPmTo`Gb8:dfddK707Gm:CCBLL?OCMJp6TTS;6`ncUcY
@b8M>i16d_JXJ_K;=<44B1Co=0]Z_^FcQR[PKRe8\SgIX@Sc`H=W`Ob3;h:MM?Fn
XEED?OULMXR0jDE:7RT34\k2`1q>M:OWcg=:>?7>m_JY?;L8Tp9j=dUNcNfnPG1a
`m^9Fk9NdlOkPQaeVB6Pcfe]ZHBR:[HY<GC1Y]AKb22aanTKReXPBbiQfIOnXK2j
d6M7Cm:hYMQaW7UUjn1`0p4Bk8GS[=CX2Cf9E7NnB@23nG4lg@=_SdOa@`<j^:<[
7cXnIF80d6f0R;Xgm5MT_Q^MVfJC4O5Xi=Qeo`NJf>;HdVg6ZRP0Fjq47Am0S@Sm
]j1ClaEAIa=dHUfX>441f2<J?kcPomMTQ4:ET0EZcE>A2S9?@9h;mqEeLQ;fkLa]
?YF`6GGF0am9gcLDJPm6>[a1Y:aFic8DLS3D19BdNjOnM^9oFPXf7a5KWlmLkFVQ
6B8]]^EE6]iQp@RhlO`0bNPhM8PWMclNLLRV\IbUU3aI\0iK]D^Q6me??^8B9f4]
2@1?14mW\MPdMTE;p]52jCk4`0O2Y1CcJc@ZfnG\W2ACjfdQPVC63>0MBBeM2LRY
MXWm9=\oDP2c<g5pZY9NLCZH]jEFCNb7Qk=PMW09OX\W;GI3Fd\C^CX6eYMYnL6O
E1_<OfU<MScJnnUlqK3@^5]8KVN23T>0?KPJ]Un]<518dkfWMD@_YJ41TjMoYZP?
`IdGSL7=TM2ghLagjb9^pCLk36<<nT_nh=I>1KIcOSo;G1m1n@NL>3Q:ek8L3:LX
JTNXLA<XNP^nCl]L_>l03p=^G]\JNmT5Pc7jkSQQ_UNQYh[gcZo>A1mRVM6H9Cg8
76n8G2UV=?=oXkIB0\A@pSCoIWD277;C68_^O@bTB56X3JD;;cCYSDXZSedCQ2V4
KNVoQlQi@>cG^S:A8aRq_68kFIdaZgMU>f\m?=2]:Q3^7B6dL^Tl?cTAiaZTbW4`
nK19Z5nUJIo9@U_?>YCE@`FQ9Yql8W;_1H:0Ghn\<6AL;]dHKgA32G\h;i;;k4Bd
jonLJOe3mj70BRP725]pO\7MW@:]N7mNf9\0_OL`m0TBNH9Ip1?7`P0oY3\mZfb[
QafSI=8PlB`SQc[GQV]fad@oW;\eCZmPc9lc_=XO>f4Rp85gSFPikcPPRJCl;gC4
h;eQnR0G4eO5@H`UM71?TG1XMFNH=65;pG[1mF78ako<1EN81I;4<gTah]HFeS0D
5=5Lo0kPNOlU2n`?2cVD>c]Yb1PP^9d;VU@lpb\BH]4B[aE2gJ69^WB129C<gZWL
55PUA60O7^ZW8RR9mRC5mS_5C>R2;DJP`Z^0SafKpQ4Mh]i4<R2kaDU;RFV6E?hQ
i_gA^=KKG@76?N6pf?cU1Z8dk@bi3EZg;<PnU_i3Maj9W=QXUCi=NHN[1[S4F[Qj
NJbo7<:J0Tkc6YdD48cKBLl3iNPqMdH@cW5T4P5kJ<`lJW<oh6dmi]gdOfMK:5d>
>[MI8:XL:CHMV<`AVj@5@gC[RKXg?i3O49ORBb;0pOlcb9a[Fg?6gi<b9\IM2o<8
k\6LNhT:aS==_0giFaB5j;gY4IMTKFBb2g0N`Km_PXSlkBEfhQHbB[AdKmM7MXC;
b2>]JaeofD=KfIAp0mI@WE<Y?mokG1>=DDRCZJeHLRj7Gl?l=H4_g?q;_OTbNg@k
QP;EhlgkMpEZgVP^kid\iXcC:kX[lKJ\8W<H[39T_<MhRN1mAmM3SpK;6WgeVL<2
R1^W>?=>S;=a:VS526l4cMc@5M[YJIA?9JIRJ<XRUeXEb2q2EgXjkO6N8gLj57D0
UVmE8bWmNdOMa9H?a;iO]6OUdNh]KZ9:ViL:_VDM2;iXmX_9F8gjTqn1[d@`T44Z
<hO3=<X8joB<LNoZmAPZTab\f`TJ;W^\bX1j^oB@:b=i[d@;3T\P1PaT?K3<Tl33
Jb=go^3lUp0Ha\7FAkY<fI@jOJCCNA[j0Ofc>2GRXiGZLOPkHMFgQpUUaV5oo<RP
kSejg^V2LmJ<db5UR4=\A7Le5C8?8Zk>OI2_d<Ll:ND8fqTnIPmRjknHhWY91AC5
Hn@BWlkDd1i^V<J=ahO5LoZO2p1NnJ\V1?nCGYBZHcXJcd`eF`i?eU1D``7]hJSn
qio`>oAGB:g4RhS_=]WcMX^c6FLO2@CiQSFBpT07[J;\J=HIRo0J<WL`2?Gj=RlP
X<QPLBFdAeJ]YcGLfLl94M`gK;@\E5;Pqbihb7BCIl[<YRG=UQ\8j7`Ga_HZ@>EW
fBIN9n@Q8GZ>C;DoiM5:gf_Un]:nq71IGMAHQSOORL:hV>_J=C5dJ=:7a^`;K@6C
o60p4GT5G>HEMTZmVO2<GeSImkYVNlEaDJ_RSP6<RiJP2BdmLapSV_1fLKK>DUQR
C=dR0:7<\6W<52UD6nb1]aM0EWTih6_165lp[hI5biH558^a<DNWDW2^cTOZMZCC
`8YC:0iUEAW]03GORo;MpV2eXkXdb?iM9[fkDlBmQZZa\f\Eb8G0_b:k]=CnJiih
pCf8J>dhX\egA:46@?hN3@2HL4\aaj=H=nL009PXU2FGka0ZS^OjFAamSaT9q\D;
?NE[bQJQV;UbNLWeT26JZAPjVWYF<0X]m9ECY^d:n6IVgE6_BNoPRFD\pTdjTW=a
Eb_JSnH5YGlBYkHE>TjTXSIYBmX4h7lWo@S=0EKKoWL?Z^goEq0661bBL^<M4PZ2
D4;B_V8K5>3XhfND]gYN8EeW`[q8X;bJ0PVIaOPV_QbnGMZGb9cE]nRLBj@nSDm;
Hk;6BZd68p5X_3YJlQNelQYJ<mh_`JTMIR@>>7?TfZQo76MgbO[4:6=>k3bmMl=7
^hR3fqcNm^9\C2M49iA38>Ga5mK=c=iB\9jd:18Lg0LM2RRHg>iG@CcEYD@NpG4g
?bF5^bfn?VA08c:kWbkb2cK3=R53L;2je:0=a\WlPG;JlOSf4BEp03nKKgWJ30jk
LeRoTUJ\PbK@2:UYhDdKC8@lmncEI8j?^XpXil=X51CnFa4P5]1Sf\K\K5^M1<<g
7fe7Ga?NI_LWeZKE1WFhGC@cm7imUU=E><jZ?>7YMpH`12=6J6VUOOg_Y7Rbi`_k
95CHbgAhE2oAHC]QikWFlnnR1b7=66eF6aQgK7gEAR<;nI5>DJ58XOLHe@qBFM8^
W6hD`n<F>6c;6A]7JhPlMHUECPQLk@Ee?OfC[;RIi6[_Ak3NA54ULlq<o3m?=JeE
g^3ENoo]8ifi<>IMISo6;YFGL^oNRdRI_io9N=2G^fN6jdK2GY:`c<:F:@iQ3aq_
mZKOBS4KTJ`=Wi><Xmj7]E;IW@2HfQ@cXK`_J6CE\lQ3b044N:@Tg<[;k6bnf]ck
A4g;2JknHG[M8paZk7Y`U]PG\53[29YPGDe3;2oGBkkS:Q<cN0HgNZM\D7Qcq4BQ
DMjEZRD\`e9Y`b>mJVl:g2mPkPko^G5jZkNQA3g7FTN]iAoh9Y2qm14B<[`=1AXc
WO;X\H9P5Vg]NWFloSD50bNMi75<bi`B?J4lF_35\h1LNCcpJ>I9Vd0FoemX61QW
fJ;nGDn@O=SXUOm9LYEXXRX[JV?a\;FR_UlUgCVO>9;FRNg^8PaSTKp3g6A>1V14
Db70Ac<R3]2NojF6KKg2AX@3V<5oR8Yk^XD:<HGWQl=;1DcRcYUDEP\Ea>\MGXSo
i00HaqGX;UN0GT8bji7RC51WO8<6GI]kBBO@GQ<=8?Sc01CAC1_d4U?iYj^ZkZMK
Q2=KY;;iqEE89LH61lWZa_WM\L4cWAIooJ;FnknT2J<2^hdOLZViYP_3RHSjaPC>
T[LbdPOK\cme<dL4[IMXq2h`hKh@GhF^he8^Z=;8F;mNL\4:Xo>An@53a8BjhCBV
nJ?qKIJdj6JDAbS7R3iB@TSM48iiSM1YNOZoZBF1XT2Va9\XnejHTF>Q0nl2e1cg
N@qI=1kK1;lV349c_2<oN?P0^nnQG6V`I:77=i08gTag6e_[3RaZW@hLgd]A\aN9
F3;HS\PH6qo=8HIADAZWehf:\`Mn;?69L]LTIBHXKUHI9oG`b655YW^gpRIX4AY\
Cb1MDS[][GVL88Sk_N5h4YYQ5[09cG=<P=kk3d_OGq]]gJd2Eb34Ah2::N<G>JjD
TjWo>KPe04`Ph9RWDHkS\7<65anR3S[W;UpkG55QGj=JUXeL>@Q079]B0`?dg8R^
351m1dUk5b4[6joAJSH;obp3MGb^<BScIN`Uo4g4B7fim:6@L4_Eo;Uo2:LU4:Wg
jbp@PQi]QobQVj<GQE4lZn8`?Nj3IEmE^FgkemmDi<><@A\7@f>bNioi=q]3Q5ZA
?i\\>T^YNdRSFM;VVF:]Z]Y[GQ@TkG\__KV3SqZg@JBccP^B;ba\de^:`HOB1YG;
U>]dgjNo?idUS[p1WLHZY8^nPj?GGg[A@X^C;gdMaMf6H9V:H65:mFPOg0pT4V1J
n_D?c6aeag>clQCThi8fDjM=2=KM;GU[9JaqBLbEjEi1N8^0Xa4B8V;GID?j3;<6
MXmS9QJE8kfL;I6kW>qS=@O;\i6jOKV\3o`WQc_FMXT7_`8;=;ceC]cWPJCdKFq0
L\6hZ5SOa5dB21IBo:VjgkY9PVGfa_eH_15F8GFqnLWW_7k[hWDBGjYWH0CBb^?V
OSg@G0bLXl4RCj:fD^AF`>X8c^pfA[4LFiA6`n6^HRf3g_nFE4[?78NG@^AFnUo\
cEEkXGpgj?jI1E3@j:22<cb1UEMg[OlQG]bR`e1V:G`?LB`X:=Ze\IT=K4l9Ee8B
7`PV?q8bhERDQ][`D0o;iEfLVLE0X>9]bE2Jlb0aWCCd23CnBaA0Af\l78FEWiLT
@8m^qi[NZmofAgW^LM]hMBT7fe_^HQN<fKooX]X40VDhB2mRLoUQWeLD1l`44DeH
M=LHj95e2DdqkFZcMl3RhHa>NIXcInBfl8CZAd`X]XG]YgIc;onUefo3IBnJZb>0
SZW=qOGWJ?hnYSVWWR2=GjTe6J1Dn5T>[fm\on:ABfCc@c@ZfnG\W2ACjfeHNGW>
qFQLA^D^CaJQfoLD7VAQcj8BUTWhLae:AYFQW^Z4\:RLnnWmcV5^qdiHX<^F@VI<
DCAMeoZh[6=BlUBdmDn2c0k9D7g1iN^3jCaQPNd:W8eDR0V>eh9q20Ve><]L\Hd?
9cO7<ConIU2KC@QfFjm4;:FNGD?RVF8Cm6=^DXlqOZgA0=LlbgFh@HbS>gcW=WEO
n^CcP<hFDkZ\H<1FLaMH3E8<LO7b8]CnWHLAE<C6U>RpWM[6S@X29Q:]4>AK8O1S
i0;A5jECYniL@iMYgU2nPYhINcn0o[<?RN]MH]Pe:4<kW2d9qKnDVAG\Ui<XZ7d:
Q\ZXKPNP1YWMV];lX\DD>>Ro;_[22O>L=OQlO2OAQlH:P@j;VLZK5DH_^?V?3L0=
IDY5Ua`iTY_=`H3[E]>lqYJck>LlPkDB?f2K<6[cm=0W0NfNci_5bm^RBcfLDP5@
_:I?h03Y3V6M57npK;F;T@]V=[@KnCBj;UN=RY>aJeAJ9:J0HXa@a4pZ1Dia_D_C
[7AndVWB0Q@^]Rm54\PIJIU_>@f3\e]`m<q@`YeWoR1aO[g>^Fo6AmG2e:RnlhWF
2a\pCaj@5nD`5XLVL01dM8^L`9VA<mRdmH4QnDaqFKPjVe=F<hXXe>_L>7mZ\bLL
BclSJBX=_hiq>h]i[Bna86md52>\=R7XYN[8Xdp>KO:6Y\m^MWQeWflHeR_?:?fo
=_Djlcmq[OemJ_cbG@8URlIe_SjkdmhgM1SnD^Fbcl6qK^48OcT5gEIdlAh@5H5?
B6\^l@[1RU?cp[P7>40PmV0MZB8KaYGHi9SCbM^[0?^DAdni3gZ6PQoVq`FBh:Gg
@<aTfGg<2lmlKXaV5Lo?kT??lb[1qH]jDe6f;]OiZPD9JJ\jb?n\Sc2iAo^Kg>nb
qBT8bcVQbL9T<jHV:7m1p?BDdeE6_Kc;^6^>>j9^L5>J^5?01AndA>9Op8linlgV
7BDf]^dfBNRjHM2QcL>QmJ9TQqd<gV\O1D=@QdcGS6?l1[O8Tb3KhmYRQ]Cc9182
pG6bhBV2V3`f@^SbGQ>l:X]3XgkFVkfSGKWTq?UgSi7o[QJ1ZGlXXh>Q32mh;NS=
_Y9cmpBL`iaB<>?hjh>\A_05@6A6_p^]Wm]LWFK2>f2N;AjYHco4bbW6L^M9M@A`
NKKA];UamqLUHdGC`OTSGmf3H4]DB3LO_TdkLcLRTZ6@1KR?7D9DHh__o<_I5?CD
qn?`;V:\eL8=ob=WJ6BWDH9=@_^08KgEIRfcS:=?d5YMcclX:qHP]Yj>IT]IKMG5
7Mm`HQ9hD4AnV>`UjkOn2DG^pZHPYbZ`Bnb9K61j1ZBec572jY\am\0m>[NSCo6J
USMg0c3`komqWN0X\CW4=2g0PaFAeFL[YR:J;5[L3T4iER7N709k29H?IXj^p2ml
9C:7]=S[G[AnUF<G`18A_gDB=eBk\Y4k8=D`6C=CRJ549XVZbch8gq=TAh<XP<PG
mDUDO6>3[@ooc4I`OeZ8EDVS]hX24A\o_faLF3qb=jRO[jO\?5lnVXO=HTI;k30K
CIa?YoL`V>JDS82h8A?:PoO6_`pXQRBHLmSbShIVmjiOc7IN>;`6EUYL33fY?SlK
6qR076UU]GkMhFJ0S6Z2;VVk=0<7L]I?h@n_;8\@pCE^k;nEAD9_RTAQHKjkgYO[
Q0>Y\4dN[8_40_bTQ?OK2hGl@pYXiECVMDIS_cgm4JP>jbg^gb?F=bCkhWRMa2>f
@\K>HWNR?UQFXp_6SkYcSTWM;:BJXp6`ULN?BV^G6ANVWD]Oh=4h`kFcf5Iell9a
0o]U@HEWghblp21R3C21\\IlEdEadh^a_78Y`Xa_d>BlKYo0SQC91p:h7gQ:`=4I
biMc3V1dn716aal^_2CCHV0::@d@F_EQ\p=jh4F=IKWHk\J8nVN\2i_mGCUT\V9]
b=EL:A0H5;=KlVk?p\Bh1Mddj[>5@=ACdRDN@N^Y=[]Fp5De2VYZ1Akjhd_ISA`\
<`71O8Tac@aCKhMZY\inL:ZJZh1jJ4TO@Q7IH6A0pHTB;Deb^ZiI^9i:jH6U0<01
FhoE?<Xn7gj:FESYd\=kJoZmgVDWbCb:jpPZ6>IL1QWN7V]F`>IO9j`HhojlXhD=
]Y>h=k81qJ>3N[`f<SmiS[bb?MG`Ud:nhb;gEVd1Xa6ZV=DX9gJdfLdlY1QTYDGj
T4dkP5I>pQO3jU?o;jR:Gk0@JgaFVehLUHZiV:i`2L;Hl7mFBQIG7WP?@piAcIY7
CA[1hBCOfjK6Ljo]U5VaYfXgB<e;KS3@YX_Bljfd1ONSmpcB]`?YJC1h_Y\TM8J;
4lH;EFjf^^mT6AJRd0K61NP@V3e>A@l>FmN=qYD;7^M:M6E3?O7gB@Ri=TYSmDF1
BXVoO[Wc84YZU1K6\jBQoBJodo>MER=qDli4X8]\`]bf_1D;a^LPmg3Z=KALAe4A
2]7XSijWZ<HVOKaLUA?Ki46Hi5P:UgDgqbK<XgcAmQK_H37PkMhPSI;]kXg:Bd4;
n[H:nl@eT:9;VgKp`8;9@RLH45=bgG>d8K:`?6:NX0cGei`keAjq;`W<WM6_Zdd1
;0lcJ95QYnjABePj>e:S5:ZYAd2>g<oQ^D>H@F3XE3gE26UqHN]8BbX_d94fINKL
R1Z^R:ThL2K<Y1TZ<W6ma^_7cdbO:FO5_Q?NnHTE1?QpQ8mI>2kJo04S5>`FMNVP
]Z\AOfSgb;_6`Ea:E87\I@W5b^q?lJB\B1[e>;`Hh0WNo[Bqbb80j[Q3YNCB2ZD<
?LWO\;8ilYJJGZMJ36fOELPU1d2qm_>fWM7eci1A4jn<_E7^34f2emoF>^Z]M8Rf
f`^P32BUC<f4pdXn8g_O_jPilST>6ZJf5[g49me:Xn9QJ8JOjj:^V7^:YOM>UpSl
mnZ\chPe?YKiVA>7W\Yl8iB04glP29oRVEK4XGX1W[\nqJ9<jQmJWC;B@7b0@R3j
]cViO@`bFnIDD9g_6l]gHlBk]lo;_e:hM]=a`p_X>NK:@BI6^;OdU@lajlNQo^`L
1XLW;gDnn?g9F1clfgbAHAWkREgcObH9KH;gp_M=1=OJL2=ji=f:9fHfI0@8fkMO
]E=h1G35GWSRTX<HJZ3XlkXYL291PVVmUAgfV[5FMSkq_1X<\9kU^T_13]R49YMP
903edU=3EUc:YEF77WFTEc@kJ?pZb_0GV8GFd9c]LNTZ<hX2hDY7e`gSJ>HO\3BF
=B^i?=3BG>ep@bcX^:GS=dG^8ZVnh7oMH0O:PNlg:8gPgXY=^2oZgYNbf7FQ2QQ3
]@9kqe;QWHKEM=^TGClLFRX30n]49H7b^`4N<HSE7aj^iP?EV=lCkQ=f>@j321aE
7Ej3PpZIelm]>SiI36>[80Q;2@E9JG7aX[AMg1ic6jdhTPIBFNKhBK51SpmmRA^Q
4Hca<o<<Y=V<;`gfO^YdClFNl2cW7VK\LC27Pq6\OLYhbV]@6g3BVHLXX\^VR4MG
92;ChKbZnR?E15o9Qp>1W_d4=V4@1;X>n6cd@8ho]`m`Fn_11C<eNijDYPq;6L=i
A:2^m:1PQf``Jg[7gIeWQAh?P`Q;AGhc599Vm2qEI5Oe6BF1Vc6L@8:WnFLT:RBW
95@=^dH[OTeK55JpPdkda0>Uf;o=]E`GaPF7[ZSPf5M1]dm[AZb\URhCT0\\RCq>
nL5@QA6iFM^^FeXMo6Do4O?Raa`>hY29=Q@<BVke`^qAk^[eRN@Bg=4a>k4XiJDo
CiCQHP]0O^4GC74O]?je\GPE^O=CPI5;46GH`CaSf:YFd0dAnq]AQQHZPIK669FX
g<WkEbm6\U<ICNZlI9eCEglcTYpZXW7i=^5FDL@oQ]WPFMJfc7ZW93ZUHEYgF1TE
?3N7U[qES?a>`4C<Mi?^edIYORbd:SJU4WG]3YZhjodCj2KnYEa1OAGLPIhKbqJi
F[?ME1?kWdAlk^dD6@d_i8NlW_>M`b9>^nUf;_FPP<oR]YFc6f9T[7p_gae<lDFE
5nUe_KWgEQU0BXT\Kd:OIhA\Q>XUCP_X2Vlln87E\9nHDgF5c@U<V4fYVG];mp<F
Xl\A@][<;5K>koSklS5PVIQS<3b=T3OU]ZG;L8mbV>ofP`l\S6h56P4fAmHU;9lH
3WFH[9MT8aEJq>9mM;6VL^[B0m?UFmSThn5LTn8W9HJ6fW7[mEZ1^hjQJYm;ClDX
_04p?MTjUm><cSi8:0DXJP\=3CjRKbXk?j3mECeQOMI0E:IeZcO5nV[Bq4E=aI3[
UWCknEE[hll;Ahil<K0@VH]54b\0KZV1OebTSoD1=33i[CGDbqN:CA^PAFAn0Ybn
RhM76BZiRV0:o0A\Sh6mBVJWg>NG\R0D9XH?l9SLKH]K4d[3;Pq_ISV8LG9m6Z1o
M??Z4?DhQkA>LBVAkT:VG7AjcEJ<R298YD8Cd4Dm@0cF@lp9n?N`<JAk2moBVT4E
><1?4Qh]kXPnAW]WWf;Z]LJFQGdSoHEm=]p?JOgWR\mA;mY`em3L=ni[:BP=]=G]
;>aR>G]jKGHFSQb`S<Aqh<cdSd[Ti<UE:B7X]?dWcag3;>]@@AGgh;JJ[geS9i1@
<m@8:UXpB4dlTHe7j_JfBB3jn8l8dHcbhh5dGgI9QZX?N0J=Y9hm34:caa2DXRqn
C7\N_TC1laNT2X86GmeDc;mBlQ?0QE0kOiEQH8_LiAa\6@@C6mpI>H^UI7jAfjJe
YXO2J>IW\g`fG^cd<h<4hWQ0^][iVbD7EBiqGOCOcQH\n[NF1]RG5ea72dp]I<Al
F^K_OOU2jO7Mi?WG><dalMdk><3^nN:h=4l[Zjd;DijJ=`q\K<9WaLGNm2@=@mJT
eIjNgV_hCIgVG\fH7gh7]0]pFj^0jbnAhn>R\j2W_1F4UgEdl8]UHKMB3>VU@Cp_
F]=5GSn1TkNh4FH;efH1kf=B^0_[Q8L\[nLR1BM_^URbA:<SPqo3n:49CjEfIRSj
iC@iYi^L>JWV0NF1C[^B@dT5bUpTAij5fiU\bc8L;V580fGU4_]1fW=@5BkO=PcQ
7[XqBj:^aUKSOJCbAP@Xl>Sah;=;K]oV1W\GX[3T1mpa_VGB93=:=>W2;TBL[K97
4on;BMbLIRShbJV59;`q=5Y[e`k3=d3bNN18dVEeU]U[E5jhSd=d9REEkWdSqSjQ
c9CFobGG<mBB@4Ge6]h>_]KXMQElgG0O1HHPF>f8q<h<eB;RV9J2ZjEdn\ZF6:NH
NUJWfD7;4GF_bI4i[H]j>_f0Lpdk5oOS]T3bNCkXKTFb59D_=DMHhgibJHKReqd^
BP7G8SS1`[X>:O7eeZLl40Qi3e[X;WToQQaGf:dPSZaKqPgj_3aTZ1nc>g45fiiI
X:Zb4cF1`I9LUAGk0:L^F3H1>mdTlqBRkDS8?RhZSL;WXG[jfoDbh0c4S[E:[JbM
Y`3dB>gS_`3MF1qSYQ987X_HK1T>oDm=g50ACfo5`>7>;37_\ea]:_Fc>KQa1pjk
TXe]kAZN2XG<498T=nQ\oYb6XNNk_>B_3PKi[O[n\9IbE;p=8L74MOd?f:WXebaY
?_bC@inG;i^eo8YblXVF3Tib456>6c3qK_HS]\:[3e<^A>7_I@IWACNniKeb4Vo>
5mGI`Y?5>nPd9>8DSg=p^AJbKS8_0aCZjTI[9dW20IgdPfGX8HL783mo][;eq:?2
JWZ`NVKAC;7^IIR2Dq=_2ZX9]Ocf<@aCY8UE;ZQK?B1ZW>BGlDM?a:kCpVeaULh^
N<^JeFo`j]X1X_?kmgkEo2JI1_V50GBj0pB?U?nEOQ7T<B_@ZG_G_;]l`n:d\2D:
Ed7BeQZBUo;m]52IJ^5BW7^?RBaORMfSq>FFYN[]@LL4g:ITeD7S]1@o]BM2?fN]
eIc40I;\ao^CX2d]dZC]\PoN[:PIS8mhGIEKSM1]TTMDADjFTnQ5j0^q6<FPQ]g?
0CNhVd_IdhaUGNH5<9RILHe:>f[8h`S@R6i<aKZX@KdiLb9_hM7JKciOKkXq8J5X
46QdDB0:g`j@TDJYfYFTl<W`d0Hm6?nV;96oB5SAQl48[GBiM0TKdRH<cVpd=E=Y
FDCYc^_NjiK]W8?k`6?lbbdnGj]jiKNVm[RhV5NkgWCKWO^=@f76RMT4GmnpXUof
EiQVlKEQTiTQ84_SKcP6RLb]IGK?[4a[2__WgSQY3f?X21A2DWZ_6DYZfM5fMA@q
\gE38B?QaGl0Y0g]ZLIY_V5G:QGdAYQ=62oDFd7HAGAOT^kjdl>9^m_b31g@^6k]
qlYPk27FUUDk?ni@i^Yh87Fo^Ve26jTY>A^5WIVQBAIK?2cDf>0K>_7MqjLe8?Y\
6nkSX9anJFfB>E[;QOT\6jN_9GH:;J=8G<4g>j`NoZWJ2je^qnAQT2]a:aL?4`N[
K?C_BfJTfjU]GDRm75YhIl;ggoGoGdmpZB]0`L[;Je]K4JT>F4Lj>7>]\X9T6S=g
DZ^G^\?70:b62GWJ@\^[3X^a[UnmBUkQVm<=CaS=j]>XD77e4D>K<AGAR;^EjDoa
BHf\2kXXM8dao=77_g0KfSfmO9UHIK4>^4gdR=mDa[UKpcD2LFLGL>3EZSLQi=Wa
]j2f]C^CiL[dIM[YH<T[WE\bN^7jjcW[6cg@dV\JhI3j9fNkAh[NCFLHTCb60EGO
mK2cTfZNeGcdRFBH_eoBVb9N<::I9lFCJT_=dO8Q06Bj^7[j<GT<k66;S5j:=M9Y
JqX<7BI4`I=m;FlLMQUF=Z]ETgJPER>iOE\D9H;LN0lIpoT7m:Ej@Nd]b06SNSio
7lWnRhQQbnM4?SNjVW5OH?l8p_;iLTVY]a_MdX9gNnjBe9TAg_FW4mB_WC1<nbaA
3^XlnIdW\0@=q7[1:Y2GA^8fX;5_mj^<cgagWhYMl:T@kmNK:?ii>Vfo=@E5jVCM
L_Yhi@ekq^_87P[>YmV7HWa4C<i<PQ7lPUY_0QeT]^5nYHo1bQGE0Qm2L3^1WUGq
EQjb33gkIcOXk4Q\G7<abSdRhgieC]ZN@]7EKRJR15bopVg><I4PX;d\C3F1`AC8
K3K95@>5j3EjWO;[gK^H0p9>FN7Ik]Mee@YI\LD@Ng<a5M7Nb_2_naO<RfM]YPkM
B]m[NcpaGM>_aYIDSoGA`4KeJ:VT3M>M25`<J4PLLWZ0;Odd3>RB`QpAh:Gen];U
;;O^TNd?XQOQ0dL6fgl[EIRH5Rh^@<Y;aV:n`O4WV=fpLXL1f\I\gaHbCSe=P9qa
KFjoIg[O>\ej6i6EU:c@6>hbdG<nj3lb==cWCpCYoHdVTJ^HWKEPXcgCWB3a5_oo
8A:YK\n^UUX]S3nC:ipfc8OjTFF]LU8g>IAN^KL>Ce=ZF]igemLO>H[68l2[SY\4
OoSp6O^B@[HFI<N;_7H8a2o^W=gIjT[n2PJc>k0Y_CX=dT_5WZNh@fhqUWc61lg3
nI02Ygd[Fc8^F>VR3i]A[oB4TZoWWZg]T=QpLaXE6k?6MU4QPf6YWgmi:XjhoW4o
Fgd=n6:\]cnQHNT[6hDXqBU\]K6f3K:`gPb]nb=JVefa;=G_XlmjTY`i6V;f26X5
Xe>9p6o2UaDRHj;iS<_IH2[b1j4J\A^kRA<e>C]V6O@EFD97P5ajqS>RFJ>a08o[
VnknEF6n>DQjG]eFM_fBH<YFS<02gCmqoElGTh^RhUFdMf^]k47aM@IhO=0?I:5K
MlfD[dcO:3qE04f9G:^<?UaKgP_`m`>U3K7GD90SN0lXfRUUa2B`DigX?pJ][HE?
Y?@42E<Xib>hW8LMUfT``;40jP;hg^BNoNBlZ52LapCT^@Zf3KB?E0@<3]b>YDA[
gBnLLZA\[Da74:]Ma69Lo3UXjaOn]N^L;gajI?nH>pcmYoHJUe8;?kS8JK8E1;@=
<Ti2ZM>c>5^BX2iWeg_]4KKVnWV?;8aCj`E`5gF\N<pmdd;P:a]?9cc5^:od^VF9
@H>lS7aOkEJQNCm^]P<[T`hRFg<7H6E5HMAm8lTLGAAAKp1gmo]nfO1g8DnaIQHk
?:BI@]h<8BAZ90>MOI1[oGXRca4ZEjiR=HY37fb34>_Qd=HBp;UK0jfTEh;KQXHj
`\9<S[if6`;RCjl^8SU]Z_EWkYB2OV7:Q>E<:VM66cke2MAWo@CK4p2D9jj7`4bO
f\=o[2^XkB:0K:7nPL@8ABkOdg1?\0lVKcQ6;jn86eUjj>Ao2QT;C:CK:BpZ8oSY
a2<W0NF9c5;]PBF[=4kM3cE2]amA3igfgRW4U3nqON_4<lFS^M[gkmiC^9]f>8@M
X\:aXSl_OEQb;jDM7lEBP2PC1XoeqB@dNWjSdi;9Sf8FKnK47:]W5CGUN>b_a0[Q
[1Cl8h5DgOE;KP=C14TJHjAaB?XqP^njfl@BCi3;U8`[joiS0GL;[\M`fBe4<Ggc
ef]?gi`JMgZY2ZTPn_V`7;@57<ZXqO]fCY>B5i[=Um9m@o9M@j?\UaBObDQfS\gp
Dd\fV\C8M<0AYdIK=7M][3:i4eg]ehjJ<FPl[Oh^fgjoh^hfjZ?F\?9Dlm5EIW2P
qGiKobIFen_>@[f[`9YhE6]n_IEa?Y9WDb39@W;jSYm7Q`6Wh`ZkHS08VjPZC<25
nOhqKA62`22iOA1ic>Y]T4:Sb7GmC@b3`49HJhf5cg?ejT8LkYf<nG9JdoNgZn=a
7ifYqLGR`kY78D:YfQl<gO_DdD\M9jESfnZDIVLk^ChE;AO<=;5_C<2V?nEU:Q05
bY?Xplg7XL3KEMj?fUUo<8S^OWWm6d3A22SnmWmgb4G47h;=A9nN@:X<_2daD:lJ
5DSq0RfQW78XWVA@Dk[Hmc5ji<L[?i\CFgA5HJ>AKZdSEQRf?3_f5:pFa@I4iAJ_
Og5MmAWTW2R9D^=B[QMnRS3]?BiWGoXH1?YTAHhC>^Yq?L\GVnRcXM2ZP`BY1:SH
oL0=2WjQa8BoODgg>TX9VfI:2f\SLSANpPBCTbC^Oi;?:i_:UFjoiE_YMeU=4h8E
:fAMLXno[eY]fY=^SQMUI8Vj9dGMnl0mdgP7PqgOo`XXPf`GB`eFdJ?HXYDSk;GU
=CU2KTi<hA>IpIC@2Dl_\Idm:__7aKj3UA_7Z^RHiYAUgHMO?pab81dm7IRjUK`=
]3<EgJiIL<bLnmNhQp3nK2R\O4nIP]:XEF8FL5[5hS3jhgg]U7[joJd][mL;eHjI
gEN1pE=gdg=U>158XQd9MJ90<CDCf4clSh2=GbPnkO8_Y;k>U[hjpYbihDn;S[0@
7H\cUnN`RkePa[c_m=j^?7f]I69qiPh[oUf`iW^AjTdLLI<nUWbNOWe\Dd`X382J
qTc5bjHlmK11SQBFk1ZDFLamDmeDn_=AR9?SfN>C2cPqK?TncHPTd=2P4cZGKUcS
qh<?\B1PO;]Q8ZlE?bb?oZe@VIPeE^m>;<S=j:d?Yp^5fY6IcS?Nb2kIfX<<l^VG
mfQf7AI_2^3HPZ]HZP?:ZC;SS50;B^f2qjA`g]7`2oTi60N1b9OKWEDeB\H<9I;B
nkG`hV\K^O\Y@XE3^3<2qJaE2jLZC\9k[H4aJfOg;PPMNjbA7L2Ylc5=QH:GL=lp
FbP0FKdcc@[@1m^QWHD@0kJ3k_ij:]jJIGE_[536pHX<lFjn579ZmS8ghLSYYFc_
GRIdO9AJ?9^\72E\mQAc]ah4ln^YU?6p;P1\DjQ^=SNbKaCFikbK[c8HhUV<cC>2
cm_j5J\8MFGm4\D:d2@UJkGT79^Kj7peV1AQ=Xe8N05f`hKkeIC3G0f\h9Y\:EXG
9=\3j?]C5ol;Sij<25TpREP\hS5>3kK6E]>:AJSno>NWn1X7Jla>ebARklS0;7^_
o]eM`2Ob6l<>7eUME9A_j[c9Li2K31o2nZP^_EE5H8Rb\U=Hj3K5==W1hgj82_L2
@6C;O0hqT6bc:0EYV?RL[L[GnFK?1>bRbjT;8V?jo^KVD[5T>F[SCT_GN`9hK[0W
qAXTlQ[4Ng?<<DL9\FQMQQR^?EOEW<S_9X>mZW4:Be2fT6fM]24Ci3<ESLGV;pl`
GNn:8;BlS\B<]1>UOkBoF?JDn_fCXa:cZK?loP5U2WFoog`o:?6[kDRG:;>P2PIS
Y0lIbbNGffmMZA0TLE5WF9BL3Z4O:jS\]c6AJ5BS4IW_OPONS7SPqj2<IPeljHb6
3W87YG\``E0PWq3mhkfRFobea\Hk<^fcGC6@E@RiTD_9YLAeP=]Fn1H_[p`aOQXN
_PU7Wm_A4O]o??Q1RFZ[NeejM4[CF9gFTCM\pK0gJ_SKLAk5PcC^P_NcGO2QPTMZ
T<HPDS@Km]ZBe5h2fWO34>;[APXSqJec7NeQJ0n[X7Rm`TTDgTj@dmH;F?e29Y5e
<WR5^7fbpTTF`F9a0gEm\o?YIOH1HY[kcRcO9^C4K>j\JlA2M1YpS4CXBchKLKEm
@`:[WZog0TNj[IM12TVLDSEIJdKS1@ifNYR?VJ?]g7Rp0bHC12U1=4PMFGCb[bQ2
7lT=gPJ6ZX`23>l?KUgN0bD`0g;HZf;_?NNg^CRb^mAkUWpc<N`IL8PDD6NP<WW=
e6=n68kFkRbDYJYmcIn6Djg;70[C@\6o5e3C1>ABkh$
`endprotected
endmodule // module vusb_hs_dma_dev_amba

