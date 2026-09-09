/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_pe_datapath.vhdl
-- Date Created: Thu Dec 21 22:42:31 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_pe_datapath.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
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
module vusb_hs_pe_datapath (pe_clk,
   pe_rst,
   pe_rst_a,
   pe_up_host_mode,
   portctrl_rx_data,
   portctrl_rx_valid_b,
   portctrl_rx_err,
   portctrl_tx_ready,
   portctrl_tx_data,
   portctrl_tx_valid_b,
   portctrl_tx_valid_early,
   portctrl_tx_valid_last,
   portctrl_tx_ls,
   portctrl_force_bit_stuff,
   portctrl_pe_busy,
   portctrl_rx_data_r,
   portctrl_rx_valid_b_r,
   dp_tx_fifo_cmd_dev,
   dp_tx_fifo_cmd_hst,
   dp_tx_fifo_set_eop_dev,
   dp_tx_fifo_set_eop_hst,
   dp_tx_fifo_ep_dev,
   dp_tx_fifo_flush_dev,
   dp_tx_fifo_flush_hst,
   dp_tx_fifo_tag_r,
   dp_tx_fifo_tag_r2,
   dp_tx_fifo_data_r,
   dp_rx_fifo_cmd_dev,
   dp_rx_fifo_cmd_hst,
   dp_rx_fifo_data_direct_dev,
   dp_rx_fifo_data_direct_hst,
   dp_rx_fifo_tag_direct_dev,
   dp_rx_fifo_tag_direct_hst,
   dp_rx_fifo_err,
   dp_rx_fifo_overflow,
   dp_rx_fifo_cnt,
   dp_tx_port_cmd_dev,
   dp_tx_port_cmd_hst,
   dp_tx_port_data_direct_dev,
   dp_tx_port_data_direct_hst,
   dp_tx_port_transmit_early_dev,
   dp_tx_port_transmit_early_hst,
   dp_tx_port_ls_hst,
   dp_pe_busy_dev,
   dp_pe_busy_hst,
   dp_crc16_rx_tx_dev,
   dp_crc16_rx_tx_hst,
   dp_crc16_rx_pid_dev,
   dp_crc16_rx_pid_hst,
   dp_crc16_valid,
   dp_testpkt_start_hst,
   dp_testpkt_start_dev,
   dp_testpkt_done,
   pe_tx_tag,
   pe_tx_data,
   pe_tx_empty,
   pe_tx_idle,
   pe_tx_rd,
   pe_tx_ep,
   pe_tx_ep_early,
   pe_tx_early_val,
   pe_tx_flush,
   pe_rx_tag,
   pe_rx_data,
   pe_rx_full,
   pe_rx_wr);
