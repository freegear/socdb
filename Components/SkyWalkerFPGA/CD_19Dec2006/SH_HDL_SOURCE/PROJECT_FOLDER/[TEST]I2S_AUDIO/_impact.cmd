setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref svfUseTime:FALSE
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "I2S" -path "D:\I2S\I2S\"
addCollection -name "I2S"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setMode -acecf
setCurrentDesign -version 0
setCurrentCollection -collection "I2S"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "I2S"
setAttribute -configdevice -attr size -value "128000000"
setMode -acecf
addConfigDevice -size 128000000 -name "XCACECF" -path "D:\I2S\I2S\/I2S"
addCollection -name "I2S"
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
addDevice -p 1 -file "D:/I2S/I2S/led_test.bit"
addDevice -p 2 -file "D:/I2S/I2S/i2s_test.bit"
setAttribute -configdevice -attr path -value "D:\I2S\I2S\/"
generate -active I2S
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 2 -file "D:/I2S/I2S/i2s_test.bit"
setAttribute -position 2 -attr devicePartName -value "xc4vlx200"
setAttribute -configdevice -attr path -value "D:\I2S\I2S\/"
generate -active I2S
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 2 -file "D:/SH_HDL_SOURCE/PROJECT_FOLDER/P_LCM_TEST/lcm_test.bit"
setAttribute -position 2 -attr devicePartName -value "xc4vlx200"
saveProjectFile -file "D:/I2S/I2S/I2S.ipf"
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setCurrentCollection -collection "I2S"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
deleteDevice -position 1
deleteDevice -position 1
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "I2S"
setAttribute -configdevice -attr size -value "0"
setMode -acecf
setMode -acempm
setMode -pff
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "LCM_TEST" -path "D:\I2S\I2S\"
addCollection -name "LCM_TEST"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
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
addConfigDevice -size 128000000 -name "XCACECF" -path "D:\I2S\I2S\/LCM_TEST"
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
addDevice -p 1 -file "D:/I2S/I2S/led_test.bit"
addDevice -p 2 -file "D:/SH_HDL_SOURCE/PROJECT_FOLDER/P_LCM_TEST/lcm_test.bit"
setAttribute -configdevice -attr path -value "D:\I2S\I2S\/"
generate -active LCM_TEST
