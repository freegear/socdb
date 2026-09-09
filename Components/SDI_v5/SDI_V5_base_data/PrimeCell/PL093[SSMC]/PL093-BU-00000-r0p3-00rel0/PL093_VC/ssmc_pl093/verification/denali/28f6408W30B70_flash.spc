--
--=====================================================================
--   Copyright (c) 2000 by Denali Software, Inc.  All rights reserved
--=====================================================================
--
--This file contains proprietary information of Denali Software, Inc.
--SOMA(tm) is Denali Software's proprietary language for defining
--memory models.
--
--Subject to your agreement with the restrictions set forth below,
--Denali Software, Inc., grants you a non-exclusive license to use
--the SOMA language in the following manner :
--
--You may:
--
--  *  Use SOMA language to create memory models.
--
--  *  Distribute memory models created using the SOMA language to
--     others provided that this notice is not removed from the file.
--
--You may not:
--
--  *  Create software programs or tools that use the SOMA language
--     as either input or output where the software programs are
--     intended for distribution to others.
--
--  *  Change the SOMA language in any manner.
--
--By using the SOMA specification files, you are consenting to be
--bound by and are becoming party to this agreement.  If you do not
--agree to all of the terms of this agreement, you may not use the
--SOMA specification files.
--
--If you have any questions regarding this agreement, or if you
--would like to inquire about obtaining additional or different rights
--in the SOMA specification files and SOMA language, please contact
--Denali Software.
--************************************************************************
-- Manufacturer    : INTEL
-- Memory Class    : FLASH 
-- Part Name       : 28f6408W30B70
-- Revision        : 05/07/2001
-- Description     : Wireless Flash Memory with SRAM, Bottom Boot
-- Datasheet URL   : ftp://download.intel.com/design/flcomp/datashts/29070202.pdf 
-- Datasheet Info  : March 2001 
-- Author Name     : Denali Software,ist 
-- Author Comment  :
--************************************************************************
Version 0.001
flash

Manufacturer intel
Sizes
manufacturerCode 137
deviceCode 0x8855
sectorSizes "8x4kw, Nx32kw"
bankCount 16
bankStarts "0x000000, 0x40000, 0x80000, 0xc0000, 0x100000, 0x140000, 0x180000, 0x1c0000, 0x200000, 0x240000, 0x280000, 0x2c0000, 0x300000, 0x340000, 0x380000, 0x3c0000"
pageWords 4
burstStartMSB 13
burstStartLSB 11
burstStartLatencyMap "2=>2,3=>3,4=>4"
burstLengthMSB 2
burstLengthMap "1=>4,2=>8,7=>-1"
readCfgRgFirstDataInput 0x60
synchReadSectors ""
pageWriteBuffers 1
pageWriteWords 8
pageWriteMinWords 1
protectedSectors "0-134"
cfiVendorSpecific "0x89885500000000000000000000000000"
cfiVendorID 0x0003
cfiExtTableAddr 0x0039
cfiExtQueryMajorV 0x30
cfiExtQueryMinorV 0x31
cfiExtQueryData "0"
cfiAltVendorID 0
cfiAltExtTableAddr 0
cfiAltExtQueryMajorV 0
cfiAltExtQueryMinorV 0
cfiAltExtQueryData "0"
cfiVccMin 0x0017
cfiVccMax 0x0019
cfiVppMin 0x00B4
cfiVppMax 0x00C6
cfiTypTimeoutWrite 0x0004
cfiTypTimeoutMaxWrite 0
cfiTypTimeoutSectorErase 0x000a
cfiTypTimeoutChipErase 0
cfiMaxTimeoutWrite 0x0004
cfiMaxTimeoutMaxWrite 0
cfiMaxTimeoutSectorErase 0x0003
cfiMaxTimeoutChipErase 0
cfiDeviceSize 0x0018
cfiDeviceInterfaceID 0x0001
cfiMaxBytesWrite 0
otpFactoryBaseAddress 0x0081
otpFactorySize 4
otpUserBaseAddress 0x0085
otpUserSize 4
otpLockByteAddress 0x0080
otpByteSelectBit 0
otpAddrMSB 0
otpAddrLSB 0
paramBlockCount 8

Features
configureSTS 0
bootSectored 1
topBoot 0
allowSimultaneousWrite 0
pageModeReads 1
burstModeReads 1
readConfigureCmd 1
delayAtPageBoundary 1
linearBurstOrderActiveLow 0
synchReadDeviceID 0
synchReadStatus 0
burstCrossBank 1
addressLatchPin 1
readyBusyPin 0
resetPin 1
powerSavePin 0
powerSaveCmd 0
selectByteWord 0
a0IsByteSelect 0
canAddSectors 0
singleWrites 1
pageModeWrites 0
noChipErase 1
eraseSuspendResume 1
eraseSuspendProgram 1
programSuspendResume 1
sectorProtection 1
writeProtectPin 1
writeProtectCmds 1
protectOnly 0
protectAllAvail 0
protectBurst 0
hasCfi 1
oneTimeProtect 1
otpFactoryArea 1
otpUserArea 1
otpUserPrevProtected 0
otpWithCmd 0
otpAddrBusRange 0
additionalChipEnablePins 0
programControlVoltagePin 1
setPermanentLockBitComm 0

Pins
address a 22
data dq 16
cebar cebar 1
oebar oebar 1
webar webar 1
wpbar wpbar 1
rybybar rybybar 0
reset resetbar 1
bytebar bytebar 0
clk clk 1
advbar advbar 1
waitbar waitbar 1
ps ps 0
cebar1 cebar1 1
cebar2 cebar2 1
vpp vpp 1

Timing
trc 70 ns
tprc 25 ns
taa 70 ns
tpacc 25 ns
tce 70 ns
toe 30 ns
tehqz 40 ns
tghqz 25 ns
toh 0 ns
tiacc 20 ns
tbacc 20 ns
tkhkh 25 ns
tkhkl 9.5 ns
tklkh 9.5 ns
tkhqx 5 ns
tavkh 9 ns
tkhax 10 ns
telkh 9 ns
tavlh 10 ns
tlhax 9 ns
tellh 10 ns
tllqv 70 ns
tlllh 10 ns
tlhll 10 ns
tllkh 10 ns
tkhlh disabled
tkhtl 20 ns
twc disabled
tas 45 ns
tah 0 ns
tds 45 ns
tdh 0 ns
toes disabled
toeh disabled
toehp disabled
tghwl disabled
tghel disabled
tghll disabled
twhgl 0 ns
tlleh 0 ns
tcs 0 ns
tch 0 ns
twp 45 ns
twph 25 ns
tcp 45 ns
tcph 25 ns
tws 0 ns
twh 0 ns
tpxwh 200 ns
tqvpx 0 ns
twhwh1 12 us
twhwh1b disabled
tpwhwh1 disabled
tpwhwh1b disabled
twhwh2 .7 s
twhwh3 disabled
teoe disabled
tseto disabled
tsusp 9 us
tpsusp 5 us
tbusy disabled
trl disabled
tready disabled
treadyr disabled
trh 100 ns
telfl disabled
telfh disabled
tflqz disabled
tfhqv disabled
tspw disabled
twhwh2b .3 s
twhwh4 disabled
twhwh5 disabled
trp disabled
teltl 20 ns
tehtz 25 ns

