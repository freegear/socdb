
module pmcon_APBIF ( M_PCLK, PRESETn, M_PSEL, M_PENABLE, M_PREADY, M_PWRITE, 
        M_PADDR, M_PWDATA, M_PRDATA, R_PCLK, R_PSEL, R_PENABLE, R_PWRITE, 
        R_PADDR, R_PWDATA, R_PRDATA, CSb, ZZb, OEb, WEb, UBb, LBb, ADDR, 
        DATAIN, nDATAEN, DATAOUT );
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
  wire   Enable, PowerupSet, PowerupClr, BurstRMode, DataRWAvail, Read, Write;
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
        .PSRAMTCON(PSRAMTCON), .PSRAMTOUT(PSRAMTOUT) );
  pmcon_MEMIF_ADDRESSWIDTH22 pmcon_MEMIF ( .PCLK(M_PCLK), .PRESETn(PRESETn), 
        .PSEL(M_PSEL), .PENABLE(M_PENABLE), .PREADY(M_PREADY), .PWRITE(
        M_PWRITE), .PADDR(M_PADDR), .PWDATA(M_PWDATA), .PRDATA(M_PRDATA), 
        .DataRWAvail(DataRWAvail), .Read(Read), .Write(Write), .PSRAMRDATA(
        PSRAMRDATA) );
  pmcon_STM_ADDRESSWIDTH22 pmcon_STM ( .PCLK(M_PCLK), .PRESETn(PRESETn), 
        .PWDATA(M_PWDATA), .PADDR(M_PADDR), .Read(Read), .Write(Write), 
        .PSRAMRDATA(PSRAMRDATA), .Enable(Enable), .PowerupSet(PowerupSet), 
        .PowerupClr(PowerupClr), .PageSize(PageSize), .BurstRMode(BurstRMode), 
        .PSRAMTCON(PSRAMTCON), .PSRAMTOUT(PSRAMTOUT), .DataRWAvail(DataRWAvail), .CSb(CSb), .ZZb(ZZb), .OEb(OEb), .WEb(WEb), .UBb(UBb), .LBb(LBb), .ADDR({
        SYNOPSYS_UNCONNECTED__0, ADDR[20:0]}), .DATAIN(DATAIN), .nDATAEN(
        nDATAEN), .DATAOUT(DATAOUT) );
endmodule


