setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref svfUseTime:FALSE
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "EXP_CNT" -path "E:\ENCODER\EXP_SOCKET\"
addCollection -name "EXP_CNT"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setMode -acecf
setCurrentDesign -version 0
setCurrentCollection -collection "EXP_CNT"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "EXP_CNT"
setAttribute -configdevice -attr size -value "128000000"
setMode -acecf
addConfigDevice -size 128000000 -name "XCACECF" -path "E:\ENCODER\EXP_SOCKET\/EXP_CNT"
addCollection -name "EXP_CNT"
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
addDevice -p 1 -file "E:/SH_HDL_SOURCE/PROJECT_FOLDER/[NONE]U51_LED_TEST/led_test.bit"
addDevice -p 2 -file "E:/ENCODER/EXP_SOCKET/exp_socket.bit"
setAttribute -configdevice -attr path -value "E:\ENCODER\EXP_SOCKET\/"
generate -active EXP_CNT
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 2 -file "E:/ENCODER/EXP_SOCKET/exp_socket.bit"
setAttribute -position 2 -attr devicePartName -value "xc4vlx200"
setAttribute -configdevice -attr path -value "E:\ENCODER\EXP_SOCKET\/"
generate -active EXP_CNT
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 1 -file "E:/ENCODER/EXP_SOCKET/exp_socket.bit"
setAttribute -position 1 -attr devicePartName -value "xc4vlx200"
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
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 2 -file "D:/Xilinx/virtex4/data/xc4vlx200_ff1513.bsd"
setAttribute -position 2 -attr devicePartName -value "xc4vlx200"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
cutDevice -p 2
addDevice -p 2 -file "D:/Xilinx/virtex4/data/xc4vlx200_ff1513.bsd"
setAttribute -configdevice -attr path -value "E:\ENCODER\EXP_SOCKET\/"
generate -active EXP_CNT
saveProjectFile -file "E:/ENCODER/EXP_SOCKET/EXP_SOCKET.ipf"
sion 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 1 -file "E:/ENCODER/EXP_SOCKET/exp_socket.bit"
setAttribute -position 1 -attr devicePartName -value "xc4vlx200"
setAttribute -configdevice -attr path -value "E:/ENCODER/EXP_SOCKET/"
generate -active EXP_CNT
saveProjectFile -file "E:\ENCODER\ENCODER\default.ipf"
