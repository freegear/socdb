
module SDRTop ( ARESETB, PORESETB, ACLK, FCLK, AWAddr, AWId, AWLen, AWValid, 
        AWReady, AWBurst, WLast, WStrb, WData, WValid, WReady, WId, BResp, 
        BValid, BReady, BId, ARAddr, ARId, ARLen, ARValid, ARReady, ARBurst, 
        RData, RValid, RReady, RLast, RId, RResp, SD_CKE, SD_CSB, SD_RASB, 
        SD_CASB, SD_WEB, SD_BADDR, SD_ADDR, SD_DQE, SD_DQI, SD_DQO, SD_DQM, 
        PRESETB, PSEL, PENABLE, PADDR, PWRITE, PWDATA, PRDATA );
  input [21:0] AWAddr;
  input [3:0] AWId;
  input [3:0] AWLen;
  input [1:0] AWBurst;
  input [3:0] WStrb;
  input [31:0] WData;
  input [3:0] WId;
  output [1:0] BResp;
  output [3:0] BId;
  input [21:0] ARAddr;
  input [3:0] ARId;
  input [3:0] ARLen;
  input [1:0] ARBurst;
  output [31:0] RData;
  output [3:0] RId;
  output [1:0] RResp;
  output [1:0] SD_BADDR;
  output [11:0] SD_ADDR;
  input [31:0] SD_DQI;
  output [31:0] SD_DQO;
  output [3:0] SD_DQM;
  input [7:2] PADDR;
  input [31:0] PWDATA;
  output [31:0] PRDATA;
  input ARESETB, PORESETB, ACLK, FCLK, AWValid, WLast, WValid, BReady, ARValid,
         RReady, PRESETB, PSEL, PENABLE, PWRITE;
  output AWReady, WReady, BValid, ARReady, RValid, RLast, SD_CKE, SD_CSB,
         SD_RASB, SD_CASB, SD_WEB, SD_DQE;
  wire   nACLK, PCLKReg, PCLK, RLastS, RValidS, RReadyS, RQFull, WQFull,
         BA_REQ, BA_RW, BA_PM, n_6, PCLKReg286;
  wire   [1:0] RRespS;
  wire   [31:0] RDataS;
  wire   [3:0] RIdS;
  wire   [13:0] BA_STS;
  wire   [21:0] BA_AA;
  wire   [3:0] BA_TT;
  wire   [3:0] BA_ID;
  assign BResp[1] = 1'b0;
  assign BResp[0] = 1'b0;

  INVX2 ACKBUF ( .A(ACLK), .Y(nACLK) );
  SDRRDS SDRRDS ( .ACLK(ACLK), .ARESETn(ARESETB), .INFORMATION_S({1'b0, 1'b0, 
        RLastS, RDataS, RIdS}), .VALID_S(RValidS), .READY_S(RReadyS), 
        .INFORMATION_R({RResp, RLast, RData, RId}), .VALID_R(RValid), 
        .READY_R(RReady) );
  SDRAi SDRAi ( .ARESETB(ARESETB), .PORESETB(PORESETB), .ACLK(ACLK), .nACLK(
        nACLK), .FCLK(FCLK), .AWAddr(AWAddr), .AWId(AWId), .AWLen(AWLen), 
        .AWValid(AWValid), .AWReady(AWReady), .AWBurst(AWBurst), .WLast(WLast), 
        .WStrb(WStrb), .WData(WData), .WValid(WValid), .WReady(WReady), .WId(
        WId), .BValid(BValid), .BReady(BReady), .BId(BId), .ARAddr(ARAddr), 
        .ARId(ARId), .ARLen(ARLen), .ARValid(ARValid), .ARReady(ARReady), 
        .ARBurst(ARBurst), .RData(RDataS), .RValid(RValidS), .RReady(RReadyS), 
        .RLast(RLastS), .RId(RIdS), .RQFull(RQFull), .WQFull(WQFull), .BA_STS(
        BA_STS), .BA_AA(BA_AA), .BA_REQ(BA_REQ), .BA_TT(BA_TT), .BA_RW(BA_RW), 
        .BA_ID(BA_ID), .BA_PM(BA_PM), .SD_DQE(SD_DQE), .SD_DQI(SD_DQI), 
        .SD_DQO(SD_DQO), .SD_DQM(SD_DQM) );
  SDRCtl SDRCtl ( .PORESETB(PORESETB), .ARESETB(ARESETB), .ACLK(ACLK), .BA_AA(
        BA_AA), .BA_TT(BA_TT), .BA_RW(BA_RW), .BA_REQ(BA_REQ), .BA_ID(BA_ID), 
        .BA_PM(BA_PM), .BA_STS(BA_STS), .RQFull(RQFull), .WQFull(n_6), 
        .SD_CKE(SD_CKE), .SD_CSB(SD_CSB), .SD_RASB(SD_RASB), .SD_CASB(SD_CASB), 
        .SD_WEB(SD_WEB), .SD_BADDR(SD_BADDR), .SD_ADDR(SD_ADDR), .PCLK(PCLK), 
        .PRESETB(PRESETB), .PSEL(PSEL), .PENABLE(PENABLE), .PADDR(PADDR), 
        .PWRITE(PWRITE), .PWDATA(PWDATA), .PRDATA(PRDATA) );
  AND2X2 U28 ( .A(WReady), .B(WQFull), .Y(n_6) );
  BUFX2 PCKBUF ( .A(PCLKReg), .Y(PCLK) );
  DFFRX1 PCLKReg_reg ( .D(PCLKReg286), .CK(ACLK), .RN(PORESETB), .Q(PCLKReg), 
        .QN(PCLKReg286) );
endmodule


module SDRCtl ( PORESETB, ARESETB, ACLK, BA_AA, BA_TT, BA_RW, BA_REQ, BA_ID, 
        BA_PM, BA_STS, RQFull, WQFull, SD_CKE, SD_CSB, SD_RASB, SD_CASB, 
        SD_WEB, SD_BADDR, SD_ADDR, PCLK, PRESETB, PSEL, PENABLE, PADDR, PWRITE, 
        PWDATA, PRDATA );
  input [21:0] BA_AA;
  input [3:0] BA_TT;
  input [3:0] BA_ID;
  output [13:0] BA_STS;
  output [1:0] SD_BADDR;
  output [11:0] SD_ADDR;
  input [7:2] PADDR;
  input [31:0] PWDATA;
  output [31:0] PRDATA;
  input PORESETB, ARESETB, ACLK, BA_RW, BA_REQ, BA_PM, RQFull, WQFull, PCLK,
         PRESETB, PSEL, PENABLE, PWRITE;
  output SD_CKE, SD_CSB, SD_RASB, SD_CASB, SD_WEB;
  wire   cmd_mask, tcl_2_, tcl_1_, AddrSwapEn, SDREnStatus, rs_state_2_,
         rs_state_1_, PwDnEn, SelfRefEn, pSD_CKE, ercmd_5_, ercmd_4_, ercmd_3_,
         ercmd_2_, ercmd_0_, refresh_cnt_15_, refresh_cnt_14_, refresh_cnt_13_,
         refresh_cnt_12_, refresh_cnt_11_, refresh_cnt_10_, refresh_cnt_9_,
         refresh_cnt_8_, refresh_cnt_7_, refresh_cnt_6_, refresh_cnt_5_,
         refresh_cnt_4_, refresh_cnt_3_, refresh_cnt_1_, cmd_full_d, i_ba_req,
         cas_0_final, cas_0_newrow, cas_empty, ras_empty, bf_0casbusy,
         bf_0rasbusy, bf_trasbusy, bf_0ready, bf_tready, bf_0idle, bf_0last,
         bf_1casbusy, bf_1rasbusy, bf_1ready, bf_1idle, bf_1last, bf_2casbusy,
         bf_2rasbusy, bf_2ready, bf_2idle, bf_2last, bf_3casbusy, bf_3rasbusy,
         bf_3ready, bf_3idle, bf_3last, cas_0_rw, rw_bstop0, rw_bstop1,
         do_valid_3, do_valid_2, do_valid_1, do_valid_0, bf_last_3, bf_last_2,
         bf_last_1, cas_pm_0, cas_0_pm, pttn5134_3_, pttn5134_2_, pttn5134_1_,
         pttn5134_0_, iSD_CSB, iSD_RASB, iSD_CASB, iSD_WEB, iSD_CKE, cas_full,
         closing, ras_full, SDREn, PRDATA465_31_, PRDATA465_30_, PRDATA465_29_,
         PRDATA465_28_, PRDATA465_27_, PRDATA465_26_, PRDATA465_25_,
         PRDATA465_24_, PRDATA465_23_, PRDATA465_22_, PRDATA465_21_,
         PRDATA465_20_, PRDATA465_19_, PRDATA465_18_, PRDATA465_17_,
         PRDATA465_16_, PRDATA465_15_, PRDATA465_14_, PRDATA465_13_,
         PRDATA465_12_, PRDATA465_11_, PRDATA465_10_, PRDATA465_9_,
         PRDATA465_8_, PRDATA465_7_, PRDATA465_6_, PRDATA465_5_, PRDATA465_4_,
         PRDATA465_3_, PRDATA465_2_, PRDATA465_1_, PRDATA465_0_,
         PwDnCnt614_15_, PwDnCnt614_14_, PwDnCnt614_13_, PwDnCnt614_12_,
         PwDnCnt614_11_, PwDnCnt614_10_, PwDnCnt614_9_, PwDnCnt614_8_,
         PwDnCnt614_7_, PwDnCnt614_6_, PwDnCnt614_5_, PwDnCnt614_4_,
         PwDnCnt614_3_, PwDnCnt614_2_, PwDnCnt614_1_, selfref_cnt2159_4_,
         selfref_cnt2159_3_, selfref_cnt2159_2_, selfref_cnt2159_1_,
         refresh_cnt2473_15_, refresh_cnt2473_14_, refresh_cnt2473_13_,
         refresh_cnt2473_12_, refresh_cnt2473_11_, refresh_cnt2473_10_,
         refresh_cnt2473_9_, refresh_cnt2473_8_, refresh_cnt2473_7_,
         refresh_cnt2473_6_, refresh_cnt2473_5_, refresh_cnt2473_4_,
         refresh_cnt2473_3_, refresh_cnt2473_2_, refresh_cnt2473_1_,
         refresh_cnt2536_14_, refresh_cnt2536_13_, refresh_cnt2536_12_,
         refresh_cnt2536_11_, refresh_cnt2536_10_, refresh_cnt2536_0_,
         n2878_3_, do_valid_04735, do_valid4741, do_id4870_3_, do_id4870_2_,
         do_id4870_1_, do_id4870_0_, bf_last_15011, bf_last_05017, bf_last5023,
         n7473, n7962, n7963, n7964, n7965, n7966, n7967, n7968, n7969, n7970,
         n7971, n7972, n7973, n7974, n7975, n7976, n7977, n7978, n7979, n7980,
         n7981, n7982, n7983, n7984, n7985, n7986, n7987, n7988, n7989, n7990,
         n7991, n7992, n7993, n7994, n7995, n7996, n7997, n7998, n7999, n8000,
         n8001, n8002, n8003, n8004, n8005, n8006, n8007, n8008, n8009, n8010,
         n8011, n8012, n8013, n8014, n8015, n8016, n8017, n8018, n8019, n8020,
         n8021, n8022, n8023, n8024, n8025, n8026, n8027, n8028, n8029, n8030,
         n8031, n8032, n8033, n8034, n8035, n8036, n8037, n8038, n8039, n8040,
         n8041, n8042, n8043, n8044, n8045, n8046, n8047, n8048, n8049, n8050,
         n8051, n8052, n8053, n8054, n8055, n8056, n8057, n8058, n8059, n8060,
         n8061, n8062, n8063, n8064, n8065, n8066, n8067, n8068, n8069, n8070,
         n8071, n8072, n8073, n8074, n8075, n8076, n8077, n8078, n8079, n8080,
         n8081, n8082, n8083, n8084, n8085, n8086, n8087, n8088, n8089, n8090,
         n8091, n8092, n8093, n8094, n8095, n8096, n8097, n8098, n8099, n8100,
         n8101, n8102, n8103, n8293, n8294, n8295, n8296, n8297, n8301, n8302,
         carry, carry0, carry1, carry2, carry3, carry4, carry5, carry6, carry7,
         carry8, carry9, carry10, carry11, carry12, carry13, carry14, carry15,
         carry16, carry17, carry18, carry19, carry20, carry21, carry22,
         carry23, carry24, carry25, carry26, carry27, carry28, carry_10_, n6,
         n8394, n8396, n8398, n8399, n8400, n8404, n8406, n8408, n8409, n8411,
         n8414, n8416, n8417, n8420, n8421, n8422, n8423, n8425, n8428, n8432,
         n8433, n8438, n8439, n8441, n8442, n8443, n8448, n8449, n8451, n8452,
         n8463, n8467, n8468, n8470, n8472, n8473, n8474, n8475, n8476, n8477,
         n8478, n8479, n8480, n8481, n8482, n8483, n8484, n8498, n8499, n8500,
         n8501, n8502, n8503, n8506, n8507, n8508, n8509, n8510, n8511, n8512,
         n8513, n8514, n8515, n8516, n8517, n8519, n8520, n8521, n8522, n8523,
         n8524, n8525, n8526, n8527, n8528, n8531, n8533, n8535, n8537, n8539,
         n8541, n8542, n8543, n8545, n8546, n8547, n8548, n8549, n8550, n8551,
         n8552, n8554, n8556, n8557, n8558, n8559, n8560, n8562, n8563, n8564,
         n8565, n8566, n8569, n8570, n8572, n8573, n8574, n8575, n8576, n8577,
         n8578, n8579, n8580, n8581, n8582, n8585, n8586, n8588, n8589, n8590,
         n8591, n8592, n8593, n8594, n8595, n8596, n8597, n8598, n8599, n8601,
         n8602, n8603, n8604, n8605, n8606, n8607, n8608, n8610, n8611, n8612,
         n8613, n8614, n8616, n8617, n8619, n8620, n8621, n8622, n8623, n8624,
         n8625, n8630, n8631, n8632, n8633, n8634, n8636, n8637, n8639, n8640,
         n8641, n8642, n8643, n8644, n8645, n8646, n8647, n8648, n8649, n8650,
         n8653, n8654, n8656, n8657, n8658, n8659, n8660, n8663, n8664, n8668,
         n8669, n8671, n8672, n8673, n8674, n8675, n8676, n8677, n8678, n8705,
         n8711, n8712, n8714, n8715, n8717, n8719, n8721, n8723, n8724, n8725,
         n8727, n8728, n8729, n8732, n8735, n8741, n8743, n8744, n8746, n8747,
         n8749, n8751, n8753, n8755, n8757, n8758, n8759, n8761, n8762, n8763,
         n8764, n8765, n8766, n8767, n8769, n8770, n8771, n8775, n8787, n8788,
         n8789, n8790, n8791, n8792, n8798, n8800, n8802, n8803, n8804, n8805,
         n8806, n8807, n8808, n8809, n8810, n8811, n8812, n8813, n8814, n8815,
         n8816, n8817, n8818, n8819, n8820, n8821, n8822, n8823, n8824, n8847,
         n8848, n8849, n8850, n8851, n8852, n8858, n8860, n8862, n8863, n8864,
         n8866, n8867, n8868, n8887, n8889, n8891, n8895, n8896, n8907, n8913,
         n8914, n8915, n8916, n8917, n8918, n8919, n8936, n8937, n8938, n8940,
         n8941, n8943, n8951, n8967, n8971, n8972, n8973, n8974, n8975, n8976,
         n8977, n8978, n8979, n8980, n8981, n8982, n8983, n8984, n8985, n8986,
         n8987, n8988, n8989, n8990, n8991, n8992, n8993, n8994, n8995, n8996,
         n8997, n8998, n8999, n9000, n9001, n9002, n9003, n9004, n9005, n9006,
         n9007, n9008, n9009, n9010, n9011, n9012, n9013, n9014, n9015, n9016,
         n9017, n9018, n9019, n9020, n9021, n9022, n9023, n9024, n9025, n9026,
         n9027, n9028, n9029, n9030, n9031, n9032, n9033, n9034, n9035, n9036,
         n9037, n9038, n9039, n9040, n9041, n9042, n9043, n9044, n9045, n9046,
         n9047, n9048, n9049, n9050, n9051, n9052, n9053, n9054, n9055, n9056,
         n9057, n9058, n9059, n9060, n9061, n9062, n9063, n9064, n9065, n9066,
         n9067, n9068, n9069, n9070, n9071, n9072, n9073, n9074, n9075, n9076,
         n9077, n9078, n9079, n9080, n9081, n9082, n9083, n9084, n9085, n9086,
         n9087, n9088, n9089, n9090, n9091, n9092, n9093, n9094, n9095, n9096,
         n9097, n9098, n9099, n9100, n9101, n9102, n9103, n9104, n9105, n9106,
         n9107, n9108, n9109, n9110, n9111, n9112, n9113, n9114, n9115, n9116,
         n9117, n9118, n9119, n9120, n9121, n9122, n9123, n9124, n9125, n9126,
         n9127, n9128, n9129, n9130, n9131, n9132, n9133, n9134, n9135, n9136,
         n9137, n9138, n9139, n9140, n9141, n9142, n9143, n9144, n9145, n9146,
         n9147, n9148, n9149, n9150, n9151, n9152, n9153, n9154, n9155, n9156,
         n9157, n9158, n9159, n9160, n9161, n9162, n9163, n9164, n9165, n9166,
         n9167, n9168, n9169, n9170, n9171, n9172, n9173, n9174, n9175, n9176,
         n9177, n9178, n9179, n9180, n9181, n9182, n9183, n9184, n9185, n9186,
         n9187, n9188, n9189, n9190, n9191, n9192, n9193, n9194, n9195, n9196,
         n9197, n9198, n9199, n9200, n9201, n9202, n9203, n9204, n9205, n9206,
         n9207, n9208, n9209, n9210, n9211, n9212, n9213, n9214, n9215, n9216,
         n9217, n9218, n9219, n9220, n9221, n9222, n9223, n9224, n9225, n9226,
         n9227, n9228, n9229, n9230, n9231, n9232, n9233, n9234, n9235, n9236,
         n9237, n9238, n9239, n9240, n9241, n9242, n9243, n9244, n9245, n9246,
         n9247, n9248, n9249, n9250, n9251, n9252, n9253, n9254, n9255, n9256,
         n9257, n9258, n9259, n9260, n9261, n9262, n9263, n9264, n9265, n9266,
         n9267, n9268, n9269, n9270, n9271, n9272, n9273, n9274, n9275, n9276,
         n9277, n9278, n9279, n9280, n9281, n9282, n9283, n9284, n9285, n9286,
         n9287, n9288, n9289, n9290, n9291, n9292, n9293, n9294, n9295, n9296,
         n9297, n9298, n9299, n9300, n9301, n9302, n9303, n9304, n9305, n9306,
         n9307, n9308, n9309, n9310, n9311, n9312, n9313, n9314, n9315, n9316,
         n9317, n9318, n9319, n9320, n9321, n9322, n9323, n9324, n9325, n9326,
         n9327, n9328, n9329, n9330, n9331, n9332, n9333, n9334, n9335, n9336,
         n9337, n9338, n9339, n9340, n9341, n9342, n9343, net1598, net1588,
         net1587, net1585;
  wire   [3:0] trc;
  wire   [3:0] trasmin;
  wire   [1:0] trcd;
  wire   [1:0] trp;
  wire   [15:0] PwDnCnt;
  wire   [2:0] stable_cnt;
  wire   [3:0] refreshno;
  wire   [15:0] trefresh;
  wire   [15:0] PwDnRef;
  wire   [3:0] ar_cnt;
  wire   [1:0] trp_cnt;
  wire   [3:0] trc_cnt;
  wire   [1:0] tmrs_cnt;
  wire   [1:0] BA_BA;
  wire   [11:0] BA_RA;
  wire   [1:0] cas_0_ba;
  wire   [11:0] cas_0_ra;
  wire   [3:0] cas_0_tt;
  wire   [12:0] b0_last_ra;
  wire   [1:0] ras_0_ba;
  wire   [11:0] ras_0_ra;
  wire   [3:0] ras_0_tt;
  wire   [5:0] bf_0reqcmd;
  wire   [5:0] bf_0cmd;
  wire   [6:0] ecmd;
  wire   [12:0] b1_last_ra;
  wire   [5:0] bf_1reqcmd;
  wire   [5:0] bf_1cmd;
  wire   [12:0] b2_last_ra;
  wire   [5:0] bf_2reqcmd;
  wire   [5:0] bf_2cmd;
  wire   [12:0] b3_last_ra;
  wire   [5:0] bf_3reqcmd;
  wire   [5:0] bf_3cmd;
  wire   [1:0] last_ba;
  wire   [3:0] do_id_3;
  wire   [3:0] do_id_2;
  wire   [3:0] do_id_1;
  wire   [3:0] do_id_0;
  wire   [7:0] cas_0_ca;
  wire   [11:0] iSD_ADDR;
  wire   [1:0] iSD_BADDR;
  wire   [3:0] cas_0_id;

  SDRBsm_3 B0SM ( .ARESETB(ARESETB), .ACLK(ACLK), .TRP(trp), .TRRD({1'b0, 1'b1}), .TRCD(trcd), .TRASMIN(trasmin), .BA_BA(BA_BA), .BA_RA(BA_RA), .BA_TT(BA_TT), 
        .BA_REQ(i_ba_req), .CAS_0_BA(cas_0_ba), .CAS_0_RA(cas_0_ra), 
        .CAS_0_TT(cas_0_tt), .CAS_0_FINAL(cas_0_final), .CAS_0_NEWROW(
        cas_0_newrow), .CAS_EMPTY(cas_empty), .LAST_RA(b0_last_ra), .RAS_0_BA(
        ras_0_ba), .RAS_0_RA(ras_0_ra), .RAS_0_TT(ras_0_tt), .RAS_EMPTY(
        ras_empty), .BF_NO({1'b0, 1'b0}), .BF_CASBUSY(bf_0casbusy), 
        .BF_TCASBUSY(n9333), .BF_RASBUSY(bf_0rasbusy), .BF_TRASBUSY(
        bf_trasbusy), .BF_READY(bf_0ready), .BF_TREADY(bf_tready), .BF_IDLE(
        bf_0idle), .BF_LAST(bf_0last), .BF_REQCMD(bf_0reqcmd), .BF_CMD(bf_0cmd), .ERCMD({ercmd_5_, ercmd_4_, ercmd_3_, ercmd_2_, n9343, ercmd_0_}), .ECMD(
        ecmd) );
  SDRBsm_2 B1SM ( .ARESETB(ARESETB), .ACLK(ACLK), .TRP(trp), .TRRD({1'b0, 1'b1}), .TRCD(trcd), .TRASMIN(trasmin), .BA_BA(BA_BA), .BA_RA(BA_RA), .BA_TT(BA_TT), 
        .BA_REQ(i_ba_req), .CAS_0_BA(cas_0_ba), .CAS_0_RA(cas_0_ra), 
        .CAS_0_TT(cas_0_tt), .CAS_0_FINAL(cas_0_final), .CAS_0_NEWROW(
        cas_0_newrow), .CAS_EMPTY(cas_empty), .LAST_RA(b1_last_ra), .RAS_0_BA(
        ras_0_ba), .RAS_0_RA(ras_0_ra), .RAS_0_TT(ras_0_tt), .RAS_EMPTY(
        ras_empty), .BF_NO({1'b0, 1'b1}), .BF_CASBUSY(bf_1casbusy), 
        .BF_TCASBUSY(n9333), .BF_RASBUSY(bf_1rasbusy), .BF_TRASBUSY(
        bf_trasbusy), .BF_READY(bf_1ready), .BF_TREADY(bf_tready), .BF_IDLE(
        bf_1idle), .BF_LAST(bf_1last), .BF_REQCMD(bf_1reqcmd), .BF_CMD(bf_1cmd), .ERCMD({ercmd_5_, ercmd_4_, ercmd_3_, ercmd_2_, n9343, ercmd_0_}), .ECMD(
        ecmd) );
  SDRBsm_1 B2SM ( .ARESETB(ARESETB), .ACLK(ACLK), .TRP(trp), .TRRD({1'b0, 1'b1}), .TRCD(trcd), .TRASMIN(trasmin), .BA_BA(BA_BA), .BA_RA(BA_RA), .BA_TT(BA_TT), 
        .BA_REQ(i_ba_req), .CAS_0_BA(cas_0_ba), .CAS_0_RA(cas_0_ra), 
        .CAS_0_TT(cas_0_tt), .CAS_0_FINAL(cas_0_final), .CAS_0_NEWROW(
        cas_0_newrow), .CAS_EMPTY(cas_empty), .LAST_RA(b2_last_ra), .RAS_0_BA(
        ras_0_ba), .RAS_0_RA(ras_0_ra), .RAS_0_TT(ras_0_tt), .RAS_EMPTY(
        ras_empty), .BF_NO({1'b1, 1'b0}), .BF_CASBUSY(bf_2casbusy), 
        .BF_TCASBUSY(n9333), .BF_RASBUSY(bf_2rasbusy), .BF_TRASBUSY(
        bf_trasbusy), .BF_READY(bf_2ready), .BF_TREADY(bf_tready), .BF_IDLE(
        bf_2idle), .BF_LAST(bf_2last), .BF_REQCMD(bf_2reqcmd), .BF_CMD(bf_2cmd), .ERCMD({ercmd_5_, ercmd_4_, ercmd_3_, ercmd_2_, n9343, ercmd_0_}), .ECMD(
        ecmd) );
  SDRBsm_0 B3SM ( .ARESETB(ARESETB), .ACLK(ACLK), .TRP(trp), .TRRD({1'b0, 1'b1}), .TRCD(trcd), .TRASMIN(trasmin), .BA_BA(BA_BA), .BA_RA(BA_RA), .BA_TT(BA_TT), 
        .BA_REQ(i_ba_req), .CAS_0_BA(cas_0_ba), .CAS_0_RA(cas_0_ra), 
        .CAS_0_TT(cas_0_tt), .CAS_0_FINAL(cas_0_final), .CAS_0_NEWROW(
        cas_0_newrow), .CAS_EMPTY(cas_empty), .LAST_RA(b3_last_ra), .RAS_0_BA(
        ras_0_ba), .RAS_0_RA(ras_0_ra), .RAS_0_TT(ras_0_tt), .RAS_EMPTY(
        ras_empty), .BF_NO({1'b1, 1'b1}), .BF_CASBUSY(bf_3casbusy), 
        .BF_TCASBUSY(n9333), .BF_RASBUSY(bf_3rasbusy), .BF_TRASBUSY(
        bf_trasbusy), .BF_READY(bf_3ready), .BF_TREADY(bf_tready), .BF_IDLE(
        bf_3idle), .BF_LAST(bf_3last), .BF_REQCMD(bf_3reqcmd), .BF_CMD(bf_3cmd), .ERCMD({ercmd_5_, ercmd_4_, ercmd_3_, ercmd_2_, n9343, ercmd_0_}), .ECMD(
        ecmd) );
  SDRCas CasQ ( .ARESETB(ARESETB), .ACLK(ACLK), .BA_BA(BA_BA), .BA_RA(BA_RA), 
        .BA_CA(BA_AA[7:0]), .BA_TT(BA_TT), .BA_ID(BA_ID), .BA_RW(BA_RW), 
        .BA_REQ(i_ba_req), .BA_PM(BA_PM), .CMD(ecmd[5:0]), .B0_LAST_RA(
        b0_last_ra), .B1_LAST_RA(b1_last_ra), .B2_LAST_RA(b2_last_ra), 
        .B3_LAST_RA(b3_last_ra), .CAS_0_BA(cas_0_ba), .CAS_0_RA(cas_0_ra), 
        .CAS_0_CA(cas_0_ca), .CAS_0_TT(cas_0_tt), .CAS_0_ID(cas_0_id), 
        .CAS_0_RW(cas_0_rw), .CAS_0_PM(cas_0_pm), .CAS_0_FINAL(cas_0_final), 
        .CAS_0_NEWROW(cas_0_newrow), .CAS_EMPTY(cas_empty), .CAS_FULL(cas_full) );
  SDRRas RasQ ( .ARESETB(ARESETB), .ACLK(ACLK), .BA_BA(BA_BA), .BA_RA(BA_RA), 
        .BA_TT(BA_TT), .BA_REQ(i_ba_req), .CMD(ecmd[5:0]), .CLOSING(closing), 
        .B0_LAST_RA(b0_last_ra), .B1_LAST_RA(b1_last_ra), .B2_LAST_RA(
        b2_last_ra), .B3_LAST_RA(b3_last_ra), .RAS_0_BA(ras_0_ba), .RAS_0_RA(
        ras_0_ra), .RAS_0_TT(ras_0_tt), .RAS_EMPTY(ras_empty), .RAS_FULL(
        ras_full) );
  NAND2X1 U4424 ( .A(n9121), .B(n9299), .Y(n9148) );
  NAND2X1 U4425 ( .A(n9151), .B(n9140), .Y(n9299) );
  NAND2BX1 U4426 ( .AN(n9289), .B(n9064), .Y(n9286) );
  NOR3X1 U4427 ( .A(n9322), .B(n9258), .C(n9220), .Y(n9064) );
  NAND2X1 U4428 ( .A(n9257), .B(n9245), .Y(n9322) );
  OR3X2 U4429 ( .A(n9063), .B(bf_2rasbusy), .C(bf_3rasbusy), .Y(bf_trasbusy)
         );
  OR2X1 U4430 ( .A(bf_0rasbusy), .B(bf_1rasbusy), .Y(n9063) );
  INVX3 U4431 ( .A(n9286), .Y(n9312) );
  NAND4BX2 U4432 ( .AN(n9295), .B(n9296), .C(n9297), .D(n9026), .Y(n9259) );
  INVX1 U4433 ( .A(n9259), .Y(n9071) );
  NAND2X1 U4434 ( .A(n9294), .B(n9259), .Y(n9290) );
  INVX1 U4435 ( .A(n9290), .Y(n9260) );
  NAND2X1 U4436 ( .A(n9246), .B(n9247), .Y(ecmd[6]) );
  NAND2X2 U4437 ( .A(n9311), .B(n9312), .Y(n9254) );
  NOR3X2 U4438 ( .A(n9313), .B(bf_0reqcmd[4]), .C(n9314), .Y(n9311) );
  NOR2X1 U4439 ( .A(n9315), .B(n9316), .Y(n9313) );
  NOR2BX1 U4440 ( .AN(BA_REQ), .B(cmd_full_d), .Y(i_ba_req) );
  NAND2X2 U4441 ( .A(n9312), .B(n9319), .Y(n9221) );
  AO22X1 U4442 ( .A0(BA_AA[14]), .A1(n9342), .B0(BA_AA[12]), .B1(n8997), .Y(
        BA_RA[4]) );
  AO22X1 U4443 ( .A0(BA_AA[20]), .A1(n9342), .B0(BA_AA[18]), .B1(n8997), .Y(
        BA_RA[10]) );
  AO22X1 U4444 ( .A0(BA_AA[18]), .A1(n9342), .B0(BA_AA[16]), .B1(n8997), .Y(
        BA_RA[8]) );
  AO22X1 U4445 ( .A0(BA_AA[17]), .A1(n9342), .B0(BA_AA[15]), .B1(n8997), .Y(
        BA_RA[7]) );
  AO22X1 U4446 ( .A0(BA_AA[12]), .A1(n9342), .B0(BA_AA[10]), .B1(n8997), .Y(
        BA_RA[2]) );
  DFFSX1 ercmd_reg_0_ ( .D(n8062), .CK(ACLK), .SN(ARESETB), .Q(ercmd_0_), .QN(
        n8996) );
  AOI21X1 U4447 ( .A0(n8572), .A1(n8498), .B0(n8573), .Y(n8998) );
  OR2X1 U4448 ( .A(n9029), .B(n9145), .Y(n8999) );
  DFFRX1 ercmd_reg_2_ ( .D(n8060), .CK(ACLK), .RN(ARESETB), .Q(ercmd_2_), .QN(
        n9025) );
  OR2X1 U4449 ( .A(n9129), .B(n9145), .Y(n9026) );
  DFFRX1 ercmd_reg_4_ ( .D(n8058), .CK(ACLK), .RN(ARESETB), .Q(ercmd_4_), .QN(
        n9027) );
  NOR4X1 U4450 ( .A(PENABLE), .B(PADDR[7]), .C(PADDR[6]), .D(n8940), .Y(n9030)
         );
  DFFRX1 SD_CKE_reg ( .D(iSD_CKE), .CK(ACLK), .RN(PORESETB), .Q(SD_CKE) );
  DFFSX1 SD_WEB_reg ( .D(iSD_WEB), .CK(ACLK), .SN(PORESETB), .Q(SD_WEB) );
  DFFSX1 SD_CASB_reg ( .D(iSD_CASB), .CK(ACLK), .SN(PORESETB), .Q(SD_CASB) );
  DFFSX1 SD_RASB_reg ( .D(iSD_RASB), .CK(ACLK), .SN(PORESETB), .Q(SD_RASB) );
  DFFSX1 SD_CSB_reg ( .D(iSD_CSB), .CK(ACLK), .SN(PORESETB), .Q(SD_CSB) );
  DFFRX1 do_valid_1_reg ( .D(do_valid_0), .CK(ACLK), .RN(ARESETB), .Q(
        do_valid_1) );
  DFFRX1 SD_BADDR_reg_0_ ( .D(iSD_BADDR[0]), .CK(ACLK), .RN(PORESETB), .Q(
        SD_BADDR[0]) );
  DFFRX1 SD_BADDR_reg_1_ ( .D(iSD_BADDR[1]), .CK(ACLK), .RN(PORESETB), .Q(
        SD_BADDR[1]) );
  DFFRX1 SD_ADDR_reg_0_ ( .D(iSD_ADDR[0]), .CK(ACLK), .RN(PORESETB), .Q(
        SD_ADDR[0]) );
  DFFRX1 SD_ADDR_reg_1_ ( .D(iSD_ADDR[1]), .CK(ACLK), .RN(PORESETB), .Q(
        SD_ADDR[1]) );
  DFFRX1 SD_ADDR_reg_2_ ( .D(iSD_ADDR[2]), .CK(ACLK), .RN(PORESETB), .Q(
        SD_ADDR[2]) );
  DFFRX1 SD_ADDR_reg_3_ ( .D(iSD_ADDR[3]), .CK(ACLK), .RN(PORESETB), .Q(
        SD_ADDR[3]) );
  DFFRX1 SD_ADDR_reg_4_ ( .D(iSD_ADDR[4]), .CK(ACLK), .RN(PORESETB), .Q(
        SD_ADDR[4]) );
  DFFRX1 SD_ADDR_reg_5_ ( .D(iSD_ADDR[5]), .CK(ACLK), .RN(PORESETB), .Q(
        SD_ADDR[5]) );
  DFFRX1 SD_ADDR_reg_6_ ( .D(iSD_ADDR[6]), .CK(ACLK), .RN(PORESETB), .Q(
        SD_ADDR[6]) );
  DFFRX1 SD_ADDR_reg_7_ ( .D(iSD_ADDR[7]), .CK(ACLK), .RN(PORESETB), .Q(
        SD_ADDR[7]) );
  DFFRX1 SD_ADDR_reg_8_ ( .D(iSD_ADDR[8]), .CK(ACLK), .RN(PORESETB), .Q(
        SD_ADDR[8]) );
  DFFRX1 SD_ADDR_reg_9_ ( .D(iSD_ADDR[9]), .CK(ACLK), .RN(PORESETB), .Q(
        SD_ADDR[9]) );
  DFFRX1 SD_ADDR_reg_10_ ( .D(iSD_ADDR[10]), .CK(ACLK), .RN(PORESETB), .Q(
        SD_ADDR[10]) );
  DFFRX1 SD_ADDR_reg_11_ ( .D(iSD_ADDR[11]), .CK(ACLK), .RN(PORESETB), .Q(
        SD_ADDR[11]) );
  DFFRX1 do_id_1_reg_0_ ( .D(do_id_0[0]), .CK(ACLK), .RN(ARESETB), .Q(
        do_id_1[0]) );
  DFFRX1 do_id_1_reg_1_ ( .D(do_id_0[1]), .CK(ACLK), .RN(ARESETB), .Q(
        do_id_1[1]) );
  DFFRX1 do_id_1_reg_2_ ( .D(do_id_0[2]), .CK(ACLK), .RN(ARESETB), .Q(
        do_id_1[2]) );
  DFFRX1 do_id_1_reg_3_ ( .D(do_id_0[3]), .CK(ACLK), .RN(ARESETB), .Q(
        do_id_1[3]) );
  OR2X1 U4451 ( .A(n9071), .B(n9072), .Y(n9275) );
  NAND2X1 U4452 ( .A(n9221), .B(n9301), .Y(n9140) );
  INVX1 U4453 ( .A(n9262), .Y(ecmd[0]) );
  INVX1 U4454 ( .A(n9148), .Y(n9297) );
  NAND4X1 U4455 ( .A(n9065), .B(n9282), .C(n9327), .D(n9328), .Y(n9289) );
  INVX1 U4456 ( .A(n9240), .Y(ecmd[3]) );
  INVX1 U4457 ( .A(n9241), .Y(ecmd[1]) );
  INVX3 U4458 ( .A(n9275), .Y(n8864) );
  NOR2X1 U4459 ( .A(bf_1reqcmd[0]), .B(bf_2reqcmd[0]), .Y(n9328) );
  NOR2X1 U4460 ( .A(n9152), .B(n9125), .Y(n9295) );
  OA21X1 U4461 ( .A0(n9289), .A1(n9303), .B0(n9294), .Y(n9070) );
  INVX1 U4462 ( .A(bf_0reqcmd[4]), .Y(n9320) );
  NAND2X1 U4463 ( .A(n9284), .B(n9320), .Y(n9319) );
  NOR3X1 U4464 ( .A(n9289), .B(n9304), .C(n9220), .Y(n9135) );
  NOR2BX1 U4465 ( .AN(n9301), .B(n9305), .Y(n9310) );
  NAND2BX1 U4466 ( .AN(n9073), .B(n9260), .Y(n9241) );
  INVX1 U4467 ( .A(bf_1reqcmd[4]), .Y(n8663) );
  NAND3X2 U4468 ( .A(n9300), .B(n9252), .C(n9251), .Y(n9296) );
  AO22X1 U4469 ( .A0(BA_AA[8]), .A1(n9342), .B0(BA_AA[20]), .B1(n8997), .Y(
        BA_BA[0]) );
  AO22X1 U4470 ( .A0(BA_AA[21]), .A1(n9342), .B0(BA_AA[19]), .B1(n8997), .Y(
        BA_RA[11]) );
  AO22X1 U4471 ( .A0(BA_AA[9]), .A1(n9342), .B0(BA_AA[21]), .B1(n8997), .Y(
        BA_BA[1]) );
  AND2X2 U4472 ( .A(n9329), .B(n9330), .Y(n9065) );
  NAND2X1 U4473 ( .A(n9331), .B(n9332), .Y(n9333) );
  AO22X1 U4474 ( .A0(BA_AA[16]), .A1(n9342), .B0(BA_AA[14]), .B1(n8997), .Y(
        BA_RA[6]) );
  AO22X1 U4475 ( .A0(BA_AA[11]), .A1(n9342), .B0(BA_AA[9]), .B1(n8997), .Y(
        BA_RA[1]) );
  AO22X1 U4476 ( .A0(BA_AA[13]), .A1(n9342), .B0(BA_AA[11]), .B1(n8997), .Y(
        BA_RA[3]) );
  AO22X1 U4477 ( .A0(BA_AA[19]), .A1(n9342), .B0(BA_AA[17]), .B1(n8997), .Y(
        BA_RA[9]) );
  AO22X1 U4478 ( .A0(BA_AA[15]), .A1(n9342), .B0(BA_AA[13]), .B1(n8997), .Y(
        BA_RA[5]) );
  AO22X1 U4479 ( .A0(BA_AA[10]), .A1(n9342), .B0(BA_AA[8]), .B1(n8997), .Y(
        BA_RA[0]) );
  NAND2X1 U4480 ( .A(n8398), .B(n8406), .Y(n8404) );
  NAND3BX1 U4481 ( .AN(n8938), .B(n8650), .C(PADDR[3]), .Y(n8887) );
  AND3X1 U4482 ( .A(n9162), .B(n9163), .C(n8501), .Y(n9066) );
  XOR2X1 U4483 ( .A(cas_0_ba[1]), .B(n9067), .Y(n8448) );
  BUFX2 U4484 ( .A(n9260), .Y(n9068) );
  INVX1 U4485 ( .A(n9228), .Y(n9200) );
  INVX1 U4486 ( .A(n9140), .Y(n9131) );
  INVX1 U4487 ( .A(n9254), .Y(n9132) );
  NAND2BX1 U4488 ( .AN(n9069), .B(n8864), .Y(n9240) );
  OR2X1 U4489 ( .A(n9257), .B(n9258), .Y(n9069) );
  INVX1 U4490 ( .A(n9303), .Y(n9257) );
  INVX1 U4491 ( .A(n9314), .Y(n9284) );
  NAND2X1 U4492 ( .A(n8858), .B(n9284), .Y(n9266) );
  NOR2X1 U4493 ( .A(n8664), .B(n9120), .Y(bf_1cmd[3]) );
  NOR2X1 U4494 ( .A(n9280), .B(n9279), .Y(bf_0cmd[3]) );
  NAND2X1 U4495 ( .A(n8864), .B(n9288), .Y(n9280) );
  INVX1 U4496 ( .A(n9258), .Y(n9288) );
  NAND2BX1 U4497 ( .AN(n9280), .B(n9279), .Y(n9120) );
  NOR2X1 U4498 ( .A(n9266), .B(n9283), .Y(bf_0cmd[5]) );
  INVX1 U4499 ( .A(n9126), .Y(n9256) );
  INVX1 U4500 ( .A(n9118), .Y(n8396) );
  NAND2X1 U4501 ( .A(n9239), .B(n8396), .Y(n9228) );
  NOR2X1 U4502 ( .A(n9334), .B(ecmd[2]), .Y(n9239) );
  INVX1 U4503 ( .A(n9334), .Y(n8441) );
  AO21X1 U4504 ( .A0(n9234), .A1(n8654), .B0(n8656), .Y(n9233) );
  INVX1 U4505 ( .A(n8657), .Y(n8656) );
  INVX1 U4506 ( .A(n9204), .Y(ecmd[2]) );
  INVX1 U4507 ( .A(n9163), .Y(ecmd[5]) );
  NAND3X1 U4508 ( .A(n8863), .B(n9324), .C(n8862), .Y(n9258) );
  INVX1 U4509 ( .A(bf_3reqcmd[2]), .Y(n9324) );
  NAND4X1 U4510 ( .A(n9221), .B(n9152), .C(n9302), .D(n9254), .Y(n9252) );
  NOR2X1 U4511 ( .A(n9135), .B(n9070), .Y(n9302) );
  NAND2X1 U4512 ( .A(n8659), .B(n9267), .Y(n9315) );
  INVX1 U4513 ( .A(n9265), .Y(ecmd[4]) );
  NAND3X1 U4514 ( .A(n8660), .B(n8663), .C(n9321), .Y(n9314) );
  INVX1 U4515 ( .A(bf_3reqcmd[4]), .Y(n9321) );
  NAND2X2 U4516 ( .A(n9260), .B(n9261), .Y(n9262) );
  NAND2X1 U4517 ( .A(n9294), .B(n9261), .Y(n9301) );
  NAND2X1 U4518 ( .A(n9325), .B(n9326), .Y(n9303) );
  NOR2X1 U4519 ( .A(bf_1reqcmd[3]), .B(bf_0reqcmd[3]), .Y(n9325) );
  NOR2X1 U4520 ( .A(bf_3reqcmd[3]), .B(bf_2reqcmd[3]), .Y(n9326) );
  NAND2X1 U4521 ( .A(n9283), .B(n9242), .Y(n9316) );
  INVX1 U4522 ( .A(bf_1reqcmd[2]), .Y(n8862) );
  INVX1 U4523 ( .A(bf_0reqcmd[2]), .Y(n9245) );
  INVX1 U4524 ( .A(bf_2reqcmd[4]), .Y(n8660) );
  INVX1 U4525 ( .A(bf_0reqcmd[5]), .Y(n9283) );
  INVX1 U4526 ( .A(bf_2reqcmd[2]), .Y(n8863) );
  NAND2X1 U4527 ( .A(n9265), .B(n9262), .Y(n9334) );
  NOR3X1 U4528 ( .A(n9290), .B(n9289), .C(n9245), .Y(bf_0cmd[2]) );
  NOR2X1 U4529 ( .A(n9290), .B(n9282), .Y(bf_0cmd[0]) );
  NOR2X1 U4530 ( .A(n9268), .B(n9270), .Y(bf_1cmd[0]) );
  NAND3X1 U4531 ( .A(n9221), .B(n9253), .C(n9254), .Y(n9139) );
  NOR2X1 U4532 ( .A(n9135), .B(n9070), .Y(n9253) );
  NOR2X1 U4533 ( .A(n9272), .B(n9273), .Y(bf_2cmd[4]) );
  NAND2X1 U4534 ( .A(bf_2reqcmd[4]), .B(n8663), .Y(n9273) );
  NOR2X1 U4535 ( .A(n8663), .B(n9272), .Y(bf_1cmd[4]) );
  NOR2X1 U4536 ( .A(n9280), .B(n9287), .Y(bf_0cmd[4]) );
  NAND2X1 U4537 ( .A(bf_0reqcmd[4]), .B(n9257), .Y(n9287) );
  NOR2X1 U4538 ( .A(n9275), .B(n9276), .Y(bf_2cmd[2]) );
  NAND2X1 U4539 ( .A(bf_2reqcmd[2]), .B(n8862), .Y(n9276) );
  NOR2X1 U4540 ( .A(n8862), .B(n9275), .Y(bf_1cmd[2]) );
  NOR2X1 U4541 ( .A(n9120), .B(n9274), .Y(bf_2cmd[3]) );
  NAND2X1 U4542 ( .A(bf_2reqcmd[3]), .B(n8664), .Y(n9274) );
  NAND2X1 U4543 ( .A(n9068), .B(n9282), .Y(n9268) );
  AND4X1 U4544 ( .A(n8663), .B(n8660), .C(bf_3reqcmd[4]), .D(n8858), .Y(
        bf_3cmd[4]) );
  NOR2X1 U4545 ( .A(n9266), .B(n9267), .Y(bf_3cmd[5]) );
  NOR2X1 U4546 ( .A(n9266), .B(n9242), .Y(bf_1cmd[5]) );
  NOR2X1 U4547 ( .A(n8659), .B(n9266), .Y(bf_2cmd[5]) );
  AND4X1 U4548 ( .A(n8862), .B(n8863), .C(bf_3reqcmd[2]), .D(n8864), .Y(
        bf_3cmd[2]) );
  NAND2X1 U4549 ( .A(n9132), .B(n9151), .Y(n9126) );
  INVX1 U4550 ( .A(n9272), .Y(n8858) );
  AND4X1 U4551 ( .A(n8664), .B(n8658), .C(bf_3reqcmd[3]), .D(n8860), .Y(
        bf_3cmd[3]) );
  INVX1 U4552 ( .A(n9120), .Y(n8860) );
  NAND2X1 U4553 ( .A(n9240), .B(n9241), .Y(n9118) );
  INVX1 U4554 ( .A(n9201), .Y(n8416) );
  INVX1 U4555 ( .A(n9261), .Y(n9219) );
  INVX1 U4556 ( .A(n8470), .Y(n8476) );
  INVX1 U4557 ( .A(n8591), .Y(n8611) );
  INVX1 U4558 ( .A(bf_1reqcmd[3]), .Y(n8664) );
  INVX1 U4559 ( .A(n9129), .Y(n9144) );
  INVX1 U4560 ( .A(bf_0reqcmd[3]), .Y(n9279) );
  INVX1 U4561 ( .A(ecmd[6]), .Y(n8406) );
  INVX1 U4562 ( .A(n9124), .Y(n8671) );
  INVX1 U4563 ( .A(bf_2reqcmd[3]), .Y(n8658) );
  INVX1 U4564 ( .A(n8751), .Y(n8762) );
  INVX1 U4565 ( .A(n8524), .Y(n8521) );
  NAND4X1 U4566 ( .A(bf_1reqcmd[2]), .B(n8664), .C(n8663), .D(n9242), .Y(n9234) );
  NAND2X1 U4567 ( .A(n9243), .B(n9244), .Y(n8657) );
  NOR2X1 U4568 ( .A(bf_0reqcmd[3]), .B(n9245), .Y(n9243) );
  NOR2X1 U4569 ( .A(bf_0reqcmd[5]), .B(bf_0reqcmd[4]), .Y(n9244) );
  NAND2BX1 U4570 ( .AN(n8605), .B(n8712), .Y(n8711) );
  AND4X1 U4571 ( .A(n8658), .B(n8659), .C(bf_2reqcmd[2]), .D(n8660), .Y(n8654)
         );
  INVX1 U4572 ( .A(n8802), .Y(n8803) );
  INVX1 U4573 ( .A(n8715), .Y(n8712) );
  DFFSX1 iSD_CASB_reg ( .D(pttn5134_1_), .CK(ACLK), .SN(ARESETB), .Q(iSD_CASB)
         );
  DFFSX1 iSD_RASB_reg ( .D(pttn5134_2_), .CK(ACLK), .SN(ARESETB), .Q(iSD_RASB)
         );
  NOR2X1 U4574 ( .A(bf_0reqcmd[2]), .B(n9258), .Y(n9304) );
  INVX1 U4575 ( .A(bf_3reqcmd[0]), .Y(n9327) );
  NAND2X1 U4576 ( .A(n9135), .B(n9259), .Y(n9204) );
  NAND2X1 U4577 ( .A(n9132), .B(n9259), .Y(n9163) );
  OR3X1 U4578 ( .A(n9289), .B(bf_0reqcmd[2]), .C(n9220), .Y(n9072) );
  NAND3X1 U4579 ( .A(n9221), .B(n9310), .C(n9254), .Y(n9125) );
  NAND2BX1 U4580 ( .AN(n9221), .B(n9259), .Y(n9265) );
  OR2X1 U4581 ( .A(n9065), .B(n9261), .Y(n9073) );
  NAND2X1 U4582 ( .A(n9317), .B(n9318), .Y(n9261) );
  NOR2X1 U4583 ( .A(bf_1reqcmd[0]), .B(bf_0reqcmd[0]), .Y(n9317) );
  NOR2X1 U4584 ( .A(bf_3reqcmd[0]), .B(bf_2reqcmd[0]), .Y(n9318) );
  INVX1 U4585 ( .A(bf_3reqcmd[5]), .Y(n9267) );
  INVX1 U4586 ( .A(bf_2reqcmd[5]), .Y(n8659) );
  INVX1 U4587 ( .A(bf_0reqcmd[0]), .Y(n9282) );
  INVX1 U4588 ( .A(bf_1reqcmd[5]), .Y(n9242) );
  DFFRX1 ercmd_reg_3_ ( .D(n8059), .CK(ACLK), .RN(ARESETB), .Q(ercmd_3_), .QN(
        n8981) );
  NAND2X1 U4589 ( .A(n9285), .B(n9259), .Y(n9272) );
  NOR2X1 U4590 ( .A(bf_0reqcmd[4]), .B(n9286), .Y(n9285) );
  INVX1 U4591 ( .A(n9333), .Y(n9152) );
  AOI21X1 U4592 ( .A0(n9255), .A1(n9152), .B0(n9256), .Y(n9246) );
  OAI21X1 U4593 ( .A0(n9248), .A1(n9249), .B0(n9144), .Y(n9247) );
  INVX1 U4594 ( .A(n9125), .Y(n9255) );
  NOR2X1 U4595 ( .A(n9268), .B(n9278), .Y(bf_2cmd[0]) );
  NAND2X1 U4596 ( .A(bf_2reqcmd[0]), .B(n9270), .Y(n9278) );
  NOR2X1 U4597 ( .A(n9268), .B(n9269), .Y(bf_3cmd[0]) );
  NAND3X1 U4598 ( .A(n9270), .B(n9271), .C(bf_3reqcmd[0]), .Y(n9269) );
  INVX1 U4599 ( .A(bf_2reqcmd[0]), .Y(n9271) );
  NAND2X1 U4600 ( .A(n9121), .B(n9305), .Y(n9129) );
  NOR2X1 U4601 ( .A(n8866), .B(n9119), .Y(bf_1cmd[1]) );
  INVX1 U4602 ( .A(n9305), .Y(n9151) );
  OAI31X1 U4603 ( .A0(n8509), .A1(n8507), .A2(n8510), .B0(n8468), .Y(n8470) );
  INVX1 U4604 ( .A(n9220), .Y(n9294) );
  OAI22X1 U4605 ( .A0(n9222), .A1(n9223), .B0(n9224), .B1(n9334), .Y(n8088) );
  NAND2X1 U4606 ( .A(n9138), .B(n9152), .Y(n9223) );
  NAND3BX1 U4607 ( .AN(n9225), .B(n9226), .C(n9163), .Y(n9224) );
  NOR2X1 U4608 ( .A(n9227), .B(n9118), .Y(n9222) );
  NAND2BX1 U4609 ( .AN(n8605), .B(n8594), .Y(n8591) );
  NAND2X1 U4610 ( .A(n9208), .B(n9209), .Y(n9201) );
  NOR2X1 U4611 ( .A(n9188), .B(n9118), .Y(n9208) );
  NOR2X1 U4612 ( .A(closing), .B(n9334), .Y(n9209) );
  INVX1 U4613 ( .A(bf_1reqcmd[0]), .Y(n9270) );
  INVX1 U4614 ( .A(n8468), .Y(n8475) );
  INVX1 U4615 ( .A(n8581), .Y(n8582) );
  NAND2BX1 U4616 ( .AN(n9334), .B(n8394), .Y(pttn5134_2_) );
  NAND2X1 U4617 ( .A(n9117), .B(n8394), .Y(pttn5134_1_) );
  NOR3X1 U4618 ( .A(n9118), .B(closing), .C(ecmd[2]), .Y(n9117) );
  AOI22X1 U4619 ( .A0(n8610), .A1(n8581), .B0(n8611), .B1(n8509), .Y(n9074) );
  NAND2BX1 U4620 ( .AN(n8596), .B(n8509), .Y(n8524) );
  AO21X1 U4621 ( .A0(n8596), .A1(n8467), .B0(n8765), .Y(n8751) );
  NAND2X1 U4622 ( .A(n9146), .B(n9147), .Y(n9124) );
  NOR2X1 U4623 ( .A(n9132), .B(n9148), .Y(n9147) );
  NOR2X1 U4624 ( .A(n9149), .B(n9150), .Y(n9146) );
  MXI2X1 U4625 ( .S0(n9151), .B(n9333), .A(n9138), .Y(n9150) );
  INVX1 U4626 ( .A(n8579), .Y(n8502) );
  INVX1 U4627 ( .A(n8590), .Y(n8520) );
  INVX1 U4628 ( .A(n8766), .Y(n8763) );
  NAND3BX1 U4629 ( .AN(n8507), .B(n8596), .C(n8749), .Y(n8766) );
  INVX1 U4630 ( .A(n8512), .Y(n8572) );
  INVX1 U4631 ( .A(n8723), .Y(n8620) );
  NAND3BX1 U4632 ( .AN(n8724), .B(n8725), .C(n9077), .Y(n8723) );
  INVX1 U4633 ( .A(n8564), .Y(n8725) );
  INVX1 U4634 ( .A(n8674), .Y(n8668) );
  INVX1 U4635 ( .A(n8621), .Y(n8578) );
  OAI21X1 U4636 ( .A0(n8619), .A1(n8579), .B0(n8572), .Y(n9075) );
  INVX1 U4637 ( .A(n8580), .Y(n8619) );
  INVX1 U4638 ( .A(n8749), .Y(n8765) );
  INVX1 U4639 ( .A(n8533), .Y(n8549) );
  AO21X1 U4640 ( .A0(n8727), .A1(n8728), .B0(n8621), .Y(n8715) );
  OA21X2 U4641 ( .A0(n8577), .A1(n8602), .B0(n9077), .Y(n8727) );
  AOI211X1 U4642 ( .A0(n8523), .A1(n8564), .B0(n8729), .C0(n8724), .Y(n8728)
         );
  NAND2BX1 U4643 ( .AN(n8805), .B(n8800), .Y(n8802) );
  INVX1 U4644 ( .A(n8640), .Y(n8641) );
  NAND2X1 U4645 ( .A(n8602), .B(n8620), .Y(n8605) );
  INVX1 U4646 ( .A(n8891), .Y(n8896) );
  INVX1 U4647 ( .A(n8467), .Y(n8507) );
  INVX1 U4648 ( .A(n8887), .Y(n8895) );
  INVX1 U4649 ( .A(n9337), .Y(n8643) );
  INVX1 U4650 ( .A(n9341), .Y(n8649) );
  INVX1 U4651 ( .A(n8644), .Y(n8645) );
  INVX1 U4652 ( .A(n9340), .Y(n8800) );
  INVX1 U4653 ( .A(n8409), .Y(n8849) );
  INVX1 U4654 ( .A(n8596), .Y(n8588) );
  DFFRX1 iSD_CKE_reg ( .D(pSD_CKE), .CK(ACLK), .RN(ARESETB), .Q(iSD_CKE) );
  DFFRX1 do_valid_0_reg ( .D(do_valid_04735), .CK(ACLK), .RN(ARESETB), .Q(
        do_valid_0) );
  DFFSX1 iSD_WEB_reg ( .D(pttn5134_0_), .CK(ACLK), .SN(ARESETB), .Q(iSD_WEB)
         );
  DFFSX1 iSD_CSB_reg ( .D(pttn5134_3_), .CK(ACLK), .SN(ARESETB), .Q(iSD_CSB)
         );
  NOR2BX1 U4655 ( .AN(cas_0_id[0]), .B(n8943), .Y(BA_STS[10]) );
  NOR2BX1 U4656 ( .AN(cas_0_id[1]), .B(n8943), .Y(BA_STS[11]) );
  NOR2BX1 U4657 ( .AN(cas_0_id[3]), .B(n8943), .Y(BA_STS[13]) );
  NOR2BX1 U4658 ( .AN(cas_0_id[2]), .B(n8943), .Y(BA_STS[12]) );
  NOR2X1 U4659 ( .A(bf_1casbusy), .B(bf_0casbusy), .Y(n9331) );
  NOR2X1 U4660 ( .A(bf_3casbusy), .B(bf_2casbusy), .Y(n9332) );
  NAND2X1 U4661 ( .A(n9323), .B(n9076), .Y(n9220) );
  NOR2X1 U4662 ( .A(n9024), .B(n8409), .Y(n9323) );
  NOR2X1 U4663 ( .A(bf_1reqcmd[1]), .B(bf_0reqcmd[1]), .Y(n9329) );
  NOR2X1 U4664 ( .A(bf_3reqcmd[1]), .B(bf_2reqcmd[1]), .Y(n9330) );
  AND2X2 U4665 ( .A(n8438), .B(n8981), .Y(n9076) );
  INVX1 U4666 ( .A(n8967), .Y(n8438) );
  NAND2BX1 U4667 ( .AN(n9343), .B(n9025), .Y(n8967) );
  DFFSX1 tcl_reg_0_ ( .D(n8027), .CK(PCLK), .SN(PRESETB), .Q(n2878_3_), .QN(
        n9013) );
  DFFRX1 ercmd_reg_5_ ( .D(n8057), .CK(ACLK), .RN(ARESETB), .Q(ercmd_5_), .QN(
        n9024) );
  NAND3X1 U4668 ( .A(n8995), .B(n8982), .C(rs_state_1_), .Y(n9305) );
  NOR2X1 U4669 ( .A(n9290), .B(n9291), .Y(bf_0cmd[1]) );
  NAND2X1 U4670 ( .A(n9219), .B(bf_0reqcmd[1]), .Y(n9291) );
  NOR2X1 U4671 ( .A(n9119), .B(n9277), .Y(bf_2cmd[1]) );
  NAND2X1 U4672 ( .A(bf_2reqcmd[1]), .B(n8866), .Y(n9277) );
  NAND2X1 U4673 ( .A(n9281), .B(n9068), .Y(n9119) );
  NOR2X1 U4674 ( .A(bf_0reqcmd[1]), .B(n9261), .Y(n9281) );
  NAND2X1 U4675 ( .A(n8974), .B(n8982), .Y(n9121) );
  NAND2X1 U4676 ( .A(n9251), .B(n9252), .Y(n9149) );
  AND4X1 U4677 ( .A(n8866), .B(n8867), .C(bf_3reqcmd[1]), .D(n8868), .Y(
        bf_3cmd[1]) );
  INVX1 U4678 ( .A(bf_2reqcmd[1]), .Y(n8867) );
  INVX1 U4679 ( .A(n9119), .Y(n8868) );
  NAND2X1 U4680 ( .A(n8996), .B(n9027), .Y(n8409) );
  NOR2X1 U4681 ( .A(n9250), .B(n9129), .Y(n9300) );
  NOR2X1 U4682 ( .A(n9139), .B(n8999), .Y(n9248) );
  NOR2BX1 U4683 ( .AN(n9149), .B(n9250), .Y(n9249) );
  INVX1 U4684 ( .A(n8472), .Y(n8473) );
  INVX1 U4685 ( .A(n8506), .Y(n8501) );
  NAND3BX1 U4686 ( .AN(n8507), .B(n8508), .C(n8468), .Y(n8506) );
  INVX1 U4687 ( .A(BA_REQ), .Y(n8823) );
  OAI211X1 U4688 ( .A0(n8511), .A1(n8512), .B0(n8513), .C0(n8514), .Y(n8468)
         );
  INVX1 U4689 ( .A(n8515), .Y(n8513) );
  NOR2BX1 U4690 ( .AN(n8516), .B(n8517), .Y(n8511) );
  AOI211X1 U4691 ( .A0(n8519), .A1(n8520), .B0(n8521), .C0(n8522), .Y(n8516)
         );
  INVX1 U4692 ( .A(n9161), .Y(n8517) );
  OAI21X1 U4693 ( .A0(n9157), .A1(ecmd[5]), .B0(n9158), .Y(n8581) );
  NAND4X1 U4694 ( .A(n8519), .B(n9102), .C(n8572), .D(n8520), .Y(n9157) );
  NOR2X1 U4695 ( .A(n9159), .B(n8617), .Y(n9158) );
  NAND2X1 U4696 ( .A(n9160), .B(n9075), .Y(n9159) );
  AOI21X1 U4697 ( .A0(n8398), .A1(ecmd[6]), .B0(pttn5134_3_), .Y(n8394) );
  NAND2X1 U4698 ( .A(n8847), .B(n9163), .Y(closing) );
  OAI21X1 U4699 ( .A0(n9152), .A1(n9250), .B0(n8411), .Y(do_valid_04735) );
  NAND2X1 U4700 ( .A(n9196), .B(n9197), .Y(pttn5134_3_) );
  NAND3X1 U4701 ( .A(n9198), .B(n9024), .C(n9076), .Y(n9197) );
  NAND2X1 U4702 ( .A(n9199), .B(n9200), .Y(n9196) );
  XOR2X1 U4703 ( .A(n9027), .B(n8996), .Y(n9198) );
  NAND3BX1 U4704 ( .AN(n8399), .B(n8396), .C(n8400), .Y(pttn5134_0_) );
  INVX1 U4705 ( .A(pttn5134_3_), .Y(n8400) );
  OAI31X1 U4706 ( .A0(n8408), .A1(n8409), .A2(n9025), .B0(n8411), .Y(n8399) );
  NAND3BX1 U4707 ( .AN(n9343), .B(n8981), .C(n9024), .Y(n8408) );
  DFFRX1 PRDATA_reg_0_ ( .D(PRDATA465_0_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[0]) );
  DFFRX1 PRDATA_reg_1_ ( .D(PRDATA465_1_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[1]) );
  DFFRX1 PRDATA_reg_2_ ( .D(PRDATA465_2_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[2]) );
  DFFRX1 PRDATA_reg_3_ ( .D(PRDATA465_3_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[3]) );
  DFFRX1 PRDATA_reg_4_ ( .D(PRDATA465_4_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[4]) );
  DFFRX1 PRDATA_reg_5_ ( .D(PRDATA465_5_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[5]) );
  DFFRX1 PRDATA_reg_6_ ( .D(PRDATA465_6_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[6]) );
  DFFRX1 PRDATA_reg_7_ ( .D(PRDATA465_7_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[7]) );
  DFFRX1 PRDATA_reg_8_ ( .D(PRDATA465_8_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[8]) );
  DFFRX1 PRDATA_reg_9_ ( .D(PRDATA465_9_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[9]) );
  DFFRX1 PRDATA_reg_10_ ( .D(PRDATA465_10_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[10]) );
  DFFRX1 PRDATA_reg_11_ ( .D(PRDATA465_11_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[11]) );
  DFFRX1 PRDATA_reg_12_ ( .D(PRDATA465_12_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[12]) );
  DFFRX1 PRDATA_reg_13_ ( .D(PRDATA465_13_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[13]) );
  DFFRX1 PRDATA_reg_14_ ( .D(PRDATA465_14_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[14]) );
  DFFRX1 PRDATA_reg_15_ ( .D(PRDATA465_15_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[15]) );
  DFFRX1 PRDATA_reg_16_ ( .D(PRDATA465_16_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[16]) );
  DFFRX1 PRDATA_reg_17_ ( .D(PRDATA465_17_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[17]) );
  DFFRX1 PRDATA_reg_18_ ( .D(PRDATA465_18_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[18]) );
  DFFRX1 PRDATA_reg_19_ ( .D(PRDATA465_19_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[19]) );
  DFFRX1 PRDATA_reg_20_ ( .D(PRDATA465_20_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[20]) );
  DFFRX1 PRDATA_reg_21_ ( .D(PRDATA465_21_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[21]) );
  DFFRX1 PRDATA_reg_22_ ( .D(PRDATA465_22_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[22]) );
  DFFRX1 PRDATA_reg_23_ ( .D(PRDATA465_23_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[23]) );
  DFFRX1 PRDATA_reg_24_ ( .D(PRDATA465_24_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[24]) );
  DFFRX1 PRDATA_reg_25_ ( .D(PRDATA465_25_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[25]) );
  DFFRX1 PRDATA_reg_26_ ( .D(PRDATA465_26_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[26]) );
  DFFRX1 PRDATA_reg_27_ ( .D(PRDATA465_27_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[27]) );
  DFFRX1 PRDATA_reg_28_ ( .D(PRDATA465_28_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[28]) );
  DFFRX1 PRDATA_reg_29_ ( .D(PRDATA465_29_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[29]) );
  DFFRX1 PRDATA_reg_30_ ( .D(PRDATA465_30_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[30]) );
  DFFRX1 PRDATA_reg_31_ ( .D(PRDATA465_31_), .CK(PCLK), .RN(PRESETB), .Q(
        PRDATA[31]) );
  NOR2X1 U4708 ( .A(n8404), .B(ecmd[5]), .Y(n9199) );
  NAND2X1 U4709 ( .A(ecmd[2]), .B(n9104), .Y(n9226) );
  INVX1 U4710 ( .A(n8411), .Y(n8443) );
  INVX1 U4711 ( .A(n8585), .Y(n8594) );
  OAI222X1 U4712 ( .A0(n8582), .A1(n9008), .B0(n8581), .B1(n9044), .C0(n8585), 
        .C1(n8586), .Y(n8061) );
  NAND2X1 U4713 ( .A(n9161), .B(n9164), .Y(n8498) );
  NAND2X1 U4714 ( .A(n9165), .B(n8502), .Y(n9164) );
  NOR2X1 U4715 ( .A(n8580), .B(n9102), .Y(n9165) );
  OAI32X1 U4716 ( .A0(n8582), .A1(n8551), .A2(n8596), .B0(n8581), .B1(n8981), 
        .Y(n8059) );
  OAI31X1 U4717 ( .A0(n9074), .A1(n8588), .A2(n8548), .B0(n8589), .Y(n8060) );
  OA21X2 U4718 ( .A0(n8590), .A1(n8591), .B0(n8592), .Y(n8589) );
  AOI31X1 U4719 ( .A0(n8523), .A1(n8593), .A2(n8594), .B0(n8595), .Y(n8592) );
  OAI32X1 U4720 ( .A0(n8582), .A1(n8574), .A2(n8570), .B0(n8581), .B1(n9025), 
        .Y(n8595) );
  OAI211X1 U4721 ( .A0(n8531), .A1(n8574), .B0(n8514), .C0(n8575), .Y(n8573)
         );
  OAI31X1 U4722 ( .A0(n8576), .A1(n8577), .A2(n8510), .B0(n8578), .Y(n8575) );
  DFFSX1 selfref_cnt_reg_0_ ( .D(n8009), .CK(ACLK), .SN(ARESETB), .Q(n8297), 
        .QN(n9100) );
  DFFSX1 selfref_cnt_reg_2_ ( .D(n8007), .CK(ACLK), .SN(ARESETB), .Q(n8295), 
        .QN(n9108) );
  DFFRX1 refresh_cnt_reg_0_ ( .D(n8086), .CK(ACLK), .RN(ARESETB), .Q(
        refresh_cnt2536_0_), .QN(n9102) );
  DFFSX1 selfref_cnt_reg_1_ ( .D(n8008), .CK(ACLK), .SN(ARESETB), .Q(n8296), 
        .QN(n9001) );
  DFFSX1 selfref_cnt_reg_3_ ( .D(n8006), .CK(ACLK), .SN(ARESETB), .Q(n8294), 
        .QN(n9098) );
  NAND2BX1 U4723 ( .AN(n8637), .B(n8597), .Y(n8596) );
  NAND3BX1 U4724 ( .AN(n8769), .B(n8770), .C(n8771), .Y(n8579) );
  AND4X1 U4725 ( .A(n8989), .B(n9007), .C(n8976), .D(n9034), .Y(n8770) );
  AND4X1 U4726 ( .A(n9004), .B(n9035), .C(n8987), .D(n8775), .Y(n8771) );
  OAI211X1 U4727 ( .A0(n9101), .A1(n8984), .B0(n9005), .C0(n9031), .Y(n8769)
         );
  INVX1 U4728 ( .A(n8550), .Y(n8545) );
  NAND3BX1 U4729 ( .AN(n8549), .B(n8467), .C(n8548), .Y(n8550) );
  NAND2BX1 U4730 ( .AN(n8747), .B(n9095), .Y(n8602) );
  NAND2BX1 U4731 ( .AN(n8639), .B(n8578), .Y(n8512) );
  NAND2BX1 U4732 ( .AN(n8531), .B(n8614), .Y(n8621) );
  NAND2BX1 U4733 ( .AN(n8577), .B(n8608), .Y(n8564) );
  NAND2BX1 U4734 ( .AN(n9002), .B(n8502), .Y(n8590) );
  NAND2BX1 U4735 ( .AN(n9100), .B(n8732), .Y(n8586) );
  OAI31X1 U4736 ( .A0(n8767), .A1(n8548), .A2(n8531), .B0(n8514), .Y(n8749) );
  AOI31X1 U4737 ( .A0(n8729), .A1(n9036), .A2(n8509), .B0(n8610), .Y(n8767) );
  AO21X1 U4738 ( .A0(n8548), .A1(n8467), .B0(n8549), .Y(n8535) );
  OAI222X1 U4739 ( .A0(n8502), .A1(n8512), .B0(n8984), .B1(n8512), .C0(n8508), 
        .C1(n8621), .Y(n8515) );
  OAI21X1 U4740 ( .A0(n9122), .A1(n9123), .B0(n9124), .Y(n8674) );
  NAND2X1 U4741 ( .A(n9125), .B(n9126), .Y(n9123) );
  AOI21X1 U4742 ( .A0(n9127), .A1(n9128), .B0(n9129), .Y(n9122) );
  NAND2X1 U4743 ( .A(n9130), .B(n9131), .Y(n9128) );
  OAI221X1 U4744 ( .A0(n8531), .A1(n8551), .B0(n8552), .B1(n8512), .C0(n8514), 
        .Y(n8533) );
  NAND2X1 U4745 ( .A(n8984), .B(n9002), .Y(n8580) );
  NOR2X1 U4746 ( .A(n9104), .B(n9204), .Y(n9227) );
  NAND2X1 U4747 ( .A(n9143), .B(n9140), .Y(n8677) );
  NAND2X1 U4748 ( .A(n9144), .B(n9145), .Y(n9143) );
  AOI211X1 U4749 ( .A0(n8620), .A1(n8602), .B0(n9107), .C0(n8621), .Y(n8617)
         );
  INVX1 U4750 ( .A(n8735), .Y(BA_STS[2]) );
  INVX1 U4751 ( .A(bf_1reqcmd[1]), .Y(n8866) );
  AND4X1 U4752 ( .A(n9006), .B(n9032), .C(n8988), .D(n8975), .Y(n8775) );
  INVX1 U4753 ( .A(n8622), .Y(n8614) );
  INVX1 U4754 ( .A(n8552), .Y(n8509) );
  INVX1 U4755 ( .A(n8607), .Y(n8577) );
  AND3X2 U4756 ( .A(n8586), .B(n8508), .C(n8603), .Y(n9077) );
  INVX1 U4757 ( .A(n8548), .Y(n8597) );
  OAI221X1 U4758 ( .A0(n8533), .A1(n8986), .B0(n8535), .B1(n9016), .C0(n8537), 
        .Y(n8068) );
  INVX1 U4759 ( .A(n8907), .Y(n8746) );
  NAND2BX1 U4760 ( .AN(n9001), .B(n9097), .Y(n8907) );
  NAND2X1 U4761 ( .A(n9263), .B(n9264), .Y(bf_last_05017) );
  NAND2X1 U4762 ( .A(n8852), .B(n9138), .Y(n9264) );
  NAND2X1 U4763 ( .A(ecmd[4]), .B(n8451), .Y(n9263) );
  OR4X1 U4764 ( .A(bf_1last), .B(bf_0last), .C(bf_3last), .D(bf_2last), .Y(
        n8852) );
  INVX1 U4765 ( .A(n8463), .Y(n9225) );
  NOR2BX1 U4766 ( .AN(n8406), .B(n9029), .Y(n8463) );
  INVX1 U4767 ( .A(n8639), .Y(n8729) );
  INVX1 U4768 ( .A(n8604), .Y(n8724) );
  NAND2BX1 U4769 ( .AN(n9008), .B(n8622), .Y(n8467) );
  NAND3BX1 U4770 ( .AN(n8938), .B(PADDR[2]), .C(PADDR[3]), .Y(n9336) );
  NAND3BX1 U4771 ( .AN(n8938), .B(PADDR[2]), .C(PADDR[3]), .Y(n8891) );
  NAND3BX1 U4772 ( .AN(n8938), .B(PADDR[2]), .C(PADDR[3]), .Y(n9335) );
  NAND3BX1 U4773 ( .AN(n8646), .B(n8647), .C(PADDR[2]), .Y(n8644) );
  NAND3BX1 U4774 ( .AN(n8646), .B(PADDR[3]), .C(PADDR[2]), .Y(n8640) );
  NAND3BX1 U4775 ( .AN(n8646), .B(PADDR[3]), .C(PADDR[2]), .Y(n9339) );
  NAND3BX1 U4776 ( .AN(n8646), .B(PADDR[3]), .C(PADDR[2]), .Y(n9338) );
  NAND2BX1 U4777 ( .AN(n9037), .B(n8791), .Y(n8789) );
  OAI221X1 U4778 ( .A0(n9111), .A1(n9036), .B0(n8596), .B1(n8551), .C0(n9008), 
        .Y(n8791) );
  INVX1 U4779 ( .A(n9250), .Y(n9138) );
  NAND3BX1 U4780 ( .AN(n8938), .B(n8647), .C(n8650), .Y(n8889) );
  XOR2X1 U4781 ( .A(n9036), .B(n8789), .Y(n8000) );
  NAND2BX1 U4782 ( .AN(n8984), .B(n8502), .Y(n8503) );
  BUFX2 U4783 ( .A(n8642), .Y(n9337) );
  NAND3BX1 U4784 ( .AN(n8646), .B(n8650), .C(PADDR[3]), .Y(n8642) );
  NOR2BX1 U4785 ( .AN(n9107), .B(n8887), .Y(PRDATA465_31_) );
  BUFX2 U4786 ( .A(n8648), .Y(n9341) );
  NAND3BX1 U4787 ( .AN(n8646), .B(n8647), .C(n8650), .Y(n8648) );
  NOR2BX1 U4788 ( .AN(WQFull), .B(n9336), .Y(PRDATA465_29_) );
  NOR2BX1 U4789 ( .AN(RQFull), .B(n9336), .Y(PRDATA465_30_) );
  BUFX2 U4790 ( .A(n8806), .Y(n9340) );
  NAND4BX1 U4791 ( .AN(n8622), .B(n9008), .C(BA_STS[2]), .D(n8823), .Y(n8806)
         );
  NAND2BX1 U4792 ( .AN(n9037), .B(n8507), .Y(n8514) );
  INVX1 U4793 ( .A(n8798), .Y(n8805) );
  AND4X1 U4794 ( .A(n8980), .B(n8993), .C(n8973), .D(n9010), .Y(n8919) );
  INVX1 U4795 ( .A(n8508), .Y(n8510) );
  AO22X1 U4796 ( .A0(n8896), .A1(BA_STS[3]), .B0(n8896), .B1(n8735), .Y(
        PRDATA465_23_) );
  INVX1 U4797 ( .A(n8414), .Y(n8821) );
  OAI221X1 U4798 ( .A0(n8790), .A1(n9000), .B0(n8622), .B1(n8789), .C0(n8574), 
        .Y(n7999) );
  INVX1 U4799 ( .A(n8789), .Y(n8790) );
  OAI31X1 U4800 ( .A0(n8605), .A1(n8579), .A2(n9102), .B0(n8606), .Y(n8593) );
  NOR2BX1 U4801 ( .AN(n8607), .B(n8576), .Y(n8606) );
  INVX1 U4802 ( .A(n8570), .Y(n8523) );
  INVX1 U4803 ( .A(PADDR[2]), .Y(n8650) );
  INVX1 U4804 ( .A(n8608), .Y(n8576) );
  INVX1 U4805 ( .A(n8551), .Y(n8610) );
  INVX1 U4806 ( .A(n8938), .Y(n8915) );
  INVX1 U4807 ( .A(PADDR[3]), .Y(n8647) );
  INVX1 U4808 ( .A(n9172), .Y(n9188) );
  NOR2BX1 U4809 ( .AN(n8414), .B(n9107), .Y(pSD_CKE) );
  INVX1 U4810 ( .A(n9178), .Y(n8676) );
  NAND2X1 U4811 ( .A(n8974), .B(n8995), .Y(n9212) );
  INVX1 U4812 ( .A(n8528), .Y(n8526) );
  DFFRX1 bf_last_reg ( .D(bf_last5023), .CK(ACLK), .RN(ARESETB), .Q(BA_STS[5])
         );
  DFFRX1 bf_last_1_reg ( .D(bf_last_15011), .CK(ACLK), .RN(ARESETB), .Q(
        bf_last_1) );
  DFFRX1 do_valid_reg ( .D(do_valid4741), .CK(ACLK), .RN(ARESETB), .Q(
        BA_STS[1]) );
  DFFRX1 do_id_reg_0_ ( .D(do_id4870_0_), .CK(ACLK), .RN(ARESETB), .Q(
        BA_STS[6]) );
  DFFRX1 do_id_reg_1_ ( .D(do_id4870_1_), .CK(ACLK), .RN(ARESETB), .Q(
        BA_STS[7]) );
  DFFRX1 do_id_reg_2_ ( .D(do_id4870_2_), .CK(ACLK), .RN(ARESETB), .Q(
        BA_STS[8]) );
  DFFRX1 do_id_reg_3_ ( .D(do_id4870_3_), .CK(ACLK), .RN(ARESETB), .Q(
        BA_STS[9]) );
  INVX1 U4813 ( .A(BA_STS[0]), .Y(n8943) );
  AND4X2 U4814 ( .A(bf_3ready), .B(bf_2ready), .C(bf_1ready), .D(bf_0ready), 
        .Y(bf_tready) );
  BUFX2 U4815 ( .A(n8301), .Y(n9343) );
  NAND2X2 U4816 ( .A(n9140), .B(cas_0_rw), .Y(n9251) );
  NOR2BX1 U4817 ( .AN(cmd_full_d), .B(n8823), .Y(BA_STS[4]) );
  NAND2BX1 U4818 ( .AN(n2878_3_), .B(tcl_1_), .Y(n8951) );
  NAND3X1 U4819 ( .A(n9306), .B(n9307), .C(n9308), .Y(n9250) );
  XOR2X1 U4820 ( .A(n7473), .B(n2878_3_), .Y(n9307) );
  XOR2X1 U4821 ( .A(n9178), .B(n8974), .Y(n9306) );
  XOR2X1 U4822 ( .A(rs_state_2_), .B(n9078), .Y(n9308) );
  NAND2X1 U4823 ( .A(n9298), .B(n9250), .Y(n9145) );
  NOR2X1 U4824 ( .A(rw_bstop1), .B(rw_bstop0), .Y(n9298) );
  OAI31X1 U4825 ( .A0(n8498), .A1(n8499), .A2(n8500), .B0(n8501), .Y(n8472) );
  NAND2BX1 U4826 ( .AN(refresh_cnt2536_0_), .B(n8502), .Y(n8500) );
  INVX1 U4827 ( .A(n8503), .Y(n8499) );
  NAND2X1 U4828 ( .A(n9292), .B(n9293), .Y(BA_STS[0]) );
  NAND2X1 U4829 ( .A(n9151), .B(n9333), .Y(n9292) );
  NAND2X1 U4830 ( .A(n9334), .B(cas_0_rw), .Y(n9293) );
  NAND2X1 U4831 ( .A(n9166), .B(ecmd[5]), .Y(n9161) );
  NOR2X1 U4832 ( .A(refresh_cnt2536_0_), .B(n8590), .Y(n9166) );
  NAND2X1 U4833 ( .A(n8951), .B(n9309), .Y(n9178) );
  NAND2X1 U4834 ( .A(n8983), .B(n2878_3_), .Y(n9309) );
  OAI222X1 U4835 ( .A0(n8468), .A1(n9102), .B0(n8470), .B1(n9045), .C0(
        refresh_cnt2536_0_), .C1(n8472), .Y(n8086) );
  XOR3X1 U4836 ( .A(n9114), .B(tcl_1_), .C(n8951), .Y(n9078) );
  NAND2X1 U4837 ( .A(n9079), .B(n9080), .Y(n8075) );
  AOI22X1 U4838 ( .A0(refresh_cnt2536_11_), .A1(n9066), .B0(trefresh[11]), 
        .B1(n8476), .Y(n9079) );
  AOI22X1 U4839 ( .A0(refresh_cnt_11_), .A1(n8475), .B0(refresh_cnt2473_11_), 
        .B1(n8473), .Y(n9080) );
  NAND2X1 U4840 ( .A(n9081), .B(n9082), .Y(n8071) );
  AOI22X1 U4841 ( .A0(trefresh[15]), .A1(n8476), .B0(n6), .B1(n9066), .Y(n9081) );
  AOI22X1 U4842 ( .A0(refresh_cnt_15_), .A1(n8475), .B0(refresh_cnt2473_15_), 
        .B1(n8473), .Y(n9082) );
  NAND2X1 U4843 ( .A(n9083), .B(n9084), .Y(n8072) );
  AOI22X1 U4844 ( .A0(refresh_cnt2536_14_), .A1(n9066), .B0(trefresh[14]), 
        .B1(n8476), .Y(n9083) );
  AOI22X1 U4845 ( .A0(refresh_cnt_14_), .A1(n8475), .B0(refresh_cnt2473_14_), 
        .B1(n8473), .Y(n9084) );
  NAND2X1 U4846 ( .A(n9085), .B(n9086), .Y(n8073) );
  AOI22X1 U4847 ( .A0(refresh_cnt2536_13_), .A1(n9066), .B0(trefresh[13]), 
        .B1(n8476), .Y(n9085) );
  AOI22X1 U4848 ( .A0(refresh_cnt_13_), .A1(n8475), .B0(refresh_cnt2473_13_), 
        .B1(n8473), .Y(n9086) );
  NAND2X1 U4849 ( .A(n9087), .B(n9088), .Y(n8074) );
  AOI22X1 U4850 ( .A0(refresh_cnt2536_12_), .A1(n9066), .B0(trefresh[12]), 
        .B1(n8476), .Y(n9087) );
  AOI22X1 U4851 ( .A0(refresh_cnt_12_), .A1(n8475), .B0(refresh_cnt2473_12_), 
        .B1(n8473), .Y(n9088) );
  NAND2X1 U4852 ( .A(n9089), .B(n9090), .Y(n8076) );
  AOI22X1 U4853 ( .A0(refresh_cnt2536_10_), .A1(n9066), .B0(trefresh[10]), 
        .B1(n8476), .Y(n9089) );
  AOI22X1 U4854 ( .A0(refresh_cnt_10_), .A1(n8475), .B0(refresh_cnt2473_10_), 
        .B1(n8473), .Y(n9090) );
  NAND2BX1 U4855 ( .AN(cas_0_rw), .B(n9334), .Y(n8411) );
  NAND3BX1 U4856 ( .AN(stable_cnt[2]), .B(n8614), .C(n8581), .Y(n8585) );
  NAND4X1 U4857 ( .A(n9235), .B(n9236), .C(n9237), .D(n9238), .Y(n8019) );
  NAND3X1 U4858 ( .A(n8657), .B(n9234), .C(ecmd[2]), .Y(n9236) );
  NAND2X1 U4859 ( .A(n9118), .B(ras_0_ba[1]), .Y(n9237) );
  NAND2X1 U4860 ( .A(cas_0_ba[1]), .B(n9334), .Y(n9235) );
  OAI2BB2X1 U4861 ( .A0N(ras_0_ra[11]), .A1N(n9118), .B0(n9201), .B1(net1585), 
        .Y(n8092) );
  OAI2BB2X1 U4862 ( .A0N(ras_0_ra[9]), .A1N(n9118), .B0(n9201), .B1(net1587), 
        .Y(n8094) );
  OAI2BB2X1 U4863 ( .A0N(ras_0_ra[8]), .A1N(n9118), .B0(n9201), .B1(net1588), 
        .Y(n8095) );
  MXI2X1 U4864 ( .S0(n8416), .B(n9203), .A(n9202), .Y(n8093) );
  NAND2X1 U4865 ( .A(iSD_ADDR[10]), .B(n9204), .Y(n9203) );
  AOI21X1 U4866 ( .A0(n9200), .A1(n8398), .B0(n9205), .Y(n9202) );
  OAI21X1 U4867 ( .A0(n8396), .A1(n9206), .B0(n8847), .Y(n9205) );
  OAI21X1 U4868 ( .A0(n9228), .A1(net1598), .B0(n9229), .Y(n8020) );
  NOR3BX1 U4869 ( .AN(n9230), .B(n9231), .C(n9232), .Y(n9229) );
  NOR2X1 U4870 ( .A(n9204), .B(n9233), .Y(n9232) );
  NAND2X1 U4871 ( .A(cas_0_ba[0]), .B(n9334), .Y(n9230) );
  NOR2X1 U4872 ( .A(n8396), .B(n8653), .Y(n9231) );
  INVX1 U4873 ( .A(ras_0_ba[0]), .Y(n8653) );
  NOR2X1 U4874 ( .A(n8396), .B(n9174), .Y(n9170) );
  INVX1 U4875 ( .A(ras_0_ra[6]), .Y(n9174) );
  NOR2X1 U4876 ( .A(n8396), .B(n9179), .Y(n9176) );
  INVX1 U4877 ( .A(ras_0_ra[5]), .Y(n9179) );
  NOR2X1 U4878 ( .A(n8396), .B(n9183), .Y(n9181) );
  INVX1 U4879 ( .A(ras_0_ra[4]), .Y(n9183) );
  NAND2X1 U4880 ( .A(iSD_BADDR[1]), .B(n9200), .Y(n9238) );
  AO22X1 U4881 ( .A0(cas_0_ba[1]), .A1(n9334), .B0(last_ba[1]), .B1(n8441), 
        .Y(n8013) );
  AO22X1 U4882 ( .A0(cas_0_ba[0]), .A1(n9334), .B0(last_ba[0]), .B1(n8441), 
        .Y(n8014) );
  AO22X1 U4883 ( .A0(do_id_0[3]), .A1(n8411), .B0(cas_0_id[3]), .B1(n8443), 
        .Y(n8015) );
  AO22X1 U4884 ( .A0(do_id_0[2]), .A1(n8411), .B0(cas_0_id[2]), .B1(n8443), 
        .Y(n8016) );
  AO22X1 U4885 ( .A0(do_id_0[1]), .A1(n8411), .B0(cas_0_id[1]), .B1(n8443), 
        .Y(n8017) );
  AO22X1 U4886 ( .A0(do_id_0[0]), .A1(n8411), .B0(cas_0_id[0]), .B1(n8443), 
        .Y(n8018) );
  AO22X1 U4887 ( .A0(cas_pm_0), .A1(n8441), .B0(n8442), .B1(n8443), .Y(n8091)
         );
  NOR2BX1 U4888 ( .AN(cas_0_pm), .B(cas_empty), .Y(n8442) );
  OAI2BB1X1 U4889 ( .A0N(iSD_ADDR[6]), .A1N(n8416), .B0(n8428), .Y(n8097) );
  NOR3BX1 U4890 ( .AN(n9169), .B(n9170), .C(n9171), .Y(n8428) );
  NOR2X1 U4891 ( .A(n9172), .B(n9173), .Y(n9171) );
  NAND2X1 U4892 ( .A(cas_0_ca[6]), .B(n9334), .Y(n9169) );
  OAI2BB1X1 U4893 ( .A0N(iSD_ADDR[5]), .A1N(n8416), .B0(n8425), .Y(n8098) );
  NOR3BX1 U4894 ( .AN(n9175), .B(n9176), .C(n9177), .Y(n8425) );
  NOR2X1 U4895 ( .A(n8676), .B(n9172), .Y(n9177) );
  NAND2X1 U4896 ( .A(cas_0_ca[5]), .B(n9334), .Y(n9175) );
  OAI2BB1X1 U4897 ( .A0N(iSD_ADDR[4]), .A1N(n8416), .B0(n8423), .Y(n8099) );
  NOR3BX1 U4898 ( .AN(n9180), .B(n9181), .C(n9182), .Y(n8423) );
  NOR2X1 U4899 ( .A(n2878_3_), .B(n9172), .Y(n9182) );
  NAND2X1 U4900 ( .A(cas_0_ca[4]), .B(n9334), .Y(n9180) );
  OAI2BB1X1 U4901 ( .A0N(iSD_ADDR[2]), .A1N(n8416), .B0(n8421), .Y(n8101) );
  NOR3BX1 U4902 ( .AN(n9186), .B(n9187), .C(n9188), .Y(n8421) );
  NAND2X1 U4903 ( .A(cas_0_ca[2]), .B(n9334), .Y(n9186) );
  NOR2X1 U4904 ( .A(n8396), .B(n9189), .Y(n9187) );
  OAI2BB1X1 U4905 ( .A0N(iSD_ADDR[1]), .A1N(n8416), .B0(n8420), .Y(n8102) );
  NOR3BX1 U4906 ( .AN(n9190), .B(n9191), .C(n9188), .Y(n8420) );
  NAND2X1 U4907 ( .A(cas_0_ca[1]), .B(n9334), .Y(n9190) );
  NOR2X1 U4908 ( .A(n8396), .B(n9192), .Y(n9191) );
  OAI2BB1X1 U4909 ( .A0N(iSD_ADDR[0]), .A1N(n8416), .B0(n8417), .Y(n8103) );
  NOR3BX1 U4910 ( .AN(n9193), .B(n9194), .C(n9188), .Y(n8417) );
  NAND2X1 U4911 ( .A(cas_0_ca[0]), .B(n9334), .Y(n9193) );
  NOR2X1 U4912 ( .A(n8396), .B(n9195), .Y(n9194) );
  NOR2X1 U4913 ( .A(refresh_cnt2536_0_), .B(n8590), .Y(n9162) );
  AO21X1 U4914 ( .A0(trp_cnt[1]), .A1(n8998), .B0(n8560), .Y(n8063) );
  OAI32X1 U4915 ( .A0(n8998), .A1(n9041), .A2(n8556), .B0(n8562), .B1(n8998), 
        .Y(n8560) );
  OAI211X1 U4916 ( .A0(n8563), .A1(n8523), .B0(n8467), .C0(n8559), .Y(n8562)
         );
  NOR2BX1 U4917 ( .AN(trp_cnt[1]), .B(n9049), .Y(n8563) );
  AO21X1 U4918 ( .A0(refresh_cnt2473_5_), .A1(n8473), .B0(n8480), .Y(n8081) );
  XNOR2X1 U1_A_51 ( .A(refresh_cnt_5_), .B(carry8), .Y(refresh_cnt2473_5_) );
  AO22X1 U4919 ( .A0(trefresh[5]), .A1(n8476), .B0(refresh_cnt_5_), .B1(n8475), 
        .Y(n8480) );
  OAI221X1 U4920 ( .A0(n8612), .A1(n8582), .B0(n8591), .B1(n8524), .C0(n8613), 
        .Y(n8057) );
  NAND3BX1 U4921 ( .AN(n9036), .B(n9000), .C(n9103), .Y(n8612) );
  AOI222X1 U4922 ( .A0(n8611), .A1(n8579), .B0(n8594), .B1(n8510), .C0(
        ercmd_5_), .C1(n8582), .Y(n8613) );
  AO21X1 U4923 ( .A0(trp_cnt[0]), .A1(n8998), .B0(n8554), .Y(n8064) );
  OAI33X1 U4924 ( .A0(n8998), .A1(n9040), .A2(n8556), .B0(n8998), .B1(n8557), 
        .B2(n8558), .Y(n8554) );
  NAND2BX1 U4925 ( .AN(trp_cnt[0]), .B(n8467), .Y(n8557) );
  INVX1 U4926 ( .A(n8559), .Y(n8558) );
  AO21X1 U4927 ( .A0(refresh_cnt2473_9_), .A1(n8473), .B0(n8484), .Y(n8077) );
  XNOR2X1 U1_A_91 ( .A(refresh_cnt_9_), .B(carry4), .Y(refresh_cnt2473_9_) );
  AO22X1 U4928 ( .A0(trefresh[9]), .A1(n8476), .B0(refresh_cnt_9_), .B1(n8475), 
        .Y(n8484) );
  AO21X1 U4929 ( .A0(refresh_cnt2473_8_), .A1(n8473), .B0(n8483), .Y(n8078) );
  XNOR2X1 U1_A_81 ( .A(refresh_cnt_8_), .B(carry5), .Y(refresh_cnt2473_8_) );
  AO22X1 U4930 ( .A0(trefresh[8]), .A1(n8476), .B0(refresh_cnt_8_), .B1(n8475), 
        .Y(n8483) );
  AO21X1 U4931 ( .A0(refresh_cnt2473_7_), .A1(n8473), .B0(n8482), .Y(n8079) );
  XNOR2X1 U1_A_71 ( .A(refresh_cnt_7_), .B(carry6), .Y(refresh_cnt2473_7_) );
  AO22X1 U4932 ( .A0(trefresh[7]), .A1(n8476), .B0(refresh_cnt_7_), .B1(n8475), 
        .Y(n8482) );
  AO21X1 U4933 ( .A0(refresh_cnt2473_6_), .A1(n8473), .B0(n8481), .Y(n8080) );
  XNOR2X1 U1_A_61 ( .A(refresh_cnt_6_), .B(carry7), .Y(refresh_cnt2473_6_) );
  AO22X1 U4934 ( .A0(trefresh[6]), .A1(n8476), .B0(refresh_cnt_6_), .B1(n8475), 
        .Y(n8481) );
  AO21X1 U4935 ( .A0(refresh_cnt2473_4_), .A1(n8473), .B0(n8479), .Y(n8082) );
  XNOR2X1 U1_A_42 ( .A(refresh_cnt_4_), .B(carry9), .Y(refresh_cnt2473_4_) );
  AO22X1 U4936 ( .A0(trefresh[4]), .A1(n8476), .B0(refresh_cnt_4_), .B1(n8475), 
        .Y(n8479) );
  AO21X1 U4937 ( .A0(refresh_cnt2473_3_), .A1(n8473), .B0(n8478), .Y(n8083) );
  XNOR2X1 U1_A_32 ( .A(refresh_cnt_3_), .B(carry10), .Y(refresh_cnt2473_3_) );
  AO22X1 U4938 ( .A0(trefresh[3]), .A1(n8476), .B0(refresh_cnt_3_), .B1(n8475), 
        .Y(n8478) );
  AO21X1 U4939 ( .A0(refresh_cnt2473_2_), .A1(n8473), .B0(n8477), .Y(n8084) );
  XNOR2X1 U1_A_22 ( .A(n8302), .B(carry11), .Y(refresh_cnt2473_2_) );
  AO22X1 U4940 ( .A0(trefresh[2]), .A1(n8476), .B0(n8302), .B1(n8475), .Y(
        n8477) );
  AO21X1 U4941 ( .A0(refresh_cnt2473_1_), .A1(n8473), .B0(n8474), .Y(n8085) );
  XNOR2X1 U1_A_17 ( .A(refresh_cnt_1_), .B(refresh_cnt2536_0_), .Y(
        refresh_cnt2473_1_) );
  AO22X1 U4942 ( .A0(refresh_cnt_1_), .A1(n8475), .B0(trefresh[1]), .B1(n8476), 
        .Y(n8474) );
  AO21X1 U4943 ( .A0(iSD_ADDR[7]), .A1(n8416), .B0(n8433), .Y(n8096) );
  NAND2X1 U4944 ( .A(n9167), .B(n9168), .Y(n8433) );
  NAND2X1 U4945 ( .A(ras_0_ra[7]), .B(n9118), .Y(n9168) );
  NAND2X1 U4946 ( .A(cas_0_ca[7]), .B(n9334), .Y(n9167) );
  AO21X1 U4947 ( .A0(iSD_ADDR[3]), .A1(n8416), .B0(n8422), .Y(n8100) );
  NAND2X1 U4948 ( .A(n9184), .B(n9185), .Y(n8422) );
  NAND2X1 U4949 ( .A(ras_0_ra[3]), .B(n9118), .Y(n9185) );
  NAND2X1 U4950 ( .A(cas_0_ca[3]), .B(n9334), .Y(n9184) );
  OAI211X1 U4951 ( .A0(n8597), .A1(n9074), .B0(n8598), .C0(n8599), .Y(n8058)
         );
  AOI32X1 U4952 ( .A0(stable_cnt[0]), .A1(n9111), .A2(n8581), .B0(ercmd_4_), 
        .B1(n8582), .Y(n8599) );
  AOI32X1 U4953 ( .A0(n8593), .A1(n8570), .A2(n8594), .B0(n8594), .B1(n8601), 
        .Y(n8598) );
  OAI211X1 U4954 ( .A0(n8564), .A1(n8602), .B0(n8603), .C0(n8604), .Y(n8601)
         );
  OR2X1 U4955 ( .A(refresh_cnt_13_), .B(n9092), .Y(n9091) );
  OR2X1 U4956 ( .A(refresh_cnt_12_), .B(n9093), .Y(n9092) );
  OR2X1 U4957 ( .A(refresh_cnt_11_), .B(n9094), .Y(n9093) );
  OR2X1 U4958 ( .A(refresh_cnt_10_), .B(carry_10_), .Y(n9094) );
  OR3X2 U4959 ( .A(n8735), .B(n9095), .C(n8743), .Y(n8508) );
  NAND2BX1 U4960 ( .AN(stable_cnt[0]), .B(n9000), .Y(n8622) );
  NAND2X1 U4961 ( .A(cas_empty), .B(ras_empty), .Y(n8735) );
  NAND4BX1 U4962 ( .AN(n8296), .B(n9095), .C(n9097), .D(n9099), .Y(n8607) );
  NAND4BX1 U4963 ( .AN(ar_cnt[3]), .B(n9028), .C(n9003), .D(n8985), .Y(n8637)
         );
  NAND2BX1 U4964 ( .AN(trc_cnt[1]), .B(n8634), .Y(n8548) );
  INVX1 U4965 ( .A(n8525), .Y(n8519) );
  NAND4BX1 U4966 ( .AN(n8623), .B(bf_0idle), .C(n8624), .D(BA_STS[2]), .Y(
        n8525) );
  INVX1 U4967 ( .A(bf_1idle), .Y(n8623) );
  NOR2BX1 U4968 ( .AN(bf_3idle), .B(n8625), .Y(n8624) );
  NAND3BX1 U4969 ( .AN(n8788), .B(n8297), .C(n8295), .Y(n8743) );
  NAND3BX1 U4970 ( .AN(n9098), .B(n8293), .C(n8296), .Y(n8788) );
  NAND3BX1 U4971 ( .AN(n8302), .B(n9101), .C(n8502), .Y(n8552) );
  NAND2BX1 U4972 ( .AN(stable_cnt[2]), .B(SDREn), .Y(n8531) );
  INVX1 U4973 ( .A(n8744), .Y(n8732) );
  NAND3BX1 U4974 ( .AN(n9095), .B(n8295), .C(n8746), .Y(n8744) );
  NAND2BX1 U4975 ( .AN(n8297), .B(n8732), .Y(n8608) );
  XOR2X1 U4976 ( .A(refresh_cnt_15_), .B(n9096), .Y(refresh_cnt2473_15_) );
  NOR2X1 U4977 ( .A(refresh_cnt_14_), .B(carry), .Y(n9096) );
  XNOR2X1 U1_A_141 ( .A(refresh_cnt_14_), .B(carry), .Y(refresh_cnt2473_14_)
         );
  XNOR2X1 U1_A_131 ( .A(refresh_cnt_13_), .B(carry0), .Y(refresh_cnt2473_13_)
         );
  XNOR2X1 U1_A_121 ( .A(refresh_cnt_12_), .B(carry1), .Y(refresh_cnt2473_12_)
         );
  NAND2BX1 U4978 ( .AN(ar_cnt[0]), .B(n8763), .Y(n8753) );
  NAND2BX1 U4979 ( .AN(SelfRefEn), .B(n8747), .Y(n8639) );
  AO21X1 U4980 ( .A0(ar_cnt[0]), .A1(n8763), .B0(n8765), .Y(n8757) );
  AO21X1 U4981 ( .A0(trc_cnt[0]), .A1(n8545), .B0(n8549), .Y(n8541) );
  OAI221X1 U4982 ( .A0(n8295), .A1(n8296), .B0(n9099), .B1(n9001), .C0(n9097), 
        .Y(n8604) );
  MXI2X1 U4983 ( .S0(n9138), .B(n9137), .A(n9136), .Y(n9127) );
  NAND2X1 U4984 ( .A(n9012), .B(n9039), .Y(n9136) );
  NAND2X1 U4985 ( .A(n9131), .B(n9139), .Y(n9137) );
  OAI2BB2X1 U4986 ( .A0N(rw_bstop1), .A1N(n9212), .B0(n9139), .B1(n9211), .Y(
        n8090) );
  NAND2X1 U4987 ( .A(n9213), .B(n9138), .Y(n9211) );
  NOR2X1 U4988 ( .A(n9333), .B(n9214), .Y(n9213) );
  NAND2X1 U4989 ( .A(n9215), .B(cas_0_rw), .Y(n9214) );
  NAND3BX1 U4990 ( .AN(n8850), .B(n8619), .C(n8851), .Y(carry_10_) );
  NAND3BX1 U4991 ( .AN(refresh_cnt_5_), .B(n9004), .C(n8987), .Y(n8850) );
  AND4X1 U4992 ( .A(n9006), .B(n9032), .C(n8988), .D(n8975), .Y(n8851) );
  OR2X1 U4993 ( .A(n7473), .B(n9121), .Y(n8741) );
  NOR2BX1 U4994 ( .AN(ercmd_0_), .B(n8581), .Y(n8062) );
  NAND2X1 U4995 ( .A(n8294), .B(n8297), .Y(n9155) );
  BUFX2 U4996 ( .A(AddrSwapEn), .Y(n9342) );
  NOR2X1 U4997 ( .A(n9132), .B(n9133), .Y(n9130) );
  NAND2X1 U4998 ( .A(n9134), .B(rs_state_2_), .Y(n9133) );
  NAND2X1 U4999 ( .A(n9104), .B(n9135), .Y(n9134) );
  OAI31X1 U5000 ( .A0(n8787), .A1(n8297), .A2(n8293), .B0(n8743), .Y(n8747) );
  NAND3BX1 U5001 ( .AN(n8294), .B(n9001), .C(n9108), .Y(n8787) );
  NAND2X1 U5002 ( .A(n9152), .B(n9153), .Y(n8603) );
  NOR3BX1 U5003 ( .AN(BA_STS[2]), .B(n9154), .C(n8741), .Y(n9153) );
  OAI21X1 U5004 ( .A0(n9155), .A1(n9156), .B0(n8293), .Y(n9154) );
  NAND2X1 U5005 ( .A(n8296), .B(n8295), .Y(n9156) );
  NAND2BX1 U5006 ( .AN(trc_cnt[0]), .B(n8545), .Y(n8537) );
  AO21X1 U5007 ( .A0(n8668), .A1(n7473), .B0(n8671), .Y(n8672) );
  OR2X1 U1_B_16 ( .A(refresh_cnt_1_), .B(refresh_cnt2536_0_), .Y(carry11) );
  OR2X1 U1_B_111 ( .A(refresh_cnt_11_), .B(carry2), .Y(carry1) );
  AO21X1 U5008 ( .A0(trc_cnt[1]), .A1(n8545), .B0(n8541), .Y(n8542) );
  OR2X1 U1_B_7 ( .A(PwDnCnt[7]), .B(carry23), .Y(carry22) );
  OR2X1 U1_B_9 ( .A(PwDnCnt[9]), .B(carry21), .Y(carry20) );
  OR2X1 U1_B_51 ( .A(refresh_cnt_5_), .B(carry8), .Y(carry7) );
  OR2X1 U1_B_1 ( .A(PwDnCnt[1]), .B(PwDnCnt[0]), .Y(carry28) );
  OR2X1 U1_B_2 ( .A(PwDnCnt[2]), .B(carry28), .Y(carry27) );
  OR2X1 U1_B_3 ( .A(PwDnCnt[3]), .B(carry27), .Y(carry26) );
  OR2X1 U1_B_4 ( .A(PwDnCnt[4]), .B(carry26), .Y(carry25) );
  OR2X1 U1_B_5 ( .A(PwDnCnt[5]), .B(carry25), .Y(carry24) );
  OR2X1 U1_B_6 ( .A(PwDnCnt[6]), .B(carry24), .Y(carry23) );
  OR2X1 U1_B_8 ( .A(PwDnCnt[8]), .B(carry22), .Y(carry21) );
  OR2X1 U1_B_10 ( .A(PwDnCnt[10]), .B(carry20), .Y(carry19) );
  OR2X1 U1_B_11 ( .A(PwDnCnt[11]), .B(carry19), .Y(carry18) );
  OR2X1 U1_B_12 ( .A(PwDnCnt[12]), .B(carry18), .Y(carry17) );
  OR2X1 U1_B_13 ( .A(PwDnCnt[13]), .B(carry17), .Y(carry16) );
  OR2X1 U1_B_101 ( .A(refresh_cnt_10_), .B(carry3), .Y(carry2) );
  OR2X1 U1_B_121 ( .A(refresh_cnt_12_), .B(carry1), .Y(carry0) );
  OR2X1 U1_B_131 ( .A(refresh_cnt_13_), .B(carry0), .Y(carry) );
  OR2X1 U1_B_22 ( .A(n8302), .B(carry11), .Y(carry10) );
  OR2X1 U1_B_32 ( .A(refresh_cnt_3_), .B(carry10), .Y(carry9) );
  OR2X1 U1_B_41 ( .A(refresh_cnt_4_), .B(carry9), .Y(carry8) );
  OR2X1 U1_B_61 ( .A(refresh_cnt_6_), .B(carry7), .Y(carry6) );
  OR2X1 U1_B_71 ( .A(refresh_cnt_7_), .B(carry6), .Y(carry5) );
  OR2X1 U1_B_81 ( .A(refresh_cnt_8_), .B(carry5), .Y(carry4) );
  OR2X1 U1_B_91 ( .A(refresh_cnt_9_), .B(carry4), .Y(carry3) );
  OAI222X1 U5009 ( .A0(n8535), .A1(n9014), .B0(trc_cnt[1]), .B1(n8537), .C0(
        n8539), .C1(n9043), .Y(n8067) );
  INVX1 U5010 ( .A(n8541), .Y(n8539) );
  INVX1 U5011 ( .A(n8792), .Y(n8634) );
  NAND3BX1 U5012 ( .AN(trc_cnt[3]), .B(n9033), .C(n8986), .Y(n8792) );
  OAI222X1 U5013 ( .A0(n8751), .A1(n9046), .B0(ar_cnt[1]), .B1(n8753), .C0(
        n8755), .C1(n8985), .Y(n8003) );
  INVX1 U5014 ( .A(n8757), .Y(n8755) );
  OAI2BB1X1 U5015 ( .A0N(trc_cnt[3]), .A1N(n8542), .B0(n8546), .Y(n8065) );
  AOI32X1 U5016 ( .A0(trc_cnt[2]), .A1(trc_cnt[3]), .A2(n8545), .B0(trc[3]), 
        .B1(n8547), .Y(n8546) );
  INVX1 U5017 ( .A(n8535), .Y(n8547) );
  NOR2X1 U5018 ( .A(n8293), .B(n9098), .Y(n9097) );
  OAI2BB1X1 U5019 ( .A0N(n8668), .A1N(n8995), .B0(n8669), .Y(n8012) );
  AOI21X1 U5020 ( .A0(n8671), .A1(n7473), .B0(n9141), .Y(n8669) );
  NOR2X1 U5021 ( .A(n8677), .B(n9142), .Y(n9141) );
  NAND2X1 U5022 ( .A(n8451), .B(n9013), .Y(n9142) );
  AO21X1 U5023 ( .A0(ar_cnt[1]), .A1(n8763), .B0(n8757), .Y(n8758) );
  OAI2BB1X1 U5024 ( .A0N(ar_cnt[3]), .A1N(n8758), .B0(n8764), .Y(n8001) );
  AOI32X1 U5025 ( .A0(ar_cnt[2]), .A1(ar_cnt[3]), .A2(n8763), .B0(refreshno[3]), .B1(n8762), .Y(n8764) );
  NOR2X1 U5026 ( .A(n8295), .B(n9100), .Y(n9099) );
  OAI221X1 U5027 ( .A0(n8749), .A1(n9003), .B0(n8751), .B1(n9047), .C0(n8753), 
        .Y(n8004) );
  AO21X1 U5028 ( .A0(PwDnCnt614_15_), .A1(n8803), .B0(n8820), .Y(n7982) );
  AO22X1 U5029 ( .A0(PwDnCnt[15]), .A1(n8805), .B0(PwDnRef[15]), .B1(n9340), 
        .Y(n8820) );
  XNOR2X1 U1_A_15 ( .A(PwDnCnt[15]), .B(carry15), .Y(PwDnCnt614_15_) );
  OR2X1 U1_B_14 ( .A(PwDnCnt[14]), .B(carry16), .Y(carry15) );
  AO21X1 U5030 ( .A0(PwDnCnt614_14_), .A1(n8803), .B0(n8819), .Y(n7983) );
  AO22X1 U5031 ( .A0(PwDnCnt[14]), .A1(n8805), .B0(PwDnRef[14]), .B1(n9340), 
        .Y(n8819) );
  XNOR2X1 U1_A_14 ( .A(PwDnCnt[14]), .B(carry16), .Y(PwDnCnt614_14_) );
  AND2X2 U5032 ( .A(n9102), .B(n9002), .Y(n9101) );
  AO21X1 U5033 ( .A0(trc_cnt[2]), .A1(n8542), .B0(n8543), .Y(n8066) );
  OAI32X1 U5034 ( .A0(n8537), .A1(trc_cnt[2]), .A2(trc_cnt[1]), .B0(n8535), 
        .B1(n9015), .Y(n8543) );
  AO21X1 U5035 ( .A0(rs_state_2_), .A1(n8672), .B0(n8678), .Y(n8010) );
  OAI33X1 U5036 ( .A0(n8674), .A1(n8974), .A2(n8982), .B0(n8677), .B1(cas_0_rw), .B2(n9078), .Y(n8678) );
  AO21X1 U5037 ( .A0(rs_state_1_), .A1(n8672), .B0(n8673), .Y(n8011) );
  OAI31X1 U5038 ( .A0(n8674), .A1(rs_state_1_), .A2(n7473), .B0(n8675), .Y(
        n8673) );
  OA22X1 U5039 ( .A0(n8676), .A1(n8677), .B0(n8677), .B1(n8451), .Y(n8675) );
  OAI2BB1X1 U5040 ( .A0N(ar_cnt[2]), .A1N(n8758), .B0(n8759), .Y(n8002) );
  AOI32X1 U5041 ( .A0(n8985), .A1(n9028), .A2(n8761), .B0(refreshno[2]), .B1(
        n8762), .Y(n8759) );
  INVX1 U5042 ( .A(n8753), .Y(n8761) );
  NAND2BX1 U5043 ( .AN(PWRITE), .B(n9030), .Y(n8938) );
  NAND4BX1 U5044 ( .AN(n8916), .B(n8917), .C(n8918), .D(n8919), .Y(n8414) );
  NAND4BX1 U5045 ( .AN(PwDnCnt[9]), .B(n8977), .C(n8990), .D(n9038), .Y(n8916)
         );
  AND4X1 U5046 ( .A(n8979), .B(n8991), .C(n8972), .D(n9011), .Y(n8917) );
  AND4X1 U5047 ( .A(n9009), .B(n8992), .C(n8978), .D(n8971), .Y(n8918) );
  NAND2BX1 U5048 ( .AN(stable_cnt[0]), .B(stable_cnt[1]), .Y(n8551) );
  OR2X1 U5049 ( .A(trp_cnt[0]), .B(trp_cnt[1]), .Y(n8570) );
  XNOR2X1 U1_A_111 ( .A(refresh_cnt_11_), .B(carry2), .Y(refresh_cnt2473_11_)
         );
  XNOR2X1 U1_A_101 ( .A(refresh_cnt_10_), .B(carry3), .Y(refresh_cnt2473_10_)
         );
  NOR2X1 U5050 ( .A(tmrs_cnt[0]), .B(tmrs_cnt[1]), .Y(n9103) );
  OAI31X1 U5051 ( .A0(n8821), .A1(n8741), .A2(n8822), .B0(n8800), .Y(n8798) );
  NAND4BX1 U5052 ( .AN(n8824), .B(bf_2idle), .C(PwDnEn), .D(bf_3idle), .Y(
        n8822) );
  NAND3BX1 U5053 ( .AN(SelfRefEn), .B(bf_0idle), .C(bf_1idle), .Y(n8824) );
  OAI31X1 U5054 ( .A0(n8564), .A1(n8510), .A2(n8565), .B0(n8566), .Y(n8559) );
  NAND2BX1 U5055 ( .AN(stable_cnt[1]), .B(refresh_cnt_1_), .Y(n8565) );
  AO21X1 U5056 ( .A0(n8510), .A1(n9000), .B0(n8523), .Y(n8566) );
  NAND2X1 U5057 ( .A(PWRITE), .B(n9030), .Y(n8646) );
  NAND3X1 U5058 ( .A(n9207), .B(n9024), .C(n8439), .Y(n8398) );
  NAND2X1 U5059 ( .A(ercmd_3_), .B(n8967), .Y(n9207) );
  AOI211X1 U5060 ( .A0(ercmd_2_), .A1(n9343), .B0(n9076), .C0(n8409), .Y(n8439) );
  NOR2BX1 U5061 ( .AN(refreshno[1]), .B(n9336), .Y(PRDATA465_17_) );
  NOR2BX1 U5062 ( .AN(stable_cnt[0]), .B(n9336), .Y(PRDATA465_20_) );
  NOR2BX1 U5063 ( .AN(n8297), .B(n9336), .Y(PRDATA465_24_) );
  NOR2BX1 U5064 ( .AN(n8294), .B(n9336), .Y(PRDATA465_27_) );
  NOR2BX1 U5065 ( .AN(refreshno[3]), .B(n8891), .Y(PRDATA465_19_) );
  NOR2BX1 U5066 ( .AN(stable_cnt[2]), .B(n8891), .Y(PRDATA465_22_) );
  NOR2BX1 U5067 ( .AN(n8295), .B(n8891), .Y(PRDATA465_26_) );
  NOR2BX1 U5068 ( .AN(refreshno[2]), .B(n9335), .Y(PRDATA465_18_) );
  NOR2BX1 U5069 ( .AN(stable_cnt[1]), .B(n9335), .Y(PRDATA465_21_) );
  NOR2BX1 U5070 ( .AN(n8296), .B(n9335), .Y(PRDATA465_25_) );
  NOR2BX1 U5071 ( .AN(n8293), .B(n9335), .Y(PRDATA465_28_) );
  NAND2BX1 U5072 ( .AN(n9036), .B(stable_cnt[1]), .Y(n8574) );
  INVX1 U5073 ( .A(bf_2idle), .Y(n8625) );
  NAND2X1 U5074 ( .A(n8616), .B(SDREn), .Y(n9160) );
  XOR2X1 U5075 ( .A(n8622), .B(stable_cnt[2]), .Y(n8616) );
  AND2X2 U5076 ( .A(n9105), .B(n8705), .Y(n9104) );
  XNOR2X1 U5077 ( .A(ras_0_ba[0]), .B(last_ba[0]), .Y(n9105) );
  AOI32X1 U5078 ( .A0(n8610), .A1(n8632), .A2(n8588), .B0(n8572), .B1(n8633), 
        .Y(n8631) );
  INVX1 U5079 ( .A(n8531), .Y(n8632) );
  AND4X1 U5080 ( .A(n8634), .B(n9101), .C(trc_cnt[1]), .D(n8636), .Y(n8633) );
  INVX1 U5081 ( .A(n8637), .Y(n8636) );
  AO22X1 U5082 ( .A0(n2878_3_), .A1(n9341), .B0(n8649), .B1(PWDATA[4]), .Y(
        n8027) );
  NAND2X1 U5083 ( .A(n9106), .B(n8711), .Y(n8009) );
  XNOR2X1 U5084 ( .A(n8297), .B(n8712), .Y(n9106) );
  OAI222X1 U5085 ( .A0(n8798), .A1(n9009), .B0(n8800), .B1(n9048), .C0(
        PwDnCnt[0]), .C1(n8802), .Y(n7997) );
  AO22X1 U5086 ( .A0(trp[1]), .A1(n9341), .B0(n8649), .B1(PWDATA[1]), .Y(n8021) );
  AO22X1 U5087 ( .A0(trcd[1]), .A1(n9341), .B0(n8649), .B1(PWDATA[3]), .Y(
        n8023) );
  AO22X1 U5088 ( .A0(trasmin[2]), .A1(n9341), .B0(n8649), .B1(PWDATA[10]), .Y(
        n8029) );
  AO22X1 U5089 ( .A0(trasmin[1]), .A1(n9341), .B0(n8649), .B1(PWDATA[9]), .Y(
        n8030) );
  AO22X1 U5090 ( .A0(trasmin[0]), .A1(n9341), .B0(n8649), .B1(PWDATA[8]), .Y(
        n8031) );
  AO22X1 U5091 ( .A0(trc[3]), .A1(n9341), .B0(n8649), .B1(PWDATA[15]), .Y(
        n8032) );
  AO22X1 U5092 ( .A0(trc[1]), .A1(n9341), .B0(n8649), .B1(PWDATA[13]), .Y(
        n8034) );
  AO22X1 U5093 ( .A0(PwDnRef[15]), .A1(n9337), .B0(n8643), .B1(PWDATA[15]), 
        .Y(n7962) );
  AO22X1 U5094 ( .A0(PwDnRef[14]), .A1(n9337), .B0(n8643), .B1(PWDATA[14]), 
        .Y(n7963) );
  AO22X1 U5095 ( .A0(PwDnRef[13]), .A1(n9337), .B0(n8643), .B1(PWDATA[13]), 
        .Y(n7964) );
  AO22X1 U5096 ( .A0(PwDnRef[12]), .A1(n9337), .B0(n8643), .B1(PWDATA[12]), 
        .Y(n7965) );
  AO22X1 U5097 ( .A0(PwDnRef[11]), .A1(n9337), .B0(n8643), .B1(PWDATA[11]), 
        .Y(n7966) );
  AO22X1 U5098 ( .A0(PwDnRef[10]), .A1(n9337), .B0(n8643), .B1(PWDATA[10]), 
        .Y(n7967) );
  AO22X1 U5099 ( .A0(PwDnRef[9]), .A1(n9337), .B0(n8643), .B1(PWDATA[9]), .Y(
        n7968) );
  AO22X1 U5100 ( .A0(PwDnRef[8]), .A1(n9337), .B0(n8643), .B1(PWDATA[8]), .Y(
        n7969) );
  AO22X1 U5101 ( .A0(PwDnRef[7]), .A1(n9337), .B0(n8643), .B1(PWDATA[7]), .Y(
        n7970) );
  AO22X1 U5102 ( .A0(PwDnRef[6]), .A1(n9337), .B0(n8643), .B1(PWDATA[6]), .Y(
        n7971) );
  AO22X1 U5103 ( .A0(PwDnRef[5]), .A1(n9337), .B0(n8643), .B1(PWDATA[5]), .Y(
        n7972) );
  AO22X1 U5104 ( .A0(PwDnRef[4]), .A1(n9337), .B0(n8643), .B1(PWDATA[4]), .Y(
        n7973) );
  AO22X1 U5105 ( .A0(PwDnRef[3]), .A1(n9337), .B0(n8643), .B1(PWDATA[3]), .Y(
        n7974) );
  AO22X1 U5106 ( .A0(PwDnRef[2]), .A1(n9337), .B0(n8643), .B1(PWDATA[2]), .Y(
        n7975) );
  AO22X1 U5107 ( .A0(PwDnRef[1]), .A1(n9337), .B0(n8643), .B1(PWDATA[1]), .Y(
        n7976) );
  AO22X1 U5108 ( .A0(PwDnRef[0]), .A1(n9337), .B0(n8643), .B1(PWDATA[0]), .Y(
        n7977) );
  AO22X1 U5109 ( .A0(trefresh[11]), .A1(n9339), .B0(PWDATA[11]), .B1(n8641), 
        .Y(n8044) );
  AO22X1 U5110 ( .A0(trefresh[5]), .A1(n9339), .B0(PWDATA[5]), .B1(n8641), .Y(
        n8050) );
  OAI222X1 U5111 ( .A0(n8979), .A1(n8887), .B0(n9017), .B1(n8889), .C0(n9055), 
        .C1(n9335), .Y(PRDATA465_2_) );
  OAI222X1 U5112 ( .A0(n8991), .A1(n8887), .B0(n9019), .B1(n8889), .C0(n9056), 
        .C1(n9335), .Y(PRDATA465_3_) );
  OAI222X1 U5113 ( .A0(n8972), .A1(n8887), .B0(n9013), .B1(n8889), .C0(n9057), 
        .C1(n9335), .Y(PRDATA465_4_) );
  OAI222X1 U5114 ( .A0(n9011), .A1(n8887), .B0(n8983), .B1(n8889), .C0(n9062), 
        .C1(n9335), .Y(PRDATA465_5_) );
  OAI222X1 U5115 ( .A0(n8990), .A1(n8887), .B0(n9114), .B1(n8889), .C0(n9058), 
        .C1(n9335), .Y(PRDATA465_6_) );
  OAI222X1 U5116 ( .A0(n8977), .A1(n8887), .B0(n9020), .B1(n8889), .C0(n9059), 
        .C1(n9335), .Y(PRDATA465_8_) );
  OAI222X1 U5117 ( .A0(n8994), .A1(n8887), .B0(n9023), .B1(n8889), .C0(n9060), 
        .C1(n9335), .Y(PRDATA465_9_) );
  OAI222X1 U5118 ( .A0(n8992), .A1(n8887), .B0(n9053), .B1(n8889), .C0(n9022), 
        .C1(n9335), .Y(PRDATA465_10_) );
  OAI222X1 U5119 ( .A0(n8978), .A1(n8887), .B0(n9018), .B1(n8889), .C0(n9054), 
        .C1(n9335), .Y(PRDATA465_11_) );
  OAI222X1 U5120 ( .A0(n8971), .A1(n8887), .B0(n9016), .B1(n8889), .C0(n9050), 
        .C1(n9336), .Y(PRDATA465_12_) );
  OAI222X1 U5121 ( .A0(n8980), .A1(n8887), .B0(n9014), .B1(n8889), .C0(n9051), 
        .C1(n9335), .Y(PRDATA465_13_) );
  OAI222X1 U5122 ( .A0(n8993), .A1(n8887), .B0(n9015), .B1(n8889), .C0(n9052), 
        .C1(n9335), .Y(PRDATA465_14_) );
  OAI222X1 U5123 ( .A0(n8973), .A1(n8887), .B0(n9061), .B1(n8889), .C0(n9021), 
        .C1(n9336), .Y(PRDATA465_15_) );
  AND3X2 U5124 ( .A(n9108), .B(n9100), .C(n8746), .Y(n9107) );
  OAI2BB1X1 U5125 ( .A0N(rw_bstop0), .A1N(n9212), .B0(n9216), .Y(n8089) );
  OAI21X1 U5126 ( .A0(n9217), .A1(n9218), .B0(n9138), .Y(n9216) );
  NOR2X1 U5127 ( .A(n9219), .B(n9220), .Y(n9218) );
  NOR2X1 U5128 ( .A(n8451), .B(n9221), .Y(n9217) );
  AO22X1 U5129 ( .A0(refreshno[3]), .A1(n9339), .B0(PWDATA[19]), .B1(n8641), 
        .Y(n7978) );
  AO22X1 U5130 ( .A0(refreshno[2]), .A1(n9338), .B0(PWDATA[18]), .B1(n8641), 
        .Y(n7979) );
  AO22X1 U5131 ( .A0(refreshno[1]), .A1(n8640), .B0(PWDATA[17]), .B1(n8641), 
        .Y(n7980) );
  AO22X1 U5132 ( .A0(SelfRefEn), .A1(n9337), .B0(PWDATA[31]), .B1(n8643), .Y(
        n8038) );
  AO22X1 U5133 ( .A0(refreshno[0]), .A1(n9339), .B0(PWDATA[16]), .B1(n8641), 
        .Y(n7981) );
  AO22X1 U5134 ( .A0(AddrSwapEn), .A1(n8644), .B0(n8645), .B1(PWDATA[1]), .Y(
        n8036) );
  AO22X1 U5135 ( .A0(SDREn), .A1(n8644), .B0(n8645), .B1(PWDATA[0]), .Y(n8037)
         );
  AO22X1 U5136 ( .A0(trasmin[3]), .A1(n9341), .B0(n8649), .B1(PWDATA[11]), .Y(
        n8028) );
  AO22X1 U5137 ( .A0(trc[2]), .A1(n9341), .B0(n8649), .B1(PWDATA[14]), .Y(
        n8033) );
  AO22X1 U5138 ( .A0(trc[0]), .A1(n9341), .B0(n8649), .B1(PWDATA[12]), .Y(
        n8035) );
  AO22X1 U5139 ( .A0(PwDnEn), .A1(n9337), .B0(PWDATA[16]), .B1(n8643), .Y(
        n8039) );
  AO22X1 U5140 ( .A0(trefresh[7]), .A1(n9339), .B0(PWDATA[7]), .B1(n8641), .Y(
        n8048) );
  AO22X1 U5141 ( .A0(n8896), .A1(refreshno[0]), .B0(n8821), .B1(n8895), .Y(
        PRDATA465_16_) );
  AO22X1 U5142 ( .A0(trp[0]), .A1(n9341), .B0(n8649), .B1(PWDATA[0]), .Y(n8022) );
  AO22X1 U5143 ( .A0(trcd[0]), .A1(n9341), .B0(n8649), .B1(PWDATA[2]), .Y(
        n8024) );
  AO22X1 U5144 ( .A0(tcl_2_), .A1(n9341), .B0(n8649), .B1(PWDATA[6]), .Y(n8025) );
  AO22X1 U5145 ( .A0(tcl_1_), .A1(n9341), .B0(n8649), .B1(PWDATA[5]), .Y(n8026) );
  AO22X1 U5146 ( .A0(trefresh[15]), .A1(n9338), .B0(PWDATA[15]), .B1(n8641), 
        .Y(n8040) );
  AO22X1 U5147 ( .A0(trefresh[14]), .A1(n8640), .B0(PWDATA[14]), .B1(n8641), 
        .Y(n8041) );
  AO22X1 U5148 ( .A0(trefresh[13]), .A1(n9339), .B0(PWDATA[13]), .B1(n8641), 
        .Y(n8042) );
  AO22X1 U5149 ( .A0(trefresh[12]), .A1(n9338), .B0(PWDATA[12]), .B1(n8641), 
        .Y(n8043) );
  AO22X1 U5150 ( .A0(trefresh[10]), .A1(n9339), .B0(PWDATA[10]), .B1(n8641), 
        .Y(n8045) );
  AO22X1 U5151 ( .A0(trefresh[9]), .A1(n9338), .B0(PWDATA[9]), .B1(n8641), .Y(
        n8046) );
  AO22X1 U5152 ( .A0(trefresh[8]), .A1(n9338), .B0(PWDATA[8]), .B1(n8641), .Y(
        n8047) );
  AO22X1 U5153 ( .A0(trefresh[6]), .A1(n9338), .B0(PWDATA[6]), .B1(n8641), .Y(
        n8049) );
  AO22X1 U5154 ( .A0(trefresh[4]), .A1(n9339), .B0(PWDATA[4]), .B1(n8641), .Y(
        n8051) );
  AO22X1 U5155 ( .A0(trefresh[3]), .A1(n9338), .B0(PWDATA[3]), .B1(n8641), .Y(
        n8052) );
  AO22X1 U5156 ( .A0(trefresh[2]), .A1(n9338), .B0(PWDATA[2]), .B1(n8641), .Y(
        n8053) );
  AO22X1 U5157 ( .A0(n8895), .A1(PwDnCnt[7]), .B0(n8896), .B1(trefresh[7]), 
        .Y(PRDATA465_7_) );
  AO22X1 U5158 ( .A0(trefresh[1]), .A1(n9339), .B0(PWDATA[1]), .B1(n8641), .Y(
        n8054) );
  AO22X1 U5159 ( .A0(trefresh[0]), .A1(n9338), .B0(PWDATA[0]), .B1(n8641), .Y(
        n8055) );
  OAI221X1 U5160 ( .A0(n9009), .A1(n8887), .B0(n9040), .B1(n8889), .C0(n8936), 
        .Y(PRDATA465_0_) );
  AOI32X1 U5161 ( .A0(PADDR[2]), .A1(n8937), .A2(n8915), .B0(n8896), .B1(
        trefresh[0]), .Y(n8936) );
  NOR2BX1 U5162 ( .AN(SDREnStatus), .B(PADDR[3]), .Y(n8937) );
  OAI221X1 U5163 ( .A0(n9010), .A1(n8887), .B0(n9041), .B1(n8889), .C0(n8913), 
        .Y(PRDATA465_1_) );
  AOI32X1 U5164 ( .A0(n8914), .A1(n9342), .A2(n8915), .B0(n8896), .B1(
        trefresh[1]), .Y(n8913) );
  NOR2BX1 U5165 ( .AN(PADDR[2]), .B(PADDR[3]), .Y(n8914) );
  AO21X1 U5166 ( .A0(stable_cnt[2]), .A1(n8789), .B0(n8507), .Y(n7998) );
  AO21X1 U5167 ( .A0(PwDnCnt614_13_), .A1(n8803), .B0(n8818), .Y(n7984) );
  AO22X1 U5168 ( .A0(PwDnCnt[13]), .A1(n8805), .B0(PwDnRef[13]), .B1(n9340), 
        .Y(n8818) );
  XNOR2X1 U1_A_13 ( .A(PwDnCnt[13]), .B(carry17), .Y(PwDnCnt614_13_) );
  AO21X1 U5169 ( .A0(PwDnCnt614_12_), .A1(n8803), .B0(n8817), .Y(n7985) );
  AO22X1 U5170 ( .A0(PwDnCnt[12]), .A1(n8805), .B0(PwDnRef[12]), .B1(n9340), 
        .Y(n8817) );
  XNOR2X1 U1_A_12 ( .A(PwDnCnt[12]), .B(carry18), .Y(PwDnCnt614_12_) );
  AO21X1 U5171 ( .A0(PwDnCnt614_11_), .A1(n8803), .B0(n8816), .Y(n7986) );
  AO22X1 U5172 ( .A0(PwDnCnt[11]), .A1(n8805), .B0(PwDnRef[11]), .B1(n9340), 
        .Y(n8816) );
  XNOR2X1 U1_A_11 ( .A(PwDnCnt[11]), .B(carry19), .Y(PwDnCnt614_11_) );
  AO21X1 U5173 ( .A0(PwDnCnt614_10_), .A1(n8803), .B0(n8815), .Y(n7987) );
  AO22X1 U5174 ( .A0(PwDnCnt[10]), .A1(n8805), .B0(PwDnRef[10]), .B1(n9340), 
        .Y(n8815) );
  XNOR2X1 U1_A_10 ( .A(PwDnCnt[10]), .B(carry20), .Y(PwDnCnt614_10_) );
  AO21X1 U5175 ( .A0(PwDnCnt614_9_), .A1(n8803), .B0(n8814), .Y(n7988) );
  AO22X1 U5176 ( .A0(PwDnCnt[9]), .A1(n8805), .B0(PwDnRef[9]), .B1(n9340), .Y(
        n8814) );
  XNOR2X1 U1_A_9 ( .A(PwDnCnt[9]), .B(carry21), .Y(PwDnCnt614_9_) );
  AO21X1 U5177 ( .A0(PwDnCnt614_8_), .A1(n8803), .B0(n8813), .Y(n7989) );
  XNOR2X1 U1_A_8 ( .A(PwDnCnt[8]), .B(carry22), .Y(PwDnCnt614_8_) );
  AO22X1 U5178 ( .A0(PwDnCnt[8]), .A1(n8805), .B0(PwDnRef[8]), .B1(n9340), .Y(
        n8813) );
  AO21X1 U5179 ( .A0(PwDnCnt614_7_), .A1(n8803), .B0(n8812), .Y(n7990) );
  XNOR2X1 U1_A_7 ( .A(PwDnCnt[7]), .B(carry23), .Y(PwDnCnt614_7_) );
  AO22X1 U5180 ( .A0(PwDnCnt[7]), .A1(n8805), .B0(PwDnRef[7]), .B1(n9340), .Y(
        n8812) );
  AO21X1 U5181 ( .A0(PwDnCnt614_6_), .A1(n8803), .B0(n8811), .Y(n7991) );
  XNOR2X1 U1_A_6 ( .A(PwDnCnt[6]), .B(carry24), .Y(PwDnCnt614_6_) );
  AO22X1 U5182 ( .A0(PwDnCnt[6]), .A1(n8805), .B0(PwDnRef[6]), .B1(n9340), .Y(
        n8811) );
  AO21X1 U5183 ( .A0(PwDnCnt614_5_), .A1(n8803), .B0(n8810), .Y(n7992) );
  XNOR2X1 U1_A_5 ( .A(PwDnCnt[5]), .B(carry25), .Y(PwDnCnt614_5_) );
  AO22X1 U5184 ( .A0(PwDnCnt[5]), .A1(n8805), .B0(PwDnRef[5]), .B1(n9340), .Y(
        n8810) );
  AO21X1 U5185 ( .A0(PwDnCnt614_4_), .A1(n8803), .B0(n8809), .Y(n7993) );
  XNOR2X1 U1_A_4 ( .A(PwDnCnt[4]), .B(carry26), .Y(PwDnCnt614_4_) );
  AO22X1 U5186 ( .A0(PwDnCnt[4]), .A1(n8805), .B0(PwDnRef[4]), .B1(n9340), .Y(
        n8809) );
  AO21X1 U5187 ( .A0(PwDnCnt614_3_), .A1(n8803), .B0(n8808), .Y(n7994) );
  XNOR2X1 U1_A_3 ( .A(PwDnCnt[3]), .B(carry27), .Y(PwDnCnt614_3_) );
  AO22X1 U5188 ( .A0(PwDnCnt[3]), .A1(n8805), .B0(PwDnRef[3]), .B1(n9340), .Y(
        n8808) );
  AO21X1 U5189 ( .A0(PwDnCnt614_2_), .A1(n8803), .B0(n8807), .Y(n7995) );
  XNOR2X1 U1_A_2 ( .A(PwDnCnt[2]), .B(carry28), .Y(PwDnCnt614_2_) );
  AO22X1 U5190 ( .A0(PwDnCnt[2]), .A1(n8805), .B0(PwDnRef[2]), .B1(n9340), .Y(
        n8807) );
  AO21X1 U5191 ( .A0(PwDnCnt614_1_), .A1(n8803), .B0(n8804), .Y(n7996) );
  XNOR2X1 U1_A_1 ( .A(PwDnCnt[1]), .B(PwDnCnt[0]), .Y(PwDnCnt614_1_) );
  AO22X1 U5192 ( .A0(PwDnCnt[1]), .A1(n8805), .B0(PwDnRef[1]), .B1(n9340), .Y(
        n8804) );
  OA21X2 U5193 ( .A0(n8523), .A1(refresh_cnt_1_), .B0(refresh_cnt2536_0_), .Y(
        n8522) );
  OAI211X1 U5194 ( .A0(n8712), .A1(n9108), .B0(n8717), .C0(n8711), .Y(n8007)
         );
  NAND2BX1 U5195 ( .AN(n8715), .B(selfref_cnt2159_2_), .Y(n8717) );
  XNOR2X1 U1_A_21 ( .A(n8295), .B(carry14), .Y(selfref_cnt2159_2_) );
  OAI211X1 U5196 ( .A0(n8712), .A1(n9001), .B0(n8714), .C0(n8711), .Y(n8008)
         );
  NAND2BX1 U5197 ( .AN(n8715), .B(selfref_cnt2159_1_), .Y(n8714) );
  XNOR2X1 U1_A_16 ( .A(n8296), .B(n8297), .Y(selfref_cnt2159_1_) );
  OAI211X1 U5198 ( .A0(n8712), .A1(n9098), .B0(n8719), .C0(n8711), .Y(n8006)
         );
  NAND2BX1 U5199 ( .AN(n8715), .B(selfref_cnt2159_3_), .Y(n8719) );
  XNOR2X1 U1_A_31 ( .A(n8294), .B(carry13), .Y(selfref_cnt2159_3_) );
  OAI211X1 U5200 ( .A0(n8712), .A1(n9042), .B0(n8721), .C0(n8711), .Y(n8005)
         );
  NAND2BX1 U5201 ( .AN(n8715), .B(selfref_cnt2159_4_), .Y(n8721) );
  XNOR2X1 U1_A_41 ( .A(n8293), .B(carry12), .Y(selfref_cnt2159_4_) );
  OAI2BB2X1 U5202 ( .A0N(n9110), .A1N(n8630), .B0(n9109), .B1(n8630), .Y(n8056) );
  OAI22X1 U5203 ( .A0(stable_cnt[1]), .A1(n8503), .B0(stable_cnt[1]), .B1(
        n8508), .Y(n9110) );
  NAND2BX1 U5204 ( .AN(n8515), .B(n8631), .Y(n8630) );
  NAND2BX1 U5205 ( .AN(n8941), .B(PSEL), .Y(n8940) );
  OR2X1 U5206 ( .A(PADDR[5]), .B(PADDR[4]), .Y(n8941) );
  NAND3BX1 U5207 ( .AN(n8848), .B(n8849), .C(n9343), .Y(n8847) );
  NAND3BX1 U5208 ( .AN(ercmd_2_), .B(n8981), .C(n9024), .Y(n8848) );
  AOI22X1 U5209 ( .A0(stable_cnt[1]), .A1(n8523), .B0(n9103), .B1(n9000), .Y(
        n9111) );
  INVX1 U5210 ( .A(n8569), .Y(n8556) );
  OAI211X1 U5211 ( .A0(stable_cnt[1]), .A1(n8508), .B0(n8570), .C0(n8467), .Y(
        n8569) );
  XNOR2X1 U5212 ( .A(n9114), .B(n8432), .Y(n9173) );
  NAND2BX1 U5213 ( .AN(n9013), .B(tcl_1_), .Y(n8432) );
  NAND2X1 U5214 ( .A(n9210), .B(n8849), .Y(n9172) );
  NOR3X1 U5215 ( .A(n8967), .B(n8981), .C(ercmd_5_), .Y(n9210) );
  NAND2X1 U5216 ( .A(tmrs_cnt[0]), .B(n8467), .Y(n8527) );
  NOR2X1 U5217 ( .A(tcl_2_), .B(n8951), .Y(n9112) );
  OAI31X1 U5218 ( .A0(n8531), .A1(stable_cnt[1]), .A2(n9036), .B0(n8514), .Y(
        n8528) );
  OR3X2 U5219 ( .A(ras_full), .B(cas_full), .C(cmd_mask), .Y(BA_STS[3]) );
  INVX1 U5220 ( .A(cas_0_rw), .Y(n8451) );
  NAND2X1 U5221 ( .A(n8449), .B(n8448), .Y(n9215) );
  XOR2X1 U5222 ( .A(n8452), .B(last_ba[0]), .Y(n8449) );
  AND3X2 U5223 ( .A(n9114), .B(n8983), .C(n2878_3_), .Y(n9113) );
  OR2X1 U1_B_21 ( .A(n8295), .B(carry14), .Y(carry13) );
  OR2X1 U1_B_15 ( .A(n8296), .B(n8297), .Y(carry14) );
  INVX1 U5224 ( .A(cas_0_ba[0]), .Y(n8452) );
  INVX1 U5225 ( .A(ras_0_ra[2]), .Y(n9189) );
  INVX1 U5226 ( .A(ras_0_ra[1]), .Y(n9192) );
  INVX1 U5227 ( .A(ras_0_ra[0]), .Y(n9195) );
  AO22X1 U5228 ( .A0(n8526), .A1(tmrs_cnt[0]), .B0(n8527), .B1(n8528), .Y(
        n8070) );
  AO22X1 U5229 ( .A0(bf_last_2), .A1(n9113), .B0(bf_last_3), .B1(n9112), .Y(
        bf_last5023) );
  AO22X1 U5230 ( .A0(do_valid_2), .A1(n9113), .B0(do_valid_3), .B1(n9112), .Y(
        do_valid4741) );
  AO22X1 U5231 ( .A0(do_id_2[0]), .A1(n9113), .B0(do_id_3[0]), .B1(n9112), .Y(
        do_id4870_0_) );
  AO22X1 U5232 ( .A0(do_id_2[1]), .A1(n9113), .B0(do_id_3[1]), .B1(n9112), .Y(
        do_id4870_1_) );
  AO22X1 U5233 ( .A0(do_id_2[2]), .A1(n9113), .B0(do_id_3[2]), .B1(n9112), .Y(
        do_id4870_2_) );
  AO22X1 U5234 ( .A0(do_id_2[3]), .A1(n9113), .B0(do_id_3[3]), .B1(n9112), .Y(
        do_id4870_3_) );
  OAI2BB2X1 U5235 ( .A0N(tmrs_cnt[1]), .A1N(n8526), .B0(n9115), .B1(n8527), 
        .Y(n8069) );
  INVX1 U5236 ( .A(ras_0_ra[10]), .Y(n9206) );
  OR2X1 U1_B_31 ( .A(n8294), .B(carry13), .Y(carry12) );
  AO21X1 U5237 ( .A0(SDREn), .A1(n8467), .B0(SDREnStatus), .Y(n8087) );
  NOR2X1 U5238 ( .A(n9116), .B(cas_pm_0), .Y(bf_last_15011) );
  DFFRX1 ercmd_reg_1_ ( .D(n8061), .CK(ACLK), .RN(ARESETB), .Q(n8301), .QN(
        n9044) );
  DFFRX1 tcl_reg_1_ ( .D(n8026), .CK(PCLK), .RN(PRESETB), .Q(tcl_1_), .QN(
        n8983) );
  DFFRX1 rs_state_reg_0_ ( .D(n8012), .CK(ACLK), .RN(ARESETB), .Q(n7473), .QN(
        n8995) );
  DFFRX1 rs_state_reg_2_ ( .D(n8010), .CK(ACLK), .RN(ARESETB), .Q(rs_state_2_), 
        .QN(n8982) );
  DFFRX1 tcl_reg_2_ ( .D(n8025), .CK(PCLK), .RN(PRESETB), .Q(tcl_2_), .QN(
        n9114) );
  DFFRX1 rs_state_reg_1_ ( .D(n8011), .CK(ACLK), .RN(ARESETB), .Q(rs_state_1_), 
        .QN(n8974) );
  DFFRX1 rw_bstop1_reg ( .D(n8090), .CK(ACLK), .RN(ARESETB), .Q(rw_bstop1), 
        .QN(n9012) );
  DFFRX1 rw_bstop0_reg ( .D(n8089), .CK(ACLK), .RN(ARESETB), .Q(rw_bstop0), 
        .QN(n9039) );
  DFFSX1 cmd_full_d_reg ( .D(BA_STS[3]), .CK(ACLK), .SN(ARESETB), .Q(
        cmd_full_d) );
  DFFSX1 stable_cnt_reg_1_ ( .D(n7999), .CK(ACLK), .SN(ARESETB), .Q(
        stable_cnt[1]), .QN(n9000) );
  DFFSX1 selfref_cnt_reg_4_ ( .D(n8005), .CK(ACLK), .SN(ARESETB), .Q(n8293), 
        .QN(n9042) );
  DFFRX1 SDREn_reg ( .D(n8037), .CK(PCLK), .RN(PRESETB), .Q(SDREn), .QN(n9037)
         );
  DFFSX1 stable_cnt_reg_2_ ( .D(n7998), .CK(ACLK), .SN(ARESETB), .Q(
        stable_cnt[2]), .QN(n9008) );
  DFFSX1 refresh_cnt_reg_11_ ( .D(n8075), .CK(ACLK), .SN(ARESETB), .Q(
        refresh_cnt_11_), .QN(n9031) );
  DFFRX1 refresh_cnt_reg_1_ ( .D(n8085), .CK(ACLK), .RN(ARESETB), .Q(
        refresh_cnt_1_), .QN(n9002) );
  DFFSX1 refresh_cnt_reg_5_ ( .D(n8081), .CK(ACLK), .SN(ARESETB), .Q(
        refresh_cnt_5_), .QN(n9035) );
  DFFSX1 PwDnCnt_reg_0_ ( .D(n7997), .CK(ACLK), .SN(PORESETB), .Q(PwDnCnt[0]), 
        .QN(n9009) );
  DFFSX1 PwDnCnt_reg_2_ ( .D(n7995), .CK(ACLK), .SN(PORESETB), .Q(PwDnCnt[2]), 
        .QN(n8979) );
  DFFSX1 PwDnCnt_reg_1_ ( .D(n7996), .CK(ACLK), .SN(PORESETB), .Q(PwDnCnt[1]), 
        .QN(n9010) );
  DFFRX1 refresh_cnt_reg_14_ ( .D(n8072), .CK(ACLK), .RN(ARESETB), .Q(
        refresh_cnt_14_), .QN(n8976) );
  DFFRX1 refresh_cnt_reg_13_ ( .D(n8073), .CK(ACLK), .RN(ARESETB), .Q(
        refresh_cnt_13_), .QN(n9007) );
  DFFRX1 refresh_cnt_reg_12_ ( .D(n8074), .CK(ACLK), .RN(ARESETB), .Q(
        refresh_cnt_12_), .QN(n8989) );
  DFFRX1 refresh_cnt_reg_10_ ( .D(n8076), .CK(ACLK), .RN(ARESETB), .Q(
        refresh_cnt_10_), .QN(n9005) );
  DFFRX1 refresh_cnt_reg_2_ ( .D(n8084), .CK(ACLK), .RN(ARESETB), .Q(n8302), 
        .QN(n8984) );
  DFFRX1 SelfRefEn_reg ( .D(n8038), .CK(PCLK), .RN(PRESETB), .Q(SelfRefEn), 
        .QN(n9095) );
  DFFSX1 stable_cnt_reg_0_ ( .D(n8000), .CK(ACLK), .SN(ARESETB), .Q(
        stable_cnt[0]), .QN(n9036) );
  DFFRX1 refresh_cnt_reg_9_ ( .D(n8077), .CK(ACLK), .RN(ARESETB), .Q(
        refresh_cnt_9_), .QN(n8975) );
  DFFRX1 refresh_cnt_reg_8_ ( .D(n8078), .CK(ACLK), .RN(ARESETB), .Q(
        refresh_cnt_8_), .QN(n8988) );
  DFFRX1 refresh_cnt_reg_7_ ( .D(n8079), .CK(ACLK), .RN(ARESETB), .Q(
        refresh_cnt_7_), .QN(n9032) );
  DFFRX1 refresh_cnt_reg_6_ ( .D(n8080), .CK(ACLK), .RN(ARESETB), .Q(
        refresh_cnt_6_), .QN(n9006) );
  DFFRX1 refresh_cnt_reg_4_ ( .D(n8082), .CK(ACLK), .RN(ARESETB), .Q(
        refresh_cnt_4_), .QN(n9004) );
  DFFRX1 refresh_cnt_reg_3_ ( .D(n8083), .CK(ACLK), .RN(ARESETB), .Q(
        refresh_cnt_3_), .QN(n8987) );
  DFFRX1 refresh_cnt_reg_15_ ( .D(n8071), .CK(ACLK), .RN(ARESETB), .Q(
        refresh_cnt_15_), .QN(n9034) );
  DFFRX1 trc_cnt_reg_2_ ( .D(n8066), .CK(ACLK), .RN(ARESETB), .Q(trc_cnt[2]), 
        .QN(n9033) );
  DFFRX1 ar_cnt_reg_0_ ( .D(n8004), .CK(ACLK), .RN(ARESETB), .Q(ar_cnt[0]), 
        .QN(n9003) );
  DFFRX1 trc_cnt_reg_0_ ( .D(n8068), .CK(ACLK), .RN(ARESETB), .Q(trc_cnt[0]), 
        .QN(n8986) );
  DFFRX1 ar_cnt_reg_1_ ( .D(n8003), .CK(ACLK), .RN(ARESETB), .Q(ar_cnt[1]), 
        .QN(n8985) );
  DFFRX1 ar_cnt_reg_2_ ( .D(n8002), .CK(ACLK), .RN(ARESETB), .Q(ar_cnt[2]), 
        .QN(n9028) );
  DFFRX1 read_bstop_reg ( .D(n8088), .CK(ACLK), .RN(ARESETB), .QN(n9029) );
  DFFRX1 AddrSwapEn_reg ( .D(n8036), .CK(PCLK), .RN(PRESETB), .Q(AddrSwapEn), 
        .QN(n8997) );
  DFFRX1 ar_cnt_reg_3_ ( .D(n8001), .CK(ACLK), .RN(ARESETB), .Q(ar_cnt[3]) );
  DFFSX1 trc_cnt_reg_3_ ( .D(n8065), .CK(ACLK), .SN(ARESETB), .Q(trc_cnt[3])
         );
  DFFSX1 PwDnCnt_reg_7_ ( .D(n7990), .CK(ACLK), .SN(PORESETB), .Q(PwDnCnt[7]), 
        .QN(n9038) );
  DFFSX1 PwDnCnt_reg_9_ ( .D(n7988), .CK(ACLK), .SN(PORESETB), .Q(PwDnCnt[9]), 
        .QN(n8994) );
  DFFSX1 trc_cnt_reg_1_ ( .D(n8067), .CK(ACLK), .SN(ARESETB), .Q(trc_cnt[1]), 
        .QN(n9043) );
  DFFSX1 PwDnCnt_reg_14_ ( .D(n7983), .CK(ACLK), .SN(PORESETB), .Q(PwDnCnt[14]), .QN(n8993) );
  DFFSX1 PwDnCnt_reg_13_ ( .D(n7984), .CK(ACLK), .SN(PORESETB), .Q(PwDnCnt[13]), .QN(n8980) );
  DFFSX1 PwDnCnt_reg_12_ ( .D(n7985), .CK(ACLK), .SN(PORESETB), .Q(PwDnCnt[12]), .QN(n8971) );
  DFFSX1 PwDnCnt_reg_11_ ( .D(n7986), .CK(ACLK), .SN(PORESETB), .Q(PwDnCnt[11]), .QN(n8978) );
  DFFSX1 PwDnCnt_reg_10_ ( .D(n7987), .CK(ACLK), .SN(PORESETB), .Q(PwDnCnt[10]), .QN(n8992) );
  DFFSX1 PwDnCnt_reg_8_ ( .D(n7989), .CK(ACLK), .SN(PORESETB), .Q(PwDnCnt[8]), 
        .QN(n8977) );
  DFFSX1 PwDnCnt_reg_6_ ( .D(n7991), .CK(ACLK), .SN(PORESETB), .Q(PwDnCnt[6]), 
        .QN(n8990) );
  DFFSX1 PwDnCnt_reg_5_ ( .D(n7992), .CK(ACLK), .SN(PORESETB), .Q(PwDnCnt[5]), 
        .QN(n9011) );
  DFFSX1 PwDnCnt_reg_4_ ( .D(n7993), .CK(ACLK), .SN(PORESETB), .Q(PwDnCnt[4]), 
        .QN(n8972) );
  DFFSX1 PwDnCnt_reg_3_ ( .D(n7994), .CK(ACLK), .SN(PORESETB), .Q(PwDnCnt[3]), 
        .QN(n8991) );
  DFFSX1 PwDnCnt_reg_15_ ( .D(n7982), .CK(ACLK), .SN(PORESETB), .Q(PwDnCnt[15]), .QN(n8973) );
  DFFRX1 last_ba_reg_1_ ( .D(n8013), .CK(ACLK), .RN(ARESETB), .Q(last_ba[1]), 
        .QN(n9067) );
  DFFSX1 tmrs_cnt_reg_0_ ( .D(n8070), .CK(ACLK), .SN(ARESETB), .Q(tmrs_cnt[0])
         );
  DFFSX1 trp_cnt_reg_1_ ( .D(n8063), .CK(ACLK), .SN(ARESETB), .Q(trp_cnt[1])
         );
  DFFRX1 trp_cnt_reg_0_ ( .D(n8064), .CK(ACLK), .RN(ARESETB), .Q(trp_cnt[0]), 
        .QN(n9049) );
  DFFRX1 tmrs_cnt_reg_1_ ( .D(n8069), .CK(ACLK), .RN(ARESETB), .Q(tmrs_cnt[1]), 
        .QN(n9115) );
  DFFRX1 last_ba_reg_0_ ( .D(n8014), .CK(ACLK), .RN(ARESETB), .Q(last_ba[0])
         );
  DFFSX1 trp_reg_1_ ( .D(n8021), .CK(PCLK), .SN(PRESETB), .Q(trp[1]), .QN(
        n9041) );
  DFFRX1 trp_reg_0_ ( .D(n8022), .CK(PCLK), .RN(PRESETB), .Q(trp[0]), .QN(
        n9040) );
  DFFSX1 trefresh_reg_11_ ( .D(n8044), .CK(PCLK), .SN(PRESETB), .Q(
        trefresh[11]), .QN(n9054) );
  DFFSX1 trc_reg_3_ ( .D(n8032), .CK(PCLK), .SN(PRESETB), .Q(trc[3]), .QN(
        n9061) );
  DFFRX1 refreshno_reg_0_ ( .D(n7981), .CK(PCLK), .RN(PRESETB), .Q(
        refreshno[0]), .QN(n9047) );
  DFFRX1 trefresh_reg_15_ ( .D(n8040), .CK(PCLK), .RN(PRESETB), .Q(
        trefresh[15]), .QN(n9021) );
  DFFRX1 trefresh_reg_9_ ( .D(n8046), .CK(PCLK), .RN(PRESETB), .Q(trefresh[9]), 
        .QN(n9060) );
  DFFRX1 trefresh_reg_8_ ( .D(n8047), .CK(PCLK), .RN(PRESETB), .Q(trefresh[8]), 
        .QN(n9059) );
  DFFRX1 trefresh_reg_6_ ( .D(n8049), .CK(PCLK), .RN(PRESETB), .Q(trefresh[6]), 
        .QN(n9058) );
  DFFRX1 trefresh_reg_4_ ( .D(n8051), .CK(PCLK), .RN(PRESETB), .Q(trefresh[4]), 
        .QN(n9057) );
  DFFRX1 trefresh_reg_3_ ( .D(n8052), .CK(PCLK), .RN(PRESETB), .Q(trefresh[3]), 
        .QN(n9056) );
  DFFRX1 trefresh_reg_2_ ( .D(n8053), .CK(PCLK), .RN(PRESETB), .Q(trefresh[2]), 
        .QN(n9055) );
  DFFRX1 trefresh_reg_14_ ( .D(n8041), .CK(PCLK), .RN(PRESETB), .Q(
        trefresh[14]), .QN(n9052) );
  DFFRX1 trefresh_reg_13_ ( .D(n8042), .CK(PCLK), .RN(PRESETB), .Q(
        trefresh[13]), .QN(n9051) );
  DFFRX1 trefresh_reg_12_ ( .D(n8043), .CK(PCLK), .RN(PRESETB), .Q(
        trefresh[12]), .QN(n9050) );
  DFFRX1 trefresh_reg_10_ ( .D(n8045), .CK(PCLK), .RN(PRESETB), .Q(
        trefresh[10]), .QN(n9022) );
  DFFSX1 PwDnRef_reg_0_ ( .D(n7977), .CK(PCLK), .SN(PRESETB), .Q(PwDnRef[0]), 
        .QN(n9048) );
  DFFSX1 trc_reg_1_ ( .D(n8034), .CK(PCLK), .SN(PRESETB), .Q(trc[1]), .QN(
        n9014) );
  DFFRX1 refreshno_reg_1_ ( .D(n7980), .CK(PCLK), .RN(PRESETB), .Q(
        refreshno[1]), .QN(n9046) );
  DFFRX1 trefresh_reg_0_ ( .D(n8055), .CK(PCLK), .RN(PRESETB), .Q(trefresh[0]), 
        .QN(n9045) );
  DFFRX1 trc_reg_2_ ( .D(n8033), .CK(PCLK), .RN(PRESETB), .Q(trc[2]), .QN(
        n9015) );
  DFFRX1 trc_reg_0_ ( .D(n8035), .CK(PCLK), .RN(PRESETB), .Q(trc[0]), .QN(
        n9016) );
  DFFRX1 PwDnEn_reg ( .D(n8039), .CK(PCLK), .RN(PRESETB), .Q(PwDnEn) );
  DFFSX1 cmd_mask_reg ( .D(n8056), .CK(ACLK), .SN(ARESETB), .Q(cmd_mask), .QN(
        n9109) );
  DFFRX1 trefresh_reg_1_ ( .D(n8054), .CK(PCLK), .RN(PRESETB), .Q(trefresh[1])
         );
  DFFRX1 refreshno_reg_3_ ( .D(n7978), .CK(PCLK), .RN(PRESETB), .Q(
        refreshno[3]) );
  DFFRX1 refreshno_reg_2_ ( .D(n7979), .CK(PCLK), .RN(PRESETB), .Q(
        refreshno[2]) );
  DFFSX1 trcd_reg_1_ ( .D(n8023), .CK(PCLK), .SN(PRESETB), .Q(trcd[1]), .QN(
        n9019) );
  DFFSX1 trasmin_reg_0_ ( .D(n8031), .CK(PCLK), .SN(PRESETB), .Q(trasmin[0]), 
        .QN(n9020) );
  DFFSX1 trasmin_reg_2_ ( .D(n8029), .CK(PCLK), .SN(PRESETB), .Q(trasmin[2]), 
        .QN(n9053) );
  DFFSX1 trasmin_reg_1_ ( .D(n8030), .CK(PCLK), .SN(PRESETB), .Q(trasmin[1]), 
        .QN(n9023) );
  DFFRX1 trcd_reg_0_ ( .D(n8024), .CK(PCLK), .RN(PRESETB), .Q(trcd[0]), .QN(
        n9017) );
  DFFRX1 trasmin_reg_3_ ( .D(n8028), .CK(PCLK), .RN(PRESETB), .Q(trasmin[3]), 
        .QN(n9018) );
  DFFSX1 trefresh_reg_5_ ( .D(n8050), .CK(PCLK), .SN(PRESETB), .Q(trefresh[5]), 
        .QN(n9062) );
  DFFRX1 iSD_BADDR_reg_1_ ( .D(n8019), .CK(ACLK), .RN(ARESETB), .Q(
        iSD_BADDR[1]) );
  DFFRX1 iSD_ADDR_reg_10_ ( .D(n8093), .CK(ACLK), .RN(ARESETB), .Q(
        iSD_ADDR[10]) );
  DFFRX1 cas_pm_0_reg ( .D(n8091), .CK(ACLK), .RN(ARESETB), .Q(cas_pm_0) );
  DFFRX1 iSD_ADDR_reg_11_ ( .D(n8092), .CK(ACLK), .RN(ARESETB), .Q(
        iSD_ADDR[11]), .QN(net1585) );
  DFFRX1 iSD_ADDR_reg_9_ ( .D(n8094), .CK(ACLK), .RN(ARESETB), .Q(iSD_ADDR[9]), 
        .QN(net1587) );
  DFFRX1 iSD_ADDR_reg_8_ ( .D(n8095), .CK(ACLK), .RN(ARESETB), .Q(iSD_ADDR[8]), 
        .QN(net1588) );
  DFFRX1 iSD_BADDR_reg_0_ ( .D(n8020), .CK(ACLK), .RN(ARESETB), .Q(
        iSD_BADDR[0]), .QN(net1598) );
  DFFRX1 trefresh_reg_7_ ( .D(n8048), .CK(PCLK), .RN(PRESETB), .Q(trefresh[7])
         );
  DFFRX1 SDREnStatus_reg ( .D(n8087), .CK(ACLK), .RN(ARESETB), .Q(SDREnStatus)
         );
  DFFSX1 PwDnRef_reg_15_ ( .D(n7962), .CK(PCLK), .SN(PRESETB), .Q(PwDnRef[15])
         );
  DFFSX1 PwDnRef_reg_14_ ( .D(n7963), .CK(PCLK), .SN(PRESETB), .Q(PwDnRef[14])
         );
  DFFSX1 PwDnRef_reg_13_ ( .D(n7964), .CK(PCLK), .SN(PRESETB), .Q(PwDnRef[13])
         );
  DFFSX1 PwDnRef_reg_12_ ( .D(n7965), .CK(PCLK), .SN(PRESETB), .Q(PwDnRef[12])
         );
  DFFSX1 PwDnRef_reg_11_ ( .D(n7966), .CK(PCLK), .SN(PRESETB), .Q(PwDnRef[11])
         );
  DFFSX1 PwDnRef_reg_10_ ( .D(n7967), .CK(PCLK), .SN(PRESETB), .Q(PwDnRef[10])
         );
  DFFSX1 PwDnRef_reg_9_ ( .D(n7968), .CK(PCLK), .SN(PRESETB), .Q(PwDnRef[9])
         );
  DFFSX1 PwDnRef_reg_8_ ( .D(n7969), .CK(PCLK), .SN(PRESETB), .Q(PwDnRef[8])
         );
  DFFSX1 PwDnRef_reg_7_ ( .D(n7970), .CK(PCLK), .SN(PRESETB), .Q(PwDnRef[7])
         );
  DFFSX1 PwDnRef_reg_6_ ( .D(n7971), .CK(PCLK), .SN(PRESETB), .Q(PwDnRef[6])
         );
  DFFSX1 PwDnRef_reg_5_ ( .D(n7972), .CK(PCLK), .SN(PRESETB), .Q(PwDnRef[5])
         );
  DFFSX1 PwDnRef_reg_4_ ( .D(n7973), .CK(PCLK), .SN(PRESETB), .Q(PwDnRef[4])
         );
  DFFSX1 PwDnRef_reg_3_ ( .D(n7974), .CK(PCLK), .SN(PRESETB), .Q(PwDnRef[3])
         );
  DFFSX1 PwDnRef_reg_2_ ( .D(n7975), .CK(PCLK), .SN(PRESETB), .Q(PwDnRef[2])
         );
  DFFSX1 PwDnRef_reg_1_ ( .D(n7976), .CK(PCLK), .SN(PRESETB), .Q(PwDnRef[1])
         );
  DFFRX1 do_id_0_reg_3_ ( .D(n8015), .CK(ACLK), .RN(ARESETB), .Q(do_id_0[3])
         );
  DFFRX1 do_id_0_reg_2_ ( .D(n8016), .CK(ACLK), .RN(ARESETB), .Q(do_id_0[2])
         );
  DFFRX1 do_id_0_reg_1_ ( .D(n8017), .CK(ACLK), .RN(ARESETB), .Q(do_id_0[1])
         );
  DFFRX1 do_id_0_reg_0_ ( .D(n8018), .CK(ACLK), .RN(ARESETB), .Q(do_id_0[0])
         );
  DFFRX1 bf_last_2_reg ( .D(bf_last_1), .CK(ACLK), .RN(ARESETB), .Q(bf_last_2)
         );
  DFFRX1 do_valid_2_reg ( .D(do_valid_1), .CK(ACLK), .RN(ARESETB), .Q(
        do_valid_2) );
  DFFRX1 do_id_2_reg_0_ ( .D(do_id_1[0]), .CK(ACLK), .RN(ARESETB), .Q(
        do_id_2[0]) );
  DFFRX1 do_id_2_reg_1_ ( .D(do_id_1[1]), .CK(ACLK), .RN(ARESETB), .Q(
        do_id_2[1]) );
  DFFRX1 do_id_2_reg_2_ ( .D(do_id_1[2]), .CK(ACLK), .RN(ARESETB), .Q(
        do_id_2[2]) );
  DFFRX1 do_id_2_reg_3_ ( .D(do_id_1[3]), .CK(ACLK), .RN(ARESETB), .Q(
        do_id_2[3]) );
  DFFRX1 iSD_ADDR_reg_7_ ( .D(n8096), .CK(ACLK), .RN(ARESETB), .Q(iSD_ADDR[7])
         );
  DFFRX1 iSD_ADDR_reg_3_ ( .D(n8100), .CK(ACLK), .RN(ARESETB), .Q(iSD_ADDR[3])
         );
  DFFRX1 iSD_ADDR_reg_6_ ( .D(n8097), .CK(ACLK), .RN(ARESETB), .Q(iSD_ADDR[6])
         );
  DFFRX1 iSD_ADDR_reg_5_ ( .D(n8098), .CK(ACLK), .RN(ARESETB), .Q(iSD_ADDR[5])
         );
  DFFRX1 iSD_ADDR_reg_4_ ( .D(n8099), .CK(ACLK), .RN(ARESETB), .Q(iSD_ADDR[4])
         );
  DFFRX1 iSD_ADDR_reg_2_ ( .D(n8101), .CK(ACLK), .RN(ARESETB), .Q(iSD_ADDR[2])
         );
  DFFRX1 iSD_ADDR_reg_1_ ( .D(n8102), .CK(ACLK), .RN(ARESETB), .Q(iSD_ADDR[1])
         );
  DFFRX1 iSD_ADDR_reg_0_ ( .D(n8103), .CK(ACLK), .RN(ARESETB), .Q(iSD_ADDR[0])
         );
  DFFRX1 bf_last_3_reg ( .D(bf_last_2), .CK(ACLK), .RN(ARESETB), .Q(bf_last_3)
         );
  DFFRX1 do_valid_3_reg ( .D(do_valid_2), .CK(ACLK), .RN(ARESETB), .Q(
        do_valid_3) );
  DFFRX1 do_id_3_reg_0_ ( .D(do_id_2[0]), .CK(ACLK), .RN(ARESETB), .Q(
        do_id_3[0]) );
  DFFRX1 do_id_3_reg_1_ ( .D(do_id_2[1]), .CK(ACLK), .RN(ARESETB), .Q(
        do_id_3[1]) );
  DFFRX1 do_id_3_reg_2_ ( .D(do_id_2[2]), .CK(ACLK), .RN(ARESETB), .Q(
        do_id_3[2]) );
  DFFRX1 do_id_3_reg_3_ ( .D(do_id_2[3]), .CK(ACLK), .RN(ARESETB), .Q(
        do_id_3[3]) );
  DFFRX1 bf_last_0_reg ( .D(bf_last_05017), .CK(ACLK), .RN(ARESETB), .QN(n9116) );
  NOR2X1 U5239 ( .A(refresh_cnt_14_), .B(n9091), .Y(n6) );
  XNOR2X1 U5240 ( .A(n9091), .B(refresh_cnt_14_), .Y(refresh_cnt2536_14_) );
  XNOR2X1 U5241 ( .A(n9092), .B(refresh_cnt_13_), .Y(refresh_cnt2536_13_) );
  XNOR2X1 U5242 ( .A(n9093), .B(refresh_cnt_12_), .Y(refresh_cnt2536_12_) );
  XNOR2X1 U5243 ( .A(n9094), .B(refresh_cnt_11_), .Y(refresh_cnt2536_11_) );
  XNOR2X1 U5244 ( .A(carry_10_), .B(refresh_cnt_10_), .Y(refresh_cnt2536_10_)
         );
  XOR2X1 U5245 ( .A(n9067), .B(ras_0_ba[1]), .Y(n8705) );
endmodule


module SDRBsm_3 ( ARESETB, ACLK, TRP, TRRD, TRCD, TRASMIN, BA_BA, BA_RA, BA_TT, 
        BA_REQ, CAS_0_BA, CAS_0_RA, CAS_0_TT, CAS_0_FINAL, CAS_0_NEWROW, 
        CAS_EMPTY, LAST_RA, RAS_0_BA, RAS_0_RA, RAS_0_TT, RAS_EMPTY, BF_NO, 
        BF_CASBUSY, BF_TCASBUSY, BF_RASBUSY, BF_TRASBUSY, BF_READY, BF_TREADY, 
        BF_IDLE, BF_LAST, BF_REQCMD, BF_CMD, ERCMD, ECMD );
  input [1:0] TRP;
  input [1:0] TRRD;
  input [1:0] TRCD;
  input [3:0] TRASMIN;
  input [1:0] BA_BA;
  input [11:0] BA_RA;
  input [3:0] BA_TT;
  input [1:0] CAS_0_BA;
  input [11:0] CAS_0_RA;
  input [3:0] CAS_0_TT;
  input [12:0] LAST_RA;
  input [1:0] RAS_0_BA;
  input [11:0] RAS_0_RA;
  input [3:0] RAS_0_TT;
  input [1:0] BF_NO;
  output [5:0] BF_REQCMD;
  input [5:0] BF_CMD;
  input [5:0] ERCMD;
  input [6:0] ECMD;
  input ARESETB, ACLK, BA_REQ, CAS_0_FINAL, CAS_0_NEWROW, CAS_EMPTY, RAS_EMPTY,
         BF_TCASBUSY, BF_TRASBUSY, BF_TREADY;
  output BF_CASBUSY, BF_RASBUSY, BF_READY, BF_IDLE, BF_LAST;
  wire   cbs_pcing, cbs_rowopen, cbs_rasing, cbs_casing, cas_0_final_l,
         cas_0_newrow_l, trrd_cnt_1_, trrd_cnt_0_, newrowexist, n2516, n2517,
         n2518, n2519, n2520, n2521, n2522, n2523, n2524, n2525, n2526, n2527,
         n2528, n2529, n2530, n2531, n2532, n2533, n2534, n2535, n2536, n2537,
         n2538, n2539, n2540, n2541, n2542, n2543, n2544, n2545, n2572, n2575,
         n2582, n2586, n2593, n2602, n2604, n2608, n2609, n2610, n2611, n2612,
         n2613, n2615, n2617, n2623, n2625, n2626, n2628, n2629, n2630, n2631,
         n2633, n2634, n2635, n2637, n2638, n2639, n2640, n2642, n2643, n2644,
         n2645, n2647, n2648, n2649, n2650, n2651, n2652, n2653, n2654, n2655,
         n2656, n2657, n2658, n2659, n2660, n2661, n2662, n2663, n2664, n2665,
         n2666, n2667, n2668, n2672, n2673, n2674, n2675, n2678, n2679, n2680,
         n2681, n2683, n2684, n2685, n2686, n2687, n2688, n2690, n2691, n2692,
         n2693, n2694, n2695, n2696, n2698, n2699, n2700, n2703, n2704, n2705,
         n2706, n2707, n2708, n2709, n2721, n2722, n2723, n2724, n2725, n2727,
         n2728, n2729, n2730, n2732, n2733, n2734, n2735, n2737, n2738, n2740,
         n2741, n2742, n2743, n2744, n2745, n2746, n2748, n2749, n2750, n2751,
         n2752, n2753, n2754, n2755, n2756, n2757, n2758, n2813, n2814, n2815,
         n2816, n2817, n2819, n2820, n2821, n2822, n2823, n2824, n2825, n2826,
         n2827, n2828, n2829, n2830, n2831, n2832, n2833, n2834, n2835, n2836,
         n2837, n2838, n2839, n2840, n2841, n2842, n2843, n2844, n2845, n2846,
         n2847, n2848, n2849, n2850, n2851, n2852, n2853, n2854, n2855, n2856,
         n2857, n2858, n2859, n2860, n2861, n2862, n2863, n2864, n2865, n2866,
         n2867, n2868, n2869, n2870, n2871, n2872, n2873, n2874, n2875, n2876,
         n2877, n2878, n2879, n2880, n2881, n2882, n2883, n2884, n2885, n2886,
         n2887, n2888, n2889, n2890, n2891, n2892, n2893, n2894, n2895, n2896,
         n2897, n2898, n2899, n2900, n2901, n2902, n2903, n2904, n2905, n2906,
         n2907, n2908, n2909, n2910, n2911, n2912, n2913, n2914, n2915, n2916,
         n2917, n2918, n2919, n2920, n2921, n2922, n2923, n2924, n2925, n2926,
         n2927, n2928, n2929, n2930, n2931, n2932, n2933, n2934, n2935, n2936,
         n2937, n2938, n2939, n2940, n2941, n2942, n2943, n2944, n2945, n2946,
         n2947, n2948, n2949, n2950, n2951, n2952, n2953, n2954, n2955, n2956,
         n2957, n2958, net1943, net1919, net1918;
  wire   [3:0] length;
  wire   [11:0] openedrow;
  wire   [3:0] trasmin_cnt;
  wire   [4:0] nextstate;
  wire   [1:0] trcd_cnt;
  wire   [1:0] trp_cnt;

  NOR3X1 U1321 ( .A(BF_TRASBUSY), .B(trp_cnt[1]), .C(trp_cnt[0]), .Y(n2930) );
  AND2X2 U1322 ( .A(n2955), .B(n2956), .Y(BF_LAST) );
  OR2X1 U1323 ( .A(trasmin_cnt[0]), .B(trasmin_cnt[1]), .Y(n2730) );
  NOR2X1 U1324 ( .A(n2914), .B(n2915), .Y(BF_REQCMD[4]) );
  INVX1 U1325 ( .A(n2894), .Y(BF_REQCMD[3]) );
  AND2X2 U1326 ( .A(n2895), .B(n2615), .Y(n2840) );
  NAND2BX1 U1327 ( .AN(n2876), .B(n2919), .Y(n2887) );
  NOR2BX1 U1328 ( .AN(n2873), .B(n2872), .Y(n2870) );
  OR3X1 U1329 ( .A(ECMD[4]), .B(ECMD[6]), .C(ERCMD[1]), .Y(n2753) );
  INVX1 U1330 ( .A(BF_CMD[3]), .Y(n2724) );
  INVX1 U1331 ( .A(n2634), .Y(n2649) );
  INVX1 U1332 ( .A(BF_CMD[2]), .Y(n2723) );
  INVX1 U1333 ( .A(BF_CMD[0]), .Y(n2741) );
  INVX1 U1334 ( .A(BF_CMD[4]), .Y(n2615) );
  NAND3BX1 U1335 ( .AN(n2721), .B(n2623), .C(n2722), .Y(n2634) );
  XOR2X1 U1336 ( .A(BF_CMD[4]), .B(BF_CMD[0]), .Y(n2722) );
  NAND3BX1 U1337 ( .AN(BF_CMD[5]), .B(n2723), .C(n2724), .Y(n2721) );
  NAND3BX1 U1338 ( .AN(n2750), .B(n2741), .C(n2751), .Y(n2650) );
  XOR2X1 U1339 ( .A(BF_CMD[5]), .B(BF_CMD[2]), .Y(n2751) );
  NAND3BX1 U1340 ( .AN(BF_CMD[4]), .B(n2724), .C(n2623), .Y(n2750) );
  NAND3X1 U1341 ( .A(BF_REQCMD[3]), .B(BF_CMD[3]), .C(n2840), .Y(n2613) );
  INVX1 U1342 ( .A(n2958), .Y(n2709) );
  DFFSX1 currstate_reg_0_ ( .D(nextstate[0]), .CK(ACLK), .SN(ARESETB), .Q(
        BF_IDLE), .QN(n2815) );
  NAND3X1 U1343 ( .A(n2637), .B(n2604), .C(n2877), .Y(n2914) );
  INVX1 U1344 ( .A(n2926), .Y(n2604) );
  INVX1 U1345 ( .A(n2896), .Y(BF_REQCMD[2]) );
  INVX1 U1346 ( .A(BF_TCASBUSY), .Y(n2877) );
  INVX1 U1347 ( .A(n2915), .Y(n2853) );
  INVX1 U1348 ( .A(n2617), .Y(BF_REQCMD[5]) );
  INVX1 U1349 ( .A(BA_RA[7]), .Y(n2668) );
  INVX1 U1350 ( .A(BA_RA[8]), .Y(n2667) );
  INVX1 U1351 ( .A(BA_RA[10]), .Y(n2690) );
  XOR2X1 U1352 ( .A(n2617), .B(BF_CMD[5]), .Y(n2895) );
  INVX1 U1353 ( .A(n2609), .Y(n2572) );
  OAI33X1 U1354 ( .A0(n2610), .A1(n2611), .A2(n2612), .B0(n2610), .B1(n2613), 
        .B2(n2611), .Y(n2609) );
  XOR2X1 U1355 ( .A(n2896), .B(n2723), .Y(n2611) );
  NAND2BX1 U1356 ( .AN(n2897), .B(n2898), .Y(n2610) );
  INVX1 U1357 ( .A(BF_CMD[1]), .Y(n2623) );
  XNOR2X1 U1358 ( .A(BF_REQCMD[0]), .B(BF_CMD[0]), .Y(n2898) );
  INVX1 U1359 ( .A(BA_RA[2]), .Y(n2694) );
  INVX1 U1360 ( .A(BA_RA[4]), .Y(n2703) );
  AOI2BB1X1 U1361 ( .A0N(n2912), .A1N(length[0]), .B0(n2649), .Y(n2841) );
  BUFX2 U1362 ( .A(n2708), .Y(n2958) );
  NAND3BX1 U1363 ( .AN(n2740), .B(n2741), .C(n2742), .Y(n2708) );
  XOR2X1 U1364 ( .A(BF_CMD[3]), .B(BF_CMD[1]), .Y(n2742) );
  NAND3BX1 U1365 ( .AN(BF_CMD[5]), .B(n2723), .C(n2615), .Y(n2740) );
  NAND3X1 U1366 ( .A(n2724), .B(n2894), .C(n2840), .Y(n2612) );
  INVX1 U1367 ( .A(n2893), .Y(n2628) );
  INVX1 U1368 ( .A(n2625), .Y(n2626) );
  INVX1 U1369 ( .A(n2908), .Y(n2913) );
  INVX1 U1370 ( .A(n2855), .Y(n2854) );
  INVX1 U1371 ( .A(n2902), .Y(n2907) );
  XOR2X1 U1372 ( .A(n2686), .B(BA_BA[1]), .Y(n2685) );
  MXI2X1 U1373 ( .S0(n2935), .B(n2922), .A(n2842), .Y(n2915) );
  NOR3X1 U1374 ( .A(n2921), .B(n2925), .C(CAS_EMPTY), .Y(n2935) );
  NAND4BX1 U1375 ( .AN(n2757), .B(n2602), .C(n2604), .D(n2817), .Y(n2617) );
  NAND4X1 U1376 ( .A(n2937), .B(n2938), .C(n2939), .D(n2940), .Y(n2922) );
  NOR3X1 U1377 ( .A(n2950), .B(n2951), .C(n2952), .Y(n2937) );
  NOR3X1 U1378 ( .A(n2947), .B(n2948), .C(n2949), .Y(n2938) );
  NOR3X1 U1379 ( .A(n2944), .B(n2945), .C(n2946), .Y(n2939) );
  NOR2X1 U1380 ( .A(n2931), .B(n2932), .Y(BF_REQCMD[0]) );
  NAND2X1 U1381 ( .A(n2877), .B(n2878), .Y(n2932) );
  NAND2X1 U1382 ( .A(n2604), .B(n2853), .Y(n2931) );
  INVX1 U1383 ( .A(n2921), .Y(n2871) );
  NAND3X1 U1384 ( .A(n2814), .B(n2825), .C(n2816), .Y(n2912) );
  NOR2BX1 U1385 ( .AN(n2758), .B(n2925), .Y(n2842) );
  NAND2X1 U1386 ( .A(n2924), .B(n2871), .Y(n2873) );
  NOR2X1 U1387 ( .A(n2925), .B(CAS_EMPTY), .Y(n2924) );
  NAND2X1 U1388 ( .A(n2815), .B(cbs_rowopen), .Y(n2926) );
  NAND2X1 U1389 ( .A(n2916), .B(n2860), .Y(n2894) );
  NOR2X1 U1390 ( .A(n2917), .B(n2815), .Y(n2916) );
  INVX1 U1391 ( .A(n2878), .Y(n2637) );
  NAND2X1 U1392 ( .A(n2918), .B(n2887), .Y(n2896) );
  NOR2X1 U1393 ( .A(n2586), .B(n2926), .Y(n2918) );
  NAND2X1 U1394 ( .A(n2920), .B(n2873), .Y(n2919) );
  NOR2X1 U1395 ( .A(n2823), .B(n2921), .Y(n2920) );
  INVX1 U1396 ( .A(n2892), .Y(n2860) );
  INVX1 U1397 ( .A(BF_TREADY), .Y(n2757) );
  NAND2X1 U1398 ( .A(n2813), .B(n2957), .Y(BF_CASBUSY) );
  INVX1 U1399 ( .A(n2912), .Y(n2957) );
  INVX1 U1400 ( .A(n2586), .Y(n2593) );
  OAI32X1 U1401 ( .A0(n2638), .A1(n2639), .A2(n2640), .B0(n2823), .B1(n2642), 
        .Y(n2542) );
  INVX1 U1402 ( .A(n2630), .Y(n2639) );
  INVX1 U1403 ( .A(n2643), .Y(n2640) );
  INVX1 U1404 ( .A(n2642), .Y(n2638) );
  INVX1 U1405 ( .A(n2730), .Y(n2728) );
  INVX1 U1406 ( .A(n2875), .Y(n2602) );
  OAI2BB1X1 U1407 ( .A0N(n2849), .A1N(n2850), .B0(n2851), .Y(nextstate[4]) );
  NOR2X1 U1408 ( .A(BF_LAST), .B(n2837), .Y(n2849) );
  INVX1 U1409 ( .A(n2856), .Y(n2850) );
  NAND4X1 U1410 ( .A(n2852), .B(n2853), .C(n2854), .D(n2609), .Y(n2851) );
  NAND2BX1 U1411 ( .AN(n2821), .B(n2628), .Y(n2625) );
  NAND2BX1 U1412 ( .AN(n2821), .B(n2634), .Y(n2630) );
  XNOR2X1 U1413 ( .A(BF_REQCMD[1]), .B(n2623), .Y(n2897) );
  NAND2X1 U1414 ( .A(n2649), .B(n2878), .Y(n2893) );
  OAI21X1 U1415 ( .A0(n2888), .A1(n2815), .B0(n2889), .Y(nextstate[0]) );
  NOR2X1 U1416 ( .A(n2890), .B(n2891), .Y(n2889) );
  NOR2X1 U1417 ( .A(n2572), .B(n2892), .Y(n2888) );
  NOR2X1 U1418 ( .A(n2827), .B(n2882), .Y(n2890) );
  INVX1 U1419 ( .A(n2733), .Y(n2725) );
  NAND2BX1 U1420 ( .AN(n2709), .B(n2586), .Y(n2733) );
  INVX1 U1421 ( .A(n2743), .Y(n2745) );
  NAND3X1 U1422 ( .A(n2866), .B(n2867), .C(n2868), .Y(n2865) );
  NAND2BX1 U1423 ( .AN(n2593), .B(n2876), .Y(n2867) );
  NAND2X1 U1424 ( .A(n2853), .B(n2855), .Y(n2866) );
  MXI2X1 U1425 ( .S0(n2871), .B(n2870), .A(n2869), .Y(n2868) );
  NAND2X1 U1426 ( .A(n2885), .B(n2886), .Y(n2883) );
  NAND2X1 U1427 ( .A(n2887), .B(n2593), .Y(n2885) );
  NAND3X1 U1428 ( .A(n2602), .B(n2817), .C(BF_TREADY), .Y(n2886) );
  DFFRX1 currstate_reg_3_ ( .D(nextstate[3]), .CK(ACLK), .RN(ARESETB), .Q(
        cbs_rasing), .QN(n2828) );
  NAND2X1 U1429 ( .A(n2827), .B(n2815), .Y(n2575) );
  NOR2X1 U1430 ( .A(n2823), .B(n2586), .Y(n2872) );
  NAND3X1 U1431 ( .A(n2816), .B(n2814), .C(n2813), .Y(n2908) );
  NAND2X1 U1432 ( .A(n2877), .B(n2878), .Y(n2855) );
  NAND2X1 U1433 ( .A(n2813), .B(n2816), .Y(n2902) );
  INVX1 U1434 ( .A(n2862), .Y(n2852) );
  NAND3X1 U1435 ( .A(n2821), .B(n2828), .C(n2608), .Y(n2856) );
  INVX1 U1436 ( .A(n2575), .Y(n2608) );
  OAI22X1 U1437 ( .A0(n2922), .A1(n2873), .B0(n2842), .B1(n2923), .Y(n2876) );
  NAND2X1 U1438 ( .A(n2921), .B(newrowexist), .Y(n2923) );
  NAND2X1 U1439 ( .A(n2953), .B(n2954), .Y(n2925) );
  XOR2X1 U1440 ( .A(n2686), .B(CAS_0_BA[1]), .Y(n2953) );
  XOR2X1 U1441 ( .A(n2936), .B(CAS_0_BA[0]), .Y(n2954) );
  OR3X2 U1442 ( .A(n2843), .B(RAS_EMPTY), .C(n2844), .Y(n2921) );
  XNOR2X1 U1443 ( .A(n2686), .B(RAS_0_BA[1]), .Y(n2843) );
  XNOR2X1 U1444 ( .A(n2936), .B(RAS_0_BA[0]), .Y(n2844) );
  XOR2X1 U1445 ( .A(RAS_0_RA[1]), .B(CAS_0_RA[1]), .Y(n2946) );
  XOR2X1 U1446 ( .A(RAS_0_RA[4]), .B(CAS_0_RA[4]), .Y(n2949) );
  XOR2X1 U1447 ( .A(RAS_0_RA[7]), .B(CAS_0_RA[7]), .Y(n2952) );
  XOR2X1 U1448 ( .A(RAS_0_RA[2]), .B(CAS_0_RA[2]), .Y(n2944) );
  XOR2X1 U1449 ( .A(RAS_0_RA[5]), .B(CAS_0_RA[5]), .Y(n2947) );
  XOR2X1 U1450 ( .A(RAS_0_RA[8]), .B(CAS_0_RA[8]), .Y(n2950) );
  XOR2X1 U1451 ( .A(RAS_0_RA[3]), .B(CAS_0_RA[3]), .Y(n2945) );
  XOR2X1 U1452 ( .A(RAS_0_RA[6]), .B(CAS_0_RA[6]), .Y(n2948) );
  XOR2X1 U1453 ( .A(RAS_0_RA[9]), .B(CAS_0_RA[9]), .Y(n2951) );
  NAND4BX1 U1454 ( .AN(n2656), .B(n2657), .C(n2658), .D(n2659), .Y(n2643) );
  OAI221X1 U1455 ( .A0(BA_RA[4]), .A1(n2832), .B0(LAST_RA[4]), .B1(n2703), 
        .C0(n2704), .Y(n2656) );
  AOI221X1 U1456 ( .A0(BA_RA[6]), .A1(n2698), .B0(openedrow[7]), .B1(n2668), 
        .C0(n2699), .Y(n2657) );
  AND4X1 U1457 ( .A(n2660), .B(n2661), .C(n2662), .D(n2663), .Y(n2659) );
  NOR2X1 U1458 ( .A(n2892), .B(n2927), .Y(BF_REQCMD[1]) );
  NAND2X1 U1459 ( .A(n2917), .B(BF_IDLE), .Y(n2927) );
  NAND2X1 U1460 ( .A(n2933), .B(n2934), .Y(n2878) );
  NOR2X1 U1461 ( .A(CAS_0_TT[1]), .B(CAS_0_TT[0]), .Y(n2933) );
  NOR2X1 U1462 ( .A(CAS_0_TT[3]), .B(CAS_0_TT[2]), .Y(n2934) );
  NAND2X1 U1463 ( .A(n2845), .B(net1918), .Y(n2586) );
  NAND2X1 U1464 ( .A(n2824), .B(net1943), .Y(BF_RASBUSY) );
  NOR3X1 U1465 ( .A(n2941), .B(n2942), .C(n2943), .Y(n2940) );
  XOR2X1 U1466 ( .A(RAS_0_RA[10]), .B(CAS_0_RA[10]), .Y(n2941) );
  XOR2X1 U1467 ( .A(RAS_0_RA[11]), .B(CAS_0_RA[11]), .Y(n2942) );
  XOR2X1 U1468 ( .A(RAS_0_RA[0]), .B(CAS_0_RA[0]), .Y(n2943) );
  OAI32X1 U1469 ( .A0(n2752), .A1(n2753), .A2(n2754), .B0(ERCMD[5]), .B1(n2755), .Y(n2655) );
  INVX1 U1470 ( .A(ERCMD[1]), .Y(n2755) );
  OR2X1 U1471 ( .A(ECMD[3]), .B(ECMD[2]), .Y(n2754) );
  NAND2X1 U1472 ( .A(n2930), .B(n2871), .Y(n2892) );
  OAI211X1 U1473 ( .A0(n2644), .A1(n2634), .B0(n2643), .C0(n2645), .Y(n2642)
         );
  NAND3BX1 U1474 ( .AN(n2707), .B(cbs_rowopen), .C(n2637), .Y(n2644) );
  OA22X1 U1475 ( .A0(n2582), .A1(n2839), .B0(n2635), .B1(n2821), .Y(n2645) );
  INVX1 U1476 ( .A(CAS_0_FINAL), .Y(n2707) );
  INVX1 U1477 ( .A(CAS_EMPTY), .Y(n2758) );
  INVX1 U1478 ( .A(n2647), .Y(n2635) );
  OAI31X1 U1479 ( .A0(n2648), .A1(ERCMD[0]), .A2(n2649), .B0(n2650), .Y(n2647)
         );
  NAND4BX1 U1480 ( .AN(n2651), .B(n2652), .C(n2653), .D(n2654), .Y(n2648) );
  INVX1 U1481 ( .A(n2655), .Y(n2651) );
  NAND2X1 U1482 ( .A(n2928), .B(n2929), .Y(n2917) );
  NOR2X1 U1483 ( .A(RAS_0_TT[1]), .B(RAS_0_TT[0]), .Y(n2928) );
  NOR2X1 U1484 ( .A(RAS_0_TT[3]), .B(RAS_0_TT[2]), .Y(n2929) );
  NAND4BBX1 U1485 ( .AN(ECMD[1]), .BN(ECMD[0]), .C(ERCMD[5]), .D(ECMD[5]), .Y(
        n2752) );
  NOR2BX1 U1486 ( .AN(n2687), .B(n2688), .Y(n2658) );
  OAI221X1 U1487 ( .A0(BA_RA[10]), .A1(n2833), .B0(LAST_RA[10]), .B1(n2690), 
        .C0(n2691), .Y(n2688) );
  AOI221X1 U1488 ( .A0(BA_RA[1]), .A1(n2693), .B0(openedrow[2]), .B1(n2694), 
        .C0(n2695), .Y(n2687) );
  AO21X1 U1489 ( .A0(n2593), .A1(cbs_rowopen), .B0(BF_IDLE), .Y(BF_READY) );
  AND2X2 U1490 ( .A(n2728), .B(net1919), .Y(n2845) );
  AOI221X1 U1491 ( .A0(LAST_RA[8]), .A1(n2819), .B0(LAST_RA[9]), .B1(n2831), 
        .C0(n2683), .Y(n2660) );
  NAND3BX1 U1492 ( .AN(n2684), .B(n2685), .C(BA_REQ), .Y(n2683) );
  XOR2X1 U1493 ( .A(BF_NO[0]), .B(BA_BA[0]), .Y(n2684) );
  OAI222X1 U1494 ( .A0(LAST_RA[11]), .A1(n2696), .B0(BA_RA[11]), .B1(n2826), 
        .C0(BA_RA[1]), .C1(n2820), .Y(n2695) );
  INVX1 U1495 ( .A(BA_RA[11]), .Y(n2696) );
  NAND2X1 U1496 ( .A(RAS_EMPTY), .B(CAS_EMPTY), .Y(n2875) );
  AO22X1 U1497 ( .A0(n2629), .A1(newrowexist), .B0(n2630), .B1(n2631), .Y(
        n2543) );
  INVX1 U1498 ( .A(n2631), .Y(n2629) );
  OAI222X1 U1499 ( .A0(n2582), .A1(n2835), .B0(n2633), .B1(n2634), .C0(n2635), 
        .C1(n2821), .Y(n2631) );
  AOI221X1 U1500 ( .A0(openedrow[9]), .A1(n2664), .B0(BA_RA[9]), .B1(n2665), 
        .C0(n2666), .Y(n2663) );
  INVX1 U1501 ( .A(LAST_RA[9]), .Y(n2665) );
  INVX1 U1502 ( .A(BA_RA[9]), .Y(n2664) );
  OAI222X1 U1503 ( .A0(LAST_RA[8]), .A1(n2667), .B0(LAST_RA[7]), .B1(n2668), 
        .C0(BA_RA[8]), .C1(n2819), .Y(n2666) );
  AO21X1 U1504 ( .A0(n2748), .A1(n2655), .B0(n2749), .Y(n2743) );
  AND4X1 U1505 ( .A(n2756), .B(n2653), .C(n2654), .D(n2652), .Y(n2748) );
  INVX1 U1506 ( .A(n2650), .Y(n2749) );
  INVX1 U1507 ( .A(ERCMD[0]), .Y(n2756) );
  OAI22X1 U1508 ( .A0(n2861), .A1(n2862), .B0(n2575), .B1(n2863), .Y(
        nextstate[2]) );
  MXI2X1 U1509 ( .S0(cbs_rasing), .B(n2847), .A(n2864), .Y(n2863) );
  NOR2X1 U1510 ( .A(n2865), .B(n2572), .Y(n2861) );
  INVX1 U1511 ( .A(n2582), .Y(n2864) );
  OAI21X1 U1512 ( .A0(n2893), .A1(n2909), .B0(n2910), .Y(n2526) );
  INVX1 U1513 ( .A(CAS_0_TT[3]), .Y(n2909) );
  NAND2X1 U1514 ( .A(n2911), .B(n2841), .Y(n2910) );
  NOR2X1 U1515 ( .A(n2913), .B(n2825), .Y(n2911) );
  OAI21X1 U1516 ( .A0(n2893), .A1(n2899), .B0(n2900), .Y(n2528) );
  INVX1 U1517 ( .A(CAS_0_TT[1]), .Y(n2899) );
  NAND2X1 U1518 ( .A(n2841), .B(n2901), .Y(n2900) );
  NAND2X1 U1519 ( .A(n2902), .B(n2903), .Y(n2901) );
  OAI21X1 U1520 ( .A0(n2893), .A1(n2904), .B0(n2905), .Y(n2527) );
  INVX1 U1521 ( .A(CAS_0_TT[2]), .Y(n2904) );
  NAND2X1 U1522 ( .A(n2841), .B(n2906), .Y(n2905) );
  OAI21X1 U1523 ( .A0(n2907), .A1(n2814), .B0(n2908), .Y(n2906) );
  AO22X1 U1524 ( .A0(cas_0_newrow_l), .A1(n2625), .B0(CAS_0_NEWROW), .B1(n2626), .Y(n2545) );
  AO22X1 U1525 ( .A0(cas_0_final_l), .A1(n2625), .B0(CAS_0_FINAL), .B1(n2626), 
        .Y(n2544) );
  AO22X1 U1526 ( .A0(n2841), .A1(n2813), .B0(CAS_0_TT[0]), .B1(n2628), .Y(
        n2529) );
  AO22X1 U1527 ( .A0(openedrow[6]), .A1(n2958), .B0(n2709), .B1(RAS_0_RA[6]), 
        .Y(n2535) );
  AO22X1 U1528 ( .A0(openedrow[5]), .A1(n2958), .B0(n2709), .B1(RAS_0_RA[5]), 
        .Y(n2536) );
  AO22X1 U1529 ( .A0(openedrow[4]), .A1(n2958), .B0(n2709), .B1(RAS_0_RA[4]), 
        .Y(n2537) );
  OAI2BB1X1 U1530 ( .A0N(n2857), .A1N(n2858), .B0(n2859), .Y(nextstate[3]) );
  INVX1 U1531 ( .A(n2847), .Y(n2858) );
  NOR2X1 U1532 ( .A(n2828), .B(n2575), .Y(n2857) );
  NAND3X1 U1533 ( .A(n2860), .B(BF_IDLE), .C(n2609), .Y(n2859) );
  OAI2BB1X1 U1534 ( .A0N(TRASMIN[2]), .A1N(n2709), .B0(n2729), .Y(n2523) );
  AOI32X1 U1535 ( .A0(trasmin_cnt[2]), .A1(n2730), .A2(n2725), .B0(n2725), 
        .B1(n2845), .Y(n2729) );
  OAI2BB1X1 U1536 ( .A0N(TRASMIN[1]), .A1N(n2709), .B0(n2727), .Y(n2524) );
  AOI32X1 U1537 ( .A0(trasmin_cnt[0]), .A1(trasmin_cnt[1]), .A2(n2725), .B0(
        n2725), .B1(n2728), .Y(n2727) );
  AO22X1 U1538 ( .A0(openedrow[7]), .A1(n2958), .B0(n2709), .B1(RAS_0_RA[7]), 
        .Y(n2534) );
  AO22X1 U1539 ( .A0(openedrow[3]), .A1(n2958), .B0(n2709), .B1(RAS_0_RA[3]), 
        .Y(n2538) );
  AO22X1 U1540 ( .A0(TRASMIN[0]), .A1(n2709), .B0(n2725), .B1(n2838), .Y(n2525) );
  AO22X1 U1541 ( .A0(openedrow[11]), .A1(n2958), .B0(n2709), .B1(RAS_0_RA[11]), 
        .Y(n2530) );
  AO22X1 U1542 ( .A0(openedrow[9]), .A1(n2958), .B0(n2709), .B1(RAS_0_RA[9]), 
        .Y(n2532) );
  AO22X1 U1543 ( .A0(TRRD[1]), .A1(n2709), .B0(n2738), .B1(n2958), .Y(n2518)
         );
  NOR2BX1 U1544 ( .AN(trrd_cnt_1_), .B(n2824), .Y(n2738) );
  AO22X1 U1545 ( .A0(TRCD[1]), .A1(n2709), .B0(n2735), .B1(n2958), .Y(n2520)
         );
  NOR2BX1 U1546 ( .AN(trcd_cnt[0]), .B(n2836), .Y(n2735) );
  AO22X1 U1547 ( .A0(TRASMIN[3]), .A1(n2709), .B0(n2732), .B1(n2725), .Y(n2522) );
  NOR2BX1 U1548 ( .AN(trasmin_cnt[3]), .B(n2845), .Y(n2732) );
  AO22X1 U1549 ( .A0(TRCD[0]), .A1(n2709), .B0(n2734), .B1(n2958), .Y(n2521)
         );
  NOR2BX1 U1550 ( .AN(trcd_cnt[1]), .B(trcd_cnt[0]), .Y(n2734) );
  AO22X1 U1551 ( .A0(TRP[1]), .A1(n2743), .B0(n2746), .B1(n2745), .Y(n2516) );
  NOR2BX1 U1552 ( .AN(trp_cnt[1]), .B(n2846), .Y(n2746) );
  AO22X1 U1553 ( .A0(TRP[0]), .A1(n2743), .B0(n2744), .B1(n2745), .Y(n2517) );
  NOR2BX1 U1554 ( .AN(trp_cnt[1]), .B(trp_cnt[0]), .Y(n2744) );
  AO22X1 U1555 ( .A0(TRRD[0]), .A1(n2709), .B0(n2737), .B1(n2958), .Y(n2519)
         );
  NOR2BX1 U1556 ( .AN(trrd_cnt_1_), .B(trrd_cnt_0_), .Y(n2737) );
  OAI222X1 U1557 ( .A0(LAST_RA[5]), .A1(n2700), .B0(BA_RA[5]), .B1(n2834), 
        .C0(BA_RA[6]), .C1(n2822), .Y(n2699) );
  INVX1 U1558 ( .A(BA_RA[5]), .Y(n2700) );
  AOI222X1 U1559 ( .A0(openedrow[3]), .A1(n2705), .B0(BA_RA[2]), .B1(n2706), 
        .C0(BA_RA[3]), .C1(n2680), .Y(n2704) );
  INVX1 U1560 ( .A(LAST_RA[2]), .Y(n2706) );
  INVX1 U1561 ( .A(BA_RA[3]), .Y(n2705) );
  AOI221X1 U1562 ( .A0(openedrow[0]), .A1(n2692), .B0(BA_RA[0]), .B1(n2674), 
        .C0(LAST_RA[12]), .Y(n2691) );
  INVX1 U1563 ( .A(BA_RA[0]), .Y(n2692) );
  NAND2X1 U1564 ( .A(n2879), .B(n2880), .Y(nextstate[1]) );
  NAND2X1 U1565 ( .A(n2881), .B(n2882), .Y(n2880) );
  NAND3X1 U1566 ( .A(n2883), .B(n2852), .C(n2609), .Y(n2879) );
  NOR2X1 U1567 ( .A(BF_IDLE), .B(n2827), .Y(n2881) );
  NAND3BX1 U1568 ( .AN(cbs_rowopen), .B(cbs_casing), .C(BF_LAST), .Y(n2582) );
  NOR3X1 U1569 ( .A(n2874), .B(newrowexist), .C(n2842), .Y(n2869) );
  NOR2X1 U1570 ( .A(n2757), .B(n2875), .Y(n2874) );
  INVX1 U1571 ( .A(ERCMD[2]), .Y(n2653) );
  INVX1 U1572 ( .A(ERCMD[3]), .Y(n2654) );
  INVX1 U1573 ( .A(ERCMD[4]), .Y(n2652) );
  NAND3X1 U1574 ( .A(CAS_0_NEWROW), .B(cbs_rowopen), .C(n2637), .Y(n2633) );
  NOR2X1 U1575 ( .A(n2813), .B(length[3]), .Y(n2956) );
  NOR2X1 U1576 ( .A(length[2]), .B(length[1]), .Y(n2955) );
  AOI221X1 U1577 ( .A0(LAST_RA[1]), .A1(n2820), .B0(LAST_RA[2]), .B1(n2829), 
        .C0(n2672), .Y(n2662) );
  OAI222X1 U1578 ( .A0(openedrow[10]), .A1(n2673), .B0(openedrow[0]), .B1(
        n2674), .C0(openedrow[11]), .C1(n2675), .Y(n2672) );
  INVX1 U1579 ( .A(LAST_RA[11]), .Y(n2675) );
  AOI221X1 U1580 ( .A0(LAST_RA[6]), .A1(n2822), .B0(LAST_RA[7]), .B1(n2830), 
        .C0(n2678), .Y(n2661) );
  OAI222X1 U1581 ( .A0(openedrow[4]), .A1(n2679), .B0(openedrow[3]), .B1(n2680), .C0(openedrow[5]), .C1(n2681), .Y(n2678) );
  INVX1 U1582 ( .A(LAST_RA[5]), .Y(n2681) );
  INVX1 U1583 ( .A(LAST_RA[0]), .Y(n2674) );
  INVX1 U1584 ( .A(LAST_RA[3]), .Y(n2680) );
  INVX1 U1585 ( .A(LAST_RA[1]), .Y(n2693) );
  INVX1 U1586 ( .A(LAST_RA[6]), .Y(n2698) );
  INVX1 U1587 ( .A(LAST_RA[10]), .Y(n2673) );
  INVX1 U1588 ( .A(LAST_RA[4]), .Y(n2679) );
  OR2X1 U1589 ( .A(n2846), .B(trp_cnt[1]), .Y(n2882) );
  NOR2X1 U1590 ( .A(cbs_casing), .B(n2856), .Y(n2891) );
  NAND2X1 U1591 ( .A(n2884), .B(n2604), .Y(n2862) );
  NOR2X1 U1592 ( .A(cbs_rasing), .B(cbs_pcing), .Y(n2884) );
  NAND2X1 U1593 ( .A(length[1]), .B(length[0]), .Y(n2903) );
  NOR2X1 U1594 ( .A(trcd_cnt[1]), .B(n2848), .Y(n2847) );
  INVX1 U1595 ( .A(BF_NO[1]), .Y(n2686) );
  INVX1 U1596 ( .A(BF_NO[0]), .Y(n2936) );
  DFFRX1 trp_cnt_reg_0_ ( .D(n2517), .CK(ACLK), .RN(ARESETB), .Q(trp_cnt[0]), 
        .QN(n2846) );
  DFFRX1 length_reg_1_ ( .D(n2528), .CK(ACLK), .RN(ARESETB), .Q(length[1]), 
        .QN(n2816) );
  DFFRX1 currstate_reg_2_ ( .D(nextstate[2]), .CK(ACLK), .RN(ARESETB), .Q(
        cbs_rowopen), .QN(n2821) );
  DFFRX1 trp_cnt_reg_1_ ( .D(n2516), .CK(ACLK), .RN(ARESETB), .Q(trp_cnt[1])
         );
  DFFRX1 length_reg_2_ ( .D(n2527), .CK(ACLK), .RN(ARESETB), .Q(length[2]), 
        .QN(n2814) );
  DFFRX1 length_reg_3_ ( .D(n2526), .CK(ACLK), .RN(ARESETB), .Q(length[3]), 
        .QN(n2825) );
  DFFRX1 trrd_cnt_reg_0_ ( .D(n2519), .CK(ACLK), .RN(ARESETB), .Q(trrd_cnt_0_), 
        .QN(n2824) );
  DFFRX1 trasmin_cnt_reg_0_ ( .D(n2525), .CK(ACLK), .RN(ARESETB), .Q(
        trasmin_cnt[0]), .QN(n2838) );
  DFFRX1 trasmin_cnt_reg_1_ ( .D(n2524), .CK(ACLK), .RN(ARESETB), .Q(
        trasmin_cnt[1]) );
  DFFRX1 length_reg_0_ ( .D(n2529), .CK(ACLK), .RN(ARESETB), .Q(length[0]), 
        .QN(n2813) );
  DFFRX1 trrd_cnt_reg_1_ ( .D(n2518), .CK(ACLK), .RN(ARESETB), .Q(trrd_cnt_1_), 
        .QN(net1943) );
  DFFRX1 trasmin_cnt_reg_3_ ( .D(n2522), .CK(ACLK), .RN(ARESETB), .Q(
        trasmin_cnt[3]), .QN(net1918) );
  DFFRX1 trasmin_cnt_reg_2_ ( .D(n2523), .CK(ACLK), .RN(ARESETB), .Q(
        trasmin_cnt[2]), .QN(net1919) );
  DFFRX1 newrowexist_reg ( .D(n2543), .CK(ACLK), .RN(ARESETB), .Q(newrowexist), 
        .QN(n2817) );
  DFFRX1 newrowenable_reg ( .D(n2542), .CK(ACLK), .RN(ARESETB), .QN(n2823) );
  DFFRX1 openedrow_reg_11_ ( .D(n2530), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[11]), .QN(n2826) );
  DFFRX1 openedrow_reg_5_ ( .D(n2536), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[5]), .QN(n2834) );
  DFFRX1 openedrow_reg_9_ ( .D(n2532), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[9]), .QN(n2831) );
  DFFRX1 openedrow_reg_7_ ( .D(n2534), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[7]), .QN(n2830) );
  DFFRX1 openedrow_reg_4_ ( .D(n2537), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[4]), .QN(n2832) );
  DFFRX1 openedrow_reg_6_ ( .D(n2535), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[6]), .QN(n2822) );
  DFFRX1 openedrow_reg_2_ ( .D(n2539), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[2]), .QN(n2829) );
  DFFRX1 openedrow_reg_10_ ( .D(n2531), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[10]), .QN(n2833) );
  DFFRX1 openedrow_reg_8_ ( .D(n2533), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[8]), .QN(n2819) );
  DFFRX1 openedrow_reg_1_ ( .D(n2540), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[1]), .QN(n2820) );
  DFFRX1 openedrow_reg_3_ ( .D(n2538), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[3]) );
  DFFRX1 openedrow_reg_0_ ( .D(n2541), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[0]) );
  DFFRX1 currstate_reg_4_ ( .D(nextstate[4]), .CK(ACLK), .RN(ARESETB), .Q(
        cbs_casing), .QN(n2837) );
  DFFRX1 currstate_reg_1_ ( .D(nextstate[1]), .CK(ACLK), .RN(ARESETB), .Q(
        cbs_pcing), .QN(n2827) );
  DFFRX1 trcd_cnt_reg_1_ ( .D(n2520), .CK(ACLK), .RN(ARESETB), .Q(trcd_cnt[1]), 
        .QN(n2836) );
  DFFRX1 cas_0_final_l_reg ( .D(n2544), .CK(ACLK), .RN(ARESETB), .Q(
        cas_0_final_l), .QN(n2839) );
  DFFRX1 cas_0_newrow_l_reg ( .D(n2545), .CK(ACLK), .RN(ARESETB), .Q(
        cas_0_newrow_l), .QN(n2835) );
  DFFRX1 trcd_cnt_reg_0_ ( .D(n2521), .CK(ACLK), .RN(ARESETB), .Q(trcd_cnt[0]), 
        .QN(n2848) );
  AO22X1 U1597 ( .A0(openedrow[8]), .A1(n2958), .B0(n2709), .B1(RAS_0_RA[8]), 
        .Y(n2533) );
  AO22X1 U1598 ( .A0(openedrow[0]), .A1(n2958), .B0(n2709), .B1(RAS_0_RA[0]), 
        .Y(n2541) );
  AO22X1 U1599 ( .A0(openedrow[10]), .A1(n2958), .B0(n2709), .B1(RAS_0_RA[10]), 
        .Y(n2531) );
  AO22X1 U1600 ( .A0(openedrow[1]), .A1(n2958), .B0(n2709), .B1(RAS_0_RA[1]), 
        .Y(n2540) );
  AO22X1 U1601 ( .A0(openedrow[2]), .A1(n2958), .B0(n2709), .B1(RAS_0_RA[2]), 
        .Y(n2539) );
endmodule


module SDRBsm_2 ( ARESETB, ACLK, TRP, TRRD, TRCD, TRASMIN, BA_BA, BA_RA, BA_TT, 
        BA_REQ, CAS_0_BA, CAS_0_RA, CAS_0_TT, CAS_0_FINAL, CAS_0_NEWROW, 
        CAS_EMPTY, LAST_RA, RAS_0_BA, RAS_0_RA, RAS_0_TT, RAS_EMPTY, BF_NO, 
        BF_CASBUSY, BF_TCASBUSY, BF_RASBUSY, BF_TRASBUSY, BF_READY, BF_TREADY, 
        BF_IDLE, BF_LAST, BF_REQCMD, BF_CMD, ERCMD, ECMD );
  input [1:0] TRP;
  input [1:0] TRRD;
  input [1:0] TRCD;
  input [3:0] TRASMIN;
  input [1:0] BA_BA;
  input [11:0] BA_RA;
  input [3:0] BA_TT;
  input [1:0] CAS_0_BA;
  input [11:0] CAS_0_RA;
  input [3:0] CAS_0_TT;
  input [12:0] LAST_RA;
  input [1:0] RAS_0_BA;
  input [11:0] RAS_0_RA;
  input [3:0] RAS_0_TT;
  input [1:0] BF_NO;
  output [5:0] BF_REQCMD;
  input [5:0] BF_CMD;
  input [5:0] ERCMD;
  input [6:0] ECMD;
  input ARESETB, ACLK, BA_REQ, CAS_0_FINAL, CAS_0_NEWROW, CAS_EMPTY, RAS_EMPTY,
         BF_TCASBUSY, BF_TRASBUSY, BF_TREADY;
  output BF_CASBUSY, BF_RASBUSY, BF_READY, BF_IDLE, BF_LAST;
  wire   cbs_pcing, cbs_rowopen, cbs_rasing, cbs_casing, cas_0_final_l,
         cas_0_newrow_l, trrd_cnt_1_, trrd_cnt_0_, newrowexist, n2516, n2517,
         n2518, n2519, n2520, n2521, n2522, n2523, n2524, n2525, n2526, n2527,
         n2528, n2529, n2530, n2531, n2532, n2533, n2534, n2535, n2536, n2537,
         n2538, n2539, n2540, n2541, n2542, n2543, n2544, n2545, n2571, n2574,
         n2577, n2581, n2585, n2592, n2603, n2607, n2608, n2609, n2610, n2611,
         n2612, n2614, n2616, n2622, n2624, n2625, n2627, n2628, n2629, n2630,
         n2632, n2633, n2634, n2636, n2637, n2638, n2639, n2641, n2642, n2643,
         n2644, n2646, n2647, n2648, n2649, n2650, n2651, n2652, n2653, n2654,
         n2655, n2656, n2657, n2658, n2659, n2660, n2661, n2662, n2663, n2664,
         n2665, n2666, n2667, n2671, n2672, n2673, n2674, n2677, n2678, n2679,
         n2680, n2682, n2683, n2684, n2685, n2686, n2687, n2689, n2690, n2691,
         n2692, n2693, n2694, n2695, n2697, n2698, n2699, n2702, n2703, n2704,
         n2705, n2706, n2707, n2708, n2720, n2721, n2722, n2723, n2724, n2726,
         n2727, n2728, n2729, n2731, n2732, n2733, n2734, n2736, n2737, n2739,
         n2740, n2741, n2742, n2743, n2744, n2745, n2747, n2748, n2749, n2750,
         n2751, n2752, n2753, n2754, n2755, n2756, n2757, n2812, n2813, n2814,
         n2816, n2817, n2818, n2819, n2820, n2821, n2822, n2823, n2824, n2825,
         n2826, n2827, n2828, n2829, n2830, n2831, n2832, n2833, n2834, n2835,
         n2836, n2837, n2838, n2839, n2840, n2841, n2842, n2843, n2844, n2845,
         n2846, n2847, n2848, n2849, n2850, n2851, n2852, n2853, n2854, n2855,
         n2856, n2857, n2858, n2859, n2860, n2861, n2862, n2863, n2864, n2865,
         n2866, n2867, n2868, n2869, n2870, n2871, n2872, n2873, n2874, n2875,
         n2876, n2877, n2878, n2879, n2880, n2881, n2882, n2883, n2884, n2885,
         n2886, n2887, n2888, n2889, n2890, n2891, n2892, n2893, n2894, n2895,
         n2896, n2897, n2898, n2899, n2900, n2901, n2902, n2903, n2904, n2905,
         n2906, n2907, n2908, n2909, n2910, n2911, n2912, n2913, n2914, n2915,
         n2916, n2917, n2918, n2919, n2920, n2921, n2922, n2923, n2924, n2925,
         n2926, n2927, n2928, n2929, n2930, n2931, n2932, n2933, n2934, n2935,
         n2936, n2937, n2938, n2939, n2940, n2941, n2942, n2943, n2944, n2945,
         n2946, n2947, n2948, n2949, n2950, n2951, n2952, n2953, n2954, n2955,
         n2956, net2106, net2082, net2081;
  wire   [3:0] length;
  wire   [11:0] openedrow;
  wire   [3:0] trasmin_cnt;
  wire   [4:0] nextstate;
  wire   [1:0] trcd_cnt;
  wire   [1:0] trp_cnt;

  NAND3X1 U1319 ( .A(n2932), .B(n2933), .C(n2934), .Y(n2919) );
  XOR2X1 U1320 ( .A(n2935), .B(RAS_0_BA[0]), .Y(n2934) );
  INVX1 U1321 ( .A(n2919), .Y(n2867) );
  AND2X2 U1322 ( .A(n2952), .B(n2953), .Y(BF_LAST) );
  NAND2X1 U1323 ( .A(n2603), .B(n2851), .Y(n2840) );
  NOR2X1 U1324 ( .A(n2840), .B(n2841), .Y(BF_REQCMD[0]) );
  NAND2X1 U1325 ( .A(n2873), .B(n2874), .Y(n2841) );
  BUFX2 U1326 ( .A(n2919), .Y(n2955) );
  XOR2X1 U1327 ( .A(n2685), .B(RAS_0_BA[1]), .Y(n2932) );
  INVX1 U1328 ( .A(RAS_EMPTY), .Y(n2933) );
  MXI2X1 U1329 ( .S0(n2868), .B(n2920), .A(n2921), .Y(n2911) );
  INVX1 U1330 ( .A(n2918), .Y(n2868) );
  AND2X2 U1331 ( .A(n2891), .B(n2614), .Y(n2839) );
  NAND4X1 U1332 ( .A(n2930), .B(n2757), .C(n2931), .D(n2867), .Y(n2918) );
  AND3X1 U1333 ( .A(n2870), .B(n2825), .C(n2871), .Y(n2842) );
  INVX1 U1334 ( .A(n2633), .Y(n2648) );
  INVX1 U1335 ( .A(BF_CMD[3]), .Y(n2723) );
  NAND3BX1 U1336 ( .AN(n2749), .B(n2740), .C(n2750), .Y(n2649) );
  XOR2X1 U1337 ( .A(BF_CMD[5]), .B(BF_CMD[2]), .Y(n2750) );
  NAND3BX1 U1338 ( .AN(BF_CMD[4]), .B(n2723), .C(n2622), .Y(n2749) );
  NAND3BX1 U1339 ( .AN(n2720), .B(n2622), .C(n2721), .Y(n2633) );
  XOR2X1 U1340 ( .A(BF_CMD[4]), .B(BF_CMD[0]), .Y(n2721) );
  NAND3BX1 U1341 ( .AN(BF_CMD[5]), .B(n2722), .C(n2723), .Y(n2720) );
  INVX1 U1342 ( .A(BF_CMD[2]), .Y(n2722) );
  INVX1 U1343 ( .A(BF_CMD[0]), .Y(n2740) );
  INVX1 U1344 ( .A(n2956), .Y(n2708) );
  INVX1 U1345 ( .A(BF_CMD[4]), .Y(n2614) );
  INVX1 U1346 ( .A(n2911), .Y(n2851) );
  INVX1 U1347 ( .A(BF_CMD[1]), .Y(n2622) );
  BUFX2 U1348 ( .A(n2707), .Y(n2956) );
  NAND3BX1 U1349 ( .AN(n2739), .B(n2740), .C(n2741), .Y(n2707) );
  NAND3BX1 U1350 ( .AN(BF_CMD[5]), .B(n2722), .C(n2614), .Y(n2739) );
  XOR2X1 U1351 ( .A(BF_CMD[3]), .B(BF_CMD[1]), .Y(n2741) );
  NAND3X1 U1352 ( .A(n2839), .B(BF_REQCMD[3]), .C(BF_CMD[3]), .Y(n2612) );
  DFFSX1 currstate_reg_0_ ( .D(nextstate[0]), .CK(ACLK), .SN(ARESETB), .Q(
        BF_IDLE), .QN(n2813) );
  INVX1 U1353 ( .A(n2890), .Y(BF_REQCMD[3]) );
  INVX1 U1354 ( .A(n2923), .Y(n2603) );
  INVX1 U1355 ( .A(n2892), .Y(BF_REQCMD[2]) );
  INVX1 U1356 ( .A(BF_TCASBUSY), .Y(n2873) );
  NOR2X1 U1357 ( .A(n2910), .B(n2911), .Y(BF_REQCMD[4]) );
  NAND3X1 U1358 ( .A(n2636), .B(n2603), .C(n2873), .Y(n2910) );
  INVX1 U1359 ( .A(n2870), .Y(n2921) );
  INVX1 U1360 ( .A(n2616), .Y(BF_REQCMD[5]) );
  INVX1 U1361 ( .A(n2908), .Y(n2954) );
  INVX1 U1362 ( .A(BA_RA[7]), .Y(n2667) );
  INVX1 U1363 ( .A(BA_RA[8]), .Y(n2666) );
  INVX1 U1364 ( .A(BA_RA[10]), .Y(n2689) );
  INVX1 U1365 ( .A(n2608), .Y(n2571) );
  OAI33X1 U1366 ( .A0(n2609), .A1(n2610), .A2(n2611), .B0(n2609), .B1(n2612), 
        .B2(n2610), .Y(n2608) );
  XOR2X1 U1367 ( .A(n2892), .B(n2722), .Y(n2610) );
  NAND3X1 U1368 ( .A(n2839), .B(n2890), .C(n2723), .Y(n2611) );
  INVX1 U1369 ( .A(BA_RA[2]), .Y(n2693) );
  INVX1 U1370 ( .A(BA_RA[4]), .Y(n2702) );
  AOI2BB1X1 U1371 ( .A0N(n2908), .A1N(length[0]), .B0(n2648), .Y(n2843) );
  XOR2X1 U1372 ( .A(n2616), .B(BF_CMD[5]), .Y(n2891) );
  INVX1 U1373 ( .A(n2889), .Y(n2627) );
  INVX1 U1374 ( .A(n2624), .Y(n2625) );
  INVX1 U1375 ( .A(n2904), .Y(n2909) );
  INVX1 U1376 ( .A(n2853), .Y(n2852) );
  INVX1 U1377 ( .A(n2898), .Y(n2903) );
  NAND2X1 U1378 ( .A(n2812), .B(n2954), .Y(BF_CASBUSY) );
  XOR2X1 U1379 ( .A(n2685), .B(BA_BA[1]), .Y(n2684) );
  NAND4BX1 U1380 ( .AN(n2756), .B(n2845), .C(n2603), .D(n2825), .Y(n2616) );
  NAND4X1 U1381 ( .A(n2936), .B(n2937), .C(n2938), .D(n2939), .Y(n2920) );
  NOR3X1 U1382 ( .A(n2949), .B(n2950), .C(n2951), .Y(n2936) );
  NOR3X1 U1383 ( .A(n2946), .B(n2947), .C(n2948), .Y(n2937) );
  NOR3X1 U1384 ( .A(n2943), .B(n2944), .C(n2945), .Y(n2938) );
  NAND3X1 U1385 ( .A(n2930), .B(n2931), .C(n2757), .Y(n2870) );
  NAND3X1 U1386 ( .A(n2814), .B(n2824), .C(n2816), .Y(n2908) );
  NAND2X1 U1387 ( .A(n2813), .B(cbs_rowopen), .Y(n2923) );
  NAND2X1 U1388 ( .A(n2915), .B(n2916), .Y(n2883) );
  NAND2X1 U1389 ( .A(n2917), .B(n2918), .Y(n2916) );
  INVX1 U1390 ( .A(n2872), .Y(n2915) );
  NOR2X1 U1391 ( .A(n2822), .B(n2955), .Y(n2917) );
  NAND2X1 U1392 ( .A(n2912), .B(n2857), .Y(n2890) );
  NOR2X1 U1393 ( .A(n2913), .B(n2813), .Y(n2912) );
  INVX1 U1394 ( .A(n2874), .Y(n2636) );
  INVX1 U1395 ( .A(n2888), .Y(n2857) );
  NAND2X1 U1396 ( .A(n2914), .B(n2883), .Y(n2892) );
  NOR2X1 U1397 ( .A(n2585), .B(n2923), .Y(n2914) );
  INVX1 U1398 ( .A(BF_TREADY), .Y(n2756) );
  INVX1 U1399 ( .A(n2585), .Y(n2592) );
  OAI32X1 U1400 ( .A0(n2637), .A1(n2638), .A2(n2639), .B0(n2822), .B1(n2641), 
        .Y(n2542) );
  INVX1 U1401 ( .A(n2629), .Y(n2638) );
  INVX1 U1402 ( .A(n2642), .Y(n2639) );
  INVX1 U1403 ( .A(n2641), .Y(n2637) );
  INVX1 U1404 ( .A(n2729), .Y(n2727) );
  NAND2BX1 U1405 ( .AN(n2819), .B(n2627), .Y(n2624) );
  NAND2BX1 U1406 ( .AN(n2819), .B(n2633), .Y(n2629) );
  NAND2X1 U1407 ( .A(n2648), .B(n2874), .Y(n2889) );
  NAND4X1 U1408 ( .A(n2863), .B(n2864), .C(n2865), .D(n2608), .Y(n2862) );
  NAND2BX1 U1409 ( .AN(n2592), .B(n2872), .Y(n2864) );
  NAND2X1 U1410 ( .A(n2851), .B(n2853), .Y(n2863) );
  MXI2X1 U1411 ( .S0(n2867), .B(n2866), .A(n2842), .Y(n2865) );
  OAI21X1 U1412 ( .A0(n2884), .A1(n2813), .B0(n2885), .Y(nextstate[0]) );
  NOR2X1 U1413 ( .A(n2886), .B(n2887), .Y(n2885) );
  NOR2X1 U1414 ( .A(n2571), .B(n2888), .Y(n2884) );
  NOR2X1 U1415 ( .A(n2820), .B(n2878), .Y(n2886) );
  NAND2BX1 U1416 ( .AN(n2893), .B(n2894), .Y(n2609) );
  XNOR2X1 U1417 ( .A(BF_REQCMD[0]), .B(BF_CMD[0]), .Y(n2894) );
  XNOR2X1 U1418 ( .A(BF_REQCMD[1]), .B(n2622), .Y(n2893) );
  OAI2BB1X1 U1419 ( .A0N(n2847), .A1N(n2848), .B0(n2849), .Y(nextstate[4]) );
  NOR2X1 U1420 ( .A(BF_LAST), .B(n2836), .Y(n2847) );
  INVX1 U1421 ( .A(n2854), .Y(n2848) );
  NAND4X1 U1422 ( .A(n2850), .B(n2851), .C(n2852), .D(n2608), .Y(n2849) );
  INVX1 U1423 ( .A(n2732), .Y(n2724) );
  NAND2BX1 U1424 ( .AN(n2708), .B(n2585), .Y(n2732) );
  NAND2X1 U1425 ( .A(n2858), .B(n2859), .Y(nextstate[2]) );
  NAND2X1 U1426 ( .A(n2860), .B(n2607), .Y(n2859) );
  NAND2BX1 U1427 ( .AN(n2861), .B(n2862), .Y(n2858) );
  INVX1 U1428 ( .A(n2742), .Y(n2744) );
  NAND2X1 U1429 ( .A(n2845), .B(BF_TREADY), .Y(n2871) );
  NAND2X1 U1430 ( .A(n2881), .B(n2882), .Y(n2879) );
  NAND2X1 U1431 ( .A(n2883), .B(n2592), .Y(n2881) );
  NAND3X1 U1432 ( .A(n2845), .B(n2825), .C(BF_TREADY), .Y(n2882) );
  DFFRX1 currstate_reg_3_ ( .D(nextstate[3]), .CK(ACLK), .RN(ARESETB), .Q(
        cbs_rasing), .QN(n2827) );
  NAND2X1 U1433 ( .A(n2820), .B(n2813), .Y(n2574) );
  NAND3X1 U1434 ( .A(n2819), .B(n2827), .C(n2607), .Y(n2854) );
  INVX1 U1435 ( .A(n2574), .Y(n2607) );
  NOR2X1 U1436 ( .A(n2868), .B(n2869), .Y(n2866) );
  NOR2X1 U1437 ( .A(n2822), .B(n2585), .Y(n2869) );
  NAND3X1 U1438 ( .A(n2816), .B(n2814), .C(n2812), .Y(n2904) );
  NAND2X1 U1439 ( .A(n2873), .B(n2874), .Y(n2853) );
  NAND2X1 U1440 ( .A(n2812), .B(n2816), .Y(n2898) );
  INVX1 U1441 ( .A(n2861), .Y(n2850) );
  XOR2X1 U1442 ( .A(n2935), .B(CAS_0_BA[0]), .Y(n2931) );
  XOR2X1 U1443 ( .A(n2685), .B(CAS_0_BA[1]), .Y(n2930) );
  OAI22X1 U1444 ( .A0(n2918), .A1(n2920), .B0(n2921), .B1(n2922), .Y(n2872) );
  NAND2X1 U1445 ( .A(n2955), .B(newrowexist), .Y(n2922) );
  AO21X1 U1446 ( .A0(n2592), .A1(cbs_rowopen), .B0(BF_IDLE), .Y(BF_READY) );
  XOR2X1 U1447 ( .A(RAS_0_RA[1]), .B(CAS_0_RA[1]), .Y(n2945) );
  XOR2X1 U1448 ( .A(RAS_0_RA[4]), .B(CAS_0_RA[4]), .Y(n2948) );
  XOR2X1 U1449 ( .A(RAS_0_RA[7]), .B(CAS_0_RA[7]), .Y(n2951) );
  XOR2X1 U1450 ( .A(RAS_0_RA[2]), .B(CAS_0_RA[2]), .Y(n2943) );
  XOR2X1 U1451 ( .A(RAS_0_RA[5]), .B(CAS_0_RA[5]), .Y(n2946) );
  XOR2X1 U1452 ( .A(RAS_0_RA[8]), .B(CAS_0_RA[8]), .Y(n2949) );
  XOR2X1 U1453 ( .A(RAS_0_RA[3]), .B(CAS_0_RA[3]), .Y(n2944) );
  XOR2X1 U1454 ( .A(RAS_0_RA[6]), .B(CAS_0_RA[6]), .Y(n2947) );
  XOR2X1 U1455 ( .A(RAS_0_RA[9]), .B(CAS_0_RA[9]), .Y(n2950) );
  NAND4BX1 U1456 ( .AN(n2655), .B(n2656), .C(n2657), .D(n2658), .Y(n2642) );
  OAI221X1 U1457 ( .A0(BA_RA[4]), .A1(n2831), .B0(LAST_RA[4]), .B1(n2702), 
        .C0(n2703), .Y(n2655) );
  AOI221X1 U1458 ( .A0(BA_RA[6]), .A1(n2697), .B0(openedrow[7]), .B1(n2667), 
        .C0(n2698), .Y(n2656) );
  AND4X1 U1459 ( .A(n2659), .B(n2660), .C(n2661), .D(n2662), .Y(n2658) );
  NOR2X1 U1460 ( .A(n2888), .B(n2924), .Y(BF_REQCMD[1]) );
  NAND2X1 U1461 ( .A(n2913), .B(BF_IDLE), .Y(n2924) );
  NAND2X1 U1462 ( .A(n2928), .B(n2929), .Y(n2874) );
  NOR2X1 U1463 ( .A(CAS_0_TT[1]), .B(CAS_0_TT[0]), .Y(n2928) );
  NOR2X1 U1464 ( .A(CAS_0_TT[3]), .B(CAS_0_TT[2]), .Y(n2929) );
  OR2X1 U1465 ( .A(trasmin_cnt[0]), .B(trasmin_cnt[1]), .Y(n2729) );
  NAND2X1 U1466 ( .A(n2844), .B(net2081), .Y(n2585) );
  NAND2X1 U1467 ( .A(n2823), .B(net2106), .Y(BF_RASBUSY) );
  INVX1 U1468 ( .A(CAS_EMPTY), .Y(n2757) );
  NOR3X1 U1469 ( .A(n2940), .B(n2941), .C(n2942), .Y(n2939) );
  XOR2X1 U1470 ( .A(RAS_0_RA[10]), .B(CAS_0_RA[10]), .Y(n2940) );
  XOR2X1 U1471 ( .A(RAS_0_RA[11]), .B(CAS_0_RA[11]), .Y(n2941) );
  XOR2X1 U1472 ( .A(RAS_0_RA[0]), .B(CAS_0_RA[0]), .Y(n2942) );
  OAI32X1 U1473 ( .A0(n2751), .A1(n2752), .A2(n2753), .B0(ERCMD[5]), .B1(n2754), .Y(n2654) );
  INVX1 U1474 ( .A(ERCMD[1]), .Y(n2754) );
  OR3X2 U1475 ( .A(ECMD[4]), .B(ECMD[6]), .C(ERCMD[1]), .Y(n2752) );
  OR2X1 U1476 ( .A(ECMD[3]), .B(ECMD[2]), .Y(n2753) );
  NAND2X1 U1477 ( .A(n2927), .B(n2867), .Y(n2888) );
  NOR3X1 U1478 ( .A(BF_TRASBUSY), .B(trp_cnt[1]), .C(trp_cnt[0]), .Y(n2927) );
  OAI211X1 U1479 ( .A0(n2643), .A1(n2633), .B0(n2642), .C0(n2644), .Y(n2641)
         );
  NAND3BX1 U1480 ( .AN(n2706), .B(cbs_rowopen), .C(n2636), .Y(n2643) );
  OA22X1 U1481 ( .A0(n2581), .A1(n2838), .B0(n2634), .B1(n2819), .Y(n2644) );
  INVX1 U1482 ( .A(CAS_0_FINAL), .Y(n2706) );
  INVX1 U1483 ( .A(n2646), .Y(n2634) );
  OAI31X1 U1484 ( .A0(n2647), .A1(ERCMD[0]), .A2(n2648), .B0(n2649), .Y(n2646)
         );
  NAND4BX1 U1485 ( .AN(n2650), .B(n2651), .C(n2652), .D(n2653), .Y(n2647) );
  INVX1 U1486 ( .A(n2654), .Y(n2650) );
  NAND2X1 U1487 ( .A(n2925), .B(n2926), .Y(n2913) );
  NOR2X1 U1488 ( .A(RAS_0_TT[1]), .B(RAS_0_TT[0]), .Y(n2925) );
  NOR2X1 U1489 ( .A(RAS_0_TT[3]), .B(RAS_0_TT[2]), .Y(n2926) );
  NAND4BBX1 U1490 ( .AN(ECMD[1]), .BN(ECMD[0]), .C(ERCMD[5]), .D(ECMD[5]), .Y(
        n2751) );
  NOR2BX1 U1491 ( .AN(n2686), .B(n2687), .Y(n2657) );
  OAI221X1 U1492 ( .A0(BA_RA[10]), .A1(n2832), .B0(LAST_RA[10]), .B1(n2689), 
        .C0(n2690), .Y(n2687) );
  AOI221X1 U1493 ( .A0(BA_RA[1]), .A1(n2692), .B0(openedrow[2]), .B1(n2693), 
        .C0(n2694), .Y(n2686) );
  AND2X2 U1494 ( .A(n2727), .B(net2082), .Y(n2844) );
  AOI221X1 U1495 ( .A0(LAST_RA[8]), .A1(n2817), .B0(LAST_RA[9]), .B1(n2830), 
        .C0(n2682), .Y(n2659) );
  NAND3BX1 U1496 ( .AN(n2683), .B(n2684), .C(BA_REQ), .Y(n2682) );
  XOR2X1 U1497 ( .A(BF_NO[0]), .B(BA_BA[0]), .Y(n2683) );
  OAI222X1 U1498 ( .A0(LAST_RA[11]), .A1(n2695), .B0(BA_RA[11]), .B1(n2826), 
        .C0(BA_RA[1]), .C1(n2818), .Y(n2694) );
  INVX1 U1499 ( .A(BA_RA[11]), .Y(n2695) );
  NOR2BX1 U1500 ( .AN(RAS_EMPTY), .B(n2757), .Y(n2845) );
  AO22X1 U1501 ( .A0(n2628), .A1(newrowexist), .B0(n2629), .B1(n2630), .Y(
        n2543) );
  INVX1 U1502 ( .A(n2630), .Y(n2628) );
  OAI222X1 U1503 ( .A0(n2581), .A1(n2834), .B0(n2632), .B1(n2633), .C0(n2634), 
        .C1(n2819), .Y(n2630) );
  AOI221X1 U1504 ( .A0(openedrow[9]), .A1(n2663), .B0(BA_RA[9]), .B1(n2664), 
        .C0(n2665), .Y(n2662) );
  INVX1 U1505 ( .A(LAST_RA[9]), .Y(n2664) );
  INVX1 U1506 ( .A(BA_RA[9]), .Y(n2663) );
  OAI222X1 U1507 ( .A0(LAST_RA[8]), .A1(n2666), .B0(LAST_RA[7]), .B1(n2667), 
        .C0(BA_RA[8]), .C1(n2817), .Y(n2665) );
  AO21X1 U1508 ( .A0(n2747), .A1(n2654), .B0(n2748), .Y(n2742) );
  AND4X1 U1509 ( .A(n2755), .B(n2652), .C(n2653), .D(n2651), .Y(n2747) );
  INVX1 U1510 ( .A(n2649), .Y(n2748) );
  INVX1 U1511 ( .A(ERCMD[0]), .Y(n2755) );
  OAI21X1 U1512 ( .A0(n2889), .A1(n2905), .B0(n2906), .Y(n2526) );
  INVX1 U1513 ( .A(CAS_0_TT[3]), .Y(n2905) );
  NAND2X1 U1514 ( .A(n2907), .B(n2843), .Y(n2906) );
  NOR2X1 U1515 ( .A(n2909), .B(n2824), .Y(n2907) );
  OAI21X1 U1516 ( .A0(n2889), .A1(n2895), .B0(n2896), .Y(n2528) );
  INVX1 U1517 ( .A(CAS_0_TT[1]), .Y(n2895) );
  NAND2X1 U1518 ( .A(n2843), .B(n2897), .Y(n2896) );
  NAND2X1 U1519 ( .A(n2898), .B(n2899), .Y(n2897) );
  OAI21X1 U1520 ( .A0(n2889), .A1(n2900), .B0(n2901), .Y(n2527) );
  INVX1 U1521 ( .A(CAS_0_TT[2]), .Y(n2900) );
  NAND2X1 U1522 ( .A(n2843), .B(n2902), .Y(n2901) );
  OAI21X1 U1523 ( .A0(n2903), .A1(n2814), .B0(n2904), .Y(n2902) );
  AO22X1 U1524 ( .A0(cas_0_newrow_l), .A1(n2624), .B0(CAS_0_NEWROW), .B1(n2625), .Y(n2545) );
  AO22X1 U1525 ( .A0(cas_0_final_l), .A1(n2624), .B0(CAS_0_FINAL), .B1(n2625), 
        .Y(n2544) );
  OAI2BB1X1 U1526 ( .A0N(n2855), .A1N(n2577), .B0(n2856), .Y(nextstate[3]) );
  NOR2X1 U1527 ( .A(n2827), .B(n2574), .Y(n2855) );
  NAND3X1 U1528 ( .A(n2857), .B(BF_IDLE), .C(n2608), .Y(n2856) );
  AO22X1 U1529 ( .A0(n2843), .A1(n2812), .B0(CAS_0_TT[0]), .B1(n2627), .Y(
        n2529) );
  AO22X1 U1530 ( .A0(openedrow[6]), .A1(n2956), .B0(n2708), .B1(RAS_0_RA[6]), 
        .Y(n2535) );
  AO22X1 U1531 ( .A0(openedrow[5]), .A1(n2956), .B0(n2708), .B1(RAS_0_RA[5]), 
        .Y(n2536) );
  AO22X1 U1532 ( .A0(openedrow[4]), .A1(n2956), .B0(n2708), .B1(RAS_0_RA[4]), 
        .Y(n2537) );
  OAI2BB1X1 U1533 ( .A0N(TRASMIN[2]), .A1N(n2708), .B0(n2728), .Y(n2523) );
  AOI32X1 U1534 ( .A0(trasmin_cnt[2]), .A1(n2729), .A2(n2724), .B0(n2724), 
        .B1(n2844), .Y(n2728) );
  OAI2BB1X1 U1535 ( .A0N(TRASMIN[1]), .A1N(n2708), .B0(n2726), .Y(n2524) );
  AOI32X1 U1536 ( .A0(trasmin_cnt[0]), .A1(trasmin_cnt[1]), .A2(n2724), .B0(
        n2724), .B1(n2727), .Y(n2726) );
  AO22X1 U1537 ( .A0(openedrow[7]), .A1(n2956), .B0(n2708), .B1(RAS_0_RA[7]), 
        .Y(n2534) );
  AO22X1 U1538 ( .A0(openedrow[3]), .A1(n2956), .B0(n2708), .B1(RAS_0_RA[3]), 
        .Y(n2538) );
  AO22X1 U1539 ( .A0(TRASMIN[0]), .A1(n2708), .B0(n2724), .B1(n2837), .Y(n2525) );
  AO22X1 U1540 ( .A0(openedrow[11]), .A1(n2956), .B0(n2708), .B1(RAS_0_RA[11]), 
        .Y(n2530) );
  AO22X1 U1541 ( .A0(openedrow[9]), .A1(n2956), .B0(n2708), .B1(RAS_0_RA[9]), 
        .Y(n2532) );
  AO22X1 U1542 ( .A0(TRRD[1]), .A1(n2708), .B0(n2737), .B1(n2956), .Y(n2518)
         );
  NOR2BX1 U1543 ( .AN(trrd_cnt_1_), .B(n2823), .Y(n2737) );
  AO22X1 U1544 ( .A0(TRCD[1]), .A1(n2708), .B0(n2734), .B1(n2956), .Y(n2520)
         );
  NOR2BX1 U1545 ( .AN(trcd_cnt[0]), .B(n2835), .Y(n2734) );
  AO22X1 U1546 ( .A0(TRASMIN[3]), .A1(n2708), .B0(n2731), .B1(n2724), .Y(n2522) );
  NOR2BX1 U1547 ( .AN(trasmin_cnt[3]), .B(n2844), .Y(n2731) );
  AO22X1 U1548 ( .A0(TRCD[0]), .A1(n2708), .B0(n2733), .B1(n2956), .Y(n2521)
         );
  NOR2BX1 U1549 ( .AN(trcd_cnt[1]), .B(trcd_cnt[0]), .Y(n2733) );
  AO22X1 U1550 ( .A0(TRP[1]), .A1(n2742), .B0(n2745), .B1(n2744), .Y(n2516) );
  NOR2BX1 U1551 ( .AN(trp_cnt[1]), .B(n2846), .Y(n2745) );
  AO22X1 U1552 ( .A0(TRP[0]), .A1(n2742), .B0(n2743), .B1(n2744), .Y(n2517) );
  NOR2BX1 U1553 ( .AN(trp_cnt[1]), .B(trp_cnt[0]), .Y(n2743) );
  AO22X1 U1554 ( .A0(TRRD[0]), .A1(n2708), .B0(n2736), .B1(n2956), .Y(n2519)
         );
  NOR2BX1 U1555 ( .AN(trrd_cnt_1_), .B(trrd_cnt_0_), .Y(n2736) );
  OAI222X1 U1556 ( .A0(LAST_RA[5]), .A1(n2699), .B0(BA_RA[5]), .B1(n2833), 
        .C0(BA_RA[6]), .C1(n2821), .Y(n2698) );
  INVX1 U1557 ( .A(BA_RA[5]), .Y(n2699) );
  AOI222X1 U1558 ( .A0(openedrow[3]), .A1(n2704), .B0(BA_RA[2]), .B1(n2705), 
        .C0(BA_RA[3]), .C1(n2679), .Y(n2703) );
  INVX1 U1559 ( .A(LAST_RA[2]), .Y(n2705) );
  INVX1 U1560 ( .A(BA_RA[3]), .Y(n2704) );
  AOI221X1 U1561 ( .A0(openedrow[0]), .A1(n2691), .B0(BA_RA[0]), .B1(n2673), 
        .C0(LAST_RA[12]), .Y(n2690) );
  INVX1 U1562 ( .A(BA_RA[0]), .Y(n2691) );
  NAND2X1 U1563 ( .A(n2875), .B(n2876), .Y(nextstate[1]) );
  NAND2X1 U1564 ( .A(n2877), .B(n2878), .Y(n2876) );
  NAND3X1 U1565 ( .A(n2879), .B(n2850), .C(n2608), .Y(n2875) );
  NOR2X1 U1566 ( .A(BF_IDLE), .B(n2820), .Y(n2877) );
  NAND3BX1 U1567 ( .AN(cbs_rowopen), .B(cbs_casing), .C(BF_LAST), .Y(n2581) );
  INVX1 U1568 ( .A(ERCMD[2]), .Y(n2652) );
  INVX1 U1569 ( .A(ERCMD[3]), .Y(n2653) );
  INVX1 U1570 ( .A(ERCMD[4]), .Y(n2651) );
  NAND3X1 U1571 ( .A(CAS_0_NEWROW), .B(cbs_rowopen), .C(n2636), .Y(n2632) );
  NOR2X1 U1572 ( .A(n2812), .B(length[3]), .Y(n2953) );
  NOR2X1 U1573 ( .A(length[2]), .B(length[1]), .Y(n2952) );
  AOI221X1 U1574 ( .A0(LAST_RA[1]), .A1(n2818), .B0(LAST_RA[2]), .B1(n2828), 
        .C0(n2671), .Y(n2661) );
  OAI222X1 U1575 ( .A0(openedrow[10]), .A1(n2672), .B0(openedrow[0]), .B1(
        n2673), .C0(openedrow[11]), .C1(n2674), .Y(n2671) );
  INVX1 U1576 ( .A(LAST_RA[11]), .Y(n2674) );
  AOI221X1 U1577 ( .A0(LAST_RA[6]), .A1(n2821), .B0(LAST_RA[7]), .B1(n2829), 
        .C0(n2677), .Y(n2660) );
  OAI222X1 U1578 ( .A0(openedrow[4]), .A1(n2678), .B0(openedrow[3]), .B1(n2679), .C0(openedrow[5]), .C1(n2680), .Y(n2677) );
  INVX1 U1579 ( .A(LAST_RA[5]), .Y(n2680) );
  INVX1 U1580 ( .A(LAST_RA[0]), .Y(n2673) );
  INVX1 U1581 ( .A(LAST_RA[3]), .Y(n2679) );
  INVX1 U1582 ( .A(LAST_RA[1]), .Y(n2692) );
  INVX1 U1583 ( .A(LAST_RA[6]), .Y(n2697) );
  INVX1 U1584 ( .A(LAST_RA[10]), .Y(n2672) );
  INVX1 U1585 ( .A(LAST_RA[4]), .Y(n2678) );
  MXI2X1 U1586 ( .S0(cbs_rasing), .B(n2577), .A(n2581), .Y(n2860) );
  OR2X1 U1587 ( .A(n2846), .B(trp_cnt[1]), .Y(n2878) );
  NOR2X1 U1588 ( .A(cbs_casing), .B(n2854), .Y(n2887) );
  NAND2X1 U1589 ( .A(length[1]), .B(length[0]), .Y(n2899) );
  NAND2X1 U1590 ( .A(n2880), .B(n2603), .Y(n2861) );
  NOR2X1 U1591 ( .A(cbs_rasing), .B(cbs_pcing), .Y(n2880) );
  NAND2BX1 U1592 ( .AN(trcd_cnt[1]), .B(trcd_cnt[0]), .Y(n2577) );
  INVX1 U1593 ( .A(BF_NO[1]), .Y(n2685) );
  INVX1 U1594 ( .A(BF_NO[0]), .Y(n2935) );
  DFFRX1 trp_cnt_reg_0_ ( .D(n2517), .CK(ACLK), .RN(ARESETB), .Q(trp_cnt[0]), 
        .QN(n2846) );
  DFFRX1 length_reg_1_ ( .D(n2528), .CK(ACLK), .RN(ARESETB), .Q(length[1]), 
        .QN(n2816) );
  DFFRX1 currstate_reg_2_ ( .D(nextstate[2]), .CK(ACLK), .RN(ARESETB), .Q(
        cbs_rowopen), .QN(n2819) );
  DFFRX1 trp_cnt_reg_1_ ( .D(n2516), .CK(ACLK), .RN(ARESETB), .Q(trp_cnt[1])
         );
  DFFRX1 length_reg_2_ ( .D(n2527), .CK(ACLK), .RN(ARESETB), .Q(length[2]), 
        .QN(n2814) );
  DFFRX1 newrowexist_reg ( .D(n2543), .CK(ACLK), .RN(ARESETB), .Q(newrowexist), 
        .QN(n2825) );
  DFFRX1 length_reg_3_ ( .D(n2526), .CK(ACLK), .RN(ARESETB), .Q(length[3]), 
        .QN(n2824) );
  DFFRX1 trrd_cnt_reg_0_ ( .D(n2519), .CK(ACLK), .RN(ARESETB), .Q(trrd_cnt_0_), 
        .QN(n2823) );
  DFFRX1 trasmin_cnt_reg_0_ ( .D(n2525), .CK(ACLK), .RN(ARESETB), .Q(
        trasmin_cnt[0]), .QN(n2837) );
  DFFRX1 trasmin_cnt_reg_1_ ( .D(n2524), .CK(ACLK), .RN(ARESETB), .Q(
        trasmin_cnt[1]) );
  DFFRX1 length_reg_0_ ( .D(n2529), .CK(ACLK), .RN(ARESETB), .Q(length[0]), 
        .QN(n2812) );
  DFFRX1 trrd_cnt_reg_1_ ( .D(n2518), .CK(ACLK), .RN(ARESETB), .Q(trrd_cnt_1_), 
        .QN(net2106) );
  DFFRX1 trasmin_cnt_reg_3_ ( .D(n2522), .CK(ACLK), .RN(ARESETB), .Q(
        trasmin_cnt[3]), .QN(net2081) );
  DFFRX1 trasmin_cnt_reg_2_ ( .D(n2523), .CK(ACLK), .RN(ARESETB), .Q(
        trasmin_cnt[2]), .QN(net2082) );
  DFFRX1 newrowenable_reg ( .D(n2542), .CK(ACLK), .RN(ARESETB), .QN(n2822) );
  DFFRX1 openedrow_reg_11_ ( .D(n2530), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[11]), .QN(n2826) );
  DFFRX1 openedrow_reg_5_ ( .D(n2536), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[5]), .QN(n2833) );
  DFFRX1 openedrow_reg_9_ ( .D(n2532), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[9]), .QN(n2830) );
  DFFRX1 openedrow_reg_7_ ( .D(n2534), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[7]), .QN(n2829) );
  DFFRX1 openedrow_reg_4_ ( .D(n2537), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[4]), .QN(n2831) );
  DFFRX1 openedrow_reg_6_ ( .D(n2535), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[6]), .QN(n2821) );
  DFFRX1 openedrow_reg_2_ ( .D(n2539), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[2]), .QN(n2828) );
  DFFRX1 openedrow_reg_10_ ( .D(n2531), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[10]), .QN(n2832) );
  DFFRX1 openedrow_reg_8_ ( .D(n2533), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[8]), .QN(n2817) );
  DFFRX1 openedrow_reg_1_ ( .D(n2540), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[1]), .QN(n2818) );
  DFFRX1 openedrow_reg_3_ ( .D(n2538), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[3]) );
  DFFRX1 openedrow_reg_0_ ( .D(n2541), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[0]) );
  DFFRX1 currstate_reg_4_ ( .D(nextstate[4]), .CK(ACLK), .RN(ARESETB), .Q(
        cbs_casing), .QN(n2836) );
  DFFRX1 currstate_reg_1_ ( .D(nextstate[1]), .CK(ACLK), .RN(ARESETB), .Q(
        cbs_pcing), .QN(n2820) );
  DFFRX1 trcd_cnt_reg_1_ ( .D(n2520), .CK(ACLK), .RN(ARESETB), .Q(trcd_cnt[1]), 
        .QN(n2835) );
  DFFRX1 cas_0_final_l_reg ( .D(n2544), .CK(ACLK), .RN(ARESETB), .Q(
        cas_0_final_l), .QN(n2838) );
  DFFRX1 cas_0_newrow_l_reg ( .D(n2545), .CK(ACLK), .RN(ARESETB), .Q(
        cas_0_newrow_l), .QN(n2834) );
  DFFRX1 trcd_cnt_reg_0_ ( .D(n2521), .CK(ACLK), .RN(ARESETB), .Q(trcd_cnt[0])
         );
  AO22X1 U1595 ( .A0(openedrow[8]), .A1(n2956), .B0(n2708), .B1(RAS_0_RA[8]), 
        .Y(n2533) );
  AO22X1 U1596 ( .A0(openedrow[0]), .A1(n2956), .B0(n2708), .B1(RAS_0_RA[0]), 
        .Y(n2541) );
  AO22X1 U1597 ( .A0(openedrow[10]), .A1(n2956), .B0(n2708), .B1(RAS_0_RA[10]), 
        .Y(n2531) );
  AO22X1 U1598 ( .A0(openedrow[1]), .A1(n2956), .B0(n2708), .B1(RAS_0_RA[1]), 
        .Y(n2540) );
  AO22X1 U1599 ( .A0(openedrow[2]), .A1(n2956), .B0(n2708), .B1(RAS_0_RA[2]), 
        .Y(n2539) );
endmodule


module SDRBsm_1 ( ARESETB, ACLK, TRP, TRRD, TRCD, TRASMIN, BA_BA, BA_RA, BA_TT, 
        BA_REQ, CAS_0_BA, CAS_0_RA, CAS_0_TT, CAS_0_FINAL, CAS_0_NEWROW, 
        CAS_EMPTY, LAST_RA, RAS_0_BA, RAS_0_RA, RAS_0_TT, RAS_EMPTY, BF_NO, 
        BF_CASBUSY, BF_TCASBUSY, BF_RASBUSY, BF_TRASBUSY, BF_READY, BF_TREADY, 
        BF_IDLE, BF_LAST, BF_REQCMD, BF_CMD, ERCMD, ECMD );
  input [1:0] TRP;
  input [1:0] TRRD;
  input [1:0] TRCD;
  input [3:0] TRASMIN;
  input [1:0] BA_BA;
  input [11:0] BA_RA;
  input [3:0] BA_TT;
  input [1:0] CAS_0_BA;
  input [11:0] CAS_0_RA;
  input [3:0] CAS_0_TT;
  input [12:0] LAST_RA;
  input [1:0] RAS_0_BA;
  input [11:0] RAS_0_RA;
  input [3:0] RAS_0_TT;
  input [1:0] BF_NO;
  output [5:0] BF_REQCMD;
  input [5:0] BF_CMD;
  input [5:0] ERCMD;
  input [6:0] ECMD;
  input ARESETB, ACLK, BA_REQ, CAS_0_FINAL, CAS_0_NEWROW, CAS_EMPTY, RAS_EMPTY,
         BF_TCASBUSY, BF_TRASBUSY, BF_TREADY;
  output BF_CASBUSY, BF_RASBUSY, BF_READY, BF_IDLE, BF_LAST;
  wire   cbs_pcing, cbs_rowopen, cbs_rasing, cbs_casing, cas_0_final_l,
         cas_0_newrow_l, trrd_cnt_1_, trrd_cnt_0_, newrowexist, n2516, n2517,
         n2518, n2519, n2520, n2521, n2522, n2523, n2524, n2525, n2526, n2527,
         n2528, n2529, n2530, n2531, n2532, n2533, n2534, n2535, n2536, n2537,
         n2538, n2539, n2540, n2541, n2542, n2543, n2544, n2545, n2572, n2575,
         n2578, n2582, n2586, n2593, n2604, n2608, n2609, n2610, n2611, n2612,
         n2613, n2615, n2617, n2623, n2625, n2626, n2628, n2629, n2630, n2631,
         n2633, n2634, n2635, n2637, n2638, n2639, n2640, n2642, n2643, n2644,
         n2645, n2647, n2648, n2649, n2650, n2651, n2652, n2653, n2654, n2655,
         n2656, n2657, n2658, n2659, n2660, n2661, n2662, n2663, n2664, n2665,
         n2666, n2667, n2668, n2672, n2673, n2674, n2675, n2678, n2679, n2680,
         n2681, n2683, n2684, n2685, n2686, n2687, n2688, n2690, n2691, n2692,
         n2693, n2694, n2695, n2696, n2698, n2699, n2700, n2703, n2704, n2705,
         n2706, n2707, n2708, n2709, n2721, n2722, n2723, n2724, n2725, n2727,
         n2728, n2729, n2730, n2732, n2733, n2734, n2735, n2737, n2738, n2740,
         n2741, n2742, n2743, n2744, n2745, n2746, n2748, n2749, n2750, n2751,
         n2752, n2753, n2754, n2755, n2756, n2757, n2758, n2813, n2815, n2816,
         n2817, n2818, n2819, n2820, n2821, n2822, n2823, n2824, n2825, n2826,
         n2827, n2828, n2829, n2830, n2831, n2832, n2833, n2834, n2835, n2836,
         n2837, n2838, n2839, n2840, n2841, n2842, n2843, n2844, n2845, n2846,
         n2847, n2848, n2849, n2850, n2851, n2852, n2853, n2854, n2855, n2856,
         n2857, n2858, n2859, n2860, n2861, n2862, n2863, n2864, n2865, n2866,
         n2867, n2868, n2869, n2870, n2871, n2872, n2873, n2874, n2875, n2876,
         n2877, n2878, n2879, n2880, n2881, n2882, n2883, n2884, n2885, n2886,
         n2887, n2888, n2889, n2890, n2891, n2892, n2893, n2894, n2895, n2896,
         n2897, n2898, n2899, n2900, n2901, n2902, n2903, n2904, n2905, n2906,
         n2907, n2908, n2909, n2910, n2911, n2912, n2913, n2914, n2915, n2916,
         n2917, n2918, n2919, n2920, n2921, n2922, n2923, n2924, n2925, n2926,
         n2927, n2928, n2929, n2930, n2931, n2932, n2933, n2934, n2935, n2936,
         n2937, n2938, n2939, n2940, n2941, n2942, n2943, n2944, n2945, n2946,
         n2947, n2948, n2949, n2950, n2951, n2952, n2953, n2954, n2955, n2956,
         n2957, n2958, n2959, n2960, net2269, net2245, net2244;
  wire   [3:0] length;
  wire   [11:0] openedrow;
  wire   [3:0] trasmin_cnt;
  wire   [4:0] nextstate;
  wire   [1:0] trcd_cnt;
  wire   [1:0] trp_cnt;

  NAND3X1 U1320 ( .A(n2939), .B(n2938), .C(n2937), .Y(n2920) );
  INVX1 U1321 ( .A(RAS_EMPTY), .Y(n2938) );
  XOR2X1 U1322 ( .A(n2686), .B(RAS_0_BA[1]), .Y(n2937) );
  XOR2X1 U1323 ( .A(n2940), .B(RAS_0_BA[0]), .Y(n2939) );
  NOR3X1 U1324 ( .A(BF_TRASBUSY), .B(trp_cnt[1]), .C(trp_cnt[0]), .Y(n2930) );
  AND2X2 U1325 ( .A(n2957), .B(n2958), .Y(BF_LAST) );
  OR2X1 U1326 ( .A(n2593), .B(n2874), .Y(n2828) );
  INVX1 U1327 ( .A(n2586), .Y(n2593) );
  NAND4X1 U1328 ( .A(n2935), .B(n2936), .C(n2758), .D(n2869), .Y(n2919) );
  INVX1 U1329 ( .A(n2920), .Y(n2869) );
  NAND2X1 U1330 ( .A(n2604), .B(n2854), .Y(n2931) );
  NOR2X1 U1331 ( .A(n2931), .B(n2932), .Y(BF_REQCMD[0]) );
  MXI2X1 U1332 ( .S0(n2870), .B(n2925), .A(n2924), .Y(n2913) );
  INVX1 U1333 ( .A(n2919), .Y(n2870) );
  INVX1 U1334 ( .A(n2892), .Y(BF_REQCMD[3]) );
  AND2X2 U1335 ( .A(n2893), .B(n2615), .Y(n2841) );
  NAND3X1 U1336 ( .A(n2936), .B(n2935), .C(n2758), .Y(n2872) );
  AND3X1 U1337 ( .A(n2872), .B(n2826), .C(n2873), .Y(n2842) );
  NOR2X1 U1338 ( .A(n2890), .B(n2927), .Y(BF_REQCMD[1]) );
  NAND2BX1 U1339 ( .AN(n2940), .B(CAS_0_BA[0]), .Y(n2845) );
  NAND2X1 U1340 ( .A(n2940), .B(n2843), .Y(n2844) );
  NAND2X1 U1341 ( .A(n2844), .B(n2845), .Y(n2935) );
  INVX1 U1342 ( .A(CAS_0_BA[0]), .Y(n2843) );
  INVX1 U1343 ( .A(n2634), .Y(n2649) );
  INVX1 U1344 ( .A(BF_CMD[3]), .Y(n2724) );
  INVX1 U1345 ( .A(BF_CMD[2]), .Y(n2723) );
  INVX1 U1346 ( .A(BF_CMD[4]), .Y(n2615) );
  INVX1 U1347 ( .A(n2913), .Y(n2854) );
  NAND3BX1 U1348 ( .AN(n2750), .B(n2741), .C(n2751), .Y(n2650) );
  XOR2X1 U1349 ( .A(BF_CMD[5]), .B(BF_CMD[2]), .Y(n2751) );
  NAND3BX1 U1350 ( .AN(BF_CMD[4]), .B(n2724), .C(n2623), .Y(n2750) );
  NAND3BX1 U1351 ( .AN(n2721), .B(n2623), .C(n2722), .Y(n2634) );
  XOR2X1 U1352 ( .A(BF_CMD[4]), .B(BF_CMD[0]), .Y(n2722) );
  NAND3BX1 U1353 ( .AN(BF_CMD[5]), .B(n2723), .C(n2724), .Y(n2721) );
  NAND3X1 U1354 ( .A(n2841), .B(BF_REQCMD[3]), .C(BF_CMD[3]), .Y(n2613) );
  INVX1 U1355 ( .A(BF_CMD[0]), .Y(n2741) );
  INVX1 U1356 ( .A(n2960), .Y(n2709) );
  DFFSX1 currstate_reg_0_ ( .D(nextstate[0]), .CK(ACLK), .SN(ARESETB), .Q(
        BF_IDLE), .QN(n2815) );
  NOR2X1 U1357 ( .A(n2912), .B(n2913), .Y(BF_REQCMD[4]) );
  NAND3X1 U1358 ( .A(n2637), .B(n2604), .C(n2875), .Y(n2912) );
  INVX1 U1359 ( .A(n2926), .Y(n2604) );
  INVX1 U1360 ( .A(n2872), .Y(n2924) );
  INVX1 U1361 ( .A(n2894), .Y(BF_REQCMD[2]) );
  INVX1 U1362 ( .A(BF_TCASBUSY), .Y(n2875) );
  INVX1 U1363 ( .A(n2617), .Y(BF_REQCMD[5]) );
  INVX1 U1364 ( .A(n2609), .Y(n2572) );
  OAI33X1 U1365 ( .A0(n2610), .A1(n2611), .A2(n2612), .B0(n2610), .B1(n2613), 
        .B2(n2611), .Y(n2609) );
  XOR2X1 U1366 ( .A(n2894), .B(n2723), .Y(n2611) );
  NAND3X1 U1367 ( .A(n2841), .B(n2892), .C(n2724), .Y(n2612) );
  INVX1 U1368 ( .A(BA_RA[7]), .Y(n2668) );
  INVX1 U1369 ( .A(BA_RA[8]), .Y(n2667) );
  INVX1 U1370 ( .A(BA_RA[10]), .Y(n2690) );
  XOR2X1 U1371 ( .A(n2617), .B(BF_CMD[5]), .Y(n2893) );
  INVX1 U1372 ( .A(BF_CMD[1]), .Y(n2623) );
  BUFX2 U1373 ( .A(n2708), .Y(n2960) );
  NAND3BX1 U1374 ( .AN(n2740), .B(n2741), .C(n2742), .Y(n2708) );
  NAND3BX1 U1375 ( .AN(BF_CMD[5]), .B(n2723), .C(n2615), .Y(n2740) );
  XOR2X1 U1376 ( .A(BF_CMD[3]), .B(BF_CMD[1]), .Y(n2742) );
  NAND4X1 U1377 ( .A(n2866), .B(n2828), .C(n2867), .D(n2609), .Y(n2865) );
  NAND2X1 U1378 ( .A(n2854), .B(n2856), .Y(n2866) );
  MXI2X1 U1379 ( .S0(n2869), .B(n2868), .A(n2842), .Y(n2867) );
  INVX1 U1380 ( .A(BA_RA[2]), .Y(n2694) );
  INVX1 U1381 ( .A(BA_RA[4]), .Y(n2703) );
  AOI2BB1X1 U1382 ( .A0N(n2910), .A1N(length[0]), .B0(n2649), .Y(n2846) );
  INVX1 U1383 ( .A(n2891), .Y(n2628) );
  INVX1 U1384 ( .A(n2625), .Y(n2626) );
  INVX1 U1385 ( .A(n2906), .Y(n2911) );
  INVX1 U1386 ( .A(n2856), .Y(n2855) );
  INVX1 U1387 ( .A(n2900), .Y(n2905) );
  XOR2X1 U1388 ( .A(n2686), .B(BA_BA[1]), .Y(n2685) );
  NAND2X1 U1389 ( .A(n2875), .B(n2876), .Y(n2932) );
  OAI21X1 U1390 ( .A0(n2921), .A1(n2872), .B0(n2922), .Y(n2874) );
  NOR2X1 U1391 ( .A(n2920), .B(n2925), .Y(n2921) );
  NAND2X1 U1392 ( .A(n2872), .B(n2923), .Y(n2922) );
  NAND4BX1 U1393 ( .AN(n2757), .B(n2848), .C(n2604), .D(n2826), .Y(n2617) );
  NAND4X1 U1394 ( .A(n2941), .B(n2942), .C(n2943), .D(n2944), .Y(n2925) );
  NOR3X1 U1395 ( .A(n2954), .B(n2955), .C(n2956), .Y(n2941) );
  NOR3X1 U1396 ( .A(n2951), .B(n2952), .C(n2953), .Y(n2942) );
  NOR3X1 U1397 ( .A(n2948), .B(n2949), .C(n2950), .Y(n2943) );
  NAND3X1 U1398 ( .A(n2816), .B(n2825), .C(n2817), .Y(n2910) );
  NAND2X1 U1399 ( .A(n2874), .B(n2917), .Y(n2885) );
  NAND2X1 U1400 ( .A(n2918), .B(n2919), .Y(n2917) );
  NOR2X1 U1401 ( .A(n2823), .B(n2920), .Y(n2918) );
  NAND2X1 U1402 ( .A(n2815), .B(cbs_rowopen), .Y(n2926) );
  NAND2X1 U1403 ( .A(n2914), .B(n2860), .Y(n2892) );
  NOR2X1 U1404 ( .A(n2915), .B(n2815), .Y(n2914) );
  INVX1 U1405 ( .A(n2876), .Y(n2637) );
  NAND2X1 U1406 ( .A(n2916), .B(n2885), .Y(n2894) );
  NOR2X1 U1407 ( .A(n2586), .B(n2926), .Y(n2916) );
  INVX1 U1408 ( .A(n2890), .Y(n2860) );
  NAND2X1 U1409 ( .A(n2813), .B(n2959), .Y(BF_CASBUSY) );
  INVX1 U1410 ( .A(n2910), .Y(n2959) );
  INVX1 U1411 ( .A(BF_TREADY), .Y(n2757) );
  OAI32X1 U1412 ( .A0(n2638), .A1(n2639), .A2(n2640), .B0(n2823), .B1(n2642), 
        .Y(n2542) );
  INVX1 U1413 ( .A(n2630), .Y(n2639) );
  INVX1 U1414 ( .A(n2643), .Y(n2640) );
  INVX1 U1415 ( .A(n2642), .Y(n2638) );
  INVX1 U1416 ( .A(n2730), .Y(n2728) );
  OAI2BB1X1 U1417 ( .A0N(n2850), .A1N(n2851), .B0(n2852), .Y(nextstate[4]) );
  NOR2X1 U1418 ( .A(BF_LAST), .B(n2838), .Y(n2850) );
  INVX1 U1419 ( .A(n2857), .Y(n2851) );
  NAND4X1 U1420 ( .A(n2853), .B(n2854), .C(n2855), .D(n2609), .Y(n2852) );
  NAND2BX1 U1421 ( .AN(n2820), .B(n2628), .Y(n2625) );
  NAND2BX1 U1422 ( .AN(n2820), .B(n2634), .Y(n2630) );
  NAND2X1 U1423 ( .A(n2649), .B(n2876), .Y(n2891) );
  OAI21X1 U1424 ( .A0(n2886), .A1(n2815), .B0(n2887), .Y(nextstate[0]) );
  NOR2X1 U1425 ( .A(n2888), .B(n2889), .Y(n2887) );
  NOR2X1 U1426 ( .A(n2572), .B(n2890), .Y(n2886) );
  NOR2X1 U1427 ( .A(n2821), .B(n2880), .Y(n2888) );
  NAND2BX1 U1428 ( .AN(n2895), .B(n2896), .Y(n2610) );
  XNOR2X1 U1429 ( .A(BF_REQCMD[0]), .B(BF_CMD[0]), .Y(n2896) );
  XNOR2X1 U1430 ( .A(BF_REQCMD[1]), .B(n2623), .Y(n2895) );
  INVX1 U1431 ( .A(n2733), .Y(n2725) );
  NAND2BX1 U1432 ( .AN(n2709), .B(n2586), .Y(n2733) );
  NAND2X1 U1433 ( .A(n2861), .B(n2862), .Y(nextstate[2]) );
  NAND2X1 U1434 ( .A(n2863), .B(n2608), .Y(n2862) );
  NAND2BX1 U1435 ( .AN(n2864), .B(n2865), .Y(n2861) );
  INVX1 U1436 ( .A(n2743), .Y(n2745) );
  NAND2X1 U1437 ( .A(n2848), .B(BF_TREADY), .Y(n2873) );
  NAND2X1 U1438 ( .A(n2883), .B(n2884), .Y(n2881) );
  NAND2X1 U1439 ( .A(n2885), .B(n2593), .Y(n2883) );
  NAND3X1 U1440 ( .A(n2848), .B(n2826), .C(BF_TREADY), .Y(n2884) );
  DFFRX1 currstate_reg_3_ ( .D(nextstate[3]), .CK(ACLK), .RN(ARESETB), .Q(
        cbs_rasing), .QN(n2829) );
  NAND2X1 U1441 ( .A(n2821), .B(n2815), .Y(n2575) );
  NAND3X1 U1442 ( .A(n2820), .B(n2829), .C(n2608), .Y(n2857) );
  INVX1 U1443 ( .A(n2575), .Y(n2608) );
  NOR2X1 U1444 ( .A(n2870), .B(n2871), .Y(n2868) );
  NOR2X1 U1445 ( .A(n2823), .B(n2586), .Y(n2871) );
  NAND3X1 U1446 ( .A(n2817), .B(n2816), .C(n2813), .Y(n2906) );
  NAND2X1 U1447 ( .A(n2875), .B(n2876), .Y(n2856) );
  NAND2X1 U1448 ( .A(n2813), .B(n2817), .Y(n2900) );
  INVX1 U1449 ( .A(n2864), .Y(n2853) );
  XOR2X1 U1450 ( .A(n2686), .B(CAS_0_BA[1]), .Y(n2936) );
  AO21X1 U1451 ( .A0(n2593), .A1(cbs_rowopen), .B0(BF_IDLE), .Y(BF_READY) );
  XOR2X1 U1452 ( .A(RAS_0_RA[1]), .B(CAS_0_RA[1]), .Y(n2950) );
  XOR2X1 U1453 ( .A(RAS_0_RA[4]), .B(CAS_0_RA[4]), .Y(n2953) );
  XOR2X1 U1454 ( .A(RAS_0_RA[7]), .B(CAS_0_RA[7]), .Y(n2956) );
  NOR3X1 U1455 ( .A(n2945), .B(n2946), .C(n2947), .Y(n2944) );
  XOR2X1 U1456 ( .A(RAS_0_RA[10]), .B(CAS_0_RA[10]), .Y(n2945) );
  XOR2X1 U1457 ( .A(RAS_0_RA[11]), .B(CAS_0_RA[11]), .Y(n2946) );
  XOR2X1 U1458 ( .A(RAS_0_RA[0]), .B(CAS_0_RA[0]), .Y(n2947) );
  XOR2X1 U1459 ( .A(RAS_0_RA[2]), .B(CAS_0_RA[2]), .Y(n2948) );
  XOR2X1 U1460 ( .A(RAS_0_RA[5]), .B(CAS_0_RA[5]), .Y(n2951) );
  XOR2X1 U1461 ( .A(RAS_0_RA[8]), .B(CAS_0_RA[8]), .Y(n2954) );
  XOR2X1 U1462 ( .A(RAS_0_RA[3]), .B(CAS_0_RA[3]), .Y(n2949) );
  XOR2X1 U1463 ( .A(RAS_0_RA[6]), .B(CAS_0_RA[6]), .Y(n2952) );
  XOR2X1 U1464 ( .A(RAS_0_RA[9]), .B(CAS_0_RA[9]), .Y(n2955) );
  NAND2X1 U1465 ( .A(n2915), .B(BF_IDLE), .Y(n2927) );
  NAND4BX1 U1466 ( .AN(n2656), .B(n2657), .C(n2658), .D(n2659), .Y(n2643) );
  OAI221X1 U1467 ( .A0(BA_RA[4]), .A1(n2833), .B0(LAST_RA[4]), .B1(n2703), 
        .C0(n2704), .Y(n2656) );
  AOI221X1 U1468 ( .A0(BA_RA[6]), .A1(n2698), .B0(openedrow[7]), .B1(n2668), 
        .C0(n2699), .Y(n2657) );
  AND4X1 U1469 ( .A(n2660), .B(n2661), .C(n2662), .D(n2663), .Y(n2659) );
  NAND2X1 U1470 ( .A(n2933), .B(n2934), .Y(n2876) );
  NOR2X1 U1471 ( .A(CAS_0_TT[1]), .B(CAS_0_TT[0]), .Y(n2933) );
  NOR2X1 U1472 ( .A(CAS_0_TT[3]), .B(CAS_0_TT[2]), .Y(n2934) );
  OR2X1 U1473 ( .A(trasmin_cnt[0]), .B(trasmin_cnt[1]), .Y(n2730) );
  NAND2X1 U1474 ( .A(n2847), .B(net2244), .Y(n2586) );
  INVX1 U1475 ( .A(CAS_EMPTY), .Y(n2758) );
  OAI32X1 U1476 ( .A0(n2752), .A1(n2753), .A2(n2754), .B0(ERCMD[5]), .B1(n2755), .Y(n2655) );
  INVX1 U1477 ( .A(ERCMD[1]), .Y(n2755) );
  OR3X2 U1478 ( .A(ECMD[4]), .B(ECMD[6]), .C(ERCMD[1]), .Y(n2753) );
  OR2X1 U1479 ( .A(ECMD[3]), .B(ECMD[2]), .Y(n2754) );
  NAND2X1 U1480 ( .A(n2930), .B(n2869), .Y(n2890) );
  OAI211X1 U1481 ( .A0(n2644), .A1(n2634), .B0(n2643), .C0(n2645), .Y(n2642)
         );
  NAND3BX1 U1482 ( .AN(n2707), .B(cbs_rowopen), .C(n2637), .Y(n2644) );
  OA22X1 U1483 ( .A0(n2582), .A1(n2840), .B0(n2635), .B1(n2820), .Y(n2645) );
  INVX1 U1484 ( .A(CAS_0_FINAL), .Y(n2707) );
  INVX1 U1485 ( .A(n2647), .Y(n2635) );
  OAI31X1 U1486 ( .A0(n2648), .A1(ERCMD[0]), .A2(n2649), .B0(n2650), .Y(n2647)
         );
  NAND4BX1 U1487 ( .AN(n2651), .B(n2652), .C(n2653), .D(n2654), .Y(n2648) );
  INVX1 U1488 ( .A(n2655), .Y(n2651) );
  NAND2X1 U1489 ( .A(n2928), .B(n2929), .Y(n2915) );
  NOR2X1 U1490 ( .A(RAS_0_TT[1]), .B(RAS_0_TT[0]), .Y(n2928) );
  NOR2X1 U1491 ( .A(RAS_0_TT[3]), .B(RAS_0_TT[2]), .Y(n2929) );
  NAND4BBX1 U1492 ( .AN(ECMD[1]), .BN(ECMD[0]), .C(ERCMD[5]), .D(ECMD[5]), .Y(
        n2752) );
  NOR2BX1 U1493 ( .AN(n2687), .B(n2688), .Y(n2658) );
  OAI221X1 U1494 ( .A0(BA_RA[10]), .A1(n2834), .B0(LAST_RA[10]), .B1(n2690), 
        .C0(n2691), .Y(n2688) );
  AOI221X1 U1495 ( .A0(BA_RA[1]), .A1(n2693), .B0(openedrow[2]), .B1(n2694), 
        .C0(n2695), .Y(n2687) );
  NAND2X1 U1496 ( .A(newrowexist), .B(n2920), .Y(n2923) );
  AND2X2 U1497 ( .A(n2728), .B(net2245), .Y(n2847) );
  AOI221X1 U1498 ( .A0(LAST_RA[8]), .A1(n2818), .B0(LAST_RA[9]), .B1(n2832), 
        .C0(n2683), .Y(n2660) );
  NAND3BX1 U1499 ( .AN(n2684), .B(n2685), .C(BA_REQ), .Y(n2683) );
  XOR2X1 U1500 ( .A(BF_NO[0]), .B(BA_BA[0]), .Y(n2684) );
  NAND2X1 U1501 ( .A(n2824), .B(net2269), .Y(BF_RASBUSY) );
  OAI222X1 U1502 ( .A0(LAST_RA[11]), .A1(n2696), .B0(BA_RA[11]), .B1(n2827), 
        .C0(BA_RA[1]), .C1(n2819), .Y(n2695) );
  INVX1 U1503 ( .A(BA_RA[11]), .Y(n2696) );
  NOR2BX1 U1504 ( .AN(RAS_EMPTY), .B(n2758), .Y(n2848) );
  AO22X1 U1505 ( .A0(n2629), .A1(newrowexist), .B0(n2630), .B1(n2631), .Y(
        n2543) );
  INVX1 U1506 ( .A(n2631), .Y(n2629) );
  OAI222X1 U1507 ( .A0(n2582), .A1(n2836), .B0(n2633), .B1(n2634), .C0(n2635), 
        .C1(n2820), .Y(n2631) );
  AOI221X1 U1508 ( .A0(openedrow[9]), .A1(n2664), .B0(BA_RA[9]), .B1(n2665), 
        .C0(n2666), .Y(n2663) );
  INVX1 U1509 ( .A(LAST_RA[9]), .Y(n2665) );
  INVX1 U1510 ( .A(BA_RA[9]), .Y(n2664) );
  OAI222X1 U1511 ( .A0(LAST_RA[8]), .A1(n2667), .B0(LAST_RA[7]), .B1(n2668), 
        .C0(BA_RA[8]), .C1(n2818), .Y(n2666) );
  AO21X1 U1512 ( .A0(n2748), .A1(n2655), .B0(n2749), .Y(n2743) );
  AND4X1 U1513 ( .A(n2756), .B(n2653), .C(n2654), .D(n2652), .Y(n2748) );
  INVX1 U1514 ( .A(n2650), .Y(n2749) );
  INVX1 U1515 ( .A(ERCMD[0]), .Y(n2756) );
  OAI21X1 U1516 ( .A0(n2891), .A1(n2907), .B0(n2908), .Y(n2526) );
  INVX1 U1517 ( .A(CAS_0_TT[3]), .Y(n2907) );
  NAND2X1 U1518 ( .A(n2909), .B(n2846), .Y(n2908) );
  NOR2X1 U1519 ( .A(n2911), .B(n2825), .Y(n2909) );
  OAI21X1 U1520 ( .A0(n2891), .A1(n2897), .B0(n2898), .Y(n2528) );
  INVX1 U1521 ( .A(CAS_0_TT[1]), .Y(n2897) );
  NAND2X1 U1522 ( .A(n2846), .B(n2899), .Y(n2898) );
  NAND2X1 U1523 ( .A(n2900), .B(n2901), .Y(n2899) );
  OAI21X1 U1524 ( .A0(n2891), .A1(n2902), .B0(n2903), .Y(n2527) );
  INVX1 U1525 ( .A(CAS_0_TT[2]), .Y(n2902) );
  NAND2X1 U1526 ( .A(n2846), .B(n2904), .Y(n2903) );
  OAI21X1 U1527 ( .A0(n2905), .A1(n2816), .B0(n2906), .Y(n2904) );
  AO22X1 U1528 ( .A0(cas_0_newrow_l), .A1(n2625), .B0(CAS_0_NEWROW), .B1(n2626), .Y(n2545) );
  AO22X1 U1529 ( .A0(cas_0_final_l), .A1(n2625), .B0(CAS_0_FINAL), .B1(n2626), 
        .Y(n2544) );
  OAI2BB1X1 U1530 ( .A0N(n2858), .A1N(n2578), .B0(n2859), .Y(nextstate[3]) );
  NOR2X1 U1531 ( .A(n2829), .B(n2575), .Y(n2858) );
  NAND3X1 U1532 ( .A(n2860), .B(BF_IDLE), .C(n2609), .Y(n2859) );
  AO22X1 U1533 ( .A0(n2846), .A1(n2813), .B0(CAS_0_TT[0]), .B1(n2628), .Y(
        n2529) );
  AO22X1 U1534 ( .A0(openedrow[6]), .A1(n2960), .B0(n2709), .B1(RAS_0_RA[6]), 
        .Y(n2535) );
  AO22X1 U1535 ( .A0(openedrow[5]), .A1(n2960), .B0(n2709), .B1(RAS_0_RA[5]), 
        .Y(n2536) );
  AO22X1 U1536 ( .A0(openedrow[4]), .A1(n2960), .B0(n2709), .B1(RAS_0_RA[4]), 
        .Y(n2537) );
  OAI2BB1X1 U1537 ( .A0N(TRASMIN[2]), .A1N(n2709), .B0(n2729), .Y(n2523) );
  AOI32X1 U1538 ( .A0(trasmin_cnt[2]), .A1(n2730), .A2(n2725), .B0(n2725), 
        .B1(n2847), .Y(n2729) );
  OAI2BB1X1 U1539 ( .A0N(TRASMIN[1]), .A1N(n2709), .B0(n2727), .Y(n2524) );
  AOI32X1 U1540 ( .A0(trasmin_cnt[0]), .A1(trasmin_cnt[1]), .A2(n2725), .B0(
        n2725), .B1(n2728), .Y(n2727) );
  AO22X1 U1541 ( .A0(openedrow[7]), .A1(n2960), .B0(n2709), .B1(RAS_0_RA[7]), 
        .Y(n2534) );
  AO22X1 U1542 ( .A0(openedrow[3]), .A1(n2960), .B0(n2709), .B1(RAS_0_RA[3]), 
        .Y(n2538) );
  AO22X1 U1543 ( .A0(TRASMIN[0]), .A1(n2709), .B0(n2725), .B1(n2839), .Y(n2525) );
  AO22X1 U1544 ( .A0(openedrow[11]), .A1(n2960), .B0(n2709), .B1(RAS_0_RA[11]), 
        .Y(n2530) );
  AO22X1 U1545 ( .A0(openedrow[9]), .A1(n2960), .B0(n2709), .B1(RAS_0_RA[9]), 
        .Y(n2532) );
  AO22X1 U1546 ( .A0(TRRD[1]), .A1(n2709), .B0(n2738), .B1(n2960), .Y(n2518)
         );
  NOR2BX1 U1547 ( .AN(trrd_cnt_1_), .B(n2824), .Y(n2738) );
  AO22X1 U1548 ( .A0(TRCD[1]), .A1(n2709), .B0(n2735), .B1(n2960), .Y(n2520)
         );
  NOR2BX1 U1549 ( .AN(trcd_cnt[0]), .B(n2837), .Y(n2735) );
  AO22X1 U1550 ( .A0(TRASMIN[3]), .A1(n2709), .B0(n2732), .B1(n2725), .Y(n2522) );
  NOR2BX1 U1551 ( .AN(trasmin_cnt[3]), .B(n2847), .Y(n2732) );
  AO22X1 U1552 ( .A0(TRCD[0]), .A1(n2709), .B0(n2734), .B1(n2960), .Y(n2521)
         );
  NOR2BX1 U1553 ( .AN(trcd_cnt[1]), .B(trcd_cnt[0]), .Y(n2734) );
  AO22X1 U1554 ( .A0(TRP[1]), .A1(n2743), .B0(n2746), .B1(n2745), .Y(n2516) );
  NOR2BX1 U1555 ( .AN(trp_cnt[1]), .B(n2849), .Y(n2746) );
  AO22X1 U1556 ( .A0(TRP[0]), .A1(n2743), .B0(n2744), .B1(n2745), .Y(n2517) );
  NOR2BX1 U1557 ( .AN(trp_cnt[1]), .B(trp_cnt[0]), .Y(n2744) );
  AO22X1 U1558 ( .A0(TRRD[0]), .A1(n2709), .B0(n2737), .B1(n2960), .Y(n2519)
         );
  NOR2BX1 U1559 ( .AN(trrd_cnt_1_), .B(trrd_cnt_0_), .Y(n2737) );
  OAI222X1 U1560 ( .A0(LAST_RA[5]), .A1(n2700), .B0(BA_RA[5]), .B1(n2835), 
        .C0(BA_RA[6]), .C1(n2822), .Y(n2699) );
  INVX1 U1561 ( .A(BA_RA[5]), .Y(n2700) );
  AOI222X1 U1562 ( .A0(openedrow[3]), .A1(n2705), .B0(BA_RA[2]), .B1(n2706), 
        .C0(BA_RA[3]), .C1(n2680), .Y(n2704) );
  INVX1 U1563 ( .A(LAST_RA[2]), .Y(n2706) );
  INVX1 U1564 ( .A(BA_RA[3]), .Y(n2705) );
  AOI221X1 U1565 ( .A0(openedrow[0]), .A1(n2692), .B0(BA_RA[0]), .B1(n2674), 
        .C0(LAST_RA[12]), .Y(n2691) );
  INVX1 U1566 ( .A(BA_RA[0]), .Y(n2692) );
  NAND2X1 U1567 ( .A(n2877), .B(n2878), .Y(nextstate[1]) );
  NAND2X1 U1568 ( .A(n2879), .B(n2880), .Y(n2878) );
  NAND3X1 U1569 ( .A(n2881), .B(n2853), .C(n2609), .Y(n2877) );
  NOR2X1 U1570 ( .A(BF_IDLE), .B(n2821), .Y(n2879) );
  NAND3BX1 U1571 ( .AN(cbs_rowopen), .B(cbs_casing), .C(BF_LAST), .Y(n2582) );
  INVX1 U1572 ( .A(ERCMD[2]), .Y(n2653) );
  INVX1 U1573 ( .A(ERCMD[3]), .Y(n2654) );
  INVX1 U1574 ( .A(ERCMD[4]), .Y(n2652) );
  NAND3X1 U1575 ( .A(CAS_0_NEWROW), .B(cbs_rowopen), .C(n2637), .Y(n2633) );
  NOR2X1 U1576 ( .A(n2813), .B(length[3]), .Y(n2958) );
  NOR2X1 U1577 ( .A(length[2]), .B(length[1]), .Y(n2957) );
  AOI221X1 U1578 ( .A0(LAST_RA[1]), .A1(n2819), .B0(LAST_RA[2]), .B1(n2830), 
        .C0(n2672), .Y(n2662) );
  OAI222X1 U1579 ( .A0(openedrow[10]), .A1(n2673), .B0(openedrow[0]), .B1(
        n2674), .C0(openedrow[11]), .C1(n2675), .Y(n2672) );
  INVX1 U1580 ( .A(LAST_RA[11]), .Y(n2675) );
  AOI221X1 U1581 ( .A0(LAST_RA[6]), .A1(n2822), .B0(LAST_RA[7]), .B1(n2831), 
        .C0(n2678), .Y(n2661) );
  OAI222X1 U1582 ( .A0(openedrow[4]), .A1(n2679), .B0(openedrow[3]), .B1(n2680), .C0(openedrow[5]), .C1(n2681), .Y(n2678) );
  INVX1 U1583 ( .A(LAST_RA[5]), .Y(n2681) );
  INVX1 U1584 ( .A(LAST_RA[0]), .Y(n2674) );
  INVX1 U1585 ( .A(LAST_RA[3]), .Y(n2680) );
  INVX1 U1586 ( .A(LAST_RA[1]), .Y(n2693) );
  INVX1 U1587 ( .A(LAST_RA[6]), .Y(n2698) );
  INVX1 U1588 ( .A(LAST_RA[10]), .Y(n2673) );
  INVX1 U1589 ( .A(LAST_RA[4]), .Y(n2679) );
  MXI2X1 U1590 ( .S0(cbs_rasing), .B(n2578), .A(n2582), .Y(n2863) );
  OR2X1 U1591 ( .A(n2849), .B(trp_cnt[1]), .Y(n2880) );
  NOR2X1 U1592 ( .A(cbs_casing), .B(n2857), .Y(n2889) );
  NAND2X1 U1593 ( .A(length[1]), .B(length[0]), .Y(n2901) );
  NAND2X1 U1594 ( .A(n2882), .B(n2604), .Y(n2864) );
  NOR2X1 U1595 ( .A(cbs_rasing), .B(cbs_pcing), .Y(n2882) );
  NAND2BX1 U1596 ( .AN(trcd_cnt[1]), .B(trcd_cnt[0]), .Y(n2578) );
  INVX1 U1597 ( .A(BF_NO[1]), .Y(n2686) );
  INVX1 U1598 ( .A(BF_NO[0]), .Y(n2940) );
  DFFRX1 trp_cnt_reg_0_ ( .D(n2517), .CK(ACLK), .RN(ARESETB), .Q(trp_cnt[0]), 
        .QN(n2849) );
  DFFRX1 length_reg_1_ ( .D(n2528), .CK(ACLK), .RN(ARESETB), .Q(length[1]), 
        .QN(n2817) );
  DFFRX1 currstate_reg_2_ ( .D(nextstate[2]), .CK(ACLK), .RN(ARESETB), .Q(
        cbs_rowopen), .QN(n2820) );
  DFFRX1 trp_cnt_reg_1_ ( .D(n2516), .CK(ACLK), .RN(ARESETB), .Q(trp_cnt[1])
         );
  DFFRX1 newrowexist_reg ( .D(n2543), .CK(ACLK), .RN(ARESETB), .Q(newrowexist), 
        .QN(n2826) );
  DFFRX1 length_reg_2_ ( .D(n2527), .CK(ACLK), .RN(ARESETB), .Q(length[2]), 
        .QN(n2816) );
  DFFRX1 length_reg_3_ ( .D(n2526), .CK(ACLK), .RN(ARESETB), .Q(length[3]), 
        .QN(n2825) );
  DFFRX1 trrd_cnt_reg_0_ ( .D(n2519), .CK(ACLK), .RN(ARESETB), .Q(trrd_cnt_0_), 
        .QN(n2824) );
  DFFRX1 trasmin_cnt_reg_0_ ( .D(n2525), .CK(ACLK), .RN(ARESETB), .Q(
        trasmin_cnt[0]), .QN(n2839) );
  DFFRX1 trasmin_cnt_reg_1_ ( .D(n2524), .CK(ACLK), .RN(ARESETB), .Q(
        trasmin_cnt[1]) );
  DFFRX1 length_reg_0_ ( .D(n2529), .CK(ACLK), .RN(ARESETB), .Q(length[0]), 
        .QN(n2813) );
  DFFRX1 trrd_cnt_reg_1_ ( .D(n2518), .CK(ACLK), .RN(ARESETB), .Q(trrd_cnt_1_), 
        .QN(net2269) );
  DFFRX1 trasmin_cnt_reg_3_ ( .D(n2522), .CK(ACLK), .RN(ARESETB), .Q(
        trasmin_cnt[3]), .QN(net2244) );
  DFFRX1 trasmin_cnt_reg_2_ ( .D(n2523), .CK(ACLK), .RN(ARESETB), .Q(
        trasmin_cnt[2]), .QN(net2245) );
  DFFRX1 newrowenable_reg ( .D(n2542), .CK(ACLK), .RN(ARESETB), .QN(n2823) );
  DFFRX1 openedrow_reg_11_ ( .D(n2530), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[11]), .QN(n2827) );
  DFFRX1 openedrow_reg_5_ ( .D(n2536), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[5]), .QN(n2835) );
  DFFRX1 openedrow_reg_9_ ( .D(n2532), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[9]), .QN(n2832) );
  DFFRX1 openedrow_reg_7_ ( .D(n2534), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[7]), .QN(n2831) );
  DFFRX1 openedrow_reg_4_ ( .D(n2537), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[4]), .QN(n2833) );
  DFFRX1 openedrow_reg_6_ ( .D(n2535), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[6]), .QN(n2822) );
  DFFRX1 openedrow_reg_2_ ( .D(n2539), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[2]), .QN(n2830) );
  DFFRX1 openedrow_reg_10_ ( .D(n2531), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[10]), .QN(n2834) );
  DFFRX1 openedrow_reg_8_ ( .D(n2533), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[8]), .QN(n2818) );
  DFFRX1 openedrow_reg_1_ ( .D(n2540), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[1]), .QN(n2819) );
  DFFRX1 openedrow_reg_3_ ( .D(n2538), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[3]) );
  DFFRX1 openedrow_reg_0_ ( .D(n2541), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[0]) );
  DFFRX1 currstate_reg_4_ ( .D(nextstate[4]), .CK(ACLK), .RN(ARESETB), .Q(
        cbs_casing), .QN(n2838) );
  DFFRX1 currstate_reg_1_ ( .D(nextstate[1]), .CK(ACLK), .RN(ARESETB), .Q(
        cbs_pcing), .QN(n2821) );
  DFFRX1 trcd_cnt_reg_1_ ( .D(n2520), .CK(ACLK), .RN(ARESETB), .Q(trcd_cnt[1]), 
        .QN(n2837) );
  DFFRX1 cas_0_final_l_reg ( .D(n2544), .CK(ACLK), .RN(ARESETB), .Q(
        cas_0_final_l), .QN(n2840) );
  DFFRX1 cas_0_newrow_l_reg ( .D(n2545), .CK(ACLK), .RN(ARESETB), .Q(
        cas_0_newrow_l), .QN(n2836) );
  DFFRX1 trcd_cnt_reg_0_ ( .D(n2521), .CK(ACLK), .RN(ARESETB), .Q(trcd_cnt[0])
         );
  AO22X1 U1599 ( .A0(openedrow[8]), .A1(n2960), .B0(n2709), .B1(RAS_0_RA[8]), 
        .Y(n2533) );
  AO22X1 U1600 ( .A0(openedrow[0]), .A1(n2960), .B0(n2709), .B1(RAS_0_RA[0]), 
        .Y(n2541) );
  AO22X1 U1601 ( .A0(openedrow[10]), .A1(n2960), .B0(n2709), .B1(RAS_0_RA[10]), 
        .Y(n2531) );
  AO22X1 U1602 ( .A0(openedrow[1]), .A1(n2960), .B0(n2709), .B1(RAS_0_RA[1]), 
        .Y(n2540) );
  AO22X1 U1603 ( .A0(openedrow[2]), .A1(n2960), .B0(n2709), .B1(RAS_0_RA[2]), 
        .Y(n2539) );
endmodule


module SDRBsm_0 ( ARESETB, ACLK, TRP, TRRD, TRCD, TRASMIN, BA_BA, BA_RA, BA_TT, 
        BA_REQ, CAS_0_BA, CAS_0_RA, CAS_0_TT, CAS_0_FINAL, CAS_0_NEWROW, 
        CAS_EMPTY, LAST_RA, RAS_0_BA, RAS_0_RA, RAS_0_TT, RAS_EMPTY, BF_NO, 
        BF_CASBUSY, BF_TCASBUSY, BF_RASBUSY, BF_TRASBUSY, BF_READY, BF_TREADY, 
        BF_IDLE, BF_LAST, BF_REQCMD, BF_CMD, ERCMD, ECMD );
  input [1:0] TRP;
  input [1:0] TRRD;
  input [1:0] TRCD;
  input [3:0] TRASMIN;
  input [1:0] BA_BA;
  input [11:0] BA_RA;
  input [3:0] BA_TT;
  input [1:0] CAS_0_BA;
  input [11:0] CAS_0_RA;
  input [3:0] CAS_0_TT;
  input [12:0] LAST_RA;
  input [1:0] RAS_0_BA;
  input [11:0] RAS_0_RA;
  input [3:0] RAS_0_TT;
  input [1:0] BF_NO;
  output [5:0] BF_REQCMD;
  input [5:0] BF_CMD;
  input [5:0] ERCMD;
  input [6:0] ECMD;
  input ARESETB, ACLK, BA_REQ, CAS_0_FINAL, CAS_0_NEWROW, CAS_EMPTY, RAS_EMPTY,
         BF_TCASBUSY, BF_TRASBUSY, BF_TREADY;
  output BF_CASBUSY, BF_RASBUSY, BF_READY, BF_IDLE, BF_LAST;
  wire   cbs_pcing, cbs_rowopen, cbs_rasing, cbs_casing, cas_0_final_l,
         cas_0_newrow_l, trrd_cnt_1_, trrd_cnt_0_, newrowexist, n2516, n2517,
         n2518, n2519, n2520, n2521, n2522, n2523, n2524, n2525, n2526, n2527,
         n2528, n2529, n2530, n2531, n2532, n2533, n2534, n2535, n2536, n2537,
         n2538, n2539, n2540, n2541, n2542, n2543, n2544, n2545, n2571, n2574,
         n2577, n2581, n2585, n2592, n2603, n2607, n2608, n2609, n2610, n2611,
         n2612, n2614, n2616, n2622, n2624, n2625, n2627, n2628, n2629, n2630,
         n2632, n2633, n2634, n2636, n2637, n2638, n2639, n2641, n2642, n2643,
         n2644, n2646, n2647, n2648, n2649, n2650, n2651, n2652, n2653, n2654,
         n2655, n2656, n2657, n2658, n2659, n2660, n2661, n2662, n2663, n2664,
         n2665, n2666, n2667, n2671, n2672, n2673, n2674, n2677, n2678, n2679,
         n2680, n2682, n2683, n2684, n2685, n2686, n2687, n2689, n2690, n2691,
         n2692, n2693, n2694, n2695, n2697, n2698, n2699, n2702, n2703, n2704,
         n2705, n2706, n2707, n2708, n2720, n2721, n2722, n2723, n2724, n2726,
         n2727, n2728, n2729, n2731, n2732, n2733, n2734, n2736, n2737, n2739,
         n2740, n2741, n2742, n2743, n2744, n2745, n2747, n2748, n2749, n2750,
         n2751, n2752, n2753, n2754, n2755, n2756, n2757, n2813, n2814, n2815,
         n2816, n2817, n2818, n2819, n2820, n2821, n2822, n2823, n2824, n2825,
         n2826, n2827, n2828, n2829, n2830, n2831, n2832, n2833, n2834, n2835,
         n2836, n2837, n2838, n2839, n2840, n2842, n2843, n2844, n2845, n2846,
         n2847, n2848, n2849, n2850, n2851, n2852, n2853, n2854, n2855, n2856,
         n2857, n2858, n2859, n2860, n2861, n2862, n2863, n2864, n2865, n2866,
         n2867, n2868, n2869, n2870, n2871, n2872, n2873, n2874, n2875, n2876,
         n2877, n2878, n2879, n2880, n2881, n2882, n2883, n2884, n2885, n2886,
         n2887, n2888, n2889, n2890, n2891, n2892, n2893, n2894, n2895, n2896,
         n2897, n2898, n2899, n2900, n2901, n2902, n2903, n2904, n2905, n2906,
         n2907, n2908, n2909, n2910, n2911, n2912, n2913, n2914, n2915, n2916,
         n2917, n2918, n2919, n2920, n2921, n2922, n2923, n2924, n2925, n2926,
         n2927, n2928, n2929, n2930, n2931, n2932, n2933, n2934, n2935, n2936,
         n2937, n2938, n2939, n2940, n2941, n2942, n2943, n2944, n2945, n2946,
         n2947, n2948, n2949, n2950, n2951, n2952, n2953, n2954, n2955, n2956,
         n2957, net2432, net2408, net2407;
  wire   [3:0] length;
  wire   [11:0] openedrow;
  wire   [3:0] trasmin_cnt;
  wire   [4:0] nextstate;
  wire   [1:0] trcd_cnt;
  wire   [1:0] trp_cnt;

  NAND3BX1 U1318 ( .AN(n2846), .B(n2935), .C(n2936), .Y(n2920) );
  INVX1 U1319 ( .A(RAS_EMPTY), .Y(n2935) );
  XOR2X1 U1320 ( .A(n2937), .B(RAS_0_BA[0]), .Y(n2936) );
  AND2X2 U1321 ( .A(n2954), .B(n2955), .Y(BF_LAST) );
  OR2X1 U1322 ( .A(n2592), .B(n2874), .Y(n2827) );
  INVX1 U1323 ( .A(n2919), .Y(n2870) );
  INVX1 U1324 ( .A(n2920), .Y(n2869) );
  NAND2X1 U1325 ( .A(n2603), .B(n2854), .Y(n2842) );
  NAND2X1 U1326 ( .A(n2875), .B(n2876), .Y(n2843) );
  MXI2X1 U1327 ( .S0(n2870), .B(n2925), .A(n2924), .Y(n2913) );
  AND2X2 U1328 ( .A(n2893), .B(n2614), .Y(n2840) );
  NAND4X1 U1329 ( .A(n2933), .B(n2934), .C(n2757), .D(n2869), .Y(n2919) );
  NOR2X1 U1330 ( .A(n2842), .B(n2843), .Y(BF_REQCMD[0]) );
  AND3X1 U1331 ( .A(n2872), .B(n2825), .C(n2873), .Y(n2844) );
  INVX1 U1332 ( .A(n2633), .Y(n2648) );
  INVX1 U1333 ( .A(BF_CMD[3]), .Y(n2723) );
  INVX1 U1334 ( .A(BF_CMD[2]), .Y(n2722) );
  INVX1 U1335 ( .A(BF_CMD[4]), .Y(n2614) );
  INVX1 U1336 ( .A(n2913), .Y(n2854) );
  NAND3BX1 U1337 ( .AN(n2720), .B(n2622), .C(n2721), .Y(n2633) );
  XOR2X1 U1338 ( .A(BF_CMD[4]), .B(BF_CMD[0]), .Y(n2721) );
  NAND3BX1 U1339 ( .AN(BF_CMD[5]), .B(n2722), .C(n2723), .Y(n2720) );
  NAND3BX1 U1340 ( .AN(n2749), .B(n2740), .C(n2750), .Y(n2649) );
  XOR2X1 U1341 ( .A(BF_CMD[5]), .B(BF_CMD[2]), .Y(n2750) );
  NAND3BX1 U1342 ( .AN(BF_CMD[4]), .B(n2723), .C(n2622), .Y(n2749) );
  NAND3X1 U1343 ( .A(BF_REQCMD[3]), .B(BF_CMD[3]), .C(n2840), .Y(n2612) );
  INVX1 U1344 ( .A(n2957), .Y(n2708) );
  INVX1 U1345 ( .A(BF_CMD[0]), .Y(n2740) );
  DFFSX1 currstate_reg_0_ ( .D(nextstate[0]), .CK(ACLK), .SN(ARESETB), .Q(
        BF_IDLE), .QN(n2814) );
  NOR2X1 U1346 ( .A(n2912), .B(n2913), .Y(BF_REQCMD[4]) );
  NAND3X1 U1347 ( .A(n2636), .B(n2603), .C(n2875), .Y(n2912) );
  INVX1 U1348 ( .A(n2926), .Y(n2603) );
  INVX1 U1349 ( .A(n2872), .Y(n2924) );
  INVX1 U1350 ( .A(BF_TCASBUSY), .Y(n2875) );
  INVX1 U1351 ( .A(n2892), .Y(BF_REQCMD[3]) );
  INVX1 U1352 ( .A(n2894), .Y(BF_REQCMD[2]) );
  INVX1 U1353 ( .A(n2616), .Y(BF_REQCMD[5]) );
  NAND4X1 U1354 ( .A(n2866), .B(n2827), .C(n2867), .D(n2608), .Y(n2865) );
  NAND2X1 U1355 ( .A(n2854), .B(n2856), .Y(n2866) );
  MXI2X1 U1356 ( .S0(n2869), .B(n2868), .A(n2844), .Y(n2867) );
  INVX1 U1357 ( .A(BA_RA[7]), .Y(n2667) );
  INVX1 U1358 ( .A(BA_RA[8]), .Y(n2666) );
  INVX1 U1359 ( .A(BA_RA[10]), .Y(n2689) );
  BUFX2 U1360 ( .A(n2707), .Y(n2957) );
  NAND3BX1 U1361 ( .AN(n2739), .B(n2740), .C(n2741), .Y(n2707) );
  NAND3BX1 U1362 ( .AN(BF_CMD[5]), .B(n2722), .C(n2614), .Y(n2739) );
  XOR2X1 U1363 ( .A(BF_CMD[3]), .B(BF_CMD[1]), .Y(n2741) );
  XOR2X1 U1364 ( .A(n2616), .B(BF_CMD[5]), .Y(n2893) );
  INVX1 U1365 ( .A(n2608), .Y(n2571) );
  OAI33X1 U1366 ( .A0(n2609), .A1(n2610), .A2(n2611), .B0(n2609), .B1(n2612), 
        .B2(n2610), .Y(n2608) );
  XOR2X1 U1367 ( .A(n2894), .B(n2722), .Y(n2610) );
  NAND3X1 U1368 ( .A(n2723), .B(n2892), .C(n2840), .Y(n2611) );
  INVX1 U1369 ( .A(BF_CMD[1]), .Y(n2622) );
  INVX1 U1370 ( .A(BA_RA[2]), .Y(n2693) );
  INVX1 U1371 ( .A(BA_RA[4]), .Y(n2702) );
  AOI2BB1X1 U1372 ( .A0N(n2910), .A1N(length[0]), .B0(n2648), .Y(n2845) );
  INVX1 U1373 ( .A(n2891), .Y(n2627) );
  INVX1 U1374 ( .A(n2624), .Y(n2625) );
  INVX1 U1375 ( .A(n2906), .Y(n2911) );
  INVX1 U1376 ( .A(n2856), .Y(n2855) );
  INVX1 U1377 ( .A(n2900), .Y(n2905) );
  XOR2X1 U1378 ( .A(n2685), .B(BA_BA[1]), .Y(n2684) );
  OAI21X1 U1379 ( .A0(n2921), .A1(n2872), .B0(n2922), .Y(n2874) );
  NOR2X1 U1380 ( .A(n2920), .B(n2925), .Y(n2921) );
  NAND2X1 U1381 ( .A(n2872), .B(n2923), .Y(n2922) );
  NAND4BX1 U1382 ( .AN(n2756), .B(n2848), .C(n2603), .D(n2825), .Y(n2616) );
  NAND4X1 U1383 ( .A(n2938), .B(n2939), .C(n2940), .D(n2941), .Y(n2925) );
  NOR3X1 U1384 ( .A(n2951), .B(n2952), .C(n2953), .Y(n2938) );
  NOR3X1 U1385 ( .A(n2948), .B(n2949), .C(n2950), .Y(n2939) );
  NOR3X1 U1386 ( .A(n2945), .B(n2946), .C(n2947), .Y(n2940) );
  NAND3X1 U1387 ( .A(n2934), .B(n2933), .C(n2757), .Y(n2872) );
  NAND3X1 U1388 ( .A(n2815), .B(n2824), .C(n2816), .Y(n2910) );
  NAND2X1 U1389 ( .A(n2874), .B(n2917), .Y(n2885) );
  NAND2X1 U1390 ( .A(n2918), .B(n2919), .Y(n2917) );
  NOR2X1 U1391 ( .A(n2822), .B(n2920), .Y(n2918) );
  NAND2X1 U1392 ( .A(n2814), .B(cbs_rowopen), .Y(n2926) );
  NAND2X1 U1393 ( .A(n2914), .B(n2860), .Y(n2892) );
  NOR2X1 U1394 ( .A(n2915), .B(n2814), .Y(n2914) );
  INVX1 U1395 ( .A(n2876), .Y(n2636) );
  NAND2X1 U1396 ( .A(n2916), .B(n2885), .Y(n2894) );
  NOR2X1 U1397 ( .A(n2585), .B(n2926), .Y(n2916) );
  INVX1 U1398 ( .A(n2585), .Y(n2592) );
  INVX1 U1399 ( .A(n2890), .Y(n2860) );
  NAND2X1 U1400 ( .A(n2813), .B(n2956), .Y(BF_CASBUSY) );
  INVX1 U1401 ( .A(n2910), .Y(n2956) );
  INVX1 U1402 ( .A(BF_TREADY), .Y(n2756) );
  OAI32X1 U1403 ( .A0(n2637), .A1(n2638), .A2(n2639), .B0(n2822), .B1(n2641), 
        .Y(n2542) );
  INVX1 U1404 ( .A(n2629), .Y(n2638) );
  INVX1 U1405 ( .A(n2642), .Y(n2639) );
  INVX1 U1406 ( .A(n2641), .Y(n2637) );
  INVX1 U1407 ( .A(n2729), .Y(n2727) );
  NAND2BX1 U1408 ( .AN(n2819), .B(n2633), .Y(n2629) );
  NAND2BX1 U1409 ( .AN(n2895), .B(n2896), .Y(n2609) );
  XNOR2X1 U1410 ( .A(BF_REQCMD[0]), .B(BF_CMD[0]), .Y(n2896) );
  XNOR2X1 U1411 ( .A(BF_REQCMD[1]), .B(n2622), .Y(n2895) );
  OAI2BB1X1 U1412 ( .A0N(n2850), .A1N(n2851), .B0(n2852), .Y(nextstate[4]) );
  NOR2X1 U1413 ( .A(BF_LAST), .B(n2837), .Y(n2850) );
  INVX1 U1414 ( .A(n2857), .Y(n2851) );
  NAND4X1 U1415 ( .A(n2853), .B(n2854), .C(n2855), .D(n2608), .Y(n2852) );
  INVX1 U1416 ( .A(n2732), .Y(n2724) );
  NAND2BX1 U1417 ( .AN(n2708), .B(n2585), .Y(n2732) );
  NAND2X1 U1418 ( .A(n2861), .B(n2862), .Y(nextstate[2]) );
  NAND2X1 U1419 ( .A(n2863), .B(n2607), .Y(n2862) );
  NAND2BX1 U1420 ( .AN(n2864), .B(n2865), .Y(n2861) );
  NAND2BX1 U1421 ( .AN(n2819), .B(n2627), .Y(n2624) );
  NAND2X1 U1422 ( .A(n2648), .B(n2876), .Y(n2891) );
  OAI21X1 U1423 ( .A0(n2886), .A1(n2814), .B0(n2887), .Y(nextstate[0]) );
  NOR2X1 U1424 ( .A(n2888), .B(n2889), .Y(n2887) );
  NOR2X1 U1425 ( .A(n2571), .B(n2890), .Y(n2886) );
  NOR2X1 U1426 ( .A(n2820), .B(n2880), .Y(n2888) );
  INVX1 U1427 ( .A(n2742), .Y(n2744) );
  NAND2X1 U1428 ( .A(n2848), .B(BF_TREADY), .Y(n2873) );
  NAND2X1 U1429 ( .A(n2883), .B(n2884), .Y(n2881) );
  NAND2X1 U1430 ( .A(n2885), .B(n2592), .Y(n2883) );
  NAND3X1 U1431 ( .A(n2848), .B(n2825), .C(BF_TREADY), .Y(n2884) );
  DFFRX1 currstate_reg_3_ ( .D(nextstate[3]), .CK(ACLK), .RN(ARESETB), .Q(
        cbs_rasing), .QN(n2828) );
  NAND2X1 U1432 ( .A(n2820), .B(n2814), .Y(n2574) );
  NAND3X1 U1433 ( .A(n2819), .B(n2828), .C(n2607), .Y(n2857) );
  INVX1 U1434 ( .A(n2574), .Y(n2607) );
  NOR2X1 U1435 ( .A(n2870), .B(n2871), .Y(n2868) );
  NOR2X1 U1436 ( .A(n2822), .B(n2585), .Y(n2871) );
  NAND3X1 U1437 ( .A(n2816), .B(n2815), .C(n2813), .Y(n2906) );
  NAND2X1 U1438 ( .A(n2875), .B(n2876), .Y(n2856) );
  NAND2X1 U1439 ( .A(n2813), .B(n2816), .Y(n2900) );
  INVX1 U1440 ( .A(n2864), .Y(n2853) );
  XOR2X1 U1441 ( .A(n2937), .B(CAS_0_BA[0]), .Y(n2933) );
  XOR2X1 U1442 ( .A(n2685), .B(CAS_0_BA[1]), .Y(n2934) );
  AO21X1 U1443 ( .A0(n2592), .A1(cbs_rowopen), .B0(BF_IDLE), .Y(BF_READY) );
  XOR2X1 U1444 ( .A(RAS_0_RA[1]), .B(CAS_0_RA[1]), .Y(n2947) );
  XOR2X1 U1445 ( .A(RAS_0_RA[4]), .B(CAS_0_RA[4]), .Y(n2950) );
  XOR2X1 U1446 ( .A(RAS_0_RA[7]), .B(CAS_0_RA[7]), .Y(n2953) );
  NOR3X1 U1447 ( .A(n2942), .B(n2943), .C(n2944), .Y(n2941) );
  XOR2X1 U1448 ( .A(RAS_0_RA[10]), .B(CAS_0_RA[10]), .Y(n2942) );
  XOR2X1 U1449 ( .A(RAS_0_RA[11]), .B(CAS_0_RA[11]), .Y(n2943) );
  XOR2X1 U1450 ( .A(RAS_0_RA[0]), .B(CAS_0_RA[0]), .Y(n2944) );
  XOR2X1 U1451 ( .A(RAS_0_RA[2]), .B(CAS_0_RA[2]), .Y(n2945) );
  XOR2X1 U1452 ( .A(RAS_0_RA[5]), .B(CAS_0_RA[5]), .Y(n2948) );
  XOR2X1 U1453 ( .A(RAS_0_RA[8]), .B(CAS_0_RA[8]), .Y(n2951) );
  XOR2X1 U1454 ( .A(RAS_0_RA[3]), .B(CAS_0_RA[3]), .Y(n2946) );
  XOR2X1 U1455 ( .A(RAS_0_RA[6]), .B(CAS_0_RA[6]), .Y(n2949) );
  XOR2X1 U1456 ( .A(RAS_0_RA[9]), .B(CAS_0_RA[9]), .Y(n2952) );
  XNOR2X1 U1457 ( .A(n2685), .B(RAS_0_BA[1]), .Y(n2846) );
  NAND4BX1 U1458 ( .AN(n2655), .B(n2656), .C(n2657), .D(n2658), .Y(n2642) );
  OAI221X1 U1459 ( .A0(BA_RA[4]), .A1(n2832), .B0(LAST_RA[4]), .B1(n2702), 
        .C0(n2703), .Y(n2655) );
  AOI221X1 U1460 ( .A0(BA_RA[6]), .A1(n2697), .B0(openedrow[7]), .B1(n2667), 
        .C0(n2698), .Y(n2656) );
  AND4X1 U1461 ( .A(n2659), .B(n2660), .C(n2661), .D(n2662), .Y(n2658) );
  NAND2X1 U1462 ( .A(n2931), .B(n2932), .Y(n2876) );
  NOR2X1 U1463 ( .A(CAS_0_TT[1]), .B(CAS_0_TT[0]), .Y(n2931) );
  NOR2X1 U1464 ( .A(CAS_0_TT[3]), .B(CAS_0_TT[2]), .Y(n2932) );
  OR2X1 U1465 ( .A(trasmin_cnt[0]), .B(trasmin_cnt[1]), .Y(n2729) );
  NAND2X1 U1466 ( .A(n2847), .B(net2407), .Y(n2585) );
  NAND2X1 U1467 ( .A(n2823), .B(net2432), .Y(BF_RASBUSY) );
  INVX1 U1468 ( .A(CAS_EMPTY), .Y(n2757) );
  OAI32X1 U1469 ( .A0(n2751), .A1(n2752), .A2(n2753), .B0(ERCMD[5]), .B1(n2754), .Y(n2654) );
  INVX1 U1470 ( .A(ERCMD[1]), .Y(n2754) );
  OR3X2 U1471 ( .A(ECMD[4]), .B(ECMD[6]), .C(ERCMD[1]), .Y(n2752) );
  OR2X1 U1472 ( .A(ECMD[3]), .B(ECMD[2]), .Y(n2753) );
  NOR2X1 U1473 ( .A(n2890), .B(n2927), .Y(BF_REQCMD[1]) );
  NAND2X1 U1474 ( .A(n2915), .B(BF_IDLE), .Y(n2927) );
  NAND2X1 U1475 ( .A(n2930), .B(n2869), .Y(n2890) );
  NOR3X1 U1476 ( .A(BF_TRASBUSY), .B(trp_cnt[1]), .C(trp_cnt[0]), .Y(n2930) );
  OAI211X1 U1477 ( .A0(n2643), .A1(n2633), .B0(n2642), .C0(n2644), .Y(n2641)
         );
  NAND3BX1 U1478 ( .AN(n2706), .B(cbs_rowopen), .C(n2636), .Y(n2643) );
  OA22X1 U1479 ( .A0(n2581), .A1(n2839), .B0(n2634), .B1(n2819), .Y(n2644) );
  INVX1 U1480 ( .A(CAS_0_FINAL), .Y(n2706) );
  INVX1 U1481 ( .A(n2646), .Y(n2634) );
  OAI31X1 U1482 ( .A0(n2647), .A1(ERCMD[0]), .A2(n2648), .B0(n2649), .Y(n2646)
         );
  NAND4BX1 U1483 ( .AN(n2650), .B(n2651), .C(n2652), .D(n2653), .Y(n2647) );
  INVX1 U1484 ( .A(n2654), .Y(n2650) );
  NAND2X1 U1485 ( .A(n2928), .B(n2929), .Y(n2915) );
  NOR2X1 U1486 ( .A(RAS_0_TT[1]), .B(RAS_0_TT[0]), .Y(n2928) );
  NOR2X1 U1487 ( .A(RAS_0_TT[3]), .B(RAS_0_TT[2]), .Y(n2929) );
  NAND4BBX1 U1488 ( .AN(ECMD[1]), .BN(ECMD[0]), .C(ERCMD[5]), .D(ECMD[5]), .Y(
        n2751) );
  NOR2BX1 U1489 ( .AN(n2686), .B(n2687), .Y(n2657) );
  OAI221X1 U1490 ( .A0(BA_RA[10]), .A1(n2833), .B0(LAST_RA[10]), .B1(n2689), 
        .C0(n2690), .Y(n2687) );
  AOI221X1 U1491 ( .A0(BA_RA[1]), .A1(n2692), .B0(openedrow[2]), .B1(n2693), 
        .C0(n2694), .Y(n2686) );
  NAND2X1 U1492 ( .A(newrowexist), .B(n2920), .Y(n2923) );
  AND2X2 U1493 ( .A(n2727), .B(net2408), .Y(n2847) );
  AOI221X1 U1494 ( .A0(LAST_RA[8]), .A1(n2817), .B0(LAST_RA[9]), .B1(n2831), 
        .C0(n2682), .Y(n2659) );
  NAND3BX1 U1495 ( .AN(n2683), .B(n2684), .C(BA_REQ), .Y(n2682) );
  XOR2X1 U1496 ( .A(BF_NO[0]), .B(BA_BA[0]), .Y(n2683) );
  OAI222X1 U1497 ( .A0(LAST_RA[11]), .A1(n2695), .B0(BA_RA[11]), .B1(n2826), 
        .C0(BA_RA[1]), .C1(n2818), .Y(n2694) );
  INVX1 U1498 ( .A(BA_RA[11]), .Y(n2695) );
  NOR2BX1 U1499 ( .AN(RAS_EMPTY), .B(n2757), .Y(n2848) );
  OAI2BB1X1 U1500 ( .A0N(TRASMIN[2]), .A1N(n2708), .B0(n2728), .Y(n2523) );
  AOI32X1 U1501 ( .A0(trasmin_cnt[2]), .A1(n2729), .A2(n2724), .B0(n2724), 
        .B1(n2847), .Y(n2728) );
  OAI2BB1X1 U1502 ( .A0N(TRASMIN[1]), .A1N(n2708), .B0(n2726), .Y(n2524) );
  AOI32X1 U1503 ( .A0(trasmin_cnt[0]), .A1(trasmin_cnt[1]), .A2(n2724), .B0(
        n2724), .B1(n2727), .Y(n2726) );
  OAI2BB1X1 U1504 ( .A0N(n2858), .A1N(n2577), .B0(n2859), .Y(nextstate[3]) );
  NOR2X1 U1505 ( .A(n2828), .B(n2574), .Y(n2858) );
  NAND3X1 U1506 ( .A(n2860), .B(BF_IDLE), .C(n2608), .Y(n2859) );
  AO22X1 U1507 ( .A0(n2628), .A1(newrowexist), .B0(n2629), .B1(n2630), .Y(
        n2543) );
  INVX1 U1508 ( .A(n2630), .Y(n2628) );
  OAI222X1 U1509 ( .A0(n2581), .A1(n2835), .B0(n2632), .B1(n2633), .C0(n2634), 
        .C1(n2819), .Y(n2630) );
  AOI221X1 U1510 ( .A0(openedrow[9]), .A1(n2663), .B0(BA_RA[9]), .B1(n2664), 
        .C0(n2665), .Y(n2662) );
  INVX1 U1511 ( .A(LAST_RA[9]), .Y(n2664) );
  INVX1 U1512 ( .A(BA_RA[9]), .Y(n2663) );
  OAI222X1 U1513 ( .A0(LAST_RA[8]), .A1(n2666), .B0(LAST_RA[7]), .B1(n2667), 
        .C0(BA_RA[8]), .C1(n2817), .Y(n2665) );
  NAND2X1 U1514 ( .A(n2877), .B(n2878), .Y(nextstate[1]) );
  NAND2X1 U1515 ( .A(n2879), .B(n2880), .Y(n2878) );
  NAND3X1 U1516 ( .A(n2881), .B(n2853), .C(n2608), .Y(n2877) );
  NOR2X1 U1517 ( .A(BF_IDLE), .B(n2820), .Y(n2879) );
  AO21X1 U1518 ( .A0(n2747), .A1(n2654), .B0(n2748), .Y(n2742) );
  AND4X1 U1519 ( .A(n2755), .B(n2652), .C(n2653), .D(n2651), .Y(n2747) );
  INVX1 U1520 ( .A(n2649), .Y(n2748) );
  INVX1 U1521 ( .A(ERCMD[0]), .Y(n2755) );
  OAI21X1 U1522 ( .A0(n2891), .A1(n2907), .B0(n2908), .Y(n2526) );
  INVX1 U1523 ( .A(CAS_0_TT[3]), .Y(n2907) );
  NAND2X1 U1524 ( .A(n2909), .B(n2845), .Y(n2908) );
  NOR2X1 U1525 ( .A(n2911), .B(n2824), .Y(n2909) );
  OAI21X1 U1526 ( .A0(n2891), .A1(n2897), .B0(n2898), .Y(n2528) );
  INVX1 U1527 ( .A(CAS_0_TT[1]), .Y(n2897) );
  NAND2X1 U1528 ( .A(n2845), .B(n2899), .Y(n2898) );
  NAND2X1 U1529 ( .A(n2900), .B(n2901), .Y(n2899) );
  OAI21X1 U1530 ( .A0(n2891), .A1(n2902), .B0(n2903), .Y(n2527) );
  INVX1 U1531 ( .A(CAS_0_TT[2]), .Y(n2902) );
  NAND2X1 U1532 ( .A(n2845), .B(n2904), .Y(n2903) );
  OAI21X1 U1533 ( .A0(n2905), .A1(n2815), .B0(n2906), .Y(n2904) );
  AO22X1 U1534 ( .A0(cas_0_newrow_l), .A1(n2624), .B0(CAS_0_NEWROW), .B1(n2625), .Y(n2545) );
  AO22X1 U1535 ( .A0(cas_0_final_l), .A1(n2624), .B0(CAS_0_FINAL), .B1(n2625), 
        .Y(n2544) );
  AO22X1 U1536 ( .A0(n2845), .A1(n2813), .B0(CAS_0_TT[0]), .B1(n2627), .Y(
        n2529) );
  AO22X1 U1537 ( .A0(openedrow[6]), .A1(n2957), .B0(n2708), .B1(RAS_0_RA[6]), 
        .Y(n2535) );
  AO22X1 U1538 ( .A0(openedrow[5]), .A1(n2957), .B0(n2708), .B1(RAS_0_RA[5]), 
        .Y(n2536) );
  AO22X1 U1539 ( .A0(openedrow[4]), .A1(n2957), .B0(n2708), .B1(RAS_0_RA[4]), 
        .Y(n2537) );
  AO22X1 U1540 ( .A0(openedrow[7]), .A1(n2957), .B0(n2708), .B1(RAS_0_RA[7]), 
        .Y(n2534) );
  AO22X1 U1541 ( .A0(openedrow[3]), .A1(n2957), .B0(n2708), .B1(RAS_0_RA[3]), 
        .Y(n2538) );
  AO22X1 U1542 ( .A0(TRASMIN[0]), .A1(n2708), .B0(n2724), .B1(n2838), .Y(n2525) );
  AO22X1 U1543 ( .A0(openedrow[11]), .A1(n2957), .B0(n2708), .B1(RAS_0_RA[11]), 
        .Y(n2530) );
  AO22X1 U1544 ( .A0(openedrow[9]), .A1(n2957), .B0(n2708), .B1(RAS_0_RA[9]), 
        .Y(n2532) );
  AO22X1 U1545 ( .A0(TRRD[1]), .A1(n2708), .B0(n2737), .B1(n2957), .Y(n2518)
         );
  NOR2BX1 U1546 ( .AN(trrd_cnt_1_), .B(n2823), .Y(n2737) );
  AO22X1 U1547 ( .A0(TRCD[1]), .A1(n2708), .B0(n2734), .B1(n2957), .Y(n2520)
         );
  NOR2BX1 U1548 ( .AN(trcd_cnt[0]), .B(n2836), .Y(n2734) );
  AO22X1 U1549 ( .A0(TRASMIN[3]), .A1(n2708), .B0(n2731), .B1(n2724), .Y(n2522) );
  NOR2BX1 U1550 ( .AN(trasmin_cnt[3]), .B(n2847), .Y(n2731) );
  AO22X1 U1551 ( .A0(TRCD[0]), .A1(n2708), .B0(n2733), .B1(n2957), .Y(n2521)
         );
  NOR2BX1 U1552 ( .AN(trcd_cnt[1]), .B(trcd_cnt[0]), .Y(n2733) );
  AO22X1 U1553 ( .A0(TRP[1]), .A1(n2742), .B0(n2745), .B1(n2744), .Y(n2516) );
  NOR2BX1 U1554 ( .AN(trp_cnt[1]), .B(n2849), .Y(n2745) );
  AO22X1 U1555 ( .A0(TRP[0]), .A1(n2742), .B0(n2743), .B1(n2744), .Y(n2517) );
  NOR2BX1 U1556 ( .AN(trp_cnt[1]), .B(trp_cnt[0]), .Y(n2743) );
  AO22X1 U1557 ( .A0(TRRD[0]), .A1(n2708), .B0(n2736), .B1(n2957), .Y(n2519)
         );
  NOR2BX1 U1558 ( .AN(trrd_cnt_1_), .B(trrd_cnt_0_), .Y(n2736) );
  OAI222X1 U1559 ( .A0(LAST_RA[5]), .A1(n2699), .B0(BA_RA[5]), .B1(n2834), 
        .C0(BA_RA[6]), .C1(n2821), .Y(n2698) );
  INVX1 U1560 ( .A(BA_RA[5]), .Y(n2699) );
  AOI222X1 U1561 ( .A0(openedrow[3]), .A1(n2704), .B0(BA_RA[2]), .B1(n2705), 
        .C0(BA_RA[3]), .C1(n2679), .Y(n2703) );
  INVX1 U1562 ( .A(LAST_RA[2]), .Y(n2705) );
  INVX1 U1563 ( .A(BA_RA[3]), .Y(n2704) );
  AOI221X1 U1564 ( .A0(openedrow[0]), .A1(n2691), .B0(BA_RA[0]), .B1(n2673), 
        .C0(LAST_RA[12]), .Y(n2690) );
  INVX1 U1565 ( .A(BA_RA[0]), .Y(n2691) );
  NAND3BX1 U1566 ( .AN(cbs_rowopen), .B(cbs_casing), .C(BF_LAST), .Y(n2581) );
  INVX1 U1567 ( .A(ERCMD[2]), .Y(n2652) );
  INVX1 U1568 ( .A(ERCMD[3]), .Y(n2653) );
  INVX1 U1569 ( .A(ERCMD[4]), .Y(n2651) );
  NAND3X1 U1570 ( .A(CAS_0_NEWROW), .B(cbs_rowopen), .C(n2636), .Y(n2632) );
  NOR2X1 U1571 ( .A(n2813), .B(length[3]), .Y(n2955) );
  NOR2X1 U1572 ( .A(length[2]), .B(length[1]), .Y(n2954) );
  AOI221X1 U1573 ( .A0(LAST_RA[1]), .A1(n2818), .B0(LAST_RA[2]), .B1(n2829), 
        .C0(n2671), .Y(n2661) );
  OAI222X1 U1574 ( .A0(openedrow[10]), .A1(n2672), .B0(openedrow[0]), .B1(
        n2673), .C0(openedrow[11]), .C1(n2674), .Y(n2671) );
  INVX1 U1575 ( .A(LAST_RA[11]), .Y(n2674) );
  AOI221X1 U1576 ( .A0(LAST_RA[6]), .A1(n2821), .B0(LAST_RA[7]), .B1(n2830), 
        .C0(n2677), .Y(n2660) );
  OAI222X1 U1577 ( .A0(openedrow[4]), .A1(n2678), .B0(openedrow[3]), .B1(n2679), .C0(openedrow[5]), .C1(n2680), .Y(n2677) );
  INVX1 U1578 ( .A(LAST_RA[5]), .Y(n2680) );
  INVX1 U1579 ( .A(LAST_RA[0]), .Y(n2673) );
  INVX1 U1580 ( .A(LAST_RA[3]), .Y(n2679) );
  INVX1 U1581 ( .A(LAST_RA[1]), .Y(n2692) );
  INVX1 U1582 ( .A(LAST_RA[6]), .Y(n2697) );
  INVX1 U1583 ( .A(LAST_RA[10]), .Y(n2672) );
  INVX1 U1584 ( .A(LAST_RA[4]), .Y(n2678) );
  MXI2X1 U1585 ( .S0(cbs_rasing), .B(n2577), .A(n2581), .Y(n2863) );
  OR2X1 U1586 ( .A(n2849), .B(trp_cnt[1]), .Y(n2880) );
  NOR2X1 U1587 ( .A(cbs_casing), .B(n2857), .Y(n2889) );
  NAND2X1 U1588 ( .A(length[1]), .B(length[0]), .Y(n2901) );
  NAND2X1 U1589 ( .A(n2882), .B(n2603), .Y(n2864) );
  NOR2X1 U1590 ( .A(cbs_rasing), .B(cbs_pcing), .Y(n2882) );
  NAND2BX1 U1591 ( .AN(trcd_cnt[1]), .B(trcd_cnt[0]), .Y(n2577) );
  INVX1 U1592 ( .A(BF_NO[1]), .Y(n2685) );
  INVX1 U1593 ( .A(BF_NO[0]), .Y(n2937) );
  DFFRX1 trp_cnt_reg_0_ ( .D(n2517), .CK(ACLK), .RN(ARESETB), .Q(trp_cnt[0]), 
        .QN(n2849) );
  DFFRX1 length_reg_1_ ( .D(n2528), .CK(ACLK), .RN(ARESETB), .Q(length[1]), 
        .QN(n2816) );
  DFFRX1 currstate_reg_2_ ( .D(nextstate[2]), .CK(ACLK), .RN(ARESETB), .Q(
        cbs_rowopen), .QN(n2819) );
  DFFRX1 trp_cnt_reg_1_ ( .D(n2516), .CK(ACLK), .RN(ARESETB), .Q(trp_cnt[1])
         );
  DFFRX1 newrowexist_reg ( .D(n2543), .CK(ACLK), .RN(ARESETB), .Q(newrowexist), 
        .QN(n2825) );
  DFFRX1 length_reg_2_ ( .D(n2527), .CK(ACLK), .RN(ARESETB), .Q(length[2]), 
        .QN(n2815) );
  DFFRX1 length_reg_3_ ( .D(n2526), .CK(ACLK), .RN(ARESETB), .Q(length[3]), 
        .QN(n2824) );
  DFFRX1 trrd_cnt_reg_0_ ( .D(n2519), .CK(ACLK), .RN(ARESETB), .Q(trrd_cnt_0_), 
        .QN(n2823) );
  DFFRX1 trasmin_cnt_reg_0_ ( .D(n2525), .CK(ACLK), .RN(ARESETB), .Q(
        trasmin_cnt[0]), .QN(n2838) );
  DFFRX1 trasmin_cnt_reg_1_ ( .D(n2524), .CK(ACLK), .RN(ARESETB), .Q(
        trasmin_cnt[1]) );
  DFFRX1 length_reg_0_ ( .D(n2529), .CK(ACLK), .RN(ARESETB), .Q(length[0]), 
        .QN(n2813) );
  DFFRX1 trrd_cnt_reg_1_ ( .D(n2518), .CK(ACLK), .RN(ARESETB), .Q(trrd_cnt_1_), 
        .QN(net2432) );
  DFFRX1 trasmin_cnt_reg_3_ ( .D(n2522), .CK(ACLK), .RN(ARESETB), .Q(
        trasmin_cnt[3]), .QN(net2407) );
  DFFRX1 trasmin_cnt_reg_2_ ( .D(n2523), .CK(ACLK), .RN(ARESETB), .Q(
        trasmin_cnt[2]), .QN(net2408) );
  DFFRX1 newrowenable_reg ( .D(n2542), .CK(ACLK), .RN(ARESETB), .QN(n2822) );
  DFFRX1 openedrow_reg_11_ ( .D(n2530), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[11]), .QN(n2826) );
  DFFRX1 openedrow_reg_5_ ( .D(n2536), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[5]), .QN(n2834) );
  DFFRX1 openedrow_reg_9_ ( .D(n2532), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[9]), .QN(n2831) );
  DFFRX1 openedrow_reg_7_ ( .D(n2534), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[7]), .QN(n2830) );
  DFFRX1 openedrow_reg_4_ ( .D(n2537), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[4]), .QN(n2832) );
  DFFRX1 openedrow_reg_6_ ( .D(n2535), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[6]), .QN(n2821) );
  DFFRX1 openedrow_reg_2_ ( .D(n2539), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[2]), .QN(n2829) );
  DFFRX1 openedrow_reg_10_ ( .D(n2531), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[10]), .QN(n2833) );
  DFFRX1 openedrow_reg_8_ ( .D(n2533), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[8]), .QN(n2817) );
  DFFRX1 openedrow_reg_1_ ( .D(n2540), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[1]), .QN(n2818) );
  DFFRX1 openedrow_reg_3_ ( .D(n2538), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[3]) );
  DFFRX1 openedrow_reg_0_ ( .D(n2541), .CK(ACLK), .RN(ARESETB), .Q(
        openedrow[0]) );
  DFFRX1 currstate_reg_4_ ( .D(nextstate[4]), .CK(ACLK), .RN(ARESETB), .Q(
        cbs_casing), .QN(n2837) );
  DFFRX1 currstate_reg_1_ ( .D(nextstate[1]), .CK(ACLK), .RN(ARESETB), .Q(
        cbs_pcing), .QN(n2820) );
  DFFRX1 trcd_cnt_reg_1_ ( .D(n2520), .CK(ACLK), .RN(ARESETB), .Q(trcd_cnt[1]), 
        .QN(n2836) );
  DFFRX1 cas_0_final_l_reg ( .D(n2544), .CK(ACLK), .RN(ARESETB), .Q(
        cas_0_final_l), .QN(n2839) );
  DFFRX1 cas_0_newrow_l_reg ( .D(n2545), .CK(ACLK), .RN(ARESETB), .Q(
        cas_0_newrow_l), .QN(n2835) );
  DFFRX1 trcd_cnt_reg_0_ ( .D(n2521), .CK(ACLK), .RN(ARESETB), .Q(trcd_cnt[0])
         );
  AO22X1 U1594 ( .A0(openedrow[8]), .A1(n2957), .B0(n2708), .B1(RAS_0_RA[8]), 
        .Y(n2533) );
  AO22X1 U1595 ( .A0(openedrow[0]), .A1(n2957), .B0(n2708), .B1(RAS_0_RA[0]), 
        .Y(n2541) );
  AO22X1 U1596 ( .A0(openedrow[10]), .A1(n2957), .B0(n2708), .B1(RAS_0_RA[10]), 
        .Y(n2531) );
  AO22X1 U1597 ( .A0(openedrow[1]), .A1(n2957), .B0(n2708), .B1(RAS_0_RA[1]), 
        .Y(n2540) );
  AO22X1 U1598 ( .A0(openedrow[2]), .A1(n2957), .B0(n2708), .B1(RAS_0_RA[2]), 
        .Y(n2539) );
endmodule


module SDRRas ( ARESETB, ACLK, BA_BA, BA_RA, BA_TT, BA_REQ, CMD, CLOSING, 
        B0_LAST_RA, B1_LAST_RA, B2_LAST_RA, B3_LAST_RA, RAS_0_BA, RAS_0_RA, 
        RAS_0_TT, RAS_EMPTY, RAS_HEMPTY, RAS_FULL );
  input [1:0] BA_BA;
  input [11:0] BA_RA;
  input [3:0] BA_TT;
  input [5:0] CMD;
  output [12:0] B0_LAST_RA;
  output [12:0] B1_LAST_RA;
  output [12:0] B2_LAST_RA;
  output [12:0] B3_LAST_RA;
  output [1:0] RAS_0_BA;
  output [11:0] RAS_0_RA;
  output [3:0] RAS_0_TT;
  input ARESETB, ACLK, BA_REQ, CLOSING;
  output RAS_EMPTY, RAS_HEMPTY, RAS_FULL;
  wire   n137_3_, n137_2_, n137_1_, n137_0_, n206_4_, n206_3_, n206_2_,
         n206_1_, n206_0_, RAS_EMPTY471, RAS_HEMPTY479, RAS_FULL486,
         ras_cnt_4_, ras_cnt_3_, ras_cnt_2_, ras_cnt_1_, ras_cnt_0_,
         ras_cnt822_3_, ras_cnt822_2_, ras_cnt822_1_, ras_cnt865_4_,
         ras_cnt865_3_, ras_cnt865_2_, ras_cnt865_1_, n1433, n1434, n1435,
         n1436, n1437, n1438, n1439, n1440, n1441, n1442, n1443, n1444, n1445,
         n1446, n1447, n1448, n1449, n1450, n1451, n1452, n1453, n1454, n1455,
         n1456, n1457, n1458, n1459, n1460, n1461, n1462, n1463, n1464, n1465,
         n1466, n1467, n1468, n1469, n1470, n1471, n1472, n1473, n1474, n1475,
         n1476, n1477, n1478, n1479, n1480, n1481, n1482, n1483, n1484, n1485,
         n1486, n1487, n1488, n1489, n1490, n1491, n1492, n1493, n1494, n1495,
         n1496, n1497, n1498, n1499, n1500, n1501, n1502, n1503, n1504, n1505,
         n1506, n1507, n1508, n1509, n1510, n1511, n1512, n1513, n1514, n1515,
         n1516, n1517, n1518, n1519, n1520, n1521, n1522, n1523, n1524, n1525,
         n1526, n1527, n1528, n1529, n1530, n1531, n1532, n1533, n1534, n1535,
         n1536, n1537, n1538, n1539, n1540, n1541, n1542, n1543, n1544, n1545,
         n1546, n1547, n1548, n1549, n1550, n1551, n1552, n1553, n1554, n1555,
         n1556, n1557, n1558, n1559, n1560, n1561, n1562, n1563, n1564, n1565,
         n1566, n1567, n1568, n1569, n1570, n1571, n1572, n1573, n1574, n1575,
         n1576, n1577, n1578, n1579, n1580, n1581, n1582, n1583, n1584, n1585,
         n1586, n1587, n1588, n1589, n1590, n1591, n1592, n1593, n1594, n1595,
         n1596, n1597, n1598, n1599, n1600, n1601, n1602, n1603, n1604, n1605,
         n1606, n1607, n1608, n1609, n1610, n1611, n1612, n1613, n1614, n1615,
         n1616, n1617, n1618, n1619, n1620, n1621, n1622, n1623, n1624, n1625,
         n1626, n1627, n1628, n1629, n1630, n1631, n1632, n1633, n1634, n1635,
         n1636, n1637, n1638, n1639, n1640, n1641, n1642, n1643, n1644, n1645,
         n1646, carry, carry0, carry_3_, carry_2_, n1, n2, n3, n2567, n2568,
         n2569, n2570, n2571, n2572, n2573, n2574, n2575, n2576, n2577, n2578,
         n2579, n2580, n2581, n2582, n2583, n2584, n2585, n2586, n2587, n2588,
         n2589, n2590, n2591, n2592, n2593, n2594, n2595, n2596, n2597, n2598,
         n2599, n2600, n2601, n2602, n2603, n2604, n2605, n2606, n2607, n2608,
         n2609, n2610, n2611, n2612, n2613, n2614, n2615, n2616, n2617, n2618,
         n2619, n2620, n2621, n2622, n2623, n2624, n2625, n2626, n2627, n2628,
         n2629, n2630, n2631, n2632, n2633, n2634, n2635, n2636, n2637, n2638,
         n2639, n2640, n2641, n2642, n2643, n2644, n2645, n2646, n2647, n2648,
         n2649, n2650, n2651, n2652, n2653, n2654, n2655, n2656, n2657, n2658,
         n2659, n2660, n2661, n2662, n2663, n2664, n2665, n2666, n2667, n2668,
         n2669, n2670, n2671, n2672, n2673, n2674, n2675, n2676, n2677, n2678,
         n2679, n2680, n2681, n2682, n2683, n2684, n2685, n2686, n2687, n2688,
         n2689, n2690, n2691, n2692, n2693, n2694, n2695, n2696, n2697, n2698,
         n2699, n2700, n2701, n2702, n2703, n2704, n2705, n2706, n2707, n2708,
         n2709, n2710, n2711, n2712, n2713, n2714, n2715, n2716, n2717, n2718,
         n2719, n2720, n2721, n2722, n2723, n2724, n2725, n2726, n2727, n2728,
         n2729, n2730, n2731, n2732, n2733, n2734, n2735, n2736, n2737, n2738,
         n2739, n2740, n2741, n2742, n2743, n2744, n2745, n2746, n2747, n2748,
         n2749, n2750, n2751, n2752, n2753, n2754, n2755, n2756, n2757, n2758,
         n2759, n2760, n2761, n2762, n2763, n2764, n2765, n2766, n2767, n2768,
         n2769, n2770, n2771, n2772, n2773, n2774, n2775, n2776, n2777, n2778,
         n2779, n2780, n2781, n2782, n2783, n2784, n2785, n2786, n2787, n2788,
         n2789, n2790, n2791, n2792, n2793, n2794, n2795, n2796, n2797, n2798,
         n2799, n2800, n2801, n2802, n2803, n2804, n2805, n2806, n2807, n2808,
         n2809, n2810, n2811, n2812, n2813, n2814, n2815, n2816, n2817, n2818,
         n2819, n2820, n2821, n2822, n2823, n2824, n2825, n2826, n2827, n2828,
         n2829, n2830, n2831, n2832, n2833, n2834, n2835, n2836, n2837, n2838,
         n2839, n2840, n2841, n2842, n2843, n2844, n2845, n2846, n2847, n2848,
         n2849, n2850, n2851, n2852, n2853, n2854, n2855, n2856, n2857, n2858,
         n2859, n2860, n2861, n2862, n2863, n2864, n2865, n2866, n2867, n2868,
         n2869, n2870, n2871, n2872, n2873, n2874, n2875, n2876, n2877, n2878,
         n2879, n2880, n2881, n2882, n2883, n2884, n2885, n2886, n2887, n2888,
         n2889, n2890, n2891, n2892, n2893, n2894, n2895, n2896, n2897, n2898,
         n2899, n2900, n2901, n2902, n2903, n2904, n2905, n2906, n2907, n2908,
         n2909, n2910, n2911, n2912, n2913, n2914, n2915, n2916, n2917, n2918,
         n2919, n2920, n2921, n2922, n2923, n2924, n2925, n2926, n2927, n2928,
         n2929, n2930, n2931, n2932, n2933, n2934, n2935, n2936, n2937, n2938,
         n2939, n2940, n2941, n2942, n2943, n2944, n2945, n2946, n2947, n2948,
         n2949, n2950, n2951, n2952, n2953, n2954, n2955, n2956, n2957, n2958,
         n2959, n2960, n2961, n2962, n2963, n2964, n2965, n2966, n2967, n2968,
         n2969, n2970, n2971, n2972, n2973, n2974, n2975, n2976, n2977, n2978,
         n2979, n2980, n2981, n2982, n2983, n2984, n2985, n2986, n2987, n2988,
         n2989, n2990, n2991, n2992, n2993, n2994, n2995, n2996, n2997, n2998,
         n2999, n3000, n3001, n3002, n3003, n3004, n3005, n3006, n3007, n3008,
         n3009, n3010, n3011, n3012, n3013, n3014, n3015, n3016, n3017, n3018,
         n3019, n3020, n3021, n3022, n3023, n3024, n3025, n3026, n3027, n3028,
         n3029, n3030, n3031, n3032, n3033, n3034, n3035, n3036, n3037, n3038,
         n3039, n3040, n3041, n3042, n3043, n3044, n3045, n3046, n3047, n3048,
         n3049, n3050, n3051, n3052, n3053, n3054, n3055, n3056, n3057, n3058,
         n3059, n3060, n3061, n3062, n3063, n3064, n3065, n3066, n3067, n3068,
         n3069, n3070, n3071, n3072, n3073, n3074, n3075, n3076, n3077, n3078,
         n3079, n3080, n3081, n3082, n3083, n3084, n3085, n3086, n3087, n3088,
         n3089, n3090, n3091, n3092, n3093, n3094, n3095, n3096, n3097, n3098,
         n3099, n3100, n3101, n3102, n3103, n3104, n3105, n3106, n3107, n3108,
         n3109, n3110, n3111, n3112, n3113, n3114, n3115, n3116, n3117, n3118,
         n3119, n3120, n3121, n3122, n3123, n3124, n3125, n3126, n3127, n3128,
         n3129, n3130, n3131, n3132, n3133, n3134, n3135, n3136, n3137, n3138,
         n3139, n3140, n3141, n3142, n3143, n3144, n3145, n3146, n3147, n3148,
         n3149, n3150, n3151, n3152, n3153, n3154, n3155, n3156, n3157, n3158,
         n3159, n3160, n3161, n3162, n3163, n3164, n3165, n3166, n3167, n3168,
         n3169, n3170, n3171, n3172, n3173, n3174, n3175, n3176, n3177, n3178,
         n3179, n3180, n3181, n3182, n3183, n3184, n3185, n3186, n3187, n3188,
         n3189, n3190, n3191, n3192, n3193, n3194, n3195, n3196, n3197, n3198,
         n3199, n3200, n3201, n3202, n3203, n3204, n3205, n3206, n3207, n3208,
         n3209, n3210, n3211, n3212, n3213, n3214, n3215, n3216, n3217, n3218,
         n3219, n3220, n3221, n3222, n3223, n3224, n3225, n3226, n3227, n3228,
         n3229, n3230, n3231, n3232, n3233, n3234, n3235, n3236, n3237,
         net3218, net3217, net3216, net3215, net3214, net3213, net3212,
         net3211, net3210, net3209, net3208, net3207, net3206, net3205,
         net3204, net3203, net3202, net3201, net3200, net3199, net3198,
         net3197, net3196, net3195, net3194, net3192, net3191, net3190,
         net3189, net3188, net3187, net3186, net3185, net3184, net3183,
         net3182, net3181, net3180, net3179, net3178, net3177, net3176,
         net3175, net3174, net3173, net3172, net3171, net3170, net3169,
         net3168, net3167;

  DFFSX4 RAS_EMPTY_reg ( .D(RAS_EMPTY471), .CK(ACLK), .SN(ARESETB), .Q(
        RAS_EMPTY) );
  DFFRX4 RAS_0_BA_reg_0_ ( .D(n1504), .CK(ACLK), .RN(ARESETB), .Q(RAS_0_BA[0]), 
        .QN(n1433) );
  DFFRX4 RAS_0_BA_reg_1_ ( .D(n1503), .CK(ACLK), .RN(ARESETB), .Q(RAS_0_BA[1]), 
        .QN(n1434) );
  AHHCONX2 U1_1_2 ( .A(n137_2_), .CI(carry_2_), .S(ras_cnt822_2_), .CON(n2) );
  AHHCONX2 U1_1_3 ( .A(n137_3_), .CI(carry_3_), .S(ras_cnt822_3_), .CON(n1) );
  AHHCONX2 U1_1_1 ( .A(n137_1_), .CI(n137_0_), .S(ras_cnt822_1_), .CON(n3) );
  NAND4X2 U2325 ( .A(n3232), .B(n3233), .C(n3234), .D(n3235), .Y(n2730) );
  NOR3X1 U2326 ( .A(CMD[2]), .B(CMD[5]), .C(CMD[4]), .Y(n3235) );
  NAND2X1 U2327 ( .A(n2730), .B(n2988), .Y(n2987) );
  NAND2X1 U2328 ( .A(n2730), .B(n2871), .Y(n2870) );
  NAND2X1 U2329 ( .A(n2730), .B(n3105), .Y(n3104) );
  OR2X1 U2330 ( .A(n2797), .B(n3176), .Y(n2567) );
  OR2X1 U2331 ( .A(n2793), .B(n3176), .Y(n2568) );
  OR2X1 U2332 ( .A(n2789), .B(n3176), .Y(n2569) );
  OR2X1 U2333 ( .A(n2785), .B(n3176), .Y(n2570) );
  OR2X1 U2334 ( .A(n2781), .B(n3176), .Y(n2571) );
  OR2X1 U2335 ( .A(n2777), .B(n3176), .Y(n2572) );
  OR2X1 U2336 ( .A(n2773), .B(n3176), .Y(n2573) );
  OR2X1 U2337 ( .A(n2769), .B(n3176), .Y(n2574) );
  OR2X1 U2338 ( .A(n2765), .B(n3176), .Y(n2575) );
  OR2X1 U2339 ( .A(n2761), .B(n3176), .Y(n2576) );
  OR2X1 U2340 ( .A(n2757), .B(n3176), .Y(n2577) );
  OR2X1 U2341 ( .A(n2753), .B(n3176), .Y(n2578) );
  INVX3 U2342 ( .A(n2705), .Y(n2735) );
  AND2X2 U2343 ( .A(n2730), .B(n2737), .Y(n2705) );
  XOR2X1 U2344 ( .A(CMD[3]), .B(CMD[1]), .Y(n3234) );
  NAND2X1 U2345 ( .A(n2730), .B(n3046), .Y(n3045) );
  NAND2X1 U2346 ( .A(n2730), .B(n2929), .Y(n2928) );
  NAND2X1 U2347 ( .A(n2730), .B(n2812), .Y(n2811) );
  NAND2X1 U2348 ( .A(n3157), .B(n2806), .Y(n3105) );
  NAND3X1 U2349 ( .A(n137_1_), .B(n137_2_), .C(n2806), .Y(n2737) );
  NAND2X1 U2350 ( .A(n3040), .B(n2806), .Y(n2988) );
  NAND2X1 U2351 ( .A(n2923), .B(n2806), .Y(n2871) );
  INVX1 U2352 ( .A(n3229), .Y(n3099) );
  NAND2X1 U2353 ( .A(n3099), .B(n3209), .Y(n3158) );
  INVX1 U2354 ( .A(BA_TT[0]), .Y(n2736) );
  INVX1 U2355 ( .A(BA_TT[3]), .Y(n2749) );
  INVX1 U2356 ( .A(BA_TT[2]), .Y(n2745) );
  INVX1 U2357 ( .A(BA_TT[1]), .Y(n2741) );
  MX2X1 U2358 ( .S0(n3208), .B(ras_cnt865_1_), .A(ras_cnt_1_), .Y(n137_1_) );
  MXI2X1 U2359 ( .S0(n3208), .B(ras_cnt865_3_), .A(ras_cnt_3_), .Y(n3207) );
  MX2X1 U2360 ( .S0(n3208), .B(ras_cnt865_2_), .A(ras_cnt_2_), .Y(n137_2_) );
  NAND3X1 U2361 ( .A(n3231), .B(BA_REQ), .C(n3207), .Y(n3229) );
  DFFSX1 RAS_HEMPTY_reg ( .D(RAS_HEMPTY479), .CK(ACLK), .SN(ARESETB), .Q(
        RAS_HEMPTY) );
  NAND2X1 U2362 ( .A(n2737), .B(n2735), .Y(n2731) );
  NAND2X1 U2363 ( .A(n3105), .B(n3104), .Y(n3100) );
  NAND2X1 U2364 ( .A(n2988), .B(n2987), .Y(n2983) );
  NAND2X1 U2365 ( .A(n2871), .B(n2870), .Y(n2866) );
  NAND2X1 U2366 ( .A(n3046), .B(n3045), .Y(n3041) );
  NAND2X1 U2367 ( .A(n2929), .B(n2928), .Y(n2924) );
  NAND2X1 U2368 ( .A(n2812), .B(n2811), .Y(n2807) );
  INVX1 U2369 ( .A(n3158), .Y(n2806) );
  AND2X2 U2370 ( .A(n3099), .B(n137_0_), .Y(n2706) );
  INVX1 U2371 ( .A(n1), .Y(n3225) );
  INVX1 U2372 ( .A(n3210), .Y(RAS_HEMPTY479) );
  INVX1 U2373 ( .A(n2729), .Y(n2711) );
  INVX1 U2374 ( .A(n3174), .Y(n3161) );
  INVX1 U2375 ( .A(n3191), .Y(n3179) );
  INVX1 U2376 ( .A(n3206), .Y(n3194) );
  NAND2X1 U2377 ( .A(n3173), .B(n3176), .Y(n3175) );
  NAND2X1 U2378 ( .A(n3173), .B(n3174), .Y(n3159) );
  NAND2X1 U2379 ( .A(n3173), .B(n3191), .Y(n3177) );
  NAND2X1 U2380 ( .A(n3173), .B(n3206), .Y(n3192) );
  INVX1 U2381 ( .A(BA_BA[0]), .Y(n2801) );
  INVX1 U2382 ( .A(BA_RA[11]), .Y(n2797) );
  INVX1 U2383 ( .A(BA_BA[1]), .Y(n2805) );
  INVX1 U2384 ( .A(n3230), .Y(n3215) );
  INVX1 U2385 ( .A(BA_RA[7]), .Y(n2781) );
  INVX1 U2386 ( .A(BA_RA[8]), .Y(n2785) );
  INVX1 U2387 ( .A(BA_RA[10]), .Y(n2793) );
  INVX1 U2388 ( .A(BA_RA[9]), .Y(n2789) );
  INVX1 U2389 ( .A(CLOSING), .Y(n3173) );
  INVX1 U2390 ( .A(BA_RA[0]), .Y(n2753) );
  INVX1 U2391 ( .A(BA_RA[3]), .Y(n2765) );
  INVX1 U2392 ( .A(BA_RA[2]), .Y(n2761) );
  INVX1 U2393 ( .A(BA_RA[5]), .Y(n2773) );
  INVX1 U2394 ( .A(BA_RA[4]), .Y(n2769) );
  INVX1 U2395 ( .A(BA_RA[6]), .Y(n2777) );
  INVX1 U2396 ( .A(BA_RA[1]), .Y(n2757) );
  NOR2X1 U2397 ( .A(n137_1_), .B(n137_2_), .Y(n3157) );
  NOR2X1 U2398 ( .A(n137_2_), .B(n2982), .Y(n3040) );
  NOR2X1 U2399 ( .A(n137_1_), .B(n2865), .Y(n2923) );
  NAND2X1 U2400 ( .A(n3098), .B(n2706), .Y(n3046) );
  NOR2X1 U2401 ( .A(n137_1_), .B(n137_2_), .Y(n3098) );
  NAND2X1 U2402 ( .A(n2981), .B(n2706), .Y(n2929) );
  NOR2X1 U2403 ( .A(n137_2_), .B(n2982), .Y(n2981) );
  NAND2X1 U2404 ( .A(n2864), .B(n2706), .Y(n2812) );
  NOR2X1 U2405 ( .A(n137_1_), .B(n2865), .Y(n2864) );
  INVX1 U2406 ( .A(n3207), .Y(n137_3_) );
  INVX1 U2407 ( .A(n2), .Y(carry_3_) );
  INVX1 U2408 ( .A(n2730), .Y(n3208) );
  INVX1 U2409 ( .A(n3), .Y(carry_2_) );
  NAND3BX1 U2410 ( .AN(n206_2_), .B(n3212), .C(n3213), .Y(n3210) );
  OAI21X1 U2411 ( .A0(n2579), .A1(n2731), .B0(n2802), .Y(n1611) );
  NOR2X1 U2412 ( .A(n2803), .B(n2804), .Y(n2802) );
  NOR2X1 U2413 ( .A(n2805), .B(n2737), .Y(n2803) );
  NOR2X1 U2414 ( .A(n2735), .B(n2652), .Y(n2804) );
  OAI21X1 U2415 ( .A0(n2580), .A1(n2731), .B0(n2798), .Y(n1612) );
  NOR2X1 U2416 ( .A(n2799), .B(n2800), .Y(n2798) );
  NOR2X1 U2417 ( .A(n2801), .B(n2737), .Y(n2799) );
  NOR2X1 U2418 ( .A(n2735), .B(n2654), .Y(n2800) );
  OAI21X1 U2419 ( .A0(n2581), .A1(n2731), .B0(n2794), .Y(n1613) );
  NOR2X1 U2420 ( .A(n2795), .B(n2796), .Y(n2794) );
  NOR2X1 U2421 ( .A(n2797), .B(n2737), .Y(n2795) );
  NOR2X1 U2422 ( .A(n2735), .B(n2656), .Y(n2796) );
  OAI21X1 U2423 ( .A0(n2582), .A1(n2731), .B0(n2790), .Y(n1614) );
  NOR2X1 U2424 ( .A(n2791), .B(n2792), .Y(n2790) );
  NOR2X1 U2425 ( .A(n2793), .B(n2737), .Y(n2791) );
  NOR2X1 U2426 ( .A(n2735), .B(n2658), .Y(n2792) );
  OAI21X1 U2427 ( .A0(n2583), .A1(n2731), .B0(n2786), .Y(n1615) );
  NOR2X1 U2428 ( .A(n2787), .B(n2788), .Y(n2786) );
  NOR2X1 U2429 ( .A(n2789), .B(n2737), .Y(n2787) );
  NOR2X1 U2430 ( .A(n2735), .B(n2660), .Y(n2788) );
  OAI21X1 U2431 ( .A0(n2584), .A1(n2731), .B0(n2782), .Y(n1616) );
  NOR2X1 U2432 ( .A(n2783), .B(n2784), .Y(n2782) );
  NOR2X1 U2433 ( .A(n2785), .B(n2737), .Y(n2783) );
  NOR2X1 U2434 ( .A(n2735), .B(n2662), .Y(n2784) );
  OAI21X1 U2435 ( .A0(n2585), .A1(n2731), .B0(n2778), .Y(n1617) );
  NOR2X1 U2436 ( .A(n2779), .B(n2780), .Y(n2778) );
  NOR2X1 U2437 ( .A(n2781), .B(n2737), .Y(n2779) );
  NOR2X1 U2438 ( .A(n2735), .B(n2664), .Y(n2780) );
  OAI21X1 U2439 ( .A0(n2586), .A1(n2731), .B0(n2774), .Y(n1618) );
  NOR2X1 U2440 ( .A(n2775), .B(n2776), .Y(n2774) );
  NOR2X1 U2441 ( .A(n2777), .B(n2737), .Y(n2775) );
  NOR2X1 U2442 ( .A(n2735), .B(n2666), .Y(n2776) );
  OAI21X1 U2443 ( .A0(n2587), .A1(n2731), .B0(n2770), .Y(n1619) );
  NOR2X1 U2444 ( .A(n2771), .B(n2772), .Y(n2770) );
  NOR2X1 U2445 ( .A(n2773), .B(n2737), .Y(n2771) );
  NOR2X1 U2446 ( .A(n2735), .B(n2668), .Y(n2772) );
  OAI21X1 U2447 ( .A0(n2588), .A1(n2731), .B0(n2766), .Y(n1620) );
  NOR2X1 U2448 ( .A(n2767), .B(n2768), .Y(n2766) );
  NOR2X1 U2449 ( .A(n2769), .B(n2737), .Y(n2767) );
  NOR2X1 U2450 ( .A(n2735), .B(n2670), .Y(n2768) );
  OAI21X1 U2451 ( .A0(n2589), .A1(n2731), .B0(n2762), .Y(n1621) );
  NOR2X1 U2452 ( .A(n2763), .B(n2764), .Y(n2762) );
  NOR2X1 U2453 ( .A(n2765), .B(n2737), .Y(n2763) );
  NOR2X1 U2454 ( .A(n2735), .B(n2672), .Y(n2764) );
  OAI21X1 U2455 ( .A0(n2590), .A1(n2731), .B0(n2758), .Y(n1622) );
  NOR2X1 U2456 ( .A(n2759), .B(n2760), .Y(n2758) );
  NOR2X1 U2457 ( .A(n2761), .B(n2737), .Y(n2759) );
  NOR2X1 U2458 ( .A(n2735), .B(n2674), .Y(n2760) );
  OAI21X1 U2459 ( .A0(n2591), .A1(n2731), .B0(n2754), .Y(n1623) );
  NOR2X1 U2460 ( .A(n2755), .B(n2756), .Y(n2754) );
  NOR2X1 U2461 ( .A(n2757), .B(n2737), .Y(n2755) );
  NOR2X1 U2462 ( .A(n2735), .B(n2676), .Y(n2756) );
  OAI21X1 U2463 ( .A0(n2592), .A1(n2731), .B0(n2750), .Y(n1624) );
  NOR2X1 U2464 ( .A(n2751), .B(n2752), .Y(n2750) );
  NOR2X1 U2465 ( .A(n2753), .B(n2737), .Y(n2751) );
  NOR2X1 U2466 ( .A(n2735), .B(n2678), .Y(n2752) );
  OAI21X1 U2467 ( .A0(n2593), .A1(n2731), .B0(n2746), .Y(n1625) );
  NOR2X1 U2468 ( .A(n2747), .B(n2748), .Y(n2746) );
  NOR2X1 U2469 ( .A(n2749), .B(n2737), .Y(n2747) );
  NOR2X1 U2470 ( .A(n2735), .B(n2680), .Y(n2748) );
  OAI21X1 U2471 ( .A0(n2594), .A1(n2731), .B0(n2742), .Y(n1626) );
  NOR2X1 U2472 ( .A(n2743), .B(n2744), .Y(n2742) );
  NOR2X1 U2473 ( .A(n2745), .B(n2737), .Y(n2743) );
  NOR2X1 U2474 ( .A(n2735), .B(n2682), .Y(n2744) );
  OAI21X1 U2475 ( .A0(n2595), .A1(n2731), .B0(n2738), .Y(n1627) );
  NOR2X1 U2476 ( .A(n2739), .B(n2740), .Y(n2738) );
  NOR2X1 U2477 ( .A(n2741), .B(n2737), .Y(n2739) );
  NOR2X1 U2478 ( .A(n2735), .B(n2684), .Y(n2740) );
  OAI21X1 U2479 ( .A0(n2596), .A1(n2731), .B0(n2732), .Y(n1628) );
  NOR2X1 U2480 ( .A(n2733), .B(n2734), .Y(n2732) );
  NOR2X1 U2481 ( .A(n2736), .B(n2737), .Y(n2733) );
  NOR2X1 U2482 ( .A(n2735), .B(n2686), .Y(n2734) );
  OAI21X1 U2483 ( .A0(n2615), .A1(n2983), .B0(n3037), .Y(n1539) );
  NOR2X1 U2484 ( .A(n3038), .B(n3039), .Y(n3037) );
  NOR2X1 U2485 ( .A(n2805), .B(n2988), .Y(n3038) );
  NOR2X1 U2486 ( .A(n2987), .B(n2597), .Y(n3039) );
  OAI21X1 U2487 ( .A0(n2617), .A1(n2983), .B0(n3034), .Y(n1540) );
  NOR2X1 U2488 ( .A(n3035), .B(n3036), .Y(n3034) );
  NOR2X1 U2489 ( .A(n2801), .B(n2988), .Y(n3035) );
  NOR2X1 U2490 ( .A(n2987), .B(n2598), .Y(n3036) );
  OAI21X1 U2491 ( .A0(n2619), .A1(n2983), .B0(n3031), .Y(n1541) );
  NOR2X1 U2492 ( .A(n3032), .B(n3033), .Y(n3031) );
  NOR2X1 U2493 ( .A(n2797), .B(n2988), .Y(n3032) );
  NOR2X1 U2494 ( .A(n2987), .B(n2599), .Y(n3033) );
  OAI21X1 U2495 ( .A0(n2621), .A1(n2983), .B0(n3028), .Y(n1542) );
  NOR2X1 U2496 ( .A(n3029), .B(n3030), .Y(n3028) );
  NOR2X1 U2497 ( .A(n2793), .B(n2988), .Y(n3029) );
  NOR2X1 U2498 ( .A(n2987), .B(n2600), .Y(n3030) );
  OAI21X1 U2499 ( .A0(n2623), .A1(n2983), .B0(n3025), .Y(n1543) );
  NOR2X1 U2500 ( .A(n3026), .B(n3027), .Y(n3025) );
  NOR2X1 U2501 ( .A(n2789), .B(n2988), .Y(n3026) );
  NOR2X1 U2502 ( .A(n2987), .B(n2601), .Y(n3027) );
  OAI21X1 U2503 ( .A0(n2625), .A1(n2983), .B0(n3022), .Y(n1544) );
  NOR2X1 U2504 ( .A(n3023), .B(n3024), .Y(n3022) );
  NOR2X1 U2505 ( .A(n2785), .B(n2988), .Y(n3023) );
  NOR2X1 U2506 ( .A(n2987), .B(n2602), .Y(n3024) );
  OAI21X1 U2507 ( .A0(n2627), .A1(n2983), .B0(n3019), .Y(n1545) );
  NOR2X1 U2508 ( .A(n3020), .B(n3021), .Y(n3019) );
  NOR2X1 U2509 ( .A(n2781), .B(n2988), .Y(n3020) );
  NOR2X1 U2510 ( .A(n2987), .B(n2603), .Y(n3021) );
  OAI21X1 U2511 ( .A0(n2629), .A1(n2983), .B0(n3016), .Y(n1546) );
  NOR2X1 U2512 ( .A(n3017), .B(n3018), .Y(n3016) );
  NOR2X1 U2513 ( .A(n2777), .B(n2988), .Y(n3017) );
  NOR2X1 U2514 ( .A(n2987), .B(n2604), .Y(n3018) );
  OAI21X1 U2515 ( .A0(n2631), .A1(n2983), .B0(n3013), .Y(n1547) );
  NOR2X1 U2516 ( .A(n3014), .B(n3015), .Y(n3013) );
  NOR2X1 U2517 ( .A(n2773), .B(n2988), .Y(n3014) );
  NOR2X1 U2518 ( .A(n2987), .B(n2605), .Y(n3015) );
  OAI21X1 U2519 ( .A0(n2633), .A1(n2983), .B0(n3010), .Y(n1548) );
  NOR2X1 U2520 ( .A(n3011), .B(n3012), .Y(n3010) );
  NOR2X1 U2521 ( .A(n2769), .B(n2988), .Y(n3011) );
  NOR2X1 U2522 ( .A(n2987), .B(n2606), .Y(n3012) );
  OAI21X1 U2523 ( .A0(n2635), .A1(n2983), .B0(n3007), .Y(n1549) );
  NOR2X1 U2524 ( .A(n3008), .B(n3009), .Y(n3007) );
  NOR2X1 U2525 ( .A(n2765), .B(n2988), .Y(n3008) );
  NOR2X1 U2526 ( .A(n2987), .B(n2607), .Y(n3009) );
  OAI21X1 U2527 ( .A0(n2637), .A1(n2983), .B0(n3004), .Y(n1550) );
  NOR2X1 U2528 ( .A(n3005), .B(n3006), .Y(n3004) );
  NOR2X1 U2529 ( .A(n2761), .B(n2988), .Y(n3005) );
  NOR2X1 U2530 ( .A(n2987), .B(n2608), .Y(n3006) );
  OAI21X1 U2531 ( .A0(n2639), .A1(n2983), .B0(n3001), .Y(n1551) );
  NOR2X1 U2532 ( .A(n3002), .B(n3003), .Y(n3001) );
  NOR2X1 U2533 ( .A(n2757), .B(n2988), .Y(n3002) );
  NOR2X1 U2534 ( .A(n2987), .B(n2609), .Y(n3003) );
  OAI21X1 U2535 ( .A0(n2641), .A1(n2983), .B0(n2998), .Y(n1552) );
  NOR2X1 U2536 ( .A(n2999), .B(n3000), .Y(n2998) );
  NOR2X1 U2537 ( .A(n2753), .B(n2988), .Y(n2999) );
  NOR2X1 U2538 ( .A(n2987), .B(n2610), .Y(n3000) );
  OAI21X1 U2539 ( .A0(n2643), .A1(n2983), .B0(n2995), .Y(n1553) );
  NOR2X1 U2540 ( .A(n2996), .B(n2997), .Y(n2995) );
  NOR2X1 U2541 ( .A(n2749), .B(n2988), .Y(n2996) );
  NOR2X1 U2542 ( .A(n2987), .B(n2611), .Y(n2997) );
  OAI21X1 U2543 ( .A0(n2645), .A1(n2983), .B0(n2992), .Y(n1554) );
  NOR2X1 U2544 ( .A(n2993), .B(n2994), .Y(n2992) );
  NOR2X1 U2545 ( .A(n2745), .B(n2988), .Y(n2993) );
  NOR2X1 U2546 ( .A(n2987), .B(n2612), .Y(n2994) );
  OAI21X1 U2547 ( .A0(n2647), .A1(n2983), .B0(n2989), .Y(n1555) );
  NOR2X1 U2548 ( .A(n2990), .B(n2991), .Y(n2989) );
  NOR2X1 U2549 ( .A(n2741), .B(n2988), .Y(n2990) );
  NOR2X1 U2550 ( .A(n2987), .B(n2613), .Y(n2991) );
  OAI21X1 U2551 ( .A0(n2649), .A1(n2983), .B0(n2984), .Y(n1556) );
  NOR2X1 U2552 ( .A(n2985), .B(n2986), .Y(n2984) );
  NOR2X1 U2553 ( .A(n2736), .B(n2988), .Y(n2985) );
  NOR2X1 U2554 ( .A(n2987), .B(n2614), .Y(n2986) );
  OAI21X1 U2555 ( .A0(n2651), .A1(n2866), .B0(n2920), .Y(n1575) );
  NOR2X1 U2556 ( .A(n2921), .B(n2922), .Y(n2920) );
  NOR2X1 U2557 ( .A(n2805), .B(n2871), .Y(n2921) );
  NOR2X1 U2558 ( .A(n2870), .B(n2616), .Y(n2922) );
  OAI21X1 U2559 ( .A0(n2653), .A1(n2866), .B0(n2917), .Y(n1576) );
  NOR2X1 U2560 ( .A(n2918), .B(n2919), .Y(n2917) );
  NOR2X1 U2561 ( .A(n2801), .B(n2871), .Y(n2918) );
  NOR2X1 U2562 ( .A(n2870), .B(n2618), .Y(n2919) );
  OAI21X1 U2563 ( .A0(n2655), .A1(n2866), .B0(n2914), .Y(n1577) );
  NOR2X1 U2564 ( .A(n2915), .B(n2916), .Y(n2914) );
  NOR2X1 U2565 ( .A(n2797), .B(n2871), .Y(n2915) );
  NOR2X1 U2566 ( .A(n2870), .B(n2620), .Y(n2916) );
  OAI21X1 U2567 ( .A0(n2657), .A1(n2866), .B0(n2911), .Y(n1578) );
  NOR2X1 U2568 ( .A(n2912), .B(n2913), .Y(n2911) );
  NOR2X1 U2569 ( .A(n2793), .B(n2871), .Y(n2912) );
  NOR2X1 U2570 ( .A(n2870), .B(n2622), .Y(n2913) );
  OAI21X1 U2571 ( .A0(n2659), .A1(n2866), .B0(n2908), .Y(n1579) );
  NOR2X1 U2572 ( .A(n2909), .B(n2910), .Y(n2908) );
  NOR2X1 U2573 ( .A(n2789), .B(n2871), .Y(n2909) );
  NOR2X1 U2574 ( .A(n2870), .B(n2624), .Y(n2910) );
  OAI21X1 U2575 ( .A0(n2661), .A1(n2866), .B0(n2905), .Y(n1580) );
  NOR2X1 U2576 ( .A(n2906), .B(n2907), .Y(n2905) );
  NOR2X1 U2577 ( .A(n2785), .B(n2871), .Y(n2906) );
  NOR2X1 U2578 ( .A(n2870), .B(n2626), .Y(n2907) );
  OAI21X1 U2579 ( .A0(n2663), .A1(n2866), .B0(n2902), .Y(n1581) );
  NOR2X1 U2580 ( .A(n2903), .B(n2904), .Y(n2902) );
  NOR2X1 U2581 ( .A(n2781), .B(n2871), .Y(n2903) );
  NOR2X1 U2582 ( .A(n2870), .B(n2628), .Y(n2904) );
  OAI21X1 U2583 ( .A0(n2665), .A1(n2866), .B0(n2899), .Y(n1582) );
  NOR2X1 U2584 ( .A(n2900), .B(n2901), .Y(n2899) );
  NOR2X1 U2585 ( .A(n2777), .B(n2871), .Y(n2900) );
  NOR2X1 U2586 ( .A(n2870), .B(n2630), .Y(n2901) );
  OAI21X1 U2587 ( .A0(n2667), .A1(n2866), .B0(n2896), .Y(n1583) );
  NOR2X1 U2588 ( .A(n2897), .B(n2898), .Y(n2896) );
  NOR2X1 U2589 ( .A(n2773), .B(n2871), .Y(n2897) );
  NOR2X1 U2590 ( .A(n2870), .B(n2632), .Y(n2898) );
  OAI21X1 U2591 ( .A0(n2669), .A1(n2866), .B0(n2893), .Y(n1584) );
  NOR2X1 U2592 ( .A(n2894), .B(n2895), .Y(n2893) );
  NOR2X1 U2593 ( .A(n2769), .B(n2871), .Y(n2894) );
  NOR2X1 U2594 ( .A(n2870), .B(n2634), .Y(n2895) );
  OAI21X1 U2595 ( .A0(n2671), .A1(n2866), .B0(n2890), .Y(n1585) );
  NOR2X1 U2596 ( .A(n2891), .B(n2892), .Y(n2890) );
  NOR2X1 U2597 ( .A(n2765), .B(n2871), .Y(n2891) );
  NOR2X1 U2598 ( .A(n2870), .B(n2636), .Y(n2892) );
  OAI21X1 U2599 ( .A0(n2673), .A1(n2866), .B0(n2887), .Y(n1586) );
  NOR2X1 U2600 ( .A(n2888), .B(n2889), .Y(n2887) );
  NOR2X1 U2601 ( .A(n2761), .B(n2871), .Y(n2888) );
  NOR2X1 U2602 ( .A(n2870), .B(n2638), .Y(n2889) );
  OAI21X1 U2603 ( .A0(n2675), .A1(n2866), .B0(n2884), .Y(n1587) );
  NOR2X1 U2604 ( .A(n2885), .B(n2886), .Y(n2884) );
  NOR2X1 U2605 ( .A(n2757), .B(n2871), .Y(n2885) );
  NOR2X1 U2606 ( .A(n2870), .B(n2640), .Y(n2886) );
  OAI21X1 U2607 ( .A0(n2677), .A1(n2866), .B0(n2881), .Y(n1588) );
  NOR2X1 U2608 ( .A(n2882), .B(n2883), .Y(n2881) );
  NOR2X1 U2609 ( .A(n2753), .B(n2871), .Y(n2882) );
  NOR2X1 U2610 ( .A(n2870), .B(n2642), .Y(n2883) );
  OAI21X1 U2611 ( .A0(n2679), .A1(n2866), .B0(n2878), .Y(n1589) );
  NOR2X1 U2612 ( .A(n2879), .B(n2880), .Y(n2878) );
  NOR2X1 U2613 ( .A(n2749), .B(n2871), .Y(n2879) );
  NOR2X1 U2614 ( .A(n2870), .B(n2644), .Y(n2880) );
  OAI21X1 U2615 ( .A0(n2681), .A1(n2866), .B0(n2875), .Y(n1590) );
  NOR2X1 U2616 ( .A(n2876), .B(n2877), .Y(n2875) );
  NOR2X1 U2617 ( .A(n2745), .B(n2871), .Y(n2876) );
  NOR2X1 U2618 ( .A(n2870), .B(n2646), .Y(n2877) );
  OAI21X1 U2619 ( .A0(n2683), .A1(n2866), .B0(n2872), .Y(n1591) );
  NOR2X1 U2620 ( .A(n2873), .B(n2874), .Y(n2872) );
  NOR2X1 U2621 ( .A(n2741), .B(n2871), .Y(n2873) );
  NOR2X1 U2622 ( .A(n2870), .B(n2648), .Y(n2874) );
  OAI21X1 U2623 ( .A0(n2685), .A1(n2866), .B0(n2867), .Y(n1592) );
  NOR2X1 U2624 ( .A(n2868), .B(n2869), .Y(n2867) );
  NOR2X1 U2625 ( .A(n2736), .B(n2871), .Y(n2868) );
  NOR2X1 U2626 ( .A(n2870), .B(n2650), .Y(n2869) );
  OAI21X1 U2627 ( .A0(n2597), .A1(n3041), .B0(n3095), .Y(n1521) );
  NOR2X1 U2628 ( .A(n3096), .B(n3097), .Y(n3095) );
  NOR2X1 U2629 ( .A(n2805), .B(n3046), .Y(n3096) );
  NOR2X1 U2630 ( .A(n3045), .B(n2687), .Y(n3097) );
  OAI21X1 U2631 ( .A0(n2598), .A1(n3041), .B0(n3092), .Y(n1522) );
  NOR2X1 U2632 ( .A(n3093), .B(n3094), .Y(n3092) );
  NOR2X1 U2633 ( .A(n2801), .B(n3046), .Y(n3093) );
  NOR2X1 U2634 ( .A(n3045), .B(n2688), .Y(n3094) );
  OAI21X1 U2635 ( .A0(n2599), .A1(n3041), .B0(n3089), .Y(n1523) );
  NOR2X1 U2636 ( .A(n3090), .B(n3091), .Y(n3089) );
  NOR2X1 U2637 ( .A(n2797), .B(n3046), .Y(n3090) );
  NOR2X1 U2638 ( .A(n3045), .B(n2689), .Y(n3091) );
  OAI21X1 U2639 ( .A0(n2600), .A1(n3041), .B0(n3086), .Y(n1524) );
  NOR2X1 U2640 ( .A(n3087), .B(n3088), .Y(n3086) );
  NOR2X1 U2641 ( .A(n2793), .B(n3046), .Y(n3087) );
  NOR2X1 U2642 ( .A(n3045), .B(n2690), .Y(n3088) );
  OAI21X1 U2643 ( .A0(n2601), .A1(n3041), .B0(n3083), .Y(n1525) );
  NOR2X1 U2644 ( .A(n3084), .B(n3085), .Y(n3083) );
  NOR2X1 U2645 ( .A(n2789), .B(n3046), .Y(n3084) );
  NOR2X1 U2646 ( .A(n3045), .B(n2691), .Y(n3085) );
  OAI21X1 U2647 ( .A0(n2602), .A1(n3041), .B0(n3080), .Y(n1526) );
  NOR2X1 U2648 ( .A(n3081), .B(n3082), .Y(n3080) );
  NOR2X1 U2649 ( .A(n2785), .B(n3046), .Y(n3081) );
  NOR2X1 U2650 ( .A(n3045), .B(n2692), .Y(n3082) );
  OAI21X1 U2651 ( .A0(n2603), .A1(n3041), .B0(n3077), .Y(n1527) );
  NOR2X1 U2652 ( .A(n3078), .B(n3079), .Y(n3077) );
  NOR2X1 U2653 ( .A(n2781), .B(n3046), .Y(n3078) );
  NOR2X1 U2654 ( .A(n3045), .B(n2693), .Y(n3079) );
  OAI21X1 U2655 ( .A0(n2604), .A1(n3041), .B0(n3074), .Y(n1528) );
  NOR2X1 U2656 ( .A(n3075), .B(n3076), .Y(n3074) );
  NOR2X1 U2657 ( .A(n2777), .B(n3046), .Y(n3075) );
  NOR2X1 U2658 ( .A(n3045), .B(n2694), .Y(n3076) );
  OAI21X1 U2659 ( .A0(n2605), .A1(n3041), .B0(n3071), .Y(n1529) );
  NOR2X1 U2660 ( .A(n3072), .B(n3073), .Y(n3071) );
  NOR2X1 U2661 ( .A(n2773), .B(n3046), .Y(n3072) );
  NOR2X1 U2662 ( .A(n3045), .B(n2695), .Y(n3073) );
  OAI21X1 U2663 ( .A0(n2606), .A1(n3041), .B0(n3068), .Y(n1530) );
  NOR2X1 U2664 ( .A(n3069), .B(n3070), .Y(n3068) );
  NOR2X1 U2665 ( .A(n2769), .B(n3046), .Y(n3069) );
  NOR2X1 U2666 ( .A(n3045), .B(n2696), .Y(n3070) );
  OAI21X1 U2667 ( .A0(n2607), .A1(n3041), .B0(n3065), .Y(n1531) );
  NOR2X1 U2668 ( .A(n3066), .B(n3067), .Y(n3065) );
  NOR2X1 U2669 ( .A(n2765), .B(n3046), .Y(n3066) );
  NOR2X1 U2670 ( .A(n3045), .B(n2697), .Y(n3067) );
  OAI21X1 U2671 ( .A0(n2608), .A1(n3041), .B0(n3062), .Y(n1532) );
  NOR2X1 U2672 ( .A(n3063), .B(n3064), .Y(n3062) );
  NOR2X1 U2673 ( .A(n2761), .B(n3046), .Y(n3063) );
  NOR2X1 U2674 ( .A(n3045), .B(n2698), .Y(n3064) );
  OAI21X1 U2675 ( .A0(n2609), .A1(n3041), .B0(n3059), .Y(n1533) );
  NOR2X1 U2676 ( .A(n3060), .B(n3061), .Y(n3059) );
  NOR2X1 U2677 ( .A(n2757), .B(n3046), .Y(n3060) );
  NOR2X1 U2678 ( .A(n3045), .B(n2699), .Y(n3061) );
  OAI21X1 U2679 ( .A0(n2610), .A1(n3041), .B0(n3056), .Y(n1534) );
  NOR2X1 U2680 ( .A(n3057), .B(n3058), .Y(n3056) );
  NOR2X1 U2681 ( .A(n2753), .B(n3046), .Y(n3057) );
  NOR2X1 U2682 ( .A(n3045), .B(n2700), .Y(n3058) );
  OAI21X1 U2683 ( .A0(n2611), .A1(n3041), .B0(n3053), .Y(n1535) );
  NOR2X1 U2684 ( .A(n3054), .B(n3055), .Y(n3053) );
  NOR2X1 U2685 ( .A(n2749), .B(n3046), .Y(n3054) );
  NOR2X1 U2686 ( .A(n3045), .B(n2701), .Y(n3055) );
  OAI21X1 U2687 ( .A0(n2612), .A1(n3041), .B0(n3050), .Y(n1536) );
  NOR2X1 U2688 ( .A(n3051), .B(n3052), .Y(n3050) );
  NOR2X1 U2689 ( .A(n2745), .B(n3046), .Y(n3051) );
  NOR2X1 U2690 ( .A(n3045), .B(n2702), .Y(n3052) );
  OAI21X1 U2691 ( .A0(n2613), .A1(n3041), .B0(n3047), .Y(n1537) );
  NOR2X1 U2692 ( .A(n3048), .B(n3049), .Y(n3047) );
  NOR2X1 U2693 ( .A(n2741), .B(n3046), .Y(n3048) );
  NOR2X1 U2694 ( .A(n3045), .B(n2703), .Y(n3049) );
  OAI21X1 U2695 ( .A0(n2614), .A1(n3041), .B0(n3042), .Y(n1538) );
  NOR2X1 U2696 ( .A(n3043), .B(n3044), .Y(n3042) );
  NOR2X1 U2697 ( .A(n2736), .B(n3046), .Y(n3043) );
  NOR2X1 U2698 ( .A(n3045), .B(n2704), .Y(n3044) );
  OAI21X1 U2699 ( .A0(n2616), .A1(n2924), .B0(n2978), .Y(n1557) );
  NOR2X1 U2700 ( .A(n2979), .B(n2980), .Y(n2978) );
  NOR2X1 U2701 ( .A(n2805), .B(n2929), .Y(n2979) );
  NOR2X1 U2702 ( .A(n2928), .B(n2615), .Y(n2980) );
  OAI21X1 U2703 ( .A0(n2618), .A1(n2924), .B0(n2975), .Y(n1558) );
  NOR2X1 U2704 ( .A(n2976), .B(n2977), .Y(n2975) );
  NOR2X1 U2705 ( .A(n2801), .B(n2929), .Y(n2976) );
  NOR2X1 U2706 ( .A(n2928), .B(n2617), .Y(n2977) );
  OAI21X1 U2707 ( .A0(n2620), .A1(n2924), .B0(n2972), .Y(n1559) );
  NOR2X1 U2708 ( .A(n2973), .B(n2974), .Y(n2972) );
  NOR2X1 U2709 ( .A(n2797), .B(n2929), .Y(n2973) );
  NOR2X1 U2710 ( .A(n2928), .B(n2619), .Y(n2974) );
  OAI21X1 U2711 ( .A0(n2622), .A1(n2924), .B0(n2969), .Y(n1560) );
  NOR2X1 U2712 ( .A(n2970), .B(n2971), .Y(n2969) );
  NOR2X1 U2713 ( .A(n2793), .B(n2929), .Y(n2970) );
  NOR2X1 U2714 ( .A(n2928), .B(n2621), .Y(n2971) );
  OAI21X1 U2715 ( .A0(n2624), .A1(n2924), .B0(n2966), .Y(n1561) );
  NOR2X1 U2716 ( .A(n2967), .B(n2968), .Y(n2966) );
  NOR2X1 U2717 ( .A(n2789), .B(n2929), .Y(n2967) );
  NOR2X1 U2718 ( .A(n2928), .B(n2623), .Y(n2968) );
  OAI21X1 U2719 ( .A0(n2626), .A1(n2924), .B0(n2963), .Y(n1562) );
  NOR2X1 U2720 ( .A(n2964), .B(n2965), .Y(n2963) );
  NOR2X1 U2721 ( .A(n2785), .B(n2929), .Y(n2964) );
  NOR2X1 U2722 ( .A(n2928), .B(n2625), .Y(n2965) );
  OAI21X1 U2723 ( .A0(n2628), .A1(n2924), .B0(n2960), .Y(n1563) );
  NOR2X1 U2724 ( .A(n2961), .B(n2962), .Y(n2960) );
  NOR2X1 U2725 ( .A(n2781), .B(n2929), .Y(n2961) );
  NOR2X1 U2726 ( .A(n2928), .B(n2627), .Y(n2962) );
  OAI21X1 U2727 ( .A0(n2630), .A1(n2924), .B0(n2957), .Y(n1564) );
  NOR2X1 U2728 ( .A(n2958), .B(n2959), .Y(n2957) );
  NOR2X1 U2729 ( .A(n2777), .B(n2929), .Y(n2958) );
  NOR2X1 U2730 ( .A(n2928), .B(n2629), .Y(n2959) );
  OAI21X1 U2731 ( .A0(n2632), .A1(n2924), .B0(n2954), .Y(n1565) );
  NOR2X1 U2732 ( .A(n2955), .B(n2956), .Y(n2954) );
  NOR2X1 U2733 ( .A(n2773), .B(n2929), .Y(n2955) );
  NOR2X1 U2734 ( .A(n2928), .B(n2631), .Y(n2956) );
  OAI21X1 U2735 ( .A0(n2634), .A1(n2924), .B0(n2951), .Y(n1566) );
  NOR2X1 U2736 ( .A(n2952), .B(n2953), .Y(n2951) );
  NOR2X1 U2737 ( .A(n2769), .B(n2929), .Y(n2952) );
  NOR2X1 U2738 ( .A(n2928), .B(n2633), .Y(n2953) );
  OAI21X1 U2739 ( .A0(n2636), .A1(n2924), .B0(n2948), .Y(n1567) );
  NOR2X1 U2740 ( .A(n2949), .B(n2950), .Y(n2948) );
  NOR2X1 U2741 ( .A(n2765), .B(n2929), .Y(n2949) );
  NOR2X1 U2742 ( .A(n2928), .B(n2635), .Y(n2950) );
  OAI21X1 U2743 ( .A0(n2638), .A1(n2924), .B0(n2945), .Y(n1568) );
  NOR2X1 U2744 ( .A(n2946), .B(n2947), .Y(n2945) );
  NOR2X1 U2745 ( .A(n2761), .B(n2929), .Y(n2946) );
  NOR2X1 U2746 ( .A(n2928), .B(n2637), .Y(n2947) );
  OAI21X1 U2747 ( .A0(n2640), .A1(n2924), .B0(n2942), .Y(n1569) );
  NOR2X1 U2748 ( .A(n2943), .B(n2944), .Y(n2942) );
  NOR2X1 U2749 ( .A(n2757), .B(n2929), .Y(n2943) );
  NOR2X1 U2750 ( .A(n2928), .B(n2639), .Y(n2944) );
  OAI21X1 U2751 ( .A0(n2642), .A1(n2924), .B0(n2939), .Y(n1570) );
  NOR2X1 U2752 ( .A(n2940), .B(n2941), .Y(n2939) );
  NOR2X1 U2753 ( .A(n2753), .B(n2929), .Y(n2940) );
  NOR2X1 U2754 ( .A(n2928), .B(n2641), .Y(n2941) );
  OAI21X1 U2755 ( .A0(n2644), .A1(n2924), .B0(n2936), .Y(n1571) );
  NOR2X1 U2756 ( .A(n2937), .B(n2938), .Y(n2936) );
  NOR2X1 U2757 ( .A(n2749), .B(n2929), .Y(n2937) );
  NOR2X1 U2758 ( .A(n2928), .B(n2643), .Y(n2938) );
  OAI21X1 U2759 ( .A0(n2646), .A1(n2924), .B0(n2933), .Y(n1572) );
  NOR2X1 U2760 ( .A(n2934), .B(n2935), .Y(n2933) );
  NOR2X1 U2761 ( .A(n2745), .B(n2929), .Y(n2934) );
  NOR2X1 U2762 ( .A(n2928), .B(n2645), .Y(n2935) );
  OAI21X1 U2763 ( .A0(n2648), .A1(n2924), .B0(n2930), .Y(n1573) );
  NOR2X1 U2764 ( .A(n2931), .B(n2932), .Y(n2930) );
  NOR2X1 U2765 ( .A(n2741), .B(n2929), .Y(n2931) );
  NOR2X1 U2766 ( .A(n2928), .B(n2647), .Y(n2932) );
  OAI21X1 U2767 ( .A0(n2650), .A1(n2924), .B0(n2925), .Y(n1574) );
  NOR2X1 U2768 ( .A(n2926), .B(n2927), .Y(n2925) );
  NOR2X1 U2769 ( .A(n2736), .B(n2929), .Y(n2926) );
  NOR2X1 U2770 ( .A(n2928), .B(n2649), .Y(n2927) );
  OAI21X1 U2771 ( .A0(n2652), .A1(n2807), .B0(n2861), .Y(n1593) );
  NOR2X1 U2772 ( .A(n2862), .B(n2863), .Y(n2861) );
  NOR2X1 U2773 ( .A(n2805), .B(n2812), .Y(n2862) );
  NOR2X1 U2774 ( .A(n2811), .B(n2651), .Y(n2863) );
  OAI21X1 U2775 ( .A0(n2654), .A1(n2807), .B0(n2858), .Y(n1594) );
  NOR2X1 U2776 ( .A(n2859), .B(n2860), .Y(n2858) );
  NOR2X1 U2777 ( .A(n2801), .B(n2812), .Y(n2859) );
  NOR2X1 U2778 ( .A(n2811), .B(n2653), .Y(n2860) );
  OAI21X1 U2779 ( .A0(n2656), .A1(n2807), .B0(n2855), .Y(n1595) );
  NOR2X1 U2780 ( .A(n2856), .B(n2857), .Y(n2855) );
  NOR2X1 U2781 ( .A(n2797), .B(n2812), .Y(n2856) );
  NOR2X1 U2782 ( .A(n2811), .B(n2655), .Y(n2857) );
  OAI21X1 U2783 ( .A0(n2658), .A1(n2807), .B0(n2852), .Y(n1596) );
  NOR2X1 U2784 ( .A(n2853), .B(n2854), .Y(n2852) );
  NOR2X1 U2785 ( .A(n2793), .B(n2812), .Y(n2853) );
  NOR2X1 U2786 ( .A(n2811), .B(n2657), .Y(n2854) );
  OAI21X1 U2787 ( .A0(n2660), .A1(n2807), .B0(n2849), .Y(n1597) );
  NOR2X1 U2788 ( .A(n2850), .B(n2851), .Y(n2849) );
  NOR2X1 U2789 ( .A(n2789), .B(n2812), .Y(n2850) );
  NOR2X1 U2790 ( .A(n2811), .B(n2659), .Y(n2851) );
  OAI21X1 U2791 ( .A0(n2662), .A1(n2807), .B0(n2846), .Y(n1598) );
  NOR2X1 U2792 ( .A(n2847), .B(n2848), .Y(n2846) );
  NOR2X1 U2793 ( .A(n2785), .B(n2812), .Y(n2847) );
  NOR2X1 U2794 ( .A(n2811), .B(n2661), .Y(n2848) );
  OAI21X1 U2795 ( .A0(n2664), .A1(n2807), .B0(n2843), .Y(n1599) );
  NOR2X1 U2796 ( .A(n2844), .B(n2845), .Y(n2843) );
  NOR2X1 U2797 ( .A(n2781), .B(n2812), .Y(n2844) );
  NOR2X1 U2798 ( .A(n2811), .B(n2663), .Y(n2845) );
  OAI21X1 U2799 ( .A0(n2666), .A1(n2807), .B0(n2840), .Y(n1600) );
  NOR2X1 U2800 ( .A(n2841), .B(n2842), .Y(n2840) );
  NOR2X1 U2801 ( .A(n2777), .B(n2812), .Y(n2841) );
  NOR2X1 U2802 ( .A(n2811), .B(n2665), .Y(n2842) );
  OAI21X1 U2803 ( .A0(n2668), .A1(n2807), .B0(n2837), .Y(n1601) );
  NOR2X1 U2804 ( .A(n2838), .B(n2839), .Y(n2837) );
  NOR2X1 U2805 ( .A(n2773), .B(n2812), .Y(n2838) );
  NOR2X1 U2806 ( .A(n2811), .B(n2667), .Y(n2839) );
  OAI21X1 U2807 ( .A0(n2670), .A1(n2807), .B0(n2834), .Y(n1602) );
  NOR2X1 U2808 ( .A(n2835), .B(n2836), .Y(n2834) );
  NOR2X1 U2809 ( .A(n2769), .B(n2812), .Y(n2835) );
  NOR2X1 U2810 ( .A(n2811), .B(n2669), .Y(n2836) );
  OAI21X1 U2811 ( .A0(n2672), .A1(n2807), .B0(n2831), .Y(n1603) );
  NOR2X1 U2812 ( .A(n2832), .B(n2833), .Y(n2831) );
  NOR2X1 U2813 ( .A(n2765), .B(n2812), .Y(n2832) );
  NOR2X1 U2814 ( .A(n2811), .B(n2671), .Y(n2833) );
  OAI21X1 U2815 ( .A0(n2674), .A1(n2807), .B0(n2828), .Y(n1604) );
  NOR2X1 U2816 ( .A(n2829), .B(n2830), .Y(n2828) );
  NOR2X1 U2817 ( .A(n2761), .B(n2812), .Y(n2829) );
  NOR2X1 U2818 ( .A(n2811), .B(n2673), .Y(n2830) );
  OAI21X1 U2819 ( .A0(n2676), .A1(n2807), .B0(n2825), .Y(n1605) );
  NOR2X1 U2820 ( .A(n2826), .B(n2827), .Y(n2825) );
  NOR2X1 U2821 ( .A(n2757), .B(n2812), .Y(n2826) );
  NOR2X1 U2822 ( .A(n2811), .B(n2675), .Y(n2827) );
  OAI21X1 U2823 ( .A0(n2678), .A1(n2807), .B0(n2822), .Y(n1606) );
  NOR2X1 U2824 ( .A(n2823), .B(n2824), .Y(n2822) );
  NOR2X1 U2825 ( .A(n2753), .B(n2812), .Y(n2823) );
  NOR2X1 U2826 ( .A(n2811), .B(n2677), .Y(n2824) );
  OAI21X1 U2827 ( .A0(n2680), .A1(n2807), .B0(n2819), .Y(n1607) );
  NOR2X1 U2828 ( .A(n2820), .B(n2821), .Y(n2819) );
  NOR2X1 U2829 ( .A(n2749), .B(n2812), .Y(n2820) );
  NOR2X1 U2830 ( .A(n2811), .B(n2679), .Y(n2821) );
  OAI21X1 U2831 ( .A0(n2682), .A1(n2807), .B0(n2816), .Y(n1608) );
  NOR2X1 U2832 ( .A(n2817), .B(n2818), .Y(n2816) );
  NOR2X1 U2833 ( .A(n2745), .B(n2812), .Y(n2817) );
  NOR2X1 U2834 ( .A(n2811), .B(n2681), .Y(n2818) );
  OAI21X1 U2835 ( .A0(n2684), .A1(n2807), .B0(n2813), .Y(n1609) );
  NOR2X1 U2836 ( .A(n2814), .B(n2815), .Y(n2813) );
  NOR2X1 U2837 ( .A(n2741), .B(n2812), .Y(n2814) );
  NOR2X1 U2838 ( .A(n2811), .B(n2683), .Y(n2815) );
  OAI21X1 U2839 ( .A0(n2686), .A1(n2807), .B0(n2808), .Y(n1610) );
  NOR2X1 U2840 ( .A(n2809), .B(n2810), .Y(n2808) );
  NOR2X1 U2841 ( .A(n2736), .B(n2812), .Y(n2809) );
  NOR2X1 U2842 ( .A(n2811), .B(n2685), .Y(n2810) );
  INVX1 U2843 ( .A(n137_1_), .Y(n2982) );
  INVX1 U2844 ( .A(n137_2_), .Y(n2865) );
  NOR3X1 U2845 ( .A(n3210), .B(n206_1_), .C(n206_0_), .Y(RAS_EMPTY471) );
  INVX1 U2846 ( .A(n3209), .Y(n137_0_) );
  INVX1 U2847 ( .A(n206_3_), .Y(n3213) );
  INVX1 U2848 ( .A(n206_4_), .Y(n3212) );
  NAND3X1 U2849 ( .A(BA_REQ), .B(n2801), .C(BA_BA[1]), .Y(n3176) );
  NAND2X1 U2850 ( .A(n2730), .B(n2729), .Y(n2709) );
  NAND3X1 U2851 ( .A(BA_BA[0]), .B(BA_REQ), .C(BA_BA[1]), .Y(n3174) );
  NAND3X1 U2852 ( .A(BA_REQ), .B(BA_BA[0]), .C(n2805), .Y(n3191) );
  NAND3X1 U2853 ( .A(n2801), .B(BA_REQ), .C(n2805), .Y(n3206) );
  NAND2X1 U2854 ( .A(n2730), .B(n3229), .Y(n3230) );
  NAND3X1 U2855 ( .A(n137_1_), .B(n137_2_), .C(n2706), .Y(n2729) );
  AND2X2 U2856 ( .A(n3229), .B(n3230), .Y(n2707) );
  OAI21X1 U2857 ( .A0(n2709), .A1(n2579), .B0(n2728), .Y(n1629) );
  NAND2X1 U2858 ( .A(BA_BA[1]), .B(n2711), .Y(n2728) );
  OAI21X1 U2859 ( .A0(n2709), .A1(n2580), .B0(n2727), .Y(n1630) );
  NAND2X1 U2860 ( .A(BA_BA[0]), .B(n2711), .Y(n2727) );
  OAI21X1 U2861 ( .A0(n2709), .A1(n2581), .B0(n2726), .Y(n1631) );
  NAND2X1 U2862 ( .A(BA_RA[11]), .B(n2711), .Y(n2726) );
  OAI21X1 U2863 ( .A0(n2709), .A1(n2582), .B0(n2725), .Y(n1632) );
  NAND2X1 U2864 ( .A(BA_RA[10]), .B(n2711), .Y(n2725) );
  OAI21X1 U2865 ( .A0(n2709), .A1(n2583), .B0(n2724), .Y(n1633) );
  NAND2X1 U2866 ( .A(BA_RA[9]), .B(n2711), .Y(n2724) );
  OAI21X1 U2867 ( .A0(n2709), .A1(n2584), .B0(n2723), .Y(n1634) );
  NAND2X1 U2868 ( .A(BA_RA[8]), .B(n2711), .Y(n2723) );
  OAI21X1 U2869 ( .A0(n2709), .A1(n2585), .B0(n2722), .Y(n1635) );
  NAND2X1 U2870 ( .A(BA_RA[7]), .B(n2711), .Y(n2722) );
  OAI21X1 U2871 ( .A0(n2709), .A1(n2586), .B0(n2721), .Y(n1636) );
  NAND2X1 U2872 ( .A(BA_RA[6]), .B(n2711), .Y(n2721) );
  OAI21X1 U2873 ( .A0(n2709), .A1(n2587), .B0(n2720), .Y(n1637) );
  NAND2X1 U2874 ( .A(BA_RA[5]), .B(n2711), .Y(n2720) );
  OAI21X1 U2875 ( .A0(n2709), .A1(n2588), .B0(n2719), .Y(n1638) );
  NAND2X1 U2876 ( .A(BA_RA[4]), .B(n2711), .Y(n2719) );
  OAI21X1 U2877 ( .A0(n2709), .A1(n2589), .B0(n2718), .Y(n1639) );
  NAND2X1 U2878 ( .A(BA_RA[3]), .B(n2711), .Y(n2718) );
  OAI21X1 U2879 ( .A0(n2709), .A1(n2590), .B0(n2717), .Y(n1640) );
  NAND2X1 U2880 ( .A(BA_RA[2]), .B(n2711), .Y(n2717) );
  OAI21X1 U2881 ( .A0(n2709), .A1(n2591), .B0(n2716), .Y(n1641) );
  NAND2X1 U2882 ( .A(BA_RA[1]), .B(n2711), .Y(n2716) );
  OAI21X1 U2883 ( .A0(n2709), .A1(n2592), .B0(n2715), .Y(n1642) );
  NAND2X1 U2884 ( .A(BA_RA[0]), .B(n2711), .Y(n2715) );
  OAI21X1 U2885 ( .A0(n2709), .A1(n2593), .B0(n2714), .Y(n1643) );
  NAND2X1 U2886 ( .A(BA_TT[3]), .B(n2711), .Y(n2714) );
  OAI21X1 U2887 ( .A0(n2709), .A1(n2594), .B0(n2713), .Y(n1644) );
  NAND2X1 U2888 ( .A(BA_TT[2]), .B(n2711), .Y(n2713) );
  OAI21X1 U2889 ( .A0(n2709), .A1(n2595), .B0(n2712), .Y(n1645) );
  NAND2X1 U2890 ( .A(BA_TT[1]), .B(n2711), .Y(n2712) );
  OAI21X1 U2891 ( .A0(n2709), .A1(n2596), .B0(n2710), .Y(n1646) );
  NAND2X1 U2892 ( .A(BA_TT[0]), .B(n2711), .Y(n2710) );
  NAND3X1 U2893 ( .A(n3211), .B(n3212), .C(n3213), .Y(RAS_FULL486) );
  NAND3X1 U2894 ( .A(n206_1_), .B(n206_0_), .C(n206_2_), .Y(n3211) );
  DFFRX1 l_b0_last_ra_reg_0_ ( .D(n1463), .CK(ACLK), .RN(ARESETB), .Q(
        B0_LAST_RA[0]), .QN(net3179) );
  DFFRX1 l_b1_last_ra_reg_0_ ( .D(n1476), .CK(ACLK), .RN(ARESETB), .Q(
        B1_LAST_RA[0]), .QN(net3192) );
  NAND3BX1 U2895 ( .AN(ras_cnt_2_), .B(n3236), .C(n3237), .Y(n3232) );
  INVX1 U2896 ( .A(CMD[0]), .Y(n3233) );
  XOR2X1 U2897 ( .A(n2730), .B(ras_cnt_0_), .Y(n3209) );
  MXI2X1 U2898 ( .S0(n3208), .B(ras_cnt865_4_), .A(ras_cnt_4_), .Y(n3231) );
  OAI21X1 U2899 ( .A0(n2687), .A1(n3100), .B0(n3154), .Y(n1503) );
  NOR2X1 U2900 ( .A(n3155), .B(n3156), .Y(n3154) );
  NOR2X1 U2901 ( .A(n2805), .B(n3105), .Y(n3155) );
  NOR2X1 U2902 ( .A(n3104), .B(n1434), .Y(n3156) );
  OAI21X1 U2903 ( .A0(n2688), .A1(n3100), .B0(n3151), .Y(n1504) );
  NOR2X1 U2904 ( .A(n3152), .B(n3153), .Y(n3151) );
  NOR2X1 U2905 ( .A(n2801), .B(n3105), .Y(n3152) );
  NOR2X1 U2906 ( .A(n3104), .B(n1433), .Y(n3153) );
  OAI21X1 U2907 ( .A0(n2689), .A1(n3100), .B0(n3148), .Y(n1505) );
  NOR2X1 U2908 ( .A(n3149), .B(n3150), .Y(n3148) );
  NOR2X1 U2909 ( .A(n2797), .B(n3105), .Y(n3149) );
  NOR2X1 U2910 ( .A(n3104), .B(n1437), .Y(n3150) );
  OAI21X1 U2911 ( .A0(n2690), .A1(n3100), .B0(n3145), .Y(n1506) );
  NOR2X1 U2912 ( .A(n3146), .B(n3147), .Y(n3145) );
  NOR2X1 U2913 ( .A(n2793), .B(n3105), .Y(n3146) );
  NOR2X1 U2914 ( .A(n3104), .B(n1436), .Y(n3147) );
  OAI21X1 U2915 ( .A0(n2691), .A1(n3100), .B0(n3142), .Y(n1507) );
  NOR2X1 U2916 ( .A(n3143), .B(n3144), .Y(n3142) );
  NOR2X1 U2917 ( .A(n2789), .B(n3105), .Y(n3143) );
  NOR2X1 U2918 ( .A(n3104), .B(n1446), .Y(n3144) );
  OAI21X1 U2919 ( .A0(n2692), .A1(n3100), .B0(n3139), .Y(n1508) );
  NOR2X1 U2920 ( .A(n3140), .B(n3141), .Y(n3139) );
  NOR2X1 U2921 ( .A(n2785), .B(n3105), .Y(n3140) );
  NOR2X1 U2922 ( .A(n3104), .B(n1445), .Y(n3141) );
  OAI21X1 U2923 ( .A0(n2693), .A1(n3100), .B0(n3136), .Y(n1509) );
  NOR2X1 U2924 ( .A(n3137), .B(n3138), .Y(n3136) );
  NOR2X1 U2925 ( .A(n2781), .B(n3105), .Y(n3137) );
  NOR2X1 U2926 ( .A(n3104), .B(n1444), .Y(n3138) );
  OAI21X1 U2927 ( .A0(n2694), .A1(n3100), .B0(n3133), .Y(n1510) );
  NOR2X1 U2928 ( .A(n3134), .B(n3135), .Y(n3133) );
  NOR2X1 U2929 ( .A(n2777), .B(n3105), .Y(n3134) );
  NOR2X1 U2930 ( .A(n3104), .B(n1443), .Y(n3135) );
  OAI21X1 U2931 ( .A0(n2695), .A1(n3100), .B0(n3130), .Y(n1511) );
  NOR2X1 U2932 ( .A(n3131), .B(n3132), .Y(n3130) );
  NOR2X1 U2933 ( .A(n2773), .B(n3105), .Y(n3131) );
  NOR2X1 U2934 ( .A(n3104), .B(n1442), .Y(n3132) );
  OAI21X1 U2935 ( .A0(n2696), .A1(n3100), .B0(n3127), .Y(n1512) );
  NOR2X1 U2936 ( .A(n3128), .B(n3129), .Y(n3127) );
  NOR2X1 U2937 ( .A(n2769), .B(n3105), .Y(n3128) );
  NOR2X1 U2938 ( .A(n3104), .B(n1441), .Y(n3129) );
  OAI21X1 U2939 ( .A0(n2697), .A1(n3100), .B0(n3124), .Y(n1513) );
  NOR2X1 U2940 ( .A(n3125), .B(n3126), .Y(n3124) );
  NOR2X1 U2941 ( .A(n2765), .B(n3105), .Y(n3125) );
  NOR2X1 U2942 ( .A(n3104), .B(n1440), .Y(n3126) );
  OAI21X1 U2943 ( .A0(n2698), .A1(n3100), .B0(n3121), .Y(n1514) );
  NOR2X1 U2944 ( .A(n3122), .B(n3123), .Y(n3121) );
  NOR2X1 U2945 ( .A(n2761), .B(n3105), .Y(n3122) );
  NOR2X1 U2946 ( .A(n3104), .B(n1439), .Y(n3123) );
  OAI21X1 U2947 ( .A0(n2699), .A1(n3100), .B0(n3118), .Y(n1515) );
  NOR2X1 U2948 ( .A(n3119), .B(n3120), .Y(n3118) );
  NOR2X1 U2949 ( .A(n2757), .B(n3105), .Y(n3119) );
  NOR2X1 U2950 ( .A(n3104), .B(n1438), .Y(n3120) );
  OAI21X1 U2951 ( .A0(n2700), .A1(n3100), .B0(n3115), .Y(n1516) );
  NOR2X1 U2952 ( .A(n3116), .B(n3117), .Y(n3115) );
  NOR2X1 U2953 ( .A(n2753), .B(n3105), .Y(n3116) );
  NOR2X1 U2954 ( .A(n3104), .B(n1435), .Y(n3117) );
  OAI21X1 U2955 ( .A0(n2701), .A1(n3100), .B0(n3112), .Y(n1517) );
  NOR2X1 U2956 ( .A(n3113), .B(n3114), .Y(n3112) );
  NOR2X1 U2957 ( .A(n2749), .B(n3105), .Y(n3113) );
  NOR2X1 U2958 ( .A(n3104), .B(n1450), .Y(n3114) );
  OAI21X1 U2959 ( .A0(n2702), .A1(n3100), .B0(n3109), .Y(n1518) );
  NOR2X1 U2960 ( .A(n3110), .B(n3111), .Y(n3109) );
  NOR2X1 U2961 ( .A(n2745), .B(n3105), .Y(n3110) );
  NOR2X1 U2962 ( .A(n3104), .B(n1449), .Y(n3111) );
  OAI21X1 U2963 ( .A0(n2703), .A1(n3100), .B0(n3106), .Y(n1519) );
  NOR2X1 U2964 ( .A(n3107), .B(n3108), .Y(n3106) );
  NOR2X1 U2965 ( .A(n2741), .B(n3105), .Y(n3107) );
  NOR2X1 U2966 ( .A(n3104), .B(n1448), .Y(n3108) );
  OAI21X1 U2967 ( .A0(n2704), .A1(n3100), .B0(n3101), .Y(n1520) );
  NOR2X1 U2968 ( .A(n3102), .B(n3103), .Y(n3101) );
  NOR2X1 U2969 ( .A(n2736), .B(n3105), .Y(n3102) );
  NOR2X1 U2970 ( .A(n3104), .B(n1447), .Y(n3103) );
  NAND3X1 U2971 ( .A(n3222), .B(n3223), .C(n3224), .Y(n206_4_) );
  NAND2X1 U2972 ( .A(n3215), .B(ras_cnt_4_), .Y(n3222) );
  NAND2X1 U2973 ( .A(n2707), .B(ras_cnt865_4_), .Y(n3223) );
  NAND2X1 U2974 ( .A(n3099), .B(n3225), .Y(n3224) );
  NAND3X1 U2975 ( .A(n3219), .B(n3220), .C(n3221), .Y(n206_3_) );
  NAND2X1 U2976 ( .A(n3215), .B(ras_cnt_3_), .Y(n3219) );
  NAND2X1 U2977 ( .A(n2707), .B(ras_cnt865_3_), .Y(n3220) );
  NAND2X1 U2978 ( .A(ras_cnt822_3_), .B(n3099), .Y(n3221) );
  NAND3X1 U2979 ( .A(n3216), .B(n3217), .C(n3218), .Y(n206_1_) );
  NAND2X1 U2980 ( .A(ras_cnt_1_), .B(n3215), .Y(n3216) );
  NAND2X1 U2981 ( .A(ras_cnt822_1_), .B(n3099), .Y(n3218) );
  NAND2X1 U2982 ( .A(ras_cnt865_1_), .B(n2707), .Y(n3217) );
  NAND3X1 U2983 ( .A(n3226), .B(n3227), .C(n3228), .Y(n206_2_) );
  NAND2X1 U2984 ( .A(ras_cnt_2_), .B(n3215), .Y(n3226) );
  NAND2X1 U2985 ( .A(ras_cnt865_2_), .B(n2707), .Y(n3227) );
  NAND2X1 U2986 ( .A(ras_cnt822_2_), .B(n3099), .Y(n3228) );
  NAND2X1 U2987 ( .A(n3214), .B(n3158), .Y(n206_0_) );
  MXI2X1 U2988 ( .S0(ras_cnt_0_), .B(n3215), .A(n2707), .Y(n3214) );
  OAI21X1 U2989 ( .A0(n3175), .A1(net3194), .B0(n2567), .Y(n1478) );
  OAI21X1 U2990 ( .A0(n3175), .A1(net3195), .B0(n2568), .Y(n1479) );
  OAI21X1 U2991 ( .A0(n3175), .A1(net3196), .B0(n2569), .Y(n1480) );
  OAI21X1 U2992 ( .A0(n3175), .A1(net3197), .B0(n2570), .Y(n1481) );
  OAI21X1 U2993 ( .A0(n3175), .A1(net3198), .B0(n2571), .Y(n1482) );
  OAI21X1 U2994 ( .A0(n3175), .A1(net3199), .B0(n2572), .Y(n1483) );
  OAI21X1 U2995 ( .A0(n3175), .A1(net3200), .B0(n2573), .Y(n1484) );
  OAI21X1 U2996 ( .A0(n3175), .A1(net3201), .B0(n2574), .Y(n1485) );
  OAI21X1 U2997 ( .A0(n3175), .A1(net3202), .B0(n2575), .Y(n1486) );
  OAI21X1 U2998 ( .A0(n3175), .A1(net3203), .B0(n2576), .Y(n1487) );
  OAI21X1 U2999 ( .A0(n3175), .A1(net3204), .B0(n2577), .Y(n1488) );
  OAI21X1 U3000 ( .A0(n3175), .A1(net3205), .B0(n2578), .Y(n1489) );
  OAI21X1 U3001 ( .A0(n3177), .A1(net3181), .B0(n3190), .Y(n1465) );
  NAND2X1 U3002 ( .A(n3179), .B(BA_RA[11]), .Y(n3190) );
  OAI21X1 U3003 ( .A0(n3177), .A1(net3182), .B0(n3189), .Y(n1466) );
  NAND2X1 U3004 ( .A(n3179), .B(BA_RA[10]), .Y(n3189) );
  OAI21X1 U3005 ( .A0(n3177), .A1(net3183), .B0(n3188), .Y(n1467) );
  NAND2X1 U3006 ( .A(n3179), .B(BA_RA[9]), .Y(n3188) );
  OAI21X1 U3007 ( .A0(n3177), .A1(net3184), .B0(n3187), .Y(n1468) );
  NAND2X1 U3008 ( .A(n3179), .B(BA_RA[8]), .Y(n3187) );
  OAI21X1 U3009 ( .A0(n3177), .A1(net3185), .B0(n3186), .Y(n1469) );
  NAND2X1 U3010 ( .A(n3179), .B(BA_RA[7]), .Y(n3186) );
  OAI21X1 U3011 ( .A0(n3177), .A1(net3186), .B0(n3185), .Y(n1470) );
  NAND2X1 U3012 ( .A(n3179), .B(BA_RA[6]), .Y(n3185) );
  OAI21X1 U3013 ( .A0(n3177), .A1(net3187), .B0(n3184), .Y(n1471) );
  NAND2X1 U3014 ( .A(n3179), .B(BA_RA[5]), .Y(n3184) );
  OAI21X1 U3015 ( .A0(n3177), .A1(net3188), .B0(n3183), .Y(n1472) );
  NAND2X1 U3016 ( .A(n3179), .B(BA_RA[4]), .Y(n3183) );
  OAI21X1 U3017 ( .A0(n3177), .A1(net3189), .B0(n3182), .Y(n1473) );
  NAND2X1 U3018 ( .A(n3179), .B(BA_RA[3]), .Y(n3182) );
  OAI21X1 U3019 ( .A0(n3177), .A1(net3190), .B0(n3181), .Y(n1474) );
  NAND2X1 U3020 ( .A(n3179), .B(BA_RA[2]), .Y(n3181) );
  OAI21X1 U3021 ( .A0(n3177), .A1(net3191), .B0(n3180), .Y(n1475) );
  NAND2X1 U3022 ( .A(n3179), .B(BA_RA[1]), .Y(n3180) );
  OAI21X1 U3023 ( .A0(n3177), .A1(net3192), .B0(n3178), .Y(n1476) );
  NAND2X1 U3024 ( .A(n3179), .B(BA_RA[0]), .Y(n3178) );
  OAI21X1 U3025 ( .A0(n3159), .A1(net3207), .B0(n3172), .Y(n1491) );
  NAND2X1 U3026 ( .A(n3161), .B(BA_RA[11]), .Y(n3172) );
  OAI21X1 U3027 ( .A0(n3159), .A1(net3208), .B0(n3171), .Y(n1492) );
  NAND2X1 U3028 ( .A(n3161), .B(BA_RA[10]), .Y(n3171) );
  OAI21X1 U3029 ( .A0(n3159), .A1(net3209), .B0(n3170), .Y(n1493) );
  NAND2X1 U3030 ( .A(n3161), .B(BA_RA[9]), .Y(n3170) );
  OAI21X1 U3031 ( .A0(n3159), .A1(net3210), .B0(n3169), .Y(n1494) );
  NAND2X1 U3032 ( .A(n3161), .B(BA_RA[8]), .Y(n3169) );
  OAI21X1 U3033 ( .A0(n3159), .A1(net3211), .B0(n3168), .Y(n1495) );
  NAND2X1 U3034 ( .A(n3161), .B(BA_RA[7]), .Y(n3168) );
  OAI21X1 U3035 ( .A0(n3159), .A1(net3212), .B0(n3167), .Y(n1496) );
  NAND2X1 U3036 ( .A(n3161), .B(BA_RA[6]), .Y(n3167) );
  OAI21X1 U3037 ( .A0(n3159), .A1(net3213), .B0(n3166), .Y(n1497) );
  NAND2X1 U3038 ( .A(n3161), .B(BA_RA[5]), .Y(n3166) );
  OAI21X1 U3039 ( .A0(n3159), .A1(net3214), .B0(n3165), .Y(n1498) );
  NAND2X1 U3040 ( .A(n3161), .B(BA_RA[4]), .Y(n3165) );
  OAI21X1 U3041 ( .A0(n3159), .A1(net3215), .B0(n3164), .Y(n1499) );
  NAND2X1 U3042 ( .A(n3161), .B(BA_RA[3]), .Y(n3164) );
  OAI21X1 U3043 ( .A0(n3159), .A1(net3216), .B0(n3163), .Y(n1500) );
  NAND2X1 U3044 ( .A(n3161), .B(BA_RA[2]), .Y(n3163) );
  OAI21X1 U3045 ( .A0(n3159), .A1(net3217), .B0(n3162), .Y(n1501) );
  NAND2X1 U3046 ( .A(n3161), .B(BA_RA[1]), .Y(n3162) );
  OAI21X1 U3047 ( .A0(n3159), .A1(net3218), .B0(n3160), .Y(n1502) );
  NAND2X1 U3048 ( .A(n3161), .B(BA_RA[0]), .Y(n3160) );
  OAI21X1 U3049 ( .A0(n3192), .A1(net3168), .B0(n3205), .Y(n1452) );
  NAND2X1 U3050 ( .A(n3194), .B(BA_RA[11]), .Y(n3205) );
  OAI21X1 U3051 ( .A0(n3192), .A1(net3169), .B0(n3204), .Y(n1453) );
  NAND2X1 U3052 ( .A(n3194), .B(BA_RA[10]), .Y(n3204) );
  OAI21X1 U3053 ( .A0(n3192), .A1(net3170), .B0(n3203), .Y(n1454) );
  NAND2X1 U3054 ( .A(n3194), .B(BA_RA[9]), .Y(n3203) );
  OAI21X1 U3055 ( .A0(n3192), .A1(net3171), .B0(n3202), .Y(n1455) );
  NAND2X1 U3056 ( .A(n3194), .B(BA_RA[8]), .Y(n3202) );
  OAI21X1 U3057 ( .A0(n3192), .A1(net3172), .B0(n3201), .Y(n1456) );
  NAND2X1 U3058 ( .A(n3194), .B(BA_RA[7]), .Y(n3201) );
  OAI21X1 U3059 ( .A0(n3192), .A1(net3173), .B0(n3200), .Y(n1457) );
  NAND2X1 U3060 ( .A(n3194), .B(BA_RA[6]), .Y(n3200) );
  OAI21X1 U3061 ( .A0(n3192), .A1(net3174), .B0(n3199), .Y(n1458) );
  NAND2X1 U3062 ( .A(n3194), .B(BA_RA[5]), .Y(n3199) );
  OAI21X1 U3063 ( .A0(n3192), .A1(net3175), .B0(n3198), .Y(n1459) );
  NAND2X1 U3064 ( .A(n3194), .B(BA_RA[4]), .Y(n3198) );
  OAI21X1 U3065 ( .A0(n3192), .A1(net3176), .B0(n3197), .Y(n1460) );
  NAND2X1 U3066 ( .A(n3194), .B(BA_RA[3]), .Y(n3197) );
  OAI21X1 U3067 ( .A0(n3192), .A1(net3177), .B0(n3196), .Y(n1461) );
  NAND2X1 U3068 ( .A(n3194), .B(BA_RA[2]), .Y(n3196) );
  OAI21X1 U3069 ( .A0(n3192), .A1(net3178), .B0(n3195), .Y(n1462) );
  NAND2X1 U3070 ( .A(n3194), .B(BA_RA[1]), .Y(n3195) );
  OAI21X1 U3071 ( .A0(n3192), .A1(net3179), .B0(n3193), .Y(n1463) );
  NAND2X1 U3072 ( .A(n3194), .B(BA_RA[0]), .Y(n3193) );
  MXI2X1 U3073 ( .S0(n3177), .B(n3179), .A(net3180), .Y(n1464) );
  MXI2X1 U3074 ( .S0(n3159), .B(n3161), .A(net3206), .Y(n1490) );
  MXI2X1 U3075 ( .S0(n3192), .B(n3194), .A(net3167), .Y(n1451) );
  MX2X1 U3076 ( .S0(n3175), .B(n3176), .A(B2_LAST_RA[12]), .Y(n1477) );
  XNOR2X1 U1_A_1 ( .A(ras_cnt_1_), .B(ras_cnt_0_), .Y(ras_cnt865_1_) );
  XNOR2X1 U1_A_2 ( .A(ras_cnt_2_), .B(carry0), .Y(ras_cnt865_2_) );
  XOR2X1 U3077 ( .A(ras_cnt_4_), .B(n2708), .Y(ras_cnt865_4_) );
  NOR2X1 U3078 ( .A(ras_cnt_3_), .B(carry), .Y(n2708) );
  XNOR2X1 U1_A_3 ( .A(ras_cnt_3_), .B(carry), .Y(ras_cnt865_3_) );
  NOR2X1 U3079 ( .A(ras_cnt_1_), .B(ras_cnt_0_), .Y(n3237) );
  NOR2X1 U3080 ( .A(ras_cnt_4_), .B(ras_cnt_3_), .Y(n3236) );
  OR2X1 U1_B_1 ( .A(ras_cnt_1_), .B(ras_cnt_0_), .Y(carry0) );
  OR2X1 U1_B_2 ( .A(ras_cnt_2_), .B(carry0), .Y(carry) );
  DFFRX1 RAS_0_RA_reg_6_ ( .D(n1510), .CK(ACLK), .RN(ARESETB), .Q(RAS_0_RA[6]), 
        .QN(n1443) );
  DFFRX1 RAS_0_RA_reg_5_ ( .D(n1511), .CK(ACLK), .RN(ARESETB), .Q(RAS_0_RA[5]), 
        .QN(n1442) );
  DFFRX1 RAS_0_RA_reg_4_ ( .D(n1512), .CK(ACLK), .RN(ARESETB), .Q(RAS_0_RA[4]), 
        .QN(n1441) );
  DFFRX1 RAS_0_TT_reg_3_ ( .D(n1517), .CK(ACLK), .RN(ARESETB), .Q(RAS_0_TT[3]), 
        .QN(n1450) );
  DFFRX1 RAS_0_TT_reg_1_ ( .D(n1519), .CK(ACLK), .RN(ARESETB), .Q(RAS_0_TT[1]), 
        .QN(n1448) );
  DFFRX1 RAS_0_TT_reg_2_ ( .D(n1518), .CK(ACLK), .RN(ARESETB), .Q(RAS_0_TT[2]), 
        .QN(n1449) );
  DFFRX1 RAS_0_TT_reg_0_ ( .D(n1520), .CK(ACLK), .RN(ARESETB), .Q(RAS_0_TT[0]), 
        .QN(n1447) );
  DFFRX1 RAS_0_RA_reg_10_ ( .D(n1506), .CK(ACLK), .RN(ARESETB), .Q(
        RAS_0_RA[10]), .QN(n1436) );
  DFFRX1 RAS_0_RA_reg_2_ ( .D(n1514), .CK(ACLK), .RN(ARESETB), .Q(RAS_0_RA[2]), 
        .QN(n1439) );
  DFFRX1 RAS_0_RA_reg_1_ ( .D(n1515), .CK(ACLK), .RN(ARESETB), .Q(RAS_0_RA[1]), 
        .QN(n1438) );
  DFFRX1 RAS_0_RA_reg_0_ ( .D(n1516), .CK(ACLK), .RN(ARESETB), .Q(RAS_0_RA[0]), 
        .QN(n1435) );
  DFFRX1 RAS_0_RA_reg_7_ ( .D(n1509), .CK(ACLK), .RN(ARESETB), .Q(RAS_0_RA[7]), 
        .QN(n1444) );
  DFFRX1 RAS_0_RA_reg_3_ ( .D(n1513), .CK(ACLK), .RN(ARESETB), .Q(RAS_0_RA[3]), 
        .QN(n1440) );
  DFFRX1 RAS_0_RA_reg_11_ ( .D(n1505), .CK(ACLK), .RN(ARESETB), .Q(
        RAS_0_RA[11]), .QN(n1437) );
  DFFRX1 RAS_0_RA_reg_9_ ( .D(n1507), .CK(ACLK), .RN(ARESETB), .Q(RAS_0_RA[9]), 
        .QN(n1446) );
  DFFRX1 RAS_0_RA_reg_8_ ( .D(n1508), .CK(ACLK), .RN(ARESETB), .Q(RAS_0_RA[8]), 
        .QN(n1445) );
  DFFRX1 ras_cnt_reg_1_ ( .D(n206_1_), .CK(ACLK), .RN(ARESETB), .Q(ras_cnt_1_)
         );
  DFFRX1 ras_cnt_reg_0_ ( .D(n206_0_), .CK(ACLK), .RN(ARESETB), .Q(ras_cnt_0_)
         );
  DFFRX1 ras_cnt_reg_3_ ( .D(n206_3_), .CK(ACLK), .RN(ARESETB), .Q(ras_cnt_3_)
         );
  DFFRX1 ras_cnt_reg_2_ ( .D(n206_2_), .CK(ACLK), .RN(ARESETB), .Q(ras_cnt_2_)
         );
  DFFRX1 ras_cnt_reg_4_ ( .D(n206_4_), .CK(ACLK), .RN(ARESETB), .Q(ras_cnt_4_)
         );
  DFFRX1 l_b2_last_ra_reg_0_ ( .D(n1489), .CK(ACLK), .RN(ARESETB), .Q(
        B2_LAST_RA[0]), .QN(net3205) );
  DFFRX1 l_b3_last_ra_reg_0_ ( .D(n1502), .CK(ACLK), .RN(ARESETB), .Q(
        B3_LAST_RA[0]), .QN(net3218) );
  DFFRX1 l_b0_last_ra_reg_6_ ( .D(n1457), .CK(ACLK), .RN(ARESETB), .Q(
        B0_LAST_RA[6]), .QN(net3173) );
  DFFRX1 l_b0_last_ra_reg_1_ ( .D(n1462), .CK(ACLK), .RN(ARESETB), .Q(
        B0_LAST_RA[1]), .QN(net3178) );
  DFFRX1 l_b1_last_ra_reg_6_ ( .D(n1470), .CK(ACLK), .RN(ARESETB), .Q(
        B1_LAST_RA[6]), .QN(net3186) );
  DFFRX1 l_b1_last_ra_reg_1_ ( .D(n1475), .CK(ACLK), .RN(ARESETB), .Q(
        B1_LAST_RA[1]), .QN(net3191) );
  DFFRX1 l_b2_last_ra_reg_6_ ( .D(n1483), .CK(ACLK), .RN(ARESETB), .Q(
        B2_LAST_RA[6]), .QN(net3199) );
  DFFRX1 l_b2_last_ra_reg_1_ ( .D(n1488), .CK(ACLK), .RN(ARESETB), .Q(
        B2_LAST_RA[1]), .QN(net3204) );
  DFFRX1 l_b3_last_ra_reg_6_ ( .D(n1496), .CK(ACLK), .RN(ARESETB), .Q(
        B3_LAST_RA[6]), .QN(net3212) );
  DFFRX1 l_b3_last_ra_reg_1_ ( .D(n1501), .CK(ACLK), .RN(ARESETB), .Q(
        B3_LAST_RA[1]), .QN(net3217) );
  DFFRX1 l_b0_last_ra_reg_9_ ( .D(n1454), .CK(ACLK), .RN(ARESETB), .Q(
        B0_LAST_RA[9]), .QN(net3170) );
  DFFRX1 l_b0_last_ra_reg_2_ ( .D(n1461), .CK(ACLK), .RN(ARESETB), .Q(
        B0_LAST_RA[2]), .QN(net3177) );
  DFFRX1 l_b1_last_ra_reg_9_ ( .D(n1467), .CK(ACLK), .RN(ARESETB), .Q(
        B1_LAST_RA[9]), .QN(net3183) );
  DFFRX1 l_b1_last_ra_reg_2_ ( .D(n1474), .CK(ACLK), .RN(ARESETB), .Q(
        B1_LAST_RA[2]), .QN(net3190) );
  DFFRX1 l_b2_last_ra_reg_9_ ( .D(n1480), .CK(ACLK), .RN(ARESETB), .Q(
        B2_LAST_RA[9]), .QN(net3196) );
  DFFRX1 l_b2_last_ra_reg_2_ ( .D(n1487), .CK(ACLK), .RN(ARESETB), .Q(
        B2_LAST_RA[2]), .QN(net3203) );
  DFFRX1 l_b3_last_ra_reg_9_ ( .D(n1493), .CK(ACLK), .RN(ARESETB), .Q(
        B3_LAST_RA[9]), .QN(net3209) );
  DFFRX1 l_b3_last_ra_reg_2_ ( .D(n1500), .CK(ACLK), .RN(ARESETB), .Q(
        B3_LAST_RA[2]), .QN(net3216) );
  DFFRX1 l_b0_last_ra_reg_10_ ( .D(n1453), .CK(ACLK), .RN(ARESETB), .Q(
        B0_LAST_RA[10]), .QN(net3169) );
  DFFRX1 l_b0_last_ra_reg_4_ ( .D(n1459), .CK(ACLK), .RN(ARESETB), .Q(
        B0_LAST_RA[4]), .QN(net3175) );
  DFFRX1 l_b1_last_ra_reg_10_ ( .D(n1466), .CK(ACLK), .RN(ARESETB), .Q(
        B1_LAST_RA[10]), .QN(net3182) );
  DFFRX1 l_b1_last_ra_reg_4_ ( .D(n1472), .CK(ACLK), .RN(ARESETB), .Q(
        B1_LAST_RA[4]), .QN(net3188) );
  DFFRX1 l_b2_last_ra_reg_10_ ( .D(n1479), .CK(ACLK), .RN(ARESETB), .Q(
        B2_LAST_RA[10]), .QN(net3195) );
  DFFRX1 l_b2_last_ra_reg_4_ ( .D(n1485), .CK(ACLK), .RN(ARESETB), .Q(
        B2_LAST_RA[4]), .QN(net3201) );
  DFFRX1 l_b3_last_ra_reg_10_ ( .D(n1492), .CK(ACLK), .RN(ARESETB), .Q(
        B3_LAST_RA[10]), .QN(net3208) );
  DFFRX1 l_b3_last_ra_reg_4_ ( .D(n1498), .CK(ACLK), .RN(ARESETB), .Q(
        B3_LAST_RA[4]), .QN(net3214) );
  DFFRX1 l_b0_last_ra_reg_11_ ( .D(n1452), .CK(ACLK), .RN(ARESETB), .Q(
        B0_LAST_RA[11]), .QN(net3168) );
  DFFRX1 l_b0_last_ra_reg_5_ ( .D(n1458), .CK(ACLK), .RN(ARESETB), .Q(
        B0_LAST_RA[5]), .QN(net3174) );
  DFFRX1 l_b1_last_ra_reg_11_ ( .D(n1465), .CK(ACLK), .RN(ARESETB), .Q(
        B1_LAST_RA[11]), .QN(net3181) );
  DFFRX1 l_b1_last_ra_reg_5_ ( .D(n1471), .CK(ACLK), .RN(ARESETB), .Q(
        B1_LAST_RA[5]), .QN(net3187) );
  DFFRX1 l_b2_last_ra_reg_11_ ( .D(n1478), .CK(ACLK), .RN(ARESETB), .Q(
        B2_LAST_RA[11]), .QN(net3194) );
  DFFRX1 l_b2_last_ra_reg_5_ ( .D(n1484), .CK(ACLK), .RN(ARESETB), .Q(
        B2_LAST_RA[5]), .QN(net3200) );
  DFFRX1 l_b3_last_ra_reg_11_ ( .D(n1491), .CK(ACLK), .RN(ARESETB), .Q(
        B3_LAST_RA[11]), .QN(net3207) );
  DFFRX1 l_b3_last_ra_reg_5_ ( .D(n1497), .CK(ACLK), .RN(ARESETB), .Q(
        B3_LAST_RA[5]), .QN(net3213) );
  DFFRX1 l_b0_last_ra_reg_3_ ( .D(n1460), .CK(ACLK), .RN(ARESETB), .Q(
        B0_LAST_RA[3]), .QN(net3176) );
  DFFRX1 l_b1_last_ra_reg_3_ ( .D(n1473), .CK(ACLK), .RN(ARESETB), .Q(
        B1_LAST_RA[3]), .QN(net3189) );
  DFFRX1 l_b2_last_ra_reg_3_ ( .D(n1486), .CK(ACLK), .RN(ARESETB), .Q(
        B2_LAST_RA[3]), .QN(net3202) );
  DFFRX1 l_b3_last_ra_reg_3_ ( .D(n1499), .CK(ACLK), .RN(ARESETB), .Q(
        B3_LAST_RA[3]), .QN(net3215) );
  DFFRX1 l_b0_last_ra_reg_7_ ( .D(n1456), .CK(ACLK), .RN(ARESETB), .Q(
        B0_LAST_RA[7]), .QN(net3172) );
  DFFRX1 l_b1_last_ra_reg_7_ ( .D(n1469), .CK(ACLK), .RN(ARESETB), .Q(
        B1_LAST_RA[7]), .QN(net3185) );
  DFFRX1 l_b2_last_ra_reg_7_ ( .D(n1482), .CK(ACLK), .RN(ARESETB), .Q(
        B2_LAST_RA[7]), .QN(net3198) );
  DFFRX1 l_b3_last_ra_reg_7_ ( .D(n1495), .CK(ACLK), .RN(ARESETB), .Q(
        B3_LAST_RA[7]), .QN(net3211) );
  DFFRX1 l_b0_last_ra_reg_8_ ( .D(n1455), .CK(ACLK), .RN(ARESETB), .Q(
        B0_LAST_RA[8]), .QN(net3171) );
  DFFRX1 l_b1_last_ra_reg_8_ ( .D(n1468), .CK(ACLK), .RN(ARESETB), .Q(
        B1_LAST_RA[8]), .QN(net3184) );
  DFFRX1 l_b2_last_ra_reg_8_ ( .D(n1481), .CK(ACLK), .RN(ARESETB), .Q(
        B2_LAST_RA[8]), .QN(net3197) );
  DFFRX1 l_b3_last_ra_reg_8_ ( .D(n1494), .CK(ACLK), .RN(ARESETB), .Q(
        B3_LAST_RA[8]), .QN(net3210) );
  DFFSX1 l_b0_last_ra_reg_12_ ( .D(n1451), .CK(ACLK), .SN(ARESETB), .Q(
        B0_LAST_RA[12]), .QN(net3167) );
  DFFSX1 l_b1_last_ra_reg_12_ ( .D(n1464), .CK(ACLK), .SN(ARESETB), .Q(
        B1_LAST_RA[12]), .QN(net3180) );
  DFFSX1 l_b2_last_ra_reg_12_ ( .D(n1477), .CK(ACLK), .SN(ARESETB), .Q(
        B2_LAST_RA[12]) );
  DFFSX1 l_b3_last_ra_reg_12_ ( .D(n1490), .CK(ACLK), .SN(ARESETB), .Q(
        B3_LAST_RA[12]), .QN(net3206) );
  DFFRX1 RAS_FULL_reg ( .D(RAS_FULL486), .CK(ACLK), .RN(ARESETB), .Q(RAS_FULL)
         );
  DFFRX1 ras_1_data_reg_17_ ( .D(n1521), .CK(ACLK), .RN(ARESETB), .QN(n2687)
         );
  DFFRX1 ras_1_data_reg_16_ ( .D(n1522), .CK(ACLK), .RN(ARESETB), .QN(n2688)
         );
  DFFRX1 ras_1_data_reg_15_ ( .D(n1523), .CK(ACLK), .RN(ARESETB), .QN(n2689)
         );
  DFFRX1 ras_1_data_reg_14_ ( .D(n1524), .CK(ACLK), .RN(ARESETB), .QN(n2690)
         );
  DFFRX1 ras_1_data_reg_13_ ( .D(n1525), .CK(ACLK), .RN(ARESETB), .QN(n2691)
         );
  DFFRX1 ras_1_data_reg_12_ ( .D(n1526), .CK(ACLK), .RN(ARESETB), .QN(n2692)
         );
  DFFRX1 ras_1_data_reg_11_ ( .D(n1527), .CK(ACLK), .RN(ARESETB), .QN(n2693)
         );
  DFFRX1 ras_1_data_reg_10_ ( .D(n1528), .CK(ACLK), .RN(ARESETB), .QN(n2694)
         );
  DFFRX1 ras_1_data_reg_9_ ( .D(n1529), .CK(ACLK), .RN(ARESETB), .QN(n2695) );
  DFFRX1 ras_1_data_reg_8_ ( .D(n1530), .CK(ACLK), .RN(ARESETB), .QN(n2696) );
  DFFRX1 ras_1_data_reg_7_ ( .D(n1531), .CK(ACLK), .RN(ARESETB), .QN(n2697) );
  DFFRX1 ras_1_data_reg_6_ ( .D(n1532), .CK(ACLK), .RN(ARESETB), .QN(n2698) );
  DFFRX1 ras_1_data_reg_5_ ( .D(n1533), .CK(ACLK), .RN(ARESETB), .QN(n2699) );
  DFFRX1 ras_1_data_reg_4_ ( .D(n1534), .CK(ACLK), .RN(ARESETB), .QN(n2700) );
  DFFRX1 ras_1_data_reg_3_ ( .D(n1535), .CK(ACLK), .RN(ARESETB), .QN(n2701) );
  DFFRX1 ras_1_data_reg_2_ ( .D(n1536), .CK(ACLK), .RN(ARESETB), .QN(n2702) );
  DFFRX1 ras_1_data_reg_1_ ( .D(n1537), .CK(ACLK), .RN(ARESETB), .QN(n2703) );
  DFFRX1 ras_1_data_reg_0_ ( .D(n1538), .CK(ACLK), .RN(ARESETB), .QN(n2704) );
  DFFRX1 ras_2_data_reg_17_ ( .D(n1539), .CK(ACLK), .RN(ARESETB), .QN(n2597)
         );
  DFFRX1 ras_2_data_reg_16_ ( .D(n1540), .CK(ACLK), .RN(ARESETB), .QN(n2598)
         );
  DFFRX1 ras_2_data_reg_15_ ( .D(n1541), .CK(ACLK), .RN(ARESETB), .QN(n2599)
         );
  DFFRX1 ras_2_data_reg_14_ ( .D(n1542), .CK(ACLK), .RN(ARESETB), .QN(n2600)
         );
  DFFRX1 ras_2_data_reg_13_ ( .D(n1543), .CK(ACLK), .RN(ARESETB), .QN(n2601)
         );
  DFFRX1 ras_2_data_reg_12_ ( .D(n1544), .CK(ACLK), .RN(ARESETB), .QN(n2602)
         );
  DFFRX1 ras_2_data_reg_11_ ( .D(n1545), .CK(ACLK), .RN(ARESETB), .QN(n2603)
         );
  DFFRX1 ras_2_data_reg_10_ ( .D(n1546), .CK(ACLK), .RN(ARESETB), .QN(n2604)
         );
  DFFRX1 ras_2_data_reg_9_ ( .D(n1547), .CK(ACLK), .RN(ARESETB), .QN(n2605) );
  DFFRX1 ras_2_data_reg_8_ ( .D(n1548), .CK(ACLK), .RN(ARESETB), .QN(n2606) );
  DFFRX1 ras_2_data_reg_7_ ( .D(n1549), .CK(ACLK), .RN(ARESETB), .QN(n2607) );
  DFFRX1 ras_2_data_reg_6_ ( .D(n1550), .CK(ACLK), .RN(ARESETB), .QN(n2608) );
  DFFRX1 ras_2_data_reg_5_ ( .D(n1551), .CK(ACLK), .RN(ARESETB), .QN(n2609) );
  DFFRX1 ras_2_data_reg_4_ ( .D(n1552), .CK(ACLK), .RN(ARESETB), .QN(n2610) );
  DFFRX1 ras_2_data_reg_3_ ( .D(n1553), .CK(ACLK), .RN(ARESETB), .QN(n2611) );
  DFFRX1 ras_2_data_reg_2_ ( .D(n1554), .CK(ACLK), .RN(ARESETB), .QN(n2612) );
  DFFRX1 ras_2_data_reg_1_ ( .D(n1555), .CK(ACLK), .RN(ARESETB), .QN(n2613) );
  DFFRX1 ras_2_data_reg_0_ ( .D(n1556), .CK(ACLK), .RN(ARESETB), .QN(n2614) );
  DFFRX1 ras_3_data_reg_17_ ( .D(n1557), .CK(ACLK), .RN(ARESETB), .QN(n2615)
         );
  DFFRX1 ras_3_data_reg_16_ ( .D(n1558), .CK(ACLK), .RN(ARESETB), .QN(n2617)
         );
  DFFRX1 ras_3_data_reg_15_ ( .D(n1559), .CK(ACLK), .RN(ARESETB), .QN(n2619)
         );
  DFFRX1 ras_3_data_reg_14_ ( .D(n1560), .CK(ACLK), .RN(ARESETB), .QN(n2621)
         );
  DFFRX1 ras_3_data_reg_13_ ( .D(n1561), .CK(ACLK), .RN(ARESETB), .QN(n2623)
         );
  DFFRX1 ras_3_data_reg_12_ ( .D(n1562), .CK(ACLK), .RN(ARESETB), .QN(n2625)
         );
  DFFRX1 ras_3_data_reg_11_ ( .D(n1563), .CK(ACLK), .RN(ARESETB), .QN(n2627)
         );
  DFFRX1 ras_3_data_reg_10_ ( .D(n1564), .CK(ACLK), .RN(ARESETB), .QN(n2629)
         );
  DFFRX1 ras_3_data_reg_9_ ( .D(n1565), .CK(ACLK), .RN(ARESETB), .QN(n2631) );
  DFFRX1 ras_3_data_reg_8_ ( .D(n1566), .CK(ACLK), .RN(ARESETB), .QN(n2633) );
  DFFRX1 ras_3_data_reg_7_ ( .D(n1567), .CK(ACLK), .RN(ARESETB), .QN(n2635) );
  DFFRX1 ras_3_data_reg_6_ ( .D(n1568), .CK(ACLK), .RN(ARESETB), .QN(n2637) );
  DFFRX1 ras_3_data_reg_5_ ( .D(n1569), .CK(ACLK), .RN(ARESETB), .QN(n2639) );
  DFFRX1 ras_3_data_reg_4_ ( .D(n1570), .CK(ACLK), .RN(ARESETB), .QN(n2641) );
  DFFRX1 ras_3_data_reg_3_ ( .D(n1571), .CK(ACLK), .RN(ARESETB), .QN(n2643) );
  DFFRX1 ras_3_data_reg_2_ ( .D(n1572), .CK(ACLK), .RN(ARESETB), .QN(n2645) );
  DFFRX1 ras_3_data_reg_1_ ( .D(n1573), .CK(ACLK), .RN(ARESETB), .QN(n2647) );
  DFFRX1 ras_3_data_reg_0_ ( .D(n1574), .CK(ACLK), .RN(ARESETB), .QN(n2649) );
  DFFRX1 ras_4_data_reg_17_ ( .D(n1575), .CK(ACLK), .RN(ARESETB), .QN(n2616)
         );
  DFFRX1 ras_4_data_reg_16_ ( .D(n1576), .CK(ACLK), .RN(ARESETB), .QN(n2618)
         );
  DFFRX1 ras_4_data_reg_15_ ( .D(n1577), .CK(ACLK), .RN(ARESETB), .QN(n2620)
         );
  DFFRX1 ras_4_data_reg_14_ ( .D(n1578), .CK(ACLK), .RN(ARESETB), .QN(n2622)
         );
  DFFRX1 ras_4_data_reg_13_ ( .D(n1579), .CK(ACLK), .RN(ARESETB), .QN(n2624)
         );
  DFFRX1 ras_4_data_reg_12_ ( .D(n1580), .CK(ACLK), .RN(ARESETB), .QN(n2626)
         );
  DFFRX1 ras_4_data_reg_11_ ( .D(n1581), .CK(ACLK), .RN(ARESETB), .QN(n2628)
         );
  DFFRX1 ras_4_data_reg_10_ ( .D(n1582), .CK(ACLK), .RN(ARESETB), .QN(n2630)
         );
  DFFRX1 ras_4_data_reg_9_ ( .D(n1583), .CK(ACLK), .RN(ARESETB), .QN(n2632) );
  DFFRX1 ras_4_data_reg_8_ ( .D(n1584), .CK(ACLK), .RN(ARESETB), .QN(n2634) );
  DFFRX1 ras_4_data_reg_7_ ( .D(n1585), .CK(ACLK), .RN(ARESETB), .QN(n2636) );
  DFFRX1 ras_4_data_reg_6_ ( .D(n1586), .CK(ACLK), .RN(ARESETB), .QN(n2638) );
  DFFRX1 ras_4_data_reg_5_ ( .D(n1587), .CK(ACLK), .RN(ARESETB), .QN(n2640) );
  DFFRX1 ras_4_data_reg_4_ ( .D(n1588), .CK(ACLK), .RN(ARESETB), .QN(n2642) );
  DFFRX1 ras_4_data_reg_3_ ( .D(n1589), .CK(ACLK), .RN(ARESETB), .QN(n2644) );
  DFFRX1 ras_4_data_reg_2_ ( .D(n1590), .CK(ACLK), .RN(ARESETB), .QN(n2646) );
  DFFRX1 ras_4_data_reg_1_ ( .D(n1591), .CK(ACLK), .RN(ARESETB), .QN(n2648) );
  DFFRX1 ras_4_data_reg_0_ ( .D(n1592), .CK(ACLK), .RN(ARESETB), .QN(n2650) );
  DFFRX1 ras_5_data_reg_17_ ( .D(n1593), .CK(ACLK), .RN(ARESETB), .QN(n2651)
         );
  DFFRX1 ras_5_data_reg_16_ ( .D(n1594), .CK(ACLK), .RN(ARESETB), .QN(n2653)
         );
  DFFRX1 ras_5_data_reg_15_ ( .D(n1595), .CK(ACLK), .RN(ARESETB), .QN(n2655)
         );
  DFFRX1 ras_5_data_reg_14_ ( .D(n1596), .CK(ACLK), .RN(ARESETB), .QN(n2657)
         );
  DFFRX1 ras_5_data_reg_13_ ( .D(n1597), .CK(ACLK), .RN(ARESETB), .QN(n2659)
         );
  DFFRX1 ras_5_data_reg_12_ ( .D(n1598), .CK(ACLK), .RN(ARESETB), .QN(n2661)
         );
  DFFRX1 ras_5_data_reg_11_ ( .D(n1599), .CK(ACLK), .RN(ARESETB), .QN(n2663)
         );
  DFFRX1 ras_5_data_reg_10_ ( .D(n1600), .CK(ACLK), .RN(ARESETB), .QN(n2665)
         );
  DFFRX1 ras_5_data_reg_9_ ( .D(n1601), .CK(ACLK), .RN(ARESETB), .QN(n2667) );
  DFFRX1 ras_5_data_reg_8_ ( .D(n1602), .CK(ACLK), .RN(ARESETB), .QN(n2669) );
  DFFRX1 ras_5_data_reg_7_ ( .D(n1603), .CK(ACLK), .RN(ARESETB), .QN(n2671) );
  DFFRX1 ras_5_data_reg_6_ ( .D(n1604), .CK(ACLK), .RN(ARESETB), .QN(n2673) );
  DFFRX1 ras_5_data_reg_5_ ( .D(n1605), .CK(ACLK), .RN(ARESETB), .QN(n2675) );
  DFFRX1 ras_5_data_reg_4_ ( .D(n1606), .CK(ACLK), .RN(ARESETB), .QN(n2677) );
  DFFRX1 ras_5_data_reg_3_ ( .D(n1607), .CK(ACLK), .RN(ARESETB), .QN(n2679) );
  DFFRX1 ras_5_data_reg_2_ ( .D(n1608), .CK(ACLK), .RN(ARESETB), .QN(n2681) );
  DFFRX1 ras_5_data_reg_1_ ( .D(n1609), .CK(ACLK), .RN(ARESETB), .QN(n2683) );
  DFFRX1 ras_5_data_reg_0_ ( .D(n1610), .CK(ACLK), .RN(ARESETB), .QN(n2685) );
  DFFRX1 ras_6_data_reg_17_ ( .D(n1611), .CK(ACLK), .RN(ARESETB), .QN(n2652)
         );
  DFFRX1 ras_6_data_reg_16_ ( .D(n1612), .CK(ACLK), .RN(ARESETB), .QN(n2654)
         );
  DFFRX1 ras_6_data_reg_15_ ( .D(n1613), .CK(ACLK), .RN(ARESETB), .QN(n2656)
         );
  DFFRX1 ras_6_data_reg_14_ ( .D(n1614), .CK(ACLK), .RN(ARESETB), .QN(n2658)
         );
  DFFRX1 ras_6_data_reg_13_ ( .D(n1615), .CK(ACLK), .RN(ARESETB), .QN(n2660)
         );
  DFFRX1 ras_6_data_reg_12_ ( .D(n1616), .CK(ACLK), .RN(ARESETB), .QN(n2662)
         );
  DFFRX1 ras_6_data_reg_11_ ( .D(n1617), .CK(ACLK), .RN(ARESETB), .QN(n2664)
         );
  DFFRX1 ras_6_data_reg_10_ ( .D(n1618), .CK(ACLK), .RN(ARESETB), .QN(n2666)
         );
  DFFRX1 ras_6_data_reg_9_ ( .D(n1619), .CK(ACLK), .RN(ARESETB), .QN(n2668) );
  DFFRX1 ras_6_data_reg_8_ ( .D(n1620), .CK(ACLK), .RN(ARESETB), .QN(n2670) );
  DFFRX1 ras_6_data_reg_7_ ( .D(n1621), .CK(ACLK), .RN(ARESETB), .QN(n2672) );
  DFFRX1 ras_6_data_reg_6_ ( .D(n1622), .CK(ACLK), .RN(ARESETB), .QN(n2674) );
  DFFRX1 ras_6_data_reg_5_ ( .D(n1623), .CK(ACLK), .RN(ARESETB), .QN(n2676) );
  DFFRX1 ras_6_data_reg_4_ ( .D(n1624), .CK(ACLK), .RN(ARESETB), .QN(n2678) );
  DFFRX1 ras_6_data_reg_3_ ( .D(n1625), .CK(ACLK), .RN(ARESETB), .QN(n2680) );
  DFFRX1 ras_6_data_reg_2_ ( .D(n1626), .CK(ACLK), .RN(ARESETB), .QN(n2682) );
  DFFRX1 ras_6_data_reg_1_ ( .D(n1627), .CK(ACLK), .RN(ARESETB), .QN(n2684) );
  DFFRX1 ras_6_data_reg_0_ ( .D(n1628), .CK(ACLK), .RN(ARESETB), .QN(n2686) );
  DFFRX1 ras_7_data_reg_17_ ( .D(n1629), .CK(ACLK), .RN(ARESETB), .QN(n2579)
         );
  DFFRX1 ras_7_data_reg_16_ ( .D(n1630), .CK(ACLK), .RN(ARESETB), .QN(n2580)
         );
  DFFRX1 ras_7_data_reg_15_ ( .D(n1631), .CK(ACLK), .RN(ARESETB), .QN(n2581)
         );
  DFFRX1 ras_7_data_reg_14_ ( .D(n1632), .CK(ACLK), .RN(ARESETB), .QN(n2582)
         );
  DFFRX1 ras_7_data_reg_13_ ( .D(n1633), .CK(ACLK), .RN(ARESETB), .QN(n2583)
         );
  DFFRX1 ras_7_data_reg_12_ ( .D(n1634), .CK(ACLK), .RN(ARESETB), .QN(n2584)
         );
  DFFRX1 ras_7_data_reg_11_ ( .D(n1635), .CK(ACLK), .RN(ARESETB), .QN(n2585)
         );
  DFFRX1 ras_7_data_reg_10_ ( .D(n1636), .CK(ACLK), .RN(ARESETB), .QN(n2586)
         );
  DFFRX1 ras_7_data_reg_9_ ( .D(n1637), .CK(ACLK), .RN(ARESETB), .QN(n2587) );
  DFFRX1 ras_7_data_reg_8_ ( .D(n1638), .CK(ACLK), .RN(ARESETB), .QN(n2588) );
  DFFRX1 ras_7_data_reg_7_ ( .D(n1639), .CK(ACLK), .RN(ARESETB), .QN(n2589) );
  DFFRX1 ras_7_data_reg_6_ ( .D(n1640), .CK(ACLK), .RN(ARESETB), .QN(n2590) );
  DFFRX1 ras_7_data_reg_5_ ( .D(n1641), .CK(ACLK), .RN(ARESETB), .QN(n2591) );
  DFFRX1 ras_7_data_reg_4_ ( .D(n1642), .CK(ACLK), .RN(ARESETB), .QN(n2592) );
  DFFRX1 ras_7_data_reg_3_ ( .D(n1643), .CK(ACLK), .RN(ARESETB), .QN(n2593) );
  DFFRX1 ras_7_data_reg_2_ ( .D(n1644), .CK(ACLK), .RN(ARESETB), .QN(n2594) );
  DFFRX1 ras_7_data_reg_1_ ( .D(n1645), .CK(ACLK), .RN(ARESETB), .QN(n2595) );
  DFFRX1 ras_7_data_reg_0_ ( .D(n1646), .CK(ACLK), .RN(ARESETB), .QN(n2596) );
endmodule


module SDRCas ( ARESETB, ACLK, BA_BA, BA_RA, BA_CA, BA_TT, BA_ID, BA_RW, 
        BA_REQ, BA_PM, CMD, B0_LAST_RA, B1_LAST_RA, B2_LAST_RA, B3_LAST_RA, 
        CAS_0_BA, CAS_0_RA, CAS_0_CA, CAS_0_TT, CAS_0_ID, CAS_0_RW, CAS_0_PM, 
        CAS_0_FINAL, CAS_0_NEWROW, CAS_EMPTY, CAS_FULL );
  input [1:0] BA_BA;
  input [11:0] BA_RA;
  input [7:0] BA_CA;
  input [3:0] BA_TT;
  input [3:0] BA_ID;
  input [5:0] CMD;
  input [12:0] B0_LAST_RA;
  input [12:0] B1_LAST_RA;
  input [12:0] B2_LAST_RA;
  input [12:0] B3_LAST_RA;
  output [1:0] CAS_0_BA;
  output [11:0] CAS_0_RA;
  output [7:0] CAS_0_CA;
  output [3:0] CAS_0_TT;
  output [3:0] CAS_0_ID;
  input ARESETB, ACLK, BA_RW, BA_REQ, BA_PM;
  output CAS_0_RW, CAS_0_PM, CAS_0_FINAL, CAS_0_NEWROW, CAS_EMPTY, CAS_FULL;
  wire   cas_1_data_30_, cas_1_data_26_, cas_1_data_21_, cas_1_data_18_,
         cas_1_data_15_, cas_1_data_14_, cas_1_data_13_, cas_1_data_10_,
         cas_1_data_7_, cas_1_data_4_, cas_1_data_1_, cas_1_final,
         cas_1_newrow, cas_2_data_31_, cas_2_data_29_, cas_2_data_26_,
         cas_2_data_23_, cas_2_data_20_, cas_2_data_18_, cas_2_data_15_,
         cas_2_data_12_, cas_2_data_8_, cas_2_data_5_, cas_2_data_0_,
         cas_2_final, cas_2_newrow, cas_3_data_31_, cas_3_data_29_,
         cas_3_data_26_, cas_3_data_23_, cas_3_data_20_, cas_3_data_18_,
         cas_3_data_15_, cas_3_data_12_, cas_3_data_8_, cas_3_data_5_,
         cas_3_data_0_, cas_3_final, cas_3_newrow, cas_4_data_31_,
         cas_4_data_29_, cas_4_data_26_, cas_4_data_23_, cas_4_data_20_,
         cas_4_data_18_, cas_4_data_15_, cas_4_data_12_, cas_4_data_8_,
         cas_4_data_5_, cas_4_data_0_, cas_4_final, cas_4_newrow,
         cas_5_data_31_, cas_5_data_29_, cas_5_data_26_, cas_5_data_23_,
         cas_5_data_20_, cas_5_data_18_, cas_5_data_15_, cas_5_data_12_,
         cas_5_data_8_, cas_5_data_5_, cas_5_data_0_, cas_5_final,
         cas_6_data_31_, cas_6_data_29_, cas_6_data_26_, cas_6_data_23_,
         cas_6_data_20_, cas_6_data_18_, cas_6_data_15_, cas_6_data_12_,
         cas_6_data_8_, cas_6_data_5_, cas_6_data_0_, cas_6_final,
         cas_6_newrow, cas_7_final, cas_7_newrow, n181_3_, n181_2_, n181_0_,
         n429_4_, n429_3_, n429_2_, n429_1_, n429_0_, CAS_EMPTY914,
         CAS_FULL922, cas_cnt_4_, cas_cnt_3_, cas_cnt_2_, cas_cnt_1_,
         cas_cnt_0_, cas_cnt_b0_pos_4_, cas_cnt_b0_pos_3_, cas_cnt_b0_pos_2_,
         cas_cnt_b0_pos_1_, cas_cnt_b0_pos_0_, cas_cnt_b1_pos_4_,
         cas_cnt_b1_pos_3_, cas_cnt_b1_pos_2_, cas_cnt_b1_pos_1_,
         cas_cnt_b1_pos_0_, cas_cnt_b2_pos_4_, cas_cnt_b2_pos_3_,
         cas_cnt_b2_pos_2_, cas_cnt_b2_pos_1_, cas_cnt_b2_pos_0_,
         cas_cnt_b3_pos_4_, cas_cnt_b3_pos_3_, cas_cnt_b3_pos_2_,
         cas_cnt_b3_pos_1_, cas_cnt_b3_pos_0_, cas_cnt1375_3_, cas_cnt1375_2_,
         cas_cnt1375_1_, cas_cnt1419_3_, cas_cnt1419_2_, cas_cnt1419_1_,
         cas_cnt_b0_pos1445_4_, cas_cnt_b0_pos1445_3_, cas_cnt_b0_pos1445_2_,
         cas_cnt_b0_pos1445_1_, cas_cnt_b1_pos1456_4_, cas_cnt_b1_pos1456_3_,
         cas_cnt_b1_pos1456_2_, cas_cnt_b2_pos1467_4_, cas_cnt_b2_pos1467_3_,
         cas_cnt_b2_pos1467_2_, cas_cnt_b3_pos1478_4_, cas_cnt_b3_pos1478_3_,
         cas_cnt_b3_pos1478_2_, n2867, n2868, n2870, n2871, n2873, n2874,
         n2877, n2878, n2880, n2882, n2884, n2885, n2887, n2888, n2890, n2891,
         n2893, n2894, n2896, n2897, n2899, n2900, n2901, n2902, n2903, n2904,
         n2905, n2906, n2907, n2908, n2909, n2910, n2911, n2912, n2913, n2914,
         n2915, n2916, n2917, n2918, n2919, n2920, n2921, n2922, n2923, n2924,
         n2925, n2926, n2927, n2928, n2929, n2930, n2931, n2932, n2933, n2934,
         n2935, n2936, n2937, n2938, n2939, n2940, n2941, n2942, n2943, n2944,
         n2945, n2946, n2947, n2948, n2949, n2950, n2951, n2952, n2953, n2954,
         n2955, n2956, n2957, n2958, n2959, n2960, n2961, n2962, n2963, n2964,
         n2965, n2966, n2967, n2968, n2969, n2970, n2971, n2972, n2973, n2974,
         n2975, n2976, n2977, n2978, n2979, n2980, n2981, n2982, n2983, n2984,
         n2985, n2986, n2987, n2988, n2989, n2990, n2991, n2992, n2993, n2994,
         n2995, n2996, n2997, n2998, n2999, n3000, n3001, n3002, n3003, n3004,
         n3005, n3006, n3007, n3008, n3009, n3010, n3011, n3012, n3013, n3014,
         n3015, n3016, n3017, n3018, n3019, n3020, n3021, n3022, n3023, n3024,
         n3025, n3026, n3027, n3028, n3029, n3030, n3031, n3032, n3033, n3034,
         n3035, n3036, n3037, n3038, n3039, n3040, n3041, n3042, n3043, n3044,
         n3045, n3046, n3047, n3048, n3049, n3050, n3051, n3052, n3053, n3054,
         n3055, n3056, n3057, n3058, n3059, n3060, n3061, n3062, n3063, n3064,
         n3065, n3066, n3067, n3068, n3069, n3070, n3071, n3072, n3073, n3074,
         n3075, n3076, n3077, n3078, n3079, n3080, n3081, n3082, n3083, n3084,
         n3085, n3086, n3087, n3088, n3089, n3090, n3091, n3092, n3093, n3094,
         n3095, n3096, n3097, n3098, n3099, n3100, n3101, n3102, n3103, n3104,
         n3105, n3106, n3107, n3108, n3109, n3110, n3111, n3112, n3113, n3114,
         n3115, n3116, n3117, n3118, n3119, n3120, n3121, n3122, n3123, n3124,
         n3125, n3126, n3127, n3128, n3129, n3130, n3131, n3132, n3133, n3134,
         n3135, n3136, n3137, n3138, n3139, n3140, n3141, n3142, n3143, n3144,
         n3145, n3146, n3147, n3148, n3149, n3150, n3151, n3152, n3153, n3154,
         n3155, n3156, n3157, n3158, n3159, n3160, n3161, n3162, n3163, n3164,
         n3165, n3166, n3167, n3168, n3169, n3170, n3171, n3172, n3173, n3174,
         n3175, n3176, n3177, n3178, n3179, n3180, n3181, n3182, n3183, n3184,
         n3185, n3186, n3187, n3188, n3189, n3190, n3191, carry, carry0,
         carry1, carry2, carry3, n1, n2, n3, carry4, carry5, carry6, carry7,
         carry8, carry9, carry_3_, carry_2_, n4657, n4658, n4660, n4661, n4662,
         n4667, n4674, n4687, n4714, n4726, n4729, n4735, n4738, n4741, n4744,
         n4747, n4750, n4753, n4756, n4771, n4779, n4780, n4781, n4783, n4789,
         n4828, n4833, n4842, n4883, n4889, n4890, n4931, n4932, n4933, n4938,
         n4977, n4978, n4983, n5022, n5029, n5030, n5031, n5037, n5040, n5042,
         n5043, n5055, n5056, n5067, n5087, n5088, n5089, n5090, n5091, n5092,
         n5093, n5095, n5096, n5097, n5098, n5100, n5101, n5102, n5103, n5105,
         n5107, n5108, n5109, n5110, n5111, n5112, n5113, n5114, n5115, n5116,
         n5117, n5118, n5119, n5120, n5121, n5122, n5123, n5124, n5125, n5126,
         n5127, n5128, n5129, n5130, n5131, n5132, n5133, n5134, n5135, n5136,
         n5137, n5138, n5139, n5140, n5141, n5142, n5143, n5144, n5145, n5149,
         n5150, n5151, n5152, n5153, n5154, n5155, n5156, n5157, n5158, n5159,
         n5160, n5164, n5165, n5166, n5167, n5168, n5169, n5170, n5202, n5203,
         n5204, n5210, n5211, n5212, n5219, n5220, n5221, n5230, n5231, n5236,
         n5237, n5238, n5239, n5240, n5241, n5243, n5244, n5245, n5246, n5252,
         n5271, n5272, n5273, n5274, n5275, n5276, n5277, n5278, n5279, n5280,
         n5281, n5282, n5283, n5284, n5285, n5286, n5287, n5288, n5289, n5290,
         n5291, n5292, n5293, n5294, n5295, n5296, n5297, n5298, n5299, n5300,
         n5301, n5302, n5303, n5304, n5305, n5306, n5307, n5308, n5309, n5310,
         n5311, n5312, n5313, n5314, n5315, n5316, n5317, n5318, n5319, n5320,
         n5321, n5322, n5323, n5324, n5325, n5326, n5327, n5328, n5329, n5330,
         n5331, n5332, n5333, n5334, n5335, n5336, n5337, n5338, n5339, n5340,
         n5341, n5342, n5343, n5344, n5345, n5346, n5347, n5348, n5349, n5350,
         n5351, n5352, n5353, n5354, n5355, n5356, n5357, n5358, n5359, n5360,
         n5361, n5362, n5363, n5364, n5365, n5366, n5367, n5368, n5369, n5370,
         n5371, n5372, n5373, n5374, n5375, n5376, n5377, n5378, n5379, n5380,
         n5381, n5382, n5383, n5384, n5385, n5386, n5387, n5388, n5389, n5390,
         n5391, n5392, n5393, n5394, n5395, n5396, n5397, n5398, n5399, n5400,
         n5401, n5402, n5403, n5404, n5405, n5406, n5407, n5408, n5409, n5410,
         n5411, n5412, n5413, n5414, n5415, n5416, n5417, n5418, n5419, n5420,
         n5421, n5422, n5423, n5424, n5425, n5426, n5427, n5428, n5429, n5430,
         n5431, n5432, n5433, n5434, n5435, n5436, n5437, n5438, n5439, n5440,
         n5441, n5442, n5443, n5444, n5445, n5446, n5447, n5448, n5449, n5450,
         n5451, n5452, n5453, n5454, n5455, n5456, n5457, n5458, n5459, n5460,
         n5461, n5462, n5463, n5464, n5465, n5466, n5467, n5468, n5469, n5470,
         n5471, n5472, n5473, n5474, n5475, n5476, n5477, n5478, n5479, n5480,
         n5481, n5482, n5483, n5484, n5485, n5486, n5487, n5488, n5489, n5490,
         n5491, n5492, n5493, n5494, n5495, n5496, n5497, n5498, n5499, n5500,
         n5501, n5502, n5503, n5504, n5505, n5506, n5507, n5508, n5509, n5510,
         n5511, n5512, n5513, n5514, n5515, n5516, n5517, n5518, n5519, n5520,
         n5521, n5522, n5523, n5524, n5525, n5526, n5527, n5528, n5529, n5530,
         n5531, n5532, n5533, n5534, n5535, n5536, n5537, n5538, n5539, n5540,
         n5541, n5542, n5543, n5544, n5545, n5546, n5547, n5548, n5549, n5550,
         n5551, n5552, n5553, n5554, n5555, n5556, n5557, n5558, n5559, n5560,
         n5561, n5562, n5563, n5564, n5565, n5566, n5567, n5568, n5569, n5570,
         n5571, n5572, n5573, n5574, n5575, n5576, n5577, n5578, n5579, n5580,
         n5581, n5582, n5583, n5584, n5585, n5586, n5587, n5588, n5589, n5590,
         n5591, n5592, n5593, n5594, n5595, n5596, n5597, n5598, n5599, n5600,
         n5601, n5602, n5603, n5604, n5605, n5606, n5607, n5608, n5609, n5610,
         n5611, n5612, n5613, n5614, n5615, n5616, n5617, n5618, n5619, n5620,
         n5621, n5622, n5623, n5624, n5625, n5626, n5627, n5628, n5629, n5630,
         n5631, n5632, n5633, n5634, n5635, n5636, n5637, n5638, n5639, n5640,
         n5641, n5642, n5643, n5644, n5645, n5646, n5647, n5648, n5649, n5650,
         n5651, n5652, n5653, n5654, n5655, n5656, n5657, n5658, n5659, n5660,
         n5661, n5662, n5663, n5664, n5665, n5666, n5667, n5668, n5669, n5670,
         n5671, n5672, n5673, n5674, n5675, n5676, n5677, n5678, n5679, n5680,
         n5681, n5682, n5683, n5684, n5685, n5686, n5687, n5688, n5689, n5690,
         n5691, n5692, n5693, n5694, n5695, n5696, n5697, n5698, n5699, n5700,
         n5701, n5702, n5703, n5704, n5705, n5706, n5707, n5708, n5709, n5710,
         n5711, n5712, n5713, n5714, n5715, n5716, n5717, n5718, n5719, n5720,
         n5721, n5722, n5723, n5724, n5725, n5726, n5727, n5728, n5729, n5730,
         n5731, n5732, n5733, n5734, n5735, n5736, n5737, n5738, n5739, n5740,
         n5741, n5742, n5743, n5744, n5745, n5746, n5747, n5748, n5749, n5750,
         n5751, n5752, n5753, n5754, n5755, n5756, n5757, n5758, n5759, n5760,
         n5761, n5762, n5763, n5764, n5765, n5766, n5767, n5768, n5769, n5770,
         n5771, n5772, n5773, n5774, n5775, n5776, n5777, n5778, n5779, n5780,
         n5781, n5782, n5783, n5784, n5785, n5786, n5787, n5788, n5789, n5790,
         n5791, n5792, n5793, n5794, n5795, n5796, n5797, n5798, n5799, n5800,
         n5801, n5802, n5803, n5804, n5805, n5806, n5807, n5808, n5809, n5810,
         n5811, n5812, n5813, n5814, n5815, n5816, n5817, n5818, n5819, n5820,
         n5821, n5822, n5823, n5824, n5825, n5826, n5827, n5828, n5829, n5830,
         n5831, n5832, n5833, n5834, n5835, n5836, n5837, n5838, n5839, n5840,
         n5841, n5842, n5843, n5844, n5845, n5846, n5847, n5848, n5849, n5850,
         n5851, n5852, n5853, n5854, n5855, n5856, n5857, n5858, n5859, n5860,
         n5861, n5862, n5863, n5864, n5865, n5866, n5867, n5868, n5869, n5870,
         n5871, n5872, n5873, n5874, n5875, n5876, n5877, n5878, n5879, n5880,
         n5881, n5882, n5883, n5884, n5885, n5886, n5887, n5888, n5889, n5890,
         n5891, n5892, n5893, n5894, n5895, n5896, n5897, n5898, n5899, n5900,
         n5901, n5902, n5903, n5904, n5905, n5906, n5907, n5908, n5909, n5910,
         n5911, n5912, n5913, n5914, n5915, n5916, n5917, n5918, n5919, n5920,
         n5921, n5922, n5923, n5924, n5925, n5926, n5927, n5928, n5929, n5930,
         n5931, n5932, n5933, n5934, n5935, n5936, n5937, n5938, n5939, n5940,
         n5941, n5942, n5943, n5944, n5945, n5946, n5947, n5948, n5949, n5950,
         n5951, n5952, n5953, n5954, n5955, n5956, n5957, n5958, n5959, n5960,
         n5961, n5962, n5963, n5964, n5965, n5966, n5967, n5968, n5969, n5970,
         n5971, n5972, n5973, n5974, n5975, n5976, n5977, n5978, n5979, n5980,
         n5981, n5982, n5983, n5984, n5985, n5986, n5987, n5988, n5989, n5990,
         n5991, n5992, n5993, n5994, n5995, n5996, n5997, n5998, n5999, n6000,
         n6001, n6002, n6003, n6004, n6005, n6006, n6007, n6008, n6009, n6010,
         n6011, n6012, n6013, n6014, n6015, n6016, n6017, n6018, n6019, n6020,
         n6021, n6022, n6023, n6024, n6025, n6026, n6027, n6028, n6029, n6030,
         n6031, n6032, n6033, n6034, n6035, n6036, n6037, n6038, n6039, n6040,
         n6041, n6042, n6043, n6044, n6045, n6046, n6047, n6048, n6049, n6050,
         n6051, n6052, n6053, n6054, n6055, n6056, n6057, n6058, n6059, n6060,
         n6061, n6062, n6063, n6064, n6065, n6066, n6067, n6068, n6069, n6070,
         n6071, n6072, n6073, n6074, n6075, n6076, n6077, n6078, n6079, n6080,
         n6081, n6082, n6083, n6084, n6085, n6086, n6087, n6088, n6089, n6090,
         n6091, n6092, n6093, n6094, n6095, n6096, n6097, n6098, n6099, n6100,
         n6101, n6102, n6103, n6104, n6105, n6106, n6107, n6108, n6109, n6110,
         n6111, n6112, n6113, n6114, n6115, n6116, n6117, n6118, n6119, n6120,
         n6121, n6122, n6123, n6124, n6125, n6126, n6127, n6128, n6129, n6130,
         n6131, n6132, n6133, n6134, n6135, n6136, n6137, n6138, n6139, n6140,
         n6141, n6142, n6143, n6144, n6145, n6146, n6147, n6148, n6149, n6150,
         n6151, n6152, n6153, n6154, n6155, n6156, n6157, n6158, n6159, n6160,
         n6161, n6162, n6163, n6164, n6165, n6166, n6167, n6168, n6169, n6170,
         n6171, n6172, n6173, n6174, n6175, n6176, n6177, n6178, n6179, n6180,
         n6181, n6182, n6183, n6184, n6185, n6186, n6187, n6188, n6189, n6190,
         n6191, n6192, n6193, n6194, n6195, n6196, n6197, n6198, n6199, n6200,
         n6201, n6202, n6203, n6204, n6205, n6206, n6207, n6208, n6209, n6210,
         n6211, n6212, n6213, n6214, n6215, n6216, n6217, n6218, n6219, n6220,
         n6221, n6222, n6223, n6224, n6225, n6226, n6227, n6228, n6229, n6230,
         n6231, n6232, n6233, n6234, n6235, n6236, n6237, n6238, n6239, n6240,
         n6241, n6242, n6243, n6244, n6245, n6246, n6247, n6248, n6249, n6250,
         n6251, n6252, n6253, n6254, n6255, n6256, n6257, n6258, n6259, n6260,
         n6261, n6262, n6263, n6264, n6265, n6266, n6267, n6268, n6269, n6270,
         n6271, n6272, n6273, n6274, n6275, n6276, n6277, n6278, n6279, n6280,
         n6281, n6282, n6283, n6284, n6285, n6286, n6287, n6288, n6289, n6290,
         n6291, n6292, n6293, n6294, n6295, n6296, n6297, n6298, n6299, n6300,
         n6301, n6302, n6303, n6304, n6305, n6306, n6307, n6308, n6309, n6310,
         n6311, n6312, n6313, n6314, n6315, n6316, n6317, n6318, n6319, n6320,
         n6321, n6322, n6323, n6324, n6325, n6326, n6327, n6328, n6329, n6330,
         n6331, n6332, n6333, n6334, n6335, n6336, n6337, n6338, n6339, n6340,
         n6341, n6342, n6343, n6344, n6345, n6346, n6347, n6348, n6349, n6350,
         n6351, n6352, n6353, n6354, n6355, n6356, n6357, n6358, n6359, n6360,
         n6361, n6362, n6363, n6364, n6365, n6366, n6367, n6368, n6369, n6370,
         n6371, n6372, n6373, n6374, n6375, n6376, n6377, n6378, n6379, n6380,
         n6381, n6382, n6383, n6384, n6385, n6386, n6387, n6388, n6389, n6390,
         n6391, n6392, n6393, n6394, n6395, n6396, n6397, n6398, n6399, n6400,
         n6401, n6402, n6403, n6404, n6405, n6406, n6407, n6408, n6409, n6410,
         n6411, n6412, n6413, n6414, n6415, n6416, n6417, n6418, n6419, n6420,
         n6421, n6422, n6423, n6424, n6425, n6426, n6427, n6428, n6429, n6430,
         n6431, n6432, n6433, n6434, n6435, n6436, n6437, n6438, n6439, n6440,
         n6441, n6442, n6443, n6444, n6445, n6446, n6447, n6448, n6449, n6450,
         n6451, n6452, n6453, n6454, n6455, n6456, n6457, n6458, n6459, n6460,
         n6461, n6462, n6463, n6464, n6465, n6466, n6467, n6468, n6469, n6470,
         n6471, n6472, n6473, n6474, n6475, n6476, n6477, n6478, n6479, n6480,
         n6481, n6482, n6483, n6484, n6485, n6486, n6487, n6488, n6489, n6490,
         net3032, net3025, net2943, net2941, net2939, net2937, net2933,
         net2931, net2927, net2925, net2923, net2919, net2917, net2913,
         net2911, net2907, net2903, net2901, net2897, net2895, net2891,
         net2889, net2885;
  wire   [31:0] cas_7_data;

  AHHCONX2 U1_1_1 ( .A(n5536), .CI(n181_0_), .S(cas_cnt1419_1_), .CON(n3) );
  AHHCONX2 U1_1_2 ( .A(n181_2_), .CI(carry3), .S(cas_cnt1419_2_), .CON(n2) );
  AHHCONX2 U1_1_3 ( .A(n181_3_), .CI(carry2), .S(cas_cnt1419_3_), .CON(n1) );
  INVX1 U4787 ( .A(n5865), .Y(n5271) );
  INVX1 U4788 ( .A(n5271), .Y(n5272) );
  INVX3 U4789 ( .A(n5271), .Y(n5273) );
  NAND2X1 U4790 ( .A(n5555), .B(n181_2_), .Y(n4781) );
  MX2X1 U4791 ( .S0(n6481), .B(cas_cnt1375_2_), .A(cas_cnt_2_), .Y(n181_2_) );
  MXI2X1 U4792 ( .S0(n6481), .B(n5487), .A(net3032), .Y(n6363) );
  OAI222X1 U4793 ( .A0(n4833), .A1(n5302), .B0(n4771), .B1(n4842), .C0(n5427), 
        .C1(n5486), .Y(n3089) );
  OR2X1 U4794 ( .A(n6461), .B(n5466), .Y(n5278) );
  OR2X1 U4795 ( .A(n6460), .B(n5467), .Y(n5279) );
  DFFRX1 CAS_0_TT_reg_3_ ( .D(n2974), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_TT[3]), 
        .QN(n2899) );
  DFFRX1 CAS_0_TT_reg_2_ ( .D(n2975), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_TT[2])
         );
  DFFRX1 CAS_0_TT_reg_1_ ( .D(n2976), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_TT[1]), 
        .QN(n2897) );
  DFFSX1 CAS_EMPTY_reg ( .D(CAS_EMPTY914), .CK(ACLK), .SN(ARESETB), .Q(
        CAS_EMPTY) );
  INVX1 U4796 ( .A(n5500), .Y(n4842) );
  AND2X2 U4797 ( .A(n6489), .B(n5538), .Y(n5274) );
  AND2X2 U4798 ( .A(n5534), .B(n5538), .Y(n5275) );
  AND2X2 U4799 ( .A(n5538), .B(n6483), .Y(n5276) );
  AND2X2 U4800 ( .A(n5776), .B(n5541), .Y(n5277) );
  OR2X1 U4801 ( .A(n6463), .B(n5480), .Y(n5280) );
  OR2X1 U4802 ( .A(n6458), .B(n5443), .Y(n5281) );
  OR2X1 U4803 ( .A(n6458), .B(n5444), .Y(n5282) );
  OR2X1 U4804 ( .A(n6458), .B(n5445), .Y(n5283) );
  OR2X1 U4805 ( .A(n6458), .B(n5446), .Y(n5284) );
  OR2X1 U4806 ( .A(n6458), .B(n5447), .Y(n5285) );
  OR2X1 U4807 ( .A(n6458), .B(n5451), .Y(n5286) );
  OR2X1 U4808 ( .A(n6458), .B(n5448), .Y(n5287) );
  OR2X1 U4809 ( .A(n6458), .B(n5449), .Y(n5288) );
  OR2X1 U4810 ( .A(n6458), .B(n5450), .Y(n5289) );
  OR2X1 U4811 ( .A(n6458), .B(n5452), .Y(n5290) );
  OR2X1 U4812 ( .A(n6458), .B(n5453), .Y(n5291) );
  INVX3 U4813 ( .A(n5485), .Y(n5538) );
  AND4X2 U4814 ( .A(n6427), .B(n6428), .C(n6429), .D(n6430), .Y(n5485) );
  OR2X1 U4815 ( .A(n6485), .B(n6409), .Y(n5303) );
  NAND2X2 U4816 ( .A(n4883), .B(n6462), .Y(n5534) );
  INVX1 U4817 ( .A(n6363), .Y(n5553) );
  NAND2X1 U4818 ( .A(n5555), .B(n6361), .Y(n4932) );
  INVX1 U4819 ( .A(n181_2_), .Y(n6361) );
  MX2X1 U4820 ( .S0(n6480), .B(cas_cnt1375_1_), .A(cas_cnt_1_), .Y(n5536) );
  NAND2X1 U4821 ( .A(n6266), .B(n6265), .Y(n5483) );
  INVX1 U4822 ( .A(n5536), .Y(n6486) );
  AND2X1 U4823 ( .A(n5538), .B(n6265), .Y(n5484) );
  AND2X1 U4824 ( .A(n6480), .B(n6482), .Y(n5492) );
  NAND2X1 U4825 ( .A(n6437), .B(n6451), .Y(n5486) );
  NAND2X1 U4826 ( .A(n5534), .B(n6460), .Y(n5865) );
  INVX1 U4827 ( .A(n5501), .Y(n6489) );
  INVX1 U4828 ( .A(n5502), .Y(n6431) );
  AND2X1 U4829 ( .A(n6479), .B(n6490), .Y(n5495) );
  AND2X1 U4830 ( .A(n6480), .B(n5534), .Y(n5498) );
  INVX1 U4831 ( .A(n5502), .Y(n6432) );
  BUFX2 U4832 ( .A(n5690), .Y(n6483) );
  NAND2X1 U4833 ( .A(n5538), .B(n6265), .Y(n6266) );
  INVX1 U4834 ( .A(n4931), .Y(n4883) );
  NAND3BX1 U4835 ( .AN(n4932), .B(n181_0_), .C(n5536), .Y(n4931) );
  AND2X1 U4836 ( .A(n6480), .B(n6265), .Y(n5503) );
  NAND2X1 U4837 ( .A(n6259), .B(n6360), .Y(n6265) );
  MXI2X1 U4838 ( .S0(BA_RA[0]), .B(n6220), .A(n6219), .Y(n5545) );
  NAND2BX2 U4839 ( .AN(n181_3_), .B(n5553), .Y(n6362) );
  BUFX2 U4840 ( .A(BA_REQ), .Y(n6462) );
  INVX1 U4841 ( .A(BA_TT[0]), .Y(n4687) );
  INVX1 U4842 ( .A(BA_CA[5]), .Y(n4714) );
  INVX1 U4843 ( .A(BA_TT[1]), .Y(n5579) );
  INVX1 U4844 ( .A(BA_CA[7]), .Y(n5617) );
  INVX1 U4845 ( .A(BA_CA[4]), .Y(n5607) );
  INVX1 U4846 ( .A(BA_TT[2]), .Y(n5583) );
  INVX1 U4847 ( .A(BA_ID[0]), .Y(n5671) );
  XOR2X1 U4848 ( .A(n5538), .B(cas_cnt_0_), .Y(n6485) );
  XOR2X1 U4849 ( .A(cas_cnt_4_), .B(carry), .Y(n5487) );
  NAND3BX1 U4850 ( .AN(n5988), .B(n5984), .C(n5985), .Y(n3053) );
  NAND3BX1 U4851 ( .AN(n5687), .B(n5683), .C(n5684), .Y(n3155) );
  DFFRX1 CAS_0_BA_reg_0_ ( .D(n2953), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_BA[0])
         );
  NAND2X1 U4852 ( .A(n6483), .B(n6459), .Y(n5488) );
  NAND2X1 U4853 ( .A(n6483), .B(n6459), .Y(n5489) );
  INVX1 U4854 ( .A(n5496), .Y(n5490) );
  INVX1 U4855 ( .A(n6442), .Y(n5857) );
  INVX1 U4856 ( .A(n6441), .Y(n5847) );
  INVX1 U4857 ( .A(n6453), .Y(n5794) );
  INVX1 U4858 ( .A(n6452), .Y(n5781) );
  INVX1 U4859 ( .A(n6450), .Y(n5861) );
  BUFX2 U4860 ( .A(n5485), .Y(n6480) );
  BUFX2 U4861 ( .A(n5485), .Y(n6481) );
  INVX1 U4862 ( .A(n6455), .Y(n6451) );
  INVX1 U4863 ( .A(n6478), .Y(n5559) );
  INVX1 U4864 ( .A(n6476), .Y(n6076) );
  INVX1 U4865 ( .A(n6448), .Y(n6446) );
  INVX1 U4866 ( .A(n6448), .Y(n6445) );
  INVX1 U4867 ( .A(n6448), .Y(n6444) );
  INVX1 U4868 ( .A(n6447), .Y(n6443) );
  INVX1 U4869 ( .A(n6447), .Y(n6442) );
  INVX1 U4870 ( .A(n6447), .Y(n6441) );
  INVX1 U4871 ( .A(n6454), .Y(n6449) );
  INVX1 U4872 ( .A(n6455), .Y(n6453) );
  INVX1 U4873 ( .A(n6455), .Y(n6452) );
  INVX1 U4874 ( .A(n6454), .Y(n6450) );
  INVX1 U4875 ( .A(n6454), .Y(n4833) );
  BUFX2 U4876 ( .A(n5485), .Y(n6479) );
  INVX1 U4877 ( .A(n6468), .Y(n5675) );
  INVX1 U4878 ( .A(n6466), .Y(n5653) );
  INVX1 U4879 ( .A(n6464), .Y(n5636) );
  INVX1 U4880 ( .A(n6473), .Y(n5599) );
  INVX1 U4881 ( .A(n6472), .Y(n5587) );
  INVX1 U4882 ( .A(n6467), .Y(n5663) );
  INVX1 U4883 ( .A(n6465), .Y(n5643) );
  INVX1 U4884 ( .A(n6438), .Y(n5840) );
  INVX1 U4885 ( .A(n6440), .Y(n6438) );
  BUFX2 U4886 ( .A(n6474), .Y(n6470) );
  BUFX2 U4887 ( .A(n5562), .Y(n6467) );
  INVX1 U4888 ( .A(n6457), .Y(n6455) );
  BUFX2 U4889 ( .A(n5560), .Y(n6478) );
  BUFX2 U4890 ( .A(n6077), .Y(n6476) );
  BUFX2 U4891 ( .A(n5560), .Y(n6477) );
  BUFX2 U4892 ( .A(n6077), .Y(n6475) );
  INVX1 U4893 ( .A(n5488), .Y(n5685) );
  INVX1 U4894 ( .A(n6456), .Y(n6447) );
  BUFX2 U4895 ( .A(n6474), .Y(n6469) );
  BUFX2 U4896 ( .A(n5562), .Y(n6466) );
  BUFX2 U4897 ( .A(n5562), .Y(n6464) );
  BUFX2 U4898 ( .A(n5562), .Y(n6463) );
  BUFX2 U4899 ( .A(n6474), .Y(n6473) );
  BUFX2 U4900 ( .A(n6474), .Y(n6472) );
  BUFX2 U4901 ( .A(n6474), .Y(n6468) );
  BUFX2 U4902 ( .A(n6474), .Y(n6471) );
  BUFX2 U4903 ( .A(n5562), .Y(n6465) );
  INVX1 U4904 ( .A(n6457), .Y(n6454) );
  INVX1 U4905 ( .A(n6456), .Y(n6448) );
  INVX1 U4906 ( .A(n5533), .Y(n6440) );
  INVX1 U4907 ( .A(n5533), .Y(n6439) );
  INVX3 U4908 ( .A(n5274), .Y(n6461) );
  INVX3 U4909 ( .A(n5276), .Y(n6459) );
  XOR2X1 U4910 ( .A(CMD[4]), .B(CMD[0]), .Y(n6427) );
  INVX1 U4911 ( .A(n5497), .Y(n6458) );
  INVX1 U4912 ( .A(CMD[2]), .Y(n6429) );
  NOR2X1 U4913 ( .A(CMD[5]), .B(CMD[3]), .Y(n6430) );
  NAND2X1 U4914 ( .A(n5538), .B(n6431), .Y(n5562) );
  NAND2X1 U4915 ( .A(n6489), .B(n6461), .Y(n6077) );
  NAND2X1 U4916 ( .A(n5538), .B(n6431), .Y(n6474) );
  INVX1 U4917 ( .A(n6225), .Y(n6256) );
  NAND2X1 U4918 ( .A(n6431), .B(n6470), .Y(n5560) );
  INVX1 U4919 ( .A(n5272), .Y(n5864) );
  NAND2X1 U4920 ( .A(n6437), .B(n5538), .Y(n6457) );
  INVX1 U4921 ( .A(CMD[1]), .Y(n6428) );
  AND2X2 U4922 ( .A(n6479), .B(n4842), .Y(n5491) );
  INVX1 U4923 ( .A(n6483), .Y(n5692) );
  INVX1 U4924 ( .A(n6431), .Y(n5625) );
  AND2X2 U4925 ( .A(n6479), .B(n6431), .Y(n5493) );
  INVX1 U4926 ( .A(n5230), .Y(n4662) );
  NOR2BX1 U4927 ( .AN(n5538), .B(n5245), .Y(n5244) );
  AND2X2 U4928 ( .A(n6479), .B(n6489), .Y(n5494) );
  INVX1 U4929 ( .A(n5204), .Y(n6367) );
  NAND2X1 U4930 ( .A(n4842), .B(n5538), .Y(n5533) );
  NAND2X1 U4931 ( .A(n4842), .B(n5538), .Y(n6456) );
  INVX1 U4932 ( .A(n6432), .Y(n5682) );
  INVX3 U4933 ( .A(n5275), .Y(n6460) );
  AND2X2 U4934 ( .A(n6490), .B(n6458), .Y(n5496) );
  AND2X2 U4935 ( .A(n5535), .B(n5538), .Y(n5497) );
  NAND2X1 U4936 ( .A(n5667), .B(n5964), .Y(n6225) );
  INVX1 U4937 ( .A(n6223), .Y(n6240) );
  INVX1 U4938 ( .A(n5067), .Y(n6249) );
  INVX1 U4939 ( .A(n5091), .Y(n6245) );
  INVX1 U4940 ( .A(n6261), .Y(n6260) );
  INVX1 U4941 ( .A(n5770), .Y(n5541) );
  INVX1 U4942 ( .A(n6433), .Y(n4750) );
  INVX1 U4943 ( .A(n5500), .Y(n6437) );
  NAND2BX1 U4944 ( .AN(n4779), .B(n5231), .Y(n5230) );
  NAND2BX1 U4945 ( .AN(n4779), .B(n5231), .Y(n6488) );
  NAND2BX1 U4946 ( .AN(n4779), .B(n5231), .Y(n6487) );
  INVX1 U4947 ( .A(n5501), .Y(n6436) );
  BUFX2 U4948 ( .A(n5690), .Y(n6482) );
  BUFX2 U4949 ( .A(n5690), .Y(n6484) );
  INVX1 U4950 ( .A(n6409), .Y(n6414) );
  INVX1 U4951 ( .A(n5211), .Y(n6384) );
  INVX1 U4952 ( .A(n5203), .Y(n6368) );
  INVX1 U4953 ( .A(n5220), .Y(n6398) );
  INVX1 U4954 ( .A(n5202), .Y(n6369) );
  INVX1 U4955 ( .A(n5221), .Y(n6397) );
  INVX1 U4956 ( .A(n5212), .Y(n6383) );
  INVX1 U4957 ( .A(n5537), .Y(n5245) );
  NAND2X1 U4958 ( .A(n5203), .B(n5202), .Y(n5204) );
  INVX1 U4959 ( .A(n4658), .Y(n5231) );
  INVX1 U4960 ( .A(n5040), .Y(n6203) );
  AND2X2 U4961 ( .A(n6479), .B(n5537), .Y(n5499) );
  INVX1 U4962 ( .A(n429_4_), .Y(n5240) );
  INVX1 U4963 ( .A(n6435), .Y(n4735) );
  NAND2X1 U4964 ( .A(n6266), .B(n6265), .Y(n6261) );
  INVX3 U4965 ( .A(n6434), .Y(n6490) );
  INVX1 U4966 ( .A(n5535), .Y(n6434) );
  NOR3X1 U4967 ( .A(n5546), .B(n5548), .C(n5545), .Y(n4660) );
  INVX1 U4968 ( .A(BA_RA[10]), .Y(n4753) );
  NAND2X1 U4969 ( .A(BA_BA[0]), .B(n5667), .Y(n6223) );
  INVX1 U4970 ( .A(BA_RA[11]), .Y(n4756) );
  INVX1 U4971 ( .A(BA_BA[1]), .Y(n5667) );
  NAND2BX1 U4972 ( .AN(n6248), .B(n6249), .Y(n6193) );
  NAND2X1 U4973 ( .A(BA_BA[1]), .B(BA_BA[0]), .Y(n5067) );
  NAND2X1 U4974 ( .A(BA_BA[1]), .B(n5964), .Y(n5091) );
  NAND2X1 U4975 ( .A(n4783), .B(n6462), .Y(n5690) );
  NAND2X1 U4976 ( .A(n6248), .B(n6249), .Y(n5040) );
  AND2X2 U4977 ( .A(n5769), .B(n6462), .Y(n5500) );
  AND2X2 U4978 ( .A(n4978), .B(n6462), .Y(n5501) );
  AND2X2 U4979 ( .A(n4667), .B(n6462), .Y(n5502) );
  NAND2X1 U4980 ( .A(n6079), .B(n5987), .Y(n5770) );
  NOR2X1 U4981 ( .A(n4779), .B(n5544), .Y(n5539) );
  INVX1 U4982 ( .A(n5545), .Y(n5544) );
  NOR2X1 U4983 ( .A(n5546), .B(n5547), .Y(n4890) );
  NAND2X1 U4984 ( .A(n5545), .B(n5548), .Y(n5547) );
  BUFX2 U4985 ( .A(BA_RA[9]), .Y(n6433) );
  INVX1 U4986 ( .A(n5556), .Y(n5776) );
  INVX1 U4987 ( .A(n5042), .Y(n6205) );
  INVX1 U4988 ( .A(n4932), .Y(n6259) );
  INVX1 U4989 ( .A(n5022), .Y(n4978) );
  NAND3BX1 U4990 ( .AN(n4932), .B(n6486), .C(n181_0_), .Y(n5022) );
  INVX1 U4991 ( .A(n4828), .Y(n4783) );
  NAND3BX1 U4992 ( .AN(n4781), .B(n6486), .C(n181_0_), .Y(n4828) );
  INVX1 U4993 ( .A(n6195), .Y(n6194) );
  INVX1 U4994 ( .A(n5551), .Y(n4661) );
  INVX1 U4995 ( .A(n6265), .Y(n5031) );
  INVX1 U4996 ( .A(BA_RA[8]), .Y(n4747) );
  INVX1 U4997 ( .A(BA_RA[5]), .Y(n4738) );
  INVX1 U4998 ( .A(BA_RA[7]), .Y(n4744) );
  NAND3BX1 U4999 ( .AN(n4781), .B(n181_0_), .C(n5536), .Y(n4658) );
  INVX1 U5000 ( .A(BA_BA[0]), .Y(n5964) );
  INVX1 U5001 ( .A(BA_RA[6]), .Y(n4741) );
  NAND2X1 U5002 ( .A(n6256), .B(n6462), .Y(n6409) );
  AND2X2 U5003 ( .A(n6409), .B(n6415), .Y(n5504) );
  NAND2X1 U5004 ( .A(n6462), .B(n6245), .Y(n5211) );
  NAND2X1 U5005 ( .A(n6462), .B(n6249), .Y(n5203) );
  NAND2X1 U5006 ( .A(n6240), .B(n6462), .Y(n5220) );
  INVX1 U5007 ( .A(n6415), .Y(n6410) );
  NAND2X1 U5008 ( .A(n5552), .B(n5553), .Y(n429_4_) );
  NAND2X1 U5009 ( .A(n5245), .B(n5554), .Y(n5552) );
  INVX1 U5010 ( .A(n1), .Y(n5554) );
  NAND2X1 U5011 ( .A(n5555), .B(n6462), .Y(n5537) );
  NAND2X1 U5012 ( .A(n5203), .B(n6248), .Y(n5202) );
  INVX1 U5013 ( .A(n5210), .Y(n6385) );
  INVX1 U5014 ( .A(n5219), .Y(n6399) );
  NOR2X1 U5015 ( .A(n4933), .B(n5550), .Y(n5986) );
  NOR2X1 U5016 ( .A(n4667), .B(n5550), .Y(n5561) );
  NOR2X1 U5017 ( .A(n4978), .B(n5549), .Y(n6078) );
  NOR2X1 U5018 ( .A(n4783), .B(n5549), .Y(n5686) );
  NOR2X1 U5019 ( .A(n4883), .B(n5551), .Y(n5866) );
  NOR2X1 U5020 ( .A(n5769), .B(n5770), .Y(n5768) );
  NAND2X1 U5021 ( .A(n5211), .B(n5210), .Y(n5212) );
  NAND2X1 U5022 ( .A(n5220), .B(n5219), .Y(n5221) );
  INVX1 U5023 ( .A(n429_0_), .Y(n5236) );
  INVX1 U5024 ( .A(BA_RA[2]), .Y(n4729) );
  INVX1 U5025 ( .A(BA_RA[1]), .Y(n4726) );
  BUFX2 U5026 ( .A(BA_RA[4]), .Y(n6435) );
  INVX1 U5027 ( .A(BA_RA[3]), .Y(n5632) );
  INVX1 U5028 ( .A(BA_RA[0]), .Y(n5621) );
  INVX1 U5029 ( .A(BA_PM), .Y(n5874) );
  INVX1 U5030 ( .A(n6462), .Y(n4779) );
  INVX1 U5031 ( .A(BA_CA[3]), .Y(n5603) );
  INVX1 U5032 ( .A(BA_CA[0]), .Y(n5591) );
  INVX1 U5033 ( .A(BA_CA[1]), .Y(n5595) );
  INVX1 U5034 ( .A(BA_CA[2]), .Y(n5902) );
  INVX1 U5035 ( .A(BA_RW), .Y(n5572) );
  NOR3X1 U5036 ( .A(n5536), .B(n4779), .C(n181_0_), .Y(n6360) );
  NOR3X1 U5037 ( .A(n6227), .B(n6228), .C(n6229), .Y(n6219) );
  NOR3X1 U5038 ( .A(n5087), .B(n6221), .C(n6222), .Y(n6220) );
  OAI21X1 U5039 ( .A0(n5140), .A1(n5139), .B0(n6230), .Y(n6227) );
  DFFRX1 CAS_0_BA_reg_1_ ( .D(n2952), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_BA[1]), 
        .QN(n2867) );
  DFFRX1 CAS_0_TT_reg_0_ ( .D(n2977), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_TT[0]), 
        .QN(n2896) );
  NOR3X1 U5040 ( .A(n5546), .B(n5545), .C(n5543), .Y(n5867) );
  NAND3X1 U5041 ( .A(n6231), .B(n6462), .C(n6232), .Y(n5546) );
  NAND2X1 U5042 ( .A(n6258), .B(n6259), .Y(n6231) );
  INVX1 U5043 ( .A(n5542), .Y(n6232) );
  NOR2BX1 U5044 ( .AN(n6485), .B(n5536), .Y(n6258) );
  NAND4BX1 U5045 ( .AN(n6233), .B(n6234), .C(n6235), .D(n6236), .Y(n5542) );
  NOR2X1 U5046 ( .A(n6242), .B(n6243), .Y(n6235) );
  AOI21X1 U5047 ( .A0(n5506), .A1(n6250), .B0(n6251), .Y(n6234) );
  OAI21X1 U5048 ( .A0(n6253), .A1(n6195), .B0(n6254), .Y(n6233) );
  NOR3X1 U5049 ( .A(n4781), .B(n5536), .C(n181_0_), .Y(n5769) );
  NAND3X1 U5050 ( .A(n5545), .B(n5543), .C(n5777), .Y(n5556) );
  INVX1 U5051 ( .A(n5546), .Y(n5777) );
  NAND2X1 U5052 ( .A(n5987), .B(n5869), .Y(n5550) );
  NAND2X1 U5053 ( .A(n6079), .B(n5868), .Y(n5549) );
  INVX1 U5054 ( .A(n6485), .Y(n181_0_) );
  AOI21X1 U5055 ( .A0(n6205), .A1(cas_cnt_b1_pos_1_), .B0(n6206), .Y(n6196) );
  NOR2X1 U5056 ( .A(n5043), .B(n5532), .Y(n6206) );
  NAND2X1 U5057 ( .A(n5868), .B(n5869), .Y(n5551) );
  NAND2BX1 U5058 ( .AN(n6257), .B(n6256), .Y(n6195) );
  NAND2BX1 U5059 ( .AN(n6241), .B(n6240), .Y(n5043) );
  NAND2BX1 U5060 ( .AN(n6246), .B(n6245), .Y(n5037) );
  OAI21X1 U5061 ( .A0(n5302), .A1(n5273), .B0(n5976), .Y(n3055) );
  NOR2X1 U5062 ( .A(n5977), .B(n5978), .Y(n5976) );
  NOR2X1 U5063 ( .A(n5534), .B(n4771), .Y(n5977) );
  NOR2X1 U5064 ( .A(n6460), .B(n5313), .Y(n5978) );
  OAI21X1 U5065 ( .A0(n5355), .A1(n5273), .B0(n5968), .Y(n3057) );
  NOR2X1 U5066 ( .A(n5969), .B(n5970), .Y(n5968) );
  NOR2X1 U5067 ( .A(n5534), .B(n5671), .Y(n5969) );
  NOR2X1 U5068 ( .A(n6460), .B(n5314), .Y(n5970) );
  OAI21X1 U5069 ( .A0(n5356), .A1(n5273), .B0(n5965), .Y(n3058) );
  NOR2X1 U5070 ( .A(n5966), .B(n5967), .Y(n5965) );
  NOR2X1 U5071 ( .A(n5534), .B(n5667), .Y(n5966) );
  NOR2X1 U5072 ( .A(n6460), .B(n5315), .Y(n5967) );
  OAI21X1 U5073 ( .A0(n5298), .A1(n5273), .B0(n5957), .Y(n3060) );
  NOR2X1 U5074 ( .A(n5958), .B(n5959), .Y(n5957) );
  NOR2X1 U5075 ( .A(n5534), .B(n4756), .Y(n5958) );
  NOR2X1 U5076 ( .A(n6460), .B(n5316), .Y(n5959) );
  OAI21X1 U5077 ( .A0(n5357), .A1(n5273), .B0(n5954), .Y(n3061) );
  NOR2X1 U5078 ( .A(n5955), .B(n5956), .Y(n5954) );
  NOR2X1 U5079 ( .A(n5534), .B(n4753), .Y(n5955) );
  NOR2X1 U5080 ( .A(n6460), .B(n5317), .Y(n5956) );
  OAI21X1 U5081 ( .A0(n5358), .A1(n5273), .B0(n5947), .Y(n3063) );
  NOR2X1 U5082 ( .A(n5948), .B(n5949), .Y(n5947) );
  NOR2X1 U5083 ( .A(n5534), .B(n4747), .Y(n5948) );
  NOR2X1 U5084 ( .A(n6460), .B(n5318), .Y(n5949) );
  OAI21X1 U5085 ( .A0(n5297), .A1(n5273), .B0(n5944), .Y(n3064) );
  NOR2X1 U5086 ( .A(n5945), .B(n5946), .Y(n5944) );
  NOR2X1 U5087 ( .A(n5534), .B(n4744), .Y(n5945) );
  NOR2X1 U5088 ( .A(n6460), .B(n5319), .Y(n5946) );
  OAI21X1 U5089 ( .A0(n5359), .A1(n5273), .B0(n5937), .Y(n3066) );
  NOR2X1 U5090 ( .A(n5938), .B(n5939), .Y(n5937) );
  NOR2X1 U5091 ( .A(n5534), .B(n4738), .Y(n5938) );
  NOR2X1 U5092 ( .A(n6460), .B(n5320), .Y(n5939) );
  OAI21X1 U5093 ( .A0(n5360), .A1(n5273), .B0(n5930), .Y(n3068) );
  NOR2X1 U5094 ( .A(n5931), .B(n5932), .Y(n5930) );
  NOR2X1 U5095 ( .A(n5534), .B(n5632), .Y(n5931) );
  NOR2X1 U5096 ( .A(n6460), .B(n5321), .Y(n5932) );
  OAI21X1 U5097 ( .A0(n5299), .A1(n5273), .B0(n5927), .Y(n3069) );
  NOR2X1 U5098 ( .A(n5928), .B(n5929), .Y(n5927) );
  NOR2X1 U5099 ( .A(n5534), .B(n4729), .Y(n5928) );
  NOR2X1 U5100 ( .A(n6460), .B(n5322), .Y(n5929) );
  OAI21X1 U5101 ( .A0(n5361), .A1(n5273), .B0(n5920), .Y(n3071) );
  NOR2X1 U5102 ( .A(n5921), .B(n5922), .Y(n5920) );
  NOR2X1 U5103 ( .A(n5534), .B(n5621), .Y(n5921) );
  NOR2X1 U5104 ( .A(n6460), .B(n5323), .Y(n5922) );
  OAI21X1 U5105 ( .A0(n5362), .A1(n5273), .B0(n5917), .Y(n3072) );
  NOR2X1 U5106 ( .A(n5918), .B(n5919), .Y(n5917) );
  NOR2X1 U5107 ( .A(n5534), .B(n5617), .Y(n5918) );
  NOR2X1 U5108 ( .A(n6460), .B(n5324), .Y(n5919) );
  OAI21X1 U5109 ( .A0(n5300), .A1(n5273), .B0(n5909), .Y(n3074) );
  NOR2X1 U5110 ( .A(n5910), .B(n5911), .Y(n5909) );
  NOR2X1 U5111 ( .A(n5534), .B(n4714), .Y(n5910) );
  NOR2X1 U5112 ( .A(n6460), .B(n5325), .Y(n5911) );
  OAI21X1 U5113 ( .A0(n5363), .A1(n5273), .B0(n5906), .Y(n3075) );
  NOR2X1 U5114 ( .A(n5907), .B(n5908), .Y(n5906) );
  NOR2X1 U5115 ( .A(n5534), .B(n5607), .Y(n5907) );
  NOR2X1 U5116 ( .A(n6460), .B(n5326), .Y(n5908) );
  OAI21X1 U5117 ( .A0(n5364), .A1(n5273), .B0(n5903), .Y(n3076) );
  NOR2X1 U5118 ( .A(n5904), .B(n5905), .Y(n5903) );
  NOR2X1 U5119 ( .A(n5534), .B(n5603), .Y(n5904) );
  NOR2X1 U5120 ( .A(n6460), .B(n5327), .Y(n5905) );
  OAI21X1 U5121 ( .A0(n5365), .A1(n5273), .B0(n5895), .Y(n3078) );
  NOR2X1 U5122 ( .A(n5896), .B(n5897), .Y(n5895) );
  NOR2X1 U5123 ( .A(n5534), .B(n5595), .Y(n5896) );
  NOR2X1 U5124 ( .A(n6460), .B(n5328), .Y(n5897) );
  OAI21X1 U5125 ( .A0(n5366), .A1(n5273), .B0(n5892), .Y(n3079) );
  NOR2X1 U5126 ( .A(n5893), .B(n5894), .Y(n5892) );
  NOR2X1 U5127 ( .A(n5534), .B(n5591), .Y(n5893) );
  NOR2X1 U5128 ( .A(n6460), .B(n5329), .Y(n5894) );
  OAI21X1 U5129 ( .A0(n5367), .A1(n5273), .B0(n5884), .Y(n3081) );
  NOR2X1 U5130 ( .A(n5885), .B(n5886), .Y(n5884) );
  NOR2X1 U5131 ( .A(n5534), .B(n5583), .Y(n5885) );
  NOR2X1 U5132 ( .A(n6460), .B(n5330), .Y(n5886) );
  OAI21X1 U5133 ( .A0(n5368), .A1(n5273), .B0(n5881), .Y(n3082) );
  NOR2X1 U5134 ( .A(n5882), .B(n5883), .Y(n5881) );
  NOR2X1 U5135 ( .A(n5534), .B(n5579), .Y(n5882) );
  NOR2X1 U5136 ( .A(n6460), .B(n5331), .Y(n5883) );
  OAI21X1 U5137 ( .A0(n5301), .A1(n5273), .B0(n5878), .Y(n3083) );
  NOR2X1 U5138 ( .A(n5879), .B(n5880), .Y(n5878) );
  NOR2X1 U5139 ( .A(n5534), .B(n4687), .Y(n5879) );
  NOR2X1 U5140 ( .A(n6460), .B(n5332), .Y(n5880) );
  OAI21X1 U5141 ( .A0(n5369), .A1(n5273), .B0(n5875), .Y(n3084) );
  NOR2X1 U5142 ( .A(n5876), .B(n5877), .Y(n5875) );
  NOR2X1 U5143 ( .A(n5534), .B(n5572), .Y(n5876) );
  NOR2X1 U5144 ( .A(n6460), .B(n5333), .Y(n5877) );
  NOR2X1 U5145 ( .A(n6461), .B(n5387), .Y(n6185) );
  NOR2X1 U5146 ( .A(n6461), .B(n5388), .Y(n6178) );
  NOR2X1 U5147 ( .A(n6461), .B(n5373), .Y(n6158) );
  NOR2X1 U5148 ( .A(n6461), .B(n5375), .Y(n6148) );
  NOR2X1 U5149 ( .A(n6461), .B(n5379), .Y(n6121) );
  NOR2X1 U5150 ( .A(n6461), .B(n5382), .Y(n6108) );
  NOR2X1 U5151 ( .A(n6461), .B(n5384), .Y(n6098) );
  NOR2X1 U5152 ( .A(n6461), .B(n5390), .Y(n6082) );
  NOR2X1 U5153 ( .A(n6459), .B(n5428), .Y(n5687) );
  AND2X2 U5154 ( .A(n6256), .B(n6257), .Y(n5505) );
  INVX1 U5155 ( .A(n5543), .Y(n5548) );
  OAI21X1 U5156 ( .A0(n5313), .A1(n5490), .B0(n6069), .Y(n3021) );
  NOR2X1 U5157 ( .A(n6070), .B(n6071), .Y(n6069) );
  NOR2X1 U5158 ( .A(n6490), .B(n4771), .Y(n6070) );
  NOR2X1 U5159 ( .A(n6458), .B(n5334), .Y(n6071) );
  OAI21X1 U5160 ( .A0(n5314), .A1(n5490), .B0(n6064), .Y(n3023) );
  NOR2X1 U5161 ( .A(n6065), .B(n6066), .Y(n6064) );
  NOR2X1 U5162 ( .A(n6490), .B(n5671), .Y(n6065) );
  NOR2X1 U5163 ( .A(n6458), .B(n5335), .Y(n6066) );
  OAI21X1 U5164 ( .A0(n5315), .A1(n5490), .B0(n6061), .Y(n3024) );
  NOR2X1 U5165 ( .A(n6062), .B(n6063), .Y(n6061) );
  NOR2X1 U5166 ( .A(n6490), .B(n5667), .Y(n6062) );
  NOR2X1 U5167 ( .A(n6458), .B(n5336), .Y(n6063) );
  OAI21X1 U5168 ( .A0(n5316), .A1(n5490), .B0(n6056), .Y(n3026) );
  NOR2X1 U5169 ( .A(n6057), .B(n6058), .Y(n6056) );
  NOR2X1 U5170 ( .A(n6490), .B(n4756), .Y(n6057) );
  NOR2X1 U5171 ( .A(n6458), .B(n5337), .Y(n6058) );
  OAI21X1 U5172 ( .A0(n5317), .A1(n5490), .B0(n6053), .Y(n3027) );
  NOR2X1 U5173 ( .A(n6054), .B(n6055), .Y(n6053) );
  NOR2X1 U5174 ( .A(n6490), .B(n4753), .Y(n6054) );
  NOR2X1 U5175 ( .A(n6458), .B(n5338), .Y(n6055) );
  OAI21X1 U5176 ( .A0(n5318), .A1(n5490), .B0(n6048), .Y(n3029) );
  NOR2X1 U5177 ( .A(n6049), .B(n6050), .Y(n6048) );
  NOR2X1 U5178 ( .A(n6490), .B(n4747), .Y(n6049) );
  NOR2X1 U5179 ( .A(n6458), .B(n5339), .Y(n6050) );
  OAI21X1 U5180 ( .A0(n5319), .A1(n5490), .B0(n6045), .Y(n3030) );
  NOR2X1 U5181 ( .A(n6046), .B(n6047), .Y(n6045) );
  NOR2X1 U5182 ( .A(n6490), .B(n4744), .Y(n6046) );
  NOR2X1 U5183 ( .A(n6458), .B(n5340), .Y(n6047) );
  OAI21X1 U5184 ( .A0(n5320), .A1(n5490), .B0(n6040), .Y(n3032) );
  NOR2X1 U5185 ( .A(n6041), .B(n6042), .Y(n6040) );
  NOR2X1 U5186 ( .A(n6490), .B(n4738), .Y(n6041) );
  NOR2X1 U5187 ( .A(n6458), .B(n5341), .Y(n6042) );
  OAI21X1 U5188 ( .A0(n5321), .A1(n5490), .B0(n6035), .Y(n3034) );
  NOR2X1 U5189 ( .A(n6036), .B(n6037), .Y(n6035) );
  NOR2X1 U5190 ( .A(n6490), .B(n5632), .Y(n6036) );
  NOR2X1 U5191 ( .A(n6458), .B(n5342), .Y(n6037) );
  OAI21X1 U5192 ( .A0(n5322), .A1(n5490), .B0(n6032), .Y(n3035) );
  NOR2X1 U5193 ( .A(n6033), .B(n6034), .Y(n6032) );
  NOR2X1 U5194 ( .A(n6490), .B(n4729), .Y(n6033) );
  NOR2X1 U5195 ( .A(n6458), .B(n5343), .Y(n6034) );
  OAI21X1 U5196 ( .A0(n5323), .A1(n5490), .B0(n6027), .Y(n3037) );
  NOR2X1 U5197 ( .A(n6028), .B(n6029), .Y(n6027) );
  NOR2X1 U5198 ( .A(n6490), .B(n5621), .Y(n6028) );
  NOR2X1 U5199 ( .A(n6458), .B(n5344), .Y(n6029) );
  OAI21X1 U5200 ( .A0(n5324), .A1(n5490), .B0(n6024), .Y(n3038) );
  NOR2X1 U5201 ( .A(n6025), .B(n6026), .Y(n6024) );
  NOR2X1 U5202 ( .A(n6490), .B(n5617), .Y(n6025) );
  NOR2X1 U5203 ( .A(n6458), .B(n5345), .Y(n6026) );
  OAI21X1 U5204 ( .A0(n5325), .A1(n5490), .B0(n6019), .Y(n3040) );
  NOR2X1 U5205 ( .A(n6020), .B(n6021), .Y(n6019) );
  NOR2X1 U5206 ( .A(n6490), .B(n4714), .Y(n6020) );
  NOR2X1 U5207 ( .A(n6458), .B(n5346), .Y(n6021) );
  OAI21X1 U5208 ( .A0(n5326), .A1(n5490), .B0(n6016), .Y(n3041) );
  NOR2X1 U5209 ( .A(n6017), .B(n6018), .Y(n6016) );
  NOR2X1 U5210 ( .A(n6490), .B(n5607), .Y(n6017) );
  NOR2X1 U5211 ( .A(n6458), .B(n5347), .Y(n6018) );
  OAI21X1 U5212 ( .A0(n5327), .A1(n5490), .B0(n6013), .Y(n3042) );
  NOR2X1 U5213 ( .A(n6014), .B(n6015), .Y(n6013) );
  NOR2X1 U5214 ( .A(n6490), .B(n5603), .Y(n6014) );
  NOR2X1 U5215 ( .A(n6458), .B(n5348), .Y(n6015) );
  OAI21X1 U5216 ( .A0(n5328), .A1(n5490), .B0(n6008), .Y(n3044) );
  NOR2X1 U5217 ( .A(n6009), .B(n6010), .Y(n6008) );
  NOR2X1 U5218 ( .A(n6490), .B(n5595), .Y(n6009) );
  NOR2X1 U5219 ( .A(n6458), .B(n5349), .Y(n6010) );
  OAI21X1 U5220 ( .A0(n5329), .A1(n5490), .B0(n6005), .Y(n3045) );
  NOR2X1 U5221 ( .A(n6006), .B(n6007), .Y(n6005) );
  NOR2X1 U5222 ( .A(n6490), .B(n5591), .Y(n6006) );
  NOR2X1 U5223 ( .A(n6458), .B(n5350), .Y(n6007) );
  OAI21X1 U5224 ( .A0(n5330), .A1(n5490), .B0(n6000), .Y(n3047) );
  NOR2X1 U5225 ( .A(n6001), .B(n6002), .Y(n6000) );
  NOR2X1 U5226 ( .A(n6490), .B(n5583), .Y(n6001) );
  NOR2X1 U5227 ( .A(n6458), .B(n5351), .Y(n6002) );
  OAI21X1 U5228 ( .A0(n5331), .A1(n5490), .B0(n5997), .Y(n3048) );
  NOR2X1 U5229 ( .A(n5998), .B(n5999), .Y(n5997) );
  NOR2X1 U5230 ( .A(n6490), .B(n5579), .Y(n5998) );
  NOR2X1 U5231 ( .A(n6458), .B(n5352), .Y(n5999) );
  OAI21X1 U5232 ( .A0(n5332), .A1(n5490), .B0(n5994), .Y(n3049) );
  NOR2X1 U5233 ( .A(n5995), .B(n5996), .Y(n5994) );
  NOR2X1 U5234 ( .A(n6490), .B(n4687), .Y(n5995) );
  NOR2X1 U5235 ( .A(n6458), .B(n5353), .Y(n5996) );
  OAI21X1 U5236 ( .A0(n5333), .A1(n5490), .B0(n5991), .Y(n3050) );
  NOR2X1 U5237 ( .A(n5992), .B(n5993), .Y(n5991) );
  NOR2X1 U5238 ( .A(n6490), .B(n5572), .Y(n5992) );
  NOR2X1 U5239 ( .A(n6458), .B(n5354), .Y(n5993) );
  OAI21X1 U5240 ( .A0(n5391), .A1(n5489), .B0(n5762), .Y(n3123) );
  NOR2X1 U5241 ( .A(n5763), .B(n5764), .Y(n5762) );
  NOR2X1 U5242 ( .A(n4771), .B(n6484), .Y(n5763) );
  NOR2X1 U5243 ( .A(n5427), .B(n6459), .Y(n5764) );
  OAI21X1 U5244 ( .A0(n5392), .A1(n5489), .B0(n5758), .Y(n3125) );
  NOR2X1 U5245 ( .A(n5759), .B(n5760), .Y(n5758) );
  NOR2X1 U5246 ( .A(n5671), .B(n6484), .Y(n5759) );
  NOR2X1 U5247 ( .A(n6459), .B(n5412), .Y(n5760) );
  OAI21X1 U5248 ( .A0(n5393), .A1(n5489), .B0(n5755), .Y(n3126) );
  NOR2X1 U5249 ( .A(n5756), .B(n5757), .Y(n5755) );
  NOR2X1 U5250 ( .A(n5667), .B(n6482), .Y(n5756) );
  NOR2X1 U5251 ( .A(n6459), .B(n5413), .Y(n5757) );
  OAI21X1 U5252 ( .A0(n5394), .A1(n5489), .B0(n5751), .Y(n3128) );
  NOR2X1 U5253 ( .A(n5752), .B(n5753), .Y(n5751) );
  NOR2X1 U5254 ( .A(n4756), .B(n6484), .Y(n5752) );
  NOR2X1 U5255 ( .A(n5309), .B(n6459), .Y(n5753) );
  OAI21X1 U5256 ( .A0(n5395), .A1(n5489), .B0(n5748), .Y(n3129) );
  NOR2X1 U5257 ( .A(n5749), .B(n5750), .Y(n5748) );
  NOR2X1 U5258 ( .A(n4753), .B(n6484), .Y(n5749) );
  NOR2X1 U5259 ( .A(n6459), .B(n5414), .Y(n5750) );
  OAI21X1 U5260 ( .A0(n5396), .A1(n5489), .B0(n5744), .Y(n3131) );
  NOR2X1 U5261 ( .A(n5745), .B(n5746), .Y(n5744) );
  NOR2X1 U5262 ( .A(n4747), .B(n6484), .Y(n5745) );
  NOR2X1 U5263 ( .A(n6459), .B(n5415), .Y(n5746) );
  OAI21X1 U5264 ( .A0(n5397), .A1(n5488), .B0(n5741), .Y(n3132) );
  NOR2X1 U5265 ( .A(n5742), .B(n5743), .Y(n5741) );
  NOR2X1 U5266 ( .A(n4744), .B(n6482), .Y(n5742) );
  NOR2X1 U5267 ( .A(n5308), .B(n6459), .Y(n5743) );
  OAI21X1 U5268 ( .A0(n5398), .A1(n5488), .B0(n5737), .Y(n3134) );
  NOR2X1 U5269 ( .A(n5738), .B(n5739), .Y(n5737) );
  NOR2X1 U5270 ( .A(n4738), .B(n6483), .Y(n5738) );
  NOR2X1 U5271 ( .A(n6459), .B(n5416), .Y(n5739) );
  OAI21X1 U5272 ( .A0(n5399), .A1(n5489), .B0(n5733), .Y(n3136) );
  NOR2X1 U5273 ( .A(n5734), .B(n5735), .Y(n5733) );
  NOR2X1 U5274 ( .A(n5632), .B(n6484), .Y(n5734) );
  NOR2X1 U5275 ( .A(n6459), .B(n5417), .Y(n5735) );
  OAI21X1 U5276 ( .A0(n5400), .A1(n5489), .B0(n5730), .Y(n3137) );
  NOR2X1 U5277 ( .A(n5731), .B(n5732), .Y(n5730) );
  NOR2X1 U5278 ( .A(n4729), .B(n6483), .Y(n5731) );
  NOR2X1 U5279 ( .A(n5310), .B(n6459), .Y(n5732) );
  OAI21X1 U5280 ( .A0(n5401), .A1(n5488), .B0(n5726), .Y(n3139) );
  NOR2X1 U5281 ( .A(n5727), .B(n5728), .Y(n5726) );
  NOR2X1 U5282 ( .A(n5621), .B(n6482), .Y(n5727) );
  NOR2X1 U5283 ( .A(n6459), .B(n5418), .Y(n5728) );
  OAI21X1 U5284 ( .A0(n5402), .A1(n5489), .B0(n5723), .Y(n3140) );
  NOR2X1 U5285 ( .A(n5724), .B(n5725), .Y(n5723) );
  NOR2X1 U5286 ( .A(n5617), .B(n6483), .Y(n5724) );
  NOR2X1 U5287 ( .A(n6459), .B(n5419), .Y(n5725) );
  OAI21X1 U5288 ( .A0(n5403), .A1(n5488), .B0(n5719), .Y(n3142) );
  NOR2X1 U5289 ( .A(n5720), .B(n5721), .Y(n5719) );
  NOR2X1 U5290 ( .A(n4714), .B(n6482), .Y(n5720) );
  NOR2X1 U5291 ( .A(n5311), .B(n6459), .Y(n5721) );
  OAI21X1 U5292 ( .A0(n5404), .A1(n5489), .B0(n5716), .Y(n3143) );
  NOR2X1 U5293 ( .A(n5717), .B(n5718), .Y(n5716) );
  NOR2X1 U5294 ( .A(n5607), .B(n6483), .Y(n5717) );
  NOR2X1 U5295 ( .A(n6459), .B(n5420), .Y(n5718) );
  OAI21X1 U5296 ( .A0(n5405), .A1(n5488), .B0(n5713), .Y(n3144) );
  NOR2X1 U5297 ( .A(n5714), .B(n5715), .Y(n5713) );
  NOR2X1 U5298 ( .A(n5603), .B(n6482), .Y(n5714) );
  NOR2X1 U5299 ( .A(n6459), .B(n5421), .Y(n5715) );
  OAI21X1 U5300 ( .A0(n5406), .A1(n5489), .B0(n5709), .Y(n3146) );
  NOR2X1 U5301 ( .A(n5710), .B(n5711), .Y(n5709) );
  NOR2X1 U5302 ( .A(n5595), .B(n6483), .Y(n5710) );
  NOR2X1 U5303 ( .A(n6459), .B(n5422), .Y(n5711) );
  OAI21X1 U5304 ( .A0(n5407), .A1(n5489), .B0(n5706), .Y(n3147) );
  NOR2X1 U5305 ( .A(n5707), .B(n5708), .Y(n5706) );
  NOR2X1 U5306 ( .A(n5591), .B(n6482), .Y(n5707) );
  NOR2X1 U5307 ( .A(n6459), .B(n5423), .Y(n5708) );
  OAI21X1 U5308 ( .A0(n5408), .A1(n5488), .B0(n5702), .Y(n3149) );
  NOR2X1 U5309 ( .A(n5703), .B(n5704), .Y(n5702) );
  NOR2X1 U5310 ( .A(n5583), .B(n6483), .Y(n5703) );
  NOR2X1 U5311 ( .A(n6459), .B(n5424), .Y(n5704) );
  OAI21X1 U5312 ( .A0(n5409), .A1(n5489), .B0(n5699), .Y(n3150) );
  NOR2X1 U5313 ( .A(n5700), .B(n5701), .Y(n5699) );
  NOR2X1 U5314 ( .A(n5579), .B(n6482), .Y(n5700) );
  NOR2X1 U5315 ( .A(n6459), .B(n5425), .Y(n5701) );
  OAI21X1 U5316 ( .A0(n5410), .A1(n5489), .B0(n5696), .Y(n3151) );
  NOR2X1 U5317 ( .A(n5697), .B(n5698), .Y(n5696) );
  NOR2X1 U5318 ( .A(n4687), .B(n6484), .Y(n5697) );
  NOR2X1 U5319 ( .A(n5312), .B(n6459), .Y(n5698) );
  OAI21X1 U5320 ( .A0(n5411), .A1(n5488), .B0(n5693), .Y(n3152) );
  NOR2X1 U5321 ( .A(n5694), .B(n5695), .Y(n5693) );
  NOR2X1 U5322 ( .A(n5572), .B(n6484), .Y(n5694) );
  NOR2X1 U5323 ( .A(n6459), .B(n5426), .Y(n5695) );
  OAI21X1 U5324 ( .A0(n5334), .A1(n6476), .B0(n6180), .Y(n2987) );
  NOR2X1 U5325 ( .A(n6181), .B(n6182), .Y(n6180) );
  NOR2X1 U5326 ( .A(n6489), .B(n4771), .Y(n6181) );
  NOR2X1 U5327 ( .A(n6461), .B(n5454), .Y(n6182) );
  OAI21X1 U5328 ( .A0(n5335), .A1(n6475), .B0(n6173), .Y(n2989) );
  NOR2X1 U5329 ( .A(n6174), .B(n6175), .Y(n6173) );
  NOR2X1 U5330 ( .A(n6489), .B(n5671), .Y(n6174) );
  NOR2X1 U5331 ( .A(n6461), .B(n5389), .Y(n6175) );
  OAI21X1 U5332 ( .A0(n5336), .A1(n6475), .B0(n6170), .Y(n2990) );
  NOR2X1 U5333 ( .A(n6171), .B(n6172), .Y(n6170) );
  NOR2X1 U5334 ( .A(n6489), .B(n5667), .Y(n6171) );
  NOR2X1 U5335 ( .A(n6461), .B(n5370), .Y(n6172) );
  OAI21X1 U5336 ( .A0(n5337), .A1(n6475), .B0(n6163), .Y(n2992) );
  NOR2X1 U5337 ( .A(n6164), .B(n6165), .Y(n6163) );
  NOR2X1 U5338 ( .A(n6489), .B(n4756), .Y(n6164) );
  NOR2X1 U5339 ( .A(n6461), .B(n5371), .Y(n6165) );
  OAI21X1 U5340 ( .A0(n5338), .A1(n6476), .B0(n6160), .Y(n2993) );
  NOR2X1 U5341 ( .A(n6161), .B(n6162), .Y(n6160) );
  NOR2X1 U5342 ( .A(n6489), .B(n4753), .Y(n6161) );
  NOR2X1 U5343 ( .A(n6461), .B(n5372), .Y(n6162) );
  OAI21X1 U5344 ( .A0(n5339), .A1(n6475), .B0(n6153), .Y(n2995) );
  NOR2X1 U5345 ( .A(n6154), .B(n6155), .Y(n6153) );
  NOR2X1 U5346 ( .A(n6489), .B(n4747), .Y(n6154) );
  NOR2X1 U5347 ( .A(n6461), .B(n5374), .Y(n6155) );
  OAI21X1 U5348 ( .A0(n5340), .A1(n6476), .B0(n6150), .Y(n2996) );
  NOR2X1 U5349 ( .A(n6151), .B(n6152), .Y(n6150) );
  NOR2X1 U5350 ( .A(n6489), .B(n4744), .Y(n6151) );
  NOR2X1 U5351 ( .A(n6461), .B(n5455), .Y(n6152) );
  OAI21X1 U5352 ( .A0(n5341), .A1(n6475), .B0(n6143), .Y(n2998) );
  NOR2X1 U5353 ( .A(n6144), .B(n6145), .Y(n6143) );
  NOR2X1 U5354 ( .A(n6489), .B(n4738), .Y(n6144) );
  NOR2X1 U5355 ( .A(n6461), .B(n5376), .Y(n6145) );
  OAI21X1 U5356 ( .A0(n5342), .A1(n6476), .B0(n6136), .Y(n3000) );
  NOR2X1 U5357 ( .A(n6137), .B(n6138), .Y(n6136) );
  NOR2X1 U5358 ( .A(n6436), .B(n5632), .Y(n6137) );
  NOR2X1 U5359 ( .A(n6461), .B(n5377), .Y(n6138) );
  OAI21X1 U5360 ( .A0(n5343), .A1(n6475), .B0(n6133), .Y(n3001) );
  NOR2X1 U5361 ( .A(n6134), .B(n6135), .Y(n6133) );
  NOR2X1 U5362 ( .A(n6436), .B(n4729), .Y(n6134) );
  NOR2X1 U5363 ( .A(n6461), .B(n5378), .Y(n6135) );
  OAI21X1 U5364 ( .A0(n5344), .A1(n6476), .B0(n6126), .Y(n3003) );
  NOR2X1 U5365 ( .A(n6127), .B(n6128), .Y(n6126) );
  NOR2X1 U5366 ( .A(n6436), .B(n5621), .Y(n6127) );
  NOR2X1 U5367 ( .A(n6461), .B(n5456), .Y(n6128) );
  OAI21X1 U5368 ( .A0(n5345), .A1(n6475), .B0(n6123), .Y(n3004) );
  NOR2X1 U5369 ( .A(n6124), .B(n6125), .Y(n6123) );
  NOR2X1 U5370 ( .A(n6436), .B(n5617), .Y(n6124) );
  NOR2X1 U5371 ( .A(n6461), .B(n5457), .Y(n6125) );
  OAI21X1 U5372 ( .A0(n5346), .A1(n6476), .B0(n6116), .Y(n3006) );
  NOR2X1 U5373 ( .A(n6117), .B(n6118), .Y(n6116) );
  NOR2X1 U5374 ( .A(n6436), .B(n4714), .Y(n6117) );
  NOR2X1 U5375 ( .A(n6461), .B(n5380), .Y(n6118) );
  OAI21X1 U5376 ( .A0(n5347), .A1(n6475), .B0(n6113), .Y(n3007) );
  NOR2X1 U5377 ( .A(n6114), .B(n6115), .Y(n6113) );
  NOR2X1 U5378 ( .A(n6436), .B(n5607), .Y(n6114) );
  NOR2X1 U5379 ( .A(n6461), .B(n5458), .Y(n6115) );
  OAI21X1 U5380 ( .A0(n5348), .A1(n6476), .B0(n6110), .Y(n3008) );
  NOR2X1 U5381 ( .A(n6111), .B(n6112), .Y(n6110) );
  NOR2X1 U5382 ( .A(n6436), .B(n5603), .Y(n6111) );
  NOR2X1 U5383 ( .A(n6461), .B(n5381), .Y(n6112) );
  OAI21X1 U5384 ( .A0(n5349), .A1(n6475), .B0(n6103), .Y(n3010) );
  NOR2X1 U5385 ( .A(n6104), .B(n6105), .Y(n6103) );
  NOR2X1 U5386 ( .A(n6489), .B(n5595), .Y(n6104) );
  NOR2X1 U5387 ( .A(n6461), .B(n5459), .Y(n6105) );
  OAI21X1 U5388 ( .A0(n5350), .A1(n6476), .B0(n6100), .Y(n3011) );
  NOR2X1 U5389 ( .A(n6101), .B(n6102), .Y(n6100) );
  NOR2X1 U5390 ( .A(n6436), .B(n5591), .Y(n6101) );
  NOR2X1 U5391 ( .A(n6461), .B(n5383), .Y(n6102) );
  OAI21X1 U5392 ( .A0(n5351), .A1(n6475), .B0(n6093), .Y(n3013) );
  NOR2X1 U5393 ( .A(n6094), .B(n6095), .Y(n6093) );
  NOR2X1 U5394 ( .A(n6436), .B(n5583), .Y(n6094) );
  NOR2X1 U5395 ( .A(n6461), .B(n5460), .Y(n6095) );
  OAI21X1 U5396 ( .A0(n5352), .A1(n6476), .B0(n6090), .Y(n3014) );
  NOR2X1 U5397 ( .A(n6091), .B(n6092), .Y(n6090) );
  NOR2X1 U5398 ( .A(n6436), .B(n5579), .Y(n6091) );
  NOR2X1 U5399 ( .A(n6461), .B(n5385), .Y(n6092) );
  OAI21X1 U5400 ( .A0(n5353), .A1(n6475), .B0(n6087), .Y(n3015) );
  NOR2X1 U5401 ( .A(n6088), .B(n6089), .Y(n6087) );
  NOR2X1 U5402 ( .A(n6436), .B(n4687), .Y(n6088) );
  NOR2X1 U5403 ( .A(n6461), .B(n5386), .Y(n6089) );
  OAI21X1 U5404 ( .A0(n5354), .A1(n6476), .B0(n6084), .Y(n3016) );
  NOR2X1 U5405 ( .A(n6085), .B(n6086), .Y(n6084) );
  NOR2X1 U5406 ( .A(n6436), .B(n5572), .Y(n6085) );
  NOR2X1 U5407 ( .A(n6461), .B(n5461), .Y(n6086) );
  OAI33X1 U5408 ( .A0(n5088), .A1(n5067), .A2(n5089), .B0(n5090), .B1(n5091), 
        .B2(n5092), .Y(n5087) );
  NAND2BX1 U5409 ( .AN(n5098), .B(n5523), .Y(n5089) );
  NAND2BX1 U5410 ( .AN(n5093), .B(n5520), .Y(n5092) );
  NAND3BX1 U5411 ( .AN(n5100), .B(n5101), .C(n5102), .Y(n5088) );
  NOR2X1 U5412 ( .A(n5037), .B(n6244), .Y(n6243) );
  NOR2X1 U5413 ( .A(cas_cnt_b2_pos1467_3_), .B(cas_cnt_b2_pos1467_4_), .Y(
        n6244) );
  INVX1 U5414 ( .A(n5869), .Y(n6079) );
  AND2X2 U5415 ( .A(n6246), .B(n6245), .Y(n5506) );
  INVX1 U5416 ( .A(n5868), .Y(n5987) );
  NAND2X1 U5417 ( .A(n6240), .B(n6241), .Y(n5042) );
  NAND3BX1 U5418 ( .AN(n5095), .B(n5096), .C(n5097), .Y(n5090) );
  INVX1 U5419 ( .A(n4780), .Y(n4667) );
  NAND3BX1 U5420 ( .AN(n4781), .B(n5536), .C(n6485), .Y(n4780) );
  INVX3 U5421 ( .A(n6362), .Y(n5555) );
  NOR2X1 U5422 ( .A(n6195), .B(n6202), .Y(n6201) );
  INVX1 U5423 ( .A(cas_cnt_b0_pos1445_1_), .Y(n6202) );
  NOR2X1 U5424 ( .A(n6195), .B(n6214), .Y(n6213) );
  INVX1 U5425 ( .A(cas_cnt_b0_pos1445_2_), .Y(n6214) );
  NOR2X1 U5426 ( .A(n6252), .B(n6193), .Y(n6251) );
  NOR2X1 U5427 ( .A(cas_cnt_b3_pos1478_3_), .B(cas_cnt_b3_pos1478_4_), .Y(
        n6252) );
  INVX1 U5428 ( .A(n4977), .Y(n4933) );
  NAND3BX1 U5429 ( .AN(n4932), .B(n5536), .C(n6485), .Y(n4977) );
  OR2X1 U5430 ( .A(n5137), .B(n5138), .Y(n6230) );
  NAND3BX1 U5431 ( .AN(n5091), .B(n5520), .C(n5097), .Y(n5138) );
  OAI222X1 U5432 ( .A0(n4833), .A1(n5297), .B0(n4744), .B1(n4842), .C0(n5308), 
        .C1(n5486), .Y(n3098) );
  OAI222X1 U5433 ( .A0(n4833), .A1(n5298), .B0(n4756), .B1(n4842), .C0(n5309), 
        .C1(n5486), .Y(n3094) );
  OAI222X1 U5434 ( .A0(n4833), .A1(n5299), .B0(n4729), .B1(n4842), .C0(n5310), 
        .C1(n5486), .Y(n3103) );
  OAI222X1 U5435 ( .A0(n4833), .A1(n5300), .B0(n4714), .B1(n4842), .C0(n5311), 
        .C1(n5486), .Y(n3108) );
  OAI222X1 U5436 ( .A0(n4833), .A1(n5301), .B0(n4687), .B1(n4842), .C0(n5312), 
        .C1(n5486), .Y(n3117) );
  NAND2X1 U5437 ( .A(n5766), .B(n5767), .Y(n3121) );
  NOR2X1 U5438 ( .A(n5771), .B(n5772), .Y(n5766) );
  NAND2X1 U5439 ( .A(n5768), .B(n4660), .Y(n5767) );
  NOR2X1 U5440 ( .A(n6441), .B(n5462), .Y(n5772) );
  OR4X1 U5441 ( .A(n5107), .B(n5108), .C(n5109), .D(n5110), .Y(n5103) );
  NAND3BX1 U5442 ( .AN(n5111), .B(n5112), .C(n5113), .Y(n5110) );
  OR4X1 U5443 ( .A(n5122), .B(n5123), .C(n5124), .D(n5125), .Y(n5105) );
  NAND3BX1 U5444 ( .AN(n5126), .B(n5127), .C(n5128), .Y(n5125) );
  XOR2X1 U5445 ( .A(n5537), .B(n6485), .Y(n429_0_) );
  INVX1 U5446 ( .A(n3), .Y(carry3) );
  INVX1 U5447 ( .A(n2), .Y(carry2) );
  NAND2X1 U5448 ( .A(n6409), .B(n6257), .Y(n6415) );
  NAND2X1 U5449 ( .A(n6480), .B(n6376), .Y(n6248) );
  NAND2X1 U5450 ( .A(n6377), .B(n6378), .Y(n6376) );
  NOR2X1 U5451 ( .A(n5293), .B(n5307), .Y(n6377) );
  NOR2X1 U5452 ( .A(n6379), .B(n5292), .Y(n6378) );
  NAND3BX1 U5453 ( .AN(n5067), .B(n5523), .C(n5102), .Y(n5140) );
  NAND2X1 U5454 ( .A(n5211), .B(n6246), .Y(n5210) );
  NAND2X1 U5455 ( .A(n5220), .B(n6241), .Y(n5219) );
  OAI21X1 U5456 ( .A0(n5486), .A1(n5412), .B0(n5851), .Y(n3091) );
  NOR2X1 U5457 ( .A(n5852), .B(n5853), .Y(n5851) );
  NOR2X1 U5458 ( .A(n6453), .B(n5355), .Y(n5852) );
  NOR2X1 U5459 ( .A(n4842), .B(n5671), .Y(n5853) );
  OAI21X1 U5460 ( .A0(n5486), .A1(n5413), .B0(n5848), .Y(n3092) );
  NOR2X1 U5461 ( .A(n5849), .B(n5850), .Y(n5848) );
  NOR2X1 U5462 ( .A(n6452), .B(n5356), .Y(n5849) );
  NOR2X1 U5463 ( .A(n4842), .B(n5667), .Y(n5850) );
  OAI21X1 U5464 ( .A0(n5486), .A1(n5414), .B0(n5841), .Y(n3095) );
  NOR2X1 U5465 ( .A(n5842), .B(n5843), .Y(n5841) );
  NOR2X1 U5466 ( .A(n6451), .B(n5357), .Y(n5842) );
  NOR2X1 U5467 ( .A(n4842), .B(n4753), .Y(n5843) );
  OAI21X1 U5468 ( .A0(n5486), .A1(n5415), .B0(n5834), .Y(n3097) );
  NOR2X1 U5469 ( .A(n5835), .B(n5836), .Y(n5834) );
  NOR2X1 U5470 ( .A(n6450), .B(n5358), .Y(n5835) );
  NOR2X1 U5471 ( .A(n4842), .B(n4747), .Y(n5836) );
  OAI21X1 U5472 ( .A0(n5486), .A1(n5416), .B0(n5828), .Y(n3100) );
  NOR2X1 U5473 ( .A(n5829), .B(n5830), .Y(n5828) );
  NOR2X1 U5474 ( .A(n6449), .B(n5359), .Y(n5829) );
  NOR2X1 U5475 ( .A(n4842), .B(n4738), .Y(n5830) );
  OAI21X1 U5476 ( .A0(n5486), .A1(n5417), .B0(n5822), .Y(n3102) );
  NOR2X1 U5477 ( .A(n5823), .B(n5824), .Y(n5822) );
  NOR2X1 U5478 ( .A(n4833), .B(n5360), .Y(n5823) );
  NOR2X1 U5479 ( .A(n4842), .B(n5632), .Y(n5824) );
  OAI21X1 U5480 ( .A0(n5486), .A1(n5418), .B0(n5816), .Y(n3105) );
  NOR2X1 U5481 ( .A(n5817), .B(n5818), .Y(n5816) );
  NOR2X1 U5482 ( .A(n6446), .B(n5361), .Y(n5817) );
  NOR2X1 U5483 ( .A(n4842), .B(n5621), .Y(n5818) );
  OAI21X1 U5484 ( .A0(n5486), .A1(n5419), .B0(n5813), .Y(n3106) );
  NOR2X1 U5485 ( .A(n5814), .B(n5815), .Y(n5813) );
  NOR2X1 U5486 ( .A(n6445), .B(n5362), .Y(n5814) );
  NOR2X1 U5487 ( .A(n4842), .B(n5617), .Y(n5815) );
  OAI21X1 U5488 ( .A0(n5486), .A1(n5420), .B0(n5807), .Y(n3109) );
  NOR2X1 U5489 ( .A(n5808), .B(n5809), .Y(n5807) );
  NOR2X1 U5490 ( .A(n6444), .B(n5363), .Y(n5808) );
  NOR2X1 U5491 ( .A(n4842), .B(n5607), .Y(n5809) );
  OAI21X1 U5492 ( .A0(n5486), .A1(n5421), .B0(n5804), .Y(n3110) );
  NOR2X1 U5493 ( .A(n5805), .B(n5806), .Y(n5804) );
  NOR2X1 U5494 ( .A(n6443), .B(n5364), .Y(n5805) );
  NOR2X1 U5495 ( .A(n4842), .B(n5603), .Y(n5806) );
  OAI21X1 U5496 ( .A0(n5486), .A1(n5422), .B0(n5798), .Y(n3112) );
  NOR2X1 U5497 ( .A(n5799), .B(n5800), .Y(n5798) );
  NOR2X1 U5498 ( .A(n6449), .B(n5365), .Y(n5799) );
  NOR2X1 U5499 ( .A(n4842), .B(n5595), .Y(n5800) );
  OAI21X1 U5500 ( .A0(n5486), .A1(n5423), .B0(n5795), .Y(n3113) );
  NOR2X1 U5501 ( .A(n5796), .B(n5797), .Y(n5795) );
  NOR2X1 U5502 ( .A(n6446), .B(n5366), .Y(n5796) );
  NOR2X1 U5503 ( .A(n4842), .B(n5591), .Y(n5797) );
  OAI21X1 U5504 ( .A0(n5486), .A1(n5424), .B0(n5788), .Y(n3115) );
  NOR2X1 U5505 ( .A(n5789), .B(n5790), .Y(n5788) );
  NOR2X1 U5506 ( .A(n6445), .B(n5367), .Y(n5789) );
  NOR2X1 U5507 ( .A(n4842), .B(n5583), .Y(n5790) );
  OAI21X1 U5508 ( .A0(n5486), .A1(n5425), .B0(n5785), .Y(n3116) );
  NOR2X1 U5509 ( .A(n5786), .B(n5787), .Y(n5785) );
  NOR2X1 U5510 ( .A(n6444), .B(n5368), .Y(n5786) );
  NOR2X1 U5511 ( .A(n4842), .B(n5579), .Y(n5787) );
  OAI21X1 U5512 ( .A0(n5486), .A1(n5426), .B0(n5782), .Y(n3118) );
  NOR2X1 U5513 ( .A(n5783), .B(n5784), .Y(n5782) );
  NOR2X1 U5514 ( .A(n6443), .B(n5369), .Y(n5783) );
  NOR2X1 U5515 ( .A(n4842), .B(n5572), .Y(n5784) );
  NOR2X1 U5516 ( .A(n5486), .B(n5428), .Y(n5771) );
  NAND3BX1 U5517 ( .AN(n6411), .B(n6412), .C(n6413), .Y(n2935) );
  NAND2X1 U5518 ( .A(n6414), .B(n5536), .Y(n6412) );
  NOR2X1 U5519 ( .A(n5431), .B(n6415), .Y(n6411) );
  NAND2X1 U5520 ( .A(n5504), .B(cas_cnt_b0_pos1445_1_), .Y(n6413) );
  NOR2X1 U5521 ( .A(n6193), .B(cas_cnt_b3_pos_0_), .Y(n6192) );
  NOR2X1 U5522 ( .A(n6193), .B(n6212), .Y(n6211) );
  INVX1 U5523 ( .A(cas_cnt_b3_pos1478_2_), .Y(n6212) );
  NOR2X1 U5524 ( .A(n5530), .B(n6193), .Y(n6200) );
  NOR2X1 U5525 ( .A(n5037), .B(n5531), .Y(n6204) );
  NOR2X1 U5526 ( .A(n5037), .B(n6216), .Y(n6215) );
  INVX1 U5527 ( .A(cas_cnt_b2_pos1467_2_), .Y(n6216) );
  OAI222X1 U5528 ( .A0(n5304), .A1(n5219), .B0(n6486), .B1(n5220), .C0(n5532), 
        .C1(n5221), .Y(n2940) );
  OAI222X1 U5529 ( .A0(n5293), .A1(n5202), .B0(n6486), .B1(n5203), .C0(n5530), 
        .C1(n5204), .Y(n2950) );
  AND4X1 U5530 ( .A(n5236), .B(n5238), .C(n5241), .D(n5237), .Y(CAS_EMPTY914)
         );
  NOR2BX1 U5531 ( .AN(n5240), .B(n429_3_), .Y(n5241) );
  OAI31X1 U5532 ( .A0(n5236), .A1(n5237), .A2(n5238), .B0(n5239), .Y(
        CAS_FULL922) );
  NOR2BX1 U5533 ( .AN(n5240), .B(n429_3_), .Y(n5239) );
  INVX1 U5534 ( .A(n429_2_), .Y(n5237) );
  INVX1 U5535 ( .A(n429_1_), .Y(n5238) );
  DFFRX1 CAS_0_RW_reg ( .D(n2982), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_RW) );
  INVX1 U5536 ( .A(BA_TT[3]), .Y(n5891) );
  DFFSX1 cas_cnt_b0_pos_reg_0_ ( .D(n2936), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b0_pos_0_) );
  DFFSX1 cas_cnt_b2_pos_reg_0_ ( .D(n2946), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b2_pos_0_), .QN(n5429) );
  DFFSX1 cas_cnt_b1_pos_reg_3_ ( .D(n2938), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b1_pos_3_), .QN(n5295) );
  DFFSX1 cas_cnt_b2_pos_reg_3_ ( .D(n2943), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b2_pos_3_) );
  NOR2X1 U5537 ( .A(cas_cnt_b1_pos1456_3_), .B(cas_cnt_b1_pos1456_4_), .Y(
        n6239) );
  INVX1 U5538 ( .A(BA_ID[2]), .Y(n4771) );
  INVX1 U5539 ( .A(BA_ID[3]), .Y(n5983) );
  INVX1 U5540 ( .A(BA_ID[1]), .Y(n5975) );
  INVX1 U5541 ( .A(BA_CA[6]), .Y(n5916) );
  NOR2X1 U5542 ( .A(cas_cnt_b0_pos1445_3_), .B(cas_cnt_b0_pos1445_4_), .Y(
        n6253) );
  DFFRX1 CAS_0_NEWROW_reg ( .D(n2985), .CK(ACLK), .RN(ARESETB), .Q(
        CAS_0_NEWROW) );
  DFFRX1 CAS_0_FINAL_reg ( .D(n2984), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_FINAL), 
        .QN(net3025) );
  OAI21X1 U5543 ( .A0(n6406), .A1(n6407), .B0(n6480), .Y(n6241) );
  NAND2X1 U5544 ( .A(cas_cnt_b1_pos_2_), .B(cas_cnt_b1_pos_0_), .Y(n6407) );
  NAND3X1 U5545 ( .A(cas_cnt_b1_pos_4_), .B(cas_cnt_b1_pos_3_), .C(
        cas_cnt_b1_pos_1_), .Y(n6406) );
  NAND4X1 U5546 ( .A(n6207), .B(n6208), .C(n6209), .D(n6210), .Y(n5543) );
  AOI21X1 U5547 ( .A0(cas_cnt_b3_pos_2_), .A1(n6203), .B0(n6215), .Y(n6208) );
  AOI21X1 U5548 ( .A0(n5506), .A1(cas_cnt_b2_pos_2_), .B0(n6211), .Y(n6210) );
  AOI21X1 U5549 ( .A0(n5505), .A1(cas_cnt_b0_pos_2_), .B0(n6213), .Y(n6209) );
  OR2X1 U1_B_34 ( .A(cas_cnt_3_), .B(carry0), .Y(carry) );
  MX2X2 U5550 ( .S0(n6481), .B(cas_cnt1375_3_), .A(cas_cnt_3_), .Y(n181_3_) );
  XOR2X1 U5551 ( .A(n4750), .B(B2_LAST_RA[9]), .Y(n5159) );
  NAND4X1 U5552 ( .A(n6196), .B(n6197), .C(n6198), .D(n6199), .Y(n5869) );
  AOI21X1 U5553 ( .A0(n6203), .A1(cas_cnt_b3_pos_1_), .B0(n6204), .Y(n6197) );
  AOI21X1 U5554 ( .A0(n5506), .A1(cas_cnt_b2_pos_1_), .B0(n6200), .Y(n6199) );
  AOI21X1 U5555 ( .A0(n5505), .A1(cas_cnt_b0_pos_1_), .B0(n6201), .Y(n6198) );
  NAND4X1 U5556 ( .A(n6190), .B(n5056), .C(n6191), .D(n5055), .Y(n5868) );
  AOI21X1 U5557 ( .A0(n5506), .A1(cas_cnt_b2_pos_0_), .B0(n6192), .Y(n6191) );
  OA22X1 U5558 ( .A0(cas_cnt_b2_pos_0_), .A1(n5037), .B0(n5292), .B1(n5040), 
        .Y(n5056) );
  MXI2X1 U5559 ( .S0(cas_cnt_b0_pos_0_), .B(n5505), .A(n6194), .Y(n6190) );
  NAND3BX1 U5560 ( .AN(B2_LAST_RA[12]), .B(n5165), .C(n5166), .Y(n5095) );
  XOR2X1 U5561 ( .A(n4726), .B(B2_LAST_RA[1]), .Y(n5165) );
  XOR2X1 U5562 ( .A(n4753), .B(B2_LAST_RA[10]), .Y(n5166) );
  NAND3BX1 U5563 ( .AN(B3_LAST_RA[12]), .B(n5150), .C(n5151), .Y(n5100) );
  XOR2X1 U5564 ( .A(n4726), .B(B3_LAST_RA[1]), .Y(n5150) );
  XOR2X1 U5565 ( .A(n4753), .B(B3_LAST_RA[10]), .Y(n5151) );
  XOR2X1 U5566 ( .A(n4756), .B(B2_LAST_RA[11]), .Y(n5169) );
  XOR2X1 U5567 ( .A(n4756), .B(B3_LAST_RA[11]), .Y(n5154) );
  NAND3BX1 U5568 ( .AN(B2_LAST_RA[0]), .B(n5096), .C(n5164), .Y(n5137) );
  INVX1 U5569 ( .A(n5095), .Y(n5164) );
  NOR3X1 U5570 ( .A(n5105), .B(B1_LAST_RA[0]), .C(n6223), .Y(n6228) );
  AOI21X1 U5571 ( .A0(cas_cnt_b1_pos_2_), .A1(n6205), .B0(n6217), .Y(n6207) );
  NOR2X1 U5572 ( .A(n5043), .B(n6218), .Y(n6217) );
  INVX1 U5573 ( .A(cas_cnt_b1_pos1456_2_), .Y(n6218) );
  NOR3X1 U5574 ( .A(n5103), .B(B0_LAST_RA[0]), .C(n6225), .Y(n6229) );
  NOR3X1 U5575 ( .A(n5105), .B(n6223), .C(n6224), .Y(n6222) );
  INVX1 U5576 ( .A(B1_LAST_RA[0]), .Y(n6224) );
  OAI2BB2X1 U5577 ( .A0N(n4657), .A1N(n4658), .B0(n5507), .B1(n4657), .Y(n3191) );
  AO21X1 U5578 ( .A0(n4660), .A1(n4661), .B0(n4662), .Y(n4657) );
  NOR3X1 U5579 ( .A(n5103), .B(n6225), .C(n6226), .Y(n6221) );
  INVX1 U5580 ( .A(B0_LAST_RA[0]), .Y(n6226) );
  AOI21X1 U5581 ( .A0(n6237), .A1(n6205), .B0(n6238), .Y(n6236) );
  NAND2X1 U5582 ( .A(n5305), .B(n5295), .Y(n6237) );
  NOR2X1 U5583 ( .A(n5043), .B(n6239), .Y(n6238) );
  OAI21X1 U5584 ( .A0(n5370), .A1(n6261), .B0(n6357), .Y(n2952) );
  NOR2X1 U5585 ( .A(n6358), .B(n6359), .Y(n6357) );
  NOR2X1 U5586 ( .A(n5667), .B(n6265), .Y(n6359) );
  NOR2X1 U5587 ( .A(n6266), .B(n2867), .Y(n6358) );
  OAI21X1 U5588 ( .A0(n5371), .A1(n6261), .B0(n6351), .Y(n2954) );
  NOR2X1 U5589 ( .A(n6352), .B(n6353), .Y(n6351) );
  NOR2X1 U5590 ( .A(n4756), .B(n6265), .Y(n6353) );
  NOR2X1 U5591 ( .A(n6266), .B(n2885), .Y(n6352) );
  OAI21X1 U5592 ( .A0(n5372), .A1(n5483), .B0(n6348), .Y(n2955) );
  NOR2X1 U5593 ( .A(n6349), .B(n6350), .Y(n6348) );
  NOR2X1 U5594 ( .A(n4753), .B(n6265), .Y(n6350) );
  NOR2X1 U5595 ( .A(n6266), .B(n2884), .Y(n6349) );
  OAI21X1 U5596 ( .A0(n5373), .A1(n5483), .B0(n6345), .Y(n2956) );
  NOR2X1 U5597 ( .A(n6346), .B(n6347), .Y(n6345) );
  NOR2X1 U5598 ( .A(n4750), .B(n6265), .Y(n6347) );
  NOR2X1 U5599 ( .A(n6266), .B(n2894), .Y(n6346) );
  OAI21X1 U5600 ( .A0(n5374), .A1(n5483), .B0(n6342), .Y(n2957) );
  NOR2X1 U5601 ( .A(n6343), .B(n6344), .Y(n6342) );
  NOR2X1 U5602 ( .A(n4747), .B(n6265), .Y(n6344) );
  NOR2X1 U5603 ( .A(n6266), .B(n2893), .Y(n6343) );
  OAI21X1 U5604 ( .A0(n5375), .A1(n5483), .B0(n6336), .Y(n2959) );
  NOR2X1 U5605 ( .A(n6337), .B(n6338), .Y(n6336) );
  NOR2X1 U5606 ( .A(n4741), .B(n6265), .Y(n6338) );
  NOR2X1 U5607 ( .A(n6266), .B(n2891), .Y(n6337) );
  OAI21X1 U5608 ( .A0(n5376), .A1(n5483), .B0(n6333), .Y(n2960) );
  NOR2X1 U5609 ( .A(n6334), .B(n6335), .Y(n6333) );
  NOR2X1 U5610 ( .A(n4738), .B(n6265), .Y(n6335) );
  NOR2X1 U5611 ( .A(n6266), .B(n2890), .Y(n6334) );
  OAI21X1 U5612 ( .A0(n5377), .A1(n6261), .B0(n6327), .Y(n2962) );
  NOR2X1 U5613 ( .A(n6328), .B(n6329), .Y(n6327) );
  NOR2X1 U5614 ( .A(n5632), .B(n6265), .Y(n6329) );
  NOR2X1 U5615 ( .A(n6266), .B(n2888), .Y(n6328) );
  OAI21X1 U5616 ( .A0(n5378), .A1(n5483), .B0(n6324), .Y(n2963) );
  NOR2X1 U5617 ( .A(n6325), .B(n6326), .Y(n6324) );
  NOR2X1 U5618 ( .A(n4729), .B(n6265), .Y(n6326) );
  NOR2X1 U5619 ( .A(n6266), .B(n2887), .Y(n6325) );
  OAI21X1 U5620 ( .A0(n5379), .A1(n6261), .B0(n6312), .Y(n2967) );
  NOR2X1 U5621 ( .A(n6313), .B(n6314), .Y(n6312) );
  NOR2X1 U5622 ( .A(n5916), .B(n6265), .Y(n6314) );
  NOR2X1 U5623 ( .A(n6266), .B(n2874), .Y(n6313) );
  OAI21X1 U5624 ( .A0(n5380), .A1(n5483), .B0(n6309), .Y(n2968) );
  NOR2X1 U5625 ( .A(n6310), .B(n6311), .Y(n6309) );
  NOR2X1 U5626 ( .A(n4714), .B(n6265), .Y(n6311) );
  NOR2X1 U5627 ( .A(n6266), .B(n2873), .Y(n6310) );
  OAI21X1 U5628 ( .A0(n5381), .A1(n5483), .B0(n6303), .Y(n2970) );
  NOR2X1 U5629 ( .A(n6304), .B(n6305), .Y(n6303) );
  NOR2X1 U5630 ( .A(n5603), .B(n6265), .Y(n6305) );
  NOR2X1 U5631 ( .A(n6266), .B(n2871), .Y(n6304) );
  OAI21X1 U5632 ( .A0(n5382), .A1(n5483), .B0(n6300), .Y(n2971) );
  NOR2X1 U5633 ( .A(n6301), .B(n6302), .Y(n6300) );
  NOR2X1 U5634 ( .A(n5902), .B(n6265), .Y(n6302) );
  NOR2X1 U5635 ( .A(n6266), .B(n2870), .Y(n6301) );
  OAI21X1 U5636 ( .A0(n5383), .A1(n6261), .B0(n6294), .Y(n2973) );
  NOR2X1 U5637 ( .A(n6295), .B(n6296), .Y(n6294) );
  NOR2X1 U5638 ( .A(n5591), .B(n6265), .Y(n6296) );
  NOR2X1 U5639 ( .A(n6266), .B(n2868), .Y(n6295) );
  OAI21X1 U5640 ( .A0(n5384), .A1(n5483), .B0(n6291), .Y(n2974) );
  NOR2X1 U5641 ( .A(n6292), .B(n6293), .Y(n6291) );
  NOR2X1 U5642 ( .A(n5891), .B(n6265), .Y(n6293) );
  NOR2X1 U5643 ( .A(n6266), .B(n2899), .Y(n6292) );
  OAI21X1 U5644 ( .A0(n5385), .A1(n5483), .B0(n6285), .Y(n2976) );
  NOR2X1 U5645 ( .A(n6286), .B(n6287), .Y(n6285) );
  NOR2X1 U5646 ( .A(n5579), .B(n6265), .Y(n6287) );
  NOR2X1 U5647 ( .A(n6266), .B(n2897), .Y(n6286) );
  OAI21X1 U5648 ( .A0(n5386), .A1(n6261), .B0(n6282), .Y(n2977) );
  NOR2X1 U5649 ( .A(n6283), .B(n6284), .Y(n6282) );
  NOR2X1 U5650 ( .A(n4687), .B(n6265), .Y(n6284) );
  NOR2X1 U5651 ( .A(n6266), .B(n2896), .Y(n6283) );
  OAI21X1 U5652 ( .A0(n5387), .A1(n5483), .B0(n6279), .Y(n2978) );
  NOR2X1 U5653 ( .A(n6280), .B(n6281), .Y(n6279) );
  NOR2X1 U5654 ( .A(n5983), .B(n6265), .Y(n6281) );
  NOR2X1 U5655 ( .A(n6266), .B(n2880), .Y(n6280) );
  OAI21X1 U5656 ( .A0(n5388), .A1(n6261), .B0(n6273), .Y(n2980) );
  NOR2X1 U5657 ( .A(n6274), .B(n6275), .Y(n6273) );
  NOR2X1 U5658 ( .A(n5975), .B(n6265), .Y(n6275) );
  NOR2X1 U5659 ( .A(n6266), .B(n2878), .Y(n6274) );
  OAI21X1 U5660 ( .A0(n5389), .A1(n5483), .B0(n6270), .Y(n2981) );
  NOR2X1 U5661 ( .A(n6271), .B(n6272), .Y(n6270) );
  NOR2X1 U5662 ( .A(n5671), .B(n6265), .Y(n6272) );
  NOR2X1 U5663 ( .A(n6266), .B(n2877), .Y(n6271) );
  OAI21X1 U5664 ( .A0(n5390), .A1(n6261), .B0(n6262), .Y(n2983) );
  NOR2X1 U5665 ( .A(n6263), .B(n6264), .Y(n6262) );
  NOR2X1 U5666 ( .A(n5874), .B(n6265), .Y(n6264) );
  NOR2X1 U5667 ( .A(n6266), .B(n2882), .Y(n6263) );
  NOR2X1 U5668 ( .A(n6461), .B(n5463), .Y(n6168) );
  NOR2X1 U5669 ( .A(n6461), .B(n5464), .Y(n6141) );
  NOR2X1 U5670 ( .A(n6461), .B(n5465), .Y(n6131) );
  NOR2X1 U5671 ( .A(n6460), .B(n5432), .Y(n5981) );
  NOR2X1 U5672 ( .A(n6460), .B(n5433), .Y(n5973) );
  NOR2X1 U5673 ( .A(n6460), .B(n5434), .Y(n5962) );
  NOR2X1 U5674 ( .A(n6460), .B(n5435), .Y(n5952) );
  NOR2X1 U5675 ( .A(n6460), .B(n5436), .Y(n5942) );
  NOR2X1 U5676 ( .A(n6460), .B(n5437), .Y(n5935) );
  NOR2X1 U5677 ( .A(n6460), .B(n5438), .Y(n5925) );
  NOR2X1 U5678 ( .A(n6460), .B(n5439), .Y(n5914) );
  NOR2X1 U5679 ( .A(n6460), .B(n5440), .Y(n5900) );
  NOR2X1 U5680 ( .A(n6460), .B(n5441), .Y(n5889) );
  NOR2X1 U5681 ( .A(n6460), .B(n5442), .Y(n5872) );
  NAND3BX1 U5682 ( .AN(B3_LAST_RA[0]), .B(n5101), .C(n5149), .Y(n5139) );
  INVX1 U5683 ( .A(n5100), .Y(n5149) );
  NAND3BX1 U5684 ( .AN(B0_LAST_RA[12]), .B(n5114), .C(n5115), .Y(n5109) );
  XOR2X1 U5685 ( .A(n4753), .B(B0_LAST_RA[10]), .Y(n5115) );
  XOR2X1 U5686 ( .A(n4756), .B(B0_LAST_RA[11]), .Y(n5114) );
  NAND3BX1 U5687 ( .AN(B1_LAST_RA[12]), .B(n5129), .C(n5130), .Y(n5124) );
  XOR2X1 U5688 ( .A(n4753), .B(B1_LAST_RA[10]), .Y(n5130) );
  XOR2X1 U5689 ( .A(n4756), .B(B1_LAST_RA[11]), .Y(n5129) );
  OA22X1 U5690 ( .A0(n5294), .A1(n5042), .B0(cas_cnt_b1_pos_0_), .B1(n5043), 
        .Y(n5055) );
  OAI2BB1X1 U5691 ( .A0N(n5508), .A1N(cas_7_final), .B0(n5230), .Y(n3190) );
  OR2X1 U5692 ( .A(n5556), .B(n5551), .Y(n5508) );
  OAI21X1 U5693 ( .A0(n6478), .A1(net2885), .B0(n5676), .Y(n3157) );
  NOR2X1 U5694 ( .A(n5677), .B(n5678), .Y(n5676) );
  NOR2X1 U5695 ( .A(n4771), .B(n6431), .Y(n5677) );
  NOR2X1 U5696 ( .A(n6473), .B(n5391), .Y(n5678) );
  OAI21X1 U5697 ( .A0(n6477), .A1(net2889), .B0(n5668), .Y(n3159) );
  NOR2X1 U5698 ( .A(n5669), .B(n5670), .Y(n5668) );
  NOR2X1 U5699 ( .A(n6431), .B(n5671), .Y(n5669) );
  NOR2X1 U5700 ( .A(n6472), .B(n5392), .Y(n5670) );
  OAI21X1 U5701 ( .A0(n6477), .A1(net2891), .B0(n5664), .Y(n3160) );
  NOR2X1 U5702 ( .A(n5665), .B(n5666), .Y(n5664) );
  NOR2X1 U5703 ( .A(n5667), .B(n6431), .Y(n5665) );
  NOR2X1 U5704 ( .A(n6471), .B(n5393), .Y(n5666) );
  OAI21X1 U5705 ( .A0(n6477), .A1(net2895), .B0(n5657), .Y(n3162) );
  NOR2X1 U5706 ( .A(n5658), .B(n5659), .Y(n5657) );
  NOR2X1 U5707 ( .A(n4756), .B(n6431), .Y(n5658) );
  NOR2X1 U5708 ( .A(n6470), .B(n5394), .Y(n5659) );
  OAI21X1 U5709 ( .A0(n6478), .A1(net2897), .B0(n5654), .Y(n3163) );
  NOR2X1 U5710 ( .A(n5655), .B(n5656), .Y(n5654) );
  NOR2X1 U5711 ( .A(n4753), .B(n6431), .Y(n5655) );
  NOR2X1 U5712 ( .A(n6469), .B(n5395), .Y(n5656) );
  OAI21X1 U5713 ( .A0(n6477), .A1(net2901), .B0(n5647), .Y(n3165) );
  NOR2X1 U5714 ( .A(n5648), .B(n5649), .Y(n5647) );
  NOR2X1 U5715 ( .A(n4747), .B(n6431), .Y(n5648) );
  NOR2X1 U5716 ( .A(n6468), .B(n5396), .Y(n5649) );
  OAI21X1 U5717 ( .A0(n6478), .A1(net2903), .B0(n5644), .Y(n3166) );
  NOR2X1 U5718 ( .A(n5645), .B(n5646), .Y(n5644) );
  NOR2X1 U5719 ( .A(n4744), .B(n6431), .Y(n5645) );
  NOR2X1 U5720 ( .A(n6467), .B(n5397), .Y(n5646) );
  OAI21X1 U5721 ( .A0(n6477), .A1(net2907), .B0(n5637), .Y(n3168) );
  NOR2X1 U5722 ( .A(n5638), .B(n5639), .Y(n5637) );
  NOR2X1 U5723 ( .A(n4738), .B(n6431), .Y(n5638) );
  NOR2X1 U5724 ( .A(n6466), .B(n5398), .Y(n5639) );
  OAI21X1 U5725 ( .A0(n6478), .A1(net2911), .B0(n5629), .Y(n3170) );
  NOR2X1 U5726 ( .A(n5630), .B(n5631), .Y(n5629) );
  NOR2X1 U5727 ( .A(n6431), .B(n5632), .Y(n5630) );
  NOR2X1 U5728 ( .A(n6465), .B(n5399), .Y(n5631) );
  OAI21X1 U5729 ( .A0(n6477), .A1(net2913), .B0(n5626), .Y(n3171) );
  NOR2X1 U5730 ( .A(n5627), .B(n5628), .Y(n5626) );
  NOR2X1 U5731 ( .A(n4729), .B(n6431), .Y(n5627) );
  NOR2X1 U5732 ( .A(n6464), .B(n5400), .Y(n5628) );
  OAI21X1 U5733 ( .A0(n6478), .A1(net2917), .B0(n5618), .Y(n3173) );
  NOR2X1 U5734 ( .A(n5619), .B(n5620), .Y(n5618) );
  NOR2X1 U5735 ( .A(n5621), .B(n6431), .Y(n5619) );
  NOR2X1 U5736 ( .A(n6466), .B(n5401), .Y(n5620) );
  OAI21X1 U5737 ( .A0(n6477), .A1(net2919), .B0(n5614), .Y(n3174) );
  NOR2X1 U5738 ( .A(n5615), .B(n5616), .Y(n5614) );
  NOR2X1 U5739 ( .A(n6432), .B(n5617), .Y(n5615) );
  NOR2X1 U5740 ( .A(n6469), .B(n5402), .Y(n5616) );
  OAI21X1 U5741 ( .A0(n6478), .A1(net2923), .B0(n5608), .Y(n3176) );
  NOR2X1 U5742 ( .A(n5609), .B(n5610), .Y(n5608) );
  NOR2X1 U5743 ( .A(n4714), .B(n6431), .Y(n5609) );
  NOR2X1 U5744 ( .A(n6464), .B(n5403), .Y(n5610) );
  OAI21X1 U5745 ( .A0(n6477), .A1(net2925), .B0(n5604), .Y(n3177) );
  NOR2X1 U5746 ( .A(n5605), .B(n5606), .Y(n5604) );
  NOR2X1 U5747 ( .A(n6432), .B(n5607), .Y(n5605) );
  NOR2X1 U5748 ( .A(n6463), .B(n5404), .Y(n5606) );
  OAI21X1 U5749 ( .A0(n6478), .A1(net2927), .B0(n5600), .Y(n3178) );
  NOR2X1 U5750 ( .A(n5601), .B(n5602), .Y(n5600) );
  NOR2X1 U5751 ( .A(n6432), .B(n5603), .Y(n5601) );
  NOR2X1 U5752 ( .A(n6466), .B(n5405), .Y(n5602) );
  OAI21X1 U5753 ( .A0(n6477), .A1(net2931), .B0(n5592), .Y(n3180) );
  NOR2X1 U5754 ( .A(n5593), .B(n5594), .Y(n5592) );
  NOR2X1 U5755 ( .A(n6432), .B(n5595), .Y(n5593) );
  NOR2X1 U5756 ( .A(n6473), .B(n5406), .Y(n5594) );
  OAI21X1 U5757 ( .A0(n6478), .A1(net2933), .B0(n5588), .Y(n3181) );
  NOR2X1 U5758 ( .A(n5589), .B(n5590), .Y(n5588) );
  NOR2X1 U5759 ( .A(n6431), .B(n5591), .Y(n5589) );
  NOR2X1 U5760 ( .A(n6472), .B(n5407), .Y(n5590) );
  OAI21X1 U5761 ( .A0(n6477), .A1(net2937), .B0(n5580), .Y(n3183) );
  NOR2X1 U5762 ( .A(n5581), .B(n5582), .Y(n5580) );
  NOR2X1 U5763 ( .A(n6432), .B(n5583), .Y(n5581) );
  NOR2X1 U5764 ( .A(n6471), .B(n5408), .Y(n5582) );
  OAI21X1 U5765 ( .A0(n6478), .A1(net2939), .B0(n5576), .Y(n3184) );
  NOR2X1 U5766 ( .A(n5577), .B(n5578), .Y(n5576) );
  NOR2X1 U5767 ( .A(n6432), .B(n5579), .Y(n5577) );
  NOR2X1 U5768 ( .A(n6470), .B(n5409), .Y(n5578) );
  OAI21X1 U5769 ( .A0(n6477), .A1(net2941), .B0(n5573), .Y(n3185) );
  NOR2X1 U5770 ( .A(n5574), .B(n5575), .Y(n5573) );
  NOR2X1 U5771 ( .A(n4687), .B(n6431), .Y(n5574) );
  NOR2X1 U5772 ( .A(n6469), .B(n5410), .Y(n5575) );
  OAI21X1 U5773 ( .A0(n6478), .A1(net2943), .B0(n5569), .Y(n3186) );
  NOR2X1 U5774 ( .A(n5570), .B(n5571), .Y(n5569) );
  NOR2X1 U5775 ( .A(n6432), .B(n5572), .Y(n5570) );
  NOR2X1 U5776 ( .A(n6468), .B(n5411), .Y(n5571) );
  OAI21X1 U5777 ( .A0(n5688), .A1(n5689), .B0(n6482), .Y(n3154) );
  MXI2X1 U5778 ( .S0(n5276), .B(cas_5_final), .A(cas_6_final), .Y(n5689) );
  NOR2X1 U5779 ( .A(n5556), .B(n5549), .Y(n5688) );
  OAI21X1 U5780 ( .A0(n5563), .A1(n5564), .B0(n6431), .Y(n3188) );
  MXI2X1 U5781 ( .S0(n5565), .B(cas_6_final), .A(cas_7_final), .Y(n5564) );
  NOR2X1 U5782 ( .A(n5556), .B(n5550), .Y(n5563) );
  INVX1 U5783 ( .A(n6467), .Y(n5565) );
  NAND2X1 U5784 ( .A(n5773), .B(n4842), .Y(n3120) );
  MXI2X1 U5785 ( .S0(n5775), .B(cas_4_final), .A(n5774), .Y(n5773) );
  NOR2X1 U5786 ( .A(n5277), .B(n5481), .Y(n5774) );
  NOR2X1 U5787 ( .A(n6442), .B(n5277), .Y(n5775) );
  NOR2X1 U5788 ( .A(n5040), .B(n6247), .Y(n6242) );
  NOR2X1 U5789 ( .A(cas_cnt_b3_pos_3_), .B(cas_cnt_b3_pos_4_), .Y(n6247) );
  NOR2X1 U5790 ( .A(n6458), .B(n5468), .Y(n5988) );
  NAND3X1 U5791 ( .A(n6288), .B(n6289), .C(n6290), .Y(n2975) );
  NAND2X1 U5792 ( .A(n5031), .B(BA_TT[2]), .Y(n6288) );
  NAND2X1 U5793 ( .A(n5503), .B(cas_1_data_4_), .Y(n6289) );
  NAND2X1 U5794 ( .A(CAS_0_TT[2]), .B(n5484), .Y(n6290) );
  NAND3X1 U5795 ( .A(n6318), .B(n6319), .C(n6320), .Y(n2965) );
  NAND2X1 U5796 ( .A(n5031), .B(BA_RA[0]), .Y(n6318) );
  NAND2X1 U5797 ( .A(n5503), .B(cas_1_data_14_), .Y(n6319) );
  NAND2X1 U5798 ( .A(CAS_0_RA[0]), .B(n5484), .Y(n6320) );
  NAND3X1 U5799 ( .A(n6339), .B(n6340), .C(n6341), .Y(n2958) );
  NAND2X1 U5800 ( .A(n5031), .B(BA_RA[7]), .Y(n6339) );
  NAND2X1 U5801 ( .A(n5503), .B(cas_1_data_21_), .Y(n6340) );
  NAND2X1 U5802 ( .A(CAS_0_RA[7]), .B(n5484), .Y(n6341) );
  NAND3X1 U5803 ( .A(n6330), .B(n6331), .C(n6332), .Y(n2961) );
  NAND2X1 U5804 ( .A(n5031), .B(n6435), .Y(n6330) );
  NAND2X1 U5805 ( .A(n5503), .B(cas_1_data_18_), .Y(n6331) );
  NAND2X1 U5806 ( .A(CAS_0_RA[4]), .B(n5484), .Y(n6332) );
  NAND3X1 U5807 ( .A(n6321), .B(n6322), .C(n6323), .Y(n2964) );
  NAND2X1 U5808 ( .A(n5031), .B(BA_RA[1]), .Y(n6321) );
  NAND2X1 U5809 ( .A(n5503), .B(cas_1_data_15_), .Y(n6322) );
  NAND2X1 U5810 ( .A(CAS_0_RA[1]), .B(n5484), .Y(n6323) );
  NAND3X1 U5811 ( .A(n6315), .B(n6316), .C(n6317), .Y(n2966) );
  NAND2X1 U5812 ( .A(n5031), .B(BA_CA[7]), .Y(n6315) );
  NAND2X1 U5813 ( .A(n5503), .B(cas_1_data_13_), .Y(n6316) );
  NAND2X1 U5814 ( .A(CAS_0_CA[7]), .B(n5484), .Y(n6317) );
  NAND3X1 U5815 ( .A(n6306), .B(n6307), .C(n6308), .Y(n2969) );
  NAND2X1 U5816 ( .A(n5031), .B(BA_CA[4]), .Y(n6306) );
  NAND2X1 U5817 ( .A(n5503), .B(cas_1_data_10_), .Y(n6307) );
  NAND2X1 U5818 ( .A(CAS_0_CA[4]), .B(n5484), .Y(n6308) );
  NAND3X1 U5819 ( .A(n6297), .B(n6298), .C(n6299), .Y(n2972) );
  NAND2X1 U5820 ( .A(n5031), .B(BA_CA[1]), .Y(n6297) );
  NAND2X1 U5821 ( .A(n5503), .B(cas_1_data_7_), .Y(n6298) );
  NAND2X1 U5822 ( .A(CAS_0_CA[1]), .B(n5484), .Y(n6299) );
  NAND3X1 U5823 ( .A(n6276), .B(n6277), .C(n6278), .Y(n2979) );
  NAND2X1 U5824 ( .A(n5031), .B(BA_ID[2]), .Y(n6276) );
  NAND2X1 U5825 ( .A(n5503), .B(cas_1_data_30_), .Y(n6277) );
  NAND2X1 U5826 ( .A(CAS_0_ID[2]), .B(n5484), .Y(n6278) );
  NAND3X1 U5827 ( .A(n6267), .B(n6268), .C(n6269), .Y(n2982) );
  NAND2X1 U5828 ( .A(n5031), .B(BA_RW), .Y(n6267) );
  NAND2X1 U5829 ( .A(n5503), .B(cas_1_data_1_), .Y(n6268) );
  NAND2X1 U5830 ( .A(CAS_0_RW), .B(n5484), .Y(n6269) );
  NAND3X1 U5831 ( .A(n6354), .B(n6355), .C(n6356), .Y(n2953) );
  NAND2X1 U5832 ( .A(n5031), .B(BA_BA[0]), .Y(n6354) );
  NAND2X1 U5833 ( .A(n5503), .B(cas_1_data_26_), .Y(n6355) );
  NAND2X1 U5834 ( .A(CAS_0_BA[0]), .B(n5484), .Y(n6356) );
  OR2X1 U5835 ( .A(n5509), .B(n5754), .Y(n3127) );
  AO22X1 U5836 ( .A0(n5492), .A1(cas_6_data_26_), .B0(n5692), .B1(BA_BA[0]), 
        .Y(n5509) );
  NOR2X1 U5837 ( .A(n6459), .B(n5469), .Y(n5754) );
  NAND3X1 U5838 ( .A(n5280), .B(n5557), .C(n5558), .Y(n3189) );
  NAND2X1 U5839 ( .A(cas_7_newrow), .B(n5559), .Y(n5558) );
  NAND2X1 U5840 ( .A(n5561), .B(n4660), .Y(n5557) );
  NAND3X1 U5841 ( .A(n6187), .B(n6188), .C(n6189), .Y(n2985) );
  NAND2X1 U5842 ( .A(n5867), .B(n5541), .Y(n6189) );
  NAND2X1 U5843 ( .A(CAS_0_NEWROW), .B(n5484), .Y(n6188) );
  NAND2X1 U5844 ( .A(n6260), .B(cas_1_newrow), .Y(n6187) );
  NAND3X1 U5845 ( .A(n5278), .B(n6074), .C(n6075), .Y(n3019) );
  NAND2X1 U5846 ( .A(n6078), .B(n5867), .Y(n6074) );
  NAND2X1 U5847 ( .A(n6076), .B(cas_2_newrow), .Y(n6075) );
  NAND2X1 U5848 ( .A(n5986), .B(n5867), .Y(n5984) );
  NAND2X1 U5849 ( .A(n5496), .B(cas_3_newrow), .Y(n5985) );
  NAND3X1 U5850 ( .A(n5279), .B(n5862), .C(n5863), .Y(n3087) );
  NAND2X1 U5851 ( .A(n5866), .B(n5867), .Y(n5862) );
  NAND2X1 U5852 ( .A(n5864), .B(cas_4_newrow), .Y(n5863) );
  NAND2X1 U5853 ( .A(n5686), .B(n4660), .Y(n5683) );
  NAND2X1 U5854 ( .A(n5685), .B(cas_6_newrow), .Y(n5684) );
  OR2X1 U5855 ( .A(n5510), .B(n5740), .Y(n3133) );
  AO22X1 U5856 ( .A0(n5492), .A1(cas_6_data_20_), .B0(n5692), .B1(BA_RA[6]), 
        .Y(n5510) );
  NOR2X1 U5857 ( .A(n6459), .B(n5470), .Y(n5740) );
  OR2X1 U5858 ( .A(n5511), .B(n5729), .Y(n3138) );
  AO22X1 U5859 ( .A0(n5492), .A1(cas_6_data_15_), .B0(n5692), .B1(BA_RA[1]), 
        .Y(n5511) );
  NOR2X1 U5860 ( .A(n6459), .B(n5471), .Y(n5729) );
  INVX1 U5861 ( .A(n5156), .Y(n5097) );
  NAND4BX1 U5862 ( .AN(n5157), .B(n5158), .C(n5159), .D(n5160), .Y(n5156) );
  XOR2X1 U5863 ( .A(BA_RA[4]), .B(B2_LAST_RA[4]), .Y(n5157) );
  XOR2X1 U5864 ( .A(n4738), .B(B2_LAST_RA[5]), .Y(n5158) );
  NAND2X1 U5865 ( .A(n5505), .B(n6255), .Y(n6254) );
  NAND2X1 U5866 ( .A(n5306), .B(n5296), .Y(n6255) );
  INVX1 U5867 ( .A(n5167), .Y(n5096) );
  NAND3BX1 U5868 ( .AN(n5168), .B(n5169), .C(n5170), .Y(n5167) );
  XOR2X1 U5869 ( .A(n4729), .B(B2_LAST_RA[2]), .Y(n5170) );
  XOR2X1 U5870 ( .A(BA_RA[3]), .B(B2_LAST_RA[3]), .Y(n5168) );
  INVX1 U5871 ( .A(n5152), .Y(n5101) );
  NAND3BX1 U5872 ( .AN(n5153), .B(n5154), .C(n5155), .Y(n5152) );
  XOR2X1 U5873 ( .A(n4729), .B(B3_LAST_RA[2]), .Y(n5155) );
  XOR2X1 U5874 ( .A(BA_RA[3]), .B(B3_LAST_RA[3]), .Y(n5153) );
  OR2X1 U5875 ( .A(n5512), .B(n5705), .Y(n3148) );
  AO22X1 U5876 ( .A0(n5492), .A1(cas_6_data_5_), .B0(n5692), .B1(BA_TT[3]), 
        .Y(n5512) );
  NOR2X1 U5877 ( .A(n6459), .B(n5472), .Y(n5705) );
  OR2X1 U5878 ( .A(n5513), .B(n5765), .Y(n3122) );
  AO22X1 U5879 ( .A0(n5492), .A1(cas_6_data_31_), .B0(n5692), .B1(BA_ID[3]), 
        .Y(n5513) );
  NOR2X1 U5880 ( .A(n6459), .B(n5473), .Y(n5765) );
  OR2X1 U5881 ( .A(n5514), .B(n5761), .Y(n3124) );
  AO22X1 U5882 ( .A0(n5492), .A1(cas_6_data_29_), .B0(n5692), .B1(BA_ID[1]), 
        .Y(n5514) );
  NOR2X1 U5883 ( .A(n6459), .B(n5474), .Y(n5761) );
  OR2X1 U5884 ( .A(n5515), .B(n5722), .Y(n3141) );
  AO22X1 U5885 ( .A0(n5492), .A1(cas_6_data_12_), .B0(n5692), .B1(BA_CA[6]), 
        .Y(n5515) );
  NOR2X1 U5886 ( .A(n6459), .B(n5475), .Y(n5722) );
  OR2X1 U5887 ( .A(n5516), .B(n5712), .Y(n3145) );
  AO22X1 U5888 ( .A0(n5492), .A1(cas_6_data_8_), .B0(n5692), .B1(BA_CA[2]), 
        .Y(n5516) );
  NOR2X1 U5889 ( .A(n6459), .B(n5476), .Y(n5712) );
  OR2X1 U5890 ( .A(n5517), .B(n5747), .Y(n3130) );
  AO22X1 U5891 ( .A0(n5492), .A1(cas_6_data_23_), .B0(n5692), .B1(n6433), .Y(
        n5517) );
  NOR2X1 U5892 ( .A(n6459), .B(n5477), .Y(n5747) );
  OR2X1 U5893 ( .A(n5518), .B(n5736), .Y(n3135) );
  AO22X1 U5894 ( .A0(n5492), .A1(cas_6_data_18_), .B0(n5692), .B1(n6435), .Y(
        n5518) );
  NOR2X1 U5895 ( .A(n6459), .B(n5478), .Y(n5736) );
  OR2X1 U5896 ( .A(n5519), .B(n5691), .Y(n3153) );
  AO22X1 U5897 ( .A0(n5492), .A1(cas_6_data_0_), .B0(n5692), .B1(BA_PM), .Y(
        n5519) );
  NOR2X1 U5898 ( .A(n6459), .B(n5479), .Y(n5691) );
  AO21X1 U5899 ( .A0(n5029), .A1(n5030), .B0(n5031), .Y(n2984) );
  NAND3X1 U5900 ( .A(n5539), .B(n5540), .C(n5541), .Y(n5030) );
  MXI2X1 U5901 ( .S0(n5484), .B(net3025), .A(n5482), .Y(n5029) );
  NOR2X1 U5902 ( .A(n5542), .B(n5543), .Y(n5540) );
  OAI221X1 U5903 ( .A0(n4674), .A1(n4938), .B0(n4890), .B1(n4938), .C0(n6490), 
        .Y(n3052) );
  INVX1 U5904 ( .A(n5550), .Y(n4674) );
  MXI2X1 U5905 ( .S0(n5497), .B(cas_2_final), .A(cas_3_final), .Y(n4938) );
  OAI221X1 U5906 ( .A0(n4661), .A1(n4889), .B0(n4890), .B1(n4889), .C0(n5534), 
        .Y(n3086) );
  MXI2X1 U5907 ( .S0(n5275), .B(cas_3_final), .A(cas_4_final), .Y(n4889) );
  OAI221X1 U5908 ( .A0(n4789), .A1(n4983), .B0(n4890), .B1(n4983), .C0(n6489), 
        .Y(n3018) );
  INVX1 U5909 ( .A(n5549), .Y(n4789) );
  MXI2X1 U5910 ( .S0(n5274), .B(cas_1_final), .A(cas_2_final), .Y(n4983) );
  NAND2X1 U5911 ( .A(n6183), .B(n6184), .Y(n2986) );
  AOI21X1 U5912 ( .A0(n5494), .A1(cas_2_data_31_), .B0(n6186), .Y(n6183) );
  INVX1 U5913 ( .A(n6185), .Y(n6184) );
  NOR2X1 U5914 ( .A(n6436), .B(n5983), .Y(n6186) );
  NAND2X1 U5915 ( .A(n6176), .B(n6177), .Y(n2988) );
  AOI21X1 U5916 ( .A0(n5494), .A1(cas_2_data_29_), .B0(n6179), .Y(n6176) );
  INVX1 U5917 ( .A(n6178), .Y(n6177) );
  NOR2X1 U5918 ( .A(n6489), .B(n5975), .Y(n6179) );
  NAND2X1 U5919 ( .A(n6166), .B(n6167), .Y(n2991) );
  AOI21X1 U5920 ( .A0(n5494), .A1(cas_2_data_26_), .B0(n6169), .Y(n6166) );
  INVX1 U5921 ( .A(n6168), .Y(n6167) );
  NOR2X1 U5922 ( .A(n6489), .B(n5964), .Y(n6169) );
  NAND2X1 U5923 ( .A(n6156), .B(n6157), .Y(n2994) );
  AOI21X1 U5924 ( .A0(n5494), .A1(cas_2_data_23_), .B0(n6159), .Y(n6156) );
  INVX1 U5925 ( .A(n6158), .Y(n6157) );
  NOR2X1 U5926 ( .A(n6489), .B(n4750), .Y(n6159) );
  NAND2X1 U5927 ( .A(n6146), .B(n6147), .Y(n2997) );
  AOI21X1 U5928 ( .A0(n5494), .A1(cas_2_data_20_), .B0(n6149), .Y(n6146) );
  INVX1 U5929 ( .A(n6148), .Y(n6147) );
  NOR2X1 U5930 ( .A(n6489), .B(n4741), .Y(n6149) );
  NAND2X1 U5931 ( .A(n6139), .B(n6140), .Y(n2999) );
  AOI21X1 U5932 ( .A0(n5494), .A1(cas_2_data_18_), .B0(n6142), .Y(n6139) );
  INVX1 U5933 ( .A(n6141), .Y(n6140) );
  NOR2X1 U5934 ( .A(n6489), .B(n4735), .Y(n6142) );
  NAND2X1 U5935 ( .A(n6129), .B(n6130), .Y(n3002) );
  AOI21X1 U5936 ( .A0(n5494), .A1(cas_2_data_15_), .B0(n6132), .Y(n6129) );
  INVX1 U5937 ( .A(n6131), .Y(n6130) );
  NOR2X1 U5938 ( .A(n6489), .B(n4726), .Y(n6132) );
  NAND2X1 U5939 ( .A(n6119), .B(n6120), .Y(n3005) );
  AOI21X1 U5940 ( .A0(n5494), .A1(cas_2_data_12_), .B0(n6122), .Y(n6119) );
  INVX1 U5941 ( .A(n6121), .Y(n6120) );
  NOR2X1 U5942 ( .A(n6436), .B(n5916), .Y(n6122) );
  NAND2X1 U5943 ( .A(n6106), .B(n6107), .Y(n3009) );
  AOI21X1 U5944 ( .A0(n5494), .A1(cas_2_data_8_), .B0(n6109), .Y(n6106) );
  INVX1 U5945 ( .A(n6108), .Y(n6107) );
  NOR2X1 U5946 ( .A(n6436), .B(n5902), .Y(n6109) );
  NAND2X1 U5947 ( .A(n6096), .B(n6097), .Y(n3012) );
  AOI21X1 U5948 ( .A0(n5494), .A1(cas_2_data_5_), .B0(n6099), .Y(n6096) );
  INVX1 U5949 ( .A(n6098), .Y(n6097) );
  NOR2X1 U5950 ( .A(n6436), .B(n5891), .Y(n6099) );
  NAND2X1 U5951 ( .A(n6080), .B(n6081), .Y(n3017) );
  AOI21X1 U5952 ( .A0(n5494), .A1(cas_2_data_0_), .B0(n6083), .Y(n6080) );
  INVX1 U5953 ( .A(n6082), .Y(n6081) );
  NOR2X1 U5954 ( .A(n6436), .B(n5874), .Y(n6083) );
  NAND2X1 U5955 ( .A(n6072), .B(n5286), .Y(n3020) );
  AOI21X1 U5956 ( .A0(n5495), .A1(cas_3_data_31_), .B0(n6073), .Y(n6072) );
  NOR2X1 U5957 ( .A(n6490), .B(n5983), .Y(n6073) );
  NAND2X1 U5958 ( .A(n6067), .B(n5287), .Y(n3022) );
  AOI21X1 U5959 ( .A0(n5495), .A1(cas_3_data_29_), .B0(n6068), .Y(n6067) );
  NOR2X1 U5960 ( .A(n6490), .B(n5975), .Y(n6068) );
  NAND2X1 U5961 ( .A(n6059), .B(n5281), .Y(n3025) );
  AOI21X1 U5962 ( .A0(n5495), .A1(cas_3_data_26_), .B0(n6060), .Y(n6059) );
  NOR2X1 U5963 ( .A(n6490), .B(n5964), .Y(n6060) );
  NAND2X1 U5964 ( .A(n6051), .B(n5288), .Y(n3028) );
  AOI21X1 U5965 ( .A0(n5495), .A1(cas_3_data_23_), .B0(n6052), .Y(n6051) );
  NOR2X1 U5966 ( .A(n6490), .B(n4750), .Y(n6052) );
  NAND2X1 U5967 ( .A(n6043), .B(n5282), .Y(n3031) );
  AOI21X1 U5968 ( .A0(n5495), .A1(cas_3_data_20_), .B0(n6044), .Y(n6043) );
  NOR2X1 U5969 ( .A(n6490), .B(n4741), .Y(n6044) );
  NAND2X1 U5970 ( .A(n6038), .B(n5283), .Y(n3033) );
  AOI21X1 U5971 ( .A0(n5495), .A1(cas_3_data_18_), .B0(n6039), .Y(n6038) );
  NOR2X1 U5972 ( .A(n6490), .B(n4735), .Y(n6039) );
  NAND2X1 U5973 ( .A(n6030), .B(n5289), .Y(n3036) );
  AOI21X1 U5974 ( .A0(n5495), .A1(cas_3_data_15_), .B0(n6031), .Y(n6030) );
  NOR2X1 U5975 ( .A(n6490), .B(n4726), .Y(n6031) );
  NAND2X1 U5976 ( .A(n6022), .B(n5284), .Y(n3039) );
  AOI21X1 U5977 ( .A0(n5495), .A1(cas_3_data_12_), .B0(n6023), .Y(n6022) );
  NOR2X1 U5978 ( .A(n6490), .B(n5916), .Y(n6023) );
  NAND2X1 U5979 ( .A(n6011), .B(n5290), .Y(n3043) );
  AOI21X1 U5980 ( .A0(n5495), .A1(cas_3_data_8_), .B0(n6012), .Y(n6011) );
  NOR2X1 U5981 ( .A(n6490), .B(n5902), .Y(n6012) );
  NAND2X1 U5982 ( .A(n6003), .B(n5285), .Y(n3046) );
  AOI21X1 U5983 ( .A0(n5495), .A1(cas_3_data_5_), .B0(n6004), .Y(n6003) );
  NOR2X1 U5984 ( .A(n6490), .B(n5891), .Y(n6004) );
  NAND2X1 U5985 ( .A(n5989), .B(n5291), .Y(n3051) );
  AOI21X1 U5986 ( .A0(n5495), .A1(cas_3_data_0_), .B0(n5990), .Y(n5989) );
  NOR2X1 U5987 ( .A(n6490), .B(n5874), .Y(n5990) );
  NAND2X1 U5988 ( .A(n5979), .B(n5980), .Y(n3054) );
  AOI21X1 U5989 ( .A0(n5498), .A1(cas_4_data_31_), .B0(n5982), .Y(n5979) );
  INVX1 U5990 ( .A(n5981), .Y(n5980) );
  NOR2X1 U5991 ( .A(n5534), .B(n5983), .Y(n5982) );
  NAND2X1 U5992 ( .A(n5971), .B(n5972), .Y(n3056) );
  AOI21X1 U5993 ( .A0(n5498), .A1(cas_4_data_29_), .B0(n5974), .Y(n5971) );
  INVX1 U5994 ( .A(n5973), .Y(n5972) );
  NOR2X1 U5995 ( .A(n5534), .B(n5975), .Y(n5974) );
  NAND2X1 U5996 ( .A(n5960), .B(n5961), .Y(n3059) );
  AOI21X1 U5997 ( .A0(n5498), .A1(cas_4_data_26_), .B0(n5963), .Y(n5960) );
  INVX1 U5998 ( .A(n5962), .Y(n5961) );
  NOR2X1 U5999 ( .A(n5534), .B(n5964), .Y(n5963) );
  NAND2X1 U6000 ( .A(n5950), .B(n5951), .Y(n3062) );
  AOI21X1 U6001 ( .A0(n5498), .A1(cas_4_data_23_), .B0(n5953), .Y(n5950) );
  INVX1 U6002 ( .A(n5952), .Y(n5951) );
  NOR2X1 U6003 ( .A(n5534), .B(n4750), .Y(n5953) );
  NAND2X1 U6004 ( .A(n5940), .B(n5941), .Y(n3065) );
  AOI21X1 U6005 ( .A0(n5498), .A1(cas_4_data_20_), .B0(n5943), .Y(n5940) );
  INVX1 U6006 ( .A(n5942), .Y(n5941) );
  NOR2X1 U6007 ( .A(n5534), .B(n4741), .Y(n5943) );
  NAND2X1 U6008 ( .A(n5933), .B(n5934), .Y(n3067) );
  AOI21X1 U6009 ( .A0(n5498), .A1(cas_4_data_18_), .B0(n5936), .Y(n5933) );
  INVX1 U6010 ( .A(n5935), .Y(n5934) );
  NOR2X1 U6011 ( .A(n5534), .B(n4735), .Y(n5936) );
  NAND2X1 U6012 ( .A(n5923), .B(n5924), .Y(n3070) );
  AOI21X1 U6013 ( .A0(n5498), .A1(cas_4_data_15_), .B0(n5926), .Y(n5923) );
  INVX1 U6014 ( .A(n5925), .Y(n5924) );
  NOR2X1 U6015 ( .A(n5534), .B(n4726), .Y(n5926) );
  NAND2X1 U6016 ( .A(n5912), .B(n5913), .Y(n3073) );
  AOI21X1 U6017 ( .A0(n5498), .A1(cas_4_data_12_), .B0(n5915), .Y(n5912) );
  INVX1 U6018 ( .A(n5914), .Y(n5913) );
  NOR2X1 U6019 ( .A(n5534), .B(n5916), .Y(n5915) );
  NAND2X1 U6020 ( .A(n5898), .B(n5899), .Y(n3077) );
  AOI21X1 U6021 ( .A0(n5498), .A1(cas_4_data_8_), .B0(n5901), .Y(n5898) );
  INVX1 U6022 ( .A(n5900), .Y(n5899) );
  NOR2X1 U6023 ( .A(n5534), .B(n5902), .Y(n5901) );
  NAND2X1 U6024 ( .A(n5887), .B(n5888), .Y(n3080) );
  AOI21X1 U6025 ( .A0(n5498), .A1(cas_4_data_5_), .B0(n5890), .Y(n5887) );
  INVX1 U6026 ( .A(n5889), .Y(n5888) );
  NOR2X1 U6027 ( .A(n5534), .B(n5891), .Y(n5890) );
  NAND2X1 U6028 ( .A(n5870), .B(n5871), .Y(n3085) );
  AOI21X1 U6029 ( .A0(n5498), .A1(cas_4_data_0_), .B0(n5873), .Y(n5870) );
  INVX1 U6030 ( .A(n5872), .Y(n5871) );
  NOR2X1 U6031 ( .A(n5534), .B(n5874), .Y(n5873) );
  OAI21X1 U6032 ( .A0(n6392), .A1(n6393), .B0(n6480), .Y(n6246) );
  NAND2X1 U6033 ( .A(cas_cnt_b2_pos_0_), .B(cas_cnt_b2_pos_1_), .Y(n6393) );
  NAND3X1 U6034 ( .A(cas_cnt_b2_pos_4_), .B(cas_cnt_b2_pos_3_), .C(
        cas_cnt_b2_pos_2_), .Y(n6392) );
  OAI21X1 U6035 ( .A0(n6425), .A1(n6426), .B0(n6479), .Y(n6257) );
  NAND2X1 U6036 ( .A(cas_cnt_b0_pos_4_), .B(cas_cnt_b0_pos_3_), .Y(n6426) );
  NAND3X1 U6037 ( .A(cas_cnt_b0_pos_0_), .B(cas_cnt_b0_pos_1_), .C(
        cas_cnt_b0_pos_2_), .Y(n6425) );
  XOR2X1 U6038 ( .A(n4741), .B(B2_LAST_RA[6]), .Y(n5160) );
  XOR2X1 U6039 ( .A(n4741), .B(B3_LAST_RA[6]), .Y(n5145) );
  XOR2X1 U6040 ( .A(n4750), .B(B3_LAST_RA[9]), .Y(n5144) );
  NAND3BX1 U6041 ( .AN(n5116), .B(n5117), .C(n5118), .Y(n5108) );
  XOR2X1 U6042 ( .A(n4744), .B(B0_LAST_RA[7]), .Y(n5117) );
  XOR2X1 U6043 ( .A(n4747), .B(B0_LAST_RA[8]), .Y(n5118) );
  XOR2X1 U6044 ( .A(BA_RA[9]), .B(B0_LAST_RA[9]), .Y(n5116) );
  NAND3BX1 U6045 ( .AN(n5131), .B(n5132), .C(n5133), .Y(n5123) );
  XOR2X1 U6046 ( .A(n4744), .B(B1_LAST_RA[7]), .Y(n5132) );
  XOR2X1 U6047 ( .A(n4747), .B(B1_LAST_RA[8]), .Y(n5133) );
  XOR2X1 U6048 ( .A(BA_RA[9]), .B(B1_LAST_RA[9]), .Y(n5131) );
  AO21X1 U6049 ( .A0(cas_cnt1375_2_), .A1(n5499), .B0(n5243), .Y(n429_2_) );
  AO22X1 U6050 ( .A0(cas_cnt_2_), .A1(n5244), .B0(cas_cnt1419_2_), .B1(n5245), 
        .Y(n5243) );
  NAND3BX1 U6051 ( .AN(n5119), .B(n5120), .C(n5121), .Y(n5107) );
  XOR2X1 U6052 ( .A(n4735), .B(B0_LAST_RA[4]), .Y(n5120) );
  XOR2X1 U6053 ( .A(n4738), .B(B0_LAST_RA[5]), .Y(n5121) );
  XOR2X1 U6054 ( .A(BA_RA[6]), .B(B0_LAST_RA[6]), .Y(n5119) );
  NAND3BX1 U6055 ( .AN(n5134), .B(n5135), .C(n5136), .Y(n5122) );
  XOR2X1 U6056 ( .A(n4735), .B(B1_LAST_RA[4]), .Y(n5135) );
  XOR2X1 U6057 ( .A(n4738), .B(B1_LAST_RA[5]), .Y(n5136) );
  XOR2X1 U6058 ( .A(BA_RA[6]), .B(B1_LAST_RA[6]), .Y(n5134) );
  AO21X1 U6059 ( .A0(cas_cnt1375_3_), .A1(n5499), .B0(n5246), .Y(n429_3_) );
  AO22X1 U6060 ( .A0(cas_cnt_3_), .A1(n5244), .B0(cas_cnt1419_3_), .B1(n5245), 
        .Y(n5246) );
  NAND3X1 U6061 ( .A(n5844), .B(n5845), .C(n5846), .Y(n3093) );
  NAND2X1 U6062 ( .A(cas_4_data_26_), .B(n5847), .Y(n5846) );
  NAND2X1 U6063 ( .A(BA_BA[0]), .B(n5500), .Y(n5845) );
  NAND2X1 U6064 ( .A(n5491), .B(cas_5_data_26_), .Y(n5844) );
  NAND3X1 U6065 ( .A(n6416), .B(n6417), .C(n6418), .Y(n2934) );
  NAND2X1 U6066 ( .A(n6414), .B(n181_2_), .Y(n6417) );
  NAND2X1 U6067 ( .A(n6410), .B(cas_cnt_b0_pos_2_), .Y(n6416) );
  NAND2X1 U6068 ( .A(n5504), .B(cas_cnt_b0_pos1445_2_), .Y(n6418) );
  NAND3X1 U6069 ( .A(n6419), .B(n6420), .C(n6421), .Y(n2933) );
  NAND2X1 U6070 ( .A(n6414), .B(n181_3_), .Y(n6420) );
  NAND2X1 U6071 ( .A(n6410), .B(cas_cnt_b0_pos_3_), .Y(n6419) );
  NAND2X1 U6072 ( .A(cas_cnt_b0_pos1445_3_), .B(n5504), .Y(n6421) );
  NAND3X1 U6073 ( .A(n5858), .B(n5859), .C(n5860), .Y(n3088) );
  NAND2X1 U6074 ( .A(cas_4_data_31_), .B(n5861), .Y(n5860) );
  NAND2X1 U6075 ( .A(BA_ID[3]), .B(n5500), .Y(n5859) );
  NAND2X1 U6076 ( .A(n5491), .B(cas_5_data_31_), .Y(n5858) );
  NAND3X1 U6077 ( .A(n5854), .B(n5855), .C(n5856), .Y(n3090) );
  NAND2X1 U6078 ( .A(cas_4_data_29_), .B(n5857), .Y(n5856) );
  NAND2X1 U6079 ( .A(BA_ID[1]), .B(n5500), .Y(n5855) );
  NAND2X1 U6080 ( .A(n5491), .B(cas_5_data_29_), .Y(n5854) );
  NAND3X1 U6081 ( .A(n5837), .B(n5838), .C(n5839), .Y(n3096) );
  NAND2X1 U6082 ( .A(cas_4_data_23_), .B(n5840), .Y(n5839) );
  NAND2X1 U6083 ( .A(n6433), .B(n5500), .Y(n5838) );
  NAND2X1 U6084 ( .A(n5491), .B(cas_5_data_23_), .Y(n5837) );
  NAND3X1 U6085 ( .A(n5831), .B(n5832), .C(n5833), .Y(n3099) );
  NAND2X1 U6086 ( .A(cas_4_data_20_), .B(n6439), .Y(n5833) );
  NAND2X1 U6087 ( .A(BA_RA[6]), .B(n5500), .Y(n5832) );
  NAND2X1 U6088 ( .A(n5491), .B(cas_5_data_20_), .Y(n5831) );
  NAND3X1 U6089 ( .A(n5825), .B(n5826), .C(n5827), .Y(n3101) );
  NAND2X1 U6090 ( .A(cas_4_data_18_), .B(n6440), .Y(n5827) );
  NAND2X1 U6091 ( .A(n6435), .B(n5500), .Y(n5826) );
  NAND2X1 U6092 ( .A(n5491), .B(cas_5_data_18_), .Y(n5825) );
  NAND3X1 U6093 ( .A(n5819), .B(n5820), .C(n5821), .Y(n3104) );
  NAND2X1 U6094 ( .A(cas_4_data_15_), .B(n6439), .Y(n5821) );
  NAND2X1 U6095 ( .A(BA_RA[1]), .B(n5500), .Y(n5820) );
  NAND2X1 U6096 ( .A(n5491), .B(cas_5_data_15_), .Y(n5819) );
  NAND3X1 U6097 ( .A(n5810), .B(n5811), .C(n5812), .Y(n3107) );
  NAND2X1 U6098 ( .A(cas_4_data_12_), .B(n6439), .Y(n5812) );
  NAND2X1 U6099 ( .A(BA_CA[6]), .B(n5500), .Y(n5811) );
  NAND2X1 U6100 ( .A(n5491), .B(cas_5_data_12_), .Y(n5810) );
  NAND3X1 U6101 ( .A(n5801), .B(n5802), .C(n5803), .Y(n3111) );
  NAND2X1 U6102 ( .A(cas_4_data_8_), .B(n6439), .Y(n5803) );
  NAND2X1 U6103 ( .A(BA_CA[2]), .B(n5500), .Y(n5802) );
  NAND2X1 U6104 ( .A(n5491), .B(cas_5_data_8_), .Y(n5801) );
  NAND3X1 U6105 ( .A(n5791), .B(n5792), .C(n5793), .Y(n3114) );
  NAND2X1 U6106 ( .A(cas_4_data_5_), .B(n5794), .Y(n5793) );
  NAND2X1 U6107 ( .A(BA_TT[3]), .B(n5500), .Y(n5792) );
  NAND2X1 U6108 ( .A(n5491), .B(cas_5_data_5_), .Y(n5791) );
  NAND3X1 U6109 ( .A(n5778), .B(n5779), .C(n5780), .Y(n3119) );
  NAND2X1 U6110 ( .A(cas_4_data_0_), .B(n5781), .Y(n5780) );
  NAND2X1 U6111 ( .A(BA_PM), .B(n5500), .Y(n5779) );
  NAND2X1 U6112 ( .A(n5491), .B(cas_5_data_0_), .Y(n5778) );
  NAND3X1 U6113 ( .A(n5679), .B(n5680), .C(n5681), .Y(n3156) );
  NAND2X1 U6114 ( .A(BA_ID[3]), .B(n5682), .Y(n5679) );
  NAND2X1 U6115 ( .A(cas_7_data[31]), .B(n5493), .Y(n5680) );
  NAND2X1 U6116 ( .A(cas_6_data_31_), .B(n5636), .Y(n5681) );
  NAND3X1 U6117 ( .A(n5672), .B(n5673), .C(n5674), .Y(n3158) );
  NAND2X1 U6118 ( .A(BA_ID[1]), .B(n5682), .Y(n5672) );
  NAND2X1 U6119 ( .A(cas_7_data[29]), .B(n5493), .Y(n5673) );
  NAND2X1 U6120 ( .A(cas_6_data_29_), .B(n5675), .Y(n5674) );
  NAND3X1 U6121 ( .A(n5660), .B(n5661), .C(n5662), .Y(n3161) );
  NAND2X1 U6122 ( .A(n5625), .B(BA_BA[0]), .Y(n5660) );
  NAND2X1 U6123 ( .A(cas_7_data[26]), .B(n5493), .Y(n5661) );
  NAND2X1 U6124 ( .A(cas_6_data_26_), .B(n5663), .Y(n5662) );
  NAND3X1 U6125 ( .A(n5650), .B(n5651), .C(n5652), .Y(n3164) );
  NAND2X1 U6126 ( .A(n5625), .B(n6433), .Y(n5650) );
  NAND2X1 U6127 ( .A(cas_7_data[23]), .B(n5493), .Y(n5651) );
  NAND2X1 U6128 ( .A(cas_6_data_23_), .B(n5653), .Y(n5652) );
  NAND3X1 U6129 ( .A(n5640), .B(n5641), .C(n5642), .Y(n3167) );
  NAND2X1 U6130 ( .A(n5625), .B(BA_RA[6]), .Y(n5640) );
  NAND2X1 U6131 ( .A(cas_7_data[20]), .B(n5493), .Y(n5641) );
  NAND2X1 U6132 ( .A(cas_6_data_20_), .B(n5643), .Y(n5642) );
  NAND3X1 U6133 ( .A(n5633), .B(n5634), .C(n5635), .Y(n3169) );
  NAND2X1 U6134 ( .A(n5625), .B(n6435), .Y(n5633) );
  NAND2X1 U6135 ( .A(cas_7_data[18]), .B(n5493), .Y(n5634) );
  NAND2X1 U6136 ( .A(cas_6_data_18_), .B(n5636), .Y(n5635) );
  NAND3X1 U6137 ( .A(n5622), .B(n5623), .C(n5624), .Y(n3172) );
  NAND2X1 U6138 ( .A(n5625), .B(BA_RA[1]), .Y(n5622) );
  NAND2X1 U6139 ( .A(cas_7_data[15]), .B(n5493), .Y(n5623) );
  NAND2X1 U6140 ( .A(cas_6_data_15_), .B(n5663), .Y(n5624) );
  NAND3X1 U6141 ( .A(n5611), .B(n5612), .C(n5613), .Y(n3175) );
  NAND2X1 U6142 ( .A(BA_CA[6]), .B(n5682), .Y(n5611) );
  NAND2X1 U6143 ( .A(cas_7_data[12]), .B(n5493), .Y(n5612) );
  NAND2X1 U6144 ( .A(cas_6_data_12_), .B(n5643), .Y(n5613) );
  NAND3X1 U6145 ( .A(n5596), .B(n5597), .C(n5598), .Y(n3179) );
  NAND2X1 U6146 ( .A(BA_CA[2]), .B(n5682), .Y(n5596) );
  NAND2X1 U6147 ( .A(cas_7_data[8]), .B(n5493), .Y(n5597) );
  NAND2X1 U6148 ( .A(cas_6_data_8_), .B(n5599), .Y(n5598) );
  NAND3X1 U6149 ( .A(n5584), .B(n5585), .C(n5586), .Y(n3182) );
  NAND2X1 U6150 ( .A(BA_TT[3]), .B(n5682), .Y(n5584) );
  NAND2X1 U6151 ( .A(cas_7_data[5]), .B(n5493), .Y(n5585) );
  NAND2X1 U6152 ( .A(cas_6_data_5_), .B(n5587), .Y(n5586) );
  NAND3X1 U6153 ( .A(n5566), .B(n5567), .C(n5568), .Y(n3187) );
  NAND2X1 U6154 ( .A(BA_PM), .B(n5682), .Y(n5566) );
  NAND2X1 U6155 ( .A(cas_7_data[0]), .B(n5493), .Y(n5567) );
  NAND2X1 U6156 ( .A(cas_6_data_0_), .B(n5653), .Y(n5568) );
  AO22X1 U6157 ( .A0(cas_7_data[14]), .A1(n6487), .B0(n4662), .B1(BA_RA[0]), 
        .Y(n2917) );
  AO22X1 U6158 ( .A0(cas_7_data[17]), .A1(n6488), .B0(n4662), .B1(BA_RA[3]), 
        .Y(n2914) );
  NAND3X1 U6159 ( .A(n6394), .B(n6395), .C(n6396), .Y(n2939) );
  NAND2X1 U6160 ( .A(n181_2_), .B(n6398), .Y(n6395) );
  NAND2X1 U6161 ( .A(cas_cnt_b1_pos_2_), .B(n6399), .Y(n6394) );
  NAND2X1 U6162 ( .A(cas_cnt_b1_pos1456_2_), .B(n6397), .Y(n6396) );
  NAND3X1 U6163 ( .A(n6380), .B(n6381), .C(n6382), .Y(n2944) );
  NAND2X1 U6164 ( .A(cas_cnt_b2_pos_2_), .B(n6385), .Y(n6380) );
  NAND2X1 U6165 ( .A(n181_2_), .B(n6384), .Y(n6381) );
  NAND2X1 U6166 ( .A(cas_cnt_b2_pos1467_2_), .B(n6383), .Y(n6382) );
  NAND3X1 U6167 ( .A(n6364), .B(n6365), .C(n6366), .Y(n2949) );
  NAND2X1 U6168 ( .A(cas_cnt_b3_pos_2_), .B(n6369), .Y(n6364) );
  NAND2X1 U6169 ( .A(n181_2_), .B(n6368), .Y(n6365) );
  NAND2X1 U6170 ( .A(cas_cnt_b3_pos1478_2_), .B(n6367), .Y(n6366) );
  NAND3X1 U6171 ( .A(n6422), .B(n6423), .C(n6424), .Y(n2932) );
  NAND2X1 U6172 ( .A(n6414), .B(n6363), .Y(n6422) );
  NAND2X1 U6173 ( .A(n6410), .B(cas_cnt_b0_pos_4_), .Y(n6423) );
  NAND2X1 U6174 ( .A(cas_cnt_b0_pos1445_4_), .B(n5504), .Y(n6424) );
  NAND3X1 U6175 ( .A(n6403), .B(n6404), .C(n6405), .Y(n2937) );
  NAND2X1 U6176 ( .A(n6363), .B(n6398), .Y(n6404) );
  NAND2X1 U6177 ( .A(cas_cnt_b1_pos_4_), .B(n6399), .Y(n6403) );
  NAND2X1 U6178 ( .A(cas_cnt_b1_pos1456_4_), .B(n6397), .Y(n6405) );
  NAND3X1 U6179 ( .A(n6400), .B(n6401), .C(n6402), .Y(n2938) );
  NAND2X1 U6180 ( .A(n181_3_), .B(n6398), .Y(n6401) );
  NAND2X1 U6181 ( .A(cas_cnt_b1_pos_3_), .B(n6399), .Y(n6400) );
  NAND2X1 U6182 ( .A(cas_cnt_b1_pos1456_3_), .B(n6397), .Y(n6402) );
  NAND3X1 U6183 ( .A(n6389), .B(n6390), .C(n6391), .Y(n2942) );
  NAND2X1 U6184 ( .A(cas_cnt_b2_pos_4_), .B(n6385), .Y(n6389) );
  NAND2X1 U6185 ( .A(n6363), .B(n6384), .Y(n6390) );
  NAND2X1 U6186 ( .A(cas_cnt_b2_pos1467_4_), .B(n6383), .Y(n6391) );
  NAND3X1 U6187 ( .A(n6386), .B(n6387), .C(n6388), .Y(n2943) );
  NAND2X1 U6188 ( .A(n181_3_), .B(n6384), .Y(n6387) );
  NAND2X1 U6189 ( .A(cas_cnt_b2_pos_3_), .B(n6385), .Y(n6386) );
  NAND2X1 U6190 ( .A(cas_cnt_b2_pos1467_3_), .B(n6383), .Y(n6388) );
  NAND3X1 U6191 ( .A(n6373), .B(n6374), .C(n6375), .Y(n2947) );
  NAND2X1 U6192 ( .A(cas_cnt_b3_pos_4_), .B(n6369), .Y(n6373) );
  NAND2X1 U6193 ( .A(n6363), .B(n6368), .Y(n6374) );
  NAND2X1 U6194 ( .A(cas_cnt_b3_pos1478_4_), .B(n6367), .Y(n6375) );
  NAND3X1 U6195 ( .A(n6370), .B(n6371), .C(n6372), .Y(n2948) );
  NAND2X1 U6196 ( .A(cas_cnt_b3_pos_3_), .B(n6369), .Y(n6370) );
  NAND2X1 U6197 ( .A(n181_3_), .B(n6368), .Y(n6371) );
  NAND2X1 U6198 ( .A(cas_cnt_b3_pos1478_3_), .B(n6367), .Y(n6372) );
  AO22X1 U6199 ( .A0(cas_7_data[21]), .A1(n6487), .B0(n4662), .B1(BA_RA[7]), 
        .Y(n2910) );
  AO22X1 U6200 ( .A0(cas_7_data[22]), .A1(n6488), .B0(n4662), .B1(BA_RA[8]), 
        .Y(n2909) );
  AO22X1 U6201 ( .A0(cas_7_data[16]), .A1(n6488), .B0(n4662), .B1(BA_RA[2]), 
        .Y(n2915) );
  AO22X1 U6202 ( .A0(cas_7_data[26]), .A1(n5230), .B0(n4662), .B1(BA_BA[0]), 
        .Y(n2905) );
  AO22X1 U6203 ( .A0(cas_7_data[25]), .A1(n6488), .B0(n4662), .B1(BA_RA[11]), 
        .Y(n2906) );
  AO22X1 U6204 ( .A0(cas_7_data[19]), .A1(n6488), .B0(n4662), .B1(BA_RA[5]), 
        .Y(n2912) );
  AO22X1 U6205 ( .A0(cas_7_data[24]), .A1(n6487), .B0(n4662), .B1(BA_RA[10]), 
        .Y(n2907) );
  AO22X1 U6206 ( .A0(cas_7_data[23]), .A1(n5230), .B0(n4662), .B1(BA_RA[9]), 
        .Y(n2908) );
  AO22X1 U6207 ( .A0(cas_7_data[18]), .A1(n6487), .B0(n4662), .B1(BA_RA[4]), 
        .Y(n2913) );
  AO22X1 U6208 ( .A0(cas_7_data[20]), .A1(n5230), .B0(n4662), .B1(BA_RA[6]), 
        .Y(n2911) );
  AO22X1 U6209 ( .A0(cas_7_data[15]), .A1(n6487), .B0(n4662), .B1(BA_RA[1]), 
        .Y(n2916) );
  AO22X1 U6210 ( .A0(cas_7_data[27]), .A1(n6487), .B0(n4662), .B1(BA_BA[1]), 
        .Y(n2904) );
  INVX1 U6211 ( .A(n5141), .Y(n5102) );
  NAND4BX1 U6212 ( .AN(n5142), .B(n5143), .C(n5144), .D(n5145), .Y(n5141) );
  XOR2X1 U6213 ( .A(BA_RA[4]), .B(B3_LAST_RA[4]), .Y(n5142) );
  XOR2X1 U6214 ( .A(n4738), .B(B3_LAST_RA[5]), .Y(n5143) );
  AO22X1 U6215 ( .A0(cas_7_data[5]), .A1(n6488), .B0(BA_TT[3]), .B1(n4662), 
        .Y(n2926) );
  OAI222X1 U6216 ( .A0(n5294), .A1(n5219), .B0(n6485), .B1(n5220), .C0(
        cas_cnt_b1_pos_0_), .C1(n5221), .Y(n2941) );
  OAI222X1 U6217 ( .A0(n5429), .A1(n5210), .B0(n6485), .B1(n5211), .C0(
        cas_cnt_b2_pos_0_), .C1(n5212), .Y(n2946) );
  OAI222X1 U6218 ( .A0(n5292), .A1(n5202), .B0(n6485), .B1(n5203), .C0(
        cas_cnt_b3_pos_0_), .C1(n5204), .Y(n2951) );
  OAI222X1 U6219 ( .A0(n5430), .A1(n5210), .B0(n6486), .B1(n5211), .C0(n5531), 
        .C1(n5212), .Y(n2945) );
  AO21X1 U6220 ( .A0(cas_cnt1375_1_), .A1(n5499), .B0(n5252), .Y(n429_1_) );
  AO22X1 U6221 ( .A0(cas_cnt_1_), .A1(n5244), .B0(cas_cnt1419_1_), .B1(n5245), 
        .Y(n5252) );
  AO22X1 U6222 ( .A0(cas_7_data[2]), .A1(n6487), .B0(BA_TT[0]), .B1(n4662), 
        .Y(n2929) );
  AO22X1 U6223 ( .A0(cas_7_data[4]), .A1(n6488), .B0(BA_TT[2]), .B1(n4662), 
        .Y(n2927) );
  AO22X1 U6224 ( .A0(cas_7_data[31]), .A1(n6488), .B0(BA_ID[3]), .B1(n4662), 
        .Y(n2900) );
  AO22X1 U6225 ( .A0(cas_7_data[29]), .A1(n5230), .B0(BA_ID[1]), .B1(n4662), 
        .Y(n2902) );
  AO22X1 U6226 ( .A0(cas_7_data[12]), .A1(n6487), .B0(BA_CA[6]), .B1(n4662), 
        .Y(n2919) );
  AO22X1 U6227 ( .A0(cas_7_data[8]), .A1(n6487), .B0(BA_CA[2]), .B1(n4662), 
        .Y(n2923) );
  AO22X1 U6228 ( .A0(cas_7_data[1]), .A1(n6488), .B0(BA_RW), .B1(n4662), .Y(
        n2930) );
  AO22X1 U6229 ( .A0(cas_7_data[3]), .A1(n6487), .B0(BA_TT[1]), .B1(n4662), 
        .Y(n2928) );
  AO22X1 U6230 ( .A0(cas_7_data[0]), .A1(n6487), .B0(BA_PM), .B1(n4662), .Y(
        n2931) );
  AO22X1 U6231 ( .A0(cas_7_data[30]), .A1(n6487), .B0(BA_ID[2]), .B1(n4662), 
        .Y(n2901) );
  AO22X1 U6232 ( .A0(cas_7_data[28]), .A1(n6488), .B0(BA_ID[0]), .B1(n4662), 
        .Y(n2903) );
  AO22X1 U6233 ( .A0(cas_7_data[13]), .A1(n6488), .B0(BA_CA[7]), .B1(n4662), 
        .Y(n2918) );
  AO22X1 U6234 ( .A0(cas_7_data[11]), .A1(n6488), .B0(BA_CA[5]), .B1(n4662), 
        .Y(n2920) );
  AO22X1 U6235 ( .A0(cas_7_data[10]), .A1(n6488), .B0(BA_CA[4]), .B1(n4662), 
        .Y(n2921) );
  AO22X1 U6236 ( .A0(cas_7_data[9]), .A1(n6487), .B0(BA_CA[3]), .B1(n4662), 
        .Y(n2922) );
  AO22X1 U6237 ( .A0(cas_7_data[7]), .A1(n6488), .B0(BA_CA[1]), .B1(n4662), 
        .Y(n2924) );
  AO22X1 U6238 ( .A0(cas_7_data[6]), .A1(n6487), .B0(BA_CA[0]), .B1(n4662), 
        .Y(n2925) );
  NAND2X1 U6239 ( .A(n6408), .B(n5303), .Y(n2936) );
  MXI2X1 U6240 ( .S0(cas_cnt_b0_pos_0_), .B(n6410), .A(n5504), .Y(n6408) );
  NOR2BX1 U6241 ( .AN(n5521), .B(n5522), .Y(n5520) );
  XNOR2X1 U6242 ( .A(BA_RA[7]), .B(B2_LAST_RA[7]), .Y(n5521) );
  XNOR2X1 U6243 ( .A(n4747), .B(B2_LAST_RA[8]), .Y(n5522) );
  NOR2BX1 U6244 ( .AN(n5524), .B(n5525), .Y(n5523) );
  XNOR2X1 U6245 ( .A(BA_RA[7]), .B(B3_LAST_RA[7]), .Y(n5524) );
  XNOR2X1 U6246 ( .A(n4747), .B(B3_LAST_RA[8]), .Y(n5525) );
  XOR2X1 U6247 ( .A(n4729), .B(B0_LAST_RA[2]), .Y(n5113) );
  XOR2X1 U6248 ( .A(n4729), .B(B1_LAST_RA[2]), .Y(n5128) );
  XOR2X1 U6249 ( .A(n4726), .B(B0_LAST_RA[1]), .Y(n5112) );
  XOR2X1 U6250 ( .A(n4726), .B(B1_LAST_RA[1]), .Y(n5127) );
  XOR2X1 U6251 ( .A(BA_RA[3]), .B(B0_LAST_RA[3]), .Y(n5111) );
  XOR2X1 U6252 ( .A(BA_RA[3]), .B(B1_LAST_RA[3]), .Y(n5126) );
  XNOR2X1 U1_A_14 ( .A(cas_cnt_1_), .B(cas_cnt_0_), .Y(cas_cnt1375_1_) );
  XNOR2X1 U1_A_34 ( .A(cas_cnt_3_), .B(carry0), .Y(cas_cnt1375_3_) );
  XNOR2X1 U1_A_24 ( .A(cas_cnt_2_), .B(carry1), .Y(cas_cnt1375_2_) );
  OR2X1 U1_B_14 ( .A(cas_cnt_1_), .B(cas_cnt_0_), .Y(carry1) );
  OR2X1 U1_B_24 ( .A(cas_cnt_2_), .B(carry1), .Y(carry0) );
  XNOR2X1 U1_A_1 ( .A(cas_cnt_b0_pos_1_), .B(cas_cnt_b0_pos_0_), .Y(
        cas_cnt_b0_pos1445_1_) );
  XNOR2X1 U1_A_2 ( .A(cas_cnt_b0_pos_2_), .B(carry_2_), .Y(
        cas_cnt_b0_pos1445_2_) );
  XNOR2X1 U1_A_21 ( .A(cas_cnt_b1_pos_2_), .B(carry9), .Y(
        cas_cnt_b1_pos1456_2_) );
  XNOR2X1 U1_A_22 ( .A(cas_cnt_b2_pos_2_), .B(carry7), .Y(
        cas_cnt_b2_pos1467_2_) );
  XNOR2X1 U1_A_23 ( .A(cas_cnt_b3_pos_2_), .B(carry5), .Y(
        cas_cnt_b3_pos1478_2_) );
  XNOR2X1 U1_A_3 ( .A(cas_cnt_b0_pos_3_), .B(carry_3_), .Y(
        cas_cnt_b0_pos1445_3_) );
  XNOR2X1 U1_A_31 ( .A(cas_cnt_b1_pos_3_), .B(carry8), .Y(
        cas_cnt_b1_pos1456_3_) );
  XNOR2X1 U1_A_32 ( .A(cas_cnt_b2_pos_3_), .B(carry6), .Y(
        cas_cnt_b2_pos1467_3_) );
  XNOR2X1 U1_A_33 ( .A(cas_cnt_b3_pos_3_), .B(carry4), .Y(
        cas_cnt_b3_pos1478_3_) );
  XOR2X1 U6253 ( .A(cas_cnt_b0_pos_4_), .B(n5526), .Y(cas_cnt_b0_pos1445_4_)
         );
  NOR2X1 U6254 ( .A(cas_cnt_b0_pos_3_), .B(carry_3_), .Y(n5526) );
  XOR2X1 U6255 ( .A(cas_cnt_b1_pos_4_), .B(n5527), .Y(cas_cnt_b1_pos1456_4_)
         );
  NOR2X1 U6256 ( .A(cas_cnt_b1_pos_3_), .B(carry8), .Y(n5527) );
  XOR2X1 U6257 ( .A(cas_cnt_b2_pos_4_), .B(n5528), .Y(cas_cnt_b2_pos1467_4_)
         );
  NOR2X1 U6258 ( .A(cas_cnt_b2_pos_3_), .B(carry6), .Y(n5528) );
  XOR2X1 U6259 ( .A(cas_cnt_b3_pos_4_), .B(n5529), .Y(cas_cnt_b3_pos1478_4_)
         );
  NOR2X1 U6260 ( .A(cas_cnt_b3_pos_3_), .B(carry4), .Y(n5529) );
  XOR2X1 U6261 ( .A(cas_cnt_b3_pos_1_), .B(cas_cnt_b3_pos_0_), .Y(n5530) );
  NAND2X1 U6262 ( .A(cas_cnt_b3_pos_3_), .B(cas_cnt_b3_pos_4_), .Y(n6379) );
  XOR2X1 U6263 ( .A(cas_cnt_b2_pos_1_), .B(cas_cnt_b2_pos_0_), .Y(n5531) );
  OR2X1 U1_B_1 ( .A(cas_cnt_b0_pos_1_), .B(cas_cnt_b0_pos_0_), .Y(carry_2_) );
  OR2X1 U6264 ( .A(cas_cnt_b2_pos_4_), .B(cas_cnt_b2_pos_3_), .Y(n6250) );
  OR2X1 U1_B_12 ( .A(cas_cnt_b2_pos_1_), .B(cas_cnt_b2_pos_0_), .Y(carry7) );
  OR2X1 U1_B_23 ( .A(cas_cnt_b3_pos_2_), .B(carry5), .Y(carry4) );
  OR2X1 U1_B_2 ( .A(cas_cnt_b0_pos_2_), .B(carry_2_), .Y(carry_3_) );
  OR2X1 U1_B_22 ( .A(cas_cnt_b2_pos_2_), .B(carry7), .Y(carry6) );
  OR2X1 U1_B_21 ( .A(cas_cnt_b1_pos_2_), .B(carry9), .Y(carry8) );
  OR2X1 U1_B_11 ( .A(cas_cnt_b1_pos_1_), .B(cas_cnt_b1_pos_0_), .Y(carry9) );
  OR2X1 U1_B_13 ( .A(cas_cnt_b3_pos_1_), .B(cas_cnt_b3_pos_0_), .Y(carry5) );
  INVX1 U6265 ( .A(B2_LAST_RA[0]), .Y(n5093) );
  INVX1 U6266 ( .A(B3_LAST_RA[0]), .Y(n5098) );
  XOR2X1 U6267 ( .A(cas_cnt_b1_pos_1_), .B(cas_cnt_b1_pos_0_), .Y(n5532) );
  DFFRX1 CAS_0_RA_reg_7_ ( .D(n2958), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_RA[7])
         );
  DFFRX1 CAS_0_RA_reg_4_ ( .D(n2961), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_RA[4])
         );
  DFFRX1 CAS_0_RA_reg_1_ ( .D(n2964), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_RA[1])
         );
  DFFRX1 CAS_0_RA_reg_0_ ( .D(n2965), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_RA[0])
         );
  DFFRX1 CAS_0_RA_reg_11_ ( .D(n2954), .CK(ACLK), .RN(ARESETB), .Q(
        CAS_0_RA[11]), .QN(n2885) );
  DFFRX1 CAS_0_RA_reg_10_ ( .D(n2955), .CK(ACLK), .RN(ARESETB), .Q(
        CAS_0_RA[10]), .QN(n2884) );
  DFFRX1 CAS_0_RA_reg_9_ ( .D(n2956), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_RA[9]), 
        .QN(n2894) );
  DFFRX1 CAS_0_RA_reg_8_ ( .D(n2957), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_RA[8]), 
        .QN(n2893) );
  DFFRX1 CAS_0_RA_reg_6_ ( .D(n2959), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_RA[6]), 
        .QN(n2891) );
  DFFRX1 CAS_0_RA_reg_5_ ( .D(n2960), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_RA[5]), 
        .QN(n2890) );
  DFFRX1 CAS_0_RA_reg_3_ ( .D(n2962), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_RA[3]), 
        .QN(n2888) );
  DFFRX1 CAS_0_RA_reg_2_ ( .D(n2963), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_RA[2]), 
        .QN(n2887) );
  DFFRX1 cas_cnt_reg_0_ ( .D(n429_0_), .CK(ACLK), .RN(ARESETB), .Q(cas_cnt_0_)
         );
  DFFRX1 cas_cnt_reg_3_ ( .D(n429_3_), .CK(ACLK), .RN(ARESETB), .Q(cas_cnt_3_)
         );
  DFFRX1 cas_cnt_reg_2_ ( .D(n429_2_), .CK(ACLK), .RN(ARESETB), .Q(cas_cnt_2_)
         );
  DFFRX1 cas_cnt_reg_1_ ( .D(n429_1_), .CK(ACLK), .RN(ARESETB), .Q(cas_cnt_1_)
         );
  DFFRX1 cas_cnt_reg_4_ ( .D(n429_4_), .CK(ACLK), .RN(ARESETB), .Q(cas_cnt_4_), 
        .QN(net3032) );
  DFFSX1 cas_cnt_b0_pos_reg_3_ ( .D(n2933), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b0_pos_3_), .QN(n5296) );
  DFFSX1 cas_cnt_b0_pos_reg_1_ ( .D(n2935), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b0_pos_1_), .QN(n5431) );
  DFFSX1 cas_cnt_b2_pos_reg_1_ ( .D(n2945), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b2_pos_1_), .QN(n5430) );
  DFFSX1 cas_cnt_b1_pos_reg_4_ ( .D(n2937), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b1_pos_4_), .QN(n5305) );
  DFFSX1 cas_cnt_b2_pos_reg_4_ ( .D(n2942), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b2_pos_4_) );
  DFFSX1 cas_cnt_b0_pos_reg_4_ ( .D(n2932), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b0_pos_4_), .QN(n5306) );
  DFFSX1 cas_cnt_b3_pos_reg_2_ ( .D(n2949), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b3_pos_2_), .QN(n5307) );
  DFFSX1 cas_cnt_b3_pos_reg_3_ ( .D(n2948), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b3_pos_3_) );
  DFFSX1 cas_cnt_b0_pos_reg_2_ ( .D(n2934), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b0_pos_2_) );
  DFFSX1 cas_cnt_b2_pos_reg_2_ ( .D(n2944), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b2_pos_2_) );
  DFFSX1 cas_cnt_b1_pos_reg_2_ ( .D(n2939), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b1_pos_2_) );
  DFFSX1 cas_cnt_b3_pos_reg_4_ ( .D(n2947), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b3_pos_4_) );
  DFFSX1 cas_cnt_b1_pos_reg_0_ ( .D(n2941), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b1_pos_0_), .QN(n5294) );
  DFFSX1 cas_cnt_b3_pos_reg_0_ ( .D(n2951), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b3_pos_0_), .QN(n5292) );
  DFFSX1 cas_cnt_b1_pos_reg_1_ ( .D(n2940), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b1_pos_1_), .QN(n5304) );
  DFFSX1 cas_cnt_b3_pos_reg_1_ ( .D(n2950), .CK(ACLK), .SN(ARESETB), .Q(
        cas_cnt_b3_pos_1_), .QN(n5293) );
  DFFRX1 cas_1_final_reg ( .D(n3018), .CK(ACLK), .RN(ARESETB), .Q(cas_1_final), 
        .QN(n5482) );
  DFFRX1 cas_5_final_reg ( .D(n3154), .CK(ACLK), .RN(ARESETB), .Q(cas_5_final), 
        .QN(n5481) );
  DFFRX1 cas_4_final_reg ( .D(n3120), .CK(ACLK), .RN(ARESETB), .Q(cas_4_final)
         );
  DFFRX1 cas_2_final_reg ( .D(n3052), .CK(ACLK), .RN(ARESETB), .Q(cas_2_final)
         );
  DFFRX1 cas_3_final_reg ( .D(n3086), .CK(ACLK), .RN(ARESETB), .Q(cas_3_final)
         );
  DFFRX1 cas_4_data_reg_30_ ( .D(n3089), .CK(ACLK), .RN(ARESETB), .QN(n5302)
         );
  DFFRX1 cas_4_data_reg_25_ ( .D(n3094), .CK(ACLK), .RN(ARESETB), .QN(n5298)
         );
  DFFRX1 cas_4_data_reg_21_ ( .D(n3098), .CK(ACLK), .RN(ARESETB), .QN(n5297)
         );
  DFFRX1 cas_4_data_reg_16_ ( .D(n3103), .CK(ACLK), .RN(ARESETB), .QN(n5299)
         );
  DFFRX1 cas_4_data_reg_11_ ( .D(n3108), .CK(ACLK), .RN(ARESETB), .QN(n5300)
         );
  DFFRX1 cas_4_data_reg_2_ ( .D(n3117), .CK(ACLK), .RN(ARESETB), .QN(n5301) );
  DFFRX1 cas_5_data_reg_30_ ( .D(n3123), .CK(ACLK), .RN(ARESETB), .QN(n5427)
         );
  DFFRX1 cas_5_data_reg_25_ ( .D(n3128), .CK(ACLK), .RN(ARESETB), .QN(n5309)
         );
  DFFRX1 cas_5_data_reg_21_ ( .D(n3132), .CK(ACLK), .RN(ARESETB), .QN(n5308)
         );
  DFFRX1 cas_5_data_reg_16_ ( .D(n3137), .CK(ACLK), .RN(ARESETB), .QN(n5310)
         );
  DFFRX1 cas_5_data_reg_11_ ( .D(n3142), .CK(ACLK), .RN(ARESETB), .QN(n5311)
         );
  DFFRX1 cas_5_data_reg_2_ ( .D(n3151), .CK(ACLK), .RN(ARESETB), .QN(n5312) );
  DFFRX1 CAS_FULL_reg ( .D(CAS_FULL922), .CK(ACLK), .RN(ARESETB), .Q(CAS_FULL)
         );
  DFFRX1 cas_7_final_reg ( .D(n3190), .CK(ACLK), .RN(ARESETB), .Q(cas_7_final)
         );
  DFFRX1 cas_5_data_reg_31_ ( .D(n3122), .CK(ACLK), .RN(ARESETB), .Q(
        cas_5_data_31_), .QN(n5473) );
  DFFRX1 cas_5_data_reg_29_ ( .D(n3124), .CK(ACLK), .RN(ARESETB), .Q(
        cas_5_data_29_), .QN(n5474) );
  DFFRX1 cas_5_data_reg_26_ ( .D(n3127), .CK(ACLK), .RN(ARESETB), .Q(
        cas_5_data_26_), .QN(n5469) );
  DFFRX1 cas_5_data_reg_23_ ( .D(n3130), .CK(ACLK), .RN(ARESETB), .Q(
        cas_5_data_23_), .QN(n5477) );
  DFFRX1 cas_5_data_reg_20_ ( .D(n3133), .CK(ACLK), .RN(ARESETB), .Q(
        cas_5_data_20_), .QN(n5470) );
  DFFRX1 cas_5_data_reg_18_ ( .D(n3135), .CK(ACLK), .RN(ARESETB), .Q(
        cas_5_data_18_), .QN(n5478) );
  DFFRX1 cas_5_data_reg_15_ ( .D(n3138), .CK(ACLK), .RN(ARESETB), .Q(
        cas_5_data_15_), .QN(n5471) );
  DFFRX1 cas_5_data_reg_12_ ( .D(n3141), .CK(ACLK), .RN(ARESETB), .Q(
        cas_5_data_12_), .QN(n5475) );
  DFFRX1 cas_5_data_reg_8_ ( .D(n3145), .CK(ACLK), .RN(ARESETB), .Q(
        cas_5_data_8_), .QN(n5476) );
  DFFRX1 cas_5_data_reg_5_ ( .D(n3148), .CK(ACLK), .RN(ARESETB), .Q(
        cas_5_data_5_), .QN(n5472) );
  DFFRX1 cas_5_data_reg_0_ ( .D(n3153), .CK(ACLK), .RN(ARESETB), .Q(
        cas_5_data_0_), .QN(n5479) );
  DFFRX1 cas_1_data_reg_30_ ( .D(n2987), .CK(ACLK), .RN(ARESETB), .Q(
        cas_1_data_30_), .QN(n5454) );
  DFFRX1 cas_1_data_reg_26_ ( .D(n2991), .CK(ACLK), .RN(ARESETB), .Q(
        cas_1_data_26_), .QN(n5463) );
  DFFRX1 cas_1_data_reg_21_ ( .D(n2996), .CK(ACLK), .RN(ARESETB), .Q(
        cas_1_data_21_), .QN(n5455) );
  DFFRX1 cas_1_data_reg_18_ ( .D(n2999), .CK(ACLK), .RN(ARESETB), .Q(
        cas_1_data_18_), .QN(n5464) );
  DFFRX1 cas_1_data_reg_15_ ( .D(n3002), .CK(ACLK), .RN(ARESETB), .Q(
        cas_1_data_15_), .QN(n5465) );
  DFFRX1 cas_1_data_reg_14_ ( .D(n3003), .CK(ACLK), .RN(ARESETB), .Q(
        cas_1_data_14_), .QN(n5456) );
  DFFRX1 cas_1_data_reg_13_ ( .D(n3004), .CK(ACLK), .RN(ARESETB), .Q(
        cas_1_data_13_), .QN(n5457) );
  DFFRX1 cas_1_data_reg_10_ ( .D(n3007), .CK(ACLK), .RN(ARESETB), .Q(
        cas_1_data_10_), .QN(n5458) );
  DFFRX1 cas_1_data_reg_7_ ( .D(n3010), .CK(ACLK), .RN(ARESETB), .Q(
        cas_1_data_7_), .QN(n5459) );
  DFFRX1 cas_1_data_reg_4_ ( .D(n3013), .CK(ACLK), .RN(ARESETB), .Q(
        cas_1_data_4_), .QN(n5460) );
  DFFRX1 cas_1_data_reg_1_ ( .D(n3016), .CK(ACLK), .RN(ARESETB), .Q(
        cas_1_data_1_), .QN(n5461) );
  DFFRX1 cas_1_newrow_reg ( .D(n3019), .CK(ACLK), .RN(ARESETB), .Q(
        cas_1_newrow), .QN(n5466) );
  DFFRX1 cas_2_newrow_reg ( .D(n3053), .CK(ACLK), .RN(ARESETB), .Q(
        cas_2_newrow), .QN(n5468) );
  DFFRX1 cas_3_newrow_reg ( .D(n3087), .CK(ACLK), .RN(ARESETB), .Q(
        cas_3_newrow), .QN(n5467) );
  DFFRX1 cas_4_newrow_reg ( .D(n3121), .CK(ACLK), .RN(ARESETB), .Q(
        cas_4_newrow), .QN(n5462) );
  DFFRX1 cas_6_newrow_reg ( .D(n3189), .CK(ACLK), .RN(ARESETB), .Q(
        cas_6_newrow), .QN(n5480) );
  DFFRX1 cas_6_final_reg ( .D(n3188), .CK(ACLK), .RN(ARESETB), .Q(cas_6_final)
         );
  DFFRX1 cas_2_data_reg_31_ ( .D(n3020), .CK(ACLK), .RN(ARESETB), .Q(
        cas_2_data_31_), .QN(n5451) );
  DFFRX1 cas_2_data_reg_29_ ( .D(n3022), .CK(ACLK), .RN(ARESETB), .Q(
        cas_2_data_29_), .QN(n5448) );
  DFFRX1 cas_2_data_reg_26_ ( .D(n3025), .CK(ACLK), .RN(ARESETB), .Q(
        cas_2_data_26_), .QN(n5443) );
  DFFRX1 cas_2_data_reg_23_ ( .D(n3028), .CK(ACLK), .RN(ARESETB), .Q(
        cas_2_data_23_), .QN(n5449) );
  DFFRX1 cas_2_data_reg_20_ ( .D(n3031), .CK(ACLK), .RN(ARESETB), .Q(
        cas_2_data_20_), .QN(n5444) );
  DFFRX1 cas_2_data_reg_18_ ( .D(n3033), .CK(ACLK), .RN(ARESETB), .Q(
        cas_2_data_18_), .QN(n5445) );
  DFFRX1 cas_2_data_reg_15_ ( .D(n3036), .CK(ACLK), .RN(ARESETB), .Q(
        cas_2_data_15_), .QN(n5450) );
  DFFRX1 cas_2_data_reg_12_ ( .D(n3039), .CK(ACLK), .RN(ARESETB), .Q(
        cas_2_data_12_), .QN(n5446) );
  DFFRX1 cas_2_data_reg_8_ ( .D(n3043), .CK(ACLK), .RN(ARESETB), .Q(
        cas_2_data_8_), .QN(n5452) );
  DFFRX1 cas_2_data_reg_5_ ( .D(n3046), .CK(ACLK), .RN(ARESETB), .Q(
        cas_2_data_5_), .QN(n5447) );
  DFFRX1 cas_2_data_reg_0_ ( .D(n3051), .CK(ACLK), .RN(ARESETB), .Q(
        cas_2_data_0_), .QN(n5453) );
  DFFRX1 cas_3_data_reg_31_ ( .D(n3054), .CK(ACLK), .RN(ARESETB), .Q(
        cas_3_data_31_), .QN(n5432) );
  DFFRX1 cas_3_data_reg_29_ ( .D(n3056), .CK(ACLK), .RN(ARESETB), .Q(
        cas_3_data_29_), .QN(n5433) );
  DFFRX1 cas_3_data_reg_26_ ( .D(n3059), .CK(ACLK), .RN(ARESETB), .Q(
        cas_3_data_26_), .QN(n5434) );
  DFFRX1 cas_3_data_reg_23_ ( .D(n3062), .CK(ACLK), .RN(ARESETB), .Q(
        cas_3_data_23_), .QN(n5435) );
  DFFRX1 cas_3_data_reg_20_ ( .D(n3065), .CK(ACLK), .RN(ARESETB), .Q(
        cas_3_data_20_), .QN(n5436) );
  DFFRX1 cas_3_data_reg_18_ ( .D(n3067), .CK(ACLK), .RN(ARESETB), .Q(
        cas_3_data_18_), .QN(n5437) );
  DFFRX1 cas_3_data_reg_15_ ( .D(n3070), .CK(ACLK), .RN(ARESETB), .Q(
        cas_3_data_15_), .QN(n5438) );
  DFFRX1 cas_3_data_reg_12_ ( .D(n3073), .CK(ACLK), .RN(ARESETB), .Q(
        cas_3_data_12_), .QN(n5439) );
  DFFRX1 cas_3_data_reg_8_ ( .D(n3077), .CK(ACLK), .RN(ARESETB), .Q(
        cas_3_data_8_), .QN(n5440) );
  DFFRX1 cas_3_data_reg_5_ ( .D(n3080), .CK(ACLK), .RN(ARESETB), .Q(
        cas_3_data_5_), .QN(n5441) );
  DFFRX1 cas_3_data_reg_0_ ( .D(n3085), .CK(ACLK), .RN(ARESETB), .Q(
        cas_3_data_0_), .QN(n5442) );
  DFFRX1 cas_1_data_reg_31_ ( .D(n2986), .CK(ACLK), .RN(ARESETB), .QN(n5387)
         );
  DFFRX1 cas_1_data_reg_29_ ( .D(n2988), .CK(ACLK), .RN(ARESETB), .QN(n5388)
         );
  DFFRX1 cas_1_data_reg_28_ ( .D(n2989), .CK(ACLK), .RN(ARESETB), .QN(n5389)
         );
  DFFRX1 cas_1_data_reg_27_ ( .D(n2990), .CK(ACLK), .RN(ARESETB), .QN(n5370)
         );
  DFFRX1 cas_1_data_reg_25_ ( .D(n2992), .CK(ACLK), .RN(ARESETB), .QN(n5371)
         );
  DFFRX1 cas_1_data_reg_24_ ( .D(n2993), .CK(ACLK), .RN(ARESETB), .QN(n5372)
         );
  DFFRX1 cas_1_data_reg_23_ ( .D(n2994), .CK(ACLK), .RN(ARESETB), .QN(n5373)
         );
  DFFRX1 cas_1_data_reg_22_ ( .D(n2995), .CK(ACLK), .RN(ARESETB), .QN(n5374)
         );
  DFFRX1 cas_1_data_reg_20_ ( .D(n2997), .CK(ACLK), .RN(ARESETB), .QN(n5375)
         );
  DFFRX1 cas_1_data_reg_19_ ( .D(n2998), .CK(ACLK), .RN(ARESETB), .QN(n5376)
         );
  DFFRX1 cas_1_data_reg_17_ ( .D(n3000), .CK(ACLK), .RN(ARESETB), .QN(n5377)
         );
  DFFRX1 cas_1_data_reg_16_ ( .D(n3001), .CK(ACLK), .RN(ARESETB), .QN(n5378)
         );
  DFFRX1 cas_1_data_reg_12_ ( .D(n3005), .CK(ACLK), .RN(ARESETB), .QN(n5379)
         );
  DFFRX1 cas_1_data_reg_11_ ( .D(n3006), .CK(ACLK), .RN(ARESETB), .QN(n5380)
         );
  DFFRX1 cas_1_data_reg_9_ ( .D(n3008), .CK(ACLK), .RN(ARESETB), .QN(n5381) );
  DFFRX1 cas_1_data_reg_8_ ( .D(n3009), .CK(ACLK), .RN(ARESETB), .QN(n5382) );
  DFFRX1 cas_1_data_reg_6_ ( .D(n3011), .CK(ACLK), .RN(ARESETB), .QN(n5383) );
  DFFRX1 cas_1_data_reg_5_ ( .D(n3012), .CK(ACLK), .RN(ARESETB), .QN(n5384) );
  DFFRX1 cas_1_data_reg_3_ ( .D(n3014), .CK(ACLK), .RN(ARESETB), .QN(n5385) );
  DFFRX1 cas_1_data_reg_2_ ( .D(n3015), .CK(ACLK), .RN(ARESETB), .QN(n5386) );
  DFFRX1 cas_1_data_reg_0_ ( .D(n3017), .CK(ACLK), .RN(ARESETB), .QN(n5390) );
  DFFRX1 cas_2_data_reg_30_ ( .D(n3021), .CK(ACLK), .RN(ARESETB), .QN(n5334)
         );
  DFFRX1 cas_2_data_reg_28_ ( .D(n3023), .CK(ACLK), .RN(ARESETB), .QN(n5335)
         );
  DFFRX1 cas_2_data_reg_27_ ( .D(n3024), .CK(ACLK), .RN(ARESETB), .QN(n5336)
         );
  DFFRX1 cas_2_data_reg_25_ ( .D(n3026), .CK(ACLK), .RN(ARESETB), .QN(n5337)
         );
  DFFRX1 cas_2_data_reg_24_ ( .D(n3027), .CK(ACLK), .RN(ARESETB), .QN(n5338)
         );
  DFFRX1 cas_2_data_reg_22_ ( .D(n3029), .CK(ACLK), .RN(ARESETB), .QN(n5339)
         );
  DFFRX1 cas_2_data_reg_21_ ( .D(n3030), .CK(ACLK), .RN(ARESETB), .QN(n5340)
         );
  DFFRX1 cas_2_data_reg_19_ ( .D(n3032), .CK(ACLK), .RN(ARESETB), .QN(n5341)
         );
  DFFRX1 cas_2_data_reg_17_ ( .D(n3034), .CK(ACLK), .RN(ARESETB), .QN(n5342)
         );
  DFFRX1 cas_2_data_reg_16_ ( .D(n3035), .CK(ACLK), .RN(ARESETB), .QN(n5343)
         );
  DFFRX1 cas_2_data_reg_14_ ( .D(n3037), .CK(ACLK), .RN(ARESETB), .QN(n5344)
         );
  DFFRX1 cas_2_data_reg_13_ ( .D(n3038), .CK(ACLK), .RN(ARESETB), .QN(n5345)
         );
  DFFRX1 cas_2_data_reg_11_ ( .D(n3040), .CK(ACLK), .RN(ARESETB), .QN(n5346)
         );
  DFFRX1 cas_2_data_reg_10_ ( .D(n3041), .CK(ACLK), .RN(ARESETB), .QN(n5347)
         );
  DFFRX1 cas_2_data_reg_9_ ( .D(n3042), .CK(ACLK), .RN(ARESETB), .QN(n5348) );
  DFFRX1 cas_2_data_reg_7_ ( .D(n3044), .CK(ACLK), .RN(ARESETB), .QN(n5349) );
  DFFRX1 cas_2_data_reg_6_ ( .D(n3045), .CK(ACLK), .RN(ARESETB), .QN(n5350) );
  DFFRX1 cas_2_data_reg_4_ ( .D(n3047), .CK(ACLK), .RN(ARESETB), .QN(n5351) );
  DFFRX1 cas_2_data_reg_3_ ( .D(n3048), .CK(ACLK), .RN(ARESETB), .QN(n5352) );
  DFFRX1 cas_2_data_reg_2_ ( .D(n3049), .CK(ACLK), .RN(ARESETB), .QN(n5353) );
  DFFRX1 cas_2_data_reg_1_ ( .D(n3050), .CK(ACLK), .RN(ARESETB), .QN(n5354) );
  DFFRX1 cas_3_data_reg_30_ ( .D(n3055), .CK(ACLK), .RN(ARESETB), .QN(n5313)
         );
  DFFRX1 cas_3_data_reg_28_ ( .D(n3057), .CK(ACLK), .RN(ARESETB), .QN(n5314)
         );
  DFFRX1 cas_3_data_reg_27_ ( .D(n3058), .CK(ACLK), .RN(ARESETB), .QN(n5315)
         );
  DFFRX1 cas_3_data_reg_25_ ( .D(n3060), .CK(ACLK), .RN(ARESETB), .QN(n5316)
         );
  DFFRX1 cas_3_data_reg_24_ ( .D(n3061), .CK(ACLK), .RN(ARESETB), .QN(n5317)
         );
  DFFRX1 cas_3_data_reg_22_ ( .D(n3063), .CK(ACLK), .RN(ARESETB), .QN(n5318)
         );
  DFFRX1 cas_3_data_reg_21_ ( .D(n3064), .CK(ACLK), .RN(ARESETB), .QN(n5319)
         );
  DFFRX1 cas_3_data_reg_19_ ( .D(n3066), .CK(ACLK), .RN(ARESETB), .QN(n5320)
         );
  DFFRX1 cas_3_data_reg_17_ ( .D(n3068), .CK(ACLK), .RN(ARESETB), .QN(n5321)
         );
  DFFRX1 cas_3_data_reg_16_ ( .D(n3069), .CK(ACLK), .RN(ARESETB), .QN(n5322)
         );
  DFFRX1 cas_3_data_reg_14_ ( .D(n3071), .CK(ACLK), .RN(ARESETB), .QN(n5323)
         );
  DFFRX1 cas_3_data_reg_13_ ( .D(n3072), .CK(ACLK), .RN(ARESETB), .QN(n5324)
         );
  DFFRX1 cas_3_data_reg_11_ ( .D(n3074), .CK(ACLK), .RN(ARESETB), .QN(n5325)
         );
  DFFRX1 cas_3_data_reg_10_ ( .D(n3075), .CK(ACLK), .RN(ARESETB), .QN(n5326)
         );
  DFFRX1 cas_3_data_reg_9_ ( .D(n3076), .CK(ACLK), .RN(ARESETB), .QN(n5327) );
  DFFRX1 cas_3_data_reg_7_ ( .D(n3078), .CK(ACLK), .RN(ARESETB), .QN(n5328) );
  DFFRX1 cas_3_data_reg_6_ ( .D(n3079), .CK(ACLK), .RN(ARESETB), .QN(n5329) );
  DFFRX1 cas_3_data_reg_4_ ( .D(n3081), .CK(ACLK), .RN(ARESETB), .QN(n5330) );
  DFFRX1 cas_3_data_reg_3_ ( .D(n3082), .CK(ACLK), .RN(ARESETB), .QN(n5331) );
  DFFRX1 cas_3_data_reg_2_ ( .D(n3083), .CK(ACLK), .RN(ARESETB), .QN(n5332) );
  DFFRX1 cas_3_data_reg_1_ ( .D(n3084), .CK(ACLK), .RN(ARESETB), .QN(n5333) );
  DFFRX1 cas_4_data_reg_28_ ( .D(n3091), .CK(ACLK), .RN(ARESETB), .QN(n5355)
         );
  DFFRX1 cas_4_data_reg_27_ ( .D(n3092), .CK(ACLK), .RN(ARESETB), .QN(n5356)
         );
  DFFRX1 cas_4_data_reg_24_ ( .D(n3095), .CK(ACLK), .RN(ARESETB), .QN(n5357)
         );
  DFFRX1 cas_4_data_reg_22_ ( .D(n3097), .CK(ACLK), .RN(ARESETB), .QN(n5358)
         );
  DFFRX1 cas_4_data_reg_19_ ( .D(n3100), .CK(ACLK), .RN(ARESETB), .QN(n5359)
         );
  DFFRX1 cas_4_data_reg_17_ ( .D(n3102), .CK(ACLK), .RN(ARESETB), .QN(n5360)
         );
  DFFRX1 cas_4_data_reg_14_ ( .D(n3105), .CK(ACLK), .RN(ARESETB), .QN(n5361)
         );
  DFFRX1 cas_4_data_reg_13_ ( .D(n3106), .CK(ACLK), .RN(ARESETB), .QN(n5362)
         );
  DFFRX1 cas_4_data_reg_10_ ( .D(n3109), .CK(ACLK), .RN(ARESETB), .QN(n5363)
         );
  DFFRX1 cas_4_data_reg_9_ ( .D(n3110), .CK(ACLK), .RN(ARESETB), .QN(n5364) );
  DFFRX1 cas_4_data_reg_7_ ( .D(n3112), .CK(ACLK), .RN(ARESETB), .QN(n5365) );
  DFFRX1 cas_4_data_reg_6_ ( .D(n3113), .CK(ACLK), .RN(ARESETB), .QN(n5366) );
  DFFRX1 cas_4_data_reg_4_ ( .D(n3115), .CK(ACLK), .RN(ARESETB), .QN(n5367) );
  DFFRX1 cas_4_data_reg_3_ ( .D(n3116), .CK(ACLK), .RN(ARESETB), .QN(n5368) );
  DFFRX1 cas_4_data_reg_1_ ( .D(n3118), .CK(ACLK), .RN(ARESETB), .QN(n5369) );
  DFFRX1 cas_5_data_reg_28_ ( .D(n3125), .CK(ACLK), .RN(ARESETB), .QN(n5412)
         );
  DFFRX1 cas_5_data_reg_27_ ( .D(n3126), .CK(ACLK), .RN(ARESETB), .QN(n5413)
         );
  DFFRX1 cas_5_data_reg_24_ ( .D(n3129), .CK(ACLK), .RN(ARESETB), .QN(n5414)
         );
  DFFRX1 cas_5_data_reg_22_ ( .D(n3131), .CK(ACLK), .RN(ARESETB), .QN(n5415)
         );
  DFFRX1 cas_5_data_reg_19_ ( .D(n3134), .CK(ACLK), .RN(ARESETB), .QN(n5416)
         );
  DFFRX1 cas_5_data_reg_17_ ( .D(n3136), .CK(ACLK), .RN(ARESETB), .QN(n5417)
         );
  DFFRX1 cas_5_data_reg_14_ ( .D(n3139), .CK(ACLK), .RN(ARESETB), .QN(n5418)
         );
  DFFRX1 cas_5_data_reg_13_ ( .D(n3140), .CK(ACLK), .RN(ARESETB), .QN(n5419)
         );
  DFFRX1 cas_5_data_reg_10_ ( .D(n3143), .CK(ACLK), .RN(ARESETB), .QN(n5420)
         );
  DFFRX1 cas_5_data_reg_9_ ( .D(n3144), .CK(ACLK), .RN(ARESETB), .QN(n5421) );
  DFFRX1 cas_5_data_reg_7_ ( .D(n3146), .CK(ACLK), .RN(ARESETB), .QN(n5422) );
  DFFRX1 cas_5_data_reg_6_ ( .D(n3147), .CK(ACLK), .RN(ARESETB), .QN(n5423) );
  DFFRX1 cas_5_data_reg_4_ ( .D(n3149), .CK(ACLK), .RN(ARESETB), .QN(n5424) );
  DFFRX1 cas_5_data_reg_3_ ( .D(n3150), .CK(ACLK), .RN(ARESETB), .QN(n5425) );
  DFFRX1 cas_5_data_reg_1_ ( .D(n3152), .CK(ACLK), .RN(ARESETB), .QN(n5426) );
  DFFRX1 cas_5_newrow_reg ( .D(n3155), .CK(ACLK), .RN(ARESETB), .QN(n5428) );
  DFFRX1 cas_6_data_reg_30_ ( .D(n3157), .CK(ACLK), .RN(ARESETB), .QN(n5391)
         );
  DFFRX1 cas_6_data_reg_28_ ( .D(n3159), .CK(ACLK), .RN(ARESETB), .QN(n5392)
         );
  DFFRX1 cas_6_data_reg_27_ ( .D(n3160), .CK(ACLK), .RN(ARESETB), .QN(n5393)
         );
  DFFRX1 cas_6_data_reg_25_ ( .D(n3162), .CK(ACLK), .RN(ARESETB), .QN(n5394)
         );
  DFFRX1 cas_6_data_reg_24_ ( .D(n3163), .CK(ACLK), .RN(ARESETB), .QN(n5395)
         );
  DFFRX1 cas_6_data_reg_22_ ( .D(n3165), .CK(ACLK), .RN(ARESETB), .QN(n5396)
         );
  DFFRX1 cas_6_data_reg_21_ ( .D(n3166), .CK(ACLK), .RN(ARESETB), .QN(n5397)
         );
  DFFRX1 cas_6_data_reg_19_ ( .D(n3168), .CK(ACLK), .RN(ARESETB), .QN(n5398)
         );
  DFFRX1 cas_6_data_reg_17_ ( .D(n3170), .CK(ACLK), .RN(ARESETB), .QN(n5399)
         );
  DFFRX1 cas_6_data_reg_16_ ( .D(n3171), .CK(ACLK), .RN(ARESETB), .QN(n5400)
         );
  DFFRX1 cas_6_data_reg_14_ ( .D(n3173), .CK(ACLK), .RN(ARESETB), .QN(n5401)
         );
  DFFRX1 cas_6_data_reg_13_ ( .D(n3174), .CK(ACLK), .RN(ARESETB), .QN(n5402)
         );
  DFFRX1 cas_6_data_reg_11_ ( .D(n3176), .CK(ACLK), .RN(ARESETB), .QN(n5403)
         );
  DFFRX1 cas_6_data_reg_10_ ( .D(n3177), .CK(ACLK), .RN(ARESETB), .QN(n5404)
         );
  DFFRX1 cas_6_data_reg_9_ ( .D(n3178), .CK(ACLK), .RN(ARESETB), .QN(n5405) );
  DFFRX1 cas_6_data_reg_7_ ( .D(n3180), .CK(ACLK), .RN(ARESETB), .QN(n5406) );
  DFFRX1 cas_6_data_reg_6_ ( .D(n3181), .CK(ACLK), .RN(ARESETB), .QN(n5407) );
  DFFRX1 cas_6_data_reg_4_ ( .D(n3183), .CK(ACLK), .RN(ARESETB), .QN(n5408) );
  DFFRX1 cas_6_data_reg_3_ ( .D(n3184), .CK(ACLK), .RN(ARESETB), .QN(n5409) );
  DFFRX1 cas_6_data_reg_2_ ( .D(n3185), .CK(ACLK), .RN(ARESETB), .QN(n5410) );
  DFFRX1 cas_6_data_reg_1_ ( .D(n3186), .CK(ACLK), .RN(ARESETB), .QN(n5411) );
  DFFRX1 cas_6_data_reg_31_ ( .D(n3156), .CK(ACLK), .RN(ARESETB), .Q(
        cas_6_data_31_) );
  DFFRX1 cas_6_data_reg_29_ ( .D(n3158), .CK(ACLK), .RN(ARESETB), .Q(
        cas_6_data_29_) );
  DFFRX1 cas_6_data_reg_26_ ( .D(n3161), .CK(ACLK), .RN(ARESETB), .Q(
        cas_6_data_26_) );
  DFFRX1 cas_6_data_reg_23_ ( .D(n3164), .CK(ACLK), .RN(ARESETB), .Q(
        cas_6_data_23_) );
  DFFRX1 cas_6_data_reg_20_ ( .D(n3167), .CK(ACLK), .RN(ARESETB), .Q(
        cas_6_data_20_) );
  DFFRX1 cas_6_data_reg_18_ ( .D(n3169), .CK(ACLK), .RN(ARESETB), .Q(
        cas_6_data_18_) );
  DFFRX1 cas_6_data_reg_15_ ( .D(n3172), .CK(ACLK), .RN(ARESETB), .Q(
        cas_6_data_15_) );
  DFFRX1 cas_6_data_reg_12_ ( .D(n3175), .CK(ACLK), .RN(ARESETB), .Q(
        cas_6_data_12_) );
  DFFRX1 cas_6_data_reg_8_ ( .D(n3179), .CK(ACLK), .RN(ARESETB), .Q(
        cas_6_data_8_) );
  DFFRX1 cas_6_data_reg_5_ ( .D(n3182), .CK(ACLK), .RN(ARESETB), .Q(
        cas_6_data_5_) );
  DFFRX1 cas_6_data_reg_0_ ( .D(n3187), .CK(ACLK), .RN(ARESETB), .Q(
        cas_6_data_0_) );
  DFFRX1 cas_4_data_reg_31_ ( .D(n3088), .CK(ACLK), .RN(ARESETB), .Q(
        cas_4_data_31_) );
  DFFRX1 cas_4_data_reg_29_ ( .D(n3090), .CK(ACLK), .RN(ARESETB), .Q(
        cas_4_data_29_) );
  DFFRX1 cas_4_data_reg_26_ ( .D(n3093), .CK(ACLK), .RN(ARESETB), .Q(
        cas_4_data_26_) );
  DFFRX1 cas_4_data_reg_23_ ( .D(n3096), .CK(ACLK), .RN(ARESETB), .Q(
        cas_4_data_23_) );
  DFFRX1 cas_4_data_reg_20_ ( .D(n3099), .CK(ACLK), .RN(ARESETB), .Q(
        cas_4_data_20_) );
  DFFRX1 cas_4_data_reg_18_ ( .D(n3101), .CK(ACLK), .RN(ARESETB), .Q(
        cas_4_data_18_) );
  DFFRX1 cas_4_data_reg_15_ ( .D(n3104), .CK(ACLK), .RN(ARESETB), .Q(
        cas_4_data_15_) );
  DFFRX1 cas_4_data_reg_12_ ( .D(n3107), .CK(ACLK), .RN(ARESETB), .Q(
        cas_4_data_12_) );
  DFFRX1 cas_4_data_reg_8_ ( .D(n3111), .CK(ACLK), .RN(ARESETB), .Q(
        cas_4_data_8_) );
  DFFRX1 cas_4_data_reg_5_ ( .D(n3114), .CK(ACLK), .RN(ARESETB), .Q(
        cas_4_data_5_) );
  DFFRX1 cas_4_data_reg_0_ ( .D(n3119), .CK(ACLK), .RN(ARESETB), .Q(
        cas_4_data_0_) );
  DFFRX1 CAS_0_CA_reg_7_ ( .D(n2966), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_CA[7])
         );
  DFFRX1 CAS_0_CA_reg_4_ ( .D(n2969), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_CA[4])
         );
  DFFRX1 CAS_0_CA_reg_1_ ( .D(n2972), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_CA[1])
         );
  DFFRX1 cas_7_data_reg_31_ ( .D(n2900), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[31]) );
  DFFRX1 cas_7_data_reg_29_ ( .D(n2902), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[29]) );
  DFFRX1 cas_7_data_reg_26_ ( .D(n2905), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[26]) );
  DFFRX1 cas_7_data_reg_23_ ( .D(n2908), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[23]) );
  DFFRX1 cas_7_data_reg_20_ ( .D(n2911), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[20]) );
  DFFRX1 cas_7_data_reg_18_ ( .D(n2913), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[18]) );
  DFFRX1 cas_7_data_reg_15_ ( .D(n2916), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[15]) );
  DFFRX1 cas_7_data_reg_12_ ( .D(n2919), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[12]) );
  DFFRX1 cas_7_data_reg_8_ ( .D(n2923), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[8]) );
  DFFRX1 cas_7_data_reg_5_ ( .D(n2926), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[5]) );
  DFFRX1 cas_7_data_reg_0_ ( .D(n2931), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[0]) );
  DFFRX1 CAS_0_ID_reg_2_ ( .D(n2979), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_ID[2])
         );
  DFFRX1 cas_7_newrow_reg ( .D(n3191), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_newrow), .QN(n5507) );
  DFFRX1 CAS_0_CA_reg_6_ ( .D(n2967), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_CA[6]), 
        .QN(n2874) );
  DFFRX1 CAS_0_CA_reg_5_ ( .D(n2968), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_CA[5]), 
        .QN(n2873) );
  DFFRX1 CAS_0_CA_reg_3_ ( .D(n2970), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_CA[3]), 
        .QN(n2871) );
  DFFRX1 CAS_0_CA_reg_2_ ( .D(n2971), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_CA[2]), 
        .QN(n2870) );
  DFFRX1 CAS_0_CA_reg_0_ ( .D(n2973), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_CA[0]), 
        .QN(n2868) );
  DFFRX1 CAS_0_ID_reg_3_ ( .D(n2978), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_ID[3]), 
        .QN(n2880) );
  DFFRX1 CAS_0_ID_reg_1_ ( .D(n2980), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_ID[1]), 
        .QN(n2878) );
  DFFRX1 CAS_0_ID_reg_0_ ( .D(n2981), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_ID[0]), 
        .QN(n2877) );
  DFFRX1 cas_7_data_reg_30_ ( .D(n2901), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[30]), .QN(net2885) );
  DFFRX1 cas_7_data_reg_28_ ( .D(n2903), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[28]), .QN(net2889) );
  DFFRX1 cas_7_data_reg_27_ ( .D(n2904), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[27]), .QN(net2891) );
  DFFRX1 cas_7_data_reg_25_ ( .D(n2906), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[25]), .QN(net2895) );
  DFFRX1 cas_7_data_reg_24_ ( .D(n2907), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[24]), .QN(net2897) );
  DFFRX1 cas_7_data_reg_22_ ( .D(n2909), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[22]), .QN(net2901) );
  DFFRX1 cas_7_data_reg_21_ ( .D(n2910), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[21]), .QN(net2903) );
  DFFRX1 cas_7_data_reg_19_ ( .D(n2912), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[19]), .QN(net2907) );
  DFFRX1 cas_7_data_reg_17_ ( .D(n2914), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[17]), .QN(net2911) );
  DFFRX1 cas_7_data_reg_16_ ( .D(n2915), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[16]), .QN(net2913) );
  DFFRX1 cas_7_data_reg_14_ ( .D(n2917), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[14]), .QN(net2917) );
  DFFRX1 cas_7_data_reg_13_ ( .D(n2918), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[13]), .QN(net2919) );
  DFFRX1 cas_7_data_reg_11_ ( .D(n2920), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[11]), .QN(net2923) );
  DFFRX1 cas_7_data_reg_10_ ( .D(n2921), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[10]), .QN(net2925) );
  DFFRX1 cas_7_data_reg_9_ ( .D(n2922), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[9]), .QN(net2927) );
  DFFRX1 cas_7_data_reg_7_ ( .D(n2924), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[7]), .QN(net2931) );
  DFFRX1 cas_7_data_reg_6_ ( .D(n2925), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[6]), .QN(net2933) );
  DFFRX1 cas_7_data_reg_4_ ( .D(n2927), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[4]), .QN(net2937) );
  DFFRX1 cas_7_data_reg_3_ ( .D(n2928), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[3]), .QN(net2939) );
  DFFRX1 cas_7_data_reg_2_ ( .D(n2929), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[2]), .QN(net2941) );
  DFFRX1 cas_7_data_reg_1_ ( .D(n2930), .CK(ACLK), .RN(ARESETB), .Q(
        cas_7_data[1]), .QN(net2943) );
  DFFRX1 CAS_0_PM_reg ( .D(n2983), .CK(ACLK), .RN(ARESETB), .Q(CAS_0_PM), .QN(
        n2882) );
  NAND2X1 U6268 ( .A(n4933), .B(n6462), .Y(n5535) );
endmodule


module SDRAi ( ARESETB, PORESETB, ACLK, nACLK, FCLK, AWAddr, AWId, AWLen, 
        AWValid, AWReady, AWBurst, WLast, WStrb, WData, WValid, WReady, WId, 
        BResp, BValid, BReady, BId, ARAddr, ARId, ARLen, ARValid, ARReady, 
        ARBurst, RData, RValid, RReady, RLast, RId, RResp, RQFull, WQFull, 
        BA_STS, BA_AA, BA_REQ, BA_TT, BA_RW, BA_ID, BA_PM, SD_DQE, SD_DQI, 
        SD_DQO, SD_DQM );
  input [21:0] AWAddr;
  input [3:0] AWId;
  input [3:0] AWLen;
  input [1:0] AWBurst;
  input [3:0] WStrb;
  input [31:0] WData;
  input [3:0] WId;
  output [1:0] BResp;
  output [3:0] BId;
  input [21:0] ARAddr;
  input [3:0] ARId;
  input [3:0] ARLen;
  input [1:0] ARBurst;
  output [31:0] RData;
  output [3:0] RId;
  output [1:0] RResp;
  input [13:0] BA_STS;
  output [21:0] BA_AA;
  output [3:0] BA_TT;
  output [3:0] BA_ID;
  input [31:0] SD_DQI;
  output [31:0] SD_DQO;
  output [3:0] SD_DQM;
  input ARESETB, PORESETB, ACLK, nACLK, FCLK, AWValid, WLast, WValid, BReady,
         ARValid, RReady;
  output AWReady, WReady, BValid, ARReady, RValid, RLast, RQFull, WQFull,
         BA_REQ, BA_RW, BA_PM, SD_DQE;
  wire   WQWrData_35_, WQWrData_34_, WQWrData_33_, WQWrData_32_, WriteLatA0_3_,
         WriteLatA0_2_, WriteLatA0_1_, WriteLatA0_0_, tWIdle, tWWDat, tWWReq,
         tWWSpi, tRRReq, tRRSpi, tRDIdle, tRDReq, WriteAck, iWValid,
         WriteLatAA_21_, WriteLatAA_20_, WriteLatAA_19_, WriteLatAA_18_,
         WriteLatAA_17_, WriteLatAA_16_, WriteLatAA_15_, WriteLatAA_14_,
         WriteLatAA_13_, WriteLatAA_12_, WriteLatAA_11_, WriteLatAA_10_,
         WriteLatAA_9_, WriteLatAA_8_, WriteLatAA_7_, WriteLatAA_6_,
         WriteLatAA_5_, WriteLatAA_4_, WBLQFull, WBLQWrite, WBLQEmpty, n_984,
         WQEmpty, DelayiWQRead, WQRdData_35_, WQRdData_34_, WQRdData_33_,
         WQRdData_32_, RQHFull, RBLQFull, ReadLatAA_21_, ReadLatAA_20_,
         ReadLatAA_19_, ReadLatAA_18_, ReadLatAA_17_, ReadLatAA_16_,
         ReadLatAA_15_, ReadLatAA_14_, ReadLatAA_13_, ReadLatAA_12_,
         ReadLatAA_11_, ReadLatAA_10_, ReadLatAA_9_, ReadLatAA_8_,
         ReadLatAA_7_, ReadLatAA_6_, ReadLatAA_5_, ReadLatAA_4_, ReadLatA0_3_,
         ReadLatA0_2_, ReadLatA0_1_, ReadLatA0_0_, n_1928, iDelayReadFlag,
         iDelayReadLast, RQRead, IncRdLastCnt, RdDataRdy, RQWrite, RQEmpty,
         AckMem251, WSpi2Addr_20_, WSpi2Addr_19_, WSpi2Addr_18_, WSpi2Addr_17_,
         WSpi2Addr_16_, WSpi2Addr_15_, WSpi2Addr_14_, WSpi2Addr_13_,
         WSpi2Addr_12_, WSpi2Addr_11_, WSpi2Addr_10_, WSpi2Addr_9_, n746_0_,
         WrWrapAddrSt_3_, WrWrapAddrSt_2_, WrWrapAddrSt_1_, WrWrapAddrSt_0_,
         LatchedWBL_3_, LatchedWBL_2_, LatchedWBL_1_, LatchedWBL_0_,
         WrWrapCnt1080_3_, WrWrapCnt1080_2_, WrWrapCnt1080_1_,
         WrWrapCnt1083_4_, WrWrapCnt1083_3_, WrWrapCnt1083_2_,
         WrWrapCnt1083_1_, n1089_29_, n1089_30_, n1089_31_, WrWrapCnt1104_5_,
         WrWrapCnt1104_4_, WrWrapCnt1104_3_, WrWrapCnt1104_2_,
         WrWrapCnt1104_1_, n1105_27_, n1105_28_, n1105_29_, n1105_30_,
         n1105_31_, n1107_29_, n1107_30_, n1107_31_, a1130_30_, a1130_29_,
         a1130_28_, a1130_27_, a1130_26_, a1130_25_, a1130_24_, a1130_23_,
         a1130_22_, a1130_21_, a1130_20_, a1130_19_, a1130_15_, a1130_14_,
         a1130_13_, a1130_12_, a1130_11_, a1130_10_, a1130_9_, a1130_7_,
         a1130_6_, a1130_5_, a1130_4_, a1130_3_, a1130_2_, a1130_1_,
         RSpi2Addr_20_, RSpi2Addr_19_, RSpi2Addr_18_, RSpi2Addr_17_,
         RSpi2Addr_16_, RSpi2Addr_15_, RSpi2Addr_14_, RSpi2Addr_13_,
         RSpi2Addr_12_, RSpi2Addr_11_, RSpi2Addr_10_, RSpi2Addr_9_,
         RdWrapAddrSt_3_, RdWrapAddrSt_2_, RdWrapAddrSt_1_, RdWrapAddrSt_0_,
         LatchedRBL_3_, LatchedRBL_2_, LatchedRBL_1_, LatchedRBL_0_,
         RdWrapCnt2357_6_, RdWrapCnt2357_5_, RdWrapCnt2357_4_,
         RdWrapCnt2357_3_, RdWrapCnt2357_2_, RdWrapCnt2357_1_, RBLQEmpty,
         n4231, n4232, n4233, n4234, n4235, n4236, n4237, n4238, n4239, n4240,
         n4241, n4242, n4243, n4244, n4245, n4246, n4247, n4248, n4249, n4250,
         n4251, n4252, n4253, n4254, n4255, n4256, n4257, n4258, n4259, n4260,
         n4261, n4262, n4263, n4264, n4265, n4266, n4267, n4268, n4269, n4270,
         n4271, n4272, n4273, n4274, n4275, n4276, n4277, n4278, n4279, n4280,
         n4281, n4282, n4283, n4284, n4285, n4286, n4287, n4288, n4289, n4290,
         n4291, n4292, n4293, n4294, n4295, n4296, n4297, n4298, n4299, n4300,
         n4301, n4302, n4303, n4304, n4305, n4306, n4307, n4308, n4309, n4310,
         n4311, n4312, n4313, n4314, n4315, n4316, n4317, n4318, n4319, n4320,
         n4321, n4322, n4323, n4324, n4325, n4326, n4327, n4328, n4329, n4330,
         n4331, n4332, n4333, n4334, n4335, n4336, n4337, n4338, n4339, n4340,
         n4341, n4342, n4343, n4344, n4345, n4346, n4347, n4348, n4349, n4350,
         n4351, n4352, n4353, n4354, n4355, n4356, n4357, n4358, n4359, n4360,
         n4361, n4362, n4363, n4364, n4365, n4366, n4367, n4368, n4369, n4370,
         n4371, n4372, n4373, n4374, n4375, n4376, n4377, n4378, n4379, n4380,
         n4395, carry, carry0, carry1, carry2, carry3, carry4, carry5, carry6,
         carry7, carry8, carry9, n26, n37, n44, n55, n63, n73, n82, n92, n101,
         n112, n121, n131, carry10, carry11, carry12, n62, n72, n81, carry13,
         carry14, carry15, n16, n25, n36, n43, carry16, carry17, n15, n24, n35,
         carry18, carry19, carry20, carry21, carry_1_, n14, n23, n34, n42,
         carry22, carry23, n13, n22, n33, carry_12_, carry_11_, carry_10_,
         carry_9_, carry_8_, carry_7_, carry24, carry25, carry26, carry27,
         carry28, n11, n21, n32, n41, n51, n61, n71, n8, n9, n10, n111, n12,
         carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, n1, n2, n3, n4, n5,
         n6, g_array, g_array0, g_array1, g_array2, g_array3, g_array4,
         g_array5, g_array6, g_array7, g_array8, g_array9, g_array10,
         g_array11, g_array12, pog_array, pog_array0, pog_array1, pog_array2,
         pog_array3, pog_array4, pog_array5, part_diff_3_, part_diff_2_,
         part_diff_1_, n31, n4534, n4535, n4536, n4538, n4539, n4540, n4542,
         n4544, n4545, n4546, n4547, n4549, n4550, n4551, n4553, n4554, n4555,
         n4557, n4558, n4559, n4560, n4562, n4563, n4564, n4565, n4566, n4567,
         n4568, n4570, n4571, n4572, n4573, n4574, n4575, n4576, n4578, n4579,
         n4580, n4581, n4582, n4583, n4584, n4585, n4587, n4588, n4589, n4590,
         n4591, n4592, n4593, n4594, n4596, n4597, n4598, n4599, n4600, n4601,
         n4602, n4603, n4604, n4605, n4606, n4608, n4609, n4610, n4611, n4612,
         n4613, n4614, n4615, n4617, n4618, n4619, n4620, n4621, n4622, n4624,
         n4625, n4626, n4627, n4628, n4629, n4630, n4631, n4632, n4634, n4635,
         n4636, n4637, n4638, n4639, n4640, n4642, n4643, n4644, n4645, n4646,
         n4647, n4648, n4650, n4651, n4652, n4653, n4654, n4655, n4656, n4657,
         n4658, n4659, n4660, n4662, n4665, n4666, n4667, n4668, n4669, n4670,
         n4673, n4676, n4677, n4678, n4679, n4680, n4681, n4682, n4683, n4684,
         n4685, n4686, n4690, n4692, n4693, n4695, n4696, n4697, n4698, n4700,
         n4701, n4702, n4703, n4713, n4714, n4716, n4718, n4720, n4722, n4723,
         n4724, n4725, n4726, n4727, n4728, n4729, n4730, n4731, n4732, n4733,
         n4734, n4735, n4736, n4737, n4738, n4739, n4740, n4741, n4742, n4743,
         n4744, n4745, n4746, n4747, n4748, n4749, n4750, n4751, n4752, n4753,
         n4755, n4756, n4757, n4758, n4760, n4761, n4762, n4763, n4764, n4765,
         n4766, n4767, n4768, n4769, n4770, n4771, n4772, n4773, n4774, n4775,
         n4776, n4777, n4778, n4779, n4780, n4781, n4782, n4783, n4784, n4785,
         n4786, n4787, n4788, n4789, n4790, n4791, n4792, n4793, n4797, n4798,
         n4800, n4802, n4804, n4807, n4808, n4809, n4810, n4811, n4812, n4813,
         n4814, n4815, n4816, n4819, n4820, n4823, n4824, n4825, n4827, n4828,
         n4829, n4834, n4835, n4836, n4837, n4838, n4839, n4840, n4841, n4842,
         n4843, n4844, n4845, n4846, n4847, n4848, n4849, n4850, n4851, n4852,
         n4853, n4854, n4855, n4856, n4857, n4858, n4859, n4860, n4861, n4862,
         n4863, n4864, n4867, n4870, n4873, n4874, n4876, n4877, n4878, n4879,
         n4881, n4882, n4883, n4884, n4886, n4888, n4890, n4891, n4893, n4894,
         n4895, n4896, n4897, n4898, n4899, n4900, n4901, n4902, n4903, n4904,
         n4905, n4906, n4907, n4908, n4909, n4910, n4911, n4912, n4913, n4914,
         n4915, n4917, n4918, n4919, n4920, n4921, n4922, n4923, n4925, n4926,
         n4927, n4928, n4929, n4930, n4931, n4932, n4933, n4934, n4935, n4936,
         n4937, n4938, n4939, n4940, n4941, n4942, n4944, n4947, n4948, n4949,
         n4950, n4951, n4952, n4953, n4954, n4955, n4956, n4957, n4958, n4959,
         n4960, n4961, n4962, n4964, n4965, n4967, n4969, n4970, n4971, n4972,
         n4973, n4974, n4975, n4976, n4978, n4979, n4980, n4981, n4982, n4983,
         n4985, n4987, n4988, n4989, n4992, n4993, n4994, n4995, n4996, n4997,
         n4998, n4999, n5000, n5001, n5002, n5005, n5006, n5007, n5008, n5009,
         n5012, n5013, n5016, n5018, n5019, n5020, n5022, n5023, n5027, n5028,
         n5032, n5033, n5035, n5036, n5037, n5038, n5040, n5043, n5045, n5048,
         n5052, n5055, n5058, n5061, n5064, n5067, n5070, n5073, n5076, n5079,
         n5082, n5083, n5084, n5085, n5086, n5087, n5088, n5089, n5090, n5091,
         n5092, n5093, n5094, n5095, n5096, n5097, n5098, n5099, n5100, n5101,
         n5102, n5103, n5104, n5105, n5106, n5107, n5108, n5109, n5110, n5111,
         n5112, n5113, n5114, n5115, n5116, n5117, n5118, n5119, n5120, n5121,
         n5122, n5123, n5124, n5125, n5126, n5127, n5128, n5129, n5130, n5131,
         n5132, n5133, n5134, n5135, n5136, n5137, n5138, n5139, n5140, n5141,
         n5142, n5143, n5144, n5145, n5146, n5147, n5148, n5149, n5150, n5151,
         n5152, n5153, n5154, n5155, n5156, n5157, n5158, n5159, n5160, n5161,
         n5162, n5163, n5164, n5165, n5166, n5167, n5168, n5169, n5170, n5171,
         n5172, n5173, n5174, n5175, n5176, n5177, n5178, n5179, n5180, n5181,
         n5182, n5183, n5184, n5185, n5186, n5187, n5188, n5189, n5190, n5191,
         n5192;
  wire   [1:0] WriteLatBB;
  wire   [3:0] WriteLatTT;
  wire   [35:0] RQWrData;
  wire   [1:0] NxtStRD;
  wire   [4:0] NxtStW;
  wire   [3:0] WriteReqID;
  wire   [3:0] WBurstCnt;
  wire   [9:0] WBLQRdData;
  wire   [3:0] WBLCnt;
  wire   [5:0] WQIncAddr;
  wire   [5:0] WrWrapCnt;
  wire   [2:0] NxtStR;
  wire   [1:0] ReadLatBB;
  wire   [3:0] ReadLatTT;
  wire   [3:0] ReadReqID;
  wire   [3:0] iDelayReadId;
  wire   [31:0] RdDataMemFd;
  wire   [3:0] RBLCnt;
  wire   [9:0] RBLQRdData;
  wire   [7:0] RQIncAddr;
  wire   [3:0] RBurstCnt;
  wire   [3:0] RdLastCnt;
  wire   [7:0] RdWrapCnt;
  assign RResp[0] = 1'b0;
  assign RResp[1] = 1'b0;
  assign BResp[0] = 1'b0;
  assign BResp[1] = 1'b0;

  SDRWQ WDatBuf ( .nRST(ARESETB), .Clk(ACLK), .WriteEn(iWValid), .ReadEn(
        n746_0_), .DelayReadEn(DelayiWQRead), .WrData({WQWrData_35_, 
        WQWrData_34_, WQWrData_33_, WQWrData_32_, WData}), .RdData({
        WQRdData_35_, WQRdData_34_, WQRdData_33_, WQRdData_32_, SD_DQO}), 
        .FullFlag(WQFull), .EmptyFlag(WQEmpty), .WrapCnt(WrWrapCnt), 
        .IncRdCnt(WQIncAddr) );
  SDRRQ RDatBuf ( .nRST(ARESETB), .nClk(nACLK), .Clk(ACLK), .WriteEn(RQWrite), 
        .ReadEn(RQRead), .WrData(RQWrData), .RdData({RId, RData}), .FullFlag(
        RQFull), .HFullFlag(RQHFull), .EmptyFlag(RQEmpty), .WrapCnt(RdWrapCnt), 
        .IncRdCnt(RQIncAddr) );
  SDRBLQ_BLQCD0_BLQD1_BLQW9 WBLBuf ( .nRST(ARESETB), .Clk(ACLK), .WriteEn(
        WBLQWrite), .ReadEn(n_984), .WrData({WriteLatBB, WriteLatA0_3_, 
        WriteLatA0_2_, WriteLatA0_1_, WriteLatA0_0_, WriteLatTT}), .RdData(
        WBLQRdData), .FullFlag(WBLQFull), .EmptyFlag(WBLQEmpty) );
  SDRBLQ_BLQCD3_BLQD15_BLQW9 RBLBuf ( .nRST(ARESETB), .Clk(ACLK), .WriteEn(
        n_1928), .ReadEn(n5180), .WrData({ARBurst, ARAddr[3:0], ARLen}), 
        .RdData(RBLQRdData), .FullFlag(RBLQFull), .EmptyFlag(RBLQEmpty) );
  DFFRX4 WrWrapCnt_reg_0_ ( .D(n4284), .CK(ACLK), .RN(ARESETB), .Q(
        WrWrapCnt[0]) );
  DFFRX4 WrWrapCnt_reg_1_ ( .D(n4283), .CK(ACLK), .RN(ARESETB), .Q(
        WrWrapCnt[1]) );
  DFFRX4 WrWrapCnt_reg_2_ ( .D(n4282), .CK(ACLK), .RN(ARESETB), .Q(
        WrWrapCnt[2]) );
  DFFRX4 WrWrapCnt_reg_3_ ( .D(n4281), .CK(ACLK), .RN(ARESETB), .Q(
        WrWrapCnt[3]) );
  DFFRX4 WrWrapCnt_reg_4_ ( .D(n4280), .CK(ACLK), .RN(ARESETB), .Q(
        WrWrapCnt[4]), .QN(n5163) );
  DFFRX4 WrWrapCnt_reg_5_ ( .D(n4279), .CK(ACLK), .RN(ARESETB), .Q(
        WrWrapCnt[5]), .QN(n5165) );
  AHHCONX2 U1_1_16 ( .A(WrWrapCnt[1]), .CI(WrWrapCnt[0]), .S(WrWrapCnt1083_1_), 
        .CON(n43) );
  AHHCONX2 U1_1_24 ( .A(WrWrapCnt[2]), .CI(carry15), .S(WrWrapCnt1083_2_), 
        .CON(n36) );
  AHHCONX2 U1_1_34 ( .A(WrWrapCnt[3]), .CI(carry14), .S(WrWrapCnt1083_3_), 
        .CON(n25) );
  AHHCONX2 U1_1_42 ( .A(WrWrapCnt[4]), .CI(carry13), .S(WrWrapCnt1083_4_), 
        .CON(n16) );
  AHHCONX2 U1_1_33 ( .A(LatchedWBL_3_), .CI(carry16), .S(n1089_29_), .CON(n15)
         );
  AHHCONX2 U1_1_14 ( .A(WBLQRdData[1]), .CI(WBLQRdData[0]), .S(n1107_31_), 
        .CON(n33) );
  AHHCONX2 U1_1_22 ( .A(WBLQRdData[2]), .CI(carry23), .S(n1107_30_), .CON(n22)
         );
  AHHCONX2 U1_1_32 ( .A(WBLQRdData[3]), .CI(carry22), .S(n1107_29_), .CON(n13)
         );
  AHHCONX2 U1_1_1 ( .A(RdWrapCnt[1]), .CI(RdWrapCnt[0]), .S(RdWrapCnt2357_1_), 
        .CON(n6) );
  AHHCONX2 U1_1_2 ( .A(RdWrapCnt[2]), .CI(carry_2_), .S(RdWrapCnt2357_2_), 
        .CON(n5) );
  AHHCONX2 U1_1_3 ( .A(RdWrapCnt[3]), .CI(carry_3_), .S(RdWrapCnt2357_3_), 
        .CON(n4) );
  AHHCONX2 U1_1_4 ( .A(RdWrapCnt[4]), .CI(carry_4_), .S(RdWrapCnt2357_4_), 
        .CON(n3) );
  AHHCONX2 U1_1_5 ( .A(RdWrapCnt[5]), .CI(carry_5_), .S(RdWrapCnt2357_5_), 
        .CON(n2) );
  AHHCONX2 U1_1_6 ( .A(RdWrapCnt[6]), .CI(carry_6_), .S(RdWrapCnt2357_6_), 
        .CON(n1) );
  AHHCONX2 U1_1_13 ( .A(ReadLatAA_9_), .CI(ReadLatAA_8_), .S(RSpi2Addr_9_), 
        .CON(n12) );
  AHHCONX2 U1_1_41 ( .A(ReadLatAA_12_), .CI(carry26), .S(RSpi2Addr_12_), .CON(
        n9) );
  AHHCONX2 U1_1_51 ( .A(ReadLatAA_13_), .CI(carry25), .S(RSpi2Addr_13_), .CON(
        n8) );
  AHHCONX2 U1_1_61 ( .A(ReadLatAA_14_), .CI(carry24), .S(RSpi2Addr_14_), .CON(
        n71) );
  AHHCONX2 U1_1_7 ( .A(ReadLatAA_15_), .CI(carry_7_), .S(RSpi2Addr_15_), .CON(
        n61) );
  AHHCONX2 U1_1_31 ( .A(ReadLatAA_11_), .CI(carry27), .S(RSpi2Addr_11_), .CON(
        n10) );
  AHHCONX2 U1_1_21 ( .A(ReadLatAA_10_), .CI(carry28), .S(RSpi2Addr_10_), .CON(
        n111) );
  AHHCONX2 U1_1_8 ( .A(ReadLatAA_16_), .CI(carry_8_), .S(RSpi2Addr_16_), .CON(
        n51) );
  AHHCONX2 U1_1_9 ( .A(ReadLatAA_17_), .CI(carry_9_), .S(RSpi2Addr_17_), .CON(
        n41) );
  AHHCONX2 U1_1_10 ( .A(ReadLatAA_18_), .CI(carry_10_), .S(RSpi2Addr_18_), 
        .CON(n32) );
  AHHCONX2 U1_1_11 ( .A(ReadLatAA_19_), .CI(carry_11_), .S(RSpi2Addr_19_), 
        .CON(n21) );
  AHHCONX2 U1_1_12 ( .A(ReadLatAA_20_), .CI(carry_12_), .S(RSpi2Addr_20_), 
        .CON(n11) );
  AHHCONX2 U1_1_15 ( .A(LatchedWBL_1_), .CI(LatchedWBL_0_), .S(n1089_31_), 
        .CON(n35) );
  AHHCONX2 U1_1_23 ( .A(LatchedWBL_2_), .CI(carry17), .S(n1089_30_), .CON(n24)
         );
  AHHCONX2 U1_1_17 ( .A(WriteLatAA_9_), .CI(WriteLatAA_8_), .S(WSpi2Addr_9_), 
        .CON(n131) );
  AHHCONX2 U1_1_35 ( .A(WriteLatAA_11_), .CI(carry8), .S(WSpi2Addr_11_), .CON(
        n112) );
  AHHCONX2 U1_1_111 ( .A(WriteLatAA_19_), .CI(carry0), .S(WSpi2Addr_19_), 
        .CON(n37) );
  AHHCONX2 U1_1_52 ( .A(WriteLatAA_13_), .CI(carry6), .S(WSpi2Addr_13_), .CON(
        n92) );
  AHHCONX2 U1_1_101 ( .A(WriteLatAA_18_), .CI(carry1), .S(WSpi2Addr_18_), 
        .CON(n44) );
  AHHCONX2 U1_1_43 ( .A(WriteLatAA_12_), .CI(carry7), .S(WSpi2Addr_12_), .CON(
        n101) );
  AHHCONX2 U1_1_62 ( .A(WriteLatAA_14_), .CI(carry5), .S(WSpi2Addr_14_), .CON(
        n82) );
  AHHCONX2 U1_1_25 ( .A(WriteLatAA_10_), .CI(carry9), .S(WSpi2Addr_10_), .CON(
        n121) );
  AHHCONX2 U1_1_121 ( .A(WriteLatAA_20_), .CI(carry), .S(WSpi2Addr_20_), .CON(
        n26) );
  AHHCONX2 U1_1_91 ( .A(WriteLatAA_17_), .CI(carry2), .S(WSpi2Addr_17_), .CON(
        n55) );
  AHHCONX2 U1_1_71 ( .A(WriteLatAA_15_), .CI(carry4), .S(WSpi2Addr_15_), .CON(
        n73) );
  AHHCONX2 U1_1_81 ( .A(WriteLatAA_16_), .CI(carry3), .S(WSpi2Addr_16_), .CON(
        n63) );
  AOI32X4 U2307 ( .A0(WrWrapCnt[0]), .A1(n5127), .A2(n4725), .B0(WrWrapCnt[0]), 
        .B1(n4726), .Y(n4724) );
  INVX4 U2854 ( .A(n4713), .Y(n_1928) );
  OAI222X1 U2855 ( .A0(RdWrapCnt[2]), .A1(n4608), .B0(n4608), .B1(n5147), .C0(
        RdWrapCnt[2]), .C1(n5147), .Y(n4659) );
  OAI222X1 U2856 ( .A0(RdWrapCnt[1]), .A1(n4581), .B0(n4581), .B1(n5134), .C0(
        RdWrapCnt[1]), .C1(n5134), .Y(n4660) );
  OAI222X1 U2857 ( .A0(RdWrapCnt[3]), .A1(n4617), .B0(n4617), .B1(n5148), .C0(
        RdWrapCnt[3]), .C1(n5148), .Y(n4622) );
  AOI221X1 U2858 ( .A0(n1), .A1(n5174), .B0(RdWrapCnt[6]), .B1(n4578), .C0(
        n4643), .Y(n4654) );
  OAI31X1 U2859 ( .A0(n4853), .A1(WBLQRdData[2]), .A2(WBLQRdData[1]), .B0(
        n4861), .Y(n4762) );
  NAND2BX1 U2860 ( .AN(n4890), .B(ARValid), .Y(n4713) );
  OAI211X1 U2861 ( .A0(n4870), .A1(n4899), .B0(n4900), .C0(n4901), .Y(BA_TT[3]) );
  OAI211X1 U2862 ( .A0(n4952), .A1(n4953), .B0(n4954), .C0(n4955), .Y(BA_TT[1]) );
  OAI211X1 U2863 ( .A0(n4929), .A1(n4930), .B0(n4931), .C0(n4932), .Y(BA_TT[2]) );
  AOI222X1 U2864 ( .A0(RdWrapCnt[4]), .A1(n4624), .B0(RdWrapCnt2357_4_), .B1(
        n4598), .C0(RQIncAddr[4]), .C1(n4593), .Y(n4620) );
  AOI222X1 U2865 ( .A0(RdWrapCnt[5]), .A1(n4624), .B0(RdWrapCnt2357_5_), .B1(
        n4598), .C0(RQIncAddr[5]), .C1(n4593), .Y(n4629) );
  OAI222X1 U2866 ( .A0(n4582), .A1(n4585), .B0(n4551), .B1(n5168), .C0(
        RdWrapCnt[0]), .C1(n4587), .Y(n4574) );
  AOI32X1 U2867 ( .A0(RdWrapCnt[0]), .A1(n5169), .A2(n4578), .B0(n4579), .B1(
        n4580), .Y(n4576) );
  AOI222X1 U2868 ( .A0(n4642), .A1(n4551), .B0(RQIncAddr[6]), .B1(n4593), .C0(
        RdWrapCnt[6]), .C1(n4643), .Y(n4639) );
  AOI222X1 U2869 ( .A0(n4583), .A1(n4612), .B0(RdWrapCnt[3]), .B1(n4568), .C0(
        RQIncAddr[3]), .C1(n4593), .Y(n4611) );
  AOI32X1 U2870 ( .A0(RdWrapCnt[3]), .A1(n4614), .A2(n4578), .B0(
        RdWrapCnt2357_3_), .B1(n4598), .Y(n4610) );
  AOI222X1 U2871 ( .A0(n4583), .A1(n4603), .B0(RdWrapCnt[2]), .B1(n4568), .C0(
        RQIncAddr[2]), .C1(n4593), .Y(n4602) );
  AOI32X1 U2872 ( .A0(RdWrapCnt[2]), .A1(n4605), .A2(n4578), .B0(
        RdWrapCnt2357_2_), .B1(n4598), .Y(n4601) );
  AOI222X1 U2873 ( .A0(n4583), .A1(n4592), .B0(RdWrapCnt[1]), .B1(n4568), .C0(
        RQIncAddr[1]), .C1(n4593), .Y(n4591) );
  AOI32X1 U2874 ( .A0(n4597), .A1(RdWrapCnt[1]), .A2(n4578), .B0(
        RdWrapCnt2357_1_), .B1(n4598), .Y(n4590) );
  DFFRX1 RdWrapCnt_reg_6_ ( .D(n4362), .CK(ACLK), .RN(ARESETB), .Q(
        RdWrapCnt[6]) );
  DFFRX1 RdWrapCnt_reg_3_ ( .D(n4365), .CK(ACLK), .RN(ARESETB), .Q(
        RdWrapCnt[3]) );
  DFFRX1 RdWrapCnt_reg_2_ ( .D(n4366), .CK(ACLK), .RN(ARESETB), .Q(
        RdWrapCnt[2]) );
  DFFRX1 RdWrapCnt_reg_1_ ( .D(n4367), .CK(ACLK), .RN(ARESETB), .Q(
        RdWrapCnt[1]) );
  AO21X1 U2875 ( .A0(pog_array3), .A1(g_array11), .B0(g_array4), .Y(n5109) );
  OA21X2 U2876 ( .A0(pog_array1), .A1(g_array9), .B0(g_array1), .Y(n5110) );
  DFFRX1 RdWrapCnt_reg_4_ ( .D(n4364), .CK(ACLK), .RN(ARESETB), .Q(
        RdWrapCnt[4]), .QN(n5113) );
  DFFRX1 RdWrapCnt_reg_5_ ( .D(n4363), .CK(ACLK), .RN(ARESETB), .Q(
        RdWrapCnt[5]), .QN(n5162) );
  DFFRX1 RdWrapCnt_reg_7_ ( .D(n4361), .CK(ACLK), .RN(ARESETB), .Q(
        RdWrapCnt[7]), .QN(n5164) );
  DFFRX1 RdWrapCnt_reg_0_ ( .D(n4368), .CK(ACLK), .RN(ARESETB), .Q(
        RdWrapCnt[0]), .QN(n5168) );
  DFFRX1 iDelayReadLast_reg ( .D(BA_STS[5]), .CK(ACLK), .RN(ARESETB), .Q(
        iDelayReadLast) );
  DFFRX1 RdDataMem_reg_0_ ( .D(RdDataMemFd[0]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[0]) );
  DFFRX1 RdDataMem_reg_1_ ( .D(RdDataMemFd[1]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[1]) );
  DFFRX1 RdDataMem_reg_2_ ( .D(RdDataMemFd[2]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[2]) );
  DFFRX1 RdDataMem_reg_3_ ( .D(RdDataMemFd[3]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[3]) );
  DFFRX1 RdDataMem_reg_4_ ( .D(RdDataMemFd[4]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[4]) );
  DFFRX1 RdDataMem_reg_5_ ( .D(RdDataMemFd[5]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[5]) );
  DFFRX1 RdDataMem_reg_6_ ( .D(RdDataMemFd[6]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[6]) );
  DFFRX1 RdDataMem_reg_7_ ( .D(RdDataMemFd[7]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[7]) );
  DFFRX1 RdDataMem_reg_8_ ( .D(RdDataMemFd[8]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[8]) );
  DFFRX1 RdDataMem_reg_9_ ( .D(RdDataMemFd[9]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[9]) );
  DFFRX1 RdDataMem_reg_10_ ( .D(RdDataMemFd[10]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[10]) );
  DFFRX1 RdDataMem_reg_11_ ( .D(RdDataMemFd[11]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[11]) );
  DFFRX1 RdDataMem_reg_12_ ( .D(RdDataMemFd[12]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[12]) );
  DFFRX1 RdDataMem_reg_13_ ( .D(RdDataMemFd[13]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[13]) );
  DFFRX1 RdDataMem_reg_14_ ( .D(RdDataMemFd[14]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[14]) );
  DFFRX1 RdDataMem_reg_15_ ( .D(RdDataMemFd[15]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[15]) );
  DFFRX1 RdDataMem_reg_16_ ( .D(RdDataMemFd[16]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[16]) );
  DFFRX1 RdDataMem_reg_17_ ( .D(RdDataMemFd[17]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[17]) );
  DFFRX1 RdDataMem_reg_18_ ( .D(RdDataMemFd[18]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[18]) );
  DFFRX1 RdDataMem_reg_19_ ( .D(RdDataMemFd[19]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[19]) );
  DFFRX1 RdDataMem_reg_20_ ( .D(RdDataMemFd[20]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[20]) );
  DFFRX1 RdDataMem_reg_21_ ( .D(RdDataMemFd[21]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[21]) );
  DFFRX1 RdDataMem_reg_22_ ( .D(RdDataMemFd[22]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[22]) );
  DFFRX1 RdDataMem_reg_23_ ( .D(RdDataMemFd[23]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[23]) );
  DFFRX1 RdDataMem_reg_24_ ( .D(RdDataMemFd[24]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[24]) );
  DFFRX1 RdDataMem_reg_25_ ( .D(RdDataMemFd[25]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[25]) );
  DFFRX1 RdDataMem_reg_26_ ( .D(RdDataMemFd[26]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[26]) );
  DFFRX1 RdDataMem_reg_27_ ( .D(RdDataMemFd[27]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[27]) );
  DFFRX1 RdDataMem_reg_28_ ( .D(RdDataMemFd[28]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[28]) );
  DFFRX1 RdDataMem_reg_29_ ( .D(RdDataMemFd[29]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[29]) );
  DFFRX1 RdDataMem_reg_30_ ( .D(RdDataMemFd[30]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[30]) );
  DFFRX1 RdDataMem_reg_31_ ( .D(RdDataMemFd[31]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[31]) );
  DFFRX1 RdIdMem_reg_0_ ( .D(iDelayReadId[0]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[32]) );
  DFFRX1 RdIdMem_reg_1_ ( .D(iDelayReadId[1]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[33]) );
  DFFRX1 RdIdMem_reg_2_ ( .D(iDelayReadId[2]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[34]) );
  DFFRX1 RdIdMem_reg_3_ ( .D(iDelayReadId[3]), .CK(ACLK), .RN(ARESETB), .Q(
        RQWrData[35]) );
  DFFRX1 iDelayReadId_reg_0_ ( .D(BA_STS[6]), .CK(ACLK), .RN(ARESETB), .Q(
        iDelayReadId[0]) );
  DFFRX1 iDelayReadId_reg_1_ ( .D(BA_STS[7]), .CK(ACLK), .RN(ARESETB), .Q(
        iDelayReadId[1]) );
  DFFRX1 iDelayReadId_reg_2_ ( .D(BA_STS[8]), .CK(ACLK), .RN(ARESETB), .Q(
        iDelayReadId[2]) );
  DFFRX1 iDelayReadId_reg_3_ ( .D(BA_STS[9]), .CK(ACLK), .RN(ARESETB), .Q(
        iDelayReadId[3]) );
  BUFX2 U2877 ( .A(g_array12), .Y(n5189) );
  BUFX2 U2878 ( .A(g_array12), .Y(n5188) );
  BUFX2 U2879 ( .A(g_array12), .Y(n5190) );
  INVX1 U2880 ( .A(n4714), .Y(n_984) );
  OA21X1 U2881 ( .A0(n_1928), .A1(n5089), .B0(n4888), .Y(n4886) );
  NAND3BX1 U2882 ( .AN(n4979), .B(n4980), .C(n4981), .Y(BA_TT[0]) );
  AO22X1 U2883 ( .A0(n5192), .A1(WriteLatAA_6_), .B0(n4902), .B1(ReadLatAA_6_), 
        .Y(BA_AA[6]) );
  AO22X1 U2884 ( .A0(ReadReqID[3]), .A1(n5009), .B0(WriteReqID[3]), .B1(n4998), 
        .Y(BA_ID[3]) );
  AO22X1 U2885 ( .A0(ReadReqID[1]), .A1(n5009), .B0(WriteReqID[1]), .B1(n4998), 
        .Y(BA_ID[1]) );
  NAND4BX1 U2886 ( .AN(n4798), .B(n4772), .C(n4768), .D(n4773), .Y(n4797) );
  NAND3BX1 U2887 ( .AN(a1130_28_), .B(n4774), .C(n4775), .Y(n4798) );
  INVX1 U1_2_5_8 ( .A(n5189), .Y(a1130_10_) );
  INVX1 U1_2_5_10 ( .A(n5189), .Y(a1130_12_) );
  INVX1 U1_2_5_27 ( .A(n5188), .Y(a1130_29_) );
  INVX1 U1_2_5_17 ( .A(n5189), .Y(a1130_19_) );
  INVX1 U1_2_5_12 ( .A(n5190), .Y(a1130_14_) );
  INVX1 U1_2_5_13 ( .A(n5190), .Y(a1130_15_) );
  INVX1 U1_2_5_7 ( .A(n5190), .Y(a1130_9_) );
  INVX1 U2888 ( .A(a1130_23_), .Y(n4768) );
  INVX1 U1_2_5_21 ( .A(n5188), .Y(a1130_23_) );
  INVX1 U2889 ( .A(a1130_27_), .Y(n4774) );
  INVX1 U1_2_5_25 ( .A(n5190), .Y(a1130_27_) );
  INVX1 U2890 ( .A(a1130_22_), .Y(n4770) );
  INVX1 U1_2_5_20 ( .A(n5190), .Y(a1130_22_) );
  INVX1 U2891 ( .A(a1130_21_), .Y(n4769) );
  INVX1 U1_2_5_19 ( .A(n5190), .Y(a1130_21_) );
  INVX1 U1_2_5_18 ( .A(n5188), .Y(a1130_20_) );
  INVX1 U1_2_5_11 ( .A(n5188), .Y(a1130_13_) );
  INVX1 U1_2_5_26 ( .A(n5190), .Y(a1130_28_) );
  INVX1 U2892 ( .A(a1130_24_), .Y(n4773) );
  INVX1 U1_2_5_22 ( .A(n5189), .Y(a1130_24_) );
  INVX1 U2893 ( .A(a1130_25_), .Y(n4772) );
  INVX1 U1_2_5_23 ( .A(n5189), .Y(a1130_25_) );
  INVX1 U2894 ( .A(a1130_26_), .Y(n4775) );
  INVX1 U1_2_5_24 ( .A(n5188), .Y(a1130_26_) );
  OR4X1 U2895 ( .A(a1130_6_), .B(a1130_7_), .C(a1130_30_), .D(a1130_29_), .Y(
        n4783) );
  INVX1 U1_2_5_4 ( .A(n5171), .Y(a1130_6_) );
  INVX1 U1_2_5_5 ( .A(n5170), .Y(a1130_7_) );
  INVX1 U1_2_5_28 ( .A(n5189), .Y(a1130_30_) );
  INVX1 U2896 ( .A(n4588), .Y(n4580) );
  INVX1 U2897 ( .A(n4808), .Y(n4816) );
  INVX1 U2898 ( .A(n31), .Y(g_array12) );
  AO21X1 U2899 ( .A0(pog_array3), .A1(g_array11), .B0(g_array3), .Y(n5170) );
  AO21X1 U2900 ( .A0(pog_array3), .A1(g_array11), .B0(g_array3), .Y(n5171) );
  NAND2BX1 U2901 ( .AN(n4568), .B(n4578), .Y(n4588) );
  INVX1 U1_2_2_2 ( .A(g_array8), .Y(g_array11) );
  INVX1 U1_2_1_0 ( .A(g_array6), .Y(g_array9) );
  INVX1 U2902 ( .A(n4585), .Y(n4593) );
  INVX1 U2903 ( .A(n4625), .Y(n4583) );
  INVX1 U2904 ( .A(n4860), .Y(n4839) );
  INVX1 U2905 ( .A(n4587), .Y(n4598) );
  INVX1 U2906 ( .A(n4565), .Y(n4690) );
  NAND3BX1 U2907 ( .AN(n_984), .B(n4807), .C(n4789), .Y(n4808) );
  NAND2BX1 U2908 ( .AN(n746_0_), .B(n4789), .Y(n4807) );
  NAND2BX1 U2909 ( .AN(RBLQRdData[3]), .B(RBLQRdData[0]), .Y(n4677) );
  NAND2BX1 U2910 ( .AN(n4827), .B(n_984), .Y(n4804) );
  NAND2BX1 U2911 ( .AN(n4820), .B(n_984), .Y(n4800) );
  NAND2BX1 U2912 ( .AN(n4824), .B(n_984), .Y(n4802) );
  INVX1 U2913 ( .A(n4735), .Y(n4725) );
  INVX1 U2914 ( .A(n4998), .Y(n4879) );
  INVX1 U2915 ( .A(n4728), .Y(n4740) );
  INVX1 U2916 ( .A(n4584), .Y(n4570) );
  INVX1 U2917 ( .A(n4596), .Y(n4571) );
  INVX1 U2918 ( .A(n4734), .Y(n4739) );
  INVX1 U2919 ( .A(n4748), .Y(n4755) );
  NAND2BX1 U2920 ( .AN(n4820), .B(n4716), .Y(n4860) );
  AO21X1 U2921 ( .A0(n4681), .A1(n4682), .B0(n4683), .Y(n4679) );
  INVX1 U2922 ( .A(n4677), .Y(n4681) );
  INVX1 U2923 ( .A(n4910), .Y(n4941) );
  OR4X1 U2924 ( .A(a1130_21_), .B(a1130_23_), .C(n4782), .D(n4783), .Y(n4765)
         );
  OR3X2 U2925 ( .A(a1130_5_), .B(a1130_9_), .C(n31), .Y(n4782) );
  INVX1 U1_3_0_3 ( .A(pog_array), .Y(pog_array3) );
  INVX1 U2926 ( .A(BA_RW), .Y(n5009) );
  OR4X1 U2927 ( .A(a1130_11_), .B(a1130_10_), .C(a1130_14_), .D(n4788), .Y(
        n4787) );
  INVX1 U2928 ( .A(n4789), .Y(n4788) );
  INVX1 U1_2_5_9 ( .A(n5188), .Y(a1130_11_) );
  INVX1 U1_2_0_3 ( .A(g_array), .Y(g_array4) );
  INVX1 U1_2_3_6 ( .A(g_array10), .Y(n31) );
  OAI21X1 U1_4_2_6 ( .A0(pog_array5), .A1(g_array8), .B0(g_array7), .Y(
        g_array10) );
  INVX1 U2929 ( .A(pog_array3), .Y(pog_array5) );
  INVX1 U2930 ( .A(g_array3), .Y(g_array7) );
  INVX1 U2931 ( .A(n4658), .Y(n4572) );
  INVX1 U2932 ( .A(n4851), .Y(n1105_27_) );
  NAND2BX1 U2933 ( .AN(n4849), .B(n13), .Y(n4851) );
  INVX1 U2934 ( .A(n4657), .Y(n4573) );
  INVX1 U2935 ( .A(n4870), .Y(n4934) );
  INVX1 U2936 ( .A(n4876), .Y(n4904) );
  INVX1 U2937 ( .A(RBLQRdData[2]), .Y(n4682) );
  INVX1 U2938 ( .A(n4983), .Y(n4982) );
  AOI21X1 U1_4_1_2 ( .A0(pog_array4), .A1(g_array6), .B0(g_array5), .Y(
        g_array8) );
  NOR2X1 U1_5_0_2 ( .A(pog_array1), .B(pog_array0), .Y(pog_array4) );
  OAI21X1 U1_4_0_2 ( .A0(pog_array0), .A1(g_array1), .B0(g_array0), .Y(
        g_array5) );
  OAI31X1 U2939 ( .A0(n4673), .A1(n4572), .A2(n4573), .B0(n5180), .Y(n4625) );
  NAND2BX1 U2940 ( .AN(n4570), .B(n4596), .Y(n4673) );
  NAND2BX1 U2941 ( .AN(n4568), .B(n5174), .Y(n4587) );
  NAND2X1 U2942 ( .A(RBLQRdData[3]), .B(n5180), .Y(n4565) );
  NAND2X1 U2943 ( .A(pog_array2), .B(g_array2), .Y(g_array6) );
  NAND3BX1 U2944 ( .AN(n4656), .B(n4657), .C(n5180), .Y(n4585) );
  NAND3BX1 U2945 ( .AN(n4570), .B(n4596), .C(n4658), .Y(n4656) );
  INVX1 U2946 ( .A(n1107_29_), .Y(n4847) );
  INVX1 U2947 ( .A(n1107_30_), .Y(n4843) );
  INVX1 U2948 ( .A(n1107_31_), .Y(n4840) );
  INVX1 U2949 ( .A(n4551), .Y(n4568) );
  INVX1 U2950 ( .A(n4693), .Y(n4703) );
  INVX1 U2951 ( .A(n4632), .Y(n4578) );
  AO21X1 U2952 ( .A0(n4635), .A1(n4578), .B0(n4568), .Y(n4624) );
  AO21X1 U2953 ( .A0(n4578), .A1(n4634), .B0(n4568), .Y(n4643) );
  INVX1 U2954 ( .A(n4733), .Y(n4731) );
  INVX1 U2955 ( .A(RBLQRdData[1]), .Y(n4676) );
  NAND2BX1 U2956 ( .AN(n4682), .B(n5180), .Y(n4562) );
  NAND2X1 U2957 ( .A(RBLQRdData[0]), .B(n5180), .Y(n4554) );
  NAND2BX1 U2958 ( .AN(n4676), .B(n5180), .Y(n4557) );
  INVX1 U2959 ( .A(n4953), .Y(n4902) );
  INVX1 U2960 ( .A(n4615), .Y(n4614) );
  INVX1 U2961 ( .A(n4606), .Y(n4605) );
  INVX1 U2962 ( .A(n4882), .Y(n4883) );
  INVX1 U2963 ( .A(n5187), .Y(n4836) );
  INVX1 U2964 ( .A(n4862), .Y(iWValid) );
  INVX1 U2965 ( .A(n11), .Y(n5037) );
  NAND2BX1 U2966 ( .AN(n5192), .B(n5116), .Y(n4998) );
  NAND3BX1 U2967 ( .AN(n4779), .B(n4780), .C(n4781), .Y(n4735) );
  INVX1 U2968 ( .A(n4764), .Y(n4780) );
  INVX1 U2969 ( .A(n4765), .Y(n4781) );
  NAND4BX1 U2970 ( .AN(n4797), .B(n4770), .C(n4769), .D(n4714), .Y(n4779) );
  OAI31X1 U2971 ( .A0(n4677), .A1(RBLQRdData[2]), .A2(RBLQRdData[1]), .B0(
        n4685), .Y(n4596) );
  NOR2BX1 U2972 ( .AN(RBLQRdData[5]), .B(n4683), .Y(n4685) );
  NAND3BX1 U2973 ( .AN(n_984), .B(n5177), .C(n746_0_), .Y(n4819) );
  NAND3BX1 U2974 ( .AN(n4760), .B(n4761), .C(n_984), .Y(n4728) );
  NAND3BX1 U2975 ( .AN(n4716), .B(n4762), .C(n4763), .Y(n4760) );
  NAND2BX1 U2976 ( .AN(n4683), .B(RBLQRdData[4]), .Y(n4584) );
  INVX1 U2977 ( .A(n4894), .Y(RQRead) );
  NAND2BX1 U2978 ( .AN(n4867), .B(RReady), .Y(n4894) );
  AO21X1 U2979 ( .A0(n4725), .A1(n4756), .B0(n4726), .Y(n4748) );
  INVX1 U2980 ( .A(n62), .Y(n4756) );
  OAI31X1 U2981 ( .A0(n4764), .A1(n4765), .A2(n4766), .B0(n4714), .Y(n4734) );
  NAND4BX1 U2982 ( .AN(n4767), .B(n4768), .C(n4769), .D(n4770), .Y(n4766) );
  NAND3BX1 U2983 ( .AN(n4771), .B(n4772), .C(n4773), .Y(n4767) );
  NAND3BX1 U2984 ( .AN(a1130_28_), .B(n4774), .C(n4775), .Y(n4771) );
  INVX1 U2985 ( .A(n4726), .Y(n746_0_) );
  NAND2BX1 U2986 ( .AN(RBLQRdData[8]), .B(RBLQRdData[9]), .Y(n4683) );
  OR2X1 U2987 ( .A(n4626), .B(n4618), .Y(n4627) );
  INVX1 U2988 ( .A(n4864), .Y(WReady) );
  OR2X1 U2989 ( .A(n4644), .B(n4637), .Y(n4645) );
  INVX1 U2990 ( .A(n4778), .Y(n4750) );
  NAND3BX1 U2991 ( .AN(n4735), .B(n5163), .C(n62), .Y(n4778) );
  INVX1 U2992 ( .A(n4890), .Y(ARReady) );
  INVX1 U2993 ( .A(n4881), .Y(AWReady) );
  OAI211X1 U2994 ( .A0(n4809), .A1(n5150), .B0(n4810), .C0(n4802), .Y(n4273)
         );
  INVX1 U2995 ( .A(n4811), .Y(n4809) );
  OAI211X1 U2996 ( .A0(n5176), .A1(n5133), .B0(n4802), .C0(n4823), .Y(n4269)
         );
  OAI211X1 U2997 ( .A0(n746_0_), .A1(n5177), .B0(n4819), .C0(n4800), .Y(n4270)
         );
  INVX1 U2998 ( .A(n4776), .Y(n4732) );
  OAI31X1 U2999 ( .A0(n4777), .A1(n4720), .A2(n4722), .B0(n_984), .Y(n4776) );
  NAND2BX1 U3000 ( .AN(n4716), .B(n4762), .Y(n4777) );
  INVX1 U3001 ( .A(n4686), .Y(n4594) );
  NAND2BX1 U3002 ( .AN(n4582), .B(n4570), .Y(n4686) );
  AND2X2 U3003 ( .A(WBLQRdData[3]), .B(n_984), .Y(n5172) );
  INVX1 U3004 ( .A(n33), .Y(carry23) );
  AO21X1 U3005 ( .A0(n5085), .A1(n5117), .B0(n4998), .Y(BA_RW) );
  NAND2BX1 U3006 ( .AN(g_array4), .B(n15), .Y(g_array3) );
  NAND2BX1 U3007 ( .AN(n5085), .B(n5009), .Y(n4953) );
  NAND2BX1 U3008 ( .AN(n5192), .B(n4998), .Y(n4910) );
  NAND2BX1 U3009 ( .AN(n4679), .B(RBLQRdData[6]), .Y(n4658) );
  NAND2BX1 U3010 ( .AN(WBLQRdData[3]), .B(WBLQRdData[0]), .Y(n4853) );
  NAND2BX1 U3011 ( .AN(n5086), .B(n4987), .Y(n4876) );
  NAND2X1 U3012 ( .A(n4978), .B(n4884), .Y(n4983) );
  NOR2X1 X0_2_3 ( .A(n5084), .B(n1089_29_), .Y(pog_array) );
  OAI211X1 U3013 ( .A0(n4676), .A1(n4677), .B0(RBLQRdData[7]), .C0(n4678), .Y(
        n4657) );
  INVX1 U3014 ( .A(n4679), .Y(n4678) );
  AO21X1 U3015 ( .A0(n4857), .A1(n4827), .B0(n4858), .Y(n4855) );
  INVX1 U3016 ( .A(n4853), .Y(n4857) );
  NAND2X1 X0_1_3 ( .A(n5084), .B(n1089_29_), .Y(g_array) );
  INVX1 U3017 ( .A(n4856), .Y(n4848) );
  OAI222X1 U3018 ( .A0(n1107_30_), .A1(n4844), .B0(n4844), .B1(n4763), .C0(
        n1107_30_), .C1(n4763), .Y(n4856) );
  INVX1 U3019 ( .A(n4912), .Y(n4939) );
  OR4X1 U3020 ( .A(n4784), .B(n4785), .C(n4786), .D(n4787), .Y(n4764) );
  NAND4BX1 U3021 ( .AN(n4790), .B(n4791), .C(n4792), .D(n4793), .Y(n4786) );
  OR4X1 U3022 ( .A(a1130_26_), .B(a1130_13_), .C(a1130_20_), .D(a1130_19_), 
        .Y(n4784) );
  OR4X1 U3023 ( .A(a1130_13_), .B(a1130_12_), .C(a1130_15_), .D(a1130_14_), 
        .Y(n4785) );
  AOI33X1 U3024 ( .A0(n4722), .A1(n4847), .A2(n4848), .B0(n1107_29_), .B1(
        n4761), .B2(n4848), .Y(n4846) );
  AOI33X1 U3025 ( .A0(n4720), .A1(n4843), .A2(n4844), .B0(n1107_30_), .B1(
        n4763), .B2(n4844), .Y(n4842) );
  AOI33X1 U3026 ( .A0(n1107_31_), .A1(n4718), .A2(n4839), .B0(n4762), .B1(
        n4840), .B2(n4839), .Y(n4838) );
  NAND2X1 U3027 ( .A(n5173), .B(n4884), .Y(n4929) );
  XNOR2X1 U3028 ( .A(n4907), .B(n4940), .Y(n5173) );
  AO22X1 U3029 ( .A0(n4714), .A1(WrWrapAddrSt_3_), .B0(n4722), .B1(n_984), .Y(
        n4285) );
  AO22X1 U3030 ( .A0(n4714), .A1(WrWrapAddrSt_1_), .B0(n4718), .B1(n_984), .Y(
        n4287) );
  AO22X1 U3031 ( .A0(n4714), .A1(WrWrapAddrSt_2_), .B0(n4720), .B1(n_984), .Y(
        n4286) );
  AO22X1 U3032 ( .A0(n4714), .A1(WrWrapAddrSt_0_), .B0(n_984), .B1(n4716), .Y(
        n4288) );
  INVX1 U3033 ( .A(n4863), .Y(n4716) );
  INVX1 U3034 ( .A(WBLQRdData[0]), .Y(n4820) );
  INVX1 U3035 ( .A(n4997), .Y(n4995) );
  INVX1 U3036 ( .A(n4996), .Y(n5008) );
  INVX1 U3037 ( .A(n5045), .Y(n5027) );
  INVX1 U3038 ( .A(n5048), .Y(n5032) );
  INVX1 U3039 ( .A(n4762), .Y(n4718) );
  INVX1 U3040 ( .A(WBLQRdData[2]), .Y(n4827) );
  INVX1 U3041 ( .A(n5007), .Y(n4974) );
  NAND2BX1 U3042 ( .AN(n5179), .B(n5008), .Y(n5007) );
  INVX1 U3043 ( .A(n4994), .Y(n4962) );
  NAND2BX1 U3044 ( .AN(n5178), .B(n4995), .Y(n4994) );
  INVX1 U3045 ( .A(n4905), .Y(n4911) );
  INVX1 U3046 ( .A(n4956), .Y(n4950) );
  INVX1 U3047 ( .A(n4957), .Y(n4937) );
  OR2X1 U3048 ( .A(n5086), .B(n4987), .Y(n4870) );
  INVX1 U3049 ( .A(n4859), .Y(n4844) );
  OAI222X1 U3050 ( .A0(n1107_31_), .A1(n4860), .B0(n4762), .B1(n4860), .C0(
        n1107_31_), .C1(n4762), .Y(n4859) );
  INVX1 U3051 ( .A(n4852), .Y(n4849) );
  OAI222X1 U3052 ( .A0(n1107_29_), .A1(n4848), .B0(n4848), .B1(n4761), .C0(
        n1107_29_), .C1(n4761), .Y(n4852) );
  NAND2BX1 U3053 ( .AN(RQRead), .B(n4567), .Y(n4551) );
  NAND3BX1 U3054 ( .AN(n4635), .B(n5162), .C(n5113), .Y(n4634) );
  XOR2X1 U3055 ( .A(n5149), .B(a1130_3_), .Y(n4793) );
  XOR2X1 U0_5_2 ( .A(part_diff_2_), .B(n5110), .Y(a1130_3_) );
  NAND2BX1 U0_3_2 ( .AN(pog_array0), .B(g_array0), .Y(part_diff_2_) );
  XOR2X1 U3056 ( .A(n5150), .B(a1130_2_), .Y(n4791) );
  XOR2X1 U0_5_1 ( .A(part_diff_1_), .B(g_array9), .Y(a1130_2_) );
  NAND2BX1 U0_3_1 ( .AN(pog_array1), .B(g_array1), .Y(part_diff_1_) );
  NAND3BX1 U3057 ( .AN(n5180), .B(n4668), .C(n4692), .Y(n4693) );
  NOR2X1 X0_2_1 ( .A(n5088), .B(n1089_31_), .Y(pog_array1) );
  NAND2X1 U3058 ( .A(n4668), .B(n4568), .Y(n4692) );
  NAND2X1 U3059 ( .A(n5028), .B(n5027), .Y(n5019) );
  NAND2X1 U3060 ( .A(n5033), .B(n5032), .Y(n5023) );
  NAND2BX1 U3061 ( .AN(n5178), .B(n4967), .Y(n4938) );
  NAND2BX1 U3062 ( .AN(n5179), .B(n4978), .Y(n4951) );
  NAND2BX1 U3063 ( .AN(n4662), .B(n4567), .Y(n4632) );
  NAND2X1 X0_1_1 ( .A(n5088), .B(n1089_31_), .Y(g_array1) );
  INVX1 U3064 ( .A(n4999), .Y(BA_PM) );
  NAND2BX1 U3065 ( .AN(n5085), .B(n4884), .Y(n4999) );
  AND2X2 U3066 ( .A(n4662), .B(n4567), .Y(n5174) );
  NOR2X1 X0_2_2 ( .A(n5098), .B(n1089_30_), .Y(pog_array0) );
  AO21X1 U3067 ( .A0(n4863), .A1(n4820), .B0(n4839), .Y(n4733) );
  NAND2X1 X0_1_2 ( .A(n5098), .B(n1089_30_), .Y(g_array0) );
  NOR2X1 X0_2_0 ( .A(n5100), .B(n5127), .Y(pog_array2) );
  NAND2X1 X0_1_0 ( .A(n5100), .B(n5127), .Y(g_array2) );
  INVX1 U3068 ( .A(n22), .Y(carry22) );
  INVX1 U3069 ( .A(n4908), .Y(n4940) );
  INVX1 U3070 ( .A(n4763), .Y(n4720) );
  OAI32X1 U3071 ( .A0(n4632), .A1(n5162), .A2(n5113), .B0(n4588), .B1(n4634), 
        .Y(n4631) );
  INVX1 U3072 ( .A(n4928), .Y(n4942) );
  AO21X1 U3073 ( .A0(n5174), .A1(n4651), .B0(n4642), .Y(n4650) );
  INVX1 U3074 ( .A(n1), .Y(n4651) );
  OAI211X1 U3075 ( .A0(n4551), .A1(n5132), .B0(n4553), .C0(n4554), .Y(n4376)
         );
  OAI211X1 U3076 ( .A0(n4695), .A1(n5151), .B0(n4696), .C0(n4557), .Y(n4355)
         );
  INVX1 U3077 ( .A(n4697), .Y(n4695) );
  INVX1 U3078 ( .A(n4761), .Y(n4722) );
  INVX1 U3079 ( .A(WBLQRdData[1]), .Y(n4824) );
  INVX1 U3080 ( .A(n4926), .Y(n4923) );
  INVX1 U3081 ( .A(n4918), .Y(n4915) );
  OAI211X1 U3082 ( .A0(n4555), .A1(n5136), .B0(n4557), .C0(n4558), .Y(n4375)
         );
  INVX1 U3083 ( .A(n4559), .Y(n4555) );
  INVX1 U3084 ( .A(n4622), .Y(n4635) );
  INVX1 U3085 ( .A(RQEmpty), .Y(n4898) );
  XOR2X1 U3086 ( .A(n15), .B(n5109), .Y(a1130_5_) );
  XOR2X1 U3087 ( .A(n5148), .B(n4617), .Y(n4615) );
  XOR2X1 U3088 ( .A(n5147), .B(n4608), .Y(n4606) );
  AO22X1 U3089 ( .A0(n5181), .A1(n5192), .B0(n4902), .B1(n5182), .Y(BA_AA[2])
         );
  NAND4BX1 U3090 ( .AN(WrWrapAddrSt_0_), .B(n5088), .C(n5084), .D(n5098), .Y(
        n4789) );
  AO22X1 U3091 ( .A0(n5192), .A1(n4965), .B0(n4902), .B1(n4976), .Y(BA_AA[1])
         );
  XOR2X1 U3092 ( .A(n5095), .B(n4534), .Y(n4380) );
  AO22X1 U3093 ( .A0(n4995), .A1(n5192), .B0(n4902), .B1(n5008), .Y(BA_AA[0])
         );
  AO22X1 U3094 ( .A0(n5192), .A1(n4926), .B0(n4902), .B1(n4918), .Y(BA_AA[3])
         );
  INVX1 U3095 ( .A(n4550), .Y(RLast) );
  INVX1 U3096 ( .A(n4967), .Y(n4985) );
  INVX1 U3097 ( .A(n4959), .Y(n4958) );
  INVX1 U3098 ( .A(n16), .Y(n4753) );
  INVX1 U3099 ( .A(n4867), .Y(RValid) );
  NAND2BX1 U3100 ( .AN(n5114), .B(n4879), .Y(n4882) );
  INVX1 U3101 ( .A(n4597), .Y(n4599) );
  INVX1 U3102 ( .A(n4581), .Y(n4579) );
  INVX1 U3103 ( .A(BA_STS[3]), .Y(AckMem251) );
  DFFRX1 iDelayReadFlag_reg ( .D(n5191), .CK(ACLK), .RN(ARESETB), .Q(
        iDelayReadFlag) );
  NAND2BX1 U3104 ( .AN(n4881), .B(AWValid), .Y(n5186) );
  NAND2BX1 U3105 ( .AN(n4881), .B(AWValid), .Y(n5187) );
  INVX1 U3106 ( .A(n37), .Y(carry) );
  INVX1 U3107 ( .A(n21), .Y(carry_12_) );
  INVX1 U3108 ( .A(n32), .Y(carry_11_) );
  INVX1 U3109 ( .A(n44), .Y(carry0) );
  INVX1 U3110 ( .A(n41), .Y(carry_10_) );
  INVX1 U3111 ( .A(n55), .Y(carry1) );
  INVX1 U3112 ( .A(n9), .Y(carry25) );
  INVX1 U3113 ( .A(n101), .Y(carry6) );
  INVX1 U3114 ( .A(n10), .Y(carry26) );
  INVX1 U3115 ( .A(n112), .Y(carry7) );
  INVX1 U3116 ( .A(n51), .Y(carry_9_) );
  INVX1 U3117 ( .A(n63), .Y(carry2) );
  INVX1 U3118 ( .A(n71), .Y(carry_7_) );
  INVX1 U3119 ( .A(n82), .Y(carry4) );
  INVX1 U3120 ( .A(n12), .Y(carry28) );
  INVX1 U3121 ( .A(n131), .Y(carry9) );
  INVX1 U3122 ( .A(n61), .Y(carry_8_) );
  INVX1 U3123 ( .A(n73), .Y(carry3) );
  INVX1 U3124 ( .A(n8), .Y(carry24) );
  INVX1 U3125 ( .A(n92), .Y(carry5) );
  INVX1 U3126 ( .A(n111), .Y(carry27) );
  INVX1 U3127 ( .A(n121), .Y(carry8) );
  NAND2BX1 U3128 ( .AN(n4862), .B(WLast), .Y(n4873) );
  NAND2BX1 U3129 ( .AN(n4864), .B(WValid), .Y(n4862) );
  OAI221X1 U3130 ( .A0(n5119), .A1(n4953), .B0(n5090), .B1(n5086), .C0(n5052), 
        .Y(BA_AA[19]) );
  AOI22X1 U3131 ( .A0(WSpi2Addr_19_), .A1(n4941), .B0(RSpi2Addr_19_), .B1(
        n4939), .Y(n5052) );
  OAI221X1 U3132 ( .A0(n5137), .A1(n4953), .B0(n5101), .B1(n5086), .C0(n5043), 
        .Y(BA_AA[20]) );
  AOI22X1 U3133 ( .A0(WSpi2Addr_20_), .A1(n4941), .B0(RSpi2Addr_20_), .B1(
        n4939), .Y(n5043) );
  OAI211X1 U3134 ( .A0(n5118), .A1(n4953), .B0(n5035), .C0(n5036), .Y(
        BA_AA[21]) );
  AOI32X1 U3135 ( .A0(n11), .A1(ReadLatAA_21_), .A2(n4939), .B0(n5192), .B1(
        WriteLatAA_21_), .Y(n5035) );
  AOI31X1 U3136 ( .A0(n5118), .A1(n5037), .A2(n4939), .B0(n5038), .Y(n5036) );
  AO22X1 U3137 ( .A0(WriteLatBB[1]), .A1(n5186), .B0(AWBurst[1]), .B1(n4836), 
        .Y(n4231) );
  AO22X1 U3138 ( .A0(WriteLatBB[0]), .A1(n4835), .B0(AWBurst[0]), .B1(n4836), 
        .Y(n4232) );
  AO22X1 U3139 ( .A0(WriteLatAA_21_), .A1(n5187), .B0(AWAddr[21]), .B1(n4836), 
        .Y(n4233) );
  AO22X1 U3140 ( .A0(WriteLatAA_20_), .A1(n5186), .B0(AWAddr[20]), .B1(n4836), 
        .Y(n4234) );
  AO22X1 U3141 ( .A0(WriteLatAA_19_), .A1(n4835), .B0(AWAddr[19]), .B1(n4836), 
        .Y(n4235) );
  AO22X1 U3142 ( .A0(WriteLatAA_18_), .A1(n5187), .B0(AWAddr[18]), .B1(n4836), 
        .Y(n4236) );
  AO22X1 U3143 ( .A0(WriteLatAA_17_), .A1(n5186), .B0(AWAddr[17]), .B1(n4836), 
        .Y(n4237) );
  AO22X1 U3144 ( .A0(WriteLatAA_16_), .A1(n4835), .B0(AWAddr[16]), .B1(n4836), 
        .Y(n4238) );
  AO22X1 U3145 ( .A0(WriteLatAA_15_), .A1(n5187), .B0(AWAddr[15]), .B1(n4836), 
        .Y(n4239) );
  AO22X1 U3146 ( .A0(WriteLatAA_14_), .A1(n5186), .B0(AWAddr[14]), .B1(n4836), 
        .Y(n4240) );
  AO22X1 U3147 ( .A0(WriteLatAA_13_), .A1(n4835), .B0(AWAddr[13]), .B1(n4836), 
        .Y(n4241) );
  AO22X1 U3148 ( .A0(WriteLatAA_12_), .A1(n5187), .B0(AWAddr[12]), .B1(n4836), 
        .Y(n4242) );
  AO22X1 U3149 ( .A0(WriteLatAA_11_), .A1(n5186), .B0(AWAddr[11]), .B1(n4836), 
        .Y(n4243) );
  AO22X1 U3150 ( .A0(WriteLatAA_10_), .A1(n4835), .B0(AWAddr[10]), .B1(n4836), 
        .Y(n4244) );
  AO22X1 U3151 ( .A0(WriteLatAA_9_), .A1(n5187), .B0(AWAddr[9]), .B1(n4836), 
        .Y(n4245) );
  AO22X1 U3152 ( .A0(WriteLatAA_8_), .A1(n5186), .B0(AWAddr[8]), .B1(n4836), 
        .Y(n4246) );
  AO22X1 U3153 ( .A0(WriteLatAA_7_), .A1(n4835), .B0(AWAddr[7]), .B1(n4836), 
        .Y(n4247) );
  AO22X1 U3154 ( .A0(WriteLatAA_6_), .A1(n5187), .B0(AWAddr[6]), .B1(n4836), 
        .Y(n4248) );
  AO22X1 U3155 ( .A0(WriteLatAA_5_), .A1(n5186), .B0(AWAddr[5]), .B1(n4836), 
        .Y(n4249) );
  AO22X1 U3156 ( .A0(WriteLatAA_4_), .A1(n4835), .B0(AWAddr[4]), .B1(n4836), 
        .Y(n4250) );
  AO22X1 U3157 ( .A0(WriteLatA0_3_), .A1(n5186), .B0(AWAddr[3]), .B1(n4836), 
        .Y(n4251) );
  AO22X1 U3158 ( .A0(WriteLatA0_2_), .A1(n5186), .B0(AWAddr[2]), .B1(n4836), 
        .Y(n4252) );
  AO22X1 U3159 ( .A0(WriteLatA0_1_), .A1(n4835), .B0(AWAddr[1]), .B1(n4836), 
        .Y(n4253) );
  AO22X1 U3160 ( .A0(WriteLatA0_0_), .A1(n4835), .B0(AWAddr[0]), .B1(n4836), 
        .Y(n4254) );
  AO22X1 U3161 ( .A0(WriteLatTT[3]), .A1(n5186), .B0(AWLen[3]), .B1(n4836), 
        .Y(n4255) );
  AO22X1 U3162 ( .A0(WriteLatTT[2]), .A1(n4835), .B0(AWLen[2]), .B1(n4836), 
        .Y(n4256) );
  AO22X1 U3163 ( .A0(WriteLatTT[1]), .A1(n5186), .B0(AWLen[1]), .B1(n4836), 
        .Y(n4257) );
  AO22X1 U3164 ( .A0(WriteLatTT[0]), .A1(n5186), .B0(AWLen[0]), .B1(n4836), 
        .Y(n4258) );
  AO22X1 U3165 ( .A0(ReadLatAA_21_), .A1(n4713), .B0(ARAddr[21]), .B1(n_1928), 
        .Y(n4291) );
  AO22X1 U3166 ( .A0(ReadLatAA_20_), .A1(n5185), .B0(ARAddr[20]), .B1(n_1928), 
        .Y(n4292) );
  AO22X1 U3167 ( .A0(ReadLatAA_19_), .A1(n5184), .B0(ARAddr[19]), .B1(n_1928), 
        .Y(n4293) );
  AO22X1 U3168 ( .A0(ReadLatAA_18_), .A1(n4713), .B0(ARAddr[18]), .B1(n_1928), 
        .Y(n4294) );
  AO22X1 U3169 ( .A0(ReadLatAA_17_), .A1(n5185), .B0(ARAddr[17]), .B1(n_1928), 
        .Y(n4295) );
  AO22X1 U3170 ( .A0(ReadLatAA_16_), .A1(n5184), .B0(ARAddr[16]), .B1(n_1928), 
        .Y(n4296) );
  AO22X1 U3171 ( .A0(ReadLatAA_15_), .A1(n4713), .B0(ARAddr[15]), .B1(n_1928), 
        .Y(n4297) );
  AO22X1 U3172 ( .A0(ReadLatAA_14_), .A1(n5185), .B0(ARAddr[14]), .B1(n_1928), 
        .Y(n4298) );
  AO22X1 U3173 ( .A0(ReadLatAA_13_), .A1(n5184), .B0(ARAddr[13]), .B1(n_1928), 
        .Y(n4299) );
  AO22X1 U3174 ( .A0(ReadLatAA_12_), .A1(n4713), .B0(ARAddr[12]), .B1(n_1928), 
        .Y(n4300) );
  AO22X1 U3175 ( .A0(ReadLatAA_11_), .A1(n5185), .B0(ARAddr[11]), .B1(n_1928), 
        .Y(n4301) );
  AO22X1 U3176 ( .A0(ReadLatAA_10_), .A1(n5184), .B0(ARAddr[10]), .B1(n_1928), 
        .Y(n4302) );
  AO22X1 U3177 ( .A0(ReadLatAA_9_), .A1(n5185), .B0(ARAddr[9]), .B1(n_1928), 
        .Y(n4303) );
  AO22X1 U3178 ( .A0(ReadLatAA_8_), .A1(n5185), .B0(ARAddr[8]), .B1(n_1928), 
        .Y(n4304) );
  AO22X1 U3179 ( .A0(ReadLatAA_7_), .A1(n5184), .B0(ARAddr[7]), .B1(n_1928), 
        .Y(n4305) );
  AO22X1 U3180 ( .A0(ReadLatAA_6_), .A1(n5184), .B0(ARAddr[6]), .B1(n_1928), 
        .Y(n4306) );
  AO22X1 U3181 ( .A0(ReadLatAA_5_), .A1(n5185), .B0(ARAddr[5]), .B1(n_1928), 
        .Y(n4307) );
  AO22X1 U3182 ( .A0(ReadLatAA_4_), .A1(n5184), .B0(ARAddr[4]), .B1(n_1928), 
        .Y(n4308) );
  AO22X1 U3183 ( .A0(ReadReqID[3]), .A1(n5184), .B0(ARId[3]), .B1(n_1928), .Y(
        n4317) );
  AO22X1 U3184 ( .A0(ReadReqID[2]), .A1(n5184), .B0(ARId[2]), .B1(n_1928), .Y(
        n4318) );
  AO22X1 U3185 ( .A0(ReadReqID[1]), .A1(n5185), .B0(ARId[1]), .B1(n_1928), .Y(
        n4319) );
  AO22X1 U3186 ( .A0(ReadReqID[0]), .A1(n5184), .B0(ARId[0]), .B1(n_1928), .Y(
        n4320) );
  AO22X1 U3187 ( .A0(WriteReqID[3]), .A1(n4835), .B0(AWId[3]), .B1(n4836), .Y(
        n4259) );
  AO22X1 U3188 ( .A0(WriteReqID[2]), .A1(n4835), .B0(AWId[2]), .B1(n4836), .Y(
        n4260) );
  AO22X1 U3189 ( .A0(WriteReqID[1]), .A1(n5186), .B0(AWId[1]), .B1(n4836), .Y(
        n4261) );
  AO22X1 U3190 ( .A0(WriteReqID[0]), .A1(n4835), .B0(AWId[0]), .B1(n4836), .Y(
        n4262) );
  AO22X1 U3191 ( .A0(BId[3]), .A1(n5186), .B0(AWId[3]), .B1(n4836), .Y(n4263)
         );
  AO22X1 U3192 ( .A0(BId[2]), .A1(n5186), .B0(AWId[2]), .B1(n4836), .Y(n4264)
         );
  AO22X1 U3193 ( .A0(BId[1]), .A1(n4835), .B0(AWId[1]), .B1(n4836), .Y(n4265)
         );
  AO22X1 U3194 ( .A0(BId[0]), .A1(n4835), .B0(AWId[0]), .B1(n4836), .Y(n4266)
         );
  AO22X1 U3195 ( .A0(ReadLatBB[1]), .A1(n5185), .B0(ARBurst[1]), .B1(n_1928), 
        .Y(n4289) );
  AO22X1 U3196 ( .A0(ReadLatBB[0]), .A1(n5184), .B0(ARBurst[0]), .B1(n_1928), 
        .Y(n4290) );
  AO22X1 U3197 ( .A0(ReadLatA0_3_), .A1(n5185), .B0(ARAddr[3]), .B1(n_1928), 
        .Y(n4309) );
  AO22X1 U3198 ( .A0(ReadLatA0_2_), .A1(n5185), .B0(ARAddr[2]), .B1(n_1928), 
        .Y(n4310) );
  AO22X1 U3199 ( .A0(ReadLatA0_1_), .A1(n5184), .B0(ARAddr[1]), .B1(n_1928), 
        .Y(n4311) );
  AO22X1 U3200 ( .A0(ReadLatA0_0_), .A1(n5184), .B0(ARAddr[0]), .B1(n_1928), 
        .Y(n4312) );
  AO22X1 U3201 ( .A0(ReadLatTT[3]), .A1(n5185), .B0(ARLen[3]), .B1(n_1928), 
        .Y(n4313) );
  AO22X1 U3202 ( .A0(ReadLatTT[2]), .A1(n5184), .B0(ARLen[2]), .B1(n_1928), 
        .Y(n4314) );
  AO22X1 U3203 ( .A0(ReadLatTT[1]), .A1(n5185), .B0(ARLen[1]), .B1(n_1928), 
        .Y(n4315) );
  AO22X1 U3204 ( .A0(ReadLatTT[0]), .A1(n5185), .B0(ARLen[0]), .B1(n_1928), 
        .Y(n4316) );
  OAI33X1 U3205 ( .A0(n4910), .A1(n5126), .A2(n5040), .B0(n4910), .B1(n26), 
        .B2(WriteLatAA_21_), .Y(n5038) );
  INVX1 U3206 ( .A(n26), .Y(n5040) );
  OAI32X1 U3207 ( .A0(n4836), .A1(WriteAck), .A2(n5116), .B0(n5114), .B1(n4870), .Y(NxtStW[4]) );
  OAI31X1 U3208 ( .A0(n4884), .A1(n4882), .A2(n5085), .B0(n4886), .Y(NxtStR[0]) );
  AOI32X1 U3209 ( .A0(n5089), .A1(n5117), .A2(n5085), .B0(tRRSpi), .B1(n4883), 
        .Y(n4888) );
  AO21X1 U3210 ( .A0(tRRReq), .A1(n4882), .B0(n_1928), .Y(NxtStR[1]) );
  AO21X1 U3211 ( .A0(tWWDat), .A1(n4873), .B0(n4836), .Y(NxtStW[1]) );
  OAI21X1 U3212 ( .A0(n5175), .A1(BReady), .B0(n4873), .Y(NxtStW[2]) );
  OAI221X1 U3213 ( .A0(n4836), .A1(n5158), .B0(n5114), .B1(n4876), .C0(n4877), 
        .Y(NxtStW[0]) );
  AOI33X1 U3214 ( .A0(n4878), .A1(n5158), .A2(n4879), .B0(WriteAck), .B1(
        tWWSpi), .B2(n5186), .Y(n4877) );
  NOR2BX1 U3215 ( .AN(n5175), .B(tWWDat), .Y(n4878) );
  NAND2BX1 U3216 ( .AN(WQEmpty), .B(BA_STS[0]), .Y(n4726) );
  NAND2BX1 U3217 ( .AN(n4881), .B(AWValid), .Y(n4835) );
  NAND2BX1 U3218 ( .AN(n4890), .B(ARValid), .Y(n5185) );
  NAND2BX1 U3219 ( .AN(n4890), .B(ARValid), .Y(n5184) );
  NAND4BX1 U3220 ( .AN(WQFull), .B(n4874), .C(tWWDat), .D(WriteAck), .Y(n4864)
         );
  INVX1 U3221 ( .A(WBLQFull), .Y(n4874) );
  NAND3BX1 U3222 ( .AN(tRRSpi), .B(n5085), .C(n4879), .Y(BA_REQ) );
  OR4X1 U3223 ( .A(WBurstCnt[0]), .B(WBLQEmpty), .C(n4834), .D(n4726), .Y(
        n4714) );
  NAND3BX1 U3224 ( .AN(WBurstCnt[3]), .B(n5099), .C(n5133), .Y(n4834) );
  NAND2BX1 U3225 ( .AN(RQEmpty), .B(tRDReq), .Y(n4867) );
  NAND2BX1 U3226 ( .AN(n4627), .B(RQIncAddr[5]), .Y(n4637) );
  NAND2BX1 U3227 ( .AN(WBurstCnt[1]), .B(n5176), .Y(n4828) );
  OAI222X1 U3228 ( .A0(RQIncAddr[3]), .A1(n4613), .B0(n4573), .B1(n4613), .C0(
        RQIncAddr[3]), .C1(n4573), .Y(n4618) );
  AO21X1 U3229 ( .A0(n4816), .A1(WBLCnt[1]), .B0(n4811), .Y(n4813) );
  OAI2BB1X1 U3230 ( .A0N(n4816), .A1N(WBLCnt[0]), .B0(n4807), .Y(n4811) );
  OAI221X1 U3231 ( .A0(n5120), .A1(n4953), .B0(n5102), .B1(n5086), .C0(n5064), 
        .Y(BA_AA[15]) );
  AOI22X1 U3232 ( .A0(WSpi2Addr_15_), .A1(n4941), .B0(RSpi2Addr_15_), .B1(
        n4939), .Y(n5064) );
  OAI221X1 U3233 ( .A0(n5121), .A1(n4953), .B0(n5091), .B1(n5086), .C0(n5067), 
        .Y(BA_AA[14]) );
  AOI22X1 U3234 ( .A0(WSpi2Addr_14_), .A1(n4941), .B0(RSpi2Addr_14_), .B1(
        n4939), .Y(n5067) );
  OR4X1 U3235 ( .A(BA_STS[4]), .B(n5089), .C(RQHFull), .D(RBLQFull), .Y(n4890)
         );
  OAI2BB2X1 U3236 ( .A0N(WrWrapCnt[4]), .A1N(n4748), .B0(n4747), .B1(n4726), 
        .Y(n4280) );
  AOI211X1 U3237 ( .A0(WQIncAddr[4]), .A1(n4740), .B0(n4749), .C0(n4750), .Y(
        n4747) );
  AO22X1 U3238 ( .A0(WrWrapCnt1083_4_), .A1(n4739), .B0(WrWrapCnt1104_4_), 
        .B1(n4732), .Y(n4749) );
  NAND3BX1 U3239 ( .AN(WBLCnt[1]), .B(n5160), .C(n4816), .Y(n4810) );
  BUFX2 U3240 ( .A(tWWReq), .Y(n5192) );
  OR2X1 U3241 ( .A(WBurstCnt[1]), .B(n4819), .Y(n4823) );
  OAI221X1 U3242 ( .A0(n5138), .A1(n4953), .B0(n5103), .B1(n5086), .C0(n5055), 
        .Y(BA_AA[18]) );
  AOI22X1 U3243 ( .A0(WSpi2Addr_18_), .A1(n4941), .B0(RSpi2Addr_18_), .B1(
        n4939), .Y(n5055) );
  OAI221X1 U3244 ( .A0(n5122), .A1(n4953), .B0(n5092), .B1(n5086), .C0(n5058), 
        .Y(BA_AA[17]) );
  AOI22X1 U3245 ( .A0(WSpi2Addr_17_), .A1(n4941), .B0(RSpi2Addr_17_), .B1(
        n4939), .Y(n5058) );
  OAI221X1 U3246 ( .A0(n5139), .A1(n4953), .B0(n5104), .B1(n5086), .C0(n5061), 
        .Y(BA_AA[16]) );
  AOI22X1 U3247 ( .A0(WSpi2Addr_16_), .A1(n4941), .B0(RSpi2Addr_16_), .B1(
        n4939), .Y(n5061) );
  AO22X1 U3248 ( .A0(n4750), .A1(n5165), .B0(WrWrapCnt1104_5_), .B1(n4732), 
        .Y(n4757) );
  XOR3X1 U1_5 ( .A(WQIncAddr[5]), .B(n1105_27_), .C(carry18), .Y(
        WrWrapCnt1104_5_) );
  INVX1 U3249 ( .A(n14), .Y(carry18) );
  AO22X1 U3250 ( .A0(n746_0_), .A1(n4751), .B0(WrWrapCnt[5]), .B1(n4752), .Y(
        n4279) );
  NAND2BX1 U3251 ( .AN(n4757), .B(n4758), .Y(n4751) );
  OAI221X1 U3252 ( .A0(n4734), .A1(n4753), .B0(n4735), .B1(n5163), .C0(n4755), 
        .Y(n4752) );
  AOI32X1 U3253 ( .A0(n5165), .A1(n4753), .A2(n4739), .B0(WQIncAddr[5]), .B1(
        n4740), .Y(n4758) );
  AO22X1 U3254 ( .A0(n5192), .A1(n5114), .B0(BValid), .B1(BReady), .Y(
        NxtStW[3]) );
  OAI2BB1X1 U3255 ( .A0N(n746_0_), .A1N(n4723), .B0(n4724), .Y(n4284) );
  OAI211X1 U3256 ( .A0(n4727), .A1(n4728), .B0(n4729), .C0(n4730), .Y(n4723)
         );
  OA22X1 U3257 ( .A0(WrWrapCnt[0]), .A1(n4734), .B0(carry12), .B1(n4735), .Y(
        n4729) );
  OAI221X1 U3258 ( .A0(n4825), .A1(n5099), .B0(WBurstCnt[2]), .B1(n4823), .C0(
        n4804), .Y(n4268) );
  INVX1 U3259 ( .A(n4828), .Y(n4825) );
  OAI221X1 U3260 ( .A0(WBLCnt[2]), .A1(n4810), .B0(n4812), .B1(n5149), .C0(
        n4804), .Y(n4272) );
  INVX1 U3261 ( .A(n4813), .Y(n4812) );
  OAI221X1 U3262 ( .A0(n5160), .A1(n4807), .B0(WBLCnt[0]), .B1(n4808), .C0(
        n4800), .Y(n4274) );
  AO21X1 U3263 ( .A0(WrWrapCnt[3]), .A1(n4726), .B0(n4744), .Y(n4281) );
  OA21X2 U3264 ( .A0(n4745), .A1(n4746), .B0(n746_0_), .Y(n4744) );
  AO22X1 U3265 ( .A0(WrWrapCnt1104_3_), .A1(n4732), .B0(WQIncAddr[3]), .B1(
        n4740), .Y(n4745) );
  AO22X1 U3266 ( .A0(WrWrapCnt1080_3_), .A1(n4725), .B0(WrWrapCnt1083_3_), 
        .B1(n4739), .Y(n4746) );
  AO21X1 U3267 ( .A0(WrWrapCnt[2]), .A1(n4726), .B0(n4741), .Y(n4282) );
  OA21X2 U3268 ( .A0(n4742), .A1(n4743), .B0(n746_0_), .Y(n4741) );
  AO22X1 U3269 ( .A0(WrWrapCnt1104_2_), .A1(n4732), .B0(WQIncAddr[2]), .B1(
        n4740), .Y(n4742) );
  AO22X1 U3270 ( .A0(WrWrapCnt1080_2_), .A1(n4725), .B0(WrWrapCnt1083_2_), 
        .B1(n4739), .Y(n4743) );
  AO21X1 U3271 ( .A0(WrWrapCnt[1]), .A1(n4726), .B0(n4736), .Y(n4283) );
  OA21X2 U3272 ( .A0(n4737), .A1(n4738), .B0(n746_0_), .Y(n4736) );
  AO22X1 U3273 ( .A0(WrWrapCnt1104_1_), .A1(n4732), .B0(WQIncAddr[1]), .B1(
        n4740), .Y(n4737) );
  AO22X1 U3274 ( .A0(WrWrapCnt1080_1_), .A1(n4725), .B0(WrWrapCnt1083_1_), 
        .B1(n4739), .Y(n4738) );
  OAI2BB1X1 U3275 ( .A0N(n4714), .A1N(LatchedWBL_0_), .B0(n4800), .Y(n4278) );
  AO21X1 U3276 ( .A0(n4714), .A1(LatchedWBL_3_), .B0(n5172), .Y(n4275) );
  OAI2BB1X1 U3277 ( .A0N(n4714), .A1N(LatchedWBL_2_), .B0(n4804), .Y(n4276) );
  OAI2BB1X1 U3278 ( .A0N(n4714), .A1N(LatchedWBL_1_), .B0(n4802), .Y(n4277) );
  AO21X1 U3279 ( .A0(WBLCnt[3]), .A1(n4813), .B0(n4814), .Y(n4271) );
  OAI31X1 U3280 ( .A0(n4810), .A1(WBLCnt[3]), .A2(WBLCnt[2]), .B0(n4815), .Y(
        n4814) );
  AOI31X1 U3281 ( .A0(WBLCnt[3]), .A1(WBLCnt[2]), .A2(n4816), .B0(n5172), .Y(
        n4815) );
  OAI31X1 U3282 ( .A0(n4823), .A1(WBurstCnt[3]), .A2(WBurstCnt[2]), .B0(n4829), 
        .Y(n4267) );
  AOI221X1 U3283 ( .A0(WBurstCnt[3]), .A1(WBurstCnt[2]), .B0(WBurstCnt[3]), 
        .B1(n4828), .C0(n5172), .Y(n4829) );
  OAI211X1 U3284 ( .A0(tWWSpi), .A1(tWIdle), .B0(n5082), .C0(n5083), .Y(n4881)
         );
  INVX1 U3285 ( .A(WQFull), .Y(n5083) );
  INVX1 U3286 ( .A(BA_STS[4]), .Y(n5082) );
  OAI211X1 U3287 ( .A0(n4637), .A1(n4638), .B0(n4639), .C0(n4640), .Y(n4362)
         );
  NAND2BX1 U3288 ( .AN(n4625), .B(n4644), .Y(n4638) );
  AOI32X1 U3289 ( .A0(n4583), .A1(RQIncAddr[6]), .A2(n4637), .B0(
        RdWrapCnt2357_6_), .B1(n4598), .Y(n4640) );
  OAI211X1 U3290 ( .A0(n4645), .A1(n4646), .B0(n4647), .C0(n4648), .Y(n4361)
         );
  NAND2BX1 U3291 ( .AN(n4625), .B(n4655), .Y(n4646) );
  OA22X1 U3292 ( .A0(n4654), .A1(n5164), .B0(n4585), .B1(n4655), .Y(n4647) );
  AOI33X1 U3293 ( .A0(n4551), .A1(n5164), .A2(n4650), .B0(n4583), .B1(
        RQIncAddr[7]), .B2(n4645), .Y(n4648) );
  OAI211X1 U3294 ( .A0(n4627), .A1(n4628), .B0(n4629), .C0(n4630), .Y(n4363)
         );
  NAND2BX1 U3295 ( .AN(n4625), .B(n4636), .Y(n4628) );
  AOI31X1 U3296 ( .A0(n4583), .A1(RQIncAddr[5]), .A2(n4627), .B0(n4631), .Y(
        n4630) );
  AOI33X1 U3297 ( .A0(n4731), .A1(WQIncAddr[0]), .A2(n4732), .B0(n4733), .B1(
        n4727), .B2(n4732), .Y(n4730) );
  AND2X2 U3298 ( .A(n5177), .B(n746_0_), .Y(n5176) );
  INVX1 U3299 ( .A(n4684), .Y(n4604) );
  OAI222X1 U3300 ( .A0(RQIncAddr[1]), .A1(n4594), .B0(n4571), .B1(n4594), .C0(
        RQIncAddr[1]), .C1(n4571), .Y(n4684) );
  INVX1 U3301 ( .A(n4680), .Y(n4613) );
  OAI222X1 U3302 ( .A0(RQIncAddr[2]), .A1(n4604), .B0(n4572), .B1(n4604), .C0(
        RQIncAddr[2]), .C1(n4572), .Y(n4680) );
  INVX1 U3303 ( .A(WStrb[0]), .Y(WQWrData_32_) );
  INVX1 U3304 ( .A(WStrb[1]), .Y(WQWrData_33_) );
  INVX1 U3305 ( .A(WStrb[2]), .Y(WQWrData_34_) );
  INVX1 U3306 ( .A(WStrb[3]), .Y(WQWrData_35_) );
  INVX1 U3307 ( .A(n24), .Y(carry16) );
  AFHCONX2 U1_4 ( .A(WQIncAddr[4]), .B(n1105_28_), .CI(carry19), .S(
        WrWrapCnt1104_4_), .CON(n14) );
  INVX1 U3308 ( .A(n23), .Y(carry19) );
  AO21X1 U3309 ( .A0(n4849), .A1(n4850), .B0(n1105_27_), .Y(n1105_28_) );
  INVX1 U3310 ( .A(n13), .Y(n4850) );
  AFHCONX2 U1_3 ( .A(WQIncAddr[3]), .B(n1105_29_), .CI(carry20), .S(
        WrWrapCnt1104_3_), .CON(n23) );
  INVX1 U3311 ( .A(n34), .Y(carry20) );
  NAND2BX1 U3312 ( .AN(n4845), .B(n4846), .Y(n1105_29_) );
  OAI33X1 U3313 ( .A0(n4848), .A1(n1107_29_), .A2(n4722), .B0(n4848), .B1(
        n4847), .B2(n4761), .Y(n4845) );
  AFHCONX2 U1_2 ( .A(WQIncAddr[2]), .B(n1105_30_), .CI(carry21), .S(
        WrWrapCnt1104_2_), .CON(n34) );
  INVX1 U3314 ( .A(n42), .Y(carry21) );
  NAND2BX1 U3315 ( .AN(n4841), .B(n4842), .Y(n1105_30_) );
  OAI33X1 U3316 ( .A0(n4844), .A1(n1107_30_), .A2(n4720), .B0(n4844), .B1(
        n4843), .B2(n4763), .Y(n4841) );
  AFHCONX2 U1_1 ( .A(WQIncAddr[1]), .B(n1105_31_), .CI(carry_1_), .S(
        WrWrapCnt1104_1_), .CON(n42) );
  NOR2BX1 U3317 ( .AN(WQIncAddr[0]), .B(n4731), .Y(carry_1_) );
  NAND2BX1 U3318 ( .AN(n4837), .B(n4838), .Y(n1105_31_) );
  OAI33X1 U3319 ( .A0(n4839), .A1(n4840), .A2(n4718), .B0(n4762), .B1(
        n1107_31_), .B2(n4839), .Y(n4837) );
  NAND3BX1 U3320 ( .AN(n4919), .B(WriteLatTT[3]), .C(n4909), .Y(n4899) );
  OA22X1 U3321 ( .A0(n4909), .A1(n4910), .B0(n4911), .B1(n4912), .Y(n4900) );
  AOI32X1 U3322 ( .A0(ReadLatTT[3]), .A1(n4902), .A2(n4903), .B0(n4904), .B1(
        WriteLatTT[3]), .Y(n4901) );
  AOI33X1 U3323 ( .A0(n4967), .A1(n5178), .A2(n4934), .B0(WriteLatTT[0]), .B1(
        n4985), .B2(n4934), .Y(n4980) );
  AOI33X1 U3324 ( .A0(n4902), .A1(n5179), .A2(n4982), .B0(ReadLatTT[0]), .B1(
        n4902), .B2(n4983), .Y(n4981) );
  OAI222X1 U3325 ( .A0(n4967), .A1(n4910), .B0(n4978), .B1(n4912), .C0(n5178), 
        .C1(n4876), .Y(n4979) );
  NAND2BX1 U3326 ( .AN(ReadLatTT[2]), .B(n4902), .Y(n4930) );
  AOI222X1 U3327 ( .A0(n4904), .A1(WriteLatTT[2]), .B0(n4939), .B1(n4940), 
        .C0(n4941), .C1(n4942), .Y(n4931) );
  AOI32X1 U3328 ( .A0(ReadLatTT[2]), .A1(n4902), .A2(n4929), .B0(n4933), .B1(
        n4934), .Y(n4932) );
  AOI222X1 U3329 ( .A0(n4904), .A1(WriteLatTT[1]), .B0(n4939), .B1(n4956), 
        .C0(n4941), .C1(n4957), .Y(n4955) );
  OA21X2 U3330 ( .A0(n4884), .A1(n5096), .B0(n4969), .Y(n4952) );
  AOI33X1 U3331 ( .A0(n4958), .A1(n4957), .A2(n4934), .B0(n4959), .B1(n4937), 
        .B2(n4934), .Y(n4954) );
  INVX1 U3332 ( .A(n35), .Y(carry17) );
  NAND2BX1 U3333 ( .AN(n4855), .B(WBLQRdData[6]), .Y(n4763) );
  NOR2BX1 U3334 ( .AN(WBLQRdData[5]), .B(n4858), .Y(n4861) );
  OR3X2 U3335 ( .A(WriteLatTT[3]), .B(WriteLatTT[2]), .C(n5178), .Y(n5033) );
  OR3X2 U3336 ( .A(ReadLatTT[3]), .B(ReadLatTT[2]), .C(n5179), .Y(n5028) );
  NAND2BX1 U3337 ( .AN(n4913), .B(n4914), .Y(n4905) );
  OAI33X1 U3338 ( .A0(n4917), .A1(ReadLatTT[3]), .A2(n4915), .B0(n4917), .B1(
        n4918), .B2(n5112), .Y(n4913) );
  AOI33X1 U3339 ( .A0(n4915), .A1(n5112), .A2(n4917), .B0(ReadLatTT[3]), .B1(
        n4918), .B2(n4917), .Y(n4914) );
  NAND2BX1 U3340 ( .AN(ReadLatBB[0]), .B(ReadLatBB[1]), .Y(n5045) );
  NAND2BX1 U3341 ( .AN(WriteLatBB[0]), .B(WriteLatBB[1]), .Y(n5048) );
  NAND2BX1 U3342 ( .AN(tRRReq), .B(n5009), .Y(n4912) );
  NAND2X1 U3343 ( .A(ReadLatA0_0_), .B(n5045), .Y(n4996) );
  NAND2X1 U3344 ( .A(WriteLatA0_0_), .B(n5048), .Y(n4997) );
  OAI222X1 U3345 ( .A0(ReadLatTT[1]), .A1(n4974), .B0(n4974), .B1(n4976), .C0(
        ReadLatTT[1]), .C1(n4976), .Y(n4947) );
  OAI222X1 U3346 ( .A0(WriteLatTT[1]), .A1(n4962), .B0(n4962), .B1(n4965), 
        .C0(WriteLatTT[1]), .C1(n4965), .Y(n4944) );
  NAND2BX1 U3347 ( .AN(n4858), .B(WBLQRdData[4]), .Y(n4863) );
  OAI32X1 U3348 ( .A0(n5033), .A1(WriteLatTT[1]), .A2(n5128), .B0(n5032), .B1(
        n5128), .Y(n4965) );
  OAI32X1 U3349 ( .A0(n5028), .A1(ReadLatTT[1]), .A2(n5130), .B0(n5027), .B1(
        n5130), .Y(n4976) );
  OAI221X1 U3350 ( .A0(n4925), .A1(n4926), .B0(WriteLatTT[3]), .B1(n4925), 
        .C0(n4988), .Y(n4987) );
  AOI211X1 U3351 ( .A0(n4923), .A1(n5111), .B0(n4989), .C0(n5153), .Y(n4988)
         );
  NAND3BX1 U3352 ( .AN(n5155), .B(WriteLatAA_6_), .C(WriteLatAA_7_), .Y(n4989)
         );
  INVX1 U3353 ( .A(n5005), .Y(n4917) );
  OAI222X1 U3354 ( .A0(ReadLatTT[2]), .A1(n5006), .B0(n5182), .B1(n5006), .C0(
        ReadLatTT[2]), .C1(n5182), .Y(n5005) );
  INVX1 U3355 ( .A(n4947), .Y(n5006) );
  INVX1 U3356 ( .A(n4992), .Y(n4925) );
  OAI222X1 U3357 ( .A0(WriteLatTT[2]), .A1(n4993), .B0(n5181), .B1(n4993), 
        .C0(WriteLatTT[2]), .C1(n5181), .Y(n4992) );
  INVX1 U3358 ( .A(n4944), .Y(n4993) );
  NAND2BX1 U3359 ( .AN(WBLQRdData[8]), .B(WBLQRdData[9]), .Y(n4858) );
  OAI21X1 U3360 ( .A0(n4905), .A1(n4906), .B0(n4884), .Y(n4903) );
  OAI222X1 U3361 ( .A0(ReadLatTT[2]), .A1(n4907), .B0(n4907), .B1(n4908), .C0(
        ReadLatTT[2]), .C1(n4908), .Y(n4906) );
  XOR3X1 U3362 ( .A(RQIncAddr[3]), .B(n4573), .C(n4613), .Y(n4612) );
  NAND2BX1 U3363 ( .AN(n4960), .B(n4961), .Y(n4957) );
  OAI33X1 U3364 ( .A0(n4964), .A1(WriteLatTT[1]), .A2(n4962), .B0(n4965), .B1(
        n4962), .B2(n5097), .Y(n4960) );
  AOI33X1 U3365 ( .A0(n4962), .A1(n5097), .A2(n4964), .B0(WriteLatTT[1]), .B1(
        n4965), .B2(n4962), .Y(n4961) );
  INVX1 U3366 ( .A(n4965), .Y(n4964) );
  INVX1 U3367 ( .A(n4920), .Y(n4909) );
  NAND2BX1 U3368 ( .AN(n4921), .B(n4922), .Y(n4920) );
  OAI33X1 U3369 ( .A0(n4925), .A1(WriteLatTT[3]), .A2(n4923), .B0(n4925), .B1(
        n4926), .B2(n5111), .Y(n4921) );
  AOI33X1 U3370 ( .A0(n4923), .A1(n5111), .A2(n4925), .B0(WriteLatTT[3]), .B1(
        n4926), .B2(n4925), .Y(n4922) );
  OAI221X1 U3371 ( .A0(n5123), .A1(n4953), .B0(n5093), .B1(n5086), .C0(n5012), 
        .Y(BA_AA[9]) );
  AOI22X1 U3372 ( .A0(WSpi2Addr_9_), .A1(n4941), .B0(RSpi2Addr_9_), .B1(n4939), 
        .Y(n5012) );
  OAI221X1 U3373 ( .A0(n5124), .A1(n4953), .B0(n5105), .B1(n5086), .C0(n5070), 
        .Y(BA_AA[13]) );
  AOI22X1 U3374 ( .A0(WSpi2Addr_13_), .A1(n4941), .B0(RSpi2Addr_13_), .B1(
        n4939), .Y(n5070) );
  OAI221X1 U3375 ( .A0(n5140), .A1(n4953), .B0(n5106), .B1(n5086), .C0(n5073), 
        .Y(BA_AA[12]) );
  AOI22X1 U3376 ( .A0(WSpi2Addr_12_), .A1(n4941), .B0(RSpi2Addr_12_), .B1(
        n4939), .Y(n5073) );
  OAI221X1 U3377 ( .A0(n5141), .A1(n4953), .B0(n5107), .B1(n5086), .C0(n5079), 
        .Y(BA_AA[10]) );
  AOI22X1 U3378 ( .A0(WSpi2Addr_10_), .A1(n4941), .B0(RSpi2Addr_10_), .B1(
        n4939), .Y(n5079) );
  OAI221X1 U3379 ( .A0(n5125), .A1(n4953), .B0(n5094), .B1(n5086), .C0(n5076), 
        .Y(BA_AA[11]) );
  AOI22X1 U3380 ( .A0(WSpi2Addr_11_), .A1(n4941), .B0(RSpi2Addr_11_), .B1(
        n4939), .Y(n5076) );
  OAI221X1 U3381 ( .A0(WriteLatAA_8_), .A1(n4910), .B0(ReadLatAA_8_), .B1(
        n4912), .C0(n5013), .Y(BA_AA[8]) );
  OA22X1 U3382 ( .A0(n5108), .A1(n4953), .B0(n5142), .B1(n5086), .Y(n5013) );
  INVX1 U3383 ( .A(n5000), .Y(n4884) );
  OAI221X1 U3384 ( .A0(n4917), .A1(n4918), .B0(ReadLatTT[3]), .B1(n4917), .C0(
        n5001), .Y(n5000) );
  AOI211X1 U3385 ( .A0(n4915), .A1(n5112), .B0(n5002), .C0(n5154), .Y(n5001)
         );
  OAI222X1 U3386 ( .A0(WriteLatTT[2]), .A1(n4927), .B0(n4927), .B1(n4928), 
        .C0(WriteLatTT[2]), .C1(n4928), .Y(n4919) );
  NAND2BX1 U3387 ( .AN(n4972), .B(n4973), .Y(n4956) );
  AOI33X1 U3388 ( .A0(n4974), .A1(n5096), .A2(n4975), .B0(ReadLatTT[1]), .B1(
        n4976), .B2(n4974), .Y(n4973) );
  OAI33X1 U3389 ( .A0(n4975), .A1(ReadLatTT[1]), .A2(n4974), .B0(n4976), .B1(
        n4974), .B2(n5096), .Y(n4972) );
  INVX1 U3390 ( .A(n4976), .Y(n4975) );
  AOI33X1 U3391 ( .A0(n4970), .A1(n4956), .A2(n4884), .B0(n4971), .B1(n4950), 
        .B2(n4884), .Y(n4969) );
  INVX1 U3392 ( .A(n4971), .Y(n4970) );
  XOR2X1 U3393 ( .A(n4951), .B(ReadLatTT[1]), .Y(n4971) );
  OAI211X1 U3394 ( .A0(n4588), .A1(n4609), .B0(n4610), .C0(n4611), .Y(n4365)
         );
  NAND2BX1 U3395 ( .AN(RdWrapCnt[3]), .B(n4615), .Y(n4609) );
  OAI211X1 U3396 ( .A0(n4618), .A1(n4619), .B0(n4620), .C0(n4621), .Y(n4364)
         );
  NAND2BX1 U3397 ( .AN(n4625), .B(n4626), .Y(n4619) );
  AOI33X1 U3398 ( .A0(n4622), .A1(n5113), .A2(n4580), .B0(n4583), .B1(
        RQIncAddr[4]), .B2(n4618), .Y(n4621) );
  INVX1 U3399 ( .A(n4935), .Y(n4927) );
  OAI222X1 U3400 ( .A0(WriteLatTT[1]), .A1(n4936), .B0(n4937), .B1(n4936), 
        .C0(WriteLatTT[1]), .C1(n4937), .Y(n4935) );
  INVX1 U3401 ( .A(n4938), .Y(n4936) );
  INVX1 U3402 ( .A(n4948), .Y(n4907) );
  OAI222X1 U3403 ( .A0(ReadLatTT[1]), .A1(n4949), .B0(n4950), .B1(n4949), .C0(
        ReadLatTT[1]), .C1(n4950), .Y(n4948) );
  INVX1 U3404 ( .A(n4951), .Y(n4949) );
  XOR2X1 U3405 ( .A(n4997), .B(WriteLatTT[0]), .Y(n4967) );
  XOR2X1 U3406 ( .A(n4996), .B(ReadLatTT[0]), .Y(n4978) );
  NAND4BX1 U3407 ( .AN(RBurstCnt[2]), .B(n5132), .C(n4893), .D(RQRead), .Y(
        n4550) );
  NOR2BX1 U3408 ( .AN(n5136), .B(RBurstCnt[3]), .Y(n4893) );
  XOR2X1 U3409 ( .A(n5152), .B(a1130_4_), .Y(n4792) );
  XOR2X1 U0_5_3 ( .A(part_diff_3_), .B(g_array8), .Y(a1130_4_) );
  NAND2BX1 U0_3_3 ( .AN(pog_array), .B(g_array), .Y(part_diff_3_) );
  NAND3BX1 U3410 ( .AN(RdLastCnt[2]), .B(n5087), .C(n5095), .Y(n4549) );
  NAND3BX1 U3411 ( .AN(RBurstCnt[0]), .B(n4567), .C(n4551), .Y(n4553) );
  XOR3X1 U3412 ( .A(WriteLatTT[2]), .B(n5181), .C(n4944), .Y(n4928) );
  NAND2BX1 U3413 ( .AN(RdWrapCnt[0]), .B(LatchedRBL_0_), .Y(n4581) );
  OAI211X1 U3414 ( .A0(n4853), .A1(n4824), .B0(WBLQRdData[7]), .C0(n4854), .Y(
        n4761) );
  INVX1 U3415 ( .A(n4855), .Y(n4854) );
  XOR3X1 U3416 ( .A(ReadLatTT[2]), .B(n5182), .C(n4947), .Y(n4908) );
  OAI32X1 U3417 ( .A0(n5020), .A1(n5097), .A2(n5129), .B0(n5022), .B1(n5129), 
        .Y(n4926) );
  NAND2BX1 U3418 ( .AN(WriteLatTT[3]), .B(WriteLatTT[0]), .Y(n5020) );
  INVX1 U3419 ( .A(n5023), .Y(n5022) );
  AO22X1 U3420 ( .A0(tRDIdle), .A1(n4891), .B0(tRDReq), .B1(n4550), .Y(
        NxtStRD[1]) );
  AO21X1 U3421 ( .A0(n4703), .A1(RBLCnt[1]), .B0(n4697), .Y(n4700) );
  OAI2BB1X1 U3422 ( .A0N(n4703), .A1N(RBLCnt[0]), .B0(n4692), .Y(n4697) );
  AO21X1 U3423 ( .A0(RBurstCnt[0]), .A1(n4567), .B0(n4568), .Y(n4559) );
  AO21X1 U3424 ( .A0(RBurstCnt[1]), .A1(n4567), .B0(n4559), .Y(n4563) );
  INVX1 U3425 ( .A(n4895), .Y(n4891) );
  OAI2BB1X1 U3426 ( .A0N(n4896), .A1N(n5135), .B0(n4897), .Y(n4895) );
  INVX1 U3427 ( .A(n4549), .Y(n4896) );
  NOR2BX1 U3428 ( .AN(n4898), .B(RBLQEmpty), .Y(n4897) );
  NOR2BX1 U3429 ( .AN(WQRdData_32_), .B(n5146), .Y(SD_DQM[0]) );
  NOR2BX1 U3430 ( .AN(WQRdData_33_), .B(n5146), .Y(SD_DQM[1]) );
  NOR2BX1 U3431 ( .AN(WQRdData_34_), .B(n5146), .Y(SD_DQM[2]) );
  NOR2BX1 U3432 ( .AN(WQRdData_35_), .B(n5146), .Y(SD_DQM[3]) );
  NAND3BX1 U3433 ( .AN(RBLCnt[1]), .B(n5161), .C(n4703), .Y(n4696) );
  NOR2BX1 U3434 ( .AN(NxtStRD[1]), .B(tRDReq), .Y(n5180) );
  INVX1 U3435 ( .A(n5180), .Y(n4567) );
  XNOR3X1 U3436 ( .A(n4594), .B(RQIncAddr[1]), .C(n4596), .Y(n4592) );
  XOR3X1 U3437 ( .A(RQIncAddr[2]), .B(n4572), .C(n4604), .Y(n4603) );
  XOR3X1 U3438 ( .A(WriteLatTT[2]), .B(n4927), .C(n4928), .Y(n4933) );
  NAND3BX1 U3439 ( .AN(n4574), .B(n4575), .C(n4576), .Y(n4368) );
  AOI33X1 U3440 ( .A0(n4570), .A1(n4582), .A2(n4583), .B0(RQIncAddr[0]), .B1(
        n4584), .B2(n4583), .Y(n4575) );
  AO22X1 U3441 ( .A0(tRRSpi), .A1(n4882), .B0(BA_PM), .B1(n4883), .Y(NxtStR[2]) );
  INVX1 U3442 ( .A(n4652), .Y(n4642) );
  NAND3BX1 U3443 ( .AN(RdWrapCnt[6]), .B(n4578), .C(n4653), .Y(n4652) );
  INVX1 U3444 ( .A(n4634), .Y(n4653) );
  OR2X1 U3445 ( .A(RBurstCnt[1]), .B(n4553), .Y(n4558) );
  OAI221X1 U3446 ( .A0(n5161), .A1(n4692), .B0(RBLCnt[0]), .B1(n4693), .C0(
        n4554), .Y(n4356) );
  OAI221X1 U3447 ( .A0(RBLCnt[2]), .A1(n4696), .B0(n4698), .B1(n5166), .C0(
        n4562), .Y(n4354) );
  INVX1 U3448 ( .A(n4700), .Y(n4698) );
  AND2X2 U3449 ( .A(WriteLatA0_2_), .B(n5023), .Y(n5181) );
  AND2X2 U3450 ( .A(ReadLatA0_2_), .B(n5019), .Y(n5182) );
  AO21X1 U3451 ( .A0(RBLCnt[3]), .A1(n4700), .B0(n4701), .Y(n4353) );
  OAI31X1 U3452 ( .A0(n4696), .A1(RBLCnt[3]), .A2(RBLCnt[2]), .B0(n4702), .Y(
        n4701) );
  AOI31X1 U3453 ( .A0(RBLCnt[3]), .A1(RBLCnt[2]), .A2(n4703), .B0(n4690), .Y(
        n4702) );
  OAI211X1 U3454 ( .A0(n4588), .A1(n4600), .B0(n4601), .C0(n4602), .Y(n4366)
         );
  NAND2BX1 U3455 ( .AN(RdWrapCnt[2]), .B(n4606), .Y(n4600) );
  OAI211X1 U3456 ( .A0(n4588), .A1(n4589), .B0(n4590), .C0(n4591), .Y(n4367)
         );
  NAND2BX1 U3457 ( .AN(RdWrapCnt[1]), .B(n4599), .Y(n4589) );
  INVX1 U3458 ( .A(RQIncAddr[0]), .Y(n4582) );
  OAI211X1 U3459 ( .A0(n4558), .A1(n4564), .B0(n4565), .C0(n4566), .Y(n4373)
         );
  NAND2BX1 U3460 ( .AN(RBurstCnt[3]), .B(n5159), .Y(n4564) );
  AOI32X1 U3461 ( .A0(RBurstCnt[2]), .A1(RBurstCnt[3]), .A2(n4567), .B0(
        RBurstCnt[3]), .B1(n4563), .Y(n4566) );
  OAI32X1 U3462 ( .A0(n5016), .A1(n5096), .A2(n5131), .B0(n5018), .B1(n5131), 
        .Y(n4918) );
  NAND2BX1 U3463 ( .AN(ReadLatTT[3]), .B(ReadLatTT[0]), .Y(n5016) );
  INVX1 U3464 ( .A(n5019), .Y(n5018) );
  INVX1 U3465 ( .A(n4660), .Y(n4608) );
  INVX1 U3466 ( .A(n4659), .Y(n4617) );
  OAI221X1 U3467 ( .A0(n4560), .A1(n5159), .B0(RBurstCnt[2]), .B1(n4558), .C0(
        n4562), .Y(n4374) );
  INVX1 U3468 ( .A(n4563), .Y(n4560) );
  AFHCONX2 U2_3 ( .A(WrWrapCnt[3]), .B(n5143), .CI(carry10), .S(
        WrWrapCnt1080_3_), .CON(n62) );
  INVX1 U3469 ( .A(n72), .Y(carry10) );
  AFHCONX2 U2_2 ( .A(WrWrapCnt[2]), .B(n5144), .CI(carry11), .S(
        WrWrapCnt1080_2_), .CON(n72) );
  INVX1 U3470 ( .A(n81), .Y(carry11) );
  AFHCONX2 U2_1 ( .A(WrWrapCnt[1]), .B(n5145), .CI(carry12), .S(
        WrWrapCnt1080_1_), .CON(n81) );
  NOR3BX1 U3471 ( .AN(WriteAck), .B(n5086), .C(WBLQFull), .Y(WBLQWrite) );
  XOR2X1 U3472 ( .A(n4938), .B(WriteLatTT[1]), .Y(n4959) );
  OR4X1 U3473 ( .A(RdWrapAddrSt_3_), .B(RdWrapAddrSt_2_), .C(RdWrapAddrSt_0_), 
        .D(RdWrapAddrSt_1_), .Y(n4668) );
  XOR2X1 U3474 ( .A(n4550), .B(IncRdLastCnt), .Y(n4534) );
  INVX1 U3475 ( .A(n25), .Y(carry13) );
  INVX1 U3476 ( .A(n3), .Y(carry_5_) );
  INVX1 U3477 ( .A(n4), .Y(carry_4_) );
  INVX1 U3478 ( .A(n36), .Y(carry14) );
  INVX1 U3479 ( .A(n43), .Y(carry15) );
  INVX1 U3480 ( .A(n5), .Y(carry_3_) );
  INVX1 U3481 ( .A(n6), .Y(carry_2_) );
  NAND4BX1 U3482 ( .AN(n4665), .B(n4666), .C(n4667), .D(n4668), .Y(n4662) );
  XOR2X1 U3483 ( .A(n5151), .B(RdWrapAddrSt_1_), .Y(n4666) );
  XOR2X1 U3484 ( .A(RdWrapAddrSt_0_), .B(RBLCnt[0]), .Y(n4665) );
  NOR2BX1 U3485 ( .AN(n4669), .B(n4670), .Y(n4667) );
  AO22X1 U3486 ( .A0(ReadReqID[2]), .A1(n5009), .B0(WriteReqID[2]), .B1(n4998), 
        .Y(BA_ID[2]) );
  AO22X1 U3487 ( .A0(n5192), .A1(WriteLatAA_7_), .B0(n4902), .B1(ReadLatAA_7_), 
        .Y(BA_AA[7]) );
  AO22X1 U3488 ( .A0(n5192), .A1(WriteLatAA_4_), .B0(n4902), .B1(ReadLatAA_4_), 
        .Y(BA_AA[4]) );
  XOR2X1 U3489 ( .A(RdWrapAddrSt_2_), .B(RBLCnt[2]), .Y(n4670) );
  XOR2X1 U3490 ( .A(a1130_1_), .B(WBLCnt[0]), .Y(n4790) );
  NAND2BX1 U0_3_0 ( .AN(pog_array2), .B(g_array2), .Y(a1130_1_) );
  XOR2X1 U3491 ( .A(RBLCnt[3]), .B(n5183), .Y(n4669) );
  AO22X1 U3492 ( .A0(ReadReqID[0]), .A1(n5009), .B0(WriteReqID[0]), .B1(n4998), 
        .Y(BA_ID[0]) );
  AO22X1 U3493 ( .A0(n5192), .A1(WriteLatAA_5_), .B0(n4902), .B1(ReadLatAA_5_), 
        .Y(BA_AA[5]) );
  NAND2BX1 U3494 ( .AN(WrWrapCnt[0]), .B(LatchedWBL_0_), .Y(carry12) );
  NAND3X1 U3495 ( .A(ReadLatAA_5_), .B(ReadLatAA_6_), .C(ReadLatAA_7_), .Y(
        n5002) );
  NOR2BX1 U3496 ( .AN(RdDataRdy), .B(RQFull), .Y(RQWrite) );
  AO21X1 U3497 ( .A0(IncRdLastCnt), .A1(n5095), .B0(n4534), .Y(n4535) );
  AO21X1 U3498 ( .A0(RdLastCnt[0]), .A1(n5087), .B0(n4535), .Y(n4539) );
  INVX1 U3499 ( .A(n2), .Y(carry_6_) );
  AO22X1 U3500 ( .A0(RdWrapAddrSt_3_), .A1(n4567), .B0(n4573), .B1(n5180), .Y(
        n4369) );
  AO22X1 U3501 ( .A0(RdWrapAddrSt_1_), .A1(n4567), .B0(n4571), .B1(n5180), .Y(
        n4371) );
  AO22X1 U3502 ( .A0(RdWrapAddrSt_2_), .A1(n4567), .B0(n4572), .B1(n5180), .Y(
        n4370) );
  AO22X1 U3503 ( .A0(RdWrapAddrSt_0_), .A1(n4567), .B0(n4570), .B1(n5180), .Y(
        n4372) );
  OAI221X1 U3504 ( .A0(tRDReq), .A1(tRDIdle), .B0(n4891), .B1(n5167), .C0(
        n4550), .Y(NxtStRD[0]) );
  OAI32X1 U3505 ( .A0(n4534), .A1(RdLastCnt[3]), .A2(n4546), .B0(n4547), .B1(
        n5135), .Y(n4377) );
  OA22X1 U3506 ( .A0(n5115), .A1(n4545), .B0(IncRdLastCnt), .B1(n4549), .Y(
        n4546) );
  AOI221X1 U3507 ( .A0(RdLastCnt[2]), .A1(n5157), .B0(RdLastCnt[1]), .B1(n5115), .C0(n4539), .Y(n4547) );
  AO21X1 U3508 ( .A0(RdLastCnt[2]), .A1(n4539), .B0(n4540), .Y(n4378) );
  OAI33X1 U3509 ( .A0(n5087), .A1(IncRdLastCnt), .A2(n5115), .B0(n4534), .B1(
        RdLastCnt[2]), .B2(n4542), .Y(n4540) );
  AOI31X1 U3510 ( .A0(n5095), .A1(n5087), .A2(n5157), .B0(n4544), .Y(n4542) );
  INVX1 U3511 ( .A(n4545), .Y(n4544) );
  AO21X1 U3512 ( .A0(LatchedRBL_3_), .A1(n4567), .B0(n4690), .Y(n4357) );
  OAI2BB1X1 U3513 ( .A0N(LatchedRBL_2_), .A1N(n4567), .B0(n4562), .Y(n4358) );
  OAI2BB1X1 U3514 ( .A0N(LatchedRBL_1_), .A1N(n4567), .B0(n4557), .Y(n4359) );
  OAI2BB1X1 U3515 ( .A0N(LatchedRBL_0_), .A1N(n4567), .B0(n4554), .Y(n4360) );
  AO21X1 U3516 ( .A0(RdLastCnt[1]), .A1(n4535), .B0(n4536), .Y(n4379) );
  OAI33X1 U3517 ( .A0(n5087), .A1(IncRdLastCnt), .A2(n5095), .B0(n4534), .B1(
        RdLastCnt[1]), .B2(n4538), .Y(n4536) );
  XOR2X1 U3518 ( .A(RdLastCnt[0]), .B(IncRdLastCnt), .Y(n4538) );
  XOR2X1 U3519 ( .A(n4581), .B(LatchedRBL_1_), .Y(n4597) );
  NAND3BX1 U3520 ( .AN(n5157), .B(RdLastCnt[0]), .C(RdLastCnt[1]), .Y(n4545)
         );
  BUFX2 U3521 ( .A(n4395), .Y(n5191) );
  AO22X1 U3522 ( .A0(SD_DQI[31]), .A1(n5191), .B0(RdDataMemFd[31]), .B1(n5156), 
        .Y(n4321) );
  AO22X1 U3523 ( .A0(SD_DQI[30]), .A1(n5191), .B0(RdDataMemFd[30]), .B1(n5156), 
        .Y(n4322) );
  AO22X1 U3524 ( .A0(SD_DQI[29]), .A1(n5191), .B0(RdDataMemFd[29]), .B1(n5156), 
        .Y(n4323) );
  AO22X1 U3525 ( .A0(SD_DQI[28]), .A1(n5191), .B0(RdDataMemFd[28]), .B1(n5156), 
        .Y(n4324) );
  AO22X1 U3526 ( .A0(SD_DQI[27]), .A1(n5191), .B0(RdDataMemFd[27]), .B1(n5156), 
        .Y(n4325) );
  AO22X1 U3527 ( .A0(SD_DQI[26]), .A1(n5191), .B0(RdDataMemFd[26]), .B1(n5156), 
        .Y(n4326) );
  AO22X1 U3528 ( .A0(SD_DQI[25]), .A1(n5191), .B0(RdDataMemFd[25]), .B1(n5156), 
        .Y(n4327) );
  AO22X1 U3529 ( .A0(SD_DQI[24]), .A1(n5191), .B0(RdDataMemFd[24]), .B1(n5156), 
        .Y(n4328) );
  AO22X1 U3530 ( .A0(SD_DQI[23]), .A1(n5191), .B0(RdDataMemFd[23]), .B1(n5156), 
        .Y(n4329) );
  AO22X1 U3531 ( .A0(SD_DQI[22]), .A1(n5191), .B0(RdDataMemFd[22]), .B1(n5156), 
        .Y(n4330) );
  AO22X1 U3532 ( .A0(SD_DQI[21]), .A1(n5191), .B0(RdDataMemFd[21]), .B1(n5156), 
        .Y(n4331) );
  AO22X1 U3533 ( .A0(SD_DQI[20]), .A1(n5191), .B0(RdDataMemFd[20]), .B1(n5156), 
        .Y(n4332) );
  AO22X1 U3534 ( .A0(SD_DQI[19]), .A1(n5191), .B0(RdDataMemFd[19]), .B1(n5156), 
        .Y(n4333) );
  AO22X1 U3535 ( .A0(SD_DQI[18]), .A1(n5191), .B0(RdDataMemFd[18]), .B1(n5156), 
        .Y(n4334) );
  AO22X1 U3536 ( .A0(SD_DQI[17]), .A1(n5191), .B0(RdDataMemFd[17]), .B1(n5156), 
        .Y(n4335) );
  AO22X1 U3537 ( .A0(SD_DQI[16]), .A1(n5191), .B0(RdDataMemFd[16]), .B1(n5156), 
        .Y(n4336) );
  AO22X1 U3538 ( .A0(SD_DQI[15]), .A1(n5191), .B0(RdDataMemFd[15]), .B1(n5156), 
        .Y(n4337) );
  AO22X1 U3539 ( .A0(SD_DQI[14]), .A1(n5191), .B0(RdDataMemFd[14]), .B1(n5156), 
        .Y(n4338) );
  AO22X1 U3540 ( .A0(SD_DQI[13]), .A1(n5191), .B0(RdDataMemFd[13]), .B1(n5156), 
        .Y(n4339) );
  AO22X1 U3541 ( .A0(SD_DQI[12]), .A1(n5191), .B0(RdDataMemFd[12]), .B1(n5156), 
        .Y(n4340) );
  AO22X1 U3542 ( .A0(SD_DQI[11]), .A1(n5191), .B0(RdDataMemFd[11]), .B1(n5156), 
        .Y(n4341) );
  AO22X1 U3543 ( .A0(SD_DQI[10]), .A1(n5191), .B0(RdDataMemFd[10]), .B1(n5156), 
        .Y(n4342) );
  AO22X1 U3544 ( .A0(SD_DQI[9]), .A1(n5191), .B0(RdDataMemFd[9]), .B1(n5156), 
        .Y(n4343) );
  AO22X1 U3545 ( .A0(SD_DQI[8]), .A1(n5191), .B0(RdDataMemFd[8]), .B1(n5156), 
        .Y(n4344) );
  AO22X1 U3546 ( .A0(SD_DQI[7]), .A1(n5191), .B0(RdDataMemFd[7]), .B1(n5156), 
        .Y(n4345) );
  AO22X1 U3547 ( .A0(SD_DQI[6]), .A1(n5191), .B0(RdDataMemFd[6]), .B1(n5156), 
        .Y(n4346) );
  AO22X1 U3548 ( .A0(SD_DQI[5]), .A1(n5191), .B0(RdDataMemFd[5]), .B1(n5156), 
        .Y(n4347) );
  AO22X1 U3549 ( .A0(SD_DQI[4]), .A1(n5191), .B0(RdDataMemFd[4]), .B1(n5156), 
        .Y(n4348) );
  AO22X1 U3550 ( .A0(SD_DQI[3]), .A1(n5191), .B0(RdDataMemFd[3]), .B1(n5156), 
        .Y(n4349) );
  AO22X1 U3551 ( .A0(SD_DQI[2]), .A1(n5191), .B0(RdDataMemFd[2]), .B1(n5156), 
        .Y(n4350) );
  AO22X1 U3552 ( .A0(SD_DQI[1]), .A1(n5191), .B0(RdDataMemFd[1]), .B1(n5156), 
        .Y(n4351) );
  AO22X1 U3553 ( .A0(n5191), .A1(SD_DQI[0]), .B0(RdDataMemFd[0]), .B1(n5156), 
        .Y(n4352) );
  INVX1 U3554 ( .A(RQIncAddr[7]), .Y(n4655) );
  INVX1 U3555 ( .A(RQIncAddr[5]), .Y(n4636) );
  INVX1 U3556 ( .A(RQIncAddr[6]), .Y(n4644) );
  INVX1 U3557 ( .A(RQIncAddr[4]), .Y(n4626) );
  INVX1 U3558 ( .A(WQIncAddr[0]), .Y(n4727) );
  DFFRX1 ReadLatA0_reg_8_ ( .D(n4304), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_8_), .QN(n5108) );
  DFFRX1 WriteLatA0_reg_8_ ( .D(n4246), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_8_), .QN(n5142) );
  DFFRX1 WriteLatA0_reg_12_ ( .D(n4242), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_12_), .QN(n5106) );
  DFFRX1 WriteLatA0_reg_11_ ( .D(n4243), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_11_), .QN(n5094) );
  DFFRX1 WriteLatA0_reg_10_ ( .D(n4244), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_10_), .QN(n5107) );
  DFFRX1 WriteLatA0_reg_9_ ( .D(n4245), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_9_), .QN(n5093) );
  DFFRX1 ReadLatA0_reg_10_ ( .D(n4302), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_10_), .QN(n5141) );
  DFFRX1 ReadLatA0_reg_9_ ( .D(n4303), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_9_), .QN(n5123) );
  DFFRX1 WriteLatA0_reg_17_ ( .D(n4237), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_17_), .QN(n5092) );
  DFFRX1 WriteLatA0_reg_16_ ( .D(n4238), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_16_), .QN(n5104) );
  DFFRX1 WriteLatA0_reg_15_ ( .D(n4239), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_15_), .QN(n5102) );
  DFFRX1 WriteLatA0_reg_14_ ( .D(n4240), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_14_), .QN(n5091) );
  DFFRX1 WriteLatA0_reg_13_ ( .D(n4241), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_13_), .QN(n5105) );
  DFFRX1 ReadLatA0_reg_16_ ( .D(n4296), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_16_), .QN(n5139) );
  DFFRX1 ReadLatA0_reg_15_ ( .D(n4297), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_15_), .QN(n5120) );
  DFFRX1 ReadLatA0_reg_14_ ( .D(n4298), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_14_), .QN(n5121) );
  DFFRX1 ReadLatA0_reg_13_ ( .D(n4299), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_13_), .QN(n5124) );
  DFFRX1 ReadLatA0_reg_12_ ( .D(n4300), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_12_), .QN(n5140) );
  DFFRX1 ReadLatA0_reg_11_ ( .D(n4301), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_11_), .QN(n5125) );
  DFFRX1 CurStR_reg_2_ ( .D(NxtStR[2]), .CK(ACLK), .RN(ARESETB), .Q(tRRSpi), 
        .QN(n5117) );
  DFFRX1 CurStR_reg_1_ ( .D(NxtStR[1]), .CK(ACLK), .RN(ARESETB), .Q(tRRReq), 
        .QN(n5085) );
  DFFRX1 CurStW_reg_4_ ( .D(NxtStW[4]), .CK(ACLK), .RN(ARESETB), .Q(tWWSpi), 
        .QN(n5116) );
  DFFRX1 CurStW_reg_3_ ( .D(NxtStW[3]), .CK(ACLK), .RN(ARESETB), .Q(tWWReq), 
        .QN(n5086) );
  DFFRX1 WriteLatTT_reg_0_ ( .D(n4258), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatTT[0]), .QN(n5178) );
  DFFRX1 WriteLatTT_reg_1_ ( .D(n4257), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatTT[1]), .QN(n5097) );
  DFFRX1 WriteLatTT_reg_3_ ( .D(n4255), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatTT[3]), .QN(n5111) );
  DFFRX1 ReadLatTT_reg_0_ ( .D(n4316), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatTT[0]), .QN(n5179) );
  DFFRX1 WriteLatTT_reg_2_ ( .D(n4256), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatTT[2]) );
  DFFRX1 ReadLatTT_reg_1_ ( .D(n4315), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatTT[1]), .QN(n5096) );
  DFFRX1 CurStW_reg_2_ ( .D(NxtStW[2]), .CK(ACLK), .RN(ARESETB), .Q(BValid), 
        .QN(n5175) );
  DFFRX1 LatchedWBL_reg_0_ ( .D(n4278), .CK(ACLK), .RN(ARESETB), .Q(
        LatchedWBL_0_), .QN(n5127) );
  DFFRX1 ReadLatTT_reg_2_ ( .D(n4314), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatTT[2]) );
  DFFRX1 AckMem_reg ( .D(AckMem251), .CK(ACLK), .RN(ARESETB), .Q(WriteAck), 
        .QN(n5114) );
  DFFRX1 ReadLatTT_reg_3_ ( .D(n4313), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatTT[3]), .QN(n5112) );
  DFFRX1 CurStRD_reg_1_ ( .D(NxtStRD[1]), .CK(ACLK), .RN(ARESETB), .Q(tRDReq)
         );
  DFFRX1 WriteLatA0_reg_20_ ( .D(n4234), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_20_), .QN(n5101) );
  DFFRX1 WriteLatA0_reg_19_ ( .D(n4235), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_19_), .QN(n5090) );
  DFFRX1 WriteLatA0_reg_18_ ( .D(n4236), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_18_), .QN(n5103) );
  DFFRX1 ReadLatA0_reg_20_ ( .D(n4292), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_20_), .QN(n5137) );
  DFFRX1 ReadLatA0_reg_19_ ( .D(n4293), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_19_), .QN(n5119) );
  DFFRX1 ReadLatA0_reg_18_ ( .D(n4294), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_18_), .QN(n5138) );
  DFFRX1 ReadLatA0_reg_17_ ( .D(n4295), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_17_), .QN(n5122) );
  DFFRX1 LatchedWBL_reg_1_ ( .D(n4277), .CK(ACLK), .RN(ARESETB), .Q(
        LatchedWBL_1_), .QN(n5145) );
  DFFRX1 WriteLatA0_reg_1_ ( .D(n4253), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatA0_1_), .QN(n5128) );
  DFFRX1 WriteLatA0_reg_0_ ( .D(n4254), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatA0_0_) );
  DFFRX1 WriteLatA0_reg_21_ ( .D(n4233), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_21_), .QN(n5126) );
  DFFRX1 ReadLatA0_reg_21_ ( .D(n4291), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_21_), .QN(n5118) );
  DFFSX1 CurStW_reg_0_ ( .D(NxtStW[0]), .CK(ACLK), .SN(ARESETB), .Q(tWIdle), 
        .QN(n5158) );
  DFFRX1 ReadLatA0_reg_1_ ( .D(n4311), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatA0_1_), .QN(n5130) );
  DFFRX1 ReadLatA0_reg_0_ ( .D(n4312), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatA0_0_) );
  DFFSX1 CurStR_reg_0_ ( .D(NxtStR[0]), .CK(ACLK), .SN(ARESETB), .QN(n5089) );
  DFFRX1 CurStW_reg_1_ ( .D(NxtStW[1]), .CK(ACLK), .RN(ARESETB), .Q(tWWDat) );
  DFFRX1 WriteLatBB_reg_1_ ( .D(n4231), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatBB[1]) );
  DFFRX1 BId_reg_3_ ( .D(n4263), .CK(ACLK), .RN(ARESETB), .Q(BId[3]) );
  DFFRX1 BId_reg_2_ ( .D(n4264), .CK(ACLK), .RN(ARESETB), .Q(BId[2]) );
  DFFRX1 BId_reg_1_ ( .D(n4265), .CK(ACLK), .RN(ARESETB), .Q(BId[1]) );
  DFFRX1 BId_reg_0_ ( .D(n4266), .CK(ACLK), .RN(ARESETB), .Q(BId[0]) );
  DFFRX1 WriteLatBB_reg_0_ ( .D(n4232), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatBB[0]) );
  DFFRX1 ReadLatBB_reg_1_ ( .D(n4289), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatBB[1]) );
  DFFRX1 ReadLatBB_reg_0_ ( .D(n4290), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatBB[0]) );
  DFFRX1 RdLastCnt_reg_0_ ( .D(n4380), .CK(ACLK), .RN(ARESETB), .Q(
        RdLastCnt[0]), .QN(n5095) );
  DFFRX1 RdLastCnt_reg_1_ ( .D(n4379), .CK(ACLK), .RN(ARESETB), .Q(
        RdLastCnt[1]), .QN(n5087) );
  DFFRX1 LatchedRBL_reg_1_ ( .D(n4359), .CK(ACLK), .RN(ARESETB), .Q(
        LatchedRBL_1_), .QN(n5134) );
  DFFRX1 LatchedRBL_reg_0_ ( .D(n4360), .CK(ACLK), .RN(ARESETB), .Q(
        LatchedRBL_0_), .QN(n5169) );
  DFFRX1 LatchedWBL_reg_3_ ( .D(n4275), .CK(ACLK), .RN(ARESETB), .Q(
        LatchedWBL_3_), .QN(n5143) );
  DFFRX1 LatchedWBL_reg_2_ ( .D(n4276), .CK(ACLK), .RN(ARESETB), .Q(
        LatchedWBL_2_), .QN(n5144) );
  DFFRX1 WriteLatA0_reg_3_ ( .D(n4251), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatA0_3_), .QN(n5129) );
  DFFRX1 WriteLatA0_reg_2_ ( .D(n4252), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatA0_2_) );
  DFFRX1 RdLastCnt_reg_2_ ( .D(n4378), .CK(ACLK), .RN(ARESETB), .Q(
        RdLastCnt[2]), .QN(n5115) );
  DFFRX1 ReadLatA0_reg_3_ ( .D(n4309), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatA0_3_), .QN(n5131) );
  DFFRX1 ReadLatA0_reg_2_ ( .D(n4310), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatA0_2_) );
  DFFRX1 WrWrapAddrSt_reg_3_ ( .D(n4285), .CK(ACLK), .RN(ARESETB), .Q(
        WrWrapAddrSt_3_), .QN(n5084) );
  DFFRX1 WrWrapAddrSt_reg_2_ ( .D(n4286), .CK(ACLK), .RN(ARESETB), .Q(
        WrWrapAddrSt_2_), .QN(n5098) );
  DFFRX1 WrWrapAddrSt_reg_1_ ( .D(n4287), .CK(ACLK), .RN(ARESETB), .Q(
        WrWrapAddrSt_1_), .QN(n5088) );
  DFFRX1 WrWrapAddrSt_reg_0_ ( .D(n4288), .CK(ACLK), .RN(ARESETB), .Q(
        WrWrapAddrSt_0_), .QN(n5100) );
  DFFRX1 DelayxWQRead_reg ( .D(DelayiWQRead), .CK(ACLK), .RN(ARESETB), .Q(
        SD_DQE), .QN(n5146) );
  DFFRX1 WBLCnt_reg_0_ ( .D(n4274), .CK(ACLK), .RN(ARESETB), .Q(WBLCnt[0]), 
        .QN(n5160) );
  DFFRX1 RBLCnt_reg_0_ ( .D(n4356), .CK(ACLK), .RN(ARESETB), .Q(RBLCnt[0]), 
        .QN(n5161) );
  DFFRX1 RBLCnt_reg_2_ ( .D(n4354), .CK(ACLK), .RN(ARESETB), .Q(RBLCnt[2]), 
        .QN(n5166) );
  DFFRX1 RdWrapAddrSt_reg_1_ ( .D(n4371), .CK(ACLK), .RN(ARESETB), .Q(
        RdWrapAddrSt_1_) );
  DFFRX1 WBurstCnt_reg_0_ ( .D(n4270), .CK(ACLK), .RN(ARESETB), .Q(
        WBurstCnt[0]), .QN(n5177) );
  DFFRX1 RdWrapAddrSt_reg_2_ ( .D(n4370), .CK(ACLK), .RN(ARESETB), .Q(
        RdWrapAddrSt_2_) );
  DFFRX1 RdWrapAddrSt_reg_0_ ( .D(n4372), .CK(ACLK), .RN(ARESETB), .Q(
        RdWrapAddrSt_0_) );
  DFFSX1 CurStRD_reg_0_ ( .D(NxtStRD[0]), .CK(ACLK), .SN(ARESETB), .Q(tRDIdle), 
        .QN(n5167) );
  DFFRX1 WriteLatA0_reg_5_ ( .D(n4249), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_5_), .QN(n5155) );
  DFFRX1 WriteLatA0_reg_4_ ( .D(n4250), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_4_), .QN(n5153) );
  DFFRX1 RBurstCnt_reg_2_ ( .D(n4374), .CK(ACLK), .RN(ARESETB), .Q(
        RBurstCnt[2]), .QN(n5159) );
  DFFRX1 ReadLatA0_reg_5_ ( .D(n4307), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_5_) );
  DFFRX1 ReadLatA0_reg_4_ ( .D(n4308), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_4_), .QN(n5154) );
  DFFRX1 WBLCnt_reg_3_ ( .D(n4271), .CK(ACLK), .RN(ARESETB), .Q(WBLCnt[3]), 
        .QN(n5152) );
  DFFRX1 RBLCnt_reg_3_ ( .D(n4353), .CK(ACLK), .RN(ARESETB), .Q(RBLCnt[3]) );
  DFFRX1 RBurstCnt_reg_0_ ( .D(n4376), .CK(ACLK), .RN(ARESETB), .Q(
        RBurstCnt[0]), .QN(n5132) );
  DFFRX1 RBurstCnt_reg_1_ ( .D(n4375), .CK(ACLK), .RN(ARESETB), .Q(
        RBurstCnt[1]), .QN(n5136) );
  DFFRX1 WBLCnt_reg_1_ ( .D(n4273), .CK(ACLK), .RN(ARESETB), .Q(WBLCnt[1]), 
        .QN(n5150) );
  DFFRX1 RBLCnt_reg_1_ ( .D(n4355), .CK(ACLK), .RN(ARESETB), .Q(RBLCnt[1]), 
        .QN(n5151) );
  DFFRX1 WBurstCnt_reg_1_ ( .D(n4269), .CK(ACLK), .RN(ARESETB), .Q(
        WBurstCnt[1]), .QN(n5133) );
  DFFRX1 WBurstCnt_reg_2_ ( .D(n4268), .CK(ACLK), .RN(ARESETB), .Q(
        WBurstCnt[2]), .QN(n5099) );
  DFFRX1 WBLCnt_reg_2_ ( .D(n4272), .CK(ACLK), .RN(ARESETB), .Q(WBLCnt[2]), 
        .QN(n5149) );
  DFFRX1 LatchedRBL_reg_3_ ( .D(n4357), .CK(ACLK), .RN(ARESETB), .Q(
        LatchedRBL_3_), .QN(n5148) );
  DFFRX1 LatchedRBL_reg_2_ ( .D(n4358), .CK(ACLK), .RN(ARESETB), .Q(
        LatchedRBL_2_), .QN(n5147) );
  DFFRX1 RdLastCnt_reg_3_ ( .D(n4377), .CK(ACLK), .RN(ARESETB), .Q(
        RdLastCnt[3]), .QN(n5135) );
  DFFRX1 RdWrapAddrSt_reg_3_ ( .D(n4369), .CK(ACLK), .RN(ARESETB), .Q(
        RdWrapAddrSt_3_), .QN(n5183) );
  DFFRX1 WriteLatA0_reg_7_ ( .D(n4247), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_7_) );
  DFFRX1 WriteLatA0_reg_6_ ( .D(n4248), .CK(ACLK), .RN(ARESETB), .Q(
        WriteLatAA_6_) );
  DFFRX1 ReadLatA0_reg_7_ ( .D(n4305), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_7_) );
  DFFRX1 ReadLatA0_reg_6_ ( .D(n4306), .CK(ACLK), .RN(ARESETB), .Q(
        ReadLatAA_6_) );
  DFFRX1 RBurstCnt_reg_3_ ( .D(n4373), .CK(ACLK), .RN(ARESETB), .Q(
        RBurstCnt[3]) );
  DFFRX1 WBurstCnt_reg_3_ ( .D(n4267), .CK(ACLK), .RN(ARESETB), .Q(
        WBurstCnt[3]) );
  DFFRX1 RdLastMem_reg ( .D(iDelayReadLast), .CK(ACLK), .RN(ARESETB), .Q(
        IncRdLastCnt), .QN(n5157) );
  DFFRX1 ReadLatchEnFd_reg ( .D(BA_STS[1]), .CK(FCLK), .RN(ARESETB), .Q(n4395), 
        .QN(n5156) );
  DFFRX1 DelayiWQRead_reg ( .D(n746_0_), .CK(ACLK), .RN(ARESETB), .Q(
        DelayiWQRead) );
  DFFRX1 ReadLatID_reg_3_ ( .D(n4317), .CK(ACLK), .RN(ARESETB), .Q(
        ReadReqID[3]) );
  DFFRX1 ReadLatID_reg_2_ ( .D(n4318), .CK(ACLK), .RN(ARESETB), .Q(
        ReadReqID[2]) );
  DFFRX1 ReadLatID_reg_1_ ( .D(n4319), .CK(ACLK), .RN(ARESETB), .Q(
        ReadReqID[1]) );
  DFFRX1 ReadLatID_reg_0_ ( .D(n4320), .CK(ACLK), .RN(ARESETB), .Q(
        ReadReqID[0]) );
  DFFRX1 WriteLatID_reg_3_ ( .D(n4259), .CK(ACLK), .RN(ARESETB), .Q(
        WriteReqID[3]) );
  DFFRX1 WriteLatID_reg_2_ ( .D(n4260), .CK(ACLK), .RN(ARESETB), .Q(
        WriteReqID[2]) );
  DFFRX1 WriteLatID_reg_1_ ( .D(n4261), .CK(ACLK), .RN(ARESETB), .Q(
        WriteReqID[1]) );
  DFFRX1 WriteLatID_reg_0_ ( .D(n4262), .CK(ACLK), .RN(ARESETB), .Q(
        WriteReqID[0]) );
  DFFRX1 RdDataRdy_reg ( .D(iDelayReadFlag), .CK(ACLK), .RN(ARESETB), .Q(
        RdDataRdy) );
  DFFRX1 RdDataMemFd_reg_31_ ( .D(n4321), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[31]) );
  DFFRX1 RdDataMemFd_reg_30_ ( .D(n4322), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[30]) );
  DFFRX1 RdDataMemFd_reg_29_ ( .D(n4323), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[29]) );
  DFFRX1 RdDataMemFd_reg_28_ ( .D(n4324), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[28]) );
  DFFRX1 RdDataMemFd_reg_27_ ( .D(n4325), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[27]) );
  DFFRX1 RdDataMemFd_reg_26_ ( .D(n4326), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[26]) );
  DFFRX1 RdDataMemFd_reg_25_ ( .D(n4327), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[25]) );
  DFFRX1 RdDataMemFd_reg_24_ ( .D(n4328), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[24]) );
  DFFRX1 RdDataMemFd_reg_23_ ( .D(n4329), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[23]) );
  DFFRX1 RdDataMemFd_reg_22_ ( .D(n4330), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[22]) );
  DFFRX1 RdDataMemFd_reg_21_ ( .D(n4331), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[21]) );
  DFFRX1 RdDataMemFd_reg_20_ ( .D(n4332), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[20]) );
  DFFRX1 RdDataMemFd_reg_19_ ( .D(n4333), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[19]) );
  DFFRX1 RdDataMemFd_reg_18_ ( .D(n4334), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[18]) );
  DFFRX1 RdDataMemFd_reg_17_ ( .D(n4335), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[17]) );
  DFFRX1 RdDataMemFd_reg_16_ ( .D(n4336), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[16]) );
  DFFRX1 RdDataMemFd_reg_15_ ( .D(n4337), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[15]) );
  DFFRX1 RdDataMemFd_reg_14_ ( .D(n4338), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[14]) );
  DFFRX1 RdDataMemFd_reg_13_ ( .D(n4339), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[13]) );
  DFFRX1 RdDataMemFd_reg_12_ ( .D(n4340), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[12]) );
  DFFRX1 RdDataMemFd_reg_11_ ( .D(n4341), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[11]) );
  DFFRX1 RdDataMemFd_reg_10_ ( .D(n4342), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[10]) );
  DFFRX1 RdDataMemFd_reg_9_ ( .D(n4343), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[9]) );
  DFFRX1 RdDataMemFd_reg_8_ ( .D(n4344), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[8]) );
  DFFRX1 RdDataMemFd_reg_7_ ( .D(n4345), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[7]) );
  DFFRX1 RdDataMemFd_reg_6_ ( .D(n4346), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[6]) );
  DFFRX1 RdDataMemFd_reg_5_ ( .D(n4347), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[5]) );
  DFFRX1 RdDataMemFd_reg_4_ ( .D(n4348), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[4]) );
  DFFRX1 RdDataMemFd_reg_3_ ( .D(n4349), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[3]) );
  DFFRX1 RdDataMemFd_reg_2_ ( .D(n4350), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[2]) );
  DFFRX1 RdDataMemFd_reg_1_ ( .D(n4351), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[1]) );
  DFFRX1 RdDataMemFd_reg_0_ ( .D(n4352), .CK(FCLK), .RN(ARESETB), .Q(
        RdDataMemFd[0]) );
endmodule


module SDRBLQ_BLQCD3_BLQD15_BLQW9 ( nRST, Clk, WriteEn, ReadEn, WrData, RdData, 
        FullFlag, EmptyFlag );
  input [9:0] WrData;
  output [9:0] RdData;
  input nRST, Clk, WriteEn, ReadEn;
  output FullFlag, EmptyFlag;
  wire   \FIFO[0][9] , \FIFO[0][8] , \FIFO[0][7] , \FIFO[0][6] , \FIFO[0][5] ,
         \FIFO[0][4] , \FIFO[0][3] , \FIFO[0][2] , \FIFO[0][1] , \FIFO[0][0] ,
         \FIFO[1][9] , \FIFO[1][8] , \FIFO[1][7] , \FIFO[1][6] , \FIFO[1][5] ,
         \FIFO[1][4] , \FIFO[1][3] , \FIFO[1][2] , \FIFO[1][1] , \FIFO[1][0] ,
         \FIFO[2][9] , \FIFO[2][8] , \FIFO[2][7] , \FIFO[2][6] , \FIFO[2][5] ,
         \FIFO[2][4] , \FIFO[2][3] , \FIFO[2][2] , \FIFO[2][1] , \FIFO[2][0] ,
         \FIFO[3][9] , \FIFO[3][8] , \FIFO[3][7] , \FIFO[3][6] , \FIFO[3][5] ,
         \FIFO[3][4] , \FIFO[3][3] , \FIFO[3][2] , \FIFO[3][1] , \FIFO[3][0] ,
         \FIFO[4][9] , \FIFO[4][8] , \FIFO[4][7] , \FIFO[4][6] , \FIFO[4][5] ,
         \FIFO[4][4] , \FIFO[4][3] , \FIFO[4][2] , \FIFO[4][1] , \FIFO[4][0] ,
         \FIFO[5][9] , \FIFO[5][8] , \FIFO[5][7] , \FIFO[5][6] , \FIFO[5][5] ,
         \FIFO[5][4] , \FIFO[5][3] , \FIFO[5][2] , \FIFO[5][1] , \FIFO[5][0] ,
         \FIFO[6][9] , \FIFO[6][8] , \FIFO[6][7] , \FIFO[6][6] , \FIFO[6][5] ,
         \FIFO[6][4] , \FIFO[6][3] , \FIFO[6][2] , \FIFO[6][1] , \FIFO[6][0] ,
         \FIFO[7][9] , \FIFO[7][8] , \FIFO[7][7] , \FIFO[7][6] , \FIFO[7][5] ,
         \FIFO[7][4] , \FIFO[7][3] , \FIFO[7][2] , \FIFO[7][1] , \FIFO[7][0] ,
         \FIFO[8][9] , \FIFO[8][8] , \FIFO[8][7] , \FIFO[8][6] , \FIFO[8][5] ,
         \FIFO[8][4] , \FIFO[8][3] , \FIFO[8][2] , \FIFO[8][1] , \FIFO[8][0] ,
         \FIFO[9][9] , \FIFO[9][8] , \FIFO[9][7] , \FIFO[9][6] , \FIFO[9][5] ,
         \FIFO[9][4] , \FIFO[9][3] , \FIFO[9][2] , \FIFO[9][1] , \FIFO[9][0] ,
         \FIFO[10][9] , \FIFO[10][8] , \FIFO[10][7] , \FIFO[10][6] ,
         \FIFO[10][5] , \FIFO[10][4] , \FIFO[10][3] , \FIFO[10][2] ,
         \FIFO[10][1] , \FIFO[10][0] , \FIFO[11][9] , \FIFO[11][8] ,
         \FIFO[11][7] , \FIFO[11][6] , \FIFO[11][5] , \FIFO[11][4] ,
         \FIFO[11][3] , \FIFO[11][2] , \FIFO[11][1] , \FIFO[11][0] ,
         \FIFO[12][9] , \FIFO[12][8] , \FIFO[12][7] , \FIFO[12][6] ,
         \FIFO[12][5] , \FIFO[12][4] , \FIFO[12][3] , \FIFO[12][2] ,
         \FIFO[12][1] , \FIFO[12][0] , \FIFO[13][9] , \FIFO[13][8] ,
         \FIFO[13][7] , \FIFO[13][6] , \FIFO[13][5] , \FIFO[13][4] ,
         \FIFO[13][3] , \FIFO[13][2] , \FIFO[13][1] , \FIFO[13][0] ,
         \FIFO[14][9] , \FIFO[14][8] , \FIFO[14][7] , \FIFO[14][6] ,
         \FIFO[14][5] , \FIFO[14][4] , \FIFO[14][3] , \FIFO[14][2] ,
         \FIFO[14][1] , \FIFO[14][0] , \FIFO[15][9] , \FIFO[15][8] ,
         \FIFO[15][7] , \FIFO[15][6] , \FIFO[15][5] , \FIFO[15][4] ,
         \FIFO[15][3] , \FIFO[15][2] , \FIFO[15][1] , \FIFO[15][0] , WrCnt_3_,
         WrCnt_2_, WrCnt_1_, WrCnt_0_, FIFO232, FIFO2320, FIFO2321, FIFO2322,
         FIFO2323, FIFO2324, FIFO2325, FIFO2326, FIFO2327, FIFO2328, FIFO2329,
         FIFO23210, FIFO23211, FIFO23212, FIFO23213, FIFO23214, FIFO23215,
         FIFO23216, FIFO23217, FIFO23218, FIFO23219, FIFO23220, FIFO23221,
         FIFO23222, FIFO23223, FIFO23224, FIFO23225, FIFO23226, FIFO23227,
         FIFO23228, FIFO23229, FIFO23230, FIFO23231, FIFO23232, FIFO23233,
         FIFO23234, FIFO23235, FIFO23236, FIFO23237, FIFO23238, FIFO23239,
         FIFO23240, FIFO23241, FIFO23242, FIFO23243, FIFO23244, FIFO23245,
         FIFO23246, FIFO23247, FIFO23248, FIFO23249, FIFO23250, FIFO23251,
         FIFO23252, FIFO23253, FIFO23254, FIFO23255, FIFO23256, FIFO23257,
         FIFO23258, FIFO23259, FIFO23260, FIFO23261, FIFO23262, FIFO23263,
         FIFO23264, FIFO23265, FIFO23266, FIFO23267, FIFO23268, FIFO23269,
         FIFO23270, FIFO23271, FIFO23272, FIFO23273, FIFO23274, FIFO23275,
         FIFO23276, FIFO23277, FIFO23278, FIFO23279, FIFO23280, FIFO23281,
         FIFO23282, FIFO23283, FIFO23284, FIFO23285, FIFO23286, FIFO23287,
         FIFO23288, FIFO23289, FIFO23290, FIFO23291, FIFO23292, FIFO23293,
         FIFO23294, FIFO23295, FIFO23296, FIFO23297, FIFO23298, FIFO23299,
         FIFO232100, FIFO232101, FIFO232102, FIFO232103, FIFO232104,
         FIFO232105, FIFO232106, FIFO232107, FIFO232108, FIFO232109,
         FIFO232110, FIFO232111, FIFO232112, FIFO232113, FIFO232114,
         FIFO232115, FIFO232116, FIFO232117, FIFO232118, FIFO232119,
         FIFO232120, FIFO232121, FIFO232122, FIFO232123, FIFO232124,
         FIFO232125, FIFO232126, FIFO232127, FIFO232128, FIFO232129,
         FIFO232130, FIFO232131, FIFO232132, FIFO232133, FIFO232134,
         FIFO232135, FIFO232136, FIFO232137, FIFO232138, FIFO232139,
         FIFO232140, FIFO232141, FIFO232142, FIFO232143, FIFO232144,
         FIFO232145, FIFO232146, FIFO232147, FIFO232148, FIFO232149,
         FIFO232150, FIFO232151, FIFO232152, FIFO232153, FIFO232154,
         FIFO232155, FIFO232156, FIFO232157, FIFO232158, n1768, n1769, n1770,
         n1771, n1772, n1773, n1774, n1775, n1776, n1777, n1778, n1779, n1780,
         n1781, n1782, n1783, n1784, n1785, n1786, n1787, n1788, n1789, n1790,
         n1791, n1792, n1839, n1841, n1843, n1846, n1861, n1864, n1865, n1867,
         n1868, n1870, n1871, n1872, n1874, n1875, n1876, n1878, n1879, n1881,
         n1882, n1883, n1884, n1885, n1886, n1887, n1888, n1890, n1892, n1893,
         n1895, n1897, n1899, n1901, n1902, n1904, n1906, n1908, n1910, n1911,
         n1913, n1915, n1917, n1919, n1921, n1923, n1924, n1925, n1926, n1929,
         n1934, n1939, n1944, n1947, n1948, n1949, n1950, n1953, n1958, n1963,
         n1968, n1971, n1972, n1973, n1974, n1977, n1982, n1987, n1992, n1995,
         n1996, n1997, n1998, n2001, n2006, n2011, n2016, n2019, n2020, n2021,
         n2022, n2025, n2030, n2035, n2040, n2043, n2044, n2045, n2046, n2049,
         n2054, n2059, n2064, n2067, n2068, n2069, n2070, n2073, n2078, n2083,
         n2088, n2091, n2092, n2093, n2094, n2097, n2102, n2107, n2112, n2115,
         n2116, n2117, n2118, n2121, n2124, n2125, n2128, n2132, n2136, n2139,
         n2140, n2143, n2146, n2151, n2152, n2153, n2154, n2155, n2156, n2157,
         n2158, n2159, n2160, n2161, n2162, n2163, n2164, n2165, n2166, n2167,
         n2168, n2169, n2170, n2171, n2172, n2173, n2174, n2175, n2176, n2177,
         n2178, n2179, n2180, n2181, n2182, n2183, n2184, n2185, n2186, n2187,
         n2188, n2189, n2190, n2191, n2192, n2193, n2194, n2195, n2196, n2197,
         n2198, n2199, n2200, n2201, n2202, n2203, n2204, n2205, n2206, n2207,
         n2208, n2209, n2210, n2211, n2212, n2213, n2214, n2215, n2216, n2217,
         n2218, n2219, n2220, n2221, n2222, n2223, n2224, n2225, n2226, n2227,
         n2228, n2229, n2230, n2231, n2232, n2233, n2234, n2235, n2236, n2237,
         n2238, n2239, n2240, n2241, n2242, n2243, n2244, n2245, n2246, n2247,
         n2248, n2249, n2250, n2251, n2252, n2253, n2254, n2255, n2256, n2257,
         n2258, n2259, n2260, n2261, n2262, n2263, n2264, n2265, n2266, n2267,
         n2268, n2269, n2270, n2271, n2272, n2273, n2274, n2275, n2276, n2277,
         n2278, n2280, n2281, n2282, n2283, n2284, n2285, n2286, n2287, n2288,
         n2289, n2290, n2292, n2294, n2295, n2296, n2297, n2298, n2299, n2300,
         n2301, n2302, n2303, n2304, n2305, n2306, n2307, n2308, n2309, n2310,
         n2311, n2312, n2313, n2314, n2315, n2316, n2317, n2318, n2319, n2320,
         n2321, n2322, n2323, n2324, n2325, n2326, n2327, n2328, n2329, n2330,
         n2331, n2332, n2333, n2334, n2335, n2336, n2337, n2338, n2339, n2340,
         n2341, n2342, n2343, n2344, n2345, n2346, n2347, n2348, n2349, n2350,
         n2351, n2352, n2353, n2354, n2355, n2356, n2357, n2358, n2359, n2360,
         n2361, n2362, n2363, n2364, n2365, n2366, n2367, n2368, n2369, n2370,
         n2371, n2372, n2373, n2374, n2375, n2376, n2377, n2378, n2379, n2380,
         n2381, n2382, n2383, n2384, n2385, n2386, n2387, n2388, n2389, n2390,
         n2391, n2392, n2393, n2394, n2395, n2396, n2397, n2398, n2399, n2400,
         n2401, n2402, n2403, n2404, n2405, n2406, n2407, n2408, n2409, n2410,
         n2411, n2412, n2413, n2414, n2415, n2416, n2417, n2418, n2419, n2420,
         n2421, n2422, n2423, n2424, n2425, n2426, n2427, n2428, n2429, n2430,
         n2431, n2432, n2433, n2434, n2435, n2436, n2437, n2438, n2439, n2440,
         n2441, n2442, n2443, n2444, n2445, n2446, n2447, n2448, n2449, n2450,
         n2451, n2452, n2453, n2454, n2455, n2456, n2457, n2458, n2459, n2460,
         n2461, n2462, n2463, n2464, n2465, n2466, n2467, n2468, n2469, n2470,
         n2471, n2472, n2473, n2474, n2475, n2476, n2477, n2478, n2479, n2480,
         n2481, n2482, n2483, n2484, n2485, n2486, n2487, n2488, n2489, n2490,
         n2491, n2492, n2493, n2494, n2495, n2496, n2497, n2498, n2499, n2500,
         n2501, n2502, n2503, n2504, n2505, n2506, n2507, n2508, n2509, n2510,
         n2511, n2512, n2513, n2514, n2515, n2516, n2517, n2518, n2519;
  wire   [3:0] RdCnt;

  INVX4 U1825 ( .A(WriteEn), .Y(n1874) );
  INVX4 U1826 ( .A(n1846), .Y(n2294) );
  INVX2 U1827 ( .A(n2294), .Y(n2295) );
  INVX4 U1828 ( .A(n2294), .Y(n2297) );
  INVX1 U1829 ( .A(n2294), .Y(n2296) );
  OR2X4 U1830 ( .A(n1861), .B(n1839), .Y(n1841) );
  NAND3X1 U1831 ( .A(n2477), .B(n2478), .C(n2479), .Y(n1790) );
  OR2X1 U1832 ( .A(n2482), .B(n1843), .Y(n2477) );
  OAI221X1 U1833 ( .A0(WriteEn), .A1(n2468), .B0(n1874), .B1(n1875), .C0(n1876), .Y(n1770) );
  DFFRX1 DatCnt_reg_2_ ( .D(n1790), .CK(Clk), .RN(nRST), .QN(n2323) );
  OR2X1 U1834 ( .A(n1841), .B(n2474), .Y(n2478) );
  OR2X1 U1835 ( .A(n2297), .B(n2323), .Y(n2479) );
  INVX2 U1836 ( .A(n1839), .Y(n1846) );
  NAND2X1 U1837 ( .A(n1861), .B(n1874), .Y(n2480) );
  NAND2X1 U1838 ( .A(ReadEn), .B(WriteEn), .Y(n2481) );
  NAND2X2 U1839 ( .A(n2480), .B(n2481), .Y(n1839) );
  NAND2BX4 U1840 ( .AN(ReadEn), .B(n2295), .Y(n1843) );
  NAND2BX1 U1841 ( .AN(n1874), .B(n1883), .Y(n1878) );
  NAND2BX1 U1842 ( .AN(n1861), .B(n1872), .Y(n1867) );
  INVX1 U1843 ( .A(ReadEn), .Y(n1861) );
  INVX1 U1844 ( .A(n2163), .Y(n2164) );
  INVX1 U1845 ( .A(n2186), .Y(n2187) );
  INVX1 U1846 ( .A(n2166), .Y(n2167) );
  INVX1 U1847 ( .A(n2510), .Y(n2165) );
  INVX1 U1848 ( .A(n2184), .Y(n2185) );
  INVX1 U1849 ( .A(n2168), .Y(n2169) );
  INVX1 U1850 ( .A(n2151), .Y(n2152) );
  INVX1 U1851 ( .A(n2182), .Y(n2183) );
  XOR2X1 U1852 ( .A(n2467), .B(n1878), .Y(n1769) );
  OAI222X1 U1853 ( .A0(n1843), .A1(n2298), .B0(n1841), .B1(n2483), .C0(n2296), 
        .C1(n2322), .Y(n1778) );
  OAI222X1 U1854 ( .A0(n1843), .A1(n2471), .B0(n1841), .B1(n2322), .C0(n2297), 
        .C1(n2298), .Y(n1779) );
  OAI222X1 U1855 ( .A0(n1843), .A1(n2319), .B0(n1841), .B1(n2298), .C0(n2296), 
        .C1(n2471), .Y(n1780) );
  OAI222X1 U1856 ( .A0(n1843), .A1(n2394), .B0(n1841), .B1(n2471), .C0(n2297), 
        .C1(n2319), .Y(n1781) );
  OAI222X1 U1857 ( .A0(n1843), .A1(n2472), .B0(n1841), .B1(n2319), .C0(n2297), 
        .C1(n2394), .Y(n1782) );
  OAI222X1 U1858 ( .A0(n1843), .A1(n2320), .B0(n1841), .B1(n2394), .C0(n2296), 
        .C1(n2472), .Y(n1783) );
  OAI222X1 U1859 ( .A0(n1843), .A1(n2395), .B0(n1841), .B1(n2472), .C0(n2296), 
        .C1(n2320), .Y(n1784) );
  OAI222X1 U1860 ( .A0(n1843), .A1(n2473), .B0(n1841), .B1(n2320), .C0(n2297), 
        .C1(n2395), .Y(n1785) );
  OAI222X1 U1861 ( .A0(n1843), .A1(n2321), .B0(n1841), .B1(n2395), .C0(n2296), 
        .C1(n2473), .Y(n1786) );
  OAI222X1 U1862 ( .A0(n1843), .A1(n2396), .B0(n1841), .B1(n2473), .C0(n2297), 
        .C1(n2321), .Y(n1787) );
  OAI222X1 U1863 ( .A0(n1843), .A1(n2474), .B0(n1841), .B1(n2321), .C0(n2296), 
        .C1(n2396), .Y(n1788) );
  OAI222X1 U1864 ( .A0(n2323), .A1(n1843), .B0(n1841), .B1(n2396), .C0(n2297), 
        .C1(n2474), .Y(n1789) );
  OAI221X1 U1865 ( .A0(n1879), .A1(n2487), .B0(n1874), .B1(n2511), .C0(n1882), 
        .Y(n1768) );
  INVX1 U1866 ( .A(n1878), .Y(n1879) );
  OR4X1 U1867 ( .A(n1995), .B(n1996), .C(n1997), .D(n1998), .Y(RdData[5]) );
  OAI221X1 U1868 ( .A0(n1915), .A1(n2440), .B0(n1917), .B1(n2371), .C0(n2016), 
        .Y(n1995) );
  NAND2BX1 U1869 ( .AN(n2146), .B(n1872), .Y(n1870) );
  NAND2BX1 U1870 ( .AN(n1871), .B(n1872), .Y(n1893) );
  NAND2BX1 U1871 ( .AN(n1864), .B(n2484), .Y(n1902) );
  NAND2BX1 U1872 ( .AN(n2140), .B(n1872), .Y(n1911) );
  NAND2BX1 U1873 ( .AN(n1865), .B(n2124), .Y(n1895) );
  NAND2BX1 U1874 ( .AN(n2125), .B(n2484), .Y(n1904) );
  NAND2BX1 U1875 ( .AN(n1865), .B(n2139), .Y(n1913) );
  OR2X1 U1876 ( .A(n2146), .B(n1865), .Y(n1921) );
  OR4X1 U1877 ( .A(n2019), .B(n2020), .C(n2021), .D(n2022), .Y(RdData[4]) );
  OAI221X1 U1878 ( .A0(n1915), .A1(n2441), .B0(n1917), .B1(n2372), .C0(n2040), 
        .Y(n2019) );
  OAI221X1 U1879 ( .A0(n1906), .A1(n2422), .B0(n1908), .B1(n2368), .C0(n2035), 
        .Y(n2020) );
  OR4X1 U1880 ( .A(n2115), .B(n2116), .C(n2117), .D(n2118), .Y(RdData[0]) );
  OAI221X1 U1881 ( .A0(n1915), .A1(n2445), .B0(n1917), .B1(n2332), .C0(n2143), 
        .Y(n2115) );
  OAI221X1 U1882 ( .A0(n1906), .A1(n2299), .B0(n1908), .B1(n2433), .C0(n2136), 
        .Y(n2116) );
  OAI221X1 U1883 ( .A0(n1897), .A1(n2326), .B0(n1899), .B1(n2429), .C0(n2128), 
        .Y(n2117) );
  OR2X1 U1884 ( .A(n2146), .B(n2125), .Y(n1917) );
  NAND2BX1 U1885 ( .AN(n2125), .B(n2139), .Y(n1908) );
  NAND2BX1 U1886 ( .AN(n2125), .B(n2124), .Y(n1890) );
  NAND2BX1 U1887 ( .AN(n1865), .B(n2484), .Y(n1899) );
  NAND2BX1 U1888 ( .AN(n1864), .B(n2139), .Y(n1906) );
  NAND2BX1 U1889 ( .AN(n1864), .B(n2124), .Y(n1888) );
  NAND2BX1 U1890 ( .AN(n2132), .B(n2484), .Y(n1897) );
  OR4X1 U1891 ( .A(n2043), .B(n2044), .C(n2045), .D(n2046), .Y(RdData[3]) );
  OAI221X1 U1892 ( .A0(n1915), .A1(n2442), .B0(n1917), .B1(n2331), .C0(n2064), 
        .Y(n2043) );
  OAI221X1 U1893 ( .A0(n1906), .A1(n2398), .B0(n1908), .B1(n2329), .C0(n2059), 
        .Y(n2044) );
  OAI221X1 U1894 ( .A0(n1897), .A1(n2325), .B0(n1899), .B1(n2400), .C0(n2054), 
        .Y(n2045) );
  OR4X1 U1895 ( .A(n2067), .B(n2068), .C(n2069), .D(n2070), .Y(RdData[2]) );
  OAI221X1 U1896 ( .A0(n1915), .A1(n2443), .B0(n1917), .B1(n2373), .C0(n2088), 
        .Y(n2067) );
  OAI221X1 U1897 ( .A0(n1906), .A1(n2311), .B0(n1908), .B1(n2431), .C0(n2083), 
        .Y(n2068) );
  OAI221X1 U1898 ( .A0(n1897), .A1(n2364), .B0(n1899), .B1(n2427), .C0(n2078), 
        .Y(n2069) );
  OR4X1 U1899 ( .A(n2091), .B(n2092), .C(n2093), .D(n2094), .Y(RdData[1]) );
  OAI221X1 U1900 ( .A0(n1915), .A1(n2444), .B0(n1917), .B1(n2374), .C0(n2112), 
        .Y(n2091) );
  OAI221X1 U1901 ( .A0(n1906), .A1(n2312), .B0(n1908), .B1(n2432), .C0(n2107), 
        .Y(n2092) );
  OAI221X1 U1902 ( .A0(n1897), .A1(n2365), .B0(n1899), .B1(n2428), .C0(n2102), 
        .Y(n2093) );
  OR4X1 U1903 ( .A(n1923), .B(n1924), .C(n1925), .D(n1926), .Y(RdData[8]) );
  OR4X1 U1904 ( .A(n1884), .B(n1885), .C(n1886), .D(n1887), .Y(RdData[9]) );
  OAI221X1 U1905 ( .A0(n1915), .A1(n2438), .B0(n1917), .B1(n2330), .C0(n1944), 
        .Y(n1923) );
  OAI221X1 U1906 ( .A0(n1906), .A1(n2310), .B0(n1908), .B1(n2430), .C0(n1910), 
        .Y(n1885) );
  OA22X1 U1907 ( .A0(n1911), .A1(n2403), .B0(n1913), .B1(n2338), .Y(n1910) );
  OAI221X1 U1908 ( .A0(n1906), .A1(n2421), .B0(n1908), .B1(n2367), .C0(n2011), 
        .Y(n1996) );
  OA22X1 U1909 ( .A0(n1911), .A1(n2303), .B0(n1913), .B1(n2451), .Y(n2011) );
  OAI221X1 U1910 ( .A0(n1888), .A1(n2434), .B0(n1890), .B1(n2334), .C0(n1892), 
        .Y(n1887) );
  OA22X1 U1911 ( .A0(n1893), .A1(n2410), .B0(n1895), .B1(n2337), .Y(n1892) );
  OAI221X1 U1912 ( .A0(n1888), .A1(n2435), .B0(n1890), .B1(n2380), .C0(n2073), 
        .Y(n2070) );
  OA22X1 U1913 ( .A0(n1893), .A1(n2414), .B0(n1895), .B1(n2342), .Y(n2073) );
  OAI221X1 U1914 ( .A0(n1888), .A1(n2301), .B0(n1890), .B1(n2336), .C0(n2049), 
        .Y(n2046) );
  OA22X1 U1915 ( .A0(n1893), .A1(n2413), .B0(n1895), .B1(n2341), .Y(n2049) );
  OAI221X1 U1916 ( .A0(n1888), .A1(n2314), .B0(n1890), .B1(n2378), .C0(n2001), 
        .Y(n1998) );
  OA22X1 U1917 ( .A0(n1893), .A1(n2412), .B0(n1895), .B1(n2340), .Y(n2001) );
  OAI221X1 U1918 ( .A0(n1888), .A1(n2436), .B0(n1890), .B1(n2381), .C0(n2097), 
        .Y(n2094) );
  OA22X1 U1919 ( .A0(n1893), .A1(n2415), .B0(n1895), .B1(n2344), .Y(n2097) );
  OAI221X1 U1920 ( .A0(n1897), .A1(n2324), .B0(n1899), .B1(n2399), .C0(n1934), 
        .Y(n1925) );
  OA22X1 U1921 ( .A0(n1902), .A1(n2407), .B0(n1904), .B1(n2349), .Y(n1934) );
  OAI221X1 U1922 ( .A0(n1915), .A1(n2437), .B0(n1917), .B1(n2369), .C0(n1919), 
        .Y(n1884) );
  OA22X1 U1923 ( .A0(n1870), .A1(n2417), .B0(n1921), .B1(n2348), .Y(n1919) );
  OA22X1 U1924 ( .A0(n1870), .A1(n2418), .B0(n1921), .B1(n2350), .Y(n1944) );
  OA22X1 U1925 ( .A0(n1902), .A1(n2357), .B0(n1904), .B1(n2307), .Y(n2078) );
  OA22X1 U1926 ( .A0(n1911), .A1(n2447), .B0(n1913), .B1(n2343), .Y(n2083) );
  OA22X1 U1927 ( .A0(n1870), .A1(n2463), .B0(n1921), .B1(n2390), .Y(n2088) );
  OA22X1 U1928 ( .A0(n1902), .A1(n2408), .B0(n1904), .B1(n2353), .Y(n2054) );
  OA22X1 U1929 ( .A0(n1911), .A1(n2304), .B0(n1913), .B1(n2406), .Y(n2059) );
  OA22X1 U1930 ( .A0(n1870), .A1(n2419), .B0(n1921), .B1(n2354), .Y(n2064) );
  OAI221X1 U1931 ( .A0(n1897), .A1(n2423), .B0(n1899), .B1(n2327), .C0(n1901), 
        .Y(n1886) );
  OA22X1 U1932 ( .A0(n1902), .A1(n2356), .B0(n1904), .B1(n2306), .Y(n1901) );
  OAI221X1 U1933 ( .A0(n1888), .A1(n2300), .B0(n1890), .B1(n2335), .C0(n1929), 
        .Y(n1926) );
  OA22X1 U1934 ( .A0(n1893), .A1(n2411), .B0(n1895), .B1(n2339), .Y(n1929) );
  OAI221X1 U1935 ( .A0(n1906), .A1(n2397), .B0(n1908), .B1(n2328), .C0(n1939), 
        .Y(n1924) );
  OA22X1 U1936 ( .A0(n1911), .A1(n2302), .B0(n1913), .B1(n2405), .Y(n1939) );
  OA22X1 U1937 ( .A0(n1902), .A1(n2409), .B0(n1904), .B1(n2355), .Y(n2128) );
  OA22X1 U1938 ( .A0(n1911), .A1(n2404), .B0(n1913), .B1(n2347), .Y(n2136) );
  OA22X1 U1939 ( .A0(n1870), .A1(n2359), .B0(n1921), .B1(n2309), .Y(n2143) );
  OA22X1 U1940 ( .A0(n1902), .A1(n2358), .B0(n1904), .B1(n2308), .Y(n2102) );
  OA22X1 U1941 ( .A0(n1911), .A1(n2448), .B0(n1913), .B1(n2345), .Y(n2107) );
  OA22X1 U1942 ( .A0(n1870), .A1(n2464), .B0(n1921), .B1(n2391), .Y(n2112) );
  OAI221X1 U1943 ( .A0(n1888), .A1(n2333), .B0(n1890), .B1(n2449), .C0(n2121), 
        .Y(n2118) );
  OA22X1 U1944 ( .A0(n1893), .A1(n2416), .B0(n1895), .B1(n2346), .Y(n2121) );
  OAI221X1 U1945 ( .A0(n1897), .A1(n2362), .B0(n1899), .B1(n2425), .C0(n2006), 
        .Y(n1997) );
  OA22X1 U1946 ( .A0(n1902), .A1(n2455), .B0(n1904), .B1(n2351), .Y(n2006) );
  INVX1 U1947 ( .A(n2132), .Y(n1872) );
  INVX1 U1948 ( .A(n1871), .Y(n2124) );
  INVX1 U1949 ( .A(n2140), .Y(n2139) );
  OR4X1 U1950 ( .A(n1971), .B(n1972), .C(n1973), .D(n1974), .Y(RdData[6]) );
  OAI221X1 U1951 ( .A0(n1915), .A1(n2439), .B0(n1917), .B1(n2370), .C0(n1992), 
        .Y(n1971) );
  OAI221X1 U1952 ( .A0(n1906), .A1(n2420), .B0(n1908), .B1(n2366), .C0(n1987), 
        .Y(n1972) );
  OR4X1 U1953 ( .A(n1947), .B(n1948), .C(n1949), .D(n1950), .Y(RdData[7]) );
  OAI221X1 U1954 ( .A0(n1915), .A1(n2469), .B0(n1917), .B1(n2393), .C0(n1968), 
        .Y(n1947) );
  OAI221X1 U1955 ( .A0(n1888), .A1(n2313), .B0(n1890), .B1(n2377), .C0(n1977), 
        .Y(n1974) );
  OA22X1 U1956 ( .A0(n1893), .A1(n2458), .B0(n1895), .B1(n2384), .Y(n1977) );
  OAI221X1 U1957 ( .A0(n1888), .A1(n2315), .B0(n1890), .B1(n2379), .C0(n2025), 
        .Y(n2022) );
  OA22X1 U1958 ( .A0(n1893), .A1(n2459), .B0(n1895), .B1(n2305), .Y(n2025) );
  OAI221X1 U1959 ( .A0(n1897), .A1(n2361), .B0(n1899), .B1(n2424), .C0(n1982), 
        .Y(n1973) );
  OA22X1 U1960 ( .A0(n1902), .A1(n2454), .B0(n1904), .B1(n2386), .Y(n1982) );
  OAI221X1 U1961 ( .A0(n1897), .A1(n2363), .B0(n1899), .B1(n2426), .C0(n2030), 
        .Y(n2021) );
  OA22X1 U1962 ( .A0(n1902), .A1(n2456), .B0(n1904), .B1(n2352), .Y(n2030) );
  OA22X1 U1963 ( .A0(n1870), .A1(n2461), .B0(n1921), .B1(n2388), .Y(n2016) );
  OA22X1 U1964 ( .A0(n1911), .A1(n2316), .B0(n1913), .B1(n2450), .Y(n1987) );
  OA22X1 U1965 ( .A0(n1870), .A1(n2460), .B0(n1921), .B1(n2387), .Y(n1992) );
  OA22X1 U1966 ( .A0(n1911), .A1(n2376), .B0(n1913), .B1(n2452), .Y(n2035) );
  OA22X1 U1967 ( .A0(n1870), .A1(n2462), .B0(n1921), .B1(n2389), .Y(n2040) );
  OR2X1 U1968 ( .A(n1864), .B(n2146), .Y(n1915) );
  OAI221X1 U1969 ( .A0(n1906), .A1(n2318), .B0(n1908), .B1(n2466), .C0(n1963), 
        .Y(n1948) );
  OA22X1 U1970 ( .A0(n1911), .A1(n2446), .B0(n1913), .B1(n2383), .Y(n1963) );
  OAI221X1 U1971 ( .A0(n1888), .A1(n2375), .B0(n1890), .B1(n2470), .C0(n1953), 
        .Y(n1950) );
  OA22X1 U1972 ( .A0(n1893), .A1(n2457), .B0(n1895), .B1(n2382), .Y(n1953) );
  OAI221X1 U1973 ( .A0(n1897), .A1(n2360), .B0(n1899), .B1(n2465), .C0(n1958), 
        .Y(n1949) );
  OA22X1 U1974 ( .A0(n1902), .A1(n2453), .B0(n1904), .B1(n2385), .Y(n1958) );
  OA22X1 U1975 ( .A0(n1870), .A1(n2392), .B0(n1921), .B1(n2317), .Y(n1968) );
  OAI221X1 U1976 ( .A0(n1868), .A1(n2485), .B0(n1861), .B1(n1870), .C0(n1871), 
        .Y(n1772) );
  INVX1 U1977 ( .A(n1867), .Y(n1868) );
  OAI221X1 U1978 ( .A0(ReadEn), .A1(n2401), .B0(n1861), .B1(n1864), .C0(n1865), 
        .Y(n1774) );
  NAND2BX1 U1979 ( .AN(n2282), .B(n1883), .Y(n2511) );
  NAND2BX1 U1980 ( .AN(n1875), .B(n2288), .Y(n2503) );
  NAND2BX1 U1981 ( .AN(n1882), .B(n1883), .Y(n2497) );
  NAND2BX1 U1982 ( .AN(n1875), .B(n2486), .Y(n2519) );
  NAND2BX1 U1983 ( .AN(n1875), .B(n2280), .Y(n2517) );
  NAND2BX1 U1984 ( .AN(n2282), .B(n2289), .Y(n2501) );
  NAND2BX1 U1985 ( .AN(n1882), .B(n2283), .Y(n2509) );
  NAND2BX1 U1986 ( .AN(n2285), .B(n2486), .Y(n2495) );
  NAND2BX1 U1987 ( .AN(n2282), .B(n1883), .Y(n1881) );
  NAND2BX1 U1988 ( .AN(n1875), .B(n2288), .Y(n2502) );
  NAND2BX1 U1989 ( .AN(n1875), .B(n2486), .Y(n2518) );
  NAND2BX1 U1990 ( .AN(n1882), .B(n1883), .Y(n2496) );
  NAND2BX1 U1991 ( .AN(n1875), .B(n2280), .Y(n2516) );
  NAND2BX1 U1992 ( .AN(n1882), .B(n2283), .Y(n2508) );
  NAND2BX1 U1993 ( .AN(n2282), .B(n2289), .Y(n2500) );
  NAND2BX1 U1994 ( .AN(n2285), .B(n2486), .Y(n2494) );
  XOR2X1 U1995 ( .A(n2402), .B(n1867), .Y(n1773) );
  NAND2BX1 U1996 ( .AN(n2282), .B(n2283), .Y(n2512) );
  NAND2BX1 U1997 ( .AN(n2282), .B(n2283), .Y(n2513) );
  NAND2BX1 U1998 ( .AN(n1882), .B(n2289), .Y(n2490) );
  NAND2BX1 U1999 ( .AN(n1882), .B(n2289), .Y(n2491) );
  NAND2BX1 U2000 ( .AN(n1876), .B(n2281), .Y(n2498) );
  NAND2BX1 U2001 ( .AN(n1876), .B(n2281), .Y(n2499) );
  NAND2BX1 U2002 ( .AN(n2286), .B(n2486), .Y(n2504) );
  NAND2BX1 U2003 ( .AN(n2286), .B(n2486), .Y(n2505) );
  NAND2BX1 U2004 ( .AN(n1875), .B(n2281), .Y(n2514) );
  NAND2BX1 U2005 ( .AN(n2285), .B(n2281), .Y(n2488) );
  NAND2BX1 U2006 ( .AN(n2285), .B(n2281), .Y(n2489) );
  NAND2BX1 U2007 ( .AN(n1875), .B(n2281), .Y(n2515) );
  NAND2BX1 U2008 ( .AN(n1876), .B(n2486), .Y(n2506) );
  NAND2BX1 U2009 ( .AN(n1876), .B(n2486), .Y(n2507) );
  NAND2BX1 U2010 ( .AN(n2292), .B(n1883), .Y(n2492) );
  NAND2BX1 U2011 ( .AN(n2292), .B(n1883), .Y(n2493) );
  INVX1 U2012 ( .A(n2286), .Y(n1883) );
  INVX1 U2013 ( .A(n2292), .Y(n2281) );
  INVX1 U2014 ( .A(n1876), .Y(n2289) );
  INVX1 U2015 ( .A(n2285), .Y(n2283) );
  INVX1 U2016 ( .A(n1882), .Y(n2280) );
  INVX1 U2017 ( .A(n2282), .Y(n2288) );
  OAI221X1 U2018 ( .A0(n2369), .A1(n2513), .B0(n2310), .B1(n2515), .C0(n2197), 
        .Y(n2196) );
  OA22X1 U2019 ( .A0(n2434), .A1(n2516), .B0(n2356), .B1(n2518), .Y(n2197) );
  OAI221X1 U2020 ( .A0(n2330), .A1(n2513), .B0(n2397), .B1(n2515), .C0(n2206), 
        .Y(n2205) );
  OA22X1 U2021 ( .A0(n2300), .A1(n2517), .B0(n2407), .B1(n2519), .Y(n2206) );
  OAI221X1 U2022 ( .A0(n2393), .A1(n2512), .B0(n2318), .B1(n2514), .C0(n2215), 
        .Y(n2214) );
  OA22X1 U2023 ( .A0(n2375), .A1(n2516), .B0(n2453), .B1(n2518), .Y(n2215) );
  OAI221X1 U2024 ( .A0(n2370), .A1(n2512), .B0(n2420), .B1(n2514), .C0(n2224), 
        .Y(n2223) );
  OA22X1 U2025 ( .A0(n2313), .A1(n2516), .B0(n2454), .B1(n2518), .Y(n2224) );
  OAI221X1 U2026 ( .A0(n2371), .A1(n2513), .B0(n2421), .B1(n2515), .C0(n2233), 
        .Y(n2232) );
  OA22X1 U2027 ( .A0(n2314), .A1(n2517), .B0(n2455), .B1(n2519), .Y(n2233) );
  OAI221X1 U2028 ( .A0(n2372), .A1(n2512), .B0(n2422), .B1(n2514), .C0(n2242), 
        .Y(n2241) );
  OA22X1 U2029 ( .A0(n2315), .A1(n2517), .B0(n2456), .B1(n2519), .Y(n2242) );
  OAI221X1 U2030 ( .A0(n2331), .A1(n2512), .B0(n2398), .B1(n2514), .C0(n2251), 
        .Y(n2250) );
  OA22X1 U2031 ( .A0(n2301), .A1(n2516), .B0(n2408), .B1(n2518), .Y(n2251) );
  OAI221X1 U2032 ( .A0(n2373), .A1(n2513), .B0(n2311), .B1(n2515), .C0(n2260), 
        .Y(n2259) );
  OA22X1 U2033 ( .A0(n2435), .A1(n2517), .B0(n2357), .B1(n2519), .Y(n2260) );
  OAI221X1 U2034 ( .A0(n2374), .A1(n2513), .B0(n2312), .B1(n2515), .C0(n2269), 
        .Y(n2268) );
  OA22X1 U2035 ( .A0(n2436), .A1(n2516), .B0(n2358), .B1(n2518), .Y(n2269) );
  OAI221X1 U2036 ( .A0(n2332), .A1(n2512), .B0(n2299), .B1(n2514), .C0(n2278), 
        .Y(n2277) );
  OA22X1 U2037 ( .A0(n2333), .A1(n2516), .B0(n2409), .B1(n2518), .Y(n2278) );
  OAI221X1 U2038 ( .A0(n2423), .A1(n2505), .B0(n2327), .B1(n2507), .C0(n2198), 
        .Y(n2195) );
  OA22X1 U2039 ( .A0(n2334), .A1(n2508), .B0(n2511), .B1(n2417), .Y(n2198) );
  OAI221X1 U2040 ( .A0(n2324), .A1(n2505), .B0(n2399), .B1(n2507), .C0(n2207), 
        .Y(n2204) );
  OA22X1 U2041 ( .A0(n2335), .A1(n2509), .B0(n1881), .B1(n2418), .Y(n2207) );
  OAI221X1 U2042 ( .A0(n2360), .A1(n2504), .B0(n2465), .B1(n2506), .C0(n2216), 
        .Y(n2213) );
  OA22X1 U2043 ( .A0(n2470), .A1(n2508), .B0(n1881), .B1(n2392), .Y(n2216) );
  OAI221X1 U2044 ( .A0(n2361), .A1(n2504), .B0(n2424), .B1(n2506), .C0(n2225), 
        .Y(n2222) );
  OA22X1 U2045 ( .A0(n2377), .A1(n2508), .B0(n2511), .B1(n2460), .Y(n2225) );
  OAI221X1 U2046 ( .A0(n2362), .A1(n2505), .B0(n2425), .B1(n2507), .C0(n2234), 
        .Y(n2231) );
  OA22X1 U2047 ( .A0(n2378), .A1(n2509), .B0(n1881), .B1(n2461), .Y(n2234) );
  OAI221X1 U2048 ( .A0(n2363), .A1(n2504), .B0(n2426), .B1(n2506), .C0(n2243), 
        .Y(n2240) );
  OA22X1 U2049 ( .A0(n2379), .A1(n2509), .B0(n2511), .B1(n2462), .Y(n2243) );
  OAI221X1 U2050 ( .A0(n2325), .A1(n2504), .B0(n2400), .B1(n2506), .C0(n2252), 
        .Y(n2249) );
  OA22X1 U2051 ( .A0(n2336), .A1(n2508), .B0(n2511), .B1(n2419), .Y(n2252) );
  OAI221X1 U2052 ( .A0(n2364), .A1(n2505), .B0(n2427), .B1(n2507), .C0(n2261), 
        .Y(n2258) );
  OA22X1 U2053 ( .A0(n2380), .A1(n2509), .B0(n1881), .B1(n2463), .Y(n2261) );
  OAI221X1 U2054 ( .A0(n2365), .A1(n2505), .B0(n2428), .B1(n2507), .C0(n2270), 
        .Y(n2267) );
  OA22X1 U2055 ( .A0(n2381), .A1(n2508), .B0(n1881), .B1(n2464), .Y(n2270) );
  OAI221X1 U2056 ( .A0(n2326), .A1(n2504), .B0(n2429), .B1(n2506), .C0(n2284), 
        .Y(n2276) );
  OA22X1 U2057 ( .A0(n2449), .A1(n2508), .B0(n2511), .B1(n2359), .Y(n2284) );
  OA22X1 U2058 ( .A0(n2306), .A1(n2494), .B0(n2410), .B1(n2496), .Y(n2200) );
  OA22X1 U2059 ( .A0(n2348), .A1(n2500), .B0(n2437), .B1(n2502), .Y(n2199) );
  OA22X1 U2060 ( .A0(n2349), .A1(n2495), .B0(n2411), .B1(n2497), .Y(n2209) );
  OA22X1 U2061 ( .A0(n2350), .A1(n2501), .B0(n2438), .B1(n2503), .Y(n2208) );
  OA22X1 U2062 ( .A0(n2385), .A1(n2494), .B0(n2457), .B1(n2496), .Y(n2218) );
  OA22X1 U2063 ( .A0(n2317), .A1(n2500), .B0(n2469), .B1(n2502), .Y(n2217) );
  OA22X1 U2064 ( .A0(n2386), .A1(n2494), .B0(n2458), .B1(n2496), .Y(n2227) );
  OA22X1 U2065 ( .A0(n2387), .A1(n2500), .B0(n2439), .B1(n2502), .Y(n2226) );
  OA22X1 U2066 ( .A0(n2351), .A1(n2495), .B0(n2412), .B1(n2497), .Y(n2236) );
  OA22X1 U2067 ( .A0(n2388), .A1(n2501), .B0(n2440), .B1(n2503), .Y(n2235) );
  OA22X1 U2068 ( .A0(n2352), .A1(n2495), .B0(n2459), .B1(n2497), .Y(n2245) );
  OA22X1 U2069 ( .A0(n2389), .A1(n2501), .B0(n2441), .B1(n2503), .Y(n2244) );
  OA22X1 U2070 ( .A0(n2353), .A1(n2494), .B0(n2413), .B1(n2496), .Y(n2254) );
  OA22X1 U2071 ( .A0(n2354), .A1(n2500), .B0(n2442), .B1(n2502), .Y(n2253) );
  OA22X1 U2072 ( .A0(n2307), .A1(n2495), .B0(n2414), .B1(n2497), .Y(n2263) );
  OA22X1 U2073 ( .A0(n2390), .A1(n2501), .B0(n2443), .B1(n2503), .Y(n2262) );
  OA22X1 U2074 ( .A0(n2308), .A1(n2494), .B0(n2415), .B1(n2496), .Y(n2272) );
  OA22X1 U2075 ( .A0(n2391), .A1(n2500), .B0(n2444), .B1(n2502), .Y(n2271) );
  OA22X1 U2076 ( .A0(n2355), .A1(n2494), .B0(n2416), .B1(n2496), .Y(n2290) );
  OA22X1 U2077 ( .A0(n2309), .A1(n2500), .B0(n2445), .B1(n2502), .Y(n2287) );
  NAND2BX1 U2078 ( .AN(n1875), .B(n2288), .Y(n2168) );
  NAND2BX1 U2079 ( .AN(n1875), .B(n2280), .Y(n2151) );
  NAND2BX1 U2080 ( .AN(n2282), .B(n2289), .Y(n2166) );
  NAND2BX1 U2081 ( .AN(n1882), .B(n2283), .Y(n2163) );
  NAND2BX1 U2082 ( .AN(n2282), .B(n1883), .Y(n2510) );
  NAND2BX1 U2083 ( .AN(n1882), .B(n1883), .Y(n2186) );
  NAND2BX1 U2084 ( .AN(n2285), .B(n2486), .Y(n2184) );
  NAND2BX1 U2085 ( .AN(n1875), .B(n2486), .Y(n2182) );
  INVX1 U2086 ( .A(n2188), .Y(n2189) );
  NAND2BX1 U2087 ( .AN(n1882), .B(n2289), .Y(n2188) );
  INVX1 U2088 ( .A(n2170), .Y(n2171) );
  NAND2BX1 U2089 ( .AN(n2282), .B(n2283), .Y(n2170) );
  INVX1 U2090 ( .A(n2174), .Y(n2175) );
  NAND2BX1 U2091 ( .AN(n1876), .B(n2281), .Y(n2174) );
  INVX1 U2092 ( .A(n2180), .Y(n2181) );
  NAND2BX1 U2093 ( .AN(n1876), .B(n2486), .Y(n2180) );
  INVX1 U2094 ( .A(n2190), .Y(n2191) );
  NAND2BX1 U2095 ( .AN(n2285), .B(n2281), .Y(n2190) );
  INVX1 U2096 ( .A(n2176), .Y(n2177) );
  NAND2BX1 U2097 ( .AN(n1875), .B(n2281), .Y(n2176) );
  INVX1 U2098 ( .A(n2172), .Y(n2173) );
  NAND2BX1 U2099 ( .AN(n2292), .B(n1883), .Y(n2172) );
  INVX1 U2100 ( .A(n2178), .Y(n2179) );
  NAND2BX1 U2101 ( .AN(n2286), .B(n2486), .Y(n2178) );
  AO22X1 U2102 ( .A0(WrData[9]), .A1(WriteEn), .B0(n2192), .B1(n1874), .Y(
        n2153) );
  OR4X1 U2103 ( .A(n2193), .B(n2194), .C(n2195), .D(n2196), .Y(n2192) );
  OAI221X1 U2104 ( .A0(n2338), .A1(n2499), .B0(n2430), .B1(n2489), .C0(n2199), 
        .Y(n2194) );
  OAI221X1 U2105 ( .A0(n2337), .A1(n2491), .B0(n2403), .B1(n2493), .C0(n2200), 
        .Y(n2193) );
  AO22X1 U2106 ( .A0(WrData[8]), .A1(WriteEn), .B0(n2201), .B1(n1874), .Y(
        n2154) );
  OR4X1 U2107 ( .A(n2202), .B(n2203), .C(n2204), .D(n2205), .Y(n2201) );
  OAI221X1 U2108 ( .A0(n2405), .A1(n2499), .B0(n2328), .B1(n2489), .C0(n2208), 
        .Y(n2203) );
  OAI221X1 U2109 ( .A0(n2339), .A1(n2491), .B0(n2302), .B1(n2493), .C0(n2209), 
        .Y(n2202) );
  AO22X1 U2110 ( .A0(WrData[7]), .A1(WriteEn), .B0(n2210), .B1(n1874), .Y(
        n2155) );
  OR4X1 U2111 ( .A(n2211), .B(n2212), .C(n2213), .D(n2214), .Y(n2210) );
  OAI221X1 U2112 ( .A0(n2383), .A1(n2498), .B0(n2466), .B1(n2488), .C0(n2217), 
        .Y(n2212) );
  OAI221X1 U2113 ( .A0(n2382), .A1(n2490), .B0(n2446), .B1(n2492), .C0(n2218), 
        .Y(n2211) );
  AO22X1 U2114 ( .A0(WrData[6]), .A1(WriteEn), .B0(n2219), .B1(n1874), .Y(
        n2156) );
  OR4X1 U2115 ( .A(n2220), .B(n2221), .C(n2222), .D(n2223), .Y(n2219) );
  OAI221X1 U2116 ( .A0(n2450), .A1(n2498), .B0(n2366), .B1(n2488), .C0(n2226), 
        .Y(n2221) );
  OAI221X1 U2117 ( .A0(n2384), .A1(n2490), .B0(n2316), .B1(n2492), .C0(n2227), 
        .Y(n2220) );
  AO22X1 U2118 ( .A0(WrData[5]), .A1(WriteEn), .B0(n2228), .B1(n1874), .Y(
        n2157) );
  OR4X1 U2119 ( .A(n2229), .B(n2230), .C(n2231), .D(n2232), .Y(n2228) );
  OAI221X1 U2120 ( .A0(n2451), .A1(n2499), .B0(n2367), .B1(n2489), .C0(n2235), 
        .Y(n2230) );
  OAI221X1 U2121 ( .A0(n2340), .A1(n2491), .B0(n2303), .B1(n2493), .C0(n2236), 
        .Y(n2229) );
  AO22X1 U2122 ( .A0(WrData[4]), .A1(WriteEn), .B0(n2237), .B1(n1874), .Y(
        n2158) );
  OR4X1 U2123 ( .A(n2238), .B(n2239), .C(n2240), .D(n2241), .Y(n2237) );
  OAI221X1 U2124 ( .A0(n2452), .A1(n2498), .B0(n2368), .B1(n2488), .C0(n2244), 
        .Y(n2239) );
  OAI221X1 U2125 ( .A0(n2305), .A1(n2490), .B0(n2376), .B1(n2492), .C0(n2245), 
        .Y(n2238) );
  AO22X1 U2126 ( .A0(WrData[3]), .A1(WriteEn), .B0(n2246), .B1(n1874), .Y(
        n2159) );
  OR4X1 U2127 ( .A(n2247), .B(n2248), .C(n2249), .D(n2250), .Y(n2246) );
  OAI221X1 U2128 ( .A0(n2406), .A1(n2498), .B0(n2329), .B1(n2488), .C0(n2253), 
        .Y(n2248) );
  OAI221X1 U2129 ( .A0(n2341), .A1(n2490), .B0(n2304), .B1(n2492), .C0(n2254), 
        .Y(n2247) );
  AO22X1 U2130 ( .A0(WrData[2]), .A1(WriteEn), .B0(n2255), .B1(n1874), .Y(
        n2160) );
  OR4X1 U2131 ( .A(n2256), .B(n2257), .C(n2258), .D(n2259), .Y(n2255) );
  OAI221X1 U2132 ( .A0(n2343), .A1(n2499), .B0(n2431), .B1(n2489), .C0(n2262), 
        .Y(n2257) );
  OAI221X1 U2133 ( .A0(n2342), .A1(n2491), .B0(n2447), .B1(n2493), .C0(n2263), 
        .Y(n2256) );
  AO22X1 U2134 ( .A0(WrData[1]), .A1(WriteEn), .B0(n2264), .B1(n1874), .Y(
        n2161) );
  OR4X1 U2135 ( .A(n2265), .B(n2266), .C(n2267), .D(n2268), .Y(n2264) );
  OAI221X1 U2136 ( .A0(n2345), .A1(n2499), .B0(n2432), .B1(n2489), .C0(n2271), 
        .Y(n2266) );
  OAI221X1 U2137 ( .A0(n2344), .A1(n2491), .B0(n2448), .B1(n2493), .C0(n2272), 
        .Y(n2265) );
  AO22X1 U2138 ( .A0(WrData[0]), .A1(WriteEn), .B0(n2273), .B1(n1874), .Y(
        n2162) );
  OR4X1 U2139 ( .A(n2274), .B(n2275), .C(n2276), .D(n2277), .Y(n2273) );
  OAI221X1 U2140 ( .A0(n2347), .A1(n2498), .B0(n2433), .B1(n2488), .C0(n2287), 
        .Y(n2275) );
  OAI221X1 U2141 ( .A0(n2346), .A1(n2490), .B0(n2404), .B1(n2492), .C0(n2290), 
        .Y(n2274) );
  XOR2X1 U2142 ( .A(WriteEn), .B(WrCnt_0_), .Y(n1771) );
  OAI2BB2X1 U2143 ( .A0N(EmptyFlag), .A1N(n1839), .B0(n2482), .B1(n1841), .Y(
        n1792) );
  OAI222X1 U2144 ( .A0(n1843), .A1(n2322), .B0(n1841), .B1(n2476), .C0(n2296), 
        .C1(n2483), .Y(n1777) );
  OAI222X1 U2145 ( .A0(n2475), .A1(n1843), .B0(n1841), .B1(n2323), .C0(n2482), 
        .C1(n2297), .Y(n1791) );
  AO22X1 U2146 ( .A0(\FIFO[0][9] ), .A1(n2489), .B0(n2191), .B1(n2153), .Y(
        FIFO232) );
  AO22X1 U2147 ( .A0(\FIFO[0][8] ), .A1(n2488), .B0(n2191), .B1(n2154), .Y(
        FIFO2320) );
  AO22X1 U2148 ( .A0(\FIFO[0][7] ), .A1(n2488), .B0(n2191), .B1(n2155), .Y(
        FIFO2321) );
  AO22X1 U2149 ( .A0(\FIFO[0][6] ), .A1(n2489), .B0(n2191), .B1(n2156), .Y(
        FIFO2322) );
  AO22X1 U2150 ( .A0(\FIFO[0][5] ), .A1(n2489), .B0(n2191), .B1(n2157), .Y(
        FIFO2323) );
  AO22X1 U2151 ( .A0(\FIFO[0][4] ), .A1(n2488), .B0(n2191), .B1(n2158), .Y(
        FIFO2324) );
  AO22X1 U2152 ( .A0(\FIFO[0][3] ), .A1(n2489), .B0(n2191), .B1(n2159), .Y(
        FIFO2325) );
  AO22X1 U2153 ( .A0(\FIFO[0][2] ), .A1(n2488), .B0(n2191), .B1(n2160), .Y(
        FIFO2326) );
  AO22X1 U2154 ( .A0(\FIFO[0][1] ), .A1(n2488), .B0(n2191), .B1(n2161), .Y(
        FIFO2327) );
  AO22X1 U2155 ( .A0(\FIFO[0][0] ), .A1(n2489), .B0(n2191), .B1(n2162), .Y(
        FIFO2328) );
  AO22X1 U2156 ( .A0(\FIFO[1][9] ), .A1(n2515), .B0(n2177), .B1(n2153), .Y(
        FIFO2329) );
  AO22X1 U2157 ( .A0(\FIFO[1][8] ), .A1(n2514), .B0(n2177), .B1(n2154), .Y(
        FIFO23210) );
  AO22X1 U2158 ( .A0(\FIFO[1][7] ), .A1(n2514), .B0(n2177), .B1(n2155), .Y(
        FIFO23211) );
  AO22X1 U2159 ( .A0(\FIFO[1][6] ), .A1(n2515), .B0(n2177), .B1(n2156), .Y(
        FIFO23212) );
  AO22X1 U2160 ( .A0(\FIFO[1][5] ), .A1(n2515), .B0(n2177), .B1(n2157), .Y(
        FIFO23213) );
  AO22X1 U2161 ( .A0(\FIFO[1][4] ), .A1(n2514), .B0(n2177), .B1(n2158), .Y(
        FIFO23214) );
  AO22X1 U2162 ( .A0(\FIFO[1][3] ), .A1(n2515), .B0(n2177), .B1(n2159), .Y(
        FIFO23215) );
  AO22X1 U2163 ( .A0(\FIFO[1][2] ), .A1(n2514), .B0(n2177), .B1(n2160), .Y(
        FIFO23216) );
  AO22X1 U2164 ( .A0(\FIFO[1][1] ), .A1(n2514), .B0(n2177), .B1(n2161), .Y(
        FIFO23217) );
  AO22X1 U2165 ( .A0(\FIFO[1][0] ), .A1(n2515), .B0(n2177), .B1(n2162), .Y(
        FIFO23218) );
  AO22X1 U2166 ( .A0(\FIFO[2][9] ), .A1(n2499), .B0(n2175), .B1(n2153), .Y(
        FIFO23219) );
  AO22X1 U2167 ( .A0(\FIFO[2][8] ), .A1(n2498), .B0(n2175), .B1(n2154), .Y(
        FIFO23220) );
  AO22X1 U2168 ( .A0(\FIFO[2][7] ), .A1(n2498), .B0(n2175), .B1(n2155), .Y(
        FIFO23221) );
  AO22X1 U2169 ( .A0(\FIFO[2][6] ), .A1(n2499), .B0(n2175), .B1(n2156), .Y(
        FIFO23222) );
  AO22X1 U2170 ( .A0(\FIFO[2][5] ), .A1(n2499), .B0(n2175), .B1(n2157), .Y(
        FIFO23223) );
  AO22X1 U2171 ( .A0(\FIFO[2][4] ), .A1(n2498), .B0(n2175), .B1(n2158), .Y(
        FIFO23224) );
  AO22X1 U2172 ( .A0(\FIFO[2][3] ), .A1(n2499), .B0(n2175), .B1(n2159), .Y(
        FIFO23225) );
  AO22X1 U2173 ( .A0(\FIFO[2][2] ), .A1(n2498), .B0(n2175), .B1(n2160), .Y(
        FIFO23226) );
  AO22X1 U2174 ( .A0(\FIFO[2][1] ), .A1(n2498), .B0(n2175), .B1(n2161), .Y(
        FIFO23227) );
  AO22X1 U2175 ( .A0(\FIFO[2][0] ), .A1(n2499), .B0(n2175), .B1(n2162), .Y(
        FIFO23228) );
  AO22X1 U2176 ( .A0(\FIFO[3][9] ), .A1(n2493), .B0(n2173), .B1(n2153), .Y(
        FIFO23229) );
  AO22X1 U2177 ( .A0(\FIFO[3][8] ), .A1(n2492), .B0(n2173), .B1(n2154), .Y(
        FIFO23230) );
  AO22X1 U2178 ( .A0(\FIFO[3][7] ), .A1(n2492), .B0(n2173), .B1(n2155), .Y(
        FIFO23231) );
  AO22X1 U2179 ( .A0(\FIFO[3][6] ), .A1(n2493), .B0(n2173), .B1(n2156), .Y(
        FIFO23232) );
  AO22X1 U2180 ( .A0(\FIFO[3][5] ), .A1(n2493), .B0(n2173), .B1(n2157), .Y(
        FIFO23233) );
  AO22X1 U2181 ( .A0(\FIFO[3][4] ), .A1(n2492), .B0(n2173), .B1(n2158), .Y(
        FIFO23234) );
  AO22X1 U2182 ( .A0(\FIFO[3][3] ), .A1(n2493), .B0(n2173), .B1(n2159), .Y(
        FIFO23235) );
  AO22X1 U2183 ( .A0(\FIFO[3][2] ), .A1(n2492), .B0(n2173), .B1(n2160), .Y(
        FIFO23236) );
  AO22X1 U2184 ( .A0(\FIFO[3][1] ), .A1(n2492), .B0(n2173), .B1(n2161), .Y(
        FIFO23237) );
  AO22X1 U2185 ( .A0(\FIFO[3][0] ), .A1(n2493), .B0(n2173), .B1(n2162), .Y(
        FIFO23238) );
  AO22X1 U2186 ( .A0(\FIFO[4][9] ), .A1(n2513), .B0(n2171), .B1(n2153), .Y(
        FIFO23239) );
  AO22X1 U2187 ( .A0(\FIFO[4][8] ), .A1(n2512), .B0(n2171), .B1(n2154), .Y(
        FIFO23240) );
  AO22X1 U2188 ( .A0(\FIFO[4][7] ), .A1(n2512), .B0(n2171), .B1(n2155), .Y(
        FIFO23241) );
  AO22X1 U2189 ( .A0(\FIFO[4][6] ), .A1(n2513), .B0(n2171), .B1(n2156), .Y(
        FIFO23242) );
  AO22X1 U2190 ( .A0(\FIFO[4][5] ), .A1(n2513), .B0(n2171), .B1(n2157), .Y(
        FIFO23243) );
  AO22X1 U2191 ( .A0(\FIFO[4][4] ), .A1(n2512), .B0(n2171), .B1(n2158), .Y(
        FIFO23244) );
  AO22X1 U2192 ( .A0(\FIFO[4][3] ), .A1(n2513), .B0(n2171), .B1(n2159), .Y(
        FIFO23245) );
  AO22X1 U2193 ( .A0(\FIFO[4][2] ), .A1(n2512), .B0(n2171), .B1(n2160), .Y(
        FIFO23246) );
  AO22X1 U2194 ( .A0(\FIFO[4][1] ), .A1(n2512), .B0(n2171), .B1(n2161), .Y(
        FIFO23247) );
  AO22X1 U2195 ( .A0(\FIFO[4][0] ), .A1(n2513), .B0(n2171), .B1(n2162), .Y(
        FIFO23248) );
  AO22X1 U2196 ( .A0(\FIFO[5][9] ), .A1(n2503), .B0(n2169), .B1(n2153), .Y(
        FIFO23249) );
  AO22X1 U2197 ( .A0(\FIFO[5][8] ), .A1(n2503), .B0(n2169), .B1(n2154), .Y(
        FIFO23250) );
  AO22X1 U2198 ( .A0(\FIFO[5][7] ), .A1(n2502), .B0(n2169), .B1(n2155), .Y(
        FIFO23251) );
  AO22X1 U2199 ( .A0(\FIFO[5][6] ), .A1(n2503), .B0(n2169), .B1(n2156), .Y(
        FIFO23252) );
  AO22X1 U2200 ( .A0(\FIFO[5][5] ), .A1(n2168), .B0(n2169), .B1(n2157), .Y(
        FIFO23253) );
  AO22X1 U2201 ( .A0(\FIFO[5][4] ), .A1(n2502), .B0(n2169), .B1(n2158), .Y(
        FIFO23254) );
  AO22X1 U2202 ( .A0(\FIFO[5][3] ), .A1(n2503), .B0(n2169), .B1(n2159), .Y(
        FIFO23255) );
  AO22X1 U2203 ( .A0(\FIFO[5][2] ), .A1(n2168), .B0(n2169), .B1(n2160), .Y(
        FIFO23256) );
  AO22X1 U2204 ( .A0(\FIFO[5][1] ), .A1(n2502), .B0(n2169), .B1(n2161), .Y(
        FIFO23257) );
  AO22X1 U2205 ( .A0(\FIFO[5][0] ), .A1(n2503), .B0(n2169), .B1(n2162), .Y(
        FIFO23258) );
  AO22X1 U2206 ( .A0(\FIFO[6][9] ), .A1(n2501), .B0(n2167), .B1(n2153), .Y(
        FIFO23259) );
  AO22X1 U2207 ( .A0(\FIFO[6][8] ), .A1(n2501), .B0(n2167), .B1(n2154), .Y(
        FIFO23260) );
  AO22X1 U2208 ( .A0(\FIFO[6][7] ), .A1(n2500), .B0(n2167), .B1(n2155), .Y(
        FIFO23261) );
  AO22X1 U2209 ( .A0(\FIFO[6][6] ), .A1(n2501), .B0(n2167), .B1(n2156), .Y(
        FIFO23262) );
  AO22X1 U2210 ( .A0(\FIFO[6][5] ), .A1(n2166), .B0(n2167), .B1(n2157), .Y(
        FIFO23263) );
  AO22X1 U2211 ( .A0(\FIFO[6][4] ), .A1(n2500), .B0(n2167), .B1(n2158), .Y(
        FIFO23264) );
  AO22X1 U2212 ( .A0(\FIFO[6][3] ), .A1(n2501), .B0(n2167), .B1(n2159), .Y(
        FIFO23265) );
  AO22X1 U2213 ( .A0(\FIFO[6][2] ), .A1(n2166), .B0(n2167), .B1(n2160), .Y(
        FIFO23266) );
  AO22X1 U2214 ( .A0(\FIFO[6][1] ), .A1(n2500), .B0(n2167), .B1(n2161), .Y(
        FIFO23267) );
  AO22X1 U2215 ( .A0(\FIFO[6][0] ), .A1(n2501), .B0(n2167), .B1(n2162), .Y(
        FIFO23268) );
  AO22X1 U2216 ( .A0(\FIFO[7][9] ), .A1(n1881), .B0(n2165), .B1(n2153), .Y(
        FIFO23269) );
  AO22X1 U2217 ( .A0(\FIFO[7][8] ), .A1(n2511), .B0(n2165), .B1(n2154), .Y(
        FIFO23270) );
  AO22X1 U2218 ( .A0(\FIFO[7][7] ), .A1(n2511), .B0(n2165), .B1(n2155), .Y(
        FIFO23271) );
  AO22X1 U2219 ( .A0(\FIFO[7][6] ), .A1(n1881), .B0(n2165), .B1(n2156), .Y(
        FIFO23272) );
  AO22X1 U2220 ( .A0(\FIFO[7][5] ), .A1(n2510), .B0(n2165), .B1(n2157), .Y(
        FIFO23273) );
  AO22X1 U2221 ( .A0(\FIFO[7][4] ), .A1(n2511), .B0(n2165), .B1(n2158), .Y(
        FIFO23274) );
  AO22X1 U2222 ( .A0(\FIFO[7][3] ), .A1(n1881), .B0(n2165), .B1(n2159), .Y(
        FIFO23275) );
  AO22X1 U2223 ( .A0(\FIFO[7][2] ), .A1(n2510), .B0(n2165), .B1(n2160), .Y(
        FIFO23276) );
  AO22X1 U2224 ( .A0(\FIFO[7][1] ), .A1(n2511), .B0(n2165), .B1(n2161), .Y(
        FIFO23277) );
  AO22X1 U2225 ( .A0(\FIFO[7][0] ), .A1(n1881), .B0(n2165), .B1(n2162), .Y(
        FIFO23278) );
  AO22X1 U2226 ( .A0(\FIFO[8][9] ), .A1(n2509), .B0(n2164), .B1(n2153), .Y(
        FIFO23279) );
  AO22X1 U2227 ( .A0(\FIFO[8][8] ), .A1(n2509), .B0(n2164), .B1(n2154), .Y(
        FIFO23280) );
  AO22X1 U2228 ( .A0(\FIFO[8][7] ), .A1(n2508), .B0(n2164), .B1(n2155), .Y(
        FIFO23281) );
  AO22X1 U2229 ( .A0(\FIFO[8][6] ), .A1(n2509), .B0(n2164), .B1(n2156), .Y(
        FIFO23282) );
  AO22X1 U2230 ( .A0(\FIFO[8][5] ), .A1(n2163), .B0(n2164), .B1(n2157), .Y(
        FIFO23283) );
  AO22X1 U2231 ( .A0(\FIFO[8][4] ), .A1(n2508), .B0(n2164), .B1(n2158), .Y(
        FIFO23284) );
  AO22X1 U2232 ( .A0(\FIFO[8][3] ), .A1(n2509), .B0(n2164), .B1(n2159), .Y(
        FIFO23285) );
  AO22X1 U2233 ( .A0(\FIFO[8][2] ), .A1(n2163), .B0(n2164), .B1(n2160), .Y(
        FIFO23286) );
  AO22X1 U2234 ( .A0(\FIFO[8][1] ), .A1(n2508), .B0(n2164), .B1(n2161), .Y(
        FIFO23287) );
  AO22X1 U2235 ( .A0(\FIFO[8][0] ), .A1(n2509), .B0(n2164), .B1(n2162), .Y(
        FIFO23288) );
  AO22X1 U2236 ( .A0(\FIFO[9][9] ), .A1(n2517), .B0(n2152), .B1(n2153), .Y(
        FIFO23289) );
  AO22X1 U2237 ( .A0(\FIFO[9][8] ), .A1(n2517), .B0(n2152), .B1(n2154), .Y(
        FIFO23290) );
  AO22X1 U2238 ( .A0(\FIFO[9][7] ), .A1(n2516), .B0(n2152), .B1(n2155), .Y(
        FIFO23291) );
  AO22X1 U2239 ( .A0(\FIFO[9][6] ), .A1(n2517), .B0(n2152), .B1(n2156), .Y(
        FIFO23292) );
  AO22X1 U2240 ( .A0(\FIFO[9][5] ), .A1(n2151), .B0(n2152), .B1(n2157), .Y(
        FIFO23293) );
  AO22X1 U2241 ( .A0(\FIFO[9][4] ), .A1(n2516), .B0(n2152), .B1(n2158), .Y(
        FIFO23294) );
  AO22X1 U2242 ( .A0(\FIFO[9][3] ), .A1(n2517), .B0(n2152), .B1(n2159), .Y(
        FIFO23295) );
  AO22X1 U2243 ( .A0(\FIFO[9][2] ), .A1(n2151), .B0(n2152), .B1(n2160), .Y(
        FIFO23296) );
  AO22X1 U2244 ( .A0(\FIFO[9][1] ), .A1(n2516), .B0(n2152), .B1(n2161), .Y(
        FIFO23297) );
  AO22X1 U2245 ( .A0(\FIFO[9][0] ), .A1(n2517), .B0(n2152), .B1(n2162), .Y(
        FIFO23298) );
  AO22X1 U2246 ( .A0(\FIFO[10][9] ), .A1(n2491), .B0(n2189), .B1(n2153), .Y(
        FIFO23299) );
  AO22X1 U2247 ( .A0(\FIFO[10][8] ), .A1(n2490), .B0(n2189), .B1(n2154), .Y(
        FIFO232100) );
  AO22X1 U2248 ( .A0(\FIFO[10][7] ), .A1(n2490), .B0(n2189), .B1(n2155), .Y(
        FIFO232101) );
  AO22X1 U2249 ( .A0(\FIFO[10][6] ), .A1(n2491), .B0(n2189), .B1(n2156), .Y(
        FIFO232102) );
  AO22X1 U2250 ( .A0(\FIFO[10][5] ), .A1(n2491), .B0(n2189), .B1(n2157), .Y(
        FIFO232103) );
  AO22X1 U2251 ( .A0(\FIFO[10][4] ), .A1(n2490), .B0(n2189), .B1(n2158), .Y(
        FIFO232104) );
  AO22X1 U2252 ( .A0(\FIFO[10][3] ), .A1(n2491), .B0(n2189), .B1(n2159), .Y(
        FIFO232105) );
  AO22X1 U2253 ( .A0(\FIFO[10][2] ), .A1(n2490), .B0(n2189), .B1(n2160), .Y(
        FIFO232106) );
  AO22X1 U2254 ( .A0(\FIFO[10][1] ), .A1(n2490), .B0(n2189), .B1(n2161), .Y(
        FIFO232107) );
  AO22X1 U2255 ( .A0(\FIFO[10][0] ), .A1(n2491), .B0(n2189), .B1(n2162), .Y(
        FIFO232108) );
  AO22X1 U2256 ( .A0(\FIFO[11][9] ), .A1(n2497), .B0(n2187), .B1(n2153), .Y(
        FIFO232109) );
  AO22X1 U2257 ( .A0(\FIFO[11][8] ), .A1(n2497), .B0(n2187), .B1(n2154), .Y(
        FIFO232110) );
  AO22X1 U2258 ( .A0(\FIFO[11][7] ), .A1(n2496), .B0(n2187), .B1(n2155), .Y(
        FIFO232111) );
  AO22X1 U2259 ( .A0(\FIFO[11][6] ), .A1(n2497), .B0(n2187), .B1(n2156), .Y(
        FIFO232112) );
  AO22X1 U2260 ( .A0(\FIFO[11][5] ), .A1(n2186), .B0(n2187), .B1(n2157), .Y(
        FIFO232113) );
  AO22X1 U2261 ( .A0(\FIFO[11][4] ), .A1(n2496), .B0(n2187), .B1(n2158), .Y(
        FIFO232114) );
  AO22X1 U2262 ( .A0(\FIFO[11][3] ), .A1(n2497), .B0(n2187), .B1(n2159), .Y(
        FIFO232115) );
  AO22X1 U2263 ( .A0(\FIFO[11][2] ), .A1(n2186), .B0(n2187), .B1(n2160), .Y(
        FIFO232116) );
  AO22X1 U2264 ( .A0(\FIFO[11][1] ), .A1(n2496), .B0(n2187), .B1(n2161), .Y(
        FIFO232117) );
  AO22X1 U2265 ( .A0(\FIFO[11][0] ), .A1(n2497), .B0(n2187), .B1(n2162), .Y(
        FIFO232118) );
  AO22X1 U2266 ( .A0(\FIFO[12][9] ), .A1(n2495), .B0(n2185), .B1(n2153), .Y(
        FIFO232119) );
  AO22X1 U2267 ( .A0(\FIFO[12][8] ), .A1(n2495), .B0(n2185), .B1(n2154), .Y(
        FIFO232120) );
  AO22X1 U2268 ( .A0(\FIFO[12][7] ), .A1(n2494), .B0(n2185), .B1(n2155), .Y(
        FIFO232121) );
  AO22X1 U2269 ( .A0(\FIFO[12][6] ), .A1(n2495), .B0(n2185), .B1(n2156), .Y(
        FIFO232122) );
  AO22X1 U2270 ( .A0(\FIFO[12][5] ), .A1(n2184), .B0(n2185), .B1(n2157), .Y(
        FIFO232123) );
  AO22X1 U2271 ( .A0(\FIFO[12][4] ), .A1(n2494), .B0(n2185), .B1(n2158), .Y(
        FIFO232124) );
  AO22X1 U2272 ( .A0(\FIFO[12][3] ), .A1(n2495), .B0(n2185), .B1(n2159), .Y(
        FIFO232125) );
  AO22X1 U2273 ( .A0(\FIFO[12][2] ), .A1(n2184), .B0(n2185), .B1(n2160), .Y(
        FIFO232126) );
  AO22X1 U2274 ( .A0(\FIFO[12][1] ), .A1(n2494), .B0(n2185), .B1(n2161), .Y(
        FIFO232127) );
  AO22X1 U2275 ( .A0(\FIFO[12][0] ), .A1(n2495), .B0(n2185), .B1(n2162), .Y(
        FIFO232128) );
  AO22X1 U2276 ( .A0(\FIFO[13][9] ), .A1(n2519), .B0(n2183), .B1(n2153), .Y(
        FIFO232129) );
  AO22X1 U2277 ( .A0(\FIFO[13][8] ), .A1(n2519), .B0(n2183), .B1(n2154), .Y(
        FIFO232130) );
  AO22X1 U2278 ( .A0(\FIFO[13][7] ), .A1(n2518), .B0(n2183), .B1(n2155), .Y(
        FIFO232131) );
  AO22X1 U2279 ( .A0(\FIFO[13][6] ), .A1(n2519), .B0(n2183), .B1(n2156), .Y(
        FIFO232132) );
  AO22X1 U2280 ( .A0(\FIFO[13][5] ), .A1(n2182), .B0(n2183), .B1(n2157), .Y(
        FIFO232133) );
  AO22X1 U2281 ( .A0(\FIFO[13][4] ), .A1(n2518), .B0(n2183), .B1(n2158), .Y(
        FIFO232134) );
  AO22X1 U2282 ( .A0(\FIFO[13][3] ), .A1(n2519), .B0(n2183), .B1(n2159), .Y(
        FIFO232135) );
  AO22X1 U2283 ( .A0(\FIFO[13][2] ), .A1(n2182), .B0(n2183), .B1(n2160), .Y(
        FIFO232136) );
  AO22X1 U2284 ( .A0(\FIFO[13][1] ), .A1(n2518), .B0(n2183), .B1(n2161), .Y(
        FIFO232137) );
  AO22X1 U2285 ( .A0(\FIFO[13][0] ), .A1(n2519), .B0(n2183), .B1(n2162), .Y(
        FIFO232138) );
  AO22X1 U2286 ( .A0(\FIFO[14][9] ), .A1(n2507), .B0(n2181), .B1(n2153), .Y(
        FIFO232139) );
  AO22X1 U2287 ( .A0(\FIFO[14][8] ), .A1(n2506), .B0(n2181), .B1(n2154), .Y(
        FIFO232140) );
  AO22X1 U2288 ( .A0(\FIFO[14][7] ), .A1(n2506), .B0(n2181), .B1(n2155), .Y(
        FIFO232141) );
  AO22X1 U2289 ( .A0(\FIFO[14][6] ), .A1(n2507), .B0(n2181), .B1(n2156), .Y(
        FIFO232142) );
  AO22X1 U2290 ( .A0(\FIFO[14][5] ), .A1(n2507), .B0(n2181), .B1(n2157), .Y(
        FIFO232143) );
  AO22X1 U2291 ( .A0(\FIFO[14][4] ), .A1(n2506), .B0(n2181), .B1(n2158), .Y(
        FIFO232144) );
  AO22X1 U2292 ( .A0(\FIFO[14][3] ), .A1(n2507), .B0(n2181), .B1(n2159), .Y(
        FIFO232145) );
  AO22X1 U2293 ( .A0(\FIFO[14][2] ), .A1(n2506), .B0(n2181), .B1(n2160), .Y(
        FIFO232146) );
  AO22X1 U2294 ( .A0(\FIFO[14][1] ), .A1(n2506), .B0(n2181), .B1(n2161), .Y(
        FIFO232147) );
  AO22X1 U2295 ( .A0(\FIFO[14][0] ), .A1(n2507), .B0(n2181), .B1(n2162), .Y(
        FIFO232148) );
  AO22X1 U2296 ( .A0(\FIFO[15][9] ), .A1(n2505), .B0(n2179), .B1(n2153), .Y(
        FIFO232149) );
  AO22X1 U2297 ( .A0(\FIFO[15][8] ), .A1(n2504), .B0(n2179), .B1(n2154), .Y(
        FIFO232150) );
  AO22X1 U2298 ( .A0(\FIFO[15][7] ), .A1(n2504), .B0(n2179), .B1(n2155), .Y(
        FIFO232151) );
  AO22X1 U2299 ( .A0(\FIFO[15][6] ), .A1(n2505), .B0(n2179), .B1(n2156), .Y(
        FIFO232152) );
  AO22X1 U2300 ( .A0(\FIFO[15][5] ), .A1(n2505), .B0(n2179), .B1(n2157), .Y(
        FIFO232153) );
  AO22X1 U2301 ( .A0(\FIFO[15][4] ), .A1(n2504), .B0(n2179), .B1(n2158), .Y(
        FIFO232154) );
  AO22X1 U2302 ( .A0(\FIFO[15][3] ), .A1(n2505), .B0(n2179), .B1(n2159), .Y(
        FIFO232155) );
  AO22X1 U2303 ( .A0(\FIFO[15][2] ), .A1(n2504), .B0(n2179), .B1(n2160), .Y(
        FIFO232156) );
  AO22X1 U2304 ( .A0(\FIFO[15][1] ), .A1(n2504), .B0(n2179), .B1(n2161), .Y(
        FIFO232157) );
  AO22X1 U2305 ( .A0(\FIFO[15][0] ), .A1(n2505), .B0(n2179), .B1(n2162), .Y(
        FIFO232158) );
  OAI2BB2X1 U2306 ( .A0N(FullFlag), .A1N(n1839), .B0(n2483), .B1(n1843), .Y(
        n1776) );
  NAND2BX1 U2307 ( .AN(RdCnt[0]), .B(RdCnt[1]), .Y(n1865) );
  NAND2BX1 U2308 ( .AN(RdCnt[0]), .B(n2401), .Y(n2125) );
  NAND2BX1 U2309 ( .AN(RdCnt[3]), .B(RdCnt[2]), .Y(n2146) );
  NAND2BX1 U2310 ( .AN(RdCnt[2]), .B(RdCnt[3]), .Y(n1871) );
  NAND2X1 U2311 ( .A(RdCnt[0]), .B(RdCnt[1]), .Y(n2132) );
  NAND2BX1 U2312 ( .AN(RdCnt[2]), .B(n2485), .Y(n2140) );
  NAND2BX1 U2313 ( .AN(RdCnt[1]), .B(RdCnt[0]), .Y(n1864) );
  NOR2X1 U2314 ( .A(n2402), .B(n2485), .Y(n2484) );
  NAND2BX1 U2315 ( .AN(WrCnt_2_), .B(WrCnt_3_), .Y(n1882) );
  NAND2BX1 U2316 ( .AN(WrCnt_3_), .B(WrCnt_2_), .Y(n2282) );
  NAND2BX1 U2317 ( .AN(WrCnt_0_), .B(WrCnt_1_), .Y(n1876) );
  NAND2BX1 U2318 ( .AN(WrCnt_0_), .B(n2468), .Y(n2285) );
  NAND2BX1 U2319 ( .AN(WrCnt_1_), .B(WrCnt_0_), .Y(n1875) );
  NAND2BX1 U2320 ( .AN(WrCnt_2_), .B(n2487), .Y(n2292) );
  NAND2X1 U2321 ( .A(WrCnt_0_), .B(WrCnt_1_), .Y(n2286) );
  XOR2X1 U2322 ( .A(ReadEn), .B(RdCnt[0]), .Y(n1775) );
  NOR2X1 U2323 ( .A(n2467), .B(n2487), .Y(n2486) );
  DFFRX1 RdCnt_reg_0_ ( .D(n1775), .CK(Clk), .RN(nRST), .Q(RdCnt[0]) );
  DFFRX1 RdCnt_reg_3_ ( .D(n1772), .CK(Clk), .RN(nRST), .Q(RdCnt[3]), .QN(
        n2485) );
  DFFRX1 RdCnt_reg_1_ ( .D(n1774), .CK(Clk), .RN(nRST), .Q(RdCnt[1]), .QN(
        n2401) );
  DFFRX1 RdCnt_reg_2_ ( .D(n1773), .CK(Clk), .RN(nRST), .Q(RdCnt[2]), .QN(
        n2402) );
  DFFRX1 DatCnt_reg_16_ ( .D(n1776), .CK(Clk), .RN(nRST), .Q(FullFlag), .QN(
        n2476) );
  DFFRX1 FIFO_reg ( .D(FIFO232), .CK(Clk), .RN(nRST), .Q(\FIFO[0][9] ), .QN(
        n2430) );
  DFFRX1 FIFO_reg0 ( .D(FIFO2320), .CK(Clk), .RN(nRST), .Q(\FIFO[0][8] ), .QN(
        n2328) );
  DFFRX1 FIFO_reg1 ( .D(FIFO2323), .CK(Clk), .RN(nRST), .Q(\FIFO[0][5] ), .QN(
        n2367) );
  DFFRX1 FIFO_reg2 ( .D(FIFO2324), .CK(Clk), .RN(nRST), .Q(\FIFO[0][4] ), .QN(
        n2368) );
  DFFRX1 FIFO_reg3 ( .D(FIFO2325), .CK(Clk), .RN(nRST), .Q(\FIFO[0][3] ), .QN(
        n2329) );
  DFFRX1 FIFO_reg4 ( .D(FIFO2326), .CK(Clk), .RN(nRST), .Q(\FIFO[0][2] ), .QN(
        n2431) );
  DFFRX1 FIFO_reg5 ( .D(FIFO2327), .CK(Clk), .RN(nRST), .Q(\FIFO[0][1] ), .QN(
        n2432) );
  DFFRX1 FIFO_reg6 ( .D(FIFO2328), .CK(Clk), .RN(nRST), .Q(\FIFO[0][0] ), .QN(
        n2433) );
  DFFRX1 FIFO_reg7 ( .D(FIFO2329), .CK(Clk), .RN(nRST), .Q(\FIFO[1][9] ), .QN(
        n2310) );
  DFFRX1 FIFO_reg8 ( .D(FIFO23210), .CK(Clk), .RN(nRST), .Q(\FIFO[1][8] ), 
        .QN(n2397) );
  DFFRX1 FIFO_reg9 ( .D(FIFO23213), .CK(Clk), .RN(nRST), .Q(\FIFO[1][5] ), 
        .QN(n2421) );
  DFFRX1 FIFO_reg10 ( .D(FIFO23214), .CK(Clk), .RN(nRST), .Q(\FIFO[1][4] ), 
        .QN(n2422) );
  DFFRX1 FIFO_reg11 ( .D(FIFO23215), .CK(Clk), .RN(nRST), .Q(\FIFO[1][3] ), 
        .QN(n2398) );
  DFFRX1 FIFO_reg12 ( .D(FIFO23216), .CK(Clk), .RN(nRST), .Q(\FIFO[1][2] ), 
        .QN(n2311) );
  DFFRX1 FIFO_reg13 ( .D(FIFO23217), .CK(Clk), .RN(nRST), .Q(\FIFO[1][1] ), 
        .QN(n2312) );
  DFFRX1 FIFO_reg14 ( .D(FIFO23218), .CK(Clk), .RN(nRST), .Q(\FIFO[1][0] ), 
        .QN(n2299) );
  DFFRX1 FIFO_reg15 ( .D(FIFO23219), .CK(Clk), .RN(nRST), .Q(\FIFO[2][9] ), 
        .QN(n2338) );
  DFFRX1 FIFO_reg16 ( .D(FIFO23220), .CK(Clk), .RN(nRST), .Q(\FIFO[2][8] ), 
        .QN(n2405) );
  DFFRX1 FIFO_reg17 ( .D(FIFO23223), .CK(Clk), .RN(nRST), .Q(\FIFO[2][5] ), 
        .QN(n2451) );
  DFFRX1 FIFO_reg18 ( .D(FIFO23224), .CK(Clk), .RN(nRST), .Q(\FIFO[2][4] ), 
        .QN(n2452) );
  DFFRX1 FIFO_reg19 ( .D(FIFO23225), .CK(Clk), .RN(nRST), .Q(\FIFO[2][3] ), 
        .QN(n2406) );
  DFFRX1 FIFO_reg20 ( .D(FIFO23226), .CK(Clk), .RN(nRST), .Q(\FIFO[2][2] ), 
        .QN(n2343) );
  DFFRX1 FIFO_reg21 ( .D(FIFO23227), .CK(Clk), .RN(nRST), .Q(\FIFO[2][1] ), 
        .QN(n2345) );
  DFFRX1 FIFO_reg22 ( .D(FIFO23228), .CK(Clk), .RN(nRST), .Q(\FIFO[2][0] ), 
        .QN(n2347) );
  DFFRX1 FIFO_reg23 ( .D(FIFO23229), .CK(Clk), .RN(nRST), .Q(\FIFO[3][9] ), 
        .QN(n2403) );
  DFFRX1 FIFO_reg24 ( .D(FIFO23230), .CK(Clk), .RN(nRST), .Q(\FIFO[3][8] ), 
        .QN(n2302) );
  DFFRX1 FIFO_reg25 ( .D(FIFO23233), .CK(Clk), .RN(nRST), .Q(\FIFO[3][5] ), 
        .QN(n2303) );
  DFFRX1 FIFO_reg26 ( .D(FIFO23234), .CK(Clk), .RN(nRST), .Q(\FIFO[3][4] ), 
        .QN(n2376) );
  DFFRX1 FIFO_reg27 ( .D(FIFO23235), .CK(Clk), .RN(nRST), .Q(\FIFO[3][3] ), 
        .QN(n2304) );
  DFFRX1 FIFO_reg28 ( .D(FIFO23236), .CK(Clk), .RN(nRST), .Q(\FIFO[3][2] ), 
        .QN(n2447) );
  DFFRX1 FIFO_reg29 ( .D(FIFO23237), .CK(Clk), .RN(nRST), .Q(\FIFO[3][1] ), 
        .QN(n2448) );
  DFFRX1 FIFO_reg30 ( .D(FIFO23238), .CK(Clk), .RN(nRST), .Q(\FIFO[3][0] ), 
        .QN(n2404) );
  DFFRX1 FIFO_reg31 ( .D(FIFO23239), .CK(Clk), .RN(nRST), .Q(\FIFO[4][9] ), 
        .QN(n2369) );
  DFFRX1 FIFO_reg32 ( .D(FIFO23240), .CK(Clk), .RN(nRST), .Q(\FIFO[4][8] ), 
        .QN(n2330) );
  DFFRX1 FIFO_reg33 ( .D(FIFO23243), .CK(Clk), .RN(nRST), .Q(\FIFO[4][5] ), 
        .QN(n2371) );
  DFFRX1 FIFO_reg34 ( .D(FIFO23244), .CK(Clk), .RN(nRST), .Q(\FIFO[4][4] ), 
        .QN(n2372) );
  DFFRX1 FIFO_reg35 ( .D(FIFO23245), .CK(Clk), .RN(nRST), .Q(\FIFO[4][3] ), 
        .QN(n2331) );
  DFFRX1 FIFO_reg36 ( .D(FIFO23246), .CK(Clk), .RN(nRST), .Q(\FIFO[4][2] ), 
        .QN(n2373) );
  DFFRX1 FIFO_reg37 ( .D(FIFO23247), .CK(Clk), .RN(nRST), .Q(\FIFO[4][1] ), 
        .QN(n2374) );
  DFFRX1 FIFO_reg38 ( .D(FIFO23248), .CK(Clk), .RN(nRST), .Q(\FIFO[4][0] ), 
        .QN(n2332) );
  DFFRX1 FIFO_reg39 ( .D(FIFO23249), .CK(Clk), .RN(nRST), .Q(\FIFO[5][9] ), 
        .QN(n2437) );
  DFFRX1 FIFO_reg40 ( .D(FIFO23250), .CK(Clk), .RN(nRST), .Q(\FIFO[5][8] ), 
        .QN(n2438) );
  DFFRX1 FIFO_reg41 ( .D(FIFO23253), .CK(Clk), .RN(nRST), .Q(\FIFO[5][5] ), 
        .QN(n2440) );
  DFFRX1 FIFO_reg42 ( .D(FIFO23254), .CK(Clk), .RN(nRST), .Q(\FIFO[5][4] ), 
        .QN(n2441) );
  DFFRX1 FIFO_reg43 ( .D(FIFO23255), .CK(Clk), .RN(nRST), .Q(\FIFO[5][3] ), 
        .QN(n2442) );
  DFFRX1 FIFO_reg44 ( .D(FIFO23256), .CK(Clk), .RN(nRST), .Q(\FIFO[5][2] ), 
        .QN(n2443) );
  DFFRX1 FIFO_reg45 ( .D(FIFO23257), .CK(Clk), .RN(nRST), .Q(\FIFO[5][1] ), 
        .QN(n2444) );
  DFFRX1 FIFO_reg46 ( .D(FIFO23258), .CK(Clk), .RN(nRST), .Q(\FIFO[5][0] ), 
        .QN(n2445) );
  DFFRX1 FIFO_reg47 ( .D(FIFO23259), .CK(Clk), .RN(nRST), .Q(\FIFO[6][9] ), 
        .QN(n2348) );
  DFFRX1 FIFO_reg48 ( .D(FIFO23260), .CK(Clk), .RN(nRST), .Q(\FIFO[6][8] ), 
        .QN(n2350) );
  DFFRX1 FIFO_reg49 ( .D(FIFO23263), .CK(Clk), .RN(nRST), .Q(\FIFO[6][5] ), 
        .QN(n2388) );
  DFFRX1 FIFO_reg50 ( .D(FIFO23264), .CK(Clk), .RN(nRST), .Q(\FIFO[6][4] ), 
        .QN(n2389) );
  DFFRX1 FIFO_reg51 ( .D(FIFO23265), .CK(Clk), .RN(nRST), .Q(\FIFO[6][3] ), 
        .QN(n2354) );
  DFFRX1 FIFO_reg52 ( .D(FIFO23266), .CK(Clk), .RN(nRST), .Q(\FIFO[6][2] ), 
        .QN(n2390) );
  DFFRX1 FIFO_reg53 ( .D(FIFO23267), .CK(Clk), .RN(nRST), .Q(\FIFO[6][1] ), 
        .QN(n2391) );
  DFFRX1 FIFO_reg54 ( .D(FIFO23268), .CK(Clk), .RN(nRST), .Q(\FIFO[6][0] ), 
        .QN(n2309) );
  DFFRX1 FIFO_reg55 ( .D(FIFO23269), .CK(Clk), .RN(nRST), .Q(\FIFO[7][9] ), 
        .QN(n2417) );
  DFFRX1 FIFO_reg56 ( .D(FIFO23270), .CK(Clk), .RN(nRST), .Q(\FIFO[7][8] ), 
        .QN(n2418) );
  DFFRX1 FIFO_reg57 ( .D(FIFO23273), .CK(Clk), .RN(nRST), .Q(\FIFO[7][5] ), 
        .QN(n2461) );
  DFFRX1 FIFO_reg58 ( .D(FIFO23274), .CK(Clk), .RN(nRST), .Q(\FIFO[7][4] ), 
        .QN(n2462) );
  DFFRX1 FIFO_reg59 ( .D(FIFO23275), .CK(Clk), .RN(nRST), .Q(\FIFO[7][3] ), 
        .QN(n2419) );
  DFFRX1 FIFO_reg60 ( .D(FIFO23276), .CK(Clk), .RN(nRST), .Q(\FIFO[7][2] ), 
        .QN(n2463) );
  DFFRX1 FIFO_reg61 ( .D(FIFO23277), .CK(Clk), .RN(nRST), .Q(\FIFO[7][1] ), 
        .QN(n2464) );
  DFFRX1 FIFO_reg62 ( .D(FIFO23278), .CK(Clk), .RN(nRST), .Q(\FIFO[7][0] ), 
        .QN(n2359) );
  DFFRX1 FIFO_reg63 ( .D(FIFO23279), .CK(Clk), .RN(nRST), .Q(\FIFO[8][9] ), 
        .QN(n2334) );
  DFFRX1 FIFO_reg64 ( .D(FIFO23280), .CK(Clk), .RN(nRST), .Q(\FIFO[8][8] ), 
        .QN(n2335) );
  DFFRX1 FIFO_reg65 ( .D(FIFO23283), .CK(Clk), .RN(nRST), .Q(\FIFO[8][5] ), 
        .QN(n2378) );
  DFFRX1 FIFO_reg66 ( .D(FIFO23284), .CK(Clk), .RN(nRST), .Q(\FIFO[8][4] ), 
        .QN(n2379) );
  DFFRX1 FIFO_reg67 ( .D(FIFO23285), .CK(Clk), .RN(nRST), .Q(\FIFO[8][3] ), 
        .QN(n2336) );
  DFFRX1 FIFO_reg68 ( .D(FIFO23286), .CK(Clk), .RN(nRST), .Q(\FIFO[8][2] ), 
        .QN(n2380) );
  DFFRX1 FIFO_reg69 ( .D(FIFO23287), .CK(Clk), .RN(nRST), .Q(\FIFO[8][1] ), 
        .QN(n2381) );
  DFFRX1 FIFO_reg70 ( .D(FIFO23288), .CK(Clk), .RN(nRST), .Q(\FIFO[8][0] ), 
        .QN(n2449) );
  DFFRX1 FIFO_reg71 ( .D(FIFO23289), .CK(Clk), .RN(nRST), .Q(\FIFO[9][9] ), 
        .QN(n2434) );
  DFFRX1 FIFO_reg72 ( .D(FIFO23290), .CK(Clk), .RN(nRST), .Q(\FIFO[9][8] ), 
        .QN(n2300) );
  DFFRX1 FIFO_reg73 ( .D(FIFO23293), .CK(Clk), .RN(nRST), .Q(\FIFO[9][5] ), 
        .QN(n2314) );
  DFFRX1 FIFO_reg74 ( .D(FIFO23294), .CK(Clk), .RN(nRST), .Q(\FIFO[9][4] ), 
        .QN(n2315) );
  DFFRX1 FIFO_reg75 ( .D(FIFO23295), .CK(Clk), .RN(nRST), .Q(\FIFO[9][3] ), 
        .QN(n2301) );
  DFFRX1 FIFO_reg76 ( .D(FIFO23296), .CK(Clk), .RN(nRST), .Q(\FIFO[9][2] ), 
        .QN(n2435) );
  DFFRX1 FIFO_reg77 ( .D(FIFO23297), .CK(Clk), .RN(nRST), .Q(\FIFO[9][1] ), 
        .QN(n2436) );
  DFFRX1 FIFO_reg78 ( .D(FIFO23298), .CK(Clk), .RN(nRST), .Q(\FIFO[9][0] ), 
        .QN(n2333) );
  DFFRX1 FIFO_reg79 ( .D(FIFO23299), .CK(Clk), .RN(nRST), .Q(\FIFO[10][9] ), 
        .QN(n2337) );
  DFFRX1 FIFO_reg80 ( .D(FIFO232100), .CK(Clk), .RN(nRST), .Q(\FIFO[10][8] ), 
        .QN(n2339) );
  DFFRX1 FIFO_reg81 ( .D(FIFO232103), .CK(Clk), .RN(nRST), .Q(\FIFO[10][5] ), 
        .QN(n2340) );
  DFFRX1 FIFO_reg82 ( .D(FIFO232104), .CK(Clk), .RN(nRST), .Q(\FIFO[10][4] ), 
        .QN(n2305) );
  DFFRX1 FIFO_reg83 ( .D(FIFO232105), .CK(Clk), .RN(nRST), .Q(\FIFO[10][3] ), 
        .QN(n2341) );
  DFFRX1 FIFO_reg84 ( .D(FIFO232106), .CK(Clk), .RN(nRST), .Q(\FIFO[10][2] ), 
        .QN(n2342) );
  DFFRX1 FIFO_reg85 ( .D(FIFO232107), .CK(Clk), .RN(nRST), .Q(\FIFO[10][1] ), 
        .QN(n2344) );
  DFFRX1 FIFO_reg86 ( .D(FIFO232108), .CK(Clk), .RN(nRST), .Q(\FIFO[10][0] ), 
        .QN(n2346) );
  DFFRX1 FIFO_reg87 ( .D(FIFO232109), .CK(Clk), .RN(nRST), .Q(\FIFO[11][9] ), 
        .QN(n2410) );
  DFFRX1 FIFO_reg88 ( .D(FIFO232110), .CK(Clk), .RN(nRST), .Q(\FIFO[11][8] ), 
        .QN(n2411) );
  DFFRX1 FIFO_reg89 ( .D(FIFO232113), .CK(Clk), .RN(nRST), .Q(\FIFO[11][5] ), 
        .QN(n2412) );
  DFFRX1 FIFO_reg90 ( .D(FIFO232114), .CK(Clk), .RN(nRST), .Q(\FIFO[11][4] ), 
        .QN(n2459) );
  DFFRX1 FIFO_reg91 ( .D(FIFO232115), .CK(Clk), .RN(nRST), .Q(\FIFO[11][3] ), 
        .QN(n2413) );
  DFFRX1 FIFO_reg92 ( .D(FIFO232116), .CK(Clk), .RN(nRST), .Q(\FIFO[11][2] ), 
        .QN(n2414) );
  DFFRX1 FIFO_reg93 ( .D(FIFO232117), .CK(Clk), .RN(nRST), .Q(\FIFO[11][1] ), 
        .QN(n2415) );
  DFFRX1 FIFO_reg94 ( .D(FIFO232118), .CK(Clk), .RN(nRST), .Q(\FIFO[11][0] ), 
        .QN(n2416) );
  DFFRX1 FIFO_reg95 ( .D(FIFO232119), .CK(Clk), .RN(nRST), .Q(\FIFO[12][9] ), 
        .QN(n2306) );
  DFFRX1 FIFO_reg96 ( .D(FIFO232120), .CK(Clk), .RN(nRST), .Q(\FIFO[12][8] ), 
        .QN(n2349) );
  DFFRX1 FIFO_reg97 ( .D(FIFO232123), .CK(Clk), .RN(nRST), .Q(\FIFO[12][5] ), 
        .QN(n2351) );
  DFFRX1 FIFO_reg98 ( .D(FIFO232124), .CK(Clk), .RN(nRST), .Q(\FIFO[12][4] ), 
        .QN(n2352) );
  DFFRX1 FIFO_reg99 ( .D(FIFO232125), .CK(Clk), .RN(nRST), .Q(\FIFO[12][3] ), 
        .QN(n2353) );
  DFFRX1 FIFO_reg100 ( .D(FIFO232126), .CK(Clk), .RN(nRST), .Q(\FIFO[12][2] ), 
        .QN(n2307) );
  DFFRX1 FIFO_reg101 ( .D(FIFO232127), .CK(Clk), .RN(nRST), .Q(\FIFO[12][1] ), 
        .QN(n2308) );
  DFFRX1 FIFO_reg102 ( .D(FIFO232128), .CK(Clk), .RN(nRST), .Q(\FIFO[12][0] ), 
        .QN(n2355) );
  DFFRX1 FIFO_reg103 ( .D(FIFO232129), .CK(Clk), .RN(nRST), .Q(\FIFO[13][9] ), 
        .QN(n2356) );
  DFFRX1 FIFO_reg104 ( .D(FIFO232130), .CK(Clk), .RN(nRST), .Q(\FIFO[13][8] ), 
        .QN(n2407) );
  DFFRX1 FIFO_reg105 ( .D(FIFO232133), .CK(Clk), .RN(nRST), .Q(\FIFO[13][5] ), 
        .QN(n2455) );
  DFFRX1 FIFO_reg106 ( .D(FIFO232134), .CK(Clk), .RN(nRST), .Q(\FIFO[13][4] ), 
        .QN(n2456) );
  DFFRX1 FIFO_reg107 ( .D(FIFO232135), .CK(Clk), .RN(nRST), .Q(\FIFO[13][3] ), 
        .QN(n2408) );
  DFFRX1 FIFO_reg108 ( .D(FIFO232136), .CK(Clk), .RN(nRST), .Q(\FIFO[13][2] ), 
        .QN(n2357) );
  DFFRX1 FIFO_reg109 ( .D(FIFO232137), .CK(Clk), .RN(nRST), .Q(\FIFO[13][1] ), 
        .QN(n2358) );
  DFFRX1 FIFO_reg110 ( .D(FIFO232138), .CK(Clk), .RN(nRST), .Q(\FIFO[13][0] ), 
        .QN(n2409) );
  DFFRX1 FIFO_reg111 ( .D(FIFO232139), .CK(Clk), .RN(nRST), .Q(\FIFO[14][9] ), 
        .QN(n2327) );
  DFFRX1 FIFO_reg112 ( .D(FIFO232140), .CK(Clk), .RN(nRST), .Q(\FIFO[14][8] ), 
        .QN(n2399) );
  DFFRX1 FIFO_reg113 ( .D(FIFO232143), .CK(Clk), .RN(nRST), .Q(\FIFO[14][5] ), 
        .QN(n2425) );
  DFFRX1 FIFO_reg114 ( .D(FIFO232144), .CK(Clk), .RN(nRST), .Q(\FIFO[14][4] ), 
        .QN(n2426) );
  DFFRX1 FIFO_reg115 ( .D(FIFO232145), .CK(Clk), .RN(nRST), .Q(\FIFO[14][3] ), 
        .QN(n2400) );
  DFFRX1 FIFO_reg116 ( .D(FIFO232146), .CK(Clk), .RN(nRST), .Q(\FIFO[14][2] ), 
        .QN(n2427) );
  DFFRX1 FIFO_reg117 ( .D(FIFO232147), .CK(Clk), .RN(nRST), .Q(\FIFO[14][1] ), 
        .QN(n2428) );
  DFFRX1 FIFO_reg118 ( .D(FIFO232148), .CK(Clk), .RN(nRST), .Q(\FIFO[14][0] ), 
        .QN(n2429) );
  DFFRX1 FIFO_reg119 ( .D(FIFO232149), .CK(Clk), .RN(nRST), .Q(\FIFO[15][9] ), 
        .QN(n2423) );
  DFFRX1 FIFO_reg120 ( .D(FIFO232150), .CK(Clk), .RN(nRST), .Q(\FIFO[15][8] ), 
        .QN(n2324) );
  DFFRX1 FIFO_reg121 ( .D(FIFO232153), .CK(Clk), .RN(nRST), .Q(\FIFO[15][5] ), 
        .QN(n2362) );
  DFFRX1 FIFO_reg122 ( .D(FIFO232154), .CK(Clk), .RN(nRST), .Q(\FIFO[15][4] ), 
        .QN(n2363) );
  DFFRX1 FIFO_reg123 ( .D(FIFO232155), .CK(Clk), .RN(nRST), .Q(\FIFO[15][3] ), 
        .QN(n2325) );
  DFFRX1 FIFO_reg124 ( .D(FIFO232156), .CK(Clk), .RN(nRST), .Q(\FIFO[15][2] ), 
        .QN(n2364) );
  DFFRX1 FIFO_reg125 ( .D(FIFO232157), .CK(Clk), .RN(nRST), .Q(\FIFO[15][1] ), 
        .QN(n2365) );
  DFFRX1 FIFO_reg126 ( .D(FIFO232158), .CK(Clk), .RN(nRST), .Q(\FIFO[15][0] ), 
        .QN(n2326) );
  DFFRX1 FIFO_reg127 ( .D(FIFO2321), .CK(Clk), .RN(nRST), .Q(\FIFO[0][7] ), 
        .QN(n2466) );
  DFFRX1 FIFO_reg128 ( .D(FIFO2322), .CK(Clk), .RN(nRST), .Q(\FIFO[0][6] ), 
        .QN(n2366) );
  DFFRX1 FIFO_reg129 ( .D(FIFO23211), .CK(Clk), .RN(nRST), .Q(\FIFO[1][7] ), 
        .QN(n2318) );
  DFFRX1 FIFO_reg130 ( .D(FIFO23212), .CK(Clk), .RN(nRST), .Q(\FIFO[1][6] ), 
        .QN(n2420) );
  DFFRX1 FIFO_reg131 ( .D(FIFO23221), .CK(Clk), .RN(nRST), .Q(\FIFO[2][7] ), 
        .QN(n2383) );
  DFFRX1 FIFO_reg132 ( .D(FIFO23222), .CK(Clk), .RN(nRST), .Q(\FIFO[2][6] ), 
        .QN(n2450) );
  DFFRX1 FIFO_reg133 ( .D(FIFO23231), .CK(Clk), .RN(nRST), .Q(\FIFO[3][7] ), 
        .QN(n2446) );
  DFFRX1 FIFO_reg134 ( .D(FIFO23232), .CK(Clk), .RN(nRST), .Q(\FIFO[3][6] ), 
        .QN(n2316) );
  DFFRX1 FIFO_reg135 ( .D(FIFO23241), .CK(Clk), .RN(nRST), .Q(\FIFO[4][7] ), 
        .QN(n2393) );
  DFFRX1 FIFO_reg136 ( .D(FIFO23242), .CK(Clk), .RN(nRST), .Q(\FIFO[4][6] ), 
        .QN(n2370) );
  DFFRX1 FIFO_reg137 ( .D(FIFO23251), .CK(Clk), .RN(nRST), .Q(\FIFO[5][7] ), 
        .QN(n2469) );
  DFFRX1 FIFO_reg138 ( .D(FIFO23252), .CK(Clk), .RN(nRST), .Q(\FIFO[5][6] ), 
        .QN(n2439) );
  DFFRX1 FIFO_reg139 ( .D(FIFO23261), .CK(Clk), .RN(nRST), .Q(\FIFO[6][7] ), 
        .QN(n2317) );
  DFFRX1 FIFO_reg140 ( .D(FIFO23262), .CK(Clk), .RN(nRST), .Q(\FIFO[6][6] ), 
        .QN(n2387) );
  DFFRX1 FIFO_reg141 ( .D(FIFO23271), .CK(Clk), .RN(nRST), .Q(\FIFO[7][7] ), 
        .QN(n2392) );
  DFFRX1 FIFO_reg142 ( .D(FIFO23272), .CK(Clk), .RN(nRST), .Q(\FIFO[7][6] ), 
        .QN(n2460) );
  DFFRX1 FIFO_reg143 ( .D(FIFO23281), .CK(Clk), .RN(nRST), .Q(\FIFO[8][7] ), 
        .QN(n2470) );
  DFFRX1 FIFO_reg144 ( .D(FIFO23282), .CK(Clk), .RN(nRST), .Q(\FIFO[8][6] ), 
        .QN(n2377) );
  DFFRX1 FIFO_reg145 ( .D(FIFO23291), .CK(Clk), .RN(nRST), .Q(\FIFO[9][7] ), 
        .QN(n2375) );
  DFFRX1 FIFO_reg146 ( .D(FIFO23292), .CK(Clk), .RN(nRST), .Q(\FIFO[9][6] ), 
        .QN(n2313) );
  DFFRX1 FIFO_reg147 ( .D(FIFO232101), .CK(Clk), .RN(nRST), .Q(\FIFO[10][7] ), 
        .QN(n2382) );
  DFFRX1 FIFO_reg148 ( .D(FIFO232102), .CK(Clk), .RN(nRST), .Q(\FIFO[10][6] ), 
        .QN(n2384) );
  DFFRX1 FIFO_reg149 ( .D(FIFO232111), .CK(Clk), .RN(nRST), .Q(\FIFO[11][7] ), 
        .QN(n2457) );
  DFFRX1 FIFO_reg150 ( .D(FIFO232112), .CK(Clk), .RN(nRST), .Q(\FIFO[11][6] ), 
        .QN(n2458) );
  DFFRX1 FIFO_reg151 ( .D(FIFO232121), .CK(Clk), .RN(nRST), .Q(\FIFO[12][7] ), 
        .QN(n2385) );
  DFFRX1 FIFO_reg152 ( .D(FIFO232122), .CK(Clk), .RN(nRST), .Q(\FIFO[12][6] ), 
        .QN(n2386) );
  DFFRX1 FIFO_reg153 ( .D(FIFO232131), .CK(Clk), .RN(nRST), .Q(\FIFO[13][7] ), 
        .QN(n2453) );
  DFFRX1 FIFO_reg154 ( .D(FIFO232132), .CK(Clk), .RN(nRST), .Q(\FIFO[13][6] ), 
        .QN(n2454) );
  DFFRX1 FIFO_reg155 ( .D(FIFO232141), .CK(Clk), .RN(nRST), .Q(\FIFO[14][7] ), 
        .QN(n2465) );
  DFFRX1 FIFO_reg156 ( .D(FIFO232142), .CK(Clk), .RN(nRST), .Q(\FIFO[14][6] ), 
        .QN(n2424) );
  DFFRX1 FIFO_reg157 ( .D(FIFO232151), .CK(Clk), .RN(nRST), .Q(\FIFO[15][7] ), 
        .QN(n2360) );
  DFFRX1 FIFO_reg158 ( .D(FIFO232152), .CK(Clk), .RN(nRST), .Q(\FIFO[15][6] ), 
        .QN(n2361) );
  DFFRX1 WrCnt_reg_0_ ( .D(n1771), .CK(Clk), .RN(nRST), .Q(WrCnt_0_) );
  DFFRX1 WrCnt_reg_3_ ( .D(n1768), .CK(Clk), .RN(nRST), .Q(WrCnt_3_), .QN(
        n2487) );
  DFFRX1 WrCnt_reg_1_ ( .D(n1770), .CK(Clk), .RN(nRST), .Q(WrCnt_1_), .QN(
        n2468) );
  DFFSX1 DatCnt_reg_0_ ( .D(n1792), .CK(Clk), .SN(nRST), .Q(EmptyFlag), .QN(
        n2475) );
  DFFRX1 WrCnt_reg_2_ ( .D(n1769), .CK(Clk), .RN(nRST), .Q(WrCnt_2_), .QN(
        n2467) );
  DFFRX1 DatCnt_reg_15_ ( .D(n1777), .CK(Clk), .RN(nRST), .QN(n2483) );
  DFFRX1 DatCnt_reg_1_ ( .D(n1791), .CK(Clk), .RN(nRST), .QN(n2482) );
  DFFRX1 DatCnt_reg_14_ ( .D(n1778), .CK(Clk), .RN(nRST), .QN(n2322) );
  DFFRX1 DatCnt_reg_13_ ( .D(n1779), .CK(Clk), .RN(nRST), .QN(n2298) );
  DFFRX1 DatCnt_reg_12_ ( .D(n1780), .CK(Clk), .RN(nRST), .QN(n2471) );
  DFFRX1 DatCnt_reg_11_ ( .D(n1781), .CK(Clk), .RN(nRST), .QN(n2319) );
  DFFRX1 DatCnt_reg_10_ ( .D(n1782), .CK(Clk), .RN(nRST), .QN(n2394) );
  DFFRX1 DatCnt_reg_9_ ( .D(n1783), .CK(Clk), .RN(nRST), .QN(n2472) );
  DFFRX1 DatCnt_reg_8_ ( .D(n1784), .CK(Clk), .RN(nRST), .QN(n2320) );
  DFFRX1 DatCnt_reg_7_ ( .D(n1785), .CK(Clk), .RN(nRST), .QN(n2395) );
  DFFRX1 DatCnt_reg_6_ ( .D(n1786), .CK(Clk), .RN(nRST), .QN(n2473) );
  DFFRX1 DatCnt_reg_5_ ( .D(n1787), .CK(Clk), .RN(nRST), .QN(n2321) );
  DFFRX1 DatCnt_reg_4_ ( .D(n1788), .CK(Clk), .RN(nRST), .QN(n2396) );
  DFFRX1 DatCnt_reg_3_ ( .D(n1789), .CK(Clk), .RN(nRST), .QN(n2474) );
endmodule


module SDRBLQ_BLQCD0_BLQD1_BLQW9 ( nRST, Clk, WriteEn, ReadEn, WrData, RdData, 
        FullFlag, EmptyFlag );
  input [9:0] WrData;
  output [9:0] RdData;
  input nRST, Clk, WriteEn, ReadEn;
  output FullFlag, EmptyFlag;
  wire   DatCnt_1_, RdCnt_0_, \FIFO[0][9] , \FIFO[0][8] , \FIFO[0][7] ,
         \FIFO[0][6] , \FIFO[0][5] , \FIFO[0][4] , \FIFO[0][3] , \FIFO[0][2] ,
         \FIFO[0][1] , \FIFO[0][0] , \FIFO[1][9] , \FIFO[1][8] , \FIFO[1][7] ,
         \FIFO[1][6] , \FIFO[1][5] , \FIFO[1][4] , \FIFO[1][3] , \FIFO[1][2] ,
         \FIFO[1][1] , \FIFO[1][0] , WrCnt_0_, FIFO230, FIFO2300, FIFO2301,
         FIFO2302, FIFO2303, FIFO2304, FIFO2305, FIFO2306, FIFO2307, FIFO2308,
         FIFO2309, FIFO23010, FIFO23011, FIFO23012, FIFO23013, FIFO23014,
         FIFO23015, FIFO23016, FIFO23017, FIFO23018, n534, n535, n536, n537,
         n538, n542, n544, n545, n547, n549, n550, n552, n554, n555, n556,
         n557, n558, n559, n560, n561;

  INVX1 U246 ( .A(n542), .Y(n545) );
  INVX1 U247 ( .A(ReadEn), .Y(n544) );
  XOR2X1 U248 ( .A(n544), .B(WriteEn), .Y(n542) );
  OAI32X1 U249 ( .A0(n542), .A1(n555), .A2(n544), .B0(n545), .B1(n558), .Y(
        n538) );
  OAI32X1 U250 ( .A0(n542), .A1(ReadEn), .A2(n555), .B0(n545), .B1(n556), .Y(
        n536) );
  XOR2X1 U251 ( .A(ReadEn), .B(n561), .Y(n535) );
  INVX1 U252 ( .A(n554), .Y(n550) );
  INVX1 U253 ( .A(WriteEn), .Y(n549) );
  AO21X1 U254 ( .A0(n542), .A1(DatCnt_1_), .B0(n547), .Y(n537) );
  OAI33X1 U255 ( .A0(n542), .A1(n556), .A2(n544), .B0(n542), .B1(ReadEn), .B2(
        n558), .Y(n547) );
  AO22X1 U256 ( .A0(\FIFO[1][6] ), .A1(n561), .B0(\FIFO[0][6] ), .B1(n557), 
        .Y(RdData[6]) );
  AO22X1 U257 ( .A0(\FIFO[1][0] ), .A1(n561), .B0(\FIFO[0][0] ), .B1(n557), 
        .Y(RdData[0]) );
  AO22X1 U258 ( .A0(\FIFO[1][5] ), .A1(n561), .B0(\FIFO[0][5] ), .B1(n557), 
        .Y(RdData[5]) );
  AO22X1 U259 ( .A0(\FIFO[1][3] ), .A1(n561), .B0(\FIFO[0][3] ), .B1(n557), 
        .Y(RdData[3]) );
  AO22X1 U260 ( .A0(\FIFO[1][2] ), .A1(n561), .B0(\FIFO[0][2] ), .B1(n557), 
        .Y(RdData[2]) );
  AO22X1 U261 ( .A0(\FIFO[1][1] ), .A1(n561), .B0(\FIFO[0][1] ), .B1(n557), 
        .Y(RdData[1]) );
  AO22X1 U262 ( .A0(\FIFO[1][4] ), .A1(n561), .B0(\FIFO[0][4] ), .B1(n557), 
        .Y(RdData[4]) );
  AO22X1 U263 ( .A0(\FIFO[1][9] ), .A1(n561), .B0(\FIFO[0][9] ), .B1(n557), 
        .Y(RdData[9]) );
  AO22X1 U264 ( .A0(\FIFO[1][8] ), .A1(n561), .B0(\FIFO[0][8] ), .B1(n557), 
        .Y(RdData[8]) );
  BUFX2 U265 ( .A(RdCnt_0_), .Y(n561) );
  AO22X1 U266 ( .A0(\FIFO[1][7] ), .A1(n561), .B0(\FIFO[0][7] ), .B1(n557), 
        .Y(RdData[7]) );
  NAND2BX1 U267 ( .AN(WrCnt_0_), .B(WriteEn), .Y(n554) );
  NOR2X1 U268 ( .A(n549), .B(n560), .Y(n559) );
  INVX1 U269 ( .A(n559), .Y(n552) );
  AO22X1 U270 ( .A0(\FIFO[0][0] ), .A1(n554), .B0(n550), .B1(WrData[0]), .Y(
        FIFO2308) );
  AO22X1 U271 ( .A0(\FIFO[1][0] ), .A1(n552), .B0(WrData[0]), .B1(n559), .Y(
        FIFO23018) );
  AO22X1 U272 ( .A0(\FIFO[0][1] ), .A1(n554), .B0(n550), .B1(WrData[1]), .Y(
        FIFO2307) );
  AO22X1 U273 ( .A0(\FIFO[1][1] ), .A1(n552), .B0(WrData[1]), .B1(n559), .Y(
        FIFO23017) );
  AO22X1 U274 ( .A0(\FIFO[0][3] ), .A1(n554), .B0(n550), .B1(WrData[3]), .Y(
        FIFO2305) );
  AO22X1 U275 ( .A0(\FIFO[1][3] ), .A1(n552), .B0(WrData[3]), .B1(n559), .Y(
        FIFO23015) );
  AO22X1 U276 ( .A0(\FIFO[0][2] ), .A1(n554), .B0(n550), .B1(WrData[2]), .Y(
        FIFO2306) );
  AO22X1 U277 ( .A0(\FIFO[1][2] ), .A1(n552), .B0(WrData[2]), .B1(n559), .Y(
        FIFO23016) );
  AO22X1 U278 ( .A0(\FIFO[1][9] ), .A1(n552), .B0(WrData[9]), .B1(n559), .Y(
        FIFO2309) );
  AO22X1 U279 ( .A0(\FIFO[1][8] ), .A1(n552), .B0(WrData[8]), .B1(n559), .Y(
        FIFO23010) );
  AO22X1 U280 ( .A0(\FIFO[1][7] ), .A1(n552), .B0(WrData[7]), .B1(n559), .Y(
        FIFO23011) );
  AO22X1 U281 ( .A0(\FIFO[1][6] ), .A1(n552), .B0(WrData[6]), .B1(n559), .Y(
        FIFO23012) );
  AO22X1 U282 ( .A0(\FIFO[1][5] ), .A1(n552), .B0(WrData[5]), .B1(n559), .Y(
        FIFO23013) );
  AO22X1 U283 ( .A0(\FIFO[1][4] ), .A1(n552), .B0(WrData[4]), .B1(n559), .Y(
        FIFO23014) );
  AO22X1 U284 ( .A0(\FIFO[0][8] ), .A1(n554), .B0(n550), .B1(WrData[8]), .Y(
        FIFO2300) );
  AO22X1 U285 ( .A0(\FIFO[0][9] ), .A1(n554), .B0(n550), .B1(WrData[9]), .Y(
        FIFO230) );
  AO22X1 U286 ( .A0(\FIFO[0][7] ), .A1(n554), .B0(n550), .B1(WrData[7]), .Y(
        FIFO2301) );
  AO22X1 U287 ( .A0(\FIFO[0][6] ), .A1(n554), .B0(n550), .B1(WrData[6]), .Y(
        FIFO2302) );
  AO22X1 U288 ( .A0(\FIFO[0][5] ), .A1(n554), .B0(n550), .B1(WrData[5]), .Y(
        FIFO2303) );
  AO22X1 U289 ( .A0(\FIFO[0][4] ), .A1(n554), .B0(n550), .B1(WrData[4]), .Y(
        FIFO2304) );
  AO21X1 U290 ( .A0(WrCnt_0_), .A1(n549), .B0(n550), .Y(n534) );
  DFFRX1 DatCnt_reg_2_ ( .D(n536), .CK(Clk), .RN(nRST), .Q(FullFlag), .QN(n556) );
  DFFRX1 RdCnt_reg_0_ ( .D(n535), .CK(Clk), .RN(nRST), .Q(RdCnt_0_), .QN(n557)
         );
  DFFRX1 FIFO_reg ( .D(FIFO2309), .CK(Clk), .RN(nRST), .Q(\FIFO[1][9] ) );
  DFFRX1 FIFO_reg0 ( .D(FIFO23010), .CK(Clk), .RN(nRST), .Q(\FIFO[1][8] ) );
  DFFRX1 FIFO_reg1 ( .D(FIFO23013), .CK(Clk), .RN(nRST), .Q(\FIFO[1][5] ) );
  DFFRX1 FIFO_reg2 ( .D(FIFO23014), .CK(Clk), .RN(nRST), .Q(\FIFO[1][4] ) );
  DFFRX1 FIFO_reg3 ( .D(FIFO23015), .CK(Clk), .RN(nRST), .Q(\FIFO[1][3] ) );
  DFFRX1 FIFO_reg4 ( .D(FIFO23016), .CK(Clk), .RN(nRST), .Q(\FIFO[1][2] ) );
  DFFRX1 FIFO_reg5 ( .D(FIFO23017), .CK(Clk), .RN(nRST), .Q(\FIFO[1][1] ) );
  DFFRX1 FIFO_reg6 ( .D(FIFO23018), .CK(Clk), .RN(nRST), .Q(\FIFO[1][0] ) );
  DFFRX1 FIFO_reg7 ( .D(FIFO230), .CK(Clk), .RN(nRST), .Q(\FIFO[0][9] ) );
  DFFRX1 FIFO_reg8 ( .D(FIFO2300), .CK(Clk), .RN(nRST), .Q(\FIFO[0][8] ) );
  DFFRX1 FIFO_reg9 ( .D(FIFO2303), .CK(Clk), .RN(nRST), .Q(\FIFO[0][5] ) );
  DFFRX1 FIFO_reg10 ( .D(FIFO2304), .CK(Clk), .RN(nRST), .Q(\FIFO[0][4] ) );
  DFFRX1 FIFO_reg11 ( .D(FIFO2305), .CK(Clk), .RN(nRST), .Q(\FIFO[0][3] ) );
  DFFRX1 FIFO_reg12 ( .D(FIFO2306), .CK(Clk), .RN(nRST), .Q(\FIFO[0][2] ) );
  DFFRX1 FIFO_reg13 ( .D(FIFO2307), .CK(Clk), .RN(nRST), .Q(\FIFO[0][1] ) );
  DFFRX1 FIFO_reg14 ( .D(FIFO2308), .CK(Clk), .RN(nRST), .Q(\FIFO[0][0] ) );
  DFFRX1 FIFO_reg15 ( .D(FIFO23011), .CK(Clk), .RN(nRST), .Q(\FIFO[1][7] ) );
  DFFRX1 FIFO_reg16 ( .D(FIFO23012), .CK(Clk), .RN(nRST), .Q(\FIFO[1][6] ) );
  DFFRX1 FIFO_reg17 ( .D(FIFO2301), .CK(Clk), .RN(nRST), .Q(\FIFO[0][7] ) );
  DFFRX1 FIFO_reg18 ( .D(FIFO2302), .CK(Clk), .RN(nRST), .Q(\FIFO[0][6] ) );
  DFFSX1 DatCnt_reg_0_ ( .D(n538), .CK(Clk), .SN(nRST), .Q(EmptyFlag), .QN(
        n558) );
  DFFRX1 DatCnt_reg_1_ ( .D(n537), .CK(Clk), .RN(nRST), .Q(DatCnt_1_), .QN(
        n555) );
  DFFRX1 WrCnt_reg_0_ ( .D(n534), .CK(Clk), .RN(nRST), .Q(WrCnt_0_), .QN(n560)
         );
endmodule


module SDRRQ ( nRST, nClk, Clk, WriteEn, ReadEn, WrData, RdData, FullFlag, 
        HFullFlag, EmptyFlag, WrapCnt, IncRdCnt );
  input [35:0] WrData;
  output [35:0] RdData;
  input [7:0] WrapCnt;
  output [7:0] IncRdCnt;
  input nRST, nClk, Clk, WriteEn, ReadEn;
  output FullFlag, HFullFlag, EmptyFlag;
  wire   DatCnt_7_, DatCnt_5_, DatCnt_4_, DatCnt_3_, DatCnt_2_, DatCnt_1_,
         DatCnt_0_, n_167, n_168, WrCnt90_6_, WrCnt90_5_, WrCnt90_4_,
         WrCnt90_3_, WrCnt90_2_, WrCnt90_1_, IncRdCnt150_6_, IncRdCnt150_5_,
         IncRdCnt150_4_, IncRdCnt150_3_, IncRdCnt150_2_, IncRdCnt150_1_,
         DatCnt247_7_, DatCnt247_6_, DatCnt247_5_, DatCnt247_4_, DatCnt247_3_,
         DatCnt247_2_, DatCnt247_1_, DatCnt251_6_, DatCnt251_5_, DatCnt251_4_,
         DatCnt251_3_, DatCnt251_2_, DatCnt251_1_, n508, n509, n510, n511,
         n512, n513, n514, n515, n516, n517, n518, n519, n520, n521, n522,
         n523, n524, n525, n526, n527, n528, n529, n530, n531, carry, carry0,
         carry1, carry2, carry3, n12, n22, n32, n42, n52, n62, carry4, carry5,
         carry6, carry7, carry8, n11, n21, n31, n41, n51, n61, carry_7_,
         carry9, carry10, carry11, carry12, carry13, carry_6_, carry_5_,
         carry_4_, carry_3_, carry_2_, n1, n2, n3, n4, n5, n6, n533, n534,
         n536, n537, n538, n539, n540, n541, n542, n543, n544, n545, n546,
         n547, n549, n550, n551, n553, n554, n557, n558, n561, n562, n566,
         n567, n568, n569, n570, n571, n572, n573, n574, n575, n576;
  wire   [7:0] WrCnt;

  RF2SH256x32 RQL ( .CENB(n_168), .AB(WrCnt), .DB(WrData[31:0]), .CENA(n_167), 
        .AA(WrapCnt), .CLKB(Clk), .CLKA(nClk), .QA(RdData[31:0]) );
  RF2SH256x4 RQH ( .CENB(n_168), .AB(WrCnt), .DB(WrData[35:32]), .CENA(n_167), 
        .AA(WrapCnt), .CLKB(Clk), .CLKA(nClk), .QA(RdData[35:32]) );
  AHHCONX2 U1_1_12 ( .A(WrCnt[1]), .CI(WrCnt[0]), .S(WrCnt90_1_), .CON(n62) );
  AHHCONX2 U1_1_22 ( .A(WrCnt[2]), .CI(carry3), .S(WrCnt90_2_), .CON(n52) );
  AHHCONX2 U1_1_32 ( .A(WrCnt[3]), .CI(carry2), .S(WrCnt90_3_), .CON(n42) );
  AHHCONX2 U1_1_42 ( .A(WrCnt[4]), .CI(carry1), .S(WrCnt90_4_), .CON(n32) );
  AHHCONX2 U1_1_52 ( .A(WrCnt[5]), .CI(carry0), .S(WrCnt90_5_), .CON(n22) );
  AHHCONX2 U1_1_62 ( .A(WrCnt[6]), .CI(carry), .S(WrCnt90_6_), .CON(n12) );
  AHHCONX2 U1_1_11 ( .A(IncRdCnt[1]), .CI(IncRdCnt[0]), .S(IncRdCnt150_1_), 
        .CON(n61) );
  AHHCONX2 U1_1_21 ( .A(IncRdCnt[2]), .CI(carry8), .S(IncRdCnt150_2_), .CON(
        n51) );
  AHHCONX2 U1_1_31 ( .A(IncRdCnt[3]), .CI(carry7), .S(IncRdCnt150_3_), .CON(
        n41) );
  AHHCONX2 U1_1_41 ( .A(IncRdCnt[4]), .CI(carry6), .S(IncRdCnt150_4_), .CON(
        n31) );
  AHHCONX2 U1_1_51 ( .A(IncRdCnt[5]), .CI(carry5), .S(IncRdCnt150_5_), .CON(
        n21) );
  AHHCONX2 U1_1_61 ( .A(IncRdCnt[6]), .CI(carry4), .S(IncRdCnt150_6_), .CON(
        n11) );
  AHHCONX2 U1_1_1 ( .A(DatCnt_1_), .CI(DatCnt_0_), .S(DatCnt251_1_), .CON(n6)
         );
  AHHCONX2 U1_1_2 ( .A(DatCnt_2_), .CI(carry_2_), .S(DatCnt251_2_), .CON(n5)
         );
  AHHCONX2 U1_1_3 ( .A(DatCnt_3_), .CI(carry_3_), .S(DatCnt251_3_), .CON(n4)
         );
  AHHCONX2 U1_1_4 ( .A(DatCnt_4_), .CI(carry_4_), .S(DatCnt251_4_), .CON(n3)
         );
  AHHCONX2 U1_1_5 ( .A(DatCnt_5_), .CI(carry_5_), .S(DatCnt251_5_), .CON(n2)
         );
  AHHCONX2 U1_1_6 ( .A(HFullFlag), .CI(carry_6_), .S(DatCnt251_6_), .CON(n1)
         );
  OAI31X1 U275 ( .A0(n_168), .A1(n12), .A2(WrCnt[7]), .B0(n554), .Y(n508) );
  DFFRX1 WrCnt_reg_6_ ( .D(n509), .CK(Clk), .RN(nRST), .Q(WrCnt[6]) );
  DFFRX1 WrCnt_reg_5_ ( .D(n510), .CK(Clk), .RN(nRST), .Q(WrCnt[5]) );
  DFFRX1 WrCnt_reg_4_ ( .D(n511), .CK(Clk), .RN(nRST), .Q(WrCnt[4]) );
  DFFRX1 WrCnt_reg_3_ ( .D(n512), .CK(Clk), .RN(nRST), .Q(WrCnt[3]) );
  DFFRX1 WrCnt_reg_2_ ( .D(n513), .CK(Clk), .RN(nRST), .Q(WrCnt[2]) );
  DFFRX1 WrCnt_reg_1_ ( .D(n514), .CK(Clk), .RN(nRST), .Q(WrCnt[1]) );
  DFFRX1 WrCnt_reg_0_ ( .D(n515), .CK(Clk), .RN(nRST), .Q(WrCnt[0]) );
  DFFRX1 WrCnt_reg_7_ ( .D(n508), .CK(Clk), .RN(nRST), .Q(WrCnt[7]), .QN(n574)
         );
  INVX1 U276 ( .A(n533), .Y(n539) );
  NAND2BX1 U277 ( .AN(n550), .B(n534), .Y(n533) );
  INVX1 U278 ( .A(n536), .Y(n537) );
  NAND2BX1 U279 ( .AN(ReadEn), .B(n534), .Y(n536) );
  INVX1 U280 ( .A(n540), .Y(n534) );
  INVX1 U281 ( .A(ReadEn), .Y(n550) );
  XOR2X1 U282 ( .A(n550), .B(n576), .Y(n540) );
  INVX1 U283 ( .A(n1), .Y(n549) );
  INVX1 U284 ( .A(n576), .Y(n_168) );
  AND4X1 U285 ( .A(n568), .B(n570), .C(n561), .D(n562), .Y(EmptyFlag) );
  NOR2BX1 U286 ( .AN(n572), .B(DatCnt_3_), .Y(n561) );
  AND4X1 U287 ( .A(n567), .B(n571), .C(n566), .D(n569), .Y(n562) );
  NOR2X1 U288 ( .A(n575), .B(ReadEn), .Y(n_167) );
  INVX1 U289 ( .A(n21), .Y(carry4) );
  INVX1 U290 ( .A(n22), .Y(carry) );
  INVX1 U291 ( .A(n2), .Y(carry_6_) );
  INVX1 U292 ( .A(n6), .Y(carry_2_) );
  INVX1 U293 ( .A(n3), .Y(carry_5_) );
  INVX1 U294 ( .A(n4), .Y(carry_4_) );
  INVX1 U295 ( .A(n41), .Y(carry6) );
  INVX1 U296 ( .A(n5), .Y(carry_3_) );
  INVX1 U297 ( .A(n62), .Y(carry3) );
  INVX1 U298 ( .A(n61), .Y(carry8) );
  INVX1 U299 ( .A(n52), .Y(carry2) );
  INVX1 U300 ( .A(n51), .Y(carry7) );
  INVX1 U301 ( .A(n42), .Y(carry1) );
  INVX1 U302 ( .A(n32), .Y(carry0) );
  BUFX2 U303 ( .A(WriteEn), .Y(n576) );
  AND4X1 U304 ( .A(DatCnt_7_), .B(HFullFlag), .C(n557), .D(n558), .Y(FullFlag)
         );
  NOR2BX1 U305 ( .AN(DatCnt_5_), .B(n567), .Y(n557) );
  AND4X1 U306 ( .A(DatCnt_3_), .B(DatCnt_2_), .C(DatCnt_1_), .D(DatCnt_0_), 
        .Y(n558) );
  NAND2BX1 U307 ( .AN(n546), .B(n547), .Y(n524) );
  AO22X1 U308 ( .A0(DatCnt_7_), .A1(n540), .B0(DatCnt247_7_), .B1(n539), .Y(
        n546) );
  AOI33X1 U309 ( .A0(n566), .A1(n549), .A2(n537), .B0(DatCnt_7_), .B1(n1), 
        .B2(n537), .Y(n547) );
  XNOR2X1 U1_A_7 ( .A(DatCnt_7_), .B(carry_7_), .Y(DatCnt247_7_) );
  AO21X1 U310 ( .A0(DatCnt251_6_), .A1(n537), .B0(n545), .Y(n525) );
  AO22X1 U311 ( .A0(DatCnt247_6_), .A1(n539), .B0(HFullFlag), .B1(n540), .Y(
        n545) );
  XNOR2X1 U1_A_6 ( .A(HFullFlag), .B(carry9), .Y(DatCnt247_6_) );
  AO21X1 U312 ( .A0(DatCnt251_5_), .A1(n537), .B0(n544), .Y(n526) );
  AO22X1 U313 ( .A0(DatCnt247_5_), .A1(n539), .B0(DatCnt_5_), .B1(n540), .Y(
        n544) );
  XNOR2X1 U1_A_5 ( .A(DatCnt_5_), .B(carry10), .Y(DatCnt247_5_) );
  AO21X1 U314 ( .A0(DatCnt251_4_), .A1(n537), .B0(n543), .Y(n527) );
  AO22X1 U315 ( .A0(DatCnt247_4_), .A1(n539), .B0(DatCnt_4_), .B1(n540), .Y(
        n543) );
  XNOR2X1 U1_A_4 ( .A(DatCnt_4_), .B(carry11), .Y(DatCnt247_4_) );
  AO21X1 U316 ( .A0(DatCnt251_3_), .A1(n537), .B0(n542), .Y(n528) );
  AO22X1 U317 ( .A0(DatCnt247_3_), .A1(n539), .B0(DatCnt_3_), .B1(n540), .Y(
        n542) );
  XNOR2X1 U1_A_3 ( .A(DatCnt_3_), .B(carry12), .Y(DatCnt247_3_) );
  AO21X1 U318 ( .A0(DatCnt251_2_), .A1(n537), .B0(n541), .Y(n529) );
  AO22X1 U319 ( .A0(DatCnt247_2_), .A1(n539), .B0(DatCnt_2_), .B1(n540), .Y(
        n541) );
  XNOR2X1 U1_A_2 ( .A(DatCnt_2_), .B(carry13), .Y(DatCnt247_2_) );
  AO21X1 U320 ( .A0(DatCnt251_1_), .A1(n537), .B0(n538), .Y(n530) );
  AO22X1 U321 ( .A0(DatCnt247_1_), .A1(n539), .B0(DatCnt_1_), .B1(n540), .Y(
        n538) );
  XNOR2X1 U1_A_1 ( .A(DatCnt_1_), .B(DatCnt_0_), .Y(DatCnt247_1_) );
  OR2X1 U1_B_1 ( .A(DatCnt_1_), .B(DatCnt_0_), .Y(carry13) );
  OR2X1 U1_B_2 ( .A(DatCnt_2_), .B(carry13), .Y(carry12) );
  OR2X1 U1_B_5 ( .A(DatCnt_5_), .B(carry10), .Y(carry9) );
  OR2X1 U1_B_4 ( .A(DatCnt_4_), .B(carry11), .Y(carry10) );
  OR2X1 U1_B_3 ( .A(DatCnt_3_), .B(carry12), .Y(carry11) );
  OAI222X1 U322 ( .A0(DatCnt_0_), .A1(n533), .B0(n534), .B1(n568), .C0(
        DatCnt_0_), .C1(n536), .Y(n531) );
  INVX1 U323 ( .A(n31), .Y(carry5) );
  AO22X1 U324 ( .A0(WrCnt[6]), .A1(n_168), .B0(WrCnt90_6_), .B1(n576), .Y(n509) );
  AO22X1 U325 ( .A0(IncRdCnt[6]), .A1(n550), .B0(IncRdCnt150_6_), .B1(ReadEn), 
        .Y(n517) );
  OR2X1 U1_B_6 ( .A(HFullFlag), .B(carry9), .Y(carry_7_) );
  OAI31X1 U326 ( .A0(n550), .A1(n11), .A2(IncRdCnt[7]), .B0(n551), .Y(n516) );
  OA22X1 U327 ( .A0(ReadEn), .A1(n573), .B0(n573), .B1(n553), .Y(n551) );
  INVX1 U328 ( .A(n11), .Y(n553) );
  AOI2BB2X1 U329 ( .A0N(n576), .A1N(n574), .B0(WrCnt[7]), .B1(n12), .Y(n554)
         );
  XOR2X1 U330 ( .A(ReadEn), .B(IncRdCnt[0]), .Y(n523) );
  XOR2X1 U331 ( .A(n576), .B(WrCnt[0]), .Y(n515) );
  AO22X1 U332 ( .A0(WrCnt[5]), .A1(n_168), .B0(WrCnt90_5_), .B1(n576), .Y(n510) );
  AO22X1 U333 ( .A0(WrCnt[4]), .A1(n_168), .B0(WrCnt90_4_), .B1(n576), .Y(n511) );
  AO22X1 U334 ( .A0(WrCnt[3]), .A1(n_168), .B0(WrCnt90_3_), .B1(n576), .Y(n512) );
  AO22X1 U335 ( .A0(WrCnt[2]), .A1(n_168), .B0(WrCnt90_2_), .B1(n576), .Y(n513) );
  AO22X1 U336 ( .A0(WrCnt[1]), .A1(n_168), .B0(WrCnt90_1_), .B1(n576), .Y(n514) );
  AO22X1 U337 ( .A0(IncRdCnt[5]), .A1(n550), .B0(IncRdCnt150_5_), .B1(ReadEn), 
        .Y(n518) );
  AO22X1 U338 ( .A0(IncRdCnt[4]), .A1(n550), .B0(IncRdCnt150_4_), .B1(ReadEn), 
        .Y(n519) );
  AO22X1 U339 ( .A0(IncRdCnt[3]), .A1(n550), .B0(IncRdCnt150_3_), .B1(ReadEn), 
        .Y(n520) );
  AO22X1 U340 ( .A0(IncRdCnt[2]), .A1(n550), .B0(IncRdCnt150_2_), .B1(ReadEn), 
        .Y(n521) );
  AO22X1 U341 ( .A0(IncRdCnt[1]), .A1(n550), .B0(IncRdCnt150_1_), .B1(ReadEn), 
        .Y(n522) );
  DFFRX1 DatCnt_reg_6_ ( .D(n525), .CK(Clk), .RN(nRST), .Q(HFullFlag), .QN(
        n569) );
  DFFRX1 DatCnt_reg_2_ ( .D(n529), .CK(Clk), .RN(nRST), .Q(DatCnt_2_), .QN(
        n572) );
  DFFRX1 DatCnt_reg_5_ ( .D(n526), .CK(Clk), .RN(nRST), .Q(DatCnt_5_), .QN(
        n571) );
  DFFRX1 DatCnt_reg_4_ ( .D(n527), .CK(Clk), .RN(nRST), .Q(DatCnt_4_), .QN(
        n567) );
  DFFRX1 DatCnt_reg_7_ ( .D(n524), .CK(Clk), .RN(nRST), .Q(DatCnt_7_), .QN(
        n566) );
  DFFRX1 DatCnt_reg_0_ ( .D(n531), .CK(Clk), .RN(nRST), .Q(DatCnt_0_), .QN(
        n568) );
  DFFRX1 DatCnt_reg_1_ ( .D(n530), .CK(Clk), .RN(nRST), .Q(DatCnt_1_), .QN(
        n570) );
  DFFRX1 DatCnt_reg_3_ ( .D(n528), .CK(Clk), .RN(nRST), .Q(DatCnt_3_) );
  DFFRX1 DelayReadEn_reg ( .D(ReadEn), .CK(Clk), .RN(nRST), .Q(n575) );
  DFFRX1 IncRdCnt_reg_0_ ( .D(n523), .CK(Clk), .RN(nRST), .Q(IncRdCnt[0]) );
  DFFRX1 IncRdCnt_reg_1_ ( .D(n522), .CK(Clk), .RN(nRST), .Q(IncRdCnt[1]) );
  DFFRX1 IncRdCnt_reg_3_ ( .D(n520), .CK(Clk), .RN(nRST), .Q(IncRdCnt[3]) );
  DFFRX1 IncRdCnt_reg_2_ ( .D(n521), .CK(Clk), .RN(nRST), .Q(IncRdCnt[2]) );
  DFFRX1 IncRdCnt_reg_7_ ( .D(n516), .CK(Clk), .RN(nRST), .Q(IncRdCnt[7]), 
        .QN(n573) );
  DFFRX1 IncRdCnt_reg_5_ ( .D(n518), .CK(Clk), .RN(nRST), .Q(IncRdCnt[5]) );
  DFFRX1 IncRdCnt_reg_6_ ( .D(n517), .CK(Clk), .RN(nRST), .Q(IncRdCnt[6]) );
  DFFRX1 IncRdCnt_reg_4_ ( .D(n519), .CK(Clk), .RN(nRST), .Q(IncRdCnt[4]) );
endmodule


module SDRWQ ( nRST, Clk, WriteEn, ReadEn, DelayReadEn, WrData, RdData, 
        FullFlag, HFullFlag, EmptyFlag, WrapCnt, IncRdCnt );
  input [35:0] WrData;
  output [35:0] RdData;
  input [5:0] WrapCnt;
  output [5:0] IncRdCnt;
  input nRST, Clk, WriteEn, ReadEn, DelayReadEn;
  output FullFlag, HFullFlag, EmptyFlag;
  wire   DatCnt_4_, DatCnt_3_, DatCnt_2_, DatCnt_1_, DatCnt_0_, n_123, n_124,
         WrCnt90_4_, WrCnt90_3_, WrCnt90_2_, WrCnt90_1_, IncRdCnt150_4_,
         IncRdCnt150_3_, IncRdCnt150_2_, IncRdCnt150_1_, DatCnt247_5_,
         DatCnt247_4_, DatCnt247_3_, DatCnt247_2_, DatCnt247_1_, DatCnt251_4_,
         DatCnt251_3_, DatCnt251_2_, DatCnt251_1_, n451, n452, n453, n454,
         n455, n456, n457, n458, n459, n460, n461, n462, n463, n464, n465,
         n466, n467, n468, carry, carry0, carry1, n12, n22, n32, n42, carry2,
         carry3, carry4, n11, n21, n31, n41, carry_5_, carry5, carry6, carry7,
         carry_4_, carry_3_, carry_2_, n1, n2, n3, n4, n469, n470, n471, n473,
         n474, n475, n476, n477, n478, n479, n480, n481, n482, n484, n485,
         n487, n488, n491, n495, n496, n497, n498, n499, n500, n501, n502,
         n503, n504, n505, n506, n507, n508, n509, n510, n511, n512, n513,
         n514, n515, n516, n517, n518, n519, n520, n521, n522, n523, n524,
         n525, n526, n527, n528, n529, n530, n531, n532, n533, n534, n535,
         n536, n537, n538, n539, n540, n541, n542, n543, n544, n545, n546,
         n547, n548, n549, n550, n551, n552, n553, n554, n555, n556, n557,
         n558, n559, n560, n561, n562, n563, n564, n565, n566;
  wire   [5:0] WrCnt;

  RF2SH64x32 WQL ( .CENB(n_124), .AB(WrCnt), .DB({n496, n527, n526, n525, n524, 
        n523, n522, n521, n520, n519, n518, n517, n516, n515, n514, n513, n511, 
        n510, n509, n508, n507, n506, n505, n504, n503, n502, n501, n500, n499, 
        n498, n497, n512}), .CENA(n_123), .AA(WrapCnt), .CLKB(Clk), .CLKA(Clk), 
        .QA(RdData[31:0]) );
  RF2SH64x4 WQH ( .CENB(n_124), .AB(WrCnt), .DB(WrData[35:32]), .CENA(n_123), 
        .AA(WrapCnt), .CLKB(Clk), .CLKA(Clk), .QA(RdData[35:32]) );
  DFFRX4 WrCnt_reg_0_ ( .D(n456), .CK(Clk), .RN(nRST), .Q(WrCnt[0]) );
  DFFRX4 WrCnt_reg_1_ ( .D(n455), .CK(Clk), .RN(nRST), .Q(WrCnt[1]) );
  DFFRX4 WrCnt_reg_2_ ( .D(n454), .CK(Clk), .RN(nRST), .Q(WrCnt[2]) );
  DFFRX4 WrCnt_reg_3_ ( .D(n453), .CK(Clk), .RN(nRST), .Q(WrCnt[3]) );
  DFFRX4 WrCnt_reg_4_ ( .D(n452), .CK(Clk), .RN(nRST), .Q(WrCnt[4]) );
  DFFRX4 WrCnt_reg_5_ ( .D(n451), .CK(Clk), .RN(nRST), .Q(WrCnt[5]), .QN(n566)
         );
  AHHCONX2 U1_1_12 ( .A(WrCnt[1]), .CI(WrCnt[0]), .S(WrCnt90_1_), .CON(n42) );
  AHHCONX2 U1_1_22 ( .A(WrCnt[2]), .CI(carry1), .S(WrCnt90_2_), .CON(n32) );
  AHHCONX2 U1_1_32 ( .A(WrCnt[3]), .CI(carry0), .S(WrCnt90_3_), .CON(n22) );
  AHHCONX2 U1_1_42 ( .A(WrCnt[4]), .CI(carry), .S(WrCnt90_4_), .CON(n12) );
  AHHCONX2 U1_1_11 ( .A(IncRdCnt[1]), .CI(IncRdCnt[0]), .S(IncRdCnt150_1_), 
        .CON(n41) );
  AHHCONX2 U1_1_21 ( .A(IncRdCnt[2]), .CI(carry4), .S(IncRdCnt150_2_), .CON(
        n31) );
  AHHCONX2 U1_1_31 ( .A(IncRdCnt[3]), .CI(carry3), .S(IncRdCnt150_3_), .CON(
        n21) );
  AHHCONX2 U1_1_41 ( .A(IncRdCnt[4]), .CI(carry2), .S(IncRdCnt150_4_), .CON(
        n11) );
  AHHCONX2 U1_1_1 ( .A(DatCnt_1_), .CI(DatCnt_0_), .S(DatCnt251_1_), .CON(n4)
         );
  AHHCONX2 U1_1_2 ( .A(DatCnt_2_), .CI(carry_2_), .S(DatCnt251_2_), .CON(n3)
         );
  AHHCONX2 U1_1_3 ( .A(DatCnt_3_), .CI(carry_3_), .S(DatCnt251_3_), .CON(n2)
         );
  AHHCONX2 U1_1_4 ( .A(DatCnt_4_), .CI(carry_4_), .S(DatCnt251_4_), .CON(n1)
         );
  NOR2BX4 U159 ( .AN(n469), .B(DelayReadEn), .Y(n_123) );
  OAI31X4 U194 ( .A0(n_124), .A1(n12), .A2(WrCnt[5]), .B0(n488), .Y(n451) );
  BUFX2 U217 ( .A(n528), .Y(n496) );
  BUFX2 U218 ( .A(n529), .Y(n497) );
  BUFX2 U219 ( .A(n530), .Y(n498) );
  BUFX2 U220 ( .A(n531), .Y(n499) );
  BUFX2 U221 ( .A(n532), .Y(n500) );
  BUFX2 U222 ( .A(n533), .Y(n501) );
  BUFX2 U223 ( .A(n534), .Y(n502) );
  BUFX2 U224 ( .A(n535), .Y(n503) );
  BUFX2 U225 ( .A(n536), .Y(n504) );
  BUFX2 U226 ( .A(n537), .Y(n505) );
  BUFX2 U227 ( .A(n538), .Y(n506) );
  BUFX2 U228 ( .A(n539), .Y(n507) );
  BUFX2 U229 ( .A(n540), .Y(n508) );
  BUFX2 U230 ( .A(n541), .Y(n509) );
  BUFX2 U231 ( .A(n542), .Y(n510) );
  BUFX2 U232 ( .A(n543), .Y(n511) );
  BUFX2 U233 ( .A(n544), .Y(n512) );
  BUFX2 U234 ( .A(n545), .Y(n513) );
  BUFX2 U235 ( .A(n546), .Y(n514) );
  BUFX2 U236 ( .A(n547), .Y(n515) );
  BUFX2 U237 ( .A(n548), .Y(n516) );
  BUFX2 U238 ( .A(n549), .Y(n517) );
  BUFX2 U239 ( .A(n550), .Y(n518) );
  BUFX2 U240 ( .A(n551), .Y(n519) );
  BUFX2 U241 ( .A(n552), .Y(n520) );
  BUFX2 U242 ( .A(n553), .Y(n521) );
  BUFX2 U243 ( .A(n554), .Y(n522) );
  BUFX2 U244 ( .A(n555), .Y(n523) );
  BUFX2 U245 ( .A(n556), .Y(n524) );
  BUFX2 U246 ( .A(n557), .Y(n525) );
  BUFX2 U247 ( .A(n558), .Y(n526) );
  BUFX2 U248 ( .A(n559), .Y(n527) );
  BUFX2 U249 ( .A(WrData[31]), .Y(n528) );
  BUFX2 U250 ( .A(WrData[1]), .Y(n529) );
  BUFX2 U251 ( .A(WrData[2]), .Y(n530) );
  BUFX2 U252 ( .A(WrData[3]), .Y(n531) );
  BUFX2 U253 ( .A(WrData[4]), .Y(n532) );
  BUFX2 U254 ( .A(WrData[5]), .Y(n533) );
  BUFX2 U255 ( .A(WrData[6]), .Y(n534) );
  BUFX2 U256 ( .A(WrData[7]), .Y(n535) );
  BUFX2 U257 ( .A(WrData[8]), .Y(n536) );
  BUFX2 U258 ( .A(WrData[9]), .Y(n537) );
  BUFX2 U259 ( .A(WrData[10]), .Y(n538) );
  BUFX2 U260 ( .A(WrData[11]), .Y(n539) );
  BUFX2 U261 ( .A(WrData[12]), .Y(n540) );
  BUFX2 U262 ( .A(WrData[13]), .Y(n541) );
  BUFX2 U263 ( .A(WrData[14]), .Y(n542) );
  BUFX2 U264 ( .A(WrData[15]), .Y(n543) );
  BUFX2 U265 ( .A(WrData[0]), .Y(n544) );
  BUFX2 U266 ( .A(WrData[16]), .Y(n545) );
  BUFX2 U267 ( .A(WrData[17]), .Y(n546) );
  BUFX2 U268 ( .A(WrData[18]), .Y(n547) );
  BUFX2 U269 ( .A(WrData[19]), .Y(n548) );
  BUFX2 U270 ( .A(WrData[20]), .Y(n549) );
  BUFX2 U271 ( .A(WrData[21]), .Y(n550) );
  BUFX2 U272 ( .A(WrData[22]), .Y(n551) );
  BUFX2 U273 ( .A(WrData[23]), .Y(n552) );
  BUFX2 U274 ( .A(WrData[24]), .Y(n553) );
  BUFX2 U275 ( .A(WrData[25]), .Y(n554) );
  BUFX2 U276 ( .A(WrData[26]), .Y(n555) );
  BUFX2 U277 ( .A(WrData[27]), .Y(n556) );
  BUFX2 U278 ( .A(WrData[28]), .Y(n557) );
  BUFX2 U279 ( .A(WrData[29]), .Y(n558) );
  BUFX2 U280 ( .A(WrData[30]), .Y(n559) );
  INVX1 U281 ( .A(n470), .Y(n476) );
  NAND2BX1 U282 ( .AN(n469), .B(n471), .Y(n470) );
  INVX1 U283 ( .A(n477), .Y(n471) );
  INVX1 U284 ( .A(n473), .Y(n474) );
  XOR2X1 U285 ( .A(n469), .B(WriteEn), .Y(n477) );
  NAND2BX1 U286 ( .AN(ReadEn), .B(n471), .Y(n473) );
  INVX4 U287 ( .A(WriteEn), .Y(n_124) );
  INVX1 U288 ( .A(ReadEn), .Y(n469) );
  INVX1 U289 ( .A(n1), .Y(n484) );
  OAI222X1 U290 ( .A0(DatCnt_0_), .A1(n470), .B0(n471), .B1(n563), .C0(
        DatCnt_0_), .C1(n473), .Y(n468) );
  NAND2BX1 U291 ( .AN(n481), .B(n482), .Y(n463) );
  AO22X1 U292 ( .A0(HFullFlag), .A1(n477), .B0(DatCnt247_5_), .B1(n476), .Y(
        n481) );
  AOI33X1 U293 ( .A0(n564), .A1(n484), .A2(n474), .B0(HFullFlag), .B1(n1), 
        .B2(n474), .Y(n482) );
  XNOR2X1 U1_A_5 ( .A(HFullFlag), .B(carry_5_), .Y(DatCnt247_5_) );
  AO21X1 U294 ( .A0(DatCnt251_4_), .A1(n474), .B0(n480), .Y(n464) );
  AO22X1 U295 ( .A0(DatCnt247_4_), .A1(n476), .B0(DatCnt_4_), .B1(n477), .Y(
        n480) );
  XNOR2X1 U1_A_4 ( .A(DatCnt_4_), .B(carry5), .Y(DatCnt247_4_) );
  AO21X1 U296 ( .A0(DatCnt251_3_), .A1(n474), .B0(n479), .Y(n465) );
  AO22X1 U297 ( .A0(DatCnt247_3_), .A1(n476), .B0(DatCnt_3_), .B1(n477), .Y(
        n479) );
  XNOR2X1 U1_A_3 ( .A(DatCnt_3_), .B(carry6), .Y(DatCnt247_3_) );
  AO21X1 U298 ( .A0(DatCnt251_2_), .A1(n474), .B0(n478), .Y(n466) );
  AO22X1 U299 ( .A0(DatCnt247_2_), .A1(n476), .B0(DatCnt_2_), .B1(n477), .Y(
        n478) );
  XNOR2X1 U1_A_2 ( .A(DatCnt_2_), .B(carry7), .Y(DatCnt247_2_) );
  AO21X1 U300 ( .A0(DatCnt251_1_), .A1(n474), .B0(n475), .Y(n467) );
  AO22X1 U301 ( .A0(DatCnt247_1_), .A1(n476), .B0(DatCnt_1_), .B1(n477), .Y(
        n475) );
  XNOR2X1 U1_A_1 ( .A(DatCnt_1_), .B(DatCnt_0_), .Y(DatCnt247_1_) );
  AOI2BB2X1 U302 ( .A0N(WriteEn), .A1N(n566), .B0(WrCnt[5]), .B1(n12), .Y(n488) );
  NOR4BX1 U303 ( .AN(HFullFlag), .B(n491), .C(n561), .D(n560), .Y(FullFlag) );
  NAND3BX1 U304 ( .AN(n562), .B(DatCnt_1_), .C(DatCnt_0_), .Y(n491) );
  NOR4BX1 U305 ( .AN(n563), .B(n495), .C(DatCnt_2_), .D(DatCnt_1_), .Y(
        EmptyFlag) );
  NAND3BX1 U306 ( .AN(DatCnt_3_), .B(n560), .C(n564), .Y(n495) );
  XOR2X1 U307 ( .A(WriteEn), .B(WrCnt[0]), .Y(n456) );
  AO22X1 U308 ( .A0(WrCnt[4]), .A1(n_124), .B0(WrCnt90_4_), .B1(WriteEn), .Y(
        n452) );
  AO22X1 U309 ( .A0(WrCnt[3]), .A1(n_124), .B0(WrCnt90_3_), .B1(WriteEn), .Y(
        n453) );
  AO22X1 U310 ( .A0(WrCnt[2]), .A1(n_124), .B0(WrCnt90_2_), .B1(WriteEn), .Y(
        n454) );
  AO22X1 U311 ( .A0(WrCnt[1]), .A1(n_124), .B0(WrCnt90_1_), .B1(WriteEn), .Y(
        n455) );
  XOR2X1 U312 ( .A(ReadEn), .B(IncRdCnt[0]), .Y(n462) );
  AO22X1 U313 ( .A0(IncRdCnt[4]), .A1(n469), .B0(IncRdCnt150_4_), .B1(ReadEn), 
        .Y(n458) );
  AO22X1 U314 ( .A0(IncRdCnt[3]), .A1(n469), .B0(IncRdCnt150_3_), .B1(ReadEn), 
        .Y(n459) );
  AO22X1 U315 ( .A0(IncRdCnt[2]), .A1(n469), .B0(IncRdCnt150_2_), .B1(ReadEn), 
        .Y(n460) );
  AO22X1 U316 ( .A0(IncRdCnt[1]), .A1(n469), .B0(IncRdCnt150_1_), .B1(ReadEn), 
        .Y(n461) );
  OAI31X1 U317 ( .A0(n469), .A1(n11), .A2(IncRdCnt[5]), .B0(n485), .Y(n457) );
  OA22X1 U318 ( .A0(ReadEn), .A1(n565), .B0(n565), .B1(n487), .Y(n485) );
  INVX1 U319 ( .A(n11), .Y(n487) );
  INVX1 U320 ( .A(n22), .Y(carry) );
  INVX1 U321 ( .A(n21), .Y(carry2) );
  INVX1 U322 ( .A(n2), .Y(carry_4_) );
  INVX1 U323 ( .A(n4), .Y(carry_2_) );
  INVX1 U324 ( .A(n42), .Y(carry1) );
  INVX1 U325 ( .A(n41), .Y(carry4) );
  INVX1 U326 ( .A(n32), .Y(carry0) );
  INVX1 U327 ( .A(n31), .Y(carry3) );
  INVX1 U328 ( .A(n3), .Y(carry_3_) );
  OR2X1 U1_B_1 ( .A(DatCnt_1_), .B(DatCnt_0_), .Y(carry7) );
  OR2X1 U1_B_2 ( .A(DatCnt_2_), .B(carry7), .Y(carry6) );
  OR2X1 U1_B_3 ( .A(DatCnt_3_), .B(carry6), .Y(carry5) );
  OR2X1 U1_B_4 ( .A(DatCnt_4_), .B(carry5), .Y(carry_5_) );
  DFFRX1 DatCnt_reg_0_ ( .D(n468), .CK(Clk), .RN(nRST), .Q(DatCnt_0_), .QN(
        n563) );
  DFFRX1 DatCnt_reg_2_ ( .D(n466), .CK(Clk), .RN(nRST), .Q(DatCnt_2_), .QN(
        n562) );
  DFFRX1 DatCnt_reg_3_ ( .D(n465), .CK(Clk), .RN(nRST), .Q(DatCnt_3_), .QN(
        n561) );
  DFFRX1 DatCnt_reg_4_ ( .D(n464), .CK(Clk), .RN(nRST), .Q(DatCnt_4_), .QN(
        n560) );
  DFFRX1 DatCnt_reg_1_ ( .D(n467), .CK(Clk), .RN(nRST), .Q(DatCnt_1_) );
  DFFRX1 DatCnt_reg_5_ ( .D(n463), .CK(Clk), .RN(nRST), .Q(HFullFlag), .QN(
        n564) );
  DFFRX1 IncRdCnt_reg_0_ ( .D(n462), .CK(Clk), .RN(nRST), .Q(IncRdCnt[0]) );
  DFFRX1 IncRdCnt_reg_3_ ( .D(n459), .CK(Clk), .RN(nRST), .Q(IncRdCnt[3]) );
  DFFRX1 IncRdCnt_reg_2_ ( .D(n460), .CK(Clk), .RN(nRST), .Q(IncRdCnt[2]) );
  DFFRX1 IncRdCnt_reg_1_ ( .D(n461), .CK(Clk), .RN(nRST), .Q(IncRdCnt[1]) );
  DFFRX1 IncRdCnt_reg_5_ ( .D(n457), .CK(Clk), .RN(nRST), .Q(IncRdCnt[5]), 
        .QN(n565) );
  DFFRX1 IncRdCnt_reg_4_ ( .D(n458), .CK(Clk), .RN(nRST), .Q(IncRdCnt[4]) );
endmodule


module SDRRDS ( ACLK, ARESETn, INFORMATION_S, VALID_S, READY_S, INFORMATION_R, 
        VALID_R, READY_R );
  input [38:0] INFORMATION_S;
  output [38:0] INFORMATION_R;
  input ACLK, ARESETn, VALID_S, READY_R;
  output READY_S, VALID_R;
  wire   que_len, n557, n558, n559, n560, n561, n562, n563, n564, n565, n566,
         n567, n568, n569, n570, n571, n572, n573, n574, n575, n576, n577,
         n578, n579, n580, n581, n582, n583, n584, n585, n586, n587, n588,
         n589, n590, n591, n592, n593, n594, n595, n596, n597, n598, n599,
         n600, n601, n602, n603, n604, n605, n606, n607, n608, n609, n610,
         n611, n612, n613, n614, n615, n616, n617, n618, n619, n620, n621,
         n622, n623, n624, n625, n626, n627, n628, n629, n630, n631, n632,
         n633, n634, n635, n636, n637, n638, n639, n640, n641, n642, n643,
         n644, n645, n646, n647, n648, n649, n650, n651, n652, n653, n654,
         n655, n656, n657, n658, n659, n660, n661, n662, n663, n664, n665,
         n666, n667, n668, n669, n670, n671, n672, n673, n674, n675, n685,
         n687, n688, n690, n691, n692, n693, n695, n697, n699, n701, n703,
         n705, n707, n709, n711, n713, n715, n717, n719, n721, n723, n725,
         n727, n729, n731, n733, n735, n737, n739, n741, n743, n745, n747,
         n749, n751, n753, n755, n757, n759, n761, n763, n765, n767, n769,
         n770, n771, n772, n773, n774, n775, n776, n777, n778, n779, n780,
         n781, n782, n783, n784, n785, n786, n787, n788, n789, n790, n791,
         n792, n793, n794, n795, n796, n797, n798, n799, n800, n801, n802,
         n803, n804, n805, n806, n807, n808, n809, n810, n811, n812, n813,
         n814, n815, n816, n817, n818, n819;
  wire   [38:0] INFORMATION_1;

  INVX1 U576 ( .A(n818), .Y(n688) );
  NAND2BX1 U577 ( .AN(n771), .B(n693), .Y(n690) );
  NAND2BX1 U578 ( .AN(n771), .B(n812), .Y(n815) );
  NAND2BX1 U579 ( .AN(n771), .B(n813), .Y(n814) );
  NAND2BX1 U580 ( .AN(n685), .B(READY_S), .Y(n818) );
  INVX1 U581 ( .A(VALID_S), .Y(n685) );
  NAND2BX1 U582 ( .AN(n685), .B(READY_S), .Y(n687) );
  NAND2BX1 U583 ( .AN(n685), .B(READY_S), .Y(n819) );
  AO21X1 U584 ( .A0(n770), .A1(n771), .B0(READY_R), .Y(n693) );
  AO21X1 U585 ( .A0(n770), .A1(n771), .B0(READY_R), .Y(n813) );
  AO21X1 U586 ( .A0(n770), .A1(n771), .B0(READY_R), .Y(n812) );
  NAND2BX1 U587 ( .AN(que_len), .B(n813), .Y(n692) );
  NAND2BX1 U588 ( .AN(que_len), .B(n693), .Y(n817) );
  NAND2BX1 U589 ( .AN(que_len), .B(n812), .Y(n816) );
  OAI222X1 U590 ( .A0(n772), .A1(n814), .B0(n765), .B1(n816), .C0(n812), .C1(
        n586), .Y(n598) );
  INVX1 U591 ( .A(INFORMATION_S[36]), .Y(n765) );
  OAI222X1 U592 ( .A0(n773), .A1(n690), .B0(n769), .B1(n692), .C0(n693), .C1(
        n588), .Y(n596) );
  INVX1 U593 ( .A(INFORMATION_S[38]), .Y(n769) );
  OAI222X1 U594 ( .A0(n774), .A1(n815), .B0(n767), .B1(n817), .C0(n813), .C1(
        n587), .Y(n597) );
  INVX1 U595 ( .A(INFORMATION_S[37]), .Y(n767) );
  OAI222X1 U596 ( .A0(n775), .A1(n690), .B0(n763), .B1(n692), .C0(n693), .C1(
        n585), .Y(n599) );
  INVX1 U597 ( .A(INFORMATION_S[35]), .Y(n763) );
  OAI222X1 U598 ( .A0(n776), .A1(n815), .B0(n761), .B1(n817), .C0(n813), .C1(
        n584), .Y(n600) );
  INVX1 U599 ( .A(INFORMATION_S[34]), .Y(n761) );
  OAI222X1 U600 ( .A0(n777), .A1(n814), .B0(n759), .B1(n816), .C0(n812), .C1(
        n583), .Y(n601) );
  INVX1 U601 ( .A(INFORMATION_S[33]), .Y(n759) );
  OAI222X1 U602 ( .A0(n778), .A1(n690), .B0(n757), .B1(n692), .C0(n693), .C1(
        n582), .Y(n602) );
  INVX1 U603 ( .A(INFORMATION_S[32]), .Y(n757) );
  OAI222X1 U604 ( .A0(n779), .A1(n815), .B0(n755), .B1(n817), .C0(n813), .C1(
        n581), .Y(n603) );
  INVX1 U605 ( .A(INFORMATION_S[31]), .Y(n755) );
  OAI222X1 U606 ( .A0(n780), .A1(n814), .B0(n753), .B1(n816), .C0(n812), .C1(
        n580), .Y(n604) );
  INVX1 U607 ( .A(INFORMATION_S[30]), .Y(n753) );
  OAI222X1 U608 ( .A0(n781), .A1(n690), .B0(n751), .B1(n692), .C0(n693), .C1(
        n578), .Y(n605) );
  INVX1 U609 ( .A(INFORMATION_S[29]), .Y(n751) );
  OAI222X1 U610 ( .A0(n782), .A1(n815), .B0(n749), .B1(n817), .C0(n813), .C1(
        n577), .Y(n606) );
  INVX1 U611 ( .A(INFORMATION_S[28]), .Y(n749) );
  OAI222X1 U612 ( .A0(n783), .A1(n814), .B0(n747), .B1(n816), .C0(n812), .C1(
        n576), .Y(n607) );
  INVX1 U613 ( .A(INFORMATION_S[27]), .Y(n747) );
  OAI222X1 U614 ( .A0(n784), .A1(n690), .B0(n745), .B1(n692), .C0(n693), .C1(
        n575), .Y(n608) );
  INVX1 U615 ( .A(INFORMATION_S[26]), .Y(n745) );
  OAI222X1 U616 ( .A0(n785), .A1(n815), .B0(n743), .B1(n817), .C0(n813), .C1(
        n574), .Y(n609) );
  INVX1 U617 ( .A(INFORMATION_S[25]), .Y(n743) );
  OAI222X1 U618 ( .A0(n786), .A1(n814), .B0(n741), .B1(n816), .C0(n812), .C1(
        n573), .Y(n610) );
  INVX1 U619 ( .A(INFORMATION_S[24]), .Y(n741) );
  OAI222X1 U620 ( .A0(n787), .A1(n690), .B0(n739), .B1(n692), .C0(n693), .C1(
        n572), .Y(n611) );
  INVX1 U621 ( .A(INFORMATION_S[23]), .Y(n739) );
  OAI222X1 U622 ( .A0(n788), .A1(n815), .B0(n737), .B1(n817), .C0(n813), .C1(
        n571), .Y(n612) );
  INVX1 U623 ( .A(INFORMATION_S[22]), .Y(n737) );
  OAI222X1 U624 ( .A0(n789), .A1(n814), .B0(n735), .B1(n816), .C0(n812), .C1(
        n570), .Y(n613) );
  INVX1 U625 ( .A(INFORMATION_S[21]), .Y(n735) );
  OAI222X1 U626 ( .A0(n790), .A1(n690), .B0(n733), .B1(n692), .C0(n693), .C1(
        n569), .Y(n614) );
  INVX1 U627 ( .A(INFORMATION_S[20]), .Y(n733) );
  OAI222X1 U628 ( .A0(n791), .A1(n815), .B0(n731), .B1(n817), .C0(n813), .C1(
        n567), .Y(n615) );
  INVX1 U629 ( .A(INFORMATION_S[19]), .Y(n731) );
  OAI222X1 U630 ( .A0(n792), .A1(n814), .B0(n729), .B1(n816), .C0(n812), .C1(
        n566), .Y(n616) );
  INVX1 U631 ( .A(INFORMATION_S[18]), .Y(n729) );
  OAI222X1 U632 ( .A0(n793), .A1(n690), .B0(n727), .B1(n692), .C0(n693), .C1(
        n565), .Y(n617) );
  INVX1 U633 ( .A(INFORMATION_S[17]), .Y(n727) );
  OAI222X1 U634 ( .A0(n794), .A1(n815), .B0(n725), .B1(n817), .C0(n813), .C1(
        n564), .Y(n618) );
  INVX1 U635 ( .A(INFORMATION_S[16]), .Y(n725) );
  OAI222X1 U636 ( .A0(n795), .A1(n814), .B0(n723), .B1(n816), .C0(n812), .C1(
        n563), .Y(n619) );
  INVX1 U637 ( .A(INFORMATION_S[15]), .Y(n723) );
  OAI222X1 U638 ( .A0(n796), .A1(n690), .B0(n721), .B1(n692), .C0(n693), .C1(
        n562), .Y(n620) );
  INVX1 U639 ( .A(INFORMATION_S[14]), .Y(n721) );
  OAI222X1 U640 ( .A0(n797), .A1(n815), .B0(n719), .B1(n817), .C0(n813), .C1(
        n561), .Y(n621) );
  INVX1 U641 ( .A(INFORMATION_S[13]), .Y(n719) );
  OAI222X1 U642 ( .A0(n798), .A1(n814), .B0(n717), .B1(n816), .C0(n812), .C1(
        n560), .Y(n622) );
  INVX1 U643 ( .A(INFORMATION_S[12]), .Y(n717) );
  OAI222X1 U644 ( .A0(n799), .A1(n690), .B0(n715), .B1(n692), .C0(n693), .C1(
        n559), .Y(n623) );
  INVX1 U645 ( .A(INFORMATION_S[11]), .Y(n715) );
  OAI222X1 U646 ( .A0(n800), .A1(n815), .B0(n713), .B1(n817), .C0(n813), .C1(
        n558), .Y(n624) );
  INVX1 U647 ( .A(INFORMATION_S[10]), .Y(n713) );
  OAI222X1 U648 ( .A0(n801), .A1(n814), .B0(n711), .B1(n816), .C0(n812), .C1(
        n595), .Y(n625) );
  INVX1 U649 ( .A(INFORMATION_S[9]), .Y(n711) );
  OAI222X1 U650 ( .A0(n802), .A1(n690), .B0(n709), .B1(n692), .C0(n693), .C1(
        n594), .Y(n626) );
  INVX1 U651 ( .A(INFORMATION_S[8]), .Y(n709) );
  OAI222X1 U652 ( .A0(n803), .A1(n815), .B0(n707), .B1(n817), .C0(n813), .C1(
        n593), .Y(n627) );
  INVX1 U653 ( .A(INFORMATION_S[7]), .Y(n707) );
  OAI222X1 U654 ( .A0(n804), .A1(n814), .B0(n705), .B1(n816), .C0(n812), .C1(
        n592), .Y(n628) );
  INVX1 U655 ( .A(INFORMATION_S[6]), .Y(n705) );
  OAI222X1 U656 ( .A0(n805), .A1(n690), .B0(n703), .B1(n692), .C0(n693), .C1(
        n591), .Y(n629) );
  INVX1 U657 ( .A(INFORMATION_S[5]), .Y(n703) );
  OAI222X1 U658 ( .A0(n806), .A1(n815), .B0(n701), .B1(n817), .C0(n813), .C1(
        n590), .Y(n630) );
  INVX1 U659 ( .A(INFORMATION_S[4]), .Y(n701) );
  OAI222X1 U660 ( .A0(n807), .A1(n814), .B0(n699), .B1(n816), .C0(n812), .C1(
        n589), .Y(n631) );
  INVX1 U661 ( .A(INFORMATION_S[3]), .Y(n699) );
  OAI222X1 U662 ( .A0(n808), .A1(n690), .B0(n697), .B1(n692), .C0(n693), .C1(
        n579), .Y(n632) );
  INVX1 U663 ( .A(INFORMATION_S[2]), .Y(n697) );
  OAI222X1 U664 ( .A0(n809), .A1(n815), .B0(n695), .B1(n817), .C0(n813), .C1(
        n568), .Y(n633) );
  INVX1 U665 ( .A(INFORMATION_S[1]), .Y(n695) );
  OAI222X1 U666 ( .A0(n810), .A1(n814), .B0(n691), .B1(n816), .C0(n812), .C1(
        n557), .Y(n634) );
  INVX1 U667 ( .A(INFORMATION_S[0]), .Y(n691) );
  AO22X1 U668 ( .A0(INFORMATION_1[35]), .A1(n687), .B0(INFORMATION_S[35]), 
        .B1(n688), .Y(n638) );
  AO22X1 U669 ( .A0(INFORMATION_1[34]), .A1(n819), .B0(INFORMATION_S[34]), 
        .B1(n688), .Y(n639) );
  AO22X1 U670 ( .A0(INFORMATION_1[33]), .A1(n818), .B0(INFORMATION_S[33]), 
        .B1(n688), .Y(n640) );
  AO22X1 U671 ( .A0(INFORMATION_1[32]), .A1(n687), .B0(INFORMATION_S[32]), 
        .B1(n688), .Y(n641) );
  AO22X1 U672 ( .A0(INFORMATION_1[31]), .A1(n819), .B0(INFORMATION_S[31]), 
        .B1(n688), .Y(n642) );
  AO22X1 U673 ( .A0(INFORMATION_1[30]), .A1(n818), .B0(INFORMATION_S[30]), 
        .B1(n688), .Y(n643) );
  AO22X1 U674 ( .A0(INFORMATION_1[29]), .A1(n687), .B0(INFORMATION_S[29]), 
        .B1(n688), .Y(n644) );
  AO22X1 U675 ( .A0(INFORMATION_1[28]), .A1(n819), .B0(INFORMATION_S[28]), 
        .B1(n688), .Y(n645) );
  AO22X1 U676 ( .A0(INFORMATION_1[27]), .A1(n818), .B0(INFORMATION_S[27]), 
        .B1(n688), .Y(n646) );
  AO22X1 U677 ( .A0(INFORMATION_1[26]), .A1(n687), .B0(INFORMATION_S[26]), 
        .B1(n688), .Y(n647) );
  AO22X1 U678 ( .A0(INFORMATION_1[25]), .A1(n819), .B0(INFORMATION_S[25]), 
        .B1(n688), .Y(n648) );
  AO22X1 U679 ( .A0(INFORMATION_1[24]), .A1(n818), .B0(INFORMATION_S[24]), 
        .B1(n688), .Y(n649) );
  AO22X1 U680 ( .A0(INFORMATION_1[23]), .A1(n687), .B0(INFORMATION_S[23]), 
        .B1(n688), .Y(n650) );
  AO22X1 U681 ( .A0(INFORMATION_1[22]), .A1(n819), .B0(INFORMATION_S[22]), 
        .B1(n688), .Y(n651) );
  AO22X1 U682 ( .A0(INFORMATION_1[21]), .A1(n818), .B0(INFORMATION_S[21]), 
        .B1(n688), .Y(n652) );
  AO22X1 U683 ( .A0(INFORMATION_1[20]), .A1(n687), .B0(INFORMATION_S[20]), 
        .B1(n688), .Y(n653) );
  AO22X1 U684 ( .A0(INFORMATION_1[19]), .A1(n819), .B0(INFORMATION_S[19]), 
        .B1(n688), .Y(n654) );
  AO22X1 U685 ( .A0(INFORMATION_1[18]), .A1(n818), .B0(INFORMATION_S[18]), 
        .B1(n688), .Y(n655) );
  AO22X1 U686 ( .A0(INFORMATION_1[17]), .A1(n687), .B0(INFORMATION_S[17]), 
        .B1(n688), .Y(n656) );
  AO22X1 U687 ( .A0(INFORMATION_1[16]), .A1(n819), .B0(INFORMATION_S[16]), 
        .B1(n688), .Y(n657) );
  AO22X1 U688 ( .A0(INFORMATION_1[15]), .A1(n687), .B0(INFORMATION_S[15]), 
        .B1(n688), .Y(n658) );
  AO22X1 U689 ( .A0(INFORMATION_1[14]), .A1(n687), .B0(INFORMATION_S[14]), 
        .B1(n688), .Y(n659) );
  AO22X1 U690 ( .A0(INFORMATION_1[13]), .A1(n819), .B0(INFORMATION_S[13]), 
        .B1(n688), .Y(n660) );
  AO22X1 U691 ( .A0(INFORMATION_1[12]), .A1(n819), .B0(INFORMATION_S[12]), 
        .B1(n688), .Y(n661) );
  AO22X1 U692 ( .A0(INFORMATION_1[11]), .A1(n687), .B0(INFORMATION_S[11]), 
        .B1(n688), .Y(n662) );
  AO22X1 U693 ( .A0(INFORMATION_1[10]), .A1(n819), .B0(INFORMATION_S[10]), 
        .B1(n688), .Y(n663) );
  AO22X1 U694 ( .A0(INFORMATION_1[9]), .A1(n687), .B0(INFORMATION_S[9]), .B1(
        n688), .Y(n664) );
  AO22X1 U695 ( .A0(INFORMATION_1[8]), .A1(n687), .B0(INFORMATION_S[8]), .B1(
        n688), .Y(n665) );
  AO22X1 U696 ( .A0(INFORMATION_1[7]), .A1(n819), .B0(INFORMATION_S[7]), .B1(
        n688), .Y(n666) );
  AO22X1 U697 ( .A0(INFORMATION_1[6]), .A1(n819), .B0(INFORMATION_S[6]), .B1(
        n688), .Y(n667) );
  AO22X1 U698 ( .A0(INFORMATION_1[5]), .A1(n687), .B0(INFORMATION_S[5]), .B1(
        n688), .Y(n668) );
  AO22X1 U699 ( .A0(INFORMATION_1[4]), .A1(n819), .B0(INFORMATION_S[4]), .B1(
        n688), .Y(n669) );
  OAI32X1 U700 ( .A0(n770), .A1(READY_R), .A2(n685), .B0(READY_R), .B1(n771), 
        .Y(n675) );
  AO22X1 U701 ( .A0(INFORMATION_1[3]), .A1(n687), .B0(INFORMATION_S[3]), .B1(
        n688), .Y(n670) );
  AO22X1 U702 ( .A0(INFORMATION_1[2]), .A1(n687), .B0(INFORMATION_S[2]), .B1(
        n688), .Y(n671) );
  AO22X1 U703 ( .A0(INFORMATION_1[1]), .A1(n819), .B0(INFORMATION_S[1]), .B1(
        n688), .Y(n672) );
  AO22X1 U704 ( .A0(INFORMATION_1[0]), .A1(n819), .B0(INFORMATION_S[0]), .B1(
        n688), .Y(n673) );
  OAI221X1 U705 ( .A0(READY_R), .A1(n770), .B0(n770), .B1(n771), .C0(n685), 
        .Y(n674) );
  NAND2X1 U706 ( .A(n811), .B(que_len), .Y(READY_S) );
  AO22X1 U707 ( .A0(INFORMATION_1[36]), .A1(n818), .B0(INFORMATION_S[36]), 
        .B1(n688), .Y(n637) );
  AO22X1 U708 ( .A0(INFORMATION_1[38]), .A1(n687), .B0(INFORMATION_S[38]), 
        .B1(n688), .Y(n635) );
  AO22X1 U709 ( .A0(INFORMATION_1[37]), .A1(n819), .B0(INFORMATION_S[37]), 
        .B1(n688), .Y(n636) );
  DFFRX1 que_len_reg ( .D(n675), .CK(ACLK), .RN(ARESETn), .Q(que_len), .QN(
        n771) );
  DFFRX1 VALID_R_reg ( .D(n674), .CK(ACLK), .RN(ARESETn), .Q(VALID_R), .QN(
        n770) );
  DFFRX1 INFORMATION_0_reg_38_ ( .D(n596), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[38]), .QN(n588) );
  DFFRX1 INFORMATION_0_reg_37_ ( .D(n597), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[37]), .QN(n587) );
  DFFRX1 INFORMATION_0_reg_36_ ( .D(n598), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[36]), .QN(n586) );
  DFFRX1 INFORMATION_0_reg_35_ ( .D(n599), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[35]), .QN(n585) );
  DFFRX1 INFORMATION_0_reg_34_ ( .D(n600), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[34]), .QN(n584) );
  DFFRX1 INFORMATION_0_reg_33_ ( .D(n601), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[33]), .QN(n583) );
  DFFRX1 INFORMATION_0_reg_32_ ( .D(n602), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[32]), .QN(n582) );
  DFFRX1 INFORMATION_0_reg_31_ ( .D(n603), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[31]), .QN(n581) );
  DFFRX1 INFORMATION_0_reg_30_ ( .D(n604), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[30]), .QN(n580) );
  DFFRX1 INFORMATION_0_reg_29_ ( .D(n605), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[29]), .QN(n578) );
  DFFRX1 INFORMATION_0_reg_28_ ( .D(n606), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[28]), .QN(n577) );
  DFFRX1 INFORMATION_0_reg_27_ ( .D(n607), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[27]), .QN(n576) );
  DFFRX1 INFORMATION_0_reg_26_ ( .D(n608), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[26]), .QN(n575) );
  DFFRX1 INFORMATION_0_reg_25_ ( .D(n609), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[25]), .QN(n574) );
  DFFRX1 INFORMATION_0_reg_24_ ( .D(n610), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[24]), .QN(n573) );
  DFFRX1 INFORMATION_0_reg_23_ ( .D(n611), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[23]), .QN(n572) );
  DFFRX1 INFORMATION_0_reg_22_ ( .D(n612), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[22]), .QN(n571) );
  DFFRX1 INFORMATION_0_reg_21_ ( .D(n613), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[21]), .QN(n570) );
  DFFRX1 INFORMATION_0_reg_20_ ( .D(n614), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[20]), .QN(n569) );
  DFFRX1 INFORMATION_0_reg_19_ ( .D(n615), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[19]), .QN(n567) );
  DFFRX1 INFORMATION_0_reg_18_ ( .D(n616), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[18]), .QN(n566) );
  DFFRX1 INFORMATION_0_reg_17_ ( .D(n617), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[17]), .QN(n565) );
  DFFRX1 INFORMATION_0_reg_16_ ( .D(n618), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[16]), .QN(n564) );
  DFFRX1 INFORMATION_0_reg_15_ ( .D(n619), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[15]), .QN(n563) );
  DFFRX1 INFORMATION_0_reg_14_ ( .D(n620), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[14]), .QN(n562) );
  DFFRX1 INFORMATION_0_reg_13_ ( .D(n621), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[13]), .QN(n561) );
  DFFRX1 INFORMATION_0_reg_12_ ( .D(n622), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[12]), .QN(n560) );
  DFFRX1 INFORMATION_0_reg_11_ ( .D(n623), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[11]), .QN(n559) );
  DFFRX1 INFORMATION_0_reg_10_ ( .D(n624), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[10]), .QN(n558) );
  DFFRX1 INFORMATION_0_reg_9_ ( .D(n625), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[9]), .QN(n595) );
  DFFRX1 INFORMATION_0_reg_8_ ( .D(n626), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[8]), .QN(n594) );
  DFFRX1 INFORMATION_0_reg_7_ ( .D(n627), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[7]), .QN(n593) );
  DFFRX1 INFORMATION_0_reg_6_ ( .D(n628), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[6]), .QN(n592) );
  DFFRX1 INFORMATION_0_reg_5_ ( .D(n629), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[5]), .QN(n591) );
  DFFRX1 INFORMATION_0_reg_4_ ( .D(n630), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[4]), .QN(n590) );
  DFFRX1 INFORMATION_0_reg_3_ ( .D(n631), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[3]), .QN(n589) );
  DFFRX1 INFORMATION_0_reg_2_ ( .D(n632), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[2]), .QN(n579) );
  DFFRX1 INFORMATION_0_reg_1_ ( .D(n633), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[1]), .QN(n568) );
  DFFRX1 INFORMATION_0_reg_0_ ( .D(n634), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_R[0]), .QN(n557) );
  DFFSX1 ready_r_ff_reg ( .D(READY_R), .CK(ACLK), .SN(ARESETn), .QN(n811) );
  DFFRX1 INFORMATION_1_reg_38_ ( .D(n635), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[38]), .QN(n773) );
  DFFRX1 INFORMATION_1_reg_37_ ( .D(n636), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[37]), .QN(n774) );
  DFFRX1 INFORMATION_1_reg_36_ ( .D(n637), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[36]), .QN(n772) );
  DFFRX1 INFORMATION_1_reg_35_ ( .D(n638), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[35]), .QN(n775) );
  DFFRX1 INFORMATION_1_reg_34_ ( .D(n639), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[34]), .QN(n776) );
  DFFRX1 INFORMATION_1_reg_33_ ( .D(n640), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[33]), .QN(n777) );
  DFFRX1 INFORMATION_1_reg_32_ ( .D(n641), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[32]), .QN(n778) );
  DFFRX1 INFORMATION_1_reg_31_ ( .D(n642), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[31]), .QN(n779) );
  DFFRX1 INFORMATION_1_reg_30_ ( .D(n643), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[30]), .QN(n780) );
  DFFRX1 INFORMATION_1_reg_29_ ( .D(n644), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[29]), .QN(n781) );
  DFFRX1 INFORMATION_1_reg_28_ ( .D(n645), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[28]), .QN(n782) );
  DFFRX1 INFORMATION_1_reg_27_ ( .D(n646), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[27]), .QN(n783) );
  DFFRX1 INFORMATION_1_reg_26_ ( .D(n647), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[26]), .QN(n784) );
  DFFRX1 INFORMATION_1_reg_25_ ( .D(n648), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[25]), .QN(n785) );
  DFFRX1 INFORMATION_1_reg_24_ ( .D(n649), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[24]), .QN(n786) );
  DFFRX1 INFORMATION_1_reg_23_ ( .D(n650), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[23]), .QN(n787) );
  DFFRX1 INFORMATION_1_reg_22_ ( .D(n651), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[22]), .QN(n788) );
  DFFRX1 INFORMATION_1_reg_21_ ( .D(n652), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[21]), .QN(n789) );
  DFFRX1 INFORMATION_1_reg_20_ ( .D(n653), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[20]), .QN(n790) );
  DFFRX1 INFORMATION_1_reg_19_ ( .D(n654), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[19]), .QN(n791) );
  DFFRX1 INFORMATION_1_reg_18_ ( .D(n655), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[18]), .QN(n792) );
  DFFRX1 INFORMATION_1_reg_17_ ( .D(n656), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[17]), .QN(n793) );
  DFFRX1 INFORMATION_1_reg_16_ ( .D(n657), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[16]), .QN(n794) );
  DFFRX1 INFORMATION_1_reg_15_ ( .D(n658), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[15]), .QN(n795) );
  DFFRX1 INFORMATION_1_reg_14_ ( .D(n659), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[14]), .QN(n796) );
  DFFRX1 INFORMATION_1_reg_13_ ( .D(n660), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[13]), .QN(n797) );
  DFFRX1 INFORMATION_1_reg_12_ ( .D(n661), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[12]), .QN(n798) );
  DFFRX1 INFORMATION_1_reg_11_ ( .D(n662), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[11]), .QN(n799) );
  DFFRX1 INFORMATION_1_reg_10_ ( .D(n663), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[10]), .QN(n800) );
  DFFRX1 INFORMATION_1_reg_9_ ( .D(n664), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[9]), .QN(n801) );
  DFFRX1 INFORMATION_1_reg_8_ ( .D(n665), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[8]), .QN(n802) );
  DFFRX1 INFORMATION_1_reg_7_ ( .D(n666), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[7]), .QN(n803) );
  DFFRX1 INFORMATION_1_reg_6_ ( .D(n667), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[6]), .QN(n804) );
  DFFRX1 INFORMATION_1_reg_5_ ( .D(n668), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[5]), .QN(n805) );
  DFFRX1 INFORMATION_1_reg_4_ ( .D(n669), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[4]), .QN(n806) );
  DFFRX1 INFORMATION_1_reg_3_ ( .D(n670), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[3]), .QN(n807) );
  DFFRX1 INFORMATION_1_reg_2_ ( .D(n671), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[2]), .QN(n808) );
  DFFRX1 INFORMATION_1_reg_1_ ( .D(n672), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[1]), .QN(n809) );
  DFFRX1 INFORMATION_1_reg_0_ ( .D(n673), .CK(ACLK), .RN(ARESETn), .Q(
        INFORMATION_1[0]), .QN(n810) );
endmodule

