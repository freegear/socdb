setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref svfUseTime:FALSE
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "LCD_36" -path "E:\RTL_COMPLETE\SOURCE_PROJECT\TFT_LCD\LCM_TEST\"
addCollection -name "LCD_36"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setMode -acecf
setCurrentDesign -version 0
setCurrentCollection -collection "LCD_36"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "LCD_36"
setAttribute -configdevice -attr size -value "128000000"
setMode -acecf
addConfigDevice -size 128000000 -name "XCACECF" -path "E:\RTL_COMPLETE\SOURCE_PROJECT\TFT_LCD\LCM_TEST\/LCD_36"
addCollection -name "LCD_36"
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
addDevice -p 2 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/TFT_LCD/LCM_TEST/lcm_test.bit"
setAttribute -configdevice -attr path -value "E:\RTL_COMPLETE\SOURCE_PROJECT\TFT_LCD\LCM_TEST\/"
generate -active LCD_36
saveProjectFile -file "E:/RTL_COMPLETE/SOURCE_PROJECT/TFT_LCD/LCM_TEST/LCM_TEST.ipf"
