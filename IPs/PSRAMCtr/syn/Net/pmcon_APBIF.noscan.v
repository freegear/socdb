
module pmcon_APBIF ( M_PCLK, PRESETn, M_PSEL, M_PENABLE, M_PREADY, M_PWSTRB, 
        M_PWRITE, M_PADDR, M_PWDATA, M_PRDATA, R_PCLK, R_PSEL, R_PENABLE, 
        R_PWRITE, R_PADDR, R_PWDATA, R_PRDATA, CSb, ZZb, OEb, WEb, UBb, LBb, 
        ADDR, DATAIN, nDATAEN, DATAOUT );
  input [3:0] M_PWSTRB;
  input [21:0] M_PADDR;
  input [31:0] M_PWDATA;
  output [31:0] M_PRDATA;
  input [5:0] R_PADDR;
  input [31:0] R_PWDATA;
  output [31:0] R_PRDATA;
  output [21:0] ADDR;
  input [15:0] DATAIN;
  output [15:0] DATAOUT;
  input M_PCLK, PRESETn, M_PSEL, M_PENABLE, M_PWRITE, R_PCLK, R_PSEL,
         R_PENABLE, R_PWRITE;
  output M_PREADY, CSb, ZZb, OEb, WEb, UBb, LBb, nDATAEN;
  wire   Enable, PowerupSet, PowerupClr, NegCatch, BurstRMode, DataRWAvail,
         Read, Write;
  wire   [2:0] PageSize;
  wire   [31:0] PSRAMTCON;
  wire   [10:0] PSRAMTOUT;
  wire   [31:0] PSRAMRDATA;
  wire   SYNOPSYS_UNCONNECTED__0;
  assign ADDR[21] = 1'b0;

  pmcon_REGIF pmcon_REGIF ( .PCLK(R_PCLK), .PRESETn(PRESETn), .PSEL(R_PSEL), 
        .PENABLE(R_PENABLE), .PWRITE(R_PWRITE), .PADDR(R_PADDR), .PWDATA(
        R_PWDATA), .PRDATA(R_PRDATA), .Enable(Enable), .PowerupSet(PowerupSet), 
        .PowerupClr(PowerupClr), .PageSize(PageSize), .BurstRMode(BurstRMode), 
        .NegCatch(NegCatch), .PSRAMTCON(PSRAMTCON), .PSRAMTOUT(PSRAMTOUT) );
  pmcon_MEMIF_ADDRESSWIDTH22 pmcon_MEMIF ( .PCLK(M_PCLK), .PRESETn(PRESETn), 
        .PSEL(M_PSEL), .PENABLE(M_PENABLE), .PREADY(M_PREADY), .PWRITE(
        M_PWRITE), .PADDR(M_PADDR), .PWDATA(M_PWDATA), .PRDATA(M_PRDATA), 
        .DataRWAvail(DataRWAvail), .Read(Read), .Write(Write), .PSRAMRDATA(
        PSRAMRDATA) );
  pmcon_STM_ADDRESSWIDTH22 pmcon_STM ( .PCLK(M_PCLK), .PRESETn(PRESETn), 
        .PSEL(M_PSEL), .PENABLE(M_PENABLE), .PWDATA(M_PWDATA), .PWSTRB(
        M_PWSTRB), .PADDR(M_PADDR), .Read(Read), .Write(Write), .PSRAMRDATA(
        PSRAMRDATA), .Enable(Enable), .PowerupSet(PowerupSet), .PowerupClr(
        PowerupClr), .PageSize(PageSize), .BurstRMode(BurstRMode), .NegCatch(
        NegCatch), .PSRAMTCON(PSRAMTCON), .PSRAMTOUT(PSRAMTOUT), .DataRWAvail(
        DataRWAvail), .CSb(CSb), .ZZb(ZZb), .OEb(OEb), .WEb(WEb), .UBb(UBb), 
        .LBb(LBb), .ADDR({SYNOPSYS_UNCONNECTED__0, ADDR[20:0]}), .DATAIN(
        DATAIN), .nDATAEN(nDATAEN), .DATAOUT(DATAOUT) );
endmodule


