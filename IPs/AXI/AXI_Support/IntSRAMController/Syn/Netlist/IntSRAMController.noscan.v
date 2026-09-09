
module IntSRAMController ( ACLK, ARESETn, AWID, AWADDR, AWLEN, AWSIZE, AWBURST, 
        AWVALID, AWREADY, WID, WDATA, WSTRB, WLAST, WVALID, WREADY, BID, BRESP, 
        BVALID, BREADY, ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID, ARREADY, 
        RID, RDATA, RRESP, RLAST, RVALID, RREADY, MEMADDR, MEMCEn, MEMWEn, 
        MEMRDATA, MEMWDATA );
  input [3:0] AWID;
  input [31:0] AWADDR;
  input [3:0] AWLEN;
  input [2:0] AWSIZE;
  input [1:0] AWBURST;
  input [3:0] WID;
  input [31:0] WDATA;
  input [3:0] WSTRB;
  output [3:0] BID;
  output [1:0] BRESP;
  input [3:0] ARID;
  input [31:0] ARADDR;
  input [3:0] ARLEN;
  input [2:0] ARSIZE;
  input [1:0] ARBURST;
  output [3:0] RID;
  output [31:0] RDATA;
  output [1:0] RRESP;
  output [29:0] MEMADDR;
  output [3:0] MEMWEn;
  input [31:0] MEMRDATA;
  output [31:0] MEMWDATA;
  input ACLK, ARESETn, AWVALID, WLAST, WVALID, BREADY, ARVALID, RREADY;
  output AWREADY, WREADY, BVALID, ARREADY, RLAST, RVALID, MEMCEn;
  wire   StateIsREAD, ReadOrWrite, n_394, \RID0[3] , \RID0[2] , \RID0[1] ,
         \RID0[0] , FirstREADCycle, n_1759, BurstLen_3_, BurstLen_2_,
         BurstLen_1_, FirstREADCycle248, Id497_3_, Id497_2_, Id497_1_,
         Id497_0_, n501_0_, Len_3_, Len_2_, Len_1_, Len_0_, Len750_3_,
         Len750_2_, Len750_1_, Len750_0_, n1075, n1076, n1077, n1078, n1079,
         n1080, n1081, n1082, n1083, n1084, n1085, n1086, n1087, n1088, n1089,
         n1090, n1091, n1092, n1093, n1094, n1095, n1096, n1097, n1098, n1099,
         n1100, n1101, n1102, n1103, n1104, n1105, n1106, n1107, n1108, n1109,
         n1111, n1112, n1113, n1114, n1115, n1116, n1117, n1118, n1119, n1120,
         n1121, n1122, n1123, n1124, n1125, n1126, n1127, n1128, n1129, n1130,
         n1131, n1132, n1133, n1134, n1135, n1136, n1137, n1138, n1139, n1140,
         n1141, n1142, n1143, n1144, n1145, n1146, n1147, n1148, n1149, n1150,
         n1151, n1152, n1153, n1154, n1155, n1156, n1157, n1158, n1159, n1160,
         n1161, n1162, n1163, n1164, n1165, n1166, n1167, n1168, n1169, n1170,
         n1171, n1172, n1173, n1174, n1175, n1176, n1177, n1178, n1179, n1180,
         n1181, n1182, n1183, n1184, n1185, n1186, n1187, n1188, n1189, n1190,
         n1191, n1192, n1193, n1194, n1195, n1196, n1197, n1198, n1199, n1200,
         n1201, n1202, n1203, n1204, n1205, n1206, n1207, n1208, n1209, n1210,
         n1211, n1212, n1213, n1214, n1215, n1216, n1217, n1218, n1219, n1220,
         n1221, n1222, n1223, n1224, n1225, n1226, n1227, n1228, n1229, n1230,
         n1231, n1232, n1233, n1234, n1235, n1236, n1237, n1238, n1239, n1240,
         n1241, n1242, n1243, n1244, n1245, n1246, n1247, n1248, n1249, n1250,
         n1251, n1252, n1253, n1254, n1255, n1256, n1257, n1258, n1259, n1260,
         n1261, n1262, n1263, n1264, n1265, n1266, n1267, n1268, n1269, n1270,
         n1271, n1272, n1273, n1274, n1275, n1276, n1277, n1278, n1279, n1280,
         n1281, n1282, n1283, n1284, n1285, n1286, n1287, n1288, n1289, n1290,
         n1291, n1292, n1293, n1294, n1295, n1296, n1297, n1298, n1299, n1300,
         n1301, n1302, n1303, n1304, n1305, n1306, n1307, n1308, n1309, n1310,
         n1311, n1312, n1313, n1314, n1315, n1316, n1317, n1318, n1319, n1320,
         n1321, n1322, n1323, n1324, n1325, n1326, n1327, n1328, n1329, n1330,
         n1331, n1332, n1365, n1398, n1399, n1400, n1401, n1402, n1403, n1404,
         n1405, n1406, n1407, n1408, n1409, n1410, n1411, n1412, n1413, n1414,
         n1415, n1416, n1417, n1418, n1419, n1420, n1421, n1422, n1423, n1424,
         n1425, n1426, n1427, n1428, n1429, n1430, n1431, n1432, n1433, n1434,
         n1435, n1436, carry_11_, carry_10_, carry_9_, carry_8_, carry_7_,
         carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, carry_1_, n1, n2,
         n3, n4, n5, n6, n7, n8, n9, n10, n11;
  wire   [1:0] Burst;
  wire   [11:0] IncreasedAddr;
  wire   [31:0] Addr;
  wire   [1:0] Size;
  wire   [2:0] IncrSize;
  assign RID[3] = \RID0[3] ;
  assign BID[3] = \RID0[3] ;
  assign RID[2] = \RID0[2] ;
  assign BID[2] = \RID0[2] ;
  assign RID[1] = \RID0[1] ;
  assign BID[1] = \RID0[1] ;
  assign RID[0] = \RID0[0] ;
  assign BID[0] = \RID0[0] ;
  assign RRESP[0] = 1'b0;
  assign RRESP[1] = 1'b0;
  assign BRESP[0] = 1'b0;
  assign BRESP[1] = 1'b0;

  OAI22X4 U383 ( .A0(n1429), .A1(n1106), .B0(n1409), .B1(n1098), .Y(
        MEMADDR[23]) );
  INVX8 U385 ( .A(Addr[25]), .Y(n1106) );
  OAI22X4 U386 ( .A0(n1430), .A1(n1108), .B0(n1410), .B1(n1094), .Y(
        MEMADDR[19]) );
  INVX8 U387 ( .A(Addr[21]), .Y(n1108) );
  OR2X4 U388 ( .A(n1109), .B(n1323), .Y(n501_0_) );
  OAI22X4 U389 ( .A0(n1111), .A1(n1112), .B0(n1113), .B1(n1114), .Y(n1280) );
  OAI22X4 U390 ( .A0(n1111), .A1(n1115), .B0(n1112), .B1(n1114), .Y(n1281) );
  INVX8 U391 ( .A(WREADY), .Y(n1112) );
  OAI22X4 U392 ( .A0(n1111), .A1(n1116), .B0(n1117), .B1(n1114), .Y(n1282) );
  OR2X4 U393 ( .A(n1118), .B(n1119), .Y(n1283) );
  OAI33X4 U394 ( .A0(n1111), .A1(StateIsREAD), .A2(n1113), .B0(n1111), .B1(
        BVALID), .B2(n1117), .Y(n1119) );
  INVX8 U395 ( .A(BVALID), .Y(n1113) );
  AND2X4 U396 ( .A(n1111), .B(n_394), .Y(n1118) );
  INVX8 U397 ( .A(n1114), .Y(n1111) );
  NAND3BX4 U398 ( .AN(n1120), .B(n1402), .C(n1122), .Y(n1114) );
  OAI31X4 U399 ( .A0(n1123), .A1(n_394), .A2(BREADY), .B0(BVALID), .Y(n1122)
         );
  OAI31X4 U400 ( .A0(n1124), .A1(n1125), .A2(n1126), .B0(n1127), .Y(n1120) );
  AOI222X4 U401 ( .A0(WLAST), .A1(n1128), .B0(n_394), .B1(n1123), .C0(
        StateIsREAD), .C1(WREADY), .Y(n1127) );
  INVX8 U402 ( .A(n1129), .Y(n1272) );
  AOI222X4 U403 ( .A0(ARSIZE[1]), .A1(ARREADY), .B0(Size[1]), .B1(n1130), .C0(
        AWSIZE[1]), .C1(AWREADY), .Y(n1129) );
  INVX8 U404 ( .A(n1131), .Y(n1273) );
  AOI222X4 U405 ( .A0(ARSIZE[0]), .A1(ARREADY), .B0(Size[0]), .B1(n1130), .C0(
        AWSIZE[0]), .C1(AWREADY), .Y(n1131) );
  XOR2X4 U406 ( .A(n1132), .B(ReadOrWrite), .Y(n1284) );
  OAI221X4 U407 ( .A0(n1115), .A1(n1133), .B0(n1116), .B1(n1134), .C0(n1402), 
        .Y(n1132) );
  INVX8 U408 ( .A(AWVALID), .Y(n1134) );
  INVX8 U409 ( .A(ARVALID), .Y(n1133) );
  INVX8 U410 ( .A(n1126), .Y(RLAST) );
  OR4X4 U411 ( .A(Len_1_), .B(Len_0_), .C(Len_3_), .D(Len_2_), .Y(n1126) );
  NAND2X4 U412 ( .A(WSTRB[3]), .B(n1128), .Y(MEMWEn[3]) );
  NAND2X4 U413 ( .A(WSTRB[2]), .B(n1128), .Y(MEMWEn[2]) );
  NAND2X4 U414 ( .A(WSTRB[1]), .B(n1128), .Y(MEMWEn[1]) );
  NAND2X4 U415 ( .A(WSTRB[0]), .B(n1128), .Y(MEMWEn[0]) );
  INVX8 U416 ( .A(n1135), .Y(n1128) );
  INVX8 U417 ( .A(n1123), .Y(MEMCEn) );
  OR2X4 U418 ( .A(StateIsREAD), .B(WREADY), .Y(n1123) );
  OAI22X4 U419 ( .A0(n1429), .A1(n1136), .B0(n1411), .B1(n1084), .Y(MEMADDR[9]) );
  OAI22X4 U420 ( .A0(n1430), .A1(n1137), .B0(n1412), .B1(n1083), .Y(MEMADDR[8]) );
  OAI22X4 U421 ( .A0(n1429), .A1(n1138), .B0(n1415), .B1(n1082), .Y(MEMADDR[7]) );
  OAI22X4 U422 ( .A0(n1430), .A1(n1139), .B0(n1416), .B1(n1081), .Y(MEMADDR[6]) );
  OAI22X4 U423 ( .A0(n1429), .A1(n1140), .B0(n1417), .B1(n1080), .Y(MEMADDR[5]) );
  OAI22X4 U424 ( .A0(n1430), .A1(n1141), .B0(n1418), .B1(n1079), .Y(MEMADDR[4]) );
  OAI22X4 U425 ( .A0(n1429), .A1(n1142), .B0(n1419), .B1(n1078), .Y(MEMADDR[3]) );
  OAI22X4 U426 ( .A0(n1430), .A1(n1143), .B0(n1420), .B1(n1077), .Y(MEMADDR[2]) );
  OAI22X4 U427 ( .A0(n1429), .A1(n1144), .B0(n1423), .B1(n1104), .Y(
        MEMADDR[29]) );
  INVX8 U428 ( .A(Addr[31]), .Y(n1144) );
  OAI22X4 U429 ( .A0(n1430), .A1(n1145), .B0(n1424), .B1(n1103), .Y(
        MEMADDR[28]) );
  INVX8 U430 ( .A(Addr[30]), .Y(n1145) );
  OAI22X4 U431 ( .A0(n1429), .A1(n1146), .B0(n1407), .B1(n1102), .Y(
        MEMADDR[27]) );
  INVX8 U432 ( .A(Addr[29]), .Y(n1146) );
  OAI22X4 U433 ( .A0(n1430), .A1(n1147), .B0(n1417), .B1(n1101), .Y(
        MEMADDR[26]) );
  INVX8 U434 ( .A(Addr[28]), .Y(n1147) );
  OAI22X4 U435 ( .A0(n1429), .A1(n1148), .B0(n1418), .B1(n1100), .Y(
        MEMADDR[25]) );
  INVX8 U436 ( .A(Addr[27]), .Y(n1148) );
  OAI22X4 U437 ( .A0(n1430), .A1(n1149), .B0(n1419), .B1(n1099), .Y(
        MEMADDR[24]) );
  INVX8 U438 ( .A(Addr[26]), .Y(n1149) );
  OAI22X4 U439 ( .A0(n1429), .A1(n1150), .B0(n1420), .B1(n1097), .Y(
        MEMADDR[22]) );
  INVX8 U440 ( .A(Addr[24]), .Y(n1150) );
  OAI22X4 U441 ( .A0(n1430), .A1(n1151), .B0(n1423), .B1(n1096), .Y(
        MEMADDR[21]) );
  INVX8 U442 ( .A(Addr[23]), .Y(n1151) );
  OAI22X4 U443 ( .A0(n1429), .A1(n1152), .B0(n1425), .B1(n1095), .Y(
        MEMADDR[20]) );
  INVX8 U444 ( .A(Addr[22]), .Y(n1152) );
  OAI22X4 U445 ( .A0(n1430), .A1(n1153), .B0(n1426), .B1(n1076), .Y(MEMADDR[1]) );
  OAI22X4 U446 ( .A0(n1429), .A1(n1154), .B0(n1427), .B1(n1093), .Y(
        MEMADDR[18]) );
  INVX8 U447 ( .A(Addr[20]), .Y(n1154) );
  OAI22X4 U448 ( .A0(n1430), .A1(n1155), .B0(n1428), .B1(n1092), .Y(
        MEMADDR[17]) );
  INVX8 U449 ( .A(Addr[19]), .Y(n1155) );
  OAI22X4 U450 ( .A0(n1429), .A1(n1156), .B0(n1407), .B1(n1091), .Y(
        MEMADDR[16]) );
  INVX8 U451 ( .A(Addr[18]), .Y(n1156) );
  OAI22X4 U452 ( .A0(n1430), .A1(n1157), .B0(n1408), .B1(n1090), .Y(
        MEMADDR[15]) );
  INVX8 U453 ( .A(Addr[17]), .Y(n1157) );
  OAI22X4 U454 ( .A0(n1429), .A1(n1158), .B0(n1409), .B1(n1089), .Y(
        MEMADDR[14]) );
  INVX8 U455 ( .A(Addr[16]), .Y(n1158) );
  OAI22X4 U456 ( .A0(n1430), .A1(n1159), .B0(n1410), .B1(n1088), .Y(
        MEMADDR[13]) );
  INVX8 U457 ( .A(Addr[15]), .Y(n1159) );
  OAI22X4 U458 ( .A0(n1429), .A1(n1160), .B0(n1411), .B1(n1087), .Y(
        MEMADDR[12]) );
  INVX8 U459 ( .A(Addr[14]), .Y(n1160) );
  OAI22X4 U460 ( .A0(n1430), .A1(n1161), .B0(n1412), .B1(n1086), .Y(
        MEMADDR[11]) );
  INVX8 U461 ( .A(Addr[13]), .Y(n1161) );
  OAI22X4 U462 ( .A0(n1429), .A1(n1162), .B0(n1415), .B1(n1085), .Y(
        MEMADDR[10]) );
  INVX8 U463 ( .A(Addr[12]), .Y(n1162) );
  OAI22X4 U464 ( .A0(n1430), .A1(n1163), .B0(n1416), .B1(n1075), .Y(MEMADDR[0]) );
  INVX8 U465 ( .A(n1408), .Y(n1105) );
  OR3X4 U466 ( .A(WREADY), .B(n1365), .C(FirstREADCycle), .Y(n1107) );
  OAI221X4 U467 ( .A0(n1401), .A1(n1164), .B0(n1165), .B1(n1166), .C0(n1167), 
        .Y(n1276) );
  NAND2X4 U468 ( .A(Len750_3_), .B(n1168), .Y(n1167) );
  INVX8 U469 ( .A(Len_3_), .Y(n1166) );
  OAI221X4 U470 ( .A0(n1401), .A1(n1169), .B0(n1165), .B1(n1170), .C0(n1171), 
        .Y(n1277) );
  NAND2X4 U471 ( .A(Len750_2_), .B(n1168), .Y(n1171) );
  INVX8 U472 ( .A(Len_2_), .Y(n1170) );
  OAI221X4 U473 ( .A0(n1402), .A1(n1172), .B0(n1165), .B1(n1173), .C0(n1174), 
        .Y(n1278) );
  NAND2X4 U474 ( .A(Len750_1_), .B(n1168), .Y(n1174) );
  INVX8 U475 ( .A(Len_1_), .Y(n1173) );
  INVX8 U476 ( .A(n1175), .Y(n1279) );
  AOI222X4 U477 ( .A0(Len750_0_), .A1(n1168), .B0(ARLEN[0]), .B1(n1109), .C0(
        Len_0_), .C1(n1176), .Y(n1175) );
  INVX8 U478 ( .A(n1177), .Y(n1168) );
  OR2X4 U479 ( .A(n1109), .B(n1176), .Y(n1177) );
  INVX8 U480 ( .A(n1165), .Y(n1176) );
  OAI2BB1X4 U481 ( .A0N(RVALID), .A1N(n1365), .B0(n1401), .Y(n1165) );
  INVX8 U482 ( .A(n1124), .Y(RVALID) );
  OR2X4 U483 ( .A(FirstREADCycle), .B(n1117), .Y(n1124) );
  AND2X4 U484 ( .A(Size[1]), .B(n1178), .Y(IncrSize[2]) );
  AND2X4 U485 ( .A(Size[0]), .B(n1179), .Y(IncrSize[1]) );
  INVX8 U486 ( .A(n1180), .Y(Id497_3_) );
  AOI222X4 U487 ( .A0(\RID0[3] ), .A1(n1324), .B0(ARID[3]), .B1(n1181), .C0(
        AWID[3]), .C1(n1182), .Y(n1180) );
  INVX8 U488 ( .A(n1183), .Y(Id497_2_) );
  AOI222X4 U489 ( .A0(\RID0[2] ), .A1(n1324), .B0(ARID[2]), .B1(n1181), .C0(
        AWID[2]), .C1(n1182), .Y(n1183) );
  INVX8 U490 ( .A(n1184), .Y(Id497_1_) );
  AOI222X4 U491 ( .A0(\RID0[1] ), .A1(n1323), .B0(ARID[1]), .B1(n1181), .C0(
        AWID[1]), .C1(n1182), .Y(n1184) );
  INVX8 U492 ( .A(n1185), .Y(Id497_0_) );
  AOI222X4 U493 ( .A0(\RID0[0] ), .A1(n1324), .B0(ARID[0]), .B1(n1181), .C0(
        AWID[0]), .C1(n1182), .Y(n1185) );
  INVX8 U494 ( .A(n1186), .Y(n1182) );
  OR2X4 U495 ( .A(n1187), .B(n1323), .Y(n1186) );
  INVX8 U496 ( .A(n1188), .Y(n1181) );
  OR2X4 U497 ( .A(ReadOrWrite), .B(n1323), .Y(n1188) );
  AND2X4 U499 ( .A(ARVALID), .B(ARREADY), .Y(FirstREADCycle248) );
  INVX8 U500 ( .A(n1189), .Y(n1274) );
  AOI222X4 U501 ( .A0(ARBURST[1]), .A1(ARREADY), .B0(Burst[1]), .B1(n1130), 
        .C0(AWBURST[1]), .C1(AWREADY), .Y(n1189) );
  INVX8 U502 ( .A(n1190), .Y(n1275) );
  AOI222X4 U503 ( .A0(ARBURST[0]), .A1(ARREADY), .B0(Burst[0]), .B1(n1130), 
        .C0(AWBURST[0]), .C1(AWREADY), .Y(n1190) );
  INVX8 U504 ( .A(n1115), .Y(AWREADY) );
  INVX8 U505 ( .A(n1116), .Y(ARREADY) );
  OAI222X4 U506 ( .A0(n1115), .A1(n1191), .B0(n_394), .B1(n1192), .C0(n1116), 
        .C1(n1164), .Y(n1269) );
  INVX8 U507 ( .A(ARLEN[3]), .Y(n1164) );
  INVX8 U508 ( .A(AWLEN[3]), .Y(n1191) );
  OAI222X4 U509 ( .A0(n1115), .A1(n1193), .B0(n_394), .B1(n1194), .C0(n1116), 
        .C1(n1169), .Y(n1270) );
  INVX8 U510 ( .A(ARLEN[2]), .Y(n1169) );
  INVX8 U511 ( .A(AWLEN[2]), .Y(n1193) );
  OAI222X4 U512 ( .A0(n1115), .A1(n1195), .B0(n_394), .B1(n1196), .C0(n1116), 
        .C1(n1172), .Y(n1271) );
  INVX8 U513 ( .A(ARLEN[1]), .Y(n1172) );
  OR2X4 U514 ( .A(ReadOrWrite), .B(n1130), .Y(n1116) );
  INVX8 U515 ( .A(AWLEN[1]), .Y(n1195) );
  OR2X4 U516 ( .A(n1187), .B(n1130), .Y(n1115) );
  INVX8 U517 ( .A(n_394), .Y(n1130) );
  OAI22X4 U518 ( .A0(n1138), .A1(n1197), .B0(n1198), .B1(n1199), .Y(n1307) );
  AOI222X4 U519 ( .A0(IncreasedAddr[9]), .A1(n1401), .B0(AWADDR[9]), .B1(n1329), .C0(ARADDR[9]), .C1(n1325), .Y(n1199) );
  INVX8 U520 ( .A(Addr[9]), .Y(n1138) );
  OAI22X4 U521 ( .A0(n1139), .A1(n1197), .B0(n1198), .B1(n1202), .Y(n1308) );
  AOI222X4 U522 ( .A0(IncreasedAddr[8]), .A1(n1401), .B0(AWADDR[8]), .B1(n1331), .C0(ARADDR[8]), .C1(n1327), .Y(n1202) );
  INVX8 U523 ( .A(Addr[8]), .Y(n1139) );
  OAI22X4 U524 ( .A0(n1140), .A1(n1197), .B0(n1198), .B1(n1203), .Y(n1309) );
  AOI222X4 U525 ( .A0(IncreasedAddr[7]), .A1(n1402), .B0(AWADDR[7]), .B1(n1331), .C0(ARADDR[7]), .C1(n1327), .Y(n1203) );
  INVX8 U526 ( .A(Addr[7]), .Y(n1140) );
  OAI222X4 U527 ( .A0(n1141), .A1(n1204), .B0(n1205), .B1(n1206), .C0(n1207), 
        .C1(n1208), .Y(n1310) );
  AOI221X4 U528 ( .A0(ARADDR[6]), .A1(n1325), .B0(AWADDR[6]), .B1(n1329), .C0(
        n1209), .Y(n1208) );
  AND3X4 U529 ( .A(IncreasedAddr[6]), .B(n1402), .C(n1205), .Y(n1209) );
  OR2X4 U530 ( .A(n1109), .B(n1141), .Y(n1206) );
  OAI2BB1X4 U531 ( .A0N(n1210), .A1N(BurstLen_3_), .B0(Burst[1]), .Y(n1205) );
  INVX8 U532 ( .A(Addr[6]), .Y(n1141) );
  OAI222X4 U533 ( .A0(n1142), .A1(n1204), .B0(n1211), .B1(n1212), .C0(n1207), 
        .C1(n1213), .Y(n1311) );
  AOI222X4 U534 ( .A0(ARADDR[5]), .A1(n1325), .B0(n1214), .B1(n1211), .C0(
        AWADDR[5]), .C1(n1329), .Y(n1213) );
  AND2X4 U535 ( .A(IncreasedAddr[5]), .B(n1401), .Y(n1214) );
  OR2X4 U536 ( .A(n1109), .B(n1142), .Y(n1212) );
  OAI221X4 U537 ( .A0(n1179), .A1(n1192), .B0(n1194), .B1(n1215), .C0(Burst[1]), .Y(n1211) );
  INVX8 U538 ( .A(Addr[5]), .Y(n1142) );
  OAI222X4 U539 ( .A0(n1143), .A1(n1204), .B0(n1216), .B1(n1217), .C0(n1207), 
        .C1(n1218), .Y(n1312) );
  AOI221X4 U540 ( .A0(ARADDR[4]), .A1(n1325), .B0(AWADDR[4]), .B1(n1329), .C0(
        n1219), .Y(n1218) );
  AND3X4 U541 ( .A(n1216), .B(IncreasedAddr[4]), .C(n1402), .Y(n1219) );
  OR2X4 U542 ( .A(n1109), .B(n1143), .Y(n1217) );
  OAI221X4 U543 ( .A0(IncrSize[0]), .A1(n1192), .B0(n1220), .B1(n1179), .C0(
        Burst[1]), .Y(n1216) );
  INVX8 U544 ( .A(n1221), .Y(n1220) );
  INVX8 U545 ( .A(BurstLen_3_), .Y(n1192) );
  INVX8 U546 ( .A(n1222), .Y(IncrSize[0]) );
  INVX8 U547 ( .A(Addr[4]), .Y(n1143) );
  OAI222X4 U548 ( .A0(n1153), .A1(n1204), .B0(n1223), .B1(n1224), .C0(n1207), 
        .C1(n1225), .Y(n1313) );
  AOI222X4 U549 ( .A0(ARADDR[3]), .A1(n1325), .B0(n1226), .B1(n1223), .C0(
        AWADDR[3]), .C1(n1329), .Y(n1225) );
  AND2X4 U550 ( .A(IncreasedAddr[3]), .B(n1402), .Y(n1226) );
  OR2X4 U551 ( .A(n1109), .B(n1153), .Y(n1224) );
  OAI211X4 U552 ( .A0(n1179), .A1(n1196), .B0(n1227), .C0(n1228), .Y(n1223) );
  AOI21X4 U553 ( .A0(BurstLen_2_), .A1(n1222), .B0(n1210), .Y(n1228) );
  INVX8 U554 ( .A(n1215), .Y(n1210) );
  OR2X4 U555 ( .A(n1179), .B(n1178), .Y(n1215) );
  INVX8 U556 ( .A(Size[0]), .Y(n1178) );
  INVX8 U557 ( .A(n1229), .Y(n1227) );
  INVX8 U558 ( .A(BurstLen_1_), .Y(n1196) );
  INVX8 U559 ( .A(Size[1]), .Y(n1179) );
  INVX8 U560 ( .A(Addr[3]), .Y(n1153) );
  INVX8 U561 ( .A(n1230), .Y(n1285) );
  AOI222X4 U562 ( .A0(Addr[31]), .A1(n1402), .B0(AWADDR[31]), .B1(n1331), .C0(
        ARADDR[31]), .C1(n1327), .Y(n1230) );
  INVX8 U563 ( .A(n1231), .Y(n1286) );
  AOI222X4 U564 ( .A0(Addr[30]), .A1(n1401), .B0(AWADDR[30]), .B1(n1331), .C0(
        ARADDR[30]), .C1(n1327), .Y(n1231) );
  OAI222X4 U565 ( .A0(n1163), .A1(n1204), .B0(n1232), .B1(n1233), .C0(n1207), 
        .C1(n1234), .Y(n1314) );
  AOI222X4 U566 ( .A0(ARADDR[2]), .A1(n1325), .B0(n1235), .B1(n1232), .C0(
        AWADDR[2]), .C1(n1329), .Y(n1234) );
  AND2X4 U567 ( .A(IncreasedAddr[2]), .B(n1121), .Y(n1235) );
  OR2X4 U568 ( .A(n1109), .B(n1163), .Y(n1233) );
  OR3X4 U569 ( .A(Size[1]), .B(n1229), .C(n1221), .Y(n1232) );
  OAI2BB1X4 U570 ( .A0N(BurstLen_1_), .A1N(Size[0]), .B0(n1194), .Y(n1221) );
  INVX8 U571 ( .A(BurstLen_2_), .Y(n1194) );
  INVX8 U572 ( .A(Addr[2]), .Y(n1163) );
  INVX8 U573 ( .A(n1236), .Y(n1287) );
  AOI222X4 U574 ( .A0(Addr[29]), .A1(n1402), .B0(AWADDR[29]), .B1(n1331), .C0(
        ARADDR[29]), .C1(n1326), .Y(n1236) );
  INVX8 U575 ( .A(n1237), .Y(n1288) );
  AOI222X4 U576 ( .A0(Addr[28]), .A1(n1121), .B0(AWADDR[28]), .B1(n1331), .C0(
        ARADDR[28]), .C1(n1326), .Y(n1237) );
  INVX8 U577 ( .A(n1238), .Y(n1289) );
  AOI222X4 U578 ( .A0(Addr[27]), .A1(n1401), .B0(AWADDR[27]), .B1(n1330), .C0(
        ARADDR[27]), .C1(n1326), .Y(n1238) );
  INVX8 U579 ( .A(n1239), .Y(n1290) );
  AOI222X4 U580 ( .A0(Addr[26]), .A1(n1402), .B0(AWADDR[26]), .B1(n1330), .C0(
        ARADDR[26]), .C1(n1326), .Y(n1239) );
  INVX8 U581 ( .A(n1240), .Y(n1291) );
  AOI222X4 U582 ( .A0(Addr[25]), .A1(n1121), .B0(AWADDR[25]), .B1(n1330), .C0(
        ARADDR[25]), .C1(n1326), .Y(n1240) );
  INVX8 U583 ( .A(n1241), .Y(n1292) );
  AOI222X4 U584 ( .A0(Addr[24]), .A1(n1401), .B0(AWADDR[24]), .B1(n1330), .C0(
        ARADDR[24]), .C1(n1326), .Y(n1241) );
  INVX8 U585 ( .A(n1242), .Y(n1293) );
  AOI222X4 U586 ( .A0(Addr[23]), .A1(n1402), .B0(AWADDR[23]), .B1(n1330), .C0(
        ARADDR[23]), .C1(n1326), .Y(n1242) );
  INVX8 U587 ( .A(n1243), .Y(n1294) );
  AOI222X4 U588 ( .A0(Addr[22]), .A1(n1121), .B0(AWADDR[22]), .B1(n1330), .C0(
        ARADDR[22]), .C1(n1326), .Y(n1243) );
  INVX8 U589 ( .A(n1244), .Y(n1295) );
  AOI222X4 U590 ( .A0(Addr[21]), .A1(n1401), .B0(AWADDR[21]), .B1(n1330), .C0(
        ARADDR[21]), .C1(n1326), .Y(n1244) );
  INVX8 U591 ( .A(n1245), .Y(n1296) );
  AOI222X4 U592 ( .A0(Addr[20]), .A1(n1402), .B0(AWADDR[20]), .B1(n1330), .C0(
        ARADDR[20]), .C1(n1326), .Y(n1245) );
  OAI222X4 U593 ( .A0(n1204), .A1(n1246), .B0(n1109), .B1(n1247), .C0(n1207), 
        .C1(n1248), .Y(n1315) );
  AOI221X4 U594 ( .A0(ARADDR[1]), .A1(n1325), .B0(AWADDR[1]), .B1(n1329), .C0(
        n1249), .Y(n1248) );
  AND3X4 U595 ( .A(n1250), .B(IncreasedAddr[1]), .C(n1121), .Y(n1249) );
  OR2X4 U596 ( .A(n1246), .B(n1250), .Y(n1247) );
  OR4X4 U597 ( .A(BurstLen_2_), .B(BurstLen_1_), .C(n1222), .D(n1229), .Y(
        n1250) );
  OR2X4 U598 ( .A(BurstLen_3_), .B(n1251), .Y(n1229) );
  OR2X4 U599 ( .A(Size[0]), .B(Size[1]), .Y(n1222) );
  INVX8 U600 ( .A(n1121), .Y(n1109) );
  INVX8 U601 ( .A(Addr[1]), .Y(n1246) );
  INVX8 U602 ( .A(n1252), .Y(n1297) );
  AOI222X4 U603 ( .A0(Addr[19]), .A1(n1121), .B0(AWADDR[19]), .B1(n1330), .C0(
        ARADDR[19]), .C1(n1326), .Y(n1252) );
  INVX8 U604 ( .A(n1253), .Y(n1298) );
  AOI222X4 U605 ( .A0(Addr[18]), .A1(n1401), .B0(AWADDR[18]), .B1(n1330), .C0(
        ARADDR[18]), .C1(n1326), .Y(n1253) );
  INVX8 U606 ( .A(n1254), .Y(n1299) );
  AOI222X4 U607 ( .A0(Addr[17]), .A1(n1402), .B0(AWADDR[17]), .B1(n1330), .C0(
        ARADDR[17]), .C1(n1326), .Y(n1254) );
  INVX8 U608 ( .A(n1255), .Y(n1300) );
  AOI222X4 U609 ( .A0(Addr[16]), .A1(n1121), .B0(AWADDR[16]), .B1(n1330), .C0(
        ARADDR[16]), .C1(n1325), .Y(n1255) );
  INVX8 U610 ( .A(n1256), .Y(n1301) );
  AOI222X4 U611 ( .A0(Addr[15]), .A1(n1401), .B0(AWADDR[15]), .B1(n1329), .C0(
        ARADDR[15]), .C1(n1325), .Y(n1256) );
  INVX8 U612 ( .A(n1257), .Y(n1302) );
  AOI222X4 U613 ( .A0(Addr[14]), .A1(n1402), .B0(AWADDR[14]), .B1(n1329), .C0(
        ARADDR[14]), .C1(n1325), .Y(n1257) );
  INVX8 U614 ( .A(n1258), .Y(n1303) );
  AOI222X4 U615 ( .A0(Addr[13]), .A1(n1121), .B0(AWADDR[13]), .B1(n1329), .C0(
        ARADDR[13]), .C1(n1325), .Y(n1258) );
  INVX8 U616 ( .A(n1259), .Y(n1304) );
  AOI222X4 U617 ( .A0(Addr[12]), .A1(n1401), .B0(AWADDR[12]), .B1(n1329), .C0(
        ARADDR[12]), .C1(n1325), .Y(n1259) );
  OAI22X4 U618 ( .A0(n1136), .A1(n1197), .B0(n1198), .B1(n1260), .Y(n1305) );
  AOI222X4 U619 ( .A0(IncreasedAddr[11]), .A1(n1402), .B0(AWADDR[11]), .B1(
        n1329), .C0(ARADDR[11]), .C1(n1325), .Y(n1260) );
  INVX8 U620 ( .A(Addr[11]), .Y(n1136) );
  OAI22X4 U621 ( .A0(n1137), .A1(n1197), .B0(n1198), .B1(n1261), .Y(n1306) );
  AOI222X4 U622 ( .A0(IncreasedAddr[10]), .A1(n1121), .B0(AWADDR[10]), .B1(
        n1329), .C0(ARADDR[10]), .C1(n1325), .Y(n1261) );
  INVX8 U623 ( .A(Addr[10]), .Y(n1137) );
  OAI22X4 U624 ( .A0(n1204), .A1(n1268), .B0(n1207), .B1(n1262), .Y(n1316) );
  AOI222X4 U625 ( .A0(IncreasedAddr[0]), .A1(n1401), .B0(AWADDR[0]), .B1(n1330), .C0(ARADDR[0]), .C1(n1326), .Y(n1262) );
  INVX8 U626 ( .A(n1263), .Y(n1201) );
  OR2X4 U627 ( .A(ReadOrWrite), .B(n1121), .Y(n1263) );
  INVX8 U628 ( .A(n1264), .Y(n1200) );
  OR2X4 U629 ( .A(n1187), .B(n1401), .Y(n1264) );
  INVX8 U630 ( .A(n1204), .Y(n1207) );
  OAI31X4 U631 ( .A0(n1265), .A1(Burst[0]), .A2(n1251), .B0(n1198), .Y(n1204)
         );
  INVX8 U632 ( .A(n1197), .Y(n1198) );
  OAI31X4 U633 ( .A0(n1265), .A1(Burst[1]), .A2(n1266), .B0(n1401), .Y(n1197)
         );
  OAI221X4 U634 ( .A0(ReadOrWrite), .A1(ARVALID), .B0(AWVALID), .B1(n1187), 
        .C0(n_394), .Y(n1121) );
  INVX8 U635 ( .A(ReadOrWrite), .Y(n1187) );
  INVX8 U636 ( .A(Burst[0]), .Y(n1266) );
  INVX8 U637 ( .A(Burst[1]), .Y(n1251) );
  INVX8 U638 ( .A(n1399), .Y(n1265) );
  OAI211X4 U639 ( .A0(n1125), .A1(n1117), .B0(n1267), .C0(n1135), .Y(n_1759)
         );
  NAND2X4 U640 ( .A(WVALID), .B(WREADY), .Y(n1135) );
  INVX8 U641 ( .A(FirstREADCycle), .Y(n1267) );
  INVX8 U642 ( .A(StateIsREAD), .Y(n1117) );
  INVX8 U643 ( .A(n1365), .Y(n1125) );
  EDFFX4 Id_reg_3_ ( .D(Id497_3_), .CK(ACLK), .E(n501_0_), .Q(\RID0[3] ) );
  EDFFX4 Id_reg_2_ ( .D(Id497_2_), .CK(ACLK), .E(n501_0_), .Q(\RID0[2] ) );
  EDFFX4 Id_reg_1_ ( .D(Id497_1_), .CK(ACLK), .E(n501_0_), .Q(\RID0[1] ) );
  EDFFX4 Id_reg_0_ ( .D(Id497_0_), .CK(ACLK), .E(n501_0_), .Q(\RID0[0] ) );
  DFFRX4 FirstREADCycle_reg ( .D(FirstREADCycle248), .CK(ACLK), .RN(n1318), 
        .Q(FirstREADCycle) );
  EDFFX4 PrevAddr_reg_31_ ( .D(Addr[31]), .CK(ACLK), .E(n_1759), .QN(n1104) );
  EDFFX4 PrevAddr_reg_30_ ( .D(Addr[30]), .CK(ACLK), .E(n1400), .QN(n1103) );
  EDFFX4 PrevAddr_reg_29_ ( .D(Addr[29]), .CK(ACLK), .E(n1399), .QN(n1102) );
  EDFFX4 PrevAddr_reg_28_ ( .D(Addr[28]), .CK(ACLK), .E(n_1759), .QN(n1101) );
  EDFFX4 PrevAddr_reg_27_ ( .D(Addr[27]), .CK(ACLK), .E(n1400), .QN(n1100) );
  EDFFX4 PrevAddr_reg_26_ ( .D(Addr[26]), .CK(ACLK), .E(n1399), .QN(n1099) );
  EDFFX4 PrevAddr_reg_25_ ( .D(Addr[25]), .CK(ACLK), .E(n_1759), .QN(n1098) );
  EDFFX4 PrevAddr_reg_24_ ( .D(Addr[24]), .CK(ACLK), .E(n1400), .QN(n1097) );
  EDFFX4 PrevAddr_reg_23_ ( .D(Addr[23]), .CK(ACLK), .E(n1399), .QN(n1096) );
  EDFFX4 PrevAddr_reg_22_ ( .D(Addr[22]), .CK(ACLK), .E(n_1759), .QN(n1095) );
  EDFFX4 PrevAddr_reg_21_ ( .D(Addr[21]), .CK(ACLK), .E(n1400), .QN(n1094) );
  EDFFX4 PrevAddr_reg_20_ ( .D(Addr[20]), .CK(ACLK), .E(n1399), .QN(n1093) );
  EDFFX4 PrevAddr_reg_19_ ( .D(Addr[19]), .CK(ACLK), .E(n_1759), .QN(n1092) );
  EDFFX4 PrevAddr_reg_18_ ( .D(Addr[18]), .CK(ACLK), .E(n1400), .QN(n1091) );
  EDFFX4 PrevAddr_reg_17_ ( .D(Addr[17]), .CK(ACLK), .E(n1399), .QN(n1090) );
  EDFFX4 PrevAddr_reg_16_ ( .D(Addr[16]), .CK(ACLK), .E(n_1759), .QN(n1089) );
  EDFFX4 PrevAddr_reg_15_ ( .D(Addr[15]), .CK(ACLK), .E(n1400), .QN(n1088) );
  EDFFX4 PrevAddr_reg_14_ ( .D(Addr[14]), .CK(ACLK), .E(n1399), .QN(n1087) );
  EDFFX4 PrevAddr_reg_13_ ( .D(Addr[13]), .CK(ACLK), .E(n_1759), .QN(n1086) );
  EDFFX4 PrevAddr_reg_12_ ( .D(Addr[12]), .CK(ACLK), .E(n1400), .QN(n1085) );
  EDFFX4 PrevAddr_reg_11_ ( .D(Addr[11]), .CK(ACLK), .E(n1399), .QN(n1084) );
  EDFFX4 PrevAddr_reg_10_ ( .D(Addr[10]), .CK(ACLK), .E(n_1759), .QN(n1083) );
  EDFFX4 PrevAddr_reg_9_ ( .D(Addr[9]), .CK(ACLK), .E(n1400), .QN(n1082) );
  EDFFX4 PrevAddr_reg_8_ ( .D(Addr[8]), .CK(ACLK), .E(n1400), .QN(n1081) );
  EDFFX4 PrevAddr_reg_7_ ( .D(Addr[7]), .CK(ACLK), .E(n_1759), .QN(n1080) );
  EDFFX4 PrevAddr_reg_6_ ( .D(Addr[6]), .CK(ACLK), .E(n1400), .QN(n1079) );
  EDFFX4 PrevAddr_reg_5_ ( .D(Addr[5]), .CK(ACLK), .E(n_1759), .QN(n1078) );
  EDFFX4 PrevAddr_reg_4_ ( .D(Addr[4]), .CK(ACLK), .E(n_1759), .QN(n1077) );
  EDFFX4 PrevAddr_reg_3_ ( .D(Addr[3]), .CK(ACLK), .E(n1400), .QN(n1076) );
  EDFFX4 PrevAddr_reg_2_ ( .D(Addr[2]), .CK(ACLK), .E(n1400), .QN(n1075) );
  INVX20 U644 ( .A(n1322), .Y(n1317) );
  INVX20 U645 ( .A(n1322), .Y(n1318) );
  INVX20 U646 ( .A(n1321), .Y(n1319) );
  INVX20 U647 ( .A(n1321), .Y(n1320) );
  INVX12 U648 ( .A(n1398), .Y(n1321) );
  INVX12 U649 ( .A(n1398), .Y(n1322) );
  INVX12 U650 ( .A(n1398), .Y(n1323) );
  INVX12 U651 ( .A(n1398), .Y(n1324) );
  INVX20 U652 ( .A(n1328), .Y(n1325) );
  INVX20 U653 ( .A(n1328), .Y(n1326) );
  INVX20 U654 ( .A(n1328), .Y(n1327) );
  INVX20 U655 ( .A(n1201), .Y(n1328) );
  INVX20 U656 ( .A(n1332), .Y(n1329) );
  INVX20 U657 ( .A(n1332), .Y(n1330) );
  INVX20 U658 ( .A(n1332), .Y(n1331) );
  INVX20 U659 ( .A(n1200), .Y(n1332) );
  BUFX20 U660 ( .A(MEMRDATA[0]), .Y(RDATA[0]) );
  BUFX20 U661 ( .A(MEMRDATA[1]), .Y(RDATA[1]) );
  BUFX20 U662 ( .A(MEMRDATA[2]), .Y(RDATA[2]) );
  BUFX20 U663 ( .A(MEMRDATA[3]), .Y(RDATA[3]) );
  BUFX20 U664 ( .A(MEMRDATA[4]), .Y(RDATA[4]) );
  BUFX20 U665 ( .A(MEMRDATA[5]), .Y(RDATA[5]) );
  BUFX20 U666 ( .A(MEMRDATA[6]), .Y(RDATA[6]) );
  BUFX20 U667 ( .A(MEMRDATA[7]), .Y(RDATA[7]) );
  BUFX20 U668 ( .A(MEMRDATA[8]), .Y(RDATA[8]) );
  BUFX20 U669 ( .A(MEMRDATA[9]), .Y(RDATA[9]) );
  BUFX20 U670 ( .A(MEMRDATA[10]), .Y(RDATA[10]) );
  BUFX20 U671 ( .A(MEMRDATA[11]), .Y(RDATA[11]) );
  BUFX20 U672 ( .A(MEMRDATA[12]), .Y(RDATA[12]) );
  BUFX20 U673 ( .A(MEMRDATA[13]), .Y(RDATA[13]) );
  BUFX20 U674 ( .A(MEMRDATA[14]), .Y(RDATA[14]) );
  BUFX20 U675 ( .A(MEMRDATA[15]), .Y(RDATA[15]) );
  BUFX20 U676 ( .A(MEMRDATA[16]), .Y(RDATA[16]) );
  BUFX20 U677 ( .A(MEMRDATA[17]), .Y(RDATA[17]) );
  BUFX20 U678 ( .A(MEMRDATA[18]), .Y(RDATA[18]) );
  BUFX20 U679 ( .A(MEMRDATA[19]), .Y(RDATA[19]) );
  BUFX20 U680 ( .A(MEMRDATA[20]), .Y(RDATA[20]) );
  BUFX20 U681 ( .A(MEMRDATA[21]), .Y(RDATA[21]) );
  BUFX20 U682 ( .A(MEMRDATA[22]), .Y(RDATA[22]) );
  BUFX20 U683 ( .A(MEMRDATA[23]), .Y(RDATA[23]) );
  BUFX20 U684 ( .A(MEMRDATA[24]), .Y(RDATA[24]) );
  BUFX20 U685 ( .A(MEMRDATA[25]), .Y(RDATA[25]) );
  BUFX20 U686 ( .A(MEMRDATA[26]), .Y(RDATA[26]) );
  BUFX20 U687 ( .A(MEMRDATA[27]), .Y(RDATA[27]) );
  BUFX20 U688 ( .A(MEMRDATA[28]), .Y(RDATA[28]) );
  BUFX20 U689 ( .A(MEMRDATA[29]), .Y(RDATA[29]) );
  BUFX20 U690 ( .A(MEMRDATA[30]), .Y(RDATA[30]) );
  BUFX20 U691 ( .A(MEMRDATA[31]), .Y(RDATA[31]) );
  BUFX20 U692 ( .A(RREADY), .Y(n1365) );
  BUFX20 U693 ( .A(WDATA[0]), .Y(MEMWDATA[0]) );
  BUFX20 U694 ( .A(WDATA[1]), .Y(MEMWDATA[1]) );
  BUFX20 U695 ( .A(WDATA[2]), .Y(MEMWDATA[2]) );
  BUFX20 U696 ( .A(WDATA[3]), .Y(MEMWDATA[3]) );
  BUFX20 U697 ( .A(WDATA[4]), .Y(MEMWDATA[4]) );
  BUFX20 U698 ( .A(WDATA[5]), .Y(MEMWDATA[5]) );
  BUFX20 U699 ( .A(WDATA[6]), .Y(MEMWDATA[6]) );
  BUFX20 U700 ( .A(WDATA[7]), .Y(MEMWDATA[7]) );
  BUFX20 U701 ( .A(WDATA[8]), .Y(MEMWDATA[8]) );
  BUFX20 U702 ( .A(WDATA[9]), .Y(MEMWDATA[9]) );
  BUFX20 U703 ( .A(WDATA[10]), .Y(MEMWDATA[10]) );
  BUFX20 U704 ( .A(WDATA[11]), .Y(MEMWDATA[11]) );
  BUFX20 U705 ( .A(WDATA[12]), .Y(MEMWDATA[12]) );
  BUFX20 U706 ( .A(WDATA[13]), .Y(MEMWDATA[13]) );
  BUFX20 U707 ( .A(WDATA[14]), .Y(MEMWDATA[14]) );
  BUFX20 U708 ( .A(WDATA[15]), .Y(MEMWDATA[15]) );
  BUFX20 U709 ( .A(WDATA[16]), .Y(MEMWDATA[16]) );
  BUFX20 U710 ( .A(WDATA[17]), .Y(MEMWDATA[17]) );
  BUFX20 U711 ( .A(WDATA[18]), .Y(MEMWDATA[18]) );
  BUFX20 U712 ( .A(WDATA[19]), .Y(MEMWDATA[19]) );
  BUFX20 U713 ( .A(WDATA[20]), .Y(MEMWDATA[20]) );
  BUFX20 U714 ( .A(WDATA[21]), .Y(MEMWDATA[21]) );
  BUFX20 U715 ( .A(WDATA[22]), .Y(MEMWDATA[22]) );
  BUFX20 U716 ( .A(WDATA[23]), .Y(MEMWDATA[23]) );
  BUFX20 U717 ( .A(WDATA[24]), .Y(MEMWDATA[24]) );
  BUFX20 U718 ( .A(WDATA[25]), .Y(MEMWDATA[25]) );
  BUFX20 U719 ( .A(WDATA[26]), .Y(MEMWDATA[26]) );
  BUFX20 U720 ( .A(WDATA[27]), .Y(MEMWDATA[27]) );
  BUFX20 U721 ( .A(WDATA[28]), .Y(MEMWDATA[28]) );
  BUFX20 U722 ( .A(WDATA[29]), .Y(MEMWDATA[29]) );
  BUFX20 U723 ( .A(WDATA[30]), .Y(MEMWDATA[30]) );
  BUFX20 U724 ( .A(WDATA[31]), .Y(MEMWDATA[31]) );
  BUFX20 U725 ( .A(ARESETn), .Y(n1398) );
  OAI211X4 U726 ( .A0(n1125), .A1(n1117), .B0(n1267), .C0(n1135), .Y(n1399) );
  OAI211X4 U727 ( .A0(n1125), .A1(n1117), .B0(n1267), .C0(n1135), .Y(n1400) );
  OAI221X4 U728 ( .A0(ReadOrWrite), .A1(ARVALID), .B0(AWVALID), .B1(n1187), 
        .C0(n_394), .Y(n1401) );
  OAI221X4 U729 ( .A0(ReadOrWrite), .A1(ARVALID), .B0(AWVALID), .B1(n1187), 
        .C0(n_394), .Y(n1402) );
  OR3X4 U730 ( .A(WREADY), .B(n1365), .C(FirstREADCycle), .Y(n1403) );
  OR3X4 U731 ( .A(WREADY), .B(n1365), .C(FirstREADCycle), .Y(n1404) );
  INVX4 U732 ( .A(n1403), .Y(n1405) );
  INVX4 U733 ( .A(n1403), .Y(n1406) );
  INVX4 U734 ( .A(n1405), .Y(n1407) );
  INVX4 U735 ( .A(n1405), .Y(n1408) );
  INVX4 U736 ( .A(n1405), .Y(n1409) );
  INVX4 U737 ( .A(n1406), .Y(n1410) );
  INVX4 U738 ( .A(n1406), .Y(n1411) );
  INVX4 U739 ( .A(n1406), .Y(n1412) );
  INVX4 U740 ( .A(n1404), .Y(n1413) );
  INVX4 U741 ( .A(n1404), .Y(n1414) );
  INVX4 U742 ( .A(n1413), .Y(n1415) );
  INVX4 U743 ( .A(n1413), .Y(n1416) );
  INVX4 U744 ( .A(n1413), .Y(n1417) );
  INVX4 U745 ( .A(n1414), .Y(n1418) );
  INVX4 U746 ( .A(n1414), .Y(n1419) );
  INVX4 U747 ( .A(n1414), .Y(n1420) );
  INVX4 U748 ( .A(n1107), .Y(n1421) );
  INVX4 U749 ( .A(n1107), .Y(n1422) );
  INVX4 U750 ( .A(n1421), .Y(n1423) );
  INVX2 U751 ( .A(n1421), .Y(n1424) );
  INVX2 U752 ( .A(n1421), .Y(n1425) );
  INVX4 U753 ( .A(n1422), .Y(n1426) );
  INVX4 U754 ( .A(n1422), .Y(n1427) );
  INVX4 U755 ( .A(n1422), .Y(n1428) );
  BUFX20 U756 ( .A(n1105), .Y(n1429) );
  BUFX20 U757 ( .A(n1105), .Y(n1430) );
  DFFRX4 Addr_reg_0_ ( .D(n1316), .CK(ACLK), .RN(n1317), .Q(Addr[0]), .QN(
        n1268) );
  DFFRX4 Addr_reg_1_ ( .D(n1315), .CK(ACLK), .RN(n1317), .Q(Addr[1]) );
  DFFRX4 Addr_reg_2_ ( .D(n1314), .CK(ACLK), .RN(n1317), .Q(Addr[2]) );
  DFFRX4 Addr_reg_3_ ( .D(n1313), .CK(ACLK), .RN(n1317), .Q(Addr[3]) );
  DFFRX4 Addr_reg_4_ ( .D(n1312), .CK(ACLK), .RN(n1317), .Q(Addr[4]) );
  DFFRX4 Addr_reg_5_ ( .D(n1311), .CK(ACLK), .RN(n1317), .Q(Addr[5]) );
  DFFRX4 Addr_reg_6_ ( .D(n1310), .CK(ACLK), .RN(n1317), .Q(Addr[6]) );
  DFFRX4 Addr_reg_7_ ( .D(n1309), .CK(ACLK), .RN(n1317), .Q(Addr[7]) );
  DFFRX4 Addr_reg_8_ ( .D(n1308), .CK(ACLK), .RN(n1317), .Q(Addr[8]) );
  DFFRX4 Addr_reg_9_ ( .D(n1307), .CK(ACLK), .RN(n1317), .Q(Addr[9]) );
  DFFRX4 Addr_reg_10_ ( .D(n1306), .CK(ACLK), .RN(n1317), .Q(Addr[10]) );
  DFFRX4 Addr_reg_11_ ( .D(n1305), .CK(ACLK), .RN(n1317), .Q(Addr[11]) );
  DFFRX4 Addr_reg_12_ ( .D(n1304), .CK(ACLK), .RN(n1317), .Q(Addr[12]) );
  DFFRX4 Addr_reg_13_ ( .D(n1303), .CK(ACLK), .RN(n1317), .Q(Addr[13]) );
  DFFRX4 Addr_reg_14_ ( .D(n1302), .CK(ACLK), .RN(n1318), .Q(Addr[14]) );
  DFFRX4 Addr_reg_15_ ( .D(n1301), .CK(ACLK), .RN(n1318), .Q(Addr[15]) );
  DFFRX4 Addr_reg_16_ ( .D(n1300), .CK(ACLK), .RN(n1318), .Q(Addr[16]) );
  DFFRX4 Addr_reg_17_ ( .D(n1299), .CK(ACLK), .RN(n1318), .Q(Addr[17]) );
  DFFRX4 Addr_reg_18_ ( .D(n1298), .CK(ACLK), .RN(n1318), .Q(Addr[18]) );
  DFFRX4 Addr_reg_19_ ( .D(n1297), .CK(ACLK), .RN(n1318), .Q(Addr[19]) );
  DFFRX4 Addr_reg_20_ ( .D(n1296), .CK(ACLK), .RN(n1318), .Q(Addr[20]) );
  DFFRX4 Addr_reg_21_ ( .D(n1295), .CK(ACLK), .RN(n1318), .Q(Addr[21]) );
  DFFRX4 Addr_reg_22_ ( .D(n1294), .CK(ACLK), .RN(n1318), .Q(Addr[22]) );
  DFFRX4 Addr_reg_23_ ( .D(n1293), .CK(ACLK), .RN(n1318), .Q(Addr[23]) );
  DFFRX4 Addr_reg_24_ ( .D(n1292), .CK(ACLK), .RN(n1318), .Q(Addr[24]) );
  DFFRX4 Addr_reg_25_ ( .D(n1291), .CK(ACLK), .RN(n1318), .Q(Addr[25]) );
  DFFRX4 Addr_reg_26_ ( .D(n1290), .CK(ACLK), .RN(n1318), .Q(Addr[26]) );
  DFFRX4 Addr_reg_27_ ( .D(n1289), .CK(ACLK), .RN(n1318), .Q(Addr[27]) );
  DFFRX4 Addr_reg_28_ ( .D(n1288), .CK(ACLK), .RN(n1318), .Q(Addr[28]) );
  DFFRX4 Addr_reg_29_ ( .D(n1287), .CK(ACLK), .RN(n1319), .Q(Addr[29]) );
  DFFRX4 Addr_reg_30_ ( .D(n1286), .CK(ACLK), .RN(n1319), .Q(Addr[30]) );
  DFFRX4 Addr_reg_31_ ( .D(n1285), .CK(ACLK), .RN(n1319), .Q(Addr[31]) );
  DFFRX4 ReadOrWrite_reg ( .D(n1284), .CK(ACLK), .RN(n1319), .Q(ReadOrWrite)
         );
  DFFSX4 State_reg_0_ ( .D(n1283), .CK(ACLK), .SN(n1317), .Q(n_394) );
  DFFRX4 State_reg_1_ ( .D(n1282), .CK(ACLK), .RN(n1319), .Q(StateIsREAD) );
  DFFRX4 State_reg_2_ ( .D(n1281), .CK(ACLK), .RN(n1319), .Q(WREADY) );
  DFFRX4 State_reg_3_ ( .D(n1280), .CK(ACLK), .RN(n1319), .Q(BVALID) );
  DFFRX4 Len_reg_0_ ( .D(n1279), .CK(ACLK), .RN(n1319), .Q(Len_0_) );
  DFFRX4 Len_reg_1_ ( .D(n1278), .CK(ACLK), .RN(n1319), .Q(Len_1_) );
  DFFRX4 Len_reg_2_ ( .D(n1277), .CK(ACLK), .RN(n1319), .Q(Len_2_) );
  DFFRX4 Len_reg_3_ ( .D(n1276), .CK(ACLK), .RN(n1319), .Q(Len_3_) );
  DFFRX4 Burst_reg_0_ ( .D(n1275), .CK(ACLK), .RN(n1319), .Q(Burst[0]) );
  DFFRX4 Burst_reg_1_ ( .D(n1274), .CK(ACLK), .RN(n1319), .Q(Burst[1]) );
  DFFRX4 Size_reg_0_ ( .D(n1273), .CK(ACLK), .RN(n1319), .Q(Size[0]) );
  DFFRX4 Size_reg_1_ ( .D(n1272), .CK(ACLK), .RN(n1319), .Q(Size[1]) );
  DFFRX4 BurstLen_reg_1_ ( .D(n1271), .CK(ACLK), .RN(n1319), .Q(BurstLen_1_)
         );
  DFFRX4 BurstLen_reg_2_ ( .D(n1270), .CK(ACLK), .RN(n1320), .Q(BurstLen_2_)
         );
  DFFRX4 BurstLen_reg_3_ ( .D(n1269), .CK(ACLK), .RN(n1317), .Q(BurstLen_3_)
         );
  INVX8 U758 ( .A(Len_0_), .Y(Len750_0_) );
  INVX8 U759 ( .A(Len_1_), .Y(n1431) );
  NAND2X4 U760 ( .A(n1431), .B(Len750_0_), .Y(n1433) );
  NAND2X4 U761 ( .A(Len_1_), .B(Len_0_), .Y(n1432) );
  NAND2X4 U762 ( .A(n1433), .B(n1432), .Y(Len750_1_) );
  INVX8 U763 ( .A(n1433), .Y(n1435) );
  INVX8 U764 ( .A(Len_2_), .Y(n1434) );
  XNOR2X4 U765 ( .A(n1435), .B(n1434), .Y(Len750_2_) );
  NAND2X4 U766 ( .A(n1435), .B(n1434), .Y(n1436) );
  XNOR2X4 U767 ( .A(Len_3_), .B(n1436), .Y(Len750_3_) );
  XOR2X1 U4 ( .A(Addr[11]), .B(carry_11_), .Y(IncreasedAddr[11]) );
  NAND2X1 U5 ( .A(Addr[10]), .B(carry_10_), .Y(n1) );
  XOR2X1 U6 ( .A(Addr[10]), .B(carry_10_), .Y(IncreasedAddr[10]) );
  NAND2X1 U7 ( .A(Addr[9]), .B(carry_9_), .Y(n2) );
  XOR2X1 U8 ( .A(Addr[9]), .B(carry_9_), .Y(IncreasedAddr[9]) );
  NAND2X1 U9 ( .A(Addr[8]), .B(carry_8_), .Y(n3) );
  XOR2X1 U10 ( .A(Addr[8]), .B(carry_8_), .Y(IncreasedAddr[8]) );
  NAND2X1 U11 ( .A(Addr[7]), .B(carry_7_), .Y(n4) );
  XOR2X1 U12 ( .A(Addr[7]), .B(carry_7_), .Y(IncreasedAddr[7]) );
  NAND2X1 U13 ( .A(Addr[6]), .B(carry_6_), .Y(n5) );
  XOR2X1 U14 ( .A(Addr[6]), .B(carry_6_), .Y(IncreasedAddr[6]) );
  NAND2X1 U15 ( .A(Addr[5]), .B(carry_5_), .Y(n6) );
  XOR2X1 U16 ( .A(Addr[5]), .B(carry_5_), .Y(IncreasedAddr[5]) );
  NAND2X1 U17 ( .A(Addr[4]), .B(carry_4_), .Y(n7) );
  XOR2X1 U18 ( .A(Addr[4]), .B(carry_4_), .Y(IncreasedAddr[4]) );
  NAND2X1 U19 ( .A(Addr[3]), .B(carry_3_), .Y(n8) );
  XOR2X1 U20 ( .A(Addr[3]), .B(carry_3_), .Y(IncreasedAddr[3]) );
  NAND2X1 U21 ( .A(IncrSize[0]), .B(Addr[0]), .Y(n11) );
  XOR2X1 U22 ( .A(IncrSize[0]), .B(Addr[0]), .Y(IncreasedAddr[0]) );
  INVX8 U23 ( .A(n3), .Y(carry_9_) );
  INVX8 U24 ( .A(n4), .Y(carry_8_) );
  INVX8 U25 ( .A(n5), .Y(carry_7_) );
  INVX8 U26 ( .A(n6), .Y(carry_6_) );
  INVX8 U27 ( .A(n7), .Y(carry_5_) );
  INVX8 U28 ( .A(n8), .Y(carry_4_) );
  INVX8 U29 ( .A(n9), .Y(carry_3_) );
  INVX8 U30 ( .A(n10), .Y(carry_2_) );
  INVX8 U31 ( .A(n11), .Y(carry_1_) );
  INVX8 U32 ( .A(n1), .Y(carry_11_) );
  INVX8 U33 ( .A(n2), .Y(carry_10_) );
  AFHCONX2 U1_1 ( .A(Addr[1]), .B(IncrSize[1]), .CI(carry_1_), .S(
        IncreasedAddr[1]), .CON(n10) );
  AFHCONX2 U1_2 ( .A(Addr[2]), .B(IncrSize[2]), .CI(carry_2_), .S(
        IncreasedAddr[2]), .CON(n9) );
endmodule

