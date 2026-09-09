setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref svfUseTime:FALSE
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "Untitled" -path "D:\ADV\A\adc\"
addCollection -name "Untitled"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setMode -acecf
setCurrentDesign -version 0
setCurrentCollection -collection "Untitled"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "Untitled"
setAttribute -configdevice -attr size -value "128000000"
setMode -acecf
addConfigDevice -size 128000000 -name "XCACECF" -path "D:\ADV\A\adc\/Untitled"
addCollection -name "Untitled"
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
addDevice -p 2 -file "D:/ADV/A/adc/adc0.bit"
setAttribute -configdevice -attr path -value "D:\ADV\A\adc\/"
generate -active Untitled
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
cutDevice -p 2
addDevice -p 2 -file "D:/ADV/A/adc/adc0.bit"
setAttribute -configdevice -attr path -value "D:\ADV\A\adc\/"
generate -active Untitled
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
cutDevice -p 2
addDevice -p 2 -file "D:/ADV/A/adc/adc0.bit"
setAttribute -configdevice -attr path -value "D:\ADV\A\adc\/"
generate -active Untitled
saveProjectFile -file "D:/ADV/A/adc/adc.ipf"