module pmcon_STM_ADDRESSWIDTH22 ( PCLK, PRESETn, PSEL, PENABLE, PWDATA, PWSTRB, 
        PADDR, Read, Write, PSRAMRDATA, Enable, PowerupSet, PowerupClr, 
        PageSize, BurstRMode, NegCatch, PSRAMTCON, PSRAMTOUT, DataRWAvail, CSb, 
        ZZb, OEb, WEb, UBb, LBb, ADDR, DATAIN, nDATAEN, DATAOUT );
  input [31:0] PWDATA;
  input [3:0] PWSTRB;
  input [21:0] PADDR;
  output [31:0] PSRAMRDATA;
  input [2:0] PageSize;
  input [31:0] PSRAMTCON;
  input [10:0] PSRAMTOUT;
  output [21:0] ADDR;
  input [15:0] DATAIN;
  output [15:0] DATAOUT;
  input PCLK, PRESETn, PSEL, PENABLE, Read, Write, Enable, PowerupSet,
         PowerupClr, BurstRMode, NegCatch;
  output DataRWAvail, CSb, ZZb, OEb, WEb, UBb, LBb, nDATAEN;
  wire   RW_cnt, cycle_cntEn, Hold, n3849, PreviousAdr_21_, PreviousAdr_20_,
         PreviousAdr_19_, PreviousAdr_18_, PreviousAdr_17_, PreviousAdr_16_,
         PreviousAdr_15_, PreviousAdr_14_, PreviousAdr_13_, PreviousAdr_12_,
         PreviousAdr_11_, PreviousAdr_10_, PreviousAdr_9_, PreviousAdr_8_,
         PreviousAdr_7_, PreviousAdr_6_, PreviousAdr_5_, PreviousAdr_4_,
         PreviousAdr_3_, PreviousAdr_2_, PreviousAdr_1_, nextrw_state_1_,
         nextrw_state_0_, ToutCnt714_10_, ToutCnt714_9_, ToutCnt714_8_,
         ToutCnt714_7_, ToutCnt714_6_, ToutCnt714_5_, ToutCnt714_4_,
         ToutCnt714_3_, ToutCnt714_2_, ToutCnt714_1_, cycle_cnt_3_,
         cycle_cnt_2_, cycle_cnt_1_, cycle_cnt_0_, hold_cnt_3_, hold_cnt_2_,
         hold_cnt_1_, hold_cnt_0_, hold_cnt1116_3_, hold_cnt1116_2_,
         hold_cnt1116_1_, hold_cnt1116_0_, NextADR1442_19_, NextADR1442_18_,
         NextADR1442_17_, NextADR1442_16_, NextADR1442_15_, NextADR1442_14_,
         NextADR1442_13_, NextADR1442_12_, NextADR1442_11_, NextADR1442_10_,
         NextADR1442_9_, NextADR1442_8_, NextADR1442_7_, NextADR1442_6_,
         NextADR1442_5_, NextADR1442_4_, NextADR1442_3_, NextADR1442_2_,
         NextADR1442_1_, n2460, n2461, n2462, n2463, n2464, n2465, n2466,
         n2467, n2468, n2469, n2470, n2471, n2472, n2473, n2474, n2475, n2476,
         n2477, n2478, n2479, n2480, n2481, n2482, n2483, n2486, n2487, n2488,
         n2489, n2490, n2491, n2492, n2493, n2494, n2495, n2496, n2497, n2499,
         n2500, n2501, n2502, n2503, n2504, n2505, n2506, n2507, n2508, n2509,
         n2510, n2511, n2512, n2513, n2514, n2515, n2516, n2517, n2518, n2519,
         n2520, n2521, n2522, n2523, n2524, n2525, n2526, n2527, n2528, n2529,
         n2530, n2531, n2532, n2533, n2534, n2535, n2536, n2537, n2538, n2539,
         n2540, n2541, n2542, n2543, n2544, n2545, n2546, n2547, n2548, n2549,
         n2550, n2551, n2552, n2553, n2554, n2555, n2556, n2557, n2558, n2559,
         n2560, n2561, n2562, n2563, n2564, n2565, n2566, n2567, n2568, n2569,
         n2570, n2571, n2572, n2573, n2574, n2575, n2576, n2577, n2578, n2579,
         n2580, n2581, n2582, n2583, n2584, n2585, n2586, n2587, n2588, n2589,
         n2590, n2591, n2592, n2593, n2594, n2595, n2596, n2597, n2598, n2599,
         n2600, n2601, n2602, n2603, n2604, n2605, n2606, n2607, n2608, n2609,
         n2610, n2611, n2612, n2613, n2614, n2615, n2616, n2617, n2618, n2619,
         n2620, n2621, n2622, n2623, n2624, n2625, n2626, n2627, n2628, n2629,
         n2630, n2631, n2632, n3108, carry, carry0, carry1, carry2, carry3,
         carry4, carry5, carry6, carry7, carry_19_, carry_18_, carry_17_,
         carry_16_, carry_15_, carry_14_, carry_13_, carry_12_, carry_11_,
         carry_10_, carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_,
         carry_3_, carry_2_, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12,
         n13, n14, n15, n16, n17, n18, n19, n3131, n3132, n3134, n3141, n3149,
         n3150, n3156, n3177, n3182, n3183, n3184, n3185, n3186, n3187, n3189,
         n3190, n3195, n3196, n3197, n3206, n3214, n3232, n3238, n3239, n3240,
         n3241, n3242, n3243, n3251, n3252, n3295, n3297, n3299, n3330, n3331,
         n3332, n3333, n3334, n3335, n3336, n3338, n3339, n3340, n3341, n3342,
         n3343, n3344, n3345, n3346, n3347, n3348, n3349, n3350, n3449, n3450,
         n3451, n3452, n3453, n3455, n3457, n3458, n3459, n3460, n3462, n3463,
         n3464, n3465, n3466, n3467, n3468, n3469, n3470, n3471, n3472, n3473,
         n3474, n3475, n3476, n3477, n3478, n3479, n3480, n3481, n3482, n3483,
         n3484, n3485, n3486, n3487, n3488, n3489, n3490, n3491, n3492, n3493,
         n3494, n3495, n3496, n3497, n3498, n3499, n3500, n3501, n3502, n3503,
         n3504, n3505, n3506, n3507, n3508, n3509, n3510, n3511, n3512, n3513,
         n3514, n3515, n3516, n3517, n3518, n3519, n3520, n3521, n3522, n3523,
         n3524, n3525, n3526, n3527, n3528, n3529, n3530, n3531, n3532, n3533,
         n3534, n3535, n3536, n3537, n3538, n3539, n3540, n3541, n3542, n3543,
         n3544, n3545, n3546, n3547, n3548, n3549, n3550, n3551, n3552, n3553,
         n3554, n3555, n3556, n3557, n3558, n3559, n3560, n3561, n3562, n3563,
         n3564, n3565, n3566, n3567, n3568, n3569, n3570, n3571, n3572, n3573,
         n3574, n3575, n3576, n3577, n3578, n3579, n3580, n3581, n3582, n3583,
         n3584, n3585, n3586, n3587, n3588, n3589, n3590, n3591, n3592, n3593,
         n3594, n3595, n3596, n3597, n3598, n3599, n3600, n3601, n3602, n3603,
         n3604, n3605, n3606, n3607, n3608, n3609, n3610, n3611, n3612, n3613,
         n3614, n3615, n3616, n3617, n3618, n3619, n3620, n3621, n3622, n3623,
         n3624, n3625, n3626, n3627, n3628, n3629, n3630, n3631, n3632, n3633,
         n3634, n3635, n3636, n3637, n3638, n3639, n3640, n3641, n3642, n3643,
         n3644, n3645, n3646, n3647, n3648, n3649, n3650, n3651, n3652, n3653,
         n3654, n3655, n3656, n3657, n3658, n3659, n3660, n3661, n3662, n3663,
         n3664, n3665, n3666, n3667, n3668, n3669, n3670, n3671, n3672, n3673,
         n3674, n3675, n3676, n3677, n3678, n3679, n3680, n3681, n3682, n3683,
         n3684, n3685, n3686, n3687, n3688, n3689, n3690, n3691, n3692, n3693,
         n3694, n3695, n3696, n3697, n3698, n3699, n3700, n3701, n3702, n3703,
         n3704, n3705, n3706, n3707, n3708, n3709, n3710, n3711, n3712, n3713,
         n3714, n3715, n3716, n3717, n3718, n3719, n3720, n3721, n3722, n3723,
         n3724, n3725, n3726, n3727, n3728, n3729, n3730, n3731, n3732, n3733,
         n3734, n3735, n3736, n3737, n3738, n3739, n3740, n3741, n3742, n3743,
         n3744, n3745, n3746, n3747, n3748, n3749, n3750, n3751, n3752, n3753,
         n3754, n3755, n3756, n3757, n3758, n3759, n3760, n3761, n3762, n3763,
         n3764, n3765, n3766, n3767, n3768, n3769, n3770, n3771, n3772, n3773,
         n3774, n3775, n3776, n3777, n3778, n3779, n3780, n3781, n3782, n3783,
         n3784, n3785, n3786, n3787, n3788, n3789, n3790, n3791, n3792, n3793,
         n3794, n3795, n3796, n3797, n3798, n3799, n3800, n3801, n3802, n3803,
         n3804, n3805, n3806, n3807, n3808, n3809, n3810, n3811, n3812, n3813,
         n3814, n3815, n3816, n3817, n3818, n3819, n3820, n3821, n3822, n3823,
         n3824, n3825, n3826, n3827, n3828, n3829, n3830, n3831, n3832, n3833,
         n3834, n3835, n3836, n3837, n3838, n3839, n3840, n3841, n3842, n3843,
         n3844, n3845, n3846, n3847, net377, net351, net350, net340, net336,
         net329;
  wire   [1:0] main_state;
  wire   [4:0] rw_state;
  wire   [31:0] PSRAMWDATA;
  wire   [10:0] ToutCnt;
  wire   [1:0] nextmain_state;
  assign ADDR[21] = 1'b0;

  AHHCONX2 U1_1_1 ( .A(ADDR[1]), .CI(ADDR[0]), .S(NextADR1442_1_), .CON(n19)
         );
  AHHCONX2 U1_1_2 ( .A(ADDR[2]), .CI(carry_2_), .S(NextADR1442_2_), .CON(n18)
         );
  AHHCONX2 U1_1_3 ( .A(ADDR[3]), .CI(carry_3_), .S(NextADR1442_3_), .CON(n17)
         );
  AHHCONX2 U1_1_4 ( .A(ADDR[4]), .CI(carry_4_), .S(NextADR1442_4_), .CON(n16)
         );
  AHHCONX2 U1_1_5 ( .A(ADDR[5]), .CI(carry_5_), .S(NextADR1442_5_), .CON(n15)
         );
  AHHCONX2 U1_1_6 ( .A(ADDR[6]), .CI(carry_6_), .S(NextADR1442_6_), .CON(n14)
         );
  AHHCONX2 U1_1_7 ( .A(ADDR[7]), .CI(carry_7_), .S(NextADR1442_7_), .CON(n13)
         );
  AHHCONX2 U1_1_8 ( .A(ADDR[8]), .CI(carry_8_), .S(NextADR1442_8_), .CON(n12)
         );
  AHHCONX2 U1_1_9 ( .A(ADDR[9]), .CI(carry_9_), .S(NextADR1442_9_), .CON(n11)
         );
  AHHCONX2 U1_1_10 ( .A(ADDR[10]), .CI(carry_10_), .S(NextADR1442_10_), .CON(
        n10) );
  AHHCONX2 U1_1_11 ( .A(ADDR[11]), .CI(carry_11_), .S(NextADR1442_11_), .CON(
        n9) );
  AHHCONX2 U1_1_12 ( .A(ADDR[12]), .CI(carry_12_), .S(NextADR1442_12_), .CON(
        n8) );
  AHHCONX2 U1_1_13 ( .A(ADDR[13]), .CI(carry_13_), .S(NextADR1442_13_), .CON(
        n7) );
  AHHCONX2 U1_1_14 ( .A(ADDR[14]), .CI(carry_14_), .S(NextADR1442_14_), .CON(
        n6) );
  AHHCONX2 U1_1_15 ( .A(ADDR[15]), .CI(carry_15_), .S(NextADR1442_15_), .CON(
        n5) );
  AHHCONX2 U1_1_16 ( .A(ADDR[16]), .CI(carry_16_), .S(NextADR1442_16_), .CON(
        n4) );
  AHHCONX2 U1_1_17 ( .A(ADDR[17]), .CI(carry_17_), .S(NextADR1442_17_), .CON(
        n3) );
  AHHCONX2 U1_1_18 ( .A(ADDR[18]), .CI(carry_18_), .S(NextADR1442_18_), .CON(
        n2) );
  AHHCONX2 U1_1_19 ( .A(ADDR[19]), .CI(carry_19_), .S(NextADR1442_19_), .CON(
        n1) );
  INVX3 U2312 ( .A(PADDR[3]), .Y(n3681) );
  INVX3 U2313 ( .A(n3585), .Y(n3728) );
  INVX3 U2314 ( .A(PADDR[10]), .Y(n3695) );
  BUFX3 U2315 ( .A(n3650), .Y(n3839) );
  NAND2X1 U2316 ( .A(n3646), .B(n3647), .Y(n3591) );
  NAND4X1 U2317 ( .A(n3581), .B(n3845), .C(n3582), .D(n3605), .Y(n3553) );
  INVX3 U2318 ( .A(n3641), .Y(n3587) );
  INVX1 U2319 ( .A(n3637), .Y(n3614) );
  OAI21X1 U2320 ( .A0(n3206), .A1(n3572), .B0(n3794), .Y(n3657) );
  NAND2BX1 U2321 ( .AN(n3544), .B(n3539), .Y(n3794) );
  NAND2X1 U2322 ( .A(n3481), .B(PADDR[1]), .Y(n3506) );
  NAND2X1 U2323 ( .A(n3766), .B(BurstRMode), .Y(n3762) );
  INVX1 U2324 ( .A(n3657), .Y(n3640) );
  INVX1 U2325 ( .A(PADDR[8]), .Y(n3691) );
  NAND2X1 U2326 ( .A(n3663), .B(n3664), .Y(n3645) );
  NOR3X1 U2327 ( .A(n3657), .B(n3639), .C(n3839), .Y(n3656) );
  AND2X2 U2328 ( .A(n3486), .B(n3482), .Y(n3457) );
  AND2X2 U2329 ( .A(n3614), .B(n3611), .Y(n3459) );
  BUFX4 U2330 ( .A(n3679), .Y(n3842) );
  INVX2 U2331 ( .A(n3608), .Y(n3519) );
  DFFSX2 cur_WE_reg ( .D(n2628), .CK(PCLK), .SN(PRESETn), .Q(WEb), .QN(n3843)
         );
  NAND2X1 U2332 ( .A(PreviousAdr_1_), .B(n3504), .Y(n3505) );
  NAND2X1 U2333 ( .A(n3505), .B(n3506), .Y(n3758) );
  INVX1 U2334 ( .A(PADDR[1]), .Y(n3504) );
  INVX1 U2335 ( .A(n3514), .Y(n3515) );
  NOR2X1 U2336 ( .A(n3751), .B(n3758), .Y(n3514) );
  NOR3X1 U2337 ( .A(n3579), .B(n3576), .C(n3580), .Y(n3578) );
  NOR2X1 U2338 ( .A(nextmain_state[0]), .B(n3575), .Y(n3580) );
  NOR3X1 U2339 ( .A(n3774), .B(n3775), .C(n3776), .Y(n3759) );
  NAND2X2 U2340 ( .A(n3759), .B(n3760), .Y(n3641) );
  NOR2X1 U2341 ( .A(n3517), .B(n3620), .Y(n3618) );
  DFFRX1 ADR_reg_2_ ( .D(n2599), .CK(PCLK), .RN(PRESETn), .Q(ADDR[2]) );
  DFFRX1 ADR_reg_7_ ( .D(n2594), .CK(PCLK), .RN(PRESETn), .Q(ADDR[7]) );
  DFFRX1 ADR_reg_9_ ( .D(n2592), .CK(PCLK), .RN(PRESETn), .Q(ADDR[9]) );
  NOR2X1 U2342 ( .A(n3515), .B(n3528), .Y(n3753) );
  NAND2X1 U2343 ( .A(n3690), .B(n3507), .Y(n3508) );
  NAND2X1 U2344 ( .A(n3691), .B(n3842), .Y(n3509) );
  NAND2X1 U2345 ( .A(n3508), .B(n3509), .Y(n3510) );
  INVX1 U2346 ( .A(n3842), .Y(n3507) );
  INVX1 U2347 ( .A(n3510), .Y(n2594) );
  NAND2X1 U2348 ( .A(n3694), .B(n3507), .Y(n3511) );
  NAND2X1 U2349 ( .A(n3695), .B(n3842), .Y(n3512) );
  NAND2X1 U2350 ( .A(n3511), .B(n3512), .Y(n3513) );
  INVX1 U2351 ( .A(n3513), .Y(n2592) );
  INVX1 U2352 ( .A(Read), .Y(n3544) );
  DFFRX1 ADR_reg_1_ ( .D(n2600), .CK(PCLK), .RN(PRESETn), .Q(ADDR[1]) );
  DFFRX1 ADR_reg_20_ ( .D(n2581), .CK(PCLK), .RN(PRESETn), .Q(ADDR[20]) );
  NAND3BX1 U2353 ( .AN(n3767), .B(n3768), .C(n3769), .Y(n3761) );
  NAND3BX1 U2354 ( .AN(n3783), .B(n3784), .C(n3785), .Y(n3774) );
  NOR3X2 U2355 ( .A(n3728), .B(rw_state[2]), .C(rw_state[0]), .Y(n3727) );
  NAND2X1 U2356 ( .A(n3609), .B(n3610), .Y(n3582) );
  NAND4BX1 U2357 ( .AN(Write), .B(n3543), .C(n3544), .D(PENABLE), .Y(n3542) );
  NAND2X1 U2358 ( .A(n3655), .B(n3656), .Y(n3654) );
  OR2X4 U2359 ( .A(nextrw_state_0_), .B(n3844), .Y(n3523) );
  OR3X6 U2360 ( .A(n3522), .B(n3845), .C(n3523), .Y(n3575) );
  DFFRX1 ADR_reg_0_ ( .D(n2601), .CK(PCLK), .RN(PRESETn), .Q(ADDR[0]), .QN(
        n3538) );
  DFFRX1 cycle_cnt_reg_2_ ( .D(n3525), .CK(PCLK), .RN(PRESETn), .Q(
        cycle_cnt_2_), .QN(n3478) );
  NAND3X2 U2361 ( .A(rw_state[3]), .B(n3519), .C(n3729), .Y(n3653) );
  NAND2X1 U2362 ( .A(n3634), .B(n3635), .Y(n3108) );
  NAND2X2 U2363 ( .A(n3519), .B(n3837), .Y(n3585) );
  INVX1 U2364 ( .A(PADDR[12]), .Y(n3699) );
  INVX1 U2365 ( .A(PADDR[9]), .Y(n3693) );
  INVX1 U2366 ( .A(n3582), .Y(nextrw_state_0_) );
  NOR2X1 U2367 ( .A(n3619), .B(n3621), .Y(n3516) );
  INVX1 U2368 ( .A(n3516), .Y(n3517) );
  NAND2X2 U2369 ( .A(n3653), .B(n3654), .Y(n3845) );
  OR2X1 U2370 ( .A(Write), .B(Read), .Y(n3518) );
  NAND3X2 U2371 ( .A(n3650), .B(n3611), .C(n3640), .Y(n3608) );
  NOR2BX1 U2372 ( .AN(n3589), .B(n3629), .Y(n3620) );
  NOR3BX1 U2373 ( .AN(n3839), .B(Write), .C(n3665), .Y(n3662) );
  NAND4X2 U2374 ( .A(n3725), .B(n3726), .C(n3653), .D(n3727), .Y(n3630) );
  NAND3X2 U2375 ( .A(n3813), .B(n3814), .C(n3815), .Y(n3650) );
  XNOR2X1 U2376 ( .A(ADDR[20]), .B(n1), .Y(n3717) );
  NOR3X2 U2377 ( .A(n3761), .B(n3762), .C(n3763), .Y(n3760) );
  INVX1 U2378 ( .A(n3838), .Y(n3837) );
  INVX1 U2379 ( .A(RW_cnt), .Y(n3572) );
  INVX1 U2380 ( .A(Write), .Y(n3520) );
  INVX4 U2381 ( .A(Write), .Y(n3232) );
  BUFX2 U2382 ( .A(n3679), .Y(n3841) );
  BUFX2 U2383 ( .A(n3679), .Y(n3840) );
  NOR2BX1 U2384 ( .AN(n3573), .B(n3575), .Y(n3521) );
  INVX1 U2385 ( .A(n3669), .Y(n3718) );
  NAND2X1 U2386 ( .A(n3614), .B(n3658), .Y(n3655) );
  XOR2X1 U2387 ( .A(n3583), .B(nextrw_state_1_), .Y(n3522) );
  NAND2BX1 U2388 ( .AN(n3553), .B(n3573), .Y(n3560) );
  INVX1 U2389 ( .A(n3732), .Y(n3734) );
  INVX1 U2390 ( .A(n3645), .Y(n3629) );
  INVX1 U2391 ( .A(n3673), .Y(n3679) );
  INVX1 U2392 ( .A(n3591), .Y(n3616) );
  INVX1 U2393 ( .A(n3612), .Y(n3606) );
  NAND2X1 U2394 ( .A(n3839), .B(n3520), .Y(n3649) );
  INVX1 U2395 ( .A(n3108), .Y(n3583) );
  INVX1 U2396 ( .A(n3149), .Y(n3150) );
  INVX1 U2397 ( .A(n3141), .Y(n3559) );
  INVX1 U2398 ( .A(n3251), .Y(n3557) );
  DFFRX1 rw_state_reg_4_ ( .D(n3844), .CK(PCLK), .RN(PRESETn), .Q(rw_state[4]), 
        .QN(n3486) );
  NAND2X1 U2399 ( .A(n3795), .B(n3796), .Y(n3539) );
  INVX1 U2400 ( .A(n3252), .Y(n3206) );
  INVX1 U2401 ( .A(n3134), .Y(n3746) );
  INVX1 U2402 ( .A(n3795), .Y(n3340) );
  INVX1 U2403 ( .A(n3796), .Y(n3342) );
  INVX1 U2404 ( .A(n3724), .Y(n3633) );
  INVX1 U2405 ( .A(n3829), .Y(n3827) );
  INVX1 U2406 ( .A(n3829), .Y(n3828) );
  INVX1 U2407 ( .A(n3834), .Y(n3833) );
  INVX1 U2408 ( .A(n3834), .Y(n3832) );
  INVX1 U2409 ( .A(n3834), .Y(n3831) );
  INVX1 U2410 ( .A(n3834), .Y(n3830) );
  NAND2X1 U2411 ( .A(n3724), .B(n3206), .Y(n3669) );
  INVX1 U2412 ( .A(n3338), .Y(n3339) );
  INVX1 U2413 ( .A(n3592), .Y(n3573) );
  INVX1 U2414 ( .A(n3156), .Y(n3576) );
  INVX1 U2415 ( .A(n3214), .Y(n3132) );
  NAND2X1 U2416 ( .A(n3614), .B(n3641), .Y(n3663) );
  AOI21X1 U2417 ( .A0(n3606), .A1(rw_state[2]), .B0(n3607), .Y(n3605) );
  NOR2X1 U2418 ( .A(n3479), .B(n3608), .Y(n3607) );
  NAND2X1 U2419 ( .A(n3606), .B(n3741), .Y(n3732) );
  OAI2BB2X1 U2420 ( .A0N(n3573), .A1N(n3591), .B0(n3553), .B1(n3590), .Y(n3579) );
  NAND4X1 U2421 ( .A(n3593), .B(n3594), .C(n3177), .D(n3595), .Y(n3590) );
  XOR2X1 U2422 ( .A(n3187), .B(n3597), .Y(n3594) );
  XOR2X1 U2423 ( .A(n3189), .B(n3190), .Y(n3177) );
  MXI2X1 U2424 ( .S0(n3618), .B(n3480), .A(n3617), .Y(n2626) );
  NOR2X1 U2425 ( .A(n3644), .B(n3592), .Y(n3617) );
  NOR2X1 U2426 ( .A(n3645), .B(n3591), .Y(n3644) );
  NAND2BX1 U2427 ( .AN(n3330), .B(n3150), .Y(n3297) );
  NAND2BX1 U2428 ( .AN(n3330), .B(n3149), .Y(n3295) );
  NAND3BX1 U2429 ( .AN(n3197), .B(n3630), .C(n3631), .Y(n3619) );
  OAI21X1 U2430 ( .A0(n3632), .A1(n3633), .B0(n3572), .Y(n3631) );
  NOR2X1 U2431 ( .A(n3108), .B(n3206), .Y(n3632) );
  NAND2X1 U2432 ( .A(n3570), .B(n3558), .Y(n3141) );
  NAND2X1 U2433 ( .A(n3524), .B(n3740), .Y(n3736) );
  NAND2X1 U2434 ( .A(n3734), .B(n3534), .Y(n3740) );
  NAND2X1 U2435 ( .A(Read), .B(n3630), .Y(n3664) );
  NAND2BX1 U2436 ( .AN(n3648), .B(n3649), .Y(n3647) );
  NAND2X1 U2437 ( .A(n3652), .B(n3845), .Y(n3646) );
  NAND2X1 U2438 ( .A(n3651), .B(n3601), .Y(n3648) );
  NAND2X1 U2439 ( .A(n3630), .B(n3518), .Y(n3673) );
  OAI21X1 U2440 ( .A0(n3636), .A1(n3637), .B0(n3638), .Y(n3635) );
  NAND3X1 U2441 ( .A(rw_state[2]), .B(n3519), .C(n3642), .Y(n3634) );
  NOR2X1 U2442 ( .A(n3639), .B(n3640), .Y(n3638) );
  NOR2X1 U2443 ( .A(n3566), .B(n3553), .Y(n3564) );
  NOR2X1 U2444 ( .A(n3567), .B(n3568), .Y(n3566) );
  NOR2BX1 U2445 ( .AN(n3569), .B(n3557), .Y(n3568) );
  NOR2BX1 U2446 ( .AN(n3570), .B(n3559), .Y(n3567) );
  NOR2X1 U2447 ( .A(n3552), .B(n3553), .Y(n3550) );
  NOR2X1 U2448 ( .A(n3554), .B(n3555), .Y(n3552) );
  NOR2BX1 U2449 ( .AN(n3556), .B(n3557), .Y(n3555) );
  NOR2BX1 U2450 ( .AN(n3558), .B(n3559), .Y(n3554) );
  NAND2X1 U2451 ( .A(n3569), .B(n3556), .Y(n3251) );
  NAND2X1 U2452 ( .A(n3519), .B(n3747), .Y(n3612) );
  NAND2X1 U2453 ( .A(n3614), .B(n3748), .Y(n3747) );
  NAND2X1 U2454 ( .A(n3587), .B(n3588), .Y(n3748) );
  NAND2BX1 U2455 ( .AN(n3641), .B(n3588), .Y(n3731) );
  NAND2X1 U2456 ( .A(n3614), .B(n3730), .Y(n3729) );
  NAND2X1 U2457 ( .A(n3587), .B(n3588), .Y(n3730) );
  NAND2X1 U2458 ( .A(n3614), .B(n3643), .Y(n3642) );
  NAND2X1 U2459 ( .A(n3587), .B(n3588), .Y(n3643) );
  NAND2X1 U2460 ( .A(n3587), .B(n3588), .Y(n3658) );
  NOR2X1 U2461 ( .A(n3536), .B(n3732), .Y(n3739) );
  NOR2BX1 U2462 ( .AN(n3588), .B(n3641), .Y(n3636) );
  OA21X2 U2463 ( .A0(n3537), .A1(n3732), .B0(n3530), .Y(n3524) );
  INVX1 U2464 ( .A(n3581), .Y(n3844) );
  NOR2X1 U2465 ( .A(n3528), .B(n3752), .Y(n3754) );
  NAND2X1 U2466 ( .A(n3584), .B(n3585), .Y(nextrw_state_1_) );
  NAND2X1 U2467 ( .A(n3586), .B(n3459), .Y(n3584) );
  NAND2X1 U2468 ( .A(n3587), .B(n3588), .Y(n3586) );
  NOR2X1 U2469 ( .A(n3670), .B(n3671), .Y(n2601) );
  INVX1 U2470 ( .A(n3664), .Y(n3671) );
  AOI2BB2X1 U2471 ( .A0N(n3673), .A1N(n3504), .B0(n3672), .B1(n3673), .Y(n3670) );
  NAND2X1 U2472 ( .A(n3674), .B(n3675), .Y(n3672) );
  INVX1 U2473 ( .A(n3330), .Y(n3299) );
  NAND2X1 U2474 ( .A(n3662), .B(n3629), .Y(n2625) );
  NOR2X1 U2475 ( .A(n3666), .B(n3460), .Y(n3665) );
  MX2X1 U2476 ( .S0(n3536), .B(n3736), .A(n3735), .Y(n3525) );
  NAND2X1 U2477 ( .A(n3572), .B(n3141), .Y(n3149) );
  DFFRX1 cycle_cnt_reg_3_ ( .D(n2497), .CK(PCLK), .RN(PRESETn), .Q(
        cycle_cnt_3_), .QN(n3533) );
  DFFRX1 cycle_cnt_reg_1_ ( .D(n2499), .CK(PCLK), .RN(PRESETn), .Q(
        cycle_cnt_1_), .QN(n3534) );
  DFFRX1 RW_cnt_reg ( .D(n2623), .CK(PCLK), .RN(PRESETn), .Q(RW_cnt) );
  NAND3X1 U2478 ( .A(rw_state[3]), .B(n3457), .C(n3824), .Y(n3134) );
  NOR2X1 U2479 ( .A(rw_state[2]), .B(n3837), .Y(n3824) );
  NAND2X1 U2480 ( .A(n3797), .B(n3798), .Y(n3252) );
  NAND3X1 U2481 ( .A(n3837), .B(n3457), .C(n3807), .Y(n3795) );
  NOR2X1 U2482 ( .A(rw_state[3]), .B(rw_state[2]), .Y(n3807) );
  INVX1 U2483 ( .A(n3611), .Y(n3639) );
  NAND2X1 U2484 ( .A(n3746), .B(n3817), .Y(n3724) );
  NOR2X1 U2485 ( .A(n3818), .B(n3819), .Y(n3817) );
  NAND2X1 U2486 ( .A(n3820), .B(n3821), .Y(n3819) );
  NAND2X1 U2487 ( .A(n3822), .B(n3823), .Y(n3818) );
  NAND3X1 U2488 ( .A(rw_state[2]), .B(n3457), .C(n3801), .Y(n3796) );
  NOR2X1 U2489 ( .A(rw_state[3]), .B(n3837), .Y(n3801) );
  INVX1 U2490 ( .A(n3183), .Y(n3187) );
  XOR2X1 U2491 ( .A(n3651), .B(n3537), .Y(n3604) );
  AO22X1 U2492 ( .A0(n3340), .A1(n3341), .B0(n3342), .B1(n3343), .Y(n3847) );
  AO22X1 U2493 ( .A0(n3340), .A1(n3341), .B0(n3342), .B1(n3343), .Y(n3846) );
  AO22X1 U2494 ( .A0(n3340), .A1(n3341), .B0(n3342), .B1(n3343), .Y(n3338) );
  NAND2X1 U2495 ( .A(n3589), .B(nextmain_state[1]), .Y(n3592) );
  XOR2X1 U2496 ( .A(n3184), .B(n3536), .Y(n3597) );
  NAND3X1 U2497 ( .A(n3622), .B(n3623), .C(n3624), .Y(n3214) );
  NOR2X1 U2498 ( .A(n3627), .B(n3628), .Y(n3623) );
  NOR2X1 U2499 ( .A(n3625), .B(n3626), .Y(n3624) );
  INVX1 U2500 ( .A(n3449), .Y(n3622) );
  NOR3X1 U2501 ( .A(n3134), .B(n3603), .C(nextmain_state[0]), .Y(n3593) );
  XOR2X1 U2502 ( .A(n3604), .B(n3196), .Y(n3603) );
  INVX1 U2503 ( .A(n3835), .Y(n3829) );
  NOR3X1 U2504 ( .A(n3718), .B(n3592), .C(n3572), .Y(n3835) );
  NAND2X1 U2505 ( .A(n3797), .B(n3798), .Y(n3535) );
  NAND2X1 U2506 ( .A(n3197), .B(n3589), .Y(n3156) );
  INVX1 U2507 ( .A(n3836), .Y(n3834) );
  NOR3X1 U2508 ( .A(n3718), .B(n3592), .C(n3572), .Y(n3836) );
  INVX1 U2509 ( .A(n3676), .Y(n3826) );
  NOR3X1 U2510 ( .A(n3718), .B(n3592), .C(n3572), .Y(n3676) );
  INVX1 U2511 ( .A(n3589), .Y(nextmain_state[0]) );
  INVX1 U2512 ( .A(n3197), .Y(nextmain_state[1]) );
  NOR2X1 U2513 ( .A(n3132), .B(CSb), .Y(n3526) );
  INVX1 U2514 ( .A(n3455), .Y(hold_cnt1116_0_) );
  XOR2X1 U2515 ( .A(PreviousAdr_5_), .B(PADDR[5]), .Y(n3786) );
  XOR2X1 U2516 ( .A(PreviousAdr_15_), .B(PADDR[15]), .Y(n3788) );
  XOR2X1 U2517 ( .A(PreviousAdr_19_), .B(PADDR[19]), .Y(n3770) );
  XOR2X1 U2518 ( .A(PreviousAdr_18_), .B(PADDR[18]), .Y(n3772) );
  XOR2X1 U2519 ( .A(PreviousAdr_6_), .B(PADDR[6]), .Y(n3787) );
  XOR2X1 U2520 ( .A(PreviousAdr_13_), .B(PADDR[13]), .Y(n3789) );
  XOR2X1 U2521 ( .A(PreviousAdr_20_), .B(PADDR[20]), .Y(n3771) );
  XOR2X1 U2522 ( .A(PreviousAdr_16_), .B(PADDR[16]), .Y(n3773) );
  AOI21X1 U2523 ( .A0(PageSize[1]), .A1(PageSize[0]), .B0(PADDR[2]), .Y(n3757)
         );
  NAND2X1 U2524 ( .A(n3751), .B(n3752), .Y(n3750) );
  MXI2X1 U2525 ( .S0(PreviousAdr_2_), .B(n3757), .A(n3756), .Y(n3755) );
  OAI22X1 U2526 ( .A0(n3616), .A1(nextmain_state[0]), .B0(cycle_cntEn), .B1(
        n3214), .Y(n3621) );
  AOI21X1 U2527 ( .A0(PageSize[1]), .A1(PageSize[0]), .B0(n3678), .Y(n3756) );
  XOR2X1 U2528 ( .A(n3697), .B(PreviousAdr_11_), .Y(n3766) );
  INVX1 U2529 ( .A(PADDR[2]), .Y(n3678) );
  INVX1 U2530 ( .A(PADDR[4]), .Y(n3683) );
  INVX1 U2531 ( .A(PADDR[7]), .Y(n3689) );
  INVX1 U2532 ( .A(PADDR[11]), .Y(n3697) );
  NOR2X1 U2533 ( .A(n3486), .B(n3608), .Y(n3725) );
  NAND2X1 U2534 ( .A(n3731), .B(n3459), .Y(n3726) );
  NOR2X1 U2535 ( .A(n3732), .B(n3742), .Y(n3735) );
  NAND2X1 U2536 ( .A(cycle_cnt_1_), .B(n3537), .Y(n3742) );
  INVX1 U2537 ( .A(PWSTRB[3]), .Y(n3570) );
  INVX1 U2538 ( .A(PWSTRB[1]), .Y(n3569) );
  INVX1 U2539 ( .A(PWSTRB[2]), .Y(n3558) );
  INVX1 U2540 ( .A(PWSTRB[0]), .Y(n3556) );
  OAI31X1 U2541 ( .A0(n3141), .A1(RW_cnt), .A2(n3251), .B0(n3239), .Y(n3330)
         );
  XOR2X1 U2542 ( .A(PreviousAdr_14_), .B(PADDR[14]), .Y(n3783) );
  NOR2X1 U2543 ( .A(n3788), .B(n3789), .Y(n3784) );
  NOR2X1 U2544 ( .A(n3786), .B(n3787), .Y(n3785) );
  XOR2X1 U2545 ( .A(PreviousAdr_17_), .B(PADDR[17]), .Y(n3767) );
  NOR2X1 U2546 ( .A(n3772), .B(n3773), .Y(n3768) );
  NOR2X1 U2547 ( .A(n3770), .B(n3771), .Y(n3769) );
  NAND4X1 U2548 ( .A(n3134), .B(n3480), .C(n3764), .D(n3765), .Y(n3763) );
  XOR2X1 U2549 ( .A(n3695), .B(PreviousAdr_10_), .Y(n3765) );
  NAND3X1 U2550 ( .A(n3780), .B(n3781), .C(n3782), .Y(n3775) );
  XOR2X1 U2551 ( .A(n3689), .B(PreviousAdr_7_), .Y(n3781) );
  XOR2X1 U2552 ( .A(n3683), .B(PreviousAdr_4_), .Y(n3782) );
  XOR2X1 U2553 ( .A(net377), .B(PADDR[21]), .Y(n3780) );
  NAND3X1 U2554 ( .A(n3519), .B(n3743), .C(n3744), .Y(n3741) );
  OAI21X1 U2555 ( .A0(n3746), .A1(n3539), .B0(cycle_cntEn), .Y(n3743) );
  NAND2X1 U2556 ( .A(n3614), .B(n3745), .Y(n3744) );
  NAND2X1 U2557 ( .A(n3587), .B(n3588), .Y(n3745) );
  MXI2X1 U2558 ( .S0(cycle_cnt_1_), .B(n3524), .A(n3733), .Y(n2499) );
  NAND2X1 U2559 ( .A(n3734), .B(n3537), .Y(n3733) );
  NOR2X1 U2560 ( .A(main_state[0]), .B(n3484), .Y(n3814) );
  NAND2X1 U2561 ( .A(cycle_cntEn), .B(n3816), .Y(n3813) );
  NAND2X2 U2562 ( .A(n3816), .B(n3232), .Y(n3815) );
  NAND3X1 U2563 ( .A(n3777), .B(n3778), .C(n3779), .Y(n3776) );
  XOR2X1 U2564 ( .A(n3691), .B(PreviousAdr_8_), .Y(n3777) );
  XOR2X1 U2565 ( .A(n3699), .B(PreviousAdr_12_), .Y(n3778) );
  XOR2X1 U2566 ( .A(n3693), .B(PreviousAdr_9_), .Y(n3779) );
  NAND2BX1 U2567 ( .AN(rw_state[0]), .B(n3611), .Y(n3610) );
  NAND2X1 U2568 ( .A(n3611), .B(n3612), .Y(n3609) );
  MXI2X1 U2569 ( .S0(n3527), .B(n3732), .A(n3530), .Y(n2500) );
  MXI2X1 U2570 ( .S0(n3578), .B(n3843), .A(n3577), .Y(n2628) );
  NOR2X1 U2571 ( .A(n3616), .B(n3592), .Y(n3577) );
  MXI2X1 U2572 ( .S0(n3841), .B(n3678), .A(n3677), .Y(n2600) );
  MXI2X1 U2573 ( .S0(n3830), .B(NextADR1442_1_), .A(ADDR[1]), .Y(n3677) );
  MXI2X1 U2574 ( .S0(n3840), .B(n3699), .A(n3698), .Y(n2590) );
  MXI2X1 U2575 ( .S0(n3828), .B(NextADR1442_11_), .A(ADDR[11]), .Y(n3698) );
  MXI2X1 U2576 ( .S0(n3841), .B(n3697), .A(n3696), .Y(n2591) );
  MXI2X1 U2577 ( .S0(n3827), .B(NextADR1442_10_), .A(ADDR[10]), .Y(n3696) );
  MXI2X1 U2578 ( .S0(n3827), .B(NextADR1442_9_), .A(ADDR[9]), .Y(n3694) );
  MXI2X1 U2579 ( .S0(n3842), .B(n3693), .A(n3692), .Y(n2593) );
  MXI2X1 U2580 ( .S0(n3825), .B(NextADR1442_8_), .A(ADDR[8]), .Y(n3692) );
  MXI2X1 U2581 ( .S0(n3676), .B(NextADR1442_7_), .A(ADDR[7]), .Y(n3690) );
  MXI2X1 U2582 ( .S0(n3840), .B(n3689), .A(n3688), .Y(n2595) );
  MXI2X1 U2583 ( .S0(n3825), .B(NextADR1442_6_), .A(ADDR[6]), .Y(n3688) );
  INVX1 U2584 ( .A(n3826), .Y(n3825) );
  MXI2X1 U2585 ( .S0(n3842), .B(n3683), .A(n3682), .Y(n2598) );
  MXI2X1 U2586 ( .S0(n3832), .B(NextADR1442_3_), .A(ADDR[3]), .Y(n3682) );
  MXI2X1 U2587 ( .S0(n3842), .B(n3681), .A(n3680), .Y(n2599) );
  MXI2X1 U2588 ( .S0(n3831), .B(NextADR1442_2_), .A(ADDR[2]), .Y(n3680) );
  MXI2X1 U2589 ( .S0(n3840), .B(n3715), .A(n3714), .Y(n2582) );
  MXI2X1 U2590 ( .S0(n3832), .B(NextADR1442_19_), .A(ADDR[19]), .Y(n3714) );
  INVX1 U2591 ( .A(PADDR[20]), .Y(n3715) );
  MXI2X1 U2592 ( .S0(n3841), .B(n3713), .A(n3712), .Y(n2583) );
  MXI2X1 U2593 ( .S0(n3831), .B(NextADR1442_18_), .A(ADDR[18]), .Y(n3712) );
  INVX1 U2594 ( .A(PADDR[19]), .Y(n3713) );
  MXI2X1 U2595 ( .S0(n3840), .B(n3711), .A(n3710), .Y(n2584) );
  MXI2X1 U2596 ( .S0(n3830), .B(NextADR1442_17_), .A(ADDR[17]), .Y(n3710) );
  INVX1 U2597 ( .A(PADDR[18]), .Y(n3711) );
  MXI2X1 U2598 ( .S0(n3841), .B(n3709), .A(n3708), .Y(n2585) );
  MXI2X1 U2599 ( .S0(n3828), .B(NextADR1442_16_), .A(ADDR[16]), .Y(n3708) );
  INVX1 U2600 ( .A(PADDR[17]), .Y(n3709) );
  MXI2X1 U2601 ( .S0(n3840), .B(n3707), .A(n3706), .Y(n2586) );
  MXI2X1 U2602 ( .S0(n3833), .B(NextADR1442_15_), .A(ADDR[15]), .Y(n3706) );
  INVX1 U2603 ( .A(PADDR[16]), .Y(n3707) );
  MXI2X1 U2604 ( .S0(n3841), .B(n3705), .A(n3704), .Y(n2587) );
  MXI2X1 U2605 ( .S0(n3828), .B(NextADR1442_14_), .A(ADDR[14]), .Y(n3704) );
  INVX1 U2606 ( .A(PADDR[15]), .Y(n3705) );
  MXI2X1 U2607 ( .S0(n3840), .B(n3703), .A(n3702), .Y(n2588) );
  MXI2X1 U2608 ( .S0(n3827), .B(NextADR1442_13_), .A(ADDR[13]), .Y(n3702) );
  INVX1 U2609 ( .A(PADDR[14]), .Y(n3703) );
  MXI2X1 U2610 ( .S0(n3841), .B(n3701), .A(n3700), .Y(n2589) );
  MXI2X1 U2611 ( .S0(n3827), .B(NextADR1442_12_), .A(ADDR[12]), .Y(n3700) );
  INVX1 U2612 ( .A(PADDR[13]), .Y(n3701) );
  MXI2X1 U2613 ( .S0(n3842), .B(n3687), .A(n3686), .Y(n2596) );
  MXI2X1 U2614 ( .S0(n3825), .B(NextADR1442_5_), .A(ADDR[5]), .Y(n3686) );
  INVX1 U2615 ( .A(PADDR[6]), .Y(n3687) );
  MXI2X1 U2616 ( .S0(n3842), .B(n3685), .A(n3684), .Y(n2597) );
  MXI2X1 U2617 ( .S0(n3833), .B(NextADR1442_4_), .A(ADDR[4]), .Y(n3684) );
  INVX1 U2618 ( .A(PADDR[5]), .Y(n3685) );
  AOI21X1 U2619 ( .A0(n3574), .A1(n3553), .B0(n3521), .Y(n2629) );
  NOR2X1 U2620 ( .A(OEb), .B(n3576), .Y(n3574) );
  NAND2X1 U2621 ( .A(n3790), .B(n3791), .Y(n3637) );
  NOR2X1 U2622 ( .A(main_state[0]), .B(n3484), .Y(n3790) );
  OAI21X1 U2623 ( .A0(n3206), .A1(n3792), .B0(n3544), .Y(n3791) );
  NAND2X1 U2624 ( .A(RW_cnt), .B(n3793), .Y(n3792) );
  NOR3X1 U2625 ( .A(n3562), .B(n3521), .C(n3563), .Y(n2630) );
  NOR2X1 U2626 ( .A(n3560), .B(n3571), .Y(n3562) );
  NOR2X1 U2627 ( .A(n3564), .B(n3565), .Y(n3563) );
  MXI2X1 U2628 ( .S0(n3150), .B(PWSTRB[3]), .A(PWSTRB[1]), .Y(n3571) );
  NOR3X1 U2629 ( .A(n3548), .B(n3521), .C(n3549), .Y(n2631) );
  NOR2X1 U2630 ( .A(n3560), .B(n3561), .Y(n3548) );
  NOR2X1 U2631 ( .A(n3550), .B(n3551), .Y(n3549) );
  MXI2X1 U2632 ( .S0(n3150), .B(PWSTRB[2]), .A(PWSTRB[0]), .Y(n3561) );
  NAND3X1 U2633 ( .A(n3519), .B(rw_state[4]), .C(n3613), .Y(n3581) );
  NAND2X1 U2634 ( .A(n3614), .B(n3615), .Y(n3613) );
  NAND2X1 U2635 ( .A(n3587), .B(n3588), .Y(n3615) );
  XOR2X1 U2636 ( .A(n3681), .B(n3529), .Y(n3528) );
  AND2X2 U2637 ( .A(Enable), .B(n3741), .Y(n3530) );
  NOR2X1 U2638 ( .A(n3841), .B(n3716), .Y(n2581) );
  MXI2X1 U2639 ( .S0(n3833), .B(n3717), .A(ADDR[20]), .Y(n3716) );
  NAND2X1 U2640 ( .A(n3737), .B(n3738), .Y(n2497) );
  NAND3X1 U2641 ( .A(n3735), .B(n3536), .C(n3533), .Y(n3737) );
  OAI21X1 U2642 ( .A0(n3739), .A1(n3736), .B0(cycle_cnt_3_), .Y(n3738) );
  OAI222X1 U2643 ( .A0(n3295), .A1(n3462), .B0(n3297), .B1(n3488), .C0(n3299), 
        .C1(n2466), .Y(n2565) );
  OAI222X1 U2644 ( .A0(n3295), .A1(n3463), .B0(n3297), .B1(n3489), .C0(n3299), 
        .C1(n2465), .Y(n2566) );
  OAI222X1 U2645 ( .A0(n3295), .A1(n3464), .B0(n3297), .B1(n3490), .C0(n3299), 
        .C1(n2464), .Y(n2567) );
  OAI222X1 U2646 ( .A0(n3295), .A1(n3465), .B0(n3297), .B1(n3491), .C0(n3299), 
        .C1(n2463), .Y(n2568) );
  OAI222X1 U2647 ( .A0(n3295), .A1(n3466), .B0(n3297), .B1(n3492), .C0(n3299), 
        .C1(n2462), .Y(n2569) );
  OAI222X1 U2648 ( .A0(n3295), .A1(n3467), .B0(n3297), .B1(n3493), .C0(n3299), 
        .C1(n2461), .Y(n2570) );
  OAI222X1 U2649 ( .A0(n3295), .A1(n3468), .B0(n3297), .B1(n3494), .C0(n3299), 
        .C1(n2475), .Y(n2571) );
  OAI222X1 U2650 ( .A0(n3295), .A1(n3469), .B0(n3297), .B1(n3495), .C0(n3299), 
        .C1(n2474), .Y(n2572) );
  OAI222X1 U2651 ( .A0(n3295), .A1(n3470), .B0(n3297), .B1(n3496), .C0(n3299), 
        .C1(n2473), .Y(n2573) );
  OAI222X1 U2652 ( .A0(n3295), .A1(n3471), .B0(n3297), .B1(n3497), .C0(n3299), 
        .C1(n2472), .Y(n2574) );
  OAI222X1 U2653 ( .A0(n3295), .A1(n3472), .B0(n3297), .B1(n3498), .C0(n3299), 
        .C1(n2471), .Y(n2575) );
  OAI222X1 U2654 ( .A0(n3295), .A1(n3473), .B0(n3297), .B1(n3499), .C0(n3299), 
        .C1(n2470), .Y(n2576) );
  OAI222X1 U2655 ( .A0(n3295), .A1(n3474), .B0(n3297), .B1(n3500), .C0(n3299), 
        .C1(n2469), .Y(n2577) );
  OAI222X1 U2656 ( .A0(n3295), .A1(n3475), .B0(n3297), .B1(n3501), .C0(n3299), 
        .C1(n2468), .Y(n2578) );
  OAI222X1 U2657 ( .A0(n3295), .A1(n3476), .B0(n3297), .B1(n3502), .C0(n3299), 
        .C1(n2467), .Y(n2579) );
  OAI222X1 U2658 ( .A0(n3295), .A1(n3477), .B0(n3297), .B1(n3503), .C0(n3299), 
        .C1(n2460), .Y(n2580) );
  NAND3X1 U2659 ( .A(n3460), .B(n3214), .C(n3545), .Y(n3543) );
  INVX1 U2660 ( .A(n3131), .Y(n3545) );
  INVX1 U2661 ( .A(PENABLE), .Y(n3547) );
  MXI2X1 U2662 ( .S0(n3541), .B(n2476), .A(n3540), .Y(n2632) );
  NAND2BX1 U2663 ( .AN(Write), .B(n3546), .Y(n3540) );
  INVX1 U2664 ( .A(n3542), .Y(n3541) );
  NOR2X1 U2665 ( .A(n3547), .B(Read), .Y(n3546) );
  AO22X1 U2666 ( .A0(PADDR[6]), .A1(n3535), .B0(n3206), .B1(PreviousAdr_6_), 
        .Y(n2617) );
  AO22X1 U2667 ( .A0(PADDR[9]), .A1(n3535), .B0(n3206), .B1(PreviousAdr_9_), 
        .Y(n2614) );
  AO22X1 U2668 ( .A0(PADDR[18]), .A1(n3535), .B0(n3206), .B1(PreviousAdr_18_), 
        .Y(n2605) );
  AO22X1 U2669 ( .A0(PWDATA[31]), .A1(Write), .B0(PSRAMWDATA[31]), .B1(n3520), 
        .Y(n2533) );
  AO22X1 U2670 ( .A0(PWDATA[30]), .A1(Write), .B0(PSRAMWDATA[30]), .B1(n3520), 
        .Y(n2534) );
  AO22X1 U2671 ( .A0(PWDATA[29]), .A1(Write), .B0(PSRAMWDATA[29]), .B1(n3520), 
        .Y(n2535) );
  AO22X1 U2672 ( .A0(PWDATA[28]), .A1(Write), .B0(PSRAMWDATA[28]), .B1(n3520), 
        .Y(n2536) );
  AO22X1 U2673 ( .A0(PWDATA[27]), .A1(Write), .B0(PSRAMWDATA[27]), .B1(n3520), 
        .Y(n2537) );
  AO22X1 U2674 ( .A0(PWDATA[26]), .A1(Write), .B0(PSRAMWDATA[26]), .B1(n3520), 
        .Y(n2538) );
  AO22X1 U2675 ( .A0(PWDATA[25]), .A1(Write), .B0(PSRAMWDATA[25]), .B1(n3520), 
        .Y(n2539) );
  AO22X1 U2676 ( .A0(PWDATA[24]), .A1(Write), .B0(PSRAMWDATA[24]), .B1(n3520), 
        .Y(n2540) );
  AO22X1 U2677 ( .A0(PWDATA[23]), .A1(Write), .B0(PSRAMWDATA[23]), .B1(n3520), 
        .Y(n2541) );
  AO22X1 U2678 ( .A0(PWDATA[22]), .A1(Write), .B0(PSRAMWDATA[22]), .B1(n3520), 
        .Y(n2542) );
  AO22X1 U2679 ( .A0(PWDATA[21]), .A1(Write), .B0(PSRAMWDATA[21]), .B1(n3520), 
        .Y(n2543) );
  AO22X1 U2680 ( .A0(PWDATA[20]), .A1(Write), .B0(PSRAMWDATA[20]), .B1(n3520), 
        .Y(n2544) );
  AO22X1 U2681 ( .A0(PWDATA[19]), .A1(Write), .B0(PSRAMWDATA[19]), .B1(n3520), 
        .Y(n2545) );
  AO22X1 U2682 ( .A0(PWDATA[18]), .A1(Write), .B0(PSRAMWDATA[18]), .B1(n3520), 
        .Y(n2546) );
  AO22X1 U2683 ( .A0(PWDATA[17]), .A1(Write), .B0(PSRAMWDATA[17]), .B1(n3520), 
        .Y(n2547) );
  AO22X1 U2684 ( .A0(PWDATA[16]), .A1(Write), .B0(PSRAMWDATA[16]), .B1(n3520), 
        .Y(n2548) );
  AO22X1 U2685 ( .A0(PWDATA[15]), .A1(Write), .B0(PSRAMWDATA[15]), .B1(n3520), 
        .Y(n2549) );
  AO22X1 U2686 ( .A0(PWDATA[14]), .A1(Write), .B0(PSRAMWDATA[14]), .B1(n3520), 
        .Y(n2550) );
  AO22X1 U2687 ( .A0(PWDATA[13]), .A1(Write), .B0(PSRAMWDATA[13]), .B1(n3520), 
        .Y(n2551) );
  AO22X1 U2688 ( .A0(PWDATA[12]), .A1(Write), .B0(PSRAMWDATA[12]), .B1(n3520), 
        .Y(n2552) );
  AO22X1 U2689 ( .A0(PWDATA[11]), .A1(Write), .B0(PSRAMWDATA[11]), .B1(n3520), 
        .Y(n2553) );
  AO22X1 U2690 ( .A0(PWDATA[10]), .A1(Write), .B0(PSRAMWDATA[10]), .B1(n3520), 
        .Y(n2554) );
  AO22X1 U2691 ( .A0(PWDATA[9]), .A1(Write), .B0(PSRAMWDATA[9]), .B1(n3520), 
        .Y(n2555) );
  AO22X1 U2692 ( .A0(PWDATA[8]), .A1(Write), .B0(PSRAMWDATA[8]), .B1(n3520), 
        .Y(n2556) );
  AO22X1 U2693 ( .A0(PWDATA[7]), .A1(Write), .B0(PSRAMWDATA[7]), .B1(n3520), 
        .Y(n2557) );
  AO22X1 U2694 ( .A0(PWDATA[6]), .A1(Write), .B0(PSRAMWDATA[6]), .B1(n3520), 
        .Y(n2558) );
  AO22X1 U2695 ( .A0(PWDATA[5]), .A1(Write), .B0(PSRAMWDATA[5]), .B1(n3520), 
        .Y(n2559) );
  AO22X1 U2696 ( .A0(PWDATA[4]), .A1(Write), .B0(PSRAMWDATA[4]), .B1(n3520), 
        .Y(n2560) );
  AO22X1 U2697 ( .A0(PWDATA[3]), .A1(Write), .B0(PSRAMWDATA[3]), .B1(n3520), 
        .Y(n2561) );
  AO22X1 U2698 ( .A0(PWDATA[2]), .A1(Write), .B0(PSRAMWDATA[2]), .B1(n3520), 
        .Y(n2562) );
  AO22X1 U2699 ( .A0(PWDATA[1]), .A1(Write), .B0(PSRAMWDATA[1]), .B1(n3520), 
        .Y(n2563) );
  AO22X1 U2700 ( .A0(PWDATA[0]), .A1(Write), .B0(PSRAMWDATA[0]), .B1(n3520), 
        .Y(n2564) );
  AO22X1 U2701 ( .A0(PADDR[21]), .A1(n3535), .B0(n3206), .B1(PreviousAdr_21_), 
        .Y(n2602) );
  AO22X1 U2702 ( .A0(PADDR[17]), .A1(n3252), .B0(n3206), .B1(PreviousAdr_17_), 
        .Y(n2606) );
  AO22X1 U2703 ( .A0(PADDR[16]), .A1(n3535), .B0(n3206), .B1(PreviousAdr_16_), 
        .Y(n2607) );
  AO22X1 U2704 ( .A0(PADDR[15]), .A1(n3535), .B0(n3206), .B1(PreviousAdr_15_), 
        .Y(n2608) );
  AO22X1 U2705 ( .A0(PADDR[13]), .A1(n3252), .B0(n3206), .B1(PreviousAdr_13_), 
        .Y(n2610) );
  AO22X1 U2706 ( .A0(PADDR[12]), .A1(n3535), .B0(n3206), .B1(PreviousAdr_12_), 
        .Y(n2611) );
  AO22X1 U2707 ( .A0(PADDR[10]), .A1(n3535), .B0(n3206), .B1(PreviousAdr_10_), 
        .Y(n2613) );
  AO22X1 U2708 ( .A0(PADDR[7]), .A1(n3535), .B0(n3206), .B1(PreviousAdr_7_), 
        .Y(n2616) );
  AO22X1 U2709 ( .A0(PADDR[5]), .A1(n3535), .B0(n3206), .B1(PreviousAdr_5_), 
        .Y(n2618) );
  AO22X1 U2710 ( .A0(PADDR[4]), .A1(n3535), .B0(n3206), .B1(PreviousAdr_4_), 
        .Y(n2619) );
  AO22X1 U2711 ( .A0(PADDR[2]), .A1(n3252), .B0(n3206), .B1(PreviousAdr_2_), 
        .Y(n2621) );
  AO22X1 U2712 ( .A0(PADDR[14]), .A1(n3535), .B0(n3206), .B1(PreviousAdr_14_), 
        .Y(n2609) );
  AO22X1 U2713 ( .A0(PADDR[8]), .A1(n3252), .B0(n3206), .B1(PreviousAdr_8_), 
        .Y(n2615) );
  NAND3X1 U2714 ( .A(n3667), .B(n3668), .C(n3544), .Y(n2623) );
  NAND2X1 U2715 ( .A(n3718), .B(RW_cnt), .Y(n3667) );
  NAND3X1 U2716 ( .A(n3251), .B(n3141), .C(Write), .Y(n3668) );
  INVX1 U2717 ( .A(n2), .Y(carry_19_) );
  INVX1 U2718 ( .A(n18), .Y(carry_3_) );
  INVX1 U2719 ( .A(n17), .Y(carry_4_) );
  INVX1 U2720 ( .A(n16), .Y(carry_5_) );
  INVX1 U2721 ( .A(n13), .Y(carry_8_) );
  INVX1 U2722 ( .A(n11), .Y(carry_10_) );
  INVX1 U2723 ( .A(n9), .Y(carry_12_) );
  INVX1 U2724 ( .A(n7), .Y(carry_14_) );
  INVX1 U2725 ( .A(n5), .Y(carry_16_) );
  INVX1 U2726 ( .A(n4), .Y(carry_17_) );
  INVX1 U2727 ( .A(n3), .Y(carry_18_) );
  INVX1 U2728 ( .A(n19), .Y(carry_2_) );
  INVX1 U2729 ( .A(n15), .Y(carry_6_) );
  INVX1 U2730 ( .A(n14), .Y(carry_7_) );
  INVX1 U2731 ( .A(n12), .Y(carry_9_) );
  INVX1 U2732 ( .A(n10), .Y(carry_11_) );
  INVX1 U2733 ( .A(n8), .Y(carry_13_) );
  INVX1 U2734 ( .A(n6), .Y(carry_15_) );
  OAI2BB1X1 U2735 ( .A0N(n3531), .A1N(n3532), .B0(n3764), .Y(n3611) );
  AND2X2 U2736 ( .A(Enable), .B(main_state[1]), .Y(n3531) );
  XOR2X1 U2737 ( .A(PSRAMTCON[17]), .B(n3533), .Y(n3822) );
  XOR2X1 U2738 ( .A(PSRAMTCON[15]), .B(n3534), .Y(n3820) );
  XOR2X1 U2739 ( .A(cycle_cnt_1_), .B(PSRAMTCON[22]), .Y(n3802) );
  XOR2X1 U2740 ( .A(n3537), .B(PSRAMTCON[28]), .Y(n3810) );
  XOR2X1 U2741 ( .A(n3537), .B(PSRAMTCON[21]), .Y(n3803) );
  XOR2X1 U2742 ( .A(cycle_cnt_3_), .B(PSRAMTCON[31]), .Y(n3811) );
  XOR2X1 U2743 ( .A(cycle_cnt_1_), .B(PSRAMTCON[29]), .Y(n3809) );
  XNOR2X1 U2744 ( .A(PSRAMTCON[16]), .B(n3536), .Y(n3823) );
  XNOR2X1 U2745 ( .A(PSRAMTCON[14]), .B(n3537), .Y(n3821) );
  XOR2X1 U2746 ( .A(n3533), .B(PSRAMTCON[7]), .Y(n3335) );
  INVX1 U2747 ( .A(rw_state[1]), .Y(n3838) );
  INVX1 U2748 ( .A(n3195), .Y(n3190) );
  NAND2BX1 U2749 ( .AN(n3196), .B(PSRAMTCON[12]), .Y(n3195) );
  INVX1 U2750 ( .A(n3331), .Y(n3239) );
  NAND2BX1 U2751 ( .AN(n3134), .B(n3332), .Y(n3331) );
  AND4X1 U2752 ( .A(n3333), .B(n3334), .C(n3335), .D(n3336), .Y(n3332) );
  XOR2X1 U2753 ( .A(n3527), .B(PSRAMTCON[4]), .Y(n3334) );
  NAND3X1 U2754 ( .A(n3805), .B(n3806), .C(n3340), .Y(n3797) );
  NOR2X1 U2755 ( .A(n3808), .B(n3809), .Y(n3806) );
  NOR2X1 U2756 ( .A(n3810), .B(n3811), .Y(n3805) );
  XOR2X1 U2757 ( .A(n3536), .B(PSRAMTCON[30]), .Y(n3808) );
  NAND3X1 U2758 ( .A(n3799), .B(n3800), .C(n3342), .Y(n3798) );
  NOR2X1 U2759 ( .A(cycle_cnt_3_), .B(n3804), .Y(n3799) );
  NOR2X1 U2760 ( .A(n3802), .B(n3803), .Y(n3800) );
  XOR2X1 U2761 ( .A(n3536), .B(PSRAMTCON[23]), .Y(n3804) );
  BUFX2 U2762 ( .A(cycle_cnt_2_), .Y(n3536) );
  NAND2X1 U2763 ( .A(n3633), .B(RW_cnt), .Y(n3816) );
  NAND4BX1 U2764 ( .AN(rw_state[2]), .B(n3812), .C(rw_state[0]), .D(n3479), 
        .Y(n3764) );
  NOR2X1 U2765 ( .A(rw_state[4]), .B(rw_state[3]), .Y(n3812) );
  BUFX2 U2766 ( .A(n3849), .Y(CSb) );
  BUFX2 U2767 ( .A(cycle_cnt_0_), .Y(n3537) );
  NAND2X1 U2768 ( .A(n3190), .B(PSRAMTCON[9]), .Y(n3600) );
  INVX1 U2769 ( .A(PageSize[1]), .Y(n3752) );
  INVX1 U2770 ( .A(PageSize[0]), .Y(n3751) );
  NAND2X1 U2771 ( .A(n3598), .B(n3599), .Y(n3183) );
  NAND2X1 U2772 ( .A(n3602), .B(n3195), .Y(n3598) );
  NAND2X1 U2773 ( .A(n3600), .B(n3601), .Y(n3599) );
  INVX1 U2774 ( .A(PSRAMTCON[9]), .Y(n3602) );
  XOR2X1 U2775 ( .A(n3596), .B(cycle_cnt_3_), .Y(n3595) );
  INVX1 U2776 ( .A(n3182), .Y(n3596) );
  OAI31X1 U2777 ( .A0(n3183), .A1(PSRAMTCON[11]), .A2(n3184), .B0(n3185), .Y(
        n3182) );
  OA22X1 U2778 ( .A0(PSRAMTCON[10]), .A1(n3186), .B0(n3187), .B1(n3186), .Y(
        n3185) );
  OR2X1 U1_B_1 ( .A(ToutCnt[1]), .B(ToutCnt[0]), .Y(carry7) );
  OR2X1 U1_B_2 ( .A(ToutCnt[2]), .B(carry7), .Y(carry6) );
  OR2X1 U1_B_3 ( .A(ToutCnt[3]), .B(carry6), .Y(carry5) );
  OR2X1 U1_B_4 ( .A(ToutCnt[4]), .B(carry5), .Y(carry4) );
  OR2X1 U1_B_5 ( .A(ToutCnt[5]), .B(carry4), .Y(carry3) );
  OR2X1 U1_B_6 ( .A(ToutCnt[6]), .B(carry3), .Y(carry2) );
  OR2X1 U1_B_7 ( .A(ToutCnt[7]), .B(carry2), .Y(carry1) );
  OR2X1 U1_B_8 ( .A(ToutCnt[8]), .B(carry1), .Y(carry0) );
  AO22X1 U2779 ( .A0(PSRAMTOUT[10]), .A1(CSb), .B0(ToutCnt714_10_), .B1(n3526), 
        .Y(n2486) );
  XNOR2X1 U1_A_10 ( .A(ToutCnt[10]), .B(carry), .Y(ToutCnt714_10_) );
  OR2X1 U1_B_9 ( .A(ToutCnt[9]), .B(carry0), .Y(carry) );
  INVX1 U2780 ( .A(PSRAMTCON[8]), .Y(n3196) );
  XOR2X1 U2781 ( .A(n3478), .B(PSRAMTCON[6]), .Y(n3336) );
  XOR2X1 U2782 ( .A(n3534), .B(PSRAMTCON[5]), .Y(n3333) );
  NAND3BX1 U2783 ( .AN(ToutCnt[9]), .B(n2483), .C(n2482), .Y(n3449) );
  XOR2X1 U2784 ( .A(n3534), .B(PSRAMTCON[25]), .Y(n3350) );
  NAND2BX1 U2785 ( .AN(hold_cnt_0_), .B(Hold), .Y(n3455) );
  AOI2BB1X1 U2786 ( .A0N(Hold), .A1N(n3134), .B0(n3539), .Y(n3131) );
  NOR2X1 U2787 ( .A(n3718), .B(RW_cnt), .Y(n3666) );
  XOR3X1 U2788 ( .A(PSRAMTCON[13]), .B(PSRAMTCON[9]), .C(n3534), .Y(n3189) );
  NOR2X1 U2789 ( .A(n3659), .B(n3134), .Y(n3652) );
  NAND3X1 U2790 ( .A(n3604), .B(n3660), .C(n3661), .Y(n3659) );
  NOR2X1 U2791 ( .A(cycle_cnt_3_), .B(n3536), .Y(n3661) );
  XOR2X1 U2792 ( .A(n3601), .B(cycle_cnt_1_), .Y(n3660) );
  NAND2X1 U2793 ( .A(n3828), .B(n3538), .Y(n3675) );
  NAND2X1 U2794 ( .A(n3156), .B(net350), .Y(n3565) );
  NAND2X1 U2795 ( .A(n3156), .B(net351), .Y(n3551) );
  NAND2X1 U2796 ( .A(Enable), .B(n3722), .Y(n3589) );
  NAND2X1 U2797 ( .A(n3723), .B(n3719), .Y(n3722) );
  NAND2X1 U2798 ( .A(main_state[0]), .B(n3721), .Y(n3723) );
  NAND2X1 U2799 ( .A(n2477), .B(n2478), .Y(n3625) );
  NAND2X1 U2800 ( .A(net336), .B(n2479), .Y(n3627) );
  AO22X1 U2801 ( .A0(DATAIN[15]), .A1(n3847), .B0(PSRAMRDATA[31]), .B1(n3339), 
        .Y(n2501) );
  AO22X1 U2802 ( .A0(DATAIN[14]), .A1(n3846), .B0(PSRAMRDATA[30]), .B1(n3339), 
        .Y(n2502) );
  AO22X1 U2803 ( .A0(DATAIN[13]), .A1(n3338), .B0(PSRAMRDATA[29]), .B1(n3339), 
        .Y(n2503) );
  AO22X1 U2804 ( .A0(DATAIN[12]), .A1(n3847), .B0(PSRAMRDATA[28]), .B1(n3339), 
        .Y(n2504) );
  AO22X1 U2805 ( .A0(DATAIN[11]), .A1(n3846), .B0(PSRAMRDATA[27]), .B1(n3339), 
        .Y(n2505) );
  AO22X1 U2806 ( .A0(DATAIN[10]), .A1(n3338), .B0(PSRAMRDATA[26]), .B1(n3339), 
        .Y(n2506) );
  AO22X1 U2807 ( .A0(DATAIN[9]), .A1(n3847), .B0(PSRAMRDATA[25]), .B1(n3339), 
        .Y(n2507) );
  AO22X1 U2808 ( .A0(DATAIN[8]), .A1(n3846), .B0(PSRAMRDATA[24]), .B1(n3339), 
        .Y(n2508) );
  AO22X1 U2809 ( .A0(DATAIN[7]), .A1(n3338), .B0(PSRAMRDATA[23]), .B1(n3339), 
        .Y(n2509) );
  AO22X1 U2810 ( .A0(DATAIN[6]), .A1(n3847), .B0(PSRAMRDATA[22]), .B1(n3339), 
        .Y(n2510) );
  AO22X1 U2811 ( .A0(DATAIN[5]), .A1(n3846), .B0(PSRAMRDATA[21]), .B1(n3339), 
        .Y(n2511) );
  AO22X1 U2812 ( .A0(DATAIN[4]), .A1(n3338), .B0(PSRAMRDATA[20]), .B1(n3339), 
        .Y(n2512) );
  AO22X1 U2813 ( .A0(DATAIN[3]), .A1(n3847), .B0(PSRAMRDATA[19]), .B1(n3339), 
        .Y(n2513) );
  AO22X1 U2814 ( .A0(DATAIN[2]), .A1(n3846), .B0(PSRAMRDATA[18]), .B1(n3339), 
        .Y(n2514) );
  AO22X1 U2815 ( .A0(DATAIN[1]), .A1(n3847), .B0(PSRAMRDATA[17]), .B1(n3339), 
        .Y(n2515) );
  AO22X1 U2816 ( .A0(DATAIN[0]), .A1(n3847), .B0(PSRAMRDATA[16]), .B1(n3339), 
        .Y(n2516) );
  NAND2X1 U2817 ( .A(net340), .B(net329), .Y(n3626) );
  NAND2X1 U2818 ( .A(n2481), .B(n2480), .Y(n3628) );
  OR2X1 U2819 ( .A(n3538), .B(n3836), .Y(n3674) );
  AND4X1 U2820 ( .A(n3347), .B(n3348), .C(n3349), .D(n3350), .Y(n3341) );
  XOR2X1 U2821 ( .A(n3478), .B(PSRAMTCON[26]), .Y(n3348) );
  XOR2X1 U2822 ( .A(n3527), .B(PSRAMTCON[24]), .Y(n3349) );
  XOR2X1 U2823 ( .A(n3533), .B(PSRAMTCON[27]), .Y(n3347) );
  AND4X1 U2824 ( .A(n3344), .B(n3533), .C(n3345), .D(n3346), .Y(n3343) );
  XOR2X1 U2825 ( .A(n3478), .B(PSRAMTCON[20]), .Y(n3344) );
  XOR2X1 U2826 ( .A(n3527), .B(PSRAMTCON[18]), .Y(n3346) );
  XOR2X1 U2827 ( .A(n3534), .B(PSRAMTCON[19]), .Y(n3345) );
  INVX1 U2828 ( .A(BurstRMode), .Y(n3793) );
  INVX1 U2829 ( .A(PSRAMTCON[13]), .Y(n3601) );
  AO21X1 U2830 ( .A0(Hold), .A1(n3458), .B0(hold_cnt1116_0_), .Y(n3452) );
  INVX1 U2831 ( .A(PowerupClr), .Y(n3721) );
  AO22X1 U2832 ( .A0(PSRAMTOUT[0]), .A1(CSb), .B0(n3526), .B1(net340), .Y(
        n2496) );
  AO22X1 U2833 ( .A0(PSRAMTOUT[9]), .A1(CSb), .B0(ToutCnt714_9_), .B1(n3526), 
        .Y(n2487) );
  XNOR2X1 U1_A_9 ( .A(ToutCnt[9]), .B(carry0), .Y(ToutCnt714_9_) );
  AO22X1 U2834 ( .A0(PSRAMTOUT[8]), .A1(CSb), .B0(ToutCnt714_8_), .B1(n3526), 
        .Y(n2488) );
  XNOR2X1 U1_A_8 ( .A(ToutCnt[8]), .B(carry1), .Y(ToutCnt714_8_) );
  AO22X1 U2835 ( .A0(PSRAMTOUT[7]), .A1(CSb), .B0(ToutCnt714_7_), .B1(n3526), 
        .Y(n2489) );
  XNOR2X1 U1_A_7 ( .A(ToutCnt[7]), .B(carry2), .Y(ToutCnt714_7_) );
  AO22X1 U2836 ( .A0(PSRAMTOUT[6]), .A1(CSb), .B0(ToutCnt714_6_), .B1(n3526), 
        .Y(n2490) );
  XNOR2X1 U1_A_6 ( .A(ToutCnt[6]), .B(carry3), .Y(ToutCnt714_6_) );
  AO22X1 U2837 ( .A0(PSRAMTOUT[5]), .A1(CSb), .B0(ToutCnt714_5_), .B1(n3526), 
        .Y(n2491) );
  XNOR2X1 U1_A_5 ( .A(ToutCnt[5]), .B(carry4), .Y(ToutCnt714_5_) );
  AO22X1 U2838 ( .A0(PSRAMTOUT[4]), .A1(CSb), .B0(ToutCnt714_4_), .B1(n3526), 
        .Y(n2492) );
  XNOR2X1 U1_A_4 ( .A(ToutCnt[4]), .B(carry5), .Y(ToutCnt714_4_) );
  AO22X1 U2839 ( .A0(PSRAMTOUT[3]), .A1(CSb), .B0(ToutCnt714_3_), .B1(n3526), 
        .Y(n2493) );
  XNOR2X1 U1_A_3 ( .A(ToutCnt[3]), .B(carry6), .Y(ToutCnt714_3_) );
  AO22X1 U2840 ( .A0(PSRAMTOUT[2]), .A1(CSb), .B0(ToutCnt714_2_), .B1(n3526), 
        .Y(n2494) );
  XNOR2X1 U1_A_2 ( .A(ToutCnt[2]), .B(carry7), .Y(ToutCnt714_2_) );
  AO22X1 U2841 ( .A0(PSRAMTOUT[1]), .A1(CSb), .B0(ToutCnt714_1_), .B1(n3526), 
        .Y(n2495) );
  XNOR2X1 U1_A_1 ( .A(ToutCnt[1]), .B(ToutCnt[0]), .Y(ToutCnt714_1_) );
  AO22X1 U2842 ( .A0(PSRAMRDATA[31]), .A1(n3846), .B0(PSRAMRDATA[15]), .B1(
        n3339), .Y(n2517) );
  AO22X1 U2843 ( .A0(PSRAMRDATA[30]), .A1(n3846), .B0(PSRAMRDATA[14]), .B1(
        n3339), .Y(n2518) );
  AO22X1 U2844 ( .A0(PSRAMRDATA[29]), .A1(n3847), .B0(PSRAMRDATA[13]), .B1(
        n3339), .Y(n2519) );
  AO22X1 U2845 ( .A0(PSRAMRDATA[28]), .A1(n3846), .B0(PSRAMRDATA[12]), .B1(
        n3339), .Y(n2520) );
  AO22X1 U2846 ( .A0(PSRAMRDATA[27]), .A1(n3847), .B0(PSRAMRDATA[11]), .B1(
        n3339), .Y(n2521) );
  AO22X1 U2847 ( .A0(PSRAMRDATA[26]), .A1(n3847), .B0(PSRAMRDATA[10]), .B1(
        n3339), .Y(n2522) );
  AO22X1 U2848 ( .A0(PSRAMRDATA[25]), .A1(n3846), .B0(PSRAMRDATA[9]), .B1(
        n3339), .Y(n2523) );
  AO22X1 U2849 ( .A0(PSRAMRDATA[24]), .A1(n3846), .B0(PSRAMRDATA[8]), .B1(
        n3339), .Y(n2524) );
  AO22X1 U2850 ( .A0(PSRAMRDATA[23]), .A1(n3847), .B0(PSRAMRDATA[7]), .B1(
        n3339), .Y(n2525) );
  AO22X1 U2851 ( .A0(PSRAMRDATA[22]), .A1(n3846), .B0(PSRAMRDATA[6]), .B1(
        n3339), .Y(n2526) );
  AO22X1 U2852 ( .A0(PSRAMRDATA[21]), .A1(n3847), .B0(PSRAMRDATA[5]), .B1(
        n3339), .Y(n2527) );
  AO22X1 U2853 ( .A0(PSRAMRDATA[20]), .A1(n3847), .B0(PSRAMRDATA[4]), .B1(
        n3339), .Y(n2528) );
  AO22X1 U2854 ( .A0(PSRAMRDATA[19]), .A1(n3846), .B0(PSRAMRDATA[3]), .B1(
        n3339), .Y(n2529) );
  AO22X1 U2855 ( .A0(PSRAMRDATA[18]), .A1(n3846), .B0(PSRAMRDATA[2]), .B1(
        n3339), .Y(n2530) );
  AO22X1 U2856 ( .A0(PSRAMRDATA[17]), .A1(n3847), .B0(PSRAMRDATA[1]), .B1(
        n3339), .Y(n2531) );
  AO22X1 U2857 ( .A0(PSRAMRDATA[16]), .A1(n3846), .B0(PSRAMRDATA[0]), .B1(
        n3339), .Y(n2532) );
  NAND3X1 U2858 ( .A(Enable), .B(n3719), .C(n3720), .Y(n3197) );
  NAND2X1 U2859 ( .A(n3721), .B(n3484), .Y(n3720) );
  INVX1 U2860 ( .A(PowerupSet), .Y(n3719) );
  INVX1 U2861 ( .A(PSRAMTCON[12]), .Y(n3651) );
  OAI32X1 U2862 ( .A0(nDATAEN), .A1(hold_cnt_1_), .A2(n3487), .B0(n3458), .B1(
        n3455), .Y(hold_cnt1116_1_) );
  AO21X1 U2863 ( .A0(n3238), .A1(Hold), .B0(n3239), .Y(n2624) );
  NAND4BX1 U2864 ( .AN(n3240), .B(n3241), .C(n3242), .D(n3243), .Y(n3238) );
  XOR2X1 U2865 ( .A(n3458), .B(PSRAMTCON[1]), .Y(n3241) );
  XOR2X1 U2866 ( .A(n3485), .B(PSRAMTCON[3]), .Y(n3242) );
  OAI31X1 U2867 ( .A0(n3450), .A1(hold_cnt_3_), .A2(n3483), .B0(n3451), .Y(
        hold_cnt1116_3_) );
  AOI32X1 U2868 ( .A0(hold_cnt_3_), .A1(n3483), .A2(Hold), .B0(hold_cnt_3_), 
        .B1(n3452), .Y(n3451) );
  INVX1 U2869 ( .A(PSRAMTCON[10]), .Y(n3184) );
  INVX1 U2870 ( .A(PSRAMTCON[11]), .Y(n3186) );
  XOR2X1 U2871 ( .A(n3483), .B(PSRAMTCON[2]), .Y(n3243) );
  NAND3BX1 U2872 ( .AN(n3458), .B(hold_cnt_0_), .C(Hold), .Y(n3450) );
  XOR2X1 U2873 ( .A(hold_cnt_0_), .B(PSRAMTCON[0]), .Y(n3240) );
  AO22X1 U2874 ( .A0(hold_cnt_2_), .A1(n3452), .B0(n3453), .B1(n3483), .Y(
        hold_cnt1116_2_) );
  INVX1 U2875 ( .A(n3450), .Y(n3453) );
  AO22X1 U2876 ( .A0(ZZb), .A1(nextmain_state[1]), .B0(n3156), .B1(n3197), .Y(
        n2627) );
  DFFRX1 ADR_reg_3_ ( .D(n2598), .CK(PCLK), .RN(PRESETn), .Q(ADDR[3]) );
  DFFRX1 ADR_reg_8_ ( .D(n2593), .CK(PCLK), .RN(PRESETn), .Q(ADDR[8]) );
  DFFRX1 ADR_reg_6_ ( .D(n2595), .CK(PCLK), .RN(PRESETn), .Q(ADDR[6]) );
  DFFRX1 ADR_reg_5_ ( .D(n2596), .CK(PCLK), .RN(PRESETn), .Q(ADDR[5]) );
  DFFRX1 ADR_reg_4_ ( .D(n2597), .CK(PCLK), .RN(PRESETn), .Q(ADDR[4]) );
  DFFSX1 rw_state_reg_0_ ( .D(nextrw_state_0_), .CK(PCLK), .SN(PRESETn), .Q(
        rw_state[0]), .QN(n3482) );
  DFFRX1 main_state_reg_0_ ( .D(nextmain_state[0]), .CK(PCLK), .RN(PRESETn), 
        .Q(main_state[0]), .QN(n3532) );
  DFFSX1 ToutCnt_reg_0_ ( .D(n2496), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[0]), 
        .QN(net340) );
  DFFRX1 PreviousAdr_reg_2_ ( .D(n2621), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_2_) );
  DFFRX1 main_state_reg_1_ ( .D(nextmain_state[1]), .CK(PCLK), .RN(PRESETn), 
        .Q(main_state[1]), .QN(n3484) );
  DFFRX1 ADR_reg_13_ ( .D(n2588), .CK(PCLK), .RN(PRESETn), .Q(ADDR[13]) );
  DFFRX1 ADR_reg_12_ ( .D(n2589), .CK(PCLK), .RN(PRESETn), .Q(ADDR[12]) );
  DFFRX1 ADR_reg_11_ ( .D(n2590), .CK(PCLK), .RN(PRESETn), .Q(ADDR[11]) );
  DFFRX1 ADR_reg_10_ ( .D(n2591), .CK(PCLK), .RN(PRESETn), .Q(ADDR[10]) );
  DFFRX1 cycle_cnt_reg_0_ ( .D(n2500), .CK(PCLK), .RN(PRESETn), .Q(
        cycle_cnt_0_), .QN(n3527) );
  DFFRX1 PreviousAdr_reg_11_ ( .D(n2612), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_11_) );
  DFFRX1 PSRAMRDATA_reg_31_ ( .D(n2501), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[31]) );
  DFFRX1 PSRAMRDATA_reg_30_ ( .D(n2502), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[30]) );
  DFFRX1 PSRAMRDATA_reg_29_ ( .D(n2503), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[29]) );
  DFFRX1 PSRAMRDATA_reg_28_ ( .D(n2504), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[28]) );
  DFFRX1 PSRAMRDATA_reg_27_ ( .D(n2505), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[27]) );
  DFFRX1 PSRAMRDATA_reg_26_ ( .D(n2506), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[26]) );
  DFFRX1 PSRAMRDATA_reg_25_ ( .D(n2507), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[25]) );
  DFFRX1 PSRAMRDATA_reg_24_ ( .D(n2508), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[24]) );
  DFFRX1 PSRAMRDATA_reg_23_ ( .D(n2509), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[23]) );
  DFFRX1 PSRAMRDATA_reg_22_ ( .D(n2510), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[22]) );
  DFFRX1 PSRAMRDATA_reg_21_ ( .D(n2511), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[21]) );
  DFFRX1 PSRAMRDATA_reg_20_ ( .D(n2512), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[20]) );
  DFFRX1 PSRAMRDATA_reg_19_ ( .D(n2513), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[19]) );
  DFFRX1 PSRAMRDATA_reg_18_ ( .D(n2514), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[18]) );
  DFFRX1 PSRAMRDATA_reg_17_ ( .D(n2515), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[17]) );
  DFFRX1 PSRAMRDATA_reg_16_ ( .D(n2516), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[16]) );
  DFFRX1 PSRAMRDATA_reg_15_ ( .D(n2517), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[15]) );
  DFFRX1 PSRAMRDATA_reg_14_ ( .D(n2518), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[14]) );
  DFFRX1 PSRAMRDATA_reg_13_ ( .D(n2519), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[13]) );
  DFFRX1 PSRAMRDATA_reg_12_ ( .D(n2520), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[12]) );
  DFFRX1 PSRAMRDATA_reg_11_ ( .D(n2521), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[11]) );
  DFFRX1 PSRAMRDATA_reg_10_ ( .D(n2522), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[10]) );
  DFFRX1 PSRAMRDATA_reg_9_ ( .D(n2523), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[9]) );
  DFFRX1 PSRAMRDATA_reg_8_ ( .D(n2524), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[8]) );
  DFFRX1 PSRAMRDATA_reg_7_ ( .D(n2525), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[7]) );
  DFFRX1 PSRAMRDATA_reg_6_ ( .D(n2526), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[6]) );
  DFFRX1 PSRAMRDATA_reg_5_ ( .D(n2527), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[5]) );
  DFFRX1 PSRAMRDATA_reg_4_ ( .D(n2528), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[4]) );
  DFFRX1 PSRAMRDATA_reg_3_ ( .D(n2529), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[3]) );
  DFFRX1 PSRAMRDATA_reg_2_ ( .D(n2530), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[2]) );
  DFFRX1 PSRAMRDATA_reg_1_ ( .D(n2531), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[1]) );
  DFFRX1 PSRAMRDATA_reg_0_ ( .D(n2532), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[0]) );
  DFFSX1 PREADY_reg ( .D(n2632), .CK(PCLK), .SN(PRESETn), .Q(DataRWAvail), 
        .QN(n2476) );
  DFFSX1 cur_CS_reg ( .D(n2626), .CK(PCLK), .SN(PRESETn), .Q(n3849), .QN(n3480) );
  DFFSX1 ToutCnt_reg_1_ ( .D(n2495), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[1]), 
        .QN(n2477) );
  DFFRX1 PreviousAdr_reg_9_ ( .D(n2614), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_9_) );
  DFFRX1 PreviousAdr_reg_12_ ( .D(n2611), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_12_) );
  DFFRX1 PreviousAdr_reg_10_ ( .D(n2613), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_10_) );
  DFFRX1 PreviousAdr_reg_7_ ( .D(n2616), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_7_) );
  DFFRX1 PreviousAdr_reg_4_ ( .D(n2619), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_4_) );
  DFFRX1 PreviousAdr_reg_6_ ( .D(n2617), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_6_) );
  DFFRX1 PreviousAdr_reg_18_ ( .D(n2605), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_18_) );
  DFFRX1 PreviousAdr_reg_17_ ( .D(n2606), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_17_) );
  DFFRX1 PreviousAdr_reg_16_ ( .D(n2607), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_16_) );
  DFFRX1 PreviousAdr_reg_15_ ( .D(n2608), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_15_) );
  DFFRX1 PreviousAdr_reg_13_ ( .D(n2610), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_13_) );
  DFFRX1 PreviousAdr_reg_5_ ( .D(n2618), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_5_) );
  DFFRX1 PreviousAdr_reg_3_ ( .D(n2620), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_3_), .QN(n3529) );
  DFFRX1 Hold_reg ( .D(n2624), .CK(PCLK), .RN(PRESETn), .Q(Hold), .QN(nDATAEN)
         );
  DFFRX1 hold_cnt_reg_0_ ( .D(hold_cnt1116_0_), .CK(PCLK), .RN(PRESETn), .Q(
        hold_cnt_0_), .QN(n3487) );
  DFFRX1 ADR_reg_18_ ( .D(n2583), .CK(PCLK), .RN(PRESETn), .Q(ADDR[18]) );
  DFFRX1 ADR_reg_17_ ( .D(n2584), .CK(PCLK), .RN(PRESETn), .Q(ADDR[17]) );
  DFFRX1 ADR_reg_16_ ( .D(n2585), .CK(PCLK), .RN(PRESETn), .Q(ADDR[16]) );
  DFFRX1 ADR_reg_15_ ( .D(n2586), .CK(PCLK), .RN(PRESETn), .Q(ADDR[15]) );
  DFFRX1 ADR_reg_14_ ( .D(n2587), .CK(PCLK), .RN(PRESETn), .Q(ADDR[14]) );
  DFFRX1 hold_cnt_reg_1_ ( .D(hold_cnt1116_1_), .CK(PCLK), .RN(PRESETn), .Q(
        hold_cnt_1_), .QN(n3458) );
  DFFSX1 ToutCnt_reg_10_ ( .D(n2486), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[10]), 
        .QN(net329) );
  DFFSX1 ToutCnt_reg_9_ ( .D(n2487), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[9])
         );
  DFFSX1 ToutCnt_reg_8_ ( .D(n2488), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[8]), 
        .QN(n2483) );
  DFFSX1 ToutCnt_reg_7_ ( .D(n2489), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[7]), 
        .QN(n2482) );
  DFFSX1 ToutCnt_reg_6_ ( .D(n2490), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[6]), 
        .QN(n2481) );
  DFFSX1 ToutCnt_reg_5_ ( .D(n2491), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[5]), 
        .QN(n2480) );
  DFFSX1 ToutCnt_reg_4_ ( .D(n2492), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[4]), 
        .QN(n2479) );
  DFFSX1 ToutCnt_reg_3_ ( .D(n2493), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[3]), 
        .QN(net336) );
  DFFSX1 ToutCnt_reg_2_ ( .D(n2494), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[2]), 
        .QN(n2478) );
  DFFRX1 PreviousAdr_reg_21_ ( .D(n2602), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_21_), .QN(net377) );
  DFFRX1 ADR_reg_19_ ( .D(n2582), .CK(PCLK), .RN(PRESETn), .Q(ADDR[19]) );
  DFFSX1 cur_OE_reg ( .D(n2629), .CK(PCLK), .SN(PRESETn), .Q(OEb) );
  DFFRX1 hold_cnt_reg_3_ ( .D(hold_cnt1116_3_), .CK(PCLK), .RN(PRESETn), .Q(
        hold_cnt_3_), .QN(n3485) );
  DFFRX1 hold_cnt_reg_2_ ( .D(hold_cnt1116_2_), .CK(PCLK), .RN(PRESETn), .Q(
        hold_cnt_2_), .QN(n3483) );
  DFFRX1 PSRAMWDATA_reg_31_ ( .D(n2533), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[31]), .QN(n3488) );
  DFFRX1 PSRAMWDATA_reg_30_ ( .D(n2534), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[30]), .QN(n3489) );
  DFFRX1 PSRAMWDATA_reg_29_ ( .D(n2535), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[29]), .QN(n3490) );
  DFFRX1 PSRAMWDATA_reg_28_ ( .D(n2536), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[28]), .QN(n3491) );
  DFFRX1 PSRAMWDATA_reg_27_ ( .D(n2537), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[27]), .QN(n3492) );
  DFFRX1 PSRAMWDATA_reg_26_ ( .D(n2538), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[26]), .QN(n3493) );
  DFFRX1 PSRAMWDATA_reg_25_ ( .D(n2539), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[25]), .QN(n3494) );
  DFFRX1 PSRAMWDATA_reg_24_ ( .D(n2540), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[24]), .QN(n3495) );
  DFFRX1 PSRAMWDATA_reg_23_ ( .D(n2541), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[23]), .QN(n3496) );
  DFFRX1 PSRAMWDATA_reg_22_ ( .D(n2542), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[22]), .QN(n3497) );
  DFFRX1 PSRAMWDATA_reg_21_ ( .D(n2543), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[21]), .QN(n3498) );
  DFFRX1 PSRAMWDATA_reg_20_ ( .D(n2544), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[20]), .QN(n3499) );
  DFFRX1 PSRAMWDATA_reg_19_ ( .D(n2545), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[19]), .QN(n3500) );
  DFFRX1 PSRAMWDATA_reg_18_ ( .D(n2546), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[18]), .QN(n3501) );
  DFFRX1 PSRAMWDATA_reg_17_ ( .D(n2547), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[17]), .QN(n3502) );
  DFFRX1 PSRAMWDATA_reg_16_ ( .D(n2548), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[16]), .QN(n3503) );
  DFFRX1 PSRAMWDATA_reg_15_ ( .D(n2549), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[15]), .QN(n3462) );
  DFFRX1 PSRAMWDATA_reg_14_ ( .D(n2550), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[14]), .QN(n3463) );
  DFFRX1 PSRAMWDATA_reg_13_ ( .D(n2551), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[13]), .QN(n3464) );
  DFFRX1 PSRAMWDATA_reg_12_ ( .D(n2552), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[12]), .QN(n3465) );
  DFFRX1 PSRAMWDATA_reg_11_ ( .D(n2553), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[11]), .QN(n3466) );
  DFFRX1 PSRAMWDATA_reg_10_ ( .D(n2554), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[10]), .QN(n3467) );
  DFFRX1 PSRAMWDATA_reg_9_ ( .D(n2555), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[9]), .QN(n3468) );
  DFFRX1 PSRAMWDATA_reg_8_ ( .D(n2556), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[8]), .QN(n3469) );
  DFFRX1 PSRAMWDATA_reg_7_ ( .D(n2557), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[7]), .QN(n3470) );
  DFFRX1 PSRAMWDATA_reg_6_ ( .D(n2558), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[6]), .QN(n3471) );
  DFFRX1 PSRAMWDATA_reg_5_ ( .D(n2559), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[5]), .QN(n3472) );
  DFFRX1 PSRAMWDATA_reg_4_ ( .D(n2560), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[4]), .QN(n3473) );
  DFFRX1 PSRAMWDATA_reg_3_ ( .D(n2561), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[3]), .QN(n3474) );
  DFFRX1 PSRAMWDATA_reg_2_ ( .D(n2562), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[2]), .QN(n3475) );
  DFFRX1 PSRAMWDATA_reg_1_ ( .D(n2563), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[1]), .QN(n3476) );
  DFFRX1 PSRAMWDATA_reg_0_ ( .D(n2564), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[0]), .QN(n3477) );
  DFFRX1 cur_ZZ_reg ( .D(n2627), .CK(PCLK), .RN(PRESETn), .Q(ZZb) );
  DFFSX1 cur_UB_reg ( .D(n2630), .CK(PCLK), .SN(PRESETn), .Q(UBb), .QN(net350)
         );
  DFFSX1 cur_LB_reg ( .D(n2631), .CK(PCLK), .SN(PRESETn), .Q(LBb), .QN(net351)
         );
  DFFRX1 DATAOUT_reg_15_ ( .D(n2565), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[15]), 
        .QN(n2466) );
  DFFRX1 DATAOUT_reg_14_ ( .D(n2566), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[14]), 
        .QN(n2465) );
  DFFRX1 DATAOUT_reg_13_ ( .D(n2567), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[13]), 
        .QN(n2464) );
  DFFRX1 DATAOUT_reg_12_ ( .D(n2568), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[12]), 
        .QN(n2463) );
  DFFRX1 DATAOUT_reg_11_ ( .D(n2569), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[11]), 
        .QN(n2462) );
  DFFRX1 DATAOUT_reg_10_ ( .D(n2570), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[10]), 
        .QN(n2461) );
  DFFRX1 DATAOUT_reg_9_ ( .D(n2571), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[9]), 
        .QN(n2475) );
  DFFRX1 DATAOUT_reg_8_ ( .D(n2572), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[8]), 
        .QN(n2474) );
  DFFRX1 DATAOUT_reg_7_ ( .D(n2573), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[7]), 
        .QN(n2473) );
  DFFRX1 DATAOUT_reg_6_ ( .D(n2574), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[6]), 
        .QN(n2472) );
  DFFRX1 DATAOUT_reg_5_ ( .D(n2575), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[5]), 
        .QN(n2471) );
  DFFRX1 DATAOUT_reg_4_ ( .D(n2576), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[4]), 
        .QN(n2470) );
  DFFRX1 DATAOUT_reg_3_ ( .D(n2577), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[3]), 
        .QN(n2469) );
  DFFRX1 DATAOUT_reg_2_ ( .D(n2578), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[2]), 
        .QN(n2468) );
  DFFRX1 DATAOUT_reg_1_ ( .D(n2579), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[1]), 
        .QN(n2467) );
  DFFRX1 DATAOUT_reg_0_ ( .D(n2580), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[0]), 
        .QN(n2460) );
  MXI2X8 U2877 ( .S0(PageSize[2]), .B(n3750), .A(n3749), .Y(n3588) );
  OAI21X4 U2878 ( .A0(n3753), .A1(n3754), .B0(n3755), .Y(n3749) );
  DFFRX1 PreviousAdr_reg_19_ ( .D(n2604), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_19_) );
  AO22X1 U2879 ( .A0(PADDR[19]), .A1(n3535), .B0(n3206), .B1(PreviousAdr_19_), 
        .Y(n2604) );
  AO22X1 U2880 ( .A0(PADDR[3]), .A1(n3252), .B0(n3206), .B1(PreviousAdr_3_), 
        .Y(n2620) );
  DFFRX1 rw_state_reg_1_ ( .D(nextrw_state_1_), .CK(PCLK), .RN(PRESETn), .Q(
        rw_state[1]), .QN(n3479) );
  DFFRX1 PreviousAdr_reg_14_ ( .D(n2609), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_14_) );
  AO22X1 U2881 ( .A0(PADDR[20]), .A1(n3535), .B0(n3206), .B1(PreviousAdr_20_), 
        .Y(n2603) );
  DFFRX1 PreviousAdr_reg_8_ ( .D(n2615), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_8_) );
  AO22X1 U2882 ( .A0(PADDR[1]), .A1(n3535), .B0(n3206), .B1(PreviousAdr_1_), 
        .Y(n2622) );
  AO22X1 U2883 ( .A0(PADDR[11]), .A1(n3535), .B0(n3206), .B1(PreviousAdr_11_), 
        .Y(n2612) );
  DFFRX1 PreviousAdr_reg_20_ ( .D(n2603), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_20_) );
  DFFRX1 cycle_cntEn_reg ( .D(n2625), .CK(PCLK), .RN(PRESETn), .Q(cycle_cntEn), 
        .QN(n3460) );
  DFFRX1 PreviousAdr_reg_1_ ( .D(n2622), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_1_), .QN(n3481) );
  DFFRX1 rw_state_reg_2_ ( .D(n3108), .CK(PCLK), .RN(PRESETn), .Q(rw_state[2])
         );
  DFFRX1 rw_state_reg_3_ ( .D(n3845), .CK(PCLK), .RN(PRESETn), .Q(rw_state[3])
         );