module pmcon_STM_ADDRESSWIDTH22 ( PCLK, PRESETn, PWDATA, PADDR, Read, Write, 
        PSRAMRDATA, Enable, PowerupSet, PowerupClr, PageSize, BurstRMode, 
        PSRAMTCON, PSRAMTOUT, DataRWAvail, CSb, ZZb, OEb, WEb, UBb, LBb, ADDR, 
        DATAIN, nDATAEN, DATAOUT );
  input [31:0] PWDATA;
  input [21:0] PADDR;
  output [31:0] PSRAMRDATA;
  input [2:0] PageSize;
  input [31:0] PSRAMTCON;
  input [10:0] PSRAMTOUT;
  output [21:0] ADDR;
  input [15:0] DATAIN;
  output [15:0] DATAOUT;
  input PCLK, PRESETn, Read, Write, Enable, PowerupSet, PowerupClr, BurstRMode;
  output DataRWAvail, CSb, ZZb, OEb, WEb, UBb, LBb, nDATAEN;
  wire   RW_cnt, Hold, cycle_cntEn, n2522, PreviousAdr_21_, PreviousAdr_20_,
         PreviousAdr_19_, PreviousAdr_18_, PreviousAdr_17_, PreviousAdr_16_,
         PreviousAdr_15_, PreviousAdr_14_, PreviousAdr_13_, PreviousAdr_12_,
         PreviousAdr_11_, PreviousAdr_10_, PreviousAdr_9_, PreviousAdr_8_,
         PreviousAdr_7_, PreviousAdr_6_, PreviousAdr_5_, PreviousAdr_4_,
         PreviousAdr_3_, PreviousAdr_2_, PreviousAdr_1_, nextrw_state_3_,
         nextrw_state_2_, nextrw_state_1_, nextrw_state_0_, ToutCnt632_10_,
         ToutCnt632_9_, ToutCnt632_8_, ToutCnt632_7_, ToutCnt632_6_,
         ToutCnt632_5_, ToutCnt632_4_, ToutCnt632_3_, ToutCnt632_2_,
         ToutCnt632_1_, cycle_cnt_3_, cycle_cnt_2_, cycle_cnt_1_, cycle_cnt_0_,
         hold_cnt_3_, hold_cnt_2_, hold_cnt_1_, hold_cnt_0_, hold_cnt1034_3_,
         hold_cnt1034_2_, hold_cnt1034_1_, hold_cnt1034_0_, NextADR1356_19_,
         NextADR1356_18_, NextADR1356_17_, NextADR1356_16_, NextADR1356_15_,
         NextADR1356_14_, NextADR1356_13_, NextADR1356_12_, NextADR1356_11_,
         NextADR1356_10_, NextADR1356_9_, NextADR1356_8_, NextADR1356_7_,
         NextADR1356_6_, NextADR1356_5_, NextADR1356_4_, NextADR1356_3_,
         NextADR1356_2_, NextADR1356_1_, n2279, n2280, n2281, n2282, n2283,
         n2284, n2285, n2286, n2287, n2288, n2289, n2290, n2291, n2292, n2293,
         n2294, n2295, n2296, n2297, n2298, n2299, n2300, n2301, n2302, n2303,
         n2304, n2305, n2306, n2307, n2308, n2309, n2310, n2311, n2312, n2313,
         n2314, n2315, n2316, n2317, n2318, n2319, n2320, n2321, n2322, n2323,
         n2324, n2325, n2326, n2327, n2328, n2329, n2330, n2331, n2332, n2333,
         n2334, n2335, n2336, n2337, n2338, n2339, n2340, n2341, n2342, n2343,
         n2344, n2345, n2346, n2347, n2348, n2349, n2350, n2351, n2352, n2353,
         n2354, n2355, n2356, n2357, n2358, n2359, n2360, n2361, n2362, n2363,
         n2364, n2365, n2366, n2367, n2368, n2369, n2370, n2371, n2372, n2373,
         n2374, n2375, n2376, n2377, n2378, n2379, n2380, n2381, n2382, n2383,
         n2384, n2385, n2386, n2387, n2388, n2389, n2390, n2391, n2392, n2393,
         n2394, n2395, n2396, n2397, n2398, n2399, n2400, n2401, n2402, n2403,
         n2404, n2405, n2406, n2407, n2408, n2409, n2410, n2411, n2412, n2413,
         n2414, n2415, n2416, n2417, n2418, n2419, n2420, n2421, n2422, n2423,
         n2424, n2425, n2426, n2427, n2428, n2429, n2430, n2431, n2432, n2433,
         n2434, n2435, n2436, n2437, n2438, n2439, n2440, n2441, n2442, n2443,
         n2444, n2445, n2446, n2447, n2448, n2449, carry, carry0, carry1,
         carry2, carry3, carry4, carry5, carry6, carry7, carry_19_, carry_18_,
         carry_17_, carry_16_, carry_15_, carry_14_, carry_13_, carry_12_,
         carry_11_, carry_10_, carry_9_, carry_8_, carry_7_, carry_6_,
         carry_5_, carry_4_, carry_3_, carry_2_, n1, n2, n3, n4, n5, n6, n7,
         n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n2544,
         n2545, n2546, n2547, n2548, n2549, n2550, n2551, n2552, n2555, n2556,
         n2557, n2558, n2559, n2560, n2561, n2562, n2563, n2564, n2566, n2567,
         n2568, n2569, n2570, n2572, n2573, n2574, n2576, n2577, n2578, n2579,
         n2580, n2582, n2583, n2584, n2585, n2586, n2587, n2588, n2589, n2590,
         n2591, n2592, n2593, n2594, n2595, n2596, n2597, n2598, n2600, n2601,
         n2602, n2603, n2605, n2606, n2607, n2608, n2609, n2610, n2611, n2612,
         n2613, n2614, n2615, n2618, n2619, n2620, n2621, n2622, n2624, n2625,
         n2626, n2627, n2628, n2629, n2630, n2631, n2635, n2636, n2637, n2638,
         n2639, n2640, n2641, n2642, n2643, n2644, n2645, n2646, n2647, n2648,
         n2649, n2650, n2651, n2652, n2653, n2654, n2655, n2656, n2657, n2658,
         n2659, n2660, n2661, n2662, n2663, n2664, n2665, n2666, n2667, n2669,
         n2670, n2671, n2672, n2674, n2676, n2678, n2679, n2681, n2713, n2714,
         n2715, n2716, n2717, n2718, n2720, n2721, n2722, n2723, n2724, n2725,
         n2726, n2727, n2728, n2729, n2730, n2731, n2732, n2733, n2734, n2735,
         n2736, n2737, n2738, n2739, n2740, n2741, n2742, n2743, n2744, n2745,
         n2746, n2747, n2748, n2749, n2750, n2751, n2752, n2753, n2754, n2755,
         n2756, n2757, n2758, n2759, n2760, n2761, n2762, n2763, n2764, n2765,
         n2766, n2767, n2768, n2769, n2770, n2771, n2772, n2773, n2774, n2775,
         n2776, n2777, n2778, n2779, n2781, n2782, n2783, n2784, n2785, n2786,
         n2787, n2788, n2789, n2790, n2791, n2792, n2793, n2794, n2795, n2796,
         n2797, n2798, n2799, n2800, n2801, n2802, n2803, n2804, n2805, n2808,
         n2809, n2810, n2811, n2812, n2813, n2815, n2816, n2817, n2818, n2819,
         n2820, n2821, n2822, n2824, n2825, n2826, n2827, n2828, n2829, n2831,
         n2832, n2833, n2834, n2836, n2837, n2838, n2839, n2840, n2843, n2844,
         n2845, n2846, n2847, n2848, n2850, n2851, n2852, n2853, n2854, n2855,
         n2856, n2857, n2858, n2859, n2860, n2861, n2862, n2863, n2864, n2865,
         n2866, n2867, n2868, n2869, n2870, n2871, n2872, n2873, n2874, n2875,
         n2876, n2877, n2878, n2879, n2880, n2881, n2882, n2883, n2884, n2885,
         n2886, n2887, n2888, n2889, n2890, n2891, n2892, n2893, n2894, n2895,
         n2896, n2897, n2898, n2899, n2900, n2901, n2902, n2903, n2904, n2905,
         n2906, n2907, n2908, n2909, n2910, n2911, n2912, n2913, n2914, n2915,
         n2916, n2917, n2918, n2919, n2920, n2921, n2922, n2923, n2924, n2925,
         n2926, n2927;
  wire   [1:0] main_state;
  wire   [4:0] rw_state;
  wire   [31:0] PSRAMWDATA;
  wire   [10:0] ToutCnt;
  wire   [1:0] nextmain_state;
  assign LBb = n2522;
  assign UBb = n2522;
  assign ADDR[21] = 1'b0;

  AHHCONX2 U1_1_1 ( .A(n2902), .CI(n2901), .S(NextADR1356_1_), .CON(n19) );
  AHHCONX2 U1_1_2 ( .A(n2903), .CI(carry_2_), .S(NextADR1356_2_), .CON(n18) );
  AHHCONX2 U1_1_3 ( .A(n2904), .CI(carry_3_), .S(NextADR1356_3_), .CON(n17) );
  AHHCONX2 U1_1_4 ( .A(n2905), .CI(carry_4_), .S(NextADR1356_4_), .CON(n16) );
  AHHCONX2 U1_1_5 ( .A(n2906), .CI(carry_5_), .S(NextADR1356_5_), .CON(n15) );
  AHHCONX2 U1_1_6 ( .A(n2907), .CI(carry_6_), .S(NextADR1356_6_), .CON(n14) );
  AHHCONX2 U1_1_7 ( .A(n2908), .CI(carry_7_), .S(NextADR1356_7_), .CON(n13) );
  AHHCONX2 U1_1_8 ( .A(n2909), .CI(carry_8_), .S(NextADR1356_8_), .CON(n12) );
  AHHCONX2 U1_1_9 ( .A(n2910), .CI(carry_9_), .S(NextADR1356_9_), .CON(n11) );
  AHHCONX2 U1_1_10 ( .A(n2911), .CI(carry_10_), .S(NextADR1356_10_), .CON(n10)
         );
  AHHCONX2 U1_1_11 ( .A(n2912), .CI(carry_11_), .S(NextADR1356_11_), .CON(n9)
         );
  AHHCONX2 U1_1_12 ( .A(n2913), .CI(carry_12_), .S(NextADR1356_12_), .CON(n8)
         );
  AHHCONX2 U1_1_13 ( .A(n2914), .CI(carry_13_), .S(NextADR1356_13_), .CON(n7)
         );
  AHHCONX2 U1_1_14 ( .A(n2915), .CI(carry_14_), .S(NextADR1356_14_), .CON(n6)
         );
  AHHCONX2 U1_1_15 ( .A(n2916), .CI(carry_15_), .S(NextADR1356_15_), .CON(n5)
         );
  AHHCONX2 U1_1_16 ( .A(n2917), .CI(carry_16_), .S(NextADR1356_16_), .CON(n4)
         );
  AHHCONX2 U1_1_17 ( .A(n2918), .CI(carry_17_), .S(NextADR1356_17_), .CON(n3)
         );
  AHHCONX2 U1_1_18 ( .A(n2919), .CI(carry_18_), .S(NextADR1356_18_), .CON(n2)
         );
  AHHCONX2 U1_1_19 ( .A(n2920), .CI(carry_19_), .S(NextADR1356_19_), .CON(n1)
         );
  XNOR2X1 U1728 ( .A(nextrw_state_2_), .B(n2566), .Y(n2869) );
  AO21X1 U1729 ( .A0(NextADR1356_1_), .A1(n2641), .B0(n2642), .Y(n2419) );
  AO21X1 U1730 ( .A0(NextADR1356_2_), .A1(n2641), .B0(n2645), .Y(n2418) );
  AO21X1 U1731 ( .A0(NextADR1356_3_), .A1(n2641), .B0(n2646), .Y(n2417) );
  AO21X1 U1732 ( .A0(NextADR1356_4_), .A1(n2641), .B0(n2647), .Y(n2416) );
  AO21X1 U1733 ( .A0(NextADR1356_5_), .A1(n2641), .B0(n2648), .Y(n2415) );
  AO21X1 U1734 ( .A0(NextADR1356_6_), .A1(n2641), .B0(n2649), .Y(n2414) );
  AO21X1 U1735 ( .A0(NextADR1356_7_), .A1(n2641), .B0(n2650), .Y(n2413) );
  AO21X1 U1736 ( .A0(NextADR1356_8_), .A1(n2641), .B0(n2651), .Y(n2412) );
  AO21X1 U1737 ( .A0(NextADR1356_9_), .A1(n2641), .B0(n2652), .Y(n2411) );
  AO21X1 U1738 ( .A0(NextADR1356_10_), .A1(n2641), .B0(n2653), .Y(n2410) );
  AO21X1 U1739 ( .A0(NextADR1356_11_), .A1(n2641), .B0(n2654), .Y(n2409) );
  AO21X1 U1740 ( .A0(NextADR1356_12_), .A1(n2641), .B0(n2655), .Y(n2408) );
  AO21X1 U1741 ( .A0(NextADR1356_13_), .A1(n2641), .B0(n2656), .Y(n2407) );
  DFFRHQX4 ADR_reg_14_ ( .D(n2406), .CK(PCLK), .RN(PRESETn), .Q(ADDR[14]) );
  DFFRHQX4 ADR_reg_15_ ( .D(n2405), .CK(PCLK), .RN(PRESETn), .Q(ADDR[15]) );
  DFFRHQX4 ADR_reg_16_ ( .D(n2404), .CK(PCLK), .RN(PRESETn), .Q(ADDR[16]) );
  DFFRHQX4 ADR_reg_17_ ( .D(n2403), .CK(PCLK), .RN(PRESETn), .Q(ADDR[17]) );
  DFFRHQX4 ADR_reg_18_ ( .D(n2402), .CK(PCLK), .RN(PRESETn), .Q(ADDR[18]) );
  DFFRHQX4 ADR_reg_19_ ( .D(n2401), .CK(PCLK), .RN(PRESETn), .Q(ADDR[19]) );
  DFFRHQX4 ADR_reg_20_ ( .D(n2400), .CK(PCLK), .RN(PRESETn), .Q(ADDR[20]) );
  DFFRHQX4 ADR_reg_0_ ( .D(n2420), .CK(PCLK), .RN(PRESETn), .Q(ADDR[0]) );
  DFFRHQX4 ADR_reg_1_ ( .D(n2419), .CK(PCLK), .RN(PRESETn), .Q(ADDR[1]) );
  DFFRHQX4 ADR_reg_2_ ( .D(n2418), .CK(PCLK), .RN(PRESETn), .Q(ADDR[2]) );
  DFFRHQX4 ADR_reg_3_ ( .D(n2417), .CK(PCLK), .RN(PRESETn), .Q(ADDR[3]) );
  DFFRHQX4 ADR_reg_4_ ( .D(n2416), .CK(PCLK), .RN(PRESETn), .Q(ADDR[4]) );
  DFFRHQX4 ADR_reg_5_ ( .D(n2415), .CK(PCLK), .RN(PRESETn), .Q(ADDR[5]) );
  DFFRHQX4 ADR_reg_6_ ( .D(n2414), .CK(PCLK), .RN(PRESETn), .Q(ADDR[6]) );
  DFFRHQX4 ADR_reg_7_ ( .D(n2413), .CK(PCLK), .RN(PRESETn), .Q(ADDR[7]) );
  DFFRHQX4 ADR_reg_8_ ( .D(n2412), .CK(PCLK), .RN(PRESETn), .Q(ADDR[8]) );
  DFFRHQX4 ADR_reg_9_ ( .D(n2411), .CK(PCLK), .RN(PRESETn), .Q(ADDR[9]) );
  DFFRHQX4 ADR_reg_10_ ( .D(n2410), .CK(PCLK), .RN(PRESETn), .Q(ADDR[10]) );
  DFFRHQX4 ADR_reg_11_ ( .D(n2409), .CK(PCLK), .RN(PRESETn), .Q(ADDR[11]) );
  DFFRHQX4 ADR_reg_12_ ( .D(n2408), .CK(PCLK), .RN(PRESETn), .Q(ADDR[12]) );
  DFFRHQX4 ADR_reg_13_ ( .D(n2407), .CK(PCLK), .RN(PRESETn), .Q(ADDR[13]) );
  AO21X1 U1742 ( .A0(NextADR1356_14_), .A1(n2641), .B0(n2657), .Y(n2406) );
  AO21X1 U1743 ( .A0(NextADR1356_15_), .A1(n2641), .B0(n2658), .Y(n2405) );
  AO21X1 U1744 ( .A0(NextADR1356_16_), .A1(n2641), .B0(n2659), .Y(n2404) );
  AO21X1 U1745 ( .A0(NextADR1356_17_), .A1(n2641), .B0(n2660), .Y(n2403) );
  AO21X1 U1746 ( .A0(NextADR1356_18_), .A1(n2641), .B0(n2661), .Y(n2402) );
  AO21X1 U1747 ( .A0(NextADR1356_19_), .A1(n2641), .B0(n2662), .Y(n2401) );
  INVX1 U1748 ( .A(n2921), .Y(n2664) );
  BUFX2 U1749 ( .A(ADDR[20]), .Y(n2921) );
  INVX1 U1750 ( .A(n2640), .Y(n2641) );
  INVX1 U1751 ( .A(n2597), .Y(n2600) );
  INVX1 U1752 ( .A(n2549), .Y(n2545) );
  NAND2BX1 U1753 ( .AN(n2926), .B(n2637), .Y(n2640) );
  OAI211X1 U1754 ( .A0(n2609), .A1(n2610), .B0(n2611), .C0(n2559), .Y(n2597)
         );
  INVX1 U1755 ( .A(n2602), .Y(n2609) );
  INVX1 U1756 ( .A(n2922), .Y(n2636) );
  INVX1 U1757 ( .A(n2672), .Y(n2618) );
  INVX1 U1758 ( .A(n1), .Y(n2665) );
  INVX1 U1759 ( .A(n2644), .Y(n2621) );
  INVX1 U1760 ( .A(n2614), .Y(n2625) );
  DFFSX1 cur_CS_reg ( .D(n2445), .CK(PCLK), .SN(PRESETn), .Q(CSb), .QN(n2874)
         );
  NAND4BX1 U1761 ( .AN(nextrw_state_3_), .B(n2869), .C(n2552), .D(n2895), .Y(
        n2549) );
  NAND2BX1 U1762 ( .AN(n2551), .B(n2552), .Y(n2550) );
  INVX1 U1763 ( .A(n2637), .Y(n2643) );
  INVX1 U1764 ( .A(n2735), .Y(n2734) );
  AOI31X1 U1765 ( .A0(n2895), .A1(n2869), .A2(n2562), .B0(n2563), .Y(n2561) );
  INVX1 U1766 ( .A(n2548), .Y(n2563) );
  NOR2BX1 U1767 ( .AN(n2564), .B(nextrw_state_3_), .Y(n2562) );
  NAND2BX1 U1768 ( .AN(nextmain_state[1]), .B(n2564), .Y(n2548) );
  INVX1 U1769 ( .A(n2752), .Y(n2744) );
  INVX1 U1770 ( .A(n2720), .Y(n2721) );
  INVX1 U1771 ( .A(n2560), .Y(n2552) );
  NAND4BX1 U1772 ( .AN(n2622), .B(n2676), .C(n2674), .D(n2625), .Y(n2672) );
  NAND3BX1 U1773 ( .AN(n2667), .B(n2847), .C(n2669), .Y(n2602) );
  INVX1 U1774 ( .A(nextrw_state_3_), .Y(n2669) );
  NAND3BX1 U1775 ( .AN(nextrw_state_1_), .B(n2899), .C(n2605), .Y(n2667) );
  INVX1 U1776 ( .A(n19), .Y(carry_2_) );
  INVX1 U1777 ( .A(n18), .Y(carry_3_) );
  INVX1 U1778 ( .A(n17), .Y(carry_4_) );
  INVX1 U1779 ( .A(n16), .Y(carry_5_) );
  INVX1 U1780 ( .A(n15), .Y(carry_6_) );
  INVX1 U1781 ( .A(n14), .Y(carry_7_) );
  INVX1 U1782 ( .A(n13), .Y(carry_8_) );
  INVX1 U1783 ( .A(n12), .Y(carry_9_) );
  INVX1 U1784 ( .A(n11), .Y(carry_10_) );
  INVX1 U1785 ( .A(n10), .Y(carry_11_) );
  INVX1 U1786 ( .A(n9), .Y(carry_12_) );
  INVX1 U1787 ( .A(n8), .Y(carry_13_) );
  INVX1 U1788 ( .A(n7), .Y(carry_14_) );
  INVX1 U1789 ( .A(n6), .Y(carry_15_) );
  INVX1 U1790 ( .A(n5), .Y(carry_16_) );
  INVX1 U1791 ( .A(n4), .Y(carry_17_) );
  INVX1 U1792 ( .A(n3), .Y(carry_18_) );
  OAI32X1 U1793 ( .A0(n2622), .A1(n2670), .A2(n2671), .B0(n2672), .B1(n2843), 
        .Y(nextrw_state_3_) );
  NAND2BX1 U1794 ( .AN(n2619), .B(n2614), .Y(n2671) );
  AO22X1 U1795 ( .A0(n2722), .A1(n2757), .B0(n2724), .B1(n2758), .Y(n2922) );
  AO21X1 U1796 ( .A0(Read), .A1(n2602), .B0(Write), .Y(n2644) );
  OAI32X1 U1797 ( .A0(n2608), .A1(n2746), .A2(n2848), .B0(n2746), .B1(n2635), 
        .Y(n2614) );
  OAI31X1 U1798 ( .A0(n2666), .A1(n2560), .A2(n2848), .B0(n2621), .Y(n2637) );
  INVX1 U1799 ( .A(n2624), .Y(n2666) );
  AO21X1 U1800 ( .A0(Read), .A1(n2602), .B0(Write), .Y(n2926) );
  NAND4BX1 U1801 ( .AN(nextrw_state_1_), .B(n2605), .C(n2895), .D(
        nextrw_state_3_), .Y(n2551) );
  OAI222X1 U1802 ( .A0(n2596), .A1(n2597), .B0(n2552), .B1(n2596), .C0(n2598), 
        .C1(n2874), .Y(n2445) );
  INVX1 U1803 ( .A(n2598), .Y(n2596) );
  OAI211X1 U1804 ( .A0(nextmain_state[0]), .A1(n2600), .B0(n2601), .C0(n2602), 
        .Y(n2598) );
  AOI31X1 U1805 ( .A0(n2923), .A1(n2848), .A2(n2605), .B0(n2606), .Y(n2601) );
  INVX1 U1806 ( .A(n2766), .Y(n2722) );
  INVX1 U1807 ( .A(n2), .Y(carry_19_) );
  NOR2X1 U1808 ( .A(n2899), .B(nextrw_state_0_), .Y(n2895) );
  INVX1 U1809 ( .A(n2809), .Y(n2754) );
  INVX1 U1810 ( .A(nextrw_state_2_), .Y(n2605) );
  INVX1 U1811 ( .A(n2556), .Y(n2559) );
  INVX1 U1812 ( .A(nextrw_state_1_), .Y(n2566) );
  NAND2BX1 U1813 ( .AN(n2672), .B(n2742), .Y(n2735) );
  AO22X1 U1814 ( .A0(n2722), .A1(n2757), .B0(n2724), .B1(n2758), .Y(n2603) );
  NAND2BX1 U1815 ( .AN(n2724), .B(n2766), .Y(n2752) );
  AO21X1 U1816 ( .A0(Read), .A1(n2602), .B0(Write), .Y(n2927) );
  AO21X1 U1817 ( .A0(n2734), .A1(n2845), .B0(n2733), .Y(n2737) );
  INVX1 U1818 ( .A(Write), .Y(n2635) );
  NAND3BX1 U1819 ( .AN(n2620), .B(n2611), .C(n2621), .Y(n2444) );
  OAI221X1 U1820 ( .A0(n2848), .A1(n2871), .B0(n2624), .B1(n2871), .C0(n2625), 
        .Y(n2620) );
  INVX1 U1821 ( .A(Read), .Y(n2610) );
  AO21X1 U1822 ( .A0(n2734), .A1(n2866), .B0(n2737), .Y(n2738) );
  INVX1 U1823 ( .A(n2746), .Y(n2753) );
  INVX1 U1824 ( .A(n2676), .Y(n2619) );
  INVX1 U1825 ( .A(n2670), .Y(n2674) );
  INVX1 U1826 ( .A(n2622), .Y(n2611) );
  INVX1 U1827 ( .A(n2742), .Y(n2733) );
  AO22X1 U1828 ( .A0(n2722), .A1(n2757), .B0(n2724), .B1(n2758), .Y(n2923) );
  NAND2BX1 U1829 ( .AN(n2595), .B(n2564), .Y(n2560) );
  NAND2BX1 U1830 ( .AN(n2923), .B(n2608), .Y(n2624) );
  INVX1 U1831 ( .A(nextmain_state[0]), .Y(n2564) );
  INVX1 U1832 ( .A(n2588), .Y(n2585) );
  INVX1 U1833 ( .A(n2595), .Y(nextmain_state[1]) );
  INVX1 U1834 ( .A(n2577), .Y(n2573) );
  AO22X1 U1835 ( .A0(n2722), .A1(n2723), .B0(n2724), .B1(n2725), .Y(n2925) );
  AO22X1 U1836 ( .A0(n2722), .A1(n2723), .B0(n2724), .B1(n2725), .Y(n2924) );
  AO22X1 U1837 ( .A0(n2722), .A1(n2723), .B0(n2724), .B1(n2725), .Y(n2720) );
  NAND2BX1 U1838 ( .AN(n2848), .B(n2627), .Y(n2679) );
  INVX1 U1839 ( .A(n2824), .Y(n2822) );
  NAND2BX1 U1840 ( .AN(n2825), .B(n2874), .Y(n2824) );
  OAI211X1 U1841 ( .A0(n2848), .A1(n2624), .B0(n2610), .C0(n2635), .Y(n2442)
         );
  INVX1 U1842 ( .A(n2831), .Y(hold_cnt1034_0_) );
  INVX1 U1843 ( .A(n2607), .Y(n2825) );
  XOR2X1 U1844 ( .A(PreviousAdr_1_), .B(PADDR[1]), .Y(n2776) );
  XOR2X1 U1845 ( .A(PreviousAdr_6_), .B(PADDR[6]), .Y(n2803) );
  NAND4BX1 U1846 ( .AN(n2834), .B(n2868), .C(rw_state[3]), .D(n2847), .Y(n2586) );
  NAND4BX1 U1847 ( .AN(n2834), .B(n2843), .C(rw_state[1]), .D(n2847), .Y(n2766) );
  NAND4BX1 U1848 ( .AN(n2834), .B(n2843), .C(rw_state[0]), .D(n2868), .Y(n2809) );
  XOR2X1 U1849 ( .A(PADDR[13]), .B(n2896), .Y(n2813) );
  XOR2X1 U1850 ( .A(PADDR[5]), .B(n2897), .Y(n2805) );
  XOR2X1 U1851 ( .A(PADDR[4]), .B(n2898), .Y(n2804) );
  INVX1 U1852 ( .A(n2839), .Y(n2724) );
  NAND3BX1 U1853 ( .AN(n2840), .B(n2847), .C(rw_state[2]), .Y(n2839) );
  NAND3BX1 U1854 ( .AN(rw_state[4]), .B(n2843), .C(n2868), .Y(n2840) );
  AND4X1 U1855 ( .A(n2759), .B(n2867), .C(n2760), .D(n2761), .Y(n2758) );
  XOR2X1 U1856 ( .A(n2846), .B(PSRAMTCON[23]), .Y(n2759) );
  XOR2X1 U1857 ( .A(n2866), .B(PSRAMTCON[22]), .Y(n2760) );
  XOR2X1 U1858 ( .A(n2845), .B(PSRAMTCON[21]), .Y(n2761) );
  XOR2X1 U1859 ( .A(n2866), .B(PSRAMTCON[29]), .Y(n2764) );
  AO22X1 U1860 ( .A0(n2676), .A1(n2622), .B0(rw_state[1]), .B1(n2618), .Y(
        nextrw_state_1_) );
  OAI33X1 U1861 ( .A0(n2755), .A1(n2610), .A2(n2746), .B0(n2636), .B1(n2746), 
        .B2(n2756), .Y(n2622) );
  NAND2BX1 U1862 ( .AN(BurstRMode), .B(RW_cnt), .Y(n2756) );
  AND4X1 U1863 ( .A(n2767), .B(n2768), .C(n2769), .D(n2770), .Y(n2755) );
  NOR2BX1 U1864 ( .AN(n2586), .B(CSb), .Y(n2767) );
  OAI32X1 U1865 ( .A0(n2622), .A1(n2619), .A2(n2674), .B0(n2672), .B1(n2872), 
        .Y(nextrw_state_2_) );
  NAND2BX1 U1866 ( .AN(n2775), .B(PageSize[1]), .Y(n2781) );
  AO21X1 U1867 ( .A0(rw_state[0]), .A1(n2618), .B0(n2619), .Y(nextrw_state_0_)
         );
  OAI31X1 U1868 ( .A0(n2551), .A1(n2612), .A2(n2586), .B0(n2613), .Y(n2556) );
  NAND4BX1 U1869 ( .AN(cycle_cnt_3_), .B(n2846), .C(n2587), .D(n2615), .Y(
        n2612) );
  OAI211X1 U1870 ( .A0(Write), .A1(n2614), .B0(n2570), .C0(n2593), .Y(n2613)
         );
  XOR2X1 U1871 ( .A(n2593), .B(cycle_cnt_1_), .Y(n2615) );
  NAND3BX1 U1872 ( .AN(n2798), .B(n2799), .C(n2800), .Y(n2785) );
  XOR2X1 U1873 ( .A(n2802), .B(PreviousAdr_7_), .Y(n2799) );
  XOR2X1 U1874 ( .A(n2801), .B(PreviousAdr_8_), .Y(n2800) );
  XOR2X1 U1875 ( .A(PreviousAdr_9_), .B(PADDR[9]), .Y(n2798) );
  NAND3BX1 U1876 ( .AN(n2788), .B(n2789), .C(n2790), .Y(n2787) );
  XOR2X1 U1877 ( .A(n2792), .B(PreviousAdr_19_), .Y(n2789) );
  XOR2X1 U1878 ( .A(n2791), .B(PreviousAdr_20_), .Y(n2790) );
  XOR2X1 U1879 ( .A(PreviousAdr_21_), .B(PADDR[21]), .Y(n2788) );
  NAND3BX1 U1880 ( .AN(n2793), .B(n2794), .C(n2795), .Y(n2786) );
  XOR2X1 U1881 ( .A(n2797), .B(PreviousAdr_16_), .Y(n2794) );
  XOR2X1 U1882 ( .A(n2796), .B(PreviousAdr_17_), .Y(n2795) );
  XOR2X1 U1883 ( .A(PreviousAdr_18_), .B(PADDR[18]), .Y(n2793) );
  NAND3BX1 U1884 ( .AN(n2817), .B(n2818), .C(n2819), .Y(n2810) );
  XOR2X1 U1885 ( .A(n2821), .B(PreviousAdr_10_), .Y(n2818) );
  XOR2X1 U1886 ( .A(n2820), .B(PreviousAdr_11_), .Y(n2819) );
  XOR2X1 U1887 ( .A(PreviousAdr_12_), .B(PADDR[12]), .Y(n2817) );
  NAND2BX1 U1888 ( .AN(n2586), .B(n2747), .Y(n2608) );
  AND4X1 U1889 ( .A(n2748), .B(n2749), .C(n2750), .D(n2751), .Y(n2747) );
  XOR2X1 U1890 ( .A(n2867), .B(PSRAMTCON[17]), .Y(n2750) );
  XOR2X1 U1891 ( .A(n2866), .B(PSRAMTCON[15]), .Y(n2748) );
  AO22X1 U1892 ( .A0(n2918), .A1(n2643), .B0(PADDR[18]), .B1(n2644), .Y(n2660)
         );
  AO22X1 U1893 ( .A0(n2919), .A1(n2643), .B0(PADDR[19]), .B1(n2926), .Y(n2661)
         );
  AO22X1 U1894 ( .A0(n2920), .A1(n2643), .B0(PADDR[20]), .B1(n2927), .Y(n2662)
         );
  OR2X1 U1895 ( .A(rw_state[2]), .B(rw_state[4]), .Y(n2834) );
  AND4X1 U1896 ( .A(n2762), .B(n2763), .C(n2764), .D(n2765), .Y(n2757) );
  XOR2X1 U1897 ( .A(n2867), .B(PSRAMTCON[31]), .Y(n2762) );
  XOR2X1 U1898 ( .A(n2845), .B(PSRAMTCON[28]), .Y(n2763) );
  XOR2X1 U1899 ( .A(n2846), .B(PSRAMTCON[30]), .Y(n2765) );
  OAI31X1 U1900 ( .A0(n2771), .A1(n2772), .A2(n2773), .B0(n2774), .Y(n2770) );
  INVX1 U1901 ( .A(PageSize[2]), .Y(n2774) );
  XOR2X1 U1902 ( .A(PreviousAdr_3_), .B(PADDR[3]), .Y(n2773) );
  OA21X2 U1903 ( .A0(n2775), .A1(n2776), .B0(n2777), .Y(n2772) );
  AOI211X1 U1904 ( .A0(PageSize[1]), .A1(PageSize[2]), .B0(n2782), .C0(n2783), 
        .Y(n2769) );
  INVX1 U1905 ( .A(BurstRMode), .Y(n2783) );
  OR4X1 U1906 ( .A(n2784), .B(n2785), .C(n2786), .D(n2787), .Y(n2782) );
  NAND3BX1 U1907 ( .AN(n2803), .B(n2804), .C(n2805), .Y(n2784) );
  AOI211X1 U1908 ( .A0(PageSize[2]), .A1(PageSize[0]), .B0(n2808), .C0(n2754), 
        .Y(n2768) );
  NAND4BX1 U1909 ( .AN(n2810), .B(n2811), .C(n2812), .D(n2813), .Y(n2808) );
  XOR2X1 U1910 ( .A(n2816), .B(PreviousAdr_15_), .Y(n2811) );
  XOR2X1 U1911 ( .A(n2815), .B(PreviousAdr_14_), .Y(n2812) );
  OAI33X1 U1912 ( .A0(n2778), .A1(PreviousAdr_2_), .A2(n2779), .B0(n2778), 
        .B1(PADDR[2]), .B2(n2870), .Y(n2771) );
  INVX1 U1913 ( .A(PADDR[2]), .Y(n2779) );
  INVX1 U1914 ( .A(n2781), .Y(n2778) );
  OAI33X1 U1915 ( .A0(n2640), .A1(n2664), .A2(n2665), .B0(n2640), .B1(n2921), 
        .B2(n1), .Y(n2663) );
  INVX1 U1916 ( .A(PageSize[0]), .Y(n2775) );
  INVX1 U1917 ( .A(PageSize[1]), .Y(n2777) );
  NOR2X1 U1918 ( .A(n2672), .B(n2900), .Y(n2899) );
  OAI222X1 U1919 ( .A0(n2555), .A1(n2556), .B0(n2552), .B1(n2555), .C0(n2557), 
        .C1(n2304), .Y(n2447) );
  INVX1 U1920 ( .A(n2557), .Y(n2555) );
  OAI221X1 U1921 ( .A0(n2551), .A1(n2558), .B0(n2559), .B1(n2560), .C0(n2561), 
        .Y(n2557) );
  NAND3BX1 U1922 ( .AN(n2567), .B(n2568), .C(n2569), .Y(n2558) );
  NAND3BX1 U1923 ( .AN(n2735), .B(cycle_cnt_0_), .C(cycle_cnt_1_), .Y(n2740)
         );
  XOR2X1 U1924 ( .A(n2846), .B(PSRAMTCON[16]), .Y(n2751) );
  XOR2X1 U1925 ( .A(n2845), .B(PSRAMTCON[14]), .Y(n2749) );
  AO21X1 U1926 ( .A0(Enable), .A1(n2753), .B0(n2754), .Y(n2676) );
  NAND2BX1 U1927 ( .AN(main_state[0]), .B(main_state[1]), .Y(n2746) );
  AO21X1 U1928 ( .A0(Enable), .A1(n2672), .B0(n2743), .Y(n2742) );
  AOI211X1 U1929 ( .A0(n2744), .A1(n2586), .B0(n2871), .C0(n2745), .Y(n2743)
         );
  AO22X1 U1930 ( .A0(Read), .A1(n2752), .B0(RW_cnt), .B1(n2603), .Y(n2670) );
  INVX1 U1931 ( .A(PADDR[20]), .Y(n2791) );
  INVX1 U1932 ( .A(PADDR[19]), .Y(n2792) );
  INVX1 U1933 ( .A(PADDR[17]), .Y(n2796) );
  INVX1 U1934 ( .A(PADDR[16]), .Y(n2797) );
  INVX1 U1935 ( .A(PADDR[8]), .Y(n2801) );
  INVX1 U1936 ( .A(PADDR[7]), .Y(n2802) );
  INVX1 U1937 ( .A(PADDR[11]), .Y(n2820) );
  INVX1 U1938 ( .A(PADDR[10]), .Y(n2821) );
  INVX1 U1939 ( .A(PADDR[14]), .Y(n2815) );
  INVX1 U1940 ( .A(PADDR[15]), .Y(n2816) );
  OAI222X1 U1941 ( .A0(n2637), .A1(n2638), .B0(n2621), .B1(n2639), .C0(n2901), 
        .C1(n2640), .Y(n2420) );
  INVX1 U1942 ( .A(PADDR[1]), .Y(n2639) );
  AO22X1 U1943 ( .A0(cycle_cnt_2_), .A1(n2738), .B0(n2739), .B1(n2846), .Y(
        n2317) );
  INVX1 U1944 ( .A(n2740), .Y(n2739) );
  OAI32X1 U1945 ( .A0(n2544), .A1(n2545), .A2(n2546), .B0(n2547), .B1(n2303), 
        .Y(n2449) );
  INVX1 U1946 ( .A(n2547), .Y(n2544) );
  NAND3BX1 U1947 ( .AN(n2546), .B(n2548), .C(n2549), .Y(n2547) );
  INVX1 U1948 ( .A(n2550), .Y(n2546) );
  OAI32X1 U1949 ( .A0(n2735), .A1(cycle_cnt_1_), .A2(n2845), .B0(n2736), .B1(
        n2866), .Y(n2318) );
  INVX1 U1950 ( .A(n2737), .Y(n2736) );
  AO21X1 U1951 ( .A0(cycle_cnt_3_), .A1(n2738), .B0(n2741), .Y(n2316) );
  OAI33X1 U1952 ( .A0(n2735), .A1(cycle_cnt_2_), .A2(n2867), .B0(n2740), .B1(
        cycle_cnt_3_), .B2(n2846), .Y(n2741) );
  AO22X1 U1953 ( .A0(n2902), .A1(n2643), .B0(PADDR[2]), .B1(n2927), .Y(n2642)
         );
  AO22X1 U1954 ( .A0(n2903), .A1(n2643), .B0(PADDR[3]), .B1(n2926), .Y(n2645)
         );
  AO22X1 U1955 ( .A0(n2904), .A1(n2643), .B0(PADDR[4]), .B1(n2926), .Y(n2646)
         );
  AO22X1 U1956 ( .A0(n2905), .A1(n2643), .B0(PADDR[5]), .B1(n2927), .Y(n2647)
         );
  AO22X1 U1957 ( .A0(n2906), .A1(n2643), .B0(PADDR[6]), .B1(n2927), .Y(n2648)
         );
  AO22X1 U1958 ( .A0(n2907), .A1(n2643), .B0(PADDR[7]), .B1(n2926), .Y(n2649)
         );
  AO22X1 U1959 ( .A0(n2908), .A1(n2643), .B0(PADDR[8]), .B1(n2927), .Y(n2650)
         );
  AO22X1 U1960 ( .A0(n2909), .A1(n2643), .B0(PADDR[9]), .B1(n2926), .Y(n2651)
         );
  AO22X1 U1961 ( .A0(n2910), .A1(n2643), .B0(PADDR[10]), .B1(n2926), .Y(n2652)
         );
  AO22X1 U1962 ( .A0(n2911), .A1(n2643), .B0(PADDR[11]), .B1(n2927), .Y(n2653)
         );
  AO22X1 U1963 ( .A0(n2912), .A1(n2643), .B0(PADDR[12]), .B1(n2927), .Y(n2654)
         );
  AO22X1 U1964 ( .A0(n2913), .A1(n2643), .B0(PADDR[13]), .B1(n2926), .Y(n2655)
         );
  AO22X1 U1965 ( .A0(n2914), .A1(n2643), .B0(PADDR[14]), .B1(n2927), .Y(n2656)
         );
  AO22X1 U1966 ( .A0(n2915), .A1(n2643), .B0(PADDR[15]), .B1(n2644), .Y(n2657)
         );
  AO22X1 U1967 ( .A0(n2916), .A1(n2643), .B0(PADDR[16]), .B1(n2926), .Y(n2658)
         );
  AO22X1 U1968 ( .A0(n2917), .A1(n2643), .B0(PADDR[17]), .B1(n2927), .Y(n2659)
         );
  AOI31X1 U1969 ( .A0(n2548), .A1(n2302), .A2(n2551), .B0(n2545), .Y(n2448) );
  XOR2X1 U1970 ( .A(n2570), .B(cycle_cnt_0_), .Y(n2587) );
  NAND2BX1 U1971 ( .AN(n2570), .B(PSRAMTCON[8]), .Y(n2588) );
  XOR2X1 U1972 ( .A(cycle_cnt_1_), .B(n2590), .Y(n2589) );
  NOR2BX1 U1973 ( .AN(n2591), .B(n2592), .Y(n2590) );
  OAI33X1 U1974 ( .A0(n2585), .A1(PSRAMTCON[9]), .A2(n2593), .B0(n2585), .B1(
        PSRAMTCON[13]), .B2(n2594), .Y(n2592) );
  AOI33X1 U1975 ( .A0(n2593), .A1(n2594), .A2(n2585), .B0(PSRAMTCON[13]), .B1(
        PSRAMTCON[9]), .B2(n2585), .Y(n2591) );
  OAI222X1 U1976 ( .A0(PSRAMTCON[9]), .A1(n2585), .B0(PSRAMTCON[13]), .B1(
        n2585), .C0(PSRAMTCON[9]), .C1(PSRAMTCON[13]), .Y(n2577) );
  OAI32X1 U1977 ( .A0(n2745), .A1(PowerupClr), .A2(n2876), .B0(n2745), .B1(
        n2678), .Y(nextmain_state[0]) );
  OAI211X1 U1978 ( .A0(main_state[1]), .A1(PowerupClr), .B0(n2678), .C0(Enable), .Y(n2595) );
  OR4X1 U1979 ( .A(ToutCnt[10]), .B(ToutCnt[0]), .C(n2836), .D(n2837), .Y(
        n2607) );
  NAND3BX1 U1980 ( .AN(ToutCnt[3]), .B(n2296), .C(n2295), .Y(n2836) );
  NAND4BX1 U1981 ( .AN(n2838), .B(n2299), .C(n2297), .D(n2298), .Y(n2837) );
  NAND3BX1 U1982 ( .AN(ToutCnt[9]), .B(n2301), .C(n2300), .Y(n2838) );
  NAND3BX1 U1983 ( .AN(n2578), .B(n2579), .C(n2580), .Y(n2567) );
  INVX1 U1984 ( .A(n2586), .Y(n2579) );
  OAI221X1 U1985 ( .A0(PSRAMTCON[8]), .A1(n2587), .B0(n2845), .B1(n2588), .C0(
        n2589), .Y(n2578) );
  XOR2X1 U1986 ( .A(n2867), .B(n2582), .Y(n2580) );
  OAI31X1 U1987 ( .A0(n2577), .A1(PSRAMTCON[11]), .A2(n2574), .B0(n2583), .Y(
        n2582) );
  OA22X1 U1988 ( .A0(PSRAMTCON[10]), .A1(n2584), .B0(n2573), .B1(n2584), .Y(
        n2583) );
  INVX1 U1989 ( .A(PSRAMTCON[11]), .Y(n2584) );
  AOI31X1 U1990 ( .A0(n2570), .A1(PSRAMTCON[8]), .A2(n2845), .B0(n2572), .Y(
        n2569) );
  OAI33X1 U1991 ( .A0(n2573), .A1(cycle_cnt_2_), .A2(n2574), .B0(n2573), .B1(
        PSRAMTCON[10]), .B2(n2846), .Y(n2572) );
  AOI31X1 U1992 ( .A0(PSRAMTCON[10]), .A1(cycle_cnt_2_), .A2(n2573), .B0(n2576), .Y(n2568) );
  OAI31X1 U1993 ( .A0(n2577), .A1(cycle_cnt_2_), .A2(PSRAMTCON[10]), .B0(n2564), .Y(n2576) );
  OR2X1 U1_B_1 ( .A(ToutCnt[1]), .B(ToutCnt[0]), .Y(carry7) );
  AO22X1 U1994 ( .A0(PSRAMTOUT[10]), .A1(CSb), .B0(ToutCnt632_10_), .B1(n2822), 
        .Y(n2305) );
  XNOR2X1 U1_A_10 ( .A(ToutCnt[10]), .B(carry), .Y(ToutCnt632_10_) );
  OR2X1 U1_B_9 ( .A(ToutCnt[9]), .B(carry0), .Y(carry) );
  OR2X1 U1_B_3 ( .A(ToutCnt[3]), .B(carry6), .Y(carry5) );
  OR2X1 U1_B_2 ( .A(ToutCnt[2]), .B(carry7), .Y(carry6) );
  OR2X1 U1_B_4 ( .A(ToutCnt[4]), .B(carry5), .Y(carry4) );
  OR2X1 U1_B_5 ( .A(ToutCnt[5]), .B(carry4), .Y(carry3) );
  OR2X1 U1_B_6 ( .A(ToutCnt[6]), .B(carry3), .Y(carry2) );
  OR2X1 U1_B_7 ( .A(ToutCnt[7]), .B(carry2), .Y(carry1) );
  OR2X1 U1_B_8 ( .A(ToutCnt[8]), .B(carry1), .Y(carry0) );
  AO22X1 U1995 ( .A0(n2733), .A1(cycle_cnt_0_), .B0(n2734), .B1(n2845), .Y(
        n2319) );
  INVX1 U1996 ( .A(Enable), .Y(n2745) );
  OAI221X1 U1997 ( .A0(cycle_cntEn), .A1(n2607), .B0(RW_cnt), .B1(n2608), .C0(
        nextmain_state[1]), .Y(n2606) );
  INVX1 U1998 ( .A(PSRAMTCON[13]), .Y(n2593) );
  INVX1 U1999 ( .A(PSRAMTCON[12]), .Y(n2570) );
  INVX1 U2000 ( .A(PSRAMTCON[10]), .Y(n2574) );
  INVX1 U2001 ( .A(PSRAMTCON[9]), .Y(n2594) );
  INVX1 U2002 ( .A(PowerupSet), .Y(n2678) );
  XOR2X1 U2003 ( .A(n2866), .B(PSRAMTCON[5]), .Y(n2715) );
  XOR2X1 U2004 ( .A(n2845), .B(PSRAMTCON[4]), .Y(n2716) );
  XOR2X1 U2005 ( .A(n2846), .B(PSRAMTCON[6]), .Y(n2718) );
  XOR2X1 U2006 ( .A(n2866), .B(PSRAMTCON[25]), .Y(n2732) );
  NAND2BX1 U2007 ( .AN(hold_cnt_0_), .B(Hold), .Y(n2831) );
  NAND2BX1 U2008 ( .AN(RW_cnt), .B(n2627), .Y(n2681) );
  INVX1 U2009 ( .A(n2713), .Y(n2627) );
  NAND2BX1 U2010 ( .AN(n2586), .B(n2714), .Y(n2713) );
  AND4X1 U2011 ( .A(n2715), .B(n2716), .C(n2717), .D(n2718), .Y(n2714) );
  XOR2X1 U2012 ( .A(n2867), .B(PSRAMTCON[7]), .Y(n2717) );
  AO22X1 U2013 ( .A0(DATAIN[15]), .A1(n2925), .B0(PSRAMRDATA[31]), .B1(n2721), 
        .Y(n2320) );
  AO22X1 U2014 ( .A0(DATAIN[14]), .A1(n2924), .B0(PSRAMRDATA[30]), .B1(n2721), 
        .Y(n2321) );
  AO22X1 U2015 ( .A0(DATAIN[13]), .A1(n2720), .B0(PSRAMRDATA[29]), .B1(n2721), 
        .Y(n2322) );
  AO22X1 U2016 ( .A0(DATAIN[12]), .A1(n2925), .B0(PSRAMRDATA[28]), .B1(n2721), 
        .Y(n2323) );
  AO22X1 U2017 ( .A0(DATAIN[11]), .A1(n2924), .B0(PSRAMRDATA[27]), .B1(n2721), 
        .Y(n2324) );
  AO22X1 U2018 ( .A0(DATAIN[10]), .A1(n2720), .B0(PSRAMRDATA[26]), .B1(n2721), 
        .Y(n2325) );
  AO22X1 U2019 ( .A0(DATAIN[9]), .A1(n2925), .B0(PSRAMRDATA[25]), .B1(n2721), 
        .Y(n2326) );
  AO22X1 U2020 ( .A0(DATAIN[8]), .A1(n2924), .B0(PSRAMRDATA[24]), .B1(n2721), 
        .Y(n2327) );
  AO22X1 U2021 ( .A0(DATAIN[7]), .A1(n2720), .B0(PSRAMRDATA[23]), .B1(n2721), 
        .Y(n2328) );
  AO22X1 U2022 ( .A0(DATAIN[6]), .A1(n2925), .B0(PSRAMRDATA[22]), .B1(n2721), 
        .Y(n2329) );
  AO22X1 U2023 ( .A0(DATAIN[5]), .A1(n2924), .B0(PSRAMRDATA[21]), .B1(n2721), 
        .Y(n2330) );
  AO22X1 U2024 ( .A0(DATAIN[4]), .A1(n2720), .B0(PSRAMRDATA[20]), .B1(n2721), 
        .Y(n2331) );
  AO22X1 U2025 ( .A0(DATAIN[3]), .A1(n2925), .B0(PSRAMRDATA[19]), .B1(n2721), 
        .Y(n2332) );
  AO22X1 U2026 ( .A0(DATAIN[2]), .A1(n2924), .B0(PSRAMRDATA[18]), .B1(n2721), 
        .Y(n2333) );
  AO22X1 U2027 ( .A0(DATAIN[1]), .A1(n2925), .B0(PSRAMRDATA[17]), .B1(n2721), 
        .Y(n2334) );
  AO22X1 U2028 ( .A0(DATAIN[0]), .A1(n2925), .B0(PSRAMRDATA[16]), .B1(n2721), 
        .Y(n2335) );
  AO22X1 U2029 ( .A0(PADDR[21]), .A1(n2603), .B0(n2636), .B1(PreviousAdr_21_), 
        .Y(n2421) );
  AO22X1 U2030 ( .A0(PADDR[20]), .A1(n2923), .B0(n2636), .B1(PreviousAdr_20_), 
        .Y(n2422) );
  AO22X1 U2031 ( .A0(PADDR[19]), .A1(n2922), .B0(n2636), .B1(PreviousAdr_19_), 
        .Y(n2423) );
  AO22X1 U2032 ( .A0(PADDR[18]), .A1(n2603), .B0(n2636), .B1(PreviousAdr_18_), 
        .Y(n2424) );
  AO22X1 U2033 ( .A0(PADDR[17]), .A1(n2923), .B0(n2636), .B1(PreviousAdr_17_), 
        .Y(n2425) );
  AO22X1 U2034 ( .A0(PADDR[16]), .A1(n2922), .B0(n2636), .B1(PreviousAdr_16_), 
        .Y(n2426) );
  AO22X1 U2035 ( .A0(PADDR[15]), .A1(n2603), .B0(n2636), .B1(PreviousAdr_15_), 
        .Y(n2427) );
  AO22X1 U2036 ( .A0(PADDR[14]), .A1(n2923), .B0(n2636), .B1(PreviousAdr_14_), 
        .Y(n2428) );
  AO22X1 U2037 ( .A0(PADDR[13]), .A1(n2922), .B0(n2636), .B1(PreviousAdr_13_), 
        .Y(n2429) );
  AO22X1 U2038 ( .A0(PADDR[12]), .A1(n2603), .B0(n2636), .B1(PreviousAdr_12_), 
        .Y(n2430) );
  AO22X1 U2039 ( .A0(PADDR[11]), .A1(n2923), .B0(n2636), .B1(PreviousAdr_11_), 
        .Y(n2431) );
  AO22X1 U2040 ( .A0(PADDR[10]), .A1(n2923), .B0(n2636), .B1(PreviousAdr_10_), 
        .Y(n2432) );
  AO22X1 U2041 ( .A0(PADDR[9]), .A1(n2603), .B0(n2636), .B1(PreviousAdr_9_), 
        .Y(n2433) );
  AO22X1 U2042 ( .A0(PADDR[8]), .A1(n2923), .B0(n2636), .B1(PreviousAdr_8_), 
        .Y(n2434) );
  AO22X1 U2043 ( .A0(PADDR[7]), .A1(n2603), .B0(n2636), .B1(PreviousAdr_7_), 
        .Y(n2435) );
  AO22X1 U2044 ( .A0(PADDR[6]), .A1(n2603), .B0(n2636), .B1(PreviousAdr_6_), 
        .Y(n2436) );
  AO22X1 U2045 ( .A0(PADDR[5]), .A1(n2923), .B0(n2636), .B1(PreviousAdr_5_), 
        .Y(n2437) );
  AO22X1 U2046 ( .A0(PADDR[4]), .A1(n2923), .B0(n2636), .B1(PreviousAdr_4_), 
        .Y(n2438) );
  AO22X1 U2047 ( .A0(PADDR[3]), .A1(n2603), .B0(n2636), .B1(PreviousAdr_3_), 
        .Y(n2439) );
  AO22X1 U2048 ( .A0(PADDR[2]), .A1(n2923), .B0(n2636), .B1(PreviousAdr_2_), 
        .Y(n2440) );
  AO22X1 U2049 ( .A0(PADDR[1]), .A1(n2603), .B0(n2636), .B1(PreviousAdr_1_), 
        .Y(n2441) );
  AND4X1 U2050 ( .A(n2729), .B(n2730), .C(n2731), .D(n2732), .Y(n2723) );
  XOR2X1 U2051 ( .A(n2867), .B(PSRAMTCON[27]), .Y(n2729) );
  XOR2X1 U2052 ( .A(n2846), .B(PSRAMTCON[26]), .Y(n2730) );
  XOR2X1 U2053 ( .A(n2845), .B(PSRAMTCON[24]), .Y(n2731) );
  AND4X1 U2054 ( .A(n2726), .B(n2867), .C(n2727), .D(n2728), .Y(n2725) );
  XOR2X1 U2055 ( .A(n2846), .B(PSRAMTCON[20]), .Y(n2726) );
  XOR2X1 U2056 ( .A(n2866), .B(PSRAMTCON[19]), .Y(n2727) );
  XOR2X1 U2057 ( .A(n2845), .B(PSRAMTCON[18]), .Y(n2728) );
  AO22X1 U2058 ( .A0(PSRAMTOUT[9]), .A1(CSb), .B0(ToutCnt632_9_), .B1(n2822), 
        .Y(n2306) );
  XNOR2X1 U1_A_9 ( .A(ToutCnt[9]), .B(carry0), .Y(ToutCnt632_9_) );
  AO22X1 U2059 ( .A0(PSRAMTOUT[8]), .A1(CSb), .B0(ToutCnt632_8_), .B1(n2822), 
        .Y(n2307) );
  XNOR2X1 U1_A_8 ( .A(ToutCnt[8]), .B(carry1), .Y(ToutCnt632_8_) );
  AO22X1 U2060 ( .A0(PSRAMTOUT[7]), .A1(CSb), .B0(ToutCnt632_7_), .B1(n2822), 
        .Y(n2308) );
  XNOR2X1 U1_A_7 ( .A(ToutCnt[7]), .B(carry2), .Y(ToutCnt632_7_) );
  AO22X1 U2061 ( .A0(PSRAMTOUT[6]), .A1(CSb), .B0(ToutCnt632_6_), .B1(n2822), 
        .Y(n2309) );
  XNOR2X1 U1_A_6 ( .A(ToutCnt[6]), .B(carry3), .Y(ToutCnt632_6_) );
  AO22X1 U2062 ( .A0(PSRAMTOUT[5]), .A1(CSb), .B0(ToutCnt632_5_), .B1(n2822), 
        .Y(n2310) );
  XNOR2X1 U1_A_5 ( .A(ToutCnt[5]), .B(carry4), .Y(ToutCnt632_5_) );
  AO22X1 U2063 ( .A0(PSRAMTOUT[4]), .A1(CSb), .B0(ToutCnt632_4_), .B1(n2822), 
        .Y(n2311) );
  XNOR2X1 U1_A_4 ( .A(ToutCnt[4]), .B(carry5), .Y(ToutCnt632_4_) );
  AO22X1 U2064 ( .A0(PSRAMTOUT[3]), .A1(CSb), .B0(ToutCnt632_3_), .B1(n2822), 
        .Y(n2312) );
  XNOR2X1 U1_A_3 ( .A(ToutCnt[3]), .B(carry6), .Y(ToutCnt632_3_) );
  AO22X1 U2065 ( .A0(PSRAMTOUT[2]), .A1(CSb), .B0(ToutCnt632_2_), .B1(n2822), 
        .Y(n2313) );
  XNOR2X1 U1_A_2 ( .A(ToutCnt[2]), .B(carry7), .Y(ToutCnt632_2_) );
  AO22X1 U2066 ( .A0(PSRAMTOUT[1]), .A1(CSb), .B0(ToutCnt632_1_), .B1(n2822), 
        .Y(n2314) );
  XNOR2X1 U1_A_1 ( .A(ToutCnt[1]), .B(ToutCnt[0]), .Y(ToutCnt632_1_) );
  AO22X1 U2067 ( .A0(PSRAMTOUT[0]), .A1(CSb), .B0(n2822), .B1(n2894), .Y(n2315) );
  AO21X1 U2068 ( .A0(Hold), .A1(n2844), .B0(hold_cnt1034_0_), .Y(n2828) );
  OAI222X1 U2069 ( .A0(n2679), .A1(n2850), .B0(n2681), .B1(n2878), .C0(n2627), 
        .C1(n2285), .Y(n2384) );
  OAI222X1 U2070 ( .A0(n2679), .A1(n2851), .B0(n2681), .B1(n2879), .C0(n2627), 
        .C1(n2284), .Y(n2385) );
  OAI222X1 U2071 ( .A0(n2679), .A1(n2852), .B0(n2681), .B1(n2880), .C0(n2627), 
        .C1(n2283), .Y(n2386) );
  OAI222X1 U2072 ( .A0(n2679), .A1(n2853), .B0(n2681), .B1(n2881), .C0(n2627), 
        .C1(n2282), .Y(n2387) );
  OAI222X1 U2073 ( .A0(n2679), .A1(n2854), .B0(n2681), .B1(n2882), .C0(n2627), 
        .C1(n2281), .Y(n2388) );
  OAI222X1 U2074 ( .A0(n2679), .A1(n2855), .B0(n2681), .B1(n2883), .C0(n2627), 
        .C1(n2280), .Y(n2389) );
  OAI222X1 U2075 ( .A0(n2679), .A1(n2856), .B0(n2681), .B1(n2884), .C0(n2627), 
        .C1(n2294), .Y(n2390) );
  OAI222X1 U2076 ( .A0(n2679), .A1(n2857), .B0(n2681), .B1(n2885), .C0(n2627), 
        .C1(n2293), .Y(n2391) );
  OAI222X1 U2077 ( .A0(n2679), .A1(n2858), .B0(n2681), .B1(n2886), .C0(n2627), 
        .C1(n2292), .Y(n2392) );
  OAI222X1 U2078 ( .A0(n2679), .A1(n2859), .B0(n2681), .B1(n2887), .C0(n2627), 
        .C1(n2291), .Y(n2393) );
  OAI222X1 U2079 ( .A0(n2679), .A1(n2860), .B0(n2681), .B1(n2888), .C0(n2627), 
        .C1(n2290), .Y(n2394) );
  OAI222X1 U2080 ( .A0(n2679), .A1(n2861), .B0(n2681), .B1(n2889), .C0(n2627), 
        .C1(n2289), .Y(n2395) );
  OAI222X1 U2081 ( .A0(n2679), .A1(n2862), .B0(n2681), .B1(n2890), .C0(n2627), 
        .C1(n2288), .Y(n2396) );
  OAI222X1 U2082 ( .A0(n2679), .A1(n2863), .B0(n2681), .B1(n2891), .C0(n2627), 
        .C1(n2287), .Y(n2397) );
  OAI222X1 U2083 ( .A0(n2679), .A1(n2864), .B0(n2681), .B1(n2892), .C0(n2627), 
        .C1(n2286), .Y(n2398) );
  OAI222X1 U2084 ( .A0(n2679), .A1(n2865), .B0(n2681), .B1(n2893), .C0(n2627), 
        .C1(n2279), .Y(n2399) );
  AO22X1 U2085 ( .A0(nextmain_state[0]), .A1(n2595), .B0(ZZb), .B1(
        nextmain_state[1]), .Y(n2446) );
  AO22X1 U2086 ( .A0(PSRAMRDATA[31]), .A1(n2924), .B0(PSRAMRDATA[15]), .B1(
        n2721), .Y(n2336) );
  AO22X1 U2087 ( .A0(PSRAMRDATA[30]), .A1(n2924), .B0(PSRAMRDATA[14]), .B1(
        n2721), .Y(n2337) );
  AO22X1 U2088 ( .A0(PSRAMRDATA[29]), .A1(n2925), .B0(PSRAMRDATA[13]), .B1(
        n2721), .Y(n2338) );
  AO22X1 U2089 ( .A0(PSRAMRDATA[28]), .A1(n2924), .B0(PSRAMRDATA[12]), .B1(
        n2721), .Y(n2339) );
  AO22X1 U2090 ( .A0(PSRAMRDATA[27]), .A1(n2925), .B0(PSRAMRDATA[11]), .B1(
        n2721), .Y(n2340) );
  AO22X1 U2091 ( .A0(PSRAMRDATA[26]), .A1(n2925), .B0(PSRAMRDATA[10]), .B1(
        n2721), .Y(n2341) );
  AO22X1 U2092 ( .A0(PSRAMRDATA[25]), .A1(n2924), .B0(PSRAMRDATA[9]), .B1(
        n2721), .Y(n2342) );
  AO22X1 U2093 ( .A0(PSRAMRDATA[24]), .A1(n2924), .B0(PSRAMRDATA[8]), .B1(
        n2721), .Y(n2343) );
  AO22X1 U2094 ( .A0(PSRAMRDATA[23]), .A1(n2925), .B0(PSRAMRDATA[7]), .B1(
        n2721), .Y(n2344) );
  AO22X1 U2095 ( .A0(PSRAMRDATA[22]), .A1(n2924), .B0(PSRAMRDATA[6]), .B1(
        n2721), .Y(n2345) );
  AO22X1 U2096 ( .A0(PSRAMRDATA[21]), .A1(n2925), .B0(PSRAMRDATA[5]), .B1(
        n2721), .Y(n2346) );
  AO22X1 U2097 ( .A0(PSRAMRDATA[20]), .A1(n2925), .B0(PSRAMRDATA[4]), .B1(
        n2721), .Y(n2347) );
  AO22X1 U2098 ( .A0(PSRAMRDATA[19]), .A1(n2924), .B0(PSRAMRDATA[3]), .B1(
        n2721), .Y(n2348) );
  AO22X1 U2099 ( .A0(PSRAMRDATA[18]), .A1(n2924), .B0(PSRAMRDATA[2]), .B1(
        n2721), .Y(n2349) );
  AO22X1 U2100 ( .A0(PSRAMRDATA[17]), .A1(n2925), .B0(PSRAMRDATA[1]), .B1(
        n2721), .Y(n2350) );
  AO22X1 U2101 ( .A0(PSRAMRDATA[16]), .A1(n2924), .B0(PSRAMRDATA[0]), .B1(
        n2721), .Y(n2351) );
  OAI32X1 U2102 ( .A0(nDATAEN), .A1(hold_cnt_1_), .A2(n2877), .B0(n2844), .B1(
        n2831), .Y(hold_cnt1034_1_) );
  AO21X1 U2103 ( .A0(n2626), .A1(Hold), .B0(n2627), .Y(n2443) );
  NAND4BX1 U2104 ( .AN(n2628), .B(n2629), .C(n2630), .D(n2631), .Y(n2626) );
  XOR2X1 U2105 ( .A(n2844), .B(PSRAMTCON[1]), .Y(n2629) );
  XOR2X1 U2106 ( .A(n2875), .B(PSRAMTCON[3]), .Y(n2630) );
  OAI31X1 U2107 ( .A0(n2826), .A1(hold_cnt_3_), .A2(n2873), .B0(n2827), .Y(
        hold_cnt1034_3_) );
  AOI32X1 U2108 ( .A0(hold_cnt_3_), .A1(n2873), .A2(Hold), .B0(hold_cnt_3_), 
        .B1(n2828), .Y(n2827) );
  XOR2X1 U2109 ( .A(n2873), .B(PSRAMTCON[2]), .Y(n2631) );
  NAND3BX1 U2110 ( .AN(n2844), .B(hold_cnt_0_), .C(Hold), .Y(n2826) );
  XOR2X1 U2111 ( .A(hold_cnt_0_), .B(PSRAMTCON[0]), .Y(n2628) );
  AO22X1 U2112 ( .A0(PWDATA[31]), .A1(Write), .B0(PSRAMWDATA[31]), .B1(n2635), 
        .Y(n2352) );
  AO22X1 U2113 ( .A0(PWDATA[30]), .A1(Write), .B0(PSRAMWDATA[30]), .B1(n2635), 
        .Y(n2353) );
  AO22X1 U2114 ( .A0(PWDATA[29]), .A1(Write), .B0(PSRAMWDATA[29]), .B1(n2635), 
        .Y(n2354) );
  AO22X1 U2115 ( .A0(PWDATA[28]), .A1(Write), .B0(PSRAMWDATA[28]), .B1(n2635), 
        .Y(n2355) );
  AO22X1 U2116 ( .A0(PWDATA[27]), .A1(Write), .B0(PSRAMWDATA[27]), .B1(n2635), 
        .Y(n2356) );
  AO22X1 U2117 ( .A0(PWDATA[26]), .A1(Write), .B0(PSRAMWDATA[26]), .B1(n2635), 
        .Y(n2357) );
  AO22X1 U2118 ( .A0(PWDATA[25]), .A1(Write), .B0(PSRAMWDATA[25]), .B1(n2635), 
        .Y(n2358) );
  AO22X1 U2119 ( .A0(PWDATA[24]), .A1(Write), .B0(PSRAMWDATA[24]), .B1(n2635), 
        .Y(n2359) );
  AO22X1 U2120 ( .A0(PWDATA[23]), .A1(Write), .B0(PSRAMWDATA[23]), .B1(n2635), 
        .Y(n2360) );
  AO22X1 U2121 ( .A0(PWDATA[22]), .A1(Write), .B0(PSRAMWDATA[22]), .B1(n2635), 
        .Y(n2361) );
  AO22X1 U2122 ( .A0(PWDATA[21]), .A1(Write), .B0(PSRAMWDATA[21]), .B1(n2635), 
        .Y(n2362) );
  AO22X1 U2123 ( .A0(PWDATA[20]), .A1(Write), .B0(PSRAMWDATA[20]), .B1(n2635), 
        .Y(n2363) );
  AO22X1 U2124 ( .A0(PWDATA[19]), .A1(Write), .B0(PSRAMWDATA[19]), .B1(n2635), 
        .Y(n2364) );
  AO22X1 U2125 ( .A0(PWDATA[18]), .A1(Write), .B0(PSRAMWDATA[18]), .B1(n2635), 
        .Y(n2365) );
  AO22X1 U2126 ( .A0(PWDATA[17]), .A1(Write), .B0(PSRAMWDATA[17]), .B1(n2635), 
        .Y(n2366) );
  AO22X1 U2127 ( .A0(PWDATA[16]), .A1(Write), .B0(PSRAMWDATA[16]), .B1(n2635), 
        .Y(n2367) );
  AO22X1 U2128 ( .A0(PWDATA[15]), .A1(Write), .B0(PSRAMWDATA[15]), .B1(n2635), 
        .Y(n2368) );
  AO22X1 U2129 ( .A0(PWDATA[14]), .A1(Write), .B0(PSRAMWDATA[14]), .B1(n2635), 
        .Y(n2369) );
  AO22X1 U2130 ( .A0(PWDATA[13]), .A1(Write), .B0(PSRAMWDATA[13]), .B1(n2635), 
        .Y(n2370) );
  AO22X1 U2131 ( .A0(PWDATA[12]), .A1(Write), .B0(PSRAMWDATA[12]), .B1(n2635), 
        .Y(n2371) );
  AO22X1 U2132 ( .A0(PWDATA[11]), .A1(Write), .B0(PSRAMWDATA[11]), .B1(n2635), 
        .Y(n2372) );
  AO22X1 U2133 ( .A0(PWDATA[10]), .A1(Write), .B0(PSRAMWDATA[10]), .B1(n2635), 
        .Y(n2373) );
  AO22X1 U2134 ( .A0(PWDATA[9]), .A1(Write), .B0(PSRAMWDATA[9]), .B1(n2635), 
        .Y(n2374) );
  AO22X1 U2135 ( .A0(PWDATA[8]), .A1(Write), .B0(PSRAMWDATA[8]), .B1(n2635), 
        .Y(n2375) );
  AO22X1 U2136 ( .A0(PWDATA[7]), .A1(Write), .B0(PSRAMWDATA[7]), .B1(n2635), 
        .Y(n2376) );
  AO22X1 U2137 ( .A0(PWDATA[6]), .A1(Write), .B0(PSRAMWDATA[6]), .B1(n2635), 
        .Y(n2377) );
  AO22X1 U2138 ( .A0(PWDATA[5]), .A1(Write), .B0(PSRAMWDATA[5]), .B1(n2635), 
        .Y(n2378) );
  AO22X1 U2139 ( .A0(PWDATA[4]), .A1(Write), .B0(PSRAMWDATA[4]), .B1(n2635), 
        .Y(n2379) );
  AO22X1 U2140 ( .A0(PWDATA[3]), .A1(Write), .B0(PSRAMWDATA[3]), .B1(n2635), 
        .Y(n2380) );
  AO22X1 U2141 ( .A0(PWDATA[2]), .A1(Write), .B0(PSRAMWDATA[2]), .B1(n2635), 
        .Y(n2381) );
  AO22X1 U2142 ( .A0(PWDATA[1]), .A1(Write), .B0(PSRAMWDATA[1]), .B1(n2635), 
        .Y(n2382) );
  AO22X1 U2143 ( .A0(PWDATA[0]), .A1(Write), .B0(PSRAMWDATA[0]), .B1(n2635), 
        .Y(n2383) );
  AO22X1 U2144 ( .A0(hold_cnt_2_), .A1(n2828), .B0(n2829), .B1(n2873), .Y(
        hold_cnt1034_2_) );
  INVX1 U2145 ( .A(n2826), .Y(n2829) );
  AND4X1 U2146 ( .A(Enable), .B(n2753), .C(n2564), .D(n2832), .Y(DataRWAvail)
         );
  OAI31X1 U2147 ( .A0(n2833), .A1(cycle_cntEn), .A2(n2825), .B0(n2809), .Y(
        n2832) );
  OA21X2 U2148 ( .A0(Hold), .A1(n2586), .B0(n2744), .Y(n2833) );
  DFFRX1 cycle_cnt_reg_1_ ( .D(n2318), .CK(PCLK), .RN(PRESETn), .Q(
        cycle_cnt_1_), .QN(n2866) );
  DFFRX1 cycle_cnt_reg_0_ ( .D(n2319), .CK(PCLK), .RN(PRESETn), .Q(
        cycle_cnt_0_), .QN(n2845) );
  DFFSX1 rw_state_reg_0_ ( .D(nextrw_state_0_), .CK(PCLK), .SN(PRESETn), .Q(
        rw_state[0]), .QN(n2847) );
  DFFRX1 rw_state_reg_1_ ( .D(nextrw_state_1_), .CK(PCLK), .RN(PRESETn), .Q(
        rw_state[1]), .QN(n2868) );
  DFFRX1 rw_state_reg_2_ ( .D(nextrw_state_2_), .CK(PCLK), .RN(PRESETn), .Q(
        rw_state[2]), .QN(n2872) );
  DFFRX1 rw_state_reg_4_ ( .D(n2899), .CK(PCLK), .RN(PRESETn), .Q(rw_state[4]), 
        .QN(n2900) );
  DFFRX1 cycle_cnt_reg_2_ ( .D(n2317), .CK(PCLK), .RN(PRESETn), .Q(
        cycle_cnt_2_), .QN(n2846) );
  DFFRX1 rw_state_reg_3_ ( .D(nextrw_state_3_), .CK(PCLK), .RN(PRESETn), .Q(
        rw_state[3]), .QN(n2843) );
  DFFRX1 cycle_cnt_reg_3_ ( .D(n2316), .CK(PCLK), .RN(PRESETn), .Q(
        cycle_cnt_3_), .QN(n2867) );
  DFFRX1 PreviousAdr_reg_2_ ( .D(n2440), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_2_), .QN(n2870) );
  DFFRX1 PreviousAdr_reg_20_ ( .D(n2422), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_20_) );
  DFFRX1 PreviousAdr_reg_19_ ( .D(n2423), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_19_) );
  DFFRX1 PreviousAdr_reg_17_ ( .D(n2425), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_17_) );
  DFFRX1 PreviousAdr_reg_16_ ( .D(n2426), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_16_) );
  DFFRX1 PreviousAdr_reg_14_ ( .D(n2428), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_14_) );
  DFFRX1 PreviousAdr_reg_13_ ( .D(n2429), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_13_), .QN(n2896) );
  DFFRX1 PreviousAdr_reg_11_ ( .D(n2431), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_11_) );
  DFFRX1 PreviousAdr_reg_10_ ( .D(n2432), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_10_) );
  DFFRX1 PreviousAdr_reg_8_ ( .D(n2434), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_8_) );
  DFFRX1 PreviousAdr_reg_7_ ( .D(n2435), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_7_) );
  DFFRX1 PreviousAdr_reg_5_ ( .D(n2437), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_5_), .QN(n2897) );
  DFFRX1 PreviousAdr_reg_4_ ( .D(n2438), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_4_), .QN(n2898) );
  DFFRX1 PreviousAdr_reg_21_ ( .D(n2421), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_21_) );
  DFFRX1 PreviousAdr_reg_18_ ( .D(n2424), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_18_) );
  DFFRX1 PreviousAdr_reg_12_ ( .D(n2430), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_12_) );
  DFFRX1 PreviousAdr_reg_9_ ( .D(n2433), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_9_) );
  DFFRX1 PreviousAdr_reg_6_ ( .D(n2436), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_6_) );
  DFFRX1 PreviousAdr_reg_1_ ( .D(n2441), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_1_) );
  DFFRX1 RW_cnt_reg ( .D(n2442), .CK(PCLK), .RN(PRESETn), .Q(RW_cnt), .QN(
        n2848) );
  DFFRX1 main_state_reg_0_ ( .D(nextmain_state[0]), .CK(PCLK), .RN(PRESETn), 
        .Q(main_state[0]), .QN(n2876) );
  DFFRX1 PreviousAdr_reg_15_ ( .D(n2427), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_15_) );
  DFFRX1 PreviousAdr_reg_3_ ( .D(n2439), .CK(PCLK), .RN(PRESETn), .Q(
        PreviousAdr_3_) );
  DFFRX1 main_state_reg_1_ ( .D(nextmain_state[1]), .CK(PCLK), .RN(PRESETn), 
        .Q(main_state[1]) );
  DFFSX1 ToutCnt_reg_0_ ( .D(n2315), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[0]), 
        .QN(n2894) );
  DFFSX1 ToutCnt_reg_9_ ( .D(n2306), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[9])
         );
  DFFSX1 ToutCnt_reg_3_ ( .D(n2312), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[3])
         );
  DFFSX1 ToutCnt_reg_5_ ( .D(n2310), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[5]), 
        .QN(n2298) );
  DFFSX1 ToutCnt_reg_4_ ( .D(n2311), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[4]), 
        .QN(n2297) );
  DFFSX1 ToutCnt_reg_6_ ( .D(n2309), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[6]), 
        .QN(n2299) );
  DFFSX1 ToutCnt_reg_7_ ( .D(n2308), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[7]), 
        .QN(n2300) );
  DFFSX1 ToutCnt_reg_8_ ( .D(n2307), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[8]), 
        .QN(n2301) );
  DFFSX1 ToutCnt_reg_1_ ( .D(n2314), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[1]), 
        .QN(n2295) );
  DFFRX1 Hold_reg ( .D(n2443), .CK(PCLK), .RN(PRESETn), .Q(Hold), .QN(nDATAEN)
         );
  DFFRX1 hold_cnt_reg_0_ ( .D(hold_cnt1034_0_), .CK(PCLK), .RN(PRESETn), .Q(
        hold_cnt_0_), .QN(n2877) );
  DFFRX1 cycle_cntEn_reg ( .D(n2444), .CK(PCLK), .RN(PRESETn), .Q(cycle_cntEn), 
        .QN(n2871) );
  DFFRX1 hold_cnt_reg_1_ ( .D(hold_cnt1034_1_), .CK(PCLK), .RN(PRESETn), .Q(
        hold_cnt_1_), .QN(n2844) );
  DFFSX1 ToutCnt_reg_10_ ( .D(n2305), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[10])
         );
  DFFSX1 ToutCnt_reg_2_ ( .D(n2313), .CK(PCLK), .SN(PRESETn), .Q(ToutCnt[2]), 
        .QN(n2296) );
  DFFRX1 hold_cnt_reg_3_ ( .D(hold_cnt1034_3_), .CK(PCLK), .RN(PRESETn), .Q(
        hold_cnt_3_), .QN(n2875) );
  DFFRX1 hold_cnt_reg_2_ ( .D(hold_cnt1034_2_), .CK(PCLK), .RN(PRESETn), .Q(
        hold_cnt_2_), .QN(n2873) );
  DFFRX1 PSRAMWDATA_reg_31_ ( .D(n2352), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[31]), .QN(n2878) );
  DFFRX1 PSRAMWDATA_reg_30_ ( .D(n2353), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[30]), .QN(n2879) );
  DFFRX1 PSRAMWDATA_reg_29_ ( .D(n2354), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[29]), .QN(n2880) );
  DFFRX1 PSRAMWDATA_reg_28_ ( .D(n2355), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[28]), .QN(n2881) );
  DFFRX1 PSRAMWDATA_reg_27_ ( .D(n2356), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[27]), .QN(n2882) );
  DFFRX1 PSRAMWDATA_reg_26_ ( .D(n2357), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[26]), .QN(n2883) );
  DFFRX1 PSRAMWDATA_reg_25_ ( .D(n2358), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[25]), .QN(n2884) );
  DFFRX1 PSRAMWDATA_reg_24_ ( .D(n2359), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[24]), .QN(n2885) );
  DFFRX1 PSRAMWDATA_reg_23_ ( .D(n2360), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[23]), .QN(n2886) );
  DFFRX1 PSRAMWDATA_reg_22_ ( .D(n2361), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[22]), .QN(n2887) );
  DFFRX1 PSRAMWDATA_reg_21_ ( .D(n2362), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[21]), .QN(n2888) );
  DFFRX1 PSRAMWDATA_reg_20_ ( .D(n2363), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[20]), .QN(n2889) );
  DFFRX1 PSRAMWDATA_reg_19_ ( .D(n2364), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[19]), .QN(n2890) );
  DFFRX1 PSRAMWDATA_reg_18_ ( .D(n2365), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[18]), .QN(n2891) );
  DFFRX1 PSRAMWDATA_reg_17_ ( .D(n2366), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[17]), .QN(n2892) );
  DFFRX1 PSRAMWDATA_reg_16_ ( .D(n2367), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[16]), .QN(n2893) );
  DFFRX1 PSRAMWDATA_reg_15_ ( .D(n2368), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[15]), .QN(n2850) );
  DFFRX1 PSRAMWDATA_reg_14_ ( .D(n2369), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[14]), .QN(n2851) );
  DFFRX1 PSRAMWDATA_reg_13_ ( .D(n2370), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[13]), .QN(n2852) );
  DFFRX1 PSRAMWDATA_reg_12_ ( .D(n2371), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[12]), .QN(n2853) );
  DFFRX1 PSRAMWDATA_reg_11_ ( .D(n2372), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[11]), .QN(n2854) );
  DFFRX1 PSRAMWDATA_reg_10_ ( .D(n2373), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[10]), .QN(n2855) );
  DFFRX1 PSRAMWDATA_reg_9_ ( .D(n2374), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[9]), .QN(n2856) );
  DFFRX1 PSRAMWDATA_reg_8_ ( .D(n2375), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[8]), .QN(n2857) );
  DFFRX1 PSRAMWDATA_reg_7_ ( .D(n2376), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[7]), .QN(n2858) );
  DFFRX1 PSRAMWDATA_reg_6_ ( .D(n2377), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[6]), .QN(n2859) );
  DFFRX1 PSRAMWDATA_reg_5_ ( .D(n2378), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[5]), .QN(n2860) );
  DFFRX1 PSRAMWDATA_reg_4_ ( .D(n2379), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[4]), .QN(n2861) );
  DFFRX1 PSRAMWDATA_reg_3_ ( .D(n2380), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[3]), .QN(n2862) );
  DFFRX1 PSRAMWDATA_reg_2_ ( .D(n2381), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[2]), .QN(n2863) );
  DFFRX1 PSRAMWDATA_reg_1_ ( .D(n2382), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[1]), .QN(n2864) );
  DFFRX1 PSRAMWDATA_reg_0_ ( .D(n2383), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMWDATA[0]), .QN(n2865) );
  DFFRX1 PSRAMRDATA_reg_31_ ( .D(n2320), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[31]) );
  DFFRX1 PSRAMRDATA_reg_30_ ( .D(n2321), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[30]) );
  DFFRX1 PSRAMRDATA_reg_29_ ( .D(n2322), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[29]) );
  DFFRX1 PSRAMRDATA_reg_28_ ( .D(n2323), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[28]) );
  DFFRX1 PSRAMRDATA_reg_27_ ( .D(n2324), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[27]) );
  DFFRX1 PSRAMRDATA_reg_26_ ( .D(n2325), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[26]) );
  DFFRX1 PSRAMRDATA_reg_25_ ( .D(n2326), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[25]) );
  DFFRX1 PSRAMRDATA_reg_24_ ( .D(n2327), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[24]) );
  DFFRX1 PSRAMRDATA_reg_23_ ( .D(n2328), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[23]) );
  DFFRX1 PSRAMRDATA_reg_22_ ( .D(n2329), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[22]) );
  DFFRX1 PSRAMRDATA_reg_21_ ( .D(n2330), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[21]) );
  DFFRX1 PSRAMRDATA_reg_20_ ( .D(n2331), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[20]) );
  DFFRX1 PSRAMRDATA_reg_19_ ( .D(n2332), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[19]) );
  DFFRX1 PSRAMRDATA_reg_18_ ( .D(n2333), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[18]) );
  DFFRX1 PSRAMRDATA_reg_17_ ( .D(n2334), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[17]) );
  DFFRX1 PSRAMRDATA_reg_16_ ( .D(n2335), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[16]) );
  DFFRX1 PSRAMRDATA_reg_15_ ( .D(n2336), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[15]) );
  DFFRX1 PSRAMRDATA_reg_14_ ( .D(n2337), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[14]) );
  DFFRX1 PSRAMRDATA_reg_13_ ( .D(n2338), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[13]) );
  DFFRX1 PSRAMRDATA_reg_12_ ( .D(n2339), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[12]) );
  DFFRX1 PSRAMRDATA_reg_11_ ( .D(n2340), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[11]) );
  DFFRX1 PSRAMRDATA_reg_10_ ( .D(n2341), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[10]) );
  DFFRX1 PSRAMRDATA_reg_9_ ( .D(n2342), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[9]) );
  DFFRX1 PSRAMRDATA_reg_8_ ( .D(n2343), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[8]) );
  DFFRX1 PSRAMRDATA_reg_7_ ( .D(n2344), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[7]) );
  DFFRX1 PSRAMRDATA_reg_6_ ( .D(n2345), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[6]) );
  DFFRX1 PSRAMRDATA_reg_5_ ( .D(n2346), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[5]) );
  DFFRX1 PSRAMRDATA_reg_4_ ( .D(n2347), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[4]) );
  DFFRX1 PSRAMRDATA_reg_3_ ( .D(n2348), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[3]) );
  DFFRX1 PSRAMRDATA_reg_2_ ( .D(n2349), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[2]) );
  DFFRX1 PSRAMRDATA_reg_1_ ( .D(n2350), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[1]) );
  DFFRX1 PSRAMRDATA_reg_0_ ( .D(n2351), .CK(PCLK), .RN(PRESETn), .Q(
        PSRAMRDATA[0]) );
  DFFRX1 cur_ZZ_reg ( .D(n2446), .CK(PCLK), .RN(PRESETn), .Q(ZZb) );
  DFFSX1 cur_WE_reg ( .D(n2447), .CK(PCLK), .SN(PRESETn), .Q(WEb), .QN(n2304)
         );
  DFFSX1 cur_ULB_reg ( .D(n2449), .CK(PCLK), .SN(PRESETn), .Q(n2522), .QN(
        n2303) );
  DFFSX1 cur_OE_reg ( .D(n2448), .CK(PCLK), .SN(PRESETn), .Q(OEb), .QN(n2302)
         );
  DFFRX1 DATAOUT_reg_15_ ( .D(n2384), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[15]), 
        .QN(n2285) );
  DFFRX1 DATAOUT_reg_14_ ( .D(n2385), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[14]), 
        .QN(n2284) );
  DFFRX1 DATAOUT_reg_13_ ( .D(n2386), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[13]), 
        .QN(n2283) );
  DFFRX1 DATAOUT_reg_12_ ( .D(n2387), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[12]), 
        .QN(n2282) );
  DFFRX1 DATAOUT_reg_11_ ( .D(n2388), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[11]), 
        .QN(n2281) );
  DFFRX1 DATAOUT_reg_10_ ( .D(n2389), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[10]), 
        .QN(n2280) );
  DFFRX1 DATAOUT_reg_9_ ( .D(n2390), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[9]), 
        .QN(n2294) );
  DFFRX1 DATAOUT_reg_8_ ( .D(n2391), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[8]), 
        .QN(n2293) );
  DFFRX1 DATAOUT_reg_7_ ( .D(n2392), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[7]), 
        .QN(n2292) );
  DFFRX1 DATAOUT_reg_6_ ( .D(n2393), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[6]), 
        .QN(n2291) );
  DFFRX1 DATAOUT_reg_5_ ( .D(n2394), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[5]), 
        .QN(n2290) );
  DFFRX1 DATAOUT_reg_4_ ( .D(n2395), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[4]), 
        .QN(n2289) );
  DFFRX1 DATAOUT_reg_3_ ( .D(n2396), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[3]), 
        .QN(n2288) );
  DFFRX1 DATAOUT_reg_2_ ( .D(n2397), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[2]), 
        .QN(n2287) );
  DFFRX1 DATAOUT_reg_1_ ( .D(n2398), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[1]), 
        .QN(n2286) );
  DFFRX1 DATAOUT_reg_0_ ( .D(n2399), .CK(PCLK), .RN(PRESETn), .Q(DATAOUT[0]), 
        .QN(n2279) );
  AO21X1 U2149 ( .A0(n2921), .A1(n2643), .B0(n2663), .Y(n2400) );
  BUFX2 U2150 ( .A(ADDR[0]), .Y(n2901) );
  BUFX2 U2151 ( .A(ADDR[1]), .Y(n2902) );
  BUFX2 U2152 ( .A(ADDR[2]), .Y(n2903) );
  BUFX2 U2153 ( .A(ADDR[3]), .Y(n2904) );
  BUFX2 U2154 ( .A(ADDR[4]), .Y(n2905) );
  BUFX2 U2155 ( .A(ADDR[5]), .Y(n2906) );
  BUFX2 U2156 ( .A(ADDR[6]), .Y(n2907) );
  BUFX2 U2157 ( .A(ADDR[7]), .Y(n2908) );
  BUFX2 U2158 ( .A(ADDR[8]), .Y(n2909) );
  BUFX2 U2159 ( .A(ADDR[9]), .Y(n2910) );
  BUFX2 U2160 ( .A(ADDR[10]), .Y(n2911) );
  BUFX2 U2161 ( .A(ADDR[11]), .Y(n2912) );
  BUFX2 U2162 ( .A(ADDR[12]), .Y(n2913) );
  BUFX2 U2163 ( .A(ADDR[13]), .Y(n2914) );
  BUFX2 U2164 ( .A(ADDR[14]), .Y(n2915) );
  BUFX2 U2165 ( .A(ADDR[15]), .Y(n2916) );
  BUFX2 U2166 ( .A(ADDR[16]), .Y(n2917) );
  BUFX2 U2167 ( .A(ADDR[17]), .Y(n2918) );
  BUFX2 U2168 ( .A(ADDR[18]), .Y(n2919) );
  BUFX2 U2169 ( .A(ADDR[19]), .Y(n2920) );
  INVX1 U2170 ( .A(n2901), .Y(n2638) );
