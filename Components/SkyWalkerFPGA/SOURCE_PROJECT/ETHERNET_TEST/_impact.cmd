setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref svfUseTime:FALSE
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "ETH_TEST" -path "E:\ENCODER\ETHERNET_TEST\"
addCollection -name "ETH_TEST"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setMode -acecf
setCurrentDesign -version 0
setCurrentCollection -collection "ETH_TEST"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "ETH_TEST"
setAttribute -configdevice -attr size -value "128000000"
setMode -acecf
addConfigDevice -size 128000000 -name "XCACECF" -path "E:\ENCODER\ETHERNET_TEST\/ETH_TEST"
addCollection -name "ETH_TEST"
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
addDevice -p 1 -file "D:/Xilinx/virtex4/data/xc4vlx200_ff1513.bsd"
addDevice -p 2 -file "E:/ENCODER/ETHERNET_TEST/ethernet.bit"
setAttribute -configdevice -attr path -value "E:\ENCODER\ETHERNET_TEST\/"
generate -active ETH_TEST
setAttribute -configdevice -attr path -value "E:\ENCODER\ETHERNET_TEST\/"
generate -active ETH_TEST
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
saveProjectFile -file "E:/ENCODER/ETHERNET_TEST/ETHERNET_TEST.ipf"
