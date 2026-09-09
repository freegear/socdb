setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref svfUseTime:FALSE
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "TEST" -path "D:\LCM\LED_TEST\"
addCollection -name "TEST"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setMode -acecf
setCurrentDesign -version 0
setCurrentCollection -collection "TEST"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "TEST"
setAttribute -configdevice -attr size -value "128000000"
setMode -acecf
addConfigDevice -size 128000000 -name "XCACECF" -path "D:\LCM\LED_TEST\/TEST"
addCollection -name "TEST"
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
addDevice -p 1 -file "D:/LCM/LED_TEST/led_test.bit"
addDevice -p 2 -file "D:/LCM/LCM_TEST/lcm_test.bit"
setAttribute -configdevice -attr path -value "D:\LCM\LED_TEST\/"
generate -active TEST
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
cutDevice -p 1
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
cutDevice -p 1
addDevice -p 1 -file "D:/LCM/LED_TEST/led_test.bit"
addDevice -p 2 -file "D:/LCM/LCM_TEST/lcm_test.bit"
setAttribute -configdevice -attr path -value "D:\LCM\LED_TEST\/"
generate -active TEST
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
cutDevice -p 2
addDevice -p 2 -file "D:/LCM/LCM_TEST/lcm_test.bit"
setAttribute -configdevice -attr path -value "D:\LCM\LED_TEST\/"
generate -active TEST