endmodule


module pmcon_MEMIF_ADDRESSWIDTH22 ( PCLK, PRESETn, PSEL, PENABLE, PREADY, 
        PWRITE, PADDR, PWDATA, PRDATA, DataRWAvail, Read, Write, PSRAMRDATA );
  input [21:0] PADDR;
  input [31:0] PWDATA;
  output [31:0] PRDATA;
  input [31:0] PSRAMRDATA;
  input PCLK, PRESETn, PSEL, PENABLE, PWRITE, DataRWAvail;
  output PREADY, Read, Write;
  wire   \PSRAMRDATA0[31] , \PSRAMRDATA0[30] , \PSRAMRDATA0[29] ,
         \PSRAMRDATA0[28] , \PSRAMRDATA0[27] , \PSRAMRDATA0[26] ,
         \PSRAMRDATA0[25] , \PSRAMRDATA0[24] , \PSRAMRDATA0[23] ,
         \PSRAMRDATA0[22] , \PSRAMRDATA0[21] , \PSRAMRDATA0[20] ,
         \PSRAMRDATA0[19] , \PSRAMRDATA0[18] , \PSRAMRDATA0[17] ,
         \PSRAMRDATA0[16] , \PSRAMRDATA0[15] , \PSRAMRDATA0[14] ,
         \PSRAMRDATA0[13] , \PSRAMRDATA0[12] , \PSRAMRDATA0[11] ,
         \PSRAMRDATA0[10] , \PSRAMRDATA0[9] , \PSRAMRDATA0[8] ,
         \PSRAMRDATA0[7] , \PSRAMRDATA0[6] , \PSRAMRDATA0[5] ,
         \PSRAMRDATA0[4] , \PSRAMRDATA0[3] , \PSRAMRDATA0[2] ,
         \PSRAMRDATA0[1] , \PSRAMRDATA0[0] , n98, n99;
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

  NOR3BX1 U24 ( .AN(PSEL), .B(PWRITE), .C(PENABLE), .Y(Read) );
  NOR3BX1 U25 ( .AN(PSEL), .B(n98), .C(PENABLE), .Y(Write) );
  INVX1 U26 ( .A(PWRITE), .Y(n98) );
  NOR2BX1 U27 ( .AN(DataRWAvail), .B(n99), .Y(PREADY) );
  INVX1 U28 ( .A(PENABLE), .Y(n99) );
