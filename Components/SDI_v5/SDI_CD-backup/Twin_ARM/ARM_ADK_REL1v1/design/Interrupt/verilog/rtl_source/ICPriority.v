// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name             : ICPriority.v,v
// File Revision         : 1.3
//
// Release Information   : ADK_REL1v1
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block implements the Interrupt Priority Logic.
//
// --=========================================================================--

// -----------------------------------------------------------------------------
//
//                             ICPriority
//                            ===========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module implements the priority scheme between internal and external
// (daisy-chain) interrupts. The internal interrupts have priority over external
// and a read from the ICVectAddr register with a pending internal interrupts
// will cause the NonVectIrqServ flag to be set, masking that and any external
// interrupts.
// A write to the ICVectAddr register will cause NonVectIrqServ flag to be
// cleared indicating that this Interrupt has been serviced.
//
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module ICPriority `protected
mUneLSQd5DT^<0BR=IWa<99oPW:e=Vje3F[DKPq83[SD4Y0K0c\4iE^b@=XkJp:8
TEaIQG?YP]DZRHencZTVNmaIng\^R5FDmVoY4eDQOkOQSgDafBOHUFGUA^5X<4HB
:_pg>QeKQ5=5WlBL__X8h;FSKLAkXDCoQI=;faCX@CIh:hJU2USgJXehYXCo73XP
2W1cL^4OJRO;_90jVk2jR3p8GNR2FJ3G3^?POP1]:OdO`Oc>g4jZST34OLNDl9Rn
>fk\H4?Q9F3<G\ZVHbhTkV]h:hdHV\mSVBDEY\5>QZK:WqTHiR2GEh2>WhLP>m;L
M=_3AYkM7oc9qN5MdbhXHj6HA]7lV;YeLbAn8f_YSB?2R3[5PI_3dc_6AcVZU_?V
;c?VWW?h0Bhp:R?Y>X_nJPLLdkUUpL7UFa6cjGBMVehS>BTZUq^A55?mk3\obSe<
fF^X^9\d7]F4qKNh00FeCiL[89BZB<]_E_DfpgM5T`G2L:]j^:L`cUVSX95EBSF_
pI4\;m4N4T1^\6I9H[1RW?C_bCaVmTGb\I`6]A7Zm:UQplY[`m3Nc^WN;_PLo1mS
HDc]LZQQO3G@AV\qflJDH9^VHe@`ZoL5cef:c2p7MZo`K@Sk_4NQ[G>I0;cD_@lQ
fLOG[R96;Gm@?EX5ApV3\3dgOlIPI`\\jGhUc1pdMi_DFFZAc07STH?QQnqG;9fo
Q71_7fRVB8;;_KL<k=i]7W26TZ58DOU]DEo_SCU<2pB]Rm15B[fNiDdVYGphMN^;
ENlnXH6]R\[7JQ^p_dWMMo\OGYlhc>T@H][MAO\5U[@<>M=>`9npPQ=64;U=^kd^
HW_n6R2K9>L1DKp3Y0CNkBdCSdU@g_@GRj5gkeq^3XYLl2oJgW<Q`HIEoJG8[gQ>
QopU]bIQE>h7DXACUb:J23:i15I`nol4_m^NO2h`IY7YGfp7>AI:eRNlN_^ZK_Q0
`qHDLaXn14WT<A_9@3PSed47qWN1VLWNPgRFkNo\[bX5fAh5cZ=gk`6Q<4o4`]47
=FmqCTE2@gTBWcI0Jm]9dA?[pPBCbVd0<36`eOOe4]5V;UeGS2^pLO:T1dagFTAh
J1lEnb8q6HLTi9iWV3>;50JloJ1=G3A]7IiPPk8mn2Gg7?21GM\?:XpJa^cM36hK
S5l9CUDf8^BFoORQMOmCkpYcnBU8b__iC@0\@FeVNM2hEKcf?3fFfcAPp@JKB=am
cVI1=VN3Sc<1Xb`g@heZBo4:GqK6F]mQ61ICTeL\7F:U7qboI^EP=b23gTN7Hbm?
DHWmD2^o]nnX\j^\ZYj;`qh9ZO=gXPRl<BeD9]C6EjMaUMHjKDbGkZ:mJHk562W:
hLaTdUHLn^ElUlWm?8Ld0Xk8CpPj24b[VeGjC_@1n[OQ8JfiKkU^C0;<]nDW5[`N
NiW;nh5g4DZRg9<GpYZ<2GCc7@e0TS7BhkTP>J`G2M3RG\h>Xm=O]ehh3Jh>A=Vi
^?b_Y?HWP]<q4NMU7>Fe07]oo`DgODed_3oABo^4qNVDoh?oU?m[bZ`Tf72^e1Q^
SmZ6[Hj9InD34Pgd=q;Ni@V`M<NNMcBmNNe<5XJkKSBQJZ=m=aNoq@656<bgN6V@
@WEn1UQZn2jSq1dXN8b1p[aoZ8Y`=N\4g0e\gLP\DjXnmLUQToWD3bKZM2`Bn>01
hUj1IoaUnq@bPGPL0J[nOLoGHGTNiTJc[ad9R>c7c7Ogk9N=G3P:Yph2hPX7LpMi
0kVnESeGLJ`1IKaDN5^^9P\_Wm@YHhhiXT1IJUWfhL8BpTh3QG72p0]QlNi3ph0W
4T_a@_<Ej=_XZYBekOd^XBff0c8S`5<m@YEoVG_SIYJkp5mLk2A2:khWR^^PFD;_
;8=kEBQ]X_3TBJAFi:o81g;8a[ASaH:;pBdlH4DGqWG:0U[hpl^A_G7gWR5DKmTb
_>T;SM2<lDb:1J]G?Oi2956=MHJ0EL_@h87`YF=RI2Hm5mWM;<b;JRdJDp1GTQG:
?XEjRMR@bj9Z6\I7Qd4hNV:GPWDl\jEmKXSf\KD`\ODYNmgIDKS;<Bgl80U34WK^
;kkmdcB@YQ5Hk56DQW73`H]Dd>5PqHOlL4eh5Lj`E7QaLbcbqCDO66XP8\GH^?4[
n2XmdoGF9?8QBLVf]9ffIqXkMUB97<HV4Rm4^5cQ:8KEZGI[=2_]_6^\MgWYLQj5
:1\N`78_e^Z1A_AL9mm6T5VEk`GODko[kfQ=0;0cCENN3>W2C[2eL3abp6D:@BC5
5T@ba8QX59[dk><WeH4^6OmL<IhajRK1qYV`PL2pnlWaF2qK`hmF254Z7dAh29^f
]PIN?QXqJ4WT=Sbhd9U[Qj2`HCU?W0\Hmi8dV]63]8QdoHn@Q6TM3CN^P>m0YPbj
`nqN;m<EX5N;QZeg1k?cIdm2[]Z1VWRQ1Nh]2U3Y`NGK@7L5gh1WA0i`gR4?dn6d
lj>_02qH:bJ80pa1cl^@qJ1Coa2qj`Hf\nhq2RhE\MC[l2h2UZGp9hO0F]mqUXlR
c`^o?;dTe6S3_D0:oMMHh\hpWHKK73IaOjj94S:Rh_8bKM_Wi;gb9gn989kFZ;Bi
nX3AqF<ZAVDJq<Ek9aPeWLP[<KMXFG;d6RC^G4`7SX5;eUD>^WN=0N7m;1eBT3eL
ZVZGqfhMCVmDqjfV3k9`qkH@I1UnB<KTdYB8BCX_\<d^j=S4;6@TmM>AjflR>pkI
3A;W>cIGc5]4EQMbMi0UY:TV=nVaoU=TUFqEPJ9ak4WO<A9NkJh6[aRIY^CnCLSj
dlke?Ok3:qRZHkYGZ7[GbDFJ6`DP=\NK2qln4HJ]^>Xml[ga<@^1GP1`h8SW@lke
:VESO0PP1\pEf6_[E`p4MMe\mi6a1MmUUT2<hGl2\43Wl560l6\cLc4<A]JMZ8=X
cKL8hi>6D[qnQe[U=6qA`@NfK;`HN@Zo3dch:cTh`YE8YiLcPQF<8poaBD$
`endprotected endmodule
