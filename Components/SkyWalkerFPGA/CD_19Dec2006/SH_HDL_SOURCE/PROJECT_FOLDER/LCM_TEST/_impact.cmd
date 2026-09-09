setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref svfUseTime:FALSE
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "LCM_TEST" -path "D:\SH_HDL_SOURCE\PROJECT_FOLDER\P_LCM_TEST\"
addCollection -name "LCM_TEST"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setMode -acecf
setCurrentDesign -version 0
setCurrentCollection -collection "LCM_TEST"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "LCM_TEST"
setAttribute -configdevice -attr size -value "128000000"
setMode -acecf
addConfigDevice -size 128000000 -name "XCACECF" -path "D:\SH_HDL_SOURCE\PROJECT_FOLDER\P_LCM_TEST\/LCM_TEST"
addCollection -name "LCM_TEST"
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
addDevice -p 1 -file "D:/SH_HDL_SOURCE/U51_LED_TEST/led_test.bit"
addDevice -p 2 -file "D:/SH_HDL_SOURCE/PROJECT_FOLDER/P_LCM_TEST/lcm_test.bit"
setAttribute -configdevice -attr path -value "D:\SH_HDL_SOURCE\PROJECT_FOLDER\P_LCM_TEST\/"
generate -active LCM_TEST
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 2 -file "D:/SH_HDL_SOURCE/PROJECT_FOLDER/P_LCM_TEST/lcm_test.bit"
setAttribute -position 2 -attr devicePartName -value "xc4vlx200"
setAttribute -configdevice -attr path -value "D:\SH_HDL_SOURCE\PROJECT_FOLDER\P_LCM_TEST\/"
generate -active LCM_TEST
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 2 -file "D:/SH_HDL_SOURCE/PROJECT_FOLDER/P_LCM_TEST/lcm_test.bit"
setAttribute -position 2 -attr devicePartName -value "xc4vlx200"
setAttribute -configdevice -attr path -value "D:\SH_HDL_SOURCE\PROJECT_FOLDER\P_LCM_TEST\/"
generate -active LCM_TEST
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 2 -file "D:/SH_HDL_SOURCE/PROJECT_FOLDER/P_LCM_TEST/lcm_test.bit"
setAttribute -position 2 -attr devicePartName -value "xc4vlx200"
setAttribute -configdevice -attr path -value "D:\SH_HDL_SOURCE\PROJECT_FOLDER\P_LCM_TEST\/"
generate -active LCM_TEST
