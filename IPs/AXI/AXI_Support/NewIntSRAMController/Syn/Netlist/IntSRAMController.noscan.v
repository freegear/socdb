
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
  wire   VALID_R, nReadOrWrite, State_0_, StateIsREAD, StateIsWAIT_RESP,
         nReadOrWrite_R, ConsecutiveRead, FirstREADCycle, Size_R_1_, Size_R_0_,
         n_3225, BurstLen_3_, BurstLen_2_, BurstLen_1_, Addr_R300_31_,
         Addr_R300_30_, Addr_R300_29_, Addr_R300_28_, Addr_R300_27_,
         Addr_R300_26_, Addr_R300_25_, Addr_R300_24_, Addr_R300_23_,
         Addr_R300_22_, Addr_R300_21_, Addr_R300_20_, Addr_R300_19_,
         Addr_R300_18_, Addr_R300_17_, Addr_R300_16_, Addr_R300_15_,
         Addr_R300_14_, Addr_R300_13_, Addr_R300_12_, Addr_R300_11_,
         Addr_R300_10_, Addr_R300_9_, Addr_R300_8_, Addr_R300_7_, Addr_R300_6_,
         Addr_R300_5_, Addr_R300_4_, Addr_R300_3_, Addr_R300_2_, Addr_R300_1_,
         Addr_R300_0_, Len_R306_3_, Len_R306_2_, Len_R306_1_, Len_R306_0_,
         Size_R312_1_, Size_R312_0_, Burst_R318_1_, Burst_R318_0_, ID_R324_3_,
         ID_R324_2_, ID_R324_1_, ID_R324_0_, nReadOrWrite_R330, n333,
         FirstREADCycle394, BID655_3_, BID655_2_, BID655_1_, BID655_0_,
         n659_0_, Len821_3_, Len821_2_, Len821_1_, Len821_0_, n1234, n1235,
         n1236, n1237, n1238, n1239, n1240, n1241, n1242, n1243, n1244, n1245,
         n1246, n1247, n1248, n1249, n1250, n1251, n1252, n1253, n1254, n1255,
         n1256, n1257, n1258, n1259, n1260, n1261, n1262, n1263, n1264, n1265,
         n1266, n1267, n1268, n1269, n1270, n1271, n1272, n1273, n1274, n1275,
         n1276, n1277, n1278, n1279, n1280, n1281, n1282, n1283, n1284, n1285,
         n1286, n1287, n1288, n1289, n1290, n1291, n1292, n1293, n1294, n1295,
         n1296, n1297, n1298, n1299, n1300, n1301, n1302, n1303, n1304, n1305,
         n1306, n1307, n1308, n1309, n1310, n1311, n1312, n1313, n1314, n1315,
         n1316, n1317, n1318, n1319, n1320, n1321, n1322, n1323, n1324, n1325,
         n1326, n1327, n1328, n1329, n1330, n1331, n1332, n1333, n1334, n1335,
         n1336, n1337, n1338, n1339, n1340, n1341, n1342, n1343, n1344, n1345,
         n1346, n1347, n1348, n1349, n1350, n1351, n1352, n1353, n1354, n1355,
         n1356, n1357, n1358, n1359, n1360, n1361, n1362, n1363, n1364, n1365,
         n1366, n1367, n1368, n1369, n1370, n1371, n1372, n1373, n1374, n1375,
         n1376, n1377, n1378, n1379, n1380, n1381, n1382, n1383, n1384, n1385,
         n1386, n1387, n1388, n1389, n1390, n1391, n1392, n1393, n1394, n1395,
         n1396, n1397, n1398, n1399, n1400, n1401, n1402, n1403, n1404, n1405,
         n1406, n1407, n1408, n1409, n1410, n1411, n1412, n1413, n1414, n1415,
         n1416, n1417, n1418, n1419, n1420, n1421, n1422, n1423, n1424, n1425,
         n1426, n1427, n1428, n1429, n1430, n1431, n1432, n1433, n1434, n1435,
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
         n1606, n1607, n1608, n1641, n1674, n1675, n1676, n1677, n1678, n1679,
         n1680, n1681, n1682, n1683, n1684, n1685, n1686, n1687, n1688, n1689,
         n1690, n1691, n1692, n1693, n1694, n1695, n1696, n1697, n1698, n1699,
         n1700, n1701, n1702, n1703, n1704, n1705, n1706, n1707, n1708, n1709,
         n1710, n1711, n1712, n1713, n1714, n1715, n1716, n1717, n1718, n1719,
         n1720, n1721, n1722, n1723, n1724, n1725, n1726, n1727, n1728, n1729,
         n1730, n1731, n1732, n1733, n1734, n1735, n1736, n1737, n1738, n1739,
         carry_11_, carry_10_, carry_9_, carry_8_, carry_7_, carry_6_,
         carry_5_, carry_4_, carry_3_, carry_2_, carry_1_, n1, n2, n3, n4, n5,
         n6, n7, n8, n9, n10, n11;
  wire   [3:0] NextState;
  wire   [3:0] Len;
  wire   [3:0] Len_R;
  wire   [1:0] Burst_R;
  wire   [3:0] ID_R;
  wire   [31:0] Addr_R;
  wire   [1:0] Burst;
  wire   [11:0] IncreasedAddr;
  wire   [31:0] Addr;
  wire   [1:0] Size;
  wire   [2:0] IncrSize;
  assign RRESP[0] = 1'b0;
  assign RRESP[1] = 1'b0;
  assign BRESP[0] = 1'b0;
  assign BRESP[1] = 1'b0;

  OAI22X4 U494 ( .A0(n1731), .A1(n1269), .B0(n1711), .B1(n1257), .Y(
        MEMADDR[23]) );
  XOR2X4 U496 ( .A(n1271), .B(nReadOrWrite), .Y(n1550) );
  OAI222X4 U497 ( .A0(n1272), .A1(n1273), .B0(nReadOrWrite), .B1(n1274), .C0(
        n1275), .C1(n1276), .Y(n1271) );
  AND2X4 U498 ( .A(n1274), .B(n1272), .Y(n1276) );
  OAI2BB1X4 U499 ( .A0N(nReadOrWrite_R), .A1N(n1585), .B0(n1278), .Y(
        nReadOrWrite_R330) );
  OAI2BB1X4 U500 ( .A0N(n1279), .A1N(n1280), .B0(n1676), .Y(n659_0_) );
  OAI2BB1X4 U501 ( .A0N(n1281), .A1N(n1282), .B0(n1679), .Y(n333) );
  OR2X4 U502 ( .A(n1275), .B(n1281), .Y(n1549) );
  OAI22X4 U503 ( .A0(n1273), .A1(n1274), .B0(nReadOrWrite), .B1(n1272), .Y(
        n1281) );
  INVX8 U504 ( .A(ARVALID), .Y(n1272) );
  INVX8 U505 ( .A(AWVALID), .Y(n1274) );
  INVX8 U506 ( .A(n1282), .Y(n1275) );
  OAI22X4 U507 ( .A0(n1283), .A1(n1284), .B0(n1285), .B1(n1286), .Y(n1537) );
  INVX8 U508 ( .A(Size_R_1_), .Y(n1284) );
  OAI22X4 U509 ( .A0(n1283), .A1(n1287), .B0(n1285), .B1(n1288), .Y(n1538) );
  INVX8 U510 ( .A(Size_R_0_), .Y(n1287) );
  INVX8 U511 ( .A(n1289), .Y(Size_R312_1_) );
  AOI222X4 U512 ( .A0(AWSIZE[1]), .A1(n1603), .B0(ARSIZE[1]), .B1(n1597), .C0(
        Size_R_1_), .C1(n1586), .Y(n1289) );
  INVX8 U513 ( .A(n1292), .Y(Size_R312_0_) );
  AOI222X4 U514 ( .A0(AWSIZE[0]), .A1(n1603), .B0(ARSIZE[0]), .B1(n1597), .C0(
        Size_R_0_), .C1(n1585), .Y(n1292) );
  OAI22X4 U515 ( .A0(BREADY), .A1(n1293), .B0(n1294), .B1(n1280), .Y(
        NextState[3]) );
  INVX8 U516 ( .A(StateIsWAIT_RESP), .Y(n1293) );
  OAI222X4 U517 ( .A0(WLAST), .A1(n1295), .B0(WVALID), .B1(n1295), .C0(n1296), 
        .C1(n1297), .Y(NextState[2]) );
  OR2X4 U518 ( .A(n1298), .B(n1299), .Y(n1297) );
  AOI211X4 U519 ( .A0(WREADY), .A1(n1280), .B0(n1300), .C0(State_0_), .Y(n1296) );
  OAI221X4 U520 ( .A0(VALID_R), .A1(n1301), .B0(VALID_R), .B1(n1302), .C0(
        n1303), .Y(NextState[0]) );
  AOI22X4 U521 ( .A0(n1300), .A1(n1298), .B0(BREADY), .B1(StateIsWAIT_RESP), 
        .Y(n1303) );
  NAND2X4 U522 ( .A(WSTRB[3]), .B(n1304), .Y(MEMWEn[3]) );
  NAND2X4 U523 ( .A(WSTRB[2]), .B(n1304), .Y(MEMWEn[2]) );
  NAND2X4 U524 ( .A(WSTRB[1]), .B(n1304), .Y(MEMWEn[1]) );
  NAND2X4 U525 ( .A(WSTRB[0]), .B(n1304), .Y(MEMWEn[0]) );
  INVX8 U526 ( .A(n1305), .Y(n1304) );
  AND2X4 U527 ( .A(n1306), .B(n1295), .Y(MEMCEn) );
  OAI22X4 U528 ( .A0(n1732), .A1(n1307), .B0(n1712), .B1(n1243), .Y(MEMADDR[9]) );
  OAI22X4 U529 ( .A0(n1731), .A1(n1308), .B0(n1713), .B1(n1242), .Y(MEMADDR[8]) );
  OAI22X4 U530 ( .A0(n1732), .A1(n1309), .B0(n1714), .B1(n1241), .Y(MEMADDR[7]) );
  OAI22X4 U531 ( .A0(n1731), .A1(n1310), .B0(n1717), .B1(n1240), .Y(MEMADDR[6]) );
  OAI22X4 U532 ( .A0(n1732), .A1(n1311), .B0(n1718), .B1(n1239), .Y(MEMADDR[5]) );
  OAI22X4 U533 ( .A0(n1731), .A1(n1312), .B0(n1719), .B1(n1238), .Y(MEMADDR[4]) );
  OAI22X4 U534 ( .A0(n1732), .A1(n1313), .B0(n1720), .B1(n1237), .Y(MEMADDR[3]) );
  OAI22X4 U535 ( .A0(n1731), .A1(n1314), .B0(n1721), .B1(n1236), .Y(MEMADDR[2]) );
  OAI22X4 U536 ( .A0(n1732), .A1(n1315), .B0(n1722), .B1(n1263), .Y(
        MEMADDR[29]) );
  OAI22X4 U537 ( .A0(n1731), .A1(n1316), .B0(n1725), .B1(n1262), .Y(
        MEMADDR[28]) );
  OAI22X4 U538 ( .A0(n1732), .A1(n1317), .B0(n1726), .B1(n1261), .Y(
        MEMADDR[27]) );
  OAI22X4 U539 ( .A0(n1731), .A1(n1318), .B0(n1709), .B1(n1260), .Y(
        MEMADDR[26]) );
  OAI22X4 U540 ( .A0(n1732), .A1(n1319), .B0(n1719), .B1(n1259), .Y(
        MEMADDR[25]) );
  OAI22X4 U541 ( .A0(n1731), .A1(n1320), .B0(n1720), .B1(n1258), .Y(
        MEMADDR[24]) );
  OAI22X4 U542 ( .A0(n1732), .A1(n1321), .B0(n1721), .B1(n1256), .Y(
        MEMADDR[22]) );
  OAI22X4 U543 ( .A0(n1731), .A1(n1322), .B0(n1722), .B1(n1255), .Y(
        MEMADDR[21]) );
  OAI22X4 U544 ( .A0(n1732), .A1(n1323), .B0(n1725), .B1(n1254), .Y(
        MEMADDR[20]) );
  OAI22X4 U545 ( .A0(n1731), .A1(n1324), .B0(n1727), .B1(n1235), .Y(MEMADDR[1]) );
  OAI22X4 U546 ( .A0(n1732), .A1(n1325), .B0(n1728), .B1(n1253), .Y(
        MEMADDR[19]) );
  OAI22X4 U547 ( .A0(n1731), .A1(n1326), .B0(n1729), .B1(n1252), .Y(
        MEMADDR[18]) );
  OAI22X4 U548 ( .A0(n1732), .A1(n1327), .B0(n1730), .B1(n1251), .Y(
        MEMADDR[17]) );
  OAI22X4 U549 ( .A0(n1731), .A1(n1328), .B0(n1709), .B1(n1250), .Y(
        MEMADDR[16]) );
  OAI22X4 U550 ( .A0(n1732), .A1(n1329), .B0(n1710), .B1(n1249), .Y(
        MEMADDR[15]) );
  OAI22X4 U551 ( .A0(n1731), .A1(n1330), .B0(n1711), .B1(n1248), .Y(
        MEMADDR[14]) );
  OAI22X4 U552 ( .A0(n1732), .A1(n1331), .B0(n1712), .B1(n1247), .Y(
        MEMADDR[13]) );
  OAI22X4 U553 ( .A0(n1731), .A1(n1332), .B0(n1713), .B1(n1246), .Y(
        MEMADDR[12]) );
  OAI22X4 U554 ( .A0(n1732), .A1(n1333), .B0(n1714), .B1(n1245), .Y(
        MEMADDR[11]) );
  OAI22X4 U555 ( .A0(n1731), .A1(n1334), .B0(n1717), .B1(n1244), .Y(
        MEMADDR[10]) );
  OAI22X4 U556 ( .A0(n1732), .A1(n1335), .B0(n1718), .B1(n1234), .Y(MEMADDR[0]) );
  INVX8 U557 ( .A(n1710), .Y(n1268) );
  OR3X4 U558 ( .A(WREADY), .B(n1641), .C(FirstREADCycle), .Y(n1270) );
  OAI222X4 U559 ( .A0(n1336), .A1(n1337), .B0(n1338), .B1(n1339), .C0(n1340), 
        .C1(n1341), .Y(n1545) );
  INVX8 U560 ( .A(Len821_3_), .Y(n1341) );
  INVX8 U561 ( .A(Len[3]), .Y(n1339) );
  OAI222X4 U562 ( .A0(n1336), .A1(n1342), .B0(n1338), .B1(n1343), .C0(n1340), 
        .C1(n1344), .Y(n1546) );
  INVX8 U563 ( .A(Len821_2_), .Y(n1344) );
  INVX8 U564 ( .A(Len[2]), .Y(n1343) );
  OAI222X4 U565 ( .A0(n1336), .A1(n1345), .B0(n1338), .B1(n1346), .C0(n1340), 
        .C1(n1347), .Y(n1547) );
  INVX8 U566 ( .A(Len821_1_), .Y(n1347) );
  INVX8 U567 ( .A(Len[1]), .Y(n1346) );
  OAI222X4 U568 ( .A0(n1336), .A1(n1348), .B0(n1349), .B1(n1338), .C0(n1340), 
        .C1(n1350), .Y(n1548) );
  INVX8 U569 ( .A(Len821_0_), .Y(n1350) );
  OR2X4 U570 ( .A(n1351), .B(n1352), .Y(n1340) );
  INVX8 U571 ( .A(n1338), .Y(n1352) );
  OAI31X4 U572 ( .A0(n1353), .A1(RLAST), .A2(n1354), .B0(n1336), .Y(n1338) );
  INVX8 U573 ( .A(Len_R[0]), .Y(n1348) );
  INVX8 U574 ( .A(n1355), .Y(Len_R306_3_) );
  AOI222X4 U575 ( .A0(AWLEN[3]), .A1(n1603), .B0(ARLEN[3]), .B1(n1597), .C0(
        Len_R[3]), .C1(n1585), .Y(n1355) );
  INVX8 U576 ( .A(n1356), .Y(Len_R306_2_) );
  AOI222X4 U577 ( .A0(AWLEN[2]), .A1(n1603), .B0(ARLEN[2]), .B1(n1597), .C0(
        Len_R[2]), .C1(n1585), .Y(n1356) );
  INVX8 U578 ( .A(n1357), .Y(Len_R306_1_) );
  AOI222X4 U579 ( .A0(AWLEN[1]), .A1(n1603), .B0(ARLEN[1]), .B1(n1597), .C0(
        Len_R[1]), .C1(n1585), .Y(n1357) );
  INVX8 U580 ( .A(n1358), .Y(Len_R306_0_) );
  AOI222X4 U581 ( .A0(AWLEN[0]), .A1(n1603), .B0(ARLEN[0]), .B1(n1597), .C0(
        Len_R[0]), .C1(n1585), .Y(n1358) );
  AND2X4 U582 ( .A(Size[1]), .B(n1288), .Y(IncrSize[2]) );
  AND2X4 U583 ( .A(Size[0]), .B(n1286), .Y(IncrSize[1]) );
  OAI22X4 U584 ( .A0(n1336), .A1(n1359), .B0(n1351), .B1(n1360), .Y(n1541) );
  INVX8 U585 ( .A(ID_R[3]), .Y(n1359) );
  OAI22X4 U586 ( .A0(n1336), .A1(n1361), .B0(n1351), .B1(n1362), .Y(n1542) );
  INVX8 U587 ( .A(ID_R[2]), .Y(n1361) );
  OAI22X4 U588 ( .A0(n1336), .A1(n1363), .B0(n1351), .B1(n1364), .Y(n1543) );
  INVX8 U589 ( .A(ID_R[1]), .Y(n1363) );
  OAI22X4 U590 ( .A0(n1336), .A1(n1365), .B0(n1351), .B1(n1366), .Y(n1544) );
  INVX8 U591 ( .A(ID_R[0]), .Y(n1365) );
  INVX8 U592 ( .A(n1367), .Y(ID_R324_3_) );
  AOI222X4 U593 ( .A0(AWID[3]), .A1(n1603), .B0(ARID[3]), .B1(n1597), .C0(
        ID_R[3]), .C1(n1585), .Y(n1367) );
  INVX8 U594 ( .A(n1368), .Y(ID_R324_2_) );
  AOI222X4 U595 ( .A0(AWID[2]), .A1(n1603), .B0(ARID[2]), .B1(n1597), .C0(
        ID_R[2]), .C1(n1586), .Y(n1368) );
  INVX8 U596 ( .A(n1369), .Y(ID_R324_1_) );
  AOI222X4 U597 ( .A0(AWID[1]), .A1(n1603), .B0(ARID[1]), .B1(n1597), .C0(
        ID_R[1]), .C1(n1585), .Y(n1369) );
  INVX8 U598 ( .A(n1370), .Y(ID_R324_0_) );
  AOI222X4 U599 ( .A0(AWID[0]), .A1(n1603), .B0(ARID[0]), .B1(n1597), .C0(
        ID_R[0]), .C1(n1585), .Y(n1370) );
  AND2X4 U600 ( .A(NextState[1]), .B(n1306), .Y(FirstREADCycle394) );
  OAI32X4 U601 ( .A0(n1301), .A1(nReadOrWrite_R), .A2(n1299), .B0(n1300), .B1(
        n1306), .Y(NextState[1]) );
  INVX8 U602 ( .A(n1302), .Y(n1300) );
  OR4X4 U603 ( .A(ConsecutiveRead), .B(n1354), .C(n1353), .D(n1371), .Y(n1302)
         );
  INVX8 U604 ( .A(n1372), .Y(n1301) );
  OAI2BB1X4 U605 ( .A0N(n1373), .A1N(n1280), .B0(n1374), .Y(n1372) );
  INVX8 U606 ( .A(State_0_), .Y(n1374) );
  OAI22X4 U607 ( .A0(n_3225), .A1(n1375), .B0(n1376), .B1(n1703), .Y(n1584) );
  OAI22X4 U608 ( .A0(n1283), .A1(n1378), .B0(n1285), .B1(n1379), .Y(n1539) );
  INVX8 U609 ( .A(Burst_R[1]), .Y(n1378) );
  OAI22X4 U610 ( .A0(n1283), .A1(n1380), .B0(n1285), .B1(n1381), .Y(n1540) );
  INVX8 U611 ( .A(Burst_R[0]), .Y(n1380) );
  INVX8 U612 ( .A(n1382), .Y(Burst_R318_1_) );
  AOI222X4 U613 ( .A0(AWBURST[1]), .A1(n1603), .B0(ARBURST[1]), .B1(n1597), 
        .C0(Burst_R[1]), .C1(n1586), .Y(n1382) );
  INVX8 U614 ( .A(n1383), .Y(Burst_R318_0_) );
  AOI222X4 U615 ( .A0(AWBURST[0]), .A1(n1603), .B0(ARBURST[0]), .B1(n1597), 
        .C0(Burst_R[0]), .C1(n1586), .Y(n1383) );
  OAI22X4 U616 ( .A0(n1283), .A1(n1337), .B0(n1285), .B1(n1384), .Y(n1534) );
  INVX8 U617 ( .A(Len_R[3]), .Y(n1337) );
  OAI22X4 U618 ( .A0(n1283), .A1(n1342), .B0(n1285), .B1(n1385), .Y(n1535) );
  INVX8 U619 ( .A(Len_R[2]), .Y(n1342) );
  OAI22X4 U620 ( .A0(n1283), .A1(n1345), .B0(n1285), .B1(n1386), .Y(n1536) );
  INVX8 U621 ( .A(Len_R[1]), .Y(n1345) );
  INVX8 U622 ( .A(n1285), .Y(n1283) );
  OR2X4 U623 ( .A(n1351), .B(n1387), .Y(n1285) );
  OR2X4 U624 ( .A(n1388), .B(n1279), .Y(n1551) );
  OR2X4 U625 ( .A(n1373), .B(StateIsWAIT_RESP), .Y(n1279) );
  INVX8 U626 ( .A(n1280), .Y(n1388) );
  OAI22X4 U627 ( .A0(n1585), .A1(n1360), .B0(n1675), .B1(n1267), .Y(BID655_3_)
         );
  INVX8 U628 ( .A(RID[3]), .Y(n1360) );
  OAI22X4 U629 ( .A0(n1585), .A1(n1362), .B0(n1678), .B1(n1266), .Y(BID655_2_)
         );
  INVX8 U630 ( .A(RID[2]), .Y(n1362) );
  OAI22X4 U631 ( .A0(n1585), .A1(n1364), .B0(n1677), .B1(n1265), .Y(BID655_1_)
         );
  INVX8 U632 ( .A(RID[1]), .Y(n1364) );
  OAI22X4 U633 ( .A0(n1585), .A1(n1366), .B0(n1676), .B1(n1264), .Y(BID655_0_)
         );
  INVX8 U634 ( .A(RID[0]), .Y(n1366) );
  OAI221X4 U635 ( .A0(n1389), .A1(n1390), .B0(n1391), .B1(n1309), .C0(n1392), 
        .Y(n1574) );
  NAND2X4 U636 ( .A(IncreasedAddr[9]), .B(n1393), .Y(n1392) );
  INVX8 U637 ( .A(Addr[9]), .Y(n1309) );
  INVX8 U638 ( .A(Addr_R[9]), .Y(n1390) );
  OAI221X4 U639 ( .A0(n1389), .A1(n1394), .B0(n1391), .B1(n1310), .C0(n1395), 
        .Y(n1575) );
  NAND2X4 U640 ( .A(IncreasedAddr[8]), .B(n1393), .Y(n1395) );
  INVX8 U641 ( .A(Addr[8]), .Y(n1310) );
  INVX8 U642 ( .A(Addr_R[8]), .Y(n1394) );
  OAI221X4 U643 ( .A0(n1389), .A1(n1396), .B0(n1391), .B1(n1311), .C0(n1397), 
        .Y(n1576) );
  NAND2X4 U644 ( .A(IncreasedAddr[7]), .B(n1393), .Y(n1397) );
  INVX8 U645 ( .A(Addr[7]), .Y(n1311) );
  INVX8 U646 ( .A(Addr_R[7]), .Y(n1396) );
  OAI222X4 U647 ( .A0(n1312), .A1(n1398), .B0(n1399), .B1(n1400), .C0(n1401), 
        .C1(n1402), .Y(n1577) );
  INVX8 U648 ( .A(Addr_R[6]), .Y(n1402) );
  OAI211X4 U649 ( .A0(n1403), .A1(n1404), .B0(n1405), .C0(n1406), .Y(n1400) );
  OAI32X4 U650 ( .A0(n1407), .A1(Burst[0]), .A2(n1312), .B0(n1312), .B1(n1408), 
        .Y(n1404) );
  AND2X4 U651 ( .A(n1409), .B(BurstLen_3_), .Y(n1407) );
  INVX8 U652 ( .A(n1410), .Y(n1409) );
  OAI33X4 U653 ( .A0(n1381), .A1(Burst[1]), .A2(n1411), .B0(n1412), .B1(n1410), 
        .B2(n1411), .Y(n1403) );
  OR3X4 U654 ( .A(Burst[0]), .B(n1379), .C(n1384), .Y(n1412) );
  INVX8 U655 ( .A(IncreasedAddr[6]), .Y(n1411) );
  INVX8 U656 ( .A(Addr[6]), .Y(n1312) );
  OAI211X4 U657 ( .A0(n1413), .A1(n1313), .B0(n1414), .C0(n1415), .Y(n1578) );
  OAI211X4 U658 ( .A0(n1416), .A1(n1417), .B0(IncreasedAddr[5]), .C0(n1398), 
        .Y(n1415) );
  AND2X4 U659 ( .A(n1418), .B(n1419), .Y(n1416) );
  AOI32X4 U660 ( .A0(n1420), .A1(Addr[5]), .A2(n1421), .B0(Addr_R[5]), .B1(
        n1422), .Y(n1414) );
  INVX8 U661 ( .A(n1419), .Y(n1420) );
  OAI22X4 U662 ( .A0(n1286), .A1(n1384), .B0(n1385), .B1(n1410), .Y(n1419) );
  INVX8 U663 ( .A(Addr[5]), .Y(n1313) );
  OAI211X4 U664 ( .A0(n1413), .A1(n1314), .B0(n1423), .C0(n1424), .Y(n1579) );
  OAI211X4 U665 ( .A0(n1425), .A1(n1417), .B0(IncreasedAddr[4]), .C0(n1398), 
        .Y(n1424) );
  AND2X4 U666 ( .A(n1418), .B(n1426), .Y(n1425) );
  AOI32X4 U667 ( .A0(n1427), .A1(Addr[4]), .A2(n1421), .B0(Addr_R[4]), .B1(
        n1422), .Y(n1423) );
  INVX8 U668 ( .A(n1426), .Y(n1427) );
  OAI22X4 U669 ( .A0(IncrSize[0]), .A1(n1384), .B0(n1428), .B1(n1286), .Y(
        n1426) );
  INVX8 U670 ( .A(n1429), .Y(n1428) );
  INVX8 U671 ( .A(Addr[4]), .Y(n1314) );
  OAI211X4 U672 ( .A0(n1413), .A1(n1324), .B0(n1430), .C0(n1431), .Y(n1580) );
  OAI211X4 U673 ( .A0(n1432), .A1(n1417), .B0(IncreasedAddr[3]), .C0(n1398), 
        .Y(n1431) );
  AND2X4 U674 ( .A(n1418), .B(n1433), .Y(n1432) );
  AOI32X4 U675 ( .A0(n1434), .A1(Addr[3]), .A2(n1421), .B0(Addr_R[3]), .B1(
        n1422), .Y(n1430) );
  INVX8 U676 ( .A(n1433), .Y(n1434) );
  OAI221X4 U677 ( .A0(IncrSize[0]), .A1(n1385), .B0(n1286), .B1(n1386), .C0(
        n1435), .Y(n1433) );
  AND2X4 U678 ( .A(n1410), .B(n1384), .Y(n1435) );
  INVX8 U679 ( .A(BurstLen_3_), .Y(n1384) );
  OR2X4 U680 ( .A(n1286), .B(n1288), .Y(n1410) );
  INVX8 U681 ( .A(Size[0]), .Y(n1288) );
  INVX8 U682 ( .A(BurstLen_1_), .Y(n1386) );
  INVX8 U683 ( .A(Size[1]), .Y(n1286) );
  INVX8 U684 ( .A(n1436), .Y(IncrSize[0]) );
  INVX8 U685 ( .A(Addr[3]), .Y(n1324) );
  OAI22X4 U686 ( .A0(n1704), .A1(n1437), .B0(n1315), .B1(n1689), .Y(n1552) );
  INVX8 U687 ( .A(Addr[31]), .Y(n1315) );
  INVX8 U688 ( .A(Addr_R[31]), .Y(n1437) );
  OAI22X4 U689 ( .A0(n1703), .A1(n1439), .B0(n1316), .B1(n1690), .Y(n1553) );
  INVX8 U690 ( .A(Addr[30]), .Y(n1316) );
  INVX8 U691 ( .A(Addr_R[30]), .Y(n1439) );
  OAI211X4 U692 ( .A0(n1413), .A1(n1335), .B0(n1440), .C0(n1441), .Y(n1581) );
  OAI211X4 U693 ( .A0(n1442), .A1(n1417), .B0(IncreasedAddr[2]), .C0(n1398), 
        .Y(n1441) );
  AND2X4 U694 ( .A(n1418), .B(n1443), .Y(n1442) );
  AOI32X4 U695 ( .A0(n1444), .A1(Addr[2]), .A2(n1421), .B0(Addr_R[2]), .B1(
        n1422), .Y(n1440) );
  INVX8 U696 ( .A(n1443), .Y(n1444) );
  OR3X4 U697 ( .A(Size[1]), .B(BurstLen_3_), .C(n1429), .Y(n1443) );
  OAI2BB1X4 U698 ( .A0N(BurstLen_1_), .A1N(Size[0]), .B0(n1385), .Y(n1429) );
  INVX8 U699 ( .A(BurstLen_2_), .Y(n1385) );
  INVX8 U700 ( .A(Addr[2]), .Y(n1335) );
  OAI22X4 U701 ( .A0(n1704), .A1(n1445), .B0(n1317), .B1(n1693), .Y(n1554) );
  INVX8 U702 ( .A(Addr[29]), .Y(n1317) );
  INVX8 U703 ( .A(Addr_R[29]), .Y(n1445) );
  OAI22X4 U704 ( .A0(n1703), .A1(n1446), .B0(n1318), .B1(n1694), .Y(n1555) );
  INVX8 U705 ( .A(Addr[28]), .Y(n1318) );
  INVX8 U706 ( .A(Addr_R[28]), .Y(n1446) );
  OAI22X4 U707 ( .A0(n1704), .A1(n1447), .B0(n1319), .B1(n1695), .Y(n1556) );
  INVX8 U708 ( .A(Addr[27]), .Y(n1319) );
  INVX8 U709 ( .A(Addr_R[27]), .Y(n1447) );
  OAI22X4 U710 ( .A0(n1703), .A1(n1448), .B0(n1320), .B1(n1696), .Y(n1557) );
  INVX8 U711 ( .A(Addr[26]), .Y(n1320) );
  INVX8 U712 ( .A(Addr_R[26]), .Y(n1448) );
  OAI22X4 U713 ( .A0(n1704), .A1(n1449), .B0(n1269), .B1(n1699), .Y(n1558) );
  INVX8 U714 ( .A(Addr[25]), .Y(n1269) );
  INVX8 U715 ( .A(Addr_R[25]), .Y(n1449) );
  OAI22X4 U716 ( .A0(n1703), .A1(n1450), .B0(n1321), .B1(n1700), .Y(n1559) );
  INVX8 U717 ( .A(Addr[24]), .Y(n1321) );
  INVX8 U718 ( .A(Addr_R[24]), .Y(n1450) );
  OAI22X4 U719 ( .A0(n1704), .A1(n1451), .B0(n1322), .B1(n1687), .Y(n1560) );
  INVX8 U720 ( .A(Addr[23]), .Y(n1322) );
  INVX8 U721 ( .A(Addr_R[23]), .Y(n1451) );
  OAI22X4 U722 ( .A0(n1703), .A1(n1452), .B0(n1323), .B1(n1695), .Y(n1561) );
  INVX8 U723 ( .A(Addr[22]), .Y(n1323) );
  INVX8 U724 ( .A(Addr_R[22]), .Y(n1452) );
  OAI22X4 U725 ( .A0(n1703), .A1(n1453), .B0(n1325), .B1(n1696), .Y(n1562) );
  INVX8 U726 ( .A(Addr[21]), .Y(n1325) );
  INVX8 U727 ( .A(Addr_R[21]), .Y(n1453) );
  OAI22X4 U728 ( .A0(n1703), .A1(n1454), .B0(n1326), .B1(n1699), .Y(n1563) );
  INVX8 U729 ( .A(Addr[20]), .Y(n1326) );
  INVX8 U730 ( .A(Addr_R[20]), .Y(n1454) );
  OAI211X4 U731 ( .A0(n1413), .A1(n1455), .B0(n1456), .C0(n1457), .Y(n1582) );
  OAI211X4 U732 ( .A0(n1458), .A1(n1417), .B0(IncreasedAddr[1]), .C0(n1398), 
        .Y(n1457) );
  INVX8 U733 ( .A(n1459), .Y(n1417) );
  AND2X4 U734 ( .A(n1418), .B(n1460), .Y(n1458) );
  INVX8 U735 ( .A(n1461), .Y(n1418) );
  OR2X4 U736 ( .A(n1379), .B(n1462), .Y(n1461) );
  AOI32X4 U737 ( .A0(n1463), .A1(Addr[1]), .A2(n1421), .B0(Addr_R[1]), .B1(
        n1422), .Y(n1456) );
  INVX8 U738 ( .A(n1462), .Y(n1421) );
  OR2X4 U739 ( .A(Burst[0]), .B(n1464), .Y(n1462) );
  INVX8 U740 ( .A(n1460), .Y(n1463) );
  OR4X4 U741 ( .A(BurstLen_1_), .B(BurstLen_2_), .C(BurstLen_3_), .D(n1436), 
        .Y(n1460) );
  OR2X4 U742 ( .A(Size[0]), .B(Size[1]), .Y(n1436) );
  INVX8 U743 ( .A(Addr[1]), .Y(n1455) );
  INVX8 U744 ( .A(n1465), .Y(n1413) );
  OAI22X4 U745 ( .A0(n1704), .A1(n1466), .B0(n1327), .B1(n1701), .Y(n1564) );
  INVX8 U746 ( .A(Addr[19]), .Y(n1327) );
  INVX8 U747 ( .A(Addr_R[19]), .Y(n1466) );
  OAI22X4 U748 ( .A0(n1703), .A1(n1467), .B0(n1328), .B1(n1702), .Y(n1565) );
  INVX8 U749 ( .A(Addr[18]), .Y(n1328) );
  INVX8 U750 ( .A(Addr_R[18]), .Y(n1467) );
  OAI22X4 U751 ( .A0(n1704), .A1(n1468), .B0(n1329), .B1(n1687), .Y(n1566) );
  INVX8 U752 ( .A(Addr[17]), .Y(n1329) );
  INVX8 U753 ( .A(Addr_R[17]), .Y(n1468) );
  OAI22X4 U754 ( .A0(n1703), .A1(n1469), .B0(n1330), .B1(n1688), .Y(n1567) );
  INVX8 U755 ( .A(Addr[16]), .Y(n1330) );
  INVX8 U756 ( .A(Addr_R[16]), .Y(n1469) );
  OAI22X4 U757 ( .A0(n1704), .A1(n1470), .B0(n1331), .B1(n1689), .Y(n1568) );
  INVX8 U758 ( .A(Addr[15]), .Y(n1331) );
  INVX8 U759 ( .A(Addr_R[15]), .Y(n1470) );
  OAI22X4 U760 ( .A0(n1703), .A1(n1471), .B0(n1332), .B1(n1690), .Y(n1569) );
  INVX8 U761 ( .A(Addr[14]), .Y(n1332) );
  INVX8 U762 ( .A(Addr_R[14]), .Y(n1471) );
  OAI22X4 U763 ( .A0(n1704), .A1(n1472), .B0(n1333), .B1(n1693), .Y(n1570) );
  INVX8 U764 ( .A(Addr[13]), .Y(n1333) );
  INVX8 U765 ( .A(Addr_R[13]), .Y(n1472) );
  OAI22X4 U766 ( .A0(n1704), .A1(n1473), .B0(n1334), .B1(n1694), .Y(n1571) );
  INVX8 U767 ( .A(Addr[12]), .Y(n1334) );
  INVX8 U768 ( .A(Addr_R[12]), .Y(n1473) );
  OAI221X4 U769 ( .A0(n1389), .A1(n1474), .B0(n1391), .B1(n1307), .C0(n1475), 
        .Y(n1572) );
  NAND2X4 U770 ( .A(IncreasedAddr[11]), .B(n1393), .Y(n1475) );
  INVX8 U771 ( .A(Addr[11]), .Y(n1307) );
  INVX8 U772 ( .A(Addr_R[11]), .Y(n1474) );
  OAI221X4 U773 ( .A0(n1389), .A1(n1476), .B0(n1391), .B1(n1308), .C0(n1477), 
        .Y(n1573) );
  NAND2X4 U774 ( .A(IncreasedAddr[10]), .B(n1393), .Y(n1477) );
  INVX8 U775 ( .A(n1478), .Y(n1393) );
  OR2X4 U776 ( .A(n1479), .B(n1459), .Y(n1478) );
  OR3X4 U777 ( .A(Burst[1]), .B(n1381), .C(n1464), .Y(n1459) );
  INVX8 U778 ( .A(Addr[10]), .Y(n1308) );
  INVX8 U779 ( .A(n1480), .Y(n1391) );
  OR2X4 U780 ( .A(n1479), .B(n1481), .Y(n1480) );
  INVX8 U781 ( .A(Addr_R[10]), .Y(n1476) );
  OR2X4 U782 ( .A(n1482), .B(n1479), .Y(n1389) );
  INVX8 U783 ( .A(n1483), .Y(n1479) );
  OAI2BB1X4 U784 ( .A0N(n1681), .A1N(n1379), .B0(n1704), .Y(n1483) );
  INVX8 U785 ( .A(n1688), .Y(n1377) );
  OAI2BB1X4 U786 ( .A0N(n1387), .A1N(n1681), .B0(n1406), .Y(n1438) );
  INVX8 U787 ( .A(Burst[1]), .Y(n1379) );
  OAI2BB1X4 U788 ( .A0N(Addr[0]), .A1N(n1465), .B0(n1484), .Y(n1583) );
  AOI32X4 U789 ( .A0(IncreasedAddr[0]), .A1(n1482), .A2(n1485), .B0(Addr_R[0]), 
        .B1(n1422), .Y(n1484) );
  INVX8 U790 ( .A(n1401), .Y(n1422) );
  OR2X4 U791 ( .A(n1482), .B(n1399), .Y(n1401) );
  AND2X4 U792 ( .A(n1408), .B(n1398), .Y(n1485) );
  INVX8 U793 ( .A(n1464), .Y(n1482) );
  OR2X4 U794 ( .A(n1399), .B(n1481), .Y(n1465) );
  INVX8 U795 ( .A(n1486), .Y(n1481) );
  OR2X4 U796 ( .A(n1464), .B(n1408), .Y(n1486) );
  INVX8 U797 ( .A(n1487), .Y(n1408) );
  XOR2X4 U798 ( .A(n1381), .B(Burst[1]), .Y(n1487) );
  INVX8 U799 ( .A(Burst[0]), .Y(n1381) );
  OR2X4 U800 ( .A(n1376), .B(n1387), .Y(n1464) );
  INVX8 U801 ( .A(n1405), .Y(n1387) );
  OAI211X4 U802 ( .A0(RVALID), .A1(n1488), .B0(VALID_R), .C0(n1489), .Y(n1405)
         );
  AND2X4 U803 ( .A(n1490), .B(n1298), .Y(n1489) );
  INVX8 U804 ( .A(nReadOrWrite_R), .Y(n1298) );
  OAI31X4 U805 ( .A0(n1491), .A1(Len[1]), .A2(n1349), .B0(n1492), .Y(n1490) );
  INVX8 U806 ( .A(Len[0]), .Y(n1349) );
  OR2X4 U807 ( .A(Len[3]), .B(Len[2]), .Y(n1491) );
  INVX8 U808 ( .A(n1492), .Y(n1488) );
  OR3X4 U809 ( .A(n1306), .B(n1493), .C(n1371), .Y(n1492) );
  INVX8 U810 ( .A(n1398), .Y(n1399) );
  OR2X4 U811 ( .A(n1682), .B(n1376), .Y(n1398) );
  INVX8 U812 ( .A(n1406), .Y(n1376) );
  OR2X4 U813 ( .A(n1336), .B(ConsecutiveRead), .Y(n1406) );
  INVX8 U814 ( .A(n1351), .Y(n1336) );
  OAI221X4 U815 ( .A0(n1375), .A1(n1354), .B0(n1354), .B1(n1306), .C0(n1494), 
        .Y(n_3225) );
  AND2X4 U816 ( .A(n1305), .B(n1493), .Y(n1494) );
  INVX8 U817 ( .A(FirstREADCycle), .Y(n1493) );
  INVX8 U818 ( .A(ConsecutiveRead), .Y(n1375) );
  INVX8 U819 ( .A(n1495), .Y(Addr_R300_9_) );
  AOI222X4 U820 ( .A0(AWADDR[9]), .A1(n1603), .B0(ARADDR[9]), .B1(n1598), .C0(
        Addr_R[9]), .C1(n1586), .Y(n1495) );
  INVX8 U821 ( .A(n1496), .Y(Addr_R300_8_) );
  AOI222X4 U822 ( .A0(AWADDR[8]), .A1(n1604), .B0(ARADDR[8]), .B1(n1598), .C0(
        Addr_R[8]), .C1(n1586), .Y(n1496) );
  INVX8 U823 ( .A(n1497), .Y(Addr_R300_7_) );
  AOI222X4 U824 ( .A0(AWADDR[7]), .A1(n1604), .B0(ARADDR[7]), .B1(n1598), .C0(
        Addr_R[7]), .C1(n1586), .Y(n1497) );
  INVX8 U825 ( .A(n1498), .Y(Addr_R300_6_) );
  AOI222X4 U826 ( .A0(AWADDR[6]), .A1(n1604), .B0(ARADDR[6]), .B1(n1598), .C0(
        Addr_R[6]), .C1(n1586), .Y(n1498) );
  INVX8 U827 ( .A(n1499), .Y(Addr_R300_5_) );
  AOI222X4 U828 ( .A0(AWADDR[5]), .A1(n1604), .B0(ARADDR[5]), .B1(n1598), .C0(
        Addr_R[5]), .C1(n1586), .Y(n1499) );
  INVX8 U829 ( .A(n1500), .Y(Addr_R300_4_) );
  AOI222X4 U830 ( .A0(AWADDR[4]), .A1(n1604), .B0(ARADDR[4]), .B1(n1598), .C0(
        Addr_R[4]), .C1(n1586), .Y(n1500) );
  INVX8 U831 ( .A(n1501), .Y(Addr_R300_3_) );
  AOI222X4 U832 ( .A0(AWADDR[3]), .A1(n1604), .B0(ARADDR[3]), .B1(n1598), .C0(
        Addr_R[3]), .C1(n1586), .Y(n1501) );
  INVX8 U833 ( .A(n1502), .Y(Addr_R300_31_) );
  AOI222X4 U834 ( .A0(AWADDR[31]), .A1(n1604), .B0(ARADDR[31]), .B1(n1598), 
        .C0(Addr_R[31]), .C1(n1586), .Y(n1502) );
  INVX8 U835 ( .A(n1503), .Y(Addr_R300_30_) );
  AOI222X4 U836 ( .A0(AWADDR[30]), .A1(n1604), .B0(ARADDR[30]), .B1(n1598), 
        .C0(Addr_R[30]), .C1(n1586), .Y(n1503) );
  INVX8 U837 ( .A(n1504), .Y(Addr_R300_2_) );
  AOI222X4 U838 ( .A0(AWADDR[2]), .A1(n1604), .B0(ARADDR[2]), .B1(n1598), .C0(
        Addr_R[2]), .C1(n1586), .Y(n1504) );
  INVX8 U839 ( .A(n1505), .Y(Addr_R300_29_) );
  AOI222X4 U840 ( .A0(AWADDR[29]), .A1(n1604), .B0(ARADDR[29]), .B1(n1598), 
        .C0(Addr_R[29]), .C1(n1586), .Y(n1505) );
  INVX8 U841 ( .A(n1506), .Y(Addr_R300_28_) );
  AOI222X4 U842 ( .A0(AWADDR[28]), .A1(n1604), .B0(ARADDR[28]), .B1(n1598), 
        .C0(Addr_R[28]), .C1(n1586), .Y(n1506) );
  INVX8 U843 ( .A(n1507), .Y(Addr_R300_27_) );
  AOI222X4 U844 ( .A0(AWADDR[27]), .A1(n1604), .B0(ARADDR[27]), .B1(n1599), 
        .C0(Addr_R[27]), .C1(n1587), .Y(n1507) );
  INVX8 U845 ( .A(n1508), .Y(Addr_R300_26_) );
  AOI222X4 U846 ( .A0(AWADDR[26]), .A1(n1604), .B0(ARADDR[26]), .B1(n1599), 
        .C0(Addr_R[26]), .C1(n1587), .Y(n1508) );
  INVX8 U847 ( .A(n1509), .Y(Addr_R300_25_) );
  AOI222X4 U848 ( .A0(AWADDR[25]), .A1(n1605), .B0(ARADDR[25]), .B1(n1599), 
        .C0(Addr_R[25]), .C1(n1587), .Y(n1509) );
  INVX8 U849 ( .A(n1510), .Y(Addr_R300_24_) );
  AOI222X4 U850 ( .A0(AWADDR[24]), .A1(n1605), .B0(ARADDR[24]), .B1(n1599), 
        .C0(Addr_R[24]), .C1(n1587), .Y(n1510) );
  INVX8 U851 ( .A(n1511), .Y(Addr_R300_23_) );
  AOI222X4 U852 ( .A0(AWADDR[23]), .A1(n1605), .B0(ARADDR[23]), .B1(n1599), 
        .C0(Addr_R[23]), .C1(n1587), .Y(n1511) );
  INVX8 U853 ( .A(n1512), .Y(Addr_R300_22_) );
  AOI222X4 U854 ( .A0(AWADDR[22]), .A1(n1605), .B0(ARADDR[22]), .B1(n1599), 
        .C0(Addr_R[22]), .C1(n1587), .Y(n1512) );
  INVX8 U855 ( .A(n1513), .Y(Addr_R300_21_) );
  AOI222X4 U856 ( .A0(AWADDR[21]), .A1(n1605), .B0(ARADDR[21]), .B1(n1599), 
        .C0(Addr_R[21]), .C1(n1587), .Y(n1513) );
  INVX8 U857 ( .A(n1514), .Y(Addr_R300_20_) );
  AOI222X4 U858 ( .A0(AWADDR[20]), .A1(n1605), .B0(ARADDR[20]), .B1(n1599), 
        .C0(Addr_R[20]), .C1(n1587), .Y(n1514) );
  INVX8 U859 ( .A(n1515), .Y(Addr_R300_1_) );
  AOI222X4 U860 ( .A0(AWADDR[1]), .A1(n1605), .B0(ARADDR[1]), .B1(n1599), .C0(
        Addr_R[1]), .C1(n1587), .Y(n1515) );
  INVX8 U861 ( .A(n1516), .Y(Addr_R300_19_) );
  AOI222X4 U862 ( .A0(AWADDR[19]), .A1(n1605), .B0(ARADDR[19]), .B1(n1599), 
        .C0(Addr_R[19]), .C1(n1587), .Y(n1516) );
  INVX8 U863 ( .A(n1517), .Y(Addr_R300_18_) );
  AOI222X4 U864 ( .A0(AWADDR[18]), .A1(n1605), .B0(ARADDR[18]), .B1(n1599), 
        .C0(Addr_R[18]), .C1(n1587), .Y(n1517) );
  INVX8 U865 ( .A(n1518), .Y(Addr_R300_17_) );
  AOI222X4 U866 ( .A0(AWADDR[17]), .A1(n1605), .B0(ARADDR[17]), .B1(n1599), 
        .C0(Addr_R[17]), .C1(n1587), .Y(n1518) );
  INVX8 U867 ( .A(n1519), .Y(Addr_R300_16_) );
  AOI222X4 U868 ( .A0(AWADDR[16]), .A1(n1605), .B0(ARADDR[16]), .B1(n1600), 
        .C0(Addr_R[16]), .C1(n1587), .Y(n1519) );
  INVX8 U869 ( .A(n1520), .Y(Addr_R300_15_) );
  AOI222X4 U870 ( .A0(AWADDR[15]), .A1(n1605), .B0(ARADDR[15]), .B1(n1600), 
        .C0(Addr_R[15]), .C1(n1587), .Y(n1520) );
  INVX8 U871 ( .A(n1521), .Y(Addr_R300_14_) );
  AOI222X4 U872 ( .A0(AWADDR[14]), .A1(n1605), .B0(ARADDR[14]), .B1(n1600), 
        .C0(Addr_R[14]), .C1(n1587), .Y(n1521) );
  INVX8 U873 ( .A(n1522), .Y(Addr_R300_13_) );
  AOI222X4 U874 ( .A0(AWADDR[13]), .A1(n1606), .B0(ARADDR[13]), .B1(n1600), 
        .C0(Addr_R[13]), .C1(n1587), .Y(n1522) );
  INVX8 U875 ( .A(n1523), .Y(Addr_R300_12_) );
  AOI222X4 U876 ( .A0(AWADDR[12]), .A1(n1606), .B0(ARADDR[12]), .B1(n1600), 
        .C0(Addr_R[12]), .C1(n1588), .Y(n1523) );
  INVX8 U877 ( .A(n1524), .Y(Addr_R300_11_) );
  AOI222X4 U878 ( .A0(AWADDR[11]), .A1(n1606), .B0(ARADDR[11]), .B1(n1600), 
        .C0(Addr_R[11]), .C1(n1588), .Y(n1524) );
  INVX8 U879 ( .A(n1525), .Y(Addr_R300_10_) );
  AOI222X4 U880 ( .A0(AWADDR[10]), .A1(n1606), .B0(ARADDR[10]), .B1(n1600), 
        .C0(Addr_R[10]), .C1(n1588), .Y(n1525) );
  INVX8 U881 ( .A(n1526), .Y(Addr_R300_0_) );
  AOI222X4 U882 ( .A0(AWADDR[0]), .A1(n1606), .B0(ARADDR[0]), .B1(n1600), .C0(
        Addr_R[0]), .C1(n1585), .Y(n1526) );
  INVX8 U883 ( .A(n1527), .Y(n1291) );
  OR2X4 U884 ( .A(nReadOrWrite), .B(n1585), .Y(n1527) );
  INVX8 U885 ( .A(n1278), .Y(n1290) );
  OR2X4 U886 ( .A(n1273), .B(n1585), .Y(n1278) );
  INVX8 U887 ( .A(n1677), .Y(n1277) );
  AND2X4 U888 ( .A(nReadOrWrite), .B(n1282), .Y(AWREADY) );
  AND2X4 U889 ( .A(n1282), .B(n1273), .Y(ARREADY) );
  INVX8 U890 ( .A(nReadOrWrite), .Y(n1273) );
  OR2X4 U891 ( .A(n1351), .B(n1299), .Y(n1282) );
  INVX8 U892 ( .A(VALID_R), .Y(n1299) );
  OAI31X4 U893 ( .A0(n1528), .A1(n1306), .A2(n1354), .B0(n1529), .Y(n1351) );
  AOI31X4 U894 ( .A0(VALID_R), .A1(n1280), .A2(n1373), .B0(State_0_), .Y(n1529) );
  INVX8 U895 ( .A(n1294), .Y(n1373) );
  OR2X4 U896 ( .A(n1305), .B(n1530), .Y(n1294) );
  INVX8 U897 ( .A(WLAST), .Y(n1530) );
  OR2X4 U898 ( .A(n1295), .B(n1531), .Y(n1305) );
  INVX8 U899 ( .A(WVALID), .Y(n1531) );
  INVX8 U900 ( .A(WREADY), .Y(n1295) );
  OR2X4 U901 ( .A(BREADY), .B(n1533), .Y(n1280) );
  INVX8 U902 ( .A(n1641), .Y(n1354) );
  AOI31X4 U903 ( .A0(RLAST), .A1(VALID_R), .A2(n1532), .B0(ConsecutiveRead), 
        .Y(n1528) );
  AND2X4 U904 ( .A(nReadOrWrite_R), .B(RVALID), .Y(n1532) );
  INVX8 U905 ( .A(n1353), .Y(RVALID) );
  OR2X4 U906 ( .A(FirstREADCycle), .B(n1306), .Y(n1353) );
  INVX8 U907 ( .A(StateIsREAD), .Y(n1306) );
  INVX8 U908 ( .A(n1371), .Y(RLAST) );
  OR4X4 U909 ( .A(Len[1]), .B(Len[0]), .C(Len[3]), .D(Len[2]), .Y(n1371) );
  EDFFX4 Addr_R_reg_31_ ( .D(Addr_R300_31_), .CK(ACLK), .E(n1591), .Q(
        Addr_R[31]) );
  EDFFX4 Addr_R_reg_30_ ( .D(Addr_R300_30_), .CK(ACLK), .E(n1591), .Q(
        Addr_R[30]) );
  EDFFX4 Addr_R_reg_29_ ( .D(Addr_R300_29_), .CK(ACLK), .E(n1591), .Q(
        Addr_R[29]) );
  EDFFX4 Addr_R_reg_28_ ( .D(Addr_R300_28_), .CK(ACLK), .E(n1591), .Q(
        Addr_R[28]) );
  EDFFX4 Addr_R_reg_27_ ( .D(Addr_R300_27_), .CK(ACLK), .E(n1591), .Q(
        Addr_R[27]) );
  EDFFX4 Addr_R_reg_26_ ( .D(Addr_R300_26_), .CK(ACLK), .E(n1591), .Q(
        Addr_R[26]) );
  EDFFX4 Addr_R_reg_25_ ( .D(Addr_R300_25_), .CK(ACLK), .E(n1591), .Q(
        Addr_R[25]) );
  EDFFX4 Addr_R_reg_24_ ( .D(Addr_R300_24_), .CK(ACLK), .E(n1591), .Q(
        Addr_R[24]) );
  EDFFX4 Addr_R_reg_23_ ( .D(Addr_R300_23_), .CK(ACLK), .E(n1591), .Q(
        Addr_R[23]) );
  EDFFX4 Addr_R_reg_22_ ( .D(Addr_R300_22_), .CK(ACLK), .E(n1591), .Q(
        Addr_R[22]) );
  EDFFX4 Addr_R_reg_21_ ( .D(Addr_R300_21_), .CK(ACLK), .E(n1591), .Q(
        Addr_R[21]) );
  EDFFX4 Addr_R_reg_20_ ( .D(Addr_R300_20_), .CK(ACLK), .E(n1591), .Q(
        Addr_R[20]) );
  EDFFX4 Addr_R_reg_19_ ( .D(Addr_R300_19_), .CK(ACLK), .E(n1592), .Q(
        Addr_R[19]) );
  EDFFX4 Addr_R_reg_18_ ( .D(Addr_R300_18_), .CK(ACLK), .E(n1592), .Q(
        Addr_R[18]) );
  EDFFX4 Addr_R_reg_17_ ( .D(Addr_R300_17_), .CK(ACLK), .E(n1592), .Q(
        Addr_R[17]) );
  EDFFX4 Addr_R_reg_16_ ( .D(Addr_R300_16_), .CK(ACLK), .E(n1592), .Q(
        Addr_R[16]) );
  EDFFX4 Addr_R_reg_15_ ( .D(Addr_R300_15_), .CK(ACLK), .E(n1592), .Q(
        Addr_R[15]) );
  EDFFX4 Addr_R_reg_14_ ( .D(Addr_R300_14_), .CK(ACLK), .E(n1592), .Q(
        Addr_R[14]) );
  EDFFX4 Addr_R_reg_13_ ( .D(Addr_R300_13_), .CK(ACLK), .E(n1592), .Q(
        Addr_R[13]) );
  EDFFX4 Addr_R_reg_12_ ( .D(Addr_R300_12_), .CK(ACLK), .E(n1592), .Q(
        Addr_R[12]) );
  EDFFX4 Addr_R_reg_11_ ( .D(Addr_R300_11_), .CK(ACLK), .E(n1592), .Q(
        Addr_R[11]) );
  EDFFX4 Addr_R_reg_10_ ( .D(Addr_R300_10_), .CK(ACLK), .E(n1592), .Q(
        Addr_R[10]) );
  EDFFX4 Addr_R_reg_9_ ( .D(Addr_R300_9_), .CK(ACLK), .E(n1592), .Q(Addr_R[9])
         );
  EDFFX4 Addr_R_reg_8_ ( .D(Addr_R300_8_), .CK(ACLK), .E(n1592), .Q(Addr_R[8])
         );
  EDFFX4 Addr_R_reg_7_ ( .D(Addr_R300_7_), .CK(ACLK), .E(n1593), .Q(Addr_R[7])
         );
  EDFFX4 Addr_R_reg_6_ ( .D(Addr_R300_6_), .CK(ACLK), .E(n1593), .Q(Addr_R[6])
         );
  EDFFX4 Addr_R_reg_5_ ( .D(Addr_R300_5_), .CK(ACLK), .E(n1593), .Q(Addr_R[5])
         );
  EDFFX4 Addr_R_reg_4_ ( .D(Addr_R300_4_), .CK(ACLK), .E(n1593), .Q(Addr_R[4])
         );
  EDFFX4 Addr_R_reg_3_ ( .D(Addr_R300_3_), .CK(ACLK), .E(n1593), .Q(Addr_R[3])
         );
  EDFFX4 Addr_R_reg_2_ ( .D(Addr_R300_2_), .CK(ACLK), .E(n1593), .Q(Addr_R[2])
         );
  EDFFX4 Addr_R_reg_1_ ( .D(Addr_R300_1_), .CK(ACLK), .E(n1593), .Q(Addr_R[1])
         );
  EDFFX4 Addr_R_reg_0_ ( .D(Addr_R300_0_), .CK(ACLK), .E(n1593), .Q(Addr_R[0])
         );
  EDFFX4 Len_R_reg_3_ ( .D(Len_R306_3_), .CK(ACLK), .E(n1593), .Q(Len_R[3]) );
  EDFFX4 Len_R_reg_2_ ( .D(Len_R306_2_), .CK(ACLK), .E(n1593), .Q(Len_R[2]) );
  EDFFX4 Len_R_reg_1_ ( .D(Len_R306_1_), .CK(ACLK), .E(n1593), .Q(Len_R[1]) );
  EDFFX4 Len_R_reg_0_ ( .D(Len_R306_0_), .CK(ACLK), .E(n1593), .Q(Len_R[0]) );
  EDFFX4 Size_R_reg_1_ ( .D(Size_R312_1_), .CK(ACLK), .E(n1594), .Q(Size_R_1_)
         );
  EDFFX4 Size_R_reg_0_ ( .D(Size_R312_0_), .CK(ACLK), .E(n1594), .Q(Size_R_0_)
         );
  EDFFX4 Burst_R_reg_1_ ( .D(Burst_R318_1_), .CK(ACLK), .E(n1594), .Q(
        Burst_R[1]) );
  EDFFX4 Burst_R_reg_0_ ( .D(Burst_R318_0_), .CK(ACLK), .E(n1594), .Q(
        Burst_R[0]) );
  EDFFX4 ID_R_reg_3_ ( .D(ID_R324_3_), .CK(ACLK), .E(n1594), .Q(ID_R[3]) );
  EDFFX4 ID_R_reg_2_ ( .D(ID_R324_2_), .CK(ACLK), .E(n1594), .Q(ID_R[2]) );
  EDFFX4 ID_R_reg_1_ ( .D(ID_R324_1_), .CK(ACLK), .E(n1594), .Q(ID_R[1]) );
  EDFFX4 ID_R_reg_0_ ( .D(ID_R324_0_), .CK(ACLK), .E(n1594), .Q(ID_R[0]) );
  EDFFX4 BID_reg_3_ ( .D(BID655_3_), .CK(ACLK), .E(n659_0_), .Q(BID[3]), .QN(
        n1267) );
  EDFFX4 BID_reg_2_ ( .D(BID655_2_), .CK(ACLK), .E(n659_0_), .Q(BID[2]), .QN(
        n1266) );
  EDFFX4 BID_reg_1_ ( .D(BID655_1_), .CK(ACLK), .E(n659_0_), .Q(BID[1]), .QN(
        n1265) );
  EDFFX4 BID_reg_0_ ( .D(BID655_0_), .CK(ACLK), .E(n659_0_), .Q(BID[0]), .QN(
        n1264) );
  EDFFX4 nReadOrWrite_R_reg ( .D(nReadOrWrite_R330), .CK(ACLK), .E(n1594), .Q(
        nReadOrWrite_R) );
  DFFRX4 State_reg_3_ ( .D(NextState[3]), .CK(ACLK), .RN(n1675), .Q(
        StateIsWAIT_RESP) );
  DFFRX4 State_reg_2_ ( .D(NextState[2]), .CK(ACLK), .RN(n1679), .Q(WREADY) );
  DFFRX4 State_reg_1_ ( .D(NextState[1]), .CK(ACLK), .RN(n1675), .Q(
        StateIsREAD) );
  DFFSX4 State_reg_0_ ( .D(NextState[0]), .CK(ACLK), .SN(n1677), .Q(State_0_)
         );
  DFFRX4 FirstREADCycle_reg ( .D(FirstREADCycle394), .CK(ACLK), .RN(n1678), 
        .Q(FirstREADCycle) );
  EDFFX4 PrevAddr_reg_31_ ( .D(Addr[31]), .CK(ACLK), .E(n1681), .QN(n1263) );
  EDFFX4 PrevAddr_reg_30_ ( .D(Addr[30]), .CK(ACLK), .E(n_3225), .QN(n1262) );
  EDFFX4 PrevAddr_reg_29_ ( .D(Addr[29]), .CK(ACLK), .E(n1682), .QN(n1261) );
  EDFFX4 PrevAddr_reg_28_ ( .D(Addr[28]), .CK(ACLK), .E(n1681), .QN(n1260) );
  EDFFX4 PrevAddr_reg_27_ ( .D(Addr[27]), .CK(ACLK), .E(n_3225), .QN(n1259) );
  EDFFX4 PrevAddr_reg_26_ ( .D(Addr[26]), .CK(ACLK), .E(n1682), .QN(n1258) );
  EDFFX4 PrevAddr_reg_25_ ( .D(Addr[25]), .CK(ACLK), .E(n1681), .QN(n1257) );
  EDFFX4 PrevAddr_reg_24_ ( .D(Addr[24]), .CK(ACLK), .E(n_3225), .QN(n1256) );
  EDFFX4 PrevAddr_reg_23_ ( .D(Addr[23]), .CK(ACLK), .E(n1682), .QN(n1255) );
  EDFFX4 PrevAddr_reg_22_ ( .D(Addr[22]), .CK(ACLK), .E(n1681), .QN(n1254) );
  EDFFX4 PrevAddr_reg_21_ ( .D(Addr[21]), .CK(ACLK), .E(n_3225), .QN(n1253) );
  EDFFX4 PrevAddr_reg_20_ ( .D(Addr[20]), .CK(ACLK), .E(n1682), .QN(n1252) );
  EDFFX4 PrevAddr_reg_19_ ( .D(Addr[19]), .CK(ACLK), .E(n1681), .QN(n1251) );
  EDFFX4 PrevAddr_reg_18_ ( .D(Addr[18]), .CK(ACLK), .E(n_3225), .QN(n1250) );
  EDFFX4 PrevAddr_reg_17_ ( .D(Addr[17]), .CK(ACLK), .E(n1682), .QN(n1249) );
  EDFFX4 PrevAddr_reg_16_ ( .D(Addr[16]), .CK(ACLK), .E(n1681), .QN(n1248) );
  EDFFX4 PrevAddr_reg_15_ ( .D(Addr[15]), .CK(ACLK), .E(n_3225), .QN(n1247) );
  EDFFX4 PrevAddr_reg_14_ ( .D(Addr[14]), .CK(ACLK), .E(n1682), .QN(n1246) );
  EDFFX4 PrevAddr_reg_13_ ( .D(Addr[13]), .CK(ACLK), .E(n1681), .QN(n1245) );
  EDFFX4 PrevAddr_reg_12_ ( .D(Addr[12]), .CK(ACLK), .E(n_3225), .QN(n1244) );
  EDFFX4 PrevAddr_reg_11_ ( .D(Addr[11]), .CK(ACLK), .E(n1682), .QN(n1243) );
  EDFFX4 PrevAddr_reg_10_ ( .D(Addr[10]), .CK(ACLK), .E(n1681), .QN(n1242) );
  EDFFX4 PrevAddr_reg_9_ ( .D(Addr[9]), .CK(ACLK), .E(n_3225), .QN(n1241) );
  EDFFX4 PrevAddr_reg_8_ ( .D(Addr[8]), .CK(ACLK), .E(n1682), .QN(n1240) );
  EDFFX4 PrevAddr_reg_7_ ( .D(Addr[7]), .CK(ACLK), .E(n1681), .QN(n1239) );
  EDFFX4 PrevAddr_reg_6_ ( .D(Addr[6]), .CK(ACLK), .E(n_3225), .QN(n1238) );
  EDFFX4 PrevAddr_reg_5_ ( .D(Addr[5]), .CK(ACLK), .E(n1682), .QN(n1237) );
  EDFFX4 PrevAddr_reg_4_ ( .D(Addr[4]), .CK(ACLK), .E(n1681), .QN(n1236) );
  EDFFX4 PrevAddr_reg_3_ ( .D(Addr[3]), .CK(ACLK), .E(n1682), .QN(n1235) );
  EDFFX4 PrevAddr_reg_2_ ( .D(Addr[2]), .CK(ACLK), .E(n1682), .QN(n1234) );
  INVX20 U910 ( .A(n1590), .Y(n1585) );
  INVX20 U911 ( .A(n1589), .Y(n1586) );
  INVX20 U912 ( .A(n1589), .Y(n1587) );
  INVX20 U913 ( .A(n1589), .Y(n1588) );
  INVX20 U914 ( .A(n1680), .Y(n1589) );
  INVX20 U915 ( .A(n1680), .Y(n1590) );
  INVX20 U916 ( .A(n1596), .Y(n1591) );
  INVX20 U917 ( .A(n1595), .Y(n1592) );
  INVX20 U918 ( .A(n1595), .Y(n1593) );
  INVX20 U919 ( .A(n1595), .Y(n1594) );
  INVX20 U920 ( .A(n1733), .Y(n1595) );
  INVX20 U921 ( .A(n1733), .Y(n1596) );
  INVX20 U922 ( .A(n1602), .Y(n1597) );
  INVX20 U923 ( .A(n1601), .Y(n1598) );
  INVX20 U924 ( .A(n1601), .Y(n1599) );
  INVX20 U925 ( .A(n1601), .Y(n1600) );
  INVX20 U926 ( .A(n1291), .Y(n1601) );
  INVX20 U927 ( .A(n1291), .Y(n1602) );
  INVX20 U928 ( .A(n1608), .Y(n1603) );
  INVX20 U929 ( .A(n1607), .Y(n1604) );
  INVX20 U930 ( .A(n1607), .Y(n1605) );
  INVX20 U931 ( .A(n1607), .Y(n1606) );
  INVX20 U932 ( .A(n1290), .Y(n1607) );
  INVX20 U933 ( .A(n1290), .Y(n1608) );
  BUFX20 U934 ( .A(MEMRDATA[0]), .Y(RDATA[0]) );
  BUFX20 U935 ( .A(MEMRDATA[1]), .Y(RDATA[1]) );
  BUFX20 U936 ( .A(MEMRDATA[2]), .Y(RDATA[2]) );
  BUFX20 U937 ( .A(MEMRDATA[3]), .Y(RDATA[3]) );
  BUFX20 U938 ( .A(MEMRDATA[4]), .Y(RDATA[4]) );
  BUFX20 U939 ( .A(MEMRDATA[5]), .Y(RDATA[5]) );
  BUFX20 U940 ( .A(MEMRDATA[6]), .Y(RDATA[6]) );
  BUFX20 U941 ( .A(MEMRDATA[7]), .Y(RDATA[7]) );
  BUFX20 U942 ( .A(MEMRDATA[8]), .Y(RDATA[8]) );
  BUFX20 U943 ( .A(MEMRDATA[9]), .Y(RDATA[9]) );
  BUFX20 U944 ( .A(MEMRDATA[10]), .Y(RDATA[10]) );
  BUFX20 U945 ( .A(MEMRDATA[11]), .Y(RDATA[11]) );
  BUFX20 U946 ( .A(MEMRDATA[12]), .Y(RDATA[12]) );
  BUFX20 U947 ( .A(MEMRDATA[13]), .Y(RDATA[13]) );
  BUFX20 U948 ( .A(MEMRDATA[14]), .Y(RDATA[14]) );
  BUFX20 U949 ( .A(MEMRDATA[15]), .Y(RDATA[15]) );
  BUFX20 U950 ( .A(MEMRDATA[16]), .Y(RDATA[16]) );
  BUFX20 U951 ( .A(MEMRDATA[17]), .Y(RDATA[17]) );
  BUFX20 U952 ( .A(MEMRDATA[18]), .Y(RDATA[18]) );
  BUFX20 U953 ( .A(MEMRDATA[19]), .Y(RDATA[19]) );
  BUFX20 U954 ( .A(MEMRDATA[20]), .Y(RDATA[20]) );
  BUFX20 U955 ( .A(MEMRDATA[21]), .Y(RDATA[21]) );
  BUFX20 U956 ( .A(MEMRDATA[22]), .Y(RDATA[22]) );
  BUFX20 U957 ( .A(MEMRDATA[23]), .Y(RDATA[23]) );
  BUFX20 U958 ( .A(MEMRDATA[24]), .Y(RDATA[24]) );
  BUFX20 U959 ( .A(MEMRDATA[25]), .Y(RDATA[25]) );
  BUFX20 U960 ( .A(MEMRDATA[26]), .Y(RDATA[26]) );
  BUFX20 U961 ( .A(MEMRDATA[27]), .Y(RDATA[27]) );
  BUFX20 U962 ( .A(MEMRDATA[28]), .Y(RDATA[28]) );
  BUFX20 U963 ( .A(MEMRDATA[29]), .Y(RDATA[29]) );
  BUFX20 U964 ( .A(MEMRDATA[30]), .Y(RDATA[30]) );
  BUFX20 U965 ( .A(MEMRDATA[31]), .Y(RDATA[31]) );
  BUFX20 U966 ( .A(RREADY), .Y(n1641) );
  BUFX20 U967 ( .A(WDATA[0]), .Y(MEMWDATA[0]) );
  BUFX20 U968 ( .A(WDATA[1]), .Y(MEMWDATA[1]) );
  BUFX20 U969 ( .A(WDATA[2]), .Y(MEMWDATA[2]) );
  BUFX20 U970 ( .A(WDATA[3]), .Y(MEMWDATA[3]) );
  BUFX20 U971 ( .A(WDATA[4]), .Y(MEMWDATA[4]) );
  BUFX20 U972 ( .A(WDATA[5]), .Y(MEMWDATA[5]) );
  BUFX20 U973 ( .A(WDATA[6]), .Y(MEMWDATA[6]) );
  BUFX20 U974 ( .A(WDATA[7]), .Y(MEMWDATA[7]) );
  BUFX20 U975 ( .A(WDATA[8]), .Y(MEMWDATA[8]) );
  BUFX20 U976 ( .A(WDATA[9]), .Y(MEMWDATA[9]) );
  BUFX20 U977 ( .A(WDATA[10]), .Y(MEMWDATA[10]) );
  BUFX20 U978 ( .A(WDATA[11]), .Y(MEMWDATA[11]) );
  BUFX20 U979 ( .A(WDATA[12]), .Y(MEMWDATA[12]) );
  BUFX20 U980 ( .A(WDATA[13]), .Y(MEMWDATA[13]) );
  BUFX20 U981 ( .A(WDATA[14]), .Y(MEMWDATA[14]) );
  BUFX20 U982 ( .A(WDATA[15]), .Y(MEMWDATA[15]) );
  BUFX20 U983 ( .A(WDATA[16]), .Y(MEMWDATA[16]) );
  BUFX20 U984 ( .A(WDATA[17]), .Y(MEMWDATA[17]) );
  BUFX20 U985 ( .A(WDATA[18]), .Y(MEMWDATA[18]) );
  BUFX20 U986 ( .A(WDATA[19]), .Y(MEMWDATA[19]) );
  BUFX20 U987 ( .A(WDATA[20]), .Y(MEMWDATA[20]) );
  BUFX20 U988 ( .A(WDATA[21]), .Y(MEMWDATA[21]) );
  BUFX20 U989 ( .A(WDATA[22]), .Y(MEMWDATA[22]) );
  BUFX20 U990 ( .A(WDATA[23]), .Y(MEMWDATA[23]) );
  BUFX20 U991 ( .A(WDATA[24]), .Y(MEMWDATA[24]) );
  BUFX20 U992 ( .A(WDATA[25]), .Y(MEMWDATA[25]) );
  BUFX20 U993 ( .A(WDATA[26]), .Y(MEMWDATA[26]) );
  BUFX20 U994 ( .A(WDATA[27]), .Y(MEMWDATA[27]) );
  BUFX20 U995 ( .A(WDATA[28]), .Y(MEMWDATA[28]) );
  BUFX20 U996 ( .A(WDATA[29]), .Y(MEMWDATA[29]) );
  BUFX20 U997 ( .A(WDATA[30]), .Y(MEMWDATA[30]) );
  BUFX20 U998 ( .A(WDATA[31]), .Y(MEMWDATA[31]) );
  BUFX8 U999 ( .A(ARESETn), .Y(n1674) );
  BUFX20 U1000 ( .A(n1674), .Y(n1675) );
  BUFX20 U1001 ( .A(n1674), .Y(n1676) );
  BUFX20 U1002 ( .A(n1674), .Y(n1677) );
  BUFX20 U1003 ( .A(n1674), .Y(n1678) );
  BUFX20 U1004 ( .A(n1674), .Y(n1679) );
  BUFX20 U1005 ( .A(n1277), .Y(n1680) );
  OAI221X4 U1006 ( .A0(n1375), .A1(n1354), .B0(n1354), .B1(n1306), .C0(n1494), 
        .Y(n1681) );
  OAI221X4 U1007 ( .A0(n1375), .A1(n1354), .B0(n1354), .B1(n1306), .C0(n1494), 
        .Y(n1682) );
  OAI2BB1X4 U1008 ( .A0N(n1387), .A1N(n1682), .B0(n1406), .Y(n1683) );
  OAI2BB1X4 U1009 ( .A0N(n1387), .A1N(n1681), .B0(n1406), .Y(n1684) );
  INVX4 U1010 ( .A(n1683), .Y(n1685) );
  INVX4 U1011 ( .A(n1683), .Y(n1686) );
  INVX4 U1012 ( .A(n1685), .Y(n1687) );
  INVX4 U1013 ( .A(n1685), .Y(n1688) );
  INVX4 U1014 ( .A(n1686), .Y(n1689) );
  INVX4 U1015 ( .A(n1686), .Y(n1690) );
  INVX4 U1016 ( .A(n1684), .Y(n1691) );
  INVX4 U1017 ( .A(n1684), .Y(n1692) );
  INVX4 U1018 ( .A(n1691), .Y(n1693) );
  INVX4 U1019 ( .A(n1691), .Y(n1694) );
  INVX4 U1020 ( .A(n1692), .Y(n1695) );
  INVX4 U1021 ( .A(n1692), .Y(n1696) );
  INVX4 U1022 ( .A(n1438), .Y(n1697) );
  INVX4 U1023 ( .A(n1438), .Y(n1698) );
  INVX8 U1024 ( .A(n1697), .Y(n1699) );
  INVX4 U1025 ( .A(n1697), .Y(n1700) );
  INVX4 U1026 ( .A(n1698), .Y(n1701) );
  INVX4 U1027 ( .A(n1698), .Y(n1702) );
  BUFX20 U1028 ( .A(n1377), .Y(n1703) );
  BUFX20 U1029 ( .A(n1377), .Y(n1704) );
  OR3X4 U1030 ( .A(WREADY), .B(n1641), .C(FirstREADCycle), .Y(n1705) );
  OR3X4 U1031 ( .A(WREADY), .B(n1641), .C(FirstREADCycle), .Y(n1706) );
  INVX4 U1032 ( .A(n1705), .Y(n1707) );
  INVX4 U1033 ( .A(n1705), .Y(n1708) );
  INVX4 U1034 ( .A(n1707), .Y(n1709) );
  INVX4 U1035 ( .A(n1707), .Y(n1710) );
  INVX4 U1036 ( .A(n1707), .Y(n1711) );
  INVX4 U1037 ( .A(n1708), .Y(n1712) );
  INVX4 U1038 ( .A(n1708), .Y(n1713) );
  INVX4 U1039 ( .A(n1708), .Y(n1714) );
  INVX4 U1040 ( .A(n1706), .Y(n1715) );
  INVX4 U1041 ( .A(n1706), .Y(n1716) );
  INVX4 U1042 ( .A(n1715), .Y(n1717) );
  INVX4 U1043 ( .A(n1715), .Y(n1718) );
  INVX4 U1044 ( .A(n1715), .Y(n1719) );
  INVX4 U1045 ( .A(n1716), .Y(n1720) );
  INVX4 U1046 ( .A(n1716), .Y(n1721) );
  INVX4 U1047 ( .A(n1716), .Y(n1722) );
  INVX4 U1048 ( .A(n1270), .Y(n1723) );
  INVX4 U1049 ( .A(n1270), .Y(n1724) );
  INVX4 U1050 ( .A(n1723), .Y(n1725) );
  INVX3 U1051 ( .A(n1723), .Y(n1726) );
  INVX3 U1052 ( .A(n1723), .Y(n1727) );
  INVX4 U1053 ( .A(n1724), .Y(n1728) );
  INVX4 U1054 ( .A(n1724), .Y(n1729) );
  INVX4 U1055 ( .A(n1724), .Y(n1730) );
  BUFX20 U1056 ( .A(n1268), .Y(n1731) );
  BUFX20 U1057 ( .A(n1268), .Y(n1732) );
  BUFX20 U1058 ( .A(n333), .Y(n1733) );
  DFFRX4 ConsecutiveRead_reg ( .D(n1584), .CK(ACLK), .RN(n1676), .Q(
        ConsecutiveRead) );
  DFFRX4 Addr_reg_0_ ( .D(n1583), .CK(ACLK), .RN(n1678), .Q(Addr[0]) );
  DFFRX4 Addr_reg_1_ ( .D(n1582), .CK(ACLK), .RN(n1677), .Q(Addr[1]) );
  DFFRX4 Addr_reg_2_ ( .D(n1581), .CK(ACLK), .RN(n1679), .Q(Addr[2]) );
  DFFRX4 Addr_reg_3_ ( .D(n1580), .CK(ACLK), .RN(n1677), .Q(Addr[3]) );
  DFFRX4 Addr_reg_4_ ( .D(n1579), .CK(ACLK), .RN(n1675), .Q(Addr[4]) );
  DFFRX4 Addr_reg_5_ ( .D(n1578), .CK(ACLK), .RN(n1676), .Q(Addr[5]) );
  DFFRX4 Addr_reg_6_ ( .D(n1577), .CK(ACLK), .RN(n1675), .Q(Addr[6]) );
  DFFRX4 Addr_reg_7_ ( .D(n1576), .CK(ACLK), .RN(n1678), .Q(Addr[7]) );
  DFFRX4 Addr_reg_8_ ( .D(n1575), .CK(ACLK), .RN(n1676), .Q(Addr[8]) );
  DFFRX4 Addr_reg_9_ ( .D(n1574), .CK(ACLK), .RN(n1679), .Q(Addr[9]) );
  DFFRX4 Addr_reg_10_ ( .D(n1573), .CK(ACLK), .RN(n1679), .Q(Addr[10]) );
  DFFRX4 Addr_reg_11_ ( .D(n1572), .CK(ACLK), .RN(n1678), .Q(Addr[11]) );
  DFFRX4 Addr_reg_12_ ( .D(n1571), .CK(ACLK), .RN(n1677), .Q(Addr[12]) );
  DFFRX4 Addr_reg_13_ ( .D(n1570), .CK(ACLK), .RN(n1675), .Q(Addr[13]) );
  DFFRX4 Addr_reg_14_ ( .D(n1569), .CK(ACLK), .RN(n1678), .Q(Addr[14]) );
  DFFRX4 Addr_reg_15_ ( .D(n1568), .CK(ACLK), .RN(n1677), .Q(Addr[15]) );
  DFFRX4 Addr_reg_16_ ( .D(n1567), .CK(ACLK), .RN(n1676), .Q(Addr[16]) );
  DFFRX4 Addr_reg_17_ ( .D(n1566), .CK(ACLK), .RN(n1676), .Q(Addr[17]) );
  DFFRX4 Addr_reg_18_ ( .D(n1565), .CK(ACLK), .RN(n1679), .Q(Addr[18]) );
  DFFRX4 Addr_reg_19_ ( .D(n1564), .CK(ACLK), .RN(n1677), .Q(Addr[19]) );
  DFFRX4 Addr_reg_20_ ( .D(n1563), .CK(ACLK), .RN(n1675), .Q(Addr[20]) );
  DFFRX4 Addr_reg_21_ ( .D(n1562), .CK(ACLK), .RN(n1679), .Q(Addr[21]) );
  DFFRX4 Addr_reg_22_ ( .D(n1561), .CK(ACLK), .RN(n1675), .Q(Addr[22]) );
  DFFRX4 Addr_reg_23_ ( .D(n1560), .CK(ACLK), .RN(n1678), .Q(Addr[23]) );
  DFFRX4 Addr_reg_24_ ( .D(n1559), .CK(ACLK), .RN(n1676), .Q(Addr[24]) );
  DFFRX4 Addr_reg_25_ ( .D(n1558), .CK(ACLK), .RN(n1678), .Q(Addr[25]) );
  DFFRX4 Addr_reg_26_ ( .D(n1557), .CK(ACLK), .RN(n1677), .Q(Addr[26]) );
  DFFRX4 Addr_reg_27_ ( .D(n1556), .CK(ACLK), .RN(n1679), .Q(Addr[27]) );
  DFFRX4 Addr_reg_28_ ( .D(n1555), .CK(ACLK), .RN(n1677), .Q(Addr[28]) );
  DFFRX4 Addr_reg_29_ ( .D(n1554), .CK(ACLK), .RN(n1675), .Q(Addr[29]) );
  DFFRX4 Addr_reg_30_ ( .D(n1553), .CK(ACLK), .RN(n1676), .Q(Addr[30]) );
  DFFRX4 Addr_reg_31_ ( .D(n1552), .CK(ACLK), .RN(n1675), .Q(Addr[31]) );
  DFFRX4 BVALID_reg ( .D(n1551), .CK(ACLK), .RN(n1678), .Q(BVALID), .QN(n1533)
         );
  DFFRX4 nReadOrWrite_reg ( .D(n1550), .CK(ACLK), .RN(n1676), .Q(nReadOrWrite)
         );
  DFFRX4 VALID_R_reg ( .D(n1549), .CK(ACLK), .RN(n1679), .Q(VALID_R) );
  DFFRX4 Len_reg_0_ ( .D(n1548), .CK(ACLK), .RN(n1679), .Q(Len[0]) );
  DFFRX4 Len_reg_1_ ( .D(n1547), .CK(ACLK), .RN(n1678), .Q(Len[1]) );
  DFFRX4 Len_reg_2_ ( .D(n1546), .CK(ACLK), .RN(n1677), .Q(Len[2]) );
  DFFRX4 Len_reg_3_ ( .D(n1545), .CK(ACLK), .RN(n1675), .Q(Len[3]) );
  DFFRX4 Id_reg_0_ ( .D(n1544), .CK(ACLK), .RN(n1678), .Q(RID[0]) );
  DFFRX4 Id_reg_1_ ( .D(n1543), .CK(ACLK), .RN(n1677), .Q(RID[1]) );
  DFFRX4 Id_reg_2_ ( .D(n1542), .CK(ACLK), .RN(n1676), .Q(RID[2]) );
  DFFRX4 Id_reg_3_ ( .D(n1541), .CK(ACLK), .RN(n1676), .Q(RID[3]) );
  DFFRX4 Burst_reg_0_ ( .D(n1540), .CK(ACLK), .RN(n1679), .Q(Burst[0]) );
  DFFRX4 Burst_reg_1_ ( .D(n1539), .CK(ACLK), .RN(n1677), .Q(Burst[1]) );
  DFFRX4 Size_reg_0_ ( .D(n1538), .CK(ACLK), .RN(n1675), .Q(Size[0]) );
  DFFRX4 Size_reg_1_ ( .D(n1537), .CK(ACLK), .RN(n1679), .Q(Size[1]) );
  DFFRX4 BurstLen_reg_1_ ( .D(n1536), .CK(ACLK), .RN(n1675), .Q(BurstLen_1_)
         );
  DFFRX4 BurstLen_reg_2_ ( .D(n1535), .CK(ACLK), .RN(n1678), .Q(BurstLen_2_)
         );
  DFFRX4 BurstLen_reg_3_ ( .D(n1534), .CK(ACLK), .RN(n1676), .Q(BurstLen_3_)
         );
  INVX8 U1059 ( .A(Len[0]), .Y(Len821_0_) );
  INVX8 U1060 ( .A(Len[1]), .Y(n1734) );
  NAND2X4 U1061 ( .A(n1734), .B(Len821_0_), .Y(n1736) );
  NAND2X4 U1062 ( .A(Len[1]), .B(Len[0]), .Y(n1735) );
  NAND2X4 U1063 ( .A(n1736), .B(n1735), .Y(Len821_1_) );
  INVX8 U1064 ( .A(n1736), .Y(n1738) );
  INVX8 U1065 ( .A(Len[2]), .Y(n1737) );
  XNOR2X4 U1066 ( .A(n1738), .B(n1737), .Y(Len821_2_) );
  NAND2X4 U1067 ( .A(n1738), .B(n1737), .Y(n1739) );
  XNOR2X4 U1068 ( .A(Len[3]), .B(n1739), .Y(Len821_3_) );
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

