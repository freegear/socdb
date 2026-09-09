setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref svfUseTime:FALSE
loadProjectFile -file "D:/aaa/U51/U51.ipf"
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
setCurrentCollection -collection "TEST"
setCurrentDesign -version 0
setMode -acecf
setCurrentDeviceChain -index 0
setCurrentCollection -collection "TEST"
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
saveProjectFile -file "D:/aaa/U51/U51.ipf"
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setCurrentCollection -collection "TEST"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
deleteDevice -position 1
deleteDevice -position 1
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "TEST"
setAttribute -configdevice -attr size -value "0"
setMode -acecf
setMode -acempm
setMode -pff
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "FPGATEST" -path "D:/aaa/FPGA/"
addCollection -name "FPGATEST"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setCurrentDesign -version 0
setCurrentCollection -collection "FPGATEST"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "FPGATEST"
setAttribute -configdevice -attr size -value "128000000"
setMode -acecf
addConfigDevice -size 128000000 -name "XCACECF" -path "D:/aaa/FPGA/FPGATEST"
addCollection -name "FPGATEST"
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
addDevice -p 1 -file "D:/aaa/U51/u51.bit"
addDevice -p 2 -file "D:/aaa/u60/u60.bit"
setAttribute -configdevice -attr path -value "D:/aaa/FPGA/"
generate -active FPGATEST
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
cutDevice -p 1
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
cutDevice -p 1
addDevice -p 1 -file "D:/aaa/U51/u51.bit"
addDevice -p 2 -file "D:/aaa/u60/u60.bit"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setAttribute -configdevice -attr path -value "D:/aaa/FPGA/"
generate -active FPGATEST
