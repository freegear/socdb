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
prom
Part "K3P6C2000B-SC15"

Sizes
pageAddressWidth 2

Features
chipEnableMode 1
chipSelectMode 0
cs1ActiveLow 0
cs2ActiveLow 0
cs3ActiveLow 0
cs4ActiveLow 0
eeMode 0
wordMode 1
pageMode 1
sectorEraseMode 0
twoCycleWriteMode 0
fastColumnAccessMode 0
flash 0
outputEnableMode 1
waitMode 0

Pins
address address 20
cebar nCS 1
csbar csbar 1
oebar nOE 1
webar webar 1
data Data 32
wordbar nWRD 1
waitbar waitbar 1

Timing
taa 150 ns
thzcs1 disabled
tacs1 disabled
thzcs2 disabled
tacs2 disabled
tpu disabled
tpd disabled
thzoe 30 ns
toe 70 ns
thzce disabled
tace 150 ns
toh 0 ns
trac disabled
tcaa disabled
twd disabled
tdw disabled
tww disabled
tpwd disabled
tcr disabled
trc 150 ns
tas disabled
toes disabled
tah disabled
tpa 70 ns
twp disabled
tds disabled
tdh disabled
toeh disabled
twc disabled
twr disabled
tcs disabled
tch disabled
tghwl disabled
twph disabled
twhwh1 disabled
twhwh2 disabled
tbusy disabled
