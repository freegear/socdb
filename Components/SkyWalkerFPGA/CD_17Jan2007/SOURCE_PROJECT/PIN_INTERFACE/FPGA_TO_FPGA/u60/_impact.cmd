setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref svfUseTime:FALSE
loadProjectFile -file "E:/RTL_COMPLETE/SOURCE_PROJECT/PIN_INTERFACE/FPGA_TO_FPGA/u60/u60.ipf"
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acempm
setMode -pff
setMode -acecf
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
setCurrentCollection -collection "INT_TEST"
setCurrentDesign -version 0
setMode -acecf
setCurrentDeviceChain -index 0
setCurrentCollection -collection "INT_TEST"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setAttribute -configdevice -attr path -value "E:\RTL_COMPLETE\SOURCE_PROJECT\PIN_INTERFACE\FPGA_TO_FPGA\u60\/"
generate -active INT_TEST
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 2 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/PIN_INTERFACE/FPGA_TO_FPGA/u60/u60.bit"
setAttribute -position 2 -attr devicePartName -value "xc4vlx200"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 1 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/PIN_INTERFACE/FPGA_TO_FPGA/U51/u51.bit"
setAttribute -position 1 -attr devicePartName -value "xc4vlx200"
setAttribute -configdevice -attr path -value "E:\RTL_COMPLETE\SOURCE_PROJECT\PIN_INTERFACE\FPGA_TO_FPGA\u60\/"
generate -active INT_TEST
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 2 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/PIN_INTERFACE/FPGA_TO_FPGA/u60/u60.bit"
setAttribute -position 2 -attr devicePartName -value "xc4vlx200"
saveProjectFile -file "E:/RTL_COMPLETE/SOURCE_PROJECT/PIN_INTERFACE/FPGA_TO_FPGA/u60/u60.ipf"
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setCurrentCollection -collection "INT_TEST"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
deleteDevice -position 1
deleteDevice -position 1
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "INT_TEST"
setAttribute -configdevice -attr size -value "0"
setMode -acecf
setMode -acempm
setMode -pff
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "PIN_CON" -path "E:\RTL_COMPLETE\SOURCE_PROJECT\PIN_INTERFACE\FPGA_TO_FPGA\u60\"
addCollection -name "PIN_CON"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setCurrentDesign -version 0
setCurrentCollection -collection "PIN_CON"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "PIN_CON"
setAttribute -configdevice -attr size -value "128000000"
setMode -acecf
addConfigDevice -size 128000000 -name "XCACECF" -path "E:\RTL_COMPLETE\SOURCE_PROJECT\PIN_INTERFACE\FPGA_TO_FPGA\u60\/PIN_CON"
addCollection -name "PIN_CON"
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
addDevice -p 1 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/PIN_INTERFACE/FPGA_TO_FPGA/U51/u51.bit"
addDevice -p 2 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/PIN_INTERFACE/FPGA_TO_FPGA/u60/u60.bit"
setAttribute -configdevice -attr path -value "E:\RTL_COMPLETE\SOURCE_PROJECT\PIN_INTERFACE\FPGA_TO_FPGA\u60\/"
generate -active PIN_CON
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 2 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/PIN_INTERFACE/FPGA_TO_FPGA/u60/u60.bit"
setAttribute -position 2 -attr devicePartName -value "xc4vlx200"
setAttribute -configdevice -attr path -value "E:\RTL_COMPLETE\SOURCE_PROJECT\PIN_INTERFACE\FPGA_TO_FPGA\u60\/"
generate -active PIN_CON
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 1 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/PIN_INTERFACE/FPGA_TO_FPGA/U51/u51.bit"
setAttribute -position 1 -attr devicePartName -value "xc4vlx200"
setAttribute -configdevice -attr path -value "E:\RTL_COMPLETE\SOURCE_PROJECT\PIN_INTERFACE\FPGA_TO_FPGA\u60\/"
generate -active PIN_CON
saveProjectFile -file "E:\RTL_COMPLETE\SOURCE_PROJECT\PIN_INTERFACE\FPGA_TO_FPGA\u60\default.ipf"