parameter usage = 2'b 11;
parameter eptx = 1'b 1;
parameter eptxa = 1'b 1;

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   pe_clk; //  pe clock
input   pe_rst; //  pe synchronous reset
input   pe_rst_a; //  pe asynchronous reset
input   pe_up_host_mode; //  host/device mode
input   [15:0] portctrl_rx_data; 
input   [2:0] portctrl_rx_valid_b; 
input   portctrl_rx_err; 
input   portctrl_tx_ready; 
output   [15:0] portctrl_tx_data; 
output   [1:0] portctrl_tx_valid_b; 
output   portctrl_tx_valid_early; 
output   portctrl_tx_valid_last; 
output   portctrl_tx_ls; 
output   portctrl_force_bit_stuff; 
output   portctrl_pe_busy; 
output   [15:0] portctrl_rx_data_r; //  delayed version of rx data from portctrl
output   [2:0] portctrl_rx_valid_b_r; //  delayed version of rx valid from portctrl
input   [2:0] dp_tx_fifo_cmd_dev; //  command bus to tx fifo controller (device)
input   [2:0] dp_tx_fifo_cmd_hst; //  command bus to tx fifo controller (host)
input   dp_tx_fifo_set_eop_dev; //  set eop no received flag (device)
input   dp_tx_fifo_set_eop_hst; //  set eop no received flag (host)
input   [3:0] dp_tx_fifo_ep_dev; 
input   [15:0] dp_tx_fifo_flush_dev; 
input   dp_tx_fifo_flush_hst; 
output   [3:0] dp_tx_fifo_tag_r; //  1st stage tx tag pipeline
output   [3:0] dp_tx_fifo_tag_r2; //  2nd stage tx tag pipeline
output   [15:0] dp_tx_fifo_data_r; //  1st stage tx data pipeline
input   [2:0] dp_rx_fifo_cmd_dev; //  command bus to rx fifo controller (device)
input   [2:0] dp_rx_fifo_cmd_hst; //  command bus to rx fifo controller (host)
input   [15:0] dp_rx_fifo_data_direct_dev; //  direct data stuffing to rx fifo controller (host)
input   [15:0] dp_rx_fifo_data_direct_hst; //  direct data stuffing to rx fifo controller (device)
input   [3:0] dp_rx_fifo_tag_direct_dev; //  direct tag stuffing to rx fifo controller (host)
input   [3:0] dp_rx_fifo_tag_direct_hst; //  direct tag stuffing to rx fifo controller (device)
output   dp_rx_fifo_err; //  bit stuff error detected in data written to FIFO
output   dp_rx_fifo_overflow; //  fifo write attempted to full fifo
output   [10:0] dp_rx_fifo_cnt; //  number of packet bytes written to FIFO
input   [3:0] dp_tx_port_cmd_dev; //  command bus to tx port controller  (device)
input   [3:0] dp_tx_port_cmd_hst; //  command bus to tx port controller (host)
input   [15:0] dp_tx_port_data_direct_dev; //  command data to tx port controller (device)
input   [15:0] dp_tx_port_data_direct_hst; //  command data to tx port controller (host)
input   dp_tx_port_transmit_early_dev; //  transmit look ahead (device)
input   dp_tx_port_transmit_early_hst; //  transmit look ahead (host)
input   dp_tx_port_ls_hst; 
input   dp_pe_busy_dev; 
input   dp_pe_busy_hst; 
input   dp_crc16_rx_tx_dev; //  crc16 source from rx port or tx fifo (device)
input   dp_crc16_rx_tx_hst; //  crc16 source from rx port or tx fifo (host)
input   dp_crc16_rx_pid_dev; //  crc16 from rx port upper byte (byte after first pid) (device)
input   dp_crc16_rx_pid_hst; //  crc16 from rx port upper byte (byte after first pid) (host)
output   dp_crc16_valid; //  crc16 matches residual
input   dp_testpkt_start_hst; //  run test packet
input   dp_testpkt_start_dev; //  run test packet
output   dp_testpkt_done; //  test packet s/m is complete
input   [3:0] pe_tx_tag; //  tag from Tx fifo
input   [15:0] pe_tx_data; //  data from Tx fifo
input   [15:0] pe_tx_empty; //  empty flag(s) from Tx fifo
output   pe_tx_idle; //  indicate to FIFO pe is idle so FIFO can populate output registers
output   pe_tx_rd; //  read from Tx fifo
output   [3:0] pe_tx_ep; //  endpoint (channel) select to Tx fifo
output   [3:0] pe_tx_ep_early; //  endpoint (non-registered) select to Tx fifo
output   pe_tx_early_val; //  pe_tx_ep_early is valid
output   [15:0] pe_tx_flush; 
output   [3:0] pe_rx_tag; //  tag to Rx fifo
output   [15:0] pe_rx_data; //  data to Rx fifo
input   pe_rx_full; //  full flag from Rx fifo
output   pe_rx_wr; 
`protected
g7aRYSQ:5DT^<_VM4]g_GGR;1@P\_DA`ddLO<:\5@YV<MYc?m`j=qSfLgD7X=]CK
PkJk=RWNTK_8qa0K2F6;CKGY3ljY6?4`55WF@Z9kPGRaC=l93G<Wb\Ul0DE5V7TL
<K2peIB;7?pg\W8N5[14\hIf`1:DQTjh8;0M]]P`BWSJZTfQAn90^ZZl?qdQkD?6
7?3<Hen5S^D[9F1<mJcG1?;;;U:542G\FZTD:U68gEp;;ViD85PYDgM3>o0@d[Wl
G7CO7dIObA>gZJQW8G[p>hf=9E]c_@aUL@[@Qf`[H9NiZnZLZhKRWfia?:<qX0SX
K3OPT8g<b=S\_d<M1>MT5a=Ep9S70R<8KdMBQ\KGG@1FYB:nJZYOX4903:0V90LN
KJKpD]L;R5ZGbDMOE0E0H:2PGfFGZKA]7gCpP_N]ammFLL>W6`iFXU5eXdd;QlQ>
B?_\5co=GkV7o]SRDTdMpPZ<9Uf]@iYoU@]?k>?7I;RYA?E_@GeA1ATPlQNobCVn
\XUIPmhFA@gTZq@1c?m2OeoaRK4]9<I2R?68mN5L5@GnB0?WI;Z;[8R0bPPGHfFc
VpcRjG0^co3CV1EQ`Ho?8no;MYkf`bB1n^>4eB<5N6JY>DpQ225aTT0bG99F84cX
1S\e1deN4`UE@R9iTOaIOhb>Jn\Uep7:7DZ]i?;k01Lk5KLZb`B^R0Lh>X1Ph7PB
Rj9RmcMN3943[q2cBO\oJDUSb3Fk0WG7JcaA:3DKS[qT?`Y5QfmhO``?h?;[46h^
iBR__1J?BQpjH8=:ALT7\N?\mCoHcBF2mb<i62Fl2L[Ri=pWDL:?;4`jES96cZfj
1?cGUiEjLfP2`MH[7Nag:^6bejqEcaM7XaNPF83a26LeJ=K2OPWE_:;q8a9TBMgn
7df9mT03=dPNNji=2]_Ae^pRWIhchJclGYPAa0FD;egN2YC@lpfoR\ORkPQFVH37
oWde\I7SCq9mI=C15BFeg_:AScJ3:8qEiW1_4=^9S@Ino8KYRTK8YFHLf3R<haLG
7q`5<j5gE_jnZRamUV3LF;c=0Zj7lDLCO@=H^O]Jf_OTq?1_WAcP0Hh67i:0ma6U
4^=0hm@elBdLS7:7Dj`<?fgdHLHg2GC:>K@M0mamgBCp=<XE0aX:ZE?5BA67U9Z:
2<Bci4XRD;pnX<]^?9QoWUgCbG`:9D\kCE9@M6Jj]25Bk@UJBbq>W>K_:O9XKIb=
X3:RcLGd]E8e6e`:MkK4\aq2\[G>WYQHk`nJ>@TI?eM[jBNbU72ZEM>h^g9;]p[:
8mL7=lXhjImEbI_U`;p9?05>P^TLHBDc]B_L=RiAABCk1L8E:T26Sq1XADXhB2<Q
W3GQ^8cA@X8dQX>6a>cnBqVL:>R2ZO8g:0l_f_^NH8:h\dU<<<cGBE2h]=?C`pPN
U0^WG<2cFQ6]\lVO@M\U]T_ZQ_A>fL^J_;fOd01Raie^XZkXJn1GG]S=B@q143M7
4ZY2PXPlS_OJJEllmIMUm6o9<pCoDkV<ZlnAN8W<=XdAk>XW3\h^EZgn0OTR1Y]M
pV;C;D>Qc[?YV@NOdSAjCgamlc\BVqi6<m;3j9LU?UN6A1E9>KN=1`K;^J^1ZqoG
aa2g7DNSnfLdgWBEM9IG9JY0poE3PQ>P8ja`eOYHfj5T^PaK6Bbp2:R@aSLO2ha=
3H2g6TLC492p?k4N7c7:Y1E>@99b[[R_ZmC@Y;HN:?jq?7iijFV\^i[[V;jj<iDV
MCWjA_Thp1>2kQG7H4_Nh6NoW5nloohTq8eF6PBU9PFkBWP:X8MgX32C=CbNYq@[
G<R?EE65Ylc6cI_?1Bl_?=>0<ga0SpSc20_HXin@@eJ8a`g8I?RW>hCZUNqgR<M_
0U1MQk^8P5Ln3L;G?kBIm1W?BeoJi`id;2Ha];Eb[AE:]d1I[f02SZ`MbmQp8:li
f`QhoW[l6^`0I1R93AXbZV1ORTnQl2>oq[7lXJ;\a\kS8D>542J3E7EWfjdh5:R7
pH62;Bic>AA]Bn6HSA>Rb\<7Io\Qm]7pJ;J\0YlT;ogb0QDAl;0`eSlL0AmZ0CXi
^Xi8ReMTRnp8nRFSH\LDc:QC^oaV_KP>7S_F^GS`QOHX2qH7DYCh[h`l_i\fA>?Y
l90:3:_1BV6NmJFnNUTc]>Q\;XJO9;5ApP;a^7cEmf\YAe64FKACHmJ_m5GK^JYG
]L<bE\7@H:A>JjQ@D@@751Aq;_KHg6inG;m]hR8TUilH[eZRoWdGl0^o<;^Fa^p[
V`j\@oS<dDVXKQPhSYI<N46Fa:F8TaB^bcOhHEFio98Lb9p:5HbS:0f[:ci470[h
`e[RcMdbSKIj:d>^87[FZ4P]5[iJK47pD[W]Uo5H`i1i:HoUX1IfJ51\Kek9EiB^
<hKl=6p]ZGh[B@RjYjJR7b?cNH?>1\EUX?LWh;LDVUgB`^Jp36IPW<RF7aj3jgi0
3YV88Y5qNRYYKOaFHKc=R[`bV4jkL=JR`]13A`apP2KRcXhk6Y4Fh3>HNV:0=OJ\
76;ADFCZjMme5Bpf]]if2]Yc0h>JM8[J3DkQ9jCJ36UJR_=k;`_WCd02SLZUbq=@
<WijFC0[EC4mcU?\544h^mI0MNj>BVPJ6eD1TAkeBA\>1G?GWK7W?R@0240YAjLZ
MoJ;WPp6STZ:YGj3[JRVGm;;a_634PBk@Vck@Y_cJ<mZc@m=UpgW7Do`Ri?kZ9VD
;Tn;l?J17_Ek4Z]?2mQ4DAK;X16W=^K2gFgYg]X`pYcFdCDY;NU1W:;:KALo9[GA
bAbWl`o>GKVKM8@TSYkf^cC:f`A=p[V>@S0Z5[8PkE]J4L2dKf2CHO8hk`mG3KP1
CeNl^li22S5Whp=ib\@ghg@5j0C>_3Gf5eo\DD;4l>kaNV_QK[=]TYak4fP:V0GK
jpmAK1HTYecKCW3L0al8Ea3^@EI_QRnXc[S3\7oNGA^SqDJ:Ji]n59Q][=7JgYJo
[H^I_^i26?aROAHkDXVcXbHm;p3]D?YMCl]Uh^^OKWO3<\8L\4pNV_8;W2Re4ULF
>X5]D9QhV126:^oV57F`RpdNC`:ldZ[bL_EA;dO?7Ti91FNi35F`<]69I]IoSTT2
pllgb1fSonfW8Y`elk=`TKif@h[iac@goMD4LFh796lR7]BL>M<75DopLWRC[^FJ
;eJQSd_3KBiCIS^9fc[6V3C7d\iYXWE\[GETmf1M<57pje;BTTJT]V]3bY^Q<c1E
fIgGP]ip;\[AdYC:OS@kNETo<::MBMGUEDk27a4h4YYNbeKYDWcifKdUK6NT1Oq6
In[n9\`_Le;em_Z:9bHNQddTS30:T`VoPhqAdDHnaY^C>f0UeA>TKP9OB[lgeCIL
Kl[MdUC8FVB]6pYI2lOb==0n0:SWQgbFU8no1d9?@8K6L]RcAipj?]EknHg=mbLb
XoRbecYA4^9maPe[6gi6Z`T?l9q6SUO02^LCLVaoOO2jdnl\bnm7j^B1ZXp8W4Fo
biT<<JmA\@H\[]^bd:_3<<V29>pHE=89@i`8]MWNMZagNcP_L3pE`eK:QJBLf9h=
IS@I<R87M`<nPS23:cqBQP\ObMlGclhZ?X?<^>\OOdRK@;Sfd>fqaY7Z@Oj8bEZm
;:G8f3J:X<k9Z?kWqnXb]:YgeehRNJASalUY>3J?kMCaQU^pZ`Md>;m`>e5WkQeI
NTna0_k2f9<3SoV`hfAgi6PFf7mq2R0Ne0n]LMWCbnV]MEU[p84dfKFQA2[JRmYF
Q3j:bkL^P>`<`g>cPjMHf[2PIVZe9p]85AD88`c2dFWfLnmRGIBH?10MFE53E;26
[3\P>b76<3qliREY?gd`>Za_GJ[fCNooSEOXHSQHK[]a6_MCOH<h4\I\OOPN]GL9
O;\19T@1VWLWoqZH[cX=aellk`8nR^HSe8GfPFWBbIpR[AQS;LhX9TGBJdPTZ386
K925^`6Eg\q]XYi?Ia44>0_XO?:`cVXJ7K8La6GM`VIU^cEkj00j7hq?B9gNDfE4
YZJB4H2M6Q`EIS8B<;1>JAh1b42]mU^p<bQ>IVQNE4N@mEd^Iga_>KXM54U;T<?3
MA7>Lea]0O3Iqmd9;\TBL7:KG8QQSaKmjnCEO77^2O?dR7gVBc9p=D9g\h_H9<3g
4c9WHc@o3@o>afg1Gd6o6YQ_<h]bYgnnq9V:LAl7<nWhWKaNEi[JTTF<2RAeD6K6
j6::_1;BZ6RE4_Y8H9I;[UWeD;f[^P[7;lTE74\XO>COqki_HA@d4;=?hZ3ZFO?f
KCHSEnK:PebmO_S<^0`h\J?aGY;NcXSAS<D3IJ4[`=4PmgDV9CSDCj>pSB_1:d<]
?cZCk7HXC3HQ]4d^a5G]GBKja7CqgHCJliWUa:C8]L?94<d:FKIO=4X]Wmc0APgL
_YN8dQCgjOi<c9hB:hBK[8Jb:]lV5ck7m\i7p;Le:A9eKQ:J3^]QM`5\B_a=TD?]
J?U[>4QXn3L0k1@CSSPXK9P4j:97kNd8DQdKg8MH`=mo:pES3TEUVf;]C[FZBX0C
H=m60U]HiQ@>DZbOG6\h58HZg86g06nb>p:RFYM>_hY6jcoHXl\_a1]E`9Fhbl]?
UXoQE^OdB7mn3mh_0gXQ8DVBMP=4E\<WKDc\QH<G5KE4Gq9odC@?@:??6gKfZo2>
OogI9hIWPFUS:nXOB[\EE5_<O6e9ST2`g9j4he5B;516`_9FjlZk[5E1qDNTGnXh
h67JRi:81b5E]8OK<:@XFjlOV;TW2Jle[>?:K\W8pTiKK:2K9NZFL=U0Z@:R6X\_
7^b1UBW3^A``hJ?<]POWpodJYS@jQND;b2V<0MKc<8bl?jF_FpDN]BjI0gA72bYF
R^:ROQdS]_7lG7^4a?S5WilA17nNSi4Lj^oDYB13;ZMT=fhm4k^7QO?U<<_09aYO
oiZ=LSRi[qSgU]fC2lmQUZGHJCVg]K`Z1H:FlcQG[IY0ki?AFi<JoccA=2<ka[U>
kO>gSaJ4GC:NfC@6@dmQUZGHJCVg]K`Z1H:FlcQG[IY0cinZNp\m[;7ZDj;SLVLU
c`SlPmYY:J2AR6Ke\P_ek5BCW7hLiK9m5@eDOhAiV62MSZShSJWn09b_bEXf;BLT
aFLP[V2fTqQ<VGRQ8Y[5g<Cc2T8aJD\8VdVZ:55`ODDmKJTHSB6cf1:k9man9TDF
0j2_QHbB5`=44;16QC[1:4=2lj02JRFQkY7SXKIhbnkmHobG4<0Xfhn5oc]o=4[d
PqYCK8hA8C2?I1j7m<^4=jln`VZ6Y=^1j95@\`X9iTFe_^I4@>g5R`:=m]jKWRN_
\97Yb=WGZ2CcXDjkOQ^G:he1[q4?Xe14>@8EIZH3EAdQFl5E\h?gKPnP8La;3OWa
ULfC?h7`_4m:onU>_F?Fo5ddCKPfURYce_1Z1>FZ4WbKFPAMM>><4??eWiI;0<C?
4<0d8VOnm\l<F=ekjqmla00jlZEgWdFO2SEV`9[UjeKHc1m9H<K3ZB`@Wc0Dm4C<
WG1?l7jJ4UKH]eT2kJ5VmTfolnMR0eKKdj?Uke3UgOeDnFRHCD=]XAU;N=kogf_S
h;=1LqOZkdjnFSXm`71`D8o\;0>N:I4J[[Xff_GX<1ff3Z_Q1pc8`61e8OH=]OD]
8SUShlcU>]i_lK2Y:m;@_bfndH?Y4UHOg0cTb54RiUMcoMZa6b9ekJ6H]1g5dAF^
bcn7QK7bfpFMKCGFYO@f@O`FMG=`dEa3NTDSCdkdPinNGMWQLQ^198g?[:WRZ5Ta
JA@Y3U?UOkX`M_^]R^g:nQU?YQ=>:@eUZ?HFbqkO^K8=5el3AoeW<[FO8=SDeEja
aM\<R8<QAcooTVj:Q3DbG>97<8@[B\FjXlaJPj>7^VZ?@oiD`60n=>lEj\Nn<F_S
P1kbaqHoUb>>ded=7R[9SofelMX?]nUf2iin>6LThoSjMBO:q3>Ob;36\gPO1Sa_
@=<VDdQl9<dDL[K^TTb^F8h`3l\T?=I[@S6p5FK4>jL=QO<AN@DW[mIAUI9edZ:T
U>[Q16cq<0c<g[6n_JhO_I[=oR3_>K\1Q:c7YkRlZkPR5=pTh[Zd]7q^Qmh_9Jdh
LPQg?TL?S4Z6aZ=X>8V?7WITI<VHoUp3la8J3l\X=7eJUW=[1TS[SWNI;i`c7UiO
9:JW@4fW7p=l4Zk@O5R[<bTJ=_\5ohRn0:C6gH7g<bDniGb?q681b`S5=gBb5lK?
0CiW[KI65L5L;9HC;cB:YqhK7477JYSmKe5cSB3dWiS1=gXB__En_KMDGcWL5CE7
pZY@b0T20^KY4e:9386MF7oa<@o=OAboJd9nB=UEACjiBqOhMZEWehO^<RN8e1M[
cBYc]RIBo40kZG\R;[EV0_ZO@[P^V2k297I0]o=ZG83`;MOn^PRc4`pKNNXgm5n0
2fjTgb:V5T`EmXCXF65YgKT9Qk_EY^nYl_lIdZk:np;YFngT9HK]_g3E:EIbaElc
e[K0c>hR^3nOPDO9EoT^lOqH`^>LiU_?1_^=39`F1G`hd`L5P4Vlkni9[ZPG\=D\
lMG\RLDK]CqIMP[IS5^P@jI<IMJV@L_T1:B_F6AYe0Qi9ZKmb^HSPUO1D]lC4hbq
g>R[HV8NhfEecWXJPjl1g<7<YPd9JZ7Cd5j@7gUW3MEc?oX]c05E2o0WFH6qcRCa
fPL>I7RZe5kZFMA_MB?TkGH\fm03Oi[ai7HbO2Yd5Bkhb<hMX5SM=XU5o=pY1C6f
CaqF]8L^DVI>kD<O>0Q>YQhhK1p8DVNXc4plQo@:^eqb?FdYeL:GA5OXGnM<e^6<
d>^hdg>eATlSUDpi1OgYf[p`o?<H^30eDj7`Y4MIe>\o[_@l8]PR8f`dk\Y@B6p9
F9AX\MVIU[LCRXe0I76kJ^FXLL>`B7?\1eaajXCDlp^D4IhjHIgTgl@`A6\6KJaK
CX36C>@VSQ^olEpN_YanCQiD>Ia<llB2H6^T`ZZEiB^hV<M9\P^HDaHb^p8\RMEH
K7kn@i]3m^7E0e>3==lM@p=^aDfOjDeS:=7NgE61OBe[Rc]9:]FP]7UAl?X[Fl>6
gjpN2J9K`>ZNFJ\5j=d\o8ZXjB[=H@Bimo<FmGM^RKM6H`1>_\GbcqhIKb`3b9m:
aGCUg=a;bJA9UjkbD63=F<XHDZ:]:8=ihUqYaO3T`3Ba<nQNH9l@T3`VnYMO3EWc
LAMBFBZefdZ;mmCm9he`Zaqb6E85UTX1^1?51h[U?Bb@7Qeh7eWEMh7HmTkZ9P6P
SdUfTF_PDD2PINDLi5QdcWhXRVGe4npI>b=JLLX5n0^>c<;@QY?U]OhJjlS=dgV2
kP]hNV<h^U_II<:M<3gp5JS0HKW15m1b18aOA=_@A<E66ol@\\1LiR:5JLe@Q1e\
;_1EP7GG>F1Xa<7p;<<>^M025[M@hYP0QPgl1Uea^J_GAiKXEXRRhXik^4hYTi:j
c8mn7WTNkiiVb>pXLUFcS\qd5g3KOCqnEgo0BEq0a>QoA8RX0X\Ra=3K_EZWILbZ
J=baCY6f>B7>3Gq[Yee8GlRENT`NIU`Y]:a7AQZm[RXoFdMcZ]:qQZKajXlHQ^a1
dmJfVHa;kJ?1aDd9j>1So5aN79UALcXqJD2nX1ho3IGVCF12U>[]6a<6HX6jgkO7
R\5P:JCmGNp]Jka;lTWKb\;>E1UjP<nPO5kXI]:ah;hJmI;[>8IgEb;pLO[lZ`R1
a_Pee0@hieil<EmKW]QPV5LDX`beQD5<D<=PXnM8?CpgXcn@<<^YQOd[mGaMJFB^
XXFECJ7E=_;VM\2OTGT8>_bhEgcXJ`0nCP9<1Y4TYKEhjSpd_Vf6TbPj>5B:<\UK
ES<U;BLDag`8?TfXHUJTmmeE9IfpcnBFfjbWRe^[f873=]]nie7]7QESm=Kp9`S[
RTW_>_X?]`M:hPNL]Gi=g1L6ZP]po3dnbUAqRSJnbU2?c`@b<>_@RjdYj<fX50nf
3Yh_7T1QW:]pUd7G9Z1pd5@Cff=<bj?PcX@0C9Y2_67U0XG@Y:n0lWRlp6^T@k?I
qeMSN9gE?NBf_N1\J`TMG:MBVRQcd2g8e30<\@DAT=ahEG8h?M[3C>?VH[bo[We\
Tn0TokVcp0HB3\KU9@i_@R]eBLW@`UC=GcWFO>0@PkN5jp<RTU`]YLP]nY7?8ig^
02^_SJBHfjQ_^nU<TFW:O[RN1mqOA1iWhjphMUE5>_PL1[cN9YIF2;CN<B=MHEk9
c@oLICaQoGdpWe\fA?9qShL1cI\9W@iAYfBkB4U<X5ZO62Yae8[;VIgQ6BX@7C]Y
\D16pZ`5hnRcB<Db`B64]dS^Fhc^NnTZ;lm<<UDE`IHmDe<egpD@XSmdfqnH7ebH
oSQV?nJcpRG5naBQh[mHm`kcYeTUCB>53<Sdn08e0YI3jBkJ1<DdlaBqF]1@NJ;p
EKcKQ8b`ASniQZ=V3`1;EG8mJUGJ6@Yb^m_a_=]\]eEM?9]e7ZCVW1qG5Hj?RO?Z
TH>ZJAO=U=J_g28dD<Z4jhJ`KQ@HSWk`7jAQ[UP2`pKUki\\_qK3\N5N5e88FPj\
3YN\;b89PCGa25g6UI@G:LUEMWXHa]FVG7Ugh5pcnZ3LK0gW38<:W_Bfn<G78LW1
ZWh4F_lKj1Qq6Rlj=D`pXObQa[F4=fSZCRHff=D[ohJ<5`E`PH9Gmo1<SW_`N_\V
IZN0qQcVoRkYbeFdlhnb\j^T`2\J2=K7C9d_k^JTFD07oIM1\pkm<1`j`D?E4cbB
jGB^DMb9p60T^:A<pUC@;CQ`E2L9VQL8>VL6Y2]V>lGPHj9OSa1C<Jf=q0mfLFFK
qJ@17eEQWW1<F1^QOg1LoWREGP8FCh?_IGEc6U83ejO:DQ:EpLijCRD><D9Ic=8O
ZkO_NT^U[K=i]mOSS`gD8m<FGg@N?q8ecEEkCpSMSSHWDipk]CnPNlNRM6flW5R2
eco7B;S@HL=?2cE31RNe7?jZDRKlTfgK]p4ek<kk9p9GF_E7?qSk98H641^iK87K
UON;mc>2>IV0kBgUNE]HVB>bQg50\CH8pTFmmDFPqP0lf3LNnjYWXW<cq:4hlG@n
CPceA1gV3K\_U[>g`=O6X4_PUZAMiZh7<pPfiWUNQq4e:`H_99[oIoE?74>cL:;X
``:8Um5Zin_D5N40W?7bA4SQhqb[gWeLRp\DAPjYm4?b0X9H1=D7YWFo9a^GXnOK
[=HTX\>SH96M`77WNM]24qG4]<5iYqSg6IPE7RS6:\\LQ6]KUSTi33c]\7oWjHe=
j9<[IdUEbj<4q0@hhPn=>4QEbk^fm?3aO12RbAoMBYbl;iL>8D<kDKV>e;`LEl2m
_e7qdlI9BOQqn:Y7ONcq\4eT]6PpYfKH28YYMNc;I5inIdND^\9?UH^^P0<fG2:J
aANZTPH@bcNkCTp5Y58[d_qejoEGl8Te8\\hRhWgbEYBKZ3?1Y0R949ah>hCC>1V
A^\je`;ha7R]I>=[\<jEG;apeKV:SV28Y0;@W<dZ<joHjFR:;mk6F]H<0@n@^C7V
B3L0M>PFngiBjiH@U:0BM?3qc=E6AUHc`;Z=kC8la926nX09Ei]V@99W4<^jVNi5
:1Xg1hE>efHSpGCPEH`R=aK7@646Nf`5:dQXL1j[J<iMEJAkW@;L2R>`d3]5lo40
^QC4@N9`<5c]:4ST[:mR8Yb;ijMQdcBq[OKoD2>pVa6C9fMH>n:7eZ;LIa2`E1N5
oMm>hQKWO69DPdi3FhQidXh=M>QgN<qo<_[@RKq6jBmZRc6[_i<8Z<<>I0E:?eN5
4TELUQUWUZH^N>pNJe677?qLl1R_l1pfFGS5I9B_8Sb[a5k5ndV6l8NFeS_gCk3;
KNU]6=6hTC0TRcbGLXL<>M<DYD5YP>P;Dk=<geE?`N<CAYYJn]@f@9Q\HGk9WpAh
@XN9C]MMc`_;J_DIi`Dnei5CDp_=`Vl2hHGCb[a7i5Z6XF[bY`c:`lWj3Bo@\hc?
[UZC1JllTeGg>UhFY]L<Ee>43j7mem3^M2c75nO]<TZ<0P`>R7681DACk[oGNVP8
QOZ[T8fH9V<]Eq\0\`kjG>PV\fe<LX3D\Jd;1:l0\EHY4f0J]ED[Kq[;;O6i`3OC
2]jXUm2TPlPO9=Ha<gLdXRV:FO8W416mA5`LI0fZ7J5a:]R69M32Zh[3Bh4BB83<
MM`IlXJP`ofN8<?X7^HRmETg4A8W3EcVl\6D8MqbY2oUj[9RYP4<0Kl\GjCJk4GQ
;ZdUlFK:nXo12Mddcdi3ZC\L@Hk`E0FOY9[dkWpW^7m^NSZkdQ=JoC:6C9Pc74JU
?]qEBWHU=IRC`FTTb?7m1]7>129Bg:W8E@e1jf6e2b9=Z=f;m6G;SeD_Ho9Ya5VT
UGFI`Ol_:llOcCkc3Tg6Xm=[oO3fLnfqh;lfANE:i4G<gI[c;@9h8>eOLUSl946W
V1Zcdjd8d^hG53Z>:8VYbJ7`b:B]QS]=6JESFjQ0SC5J74\`cel]ZUJIJk^_2i`c
3?UEm448d^1=mJRm7>cXOTD]@nq\:F2`j2;Fl>V\CYU6o@SDGdA7K@Y=7m:KWCJj
8efaOlCB[`DUBeO>aq3fWFJO:HN_aK7W8PTTe4k>7U`T=q5]WZRVGLCY5_3jDWKQ
05BfLL:Bj:1=lfW_C?NnT1Odmj`mi1>2JWOl[k:aYSWi1L_RK?U_V>3l6;^nL;>4
id=ecEK3md:6q4l06MjE\24m@W>m3JPf4;83HB@o9L]AUL\DFnRkhQQB5ddcP61L
DdlM0<RX453hE4i?[pONY]Vfk4__HVUB7P6DplF1a<mO\1]:Xlf7`CZ:eeCP66kK
PkdT:f3E8Yhb7flH21O;Kc21cA@jbJ0V:c4n[J49_PWejn[oYm<g0FMi]pHne^h3
2TI0KFdX>6JKEEQ<i1kcKA[D`J[Pg6KB7H6;`cIRJE7oLGU3g_`n2OThhe2C02o^
p9e=ac51J4G<^:V0n?R=XnTP@Z\Mq_:gj1M77[E^f:XJjdScZghhFK0e<8Bl\q62
Ij?IWgGTm8k^?:dSPn74V6^LO8;eKWkOC;aQ\DoAgYASK0>KhO8oHBF1IhWE\[RN
AkX^FXGc=@=TQ?dSc6bRSpcmBTdOL;3[W9o3SUmmD_@d;4NFD9E:NBoRV7REa;15
UYa3iB=JRC2I:[PX7Pa47pdAZ0FZD^d`8aQ;ik3oph;lfj<@e34R10;n2?cIhh7o
?L]iPIK_UFPYJ?3D6QBc2YnjA==CBOg:;V3^^6S]l7JLSgYe2^4H>];?P;bABLFJ
]PG:PIKZFLPYaP5M0o6;EmQ1LA1dQX:nB=DR:9;3`C=f>Cn6364LP]^fG\@W28l@
lZLXnTZ4aqcc0JPUY9`X?IIQQbQO0XBlF0bB\[hWpGSZC<dHYF<FnlUFW11gl;RV
Q@G[IlfS7m?bIMha_FljIGAWJJEl[8_C3CY5J`fV4HG=aT]O1HRhk8Ik_[d[`0c?
oe0VI\K;LoX5oPRpMnjQ]_:g1AOX9V9ahZ>o;c4cLgWDP<eI4@=hYLUoFIn[`CKO
Qi_EEm\BllZ_6YL65AmDC:<N[Gi4:I`a_mSp4>DWiA60`eFUTio?=6k@gU=bkIY4
2<4qaY=M^7H>DWa@Q]cZoR4GbKbKKW\Z:`XdC]3UZkO?g]=8KN;7QXHNfJ4k\a`Q
qa3b4YGJJnI;;Dog4;OJ>oIJTC:H\<`E`fP8naHei5SOWBc>n7OY:_Y^[KKKY];:
pV5aM\YZc3O;:ZfKAJRP:;O<]mi\DJNM7iL?9OFcEJ6;Jbj@[Mn2nd?mYF]69KQb
qa0Y8;>Kbo=UTl?[`3^51E^A:l84hcd;h@?@2WWoH<2pcGNEIJM^[YKOHhUlWV=S
WIhjDNdEqL4=ZGmg6iBec18\BNo9A6i^gDEHWcoflBB5TI`q7bI4\Jbp@?C0gP^W
WiN4oh1?T]8\nd1=Sk`4_a7bP@SbB8`m`D<\hnp4fFS5K0hC6J594GSh:;I3ieMN
BOe1g9X5oGC3oc<dgdHd^U7<GqBe>O1P4eJhEP5naGI9[Dd2Ub3EbBlXWmJZUL3P
Wk7nXHAk1qf?11YRj_JlfGckAg2`6Ak:=H@JMT7:U5QdbQqNokUUS?2M;e`hhh6n
BjE`Fechc>Z4<McCaZOE6;WoXWBpL92gKYc8=X[SiWG6ERk0iK7Z\DiDIJkjmb<U
dbRl?=8CZX^1;45LE5Up[Ik;bC@WPbJZlPR2>7J5WP8oI4A7[ZCj<E@Th<:l;]AF
FPcYIDdq053m`U]J:Hh<2?GBSY?KUAM1d`YT?cqSZD`dj3p>1FDkiop1l3CoXgpH
BofbKWG4dO`_Qc4>knPAi3LCcP]FJG>CJjpUh]7e^Yg4=\NQ561;k`5paW_GMXfq
UH`gPRTHYBmeUOLf7KmSb[U>EW05nf0M^geNZ]PTG031]iH[`mp7P6\1;GbHa`1P
b2jLUn`W=;JAV5anP5lE5O=cK[;^g475DfqS_?4:>D1FHcTcT4<cN0qXYdb4N]75
a=Jd8i9^WXhP]CcNH4KTeBINUfCpfXok]?nM8d>SbXg2A7MDOZYT0>o>:f<kLRTj
[1n=;;QdqlkE_iW2JGo^HVaPQc5L<XT05B]4D]j?Q=<D0Kb[MDc4hS@NE]dB8lI[
pN=ccFoa6F75cS2H=F1LVnN=:NabD\G1i[3OW]A1J6dpPS>WaC9J`K\clH[e1cST
C=k1YGPG50==8mmBLQeQ^Q0nSAGblnOpP2^3enEp=I?TRQ6pmZ?R9?IpYQa8Ifd7
GCXLdG3HN2oTJ@b7fB]QFaWnc>_RoV^LK^^AOKF>emqbZQQAhULe?0i>F1]AN\L?
IX6g6D;ikC5e[;WG]7T5lJU=@1p<ZGhPS;OLcaHaV[F:n[jLD]6Mhf7`Pe]8lBIp
76lanCB24B^f>Ubaj_@FE\c=L_?3<APq@A\MF1B^lmb57J\BCGf5mGhg5;OFYSja
SSS_EcIPReNkH>kFqKV`C?[3LBY67gg8aa3VooP1D5=?gGcHq;IHAMH7pLN7NAna
F5??8ni[28mHPoIIFcE?1hhJK1=TBa]G]ISQTbe_ONX6q[hJGe\8p`@iOnI`:q<Z
mJioBqS8hMfh4^I<OlH=^COSAb>dho;dhVeS5WD?_\@O=ECCB:4@cJ:]PL3g3_oL
bV47OBDEL;Ef_[kiXO@]TQ5m2?^mXAPdGag_^BH1j_^5=J187q`:JNR2@pL^5H^C
bZ`S9KMKaiNT407VNbTWk4cdQP;jDTdLfJaV?O?JIAP;kNZWc90Hj`L\T?=IP@5?
pjJF1Jk0pDdKa1=EWJa@NhZ:nUQd4\SB3>cDLd=<qFJTHX>N8IGaW4JMI]DdKBA4
>U7KLL>0p]0I=fi@p7`]IXAeV3gbPIX:\LF\HbXcIUW9A^<<_MPbjV^CRVmj8`;k
9j]oMk7;pUmH93YMOfikB;>XhWCCoOB=IfK?;??^a>?`MLejVZ>k7q?DA1bH_pim
JTWAGlda7mV\h;_J4`1CLAU6?NdFHj4W:[hUPq3P5YE\:0Rd]dZ>GUb`e=[KF0cF
K9ZY1SbEejYidAlR4S:O?=kFahHebgCQZn;CdpZA4BB^QpB1jZe68Hf]Dm@O8o95
`0F[D[JY`WaC[\XKhYdgQcKWq]bF@aHBp[7g6:0EZ0hl6I=:===3XGkC6W?PKb9k
U6Z2jgCbm0Zcl62RBkZ_c:[h]80>pG=>CISZJTH]E;<\T4i4V7TQoY8=@mSCmk_h
Mh8U[BClb9Ma2Y1kkD@EJq;6bG0ZK`BmGM7K6WDn8U7i^TV9b;JC^VJX8\p_ehS?
88q\hngg9F[]\=CLh^N3i^_3e7V`gQmAfCHKGcbc81@D3pmS5fC]6q81gYCMDkgD
N3MUiPj?;1K]^?[7<mHciZo9Ra;7<H=g\j3UX?NXPR576QW\:aV2?8@>KV=O:Vq=
c<M1;9e^63>c3aJGS4\KI<WRc7kYiQVKinXb5A:k1_iKm[M5Moc[mP1lHcdmWW5L
2NE?DNlYG5?UMU=dXqAK7:8=L]1kUODXQi^S@FH=l5U6bZgiB^fhCV;Cdbl>eah_
10^]H0A>GC<V_BPB0j>`l]1B@D9K46IQjUqLG]aj2L\L81`hEKQ=`d9T[@1c[[Y6
U_HHG\CEGQ]q@XnofA0Q@g>1L;k6ckW42FK_mA:Yd9ORQd94pZc[Th7Y01mN94_:
ZTcT\7dkiPIqH:AS:VJn@UjKnMJ\C=\5d21i:F`k^\aQ^8B0=k77eEiZkgSoja2a
S8=R15nej?g<`5i^900pVJSGWQ?QTZjb:fXE]NXnSIK;SJW8Db\jA\j`[XQ^WcFR
?LSAco[UR;kgJ8flilB1NZE5Ja@NhZ:nUQd4\SQCJfkp?9nJZ:Eq9YO9W5@TTS9I
d37cHT_nWn0m5n`PnbH[EZBoj84OJT2qIj1IGLap?a:YS<5SoY17T@ZD;g_V<n\Z
EUBROm<7\UJAB``@:K2]g>`qPEX6kkAI8@obO`mEBNl2LU[ec]<PiMZ3:cTgk?>>
MU@?H[2Qd221hO3548<:>Dc25R^IkVL314`@Pc^H5daqW_04^BIh`31Z?fL_cHUI
X<E;UC;JEE0WA:41mS<N_jY=XgPlaL?HC5W@IcDJ2I4jFQ9=cKCSK4O2IkbEogpU
K\eE^gY1>8ZNAo;YNPfFX8^BfFF9>QII5QGlkmRqC=dKT>2aQXI>8>`_[e0jSV1?
JfR]ZolTTQ55qKSXXgDAJ;mc3j;VNeVUT3SF_Z8i:mU8QAn`G4BG1OnJJ;o`YN1C
:OkNLjVo8=E2f_fW1oc;pL]@ba9ISTh0SH3Da05O5n==33;oD0M]bE7`JaIj5WV:
AR_IUlcb3S3\6hJWW7BYf1Z;__mODFhcdSJFDMQh=7=eqYYD4=nGcYmnSFXMSU?f
O8nn_HC`o?Pp3e;abD`pnd`5WiD\1JfZHSGoWiN\Qh^D8lkU?Z86HHGcMWpT1KkS
OFqba@`WDmODhY2i_`kJkPT:l[;bR_U_RP^A@<`JbcHjOA\OGIeEjh4mon=9Em=U
:9QpNj8=Niip[OHm?ek0h:6>gSZB7SIc10j7fVBd395]\?\XoP>dX`qd56_1\hnJ
\Mi8jaa>:SSTK>\VY6LVmi=Qd6`Ge4^k3`b[PMa;3O]9\U7_Y6BEE0_T]7:oh8><
DC4gkkflMcq9R6]k=?fVO?icje?P;?D;@[E\n2@GU:\6^hE@;::mf\KHkATEoK`p
=NA4OlZkDkKQjW:D3bZ2DBa0NIVZK7n@9dKTXING7;RHf?JU@1j9ZZcN>KZQ8Xe=
:MIV@XjdB`R[1ghgqhQ]m]7I@SDTlGa_D7^E5PYZY6E:\l2NNPN95piShC6mihj9
25jb^@cBhoPfkM0[J8no6PL[ZB3d9ZhNPMaC<VgLclgn\gQg6SRB[hBag?`D``pS
5=N_i^qLMd\LS;p`f>@_\IB`EA4EY<p2KmH\bYqLHG<nDLGGhic9J0oDh>:9`TcI
KJnU_:Xj\K\9^l3q^KIaaSAKl4R8gBNINSbDN1=n<P[XL?a4\g1gaB?moFCEfOBk
_7aKPoS@Uc^M5\]DZ0jFTFd]VHeI[e;kJ^p;@FQR`LI;TkLg<R>fm8iiR=ULnOB:
E;C1QRXTM:L8BWG_nM]52Hhj6BhdG@]e:GRK>ZUKnD6dK=3S9M2paScT0Z^TA982
:_LiWUQ:YHoeFnYMKf;OYA]9pOReWg^[dd2I;aInCENVl=nF^T3eaV]LI>3DaJ5o
?A8j9`8@O8f7@=^Ai<5I`5ZXkdG]T8Acq:XG6NEhq10_@7h\_482Vi[W`XEJR_lj
0qSVW?UK5d\VJe`7PKPI5fQjjM6mQUMGG0gJg0L6_@>dCG?;:[mCSWiGA1GOFTU2
_3Tb?HIW4L`V_^]lF:^W9g9Y>qoi@HX^apg4KlF__Wp5Pif_empKBk7n\WpTnofa
:ePD8PhI?eTfbSbRnM?AlXHn\mfTQMMHhB>pGKE:8?2qdYBYCX[p@6Si6LTp4i0o
CK`>h>WoTm0jTTVjgQQ>mY]Q`W0=7`Q>eX1qf]F[=PC@2;c\6gZUE7dE8Qk:K7IS
TA9MC9IKjH@]U0pcJg1kh\7<X:20UoUFKnC;Wi45?fBR^GblDTDYV^<GC4ep4Kgj
1Y?\f`d_Xk_5ERS@6HSn><RGlPe^4jZ3heT@jo@3GPE]TMSG62V4JC7O_@e9gNZa
p1VGaQ3^n>M]d9mFK[JifB`WefMK4hkAgQSXAibCNcGX>LLgk^gq?S4R9f;W[h4V
U`MC?@WY2Tc5c_VZ>6j]7JTJD8O;Q>Ej@hU3_oIGWUdp[GcAC0U<SAgHnbeQhOKY
4H`6fJ6YPDTOdNTQk[H>aigim:gPYhn6L1MpU?DBe:YRm@mN1B[a[An21GX29DhD
djZ72DQBC3mWjUp8e3M\gDWX_f29fI:hdkEO3oaSFN\a3<O@>YIN9U8qn^mG6?OF
LJBBMdHWJR0\m47[>`6LX2S[U7YSF9q8IY@VVCq2>Hl`7dFGRLF2M3TGf3cJV2hK
RYL9W[TgS8KnQ2@LfBc<2YD?mdHIgV=lKNjqbc=A31c?Xj14=BR<nEk?aDK4Z9Kh
I[G:@M`34A90L^T@1Q9U?0WD0XB8A\:3PaD^qSL33B^O8HSX99eZJ:jRD778F98[
7D=97PCAG2InNlIm:BiM@M]Ro\1W\p5Bf;5NcXQIZQD:>7K>ggMao4mDDk[8kOGB
I@O7^<ZY_liU7LpMAJ>I9Op>i>YQUDqB2^^S@Ua9<6Q6T\4mFJnBe3pdF1N\:TpH
H\UL\?_\Fjf6YEFZhnYGAE`mK3I_\Pd]WIpMbXm\BfpoK_I0P9]]<@oTc?NHTGO0
jPRK0Wgl```<Agj7]g6dMZi]SQZ\mMi4:ccaBI8pS>TQaDcN]EYU4_aIK[0X``PZ
djOUXFQ59coV[Jd]`HGYI7He378QMLE>V?\8`XBopg=;2Z]ILhLk`T^2hc;Se<o\
i4m=<U7TLM9>Af<7SL3`3kSDHAU9?jB1;p^gSeVI4JAZO581;_YURNTWWODe`JV=
>3cSm87\1fA5IHbfD@qc0QB<^Tq[e5bcLGq]DlA:4Pp<N7PHF:LVZjIINVJB[<3`
_1JL>m`hMCTQ81i>YY5JCM7lMc1OW`3XNlV\]4b3P_9j3ZIbm^M<bi8ENoFhY7Fl
HFi1oDcn05m8D@qUFaoe6Snc7Ca[XN1q6W[L?3EpN8lf0G>2=5l<mO`4\79l3nV4
Q=BN\M>g9iUegG;0\fLcjK0CheQlYf][cD[JR3I5o=p2KemS7Eq=0_bGhfBXOZ_T
c5qYZNFZ\VmR^FV79TOgnD`KBjW3:]IQoG[:\4M^Fd:Wj@VQ\>f?9EiKB4PTd9]]
iDZ>SP^JKd]\7fBS2g2c[n28bpDc2H1;<qolPMcmLC^N_VPiZMgc2K_HW:nO[30K
ZBFWfc99n==JZR>Abgf^=R=M]f[6N5?`cEaEI0^R=Pq;UhSJe=qW;N[CX3hLhTcc
9nRIQ[bFciB`b\hCBofOiAZO9k`P775DV=h<2HD32]mM=58G6qMLSm5BLqZ>Fh`b
bjK_RWZ[5m`IK]b<Z:GYTn\bOWW\PmAoD1\Km?dQAYji3Q2G:XR8ZGaf^XSKA[WR
pCT^NZb3PSIARaO5fKA1OndVjSkOqNCN6LLhDil\M]Z;;o7k:emed1`lk?a`VWMM
@QHJnF:N]Bc2dGXXWX9Q77o=qjWNK3>hqKHPH0jFpU3Bli8DqVJUf;J:q6^c\XNB
99JegboFEh9H`3IdVImIVTg1DD5_mFTnlfW^^L0o:R9kB9<WmNPZiIc[V2i^ciAi
FZMpALl91Zn?=QkH2Le^>:C8e>;aH4eB4aF\Fbn^IV5T4;Y]AL12O[oQdYeKH8_j
6O>LA9pLV@VQNRUmdHgBBPjkCBmkTJ5UC\9eW5<5B@_>NEYNRHWJ^ef\c_g0A1q_
Dia\oATjhAeba7\kQWc`N52<>1ZL7RmffeLG6[d8lqX6MA5N>]LLUQ94E@^70ZG9
<Dl9<Lo6dh?dUP[FAEdN8q>Im`7>H^Vn^XY]D=WM<l2CRKg93YENHh]DQ7hdqZSi
9QPfqUCA=VeJ0<Vnj^:V_\dVRO6alHF9Y30Y]JnR76PQ6UGdA5_3@J6fk6N_RJ>p
Z53PWMSf5>0<;=B`YCq9aDTE_J`B5XWkF@[Fe<kkL]1`T:M9_^`B<cBCPO3o4VCL
@PTkbJUU;Sl`]q`i9]`ma[m5`6B^>bNOBZK\@TT[6Oh29hIE[U2Li9_ERfkWW]8f
DminLqTi4L^gjnDc_iKJAZC<__aEMbkaYBP_l86=eLIHKR4MdITj:`59_oWT@eYJ
p5V3Kj2CK4=_@0VGV;QT?_`:[FWifH3H;;e^]>3lX0agJ=V4dngi3=l4IdbOV\0U
q6]337`F]1NB>J^eSdoh`mgk4o1gRGOFM;12\<L@PfW1A:RfpMT0S=a^q5?P1PaK
pd0?HB:5[`iH9n8DRgU[hp2o44Y:3qdjKo[C;lL8XYRddVPD1IOVN]NK>WS8<@ee
GqM=4`4O>q>@DCIBBm?E7LSma?KZF@3VQRMa[2;j_iJa?[FJ04iL=P?84LU<43G[
XY9HqX8@HTWKTA6`gO31ZcnRb[a3ff]?:aQXafd`D3;X30ID@TW34BneVnU6h59q
[Wn3NP5AEOC?Z\AFf_XGdTYbPgLOFc[?a1`d2\7QJ3FJaDDeH:b;dI7p1hQXJ7e2
lhW2Z07U2lVJnEO^]mGh52QnWKKc1dQd@<fX_@]_9ngCU2TdK=pSWgHbReS:Zm4\
XFd9QI75O7KFa873I_Q2?78=AGVUBddNaHpn2mFnRBG\3W7JdH:6^D4;>ZWmABlA
dXWWK?Um?NMm3:og8QoEO?@NO]_=;U5hjd1pUC9kAK_qC9fnDI_p:9008a=qD2nT
ocD=]mh?SP3D8eYFN[VGO=<?d]?^3libIl7?>@c;I\XL:44Jd@FQiopNdT;ccB`<
Mo3:C[?lVoE]>588a1L34X^lT:1R:P\Eg7_U]n2B?DGd4oW=XX<BaqP04CjKSD2`
lChB9JXB;X>N5Kmh_GkR8=O10A\Hbj7EoU2e2=HkhOlG`TZCpGLCl8g^?VZ]@?LV
k`K<b2na768YUU<kg80]h]ZAQknoaO\53f@O0NXUpi`RGLf9HD4`?0ID`9cg@X8i
gCS:Oa40\12jSLgf4YMZ`LoW7eAMj;m:f2XpkH^7JAd\8YeSD=coJgo1@CiQWJMO
h7K]`7cTSV9FiA3QX=R88Y?iD0IG:]Aa@GeMH2?GS\@_d1I5e6J@p]k5TBEe[\El
SD:6@:C4Uc406nC4Iha3pULCSm4ccOe7EW^E9pGK08;G_S4k]mReHNOPk6SOM@aJ
^ZJRS^<AK2]fF?PhpmcEO9ZUpaCY2KVnO44U<^MgUSR_eNX?MEjkS5eKL\O@f_Sh
=mnThZkFW:KK=20a5hRHOiLkcJKY@KWnOO]lIRaYhpUlL5>NDMB_`Ro@T17SeOK8
kU`Ol;Ko6J=5c1D[L>H=bUEIAo503jGaLqn`]5R4fX20Y?8S^lU\NKbUYMagR:=X
Jjg5_@4h;@QIl7<\q::<91dZQ?23WoQiG@R3EVe]7K;3ZIMQIfARn^`IKhJhl2`>
YZPN\3HhqAaLXhR=p4Z]JiKKZJLghb?nKSNba5`dg@Y:MUd5[KaTAV>8k0G\I=B^
=p]@:EghJq]Xh]@`^id3:YHTN5DT@50ND_d2l5P_5:hGOhV=AV;>f4jLU\NH0k7m
E?J`H75ghW9AhY@N^iSAiaPXf7p?FA<gW89H25dLlbMpoUn_]l35jdKK3K7=UiER
e1:L=2TO1>H8nOfWj4R_CgS[c=i?@aD]P3SpOi?D_FmQi;3g:\9=R@oVJ2fI<k`B
hj\S_=UF`N1mCc1dMSUALmf`?B@q>ld0bHbq5Ii42Wfh3NT;b6gd7WPBcnGPagNh
d2XfJ;^ZLC5Xq]Hh\e>9qL>5Da80?:G^[8I4MT8di7HN>K^Ti71BhWA3b^=16AYm
;eQFWV_<hKh2O>:5VAgLCca89^I9bgY13[`c2>Cfk_gLY18<pS=8>:A[QCB]1^jV
d18iS]:A37ec=2T\NfI@7;c[`34jDF8UEEV]UpWWT0f8?\BWBdRETN9o0^B8V^8\
i`8bOL2\?^0S55YEBLB7L0:SCP18:pPoZDNZ9?EWI^02@hFd^=ggW?T7HL[1o1a5
_b8V>SboC:WAkU:?C5M4\[Q[2jpWf0ffOIpUB6c9_TPY8TGL<<`O97d9F5JNZ@W_
a`FjK@`USapG@E[\`:qJS?]?geSme3Lb<_Q=`UOTO>8]Pcdc770hn4^gna5<0[8G
U=B:d1lhBD:;n3oBG3\5@N6K\ho==c@B2Vn<68H8mP;O^BqPG4S6WO_ng=\=UCoF
RO3SkM[jgHE3b;HCgi`0i6J\E`c``E>?3XZ[7VIBnh9Qc4NM]jaSQ3YS<WVRQCbf
[VG4l]cp@09Y1?]oF6g^d5HbOc2N;:5b<4H1D;TE:gG[ULHf0Q[NScTYoTe]?_gp
je4EB[JfN:9U=HKR[mma]mX9SE^lPJ]0Fh?6IJC<o@aD:b:@5X^EY8i\gYpB5QAM
d`0Q<N=KiL>V=UZ]K6Fi70eLLRiFmYAPRNb2K[h]\0khEbWFdoq6R0AHgYqC38Xa
0HoJ5H_4Z8SM1a>mR3Y_\GOVZR=3l\fnHjOJBqJ^UhhIHpYZ2RCF9BOmliWAFEe`
BoG_W<bZS4I\UiiFalemMQO8NLm;[U;7TK]lmRMHSP_TVG=D_>VaHjBFQj^=Y<gL
U;JVAjf[gqYnc3aSEE34e]OiYcfQO7Wm4;k7<SNMG93j7F?<:8[fMXGCC@[b]`b[
^jMFkS`^^O8onOYLDb31^7]1k68iO7GXo9\CX@1F?m=:A`kdP9qn^f71OdRU>oX>
j4FoIeOg8XUgf0h2dl]\nXCMd1B5]0jilq9Z?_bn>Q[Z:G@c4DISn@gEFm\^><KH
C4bgNDgab@3na[MfnKMFgm0g7pmB^0gE43jNJL4^0:MLl9_]Tj0m56h9;n^L=]RK
hVnbo_6ONT=b62Z]3qB<P7?:nqB^MM@l\>@]\:M89ik=[fcAiUB=^0<ObJ2CfgHC
jfqHDMYF]mpi?Q8[[;RUSh;[Gf<4[f;WH`ZXhX_jG1dVd1h9CcJEgWaa[13;OAJI
@Ac_jnIFD7_m7i5XL4:?OcGM;fFYB9Pi=RCqM@YQ>G^W5jUD5i`ec5LUPmSX@c0]
l:64Fj:W06`ob7ZTaX]`D=AcnOY<Ckk73]cAY5OihC5Vc^CXcJMp^dfRUaFh\MI]
?4QbHAJf\F]eg=`2nZa8Oi0FaTOILCa>LVH67VAmlH1pn4f]Zd]JB<[2aL0d;;8T
hE<`oAoR0Oc5[fejbCX:dhZX;=YnIM5?je@qXBkfOX[8>Uh6[Wi=9\HVDk;5A=`L
K`SUOaNZSPV566EqQUTYV^7qlKW365MKXd\Q4T2lGR[<nWdl175Z4i2T22Y<3?>m
V[h?p7L76J7Yq;<N_i8Qdl7JOMhEje:JK=c0?T9XNJM1a6>FHjb@6342k1g<Qbn7
H4QjnJQRW1Q4^J0leA_hhEQAUXL:qcO9XVIK]MbjN^Q@52MVkoO21mTgj^E2Oam>
SfkL@3OcaP:RF[HL_IQ4H<hdZ9ciY]IDbmAS;MYaNfLWY7oVl4Aei=`G7<>kA6^@
H?aj1pmKR4HPKKcV^;ieiHe1fHiKaE4Wl]jEQi=LVVBf6[9NB7qh\i?CeLLA__6O
KF7Z`l^fA3jS]@`7gc6jb?4KOZ>o=NIl4j>?D?^VDCqoEf?X6@2KSek[_hb;m2`_
CZlPAT08BSdkfMKdJlG]SiQ>FWl@]g5A\Hp]G6<lk3q6P4XdK3[PMYLmU0jbP=mj
OeAITL_OnQZ?SdcIaf7k:c>q6o0?:h>q8@]E9k62cQF^[VaeGaf^ViTR6o84BDd]
egSQDADCa`JI?B:hYRe51d_O_gLA=9kOjG0J3];LRmnQnaac6<4bQ3lnpP>foH7Q
1B:Q<>?g>=ma0;?pmk48[^ETYUf1NWFE9aM@[P^`R7JVKLP;:<lG5Y3IoTc:l^Vk
CJkY6:7g34@d3ccHSGU4X2RbUie:?HAqdaULTQ<Jji1`e11:_31BRJH^Po<T]cY]
Jh6d1Ym^V=J^_G<P`V98LI>qj]LRI1;_;Mb9W69gLh?UIZ[NW[m;VUX_OSVfCKVg
SI92NgQ3EUW]Ea3plfG3JSCp7A1AIKZ1`E>@V6K@Sjni=aiR<NOeW>Knhl:ZVZ7K
0fUp76P\>J`q>5@]X^mH1ncScLG0g[9iA;>`b^oRk5:?gSkBXUF`8ecioMm5a=Z8
5ZkB2_99P[:I<U6^HX:kAlhnn?mql@>W18ebTdA_9XMS`7_9H^li;hjF;7>mJ32=
VUCUlFijU@hFmmDhD]i@;R>:[Q]p?1:SaPUI0a@n^cKk`9V>5SiQD0jgdAM=UafA
\8BeT7JPen=5:R^WK3KpIFP<1fY<05JeMik^?k`>8ceN4;3keP2Sl8E3EJZhj2P@
97WVX^E394jpY:5Vl?2pA:UcLSVfcd?G\_[ROUdE3K2VP>hOWehBM3`UHK[Gaaq7
UGiQXE[;70en\i2;RiYo<[T]aB7Tf<VFlRF=gBmaN`@YSlehnh;FO[Ep4?\JWHip
0?DWK^Ve6cA6SJI;iAY:8<c`7_Wno`OV0niJAidBFL?YTb[5CURgMW<lNWje42Po
NaR9dAJU23>VEYSn_\YDGXdY_P_hYnj\QgCnO4q@[EYKI^3QXHl^kL?KW[:M88j_
bCKa`FFl`MROUA>kY3cW5DdjN5hHNg_>gEB]naBIJ`D7Wp^l<38:7CUS`hd_1g_T
TREd]fPgZ[lmmUPB7?ifnI4W42lBLONCbVpBVRm?0@QMYQEo0Ei6W44h6Dd\N@=j
GGBDkViQ`h6@?SJonoZ@nV[URZpQM;<M6_pfc6lR47PHJ83OHO0Cfi<maDURa9@l
?ToFi5KM7Djj==_k`TWgURnHVa9H_jTP;gpAWT:gk9bTXE;^d^PnVT<D:9@`Cc?;
HTR9;;moD7g@Tq1>W2fEXq_:NTC\iX8=a?]GET5a7n\MnEBj5jD5c9`bbk`Lma[K
27^2D2=HNQS^DYXPpb7VE:7Ze77n]::@E<HL3k124^90bP9a[JXA_oc8^IPOCMT0
6><Uh>1Aq74T1S4[f_W6PRCINV6\AlVSDVQ5<ec_<EDJ7WcD<jmL8cl0FVX?ScmV
TYEq5I58`A8mdm;R7^7KC0S4165Tn4<b?3fCjEi@o3lH@bX8973h3FO4Z]lpJI`P
V[=qDe8TNVAbj35<BdkUNI[keo^\JQf\SHTUMPV5b;IJibjB4eYYoc1KaDjNp;Dg
EKP2qM`RZ>G8k9HWZ<Xg_J74q?]7Shoah]GNgGiRPCbTS;V<SbbGAS]5V=^@knW<
A6aRnQN44QA?bSX:8d\GcIVJAe:HV=j6Y92kIIZ7che>N;NWW34W2e5[i^aFV;L:
pYS=bcbTKCla9EP1b788ToMg\]MeDOOX:;fiJCJcfL0Lk=c<XVDX_TnEliRV`e8B
G70>dV0QL6Egm_mfqm1DCP4NKCm9;M8SlSKo>g\TI4i>I6bCQ;L]ZbmWFG=LZ6]U
7a8[2;J_p:8Tff>W:QX<S1@[;Q5MZBKMInH[O?WI\\9PB:=A6d]JUkSA;6m<2Vha
q`>o=UYopJX@;KEFjPRS=@<@oGM><PGK<2Eg<>722\^::DZA;=956<C]=kMGUK_[
cqODGkeI]<h:NDe7P=bL]nDKaV[16W?GA5F8HMcdP?VFHC>N3:\5aEBYj8d:nU<D
mOAF`XPmAQqHCIC8F7qS2H@^:`K83\aX?LT=iMoS[mVXTWb;1?aShS0FN[hU=bZU
850l2OBoh<f?1Ji<dj[3LaTU9pIS7B^;<XHR5U1A5NCM6F69<@d=0aHjZIGJnQci
OIKKeIPYVjk9bm6ZO`1TeQI76ZIJd^jXf78ES;_7@0D=9J6bg6WGaaeeN:<?Hgph
G91gWc:Qg8>`aTBOCE<@Bb1EF?Z\Te?E>g`jk;37Y`CI\GNjW5]qJgm<YPmHY6cZ
:27k]VZK1VPEUXgCJ6oXSHU;ACQ@MJ]>GO61Aj:cBR9pDCoKoX@9kE2SBGKLBm>]
?IV9lSWii:W?XcPQnhTZBW\e4H6BkDp^bZ0Lb_qPQLoVYIc27C1]G290RaEokUJ>
^PFXXDpOkHlL^>qk>1ffJ=:oiJ9TFnX^c8I93gPMj6mi1\;jf?3Fd51F;Z17ZTmm
3eA72\UGZ=V_bpbbABa_@E]nQW?\FlWEA=cHlBheB86a<^UA>fn2e<`2K9D5Q<2m
\BMEGYQaneRd0@>Q029WpK?`J25VBN0hKU6nn9IVT6:AS4MoXVhj5hM:NkfO0a:`
[nidb;3`10kE_Yab=CHPM;M>J1k8>g:l\PAf3i_apjMENm5@@00fJRW]gY<58]JA
K0fXl11deO8@8H7mN^XQ[HH5CkV`kO^mHOh5>]CBmKb:6_ZQJM7OhKCqEc3Ub4Bq
S9=KA2M\iI1Gd_R8iYcfU=pT<VWb2]2GYgd9ON<n1igJ:K4YI9[RlJ[<2[q2]3?\
:PpW6mNJkm[]EDjQVc[Gmd]H;MUV?IgJIFAYD8eQ?bkkD4UUXd5_5qSYEo1AWp73
QiKWNf>A7D5F5?1MHVmQPN\D1i3EmaGKKg8UQYETiRPId4dXJ45KnQO0B4<ipM]P
o[M`CU0J\EY\<0f3TRBj5[IDb?J<WMNbEo]IlemXh70RCcXjOGeN4boc9N6^ZP2=
gIiqG<=TbD@Ra9=YTXTE]H>7>>L9@Zd8WkaFV81j`<l8[022kFNncHadnT>jM5lp
A>n6lK4?mS:=R;7IY6CDHfj:U4Q25\>8HRF5of06^HF^je4;il]LIUbFDjQEGge<
0FlJK`oC2?=d`RpUodMEG3paBNbK:Sq[AKoM6=qD7;VJ@0b<4XIHR=QAiFL]imK=
5LP[Aj0F_Pcch\Q]TmHj=P5f@jlNN1p6\=b5>eMjJ0?Z_>X<3dj0J?GJQkSI3AVj
H6<YYClTX\e312W_BS0^daEl^q0Tdc?jD>F926ANhZL6Nf78R=GOEOT3]50aX\X^
NJ6]J6:[PY_C?goEE6\aIUdaYqBOjIoWnfe4Zm<^iK^dGh;8oC7Pkd:DG?Ii^7hU
I\29D5=L6>O:hUC1:VWiRR2ZMKL49c33U[;?q;J554\_p3g9_BnWqLjT>_?KLq2f
WZUZ\qOoAnOdJDN>]=<o;;lPqVjni;43pD7k?5B:q=cSJDX:qSN1PaL;p_1KMEnB
B]_hZ=_:kCYI_f:LC92GomE^iI6IhMj2hc_87Od5^>kejlUbISi^7pfP804m=<U7
TLM9>AfI7SL3`3kSDHAU9?jn0k=Xak5SYTdkcg5O:]dFKTTTanonSN6`URq[:XB6
NaDf\\:1<K1S;QIUbf\N;;Vk;XD]c\NT^SK0oX@A[=KKnkK@C;Umjck]564=;ZFF
M66bVUhq<Pijh;3WCNMNn:ONUbGFR<lob;OE[PXj0\=G@o7bi?J:1X^WQl50BWG3
pbjd9i<7;=^<D3\GQY2nc?<HCa]4_J<Rl^B6GKB5Whf[B\SUE^4gc=P=Apg\mk]E
LiLC7dDcQfbS`BQgoZ1dOg^:\^>_J`R:F8M5P9=il:LmBiXKio?0TQ6J9?ZWGS7S
K56=Ind8HP1bp=<5@C?8nQijJ2cgA7PfhoGB`1TCk_QT>gVES\^_C<?C_QNm4gD8
T[0NnH1oHpjj:l0n]TVe=iX6hY\QdR<`5>7070JIEX<;QgJEGSnmSh4;j8][O3O0
8;<m<g@c\d?`0QRZ]:GEHLJ9?L\On^::=f@R=ZOIHl[;D\4o;<X5bTJ1Bigh?Yjg
@H6hb4`dfRqcPLZYC8UJY@3doKJdSQ3Xl>7obCc5l5d`mK4mG^8PBegjhEG6d6Kl
FQ@d\M9[6Y>=O[^6`CEl3<1`noQiSI@CN]Ld`eb>i;OMe]]m_o<YJbG==@nQ8??=
K\m_^;6g@bpBj6Q?POE<7oYKCLQ^RfRdQ2YjbbaaGhS0S2ZZhDSXfJ6ST3k1a?kL
i[D0ELOoob8P22;RlC6GIlWAML`O`OORo@Bj\NCY:C`<f5<[l>^?Z3AH9mpD^c;>
j7:_=fBTUNQP[HXk7B][O[ooYBZ6fI2Ej7ESkaaQd?8^L\NPEEGdmP90WpLc8MJR
5]o>WNZlQG61B9aQFJjA[a\56h_JoYWTJG;npU1A?Ch0BcT]Z`FjH5]>PkQkCjoN
BnhcdPca]gbfmPUVb<bq4eRS?5Qqb3[L0nei?2[JJMjgKm1p2PZOHK`9[j0@mQen
Bi2ZMLH?DkcZijfRCCA6^kS7Hn:lmdf3d?BPfoiOmmMTbnQa5NO;fn4I5aBdjaM]
i?H]MJeBpA1HV8E=a]l@0oWY[NOi[F^agZKLZ^aSS=oC;cOhI5S8V:`0\`dMXYN;
4OWdDPU:f34S3]cOBH\m9m]p?KNaf`2q4McJZNhWJh:PgnQHPiP:SdYTNUJnJ4\C
4a9AB4jqbO<_o>?p9;EIOEFqO[FlF5E^Xh>TM8jYXB02SNQY1j:M=n;A4`F^]JZR
D=Z>9IGql<8hfVfq1G>327;Icf:_<J`ZRBI50mG6feX:bnf?l0[68:_14g=OaAVq
ho<<9bKd]L5hCjkTmb93MaT65M;N60SAkbVF\R>S?89lIZod?J\IgG@LBJCBm2QL
o_PL7e3:R50416ncBJ[n>Y3^ZTjWaGSMPPqX@?J=E`p1i>Bhf<qaUH:Y^Hq\>29V
:BF4HMCdZ`<E_]gT;J37E\TB:^_n<laIAHGnZ?lG8YeUe\Xg^_ONj5[:T<kCBA<C
3bO:B@N]?nK=]\AASKFo?_lc70KqKh?7n0lpF0dmM>m6;O3>BZIC^2^MhXCWR^4G
BhdHXA:@X`8k:GFa\OBZC11BpD:j]JhFhc^\`WcCOD>GO\_YhRTORmVLFWoYJRXZ
F8D7Za_6kFD1^aOX?`ZX:kL=dCChYEhYCcLNU;0F9mKdd5=pfVagQ\Wp31a8:>Nk
oan[UY@eU`TMh=6`m5g;<Xjc[COY@C10mCVW4NW=5NWFoImA:Y_mSToOfeQ=[>EX
`iTUSNg5[iYbhI>NXILCIXoQb?E\@H]0XZG2bNkg9\Ql[6oIWW@FP;4oF:aX[;CC
]?E?cR@Z63m9kS=IA6jH9GjRKR87FeOM7dDDpH4MU@gdAh>i1ec]1LMRK8liGKiD
XMCNRDahnA\SCi]3VRY[C]a90`KA]15K^b9Cd[CaleVbYX`Wfcf<_ch_k_lNf=ZM
j@kgSnJH9[V:BC3[ifKinAdBOOUOK0enDVmSBjOADWgSgddeT]a_9iIPI=7V2MTa
Ri`jCYn6_kV:LVNEg14_k0HphXn_M7\m[K_<Wl_0H9<53lda417b5^hq`>nb3I`;
Nf]fSASkn\COdhZi]_HghM[Fkd3NqXi24`k3\gS7NhF22Z_Jo:JND0eeh3JgCE1C
e<Elnq[F[I^W55LWXMlM8W]]8930l7cmFS]^81@7j7>46IkakL1XpBCnR;J\8JJU
3_E<J>]iPm<h6RKTJjM4<DHmiV\UgdOQTD2=kCQRGDY[1S7nl\4Rdg=qNS@iPX\q
W;>A[l=Elh[>]B@dZj[=CC^66STjUiLS>bpld>_69mpkaBF6XXLp>8C^ULPpS5nF
Pdi4FfgiFof:8L<aQ98GTR<Sh>A=Y_q:9Eg3:`plPIEG@Y0]VhcQXH6\c3Se?>@l
5UbaMmpHg<PQHBq4108iB];YoB;Lg\_QAAb]JXRdfGj8\jqn=SaD0Ean@CB=SQJ1
R2>gYE9FGbbSSpM2PI:5d__TMWm]=a19YHTQI=9_?dan?9^598n0ULY0p;8;T]k0
?HY\gZjQJH1eJ9>M1I;G6ii0eV4a@c@T1knhq2G=PGCAGGD6H1[JZD0AOZBLkHS3
QHN89jeHKIDp1BoULZQqe0MkaLQVaQMldM9eE@OVl^`X>=Hli<C?^I9CaYl`0ehD
>L@1dFoAjP=i2gT;H4V9qR?M_DXDqY9e=@e\2F[`<V]C\BCSoJ0Zo:Ob[QFImkCN
<_YTdjd>DlFRa1720^8o<T;9GdE`FD_fqNHDU`LKRpWl1[G@<q?KH=PM46hQ1>^1
\01Zfh]ia0a;6M@a4\c;ibTQfSIf[8K9`3B@Q:59QB_Ai>=VkNp2;YTFY9p3jE9P
`9q>_jd^ea6M?;X^kaI1ZLZHh1[^H8?l;Y]WdaFfQO;NY=hS2fN>@=8p78\82XD_
h>g9fmlTdn?CIFaRZ5oRdT=iY1>3fnShYo2YfDAN1mma9@bEXjW4Q`FnD4MmSo6h
_[1J:bFmq9lEjR7@5bQV^NHR^LJmU=Q;`;6;a4O<Ef]Fjl46\@a@DiD2kA1q=8BC
n71pLMm>CGn:G9E<`55WEP9N]_d3p9NbR0TVSXZPGOGCc_2mJq`h0WMP>p2b7Z0E
W_ML@AfNi4O]AaCH4YR2F<4iP;`5UH:kTXk]oDkl4D_Pb0[dX5N]A52HIaHc]S0L
32A3BRW^^oUXqbcR=8I1VNeSmg^9VEUQI_47oZAU7mi;0[G8eQED7c2UD_J<fUI0
0L1dp3oCgd\MpoOJl8Xdb1L;eo;ad=76:ESqHk4WJAPpXC@Iam0b6:N5<=W1Zn4J
j?23KVdo;Z@HYK@N6SEa`9nmFYWaDV6UZ8^^S\V[j0ODOY8h\X=PdQ:dG8HOXBAp
C]QEiF]p<VM7PlVDq`2_BgaYq@3:CBjd<bCEbmJn@;F7nDEaU@2HkHl\WP2[Lj9K
MlcON45p6lOB3Rlp6>L1_`<pJbHHfWVjAA?9loJD>=dY<P0R=H9oE^8O1LEL7\I0
c>Ul9:NlBbn3pn701?S13=2lkI]aGaQ@]U]DUY=5MUWAiLLmV\>;d`<n^<]:M8VK
_H?j@jUR;jl_@Hf82Q8aWdiU^2f=<C_m<D6Sc7VUmG:K1YTFZq8d8=JBDHDd1fQX
:]3399QVg>WjLD]eK0[\iQ>ekcRi[kfoF7A2@i__:`2GE71L]8p18g3@mUq^3LlW
o^VLJDn8nO_fAb:HEXIK?^Pof;3m?hQfJ[SOh>O[T5]K^jLP<8U=@<J`6i8;FEIH
OWV;D9nIS^f6WDL_VUY>`?HCj]Hg5Oq[cIMab7qG83^9e@j\44Xl`BqCc0@Td1S?
2O\iV7_c:aCN54NoeUX=F:K?3o7\C?42^`f`T6HE4l<MUE_VEF:R9fH[3UCTk_db
1O1g]EP<Vq5PEX@?kpjBm`@Klq3F;@hDHp81Fc9@9f6Qo_d7K@l1fKNDIP1_Si\Y
:TDd0>42;B7XmdR=\bRLlPIin<QMeFggXVhL2JS3YjmgKUNS;3k2kpn3O6[_WpMm
CLZempono9@l_N@>eGY3Q;lOU==>aF9[hZ2^LqDh0K9o2pL^JZ>\mW;K=3Yc17g>
P5=c4UDomjULV^_=P?<\X:j^qPK>BURF>RJ?B;I\M4JlG27dZ6ijGRX<0H^[cO[>
>:UR@pj6=LAA\;cS3SgZUDCQKVAbHAHoX<oNNG[j`G_=p^2=53AGp9RljIW1b7QT
Ie0nMN\KHf\;ZF;TYO[Z\nd6G>BINFfKgK:6ZN^1^pndjmkSJphKiKO??pX_0VGX
apLK_VUgK_3h>182j^=YImC3G1Tnn4bP_44WALN80o8Td1<i?I6`7>j2e2jnNf9i
\3Pi1jqY3]W]IBZ<Eb:W@?A\la8Mn`_g<:H[iEP<@cqXQkJg>eph6FE=o`gXPJgG
BgPNaY5HBWV^@A?PO6WR@9PTO:Z:mPS=DlYaoiGpE=[h1\TqZIJYemjqWZ8J_2BK
2PYe7j^a@>QO:L8:h`k@T2<RWJZe8?62<VX9Yf^Tf\6H`MK8XnIKqOkhPcEPp[lZ
2Ki[Ko3]5]`PT=Rfi`en3PLHeM4<dl:Ql6fUlHTR2c@RU:P1W`iYP3;`i06QI[:j
i=gNHP2VS3h9=SGR[5nRlF^GR^]KCP;IONb@V8>?h:\QpBUfVJ5ipn`hZj:@L`l:
KdhDBjmb<2lgSTI:39YL3LEJ:YYJSm3O8l9Vga35:q=1O[N^gqXe2hV5GhSYVkSl
>WkCJMbNX4kR0kgUYY18lQ:Fn61Ip^3?LTUapOFfFCW7M:ZTPYAgKIQ90;gY7lbX
KD;fSR4Y2T^0dWfD_n4Q`BL7`p9PAK]7Xp74[G>FmJVLm__^8PQi`?cQVTXSD7LR
QahRCjRNa7MmN]BYBe?WMel6qk9X`NgMpbmbmY@=pjL70<T5cQ6@S1:?hDB`Hhoh
imF\>cbV`<VdBDJVRdYN9B@Q6?@;GpHjggg[0pkQBJ?gmq2Uk\Oc[qg5E4WVnp4e
Gj?LW_POG;N`g_Z_fTaTMY<>1N\eRcW3@GHe1AogMe4EIlV3GOaEm\L]@?HXS^4@
GFD8H^W@iBbToRKic:KebF>4f>`jq]KTkgHnVEUH03d_nKVWU6GmY`Cf9]M`;HaU
D_OKp;gWQ=SLla<`<WTNJO<pT7IM534>b4Pal9j]=cWSnBKHJ8\O`Rh5Tk2@gJY>
SmpeglS9M_=IIP`DfF@<JmaMV@SXZmlOmp[_30iSEFSMac>kdBGAaUk`m6LCAgk9
eRNS?j;QqnHGmlX2q@05DJA`D1YTJP>DK[lb55L\R]UTILN]GZXmF8?ZU]P6UqmI
ST]HB9<9MMnD\NW<?1Y1end\G^Q]P360^`bmJlME5VPmHQ@Cp3\a?bmZqBiln>Ya
pNmj48>1dYgc\LQU]D1l6je7qhE_<Wnnp\IS9JT@W99`4dPmE::1RPJkITHoZ2cD
b0M=pigj6c92p1A_kNacd2=a[Ef\kXF`P[?a2NRa7UYijGLfCAP9Hf=Y6e=O5E27
Gq4]mPOXAi33`H@GdVHbo@;k^aUda:jPkd^HR:W=b18D^jqX;[]a2_L1mYKdWP72
Fk25W6;?PcIOSlJH]7G1`ae@A;b1OTafbpC^a5?`WqP>KI>DjpVmX^8NEqFkQ05_
H91C4>aKoYg3A:DK0nW9jW7hLXqPEE:A7QY5WTkY]GW[;Sp1VKYhKUq6JCNFURF3
BnFSKn5A1UYALKY7o1bc<_:Wl4NbIKoRFU0?HDMpnX8A>53>57X;8VOiX7;>CYKN
Q6Yg<?4gqe4ELM>Ep3^e=NbFBATnaSDmJme8hd_\0ZQ<j40J1Te^>19=E1?1hqC[
@WK6fQehTnVV`F]dYHQ3]ADe9B;C>T?9\:2<H`5X=8AjmI`gqVaWISX][I27[Rg7
4KDMIogc]cQNGh3kf\G9^:knkk0K9d>k6SeUXLUSfblp8CTiG^cqnfl>mFLp;8Om
[;T9T[FUAE7P>UCqY3AI7:Tp7`e2fXSP][]i`Qf@;YWnDLI]CQhR`nQi;jWg1Xjm
Q77:4?=4=`p_iJ@a65qQe:`h\^^KTVUL<GA^3Z;IjN4OZeFMFf:mckdMZK<YkQ`e
R2_30I3Z92qXn79cLfC<BkAQG>N7\Bda;`5_[0q0OY<?UOpIdnJcXcZhHfS3d?g8
3Vm<4QfB^QRF7JC5a:BX7Kn8i8UqnjRKagGp1Y=5m7Gp`\SB\]bqeZ@6_7L9X6LJ
B`S:hHZEfCc[SHH[Y>=Q6C\GZ9f[P1HlaC?B;01^hLeg>Woid0\q6?QmU9mqc:F[
MX3qdRZ_2EPqde2>=\<;R_l8MO7_bef>l^YX1Bh3W0O9LPQk]Bl>TbWYIYf[HhUA
FgeqI1@WZjOFYdTkbaHIQW4pLTcJ8Z<qKoK?f:K;o3ZLML:emj\nGLWFhU:nKUIh
nE0R49ZF=?KMUlL7m9qE8WQ1_dpMeoDBgIa[j\C;08Ve^nkJZYc^0HF\S5O=[]G<
Q`YSL61p2P2mCUhqan7T\h`pCLcC]XFNqM_7=oF6pZRaF`[mYXZR\Tj28]VfXa;l
e;]IfN5oYiL@fcHX:LG`CpG8F7;Ha=lNMbeXVcoEdKIJ44:`KGMBKLPbS;Kn]BI1
d8=0mUpY9OlL_DpK`_:QZG?KgAI4N9d20h65RoK`29>=VI;c@U<QbLJ9CX@p[IPE
AnYO]\FoRa4f2Q1T@^J89TNA<8JkBbNDFfdQGN<q9;`f8Deq=0>Kl9TpoEha]Gdq
cLb5m:iqTQ5BR2KpJYSiAc8p?RI3_7cd=>3NE@G`l?eLAcUQONU0YeM9P[VN:HDA
0cC0`^?4:4J3KPn>1;Y>A;UI2;ZNGkWohH3nFc_johcD3LJ:I0\>q4QLK4Z@=:Kb
Jfe0Z<Mk9PfT2qkVio_I11hJl995bmZ9?@NfF;^H>X_B:C1M41RlXY9\>Nb6FBmW
`8F0lJKmIbZoWG0gWBPoSgI?:kIBe8B@=Z402d^[>@1;Zd?`<TU7mT24LCbQP9[j
9F9N`?B<F69T1qPmcE;3>Di>YR8NNB4iJ4E?\@0fOmpRk2`Hnf5=jX01]\O1aq2[
hI_6Nk4d>WU>fjKnG5=7m\a^YcQUW2YC8V==c@EQQeNk:D9INa;c\EhlP6dnR]NS
Y:n[WL1E_2Wo0bOnB5]WQpBM94YCKLb^=D8lLVZmpCFboM=IBNcejE:iF]_WbfUn
34g4JUD]Na3P:\[9>_=JDKk2=54J3BL1ZbBNTPDf28FSd1N_X^:ebdeL8R0oQoFU
P7Gi9=F][3j^Q7BYYK4HBkRqVS<ED3HXg:SmA9@8ndk1PVVJ_>bZ`E:`GRaJmE[j
=LT7G1Q`mT<VQg3L9X\A0kEPW5laVKH2\I>IY<_EaTaqbYg^=dQaN?E[d@T1h@=P
;\VVBDl_^0b8E3hNOm6;Ae5knajTq8JTeI:gG7J`>okm4c>RO0\oY3<oaoS\ScS@
mmWU]8IUJ=Om1T7L9\E]U@5^dk7OTMmXI9O][S;`U`M9mf[ip=d60T<ad<4m=H2N
DKJ`?=FdE[1=flnA=70OJXZKI`WkCO`G4ITcQ@`jWi:mo1jEiAQCS^Wjb4SgEoag
5b;SqDe9ToK6WWl0Ol1QR9aiI<E<57g>9Ogiei8LY@K1;k<OBJcS7Hhl0@4jHTV@
maPd1[]gdY`6GZOO5df[324<qaQVAXaNj54UCQj2J1VRDQTg]`]k@^TL]EJdS3@D
BDdBVHhofZBR=Hd:7_GKKHl?OlK=eh]C`E;[LShRH`NTq;@m2GWQc>dSc?OCg3aN
1LAdPInWfa6dl9<d[@]K[]m>H]3LgiKHQa^gQdA`AT>[X<S2i;\]^\e>8CK[n@Rm
q<ZiXfb7JYCol0Z6kmdm[@\Y8M]Meg1InflAFHhoiW3NQkj_GE2B^@efGjYn3`en
??1AL@NN>GL>ahgAhh[oqOcF\Gfla9jdG63?LOk>FYf3]5jbH8n\lPQ5Q1iS_Rl6
0IN]1FZP0a2K5A:mZe[VKBPmC9HXKc@[nIIF?Fn4qH>g65@9j3NNclKH^koObXLM
c=goQcINU?nb9[R7nWf\9Z\6NLQARQeO_MJ\F1_1TPUH6oBdH2TV5GLXnPTBq39M
5NIeHQfWbVUZgR<d_8[gM2ndfCGE=i_XYc3hXcE22E=\QO\]d:IDTCBbTLUFnLYl
blJ6ahYS^SbN8\@>p?XPJaLDjlf2Pek;YiHF]2EVWISn9^dhH7N0Th8gB^anqm]2
E@NLPMZDOKmlUXOmUnR\Xh4W2[Sj0:PI\l:`ZYK_bNXVjA;:_VeC`YaP?[86ghnB
67kT^ZP0WMhc86l9qbhc2FjT<@hEJiUoBBLjgo;99OjalF;lk5E;9_UcjG0KYLlh
0^9EY7f[VCFg7cFOWHZHl`BDCQObeQgOF2jkpBoSR;<M3Bh\e931bTI8UiL[KQQ=
R3DUE7UgToRBoa@`6IiGdlC1RSh>hTl6fZdeZXmjVKdeaV4NaN3\@Z``p<>1M;AX
DhBY?lC3@PW@=<>_TQ9E9WMbCUMGlQf5?8Gf7_`E_I=>90fai5f6LMX0WZCpk8S<
K4goV@dPi=GgHRPFOF[2H[[lfA?NEBbjQKVPNa93lTn:`BFhN=P^\@1[UR\aM1SF
FQf8?7=O:GQUMj=ph`Lf\=`HLTY@6]f`MbmnWQ7^O^L_I0CdOCoao^J\W^M29R:Y
^YY>g[6WVFjDXULCg97P=JQ@=7@oN7?ZNX7piKRfk>NWXKSd8RfDMQ:506n^<>cY
;8N<e0dl4c8GI5VlKEQAV>9eL7O4B0NkL5:_=<>Qo\3VanE41TO?J08qlah>Ub6f
;mC5FJG71KY`6Y]Pkblk[:aVQJ68^YSnO[;Fj;K<;>oLecjiXoH4f]YGg:Qn37BT
e46mcc4>NYKqFi[hKIIcI2O2>07o>2ZR=0;Z:EVKfik8R?RF=GENNoH6[4f7I@IS
fT5Gc]5ZVEBdo\c1jjGUM]4:DgWcMRLq7oYS99o0lBT`mL0U=h0\WMSkJZS0d]LR
G^0j>;6[lU7[T>WEfMVZ5:FkkJQgd2NIR;k7iXG^j2LPRFfa7kTp=^64J?cmVn9c
KI3<XE]XTlSUbTpekeUO:2g^NUbAiDbO7MR2ok]5mjBF:NflkAJKbHTc12Xa]1?N
fGT93W26JGX]P_E2O=G:PUI92i]J0Rn[e5pHne^8nY:@?DA57FI9ZO2a2YJ`?E:h
M<VWmjX^?0N4cLMn\XWX\:i;=1V`3l7TJe]n^Ne16kl\jKPLKF@ILCp_DeKJ_Lo1
Q^OMFJh^o3?RASo<HD\bC;kFC4^KM5K4`F1MIlPE=E@5UCPlLiLCcFaK0M5O[d2h
>_AR_;\UIcqQk2giP5Y?IRRXfj5cG`BF0EHPXOHnE;5Zc9k3_HnJ\WG=P=E^6eXK
W6U8?KJO0STJWkXK4kSlCJIaJ8WP6lq9J:jTPkS`R=ZJU;NT<=X\[i1\WDb3DhJI
fobY6hMI@Q<PW\?Q10\[G`l]JGn4BT]mE@>;Z>H]cA=2eM2E17qF^16>FjD3ePo\
V3>LK@ZF`\?2FUO19K?ofke1<a5:JVW2I]dG@IHXlBUhI:>m5in5P]UCBPo>>=bG
1nVbZJpQaNPXM]LDcOaBEYXc8M8D76PF59ZE`JfWAM6HeZj]I`[0Ea;7kUXJ7ggN
<RaL]V4E>\T_R@4[f2kNLOV;7hqb^`HA>3>I0dGU3NbVNlPDXE10cC8?HF=Y]mTJ
?<?452pMIKBS`__2W`o^ocHO6Fk4C`7Cah[E1bTA_[Lfj9coeh8eOaCg8FD:3g\i
G8gl3Y@WP@P]CS75XC1lFX`RSXq\Y6SU`iZ^AFhW]\J\X?k2Ka8N`0CK<XHhi@FD
39pC>d>5>3X0K51<hf4`OTebTLFW;d<\mpEOkae?5YCD;RkSQ`DnRlWQaUFn>A`]
PI=VoRc?gpm6]WfW2A0^k:JPPKc966T>n\b@>q181[XBSdc>AdnaoZ0RcPcR;K9;
IM5ZGLfKa^aYIgEbgB1OPGeJ@\qDVafiCQjna2B?k]ib05qX29mJUQ=LgmW6kgG;
F6jeD]OP^RnEfk7P^8Mdg]5[B1q;CV@ZPpE?Mm42IqDlhOWQb??V[>\6;g>fjCF^
1_0mJWnUgDqERBAYL_I=ahcB8bnd9AHUQ3T0FU\``kW4d7[W5?QZM<17?n_dEMD?
HdAm90WfUmUEckB[o8VNl6?Obj94jIHdJm4_`_;3dIoDQE7@c=iT7\bXP<ne[EYR
8;JY1_\kjOcVN<@4;WGVlSH=F3[?[`TT;4m3MGckSGGQQ7\e_Nk:7V@Xd]=M><FR
kNM2Odad6GAH_qT^486gjp3CL7TbZBECP7M0PH?9Z>7c6SUWTA=c`aA`R<B@;Lf@
H>UQ0Tf7JXK]5VS69nCS:Z602YGAnS=7<DiI4p@C=TOl`3XkO]X5Y9qG[o;D]5q3
\9;o>Sn6_C\DSAMSC;=PKE\Q6EL?];7ecWNc1V`1BHPSELT]Tf1O7@_3K3Yc\`53
U4ggN^4D[a84Sh]pe4HMIQTpdFg:5?WpQVXD@=EkY079e>X>83lJ24EWQN=j5>\D
OWP0f<G4oX=q@O7n?IDk6a;`J=QWDLJ^FCh?A;LNX=n?XAHX9Zp`e^c9ajp8mKGO
1pTcA5SlqPM@4dL2Gg^6I9ebW:VBaIE\k5I\=Ie>2]IAVRa9pGfgeOL\n>Y?_^ed
jN6Z]A@nhiFMb9EG]p5G7@YbBTO<ma]VDNd7maCD?N=G?GU?\>h6pO@ljLAl3@Mk
h:R17`KA6aKffl8YV>27BJYBXWIL4XHI8Z_hDJJq1ZIJo>d7^a=K?c`P=e@ol\Tk
0DPQ8CMBHfD;Ujmf:5qd0@jgJqggD`Xc@pfG^R\V^_CBf?]RiTHkn>YF?0WOK2fA
ogA272Kj]Tf5LpKMQolLD[YHXe>8V]9Rg545::]OBMP`EgS\@2oTGTkS`BENDl\o
aETgUEI20M52KQnJB`kJL\\S<SQfb:\QOeUJ;0938GbN3C28Mc^iAck8AT0[kbhE
@S2Ql^[N1lb7_dFL>kK]D=n@P[>8V]SUljIX2AUAhJ:`fZZEa54R4h13n`j;Wol4
pk:94\J2pSROea28Z1eVeJ=aC50k5^Fi2n43:_:Yj>Go9_C0n1J?PXE8jG@6?AkQ
mWLl1<2VZIcDI52S1Je0f>SXGaJPM[F^8=IFE_X\>CBjUBOFZaUFe:Dfehepo@\I
U>0pMKSOA4OoVfXTVU\`Q9IRLhRe`ngZ7n=CN3;1aNg=pC8\l`?lK^oL[dRRfCbg
3gK7Efn@8_MkBU@f>bNgXjlq>W2>[\Pq]]3W8Lqd`m1I?pP@ePGJ7Vkn0Mf>7cPZ
9L6]NMSeTLmW>_oB;Gog27IBpLGOGOf9kTmC`6U;\gQ9ZE<6Yd=]Fh\GZRYqjCQ`
10f^Ba:CGb5F\TjIeMJg>`6Xh2QJQi3qiUR8Y7REiKRg=F`9MUm6<UPn?Sh3f6AQ
REoo99AhJ77q\8Ygd9p1PFcoX]p6\_bC?0\e?l;F^V2`oURo7dB@V8N:lM_3N=ch
AfO0N60IW]jPEhDV^WjCDPS]PC0pQ^Goa\9n`i8J3WD9S<VlBjI`S7[63l_\Ff`N
>1J0:b:Kq]8<G@8ELL3@RG1==eHM95Meb6RM>0PbMVMOE\WE9\7VhRcHMfRF=4_K
@bhLSaI6CYNVA2`HYi::KlIRaUb_@Hj>GX1fK1W?3?AXRGob6K2Vmc0Nm86N;5WN
VIUZloIkfhl4aG3_9>3SlHRPU_a?Z031J3GY:komDGMZR]n?H>aEmT\G4^98\SA9
XqOM4;o`?qGEFTgn]GhYfkB]b`@=ZS8lLBOQ<EZ[\S;5qKNdL1>UG[_I:=olf:`e
lH?B7dZEVE?_=P4V9^g9YQA3F]f3VFV;ECIM8iWYJNUjD42A;^]3KdHoF73bV`U1
Mi>N:dAA:_PNB?J67\2:c6MD0U>]>8okahJpL_Dg@K4pX443chgCZb0LGCG5bW5j
F?@VcnUTKC^88KgP6kBTBlq5X6f@QWq=o=KZUf\G=<DAG3ip5G8GHmqo9QPnDq?S
Hl3HE:e:iZnohGmF:Dn[jLKaR7AZmd7DYB=3dp`H9NEeYBC90Fc^AF12BCZaDI^e
l95Bp5ZoVV5Jk]VZ>aRd7b3ad9lWfmS7`]2DleioUNOpSm0E8bAh^gEO8TPlHQoG
:d1Xq^U<>4`bXked6=`MZRoBQV61B^mp6ocF[2h9=4d7dLaZI?NU_cAfD0dV;Smq
UOij=;m]l[3MN4DW`JqVbmLiCpRgELC?2pf9I@`4Yi8_f0]VX[4B54JkpOc;9AVA
7R[S>a5RROIZZPl_UFAQ7pI5j3^FbI1f2NJa_KhjI7WU@KaK3=CY^oo1[eKD^Spm
5SP[KlM2G;PZ=PDdJ`NSSDF0:o@T=DUiN1]@O=[n9l5@2A:lME^flViA879bSeCh
mC>I=nJM::YpQPNP`M[lR5aH]LeOLoVd^^;37W95O=h2KN6o>K0Ge;W8hDfO;SXY
MPddF6q3;\:l6ZcHU@dAURd`T6aeeYRUY@fb?`D=Z3S;oRJJXSGjjDFCPhG5;N4I
05EpSInKS<e392QAImHBKbmpdef?;UBXHSc>]Dl[K\1S9hMAe;77FVDLa0iQ0oZi
N2cIVATSULjGCY5M`>n2d2q5]kA1JLI1\Ol;Z\dI732>^d3X]HaS]_fGkhLNYBYI
>?3GKLE35jalD_Rd`f:nW]0TL@Rg89@eWbMqoJWNReX0nM2CRnl13^@HoQUZW7Kc
[<2jE;^a7Y^CDTgj\nQHJiaF=\>JWBq?\:6ho\E?THj4E0;^gRZ9;D01nW@a]`n4
_E_jgOOQo\H_Z2eUmRQaZWZb0G504ZpnanQEc3eU_H4mRZ^e0L3Xng;DAfIWB\cq
T8>0Va0]mIV=mH@ZohUb@K3S3_nq<Zh?<hN=n6HSSQRO>MPV[QLGZIg=:m4;SFBN
;2_9ndRV?J<iMZ]clOS1@e2oD_KScm6S4F]UZ7mq31V>j1Fje6EaUITIoYmo4fJo
I=IFC8<3omOT0VlacnE4Jb[O5daPm@KfSi57ERQ_0M<U2iXoZXI>ql8X2WQnFiNH
XP0jJQe?1HVkaPf528eX>:0YFW8YiY:dn7f@Bd`1><@[mi@R]H]CAknYf>>Sd3RP
g@>qQ45]j`V11iSY@1qRkOA=gkS5C]X_8XDa;AiY>bKeVdhS3>gOQmY\43^:KRId
CHE2[MU]\Ie881:99iBc>32Wa_J7L8=Diq^]j@m2J@S6o>Zo>Q`6>KO<HX5X0Oe=
iMTD?TS<>cJ277[0mmAel`lW4`ANa`\bSQBlL2?ARJLdQ5O2q4MYKKd2E?8Y_5a7
kA@DnHJ6bKe0Vj8SONge4d[^>SYm6Q29`f1A0cF@bISXM0dni8kj>ZShM^GJcDaq
G1leJ;W1gc^QLJd3Y^DnKO2E7icY_Ebem2KLL@kaYg?Y[XTO;MkBJYM1`=C\e<HJ
\:^aflEjZ=S4f7qY^Ad8]0F;MeEWZS]:F;oW]1I37mPaQ6lE3lID1gbn\T4qK?C3
408FgIF4\<nghdp`BZ[2_[5oaga^8\^eJaFJ7CCo=;E>jBH>h8PMNCPI:oAY4=^O
k\L9]CHaJ_1_h:q88ST_b?VaK3JFESHlP]NT`1^hZ_5DKSBjAIJqbge=YJ^1>6^Z
SQJbZ2k4Eg7VkBFh:XnIKToNq\cM>F>^Oh6Y52ZY\<O5df4SEV6:Xla<GO>5GqU^
63CT>@5nF1`\k14<R:jH0kTi<chKW7gC^`q\[ICKLeLFPkLL89Y\OgRBAC:?;e@W
5`NNR\SpEJiji9@`MAjf3K6\TOVL?7bMLfFeV5]3EkUGqkT3HgMYc1R573b`c\S=
<9Q`6`<3aX1W0oJA8JeT[XXg]ldD`ZoTSen4C9NMT<;_k@Q]H25ZBAilmD1q1Hoi
94`T6GlJG:V@jHcdYlf=J`_38K1Q]8:`nVCdYU1[7`QGbf8353fmkYqWnLL]VfR1
CQf=iFF6V3JiZK`mTRLc88AJDZJ]Ld`7JW0pA<JK<j\KYMO_AXP7DEA\[_hnmEE7
V5UjXohOKbEHmXo6@h:N=0GEZ_\L`Qhph73h<Nd8BUEI2R5XCJPYSIBHl6PZ^Pd[
\G51KDjAWZDT8i0mj18Q5?[?@hdR?eCpdm[Yc^`j2<T=c89?GTpRloR6HjGNnba[
R5>87:?XU;a9]O@VN>1<Emq:g=ikfDq?dO3ZmpdYBNZJ8>n3]JJlhSbdAW3K[X@=
pYE47Z^qhi\PEFNL=8AeGMZQ]@ie4hjU1d30ieNI0HJ`VV5`qkHM;MHGL<0SW@?b
Oli@j5\Ye8mYBgZoOq_ah^cW?9Rb=fBjR\kkPAQbi>k;GD:?1T@7OGiXpiIh?:G6
oL1COKC:W@LL4M8<4_=ql;K>GMPd`6ioMe4@^==oDW__9DqLC73P_j5oI^74=b:\
Ih`QQcIk4T_UTUTBbc^9VD<QdeQJBNDJ?Bki@20@DHNFVp;Zm9olJ^ZoXmX`9;MS
9L?OFY]WF8I?8q`i^4LIp6:>i;egp?hQ0JPKP1L6d22G2T`:Acb3p5]Rl73FIE=>
6MJjD;fmLWXkePBI`pVhZ[h?;DJ52lJW6DnF6o4;`eX<1hjg5M>MW[3W0@pXe@9d
;FGC6;m0QnFVHW9OnnZ]^[VmM@20S;P?a`=jLKXh>ZG4_89lJo0<V[[HX@743SCd
GF;;MNoK:G3<BpEnUKChB2W?]mFoG40FcJWcU;T_A^<L8IXCAjEdN9l2o]M9gWO[
JmRP[87]1:ZIBVNl7Dq9`T2U3>S04@2<ZT5QgQQ?od0aH0<P66e`]k2?1aj9AO5j
REB3jb7obX<DA1qY@Y6MTd]0@fJj]LW0VW4NY]YnFT7<i2MLRI23Sj9ZUN92W;S?
LamI28d30pk37Th>n842JG0T1DQfD\^6`9d[fYjMm>:kKHl;35ja_Nj<n2AUM2iG
8m==qa^HKg2af;[=M^g2ELcV]\EQfhY4l;=]do6U0Vek>AKf^;CEfHAa4VgiTW1q
TcAilM;9`mAMdJA<E[6[IG?A:5e86DXnn8UM^EgOlLo=LLJhg8IfNDZlOHpPHcBc
G@_Ma]_0T`Xo87Dkbq@61@YE?_a2E\:_>4d<_[1HSL4=?ZDdT4KdFd\MQ>Vio4RB
=5LnhZ5=Ig^Pn[iPq]70<9]gWfQVN07XMeQiHc0]_4D>H84]aqKJ\gMeoSRTZck4
8eXZ[ln9e;AM82JV4[Vl@DT<NXD0^m[_?M=DfO0_1oO=MCh>8dMgdKg1ogJDoFmi
?<FTpjon8<e7boZl885M3g[CN7Z5kG55Q[81SNlm9B]<0M7bdRQHf1n4=>U__lRm
peBcM1W=TH_k[6kVTD64[g[?Db\V5WOB;:I:WU@B4XP3AKJmSP?GS4L@k<Sp6kT5
E]Re==XiG7i4Vblb?C[[hI4jNQV@1I>2XUoGD8UVLm>Yc>dSU6ngV6p6Iab9PJ:K
FQolBT[_51eXR\b6[HbH00l93`XfP1`VF326\:LKW26JBL54930qT7mmQ=B>Ogml
ia0KF<a;Ia^0A`GPPWGk[81^6@3gOO5hcLoePM2;BGFOVcpQAE:CTFQnRRiD?]K4
WXaX[L\dA5WDGK:XHGRfWHFjoGk_;]6Jo_LiYVbhlhp]UZB8oC4l:H1GF<PB>Y14
8_>MoDVF8fK;a]MSolB?=bQUSPKjLfF`lEIJoA9Dmp1T:;9XT:ca3Q[]7oaGNEGO
0[iAJWn7>C_S]W1F_OG0G4bfBBFM3cP=lR_I@fbhJ9?_S4JS\ZmU3DUmq7]U64cb
U0d0kdIGY_DhMjePUVWAY1M_qIT0LYHVaAXYAk1jg=i6KkReh\iNJN7X3Fdf<TJM
l3]aZ;PB]:^`Lm6LkF\FocjNgC>kcOZbPCUREk`p[TZ;\Pb;e@Z[k^i=IRmW7>>8
CkPN4_^qRQBDX31OK[]f@RcW`nZGN_I94c8:??8n3W20KD=d]IJ8@GGP<ZV`XkD_
42qg<6M:QY:4N3Mn85o_VfQKMd8449WPZ9;n3n3n[T;Q66M@0>lR>RjjHA@A@mC^
SYJH:G^8J]Ta_`q`OTE[i0_\ni=2:XOh7XRWS;WIUdn0A;4\Vj_jhYKWm@`fn[de
QnVZSF8R@fJlJV4PPdI];ha0`;pB\8`ME4H_DKAI`0HfdW1Kb?PDV\m_QkLQS_QI
lK=;36RDmCdKUY=7c2GYRA>@AdKcD0e:]MYaonqlV[i_Ff4l^cWJVQiR[dPa^_i\
f_Dge=<E[EZNIbHW[?27Iflh3PaGjbjkGnfHlDZEYpBUoM[JVWSD2MkXNX]5E_6I
1Jh1;>\^jQXRocaU[LRg66=JZ>T@U]ZKn2><W5IdL^n_Q\cl>g4L:p6Z:cX>R5?N
mI>bTI:g@M\SkP`Ef_RS:Q=8oYJBZZ4[:mYgVPkMK;L<7@dV_i>@MdFlK>1BdBmP
jqV3\1k3RABD?TE4WQBXhPbdAJ?DGn?XH`8fW8:joN__;DG[oPMYYoGW;iYMP9:i
gcYkGnG3dTOh@pOlMJ@:^?SPa=2i:I_8C2XZ9QVJRN[No`b85o5eCLSRgD:^D2ef
f1J<?aVF\8\WNToU2a_<6I3OLVpYHCoQIHi0A:?o<dHe]W[9K>:n>SmlP9J8]>TQ
6_mQPNP`M[lXH[`JG;>n4=4PSmFNHkMDYQHC4mQ:CKp`aRQAE^6[hR]eAdb]Hkb6
b6WJFRWDY5F\=XLna?SDHUPU6Pa207O`E@;d\gakX:alK9f?Q^h?@R:eA?bccq:_
Kmi;DbGP4iUY1^Jf61m21APf8fZ1gj_=]7aB@2Tg0Q5al2T8`1;djQRbO;J?AcO]
b:mZDM=?4jUY`^k\qJQdZ7Z`@QW7>bAXB>7FM\A[MQRO9KBe5IHo<[Pd5dAg6Z`X
jQnRl5koiFZ5TN?S9UkpccHf:B[23@KnD2?fcVH:G;5WQG9DgDgUOHCNJWmmfok\
W?KRg>OEQkMlVhHG:`I_R?PD0Q[4DiKOD2ZP@@pFl10;Qj=3Ni151RVEUMGgQ\FZ
=FULHS5]aenM7?5DDm71f=[JTIO=DBf7U:gk3gM_EJjRRmR3XbFQ1RgOZep2nKdl
]WL;;5S_oZfLNab^gU6NS^MTT1hNoPPW2RWV]C8bNMRfPOWWBgbAC@pTY;?lLhZ:
L\DGg4c?HU?h?`Ye<1f0>XRU=o>j3@ZWginR35>_<5GEUnNLbqSS8L<RY2PaZ6m6
B1d_V66ZfSV\TX7<32<D;]jfGJ<[9b335G@EW^i]ncfkp3F5A6kI3:\0me[aTb49
<2Me@mCFd;TaSeKH2NhanN\MhDf9_;W5CV5VH0Xpn\G53M9Y8Jf`n^6eS7jMliaO
Gk5[Ha@fWN_W:5O_H>oVbI768Y?CO_LiRdqiCZo9NOSH8X\RTH4e3hdKMeTE^Ea8
S>2A<TIhH[?C@Agl<O8`C[>K=_mDC^d\_pdm0ca57NbUbm23iO9c5IVK]V>Ea91R
TE5g4q5FD>3Rd_FOK^TZe=l\MR?\oc4hP^OH4<q?k:mQa<;U7;c4IE`NN]kSYZW:
6G<kW`ICH\Bq5mD_D6Up7J[O7hq^0VFVK$
`endprotected
endmodule // module vusb_hs_pe_datapath

