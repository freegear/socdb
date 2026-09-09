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
4GA`DSQV5DT^<2YDRl6S5Y3\`6]?nkIUmAK`q3dP8?QKQbMHcNK]=;=MP>?Z1RJ6
5:@_4a[]d1Ck4f3VO9Be>`<A7REqnY0TYRD9kH>]D=71IklmlEd[9UlkpQc4]B1q
hc@;K56@m8X;VfQ9<\YD[Ai3e@cGeOKHGQpP0ihbedGEMW4@PiaNU_2>LTeEE9Yi
K[P@Z8Xp=LGBkQIaLKB\BIEf_UlSS<k42S?73N@hFYHib4p^hEKBm7cG^Y:G^o_`
C@@j6^Sbi3`dQ\h?B3`]>qcDeDo@:82B6NiSlW[Og1<\gaL`5`c:B8oMKVq`jDlW
f>`PJP1?PDUjXf@FNS8PXQIC0laM5bDW<<15a<B=JY_8lpU>>LTO;h;0_h??5Eg:
oIhh^^7k:\HU>j;hpSCTJKfQ__SB8gX1i>^fKodaPF5Cc6YVSh;B7H[OS9b8L6?I
0q6J5V9=UkL?]`JHOjC3PiYF8Db\P\64c7poi4>AL<n;`6[c\9J7LYo;HaDXDk4V
IBdb4m=?><j=<6WZ55[pD85M9gA>o2a[Oj5?RZfjA`Hd4=mf<@<BhNZUq=;P?deQ
bbC1]XPQ`nK\i[1\dI^^3b=>2og<qmATj^==N?N14eZSNA8??g21>I7ijHO]AFop
bD5c:5]LEAMS6_2<gojB?D`7Va>:q?C;[>hk0bAYNg1YS[Y4k9Ei4fYFJZP0O8O`
g9apA59L7LFjJ3jaC_Ib2Tn?d5Z?_gBY_kpSh>4Z1J@QjU6GoD44NXNND5<`CM^]
2XZ2ICo<Z5kDl2^XRqE6NX0[j^JL3LVR>WG51Q_iRSkkd]BkbXpYKLc\oA]9]A?\
6:T]1S5Maj1;QE_a4PBk?F5pS>T`[RC`mD[KQi8fGb@KZR2m;=6AW>>M9<q;bVml
F5IEFXG[SdYcAMHOk^B@VmSXmI`eiKLqZkRW=JAaU75GHAZMhl>=@\<XVTAP0OV2
e@95=ND6:eK8>b5ZHHpnl`a<FZ@TmM>oBDXZU1H0_GG1?=d_PUJ>2e]l]b5X=UDI
Df8fkpcieVBjXC5[_<jU=4UPVjBY[HL=FG9[3omD70WDn43TpiOfX\ZW:6K7HM<A
qPHgiWVWf9eTfBbY<g`?eSZT`I=dAao?\=h:aeT9ml1afEofq7EOiVhonmh8\mNb
VbjPJe7c`=801afOT]E?2jDqBXO4H3Z1J8\5>d<XTn:L:?KhI?<me\YMW<PmJS^;
Oikjec^p=9oH4]_Wb0Ejk:VDIjhn8bhQ`42:`?8RM?X\oL;[Hmqi?^8U[o=RVFRe
7DY8o9lK<VVXQoU8T1a_?=P9nT2pQb9=W?4QjV?`>G5PoXGnGjnAYM8d1Oec:S4W
pEjL;k?DZ\LfPoL_6?ZC_\Vh0dT95Wl<^`PIAJY=JD8JS30U7@alq@R7;F9TFbcU
1Gi=5W=_P\H7GQMdED5:Z5=fapT9Thj=`h:[M3ZBd0;K10eeYI;nXRVAFPqJEPQ`
^mb[Z1:gc^PKGBQY>86BI=:1=E_1O=q6jU:IZ@J4b8:Y<RS6C@3U>[LQAdc5[ccV
EHg;LNkqO>9R0V_]_k:n4C<h1C2C0NoaTZO0D=7;j2qQa4O>MG_j[iabeO\Z7<9Y
:LfI0MKJR1VY1=8NPW:`HqaLlA\\mJF?Iab3]@VI>]Kh<lZ\T<c^qBUJ_AM7l4mn
`4C6jXCePiDC[Zmo5onXm_WR^LE5E1dp20MaIIR3iERLFWai2LYo_U=Ya0D4>d`i
bC]CN8fp=F\KFFiML2Lj[VnB<0:gJCRWJ1`ZV4ignZRhd`L0Y4ODpUmJ262]D@BL
m3c<OkdJ^>?kKhVblpKTL70eNffiN\3Wak\B^[G?f^4^j8V9pUc^5lFFNI;0HXg5
7?H9=<2I1iGdNqOQeS=eVG>;o0`iAEoW1\iMoXeKpcoCOZOSUcPOX^[U=i0B8U:M
C^5jq_S\;:R4AOEk0jNOV1f1<cGAo=B]6mUlp4MYkDd?J]A`[lc^k2@cM]CNJl^o
q75G9P@2DcH6P5@MVFOTU1VQTX:gR7X4`aV_i@M8jqaLIU[CUB]MB:k4k752B597
_K0WR0H<pdX6;oEeHMb7<<\4T2E<poZb2e^BSJZ3XYmnbBTcVK<@F=Kgok>`Jh<R
S>JBj5M9qVhHmX=R2bQ2cPn@WElnNN6GO?CFMYJhgHY;iVAqh?DeIaBES0<2oO[n
M\7CciD4\H?nSbS3KSkk5<5=K:f3fRaDA1Pp?W79KROIGWo@eIEOQ6@<llge?U9D
TW?FGDjD;5BUlYKkU4X3jA?2AXZ:dPjl3@Ip4Sl8nJnJQX35W57UNl`>elf91S\S
N6iq[iY`fRO^\4Q8[ESIeH?XjC>=5nK0@:KEeof4K=]Z>SZTpdC`IeL_42k;ZQ>3
Va<>@Z=lf;Qknoh:Jl^_WmhbpI@Pn2RJA3@fKZKK7`K5i`hF9Dl6^lR]f=IAAALj
QemHeCg=MVL7BqXAnmB28PiFCK\7@eFb\d8HgMqhD0dQJ96^l\j_Ib5mWo>pV;BL
A8Ul=4jc2`Q[L\0jcBpQ?Y0G`ojdheMZFLWG94OiUKCA>>=PeLHhmDAel_Z`D3>p
FRohaja>kPSF4ZPHC52H_J`[LoR82JEZ;je@R;CN[Pp\LC0S7PoY]3gH74AZ?;TA
96a6dJFJ]3@37`:pE4gYU[Eoj_ZTCf=4MD?gghP7LVd1VWfFYng9N1A>BSkR_D3p
Wa]QWHI43^KkHV6<GN_6]3]mnkY:;eX86Jh3aR^HHcMoaNEqhU=DOmVC^IE^]ZD1
IdZQj;BhPbkl=>=>=XR<Vlf2q4CoX=gW^d[MmI2BJiDC\Q=_3cE\:mS;K>;0LffO
]CiADpGc[9;hEe4iN55mQ1gH2;Rgg5@IVQS4l7Jo3XSVQQpbdlTS8k0mfXi]=jBP
F5gIN\W7DRo=hG22JlDg:Bmph>;G[j3\>lZ`FP2S5b\:d=K[LW5Z0_11b8lJ2O22
Q5HHI7[qgbJnMe@oRf=Ef0JFdV1PlUn>;mGg8Um?\^q>DU[e_db96@>g3?]qfYhl
W;kYenT>dVZ1[TTpP<=1J48DboaN9D^=CE;=M6D0g2d]k@YJmRqc:BVc<_]LANGi
FVLp]c=e:;WOi0HNFk<Q_<FpZQZogkaZD2RQ[DENaDgfCRGMI8k2Kb@7OP8^1Fo0
6`ITIjnl2;Q4<L3pdYCBedBXC:RdoI`ANg3KAOeqlfgS<a6>ClKIeQFCT[3GF^H5
Ldh75hG8Ui57mQPpHDR1d8FYQfiMU^C3@<?iVS=8?nEB=e]gjA1?b6GqGB5iLmW?
EVbiKG6m;Z\n9?C<e`5m=b`;M[Q]2=<q8NS?0cY]Fm0bjEcE`Te6_5=fmP1P5Ga<
g;1FbQqRE`8HX<>>?cD_;o?\F5VC4XGn@@V8YK2c`3>degepmBobSJ5M8IV5^boN
BSkgoYdUUYSNRCMnQ\I4GPqFOZjg3IjVPYIk7OAjmOWX6Qoc5:TI^<gJiQ0F1p6;
mV=QjYALn?9o581b\06T0OCE13KAl[WQlnpP8f3NRnfFSQ@8N>;3Ng99[h9_N6;9
JNope4E`;bbBNY3T7KbdP0`q?k[nj106jm`CDjUZNFdZ5KPlQZ[0X9\^q:ITV38G
;Ua9I:QN@8]G8BR2k`[1We3>qOU1H7HDm9cKd`7<Jc`X[7G=UPFY7@7h3noJEJIq
n\>@iL070A0db[MDHAcUL20mSRN@7_S6D<4hl?Rbe9q8J@_1IiKD\9OC5ghLc9IN
FdHNDM5Q^M4<A=hcjUPRaSp41T6D]^@N5kaGATC7BEGFQTnE@k6L=>iDM?b<DMF]
^]bPMQ^YRq0[=LK:[3EA;GSl=64HC;WEdMV0[?l7Z>RaTCcm`T4W9[AjFkfV2<la
0pfAS>UhiZ`f8En?M`ga=2S1>E]\H8[goRU368?QohI]019jagh1qh\G:\fRK2C:
QFoV<FRC7]G\EAkld;Z[mP`:Sc8JJB@2d6X<Dql]01Wlk\C;W3dFZT9QeWi1BT`E
nf]M<D3]H\aVl;C;<Z@Jk3IkE;;KVWb1c8qm;7OC>G<ZB:PV_BHVN@fTC6BC1ka?
^m0N\M<k>BD>XO<qm1>`Z2cIKU1^jZ=k[lJ7W`If@MOGc:DSmE6?=:O;oC1YiBWM
Q9Q;4;p9QFHmeF42IWg6d>Z2<?j>l^>WoK<VL^FlcJZKDg_DAj;J>aMpa[_MMVMg
4e?;3^Jin=;B>l\JnbETRa3T24NbPg6AklAkhf5qNDBNQG>1be]YG5jWDa\oD_Jd
I9`TXXC@Gi]DRc?;_^9q_]>ZHlXJ?3H\o;:Xa0HX0SP46R^JRUmM`^Oe`>plf;`@
`Ace]eW;2EG[00kIe@E>NlZb?2T<Ai95>plJl=c_a:V@X;6Q7Q3hf\4\;IYcNKDl
ec4EL4c8@2p=6JRDIRMjB2jRjKjSOmNmA9oNAgK4P3dTH\Kqn[TO`jVNVV?;36RL
;@EfK<0V6U\R5e2?[FD:660TkVIpLUWNX=edAL3dA5G:SmmB3Wg:1UHmQ]_j8lcJ
q>2aP84A2hE=UeaAfE1c`9bHjiDOePZaGZTKCmd1lQUm]CeHbi;CqMgMZMnnJ;>V
@bj\^TdGfibTl\[_m=]\pg1nSOki<?ULhW\Am[DM7:EPGHlU`[iol07MRAD;JYRD
9aG?Kbh[q;PAJLeZn;QH1RSIeRU36EOFZa_flI:<\4@XQ;e2\<@8SGX3Z^5Ypmli
LcK;2jC0k>\CJZkf1]WR0PoY7kEF5kLL[IciUAo__qPd62OBa9J@HmeggAVoO=AL
gB:TmJXi8T:a\hHAG?WIDpJnIe[4@S;38>lM>PfGj3bL6Xa8m`el4ODFDTJC@6aB
:^N52JZj5aDP0fG<TXn]NK<91IpH6][I[==hnmZbGJKHW[R@QB;GlY:ZgZpo2aCb
Ad4[N0FnkJ<WP@f6M4T>NnI1d1fG0AZK]_;Zn4lKmN4?4IoeV?NB3dS@KUOSESq[
hJL8BRbaBZ<;UFM_TOWIR7Bn1koO16\aSO=q68^\652O?9[4g;>9;5IV4dFA9Jdn
RKW0;bC=o>klc_di]=]goJ0qCe<dXNd]i;?;bc8ChY58EgS:koX9:S7Y@m_b507X
XnHFc?ZGkkYG3K<Q0d[GN>=1Z;ioYkO[HKn\ODk>q:bm?E9DZoNR?igD0>BkEZXE
2gU8U2GDem4]Y>fbqnl42HaILeONSSo5p5Gm@Qj6l6gD0>;dLCRlj4dhaj=<OJHo
XmRSJp>IjONG0MHgo09=@n53OR?F03g@0S@l71N6[IqS4IcWIAL8S[LP5m_h27Lg
U;]^obEV@X9`[RAGfcDWUYKn7SDdn;1\f[Ck2p[5c<UhJekf9V:313;lJFhQ`K0g
2ihna0lZYAkK\nfo<CDcTncHVZeJWG50DBMPQVp@PA::CL4OXWKQK@oARaE=0=gm
lV>>cL5WlZ3=D6IBHXe21p;A`gV]QDZhUh:j;3iPbV9CJ5d53O=PHdcBiHb0AJ_j
61U:Q3p<K3NLoWFC50AUdn>G7F097]H\ljmDNBWE4bO<_<NDX?O??mfpWM;TnSWa
6XacGA_^;f[Wkf;WYOk3niK@QbcT0]9[90\Z9aE5[n:mD0LR2_FOdYY?hka8e4pm
_dWk1Ejdg?WUCoJf;klYQoRaBDSgSh;GFEo:YA6O=hfO0@TqMEf;Q8@@QA6G]S07
h7Dh5m3`QMESUPD>6R@67O1d2Wn1TlHUE1Ep`i8oUm5?<HJh9\V=[8O5:acO7FP7
FFE?O\fqQ^\fdO4f2L[AAPmSMm2G3O`:>6V;deINi?Y1I6V`_F706T=RcbCqQMH:
L;YiC:\03YVcgWKJWEJY7]j61PP<kLhS3>lf7R=lE\]Y`b?mkKpgkgKQ6o^aIe6K
gU3d]B`I?1_n^SR6LZ9d1W:Qhp=EH94]<nJb<1>RBlaBB8=?HOmjCcceS9:^jImQ
C@Y]BgHo_?`\[m>cpf3J2\d5KnMhGH=^ZSVTnPBF9P@8^5AgPXQhGU=NHf`8NjeI
aA44nB@q3J?@U7QmRRD<\^m=LSRb:Kd=EWY29SCQdcF<>^q_HmM23W:E\^PQjJkI
2JV7dCo7`[Q4H8`>nedM=UePPUWnER3B[DdnM@C^?b6X[TPEm;XD=EdpCVddeYN;
k3mOB?P?=g8UYZ]9@UkR^:KHS`[dfFZ:ecZ;L`?]YYGa6Wq2kSeK?c?QR\N65TNY
?LJ<bCFT^;NMgPK7V?lE06IRoiWc>n5g0b\i8qWLUm3EN9@=YhfDCSi<bZnc5O^:
8ClS2dQUPMJ4pI:fIAcBj8n65Y2F:\7J8H00LTnEjOm`SY7a?kj3fH^ZI6TDJ^nc
RXbp7mJKAkUM@]LXngbQ`0ZeAjK<fB7QbRj\EDPi_l26X?8W91e3:Pgi1DqUMQ`7
bAUQm0`G4_m>hGTN6TTR;VmJ<X6Kj:Qa^p_D8To=1WhnhRfA_^aV`8qOh\>To41P
lO24[9iQn?l9d:Ng\FkF<[7]leI_fj?A_dEA0RU;3fH;9p5?1eai>^2EDlDI3D2j
NJ:=lXdoOL@m3jlYJRV^F1N5UVOkp4f64c27Ac`:Co?RESZXF[>`XlfaM1L;@UG`
HhB03l@<4WobNm_qQTQY;g7Vhf:1Mkeeah]5gmCUdZcn><pTOO\LZlC6>L3agZmk
6oF:gMNY:_hiUI2pLQ^D`M4KM=C7KZIci0A3]V0;blDe^WV[DRM5Dl8XoZ^A1oA3
p3^U=hjZL:NTVe;4L0M3>KC1SC7G0^oNk:M3SME4Jb>6haQ[KZ`p<P\?m1KLH6hm
UL1L\]F7M5R;QVS;1<>I5a\\@ZCglMkS^Ijd3CVC8eUeL:g7X68OU73q>8gbZ12k
9hAeX[=Pc[8EGci4=ACTiGEU\F;knAQRm\4E=K<MU2peXDJA7G;1m3IRNUn18oPA
60OV?MjC8:Y1O\kqbd^0KQ@a<R>j\[JTT_M`5EN68Aj^D9>ZLff4q`oDnj>mTW;D
b4O58H7c`bgPj0S9E6lB\;dJIpkfH2SEYA[<Ug75ARUBL>Rce=3icoIQgZFd^TMI
PRf1F:U2<8VADRj:ApHYB`8j_7Qc??Dh7ZOl5mn2=Tnm@19f[^2I__pG@SU^CFO@
ed72\@mH>XhFN]CXlnFC@NnA[YDdcmKVkd]qSmjkBM5jjB_ToWg3T4?IWLD4P:4n
MmleTKn4eoPP4T<gpThcl[fm^6ZEF=091eX`_dUGE>[6Q2l3Ed`][H;p0bd;46=1
jd\8hP`NT\=KcHFUlQBC0AWBXDGK`lq;hi`;ZZT]H^ZATD6:fXeFMQ]4lF5OUmVm
IXim^DR;Vp[eZF0kGQQMl>1E<AT>1WicObQJPjkd56p`K4OGgUlI859m334^53C`
PBVb^4DeZ1dJgpQMD5aio]NNO]>M0<M^Kec2gg;QdHo1D]9Yq8OjBK4na7@9Vf>p
m]M;W`IC2bRii_o[0FlOCh4oiQ77NNL47^qZ8YD\b5Dk_FN@d;XT\CE7d_=Zl0[G
e6]WIq7c?9MEkNi8U?A_2QmXf>X?1[BZ@2=eFfpehTNO^h]olRoKkRl5=HjDnb5E
TOa=Rpg\>K<^XW9OE7Yhnn_?BgmI0O@YiR0Lk`p\5bOd5ggd`V\TFZ0I^60n_mg3
^1EY]qh;_RlYnOUOVaTYYc:mUGa[>MjdGioMqe41i]L:BHAMVaX@9\To22Uj=n]i
HX[Bq4IXoNW?lOl^cf?CeW1XMJ4dh2778JF`pDX2i8^6ZmaDmUAe@5Tl7@IRWc9;
?J8]8f64q5hQj@2c4`ADnVEk>Q7`HK^=RCmD^LR4TIa\phA;CFo1GU5:aNl4O6YH
H_]H5JV;oRbfqi^bd[i2njdYo?@3FXl_0m<Iao2:;V>Sp3BCoCJbY8mcJLH?YXjh
JGYe63mZceX;k?bUBh1oH>fCd6dKDc7TB[Tjp3BHAc]8NCn=iT==@R0J7kAn>3cc
^?Z>H<1adUI6UqJcf;P3ET<Bd6NkSYmoVlkMnTgHRdO8WXf7niILc9pVn`mE0FgH
1S=MnE@h:YRAJBgTiL]Tgjk?W?Nhn\kpF@hb2m0HL9Li0LUZR4DW^L[TNQlcoJhf
c[8g5:]1pcaVFL;8PD]`e13]l<c2mNfdf<bPf99Z;L2\CWLgph[X\JEP3iE_QP72
R8D4cOEdKT;_[jkO^`kB5WSHpoY0;7@P6GRT>lVVWV;oLjMQiliRUAhfK?l[_p1Q
0=;2Z;CE^SX>f54n0N6E7\RA7oE3R6Ubh14mpRV4nCHnk9ig5ULZ06faN057kbKi
^6n>Xq06OC]O@IEMM8\m1naRS>WPIm@lGV;86RRmChb1q?n^bl^SD[=NYV_\?QIi
oa]R0Qf;\kDaF^:M?aK=dqRGId6TXh>k^X4LILOeCn;J]RnEGgYUN^=GLZEiA5p1
m[gOU2>ID9RC:YYlJ<6_Y1;TGa5afnHTgQZHd9\mcqfFS9jM6Yaem@YQUPXjSCW^
bm_Z8aQJ@bjG25Gl^dlKpO?RmfWS:3JG6lXY]?63Xd8`D`3hk3egAbIIBnUN_Y6Z
:N@f6g@\p;\5f\EBhjD:G[PMSd0T\=oY@_d0IAGCm9S33^[OORWqgEMeCGm7o7E:
mFZ1?^9@\93:HO1:J7\mZdfM12bh47p_OKA;dg\gmO^ZZCF[AQi@;`k83XRY9J?F
C=A6\G0dL]\2>KEMORhg^qJXWBmU19YS04W;6eJBfbTFP47aVaXKg:PG;G=G:?eE
124ZLeB0P;kCphHTckUP23b_gHo[^JlfE31gL==>Vhk7T@3DOHa\<\[q]@A\5Emg
;YBlV3V1i?miU[:4i6f6o]Y[TVaRiQgU6np5ljPgLG3Lmf[K1?CJX6l`6DR`1YmE
[jIOPpQJi@jX=D@n\J<K;;1TX>K1^gba14[bd^6ep_1WWQ71LO`AWAMO^bnkL@`i
RVHYFJ__DANk8OIiVVBR:JNq=d_gDIjF8>b^6B40G3:PORB;\<ANK1W:lPlIYed2
m4@ETC^l?H]KWRlU9i7YdE`5M0IaKepPM?g`ZXV0m@\BoAVP_;@_KGQZU<TTO_NG
8i@Lk>;CS9WWEpiILbT\lLKBA\:ZC3ea6]LOW_PQaQR`djDgF;Io;F]@DqO<;:IQ
84C47hHOh[4CQP`hUZ?=9J2J@a@6[8Fh=0pn2>2;boSk=I7]BoXkQY9=jF^18`fD
LS1:\^gKfPMqPFZ?TMH9gKj554;So^KJ4>_4E=BPD=Z_Z3kkkF6XqkF7370=Jk;k
fE7TT>U;SHkCd3OZa]hLeAO53Q@AL;]`eL8IlMdMl:JhdR\eVNdTWM1pM0H]n0];
Xm0MEeRBf^\il@hNPKg=NaXGX?V[_k^1<1q;\D2O=MZV9>=;V3bh6JBImfUN@jgL
\lpWT39\oGM@i99_3R9L3K_ZlT0GWK4IU`]1=NioJq99g8@ONqPM;UcDK=:TZ`9j
lhdo@TnflQbn=b?NS:GYO9nco_YX]D8hn8[FLMloXNPZad1HPf`[`>CaY=p24fQL
g01D5?]23DOZcca[j1VkN5]j4Uh8gHQ`HeUfCg<ISS7b4Wl]BcIoKIM9;K_VaFaB
B4i8>52qXB?EdXbp^<4UnTaSIcF71P;Icn5nGeXMTeEQO^@nI[MEL]q5VgDfH8Qe
Y4_VeIFoJ0jW^YmfFZ?19BVoVfXTXoK]7Cpc^M@BGWqSaS8eUEqC]A=Ug5pTkR35
klk@66:6U>9CII[NEUD3^mS5:3;Z[c6>1qO_BFYm8qNIkengJpZ3Q9iPBNY\IPgi
k?Y5^AY;XpH@lTO`[pU?CDkKYp1@Eo0eFPSd]61nD?UD3O\de;Zoj@cm\1bLhp=2
0UGX`pjO6>WTj[DVdN];NlGm6EESTXQ`HPN>:hIoHkBTFo0Z`3l@i5bQOY6h1@Z1
nDGD@b3:dfAJN8Qi:>qVK7RfL[qB<GnNe?:l0:B6Y9j=?3P=j[NgIChF2NZ8U^XM
5p<b]Oj6epom`OaK9pF9]E\l1Eig@?@8`M`O1FfS]_iW6B?g[2k=7V<\4T0<EqQ=
<ELEHq4_E[c\<mbRmER[ZYD;e2EPNXWV<XUZFYT`;aW0qE?<aHCjpKjfB`__pAhl
_hfDp^CEFY^dqG03<ZjbJ\bfgmm7503C@imPdjdSe5ng7CHliR<BEMWBZEX_ZlC6
6;`6JFKEiXYNH]?7SOjGmT5:mBdBVX^`:Ob4SB?PZfnXi:SIR7<LH\LGh5NSLpj>
j4kM=YZBIm=d8]Tdp>ZhRHL;qWLo5Ihg;EDUI7?oHQB>UE^jUKYP4:];bV=]:9:q
@XW];9QqMYG=6^HpAeOX?^OpocaV9FC\\AZMl?HWiSf[jLVi=9Q9_;;nW4;J3dpH
mYCR22q5e7P9HSpnfjJ\L]qY23dQahk;CI:i?ccjb=OW@QkZJ0VXCV6;nWM?@jTD
>BA=jTj1k[CaT>a0U9UQfUC\_ecpm;dbUESpf:j91B4Sn><dfk^KNEYbF[B5VKOg
?AI03^BcLb6OKXdVcEa?@aM>V@kLCN:iDLAkhXjMbEeApM@X9D6^k?06_[]KeSLP
SA?B9jAg14_]Yi`QnYmd2GW9TdFl`lP[ZTUG8ph=4eO==EJJdU<E6\;Uj[dD2pLC
iCC850Le3ZIWmXbC]WdVDmFPS\nj0QQhFFf?K2GBpElL0Ghj\23jL_J:Y\VO@T_A
J1I]I^fP3l?QpOAjS5=MWe2_7IKcn^;lDc9XB[<6DVi1W@lY:8DqY[8^S28qfWHb
2m8<N=>48hm4o00QTSgi8kq_EdlGTGDQ\nikP^G[<N;7_[P985FHYE`]EO7QMn]K
XE`2:LJ@Cj1Y5qD^W14n;k_DC5ZfOg@R5_\8YcYS??7<=fi1FIi38>0E0olgEIa0
p3<amDSJjeZ:n_;PV[5aG2nEiQc67MTMXkX?U[GELJF^VO9a9VAhHdD1A33TXqS6
eQ8m:OiQJOAh;JF6@M1^Ce_6nho8?C8DRZG^T?:Xd@E2\;R:]o>4bTFVK9p7gI4:
JBqhoWU]mb1C00D12I1TQg@VG:HTV3b:j\CWUiIMV87?lR5YB2`HVXg0QX`CCqZo
M:4neqhoUTjD3pV8BOYlX`Ii=dm@ihPlJCJV8BaQ5WKjf41f3cgH^800ePAHfJhn
fj1]^TK<Eaje<AVTB==V=ol3dZaMCGJ^F5I9p09\\[;mD\oMj]<^VSF87c8bYA4D
m8GOc;07F^26R\NH6IW@5HLO@qTMSQ>BSqGlC2K_f<1>DU_O5VaTPc=UWG7:fl_W
c;BiiE\Wgbm^6gZY`j6L4Q1EqDi;9=h\UT1M_<RhJ012Om]N[G4K>I<Df@5`2ThB
MCBGcT1maLlq7H9]jEZ4P]CY:m`NN7IXHO5MD3[A1loc?6hjS=1ka0UK5BU1;fHY
@a=X`d68q0ATe=HaS]K[GU0;jh9NWD`Cj<7?WU@FX=l<>0:@]SlN5eJlY]hVP?eQ
^3egGp>H`^[D1k0=h]HPQm^`X6;bnp73hBJ]LpNNAO_U=p2NnVDkGqEbAA51D3Gn
U\21LD@7L8GgDiU?31?C_cXm?1hd8h8NXgnKB3U4Nc5\3QIY]mkmK9B5AF_MZ;g_
HkWi7LL[e0kGA;>M1:=U\c8[LilVLbUBFdfSKqYPcJFm;paf^DjVXJdL5:R3?EXd
h3;jEmgf=OM=hAF6J^K_<9fW?;i^]VRYBqPh6Lk^2QY;cFFV6b1ZBWSd8GLgO4pX
b3AM^@6DTPWIXXFlI4FghQ:6UZhE4`f@HoYL]1Ed^XlCS:_VZH>X9iq?K`6K6Yqi
EJ`CV=Dg06:lI2bJcQc@30:e@YGB7XE?Yj;291cQD6`AU`CiWpTc9WTa9qWc[0SF
8q9<0SYc?_Q2b=gdHSgCO^6`DKHVai^j?@T1JIhjm3Fff7^n7V<BXWdjRG@nKi^J
Ag9K=fpZQ>FaTT?YK2ocOWpd[d^`Nlp9gNQI8=^cBDWoKmXMFa;O<]@[KmCQREO6
:O:MPlM\h6jf\QNm`p`7UP\\\p3RXHSSQRD[UmF4`]STmiZnYB4OP@OnigV2HQk2
3mc\:D]Shl^d6DQ=QA`a8AbW?S;leV7DjlOmV1[YTMnhq\KN<_7K<JTSkgKE1o3f
6F@mRcH>MfhGlKiom<<d:LL^oU5f50TdHVZaUHTOS2LUAnMTDFk]me4`QEME18KV
MjJI`q]WSPR^TqRTaRRjDqPc3OEZBp^5cO?Si=;M\[Am7dVY=4ne>:C:CoQJTY3\
SX98MB25V[fMXEWd0@2:ePZYDTqAP78@DiCTBWnC^fm_n:aOW8Ge3O_JFJ8Cf<2Z
YHkVgS7FZ<@3VmJ=dLP8TlSm7AP7ZAml>ApP2_UV3469VSlKXaD5:Fj@WkQeOecd
YBdbl;oYi]DVQ<RF18anQAJPG:iCdUnI;Y>A5I_pP2a_2J@7M^T9I5Sh2LU<9UI6
1o9k2aBGESN8DSJ49;bRoQDB4l4A1BfHX3^>1c>YldnGpgWlfMB9`HTTPjfn51^W
Q:KFHQYaDoY[IGn=e^\QKm`BKY6IB?gkojEn?O^>MXmqKLTDW9DYOKA2R@:KjdBC
BeGQ^mNal^@?fi^cD@9GaHB9]aeqbjnZdfjD0hVIG9=\mbWjPJ[QKXgCnBlm=\9@
GhpMgYcd`on29ITd`\LUg?oJ733fB=4`ZT;67qiFc>;cd6KFG\=IJJe5Fgj2UP<Q
ZVfc@8b:gMFCM5pm0?XT=Fp4fWTV_K[1NFnTUB:TdPCR2CjdniIb6gdB`dg5^mhU
_g1fZTMQd<a4JpGhUk4bVPG@f2IDl4fBI?RSR9^njRnZmdgfFRbaSUcjLLSgF_R;
7KC\qdMBbGBU\]eHXFCS3c3iMZM8\VXjE;X>IZCTS;Zd[>RX>ki:W[^ani9qY`mV
^7mC<4KC_7Z[a>FDTo\2iD75LU[hT<K1\=URgmTSW8Jh_g^D\=;bq3beWI^mp6:9
=C`Wq[nZRn_mq\7=\0U=L=POKVTYH1\fEd6=H9RE<Na`k_X;gn:nU7C57XZ2@@ij
\>=[R4>4q9k\==`Y4l;nJ;=7e]kfOQZ10Djk[_CTZ9=4KQ:4oWhZcZM_J\ngPb[`
`@^\Vh_1k9g\]U@gdA8QQ\BAHU0l0CGh`pK\7b[oX3gU<KN@k>RL`TSb9RiU2bOg
\3D2=>_BGE2^>G9BmdXN<Ep9E1daE=qdENH@RbXG:B=[Xf7U2?0PiS^b9Mo174om
>g3KR=kRh^TDkS5HPcI;4p=<QW:hMknCaP031HXSk]52_WfZTHE1OSWoHVVe2;GD
k]gF@T5A8Ca1pE=o?Cl0D7Bhj@dj0=Nke=HHRbd^Cg^nHh][<1o_]?obTDBEV?NF
HX`pCoQCjSZF3>iki8SCC1A5@12h:3D4A:>aonATXiS08hhFZl=nNEFNZ]X0ph>O
VZ4Bp>O:e79:ph>:T?^f]nZm]d\o?WGIg6N^hC9jD<hqo4h3Kg@qAlA]8Vmlokml
BG]1h1dQ5OS1<L:B<Hc:[<T^V`14_a<:cXP2T>]0G4ZajT_2:CnFbeXj2AiqeJAj
Q0<m1D]7ic6HGCE@mNfIQ<bOF99@HL2;>?H5<kH<[dMb\XSYo2oa_C4`?PBMQ[F3
2H4m_Sgq>6;eO5`3X7=7Rb5C]N8WQn3h>bFEDVP]QBK=3_cJTldJZMMZX=d]1J1[
mMUeRAnA`oLSY9e6]T3qRJPTh]DTa^Sn9SNAY@h14khNdBS<Mf<g0F0dN;[o6YaW
l=@>RDMe7IlN:\I\FLbRRmWTChPcjY_<ZbCWR8nA9<niY=V62N:FT^2RUbk[@`O6
qA<mSiiP2SZKnfLD3ki14e0>:8]UOh7J<4B>qgPKFI>;qPkm2_i<9lC5>Soaf4JQ
;[1hI9bXjUnI`Y6;gnnGeG0Xo53\eTmgga56hqO?;VMj8q`n6VjT9p0<XKMifq^5
dH@FDqIRJK\5Ac1]Zn0Mof<KkjHeD0NF93l5hQoXY8T:E;?:?Pg?>ZmfS7m?fSXA
hI[CeD<lUKV<jnKcOSd74Q`=33lij`?n^n0l^[N8l1LJ`PR6`hnPG7IEOXFRQONI
KQZKndDO2_2DUn??Yqm\B:@FWgNhG?ho;9gX?G]YPfW0Ie`ih9PNCo[^K<C@29GP
4YUe2XCe32`9EnAhK^m?7IqK@BD[??:AF:lJa46lH@I[7oSQe?Y^AIO<X1Q9<lc^
dZ_?L5RZbVoHR>f<;Q=7_\HLRFYR3?di6??hR;q>mRGbBl`KPg@je0kOe8;4W0RD
SDcRFO\RK8o4F]CZ`;lFHWZ\5oKW53nI4_EG7pn>OHg^5eJBK`HYJ1PoB[gI6d<@
`qS^GJ[ZG4NAB8KXII28`5E\EMOa[h1:XUGc]aIMoc4Iom:YLTSk?Nc`M5HVk`bL
b`moPc1`]U9m4leFh]n<HMa4lm1^ho:Hl7XIRfM5M:;`SIE5W?9D8\P6>U??;F>7
4OR]30Q4^AXihp=Q`f=e9VHU9\MP8_Wk`=T4hNeJTZe^fRV^X?l:NkF5e5ZiT1D<
9XIP1X?98X0oUn=7e]qb>cC`E]P[PIhP7g8[LQ?71WHoW68[<a^clM[M1?J^NTKK
e\Tf37HoO]I9SKADa0N3Y70k2aSnZLUk1jqNS2Xi17GbUi;?NXd8kba_Z[e7\hpS
?jhZ]A50@QJ;i?MFmaSiVYH4nbWoakJ^N5]aD9hP4`OcDJlj<K<j@Dl<]^;P]bj8
Ino6cgI\`>O:?hDCa7_N4KBAcBm2Y0a2NKES`BA1L7CgDF<C<2TPJ9C[ZW<=]95I
5Tq=eN?7>[@l5UF37=@gX5CE:A9]=ga>?_EV:CXKe;N9?OjFDMO\`K[]7fZB87Up
l;f]]]Ge96G@]N6\32i1:aRpY`^;mm8D[Y]o<Ho?f8WFdW^n:^Xg77iceHD8Wk\@
?YE@:=6midQ^2oJcfWjlXX7[9\kf1;JJl08]3\eNpb5F@YA\8TAOf<D>lZXjjAU\
Z4j]q\kU>N?^3Lm8SVIJSRW@6oT5YQP24BMY>d1Y0ig2oiC@P^d><Q2RP^SB;L49
\J_;ngeq2BKlalW4lWV]`aYZLm]HK4Vk;W9\G?hSgWDG[VB_GC]>m;]_oE8hPg9B
RM6:q==B5W5\XB\LNh@bBZ73VARb4JSVmK8:1X94?eY92JoYDQ]R::T6icdFc`:o
kdNLg_QRI;d<Y`fij33WdWEh?e5L28KP<K6>2qk:>56RaM3h`P@6GgJ:OjMSi^Mm
YD@<mh0`Z:cR1Y=m5@Za6Ie=<GPFl4HIo=PNV9`8mF71j]a1d>TLXpPCYO>5KiMf
j7VH9BQn]2`d_?J31aMS;^7AfnlN]Xima6fJhXlHLI=<O0^hD^I:H`k[[EM0W@^;
6<mQ2R[gi57dfP;hl35cTJ`^5k[5?ZK<\`n`:^?<J6S^oRqAg^\SmC0afR<fKQOQ
1Tk8>oCFoD2F=Za1YaeS4@YiDm:jjk``MciLIJmhj5G2Ko?IfSXZ4M^`f;5M3XOG
:P<ALMcXm_:d74RaU]51DUcSlqbBOY9m2ZCcMZBJ7MI_aE8Em7jZC0OMIG5GVS8o
1<O9l>7iZ:4dbb\080C]:849DQclp1:X93;211o_W2`5^_`kfe?HnJKZS4`m=bCT
c0`mI6O27fXj@3n[?>mgXQ;MQ7CGP64I:b;<XL8pYDLSi8N\OLbD\jh;=7[?^[?7
bW^`HoZ;=Q0:CEdLdQL2Tmq_NWX6KCcaUZkEKi>4lqh_DSN[BcWL7HImogDM73[?
?@Y093NgE^lXHeZPDYJ?;8ok615YRMi[lC5`?A6MDf68Z[gMkW`Z6gba7=PZSO:P
=F7\iDOgn_<YJ96X0LMCYE[:25X1]15>F?KcARO;_UE@amSempE0VIIBpiJ_DZ>W
mT<90WTnEJb1EnISeHob4602T:K0qd9ROL2p\6?_nXmT[_Na8e92Wi;KoL1CFYRA
?EpXAXie^pPhI7Y9KOcYZ]dBQhohkHY9Rag=mPlGYMKjVY54j0]o0:QOFG^40lQU
G_[@KW>YohgJD;VMpFW>DX_GKYfCiG@gSX0ke`ONn9H9Bg[V6qW282YBq^^@TgQ6
9o>WmYHO2SWJL7oSd6DLp3<j0i?^ah2SG7D6bZapC\>3m4pYm5l\GF^7Qa1Y5m7g
<^LL\H:TVjUflJ6pU0^ZK=qC0S<?4PKb0Mg__9OWAB<oA29;6LEKE98qE>j6C1q4
bf[\?XncdB]l;G8BS1=4\>b6XG^J>bh0S4VRSq^RbQJ:p_[74dYE_HLj[ElN8L8Y
7=^lX=lf5[aK=hC=O9bSh\YpIoDmmJ7<?Bo_`nO\kQ;Zn[I8?CB4gG@Fq^\me]dp
MN`Ml`Kl8QoJSGI]iO@9?hWOP@bj1A5lqL0<Dk3q;hhP5Zm;2icSKk5ZU4WBPKiA
K`4qTQ\W?9qmdC:_bX`dn86dkM@_V6fea2`aeiia39H^S@9c5lFGSKoYLakX[qle
=i_XSIki_WNFC9g7>:mNLYHFjOLmh^[S[Q=Cb@_dpFlK;0P_o>P8>X8Uo7V>EZh\
1ZAVSTkQKBHdfLIJL\02UgKQK?HD26cNc>G^MPFkKRMi6>_HoQi;E5lWkjTPlRCa
FbnYWGA^WjRPTPhdE?fj3j34WlQ40M9R]1>plKR@`5gM=V7LIl23S_\4jD]CSIVQ
XEjPaoHTCe\Oj2_DfT97DlBT7TJH=[e1R:QaG;?1IF55T<Ao`LmhGRD1CiLY7V=`
dblTKA>7k;H?I]N^kh[o0<\bB1h69C>lNV9SEo6qUO>b1MQDDA@NhX0Yf;5=ASKN
]kTIYWli]8I8Bg>BL@ImCFVN?a6o52J?8KC?1@]hAmjHiV2pYQdMM00IHC47HJD8
:o__L0khZUP:R\_Ca>1RKf[NnYCBOEHdb>JcoYm;\[65o9QaKZKN<i0NCbiXj7Dm
fMF`YP0VqF=]cX8j01^o0QD4fX1F<3YLV<M2Bp8V?InjBeoA8KHEoW>HiiE]K9<L
eoZLCQUD`S]bWgM0G1^Tm6nVU8e4A=iJad:75G_O9]9W2dnKBUR8QDl[oJJl]@7n
Bj_cl\0^0n6=i4a0[4TVZaH`j4kGOpDL91OFZ3d=G;J_cC?JY\ZZZHUAG6=DYDn5
:doE?DIfXA:HEH?KZFk[A]@ahAWkAcdj94C>[RH4dFWE^7@GhjS0c?=FZg==jd@Y
SnKA@F\kk6Sa1F6cRFkbAJ=ZZ4b6GP>Uan]\HmPjeRqZRSMK75YAXMD7^TGjLBQ3
UqKT^DSJoje^IEkb?63kp^N]bZK1R:n9nf5BMR=EnGk_\<0<Hl7h:>AT@OjU<aHP
2\@MKE0b31G1^LBgPjb7[A]:acXNPg:4\GR=Glf1JP`iWHaTHZ^3LR>2XWQ9C<LJ
gChVW:?KcG41q^O:eH2Wo`jj[YG199REmFC2cWRhD^AWGBSX0BVh8[iFKbl?_M[g
EI1qSW64OW<K`oS[Tjf5@kITN`N9n>pNY@h9[=H_KKKl];D]>pOcFP5XL>>MhNdZ
=@fdWbDbBe:2K:]R=fRdgLICaRn6pAMB]h]A4ImQQcaUKo_E6oT1c466UL_YCJHL
NWo0FqE5cS>BQdT7\amf>OV9chDFS4KK]\m<N5QPVUEaqW9Te@NLqA1hH1gjR5^d
T0n3CYQ:eTi?0>EZNXa^GUJlTVRj@RSUVF8^lRcTq1Y4LBITc<5dnJ983FO=KeWQ
<cV5ORG1A`5:[6o>U=CmScE;DW9HpfO`bjOl`TEddIjZC:oNDknKF<eeG?5IcHBc
X<SOHco<^[Eoa8D;J2cA2ICplDJ1V:JX7KbHomk5ef;0bFaR2gB[LDH@`ej7K868
Tk]fSna7T=bp00jlbYAXPc2Kl:V8Y4I9^j]?__G5;bfTZOAAlOkW=\BKDGpmM2>Q
2Km>hU0OM``>73hTePJR9EmRH_R7MlLhdEOJlO<Qcp?:P>oPJ[bDmg3SZH4nNcCZ
mUbCC9_Wql7D]n0M5mNLfR^oigckW;MI<jA=dYUoIBm4A4Y^De6E8G4e]aAIUpGh
ecC7QCeF3O@o<PMi3AXVf<MFH=KBOSTRMc7=0NTeT\5`ek9e0Xq8`m427XaF_AG<
ToEe^YL?dVJa;lQn5dKm>HD6;EA^kJWCS^1mocgp4NiKKW4O0^A3DBQfo5@`hKUo
9XcP3?DEkfDkVJ33ZPH9`cIf]9pFonSeDF6TeldBDmij>of6aYX_Tc00m`?LjHA5
f3FOoG>pAJZ1>P\k`JbQmf9<<k06pLMOI^mR_91^=6MJ:_<;E@]5:C?HS@BNYNf8
TXg=:Adm@Z\J46GXp@dKf\H4p^dbFWF`p;k>_?8npo=>9:bKd<^>EaDXALOQFDI>
1CdP1>fm0e_c^NWFGd8=i`on9iSbbgY9K2enp2=<cdV6QC>>?0cVTE]9[28D]bMK
O=UIa@hZpdfeE;\jq=7g3_5KbTd?L8XPl?dffG6H1]49ek:m7;\V]i5m4mZfEHF_
loW\p4cQF5Bid`e0d23ANoAm_JD:bfCkV8G0Z?3QR^HnlMRXMB=91JJT\ei5qOT7
OQjZoSlT^JEkQZNkeJJ[]Am1Fhd0eB=UaM`Yd@<PaMOV2Y8lpNh6HTB>B0O30UoV
^_jm;eeg^jDNO=Ac@NJ?gNDENf?CF^5j4Z=Tp:1R<:JYdk66MDKGglYd@MIR4A[m
ihS[I5Kj303>;UcQ71;qh\F_eLEL;gLBSSohA\XK71;<S>OP=m<i6<oLOTR:On[j
JkpL5;h`M;OoHP4=Rj0QW5Eng0:6QKCS;>b36djA[[[AXnK2LTi7IXfpcQggF?GQ
^87MS2dNkF:M>\<`G\FGB8S@h]N168Khe\f1@bX2]o_Nq4eG_Za_DmN\O@6fmUKS
O@S;G\8>@\L[;?Y`4NXhLO8O5og;4>;N9qJ@Xe3LDR=8@o3^LPP?4U;lb9>l_[T5
C>EKG=QObU3?UGYY?celqmRdNN[<SEYdf5WMNYc4MfHc0[CkB8MjHdPG@16bFXbq
13Ph;e<64=Q>bnQPU\>3d>mEiG:IRlO^<QeccWIeOB26p92\BLRMnDf2SCM9KO[\
B3@cB?F4:KdNVa8NHUG5\8fiRJ\>N9[cp]FhPA:2pOVL`M2=plAHEDc^pXV@Ue^;
<Cb_K3G>CZ^f=[83kOPdmDeCXCLV?0BmTC@5=Ai_<@1C1RBVX:3GR9h74q2EoHAZ
iFS3APiag0l<RY_3P4jE4aLM_<hk?CL5YZkXA@ofXeMY6jPTi>EQBj8Tinooi8:d
qTcDRa[Y7aokMa<LaNnTR<JR?n;oa3o2G?AM9eV0Qq__J]Tc48>7LJ3GaJ@:BX8j
HESEi>X<5fXF1VG5]gKZV_c[6M7HeIico[31ai@jA=SAab]lqjmYQKMCiOEHdb>R
f0`V=jKK5NgQ9^ZLo2GVmUlHOjmlBX4=O5a=QX:q30fkCj0^ma8WWeAL__;E?j2i
<n6?c7381<7D0oeAXFOE9LjnIPCe`bS_BSZqjeYiEjG28]YUIO8RK@5Q>aR2Zci9
@T`fpfcK;0^YN`Wj0T[O>iT3Cl_?h^CeCKTY;RO^ST5`N@c64]Bh:DcTDCa?CMXS
0TA3V;LV:YQfq4F6NMFPkoG3_EfeNmQUn79nXk<QA:oCN_ZCLlY81P2D]R3K1GRd
O1bON@V[:RU[10oZ<;o>Bp?XEc8]\]_d?iPj[iLe=LX:IMZBn1G]Vj[T5Y4FXO<h
UObkeiB002KWUF5aE_^W_S`ZBcj3TKpC`hQT:;04Y`B;8PlFiiaabW`3i[5BIE;C
[_g5B0>ZAWQ_Vk^DU781AADE:j3]oUNHLKOm>kFg>LXLNLK52YIDmaId9`POE\Q=
_>kNCW1?YpnA1c02NpfXho5lJ]^Y=;RD>R`U`_fXcTZ_hoA_nA=fe0MX<Yg=Uh?`
Tl=83?NT@SA0Z5J2WOfCoKd^L[c?j^7;EC0VbOKjKA`0om[mTRKS1FnOqejgRi^k
hSWn^T=3Wk?NPDUOd]A:82W]R8L]eJH@X8<QG[2lFL:h]mJ\lqFZi6geEW]9Qb;F
NceADEf\OSjBKc44E=e2S:L2X9WPaB^?k8Qeg<N<WFXUTdI:j7AoUYcU==cI6jWl
qScFGTmApND:Tj@JBkYM>9Tfll>AaIJ7m[LcKfjXV:mJFIk3lZ[PAadm:<kpQ9a:
mOnq6bIR3c]Edhb1?bUE=h:8QoHBVJ>EE2NLZfIPnG52>`8AWhL9Cn\BU3Vo6H1\
8kkl0h5VofF@kR>X;mObmoQBHK>F>m?83iUcEOK\[Lojm6@p];C\Z>UqSMOeD<Ie
AMCkR17S`>6;L:0mlJ96Thn\7UHZhkVH\7OBGn`R]apOTfG=Xlc00Zdi^<3ZmFFo
E\D;JIm:ecgm84DlO_iS26PcJ>l\TS>b2IAi=h5Ya3LFd^hqY]FiOFepfGa>_IBq
S01^Va<p0JPgFS=q[J^Q8SIgbbWl?U`Z]i;Vi\NleAD:?gI5d3AhMTg6P5`ZgdZ2
FZJ[HcS[PQB4Z6ZTY66WP54RLA82ZG`]MNUCP>K>A:aNaFiGEa:4]Sp]FloI@7>j
d8T:nga^E?7ZWKSW]XeZ1?U]:DJ4VnaNZLNZ8dc5=NL1D8\31]736Yf]9=oj1Y6a
Z`@BSE@C2^pE;hI5]apHn495HoQYoLRRhC@=bj9MZECbKap?VI>P;kF>?PE=IW>7
LlA84NTWA4OR2\[0T5=RR`MFMkCl\Y:cSqM?7;5`0p>L0l`a]4nU4Xf0e1<j@l?e
k43U2AUIDjWT_B3O0SL96U`e:\;bOH2`h7OIh>h[BHW6X8^SHk0eni8?Yhc7lV\L
U79eb4YSX3gQe`IingB6Aqd2a3hEnp0PWXlAmVUklT3\DfB0dKe:kUOG3ZL4@l3T
m\[<N[dD=ONBQXS9qfGe_OiSplUUcmN3b8gX:2JD^AQGk=nY>BeEZ1c=:fg7X5`o
dGDFOp>B4@<3cq=BhYf;nU<Q3EPN\2]bCVdOG:CLEA25HmLlQ1RmP[TM<fNY6FOa
35SFH1A8=NYimPm7nH1IK>;U=jESgZG^<1b5M^HiX2>ic4oDRe[2XP1cqOmXmb9m
p0m=JHXlMi8WhR_h?UELN[H>o13I6A50HO3A;_2Zd4RNMeg]EoJnhM>8f=m[fi8J
e??MkUHcc4H3Z>VeeQl4P4eLRQ[OO2aWgRPk\W_pKh`SA_j;BafjZAT0E0o11C<i
A;:kYM`jPfX:0VEYQk8kXBI7UHDenkj<dknUU2><[MLjVN8kpV3>GohjpX?8MF8F
OJH8ZLXO8>4f5QPJ^i\IQ::CbH>R6]JPQdH@5pgjmYG>]=]Z3X;dAe\B1IRKf_kO
a8B6M=\7SPYK2Bk23dEOd;_[oqVUCTFLSq7f03kS[l;3;B?UHUGRDfn]k87IVkHI
^FPln<N=E?i6og@dgFeKf4]BYLjl\pCon[Ki^qie\;=ZLXiCj01n;@LJAD@oAOJ5
hh67C;9IHAi8eP0@p0gDDSbZC<7_M4jTP?1^]n[OCMTK1CbNXijf@UEa17UVoqOK
3oKNUplS]^W6PpKQb_4]CpJLmJK=lq`ji02\c3FmdL5]`1o?k5B[om[D<Jbi\l`0
>Y>6YYeRVX_ncXMEG]cL@mceD0i21hAHEWf;\a@7JoiZnYF4Zg]WJV2:QW^@NUkh
UTnmqfW1_7_aL:\Kcb\=n?NgAPj0YK?SJ=IeDhSc_9KQfHDP@he954[oZATUo>j5
<bg5jXYBS?nBaLCN<S6q3e^n==6pTm^j1HH8>\deV=R56W3BBcBIZSUT=eAeN1cc
nH]E`4k1c`qmZ35KSCEGhb;dR>@kkBm_1mHK0Y8=3i^:Zd8XT\>SP`5q2kO_Si?q
bW^5\^o3b==26LAVD6Ua2UnG<UiVL1WVKKe<cLakFXK=l9MTZko5?USiFU4q>Odb
BJN3R_^fP_NIK@n86_>QeZWkOCKpPF;:ZV@pVB4eVRnF@HR[cRFjbJW:74:8K_[C
HoNIm6jBNN`Z5EO3poZ>cE7hqmN8Fj]aq4T@CZikOfCETlif0C2]P9TofiO@849a
oQHdJ7g;4nHI2;3W19>LFD5GELIU=e@k\^1gPiCPE5IehnhNo\_[Pf@Ci<GSJ52T
`9ZEOU4iMCopN[W];G3qYclLlF^j1_0K6<AAaCAR8\9Whc]TDS6DO:7EeBgS\mEa
?Rkh_onG2WAO^JSGBoAfB^kfiSSWoF=V=g]Q^9:FG[fXklaE^YmI=2D\Rkpoc6f]
nGa2CPLm1kF`b7`@6BC>FMWk0X?LN@pJKcUCAkNHG=X@TBfe6AAKWgZJ6C28l2TX
SkHk6Fop:G:`Dc8qfZ2QQI[3@9@BRRQ=mRYcXXcR7>iDb]njTkN3EPc4^[gWOSN2
CXbqOOnQZ^7qf2=LC3mCl@0EOX9\e9`1]FBdK28SgJ`_STJ<6LK@4VG;iT6GOWE6
J1T3<AHQVLC4jNBf5baU7@GWli4Z^@98M\i4?7bl<2DL[aADTG:0X\XqK7b]=MQ6
cc7\mBpjGB>>]Sp1`HSGBKYGAcD=SQjdf4ni>Jo5DBo?@iVWTd>;\gmle;iU_nhf
OEpj_SX`6dq?P7NQkepg7GjQ`1p>8;oQg=qK=D:ldERi\YfdO6gC16Dpd>WMh`b5
12n;fbm3akSCeMnOk43^MSLH1;Sbf9=7n9Nn5:nbaC2iV2V\<?eN4QEl;dj_Wkk`
]V5MOELMjX_i_FGe4UM0DEnKm4@S1aqndW3BiAM<K>X_mE@6W:m<RA_adZLU:6<]
n`q6]02`0gq17JS[9UINdGLJZCTVOoM`6fPDl43^L\=EjW3=W7TjG1KVKQlK@mpC
OJ8?9aR_lZ]=hTm>cAMXB73TeXJANElSh^h1_W?ikp2g;6j3ipho`iP=c9ePSOB_
nO0>\V1l8>CKHA9icfJIG1eRHGlgU6Y^ELaT:S6:I^H[78<IlBh3`6k:h@Fl^HSE
^==^<eh3Z1=MORLi<J]0UXcg13m254bDqHWmZ8j=qZ0K26IM7V:W@coWTlF[kc>k
KNUgX@GkQIliY1]f;Z=KmK78dif8p`Y>e1PbQWMWdd25TPYTQMTTTKak6hn68SQ_
@nmNi^GO=A2=3JK1CLaa`]Mq]>4IM`@q:egPf4CqS8>hDZGpX0>XWgDgdZ^6KCZq
ld7RlJnp@U0<05bpl9gQlg4D3HmVAbnmo3eobWTQ35eAi;3fRLPOn6;Ql;@J>7Mq
ahddZ\jO:H\UN[DC1D59k0Vo^AT>gGNBSHJq=faCd<?e_TJQ;DKWdJB2h?2?f:?8
Va^RF^:j50R6p2UEbnHf`kc7l4aR>:N=omJM2Aoj=N[h`2[;:j^oZj<q]5G4PF\p
ToW_nB829X`cI3VXHY8E5:RI<nWUdkAN;5G0cJ9Y6eRTOgo15IYq_V:T6Y[7Ti8:
P_=:m\b9Z1ZLC<:J6=2ZV@NZYDbZZSeUn3LRo:lpLdiC^?Bp`bKCh\iqQ@oBfncp
^D_i5XQ[[j2CQ9FTBSWD3^]6^W>@JTe<?odg\EqN4dK1LWqkAc\nd[kV:b?1a4n8
Obf3C@Z:H8cO9kkA>N?<jXMROin;8:8aBg@HoDIoW>qchNjdjYXCOo<j70oN_cS6
koM@Qnh6QOJ11j9MilCH36VciS`I6fpVaEj45Mb7GNjI;M09Z[YEKQGZ]fO2c\m[
H:?c]AJ<gI;RLEbBe`p`6[0l^?pBL:=j`cqE;hI5]apQo0fMl3W=cZH=kmaaNN0b
RmW[?TGjNOPIP@_A@ocjCj0kMVI@Se[hQ0OcX`@==qSMLnX;@:A?7j;@jI:eXHPo
QEHf7oN6AEA_n0RfS_ST]NbPgdn?N6h<\BB1G>bgfg:H1c@CE6m75pGK[IMdDR?C
Am\6hh8NFSDM_0d\E]Wa3i\m36mo3`LG:O5aHG^h4<jT9fgChEY2^BjkfnG\\dRn
a9a60h:[HblI6F7eG33f7SE4FDF87D^1QXpHn>f9NGpF36k]hPq1Mc[6Q3peoP_V
;HFVWKPe\k5lWBW;g]]ROQ;<Dm@P5\LJkKe>i5bm[CQcRm\ieL^I9;DX9?nn^PCo
]HcVWKPe\k5lWBW;g]]ROQ;<Dm@PcL54WpmUHT4GLO\]aPM_5a;[qIh0gWQ7Oo=Q
<6c]nAGCBThY2hGHA4W;IY6H?I6]@mY@SG;[OndYfXLG`nfN`a10LI2e:fQFB70F
7@P]k_J<7=LDSLiQp6`]4CD?AMYO?W40W?J1SUDe`]9T9A4e:eF<Qh8QdKWRT1nI
K=oiK7UlEhZFn1DMgqB_R>0Kj8LSe=j>Y:c>qEMI__Nk^3L8<[O;miJ2D3o=3MJB
:`5m0JD64bD2k``C58NeqQXDU;S3_glHdEH\Q=hBG5ZDdUAG_g;f4hWqLgkL5iA9
JXe71ZoS[oQ\KA[0N5WM0k<kgaQ;5egMq\a5LI^>q@QjBokFVZoJSi=VN7jR;SQ2
ZQ[6J8;l7>RMbgIh23_gN3kgJF8oaX0pWCD<FX1i7mLFi]IFDh?90EYELI6OJ3pG
fk;WE=p2PWWh\=qneZ7GAlqo8NZ[g2\5=D7]H9EWVF6mB@B\B?@=>0Y?cX9HFlbD
;T]532_nK?Ng\KM@K@Zf[d`B^g8>QgWc=Af5fCQNcE59dIkX>q3M<5`mMMOn]D_:
25_1e:Qh7G6@4X:aIP[IekBiV9=0B\eJcRbG;Xlmp<aNlLHTq?I=hEc\X^<N:86H
G@W_e^jM@A8ZQ5@\N;D@m@mSJLcD_pNeV8UV_TgkWmG:?]KNm\V1YE:hQ9djPegW
>bgHiDCM^Q`b=bi6]RB;qH<@J[Uoq:n6[CD2pJZf?aHZq\aF;O\Xe@:G4Kc?5B3S
LLT_=l;5OP;7PYa=7oM`ZE1_^LcMB<<kGJbNlLG9VDRoQEeT6[LDgnj:]V9pC^M[
N6jp[7\KmBUCR_SJXC4I`j[kIRj^XPP^92qOOnQZ^4qj^JcG`>pSGRZlkG3i>`<o
6AXUo<=L;E0QmYO3d@Sb<B>[UnXY2oZY]gLMVh4hc7RPI;]7[n]]2GWe;oF\aFG:
=11BYUa@ia1e1Z[U8:W9T:Dq0464<ZbT00Sh0;il[A<:[d4I62?hShOCmk]@>HCq
lIh9Y1jRiWG9odak282U\nC01Nj;Ni>6hf?;Jj;ZZ:@OQfhqDS38\EgeaA0806R7
Zg`W;N9IU?54F[=E1:OhZMoQe[aKp>6^J]_OV5XWb?o:g4gLTS^KTKPe=?\@60RG
^7Hmjq^JU23E17fPnMj2P]PYp=P\H9n@qM3J[C?0QQl3\YSG:T>05X^d\hKQfjTd
PR[>J4U]049HBHL4mJQqGK;\P>nb[HHOm;59gG7=NUo_G9hb2JHQO0\oO1BVL4I9
nmLJ8_`V_ADe>8Ueq`MRVTX>RE\^HDSjh?>I^a8[WEVh6<8Pm[Lg^n:fW^bm[D1E
_<W@24B2^:1<L;eZMWYl4cTLM^gj8_gL:nPJD3IoIcSXB^o06_FINQ[Gf8hfMpba
h@Lfjq;Cm@h^Bpc\;fJgTq3Q<Dn5Xec]4NTA8dOLcf@akoOYn8BolAhm6lA^ejHD
Z>KI9>9`7OgG^>1ci05b2hZ8>1WU6d85g6>>bRkod<0ANS8`p5fiO@]8Wnm>LlG^
7[RCDh7Zi7E^`[1J1Pg7IN6D23<PVK__MaZ8>9BpdWIM]NffSU0J@i3bg42e?fA5
BaJ3ChqWPZ?c@EpQ=eYmfW7fZj[D1gnHGDMdQedm3=lR]>c[`ik@;N\e@:4N2[R8
XqD<CE[;`hP_7TF4YY0Gk?48@8c2BQNV8l69V]JdofEdX9VLdn0VK]n?@<@dZWqm
m:8b^mPe46T[_=APL^i\C7[^f`LfH3>0QIEC3]h18[_0b0l;Yo:Vb0Hg7LYkUdab
WnfDX:Onmg4=6RGKmcHRn35i8CT=dNDTfbDZ[bT^I6;qVn?EUa]5g7:MkK_Ja<I0
KE5E78KIJEqmn^4D?0qoY\`^D4qe4ELM>Dq]UOa51U5LCJfZQbcmKDcEg2dn`U3W
Y6fC7`SCNTGpc[EL6aP61`E<AlLQ00iJ\SF7=0:FUWBAGBqd]bSRBEq29O=LX7fO
I4c9SR0[5QcVP5V6K>Xg5nCBm_7eaJJYg3h^oQ`UTQ8GJqIno_7iXB:5nHK5BU\k
]?2]k`5mMPg8gVGGaBORi@9eR8o>7HdU^=`IIc74a6k_iA[oO8GigSU\aaf\U:J[
1l2[]G5<eB9HdFG82S^[2;919imS?Eq?Cig>lYqgcIO1o=5fIO_81EcYXkL4Wkma
gcJjiUM0cFSC<IKeRo68^PIKM\LGdpINKcXg;p5WL5;@:=Qk`A:nofEa84B_6ND?
i\dY`aS641@8]:INfGEA8g5[X3kR00hRR4`ek8a0\qLLk^o>fp1SYj;<8m56J27@
R>c32gnEk71^Q<lGF`a?nq<1dN1;8p[E]OhkBqG2WAmZ2G9BNXRlVJXiG\WcVTBa
:j=>h?TSca=dSL:0AI<_dN0;`3QUYS6H?Y:1D7gn1qf0a\C^4p65LVL^Pq\Ji2lL
;pC@3hj?k4ZGo3SdW<GN]gIK1AWHOdbRm1\Pq@eM_^][pP8`9`[hmgd4F07Sa<lA
F7YAV]UNXO<4Cl@fQEb0<b=elOJ0\j?M4OA>3j<e9NG`;d\jIZ5?7UJAR;nDaq\R
8A_H;TlT6HD2Z1Z8VPmho29AS=UnFcT1FjSda@T>KaA061p`_k]TJhZZUfae\^LZ
FoB]YBIDMd=9^DG77_UgX6K2mDY4Yec[5Rn4o8@<3\Y[DR:`bElqW8gKkgnq71XA
1_PY@3[[8=kg5g0QQP>2b\Sn[CBGg?aRA97KXUK5H4c6>JITdJ7@3X152PWjaj\q
Hd>B@h^AEW`9C>ENe1E_L_7GXHghi8Pdg9o@LHED^P8RgWZ5A:hX1J?Bc1fq>F:>
`MbqTR9CoG3qRRcf5fKJqN\U62g>p89hmlh4\]2Hf<Wf]InLD<Ac81RSe]WbA1d]
>emn7kMH8c][eT>[ASe3Il=b;FHZEEHTR=>GnT;X52ffk5eU8jAH97ZQ@<oWROdG
>emY\;9JbX>2<h3p08JVb>jgMY[KiKg1YD>ZZEbd>MjXOCfaEd[maC4;J[i:Di5B
c45WogD=eEVc9dQVS^pD]9RPZep9<3T?>ko<9Wh?mOnUnY4Endmb0N`;cO\id<cT
QcY[F6V?_5`ZNnKD@00Cfo6@PlIZS<qG<4U?L[q6k>iFeCp_dJcSe_pJe^0Dgl_?
DLNiFDTBJ21>YaZVigcD=BjOYT0_lNidHh7j1fFTkkAI[;9<jC3aO5ilGoYJkci5
JS@ia@b2`T]A=?T>SnSHggC9\\PH4cQSfdjd_qYI6NE`_6A[KG=>]mJT>@2=`TSO
^TQi`bVgY?gR]NSdob\S=83;;ha`@70lq\PCc`:<22X=QUOl6ggedHK@>VP_AVSE
<EicU?]=oURk<gU3KL_HFlB@1`<\q5eRS[:bpd5T=lTa_[dk1^0dL0??CLSJi=Qa
<PE9>jTo`D03_UQll2gf5U1p_IgOa:eJ5EM9jANQ^5600=O1Rh<oNhj3]\2pnD?;
?9e4fNHR3nOj^Iej3^Sh4d:=fINAM:I:`TN94mL3M5F0cfDMeIf<[[T=FGT2oT3B
P8GFWj3__Jh2DXLagl=O:ngdYnkW35Xo5PJiC?k[p\F[[dF=p_>O;kU63]P_dD8^
i>3@KMA\3N3QmWe=R<Ug7RmVFl0U8>Q^MF;j82I8>476EXo19_COC:>U[A?@hZ6@
GogAhjESMHELnJ@09fmLY<ibOWEX7M>W?395d4Dc5_Tpl?1gdX?pg<UMBi@OPH:<
jLbJIU5DNCe^k8:l\_ZB^hYX6TDOXSMT^c7;lmpQIM_Ibhe\^P_P6S@JmF]kKcL2
dM\naf1\`7c]6bU0=NSPG3SEiOQGLKZ]jK<6ZnA1@gqmYFIQnWq`5AKYGIE^Aj3P
]aK<GcW1l?n]H4P9c5RX\mA1ih2l8:l\_ZB^hYX6TDOXSMT^c[m`iRnj2P2\MLDA
LmVUG0cQF5=]\:HB]]dKef41nUfliJoJ3F<QK8lLhKp;Um@DU6qc_Hg`W_o^4KJb
cQnacSbi[NbU^CTS<9ZPhBp`o70mO=:6Ck]5<eI^OmfIIWBRi[N_@6_hZJU\\OdR
5GdACj0WI:R4X6729=U71@BihgdSX4n8jk_cWh2^DA`i3Imkn@gQd=_[;G`j;UZR
8mYp8e4:>NYpOFllbW=KJ5SC5<PY==g<Pn<=70=RZ11J4m66\E[M1S2YLiF[En<<
FCMlTepjj6N:64qhL:R6Je3>1IVFjPecfSH1=cLfkj:N0WV6ReJFdUcnS7DYDbMD
nI4H3c]?kfV\N>92;XDMXXXU2:5<IXqG8[PX^LqTPH:]X<07[SRHUQgC1EoJk9fZ
H8]RiPi[RncJ_Uoqi1@ke:Np_6XM;UWpMC]GBAGp0>?HD[kZ2DYN3Lni1ga?_[hP
B9jLCWIVF6^D3>VfR0lbb\SYDAK3dEaTV`dc[=Mb0cfci9?afnlgP;=8Pf:aXmCe
`4CNdV3BCeZe_O;HqAIR4_mNa9QA@?BXcVPY@:LjF=5Qk=Dfle<?YjhE`GAgPD>1
Z8Y5H;W21oQd=hE93eWF5RN[8c^ZQ:GWESUND8c\8HlAZ[0qH=aT?G\KoF0N;O4[
:Yq^9VXf8OjfcU?HO6a2iHN=Ei1`O;7WR5`\V\mZ>QKe>Y?T`j?hL2ZllF_N@T=[
jE>V>V=Wo4IiO5\7:0<Vh_\M10[`D\Z1\:a6SE;bTHKCQ7H4FkQhhq6BTMLA56:n
aKNC1H=[BoeI0K\LmiTil\<ZX>gATID^UVha:WWST`WQ]`6<HA8GEJJW2hcUMn;Y
PQacXOblW:hNehVJq:^EPj=`N:@540Y;OlN6RPRFDon^hJc=k2QI]4XPQVAEA_H4
S>H`k3I@6R>qF_OA6Z`en6P^an_k`Bp^:d0=8Rhm[]gOih`91b^?KFhh]3G:`eJ9
PH1Wn_lVen`Ch=`YiHULDM@_RjPfEK=dbKCHocK:@3C\nhUW@3TXKFhh]3G:`eJ9
PH1Wn_lVe^XCfPVJddDoO5F0dHV926I1bYd8_DkGO0S<[8q_Nf=^5V8D0<R[Wm@7
BMcck`Ih>O5G0mX@1agn1cif_hE1`=fR]d9^><4mOSF@HmXWnfhbW10jR\hSJV5P
e;Bc\QRQT@E^0mH@1agn1cif_hE1`=fR?6@_SqiN3lX=[d]NIf@ao;3=f552I0n<
oB]l9fj\fnL6ag0lS4609ZJMc_aeO;5l6WOmVRDYfbGBNSf;F`k@D:E==b5=;;PZ
=Spjd:87GOYGE1QABHjA:Z;Y5SFHNHbARkbMLYq>hnmZBM1U4HM5YOX]^qZeLMd=
2_l7:DjjQkbhjlCn;:?UCHBlAL`YXB6Vck6G^lLMV?OCH@E\3]c?I]eSS?KV6Z:c
n<]JMLS5QIRJTiLn;S?UCHBlAL`YXB6Vck6GaGLnHTNE=nl7ZA_>I]d=o\jneZi\
^G^:[P<i>dUhWAC8Wod6SKMPq;QG2T0hjLK9<mnbI\j`Ak3jB>_4n[>:<<HSBIfP
^VoH`]FJWi=d[iGJZSRWN]K5Den6ahWhCT?mAl>FicK3@iomf;E3^cW8<5JNGI5^
0gXq@A\HPPGD60U<O7?RL4ORO>BNjH?ThSlMU3Oi:3fZ0RDYL1a]dZgMY\Ta[IR5
`=bfX]N_fdbHjYKMmP@Sj4Y1OgQG7QZWpT4[Uk<@QOFDEW5[mLEFl9gO<:gTITC4
fTleZggGapJJNE[:4e;k1JeK;QYYq2mflkoJ<OUbY>M2?GRW695QhfI_@fV;;O0j
BbQ0EhlkalFV6]]:RA`JCd1WGY0P?GG\=;=bGP^Lhgk2F>380A5Q[fI_@fV;;O0j
BbQ0EhlLal_a]flLEEI[E2EW2ooc51[^K1Ge7dafQFFn[hRn_93GefNPcZ?q51R]
5JWm2HAc]N0]HBJI<o><379PA48FX;8KkIR[`jG_gV_KRi5Q@g\0f;[bD?FT^N[>
1]W>:Q?J\Wja5b0_R[@?`PBdH`RReeo@k_\iKmqCh@kjdR:[CE33Z<5]i4^]\;9Y
=G=RbR=3@P6S^i3o6>Wm0GkP;IM07ceon\IhkTNX?n_6g<C0>AlGFTB2ik3]<EHh
[ST`_CkC=SM;?GGn6QVoIcQ@<V;kEZ=T=b7g]oPFUp8DXOROdigJPg2?@0N;ph]7
l\X0FM_fD?Z]HEC:V^R=4>;8Lf3omRUUEG;7FPde<mnK]nIA;Sef;SMk>4H;j@W:
gFXZNDPHEMge>dkEHGbbn?inPSETS2J;QdeKTSdJ@mV0^KDmW8DOVf0P:b0GGlUB
LA3JTFPN0Z`IR9SdX;Nc2AX8L9YT>KCL]XVZfka`5;C7pc]DjH8`\jPdNUS7DFNh
NBjD3BZLUfOgf>m55lSjA0eNq0noCQ_;;45]RKab6_9GGL9mh:7GVmO\J8ooT6XC
b6A7Smi2O71haiD;[QR[i76<80H_C]\c\gfc771TjK98l[:OkIEFQA0`9AE[Fffc
j]a0<i:Zm6epU9TLHi1_612UAf8Dg>ZQkZZNe0YjP^J]h;\2dcjc3>Oj<:FRhh0m
8WiOhS9oX?RbmWll6[7m?inV^J5A6OJekn3R:k3GdQMejZ:F1;cX2Ce?^IgpZC8P
?af;ZLW3AC_57T][CePB=NJ^4N2HBRflbIhYAPaO:kU\?D@EnSZ1PPfQJl=EMJll
\XU@p<ZlcgZQEVaiP551@Pb?;28KQLePQMHh<HIIk^?[<Q@JJQb?;^d8mYOAXlk_
C`RJjBAI1>`Wpeg9TCm]Y=UkaWMM\H577:@`?[XfEe]_EY:f3=oH^of:h=UPL:>f
\Pcg@h\5J<RB\HS\R=GQVK1odRPMbNLfBkHRo\5_LhTLGjAT5_hHB9G:j\SY[JU<
5KU>N`Xj_Z4B4;<kY8Y4^oW0[iDP?>5Ona:d6S4kU\>KqM9]`mD]_:8hc8gl@7mU
4\c>_c>?71njg<ZTjjmUBjo\C`jm;3XJnkBOnC?Si8o\g6LRNF=MGpOQ_CXC1M]m
fCN2C8f0>Q9TecBU3NWX1=bYonMS2D=T@082pA7;PWA37?RT]\Y5]]7[X37<j[5W
InFXNoY0SiiYIcRQLeQXUaFCBd07X5aP\7Cf1A;BiXmFgSMBA4:56\OCUgK44YDf
qT9`R]ia0kUKO2VY]S9i2YXTUI^h7:Y8WL[EQn2J8@c=>9Lo:<d2j8HjGKFlC]a6
^U=GQ`VWldN<c29F^S\m^Yk7gJnpM8EA6DXfe<OI;YBjjjXRSPW:@bL`eNi2QiaT
k3>mN6;b<?1kUnVTNAkInAFk9^Vc\Ze2`>:CN=3[48C6\67iKQpGSfF?<D___AeG
kRGmGDQRD`<5@ebjhj5QUWHD0RcML2e[RRJRMRVf1n7G3@qG]de07;m?:n0YKD6V
J^[`[cfmgI6T\aXETl3@O[NfG3CN`Qh\faT7X`3_bUS5YjXG=9G5V:CB[a5:QP\9
JqIYOb7`IgL_WNk7MlRdG^h1FlKWlOlDGIXb[\EcEn6Q_IYlTRBj9mG;TX0O9n_4
f7B86[PFS[[le\19ME>X3UFkf_No^AB\42FJeIQHB6IOYfjc5_>LGa\CQJkLmc=^
NjgA:_LB7O3mq]NQTXbX4bUZ0Kc[4[[dNW9<DKDg0PAN1CF82W<^5UF4oN^>AodG
bG;=d=bl?_4SW`\=jO4FMI_mKq0f^>a_EDUU6<F]l@3MZhLm]6\=9dMCmBCWLQZ=
>GH33i7DhI9c6hUU`_WRA2_4lk0a?og^37A<Rb;Ipg6Wlb0G\Qa>mcdWLc6q`iG`
dL=HWSYZ?PYN55<S^ORAeeR:V>cGLZZ9>OZpS6jBVRGaHhhm0JAa^:ehWSkiboXF
KK9o1DD<5UVCDX]`4l`;0R;[ild3_3Y5_?6j82nT[FI<hm1PTRFdG^=l7cP4W_YN
RfJ0CWbbJmR1iY[Xa1A`O@TKQZC;l<28:A0L]Zj84fnpmU0m0L=I^lQ9biEE16Z?
c8n[O3o:dL6ERlTh>abUNSlCFI8RHQmgbGRRID8I=dU\p;O5O`5<aELgV951DQ_m
:6VkOH]GSb5b9WYH5ooGH`3FHa^>KF`5TNfkKT<6]mhmU_[=qL8NoV?Mm1OBXAX=
Q]1m14^AbDga5peR;g3D]jZOjk`3@ZMhLbTmo1NcSSOZFR=UM2@8l[MJn1IWDb>J
VUNcF1Tb@oT=if5LT]Tc2h]_Ye_m1B`PmBEogbL^E9>_SeHMoLReUnDWdV24:O93
5Nj4VSLEVY=bd]cQoGFoh0Pgj<qgS]>TVchZ3^UEM[<8Kd[ST2Jf`9Hi=O09cF]]
kD6;0L?[5Zj9;@Z<FZnbBo7VFR0mVaZJ6qY4P[m27<Pjh`^R\^@G6B:c3b\WSS;G
H<VK[i9B<h?CANYT`mTFFS:?010\PKYI1HV<SA]iQJde@WKMqIDRDdBS<@ogiNN;
GiNV]NV]KA\R]R?YM7mec:3JKI>SekmIN_R@ApXE0e`ODBcgGaog1<L>qlJNWG=W
X7M[<OT^d:8`46YmUUfTc`A_nT0Uk_TX8^=7^HNLhm=m8cFhb4g`GAZj<j01bAC@
d2FN2k^`E_2BnIScBE8^^X9eS2W39i8>S8SX5<kRE96X8I`oSNCKV@FTdRSXfo9I
?6\oq9>NR\`eb:U<=N?\oZ0B:IdN=<;enR1h6iUoGWUc^7TSGL`O\1R7GBT<PKSm
XHoeMDg^QR=8;l=hGoGpaoS6JAK>>NeAnBaogeAL=ghBk=[@U2@fhYn<43EYGJTO
lJLD>ZoYF[YN9>m8CK`d8afBQMA>YJ;=OH=pS4O=@e0P>`Z@ko5A]g0miVAUWhqW
LIXNFacgbDOCNd2V=q1eZk<5^_>;e66i]om;c5C_QaUZZ?KNS:KHiWB5YHRWC5i0
eN[:IYbH82L@]]F?[7?WC?`J@FlAD7m9H^3d]e5o0NN2MIH=^BAZ^Vm8XJLDCF1l
;aa3@P1jcjIl170A10jj9NJ]K<T1hqT@5N4ZmTa`N>ERj>\aA\DDRWfj[\DVO8d3
OJLNUjlCGL:S1<EKKWR=hkjPUlZTb2;jgjU:hcfJEpfZ27b<1:L=^jXR7DYi=1Fl
[Ad_KSFBe:ZGko2fLnS<DR75<[kijH2CThTU0enHN[IPDUH218LUiYA[1Q0ZA9FN
1LmMJMcT7EV7e?<d1756pdUgM_MA[3l_:cAbQB>KHO4fKmKlO@A\`SUV_10gVCE`
AJo=?@FldC6Y^5WjJbKV<@Rm[`W?ZF2DIpVPZA9T_\S6DYibfdYnG4<Z8dOIN^dN
4HFi[X=oW`ofUp_85?Z;cE]FlAbaEVJ6bqAg:GmZGQWVB:m6X4S<O1S_lJV9[A@^
4jN0gU0BIU1U6M:KdY\fjj98]J6?`VD9SJW1p1>l?5N>eBc;oTbEK6YA`:gk?ah:
K_>^]EAhdFR_enfTD5V6ioOLDA2jCVFmeKQP1n1Kmh?IiGNI2^9kd`EN0;<gB8Of
h67;Z0ZcBW;Nn;78ZXWIa9UM]YoEcVLf07H7V:f8Bg870k;?Xg9iRplToGRDL<jg
CiLI_`V9ODAY`c;f4V0Cf`eRfQ>_BKYPUT;hOKf0WZo8V9mJVPNE10WK`@oa>4K_
OnZRH7lQ<qT_KZ1]G@kggm^2DIKG1UohOR=3i:[559M;S3EndChD;_ebXX6@8`8K
cg>g1<nF8EF`18Ed8VfDj9N0S]:bLdaGND@>gWECl2=L>;5m_9U9qVJA99>]3IZ^
WWO27`e3f]L9Y:AIXS<\JGSY8;Qm[Z9l2Z31k0S6g`7bLWZ[jj7dV9mZJDbJGIKE
mi@KP^[naq_\>1XYGA\B3Zok\8K6q?9SMQT9_;XMlMIFQ?8dRX=2aijFPMLW^J_E
:aSifgI5_`Bb^VQEX3ddSbjQ58iXeMbC]?aI7ASld\<T5kXlXZ?Y6_ei6`PE_VZ]
`0LE09jS\LH^AXIHK5jV02JZd^T;9AT\>:451]XZU5i[qlkIZFMS3m:Wg6C[]<A\
[DEKEKGg5T[G`li:kBBKAj:i9e;Q5g23WAPZ`3;ao1<c>\^U=a_nq?=0J\j7o3PG
]Qnc=5o4=RV5OL@aH:]:dckb]TkddWaA52R7DISW5XRR7WSnaSPPc?U[be=50h0K
?8nX4_^p]noRUi[<LQGUi>D92hCMPgb:DFB9CYGBLj_FN6EZJNF3N`jWShiLm8n=
WY=bJZPS;TP:ePQI`<dPYL4jQeYUdi0ali:Ih^fCPS=Oinha7lq1KRI1hRVWfU=S
3bjWWo7hcl?83m@KYZmKSe4MfJfjJf2T[BUcJ?XV;h]:1ZZEc_=GFO7nNG1@Q1nR
6[dbFmpHm5kJkCld>Xjg^UmBJq=_2bje3V\lMbdRBZSARo_U73TVI`G1eNIZYT^Z
MH39q>==MA`\Q<11nW=1[ALc<b5KNPF;GD:GQ0lKMDYNh0Yp@CUPL^a;C]]lG5@1
VOXmHoL<0WZ4di?\k^Cb6GYZm2J7CAnG0=1Yq7lni=dg?lhMaaPS_Mkdo6GNQgd@
^hR8GLPTGbiq^<V=\ekqKVWg82<[hAZGoT[C7PEAB9IM0MK@OZe_66h;YocZ846X
mKjh82qD;NoXlNEO_g7d6UIjmA5H?_P_f`6]nFG=3Y]5C@3m6\^6\k_^Mp71e<S\
C@FllNdASJ6;1?5U?Yco2iTN5IEZkZ`4T343mRH2a:V2qZm[[k_npdIkbd`RqBkj
3J`Dp]WeX@YW^Q5lG]IK^V:l[<;]G2_7gpXD?DnJWOIQV@EgE6IaFK4meOmmKXcW
_=]`dp5`jagFhqV2JH9\LWJo0oi9aWM7CTGYPGB6EVDc5nljV;`9R^KBDF6nT^oY
q2?Qco3[oUdmQ9Ce@Yd13>@m0ANMj8;W^jIT>;SB_QVUh]WUH0?qg1nS?kiT?ULh
W\AmaDi<`gJO<Wjjij<_`iddSYlAA8CKaG^X7DqLfO8^DapAadl4aVpMC1mWaCpg
Q8IX?bg7WFZ5X[Y;:j2gT3X_g@62Mcec9DhDX>MfP2hHUR9JoMcQW:S8;c@LnqQ?
VD@mT[V;GOiail0gVO^6hmi7l>l_@;FJoUjJT89@O<]?Tep_Ded8K1`W3?74QZZf
aUHX@=]iVR[H9jWSVdJcfd\FfKWT^SN9RnKNGbjen@V]In0ph6=8[Kb3LUV^c4>X
RJcMcZEhb7LRio^4<d5k\^ioCe9kTQSVUeU\50Im<g]C]aUdhCQhpE[42`:7p2@6
\Y]XWnP=`\E\C=e?EU6mLW>\5`EnbI6]T7eq@C1dC:H;N[cZAY2WiQWq;C\MlNL<
J4XhWYJgW_8dHB>ACaE>8eZUR_26oQfCSOBN6NJp9@11BCoqCV=_?7IZ68<j=^VD
XEhkjCZ^oYJK4E1TJ;PiNecGooDGGEC8a4p^S?`\m;p@44[>a0PgbTWIkOKPQmZ:
eX96^SeaZZ[EF]dj<EMf7TQ4YMM@UW2qb_;1jGLLH^iE@LQd1^3qhWCe:LRqQ5Ce
h0UTehN2hT?mAWS9H_mhQTknc7\Q]AL2gZE73ET2FV_iUlpdBV9IhZp=PY<S:MY;
:oS[0g1l<`pIl?GDiAq2gmS_H?BX[6GEaO6Z?NNKo36Ec7pJ:\DI8gRaB:beZi>f
?CiNlc:hZ1L=3\8lVbDcKfBc5cXVBjRX4qeV46jg?p2f2e@eV\q4GGj]^<qT\PWD
DU=<_VB6d4QiXCVEGVcY\FZd:cDnBA084Km]F^Wg=i9RGqg1hM=NGpin:b2SIqUo
OKh?:q?9G:`UbqBI5E\6gF1EXb^mb>ZKeQ_G;95=g\Yo;0o;D@SP\EiKkaHGYHbi
`ZZQJ[qPYVFOB>qQ0nEG][q\39D4@S<7U`4nVlOkO_G@`mN<c?64LI]39=iKF=:?
>PG\8:pbLd8Y<EhZid>LgBdcWqQI`^0JVNQH<F^1?Y?PY?L3K[m;oVKLa3kOUCQD
QPY9q0bT7DD]cH<K3haLAQ0<PmP_O>Y37?j<@X4c5`2ETq1nbgMJTplSV6><A5cW
iPKm1Dm97j^EJ6[\JmX126HA8CI<;:0TG_n:gXFQe@?U6k_;5=VIPq^<5@?hLF@9
Sc=:ZfNl5k8:2MmT5eJlTBfYG?BaX2hLX2G;8`J?Hq]:c_hJOWhQdEHI9[:D;P=6
i;SFhY01;gYi;JT8^h:9MeFM_\hgT09WclnQCQCc<pg6Rh0M67@IY9jUJIiFI`W5
A`S2[g92hYDOAmm7C8Ek4Z]6=V7aCf3jJA2?BnBA2pYH8eh44PTU5a_[T1ZdQked
2Qg@YWbdD6=gZjQQW=M`T4m[ld^Cbqc]PW3;lelJA4Lf82mcIYCNM7o^n>ll;?UG
:HdP?:P1K<@G@45le5L5307CMSK:<qA0H5MMC4mTTXfE_ZoJ2UiTbU>fYXk0HCUb
58[BV0XRWYNmIhn<Dma7pmn3S4UDD5MkBa^aCJJfl6VhTkoPb5C6STh9cFRIMo?f
LDAYU@MhLj=<OJHoXO78pN2J9K`>ZNFJ\5j=d\o8ZOoSU8eW7=QoLF?TMYn4hF8i
T6e<[fLlq5=97=M4VYXPL2V>K1OSRNMO:n=chSe3W][;]`KNnDESZR:MaDC]=QlD
^Zm9WJkfpBJe]<I_CU6>Q=aa7?5^7^i[4[W<F\Ol2aCli7@oeeG3MP7pT<O<c?Ke
ZHGVV_dXH@:fc:059aZaIM`cS58OfJ[PlJK_b?\YU6]1RI4Dee8Yj2Nq3oP^17nE
7W3XTo^0lS2m?c6B:7RZO:UQoK^]ciG[f2Kc2[7lQ7mpEOT1<b\BUBI4J[M_NidW
Z5<2WmFMO\cI5<49MDVKcP2`BBS9>D^kVm`J8UaK1BNp3n0k@eP@F>>lIRAL1a?6
4>0f;jS;U]1ahQPR9XG<@53;RRepF8=dgU0hfMYG9QB=^N:8;o2HW1W@SN3>YXi@
Q<p:=cX;^SDoTjU7fX38nPbNA<h<eBJH3XKAdj?<f_bQWn;1SZF5[f[FRKXBZ0q4
_@E;dOn7:he2ZJ1g\F=]XC=1N_?;o>WZda:a^Z@46KC:0q5miWnjHq?45QKZfp=^
FL]C@qS<BA6Z6a<R09Hhhm0:V>U=VEHnK3QHh6^XJaBopeKOo[PYqdQA^5lha;BN
NI`N7WaQH9W\GHF<2@WbciY=alMObUSNFQ[YinLQ`DNX_Qj:UfJ9qNjeGR^KB4BI
DCl0[^>8`l0iBU=nDDGTADeR[Wm>^0`WfDOp\F^:RHRe^d[P>]0mLC=bMbFIRc5X
2haeL]DaY4Y@RV<:m3CUZjjqG?QU@2Um3:1]I?KBTVToWd=j@ZkS6F^j30Og<[I0
h<D>X_Gc[4HbgJ7MJ]JgJDjpnUWC^Bmi<6>236OmT?dGK1N_m`LfCd5M4mf?U@aJ
^eTm9ihjE[1j3kn6_@^MLZ2p0HB3RKU9@i_@R]eBLW@`kS=gSF`:eG]<2VPf;0ih
Ic^DZoZ9AKEqB5OR71Uo9PCA\NOVJ=E:;`bl@3Zm4Vl>E9U>QnVoFLPM_HE2]]G;
EK^HRP54Gk`pe?i[UgCa^kkhNEE>ndf^g_6D[n@;=]Q@<^Y\d_Ycka?h0UL;_7Xb
oQ?=BG855P1pkOU9EUkJ0N=?0Oid4@D\?]bB;B`7:_faOU=nMbSj:8?\\0nZj?Cp
5aZc\iT_ZUn@EUY2ohj^<F4YfmnVb;k5[S0G2CM;^3XV;\Z8h2pAE@8bToATHEFC
0Fe?EgW`A<gR^BJ`ZA0\QSBJYc^=C<<J@;a`kZaC6>WQ3P9IOKpdI1NUF`gd`E4]
nd>^Z3C6X6L;U`8L:?UOV6aU<M@Z2ADDO]>c]h37i>j3nT>3Chp[od`>ReK?QO1L
e<02lE;7nJ>RTB03FMgbg59O5Oigd;`ASN4ghiqoX:cH?Aie^W?Bc?Q7BGgVF@L>
>McACO`CPPIQZS]<S[?k0C0klSij]6?]^CaoLXq;LYYo@ONCNCX1YUOL71[h<fU:
U:cVc=XCXk?fF[i:aV:ZVlpSPnRnKOb;W[If5WZOV\V^m^8agePPdXmO?h^A5l3Q
4blbkM;dQJo3`bKi^jpnTOIe16On?iW4`Z`g37YJkAff^SI9g4XdmdIm:m>9bCi]
Jph0_04CPp>gT^Z_cqfiOAWo3;D4@E`e0J`mUVU@f95Y3ldDUkGCJ?hLFNp[g^T:
6jp4PYgUJm\<1W<G<7o6:2jj`8F_02F6F<WK[6mgEa1g<V@Llf5JNnoiU3PNW9R^
8XLqh0lKCe1P^SkF]9Rg^iVReTQ3Yef6Um>4JS_=QmdM?g5UI\T0nbkLKQ<8q3QR
i=lihD\M?Ue4OYI6dS49SfgkNO[cPhjVE7K21Z7A@E;5qLTk8n>DqF7]6Xn@`[8l
Y\=D?J9;2J8@ZI2QFa?;3AGnF7o\>h]bqg=FBZ6O6KVVOoGbX1gU]R0OV<jB]H08
iC1=qEjPYLbKhRTQVm:AKCZSpY7Uh5F`q385=kf<e^oiTc=M0>d6OaIR:iOcmQi2
BbRnIb0FVim[H\RV6dUnP653I5<^9a_oR37_=q[H5NF>jdGL^U:BV8jHDQYEcSFF
ekA;^Rm9Tj]Z:X[6cGHeJYcoLR8jDm\FHe[AfpC^Uch_;HPZ=KBIkDCZGo<D7hG1
b5BXJ82P;]f<7QK46>9ViWj7J[_FWa;B90Jj?Eg6p1UGXYbO:b130S>gnI;_APWR
JCkJI=KJIALK8IClIA^8hn_=q;@[D;HL10RcRF06c>]hO[]]il>\4j9YZd?S6iX8
1N=C4GKLAEM_B?>=IH499R@Ac^b4;T]eOpVcQP:E`p2kg2?W;V\6XWA4D3eTgpi6
c`DL;qaULflfmI:WCP=nVEN^mS<H]J^Q?fD>nkb<ZQalbaQ0n>NI5f7nfFT`dI9D
Y;\`T_a\T_p52K<4_FCIkMiVi8_SBBHA:J5ai1GhjfVB3?@FO_n4`\H<>m=8MhGO
XGV?2cL[Tmp8o`;]93258B2NNKC8QlC7<NQCQPVokHI^0L^4d_X1TXeWT5IP1Y4W
HPo2Z2j@QO>E^p3ndAeK[<YoN[P9PUKd6a_GQP3;Mm]CE_DeYUgg9`gB_n>T1pKB
W7OL?qF@E0\9OS3SAmaE9I^XBq2jTDUNMkNF_^dlR9:\Z8q4b6\J^dq^ocDhH\o_
7FAd3YC\PO\nPTm\dCNlZ9lXRk<W:gmm7\Zk>;7U=bFT=LKS?TjW>iD^c<Ip>63Y
]E`^kiJg<W_gnA^5?]XcP>O;Ii3V:eU9_GmSIb3C_Y1;TGa504h_Hk53TO2p@8:=
dP?:P1K<@G@45le5L5307CMSbXLb=\N^d?2KP3gkHY>@>V]alb]KnQBaC`Un;Rp4
\4Yk>R_JU]mC_WJ2@89kA9EH`R[3e;IiiH\3WZTd:mXfU;pjB2W9oJp?=;E97Y9D
<Ya39OGmDqS_K3ocXOpbQ14fLAp6QFZ_551Z3Tc0GZ0UJBkj<4i9CG@]\HKWVlMR
eWT3;l]a`S_KmF5Q6m8M>^V50@e679AqMTQOLn3V2e2E:j2S`]J_W9@9:Z1hYR`4
X72b4WCiY8Jk@g`=R>N4Jb4fIE\je=1pIQ2?`0Nb_FkI;B<l]YQP>DQ^1SmDI=?X
0\:OMa2mRW16@GSk]_;Bk23YF=BD=QS`RDLc_oNbqJ5Z=jXb]klS`A8B0cihdmka
g]f^<A?l[W\>8Q_ZJmoVYKTEGXmOm6nbmY:kRL6DeQ9pJP0SgBd=1Wc58Eo[N=D0
EKIKEekM9m9<fT<QhUTHIjaXglaqKnD01:bq36b3OJIqO749Z``q6PI08CRq>fbA
^_Mp5Z6:UmJph:;Eb=6=;W09O@l?6Wa^R`fmmX32Sj1ohN09T0R`S:L`<]W2Xi@D
EbdF`6Ai6hL1hCc?0@66;W096@l?=WS_1f7PWWW_o[\Go37I0X5;M];1:dd?=_\B
9\]jVGMd:_SQTH@5V;3?;gYpa1@hGja^76:?MFE]S7CH=:8WK@KB9NpHV@J9eFH7
4oFF[^G`ANBebLc41fn]1EV0@0UfQbjg[al_m_MnCcL9K=^JC6Fk7A6<k@VUKF=V
G<=Sf70Fa2CBVVSLB7Unj5HJj0gq@Eb3EF1L`OZ7i2W3^XnB\T`;]CVEd0;;1H2U
ijeHO0G`Z53B:]0]K2@i7TThm^7O@7;^q@cchNU[E]S;el?b6L1USnUi_3k>3cLK
V^mK:3Bc=[]`ZSUV6dKR7Eh8\?LN5XjTj@8cNN\P;V4f\lATfO1Tm=L7a6LKmbM]
3ineaddmcL[beEL;0UGhq02<4m5oBIWJ2]4n5`oq4]7mZf<e2a>@]`kCeoj@F5@i
\nUKe0_UoRWUh]\[Hep`E50DInmRV8S5Jk\BcF^6OUoSac[jUiokcp0R=PH6^>dN
0KDd>m7^VCJX:Q_9qH4TjJB?^2ha4Z;LZXahnI3SX?VIRfJNC6G^X>dqLlIVXL7q
7OF?A[:[bTIJb06C9K]Ei<TQDTOCK4K=7EHlm<H^9PP<7j46I9Z8=@<f@SjgqIMH
8CP=HB]7<W[a98B56^UBK1mCHRoADJ:e\PD<P4ooG;hMKq9kSToXLRZ@:XmNE56H
?hd<HM39iN_5ada[DN7\hQS`@OXSWCEjZS7nlWkL4jqAY`G0?2q5@ki^DNpEQ5VM
>4piN664>4S0T<J[oXL2BWQKV1>H7^eZ]H4_Mc>3k=9H8Q[l?9eP5JcaNIBV>4fh
nR?]DGqDeA?^H7DSKn;UIpa[E:I>[pl;dmIT>GO85ffbCV8DMkHW6k:m>QPG37:0
6bj6mZ:cO@KOUZM<STTLL99oCcqeolok==1=NAK__5?1g[0TBYnaT`?`8nI0:]a5
1L0DS>Y@FjIq1ViX_NU=clPB^^=IkLRQCTm_9Vji7iLf;QCBcKCSKW>0KhN?1QoM
3jDQUBo>paI[[8Fjpi^\o4F<pXJ[lgbnpaPPE545:hkOlV[i9aEhZ>GTJa78`]DQ
h<DU=5jQecnm9M5=iL_e_CJhhEY:OYc;kOjcd[@<_@HN1T@PJ`5UF>Nc47a=c_@J
53:CoE4]mLmp@@0EgmRpBNY7YJ4;dc;Yh_RAh3`CV7p^^PHWblK@RVGJ3f7i<<m>
8NdWW;n;;]<`23oYJRNWUGl=3XJ;F`9EL;MW1>6W@=peJDTK\nCW0?O5`:N;SP2X
RCIBoZ4nOh:jAmPnORUkYNN5H71hZSX2BGX<?H>q4[WUVk=?4<42gN3a<JR>iU1W
lin;l<026Jgimon?f\E2:LI]Tc@OmXBlNIOQCmE2E^po7kZ1Zmp\Qn4=X_cZ_LgU
X=ql6A9>c<qg?BfJ\Dpbc2[037a23a7`9;7TVD=iL<2GenJTYi`X3K2;aZ@Y1fh0
ndjljGf433=DZU6ICIhbal8pOZDBf7?pM5PPP>7DO`=cJBaeWj^`dfnT0D\^o4@A
h]T^N2qYIY^lODXCF9P^_dPSk]p1ii35Zhp[QUfF5X`ZQ\YEXbi^Jh[GTkRcTk9W
k6jJ=?dYU1X1kZ[Kd0<iO_AZd`DhN>hC\_Cpje1AC`2\8^_E4?UYMVMMCm0oI9cS
13;]WN2IaZ<\`3DdDETIJF1bCMR]J>\]1]]<EgeD6Wq^hJn8f]W8ePll0>0d\BP6
^mih44L<M;=hLgLB@1IN:gGEf:ca4@e;:_@_Y]4ka8V[f?pPDVB50ZXO4ejJd`^E
An:=?99C?iH^KIajT8CE8LMaVH1V^8dI8EMLU@6m0lLI0E@C9mAgP?OpYgf>@KYp
oKdF946n?ZFH9fiVQ9ap8C=TfP4q7eaUFem`DQd6S2Jo5iCK0CpSUR[NC8BjXYm5
<bblUdZilaJJ9FIAUaELc3aSd<R_36^7n:^nQ:BIfoBa]kn4<OHTZM5^PpI1HF:f
dR\3MB1U04^aHcBB5YW]^SDBJ>B68HM`H7ieM@T1YM`h01=UjO4[<AiV]2i7ZqVA
;]U4[]\g]J7^3Cgc=FA>0NDaa3JdbVKW02?P9>IDcDcfTEnj2cdQ0H8ej@4CX9b^
mh61O5qLL1mGKopNAM^aYeP52SooQiU;>=qCRG8\^5pEK;699D\b>:SVHBn^V]Bo
ac:0d196AOObjQ1BJ5hJ`Pl9@9`2HU0T0KabT0T5N58\f6ajnp^EbOo@2?bo1LLE
Y\X`Y@Z^OTWlDn@0c>l_@eHIc6nh4\59JDGk2nJ<Tm^g7^I]Ieb;hqOGmW_>5K<n
@ffcTgb@LS4N9lTN6::jO]<C`TlF`G4noJH`>`I<[1qo3YSCF7NJO>kOP4n:7CNZ
BcGkaaHZf:G0I]N2LC>Ya^;P;Ad7XcLU@IFTJMYKU99WL3JYGccpBXW;FD1qMn`?
5[g6pbdc=JcEqDOmfV4`^:j?C3^0f2l=Rh`KNedV6L@oHFiI?<n=mT?ajRPJglOA
e07aT[T9WPWJ6RRaP1>pMl@f?LZ?VKlC1E@oiX9eA;P8M@QoGjc]nVb_5PP=kWjB
dCjbfaAo4oFUgJL74M36FHYpZDQk]doRa`gJ?hZZ;>?]NKZHX>=c@QYan?Xm?WGq
b0390F1:8YQT0Z3Fb11@b6[\C5Z<9foLo]iVlYGB30nJ@QKf6egjja23M`P16;QP
im27jC=EqD>`_W4Bq2XNc[9apD[a@aPK3PF1WK8aZ=dW\jY8dOnKoqC]6J=>gq4A
hGKh9qKCg1;bJq2g3=Zj6dbTgd@FB>DKj^16FV?f0T83_4^k_D0UT0ZCdb[;nd48
aJ5UGTYOYCeG2J86<8?h@eb5e5Ri[m62PBHi66kVkdAB;8EL9nagbim`ASNIKIc2
pa?FFH?\cOgFVHRcYcc2E\01XLiYjH96`lHHTZWO89oMY^H3UpD5b9ViW^00]a[H
:Kk_E9i@_R\aL5llF1Hdl:aaT7LjONJgd:IldcDWp4a;O26^p=^aDf>mC:o5e32C
16[U\40[[MMIX5XM_den][[SiVRL0n0=S9bJ`iop0ZPLV5YpDAVedKCqCT0lB\0p
`K75S5bTa?Q1cDaW;>Y5Da?T;;>VGOVk:GJihiC\=UYUf>aZWJOX<317X@??q7eO
g0@\piXkL7ED7=c\ebRaTA1Hnq@RHY6RUR^dYc:Qk=30aY>MgS=hXS7JI9JdVZQ1
bUDNhF>f@[qHb3`?gIqRUWlOcEpJ<MjWV1qbVnIB3Yn03hJZQPYgQjeiYW7]a1QY
Qb3HHk09B=RG3D2mak>j]Wib^b95bSE^k2EVgW:?^mAqG6PKS4TqD<n2h9bqT0H^
F[aE2R=REbNPjm\\9l`eiK0XV7K@[6?@LD<H4G0X:O0[10<lDdPNF?b^SV=ho\H5
Z>a]2R=REbNPjm\\9l`eiK0XV7K@[J=@o@p[]ggX:D0]f4F>DVacFbSoA6AAaB:p
i0mIVOLAa^VM[]Q\o:C8PIU5fkTSYfAGP?52E_MY40?6E<IdhoC7`id4TCo>qOgT
oAGSnGd23:T@TUP^m_KW8[A5YW3]1nG9IUCmFMMTPS5X4QBJgk1^fFgmUe`g88kf
5ZbS_A4]?>;F5iiQSUd8c:MZ\n[Dn7d7qocDA6:Rd[=2K>I\nTkp?F\>IjbRjT:N
O8nfDBJiOX^f970agO6;QKW;Yjh2nVC`9mHc^b93Mb8FggBJgbb4JZ=^m6OY@b2P
O;Hn=^0]l40gPaW69F3mo=36bZ9nqnfA:V7kOKWUb3?m0cS;Uf[;oPnab@BCmiR:
3I7CQ4OlA@HY@Ua?OFK6aV?CYX5N;f>Lb:]q`ll9UebNDK:]ff\\6femb1<=1b?p
B`@7YioJSaXb2_L9O`[d3II2V]38XK<GRkaUVDhCB_UEdJeiH8qj;XNL6A;U?2K=
8hjbn7=ZjZlY_k_?mULP:jf`_KILR?[q5\8>K4YCROSdZM5TKLOfUDEeoXZih<8I
b>oF5bMQd^WpCULmRAGq5]=02\40<fgoFjGkF7:bTWIhJ:59j2IFZ9UOeZBVjRI3
:8cA\]ajIi7\MaZ;6]><g7PG>j7SiW1BldqeJ6gSmC2BFNmdlE=?8`=f[o<0\fN8
EOV472:q6Ig>T[1D]f00TU?a^5KVnB=9]i@5j`H`adSU8DUNb:h0j5bKmBTKTe[G
4O5:L]Pl71C`YCmbqIVLFO6:q`9KCXH[@;ib[jVAH`[EgV`EdiIf8@F3_OLMfZmS
gWMGY1[@PCMEQjDocqigMb_lg36^3Rh68SMRDigYO@TTAAKK]jH@2DYbVcJ343>T
J8UNg;:`L2qI01gUfmqoLUId^Kqad<\3gKpHKH?Hb2M]X0aVh63__L^^7Tg:nkGd
iGW1ma]2YG4nbNi53j3c`i[Ge>gqLccVWgmWQkm>:=hYdn2E5KJ1Q``GPCdL2Y4f
[HZT6TbBU]1^P^7YbhAaqIGJ\E7BTUE:maLdF[ohGIogQ73mnHndOVK;F<kVU[?B
<gF2THTCK5dJWjfMa2K:OKMcp[`amfZmpH9_o\6PW@4RYURQ>26Zol93R=P]EF>1
9BinVWOf@mOR]@F5_Y4AcPQ5iRGiWoF;MPoFW6@^PhPL^PipdhQGe7=Ak^Od;08]
\cjWeOFH_jH\F:S2i4QY_F5<4UQmaFo6i6^C7m5kF[Sd2<RH60LhdagLp4KEhFoi
VVlC=m;SpfhlLZYjqM?UjX92eG45j656TOJXHFLmA]QUBcJ]lW3fGmoB7=f24kGI
^[;?SVHL1pZoB@MW[RHhn5YRMd57Ngl@]ghGJ@\B\FhF67G3UMQ<[AT>BL>42dih
A^pCiRg?Z[q=]0khn[p_;=9NKjpE54W@lUIJhaW:1NV=dY<66mB^NjjQDfh?41XJ
Ee1E>CP`XLOGlICo:X[qBm?O5VTADdB`0o<Bn2jlP`fHFU[Wj7mWZd@Q;V8BP08:
?7n`5X4a[07]q_X7BdUb3TAg]NQP`?9?i;jNM_FKiWJ<5KkG[WlW1?O<WJX]]2dJ
J6LYF:`087njS4CJZpja8BQ\Iq4KHnIDDf>[I?dE2cJ<<>884ogJE`goOB^G[BZ8
O`iNPjjWe9Hkml:g;kLnnX_O@FU<3;Q4D;A0<n_GERV8q9bbZ<B>pl17MWVE@iGC
>Y^PGoQV]JIEDWZ@SP3>3H:]E]AEMgIBHLEMFRCqb>aR[c>XFRnj4lGMmbB>`M3b
MUgT;a9:o@<4jFBQQjhN0HcT]aqG=ALZ4^pQK0jE2mJHlnTa4T1IhiJXMX<X@fCg
8_F4Mdb^OCK2ae^G88F348KQfj`kY1HPcE\X6E;pjg9dC^Qp7Rd_AF^p[PfRUZAY
hbB=P:Yf3d5REF^_>gm`Zk@QF6\OTY2I=ooeBOGlmlqO^FaiDJ`Fld9=B0l5:3b=
1XTGiO>J][1CNM>>5TO`g;\WdQPhBpkAdhDAPqhm=l^;>o;ejldj_iKc0KTN[E<a
MLKB6:HCT@<7V_h<q^W4LhdS?oG\RjmS<b@?N7QonANM[NAS`k6U?fP@lhX]\J1@
CN=p;RQh3=lORL@hQekh5ENa9DbImXUKRcijf[hb?RJ5=TgmNh71:0qUo1YI5iO@
kFa>1]Ul=@E>RJ4Zd0C0cI8dJKYOYLZk`dn>5dI4gKB9bMkX?poooH=iQbKOmog6
AeZ1_kpH_BB3AFmf_mHQU;j`3FD=kY6SLDLI4SJ@co32bY]HJc4b2bKB<Um6ZQJ6
1qn``J8`^icVdnT]Ao6KM66^EbVc8Mc8Rk^^m<Y]m4^>h8_^HTljapok7<6`4Vj^
ZS@RCI4[SG[:jjE=8=Z0`LnSETO579Ci:j\2_UEc4qTbA]50?XH@4n0\_AgJ_\DP
O9KGbR?i\OAoBYb_FGhUD4bf1S\[?[J]Qh;_\jM=MHHe`PQAZ;Y8pb`WC^^Kq2CZ
?nFl17L@0g`PR8Y7W1lQnc=NX28flQA[ZHnQf?^HAIH=q087R_AA`1ZJoaPDSgbR
540O4n:M7XQaNDQcmW@mjhQ7mBRep<TW4>AiTNI7O[[S2jHKNS?0Ra<gjEWK5HOi
QE@nHQUGUq7noPZ9mq<T3IQXjq;^_IDLPqM]bcOXiohMNe<BHE^`WjDg?5o8^RQM
=:ASYA<<bdDcE@4?mpm5D0:HKZPb<8O`0>1:ji7n`Hg67_G][CNdhJ\KG2jNg@L@
6q5B33d]mpe2D;d`Wq^AjTIeMpR<>\IeGqe]Re<1fgc`>km5C9KaJ@NgcKIPCjN4
ZW\UKCbNgN80NZXO@hY^URGPe5m<k?lP;eA=?KRVPgqRIAL0S6]CmR3R;lA`S6Vo
F>BcKcRD?=N\XUGRo8Bqe3_48F]pd8Aio^@;<ok^6`P9VOFaF^kC_Bj?mWlFk:Pj
_am85Mf]NS\fm3QU3nhVZ?Ti;gi^h61LJYN27OTmN6qYU[@P=Om]n@L<8jE\HX4<
JN:=O3B^@@h<L<Wb=b[j@EA^5COI7=mn`55AEC8>nkC5MedP8GhpB?c0Mo^`QRGC
F3bCpWL1FXa@pl1XhT4aCnOfl5d4\A`VadLZNDk9oNZkS^_Bf4a`=Q6=lY`0>XgE
Mc2_Nq>jJGAP8MQWBJh0G`;YL0eHIPOX5iak@0hKYPfn29oZ]bGKeiO:eQV1^Ipc
LX;iB:qTLX\]X2plTX=?LUp@c0CkE78DQ3dh_RP4[LgdOP4mk00?A8YWUJ8kd^c:
mC:II3bA>7;fR;nPX:N@5aN4`iRJ>]6pL>BPJ>lL8^OCdc1>Q@FjjFCF;7`m`DQA
mHN>O6b61J`m4\=[gXdZ=1hQql\=L]9MThKaVZWbkc?f40;UfgBbP^D1iJ<J<H]0
l36SDnA>EUkP>2Z;@pG<]b6Jbq>n[ZAc7A;_=96K@HW6AIb4oW5kAhP3_SUYLb=n
U5_n\HacX\m\oa8Do<Mc:ZQFTT<LZF_VE@cjj?BBqcR<N4217d=[llB1o:Z67TlU
aMbF3CgB@BUXm`WV_7G3eGIU`5R2=Kn<@8mYPaWn^Bo=iHI=DpgLB>0j3qM3J[C?
0AQl3\YSG:T1D2VKVinQ9?o82QRgg5@U;cfmE[0YWMMg7A3iO?qkG1cinHUaEIPG
2TJ_FefhSXQX`b532k^C<jS;S4:[A]e:BBhIGHOP`RDq9>D1__lpOc5n62n=Hm@B
VNAN657_JPMb9TY2P[@KqCmkh4KmpcGHhM\2p[Pa\C_>TN8<d]4[V6S;[3HZeaJl
?0fbHF@hU6VO]2m1hEPKGf9Ti_O]YpULhMhka<S3ibQ;4=@d17C_Bg9ddMV61b4<
IUXJ:^J_A>Y?_FnT[BIjM_qE8\BoA3p4C^ibkLkeQQ`7f<gN8`L?]7Qd]H;f\:ln
CahXjnnPKfEA\dcgJF]RUEc`H0Y^_mG?m;mjTJZ<GdANJmG9mqS8U`9kYp7aeF3\
iGF5JRKCAfZ=IbY^m;Cbj9OVR>BNMK0DeJm_4Z6fo047qchNj?jYJCOo<j70oNgg
W6U2i7a@;G[<hCni=\fb97nEC0U_KJ7pD1OSmM[IoM_SRY\SjFdN5Z>1cUn5nB?^
ZFebjJ^5Ro>2YTNO]1]5_>YAR9k@`1eqnjRKagGq1Y=5m7Gq`\SB\]bp=Q9lHWf8
HOG@^Vcj3TUHH3ZHmZ7OBm^P]CkNERAJCMW9?0F`9BqLdR961=Vm=H:AM1AXffL<
EZKg;I0:kK4Dd\5I:k^]M9ULjU^Fmq5ZEP8:Eq0OVb2XjX3heAWP`\`dKm44P2KP
>1ASDBEDga?YmNWd]S=7;dTSpH4V@Ej7n3@298Rk4;dMb=J;I[MLXj7e=VS2=e9j
2JEd`IHjal]qnVZ_iTA4d]dQk:;:=j[b1DOPJR0_f<0=VD6Fgd=1pJ>TmPO81Kfb
M=M3?3HX43h`d9G8NNI69@\TBYVIc?446I>A=R=^=c9jnMQq^UckeLlFY8J72gdS
_3N1MjQal;C>6DnBMH4aB`Cao_TKHE;6hP7B?hlF_EpJHNGdGQJ_0LD[lbPC@kH;
V>X80gg<Fe^19[Zj5DUBC:K[_Z]@ClpSkM]mlFMJ2fM0GF2<LnJ[i_3>\;TDYb:H
WGD[Ea7N[2YTYB[\hApi`[jk1LgNAAU=??WHMo=ji7[Udn5fAi[jXL<O_X8p`0Zf
LD1?<RM0H0]V3mE@_X;kJK0l?o?=of@0GU@8_lUa>gnIkL=l]na6Y=Nnf9LbVdoa
`NRaGCqXOS:0JiqaY7MBbR2@MGKF>jI?`@[H^CoWDmJo]TR^Jb=g0;^C;3GC\Sq]
c<`iBnkWTK89cR6K5Mn9m5dJeac;E;=IeZPUdQCVhLm>P8qHbm[EeDp\o\8=jRpN
a_IGZmq3RMnHMRl3K8K6YaE97mjZP@`kl;GE_je[:j^VZkW9TBN>81pJCKFXhNnZ
\AUd4Q@8EQIZ^aCmhBjgCP_V35h;g]FM\B@DDCpSZ\>S\WSS\=CgmXOFR:DjS0`b
8XX>9LQYmqTXA=m<YqF8D5J]Ap_Yg@_Uaq8TJIDkeplH9<EFEFlA1=5@>1\O4UpH
bM6@TnY2E3]GgX7J;ikH3AcHE8Yk`YbFZ2<kl^[V301MUaXDL614NDV_;71Jnk2K
de7HKq84Cia1c\?=Hf;X`K\DEmV@SMnP_AVM29An3;9`UV<XXMDl?h;goIcNMSgO
e`V;a0;]Pq@;WQa4V9Z`;KP;;58U;?TDPTb?k>TXFSm@RCC0G?LIB>b>a\m4mEEM
hcJj44`\H@:A\l\6LTmXpW6<7<55_90Zn?H@jG;W^<hOJU4[VjG<<_<:22imJA;:
M6Ma@M6D888;4ZVb7oCoh_`3qRN6IJkh<f0?1n3C\[ZJ=HBJ1f1c1bB?V4KcF=V?
J`_JfY]RQQ;>n94gk50;M8YgDEGpbW@KH=<R^Y62A26jEFCTN];Cb8=aFV9P9kW7
l3VNg`<d2\gn^eAW]>hT5afQOYLX0K9qelTQbGUC]M\g4_1;h;hYgY9G\j6]KWM2
[LacV8N2bQAkGj_C:kZ@c\0K8iAn3GcXa:mdIAc5p`J4a`lUfVKJd9RLFD]O;aB;
f>Uj5VnT_O69hdcDYJPddmKa5l:63gFOl``>A2J2g\n6TgYVo?j]_KKLHiDmp\Pn
geMZd;aA_J8V[AF=<Z3aF2XRA:];[iCXD^nXkK@67Kb4A0i[4Y:IHMXIqUEml27>
BjClYkR:ii:>]1FA7e3\diV71T5<ZZ5KTMe4dBJ]ZmnS:=_>7feUiTY=8glI@TBq
N`<U3K3NEK1_f07KKR;FFK[6?7fL:IRk^_InFNaVBPZ5h_=BNO6@aoa1?Q4i^HRk
g7ef9kq:^ePTG>TmMVj`e]=>5:Z]PJ1Gk_n^fPDj?\0GOAdKd[KESVH>]?25LiA<
^Sh99kSKXLq@hG3E<\8nRC9G@D:QC3ERof_?>A^A[]J@oeY882F37dgle\lokH3k
_Gah?6m34q\n6oRb>pHajQZ^O993lZBa7AVSmS0Gp8fi6J@ZqJ8Ndo:3q\92ZXaC
e4@:M>KAT]IYe@]@V1LVQb35S24XLh1bKJ7A1@34OH:5@]AKjcm<@7ZIZ_JnDU9T
F<e=I\DA_AIMFSbFnTGU7KDjN=QHMkONdO\AhD:ROn0j^FJJBd[E>:?WAQH0Z4NV
_O6qE=n=6f[5iO[:TN:@?5TIdJW1\dJN?MJ?Xf_GIU92i61g2cjTPb>I\@0aZB4W
\LM2F^n=iQ]pPFN1VccFVJkIF>>D79>n=`1k9hBhAZP281_^M\LlciXXLd_36:kG
VFIi\0XnY5a;6ED_1=Eqn;TY9NB5]1F]^\_@R=j5fNEJcPAV>n0_Lg<L0f>Oa7_4
]QXn76P=Y8>pERRT36icGR@9<Xgim7dEhg;E`36bV5D;1X7h:d;IVHPSNaoV4AU@
Cn0p[T0lHO3b9mPlG\fejZX0TdeSYFlJAl5f:a>XZUQPCBf<eiILE7TmJ1j`g82\
7gq;dO\fXEWoJ[dhk>:mG4;XV@_hY`LWmeBB;oE7LM8eTZ]GBT`G27YSF>pS;H`U
Kg5O@BdYLQVkI6p]Xk?jh==NQ88IGYa6j[X>hQaCKEbK?jL??6\J9d]d>J8\aJiO
NJ1MnJ:_QPa\?6pC\Z=Zab<1oRjWjIX^AWde\88F3^CK5mOjRlLcT4;VKH;nkR<_
]1=qIHJ3[OP]2kN;l:RS]]gLK6<=QHi6N5CNHY2S[@BTC[e5P]k2A=Q[bn5>Q32e
0lDJ;hAR?_g\lICNOkGa\h8@cSgMmiR92^eP_TOLf8nMT>N=Z1j2J[hOl0LVAjA\
ZBLZPa337T=q9>d:Lj;h1;cX1[Z[A;\a4gMAiN7PGhW6g4@GB>9e2Kd;bJ0AenVL
`VTkA0giA5WI^kE1?X7@mUp;WT5NdnbNc3Tn238UmVbJ<P;;^?8YC=Tn:GGZ7iEQ
JMXPb:E<c^3Ydb@BGHj2^:0jLYneWI^a<pXZ^N5JFo?A0Qe[g<99^mm_jZncO1>j
;D4an6c^mUQE5TSk`jRJ41\Oi:pFPnP<RE@DIaG_H4LC8liV6Mg<[]aqTk;V[e]i
hNnU1jA[35p[bPmkad1?Meh5_GS^CRB`I9?]i6EVF:8e1FTCRXZN;iPg^=1LD^Dh
oeV\HPlE2EH]SnnBGRf]ZG1nW2[55HhcQlFN8IghOFKEa=FWO=`9n8VG^e<Lh5\8
Eih[RCBWE\W=aPcKhmG3KW\OVjGmLHn:71m>e3oe8X1?K_8q;FFO9L[WOFn\;f]f
O89hgU3Jn`lmd4jMl=]pQlN?YKE0Gj94L?N7>>dP6?EH8ca=>9m4O]C?E=QZH=cG
34a7BlocE65b[QkaKb8cJlVAcG]P4^Lj\a6bZY>9TXW9beN3gOZgdE;o^Fo[Wmdm
fUjR`aZZS`o_@ECO4TJ;_AVXC;kg>;MU_>BDkblW@F9[AXPN[cL9bI0Jb8`H=Qci
l[;8:j;>q_TZZ^_n5iaGi2gl<lE[Ak3A\GSLK2k5h]^TgJaZOg`Ypj4MN7YP8;oU
^7ZMW;^GB6aRUjBm7Ad96T5XWa?HgBI_Z\VW1R^Aa>A?_YNYCH3Yk]c3]9aP9\@4
>ND5o_[_NS4>]0a;l;V;<>`9^aj;XDc?]d^8B8m=QR6:K84Y75SRF=<3QbW>D;oU
^7ZMW;^GB6aRUjBm7Ad96T5K6hM:p7V<j^[RAaZ77IKY?BE12\9b?2`B9W25XS=<
IqFO83A]gbEB11ce43pT^T3_H_8JOE1VYkR;]mYEM@96<AO]Qc;Y0O4WHehIIK:6
PBVCeHYVho12Hh^XHn3NVbl>DM>m0L?_iEg_kh1hn6NaVNX9GD6A>WLcNKTX;Kbb
F[SSRXXVOF_aV6d^;jOj>2NH2Wp\G<IUL0QHYEQZm=c381\R>IO8Cj33d3P9g7J^
PkflLjRU2VV?GSdfjfmWD:=YD@nFJlZ^ac7`Fg7D5M>9ZYoC>jjeJLacO\okXI:[
0qN7f1G4?ZfIYI^f1j8j3C7lPBlaaeiGcm_n1:I=c=kQUT\llY`\fRe;TEV5@VKk
FXV>8V3_WLmVeGQ<B^L87SllKBehSjGhIc5>9aoap@?3J7=f8^<Wa[BF5fDiJVdc
H6WD`>ebjA59aommN4U8aqg2U<6IOdb[bdX3NV0RiHIi6EKabC]ILPP6G9`PkYc>
YNYPfF4XQ<Z31Acj7]kFZoh3_G?0b5WajHn4T1f`HD[mpBU`AFm6c`m7XA;iXnlp
CLWQI8;YG5G<A0PQWdbTUd4i>YNa@0Gh9O?7booKJ8TFTldI]T?bif<BB9q\oXTZ
b70SH]ML?m5:FciBS<_Dj5R?H[MIH[9lDhPS9fcR>7^nl]hBITND:P<<QEpOS5UL
RRk?1DLc:C:=EffAWYo59K]HomC@2A4MM8RNVfgf>`q2MYH5OJl?H=O_7OIj0N^J
Gn`XL>3R1ad:9b=q31<WA[\km[aTM\5ZT<3g:`R84XWELTalM`DBcDN3q@jFcHIb
p[YLcF_o4VMA]ma`>k9B=_9kTUF3Wn[c`7H=QaFhOAK^[aB=pPFbFgh3MJoG>Ygo
CqomY>1RE]BaTgD^i;WR>H[G=<\H<APEf6k9;_LOJL]B3ihcaqk`W`PUiid1Q\D1
b=_PaT:^\>mnAWb?UM2iI?m8WkiOklH1qB_=GbmS4;L@CI@4TP=mQK^h4L`o[UeW
>?@fiS1L2PIEanRq:^UGR<I@BcAck]:oO`4K]9^>^C\6^K@^Y2?Nji@:>\mpYn^H
aV3ABaALcT=Ug:Y>dUC?6eFKV5b=\7`JG2h1^41qca<g9<n>jG@QeBkO8kdF>1FQ
Ca7=n`_i\R=gGlie2U]gqFa<gPgh2^mmjo`kZeAfDPNcS_c\GehcFNR]4a\2Z[2]
FpA23?9_X2^A=YiBk0l>3>mkXUGP:P_jenKmjn7@=UW>lLQb?2qBbe^QeTio9jbB
\OeKQ5:d@jlN=`Oef0A:giC6Vo:8Q`FR6M3cYfUpRHANc2@H3PT47VIE]63\;egK
HM;]82`FcA7MLC2mi8oedU[BpOC6:egNA7YMk_DoQ0k8iIci<G4bX`T8W91fhDWH
E\d7jqHh?kUL`FKcC?O\lm3T`1oZKSaTo=eKcg:bPOTe`oI6^lqS2NDjDcnKIOmJ
=74>j04b6>daka_A[?G<=\BQ9fAW1E^^kimZ8LSmDqNO8Zh04O^l`?F95koh@Bfh
67kg5P6:IfBGZel^6H2:`=YW]@of_]?cpAhiO<Bal@a]\=GPB04_PIW23KCGo8\V
k88Y89]LG?oJX=l\CB7gjGhq=@Y`1>50YRgKcMDIkEI^ifDc?g0WDQT5jeJDg>0L
l_?EVh?o\JHBHnpeS<UTe8\hCflW7[W_AEM2oXFNh9EX2EU4Zd3d<=SfXQ>8X`HY
6XTpWX_4>3[1FPTH>]OHgiPeZMMYm7FJV;bjP^Z9T=\E^QHT9W9TRd\Aq^I^KaEe
\@5`P_00=2P?^PM_fC@?neO\3Q:=mjM\:`oo>=1]BY?mqdbS;2\bq^E?BlSVqMfd
=U6hp=L0`6J<P7Ji>Gdf^=nD[A@H1q?`PZko3hZ[GmabUZOY\PkWVSe6TXAi5<7X
gN:0qjTZAAeQqW:Wl>eZ8EMQ^A;H\hL]W3\h2X3n0h?EDh1MBC^K8chBa4AfpbIP
:1@^hHQU4fS=:084Aen]=T8]LPN]oE;5`HfGSj]IM4_]bg0SaSf5RSR9<W=GJjeM
MROqgimcbYld\_P9PcA79kULReN57EJUkd684O=jX^llmgfPifWq>K;Y\odiPiEI
fTNgiSLfGYVAnZPfVZD_2WV9;<b]iX7aOTqk_]IIL`OhPUCRJW4@VMLKUda5\U22
<:5dT3@U_0LE;RX7DqJCnbidYl0baM5dFE\;AN:9lkgW974d7@;BkhiHS2MXdp]:
WRo>@9eGHNf^NSOPiC^1P@;1J[c4cngdWZ5`]TlU:pnR1V@0nCUBaUfBR1ZWgZXL
dRk8IV?>VVOUVgWlB:6i90qIfmog48KJgC<iLTTSl]Y@]UcjheK;KeZjib^ph?Pd
70>VhU^^F6h:21Z]^PcGAZ9Y5\L>ISX;d]eSc9WRqBgNF6`]32BlDhIfL0oY_N<F
D?:WO<9gEhARaI=_U4lYedOF:qeTRAM5fmMb^\]=RladL7T4L3hP_9`eK]2Og;oE
X19[[PfPf3qddEoK5SeN08>>`;?a_Ii@2EDIQA1V7S\\a<aMC`6WEIDp:0HA6LC_
B6XIe3cWWg`m>EU2cR\2Q;1Y922Wa17T7^V7q@1lY^I6aXi>FNE6FL:L0HkVJ?VU
n1?3:c6@3l^M=@^4DBQY>OBW07Pq]>b=ZXOK@8Fk3Y>h8CBk0`:_eaCblNNjc70?
gGm`f[IcT6XPO@B>k7qFL>Vaj?bRXaem;R2=iE4]X5>b]mGICb:f@Z6DEI;37Z9d
gg<lcd5Q0pI>l_Tb5KfL_<85jhMT^]_C`lij7FJ:B?2Hq]YJccbFbVP9K;L2X>V[
Wc0KU`MkiY^0^h4G?`S]mac8ilTXS`OS9UCpCfV:?V^Nec_i]dfZ99dVFl:XRS1f
JYG[6hJ4;7H_o5`2d<00=6e4q=U;o_EN2WKDDZN:bf?X;5f2A`mlcMgKRISQf[dm
cRdjG<FHH28YRq51n4l?Nq>gTffI4`7<LaGn2q^VLf>aWq[DoZXF8qXKfA4c9YIG
ICHG\X[>6ZN]jCdVVQVCMg2A]F11KnU60_g6[Pl1n7MRPWCdpQLG`Wc:2EYf<LoG
>HlkLf@[`1P>U`U2P4lnlNj92C<U3]7a3ihMYFo?@mWSen6pUcL_Ife=jgln;:iP
G^PRR<IOSciq00YS\gk7lRKki\<IcX=9^41A9fYkTV]_^:OTnhTDP0PIk_okBGR@
CE^qH\8_J0JBlGF\iW<4\kJUkfjh=\]WhJA4>I<L3_9JIMjWZOLT78Z\<^mT_ODq
Td8ZL>deO1PA[\IKH4lW`6YU:g3:ocCj_Og2Y:>FF=^>0n;KdmM3FV?^@F0qKg2:
Z13gGJOWW`=JlFJcY[\m\84A12TGWB6Oi]WNi3WW69]?<RRCX]qXej3l\QO0S?fB
XoSX>YVUN2335RWZfdQlB5KKinGh]`6[AHO:Nf83=2N4VO1VcpDPo<S1mOlS[kR1
:J<W:^N9I255e92_YFe2?;MNB?dJ7JOJSR]miL40XBpSH\SfF7hf8j`9GeT=bDQO
LA`1@WR2?VII1\BFZ3;lZZAfH>K9FMhH6d2>VX[V_Z`U?f2GlpP2_e]?AP59<>Gg
DV4aJHM=Bl?mSX1U>fCGVm>hC@iKb2Hc]PLe:<lf<FH1WRgkQfp63VN5f?F^3DP?
kJfj5SNgn`_Og6D;N5i6aHdn?SSmmm74nXhFSd5j4<bg0bfjOp=HSR^BFAiLmSCI
0WY4@L;<\D:DTD^2cR1_:Y[Y_gS@cDMQ`TOXJm9;laoV9OIdBqjEPfiXPLODYiCF
EY?dZbUUo:gD:Zd<ndZnhAm8AfaA[hG87f1Kg=D7M:pHRoMCl5o>[=C1Ad?c4IAN
=H7TU7b[K8?b@aQ4`FjUmAno@?IIcD]2\D[=3k;q<I=VanaUMDXPfn>6SoS5i\KG
l9a?SbZ1eUlkT5>>J\GQH0R4ccbnXg\edh`M?o:9ELEg2UC6GV3plf]`Mh@GaceF
\l\R\?>W@XEYLhf]HUEVNWl>?Y3:_3M@dF72?DI??`QNTA18:iaq2YTiS>9Z?4_h
VCMV0I6kmJ\keg1;3OAnD3Qn]7c\eSn\X0>O3oCl5YkbLkVJ6lE4SCbGkLnMEX8q
5:]aP55:_5^\8LVHXDE:iaO0oGnej>Val3SU5>Vn;>EN:]A7AoM5`Q0JmeX>>8N@
L6qCV9d3\0WJHO9iS?f7Y87YZ]9@UkR^:KHS`Ud2Pkl[@>UV<EZ;H7J1PP1J8WS?
;Him8Ff^alJpG_oXHF8:TR9:YC4KH=W4`jJB0J?J:Dl]WGnQ@6E;^cYY3k@>oodK
d8b@T\@=9\>HZ7qI;>[dU8p=kM09gepcX7>]Bapm7CPV1^dUb92nmZ0]bk`?0\2`
j\@i;iNi:m1R_c;0J79<7O69l[9R2=Em:oBGTliQQRNVdEPlM<S?SRbBN=^?_2<L
CakP2_^j5Z@<cc=NCd]p<JOc=ohASE6>Bn;QWkqI=LkfNOQcLoO6]<f=402jC^GU
FOT_;9Qa]bV[95_nMA7feGmX3MlWFdchV?4i:c]9Q_m_mh?MTW8ae4Lfd02oSAeb
VYSE_]1`bcV9V5VS272pMh@AfLb2]9KZXhA5_8pRJ;9mFlA54A8^XfdYF=i8^X3X
iO_e5mITRoeK=;[nNR\8RNYQH??ka>WJik\^blqPgOG_5>NR<GB]\OP1\b9;`4B?
`?UNM?7GoF:<N`DNNa;JgFnF2Fh:L@d6BkO?JT@P;2H59qj6G\h7jVUFaPWPmGI;
RRY58e6m3<CE4^F12XR1kXnG9h1[W4@K@]6h4I5A7UQefm9j<m6c:7eGWKgmOF51
CcX]D:pbg2G@`B<1e4XGa<RS1kMLnD>@@;piPb`JiNPDAC8RGGilg[89IMZB\DaY
`1:Qj=9RM:nVQX:AO<FMVCcmcIJA?S`9Oof[SFL?XNG<Ug\TTEj]M]p_DIe3CQPm
T<VQY34K<1Z`a9;>F\pb:;4FF9@PdE55L:B43kIFDYPPlf:jPUM^]AAhZC7JD9ef
LEV<]k\<A<GGU]WcfAYXf<K2F[A6H?X?N?Q5b=8aBJPqd?UCA?MW:Km`;<:KK?q[
9;VBNTA=O3h]NACUVlEAE7ClQ^8\<OO8`_JP^[=`aXpX=BhMb:Mk^0Qi=mff==mM
Ab45ln5>En[OnMT9U>NQWo4`meGooK0_NfH<QRe\@]=?iJ0Wa3=F0oaeCYCFGMAF
PXdoP105=P\D7???cI21W5X_Tm5Vn_LRI5QH_:bY23kAP^]Z<3HdRa8q[7?7=e1B
TaRKYM@8<nmZSai7@^AiD[MW@C>4?Jbe_fT0Xn:mi[S_8KSWYUJ^bTYi4MFWpQ2;
8K:iWFoaK@N?7]dq@1HARC;m<W?U2Q0ieG<SAH;Zk@FkmI7mDoJ58IdVo1E2;U7N
f7B7mQl4HTSQRHnC78H]XdjUUK=?S^TFJQS`fD4c2gP5SAL`IUlN][8<o8TVPXK=
JKB=0A]FK\V^;U0TUMQ^b]TQbVpHF:MnE`IKkmQL7Fn?_?^JNjWaRF?6RhOJR_=m
j?LT:ZdZG6V:KJPi@f7X[MLjk945cAqR`fmQG=GgaJVaD1gl6pVb]m\QV@MR10k`
?9bZIS^o]Sf>Dl>Yq\cfcJWRU9o_fO\\LoTG[d_2=XcQ_c1LCh`TYX@OmW8GKSja
8M?HJh>42;4X>@A5PKjk4d4dOo\?^SoM^Z3L==h6qnR;<g>ni]eVIhTJUSQqj_CU
JOS658KPfD73Yl]Do`X48P7DZ4Xdg7m?@K=6^ROk\38mGjW2;eQ5=OBOhn`MjH:g
4;SJan:e<fD4bHSj0Bi<P=p]H4HX[58^Z^jo4PHH?p:A1lVQifkf]Kle>iB[\9PD
cJC0V4A\5M=Y372ai=>8Wbceb?EaW]2oC7ABb>JcG6f;mOBQdR^aQ\S9TfoG]ehR
ojbNCQ^MdaDCpa^ja[I[RU]cfBNf<lkNLH4NAFXlTEg:`U38h2^i:G^qCcFKdDV]
aX9U2B^kC_p0To0Q`a1f^FJ0\GJU1A7]ZPIiG>>>E1adZG^gR7ODXjTAQW3T=2hA
^=?74>]8D2N06jV7@i0f6VJQEGDVXF\RhAQUKp;B2@>LgjV5Om;jaX7dpfAA]lFG
CMEBYSG_:Q^h<LQo<Iko6I>mVZ15R9^EQ_[p:Fe[]koYHO5<1W3Mo]gT[^dD8cMO
oFe`0YqMAP?<OobXDDDnG2a4g_iejMIQ\BlPMn8M?X?Emp^V:ZcOiq]D8YfC<VYi
l45ZCn0UdE[?W6PQ^^]>d64<2k_eGcPiOg?g@QcVLqnQ3UekdLejC4d]YacGdnlW
kN0IEYSOYGdNHgBUU5:La\G:`D2h8pSI9k`?MSUV5UUi4ABj@Q1RCDo438Z]VqmU
B`V8:llFN9Q;mU_UAY3e35QR^:O^`G;STiB`N2ON:<h?QReQj`;Iq75D^3QLKS]8
BEWjaakUgO>MS@7Q6Kh^H5=JImE7FEl6dVS91c2G5:5qHmEQHTLQkH[WX12`9ZK7
gn=aj7kYPd@noR4;id6gV]:nb[WW_P5\^UopY2Q^9JMlB3\8e3DcZWPd9ZcHRXmW
_V@PjUYVd9_aYEh^DLXHk8dQfN3q3L>L?1IL0B93NJQP73>3e2b>b6o]fdg@V<7:
:\`EjkX5hmAb]Ykd?bdqieGoFmAgbg_A2JAH`^kGXZf[mC2?[8g8gRVk@b[F>0?g
Qcq^[Tn5K23N]TB[MNjInKeA>lm:lRZ=b1h05J`H00LTnFGX<N>lcc<KN[p?Ph1G
N7d?]lMS2b=f10l47LBFPi9c0ZAc:D4=7g>Y`1_hL3A=oAKioSpF:1ifHGb_g72]
TUbU9Yh_P1QH@[=2UmIlT>^Xd1gSZ[bG`F^MN7GMH8qH9cl8K7n<cIDNG5IY=PgH
ZB[VOIjG2F?PReNK22CY^i\8UZccN3c4\?pf6;a<49DE1jf17_Xq\1?YF0B]c7>Q
=]QoCjQ;0[EFfE:M5n@9kCP[U\9hARWIU^Tc@I2HWR]pnRGHfTlPb9d?:PnGgCMZ
JL>cHI>B4gn8;<Qd@m=mAQFSncfqheQ3[1K8O;A01^T:?LHW;hX=Y??`8GT9;@UG
_Q?BEW2SdIlpMbN4<78>e8DA:0N:3fg_@i5@<Z4;OOjUYj_?nc?:=@dV9bYmWNGZ
j@?Jk]6pNh6HlB>I0O30UoV^_emReNoQ3FUJ2mcIj<K\kSTnlIGkeoG>cNK7;lAK
Xj7pUa]50hJqIXDl<4TpA^eC[B=qMeO61Hi]Z\6;S`_KZFPZ9LidGZ0lcCb_I>HJ
j>3CDa6lVIMmN?M8c<DgBC2CnB;IL4qm58<`b>eNDCN8L<NL>YHGD=Z\GLoiFjij
GcqTHBdmAapg85:T3P26o:OKfR@o7S[38`T6<_5P\9<HFLhRMEc=0I@eAGkQH<pH
o6]eOhSGASFIcW1lHR@0MIm=O@];J?l^IL81_?0GTU;O^\oiS2qX4P<41VAmiUEO
SMABJD8>>iEZ:6LZ]Lo15hVRRMl@TfelIF5JQj3:lqAD>4@3<`NeN7aZ8?QiSG_9
<YDieEfWPAjhi\C<1`RlV\`=G1eE75L<pO4XU_6]kklLD_?EUARkPiAJbEED@2;3
j2O2E[F[PVR:X6nb4C:iEf1^Eq5e:WI<OEXl=1FjGUK7JKa[3LJfhR5?=GIFMa_o
S5\XnNUHhh@Oc0^=dpE86`OHEkIUN@HZ]n1;^cT3Z3M=1g1D@Id^^JMMb8RhLg\5
DlOmLI9Z2qe@d9UmVc?il9ZL9XBAnnVdd3DVgP>Io>\K>8RTL=H@Q:jBF;^FlnjR
_p=8TikCWElE]nl3Mj1oEY7hG<N92P>EQP7dE7Lmn2=><Kn:eV]n`MdScqk\]lRJ
SX<QL02>N>9doL1?k@8M;5N\>I0L[@_J7Nb1;L2m2KPkHZ_R1qhoe[=Q4VZC8g5j
`R`JU]IaP3MI2IKPUKdKgc:<?:Q^MhDZcEl]ZEGX8qkO47<?D6Z6^U]mU3hKY7:L
JHl0jl43o4kNDfiAVD2_aYTXo0a?bDlAPq9F`\FVckLlAC1]3A@;?2UIRd?7FjHK
Sg4I^[^56941UE=V[f^3Gn3\np8]<>KDnKlEe;;?ji9T>MgUhHY5^\_H6E8IR;7^
c0HLPnUQZpgnM6mNLQDc5`D@1>N]:e>ODiROoK6UVW;dOAhP3aNP>pA`EOC2:`Sl
oocT`[V`6i_3\HFVYCZ?n@L4LVXG:LjF_0V36pYC1CCJI73QGZi8PDh=h4Q2gYe<
ICm7[OFC1;K:ZVCi4UZG]J9NHY[SXGIkCq0^Qhg30:G\>O_6IJa[fM]Ze`7D5k`T
=8:g:T__WfXAGgjd2@6?i]>JQW9icpX?i:BQOp^J>nk?6q4ji;[XjqdeG?j^:[ng
K3`I:M4GN9jX<[^6^iBaDBRB3DEP0\Xh=QY\g66FFC6CTL8_9?k[;\dCK2q4]5oK
<;T0i\_>J3mWgOb;bBaFY7:dDM@g[HBD_be6aRMPMm_kA`iWH7ka>>YeEhPcAjCD
>qS3KE65=GMe[c\U6Nen9Z6TUfWEKj@[[>2_OmC:iZUR[b1`h674<PMnY:\XeEJ:
Cl<TXNMmBgpS?K=bkY@_<E^889oZgiS3]QHojZ\EbTa4afS]]9N\:bSP6Slk=\`5
Nn3CH9;CaPqS?jUn\:P5nI6N:H8=IMP;5i3]W7C2URi2bMYe5GkSAY\8<flB?dlG
MV4=<l^6M=JF1eSQ2<[JV_qCm]jJbgn8BO@=?N:2g4V7M46kBCDmIMmcH37AhXmA
3MS_8mcjad2AIb<NhXW7`qb2jDMG?[6Xoa>O`jSVk>_nGOTDa7]_;7Vc\C>[k?<^
TE^d5<`6KjRlW@TKC0Ib;Kc^b9_ZKa>67OH7p0SaG4eY2TQfKFU0mQ`B^`0AmURI
J000CeDEVKdJTZP0<eGW[5^YX=Sjb;Qn7G^R;I3ATgOo:pD4UC>?_nTY[G:`oNnc
>dRf\dl1o:1V5D^cR@UZEcGmk:3d797Td_2;_Wd`<ARjm7a1bNeD@Q`YjBC2pge2
iU_RJGOcD^afKX[BJ7H8OfiG4pc51UG\l7S4m5<=PWnIEgNk[ec1j\T;C[=j=oIi
JjX:ZW`_TDP:ej8KGd:74R\WQ^?fbSiXpg`I@:6JYYJWCWE@<k1Y;^I9jeYgeIhZ
XdR2XCn3ESa8_Xh6`^82@fT2oCJR]@a4TM`N7L85fURDqW`l^6A]@\kfN8XF3<L9
0TY4?a1`?U8QeEW]39>=Z[[mk8X0c=2ZFf1dHX4jXamKlpdjR5`S>hk2KU4e1?]6
?A=\lPkWT3VnO`6ci01;ckCooEPffA_4ING\_ooL5:R3?EXdh3W5Oii?2>R8q<=F
;K5oNY5hm^^K``m=6]0^:1:R^a@<f:o>a]2GcV=7D]][Bnbh:2=qaCB295[IQ52j
o7a`cRffiA>@YEj8=gkNVEGm2=@Xo\ne?Kai4fV\T:lgdYl414q69HTE`b7WgD7I
d>gdRbo>Dc8cbMPa[O9DIA3Ie1\TN`;oUNS4H\<;cU6[O1o\SgXnRO9ikW9MEU;1
XqUOQGMULj;CR\P?<gII]=KBo9^9C_QoRaVHH>f;3N=0Ik1:=;gLYgY1A3RIl58D
ViVTjhU5k:`l9>OZ>L5j1;1Cq1hS]YQA[@dccc^lD8OX_[Rapi;:TU3Eqio\ej:a
qhQ8R?=6p<`KaeBGQ00PI7GIVeBRSaEif\F?6lI=qlL6b9a8TRJgoL1\=^QgNR43
RFDQK7Fhe?]?h5ZFU6YnJ?la^8MA90P5CYACWc6j8AgDoJ]@c`\MYQ:08n1l?4:0
CJ7mlm?II6KBbOS4LkMnSRn:F5K;86T>b61JiX5LTP4[d=?KoaN>qF?IRRDAjBPF
F=nXXYfPhF>F1V1[WZgN@cPSW?Na@RXOk0aimT10>_e:UZ?8ngG<:0b767OSboGU
bNb\W4V=:;^LkjW73a_UTGUT?bTnCXX1R62qn2OELc`cm6nW>EXEGeX8j0XT0laC
`I`5jCMbL1o22HgZG;[TOdg_K3CJmFH1R0A<GgYk2T59MYUX7HEhE>0HiFB9@3\d
ba;dA5nAABg9`1BeAnp:5J1oha]]OO:oLFb5hS?RcIL6>i]4:MVhK0;plP[8S?8n
;73@aKf91DpMmlm07FHRX]RT6RdTeEbbkN=46RP>>F:d6W;K[9UFnfN=Kh_4o9CF
XXGo0=jQ:<kH1qQLW`WcC2?FjLN]o0jl2=gC[e8[gJ996O:^l_VT9]I15\27d8ZN
@aohf:0mQTYKf1iXoW2?m5q59AkcBKTf2lm4<SV0EXEGeX8jHIDllQHY<I9iThQc
HDb;2Gg>oolXn@^7hGXNbo[de6JQahcm1[q]^7DjXG_C32HiKD9E8f4ld4]\B3hC
hM=IJFNYf;S>aBZQYB7QTm`G6g;1HTZMTXF5M:iK@]eX9Fl@Z?Be?85DZZolei7b
>CJAVl7W^dXNYEW<6YAHWB5hK@_?aF9iL@L`8PUZ5\1:G=1q5Ze<^WcOanJ@XDT]
?SmNbonU:gLPH7KC4b;HRjETSUDL@BPg0HRXWY5L9WUY81GRNQZk2>?peIl92aMM
hbTo>>a`X60N>6C<enJFEOb_2;IZ]MH:d<D:QgSDY9aab;X]a65d2B9=[5OkH=IW
m_b^p>IBJAkYThR<P;`1Wia8il0LenL39GeeRhWE6;1fcIR=8[F^:CCXM53m:D;;
X@>J25OFL6hn=ZVbcp8SPGU0gAVBiDM09hkYqF^BaL^Amj]ZJISQ3=68\o6:;D>V
\Z7eFWJOQ:7nc?0Wm@gXAoI0c0FWUdQ4g51SFY;XIB^e3Fm^JfXdiKoRg[`k0h`\
QWFP78io`5ilag=459Fo\H;dXc:=IK?>C5lRO7mTf1\>oEnLq@X:50o2W\LFaGZ5
NCQJ59Q@GBjh0GIUjYbdRn7UOY>ZDgOO0oLaZ1]HVTTZ04kID32COOjYniIZqk]T
d;>d468m;=hIU8IM[J2[O]g^e70RNKH@Z8]=5\CBagic`kQ;j8e`iFaCJ]LDU]\9
ZV2Z6K^Qp0mWN17D4;llVGo[f0A?pH0TmZ<BbJ_^UW@`7KBDF65a`aPPEAg22Qd8
8f?IOFZN73W?RL`<TCHUP\<]0Pk;hD4JERYh4eaIcB4`l3]_;>5U:3>4aAO<_L8W
7?SoLLT86g1@;5Bp_FE\=b=iFa@iU`nRX<hR98RVFTOh66fBLRHcX39_bKak[WVP
_lA0RRjahIlm2Pp4DMH8O^2DPTU0PLm0<qj@_AB?YeY5XC^^>_K?Dh6g3Fg3kfMf
N:=_fV9Slo8FXdMBkelRT7lGF:XVQq>;Z\a`N>UdCmdf6_off6og>2H5Z\d53UGj
HDD]QH:D1b@kQB0NaUVZ<U_SZ<OIReMcS\GS<_8EdUnlo<Xo^p@fH6HGL\GP0dd3
G@Ki4h?O]mS:\\hJbRK`ano=J^ka789RTqk@_3n]=Ib89E?3>]>1@XhT0lONVhB>
Vh1NA2Sb5bo8bN7h31[91GQJ4q9UjdJl=U>A0>0geH0N5?_X]6SN5F3CdS`Sg;LR
p`B89^m\<B4gEGPBN\^N?U??Nnb@98m`QBJ;5>ogdpibY5J;7p^4Fj=i94mV:QS3
k\KcL=`F8QVQjERSe3UI9bWJ3d\eVWn2<d8fIWni\Dp:WJVWE<qbfh4RfDq?_R\W
M@pU\W\B<iQCBdo2=VJ>nA1n?qm9boje`J2HSbXPffc;eLi0g2BhSXDN_5BjPoJo
qd^b@B>hqH=aT?G\KoF0N;BC;7`^cbP[^IcI7Zk0kFNC1\cV:lCboXM76>h2l\kh
JpQA0OfUoq]UkY?X:p7A^hHEfpPB7]e^Q_AQBgiAbHd5[:M\]kNYK<7dcXCGAELF
DUk6?5XIL[[966eNEFeG5BWUnd:LfZK]PG5QTQY7bbR^m<A0cZlk[STDdaDjAUMf
A9m3HQ[Q=p^H=XL7@qhaeZmc8=6VlW\_[O[=L00=d0o<\IHc>oTXi6L:V>Ag]2@X
Nam56OC_C1;n67P9>bfDDq>7[[7b7qhnK]7jXqo[Rf5XWdY_H1Hm;:A`aX3ddWjS
<gc`\AB[n:E1M>OTqC7??M`igQcBVEe4n_]c\T9]baU81GKH0::6pRkN9]>Dh4Z0
K7Z]OaH\5Ymg1`CXETYTD8EA;PlU_C8dLX3GlA8?MIUfZ2@^En^8p\`D90>Hk8EU
1X;>]IkS@LPlE=Zn9HDlRNbMjb6qTaYSl:TpcHSO265JbN0R8`Q9XS@NKcA?kAY=
cPN]N2Q`^cV`7LQeglOjm?8PL2pXFN>^OK1EaWfA>QLS:`^8n[M=67OMBKHJ8SoC
F:eQUg0Se\b[l:\G6p@R:P58LS3o[i8gPP3SgODj^DLg0]Ib[a7@kEoG4dYI0eiS
5oIM1MDYpfX@MU;4q:<dWRJHq_\kKCAFqEa1kB94=J`;:I5o@llC<cWNP:YL7_8I
^01<q\fD>:6fg>^^7TEGI\[]9]C5JGFfI1IE9O5ilISpW\9;=:4qHSTjjB?^2ha4
Z;C5X<DDG]>XLQ;S`7UmSTGjTig?4:Sl9i`EYf2G=mpIc1I>N6K@f@f[a1mj\5@Z
BV[dig^]57U\@^d;AU=94fPG[G_1`3Y_hq8mFgM0>N6eN\B_ISNEKHN3CM<bXN8X
JARj8K@OCoA7]GITA?dG:5DWq\1fObD3phmNm59Vp^AjhlGKp@<O@eA8>ZRPZERf
SVA<fB^XObZQ<MZ6mEWQQ@RamJ3]AJ^[2]lJk^0Gom^aZlldn2@KceNfEJa_?^Dq
H>SH:;>=eDZQ<e`N;TRi@B2;IXojAeA;adL01<[Co;ddZ;RMOVgX:1_IKN95nSil
YCoeS;Yhl7Pp90ddPXeU`N3ebXqfL:14GPTS`BGVTV6j]`@ZWl812Z`aAkDd]L:f
\1qRY0IOVKp36GX>=NX1No];=DKPMkKF4=om^>aCfM1Ni[BjCb`aai]Y@<0FATUa
fI6E]KcX1QnkI7Y2oZB^BPhV3bfVeVBFNK?Ifhf2AE^]eW3m4ofaRq[\9G=F]qY:
ShVU4cN>X9kRL]j85n=7Gha\F4HO]AOWoW2KJgW62<UYEZ=GS56FLEn[_Cj<l?7@
N2W0q0MfH?K4q2PWWh\=pAc=3L2ONb=fADT`Oo8f\NVpXaJahS;q1a:YHi80knJm
K>Y;C_XCZ\:[d@GFfiakFU7:N?8icQ8]30WcB2]ZhfAf8C6LUUanGVA6je^oCi?^
J>o81]9HICNLOS6Ke7dkT36BVU5JWQ0G5:opITVBk;8pTo^RG3Yp;ogLYJYpneZ7
GAbqAXYQ_J42N7[2[Eie]bj76ZY6SMFj52o9dSBb\ag:3Veda^A2fmfeATqi<mAA
Kfqo=<U5XXTbhQ3n:[I^`=8BnIUA:TVF3kWeST5nl?T0Eo=OCWLFlOYRXmRcNA^L
P]?pAHddDm9qEVDl7Yap_B==mVRq=M=omIlIMa61ilND`U?aCFL<g\@O02fS^=>6
81D<nnYT]NTcI1nJ0H;2SeYmK^RM2NMYg\;hL]`La5MaUVl7LZd9;]Ea<>oMGjg<
WiDlcnAHqKE[HKVfL]072HCb:\<$
`endprotected
endmodule // module vusb_hs_portctrl_rm