endmodule


module pmcon_REGIF ( PCLK, PRESETn, PSEL, PENABLE, PWRITE, PADDR, PWDATA, 
        PRDATA, Enable, PowerupSet, PowerupClr, PageSize, BurstRMode, 
        PSRAMTCON, PSRAMTOUT );
  input [5:0] PADDR;
  input [31:0] PWDATA;
  output [31:0] PRDATA;
  output [2:0] PageSize;
  output [31:0] PSRAMTCON;
  output [10:0] PSRAMTOUT;
  input PCLK, PRESETn, PSEL, PENABLE, PWRITE;
  output Enable, PowerupSet, PowerupClr, BurstRMode;
  wire   nextPowerupSet, nextPowerupClr, n567, n568, n569, n570, n571, n572,
         n573, n574, n575, n576, n577, n578, n579, n580, n581, n582, n583,
         n584, n585, n586, n587, n588, n589, n590, n591, n592, n593, n594,
         n595, n596, n597, n598, n599, n600, n601, n602, n603, n604, n605,
         n606, n607, n608, n609, n610, n611, n612, n613, n614, n621, n623,
         n624, n625, n627, n628, n629, n633, n634, n636, n638, n640, n653,
         n654, n655, n657, n658, n659, n660, n661, n662, n663, n664, n665,
         n666, n667, n668, n669, n670, n671, n672, n673, n674, n675, n676,
         n677;
  wire   [31:0] NextPRDATA;

  NOR4X1 U491 ( .A(PADDR[5]), .B(PADDR[4]), .C(PADDR[3]), .D(n657), .Y(n668)
         );
  DFFRX1 Enable_reg ( .D(n613), .CK(PCLK), .RN(PRESETn), .Q(Enable), .QN(n658)
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
  INVX1 U492 ( .A(n627), .Y(n628) );
  INVX1 U493 ( .A(n624), .Y(n625) );
  INVX1 U494 ( .A(n640), .Y(n634) );
  INVX1 U495 ( .A(n636), .Y(n633) );
  INVX1 U496 ( .A(n621), .Y(n623) );
  NAND3BX1 U497 ( .AN(PADDR[1]), .B(PADDR[0]), .C(n653), .Y(n640) );
  NAND3BX1 U498 ( .AN(PADDR[0]), .B(PADDR[1]), .C(n674), .Y(n624) );
  NAND3BX1 U499 ( .AN(PADDR[1]), .B(PADDR[0]), .C(n674), .Y(n677) );
  NAND3BX1 U500 ( .AN(PADDR[1]), .B(PADDR[0]), .C(n674), .Y(n676) );
  NAND3BX1 U501 ( .AN(PADDR[1]), .B(PADDR[0]), .C(n674), .Y(n627) );
  NAND3BX1 U502 ( .AN(PADDR[0]), .B(PADDR[1]), .C(n653), .Y(n636) );
  NAND3BX1 U503 ( .AN(PADDR[1]), .B(n629), .C(n674), .Y(n621) );
  NAND2BX1 U504 ( .AN(PADDR[2]), .B(PSEL), .Y(n657) );
  NAND3BX1 U505 ( .AN(PADDR[1]), .B(n629), .C(n653), .Y(n638) );
  NOR2BX1 U506 ( .AN(PSRAMTCON[13]), .B(n640), .Y(NextPRDATA[13]) );
  NOR2BX1 U507 ( .AN(PSRAMTCON[16]), .B(n640), .Y(NextPRDATA[16]) );
  NOR2BX1 U508 ( .AN(PSRAMTCON[19]), .B(n640), .Y(NextPRDATA[19]) );
  NOR2BX1 U509 ( .AN(PSRAMTCON[22]), .B(n640), .Y(NextPRDATA[22]) );
  NOR2BX1 U510 ( .AN(PSRAMTCON[25]), .B(n640), .Y(NextPRDATA[25]) );
  AND3X2 U511 ( .A(PWRITE), .B(PENABLE), .C(n668), .Y(n674) );
  NOR2X1 U512 ( .A(PWDATA[1]), .B(n621), .Y(nextPowerupClr) );
  NOR2BX1 U513 ( .AN(PWDATA[1]), .B(n621), .Y(nextPowerupSet) );
  INVX1 U514 ( .A(n654), .Y(n653) );
  NAND3BX1 U515 ( .AN(PWRITE), .B(n655), .C(n668), .Y(n654) );
  INVX1 U516 ( .A(PENABLE), .Y(n655) );
  NAND3BX1 U517 ( .AN(PADDR[1]), .B(PADDR[0]), .C(n653), .Y(n675) );
  AO22X1 U518 ( .A0(PSRAMTCON[31]), .A1(n677), .B0(PWDATA[31]), .B1(n628), .Y(
        n570) );
  AO22X1 U519 ( .A0(PSRAMTCON[30]), .A1(n676), .B0(PWDATA[30]), .B1(n628), .Y(
        n571) );
  AO22X1 U520 ( .A0(PSRAMTCON[29]), .A1(n627), .B0(PWDATA[29]), .B1(n628), .Y(
        n572) );
  AO22X1 U521 ( .A0(PSRAMTCON[28]), .A1(n677), .B0(PWDATA[28]), .B1(n628), .Y(
        n573) );
  AO22X1 U522 ( .A0(PSRAMTCON[27]), .A1(n676), .B0(PWDATA[27]), .B1(n628), .Y(
        n574) );
  AO22X1 U523 ( .A0(PSRAMTCON[26]), .A1(n627), .B0(PWDATA[26]), .B1(n628), .Y(
        n575) );
  AO22X1 U524 ( .A0(PSRAMTCON[25]), .A1(n677), .B0(PWDATA[25]), .B1(n628), .Y(
        n576) );
  AO22X1 U525 ( .A0(PSRAMTCON[24]), .A1(n676), .B0(PWDATA[24]), .B1(n628), .Y(
        n577) );
  AO22X1 U526 ( .A0(PSRAMTCON[23]), .A1(n627), .B0(PWDATA[23]), .B1(n628), .Y(
        n578) );
  AO22X1 U527 ( .A0(PSRAMTCON[22]), .A1(n677), .B0(PWDATA[22]), .B1(n628), .Y(
        n579) );
  AO22X1 U528 ( .A0(PSRAMTCON[21]), .A1(n676), .B0(PWDATA[21]), .B1(n628), .Y(
        n580) );
  AO22X1 U529 ( .A0(PSRAMTCON[20]), .A1(n627), .B0(PWDATA[20]), .B1(n628), .Y(
        n581) );
  AO22X1 U530 ( .A0(PSRAMTCON[19]), .A1(n677), .B0(PWDATA[19]), .B1(n628), .Y(
        n582) );
  AO22X1 U531 ( .A0(PSRAMTCON[18]), .A1(n676), .B0(PWDATA[18]), .B1(n628), .Y(
        n583) );
  AO22X1 U532 ( .A0(PSRAMTCON[17]), .A1(n677), .B0(PWDATA[17]), .B1(n628), .Y(
        n584) );
  AO22X1 U533 ( .A0(PSRAMTCON[16]), .A1(n677), .B0(PWDATA[16]), .B1(n628), .Y(
        n585) );
  AO22X1 U534 ( .A0(PSRAMTCON[15]), .A1(n676), .B0(PWDATA[15]), .B1(n628), .Y(
        n586) );
  AO22X1 U535 ( .A0(PSRAMTCON[14]), .A1(n676), .B0(PWDATA[14]), .B1(n628), .Y(
        n587) );
  AO22X1 U536 ( .A0(PSRAMTCON[13]), .A1(n677), .B0(PWDATA[13]), .B1(n628), .Y(
        n588) );
  AO22X1 U537 ( .A0(PSRAMTCON[12]), .A1(n676), .B0(PWDATA[12]), .B1(n628), .Y(
        n589) );
  AO22X1 U538 ( .A0(PSRAMTCON[11]), .A1(n677), .B0(PWDATA[11]), .B1(n628), .Y(
        n590) );
  AO22X1 U539 ( .A0(PSRAMTOUT[10]), .A1(n624), .B0(PWDATA[10]), .B1(n625), .Y(
        n602) );
  AO22X1 U540 ( .A0(PSRAMTOUT[9]), .A1(n624), .B0(PWDATA[9]), .B1(n625), .Y(
        n603) );
  AO22X1 U541 ( .A0(PSRAMTOUT[8]), .A1(n624), .B0(PWDATA[8]), .B1(n625), .Y(
        n604) );
  AO22X1 U542 ( .A0(PSRAMTOUT[7]), .A1(n624), .B0(PWDATA[7]), .B1(n625), .Y(
        n605) );
  AO22X1 U543 ( .A0(PSRAMTOUT[6]), .A1(n624), .B0(PWDATA[6]), .B1(n625), .Y(
        n606) );
  AO22X1 U544 ( .A0(PSRAMTOUT[5]), .A1(n624), .B0(PWDATA[5]), .B1(n625), .Y(
        n607) );
  AO22X1 U545 ( .A0(PSRAMTOUT[4]), .A1(n624), .B0(PWDATA[4]), .B1(n625), .Y(
        n608) );
  AO22X1 U546 ( .A0(PSRAMTOUT[3]), .A1(n624), .B0(PWDATA[3]), .B1(n625), .Y(
        n609) );
  AO22X1 U547 ( .A0(PageSize[2]), .A1(n621), .B0(PWDATA[5]), .B1(n623), .Y(
        n567) );
  AO22X1 U548 ( .A0(PageSize[1]), .A1(n621), .B0(PWDATA[4]), .B1(n623), .Y(
        n568) );
  AO22X1 U549 ( .A0(PageSize[0]), .A1(n621), .B0(PWDATA[3]), .B1(n623), .Y(
        n569) );
  AO22X1 U550 ( .A0(Enable), .A1(n621), .B0(PWDATA[0]), .B1(n623), .Y(n613) );
  AO22X1 U551 ( .A0(BurstRMode), .A1(n621), .B0(PWDATA[2]), .B1(n623), .Y(n614) );
  AO22X1 U552 ( .A0(PSRAMTCON[10]), .A1(n677), .B0(n628), .B1(PWDATA[10]), .Y(
        n591) );
  AO22X1 U553 ( .A0(PSRAMTCON[9]), .A1(n676), .B0(n628), .B1(PWDATA[9]), .Y(
        n592) );
  AO22X1 U554 ( .A0(PSRAMTCON[8]), .A1(n676), .B0(n628), .B1(PWDATA[8]), .Y(
        n593) );
  AO22X1 U555 ( .A0(PSRAMTCON[7]), .A1(n677), .B0(n628), .B1(PWDATA[7]), .Y(
        n594) );
  AO22X1 U556 ( .A0(PSRAMTCON[6]), .A1(n676), .B0(n628), .B1(PWDATA[6]), .Y(
        n595) );
  AO22X1 U557 ( .A0(PSRAMTCON[5]), .A1(n677), .B0(n628), .B1(PWDATA[5]), .Y(
        n596) );
  AO22X1 U558 ( .A0(PSRAMTCON[4]), .A1(n677), .B0(n628), .B1(PWDATA[4]), .Y(
        n597) );
  AO22X1 U559 ( .A0(PSRAMTCON[3]), .A1(n676), .B0(n628), .B1(PWDATA[3]), .Y(
        n598) );
  AO22X1 U560 ( .A0(PSRAMTCON[2]), .A1(n676), .B0(n628), .B1(PWDATA[2]), .Y(
        n599) );
  AO22X1 U561 ( .A0(PSRAMTCON[1]), .A1(n677), .B0(n628), .B1(PWDATA[1]), .Y(
        n600) );
  AO22X1 U562 ( .A0(PSRAMTCON[0]), .A1(n676), .B0(n628), .B1(PWDATA[0]), .Y(
        n601) );
  AO22X1 U563 ( .A0(PSRAMTOUT[2]), .A1(n624), .B0(n625), .B1(PWDATA[2]), .Y(
        n610) );
  AO22X1 U564 ( .A0(PSRAMTOUT[1]), .A1(n624), .B0(n625), .B1(PWDATA[1]), .Y(
        n611) );
  AO22X1 U565 ( .A0(PSRAMTOUT[0]), .A1(n624), .B0(n625), .B1(PWDATA[0]), .Y(
        n612) );
  NOR2BX1 U566 ( .AN(PSRAMTCON[11]), .B(n640), .Y(NextPRDATA[11]) );
  NOR2BX1 U567 ( .AN(PSRAMTCON[12]), .B(n675), .Y(NextPRDATA[12]) );
  NOR2BX1 U568 ( .AN(PSRAMTCON[14]), .B(n675), .Y(NextPRDATA[14]) );
  NOR2BX1 U569 ( .AN(PSRAMTCON[15]), .B(n675), .Y(NextPRDATA[15]) );
  NOR2BX1 U570 ( .AN(PSRAMTCON[17]), .B(n675), .Y(NextPRDATA[17]) );
  NOR2BX1 U571 ( .AN(PSRAMTCON[18]), .B(n675), .Y(NextPRDATA[18]) );
  NOR2BX1 U572 ( .AN(PSRAMTCON[20]), .B(n675), .Y(NextPRDATA[20]) );
  NOR2BX1 U573 ( .AN(PSRAMTCON[21]), .B(n675), .Y(NextPRDATA[21]) );
  NOR2BX1 U574 ( .AN(PSRAMTCON[23]), .B(n640), .Y(NextPRDATA[23]) );
  NOR2BX1 U575 ( .AN(PSRAMTCON[24]), .B(n675), .Y(NextPRDATA[24]) );
  NOR2BX1 U576 ( .AN(PSRAMTCON[26]), .B(n675), .Y(NextPRDATA[26]) );
  NOR2BX1 U577 ( .AN(PSRAMTCON[27]), .B(n675), .Y(NextPRDATA[27]) );
  NOR2BX1 U578 ( .AN(PSRAMTCON[28]), .B(n675), .Y(NextPRDATA[28]) );
  NOR2BX1 U579 ( .AN(PSRAMTCON[29]), .B(n640), .Y(NextPRDATA[29]) );
  NOR2BX1 U580 ( .AN(PSRAMTCON[30]), .B(n675), .Y(NextPRDATA[30]) );
  NOR2BX1 U581 ( .AN(PSRAMTCON[31]), .B(n675), .Y(NextPRDATA[31]) );
  OAI222X1 U582 ( .A0(n669), .A1(n636), .B0(n658), .B1(n638), .C0(n663), .C1(
        n675), .Y(NextPRDATA[0]) );
  OAI222X1 U583 ( .A0(n670), .A1(n636), .B0(n662), .B1(n638), .C0(n664), .C1(
        n675), .Y(NextPRDATA[2]) );
  OAI222X1 U584 ( .A0(n671), .A1(n636), .B0(n661), .B1(n638), .C0(n665), .C1(
        n675), .Y(NextPRDATA[3]) );
  OAI222X1 U585 ( .A0(n672), .A1(n636), .B0(n660), .B1(n638), .C0(n666), .C1(
        n675), .Y(NextPRDATA[4]) );
  OAI222X1 U586 ( .A0(n673), .A1(n636), .B0(n659), .B1(n638), .C0(n667), .C1(
        n640), .Y(NextPRDATA[5]) );
  AO22X1 U587 ( .A0(n633), .A1(PSRAMTOUT[1]), .B0(n634), .B1(PSRAMTCON[1]), 
        .Y(NextPRDATA[1]) );
  AO22X1 U588 ( .A0(n633), .A1(PSRAMTOUT[6]), .B0(n634), .B1(PSRAMTCON[6]), 
        .Y(NextPRDATA[6]) );
  AO22X1 U589 ( .A0(n633), .A1(PSRAMTOUT[7]), .B0(n634), .B1(PSRAMTCON[7]), 
        .Y(NextPRDATA[7]) );
  AO22X1 U590 ( .A0(n633), .A1(PSRAMTOUT[8]), .B0(n634), .B1(PSRAMTCON[8]), 
        .Y(NextPRDATA[8]) );
  AO22X1 U591 ( .A0(n633), .A1(PSRAMTOUT[9]), .B0(n634), .B1(PSRAMTCON[9]), 
        .Y(NextPRDATA[9]) );
  AO22X1 U592 ( .A0(n633), .A1(PSRAMTOUT[10]), .B0(n634), .B1(PSRAMTCON[10]), 
        .Y(NextPRDATA[10]) );
  INVX1 U593 ( .A(PADDR[0]), .Y(n629) );
  DFFRX1 PageSize_reg_1_ ( .D(n568), .CK(PCLK), .RN(PRESETn), .Q(PageSize[1]), 
        .QN(n660) );
  DFFRX1 PageSize_reg_0_ ( .D(n569), .CK(PCLK), .RN(PRESETn), .Q(PageSize[0]), 
        .QN(n661) );
  DFFSX1 PSRAMTCON_reg_31_ ( .D(n570), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[31]) );
  DFFSX1 PSRAMTCON_reg_30_ ( .D(n571), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[30]) );
  DFFSX1 PSRAMTCON_reg_29_ ( .D(n572), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[29]) );
  DFFSX1 PSRAMTCON_reg_28_ ( .D(n573), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[28]) );
  DFFSX1 PSRAMTCON_reg_23_ ( .D(n578), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[23]) );
  DFFSX1 PSRAMTCON_reg_22_ ( .D(n579), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[22]) );
  DFFSX1 PSRAMTCON_reg_21_ ( .D(n580), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[21]) );
  DFFRX1 PageSize_reg_2_ ( .D(n567), .CK(PCLK), .RN(PRESETn), .Q(PageSize[2]), 
        .QN(n659) );
  DFFRX1 BurstRMode_reg ( .D(n614), .CK(PCLK), .RN(PRESETn), .Q(BurstRMode), 
        .QN(n662) );
  DFFSX1 PSRAMTCON_reg_17_ ( .D(n584), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[17]) );
  DFFSX1 PSRAMTCON_reg_16_ ( .D(n585), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[16]) );
  DFFSX1 PSRAMTCON_reg_15_ ( .D(n586), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[15]) );
  DFFSX1 PSRAMTCON_reg_14_ ( .D(n587), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[14]) );
  DFFSX1 PSRAMTCON_reg_10_ ( .D(n591), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[10]) );
  DFFSX1 PSRAMTCON_reg_9_ ( .D(n592), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[9]) );
  DFFSX1 PSRAMTCON_reg_13_ ( .D(n588), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[13]) );
  DFFSX1 PSRAMTCON_reg_11_ ( .D(n590), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[11]) );
  DFFSX1 PSRAMTCON_reg_12_ ( .D(n589), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[12]) );
  DFFRX1 PowerupSet_reg ( .D(nextPowerupSet), .CK(PCLK), .RN(PRESETn), .Q(
        PowerupSet) );
  DFFSX1 PSRAMTCON_reg_8_ ( .D(n593), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[8]) );
  DFFRX1 PowerupClr_reg ( .D(nextPowerupClr), .CK(PCLK), .RN(PRESETn), .Q(
        PowerupClr) );
  DFFSX1 PSRAMTCON_reg_5_ ( .D(n596), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[5]), .QN(n667) );
  DFFSX1 PSRAMTCON_reg_4_ ( .D(n597), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[4]), .QN(n666) );
  DFFSX1 PSRAMTCON_reg_7_ ( .D(n594), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[7]) );
  DFFSX1 PSRAMTCON_reg_6_ ( .D(n595), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[6]) );
  DFFSX1 PSRAMTCON_reg_27_ ( .D(n574), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[27]) );
  DFFSX1 PSRAMTCON_reg_26_ ( .D(n575), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[26]) );
  DFFSX1 PSRAMTCON_reg_25_ ( .D(n576), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[25]) );
  DFFSX1 PSRAMTCON_reg_24_ ( .D(n577), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[24]) );
  DFFSX1 PSRAMTCON_reg_20_ ( .D(n581), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[20]) );
  DFFSX1 PSRAMTCON_reg_19_ ( .D(n582), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[19]) );
  DFFSX1 PSRAMTCON_reg_18_ ( .D(n583), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTCON[18]) );
  DFFSX1 PSRAMTCON_reg_3_ ( .D(n598), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[3]), .QN(n665) );
  DFFSX1 PSRAMTCON_reg_2_ ( .D(n599), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[2]), .QN(n664) );
  DFFSX1 PSRAMTCON_reg_0_ ( .D(n601), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[0]), .QN(n663) );
  DFFSX1 PSRAMTOUT_reg_5_ ( .D(n607), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[5]), .QN(n673) );
  DFFSX1 PSRAMTOUT_reg_4_ ( .D(n608), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[4]), .QN(n672) );
  DFFSX1 PSRAMTOUT_reg_3_ ( .D(n609), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[3]), .QN(n671) );
  DFFSX1 PSRAMTOUT_reg_2_ ( .D(n610), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[2]), .QN(n670) );
  DFFSX1 PSRAMTOUT_reg_0_ ( .D(n612), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[0]), .QN(n669) );
  DFFSX1 PSRAMTCON_reg_1_ ( .D(n600), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTCON[1]) );
  DFFSX1 PSRAMTOUT_reg_10_ ( .D(n602), .CK(PCLK), .SN(PRESETn), .Q(
        PSRAMTOUT[10]) );
  DFFSX1 PSRAMTOUT_reg_9_ ( .D(n603), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[9]) );
  DFFSX1 PSRAMTOUT_reg_8_ ( .D(n604), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[8]) );
  DFFSX1 PSRAMTOUT_reg_7_ ( .D(n605), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[7]) );
  DFFSX1 PSRAMTOUT_reg_6_ ( .D(n606), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[6]) );
  DFFSX1 PSRAMTOUT_reg_1_ ( .D(n611), .CK(PCLK), .SN(PRESETn), .Q(PSRAMTOUT[1]) );
endmodule