endmodule


module pmcon_MEMIF_ADDRESSWIDTH22 ( PCLK, PRESETn, PSEL, PENABLE, PREADY, 
        PWRITE, PADDR, PWDATA, PRDATA, DataRWAvail, Read, Write, PSRAMRDATA );
  input [21:0] PADDR;
  input [31:0] PWDATA;
  output [31:0] PRDATA;
  input [31:0] PSRAMRDATA;
  input PCLK, PRESETn, PSEL, PENABLE, PWRITE, DataRWAvail;
  output PREADY, Read, Write;
  wire   DataRWAvail0, \PSRAMRDATA0[31] , \PSRAMRDATA0[30] , \PSRAMRDATA0[29] ,
         \PSRAMRDATA0[28] , \PSRAMRDATA0[27] , \PSRAMRDATA0[26] ,
         \PSRAMRDATA0[25] , \PSRAMRDATA0[24] , \PSRAMRDATA0[23] ,
         \PSRAMRDATA0[22] , \PSRAMRDATA0[21] , \PSRAMRDATA0[20] ,
         \PSRAMRDATA0[19] , \PSRAMRDATA0[18] , \PSRAMRDATA0[17] ,
         \PSRAMRDATA0[16] , \PSRAMRDATA0[15] , \PSRAMRDATA0[14] ,
         \PSRAMRDATA0[13] , \PSRAMRDATA0[12] , \PSRAMRDATA0[11] ,
         \PSRAMRDATA0[10] , \PSRAMRDATA0[9] , \PSRAMRDATA0[8] ,
         \PSRAMRDATA0[7] , \PSRAMRDATA0[6] , \PSRAMRDATA0[5] ,
         \PSRAMRDATA0[4] , \PSRAMRDATA0[3] , \PSRAMRDATA0[2] ,
         \PSRAMRDATA0[1] , \PSRAMRDATA0[0] , n73, n74, n75, n76;
  assign PREADY = DataRWAvail0;
  assign DataRWAvail0 = DataRWAvail;
  assign PRDATA[31] = \PSRAMRDATA0[31] ;
  assign \PSRAMRDATA0[31]  = PSRAMRDATA[31];
  assign PRDATA[30] = \PSRAMRDATA0[30] ;
  assign \PSRAMRDATA0[30]  = PSRAMRDATA[30];
  assign PRDATA[29] = \PSRAMRDATA0[29] ;
  assign \PSRAMRDATA0[29]  = PSRAMRDATA[29];
  assign PRDATA[28] = \PSRAMRDATA0[28] ;
  assign \PSRAMRDATA0[28]  = PSRAMRDATA[28];
  assign PRDATA[27] = \PSRAMRDATA0[27] ;
  assign \PSRAMRDATA0[27]  = PSRAMRDATA[27];
  assign PRDATA[26] = \PSRAMRDATA0[26] ;
  assign \PSRAMRDATA0[26]  = PSRAMRDATA[26];
  assign PRDATA[25] = \PSRAMRDATA0[25] ;
  assign \PSRAMRDATA0[25]  = PSRAMRDATA[25];
  assign PRDATA[24] = \PSRAMRDATA0[24] ;
  assign \PSRAMRDATA0[24]  = PSRAMRDATA[24];
  assign PRDATA[23] = \PSRAMRDATA0[23] ;
  assign \PSRAMRDATA0[23]  = PSRAMRDATA[23];
  assign PRDATA[22] = \PSRAMRDATA0[22] ;
  assign \PSRAMRDATA0[22]  = PSRAMRDATA[22];
  assign PRDATA[21] = \PSRAMRDATA0[21] ;
  assign \PSRAMRDATA0[21]  = PSRAMRDATA[21];
  assign PRDATA[20] = \PSRAMRDATA0[20] ;
  assign \PSRAMRDATA0[20]  = PSRAMRDATA[20];
  assign PRDATA[19] = \PSRAMRDATA0[19] ;
  assign \PSRAMRDATA0[19]  = PSRAMRDATA[19];
  assign PRDATA[18] = \PSRAMRDATA0[18] ;
  assign \PSRAMRDATA0[18]  = PSRAMRDATA[18];
  assign PRDATA[17] = \PSRAMRDATA0[17] ;
  assign \PSRAMRDATA0[17]  = PSRAMRDATA[17];
  assign PRDATA[16] = \PSRAMRDATA0[16] ;
  assign \PSRAMRDATA0[16]  = PSRAMRDATA[16];
  assign PRDATA[15] = \PSRAMRDATA0[15] ;
  assign \PSRAMRDATA0[15]  = PSRAMRDATA[15];
  assign PRDATA[14] = \PSRAMRDATA0[14] ;
  assign \PSRAMRDATA0[14]  = PSRAMRDATA[14];
  assign PRDATA[13] = \PSRAMRDATA0[13] ;
  assign \PSRAMRDATA0[13]  = PSRAMRDATA[13];
  assign PRDATA[12] = \PSRAMRDATA0[12] ;
  assign \PSRAMRDATA0[12]  = PSRAMRDATA[12];
  assign PRDATA[11] = \PSRAMRDATA0[11] ;
  assign \PSRAMRDATA0[11]  = PSRAMRDATA[11];
  assign PRDATA[10] = \PSRAMRDATA0[10] ;
  assign \PSRAMRDATA0[10]  = PSRAMRDATA[10];
  assign PRDATA[9] = \PSRAMRDATA0[9] ;
  assign \PSRAMRDATA0[9]  = PSRAMRDATA[9];
  assign PRDATA[8] = \PSRAMRDATA0[8] ;
  assign \PSRAMRDATA0[8]  = PSRAMRDATA[8];
  assign PRDATA[7] = \PSRAMRDATA0[7] ;
  assign \PSRAMRDATA0[7]  = PSRAMRDATA[7];
  assign PRDATA[6] = \PSRAMRDATA0[6] ;
  assign \PSRAMRDATA0[6]  = PSRAMRDATA[6];
  assign PRDATA[5] = \PSRAMRDATA0[5] ;
  assign \PSRAMRDATA0[5]  = PSRAMRDATA[5];
  assign PRDATA[4] = \PSRAMRDATA0[4] ;
  assign \PSRAMRDATA0[4]  = PSRAMRDATA[4];
  assign PRDATA[3] = \PSRAMRDATA0[3] ;
  assign \PSRAMRDATA0[3]  = PSRAMRDATA[3];
  assign PRDATA[2] = \PSRAMRDATA0[2] ;
  assign \PSRAMRDATA0[2]  = PSRAMRDATA[2];
  assign PRDATA[1] = \PSRAMRDATA0[1] ;
  assign \PSRAMRDATA0[1]  = PSRAMRDATA[1];
  assign PRDATA[0] = \PSRAMRDATA0[0] ;
  assign \PSRAMRDATA0[0]  = PSRAMRDATA[0];

  NOR3X2 U17 ( .A(n76), .B(PWRITE), .C(PENABLE), .Y(Read) );
  BUFX6 U18 ( .A(n74), .Y(Write) );
  OR2X2 U19 ( .A(PENABLE), .B(n76), .Y(n73) );
  INVX3 U20 ( .A(PSEL), .Y(n76) );
  NOR2X2 U21 ( .A(n73), .B(n75), .Y(n74) );
  INVX1 U22 ( .A(PWRITE), .Y(n75) );
