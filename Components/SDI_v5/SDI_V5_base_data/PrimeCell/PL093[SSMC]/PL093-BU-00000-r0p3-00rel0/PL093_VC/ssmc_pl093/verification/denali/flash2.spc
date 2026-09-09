--======================================================================
--    Copyright (c) 2000 by Denali Software, Inc.  All rights reserved
--======================================================================
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
Version 0.001
flash

Part "28F800C3"
Sizes
manufacturerCode 1
deviceCode 164
sectorSizes "Nx64kb"
bankCount 1
bankStarts ""
pageWords 1
burstLength 32
burstStartMSB 13
burstStartLSB 11
burstStartLatencyMap "2=>2,3=>3,4=>4,5=>5,6=>6"
burstLengthMSB 2
burstLengthMap "1=>4,2=>8,7=>-1"
readCfgRgFirstDataInput 0x60
synchReadSectors ""
pageWriteBuffers 1
pageWriteWords 8
pageWriteMinWords 1
protectedSectors ""
cfiVendorSpecific "00000000000000000000000000000000"
cfiVendorID 0
cfiExtTableAddr 0
cfiExtQueryMajorV 0
cfiExtQueryMinorV 0
cfiExtQueryData "0"
cfiAltVendorID 0
cfiAltExtTableAddr 0
cfiAltExtQueryMajorV 0
cfiAltExtQueryMinorV 0
cfiAltExtQueryData "0"
cfiVccMin 0
cfiVccMax 0
cfiVppMin 0
cfiVppMax 0
cfiTypTimeoutWrite 0
cfiTypTimeoutMaxWrite 0
cfiTypTimeoutSectorErase 0
cfiTypTimeoutChipErase 0
cfiMaxTimeoutWrite 0
cfiMaxTimeoutMaxWrite 0
cfiMaxTimeoutSectorErase 0
cfiMaxTimeoutChipErase 0
cfiDeviceSize 0
cfiDeviceInterfaceID 0
cfiMaxBytesWrite 0
otpFactoryBaseAddress 0
otpFactorySize 0
otpUserBaseAddress 0
otpUserSize 0
otpLockByteAddress 0
otpByteSelectBit 0
otpAddrMSB 0
otpAddrLSB 0

Features
intelCmdSet 1
configureSTS 0
readConfigureCmdPage 0
amdCmdSet 0
eraseSuspendToggle 0
hasUnlockBypass 0
sixCycleUnlockBypassCmd 0
oneCycleBypassProgramCmd 0
bootSectored 0
topBoot 0
allowSimultaneousWrite 0
pageModeReads 0
burstModeReads 0
burstAdvancePin 0
burstEnableDisable 0
burstEndPin 0
linearBurst 0
interleavedBurst 0
readConfigureCmd 0
delayAtPageBoundary 1
linearBurstOrderActiveLow 0
synchReadDeviceID 0
synchReadStatus 0
burstCrossBank 1
setWaitStateCmd 0
addressLatchPin 0
readyBusyPin 0
resetPin 0
powerSavePin 0
powerSaveCmd 0
selectByteWord 0
a0IsByteSelect 0
muxDataAddr 0
latchAddressOnRise 0
canAddSectors 1
singleWrites 1
pageModeWrites 0
noChipErase 0
eraseSuspendResume 1
eraseSuspendProgram 0
programSuspendResume 0
sectorProtection 0
writeProtectPin 0
writeProtectCmds 0
protectOnly 0
protectAllAvail 0
protectBurst 0
hasCfi 0
oneTimeProtect 0
otpFactoryArea 0
otpUserArea 0
otpUserPrevProtected 0
otpWithCmd 0
otpAddrBusRange 0
softwareChipProtectCommand 0
alternateChipEraseCommand 0
ignoreCommandAddress 0

Pins
address address 19
data Data 16
cebar nCS 1
oebar nOE 1
webar nWE 1
wpbar wpbar 1
rybybar rybybar 1
reset reset 1
bytebar bytebar 1
clk clk 1
advbar advbar 1
lbabar lbabar 1
baabar baabar 1
indbar indbar 1
waitbar waitbar 1
ps ps 1

Timing
trc 90 ns
tprc disabled
taa 90 ns
tpacc disabled
tce 90 ns
toe 35 ns
tehqz 25 ns
tghqz 25 ns
toh 0 ns
tiacc disabled
tbacc disabled
tkhkh disabled
tkhkl disabled
tklkh disabled
tkhqx disabled
tlbas disabled
tlbah disabled
tbaas disabled
tbaah disabled
tavkh disabled
tkhax disabled
telkh disabled
tavlh disabled
tlhax disabled
tellh disabled
tllqv disabled
tlllh disabled
tlhll disabled
tllkh disabled
tkhlh disabled
tkhtl disabled
twc disabled
tas 0 ns
tah 0 ns
tds 0 ns
tdh 0 ns
toes disabled
toeh disabled
toehp disabled
tghwl 0 ns
tghel 0 ns
tghll disabled
twhgl 0 ns
tlleh disabled
tcs 0 ns
tch 0 ns
twp disabled
twph disabled
tcp 55 ns
tcph 25 ns
tws disabled
twh disabled
tpxwh disabled
tqvpx disabled
twhwh1 disabled
twhwh1b disabled
tpwhwh1 disabled
tpwhwh1b disabled
twhwh2 disabled
twhwh3 disabled
teoe disabled
tseto disabled
tsusp disabled
tpsusp disabled
tbusy disabled
trl disabled
tready disabled
treadyr disabled
trh disabled
telfl disabled
telfh disabled
tflqz disabled
tfhqv disabled
tprotver disabled
tunprotver disabled
tspw disabled
trp 0 ns
tpcp 0 ns
tpas 0 ns
tpah 0 ns

