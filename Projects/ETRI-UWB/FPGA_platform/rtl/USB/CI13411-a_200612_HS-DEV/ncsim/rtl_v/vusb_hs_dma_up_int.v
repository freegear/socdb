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
AQ`;]SQ:5DT^<_8Yf1ZP:?LII`92>Ge20i73cM>>4SN]fK[_We<f4PMIp85:fI;6
KKc9UQUE;VDWK>G;F`2Xil7LRBVb\p96Tb4F^R8?=l4MW9Ic@T:QSI\NGa?6PTg3
cnbG6GlQX2>Un;@Kn`FgI:U@mqZPMj?>q5V8B[4_Jg21=j7HUfL26@84?IlDdUXT
nIiDUIgA@VZp^T\kF_KbHmgElIc;c7ccR\DjU=kD2Oe]\i[\p51P<@eUoE3?:JUV
:T;oM2Kga:_YCR@BHBakTMGk]_M3FpT\f?SdTUjN4:Z?nJY?5f5P@T:OVACao]:0
cG5=p1Qnnhl@`47l6gk_^=N5`GYBY;1Q<40o1gKpYei1L=\=::86Ng2kdOIH1TkO
E7?]om9JaJq02k^1L;mL9K_943MgJFDc=WQSc_<J:>9bnq`dmOADj<Nb1;<`:GRQ
X\WoNEUi<\7ilBQlGn9ib`qfU3>b>9dLJU;F;4ZH04a^_?XUk21N74Dho@[aXqod
CBj>0AgbmQXno;36ETZ_2KAmefLmiH2AfSgmqFUD8KDZao`g2:5[m:[F:[d]K3RQ
?]KcGR]mjm=0YIdJI7=2dRm4LonCSnJa=3iQ2KSgio[_qPgGDd`ZN\fSjSkd59fK
[G<5`R1l_P?L9KBAgY]\78SaW76q75C9;g[KI>njVEniFE:EI0^RKILO>l\W7lbG
Wa[FZUgiW[lTqkZOdSEmRfjbn0Ui=QUO?>0J8[iSXIV6eBXdSZQh`2Cl1b8b=oAR
Xq>2Jdf@B4VI<_?W\XCZ]S8bbJRLTd]PaoPhR953^lic^39cHlM2XV4]6OPm;X[H
86XkD:9S;_H8`adl<\>JaKYA8UmCeoHHKQ03pQ1=[fAM_7R_YZG:njS[@mjnOMng
9<1G<<HBb??ePmQnYTgTG^[7LRaCSNBZ?F3mHEP]G=XSLPF0HlCifb9Yg6C<>`\1
]1NYplbHdfS57`TIDendk^bmnh?[>KM4LjE]cS37CAcYe?M5[gPRed\Ln3[?E`MP
cN3LI96UGec@F]R7TQ1]bN@IKERPaZUT`_Z>9Gbi2^EbqJ<nmkB:H98XSLP`fBU^
RGaq^RSK;0?NLGIJ7gTk^>4S@@Y5;T9?E><^bZNf^;k`jU@6AIfP6[T^\;QipP`@
X[QHI^cZ^fg@GPoO9eZ0QAYGo:LZ2XXWI8a]fjCO1ZM48V82QKDd:;NjnqB\M>6]
[SEi[l37g7MZhnafA6j:_gU]k4oOe00`b[mfV4OLg;qd@:\8[<YIfLR>@>=R9DBJ
LI3@?JW;?>ZGXO\n`;;8ZJgo=Ioq\0c2co686F5[b:<QMmLf;f1`Aan^haO;`:`h
mR9CKMIhZ]KU\Q2OPD3GpA[L461;P>E5j[TTVjDAG_9f:hDSWd@T=l8Ri_PZ70;G
@Q1>BaDAigoFZ=8qL:bPC?S9m>QG8L9k\6ZokZ[:DHHkq\5YOdRE8LZXM=>YjLEN
L`:_HADb]l`2PmDNPF`1QKfO7X1bLqAJ9<NZBgdcKkdc_VE85^8RFk_RNeR3Z8g3
FbVIoA4]<gc58ZpEUa14Qm^L`od`IChK7?XYSXG_e>>B;:LhMHc?86b@FWajn]`2
1pU^B]X28FDGCW<mBCeXHHUlaK[97_@;LdT2i65G\pfiSj`:RFMBKC3JV_q@`W7n
TG?F3P3da^`XYKji>7I0DQ57SMk^l5Z@PWFO?dMGopQ_62jIWXUn2bW\HE;@5_@=
6=P3qDdM>WPkFm7`_aNV1Mm=gjd7DYe40j;9edbpJX4F<Voom\U^1:HDi@oTRW9\
5=>\m`p6kHWAYTlY<0b?l0kKWQd:c^Gd\8BGRaFqJXi3=^88l[ITBh2<?cIC[lmj
egWV3A_Da57]>LPAk;lAfJipJRnfjCeRcn4TeA5UV9_BfXTnpe5GR]7Uhe23Wni>
e7FjiB\K6@aUmMljRJOcN7?8]L7Lp51L=AX]jFP:7RS>>Pm\J4Dnq>EB:YBFYBkY
[[EU@LQn;EK6lO2g2Zk_dDiNFc764qj;6>8Tj79VUSTlX=VGP03mBlLd=09iqi_l
D>hETQLHP<8mO^TX7>0i``8WiYa@K<<7?V5IcU54p^Zh\gh7``DlIO:@Q=cUY;[l
6<V_Ta@7QePA[5jp2EWBbS>X<]c6noG]kjYULRk3Ck`\gl<[am9aTb1MhJ>Rma@;
gUeqMF`5eangbX`@4@6mM^BF8k:08XAS4cL:LR95=1I^m0NB@XaNnDfJcoJKph[S
aZ?G@V66fAHc0:==Z2@gnJQ00c:BqmBmdFVNcSl@O5kUdD;ZNe7dnE6l`2jRAk_`
?RN1h@=kVq0Z_>8hW50SS;1\17Tj[78_5V5PQ]=@KD0>i45VUqNoG_IfBMkmeQ]f
j9>8nf9YFCGN;i7l^JBSkW\KqP^kIc8_UZHOj0R9ejfM`cm=AlOH\khIo@e^W3l6
;d1FE]:;D_O]kpE@N9_aENoda^SR1WhcG3X5L5`8H>\Bg^4`pBi3\ml[d\?kO^R3
?GOZQYbZgISiV^iAd2W9Z51ql8?=g[\`03cJJCGG4DEC556O=kYq<^9aB:hooBZf
^]KmPE\RDEKRI2RpKYEGLcm1AbiXE16<3j;JDfChICp>?hSI><CHaEd94F^M?ECK
`\\o2]AaDc7T@E6Z:2JpNcJcbkPT4NYU2Pk_8cn0A<Ae1OoRkBUG@3HDRNPqeb1R
:MCMj6;l@0^kah>@GgR6ZBfha5JLng:IHWNPq>YEB8dK3>1_eaMY[C\bZNJdCE]?
V3a[l>]9i^9DWj0W^d0[5cMH]fG5OF?e>AWM8cl7JcoGIp8ld0USYjWeC2o5k=UL
=JgSBIEHE[WGg^??OCX^9\e<CpH9@Dj?M1^NEZWEB>:f0KU0ce=4n19WW<UXEo@i
4bq4nBL1F^T:Vk8TYd55c_BX9F`nbdV<KNm_MlV_ZAO=NbVbnWoLRWa4?D]DB?Q;
D`5?X6QBaPg8]=XX^;oTn:O:De0fBgP5\D^BM?dqK38caACV\a\FV]LI`NWo[CV[
aB@5QCM`fIIBe0j@KP=D1=NDC@Z2nhPJbIV<9aoVNc;jT@@e1dlQR^SS]SGV@T]:
>_F<c0M^7RqNK?;Fh[T^Q:7<680E0]=`_cYGHKg<c>dNDZh1ATccHLdD;=ohDV5o
798=R@]Uj=bjhlV8@[>h3AD6@9D2^VQ<c=Kd9eJJ\60G1T:FT194Dp>\doT5CX^9
?4h5LSBI5bD9mJ:]5U6FAOchBA@m40e]H=iT57j2:J:2VG8SAqCFVMb<dSIeAg[g
NISjni^71_X_Wol^\_A?R<Nc];h]?eQgRT[Sk`a>OSIP_R[LDpYXXgTi<38YZ0bK
01?im2Q[0PAHfdR3o5Bf8f1fHpg=_PVU;G71GJ4;5S>lCB]LP;=;FF[]YGcFYPh@
AS?HeX^C`pKW:>RFnb=Q>?E5ZPSJq[ndeJbPfIoJmkm]aAVkN[;cU2:7pVaZ8dBW
USRi<;og:Ih2dEdl5KT5A6?lA:3UUFSB;laWl6npgMLXK5KB:nbJW0ajRmDLGj_a
LIJ2gLO7IAEGmV\Mm]HAL?`eo<OpZ4OB\71Of4G?YO1QFJ:I;GQQdMj]CK54U0S?
\3n4Ml3X@6lPT`AX@0j2:7_NB7A6G:ke9@gq2BXH\>CE3AgQdc43Zd?MYjE=hHE;
jB@4Ha_;`@R90jq]5[7TebINVd[k6eSLZ7C:J=:I?9Sq?Fd2<Pg1b5Ej:ZYZ\dnF
Oc>fRAnA?P;Fp]P;F8ogChNhoH5g4QB85iWF9PZS2fA_Pi9NGFakYe2pTKD?FdgH
o8aA2m_OQ?9f6VA0d6KZkRleJb2`>?4@hVZk]@FAqnREbFfW@eGO2\6;hMK]Zi>R
fi8f4a=p`[V8EiRmKk4hX;mB`GA1h9;A<Ti\:QUBp5]Cm5h`S1IGR01kW1NhMhF2
p_S6LdlF]IgH>JIHhb=4LJ^j]A_\?5UnQBADqT;YY@\bgk6`84SGd>cGVQ@Yf^gj
I4WJ?i=;DcNI>cMA;gJJ8Nmp]P@`[Fa0Z6LKCE92GBk@n4e0<4]6<@Sk^ISnB[:B
BBm5NO_fOeHpPk`_EYBI@?jlTiDJ?ZW>@2bNbk]\9LFL6^kbSYY2;^U3b^<`MI]T
TlpAZKELIeJ\9>57MVM_PPV50Mc2KUi1`I4bOEe_TGWPcMo@C1GGd6@HO8cMWPqo
C_d]jNIk@\MEGo3YTJBXNgg63JRX=TQEXV_YXT9cm2E[ha@20QP6LCafmjOqkhYm
>92_LgOjCn67c@DIl4;Oo@@<gm\f7QGh7l4@]nZQf=TPDl<q3ePP>?RK=6gBT\II
>nO^c`:e3F\46QnJE9e^U]0BGKP\h^ik2]XpoE^P2412bPICPUM0W41[`Dg19UM>
MSf=DiGGh^AhBmFldIOL1HSpcLB]D@_gi05[I\l6D7i4PY`ifPI;X9nWK\=OWmcZ
l?Fem9;6TjepmCn^LGmAS0MWDS@]f6OM\Voa?KB[QLEP]1og:hDkI]iQWA_A37Mi
VOEqZ8R`9_`<RhTmR[d\FB`NM3CF?a:9jlQ5]<17P\iWJnALJ8gSmaGI0eZpAgfA
;]UDnLWcS>hKQD8h5CBY6>]iZ\N42cT=3F0INl505>W^1FF0X0`KpROg]K[:a_e;
V6n>42ILiR=cU7XfMjF^b;REnLV5A0Wn<Si7fh0f_q^cOl]EbJ[6_[41J:njlHYh
YPFJ0oJCVPQVopNPTH[;G]QRDjnBY1I]1PkA_i[8JL5H\;=]B[fm@22`d9BgqRXZ
[b_<G@S5m^Edh:W^gj9Wd>AAgLM8oH1Wqi6dDQ:a8fc8ROVJ49[;fAal2S8dMQOa
aFI;gNIf77QpD`0B^T^M`cObLH9A[c\2]S9@<>6@TXL8Q=T=SDQEn7q\H[F9DPTF
Efk\:<D]65=D4A@6O8NC_FTLEH1?0oS54p@R@5a7\Bb_LjN9=V8bOQ`ka_6e[7OR
UglIgbQBn;TO8ph6:gjankjgQ55Bn=FHD:Ke56d1XU8CKDK3nZAnn6=CqB>N@m=b
3B_<R@@Thd0eQKL?fjlYC6=h9gmb323XW_[pnS`bYXG:90NIkZF=^`Fb`H2`Qh\a
]bO5ZM\fKg9W]\pN>jh@@1bBUYM_F_jFBo4i>NBnODlSfkXM?33;\SX8Eq5E0`MK
^CRkTZaDlERN1LT[nEMam_B71M_[=:]iC3XiqAT[^2GbajdbBiH[b@Y]ULi<_76l
E;CWA1iIVE8aVO6pS<d3ce3lIROXEkGkR:Hk^GgMA2nWLjURHRW8JT_5^MP5H=9<
h6pFZB2HGgOdKSD<Do<O@`^Mi>gIJYVg<;9ah:X8kQ=MDpIAa9ncKfFCEfa0NTC]
B;_hEDFMLF0309HkN3m^>TICf<IV3hLLki3_XkVT]^<QUmd8IBe3E;\>YB8k@;c@
m[3\0U@]p[o@?OlGKV_l`0SGkK\XckIcW20a>NR@H=>[]=f0?P^YKPef9llgT?<4
2[Sa:50]iZmnYTcF1hdgk_A5pmM[1N9WaGK`F^cmci;_l@^\XJmd:>HV95FXP]^^
To=E^4G2NI0O_b[89[PCb5IPgfi[abE<Oi3eLP>9CW:kAnPOdi:<RbdibH6;A;cG
<<gO^Ymq85>]_FnV<=RaHc0[GROC4`[oR3Ag@LqJHNQW^XQoKjMghokiMMS\nLHT
bLe\\bfRABS:8]Enl2a86D?[EO;^c]5XDkXP260kk0]H^LhAm3H5o?L4\aD??XbY
?F\1ITj^:<;m;h]GUYP>\7FnMoJPf<:M:IEml5=KQnPqWlg;0Pg`ch_9W:@Sg3E_
lSiZD0]RmHjfDQc`78LH54@`4RBZL3_[J:YQbWlg<eV8@=gjIAZYSVW=9MBXW^kE
l8iW[04G331L8;QSChkH[3MVX[PeKMBpD[_dVjY8=]fTVOIG2Vp[jZ:DeMc\5fED
Ghh>mm6ZXA5VWB\Y\[8;GfD5mH7GP3_GF@IU1=IfOjGJO<d;X\8bfX1KGUVYed>f
0DY=6dLMb>QQm[`7c7KK6p`D\ooH`QO8kYEU95@iS6\P7kKG4L1`H^lS7A6?mJ[o
P22S[T^eaIoY4Tq:]`=C?FW^^LEfTE\RoUj:IA9[d^d9DWS:dZJ`e_J::^eH:DPI
K\c>F=HKQRJfl0<i@hSlAdWPI3Zlo6QAH_oq>6cSD\21=lAN=YK8j>9meb8\^f?^
JWPc90K\1d5@oog2H1OMYP=EO3iQdenE6e6IaLhT@gq<oeN_>3LGj_UKeYN[?qZL
dmjFa?]jETDlR\a7S=Bb1UgagXm>_BW2^_FlA\5o=1SS`TbO\YOb5>LP55gjQJLd
l3fj]LEgI[f1`7aZ=Ag@BVRBS7]>_nThfWp\emD6D;QLkm67oH5=>fNFWHdNE1C8
206lAMA8oSRLZ@miYCAoTVH<:HV==Wf?b9nMHR^ofHRX]2eD\dbZLKA[D1VUUlnp
Oc3Thma2\O5Mc9gZnn]Zoc@:K>Q734XJC8GS4ad_YW3gLeT:\>RmkdgBamJe=0kQ
4m0MO3Je=bjXKPCqSdRHJi9JSlTG?e4KMCH0<P9T3OEmZ16XZL]WlE`[SYihca_E
mJAN0[Q?U]_go1E4`dRAUVKNId>?=<WngcRgdIS3\YHVP2gOe?]:ZPFG?Uo[Rhpl
lnVZM;j9DUTQQb\T^qe1WZPT^1R>03lce_bc6nXchch;DKgQ;hRj[I8I613mbZPi
fRS3FR25_bc1KLZ^BmiY6]`oF67`5jdNmOaIjPNQo?AK\AX>V[mZ6q0j>X^4MEXk
bB:bScETn_=<NDLQT8cP2o:bgCAmkGbWL8T3]nhD:YgoQZMgDpOgbY8T9R[mWCX[
P2Z9n6LbFk=0J]UgQ0L=Xi?=OBA03K`:olGNlSjB]aXW\1C6B0UZfEOIQ5WY_3BW
SmJa<6biQn\=LLGDqVEF_EA@A]afkC^2BmDqXdbdabG<EXRVa[a<j4[08<n<`eRF
8TWHkDg[FNhm00q\4>D;7CLb64X3d:Kj>W8=;e22KETM4W46]PpGhc?[XJ\P^OBe
57L]cl;if:=A5:iWW0Ah=5Qh\WNF1pib;nbiKq_7GlL0^aU^52R_k`oEYmjQ^<eG
XJV_\kO2aSblMV=7]?V?loqY`N:aJ[7JaeBYEQ?c^?ZCUO1Cj5Y;H6mQC^L5Y49@
PP7<hEE]]hj@8bp3`S2]k3Zch?=7Pq_b7CVYBSn5LoU?Fn^A:nm6^cm:cj]X4ca<
dg1[1m?afeSS2bHM?Td;jPXh_jp8ka2[nl^gPM:I?4i976G0ATlW9U\0748H^k6O
h[M3@W0N49n4A@p^IcTB:a:oIoI?l]2M:?=4jH3HJ<Zb>AH\llP?h1O>3FHPd60O
6=ooc8IghpHZUK^=k?V?oXOlm?n19[RiCXe1PM=lLA_NAoY83@X3ilh@A\f3TdN6
7p==^04`d^S7aA>_If5KGG7bGSZQFgOj^6RhWZNIET1]pmoFeNj;]h18UK;8Y600
C9\GJNEJZ5V>`R:fDjQ_Q^hIbU]p9_g>AY?UaeaKBYj8b3OQ2_lO;T:PT>[=KVYA
QZ=HKAl[oV;Ybd4]WFmP?VhpZfH`PT4j`_dE5<283VNKL2XUG0Ra^DYJU8WAX>N<
0KcmD]@@qk8YQDQfHfinC\_D`kb[AoI9VZ9SAkgJ2l`fS;CP>Gf3B<143EQTp6e2
aLW_nli8UG:MlaLLZ4kBOo4\RW02<7>mCbb>iqcF0B\Z8idhK<;2F`hoKW8Ja5JC
>oeVe[kCfdKmV<YVilWHO?ggf27J>qd]inkJnJ7Y4BX8H97;L5ULUH@A<@D8`X]F
ANDAaJ;cj5kIWCh[>RA_MG<i:QPQ[O0aSWWRiO<4D=Q6>q<VYIOHhgQMYbJ;<7Gk
;?9E1oIeh]6Cdl8B_m_5Za0[ZAhh8MV`ZgO;Ek@h_2H==RGR9Wi=\CUO16^CmLL6
E;ac_q;R@b9:5[F;IlJILEanbAORI_HH^kkKF^q>kQ2cKChGG`17BJ[RP\1eciVC
DQo8J\l;?XP`FPAkcBe:8:UI<6Q7MlFUUGi@U?eIPIjJmd>Mk=U=a1hTFJM@:aEp
GcYj>g>nLl[PenMRh0A\>bhJ2Tab;m^jJZ>8g]77iP2Xm[0a8W>gcgc;eSXM\?a3
3lJPabeefXc^^E<qId^<F43GhJn:[0P`Wn[?Qh5f\6HlaNebm_YJ7WKfB\C^>CaD
?nBVA9KF_WO=kI_7WCTE;;Ul1MJET0XpPSoiUX2KU5olJ[7PO:h5QTb;g;F:n[6U
D;;kR:;m;5P0oldi;X5JYSmQb4a2f2;?e9V[53SE7BZnaiSq45dk`CGH>U@O\YoI
e1dDWgPFJBHAL:E1;QLW^1@AFB1AhSIF6X<3<l4mga\``@41\U@D`kh1:DGMUH<P
@5Qp^[Plo]HGQG_TYcRY4aQm8]X1L;]g=7;P60Hm32WgI7>>@N:n2eV4lMKP<\iH
K]YmdgdWS6KiGKgA>2oG^BSpgb:hMI<XESoj>=YDJ707fVS4bel5>^`8?;mX3`_3
bdTW]Km`m8nFHS\a=PY1Wi<FUk?eLa_6]S]]EVV[qW46AjMjhi_2Ag1MbO<mH35c
jhi896XdRMg;H:9Ck8j09ni9H<YnZL;SLE9WABI=X`oWL^HDYDFRdQA=QBoQ0qNL
55Dmg?9DOBL1V^SNOU\Jc:[H[Z8NXI5mYB?^b6h_fq2QSWnWd\42VY:4n7PJoacG
0YMcXM<cU=5WFWO_UV9=hS?3XUp>_XG0E\@m1UjNFkG`]AYo^0jCYkV9nk:>O1cF
@O6Ul]QWa^fp1HK3]?A@GOdo4?E_@^M4CZ^05e<cV4L]c`kPL;Ckde3YC4@4bQl>
k>qIo8<`g5q2MBGZRN[;[a2l`N4:B[K5f[WC>IP?g?cN`5cl9Y__neBgd7<m4_H;
<qS31]4_WqL15D9eDq_VI=6XMq8^@V@?U5nlgI^B0V>S=b_<am[h9M79qnj94^mU
IflKNVc1Q4jWk\^8McLSbe<VV7IaZTWkUEUB:bj?OamgcHKqHBQ\k@mqnWRKN[7:
LJE@:3ZCPKR@PXE=^aA3oPlCdPc[Y>JM1N\?SP1jHT_DG<n0OhdLGn?HqEiWSQf]
RVNmXZ82le;Y:Dg_^g2geX=S9d;`?`DJ4CF1oX1i^X[4^a]f1Ya7b7U^4FkekGlD
^a`OoJX85Ag`Ta;Ad;X<fhU1SH@5Xe:3G07V@_I]OM=<FGV\U2YWYY^q2=Gm<k^I
RlclLn2YnAg=LQ4E7kPbN6Rn9L16<B0oAGRkFPRAV6lbP:K^jVA0R34=Q@2o0jj;
5\m6;83m4_W[OW40B^g7lK_fXK\@A=G26HM\A6VgimDNfDaNJ^aeAN2UD]5YVeq8
\ZAUa1VI`CZKm;7Hn_1[<462YL2Z\C^PVV><:joDF]PL2HUIo;]gmP?gM]G>0Jo^
@5A7608p6g>kEHhc89B0HFk2d<K43cHhi7PdMI;mYC[\=3D]HSoQj2gU8@]9W?hg
B3ZGi>VVVc=?1U1\eJi1pIoD7Q`nfh:nJ@<OkVoCQj]RmRdm@I\qfffoQV@pli=c
Cc=q]XhF2O2qBj[ha9\E:03Me6QLoYZ<1V?Okn^h3<jX0g3n5\Sp]cAj]7hq\@oh
4DQgYF;BeJiBNH\?E;cE4n?db41l<XE>5@nY1mh4?QRbp2P[TUW6Uce9n:a^XYRO
FdKV;\gKAQ>kbI;VS^HK<hNBnm4^<_hnW=D;pTEf8i^PEjRT[m1D@m<ekAOmFFGB
RXc=8dXbCM4\RK8`ZS=0OM`MS\g9g2<kEq8^ob[i>GCl2^K<4=JRjdFY37Z?InaW
E0COZl:U4nVH_oM\Rb`RhpSMVj=_X203bQ6G^Ti0YI`F?d5>l@Yi?eB=m1=8V=01
N\:SNJ;hFA;okc4M?<4C76QcBkSo9qJFPCBYDaEY98U8GG=aBb>_oALFk3JXTQ_6
8L0`=7j1M\;?^\J7PS^@eIRjpE_;ZOjCWaO5ilG6nJa:RQ2>GGG:Qb:EeTO`DB`5
>g]QLgYTXkKcQlXcp4O:C61a]F:iP8YA[Lhf\HfN\:F>gVgTa;UHD5Ga4QPp4UXl
aUZR7FdNi\2BYA>YnZO<^[M^O44RgKq6H8b2EG8^R<S0:WiVkeW?4:13;dN784S3
a:f=b^O=0nYEdp1]b9^?do_Bg:Z2QObDijTDAhSV5^hUac1@g`liF1@5iF=Bg0qc
Nj2\nD^d0P\dInHbV7f?X0j:BQ2d329H<lT4QmW>AaJfbVjTjaqSdf0k22eGi\3_
b9T8P@mG_@adNS77fG503DUh9=LpWRdHb^\5^1b46Ng\253i1Z[XUZdDDLU=HM1>
W]>_6ha9bSmBJ[KG[N7q^MQ0l0IQYh]Af=lP3T:37iSO?DbTJY\SU5H^d^3n2PHb
OaEoM?;6QV;LZo]GTDSAMm\4eR_\g\7`V_[q:09Jb5i;1XH8j>ji_d6j5h>eG=8Q
OBWf\iC8;@FALiH<\D:?KVojVF>F?:cO_6EAi=O2>ZKiJiSj<T<H?MPLAd7q8:Nj
368b>QlAa5o`_0OT\mm=ih]e3Dm8U_9Q\dOkK?dEhN5g9ZojDIPP2E4IR:UCb0G[
>MBQ<4<5kgV98DXi[HP5qG5TbSg_Re?`?XoLUWlN62SQ2n1bGJ2bEe9Mla`41@WG
p^Im[>0j9ZBUoa>6P@_K:@^P3d3?PV8fAb>:l7aOl[ngXLnNiM]b:VJ^<=E@ieFc
Tb?WNd5^dH8V]dNSp9PIEfB]E7]]bf\86EA4PBDnBED]DkXTfGKHY;n[PbZ?N@2O
^lXCe7M1h3C]b@oY7[`H>^hN\j=:KA@=pcNDlElYHPVVNHWedEBmUZNZHoh=a>Hf
1n2U<i;42ooAl135]_28_3\JBd98EI1`6DVPHS<OIRF:OZbXq1Q5Ch=fW[=H]4\V
^njK@A6gA11O:CB3`UFW4bcl5MC=PF?2MfC:7BQ9_5@]fjYg1Na096aO2d2dm]1Y
W`_\pJYA6MhdEJY_QaiDkNaeb?gZ^R6j6S9QU^kh6]S;I=63`Je:2SJ1hC7Y6:9X
__MhD42mACHOEja;U8:1W]RLqomXaUW85<LLT::<O:[RPJ?0RPRS>TeBj5c[R`R:
bp\VGdmW9FO4dhVn@<Ae5F804_7m@e797>D3L`8oDl4P:8Tg1Pl09b0b0oOAMDM0
=fSd1VW9iNIC;\W[GbqVjg1bDOcjG3]VP^=XL7g5_O2J<JeH[2YQDm3ke`3T:\`P
IB1CS:]^OeGYKd7fk:WPPFFT=^a6:3G`i0Re8HjqK2`8A_j;BafjZAcoETNh7_73
l;ijAfc8h@A6_[_mGh^[[[<hqNF>EBchLYJl^83\3_ngWL\\fW70B3aE=59^]Oej
9DISjTiV@ql^L^X:8J]F^FHOSAV@HX6^7g5KkoIaaZ6U@i<3ZOmhhXcQYaf6Ug1^
p2DZj?VNqGGFJCg4SifCTQK?Eh\n<;SgcCaFDMElWg8eS=Hch3d^mk7F4PW172Lq
>3OVYc1K:U6V`@>BfjaJ7cK1_IFb>2H>l>CYJ2WJlIabGXmKh=q0l[6iU`pdl?fk
D2qgd`9hHLq6S<5gE61>VEBIHFD4@8;ZAgi^`888<:;GdnCCm\JoY^do]6DJj23^
hqg?H8YOTph]]9g=;BX6=m?fIdQXbd>M6cal7o[;M8E_]LNA73hSl[a97jQ]Hg91
61;QnPCcC\qW46AjMjhi_2Ag1MbO<mH35cjhi896XdRMg;H:9Ck8jCU2n6_<ZPT]
Q<MaCCYh_bb:jQA\LjEFJ_D4IoYBQc;J`Ti45?KGF4iI^YaPo`>[3>c4CA5QNeY9
>kLkc1?c[p=SQbKm:h0\KJ2dLBbGTIDPSA[>>di[e]R8CZgUB@3_5HiUJbG3QQT3
NTi?;mB29?eU0e79]_DloaSOeRLKSb_7S31VaOH8UadAd;[boQAjjOhjGcDB\T<Y
VMKo>MjNefW2I1c6p2OP2Y0H8eA4eGBSAORJm^[3S30_o@?@VIekeiOYbM?MK_bM
FAh]_V5_Uo_N;lD[1h=O[4^l6p[E[39^BY\6RNWD6RXED6e1T10=G;6@Dl:eSlJC
=b8DBcPO^b6`lO2cI\HDEEg^IKNP4F2R7Rp[88PZ:oXjMf22mh<M5V:1<MLoYFmH
8;?boVIG94o1S[`W28K?9=n;5cC_K:dmSYiN_<^oOhULRDTq8=co=n<qOb`m1oAR
=HShDlQ<h?k>Y1gA^VOCPF[VblnLdg?_CE;bX_Sl@4e4=OUp4SSmO8Iph<o4CIOJ
nLmlaU[?Tg?<::1AASNmAT:cTZDFd7T]?QWK_FJa031Qg:M1<BW8iKGob=nClU9P
pEHmOF@Z:MnLjCcBH>Wn]h\2TI27?>5b>`4Z8JXTJ_=ZVEe9YMm8S]2SS[TjNVVg
OH9KXH08n8<=IpT9hg41Zb>d;`U>a\`_C7fig9SIAH_YBCi6VVUEUobXAj=E[q3H
VZE^5pESX?:T8a8T0i_oh5QVV?RjCWVYL?LUH4FQ1>AmJgAF;ZFhp?6onC\j3:K;
WUd`X_^MTQ_@am25P0_PgJ4l_o=KSEl\A<mRjMNGHp?V5CPZJpF:E\O?ikSZgNd\
^gC_@CU<mOX?1cUZ\o2:>\3;WAe^Bd84LkM3SFjAK43IT`c^CipcV>gkEUAmU]0i
8?F0[T8`lLho@OYIncQhD73`j3IW7i?OMb3Z;IPW>:W4_;lHF?:q>6jeV\ip2V1H
mm]p>D5[2MN2aKDk2;I[@9nP_mJfVdJgT4jK^VLfXYUE3:PBq48MKlT_\DW6U37m
n;@28deXFMO2926EkUYJoDJCEd77m7I=VnRedU>iET@YJ16XID3=XMG0poebUIgT
p_NQAT1>V`cODlHddVf>YFR:PcQF=gIE7RBJ:P145OZR3@4qO>J[m\Tqc:9jYjNd
cmRB\e=cLIFmG:EK];iZhofm5`7PVZRdNTWZKCV\@B37K4WBhnaS5JJNcL?dqdia
n4C@qDAUnAE[p2VYI8n8HWa2mFVH>jUV5H?A9`Fj84jbbN=T0ZCWXENeA<doV<4:
3iPp^ckZ7KNGD\[mb9@c2Rk0a80U4C`O7OB;la\q=bZlDCJpn2SIOjQ3\34Q[c1b
Q0c59[B?]?3e_9Xo7RIP2n1DcmCTPkpN7W>=J_q45LBl_W3G[HVjV9;5B7>HigFK
aP=Fd11a]8I0EnDLO4b95S9>0;]p5V6<aJdpW3X>K:>?3`C>nRn>2c]Bi[oJD?1i
b`944c5[LnB;h0bdihp3hkcN3kpP1_Gc;^:c8T;VTNQ?HgEYbbfVci=31hi]W[0L
?W7SKS0U<;WjddW:6:]\ce3idJ67iU?mK00^XCq1i>VjXND4P55bPHG_o3VbS;jV
0n2cSTkJBqc]MO6NHLH@]?>:H0[1UMViL5=>oEiQ8hEYa8AO^\dO\V;nTkmki4bM
qnecmO^GpNaZ]:j9R0maSN\QfGOD8>m0B>`F:AJXJ=cDLWfHbahgfDSp`NofkYmp
2AIGPDfSl47YC@W0Q9\Jc?bo?AV;633BII1^[eoXRk<YHRn?`gc1@NSb3lK1in4M
Rb`Wb2ZV6<PqfJYjQEm\=h0WXhD>WPaj:hPQQbX_XANH5IB8A\aa<PjQ3ciVmg1T
?2m@G_5Xd5B;F_0@pDdPeKL1pDdPQ4O3[D9V8SNUhkL;OW_=:<Ig=;ZKWQ373`\T
ej7V3LTpE2;ck;8pK2h;`miZT^0A5T^4P[O3WcCDR2PIii?9Q6nM42?cYX;hFgi>
TEh3cNg@I>?EI7HOJcRNA8C=hL>p5nDMbD:pHKj^?V7QH]VXgU68F;nkoG9n0DI`
ie;CWnXIRIChm\a1_>XTnUO7X8@d@FLEU6RoqIX3;VVGp`L^_i5?Rlj1abEoFmJe
e]2Z_DhG=F6fheR>[9clCCiAP2PNON;M6f3P1YPbCSClFSF3]E]^nF;[I;k=U<EO
niK3f=MHIjLG6B\l>d;_NCi?kg]\4fn]]Z@SUI0\kBnl4Fk0Tbn?geQe:4ac\`E?
[=Do4HhM80Kfj=Rne_V5=RU?gnR\\f4aF67`_?5mjqQAFZf;eq;MTQD><4bQS^XH
0<Bm3`aJE?GbFKRm5L]a_3mNN2FGFLE?QoH0ggPGBq40PeV8PqKLVD437AT8DY5i
`e500KMKI3c?TiaDlERN1LT[nEMam_B71M_[=:fLCO<iH@X`@NHm@QUFN<AV_oUi
mIk=;1;]hnUXj]Bb0mJ\NAP@nEKAm;<3L2XV`Vm\PV6^K?O=?DH>0OU[:BSmhYe<
oPW2]ZggK0j3:R;8pfUmMOmgpc47R`?7:>5k7I:gZiIBa2V_BV=1^I]:E?T[gi7H
TngP^GUBUcAI]\n`B:[[=f9me`GMD^X5@gK[_qUWe:[CTp\1Ke:hb7X`_Io:LZSm
L]3;;Eef2\UAgk=RA<]DQ`kP0[FkE67?5B`[TbMg^_q<Xc`I3\>\[HQ]8c;M^2PV
N2_h0;5V;IRm9h>jK3cnja@;@dak2cT[8gU:8DEcUL=iaZVj]PgIE08Zb\QA4Ql>
NOS1oaYg2[3IGb;jUkbN8Ve<inkpSQWF>0@7InbOU7>?aT@FPAUiB^`ihVbI9`ec
XS@]1Uf1W0:iAkjda?DfHPibG=XnKZ8YAM0nS3bFg5UKScV:gXI;haHnWiVFp8mg
:cgdMnjgDF^P=`ZLqL2ONaX=pIH=@S;SnPJe2\eDGeJ]og9QkYeL^8RDTjnpdXbF
KLGbFR9[XlXZH^l6;bY]<N]6EBa]1A:9867;D?2CQfMSC`lEnQ3gI3[?moWR[dO7
PYSVLRYLp8GE?o[Cp6[VLT;eQ[ilP?Fn7gXWL:a;GSN?RkgLBE00hT3NK:VZm[U1
;PhZ0ba?d]ef^`ea7emY_Rlf5WSTS6NMF97WE8DhpLIZcZDLqHTC7C@TGh0Ig@[K
b=W>>?ha:=9g03PbXif]Soh\02^<V3Nn\0;hjXF^^Nidm:;:HiNEf[54gjiNHqgM
AmRHmpgcffMY[qSbV@W8a7L[jfRS8Dm`P\B_c1`9JMJG3qYkW=7_DpjTZAAeQp>K
iV[B0Lge5iASDAT9]K`0d5a>gk_0JN51aYeSEUC37O=lG\=ZXG7e?8L=k8LZMTi4
c@_BlJ;h?P^KH5bNPYH0`2FU=hYD\>C7CNeVn`DRCc?OqgVH81oJ4f8QIoX`lXeK
G5l:3]fWQcP0N0fGI<NZSRQo^>569SJX\M7C_mn6@C6F2PYBm[4I2mnQUZ9`?Vb>
5>S2O[MLKJ5BTp4OGgd?9LlHFISj?2D<pClbTj9aqQMjofB>3aO^_FMk>f_]b25Z
WRGQ]lVL04H9BU7nIPYZ>XKVQi;[_dj>[jKg7BKNgMlB<hjj<KmT^qSFZM1N\QN<
Xn2cda\;SKM3cMX4c6SjEmQY6EVk0OpP^fcNn:qXGfea1SYf\J^bo3<Wg_^ES6_6
6GWXFgTh7gRV>ka2kUCV=@QYLfWKHn9@_Bl4TL2Y]01jSHDaek`LnUL5?QcHbBqX
MkChV[pR?1U98j7=Om68]6bmI\A@SGh\YEZfd_UoSAZOO@9;cVYEL_XMQncnU1j9
KBSCmcaUbl7Mc:12f76pbUO\6APp^`j9LdhqTRK;Xg2p6nPG>In1TVR7?hNnfA==
YUGn4o^ZD;68N]2ClPKKV`Cng<=RoF;]B@hUh4[>]16m0_aXIbb@K<Z`mV?9cn=D
:8MeIj8mZ>j?cU9l=f63V1gfT8ii1O]LRJSOZ6[4WU3Gi92;Dan8Xb0f1R2XGnHb
a?I:??VIlj6nEACR>]8ml<M8@M2f1UTM@>BYcLgBq3aL]@d5fCnGd3nmmLaaN:AE
W_i?QCHbcGG[LNK\cn;:QSWpO12^lM@qbPcNI[YWeoObTfk0SQ?5DmM3:9_G`C\C
n:k:Sd7c2YW394fYX0V:Rec^G\^g_[?X5Q[EUVlf^mY@Qf;mYDfb<87h9j4`BCH?
HGhY<17==C5SfBBYKF^QdMfnG>_3Uj;c53@LA0KgWIJV\T\USF6@kI52;44^:UqI
^fHjE:qmUB`V8:llFN9Q;mU_I3b<\_@::<3BdXW@d?R@nEA?PVnh?j:o_?I:]9>0
Fg3nDVlAd`l5nfJ=__MGPL[_kT<pJY=ICjRq`Q3[Q2AJ2:ObjjaLgU2a0[TjJ;9b
`Z8:33k6^`P36AZW[Oa0dieTC]9GO2_I7WAEhB]ge]>NS?nDKQbUBBm5kQ5_m5m`
:knI@iTe6TY3G`AhlQUYhlodCR9:K4GKE8HcaRc^1C>4UUB>d7b5;GR7\iR;OQg<
\[E:R]DMYOlJo<Sg?E\Gf0=p]mQ=5AIqeT<CdL0aVbT>kdW]3\[h\b@<nb_`SdaH
Ua]pjTa69^JT?SgE[hbFU4H<__fgH6V=V6bhnlc92JWk74\j4MN7iKljREaKYC32
@D]J^EfW1fdj06;[?hlM76d[Y?RC?mNLShRRGlG6FiQPZdO:i0``[CS<B<8=A>HO
lPmWclZ3iidZM6Wq7D?a0QTpKdCnhO>qQ^L:eECNQe^NMMC]o8`UP>8b\Tm_gnV`
;h8A<Mm^lXSVd39V`L:L=mi2JYqnbBGhSKmTA@3J3B_XE_5h<5;dfAjSg2CHKATR
`cLD7KB31o25[I@NS`be[I\2UnGgh76LUM?KS]@TPBb@6R;mKE1gFXnOkTo\=1i>
>HQDSS;PMo@O3WX2><CWm@lW1YbMA`>XTKj?dZ3F6HbT6X[dKig9[X>822a;8_Fn
o_DcnSi1NkNOo5IQiE:Zl[>pTKg>aD:qMfdI[Ca5j6OBmeo3`f@?<\>Va`F5??aX
6f5McLH?W`oWP<G=3k_b36O;f=Voh;QH5<YONA]aBHQJJe6alHc6fDJKBDiFg9@2
9KT]O_H7BQe6[:]56aAPaLFZe9G4E`3K5l;<P`oW0Z4k]gMZ=OVUbUcMWN?;lhpN
UVH8Z]q5@:HD;\I7kdfLR;ge;X5hA2OU3UB4TZeC\Qb9:@nnPeA@hOg328IJnOYE
<al4FPUGLbR[;m0\V:@oGMGcM@MXCpGbCVgJRphM>>4H8VTaMidKcg815E5@^GaM
[:EPN=GB=@gk<ZgZ^APHc<0KaF;nYcWL4NVTnfdY=FST>_Dd\e@m=Kn[E6FA9b6_
mH19Q>1?B\b5PX5@Yk3BmWE_1L<5oOfAd]g2C5KA>V`c3H7KVkM^@Jn>7_EdFRmW
c6m=8B\co<HSQ]\Vkd7S361h5jUDpOLM0cZ[pL=VXeYY8Y]VhD]]7Z7SQ3S@jFJX
WX?Sq0E=oo>8WW\Qa<;Q9@A;MB]0Y]c>E4B[T<>M:VEEH]4>0o1Z>JmCKP<2YTHm
=6G?mAYQ7bbN;LIQ]77[4:3\f?LKnWJe=liQ>`KGT7]=8QmPmg0mRSiiM]Tmng_f
m9Y6HANY7OoYZ5TF88jqML^P?XIpnQI3GdApYB0;A>fI3fSoeV1khgnB_@YPi5[_
hBJU25c?YHkG=9\F_oP6N^`pl>jWcbW:WG]bMXACVd>6;:go;K>ZZdiGj3eY9O^c
:=^>g48oTlHg6B5MWLZS0@imX\B]3[PJKk]d_@`H\>=OBggjnDHcU`mH=ZMHKNGL
:bW6`WXA8TG1Scmd9BaS2Dj`4^\jlKWE@`gAPcNnM>Qh;INSg8BS7Ei`3WO[]QEd
6i9M_:^i8W:4\:`;im7_pQYNPl`CqSRfa;`_ld3Uj@G<o3Xg_6A[]OmeTfhWGW`c
kEj>6BcHDi_m1ccHYn7T977dc0E?6e\GkKA@]623X5G`oYVNal>UcCEInfUVLE\;
8jA>0FR26a2=E8n445@7]?:Aaen7VeNd2=oSBle9gnc?ZC8ZJI_Y1[D=l;]qTWBW
mPc[2?nik<=hN><c7oG\V69`8o9`YchlWdJ\qDZ>gB]\qRP3XGLT@\29mNnBd3KM
<EOdX:hIiJ=CaV]5;>O0Se7]mgT;1j@lHYXnce3@:<T_lh9GJk@k:;7oMqN<;HKJ
Hp9fUfF[gTiL?Uo6<MSS3QJTcjiIh6RA8>3nQbX7O1;82LYS_`Th=F>`25YXDij7
4`U^qi=7S\EdHWd:B_X:4J8Ee\M=FIN8:fAV2Pe]:5QiWXY57`8BZQ]]`A77_4jC
R=RMniI5_^eI:DJ88h;IV]0XL9B358<CM@S:l_VcP<19l0QF30AlL37qS>dAWcVR
e9nma^7NP4la;W_:YGZo:E]R\Ae\FbV4CBRUnjF[Dd]IPdV4MY;k5J;BS@^NmX:Q
FccH58<nHU1DjnT??SQKqIf9:b:2p5MJP08K0HmE@<>Cl6Qj:`CPaKWIeNI42a[6
NfBgbPQeVDGd2WH9_bAHidL?Yi1R[b3[HAa9o\^Y\p>\O[iN;q`67TKR01dc9XnS
[E=@D?G7@V48GJWA4doH:FoAA7I0eFd0YPYeiLC=1nn_SFQja5Flg]917AfOQgG;
2UX_WZ@n:pmkiI1?0p]?Q]j`\\M<TlfTmX_;HY5SO_M3M6FXge82emJPbO=YBIFJ
ULf4JdT<VmUe<ODcbO6fbmaDRM50lOpKEE:fYkhSWJlWhQ_E6l@UVWZ^=;FG2R15
oY5^j49a7;FJlFU;Rm12NenCeDqGGB4QiYqig4cU;7pc`6ALR0M54?X>ei?lU4T`
b?L=7jPm@8L_Zm[65=N4FeH=ENI1QO4o:a>VYiXPK5oYn8egCI^93M5I5n<^o85a
A:72m]R_n?jVXR5^EON4hQX7VjIgb?dY28QDZD2>^fP:Q884T068SA1D9a8go\BN
X9H:>M;1M8CRMEP5_]<\A\Ia0K7g?BKKA3PdYQXpBfGWm[fq>H5mZnn[ikVkY@<8
Qk`44gjIj;dBVR=HkJEoZB6gdN;Wk:mfETm_1ae?^[[oQ5]lKGea`\laANSiGWJM
W^[@ggOZOmD^?HSVPOk;ZS`g\1;0Klpam2R0o5b9E6Y83Sh@3h4ic8nf]VkMFBb`
Bj78Xi4dW]<]YOeZfOh^1cW8N9^Xi6c=f;hAh5VQK68N^Cdn]5m=B]n^R5NJRjPp
MbIlIS;6b95aZ:QWGnplkC7KD7q?9cVHWgCP:cd6dC_<IHVnS79DEEIA<2=h0Z`O
JTI6KI6i<cFENF7dOFHboig83762SZ`MUO[pGK?MBWYlRQn_QPRfYH4RShX?YTS`
4[72IVm?d]Rci0YR>V[lABUScLN9c;RVC?l>ZPZH5<oII<ogp>0mlbZ>q@=?dI\Z
P296I:_9JLn26GE3?Qgg?9CMbD7D=]9V^QVCj7g7dNOZkhlYB\FB44AI7O3Qb:Z[
Gg3`ncmchPnDcg[hqVWS=_?\piebaP8aa7=Ff?bbekc:3JW5a_eIYThF3I6>LZT0
:RIZELU<Ammo4dHg7HBkKkbj[nJF5;fR8MRffq:OjcMeHpF[d;ZRo\Jo`mem7Y_d
KS@T1M=8l:0ndeDbUN29aX`CgWf;`PG3eKhXm^bN3la7K2HGJH?n9Zd[CeEA?J_<
SaVoEp?Xb`NTVJTX0GQOqlm@\IgapcaIEC@?@gkbeFP3c1mfAO>4E8>b?[oRHC;l
oHehYO40c9KOljIW]GPOYCf^gWZhW4`ZgAVbm^7_bq[;MC65hp;;nP3G8p]l2_nM
`[6h93]N[f=_J^G4PZT4IPWTiR]\Rc=aNYGSP\KjKc>;piG_6dL8Li2hWNh\LCNF
>=[HBCeLA]=5^MTC<V7oAFX:6eXaT@Tb\5aYK9[D6D>]S:WFA;elj8Caf7]d9PS9
M=_fS5cD5na\TeZA06VjoF7<6k7AhmIQ7;K9oai1oeT`oGlG9^T8eN[mjmCg6\S_
;XYf^ePC@@h5\HgR<JG[Udl]g[^homeRVnljn_JCYqUA\G1:bpkKFh0]675^MN_S
gIjKgjH@fP<2C[4T4SRQHN86C;mGQYDEWUC7=Vbff`<@=5=H:NkO<hDQbDciXGnC
91f\9QE_AIQ\BPlljhj^h;0V5m70gO;EPp[\OA<f1;OU;dc2gghkUkhiDeS@[c=n
7mgD;H]HAX^^5DBM@A8mdj1n^8do\h;N0feo7;3]jV\`YJ_55B=VJRC<KX\Y_q[]
On]nVpL0[\?:]>l\Q]koi:NdSWoinGMPm^=<2=b_;Wik1P=V96Lc2WNC:gZ7gB6_
G49K;\o^EDJcm>NWJLp3@]C9iJp86o7JM2S09e<3OYcJmgDENHmQaETKZc2cjDF^
WT1lGUYKOLG`aCXc8K=Sh:haK34jRL_pfCQdOJ7FkcLg]N;3UoZKHf=`8i_Nf42>
H5be>1ST<ORmV@X3KOWB8C5VRj1DN?2jSG7@ajFi;[LA8j^X<9fTBKjp_V`;>ehq
O^:N60i>NLo6d4`bNV6jN=PCF=QRQiOnD^B;@VhWAaZllU@BZH4De8e9`K:YR8[M
oD`i]DgQY<[lp2Xjie`Tp5aTm]3PhE[RUPmOaoEe;5@?UgCU7G6@iKDlg6_>=UA[
QCQ\IVQ33K>T:78<a[\aZ=igKea412S84LnWKlhKBAEZpTK9=WK<qIimZC[ZW80j
P6cmH1;_?27BT5abQ]j39o`<maCoDW[dJQ\a6S0Ji2MLG1dA<<n<L1`d?a>;SE:F
Xq\PSB?U`pMBm`PKHpkiXhZ:oa7G8Y6:eNIPaqo>j\=0G<dJm6a`<HaIABiHY4E^
BQObSl:W>9=PR8?TZ<TBc8J6Pg_0ROe78LgD6je30oU<[=nTS?UVH4QbUH9k8UlU
jWD<DmDX@GWRE2?N:a=?e]7b3YSBT3GUoP>8c4\nKYJBGfGmXZmdd:abcDoQ7K30
9i;BSeWST4;8f=diEo>C667je48hJWbZ`hq[\\IG\Mp4P`b1_I6<kf1QoGXcXAR;
m9b0_[j`>LPkb;Y42Yk8bfh]Z6GPfHTCc8jg:dmoo:RPhE0XPL^E3BHSN?^c_HRc
ncpC[eChLF55mH4nZgjYdCDbB2FJLgFlJjI?Km?F4<=mU3Lk[?Rf\Y5LbkELXLiP
mhVd[;=1IDeq=;0EY]Gqa\GVgPTAZW\>O33?hAmfe]kNSgQ45Bn=FHD:Ke56d1XU
8CKDK3nZ;O:ZWN=208Th:K>6X_kMZX\FHZfnqS3=a^m=pH4fVJ7\4K?X6S=;3SQI
GFoO6^6B=5Q]l_T3SDPUHV;E[I:0jl8J5oDQb9gVc:jPR=`j`KTW38e\T3[PiCgT
\fSkUnOAfZQOfFCLh4MaGij\NPEYT]fYHpkFm840>6PHg6O[^9;d40K>ZH@fQ6GC
CM_Gi>dGc<W0cT[j@C77><QC0T1Lj4I69O6KXJE^dm>;g71BO_1B@B3PkhF:AMO[
Q4pTXL9g41@og@_ne`KdPYqX?\onb<pKI^Jk2]1SBQiGHjVW>Hb8?06>0L0ed0g]
R>f\S>ZV\jf8R@U6O]`eM<m[^c=nRgmqjk7>CLKQIH]?cJ8g\in<jQaSf2IVZeNj
0[1Dc]ajdQZQ_3=mW4E@G9UDS\8[a8UMNCTMY<=k_HmV7[e?qGSDfJ6kqbOj?fKY
pC`8fV>aUl]1K[YNA0[c4^i^OH6bNPXWl`=M;?ZGC:<oZP_`mCnM=@P`J^OPW:R7
JnH2iijc4bh_MXES]b3c:jnhOb3ET?\mXTN1JHo1m:Z2bKMD093TTQanGijEWI3l
6@hUDDYao4l7XRa56[357S92R\R7jA5W`^FANdMW2cUE:5f7B9AY_Yo2X6Y8OqTa
?lEnGqmj8lSGJWGPbJOo66>TOmkjI]m@CZ[b1cmggJ=SBW:Q^Z`c^ne@E9ZZnG^=
Ij_l4EAhdLP7YMAc[]?JH2>A:XknhqP5MVL^fp[RWekk5H216MIH;fi3LY6DE`\N
;XhfSec198h^IT;@WDP\`N39D^S@CU9QiiA>mn]2ME@Ymke2?b@`dOp;cj9Ll4qg
URKMTQ?EX85iMGXW_EC>@k4b8_;<\>5aE=jqKo[5[hX4Ia54lEWn[`;DUXXgi1o3
^\ma?Vf<7E4o4DfM@mllAA:dT:YhnYf2Q7DZK`Zj3dN78\afTa83cKSSOM2S`f>M
?O6[fMLaKcW;^P4TM>GlOgcInhpoOBNWIm[OmSKIV>Zo1^lke3CkN1dj@<@lU?jc
]3V^SQ>^TbYFk97lcP66hog77SGfS80[Yjk0W?@g>D3OOW12h9;d=dPqj_V:U_Jq
U[Qd^d;eoEY11\FMa`lV<K0eoGL9URaARFFihYXIX:T7LD>gl>905fd_Ef`9lmEL
;HF<ec02DmPO]EM1qjFG3m^aq_HSCLB4dJkm==_ERN9pn6IHj\lqe5bAT;7K8cl6
K_ie=Z?ZD]9NL]@6bo5a?089Hn6H?U>nZIPUDehN7ERo5il]f;NC[3Zbb0X<D6WQ
BMa4Z@L2IVM2D?5=_Njcaf@@]9]Q?f8?YWI[fBC9Uh;AO;`Fm<dUlH3\nM76bCAP
\8;:T@<Vh4SEUn]Lb:5ERnk\o0\]67ikNNYCfUJVGO2<Vge`pPgHVNmLqDC=]Zb@
ga011R5IkQ@5FTV1m@g8C[HN<b3V8@N<nAeTLRMS>F:4o<4aACe0iPdFJDE@NjRf
_;h3B5a7RJ:RQSX?XbZ93D]6;8[5_CJ_JAnfX;@f0ZQqmlPjj;f\ZiLI6b=@[>Md
55KQ<`nO=SiDRh<b1JWNO:Z4]aKTCTC8>cLbGJ[[g@6Q:k;SOYghNI>nJo[27Zof
L1H?EQWp1Qm88O;q?AhlK]`bj;bSV07nH<kjkkHK]0<IoPT\n];P8g[m@jZ36WRL
na>Fk2Ym6WJIofD[GmLQJd6]2=ocT7q?m\]RnQpgKEPFan2=;`o2a]VR0lp6=gB0
@nfkb[g4meLYn3nPQmWih[eie9RH0[Cn?WCQdM[1m0\0jWERQVK>]co3_=;XKd7`
C?Wbha7RgeB80DqLGHJJNlq[0Yj6h;_1b\Wg11ZB9aIfg[c8OaDL@9KDb_<\g;2e
nT]MOnhUL_Zgi0UE<Rc]MiP:SlDBAMj7D7P31qK[l0K2?poLg`J]AqOeUH67`oXn
OMV^G=dL;W[dih6MKJ90m]@@:NE7J`YGJhc6gnlYSLH:heYeJE;95bRXY4miA`TW
JZKE[S[SOE5BML94AWF1a1KkWT4C3gYe>lHO1[oTFXCNRoe1UbohBEMOfU^5`K_b
AWCPLPJSj4TjVCU?TPo^mIWlTLD6?EU;9]C<ReoC1m<g[SPDhBpU:W524<^nPG`2
kI\jLeAkefR3E_FMN\_0JGDQe<:TR?IDHiBZbi61Oq<A6X@4Wp`a^9o=cQP>@3MA
WK]<3>4F;8XUF?_ENnWV@>=4G`F3I<G@_JRKEPo:9g8nXm>cQGbb_;R_omN\K8XK
_qXB@4Q:Tphj=D\f3N>U;N;4S;oMbQhjThLXA[gEea`B51[QEeSK_Z7QV?a03>01
YlHIn6Bf4dR`^\94V]LnQM\4MmnWqd4?jGPXpCVoggT2:8dC29O6AVcLTKTDc04>
jJScKnBYgBIT5[N1oF9WB]0]?hLB7<jo`CUUNb0f0N6Qlgh;`m<6@[KIpGQ\FCZe
FUB[G`V=ZRgdY8kqPS;a3\;p8^X5EOQ=eme0IPE_Ta_2_PWknlll<UB\3ZWmdKK^
jHlK6[Koc2Ii1?\cd0HjNHVXfBK4S;_B2>MF9Pk<o[qFb4E:b7qjc_X4\M522:N8
i_gn48P70aG_c9LY3FCbJlbEXmJD>Imh5_`X=d5<>1oEj7>12a5H<V\Plq1]NOkU
_pgINLUASqaGB0g?0q_XbfVm8q4GI89bLn@k4;oNQmV5jY6mVfR[_IGT^nH]heU`
7n;a>No1_C7G_UC?g<WD>1NNT9M:S\aKJOpP;LPCOIgU=o4n8m`coO4[ae>A=\8J
QQI@I[[eETdn=0:?d]<BMN10U;28L4HnCKI<<_le0\ClLZopZ4\Alc3W2_De952S
;ZaGOAPU>A2=V;8BQQdTI\5n7PZoP@2q??02;]5pGbNQ=`o:DNm;\omAh6EUlGGk
^MFgVPClS8?ZpK3[?b^VE;cKTi6dPmkEDMOeg@adN5]GSnccVo>VF=PoTH?q9e0]
FF_pfoSY6NSGb]fin:m?mJJMfXgO;5enAO@@=ff;<mkfT1:bc>f90DL<iGFFXnoo
=L74HK;?[Lp>jDLLIB@\aO4[1E<SXIS;2hoF0=TSSKT`aMLU941CWLAPEmk881c_
YY3q2ooA\_jX65?Mil\Gh3KJ1<[PE95JcVR4fENdn]2FK:>?p_f`9iRTg^Qh4V<:
YL_;<D=5]@=YKX@TA7ZTB`En=NnB1OD@R:hfdoN`1g^m0q[BLFi55<jdP;1G`IAi
4T4ldRKYoFkPLPIE@i2=Eb3GoC@ONd^KEbOZkhIDOVK4C>SJM>BY@bZ1m>MDiX7a
IpNSEMcOIpSK]XbGlQVfZ<;\<=9?UXNV::SM]>[@Ll7g8DSV_gk?Zi3Sp`fLFL9]
qb52lgl2CG[mH:6PGk8mWnFQ_oEj[1mcl^^Jo^QQliD:<o4N=Z54O3KHaHoJ_KdJ
TpQYoS@IEhaYPRIa67keO2ZM2a4>eiEEcWSJ<?h=2ENNkp2[NdC]GT:SLE7h9TMK
ZE`_RPnIYSj7=Q@3m5]aYeEJ_1HoQ:8TXh6Vh2e04VZAXUEDL:UPqXE^[^knJ7g:
e2d6COYH1ca1bUFXPkX4kMMb_7RH;cQ04`h^DYFN@k;1J]o79Z:LXXX_Y7Y6hJHC
?WHBIOM[J9a=9IF6PkjRRJS^E=Qki?92Op6d>C6OWqcI23T9kqmkE6OBP;KHYEY@
Z`:U:m<lDe8n];_ER:mCKAG_G`05nbp6C66bf5pP2oOPGa:D`[MC;icTkCJcXc9<
<P4A1VNJC\enY@1NH`4Q1q]@Z08?SpA20EhD4NLJH7Z[0OGm:dZeb5PJTG@Bc9Ho
@@nLE]>[EIfbngS;RmK42iY15DLc?;AI?RqZ=G@jLn[aXA4IoKZf5d`kVnJ7YSLI
S^NoncMUeE@`YQ<[T5:]iWeo:37Bi8I::0hAdqbBP>eF7q5Bkn@]=q\MkEc_@aLI
QhcglNF5__kl:VXQ_I;UBY_loRH<m3Y?;oE^kmQa>Q;8ZU_L4mCjiQ5F9gJB7Ib6
e21b\Un5T9XF84qLaC_1OQn_BoSm^hgeNYWD1o[m98Oijen7=I6<@O16l=:K9bdb
XAGDNEFeBXH_ORCeSPE68hK]F9p02FQkF>qPQaXdIZUod@T>DdlWh_P_4P5V6aC@
4;5C605HNR4@kO1K5`>AgIC;M\gJg5c^opHEY\3A;>[ZO7<j7HoDP50E6@bN=F6Y
2N242T^TGki7P8aH0l6>IH=54>DMUm1P]IH<ISpG`FHIH6q6Z0]meQnNDEXLQdC:
0O[U9g9qY5Gdi8<F`7Tl=VDS43Bi;V;7SOVKR^X7M3J>JmFK6Tk^QZO6i<[CS?8M
;73@aIY@Y9815MQ>I@?o2K;iHM9cj`F7llGlm1QHmdYd86qkjR=hdIqN?50eTdCU
?<nAkX0I;d1]fUcB:kRPPe>J7k[SA7YKH:M@^6ZH\HqeE\@P8DqBM;7U?<joUVSU
0m=ahPO;g?L@\]I8T6N@9^5Ool:\>[0n[j=X[7@J1pcD?HP[VEXN^Vc896WU=FR[
]h5B=j6chfY5Fhk4i][A>W6]gPc\2I`>j=d>1ACZ@pAhQg0d@73D?N_n\GXPVfoO
JfG>S2PAgMW8d6O;B0>clU1@HCPl;5Y2TpY`SFFO;qQYe2L9[qSR<d^X`qYeXK_9
JRNS01aIkSN^T>a2=caNT3VS7ICV=boa_ANTKcl8cAhDfk@lc1`1Ki<^DcETa[1[
\N]Qd=iOFhg;iKOnL>ShE=hLWL4;[pBNJ3AGMNH6iNCjKNdaJDP_;MYJ4NCn]E_8
Cc^Maqm7TR=_l6>gBXNJ9YRIDRBc>cHS<^OEIOhI5CS=5W3W41aE`EU<T=mmCpj0
[aJE`pLndE7j6qLGA5a7abUZ<X?P5A1`34Vm6OlSJ]:f4h?OSae1Z6W13m[UX`J_
I\q?>0NfNPq6Y6IkdRJ`>kD41HSX^KmScF06[\fHlBC_JT=q6N@6l<IFSOi5YXii
R_]EAA`h[WaEX5]N:doi\SII:FmhZnq`<oj4ihpXZAiG9Q^PYYZ^8<U_i4AA]]>S
[1J^9lb<HRF4^93cSndaI^][B9Qm22ZI89g\D`UdSnC@SpkJ?4nV8piE9PecUD>H
egW=gibmO>0YPTVW?[62GPK1`_;eeg9nd@Z2piDc\\YIpR`XdmBhfdH>o4KRCP@d
YY[G[=eMqL9Fc5VBA@:We[ZB2f8A^1lLM84lH9m@8oBX2D2DX1cao^FaEao4N;e?
Vg6QS=dMg\Z6YE\X7pW\43gK_qDj<RA9EL:\nA7Jcc]FFYAEF0PhX;cVQKm6F5`F
`FL7nY:3pTHBdmAap;M=E774@`_nj5`HACjY[Ud4M[7Hibcca:QkhLi9A\O[`BAQ
PlCmO?l3g:Ki@c@mGYmm9XG1_CVHqXg]E5hJh7<[cD2VdqQ>9g0XbpAkQS=YEK`@
4>]aYVeH=fm^LdSU0TQTeYP87XUmG9j4XXHCpYBKf5^PpKPk4?FRMDT:^Y8ae8_1
Xbgb]A7=:f^\T@EEA9H\O`O\K\LELDS^P6H>cGUVN_4NcV][0eQbE5g0q2YV:gF]
piSLTIX\pV7`SO8>AkCS7_FAcJ@kUT4>YKWbU?NmdLg[:jHQAY=YE:]TT^I7BpO5
MbK>lq@FAG4b4QYo7?@:eCmIOOQPffaOi8>0RhmT1f[IeHX\^^NGqHGhQ0aI7\7J
9kdJaiZY^??c2o7^fl?Li4>aJ1V:aeW5Zpd`3Tk>=q`oD=2AIT?IT8:9=\he^kTQ
Vn98G?F87nM8229VhSDZ2i=o4m:R]^ihNd8Fa\iAA@mB7WLPg@RC]>MY0KIQpEZb
1Rb1qHS^;C:gH0koU28WFifFcQlQ`aM`GHK_BG_G`EZA@PZEh`Dq>Q8E2c4qgOoE
^9Oj44an5;dP][EH_Eh@USSM0lA=`gODAjl_]6YdR<SIY0R^L>`5iIfTC]4fJ0bc
=A2Lh2SCn0ZNF4pX3jQ@\8qUW9Yk8@KL4?@e`[;2^53IeV^\JXmW3Z0@DS84hO6]
4doR?p8B9R?b6>ac99CiP:K8LoRD2`>DCHNM7Maa2Oe:b@2V]OmFkRYeM@bdcnL;
17R>79qECU:G6\qn@@_UC\i58d^D:Kno5<WP:LmBWM:gI@MaT5RW>G^ZZX:g;1Zm
F`2\@dnJhV<Y3Kb?aoeOm\l8PEEZTSl5dpn5NSFA<q:OY9JE?pfI3416C3H0_oS2
3UhmjYn<^fgHe28Ze]e44bTL`FDAR854\Vqa\`k@E:q4e?fn^UXCG5;2EjcM\Di]
caX2cje;BHf6Y_JoGlU6<R01mqJLmJK=`p4j`LP;:^?0;PV9GVmX`o7MN9MBGeb\
[<eh]j8m<aBA2CcFXHg1PpO@L[5;>eOie]:WZpAn3IgEdq@QCQTV=C<1=M?900a2
ok:f\WgWZR;n5oegdJ8?6:qYo<HYE6pO^>9bH1p`W^WWF^Wm@2<XcT:cjo]Z^<FH
mj9oHd2^QZkJ4[MADoA?^p[i1aL]_q>[Zk[6F[Ucel\nWV6nFY`P11Fmm1Y9A\PQ
Zj;IqQ];bN]m:9LC;0e?4Ge]ld8;fYWDgh>eG6<FLAi<SGZ[Ek]GQh[k@65l9P:[
WU]lFQ`lIq:kK6MS2peR?8jCOp4JI56N???UeM93JYJ5dL]<]:78HYD=WMM?SB[3
I9F6dCfYY0b:?>jBgMHkpH8V=>2]pc[@AbKILgj_8OF4?TZ?RjHMYTj1X;^1WbV7
Q]g[E7PT]6Qp>hlb`XahH;Alckgp]_4_VL=p4MHkAd<]`\ST[BUXfBI[MR]k`\2<
;L?\N0=l_U>:@O>ZACfbCQ@:5ba0Jk15<gSl[4B<<5K48HfAUc;:R01;[gWUK56Y
M]C9>cL53b<KKfD0A@nP^PnCZ^poJHee:7pUnIK^YY@bNF7N^4d]K8T6>jTMVeN?
hCJQW6\c0\\nV@RP`qoWgUO4Cp?n\ce0N\cQgVNDNT2IM@kQ;YgFOih76E]h>59N
CTQ:CT5EPEVbfECK4j?]3SH7=WdF6c_\SCqKG^<>\2p6H5\f>2jmW0jHiReHDblN
]4fDRQ^UW2YG:=[4_>ATCaTWWqLaWkT8gqCE@mRVjYj[Z4]@P:4]LZ5MH_WAf3oZ
9<\:QqNU5H?REa6?;JMIA?;Ng>M\a5\LF\F2H`09JcU>0`L_@G3m;h4E8_ka4P:j
NI43JV;IFFTjA^\7bN>AMdNclkcH`J=Xhb_ji@n1Q=S^T7eE[k?c_Y4ZJi37>A\0
2pO`WJag6q?I0\CikpWN1]`1VXN9\\ejJCI=dCDB7anKh0<ZbdmVVXhfCI<=V?2c
C;?0S\ZfdXi?\4fBpZRmMZDKp91f[6NF0Tj^M]@b4[=LmA3Z>^RYZ5Va1HIfmB=R
[E8O@fbp4=02R7XpA03Y[Q[A5IN7FZ>K>c6loN^\RW28:MY?C?AKJLYVU;]N4=ES
3YgV0IbGY`5R5SB;VYZRfZ030DS1dj1K_h5:Df;ElR<nV6F651SXHOFGD60McXQ;
EU:Ra<^b9U=V3JqI;8RCaPDe9cGQbg9Z>]o\UHf3HX[MZB`b2g_b0p0=F3B\=qHk
cKKjJEWiUK^7l3I3TbcYOi5AEaG<<g=b:^NH0=WhDhb?qI[Vn^:0qWUYkM`L=cG3
?df3022W;:97jm4kQ>O;M^g]@7YcJ=l0_1C^fbhg3_0UReRnM;PdGn[Rc?765mS8
cpF@Z\EcApe\c7Q_:q6Y9d0QEHb;TBk^p0<XKMi6p^UkHL1TZGVnVJo=CD:BVMdM
EWkGW8i=>MgKmDF][N2^jT>eoT05DE>TP;Lc0gI[m]RgQmP<41m]go`C63\RcnUj
m=KL6pjZ=I]i@q<Fen=@?YljD6EYGaH@3Z?UV`gR[KjAO\dfJ`Dj654]9_NSTkp6
MDfPHSq8lCEg7L3:Gi4B0nU48IZG\BKS9UO=L<0h1VU7nFNW0GQUWN]Zh;hGMOjJ
Z31IaUC2EE9SePH^TdRX41HOknAf0Lj9H;8qW`0\7dMTdId;oao;G3>@6kEJd:`@
QEkMSRAXiB4H=lAjabaoBXO1p2AH:_Z]pU0UlLHMEfNg7Om5Z_1lECn7YPQilWL9
RnE>ji0X4O\V4K6D8pH0f^\gSqd5Ti_1i>3c4[KjLTYd_W@T`>[dEo0^cOjiN7GF
e9C_YU`LV4OB5mHhI=PDMUJMhWlN6bg?Y\LjaTo4[JYhBHnm2pm8b3iX[q5\mD?^
`>nVX86KC3WoTAB4SEUY;In^elFBk:AbGkE`ZcG_8?7kcaW2o1X7lqBL5U:B^p@F
1FcMa]1MLOLJamn:K3nC?KRLYd>f`hTI<T`I7iOMO\EOWC?PVVcGaR[m_K3d1`Ah
@aZCUe:1_2OGkXUdbjTN>9p__?EaWmbAOc>Q7g?L:QAPElZbRjaX8SjLm6MOi9;M
M5M_UZg2AN@j0S5=AD1qiHb1eL`pFZ]SEl6k9BV;9Q2GTC>?cI=5dGn8UB2bgFYb
aF8IS4hYD4Mdeah=jVnpLW9jQciqfnW^4g^Yfh3?\hH4V2RKeFnPNlLB^BfHGB\k
SYXWk7I]gaZUAY[f2d@L5g@964A2=JN>2:PQ@I^Epg52iR`@qES6HHdXqE=_CgJ0
M5[<oaZ@5`;_<KHV5h[HGIa=aFMS1W7j8Ogc[<A68<ZSCZ:;oa1>ARASOa`@HMZD
oK8qjk^PfGiZ[4=k:ZN5d0b`AnYDQPIFO:lSd3;jmZancg`4I2<5NVpIAU\OMbXU
ZELiXeokH2gmQi?d6jo\HjA7;QBIJR[93GL^EacGcELn8@AB<Q`ZYm:84e`W2=49
LB9FV_V612gmj0ibhqHamQdPCJ8IR[D4bg<13WehX2GUcT1UXd2RbOhNT?LAa^`m
ToZD5RjnH[5AICpchCm?Db>LR9E_CE<6M3EZ4l:X@g=kIKUZSK8]L7Y5WSF;ZRKD
fRoCB4]8gIg41\mcUCm>i3cMkO2^X^e?G3eJg[aE0]T:H@;61q5efU01SdaXFSYM
KCSHjO4dlh^<cTqIZ``BU5UD:9cgC<I5?g1N?LM@G4FHmhJ7ElHj3o17?Zi4PbgX
6KVT8g1U[nOC5lXe`M1Y>gOPIQJNV<Ioc<@7>4^3kHGRH74PgeT[[?dMRgPImVqI
oGXZ_6YA`IEhK`d9lPMPFYEF[XqDGRB8eWPffD?l1fI\:_BUiEISR3XLngd4mL[l
Y1NL4E2Q4][[3HPKea`XT]Ch\j`\7gFFehP7m_aGn3g:X0Lb>8\:]38<[XL]Q9=V
?YlFhbK>NkD18XG]U[Ng_nMP<pIO^?YME4L3eiTfgZ97HQ>mq@YB4QNX3h<I4ieZ
I96HNk3ST^gn6K1f`bBS@0[I0NGh_gH9JLU8l0m05f9KOmbF@VQYZS9<3XkES4aa
B9M]TChp1k?_1d\Jgd;KXV=FC4Jc<N:_@6ZGKTRZLUe>Y_C>73C0oUScVP50X<iH
7]C1VWn?[bh0iVbDVBQL0gnZgeJmecb1G8QoZdJQ5?>HNab\8EU7_YQ7flHd8Bk^
@dkp91A6XEX^S6KE=gmnPTa>ViPSOSMWYCHO1^X9mLhQfXC`j\]I[ZUN7o:TlNLj
1ejf2f=kk<e[NVO?]ohV;=8nqi3`m@b=SR`oAIY`pkUY\?j]4HNSVVCd3KOIPL?G
b?ng4om1OPiMD`gId`i1<8S57ghbj:2dB>=:30U:^NHL1IKijBRd^V>igH`VZClh
h]EnBT?lJdK;`^jdfAHXki@hh`Q\1[10Q@o>[0ljA2lqc:7?\JlEe6_^PJW3OhTI
UA4WLHdo03FdIAP6?f2C_A]IL3RFFi\HW2Rjo2^`[Lfd51cR7LLlFilg<]ccj865
miOfpmLd03:?6YjX\4hLdT3iJ<e3K;[;2fBS2a[LlUaXDP^50_IZgS=V6Tb;A\om
k_GeRU3`Q5g4D`cIb4P2iGXo9Ac^b7NM]CA;_jW6?6F?a5nU6GA[`mA?2R=6;7gh
oYM`7[TZ:U:nP7CWl`3NTN5jRK4phAmCNK_29_i0;G0cIGp]KlBTjBZoVcQaf3cG
F1ndKlG_0_U`5?7ANcPBQ@IW1WMA2Li9]Xk;ah0;k4kiTR3LR][VGVOmU6MAf8@9
WJN3UD1_?F45OUXhMh=JZ4Dm\WEY==hj_dS;JDQWJcGTRV0YK;b[_4<<o6Ll=J09
XmW1[e9S;JEpncEl1WGT0i\aFKIoYPq?WT4Db<E[oeNjIRoNSWWJQlc_U8DfHYZ<
^1U7gCVX_;SSVLkg4L\fM4g_0L8MV6NZFo9VPLpQ;a@W@I:=g;4Y0:L\]Y1Som4N
`aLN@c\MhL7^f>?Thcqc8?:_OT3Q>;04nKEV6eZD5848I0XFgOKHc=WOT;dNo589
B6h9Ep`<B4NcYT8iTfUFLZMVoULV4T6HkYaCI=[nMKQoYo:Zn?J]eR8WQfERnF2c
q]HN^HZ7i>DSlFJ;H7=i9JaHm:<:dSXkMFU5TP9[U0>Rg:ZlWkk0D0kLiI`YGKf[
;aoiO_2fem5\E7T^IX1fR\Qq`1U\^AdN>XU_b4^d8jm91VVK^9W@qf04QMeAVF7C
BG77Nf_`HZ_Voeef[FJ3YP34ml21P?Uh9DS_IO?4j>4C<=Bi5_Z=9Ic459BAlF7C
BG77Nf_`HZ_Voeef[FJGc`3VpNBiIdY\ilnZ>Afo?5DLh9MY66J891=Wkmk@a4[G
ZZELVo7aHN87`<Z08HLFPamek]ZFm41p?cAklXe71;kHPG02_33TTI=[Lje`q3FG
5N0JH3BZYHkjnllnZb3?=WJN_L?P=\j>1[P=CYeLkQU=;VE_PelKf@YIoBABq]2D
jQo_0IGZS<0KQUVkfUocA8[^l=VZLgUj]aM??>RS:T5oUI^8X7FDTOmi10b8oRCq
An86^VIHdB9E^m?J\Gdgn\>a2=m3VX6DmaZaT891CBQ2ETfZDH431NMYhV9P@k3h
]h6D0a<o?3gP9RK?D;CWpQJnoZ;gShR`T;H^6mS0_NDUB3A6\nknKQ6RDO<EaS^a
73>dBMNiVZ?8\`BCAVMKYTETTq8lGmX]a<^94N?onkm]qJVaSNm61CMONiI0Q<kL
e@6\\Z>NE2MXjlJkR5P16nDT4ZNc:^D5>k`AHGGN<^G6i@<9DhEd]CgKd_S]h;gL
@AnIGcBRg\@>iq2ROfmCdk8OnLLj]4b151o=]ARK6q6[TBVU?Tk7OQP?J\Nl[MO:
E<NOHY2`SdcVR@PTJg=PB>f1=SOEbX<Q2RmaS5NZfeDk]7VJOO007_PN\<\?3lZV
qgYRmR[T=^M3JUe9F1UIlG<1NElQnoSjB5f>^eBLCN\>m3b2Dmf\TSO?op<Fg;FB
4oHFiRK0RmWHYmBe@jJ<^>1V1QlW2`]]U7mbgbMFAUOQCABdP[6l:QnR3^Pbkacj
<XUj^G^:nW?c^aW0Vj3UK0P389`14\B>qbDIoUZW2\3V]`V^9aTKjR8nN@3iWLPF
a;M`ildHHj8QfHM56RGHB@SkGq2nQ_m`MNYFdc`e874?e?jVjb>>93ORfoHAi?7L
`ffm_1agCCS;^9l^mVhf`bHK_BG_G`EHGCFOXD`hC1jfO8go3?]hCccgE>0NiHHO
_?qmZSfe^d@XVmAomcP9^ZZ`8VngfJaC]JTR4hZ`_FBVGFk4K@EQW3<f]DYjUJWq
C6oFfmORX6EAaZmTa9c?S^Vcm20bAlI?eJERC\7fHZE>C;:k1XE4ZWSZqU:?almY
_BUgb@]AIAQmJ6>oG8?Td9CFRcb__[Do<B^[C9LiP[UDd1Qj_Gcjh6:57_T8Ol<W
G_3G1@<NceYF>6lq4^8BQT`QHG_:LgZJcN`9\9>Ii^J9nN343H@a_^IMWB[3VBBo
LFNY=nXmpK\JeFG`__oKJGZ:M4YRmlBGT0A@nH0<;ghngDjTPU;VmjE86Tko81=J
lB2`2YWW2HEoPHKW=VR?dTioN=;NG=RqoHBJ[fO@d]E8<[GE9RQLmbDKLVmedLA6
mn^H[XJ@`4k4hJG79XQ3G2iLpF?gTQGo9I`[5o2@jGIFS[`TZ67[>\eKJkVm_V5g
[8:=]]U@IY1;QIKMMV9aYo`1m9gHN9STF0E3KVba7RcJ3@nq[OUoEITUkAlIWFc\
`<cjf_MPeVI?R=f067qnSgl_gEWdkUoiZmEHWGn7N1SBWcX5E;WXX]_W^Rfd52`B
YMldIS=ET5apm>NJaaS9_N8@]lW5203\AF]CofV86<LOR6Z^JP;_GERS<Gjd@E^I
bFKUhQ]9>3[9m;TK<adcNjngOMi_2i90MJaiqDHcJfIF[N1Z;[:U3\<IUPZ8Q3Gk
go`i[g_X^cLn6DoRGbTB<?I5F<a8mpV3YY[5[cnF\gDA@:>jlAjdP8?dP9JJH:=O
4FTM3`36ST5:DoboTXVEBGn??;a^gR2OWU@d3_Ve27GNDGej9^:m?YE\5lJGCfRG
?3k9@JmDnmD=LcU8c9:9EDNeAbD9QUjXjbn09kn2EW=6AD[dhGngJNTZZAUg]Nfl
?[n6<X9k8c5N\URSqL9CakOJb3]2;NDaK_;i\HcQDOc8T7IVY?`EhcI3l^LXW8Gd
hdlDcnHi43=Lgd9;3a;F8kdLJgT;Un\T1AViT_ZAoe@ng]WFZB@0Ec=I:i11]VbW
G`7m:_7RU0U;Wlf;g4LC[>X@e336e414NgSnM_Kj]ab^3fWWMBZPGU_LA^adY`;S
Bd5RcC7VO:2Gk^3AdL9MX2ILq[<Y7@AI>aHDmeISE9<jD?F`k30Z`Rm\8VOJL`hX
ET^5mB4DZ\c5QQ[AM2cnXkBDJ[kPfbTC1MiV:E8=M0Nneaol_X_<[l6T<VEJm`4F
ZYTi4TOaW3TfH3Pco^giYaOcQq2@VJb\VJWmL]=;SfLe9EfZJMeEfGDAh:49FXRc
OF7lkRAD[6cN>mF133ATOE<GK<F<l1^4U`lo87=PDnYOS\f\Y>50`Xo[]S^N^gc;
leNiY0<Z\OI<E<bkI\gF`S=N^4PgFbCkV@mBHXU@U8pSBEG4i]`N=KkKd;PLEU`[
W8F1fi<QX:Y5S4<aejIe1[IP0S2YRAQi=]p6HcbfI3;A<n2m4nSgm`2d`4GcHP@D
@`4OFfD`YeW\lGcba1Em>>Li4MTD4@ZA4]6GAeUWd3;EWIZL?g>_aH8SI5`[9TX`
XCb^<o^TP0DS=i?bXXPCT0Zi]8dVmM6FYjl19700WGOaFBWqgmoJ_8NX6oEceUgR
`3JM37`C\bCZ\j]@;SM1<An9\QibX5hIoOkgcXPO:`KHZlai=Rg=_V`VPOXTKPk`
1>737K0=eA;AnS]SkckK>]ZGSjCUFf;\S3Le4<PP6ei8W]5HWeGC55R61KjaMeVp
`?M_IA<g=b8?01fKKMkFo=>>:Qg6Tb`D2kXIlX0eZT52TE2@i7WoKg\VQHV:SW^5
P<_5E?g@NB?X0HfVKG7EeWMN2FJRbDNRZ@<C;nc44NjdKL`Ta?VU:\HRIHV:STOQ
`@fU<FfqlK;3MOMGNddF2ihL5i6b`k\U3>jek2]<j55BHf3YW7mQ__AaA0^ol0^F
gN_JdgO[3IM8g6HAm_YE2I0;^F\kP?F82dH<2@goZ^5l4f7?^jICbP\OB3]1J1qj
P7MRe1<MCBIiY7`FlNO2ALZP3e9\fUi:gG8qbZR<c^F;nIj<SKLdP5d[[Pf;U<g[
4WWXa0C5kM5i2DinT]255R@D[H24E9fWc9FnEiOKAfIpdV;GSQ74>::DAF7A9XH;
iO=aef>mgE?1i=k<]6:^aC<E<3QLNBkq6o<P=Hbo7_Z?PePHcLFP3J=NenbHRU_V
9[SiNgG7fECPlamRc8gqOR>I3eXpSW\<VjfiN6Nl;diQ42\3UTbKCF2p8HdFA\9P
@0nXQHJ0\B?Ce>Q^=UoRn?;57W93[Ebn=7D;S6>3W<WeTdSp3`SI43<aHj<@9hiC
GDhCL`2pfA?`1Z]q?4f_1[]XZFC<@i?eC5;2_bHi[N;Nk@Mb_XfR;BC8A\ke4\h0
]N5^Jd=C3X<4Nnk>pLI8aS\EW>[40VGTfBDTVLZ;>]HLUaHB7Tk7WWcN\8@GoVkS
>c4H[>EXCH>AUM67aqD9`\4XXpX?3CD>P@2g4007lDV1B[\Xmmp2eda7o;LaoLf@
T>F6ZC0pl4@_P^bq\W2:nD^k=870BW@HTZNLKfg9IO=79E@8YIU:[gQYF\d@S5\<
ZE_3FnGm]d>HW_n4\IC@pUX:DieHpAii]\neNok@J:S:gE3M?mEl@V9V5W7pL]07
Y72qeoEB0l;W1^P[18hnCM]N^3SCRO2A<?F1SNYA4Mf8]IQ[g2fRmo4[dAkn9CgX
Xo[Vf5H]VLl7Ng>p`TMh2n]`KPEmG\n5W[1qO73i63\pdNfj@Sh:a`2:<Z;Ia7@K
01b=e_Yp_G_00>fp9N1_h;Db?=^POH``E=AA@e]YUaV:o<57FfYbnAD1W4Fll?M\
;g_aeA`fRI\^nM7mcORdY7bXe;Nep4U[bRb0p^5`:hYM1?XW`lmVhiHS6cd?b]O\
`>LVFATe[^2jlfHKDZGS1=l`O=7<paE_J>LRJ1E`WQHlIJ54`n^Rjp]57bM6ZqS@
_2b`jbg02[BX\EGh8?;TM:M5Bjen3?:>APA4d7faQiZP2iEOjWELYRN856UPHBFd
Rh0IEX4?RR6Q:kfCqdb>J@l_^Tbl_@Me;gT_SYMU_Q1hGbU:LaI\kCSFo7dG@fl_
9Dfn6P:KBG0UHSX;]X;n63EnqL49nb^gpY2=PSS<jQ4gI_Y3_fW6D51`dRMBEP9[
p@T<Y@3kp<e>;E@HcBMZQZlHnGdLlWL9Hl6ZEI6Z__KEV\350MX=Y6LAVU6]QfiX
Id`::X5JZklH_T_H26^6eZcWVWC61^MS[03^q1mn]eKn2_g19oeITC2:7VN;@7jO
GLmb<F]Fo]b@`]YFkZOoj5;IQBo7KW`BgfIa3A2RWeH4CGRX9:i1p2;=Bd:;6:l5
B?jlU_Aq;f5_4cYpmU8=Zdk\g>iDeNoGB\:28MG\q6Ag_M=8qlbD:eR4jETYL[Bj
3NJE>AlUhEcJYa`<Nnh7<T1_kLaRU<4Z7`QLQ[H6\OSQo:[?m3[9n7iCR`<;\6h\
jSWq^lUWDLP<a7\EoCejn<5PEf6j_DckL1m4nXWhnNe?aoomaAFfd4aG`6=hX>O4
O1?XL7Z6>?4qDn2KdY`qKGgkS;aNa57TP;X_Qb@;`[C2T<qFf6OYOhq]\V@AQVS4
Ge:YM\`m1[EC?SGKm?Peh7GTLo12G_[aI]bQZf\:ZL[DZDBUb`A<UWh6L?WAJVPo
ChO]c8bp^73TC9b45c>1A<aRS]eZ23^@a@9Sog7kYL:EDYP\bhJb^`em[DlZaL[E
iZde34?_EJ[\U5g=qKkaQMP=hoghOnIYW\:VF8AB36<6nNPAiMe[1da2GZlNAIAT
HAO59G2?LV5`aegGlFT^T6QqS3NaY\\pi0da=9Hm6Ej:ZDeR@oKc]7aVQ8nFqgL_
X0o7pScOScGG@L6Fmfm8o4CPE:T:4jF<Uafg14SoJ3XQf<0[9D1Q7Rh1N]1iJS5c
l0la[4[L<=kOm^4Jn\7mFH>:jC9q:dJ?CaHk[:6DH8oDI^X8:Y7T=JYf_1XAQbY>
]4?<0nk0cMj[Q>9bmeK8o33TA7JGYH@?JaNH=1Yp@\1>`60qnAVMjR@=SR0Uo@G]
8j5`QMN4abqaJ?]Q?aS`I:nRmSWKWailDlM1nV:5Y5jo0WED_YA]^oI:T0Z[J?pb
WEGEKFqAfPM<D5P_Xkj6]@9`hISe4EdifZF6K^Gc6\I1=:K]D6Ad=f73V56O:Bql
M6okAGpJ1A2H4WDnonYjaHGD>2e0FZBqb2mUF^5qj2bEBD9\PUhd^k^;bQfYJimZ
57U0dEX]DJ`?D]mq=i=2N6LH\AXl5;3cTnc5i>lO6am2UUgkXS@m^E8b=MhFhN;Q
=S`S^7ED>8lN@Bp<P@32DepiBmcNTGFqbdka0:iqa2?67FVpU2DT3]fp6Q:5Z^4p
Vb6S:Ohqoj>TCV^G7_S]kAlR_=a`67KI3Lm`U0_cBff9]gp3631DechU?Ce3]kIc
embI=07lGEpCOHOWKSF:IF9DRV>NWRT22YpXh7K\NGqPQB7M\F9akXDBDbAOXS5q
YBiW<5k8POH_Z0LB?<6@4TMfa_A9Z[3UJ`?=FH1jl<O5_@QI]i_=Z<A@33]0QOgg
EJT\l>a_dVcakOj8<0n`T8JDiBAdj]2QQ\dZK3Ib1^2fpT@n1OOdl1VifE@C1Nj^
\^DPH5<>caT:?h52Bn:[FB1:F6ICDBo2V?aDEmT@I=Sn0qU`4m0DES]@<6oAXTTh
I]Ec\eF8^\ZS7RPGHU6IfO:MOM<Gj4:ATB\HjjMl0;>ZZ?n\@c7iqX73[MRe25PU
Ooi`enQ_Xe4@DWNE2ORV_nL7n5oN\R;O_U5c]qM?JWOkV6ajFXBP=Cc6\V35OVlg
ROk?5ST^9R3`UZi_fX]D9oc2?[^Y79;o`<\<=eWHmU`aqDfZ\_mgGdR4j:V^`Cjn
51]o@@dJH3?@P:?PUfe`=6HE4FZagR_9LQjEgqF6@bhWP;073glVCDX=Se_Uk?@H
O=[JQ6eB=g?ICL<39<0_dXWTc4_@dj3lR4q[5l;gTnlH;4M?=WUmn;Jk37jkKDR^
H>\T9@N?4j6Wm:QEAleWV5W8Q9VJNUKlV5@Kl:HeM[N^=UN8MN3d`\q[;RD?LAq`
8cAZ9G0j3k95K4CEDhUIIBPIl77;LV6cEmp9>JPE\XNYW\<Emgh0U83i]HpEWY7P
IHqIEJB3Yk]3d:6jSMM`gDTPHW1I[P5Qg2:J2oA0BEWeVla4=kLc@[RXPOk6>poZ
V:NC5nmGS:iZf;N]GlFAAU\naBS0HB\J;<<]gcBan^BnN[3I\jUmW4ilf8JJq4NF
0oR4YbZEO8?4[>RiZg9QCV7WX;n@7=lf4VdQ^;:CI2[C@U5ELN9kKoo;q75Vn2;^
hLAZi^j?EYaSDMS3^PYm?SDlXW@ScRKTWaM^X:JSN:NkOq42``EK=pfh^Sd`E_eZ
C1eVegX:YGpLIYQK^P[nB480`S>=6]?e2GkD]:DfmXP4Mi`OW05l@=AmBfQV\`\j
UQ_[9>QPEp^M06RgCp\6d6FW9\codO;eEQ=27iBU`M6nU_IUe1oQQH@hMNi78eWb
6gI[1gO=^mJC1NBS49\eEapRn=AoYnqo8L;HXbkK1G1US2QF4Jm9`\45MhBqJVE;
P\Mq<dW:>ZjIiF6P@52Bo<ECQJ8F^958KH>Kch31UIH:?f8`_EY3]i]S_OhCL2Dp
l4hb6D`q<[IACmNj:;e@ZIJa6_OU\`8X[^CIa0VapNcZ:IoY2F3e@>GASdId4m`6
SX8=]q4i_iHbeq<6eW;JClIP0E;CU_4hP3CYkBJ3I:miU;J`WHT\>>GeaMN?5<`A
U[XRP`eY;;KleKIT>q_1JEIdepbg^f3e==gKTQ@ERYR2;JkJ:gpS@H?Viop0XQIX
Ceo;dT[gVWm6[^jdEe=LA0<4N@>GQF\7QS1VA1p5<bEjk;ICl:;Jo7S5CiYRo\:2
=AEe=cfpblY]=:4pXBb1K2W<[4Pd^Bb_jNGM?Q@AnEC1`HQ7O=D<Foe_e\J1b2bN
[fHEP;Kpm2_^D>bfHJZZCa0F@[]jhL2M<o0;@V0cA:ckC0N6LjWc691JKXfmMl1q
kF\0OB:pee;9iUQW7:Q`Te=YD_8X<N]ZLE;@cJaH4R53QfJhi_2KIAA<8`S8c>>8
@<NedJ`QeD2JpO7Co63Eq16`64]8e^[=\I?=cARNQ^HX>Cc=>_gciIhqfn?OH2RA
_;Zd;Uh2ZE=ofPY=YIi7WjQfImHB0]Sq_?9R;`ZqdAVf7I9A02nKj@n<K6A74]R^
074V88T5[hI108nXlFFCa;4fUn]JQkgEV^]49n\6m1;_@P_;0=cJM?[MM7n6>O22
dh7jKA@<ak6D<8dU\XW[nP=\`lBbghpeLW0G=L>HTE8f\\:\Qb7\=6626OD<Gc_j
^E2RJ0FQT370HgeMC_m2Ah4K@5U\:3ec<64KjXh7F?[79Hb?hE`8OSR=U:WVW^l`
IEhP>9o\?4P`^1NbFF;X76;\6iCKU3S2:Xpdkaf6c^ZamaFT`7cjj_MbE8@gfebZ
bHjDcjY6EHEl:8dkb>kT<RIn0aFZ7c_AB>\<2`:lT]IAeOG6\`D5o<iJkgcYDQ];
92GeD9=F82Hc2kUgjX[2[L8>>:Z`\gpDHL[9E8]Tf]Cd<i@a^98lRl?l7agZBqZF
n<PZTp;U?DHBm8h7:O327IPJGKo`j<<7>n?>l@mPX2i^qZRP7g6\q9U:SA7X]dgn
k1Yb6NM6Ml^0T<m3E>m>;P5o]^mY0n<>pfMIXDZKqJP[6e=8KL[]>F?TTcX0<8nX
WXdl1O\7nl`l]>fH;\IbH;F^^IgIDSfoBn7chiTQOPf`6JAP6RV1cPBHE:SD^^9O
gEih2?V[nUEc4Tc54n:ad>gC`M;G09iQE[L8ZRTpX;d]5C0bm;DUP;mnl`ZI2>3D
@`^C\a=Cd]7G?PfNm6`86bP]jJ6NTgB6Wk@TOM;LXNhNP6mUe^S2KMm1PHY[Icfh
A7@Xf=c64LQn4F<O6_`3`3K><1QD8dF<0b?@Z18^QS6:8ZA\RC=q6T2lZncqn?b5
IN^pCR0=BoMHY\Y2Z\q^D2`2Hl5H66LQL9KCJoicPCbq\9a]\YJqlXdV^0OU6oNF
OO=F5flkXnUIa^Om6069lUB2fRf;SdDneJ;fafIn3?ekAG]F7aq:HcheEZqd9c;H
?MapH8Bh8aApWX]Ej__4RklF320\O[]h_H>D[GkN7]cqn2Kk\KgqoB^d:DSq3Soe
89lq1O<6eS<_ci>ZPcPIhTlOFdW1AVOVL1C=Mk7B6_\6U0pn@`GHOL>m:3RG3`Dl
H7DPaI1<b\SG>ZYp<NWNffWPNKmPX[R8HXhE@Jl4cAa@dYfA8j<h\E3h]bpjHj@5
GZUMl<k;4h;G45<@X>>=YU:o5FdIjMoN:jTU4]4mgUkK4qEcPVoi0q5QUD5>KXAQ
L6bLbgFcl56aPDUXd_ga5`Ug^30bnZQ`cDhB8poIAHkLgkE>:M8mjH_b\8iLgG9W
BW?JeGk6dXWam[_55fgPYq^[NXGelJQnkCTOR^;4loPSH=YN>O??dkCe_F@MY7W^
m?dZWjZ12NpR`95iPMh^l1XRYeUA_SF@Rkl_4Tn7o;@?8`kA?0i=0;9i\SbKPM`l
7q53oo\8gcZ?bn3jSa`dHB2_XTAT1A^MXq<SAQWW^OD;MAM>M<ENjEN3Z;MjWJ`b
c52_2H=[lX9I4h?^ogb]J3@mD@pm:dEIY\6bZV_LEQkOh6B514>JOV95dK3RW`Z2
8ZnfgNBhCLEhWn]42p>PBEKEmqX;1SRHmqK[BUXFbqRkUliM=]MH>mH61aFJ\UCB
0VHJ\]b1gUNT\GF6>pcal]B]Aqh;C3X19F<C8g98UTPGJ3O;HhWA[Eh@kB0^31Ak
;cTA6VaYmq8f0WhdW7iXfm:>E0H=JX?bP0I[1k?m_D2Tm]b`I[NYbR0CILD`1p3G
\Y1?]1nVJg1_V`@9U=>F4Rc@RNB7aAhdL`X@:kI6F24iEpX@CAihI:RJK]9aCGJ^
4VD1ITlFQ2?YajDoV6j5>E42QAAbf;a]Meqh]><_`N@\bYPigPWLo1e7Mk;SLP<T
9MdDCRf<B:nIfeU3WieNc5l3Yp[:h2hX=REg[X`bN]L8QWNRm5@TWUoA2NZk514l
=m]>>\Y[\mO?PC^23WpV6>lh7:[3\5@iMFn4d4HUS]3XKEJ<5H3a3iE0mRDfLELA
0kJdgb]07p7\`HnIHpC;^ZnVfWfZG1>5D6M=Dhj=lcMLlAWOb\kAUl7i?>N^NEE1
Hn=_8K\0UqAIWeNi6p^75Ea@0W@ldN7LFJMVH[S`f`mR=A\HffK_Vd[B^EOXKLTF
M678Flm8]96>^BUnZ2kSXF?;eAJM1=fdSkdnkLpa]chkgFGGG23PhA?g@R_]Fc>^
h2nbK\gT62cM39n=knA<N\:HjS^UOE6T_]e`f5<lUF06QpNY[4IZH;ZTfIBTgY]A
HJKQSn]1WF3l?B6e[od_TZ2R656?<glHo<m3Vo^e0MSY@jURdbHC6ooM3\QI_=qo
1VW\i03Fo0IBM`fh4CLIV7nVY2iZEZXV0i>UGa@SDkiV]BIoTW\J8MOMUB4UR>6X
2Cn_?JpU2b5m[CqYc:m6oKa;k^V6R7BfaEdpGboTb^5jBQE<X6RM=HI_ggEbWiV>
]4doUcYW`Cb<XV4ERAGqZlXS>Pnq?EBe4EoplcQOIjWLhJA_jhQnLAPn2MVc2CCN
1MWC2Sb388RHcPBd>X9U2@[V58QBCGNYT]5DjfDLqk>5W@]\qN8nB=D^;aOReigT
=HbJho?2_?jMG[kdS<82Vb=:JnEmRKdOqfcb5d]6p8M]J30kIf7?>0f701kEnlSU
odmSIT^:>_9YD3@o@UA?_<>M]<iW7T_mM=a\`\WN[@2nZ^C?CM7=k[f3Ae0@03@V
Hq>Via2B9Xf2lLYZ`LcJhnZnfncoIQIoGj^F;3nl5MfoW`o[6Q66Mi1c>R]CJX1Z
5G3ZMT>CZpO@6HkThqG0_3gA`>[hK`n5T8NISGoZLd@3k9jYmeYBh;HfDGh^g?5i
GqUkkBVE`qOOi4I1VdX1LEZ=d]f:dD;[dI_ReM>k;QOdj\_3d2YgWqD>5FW:2pD>
QD12QpNEIBJlLdI3RiO=G5E8UhPUl2TZUSKLgJWGNo?h5[=7SYOT7p]Q:Ch]MpA5
if92P7aI3d14]TLX_BRnTPkAZQGXSVj\>4Gn[[XfbcV<m=@20lp;gZ1\DECSloi[
d@l5iX7A;e<YWNWX_gf5J\DnFK\>TH4ZFkh8`n:j_pa1lKnU=k]JjHb1^]3^XcH_
9k2ESb_nqifPf4R7g5Okbojn[8a4>>1BILZHC<?hf0KcSHb:i3JiB1DigM_V;VUI
Bp:9>Ma=<U]4ZY__`jA\WJmI07o5n[;Rm`cY4ki<2lR7_mL?63b:O]:gp@137k\1
q@^0<fmIpBfWS^cjT=Bm::h\J3WWG@><:G:dLafC9jXIb=Ul?hgqN;6T^>CpJ;P<
:e_ZoK3P<dITj=<FD0IC_1B[>N<BFZSZ021k[EDMLO3f>8<o`Q\NN8095dbV\9io
:YYHEL0ad67?ZDM2:2GU@H[Slm4OPISS`1>M@6nbVDq:DMEP0M:BJ5h1d>[Hn_V4
0U8b>10>`Dl[1j;k7NYj3ml_\I49_WHUE0W:[7mq>4LfZEHNalH2Z?031_Z^n9LO
]b\i2hO>I?gA_e@mIJQA965iE_kaNDckDE1A=4?h3XWpEG8=@P]4i\gD<9[XgD<M
YXYB4j9n4mqG4;>IcK;gJiFY_V`<QeI[^]I@CX6DU16D7\>?onM4Z>e^8IEK:FjV
m=SnIc<LViWZ[I5FVKC2AVN@J2M`_5JFO4WZ@2;pV_XlgfEl6<>9Pkj\j9NL3B]4
QaJ5H2mUIIUNmP5C0105\`5@7JVh?Cb3>J\8_RE[khVac4hI\2j_P^l?NJknAkQM
jlQ7_^am@^1\YQ5W`gDTPHW1^[UEU1ba3fkLgKKLeJ2d^4R[HHUHPH=Q_noM\^kD
HQqnV9jl\SR>Qg4G\b1goC6XE`7GKR57YW?_a[>58=h?J\L\K4ALBUN3hmRK=^ib
VJjj6KaQAbCN^kPaa9gUAQ\aH<SOGne6@X7GD2RV8@Yf\RXZdNi\\V^@Kcn]5LSD
V:;EBBfA7naldT8KQ13@4:A@1p`=YUJ5QpZ188;cHIfDITO?aK4715VCBC;H_dY8
@9f07i1EGpZeoHF?Opm<<\iUDp29AQm0<iobd:>f]]<2@<X\in2hK;9afbdf9ILc
Xaoa`2`47JE4Qa?Db3EaIqW;UR5CT?jIRnR5oKL@o6g\`NaDknTMI:S`gDW@e<Z]
?oJIjQ`98j3;YgKHc[ZJd[`2LlR8fN2THQT=HcLn]ORVL\9O8DgY\\dB7Cg?G9JY
:Ch4qNLf4RYAa:?V`jEj\`?pDDg0[6\MJc]@8HIM]3XaQ4=[Q^il?J2M_Li]\W1n
Ao[?Gi@alI`NR71kA9na>BTcGKSjJ:6]gPTeOna=o3`ZGY==gS7<5VIOM^Yf_I<a
\3[O3CPcqcl3iYd2mlW?H=QX`EOqW]Ve5RX]J<H7;`W_IJf=6nnHRTM^oIZmYQ=m
N[I[DJ@fULo_[^Y0TU7nFXop\m1l2lP_FZPCDNW>e81XT>@MJ]m3d_k8I=WBDL8n
deRP:g4c^iZ?iSnD[EM__nL<hdP@Tl^D;Pb=d\ji7Z`D_E6B4]nd9SZWIWePo>NA
S`hP@;ofkS3hJdqX:i0AZJN[L^:N_=eQPpZIQ9Q:^:o5>9UGo@WTXcaQgX@cgfgW
Ck?7`gW:7VUPT8h`_aI5<P33XXG1D[c;Em]ZDK2\[3MTa_f>T]MKbH@755\<?Y=G
;O<^cHP6nA2RT_N3^opiQ:NSHE@jmRkRk8\Teq_QI;2_;hW0K=OLQAZm1n<>LY6J
IaF8E^[5Nn3f5XUeqIo[?n86fEZA=8TF]@gcB3`kNW;iK=91R>22L[\m2B<U4=F>
p=W61\E1E\1l8?AWjo\J?BX`MDQ[8qkNeg;n57`n82fNnkKMbW;JfN3]Z4fEnAn1
_ZYJ[0ZRqn`GZ8?Dpa1Dh28QQi9`EomV5^`l1b?RTS>SfXI?@a_DDHaXW0f@1Pbq
nW4ZQkIqW=2YZ\5WcQ;ZU42HFl>ghEGRfA[Wm=b[_2TqOj9\jaFqhAXO=FEq:MAR
eT;GeX6FB_Gc635WB;8J1bVoh0E4Z5>7F4UX]JIP`Jf`naZOfG=XjmCS9>kS7X]Z
LT?3][RBpbiXB0NUpBMHFAgjWodV`\4\4GmW?TA=lXH`:fk1[VmeR>nBCKFNQ:mq
hbYfbefp6H]m_\Ip?R9HV^;`][MP4OY4RC9pX4g>ombpZkf9CM^n>A5=LR`B9UFJ
Kgg1Z58NWkGmkKGE>j9ZA5h]LJ>K99n?jhAjp3OMZGFlp^bZ0Lbmqn2kh@g@p5KR
Bci7OA1;f8jh528oRaEm=`Zh65Q6D8oS]KGQG`31AU1eQf36;2`=llV2a9dLL@b@
JbnXf:bX?\SS5>B:ZPAmcP;0hOUZX`GAPPOcgM2D@1XTapDDLA0[QiCMf2;=^UOc
OaJo^<ICfB1D5]Zg3?4oP>X8odSY]iQ3FN6o[1O98plcQ1O[RoiAYaK4oo88N@a[
RZhI<Xf>Q\YZKLT@HhTa?ZeBg^0>N3H;NPcNV\eaaPQh6HG`C`K<EWmP3D9f_ZJe
pN<CITUe=iJUUZl`2>j`eAAOoNNkef3i^N^WBm`?N^67?=I6[<A=bjc4gEWFU46o
l_69e[FkZo5N5^;k`=1LmQ=p3Rh?gDhhnDm0>LaL8n8UCTKoJL=iVd:CmN\P9P>n
`D9YI:NUcV[[@`WXj]0BJB>9TAjIPBXgEI]cI`Q>0^lGYWp7?bi:nL`7[ZX\mD;<
]Zkm5`f?8@=8diGHXd63H@DeQHWX>7AT2ODK6U:FU;6^PlgKb6ckiXE1Ba?Qj]7@
nIbpe_4JYk]F>k``mV]RR>YZl;WglF>Foj2M9=]CG2@4;ojcoe6mj`en2cFOi9lU
g9JgBLN=DECCGMim^9RG<e?Iqe87:EI3eLZCn`51D9:j?LIScLERYYKPTG@VU=Q]
M;JDaiKAKnMS?3\2`RNV>cVe9g<SI93HMpEG6HXJ3:JUf34FLimO8SPh:bGAPXS[
VE`\j=cF4@IVo6jAk_9f25[n;Lb6dW5[eL]MmR@k?gSH?MTjilToafp?g?o<=9XD
d3o;]=jm<21<IcP\elQ:YR>$
`endprotected
endmodule // module vusb_hs_dma_up_int

