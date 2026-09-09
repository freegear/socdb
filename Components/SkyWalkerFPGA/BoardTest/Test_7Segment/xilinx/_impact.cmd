setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref svfUseTime:FALSE
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "SevenSeg" -path "D:\projects\FPGABoard_Test\Test_7Segment\xilinx\"
addCollection -name "SevenSeg"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setMode -acecf
setCurrentDesign -version 0
setCurrentCollection -collection "SevenSeg"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "SevenSeg"
setAttribute -configdevice -attr size -value "128000000"
setMode -acecf
addConfigDevice -size 128000000 -name "XCACECF" -path "D:\projects\FPGABoard_Test\Test_7Segment\xilinx\/SevenSeg"
addCollection -name "SevenSeg"
setMode -acecf
setAttribute -configdevice -attr size -value "generaic"
setAttribute -configdevice -attr reserveSize -value "0"
setAttribute -configdevice -attr name -value "XCCACE-AUTO"
addDesign -version 0 -name "rev0"
setMode -acecf
addDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
addDevice -p 1 -file "C:/Xilinx/virtex4/data/xc4vlx200_ff1513.bsd"
addDevice -p 2 -file "D:/projects/FPGABoard_Test/Test_7Segment/xilinx/fpgatop.bit"
setAttribute -configdevice -attr path -value "D:\projects\FPGABoard_Test\Test_7Segment\xilinx\/"
generate -active SevenSeg
saveProjectFile -file "D:/projects/FPGABoard_Test/Test_7Segment/xilinx/SevenSegment.ipf"
