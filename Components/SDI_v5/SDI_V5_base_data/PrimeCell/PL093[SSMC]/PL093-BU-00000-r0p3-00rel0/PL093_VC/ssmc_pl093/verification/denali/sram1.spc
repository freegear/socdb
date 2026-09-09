--======================================================================--
--    Copyright (c) 2000 by Denali Software, Inc.  All rights reserved
--======================================================================--
-- 
-- This file contains proprietary information of Denali Software, Inc.
-- SOMA(tm) is Denali Software's proprietary language for defining 
-- memory models.  
-- 
-- Subject to your agreement with the restrictions set forth below, 
-- Denali Software, Inc., grants you a non-exclusive license to use
-- the SOMA language in the following manner :
-- 
-- You may:
-- 
--   *  Use SOMA language to create memory models.
-- 
--   *  Distribute memory models created using the SOMA language to 
--      others provided that this notice is not removed from the file.
-- 
-- You may not:
-- 
--   *  Create software programs or tools that use the SOMA language 
--      as either input or output where the software programs are 
--      intended for distribution to others.
-- 
--   *  Change the SOMA language in any manner.
-- 
-- By using the SOMA specification files, you are consenting to be 
-- bound by and are becoming party to this agreement.  If you do not 
-- agree to all of the terms of this agreement, you may not use the 
-- SOMA specification files.
-- 
-- If you have any questions regarding this agreement, or if you 
-- would like to inquire about obtaining additional or different rights 
-- in the SOMA specification files and SOMA language, please contact 
-- Denali Software.
--
Version 0.001
-- Written on 12/29/2000
-- MemMaker version: 2.600  $DENALI: /NIS/tools/tool14/denali
sram
Manufacturer samsung
Part "KM681002A-15"

Sizes
portCount 1
semaphoreWidth 0
lowAddress 0
highAddress 67108863

Features
uniDirMode 0
masterSlaveMode 0
semaphoreMode 0
busyMode 0
interruptMode 0
byteEnableMode 0
dataLatchMode 0
addressLatchMode 0
oneCE 1
twoCE 0
ce1ActiveLow 1
ce2ActiveLow 0
resetMode 0
outputEnableMode 1
checkAddrBounds 0

Pins
ms ms 1
reset reset 1
address address 17
addressLatch addressLatch 1
cebar nCS 1
ce2bar ce2bar 1
busybar busybar 1
webar nWE 1
oebar nOE 1
sembar sembar 1
bebar bebar 4
Data Data 8
DataIn datain 9
DataOut dataout 9
dataLatch dataLatch 1
intbar intbar 1

Timing
taa 15 ns
tabe disabled
tace 15 ns
tah 0 ns
taoe 7 ns
tas 0 ns
tavel 0 ns
taw 10 ns
tbdd disabled
tbha disabled
tbhc disabled
tbla disabled
tblc disabled
tbw disabled
tcw 10 ns
tddd disabled
tdh 0 ns
tds 7 ns
thzbe disabled
thzce 0 ns
thzoe 0 ns
thzwe 0 ns
thzbe_max disabled
thzce_max 7 ns
thzoe_max 7 ns
thzwe_max 7 ns
tinr disabled
tins disabled
tlzbe disabled
tlzce 3 ns
tlzoe 0 ns
tlzwe 3 ns
toh 3 ns
tpd 15 ns
tps 1 s
tpu 0 ns
trc 15 ns
tsop disabled
tsps disabled
tswrd disabled
twb disabled
twc 15 ns
twdd disabled
twh disabled
twp1 10 ns
twp2 15 ns
talhqv disabled
talhall disabled
tavall disabled
tevall disabled
tavalh disabled
tevalh disabled
tallax disabled
tallex disabled
talhqx1 disabled
talhqx2 disabled
talhqz disabled
talhwl disabled
tdvdll disabled
tdveh disabled
tdlhwh disabled
tdlheh disabled
talleh disabled
tdlldx disabled
twhdlh disabled
tehdlh disabled
twhalh disabled
talhwh disabled