endmodule


module pmcon_REGIF ( PCLK, PRESETn, PSEL, PENABLE, PWRITE, PADDR, PWDATA, 
        PRDATA, Enable, PowerupSet, PowerupClr, PageSize, BurstRMode, NegCatch, 
        PSRAMTCON, PSRAMTOUT );
  input [5:0] PADDR;
  input [31:0] PWDATA;
  output [31:0] PRDATA;
  output [2:0] PageSize;
  output [31:0] PSRAMTCON;
  output [10:0] PSRAMTOUT;
  input PCLK, PRESETn, PSEL, PENABLE, PWRITE;
  output Enable, PowerupSet, PowerupClr, BurstRMode, NegCatch;
  wire   nextPowerupSet, nextPowerupClr, n594, n595, n596, n597, n598, n599,
         n600, n601, n602, n603, n604, n605, n606, n607, n608, n609, n610,
         n611, n612, n613, n614, n615, n616, n617, n618, n619, n620, n621,
         n622, n623, n624, n625, n626, n627, n628, n629, n630, n631, n632,
         n633, n634, n635, n636, n637, n638, n639, n640, n641, n642, n649,
         n651, n652, n653, n655, n656, n657, n661, n662, n664, n666, n668,
         n684, n685, n686, n688, n689, n690, n691, n692, n693, n694, n695,
         n696, n697, n698, n699, n700, n701, n702, n703, n704, n705, n706,
         n707, n708, n709, n710, n711, n712, n713, n714;
  wire   [31:0] NextPRDATA;

  NOR4X1 U506 ( .A(PADDR[5]), .B(PADDR[4]), .C(PADDR[3]), .D(n688), .Y(n701)
         );
  DFFRX1 PRDATA_reg_0_ ( .D(NextPRDATA[0]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[0]) );
  DFFRX1 PRDATA_reg_1_ ( .D(NextPRDATA[1]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[1]) );
  DFFRX1 PRDATA_reg_2_ ( .D(NextPRDATA[2]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[2]) );
  DFFRX1 PRDATA_reg_3_ ( .D(NextPRDATA[3]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[3]) );
  DFFRX1 PRDATA_reg_4_ ( .D(NextPRDATA[4]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[4]) );
  DFFRX1 PRDATA_reg_5_ ( .D(NextPRDATA[5]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[5]) );
  DFFRX1 PRDATA_reg_6_ ( .D(NextPRDATA[6]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[6]) );
  DFFRX1 PRDATA_reg_7_ ( .D(NextPRDATA[7]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[7]) );
  DFFRX1 PRDATA_reg_8_ ( .D(NextPRDATA[8]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[8]) );
  DFFRX1 PRDATA_reg_9_ ( .D(NextPRDATA[9]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[9]) );
  DFFRX1 PRDATA_reg_10_ ( .D(NextPRDATA[10]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[10]) );
  DFFRX1 PRDATA_reg_11_ ( .D(NextPRDATA[11]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[11]) );
  DFFRX1 PRDATA_reg_12_ ( .D(NextPRDATA[12]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[12]) );
  DFFRX1 PRDATA_reg_13_ ( .D(NextPRDATA[13]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[13]) );
  DFFRX1 PRDATA_reg_14_ ( .D(NextPRDATA[14]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[14]) );
  DFFRX1 PRDATA_reg_15_ ( .D(NextPRDATA[15]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[15]) );
  DFFRX1 PRDATA_reg_16_ ( .D(NextPRDATA[16]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[16]) );
  DFFRX1 PRDATA_reg_17_ ( .D(NextPRDATA[17]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[17]) );
  DFFRX1 PRDATA_reg_18_ ( .D(NextPRDATA[18]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[18]) );
  DFFRX1 PRDATA_reg_19_ ( .D(NextPRDATA[19]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[19]) );
  DFFRX1 PRDATA_reg_20_ ( .D(NextPRDATA[20]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[20]) );
  DFFRX1 PRDATA_reg_21_ ( .D(NextPRDATA[21]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[21]) );
  DFFRX1 PRDATA_reg_22_ ( .D(NextPRDATA[22]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[22]) );
  DFFRX1 PRDATA_reg_23_ ( .D(NextPRDATA[23]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[23]) );
  DFFRX1 PRDATA_reg_24_ ( .D(NextPRDATA[24]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[24]) );
  DFFRX1 PRDATA_reg_25_ ( .D(NextPRDATA[25]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[25]) );
  DFFRX1 PRDATA_reg_26_ ( .D(NextPRDATA[26]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[26]) );
  DFFRX1 PRDATA_reg_27_ ( .D(NextPRDATA[27]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[27]) );
  DFFRX1 PRDATA_reg_28_ ( .D(NextPRDATA[28]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[28]) );
  DFFRX1 PRDATA_reg_29_ ( .D(NextPRDATA[29]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[29]) );
  DFFRX1 PRDATA_reg_30_ ( .D(NextPRDATA[30]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[30]) );
  DFFRX1 PRDATA_reg_31_ ( .D(NextPRDATA[31]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[31]) );
  INVX1 U507 ( .A(n655), .Y(n656) );
  INVX1 U508 ( .A(n652), .Y(n653) );
  INVX1 U509 ( .A(n711), .Y(n662) );
  INVX1 U510 ( .A(n649), .Y(n651) );
  INVX1 U511 ( .A(n664), .Y(n661) );
  DFFRX1 Enable_reg ( .D(n640), .CK(PCLK), .RN(PRESETn), .Q(Enable), .QN(n690)
         );
  DFFRX1 PageSize_reg_1_ ( .D(n595), .CK(PCLK), .RN(PRESETn), .Q(PageSize[1]), 
        .QN(n691) );
  DFFRX1 PageSize_reg_0_ ( .D(n596), .CK(PCLK), .RN(PRESETn), .Q(PageSize[0]), 
        .QN(n692) );
  DFFRX1 BurstRMode_reg ( .D(n641), .CK(PCLK), .RN(PRESETn), .Q(BurstRMode), 
        .QN(n693) );
  DFFRX1 PageSize_reg_2_ ( .D(n594), .CK(PCLK), .RN(PRESETn), .Q(PageSize[2]), 
        .QN(n689) );
  NAND3BX1 U512 ( .AN(PADDR[1]), .B(PADDR[0]), .C(n684), .Y(n711) );
  NAND3BX1 U513 ( .AN(PADDR[0]), .B(PADDR[1]), .C(n708), .Y(n652) );
  NAND3BX1 U514 ( .AN(PADDR[1]), .B(PADDR[0]), .C(n708), .Y(n714) );
  NAND3BX1 U515 ( .AN(PADDR[1]), .B(PADDR[0]), .C(n708), .Y(n713) );
  NAND3BX1 U516 ( .AN(PADDR[1]), .B(PADDR[0]), .C(n708), .Y(n655) );
  NAND3BX1 U517 ( .AN(PADDR[1]), .B(n657), .C(n708), .Y(n649) );
  NAND3BX1 U518 ( .AN(PADDR[0]), .B(PADDR[1]), .C(n684), .Y(n664) );
  NAND2BX1 U519 ( .AN(PADDR[2]), .B(PSEL), .Y(n688) );
  NAND3BX1 U520 ( .AN(PADDR[1]), .B(n657), .C(n684), .Y(n666) );
  NOR2BX1 U521 ( .AN(PSRAMTCON[13]), .B(n711), .Y(NextPRDATA[13]) );
  NOR2BX1 U522 ( .AN(PSRAMTCON[16]), .B(n711), .Y(NextPRDATA[16]) );
  NOR2BX1 U523 ( .AN(PSRAMTCON[19]), .B(n711), .Y(NextPRDATA[19]) );
  NOR2BX1 U524 ( .AN(PSRAMTCON[22]), .B(n711), .Y(NextPRDATA[22]) );
  NOR2BX1 U525 ( .AN(PSRAMTCON[25]), .B(n711), .Y(NextPRDATA[25]) );
  AND3X2 U526 ( .A(PWRITE), .B(PENABLE), .C(n701), .Y(n708) );
  NOR2X1 U527 ( .A(PWDATA[1]), .B(n649), .Y(nextPowerupClr) );
  NOR2BX1 U528 ( .AN(PWDATA[1]), .B(n649), .Y(nextPowerupSet) );
  INVX1 U529 ( .A(n685), .Y(n684) );
  NAND3BX1 U530 ( .AN(PWRITE), .B(n686), .C(n701), .Y(n685) );
  INVX1 U531 ( .A(PENABLE), .Y(n686) );
  BUFX2 U532 ( .A(n712), .Y(n709) );
  NAND3BX1 U533 ( .AN(PADDR[1]), .B(PADDR[0]), .C(n684), .Y(n712) );
  BUFX2 U534 ( .A(n668), .Y(n710) );
  NAND3BX1 U535 ( .AN(PADDR[1]), .B(PADDR[0]), .C(n684), .Y(n668) );
  AO22X1 U536 ( .A0(PSRAMTCON[13]), .A1(n714), .B0(PWDATA[13]), .B1(n656), .Y(
        n615) );
  AO22X1 U537 ( .A0(PSRAMTCON[12]), .A1(n713), .B0(PWDATA[12]), .B1(n656), .Y(
        n616) );
  AO22X1 U538 ( .A0(PSRAMTCON[31]), .A1(n714), .B0(PWDATA[31]), .B1(n656), .Y(
        n597) );
  AO22X1 U539 ( .A0(PSRAMTCON[30]), .A1(n713), .B0(PWDATA[30]), .B1(n656), .Y(
        n598) );
  AO22X1 U540 ( .A0(PSRAMTCON[29]), .A1(n655), .B0(PWDATA[29]), .B1(n656), .Y(
        n599) );
  AO22X1 U541 ( .A0(PSRAMTCON[28]), .A1(n714), .B0(PWDATA[28]), .B1(n656), .Y(
        n600) );
  AO22X1 U542 ( .A0(PSRAMTCON[27]), .A1(n713), .B0(PWDATA[27]), .B1(n656), .Y(
        n601) );
  AO22X1 U543 ( .A0(PSRAMTCON[26]), .A1(n655), .B0(PWDATA[26]), .B1(n656), .Y(
        n602) );
  AO22X1 U544 ( .A0(PSRAMTCON[25]), .A1(n714), .B0(PWDATA[25]), .B1(n656), .Y(
        n603) );
  AO22X1 U545 ( .A0(PSRAMTCON[24]), .A1(n713), .B0(PWDATA[24]), .B1(n656), .Y(
        n604) );
  AO22X1 U546 ( .A0(PSRAMTCON[23]), .A1(n655), .B0(PWDATA[23]), .B1(n656), .Y(
        n605) );
  AO22X1 U547 ( .A0(PSRAMTCON[22]), .A1(n714), .B0(PWDATA[22]), .B1(n656), .Y(
        n606) );
  AO22X1 U548 ( .A0(PSRAMTCON[21]), .A1(n713), .B0(PWDATA[21]), .B1(n656), .Y(
        n607) );
  AO22X1 U549 ( .A0(PSRAMTCON[20]), .A1(n655), .B0(PWDATA[20]), .B1(n656), .Y(
        n608) );
  AO22X1 U550 ( .A0(PSRAMTCON[19]), .A1(n714), .B0(PWDATA[19]), .B1(n656), .Y(
        n609) );
  AO22X1 U551 ( .A0(PSRAMTCON[18]), .A1(n713), .B0(PWDATA[18]), .B1(n656), .Y(
        n610) );
  AO22X1 U552 ( .A0(PSRAMTCON[17]), .A1(n714), .B0(PWDATA[17]), .B1(n656), .Y(
        n611) );
  AO22X1 U553 ( .A0(PSRAMTCON[16]), .A1(n714), .B0(PWDATA[16]), .B1(n656), .Y(
        n612) );
  AO22X1 U554 ( .A0(PSRAMTCON[15]), .A1(n713), .B0(PWDATA[15]), .B1(n656), .Y(
        n613) );
  AO22X1 U555 ( .A0(PSRAMTCON[14]), .A1(n713), .B0(PWDATA[14]), .B1(n656), .Y(
        n614) );
  AO22X1 U556 ( .A0(PSRAMTCON[11]), .A1(n714), .B0(PWDATA[11]), .B1(n656), .Y(
        n617) );
  AO22X1 U557 ( .A0(PSRAMTOUT[10]), .A1(n652), .B0(PWDATA[10]), .B1(n653), .Y(
        n629) );
  AO22X1 U558 ( .A0(PSRAMTOUT[9]), .A1(n652), .B0(PWDATA[9]), .B1(n653), .Y(
        n630) );
  AO22X1 U559 ( .A0(PSRAMTOUT[8]), .A1(n652), .B0(PWDATA[8]), .B1(n653), .Y(
        n631) );
  AO22X1 U560 ( .A0(PSRAMTOUT[7]), .A1(n652), .B0(PWDATA[7]), .B1(n653), .Y(
        n632) );
  AO22X1 U561 ( .A0(PSRAMTOUT[5]), .A1(n652), .B0(PWDATA[5]), .B1(n653), .Y(
        n634) );
  AO22X1 U562 ( .A0(PSRAMTOUT[4]), .A1(n652), .B0(PWDATA[4]), .B1(n653), .Y(
        n635) );
  AO22X1 U563 ( .A0(PSRAMTOUT[3]), .A1(n652), .B0(PWDATA[3]), .B1(n653), .Y(
        n636) );
  AO22X1 U564 ( .A0(PageSize[0]), .A1(n649), .B0(PWDATA[3]), .B1(n651), .Y(
        n596) );
  AO22X1 U565 ( .A0(PageSize[2]), .A1(n649), .B0(PWDATA[5]), .B1(n651), .Y(
        n594) );
  AO22X1 U566 ( .A0(PageSize[1]), .A1(n649), .B0(PWDATA[4]), .B1(n651), .Y(
        n595) );
  AO22X1 U567 ( .A0(Enable), .A1(n649), .B0(PWDATA[0]), .B1(n651), .Y(n640) );
  AO22X1 U568 ( .A0(BurstRMode), .A1(n649), .B0(PWDATA[2]), .B1(n651), .Y(n641) );
  AO22X1 U569 ( .A0(NegCatch), .A1(n649), .B0(PWDATA[6]), .B1(n651), .Y(n642)
         );
  AO22X1 U570 ( .A0(PSRAMTCON[10]), .A1(n714), .B0(n656), .B1(PWDATA[10]), .Y(
        n618) );
  AO22X1 U571 ( .A0(PSRAMTCON[9]), .A1(n713), .B0(n656), .B1(PWDATA[9]), .Y(
        n619) );
  AO22X1 U572 ( .A0(PSRAMTCON[8]), .A1(n713), .B0(n656), .B1(PWDATA[8]), .Y(
        n620) );
  AO22X1 U573 ( .A0(PSRAMTCON[7]), .A1(n714), .B0(n656), .B1(PWDATA[7]), .Y(
        n621) );
  AO22X1 U574 ( .A0(PSRAMTCON[6]), .A1(n713), .B0(n656), .B1(PWDATA[6]), .Y(
        n622) );
  AO22X1 U575 ( .A0(PSRAMTCON[5]), .A1(n714), .B0(n656), .B1(PWDATA[5]), .Y(
        n623) );
  AO22X1 U576 ( .A0(PSRAMTCON[4]), .A1(n714), .B0(n656), .B1(PWDATA[4]), .Y(
        n624) );
  AO22X1 U577 ( .A0(PSRAMTCON[3]), .A1(n713), .B0(n656), .B1(PWDATA[3]), .Y(
        n625) );
  AO22X1 U578 ( .A0(PSRAMTCON[2]), .A1(n713), .B0(n656), .B1(PWDATA[2]), .Y(
        n626) );
  AO22X1 U579 ( .A0(PSRAMTCON[1]), .A1(n714), .B0(n656), .B1(PWDATA[1]), .Y(
        n627) );
  AO22X1 U580 ( .A0(PSRAMTCON[0]), .A1(n713), .B0(n656), .B1(PWDATA[0]), .Y(
        n628) );
  AO22X1 U581 ( .A0(PSRAMTOUT[6]), .A1(n652), .B0(n653), .B1(PWDATA[6]), .Y(
        n633) );
  AO22X1 U582 ( .A0(PSRAMTOUT[2]), .A1(n652), .B0(n653), .B1(PWDATA[2]), .Y(
        n637) );
  AO22X1 U583 ( .A0(PSRAMTOUT[1]), .A1(n652), .B0(n653), .B1(PWDATA[1]), .Y(
        n638) );
  AO22X1 U584 ( .A0(PSRAMTOUT[0]), .A1(n652), .B0(n653), .B1(PWDATA[0]), .Y(
        n639) );
  NOR2BX1 U585 ( .AN(PSRAMTCON[12]), .B(n709), .Y(NextPRDATA[12]) );
  NOR2BX1 U586 ( .AN(PSRAMTCON[11]), .B(n710), .Y(NextPRDATA[11]) );
  NOR2BX1 U587 ( .AN(PSRAMTCON[14]), .B(n710), .Y(NextPRDATA[14]) );
  NOR2BX1 U588 ( .AN(PSRAMTCON[15]), .B(n709), .Y(NextPRDATA[15]) );
  NOR2BX1 U589 ( .AN(PSRAMTCON[17]), .B(n710), .Y(NextPRDATA[17]) );
  NOR2BX1 U590 ( .AN(PSRAMTCON[18]), .B(n709), .Y(NextPRDATA[18]) );
  NOR2BX1 U591 ( .AN(PSRAMTCON[20]), .B(n710), .Y(NextPRDATA[20]) );
  NOR2BX1 U592 ( .AN(PSRAMTCON[21]), .B(n709), .Y(NextPRDATA[21]) );
  NOR2BX1 U593 ( .AN(PSRAMTCON[23]), .B(n710), .Y(NextPRDATA[23]) );
  NOR2BX1 U594 ( .AN(PSRAMTCON[24]), .B(n709), .Y(NextPRDATA[24]) );
  NOR2BX1 U595 ( .AN(PSRAMTCON[26]), .B(n710), .Y(NextPRDATA[26]) );
  NOR2BX1 U596 ( .AN(PSRAMTCON[27]), .B(n709), .Y(NextPRDATA[27]) );
  NOR2BX1 U597 ( .AN(PSRAMTCON[28]), .B(n710), .Y(NextPRDATA[28]) );
  NOR2BX1 U598 ( .AN(PSRAMTCON[29]), .B(n710), .Y(NextPRDATA[29]) );
  NOR2BX1 U599 ( .AN(PSRAMTCON[30]), .B(n709), .Y(NextPRDATA[30]) );
  NOR2BX1 U600 ( .AN(PSRAMTCON[31]), .B(n709), .Y(NextPRDATA[31]) );
  OAI222X1 U601 ( .A0(n702), .A1(n664), .B0(n700), .B1(n666), .C0(n694), .C1(
        n709), .Y(NextPRDATA[6]) );
  OAI222X1 U602 ( .A0(n703), .A1(n664), .B0(n690), .B1(n666), .C0(n695), .C1(
        n710), .Y(NextPRDATA[0]) );
  OAI222X1 U603 ( .A0(n704), .A1(n664), .B0(n693), .B1(n666), .C0(n696), .C1(
        n709), .Y(NextPRDATA[2]) );
  OAI222X1 U604 ( .A0(n705), .A1(n664), .B0(n692), .B1(n666), .C0(n697), .C1(
        n710), .Y(NextPRDATA[3]) );
  OAI222X1 U605 ( .A0(n706), .A1(n664), .B0(n691), .B1(n666), .C0(n698), .C1(
        n709), .Y(NextPRDATA[4]) );
  OAI222X1 U606 ( .A0(n707), .A1(n664), .B0(n689), .B1(n666), .C0(n699), .C1(
        n711), .Y(NextPRDATA[5]) );
  AO22X1 U607 ( .A0(n661), .A1(PSRAMTOUT[9]), .B0(n662), .B1(PSRAMTCON[9]), 
        .Y(NextPRDATA[9]) );
  AO22X1 U608 ( .A0(n661), .A1(PSRAMTOUT[1]), .B0(n662), .B1(PSRAMTCON[1]), 
        .Y(NextPRDATA[1]) );
  AO22X1 U609 ( .A0(n661), .A1(PSRAMTOUT[7]), .B0(n662), .B1(PSRAMTCON[7]), 
        .Y(NextPRDATA[7]) );
  AO22X1 U610 ( .A0(n661), .A1(PSRAMTOUT[8]), .B0(n662), .B1(PSRAMTCON[8]), 
        .Y(NextPRDATA[8]) );
  AO22X1 U611 ( .A0(n661), .A1(PSRAMTOUT[10]), .B0(n662), .B1(PSRAMTCON[10]), 
        .Y(NextPRDATA[10]) );
  INVX1 U612 ( .A(PADDR[0]), .Y(n657) );
  DFFSX1 PSRAMTCON_reg_8_ ( .D(n620), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[8]) );
  DFFSX1 PSRAMTCON_reg_17_ ( .D(n611), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[17]) );
  DFFSX1 PSRAMTCON_reg_16_ ( .D(n612), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[16]) );
  DFFSX1 PSRAMTCON_reg_15_ ( .D(n613), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[15]) );
  DFFSX1 PSRAMTCON_reg_14_ ( .D(n614), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[14]) );
  DFFSX1 PSRAMTCON_reg_31_ ( .D(n597), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[31]) );
  DFFSX1 PSRAMTCON_reg_30_ ( .D(n598), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[30]) );
  DFFSX1 PSRAMTCON_reg_29_ ( .D(n599), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[29]) );
  DFFSX1 PSRAMTCON_reg_28_ ( .D(n600), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[28]) );
  DFFSX1 PSRAMTCON_reg_23_ ( .D(n605), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[23]) );
  DFFSX1 PSRAMTCON_reg_22_ ( .D(n606), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[22]) );
  DFFSX1 PSRAMTCON_reg_21_ ( .D(n607), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[21]) );
  DFFSX1 PSRAMTCON_reg_9_ ( .D(n619), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[9]) );
  DFFRX1 PowerupSet_reg ( .D(nextPowerupSet), .CK(PCLK), .RN(PRESETn), .Q(
        PowerupSet) );
  DFFSX1 PSRAMTCON_reg_12_ ( .D(n616), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[12]) );
  DFFSX1 PSRAMTCON_reg_6_ ( .D(n622), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[6]), .QN(n694) );
  DFFSX1 PSRAMTCON_reg_5_ ( .D(n623), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[5]), .QN(n699) );
  DFFSX1 PSRAMTCON_reg_4_ ( .D(n624), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[4]), .QN(n698) );
  DFFSX1 PSRAMTCON_reg_13_ ( .D(n615), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[13]) );
  DFFSX1 PSRAMTCON_reg_10_ ( .D(n618), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[10]) );
  DFFSX1 PSRAMTCON_reg_11_ ( .D(n617), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[11]) );
  DFFRX1 PowerupClr_reg ( .D(nextPowerupClr), .CK(PCLK), .RN(PRESETn), .Q(
        PowerupClr) );
  DFFSX1 PSRAMTCON_reg_7_ ( .D(n621), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[7]) );
  DFFSX1 PSRAMTCON_reg_27_ ( .D(n601), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[27]) );
  DFFSX1 PSRAMTCON_reg_26_ ( .D(n602), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[26]) );
  DFFSX1 PSRAMTCON_reg_25_ ( .D(n603), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[25]) );
  DFFSX1 PSRAMTCON_reg_24_ ( .D(n604), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[24]) );
  DFFSX1 PSRAMTCON_reg_20_ ( .D(n608), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[20]) );
  DFFSX1 PSRAMTCON_reg_19_ ( .D(n609), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[19]) );
  DFFSX1 PSRAMTCON_reg_18_ ( .D(n610), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[18]) );
  DFFSX1 PSRAMTCON_reg_3_ ( .D(n625), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[3]), .QN(n697) );
  DFFSX1 PSRAMTCON_reg_2_ ( .D(n626), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[2]), .QN(n696) );
  DFFSX1 PSRAMTCON_reg_0_ ( .D(n628), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[0]), .QN(n695) );
  DFFSX1 PSRAMTOUT_reg_6_ ( .D(n633), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[6]), .QN(n702) );
  DFFSX1 PSRAMTOUT_reg_5_ ( .D(n634), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[5]), .QN(n707) );
  DFFSX1 PSRAMTOUT_reg_4_ ( .D(n635), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[4]), .QN(n706) );
  DFFSX1 PSRAMTOUT_reg_3_ ( .D(n636), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[3]), .QN(n705) );
  DFFSX1 PSRAMTOUT_reg_2_ ( .D(n637), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[2]), .QN(n704) );
  DFFSX1 PSRAMTOUT_reg_0_ ( .D(n639), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[0]), .QN(n703) );
  DFFSX1 PSRAMTCON_reg_1_ ( .D(n627), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[1]) );
  DFFSX1 PSRAMTOUT_reg_10_ ( .D(n629), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTOUT[10]) );
  DFFSX1 PSRAMTOUT_reg_9_ ( .D(n630), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[9]) );
  DFFSX1 PSRAMTOUT_reg_8_ ( .D(n631), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[8]) );
  DFFSX1 PSRAMTOUT_reg_7_ ( .D(n632), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[7]) );
  DFFSX1 PSRAMTOUT_reg_1_ ( .D(n638), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[1]) );
  DFFRX1 NegCatch_reg ( .D(n642), .CK(PCLK), .RN(PRESETn), .Q(NegCatch), .QN(
        n700) );
endmodule

